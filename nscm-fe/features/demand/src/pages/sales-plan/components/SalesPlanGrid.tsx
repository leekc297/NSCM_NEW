import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
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
import styles from '../SalesPlan.module.scss';
import { isDiv40 } from '../utils/sales-plan.division';
import {
  buildCutoff,
  buildMeasureAuth,
  dynKindOf,
  evalSalesPlanDynCell,
  insertStaticEditable,
} from '../utils/sales-plan.editLock';
import {
  applyMeasureSwitch,
  buildCatchUpFcstTypeMap,
  buildMeasureInfoMap,
  filterComboRowsByRow,
  toCellStr,
} from '../utils/sales-plan.gridCombos';
import { getDynKey, HierarchicalMergeManager } from '../utils/sales-plan.merge';

// 동적 컬럼 kind 서열 — M(월)=0 상위 … D(일)=2 하위. 표시 규칙/드릴다운 판정용 (DMF0003 동일).
const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

interface Props {
  rows: SalesPlanRow[];
  gridRef: Ref<FlexGridType<SalesPlanRow>>;
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
  gridFilterRef,
  editTrackerRef,
  onPopupCellDblClick,
  divisionId,
  bucketType = BUCKET_TYPE.MONTHLY,
  sumYn = false,
  staticColumns,
  spreadTitle,
  calendarInfo,
  editAuth,
  measureInfoRows,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const division = divisionId ?? '';
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
    return s;
  }, [calendarInfo]);
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

  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
        ...c,
        visible: true,
        display: true,
      })),
    [visibleColumns]
  );

  // ===== Grid 내 combo column dropdown — UI Category 메타(cellCboDataTp) 기반 (DMF0020/0003 표준) =====
  //   콤보 SQL 은 파라미터 없는 등록명만 사용 (BE makeComboQuery raw 치환 — DMF0003 2026-07-03 실측 근거).
  const comboColumns = useMemo(
    () =>
      visibleColumns.filter(
        c => (c.cellCtrlObjTpCd as unknown as string) === 'FPComboBox' && !!c.cellCboDataTp
      ),
    [visibleColumns]
  );
  const comboResults = useTabComboQueries({
    filters: comboColumns.map(c => c.cellCboDataTp as string),
  });
  const comboSig = comboColumns
    .map((c, i) => `${c.cellCboDataTp}#${comboResults[i]?.length ?? 'x'}`)
    .join(',');
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    comboColumns.forEach((c, i) => {
      const arr = comboResults[i] ?? [];
      m[c.colNm] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);

  // cascade 스왑용 콤보 원본 rows + 전체 dataMap 원복 ref 미러 (핸들러 useEffect deps 밖 참조).
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

  // ⭐ 편집 전용 콤보 (hook #59 §5-G — 편집 진입 시 스왑, cellEditEnded 원복):
  //   CURRENCY = 'CurrencyList' (AS-IS dtCurrencyList L3000) / MEASURE = measureInfo SP (L2925) /
  //   FCST_TYPE(Catch_Up) = 'FcstType' 전체에서 ETC 제외 클라 필터 (L4903).
  const editComboEntries = useMemo(() => Object.entries(GRID_EDIT_COMBO), []);
  const editComboResults = useTabComboQueries({
    filters: editComboEntries.map(([, cfg]) => cfg.comboId),
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

  const measureInfoMap = useMemo(
    () => buildMeasureInfoMap(measureInfoRows ?? []),
    [measureInfoRows]
  );
  const measureInfoMapRef = useRef<DataMap | null>(null);
  measureInfoMapRef.current = measureInfoMap;

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
  };
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const kindOf = (b: string): 'M' | 'W' | 'D' | null =>
      /^M_\d{6}$/.test(b) ? 'M' : /^W_\d{7,10}$/.test(b) ? 'W' : /^D_\d{8}$/.test(b) ? 'D' : null;
    // (1) GET_SPREAD_TITLE 우선
    const titleRows = (spreadTitle ?? []).filter(r => !!kindOf(String(r.COLUMN_NAME ?? '')));
    if (titleRows.length > 0) {
      return titleRows
        .map<DynColMeta>(r => ({
          binding: String(r.COLUMN_NAME),
          kind: kindOf(String(r.COLUMN_NAME))!,
          large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
          small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
          leaf: String(r.COLUMN_LABEL_NAME ?? ''),
          sort: Number(r.SORT_ORDER_NO ?? 0),
        }))
        .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    // (2) fallback — 데이터 row 키 union (라벨 = binding 파생)
    if (!rows || rows.length === 0) return [];
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        if (kindOf(k)) set.add(k);
      }
    }
    return [...set].sort().map<DynColMeta>(b => {
      const dyn = getDynKey(b);
      return { binding: b, kind: kindOf(b)!, large: dyn.ym, small: dyn.sub, leaf: dyn.leaf, sort: 0 };
    });
  }, [spreadTitle, rows]);

  // binding 순서 목록 + 표시 규칙 rank 분리 (활성 bucket=표시 / 상위 합계=sumYn / 하위=드릴 전용 — DMF0003 1:1)
  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
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
            ? (m.small ||
                (/^W_\d{7,9}$/.test(m.binding) && !/^W_\d{8}$/.test(m.binding)
                  ? `W${m.binding.slice(8)}`
                  : getDynKey(m.binding).sub)
              ).trim() || 'SUM'
            : (m.small || getDynKey(m.binding).sub).trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)!.push({
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
      });
    });
    // sub 정렬: 'SUM'(월합계) 최우선 → 주차 오름차순. leaf 정렬: 합계(M/W) 먼저 → 일자 binding 순.
    const subOrder = (k: string): number => (k === 'SUM' ? -1 : Number(k.replace(/\D/g, '') || 0));
    const leafKind = (b: string): 'M' | 'W' | 'D' =>
      /^M_/.test(b) ? 'M' : /^W_/.test(b) ? 'W' : 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: 48,
        columns: [...bucket.subs.entries()]
          .sort(([a], [b]) => subOrder(a) - subOrder(b))
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

    // ⭐ footer Sum 미표시 — 사용자 확정 2026-07-15 "Grid Footer Summary Visible = false".
    //   (AS-IS InitSpreadFooterSum 은 있었으나 TO-BE 제외. 기 생성분(HMR 잔재) 도 숨김)
    for (let i = 0; i < g.columnFooters.rows.length; i++) {
      g.columnFooters.rows[i].visible = false;
    }

    const formatHandler = (_s: FlexGridType<SalesPlanRow>, e: FormatItemEventArgs) => {
      // #108 — No. 코너 헤더 (TopLeft 단일 라벨)
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.cell.textContent !== 'No.') e.cell.textContent = 'No.';
        e.cell.style.textAlign = 'center';
        return;
      }
      const col = e.panel.columns[e.col];
      if (!col) return;

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        // ⭐ 당월 M_/당주 W_ 헤더 Green Bold (AS-IS chkColor OFF 기본 — 커서 2 기준. Color 체크박스 제거 확정)
        const isCurrentPeriod = !!col.binding && currentPeriodBindingsRef.current.has(col.binding);
        e.cell.style.color = isCurrentPeriod ? '#1e8449' : '';
        e.cell.style.fontWeight = isCurrentPeriod ? '700' : '';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      if (!col.binding) return;

      const binding = col.binding;
      const rowItem = (e.panel.rows[e.row] as unknown as { dataItem?: SalesPlanRow })?.dataItem;
      const isDyn = !staticBindingSet.has(binding) && !!dynKindOf(binding);
      const isInsert = rowItem?.CRUD_TYPE === 'I';

      if (isDyn) {
        // 당주/당월 컬럼 세로 레일 (배경색과 독립 — 편집 Yellow 와 공존)
        toggleClass(e.cell, 'sp-cell-current-period', currentPeriodBindingsRef.current.has(binding));
        // ⭐ editLock R1~R4 — 편집가능 Yellow / 과거 Gray / 그 외 White (#95 — 전체회색·inline 금지)
        const state = evalSalesPlanDynCell({
          binding,
          row: rowItem,
          divisionId: division,
          bucketType,
          cutoff,
          auth,
        });
        toggleClass(e.cell, 'wj-cell-editable', state.editable);
        toggleClass(e.cell, 'wj-cell-non-editable', !state.editable && state.isPast);
        // ⭐ 변경 셀 Red (AS-IS Dsdm_Changed L3948 — EditTracker 단일 소스 + 신규 행 입력 셀)
        const tracked =
          rowItem &&
          (editTrackerRef?.current?.getOriginalValues() as
            | Map<SalesPlanRow, Record<string, unknown>>
            | undefined)?.get(rowItem)?.[binding] !== undefined;
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
        const editable = insertStaticEditable(binding, rowItem, division);
        toggleClass(e.cell, 'wj-cell-editable', editable);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        const measure = toCellStr(rowItem.MEASURE);
        const isModalCell =
          (binding === 'PROJECT_CODE' && !isDiv40(division)) ||
          (binding === 'ITEM_ID' && isDiv40(division) && measure === EDIT_MEASURE.CATCH_UP);
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
        // ⭐ 편집 전용 콤보 스왑 — MEASURE(measureInfo SP)/FCST_TYPE(Catch_Up ETC 제외)/CURRENCY(CurrencyList)
        if (binding === 'MEASURE' && measureInfoMapRef.current) {
          col.dataMap = measureInfoMapRef.current;
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
        // ⭐ cascade dataMap 스왑 — 행 컨텍스트(상위 셀 값)로 콤보 후보 필터 (관대 통과)
        const cascade = GRID_CASCADE_FILTERS[binding];
        if (cascade && comboRowsRef.current[binding]) {
          const filtered = filterComboRowsByRow(comboRowsRef.current[binding], row, cascade);
          if (filtered.length > 0) col.dataMap = new DataMap(filtered, 'CODE', 'NAME');
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

      // ⭐ 스왑 원복 (hook #59 §5-G — 원복 누락 시 필터 밖 CODE 보유 타 행 명칭 변환 파손. 취소도 커버)
      if (
        (GRID_CASCADE_FILTERS[binding] ||
          GRID_EDIT_COMBO[binding] ||
          binding === 'MEASURE' ||
          binding === 'FCST_TYPE') &&
        dataMapsRef.current[binding]
      ) {
        col.dataMap = dataMapsRef.current[binding];
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
      // ⭐ cascade 계단 clear (hook #59 §5-G — 상위 콤보 값이 실제로 바뀐 경우만)
      const clearTargets = GRID_CASCADE_CLEAR[binding];
      if (clearTargets && changed) {
        clearTargets.forEach(k => {
          rec[k] = '';
        });
      }
      editingCellRef.current = null;
      s.invalidate(true);
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
      if (binding === 'PROJECT_CODE' && !isDiv40(division)) {
        onPopupCellDblClick?.('PROJECT', row);
        return;
      }
      if (
        binding === 'ITEM_ID' &&
        isDiv40(division) &&
        toCellStr(row.MEASURE) === EDIT_MEASURE.CATCH_UP
      ) {
        onPopupCellDblClick?.('ITEM', row);
      }
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
    dataMaps,
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
      // (0-b) combo dataMap 재적용 — wrapper columnGroups 재적용이 col.dataMap 을 덮으므로 재부착(guard)
      for (let i = 0; i < g.columns.length; i++) {
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
  }, [sumYn, summaryBindings, drillBindings, dynBindings, gridRef]);

  // ⭐ 당주/당월 헤더 강조 — 조회 응답(커서 2) 갱신 시 formatItem 재실행 (최신 binding 반영).
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    g?.invalidate(true);
  }, [calendarInfo, gridRef]);

  // ⭐ F4 Filter — 피처 소유 FlexGridFilter (동적 컬럼 필터 제외 + 필터후 머지/높이 재적용)
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesPlanRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;

    const isDynamic = (binding: string | null | undefined): boolean => /^[MWD]_/.test(binding ?? '');
    const onFilterChanging = (_s: FlexGridFilter, e: { cancel: boolean; getColumn: () => { binding?: string | null } }) => {
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
      />
    </div>
  );
};
