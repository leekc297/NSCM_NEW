import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, DataMap } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridFilter as FlexGridFilterCtor } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { ComboParam, RawFlexGridColumnConfig } from '@foundation/models';
import { keepRowVisibleUnderFilter } from '@foundation/utils';
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
  buildDeptIdDataMap,
  cascadeClearColumns,
  ROW_COMBO_IDS,
  toCellStr,
} from '../utils/etc-sales-reports.gridCombos';
import {
  EtcSalesReportsMergeManager,
  type MergeContext,
  type SetKeyMap,
} from '../utils/etc-sales-reports.merge';

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
  // 행 → 세트키. 병합 블록이 세트를 넘지 않게 하는 원천 (저장부와 같은 맵 — merge.ts 상단 참조).
  setKeys?: SetKeyMap;
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
  setKeys,
}: Props) => {
  const division = divisionId ?? '';

  // 병합 컨텍스트 ref 미러 — MergeManager 는 컬럼 구성이 바뀔 때만 다시 만들어지므로(아래 useEffect
  //   의존성), 조회·Insert 마다 바뀌는 세트키 맵과 편집 진입 세트는 ref 로 넘긴다(lockCtxRef 와 동형).
  //   `activeSetKey` 는 이벤트 핸들러가 직접 쓰므로 렌더에서 덮지 않는다.
  const mergeCtxRef = useRef<MergeContext>({ setKeys: undefined, activeSetKey: null });
  mergeCtxRef.current.setKeys = setKeys;

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
  // DEPT_ID 메타 콤보 rows — 행별 후보 해석(`resolveDeptIdRows`)의 기본 분기 원천
  const deptDefaultRows = useMemo<Record<string, unknown>[]>(() => {
    const i = comboColumns.findIndex(c => c.colNm === 'DEPT_ID');
    return i >= 0 ? ((comboResults[i] ?? []) as unknown as Record<string, unknown>[]) : [];
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSig]);

  // ===== 행별 콤보 — AS-IS `.cs` 런타임 SetCellTypeCombo 분 (메타에 컬럼이 없어 별도 구독) =====
  //   DEPT_ID 부모키 후보(`DMF0044_DEPARTMENT_TEAM`). 화면 단위로 superset 을 받아
  //   컬럼 DataMap 하나에 담고, 후보 목록만 행 컨텍스트로 좁힌다(hook #59 §5-G).
  const [deptByDepartmentRows, custReportRows] = useTabComboQueries({
    filters: [ROW_COMBO_IDS.DEPT_BY_DEPARTMENT, ROW_COMBO_IDS.CUST_REPORT],
  });
  const deptByDepartment = useMemo<Record<string, unknown>[]>(
    () => (deptByDepartmentRows ?? []) as unknown as Record<string, unknown>[],
    [deptByDepartmentRows]
  );
  // CUST_REPORT 행별 콤보 (AS-IS L1346 `DMF0005_REPORT_GROUP2` — 파라미터 없음)
  const custReportList = useMemo<Record<string, unknown>[]>(
    () => (custReportRows ?? []) as unknown as Record<string, unknown>[],
    [custReportRows]
  );

  // 메타에 없는(= `.cs` 가 런타임에 붙이던) 콤보의 컬럼 DataMap.
  //   금지: 편집 진입 시 `column.dataMap` 을 갈아끼우지 말 것 — dataMap 은 셀이 아니라 **컬럼**
  //   속성이라 그 컬럼 전 행의 표시가 함께 바뀌고, 좁혀진 맵에 없는 코드는 원 코드로 드러난다
  //   (근거·대안은 `utils/etc-sales-reports.gridCombos.ts` buildDeptIdDataMap 주석 참조).
  const rowScopedDataMaps = useMemo<Record<string, DataMap | null>>(
    () => ({
      DEPT_ID: buildDeptIdDataMap({ deptDefault: deptDefaultRows, deptByDepartment }, division),
      CUST_REPORT: buildDataMap(custReportList),
    }),
    [deptDefaultRows, deptByDepartment, custReportList, division]
  );

  // 컬럼에 실제로 붙일 DataMap — 메타 콤보 위에 행별 콤보를 덮는다.
  //   null(원천 미도착)은 덮지 않는다. 덮으면 이미 붙어 있던 메타 맵까지 지워진다.
  const effectiveDataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const merged: Record<string, DataMap | null> = { ...dataMaps };
    Object.entries(rowScopedDataMaps).forEach(([binding, dm]) => {
      if (dm) merged[binding] = dm;
    });
    return merged;
  }, [dataMaps, rowScopedDataMaps]);

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

    // ===== 편집 진입 세트 분리 (AS-IS spdMain_CellClick 파리티 — `.cs:1503~1527`) =====
    //   조회 직후에는 종전대로 광역 병합이고, **더블클릭한 세트 하나만** 블록에서 떨어져 나온다.
    //   목적은 모양이 아니라 **쓰기 범위**다 — wijmo 는 편집 커밋을 병합 블록 전 행에 쓰고
    //   그 범위(`_rng`)를 `startEditing` 이 beginningEdit **보다 먼저** 잡는다. 그래서 편집이
    //   시작되기 전에 갈라 놔야 값이 세트 밖으로 새지 않는다(근거 전문 = merge.ts 상단).
    const openSetForEdit = (row: number, col: number): void => {
      const binding = g.columns[col]?.binding ?? '';
      if (!staticBindingSet.has(binding)) return; // 수치(M_) 셀은 병합 대상이 아니다
      const item = g.rows[row]?.dataItem as EtcSalesReportRow | undefined;
      if (!item) return;
      // 편집 불가 셀은 갈라 두면 되돌릴 계기(cellEditEnded)가 없다 — 애초에 분리하지 않는다.
      //   PROJECT_CODE 더블클릭(드릴다운 팝업)처럼 편집이 아닌 더블클릭도 여기서 걸러진다.
      if (!staticEditableByMeta(inputTpRef.current.get(binding), item)) return;
      const key = mergeCtxRef.current.setKeys?.get(item);
      if (!key || mergeCtxRef.current.activeSetKey === key) return;
      // 블록이 이미 그 세트 하나뿐이면 갈라낼 것이 없다 — 아래 동기 refresh 를 아낀다.
      //   신규 세트는 항상 여기에 해당한다(기존 행과는 값이 같아도 병합하지 않으므로).
      const merged = g.getMergedRange(g.cells, row, col);
      if (!merged || merged.row === merged.row2) return;
      let spansOtherSet = false;
      for (let r = merged.row; r <= merged.row2 && !spansOtherSet; r++) {
        const other = g.rows[r]?.dataItem as EtcSalesReportRow | undefined;
        if (other && mergeCtxRef.current.setKeys?.get(other) !== key) spansOtherSet = true;
      }
      if (!spansOtherSet) return;
      // 필수: 진행 중이던 편집을 **먼저** 끝낸다. 아래 refresh 가 finishEditing 을 부르는데,
      //   그 cellEditEnded 안의 closeActiveSet 가 방금 연 세트를 도로 닫아 버린다(순서 사고).
      if (g.activeEditor) g.finishEditing();
      mergeCtxRef.current.activeSetKey = key;
      // 필수: **동기** refresh. invalidate(10ms 뒤 refresh)로 미루면 wijmo 가 아직 광역인 DOM 에서
      //   편집을 시작해, 세트가 1행인 division(82)에서는 편집기가 앉을 셀을 못 찾아 편집이 아예
      //   시작되지 않는다(`_EditHandler._updateEditorCell` 은 단일 셀 범위면 refresh 를 건너뛴다).
      //   지금은 편집기가 열리기 **전**이라 refresh 가 부르는 finishEditing 이 해칠 편집이 없다.
      g.refresh(false);
    };

    // ===== 신규 세트 값 동기화 — 병합이 못 덮는 경로의 안전망 =====
    //   신규 세트는 병합되어 있어 보통은 wijmo 가 세트 전 행에 값을 쓴다. 다만 병합이 닿지 않는
    //   경로가 둘 있다.
    //     ① 붙여넣기 — 공용 DataGrid 가 `expandSelectionOnCopyPaste = false` 라 앵커 1행에만 쓴다.
    //     ② 세트가 viewport 경계에 걸치면 병합 블록이 그 자리에서 잘린다(`panel.viewRange` 제한).
    //     ③ cascade clear 는 편집한 행에만 적용된다.
    //   그런데 저장 빌더는 세트 **첫 행**에서 identity 를 읽으므로
    //   (`utils/etc-sales-reports.save.ts` `identityOf(t.setRows[0])`) 첫 행이 비면 Department 공란으로
    //   보고 저장을 막는다(MSG00429). 세트는 한 레코드이므로 Measure 를 뺀 정적 값은 전 행이 같아야 한다.
    //   변경 등록(EditTracker)은 불요 — 신규 세트는 `CRUD_TYPE='I'` 만으로 늘 저장 대상이다.
    //
    //   금지: 수치(M_) 셀은 절대 전파하지 말 것 (2026-08-21 실사고 — "뒤에 병합 안 된 데이터도 같은
    //     값이 들어간다"). 월 수량은 **행(Measure)마다 다른 값**이라 세트 공유 대상이 아니다.
    //     동적 컬럼은 `allowMerging: false` 라 화면에서도 병합되지 않는다 — 전파는 그 계약도 깬다.
    //     그래서 전파 대상을 **정적 컬럼 화이트리스트**(`staticBindingSet`)로 못박는다.
    const syncInsertSet = (
      s: FlexGridType<EtcSalesReportRow>,
      src: EtcSalesReportRow,
      bindings: string[]
    ): void => {
      const gid = src.INSERT_GROUP_ID;
      if (src.CRUD_TYPE !== 'I' || !gid) return;
      // 세트 공유 값 = 정적 컬럼 - MEASURE. 나머지(M_ 수량 등)는 행마다 달라야 한다.
      const shared = bindings.filter(b => b !== 'MEASURE' && staticBindingSet.has(b));
      if (shared.length === 0) return;
      const rec = src as Record<string, unknown>;
      let touched = false;
      for (let i = 0; i < s.rows.length; i++) {
        const other = s.rows[i]?.dataItem as EtcSalesReportRow | undefined;
        if (!other || other === src) continue;
        if (other.CRUD_TYPE !== 'I' || other.INSERT_GROUP_ID !== gid) continue;
        const target = other as Record<string, unknown>;
        shared.forEach(b => {
          if (target[b] === rec[b]) return;
          target[b] = rec[b];
          touched = true;
        });
      }
      if (touched) s.invalidate();
    };

    // 분리 해제 — 편집이 끝난 뒤에만 부른다(편집 중 invalidate 금지 — merge.ts 상단 참조).
    const closeActiveSet = (): void => {
      if (mergeCtxRef.current.activeSetKey == null) return;
      mergeCtxRef.current.activeSetKey = null;
      g.invalidate();
    };

    const formatHandler = (_s: FlexGridType<EtcSalesReportRow>, e: FormatItemEventArgs) => {
      if (e.panel !== g.cells) return;
      const col = g.columns[e.col];
      const binding = col?.binding ?? '';
      const rowItem = g.rows[e.row]?.dataItem as EtcSalesReportRow | undefined;

      // 음수 = 빨간 글자 (공통 규약. 정본 mkt-fcst / demand-manager / contribute-view).
      //   필수: **진입 직후 한 번만** 칠한다 — 아래 분기들이 각자 return 하므로 분기 안에서 부르면
      //   편집 중인 셀(editRange 가드로 조기 return)과 정적/동적 어디에도 안 걸리는 컬럼
      //   (개인화로 사용자가 되살린 컬럼은 staticBindingSet 에 없다)이 통째로 빠진다.
      //   값 원천은 그 셀이 실제로 그리는 원값이다(`getCellData(..., false)`) — 콤보 컬럼은
      //   CODE 가 와서 toNumber 가 0 이 되므로 자연히 음수 판정에서 빠진다.
      paintNegative(e.cell, toNumber(e.panel.getCellData(e.row, e.col, false)));

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
        return;
      }
      if (staticBindingSet.has(binding) && rowItem) {
        // 색상 판정도 편집 게이트와 **같은 함수**를 쓴다 — 두 곳이 갈리면 노란칸인데 못 고치는 상태가 생긴다
        const editable = staticEditableByMeta(inputTpRef.current.get(binding), rowItem);
        toggleClass(e.cell, 'wj-cell-editable', editable);
      }
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 시작 — 게이트만 본다. cascade 후보 좁히기는 컬럼 DataMap 의 `getDisplayValues` 담당이라
    //   여기서 dataMap 을 건드리지 않는다(hook #59 §5-G).
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
          closeActiveSet(); // 편집이 안 열리면 cellEditEnded 가 없다 — 갈라진 채 남지 않게 여기서 복원
          return;
        }
        return;
      }
      if (dynKindOf(binding)) {
        e.cancel = !evalDyn(binding, row).editable;
        if (e.cancel) closeActiveSet();
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 편집 종료 — 수치셀 빈값 → '0' (AS-IS L1295~1302) + 종속 컬럼 cascade clear
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
        // 신규 세트는 병합이 없으므로 방금 바뀐 값(+ cascade clear 분)을 세트 전체에 맞춘다
        syncInsertSet(s, row, [binding, ...clears]);
      }
      // 편집이 끝났으니 갈라 뒀던 세트를 광역 병합으로 되돌린다(invalidate 는 여기서만 안전).
      closeActiveSet();
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

    // 더블클릭 = 편집 진입 = 세트 분리 시점. **capture 단계**로 등록해 wijmo 자신의 mousedown
    //   핸들러보다 먼저 돌게 한다 — wijmo 는 이 mousedown 에서 hitTest·select 를 하고 이어지는
    //   mouseup 에서 `startEditing(true, null, null)`(= selection.row 사용)로 편집을 시작하므로,
    //   그 전에 병합이 세트로 갈라져 있어야 선택도 편집 범위도 세트 안에 잡힌다.
    //   `detail >= 2` 로 **두 번째 클릭에서만** 갈라진다 — 단일 클릭(포커스 이동)은 병합을 건드리지
    //   않는다(과거 selectionChanged 판이 "포커스만 옮겼는데 병합이 깨진다"가 됐던 지점).
    //   병합 셀은 위에서 아래까지 한 칸이라 wijmo 쪽에는 "클릭한 줄" 정보가 없다. 물리 행은
    //   좌표 기반 `hitTest` 만 알고 있으므로 여기서 잡아 둔다.
    const mouseDownCapture = (ev: MouseEvent) => {
      if (ev.detail < 2) return;
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells || ht.row < 0 || ht.col < 0) return;
      openSetForEdit(ht.row, ht.col);
    };
    g.hostElement.addEventListener('mousedown', mouseDownCapture, true);

    // 키보드로 편집을 시작하는 경로(F2 / 문자 입력)도 같은 분리가 필요하다 — 안 그러면 그 경로만
    //   광역 블록 전체에 값이 쓰인다. 대상 행은 선택 행(병합 블록의 맨 윗행)이다.
    const keyDownCapture = (ev: KeyboardEvent) => {
      if (g.activeEditor || ev.ctrlKey || ev.metaKey || ev.altKey) return;
      if (ev.key !== 'F2' && ev.key.length !== 1) return; // F2 또는 문자 1글자 입력만 편집을 연다
      const sel = g.selection;
      if (!sel || sel.row < 0 || sel.col < 0) return;
      openSetForEdit(sel.row, sel.col);
    };
    g.hostElement.addEventListener('keydown', keyDownCapture, true);

    // 스크롤 시 재렌더(merge 재계산용). ⚠ 편집 중에는 건너뛴다 — 편집기가 붙은 셀을 다시 그리면
    //   입력이 끊긴다(위 formatItem editRange 가드와 같은 계열의 사고. DMF0044 2026-08-11 선례).
    const handleScrollInvalidate = () => {
      if (g.editRange) return;
      g.invalidate();
    };
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    g.allowMerging = AllowMerging.All;
    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.mergeManager = new EtcSalesReportsMergeManager(fixedBindings, mergeCtxRef);

    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler as never);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
        g.hostElement?.removeEventListener('mousedown', mouseDownCapture, true);
        g.hostElement?.removeEventListener('keydown', keyDownCapture, true);
        g.scrollPositionChanged?.removeHandler(handleScrollInvalidate);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, fixedBindings, onProjectCellDblClick]);

  // ⭐ hook #93 — 헤더 총 48px. DMF0049 는 **1단**이므로 행 1개가 48 을 그대로 갖는다
  //   (2단 화면이면 24+24 로 자동 분배 — `48 / headerRows.length`). + combo dataMap 재적용
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<EtcSalesReportRow> | null } | null)?.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const dm = effectiveDataMaps[col.binding ?? ''];
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
  }, [dynBindings, visibleColumns, effectiveDataMaps, gridRef]);

  // F4 Filter
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<EtcSalesReportRow> | null } | null)?.current;
    if (!g || !gridFilterRef) return;
    const onFilterApplied = () => g.invalidate(true);
    let f = gridFilterRef.current;
    if (!f || f.grid !== g) {
      f = new FlexGridFilterCtor(g);
      f.filterColumns = [''];
      gridFilterRef.current = f;
    }
    f.filterApplied.addHandler(onFilterApplied);
    return () => {
      try {
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, gridFilterRef]);

  // 공통 UC-01 — 필터가 걸린 상태에서 Insert 해도 필터를 유지한 채 신규행이 보여야 한다.
  //   Insert 는 rows 를 새 배열로 만들어 itemsSource 를 갈아끼우는데, 그 순간 wijmo 가 두 가지를 한다.
  //     (1) FlexGridFilter 가 생성자에서 itemsSourceChanged 에 건 clear() 로 필터를 통째로 비운다
  //         -> 공용 DataGrid 의 capture/restore 가 되돌린다. 필수: gridFilterRef 를 DataGrid 에
  //            넘겨야 그 장치가 이 화면의 필터를 본다(안 넘기면 화면이 직접 만든 필터라 무동작).
  //     (2) 값이 빈 신규행은 필터 조건에 걸려 CollectionView 에서 빠진다
  //         -> keepRowVisibleUnderFilter 로 wijmo 예외집합(excludedRowsSet)에 등록해 통과시킨다.
  //   순서 의무: 복원의 apply() 가 예외집합을 비우므로 itemsSource 교체가 끝난 뒤(= 이 effect)에
  //   등록하고 refresh 한다. handleInsert 안에서 동기로 등록하면 뒤이은 복원에 지워진다.
  //   컬럼 0개 가드: 컬럼이 없는 상태에서 refresh 하면 wijmo 가 인덱스 -1 로 계산하다 예외를 던진다.
  //   정본 = forecast-price/components/ForecastPriceGrid.tsx.
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<EtcSalesReportRow> | null } | null)?.current;
    if (!g || g.columns.length === 0) return;
    const insertRows = rows.filter(r => r.CRUD_TYPE === 'I');
    if (insertRows.length === 0) return;
    insertRows.forEach(r =>
      keepRowVisibleUnderFilter(
        g as unknown as FlexGridType<WijmoRowItem>,
        r as unknown as WijmoRowItem
      )
    );
    g.collectionView?.refresh();
  }, [rows, gridRef]);

  return (
    <>
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
    </>
  );
};
