import { useEffect, useMemo, useRef, useState } from 'react';

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
  const clearMainFilters = usePlanGroupMasterStore(state => state.clearMainFilters);

  // Div 확인창 Cancel 때 콤보 표시 원복용 key(갭분석 C-01). 선택 칸(MUI Autocomplete)은 value 가 그대로여도
  //   입력란 글자를 클릭한 항목으로 바꿔 두므로, Cancel 이면 key 를 바꿔 다시 그려 이전 Div 로 되돌린다.
  const [divisionKey, setDivisionKey] = useState(0);

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

  // Line 은 조건만 갱신한다 — AS-IS 는 Line 변경 이벤트가 없어 그리드를 유지한다(cs:313-317).
  const changeCondition = (patch: Partial<typeof searchParams>) => {
    setSearchParams(patch);
  };

  // 체크리스트(Op/Plant/Building/Plan Group)는 체크할 때마다 조건만 갱신하고, 그리드 clear 는
  //   드롭다운을 '닫을 때'로 미룬다(AS-IS 파리티). AS-IS UsrCheckedList2 는 개별 체크
  //   (clb_SelectedIndexChanged)로는 이벤트를 쏘지 않고(해당 발화 주석처리 cs:814-837), 드롭다운이
  //   닫히며 origin(열 때 값) 대비 '실제로 바뀐 경우에만' SelectedIndexChanged → ClearDataSource 를
  //   1회 발화한다(cs:1455 `origin_chk == cbo.Text → return`, 1489-1498). 체크 즉시 비우거나 같은 값으로
  //   되돌려 닫을 때도 비우면 AS-IS 와 달라 사용자 신고(2026-11-13).
  //
  //   열 때 그 콤보의 값을 스냅샷해 두고, 닫을 때 현재 값과 비교해 다를 때만 비운다. 한 번에 하나만
  //   열리므로 ref 하나로 충분하고, axis 는 콤보별로 바인딩한다.
  const openValueRef = useRef<string | null>(null);

  const handleConditionOpen = (axis: keyof typeof searchParams) => () => {
    openValueRef.current = searchParams[axis];
  };

  // 드롭다운 닫힘 — 열 때 대비 값이 실제로 바뀐 경우에만 그리드를 비운다(AS-IS 닫힘 시 ClearDataSource).
  //   같은 값으로 되돌려 닫으면 비우지 않는다. 저장 안 한 변경이 있으면 MSG00704 확인 후에만 진행(TO-BE 안전장치).
  const handleConditionClose = (axis: keyof typeof searchParams) => () => {
    const opened = openValueRef.current;
    openValueRef.current = null;
    if (opened === null || searchParams[axis] === opened) return;
    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
      if (!ok) return;
      clearMainFilters();
    });
  };

  // 상위축(Op/Plant/Building) 변경 → Line 재필터 + Line 선택 prune (02 §3). 그리드 clear 는 닫힘으로 미룸.
  const changeLineParent = (patch: Partial<typeof searchParams>) => {
    const next = { ...searchParams, ...patch };
    const nextLineOptions = buildLineOptions(
      lineRows,
      division,
      next.operation,
      next.plant,
      next.building
    );
    setSearchParams({ ...patch, line: pruneSelection(next.line, nextLineOptions) });
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
                  key={divisionKey}
                  value={division}
                  disabled={disabled}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, value) => {
                    // Division 변경 = 하위 5 리셋 + 그리드 clear(store). 편집 중이면 MSG00704 confirm 후에만(GAP-01).
                    //   취소 시 key 를 바꿔 콤보를 이전 Div 로 다시 그린다(갭분석 C-01).
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setSearchParams({ divisionId: value });
                      else setDivisionKey(k => k + 1);
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
                  onOpen={handleConditionOpen('operation')}
                  onClose={handleConditionClose('operation')}
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
                  onOpen={handleConditionOpen('plant')}
                  onClose={handleConditionClose('plant')}
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
                  onOpen={handleConditionOpen('building')}
                  onClose={handleConditionClose('building')}
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
                  onOpen={handleConditionOpen('planGroup')}
                  onClose={handleConditionClose('planGroup')}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
