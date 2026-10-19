import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore } from '@shared/stores';

import {
  INIT_SET,
  LBL,
  MENU_ID,
  SEARCH_COMBO_ID,
  SHEETS,
} from '../precede-safety-stock-day.constants';
import { usePrecedeSafetyStockDayStore } from '../usePrecedeSafetyStockDayStore';
import {
  buildDivisionFilteredOptions,
  matchSiteByDivision,
  missingRequiredSearchLabel,
} from '../utils/precede-safety-stock-day.util';

interface PrecedeSafetyStockDayFormProps {
  tabId: string;
}

/**
 * 조회조건 — design/01_layout.md §1.1·§4 #6 좌표순서로 8개 논리조건 전건 노출:
 * Row1(Division/Site/Type/Stage) + Row2(Plan Group/Item Id+팝업/Period/Valid). 4열×2행 정합이라
 * overflow 분리 대상이 아니다.
 *
 * Division→PlanGroup/Stage/Site cascade 는 병렬 필터 방식(재조회 아님, §3) — Division 변경 시
 * usePrecedeSafetyStockDayStore.setDivision 이 Division·기간 제외 전 조건 + 그리드를 초기화한다
 * (TO-BE 공통 요건, SCP0025 선례). 편집중이면 MSG00704 confirm 후에만 적용.
 *
 * Site(clbSite)/Stage(cboStage)/Type(cboType) 는 전용 SP `PKG_SCP0127.P_SCP0127_GET_SEARCH_INFO`
 * (init 시트)의 다중커서(o_rc2/o_rc3/o_rc4)에서 옵션을 받는다 — init 호출은 화면당 1회(enabled:true,
 * SP 가 전사 목록 반환 → cascade 는 FE 클라 필터). Site 는 AS-IS RefreshSiteByDivision 재현(EE →
 * IN('81','40','82'), EE_* → 81_* 매핑, 그 외 → = division). Stage 는 DIVISION_ID = division(원값).
 * Type 은 전역(COVER_DAY_TYPE MAX/MIN, Division 하위 아님).
 */
export const PrecedeSafetyStockDayForm = ({ tabId }: PrecedeSafetyStockDayFormProps) => {
  const { t } = useTranslation();

  const searchParams = usePrecedeSafetyStockDayStore(state => state.searchParams);
  const setSearchParams = usePrecedeSafetyStockDayStore(state => state.setSearchParams);
  const setDivision = usePrecedeSafetyStockDayStore(state => state.setDivision);
  const setFilters = usePrecedeSafetyStockDayStore(state => state.setFilters);
  const fetchStaticColumns = usePrecedeSafetyStockDayStore(state => state.fetchStaticColumns);
  const openSearchArea = usePrecedeSafetyStockDayStore(state => state.isOpenSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions, planGroups] = useTabComboQueries({
    filters: [SEARCH_COMBO_ID.DIVISION, SEARCH_COMBO_ID.PLAN_GROUP],
  });
  const [validOptions] = useTabComboQueries({ filters: [SEARCH_COMBO_ID.VALID] });

  // init(GET_SEARCH_INFO) — Site/Stage/Type 다중커서 원천. 화면당 1회(enabled:true, 전사 반환 → FE cascade).
  const initFilters = useMemo(() => ({ divisionId: '', scmSiteId: '' }), []);
  const { data: initData } = useTabProcQuery<MENU_ID, SHEETS.INIT>({
    menuId: MENU_ID,
    sheetName: SHEETS.INIT,
    tabId,
    filters: initFilters,
    enabled: true,
  });

  // Division 단일 선택 — ALL 없음(AS-IS). 콤보 로드 후 현재값이 목록에 없으면 첫 항목 자동선택.
  //   deps 에 "현재값 보유 여부(hasDivision)"를 넣어 Reset 으로 값만 비워져도 재선택되게 한다
  //   (자매 SCP0128 SafetyStockForm 동형, memory f10-reset-default-reselect-needs-has-value-flag-in-deps).
  //   자동선택도 setDivision 경유 — mount/Reset 재선택 시에도 조건·그리드 초기화 상태를 일관되게 둔다
  //   (SCP0025 선례, dirty 가드는 사용자 조작이 아니라 생략).
  const firstDivision = divisions?.[0]?.CODE;
  const hasDivision = !!divisions?.some(item => item.CODE === searchParams.divisionId);
  useEffect(() => {
    if (!hasDivision && firstDivision) {
      setDivision(firstDivision);
    }
  }, [firstDivision, hasDivision, setDivision]);

  // Site(o_rc2) — 선택 Division cascade(AS-IS RefreshSiteByDivision 재현): EE → IN('81','40','82'),
  //   EE_* → 81_* 매핑, 그 외 → = division. 다중선택(util matchSiteByDivision).
  const siteOptions = useMemo(
    () =>
      (initData?.[INIT_SET.SITE] ?? [])
        .filter(item => matchSiteByDivision(item.DIVISION_ID, searchParams.divisionId))
        .map(item => ({ label: item.NAME, value: item.CODE })),
    [initData, searchParams.divisionId]
  );

  // Stage(o_rc3, OPMZ_STAGE_CD: SEGMENT1=DIVISION_ID/SEGMENT3=CODE/ATTRIBUTE1=NAME) — 선택 Division
  //   cascade. AS-IS RefreshStageByDivision 은 DIVISION_ID = division(원값, EE 특수분기 없음). 단일선택.
  //   (기존 useTabLookupQueries 는 DIVISION_ID 컬럼이 없어 필터가 무력화돼 빈 콤보였다 — init o_rc3 로 교정.)
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
                    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                    //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
                    //   복귀한다(commit 51d4e9fa 패턴).
                    onChange={(_, option) => {
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (ok) setDivision(option);
                      });
                    }}
                  />
                )}
              />
            </Grid>
            {/* Site(o_rc2) — init 다중커서. Division cascade + IN('81','40','82'), 다중(콤마결합). */}
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
            {/* Type(o_rc4, COVER_DAY_TYPE MAX/MIN) — 전역(Division 하위 아님), 단일. */}
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
            {/* Stage — AS-IS Designer Row1 끝(cboStage x887, y=12). Division cascade 클라 필터.
                design 01_layout.md §1.1·§4 #6 좌표순서(Row1 = Division/Site/Type/Stage). */}
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
            {/* 2행(AS-IS Designer y=41~43): Plan Group / Item / Period / Valid — clbPlanGroup x77 선두. */}
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
                    options={buildDivisionFilteredOptions(
                      planGroups,
                      searchParams.divisionId,
                      'CODE',
                      'NAME'
                    )}
                    onChange={(_, option) => setSearchParams({ planGroupId: option })}
                  />
                )}
              />
            </Grid>
            {/* Item — 텍스트 + 팝업버튼(MaterialByDivisionModal, division 컨텍스트). 콤마 다중 반환.
                AS-IS txtItemId(326,41)+btnItemId 로 Plan Group 다음·Period 앞. 팝업버튼이 달렸다는
                이유만으로 extraConditions 로 분리하지 않고 AS-IS Designer 좌표 순서를 지킨다
                (조건 6개 = 4열×2행 정합, overflow 아님). */}
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
            {/* Valid — 단일 콤보(YesOrNo). AS-IS cboValid(887,43) 2행 맨 끝에 정상 배치된 조건. */}
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
          scpModuleType: 'SCP0127',
        }}
        setSelectedValue={items => setSearchParams({ itemId: items })}
      />
    </>
  );
};
