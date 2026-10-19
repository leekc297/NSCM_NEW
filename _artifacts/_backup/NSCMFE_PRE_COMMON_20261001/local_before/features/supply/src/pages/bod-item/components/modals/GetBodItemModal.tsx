import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, buildNoColumn, withRowNo } from '@foundation/utils';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';

import { MENU_ID, POPUP_SHEET } from '../../bod-item.constants';
import type { BodPopupRow } from '../../bod-item.types';

import styles from './GetBodItemModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  /** 선택 BOD 행(들) — 부모가 신규행 FROM_SITE_NAME/TO_SITE_NAME/BOD_ID/INCOTERMS/TRANSPORT_MODE 채움. */
  setSelectedValue: (rows: BodPopupRow[]) => void;
  preSearchParams: { divisionId: string; itemId: string; planGroup: string };
}

// AS-IS GetBODItem 팝업 그리드(03 §5-7) — retList 다건 cascade.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'BOD_ID', colLblNm: 'BOD ID', colWth: 90, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'FROM_SITE_NAME', colLblNm: 'From Site', colWth: 130, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'TO_SITE_NAME', colLblNm: 'To Site', colWth: 130, horzAlgnCd: 'L', visible: true, display: true },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 80, horzAlgnCd: 'C', visible: true, display: true },
  { colNm: 'TRANSPORT_MODE', colLblNm: 'Trans Mode', colWth: 90, horzAlgnCd: 'C', visible: true, display: true },
];

/**
 * GetBODItem 팝업(로컬) — Excluded BOD_ID 셀 더블클릭(03 §5-7). retList 다건 선택 → 신규행 cascade 채움.
 * 주의: 조회 SP(bodPopup)는 PKG_SCP0030 에 미배포(convert-sp 후속) — 배선 완비, 런타임 데이터는 SP 배포 후.
 */
export const GetBodItemModal = ({ open, modalClose, setSelectedValue, preSearchParams }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<BodPopupRow>>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const [filters, setFilters] = useState<ProcRequest<MENU_ID, typeof POPUP_SHEET.BOD> | undefined>(
    undefined
  );

  useEffect(() => {
    if (!open) return;
    setFilters({
      divisionId: preSearchParams.divisionId ?? '',
      itemId: preSearchParams.itemId ?? '',
      planGroup: preSearchParams.planGroup ?? '',
    });
  }, [open, preSearchParams.divisionId, preSearchParams.itemId, preSearchParams.planGroup]);

  const { data, isLoading, isFetching } = useTabProcQuery<MENU_ID, typeof POPUP_SHEET.BOD>({
    menuId: MENU_ID,
    sheetName: POPUP_SHEET.BOD,
    tabId: 'SCP0030_GetBodItemModal',
    filters,
    enabled: open && !!filters,
  });
  const loading = isLoading || isFetching;

  const rows = useMemo(() => withRowNo((data?.o_rc1 ?? []) as unknown as BodPopupRow[]), [data]);
  const staticColumns = useMemo(
    () => [buildNoColumn(t('LBL00674', { defaultValue: 'No' })), ...POPUP_COLUMNS],
    [t]
  );

  const handleSubmit = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selections = (grid.selectedItems ?? []) as unknown as BodPopupRow[];
    if (selections.length === 0) return;
    setSelectedValue(selections);
    modalClose();
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row) as BodPopupRow | undefined;
    if (!dataItem) return;
    setSelectedValue([dataItem]);
    modalClose();
  };

  return (
    <CustomDialog
      size={640}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00343', { defaultValue: 'BOD Item' })}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<BodPopupRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                useCheckbox
                staticColumns={staticColumns}
                itemsSource={rows}
                dblClick={handleDblClick}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              priority='primary'
              size='medium'
              onClick={handleSubmit}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
