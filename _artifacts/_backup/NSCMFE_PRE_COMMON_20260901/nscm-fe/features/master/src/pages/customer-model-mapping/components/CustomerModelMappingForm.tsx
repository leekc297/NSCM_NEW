import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import {
  DIVISION_NO_PROJECT,
  SEARCH_COMBO,
  buildEndCustomerComboParam,
  buildSalesSiteComboParam,
  buildTeamComboParam,
  toComboOptions,
} from '../customer-model-mapping.constants';
import { useCustomerModelMappingStore } from '../useCustomerModelMappingStore';

export const CustomerModelMappingForm = () => {
  const { t } = useTranslation();

  const searchParams = useCustomerModelMappingStore(state => state.searchParams);
  const setSearchParams = useCustomerModelMappingStore(state => state.setSearchParams);
  const setFilters = useCustomerModelMappingStore(state => state.setFilters);
  const isOpenSearchArea = useCustomerModelMappingStore(state => state.isOpenSearchArea);
  const comboTrigger = useCustomerModelMappingStore(state => state.comboTrigger);

  // Division 40 은 Project 개념이 없어 조회조건 Project 를 잠근다 (입력·팝업 모두).
  const isProjectDisabled = searchParams.divisionId === DIVISION_NO_PROJECT;

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);

  // Division 과 Active 는 파라미터가 없어 화면 진입 1회로 끝난다. Team 은 division 이 키에 실려
  //   Division 이 바뀔 때 다시 조회된다 - 파라미터 이름이 PARAM1 이어야 하는 이유는
  //   customer-model-mapping.constants 의 SEARCH_COMBO 주석 "필수" 항목 참조.
  const [myDivision, teambyDivision, yesOrNo] = useTabComboQueries({
    filters: [SEARCH_COMBO.division, buildTeamComboParam(searchParams), SEARCH_COMBO.active],
  });

  // End Customer 와 Sales Site 는 원천이 둘로 갈린다. 어느 쪽을 쓸지는 40 여부만이 아니라 "방금
  //   무엇을 바꿨는가"(comboTrigger)로 정해진다 - AS-IS 의 40 분기가 Division 변경 경로에만 있기
  //   때문이다. 규칙은 customer-model-mapping.constants 의 SearchComboTrigger 주석 참조.
  //   이번에 부를 1건만 조립해 넘기므로 반대편 원천은 호출되지 않는다.
  const [endCustomer] = useTabComboQueries({
    filters: [buildEndCustomerComboParam(comboTrigger, searchParams)],
  });
  const [salesSite] = useTabComboQueries({
    filters: [buildSalesSiteComboParam(comboTrigger, searchParams)],
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
                    options={
                      myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
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
                      }, 'division');
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
                    // sortBy 를 주지 않는다 - 콤보 SQL 의 ORDER BY 순서를 그대로 쓴다.
                    //   sortBy='label' 은 첫 글자 그룹(숫자-영문-한글) + localeCompare('ko') 라,
                    //   'ESS.SCM...' 과 'ESS.마케팅...' 처럼 문자열 중간에서 한/영이 갈리는 팀명의
                    //   순서가 AS-IS(Oracle NLS_SORT=BINARY, 코드포인트 순)와 뒤집힌다.
                    options={toComboOptions(teambyDivision)}
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
                      }, 'team');
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
                    options={toComboOptions(endCustomer)}
                    onChange={(_, options) => {
                      // salesSite 를 함께 푸는 이유: End Customer 는 Sales Site 콤보의 파라미터라
                      //   목록이 다시 만들어진다. 이전 선택이 새 목록에 없으면 화면에는 남고
                      //   조회에는 실려 나가 결과가 0건이 된다.
                      setSearchParams({ endCustomer: options, salesSite: 'ALL' }, 'endCustomer');
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
                    options={toComboOptions(salesSite)}
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
