// SYS0013 Designer(View) 상단 메타폼 — Report Name / Description / Role (box border 없음).
// Report Name(DQ_NAME)·Description 편집 → trackMainModify (main SAVE 경로).
// Role = AS-IS clbRole 다중선택(SCM_ADM_DQ_USER_GROUP). 옵션=공용 콤보 UserGroup, 현재값=main GET GROUP_ID('ALL,' 접두).
//   선택 변경은 store.roleSelection, 저장은 DynamicQuery.handleSave 에서 diff → SYS0013_SAVE_USER_GROUP.
import { useEffect, useMemo } from 'react';

import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import type { QueryRow } from '../dynamic-query.types';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

import styles from './DynamicQueryMetaForm.module.scss';

interface Props {
  selectedRow: QueryRow | undefined;
}

const parseRoles = (groupId: unknown): string[] =>
  ((groupId ?? '') as string)
    .split(',')
    .map(s => s.trim())
    .filter(s => s !== '' && s !== 'ALL');

export const DynamicQueryMetaForm = ({ selectedRow }: Props) => {
  const { t } = useTranslation();
  const trackMainModify = useDynamicQueryStore(s => s.trackMainModify);
  const roleSelection = useDynamicQueryStore(s => s.roleSelection);
  const roleSourceId = useDynamicQueryStore(s => s.roleSourceId);
  const setRoleSelection = useDynamicQueryStore(s => s.setRoleSelection);
  const initRoles = useDynamicQueryStore(s => s.initRoles);

  const [roleData] = useTabComboQueries({ filters: ['UserGroup'] });
  const roleOptions = useMemo(
    () =>
      (roleData ?? []).map(r => ({ value: String(r.CODE ?? ''), label: String(r.NAME ?? r.CODE) })),
    [roleData]
  );

  // 선택된 query 변경 시 현재 역할(GROUP_ID)로 init — 미저장 변경 자연 reset.
  useEffect(() => {
    if (!selectedRow) return;
    const id = String(selectedRow.DQ_ID);
    if (roleSourceId === id) return;
    initRoles(parseRoles(selectedRow.GROUP_ID), id);
  }, [selectedRow, roleSourceId, initRoles]);

  if (!selectedRow) return null;

  const handleChange = (field: 'DQ_NAME' | 'DESCRIPTION', value: string) => {
    selectedRow[field] = value;
    trackMainModify(String(selectedRow.DQ_ID), selectedRow as unknown as Record<string, unknown>);
  };

  return (
    <Grid container spacing={2} className={styles.metaForm}>
      <Grid size={4}>
        <FormItem
          label={t('LBL00718', 'Report Name')}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              value={selectedRow.DQ_NAME ?? ''}
              onChange={e => handleChange('DQ_NAME', e.target.value)}
            />
          )}
        />
      </Grid>
      <Grid size={4}>
        <FormItem
          label={t('LBL00719', 'Description')}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              value={selectedRow.DESCRIPTION ?? ''}
              onChange={e => handleChange('DESCRIPTION', e.target.value)}
            />
          )}
        />
      </Grid>
      <Grid size={4}>
        <FormItem
          label={t('LBL00720', 'Role')}
          labelAlign='right'
          render={() => (
            <CustomDropdown
              multiple
              useClearIcon
              options={roleOptions}
              value={roleSelection.join(',')}
              onChange={(_, v) =>
                setRoleSelection(typeof v === 'string' && v ? v.split(',').filter(Boolean) : [])
              }
            />
          )}
        />
      </Grid>
    </Grid>
  );
};
