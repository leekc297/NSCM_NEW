import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

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
  const openSearchArea = usePlanActivityMgmtStore(state => state.openSearchArea);
  const setAlert = useMessageStore(state => state.setAlert);

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

  // 조회영역 전체 비활성(AS-IS SetDivisionAuthCheck usrLayoutControl2 Enabled=false, design 01 §2 L2) —
  //   콤보 disabled 와 함께 Search 도 무동작으로 막는다(shared SearchArea 무수정 = 화면 함수 게이트).
  const handleSearch = () => {
    if (noAuthDivision) return;
    onSearch();
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={handleSearch}
      conditions={
        <>
          {/* Division (단일 select) — 값=DIVISION_ID, 표시=`DIVISION_ID DIVISION_NAME` */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, { defaultValue: 'Division' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noAuthDivision}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    // Division 변경 = PlanGroup 재필터(선택 초기화) + 그리드 clear(store setSearchParams).
                    setSearchParams({
                      divisionId: String(picked ?? ''),
                      planGroupId: '',
                      planGroupName: '',
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Plan Group (단일 select) — 全件 로드 후 Division 클라 필터 + NAME 정렬 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLAN_GROUP, { defaultValue: 'Plan Group' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noAuthDivision}
                  sortBy='label'
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
              label={t(LBL.PROCESS, { defaultValue: 'Process' })}
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
