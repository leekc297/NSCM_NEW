import { useMemo } from 'react';

import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import type { DynamicQueryMeta } from '../dynamic-query.types';

import styles from './DynamicQueryMetaForm.module.scss';

interface Props {
  dynamicQueryMeta: DynamicQueryMeta | undefined;
}

export const DynamicQueryMetaForm = ({ dynamicQueryMeta }: Props) => {
  const { t } = useTranslation();

  const [roleData] = useTabComboQueries({ filters: ['UserGroup'] });
  const roleOptions = useMemo(
    () =>
      (roleData ?? []).map(r => ({ value: String(r.NAME ?? ''), label: String(r.NAME ?? r.CODE) })),
    [roleData]
  );

  const roleValue = useMemo(
    () =>
      (dynamicQueryMeta?.role ?? '')
        .split(',')
        .map(code => code.trim())
        .filter(code => code !== '' && code !== 'ALL')
        .join(','),
    [dynamicQueryMeta?.role]
  );
  return (
    <Grid container spacing={2} className={styles.metaForm}>
      <Grid size={4}>
        <FormItem
          label={t('LBL00718', 'Report Name')}
          labelAlign='right'
          render={() => (
            <InputField fullWidth readOnly value={dynamicQueryMeta?.reportName ?? ''} />
          )}
        />
      </Grid>
      <Grid size={4}>
        <FormItem
          label={t('LBL00608', 'Description')}
          labelAlign='right'
          render={() => (
            <InputField fullWidth readOnly value={dynamicQueryMeta?.description ?? ''} />
          )}
        />
      </Grid>
      <Grid size={3}>
        <FormItem
          label={t('LBL00720', 'Role')}
          labelAlign='right'
          render={() => (
            <CustomDropdown
              readOnly
              multiple
              useClearIcon
              limitTags={1}
              options={roleOptions}
              value={roleValue}
            />
          )}
        />
      </Grid>
    </Grid>
  );
};
