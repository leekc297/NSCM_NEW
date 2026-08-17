import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, DataMap } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridFilter as FlexGridFilterCtor } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { ComboParam, RawFlexGridColumnConfig } from '@foundation/models';
import { rebindFilterColumns } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import type { SalesReportRow, SpreadTitleRow } from '../sales-reports.types';
import styles from '../SalesReports.module.scss';
import {
  dynKindOf,
  evalSalesReportCell,
  staticEditableByMeta,
} from '../utils/sales-reports.editLock';
import {
  buildDataMap,
  DEPARTMENT_CHANGE_CLEAR,
  filterComboRowsByRow,
  GRID_CASCADE_FILTERS,
  resolveDeptIdRows,
  ROW_COMBO_IDS,
  toCellStr,
} from '../utils/sales-reports.gridCombos';
import { SalesReportsMergeManager } from '../utils/sales-reports.merge';

// ⭐ DMF0044 SalesReportsGrid — business-plan Grid 축약 (M_ 단일축 · **1단 헤더**[월 라벨 '2025-01'] ·
//   배분/롤업 없음 · 2행 Measure 블록은 행 데이터 차원 — Grid 는 셀 편집만).
//   편집 게이트 = evalSalesReportCell 4변수 매트릭스 (EDIT_FLAG×Measure×Div×시점 + ALL 차단).
//   AS-IS spdMain_Changed L1295~1302: 수치셀 빈값 → '0' 강제 (cellEditEnded 파리티).
//   ITEM_ID 셀 더블클릭 → Item 팝업 (값 '기타매출' 제외 — 제약매트릭스 M-8 L93).

interface Props {
  rows: SalesReportRow[];
  gridRef: Ref<FlexGridType<SalesReportRow>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  onItemCellDblClick?: (row: SalesReportRow) => void;
  divisionId?: string;
  dataType?: string;
  thisMonth?: string; // yyyymm — 조회 시점 고정 (store)
  staticColumns?: RawFlexGridColumnConfig[];
  spreadTitle?: SpreadTitleRow[];
}

const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  const n = typeof v === 'number' ? v : Number(toCellStr(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

export const SalesReportsGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onItemCellDblClick,
  divisionId,
  dataType = 'ALL',
  thisMonth = '',
  staticColumns,
  spreadTitle,
}: Props) => {
  const division = divisionId ?? '';

  // ⭐ 정적 컬럼 — admin 메타 100% 주도 (hook #113 — visible/display 2 boolean 만, FALLBACK 금지)
  const visibleColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => (staticColumns ?? []).filter(c => c.visible !== false && c.display !== false),
    [staticColumns]
  );
  const fixedBindings = useMemo(() => visibleColumns.map(c => c.colNm), [visibleColumns]);
  const staticBindingSet = useMemo(() => new Set(fixedBindings), [fixedBindings]);

  // ⭐ 정적 컬럼도 **1단 헤더**로 강제 (2026-08-10).
  //   공용 `packages/foundation/src/utils/columnMapping.ts` 의 `getColumnDepth` 는 메타의
  //   `sClsLblNm`/`lClsLblNm` 만 보고 단수를 정한다. DMF0044 메타에는 3행
  //   (BIZ_TYPE / BIZ_TYPE_NAME40 / SOLDTO_CUST_REPORT)이 `SCLS=LCLS≠colLbl` 이라 **2단**이 된다.
  //   ⚠ 그런데 **AS-IS 도 메타는 동일**하다(2026-08-10 AS-IS DB 전수 대조 — 46행 집합 일치).
  //     AS-IS 화면은 `DMF0044_Sales_Reports.cs:235~236` 이 `iColumnHeaderRowCount = 1` 을 넘겨
  //     **코드가 1단을 강제**하고, 그 경우 클래스 라벨은 표시에 쓰이지 않는다.
  //   ⇒ 메타(원본 라벨)는 **건드리지 않고**, 화면이 1단임을 선언한다 = AS-IS 계약 1:1.
  //     (공용 컴포넌트에는 "몇 단" 을 넘기는 prop 이 없고, 전역 prop 변경은 금지 규약.)
  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
        ...c,
        visible: true,
        display: true,
        sClsLblNm: '',
        lClsLblNm: '',
      })),
    [visibleColumns]
  );

  // ===== Grid 콤보 — UI Category 메타(cellCboDataTp) 기반 (DMF0044_MDF_DEPARTMENT 등 기등록) =====
  const comboColumns = useMemo(
    () =>
      visibleColumns.filter(
        c => (c.cellCtrlObjTpCd as unknown as string) === 'FPComboBox' && !!c.cellCboDataTp
      ),
    [visibleColumns]
  );
  // ⭐ 셀 콤보 바인드 파라미터 — AS-IS 프레임워크 계약 1:1 (2026-08-09 보완, DMF0042 선례 이식).
  //   AS-IS `SpreadInfo.cs:1975~1981` 이 메타 콤보에 **커서 ATTRIBUTE1~5 를 sParam1~5 로** 넘기고,
  //   그 커서(`DMF0044_GET_SPREAD_TITLE` L87~89)가 채우는 값 =
  //     · ATTRIBUTE1 = `@p_division_id`  ("COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다")
  //     · ATTRIBUTE2 = `CASE WHEN CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 …`
  //   ⇒ 전 메타 셀 콤보에 division, `DM_LOOKUP_DIV` 에는 추가로 컬럼 ATTRIBUTE1(LOOKUP_TYPE).
  //   ⛔ 미전달 시 `B.SEGMENT1=@param1 AND A.LOOKUP_TYPE=@param2` 가 '' 비교가 되어 **항상 0행**.
  //   BE makeComboQuery 는 raw 치환이라 값은 작은따옴표로 감싼다(hook #117 §5.8). 여분 키는 무해.
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const comboResults = useTabComboQueries({
    // 반환 타입 명시 — ComboParam 은 `[key: string]: string` 인덱스 시그니처라
    //   삼항 추론 union 의 `divisionId?: undefined` 가 대입 불가가 된다(TS2322).
    filters: comboColumns.map(
      (c): ComboParam =>
        c.cellCboDataTp === 'DM_LOOKUP_DIV'
          ? { comboId: 'DM_LOOKUP_DIV', param1: q(division), param2: q(c.attribute1) }
          : { comboId: c.cellCboDataTp as string, divisionId: q(division) }
    ),
  });
  // ⚠ division 을 시그니처에 포함한다 — 미포함 시 division 전환 후 행수가 우연히 같으면
  //   useMemo 가 재계산되지 않아 **이전 division 의 dataMap 이 잔존**한다(DMF0042 실측).
  const comboSig = comboColumns
    .map((c, i) => `${c.cellCboDataTp}@${division}#${comboResults[i]?.length ?? 'x'}`)
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
  // ⭐ 행별 콤보 원천 (2026-08-09 이관) — AS-IS `.cs` 가 SetCellTypeCombo 로 붙이던 분.
  //   메타(SHEET_COLUMNS)에는 AS-IS 도 바인딩이 없어 별도 fetch 가 원천이다.
  const rowComboIds = useMemo(() => Object.values(ROW_COMBO_IDS), []);
  const rowComboResults = useTabComboQueries({
    filters: rowComboIds.map(id =>
      // DEPT_DEFAULT(TEAM2)만 division 분기 — AS-IS Param1 은 division (UP_FX TEAM2 분기)
      id === ROW_COMBO_IDS.DEPT_DEFAULT ? { comboId: id, divisionId: q(division) } : id
    ),
  });
  const rowComboSig = rowComboIds
    .map((id, i) => `${id}@${division}#${rowComboResults[i]?.length ?? 'x'}`)
    .join(',');
  const rowComboRef = useRef<Record<string, Record<string, unknown>[]>>({});
  useEffect(() => {
    const m: Record<string, Record<string, unknown>[]> = {};
    rowComboIds.forEach((id, i) => {
      m[id] = (rowComboResults[i] ?? []) as unknown as Record<string, unknown>[];
    });
    rowComboRef.current = m;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rowComboSig]);

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

  // ===== 동적 컬럼 메타 — GET_SPREAD_TITLE 우선, 부재 시 row 키 union fallback (M_ 단일축) =====
  //   ⭐ 2026-08-10 — **1단 헤더**로 전환. AS-IS `DMF0044_Sales_Reports.cs:235~236` 가
  //     `SetSheetHeaderColumn(siMain, 1)` / `CreateSheetHeaderColumnDtDiv(siMain, 1, …)` 로
  //     **iColumnHeaderRowCount = 1** 을 넘긴다(2단 화면은 DMF0072/DMF0074 처럼 2를 넘긴다).
  //     실제로 `DMF0044_GET_SPREAD_TITLE` 의 동적 컬럼은 LARGE/SMALL/COLUMN_LABEL_NAME 이 모두
  //     `2025-01` 동일값이라, 2단으로 묶으면 '2025-01' 그룹 아래 '2025-01' 1개짜리가 12개 생겼다.
  type DynColMeta = { binding: string; label: string; sort: number };
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const titleRows = (spreadTitle ?? []).filter(r => dynKindOf(String(r.COLUMN_NAME ?? '')));
    if (titleRows.length > 0) {
      return titleRows
        .map<DynColMeta>(r => ({
          binding: String(r.COLUMN_NAME),
          // 라벨 원천 = COLUMN_LABEL_NAME('2025-01'). 부재 시에만 binding 에서 yyyy-mm 합성.
          label: String(
            r.COLUMN_LABEL_NAME ??
              `${String(r.COLUMN_NAME).slice(2, 6)}-${String(r.COLUMN_NAME).slice(6, 8)}`
          ),
          sort: Number(r.SORT_ORDER_NO ?? 0),
        }))
        .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    if (!rows || rows.length === 0) return [];
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) if (dynKindOf(k)) set.add(k);
    }
    return [...set].sort().map<DynColMeta>(b => ({
      binding: b,
      label: `${b.slice(2, 6)}-${b.slice(6, 8)}`,
      sort: 0,
    }));
  }, [spreadTitle, rows]);
  const dynBindings = useMemo(() => dynColMetas.map(m => m.binding), [dynColMetas]);

  // editLock 파라미터 ref 미러 (핸들러 공유)
  const lockCtxRef = useRef({ division, dataType, thisMonth });
  lockCtxRef.current = { division, dataType, thisMonth };

  // 주의: 콜백은 반드시 ref 미러로 받아 아래 대형 effect 의 deps 에서 뺀다.
  //   부모가 인라인 화살표로 넘기면 렌더마다 identity 가 바뀌는데, 그게 deps 에 있으면
  //   조회조건 콤보를 하나 바꿀 때마다(= 부모 리렌더) effect 가 재실행되어 말미의
  //   `g.invalidate(true)` 가 셀 DOM 을 통째로 다시 그린다 = 화면 깜빡임 (2026-08-12).
  const onItemCellDblClickRef = useRef(onItemCellDblClick);
  onItemCellDblClickRef.current = onItemCellDblClick;

  // ⭐ 정적 컬럼 입력형(UI Category Setup `INPUT_TP_CD`) — 편집·색 판정의 단일 원천.
  //   핸들러가 effect 안에서 등록되므로 ref 미러로 최신 메타를 본다(lockCtxRef 와 동형).
  const inputTpRef = useRef<Map<string, string | undefined>>(new Map());
  inputTpRef.current = new Map(
    visibleColumns.map(c => [c.colNm, c.inputTpCd as string | undefined])
  );

  // ⭐ 동적 PIVOT 컬럼 — **1단 평면**(AS-IS iColumnHeaderRowCount=1). nested columnGroups 사용 금지.
  //   헤더 높이 48px 고정(hook #93) — 1단이므로 행 1개가 48을 그대로 갖는다.
  //
  //   ⚠️ **`_inputEditType` 필수** (2026-08-10 실사고 — "노란색인데 편집이 안 됨").
  //   공용 `DataGrid` 가 `setEditableColumns()` 로 자체 `beginningEdit` 을 걸고
  //   `GridUtils.isEditableCell()` 로 1차 판정하는데, 그 함수는 컬럼의 **`_inputEditType`** 만 본다
  //   (정적 컬럼은 `mapColumn()` 이 `inputTpCd` → `_inputEditType` 으로 변환해 주지만,
  //    **동적 컬럼은 raw 로 전달**되므로 `inputTpCd` 로 주면 변환되지 않아 `undefined` → `default: false`).
  //   ⇒ 여기서 `_inputEditType` 을 직접 준다. 정본: forecast-price/ForecastPriceGrid.tsx:479.
  //   최종 판정은 아래 `beginningEdit` 의 `evalDyn`(AS-IS 4변수 매트릭스)이 하므로
  //   **색(formatItem)과 편집 게이트가 같은 함수를 본다**(둘이 갈리면 "노란칸인데 못 고침"이 생긴다).
  const mainDynamicColumns = useMemo(
    () =>
      dynColMetas.map(m => ({
        binding: m.binding,
        header: m.label,
        align: 'right',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: 48,
        _display: true,
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      })),
    [dynColMetas]
  ) as never[];

  // ===== grid 핸들러 + mergeManager =====
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesReportRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1; // zebra (#95)
    for (let i = 0; i < g.columnFooters.rows.length; i++) g.columnFooters.rows[i].visible = false;

    const evalDyn = (binding: string, row: SalesReportRow | undefined) =>
      evalSalesReportCell({
        binding,
        row,
        divisionId: lockCtxRef.current.division,
        dataType: lockCtxRef.current.dataType,
        thisMonth: lockCtxRef.current.thisMonth,
      });

    const toggleClass = (el: HTMLElement, cls: string, on: boolean) => {
      if (on) el.classList.add(cls);
      else el.classList.remove(cls);
    };

    const formatHandler = (_s: FlexGridType<SalesReportRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const col = g.columns[e.col];
      const binding = col?.binding ?? '';
      const rowItem = g.rows[e.row]?.dataItem as SalesReportRow | undefined;
      if (dynKindOf(binding)) {
        // ⭐ 편집 가능/노란색 = **AS-IS EditButton 매트릭스**(`evalDyn`) 로 판정한다 (2026-08-11 복원).
        //   [경위] 2026-08-10 에 "EDIT_FLAG 표준 패턴 위임" 으로 바꾸면서 매트릭스가 게이트에서 빠졌고,
        //   `evalDyn` 은 정의만 남고 **호출 0건인 죽은 코드**가 됐다. 그 결과 Cutoff(Data Type=1) 행은
        //   `EDIT_FLAG` 가 구조적으로 'N'(SP L1377 `(V_GROUP_ID='ADMIN') AND (DATA_TYPE='2')`)이라
        //   **ADMIN 이어도 전부 잠겼다** — AS-IS 는 Edit 버튼을 누르면 편집 모드로 들어간다.
        //   [현재] TO-BE 는 Edit 버튼이 없으므로(BTN_MPG_M 에 EDIT 미등록) **조회 시점에 AS-IS Edit
        //   버튼과 동일한 액션**을 적용한다(사용자 지시 2026-08-11). 매트릭스 원문 = `.cs` L318~370.
        //   ⚠ 색(여기)과 편집(beginningEdit)이 **같은 `evalDyn` 하나**를 보므로 둘이 갈릴 수 없다.
        //     공용 `formatEditableColumns` 가 먼저 EDIT_FLAG 로 칠한 것을 뒤에 등록된 이 핸들러가 덮는다.
        //
        //   ⚠️ **`editRange` 가드 필수** (2026-08-11 실사고 — ETC 조회 시 "노란색인데 편집 불가").
        //   `formatItem` 은 **편집 중인 셀에도 발생**한다(Wijmo 가 편집기 <input> 을 셀에 넣은 뒤 셀을 갱신).
        //   가드 없이 `textContent` 를 대입하면 방금 삽입된 <input> 이 지워져, 공용 판정을 통과하고
        //   노란색까지 정상인데 타이핑만 불가능한 상태가 된다(색·편집 판정은 결백 — 둘 다
        //   `GridUtils.isEditableCell` 하나를 공유하고 `EDIT_FLAG='Y'` 로 true 였다).
        //   자매 화면 3본이 모두 같은 가드를 갖고 있다:
        //     forecast-price/ForecastPriceGrid.tsx / business-plan/BusinessPlanGrid.tsx
        //     / sales-plan/SalesPlanGrid.tsx  ← 본 화면에만 누락돼 있었다.
        if (g.editRange?.contains(e.row, e.col)) return; // 편집 중 셀은 건드리지 않는다
        toggleClass(e.cell, 'wj-cell-editable', evalDyn(binding, rowItem).editable);
        const v = rowItem?.[binding];
        const n = toNumber(v);
        e.cell.textContent = v == null || v === '' || n === 0 ? '' : n.toLocaleString();
        return;
      }
      if (staticBindingSet.has(binding) && rowItem) {
        // 색상 판정도 편집 게이트와 **같은 함수**를 쓴다 — 두 곳이 갈리면 노란칸인데 못 고치는 상태가 생긴다
        const editable = staticEditableByMeta(inputTpRef.current.get(binding), rowItem);
        toggleClass(e.cell, 'wj-cell-editable', editable);
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — 게이트 + cascade 콤보 스왑 (hook #59 §5-G)
    const editingCellRef: { current: { binding: string } | null } = { current: null };
    const beginningEditHandler = (
      s: FlexGridType<SalesReportRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as SalesReportRow | undefined;
      if (staticBindingSet.has(binding)) {
        // UI Category Setup `INPUT_TP_CD` 단일 원천 (IM/IO=신규행만, M/O=전 행, S=불가).
        //   AS-IS InsertRow 잠금 파리티는 메타 값('S')으로 보존한다 — 여기 하드코딩 금지.
        const allowed = staticEditableByMeta(inputTpRef.current.get(binding), row);
        if (!allowed) {
          e.cancel = true;
          return;
        }
        // ⭐ 행별 콤보 스왑 (2026-08-09 이관) — AS-IS 가 `.cs` 에서 행마다 붙이던 콤보를
        //   편집 진입 시점에 행 컨텍스트로 골라 붙인다. 편집 종료 시 원복(cellEditEnded).
        const rowDm =
          binding === 'DEPT_ID'
            ? buildDataMap(
                resolveDeptIdRows(row, {
                  deptDefault: rowComboRef.current[ROW_COMBO_IDS.DEPT_DEFAULT] ?? [],
                  deptByDepartment: rowComboRef.current[ROW_COMBO_IDS.DEPT_BY_DEPARTMENT] ?? [],
                  deptEtc: rowComboRef.current[ROW_COMBO_IDS.DEPT_ETC] ?? [],
                })
              )
            : binding === 'CUST_REPORT'
              ? buildDataMap(rowComboRef.current[ROW_COMBO_IDS.CUST_REPORT] ?? [])
              : binding === 'PRODUCT_GROUP'
                ? buildDataMap(rowComboRef.current[ROW_COMBO_IDS.PRODUCT_GROUP] ?? [])
                : null;
        if (rowDm) {
          s.columns[e.col].dataMap = rowDm;
          editingCellRef.current = { binding };
          return;
        }

        // cascade 스왑 — 메타 콤보를 상위 셀 값으로 필터 (AS-IS ComboSelChange M-6)
        const cascade = GRID_CASCADE_FILTERS[binding];
        const src = comboRowsRef.current[binding];
        if (cascade && src && row) {
          const dm = buildDataMap(filterComboRowsByRow(src, row, cascade));
          if (dm) {
            s.columns[e.col].dataMap = dm;
            editingCellRef.current = { binding };
          }
        }
        return;
      }
      // ⭐ 동적(M_) 셀 = **AS-IS EditButton 매트릭스**로 최종 판정 (2026-08-11 복원).
      //   TO-BE 에는 Edit 버튼이 없으므로(BTN_MPG_M 미등록) 조회 시점에 동일 액션을 적용한다.
      //   공용 `setEditableColumns` 가 `EDIT_FLAG='N'` 으로 이미 cancel 해 둔 셀이라도,
      //   매트릭스가 허용하면 **`e.cancel = false` 로 되살린다** (이 핸들러가 나중에 등록되어 뒤에 실행).
      //   AS-IS `.cs` L318~370 6분기: EDIT_FLAG='Y' 전개방 / LOC 계획구간 / RTF·Business_Plan×40 전구간
      //                              / 기타×40 과거구간 / 비40 잠금 (+ Data Type=ALL 전면 차단 L272~276)
      e.cancel = !evalDyn(binding, row).editable;
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 편집 종료 — 수치셀 빈값 → '0' (AS-IS L1295~1302) + cascade dataMap 원복
    const cellEditEndedHandler = (
      s: FlexGridType<SalesReportRow>,
      e: { row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as SalesReportRow | undefined;
      if (dynKindOf(binding) && row && (row[binding] == null || row[binding] === '')) {
        (row as Record<string, unknown>)[binding] = '0';
      }
      // ⭐ DEPARTMENT_ID 변경 → 하위 컬럼 clear (AS-IS L1187~1191 / L1211~1215 — 양 분기 동일 5컬럼).
      //   DEPT_ID 후보는 다음 편집 진입 시 `resolveDeptIdRows` 가 새 DEPARTMENT_ID 로 다시 고른다.
      if (binding === 'DEPARTMENT_ID' && row) {
        const rec = row as Record<string, unknown>;
        DEPARTMENT_CHANGE_CLEAR.forEach(col => {
          rec[col] = '';
        });
        rec.DEPT_ID = '';
        s.invalidate();
      }
      // cascade 원복
      if (editingCellRef.current?.binding === binding) {
        const orig = dataMapsRef.current[binding];
        if (orig !== undefined) s.columns[e.col].dataMap = orig;
        editingCellRef.current = null;
      }
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler as never);

    // ITEM_ID 셀 더블클릭 — 값 '기타매출' 제외 (제약매트릭스 M-8 L93 — DM0002 Item 팝업)
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = g.rows[ht.row]?.dataItem as SalesReportRow | undefined;
      if (!row || binding !== 'ITEM_ID') return;
      if (toCellStr(row.ITEM_ID).trim() === '기타매출') return;
      onItemCellDblClickRef.current?.(row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // 스크롤 시 재렌더(merge 재계산용). ⚠ 편집 중에는 건너뛴다 — 편집기가 붙은 셀을 다시 그리면
    //   입력이 끊긴다(위 formatItem editRange 가드와 같은 계열의 사고. 자매 3본에는 이 핸들러가 없다).
    const handleScrollInvalidate = () => {
      if (g.editRange) return;
      g.invalidate();
    };
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.mergeManager = new SalesReportsMergeManager(fixedBindings);
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler as never);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
        g.scrollPositionChanged?.removeHandler(handleScrollInvalidate);
      } catch {
        /* unmount race */
      }
    };
    // 재실행 조건은 컬럼 구성 변경뿐이다 — 콜백 identity 는 위 ref 미러로 끊었다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, fixedBindings]);

  // ⭐ hook #93 — 헤더 총 48px. DMF0044 는 **1단**이므로 행 1개가 48 을 그대로 갖는다
  //   (2단 화면이면 24+24 로 자동 분배 — `48 / headerRows.length`). + combo dataMap 재적용 + Filter sanitize
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesReportRow> | null } | null)?.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const f = gridFilterRef?.current;
      if (f) {
        const cleaned = f.filterColumns.filter(b => !/^M_/.test(b));
        if (cleaned.length !== f.filterColumns.length) f.filterColumns = cleaned;
      }
      // (0-a2) [공통 UC-07, hook #133 §5] 재조회해도 사용자가 걸어둔 **필터가 유지**되어야 한다.
      //   columnGroups 재대입이 Column 객체를 통째로 재생성해, FlexGridFilter 가 죽은 Column 을
      //   붙든 채 남으면 "아이콘은 꺼졌는데 행은 걸러진" 상태가 된다. 끊긴 필터만 재바인딩한다
      //   (끊긴 게 없으면 no-op — 되먹임 방지 가드는 유틸 내부). 위 sanitize 로 제외한 동적(M_)
      //   컬럼은 이미 filterColumns 에서 빠져 되살아나지 않는다. 2026-08-15 보완.
      rebindFilterColumns(
        g as unknown as FlexGridType<WijmoRowItem>,
        gridFilterRef?.current
      );
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const dm = dataMaps[col.binding ?? ''];
        if (dm && col.dataMap !== dm) col.dataMap = dm;
      }
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
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, visibleColumns, dataMaps, gridRef, gridFilterRef]);

  // F4 Filter — 동적(M_) 컬럼 필터 cancel
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<SalesReportRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;
    const onFilterChanging = (
      _s: FlexGridFilter,
      e: { cancel: boolean; getColumn: () => { binding?: string | null } }
    ) => {
      if (/^M_/.test(e.getColumn()?.binding ?? '')) e.cancel = true;
    };
    const onFilterApplied = () => g.invalidate(true);
    let f = gridFilterRef.current;
    if (!f || f.grid !== g) {
      f = new FlexGridFilterCtor(g);
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
