import {
  OtherIdeaIcon,
  ControlAddIcon,
  EditDeleteIcon,
  ControlConfirmIcon,
} from '@lges/design-system/icon';
import { type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_MSG } from '@foundation/constants';
import { GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, TitleArea } from '@shared/lges';
import { Grid } from '@shared/mui';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import type { RESPONSE_SET } from '../dynamic-query.constants';
import { MENU_ID, SHEETS } from '../dynamic-query.constants';
import type { Columns, Parameters } from '../dynamic-query.types';
import {
  findParamTokens,
  reconcileColumns,
  reconcileParameters,
  toAtToken,
} from '../dynamic-query.utils';
import styles from '../DynamicQuery.module.scss';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

import { DynamicQueryModalColumnsGrid } from './DynamicQueryModalColumnsGrid';
import { DynamicQueryModalParametersGrid } from './DynamicQueryModalParametersGrid';

interface DynamicQueryModalProps {
  open: boolean;
  modalClose: () => void;
  initialRow?: ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>;
  tabId: string;
  onSaved?: () => void;
}

const extractTopSelectList = (sql: string): string | null => {
  const noParam = sql.replace(/[@:]\w+/g, 'NULL');
  const selMatch = /\bselect\b/i.exec(noParam);
  if (!selMatch) return null;
  const afterSelect = noParam.slice(selMatch.index + selMatch[0].length);

  let depth = 0;
  let end = -1;
  for (let i = 0; i < afterSelect.length; i++) {
    const ch = afterSelect[i];
    if (ch === '(') depth++;
    else if (ch === ')') depth--;
    else if (
      depth === 0 &&
      /\bfrom\b/i.test(afterSelect.slice(i, i + 4)) &&
      /\W/.test(afterSelect[i + 4] ?? ' ') &&
      (i === 0 || /\W/.test(afterSelect[i - 1]))
    ) {
      end = i;
      break;
    }
  }
  const selectList = end >= 0 ? afterSelect.slice(0, end) : afterSelect;
  return selectList.replace(/^\s*(distinct|all)\b/i, '');
};

const selectHasStar = (sql: string): boolean => {
  const body = extractTopSelectList(sql);
  return body !== null && /(^|,)\s*(\w+\s*\.\s*)?\*/.test(body);
};

const parseSelectColumnOrder = (sql: string): string[] => {
  const body = extractTopSelectList(sql);
  if (body === null) return [];

  // depth 0 콤마로 분리
  const items: string[] = [];
  let cur = '';
  let depth = 0;
  for (const ch of body) {
    if (ch === '(') depth++;
    else if (ch === ')') depth--;
    if (ch === ',' && depth === 0) {
      items.push(cur);
      cur = '';
    } else {
      cur += ch;
    }
  }
  if (cur.trim()) items.push(cur);

  return items.map(raw => {
    const item = raw.trim().replace(/\s+/g, ' ');
    if (!item || item === '*') return ''; // SELECT * / 빈 항목 → 매칭 불가
    // 'expr AS alias' 또는 'expr alias' → 마지막 토큰이 alias
    const asMatch = /\s+as\s+("[^"]+"|\w+)\s*$/i.exec(item);
    if (asMatch) return asMatch[1].replace(/"/g, '');
    // 함수/표현식(괄호·연산자 포함) 뒤 공백 alias
    const spaceAlias = /^(.+?)\s+("[^"]+"|\w+)$/.exec(item);
    if (spaceAlias) {
      const head = spaceAlias[1];
      // head 가 단순 식별자('a' / 'a.b') 가 아니면(=표현식) 뒤 토큰이 alias
      if (/[()+\-*/|]/.test(head) || /\s/.test(head.trim())) {
        return spaceAlias[2].replace(/"/g, '');
      }
    }
    // 'a.b.c' → 마지막 세그먼트, 단순 컬럼 → 그대로
    const seg = item.replace(/"/g, '').split('.');
    const last = seg[seg.length - 1];
    // 순수 식별자만 컬럼으로 인정 (표현식은 alias 없으면 매칭 불가)
    return /^\w+$/.test(last) ? last : '';
  });
};

const orderColumnsBySelect = <T extends { name: string }>(cols: T[], sql: string): T[] => {
  if (selectHasStar(sql)) return cols; // SELECT * → 테이블 정의 순서(cursor) 그대로
  const selectOrder = parseSelectColumnOrder(sql).filter(Boolean);
  if (selectOrder.length === 0) return cols; // 파싱 실패 → 원래 순서 유지 (안전)

  const byUpper = new Map(cols.map(c => [c.name.toUpperCase(), c]));
  const used = new Set<string>();
  const ordered: T[] = [];
  for (const name of selectOrder) {
    const key = name.toUpperCase();
    const hit = byUpper.get(key);
    if (hit && !used.has(key)) {
      ordered.push(hit);
      used.add(key);
    }
  }
  const rest = cols.filter(c => !used.has(c.name.toUpperCase()));
  return [...ordered, ...rest];
};

interface BeColumnMeta {
  name: string;
  type: string;
}

interface ValidatedColumn {
  name: string;
  type: string;
}

export const DynamicQueryModal = ({
  open,
  modalClose,
  initialRow,
  tabId,
  onSaved,
}: DynamicQueryModalProps) => {
  const { t } = useTranslation();

  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);

  const setSaveColumnsAndParametersList = useDynamicQueryStore(
    s => s.setSaveColumnsAndParametersList
  );
  const getSaveColumnsAndParametersList = useDynamicQueryStore(
    s => s.getSaveColumnsAndParametersList
  );

  const [group] = useTabComboQueries({ filters: ['UserGroup'] });
  const roleOptions = group?.map(item => ({ label: item.NAME, value: item.NAME })) ?? [];

  const [reportNm, setReportNm] = useState<string>('');
  const [description, setDescription] = useState<string>('');
  const [role, setRole] = useState<string>('');

  const [sqlText, setSqlText] = useState<string>('');
  const columnsGridRef = useRef<FlexGrid<Columns>>(null);
  const [columnsRows, setColumnsRows] = useState<Columns[]>([]);
  const parameterGridRef = useRef<FlexGrid<Parameters>>(null);
  const [parameterRows, setParameterRows] = useState<Parameters[]>([]);

  const [dqId, setDqId] = useState<string | number>('');

  const [validating, setValidating] = useState<boolean>(false);

  // 기존 저장 row 를 세션 편집분 없이 열었을 때만 값이 세팅된다(= DQ_ID 로 SP 조회 대상).
  //   신규(I) row / 세션에 편집분이 있는 row 는 undefined → 조회 훅 비활성.
  const [apiFetchDqId, setApiFetchDqId] = useState<number | undefined>(undefined);

  const popupFetchFilters = useMemo(
    () => (apiFetchDqId ? { dqId: apiFetchDqId } : undefined),
    [apiFetchDqId]
  );

  // 기존 저장 row 의 Columns 그리드 조회 (view 탭과 동일한 COLUMNS SP, DQ_ID 로).
  const { data: popupColumnsData } = useTabProcQuery<MENU_ID, SHEETS.COLUMNS>({
    menuId: MENU_ID,
    sheetName: SHEETS.COLUMNS,
    tabId,
    filters: popupFetchFilters,
    enabled: open && apiFetchDqId !== undefined,
  });

  // 기존 저장 row 의 Condition/Parameters 그리드 조회 (view 탭과 동일한 PARAMETERS SP, DQ_ID 로).
  const { data: popupParametersData } = useTabProcQuery<MENU_ID, SHEETS.PARAMETERS>({
    menuId: MENU_ID,
    sheetName: SHEETS.PARAMETERS,
    tabId,
    filters: popupFetchFilters,
    enabled: open && apiFetchDqId !== undefined,
  });

  useEffect(() => {
    if (!open) {
      setReportNm('');
      setDescription('');
      setRole('');
      setSqlText('');
      setDqId('');
      setColumnsRows([]);
      setParameterRows([]);
      setApiFetchDqId(undefined);
      return;
    }
    setReportNm(initialRow?.DQ_NAME ?? '');
    setDescription(initialRow?.DESCRIPTION ?? '');

    setRole(initialRow?.GROUP_NAME ?? '');
    setSqlText(initialRow?.DQ_TEXT ?? '');
    setDqId(initialRow?.DQ_ID ?? '');

    // 팝업 오픈 시 columns/parameters 출처 판정.
    //   AS-IS SCM0005 FindData: 세션(POPUPFLAG) 있으면 메모리 복원 / 없고 기존 row 면 DQ_ID SP 조회 / 신규는 빈 그리드.
    const crudType = initialRow?.CRUD_TYPE ?? '';
    const rowDqId = initialRow?.DQ_ID ?? '';
    // 세션에 이번 편집분(신규/기존 공통)이 있으면 우선 복원.
    const { columns, parameters } = getSaveColumnsAndParametersList(crudType, rowDqId);

    const isNewRow = crudType === 'I';
    const hasNumericDqId = rowDqId !== '' && !isNaN(Number(rowDqId));

    if (columns.length > 0 || parameters.length > 0) {
      // 세션에 이번 편집분이 있으면 그걸 복원.
      setColumnsRows(columns);
      setParameterRows(parameters);
      setApiFetchDqId(undefined);
    } else if (!isNewRow && hasNumericDqId) {
      // 세션 없음 + 기존 저장 row → DQ_ID 로 SP 조회 (아래 조회 결과 반영 useEffect 가 그리드 채움).
      setColumnsRows([]);
      setParameterRows([]);
      setApiFetchDqId(Number(rowDqId));
    } else {
      // 신규(미저장) row 이고 세션도 없음 → 빈 그리드 (사용자가 Confirm 으로 파싱). AS-IS 동일.
      setColumnsRows([]);
      setParameterRows([]);
      setApiFetchDqId(undefined);
    }
  }, [open, initialRow, getSaveColumnsAndParametersList]);

  useEffect(() => {
    if (!open || apiFetchDqId === undefined) return;
    const cols = popupColumnsData?.o_rc1 ?? [];
    if (cols.length > 0 && Number(cols[0].DQ_ID) !== apiFetchDqId) return; // stale 캐시 무시
    setColumnsRows(
      cols.map(c => ({
        DQ_ID: c.DQ_ID,
        COLUMN_NAME: c.COLUMN_NAME,
        VALUE_YN: c.VALUE_YN,
        VALUE_TYPE: c.VALUE_TYPE,
        VALID_YN: c.VALID_YN,
        SEQNO: String(c.SEQNO ?? ''),
        AGGREGATE: c.AGGREGATE ?? '',
        CRUD_TYPE: '',
      }))
    );
  }, [open, apiFetchDqId, popupColumnsData]);

  useEffect(() => {
    if (!open || apiFetchDqId === undefined) return;
    const params = popupParametersData?.o_rc1 ?? [];
    if (params.length > 0 && Number(params[0].DQ_ID) !== apiFetchDqId) return; // stale 캐시 무시
    setParameterRows(
      params.map(p => ({
        DQ_ID: p.DQ_ID,
        PARAMETER_ID: toAtToken(p.PARAMETER_ID),
        PARAMETER_TYPE: p.PARAMETER_TYPE,
        OPERATION_ID: p.OPERATION_ID,
        VALID_YN: p.VALID_YN,
        REP_YN: p.REP_YN,
        SEQNO: String(p.SEQNO ?? ''),
        CRUD_TYPE: '',
      }))
    );
  }, [open, apiFetchDqId, popupParametersData]);

  //sql문 구문 검증
  //  BE `P_SYS0013_VALIDATE_QUERY` 는 DBMS_SQL.PARSE 로만 구문을 검증하고(실행 X) 컬럼 스키마를 반환한다.
  //  - 파라미터 토큰(:Param/@Param)을 값으로 채우지 않아도 되므로 원본 SQL 을 그대로 보낸다(별도 wrap 불필요).
  //  - PARSE 성공 = 구문 정상 → O_RESULT_CURSOR 의 CODE 가 '0'(SUCCESS) 이면 결과 행 수와 무관하게 "검증 통과".
  //  - 구문 오류 시 SP 가 RAISE_APPLICATION_ERROR → 500(catch) 또는 CODE != '0' 로 내려온다.
  const validateSql = async (sql: string): Promise<ValidatedColumn[] | null> => {
    const failWithSyntaxError = () => {
      void setAlert({ type: 'alert', content: t('MSG00149', '_SQL 구문이 틀렸습니다.') });
      return null;
    };

    try {
      const response = await apiClient.validateDynamicQuery(sql);

      const result = response.result as
        | {
            O_RESULT_CURSOR?: { CODE?: string; MSG?: string }[];
            o_rc1_columns?: BeColumnMeta[];
          }
        | undefined;
      const dbCode = result?.O_RESULT_CURSOR?.[0]?.CODE;
      // 프로시저가 성공(200 + CODE '0')하지 못했을 때만 구문 오류로 처리한다.
      if ((response.code && response.code !== '0') || (dbCode && dbCode !== '0'))
        return failWithSyntaxError();

      // 검증 통과 — DESCRIBE_COLUMNS2 기반 컬럼 스키마([{name,type}]) 를 SELECT 순서로 정렬해 반환.
      // (컬럼이 0개여도 CODE '0' 이면 검증 자체는 성공이므로 빈 배열로 통과시킨다.)
      const beColumns = result?.o_rc1_columns ?? [];
      const columns = beColumns.map(c => ({ name: c.name, type: c.type }));
      return orderColumnsBySelect(columns, sql);
    } catch {
      return failWithSyntaxError();
    }
  };

  const guardSqlThenValidate = async (): Promise<boolean> => {
    if (!sqlText.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00150', 'SQL 을 먼저 입력하세요.') });
      return false;
    }
    setValidating(true);
    const columns = await validateSql(sqlText);
    setValidating(false);
    return columns !== null;
  };

  //comfirm 버튼 클릭 이벤트
  const handleParsing = async () => {
    if (!sqlText.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00150', 'SQL 을 먼저 입력하세요.') });
      return;
    }
    setValidating(true);
    const columns = await validateSql(sqlText);
    setValidating(false);
    if (columns === null) return; // 검증 실패 (alert 는 validateSql 에서 이미 표시)

    const prevColumns = (columnsGridRef.current?.rows ?? [])
      .map(r => r.dataItem as Columns | null)
      .filter((d): d is Columns => !!d);
    const prevParameters = (parameterGridRef.current?.rows ?? [])
      .map(r => r.dataItem as Parameters | null)
      .filter((d): d is Parameters => !!d);

    // 컬럼 셋팅 — 실제 결과 컬럼명 + 추론 타입으로 Columns 그리드 채움(기존 대조).
    setColumnsRows(reconcileColumns(columns, prevColumns, dqId));

    const tokens = findParamTokens(sqlText);
    setParameterRows(reconcileParameters(tokens, prevParameters, dqId));
    setToast({ type: 'success', message: t('MSG00148', '검증되었습니다.') });
  };

  const handleColumnInsert = async () => {
    if (!(await guardSqlThenValidate())) return;
    if (!columnsGridRef.current) return;
    GridAction.addRow(columnsGridRef.current, {
      DQ_ID: dqId,
      COLUMN_NAME: '',
      VALUE_YN: '',
      VALUE_TYPE: '',
      VALID_YN: '',
      SEQNO: '',
      AGGREGATE: '',
    });
  };
  const handleColumnDelete = () => {
    if (!columnsGridRef.current) return;
    GridAction.removeRow(columnsGridRef.current);
  };
  const handleConditionInsert = async () => {
    if (!(await guardSqlThenValidate())) return;
    if (!parameterGridRef.current) return;
    GridAction.addRow(parameterGridRef.current, {
      DQ_ID: dqId,
      PARAMETER_ID: '',
      PARAMETER_TYPE: 'Parameter',
      OPERATION_ID: '-',
      VALID_YN: 'Y',
      REP_YN: '-',
      SEQNO: '',
    });
  };
  const handleConditionDelete = () => {
    if (!parameterGridRef.current) return;
    GridAction.removeRow(parameterGridRef.current);
  };

  const handleSave = () => {
    if (!reportNm.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00150', '필수값을 입력하세요.') });
      return;
    }
    if (!description.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00150', '필수값을 입력하세요.') });
      return;
    }
    if (!sqlText.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00150', 'SQL 을 먼저 입력하세요.') });
      return;
    }

    const columns: Columns[] = (columnsGridRef.current?.rows ?? [])
      .map(r => r.dataItem as Columns | null)
      .filter((d): d is Columns => !!d)
      .map((d, idx) => ({
        DQ_ID: dqId,
        COLUMN_NAME: d.COLUMN_NAME ?? '',
        VALUE_YN: d.VALUE_YN ?? '',
        VALUE_TYPE: d.VALUE_TYPE ?? '',
        VALID_YN: d.VALID_YN ?? '',
        SEQNO: String(d.SEQNO ?? idx + 1),
        AGGREGATE: d.AGGREGATE ?? '',
        CRUD_TYPE: d.CRUD_TYPE ?? '',
      }));

    const parameters: Parameters[] = (parameterGridRef.current?.rows ?? [])
      .map(r => r.dataItem as Parameters | null)
      .filter((d): d is Parameters => !!d)
      .map((d, idx) => ({
        DQ_ID: dqId,
        PARAMETER_ID: toAtToken(d.PARAMETER_ID),
        PARAMETER_TYPE: d.PARAMETER_TYPE ?? '',
        OPERATION_ID: d.OPERATION_ID ?? '',
        VALID_YN: d.VALID_YN ?? '',
        REP_YN: d.REP_YN ?? '',
        SEQNO: String(d.SEQNO ?? idx + 1),
        CRUD_TYPE: d.CRUD_TYPE ?? '',
      }));

    const isInsertRow = initialRow?.CRUD_TYPE === 'I';
    const crudType = isInsertRow ? 'I' : 'M';

    setSaveColumnsAndParametersList({ DQ_ID: dqId, CRUD_TYPE: crudType, columns, parameters });

    if (initialRow) {
      initialRow.DQ_NAME = reportNm;
      initialRow.DESCRIPTION = description;
      initialRow.GROUP_NAME = role;
      initialRow.DQ_TEXT = sqlText;
      if (!isInsertRow) initialRow.CRUD_TYPE = 'M';
    }
    onSaved?.();
    setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      size={1600}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00760', 'SQL Query')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <Grid container spacing={2} className={styles.metaForm}>
            <Grid size={4}>
              <FormItem
                label={t('LBL00718', 'Report Name')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    value={reportNm}
                    onChange={e => {
                      setReportNm(e.target.value);
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={4}>
              <FormItem
                label={t('LBL00608', 'Description')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    value={description}
                    onChange={e => {
                      setDescription(e.target.value);
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={4}>
              <FormItem
                label={t('LBL00720', 'Role')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={role}
                    options={roleOptions}
                    onChange={(_, options) => {
                      setRole(options);
                    }}
                  />
                )}
              />
            </Grid>
          </Grid>
          <PanelGroup className={styles.designerPanelGroup} orientation='horizontal'>
            <Panel defaultSize={55}>
              <div className={styles.leftPane}>
                <TitleArea
                  isSubTitle
                  title={t('LBL00652', 'SQL')}
                  depth='h4'
                  rightButtons={
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='small'
                      buttonLabel={t('LBL00359', 'Confirm')}
                      disabled={validating}
                      onClick={() => void handleParsing()}
                      iconComponent={<OtherIdeaIcon appearance='lined' />}
                    />
                  }
                />
                <div className={styles.gridFill}>
                  <textarea
                    className={styles.sqlTextarea}
                    value={sqlText}
                    spellCheck={false}
                    onChange={e => {
                      setSqlText(e.target.value);
                    }}
                  />
                </div>
              </div>
            </Panel>
            <PanelSeparator />
            <Panel defaultSize={45}>
              <div className={styles.rightPane_1}>
                <TitleArea
                  isSubTitle
                  title={t('LBL00646', 'Columns')}
                  depth='h4'
                  rightButtons={
                    <>
                      <Button
                        appearance='outlined'
                        priority='normal'
                        size='small'
                        buttonLabel={t('LBL00621', 'Add')}
                        disabled={validating}
                        onClick={() => void handleColumnInsert()}
                        iconComponent={<ControlAddIcon size='default' />}
                      />
                      <Button
                        appearance='outlined'
                        priority='normal'
                        size='small'
                        buttonLabel={t('LBL00622', 'Delete')}
                        onClick={handleColumnDelete}
                        iconComponent={<EditDeleteIcon appearance='lined' />}
                      />
                    </>
                  }
                />
                <div className={styles.gridFill}>
                  <DynamicQueryModalColumnsGrid gridRef={columnsGridRef} data={columnsRows} />
                </div>
              </div>
              <div className={styles.rightPane_2}>
                <TitleArea
                  isSubTitle
                  title={t('LBL00726', 'Condition')}
                  depth='h4'
                  rightButtons={
                    <>
                      <Button
                        appearance='outlined'
                        priority='normal'
                        size='small'
                        buttonLabel={t('LBL00621', 'Add')}
                        disabled={validating}
                        onClick={() => void handleConditionInsert()}
                        iconComponent={<ControlAddIcon size='default' />}
                      />
                      <Button
                        appearance='outlined'
                        priority='normal'
                        size='small'
                        buttonLabel={t('LBL00622', 'Delete')}
                        onClick={handleConditionDelete}
                        iconComponent={<EditDeleteIcon appearance='lined' />}
                      />
                    </>
                  }
                />
                <div className={styles.gridFill}>
                  <DynamicQueryModalParametersGrid
                    gridRef={parameterGridRef}
                    data={parameterRows}
                  />
                </div>
              </div>
            </Panel>
          </PanelGroup>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel={t('LBL00111', '_Save')}
              iconPosition='leading'
              iconComponent={<ControlConfirmIcon size='small' />}
              priority='primary'
              size='medium'
              onClick={() => handleSave()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00107', '_Close')}
              onClick={() => modalClose()}
            />
          </div>
        </div>
      }
    />
  );
};
