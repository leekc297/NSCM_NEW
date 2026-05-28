import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useLookupStore } from '../useLookupStore';

import styles from './LookupForm.module.scss';

interface LookupFormProps {
  onSubmit: () => void;
}

export const LookupForm = ({ onSubmit }: LookupFormProps) => {
  const { t } = useTranslation();

  const searchParams = useLookupStore(state => state.searchParams);
  const setSearchParams = useLookupStore(state => state.setSearchParams);
  const isOpenSearchArea = useLookupStore(state => state.isOpenSearchArea);

  const [system, yesOrNo] = useTabComboQueries({
    filters: ['LookupCommon', 'YesOrNo'],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSubmit}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={4}>
            <FormItem
              label={t('', '_Lookup Type')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.lookupType}
                  onChange={event => setSearchParams({ lookupType: event.target.value })}
                />
              )}
              className={styles.formItem}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('', '_System')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  value={searchParams.lookupGroup}
                  options={
                    system?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ lookupGroup: option });
                  }}
                />
              )}
              className={styles.formItem}
            />
          </Grid>
          <Grid size={4}>
            <FormItem
              label={t('', '_Valid')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  value={searchParams.validYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ validYn: option });
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
