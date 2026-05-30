/**
 * DMF0072 NNMasterMapping — 조회조건 폼
 * AS-IS Designer.cs: clbDivisions / clbTeam / clbEndCustomer / clbSalesSite /
 *                    umltProject + btnProject / umltModel + btnModelType / clbDataTypeCode
 */
import { useTranslation } from 'react-i18next';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { DATA_TYPE_CODE, type DataTypeCode } from '../nn-master-mapping.constants';
import { useNNMasterMappingStore } from '../useNNMasterMappingStore';

import styles from './NNMasterMappingForm.module.scss';

interface NNMasterMappingFormProps {
  onSearch?: () => void;
  onOpenProjectPopup: () => void;
  onOpenModelPopup: () => void;
}

const arrayToCsv = (arr: string[]) => arr.join(',');
const csvToArray = (csv: string | null | undefined): string[] =>
  csv && typeof csv === 'string' ? csv.split(',').filter(Boolean) : [];

export const NNMasterMappingForm = ({
  onSearch,
  onOpenProjectPopup,
  onOpenModelPopup,
}: NNMasterMappingFormProps) => {
  const { t } = useTranslation();

  const searchParams = useNNMasterMappingStore(state => state.searchParams);
  const setSearchParams = useNNMasterMappingStore(state => state.setSearchParams);
  const setFilters = useNNMasterMappingStore(state => state.setFilters);
  const isOpenSearchArea = useNNMasterMappingStore(state => state.isOpenSearchArea);

  // AS-IS InnerTable cascade: MyDivision → UserTeamByDivision → EndCustomerByDivision → UserSiteByEndCustomer
  const [divisions, teams, endCustomers, scmSites] = useTabComboQueries({
    filters: ['MyDivision', 'UserTeamByDivision', 'EndCustomerByDivision', 'SalesSite'],
  });

  const onSearchClick = () => {
    if (onSearch) onSearch();
    else setFilters();
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearchClick}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          {/* AS-IS Designer.cs clbDivisions Width=113~294 */}
          <Grid size={2}>
            <FormItem
              label={t('LBL_COMMON_DIVISION', '_사업부')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  mandatory
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => setSearchParams({ divisionId: option as string })}
                />
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs clbTeam Width=100~250 */}
          <Grid size={2}>
            <FormItem
              label={t('LBL00044', '_Team')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  value={arrayToCsv(searchParams.teamIds)}
                  options={
                    teams
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => setSearchParams({ teamIds: csvToArray(option) })}
                />
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs clbEndCustomer Width=100~155 */}
          <Grid size={2}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  value={arrayToCsv(searchParams.endCustomers)}
                  options={
                    endCustomers
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => setSearchParams({ endCustomers: csvToArray(option) })}
                />
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs clbSalesSite Width=100~281 */}
          <Grid size={2}>
            <FormItem
              label={t('LBL00011', '_Sales Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  value={arrayToCsv(searchParams.salesSiteIds)}
                  options={scmSites?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) =>
                    setSearchParams({ salesSiteIds: csvToArray(option) })
                  }
                />
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs umltProject + btnProject (popup) */}
          <Grid size={2}>
            <FormItem
              label={t('LBL_DMF0020_PROJECT', '_Project')}
              labelAlign='right'
              render={() => (
                <Stack direction='row' spacing={1} sx={{ width: '100%' }}>
                  <InputField
                    fullWidth
                    value={searchParams.projectCode}
                    onChange={event => setSearchParams({ projectCode: event.target.value })}
                  />
                  {/* AS-IS .cs:~270 btnProject_Click → SCM0002_ProjectbyDivisionPopupEx */}
                  <Button appearance='outlined' priority='normal' onClick={onOpenProjectPopup}>
                    ...
                  </Button>
                </Stack>
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs umltModel + btnModelType (popup) */}
          <Grid size={2}>
            <FormItem
              label={t('LBL00003', '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <Stack direction='row' spacing={1} sx={{ width: '100%' }}>
                  <InputField
                    fullWidth
                    value={searchParams.modelType}
                    onChange={event => setSearchParams({ modelType: event.target.value })}
                  />
                  {/* AS-IS .cs:~290 btnModelType_Click → DM0002_ItembyDivisionPopupEx */}
                  <Button appearance='outlined' priority='normal' onClick={onOpenModelPopup}>
                    ...
                  </Button>
                </Stack>
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs clbDataTypeCode (DM_EDI_DATA_TYPE_CODE) */}
          <Grid size={12} sx={{ display: 'flex', alignItems: 'center', mt: 1 }}>
            <Stack direction='row' spacing={2} alignItems='center'>
              <span className={styles.label}>{t('LBL_DMF0072_DATA_TYPE', '_DataType')}</span>
              <CustomDropdown
                value={searchParams.dataTypeCode}
                options={[
                  { label: 'SCM', value: DATA_TYPE_CODE.SCM },
                  { label: 'EDI', value: DATA_TYPE_CODE.EDI },
                  { label: 'RPA', value: DATA_TYPE_CODE.RPA },
                ]}
                onChange={(_, option) =>
                  setSearchParams({ dataTypeCode: option as DataTypeCode })
                }
              />
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
