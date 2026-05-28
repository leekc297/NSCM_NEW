import type { FlexGrid } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import _ from 'lodash';
import { useEffect, useRef, useState } from 'react';

import { i18n } from '@foundation/i18n';
import { GridUtils } from '@foundation/utils';
import { CustomDropdown, DataGrid, SearchArea, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { FormItem, InputField, type DialogNavigationSize } from '@shared/lges';
import { Grid } from '@shared/mui';

import { SHEETS, POPUP_ID } from './message-modal.constants';
import styles from './MessageModal.module.scss';
import { useMessageModalStore } from './useMessageModalStore';

interface MessageModalProps {
  size?: DialogNavigationSize;
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (messageId: string, message: string) => void;
  initialType?: string;
  initialMessage?: string;
  messageTypeFilters?: string[];
}

export const MessageModal = ({
  size = 800,
  open,
  modalClose,
  setSelectedValue,
  initialType = 'LBL',
  initialMessage = '',
  messageTypeFilters,
}: MessageModalProps) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<POPUP_ID, SHEETS.MESSAGE>> | undefined>();

  const initialized = useMessageModalStore(state => state.initialized);
  const staticColumns = useMessageModalStore(state => state.staticColumns);
  const fetchStaticColumns = useMessageModalStore(state => state.fetchStaticColumns);

  const [messageTypeData] = useTabComboQueries({ filters: ['MessageType'] });
  const [modalFilters, setModalFilters] = useState<{
    type: string;
    message: string;
  }>({
    type: initialType,
    message: initialMessage,
  });

  const { data } = useTabProcQuery<POPUP_ID, SHEETS.MESSAGE>({
    menuId: POPUP_ID,
    sheetName: SHEETS.MESSAGE,
    tabId: POPUP_ID,
    filters: undefined,
    enabled: true,
  });

  const itemsSource = (data?.o_rc ?? []).filter(
    message =>
      message.MSG_TP_CD === modalFilters.type &&
      ((message.MSG_NM_KO ?? '').toLowerCase().includes(modalFilters.message.toLowerCase()) ||
        (message.MSG_NM_EN ?? '').toLowerCase().includes(modalFilters.message.toLowerCase()) ||
        (message.MSG_NM_CN ?? '').toLowerCase().includes(modalFilters.message.toLowerCase()))
  );

  const handleFilterChange = _.debounce((type: string, message: string) => {
    setModalFilters({
      type: type,
      message: message,
    });
  }, 50);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    let messageName = '';
    switch (i18n.language) {
      case 'KO':
        messageName = dataItem.MSG_NM_KO;
        break;
      case 'EN':
        messageName = dataItem.MSG_NM_EN;
        break;
      case 'CN':
        messageName = dataItem.MSG_NM_CN;
        break;
    }

    setSelectedValue(dataItem.MSG_ID, messageName);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setModalFilters({
      type: initialType,
      message: initialMessage,
    });
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  return (
    <CustomDialog
      size={size}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00354', '_Message Popup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00112', '_Search')}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00052', '_Type')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        isInput={false}
                        value={initialType}
                        options={
                          messageTypeData
                            ?.filter(
                              item => !messageTypeFilters || messageTypeFilters.includes(item.CODE)
                            )
                            ?.sort((a, b) => Number(a.SORT_ORD) - Number(b.SORT_ORD))
                            ?.map(item => ({
                              label: t(item.NAME, item.DESC),
                              value: item.CODE,
                            })) ?? []
                        }
                        onChange={(_, option) => handleFilterChange(option, modalFilters.message)}
                      />
                    )}
                  />
                </Grid>
                <Grid size={6}>
                  <FormItem
                    label={t('MNU00060', '_Message')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        defaultValue={initialMessage}
                        onChange={event =>
                          handleFilterChange(modalFilters.type, event.target.value)
                        }
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<POPUP_ID, SHEETS.MESSAGE>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={handleDblClick}
            />
          </div>
        </div>
      }
    />
  );
};
