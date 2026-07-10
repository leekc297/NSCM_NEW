// SYS0013 Register 탭 검색 Form — 라벨 = AS-IS 정본 (Report Name / Description / Role).
// Role 콤보 = admin USER_GR (useTabComboQueries 'UserGroup') + 'ALL' 선두.
import { useEffect } from 'react';

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
  const searchCondition = useDynamicQueryStore(s => s.searchCondition);
  const setSearchCondition = useDynamicQueryStore(s => s.setSearchCondition);
  const openSearchArea = useDynamicQueryStore(s => s.openSearchArea);

  const [group] = useTabComboQueries({ filters: ['UserGroup'] });
  const roleOptions = [
    { label: t('LBL00721', 'All'), value: 'ALL' },
    ...(group?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []),
  ];

  // 영속 store(tab) 에 남은 비유효 role 값을 콤보 로드 후 ALL 로 정규화 (stale persist 가드).
  useEffect(() => {
    if (!group) return;
    const valid = new Set<string>(['ALL', ...group.map(g => String(g.CODE))]);
    if (!valid.has(String(searchCondition.role))) {
      setSearchCondition({ role: 'ALL' });
    }
  }, [group, searchCondition.role, setSearchCondition]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00722', 'Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00718', 'Report Name')}
              labelAlign='right'
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
              label={t('LBL00719', 'Description')}
              labelAlign='right'
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
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchCondition.role || 'ALL'}
                  options={roleOptions}
                  onChange={(_, value) =>
                    setSearchCondition({ role: typeof value === 'string' ? value : 'ALL' })
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
