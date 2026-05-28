import { useState } from 'react';

import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import { useCustomerModelMappingStore } from '../useCustomerModelMappingStore';

import styles from './CustomerModelMappingForm.module.scss';

export const CustomerModelMappingForm = () => {
  const { t } = useTranslation();

  const searchParams = useCustomerModelMappingStore(state => state.searchParams);
  const setSearchParams = useCustomerModelMappingStore(state => state.setSearchParams);
  const setFilters = useCustomerModelMappingStore(state => state.setFilters);
  const isOpenSearchArea = useCustomerModelMappingStore(state => state.isOpenSearchArea);

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
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={
                      myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, option) => {
                      setSearchParams({ divisionId: option });
                    }}
                    className={styles.input}
                  />
                )}
                labelSize='long'
                className={styles.formItem}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00044', '_Team')}
                labelAlign='right'
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
                    className={styles.input}
                  />
                )}
                labelSize='long'
                className={styles.formItem}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00080', '_End Customer')}
                labelAlign='right'
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
                    className={styles.input}
                  />
                )}
                labelSize='long'
                className={styles.formItem}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
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
                    className={styles.input}
                  />
                )}
                labelSize='long'
                className={styles.formItem}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00327', '_Project')}
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
                              onClick={() => setOpenPrjByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onDoubleClick={() => setOpenPrjByDivisionModal(true)}
                  />
                )}
                labelSize='long'
                className={styles.formItem}
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
                              onClick={() => setOpenModelByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onDoubleClick={() => setOpenModelByDivisionModal(true)}
                  />
                )}
                labelSize='long'
                className={styles.formItem}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00083', '_Customer PJT')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={styles.input}
                    value={searchParams.customerPJT}
                    onChange={event => setSearchParams({ customerPJT: event.target.value })}
                  />
                )}
                labelSize='long'
                className={styles.formItem}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00084', '_Customer Model')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={styles.input}
                    value={searchParams.customerModel}
                    onChange={event => setSearchParams({ customerModel: event.target.value })}
                  />
                )}
                labelSize='long'
                className={styles.formItem}
              />
            </Grid>
          </>
        }
        extraConditions={
          <Grid size={3}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.activeFlag}
                  isInput={false}
                  allOption
                  options={yesOrNo?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({ activeFlag: option });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
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
