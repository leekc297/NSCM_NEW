import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { GridUtils } from '@foundation/utils';
import { CustomDropdown, SearchArea, DataGrid, CustomDialog } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  MODAL_OWNER_BY_DIVISION,
  MODAL_SHEET_OWNER_BY_DIVISION,
} from './owner-by-division-modal.constants';
import styles from './OwnerByDivisionModal.module.scss';
import { useOwnerByDivisionModalStore } from './ownerByDivisionModalStore';

interface OwnerByDivisionModalProps {
  open: boolean;
  modalClose: () => void;
  // DMF0008 (2026-07-08): cell dblClick 시 OWNER(코드) + USER_NM(이름) 자동 채움 의무 — optional 추가 인자
  setSelectedValue: (owners: string, ownerNames?: string) => void;
  preSearchParams: ProcRequest<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION>;
  ownerId?: string;
  // ⭐ 멀티 선택 모드(옵션). true 시 체크박스 컬럼으로 선택(재기동 시 carry/프리체크 없음).
  multiCheckbox?: boolean;
}

interface OwnerComboOption {
  CODE: string;
  NAME: string;
  DIVISION_ID?: string;
  DEPT_ID?: string;
}

export const OwnerByDivisionModal = ({
  open,
  modalClose,
  setSelectedValue,
  preSearchParams,
  ownerId = undefined,
  multiCheckbox = false,
}: OwnerByDivisionModalProps) => {
  const { t } = useTranslation();

  const gridRef =
    useRef<
      FlexGrid<ResponseData<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION, 'o_rc1'>>
    >();

  const initialized = useOwnerByDivisionModalStore(state => state.initialized);
  const staticColumns = useOwnerByDivisionModalStore(state => state.staticColumns);
  const fetchStaticColumns = useOwnerByDivisionModalStore(state => state.fetchStaticColumns);

  const [divisions, teams, endCustomers, endCustomers40, salesSites] = useTabComboQueries({
    filters: [
      'MyDivision',
      'TeambyDivision',
      'EndCustomer',
      'EndCustomerByDivision40',
      'SalesSite',
    ],
  });

  const [searchParam, setSearchParam] = useState<
    ProcRequest<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION>
  >({} as ProcRequest<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION>);
  const ownerEndCustomers = (searchParam.divisionId === '40' ? endCustomers40 : endCustomers) as
    | OwnerComboOption[]
    | undefined;

  const [modalFilters, setModalFilters] = useState<{
    owner: string;
  }>({ owner: '' });
  const [ownerKeyword, setOwnerKeyword] = useState('');

  const { data: ownerData } = useTabProcQuery<MODAL_OWNER_BY_DIVISION>({
    menuId: MODAL_OWNER_BY_DIVISION,
    sheetName: MODAL_SHEET_OWNER_BY_DIVISION,
    tabId: 'OwnerByDivisionModal',
    filters: searchParam,
    enabled: open,
  });

  // useMemo — 매 렌더 새 배열이면 그리드 re-bind 로 체크박스 선택(row.isSelected)이 풀림.
  const itemsSource = useMemo(
    () =>
      (ownerData?.o_rc1 ?? []).filter(owner =>
        (owner.OWNER ?? '').toLowerCase().includes(modalFilters.owner.toLowerCase())
      ),
    [ownerData, modalFilters]
  );

  // 자동필터 해제 — Search 버튼/Enter 시에만 modalFilters 반영 (입력 중 즉시필터 안 함).
  const handleSearch = () => setModalFilters({ owner: ownerKeyword });

  const handleSubmit = () => {
    if (multiCheckbox) {
      // 체크박스 모드 — 체크된(row.isSelected) 행의 OWNER(코드) + USER_NM(이름) 수집.
      const grid = gridRef.current;
      if (!grid) return;
      const ids: string[] = [];
      const names: string[] = [];
      for (const row of grid.rows) {
        const it = row?.dataItem as { OWNER?: string; USER_NM?: string } | undefined;
        if (row?.isSelected && it?.OWNER) {
          ids.push(it.OWNER);
          names.push(it.USER_NM ?? '');
        }
      }
      setSelectedValue(ids.join(','), names.join(','));
      modalClose();
      return;
    }

    const selections = gridRef.current?.selectedItems as ResponseData<
      MODAL_OWNER_BY_DIVISION,
      MODAL_SHEET_OWNER_BY_DIVISION,
      'o_rc1'
    >[];

    if (!selections) return;

    const owners = selections.map(item => item.OWNER).join(',');
    const ownerNames = selections.map(item => item.USER_NM ?? '').join(',');

    setSelectedValue(owners, ownerNames);
    modalClose();
  };

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    if (!dataItem) return;

    setSelectedValue(dataItem.OWNER, dataItem.USER_NM ?? '');
    modalClose();
  };

  useEffect(() => {
    if (!open) return;
    // ownerId 가 undefined 일 때 preSearchParams.owner fallback — DMF0005 가 prop 생략해도
    // 호출 화면의 owner 검색조건이 modal filter 로 반영됨. feat/dmf0020-sales-future-price
    // 머지 시 동일 패턴이라 conflict 0 + DMF0005 ownerId prop 주석 사고 사전 차단.
    setModalFilters({ owner: ownerId ?? preSearchParams.owner ?? '' });
    setOwnerKeyword(ownerId ?? preSearchParams.owner ?? '');
    setSearchParam({ ...preSearchParams, owner: '' });
    if (!initialized) void fetchStaticColumns();
  }, [open]);

  return (
    <CustomDialog
      size={1200}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00336', '_OwnerByDivisionPopup')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleSearch}
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
                              ownerEndCustomers
                                ?.filter(
                                  item =>
                                    searchParam.divisionId === '40' ||
                                    (item.DIVISION_ID === searchParam.divisionId &&
                                      (searchParam.deptId === 'ALL' ||
                                        searchParam.deptId
                                          ?.split(',')
                                          .includes(item.DEPT_ID ?? '')))
                                )
                                .map(item => [`${item.DIVISION_ID ?? '40'}|${item.CODE}`, item])
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
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00082', '_Owner')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={ownerKeyword}
                        onChange={e => setOwnerKeyword(e.target.value)}
                        onKeyDown={e => e.key === 'Enter' && handleSearch()}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid<ResponseData<MODAL_OWNER_BY_DIVISION, MODAL_SHEET_OWNER_BY_DIVISION, 'o_rc1'>>
              gridRef={gridRef}
              isReadOnly
              useCheckbox={multiCheckbox}
              staticColumns={staticColumns}
              itemsSource={itemsSource}
              dblClick={multiCheckbox ? undefined : handleDblClick}
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
