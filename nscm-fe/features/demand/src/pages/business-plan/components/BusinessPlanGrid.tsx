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

import type { ComboParam, FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
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
} from '../business-plan.constants';
import type { BusinessPlanRow, SpreadTitleRow } from '../business-plan.types';
import styles from '../BusinessPlan.module.scss';
import { isDiv40, isDiv82 } from '../utils/business-plan.division';
import {
  type BizPlanCutoff,
  dynKindOf,
  evalBizPlanDynCell,
  insertStaticEditable,
  parseDynTag,
  type ValidWindow,
} from '../utils/business-plan.editLock';
import { buildDataMap, filterComboRowsByRow, toCellStr } from '../utils/business-plan.gridCombos';
import { HierarchicalMergeManager } from '../utils/business-plan.merge';
import { applyCellChange } from '../utils/business-plan.spread';

// 동적 컬럼 kind 서열 — Y(연)=0 상위 … M(월)=2 하위. 표시 규칙/드릴다운 판정용
//   (플랜 §E 확정: 활성 bucket=표시 / 상위 SUM=sumYn / 하위=드릴 전용. AS-IS SetSpreadColumn L466~498 대응).
const DYN_RANK = { Y: 0, Q: 1, M: 2 } as const;

interface Props {
  rows: BusinessPlanRow[];
  gridRef: Ref<FlexGridType<BusinessPlanRow>>;
  // F4 Filter — 피처가 FlexGridFilter 직접 소유. 동적(Y_/Q_/M_) 컬럼 필터 cancel + 필터후 머지/높이 재적용.
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  // F7 Save — EditTracker 로 변경 셀 추적(Red 마킹 단일 소스) + 비-insert 행 자동 CRUD_TYPE='M' 마킹.
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  // 셀 모달 2종 — PROJECT(81·82 신규행) / ITEM(전 division 신규행). AS-IS spdMain_CellDoubleClick L1640~1797.
  onPopupCellDblClick?: (modalKey: 'PROJECT' | 'ITEM', row: BusinessPlanRow) => void;
  divisionId?: string;
  bucketType?: BUCKET_TYPE;
  // Sum 체크박스 — 상위 버킷 SUM 컬럼(Y_/Q_) 표시 토글 (AS-IS chkSum L2832 — 조회 없이 즉시 반영).
  sumYn?: boolean;
  // admin SYS0004 UI Category Setup 동적 메타 (SHEET_COLUMNS 63건 — division 서버 직접 비교, hook #113).
  staticColumns?: RawFlexGridColumnConfig[];
  // DMF0042_GET_SPREAD_TITLE 결과 — 동적 3단 헤더(연/분기/월)의 1차 소스.
  spreadTitle?: SpreadTitleRow[];
  // editLock 기준 — 금주 월요일 cutoff (조회 p_now_yyyymmdd 와 동일 원천) + 40 유효구간 (커서 2).
  cutoff?: BizPlanCutoff | null;
  validWindow?: ValidWindow | null;
}

// 숫자 변환 — 콤마 제거, 비숫자 0.
const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  const n = typeof v === 'number' ? v : Number(toCellStr(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

// ⭐ measure 별 숫자 포맷 (AS-IS spdMain_Changed — Business_Plan=long 정수 / LOC 등=double 실수).
//   0/null/빈 셀 = 빈칸.
const formatByMeasure = (v: unknown, measure: string): string => {
  if (v == null || v === '' || v === 0) return '';
  const n = toNumber(v);
  if (n === 0) return '';
  if (measure === EDIT_MEASURE.BUSINESS_PLAN || measure === 'CAR_QTY' || measure === 'MKT_FCST') {
    return Math.trunc(n).toLocaleString();
  }
  return n.toLocaleString(undefined, { maximumFractionDigits: 3 });
};

export const BusinessPlanGrid = ({
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
  cutoff,
  validWindow,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const division = divisionId ?? '';

  // ⭐ 정적 컬럼 — admin(UI Category Setup) 메타 100% 주도. 하드코딩/화이트리스트/FALLBACK 금지 (hook #113).
  //   FE 는 VISIBLE_FLAG(admin 관리 노출) + DISPLAY_FLAG(사용자 Column Setup 선택) 만 반영.
  // ⭐ MEASURE 는 Column Setting 대상에서 제외하고 정적 컬럼 마지막에 항상 표시한다
  //   (2026-08-05 사용자 확정 — admin 메타 VISIBLE_FLAG/개인화 display 와 무관하게 상시 노출).
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    const cols = staticColumns ?? [];
    const base = cols.filter(
      c => c.colNm !== 'MEASURE' && c.visible !== false && c.display !== false
    );
    const measure = cols.find(c => c.colNm === 'MEASURE');
    return measure ? [...base, { ...measure, visible: true, display: true }] : base;
  }, [staticColumns]);
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
  //   실측 콤보: DEPT_ID·DEPT_ID40=DeptId / END_CUSTOMER=EndCustomerByDivisionDept /
  //   END_CUSTOMER40=EndCustomerByDivision40 / SCM_SITE_ID40=SiteByEndCustomer / INCOTERMS=IncotermsEdit /
  //   INCOTERMS82=Incoterms / FCST_TYPE=DM_LOOKUP_DIV / PLANT_SITE_ID=FromSiteByDivision /
  //   MEASURE=DMF0042_BP_Measure (SHEET_COLUMNS 2026-07-15 실측).
  const comboColumns = useMemo(
    () =>
      visibleColumns.filter(
        c => (c.cellCtrlObjTpCd as unknown as string) === 'FPComboBox' && !!c.cellCboDataTp
      ),
    [visibleColumns]
  );
  // ⭐ 셀 콤보 바인드 파라미터 — AS-IS 프레임워크 계약 1:1 (2026-08-09 보완).
  //   AS-IS `SpreadInfo.cs:1975~1981` : 메타 콤보는 **커서 ATTRIBUTE1~5 를 sParam1~5 로** 넘긴다.
  //   그 커서(`DMF0042_GET_SPREAD_TITLE`) 가 채우는 값 =
  //     · ATTRIBUTE1 = `@p_division_id`  ("COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다" 주석)
  //     · ATTRIBUTE2 = `CASE WHEN CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE '' END`
  //   ⇒ **모든 메타 셀 콤보에 division**, `DM_LOOKUP_DIV` 에는 추가로 컬럼 ATTRIBUTE1(LOOKUP_TYPE).
  //   TO-BE CMBO 는 named token 이라 division 계열 = `@divisionId`, DM_LOOKUP_DIV = `@param1`/`@param2`.
  //   ⛔ 미전달 시 `DM_LOOKUP_DIV`(FCST_TYPE) 는 `B.SEGMENT1=@param1 AND A.LOOKUP_TYPE=@param2` 가
  //      '' 비교가 되어 **항상 0행**(조용한 빈 콤보) — 2026-08-09 게이트 섹션 7 FAIL 실측.
  //   BE makeComboQuery 는 raw 치환이므로 값은 작은따옴표로 감싼다(hook #117 §5.8). 여분 키는 무해.
  //   값 quoting 헬퍼는 조회조건(BusinessPlanForm)과 **동일 규약**을 쓴다 — 빈 값은 'ALL' 센티널
  //   (memory feedback_bind_combo_value_quoting: 빈 '' 는 CASE-IN 계열에서 전멸한다).
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const comboResults = useTabComboQueries({
    filters: comboColumns.map((c): ComboParam =>
      c.cellCboDataTp === 'DM_LOOKUP_DIV'
        ? { comboId: 'DM_LOOKUP_DIV', param1: q(division), param2: q(c.attribute1) }
        : { comboId: c.cellCboDataTp as string, divisionId: q(division) }
    ),
  });
  // ⚠ division 을 시그니처에 포함한다 — 미포함 시 division 전환 후 행수가 우연히 같으면
  //   useMemo 가 재계산되지 않아 **이전 division 의 dataMap 이 잔존**한다.
  const comboSig = comboColumns
    .map((c, i) => `${c.cellCboDataTp}@${division}#${comboResults[i]?.length ?? 'x'}`)
    .join(',');
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    comboColumns.forEach((c, i) => {
      m[c.colNm] = buildDataMap((comboResults[i] ?? []) as unknown as Record<string, unknown>[]);
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

  // ⭐ 편집 전용 콤보 (hook #59 §5-G) — CURRENCY = 'CurrencyList' (AS-IS InsertRow L1184)
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
      m[binding] = buildDataMap((editComboResults[i] ?? []) as unknown as Record<string, unknown>[]);
    });
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [editComboSig]);
  const editDataMapsRef = useRef<Record<string, DataMap | null>>({});
  useEffect(() => {
    editDataMapsRef.current = editDataMaps;
  }, [editDataMaps]);

  // 편집 시작 셀의 (binding, oldVal) — cellEditEnded 에서 실제 값 변경 여부 판정.
  const editingCellRef = useRef<{ binding: string; oldVal: unknown } | null>(null);

  // ⭐ 동적 기간 컬럼 메타 — GET_SPREAD_TITLE 1차 소스 (B_* 는 kindOf null 로 자동 제외 = 항상 숨김).
  type DynColMeta = {
    binding: string;
    kind: 'Y' | 'Q' | 'M';
    large: string;
    small: string;
    leaf: string;
    sort: number;
  };
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    // (1) GET_SPREAD_TITLE 우선
    const titleRows = (spreadTitle ?? []).filter(r => !!dynKindOf(String(r.COLUMN_NAME ?? '')));
    if (titleRows.length > 0) {
      return titleRows
        .map<DynColMeta>(r => ({
          binding: String(r.COLUMN_NAME),
          kind: dynKindOf(String(r.COLUMN_NAME))!,
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
        if (dynKindOf(k)) set.add(k);
      }
    }
    // 정렬: 연 → (Y_ 선두) → 분기 → (Q_ 선두) → 월 (AS-IS 헤더 순: 연 SUM → 분기 SUM → 월들)
    const orderKey = (b: string): string => {
      const tag = parseDynTag(b)!;
      const q = tag.kind === 'Y' ? 0 : tag.quarter;
      const m = tag.kind === 'M' ? tag.month : 0;
      return `${tag.year}-${q}-${tag.kind === 'Y' ? 0 : tag.kind === 'Q' ? 1 : 2}-${String(m).padStart(2, '0')}`;
    };
    return [...set]
      .sort((a, b) => orderKey(a).localeCompare(orderKey(b)))
      .map<DynColMeta>(b => {
        const tag = parseDynTag(b)!;
        return {
          binding: b,
          kind: tag.kind,
          large: String(tag.year),
          small: tag.kind === 'Y' ? 'SUM' : `Q${tag.quarter}`,
          leaf: tag.kind === 'M' ? String(tag.month).padStart(2, '0') : 'SUM',
          sort: 0,
        };
      });
  }, [spreadTitle, rows]);

  // binding 순서 목록 + 표시 규칙 rank 분리 (활성 bucket=표시 / 상위 SUM=sumYn / 하위=드릴 전용)
  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  const bucketRank = DYN_RANK[bucketType as 'Y' | 'Q' | 'M'];
  const summaryBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] < bucketRank).map(m => m.binding),
    [dynColMetas, bucketRank]
  );
  const drillBindings = useMemo<string[]>(
    () => dynColMetas.filter(m => DYN_RANK[m.kind] > bucketRank).map(m => m.binding),
    [dynColMetas, bucketRank]
  );
  // 드릴 오버라이드(binding → visible) — bucket/sum/조회 변경 시 리셋 (AS-IS SetSpreadColumn 재실행 1:1).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  // editLock 파라미터 ref 미러 (formatItem/beginningEdit 핸들러 공유)
  const cutoffRef = useRef<BizPlanCutoff | null>(null);
  const windowRef = useRef<ValidWindow | null>(null);
  cutoffRef.current = cutoff ?? null;
  windowRef.current = validWindow ?? null;

  // ⭐ 동적 PIVOT 컬럼 — 3단 nested (연 → 분기/SUM → leaf). 라벨 = GET_SPREAD_TITLE 제공값.
  //   AS-IS SetSpreadHeaderSpan (Y_/Q_/M_ 3단 + SUM 헤더) 대응. SUM = 각 그룹 선두 leaf (플랜 §E).
  const mainDynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    type SubBucket = { label: string; cols: LeafCol[]; order: number };
    type YearBucket = { label: string; subs: Map<string, SubBucket>; order: number };
    const yearMap = new Map<string, YearBucket>();
    dynColMetas.forEach((m, idx) => {
      const tag = parseDynTag(m.binding);
      if (!tag) return;
      const yKey = String(tag.year);
      let yb = yearMap.get(yKey);
      if (!yb) {
        yb = { label: m.kind === 'Y' ? m.large || yKey : yKey, subs: new Map(), order: idx };
        yearMap.set(yKey, yb);
      }
      // 2단 키 — Y_='SUM'(연 SUM 단독) / Q_·M_=분기.
      const subKey = tag.kind === 'Y' ? 'SUM' : `Q${tag.quarter}`;
      if (!yb.subs.has(subKey)) {
        yb.subs.set(subKey, {
          label: tag.kind === 'Y' ? 'SUM' : m.kind === 'Q' ? m.small || subKey : subKey,
          cols: [],
          order: tag.kind === 'Y' ? -1 : tag.quarter,
        });
      }
      yb.subs.get(subKey)!.cols.push({
        binding: m.binding,
        // 3단(leaf) 라벨 — M=월 라벨 / Q·Y=SUM.
        header: tag.kind === 'M' ? m.leaf || String(tag.month).padStart(2, '0') : 'SUM',
        align: 'right',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: 48, // 다단 헤더 높이(#93) — 동적 컬럼 명시 의무 (wrapper 는 static 만 자동)
        _display: true,
      });
    });
    // leaf 정렬: Q_ SUM 먼저 → 월 오름차순 (AS-IS SUM = 그룹 선두 컬럼)
    const leafOrder = (b: string): number => {
      const tag = parseDynTag(b)!;
      return tag.kind === 'M' ? tag.month : -1;
    };
    return [...yearMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(yb => ({
        header: yb.label,
        align: 'center',
        height: 48,
        columns: [...yb.subs.values()]
          .sort((a, b) => a.order - b.order)
          .map(sub => ({
            header: sub.label,
            align: 'center',
            height: 48,
            columns: sub.cols.sort((a, b) => leafOrder(a.binding) - leafOrder(b.binding)),
          })),
      }));
  }, [dynColMetas]);

  // ⭐ grid 핸들러 + mergeManager useEffect 등록.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<BusinessPlanRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    // 홀짝 zebra (#95)
    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    // footer Sum 미표시 — AS-IS SUM 은 footer 아닌 그룹 선두 컬럼 (플랜 §A)
    for (let i = 0; i < g.columnFooters.rows.length; i++) {
      g.columnFooters.rows[i].visible = false;
    }

    const formatHandler = (_s: FlexGridType<BusinessPlanRow>, e: FormatItemEventArgs) => {
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
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      if (!col.binding) return;

      const binding = col.binding;
      const rowItem = (e.panel.rows[e.row] as unknown as { dataItem?: BusinessPlanRow })?.dataItem;
      const isDyn = !staticBindingSet.has(binding) && !!dynKindOf(binding);
      const isInsert = rowItem?.CRUD_TYPE === 'I';

      if (isDyn) {
        // ⭐ editLock R1~R4 — 편집가능 Yellow / 과거 Gray / 그 외 White (#95 — 전체회색·inline 금지)
        const state = evalBizPlanDynCell({
          binding,
          row: rowItem,
          divisionId: division,
          bucketType,
          cutoff: cutoffRef.current,
          window: windowRef.current,
        });
        toggleClass(e.cell, 'wj-cell-editable', state.editable);
        toggleClass(e.cell, 'wj-cell-non-editable', !state.editable && state.isPast);
        // ⭐ 변경 셀 Red (AS-IS SetCellColor Red — EditTracker 단일 소스 + 신규 행 입력 셀)
        const tracked =
          rowItem &&
          (
            editTrackerRef?.current?.getOriginalValues() as
              | Map<BusinessPlanRow, Record<string, unknown>>
              | undefined
          )?.get(rowItem)?.[binding] !== undefined;
        const insertInput = isInsert && rowItem?.[binding] != null && rowItem?.[binding] !== '';
        toggleClass(e.cell, 'bp-cell-changed', !!tracked || !!insertInput);
        // ⭐ measure 별 숫자 포맷 (편집 중 셀 제외)
        if (!g.editRange?.contains(e.row, e.col)) {
          const measure = toCellStr(rowItem?.MEASURE);
          e.cell.innerText = formatByMeasure(rowItem?.[binding], measure);
        }
        return;
      }

      // ⭐ 콤보 dataMap 계층 indent 보존 (memory feedback_measure_combo_indent_whitespace)
      if (binding === 'MEASURE') e.cell.style.whiteSpace = 'pre';

      // 정적 셀 — Insert 행 화이트리스트(R5)만 Yellow. 기존행 정적 영역은 전량 잠금
      //   (2026-07-21 G2 — 신정본 EditButton L649 LockRange 활성 / INCO·FCST unlock 블록 L651~667 전체 주석).
      if (rowItem) {
        const editable = isInsert ? insertStaticEditable(binding, rowItem, division) : false;
        toggleClass(e.cell, 'wj-cell-editable', editable);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        const isModalCell =
          isInsert &&
          ((binding === 'PROJECT_CODE' && !isDiv40(division) && !isDiv82(division)) ||
            (binding === 'PROJECT_CODE82' && isDiv82(division)) ||
            (binding === 'ITEM_ID' && !isDiv40(division)) ||
            (binding === 'ITEM_ID40' && isDiv40(division)));
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

    // ===== 편집 시작 — R5/R6 정적 + R1~R4 동적 판정 + 콤보 dataMap 스왑 (hook #59 §5-G) =====
    const beginningEditHandler = (
      s: FlexGridType<BusinessPlanRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';
      const row = s.rows[e.row].dataItem as BusinessPlanRow | undefined;

      if (staticBindingSet.has(binding)) {
        // 정적 셀 — Insert 행 화이트리스트만. 기존행 = 전량 잠금 (G2 — 신정본 L649/L651~667 주석 파리티)
        const allowed =
          !!row && row.CRUD_TYPE === 'I' && insertStaticEditable(binding, row, division);
        if (!allowed) {
          e.cancel = true;
          return;
        }
        e.cancel = false;
        editingCellRef.current = { binding, oldVal: (row as Record<string, unknown>)[binding] };
        // ⭐ 편집 전용 콤보 스왑 — CURRENCY(CurrencyList)
        if (GRID_EDIT_COMBO[binding] && editDataMapsRef.current[binding]) {
          col.dataMap = editDataMapsRef.current[binding];
          return;
        }
        // ⭐ cascade dataMap 스왑 — 행 컨텍스트(상위 셀 값)로 콤보 후보 필터 (관대 통과)
        const cascade = GRID_CASCADE_FILTERS[binding];
        if (cascade && comboRowsRef.current[binding] && row) {
          const filtered = filterComboRowsByRow(comboRowsRef.current[binding], row, cascade);
          if (filtered.length > 0) col.dataMap = new DataMap(filtered, 'CODE', 'NAME');
        }
        return;
      }
      // 동적 셀 — R1~R4 종합. FIFO 마지막 핸들러 → e.cancel 명시 설정이 wrapper 보다 우선.
      if (dynKindOf(binding)) {
        const state = evalBizPlanDynCell({
          binding,
          row,
          divisionId: division,
          bucketType,
          cutoff: cutoffRef.current,
          window: windowRef.current,
        });
        e.cancel = !state.editable;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    // 붙여넣기 게이트 — 편집 가드와 동일 판정
    g.pastingCell.addHandler(beginningEditHandler as never);

    // ===== 편집 종료 — dataMap 원복 + 배분/롤업 엔진 + EditTracker 마킹 =====
    const cellEditEndedHandler = (
      s: FlexGridType<BusinessPlanRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      const col = s.columns[e.col];
      const binding = col.binding ?? '';

      // ⭐ 스왑 원복 (hook #59 §5-G — 원복 누락 시 필터 밖 CODE 보유 타 행 명칭 변환 파손. 취소도 커버)
      if (
        (GRID_CASCADE_FILTERS[binding] || GRID_EDIT_COMBO[binding]) &&
        dataMapsRef.current[binding]
      ) {
        col.dataMap = dataMapsRef.current[binding];
      }

      const row = s.rows[e.row].dataItem as BusinessPlanRow | undefined;
      if (!row) return;
      const rec = row as Record<string, unknown>;

      // ===== 동적 셀 — 배분·롤업 (AS-IS spdMain_Changed L1800~2723 → spread 엔진) =====
      if (dynKindOf(binding)) {
        const measure = toCellStr(row.MEASURE);
        if (!measure) {
          rec[binding] = null;
          s.invalidate(true);
          return;
        }
        const { patches, truncated } = applyCellChange({
          rowValues: rec,
          binding,
          value: rec[binding],
          measure,
          dynBindings,
          thisMonth: cutoffRef.current?.thisMonth ?? '',
        });
        // EditTracker — patch 전 셀(oldVal)→후 셀 추적 (Red 마킹·SAVE 수집 단일 소스)
        for (const [b, v] of Object.entries(patches)) {
          const oldVal = b === binding ? (e.data ?? null) : (rec[b] ?? null);
          rec[b] = v;
          if (row.CRUD_TYPE !== 'I') {
            editTrackerRef?.current?.storeChange(
              row as never,
              b,
              (oldVal ?? null) as never,
              (v ?? null) as never
            );
          }
        }
        // Business_Plan 소수 절삭 안내 (AS-IS L1853 MSG00289 → MSG00679)
        if (truncated) {
          void setAlert({
            type: 'alert',
            content: t(MSG.BP_INTEGER_ONLY, '_Business Plan 데이터는 정수로 입력해 주세요.'),
          });
        }
        s.invalidate(true);
        return;
      }

      // ===== 정적 셀 — cascade 계단 clear (정의 시) =====
      if (!staticBindingSet.has(binding)) return;
      const prev = editingCellRef.current;
      const newVal = rec[binding];
      const changed = prev?.binding === binding && toCellStr(prev.oldVal) !== toCellStr(newVal);
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
    // 붙여넣기 후 처리 — 동적 셀은 배분/추적 경로 공유
    const pastedCellHandler = (
      s: FlexGridType<BusinessPlanRow>,
      e: { row: number; col: number; data?: unknown }
    ) => {
      const b = s.columns[e.col]?.binding ?? '';
      if (dynKindOf(b)) cellEditEndedHandler(s, e);
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // ===== 더블클릭 — 헤더 드릴다운 + 셀 모달 (AS-IS spdMain_CellDoubleClick L1598~1797) =====
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      // 헤더 — Y_ 헤더: 해당 연 Q_ 토글 + 열린 M_ 접기 / Q_ 헤더: 해당 분기 M_ 토글 (L1600~1639)
      if (ht.cellType === CellType.ColumnHeader) {
        const hb = g.columns[ht.col]?.binding ?? '';
        const hk = dynKindOf(hb);
        if (hk !== 'Y' && hk !== 'Q') return;
        const idx = dynBindings.indexOf(hb);
        if (idx < 0) return;
        const flip = (target: string, hideOnly: boolean) => {
          const targetCol = g.getColumn(target);
          if (!targetCol) return;
          if (hideOnly && !targetCol.visible) return; // AS-IS: 열린 M_ 만 접기 (Y_ 드릴)
          drillVisRef.current.set(target, hideOnly ? false : !targetCol.visible);
        };
        for (let i = idx + 1; i < dynBindings.length; i++) {
          const target = dynBindings[i];
          const tk = dynKindOf(target);
          if (hk === 'Y') {
            if (tk === 'Y') break;
            if (tk === 'Q') flip(target, false);
            else if (tk === 'M') flip(target, true);
          } else {
            if (tk === 'Q' || tk === 'Y') break;
            if (tk === 'M') flip(target, false);
          }
        }
        applyDynVisibilityRef.current?.();
        return;
      }
      if (ht.cellType !== CellType.Cell) return;
      // 데이터 셀 — 신규(I) 행만 (AS-IS 조기 가드 IsLock || Action!='I' L1643)
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = g.rows[ht.row]?.dataItem as BusinessPlanRow | undefined;
      if (!row || row.CRUD_TYPE !== 'I') return;
      // PROJECT_CODE(81)/PROJECT_CODE82(82) — L1699~1797 / ITEM_ID(81·82)/ITEM_ID40(40) — L1640~1698
      if (
        (binding === 'PROJECT_CODE' && !isDiv40(division) && !isDiv82(division)) ||
        (binding === 'PROJECT_CODE82' && isDiv82(division))
      ) {
        onPopupCellDblClick?.('PROJECT', row);
        return;
      }
      if (
        (binding === 'ITEM_ID' && !isDiv40(division)) ||
        (binding === 'ITEM_ID40' && isDiv40(division))
      ) {
        onPopupCellDblClick?.('ITEM', row);
      }
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // Scroll 시 머지 그룹 재계산 (viewport sticky — AS-IS TopChange SmartColMerge L2736~2741)
    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    // ===== 머지 활성 + HierarchicalMergeManager (utils/business-plan.merge.ts) =====
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
    validWindow,
    division,
    bucketType,
    dataMaps,
  ]);

  // ⭐ hook #93 — 다단 헤더 총높이 48px 고정 (3단=16×3) + combo dataMap 재적용 + Filter sanitize.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<BusinessPlanRow> | null } | null)?.current;
    if (!g) return;

    const applyHeaderHeight = () => {
      // (0-a) Filter sanitize — 동적(Y_/Q_/M_) binding 제거 (머지헤더 충돌 방지)
      const f = gridFilterRef?.current;
      if (f) {
        const cleaned = f.filterColumns.filter(b => !/^[YQM]_/.test(b));
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

  // ⭐ Sum 체크박스 + 헤더 드릴다운 — 동적 컬럼 visible 통합 적용 (AS-IS SetSpreadColumn L466~498 +
  //   헤더 더블클릭 1:1). 규칙: 활성 bucket=표시 / 상위 SUM=sumYn / 하위=숨김 — 드릴 오버라이드 우선.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<BusinessPlanRow> | null } | null)?.current;
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

  // ⭐ F4 Filter — 피처 소유 FlexGridFilter (동적 컬럼 필터 제외 + 필터후 머지/높이 재적용)
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<BusinessPlanRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;

    const isDynamic = (binding: string | null | undefined): boolean =>
      /^[YQM]_/.test(binding ?? '');
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
  );
};
