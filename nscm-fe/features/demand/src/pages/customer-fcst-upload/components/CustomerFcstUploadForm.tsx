import type { Dispatch, SetStateAction } from 'react';

import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { useCustomerFcstUploadStore } from '../useCustomerFcstUploadStore';

import styles from './CustomerFcstUploadForm.module.scss';

interface CustomerFcstUploadProps {
  onSubmit: () => void;
  setOpenPrjByDivisionModal: Dispatch<SetStateAction<boolean>>;
  setOpenModelByDivisionModal: Dispatch<SetStateAction<boolean>>;
}
export const CustomerFcstUploadForm = ({
  onSubmit,
  setOpenPrjByDivisionModal,
  setOpenModelByDivisionModal,
}: CustomerFcstUploadProps) => {
  const { t } = useTranslation();

  const searchParams = useCustomerFcstUploadStore(state => state.searchParams);
  const setSearchParams = useCustomerFcstUploadStore(state => state.setSearchParams);
  const isOpenSearchArea = useCustomerFcstUploadStore(state => state.isOpenSearchArea);

  const [myDivision, teambyDivision, endCustomer, salesSite, customsHandbook, plantSite, bucket] =
    useTabComboQueries({
      filters: [
        'MyDivision',
        'TeambyDivision',
        'EndCustomer',
        'SalesSite',
        'CustomsHandbook',
        'PlanSite',
        'Bucket',
      ],
    });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSubmit}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  defaultValue='ALL'
                  value={searchParams.divisionId}
                  options={myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
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
                  value={searchParams.team}
                  defaultValue='ALL'
                  allOption
                  useClearIcon
                  multiple
                  options={
                    teambyDivision
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ team: option });
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
                  defaultValue='ALL'
                  multiple
                  allOption
                  useClearIcon
                  options={
                    endCustomer
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
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
                  defaultValue='ALL'
                  multiple
                  allOption
                  useClearIcon
                  options={
                    salesSite
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
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
              label={t('', 'Plan Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.plantSite}
                  defaultValue='ALL'
                  multiple
                  allOption
                  useClearIcon
                  options={
                    plantSite
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({ plantSite: options });
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
              label={t('', 'PJT')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={clsx(styles.inputWithSearch, styles.input)}
                  value={searchParams.project}
                  onChange={event => setSearchParams({ project: event.target.value })}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={() => setOpenPrjByDivisionModal(true)}
                      />
                    ),
                  }}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('', 'Period')}
              labelAlign='right'
              required
              render={() => (
                <DatePickerCalendar
                  elevation
                  value={null}
                  usecase='date-range-multi'
                  locale='ko'
                  sx={{
                    width: '100%',
                    '& div': {
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                    },
                  }}
                />
              )}
              labelSize='long'
              className={clsx(styles.formItem, styles.date)}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('', 'Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.bucket}
                  allOption
                  options={bucket?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({ bucket: option });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00003', '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={clsx(styles.inputWithSearch, styles.input)}
                  value={searchParams.modelNickname}
                  onChange={event => setSearchParams({ modelNickname: event.target.value })}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={() => setOpenModelByDivisionModal(true)}
                      />
                    ),
                  }}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('', 'Customs Handbook')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.customsHandbook}
                  allOption
                  options={
                    customsHandbook?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ customsHandbook: option });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
        </>
      }
    />
  );
};
