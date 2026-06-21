import { SearchArea } from '@shared/components';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useProgramStore } from '../useProgramStore';

export const ProgramForm = () => {
  const { t } = useTranslation();

  const searchParams = useProgramStore(state => state.searchParams);
  const setSearchParams = useProgramStore(state => state.setSearchParams);
  const setFilters = useProgramStore(state => state.setFilters);
  const isOpenSearchArea = useProgramStore(state => state.isOpenSearchArea);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', 'Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <Grid size={3}>
          <FormItem
            label={t('LBL00623', 'Search')}
            labelAlign='right'
            render={() => (
              <InputField
                fullWidth
                value={searchParams.search}
                onChange={event => setSearchParams({ search: event.target.value })}
                onKeyDown={event => event.key === 'Enter' && setFilters()}
              />
            )}
          />
        </Grid>
      }
    />
  );
};
