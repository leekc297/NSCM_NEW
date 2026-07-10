// SYS0013 Dynamic Query — 진입 컴포넌트 (2026-07-09 재개발).
// 기준 스펙: Doc/화면설계서/SYS0013_DynamicQuery_상세동작_개발용.md (AS-IS SCM0005 이벤트 23종).
// CRUD = 표준 EditTracker + GridAction / 저장 = useDynamicQuerySave (useProcMutation 수렴).
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { BUTTON_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DynamicQueryColumnsGrid } from './components/DynamicQueryColumnsGrid';
import { DynamicQueryEditModal, type EditModalResult } from './components/DynamicQueryEditModal';
import { DynamicQueryForm } from './components/DynamicQueryForm';
import { DynamicQueryMainGrid } from './components/DynamicQueryMainGrid';
import { DynamicQueryMetaForm } from './components/DynamicQueryMetaForm';
import { DynamicQueryParametersGrid } from './components/DynamicQueryParametersGrid';
import { DynamicQueryResultGrid } from './components/DynamicQueryResultGrid';
import { DynamicQuerySQLViewer } from './components/DynamicQuerySQLViewer';
import { MENU_ID, SHEETS, SHEET_INDEX } from './dynamic-query.constants';
import { extractParamTokens, substituteParams } from './dynamic-query.payload';
import type {
  ColumnMetaRow,
  ParameterMetaRow,
  PendingQueryMeta,
  QueryRow,
  ResultRow,
  ValidateColumnRow,
} from './dynamic-query.types';
import styles from './DynamicQuery.module.scss';
import { useDynamicQuerySave } from './useDynamicQuerySave';
import { useDynamicQueryStore } from './useDynamicQueryStore';

export const DynamicQuery = ({ tabId, title }: PageProps<MENU_ID>) => {
  const mainGridRef = useRef<FlexGrid<QueryRow>>(undefined);
  const resultGridRef = useRef<FlexGrid<ResultRow>>(undefined);
  const columnsGridRef = useRef<FlexGrid<ColumnMetaRow>>(undefined);
  const parametersGridRef = useRef<FlexGrid<ParameterMetaRow>>(undefined);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const mainEditTrackerRef = useRef<EditTracker<QueryRow>>(undefined);
  const columnsEditTrackerRef = useRef<EditTracker<ColumnMetaRow>>(undefined);
  const parametersEditTrackerRef = useRef<EditTracker<ParameterMetaRow>>(undefined);

  const initialized = useDynamicQueryStore(s => s.initialized);
  const fetchSearchConditions = useDynamicQueryStore(s => s.fetchSearchConditions);
  const fetchStaticColumns = useDynamicQueryStore(s => s.fetchStaticColumns);
  const filters = useDynamicQueryStore(s => s.filters);
  const setFilter = useDynamicQueryStore(s => s.setFilter);
  const setExecuteFilter = useDynamicQueryStore(s => s.setExecuteFilter);
  const openSearchArea = useDynamicQueryStore(s => s.openSearchArea);
  const setOpenSearchArea = useDynamicQueryStore(s => s.setOpenSearchArea);
  const activePage = useDynamicQueryStore(s => s.activePage);
  const setActivePage = useDynamicQueryStore(s => s.setActivePage);
  const selectedQueryId = useDynamicQueryStore(s => s.selectedQueryId);
  const editedSqlText = useDynamicQueryStore(s => s.editedSqlText);
  const parameterValues = useDynamicQueryStore(s => s.parameterValues);
  const setRoleSelection = useDynamicQueryStore(s => s.setRoleSelection);
  const initRoles = useDynamicQueryStore(s => s.initRoles);
  const roleSourceId = useDynamicQueryStore(s => s.roleSourceId);
  // View 탭 Columns/Condition CRUD — 공통 Insert/Delete 가 활성(클릭) 그리드 기준 라우팅 (hook #97).
  const [focusedViewGrid, setFocusedViewGrid] = useState<'columns' | 'parameters'>('columns');
  // SQL Query 편집 모달 (AS-IS 팝업 복원 — 2026-07-09): Insert(신규 자동 기동) / 더블클릭(수정).
  const [editModalOpen, setEditModalOpen] = useState(false);
  const [editTargetRow, setEditTargetRow] = useState<QueryRow | undefined>(undefined);
  // 모달 OK 메타 — Save 시 diff(I/M/D) 계산 후 저장 체인 (신규 = NEW_DQ_IDS 채번, AS-IS 정합).
  const pendingNewMetaRef = useRef<PendingQueryMeta | null>(null);
  const sessionUserId = useSessionStore(s => s.session.userId);

  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const queryClient = useQueryClient();

  // ui-dynamic-property-management §3 — Menu Button 동적 fetch (BTN_MPG + USER_GR 권한).
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const { data: resultData } = useTabProcQuery<MENU_ID, SHEETS.RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.RESULT,
    tabId,
    filters: filters[SHEETS.RESULT],
    // BTN_MPG_M(SYS0013, result, EXECUTE) → API_M(PKG_SYS0013.P_SYS0013_GET_DYNAMIC_QUERYS).
    procedureAction: 'EXECUTE' as BUTTON_TYPE,
    enabled: !!filters[SHEETS.RESULT],
  });

  const { data: columnsData } = useTabProcQuery<MENU_ID, SHEETS.COLUMNS>({
    menuId: MENU_ID,
    sheetName: SHEETS.COLUMNS,
    tabId,
    filters: filters[SHEETS.COLUMNS],
    enabled: !!filters[SHEETS.COLUMNS] && !!selectedQueryId,
  });

  const { data: parametersData } = useTabProcQuery<MENU_ID, SHEETS.PARAMETERS>({
    menuId: MENU_ID,
    sheetName: SHEETS.PARAMETERS,
    tabId,
    filters: filters[SHEETS.PARAMETERS],
    enabled: !!filters[SHEETS.PARAMETERS] && !!selectedQueryId,
  });

  const mainRows = useMemo(() => (mainData?.o_rc1 ?? []) as QueryRow[], [mainData]);
  const resultRows = useMemo(() => (resultData?.o_rc1 ?? []) as ResultRow[], [resultData]);
  const columnsRows = useMemo(() => (columnsData?.o_rc1 ?? []) as ColumnMetaRow[], [columnsData]);
  const parametersRows = useMemo(
    () => (parametersData?.o_rc1 ?? []) as ParameterMetaRow[],
    [parametersData]
  );

  const { handleSave } = useDynamicQuerySave({
    tabId,
    mainRows,
    columnsRows,
    parametersRows,
    pendingNewMetaRef,
  });

  useEffect(() => {
    if (!initialized) void fetchSearchConditions();
    void fetchStaticColumns();
    if (!filters[SHEETS.MAIN]) setFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearch = () => {
    setFilter();
    // master hook §2.4 — Search 시 admin SYS0004 메타 refetch.
    void fetchStaticColumns();
  };

  // Register Insert — AS-IS InsertRow L944-959 정합 (VALID_YN/ADMIN_ONLY_YN 'Y' 기본, DQ_ID 서버 채번).
  // 행 추가 직후 SQL Query 편집 모달 자동 기동 (AS-IS 신규 흐름 = Insert→편집 더블클릭→팝업의 축약).
  const handleInsert = () => {
    const grid = mainGridRef.current;
    if (!grid) return;
    GridAction.addRow(grid, {
      DQ_ID: '',
      DQ_NAME: '',
      DESCRIPTION: '',
      DQ_TEXT: '',
      DIVISION_ID: '-',
      VALID_YN: 'Y',
      ADMIN_ONLY_YN: 'Y',
      GROUP_ID: '',
      GROUP_NAME: '',
    });
    // addRow 는 선택행 위에 삽입 — 방금 추가된 미기입 신규(I) 행을 찾아 모달 대상 지정.
    const items = grid.collectionView.items;
    const newRow = items.find(r => r.CRUD_TYPE === 'I' && !r.DQ_ID && !r.DQ_NAME && !r.DQ_TEXT);
    if (newRow) {
      setEditTargetRow(newRow);
      setEditModalOpen(true);
    }
  };

  // 더블클릭(수정) → 모달 (AS-IS 편집모드 더블클릭=SQL Query 팝업 정합).
  const handleEditRow = (row: QueryRow) => {
    setEditTargetRow(row);
    setEditModalOpen(true);
  };

  // Register Delete — 확인 후 표준 removeRow (신규행 즉시 제거 / 기존행 'D' 마킹, 저장 시 확정).
  const handleDelete = () => {
    const grid = mainGridRef.current;
    if (!grid || !grid.selectedItems.length) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_삭제할 행을 선택하세요') });
      return;
    }
    void (async () => {
      const ok = await setAlert({
        type: 'confirm',
        // ⚠ MSG00012 는 '탭 10개 제한' 메시지 — 삭제 확인은 MSG00654 (2026-07-09 오인용 수정)
        content: t('MSG00654', '_선택한 행을 삭제하시겠습니까?'),
      });
      if (!ok) return;
      GridAction.removeRow(grid);
    })();
  };

  // View 공통 Insert/Delete — 활성(클릭) 그리드 라우팅.
  const handleViewInsert = () => {
    if (!selectedQueryId) {
      void setAlert({ type: 'alert', content: t('MSG00630', '_Query 를 선택하세요') });
      return;
    }
    if (focusedViewGrid === 'parameters') {
      if (!parametersGridRef.current) return;
      GridAction.addRow(parametersGridRef.current, {
        DQ_ID: Number(selectedQueryId),
        PARAMETER_ID: '',
        PARAMETER_TYPE: 'Parameter',
        OPERATION_ID: '-',
        VALID_YN: 'Y',
        REP_YN: 'N',
        SEQNO: '0',
        DEFAULT_VALUE: '',
      });
    } else {
      if (!columnsGridRef.current) return;
      GridAction.addRow(columnsGridRef.current, {
        DQ_ID: Number(selectedQueryId),
        COLUMN_NAME: '',
        VALUE_YN: 'Y',
        VALUE_TYPE: 'System.String',
        AGGREGATE: '',
        VALID_YN: 'Y',
        SEQNO: '0',
      });
    }
  };

  const handleViewDelete = () => {
    if (focusedViewGrid === 'parameters') {
      const grid = parametersGridRef.current;
      if (!grid || !grid.selectedItems.length) {
        void setAlert({ type: 'alert', content: t('MSG00014', '_삭제할 행을 선택하세요') });
        return;
      }
      GridAction.removeRow(grid);
    } else {
      const grid = columnsGridRef.current;
      if (!grid || !grid.selectedItems.length) {
        void setAlert({ type: 'alert', content: t('MSG00014', '_삭제할 행을 선택하세요') });
        return;
      }
      GridAction.removeRow(grid);
    }
  };

  const selectedRow = useMemo<QueryRow | undefined>(
    () => mainRows.find(r => String(r.DQ_ID) === String(selectedQueryId)),
    [mainRows, selectedQueryId]
  );

  // SQL 뷰어 표시용 — 선택 쿼리 DQ_TEXT 에 파라미터 값 치환한 최종 SQL.
  const baseSqlForViewer = useMemo(() => {
    if (!selectedRow?.DQ_TEXT) return '';
    return substituteParams(selectedRow.DQ_TEXT, parameterValues, parametersRows);
  }, [selectedRow, parameterValues, parametersRows]);

  // ── Execute + 실행이력 (격차② EXECUTE_HIST) ──────────────────────────────
  // AS-IS L517-539: 실행 시 PR_DM_ADM_DQ_EXECUTE_HIST 기록, 이력 실패는 침묵(try/catch{}).
  const pendingHistRef = useRef<{ dqId: string; sql: string } | null>(null);

  const handleExecute = () => {
    if (!selectedQueryId) {
      void setAlert({ type: 'alert', content: t('MSG00628', '_실행할 Query 를 선택하세요') });
      return;
    }
    const sqlSource = (editedSqlText && editedSqlText.trim()) || selectedRow?.DQ_TEXT || '';
    if (!sqlSource.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00628', '_실행할 Query 를 선택하세요') });
      return;
    }
    const sqlText = substituteParams(sqlSource, parameterValues, parametersRows);
    pendingHistRef.current = { dqId: selectedQueryId, sql: sqlText };
    setExecuteFilter(sqlText);
    void queryClient.invalidateQueries({ queryKey: [tabId, SHEETS.RESULT] });
    setToast({ type: 'success', message: t('MSG00629', '_실행 완료') });
  };

  useEffect(() => {
    const pending = pendingHistRef.current;
    if (!pending || !resultData) return;
    pendingHistRef.current = null;
    // fire-and-forget — 이력 실패가 실행 결과를 막지 않음 (AS-IS catch{} 침묵 정합).
    apiClient
      .post(`/${MENU_ID}/${SHEETS.HISTORY}/EXECUTE/call-proc`, {
        dqId: pending.dqId,
        dqText: pending.sql,
        updatedBy: sessionUserId ?? '',
      })
      .catch(() => undefined);
  }, [resultData, sessionUserId]);

  // Validate 성공 시 Columns/Condition 자동채움 — AS-IS Confirm 정합 (정의가 빈 경우에만).
  // 툴바 Validate 버튼과 편집 모달의 onValidated 가 공용.
  const applyValidationAutoFill = (cols: ValidateColumnRow[], sqlSource: string) => {
    const columnsGrid = columnsGridRef.current;
    if (columnsGrid && columnsRows.length === 0 && cols.length > 0 && selectedQueryId) {
      for (const [i, c] of cols.entries()) {
        GridAction.addRow(
          columnsGrid,
          {
            DQ_ID: Number(selectedQueryId),
            COLUMN_NAME: c.COLUMN_NAME,
            VALUE_YN: 'Y',
            VALUE_TYPE: c.VALUE_TYPE,
            AGGREGATE: '',
            VALID_YN: 'Y',
            SEQNO: String(i + 1),
          },
          'bottom'
        );
      }
    }
    const parametersGrid = parametersGridRef.current;
    const tokens = extractParamTokens(sqlSource);
    if (parametersGrid && parametersRows.length === 0 && tokens.length > 0 && selectedQueryId) {
      for (const [i, token] of tokens.entries()) {
        GridAction.addRow(
          parametersGrid,
          {
            DQ_ID: Number(selectedQueryId),
            PARAMETER_ID: token,
            PARAMETER_TYPE: 'Parameter',
            OPERATION_ID: '=',
            VALID_YN: 'Y',
            REP_YN: 'N',
            SEQNO: String(i + 1),
            DEFAULT_VALUE: '',
          },
          'bottom'
        );
      }
    }
  };

  // 편집 모달 OK — 대상 행 반영 + CRUD 마킹 + Column/Condition 최종 상태 보관 (AS-IS SetItem 정합).
  // 실제 저장(diff I/M/D → SP 체인)은 공통 Save 가 수행.
  const handleModalApply = (values: EditModalResult) => {
    const row = editTargetRow;
    if (!row) return;
    row.DQ_NAME = values.dqName;
    row.DESCRIPTION = values.description;
    row.DQ_TEXT = values.dqText;
    if (row.CRUD_TYPE !== 'I' && row.CRUD_TYPE !== 'D') row.CRUD_TYPE = 'M';
    mainGridRef.current?.invalidate();
    const isNew = row.CRUD_TYPE === 'I';
    pendingNewMetaRef.current = {
      row,
      roles: values.roles,
      colsFinal: values.colsFinal,
      condsFinal: values.condsFinal,
      colsOriginal: isNew
        ? []
        : columnsRows.map(c => ({
            COLUMN_NAME: String(c.COLUMN_NAME ?? ''),
            VALUE_TYPE: String(c.VALUE_TYPE ?? ''),
            VALID_YN: String(c.VALID_YN ?? 'Y'),
            SEQNO: String(c.SEQNO ?? '0'),
            AGGREGATE: String(c.AGGREGATE ?? ''),
          })),
      condsOriginal: isNew
        ? []
        : parametersRows.map(p => ({
            PARAMETER_TYPE: String(p.PARAMETER_TYPE ?? 'Parameter'),
            PARAMETER_ID: String(p.PARAMETER_ID ?? ''),
            VALID_YN: String(p.VALID_YN ?? 'Y'),
            SEQNO: String(p.SEQNO ?? '0'),
            OPERATION_ID: String(p.OPERATION_ID ?? '='),
            REP_YN: String(p.REP_YN ?? 'N'),
            DEFAULT_VALUE: String(p.DEFAULT_VALUE ?? ''),
          })),
    };
    // 기존 행 Role — diff 는 공통 Save(roleChanged 경로)가 처리.
    if (!isNew && row.DQ_ID) {
      const id = String(row.DQ_ID);
      if (roleSourceId !== id) {
        const original = String(row.GROUP_ID ?? '')
          .split(',')
          .map(s => s.trim())
          .filter(s => s !== '' && s !== 'ALL');
        initRoles(original, id);
      }
      setRoleSelection(values.roles);
    }
  };

  // ── Validate (격차① — AS-IS 팝업 Confirm 'TOP 0' 검증 + 컬럼/@PARAM 자동추출) ──
  const handleValidate = () => {
    const sqlSource = (editedSqlText && editedSqlText.trim()) || selectedRow?.DQ_TEXT || '';
    if (!sqlSource.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00628', '_실행할 Query 를 선택하세요') });
      return;
    }
    // PARSE 는 bind 미지원 — 토큰을 '' literal 로 사전 치환.
    const sqlText = substituteParams(sqlSource, parameterValues, parametersRows);
    void (async () => {
      try {
        const response = await apiClient.post<{ o_rc1: ValidateColumnRow[] }>(
          `/${MENU_ID}/${SHEETS.MAIN}/VALIDATE/call-proc`,
          { sqlText }
        );
        const cols = response.data.result?.o_rc1 ?? [];
        setToast({ type: 'success', message: t('MSG00655', '_Query 검증이 완료되었습니다.') });
        // AS-IS Confirm 정합 — 정의가 빈 경우에만 자동채움 (기존 정의 덮어쓰기 금지).
        applyValidationAutoFill(cols, sqlSource);
      } catch (err) {
        void setAlert({ type: 'alert', content: String((err as Error)?.message ?? err) });
      }
    })();
  };

  // hasButton 게이트 — Insert/Delete 는 Register=main / View=활성 그리드 라우팅 (hook #97).
  const isRegisterPage = activePage === SHEET_INDEX.REGISTER;
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? (isRegisterPage ? handleInsert : handleViewInsert) : false,
    delete: hasButton('DELETE') ? (isRegisterPage ? handleDelete : handleViewDelete) : false,
    condition: false,
    resetCondition: false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    ...(hasButton('VALIDATE') && !isRegisterPage
      ? [{ label: t('LBL00761', 'Validate'), action: handleValidate }]
      : []),
    ...(hasButton('EXECUTE') ? [{ label: t('LBL00729', 'Execute'), action: handleExecute }] : []),
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {isRegisterPage && openSearchArea && <DynamicQueryForm onSearch={handleSearch} />}

      <SubTitle
        menuId={MENU_ID}
        grid={
          isRegisterPage
            ? mainGridRef
            : focusedViewGrid === 'parameters'
              ? parametersGridRef
              : columnsGridRef
        }
        gridFilter={gridFilterRef}
        dataCount={
          isRegisterPage
            ? mainRows.length
            : focusedViewGrid === 'parameters'
              ? parametersRows.length
              : columnsRows.length
        }
        excelFileName='DynamicQuery'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />

      <TabWrapper
        persist
        activeTabIndex={activePage}
        setActiveTabIndex={i => setActivePage(i as SHEET_INDEX)}
      >
        {/* Register — Query 목록 (AS-IS tpRegister) */}
        <TabItem label={t('LBL00723', 'Register')}>
          <DynamicQueryMainGrid
            gridRef={mainGridRef}
            gridFilterRef={gridFilterRef}
            editTrackerRef={mainEditTrackerRef}
            data={mainRows}
            activePage={activePage}
            onEditRow={handleEditRow}
          />
        </TabItem>

        {/* View — Designer (AS-IS tpView: 좌 Columns/Condition/SQL + 우 Result) */}
        <TabItem label={t('LBL00724', 'View')}>
          <div className={styles.viewBody}>
            <DynamicQueryMetaForm selectedRow={selectedRow} />
            <PanelGroup className={styles.designerPanelGroup} orientation='horizontal'>
              <Panel defaultSize={55}>
                <div className={styles.leftPane}>
                  <div
                    className={`${styles.leftSection} ${styles.grow4}`}
                    onClickCapture={() => setFocusedViewGrid('columns')}
                  >
                    <TitleArea isSubTitle title={t('LBL00725', 'Columns')} depth='h4' />
                    <div className={styles.gridFill}>
                      <DynamicQueryColumnsGrid
                        gridRef={columnsGridRef}
                        editTrackerRef={columnsEditTrackerRef}
                        data={columnsRows}
                      />
                    </div>
                  </div>

                  <div
                    className={`${styles.leftSection} ${styles.grow2}`}
                    onClickCapture={() => setFocusedViewGrid('parameters')}
                  >
                    <TitleArea isSubTitle title={t('LBL00726', 'Condition')} depth='h4' />
                    <div className={styles.gridFill}>
                      <DynamicQueryParametersGrid
                        gridRef={parametersGridRef}
                        editTrackerRef={parametersEditTrackerRef}
                        data={parametersRows}
                      />
                    </div>
                  </div>

                  <div className={`${styles.leftSection} ${styles.grow4}`}>
                    <TitleArea isSubTitle title={t('LBL00727', 'SQL')} depth='h4' />
                    <div className={styles.gridFill}>
                      <DynamicQuerySQLViewer baseSql={baseSqlForViewer} />
                    </div>
                  </div>
                </div>
              </Panel>

              <PanelSeparator />

              <Panel defaultSize={45}>
                <div className={styles.rightPane}>
                  <TitleArea isSubTitle title={t('LBL00728', 'Result')} depth='h4' />
                  <DynamicQueryResultGrid
                    gridRef={resultGridRef}
                    data={resultRows}
                    columnsMeta={columnsRows}
                  />
                </div>
              </Panel>
            </PanelGroup>
          </div>
        </TabItem>
      </TabWrapper>

      {/* SQL Query 편집 모달 — AS-IS SCM0005_DynamicQueryListPopUp 디자인·기능 동일 (SYS0013_POPUP.png) */}
      <DynamicQueryEditModal
        open={editModalOpen}
        targetRow={editTargetRow}
        existingCols={columnsRows}
        existingConds={parametersRows}
        modalClose={() => setEditModalOpen(false)}
        onApply={handleModalApply}
      />
    </>
  );
};
