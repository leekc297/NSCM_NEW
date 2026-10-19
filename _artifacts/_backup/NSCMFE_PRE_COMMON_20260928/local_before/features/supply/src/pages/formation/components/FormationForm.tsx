import { MaterialByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { MENU_ID } from '../formation.constants';
import { useFormationStore } from '../useFormationStore';

export const FormationForm = () => {
  const { t } = useTranslation();

  const searchParams = useFormationStore(state => state.searchParams);
  const setSearchParams = useFormationStore(state => state.setSearchParams);
  const setFilters = useFormationStore(state => state.setFilters);
  const fetchStaticColumns = useFormationStore(state => state.fetchStaticColumns);
  const openSearchArea = useFormationStore(state => state.openSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  // Plant Site — PlantByDivisionCompany(@divisionId). CODE=PLANT_ID. division 이 쿼리키라 바뀌면 재조회.
  const [plantSites] = useTabComboQueries({
    filters: [{ comboId: 'PlantByDivisionCompany', divisionId: searchParams.divisionId || 'ALL' }],
  });

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00001', '_Div.')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    onChange={(_, option) =>
                      setSearchParams({ divisionId: option, plantSiteId: 'ALL', itemId: '' })
                    }
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00005', '_Plant Site')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={searchParams.plantSiteId}
                    options={
                      plantSites?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, options) => setSearchParams({ plantSiteId: options })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00021', '_Material')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={searchParams.itemId ?? ''}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenItemModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={event => setSearchParams({ itemId: event.target.value })}
                  />
                )}
              />
            </Grid>
          </>
        }
      />
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => setSearchParams({ itemId: items })}
        // AS-IS SCP0022_Formation.btnItemId_Click 은 화면 ID 앞 7자를 module type 으로 넘긴다.
        preSearchParams={{ divisionId: searchParams.divisionId, scpModuleType: MENU_ID }}
      />
    </>
  );
};
