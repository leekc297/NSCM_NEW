import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { COMBO, INIT_SET, LBL, MENU_ID, SHEETS } from '../safety-stock.constants';
import { useSafetyStockStore } from '../useSafetyStockStore';
import { matchSiteByDivision, missingRequiredSearchLabel } from '../utils/safety-stock.util';

interface SafetyStockFormProps {
  tabId: string;
}

/**
 * 조회조건 — design/02_search-combo.md §1 인벤토리 8개 논리조건 전건
 * (Division/Site/Type/Stage/Plan Group/Item Id+팝업/Period/Valid).
 *
 * Division cascade(PlanGroup/Site/Stage)는 클라 필터 방식(재조회 아님, §3) — Division 변경 시
 * useSafetyStockStore.setSearchParams 가 하위 선택값을 초기화한다.
 *
 * Site(clbSite)/Type(cboType)/Stage(cboStage) 는 전용 SP `PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO`
 * (init 시트)의 다중커서에서 옵션을 받는다 — AS-IS GetSearchInfo(.cs:190~215) DataSet Tables[1]/[3]/[2]
 * ↔ o_rc2/o_rc4/o_rc3. init 호출은 화면당 1회(Division 변경 시 재호출 안 함 — SP 가 전사 목록을
 * 반환하고 cascade 는 FE 클라 필터로 처리, 자매 workbench W23 동형).
 */
export const SafetyStockForm = ({ tabId }: SafetyStockFormProps) => {
  const { t } = useTranslation();

  const searchParams = useSafetyStockStore(state => state.searchParams);
  const setSearchParams = useSafetyStockStore(state => state.setSearchParams);
  const setFilters = useSafetyStockStore(state => state.setFilters);
  const fetchStaticColumns = useSafetyStockStore(state => state.fetchStaticColumns);
  const openSearchArea = useSafetyStockStore(state => state.isOpenSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions, planGroups] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_GROUP],
  });
  const [validOptions] = useTabComboQueries({ filters: [COMBO.VALID] });

  // init(GET_SEARCH_INFO) — 조회조건 콤보(Site/Type/Stage) 다중커서 원천. 화면당 1회(enabled:true).
  //   siteId 는 전사 반환이므로 빈 값으로 호출하고 FE 가 Division cascade 한다.
  const initFilters = useMemo(() => ({ divisionId: '', scmSiteId: '' }), []);
  const { data: initData } = useTabProcQuery<MENU_ID, SHEETS.INIT>({
    menuId: MENU_ID,
    sheetName: SHEETS.INIT,
    tabId,
    filters: initFilters,
    enabled: true,
  });

  // Division 단일 선택 — 콤보 로드 후 현재값이 목록에 없으면 첫 항목 자동선택(AS-IS 는 ALL 없음).
  //   deps 에 옵션뿐 아니라 "현재값 보유 여부"를 넣어 Reset 으로 값만 비워져도 재선택되게 한다.
  const firstDivision = divisions?.[0]?.CODE;
  const hasDivision = !!divisions?.some(item => item.CODE === searchParams.divisionId);
  useEffect(() => {
    if (!hasDivision && firstDivision) {
      setSearchParams({ divisionId: firstDivision });
    }
  }, [firstDivision, hasDivision, setSearchParams]);

  // Site(o_rc2) — 선택 Division cascade(AS-IS RefreshSiteByDivision 재현): EE → IN('81','40','82'),
  //   EE_* → 81_* 매핑, 그 외 → = division. 다중선택(util matchSiteByDivision).
  const siteOptions = useMemo(
    () =>
      (initData?.[INIT_SET.SITE] ?? [])
        .filter(item => matchSiteByDivision(item.DIVISION_ID, searchParams.divisionId))
        .map(item => ({ label: item.NAME, value: item.CODE })),
    [initData, searchParams.divisionId]
  );

  // Stage(o_rc3) — 선택 Division cascade. 단일선택.
  const stageOptions = useMemo(
    () =>
      (initData?.[INIT_SET.STAGE] ?? [])
        .filter(item => item.DIVISION_ID === searchParams.divisionId)
        .map(item => ({ label: item.NAME, value: item.CODE })),
    [initData, searchParams.divisionId]
  );

  // Type(o_rc4, COVER_DAY_TYPE MAX/MIN) — Division 하위 아님(전역). 단일선택.
  const typeOptions = useMemo(
    () => (initData?.[INIT_SET.TYPE] ?? []).map(item => ({ label: item.NAME, value: item.CODE })),
    [initData]
  );

  const onSearch = () => {
    // AS-IS checkRequired(Designer "*": Division/Period) — 비면 필드별 MSG00614 로 차단.
    const missLbl = missingRequiredSearchLabel(searchParams);
    if (missLbl) {
      void useMessageStore.getState().setAlert({
        type: 'alert',
        content: t('MSG00614', '_{0} 값은 필수 입력입니다.').replace('{0}', `[${t(missLbl, '')}]`),
      });
      return;
    }
    setFilters();
    void fetchStaticColumns();
  };

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {/* 1행(AS-IS y=12): Division/Site/Type/Stage — design 02_search-combo.md §1 좌표 순서. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, '_Div')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    onChange={(_, option) => setSearchParams({ divisionId: option })}
                  />
                )}
              />
            </Grid>
            {/* Site/Type/Stage — init(GET_SEARCH_INFO) 다중커서 원천(o_rc2/o_rc4/o_rc3).
                Site/Stage 는 Division cascade, Type 은 전역. Site 는 다중(콤마결합, allOption),
                Type/Stage 는 단일(allOption). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.SITE, '_SCM Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    value={searchParams.scmSiteId}
                    options={siteOptions}
                    onChange={(_, option) => setSearchParams({ scmSiteId: option })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.TYPE, '_Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    allOption
                    value={searchParams.valueType}
                    options={typeOptions}
                    onChange={(_, option) => setSearchParams({ valueType: option })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.STAGE, '_Stage')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    allOption
                    value={searchParams.stage}
                    options={stageOptions}
                    onChange={(_, option) => setSearchParams({ stage: option })}
                  />
                )}
              />
            </Grid>
            {/* 2행(AS-IS y=39~43): Plan Group/Item/Period/Valid — AS-IS Designer 좌표상 Item 은
                clbPlanGroup(77,41)과 dCalendar(607,39) 사이(txtItemId 324,41)에 다른 조건과 동등히
                배치된다. 팝업버튼이 달렸다는 이유만으로 extraConditions 로 분리하지 않고 그 순서를
                지킨다(조건 8개 = 4열×2행 정합, overflow 아님). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PLAN_GROUP, '_Plan Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    value={searchParams.planGroupId}
                    options={
                      planGroups
                        ?.filter(item => !item.DIVISION_ID || item.DIVISION_ID === searchParams.divisionId)
                        .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, option) => setSearchParams({ planGroupId: option })}
                  />
                )}
              />
            </Grid>
            {/* Item — 텍스트 + 팝업버튼(MaterialByDivisionModal, division 컨텍스트). 콤마 다중 반환.
                AS-IS txtItemId(324,41)+btnItemId 로 Plan Group 다음·Period 앞. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.ITEM, '_Model/Nickname')}
                labelAlign='right'
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
                              onClick={() => setOpenItemModal(true)}
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
              <PeriodRangePicker
                label={t(LBL.PERIOD, '_Period')}
                start={searchParams.periodFrom}
                end={searchParams.periodTo}
                onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.VALID, '_Active')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    allOption
                    value={searchParams.validYn}
                    options={
                      validOptions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, option) => setSearchParams({ validYn: option })}
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
        preSearchParams={{
          divisionId: searchParams.divisionId,
          itemId: searchParams.itemId,
          scpModuleType: 'SCP0128',
        }}
        setSelectedValue={items => setSearchParams({ itemId: items })}
      />
    </>
  );
};
