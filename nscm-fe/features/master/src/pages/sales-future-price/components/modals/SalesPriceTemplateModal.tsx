import { type FlexGrid } from '@mescius/wijmo.grid';
import { useRef } from 'react';

import { CustomDialog, DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';
import { Stack } from '@shared/mui';

import { MENU_ID } from '../../sales-future-price.constants';

import styles from './SalesPriceTemplateModal.module.scss';

interface SalesPriceTemplateModalProps {
  open: boolean;
  modalClose: () => void;
}

const SHEET_NM = 'salesPriceTemplate' as never;

export const SalesPriceTemplateModal = ({ open, modalClose }: SalesPriceTemplateModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<WijmoRowItem>>();

  const { data } = useTabProcQuery({
    menuId: MENU_ID as MenuId,
    sheetName: SHEET_NM,
    tabId: 'sales-price-template-modal',
    filters: {} as never,
    enabled: open,
  });

  return (
    <CustomDialog
      size={800}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00096', '_Sales Price Template')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.gridWrapper}>
            <DataGrid<WijmoRowItem>
              gridRef={gridRef}
              isReadOnly
              staticColumns={[]}
              itemsSource={(data?.o_rc as WijmoRowItem[] | undefined) ?? []}
            />
          </div>
          <Stack direction='row' spacing={1} className={styles.actionBar}>
            <Button appearance='outlined' priority='normal' onClick={modalClose}>
              {t('LBL00103', '_Close')}
            </Button>
          </Stack>
        </div>
      }
    />
  );
};
