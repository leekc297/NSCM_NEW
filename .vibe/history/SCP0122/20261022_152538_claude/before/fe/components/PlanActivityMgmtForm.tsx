import { useEffect, useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import {
  COMBO,
  LBL,
  MENU_ID,
  MSG,
  PROCESS_LOOKUP_TYPE,
} from '../plan-activity-mgmt.constants';
import { usePlanActivityMgmtStore } from '../usePlanActivityMgmtStore';
import { isPicked, sortByNameCi, str, toComboOptions } from '../utils/plan-activity-mgmt.util';

interface Props {
  onSearch: () => void;
}

export const PlanActivityMgmtForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = usePlanActivityMgmtStore(state => state.searchParams);
  const setSearchParams = usePlanActivityMgmtStore(state => state.setSearchParams);
  const setDivision = usePlanActivityMgmtStore(state => state.setDivision);
  const openSearchArea = usePlanActivityMgmtStore(state => state.openSearchArea);
  const setAlert = useMessageStore(state => state.setAlert);

  const tabId = useTabid();

  // 콤보 3 (design 02 §5):
  //   Division  = Division_SCP      (@mnuId raw, @sesUserId 세션 자동 / 권한필터 EE 포함 — WithoutEE 클라필터 금지)
  //   PlanGroup = PlanGroup_SCP_ALL (全件 -> 선택 Division 클라 필터 + NAME 정렬)
  //   Process   = LookupCommon      (@lookupType='OPMZ_PRS_CD', 정적)
  const [divisions, planGroups, processes] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      COMBO.PLAN_GROUP,
      { comboId: COMBO.PROCESS, lookupType: PROCESS_LOOKUP_TYPE },
    ],
  });

  const divisionOptions = useMemo(() => toComboOptions(divisions), [divisions]);
  // 필터형 cascade — 선택 Division 으로 옵션 좁힘(AS-IS DBUtils.Filter DIVISION_ID='...', design 02 §3).
  //   NAME 정렬 = AS-IS SCP0121_GET_SEARCH_INFO Tables[3] `ORDER BY OPMZ_PLAN_GR_NAME`(2025-10-20, CI 콜레이션)을
  //   화면이 재현(sortByNameCi). 공용 sortBy='label' 은 숫자·영문·한글 그룹 + numeric 비교라 AS-IS 순서와 다를 수 있고,
  //   아래 첫 후보 자동선택이 이 순서를 따라야 하므로 쓰지 않는다.
  //   Division 무선택이면 후보 0(AS-IS RefreshPlanGroupByDivision DIVISION_ID='' 필터 -> 0건 등가).
  const planGroupOptions = useMemo(
    () =>
      sc.divisionId
        ? sortByNameCi(
            toComboOptions(
              (planGroups ?? []).filter(row => str(row.DIVISION_ID) === sc.divisionId)
            )
          )
        : [],
    [planGroups, sc.divisionId]
  );
  const processOptions = useMemo(() => toComboOptions(processes), [processes]);

  // AS-IS 는 setListBox(DropDownList 에 DataSource 바인딩, CControl.cs:344-375)라 후보가 실리는 순간 첫 항목이
  //   선택된다 — Form_Load InitControls cs:126-127,174 = Division 첫 행 / Plan Group(선택 Division 필터) 첫 행 /
  //   Process 첫 행, Division 변경 시 RefreshPlanGroupByDivision cs:169-175 재바인딩 = Plan Group 첫 행.
  //   TO-BE CustomDropdown 은 자동 선택을 하지 않으므로 값이 비었거나 현재 후보에 없을 때만 첫 후보를 채운다
  //   (형제 SCP0123 동일 보완). F6 저장 조회조건 복원값이 후보 안에 있으면 덮어쓰지 않는다 — 복원된 Division 과
  //   맞지 않는 Plan Group(후보 밖)만 AS-IS 재바인딩처럼 첫 후보로 바뀐다.
  useEffect(() => {
    if (divisionOptions.length === 0 || isPicked(sc.divisionId, divisionOptions)) return;
    setSearchParams({ divisionId: divisionOptions[0]?.value ?? '' });
  }, [divisionOptions, sc.divisionId, setSearchParams]);

  useEffect(() => {
    if (planGroupOptions.length === 0 || isPicked(sc.planGroupId, planGroupOptions)) return;
    const first = planGroupOptions[0];
    setSearchParams({ planGroupId: first?.value ?? '', planGroupName: first?.label ?? '' });
  }, [planGroupOptions, sc.planGroupId, setSearchParams]);

  useEffect(() => {
    if (processOptions.length === 0 || isPicked(sc.prsCd, processOptions)) return;
    const first = processOptions[0];
    setSearchParams({ prsCd: first?.value ?? '', prsName: first?.label ?? '' });
  }, [processOptions, sc.prsCd, setSearchParams]);

  // division 데이터 권한 게이트(design 01 §2 L2) — 권한 division 0건이면 조회영역 비활성 + 안내.
  //   hasButton 권한과 별개 축. 콤보 로딩 완료(undefined 아님) + 0건일 때만 판정.
  const noAuthDivision = divisions !== undefined && divisions.length === 0;
  useEffect(() => {
    if (noAuthDivision) {
      void setAlert({ type: 'alert', content: t(MSG.NO_AUTH_DIVISION, '_No authority assigned.') });
    }
  }, [noAuthDivision, setAlert, t]);

  // 조회영역 전체 비활성(AS-IS SetDivisionAuthCheck usrLayoutControl2 Enabled=false, design 01 §2 L2) —
  //   콤보 disabled 와 함께 Search 도 무동작으로 막는다(shared SearchArea 무수정 = 화면 함수 게이트).
  const handleSearch = () => {
    if (noAuthDivision) return;
    onSearch();
  };

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={handleSearch}
      conditions={
        <>
          {/* Division (단일 select) — 값=DIVISION_ID, 표시=`DIVISION_ID DIVISION_NAME` */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noAuthDivision}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    // Division 변경 = Division 제외 검색조건(PlanGroup/Process) + 그리드 초기화(store setDivision,
                    //   TO-BE 공통 요건). 편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가
                    //   이전 Div 로 복귀(commit 51d4e9fa 패턴).
                    const v = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Plan Group (단일 select) — 全件 로드 후 Division 클라 필터 + NAME 정렬 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLAN_GROUP, '_Plan Group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noAuthDivision}
                  value={sc.planGroupId}
                  options={planGroupOptions}
                  onChange={(_, picked) => {
                    const option = planGroupOptions.find(o => o.value === picked);
                    // PlanGroup 변경 = 그리드 clear(store setSearchParams).
                    setSearchParams({
                      planGroupId: String(picked ?? ''),
                      planGroupName: option?.label ?? '',
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Process (단일 select) — lookup OPMZ_PRS_CD. cascade 없음(그리드 비우지 않음) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PROCESS, '_Process')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noAuthDivision}
                  value={sc.prsCd}
                  options={processOptions}
                  onChange={(_, picked) => {
                    const option = processOptions.find(o => o.value === picked);
                    setSearchParams({
                      prsCd: String(picked ?? ''),
                      prsName: option?.label ?? '',
                    });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
