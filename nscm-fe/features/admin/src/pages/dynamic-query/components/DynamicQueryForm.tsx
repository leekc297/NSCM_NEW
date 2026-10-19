import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useDynamicQueryStore } from '../useDynamicQueryStore';

interface Props {
  onSearch: () => void;
}

export const DynamicQueryForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  // 검색 조건
  const searchCondition = useDynamicQueryStore(s => s.searchCondition);
  const setSearchCondition = useDynamicQueryStore(s => s.setSearchCondition);

  // 검색 폼 닫히고 열리는 구분 값
  const openSearchArea = useDynamicQueryStore(s => s.openSearchArea);

  const [group] = useTabComboQueries({ filters: ['UserGroup'] });
  const roleOptions = group?.map(item => ({ label: item.NAME, value: item.CODE })) ?? [];

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', 'Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00718', 'Report Name')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <InputField
                  fullWidth
                  value={searchCondition.reportName}
                  onChange={e => setSearchCondition({ reportName: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00608', 'Description')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <InputField
                  fullWidth
                  value={searchCondition.description}
                  onChange={e => setSearchCondition({ description: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00720', 'Role')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchCondition.role}
                  options={roleOptions}
                  onChange={(_, options) => {
                    setSearchCondition({ role: options });
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
