import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { attachRowNoHeader, GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
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
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

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

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, itemsSource]);

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL_DMF0043_CONTRIBUTE_RATE', '_Contribution Rate')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.gridWrapper}>
            <ResultArea
              title=''
              count={itemsSource.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<ResponseData<MODAL_RATE, MODAL_SHEET_RATE, 'o_rc1'>>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={staticColumns}
                itemsSource={itemsSource}
                dblClick={handleDblClick}
              />
            </ResultArea>
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
