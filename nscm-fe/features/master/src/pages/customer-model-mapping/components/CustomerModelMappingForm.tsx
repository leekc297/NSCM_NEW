import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { CascadeFields, ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import { DIVISION_NO_PROJECT, SEARCH_CASCADE_COMBO_ID } from '../customer-model-mapping.constants';
import { useCustomerModelMappingStore } from '../useCustomerModelMappingStore';

export const CustomerModelMappingForm = () => {
  const { t } = useTranslation();

  const searchParams = useCustomerModelMappingStore(state => state.searchParams);
  const setSearchParams = useCustomerModelMappingStore(state => state.setSearchParams);
  const setFilters = useCustomerModelMappingStore(state => state.setFilters);
  const isOpenSearchArea = useCustomerModelMappingStore(state => state.isOpenSearchArea);

  // Division 40 은 Project 개념이 없어 조회조건 Project 를 잠근다 (입력·팝업 모두).
  const isProjectDisabled = searchParams.divisionId === DIVISION_NO_PROJECT;

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);

  // Div / Team / End Customer / Sales Site 콤보는 CascadeFields 가 조인 콤보 1건으로 직접 조회한다.
  // 여기서는 이 화면에만 있는 Active 콤보만 받는다.
  const [yesOrNo] = useTabComboQueries({ filters: ['YesOrNo'] });

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        onSearch={setFilters}
        isHidden={!isOpenSearchArea}
        conditions={
          <>
            {/* Div - Team - End Customer - Sales Site 는 조인 콤보 1건(CascadeFields)에서 뽑는다.
                단계 옵션은 상위 선택으로 좁힌 행에서 나오고, 하위 값 초기화도 컴포넌트가 한다.
                여기서는 이 화면 고유 항목(Project / Model / Customer PJT / Customer Model / Active)만 얹는다. */}
            <CascadeFields
              comboId={SEARCH_CASCADE_COMBO_ID}
              gridSize={3}
              // 배열 순서가 곧 cascade 순서다. field 는 스토어 필드명 — value 로 넘긴 searchParams 의
              // 키와 대조돼 오타가 컴파일에서 잡힌다.
              levels={[
                { key: 'division', field: 'divisionId' },
                { key: 'team', field: 'deptId' },
                { key: 'endCustomer', field: 'endCustomer' },
                { key: 'salesSite', field: 'salesSite' },
              ]}
              value={searchParams}
              onChange={(next, changed) => {
                // Division / Team 변경은 화면 고유 조회조건까지 전부 초기화한다 — 종전 인라인 동작 그대로.
                // Project 코드는 Division 소속 값이라 Division 이 바뀌면 반드시 지운다
                //   (40 으로 바꿀 때 잠긴 칸에 이전 값이 남아 조회에 실려 가는 것도 함께 막힌다).
                // End Customer / Sales Site 는 cascade 하위만 정리되면 되므로 next 만 반영한다.
                if (changed === 'division' || changed === 'team') {
                  setSearchParams({
                    ...next,
                    projectCode: '',
                    itemId: '',
                    customerPJT: '',
                    customerModel: '',
                    activeFlag: 'Y',
                  });
                  return;
                }
                setSearchParams(next);
              }}
            />
            <Grid size={3}>
              <FormItem
                label={t('LBL00617', '_Project')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    disabled={isProjectDisabled}
                    value={searchParams.projectCode}
                    onChange={event => setSearchParams({ projectCode: event.target.value })}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={isProjectDisabled}
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => !isProjectDisabled && setOpenPrjByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onDoubleClick={() => !isProjectDisabled && setOpenPrjByDivisionModal(true)}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00508', 'Model / Nickname')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={searchParams.itemId}
                    onChange={event => setSearchParams({ itemId: event.target.value })}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenModelByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onDoubleClick={() => setOpenModelByDivisionModal(true)}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00083', '_Customer PJT')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    value={searchParams.customerPJT}
                    onChange={event => setSearchParams({ customerPJT: event.target.value })}
                  />
                )}
                className={commonStyles.formItem}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00084', '_Customer Model')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <InputField
                    fullWidth
                    value={searchParams.customerModel}
                    onChange={event => setSearchParams({ customerModel: event.target.value })}
                  />
                )}
              />
            </Grid>
          </>
        }
        extraConditions={
          <Grid size={3}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={searchParams.activeFlag}
                  isInput={false}
                  allOption
                  options={yesOrNo?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({ activeFlag: option });
                  }}
                />
              )}
            />
          </Grid>
        }
      />
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={projects => setSearchParams({ projectCode: projects })}
        preSearchParams={{ ...searchParams }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openModelByDivisionModal}
        modalClose={() => setOpenModelByDivisionModal(false)}
        setSelectedValue={items => setSearchParams({ itemId: items })}
        preSearchParams={{ ...searchParams }}
        callFromCell={false}
      />
    </>
  );
};
