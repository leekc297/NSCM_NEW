import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField, Label } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  ItemByDivisionModal,
  OwnerByDivisionModal,
  ProjectByDivisionModal,
  buildComboOptions,
  toSelectedCodes,
} from '../../../components';
import { SHEET_INDEX } from '../sales-site-project-model.constants';
import { useSalesSiteProjectModelStore } from '../useSalesSiteProjectModelStore';

interface SalesSiteProjectModelFormProps {
  onSubmit: () => void;
  setActiveTab: (tab: SHEET_INDEX) => void;
}

export const SalesSiteProjectModelForm = ({
  onSubmit,
  setActiveTab,
}: SalesSiteProjectModelFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useSalesSiteProjectModelStore(state => state.openSearchArea);
  const openPurchaseGrid = useSalesSiteProjectModelStore(state => state.openPurchaseGrid);
  const searchParams = useSalesSiteProjectModelStore(state => state.searchParams);
  const setOpenPurchaseGrid = useSalesSiteProjectModelStore(state => state.setOpenPurchaseGrid);
  const setSearchParams = useSalesSiteProjectModelStore(state => state.setSearchParams);

  /**
   * 이 화면의 조회조건 콤보는 전부 필터 방식이다.
   *
   *   콤보                                  목록 구성 조건                갱신 시점
   *   FilterMyDivision            (#0)  없음                          화면 진입 1회
   *   FilterTeambyDivision        (#1)  Division                      Division 변경
   *   FilterEndCustomerByDivision (#2)  Division + Team               Division / Team 변경
   *   FilterSiteByEndCustomer     (#4)  Division + Team + End Customer  Division / Team / End Customer 변경
   *   YesOrNo                               없음                          화면 진입 1회
   *
   * Filter 접두는 필터 방식이라는 표시다. 파라미터 없이 전량을 한 번 받아 두고, 좁히는 일은
   * 아래 각 options 에서 클라이언트가 한다. 괄호 안 번호는 AS-IS BigFilter 데이터셋의 테이블
   * 인덱스다. 파라미터가 없으니 쿼리 키가 고정이라 조회조건을 바꿔도 서버를 다시 치지 않는다 -
   * AS-IS GetDMInnerTable 이 세션 캐시 테이블을 LINQ 로 거르던 것과 같은 동작이다.
   */
  const [divisions, teams, endCustomers, salesSites, yesOrNo] = useTabComboQueries({
    filters: [
      'FilterMyDivision',
      'FilterTeambyDivision',
      'FilterEndCustomerByDivision',
      'FilterSiteByEndCustomer',
      'YesOrNo',
    ],
  });

  /**
   * End Customer 목록 = Division + Team. 이 콤보는 DEPT_ID 가 공란인 행이 대다수라
   * (SITE_ITEM LEFT OUTER JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다 -
   * 필터가 통째로 무력화된다. 그래서 DEPT_ID 는 엄격 매칭이다.
   *
   * 아래 Sales Site 필터가 이 목록을 그대로 재사용하므로 JSX 밖으로 뺐다.
   */
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division: searchParams.divisionId,
    narrow: { column: 'DEPT_ID', codes: searchParams.deptId.split(',') },
  });

  /**
   * Sales Site 를 좁힐 End Customer 코드 집합.
   *
   * AS-IS 는 Sales Site 콤보에 Team 을 넘기지 않는다 - SetChangeControl("UserSiteByEndCustomer",
   * sDivision, string.Empty, sEndCustomer) 로 호출부 4곳이 전부 팀 자리를 비운다. 대신
   * CString.GetCheckedListValue 가 'ALL' 을 그 시점 End Customer 목록의 전체 CODE 로 펼쳐
   * 넘기므로, Team 이 End Customer 를 좁히고 그 좁혀진 집합이 다시 Sales Site 를 좁힌다.
   *
   * 그래서 DEPT_ID 로 직접 거르지 않는다. Sales Site 행의 DEPT_ID 기준은 End Customer 와 달라
   * 직접 걸면 AS-IS 보다 좁거나 넓게 나온다.
   *
   * 필수: 미선택('ALL')을 그냥 "축 미적용"으로 떨어뜨리면 안 된다. 그러면 Team 을 골라도
   * Sales Site 가 그대로라 목록 구성 조건 "Division + Team + End Customer" 가 깨진다.
   * 위 endCustomerOptions 는 이미 Division + Team 으로 좁혀져 있으므로, 그 전체 CODE 로
   * 펼치는 것이 곧 Team 을 반영하는 길이다.
   *
   * 목록이 비면 빈 배열이 되어 그 단계가 미적용된다 - AS-IS 도 펼친 결과가 공란이면
   * Count == 0 분기로 떨어져 전량이 흐른다.
   */
  const selectedEndCustomers = toSelectedCodes(searchParams.endCustomer.split(','));
  const endCustomerCodes =
    selectedEndCustomers.length > 0
      ? selectedEndCustomers
      : endCustomerOptions.map(option => option.value);

  const [openProjectByDivisionModal, setOpenProjectByDivisionModal] = useState(false);
  const [openItemByDivisionModal, setOpenItemByDivisionModal] = useState(false);
  const [openOwnerByDivisionModal, setOpenOwnerByDivisionModal] = useState(false);

  const handleProjectByDivisionModal = (projects: string) => {
    setSearchParams({ projectCode: projects });
  };

  const handleItemByDivisionModal = (items: string) => {
    setSearchParams({ itemId: items });
  };

  const handleOwnerByDivisionModalSubmit = (owners: string) => {
    setSearchParams({ owner: owners });
  };

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSubmit}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                label={t('LBL00001', '_Div.')}
                labelAlign='right'
                required
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={(divisions ?? []).map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    }))}
                    onChange={(_, option) => {
                      // division 변경 = 하위 조회조건 전부 초기화. 목록 자체가 바뀌므로
                      // 안 지우면 옵션에 없는 값이 조회조건에 남아 그대로 서버로 나간다.
                      setSearchParams({
                        divisionId: option,
                        deptId: 'ALL',
                        endCustomer: 'ALL',
                        salesSite: 'ALL',
                        projectCode: '',
                        itemId: '',
                        owner: '',
                        activeFlag: 'ALL',
                      });
                      setOpenPurchaseGrid(true);
                    }}
                  />
                )}
              />
            </Grid>
            {/* 주의: 'ALL' 을 빈 문자열로 바꿔 value 로 내려보내지 않는다.
                CustomDropdown 은 전체선택을 'ALL' sentinel 로 내보내고, 그 값이 그대로 돌아와야
                전체 체크 표시를 유지한다. 빈 값으로 바꾸면 sentinel 이 깨져 체크가 바로 풀린다.
                전체해제(빈 문자열)도 'ALL' 로 되돌린다 — 스토어 조회조건이 그대로 서버 필터라
                빈 값이 나가면 팀 조건이 아무것도 매칭하지 않는 뜻이 돼 버린다. */}
            <Grid size={3}>
              <FormItem
                label={t('LBL00044', 'Team')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={searchParams.deptId}
                    options={buildComboOptions(teams, { division: searchParams.divisionId })}
                    onChange={(_, option) => {
                      setSearchParams({
                        deptId: option || 'ALL',
                        endCustomer: 'ALL',
                        salesSite: 'ALL',
                        projectCode: '',
                        itemId: '',
                        owner: '',
                        activeFlag: 'ALL',
                      });
                      setOpenPurchaseGrid(true);
                    }}
                  />
                )}
              />
            </Grid>
            {/* 목록 구성 조건 = Division + Team. 규칙은 위 endCustomerOptions 주석 참조. */}
            <Grid size={3}>
              <FormItem
                label={t('LBL00080', '_End Customer')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={searchParams.endCustomer}
                    options={endCustomerOptions}
                    onChange={(_, option) => {
                      setSearchParams({
                        endCustomer: option,
                        // cascade 상위 단계라 하위 Sales Site 선택은 초기화한다 —
                        // 안 지우면 옵션에서 사라진 사이트가 조회조건에 그대로 남아 서버로 나간다.
                        salesSite: 'ALL',
                      });
                    }}
                  />
                )}
              />
            </Grid>
            {/* 목록 구성 조건 = Division + End Customer. Team 은 직접 걸지 않는다 - 위
                endCustomerCodes 주석 참조(AS-IS 가 팀 자리를 비우고 End Customer 집합으로 좁힌다).
                DIVISION_ID 는 관대 매칭(빈 행 통과), END_CUSTOMER 는 좁힐 코드가 있을 때만 건다. */}
            <Grid size={3}>
              <FormItem
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    value={searchParams.salesSite}
                    options={buildComboOptions(salesSites, {
                      division: searchParams.divisionId,
                      narrow: { column: 'END_CUSTOMER', codes: endCustomerCodes },
                    })}
                    onChange={(_, option) => {
                      setSearchParams({
                        salesSite: option,
                      });
                    }}
                  />
                )}
              />
            </Grid>
            {searchParams.divisionId !== '40' && (
              <Grid size={3}>
                <FormItem
                  label={t('LBL00617', '_PJT')}
                  labelAlign='right'
                  className={commonStyles.formItem}
                  render={() => (
                    <InputField
                      fullWidth
                      className={commonStyles.popupSearchField}
                      value={searchParams.projectCode}
                      InputProps={{
                        endAdornment: (
                          <Button
                            appearance='outlined'
                            priority='normal'
                            iconComponent={
                              <FunctionSearchIcon
                                appearance='lined'
                                onClick={() => setOpenProjectByDivisionModal(true)}
                              />
                            }
                          />
                        ),
                      }}
                      onChange={e => setSearchParams({ projectCode: e.target.value })}
                    />
                  )}
                />
              </Grid>
            )}
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
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenItemByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={e => setSearchParams({ itemId: e.target.value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t('LBL00082', '_Owner')}
                labelAlign='right'
                className={commonStyles.formItem}
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={searchParams.owner}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenOwnerByDivisionModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={e => setSearchParams({ owner: e.target.value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3} className={commonStyles.customGrid}>
              <FormItem
                label={t('LBL00007', '_Active')}
                labelAlign='right'
                required
                width='100%'
                className={commonStyles.formItem}
                render={() => (
                  <CustomDropdown
                    limitTags={1}
                    isInput={false}
                    allOption
                    value={searchParams.activeFlag}
                    options={
                      yesOrNo?.map(item => ({
                        label: item.NAME,
                        value: item.CODE,
                      })) ?? []
                    }
                    onChange={(_, options) => {
                      setSearchParams({ activeFlag: options });
                    }}
                  />
                )}
              />
              {searchParams.divisionId !== '40' && (
                <FormItem
                  render={() => (
                    <div className={commonStyles.customCheckbox}>
                      <Checkbox
                        checked={openPurchaseGrid}
                        sx={{ marginLeft: '15px' }}
                        onChange={checked => {
                          if (!checked) setActiveTab(SHEET_INDEX.PRODUCTION);
                          setOpenPurchaseGrid(checked);
                        }}
                      />
                      <Label labelText={t('LBL00316', '_Detail')} depth='sub' />
                    </div>
                  )}
                />
              )}
            </Grid>
          </>
        }
      />
      <ProjectByDivisionModal
        open={openProjectByDivisionModal}
        modalClose={() => setOpenProjectByDivisionModal(false)}
        setSelectedValue={handleProjectByDivisionModal}
        preSearchParams={{ ...searchParams }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openItemByDivisionModal}
        modalClose={() => setOpenItemByDivisionModal(false)}
        setSelectedValue={handleItemByDivisionModal}
        preSearchParams={searchParams}
        callFromCell={false}
      />
      <OwnerByDivisionModal
        open={openOwnerByDivisionModal}
        modalClose={() => setOpenOwnerByDivisionModal(false)}
        setSelectedValue={handleOwnerByDivisionModalSubmit}
        preSearchParams={searchParams}
        ownerId={searchParams.owner}
      />
    </>
  );
};
