import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { DynamicQueryColumnsGrid } from './components/DynamicQueryColumnsGrid';
import { DynamicQueryForm } from './components/DynamicQueryForm';
import { DynamicQueryHistoryGrid } from './components/DynamicQueryHistoryGrid';
import { DynamicQueryMainGrid } from './components/DynamicQueryMainGrid';
import { DynamicQueryParametersGrid } from './components/DynamicQueryParametersGrid';
import { DynamicQueryResultGrid } from './components/DynamicQueryResultGrid';
import { DynamicQuerySQLViewer } from './components/DynamicQuerySQLViewer';
import { MENU_ID, SHEETS } from './dynamic-query.constants';
import type {
  ColumnMetaRow,
  HistoryRow,
  ParameterMetaRow,
  QueryRow,
  ResultRow,
} from './dynamic-query.types';
import { useDynamicQueryStore } from './useDynamicQueryStore';

export const DynamicQuery = ({ tabId, title }: PageProps<MENU_ID>) => {
  const mainGridRef = useRef<FlexGrid<QueryRow>>(null);
  const resultGridRef = useRef<FlexGrid<ResultRow>>(null);
  const columnsGridRef = useRef<FlexGrid<ColumnMetaRow>>(null);
  const parametersGridRef = useRef<FlexGrid<ParameterMetaRow>>(null);
  const historyGridRef = useRef<FlexGrid<HistoryRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const initialized = useDynamicQueryStore(s => s.initialized);
  const fetchSearchConditions = useDynamicQueryStore(s => s.fetchSearchConditions);
  const fetchStaticColumns = useDynamicQueryStore(s => s.fetchStaticColumns);
  const filters = useDynamicQueryStore(s => s.filters);
  const setFilter = useDynamicQueryStore(s => s.setFilter);
  const setExecuteFilter = useDynamicQueryStore(s => s.setExecuteFilter);
  const openSearchArea = useDynamicQueryStore(s => s.openSearchArea);
  const setOpenSearchArea = useDynamicQueryStore(s => s.setOpenSearchArea);
  const selectedQueryId = useDynamicQueryStore(s => s.selectedQueryId);
  const editedSqlText = useDynamicQueryStore(s => s.editedSqlText);
  const parameterValues = useDynamicQueryStore(s => s.parameterValues);
  const mainPendingChanges = useDynamicQueryStore(s => s.mainPendingChanges);
  const mainInsertedRows = useDynamicQueryStore(s => s.mainInsertedRows);
  const trackMainInsert = useDynamicQueryStore(s => s.trackMainInsert);
  const trackMainDelete = useDynamicQueryStore(s => s.trackMainDelete);
  const columnsPendingChanges = useDynamicQueryStore(s => s.columnsPendingChanges);
  const trackColumnsInsert = useDynamicQueryStore(s => s.trackColumnsInsert);
  const trackColumnsDelete = useDynamicQueryStore(s => s.trackColumnsDelete);
  const parametersPendingChanges = useDynamicQueryStore(s => s.parametersPendingChanges);
  const trackParametersInsert = useDynamicQueryStore(s => s.trackParametersInsert);
  const trackParametersDelete = useDynamicQueryStore(s => s.trackParametersDelete);
  const clearAllPending = useDynamicQueryStore(s => s.clearAllPending);
  const setSelectedQueryId = useDynamicQueryStore(s => s.setSelectedQueryId);

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

  const { data: historyData } = useTabProcQuery<MENU_ID, SHEETS.HISTORY>({
    menuId: MENU_ID,
    sheetName: SHEETS.HISTORY,
    tabId,
    filters: filters[SHEETS.HISTORY],
    enabled: !!filters[SHEETS.HISTORY] && !!selectedQueryId,
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
  // 하단 Columns/Parameters Tab 은 각자 자체 toolbar (Add/Delete 버튼).
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
    const totalDirty = mainDirty.length + columnsDirty.length + parametersDirty.length;
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
            const dqIdIsTemp =
              typeof dqIdRaw === 'string' && dqIdRaw.startsWith('TEMP_');
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

  // ui-dynamic-property-management §3.2 — hasButton 조건부 callback
  // admin SYS0009 의 USE_YN='N' / USER_GR 미부여 시 자동 숨김
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
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
  const historyRows = (historyData?.o_rc1 ?? []) as unknown as HistoryRow[];

  // Parameter VALUE → SQL literal 변환 (OPERATION_ID 별 분기).
  // AS-IS SCM0005_DynamicQueryList.cs L446-470 정합:
  //   =/>/< : 'value'
  //   IN    : ('v1', 'v2', ...)   (CSV split, AS-IS L454-463)
  //   LIKE  : '%value%'           (AS-IS 는 'value%' trailing only — NSCM 은 양쪽 % 적용 사용자 결정)
  //   기타   : 'value'
  // 미입력 = '' (AS-IS L687-688).
  const buildParamLiteral = (rawValue: string, operationId: string): string => {
    const v = String(rawValue ?? '').trim();
    if (!v) return '\'\'';
    const escape = (s: string) => s.replace(/'/g, '\'\'');
    const op = (operationId || '=').toUpperCase();
    if (op === 'LIKE') return `'%${escape(v)}%'`;
    if (op === 'IN') {
      const items = v
        .split(',')
        .map(x => x.trim())
        .filter(x => x !== '')
        .map(x => `'${escape(x)}'`)
        .join(', ');
      return items ? `(${items})` : '(\'\')';
    }
    return `'${escape(v)}'`;
  };

  // handleExecute — mainRows / parametersRows / buildParamLiteral 정의 뒤 위치
  //   (use-before-define lint 회피)
  const handleExecute = () => {
    if (!selectedQueryId) {
      void setAlert({ type: 'alert', content: t('MSG00628', '_실행할 Query 를 선택하세요') });
      return;
    }
    // AS-IS SCM0005_DynamicQueryList.cs L541 sFinalSql 를 SP 입력으로 전달 (P_SQL_TEXT IN VARCHAR2).
    // SP 가 OPEN O_RC1 FOR P_SQL_TEXT 로 동적 SELECT cursor 반환 → useTabProcQuery(RESULT) refetch.
    // SQL Tab 사용자 수정분 (editedSqlText) 가 mainRow.DQ_TEXT 보다 우선.
    const row = mainRows.find(r => String(r.DQ_ID) === String(selectedQueryId));
    let sqlText = (editedSqlText && editedSqlText.trim()) || row?.DQ_TEXT || '';
    if (!sqlText.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00628', '_실행할 Query 를 선택하세요') });
      return;
    }
    // AS-IS L687-690 정합 + OPERATION_ID 분기 (=/IN/LIKE/...).
    // 변환 룰 C8 가 본문 @PARAM* → :PARAM* 변환 → BE OPEN cursor 시 bind 인식 → ORA-01008.
    // 모든 토큰을 literal 로 사전 치환 의무.
    for (const [paramId, value] of Object.entries(parameterValues)) {
      const paramRow = parametersRows.find(r => String(r.PARAMETER_ID) === paramId);
      const literal = buildParamLiteral(value, paramRow?.OPERATION_ID ?? '=');
      const tokenAt = paramId.startsWith('@') ? paramId : `@${paramId}`;
      const tokenBind = paramId.startsWith(':') ? paramId : `:${paramId.replace(/^@/, '')}`;
      sqlText = sqlText.split(tokenAt).join(literal).split(tokenBind).join(literal);
    }
    sqlText = sqlText.replace(/[:@]PARAM[A-Z0-9_]*/gi, '\'\'');
    setExecuteFilter(sqlText);
    void queryClient.invalidateQueries({ queryKey: [tabId, SHEETS.RESULT] });
    setToast({ type: 'success', message: t('MSG00629', '_실행 완료') });
  };

  const customButtons = hasButton('EXECUTE')
    ? [{ label: t('LBL00649', 'Execute'), action: handleExecute }]
    : [];

  // SQL Tab 표시용 — 선택된 query 의 DQ_TEXT 에 parameter 값을 치환한 결과.
  // 사용자가 Parameters Tab 에서 입력한 VALUE 가 SQL 안 @PARAM*/:PARAM* 토큰을 치환하여
  // 최종 실행될 SQL 형태로 표시. 미입력 토큰 = '' fallback.
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
    sql = sql.replace(/[:@]PARAM[A-Z0-9_]*/gi, '\'\'');
    return sql;
  }, [selectedQueryId, mainRows, parameterValues, parametersRows]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <DynamicQueryForm onSearch={handleSearch} />}

      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={gridFilterRef}
        dataCount={mainRows.length}
        excelFileName='DynamicQuery'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />

      <DynamicQueryMainGrid gridRef={mainGridRef} gridFilterRef={gridFilterRef} data={mainRows} />

      <TabWrapper persist>
        <TabItem label={t('LBL00646', 'Columns')}>
          <DynamicQueryColumnsGrid gridRef={columnsGridRef} data={columnsRows} />
        </TabItem>
        <TabItem label={t('LBL00647', 'Parameters')}>
          <DynamicQueryParametersGrid gridRef={parametersGridRef} data={parametersRows} />
        </TabItem>
        <TabItem label={t('LBL00648', 'History')}>
          <DynamicQueryHistoryGrid gridRef={historyGridRef} data={historyRows} />
        </TabItem>
        <TabItem label={t('LBL00652', 'SQL')}>
          <DynamicQuerySQLViewer baseSql={baseSqlForViewer} />
        </TabItem>
        <TabItem label={t('LBL00645', 'Result')}>
          <DynamicQueryResultGrid
            gridRef={resultGridRef}
            data={resultRows}
            columnsMeta={columnsRows}
          />
        </TabItem>
      </TabWrapper>
    </>
  );
};
