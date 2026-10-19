import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { PanelGroup, Panel, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { DynamicQueryColumnsGrid } from './components/DynamicQueryColumnsGrid';
import { DynamicQueryForm } from './components/DynamicQueryForm';
import { DynamicQueryMainGrid } from './components/DynamicQueryMainGrid';
import { DynamicQueryMetaForm } from './components/DynamicQueryMetaForm';
import { DynamicQueryParametersGrid } from './components/DynamicQueryParametersGrid';
import { DynamicQueryResultGrid } from './components/DynamicQueryResultGrid';
import { DynamicQuerySQLViewer } from './components/DynamicQuerySQLViewer';
import type { RESPONSE_SET } from './dynamic-query.constants';
import { MENU_ID, SHEET_INDEX, SHEETS } from './dynamic-query.constants';
import { replaceParamToken, toAtToken } from './dynamic-query.utils';
import styles from './DynamicQuery.module.scss';
import { useDynamicQueryStore, type ResultGridColumn } from './useDynamicQueryStore';

interface ParamAndValue {
  param: string;
  value: string;
  isUse: boolean;
  operation: string;
}

// 특정 리포트는 값이 비어있어도 실행이 되지만 결과가 무의미/과도한 범위 조회가 되므로, 해당 리포트에서는
// 지정된 Condition 값을 필수로 강제한다. 리포트명(DQ_NAME) 기준 매칭 (사용자 지정, 2026-09-16).
const REQUIRED_PARAMS_BY_REPORT: Record<string, string[]> = {
  'Sales Result Query Detail': ['PARAM_DIVSION_ID', 'PARAM_SALES_YYYYMM'],
  'MKT_FCST 수정이력 조회': ['PARAM_FROM_DATE', 'PARAM_DIVSION_ID'],
};

export const DynamicQuery = ({ tabId, title }: PageProps<MENU_ID>) => {
  // i18n
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);

  // 버튼 권한 조회
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // register 목록 그리드
  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  // veiw Tab 그리드
  const columnsGridRef = useRef<FlexGrid>();
  const parametersGridRef = useRef<FlexGrid>();
  const resultGridRef = useRef<FlexGrid>();

  // 검색 폼 오픈 여부 구분 값
  const openSearchArea = useDynamicQueryStore(s => s.openSearchArea);
  const setOpenSearchArea = useDynamicQueryStore(s => s.setOpenSearchArea);

  // 아래 Filter들은 조작함으로써 실질적으로 useTabProcQuery을 동작시킴
  const filters = useDynamicQueryStore(s => s.filters);
  const setFilter = useDynamicQueryStore(s => s.setFilter);

  // 그리드의 컬럼헤더 정보를 조회
  const fetchStaticColumns = useDynamicQueryStore(s => s.fetchStaticColumns);

  // 기본적인 화면 세팅이 끝났음을 알림.
  const initialized = useDynamicQueryStore(s => s.initialized);

  // 저장된 검색 조건를 조회
  const fetchSearchConditions = useDynamicQueryStore(s => s.fetchSearchConditions);

  // 활성화 된 탭
  const activePage = useDynamicQueryStore(s => s.activePage);
  const setActivePage = useDynamicQueryStore(s => s.setActivePage);

  // Register탭 내 그리드에서 View셀을 더블 클릭했을 때 선택된 정보
  const dynamicQueryMeta = useDynamicQueryStore(s => s.dynamicQueryMeta);

  // 쿼리 저장 스토어
  const sqlText = useDynamicQueryStore(s => s.sqlText);

  // 쿼리 결과 컬럼 세팅
  const setResultGridColumns = useDynamicQueryStore(s => s.setResultGridColumns);

  // 쿼리 실행을 위한 필터
  const setExecuteFilter = useDynamicQueryStore(s => s.setExecuteFilter);

  // 신규 데이터 삽입시 임시로 DQ_ID를 따기 위한 스토어 함수
  const getTempDqId = useDynamicQueryStore(s => s.getTempDqId);

  // 신규 or 수정 중인 컬럼 및 파라미터
  const saveColumnsAndParametersList = useDynamicQueryStore(s => s.saveColumnsAndParametersList);

  // 저장 성공 후 편집 세션 정리 (setFilter 를 거치지 않는 재조회 경로에서 stale 세션 방지)
  const clearSaveColumnsAndParametersList = useDynamicQueryStore(
    s => s.clearSaveColumnsAndParametersList
  );

  // 테스트
  // const setSaveColumnsAndParametersList = useDynamicQueryStore(
  //   s => s.setSaveColumnsAndParametersList
  // );

  // Register 탭 그리드 조회
  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // View 탭 Columns 그리드 조회
  const { data: columnsData } = useTabProcQuery<MENU_ID, SHEETS.COLUMNS>({
    menuId: MENU_ID,
    sheetName: SHEETS.COLUMNS,
    tabId,
    filters: filters[SHEETS.COLUMNS],
    enabled: !!filters[SHEETS.COLUMNS],
  });

  // View 탭 Condition 그리드 조회
  const { data: parametersData } = useTabProcQuery<MENU_ID, SHEETS.PARAMETERS>({
    menuId: MENU_ID,
    sheetName: SHEETS.PARAMETERS,
    tabId,
    filters: filters[SHEETS.PARAMETERS],
    enabled: !!filters[SHEETS.PARAMETERS],
  });

  const { data: resultData } = useTabProcQuery<MENU_ID, SHEETS.RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.RESULT,
    tabId,
    filters: filters[SHEETS.RESULT],
    // 'EXECUTE' 는 BUTTON_TYPE enum 에 없는 DB 전용 action (result 커서 실제 실행).
    //   기존 dynamic-query 화면과 동일하게 as never 로 전달한다.
    procedureAction: 'EXECUTE' as never,
    enabled: !!filters[SHEETS.RESULT],
  });

  const { mutateAsync: mutateMain } = useProcMutation<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const { mutate: mutateColumns } = useProcMutation<MENU_ID, SHEETS.COLUMNS, RESPONSE_SET.OUTPUT>({
    menuId: MENU_ID,
    sheetName: SHEETS.COLUMNS,
    tabId,
  });

  const { mutate: mutateParameters } = useProcMutation<
    MENU_ID,
    SHEETS.PARAMETERS,
    RESPONSE_SET.OUTPUT
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.PARAMETERS,
    tabId,
  });

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

  const excuteQuery = () => {
    if (!sqlText) {
      void setAlert({ type: 'alert', content: t('MSG00628', '_실행할 Query 를 선택하세요') });
      return;
    }

    let columns = [] as ResultGridColumn[];
    if (columnsGridRef.current) {
      columns = columnsGridRef.current.rows
        .toSorted((a, b) => {
          const aSeq =
            Number(
              (a.dataItem as ResponseData<MENU_ID, SHEETS.COLUMNS, RESPONSE_SET.OUTPUT>).SEQNO
            ) || 0;
          const bSeq =
            Number(
              (b.dataItem as ResponseData<MENU_ID, SHEETS.COLUMNS, RESPONSE_SET.OUTPUT>).SEQNO
            ) || 0;

          return aSeq - bSeq;
        })
        .filter(
          item =>
            (item.dataItem as ResponseData<MENU_ID, SHEETS.COLUMNS, RESPONSE_SET.OUTPUT>)
              .VALUE_YN === 'Y'
        )
        .map(item => {
          const data = item.dataItem as ResponseData<MENU_ID, SHEETS.COLUMNS, RESPONSE_SET.OUTPUT>;

          return { name: data.COLUMN_NAME, valueType: data.VALUE_TYPE };
        });
    }

    setResultGridColumns(columns);

    let parameters = [] as ParamAndValue[];
    if (parametersGridRef.current) {
      parameters = parametersGridRef.current.rows.map(item => {
        const data = item.dataItem as ResponseData<MENU_ID, SHEETS.PARAMETERS, RESPONSE_SET.OUTPUT>;

        return {
          param: data.PARAMETER_ID,
          value: data.VALUE ?? '',
          isUse: data.VALID_YN === 'Y',
          operation: data.OPERATION_ID ?? '=',
        };
      });
    }

    // 리포트별 필수 Condition 값 체크 — REQUIRED_PARAMS_BY_REPORT 에 등록된 리포트만 대상.
    const requiredParams = REQUIRED_PARAMS_BY_REPORT[(dynamicQueryMeta?.reportName ?? '').trim()];
    if (requiredParams) {
      const normalize = (id: string) => id.replace(/^[@:]/, '').toUpperCase();
      const valueByParam = new Map(
        parameters.map(item => [normalize(item.param), item.value.trim()])
      );
      const missing = requiredParams.filter(name => !valueByParam.get(name.toUpperCase()));

      if (missing.length > 0) {
        void setAlert({
          type: 'alert',
          content: t(
            'MSG00150',
            `${missing.map(name => `@${name}`).join(', ')} 는 필수값이니 값을 입력하세요.`
          ),
        });
        return;
      }
    }

    // USE(VALID_YN='Y') 인 Condition 만 값이 필수 — 하나라도 비어있으면 실행 차단.
    // const missingValue = parameters.some(item => item.isUse && !item.value.trim());
    // if (missingValue) {
    //   void setAlert({ type: 'alert', content: t('MSG00150', 'CONDITION에 해당하는 VALUE를 입력해 주세요.') });
    //   return;
    // }

    let sql = sqlText;
    for (const item of parameters) {
      const param = item.param.replace('@', '').replace(':', '');
      const value = buildParamLiteral(item.value, item.isUse ? item.operation : '');
      sql = replaceParamToken(sql, param, value);
    }

    // const leftover = findParamTokens(sql);
    // if (leftover.length > 0) {
    //   void setAlert({
    //     type: 'alert',
    //     content: t(
    //       'MSG00631',
    //       `_정의되지 않은 파라미터가 있습니다: ${leftover
    //         .map(n => `@${n}`)
    //         .join(', ')} — Condition 에 추가하세요.`
    //     ),
    //   });
    //   return;
    // }

    setExecuteFilter(sql);
    void queryClient.invalidateQueries({ queryKey: [tabId, SHEETS.RESULT] });
  };

  const customButtons =
    hasButton('EXECUTE') && activePage === SHEET_INDEX.DESIGNER
      ? [{ label: t('LBL00649', 'Execute'), action: excuteQuery }]
      : [];

  const handleSearch = () => {
    setFilter();
  };

  const handleInsert = () => {
    if (!gridRef.current) return;

    GridAction.addRow(gridRef.current, {
      DQ_ID: getTempDqId(), // 컬럼과 파라미터를 매칭하기 위한 유니크한 임시값
      DQ_NAME: '',
      DESCRIPTION: '',
      GROUP_NAME: 'ALL',
      VALID_YN: 'Y',
      DQ_TEXT: '',
    });
  };

  const handleDelete = () => {
    if (!gridRef.current) return;

    const row = GridUtils.getSelectedRows(gridRef.current);
    if (!row) {
      void setAlert({ type: 'alert', content: t('MSG00630', '_Query 를 선택하세요') });
      return;
    }

    GridAction.removeRow(gridRef.current);
  };

  const handleSave = () => {
    console.log(gridRef.current);
    if (gridRef.current && gridRef.current?.rows.length > 0) {
      // 신규 or 수정한 건들 중에 필수 값들이 비어있는건 아니지 체크
      console.warn(
        '[MAIN SAVE go-check] rows=',
        gridRef.current?.rows.map(r => {
          const d = r.dataItem as ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>;
          return {
            CRUD_TYPE: d?.CRUD_TYPE,
            DQ_ID: d?.DQ_ID,
            DQ_NAME: d?.DQ_NAME,
            DESCRIPTION: d?.DESCRIPTION,
            DQ_TEXT: d?.DQ_TEXT,
          };
        })
      );
      const go = gridRef.current?.rows.some(item => {
        const data = item.dataItem as ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>;
        return (
          (data.CRUD_TYPE === 'I' || data.CRUD_TYPE === 'M') &&
          (!data.DQ_NAME ||
            data.DQ_NAME === '' ||
            !data.DESCRIPTION ||
            data.DESCRIPTION === '' ||
            !data.DQ_TEXT ||
            data.DQ_TEXT === '')
        );
      });

      if (go) {
        void setAlert({ type: 'alert', content: t('MSG00150', '_필수값을 입력하세요.') });
        return;
      }

      // SCM_ADM_DQ_LIST 테이블 내용에 해당하는 Regist그리드의신규, 수정, 삭제 대상이 되는 데이터들 저장용
      const insertMainList = [] as ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>[];
      const updateMainList = [] as ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>[];
      const deleteMainList = [] as ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>[];

      // Regist그리드의 신규 건에 속해 있는 데이터를 Insert 하고 리턴 받은 DQ_ID를 columns와 paremers에 세팅하기 위한 분별용
      const mainList = [] as ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>[];

      gridRef.current?.rows.forEach(item => {
        const data = item.dataItem as ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>;
        if (data.CRUD_TYPE === 'I') {
          insertMainList.push({
            CRUD_TYPE: 'I',
            DQ_ID: undefined,
            DIVISION_ID: '40', // 세션에서 현재 DIVISION 가져올 수 있는 공통 처리 필요.
            DQ_NAME: data.DQ_NAME,
            DESCRIPTION: data.DESCRIPTION,
            DQ_TEXT: data.DQ_TEXT,
            VALID_YN: data.VALID_YN,
            ADMIN_ONLY_YN: data.ADMIN_ONLY_YN ?? 'N',
            GROUP_NAME: data.GROUP_NAME,
          });
          mainList.push(data);
        } else if (data.CRUD_TYPE === 'M') {
          updateMainList.push({
            CRUD_TYPE: 'M',
            DQ_ID: Number(data.DQ_ID),
            DIVISION_ID: '40', // 세션에서 현재 DIVISION 가져올 수 있는 공통 처리 필요.
            DQ_NAME: data.DQ_NAME,
            DESCRIPTION: data.DESCRIPTION,
            DQ_TEXT: data.DQ_TEXT,
            VALID_YN: data.VALID_YN,
            ADMIN_ONLY_YN: data.ADMIN_ONLY_YN ?? 'N',
            GROUP_NAME: data.GROUP_NAME,
          });
        } else if (data.CRUD_TYPE === 'D') {
          deleteMainList.push({
            CRUD_TYPE: 'D',
            DQ_ID: Number(data.DQ_ID),
            DIVISION_ID: '40', // 세션에서 현재 DIVISION 가져올 수 있는 공통 처리 필요.
            DQ_NAME: data.DQ_NAME,
            DESCRIPTION: data.DESCRIPTION,
            DQ_TEXT: data.DQ_TEXT,
            VALID_YN: data.VALID_YN,
            ADMIN_ONLY_YN: data.ADMIN_ONLY_YN ?? 'N',
            GROUP_NAME: data.GROUP_NAME,
          });
        }
      });

      const saveList = [...insertMainList, ...updateMainList, ...deleteMainList];

      console.log(
        '[MAIN SAVE] rows=',
        gridRef.current?.rows.map(r => {
          const d = r.dataItem as ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>;
          return { CRUD_TYPE: d?.CRUD_TYPE, DQ_ID: d?.DQ_ID, DQ_NAME: d?.DQ_NAME };
        }),
        'insert=',
        insertMainList.length,
        'update=',
        updateMainList.length,
        'delete=',
        deleteMainList.length
      );

      if (saveList.length === 0) {
        void setAlert({ type: 'alert', content: t('MSG00003', '_변경된 내용이 없습니다.') });
        return;
      }

      void (async () => {
        const ok = await setAlert({
          type: 'confirm',
          content: t('MSG00617', `${saveList.length} 행을 저장하시겠습니까?`).replace(
            '{0}',
            `${saveList.length}`
          ),
        });

        if (!ok) return;
        console.log(saveList);

        // PKG_SYS0013.P_SYS0013_SAVE_QUERY_LIST 프로시저 내에서 삭제(CRUD_TYPE = D) 건은 COLUMNS와 PARAMETERS도 같이 삭제되도록 처리함.
        const result = await mutateMain(saveList);

        const saveCloumns = [] as ResponseData<MENU_ID, SHEETS.COLUMNS, RESPONSE_SET.OUTPUT>[];
        const saveParameters = [] as ResponseData<
          MENU_ID,
          SHEETS.PARAMETERS,
          RESPONSE_SET.OUTPUT
        >[];

        // 신규 건만!!
        if (result.result) {
          // 응답 타입이 mutaion은 어떤 타입인지 알수가 없다.
          const res = result.result as unknown as { o_rc2: { DQ_ID: number }[] };
          if (res.o_rc2.length > 0) {
            const dqObjList = res.o_rc2;

            for (const [i, dqObj] of dqObjList.entries()) {
              const newParent = mainList[i];
              if (!newParent) continue;
              // 임시 DQ_ID가 동일한지 확인
              saveColumnsAndParametersList.forEach(item => {
                if (item.DQ_ID === newParent.DQ_ID) {
                  item.columns.forEach(col => {
                    saveCloumns.push({
                      SEQNO: col.SEQNO,
                      COLUMN_NAME: col.COLUMN_NAME,
                      VALID_YN: col.VALID_YN,
                      DQ_ID: dqObj.DQ_ID,
                      VALUE_YN: col.VALUE_YN,
                      VALUE_TYPE: col.VALUE_TYPE,
                      CRUD_TYPE: 'I',
                      AGGREGATE: col.AGGREGATE,
                    });
                  });

                  item.parameters.forEach(params => {
                    saveParameters.push({
                      DQ_ID: dqObj.DQ_ID,
                      PARAMETER_ID: toAtToken(params.PARAMETER_ID),
                      PARAMETER_TYPE: params.PARAMETER_TYPE,
                      OPERATION_ID: params.OPERATION_ID,
                      VALID_YN: params.VALID_YN,
                      REP_YN: params.REP_YN,
                      SEQNO: params.SEQNO,
                      CRUD_TYPE: 'I',
                    });
                  });
                }
              });
            }
          }
        }

        // 변경 건만!!
        saveColumnsAndParametersList.forEach(item => {
          if (item.CRUD_TYPE === 'M') {
            item.columns.forEach(col => {
              saveCloumns.push({
                SEQNO: col.SEQNO,
                COLUMN_NAME: col.COLUMN_NAME,
                VALID_YN: col.VALID_YN,
                DQ_ID: Number(item.DQ_ID),
                VALUE_YN: col.VALUE_YN,
                VALUE_TYPE: col.VALUE_TYPE,
                CRUD_TYPE: col.CRUD_TYPE,
                AGGREGATE: col.AGGREGATE,
              });
            });

            item.parameters.forEach(params => {
              saveParameters.push({
                DQ_ID: Number(item.DQ_ID),
                PARAMETER_ID: toAtToken(params.PARAMETER_ID),
                PARAMETER_TYPE: params.PARAMETER_TYPE,
                OPERATION_ID: params.OPERATION_ID,
                VALID_YN: params.VALID_YN,
                REP_YN: params.REP_YN,
                SEQNO: params.SEQNO,
                CRUD_TYPE: params.CRUD_TYPE,
              });
            });
          }
        });

        // eslint-disable-next-line no-console
        console.log(
          '[CHILD SAVE] session=',
          saveColumnsAndParametersList.map(s => ({
            DQ_ID: s.DQ_ID,
            CRUD_TYPE: s.CRUD_TYPE,
            cols: s.columns.map(c => c.CRUD_TYPE),
            params: s.parameters.map(p => p.CRUD_TYPE),
          })),
          'saveCloumns=',
          saveCloumns.length,
          saveCloumns.map(c => ({ DQ_ID: c.DQ_ID, COL: c.COLUMN_NAME, CRUD: c.CRUD_TYPE })),
          'saveParameters=',
          saveParameters.length,
          saveParameters.map(p => ({ DQ_ID: p.DQ_ID, PID: p.PARAMETER_ID, CRUD: p.CRUD_TYPE }))
        );

        if (saveCloumns.length > 0) mutateColumns(saveCloumns);
        if (saveParameters.length > 0) mutateParameters(saveParameters);

        clearSaveColumnsAndParametersList();
      })();
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') && activePage === SHEET_INDEX.REGISTER ? handleSearch : false,
    save: hasButton('SAVE') && activePage === SHEET_INDEX.REGISTER ? handleSave : false,
    insert: hasButton('INSERT') && activePage === SHEET_INDEX.REGISTER ? handleInsert : false,
    delete: hasButton('DELETE') && activePage === SHEET_INDEX.REGISTER ? handleDelete : false,
    condition: false,
    resetCondition: false,
    manual: false,
    upload: false,
  };

  // 실제 조회된 데이터 갯수만!
  const getCount = () => {
    return (mainData?.o_rc1 ?? []).length;
  };

  // 초기 렌더링
  useEffect(() => {
    if (!initialized) void fetchSearchConditions();
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // View 탭 3 그리드(Columns/Condition/Result) 건수 — 각 영역 제목 줄에 따로 표시한다.
  const columnsCount = columnsData?.o_rc1?.length ?? 0;
  const parametersCount = parametersData?.o_rc1?.length ?? 0;
  const resultCount = resultData?.o_rc1?.length ?? 0;

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
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={getCount()}
        // Register 탭은 상단 건수가 곧 이 그리드 건수라 그대로 두고, View 탭(Columns/Condition/
        // Result 4 그리드 동시 표시)에서는 Register 건수와 무관해지므로 숨기고 각 영역에서 표시한다.
        hideTotalCases={activePage !== SHEET_INDEX.REGISTER}
        excelFileName='DynamicQuery'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />

      <TabWrapper persist activeTabIndex={activePage} setActiveTabIndex={i => setActivePage(i)}>
        <TabItem label={t('LBL00723', 'Register')}>
          <DynamicQueryMainGrid
            gridRef={gridRef}
            gridFilterRef={gridFilterRef}
            data={mainData?.o_rc1 ?? []}
            goViewTab={() => setActivePage(SHEET_INDEX.DESIGNER)}
            tabId={tabId}
          />
        </TabItem>
        <TabItem label={t('LBL00724', 'View')}>
          <div className={styles.viewBody}>
            <DynamicQueryMetaForm dynamicQueryMeta={dynamicQueryMeta} />
            <PanelGroup className={styles.designerPanelGroup} orientation='horizontal'>
              <Panel defaultSize={55}>
                <PanelGroup className={styles.leftPane} orientation='vertical'>
                  <Panel defaultSize={40} minSize={15} style={{ overflow: 'hidden' }}>
                    <div className={styles.leftSection}>
                      <TitleArea
                        isSubTitle
                        title={t('LBL00646', 'Columns')}
                        depth='h4'
                        totalCases={columnsCount === 0 ? undefined : columnsCount}
                      />
                      {/* <div className={styles.gridFill}> */}
                      <DynamicQueryColumnsGrid
                        gridRef={columnsGridRef}
                        data={columnsData?.o_rc1 ?? []}
                      />
                      {/* </div> */}
                    </div>
                  </Panel>

                  <PanelSeparator className={styles.rowSplitBar} />

                  <Panel defaultSize={20} minSize={10} style={{ overflow: 'hidden' }}>
                    <div className={styles.leftSection}>
                      <TitleArea
                        isSubTitle
                        title={t('LBL00726', 'Condition')}
                        depth='h4'
                        totalCases={parametersCount === 0 ? undefined : parametersCount}
                      />
                      {/* <div className={styles.gridFill}> */}
                      <DynamicQueryParametersGrid
                        gridRef={parametersGridRef}
                        data={parametersData?.o_rc1 ?? []}
                      />
                      {/* </div> */}
                    </div>
                  </Panel>

                  <PanelSeparator className={styles.rowSplitBar} />

                  <Panel defaultSize={40} minSize={15} style={{ overflow: 'hidden' }}>
                    <div className={styles.leftSection}>
                      <TitleArea isSubTitle title={t('LBL00652', 'SQL')} depth='h4' />
                      {/* <div className={styles.gridFill}> */}
                      <DynamicQuerySQLViewer />
                      {/* </div>   */}
                    </div>
                  </Panel>
                </PanelGroup>
              </Panel>

              <PanelSeparator />

              <Panel defaultSize={45}>
                <div className={styles.rightPane}>
                  <TitleArea
                    isSubTitle
                    title={t('LBL00645', 'Result')}
                    depth='h4'
                    totalCases={resultCount === 0 ? undefined : resultCount}
                  />
                  <DynamicQueryResultGrid gridRef={resultGridRef} data={resultData?.o_rc1 ?? []} />
                </div>
              </Panel>
            </PanelGroup>
          </div>
        </TabItem>
      </TabWrapper>
    </>
  );
};
