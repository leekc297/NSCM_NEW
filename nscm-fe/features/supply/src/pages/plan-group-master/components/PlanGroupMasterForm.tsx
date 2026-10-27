import { useEffect, useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import {
  confirmIfDirtyKey,
  tabDirtyKey,
  useMessageStore,
  useTabid,
} from '@shared/stores';

import {
  ALL,
  DIVISION_COMBO_ID,
  LABELS,
  MENU_ID,
  MSG,
} from '../plan-group-master.constants';
import type { LineInfoRow, SearchInfoRow } from '../plan-group-master.types';
import { usePlanGroupMasterStore } from '../usePlanGroupMasterStore';
import {
  buildBuildingOptions,
  buildLineOptions,
  buildOperationOptions,
  buildPlanGroupOptions,
  buildPlantOptions,
  pruneSelection,
} from '../utils/plan-group-master.searchInfo';

interface PlanGroupMasterFormProps {
  operationRows: readonly SearchInfoRow[];
  plantRows: readonly SearchInfoRow[];
  buildingRows: readonly SearchInfoRow[];
  lineRows: readonly LineInfoRow[];
  planGroupRows: readonly SearchInfoRow[];
  onSearch: () => void;
}

export const PlanGroupMasterForm = ({
  operationRows,
  plantRows,
  buildingRows,
  lineRows,
  planGroupRows,
  onSearch,
}: PlanGroupMasterFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = usePlanGroupMasterStore(state => state.openSearchArea);
  const initialized = usePlanGroupMasterStore(state => state.initialized);
  const searchParams = usePlanGroupMasterStore(state => state.searchParams);
  const setSearchParams = usePlanGroupMasterStore(state => state.setSearchParams);

  // Division 콤보 — Division_SCP (권한필터, EE 포함). Division_SCP_NoEE/MyDivision 오매핑 금지(02 §2-A).
  const [divisions] = useTabComboQueries({
    filters: [{ comboId: DIVISION_COMBO_ID, mnuId: MENU_ID }],
  });

  const { setToast } = useMessageStore.getState();
  const tabId = useTabid();

  // 권한 Division 0건 → SearchArea 비활성 + MSG00097 1회 (R2, SetDivisionAuthCheck 등가).
  const divisionCodes = useMemo(
    () => (divisions ?? []).map(item => String(item.CODE ?? '')).filter(Boolean),
    [divisions]
  );
  const noDivision = initialized && divisionCodes.length === 0;
  useEffect(() => {
    if (noDivision) void setToast({ type: 'error', message: t(MSG.REQUIRE_DIVISION, '_No authorized Division.') });
  }, [noDivision, setToast, t]);

  // AS-IS 기본 Division = 권한 콤보 첫 행(02 §4, 세션 div 강제선택 없음 — GAP-10 해소).
  //   현재 선택이 권한 목록 밖(초기 빈값·F6 복원 실패 포함)이면 첫 행으로 채운다. F6 복원값이 권한 내면 유지.
  useEffect(() => {
    if (!initialized || divisionCodes.length === 0) return;
    if (divisionCodes.includes(searchParams.divisionId)) return;
    setSearchParams({ divisionId: divisionCodes[0] });
  }, [initialized, divisionCodes, searchParams.divisionId, setSearchParams]);

  const division = searchParams.divisionId;

  // 클라 필터 cascade (재조회 아님). Division + 상위축 변경 시 하위 옵션 재계산.
  const operationOptions = useMemo(
    () => buildOperationOptions(operationRows, division),
    [operationRows, division]
  );
  const plantOptions = useMemo(
    () => buildPlantOptions(plantRows, division),
    [plantRows, division]
  );
  const buildingOptions = useMemo(
    () => buildBuildingOptions(buildingRows, division),
    [buildingRows, division]
  );
  const planGroupOptions = useMemo(
    () => buildPlanGroupOptions(planGroupRows, division),
    [planGroupRows, division]
  );
  const lineOptions = useMemo(
    () =>
      buildLineOptions(
        lineRows,
        division,
        searchParams.operation,
        searchParams.plant,
        searchParams.building
      ),
    [lineRows, division, searchParams.operation, searchParams.plant, searchParams.building]
  );

  // Division 외 조회조건(Operation/Plant/Building/Line/Plan Group) 변경은 조건만 갱신하고 그리드는 보존한다.
  //   그리드 초기화는 cascade root 인 Division 변경에서만(store setSearchParams 가 filters 를 비움, SRCH-07).
  //   비-Division 변경은 결과를 지우지 않으므로 dirty 가드 불필요(조회(Search) 전까지 편집분 유지).
  const changeCondition = (patch: Partial<typeof searchParams>) => {
    setSearchParams(patch);
  };

  // 상위축(Op/Plant/Building) 변경 → Line 재필터 + Line 선택 prune (02 §3).
  const changeLineParent = (patch: Partial<typeof searchParams>) => {
    const next = { ...searchParams, ...patch };
    const nextLineOptions = buildLineOptions(
      lineRows,
      division,
      next.operation,
      next.plant,
      next.building
    );
    changeCondition({ ...patch, line: pruneSelection(next.line, nextLineOptions) });
  };

  const disabled = noDivision;

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
              label={t(LABELS.DIVISION, '_Division')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={division}
                  disabled={disabled}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, value) => {
                    // Division 변경 = 하위 5 리셋 + 그리드 clear(store). 편집 중이면 MSG00704 confirm 후에만(GAP-01).
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setSearchParams({ divisionId: value });
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABELS.OPERATION, '_Operation')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={searchParams.operation}
                  options={operationOptions}
                  onChange={(_, value) => changeLineParent({ operation: value || ALL })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABELS.PLANT, '_Plant')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={searchParams.plant}
                  options={plantOptions}
                  onChange={(_, value) => changeLineParent({ plant: value || ALL })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABELS.BUILDING, '_Building')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={searchParams.building}
                  options={buildingOptions}
                  onChange={(_, value) => changeLineParent({ building: value || ALL })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABELS.LINE, '_Line')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={searchParams.line}
                  options={lineOptions}
                  onChange={(_, value) => changeCondition({ line: value || ALL })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABELS.PLAN_GROUP, '_Plan Group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={searchParams.planGroup}
                  options={planGroupOptions}
                  onChange={(_, value) => changeCondition({ planGroup: value || ALL })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
