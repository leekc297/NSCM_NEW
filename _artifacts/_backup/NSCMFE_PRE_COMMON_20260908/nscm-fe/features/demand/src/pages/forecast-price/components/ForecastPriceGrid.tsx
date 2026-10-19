import type { GridPanel } from '@mescius/wijmo.grid';
import {
  type FlexGrid,
  AllowMerging,
  CellRange,
  CellType,
  DataMap,
  SelectionMode,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import type { ComboResponse, FlexGridColumnConfig } from '@foundation/models';
import {
  CustomMergeManager,
  EditTracker,
  keepRowVisibleUnderFilter,
  paintNegativeText,
  toGridNumber,
} from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  AUTH_MEASURES,
  CELL_MODAL_KEY,
  GRID_EDIT_COMBO,
  MENU_ID,
  MSG,
  PRICE_MEASURES,
} from '../forecast-price.constants';
import type { ForecastPriceRow, SpreadTitleRow } from '../forecast-price.types';
import { useForecastPriceStore } from '../useForecastPriceStore';
import { isAsFromSiteEditable } from '../utils/forecast-price.asFromSite';
import { q } from '../utils/forecast-price.combo';
import { isPastPeriodLocked, thisWeekMondayYmd } from '../utils/forecast-price.editLock';
import {
  AS_MEASURE,
  isAsMeasureAllowed,
  isMeasureEditableByAuth,
  isWsFcstTypeEditCombo,
  isWsOnlyFcstType,
} from '../utils/forecast-price.wsAuth';

dayjs.extend(isoWeek);

/** 동적 컬럼 헤더 머지 키 — dynamicColumns 의 그룹 구성(ym / sub)과 **동일 규칙**. */
interface HeaderKey {
  ym: string; // 1단 = 년월 (binding[2..8])
  sub: string; // 2단 = 주차 그룹 (SPREAD_TITLE small, M_ 는 'SUM')
}

// ⭐ 동적 헤더 머지 — mkt-fcst `HierarchicalMergeManager` 규약 이식 (정본).
//   [문제] 공용 `CustomMergeManager._getColumnHeaderMergedRange` 는 **셀 라벨이 같으면** 붙인다.
//     동적 leaf 헤더는 W_·M_ 모두 리터럴 'SUM' 이라(dynamicColumns header 참조, mkt-fcst L492 동일)
//     leaf 행의 SUM 들이 **가로로 한 덩어리**가 되고, M_ 는 세로 가드(_isSameHorizontalRange) 실패로
//     'SUM' 이 두 줄로 쌓인다.
//   [해결] 라벨이 아니라 **binding 파생 키**로 머지 (mkt-fcst 와 동일한 접근).
//   ⚠️ 회귀 방지 — 2026-07-22 사고: TopLeft 를 전 범위 머지했다가 헤더 더블클릭 드릴다운이 죽었다.
//     ⇒ **ColumnHeader 만** 재정의하고 TopLeft·Cell 은 super(기존 CustomMergeManager) 그대로 위임한다.
//     드릴다운은 `hitTest` 의 ColumnHeader 좌표에 의존하는데, 2단 머지 원점이 W_ 컬럼으로 유지되므로
//     (dynamicColumns 가 그룹 내 kindRank M<W<D 순 정렬 → W_ 가 D_ 보다 앞) 기존 동작과 동일하다.
class FcstHeaderMergeManager extends CustomMergeManager<ForecastPriceRow> {
  constructor(
    grid: FlexGrid<ForecastPriceRow>,
    private readonly getKeys: () => Map<string, HeaderKey>
  ) {
    super(grid);
  }

  // ⭐ [2026-08-20 사용자 리포트·같은 날 전 컬럼 확장 지시] 빈 셀도 그룹 병합 허용 (이 화면 전 컬럼).
  //   공용 CustomMergeManager 의 빈 셀 병합 금지 가드(2026-08-14 신설)가 값이 비어 있는
  //   SENDER_NAME 등 attribute 컬럼을 행마다 갈라 놓았다(같은 키 조합의 measure 분할 행인데
  //   개별 입력칸처럼 보임). 머지키가 좌측 전 컬럼 누적이라 허용해도 같은 키 조합 블록 안에서만
  //   병합되고, Insert 행(CRUD_TYPE='I') 제외는 공용 가드가 계속 담당한다(DMF0003 No.57 회귀 0).
  //   동적 주차/월 컬럼은 allowMerging:false 라 공용 가드(_getCellMergedRange 첫 줄)가 먼저 거른다.
  protected override allowEmptyCellMerge(panel: GridPanel): boolean {
    return panel.cellType === CellType.Cell;
  }

  getMergedRange(panel: GridPanel, r: number, c: number): CellRange | null {
    // TopLeft / Cell = 기존 동작 유지 (회귀 0)
    if (panel.cellType !== CellType.ColumnHeader) return super.getMergedRange(panel, r, c);

    const keys = this.getKeys();
    const bindingAt = (i: number): string => panel.columns[i]?.binding ?? '';
    const b = bindingAt(c);
    // 정적 컬럼 등 동적 대상이 아니면 기존 값기반 머지 유지 (헤더 세로 span 보존)
    if (!keys.has(b)) return super.getMergedRange(panel, r, c);

    const leafRow = panel.rows.length - 1;

    // M_(월 SUM) — 1단 아래 전 행 세로 병합. 2·3단 라벨이 모두 'SUM' 이라 한 칸으로 보여야 한다.
    if (b.startsWith('M_') && r >= 1) {
      return leafRow <= 1 ? null : new CellRange(1, c, leafRow, c);
    }
    // leaf 행('SUM' / 일자) — 가로 병합 금지 (라벨 동일로 인한 오병합 차단)
    if (r === leafRow) return null;

    const keyOf = (i: number): string => {
      const k = keys.get(bindingAt(i));
      if (!k) return '\0';
      return r === 0 ? k.ym : `${k.ym}|${k.sub}`;
    };
    const key = keyOf(c);
    let c1 = c;
    let c2 = c;
    while (c1 > 0 && keyOf(c1 - 1) === key) c1--;
    while (c2 < panel.columns.length - 1 && keyOf(c2 + 1) === key) c2++;
    return c1 === c2 ? null : new CellRange(r, c1, r, c2);
  }
}
// (구 #10 실시간 중복체크 키 8종 상수는 2026-08-11 제거 — 통합테스트 No.38 "저장 시점 검증" 요구.
//  저장 시점 중복 판정은 ForecastPrice.handleSave + forecast-price.validate.ts 가 담당.)

import {
  allocateLoc,
  bucketBitsOfDay,
  divideByDate,
  divideByMonth,
  divideByWeek,
  isInsertRow,
  isNonEditableCell,
  toNumber,
  type CalendarInfo,
} from './ForecastPriceGridUtils';

/** MEASURE 컬럼 dataMap — 행별 후보 필터 설치 여부 표식. */
type MeasureCandidateDataMap = DataMap & { rowScopedCandidates?: boolean };

/** FCST Type 컬럼 dataMap — W/S 2종 제거 필터 설치 여부 표식. */
type FcstTypeCandidateDataMap = DataMap & { wsFilteredCandidates?: boolean };

interface ForecastPriceGridProps {
  gridRef: MutableRefObject<FlexGrid<ForecastPriceRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ForecastPriceRow[];
  spreadTitle: SpreadTitleRow[];
  editTrackerRef: MutableRefObject<EditTracker | null>;
  // #10 — Insert 행 키 중복(MSG00260) 발생 시 페이지 alert 호출.
  /**
   * [No.65 2026-08-14] FPModal 셀 더블클릭 → 페이지가 검색 모달을 연다 (DMF0003 `onPopupCellDblClick` 1:1).
   * 대상 = `CELL_MODAL_KEY` 에 등록된 binding × 메타 `FPModal`+`IM` × 신규행(CRUD_TYPE='I').
   */
  onPopupCellDblClick?: (modalKey: string, row: WijmoRowItem) => void;
}

interface DynColMeta {
  binding: string;
  kind: 'M' | 'W' | 'D';
  large: string; // 1단 = 년월 (LARGE_CLASS_LABEL_NAME)
  small: string; // 2단 = 주차 (SMALL_CLASS_LABEL_NAME)
  leaf: string; // 3단 = 일자 (COLUMN_LABEL_NAME)
  sort: number;
}

/** 콤보 행의 임의 컬럼을 안전하게 문자열화 (원시값만 채택 — 객체는 빈 문자열로 관대 통과). */
const comboCellStr = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

const kindOf = (b: string): 'M' | 'W' | 'D' | null =>
  /^M_\d{6}$/.test(b) ? 'M' : /^W_\d{7,10}$/.test(b) ? 'W' : /^D_\d{8}$/.test(b) ? 'D' : null;

// 표시 rank (M=0 상위 합계 … D=2 하위 상세). 활성 bucket = 데이터에 존재하는 최정밀 kind(max rank).
//   상위(rank<활성) = SUM 합계 컬럼 → chkSum(sumYn) 으로 표시 토글 (AS-IS chkSum / mkt-fcst 패턴 #92).
const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

// 실적/계획 경계 초록 세로선 (사용자 요구 2026-07-29 — AS-IS 캡처 "실적구간 표기 초록선").
//   AS-IS 는 실적구간(과거·회색)이 끝나고 계획구간이 시작되는 지점에 세로선 하나를 긋는다.
//   선은 "당기 컬럼의 왼쪽 경계"에 그려지며 화면 전체에서 단 하나만 존재한다.
//
//   어느 컬럼이 그 당기 컬럼인가 — 근거 2건이 서로를 보완한다:
//     ① 요청서: "(Monthly Bucket 조회 후 컬럼을 더블클릭하여 Weekly Bucket 으로 펼쳤을때)
//        SUM 컬럼에는 표기 안되도록" → M_ SUM 이 보여도 W_ 당주가 펼쳐져 있으면 W_ 가 가져간다.
//     ② AS-IS 캡처: 당주(W31)를 일자로 펼친 상태에서도 선은 여전히 W31 SUM 컬럼 왼쪽에 있다
//        → 일자(D_)까지 내려가지는 않는다.
//   합치면 규칙은 "M_ 보다 W_ 우선, 단 D_ 로는 안 내려감".
//   주의: sales-plan(DMF0021) shouldHighlightCurrentPeriod 와 여기서 갈린다 — sales-plan 은 보이는
//     최하위 버킷까지 내려가 D_ 당일로 강조를 옮긴다. DMF0082 는 위 ② 캡처를 따른다.
//   D_ 는 폴백 전용(-1) — Daily 조회 + chkSum OFF 처럼 M_/W_ 당기 컬럼이 하나도 안 보일 때만 쓴다.
const BOUNDARY_PREFERENCE = { M: 0, W: 1, D: -1 } as const;

/**
 * 초록 경계선을 그릴 컬럼 binding 하나를 고른다. 대상이 없으면 null.
 * @param isVisible 드릴다운·chkSum 반영 — 호출 시점의 컬럼 가시성을 조회한다.
 */
const findActualBoundaryBinding = (
  dynBindings: readonly string[],
  currentPeriodBindings: ReadonlySet<string>,
  isVisible: (binding: string) => boolean
): string | null => {
  let best: string | null = null;
  let bestRank = -Infinity;
  let dayFallback: string | null = null;

  for (const binding of dynBindings) {
    if (!currentPeriodBindings.has(binding)) continue;
    const kind = kindOf(binding);
    if (!kind || !isVisible(binding)) continue;

    if (kind === 'D') {
      dayFallback ??= binding;
    } else if (BOUNDARY_PREFERENCE[kind] > bestRank) {
      bestRank = BOUNDARY_PREFERENCE[kind];
      best = binding;
    }
  }
  return best ?? dayFallback;
};

// ⭐ DMF0082 메인 그리드 — AS-IS spdMain(FCST 행 + PRICE 행 병렬 단일 시트) 1:1.
//   동적 시간축 = DMF0082_GET_SPREAD_TITLE (월>주>일 3단, mkt-fcst 패턴 이식) /
//   편집 = 권한 4분기(measureAuth, GET drop3) × 행 EDIT_FLAG × bucket × 기준주차 이전 잠금 /
//   배분 = 월간→주간→일별 자동 (ForecastPriceGridUtils — AS-IS EditChange 분배 로직).
export const ForecastPriceGrid = ({
  gridRef,
  gridFilterRef,
  data,
  spreadTitle,
  editTrackerRef,
  onPopupCellDblClick,
}: ForecastPriceGridProps) => {
  const monthMap = useRef<Map<string, Set<string>>>(new Map());
  const weekMap = useRef<Map<string, Set<string>>>(new Map());
  const bucketRef = useRef<string>('W');

  const searchParams = useForecastPriceStore(state => state.searchParams);
  const staticColumns = useForecastPriceStore(state => state.staticColumns);
  const measureAuth = useForecastPriceStore(state => state.measureAuth);
  const measureAuthRef = useRef(measureAuth);
  measureAuthRef.current = measureAuth;

  // ⭐ [E20260826-AUTHVIEW] 시간창 因 잠금 메저(drop3 'T') — 편집 시도 시 MSG00477 안내 (AS-IS
  //   DMF0003 EditButton L849~856 파리티: SCP Planner 시간창 밖 = 메시지 후 차단).
  //   beginningEdit 는 타이핑으로 연타될 수 있어 2초 억제로 스팸을 막는다.
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();
  const measureTimeGate = useForecastPriceStore(state => state.measureTimeGate);
  const measureTimeGateRef = useRef(measureTimeGate);
  measureTimeGateRef.current = measureTimeGate;
  const lastTimeGateAlertRef = useRef(0);

  // ⭐ 배분 캘린더(drop4, #1) / M+3 기준월(drop1, #4) — 핸들러가 재구독 없이 최신 참조 (measureAuth 패턴).
  const calendar = useForecastPriceStore(state => state.calendar);
  const m3CutoffYyyymm = useForecastPriceStore(state => state.m3CutoffYyyymm);
  const calendarMapRef = useRef<Map<string, CalendarInfo>>(new Map());
  calendarMapRef.current = useMemo(() => new Map(Object.entries(calendar)), [calendar]);
  const m3CutoffRef = useRef(m3CutoffYyyymm);
  m3CutoffRef.current = m3CutoffYyyymm;
  const bucketTypeParam = searchParams.bucketType;
  const bucketTypeParamRef = useRef(bucketTypeParam);
  bucketTypeParamRef.current = bucketTypeParam;

  // ⭐ 기본 배분요일 (AS-IS sDefaultDay — .cs L1773 `Data.Common(Type.DefaultBucketDay, division, bucketType)`).
  //   행 BUCKET 이 비었거나 '0000000' 일 때 적용되는 요일비트의 원천. 마스터 lookup DEFAULT_BUCKET_DAY
  //   (SEGMENT1=division × SEGMENT2=MONTHLY|WEEKLY) 를 CMBO 'DefaultBucketDay' 로 조회한다.
  //   ⚠️ 구 코드는 FE 상수(40=MON/그 외=FRI)로 박아 두어 마스터 변경·division 추가에 반응하지 못했다.
  const [defaultBucketDayRows] = useTabComboQueries({
    filters: [
      {
        comboId: 'DefaultBucketDay',
        divisionId: q(searchParams.divisionId),
        bucketType: q(bucketTypeParam),
      },
    ],
    enabled: !!searchParams.divisionId,
  });
  const defaultBucketRef = useRef<string>(bucketBitsOfDay(undefined));
  defaultBucketRef.current = bucketBitsOfDay(defaultBucketDayRows?.[0]?.CODE);

  // ⭐ 편집 전용 콤보 프리페치 (정본 mkt-fcst MktFcstGrid:280-311 이식) — AS-IS UP_FX 계통의
  //   "조회 표시 ↔ 편집 후보" 이원화. 진입 시 dataMap 스왑 → 종료 시 표시용으로 원복.
  //   0행이면 null 로 두어 **스왑을 생략**한다(미등록/무권한 시 기존 동작 유지 = 회귀 0).
  //   ⭐ [2026-08-21 사용자 지정] **편집 콤보 ID 는 메타에서 해소한다** — `ATTRIBUTE9`(편집 콤보) →
  //     없으면 `CELL_COMBO_DATA_TYPE`(표시 콤보). 화면 상수(GRID_EDIT_COMBO)는 옵션만 갖는다.
  //     소스에만 있던 편집 콤보는 UI CATEGORY SETUP 에서 확인이 안 돼 운영자가 인지할 수 없었다.
  //   ⚠ 둘 다 비면 그 binding 은 **스왑 대상에서 제외**한다(빈 콤보로 덮어써 기존 표시가 깨지는 것 방지).
  const editComboEntries = useMemo(() => {
    const metaOf = new Map(staticColumns.map(c => [c.colNm, c]));
    return Object.entries(GRID_EDIT_COMBO)
      .map(([binding, opts]) => {
        const m = metaOf.get(binding);
        const comboId = m?.attribute9?.trim() || m?.cellCboDataTp?.trim() || '';
        return [binding, { ...opts, comboId }] as const;
      })
      .filter(([, cfg]) => cfg.comboId !== '');
  }, [staticColumns]);
  const editComboResults = useTabComboQueries({
    filters: editComboEntries.map(([, cfg]) =>
      cfg.divisionParam
        ? { comboId: cfg.comboId, divisionId: q(searchParams.divisionId) }
        : cfg.comboId
    ),
  });
  const editComboSig = editComboResults
    .map((r, i) => `${editComboEntries[i]?.[0]}#${r?.length ?? 'x'}`)
    .join(',');
  const editDataMapsRef = useRef<Record<string, DataMap | null>>({});
  const editComboRowsRef = useRef<Record<string, Record<string, unknown>[]>>({});
  useEffect(() => {
    const maps: Record<string, DataMap | null> = {};
    const rows: Record<string, Record<string, unknown>[]> = {};
    editComboEntries.forEach(([binding], i) => {
      const arr = (editComboResults[i] ?? []) as unknown as Record<string, unknown>[];
      rows[binding] = arr;
      maps[binding] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    editDataMapsRef.current = maps;
    editComboRowsRef.current = rows;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [editComboSig]);

  // ⭐ AS 사이트 전용 Incoterms (AS-IS UP_FX_GetCommonDataList_DM @Code='AS_INCOTERMS', .cs L7923) —
  //   행의 SCM_SITE_ID 가 AS(비축)향 사이트면 Incoterms 후보를 AS 전용 목록으로 교체한다.
  //   AS-IS 는 `IF EXISTS(AS_SITE_PLANT …) … ELSE INCOTERMS` 로 분기하므로, TO-BE 도 AS 사이트 판정을
  //   먼저 하고(AS_FROM_SITE) 매칭될 때만 스왑한다(0행이면 생략 → IncotermsEdit 유지). 정본 = mkt-fcst:320-342.
  const [asSiteRows, asIncotermsRows, wsFcstTypeRows, fcstTypeEditRows] = useTabComboQueries({
    filters: [
      { comboId: 'AS_FROM_SITE', param1: q(searchParams.divisionId) },
      { comboId: 'AsIncotermsEdit', divisionId: q(searchParams.divisionId) },
      // [No.63-② 2026-08-11] AS From Site 편집 활성 판정용 FCST Type 기준 목록.
      //   AS-IS `GetLookupValues("FCST_TYPE", "DM Planner (W/S)")` → `UP_FX_GetCommonDataList_DM` L72~79 =
      //   LOOKUP_TYPE 'SALES_TYPE_CODE2'(WS/WSF/AS/ASF 4종). TO-BE 등재본 = `FcstTypeWs`.
      //   ⚠ 현재 사용자 그룹과 무관한 **고정 참조 목록**이다(FcstTypeByUserGroupDMF0082 와 용도가 다름).
      { comboId: 'FcstTypeWs' },
      // ⭐ [41번-② 2026-08-12] FCST Type **편집 후보** — division × W/S 그룹 분기를 서버가 판정한다.
      //   표시용 셀 콤보(FcstTypeByUserGroupDMF0082)는 divisionId 를 못 받으므로 그대로 두고,
      //   division 을 명시 전달하는 편집 전용 등록본을 따로 조회한다
      //   (AsIncotermsEdit / FcstPriceEditMeasure 와 같은 "표시용 ↔ 편집용 이원화" 규약).
      { comboId: 'FcstTypeEditDMF0082', divisionId: q(searchParams.divisionId) },
    ],
    enabled: !!searchParams.divisionId,
  });
  const asSiteNamesRef = useRef<Set<string>>(new Set());
  // AS-IS 는 `dtAsSalesSite.Select("Name = '<SCM_SITE_ID>'")` 로 **NAME 만** 대조한다(.cs L3465·L3565).
  //   실데이터도 원장 SCM_SITE_ID = 'WA00-81-AS' 형태(= 콤보 NAME)이고 CODE('...-W')로는 쓰이지 않는다.
  //   위 `asSiteNamesRef`(NAME∪CODE)는 기존 Incoterms 스왑용이라 그대로 두고, 향 판정만 NAME 전용을 쓴다.
  const asSiteNameOnlyRef = useRef<Set<string>>(new Set());
  // [41번-②] 서버가 division × W/S 그룹으로 걸러 준 FCST Type 편집 후보 표시명.
  //   0건이면(등록본 미배포 등) FE 규칙으로 degrade 한다 — 드롭다운을 비우지 않는다.
  const fcstTypeEditNamesRef = useRef<string[]>([]);
  const asIncotermsMapRef = useRef<DataMap | null>(null);
  const asFromSiteMapRef = useRef<DataMap | null>(null);
  const wsFcstTypeSetRef = useRef<Set<string>>(new Set());
  useEffect(() => {
    const siteRows = (asSiteRows ?? []) as unknown as Record<string, unknown>[];
    asSiteNamesRef.current = new Set(
      siteRows
        .flatMap(r => [comboCellStr(r.NAME).trim(), comboCellStr(r.CODE).trim()])
        .filter(Boolean)
    );
    asSiteNameOnlyRef.current = new Set(
      siteRows.map(r => comboCellStr(r.NAME).trim()).filter(Boolean)
    );
    // AS-IS L2615~2616 `SetCellTypeCombo(AS_FROM_SITE, dtAsFromSite)` — 검출용과 **같은 목록**이 후보다.
    asFromSiteMapRef.current = siteRows.length > 0 ? new DataMap(siteRows, 'CODE', 'NAME') : null;
    const rows = (asIncotermsRows ?? []) as unknown as Record<string, unknown>[];
    asIncotermsMapRef.current = rows.length > 0 ? new DataMap(rows, 'CODE', 'NAME') : null;
    wsFcstTypeSetRef.current = new Set(
      ((wsFcstTypeRows ?? []) as unknown as Record<string, unknown>[])
        .map(r => comboCellStr(r.CODE).trim())
        .filter(Boolean)
    );
    fcstTypeEditNamesRef.current = (
      (fcstTypeEditRows ?? []) as unknown as Record<string, unknown>[]
    )
      .map(r => comboCellStr(r.NAME) || comboCellStr(r.CODE))
      .filter(Boolean);
  }, [asSiteRows, asIncotermsRows, wsFcstTypeRows, fcstTypeEditRows]);

  // ⭐ [No.63-① ② 2026-08-11] AS From Site 편집 활성 판정 — 계약·근거는 `forecast-price.asFromSite.ts`
  //   (AS-IS `DMF0003_MktFcst.cs` [E20260211-001189] 1:1, 단위테스트 10건 동반).
  const asFromSiteEditable = (dataItem: WijmoRowItem): boolean =>
    isAsFromSiteEditable(
      {
        DIVISION_ID: dataItem['DIVISION_ID'],
        SCM_SITE_ID: dataItem['SCM_SITE_ID'],
        FCST_TYPE: dataItem['FCST_TYPE'],
      },
      {
        asSiteNames: asSiteNameOnlyRef.current,
        wsFcstTypes: wsFcstTypeSetRef.current,
        fallbackDivisionId: searchParams.divisionId,
      }
    );

  // 스왑 전 원본(표시용) dataMap 백업 — binding 별 1회만 저장 후 편집 종료 시 원복.
  const origDataMapRef = useRef<Record<string, DataMap | null>>({});

  // 'DM Planner (W/S)' 소속 여부 (CMBO 'MktFcstWsPlannerYn' → store) —
  //   AS_In_Req measure 개방 / FCST Type W/S 후보 자격의 단일 원천. 핸들러는 ref 로 최신값을 본다.
  const wsPlannerYn = useForecastPriceStore(state => state.wsPlannerYn);
  const wsPlannerYnRef = useRef(wsPlannerYn);
  wsPlannerYnRef.current = wsPlannerYn;

  // ⭐ #7 Insert 행 편집가능 Measure 콤보 캐스케이드 (hook #59 §5-G / AS-IS L5839) —
  //   Site 변경 시 FcstPriceEditMeasure(div/site/bucket) 조회해 행별 후보 캐시 → MEASURE 편집 진입 시
  //   컬럼 dataMap 스왑(편집 후보=편집가능 measure), 편집 종료 시 원 dataMap(전체 표시용) 원복.
  const editMeasuresRef = useRef<WeakMap<object, ComboResponse[]>>(new WeakMap());
  // D9 — 행별 Cell Prod Site 후보 캐시 (ITEM_ID 변경 시 재조회).
  const cellProdSitesRef = useRef<WeakMap<object, ComboResponse[]>>(new WeakMap());
  // 행별 Sales Site 후보 캐시 (END_CUSTOMER 변경 시 재조회).
  const salesSitesRef = useRef<WeakMap<object, ComboResponse[]>>(new WeakMap());

  // ⭐ #2 SALES_BUCKET 캐스케이드 (AS-IS L5862~5874) — Insert 행에서 Sales Site / Incoterms 변경 시
  //   배분 요일비트(SUN-first 7자리)를 조회해 행 BUCKET 에 세팅. 결과 없으면 '' → 배분은 기본요일 적용.
  //   (BUCKET 은 divideBy*/allocateLoc 가 다음 수량 편집 때 읽음 — AS-IS 도 세팅만.)
  /**
   * 상위 컬럼 변경으로 **후보 밖이 된 하위 셀 값을 비운다** (사용자 요구 2026-08-22).
   *
   * 증상: End Customer 를 바꾸면 Sales Site **콤보 후보**는 새 고객 것으로 바뀌는데 **값은 그대로** 남아,
   *      셀을 열어보기 전까지 이전 고객의 사이트가 저장 대상으로 남는다.
   * AS-IS 는 `SetCellTypeCombo` 로 후보만 갈아끼우지만, TO-BE 는 "드롭다운에 뜨는 값 = 셀에 남을 수 있는 값"
   * 불변식을 지킨다(공용 `DataGrid.clearStaleComboCells` 와 같은 규칙).
   *
   * ⚠ 공용 처리로는 못 덮는다 — 그쪽은 **컬럼 메타 `ATTRIBUTE2` + 컬럼 단위 콤보맵** 기준인데(DMF0082 는
   *   `ATTRIBUTE2` 정의 0건), 이 화면의 후보는 **행별 서버 재조회 결과(WeakMap)** 라 공용이 볼 수 없다.
   *
   * EditTracker 에도 기록한다 — 안 하면 저장 payload 가 이전 값을 그대로 싣는다.
   */
  const clearIfNotInCandidates = (
    dataItem: WijmoRowItem,
    binding: string,
    rows: ComboResponse[] | undefined
  ): boolean => {
    const current = String(dataItem[binding] ?? '').trim();
    if (current === '') return false;
    // 후보를 못 받았으면(조회 실패 등) 비우지 않는다 — 폴백이 값을 지우는 사고 방지.
    if (!rows || rows.length === 0) return false;
    if (rows.some(r => String(r.CODE ?? '') === current)) return false;
    editTrackerRef.current?.storeChange(dataItem, binding, current, '');
    dataItem[binding] = '';
    gridRef.current?.invalidate();
    return true;
  };

  /**
   * 상위 컬럼이 바뀌면 **그 컬럼을 조회조건으로 쓰는 하위 컬럼 값을 초기화**한다
   * (사용자 요구 2026-08-22: "TEAM 변경시 SALES SITE, MODEL 등 실제 영향을 받는 다른 COLUMN 의
   *  데이터도 초기화 되어야 합니다").
   *
   * 왜 `clearIfNotInCandidates` 로는 부족한가 — 그건 **콤보**(후보 목록이 있는 컬럼) 전용이다.
   * `ITEM_ID`(FPTextModal) · `PROJECT_CODE`(FPModal) 는 후보 목록이 없어 "후보 밖" 판정 자체가 불가하다.
   * 대신 **모달의 조회조건 계약**이 근거가 된다 (AS-IS `spdMain_CellDoubleClick` 실측):
   *
   *   PROJECT_CODE 팝업 ← (division, team, endCustomer, scmSite)          .cs:3737
   *   ITEM_ID      팝업 ← (division, team, endCustomer, scmSite, project) .cs:3804
   *
   * ⇒ 조회조건이 바뀌면 그 조건으로 고른 값은 더 이상 유효하다고 볼 수 없다 → 초기화.
   *   파생 컬럼(모달이 함께 채우던 것)도 같이 비운다 — 남겨두면 코드 없는 명칭만 떠 있게 된다.
   */
  const DEPENDENT_CLEAR_MAP: Record<string, string[]> = {
    // End Customer 가 바뀌면 Project/Model 의 조회조건이 바뀐다
    END_CUSTOMER: ['PROJECT_CODE', 'ITEM_ID'],
    // Sales Site 도 두 모달의 조회조건
    SCM_SITE_ID: ['PROJECT_CODE', 'ITEM_ID'],
    // Project 는 Model 팝업의 조회조건(.cs:3804 6번째 인자)
    PROJECT_CODE: ['ITEM_ID'],
    // Model 이 바뀌면 Cell Prod Site 후보가 바뀐다(콤보 `CELL_PROD_SITE_ID` ← div, item)
    ITEM_ID: ['CELL_PROD_SITE_ID'],
  };
  /** 모달이 함께 채우던 파생 컬럼 — 원본이 비면 같이 비운다 (ForecastPrice.tsx setDerivedCell 짝). */
  const DERIVED_OF: Record<string, string[]> = {
    ITEM_ID: ['ITEM_NAME', 'NICK_NAME'],
    PROJECT_CODE: ['PROJECT_NAME', 'PROJECT_STATUS', 'PROJECT_OWNER'],
  };

  const clearDependentCells = (dataItem: WijmoRowItem, changedBinding: string) => {
    let touched = false;
    const clearOne = (binding: string) => {
      // 그리드에 없는 컬럼(division 별 미표시)은 건드리지 않는다.
      if (!gridRef.current?.columns.getColumn(binding)) return;
      const prev = String(dataItem[binding] ?? '');
      if (prev === '') return;
      editTrackerRef.current?.storeChange(dataItem, binding, prev, '');
      dataItem[binding] = '';
      touched = true;
    };
    // ⭐ **연쇄(재귀)** — 한 단계로 끝내면 안 된다. 예: End Customer 변경 → ITEM_ID 초기화 →
    //   ITEM_ID 를 조회조건으로 쓰는 CELL_PROD_SITE_ID 가 그대로 남는다(2026-08-22 실측).
    //   visited 로 순환·중복 방문을 막는다.
    const visited = new Set<string>([changedBinding]);
    const walk = (from: string) => {
      for (const target of DEPENDENT_CLEAR_MAP[from] ?? []) {
        if (visited.has(target)) continue;
        visited.add(target);
        clearOne(target);
        (DERIVED_OF[target] ?? []).forEach(clearOne);
        walk(target); // 그 컬럼에 종속된 하위까지 계속
      }
    };
    walk(changedBinding);
    if (touched) gridRef.current?.invalidate();
  };

  const applySalesBucket = (dataItem: WijmoRowItem) => {
    const div = String(dataItem['DIVISION_ID'] ?? '');
    const site = String(dataItem['SCM_SITE_ID'] ?? '');
    const inco = String(dataItem['INCOTERMS'] ?? '');
    if (!div || !site || !inco) return; // 세 값 모두 있어야 조회 (AS-IS: div·site 채워졌을 때)
    void apiClient
      .getCombo({
        comboId: 'SalesBucket',
        divisionId: q(div),
        scmSiteId: q(site),
        incoterms: q(inco),
      })
      .then(rows => {
        const bucket = rows?.[0]?.CODE ?? '';
        // '0000000'(매칭 0건 PIVOT) = 미설정 취급 → 기본요일 배분 (AS-IS '' 동작).
        dataItem['BUCKET'] = bucket && bucket !== '0000000' ? bucket : '';
      })
      .catch((err: unknown) => {
        // 폴백은 유지하되 무증상 금지 (hook #117 §5.8) — 실패 시 BUCKET 미세팅 → 기본요일 배분.
        console.error('[combo] SalesBucket 조회 실패 — 기본요일 배분으로 폴백', err);
      });
  };

  // #7 — Insert 행 Site 변경 시 편집가능 Measure 후보 재조회 → 행별 캐시 (MEASURE 편집 진입 시 사용).
  //   [No.63 2026-08-11] 후보 3분기(site 향)는 콤보 SQL 이 AS_SITE_PLANT 룩업으로 판정(서버 권위):
  //   미입력=MKT+AS_In_Req+LOC / 고객향=MKT+LOC / 비축향=AS_In_Req+LOC (통합테스트 1st No.63 매트릭스 1:1).
  const applyEditMeasures = (dataItem: WijmoRowItem, clearStale = false) => {
    const div = String(dataItem['DIVISION_ID'] ?? '');
    const site = String(dataItem['SCM_SITE_ID'] ?? '');
    // ⭐ [2026-08-18 W/S 메저 3분기 정정] Sales Site 미입력도 **정당한 분기**다 — 여기서 return 하면
    //   서버 후보가 영영 안 와서 폴백 목록이 뜨고, 요구(미입력=MKT+AS_In_Req+LOC 3종)가 깨진다.
    if (!div) return;
    // ⚠️ 미입력은 `q('')`(→ 'ALL') 로 보내면 안 된다. 등록 SQL 의 분기 게이트가
    //   `NVL(@scmSiteId,' ') <> ' '` 라, 'ALL' 은 "입력됨"으로 읽혀 AS_SITE_PLANT 미등재 =
    //   고객향으로 취급되고 AS_In_Req 가 제거된다.
    //   사내 실측(2026-08-18): site=' ' → 3종(AS_In_Req·MKT_FCST·LOC) / site='ALL' → 2종(MKT_FCST·LOC).
    void apiClient
      .getCombo({
        comboId: 'FcstPriceEditMeasure',
        divisionId: q(div),
        scmSiteId: `'${site.trim() !== '' ? site.replace(/'/g, '\'\'') : ' '}'`,
        bucketType: q(bucketTypeParamRef.current),
      })
      .then(rows => {
        // [No.63 그룹 축 / 41번] AS_In_Req 는 81 계열·82 + DM Planner(W/S) 에서만 후보로 남긴다.
        //   ⭐ 판정은 셀 개방(canEditCell)과 **같은 함수**를 쓴다 — 후보로 고를 수 있는데 셀이 안 열리는
        //   (또는 그 반대) 어긋남을 원천 차단. 구 코드는 authGroup(ADMIN 우선 단일 그룹) 문자열
        //   비교라 W/S 겸직자가 ADMIN 으로 해석되면 후보에서 빠졌다.
        const out = isAsMeasureAllowed({
          wsPlannerYn: wsPlannerYnRef.current,
          divisionId: div,
        })
          ? (rows ?? [])
          : (rows ?? []).filter(r => String(r.CODE) !== AS_MEASURE);
        editMeasuresRef.current.set(dataItem, out);
        if (clearStale) clearIfNotInCandidates(dataItem, 'MEASURE', out);
        return;
      })
      .catch((err: unknown) => {
        // 폴백은 유지하되 무증상 금지 — 캐시 미설정 → 편집 진입 시 전체 Measure 콤보.
        console.error('[combo] FcstPriceEditMeasure 조회 실패 — 전체 Measure 콤보로 폴백', err);
      });
  };

  // ⭐ Insert 행 End Customer 변경 시 Sales Site 후보 재조회 (AS-IS
  //   `Data.UserSiteByEndCustomer(division, endCustomer, …)` = `UP_FX_GetCommonDataList
  //   @Code='SiteByEndCustomer'`, .cs L2580 InsertRow / L8237·8283·8294 ComboSelChange).
  //   SCM_SITE_ID 는 SAVE IN 파라미터(scmSiteId)라 값이 잘못되면 원장에 그대로 들어간다.
  //   CMBO 는 관대형(@t IS NULL OR …)이라 미전달 시 "전체 사이트"가 뜨는 조용한 폴백이었다.
  const applySalesSites = (dataItem: WijmoRowItem, clearStale = false) => {
    const div = String(dataItem['DIVISION_ID'] ?? '');
    const cust = String(dataItem['END_CUSTOMER'] ?? '');
    if (!div) return;
    void apiClient
      .getCombo({ comboId: 'SiteByEndCustomer', divisionId: q(div), endCustomer: q(cust) })
      .then(rows => {
        salesSitesRef.current.set(dataItem, rows ?? []);
        // 사용자 편집으로 온 호출만 값을 비운다 — Insert 프라이밍(시드 승계)은 건드리지 않는다.
        if (!clearStale) return;
        if (clearIfNotInCandidates(dataItem, 'SCM_SITE_ID', rows)) {
          // Sales Site 가 비면 그에 종속된 Measure 후보·BUCKET 이 낡는다 → 한 단계 더 갱신
          //   (AS-IS ComboSelChange 의 Site 분기와 동일 범위).
          applyEditMeasures(dataItem, true);
          applySalesBucket(dataItem);
        }
      })
      .catch((err: unknown) => {
        console.error('[combo] SiteByEndCustomer 조회 실패 — 전체 목록으로 폴백', err);
      });
  };

  // ⭐ D9 — Insert 행 Model(ITEM_ID) 변경 시 Cell Prod Site 후보 재조회 (AS-IS
  //   `Data.Common(Type.CELL_PROD_SITE_ID, division, itemId)` = `UP_FX_GetCommonDataList @Code='CELL_PROD_SITE_ID'`,
  //   .cs L5854). AS-IS SP 는 PARAM1(division) 유무로 분기해, 이벤트 호출 시 해당 품목의 BIZ_TYPE 이
  //   CELL 이 아니면 '-'(Common) 만 남긴다. CMBO 가 여분 컬럼을 반환하지 않아 클라 필터가 불가 →
  //   Measure 와 동일하게 행별 서버 재조회 + WeakMap 캐시로 처리한다.
  const applyCellProdSites = (dataItem: WijmoRowItem, clearStale = false) => {
    const div = String(dataItem['DIVISION_ID'] ?? '');
    const item = String(dataItem['ITEM_ID'] ?? '');
    if (!div || !item) return;
    void apiClient
      .getCombo({ comboId: 'CELL_PROD_SITE_ID', divisionId: q(div), itemId: q(item) })
      .then(rows => {
        cellProdSitesRef.current.set(dataItem, rows ?? []);
        if (clearStale) clearIfNotInCandidates(dataItem, 'CELL_PROD_SITE_ID', rows);
      })
      .catch((err: unknown) => {
        console.error('[combo] CELL_PROD_SITE_ID 조회 실패 — 전체 목록으로 폴백', err);
      });
  };

  // ⭐ Insert 행 캐스케이드 프라이밍 (AS-IS InsertRow .cs L2621~2630 — 행 생성 시점에
  //   Measure / Cell Prod Site / Sales Site 후보를 **시드 키로 즉시 재조회**한다).
  //   구 코드는 SCM_SITE_ID 를 사용자가 다시 바꿀 때만 조회해, 시드 그대로 저장하는 정상 흐름에서
  //   사이트 특성(VMI_YN) 기반 Measure 필터가 **한 번도 적용되지 않았다**.
  const primedRowsRef = useRef<WeakSet<object>>(new WeakSet());
  useEffect(() => {
    for (const row of data ?? []) {
      const item = row as unknown as WijmoRowItem;
      if (item['CRUD_TYPE'] !== 'I' || primedRowsRef.current.has(item)) continue;
      primedRowsRef.current.add(item);
      applyEditMeasures(item);
      applyCellProdSites(item);
      applySalesSites(item);
    }
  }, [data]);

  // ⭐ VMI_In_Req 개방 판정 입력 (현업 검수 41번 — "Sales Site 가 VMI = Y 인 경우만").
  //   VMI_YN 은 사이트 마스터 조인 결과라 **조회행에만** 실린다. 신규행은 같은 Sales Site 를 쓰는
  //   조회행에서 값을 승계한다(신규행 자체에는 조인 결과가 없다).
  //   vmiProvided = 이번 조회 커서에 VMI_YN 컬럼이 실제로 있었는가 — 관리자가 컬럼 메타에서 내리면
  //   값이 통째로 안 오므로, 그때 잠그면 40·82 VMI 행이 전부 막혀 퇴행한다(판정 보류).
  const vmiBySiteRef = useRef<Map<string, string>>(new Map());
  const vmiProvidedRef = useRef(false);
  useEffect(() => {
    const bySite = new Map<string, string>();
    let provided = false;
    for (const row of data ?? []) {
      const item = row as unknown as WijmoRowItem;
      if (!('VMI_YN' in item)) continue;
      provided = true;
      const site = String(item['SCM_SITE_ID'] ?? '').trim();
      const yn = String(item['VMI_YN'] ?? '').trim();
      if (site && yn && !bySite.has(site)) bySite.set(site, yn);
    }
    vmiBySiteRef.current = bySite;
    vmiProvidedRef.current = provided;
  }, [data]);

  // #12 당주(현재 기간) binding 집합 — 활성 버킷의 당월(M_)/당주(W_)/금주월요일(D_) 녹색 보더.
  const currentPeriodRef = useRef<Set<string>>(new Set());
  currentPeriodRef.current = useMemo(() => {
    const ym = dayjs().format('YYYYMM');
    const wk = String(dayjs().isoWeek()).padStart(2, '0');
    return new Set([`M_${ym}`, `W_${ym}${wk}`, `D_${thisWeekMondayYmd()}`]);
  }, []);

  // 실적/계획 경계 초록 세로선을 그릴 컬럼 (사용자 요구 2026-07-29 — AS-IS "실적구간 표기 초록선").
  //   화면 전체에서 단 하나. 드릴다운·chkSum 으로 컬럼 가시성이 바뀔 때마다 재산출되며(아래 가시성
  //   useEffect), formatItem 은 이 값과 binding 을 비교만 한다 — 셀마다 후보 탐색을 돌리지 않는다.
  const actualBoundaryRef = useRef<string | null>(null);

  // ── 동적 컬럼 메타 (SPREAD_TITLE 우선 / 0건 시 data row 키 union fallback — mkt-fcst 패턴) ──
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const titleRows = (spreadTitle ?? []).filter(r => !!kindOf(String(r.COLUMN_NAME ?? '')));
    if (titleRows.length > 0) {
      return titleRows
        .map<DynColMeta>(r => ({
          binding: String(r.COLUMN_NAME),
          kind: kindOf(String(r.COLUMN_NAME)) as DynColMeta['kind'],
          large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
          small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
          leaf: String(r.COLUMN_LABEL_NAME ?? ''),
          sort: Number(r.SORT_ORDER_NO ?? 0),
        }))
        .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    if (!data || data.length === 0) return [];
    const set = new Set<string>();
    for (const r of data) {
      for (const k of Object.keys(r)) {
        if (kindOf(k)) set.add(k);
      }
    }
    return [...set].sort().map<DynColMeta>(b => ({
      binding: b,
      kind: kindOf(b) as DynColMeta['kind'],
      large: `${b.slice(2, 6)}-${b.slice(6, 8)}`,
      small: '',
      leaf: b.slice(8),
      sort: 0,
    }));
  }, [spreadTitle, data]);

  // ── 활성 bucket / 요약(상위 합계) / 드릴(하위 상세) 분류 (#93 height / #92 sum + 드릴다운, mkt-fcst 패턴) ──
  //   활성 = 조회 bucketType (데이터 최정밀 아님 — Weekly 조회 시 D_ 존재해도 활성=W).
  //   상위(rank<활성) = SUM 합계 → chkSum(sumYn) 토글 / 하위(rank>활성) = 기본 숨김 → 헤더 더블클릭 드릴.
  //   tierH = 3단(D 존재)16 / 2단 24 (총 48px 고정, #93).
  const bucketPrefix = (searchParams.bucketType || 'W').trim().charAt(0).toUpperCase() as
    | 'M'
    | 'W'
    | 'D';
  const { hasDaily, tierH, summaryBindings, drillBindings, dynBindings } = useMemo(() => {
    const daily = dynColMetas.some(m => m.kind === 'D');
    const active = DYN_RANK[bucketPrefix] ?? DYN_RANK.W;
    return {
      hasDaily: daily,
      tierH: daily ? 16 : 24,
      summaryBindings: dynColMetas.filter(m => DYN_RANK[m.kind] < active).map(m => m.binding),
      drillBindings: dynColMetas.filter(m => DYN_RANK[m.kind] > active).map(m => m.binding),
      dynBindings: dynColMetas.map(m => m.binding),
    };
  }, [dynColMetas, bucketPrefix]);
  // 드릴 오버라이드(binding→visible) — bucket/sum/조회 변경 시 리셋 (AS-IS SetSpreadColumn 재실행).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  // ── monthMap(M_→W_ set) / weekMap(W_→D_ set) — 배분 로직 입력 (SPREAD_TITLE 관계 기반) ──
  useEffect(() => {
    const mm = new Map<string, Set<string>>();
    const wm = new Map<string, Set<string>>();
    // 주차 키: 같은 (large, small) 조합의 W_ binding. D_ 는 자신의 (large, small) 주차에 소속.
    const weekBySub = new Map<string, string>(); // `${large}|${small}` → W_ binding
    dynColMetas.forEach(m => {
      if (m.kind === 'W') weekBySub.set(`${m.large}|${m.small}`, m.binding);
    });
    dynColMetas.forEach(m => {
      if (m.kind === 'D') {
        const wk = weekBySub.get(`${m.large}|${m.small}`);
        if (wk) {
          if (!wm.has(wk)) wm.set(wk, new Set());
          wm.get(wk)?.add(m.binding);
        }
      } else if (m.kind === 'W') {
        const month = `M_${m.binding.slice(2, 8)}`;
        if (!mm.has(month)) mm.set(month, new Set());
        mm.get(month)?.add(m.binding);
      }
    });
    monthMap.current = mm;
    weekMap.current = wm;
  }, [dynColMetas]);

  // ── 동적 컬럼 3단 nested (mkt-fcst 패턴 — 년월 → 주차/SUM → 일자. #93 height 명시) ──
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    // ⭐ 헤더 단수 동적 (#93 캐노니컬 + Figma DMF0082 Table 실측 정합):
    //   D_ 존재(Daily 조회) = 3단(년월>주차>일, 각 16px) / D_ 부재(W/M 조회) = 2단(년월>주차, 각 24px
    //   — Figma Table 프레임 실측 24+24=48 과 일치). hasDaily/tierH = 컴포넌트 스코프 파생.
    const largeMap = new Map<
      string,
      { label: string; subs: Map<string, LeafCol[]>; order: number }
    >();
    const kindRank = { M: 0, W: 1, D: 2 } as const;
    dynColMetas.forEach((m, idx) => {
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      const subKey = m.kind === 'M' ? 'SUM' : (m.small || 'SUM').trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)?.push({
        binding: m.binding,
        // 3단 leaf = 일자('06') / 2단 leaf = 주차 라벨('W28') 또는 월 'SUM'
        header: hasDaily ? (m.kind === 'D' ? m.leaf || 'SUM' : 'SUM') : subKey,
        align: 'right',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: tierH,
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    // 주차 정렬 — 월 합계('SUM') 최우선 → 이월 주차('+Wnn') → 주차 번호 오름차순.
    //   SP 가 월/연 경계에서 분할한 주차를 'Wnn+'(앞부분) / '+Wnn'(이어지는 뒷부분) 로 표기한다.
    //   숫자만 뽑아 정렬하면 1월 그룹의 '+W53'(전년 53주차 잔여 = 1/1~1/3)이 53 으로 읽혀
    //   'W01 W02 W03 W04 +W53' 처럼 맨 뒤로 밀린다 (2026-08-03 리포트). '+' 접두 = 이월 주차이므로
    //   번호와 무관하게 그 월 그룹의 첫 주차로 보낸다.
    const subOrder = (k: string): number => {
      if (k === 'SUM') return Number.NEGATIVE_INFINITY;
      const n = Number(k.replace(/\D/g, '') || 0);
      return k.trim().startsWith('+') ? n - 1000 : n;
    };
    const leafKind = (b: string): 'M' | 'W' | 'D' => kindOf(b) ?? 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: tierH,
        allowSorting: false,
        allowMerging: false,
        columns: hasDaily
          ? [...bucket.subs.entries()]
              .sort(([a], [b]) => subOrder(a) - subOrder(b))
              .map(([subLabel, leafCols]) => ({
                header: subLabel,
                align: 'center',
                height: tierH,
                allowSorting: false,
                allowMerging: false,
                columns: leafCols.sort(
                  (a, b) =>
                    kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                    a.binding.localeCompare(b.binding)
                ),
              }))
          : // 2단 — 주차/SUM 컬럼을 직접 leaf 로 (Figma Table 실측 구조)
            [...bucket.subs.entries()]
              .sort(([a], [b]) => subOrder(a) - subOrder(b))
              .flatMap(([, leafCols]) =>
                leafCols.sort((a, b) => a.binding.localeCompare(b.binding))
              ),
      }));
  }, [dynColMetas, hasDaily, tierH]);

  const staticBindingSet = useMemo(() => new Set(staticColumns.map(c => c.colNm)), [staticColumns]);
  // [No.35 2026-08-11] colNm → INPUT_TP_CD (UI Category Setup) — 신규행 입력 컬럼 판정의 단일 원천.
  //   핸들러는 재등록 없이 ref 로 최신 맵을 본다 (measureAuth/calendar 패턴 동일).
  const inputTpRef = useRef<Map<string, string>>(new Map());
  inputTpRef.current = useMemo(
    () => new Map(staticColumns.map(c => [c.colNm, String(c.inputTpCd ?? '')])),
    [staticColumns]
  );

  // ⭐ [No.65 2026-08-14] FPModal 셀 → 모달 키 맵. 메타(FPModal + IM)와 화면 등록(CELL_MODAL_KEY)이
  //   **둘 다** 성립할 때만 담는다 — 메타만 보고 열면 모달이 없는 컬럼에서 빈 팝업이 뜨고,
  //   상수만 보고 열면 관리자가 컬럼을 내린 뒤에도 계속 열린다(hook #130 메타 실소비 규약).
  const modalCellRef = useRef<Map<string, string>>(new Map());
  modalCellRef.current = useMemo(() => {
    const map = new Map<string, string>();
    for (const c of staticColumns) {
      // ⭐ [2026-08-22 사용자 결정] 모달 식별자 원천 = 메타 `CELL_COMBO_DATA_TYPE`.
      //   화면 상수(`CELL_MODAL_KEY`)는 메타 미등재 시 폴백 — 관리자가 슬롯을 채우면 그 값이 이긴다.
      //   ⚠ 이 슬롯은 모달 컨트롤에서만 모달키다(FPComboBox 면 콤보 ID). 아래 ctrlOk 가 이미 가른다.
      const key = c.cellCboDataTp?.trim() || CELL_MODAL_KEY[c.colNm];
      // ⭐ [2026-08-22] `FPTextModal` 포함 — 타이핑+모달 동시 허용 값(AS-IS 파리티).
      //   입력형도 IM(신규행 필수) 외에 IO(신규행 선택)를 허용한다 — AS-IS DMF0082 의 Model 셀은
      //   신규행에서 선택 입력이었다(`InsertRow` L2541 이 division 40 신규행에만 아이콘 부착).
      const ctrlOk =
        c.cellCtrlObjTpCd === CELL_CONTROL_TYPE.MODAL ||
        c.cellCtrlObjTpCd === CELL_CONTROL_TYPE.TEXT_MODAL;
      const inputOk =
        c.inputTpCd === CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY ||
        c.inputTpCd === CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY;
      if (key && ctrlOk && inputOk) {
        map.set(c.colNm, key);
      }
    }
    return map;
  }, [staticColumns]);

  const onPopupCellDblClickRef = useRef(onPopupCellDblClick);
  onPopupCellDblClickRef.current = onPopupCellDblClick;

  // ⭐ 컬럼 개인화 색 (ColumnLayoutModal 저장값) — binding → {cell, text}.
  //   공용 columnMapping 은 colWth/visible 만 넘기고 색은 안 넘기므로 formatItem 이 직접 적용한다
  //   (DMF0020 SalesFuturePriceGrid 선례 동일). ref 로 최신 맵 전달 — 핸들러 재등록 불필요.
  const colorMetaRef = useRef<Map<string, { cell: string; text: string }>>(new Map());
  colorMetaRef.current = useMemo(() => {
    const m = new Map<string, { cell: string; text: string }>();
    staticColumns.forEach(c => {
      if (c.cellColor || c.textColor) {
        m.set(c.colNm, { cell: c.cellColor ?? '', text: c.textColor ?? '' });
      }
    });
    return m;
  }, [staticColumns]);

  // ⭐ 헤더 머지 키 — dynamicColumns 의 그룹 구성(ymKey / subKey)과 **동일 규칙**으로 산출.
  //   (같은 규칙을 써야 머지 범위 = 실제 헤더 그룹 구조. 별도 파생 시 그룹 경계를 넘어 붙는다.)
  const headerKeyMap = useMemo<Map<string, HeaderKey>>(() => {
    const m = new Map<string, HeaderKey>();
    dynColMetas.forEach((d: DynColMeta) => {
      m.set(d.binding, {
        ym: d.binding.slice(2, 8),
        sub: d.kind === 'M' ? 'SUM' : (d.small || 'SUM').trim() || 'SUM',
      });
    });
    return m;
  }, [dynColMetas]);
  // 매니저는 1회만 생성(super 가 grid 이벤트를 바인딩하므로 재생성 시 핸들러 누적) → ref 로 최신 맵 전달.
  const headerKeyRef = useRef(headerKeyMap);
  headerKeyRef.current = headerKeyMap;

  // ⭐ 동적 헤더 머지 매니저 설치 (ColumnHeader 만 재정의 — TopLeft·Cell 은 super 위임).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    if (g.mergeManager instanceof FcstHeaderMergeManager) return;
    g.mergeManager = new FcstHeaderMergeManager(g, () => headerKeyRef.current);
    g.invalidate(true);
  }, [gridRef, staticColumns, dynamicColumns]);

  useEffect(() => {
    bucketRef.current = searchParams.bucketType;
  }, [searchParams.bucketType]);

  // ⭐ 필터 유지 + 신규행 표시 (2026-08-12 사용자 요구 — "필터된 상태에서도 행추가가 가능해야 한다").
  //   Wijmo 제약 2가지를 각각 처리한다.
  //   ① FlexGridFilter 는 생성자에서 `itemsSourceChanged` 에 자기 clear() 를 건다. 이 화면은 Insert 마다
  //      gridRows 를 새 배열로 만들어 itemsSource 가 갈리므로, 사용자가 건 필터가 매번 사라진다.
  //      → 사용자가 필터를 적용할 때 filterDefinition(JSON)을 떠 두고, itemsSource 교체 후 되살린다.
  //   ② 값이 빈 신규행은 필터 조건에 걸려 CollectionView 에서 빠진다.
  //      → 공용 keepRowVisibleUnderFilter 로 wijmo 예외 집합(excludedRowsSet)에 등록한다.
  //   순서 의무: apply() 가 예외 집합을 비우므로 **필터 복원 → 예외 등록 → refresh** 로 진행한다.
  //   주의: 이 작업은 React effect(렌더 이후)에서만 한다. filterApplied 핸들러 안에서 refresh 를 부르면
  //     wijmo apply() 도중 재진입이 되어 내부 인덱스가 어긋난다.
  const filterDefinitionRef = useRef('');
  // 최신 행 배열 참조 — filterApplied 핸들러(비 React 콜백)에서 신규행을 다시 찾기 위해.
  const dataRef = useRef(data);
  dataRef.current = data;
  useEffect(() => {
    const gridFilter = gridFilterRef.current;
    if (!gridFilter) return;
    const rememberFilter = () => {
      filterDefinitionRef.current = gridFilter.filterDefinition;

      // ⭐ [2026-08-22 §3] **apply() 는 예외집합을 통째로 비운다.**
      //     FlexGridFilter.apply()  →  this.excludedRowsSet = null;  →  onFilterApplied()
      //   즉 이 핸들러가 도는 시점엔 방금 `keepRowVisibleUnderFilter` 로 등록해 둔 신규행이 이미
      //   전부 날아가 있다. 그래서 필터를 걸거나 바꾸는 **모든 경로**에서 신규행이 사라진다
      //   (사용자 신고 2026-08-22 "FILTER 후 INSERT ROW 시 INSERT ROW 가 보이지 않습니다").
      //   아래 data effect 는 `data` 가 바뀔 때만 도는데, 필터 적용은 `data` 를 바꾸지 않으므로
      //   그 경로로는 복구되지 않는다 → 여기서 다시 등록해야 한다.
      const g = gridRef.current;
      if (!g || g.columns.length === 0) return;
      const inserted = dataRef.current.filter(
        row => (row as unknown as WijmoRowItem)['CRUD_TYPE'] === 'I'
      );
      if (inserted.length === 0) return;
      inserted.forEach(row => keepRowVisibleUnderFilter(g, row));
      // ⚠ refresh 를 여기서 **동기로** 부르면 wijmo apply() 도중 재진입이 되어 내부 인덱스가 어긋난다
      //   (이 파일의 기존 주석 계보). apply() 스택을 벗어난 다음 틱에 판정만 다시 시킨다.
      //   refresh() 는 apply() 를 부르지 않으므로 filterApplied 가 다시 나지 않는다(무한루프 없음).
      // ⚠ 이 refresh 는 **부모의 Insert 포커스 effect 보다 늦게** 돈다(effect 는 동기 커밋 안,
      //   마이크로태스크는 그 뒤). refresh 로 제외행이 다시 나타나면 행 인덱스가 밀려, 방금 맞춘
      //   스크롤 위치가 **다른 행**을 가리키게 된다(사용자 신고 2026-08-22: "잠깐 INSERT ROW 가
      //   보이다가 SCROLL 되면서 위치가 달라집니다").
      //   → refresh 전후로 **선택된 데이터 행 객체**를 기준으로 위치를 되맞춘다(인덱스는 밀리지만
      //     행 객체는 그대로다 — 인덱스로 기억하면 안 되는 이유는 #144 §1 과 동일).
      const keepItem =
        g.selection.row >= 0
          ? ((g.rows[g.selection.row]?.dataItem ?? null) as WijmoRowItem | null)
          : null;
      const keepCol = Math.max(0, g.selection.col);
      queueMicrotask(() => {
        if (gridRef.current !== g || g.columns.length === 0) return;
        g.collectionView?.refresh();
        if (!keepItem) return;
        const idx = g.rows.findIndex(r => r.dataItem === keepItem);
        if (idx < 0) return;
        g.select(idx, Math.min(keepCol, Math.max(0, g.columns.length - 1)));
        g.scrollIntoView(idx, -1);
      });
    };
    gridFilter.filterApplied.addHandler(rememberFilter);
    return () => gridFilter.filterApplied.removeHandler(rememberFilter);
  }, [gridFilterRef, gridRef, dynamicColumns]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    // 컬럼이 하나도 없는 그리드에는 적용할 것이 없다.
    //   division 별 admin 컬럼 메타가 미적재면(예: 81 — /admin/menu/DMF0082/column 이 result:null)
    //   staticColumns 가 빈 배열이 되고, 조회 결과까지 0건이면 동적 컬럼도 비어 columnGroups 가
    //   통째로 빈 배열이 된다. 이 상태에서 아래 collectionView.refresh() 로 신규행을 밀어 넣으면
    //   wijmo 가 컬럼 인덱스 -1 로 내부 계산을 하다 'Positive number expected.' 를 던져 화면이
    //   에러 바운더리로 떨어진다 (2026-08-13 division 81 조회 0건 + 행추가 실측).
    //   어차피 컬럼이 없어 신규행을 보여줄 수단도 없으므로 건너뛰는 것이 무손실이다.
    if (g.columns.length === 0) return;

    const insertRows = (data ?? []).filter(
      row => (row as unknown as WijmoRowItem)['CRUD_TYPE'] === 'I'
    );
    // ⭐ 신규행이 없다 = **조회 결과 교체**(Search). 이때는 필터를 복원하지 않는다 (2026-08-13 정정).
    //   구 구현은 data 가 바뀔 때마다 무조건 복원해서 두 가지 문제가 있었다:
    //     ① 새로 조회했는데 직전 필터가 되살아난다 (사용자 기대와 반대).
    //     ② 조회로 컬럼 구성이 바뀌면 옛 filterDefinition 이 없는 컬럼을 가리켜 wijmo 내부
    //        인덱스가 음수가 될 수 있다 → `Positive number expected`.
    //   기억해 둔 정의도 함께 버린다 — 다음 조회에 유령 필터가 붙지 않게.
    if (insertRows.length === 0) {
      filterDefinitionRef.current = '';
      return;
    }

    const gridFilter = gridFilterRef.current;
    const savedFilter = filterDefinitionRef.current;
    if (gridFilter && savedFilter && gridFilter.filterDefinition !== savedFilter) {
      try {
        gridFilter.filterDefinition = savedFilter; // setter 가 apply 까지 수행
      } catch {
        // 컬럼 구성이 바뀌어 정의를 못 붙이는 경우 — 필터 없이 진행 (화면 차단 금지).
        filterDefinitionRef.current = '';
      }
    }

    insertRows.forEach(row => keepRowVisibleUnderFilter(g, row));
    g.collectionView?.refresh();
  }, [gridRef, gridFilterRef, data]);

  // ── grid 핸들러 등록 (useEffect + gridRef, deps=[staticColumns, dynamicColumns], cleanup 의무) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    editTrackerRef.current = new EditTracker(g as FlexGrid);
    // ⭐ 2026-08-22 (hook #144 §2 적용) — 화면이 `FlexGridFilter` 를 직접 만들던 블록 제거.
    //   `<DataGrid>` 가 `handleInitialized`(DataGrid.tsx:542)에서 이미 만들며, 그쪽이 React
    //   자식 커밋 시점이라 이 부모 effect 보다 **먼저** 돈다 → `if (!gridFilterRef.current)` 가드에
    //   항상 걸려 여기 코드는 실행된 적이 없다(죽은 코드). 그 결과 필터 대상이 화면 의도(정적 컬럼만)가
    //   아니라 DataGrid 기본값 `['']`(전 컬럼)이었다.
    //   → 대상 목록은 `<DataGrid filterColumns={...}>` 로 넘긴다(아래 JSX). 생성 주체는 DataGrid 단일.

    // 편집 가능 판정 — measure 권한(41번 매트릭스) + GridUtils 시간축 판정.
    const canEditCell = (binding: string, dataItem: WijmoRowItem): boolean => {
      const measure = dataItem['MEASURE'];
      if (typeof measure !== 'string') return false;
      // ⭐ measure 권한은 wsAuth 단일 판정 (2026-08-12 — 현업 검수 41번 배선).
      //   구 코드는 AUTH_MEASURES 화이트리스트 + measureAuth 뿐이라 AS_In_Req 가 항상 잠기고,
      //   VMI_In_Req 는 "권한과 무관" 요건과 달리 그룹권한을 탔다.
      const rowSite = String(dataItem['SCM_SITE_ID'] ?? '').trim();
      if (
        !isMeasureEditableByAuth({
          measure,
          divisionId: String(dataItem['DIVISION_ID'] ?? '') || searchParams.divisionId,
          wsPlannerYn: wsPlannerYnRef.current,
          measureAuth: measureAuthRef.current,
          vmiYn: dataItem['VMI_YN'] ?? vmiBySiteRef.current.get(rowSite),
          vmiProvided: vmiProvidedRef.current,
          // 엄격 'I' 판정 — 'M'(값 편집 마킹) 행을 신규행으로 세면 VMI_YN 미상일 때
          //   isVmiMeasureAllowed 가 "신규행이니 통과"로 잘못 열어준다 (isInsertRow 주석).
          isInsertRow: isInsertRow(dataItem),
        })
      )
        return false;
      const bucketName =
        bucketRef.current === 'M' ? 'Monthly' : bucketRef.current === 'D' ? 'Daily' : 'Weekly';
      return !isNonEditableCell(
        g as FlexGrid,
        binding,
        dataItem,
        weekMap.current,
        bucketName,
        m3CutoffRef.current
      );
    };

    // MEASURE 컬럼 dataMap 에 행별 후보 필터를 1회 설치한다 (편집 진입 시 lazy — dataMap 은
    //   메타/콤보 도착 후에야 채워지고 layout 재적용으로 새 인스턴스가 될 수 있다).
    //   원본 getDisplayValues 는 보관해 두고, 행별 후보가 없으면 전체 목록으로 위임한다.
    const installMeasureCandidateFilter = (dataMap?: DataMap) => {
      if (!dataMap) return;
      const map = dataMap as MeasureCandidateDataMap;
      if (map.rowScopedCandidates) return;
      map.rowScopedCandidates = true;
      const allDisplayValues = map.getDisplayValues.bind(map) as (item?: unknown) => string[];
      map.getDisplayValues = (item?: unknown): string[] => {
        const candidates = item ? editMeasuresRef.current.get(item as object) : undefined;
        if (candidates && candidates.length > 0) {
          // 후보 코드를 전체 map 의 표시명으로 환산 (map 에 없는 코드만 콤보 NAME 으로 폴백).
          return candidates.map(
            candidate =>
              map.getDisplayValue(String(candidate.CODE)) ||
              String(candidate.NAME ?? candidate.CODE ?? '')
          );
        }
        // ⭐ 서버 후보 0건 폴백 (2026-08-13 정정) — 룩업 `DM_UI_EDITABLE_MEASURE` 에 해당 division
        //   행이 없으면 콤보가 0건을 준다(division 81 실측). 구 구현은 이때 **표시용 전체 목록**을
        //   그대로 열어 `Balance`·`AS Inv.`·EDI 종속 메저(Immidiate/Planning_Forecast/…)처럼
        //   신규행에 넣을 수 없는 measure 까지 고를 수 있었다.
        //   ⇒ 화면이 아는 편집대상(AUTH_MEASURES)만 남긴다. 드롭다운을 비우지는 않아
        //     룩업 미등록 환경에서도 최소 입력은 유지된다(기존 "비우지 않기" 규약 계승).
        //   ⚠️ 판정은 표시명 → **코드**(getKeyValue) 방향으로 한다. 코드 → 표시명(getDisplayValue)
        //     방향은 map 에 없는 코드에서 무엇을 돌려주는지가 wijmo 구현에 달려 있어(키 자체를 그대로
        //     반환하기도 한다) 매칭이 조용히 실패한다 — 실제로 AS_In_Req 가 그렇게 누락됐다
        //     (2026-08-13 division 81 실측). getKeyValue 는 wijmo 가 선택값을 코드로 되돌릴 때
        //     쓰는 바로 그 함수라, 이 방향이면 "고를 수 있는 값 = 저장 가능한 값" 이 보장된다.
        const all = allDisplayValues(item);
        const narrowed = all.filter(name =>
          (AUTH_MEASURES as readonly string[]).includes(String(map.getKeyValue(name) ?? '').trim())
        );
        return narrowed.length > 0 ? narrowed : all;
      };
    };

    // ⭐ [41번-② 2026-08-12] FCST Type 편집 후보 — **division × W/S 그룹** 분기.
    //   표시용 셀 콤보 'FcstTypeByUserGroupDMF0082' 는 **사용자 그룹만** 보고 division 을 보지 않아,
    //   W/S 권한자가 Div 40 을 조회하면 SALES_TYPE_CODE2(W/S 2종 포함)가 그대로 노출됐다.
    //   요구 원문: "SALES_TYPE_CODE2 … 는 81, 81_Div 의 DM Planner(W/S) 권한일 경우에 사용" /
    //             "40 Div 의 경우 W/S(Chargable), W/S(Free) 는 안 보여야 함".
    //   ⇒ 판정 권위는 **서버**(CMBO 'FcstTypeEditDMF0082', @divisionId 전달)로 옮겼다.
    //     여기서는 그 결과를 표시 목록과 교집합해 드롭다운만 좁힌다.
    //   ⚠️ dataMap 을 **교체하지 않고** getDisplayValues 만 덮는다 — 교체하면 기존 행에 저장된
    //     W/S 값의 CODE→NAME 매핑이 깨진다(MEASURE 와 동일 규약).
    const installFcstTypeCandidateFilter = (dataMap?: DataMap) => {
      if (!dataMap) return;
      const map = dataMap as FcstTypeCandidateDataMap;
      if (map.wsFilteredCandidates) return;
      map.wsFilteredCandidates = true;
      const allDisplayValues = map.getDisplayValues.bind(map) as (item?: unknown) => string[];
      // 서버 후보가 없거나 표시 목록과 라벨이 어긋날 때의 degrade — FE 규칙으로 W/S 2종만 제거.
      //   (선택값을 코드로 되돌리는 건 표시 map 이므로, 표시 목록 밖 이름을 넣으면 매핑이 깨진다.)
      const fallback = (values: string[]): string[] =>
        isWsFcstTypeEditCombo({
          wsPlannerYn: wsPlannerYnRef.current,
          divisionId: searchParams.divisionId,
        })
          ? values
          : values.filter(name => !isWsOnlyFcstType('', name));

      map.getDisplayValues = (item?: unknown): string[] => {
        const values = allDisplayValues(item);
        const serverNames = fcstTypeEditNamesRef.current;
        if (serverNames.length === 0) return fallback(values);
        const allow = new Set(serverNames);
        const narrowed = values.filter(name => allow.has(name));
        return narrowed.length > 0 ? narrowed : fallback(values);
      };
    };

    // ⭐ 정적 컬럼 편집 가능 판정 — 편집 차단(beginningEdit/pastingCell)과 셀 색칠(formatItem)이
    //   **반드시 같은 함수**를 봐야 한다. 2026-08-11 No.35 로 편집 조건만 INPUT_TP_CD 로 좁히고
    //   색칠은 isInsert 그대로 둬서, 조회전용(INPUT_TP_CD='S') 인 Nick Name/Team 등이 신규행에서
    //   노랑(편집가능)으로 보이는데 편집은 막히는 어긋남이 생겼다 (2026-08-12 사용자 리포트).
    const canEditStaticCell = (binding: string, dataItem: WijmoRowItem): boolean => {
      // Insert 행(CRUD_TYPE==='I')만 편집 (AS-IS: 기존 행 키 컬럼 잠금).
      //   주의: 'M'(값 편집으로 EditTracker 가 찍는 수정 마킹)을 Insert 로 세면 금액 한 번 고친 뒤
      //     Model/Nick Name 등 키 컬럼이 통째로 열린다 — isInsertRow 주석(2026-07-31) 참고.
      if (!isInsertRow(dataItem)) return false;
      // [No.35 2026-08-11] 신규행 입력 컬럼 = UI Category Setup `INPUT_TP_CD`(IM/IO/M/O) 한정 —
      //   통합테스트 1st "As-Is 기준 입력 가능한 컬럼은 8개"(End Customer/Sales Site/Model/Incoterms/
      //   FCST Type/Customs Handbook[DOM_EXP]/Cell Prod Site/Currency + Measure 콤보).
      const inputTp = inputTpRef.current.get(binding);
      if (!(inputTp === 'IM' || inputTp === 'IO' || inputTp === 'M' || inputTp === 'O'))
        return false;
      // [No.63-① ② 2026-08-11] AS From Site — 메타는 IO 로 열되(전 division 공통 1값), 실제 활성은
      //   division × Sales Site 향 × FCST Type 으로 좁힌다. 40 은 전부 차단되어 No.35(입력 8컬럼) 유지.
      if (binding === 'AS_FROM_SITE') return asFromSiteEditable(dataItem);
      return true;
    };

    const cellEditableHandler = (
      sender: FlexGrid,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem) {
        e.cancel = true;
        return;
      }
      if (staticBindingSet.has(binding)) {
        // 편집 가부는 canEditStaticCell 단일 판정 (셀 색칠도 같은 함수를 본다).
        if (!canEditStaticCell(binding, dataItem)) {
          e.cancel = true;
          return;
        }
        // AS From Site — 편집 허용 시 후보 목록(AS_FROM_SITE 콤보)으로 dataMap 스왑.
        if (binding === 'AS_FROM_SITE') {
          const asCol = sender.columns[e.col];
          if (asCol && asFromSiteMapRef.current) {
            if (!(binding in origDataMapRef.current))
              origDataMapRef.current[binding] = (asCol.dataMap as DataMap) ?? null;
            asCol.dataMap = asFromSiteMapRef.current;
          }
          return;
        }
        // ⭐ #7 — MEASURE 편집 후보 제한. dataMap 을 **교체하지 않고** getDisplayValues 만 덮는다.
        //   구 구현은 행별 후보(FcstPriceEditMeasure 3~4종)로 컬럼 dataMap 을 통째로 갈아끼웠다.
        //   dataMap 은 컬럼 단위라 교체하는 순간 후보 밖 코드는 CODE→NAME 매핑을 잃고,
        //   편집 중인 셀과 같은 컬럼의 다른 행이 전부 raw CODE('KRW')로 보였다 (2026-08-12 리포트).
        //   wijmo 는 편집기 드롭다운을 만들 때 getDisplayValues(행 dataItem) 를 호출하므로,
        //   전체 표시용 map 을 그대로 두고 후보만 좁히면 표시와 후보가 동시에 맞는다.
        //   (measure 후보는 전체 목록의 부분집합이라 이 방식이 성립한다.)
        if (binding === 'MEASURE') {
          installMeasureCandidateFilter(sender.columns[e.col]?.dataMap as DataMap | undefined);
          return;
        }
        // [41번-② 2026-08-12] FCST Type — W/S 자격이 없으면 후보에서 W/S 2종 제거 (division 게이트).
        if (binding === 'FCST_TYPE') {
          installFcstTypeCandidateFilter(sender.columns[e.col]?.dataMap as DataMap | undefined);
          return;
        }

        // 행 단위 서버 재조회로 좁혀진 후보가 있으면 그것으로 스왑 (없으면 표시용 유지 = 회귀 0).
        //   CELL_PROD_SITE_ID ← ITEM_ID 변경 / SCM_SITE_ID ← END_CUSTOMER 변경.
        const rowScopedRef =
          binding === 'CELL_PROD_SITE_ID'
            ? cellProdSitesRef
            : binding === 'SCM_SITE_ID'
              ? salesSitesRef
              : null;
        if (rowScopedRef) {
          const candidates = rowScopedRef.current.get(dataItem);
          const rsCol = sender.columns[e.col];
          if (candidates && candidates.length > 0 && rsCol) {
            if (!(binding in origDataMapRef.current))
              origDataMapRef.current[binding] = (rsCol.dataMap as DataMap) ?? null;
            rsCol.dataMap = new DataMap(candidates as unknown[], 'CODE', 'NAME');
          }
          return;
        }

        // ⭐ UP_FX 편집 콤보 스왑 (2026-08-08) — 표시용 메타 콤보 → 편집 후보로 교체.
        //   순서: ①AS 사이트 행의 Incoterms(AS 전용) ②행 컨텍스트 필터 ③기본 편집 콤보.
        //   어느 단계든 후보 0건이면 스왑을 생략해 표시용 콤보를 그대로 쓴다(회귀 0).
        const col = sender.columns[e.col];
        const cfg = GRID_EDIT_COMBO[binding];
        // divisions 지정 시 그 division 행에만 편집판을 적용 (AS-IS 적용 범위 밖은 표시용 전체 유지).
        const rowDiv = String(dataItem['DIVISION_ID'] ?? '');
        const editCfg = cfg && (!cfg.divisions || cfg.divisions.includes(rowDiv)) ? cfg : undefined;
        if (col && editCfg) {
          const backup = () => {
            if (!(binding in origDataMapRef.current))
              origDataMapRef.current[binding] = (col.dataMap as DataMap) ?? null;
          };
          // ① AS 사이트 행 → AS 전용 Incoterms (AS-IS AS_INCOTERMS 분기)
          if (binding === 'INCOTERMS') {
            const site = String(dataItem['SCM_SITE_ID'] ?? '').trim();
            if (site && asSiteNamesRef.current.has(site) && asIncotermsMapRef.current) {
              backup();
              col.dataMap = asIncotermsMapRef.current;
              return;
            }
          }
          // ② 행 컨텍스트 필터 (관대 통과 — 행/콤보 어느 쪽 값이 비면 통과. 정본 mkt-fcst:814-832)
          const src = editComboRowsRef.current[binding] ?? [];
          const filterKey = editCfg.rowFilterKey;
          if (filterKey && src.length > 0) {
            const rv = String(dataItem[filterKey] ?? '').trim();
            const filtered = src.filter(cr => {
              const cv = comboCellStr(cr[filterKey]);
              return !rv || rv === 'ALL' || !cv || rv === cv;
            });
            const dedup = [...new Map(filtered.map(cr => [comboCellStr(cr.CODE), cr])).values()];
            if (dedup.length > 0) {
              backup();
              col.dataMap = new DataMap(dedup, 'CODE', 'NAME');
              return;
            }
          }
          // ③ 기본 편집 콤보
          const editMap = editDataMapsRef.current[binding];
          if (editMap) {
            backup();
            col.dataMap = editMap;
          }
          return;
        }

        // ⭐ D7 — CURRENCY: PRICE 계열 measure 가 아니면 빈 목록으로 교체해 입력을 차단
        //   (AS-IS `UP_FX_GetCommonDataList_DM @Code='NO_DATA'` = `SELECT '' CODE, '' NAME`, .cs L5639).
        if (binding === 'CURRENCY' && col) {
          const measure = String(dataItem['MEASURE'] ?? '');
          if (!(PRICE_MEASURES as readonly string[]).includes(measure)) {
            if (!(binding in origDataMapRef.current))
              origDataMapRef.current[binding] = (col.dataMap as DataMap) ?? null;
            col.dataMap = new DataMap([], 'CODE', 'NAME');
          }
        }
        return;
      }
      if (kindOf(binding) && !canEditCell(binding, dataItem)) {
        e.cancel = true;
        // [E20260826-AUTHVIEW] 시간창 因 잠금 메저 = MSG00477 안내 (그룹 미보유 'N' 은 침묵 유지 —
        //   DM Viewer 등에는 시간 메시지를 띄우지 않는다).
        const measure = dataItem['MEASURE'];
        if (
          typeof measure === 'string' &&
          measureTimeGateRef.current[measure] &&
          Date.now() - lastTimeGateAlertRef.current > 2000
        ) {
          lastTimeGateAlertRef.current = Date.now();
          void setAlert({
            type: 'alert',
            content: t(MSG.SCP_TIME_WINDOW, '_This is not an editable time window.'),
          });
        }
      }
    };

    // 편집 종료 — 월/주/일 배분 (AS-IS spdMain_EditChange 분배 로직 1:1, GridUtils 재사용).
    const cellEditHandler = (sender: FlexGrid, e: { row: number; col: number; data?: unknown }) => {
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem) return;
      // (MEASURE 는 dataMap 을 교체하지 않고 getDisplayValues 로 후보만 좁히므로 원복이 필요 없다.)
      // ⭐ UP_FX 편집 콤보 원복 — 스왑이 남으면 필터 밖 CODE 를 가진 **다른 행**의 명칭 변환이 깨진다
      //   (편집 취소 경로도 cellEditEnded 를 타므로 여기서 일괄 원복. 정본 mkt-fcst:926-939).
      if (binding in origDataMapRef.current) {
        const col = sender.columns[e.col];
        if (col) col.dataMap = origDataMapRef.current[binding] ?? null;
      }
      const isInsert = isInsertRow(dataItem);
      // ⭐ [2026-08-22] 상위 변경 → 하위(모달 조회조건 종속) 컬럼 초기화. apply* 보다 **먼저** 돈다 —
      //   먼저 비워야 뒤이은 후보 재조회가 빈 값 기준으로 정상 동작한다.
      if (isInsert) clearDependentCells(dataItem, binding);
      // #2 — Insert 행 Site/Incoterms 변경 → SALES_BUCKET 조회·세팅 (배분 요일 원천).
      //   #7 — Site 변경 시 편집가능 Measure 후보도 재조회(행별 캐시).
      if ((binding === 'SCM_SITE_ID' || binding === 'INCOTERMS') && isInsert) {
        applySalesBucket(dataItem);
      }
      // ⭐ 편집가능 Measure 재조회 — AS-IS 는 **6개 지점**에서 재조회한다:
      //   InsertRow(.cs L2621 — 위 프라이밍 effect) / 셀변경(L5841) / Paste(L7922·L8027) /
      //   ComboSelChange Division(L8261) / ComboSelChange Sales Site·Incoterms(L8308).
      //   후보는 서버(`FcstPriceEditMeasure`)가 **사이트 특성(SCM_MST_SITE.VMI_YN)** 과 bucket(D→LOC 제외)로
      //   가리므로, 이 키들이 바뀌면 반드시 다시 물어야 한다. 구 코드는 SCM_SITE_ID 하나뿐이었다.
      if (
        (binding === 'SCM_SITE_ID' || binding === 'DIVISION_ID' || binding === 'INCOTERMS') &&
        isInsert
      ) {
        applyEditMeasures(dataItem, true);
      }
      // D9 — Model(ITEM_ID) 변경 → Cell Prod Site 후보 재조회 (AS-IS .cs L5854).
      //   Division 변경도 CMBO 바인드(@divisionId)에 들어가므로 함께 재조회.
      if ((binding === 'ITEM_ID' || binding === 'DIVISION_ID') && isInsert)
        applyCellProdSites(dataItem, true);
      // End Customer 변경 → Sales Site 후보 재조회 (AS-IS .cs L8237·8283·8294).
      if ((binding === 'END_CUSTOMER' || binding === 'DIVISION_ID') && isInsert)
        applySalesSites(dataItem, true);
      // [No.63-① ② 2026-08-11] Sales Site / FCST Type 변경으로 AS From Site 조건이 깨지면 **값도 비운다** —
      //   AS-IS 는 잠글 때마다 `SetText(AS_FROM_SITE, "")` 를 함께 호출한다(.cs L3481·3506·3587·3597).
      //   비우지 않으면 비축향으로 바꾼 뒤에도 이전 고객향 값이 payload 로 저장된다.
      if (
        (binding === 'SCM_SITE_ID' || binding === 'FCST_TYPE' || binding === 'DIVISION_ID') &&
        isInsert &&
        !asFromSiteEditable(dataItem) &&
        String(dataItem['AS_FROM_SITE'] ?? '') !== ''
      ) {
        dataItem['AS_FROM_SITE'] = '';
        sender.invalidate();
      }
      // #10 실시간 중복 검사(AS-IS MSG00260 :5878 파리티)는 **2026-08-11 제거** — 통합테스트 1st No.38
      //   사용자 요구 "저장 버튼 클릭 시 중복 Validation 수행하도록 수정"(입력 즉시 팝업 금지).
      //   중복 검증은 저장 시점 단일 경로 = ForecastPrice.handleSave 의 MSG00260(DUP_NEW_ROW) 검사 +
      //   SP 측 검증이 담당한다. (AS-IS 원문은 실시간이었으나 문서 요구가 우선 — 대사표 No.38)
      if (!kindOf(binding)) return;
      let val = sender.getCellData(e.row, e.col, false) as WijmoPrimitive;
      const oldVal = (e.data ?? null) as WijmoPrimitive;
      if (
        (oldVal === undefined || oldVal === null) &&
        (val === undefined || val === null || val === '')
      )
        return;
      const tracker = editTrackerRef.current;
      if (!tracker) return;
      const measure = dataItem['MEASURE'];
      // #14 — Daily 버킷 D_ 직접 입력 시 FCST 3종은 정수 절삭 (AS-IS :6094~6103).
      if (
        binding.startsWith('D_') &&
        (measure === 'MKT_FCST' || measure === 'SCM_FCST' || measure === 'VMI_In_Req')
      ) {
        const truncated = Math.trunc(toNumber(val));
        if (truncated !== toNumber(val)) {
          val = truncated;
          sender.setCellData(e.row, e.col, truncated);
        }
      }
      // 배분 대상 = MKT_FCST/SCM_FCST 만 (AS-IS L498 실측). LOC=일괄할당. VMI_In_Req=단일 셀(배분 없음).
      if (measure === 'MKT_FCST' || measure === 'SCM_FCST') {
        if (binding.startsWith('M_'))
          divideByMonth(
            binding,
            dataItem,
            val,
            monthMap.current,
            weekMap.current,
            calendarMapRef.current,
            tracker,
            defaultBucketRef.current
          );
        else if (binding.startsWith('W_'))
          divideByWeek(
            binding,
            dataItem,
            val,
            oldVal,
            weekMap.current,
            tracker,
            defaultBucketRef.current
          );
        else if (binding.startsWith('D_')) divideByDate(binding, dataItem, val, oldVal, tracker);
      } else if (measure === 'LOC') {
        allocateLoc(binding, dataItem, val, monthMap.current, weekMap.current, tracker);
      } else {
        tracker.storeChange(dataItem, binding, oldVal, val);
      }
      sender.invalidate();
    };

    // 셀 표시 (#95 3색 표준 — 편집가능 Yellow / 기준주차 이전 잠금 Gray / 기본 White+zebra)
    //   + #108 No. 코너 헤더 (TopLeft 전체 단일 머지 + 'No.' 라벨, 재귀 가드).
    const formatHandler = (
      sender: FlexGrid,
      e: {
        panel: { cellType: CellType; rows: unknown };
        row: number;
        col: number;
        cell: HTMLElement;
      }
    ) => {
      if (e.panel.cellType === CellType.TopLeft) {
        // 코너 헤더 — row-header 첫 컬럼(번호)에만 'No.' 표시, 나머지(편집 그리드의 CRUD 상태 컬럼)는 공백.
        //   편집 그리드는 rowHeaders 2컬럼이라 전 셀에 'No.' 를 찍으면 'No. No.' 로 보였다(#108).
        //   Exchange Rate(읽기전용=1컬럼) 팝업처럼 코너에 'No.' 하나만 보이도록 한다.
        const label = e.col === 0 ? 'No.' : '';
        if (e.cell.textContent !== label) e.cell.textContent = label;
        e.cell.style.textAlign = 'center';
        e.cell.style.verticalAlign = 'middle';
        return;
      }
      // ⭐ 당월·당주 헤더 초록 볼드 — **AS-IS 화면 캡처 기준** (사용자 확정 2026-07-22).
      //   AS-IS 는 초록을 **헤더에만** 쓴다: 1단(년월)=당월 / 하위단=당주 **W_ 컬럼만**
      //   (그 아래 leaf 'SUM' 은 같은 W_ binding 이라 함께 초록). 본문 셀에는 초록을 칠하지 않는다.
      //   ⚠️ M_(당월 SUM)·D_ 는 제외 — 포함 시 초록이 4곳으로 번져 AS-IS 와 달라진다.
      if (e.panel.cellType === CellType.ColumnHeader) {
        const hb = sender.columns[e.col]?.binding ?? '';
        if (!kindOf(hb)) return;
        // 주말 일자 헤더 색 — 토요일 파랑 / 일요일 빨강 (D_ leaf 헤더 한정, 사용자 요구 2026-07-22).
        //   D_ 는 3단 leaf(일자)에서만 자기 라벨이 보인다(상위 row 는 월/주 머지에 덮임) → leaf row 한정.
        const leafRow = sender.columnHeaders.rows.length - 1;
        if (hb.startsWith('D_') && e.row === leafRow) {
          const ymd = hb.slice(2); // YYYYMMDD
          const dow = dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`).day();
          if (dow === 6)
            e.cell.style.color = '#1565c0'; // 토
          else if (dow === 0) e.cell.style.color = '#d32f2f'; // 일
        }
        const isGreen =
          e.row === 0
            ? hb.slice(2, 8) === dayjs().format('YYYYMM')
            : hb.startsWith('W_') && currentPeriodRef.current.has(hb);
        if (isGreen) {
          e.cell.style.color = '#2e7d32';
          e.cell.style.fontWeight = 'bold';
        }
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem) return;

      // ⭐ CUST 종속 메저 단계별 indent (사용자 지시 2026-08-26 — DMF0003 MktFcstGrid 파리티).
      //   표시명은 공유 콤보 'Measure' dataMap(1단 ' └ ' / 2단 '    └ ' 공백4)에서 오는데,
      //   선행 공백이 HTML 에서 collapse 되면 전 단계가 같은 깊이로 보인다 → MEASURE 셀만
      //   white-space 보존 (다른 컬럼 영향 0).
      if (binding === 'MEASURE') e.cell.style.whiteSpace = 'pre';

      if (kindOf(binding)) {
        const editable = canEditCell(binding, dataItem);
        e.cell.classList.toggle('wj-cell-editable', editable);
        // 과거 구간(월=당월 전 / 주·일=금주 월요일 전) = 잠금 Gray (특수셀 한정 — 전체 회색 금지).
        //   필수: 편집 차단(isNonEditableCell)과 같은 함수를 써야 색과 동작이 어긋나지 않는다.
        //   판정 기준은 forecast-price.editLock.isPastPeriodLocked 주석이 단일 출처.
        e.cell.classList.toggle(
          'wj-cell-non-editable',
          isPastPeriodLocked(binding, weekMap.current)
        );
        // 실적/계획 경계 초록 세로선 — 당기 컬럼 왼쪽 한 줄만 (좌·우 레일인 sales-plan/mkt-fcst
        //   와 다르다). 대상 판정 근거는 findActualBoundaryBinding 주석 참고.
        //   (2026-07-22 에 "본문에 초록선 없음"으로 지웠던 것을 AS-IS 재확인 후 되살린 것이다.)
        //   배경색·글자색과 같은 inline 방식 — sales-plan/mkt-fcst 는 !important CSS 클래스를 쓰지만
        //   inline 은 그 자체로 Wijmo 기본 셀 border 를 이기므로 전용 스타일시트가 필요없다.
        //   필수: 비대상 셀은 '' 로 되돌린다 — Wijmo 셀 재활용으로 이전 셀의 선이 남는다.
        //   boxShadow 는 예전 레일 구현의 잔재 — 같은 이유로 계속 지운다.
        e.cell.style.boxShadow = '';
        e.cell.style.borderLeft = binding === actualBoundaryRef.current ? '2px solid #1e8449' : '';
        // 음수 = 빨간 글자 — AS-IS CustomCell.NegativeRed=true(:1876)·공용 SpreadInfo 기본 파리티.
        //   정본 = @foundation/utils paintNegativeText (REQ:CHAT-20260820-6 계보 — sales-plan 동일 배선).
        //   비음수는 반드시 제거(셀 DOM 재활용 잔상)·문자 값은 toGridNumber=0 → 자연 제외.
        paintNegativeText(e.cell, toGridNumber(dataItem[binding]));
        // #11 숫자 표시 — NOTATION(POINT3/LOC)=소수3자리 / INTEGER=정수. 0/null 은 빈칸 (AS-IS :1853~1924).
        if (!sender.editRange?.contains(e.row, e.col)) {
          const v = dataItem[binding];
          if (v === undefined || v === null || v === 0 || v === '') {
            e.cell.innerText = '';
          } else {
            const isPoint3 = dataItem['NOTATION'] === 'POINT3' || dataItem['MEASURE'] === 'LOC';
            e.cell.innerText = toNumber(v as WijmoPrimitive).toLocaleString(undefined, {
              minimumFractionDigits: isPoint3 ? 3 : 0,
              maximumFractionDigits: isPoint3 ? 3 : 0,
            });
          }
        }
        return;
      }
      // 정적 컬럼: **실제로 편집 가능한 셀만** Yellow — 편집 차단과 같은 판정을 쓴다.
      //   신규행이라도 INPUT_TP_CD='S'(Nick Name/Team 등 조회전용)는 칠하지 않는다 (2026-08-12 정정).
      const editable = canEditStaticCell(binding, dataItem);
      e.cell.classList.toggle('wj-cell-editable', editable);
      // ⭐ 개인화 색 — 우선순위: 편집가능셀 Yellow(클래스) > 저장된 Cell Color > 기본(제거).
      //   inline !important 라 클래스보다 세므로 편집가능 셀에는 배경을 칠하지 않는다.
      //   미지정 시 removeProperty 필수 — Wijmo 셀 재활용으로 이전 행 색이 남는다.
      const personalColor = colorMetaRef.current.get(binding);
      if (!editable && personalColor?.cell) {
        e.cell.style.setProperty('background-color', personalColor.cell, 'important');
      } else {
        e.cell.style.removeProperty('background-color');
      }
      // 음수 빨강 > 개인화 Text Color (sales-plan 정본 우선순위). 비음수 = 개인화 색 또는 제거.
      const staticCellNumber = toGridNumber(dataItem[binding]);
      if (staticCellNumber < 0) {
        paintNegativeText(e.cell, staticCellNumber);
      } else if (personalColor?.text) {
        e.cell.style.setProperty('color', personalColor.text, 'important');
      } else {
        e.cell.style.removeProperty('color');
      }
    };

    // Delete 키 — 선택 범위 일괄 clear + 배분 재계산 (AS-IS KeyUp Delete 1:1)
    const keydownHandler = (keyboardEvent: KeyboardEvent) => {
      if (keyboardEvent.key !== 'Delete') return;
      keyboardEvent.preventDefault();
      keyboardEvent.stopPropagation();
      const tracker = editTrackerRef.current;
      if (!tracker) return;
      g.selectedRanges.forEach(range => {
        for (let row = range.topRow; row <= range.bottomRow; row++) {
          for (let col = range.leftCol; col <= range.rightCol; col++) {
            const dataItem = g.rows[row]?.dataItem as WijmoRowItem | undefined;
            const binding = g.columns[col]?.binding;
            if (!binding || !dataItem || g.columns[col]?.isReadOnly) continue;
            if (staticBindingSet.has(binding)) {
              // Insert 행의 편집가능 정적 컬럼만 Delete 로 비운다 — 기존 행('M'/'D')의 키는 잠금 대상.
              //   필수: 판정은 편집 진입(canEditStaticCell)과 같은 함수 — 타이핑은 막히는데 Delete 로는
              //   지워지면 '입력불가컬럼'(INPUT_TP_CD='S')을 지킨 게 아니다 (2026-08-04).
              if (canEditStaticCell(binding, dataItem)) dataItem[binding] = null;
              continue;
            }
            if (!kindOf(binding) || !canEditCell(binding, dataItem) || !dataItem[binding]) continue;
            const oldValue = dataItem[binding];
            tracker.storeChange(dataItem, binding, oldValue, 0);
            dataItem[binding] = 0;
            const measure = dataItem['MEASURE'];
            if (measure === 'MKT_FCST' || measure === 'SCM_FCST') {
              if (binding.startsWith('M_'))
                divideByMonth(
                  binding,
                  dataItem,
                  0,
                  monthMap.current,
                  weekMap.current,
                  calendarMapRef.current,
                  tracker,
                  defaultBucketRef.current
                );
              else if (binding.startsWith('W_'))
                divideByWeek(
                  binding,
                  dataItem,
                  0,
                  oldValue,
                  weekMap.current,
                  tracker,
                  defaultBucketRef.current
                );
              else if (binding.startsWith('D_'))
                divideByDate(binding, dataItem, 0, oldValue, tracker);
            } else if (measure === 'LOC') {
              allocateLoc(binding, dataItem, 0, monthMap.current, weekMap.current, tracker);
            }
          }
        }
      });
      g.invalidate();
    };

    // 헤더 더블클릭 드릴다운 (AS-IS spdMain_CellDoubleClick 헤더 분기 / mkt-fcst 1:1) —
    //   W_ 헤더('SUM' leaf) 더블클릭 = 해당 주(다음 W_/M_ 전까지) D_ 토글 → 일자별 컬럼 표시/접기.
    //   M_ 헤더 더블클릭 = 해당 월(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기.
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);

      // ⭐ [No.65 2026-08-14] FPModal 셀 더블클릭 → 검색 모달 (DMF0003 MktFcstGrid L1156~1160 1:1).
      //   공용 DataGrid 는 FPModal 셀의 직접 편집을 취소하므로(dataGridUtils.setEditableColumns),
      //   모달을 열어주지 않으면 그 컬럼은 **입력 수단이 없다** — 통합테스트 No.65 "Project 컬럼이 없음".
      //   헤더 드릴다운 분기보다 먼저 본다 (셀 영역이라 서로 겹치지 않는다).
      if (ht.cellType === CellType.Cell && ht.row >= 0 && ht.col >= 0) {
        const cellBinding = g.columns[ht.col]?.binding ?? '';
        const modalKey = modalCellRef.current.get(cellBinding);
        if (modalKey) {
          const item = g.rows[ht.row]?.dataItem as WijmoRowItem | undefined;
          // 신규행만 — 조회행의 키 컬럼은 AS-IS 도 잠금(수정 대상 아님).
          if (item && isInsertRow(item)) {
            onPopupCellDblClickRef.current?.(modalKey, item);
            return;
          }
        }
      }

      if (ht.cellType !== CellType.ColumnHeader) return;
      // 머지된 상위 헤더 → 그룹 대표 binding 복원 (사용자 보고 2026-07-29 "접기가 SUM 위에서만 먹힘").
      //   hitTest 는 커서 아래 물리 컬럼을 준다(머지 원점이 아니다). 주를 일자로 펼치면 2단
      //   'W31' 그룹이 [W_ SUM, D_27…D_31] 로 머지되고 라벨은 그 가운데 = D_ 컬럼들 위에 그려진다.
      //   그대로 두면 hb 가 D_ 로 잡혀 아래 M/W 가드에 걸리고, 좌단(SUM) 위에서만 접기가 된다.
      //   접기 전에는 그룹이 1칸이라 어디를 눌러도 W_ 가 잡히므로 펼치기만 되고 접기는 죽는 비대칭.
      //     1단(년월) = M_${ym} 로 직접 산출 — chkSum OFF 로 M_ 컬럼이 숨어도 dynBindings 에는 있다
      //       (머지 좌단을 쓰면 M_ 가 숨은 순간 첫 주 W_ 를 집어 월 드릴이 주 드릴로 바뀐다).
      //     2단(주차) = 머지 범위 좌단 — dynamicColumns 가 그룹 내 M<W<D 로 정렬하므로 좌단이 W_.
      //   leaf 행(주차/일자 낱개 컬럼)은 물리 컬럼이 곧 대상이라 손대지 않는다.
      const leafRow = g.columnHeaders.rows.length - 1;
      let hb = g.columns[ht.col]?.binding ?? '';
      if (kindOf(hb) && ht.row < leafRow) {
        if (ht.row === 0) {
          hb = `M_${hb.slice(2, 8)}`;
        } else {
          const merged = g.getMergedRange(g.columnHeaders, ht.row, ht.col);
          if (merged) hb = g.columns[merged.leftCol]?.binding ?? hb;
        }
      }
      const hk = kindOf(hb);
      if (hk !== 'M' && hk !== 'W') return;
      const idx = dynBindings.indexOf(hb);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const col = g.getColumn(target);
        if (!col) return;
        if (hideOnly && !col.visible) return; // M_ 드릴: 보이는 D_ 만 접기
        drillVisRef.current.set(target, hideOnly ? false : !col.visible);
      };
      for (let i = idx + 1; i < dynBindings.length; i++) {
        const t = dynBindings[i];
        const tk = kindOf(t);
        if (hk === 'M') {
          if (tk === 'M') break;
          if (tk === 'W') flip(t, false);
          else if (tk === 'D') flip(t, true);
        } else {
          if (tk === 'W' || tk === 'M') break;
          if (tk === 'D') flip(t, false);
        }
      }
      applyDynVisibilityRef.current?.();
    };

    // ⭐ 동적(M_/W_/D_) 헤더 정렬 차단 (사용자 요구 2026-07-22) — 주차/SUM 단일클릭 시 공용
    //   DataGrid `setSortableColumnHeaderClick` 가 정렬을 걸고 `select(-1,-1)+scrollIntoView(0,0)` 로
    //   그리드를 맨 앞으로 스크롤한다. 그 스크롤 탓에 뒤이은 dblclick 의 hitTest 가 앞쪽 컬럼을 집어
    //   드릴다운(특히 October M_)이 죽는다. allowSorting=false 재설정은 columnGroups 재적용과 경쟁해
    //   클릭 순간을 못 막으므로, **capture 단계**에서 동적 헤더 click 을 선점 차단한다.
    //   (click 대상은 셀=하위 요소 → hostElement 의 capture 가 공용 bubble 핸들러보다 먼저 실행.
    //    dblclick 은 건드리지 않아 드릴다운은 그대로 동작. 정적 컬럼 정렬은 유지 — kindOf 대상만 차단.)
    const dynHeaderSortGuard = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
      if (!kindOf(hb)) return;
      ev.stopImmediatePropagation();
    };

    g.beginningEdit.addHandler(cellEditableHandler);
    g.pastingCell.addHandler(cellEditableHandler);
    g.cellEditEnded.addHandler(cellEditHandler);
    g.pastedCell.addHandler(cellEditHandler);
    g.formatItem.addHandler(formatHandler);
    g.hostElement.addEventListener('keydown', keydownHandler);
    g.hostElement.addEventListener('dblclick', dblclickHandler);
    // capture 단계 등록 — 공용 setSortableColumnHeaderClick(bubble)보다 먼저 실행돼 정렬 선점 차단.
    g.hostElement.addEventListener('click', dynHeaderSortGuard, true);

    return () => {
      g.beginningEdit.removeHandler(cellEditableHandler);
      g.pastingCell.removeHandler(cellEditableHandler);
      g.cellEditEnded.removeHandler(cellEditHandler);
      g.pastedCell.removeHandler(cellEditHandler);
      g.formatItem.removeHandler(formatHandler);
      g.hostElement.removeEventListener('keydown', keydownHandler);
      g.hostElement.removeEventListener('dblclick', dblclickHandler);
      g.hostElement.removeEventListener('click', dynHeaderSortGuard, true);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, dynamicColumns]);

  // ⭐ 다단 헤더 높이 48px 고정 (#93) — 실헤더 행 수로 나눠 각 행 height 명시 설정 (mkt-fcst 방식).
  //   wrapper 의 defaultSize 만으로는 동적 config height 가 만든 explicit row height 에 덮여 무효 →
  //   각 헤더행 height 를 직접 세팅. updatedLayout 마다 재적용(columnGroups rebuild 후 리셋 대응).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      if (
        Math.round(headerRows.defaultSize) === per &&
        Math.round(headerRows[0]?.height ?? 0) === per
      ) {
        return;
      }
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();
    return () => {
      try {
        g.updatedLayout.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynamicColumns, gridRef]);

  // ⭐ 동적 컬럼 표시 통합 (chkSum + 헤더 드릴다운, mkt-fcst 패턴 1:1) —
  //   활성 bucket=표시 / 상위 합계=sumYn / 하위=숨김 → 셋 다 드릴 오버라이드(drillVisRef) 우선.
  //   wrapper 의 columnGroups 재적용이 visible 을 덮으므로 updatedLayout 마다 재적용. 조회 없이 즉시 반영.
  const sumYn = searchParams.sumYn;
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    drillVisRef.current.clear(); // bucket/sum/조회 변경 = AS-IS SetSpreadColumn 재실행 → 드릴 리셋
    const summarySet = new Set(summaryBindings);
    const drillSet = new Set(drillBindings);
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        // ⭐ 동적 컬럼 정렬 금지 (사용자 요구 2026-07-22) — 헤더 클릭 시 정렬이 걸려 드릴다운이
        //   오작동한다. 공용 DataGrid 는 **컬럼 객체의 allowSorting** 으로 정렬 아이콘과 클릭을
        //   판정하므로(dataGridUtils `formatSortableColumns` / `setSortableColumnHeaderClick`),
        //   dynamicColumns config 의 allowSorting:false 가 columnGroups 재적용으로 되살아나도
        //   여기서 매 updatedLayout 마다 다시 눌러 확정한다. 정적 컬럼은 정렬 유지(dynSet 만 대상).
        if (col.allowSorting) col.allowSorting = false;
        const base = summarySet.has(b) ? sumYn : drillSet.has(b) ? false : true;
        const want = drillVisRef.current.get(b) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      // 실적/계획 경계선 대상 재산출 — 가시성이 확정된 직후가 유일한 정확한 시점이다
      //   (드릴다운/chkSum 이 곧 판정 입력). 값이 바뀌면 invalidate 를 강제해 formatItem 을 다시 태운다
      //   — 컬럼 visible 이 그대로여도(첫 레이아웃 등) 선 위치는 바뀔 수 있다.
      const boundary = findActualBoundaryBinding(dynBindings, currentPeriodRef.current, b => {
        const col = g.getColumn(b);
        return !!col && col.visible;
      });
      if (boundary !== actualBoundaryRef.current) {
        actualBoundaryRef.current = boundary;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    applyDynVisibilityRef.current = applyDynVisibility;
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
  }, [sumYn, summaryBindings, drillBindings, dynBindings, dynamicColumns, gridRef]);

  return (
    <DataGrid<ForecastPriceRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      // ⭐ 메타 셀 콤보의 @토큰 해소 (정본 mkt-fcst MktFcstGrid — 2026-07-20 measure 코드 표시 사고 대응).
      //   `Measure` CMBO 는 `WHERE A.PROGRAM_ID = @mnuId` 라 미전달 시 '' 치환 → SHEET_MEASURE 0행 →
      //   CODE→NAME 매핑 부재 → 그리드가 measure **코드를 raw 로 표시**한다(DMF0082 measure 14종 전부).
      //   ⭐ [2026-08-18 사용자 확정] divisionId 를 **전달한다**. 종전엔 "전 셀 콤보 일괄 spread 로
      //     관대형 콤보가 전체→division 한정으로 바뀐다"는 이유로 제외했으나, 이 화면은 division
      //     스코프 화면이라 좁혀지는 쪽이 정상이다. 특히 **Insert 행에서 타 division 의 End Customer
      //     를 고를 수 있으면 안 된다**(사용자 지적).
      //     사내 실측(2026-08-18) — 셀 콤보 19종 중 @divisionId 토큰 보유는 5종뿐이고 전부 관대형,
      //     전달 시 0행 되는 콤보 없음:
      //       EndCustomerByDivisionDMF0082 7,228→1,338 / SiteByEndCustomer 2,532→461 /
      //       PlantByDivisionCompany 45→12 / FcstTypeByUserGroupDMF0082 14→4 / CELL_PROD_SITE_ID 4→1
      //     나머지 14종(Measure·Incoterms·CurrencyList 등)은 토큰이 없어 무영향.
      comboParams={{ mnuId: `'${MENU_ID}'`, divisionId: q(searchParams.divisionId) }}
      // ⭐ [E20260901-CPSDISP] Cell Prod Site 표시 콤보는 **파라미터 없이**(전체 목록) 조회한다.
      //   이 콤보는 division 을 받으면 AS-IS BIZ_TYPE 분기로 '-'(Common) 1행만 반환해(실측: 무파라미터
      //   5행 / divisionId 전달 1행), 그 축소본이 dataMap 이 되면 원장 코드(HQ06-A 등)가 CODE→NAME
      //   매핑을 잃고 raw 코드로 표시된다(사용자 신고 2026-09-01). 편집 후보 제한은 행별
      //   applyCellProdSites(division+item)가 계속 담당 — "표시용 ↔ 편집용 이원화" 규약.
      comboParamExcludes={['CELL_PROD_SITE_ID']}
      selectionMode={SelectionMode.MultiRange}
      allowMerging={AllowMerging.All}
      alternatingRowStep={1}
      useSummaryTooltip
      useResultColumns
      useHotkey
    />
  );
};
