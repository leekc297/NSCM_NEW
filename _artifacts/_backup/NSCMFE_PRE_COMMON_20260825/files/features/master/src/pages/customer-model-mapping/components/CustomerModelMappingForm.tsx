import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  DivisionField,
  EndCustomerField,
  ItemByDivisionModal,
  ProjectByDivisionModal,
  SalesSiteField,
  TeamField,
} from '../../../components';
// 임시 로컬 디버그 — 확인 끝나면 이 import 와 logSearchReset 호출, debugLabel prop 을 지운다.
import { logSearchReset } from '../../../components/searchFields/SearchFields.debug';
import { DIVISION_NO_PROJECT } from '../customer-model-mapping.constants';
import { useCustomerModelMappingStore } from '../useCustomerModelMappingStore';

// 스토어의 조회조건은 CustomDropdown 이 내보내는 문자열 그대로다 ('ALL' 또는 콤마 조인).
// SearchFields 카탈로그는 string[] 계약이라 이 화면에서만 변환한다.
// 'ALL' 은 ['ALL'] 로 왕복하고, cascade 에서는 toFilterSet 이 걷어내 필터 미적용이 된다 —
// 기존 인라인 코드의 deptId === 'ALL' 분기와 같은 뜻이다.
const toList = (v: string) => v.split(',').filter(Boolean);

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

  // MyDivision / TeambyDivision / EndCustomer / SalesSite 는 카탈로그 필드가 같은 comboId 로
  // 직접 조회한다. react-query 키가 동일해 캐시를 공유하므로 네트워크 호출은 늘지 않는다.
  const [yesOrNo] = useTabComboQueries({ filters: ['YesOrNo'] });

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        onSearch={setFilters}
        isHidden={!isOpenSearchArea}
        conditions={
          <>
            <DivisionField
              gridSize={3}
              value={searchParams.divisionId}
              onChange={value => {
                // 임시 로컬 디버그 — division 변경 시 하위 조회조건이 어떻게 재세팅되는지.
                // 확인 끝나면 이 호출과 SearchFields.debug import 를 지운다.
                logSearchReset({
                  label: 'DMF0006 customer-model-mapping',
                  changed: { field: 'divisionId', from: searchParams.divisionId, to: value },
                  resets: [
                    { field: 'deptId', from: searchParams.deptId, to: 'ALL' },
                    { field: 'endCustomer', from: searchParams.endCustomer, to: 'ALL' },
                    { field: 'salesSite', from: searchParams.salesSite, to: 'ALL' },
                    { field: 'projectCode', from: searchParams.projectCode, to: '' },
                    { field: 'itemId', from: searchParams.itemId, to: '' },
                    { field: 'customerPJT', from: searchParams.customerPJT, to: '' },
                    { field: 'customerModel', from: searchParams.customerModel, to: '' },
                    { field: 'activeFlag', from: searchParams.activeFlag, to: 'Y' },
                  ],
                });
                // Project 코드는 Division 소속 값이라 Division 이 바뀌면 초기화한다
                //   (40 으로 바꿀 때 잠긴 칸에 이전 값이 남아 조회에 실려 가는 것도 함께 막힌다).
                setSearchParams({
                  divisionId: value,
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
            {/* 주의: 'ALL' 을 빈 배열로 바꿔 내려보내지 않는다.
                CustomDropdown 은 SELECT ALL 을 'ALL' sentinel 로 내보내고, 그 값이 그대로
                돌아와야 전체 체크 표시를 유지한다(isAllSentinel). 빈 배열로 바꾸면 value 가 ''
                가 되어 sentinel 이 깨지고, setSelectAllChecked(false) 가 돌아 체크가 바로 풀린다. */}
            <TeamField
              gridSize={3}
              division={searchParams.divisionId}
              value={toList(searchParams.deptId)}
              onChange={v => {
                // 임시 로컬 디버그 — CustomDropdown 이 실제로 무엇을 내보내는지(전체선택='ALL',
                // 전체해제='', 개별선택=콤마 조인) 확인용. 확인 끝나면 호출과 import 삭제.
                logSearchReset({
                  label: 'DMF0006 customer-model-mapping',
                  changed: {
                    field: 'deptId (= End Customer / Sales Site 콤보의 DEPT_ID)',
                    from: searchParams.deptId,
                    to: v.length > 0 ? v.join(',') : 'ALL',
                  },
                  resets: [
                    { field: 'endCustomer', from: searchParams.endCustomer, to: 'ALL' },
                    { field: 'salesSite', from: searchParams.salesSite, to: 'ALL' },
                    { field: 'projectCode', from: searchParams.projectCode, to: '' },
                    { field: 'itemId', from: searchParams.itemId, to: '' },
                    { field: 'customerPJT', from: searchParams.customerPJT, to: '' },
                    { field: 'customerModel', from: searchParams.customerModel, to: '' },
                    { field: 'activeFlag', from: searchParams.activeFlag, to: 'Y' },
                  ],
                });
                setSearchParams({
                  deptId: v.length > 0 ? v.join(',') : 'ALL',
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
            {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
                여기엔 Team(DEPT_ID) 단계만 넘긴다. 콤보를 바꾸면 컬럼명도 달라질 수 있어
                어느 조회조건이 어느 컬럼에 대응하는지는 화면이 들고 있는다.
                필수: strict. 'EndCustomer' 콤보는 DEPT_ID 가 공란인 행이 대다수라(SITE_ITEM LEFT
                  OUTER JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다 — 필터가 통째로
                  무력화된다. 인라인 시절 조건(deptId.split(',').includes(item.DEPT_ID))과 동일. */}
            <EndCustomerField
              gridSize={3}
              division={searchParams.divisionId}
              cascade={{ DEPT_ID: { values: toList(searchParams.deptId), strict: true } }}
              debugLabel='DMF0006 customer-model-mapping / End Customer'
              value={toList(searchParams.endCustomer)}
              onChange={values => {
                // 임시 로컬 디버그 — 이 화면에서 End Customer 는 'SalesSite' 콤보의 PROJECT_CODE
                // 자리로 쓰인다. 어떤 값이 하위 Sales Site cascade 로 넘어가는지 확인용.
                logSearchReset({
                  label: 'DMF0006 customer-model-mapping',
                  changed: {
                    field: 'endCustomer (= SalesSite 콤보의 PROJECT_CODE)',
                    from: searchParams.endCustomer,
                    to: values.join(','),
                  },
                  resets: [{ field: 'salesSite', from: searchParams.salesSite, to: 'ALL' }],
                });
                setSearchParams({
                  endCustomer: values.join(','),
                  // cascade 상위 단계라 하위 Sales Site 선택은 초기화한다 —
                  // 안 지우면 옵션에서 사라진 사이트가 조회조건에 그대로 남아 서버로 나간다.
                  salesSite: 'ALL',
                });
              }}
            />
            {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
                division 은 카탈로그 필드가 항상 먼저 걸므로 여기 적지 않는다.
                End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                  내려주지 않기 때문이다. DMF0043 sales-site, DMF0044 sales-site-project-model 과 동일.
                콤보를 바꾸면 컬럼명도 달라지므로 어느 조회조건이 어느 컬럼에 대응하는지는 화면이 든다. */}
            <SalesSiteField
              gridSize={3}
              division={searchParams.divisionId}
              cascade={{
                // DEPT_ID 는 strict — 인라인 시절 조건과 동일하고, End Customer 와 같은 이유로
                // 관대로 두면 Team 이 목록을 못 좁힌다.
                DEPT_ID: { values: toList(searchParams.deptId), strict: true },
                // PROJECT_CODE 는 관대 — 'SalesSite' 콤보는 이 컬럼이 NULL 인 행이 정상적으로
                // 존재한다. 자르면 목록이 비어버린다.
                PROJECT_CODE: toList(searchParams.endCustomer),
              }}
              debugLabel='DMF0006 customer-model-mapping / Sales Site'
              value={toList(searchParams.salesSite)}
              onChange={values => {
                // 임시 로컬 디버그 — cascade 최하위라 같이 재세팅되는 항목은 없다.
                logSearchReset({
                  label: 'DMF0006 customer-model-mapping',
                  changed: {
                    field: 'salesSite',
                    from: searchParams.salesSite,
                    to: values.join(','),
                  },
                  resets: [],
                });
                setSearchParams({
                  salesSite: values.join(','),
                });
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
