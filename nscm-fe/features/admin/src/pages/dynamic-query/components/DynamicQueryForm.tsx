import { CustomDropdown, SearchArea } from '@shared/components';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  onSearch: () => void;
}

const CATEGORY_OPTIONS = [
  { label: 'All', value: 'ALL' },
  { label: 'Demand', value: 'DM' },
  { label: 'SCM', value: 'SCM' },
  { label: 'Admin', value: 'ADMIN' },
];

export const DynamicQueryForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const searchCondition = useDynamicQueryStore(s => s.searchCondition);
  const setSearchCondition = useDynamicQueryStore(s => s.setSearchCondition);
  const openSearchArea = useDynamicQueryStore(s => s.openSearchArea);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00650', 'Query Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchCondition.queryName}
                  onChange={e => setSearchCondition({ queryName: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00651', 'Category')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchCondition.category}
                  options={CATEGORY_OPTIONS}
                  onChange={(_, value) =>
                    setSearchCondition({ category: typeof value === 'string' ? value : 'ALL' })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
