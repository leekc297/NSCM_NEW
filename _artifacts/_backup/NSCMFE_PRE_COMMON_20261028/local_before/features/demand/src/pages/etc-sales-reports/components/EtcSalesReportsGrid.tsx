import { DataType } from '@mescius/wijmo';
import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, DataMap } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridFilter as FlexGridFilterCtor } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, type Ref, memo, useEffect, useMemo, useRef } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { ComboParam, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { dataScaleOf, DEFAULT_DATA_SCALE, excelNumberFormat } from '../etc-sales-reports.constants';
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

// 병합 셀 붙여넣기를 세트 전 행에 퍼뜨릴 컬럼 (사용자 지정 2026-09-16 — 이 둘만).
//   나머지 정적 컬럼은 wijmo 기본대로 앵커 1행에만 쓴다.
const PASTE_PROPAGATE_BINDINGS = new Set(['CELL_MODEL_INFO', 'CELL_MODEL']);

// 음수 값 글자색 (DMF0003 mkt-fcst / demand-manager 와 동일 톤)
const NEGATIVE_COLOR = '#c0392b';

const paintNegative = (cell: HTMLElement, value: number): void => {
  if (value < 0) cell.style.setProperty('color', NEGATIVE_COLOR, 'important');
  else cell.style.removeProperty('color');
};

const EtcSalesReportsGridBase = ({
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
  //   의존성), 조회·Insert 마다 바뀌는 세트키 맵은 ref 로 넘긴다(lockCtxRef 와 동형).
  //   `activeSetKey` 는 2026-09-21 최종 확정 이후 갱신되지 않는다(항상 null — merge.ts 상단 ③ 참조,
  //   되돌릴 수 있게 필드는 남겨 둔다).
  const mergeCtxRef = useRef<MergeContext>({ setKeys: undefined, activeSetKey: null });
  mergeCtxRef.current.setKeys = setKeys;

  // ===== 편집 쓰기 범위 좁히기 (2026-09-21 최종 확정) =====
  //   병합/화면은 어떤 클릭에도 절대 안 바뀐다 — 대신 실제 값 쓰기만 클릭한 레코드 세트로 좁힌다.
  //   시행착오 경위는 `utils/etc-sales-reports.merge.ts` 파일 상단 ③ 전체 참조.
  //   pendingEditAnchorRef: 사용자가 실제로 클릭/선택한 물리 행·열(mousedown hitTest 또는 키보드
  //     선택 좌표). wijmo 의 beginningEdit e.row 는 병합 블록 안 임의의 행일 수 있어 신뢰하지 않는다.
  const pendingEditAnchorRef = useRef<{ row: number; col: number } | null>(null);
  //   scopeFixRef: beginningEdit 시점에 찍어 둔 "이 편집이 실제로 덮는 범위" 스냅샷.
  //     cellEditEnded 에서 anchorKey 밖의 행은 snapshot 값으로 되돌린다.
  const scopeFixRef = useRef<{
    binding: string;
    anchorKey: string;
    anchorItem: EtcSalesReportRow;
    snapshot: Map<EtcSalesReportRow, unknown>;
  } | null>(null);
  // cascadeClearOriginRef: DEPARTMENT_ID/DEPT_ID 편집 시작 시점의 원래 값 스냅샷.
  // cellEditEnded 는 값이 실제로 바뀌지 않아도(더블클릭 후 다른 셀로 포커스만 이동해도) 발동하므로,
  // 이 스냅샷과 비교해 값이 실제로 바뀐 경우에만 cascadeClearColumns 를 호출한다.
  const cascadeClearOriginRef = useRef<{
    row: EtcSalesReportRow;
    binding: string;
    value: unknown;
  } | null>(null);

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
        // 엑셀 내려받기 서식 — 메타 자릿수(DATA_SCALE_NUMBER, 실측 3)의 숫자 서식. 공용 excelDownload 는
        //   컬럼 format 이 없으면 wijmo 기본 '#,##0.00'(2자리)로 써서 3자리 값이 반올림돼 보였다
        //   (REQ:CHAT-20260820-20). 'n3' 은 변환기에서 '#,##0.000' 이 된다. 화면 표시는 아래 formatItem 이
        //   같은 자릿수로 그리므로 둘이 갈리지 않는다.
        //   AS-IS 의 음수 빨강([Red])은 wijmo 가 사용자 지정 서식 문자열을 화면 쪽에서 2자리로 해석해
        //   편집기 표시가 깨지므로 컬럼 format 에는 넣지 않고, 엑셀 전용 `_excelFormat` 으로 따로 준다
        //   (공용 excelDownload 가 opt-in 으로 읽는다). AS-IS DMF0049 .cs:487 `#,##0.000;[Red]-#,##0.000` 1:1.
        format: `n${m.scale}`,
        _excelFormat: excelNumberFormat(m.scale),
        // 숫자 타입 고정 — 빈 셀에서 입력을 시작해도 문자열이 아니라 숫자로 커밋되고, 엑셀에도 숫자 셀로 나간다.
        dataType: DataType.Number,
        _ctrlType: CELL_CONTROL_TYPE.NUMBER,
        _display: true,
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      })),
    [dynColMetas]
  ) as never[];

  // ===== grid 핸들러 + mergeManager =====
  useEffect(() => {
    const g = (gridRef as { current: FlexGridType<EtcSalesReportRow> | null } | null)?.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;
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

    // ===== [비활성화 2026-09-21 최종] 편집 진입 세트 분리 (AS-IS spdMain_CellClick 파리티) =====
    //   클릭/더블클릭 시 세트를 광역 블록에서 미리 떼어내던 로직. 시행착오 경위(콤보 실사고 →
    //   화면 절대 안 건드리기 → 드롭다운 위치 문제로 세트 분리 재도입 → 그마저도 "클릭하면 (조금
    //   이라도) 쪼개진다"고 반려)는 `utils/etc-sales-reports.merge.ts` 파일 상단 ③ 전체 참조.
    //   최종 확정: 화면(병합 모양)은 어떤 경우에도 절대 안 건드린다 — 드롭다운이 클릭 위치보다
    //   아래에 뜨는 문제는 이번 라운드에서는 감수한다. 삭제 대신 주석 처리 — 되돌릴 수 있게 남겨 둔다.
    // const openSetForEdit = (row: number, col: number): void => {
    //   const binding = g.columns[col]?.binding ?? '';
    //   if (!staticBindingSet.has(binding)) return; // 수치(M_) 셀은 병합 대상이 아니다
    //   const item = g.rows[row]?.dataItem as EtcSalesReportRow | undefined;
    //   if (!item) return;
    //   // 편집 불가 셀은 갈라 두면 되돌릴 계기(cellEditEnded)가 없다 — 애초에 분리하지 않는다.
    //   //   PROJECT_CODE 더블클릭(드릴다운 팝업)처럼 편집이 아닌 더블클릭도 여기서 걸러진다.
    //   if (!staticEditableByMeta(inputTpRef.current.get(binding), item)) return;
    //   const key = mergeCtxRef.current.setKeys?.get(item);
    //   if (!key || mergeCtxRef.current.activeSetKey === key) return;
    //   // 블록이 이미 그 세트 하나뿐이면 갈라낼 것이 없다 — 아래 동기 refresh 를 아낀다.
    //   //   신규 세트는 항상 여기에 해당한다(기존 행과는 값이 같아도 병합하지 않으므로).
    //   const merged = g.getMergedRange(g.cells, row, col);
    //   if (!merged || merged.row === merged.row2) return;
    //   let spansOtherSet = false;
    //   for (let r = merged.row; r <= merged.row2 && !spansOtherSet; r++) {
    //     const other = g.rows[r]?.dataItem as EtcSalesReportRow | undefined;
    //     if (other && mergeCtxRef.current.setKeys?.get(other) !== key) spansOtherSet = true;
    //   }
    //   if (!spansOtherSet) return;
    //   // 필수: 진행 중이던 편집을 **먼저** 끝낸다. 아래 refresh 가 finishEditing 을 부르는데,
    //   //   그 cellEditEnded 안의 closeActiveSet 가 방금 연 세트를 도로 닫아 버린다(순서 사고).
    //   if (g.activeEditor) g.finishEditing();
    //   mergeCtxRef.current.activeSetKey = key;
    //   // 필수: **동기** refresh. invalidate(10ms 뒤 refresh)로 미루면 wijmo 가 아직 광역인 DOM 에서
    //   //   편집을 시작해, 세트가 1행인 division(82)에서는 편집기가 앉을 셀을 못 찾아 편집이 아예
    //   //   시작되지 않는다(`_EditHandler._updateEditorCell` 은 단일 셀 범위면 refresh 를 건너뛴다).
    //   //   지금은 편집기가 열리기 **전**이라 refresh 가 부르는 finishEditing 이 해칠 편집이 없다.
    //   g.refresh(false);
    // };

    // ===== 편집 쓰기 범위 스냅샷 (2026-09-21 확정 — 병합을 안 건드리는 유일한 방법) =====
    //   병합/화면은 절대 그대로 두고, 편집이 시작되는 이 순간의 병합 범위 전체를 스냅샷해 둔다.
    //   cellEditEndedHandler 에서 anchorKey(클릭한 레코드 세트) 밖의 행은 이 스냅샷 값으로
    //   되돌린다. anchor 는 pendingEditAnchorRef(실제 클릭/선택한 물리 행)에서 가져온다 —
    //   wijmo 의 beginningEdit e.row 는 병합 블록 안 임의의 행(주로 맨 윗행)일 수 있어 믿지 않는다.
    const prepareScopeFix = (
      s: FlexGridType<EtcSalesReportRow>,
      row: number,
      col: number,
      binding: string
    ): void => {
      scopeFixRef.current = null;
      const setKeys = mergeCtxRef.current.setKeys;
      if (!setKeys) return;
      const range = s.getMergedRange(s.cells, row, col, false);
      if (!range || range.row === range.row2) return; // 병합 없음 — 손댈 것 없다
      const anchorPos = pendingEditAnchorRef.current;
      const anchorRow =
        anchorPos && anchorPos.row >= range.row && anchorPos.row <= range.row2
          ? anchorPos.row
          : row;
      const anchorItem = s.rows[anchorRow]?.dataItem as EtcSalesReportRow | undefined;
      const anchorKey = anchorItem ? setKeys.get(anchorItem) : undefined;
      if (!anchorItem || !anchorKey) return;
      const snapshot = new Map<EtcSalesReportRow, unknown>();
      for (let r = range.row; r <= range.row2; r++) {
        const item = s.rows[r]?.dataItem as EtcSalesReportRow | undefined;
        if (item) snapshot.set(item, (item as Record<string, unknown>)[binding]);
      }
      scopeFixRef.current = { binding, anchorKey, anchorItem, snapshot };
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

    // [비활성화 2026-09-21 최종] 분리 해제 — activeSetKey 사전 분리(openSetForEdit)와 짝이던
    //   함수. 지금은 병합을 절대 건드리지 않으므로 되돌릴 것도 없다. 삭제 대신 주석 처리.
    // const closeActiveSet = (): void => {
    //   if (mergeCtxRef.current.activeSetKey == null) return;
    //   mergeCtxRef.current.activeSetKey = null;
    //   g.invalidate();
    // };

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
          // closeActiveSet(); // 2026-09-21 최종: activeSetKey 분리를 안 쓰므로 불필요(비활성화 참조)
          return;
        }
        // 편집이 실제로 열리는 경우에만 쓰기 범위 스냅샷을 잡는다(취소된 편집엔 필요 없다).
        prepareScopeFix(s, e.row, e.col, binding);
        // cascadeClearColumns 는 DEPARTMENT_ID/DEPT_ID 값이 실제로 바뀔 때만 발동해야 한다(AS-IS
        // CellsUpdated 파리티). 편집 시작 시점 값을 여기서 캡처해 cellEditEnded 에서 비교한다.
        // 주의: 비교 대상은 scopeFix.anchorItem(실제 클릭한 물리 행)과 같아야 한다 — e.row 는
        // 병합 블록 안 임의의 행(주로 맨 윗행)이라, e.row 기준으로 캡처하면 cellEditEnded 의
        // scopeFix.anchorItem 과 객체가 달라 비교가 항상 "변경됨"으로 나와 가드가 무력화된다.
        const cascadeClearOriginItem = scopeFixRef.current?.anchorItem ?? row;
        cascadeClearOriginRef.current =
          cascadeClearOriginItem && (binding === 'DEPARTMENT_ID' || binding === 'DEPT_ID')
            ? {
                row: cascadeClearOriginItem,
                binding,
                value: (cascadeClearOriginItem as Record<string, unknown>)[binding],
              }
            : null;
        return;
      }
      if (dynKindOf(binding)) {
        e.cancel = !evalDyn(binding, row).editable;
        // if (e.cancel) closeActiveSet(); // 2026-09-21 최종: 위와 동일 이유로 불필요
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
      // scopeFix 가 이 binding 을 위해 잡혀 있으면(정적/병합 컬럼) **앵커(실제 클릭한 레코드)**
      //   의 dataItem 을 쓴다 — e.row 는 병합 블록 안 임의의 행(주로 맨 윗행)일 수 있어, 그걸
      //   그대로 쓰면 cascade clear/신규세트 동기화가 엉뚱한 레코드에 적용된다.
      const scopeFix = scopeFixRef.current?.binding === binding ? scopeFixRef.current : null;
      scopeFixRef.current = null;
      const row = scopeFix
        ? scopeFix.anchorItem
        : (s.rows[e.row]?.dataItem as EtcSalesReportRow | undefined);
      if (dynKindOf(binding) && row) {
        const raw = row[binding];
        if (raw == null || raw === '') {
          (row as Record<string, unknown>)[binding] = 0; // AS-IS L1295~1302 — 빈값 → 0
        } else {
          // ⭐ REQ:CHAT-20260820-16 — 입력축도 메타 자릿수로 정규화한다. 표시(3자리)와 저장 payload 가
          //   갈리지 않게 **셀 값 자체**를 고정 소수로 확정한다(지수표기도 여기서 제거된다).
          //   값은 문자열이 아니라 숫자로 둔다 — 문자열로 두면 저장 전 엑셀 내려받기에서 그 칸만 문자
          //   셀로 나가 서식·정렬이 깨진다(REQ:CHAT-20260820-20). 저장 payload 는 qtyOf 가 다시 toFixed 한다.
          const sc = dynScaleRef.current.get(binding) ?? DEFAULT_DATA_SCALE;
          (row as Record<string, unknown>)[binding] = Number(toNumber(raw).toFixed(sc));
        }
      }
      // DEPARTMENT_ID / DEPT_ID 변경 → 종속 컬럼 clear (AS-IS 매트릭스 = cascadeClearColumns JSDoc)
      //   ⚠ AS-IS 는 **DEPT_ID 자체를 지우지 않는다** — DMF0044 와 다른 지점이라 원문 그대로 따른다.
      //     DEPT_ID 후보는 다음 편집 진입 시 `resolveDeptIdRows` 가 새 DEPARTMENT_ID 로 다시 고른다.
      if (row) {
        // 이전 코드 — 값이 실제로 바뀌었는지 확인하지 않고 편집 세션 종료(cellEditEnded)마다
        // 무조건 cascade clear 를 실행했다. wijmo 의 cellEditEnded 는 더블클릭 후 값을 고르지 않고
        // 다른 셀로 포커스만 옮겨도 발동하므로, Department/Team 더블클릭만으로 CUST_REPORT 등
        // 5개 컬럼이 지워지고 그 값이 세트 내 다른 행과 달라져 병합이 풀리는 실사고가 났다.
        // const clears = cascadeClearColumns(binding, row, lockCtxRef.current.division);
        // if (clears.length > 0) {
        //   const rec = row as Record<string, unknown>;
        //   clears.forEach(col => {
        //     rec[col] = '';
        //   });
        //   s.invalidate();
        // }
        // syncInsertSet(s, row, [binding, ...clears]);

        // 값이 실제로 바뀐 경우에만 cascade clear 를 실행한다(AS-IS CellsUpdated 파리티 — 값 변경
        // 없이 편집 세션만 끝난 경우는 대상이 아니다).
        const origin = cascadeClearOriginRef.current;
        const valueChanged =
          origin && origin.row === row && origin.binding === binding
            ? origin.value !== (row as Record<string, unknown>)[binding]
            : true; // 캡처가 없으면(예: 프로그램적 편집) 기존과 동일하게 보수적으로 처리한다
        const clears = valueChanged
          ? cascadeClearColumns(binding, row, lockCtxRef.current.division)
          : [];
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
      cascadeClearOriginRef.current = null;
      // 편집 쓰기 범위 원복 — wijmo 는 편집 커밋을 병합 블록 전 행에 쓰므로, 클릭한 레코드
      //   세트(anchorKey) 밖의 행은 스냅샷 원본값으로 되돌리고 EditTracker 오표시도 취소한다.
      //   세트 안 행은 새 값을 유지하며 EditTracker 에 직접 등록한다 — wijmo 기본은 `event.row`
      //   (병합 블록 맨 윗행) 하나만 기록하므로 세트의 나머지 행은 등록해 주지 않으면 저장에서 빠진다.
      if (scopeFix) {
        const setKeys = mergeCtxRef.current.setKeys;
        const tracker = editTrackerRef?.current;
        let touched = false;
        scopeFix.snapshot.forEach((originalValue, rec) => {
          const target = rec as Record<string, unknown>;
          const inAnchorSet = setKeys?.get(rec) === scopeFix.anchorKey;
          if (inAnchorSet) {
            tracker?.storeChange(
              rec as unknown as WijmoRowItem,
              binding,
              originalValue as WijmoPrimitive,
              target[binding] as WijmoPrimitive
            );
          } else if (target[binding] !== originalValue) {
            target[binding] = originalValue;
            tracker?.storeChange(
              rec as unknown as WijmoRowItem,
              binding,
              originalValue as WijmoPrimitive,
              originalValue as WijmoPrimitive
            );
            touched = true;
          }
        });
        if (touched) s.invalidate();
      }
      // [비활성화 2026-09-21 최종] 갈라 뒀던 세트를 광역 병합으로 되돌리던 호출 — 더 이상 가르지
      //   않으므로 불필요(비활성화된 openSetForEdit/closeActiveSet 참조).
      // closeActiveSet();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler as never);

    // 병합 셀 붙여넣기 = 세트 전 행에 반영 (DMF0044 REQ:CHAT-20260820-10 이식 — 범위만 세트로 좁힘).
    //   [문제] 공용 DataGrid 가 `expandSelectionOnCopyPaste = false` 라 붙여넣기는 앵커(선택) 1행에만
    //   값을 쓴다. 정적 컬럼은 좌측 계층 값이 모두 같아야 병합되므로(`canMergeRows`) 한 행만 바뀌는
    //   순간 블록이 갈라져 "한 칸에만 들어간" 모양이 되고, 나머지 행까지 채워야 다시 붙는다.
    //   조회 세트는 저장이 세트 첫 행에서 identity 를 읽으므로(`utils/etc-sales-reports.save.ts`
    //   `identityOf`) 첫 행이 아닌 줄에 붙인 값은 저장에서도 빠진다. 신규 세트는 syncInsertSet 이
    //   이미 맞추므로 여기서는 값이 같아 건너뛴다.
    //   [범위] 광역 병합 블록 전체가 아니라 앵커가 속한 세트다. 더블클릭 편집의 쓰기 범위(merge.ts
    //   상단 — 편집은 그 세트만 고친다)와 같게 둔다. 여러 세트에 걸친 블록에 붙이면 그 세트만 새 값으로
    //   떨어져 나온다(더블클릭 편집 후와 같은 모양).
    //   [대상] Cell Model Info / Cell Model **두 컬럼만**(사용자 지정 2026-09-16). 나머지 정적 컬럼은
    //   종전대로 앵커 1행에만 쓴다 — 전 컬럼에 걸면 사용자가 의도한 범위를 넘어 세트 전체가 바뀐다.
    //   금지: MEASURE 와 수치(M_) 컬럼은 전파하지 말 것 — 행마다 다른 값이다(syncInsertSet 주석 참조).
    //   등록 순서 의무: cellEditEndedHandler 뒤 — 앵커의 cascade clear·신규 세트 동기화가 끝난 값을 본다.
    const propagatePasteToSet = (
      s: FlexGridType<EtcSalesReportRow>,
      e: { row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      if (!PASTE_PROPAGATE_BINDINGS.has(binding) || !staticBindingSet.has(binding)) return;
      const anchor = s.rows[e.row]?.dataItem as EtcSalesReportRow | undefined;
      const setKeys = mergeCtxRef.current.setKeys;
      const key = anchor ? setKeys?.get(anchor) : undefined;
      if (!anchor || !key) return;
      const value = anchor[binding];
      const tracker = editTrackerRef?.current;
      let touched = false;
      for (let i = 0; i < s.rows.length; i++) {
        const target = s.rows[i]?.dataItem as EtcSalesReportRow | undefined;
        if (!target || target === anchor || setKeys?.get(target) !== key) continue;
        const previous = target[binding];
        if (previous === value) continue;
        target[binding] = value;
        // 값만 바꾸면 저장 대상에서 빠진다 — 변경 등록(CRUD_TYPE='M')까지 해야 payload 에 실린다
        tracker?.storeChange(
          target as unknown as WijmoRowItem,
          binding,
          previous as WijmoPrimitive,
          value as WijmoPrimitive
        );
        // 앵커가 받은 종속 컬럼 clear 를 같은 세트 행에도 맞춘다. 변경 등록 뒤에 판정해야
        //   앵커와 같은 CRUD_TYPE 조건(cascadeClearColumns 의 isM)을 본다.
        cascadeClearColumns(binding, target, lockCtxRef.current.division).forEach(col => {
          target[col] = '';
        });
        touched = true;
      }
      if (touched) s.invalidate();
    };
    g.pastedCell.addHandler(propagatePasteToSet as never);

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

    // [비활성화 2026-09-21 최종] 예전엔 더블클릭(또는 콤보 셀 재클릭)일 때만 openSetForEdit 을
    //   불러 병합을 세트로 미리 갈랐다. 최종 확정으로 병합은 어떤 클릭에도 절대 안 바뀐다 — 여기서는
    //   **어떤 물리 행·열을 클릭했는지만** 기록해 둔다(prepareScopeFix 가 쓰기 범위 계산에 사용).
    //   병합 셀은 위에서 아래까지 한 칸이라 wijmo 쪽에는 "클릭한 줄" 정보가 없다 — 물리 행은
    //   좌표 기반 `hitTest` 만 알고 있으므로 여기서 잡아 둔다.
    const mouseDownCapture = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (!ht || ht.panel !== g.cells || ht.row < 0 || ht.col < 0) return;
      pendingEditAnchorRef.current = { row: ht.row, col: ht.col };
      // openSetForEdit(ht.row, ht.col); // [비활성화 2026-09-21 최종] — 위 openSetForEdit 참조
    };
    g.hostElement.addEventListener('mousedown', mouseDownCapture, true);

    // 키보드로 편집을 시작하는 경로(F2 / 문자 입력)도 같은 좌표 기록이 필요하다 — 대상 행은
    //   선택 행이다.
    const keyDownCapture = (ev: KeyboardEvent) => {
      if (g.activeEditor || ev.ctrlKey || ev.metaKey || ev.altKey) return;
      if (ev.key !== 'F2' && ev.key.length !== 1) return; // F2 또는 문자 1글자 입력만 편집을 연다
      const sel = g.selection;
      if (!sel || sel.row < 0 || sel.col < 0) return;
      pendingEditAnchorRef.current = { row: sel.row, col: sel.col };
      // openSetForEdit(sel.row, sel.col); // [비활성화 2026-09-21 최종]
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
        g.pastedCell?.removeHandler(propagatePasteToSet as never);
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
        // allowSorting prop 은 넘기지 않는다 - grid.allowSorting 이 truthy 면 wijmo
        //   _MouseHandler._mousedown 이 헤더 클릭 시 열 전체 선택(_mouseSelect)을 건너뛴다.
        //   공용 정렬(F3 스위치 + 헤더 클릭 + 아이콘)은 이 prop 없이도 그대로 동작한다.
        allowMerging={AllowMerging.All}
      />
    </>
  );
};

// version 등 검색 입력이 키 입력마다 store 를 갱신해 부모가 리렌더돼도, props 가 참조 안정적이면
//   그리드 리렌더(= 공용 DataGrid 리페인트 = 깜빡임)를 건너뛴다. onProjectCellDblClick 은 부모에서
//   useCallback 으로 고정한다.
export const EtcSalesReportsGrid = memo(EtcSalesReportsGridBase);
