import { SearchArea } from '@shared/components';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useGroupUserStore } from '../useGroupUserStore';

export const GroupUserForm = () => {
  const { t } = useTranslation();

  const searchParams = useGroupUserStore(state => state.searchParams);
  const setSearchParams = useGroupUserStore(state => state.setSearchParams);
  const setMainFilter = useGroupUserStore(state => state.setMainFilter);
  const isOpenSearchArea = useGroupUserStore(state => state.isOpenSearchArea);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', 'Search')}
      onSearch={setMainFilter}
      isHidden={!isOpenSearchArea}
      conditions={
        <Grid size={3}>
          <FormItem label='' labelAlign='right' render={() => <></>} />
        </Grid>
      }
    />
  );
};
