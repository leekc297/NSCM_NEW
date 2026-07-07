/* eslint-disable quotes */
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DynamicQueryColumnsGrid } from './components/DynamicQueryColumnsGrid';
import { DynamicQueryForm } from './components/DynamicQueryForm';
import { DynamicQueryMainGrid } from './components/DynamicQueryMainGrid';
import { DynamicQueryMetaForm } from './components/DynamicQueryMetaForm';
import { DynamicQueryParametersGrid } from './components/DynamicQueryParametersGrid';
import { DynamicQueryResultGrid } from './components/DynamicQueryResultGrid';
import { DynamicQuerySQLViewer } from './components/DynamicQuerySQLViewer';
import { MENU_ID, SHEETS, SHEET_INDEX } from './dynamic-query.constants';
import type { ColumnMetaRow, ParameterMetaRow, QueryRow, ResultRow } from './dynamic-query.types';
import styles from './DynamicQuery.module.scss';
import { useDynamicQueryStore } from './useDynamicQueryStore';

export const DynamicQuery = ({ tabId, title }: PageProps<MENU_ID>) => {
  const mainGridRef = useRef<FlexGrid<QueryRow>>(null);
  const resultGridRef = useRef<FlexGrid<ResultRow>>(null);
  const columnsGridRef = useRef<FlexGrid<ColumnMetaRow>>(null);
  const parametersGridRef = useRef<FlexGrid<ParameterMetaRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

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
  const mainPendingChanges = useDynamicQueryStore(s => s.mainPendingChanges);
  const mainInsertedRows = useDynamicQueryStore(s => s.mainInsertedRows);
  const trackMainInsert = useDynamicQueryStore(s => s.trackMainInsert);
  const trackMainDelete = useDynamicQueryStore(s => s.trackMainDelete);
  const columnsPendingChanges = useDynamicQueryStore(s => s.columnsPendingChanges);
  const parametersPendingChanges = useDynamicQueryStore(s => s.parametersPendingChanges);
  const clearAllPending = useDynamicQueryStore(s => s.clearAllPending);
  const setSelectedQueryId = useDynamicQueryStore(s => s.setSelectedQueryId);
  // View 탭 Columns/Condition CRUD — 상단 공통 Insert/Delete 가 활성(클릭) 그리드 기준 라우팅.
  const trackColumnsInsert = useDynamicQueryStore(s => s.trackColumnsInsert);
  const trackColumnsDelete = useDynamicQueryStore(s => s.trackColumnsDelete);
  const trackParametersInsert = useDynamicQueryStore(s => s.trackParametersInsert);
  const trackParametersDelete = useDynamicQueryStore(s => s.trackParametersDelete);
  const roleSelection = useDynamicQueryStore(s => s.roleSelection);
  const roleOriginal = useDynamicQueryStore(s => s.roleOriginal);
  const [focusedViewGrid, setFocusedViewGrid] = useState<'columns' | 'parameters'>('columns');
  const sessionUserId = useSessionStore(s => s.session.userId);

  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const queryClient = useQueryClient();

  // ui-dynamic-property-management §3 — Menu Button 동적 fetch (admin USE_YN + USER_GR 권한)
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
    // BE callProc routing: BTN_MPG_M(SYS0013, result, EXECUTE) → API_M(API_URL=PKG_SYS0013.P_SYS0013_GET_DYNAMIC_QUERYS).
    procedureAction: 'EXECUTE' as never,
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

  useEffect(() => {
    if (!initialized) void fetchSearchConditions();
    void fetchStaticColumns();
    if (!filters[SHEETS.MAIN]) setFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearch = () => {
    setFilter();
    // ⭐ master hook §2.4 — Search 시 admin SYS0004 메타 refetch
    void fetchStaticColumns();
  };

  // SubTitle hotkey — Main grid 만 대상 (AS-IS BaseForm Insert/Delete/Save 정합).
  const handleInsert = () => {
    trackMainInsert({
      DIVISION_ID: '-',
      DQ_NAME: '',
      DESCRIPTION: '',
      DQ_TEXT: '',
      VALID_YN: 'Y',
      ADMIN_ONLY_YN: 'Y',
    });
  };

  const handleDelete = () => {
    if (!selectedQueryId) {
      void setAlert({ type: 'alert', content: t('MSG00630', '_Query 를 선택하세요') });
      return;
    }
    void (async () => {
      const ok = await setAlert({
        type: 'confirm',
        content: t('MSG00012', '_선택한 행을 삭제하시겠습니까?'),
      });
      if (!ok) return;
      trackMainDelete(String(selectedQueryId));
    })();
  };

  // View 탭 공통 Insert/Delete — 활성(클릭) 그리드(Columns / Condition) 기준 라우팅 (사용자 요구 2026-06-28).
  const handleViewInsert = () => {
    if (!selectedQueryId || selectedQueryId.startsWith('TEMP_')) {
      void setAlert({ type: 'alert', content: t('MSG00630', '_Query 를 선택하세요') });
      return;
    }
    if (focusedViewGrid === 'parameters') {
      trackParametersInsert(Number(selectedQueryId), {
        PARAMETER_TYPE: 'Parameter',
        OPERATION_ID: '-',
        VALID_YN: 'Y',
        REP_YN: 'N',
        SEQNO: '0',
      });
    } else {
      trackColumnsInsert(Number(selectedQueryId), {
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
      const sel = parametersGridRef.current?.selectedItems?.[0] as ParameterMetaRow | undefined;
      if (!sel?.PARAMETER_ID) {
        void setAlert({ type: 'alert', content: t('MSG00014', '_삭제할 행을 선택하세요') });
        return;
      }
      trackParametersDelete(String(sel.PARAMETER_ID));
    } else {
      const sel = columnsGridRef.current?.selectedItems?.[0] as ColumnMetaRow | undefined;
      if (!sel?.COLUMN_NAME) {
        void setAlert({ type: 'alert', content: t('MSG00014', '_삭제할 행을 선택하세요') });
        return;
      }
      trackColumnsDelete(String(sel.COLUMN_NAME));
    }
  };

  // unknown 값 안전 stringification — string/number/boolean/bigint 만 통과, 나머지는 default
  const safeStr = (v: unknown, def = ''): string => {
    if (typeof v === 'string') return v;
    if (typeof v === 'number' || typeof v === 'boolean' || typeof v === 'bigint') return String(v);
    return def;
  };

  const handleSave = () => {
    const mainDirty = Object.values(mainPendingChanges);
    const columnsDirty = Object.values(columnsPendingChanges);
    const parametersDirty = Object.values(parametersPendingChanges);
    // Role 변경 — 저장된 query(비-TEMP)에서만, 선택/원본 차이 존재 시.
    const roleChanged =
      !!selectedQueryId &&
      !selectedQueryId.startsWith('TEMP_') &&
      (roleSelection.length !== roleOriginal.length ||
        roleSelection.some(r => !roleOriginal.includes(r)));
    const totalDirty =
      mainDirty.length + columnsDirty.length + parametersDirty.length + (roleChanged ? 1 : 0);
    if (totalDirty === 0) {
      void setAlert({ type: 'alert', content: t('MSG00003', '_변경된 내용이 없습니다.') });
      return;
    }
    void (async () => {
      const ok = await setAlert({
        type: 'confirm',
        content: t('MSG00617', '_{0} 행을 저장하시겠습니까?').replace('{0}', String(totalDirty)),
      });
      if (!ok) return;
      try {
        // 1) Main (SCM_ADM_DQ_LIST) — TEMP_* 는 dqId 미전달 (SP MAX+1 자동).
        if (mainDirty.length > 0) {
          const mainPayload = mainDirty.map(c => {
            const r = c.row;
            const dqIdRaw = r.DQ_ID;
            const dqIdIsTemp = typeof dqIdRaw === 'string' && dqIdRaw.startsWith('TEMP_');
            return {
              crudType: c.crudType,
              dqId:
                c.crudType === 'I' || dqIdIsTemp
                  ? undefined
                  : typeof dqIdRaw === 'number'
                    ? dqIdRaw
                    : Number(dqIdRaw),
              divisionId: r.DIVISION_ID ?? '-',
              dqName: r.DQ_NAME ?? '',
              description: r.DESCRIPTION ?? '',
              dqText: r.DQ_TEXT ?? '',
              validYn: r.VALID_YN ?? 'Y',
              adminOnlyYn: r.ADMIN_ONLY_YN ?? 'N',
            };
          });
          await apiClient.post(`/${MENU_ID}/main/SAVE/call-proc`, {
            pData: JSON.stringify(mainPayload),
          });
        }
        // 2) Columns (SCM_ADM_DQ_COLUMN) — TEMP_C_* 는 사용자가 입력한 COLUMN_NAME 으로 INSERT.
        if (columnsDirty.length > 0) {
          const colPayload = columnsDirty.map(c => {
            const r = c.row;
            const colNameRaw = r.COLUMN_NAME;
            const colName =
              c.crudType === 'I' && typeof colNameRaw === 'string' && colNameRaw.startsWith('TEMP_')
                ? '' // TEMP placeholder — 사용자가 cellEditEnded 로 실제 이름 입력
                : safeStr(colNameRaw);
            return {
              crudType: c.crudType,
              dqId: Number(r.DQ_ID ?? 0),
              columnName: colName,
              valueYn: r.VALUE_YN ?? 'Y',
              valueType: r.VALUE_TYPE ?? 'System.String',
              aggregate: safeStr(r.AGGREGATE), // ATTRIBUTE2 영속화 (SUM/MAX/MIN/COUNT / 빈값=비집계)
              validYn: r.VALID_YN ?? 'Y',
              seqno: safeStr(r.SEQNO, '0'),
            };
          });
          await apiClient.post(`/${MENU_ID}/columns/SAVE/call-proc`, {
            pData: JSON.stringify(colPayload),
          });
        }
        // 3) Parameters (SCM_ADM_DQ_PARAMETER) — TEMP_P_* 는 사용자가 입력한 PARAMETER_ID 로 INSERT.
        if (parametersDirty.length > 0) {
          const paramPayload = parametersDirty.map(c => {
            const r = c.row;
            const paramIdRaw = r.PARAMETER_ID;
            const paramId =
              c.crudType === 'I' && typeof paramIdRaw === 'string' && paramIdRaw.startsWith('TEMP_')
                ? ''
                : safeStr(paramIdRaw);
            return {
              crudType: c.crudType,
              dqId: Number(r.DQ_ID ?? 0),
              parameterId: paramId,
              parameterType: r.PARAMETER_TYPE ?? 'Parameter',
              operationId: r.OPERATION_ID ?? '-',
              validYn: r.VALID_YN ?? 'Y',
              repYn: r.REP_YN ?? 'N',
              seqno: safeStr(r.SEQNO, '0'),
              defaultValue: r.DEFAULT_VALUE ?? null,
            };
          });
          await apiClient.post(`/${MENU_ID}/parameters/SAVE/call-proc`, {
            pData: JSON.stringify(paramPayload),
          });
        }
        // 4) Role (SCM_ADM_DQ_USER_GROUP) — diff 저장: 선택=Y / 해제=N (단건 SP 그룹별 호출).
        if (roleChanged) {
          const added = roleSelection.filter(r => !roleOriginal.includes(r));
          const removed = roleOriginal.filter(r => !roleSelection.includes(r));
          const roleCalls = [
            ...added.map(g => ({ groupId: g, validYn: 'Y' })),
            ...removed.map(g => ({ groupId: g, validYn: 'N' })),
          ];
          for (const rc of roleCalls) {
            await apiClient.post(`/${MENU_ID}/${SHEETS.USER_GROUP}/SAVE/call-proc`, {
              dqId: selectedQueryId,
              groupId: rc.groupId,
              validYn: rc.validYn,
              createdBy: sessionUserId ?? '',
              lastUpdatedBy: sessionUserId ?? '',
            });
          }
        }
        setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
        clearAllPending();
        setSelectedQueryId('');
        void queryClient.invalidateQueries({ queryKey: [tabId] });
      } catch (err) {
        void setAlert({
          type: 'alert',
          content: String((err as Error)?.message ?? err),
        });
      }
    })();
  };

  // ui-dynamic-property-management §3.2 — hasButton 조건부 callback.
  //   Insert/Delete 대상: Register=main grid / View=활성(클릭)한 Columns·Condition grid.
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

  // mainRows = fetched + 추가된 신규 row + pending 변경 반영 (마킹된 삭제 row 제외).
  const fetchedMainRows = (mainData?.o_rc1 ?? []) as unknown as QueryRow[];
  const mainRows = useMemo<QueryRow[]>(() => {
    const deletedIds = new Set(
      Object.entries(mainPendingChanges)
        .filter(([, c]) => c.crudType === 'D')
        .map(([id]) => id)
    );
    const visible = fetchedMainRows.filter(r => !deletedIds.has(String(r.DQ_ID)));
    return [...visible, ...(mainInsertedRows as unknown as QueryRow[])];
  }, [fetchedMainRows, mainInsertedRows, mainPendingChanges]);

  const resultRows = (resultData?.o_rc1 ?? []) as unknown as ResultRow[];
  const columnsRows = (columnsData?.o_rc1 ?? []) as unknown as ColumnMetaRow[];
  const parametersRows = (parametersData?.o_rc1 ?? []) as unknown as ParameterMetaRow[];

  const selectedRow = useMemo<QueryRow | undefined>(
    () => mainRows.find(r => String(r.DQ_ID) === String(selectedQueryId)),
    [mainRows, selectedQueryId]
  );

  // Parameter VALUE → SQL literal 변환 (OPERATION_ID 별 분기).
  // AS-IS SCM0005_DynamicQueryList.cs L446-470 정합:
  //   =/>/< : 'value' / IN : ('v1','v2',...) / LIKE : '%value%' / 미입력 = ''.
  const buildParamLiteral = (rawValue: string, operationId: string): string => {
    const v = String(rawValue ?? '').trim();
    if (!v) return "''";
    const escape = (s: string) => s.replace(/'/g, "''");
    const op = (operationId || '=').toUpperCase();
    if (op === 'LIKE') return `'%${escape(v)}%'`;
    if (op === 'IN') {
      const items = v
        .split(',')
        .map(x => x.trim())
        .filter(x => x !== '')
        .map(x => `'${escape(x)}'`)
        .join(', ');
      return items ? `(${items})` : "('')";
    }
    return `'${escape(v)}'`;
  };

  // handleExecute — mainRows / parametersRows / buildParamLiteral 정의 뒤 위치 (use-before-define 회피)
  const handleExecute = () => {
    if (!selectedQueryId) {
      void setAlert({ type: 'alert', content: t('MSG00628', '_실행할 Query 를 선택하세요') });
      return;
    }
    const row = mainRows.find(r => String(r.DQ_ID) === String(selectedQueryId));
    let sqlText = (editedSqlText && editedSqlText.trim()) || row?.DQ_TEXT || '';
    if (!sqlText.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00628', '_실행할 Query 를 선택하세요') });
      return;
    }
    // AS-IS L687-690 정합 + OPERATION_ID 분기. 모든 token 을 literal 로 사전 치환 (bind 인식 ORA-01008 회피).
    for (const [paramId, value] of Object.entries(parameterValues)) {
      const paramRow = parametersRows.find(r => String(r.PARAMETER_ID) === paramId);
      const literal = buildParamLiteral(value, paramRow?.OPERATION_ID ?? '=');
      const tokenAt = paramId.startsWith('@') ? paramId : `@${paramId}`;
      const tokenBind = paramId.startsWith(':') ? paramId : `:${paramId.replace(/^@/, '')}`;
      sqlText = sqlText.split(tokenAt).join(literal).split(tokenBind).join(literal);
    }
    sqlText = sqlText.replace(/[:@]PARAM[A-Z0-9_]*/gi, "''");
    setExecuteFilter(sqlText);
    void queryClient.invalidateQueries({ queryKey: [tabId, SHEETS.RESULT] });
    setToast({ type: 'success', message: t('MSG00629', '_실행 완료') });
  };

  const customButtons = hasButton('EXECUTE')
    ? [{ label: t('LBL00729', 'Execute'), action: handleExecute }]
    : [];

  // SQL Tab 표시용 — 선택된 query 의 DQ_TEXT 에 parameter 값을 치환한 최종 SQL.
  const baseSqlForViewer = useMemo(() => {
    if (!selectedQueryId) return '';
    const row = mainRows.find(r => String(r.DQ_ID) === String(selectedQueryId));
    let sql = row?.DQ_TEXT ?? '';
    if (!sql) return '';
    for (const [paramId, value] of Object.entries(parameterValues)) {
      const paramRow = parametersRows.find(r => String(r.PARAMETER_ID) === paramId);
      const literal = buildParamLiteral(value, paramRow?.OPERATION_ID ?? '=');
      const tokenAt = paramId.startsWith('@') ? paramId : `@${paramId}`;
      const tokenBind = paramId.startsWith(':') ? paramId : `:${paramId.replace(/^@/, '')}`;
      sql = sql.split(tokenAt).join(literal).split(tokenBind).join(literal);
    }
    sql = sql.replace(/[:@]PARAM[A-Z0-9_]*/gi, "''");
    return sql;
  }, [selectedQueryId, mainRows, parameterValues, parametersRows]);

  const isRegister = activePage === SHEET_INDEX.REGISTER;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {isRegister && openSearchArea && <DynamicQueryForm onSearch={handleSearch} />}

      <SubTitle
        menuId={MENU_ID}
        grid={
          isRegister
            ? mainGridRef
            : focusedViewGrid === 'parameters'
              ? parametersGridRef
              : columnsGridRef
        }
        gridFilter={gridFilterRef}
        dataCount={
          isRegister
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
        {/* TABPAGE1 — Register = Query List */}
        <TabItem label={t('LBL00723', 'Register')}>
          <DynamicQueryMainGrid
            gridRef={mainGridRef}
            gridFilterRef={gridFilterRef}
            data={mainRows}
            activePage={activePage}
            onEnterDesigner={() => setActivePage(SHEET_INDEX.DESIGNER)}
          />
        </TabItem>

        {/* TABPAGE2 — View = Designer (상단 메타폼 + 좌: 정의 / 우: 결과 미리보기) */}
        <TabItem label={t('LBL00724', 'View')}>
          <div className={styles.viewBody}>
            <DynamicQueryMetaForm selectedRow={selectedRow} />
            <PanelGroup className={styles.designerPanelGroup} orientation='horizontal'>
            <Panel defaultSize={55}>
              <div className={styles.leftPane}>
                {/* Columns : Condition : SQL = 4 : 2 : 4 (사용자 요구 2026-06-28) */}
                <div
                  className={`${styles.leftSection} ${styles.grow4}`}
                  onClickCapture={() => setFocusedViewGrid('columns')}
                >
                  <TitleArea isSubTitle title={t('LBL00725', 'Columns')} depth='h4' />
                  <div className={styles.gridFill}>
                    <DynamicQueryColumnsGrid gridRef={columnsGridRef} data={columnsRows} />
                  </div>
                </div>

                <div
                  className={`${styles.leftSection} ${styles.grow2}`}
                  onClickCapture={() => setFocusedViewGrid('parameters')}
                >
                  <TitleArea isSubTitle title={t('LBL00726', 'Condition')} depth='h4' />
                  <div className={styles.gridFill}>
                    <DynamicQueryParametersGrid gridRef={parametersGridRef} data={parametersRows} />
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
    </>
  );
};
