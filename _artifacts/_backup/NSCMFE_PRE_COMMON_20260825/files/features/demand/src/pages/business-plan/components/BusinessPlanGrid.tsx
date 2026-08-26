import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useCallback, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, keepRowVisibleUnderFilter } from '@foundation/utils';
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
import { filterComboRowsByRow, toCellStr } from '../utils/business-plan.gridCombos';
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
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.colNm), [visibleColumns]);
  const staticBindingSet = useMemo(() => new Set(fixedBindings), [fixedBindings]);

  // ⭐ 컬럼 개인화 색 (ColumnLayoutModal 저장값) — binding → {cell, text}.
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
  //   ⚠⚠ **값 quoting 의무** — BE LookupServiceImpl.makeComboQuery 는 `@param2` 를 raw 치환하고,
  //     파라미터가 없을 때의 기본값이 `''`(따옴표 포함 빈 문자열)다. 즉 SQL 에서 @param 은 문자열
  //     리터럴 자리에 그대로 박히므로 값이 따옴표를 직접 들고 와야 한다.
  //     따옴표 없이 보내면 `WHERE LOOKUP_TYPE = BP_FCST_TYPE` 가 되어 컬럼명으로 해석 → 0건 →
  //     dataMap=null → 드롭다운 대신 텍스트 입력으로 남는다 (2026-08-07 실측).
  const q = (v: string): string => `'${v}'`;
  const comboFilters = useMemo(
    () =>
      comboColumns.map(c => {
        const comboId = String(c.cellCboDataTp);
        if (comboId === 'DM_LOOKUP_DIV') {
          return {
            comboId,
            param1: q(division),
            param2: q(c.attribute1?.trim() ?? ''),
          } as never;
        }
        return comboId as never;
      }),

    [comboColumns, division]
  );
  const comboResults = useTabComboQueries({ filters: comboFilters });

  // ⭐ Team 표시 전용 콤보 — 'TeambyDivision' (조회조건 Team 과 같은 원천).
  //   그리드 행의 DEPT_ID 는 조회 SP 가 SCM_MST_SITE_ITEM.DEPT_ID 로 채우는데, 메타 지정 콤보
  //   'DeptId' 는 SCM_MST_SITE.DEPT_ID 와 품목 OWNER 의 부서만 뽑아 코드 공간이 달라 매핑이
  //   안 잡힌다(코드가 그대로 노출). 표시만 같은 원천으로 덮고, 편집 콤보는 등록본 'DeptId' 를
  //   GRID_EDIT_COMBO 로 유지한다 — CELL_PROD_SITE 와 동일 구조.
  const [teamComboRows] = useTabComboQueries({
    filters: [{ comboId: 'TeambyDivision', divisionId: q(division) }] as never,
  });
  const teamSig = `${division}#${teamComboRows?.length ?? 'x'}`;
  const teamDataMap = useMemo<DataMap | null>(() => {
    const arr = ((teamComboRows ?? []) as unknown as Record<string, string>[]).filter(
      r => !r.DIVISION_ID || !division || r.DIVISION_ID === division
    );
    // 같은 DEPT_ID 가 division 별로 중복 반환될 수 있어 CODE 기준 dedup.
    const uniq = [...new Map(arr.map(r => [String(r.CODE ?? ''), r])).values()];
    return uniq.length > 0 ? new DataMap(uniq, 'CODE', 'NAME') : null;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [teamSig]);
  const comboSig = comboColumns
    .map((c, i) => `${c.cellCboDataTp}#${comboResults[i]?.length ?? 'x'}`)
    .join(',');
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const m: Record<string, DataMap | null> = {};
    comboColumns.forEach((c, i) => {
      const arr = comboResults[i] ?? [];
      m[c.colNm] = arr.length > 0 ? new DataMap(arr, 'CODE', 'NAME') : null;
    });
    // Team 표시 오버라이드 (위 teamDataMap 주석 참조) — 메타 콤보로는 코드가 안 풀린다.
    if (teamDataMap) {
      if ('DEPT_ID' in m) m.DEPT_ID = teamDataMap;
      if ('DEPT_ID40' in m) m.DEPT_ID40 = teamDataMap;
    }
    return m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig, teamDataMap]);

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

  // 신규행 필터 예외 재등록용 최신 rows 미러 (filterApplied 핸들러가 deps 밖에서 참조).
  const rowsRef = useRef<BusinessPlanRow[]>([]);
  rowsRef.current = rows;

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
      // 팝업 전용 셀(Project · Model) — 직접 타이핑은 막고 더블클릭 모달로만 입력한다
      //   (설계서 [사업부별 분기] '검색 모달 전용 칸'). 즉 **입력 수단이 있는 칸**이므로 다른 편집
      //   가능 셀과 같은 Yellow 로 보여야 한다 (2026-08-21 사용자 요구).
      //   insertStaticEditable 은 '직접 입력 가능' 판정이라 이 컬럼들에 false 를 주는 게 맞다
      //   (beginningEdit 의 타이핑 차단이 그 값을 쓴다) — 표시 판정에서만 따로 더한다.
      const isModalCell =
        isInsert &&
        ((binding === 'PROJECT_CODE' && !isDiv40(division) && !isDiv82(division)) ||
          (binding === 'PROJECT_CODE82' && isDiv82(division)) ||
          (binding === 'ITEM_ID' && !isDiv40(division)) ||
          (binding === 'ITEM_ID40' && isDiv40(division)));

      if (rowItem) {
        const editable = isInsert ? insertStaticEditable(binding, rowItem, division) : false;
        toggleClass(e.cell, 'wj-cell-editable', editable || isModalCell);
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

      // ⭐ 개인화 색 (ColumnLayoutModal 저장값) — 정적 컬럼만 (동적 기간 컬럼은 위에서 return).
      //   우선순위: Insert 편집셀 Yellow(클래스) > 저장된 Cell Color. inline !important 라 클래스보다
      //   세므로 편집 가능 Insert 셀에는 배경을 칠하지 않는다.
      //   미지정 시 removeProperty 필수 — Wijmo 셀 재활용으로 이전 컬럼 색이 남는다.
      const personalColor = colorMetaRef.current.get(binding);
      //   팝업 셀도 편집 가능 취급 — 개인화 배경색이 Yellow 를 덮지 않게 한다.
      const insertEditable =
        (!!rowItem && isInsert && insertStaticEditable(binding, rowItem, division)) || isModalCell;
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
        // ⭐ 머지된 상위 헤더 → 그룹 대표 binding 복원 (forecast-price 선례 1:1).
        //   hitTest 는 **커서 아래 물리 컬럼**을 준다(머지 원점이 아니다). 3단 헤더에서 1단(연)/
        //   2단(분기) 라벨은 머지 범위 **가운데** = M_ 컬럼들 위에 그려지므로, 그대로 두면 hb 가 M_
        //   로 잡혀 아래 Y/Q 가드에 걸린다 → 사용자가 실제로 누르는 연/분기 라벨에서 드릴다운이 죽고
        //   leaf 의 'SUM' 칸(Y_/Q_ 물리 컬럼 위)에서만 먹는다.
        //     1단(연) = Y_${연도} 직접 산출 — Y_/Q_/M_ 모두 slice(2,6) 이 연도다. 머지 좌단 대신
        //       직접 산출해야 Sum OFF 로 Y_ 가 숨은 상태에서도(컬럼 순서 무관) 연 드릴로 확정된다.
        //     2단(분기) = 머지 좌단 — mainDynamicColumns 가 그룹 내 Q_ → M_ 순으로 정렬하므로
        //       좌단이 Q_ (Y_ 의 'SUM' 그룹은 단독 세로머지라 좌단이 곧 Y_).
        //   leaf 행(Y_/Q_ 의 'SUM' · 월 낱개)은 물리 컬럼이 곧 대상이라 손대지 않는다.
        const leafRow = g.columnHeaders.rows.length - 1;
        let hb = g.columns[ht.col]?.binding ?? '';
        if (dynKindOf(hb) && ht.row < leafRow) {
          const merged = g.getMergedRange(g.columnHeaders, ht.row, ht.col);
          const leftBinding = merged ? (g.columns[merged.leftCol]?.binding ?? hb) : hb;
          const yearBinding = `Y_${hb.slice(2, 6)}`;
          hb = ht.row === 0 && dynBindings.includes(yearBinding) ? yearBinding : leftBinding;
        }
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

  // ⭐ 필터 상태에서 Insert — 값이 빈 신규행은 필터 조건에 걸려 CollectionView 에서 빠진다.
  //   공용 keepRowVisibleUnderFilter 로 wijmo 예외 집합(grid._newAddedRowsSet)에 등록해 보이게 한다.
  //   필터 자체의 보존은 공용 DataGrid 가 담당한다(itemsSourceChanged 의 capture -> clear -> restore).
  //   ⚠ 등록은 **한 번으로 끝나지 않는다**. FlexGridFilter.apply() 가 그 Set 을 null 로 비우는데
  //     (gridAction.ts keepRowVisibleUnderFilter 주석), DataGrid 의 필터 복원이 곧 apply() 라
  //     Insert 마다 예외가 날아가 신규행이 다시 숨는다 (2026-08-21 실측).
  //     ⇒ rows 변경 시 + filterApplied 시 **양쪽에서** 재등록한다.
  const reapplyInsertRowVisibility = useCallback((): boolean => {
    const g = (gridRef as { current: FlexGridType<BusinessPlanRow> | null } | null)?.current;
    // 컬럼이 없는 그리드에 refresh 를 걸면 wijmo 가 컬럼 인덱스 -1 로 계산하다 예외를 던진다.
    if (!g || g.columns.length === 0) return false;
    const insertRows = rowsRef.current.filter(r => r.CRUD_TYPE === 'I');
    if (insertRows.length === 0) return false;
    insertRows.forEach(row => keepRowVisibleUnderFilter(g as never, row as never));
    return true;
  }, [gridRef]);

  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<BusinessPlanRow> | null } | null)?.current;
    if (reapplyInsertRowVisibility()) g?.collectionView?.refresh();
  }, [gridRef, rows, reapplyInsertRowVisibility]);

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
    // 필터가 적용될 때마다 정의(JSON)를 떠 둔다. Insert 로 itemsSource 가 갈리면 FlexGridFilter 가
    //   스스로 clear() 하므로, 아래 복원 effect 가 이 값으로 되살린다.
    //   ⚠ 이 등록은 **FlexGridFilter 를 만드는 이 effect 안에서** 해야 한다. 별도 effect 로 빼면
    //     인스턴스 생성보다 먼저 실행돼 gridFilterRef.current 가 undefined 라 핸들러가 안 붙고,
    //     기억된 정의가 영원히 빈 문자열로 남아 필터가 그대로 풀린다 (2026-08-21 실측).
    // ⚠ 여기서 새 FlexGridFilter 를 만들면 안 된다 (2026-08-21 실측 — "필터 걸고 행추가하니 필터가 풀림").
    //   공용 DataGrid 가 itemsSourceChanged 에 [capture -> FlexGridFilter 생성(=wijmo clear) -> restore]
    //   를 **등록 순서**로 걸어 필터를 되살린다. 여기서 두 번째 인스턴스를 만들면 그 clear 핸들러가
    //   restore **뒤에** 붙어 마지막에 실행되므로 복원분이 도로 지워진다.
    //   ⇒ DataGrid 에 gridFilterRef 를 넘겨 인스턴스를 공유하고(아래 JSX), 없을 때만 안전망으로 만든다.
    //     (forecast-price 가 쓰는 배선 1:1 — `if (!gridFilterRef.current)` 가드.)
    if (!gridFilterRef.current) {
      const created = new FlexGridFilter(g);
      created.filterColumns = [''];
      gridFilterRef.current = created;
    }
    const f = gridFilterRef.current;
    // apply() 가 방금 예외 집합을 비웠으므로 여기서 되살린다.
    //   ⚠ refresh 는 rAF 로 미룬다 — filterApplied 핸들러 안에서 부르면 wijmo apply() 도중
    //     재진입이 되어 내부 인덱스가 어긋난다 (DMF0082 주석 참고).
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
    f.filterChanging.addHandler(onFilterChanging as never);
    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      window.cancelAnimationFrame(raf);
      try {
        f?.filterChanging.removeHandler(onFilterChanging as never);
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, gridRef, gridFilterRef, reapplyInsertRowVisibility]);

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
      itemsSource={rows as unknown as WijmoRowItem[]}
      autoGenerateColumns={false}
      allowSorting={true}
      allowMerging={AllowMerging.All}
    />
    // </div>
  );
};
