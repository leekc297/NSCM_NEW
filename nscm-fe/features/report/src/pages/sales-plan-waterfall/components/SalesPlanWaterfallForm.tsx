import {
  DivisionField,
  EndCustomerField,
  ItemByDivisionModal,
  OwnerByDivisionModal,
  PeriodField,
  PlantSiteField,
  ProjectByDivisionModal,
  SalesSiteField,
  TeamField,
} from 'features/master/src/components';
import { useEffect, useState } from 'react';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
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
  // 2026-08-22 콤보 통일 — Div / Team / End Customer / Sales Site / Plant Site 는 SearchFields
  //   카탈로그 필드가 각자 조회한다 (MyDivision / TeambyDivision / EndCustomer / SalesSite /
  //   PlantSitebyEndCustomer). 종전 'UserTeamByDivision' / 'EndCustomerByDivision' /
  //   'UserSiteByEndCustomer' / 'UserPlantSiteByEndCustomer' 원천 스왑은 폐지했다.
  const [bizType, salesPlanAmountKrw, salesPlanAmountUsd, salesPlanAmountLoc] = useTabComboQueries({
    filters: ['BizType', 'SALES_PLAN_AMOUNT_KRW', 'SALES_PLAN_AMOUNT_USD', 'SALES_PLAN_AMOUNT_LOC'],
  });

  // 스토어는 콤마조인 문자열 — 카탈로그 필드와 cascade 입력은 배열이다.
  const toList = (v: string): string[] => (v ? v.split(',').filter(Boolean) : []);
  const selTeams = toList(searchParams.team);
  const selEndCustomers = toList(searchParams.endCustomer);

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
            <DivisionField
              gridSize={3}
              value={searchParams.divisionId}
              onChange={option =>
                setSearchParams({
                  divisionId: option,
                  team: '',
                  endCustomer: '',
                  salesSite: '',
                  bizType: '',
                  plantSiteId: '',
                })
              }
            />
            <TeamField
              gridSize={3}
              division={searchParams.divisionId}
              value={selTeams}
              onChange={v =>
                // Team 은 End Customer / Sales Site cascade 의 DEPT_ID 단계라 하위를 비운다.
                setSearchParams({
                  team: v.join(','),
                  endCustomer: '',
                  salesSite: '',
                  plantSiteId: '',
                })
              }
            />
            {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
                여기엔 Team(DEPT_ID) 단계만 넘긴다.
                필수: strict. 'EndCustomer' 콤보는 DEPT_ID 공란 행이 대다수라(SITE_ITEM LEFT OUTER
                  JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다. */}
            <EndCustomerField
              gridSize={3}
              division={searchParams.divisionId}
              cascade={{ DEPT_ID: { values: selTeams, strict: true } }}
              value={selEndCustomers}
              onChange={v =>
                setSearchParams({ endCustomer: v.join(','), salesSite: '', plantSiteId: '' })
              }
            />
            {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
                End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 종전 'UserSiteByEndCustomer'
                  가 내려주던 END_CUSTOMER 컬럼을 'SalesSite' 콤보는 내려주지 않는다.
                  DMF0003 / DMF0014 와 동일한 매핑이다.
                DEPT_ID 는 엄격, PROJECT_CODE 는 관대 — PROJECT_CODE 가 NULL 인 행이 정상적으로
                  존재해 자르면 목록이 통째로 비어버린다. */}
            <SalesSiteField
              gridSize={3}
              division={searchParams.divisionId}
              cascade={{
                DEPT_ID: { values: selTeams, strict: true },
                PROJECT_CODE: selEndCustomers,
              }}
              value={toList(searchParams.salesSite)}
              onChange={v => setSearchParams({ salesSite: v.join(',') })}
            />
            {/* Row B — Ver. / Period / Bucket (+ inline Sum/Color/Cell Qty) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
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
            {/* 공용 카탈로그 PeriodField(@master/searchFields) — SalesPrice 등 타 화면과 동일 DateRange. */}
            {/* store 는 [Dayjs, Dayjs] 유지 — YYYYMMDD 문자열 ↔ dayjs 변환. */}
            <PeriodField
              gridSize={3}
              start={
                searchParams.period?.[0] ? dayjs(searchParams.period[0]).format('YYYYMMDD') : ''
              }
              end={searchParams.period?.[1] ? dayjs(searchParams.period[1]).format('YYYYMMDD') : ''}
              onChange={(start, end) =>
                setSearchParams({
                  period: [
                    dayjs(`${start.slice(0, 4)}-${start.slice(4, 6)}-${start.slice(6, 8)}`),
                    dayjs(`${end.slice(0, 4)}-${end.slice(4, 6)}-${end.slice(6, 8)}`),
                  ],
                })
              }
            />
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
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
                className={commonStyles.formItem}
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
                className={commonStyles.formItem}
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
                className={commonStyles.formItem}
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
                className={commonStyles.formItem}
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
                className={commonStyles.formItem}
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
                className={commonStyles.formItem}
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
                className={commonStyles.formItem}
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
            {/* Plant Site — 카탈로그 PlantSiteField (콤보 'PlantSitebyEndCustomer' — 2026-08-22
                콤보 통일. 종전 'UserPlantSiteByEndCustomer' 는 폐지). Division + End Customer
                cascade 는 카탈로그가 클라이언트에서 건다.
                disabled={false} — 카탈로그 기본 게이트는 81 계열 전용이지만 이 화면은
                종전부터 전 division 활성이다. 활성 기준은 콤보 통일 대상이 아니라 그대로 둔다. */}
            <PlantSiteField
              gridSize={3}
              division={searchParams.divisionId}
              endCustomer={searchParams.endCustomer || undefined}
              disabled={false}
              value={toList(searchParams.plantSiteId)}
              onChange={v => setSearchParams({ plantSiteId: v.join(',') })}
            />
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
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
                className={commonStyles.formItem}
                label={t('LBL00618', '_Model/Nickname')}
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
