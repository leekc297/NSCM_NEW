import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import { t } from '@foundation/i18n';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { attachRowNoHeader, GridAction } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useSaveWithValidation } from '@shared/hooks';
import { Button } from '@shared/lges';
import { ControlConfirmIcon, FileExceldownloadIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { MODEL_CHANGE_SHEET, SHEETS } from '../sales-site-project-model.constants';
import { useSalesSiteProjectModelSave } from '../useSalesSiteProjectModelSave';

import styles from './ModelCodeChangeModal.module.scss';

// AS-IS GSCM.DM.Plan.UIL/POPUP/DMF0005_ModelCodeChange (Title 'Sales Site Project Model Popup', 682×400).
//   메인 btnModelChange_Click(.cs L3455) → ShowDialog → DialogResult.OK 면 FindData_Main 재조회.
//   - 그리드: BEFORE(ITEM_ID_BEFORE) / AFTER(ITEM_ID_AFTER) 2컬럼, 폭 250. 조회 없이 빈 그리드로 연다
//     (DefineProperty 에서 Find/OK 버튼 숨김).
//   - Insert(InsertRow) / Delete(신규행만 삭제 — DeleteButton 이 CAppSetting.StringI 행만 지움) /
//     Save(SaveData) / Excel / Close.
//   - Edit(SwitchLock) 은 이식하지 않는다 — TO-BE 그리드는 잠금 모드 토글 없이 바로 편집한다
//     (모든 행이 신규행이라 AS-IS 에서도 Insert 직후 LockRange 해제 상태였다).
// 저장 SP = PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP (AS-IS DM.DMF0005_SAVE_MODEL_CHANGE_POPUP).
//   AS-IS 는 BEFORE/AFTER/USER 를 '^' 로 이어 보냈지만, TO-BE SP 는 메인 저장과 같은 P_DATA(JSON 배열) +
//   P_USER_ID 규약이라 { data: [{ ITEM_ID_BEFORE, ITEM_ID_AFTER }] } 로 보낸다(사용자 ID 는 BE 세션 주입).
//   코드 형식 검증(12자리 / 앞 11자리 동일 / 'MP' 시작 / 전후 동일 / Division 40 Model 존재)은 SP 가 한다.

type ModelChangeRow = ResponseData<'DMF0005', typeof MODEL_CHANGE_SHEET, 'modelChange'>;

interface Props {
  open: boolean;
  modalClose: () => void;
  tabId: string;
}

// 팝업 전용 고정 컬럼 — 조회 SP 가 없는 입력 전용 그리드라 형제 SalesPriceRangeModal 과 같이 리터럴로 둔다.
//   두 컬럼 모두 신규행 필수 입력(IM) — 저장 전 공용 useSaveWithValidation 이 공란을 막는다.
const MODEL_CHANGE_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'ITEM_ID_BEFORE', colLblNm: 'BEFORE', colWth: 250 },
  { colNm: 'ITEM_ID_AFTER', colLblNm: 'AFTER', colWth: 250 },
].map(c => ({
  ...c,
  horzAlgnCd: 'L',
  fixed: false,
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY,
})) as RawFlexGridColumnConfig[];

export const ModelCodeChangeModal = ({ open, modalClose, tabId }: Props) => {
  const { saveWithValidation } = useSaveWithValidation();
  const { setToast, setAlert } = useMessageStore.getState();
  const gridRef = useRef<FlexGrid<ModelChangeRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  // 그리드 소스 배열 — GridAction.addRow/removeRow 가 이 배열을 직접 splice 한다.
  //   열 때마다 새 배열로 비운다(AS-IS 도 팝업 인스턴스를 매번 새로 만들어 빈 그리드로 시작).
  const [rows, setRows] = useState<ModelChangeRow[]>([]);
  // addRow/removeRow 는 setState 를 부르지 않아 건수 표시가 따라오지 않는다 — 조작 직후 다시 센다.
  const [rowCount, setRowCount] = useState(0);
  const syncRowCount = () =>
    setRowCount(gridRef.current?.collectionView?.sourceCollection?.length ?? 0);

  useEffect(() => {
    if (!open) return;
    setRows([]);
    setRowCount(0);
  }, [open]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, rows]);

  // 저장 성공 시 메인(production) 재조회 — AS-IS DialogResult.OK → FindData_Main.
  const { mutate, isPending } = useSalesSiteProjectModelSave<typeof MODEL_CHANGE_SHEET>({
    sheetName: MODEL_CHANGE_SHEET,
    refetchSheetName: SHEETS.PRODUCTION,
    tabId,
  });

  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.addRow(grid, { ITEM_ID_BEFORE: '', ITEM_ID_AFTER: '' });
    syncRowCount();
  };

  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    // AS-IS DeleteButton — 신규행(I)만 지운다. 이 팝업의 행은 전부 신규행이다.
    if (!GridAction.removeRow(grid, true)) {
      void setAlert({ type: 'alert', content: t('MSG00014', '_No selection') });
      return;
    }
    syncRowCount();
  };

  const handleSave = () => {
    const grid = gridRef.current;
    if (!grid) return;
    grid.finishEditing();

    const saveData = (grid.collectionView?.sourceCollection ?? []).map(row => ({
      ITEM_ID_BEFORE: String(row.ITEM_ID_BEFORE ?? '').trim(),
      ITEM_ID_AFTER: String(row.ITEM_ID_AFTER ?? '').trim(),
      CRUD_TYPE: row.CRUD_TYPE,
    }));
    if (saveData.length === 0) {
      setToast({ type: 'error', message: t('MSG_NO_CHANGE', '_수정한 내용이 없습니다.') });
      return;
    }

    saveWithValidation(saveData, MODEL_CHANGE_COLUMNS, data =>
      mutate(
        data.map(({ ITEM_ID_BEFORE, ITEM_ID_AFTER }) => ({ ITEM_ID_BEFORE, ITEM_ID_AFTER })),
        // AS-IS SaveData — 저장 메시지 후 팝업 Close. 실패면(SP 검증 메시지 alert) 팝업을 유지한다.
        { onSuccess: () => modalClose() }
      )
    );
  };

  const handleExcel = async () => {
    const grid = gridRef.current;
    if (!grid) return;
    await GridAction.excelDownload(grid, 'Model-Code-Change');
  };

  return (
    <CustomDialog
      open={open}
      size={460}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과 충돌한다
      //   (형제 SalesPriceRangeModal 과 동일 사유).
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Sales Site Project Model Popup</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <div className={styles.gridWrapper}>
            <ResultArea>
              <DataGrid<ModelChangeRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows}
                staticColumns={MODEL_CHANGE_COLUMNS}
                autoGenerateColumns={false}
                className={styles.grid}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              iconComponent={<FileExceldownloadIcon />}
              disabled={rowCount === 0}
              onClick={() => void handleExcel()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00121', '_Insert')}
              onClick={handleInsert}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00108', '_Delete')}
              onClick={handleDelete}
            />
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel={t('LBL00111', '_Save')}
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              disabled={isPending}
              onClick={handleSave}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', '_Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
