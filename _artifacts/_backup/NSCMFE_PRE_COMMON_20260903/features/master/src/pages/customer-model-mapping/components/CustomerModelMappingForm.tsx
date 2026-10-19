import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  ItemByDivisionModal,
  ProjectByDivisionModal,
  buildComboOptions,
} from '../../../components';
import {
  DIVISION_NO_PROJECT,
  SEARCH_COMBO,
  buildEndCustomerComboParam,
  buildSalesSiteComboParam,
  resolveEndCustomerParam,
} from '../customer-model-mapping.constants';
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

  // Division 과 Team 은 필터 방식(Filter)이라 파라미터가 없다 - 셋 다 화면 진입 1회로 끝나고
  //   조회조건을 바꿔도 서버를 다시 치지 않는다. Team 을 division 으로 좁히는 일은 아래 options
  //   에서 한다. 나머지 두 콤보는 재조회 방식이라 파라미터를 싣는다.
  const [myDivision, teambyDivision, yesOrNo] = useTabComboQueries({
    filters: [SEARCH_COMBO.division, SEARCH_COMBO.team, SEARCH_COMBO.active],
  });

  // End Customer 와 Sales Site 는 재조회 방식이고 division 40 여부로 원천이 갈린다. 이번에 부를
  //   1건만 조립해 넘기므로 반대편 원천은 호출되지 않는다. 파라미터가 react-query 키에 실려
  //   조회조건이 바뀌면 자동으로 다시 조회된다.
  const [endCustomer] = useTabComboQueries({
    filters: [buildEndCustomerComboParam(searchParams)],
  });
  const endCustomerOptions = buildComboOptions(endCustomer);

  /**
   * Sales Site 는 End Customer 를 파라미터로 받는데, 미선택이면 그 시점 End Customer 목록
   * 전체로 펼쳐 넘긴다 - AS-IS CString.GetCheckedListValue 재현(resolveEndCustomerParam 주석).
   *
   * 이것이 Team 을 Sales Site 에 반영하는 경로다. Team 을 바꾸면 End Customer 목록이 좁혀지고,
   * 펼친 값이 달라져 Sales Site SQL 이 다시 나간다. 공란으로 넘기면 Team 을 골라도 목록이
   * 그대로다.
   */
  const [salesSite] = useTabComboQueries({
    filters: [
      buildSalesSiteComboParam({
        divisionId: searchParams.divisionId,
        endCustomer: resolveEndCustomerParam(searchParams.endCustomer, endCustomerOptions),
      }),
    ],
  });

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        onSearch={setFilters}
        isHidden={!isOpenSearchArea}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                label={t('LBL00001', '_Div.')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={buildComboOptions(myDivision)}
                    onChange={(_, option) => {
                      // Project 코드는 Division 소속 값이라 Division 이 바뀌면 초기화한다
                      //   (40 으로 바꿀 때 잠긴 칸에 이전 값이 남아 조회에 실려 가는 것도 함께 막힌다).
                      setSearchParams({
                        divisionId: option,
                        deptId: 'ALL',
                        endCustomer: 'ALL',
                        salesSite: 'ALL',
                        projectCode: '',
                        itemId: '',
                        customerPJT: '',
                        customerModel: '',
                        activeFlag: 'Y',
                      });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00044', '_Team')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    value={searchParams.deptId}
                    allOption
                    useClearIcon
                    multiple
                    // 조회조건 드롭다운은 전부 표시명 순(숫자-영문-한글)으로 둔다 - 눈으로 찾는
                    //   목록이라 콤보 SQL 의 ORDER BY 보다 이쪽이 낫다는 사용자 확정(2026-08-28).
                    sortBy='label'
                    options={buildComboOptions(teambyDivision, {
                      division: searchParams.divisionId,
                    })}
                    onChange={(_, option) => {
                      setSearchParams({
                        deptId: option,
                        endCustomer: 'ALL',
                        salesSite: 'ALL',
                        projectCode: '',
                        itemId: '',
                        customerPJT: '',
                        customerModel: '',
                        activeFlag: 'Y',
                      });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00080', '_End Customer')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    value={searchParams.endCustomer}
                    multiple
                    allOption
                    useClearIcon
                    sortBy='label'
                    options={endCustomerOptions}
                    onChange={(_, options) => {
                      // salesSite 를 함께 푸는 이유: End Customer 는 Sales Site 콤보의 파라미터라
                      //   목록이 다시 만들어진다. 이전 선택이 새 목록에 없으면 화면에는 남고
                      //   조회에는 실려 나가 결과가 0건이 된다.
                      setSearchParams({ endCustomer: options, salesSite: 'ALL' });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    value={searchParams.salesSite}
                    multiple
                    allOption
                    useClearIcon
                    sortBy='label'
                    options={buildComboOptions(salesSite)}
                    onChange={(_, options) => {
                      // 'ALL' 을 빈 값으로 바꾸지 않는다 - CustomDropdown 이 전체선택을 'ALL'
                      //   sentinel 로 내보내고 그 값이 그대로 돌아와야 전체 체크가 유지된다.
                      setSearchParams({ salesSite: options });
                    }}
                  />
                )}
              />
            </Grid>
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
                  options={buildComboOptions(yesOrNo)}
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
