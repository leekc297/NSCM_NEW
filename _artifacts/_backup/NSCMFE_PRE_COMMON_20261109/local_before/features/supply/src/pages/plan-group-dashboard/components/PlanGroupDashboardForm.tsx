import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  COMPLETED_YN_OPTIONS,
  MENU_ID,
  PLAN_GROUP_DASHBOARD_COMBO_ID,
  RESPONSE_SET,
  SHEETS,
} from '../plan-group-dashboard.constants';
import { buildDivisionFilteredOptions } from '../plan-group-dashboard.util';
import { usePlanGroupDashboardStore } from '../usePlanGroupDashboardStore';

// searchInfo 조회 파라미터 — AS-IS p_user_id='' 고정(owner 필터 우회). 모듈 상수로 둬 참조를
//   고정한다: useTabProcQuery 는 filters 참조가 바뀌면 값이 같아도 재조회로 판정해 캐시를 비우므로,
//   렌더 본문 인라인 객체로 넘기면 매 렌더 재조회 루프가 돈다(useCustomQueryClient.ts 훅 주석).
const SEARCH_INFO_FILTERS: { userId: string } = { userId: '' };

/**
 * 조회조건 5종 — AS-IS SCP0124_PlanGroupDashboard `usrConditionPanel1` 의
 * cboDivision/cboPlanGroup/clbPlant/cboCompleted/dCalendar 그대로. 배치 순서는 AS-IS Designer
 * x좌표(좌→우) 그대로: Division(56)→Plan Group(265)→Plant(433)→Completed(665)→기간(741).
 *
 * Division→(Plan Group·Plant) cascade 는 병렬 필터 방식(재조회 아님) — AS-IS SetChangedControl 이
 * RefreshPlanGroupByDivision/RefreshPlantIdByDivision 로 이미 받아둔 전량(searchInfo 커서)을
 * DIVISION_ID 로 좁힌다(cs:214-235). buildDivisionFilteredOptions 로 재현한다.
 *
 * Plan Group·Plant 공급원 = 공용 `P_SCP0121_GET_SEARCH_INFO`(searchInfo 시트)의 planGroupList
 * (AS-IS Tables[3])·plantList(AS-IS Tables[0]) 커서. AS-IS `GetSearchInfo()` 가 p_user_id='' 로
 * 부르므로 owner 필터 없이 전량을 받는다(cs:187-191). 자매 SCP0123 searchInfo 선례.
 *
 * Division 은 권한 콤보(Division_SCP), ALL 옵션 없음, 기본값 = 권한목록 첫 행(AS-IS setListBox
 * DataSource 바인딩 index 0 자동선택). Completed 는 Y/N 리터럴 + ALL(AS-IS YesOrNo+true).
 */
interface PlanGroupDashboardFormProps {
  // 조회 트리거 — 기간 검증(validatePeriodRange) 후 setFilters/컬럼 재조회까지 상위가 소유한다.
  //   SearchArea Search 버튼과 SubTitle F5 가 같은 핸들러를 쓰도록 상위에서 주입한다.
  onSearch: () => void;
}

export const PlanGroupDashboardForm = ({ onSearch }: PlanGroupDashboardFormProps) => {
  const { t } = useTranslation();
  const tabId = useTabid();

  const searchParams = usePlanGroupDashboardStore(state => state.searchParams);
  const setSearchParams = usePlanGroupDashboardStore(state => state.setSearchParams);
  const setDivision = usePlanGroupDashboardStore(state => state.setDivision);
  const openSearchArea = usePlanGroupDashboardStore(state => state.isOpenSearchArea);

  // Division 권한 콤보 — Division_SCP(@sesUserId/@mnuId 권한조인). AS-IS BLUtils.GetDivision(false,"").
  const [divisions] = useTabComboQueries({
    filters: [{ comboId: PLAN_GROUP_DASHBOARD_COMBO_ID.DIVISION, mnuId: MENU_ID }],
  });

  // Plan Group / Plant 는 콤보 레지스트리가 아니라 공용 searchInfo SP 의 커서다(AS-IS 와 동일).
  //   AS-IS p_user_id='' 고정 → owner 필터 우회(전량). division 좁힘은 아래 FE 클라 필터.
  const { data: searchInfoData } = useTabProcQuery<MENU_ID, SHEETS.SEARCH_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.SEARCH_INFO,
    tabId,
    filters: SEARCH_INFO_FILTERS,
    enabled: true,
  });
  const planGroups = searchInfoData?.[RESPONSE_SET.PLAN_GROUP_LIST];
  const plants = searchInfoData?.[RESPONSE_SET.PLANT_LIST];

  // Division 기본값 = 권한목록 첫 행(세션 division 아님). AS-IS setListBox 가 index 0 을 자동 선택.
  //   dep 에 divisionId(값 축)를 포함한다 — F10(resetSearchCondition→reset())이 divisionId 를 '' 로
  //   비워도 divisions(React Query data)는 참조가 그대로라 [divisions] 만으로는 effect 가 재실행되지
  //   않아 Division 콤보가 공란으로 남는다(삭제형 잔재 — AS-IS 는 F10 후 index 0 복귀). 값 축을 watch 해
  //   비면 첫 행으로 자가복구한다(필수 기본값이라 플래그 불요 — f10-wipes-mount-seeded-default-dates 패턴).
  //   채워진 뒤(0→N)엔 `!divisionId` 가드가 즉시 return → 중복 setDivision·루프 없음.
  useEffect(() => {
    const first = divisions?.[0]?.CODE;
    if (!searchParams.divisionId && first) setDivision(String(first));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions, searchParams.divisionId]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Division')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE
                  //   공통 요건). 편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled
                  //   콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
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
              label={t('LBL00002', '_Plan Group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
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
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00030', '_Plant')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.plantId}
                  options={buildDivisionFilteredOptions(
                    plants,
                    searchParams.divisionId,
                    'CODE',
                    'NAME'
                  )}
                  onChange={(_, option) => setSearchParams({ plantId: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00058', '_Completed')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={searchParams.completedYn}
                  options={[...COMPLETED_YN_OPTIONS]}
                  onChange={(_, option) => setSearchParams({ completedYn: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <PeriodRangePicker
              allowTextInput
              label={t('LBL00013', '_Period')}
              start={searchParams.startDate}
              end={searchParams.endDate}
              onChange={(start, end) => setSearchParams({ startDate: start, endDate: end })}
            />
          </Grid>
        </>
      }
    />
  );
};
