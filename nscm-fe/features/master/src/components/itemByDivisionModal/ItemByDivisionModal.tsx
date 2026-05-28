import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef, useState } from 'react';

import _ from '@foundation/lodash';
import { GridUtils } from '@foundation/utils';
import { CustomDropdown, SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  MODAL_ITEM_BY_DIVISION,
  MODAL_SHEET_ITEM_BY_DIVISION,
} from './item-by-division-modal.constants';
import styles from './ItemByDivisionModal.module.scss';
import { useItemByDivisionModalStore } from './itemByDivisionModalStore';

interface ItemByDivisionModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (items: string, itemName?: string, itemType?: string) => void;
  preSearchParams: ProcRequest<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>;
  callFromCell: boolean;
}

export const ItemByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  callFromCell,
}: ItemByDivisionModalProps) => {
  const { t } = useTranslation();

  const gridRef =
    useRef<FlexGrid<ResponseData<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION, 'o_rc1'>>>();

  const initialized = useItemByDivisionModalStore(state => state.initialized);
  const staticColumns = useItemByDivisionModalStore(state => state.staticColumns);
  const divisionId = useItemByDivisionModalStore(state => state.divisionId);
  const fetchStaticColumns = useItemByDivisionModalStore(state => state.fetchStaticColumns);

  const [divisions, teams, endCustomers, salesSites] = useTabComboQueries({
    filters: ['MyDivision', 'TeambyDivision', 'EndCustomer', 'SalesSite'],
  });

  const [searchParam, setSearchParam] = useState<
    ProcRequest<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>
  >({} as ProcRequest<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>);
  const [itemId, setItemId] = useState<string>();

  const [modalFilters, setModalFilters] = useState<{
    itemId: string;
  }>({
    itemId: '',
  });

  const { data: itemData } = useTabProcQuery<MODAL_ITEM_BY_DIVISION>({
    menuId: MODAL_ITEM_BY_DIVISION,
    sheetName: MODAL_SHEET_ITEM_BY_DIVISION,
    tabId: 'ItemByDivisionModal',
    filters: searchParam,
    enabled: open,
  });

  const itemsSource = (itemData?.o_rc1 ?? []).filter(
    item =>
      (item.ITEM_ID ?? '').toLowerCase().includes(modalFilters.itemId.toLowerCase()) ||
      (item.ITEM_NAME ?? '').toLowerCase().includes(modalFilters.itemId.toLowerCase()) ||
      (item.NICK_NAME ?? '').toLowerCase().includes(modalFilters.itemId.toLowerCase())
  );

  const handleItemChange = _.debounce((items: string) => {
    setModalFilters({
      itemId: items,
    });
  }, 50);

  const handleSubmit = () => {
    const selections = gridRef.current?.selectedItems as ResponseData<
      MODAL_ITEM_BY_DIVISION,
      MODAL_SHEET_ITEM_BY_DIVISION,
      'o_rc1'
    >[];

    if (!selections) return;

    const items = selections.map(item => item.ITEM_ID).join(',');

    setSelectedValue(items);
    modalClose();
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    setSelectedValue(dataItem.ITEM_ID, dataItem.ITEM_NAME, dataItem.ITEM_CLASS_NAME);
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    setSearchParam({
      divisionId: preSearchParams.divisionId,
      deptId: callFromCell ? 'ALL' : preSearchParams.deptId,
      endCustomer: callFromCell ? 'ALL' : preSearchParams.endCustomer,
      salesSite: callFromCell ? 'ALL' : preSearchParams.salesSite,
      projectCode: callFromCell ? '' : preSearchParams.projectCode,
      itemId: '',
    });
    setModalFilters({ itemId: preSearchParams.itemId ?? '' });
    setItemId(preSearchParams.itemId);
    if (!initialized || preSearchParams.divisionId !== divisionId)
      void fetchStaticColumns(preSearchParams.divisionId);
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
          <h2 className='headerTitle'>{t('LBL00343', '_ItemByDivisionPopup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00001', '_Div.')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        mandatory
                        disabled
                        value={searchParam?.divisionId ?? ''}
                        options={
                          divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                        }
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00044', '_Team')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        mandatory
                        multiple
                        disabled
                        limitTags={1}
                        value={searchParam.deptId}
                        options={[
                          ...new Map(
                            (teams ?? [])
                              .filter(item => item.DIVISION_ID === searchParam.divisionId)
                              .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                          ).values(),
                        ].map(item => ({ label: item.NAME, value: item.CODE }))}
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00080', '_End Customer')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        disabled
                        limitTags={1}
                        value={searchParam.endCustomer}
                        options={
                          [
                            ...new Map(
                              endCustomers
                                ?.filter(
                                  item =>
                                    item.DIVISION_ID === searchParam.divisionId &&
                                    (searchParam.deptId === 'ALL' ||
                                      searchParam.deptId?.split(',').includes(item.DEPT_ID))
                                )
                                .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                            ).values(),
                          ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                        }
                      />
                    )}
                  />
                </Grid>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00011', '_Sales Site')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        multiple
                        disabled
                        limitTags={1}
                        value={searchParam.salesSite}
                        options={[
                          ...new Map(
                            (salesSites ?? [])
                              .filter(
                                item =>
                                  item.DIVISION_ID === searchParam.divisionId &&
                                  (searchParam.deptId === 'ALL' ||
                                    searchParam.deptId?.split(',').includes(item.DEPT_ID))
                              )
                              .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                          ).values(),
                        ].map(item => ({ label: item.NAME, value: item.CODE }))}
                      />
                    )}
                  />
                </Grid>
                {searchParam.divisionId !== '40' && (
                  <Grid size={4}>
                    <FormItem
                      label={t('LBL00327', '_Project')}
                      labelAlign='right'
                      render={() => (
                        <InputField fullWidth disabled value={searchParam.projectCode ?? ''} />
                      )}
                    />
                  </Grid>
                )}
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00003', '_Model/Nickname')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={itemId ?? ''}
                        onChange={e => {
                          setItemId(e.target.value);
                          handleItemChange(e.target.value);
                        }}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_ITEM_BY_DIVISION, MODAL_SHEET_ITEM_BY_DIVISION>>
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
