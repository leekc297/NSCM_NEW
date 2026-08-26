import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, DataMap } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridFilter as FlexGridFilterCtor } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { ComboParam, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { dataScaleOf, DEFAULT_DATA_SCALE } from '../etc-sales-reports.constants';
import type { EtcSalesReportRow, SpreadTitleRow } from '../etc-sales-reports.types';
import styles from '../EtcSalesReports.module.scss';
import {
  dynKindOf,
  evalEtcReportCell,
  staticEditableByMeta,
} from '../utils/etc-sales-reports.editLock';
import {
  buildDataMap,
  cascadeClearColumns,
  resolveDeptIdRows,
  ROW_COMBO_IDS,
  toCellStr,
} from '../utils/etc-sales-reports.gridCombos';
import { EtcSalesReportsMergeManager, setKeyOf } from '../utils/etc-sales-reports.merge';

// ⭐ DMF0049 EtcSalesReportsGrid — sales-reports(DMF0044) Grid 이식 (M_ 단일축 · **1단 헤더**
//   [월 라벨 '2025-01'] · 배분/롤업 없음 · 2행 Measure 블록은 행 데이터 차원 — Grid 는 셀 편집만).
//   편집 게이트 = evalEtcReportCell 4변수 매트릭스 (EDIT_FLAG×Measure×Div×시점 + ALL 차단).
//   AS-IS spdMain_Changed L1295~1302: 수치셀 빈값 → '0' 강제 (cellEditEnded 파리티).
//   ITEM_ID 셀 더블클릭 → Item 팝업 (값 '기타매출' 제외 — 제약매트릭스 M-8 L93).

interface Props {
  rows: EtcSalesReportRow[];
  gridRef: Ref<FlexGridType<EtcSalesReportRow>>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker | undefined>;
  onProjectCellDblClick?: (row: EtcSalesReportRow) => void;
  divisionId?: string;
  planResult?: string; // 'Plan' | 'Result'
  mdfType?: string; // REPORT_SP_W | REPORT_BP_M
  yyyy?: string;
  thisMonth?: string; // yyyymm — 조회 시점 고정 (store)
  sEditMeasure?: string; // DM_LOOKUP_DIV(div,'DM_SR_ETC_CURRENCY') 첫 CODE
  userGroup?: string;
  staticColumns?: RawFlexGridColumnConfig[];
  spreadTitle?: SpreadTitleRow[];
}

const toNumber = (v: unknown): number => {
  if (v == null || v === '') return 0;
  const n = typeof v === 'number' ? v : Number(toCellStr(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

// 음수 값 글자색 (DMF0003 mkt-fcst / demand-manager 와 동일 톤)
const NEGATIVE_COLOR = '#c0392b';

const paintNegative = (cell: HTMLElement, value: number): void => {
  if (value < 0) cell.style.setProperty('color', NEGATIVE_COLOR, 'important');
  else cell.style.removeProperty('color');
};

export const EtcSalesReportsGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onProjectCellDblClick,
  divisionId,
  planResult = 'Plan',
  mdfType = 'REPORT_SP_W',
  yyyy = '',
  thisMonth = '',
  sEditMeasure = '',
  userGroup = '',
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

  // ⭐ 정적 컬럼도 **1단 헤더**로 강제 (2026-08-11 — DMF0044 2026-08-10 선례 이식).
  //   공용 `packages/foundation/src/utils/columnMapping.ts` 의 `getColumnDepth` 는 메타의
  //   `sClsLblNm`/`lClsLblNm` 만 보고 단수를 정하므로, 클래스 라벨이 채워진 행이 하나라도 있으면 2단이 된다.
  //   ⚠ AS-IS 도 메타는 동일하고, `DMF0049_Sales_ETC_Reports.cs:265` 가
  //     `CreateSheetHeaderColumnDtDiv(siMain, **1**, …)` 로 **iColumnHeaderRowCount = 1** 을 넘겨
  //     **코드가 1단을 강제**한다(그 경우 클래스 라벨은 표시에 쓰이지 않는다).
  //   ⇒ 메타(원본 라벨)는 **건드리지 않고**, 화면이 1단임을 선언한다 = AS-IS 계약 1:1.
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
  // ⭐ AS-IS 콤보 파라미터 계약 (SpreadInfo.cs L1975~1981 ← DMF0049_GET_SPREAD_TITLE):
  //   ATTRIBUTE1 = @p_division_id → param1 / CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV' 이면
  //   컬럼 ATTRIBUTE1 → param2(LOOKUP_TYPE). 값은 따옴표로 감싼다(BE raw 치환 — 미따옴표 = ORA 오류).
  //   ⚠ 2026-08-10 실측: 무전달 시 DM_LOOKUP_DIV 3컬럼 전부 **0행**(BIZ_TYPE/ITEM_ID/ITEM_USE)
  //     → 그리드가 CODE 를 raw 로 표시. 전달 시 40 BIZ_TYPE 6 / 40 ITEM_ID 16 / 82 ITEM_USE 7.
  const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
  const comboResults = useTabComboQueries({
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

  // ===== 행별 콤보 — AS-IS `.cs` 런타임 SetCellTypeCombo 분 (메타에 컬럼이 없어 별도 구독) =====
  //   DEPT_ID 부모키 후보(`DMF0044_DEPARTMENT_TEAM`). 화면 단위로 superset 을 받아
  //   `beginningEdit` 에서 행 컨텍스트로 골라 스왑한다(hook #59 §5-G).
  const [deptByDepartmentRows, custReportRows] = useTabComboQueries({
    filters: [ROW_COMBO_IDS.DEPT_BY_DEPARTMENT, ROW_COMBO_IDS.CUST_REPORT],
  });
  const rowComboRef = useRef<Record<string, unknown>[]>([]);
  useEffect(() => {
    rowComboRef.current = (deptByDepartmentRows ?? []) as unknown as Record<string, unknown>[];
  }, [deptByDepartmentRows]);
  // CUST_REPORT 행별 콤보 (AS-IS L1346 `DMF0005_REPORT_GROUP2` — 파라미터 없음)
  const custReportRef = useRef<Record<string, unknown>[]>([]);
  useEffect(() => {
    custReportRef.current = (custReportRows ?? []) as unknown as Record<string, unknown>[];
  }, [custReportRows]);

  // ===== 동적 컬럼 메타 — GET_SPREAD_TITLE 우선, 부재 시 row 키 union fallback (M_ 단일축) =====
  //   ⭐ 2026-08-11 — **1단 헤더**로 전환 (DMF0044 2026-08-10 선례 이식). AS-IS
  //     `DMF0049_Sales_ETC_Reports.cs:265` 가 `CreateSheetHeaderColumnDtDiv(siMain, 1, …)` 로
  //     **iColumnHeaderRowCount = 1** 을 넘긴다(2단 화면은 DMF0072/DMF0074 처럼 2를 넘긴다).
  //     실제로 `PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE`(BODY L229~232) 은 LARGE/SMALL/COLUMN_LABEL_NAME
  //     을 모두 `SCM_SYS_CALENDAR_M.MONTH_NAME`(= `2025-01`) **동일값**으로 주므로, 2단으로 묶으면
  //     '2025-01' 그룹 아래 '2025-01' 1개짜리가 12개 생겼다(오구성).
  //   ⭐ REQ:CHAT-20260820-16 — `scale` 은 같은 SP 가 주는 `DATA_SCALE_NUMBER` 를 소비한다
  //     (동적 M_ 분기 실측 '3'). 표시·입력 정규화가 이 값 하나를 공유하므로 둘이 갈릴 수 없다.
  type DynColMeta = { binding: string; label: string; sort: number; scale: number };
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
          scale: dataScaleOf(r.DATA_SCALE_NUMBER),
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
      scale: DEFAULT_DATA_SCALE, // SP 메타가 없는 fallback 경로 — 자릿수 원천이 없다
    }));
  }, [spreadTitle, rows]);
  const dynBindings = useMemo(() => dynColMetas.map(m => m.binding), [dynColMetas]);

  // 자릿수 ref 미러 — 핸들러가 effect 안에서 등록되므로(lockCtxRef·inputTpRef 와 동형) 최신 메타를 본다
  const dynScaleRef = useRef<Map<string, number>>(new Map());
  dynScaleRef.current = new Map(dynColMetas.map(m => [m.binding, m.scale]));

  // editLock 파라미터 ref 미러 (핸들러 공유)
  const lockCtxRef = useRef({
    division,
    planResult,
    mdfType,
    yyyy,
    thisMonth,
    sEditMeasure,
    userGroup,
  });
  lockCtxRef.current = { division, planResult, mdfType, yyyy, thisMonth, sEditMeasure, userGroup };

  // ⭐ 정적 컬럼 입력형(UI Category Setup `INPUT_TP_CD`) — 편집·색 판정의 단일 원천.
  //   핸들러가 effect 안에서 등록되므로 ref 미러로 최신 메타를 본다(lockCtxRef 와 동형).
  const inputTpRef = useRef<Map<string, string | undefined>>(new Map());
  inputTpRef.current = new Map(
    visibleColumns.map(c => [c.colNm, c.inputTpCd as string | undefined])
  );

  // ⭐ 동적 PIVOT 컬럼 — **1단 평면**(AS-IS iColumnHeaderRowCount=1). nested columnGroups 사용 금지.
  //   헤더 높이 48px 고정(hook #93) — 1단이므로 행 1개가 48을 그대로 갖는다.
  //
  //   ⚠️ **`_inputEditType` 필수** (DMF0044 2026-08-10 실사고 — "노란색인데 편집이 안 됨").
  //   공용 `DataGrid` 가 `setEditableColumns()` 로 자체 `beginningEdit` 을 걸고
  //   `GridUtils.isEditableCell()` 로 1차 판정하는데, 그 함수는 컬럼의 **`_inputEditType`** 만 본다
  //   (정적 컬럼은 `mapColumn()` 이 `inputTpCd` → `_inputEditType` 으로 변환해 주지만,
  //    **동적 컬럼은 raw 로 전달**되므로 `inputTpCd` 로 주면 변환되지 않아 `undefined` → `default: false`).
  //   최종 판정은 아래 `beginningEdit` 의 `evalDyn`(제약매트릭스 §2~§6)이 하므로
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
    const g = (gridRef as { current: FlexGridType<EtcSalesReportRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1; // zebra (#95)
    for (let i = 0; i < g.columnFooters.rows.length; i++) g.columnFooters.rows[i].visible = false;

    const evalDyn = (binding: string, row: EtcSalesReportRow | undefined) =>
      evalEtcReportCell({
        binding,
        row,
        divisionId: lockCtxRef.current.division,
        planResult: lockCtxRef.current.planResult,
        mdfType: lockCtxRef.current.mdfType,
        yyyy: lockCtxRef.current.yyyy,
        thisMonth: lockCtxRef.current.thisMonth,
        sEditMeasure: lockCtxRef.current.sEditMeasure,
        userGroup: lockCtxRef.current.userGroup,
      });

    const toggleClass = (el: HTMLElement, cls: string, on: boolean) => {
      if (on) el.classList.add(cls);
      else el.classList.remove(cls);
    };

    const formatHandler = (_s: FlexGridType<EtcSalesReportRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const col = g.columns[e.col];
      const binding = col?.binding ?? '';
      const rowItem = g.rows[e.row]?.dataItem as EtcSalesReportRow | undefined;
      if (dynKindOf(binding)) {
        // ⚠️ **`editRange` 가드 필수** (DMF0044 2026-08-11 실사고 — "노란색인데 편집 불가").
        //   `formatItem` 은 **편집 중인 셀에도 발생**한다(Wijmo 가 편집기 <input> 을 셀에 넣은 뒤 셀을 갱신).
        //   가드 없이 `textContent` 를 대입하면 방금 삽입된 <input> 이 지워져, 판정은 정상인데
        //   타이핑만 불가능한 상태가 된다. 자매 화면 3본(forecast-price/business-plan/sales-plan)과
        //   DMF0044 가 모두 같은 가드를 갖고 있다.
        if (g.editRange?.contains(e.row, e.col)) return; // 편집 중 셀은 건드리지 않는다
        const st = evalDyn(binding, rowItem);
        toggleClass(e.cell, 'wj-cell-editable', st.editable);
        toggleClass(e.cell, 'wj-cell-non-editable', !st.editable && st.isPast);
        // 숫자 표시 — 0/빈 = 빈칸, 콤마 포맷 + 메타 자릿수 고정 소수 (REQ:CHAT-20260820-16).
        //   ⚠ **0 은 계속 빈칸**이다(2026-08-20 사용자 확정 — 현행 동작 보존). '0.000' 을 찍지 않는다.
        const v = rowItem?.[binding];
        const n = toNumber(v);
        const s = dynScaleRef.current.get(binding) ?? DEFAULT_DATA_SCALE;
        e.cell.textContent =
          v == null || v === '' || n === 0
            ? ''
            : n.toLocaleString(undefined, {
                minimumFractionDigits: s,
                maximumFractionDigits: s,
              });
        // 음수 수량 = 빨간 글자 (mkt-fcst 동일 규약)
        paintNegative(e.cell, n);
        return;
      }
      if (staticBindingSet.has(binding) && rowItem) {
        // 색상 판정도 편집 게이트와 **같은 함수**를 쓴다 — 두 곳이 갈리면 노란칸인데 못 고치는 상태가 생긴다
        const editable = staticEditableByMeta(inputTpRef.current.get(binding), rowItem);
        toggleClass(e.cell, 'wj-cell-editable', editable);
        // 정적 컬럼의 수치도 음수면 빨간 글자. 문자 컬럼은 toNumber 가 0 을 돌려주므로
        // 자연히 음수 판정에서 빠진다.
        paintNegative(e.cell, toNumber(rowItem[binding]));
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — 게이트 + cascade 콤보 스왑 (hook #59 §5-G)
    const editingCellRef: { current: { binding: string } | null } = { current: null };
    const beginningEditHandler = (
      s: FlexGridType<EtcSalesReportRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as EtcSalesReportRow | undefined;
      if (staticBindingSet.has(binding)) {
        // UI Category Setup `INPUT_TP_CD` 단일 원천 (IM/IO=신규행만, M/O=전 행, S=불가).
        //   AS-IS InsertRow(L965~1024)·EditButton 키영역(L399~412) 잠금 파리티는 메타 값('S')으로
        //   보존한다 — 여기 하드코딩 금지.
        const allowed = staticEditableByMeta(inputTpRef.current.get(binding), row);
        if (!allowed) {
          e.cancel = true;
          return;
        }
        // 행 컨텍스트 스왑 — DEPT_ID 후보를 AS-IS 2분기(L1268 / L1294)로 다시 고른다
        if (binding === 'DEPT_ID' && row) {
          const dm = buildDataMap(
            resolveDeptIdRows(row, lockCtxRef.current.division, {
              deptDefault: comboRowsRef.current.DEPT_ID ?? [],
              deptByDepartment: rowComboRef.current,
            })
          );
          if (dm) {
            s.columns[e.col].dataMap = dm;
            editingCellRef.current = { binding };
          }
        }
        // CUST_REPORT — AS-IS 가 `.cs` 에서 붙이던 행별 콤보(L1346/1367/1597). 메타에 없으므로
        //   화면이 구독해 편집 진입 시 스왑한다(편집 종료 시 cellEditEnded 가 원복).
        if (binding === 'CUST_REPORT') {
          const dm = buildDataMap(custReportRef.current);
          if (dm) {
            s.columns[e.col].dataMap = dm;
            editingCellRef.current = { binding };
          }
        }
        return;
      }
      if (dynKindOf(binding)) {
        e.cancel = !evalDyn(binding, row).editable;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 편집 종료 — 수치셀 빈값 → '0' (AS-IS L1295~1302) + cascade dataMap 원복
    const cellEditEndedHandler = (
      s: FlexGridType<EtcSalesReportRow>,
      e: { row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as EtcSalesReportRow | undefined;
      if (dynKindOf(binding) && row) {
        const raw = row[binding];
        if (raw == null || raw === '') {
          (row as Record<string, unknown>)[binding] = '0'; // AS-IS L1295~1302 — 빈값 → '0'
        } else {
          // ⭐ REQ:CHAT-20260820-16 — 입력축도 메타 자릿수로 정규화한다. 표시(3자리)와 저장 payload 가
          //   갈리지 않게 **셀 값 자체**를 고정 소수로 확정한다(지수표기도 여기서 제거된다).
          const sc = dynScaleRef.current.get(binding) ?? DEFAULT_DATA_SCALE;
          (row as Record<string, unknown>)[binding] = toNumber(raw).toFixed(sc);
        }
      }
      // DEPARTMENT_ID / DEPT_ID 변경 → 종속 컬럼 clear (AS-IS 매트릭스 = cascadeClearColumns JSDoc)
      //   ⚠ AS-IS 는 **DEPT_ID 자체를 지우지 않는다** — DMF0044 와 다른 지점이라 원문 그대로 따른다.
      //     DEPT_ID 후보는 다음 편집 진입 시 `resolveDeptIdRows` 가 새 DEPARTMENT_ID 로 다시 고른다.
      if (row) {
        const clears = cascadeClearColumns(binding, row, lockCtxRef.current.division);
        if (clears.length > 0) {
          const rec = row as Record<string, unknown>;
          clears.forEach(col => {
            rec[col] = '';
          });
          s.invalidate();
        }
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

    // PROJECT_CODE 셀 더블클릭 — SCM0002 Project 팝업 ETC=true (L1428~1457. ITEM 팝업은 dead — 콤보로 변경)
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = g.rows[ht.row]?.dataItem as EtcSalesReportRow | undefined;
      if (!row || binding !== 'PROJECT_CODE') return;
      onProjectCellDblClick?.(row);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // 스크롤 시 재렌더(merge 재계산용). ⚠ 편집 중에는 건너뛴다 — 편집기가 붙은 셀을 다시 그리면
    //   입력이 끊긴다(위 formatItem editRange 가드와 같은 계열의 사고. DMF0044 2026-08-11 선례).
    const handleScrollInvalidate = () => {
      if (g.editRange) return;
      g.invalidate();
    };
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    const mergeManager = new EtcSalesReportsMergeManager(fixedBindings);
    g.mergeManager = mergeManager;

    // ⭐ REQ:CHAT-20260820-18/19 — 수정할 line 을 클릭하면 그 measure 세트가 광역 병합에서 분리된다.
    //   AS-IS `spdMain_CellClick`(.cs:1578~1605) 이 클릭 행의 세트 범위를 `SetRowSpanFucTwo` 로
    //   다시 span 하는 동작 그대로다(세트 첫 행 = `GetCellIndexBySpanRowCells40` .cs:1612~1635).
    //   ⚠ **편집 중에는 세트키를 바꾸지 않는다** — 공용 `packages/foundation/src/utils/mergeManager.ts:66~74`
    //     가 금지한다(invalidate 가 예약한 refresh 는 finishEditing 을 불러 편집기·콤보 드롭다운을 닫는다).
    //     활성 세트키는 편집이 끝날 때까지 그대로 유지되므로 편집 중 병합이 다시 붙는 일도 없다.
    //   ⚠ AS-IS 는 이 재-span 을 division 40 · DEPARTMENT_ID/DEPT_ID/CUST_REPORT 3컬럼으로 한정했다.
    //     TO-BE 는 세트키가 40 외 division 에서 자연히 1행 세트로 수렴하고, 좌측 컬럼 일부만 끊으면
    //     같은 행에서 컬럼마다 경계가 달라져 보이므로 fixed 컬럼 전체·전 division 에 동일 적용한다.
    const selectionChangedHandler = (s: FlexGridType<EtcSalesReportRow>) => {
      if (s.editRange) return;
      const item = s.rows[s.selection.row]?.dataItem as EtcSalesReportRow | undefined;
      // 세트키가 실제로 바뀐 경우에만 다시 그린다 — 같은 세트 재클릭마다 refresh 를 예약하면
      //   그 직후의 편집 진입(두 번째 클릭)이 끊긴다.
      if (mergeManager.setActiveSetKey(setKeyOf(item))) s.invalidate();
    };
    g.selectionChanged.addHandler(selectionChangedHandler);

    g.invalidate(true);

    return () => {
      try {
        g.selectionChanged?.removeHandler(selectionChangedHandler);
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
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, fixedBindings, onProjectCellDblClick]);

  // ⭐ 행 교체(재조회·Insert) = **광역 병합 복원** (REQ:CHAT-20260820-18/19).
  //   AS-IS 는 FindData 끝에서 `SmartColMerge()`(.cs:599) 를 다시 돌려 전 행을 값 기준으로 묶는다.
  //   활성 세트키를 비우지 않으면 직전에 클릭해 둔 세트가 **새 조회 결과에서도 갈라진 채** 남는다.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<EtcSalesReportRow> | null } | null)?.current;
    const mm = g?.mergeManager;
    if (g && mm instanceof EtcSalesReportsMergeManager && mm.setActiveSetKey(null)) g.invalidate();
  }, [rows, gridRef]);

  // ⭐ hook #93 — 헤더 총 48px. DMF0049 는 **1단**이므로 행 1개가 48 을 그대로 갖는다
  //   (2단 화면이면 24+24 로 자동 분배 — `48 / headerRows.length`). + combo dataMap 재적용 + Filter sanitize
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<EtcSalesReportRow> | null } | null)?.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const f = gridFilterRef?.current;
      if (f) {
        const cleaned = f.filterColumns.filter(b => !/^M_/.test(b));
        if (cleaned.length !== f.filterColumns.length) f.filterColumns = cleaned;
      }
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
    const g = (gridRef as { current: FlexGridType<EtcSalesReportRow> | null } | null)?.current;
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
    <>
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
    </>
  );
};
