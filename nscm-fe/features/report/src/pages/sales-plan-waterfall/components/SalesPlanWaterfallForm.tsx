import {
  ItemByDivisionModal,
  OwnerByDivisionModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useEffect, useState } from 'react';

import dayjs from '@foundation/dayjs';
import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';

import { BUCKET_TYPE } from '../sales-plan-waterfall.constants';
import { useSalesPlanWaterfallStore } from '../useSalesPlanWaterfallStore';

import styles from './SalesPlanWaterfallForm.module.scss';

interface SalesPlanWaterfallFormProps {
  onSubmit: () => void;
}

export const SalesPlanWaterfallForm = ({ onSubmit }: SalesPlanWaterfallFormProps) => {
  const { t } = useTranslation();

  const searchParams = useSalesPlanWaterfallStore(state => state.searchParams);
  const setSearchParams = useSalesPlanWaterfallStore(state => state.setSearchParams);
  const isOpenSearchArea = useSalesPlanWaterfallStore(state => state.isOpenSearchArea);

  const [openProjectModal, setOpenProjectModal] = useState<boolean>(false);
  const [openItemModal, setOpenItemModal] = useState<boolean>(false);
  const [openOwnerModal, setOpenOwnerModal] = useState<boolean>(false);
  const [openVersionModal, setOpenVersionModal] = useState<boolean>(false);

  useEffect(() => {
    if (searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY && searchParams.isSumChecked) {
      setSearchParams({ isSumChecked: false });
    }
  }, [searchParams.bucket, searchParams.isSumChecked, setSearchParams]);

  const isOnlyWeekly = searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY;
  const isDivision40 = searchParams.divisionId === '40';

  // TODO(F8): Combo IDs PascalCase 보존 — BE /combo 메타 확정 후 표기 교체 가능
  const [
    myDivision,
    userTeamByDivision,
    endCustomerByDivision,
    userSiteByEndCustomer,
    bizType,
    userPlantSiteByEndCustomer,
    salesPlanAmountKrw,
    salesPlanAmountUsd,
    salesPlanAmountLoc,
  ] = useTabComboQueries({
    filters: [
      'MyDivision',
      'UserTeamByDivision',
      'EndCustomerByDivision',
      'UserSiteByEndCustomer',
      'BizType',
      'UserPlantSiteByEndCustomer',
      'SALES_PLAN_AMOUNT_KRW',
      'SALES_PLAN_AMOUNT_USD',
      'SALES_PLAN_AMOUNT_LOC',
    ],
  });

  // TODO(F1): DMF0073_VersionBySalesPricePopup 신규 모달 — 카탈로그 미구현
  // TODO(F4/F5): Cell Qty / Internal Txn 체크박스는 layout.md 따라 emit (C# Visible=false 차이)

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!isOpenSearchArea}
        conditions={
          <>
            {/* Row A — Div / Team / End Customer / Sales Site */}
            <Grid size={3}>
              <FormItem
                label={t('LBL00001', '_Div.')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    mandatory
                    value={searchParams.divisionId}
                    options={
                      myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, option) => {
                      setSearchParams({
                        divisionId: option,
                        team: '',
                        endCustomer: '',
                        salesSite: '',
                        bizType: '',
                        plantSiteId: '',
                      });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00044', '_Team')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={searchParams.team}
                    options={
                      userTeamByDivision
                        ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                        .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, options) => {
                      setSearchParams({ team: options });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00080', '_End Customer')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={searchParams.endCustomer}
                    options={
                      endCustomerByDivision
                        ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                        .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, options) => {
                      setSearchParams({ endCustomer: options, salesSite: '', plantSiteId: '' });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={searchParams.salesSite}
                    options={
                      userSiteByEndCustomer
                        ?.filter(
                          item =>
                            item.DIVISION_ID === searchParams.divisionId &&
                            (!searchParams.endCustomer ||
                              String(item.END_CUSTOMER ?? '')
                                .split(',')
                                .some(ec =>
                                  String(searchParams.endCustomer).split(',').includes(ec)
                                ))
                        )
                        .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, options) => {
                      setSearchParams({ salesSite: options });
                    }}
                  />
                )}
              />
            </Grid>
            {/* Row B — Ver. / Period / Bucket (+ inline Sum/Color/Cell Qty) */}
            <Grid size={3}>
              <FormItem
                label={t('LBL00031', '_Ver.')}
                labelAlign='right'
                required
                render={() => (
                  <InputField
                    fullWidth
                    className={clsx(styles.inputWithSearch, styles.input)}
                    value={searchParams.versionType}
                    onChange={event => setSearchParams({ versionType: event.target.value })}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenVersionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onKeyDown={() => setOpenVersionModal(true)}
                    onDoubleClick={() => setOpenVersionModal(true)}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00013', '_Period')}
                labelAlign='right'
                required
                render={() => (
                  <DatePickerCalendar
                    sx={{ width: '100%' }}
                    usecase='date-range-multi'
                    elevation
                    size='large'
                    value={[dayjs(searchParams.period[0]), dayjs(searchParams.period[1])]}
                    onChange={date => {
                      setSearchParams({ period: date });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00032', '_Bucket')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={searchParams.bucket}
                    // TODO(F7): SHEETS.BUCKET_TYPE useTabProcQuery 연결
                    options={[]}
                    onChange={(_, option) => {
                      setSearchParams({ bucket: option });
                    }}
                  />
                )}
              />
            </Grid>
            {/* Bucket inline group — Sum / Color / Cell Qty */}
            <Grid size={3} sx={{ display: 'flex', alignItems: 'center' }}>
              <Stack direction='row' spacing={1} alignItems='center' sx={{ width: '100%' }}>
                <Checkbox
                  labelText={t('', '_Sum')}
                  checked={searchParams.isSumChecked}
                  disabled={isOnlyWeekly}
                  onChange={checked => setSearchParams({ isSumChecked: checked })}
                />
                <Checkbox
                  labelText={t('', '_Color')}
                  checked={searchParams.isColorChecked}
                  onChange={checked => setSearchParams({ isColorChecked: checked })}
                />
                <Checkbox
                  labelText={t('', '_Cell Qty')}
                  checked={searchParams.isCellQtyChecked}
                  disabled={!isDivision40}
                  onChange={checked => setSearchParams({ isCellQtyChecked: checked })}
                />
              </Stack>
            </Grid>
          </>
        }
        extraConditions={
          <>
            {/* Row C — KRW / USD / LOC / QTY */}
            <Grid size={3}>
              <FormItem
                label={t('', '_KRW')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={searchParams.krw}
                    options={
                      salesPlanAmountKrw?.map(item => ({
                        label: item.NAME,
                        value: item.CODE,
                      })) ?? []
                    }
                    onChange={(_, option) => {
                      setSearchParams({ krw: option });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('', '_USD')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={searchParams.usd}
                    options={
                      salesPlanAmountUsd?.map(item => ({
                        label: item.NAME,
                        value: item.CODE,
                      })) ?? []
                    }
                    onChange={(_, option) => {
                      setSearchParams({ usd: option });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('', '_LOC')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={searchParams.loc}
                    options={
                      salesPlanAmountLoc?.map(item => ({
                        label: item.NAME,
                        value: item.CODE,
                      })) ?? []
                    }
                    onChange={(_, option) => {
                      setSearchParams({ loc: option });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('', '_QTY')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={searchParams.qty}
                    // TODO(F7): SHEETS.QTY_TYPE useTabProcQuery 연결
                    options={[]}
                    onChange={(_, option) => {
                      setSearchParams({ qty: option });
                    }}
                  />
                )}
              />
            </Grid>
            {/* Row D — PJT / Item Type / Biz. Type (+ inline Internal Txn) */}
            <Grid size={3}>
              <FormItem
                label={t('', '_PJT')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={clsx(styles.inputWithSearch, styles.input)}
                    value={searchParams.projectCode}
                    onChange={event => setSearchParams({ projectCode: event.target.value })}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenProjectModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onKeyDown={() => setOpenProjectModal(true)}
                    onDoubleClick={() => setOpenProjectModal(true)}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('', '_Item Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={searchParams.itemType}
                    // TODO(F7): SHEETS.ITEM_TYPE_LOOKUP useTabProcQuery 연결
                    options={[]}
                    onChange={(_, options) => {
                      setSearchParams({ itemType: options });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00085', '_Biz. Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={searchParams.bizType}
                    options={
                      bizType
                        ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                        .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, options) => {
                      setSearchParams({ bizType: options });
                    }}
                  />
                )}
              />
            </Grid>
            {/* Biz. Type inline group — Include Internal Txn */}
            <Grid size={3} sx={{ display: 'flex', alignItems: 'center' }}>
              <Stack direction='row' spacing={1} alignItems='center' sx={{ width: '100%' }}>
                <Checkbox
                  labelText={t('', '_Include Internal Txn')}
                  checked={searchParams.isInternalChecked}
                  onChange={checked => setSearchParams({ isInternalChecked: checked })}
                />
              </Stack>
            </Grid>
            {/* Row E — Plant Site / Owner / Model/Nickname */}
            <Grid size={3}>
              <FormItem
                label={t('', '_Plant Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={searchParams.plantSiteId}
                    options={
                      userPlantSiteByEndCustomer
                        ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                        .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, options) => {
                      setSearchParams({ plantSiteId: options });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('', '_Owner')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={clsx(styles.inputWithSearch, styles.input)}
                    value={searchParams.owner}
                    onChange={event => setSearchParams({ owner: event.target.value })}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenOwnerModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onDoubleClick={() => setOpenOwnerModal(true)}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00003', '_Model/Nickname')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={clsx(styles.inputWithSearch, styles.input)}
                    value={searchParams.itemId}
                    onChange={event => setSearchParams({ itemId: event.target.value })}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenItemModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onKeyDown={() => setOpenItemModal(true)}
                    onDoubleClick={() => setOpenItemModal(true)}
                  />
                )}
              />
            </Grid>
          </>
        }
        onSearch={onSubmit}
      />
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={projects => setSearchParams({ projectCode: projects })}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          deptId: searchParams.team,
          endCustomer: searchParams.endCustomer,
          salesSite: searchParams.salesSite,
          projectCode: searchParams.projectCode,
        }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => setSearchParams({ itemId: items })}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          deptId: searchParams.team,
          endCustomer: searchParams.endCustomer,
          salesSite: searchParams.salesSite,
          projectCode: searchParams.projectCode,
          itemId: searchParams.itemId,
        }}
        callFromCell={false}
      />
      <OwnerByDivisionModal
        open={openOwnerModal}
        modalClose={() => setOpenOwnerModal(false)}
        setSelectedValue={owners => setSearchParams({ owner: owners })}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          deptId: searchParams.team,
          endCustomer: searchParams.endCustomer,
          projectCode: searchParams.projectCode,
          salesSite: searchParams.salesSite,
          owner: searchParams.owner,
        }}
        ownerId={searchParams.owner}
      />
      {/* TODO(F1): DMF0073_VersionBySalesPricePopup 신규 모달 (카탈로그 미구현) */}
      {openVersionModal && null}
    </>
  );
};
