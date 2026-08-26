// SYS0013 SQL Query 편집 모달 — 항목·TEXT·LABEL = AS-IS(SYS0013_POPUP.png) 유지 / 디자인 = TO-BE 표준.
// 표준 정본: PriceBatchInputModal(DMF0020) — customHeaderTitle(headerDot) + dialogContent flex +
//   그리드 특화 액션 = TitleArea rightButtons + 하단 buttonWrapper(Close/OK) + Button(buttonLabel/LBL 재사용).
//
// 기능(AS-IS SCM0005_DynamicQueryListPopUp 정합):
//   Confirm(LBL00359) = SQL 검증(P_SYS0013_VALIDATE_QUERY — 'SELECT TOP 0' 등가) + Column/Condition
//                       재구성 (동명 행의 Valid/Seq 사용자 값 보존 — AS-IS dtCols 재구성 정합)
//   Edit            = SQL 편집 잠금 토글 (AS-IS rtxtSQL 기본 잠김)
//   Insert/Delete   = 각 그리드 TitleArea rightButtons (행 추가/삭제)
//   OK(LBL00716)    = 최종 상태를 부모에 반환 (AS-IS SetItem 정합 — 실제 저장은 공통 Save 의 diff 체인)
//   Close(LBL00627) = 폐기
import { type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField, TitleArea } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../dynamic-query.constants';
import { extractParamTokens, substituteParams } from '../dynamic-query.payload';
import type {
  ColumnMetaRow,
  ParameterMetaRow,
  QueryRow,
  ValidateColumnRow,
} from '../dynamic-query.types';

import styles from './DynamicQueryEditModal.module.scss';

// 모달 그리드 로컬 행 — 최종 상태 편집 모델 (I/M/D diff 는 OK 후 저장 시 계산).
export interface ModalColumnRow extends WijmoRowItem {
  COLUMN_NAME: string;
  VALUE_TYPE: string;
  VALID_YN: string;
  SEQNO: string;
}
export interface ModalConditionRow extends WijmoRowItem {
  PARAMETER_TYPE: string;
  PARAMETER_ID: string;
  VALID_YN: string;
  SEQNO: string;
}

export interface EditModalResult {
  dqName: string;
  description: string;
  dqText: string;
  roles: string[];
  colsFinal: ModalColumnRow[];
  condsFinal: ModalConditionRow[];
}

interface Props {
  open: boolean;
  targetRow: QueryRow | undefined;
  // 기존 행 편집 시 현재 정의 로드 (AS-IS LoadData 정합). 신규 행은 빈 그리드.
  existingCols: ColumnMetaRow[];
  existingConds: ParameterMetaRow[];
  modalClose: () => void;
  onApply: (values: EditModalResult) => void;
}

// AS-IS 팝업 Column 그리드: Column / Type / Valid / Seq No (캡쳐 라벨 유지)
const COLUMN_GRID_META: RawFlexGridColumnConfig[] = [
  { colNm: 'COLUMN_NAME', colLblNm: 'Column', colWth: 150, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
  { colNm: 'VALUE_TYPE', colLblNm: 'Type', colWth: 120, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
  { colNm: 'VALID_YN', colLblNm: 'Valid', colWth: 55, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
  { colNm: 'SEQNO', colLblNm: 'Seq No', colWth: 60, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
];

// AS-IS 팝업 Condition 그리드: Type / Column / Valid / No (캡쳐 라벨 유지)
const CONDITION_GRID_META: RawFlexGridColumnConfig[] = [
  { colNm: 'PARAMETER_TYPE', colLblNm: 'Type', colWth: 110, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
  { colNm: 'PARAMETER_ID', colLblNm: 'Column', colWth: 160, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
  { colNm: 'VALID_YN', colLblNm: 'Valid', colWth: 55, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
  { colNm: 'SEQNO', colLblNm: 'No', colWth: 50, fixed: false, visible: true, display: true, inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL },
];

const parseRoles = (groupId: unknown): string[] =>
  ((groupId ?? '') as string)
    .split(',')
    .map(s => s.trim())
    .filter(s => s !== '' && s !== 'ALL');

export const DynamicQueryEditModal = ({
  open,
  targetRow,
  existingCols,
  existingConds,
  modalClose,
  onApply,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);

  const colGridRef = useRef<FlexGrid<ModalColumnRow>>(undefined);
  const condGridRef = useRef<FlexGrid<ModalConditionRow>>(undefined);

  const [dqName, setDqName] = useState('');
  const [description, setDescription] = useState('');
  const [dqText, setDqText] = useState('');
  const [roles, setRoles] = useState<string[]>([]);
  const [colRows, setColRows] = useState<ModalColumnRow[]>([]);
  const [condRows, setCondRows] = useState<ModalConditionRow[]>([]);
  // AS-IS rtxtSQL 기본 잠김 — Edit 버튼으로 해제 (신규 행은 처음부터 편집 가능).
  const [sqlEditable, setSqlEditable] = useState(false);
  // 그리드 편집 시작 후에는 existingCols 지연 도착이 사용자 편집을 덮어쓰지 않도록 가드.
  const touchedRef = useRef(false);

  const isNewRow = targetRow?.CRUD_TYPE === 'I';

  const [roleData] = useTabComboQueries({ filters: ['UserGroup'] });
  const roleOptions = useMemo(
    () =>
      (roleData ?? []).map(r => ({ value: String(r.CODE ?? ''), label: String(r.NAME ?? r.CODE) })),
    [roleData]
  );

  // 모달 오픈 — 대상 행 값 + 기존 정의 로드 (AS-IS LoadData). Close = 폐기.
  useEffect(() => {
    if (!open || !targetRow) return;
    setDqName(String(targetRow.DQ_NAME ?? ''));
    setDescription(String(targetRow.DESCRIPTION ?? ''));
    setDqText(String(targetRow.DQ_TEXT ?? ''));
    setRoles(parseRoles(targetRow.GROUP_ID));
    setSqlEditable(targetRow.CRUD_TYPE === 'I');
    touchedRef.current = false;
    setColRows([]);
    setCondRows([]);
  }, [open, targetRow]);

  // 기존 정의(fetch) 도착 시 그리드 초기 로드 — 사용자 편집 시작 전까지만 sync.
  useEffect(() => {
    if (!open || !targetRow || targetRow.CRUD_TYPE === 'I' || touchedRef.current) return;
    setColRows(
      (existingCols ?? []).map(c => ({
        COLUMN_NAME: String(c.COLUMN_NAME ?? ''),
        VALUE_TYPE: String(c.VALUE_TYPE ?? ''),
        VALID_YN: String(c.VALID_YN ?? 'Y'),
        SEQNO: String(c.SEQNO ?? '0'),
      }))
    );
    setCondRows(
      (existingConds ?? []).map(p => ({
        PARAMETER_TYPE: String(p.PARAMETER_TYPE ?? 'Parameter'),
        PARAMETER_ID: String(p.PARAMETER_ID ?? ''),
        VALID_YN: String(p.VALID_YN ?? 'Y'),
        SEQNO: String(p.SEQNO ?? '0'),
      }))
    );
  }, [open, targetRow, existingCols, existingConds]);

  // ── Confirm — AS-IS 'SELECT TOP 0' 검증 + Column/Condition 재구성 (동명 행 사용자 값 보존) ──
  const handleConfirm = () => {
    if (!dqText.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00628', '_실행할 Query 를 선택하세요') });
      return;
    }
    const sqlText = substituteParams(dqText, {}, []);
    void (async () => {
      try {
        const response = await apiClient.post<{ o_rc1: ValidateColumnRow[] }>(
          `/${MENU_ID}/${SHEETS.MAIN}/VALIDATE/call-proc`,
          { sqlText }
        );
        const cols = response.data.result?.o_rc1 ?? [];
        touchedRef.current = true;
        const prevCols = new Map(colRows.map(r => [r.COLUMN_NAME.toUpperCase(), r]));
        setColRows(
          cols.map((c, i) => {
            const prev = prevCols.get(String(c.COLUMN_NAME).toUpperCase());
            return {
              COLUMN_NAME: c.COLUMN_NAME,
              VALUE_TYPE: c.VALUE_TYPE,
              VALID_YN: prev?.VALID_YN ?? 'Y',
              SEQNO: prev?.SEQNO && prev.SEQNO !== '0' ? prev.SEQNO : String(i + 1),
            };
          })
        );
        const tokens = extractParamTokens(dqText);
        const prevConds = new Map(condRows.map(r => [r.PARAMETER_ID.toUpperCase(), r]));
        setCondRows(
          tokens.map((token, i) => {
            const prev = prevConds.get(token.toUpperCase());
            return {
              PARAMETER_TYPE: prev?.PARAMETER_TYPE ?? 'Parameter',
              PARAMETER_ID: token,
              VALID_YN: prev?.VALID_YN ?? 'Y',
              SEQNO: prev?.SEQNO && prev.SEQNO !== '0' ? prev.SEQNO : String(i + 1),
            };
          })
        );
        setToast({ type: 'success', message: t('MSG00655', '_Query 검증이 완료되었습니다.') });
      } catch (err) {
        void setAlert({ type: 'alert', content: String((err as Error)?.message ?? err) });
      }
    })();
  };

  // ── Insert / Delete — 각 그리드 TitleArea rightButtons (표준: 행 대상 액션은 grid 위) ──
  const insertColRow = () => {
    touchedRef.current = true;
    setColRows(rows => [
      ...rows,
      { COLUMN_NAME: '', VALUE_TYPE: 'System.String', VALID_YN: 'Y', SEQNO: String(rows.length + 1) },
    ]);
  };
  const deleteColRow = () => {
    const sel = colGridRef.current?.selectedItems?.[0] as ModalColumnRow | undefined;
    if (!sel) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_삭제할 행을 선택하세요') });
      return;
    }
    touchedRef.current = true;
    setColRows(rows => rows.filter(r => r !== sel));
  };
  const insertCondRow = () => {
    touchedRef.current = true;
    setCondRows(rows => [
      ...rows,
      { PARAMETER_TYPE: 'Parameter', PARAMETER_ID: '', VALID_YN: 'Y', SEQNO: String(rows.length + 1) },
    ]);
  };
  const deleteCondRow = () => {
    const sel = condGridRef.current?.selectedItems?.[0] as ModalConditionRow | undefined;
    if (!sel) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_삭제할 행을 선택하세요') });
      return;
    }
    touchedRef.current = true;
    setCondRows(rows => rows.filter(r => r !== sel));
  };

  // ── OK — 최종 상태 반환 (AS-IS SetItem 반환 정합, 실제 저장은 공통 Save) ──
  const handleOk = () => {
    if (!dqName.trim() || !dqText.trim()) {
      void setAlert({ type: 'alert', content: t('MSG00013', '_필수값을 입력하세요.') });
      return;
    }
    onApply({
      dqName,
      description,
      dqText,
      roles,
      colsFinal: colRows.filter(r => String(r.COLUMN_NAME ?? '').trim() !== ''),
      condsFinal: condRows.filter(r => String(r.PARAMETER_ID ?? '').trim() !== ''),
    });
    modalClose();
  };

  const gridActionButtons = (onInsert: () => void, onDelete: () => void) => (
    <>
      <Button
        appearance='outlined'
        priority='normal'
        size='small'
        buttonLabel={t('LBL00121', 'Insert')}
        onClick={onInsert}
      />
      <Button
        appearance='outlined'
        priority='normal'
        size='small'
        buttonLabel={t('LBL00108', 'Delete')}
        onClick={onDelete}
      />
    </>
  );

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={1200}
      height='80vh'
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>SQL Query</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          {/* 필드 3종 — 항목·라벨 = AS-IS 유지 (Report Name / Description / Role) */}
          <Grid container spacing={2}>
            <Grid size={4}>
              <FormItem
                label={t('LBL00718', 'Report Name')}
                labelAlign='right'
                render={() => (
                  <InputField fullWidth value={dqName} onChange={e => setDqName(e.target.value)} />
                )}
              />
            </Grid>
            <Grid size={4}>
              <FormItem
                label={t('LBL00719', 'Description')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    value={description}
                    onChange={e => setDescription(e.target.value)}
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
                    useClearIcon
                    options={roleOptions}
                    value={roles.join(',')}
                    onChange={(_, v) =>
                      setRoles(typeof v === 'string' && v ? v.split(',').filter(Boolean) : [])
                    }
                  />
                )}
              />
            </Grid>
          </Grid>

          {isNewRow && (
            <div className={styles.hint}>
              신규 Query — 번호(DQ_ID)는 저장 시 채번되며, Role/Column/Condition 은 저장 시 함께
              등록됩니다.
            </div>
          )}

          {/* 본문 — 좌 Query / 우 Column + Condition (AS-IS 캡쳐 배치, 스타일 = TO-BE 표준) */}
          <div className={styles.bodyRow}>
            <div className={styles.queryPane}>
              {/* AS-IS 캡쳐 섹션 라벨 'Query' 유지 (LBL 미등재 — Edit 와 함께 AS-IS 원문 하드코딩 2건) */}
              <TitleArea
                isSubTitle
                title='Query'
                depth='h4'
                rightButtons={
                  <>
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='small'
                      buttonLabel='Edit'
                      onClick={() => setSqlEditable(v => !v)}
                    />
                    <Button
                      appearance='contained'
                      priority='primary'
                      size='small'
                      buttonLabel={t('LBL00359', 'Confirm')}
                      onClick={handleConfirm}
                    />
                  </>
                }
              />
              <textarea
                className={styles.sqlTextarea}
                value={dqText}
                readOnly={!sqlEditable}
                onChange={e => setDqText(e.target.value)}
                spellCheck={false}
                placeholder={sqlEditable ? '' : 'Edit 버튼으로 편집을 활성화하세요.'}
              />
            </div>
            <div className={styles.gridsPane}>
              <div className={`${styles.gridSection} ${styles.gridGrowCol}`}>
                <TitleArea
                  isSubTitle
                  title={t('LBL00725', 'Columns')}
                  depth='h4'
                  rightButtons={gridActionButtons(insertColRow, deleteColRow)}
                />
                <div className={styles.gridWrapper}>
                  <DataGrid<ModalColumnRow>
                    gridRef={colGridRef}
                    itemsSource={colRows}
                    staticColumns={COLUMN_GRID_META}
                    cellEditEnded={() => {
                      touchedRef.current = true;
                    }}
                  />
                </div>
              </div>
              <div className={`${styles.gridSection} ${styles.gridGrowCond}`}>
                <TitleArea
                  isSubTitle
                  title={t('LBL00726', 'Condition')}
                  depth='h4'
                  rightButtons={gridActionButtons(insertCondRow, deleteCondRow)}
                />
                <div className={styles.gridWrapper}>
                  <DataGrid<ModalConditionRow>
                    gridRef={condGridRef}
                    itemsSource={condRows}
                    staticColumns={CONDITION_GRID_META}
                    cellEditEnded={() => {
                      touchedRef.current = true;
                    }}
                  />
                </div>
              </div>
            </div>
          </div>

          {/* Action — 표준 buttonWrapper (하단 우측 정렬): Close / OK */}
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t('LBL00716', 'OK')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              onClick={handleOk}
            />
          </div>
        </div>
      }
    />
  );
};
