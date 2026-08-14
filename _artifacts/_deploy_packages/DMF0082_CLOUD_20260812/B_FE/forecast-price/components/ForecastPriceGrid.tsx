import type { GridPanel } from '@mescius/wijmo.grid';
import {
  type FlexGrid,
  AllowMerging,
  CellRange,
  CellType,
  DataMap,
  SelectionMode,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import type { ComboResponse, FlexGridColumnConfig } from '@foundation/models';
import { CustomMergeManager, EditTracker, isNonEditableDateColumn } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  AUTH_MEASURES,
  GRID_EDIT_COMBO,
  MENU_ID,
  PRICE_MEASURES,
} from '../forecast-price.constants';
import type { ForecastPriceRow, SpreadTitleRow } from '../forecast-price.types';
import { useForecastPriceStore } from '../useForecastPriceStore';
import { isAsFromSiteEditable } from '../utils/forecast-price.asFromSite';
import { q } from '../utils/forecast-price.combo';
import { thisWeekMondayYmd } from '../utils/forecast-price.editLock';

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
  isNonEditableCell,
  toNumber,
  type CalendarInfo,
} from './ForecastPriceGridUtils';

interface ForecastPriceGridProps {
  gridRef: MutableRefObject<FlexGrid<ForecastPriceRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ForecastPriceRow[];
  spreadTitle: SpreadTitleRow[];
  editTrackerRef: MutableRefObject<EditTracker | null>;
  // #10 — Insert 행 키 중복(MSG00260) 발생 시 페이지 alert 호출.
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
}: ForecastPriceGridProps) => {
  const monthMap = useRef<Map<string, Set<string>>>(new Map());
  const weekMap = useRef<Map<string, Set<string>>>(new Map());
  const bucketRef = useRef<string>('W');

  const searchParams = useForecastPriceStore(state => state.searchParams);
  const staticColumns = useForecastPriceStore(state => state.staticColumns);
  const measureAuth = useForecastPriceStore(state => state.measureAuth);
  const measureAuthRef = useRef(measureAuth);
  measureAuthRef.current = measureAuth;

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
  const editComboEntries = useMemo(() => Object.entries(GRID_EDIT_COMBO), []);
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
  const [asSiteRows, asIncotermsRows, wsFcstTypeRows] = useTabComboQueries({
    filters: [
      { comboId: 'AS_FROM_SITE', param1: q(searchParams.divisionId) },
      { comboId: 'AsIncotermsEdit', divisionId: q(searchParams.divisionId) },
      // [No.63-② 2026-08-11] AS From Site 편집 활성 판정용 FCST Type 기준 목록.
      //   AS-IS `GetLookupValues("FCST_TYPE", "DM Planner (W/S)")` → `UP_FX_GetCommonDataList_DM` L72~79 =
      //   LOOKUP_TYPE 'SALES_TYPE_CODE2'(WS/WSF/AS/ASF 4종). TO-BE 등재본 = `FcstTypeWs`.
      //   ⚠ 현재 사용자 그룹과 무관한 **고정 참조 목록**이다(FcstTypeByUserGroupDMF0082 와 용도가 다름).
      { comboId: 'FcstTypeWs' },
    ],
    enabled: !!searchParams.divisionId,
  });
  const asSiteNamesRef = useRef<Set<string>>(new Set());
  // AS-IS 는 `dtAsSalesSite.Select("Name = '<SCM_SITE_ID>'")` 로 **NAME 만** 대조한다(.cs L3465·L3565).
  //   실데이터도 원장 SCM_SITE_ID = 'WA00-81-AS' 형태(= 콤보 NAME)이고 CODE('...-W')로는 쓰이지 않는다.
  //   위 `asSiteNamesRef`(NAME∪CODE)는 기존 Incoterms 스왑용이라 그대로 두고, 향 판정만 NAME 전용을 쓴다.
  const asSiteNameOnlyRef = useRef<Set<string>>(new Set());
  const asIncotermsMapRef = useRef<DataMap | null>(null);
  const asFromSiteMapRef = useRef<DataMap | null>(null);
  const wsFcstTypeSetRef = useRef<Set<string>>(new Set());
  useEffect(() => {
    const siteRows = (asSiteRows ?? []) as unknown as Record<string, unknown>[];
    asSiteNamesRef.current = new Set(
      siteRows.flatMap(r => [comboCellStr(r.NAME).trim(), comboCellStr(r.CODE).trim()]).filter(Boolean)
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
  }, [asSiteRows, asIncotermsRows, wsFcstTypeRows]);

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

  // ⭐ #7 Insert 행 편집가능 Measure 콤보 캐스케이드 (hook #59 §5-G / AS-IS L5839) —
  //   Site 변경 시 FcstPriceEditMeasure(div/site/bucket) 조회해 행별 후보 캐시 → MEASURE 편집 진입 시
  //   컬럼 dataMap 스왑(편집 후보=편집가능 measure), 편집 종료 시 원 dataMap(전체 표시용) 원복.
  const editMeasuresRef = useRef<WeakMap<object, ComboResponse[]>>(new WeakMap());
  const measureOrigDataMapRef = useRef<DataMap | null>(null);
  // D9 — 행별 Cell Prod Site 후보 캐시 (ITEM_ID 변경 시 재조회).
  const cellProdSitesRef = useRef<WeakMap<object, ComboResponse[]>>(new WeakMap());
  // 행별 Sales Site 후보 캐시 (END_CUSTOMER 변경 시 재조회).
  const salesSitesRef = useRef<WeakMap<object, ComboResponse[]>>(new WeakMap());

  // ⭐ #2 SALES_BUCKET 캐스케이드 (AS-IS L5862~5874) — Insert 행에서 Sales Site / Incoterms 변경 시
  //   배분 요일비트(SUN-first 7자리)를 조회해 행 BUCKET 에 세팅. 결과 없으면 '' → 배분은 기본요일 적용.
  //   (BUCKET 은 divideBy*/allocateLoc 가 다음 수량 편집 때 읽음 — AS-IS 도 세팅만.)
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
  const authGroup = useForecastPriceStore(state => state.authGroup);
  const authGroupRef = useRef(authGroup);
  authGroupRef.current = authGroup;
  const applyEditMeasures = (dataItem: WijmoRowItem) => {
    const div = String(dataItem['DIVISION_ID'] ?? '');
    const site = String(dataItem['SCM_SITE_ID'] ?? '');
    if (!div || !site) return;
    void apiClient
      .getCombo({
        comboId: 'FcstPriceEditMeasure',
        divisionId: q(div),
        scmSiteId: q(site),
        bucketType: q(bucketTypeParamRef.current),
      })
      .then(rows => {
        // [No.63 그룹 축] AS-IS DMF0003_MktFcst.cs E20260402-001736 1:1 — 81계열/82 에서
        //   DM Planner (W/S) 가 아니면 AS_In_Req 를 후보에서 제거한다.
        let out = rows ?? [];
        if (
          (div.startsWith('81') || div === '82') &&
          authGroupRef.current !== 'DM Planner (W/S)'
        ) {
          out = out.filter(r => String(r.CODE) !== 'AS_In_Req');
        }
        return editMeasuresRef.current.set(dataItem, out);
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
  const applySalesSites = (dataItem: WijmoRowItem) => {
    const div = String(dataItem['DIVISION_ID'] ?? '');
    const cust = String(dataItem['END_CUSTOMER'] ?? '');
    if (!div) return;
    void apiClient
      .getCombo({ comboId: 'SiteByEndCustomer', divisionId: q(div), endCustomer: q(cust) })
      .then(rows => salesSitesRef.current.set(dataItem, rows ?? []))
      .catch((err: unknown) => {
        console.error('[combo] SiteByEndCustomer 조회 실패 — 전체 목록으로 폴백', err);
      });
  };

  // ⭐ D9 — Insert 행 Model(ITEM_ID) 변경 시 Cell Prod Site 후보 재조회 (AS-IS
  //   `Data.Common(Type.CELL_PROD_SITE_ID, division, itemId)` = `UP_FX_GetCommonDataList @Code='CELL_PROD_SITE_ID'`,
  //   .cs L5854). AS-IS SP 는 PARAM1(division) 유무로 분기해, 이벤트 호출 시 해당 품목의 BIZ_TYPE 이
  //   CELL 이 아니면 '-'(Common) 만 남긴다. CMBO 가 여분 컬럼을 반환하지 않아 클라 필터가 불가 →
  //   Measure 와 동일하게 행별 서버 재조회 + WeakMap 캐시로 처리한다.
  const applyCellProdSites = (dataItem: WijmoRowItem) => {
    const div = String(dataItem['DIVISION_ID'] ?? '');
    const item = String(dataItem['ITEM_ID'] ?? '');
    if (!div || !item) return;
    void apiClient
      .getCombo({ comboId: 'CELL_PROD_SITE_ID', divisionId: q(div), itemId: q(item) })
      .then(rows => cellProdSitesRef.current.set(dataItem, rows ?? []))
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

  // #12 당주(현재 기간) binding 집합 — 활성 버킷의 당월(M_)/당주(W_)/금주월요일(D_) 녹색 보더.
  const currentPeriodRef = useRef<Set<string>>(new Set());
  currentPeriodRef.current = useMemo(() => {
    const ym = dayjs().format('YYYYMM');
    const wk = String(dayjs().isoWeek()).padStart(2, '0');
    return new Set([`M_${ym}`, `W_${ym}${wk}`, `D_${thisWeekMondayYmd()}`]);
  }, []);

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
    const subOrder = (k: string): number => (k === 'SUM' ? -1 : Number(k.replace(/\D/g, '') || 0));
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

  // ── grid 핸들러 등록 (useEffect + gridRef, deps=[staticColumns, dynamicColumns], cleanup 의무) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    editTrackerRef.current = new EditTracker(g as FlexGrid);
    if (!gridFilterRef.current) {
      // 동적(M_/W_/D_) 컬럼은 필터 제외 — 정적 컬럼만 필터 대상.
      gridFilterRef.current = new FlexGridFilter(g as FlexGrid, {
        filterColumns: staticColumns.map(c => c.colNm ?? '').filter(Boolean),
      });
    }

    // 편집 가능 판정 — AS-IS 권한 4분기(bEDIT_AUTH_*, GET drop3) + GridUtils 공통 판정.
    const canEditCell = (binding: string, dataItem: WijmoRowItem): boolean => {
      const measure = dataItem['MEASURE'];
      if (typeof measure !== 'string') return false;
      // 권한 대상 measure(4종) 외 = 항상 read-only / 대상인데 그룹권한 N = 차단.
      if (!(AUTH_MEASURES as readonly string[]).includes(measure)) return false;
      if (measureAuthRef.current[measure] === false) return false;
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
        // 정적 컬럼: Insert 행(CRUD_TYPE 존재)만 편집 (AS-IS: 기존 행 키 컬럼 잠금)
        const isInsert = dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null;
        if (!isInsert) {
          e.cancel = true;
          return;
        }
        // [No.35 2026-08-11] 신규행 입력 컬럼 = UI Category Setup `INPUT_TP_CD`(IM/IO/M/O) 한정 —
        //   통합테스트 1st "As-Is 기준 입력 가능한 컬럼은 8개"(End Customer/Sales Site/Model/Incoterms/
        //   FCST Type/Customs Handbook[DOM_EXP]/Cell Prod Site/Currency + Measure 콤보). 종전에는
        //   Insert 행이면 **전 정적 컬럼**이 열려 있었다(hook #130 A 메타 실소비 — 하드코딩 아닌 메타 판정).
        const inputTp = inputTpRef.current.get(binding);
        if (!(inputTp === 'IM' || inputTp === 'IO' || inputTp === 'M' || inputTp === 'O')) {
          e.cancel = true;
          return;
        }
        // [No.63-① ② 2026-08-11] AS From Site — 메타는 IO 로 열되(전 division 공통 1값), 실제 활성은
        //   division × Sales Site 향 × FCST Type 으로 좁힌다. 40 은 여기서 전부 차단되어 No.35(입력 8컬럼) 유지.
        if (binding === 'AS_FROM_SITE') {
          if (!asFromSiteEditable(dataItem)) {
            e.cancel = true;
            return;
          }
          const asCol = sender.columns[e.col];
          if (asCol && asFromSiteMapRef.current) {
            if (!(binding in origDataMapRef.current))
              origDataMapRef.current[binding] = (asCol.dataMap as DataMap) ?? null;
            asCol.dataMap = asFromSiteMapRef.current;
          }
          return;
        }
        // #7 — MEASURE 편집 진입: 행별 편집가능 후보로 컬럼 dataMap 스왑 (원본은 1회만 백업 → 편집 종료 시 원복).
        if (binding === 'MEASURE') {
          const candidates = editMeasuresRef.current.get(dataItem);
          const col = sender.columns[e.col];
          if (candidates && candidates.length > 0 && col) {
            if (!measureOrigDataMapRef.current)
              measureOrigDataMapRef.current = col.dataMap as DataMap;
            col.dataMap = new DataMap(candidates as unknown[], 'CODE', 'NAME');
          }
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
      if (kindOf(binding) && !canEditCell(binding, dataItem)) e.cancel = true;
    };

    // 편집 종료 — 월/주/일 배분 (AS-IS spdMain_EditChange 분배 로직 1:1, GridUtils 재사용).
    const cellEditHandler = (sender: FlexGrid, e: { row: number; col: number; data?: unknown }) => {
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem) return;
      // #7 — MEASURE 편집 종료: 스왑했던 dataMap 을 원본(전체 표시용)으로 원복 (취소 포함 커버).
      if (binding === 'MEASURE' && measureOrigDataMapRef.current) {
        const col = sender.columns[e.col];
        if (col) col.dataMap = measureOrigDataMapRef.current;
      }
      // ⭐ UP_FX 편집 콤보 원복 — 스왑이 남으면 필터 밖 CODE 를 가진 **다른 행**의 명칭 변환이 깨진다
      //   (편집 취소 경로도 cellEditEnded 를 타므로 여기서 일괄 원복. 정본 mkt-fcst:926-939).
      if (binding in origDataMapRef.current) {
        const col = sender.columns[e.col];
        if (col) col.dataMap = origDataMapRef.current[binding] ?? null;
      }
      const isInsertRow = dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null;
      // #2 — Insert 행 Site/Incoterms 변경 → SALES_BUCKET 조회·세팅 (배분 요일 원천).
      //   #7 — Site 변경 시 편집가능 Measure 후보도 재조회(행별 캐시).
      if ((binding === 'SCM_SITE_ID' || binding === 'INCOTERMS') && isInsertRow) {
        applySalesBucket(dataItem);
      }
      // ⭐ 편집가능 Measure 재조회 — AS-IS 는 **6개 지점**에서 재조회한다:
      //   InsertRow(.cs L2621 — 위 프라이밍 effect) / 셀변경(L5841) / Paste(L7922·L8027) /
      //   ComboSelChange Division(L8261) / ComboSelChange Sales Site·Incoterms(L8308).
      //   후보는 서버(`FcstPriceEditMeasure`)가 **사이트 특성(SCM_MST_SITE.VMI_YN)** 과 bucket(D→LOC 제외)로
      //   가리므로, 이 키들이 바뀌면 반드시 다시 물어야 한다. 구 코드는 SCM_SITE_ID 하나뿐이었다.
      if (
        (binding === 'SCM_SITE_ID' || binding === 'DIVISION_ID' || binding === 'INCOTERMS') &&
        isInsertRow
      ) {
        applyEditMeasures(dataItem);
      }
      // D9 — Model(ITEM_ID) 변경 → Cell Prod Site 후보 재조회 (AS-IS .cs L5854).
      //   Division 변경도 CMBO 바인드(@divisionId)에 들어가므로 함께 재조회.
      if ((binding === 'ITEM_ID' || binding === 'DIVISION_ID') && isInsertRow)
        applyCellProdSites(dataItem);
      // End Customer 변경 → Sales Site 후보 재조회 (AS-IS .cs L8237·8283·8294).
      if ((binding === 'END_CUSTOMER' || binding === 'DIVISION_ID') && isInsertRow)
        applySalesSites(dataItem);
      // [No.63-① ② 2026-08-11] Sales Site / FCST Type 변경으로 AS From Site 조건이 깨지면 **값도 비운다** —
      //   AS-IS 는 잠글 때마다 `SetText(AS_FROM_SITE, "")` 를 함께 호출한다(.cs L3481·3506·3587·3597).
      //   비우지 않으면 비축향으로 바꾼 뒤에도 이전 고객향 값이 payload 로 저장된다.
      if (
        (binding === 'SCM_SITE_ID' || binding === 'FCST_TYPE' || binding === 'DIVISION_ID') &&
        isInsertRow &&
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

      if (kindOf(binding)) {
        const editable = canEditCell(binding, dataItem);
        e.cell.classList.toggle('wj-cell-editable', editable);
        // 기준주차 이전 = 잠금 Gray (특수셀 한정 — 전체 회색 금지)
        e.cell.classList.toggle(
          'wj-cell-non-editable',
          isNonEditableDateColumn(binding, weekMap.current)
        );
        // #12 본문 셀 초록 보더 제거 — AS-IS 화면 캡처에는 본문에 초록 선이 없다(사용자 확정 2026-07-22).
        //   당주 강조는 헤더 초록 볼드가 전담(위 ColumnHeader 분기). 잔여 inline 스타일 정리 위해 '' 유지.
        e.cell.style.boxShadow = '';
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
      // 정적 컬럼: Insert 행만 Yellow
      const isInsert = dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null;
      e.cell.classList.toggle('wj-cell-editable', isInsert);
      // ⭐ 개인화 색 — 우선순위: Insert 편집셀 Yellow(클래스) > 저장된 Cell Color > 기본(제거).
      //   inline !important 라 클래스보다 세므로 insert 행에는 배경을 칠하지 않는다.
      //   미지정 시 removeProperty 필수 — Wijmo 셀 재활용으로 이전 행 색이 남는다.
      const personalColor = colorMetaRef.current.get(binding);
      if (!isInsert && personalColor?.cell) {
        e.cell.style.setProperty('background-color', personalColor.cell, 'important');
      } else {
        e.cell.style.removeProperty('background-color');
      }
      if (personalColor?.text) {
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
              if (dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null)
                dataItem[binding] = null;
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
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
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
      //   ⚠️ divisionId 는 넣지 않는다 — DataGrid 는 comboParams 를 전 셀 콤보에 일괄 spread 하므로
      //     관대형(@divisionId IS NULL OR …) 콤보들이 한꺼번에 "전체"→"division 한정"으로 바뀐다.
      //     행 단위 종속은 GRID_EDIT_COMBO 스왑 경로가 담당한다.
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      selectionMode={SelectionMode.MultiRange}
      allowMerging={AllowMerging.All}
      alternatingRowStep={1}
      useSummaryTooltip
      useResultColumns
      useHotkey
    />
  );
};
