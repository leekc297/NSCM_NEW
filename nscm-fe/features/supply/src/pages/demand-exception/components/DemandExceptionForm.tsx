import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, INIT_SET, MENU_ID, SHEETS } from '../demand-exception.constants';
import { useDemandExceptionStore } from '../useDemandExceptionStore';
import { matchSiteByDivision } from '../utils/demandExceptionSiteCascade';

/**
 * 조회조건 — design/02_search-combo.md §1 인벤토리 7논리조건 전건
 * (Division/Site/Plan Group/Item Id+팝업/Stage/Period/Valid Yn) 데이터 배선 완료.
 *
 * 데이터소스(AS-IS .cs + DB 실측 2026-10-13 확정):
 *   · Division = CMBO `Division_SCP`(BLUtils.GetDivision, .cs:45) — 단일, ALL 없음, 첫 항목 자동선택.
 *   · Valid    = CMBO `YesOrNo`(cboValid.DataBind(YesOrNo,true), .cs:174) — 단일, allOption.
 *   · PlanGroup/Site/Stage = init 시트(PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO) 다중커서
 *     o_rc1/o_rc2/o_rc7(INIT_SET). GetSearchInfo(.cs:191~216)가 SCP0128 SP 를 재사용하는 AS-IS 를
 *     그대로 이식 — Stage 는 O_RC7(ATTRIBUTE3='Y' 신버전, .cs:181~182)을 읽는다(SCP0128 은 O_RC3).
 *
 * Division cascade(PlanGroup/Site/Stage)는 전부 클라 필터 방식(재조회 아님, §3) — Division 변경 시
 *   useDemandExceptionStore.setDivision 이 하위 선택값·그리드를 초기화한다. Site 만 EE 분기
 *   (matchSiteByDivision), PlanGroup/Stage 는 DIVISION_ID 단순일치(.cs:254~283 재현).
 */
export const DemandExceptionForm = () => {
  const { t } = useTranslation();

  const searchParams = useDemandExceptionStore(state => state.searchParams);
  const setSearchParams = useDemandExceptionStore(state => state.setSearchParams);
  const setDivision = useDemandExceptionStore(state => state.setDivision);
  const setFilters = useDemandExceptionStore(state => state.setFilters);
  const fetchStaticColumns = useDemandExceptionStore(state => state.fetchStaticColumns);
  const openSearchArea = useDemandExceptionStore(state => state.isOpenSearchArea);

  const tabId = useTabid();

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const [validOptions] = useTabComboQueries({ filters: [COMBO.VALID] });

  // init(GET_SEARCH_INFO) — PlanGroup/Site/Stage 다중커서 원천. 화면당 1회(enabled:true). 전사 목록을
  //   받아 FE 가 Division cascade 하므로 divisionId/scmSiteId 는 빈 값으로 호출(형제 SCP0128 동형).
  const initFilters = useMemo(() => ({ divisionId: '', scmSiteId: '' }), []);
  const { data: initData } = useTabProcQuery<MENU_ID, SHEETS.INIT>({
    menuId: MENU_ID,
    sheetName: SHEETS.INIT,
    tabId,
    filters: initFilters,
    enabled: true,
  });

  // Division 단일 선택 — 콤보 로드 후 현재값이 목록에 없으면 첫 항목 자동선택(AS-IS 는 ALL 없음).
  //   현재값 보유 여부를 deps 에 넣어 Reset 으로 값만 비워져도 재선택되게 한다. setDivision 경유라
  //   하위 cascade 초기화를 함께 태운다(프로그램 선택이므로 dirty confirm 은 건너뜀).
  const firstDivision = divisions?.[0]?.CODE;
  const hasDivision = !!divisions?.some(item => item.CODE === searchParams.divisionId);
  useEffect(() => {
    if (!hasDivision && firstDivision) {
      setDivision(firstDivision);
    }
  }, [firstDivision, hasDivision, setDivision]);

  // PlanGroup(o_rc1) — 선택 Division 단순일치(AS-IS RefreshPlanGroupByDivision .cs:254). 다중선택.
  const planGroupOptions = useMemo(
    () =>
      (initData?.[INIT_SET.PLAN_GROUP] ?? [])
        .filter(item => item.DIVISION_ID === searchParams.divisionId)
        .map(item => ({ label: item.NAME, value: item.CODE })),
    [initData, searchParams.divisionId]
  );

  // Site(o_rc2) — 선택 Division cascade(AS-IS RefreshSiteByDivision .cs:261, EE 분기). 다중선택.
  const siteOptions = useMemo(
    () =>
      (initData?.[INIT_SET.SITE] ?? [])
        .filter(item => matchSiteByDivision(item.DIVISION_ID, searchParams.divisionId))
        .map(item => ({ label: item.NAME, value: item.CODE })),
    [initData, searchParams.divisionId]
  );

  // Stage(o_rc7, ATTRIBUTE3='Y') — 선택 Division 단순일치(AS-IS RefreshStageByDivision .cs:277). 단일.
  const stageOptions = useMemo(
    () =>
      (initData?.[INIT_SET.STAGE] ?? [])
        .filter(item => item.DIVISION_ID === searchParams.divisionId)
        .map(item => ({ label: item.NAME, value: item.CODE })),
    [initData, searchParams.divisionId]
  );

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
            {/* 1행(design 02 §1 x좌표 순서): Division/Site/Stage/ValidYn. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00001', '_Div')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통
                    //   요건). 편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가
                    //   이전 Div 로 복귀(commit 51d4e9fa 패턴).
                    onChange={(_, option) => {
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (ok) setDivision(option);
                      });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00015', '_Site')}
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
                label={t('LBL00061', '_Stage')}
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
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00639', '_Active')}
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
            {/* 2행: Plan Group / Model(팝업) / Period — AS-IS Designer 좌표 순서(txtItemId 가 Plan Group
                다음, Period 앞). 형제 SCP0128 선례와 동일. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00002', '_Plan Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    value={searchParams.planGroupId}
                    options={planGroupOptions}
                    onChange={(_, option) => setSearchParams({ planGroupId: option })}
                  />
                )}
              />
            </Grid>
            {/* Model(Item) — 텍스트 + 팝업버튼(MaterialByDivisionModal). AS-IS txtItemId(324,41)+btnItemId
                로 Plan Group 다음·Period 앞. 팝업버튼이 달렸다는 이유로 extraConditions 로 접지 않고 그
                순서대로 메인 조회조건에 노출(형제 SCP0128 선례와 동일). 라벨 LBL00618 'Model/Nickname'. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00618', '_Model/Nickname')}
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
                label={t('LBL00013', '_Period')}
                start={searchParams.periodFrom}
                end={searchParams.periodTo}
                onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
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
          scpModuleType: 'SCP0129',
        }}
        setSelectedValue={items => setSearchParams({ itemId: items })}
      />
    </>
  );
};