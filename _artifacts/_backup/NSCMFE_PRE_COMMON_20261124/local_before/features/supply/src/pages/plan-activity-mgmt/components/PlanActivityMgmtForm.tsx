import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea, sortOptionsBy } from '@shared/components';
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
import { str, toComboOptions } from '../utils/plan-activity-mgmt.util';

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

  const divisionOptions = toComboOptions(divisions);
  // 필터형 cascade — 선택 Division 으로 옵션 좁힘(AS-IS DBUtils.Filter DIVISION_ID='...', design 02 §3).
  //   NAME(label) 정렬은 CustomDropdown sortBy='label'(AS-IS 2025-10-20 OPMZ_PLAN_GR_NAME 정렬 등가).
  //   Division 무선택이면 후보 0(AS-IS RefreshPlanGroupByDivision DIVISION_ID='' 필터 -> 0건 등가).
  const planGroupOptions = sc.divisionId
    ? toComboOptions((planGroups ?? []).filter(row => str(row.DIVISION_ID) === sc.divisionId))
    : [];
  const processOptions = toComboOptions(processes);

  // division 데이터 권한 게이트(design 01 §2 L2) — 권한 division 0건이면 조회영역 비활성 + 안내.
  //   hasButton 권한과 별개 축. 콤보 로딩 완료(undefined 아님) + 0건일 때만 판정.
  const noAuthDivision = divisions !== undefined && divisions.length === 0;
  useEffect(() => {
    if (noAuthDivision) {
      void setAlert({ type: 'alert', content: t(MSG.NO_AUTH_DIVISION, '_No authority assigned.') });
    }
  }, [noAuthDivision, setAlert, t]);

  // 조회조건 기본 선택 — 각 콤보 로드 후 현재값이 옵션에 없으면 첫 항목 자동선택(사용자 요구 2026-10-19:
  //   "조회조건 default 없음 → 첫 데이터 선택"). AS-IS 는 명시 기본값 없음(design 02 §4)이나 스펙 우선.
  //   현재값 보유(has*)를 deps 에 넣어 Reset 으로 비어도 재선택되게 한다(형제 SCP0129 선례).
  //   프로그램 선택이라 dirty confirm 은 건너뛰고, 권한 division 0건(비활성)이면 기본선택도 하지 않는다.
  const firstDivision = divisionOptions[0]?.value;
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (noAuthDivision) return;
    if (!hasDivision && firstDivision) setDivision(firstDivision);
  }, [noAuthDivision, hasDivision, firstDivision, setDivision]);

  // PlanGroup — 선택 Division 으로 필터된 옵션의 첫 항목(Division 기본선택 후 cascade 로 채워진다).
  //   주의: CustomDropdown 이 sortBy='label' 로 표시만 정렬하므로, 기본선택도 같은 정렬의 첫 항목을
  //   골라야 "보이는 첫째"와 일치한다(raw [0] 은 서버순서라 어긋남 — ESS_NAM 앞 ESS_NB 선택 사고).
  const firstPlanGroup = sortOptionsBy(planGroupOptions, 'label')[0];
  const firstPlanGroupValue = firstPlanGroup?.value;
  const firstPlanGroupLabel = firstPlanGroup?.label;
  const hasPlanGroup = planGroupOptions.some(o => o.value === sc.planGroupId);
  useEffect(() => {
    if (noAuthDivision) return;
    if (sc.divisionId && !hasPlanGroup && firstPlanGroupValue) {
      setSearchParams({ planGroupId: firstPlanGroupValue, planGroupName: firstPlanGroupLabel ?? '' });
    }
  }, [
    noAuthDivision,
    sc.divisionId,
    hasPlanGroup,
    firstPlanGroupValue,
    firstPlanGroupLabel,
    setSearchParams,
  ]);

  // Process — 정적 lookup(OPMZ_PRS_CD) 첫 항목(cascade 없음).
  const firstProcessValue = processOptions[0]?.value;
  const firstProcessLabel = processOptions[0]?.label;
  const hasProcess = processOptions.some(o => o.value === sc.prsCd);
  useEffect(() => {
    if (noAuthDivision) return;
    if (!hasProcess && firstProcessValue) {
      setSearchParams({ prsCd: firstProcessValue, prsName: firstProcessLabel ?? '' });
    }
  }, [noAuthDivision, hasProcess, firstProcessValue, firstProcessLabel, setSearchParams]);

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
                  sortBy='label'
                  value={sc.planGroupId}
                  options={planGroupOptions}
                  onChange={(_, picked) => {
                    const option = planGroupOptions.find(o => o.value === picked);
                    // PlanGroup 변경 = 그리드 clear(store setSearchParams). 편집중(dirty)이면 MSG00704 confirm
                    //   후에만 실행, 취소 시 controlled 콤보가 이전 PlanGroup 으로 복귀(Division 과 동일, commit 51d4e9fa 패턴).
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      setSearchParams({
                        planGroupId: String(picked ?? ''),
                        planGroupName: option?.label ?? '',
                      });
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
