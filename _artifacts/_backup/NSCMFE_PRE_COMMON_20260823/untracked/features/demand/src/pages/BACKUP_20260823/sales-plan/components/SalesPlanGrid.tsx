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
import {
  type MutableRefObject,
  type Ref,
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { isoWeeksOfMonth } from '@shared/lib/bucket-distribution';
import { useMessageStore } from '@shared/stores';

import {
  BUCKET_TYPE,
  EDIT_MEASURE,
  GRID_CASCADE_CLEAR,
  GRID_CASCADE_FILTERS,
  GRID_EDIT_COMBO,
  MSG,
} from '../sales-plan.constants';
import type {
  CalendarInfo,
  EditAuthInfo,
  MeasureInfoRow,
  SalesPlanRow,
  SpreadTitleRow,
} from '../sales-plan.types';
import {
  buildSalesPlanComboContext,
  buildSalesPlanComboFilter,
  isSalesPlanRowDependentCombo,
  salesPlanComboContextKey,
} from '../utils/sales-plan.comboContext';
import {
  buildCutoff,
  buildMeasureAuth,
  dynKindOf,
  evalSalesPlanDynCell,
  insertStaticEditable,
  isInsertModalCell,
} from '../utils/sales-plan.editLock';
import {
  applyMeasureSwitch,
  buildCatchUpFcstTypeMap,
  dedupeComboRowsByCode,
  filterComboRowsByRow,
  toCellStr,
} from '../utils/sales-plan.gridCombos';
import {
  getDynKey,
  getMonthWeekKeysInRange,
  HierarchicalMergeManager,
} from '../utils/sales-plan.merge';

// 동적 컬럼 kind 서열 — M(월)=0 상위 … D(일)=2 하위. 표시 규칙/드릴다운 판정용 (DMF0003 동일).
const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

// [통합테스트 1st No.61-④] Team(DEPT_ID) 파생 원천.
//   Team 은 전 Div 입력 불가(insertStaticEditable false)라 스스로 값을 가질 수 없다 — 아래 컬럼의
//   선택 행이 Sales Site Project Model 마스터의 DEPT_ID 를 함께 내려주면 그 값으로 Team 을 채운다.
const TEAM_SOURCE_BINDINGS: readonly string[] = [
  'SCM_SITE_ID',
  'PROJECT_CODE',
  'ITEM_ID',
  'END_CUSTOMER',
  'END_CUSTOMER40',
];

interface Props {
  rows: SalesPlanRow[];
  gridRef: Ref<FlexGridType<SalesPlanRow>>;
  tabId: string;
  // F4 Filter — 피처가 FlexGridFilter 직접 소유. 동적(M_/W_/D_) 컬럼 필터 cancel + 필터후 머지/높이 재적용.
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  // F7 Save — EditTracker 로 변경 셀 추적(Red 마킹 단일 소스) + 비-insert 행 자동 CRUD_TYPE='M' 마킹.
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  // 셀 모달 2종 — PROJECT(81·82 신규행) / ITEM(40+Catch_Up 신규행). AS-IS spdMain_CellDoubleClick L3834/3863.
  onPopupCellDblClick?: (modalKey: 'PROJECT' | 'ITEM', row: SalesPlanRow) => void;
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
  // MEASURE 표시 전체 CODE/LABEL (SCM_MST_SHEET_MEASURE 동적 fetch — 31건, 기존 저장 데이터 전 범위 포함).
  //   CMBO 'Measure' 응답이 비면 이 값이 표시 dataMap 을 대신한다 (없으면 CODE 그대로 노출).
  staticMeasures?: { colNm: string; colLblNm?: string }[];
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
  staticMeasures,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const division = divisionId ?? '';
  const [rowComboContext, setRowComboContext] = useState(() =>
    buildSalesPlanComboContext(undefined, division)
  );
  const rowComboContextRef = useRef(rowComboContext);
  const syncRowComboContext = useCallback(
    (row?: SalesPlanRow) => {
      const next = buildSalesPlanComboContext(row, division);
      rowComboContextRef.current = next;
      setRowComboContext(prev =>
        salesPlanComboContextKey(prev) === salesPlanComboContextKey(next) ? prev : next
      );
    },
    [division]
  );
  useEffect(() => syncRowComboContext(), [syncRowComboContext]);

  // ⭐ [통합테스트 1st No.61-③ 2026-08-12] 신규행 Model = AS-IS `SALES_PLAN_ITEM_ID` lookup 1:1
  //   (.cs L525 Data.Common(SALES_PLAN_ITEM_ID) + GUBUN division 분기 L3341~3352).
  //   구 COM0008 itemByDivision(아이템 마스터 전체)은 오구현 — Insert 는 기타매출 특수코드
  //   (ETC/Tooling/MDF 등 division 별 lookup 등재분)만 허용. CMBO 'SalesPlanItemId' 신설분 소비.
  const [salesPlanItemRows] = useTabComboQueries({
    filters: [{ comboId: 'SalesPlanItemId', divisionId: `'${division || 'ALL'}'` }],
  });
  const itemDropdownRows = useMemo(
    () => (salesPlanItemRows ?? []) as unknown as Record<string, unknown>[],
    [salesPlanItemRows]
  );
  const itemDropdownMap = useMemo<DataMap | null>(() => {
    if (itemDropdownRows.length === 0) return null;
    return new DataMap(itemDropdownRows, 'CODE', 'NAME');
  }, [itemDropdownRows]);
  const itemDropdownMapRef = useRef<DataMap | null>(null);
  const itemDropdownRowsRef = useRef(itemDropdownRows);
  itemDropdownMapRef.current = itemDropdownMap;
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

  // MEASURE 표시 fallback — CMBO 'Measure'(mnuId 전달) 응답이 비면 SCM_MST_SHEET_MEASURE 로 대체한다.
  //   기존 데이터의 MEASURE 값 전 범위(31종)는 Insert 콤보(measureInfoRows 3종)보다 넓어서,
  //   fallback 이 없으면 Measure 컬럼이 CODE 그대로 노출된다.
  const staticMeasuresMap = useMemo(() => {
    const measureRows = dedupeComboRowsByCode(
      (staticMeasures ?? []).map(m => ({
        CODE: m.colNm,
        NAME: m.colLblNm || m.colNm,
      }))
    );
    return measureRows.length > 0 ? new DataMap(measureRows, 'CODE', 'NAME') : null;
  }, [staticMeasures]);

  // ===== Grid 내 combo column dropdown — 표시용 전체 콤보 + 편집용 행 종속 콤보 =====
  const comboColumns = useMemo(
    () =>
      visibleColumns.filter(
        c => (c.cellCtrlObjTpCd as unknown as string) === 'FPComboBox' && !!c.cellCboDataTp
      ),
    [visibleColumns]
  );
  const displayComboContext = useMemo(
    () => buildSalesPlanComboContext(undefined, division),
    [division]
  );
  const comboFilters = useMemo(
    () =>
      comboColumns.map(c =>
        buildSalesPlanComboFilter(c.colNm, c.cellCboDataTp as string, displayComboContext, false)
      ),
    [comboColumns, displayComboContext]
  );
  const comboResults = useTabComboQueries({ filters: comboFilters });
  const comboSig = `${comboColumns.map(c => `${c.colNm}:${c.cellCboDataTp}`).join(',')}::${JSON.stringify(
    comboResults
  )}`;
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    comboColumns.forEach((c, i) => {
      // CODE 중복 제거 필수 — 목록 SP 의 권한/division 조인 중복이 드롭다운 항목 중복으로 보인다.
      const arr = dedupeComboRowsByCode(
        (comboResults[i] ?? []) as unknown as Record<string, unknown>[]
      );
      m[c.colNm] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    // MEASURE — 콤보 응답이 없거나 0건이면 SHEET_MEASURE 메타로 대체 (CODE 노출 방지).
    if (!m.MEASURE && staticMeasuresMap) m.MEASURE = staticMeasuresMap;
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig, staticMeasuresMap]);

  const comboRowsRef = useRef<Record<string, Record<string, unknown>[]>>({});
  const dataMapsRef = useRef<Record<string, DataMap | null>>({});
  useEffect(() => {
    const rowsByBinding: Record<string, Record<string, unknown>[]> = {};
    comboColumns.forEach((c, i) => {
      rowsByBinding[c.colNm] = (comboResults[i] ?? []) as unknown as Record<string, unknown>[];
    });
    comboRowsRef.current = rowsByBinding;
    dataMapsRef.current = dataMaps;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig, dataMaps]);

  const rowComboColumns = useMemo(
    () => comboColumns.filter(c => isSalesPlanRowDependentCombo(c.colNm)),
    [comboColumns]
  );
  const rowComboFilters = useMemo(
    () =>
      rowComboColumns.map(c =>
        buildSalesPlanComboFilter(c.colNm, c.cellCboDataTp as string, rowComboContext, true)
      ),
    [rowComboColumns, rowComboContext]
  );
  const rowComboResults = useTabComboQueries({ filters: rowComboFilters });
  const rowComboContextKey = salesPlanComboContextKey(rowComboContext);
  const rowComboSig = `${rowComboContextKey}::${JSON.stringify(rowComboResults)}`;
  const rowDataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    rowComboColumns.forEach((c, i) => {
      const arr = rowComboResults[i] ?? [];
      m[c.colNm] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rowComboSig]);
  const rowDataMapsRef = useRef<Record<string, DataMap | null>>({});
  const loadedRowComboContextRef = useRef('');
  useEffect(() => {
    rowDataMapsRef.current = rowDataMaps;
    loadedRowComboContextRef.current = rowComboResults.every(result => result !== undefined)
      ? rowComboContextKey
      : '';
  }, [rowComboContextKey, rowComboResults, rowDataMaps]);
  // ⭐ 편집 전용 콤보 (hook #59 §5-G — 편집 진입 시 스왑, cellEditEnded 원복):
  //   CURRENCY = 'CurrencyList' (AS-IS dtCurrencyList L3000) / MEASURE = measureInfo SP (L2925) /
  //   FCST_TYPE(Catch_Up) = 'FcstType' 전체에서 ETC 제외 클라 필터 (L4903).
  const editComboEntries = useMemo(() => Object.entries(GRID_EDIT_COMBO), []);
  const editComboResults = useTabComboQueries({
    // divisionParam=true 콤보는 FE quoting 전달 의무 (BE raw 치환 — hook oracle-cmbo-varname-quote)
    filters: editComboEntries.map(([, cfg]) =>
      cfg.divisionParam ? { comboId: cfg.comboId, divisionId: `'${division}'` } : cfg.comboId
    ),
  });
  const editComboSig = editComboResults
    .map((r, i) => `${editComboEntries[i]?.[0]}#${r?.length ?? 'x'}`)
    .join(',');
  const editDataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    editComboEntries.forEach(([binding], i) => {
      const arr = (editComboResults[i] ?? []) as unknown as Record<string, unknown>[];
      m[binding] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [editComboSig]);
  const editDataMapsRef = useRef<Record<string, DataMap | null>>({});
  useEffect(() => {
    editDataMapsRef.current = editDataMaps;
  }, [editDataMaps]);

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
    // (2) fallback — 데이터 row 키 union (라벨 = binding 파생)
    if (!rows || rows.length === 0) return [];
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        if (kindOf(k)) set.add(k);
      }
    }
    return [...set].sort().flatMap<DynColMeta>(binding => {
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
  }, [spreadTitle, rows, startYyyymmdd, endYyyymmdd]);

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

    // 현재기간 강조는 화면에 표시된 가장 하위 버킷에만 적용한다.
    // Monthly에서 Weekly를 펼치면 M_ SUM은 제외하고 W_ 당주만 강조한다.
    const shouldHighlightCurrentPeriod = (binding: string): boolean => {
      if (!currentPeriodBindingsRef.current.has(binding)) return false;
      const kind = dynKindOf(binding);
      if (kind !== 'M' && kind !== 'W') return true;
      const rank = DYN_RANK[kind];
      const index = dynBindings.indexOf(binding);
      if (index < 0) return true;
      for (let i = index + 1; i < dynBindings.length; i++) {
        const childBinding = dynBindings[i];
        const childKind = dynKindOf(childBinding);
        if (!childKind) continue;
        const childRank = DYN_RANK[childKind];
        if (childRank <= rank) break;
        if (childRank === rank + 1 && g.getColumn(childBinding)?.visible) return false;
      }
      return true;
    };

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
        toggleClass(e.cell, 'wj-cell-non-editable', false);
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
        const editable = insertStaticEditable(binding, rowItem, division) || isModalCell;
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
        (insertStaticEditable(binding, rowItem, division) ||
          isInsertModalCell(binding, rowItem, division));
      if (!insertEditable && personalColor?.cell) {
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
    g.formatItem.addHandler(formatHandler);

    // ===== 편집 시작 — R5 정적 화이트리스트 + R1~R4 동적 판정 + 콤보 dataMap 스왑 (hook #59 §5-G) =====
    const beginningEditHandler = (
      s: FlexGridType<SalesPlanRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      const row = s.rows[e.row].dataItem as SalesPlanRow | undefined;

      if (staticBindingSet.has(binding)) {
        // 정적 셀 — Insert 행 화이트리스트만 (기존 행 키 컬럼 잠금. AS-IS InsertRow 잠금 68건 붕괴)
        if (!row || row.CRUD_TYPE !== 'I' || !insertStaticEditable(binding, row, division)) {
          e.cancel = true;
          return;
        }
        e.cancel = false;
        editingCellRef.current = { binding, oldVal: (row as Record<string, unknown>)[binding] };
        // ⭐ 편집 전용 콤보 — MEASURE(후보만 좁힘)/FCST_TYPE(Catch_Up ETC 제외)/CURRENCY(CurrencyList)
        if (binding === 'MEASURE') {
          installMeasureCandidateFilter(col.dataMap as DataMap | undefined);
          return;
        }
        if (binding === 'ITEM_ID') {
          // [No.61-③] lookup 콤보(division 스코프 고정) — 행 컨텍스트 대기 없이 즉시 개방
          if (!itemDropdownMapRef.current) {
            e.cancel = true;
            return;
          }
          col.dataMap = itemDropdownMapRef.current;
          return;
        }
        if (binding === 'FCST_TYPE' && toCellStr(row.MEASURE) === EDIT_MEASURE.CATCH_UP) {
          const m = buildCatchUpFcstTypeMap(comboRowsRef.current[binding] ?? []);
          if (m) col.dataMap = m;
          return;
        }
        if (GRID_EDIT_COMBO[binding] && editDataMapsRef.current[binding]) {
          col.dataMap = editDataMapsRef.current[binding];
          return;
        }
        if (isSalesPlanRowDependentCombo(binding)) {
          // ⭐ [통합테스트 1st No.61-① 2026-08-12] 행 컨텍스트 미동기/로딩 미완 시 e.cancel 로
          //   "콤보 무동작" 이 되던 결함 정정 — 전역(division 스코프) 표시 콤보로 폴백해 즉시 개방.
          //   AS-IS 도 InsertRow 는 권한 범위 전체(dtSalesSiteAuth 등)를 선바인딩(L2951~2954) 후
          //   상위 셀 변경 시 좁힘 — 폴백 = AS-IS 초기 상태와 동일 계약.
          const expectedContext = buildSalesPlanComboContext(row, division);
          const expectedKey = salesPlanComboContextKey(expectedContext);
          if (salesPlanComboContextKey(rowComboContextRef.current) !== expectedKey) {
            syncRowComboContext(row); // 다음 편집을 위한 정밀 후보 재조회 (개방은 폴백으로 진행)
          }
          const rowMap =
            loadedRowComboContextRef.current === expectedKey
              ? rowDataMapsRef.current[binding]
              : null;
          const fallback = dataMapsRef.current[binding];
          const dm = rowMap ?? fallback;
          if (!dm) {
            e.cancel = true;
            return;
          }
          col.dataMap = dm;
          return;
        }

        const cascade = GRID_CASCADE_FILTERS[binding];
        if (cascade && comboRowsRef.current[binding]) {
          // mkt-fcst(EndCustomerByDivisionDept 동일 baseline) 1:1 — 무조건 재대입.
          //   filtered 0건일 때 재대입을 건너뛰면 col.dataMap 이 편집 시작 전 표시용
          //   전체(미필터) dataMap 에 그대로 남아 Div/Team cascade 가 항상 무력화된 것처럼
          //   보인다(리포트: END_CUSTOMER 콤보가 전체 데이터로 보임). 0건도 그대로 반영해
          //   현재 행 컨텍스트를 정확히 반영한다.
          const filtered = filterComboRowsByRow(comboRowsRef.current[binding], row, cascade);
          col.dataMap = new DataMap(filtered, 'CODE', 'NAME');
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
    const selectionChangedHandler = (s: FlexGridType<SalesPlanRow>) => {
      const row = s.rows[s.selection.row]?.dataItem as SalesPlanRow | undefined;
      syncRowComboContext(row?.CRUD_TYPE === 'I' ? row : undefined);
    };
    g.selectionChanged.addHandler(selectionChangedHandler);
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

      // ⭐ 스왑 원복 (hook #59 §5-G — 원복 누락 시 필터 밖 CODE 보유 타 행 명칭 변환 파손. 취소도 커버)
      if (
        GRID_CASCADE_FILTERS[binding] ||
        GRID_EDIT_COMBO[binding] ||
        binding === 'ITEM_ID' ||
        binding === 'MEASURE' ||
        binding === 'FCST_TYPE'
      ) {
        col.dataMap = dataMapsRef.current[binding] ?? null;
      }

      const row = s.rows[e.row].dataItem as SalesPlanRow | undefined;
      if (!row) return;
      const rec = row as Record<string, unknown>;

      // ===== 동적 셀 — V-C1~C3 (AS-IS Dsdm_Changed L3937~3948 + LeaveCell L4322~4398) =====
      if (dynKindOf(binding)) {
        const measure = toCellStr(row.MEASURE);
        // V-C3 — MEASURE 빈 행 숫자 입력 롤백 (L3941 셀 clear)
        if (!measure) {
          rec[binding] = null;
          s.invalidate(true);
          return;
        }
        const oldVal = e.data ?? null;
        let val = toNumber(rec[binding]);
        // V-C1 — RTF_SYS_RP 음수 차단 (FcstType=RMA 만 음수 허용, L4358) + 정수 절삭 (L4390)
        if (measure === EDIT_MEASURE.RTF_SYS_RP) {
          if (toCellStr(row.FCST_TYPE) !== 'RMA' && val < 0) {
            rec[binding] = null;
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
        if (row.CRUD_TYPE !== 'I') {
          editTrackerRef?.current?.storeChange(
            row as never,
            binding,
            (oldVal ?? null) as never,
            (rec[binding] ?? null) as never
          );
        }
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
      // [통합테스트 1st No.61-④ 후반부] Team 파생 표시 — Sales Site / Project / Model(+End Customer)
      //   선택 행이 마스터(Sales Site Project Model)의 DEPT_ID 를 함께 내려주면 Team 셀을 그 값으로
      //   채운다. Team 은 입력 불가 컬럼이라 이 경로가 값의 유일한 출처다.
      //   관대 규칙: 선택 행에 DEPT_ID 컬럼 자체가 없으면 종전 값을 유지한다 — 콤보 SQL 이 컬럼을
      //   추가하는 순간 FE 수정 없이 자동 활성 (cascade 관대 통과와 동일 계약).
      if (changed && TEAM_SOURCE_BINDINGS.includes(binding)) {
        const sourceRows =
          binding === 'ITEM_ID'
            ? itemDropdownRowsRef.current
            : (comboRowsRef.current[binding] ?? []);
        const picked = sourceRows.find(r => toCellStr(r.CODE) === toCellStr(newVal));
        if (picked && 'DEPT_ID' in picked) {
          rec.DEPT_ID = toCellStr(picked.DEPT_ID);
          if ('TEAM_NAME' in picked) rec.TEAM_NAME = toCellStr(picked.TEAM_NAME);
        }
      }

      // ⭐ cascade 계단 clear (hook #59 §5-G — 상위 콤보 값이 실제로 바뀐 경우만)
      const clearTargets = GRID_CASCADE_CLEAR[binding];
      if (clearTargets && changed) {
        clearTargets.forEach(k => {
          rec[k] = '';
        });
      }
      editingCellRef.current = null;
      syncRowComboContext(row);
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
    // ⭐ 붙여넣기 후 처리 (AS-IS spdMain_ClipboardPasted L5572~5596) — ITEM_ID 포함 시 종속
    //   CELL_PROD_SITE_ID 콤보 재부착 + 동적 셀은 V-C 검증/추적 경로 공유.
    const pastedCellHandler = (
      s: FlexGridType<SalesPlanRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      const b = s.columns[e.col]?.binding ?? '';
      if (b === 'ITEM_ID') {
        const row = s.rows[e.row]?.dataItem as SalesPlanRow | undefined;
        if (row) syncRowComboContext(row);
        for (let i = 0; i < s.columns.length; i++) {
          const c = s.columns[i];
          const dm = dataMapsRef.current[c.binding ?? ''];
          if (dm && c.dataMap !== dm) c.dataMap = dm;
        }
        s.invalidate(true);
        return;
      }
      if (dynKindOf(b)) cellEditEndedHandler(s, e);
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
      // PROJECT_CODE 셀 (81·82 — L3834) / ITEM_ID 셀 (40 && Catch_Up — L3863)
      //   판정은 formatItem 의 Yellow/아이콘 과 동일 함수 (isInsertModalCell) 로 통일.
      if (!isInsertModalCell(binding, row, division)) return;
      onPopupCellDblClick?.(binding === 'PROJECT_CODE' ? 'PROJECT' : 'ITEM', row);
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
        g.selectionChanged?.removeHandler(selectionChangedHandler);
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
    dataMaps,
    syncRowComboContext,
  ]);

  // ⭐ hook #93 — 다단 헤더 총높이 48px 고정 (1단 48 / 2단 24×2 / 3단 16×3) + combo dataMap 재적용.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    if (!g) return;

    const applyHeaderHeight = () => {
      // (0-a) Filter sanitize — 동적(M_/W_/D_) binding 제거 (머지헤더 충돌 방지)
      const f = gridFilterRef?.current;
      if (f) {
        const cleaned = f.filterColumns.filter(b => !/^[MWD]_/.test(b));
        if (cleaned.length !== f.filterColumns.length) f.filterColumns = cleaned;
      }
      // (0-b) combo dataMap 재적용 — wrapper columnGroups 재적용이 col.dataMap 을 덮으므로 재부착(guard).
      //   편집 중인 컬럼은 제외 — beginningEditHandler 가 스왑한 편집 전용 dataMap(SCM_SITE_ID 등
      //   행종속 콤보 rowDataMaps / END_CUSTOMER 등 cascade dataMap / MEASURE·FCST_TYPE·ITEM_ID·
      //   CURRENCY 편집 콤보)을 이 guard 가 표시용 dataMap(dataMaps — division 단위)으로 되돌려버리면
      //   cascade 필터가 무력화된다 (updatedLayout 이 편집 중에도 재발화 — resize/invalidate/scroll 등).
      for (let i = 0; i < g.columns.length; i++) {
        if (g.editRange && g.editRange.col === i) continue;
        const col = g.columns[i];
        const dm = dataMaps[col.binding ?? ''];
        if (dm && col.dataMap !== dm) col.dataMap = dm;
      }
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
  }, [dynBindings, visibleColumns, dataMaps, gridRef, gridFilterRef]);

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
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
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

  // ⭐ F4 Filter — 피처 소유 FlexGridFilter (동적 컬럼 필터 제외 + 필터후 머지/높이 재적용)
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;

    const isDynamic = (binding: string | null | undefined): boolean =>
      /^[MWD]_/.test(binding ?? '');
    const onFilterChanging = (
      _s: FlexGridFilter,
      e: { cancel: boolean; getColumn: () => { binding?: string | null } }
    ) => {
      if (isDynamic(e.getColumn()?.binding)) e.cancel = true;
    };
    const onFilterApplied = () => g.invalidate(true);

    let f = gridFilterRef.current;
    if (!f || f.grid !== g) {
      f = new FlexGridFilter(g);
      f.filterColumns = [''];
      gridFilterRef.current = f;
    }
    f.filterChanging.addHandler(onFilterChanging as never);
    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      try {
        f?.filterChanging.removeHandler(onFilterChanging as never);
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, gridRef, gridFilterRef]);

  return (
    <div className={styles.gridContainer}>
      <DataGrid
        key={mainStaticColumns.map(c => c.colNm).join(',')}
        className={styles.grid}
        gridRef={gridRef as never}
        editTrackerRef={editTrackerRef as never}
        staticColumns={mainStaticColumns}
        dynamicColumns={mainDynamicColumns}
        itemsSource={rows as unknown as WijmoRowItem[]}
        autoGenerateColumns={false}
        allowSorting={true}
        allowMerging={AllowMerging.All}
        useAggregationRow={false} // [2026-08-12 사용자 지시] Footer Summary 삭제
      />
    </div>
  );
};
