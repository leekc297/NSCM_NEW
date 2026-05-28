import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useMessageManagementStore } from '../useMessageManagementStore';

import styles from './MessageManagementForm.module.scss';

export const MessageManagementForm = () => {
  const { t } = useTranslation();

  const searchParams = useMessageManagementStore(state => state.searchParams);
  const setSearchParams = useMessageManagementStore(state => state.setSearchParams);
  const isOpenSearchArea = useMessageManagementStore(state => state.isOpenSearchArea);
  const setFilters = useMessageManagementStore(state => state.setFilters);

  const [messageTypeData, yesOrNo] = useTabComboQueries({
    filters: ['MessageType', 'YesOrNo'],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={4}>
            <FormItem
              label={t('LBL00052', '_Type')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <CustomDropdown
                  multiple
                  isInput={false}
                  value={searchParams.messageType}
                  options={
                    messageTypeData?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ messageType: option });
                  }}
                />
              )}
              className={styles.formItem}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('MNU00060', '_Message')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.message}
                  onChange={event => setSearchParams({ message: event.target.value })}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  value={searchParams.useYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ useYn: option });
                  }}
                />
              )}
              className={styles.formItem}
            />
          </Grid>
        </>
      }
    />
  );
};
