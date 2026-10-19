import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import styles from 'features/demand/src/pages/sales-plan/SalesPlan.module.scss';
import { type MutableRefObject, type Ref, useCallback, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, keepRowVisibleUnderFilter, paintNegativeText } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { isoWeeksOfMonth } from '@shared/lib/bucket-distribution';
import { useMessageStore } from '@shared/stores';

import {
  BUCKET_TYPE,
  DEPT_CASCADE_CLEAR_NON40,
  EDIT_MEASURE,
  GRID_CASCADE_CLEAR,
  INSERT_DEFAULT_FCST_TYPE,
  MENU_ID,
  MSG,
  SHEETS,
} from '../sales-plan.constants';
import type {
  CalendarInfo,
  EditAuthInfo,
  MeasureInfoRow,
  SalesPlanRow,
  SpreadTitleRow,
} from '../sales-plan.types';
import { isDiv40 } from '../utils/sales-plan.division';
import {
  buildCutoff,
  buildMeasureAuth,
  dynKindOf,
  evalSalesPlanDynCell,
  insertStaticEditable,
  isInsertModalCell,
} from '../utils/sales-plan.editLock';
import { applyMeasureSwitch, toCellStr } from '../utils/sales-plan.gridCombos';
import {
  getDynKey,
  getMonthWeekKeysInRange,
  HierarchicalMergeManager,
} from '../utils/sales-plan.merge';

// 동적 컬럼 kind 서열 — M(월)=0 상위 … D(일)=2 하위. 표시 규칙/드릴다운 판정용 (DMF0003 동일).
const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

interface Props {
  rows: SalesPlanRow[];
  gridRef: Ref<FlexGridType<SalesPlanRow>>;
  tabId: string;
  // F4 Filter — 피처가 FlexGridFilter 직접 소유. 필터후 머지/높이 재적용.
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  // F7 Save — EditTracker 로 변경 셀 추적(Red 마킹 단일 소스) + 비-insert 행 자동 CRUD_TYPE='M' 마킹.
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  // 셀 모달 3종 — PROJECT(81·82 신규행) / ITEM(40+Catch_Up 신규행) / TEAM(DEPT_ID 신규행,
  //   Catch_Up 제외). AS-IS spdMain_CellDoubleClick L3834/3863 + DEPT_ID 콤보→모달 전환(2026-09-18).
  onPopupCellDblClick?: (modalKey: 'PROJECT' | 'ITEM' | 'TEAM', row: SalesPlanRow) => void;
  divisionId?: string;
  bucketType?: BUCKET_TYPE;
  // Sum 체크박스 — 상위 버킷 합계 컬럼(M_/W_) 표시 토글 (AS-IS chkSum L4419 — 조회 없이 즉시 반영).
  sumYn?: boolean;
  currentYyyymmdd?: string;
  // 조회 기간 — GET_SPREAD_TITLE 이 월 시작 주만 내려줄 때 월경계 주차 binding 보완용.
  startYyyymmdd?: string;
  endYyyymmdd?: string;
  // admin SYS0004 UI Category Setup 동적 메타 (SHEET_COLUMNS 66건 — division 서버 필터, 하드코딩 fallback 없음).
  staticColumns?: RawFlexGridColumnConfig[];
  // P_DMF0021_GET_SPREAD_TITLE 결과 — 동적 3단 헤더(라벨/정렬/구조)의 1차 소스.
  spreadTitle?: SpreadTitleRow[];
  // MAIN 커서 2/3 — 기준일(editLock cutoff — 클라 시계 금지) / measure 편집권한.
  calendarInfo?: CalendarInfo | null;
  editAuth?: EditAuthInfo | null;
  // Insert 행 MEASURE 편집 콤보 (GET_SALES_PLAN_MEASUREINFO — 40 전용 편집, 기본 SalesAmt_LOC).
  measureInfoRows?: MeasureInfoRow[];
}

// 숫자 변환 — 콤마 제거, 비숫자 0.
const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  const n = typeof v === 'number' ? v : Number(toCellStr(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

// ⭐ 행별 NOTATION 숫자 포맷 (AS-IS Draw L1696~1762 SetRowFormat — INTEGER/POINT/POINT3, 82 메저별 표기
//   [E20231128-000738]). 0/null/빈 셀 = 빈칸.
const formatByNotation = (v: unknown, notation: string): string => {
  if (v == null || v === '' || v === 0) return '';
  const n = toNumber(v);
  if (n === 0) return '';
  if (notation === 'INTEGER') return Math.trunc(n).toLocaleString();
  if (notation === 'POINT3')
    return n.toLocaleString(undefined, { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  if (notation === 'POINT') return n.toLocaleString(undefined, { maximumFractionDigits: 1 });
  return n.toLocaleString(undefined, { maximumFractionDigits: 3 });
};

export const SalesPlanGrid = ({
  rows,
  gridRef,
  // tabId 는 Props 계약상 유지(부모 전달) — 현재 그리드 내부 조회가 없어 소비하지 않는다.
  gridFilterRef,
  editTrackerRef,
  onPopupCellDblClick,
  divisionId,
  bucketType = BUCKET_TYPE.MONTHLY,
  sumYn = false,
  currentYyyymmdd = '',
  startYyyymmdd = '',
  endYyyymmdd = '',
  staticColumns,
  spreadTitle,
  calendarInfo,
  editAuth,
  measureInfoRows,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const division = divisionId ?? '';
  // 필터 예외 재등록(reapplyInsertRowVisibility)이 최신 rows 를 보게 하는 미러.
  const rowsRef = useRef<SalesPlanRow[]>([]);
  rowsRef.current = rows;

  // ⭐ [통합테스트 1st No.61-③ 2026-08-12] 신규행 Model = AS-IS `SALES_PLAN_ITEM_ID` lookup 1:1
  //   (.cs L525 Data.Common(SALES_PLAN_ITEM_ID) + GUBUN division 분기 L3341~3352).
  //   구 COM0008 itemByDivision(아이템 마스터 전체)은 오구현 — Insert 는 기타매출 특수코드
  //   (ETC/Tooling/MDF 등 division 별 lookup 등재분)만 허용. CMBO 'SalesPlanItemId' 신설분 소비.
  const [salesPlanItemRows] = useTabComboQueries({
    filters: [{ comboId: 'SalesPlanItemId', divisionId: `'${division || 'ALL'}'` }],
  });
  // 선택 코드로 ITEM_CLASS_NAME 을 파생하는 조회용이자, 아래 신규행 전용 콤보의 후보 원본.
  const itemDropdownRows = useMemo(
    () => (salesPlanItemRows ?? []) as unknown as Record<string, unknown>[],
    [salesPlanItemRows]
  );
  const itemDropdownRowsRef = useRef(itemDropdownRows);
  itemDropdownRowsRef.current = itemDropdownRows;

  const bucketPrefix =
    bucketType === BUCKET_TYPE.MONTHLY ? 'M' : bucketType === BUCKET_TYPE.DAILY ? 'D' : 'W';

  // ⭐ editLock cutoff/권한 — MAIN 커서 2/3 원천 (formatItem 배경색 + beginningEdit cancel 공유).
  const cutoff = useMemo(() => buildCutoff(calendarInfo ?? null), [calendarInfo]);
  const auth = useMemo(() => buildMeasureAuth(editAuth ?? null), [editAuth]);

  // ⭐ 당월/당주 binding 집합 — 헤더 Green Bold + 데이터셀 세로 레일 (AS-IS chkColor OFF 기본 경로
  //   L3549~3578·L1898~1913. 기준 = 커서 2 THIS_YYYYMM/THIS_YYYYMMWW — 클라 시계 금지).
  const currentPeriodBindings = useMemo<Set<string>>(() => {
    const s = new Set<string>();
    const m = (calendarInfo?.THIS_YYYYMM ?? '').toString().trim();
    const w = (calendarInfo?.THIS_YYYYMMWW ?? '').toString().trim();
    if (m) s.add(m.startsWith('M_') ? m : `M_${m}`);
    if (w) s.add(w.startsWith('W_') ? w : `W_${w}`);
    const d = String(calendarInfo?.BASIS_DATE ?? currentYyyymmdd).replace(/[^0-9]/g, '');
    if (/^\d{8}$/.test(d)) s.add(`D_${d}`);
    return s;
  }, [calendarInfo, currentYyyymmdd]);
  const currentPeriodBindingsRef = useRef(currentPeriodBindings);
  currentPeriodBindingsRef.current = currentPeriodBindings;

  // ⭐ 정적 컬럼 — admin(UI Category Setup) 메타 100% 주도. 하드코딩/화이트리스트 금지 (사용자 룰 2026-07-15.
  //   구 MEASURE 강제표시 예외 제거 — 사내 실측 VISIBLE_FLAG='Y' 로 예외 자체가 불필요였음).
  //   ① DIVISION_ID 가시성 = PR_GET_SHEET_COLUMN_LIST(divisionId 파라미터)가 DIVISION_ID 를 "직접 비교"
  //      필터해 반환 (실측: 40=46/81=32/''=62행). ATTRIBUTE1/3 우회 비교 금지 — 사용자 룰
  //      (hook ui-category-division-direct-compare). fetch 가 divisionId 전송 = 서버 필터 완결.
  //   ② FE 는 VISIBLE_FLAG(admin 관리 노출) + DISPLAY_FLAG(사용자 Column Setup 선택) 만 반영.
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.colNm), [visibleColumns]);
  const staticBindingSet = useMemo(() => new Set(fixedBindings), [fixedBindings]);

  // 컬럼 개인화 색 (ColumnLayoutModal 저장값) — binding → {cell, text}.
  //   공용 DataGrid 는 colWth/display 만 옮기고 색은 안 넘기므로 formatItem 이 직접 적용한다
  //   (mkt-fcst/forecast-price 선례 동일). ref 로 최신 맵 전달 — 핸들러 재등록 불필요.
  const colorMetaRef = useRef<Map<string, { cell: string; text: string }>>(new Map());
  colorMetaRef.current = useMemo(() => {
    const m = new Map<string, { cell: string; text: string }>();
    (staticColumns ?? []).forEach(c => {
      if (c.cellColor || c.textColor) {
        m.set(c.colNm, { cell: c.cellColor ?? '', text: c.textColor ?? '' });
      }
    });
    return m;
  }, [staticColumns]);

  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
        ...c,
        visible: true,
        display: true,
      })),
    [visibleColumns]
  );

  // 금지: 여기서 DataMap 을 만들어 col.dataMap 에 붙이지 말 것. 셀 콤보의 후보·표시·행별 좁힘은
  //   전부 컬럼 메타(cellCboDataTp / PARAM2 / PARAM9 / PARAM10)가 단일 원천이고 공용 DataGrid 가
  //   그 메타대로 만든다(foundation getDataMap / getRowParamDataMap). 화면이 col.dataMap 을 덮으면
  //   그 설정이 통째로 무효가 된다 — Sales Site(PARAM10='D')가 End Customer 를 바꿔도 이전 목록을
  //   그대로 들고 있던 원인이 이 덮어쓰기였다 (2026-09-01).
  // Team(DEPT_ID)은 콤보 편집 컬럼이라 공용 DataGrid 가 메타(cellCboDataTp)대로 맵을 만든다 —
  //   화면이 상위 선택에서 파생하지 않는다(구 TEAM_SOURCE 파생 조회 제거, 2026-09-08).

  // ===== 신규행 전용 셀 콤보 (ITEM_ID) =====
  // AS-IS 는 InsertRow 가 그 셀에만 콤보를 건다 — SetCellTypeCombo(ITEM_ID, dtITEM_ID GUBUN 분기)
  //   .cs L3341~3353. 조회 행은 텍스트다.
  // TO-BE admin 메타는 ITEM_ID 가 FPText 라 공용 DataGrid 의 콤보 경로를 아예 타지 않는다
  //   (공용 콤보/applyComboDataMaps 둘 다 cellCtrlObjTpCd=FPComboBox + cellCboDataTp 를 요구).
  //   그래서 이 컬럼만 화면이 직접 맡는다 — 화면 개별 하드코딩 (사용자 결정 2026-09-02).
  //   CURRENCY 는 admin 메타를 FPComboBox + cellCboDataTp=CURRENCY_LIST 로 전환해 공용 경로로
  //   넘겼다 (2026-09-04) — 파생/캐스케이드 로직이 없어 화면 하드코딩이 불필요했다.
  // 위 "col.dataMap 을 덮지 말 것" 금지와 충돌하지 않는다: 그 금지는 컬럼 메타(PARAM2/PARAM10)가
  //   만든 맵을 화면 스냅샷으로 덮는 경우를 막는 것이고, ITEM_ID 는 메타 콤보가 없어 공용
  //   계층이 dataMap 을 쓰지도 읽지도 않는다.
  // 조회 행 = 텍스트 유지 방법: 맵을 교체하지 않고 getDisplayValues 가 신규행에만 후보를 돌려준다
  //   (MEASURE/FCST_TYPE 와 같은 방식). 표시(CODE->NAME) 는 전 행 공통이라 조회 행 라벨도 맞는다.
  const insertOnlyDataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const build = (source: Record<string, unknown>[]): DataMap | null => {
      if (source.length === 0) return null;
      const map = new DataMap(source, 'CODE', 'NAME');
      const allDisplayValues = map.getDisplayValues.bind(map) as (item?: unknown) => string[];
      map.getDisplayValues = (item?: unknown): string[] => {
        const all = [...new Set(allDisplayValues(item))];
        // 행 컨텍스트 없는 호출(컬럼 필터 패널 등) 은 전체 목록을 유지한다 — 비우면 필터가 죽는다.
        if (!item) return all;
        return (item as SalesPlanRow).CRUD_TYPE === 'I' ? all : [];
      };
      return map;
    };
    return {
      ITEM_ID: build(itemDropdownRows),
    };
  }, [itemDropdownRows]);

  // 부착 — wijmo 는 columnGroups 재대입마다 Column 을 새로 만들어 dataMap 이 날아가므로
  //   updatedLayout 에서 다시 건다. 대상은 ITEM_ID(메타 콤보 없음)뿐이라 공용 계층이 만든
  //   맵을 덮을 여지가 없다. 금지: 여기에 다른 바인딩을 추가하지 말 것.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    if (!g) return;
    const attach = () => {
      Object.entries(insertOnlyDataMaps).forEach(([binding, map]) => {
        if (!map || !staticBindingSet.has(binding)) return;
        const col = g.getColumn(binding);
        if (col && col.dataMap !== map) col.dataMap = map;
      });
    };
    g.updatedLayout.addHandler(attach);
    attach();
    return () => {
      try {
        g.updatedLayout?.removeHandler(attach);
      } catch {
        /* unmount race */
      }
    };
  }, [insertOnlyDataMaps, staticBindingSet, gridRef]);

  // Insert 행에서 고를 수 있는 measure 코드 (GET_SALES_PLAN_MEASUREINFO — 기본 3종).
  //   dataMap 을 만들지 않고 '코드 집합' 으로만 쓴다 — 아래 installMeasureCandidateFilter 참조.
  const measureInfoCodes = useMemo(
    () =>
      new Set(
        (measureInfoRows ?? [])
          .map(r => toCellStr((r as Record<string, unknown>).CODE).trim())
          .filter(Boolean)
      ),
    [measureInfoRows]
  );
  const measureInfoCodesRef = useRef<Set<string>>(measureInfoCodes);
  measureInfoCodesRef.current = measureInfoCodes;

  // 편집 시작 셀의 (binding, oldVal) — cellEditEnded 에서 실제 값 변경 여부 판정(불필요 clear 방지).
  const editingCellRef = useRef<{ binding: string; oldVal: unknown } | null>(null);

  // ⭐ 동적 기간 컬럼 메타 — GET_SPREAD_TITLE 를 1차 소스로 사용 (B_* 는 kindOf null 로 자동 제외 = 항상 숨김).
  type DynColMeta = {
    binding: string;
    kind: 'M' | 'W' | 'D';
    large: string;
    small: string;
    leaf: string;
    sort: number;
    dayCode: string;
  };
  // 동적 컬럼 fallback(spreadTitle 부재 시)만 rows 를 쓴다 — 그것도 '동적 키 집합' 만 본다.
  //   rows 배열 자체를 dynColMetas dep 에 두면 행추가(Insert)마다 rows 참조가 바뀌어 dynColMetas 가
  //   새 배열이 되고, 그 결과가 mainDynamicColumns -> 공용 DataGrid 의 columnGroups 를 새 참조로 만든다.
  //   공용 DataGrid 는 columnGroups 참조가 안 바뀌어야 Wijmo 가 컬럼을 재생성하지 않는 설계라
  //   (DataGrid.tsx 670~715 주석), 그 참조가 깨지면 전 컬럼 재생성 -> 다단 헤더 높이 리셋 ->
  //   applyHeaderHeight 재적용으로 헤더 높이가 한 프레임 깜빡인다 (2026-09-02 행추가 리포트).
  //   따라서 배열 대신 동적 키 서명(내용이 바뀔 때만 값이 바뀌는 문자열)에만 의존시킨다.
  const rowDynKeySig = useMemo(() => {
    if ((spreadTitle?.length ?? 0) > 0) return ''; // spreadTitle 우선 경로 — rows 미참조
    if (!rows || rows.length === 0) return '';
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        if (/^M_\d{6}$/.test(k) || /^W_\d{7,10}$/.test(k) || /^D_\d{8}$/.test(k)) set.add(k);
      }
    }
    return [...set].sort().join(',');
  }, [spreadTitle, rows]);
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const kindOf = (b: string): 'M' | 'W' | 'D' | null =>
      /^M_\d{6}$/.test(b) ? 'M' : /^W_\d{7,10}$/.test(b) ? 'W' : /^D_\d{8}$/.test(b) ? 'D' : null;
    // (1) GET_SPREAD_TITLE 우선
    const titleMetas = (spreadTitle ?? []).flatMap<DynColMeta>(r => {
      const binding = String(r.COLUMN_NAME ?? '');
      const kind = kindOf(binding);
      if (!kind) return [];
      return [
        {
          binding,
          kind,
          large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
          small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
          leaf: String(r.COLUMN_LABEL_NAME ?? ''),
          sort: Number(r.SORT_ORDER_NO ?? 0),
          dayCode: String(r.DAY_CODE ?? ''),
        },
      ];
    });
    if (titleMetas.length > 0) {
      // AS-IS 는 월 경계 주차를 양쪽 월에 모두 표시한다. TO-BE SP 가 주 시작 월에만
      // 반환하는 경우(예: W_20261253만 존재) 조회기간에서 누락 binding만 보완한다.
      if (titleMetas.some(meta => meta.kind === 'W')) {
        const existing = new Set(titleMetas.map(meta => meta.binding));
        const largeLabelByMonth = new Map(
          titleMetas.map(meta => [meta.binding.slice(2, 8), meta.large] as const)
        );
        const maxSort = Math.max(...titleMetas.map(meta => meta.sort), 0);
        getMonthWeekKeysInRange(startYyyymmdd, endYyyymmdd).forEach((binding, index) => {
          if (existing.has(binding)) return;
          const ym = binding.slice(2, 8);
          titleMetas.push({
            binding,
            kind: 'W',
            large: largeLabelByMonth.get(ym) || `${ym.slice(0, 4)}-${ym.slice(4)}`,
            small: `W${binding.slice(8)}`,
            leaf: '',
            sort: maxSort + index + 1,
            dayCode: '',
          });
        });
      }
      return titleMetas.sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    // (2) fallback — 데이터 row 키 union (라벨 = binding 파생). rowDynKeySig 이 정렬·중복제거를 끝낸
    //   동적 키 목록이라 그대로 펼친다 (rows 배열 자체는 여기서 참조하지 않는다 — 위 서명 주석 참조).
    if (!rowDynKeySig) return [];
    return rowDynKeySig.split(',').flatMap<DynColMeta>(binding => {
      const kind = kindOf(binding);
      if (!kind) return [];
      const dyn = getDynKey(binding);
      return [
        {
          binding,
          kind,
          large: dyn.ym,
          small: dyn.sub,
          leaf: dyn.leaf,
          sort: 0,
          dayCode: '',
        },
      ];
    });
  }, [spreadTitle, rowDynKeySig, startYyyymmdd, endYyyymmdd]);

  // binding 순서 목록 + 표시 규칙 rank 분리 (활성 bucket=표시 / 상위 합계=sumYn / 하위=드릴 전용 — DMF0003 1:1)
  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  const weekendCodeByBinding = useMemo(() => {
    const result = new Map<string, 'SAT' | 'SUN'>();
    dynColMetas
      .filter(meta => meta.kind === 'D')
      .forEach(meta => {
        const code = meta.dayCode.trim().toUpperCase();
        if (code.includes('SAT')) result.set(meta.binding, 'SAT');
        else if (code.includes('SUN')) result.set(meta.binding, 'SUN');
        else {
          const yyyymmdd = meta.binding.slice(2);
          const day = new Date(
            Date.UTC(
              Number(yyyymmdd.slice(0, 4)),
              Number(yyyymmdd.slice(4, 6)) - 1,
              Number(yyyymmdd.slice(6, 8))
            )
          ).getUTCDay();
          if (day === 6) result.set(meta.binding, 'SAT');
          if (day === 0) result.set(meta.binding, 'SUN');
        }
      });
    return result;
  }, [dynColMetas]);
  const weekendCodeByBindingRef = useRef(weekendCodeByBinding);
  weekendCodeByBindingRef.current = weekendCodeByBinding;
  const summaryBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] < DYN_RANK[bucketPrefix]).map(m => m.binding),
    [dynColMetas, bucketPrefix]
  );
  const drillBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] > DYN_RANK[bucketPrefix]).map(m => m.binding),
    [dynColMetas, bucketPrefix]
  );
  // 드릴 오버라이드(binding → visible) — bucket/sum/조회 변경 시 리셋 (AS-IS SetSpreadColumn 재실행 1:1).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  // ⭐ 동적 PIVOT 컬럼 — 3단 nested (대상년월 → 주차/SUM → leaf). 라벨 = GET_SPREAD_TITLE 제공값.
  //   AS-IS SetSpreadHeaderSpan L3660~3747 (Large 월 span / Small 주 span / 일+요일) + SUM 헤더 5종 대응.
  const mainDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    type SubBucket = Map<string, LeafCol[]>;
    type LargeBucket = { label: string; subs: SubBucket; order: number };
    const largeMap = new Map<string, LargeBucket>();
    const kindRank = { M: 0, W: 1, D: 2 } as const; // sub 내 leaf 순서 — 합계(W) 먼저, 일자(D) 다음
    dynColMetas.forEach((m, idx) => {
      // 1단 그룹 키 = binding 의 yyyymm (라벨은 large). 라벨만으로 묶으면 동명 월 충돌 → binding 기준.
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      // 2단 키 — kind 기반. W 는 SP small('Wxx') 우선, 없으면 binding 파생.
      const subKey =
        m.kind === 'M'
          ? 'SUM'
          : m.kind === 'W'
            ? (
                m.small ||
                (/^W_\d{7,9}$/.test(m.binding) && !/^W_\d{8}$/.test(m.binding)
                  ? `W${m.binding.slice(8)}`
                  : getDynKey(m.binding).sub)
              ).trim() || 'SUM'
            : (m.small || getDynKey(m.binding).sub).trim() || 'SUM';
      let subColumns = bucket.subs.get(subKey);
      if (!subColumns) {
        subColumns = [];
        bucket.subs.set(subKey, subColumns);
      }
      subColumns.push({
        binding: m.binding,
        // 3단(leaf) 라벨 — M/W 합계는 'SUM' / D=일자(m.leaf).
        header: m.kind === 'D' ? m.leaf || m.small || 'SUM' : 'SUM',
        align: 'right',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: 48, // 다단 헤더 높이(#93) — wrapper 가 staticColumns 만 자동 처리, 동적은 명시 의무.
        _display: true,
        // [2026-08-12 사용자 지시] Grid Footer Summary 삭제 — aggregate 미지정
        format: '#,##0.###',
      });
    });
    // sub 정렬: 'SUM'(월합계) 최우선 → 주차 오름차순. leaf 정렬: 합계(M/W) 먼저 → 일자 binding 순.
    //   주차는 숫자 크기가 아니라 그 달의 실제 시간순으로 놓는다 (연말·연초 W53→W01 역전 방지).
    const subOrder = (label: string, leafCols: LeafCol[]): number => {
      if (label === 'SUM') return -1;
      const ym = leafCols[0]?.binding.slice(2, 8) ?? '';
      const week = Number(label.replace(/\D/g, '') || 0);
      const chronologicalIndex = isoWeeksOfMonth(ym).findIndex(item => item.isoWeek === week);
      return chronologicalIndex >= 0 ? chronologicalIndex : week;
    };
    const leafKind = (b: string): 'M' | 'W' | 'D' =>
      /^M_/.test(b) ? 'M' : /^W_/.test(b) ? 'W' : 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: 48,
        columns: [...bucket.subs.entries()]
          .sort(([a, aCols], [b, bCols]) => subOrder(a, aCols) - subOrder(b, bCols))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            height: 48,
            columns: leafCols.sort(
              (a, b) =>
                kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
  }, [dynColMetas]);

  // ⭐ grid 핸들러 + mergeManager + footer useEffect 등록.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    // 홀짝 zebra (#95)
    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    // 현재기간 강조 = 당월 M_ / 당주 W_ / 당일 D_ binding 이면 무조건 Green Bold.
    // 헤더 더블클릭으로 상위 버킷을 펼쳐도 그 버킷의 SUM 헤더는 계속 당월/당주 색을 유지한다
    //   (예: 2026-09 를 펼쳐 W36~W40 이 나와도 SUM(=M_202609) 과 W36 이 함께 초록).
    //   종전에는 "화면에 보이는 가장 하위 버킷만" 규칙으로 하위가 펼쳐지면 상위 SUM 을 껐는데,
    //   펼친 구간이 당월이라는 표시가 사라져 오히려 위치를 잃는다 (사용자 요청 2026-09-01).
    // 참고: 왼쪽 세로 레일(applyRail)은 지금도 당주 W_ 한 컬럼 전용 — 여기서 바꾸지 않는다.
    const shouldHighlightCurrentPeriod = (binding: string): boolean =>
      currentPeriodBindingsRef.current.has(binding);

    // 현재기간 rail — 당주 W_ 컬럼 하나만 대상 (당월 M_ SUM·당일 D_ 는 제외.
    //   MktFcstGrid/SalesMonitoringGrid 동일 규칙). 헤더·데이터셀 공통 판정.
    const isCurrentWeekRail = (binding: string): boolean =>
      dynKindOf(binding) === 'W' && currentPeriodBindingsRef.current.has(binding);
    // rail 그리기/지우기 — inline !important (CSS 클래스는 Wijmo 기본 셀 border 에 밀린다).
    //   미대상 셀은 반드시 removeProperty — Wijmo 셀 재활용으로 이전 컬럼 선이 남는다.
    //   필수: AS-IS 는 당주 왼쪽 경계 한 줄만 그린다 — 오른쪽 초록선/구 클래스 잔상은 항상 제거.
    const applyRail = (cell: HTMLElement, on: boolean) => {
      if (on) cell.style.setProperty('border-left', '2px solid #1e8449', 'important');
      else cell.style.removeProperty('border-left');
      cell.style.removeProperty('border-right');
      toggleClass(cell, 'sp-cell-current-period', false);
    };

    // MEASURE 편집 후보 제한 — dataMap 을 교체하지 않고 getDisplayValues 만 덮는다
    //   (DMF0082 ForecastPriceGrid 2026-08-12 선례 1:1).
    //   금지: 편집 진입 시 col.dataMap 교체 — dataMap 은 컬럼 단위라 교체하는 순간 후보 밖 코드
    //   (표시 31종 중 Insert 대상 3종만 남음)가 CODE→NAME 매핑을 잃는다. 그래서 드롭다운이
    //   코드로 보이고 같은 컬럼의 다른 행까지 raw CODE 로 바뀐다.
    //   wijmo 는 편집기 드롭다운을 만들 때 getDisplayValues(행 dataItem) 를 호출하므로,
    //   표시용 전체 map 을 그대로 두고 후보만 좁히면 표시와 후보가 동시에 맞는다.
    //   주의: 판정은 표시명 → 코드(getKeyValue) 방향 — 반대 방향은 map 에 없는 코드에서
    //   wijmo 가 키를 그대로 돌려주기도 해 매칭이 조용히 실패한다.
    type MeasureCandidateDataMap = DataMap & { rowScopedCandidates?: boolean };
    const installMeasureCandidateFilter = (dataMap?: DataMap) => {
      if (!dataMap) return;
      const map = dataMap as MeasureCandidateDataMap;
      if (map.rowScopedCandidates) return;
      map.rowScopedCandidates = true;
      const allDisplayValues = map.getDisplayValues.bind(map) as (item?: unknown) => string[];
      map.getDisplayValues = (item?: unknown): string[] => {
        // 표시명 중복 제거 — 소스 dedupe(dedupeComboRowsByCode) 뒤에도 서로 다른 CODE 가 같은
        //   라벨을 쓰면 드롭다운에 같은 항목이 두 번 뜬다. 사용자는 구분할 수 없고 선택은
        //   getKeyValue 가 고르는 한 코드로만 매핑되므로 목록 단계에서 1회로 접는다.
        const all = [...new Set(allDisplayValues(item))];
        const codes = measureInfoCodesRef.current;
        if (codes.size === 0) return all; // SP 후보 미도착 — 전체 목록 유지(드롭다운을 비우지 않는다)
        const narrowed = all.filter(name => codes.has(String(map.getKeyValue(name) ?? '').trim()));
        return narrowed.length > 0 ? narrowed : all;
      };
    };

    // FCST_TYPE 후보 제한 — Catch_Up 행에서만 ETC 를 뺀다 (AS-IS L4903. SalesAmt_LOC 은 ETC 고정이라
    //   L2944 InsertRow 가 값을 직접 넣고 이 컬럼을 잠근다).
    //   MEASURE 와 같은 이유로 dataMap 을 교체하지 않는다 — 교체하면 ETC 를 가진 다른 행이 라벨을
    //   잃는다. wijmo 가 드롭다운을 만들 때 행 dataItem 을 넘겨주므로 행별 판정이 그대로 가능하다.
    const installCatchUpFcstTypeFilter = (dataMap?: DataMap) => {
      if (!dataMap) return;
      const map = dataMap as MeasureCandidateDataMap;
      if (map.rowScopedCandidates) return;
      map.rowScopedCandidates = true;
      const allDisplayValues = map.getDisplayValues.bind(map) as (item?: unknown) => string[];
      map.getDisplayValues = (item?: unknown): string[] => {
        const all = [...new Set(allDisplayValues(item))];
        const measure = toCellStr((item as Record<string, unknown> | undefined)?.MEASURE);
        if (measure !== EDIT_MEASURE.CATCH_UP) return all;
        const narrowed = all.filter(
          name =>
            String(map.getKeyValue(name) ?? '')
              .trim()
              .toUpperCase() !== INSERT_DEFAULT_FCST_TYPE
        );
        return narrowed.length > 0 ? narrowed : all;
      };
    };

    const formatHandler = (_s: FlexGridType<SalesPlanRow>, e: FormatItemEventArgs) => {
      // #108 — No. 코너 헤더 (TopLeft 단일 라벨)
      if (e.panel.cellType === CellType.TopLeft) {
        // 편집 그리드는 순번/상태 row header가 각각 존재하므로 첫 번째 열에만 표시한다.
        const label = e.col === 0 ? 'No.' : '';
        if (e.cell.textContent !== label) e.cell.textContent = label;
        e.cell.style.textAlign = 'center';
        return;
      }
      const col = e.panel.columns[e.col];
      if (!col) return;

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        // ⭐ 당월 M_/당주 W_ 헤더 Green Bold (AS-IS chkColor OFF 기본 — 커서 2 기준. Color 체크박스 제거 확정)
        const showCurrentPeriod = !!col.binding && shouldHighlightCurrentPeriod(col.binding);
        const weekendCode = col.binding
          ? weekendCodeByBindingRef.current.get(col.binding)
          : undefined;
        e.cell.style.color = showCurrentPeriod
          ? '#1e8449'
          : weekendCode === 'SAT'
            ? '#1565c0'
            : weekendCode === 'SUN'
              ? '#d32f2f'
              : '';
        e.cell.style.fontWeight = showCurrentPeriod ? '700' : '';
        // 당주 헤더 왼쪽에도 rail — 아래 데이터셀 border-left 와 한 줄로 이어진다.
        applyRail(e.cell, isCurrentWeekRail(col.binding ?? ''));
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      if (!col.binding) return;

      const binding = col.binding;
      // 당주 rail — 동적/정적 전 셀이 이 줄을 지나야 재활용 잔상이 남지 않는다 (isDyn 분기보다 앞).
      applyRail(e.cell, isCurrentWeekRail(binding));
      // 음수 = 빨간 글자 (그리드 공통 규약. 정본 @foundation/utils paintNegativeText).
      //   필수: 진입 직후 한 번만 칠한다 — 아래 분기들이 각자 return 하므로 분기 안에서 부르면
      //   정적/동적 어디에도 안 걸리는 컬럼이 통째로 빠진다.
      //   값 원천 = 그 셀이 실제로 그리는 원값(getCellData(..., false)). 콤보 컬럼은 CODE 가 와서
      //   toGridNumber 가 0 을 돌려주므로 자연히 음수 판정에서 빠진다.
      //   주의: 정적 셀은 아래에서 개인화 Text Color 와 우선순위를 다시 따진다(음수 빨강이 우선).
      paintNegativeText(e.cell, toNumber(e.panel.getCellData(e.row, e.col, false)));
      const rowItem = (e.panel.rows[e.row] as unknown as { dataItem?: SalesPlanRow })?.dataItem;
      const isDyn = !staticBindingSet.has(binding) && !!dynKindOf(binding);
      const isInsert = rowItem?.CRUD_TYPE === 'I';

      if (isDyn) {
        // ⭐ editLock R1~R4 — 편집가능 Yellow / 과거 Gray / 그 외 White (#95 — 전체회색·inline 금지)
        const state = evalSalesPlanDynCell({
          binding,
          row: rowItem,
          divisionId: division,
          bucketType,
          cutoff,
          auth,
        });
        const editable = state.editable;
        toggleClass(e.cell, 'wj-cell-editable', editable);
        // 실적 구간(과거 기간 컬럼) = Gray. DMF0003 MktFcstGrid / DMF0020 ForecastPriceGrid 와 같은
        //   방식(공통 클래스 wj-cell-non-editable, 전체회색·inline 금지).
        //   판정은 컬럼(기간) 차원인 state.isPast 를 쓴다 — evalSalesPlanDynCell 이 행 게이트보다
        //   먼저 계산해 모든 early return 에 실어 보내므로, 읽기전용 measure 행만 흰색으로 남아
        //   실적 구간이 얼룩지는 일이 없다. 편집 차단은 그대로 state.editable 담당 —
        //   색과 잠금의 역할만 나눈 것이다.
        toggleClass(e.cell, 'wj-cell-non-editable', state.isPast);
        // ⭐ 변경 셀 Red (AS-IS Dsdm_Changed L3948 — EditTracker 단일 소스 + 신규 행 입력 셀)
        const tracked =
          rowItem &&
          (
            editTrackerRef?.current?.getOriginalValues() as
              | Map<SalesPlanRow, Record<string, unknown>>
              | undefined
          )?.get(rowItem)?.[binding] !== undefined;
        const insertInput = isInsert && rowItem?.[binding] != null && rowItem?.[binding] !== '';
        toggleClass(e.cell, 'sp-cell-changed', !!tracked || !!insertInput);
        // ⭐ 행별 NOTATION 숫자 포맷 (편집 중 셀 제외)
        if (!g.editRange?.contains(e.row, e.col)) {
          const notation = toCellStr(rowItem?.NOTATION);
          e.cell.innerText = formatByNotation(rowItem?.[binding], notation);
        }
        return;
      }

      // ⭐ 콤보 dataMap 계층 indent 보존 (memory feedback_measure_combo_indent_whitespace — CMBO_SQL 원천)
      if (binding === 'MEASURE') e.cell.style.whiteSpace = 'pre';

      // 정적 셀 — Insert 행 화이트리스트(R5) = Yellow. 모달 셀 아이콘 (PROJECT_CODE 81·82 / ITEM_ID 40+Catch_Up).
      if (rowItem && isInsert) {
        // 모달 전용 셀(PROJECT_CODE 81·82 / ITEM_ID 40+Catch_Up)도 입력 가능 셀 = Yellow.
        //   insertStaticEditable 은 직접 타이핑 게이트라 false 지만, 팝업으로 값이 들어가므로
        //   표시는 편집 가능이어야 한다 (mkt-fcst FPModal 셀과 동일 계약).
        const isModalCell = isInsertModalCell(binding, rowItem, division);
        const editable =
          insertStaticEditable(binding, rowItem, division, measureInfoCodesRef.current.size) ||
          isModalCell;
        toggleClass(e.cell, 'wj-cell-editable', editable);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        toggleClass(e.cell, 'wj-cell-popup', false); // wrapper 자동 토글 무력화 (전용 span 사용)
        if (isModalCell) {
          const cellEl = e.cell;
          cellEl.style.cursor = 'pointer';
          cellEl.style.paddingRight = '20px';
          if (!cellEl.querySelector('.popup-icon')) {
            const icon = document.createElement('span');
            icon.className = `popup-icon ${styles.popupIcon}`;
            cellEl.appendChild(icon);
          }
        } else {
          e.cell.querySelector('.popup-icon')?.remove();
        }
      } else {
        toggleClass(e.cell, 'wj-cell-editable', false);
        e.cell.querySelector('.popup-icon')?.remove();
      }

      // 개인화 색 (ColumnLayoutModal 저장값) — 정적 컬럼만 (동적 기간 컬럼은 위에서 return).
      //   우선순위: Insert 편집셀 Yellow(클래스) > 저장된 Cell Color. inline !important 라 클래스보다
      //   세므로 편집 가능 Insert 셀에는 배경을 칠하지 않는다.
      //   미지정 시 removeProperty 필수 — Wijmo 셀 재활용으로 이전 컬럼 색이 남는다.
      const personalColor = colorMetaRef.current.get(binding);
      const insertEditable =
        !!rowItem &&
        isInsert &&
        (insertStaticEditable(binding, rowItem, division, measureInfoCodesRef.current.size) ||
          isInsertModalCell(binding, rowItem, division));
      if (!insertEditable && personalColor?.cell) {
        e.cell.style.setProperty('background-color', personalColor.cell, 'important');
      } else {
        e.cell.style.removeProperty('background-color');
      }
      // 글자색 우선순위: 음수 빨강 > 개인화 Text Color (mkt-fcst 동일 규약).
      //   위에서 이미 칠한 음수색을 여기서 지우거나 덮지 않도록 3분기로 처리한다 — 단순히
      //   personalColor 유무로만 갈라 쓰면 else 의 removeProperty 가 음수색을 도로 지운다.
      if (toNumber(rowItem?.[binding]) < 0) {
        paintNegativeText(e.cell, -1);
      } else if (personalColor?.text) {
        e.cell.style.setProperty('color', personalColor.text, 'important');
      } else {
        e.cell.style.removeProperty('color');
      }
    };
    g.formatItem.addHandler(formatHandler);

    // ===== 편집 시작 — R5 정적 화이트리스트 + R1~R4 동적 판정 =====
    // 금지: 여기서 col.dataMap 을 갈아끼우지 말 것. dataMap 은 셀이 아니라 컬럼 속성이라 그 컬럼
    //   전 행이 그 맵을 탄다. 행별 후보는 컬럼 메타(PARAM2/PARAM9/PARAM10)를 보고 공용 계층이
    //   getDisplayValues(행) 로 처리한다. 행 상태로 후보를 더 좁혀야 하면 아래 MEASURE 처럼
    //   기존 맵의 getDisplayValues 만 덮는다 (교체 아님).
    const beginningEditHandler = (
      s: FlexGridType<SalesPlanRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      const row = s.rows[e.row].dataItem as SalesPlanRow | undefined;

      if (staticBindingSet.has(binding)) {
        // 정적 셀 — Insert 행 화이트리스트만 (기존 행 키 컬럼 잠금. AS-IS InsertRow 잠금 68건 붕괴)
        if (
          !row ||
          row.CRUD_TYPE !== 'I' ||
          !insertStaticEditable(binding, row, division, measureInfoCodesRef.current.size)
        ) {
          e.cancel = true;
          return;
        }
        e.cancel = false;
        editingCellRef.current = { binding, oldVal: (row as Record<string, unknown>)[binding] };
        // 행 상태로 후보를 더 좁혀야 하는 두 컬럼만 기존 맵의 getDisplayValues 를 덮는다.
        //   나머지(Sales Site·End Customer·Project·Model·Currency 등)는 컬럼 메타가 단일 원천이라
        //   여기서 할 일이 없다 — 손대는 순간 그 메타 설정이 무효가 된다.
        //   MEASURE  : Insert 행 후보 = GET_SALES_PLAN_MEASUREINFO (AS-IS L2925)
        //   FCST_TYPE: Catch_Up 행만 ETC 제외 (AS-IS L4903)
        if (binding === 'MEASURE') {
          installMeasureCandidateFilter(col.dataMap as DataMap | undefined);
          return;
        }
        if (binding === 'FCST_TYPE') {
          installCatchUpFcstTypeFilter(col.dataMap as DataMap | undefined);
          return;
        }
        return;
      }
      // 동적 셀 — R2 Daily 전잠금(MSG00361) + R1~R4 종합. FIFO 마지막 핸들러 → e.cancel 명시 설정이
      // wrapper setEditableColumns('S' read-only) 보다 우선.
      if (dynKindOf(binding)) {
        if (bucketType === BUCKET_TYPE.DAILY) {
          e.cancel = true;
          // AS-IS EditButton L1101~1103 — Daily 버킷 편집 불가 안내
          void setAlert({
            type: 'alert',
            content: t(MSG.DAILY_EDIT_BLOCK, '_Daily 버킷에서는 편집할 수 없습니다.'),
          });
          return;
        }
        const state = evalSalesPlanDynCell({
          binding,
          row,
          divisionId: division,
          bucketType,
          cutoff,
          auth,
        });
        e.cancel = !state.editable;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    // 붙여넣기 게이트 — 편집 가드와 동일 판정 (AS-IS spdMain_KeyUp Ctrl+V 키영역 가드 L5431 대응)
    g.pastingCell.addHandler(beginningEditHandler as never);

    // ===== 편집 종료 — dataMap 원복 + V-C1~C3 셀 검증 + R6 Measure 전환 + cascade clear =====
    const cellEditEndedHandler = (
      s: FlexGridType<SalesPlanRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      // 원복할 것이 없다 — 편집 시작이 col.dataMap 을 바꾸지 않는다(MEASURE/FCST_TYPE 는 같은 맵의
      //   getDisplayValues 만 덮고, 그 판정은 행 dataItem 기준이라 행이 바뀌면 저절로 따라간다).

      const row = s.rows[e.row].dataItem as SalesPlanRow | undefined;
      if (!row) return;
      const rec = row as Record<string, unknown>;

      // ===== 동적 셀 — V-C1~C3 (AS-IS Dsdm_Changed L3937~3948 + LeaveCell L4322~4398) =====
      if (dynKindOf(binding)) {
        // 값 조정/롤백 뒤 EditTracker 를 최종값으로 재판정한다. 원본은 반드시 EditTracker 가 가진
        //   실제 기록(getOriginalValues)에서 가져온다 — e.data(편집 직전 값)를 원본으로 넘기면,
        //   EditTracker._cellChanged 가 앞서 이미 해제한 기록을 직전 값 기준으로 되살려
        //   입력 후 Delete 시 M 이 안 풀린다(2026-09-16 리포트). 기록이 없으면(변경 없음으로 해제된
        //   상태) 최종값 자신을 원본으로 넘겨 해제 상태를 유지한다.
        const retrackDyn = () => {
          if (row.CRUD_TYPE === 'I') return;
          const tracker = editTrackerRef?.current;
          if (!tracker) return;
          const finalVal = (rec[binding] ?? null) as never;
          const recorded = tracker.getOriginalValues().get(row as never);
          const hasOriginal = !!recorded && binding in recorded;
          const original = hasOriginal ? (recorded[binding] as never) : finalVal;
          tracker.storeChange(row as never, binding, original, finalVal);
        };

        const measure = toCellStr(row.MEASURE);
        // V-C3 — MEASURE 빈 행 숫자 입력 롤백 (L3941 셀 clear)
        if (!measure) {
          rec[binding] = null;
          retrackDyn();
          s.invalidate(true);
          return;
        }
        let val = toNumber(rec[binding]);
        // V-C1 — RTF_SYS_RP 음수 차단 (FcstType=RMA 만 음수 허용, L4358) + 정수 절삭 (L4390)
        if (measure === EDIT_MEASURE.RTF_SYS_RP) {
          if (toCellStr(row.FCST_TYPE) !== 'RMA' && val < 0) {
            rec[binding] = null;
            retrackDyn();
            s.invalidate(true);
            return;
          }
          val = Math.trunc(val);
          rec[binding] = val;
        }
        // V-C2 — SalesAmt_LOC 소수 3자리 (L4384)
        if (measure === EDIT_MEASURE.SALES_AMT_LOC) {
          val = Math.round(val * 1000) / 1000;
          rec[binding] = val;
        }
        // EditTracker — 변경 셀 추적 (Red 마킹·SAVE 수집 단일 소스. 비-insert 행 자동 'M' 마킹)
        retrackDyn();
        s.invalidate(true);
        return;
      }

      // ===== 정적 셀 (Insert 행) — R6 Measure 전환 + cascade 계단 clear =====
      if (!staticBindingSet.has(binding) || row.CRUD_TYPE !== 'I') return;
      const prev = editingCellRef.current;
      const newVal = rec[binding];
      const changed = prev?.binding === binding && toCellStr(prev.oldVal) !== toCellStr(newVal);

      // ⭐ R6 — Catch_Up ↔ SalesAmt_LOC 전환 (cutoff 스왑은 editLock 이 row.MEASURE 실시간 참조 —
      //   FCST_TYPE ETC 고정/개방 + ITEM 모달 전환 + 기존 기간 입력 전체 초기화)
      if (binding === 'MEASURE' && changed) {
        applyMeasureSwitch(row, toCellStr(newVal), dynBindings);
      }
      if (binding === 'ITEM_ID' && changed) {
        // [No.61-③] lookup 매칭 → ITEM_CLASS_NAME = NAME 자동세팅 (AS-IS ComboSelChange L4785~4794 1:1)
        const selected = itemDropdownRowsRef.current.find(
          item => toCellStr(item.CODE) === toCellStr(newVal)
        );
        if (selected) {
          rec.ITEM_CLASS_NAME = toCellStr(selected.NAME);
        }
      }
      // cascade 계단 clear (hook #59 §5-G — 상위 콤보 값이 실제로 바뀐 경우만).
      //   상위 콤보(End Customer/Sales Site 등)를 바꾸면 하위 종속 셀을 비운다.
      const clearTargets = GRID_CASCADE_CLEAR[binding];
      if (clearTargets && changed) {
        clearTargets.forEach(k => {
          rec[k] = '';
        });
      }
      // Team(DEPT_ID) 변경 = 40 제외 division 에서 End Customer/Sales Site/Project 초기화
      //   (사용자 요구 2026-09-08). 40 은 End Customer 가 Team 종속이 아니라 대상 아님.
      if (binding === 'DEPT_ID' && changed && !isDiv40(division)) {
        DEPT_CASCADE_CLEAR_NON40.forEach(k => {
          rec[k] = '';
        });
      }

      editingCellRef.current = null;
      s.invalidate(true);
      // 머지 참여 컬럼(fixedBindings) 값 재수정 시 병합 미해제 방지 (2026-08-05 리포트: 같은 값 입력
      //   →병합 확인 후 다른 값으로 재수정해도 병합 유지). 콤보 에디터(dataMap) 커밋이 이 핸들러 실행
      //   시점보다 한 프레임 늦게 반영되는 경우 invalidate(true) 가 아직 옛 값 기준으로 병합범위를
      //   재계산해버려 새 값이 반영된 다음 프레임까지 재계산되지 않는다 — 한 번 더 강제 재계산한다.
      if (changed && fixedBindings.includes(binding)) {
        window.requestAnimationFrame(() => s.invalidate(true));
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    // 붙여넣기 후 처리 (AS-IS spdMain_ClipboardPasted L5572~5596).
    //   붙여넣기도 셀 편집과 똑같은 후처리를 탄다 — cascade 계단 clear / Measure 전환 /
    //   동적 셀 V-C 검증·추적이 전부 cellEditEndedHandler 안에 있다.
    //   2026-08-23 리포트: 종전에는 ITEM_ID 와 동적 셀만 태워서 정적 콤보 셀
    //   (End Customer/Sales Site/Project/Measure 등)이 후처리를 통째로 건너뛰어 하위 셀 clear 가 빠졌다.
    //   변경 판정 입력(editingCellRef)과 cascade dataMap 은 pastingCell(=beginningEditHandler)이
    //   셀마다 먼저 세팅하므로, 편집 경로와 같은 전제로 안전하게 재사용된다.
    const pastedCellHandler = (
      s: FlexGridType<SalesPlanRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      cellEditEndedHandler(s, e);
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // ===== 더블클릭 — 헤더 드릴다운 + 셀 모달 (AS-IS spdMain_CellDoubleClick L3749~3916) =====
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      // 헤더 — M_ 헤더: 해당 월 구간 W_ 토글 + 보이는 D_ 접기 / W_ 헤더: 해당 주 D_ 토글 (L3751~3794)
      if (ht.cellType === CellType.ColumnHeader) {
        const hb = g.columns[ht.col]?.binding ?? '';
        const hk = dynKindOf(hb);
        if (hk !== 'M' && hk !== 'W') return;
        const idx = dynBindings.indexOf(hb);
        if (idx < 0) return;
        const flip = (target: string, hideOnly: boolean) => {
          const targetCol = g.getColumn(target);
          if (!targetCol) return;
          if (hideOnly && !targetCol.visible) return; // AS-IS: D_ 는 보이는 경우만 접기 (M_ 드릴)
          drillVisRef.current.set(target, hideOnly ? false : !targetCol.visible);
        };
        for (let i = idx + 1; i < dynBindings.length; i++) {
          const target = dynBindings[i];
          const tk = dynKindOf(target);
          if (hk === 'M') {
            if (tk === 'M') break;
            if (tk === 'W') flip(target, false);
            else if (tk === 'D') flip(target, true);
          } else {
            if (tk === 'W' || tk === 'M') break;
            if (tk === 'D') flip(target, false);
          }
        }
        applyDynVisibilityRef.current?.();
        return;
      }
      if (ht.cellType !== CellType.Cell) return;
      // 데이터 셀 — 신규(I) 행만 (AS-IS 조기 가드 IsLock || Action!='I' L3797)
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = g.rows[ht.row]?.dataItem as SalesPlanRow | undefined;
      if (!row || row.CRUD_TYPE !== 'I') return;
      // PROJECT_CODE 셀 (81·82 — L3834) / ITEM_ID 셀 (40 && Catch_Up — L3863) /
      //   DEPT_ID(Team) 셀 (Catch_Up 제외 — 2026-09-18 콤보→모달+키인 전환).
      //   판정은 formatItem 의 Yellow/아이콘 과 동일 함수 (isInsertModalCell) 로 통일.
      if (!isInsertModalCell(binding, row, division)) return;
      const modalKey =
        binding === 'PROJECT_CODE' ? 'PROJECT' : binding === 'ITEM_ID' ? 'ITEM' : 'TEAM';
      onPopupCellDblClick?.(modalKey, row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // Scroll 시 머지 그룹 재계산 (viewport sticky #38 — AS-IS TopChange SmartColMerge L3529)
    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    // ===== 머지 활성 + HierarchicalMergeManager (utils/sales-plan.merge.ts) =====
    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.mergeManager = new HierarchicalMergeManager(fixedBindings);
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.pastingCell?.removeHandler(beginningEditHandler as never);
      } catch {
        /* unmount race */
      }
      try {
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.pastedCell?.removeHandler(pastedCellHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.scrollPositionChanged?.removeHandler(handleScrollInvalidate);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    visibleColumns,
    dynBindings,
    fixedBindings,
    onPopupCellDblClick,
    cutoff,
    auth,
    division,
    bucketType,
  ]);

  // ⭐ hook #93 — 다단 헤더 총높이 48px 고정 (1단 48 / 2단 24×2 / 3단 16×3).
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    if (!g) return;

    const applyHeaderHeight = () => {
      // 금지: 여기에 combo dataMap 재부착 루프를 되살리지 말 것. 공용 DataGrid 가 컬럼 메타대로
      //   만든 맵(PARAM2 행 필터 / PARAM9 신규행 콤보 / PARAM10='D' 행별 재조회 후보)을 화면
      //   기준 맵으로 덮어 그 설정을 전부 무효화한다 — Sales Site 가 End Customer 변경을 반영하지
      //   못하던 원인이 이 루프였다 (2026-09-01). 재적용이 필요한 것은 헤더 높이뿐이다.
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const rowCount = headerRows.length;
      const per = Math.round(48 / rowCount);
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
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, gridRef]);

  // ⭐ Sum 체크박스 + 헤더 드릴다운 — 동적 컬럼 visible 통합 적용 (AS-IS SetSpreadColumn L3598~3656 +
  //   헤더 더블클릭 1:1). 규칙: 활성 bucket=표시 / 상위 합계=sumYn / 하위=숨김 — 드릴 오버라이드 우선.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    if (!g) return;
    // bucket/sum/조회 변경 = AS-IS SetSpreadColumn 재실행과 동일 — 드릴 상태 리셋
    drillVisRef.current.clear();
    const summarySet = new Set(summaryBindings);
    const drillSet = new Set(drillBindings);
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      // 우클릭 Hide Column 으로 숨긴 컬럼(공용 DataGrid 가 grid 인스턴스에 얹어 준다 — Column
      //   객체의 커스텀 플래그는 wijmo 생성자가 `_` 로 시작하는 키를 무시해 전달되지 않는다).
      const userHiddenColumns = (g as unknown as { _userHiddenColumns?: ReadonlySet<string> })
        ._userHiddenColumns;
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        // Hide Column 으로 숨긴 컬럼은 sum/드릴 재계산 대상에서 제외 — 숨김 유지.
        if (userHiddenColumns?.has(b)) {
          if (col.visible !== false) {
            col.visible = false;
            changed = true;
          }
          continue;
        }
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
        g.updatedLayout?.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
    // 필수: visibleColumns — Column Setting 저장으로 static 컬럼 세트가 바뀌면 <DataGrid key=...>
    //   가 Wijmo grid 인스턴스를 통째로 재생성한다(mainStaticColumns 는 visibleColumns 파생).
    //   이 dep 이 없으면 새 grid 에는 이 이펙트가 재등록되지 않아, 동적 컬럼이 원본 정의값
    //   (mainDynamicColumns 의 visible:true, 전 버킷 동시노출)으로 남아 Weekly/Daily 컬럼까지
    //   함께 보여 "Bucket 이 Week 로 바뀐 것"처럼 보인다 (2026-08-05 리포트).
  }, [sumYn, summaryBindings, drillBindings, dynBindings, visibleColumns, gridRef]);

  // ⭐ 당주/당월 헤더 강조 — 조회 응답(커서 2) 갱신 시 formatItem 재실행 (최신 binding 반영).
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    g?.invalidate(true);
  }, [calendarInfo, currentYyyymmdd, weekendCodeByBinding, gridRef]);

  // 필터 상태에서 Insert — 값이 빈 신규행은 필터 조건에 걸려 CollectionView 에서 빠진다.
  //   GridAction.addRowSet 이 삽입 시점에 이미 keepRowVisibleUnderFilter 로 등록하므로, 여기서는
  //   사용자가 필터 팝업에서 직접 Apply 를 눌러 그 등록이 지워지는 경우만 재등록하면 된다 —
  //   FlexGridFilter.apply() 가 예외 집합(grid._newAddedRowsSet)을 무조건 비우기 때문이다
  //   (gridAction.ts keepRowVisibleUnderFilter 주석). 필터 자체의 보존은 공용 DataGrid 가 담당한다
  //   (itemsSourceChanged 의 capture -> clear -> restore).
  const reapplyInsertRowVisibility = useCallback((): boolean => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    // 컬럼이 없는 그리드에 refresh 를 걸면 wijmo 가 컬럼 인덱스 -1 로 계산하다 예외를 던진다.
    if (!g || g.columns.length === 0) return false;
    const insertRows = rowsRef.current.filter(r => r.CRUD_TYPE === 'I');
    if (insertRows.length === 0) return false;
    insertRows.forEach(row => keepRowVisibleUnderFilter(g as never, row as never));
    return true;
  }, [gridRef]);

  // F4 Filter — 피처 소유 FlexGridFilter (필터후 머지/높이 재적용)
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;

    // 금지: 여기서 새 FlexGridFilter 를 만들면 안 된다 ("필터 걸고 행추가하니 필터가 풀림" 의 원인).
    //   공용 DataGrid 가 itemsSourceChanged 에 [capture -> FlexGridFilter 생성(=wijmo clear) -> restore]
    //   를 등록 순서로 걸어 필터를 되살린다. 여기서 두 번째 인스턴스를 만들면 그 clear 핸들러가
    //   restore 뒤에 붙어 마지막에 실행되므로 복원분이 도로 지워진다.
    //   따라서 DataGrid 에 gridFilterRef 를 넘겨 인스턴스를 공유하고(아래 JSX), 없을 때만 안전망으로 만든다.
    if (!gridFilterRef.current) {
      const created = new FlexGridFilter(g);
      created.filterColumns = [''];
      gridFilterRef.current = created;
    }
    const f = gridFilterRef.current;

    // apply() 가 방금 예외 집합을 비웠으므로 여기서 되살린다.
    //   주의: refresh 는 rAF 로 미룬다 — filterApplied 핸들러 안에서 부르면 wijmo apply() 도중
    //   재진입이 되어 내부 인덱스가 어긋난다.
    let raf = 0;
    const onFilterApplied = () => {
      g.invalidate(true);
      if (!reapplyInsertRowVisibility()) return;
      window.cancelAnimationFrame(raf);
      raf = window.requestAnimationFrame(() => {
        reapplyInsertRowVisibility();
        g.collectionView?.refresh();
      });
    };
    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      window.cancelAnimationFrame(raf);
      try {
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [visibleColumns, gridRef, gridFilterRef, reapplyInsertRowVisibility]);

  return (
    // <div className={styles.gridContainer}>
    <DataGrid
      key={mainStaticColumns.map(c => c.colNm).join(',')}
      className={styles.grid}
      gridRef={gridRef as never}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef as never}
      staticColumns={mainStaticColumns}
      dynamicColumns={mainDynamicColumns}
      // 셀 콤보 SQL 이 요구하는 화면 단위 파라미터 — 행 값이 아니라 화면 컨텍스트라 PARAM2 로는
      //   적을 자리가 없다(useRowParamCombos 주석). 미전달 시 BE makeComboQuery 가 @키 를 '' 로
      //   치환해 조용히 0건이 되고, 그러면 셀이 이름 대신 CODE 로 보인다.
      //   divisionId : Model/Sales Site 등 division 스코프 콤보 / mnuId : 'Measure'(= @mnuId 비관대형)
      comboParams={{ divisionId: `'${division || 'ALL'}'`, mnuId: `'${MENU_ID}'` }}
      // 이 그리드의 셀 콤보에 시트 스코프 sheetName 을 함께 실어 @sheetName 을 해소한다(mnuId 와 짝).
      sheetName={SHEETS.MAIN}
      itemsSource={rows as unknown as WijmoRowItem[]}
      autoGenerateColumns={false}
      // allowSorting prop 은 넘기지 않는다 - grid.allowSorting 이 truthy 면 wijmo
      //   _MouseHandler._mousedown 이 헤더 클릭 시 열 전체 선택(_mouseSelect)을 건너뛴다.
      //   공용 정렬(F3 스위치 + 헤더 클릭 + 아이콘)은 이 prop 없이도 그대로 동작한다.
      allowMerging={AllowMerging.All}
      useAggregationRow={false} // [2026-08-12 사용자 지시] Footer Summary 삭제
    />
    // </div>
  );
};
