import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import { useCustomerFcstMasterStore } from '../useCustomerFcstMasterStore';

interface CustomerFcstMasterFormProps {
  onSubmit: () => void;
}

export const CustomerFcstMasterForm = ({ onSubmit }: CustomerFcstMasterFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useCustomerFcstMasterStore(state => state.openSearchArea);
  const searchParams = useCustomerFcstMasterStore(state => state.searchParams);
  const setSearchParams = useCustomerFcstMasterStore(state => state.setSearchParams);
  const userId = useSessionStore(state => state.session.userId);

  const [divisions, buckets, endCustomers, scmSites, yesOrNo] = useTabComboQueries({
    filters: ['MyDivision', 'BucketType', 'EndCustomer', 'SalesSite', 'YesOrNo'],
  });

  useEffect(() => {
    setSearchParams({
      userId: userId,
    });
  }, [userId]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSubmit}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({
                      divisionId: option,
                      endCustomer: 'ALL',
                      scmSiteId: 'ALL',
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00032', '_Bucket Type')}
              labelAlign='right'
              required
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={searchParams.bucketType}
                  options={buckets?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({
                      bucketType: option,
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              required
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.endCustomer}
                  options={
                    [
                      ...new Map(
                        endCustomers
                          ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({
                      endCustomer: options,
                    });
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
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.scmSiteId}
                  options={
                    [
                      ...new Map(
                        scmSites
                          ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({
                      scmSiteId: options,
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  allOption
                  limitTags={1}
                  value={searchParams.validYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({
                      validYn: options,
                    });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
