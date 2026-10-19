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
  useSessionStore,
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
  const clearMainFilters = usePlanGroupMasterStore(state => state.clearMainFilters);

  // Division 콤보 — Division_SCP (권한필터, EE 포함). Division_SCP_NoEE/MyDivision 오매핑 금지(02 §2-A).
  const [divisions] = useTabComboQueries({
    filters: [{ comboId: DIVISION_COMBO_ID, mnuId: MENU_ID }],
  });

  const { setToast } = useMessageStore.getState();
  const sessionDiv = useSessionStore(state => state.session.div);
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

  // 권한 목록 밖 Division 보정 (sales-site/MktFcst 규약). 세션 div 가 목록에 있으면 그것, 없으면 첫 행.
  useEffect(() => {
    if (!initialized || divisionCodes.length === 0) return;
    if (divisionCodes.includes(searchParams.divisionId)) return;
    const picked = divisionCodes.includes(String(sessionDiv ?? ''))
      ? String(sessionDiv)
      : divisionCodes[0];
    setSearchParams({ divisionId: picked });
  }, [initialized, divisionCodes, searchParams.divisionId, sessionDiv, setSearchParams]);

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

  // 조회조건 변경은 전건 그리드 즉시 clear (SRCH-07 / §3 ClearDataSource).
  //   편집가능 그리드라 미저장 편집(dirty)이 있으면 clear 전 MSG00704 confirm(GAP-01, 커밋 51d4e9fa 패턴).
  //   취소 시 controlled 콤보가 이전 값으로 복귀(setSearchParams 미실행). 조회(Search) 와 동일 'search' 가드.
  const changeCondition = (patch: Partial<typeof searchParams>) => {
    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
      if (!ok) return;
      setSearchParams(patch);
      clearMainFilters();
    });
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
