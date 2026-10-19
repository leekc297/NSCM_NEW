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

  // 조회조건 콤보는 단계마다 자기 콤보를 따로 조회한다. cascade(상위 선택으로 하위 목록 좁히기)는
  // 아래 각 CustomDropdown 의 options 에서 클라이언트 필터로 건다.
  const [divisions, endCustomers, salesSites, yesOrNo] = useTabComboQueries({
    filters: ['MyDivision', 'EndCustomer', 'SalesSite', 'YesOrNo'],
  });

  // Team 콤보는 divisionId 를 파라미터로 받아야 한다 (AS-IS 콜사이트 계약 = @Param1=division 재조회).
  //   TeambyDivision 은 40 이 owner 경로 전용 분기라, 미전달('ALL' 분기)로는 40 팀이 영원히
  //   반환되지 않는다 (40 SALES 사이트는 DEPT 미배정 설계).
  //   주의: BE makeComboQuery 는 등록 SQL 의 @키를 bind 가 아니라 raw 문자열로 치환한다 —
  //   작은따옴표를 포함해 넘겨야 SQL 리터럴이 된다. division 변경 = 쿼리키 변경 = 자동 재조회.
  const [teams] = useTabComboQueries({
    filters: [{ comboId: 'TeambyDivision', divisionId: `'${searchParams.divisionId}'` }],
  });

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
                    options={(divisions ?? []).map(item => ({ label: item.NAME, value: item.CODE }))}
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
                label={t('LBL00502', 'Team')}
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
                    options={[
                      ...new Map(
                        (teams ?? [])
                          // TeambyDivision 은 DIVISION_ID 가 비어 내려오는 행이 있다 — 자르면
                          // 목록이 통째로 비므로 남긴다.
                          .filter(
                            item => !item.DIVISION_ID || item.DIVISION_ID === searchParams.divisionId
                          )
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE }))}
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
            {/* cascade = division - team. 'EndCustomer' 콤보는 DEPT_ID 가 공란인 행이 대다수라
                (SITE_ITEM LEFT OUTER JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다 —
                필터가 통째로 무력화된다. 그래서 DEPT_ID 는 엄격 매칭이다. */}
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
                    options={[
                      ...new Map(
                        (endCustomers ?? [])
                          .filter(
                            item =>
                              item.DIVISION_ID === searchParams.divisionId &&
                              (searchParams.deptId === 'ALL' ||
                                searchParams.deptId.split(',').includes(item.DEPT_ID))
                          )
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE }))}
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
            {/* cascade = division - team. 'SalesSite' 콤보도 DEPT_ID 는 엄격 매칭 — End Customer
                와 같은 이유다. End Customer 선택은 이 목록을 좁히지 않는다: 이 콤보는 END_CUSTOMER
                컬럼을 내려주지 않아 대응시킬 컬럼이 없다. */}
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
                    options={[
                      ...new Map(
                        (salesSites ?? [])
                          .filter(
                            item =>
                              item.DIVISION_ID === searchParams.divisionId &&
                              (searchParams.deptId === 'ALL' ||
                                searchParams.deptId.split(',').includes(item.DEPT_ID))
                          )
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE }))}
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
