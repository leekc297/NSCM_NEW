import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef } from 'react';

import { GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';

import { MODAL_RATE, MODAL_SHEET_RATE } from './contribute-rate-modal.constants';
import styles from './ContributeRateModal.module.scss';
import { useContributeRateModalStore } from './contributeRateModalStore';

export interface ContributeRateModalSelection {
  divisionId: string;
  yyyymm: string;
  osCorpCd: string;
  contributionType: string;
  contributionRatio: string;
}

interface ContributeRateModalProps {
  open: boolean;
  yyyy: string;
  modalClose: () => void;
  setSelectedValue: (row: ContributeRateModalSelection) => void;
}

// AS-IS DMF0043_ContributeRatePopup (.cs L573 btnCutOff_Click) — 기여율 설정 모달.
// RegionModal 표준 (#67) — open / modalClose props 외부 제어 + staticColumns store fetch.
export const ContributeRateModal = ({
  open,
  yyyy,
  modalClose,
  setSelectedValue,
}: ContributeRateModalProps) => {
  const { t } = useTranslation();

  const initialized = useContributeRateModalStore(state => state.initialized);
  const staticColumns = useContributeRateModalStore(state => state.staticColumns);
  const fetchStaticColumns = useContributeRateModalStore(state => state.fetchStaticColumns);

  const gridRef = useRef<
    FlexGrid<ResponseData<MODAL_RATE, MODAL_SHEET_RATE, 'o_rc1'>> | undefined
  >();

  // useTabProcQuery 는 filters 참조가 바뀌면 캐시를 버리고 재조회한다. yyyy prop 을
  // 인라인 리터럴로 감싸면 값이 그대로여도 매 렌더 새 참조가 생겨 그리드가 깜빡인다 —
  // useMemo 로 참조를 yyyy 에 고정한다.
  const filters = useMemo(() => ({ yyyy }), [yyyy]);

  const { data } = useTabProcQuery<MODAL_RATE>({
    menuId: MODAL_RATE,
    sheetName: MODAL_SHEET_RATE,
    tabId: MODAL_RATE,
    filters,
    enabled: open && !!yyyy,
  });

  const itemsSource = data?.o_rc1 ?? [];

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(grid, ht.row);
    if (!row) return;
    setSelectedValue({
      divisionId: String(row.DIVISION_ID ?? ''),
      yyyymm: String(row.YYYYMM ?? ''),
      osCorpCd: String(row.OS_CORP_CD ?? ''),
      contributionType: String(row.CONTRIBUTION_TYPE ?? ''),
      contributionRatio: String(row.CONTRIBUTION_RATIO ?? ''),
    });
    modalClose();
  };

  const handleSubmit = () => {
    const selections = GridUtils.getSelectedRows(gridRef.current);
    if (!selections || selections.length === 0) return;
    const row = selections[0];
    setSelectedValue({
      divisionId: String(row.DIVISION_ID ?? ''),
      yyyymm: String(row.YYYYMM ?? ''),
      osCorpCd: String(row.OS_CORP_CD ?? ''),
      contributionType: String(row.CONTRIBUTION_TYPE ?? ''),
      contributionRatio: String(row.CONTRIBUTION_RATIO ?? ''),
    });
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL_DMF0043_CONTRIBUTE_RATE', '_Contribution Rate')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_RATE, MODAL_SHEET_RATE, 'o_rc1'>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={handleDblClick}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
            <Button
              appearance='contained'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
          </div>
        </div>
      }
    />
  );
};
