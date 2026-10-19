// 같은 feature(supply) 안의 공용 팝업 — baseUrl 기준 비상대 경로(상대경로 import 금지, Top11 #1).
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { CapaItemPopup, type CapaItemSelection } from 'features/supply/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcGridColumnSetup } from '@foundation/assets';
import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction, type EditTracker } from '@foundation/utils';
import {
  ColumnLayoutModal,
  MainTitle,
  saveTitleSet,
  SubTitle,
  TabItem,
  TabWrapper,
} from '@shared/components';
import {
  useInvalidateCombos,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueries,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  ASSIGN_SHEET_BY_DIVISION_TYPE,
  COLUMN,
  COMBO,
  CUTOFF_PROG_STATS,
  DIVISION_TYPE,
  EXCEL_FILE_NAME,
  FALLBACK_LABEL,
  LBL,
  LINE_SHEET_BY_DIVISION_TYPE,
  MENU_ID,
  MSG,
  NEW_ROW_DATE_CELL_VALUE,
  SHEET_PARAM_NAME,
  SHEETS,
  SHOP_GROUP_BY_DIVISION_TYPE,
  SOP_MODEL_SHEET_BY_DIVISION_TYPE,
  SOP_SHEET_BY_DIVISION_TYPE,
  TAB,
  TITLESET_COLUMN_TYPE,
  type TabIndex,
} from './capa-line-assign.constants';
import type { ComboRow, GridRow, SpreadTitleRow } from './capa-line-assign.types';
import styles from './CapaLineAssign.module.scss';
import { CapaLineAssignForm } from './components/CapaLineAssignForm';
import { CapaLineAssignGrid } from './components/CapaLineAssignGrid';
import { CapaLineSopGrid } from './components/CapaLineSopGrid';
import { CapaLineAssignModelModal } from './components/modals/CapaLineAssignModelModal';
import { CapaLineModal } from './components/modals/CapaLineModal';
import { useCapaLineAssignValidation } from './hooks/useCapaLineAssignValidation';
import { useCapaLineCascade } from './hooks/useCapaLineCascade';
import { useCapaLineAssignStore } from './useCapaLineAssignStore';
import { checkNameOnDummyCode, dummyCodeTypeOf } from './utils/capaLineAssign.dummyCode';
import { buildAssignSavePayload, buildSopSavePayload } from './utils/capaLineAssign.save';
import { buildDateColumns, toLayoutFallback } from './utils/capaLineAssignColumns';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/** `_from_yyyymm` — Version(YYYYMM) + 1개월 (AS-IS getter cs:337-358, design 03 §2.1 / D-3). */
const nextMonth = (yyyymm: string): string => {
  if (yyyymm.length < 6) return '';
  const year = Number(yyyymm.slice(0, 4));
  const month = Number(yyyymm.slice(4, 6));
  if (!year || !month) return '';
  return month === 12 ? `${year + 1}01` : `${year}${String(month + 1).padStart(2, '0')}`;
};

/** 팝업 경유 행추가의 중복 판정 키 (design 03 §3.5.1). */
const keyOf = (row: GridRow, columns: readonly string[]): string =>
  columns.map(column => str(row[column])).join('|');

const LINE_DUP_KEYS = [
  COLUMN.DIVISION_ID,
  COLUMN.SITE_ID,
  COLUMN.COMPANY_ID,
  COLUMN.PLANT_ID,
  COLUMN.FACTORY_ID,
  COLUMN.LINE_ID,
] as const;

const SOP_DUP_KEYS = [...LINE_DUP_KEYS, COLUMN.OPERATION_ID, COLUMN.ELTR_LN_TP_CD] as const;

/**
 * SCP0104 CAPA Line Assign — AS-IS `GSCM.SCP.Forms.UIL Master/SCP0104_CAPA_Line_Assign.cs`(6,107줄).
 *
 * 설계: `.atlas/gscm-design/SCP0104/design/00~03,07` · 계획: `convert-flow/{goal,plan}.md` ·
 * AS-IS 라인 매핑: `__asis-mapping__.md`.
 *
 * 구조 요약
 *   · 탭 2개(Line Assign / SOP) × 그리드 2개. **탭 전환은 아무것도 트리거하지 않는다** —
 *     AS-IS `tbcAll` 에 이벤트가 0건이라 탭을 바꾸면 Search 를 다시 눌러야 한다(R-11, hook #81 미적용).
 *   · `divisionType`(Electrode/Cell/Module-Pack)이 시트·콤보·라벨·노출을 동시에 가르는 모드 스위치.
 *   · Search 는 **활성 탭 1개만** 조회한다(AS-IS FindButton 의 첫 분기가 `isPageSOP`).
 *
 * 런타임 한계: `PKG_SCP0104` 미배포(goal.md ②) — 조회·저장은 convert-sp 배포 후에 붙는다.
 */
export const CapaLineAssign = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();
  const invalidateCombos = useInvalidateCombos();
  const { saveWithValidation } = useSaveWithValidation();
  const { findDroppedRowKey } = useCapaLineAssignValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 활성 탭은 store 가 아니라 페이지 로컬 state 다(design 01 R-08 / hook #72).
  const [activeTab, setActiveTab] = useState<TabIndex>(TAB.ASSIGN);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openLinePopup, setOpenLinePopup] = useState(false);
  const [openSopModelPopup, setOpenSopModelPopup] = useState(false);
  const [itemPopupRow, setItemPopupRow] = useState<GridRow | null>(null);

  const assignGridRef = useRef<FlexGrid | undefined>(undefined);
  const sopGridRef = useRef<FlexGrid | undefined>(undefined);
  const assignFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const sopFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const assignTrackerRef = useRef<EditTracker | undefined>(undefined);
  const sopTrackerRef = useRef<EditTracker | undefined>(undefined);
  const savingRef = useRef(false);
  const authAlertedRef = useRef(false);

  const sc = useCapaLineAssignStore(s => s.searchParams);
  const applied = useCapaLineAssignStore(s => s.applied);
  const filters = useCapaLineAssignStore(s => s.filters);
  const editMode = useCapaLineAssignStore(s => s.editMode);
  const staticColumns = useCapaLineAssignStore(s => s.staticColumns);
  const userColumnLayout = useCapaLineAssignStore(s => s.userColumnLayout);
  const openSearchArea = useCapaLineAssignStore(s => s.openSearchArea);
  const initialized = useCapaLineAssignStore(s => s.initialized);
  const setOpenSearchArea = useCapaLineAssignStore(s => s.setOpenSearchArea);
  const setFilters = useCapaLineAssignStore(s => s.setFilters);
  const clearFilters = useCapaLineAssignStore(s => s.clearFilters);
  const clearAssignFilters = useCapaLineAssignStore(s => s.clearAssignFilters);
  const setEditMode = useCapaLineAssignStore(s => s.setEditMode);
  const fetchStaticColumns = useCapaLineAssignStore(s => s.fetchStaticColumns);
  const applyColumnLayout = useCapaLineAssignStore(s => s.applyColumnLayout);
  const clearUserColumnLayout = useCapaLineAssignStore(s => s.clearUserColumnLayout);

  const cascade = useCapaLineCascade();

  const divisionType = sc.divisionType;
  const isEltr = divisionType === DIVISION_TYPE.ELTR;
  const assignSheet = ASSIGN_SHEET_BY_DIVISION_TYPE[divisionType];
  const sopSheet = SOP_SHEET_BY_DIVISION_TYPE[divisionType];
  const linePopupSheet = LINE_SHEET_BY_DIVISION_TYPE[divisionType];
  const sopModelSheet = SOP_MODEL_SHEET_BY_DIVISION_TYPE[divisionType];
  const activeSheet = activeTab === TAB.SOP ? sopSheet : assignSheet;

  // ── 동적 기간컬럼 (design 03 §2 / D-1~D-9) ────────────────────────────────────────────
  //   **Search 전에도 호출한다** — 헤더가 데이터보다 먼저 만들어져야 한다(§4.1 I2).
  const spreadTitleFilters = useMemo(() => {
    const from = nextMonth(sc.verId);
    if (!from) return undefined;
    return {
      p_from_yyyymm: from,
      p_program_id: MENU_ID,
      // AS-IS 가 `""` 를 넘긴다(cs:2098) — 그 결과 1단 헤더가 항상 공백이다(§2.2). 임의 값 금지.
      p_sheet_name: '',
    };
  }, [sc.verId]);

  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: spreadTitleFilters,
    enabled: !!spreadTitleFilters,
  });

  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    () => spreadTitleData?.o_rc1 ?? [],
    [spreadTitleData]
  );
  const dateColumns = useMemo(() => buildDateColumns(spreadTitleRows), [spreadTitleRows]);
  const dateBindings = useMemo(
    () =>
      [...spreadTitleRows]
        .sort((a, b) => Number(str(a.SORT_ORDER_NO)) - Number(str(b.SORT_ORDER_NO)))
        .map(row => str(row.COLUMN_NAME))
        .filter(Boolean),
    [spreadTitleRows]
  );

  // ── 그리드 조회 ──────────────────────────────────────────────────────────────────────
  const assignQuery = useTabProcQuery<MENU_ID, SHEETS.ASSEMBLY | SHEETS.ELTR>({
    menuId: MENU_ID,
    sheetName: assignSheet,
    tabId,
    filters: filters[assignSheet],
    enabled: !!filters[assignSheet],
  });
  const sopQuery = useTabProcQuery<MENU_ID, SHEETS.SOP_ASSEMBLY | SHEETS.SOP_ELTR>({
    menuId: MENU_ID,
    sheetName: sopSheet,
    tabId,
    filters: filters[sopSheet],
    enabled: !!filters[sopSheet],
  });

  // itemsSource 참조 안정화 — 매 렌더 새 배열이면 memo(DataGrid) 가 무력화된다(§5-4).
  const assignRows = useMemo<GridRow[]>(
    () => (assignQuery.data?.o_rc1 ?? []) as unknown as GridRow[],
    [assignQuery.data]
  );
  const sopRows = useMemo<GridRow[]>(
    () => (sopQuery.data?.o_rc1 ?? []) as unknown as GridRow[],
    [sopQuery.data]
  );

  // ── 셀 콤보 원천 (design 03 §5.6) ────────────────────────────────────────────────────
  //   `CapaNickname_SCP_ALL` 은 `CODE`/`NAME` 별칭이 없다(§6-2 FAIL) — 그대로 셀 콤보에 물리면
  //   목록이 조용히 빈다. 그래서 rows 를 받아 `NICK_NAME`/`ITEM_ID` 를 직접 읽는다.
  const [nicknameRowsRaw] = useTabComboQueries({ filters: [COMBO.NICKNAME] });
  const [dummyCodeRowsRaw] = useTabComboQueries({ filters: [COMBO.DUMMY_CODE] });

  /**
   * G14·G15 로 이번 세션에 채번된 Dummy 코드 — AS-IS `AppendNewDummyCode`/`AppendNewCode` 가
   * **재조회 없이 클라 DataTable 에 직접 덧붙이는** 것(cs:3666-3668·3683-3685)과 같은 자리다.
   * 조회조건 목록을 다시 받으면 사용자가 고른 조건이 초기화되므로 AS-IS 도 refetch 를 피했다.
   */
  const [appendedDummyRows, setAppendedDummyRows] = useState<ComboRow[]>([]);

  const comboSources = useMemo(
    () => ({
      masterRows: cascade.masterRows,
      operationRows: cascade.operationRows,
      electrodeRows: cascade.electrodeRows,
      nicknameRows: [...((nicknameRowsRaw ?? []) as ComboRow[]), ...appendedDummyRows],
    }),
    [
      cascade.masterRows,
      cascade.operationRows,
      cascade.electrodeRows,
      nicknameRowsRaw,
      appendedDummyRows,
    ]
  );

  const dummyCodes = useMemo(
    () =>
      new Set(
        [
          ...((dummyCodeRowsRaw ?? []) as ComboRow[]),
          ...appendedDummyRows,
        ]
          .map(row => str(row.CODE))
          .filter(Boolean)
      ),
    [dummyCodeRowsRaw, appendedDummyRows]
  );

  // ── 진입 / 조건 변경 ────────────────────────────────────────────────────────────────
  useEffect(() => {
    // 진입 자동조회 금지 — MDI keep-alive 로 남은 stale filters 무효화(§5-7).
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 권한 Division 0건 게이트 — 판정 시점은 **콤보 응답 도착 시 1회**(조회 버튼 시점이 아니다).
  //   메시지는 MSG00667 이다. TO-BE MSG00097 은 "Please select Division." 이라 재사용 금지(R-22).
  useEffect(() => {
    if (cascade.hasDivisionAuth || authAlertedRef.current) return;
    authAlertedRef.current = true;
    void setAlert({
      type: 'alert',
      content: t(MSG.NO_DIVISION_AUTH, { defaultValue: 'No authority assigned.' }),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cascade.hasDivisionAuth]);

  /**
   * 초기화 비대칭 재현 (design 01 §3.3 결론1 / K-16).
   *   · Division / Plan Month / Version 변경 → **Assign 탭만** 비운다(SOP 탭 잔존).
   *   · `divisionType` 변경 → 양 탭 초기화(store `changeDivisionType` 이 수행).
   * "조건이 바뀌면 둘 다 비운다"로 통일하면 AS-IS 와 달라진다.
   */
  const prevDivisionRef = useRef(sc.divisionId);
  const prevVerRef = useRef(`${sc.verId}|${sc.verSeq}`);
  const prevDivisionTypeRef = useRef(sc.divisionType);
  useEffect(() => {
    const verKey = `${sc.verId}|${sc.verSeq}`;
    if (prevDivisionTypeRef.current !== sc.divisionType) {
      prevDivisionTypeRef.current = sc.divisionType;
      prevDivisionRef.current = sc.divisionId;
      prevVerRef.current = verKey;
      assignTrackerRef.current?.clearChanges();
      sopTrackerRef.current?.clearChanges();
      // 컬럼 메타는 set() 커밋 뒤 새 값으로 호출한다(producer 안 get() 금지 — §5-5).
      void fetchStaticColumns(sc.divisionId);
      queryClient.removeQueries({ queryKey: [tabId] });
      return;
    }
    if (prevDivisionRef.current !== sc.divisionId || prevVerRef.current !== verKey) {
      const divisionChanged = prevDivisionRef.current !== sc.divisionId;
      prevDivisionRef.current = sc.divisionId;
      prevVerRef.current = verKey;
      assignTrackerRef.current?.clearChanges();
      clearAssignFilters();
      if (divisionChanged) {
        clearUserColumnLayout();
        void fetchStaticColumns(sc.divisionId);
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, sc.verId, sc.verSeq, sc.divisionType]);

  // 조회 성공 시 편집모드 해제 + EditTracker clear (R-16·R-17 / CP-10).
  //   빼면 "편집모드로 조회 → 이전 편집표시가 새 데이터에 남음" 회귀가 난다.
  useEffect(() => {
    if (!assignQuery.data) return;
    assignTrackerRef.current?.clearChanges();
    setEditMode(assignSheet, false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [assignQuery.data]);

  useEffect(() => {
    if (!sopQuery.data) return;
    sopTrackerRef.current?.clearChanges();
    setEditMode(sopSheet, false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sopQuery.data]);

  // ── 액션 ────────────────────────────────────────────────────────────────────────────
  // 주의: `*` 필수 조회조건 검증은 구현하지 않는다 — Designer 라벨 중 `*` 로 끝나는 것이 0건이라
  //   AS-IS 에서 사문화된 분기다(R-27 / V-21). 없는 검증을 새로 만들지 않는다.
  const handleSearch = () => {
    if (!cascade.hasDivisionAuth) return;
    assignTrackerRef.current?.clearChanges();
    sopTrackerRef.current?.clearChanges();
    // AS-IS FindButton 은 `isPageSOP` 로 갈린다 — 활성 탭 1개만 조회한다.
    setFilters(activeTab, cascade.candidates);
    void fetchStaticColumns(sc.divisionId);
  };

  /**
   * Edit(F2) — AS-IS `EditButton()` override.
   * 컷오프 게이트(R-19)를 **통과한 뒤에만** 편집모드를 뒤집는다. Assign 분기는 진입 시 셀 콤보
   * 후보를 현재 division 기준으로 다시 받는다(AS-IS `RefreshSpreadAll`, cs:4113).
   */
  const handleEdit = () => {
    const grid = activeTab === TAB.SOP ? sopGridRef.current : assignGridRef.current;
    if (!grid) return; // R-18 — ref 미준비 시 조용히 return(토스트 금지)
    if (CUTOFF_PROG_STATS.includes(cascade.progStat)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.CUTOFF_READONLY, { defaultValue: 'Read-only mode.' }),
      });
      return;
    }
    const next = !editMode[activeSheet];
    setEditMode(activeSheet, next);
    if (next && activeTab === TAB.ASSIGN) {
      void invalidateCombos([
        COMBO.MASTER,
        COMBO.MASTER_EE,
        COMBO.OPERATION,
        COMBO.OPERATION_EE,
        COMBO.ELECTRODE_TYPE,
        COMBO.NICKNAME,
      ]);
    }
  };

  /**
   * Insert(F8) — SubTitle INSERT 1개를 `activeTab` 으로 라우팅한다(U-1 확정, hook #97).
   * AS-IS 는 공통 `InsertButton` 이 SOP 탭에서 early-return(B11) 하기 때문에 SOP 전용 `btnSopNew`
   * 를 따로 뒀다. TO-BE 는 그 우회를 없애고 **가드 3개(R-13)만 SOP 분기에 재현**한다.
   * 전부 메시지 없이 조용히 return 하는 것도 AS-IS 그대로다(CP-13).
   */
  const handleInsert = () => {
    if (activeTab === TAB.SOP) {
      if (!sopGridRef.current) return; // ① `_siSop == null`
      if (!editMode[sopSheet]) return; // ②③ `IsLock(sheet)` / `!IsEditModes[SOP]`
      // SOP 행은 P02 SOP Model 팝업으로만 만들어진다(G44·G45 `Insert_Row_Sop`).
      setOpenSopModelPopup(true);
      return;
    }
    const grid = assignGridRef.current;
    if (!grid) return; // B12
    if (!editMode[assignSheet]) return; // B13 시트 잠금(조회모드)
    // 신규행 기본값은 **확정 조회조건**(applied) 기준이다 — 입력 중 searchParams 가 아니다
    //   (CommonCheckList Division §"Insert 시 확정 searchParams 기준 division").
    if (!applied) return;
    const row: Record<string, unknown> = {
      [COLUMN.VER_ID]: applied.verId,
      [COLUMN.VER_SEQ]: applied.verSeq,
      [COLUMN.DIVISION_ID]: applied.divisionId,
      [COLUMN.DUMMY_YN]: 'N',
      [COLUMN.VALID_YN]: 'Y',
    };
    // ELTR 신규행은 `ELTR_LN_TP_CD` 기본값이 'S' 다(G38, cs:5300-5303).
    if (isEltr) row[COLUMN.ELTR_LN_TP_CD] = 'S';
    // 동적 기간셀 기본값은 전건 "1"(D-8).
    for (const binding of dateBindings) row[binding] = NEW_ROW_DATE_CELL_VALUE;
    GridAction.addRow(grid, row as Partial<WijmoRowItem>);
  };

  /**
   * Delete(F9) — AS-IS `DeleteButton`(G31·G32).
   * 가드 3종(그리드 없음 / 빈 그리드 / 미선택)은 전부 무동작이고, **신규행('I')만 실제로 제거**한다.
   * 기존행은 삭제 대신 `VALID_YN='N'` 편집으로 처리한다(hook #138 / S-4).
   */
  const handleDelete = () => {
    const grid = activeTab === TAB.SOP ? sopGridRef.current : assignGridRef.current;
    if (!grid) return;
    if (grid.rows.length === 0) return;
    if (!grid.selectedRows?.length) return;
    GridAction.removeRow(grid, true);
    grid.invalidate();
  };

  const doSave = (rows: GridRow[]) => {
    void (async () => {
      if (savingRef.current) return;
      const isSop = activeTab === TAB.SOP;
      const sheetParam = SHEET_PARAM_NAME[divisionType];
      const payload = isSop
        ? buildSopSavePayload({
            rows,
            verId: applied?.verId ?? sc.verId,
            verSeq: applied?.verSeq ?? sc.verSeq,
            sheetParamName: `SOP_${sheetParam}`,
          })
        : buildAssignSavePayload({
            rows,
            verId: applied?.verId ?? sc.verId,
            verSeq: applied?.verSeq ?? sc.verSeq,
            sheetParamName: sheetParam,
            isEltr,
            dateBindings,
          });

      savingRef.current = true;
      try {
        const res = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${activeSheet}/SAVE/call-proc`,
          payload
        );
        // false-success 차단(§5-10 / S-10) — 인터셉터가 500/CODE≠0 도 resolve 할 수 있다.
        if (res.status >= 400 || Number(res.data?.code)) {
          void setAlert({
            type: 'alert',
            content:
              (res.data as { message?: string })?.message?.trim() ||
              t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
          });
          return;
        }
        // SAVE SP 는 `result_code`/`result_cnt` 를 돌려주고 AS-IS 는 `'S'` 만 성공으로 본다(§4.3-e).
        const body = res.data?.result as Record<string, unknown> | undefined;
        const firstSet = body
          ? (Object.values(body).find(Array.isArray) as Record<string, unknown>[] | undefined)
          : undefined;
        const head = firstSet?.[0];
        const resultCode = head ? str(head.result_code ?? head.RESULT_CODE) : '';
        if (resultCode && resultCode !== 'S') {
          void setAlert({
            type: 'alert',
            content: t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
          });
          return;
        }
        const savedCount = head ? str(head.result_cnt ?? head.RESULT_CNT) : '';
        // 주의: i18next 기본 보간자는 `{{ }}` 라 DB 메시지의 `{0}` 은 옵션 전달로 치환되지 않는다.
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, { defaultValue: '{0} data saved.' }).replace(
            '{0}',
            String(savedCount || rows.length)
          ),
        });
        if (isSop) {
          sopTrackerRef.current?.clearChanges();
          setEditMode(sopSheet, false);
          void sopQuery.refetch?.();
        } else {
          assignTrackerRef.current?.clearChanges();
          setEditMode(assignSheet, false);
          void assignQuery.refetch?.();
        }
      } catch (error) {
        void setAlert({
          type: 'alert',
          content:
            error instanceof Error
              ? error.message
              : t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
        });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  /**
   * Save(F7) — 활성 탭 1시트만 저장한다.
   *
   * 검증 2단(둘 다 필수):
   *   ① 화면 커스텀 — SP 가 필수키 공백 행을 **에러 없이 버리므로**(§4.3-d) FE 가 먼저 막는다.
   *   ② 공용 메타 기반 `useSaveWithValidation` — `INPUT_TP_CD=M/IM` 컬럼 빈값 차단.
   *      전제: `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD` 가 전건 `'S'` 인 현재 상태에서는 무발동이다
   *      (design 03 §0.3). `05_register.sql` 의 정정 UPDATE(U-8 승인)가 적용돼야 실효가 생긴다.
   */
  const handleSave = () => {
    const isSop = activeTab === TAB.SOP;
    const grid = isSop ? sopGridRef.current : assignGridRef.current;
    if (!grid) return;
    grid.finishEditing();
    if (!editMode[activeSheet]) return;
    const source = (grid.collectionView?.sourceCollection ?? []) as GridRow[];
    const dirty = source.filter(row => row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      setToast({
        type: 'error',
        message: t(MSG.NO_CHANGES, { defaultValue: 'No changes to save.' }),
      });
      return;
    }
    const dropped = findDroppedRowKey(dirty, { isEltr, isSop, dateBindings });
    if (dropped) {
      void setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_FIELD.id, CRUD_MSG.REQUIRED_FIELD.fallback).replace(
          '{0}',
          `[${dropped.column}]`
        ),
      });
      return;
    }
    saveWithValidation(dirty, staticColumns[activeSheet], rows => doSave(rows));
  };

  // AS-IS 툴바 override 는 5종뿐이다(Search/Insert/Edit/Delete/Save) — Excel/Upload/Manual 없음.
  //   `hasButton` 을 곱해 admin 권한 메타로 노출을 가른다(R-23 / CP-03, hook #63).
  const editable = editMode[activeSheet] === true;
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') && editable ? handleInsert : false,
    delete: hasButton('DELETE') && editable ? handleDelete : false,
    save: hasButton('SAVE') && editable ? handleSave : false,
    manual: false,
    upload: false,
  };

  // `btnColumn`(P04)은 조회영역 버튼이 아니라 SubTitle 공용 아이콘으로 옮긴다(hook #120).
  //   이 화면은 환율·Measure 아이콘을 쓰지 않아 GridColumnSet 1개뿐이다 → 순서 이슈 미해당.
  const customButtons = [
    ...(hasButton('EDIT')
      ? [
          {
            label: t(LBL.EDIT, { defaultValue: 'Edit' }),
            title: t(LBL.EDIT, { defaultValue: 'Edit' }),
            action: handleEdit,
          },
        ]
      : []),
    {
      label: t(LBL.COLUMN_SETTING, { defaultValue: 'Column Setting' }),
      title: t(LBL.COLUMN_SETTING, { defaultValue: 'Column Setting' }),
      action: () => setOpenColumnSetting(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
  ];

  /**
   * 셀 더블클릭 라우팅 — `NICK_NAME`/`ITEM_ID` → P01 Item / 그 외 → P03 CAPA Line (00 §4e, hook #18).
   *
   * AS-IS cs:5709-5712 두 분기를 그대로 옮긴다. ELTR 의 `NICK_NAME` 은 **아무 팝업도 열지 않는다**
   * (A-7 / B34, 2025-03-31 개정) — Line 팝업으로 흘리면 AS-IS 에 없던 동작이 생긴다.
   * 반대로 ELTR 의 주키는 `ITEM_ID` 라 그 셀이 Item 팝업 진입점이다.
   */
  const handleAssignCellDblClick = (binding: string, row: GridRow) => {
    if (isEltr && binding === COLUMN.NICK_NAME) return;
    if (binding === COLUMN.NICK_NAME || binding === COLUMN.ITEM_ID) {
      setItemPopupRow(row);
      return;
    }
    setOpenLinePopup(true);
  };

  /**
   * P01 Item 선택 확정 — AS-IS `spdAssign_CellDoubleClick`(cs:5712-5734) + `ShowItem`(cs:5852-5882).
   *
   * 선택 **1건이면 더블클릭한 행 수정**(`Edit_Row_Assign`), **2건 이상이면 건수만큼 행 추가**
   * (`Insert_Row_Assign` 반복, A-6). 값 배치는 모드로 갈린다 — CELL/M-P 는 `NICK_NAME`=선택값·
   * `ITEM_ID`='-', ELTR 은 반대다(cs:5316-5325). 추가행 기본값은 `handleInsert` 와 동일한
   * `Edit_Row_Assign` 추가모드 블록(cs:5292-5310)이다.
   */
  const handleItemPopupSelect = (selectedAll: CapaItemSelection[]) => {
    const row = itemPopupRow;
    if (!row) return;
    // AS-IS `GetSelectedValues` 는 공백 제거 + distinct 다(SCM0002_CAPAItemPopup.cs:139).
    const picked = [
      ...new Set(
        selectedAll
          .map(selection => (isEltr ? selection.itemId : (selection.nickName ?? '')))
          .filter(Boolean)
      ),
    ];
    if (picked.length === 0) return;
    const grid = assignGridRef.current;
    if (!grid) return;
    const putItem = (target: GridRow, item: string) => {
      target[COLUMN.NICK_NAME] = isEltr ? '-' : item;
      target[COLUMN.ITEM_ID] = isEltr ? item : '-';
    };
    if (picked.length === 1) {
      // 주의: 값 대입만으로는 CRUD_TYPE 이 서지 않는다 — handleSave 가 CRUD_TYPE 으로만 dirty 를
      // 고르므로 셀에 값이 보여도 저장에서 통째로 빠진다. CRUD_TYPE 을 세우는 경로는
      // EditTracker.storeChange 와 GridAction.addRowSet 둘뿐이라, 셀 편집과 동일하게 공용
      // tracker 를 경유해 기록한다. 원본과 같아지면 tracker 가 M 을 자동 해제한다.
      const tracker = assignTrackerRef.current;
      const prevNickName = row[COLUMN.NICK_NAME] as WijmoPrimitive;
      const prevItemId = row[COLUMN.ITEM_ID] as WijmoPrimitive;
      putItem(row, picked[0]);
      const target = row as unknown as WijmoRowItem;
      tracker?.storeChange(
        target,
        COLUMN.NICK_NAME,
        prevNickName,
        row[COLUMN.NICK_NAME] as WijmoPrimitive
      );
      tracker?.storeChange(target, COLUMN.ITEM_ID, prevItemId, row[COLUMN.ITEM_ID] as WijmoPrimitive);
      grid.invalidate();
      return;
    }
    // 신규행 기본값은 확정 조회조건(applied) 기준 — 입력 중 searchParams 가 아니다.
    if (!applied) return;
    const newRows = picked.map(item => {
      const candidate: GridRow = {
        [COLUMN.VER_ID]: applied.verId,
        [COLUMN.VER_SEQ]: applied.verSeq,
        [COLUMN.DIVISION_ID]: applied.divisionId,
        [COLUMN.DUMMY_YN]: 'N',
        [COLUMN.VALID_YN]: 'Y',
      };
      if (isEltr) candidate[COLUMN.ELTR_LN_TP_CD] = 'S';
      for (const binding of dateBindings) candidate[binding] = NEW_ROW_DATE_CELL_VALUE;
      putItem(candidate, item);
      return candidate as Partial<WijmoRowItem>;
    });
    GridAction.addRowSet(grid, newRows);
  };

  /**
   * G14·G15 — 마스터에 없는 명칭 입력 시 Dummy 코드 get-or-create (AS-IS cs:3658-3690).
   *
   * 순서도 AS-IS 그대로다: CHECK SP 채번 → 클라 목록 2종 갱신(조회조건/셀 콤보) → `DUMMY_YN='Y'`.
   * 채번 실패(미배포·오류)면 **아무것도 바꾸지 않는다** — AS-IS 도 `""` 를 받으면 `DUMMY_YN` 을
   * 세우지 않고 지나간다. 그 경우 저장 시 서버가 그 행을 버릴 수 있다는 점은 04 리포트에 남긴다.
   */
  const handleUnknownItemName = (binding: string, row: GridRow, name: string) => {
    const codeType = dummyCodeTypeOf(binding, isEltr);
    if (!codeType) return;
    void (async () => {
      const code = await checkNameOnDummyCode({ sheet: assignSheet, codeType, name });
      if (!code) return;
      setAppendedDummyRows(previous =>
        previous.some(candidate => str(candidate.CODE) === code)
          ? previous
          : [
              ...previous,
              {
                CODE: code,
                NAME: name,
                DIVISION_ID: str(row[COLUMN.DIVISION_ID]),
                [COLUMN.NICK_NAME]: isEltr ? '' : name,
                [COLUMN.ITEM_ID]: isEltr ? name : code,
              } as ComboRow,
            ]
      );
      row[COLUMN.DUMMY_YN] = 'Y';
      assignGridRef.current?.invalidate();
    })();
  };

  /** P03 선택 다건 → Assign 행 추가. 중복키(6키) 행은 건너뛴다(§3.5.1 / A-5). */
  const handleLinePopupConfirm = (picked: GridRow[]) => {
    const grid = assignGridRef.current;
    if (!grid || !applied) return;
    const existing = new Set(assignRows.map(row => keyOf(row, LINE_DUP_KEYS)));
    const newRows: Partial<WijmoRowItem>[] = [];
    for (const source of picked) {
      const candidate: Record<string, unknown> = {
        [COLUMN.VER_ID]: applied.verId,
        [COLUMN.VER_SEQ]: applied.verSeq,
        [COLUMN.DIVISION_ID]: str(source.DIVISION_ID) || applied.divisionId,
        [COLUMN.SITE_ID]: str(source.SITE_ID),
        [COLUMN.SITE_NAME]: str(source.SITE_NAME),
        [COLUMN.COMPANY_ID]: str(source.COMPANY_ID),
        [COLUMN.COMPANY_NAME]: str(source.COMPANY_NAME),
        [COLUMN.PLANT_ID]: str(source.PLANT_ID),
        [COLUMN.PLANT_NAME]: str(source.PLANT_NAME),
        [COLUMN.FACTORY_ID]: str(source.FACTORY_ID),
        [COLUMN.FACTORY_NAME]: str(source.FACTORY_NAME),
        [COLUMN.LINE_ID]: str(source.LINE_ID),
        [COLUMN.LINE_NAME]: str(source.LINE_NAME),
        [COLUMN.VALID_YN]: 'Y',
        [COLUMN.DUMMY_YN]: 'N',
      };
      // AS-IS `Edit_Row_Assign_Line` 은 Operation·ELTR_LN_TP_CD·Item 계열을 채우지 않는다(G40).
      // AS-IS `InsertAssignLine` 은 중복체크 **앞에서** 6키 전건을 두 번 건다 —
      //   ① 하나라도 `'-'` 면 skip ② 하나라도 공백이면 skip("빈값 or 오입력 방지" 주석).
      //   `'-'` 는 공백이 아니라서 저장 전 필수키 검사(findDroppedRowKey)도, SAVE SP 의 공백 탈락
      //   필터(design 03 §4.3-d)도 통과한다 → 6키 중 하나만 검사하면 `'-'` 키 행이 실제로 MERGE 된다.
      //   AS-IS 의 가드 6키와 중복키 6키가 같은 집합이라 `LINE_DUP_KEYS` 를 그대로 쓴다.
      if (LINE_DUP_KEYS.some(binding => str(candidate[binding]) === '-')) continue;
      if (LINE_DUP_KEYS.some(binding => !str(candidate[binding]))) continue;
      const key = keyOf(candidate as GridRow, LINE_DUP_KEYS);
      if (existing.has(key)) continue; // 중복 행 skip
      existing.add(key);
      for (const binding of dateBindings) candidate[binding] = NEW_ROW_DATE_CELL_VALUE;
      newRows.push(candidate as Partial<WijmoRowItem>);
    }
    if (newRows.length > 0) GridAction.addRowSet(grid, newRows);
  };

  /** P02 선택 다건 → SOP 행 추가. 중복키(8키) 행은 건너뛴다(§3.5.1). */
  const handleSopModelConfirm = (picked: GridRow[]) => {
    const grid = sopGridRef.current;
    if (!grid || !applied) return;
    const existing = new Set(sopRows.map(row => keyOf(row, SOP_DUP_KEYS)));
    const newRows: Partial<WijmoRowItem>[] = [];
    for (const source of picked) {
      // AS-IS `Edit_Row_Sop`(G39) — 17필드 + `VALID_YN='Y'`.
      const candidate: Record<string, unknown> = {
        [COLUMN.DIVISION_ID]: str(source.DIVISION_ID) || applied.divisionId,
        [COLUMN.SITE_ID]: str(source.SITE_ID),
        [COLUMN.SITE_NAME]: str(source.SITE_NAME),
        [COLUMN.COMPANY_ID]: str(source.COMPANY_ID),
        [COLUMN.COMPANY_NAME]: str(source.COMPANY_NAME),
        [COLUMN.PLANT_ID]: str(source.PLANT_ID),
        [COLUMN.PLANT_NAME]: str(source.PLANT_NAME),
        [COLUMN.FACTORY_ID]: str(source.FACTORY_ID),
        [COLUMN.FACTORY_NAME]: str(source.FACTORY_NAME),
        [COLUMN.LINE_ID]: str(source.LINE_ID),
        [COLUMN.LINE_NAME]: str(source.LINE_NAME),
        [COLUMN.OPERATION_ID]: str(source.OPERATION_ID),
        [COLUMN.OPERATION_NAME]: str(source.OPERATION_NAME),
        [COLUMN.ELTR_LN_TP_CD]: str(source.ELTR_LN_TP_CD),
        [COLUMN.VALID_YN]: 'Y',
      };
      const key = keyOf(candidate as GridRow, SOP_DUP_KEYS);
      if (existing.has(key)) continue;
      existing.add(key);
      newRows.push(candidate as Partial<WijmoRowItem>);
    }
    if (newRows.length > 0) GridAction.addRowSet(grid, newRows);
  };

  const activeColumns = staticColumns[activeSheet];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <CapaLineAssignForm cascade={cascade} onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={activeTab === TAB.SOP ? sopGridRef : assignGridRef}
        gridFilter={activeTab === TAB.SOP ? sopFilterRef : assignFilterRef}
        dataCount={activeTab === TAB.SOP ? sopRows.length : assignRows.length}
        excelFileName={EXCEL_FILE_NAME}
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/*
        탭 2개. `persist` 로 비활성 탭을 언마운트하지 않는다 — 재마운트 시 헤더높이·머지가 타이밍으로
        깨진다(§5-8). 탭 전환에 자동 조회를 붙이지 않는다(R-11 — AS-IS `tbcAll` 이벤트 0건).
      */}
      <div className={styles.tabArea}>
        <TabWrapper
          persist
          activeTabIndex={activeTab}
          setActiveTabIndex={index => setActiveTab(index as TabIndex)}
        >
          <TabItem label={t(LBL.TAB_LINE_ASSIGN, { defaultValue: 'Line Assign' })}>
            <CapaLineAssignGrid
              sheet={assignSheet}
              data={assignRows}
              gridRef={assignGridRef}
              gridFilterRef={assignFilterRef}
              editTrackerRef={assignTrackerRef}
              adminColumns={staticColumns[assignSheet]}
              userColumnLayout={userColumnLayout[assignSheet]}
              dateColumns={dateColumns}
              editMode={editMode[assignSheet] === true}
              comboSources={comboSources}
              dummyCodes={dummyCodes}
              onCellDblClick={handleAssignCellDblClick}
              onUnknownItemName={handleUnknownItemName}
            />
          </TabItem>
          {/* SOP 탭 라벨은 `SCM_ADM_MSG_M` 에 등가 LBL 이 없다 — 임의 등록 금지, 영문 fallback 유지. */}
          <TabItem label={FALLBACK_LABEL.TAB_SOP}>
            <CapaLineSopGrid
              sheet={sopSheet}
              data={sopRows}
              gridRef={sopGridRef}
              gridFilterRef={sopFilterRef}
              editTrackerRef={sopTrackerRef}
              adminColumns={staticColumns[sopSheet]}
              userColumnLayout={userColumnLayout[sopSheet]}
              editMode={editMode[sopSheet] === true}
            />
          </TabItem>
        </TabWrapper>
      </div>

      {/* P03 CAPA Line — 셀 더블클릭 진입. */}
      <CapaLineModal
        open={openLinePopup}
        sheet={linePopupSheet}
        tabId={tabId}
        divisionId={applied?.divisionId ?? sc.divisionId}
        onClose={() => setOpenLinePopup(false)}
        onConfirm={handleLinePopupConfirm}
      />

      {/* P02 SOP Model — SOP 탭 Insert 진입(AS-IS btnSopNew → InsertSop). */}
      <CapaLineAssignModelModal
        open={openSopModelPopup}
        sheet={sopModelSheet}
        tabId={tabId}
        divisionId={applied?.divisionId ?? sc.divisionId}
        verId={applied?.verId ?? sc.verId}
        verSeq={applied?.verSeq ?? sc.verSeq}
        onClose={() => setOpenSopModelPopup(false)}
        onConfirm={handleSopModelConfirm}
      />

      {/*
        P01 Item — 그리드 셀(`NICK_NAME`/`ITEM_ID`) 경유. AS-IS `ShowItem` 은 `Init(true, …)` =
        **다중선택**이고(cs:5860) 선택 1건이면 현재행 수정, 2건 이상이면 행 추가다(A-6).
        공용 `CapaItemPopup` 이 `multiSelect`/`selectedAll` 을 이미 제공하므로 자기 화면만 고쳐 배선한다.
        `OPERATION_GROUP = shop_group` 필터는 AS-IS 가 **조회 직후 목록 자체**에 건다
        (SCM0002_CAPAItemPopup.cs:301-303) — 공용 `operationGroup` prop 이 같은 위치에 걸어준다.
      */}
      <CapaItemPopup
        multiSelect
        open={itemPopupRow !== null}
        operationGroup={SHOP_GROUP_BY_DIVISION_TYPE[divisionType]}
        params={{
          // AS-IS `ShowItem` 은 인자를 쓰지 않고 **조회조건 컨트롤 현재값**을 넘긴다 — `_division`/
          //   `_item_id` 둘 다 getter(cs:303·729)라 확정값(applied)이 아니라 입력 중 값이다(cs:5860).
          //   그리드 셀 경로도 같은 값이다(cs:5714 가 넘긴 `""` 는 `ShowItem` 이 쓰지 않는다).
          divisionId: sc.divisionId,
          itemId: sc.itemId,
        }}
        onClose={() => setItemPopupRow(null)}
        onSelect={(_, selectedAll) => handleItemPopupSelect(selectedAll)}
      />

      {/*
        P04 컬럼 표시설정 — 공용 `ColumnLayoutModal` 재사용(사본 금지, hook #132).
        저장 후 그리드를 비우고 Search 를 재유도한다 — 설정이 바뀌면 이전 조회 rows 는 무효다
        (design 03 §2.4 T6 / 01 §3.3 결론3). 조회·저장·복원의 sheetName/columnType 3점이 일치해야
        "저장은 되는데 재진입 시 원복" 사고가 나지 않는다(§5-9).
      */}
      <ColumnLayoutModal
        open={openColumnSetting}
        modalClose={() => setOpenColumnSetting(false)}
        menuId={MENU_ID}
        sheetName={activeSheet}
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={sc.divisionId}
        fallbackColumns={toLayoutFallback(activeColumns)}
        onSave={settings => {
          const sheet = activeSheet;
          applyColumnLayout(
            sheet,
            settings.map(setting => ({
              colNm: setting.COLUMN_NAME,
              visible: setting.USER_FLAG === 'Y',
              width: setting.COL_WIDTH,
              cellColor: setting.CELL_COLOR,
              textColor: setting.TEXT_COLOR,
              order: setting.SORT_ORDER_NO,
            }))
          );
          // 설정이 바뀌었으므로 이전 조회 rows 는 무효 — 그리드부터 비운다(조회는 하지 않는다).
          clearAssignFilters();
          const visible = settings.filter(setting => setting.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: sheet,
            columnType: TITLESET_COLUMN_TYPE,
            rows: visible.map((setting, index) => ({
              name: setting.COLUMN_NAME,
              sortOrderNo: index + 1,
              colWidth: setting.COL_WIDTH,
              cellColor: setting.CELL_COLOR,
              textColor: setting.TEXT_COLOR,
            })),
          }).then(ok => {
            if (!ok) {
              void setAlert({
                type: 'alert',
                content: t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
              });
              return;
            }
            // 전역 staleTime=Infinity 라 invalidate 없이는 팝업 titleSet 재조회가 일어나지 않는다.
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            void fetchStaticColumns(sc.divisionId);
          });
        }}
      />
    </>
  );
};
