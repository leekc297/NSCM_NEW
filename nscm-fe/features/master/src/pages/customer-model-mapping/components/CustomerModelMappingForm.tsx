import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import { DIVISION_NO_PROJECT } from '../customer-model-mapping.constants';
import { useCustomerModelMappingStore } from '../useCustomerModelMappingStore';

export const CustomerModelMappingForm = () => {
  const { t } = useTranslation();

  const searchParams = useCustomerModelMappingStore(state => state.searchParams);
  const setSearchParams = useCustomerModelMappingStore(state => state.setSearchParams);
  const setFilters = useCustomerModelMappingStore(state => state.setFilters);
  const isOpenSearchArea = useCustomerModelMappingStore(state => state.isOpenSearchArea);

  // Division 40 은 Project 개념이 없어 조회조건 Project 를 잠근다 (입력·팝업 모두).
  const isProjectDisabled = searchParams.divisionId === DIVISION_NO_PROJECT;

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);

  const [myDivision, teambyDivision, endCustomer, salesSite, yesOrNo] = useTabComboQueries({
    filters: ['MyDivision', 'TeambyDivision', 'EndCustomer', 'SalesSite', 'YesOrNo'],
  });

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        onSearch={setFilters}
        isHidden={!isOpenSearchArea}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                label={t('LBL00001', '_Div.')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={
                      myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, option) => {
                      // Project 코드는 Division 소속 값이라 Division 이 바뀌면 초기화한다
                      //   (40 으로 바꿀 때 잠긴 칸에 이전 값이 남아 조회에 실려 가는 것도 함께 막힌다).
                      setSearchParams({ divisionId: option, projectCode: '' });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00044', '_Team')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    value={searchParams.deptId}
                    allOption
                    useClearIcon
                    multiple
                    options={[
                      ...new Map(
                        (teambyDivision ?? [])
                          .filter(item => item.DIVISION_ID === searchParams.divisionId)
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE }))}
                    onChange={(_, option) => {
                      setSearchParams({ deptId: option });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00080', '_End Customer')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    value={searchParams.endCustomer}
                    multiple
                    allOption
                    useClearIcon
                    options={
                      [
                        ...new Map(
                          endCustomer
                            ?.filter(
                              item =>
                                item.DIVISION_ID === searchParams.divisionId &&
                                (searchParams.deptId === 'ALL' ||
                                  searchParams.deptId.split(',').includes(item.DEPT_ID))
                            )
                            .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                        ).values(),
                      ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, options) => {
                      setSearchParams({ endCustomer: options });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    value={searchParams.salesSite}
                    multiple
                    allOption
                    useClearIcon
                    options={[
                      ...new Map(
                        (salesSite ?? [])
                          .filter(
                            item =>
                              item.DIVISION_ID === searchParams.divisionId &&
                              (searchParams.deptId === 'ALL' ||
                                searchParams.deptId.split(',').includes(item.DEPT_ID))
                          )
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE }))}
                    onChange={(_, options) => {
                      setSearchParams({ salesSite: options });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00617', '_Project')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    disabled={isProjectDisabled}
                    value={searchParams.projectCode}
                    onChange={event => setSearchParams({ projectCode: event.target.value })}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={isProjectDisabled}
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => !isProjectDisabled && setOpenPrjByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onDoubleClick={() => !isProjectDisabled && setOpenPrjByDivisionModal(true)}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00508', 'Model / Nickname')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
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
                              onClick={() => setOpenModelByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onDoubleClick={() => setOpenModelByDivisionModal(true)}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00083', '_Customer PJT')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    value={searchParams.customerPJT}
                    onChange={event => setSearchParams({ customerPJT: event.target.value })}
                  />
                )}
                className={commonStyles.formItem}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00084', '_Customer Model')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <InputField
                    fullWidth
                    value={searchParams.customerModel}
                    onChange={event => setSearchParams({ customerModel: event.target.value })}
                  />
                )}
              />
            </Grid>
          </>
        }
        extraConditions={
          <Grid size={3}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={searchParams.activeFlag}
                  isInput={false}
                  allOption
                  options={yesOrNo?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({ activeFlag: option });
                  }}
                />
              )}
            />
          </Grid>
        }
      />
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={projects => setSearchParams({ projectCode: projects })}
        preSearchParams={{ ...searchParams }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openModelByDivisionModal}
        modalClose={() => setOpenModelByDivisionModal(false)}
        setSelectedValue={items => setSearchParams({ itemId: items })}
        preSearchParams={{ ...searchParams }}
        callFromCell={false}
      />
    </>
  );
};
