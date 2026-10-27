// SCP0122 PlanActivityMgmt — TobeGen 생성 골격 (As-is SCP0122_PlanActivityMgmt, Fact Pack Doc/asisfacts/screens/SCP0122)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { PlanActivityMgmtForm } from './components/PlanActivityMgmtForm';
import { PlanActivityMgmtGrid } from './components/PlanActivityMgmtGrid';
import type { RESPONSE_SET } from './plan-activity-mgmt.constants';
import { MENU_ID, SHEETS } from './plan-activity-mgmt.constants';
import { usePlanActivityMgmtStore } from './usePlanActivityMgmtStore';

export const PlanActivityMgmt = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.PLAN_ACTIVITY_MGMT, RESPONSE_SET.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = usePlanActivityMgmtStore(state => state.filters);
  const setFilters = usePlanActivityMgmtStore(state => state.setFilters);
  const staticColumns = usePlanActivityMgmtStore(state => state.staticColumns);
  const fetchStaticColumns = usePlanActivityMgmtStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = usePlanActivityMgmtStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = usePlanActivityMgmtStore(state => state.setOpenSearchArea);

  const { saveWithValidation } = useSaveWithValidation();

  // spdMain ← 시트 'Plan Activity Mgmt'. As-is 조회 SP: SCP0122_GET_PLAN_ACTIVITY_MGMT
  const { data: data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_ACTIVITY_MGMT,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // As-is 저장: SCP0122_SAVE_PLAN_ACTIVITY_MGMT
  const { mutate } = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_ACTIVITY_MGMT,
    tabId,
  });

  // As-is this.Load (Form_Load) → 메타 컬럼 + 저장된 조회조건
  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  const onSave = () => {
    const saveData = data?.o_rc?.filter?.(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumns, mutate);
  };

  // AS-IS InsertButton SCP0122_PlanActivityMgmt.cs:258 4줄 → 행 추가
  const handleInsertRow = () => {
    // TODO(이식): As-is InsertButton/InsertRow 본문 — 기본값·잠금 컬럼(LockColumn)·cellType 은 그리드 컬럼 메타(_inputEditType/_ctrlType)로
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, { /* TODO(이식): As-is InsertRow 기본값 (예: DIVISION_ID: divisionId, VALID_YN: 'Y') */ }, 'above');
  };
  // AS-IS DeleteButton SCP0122_PlanActivityMgmt.cs:263 7줄 → 선택 행 삭제
  const handleDeleteRow = () => {
    // TODO(이식): As-is DeleteButton 본문 (삭제 가능 조건·확인 메시지 MSG 코드)
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current);
  };
  // AS-IS EditButton SCP0122_PlanActivityMgmt.cs:271 11줄 — hotkeyConfig 미지원: customButtons 의 편집 토글(IsReadOnly) 로 — TODO(이식)

  // 공통 버튼 — As-is BaseForm override 근거(members.csv). 룰 25 §1.5.1/§1.5.3: 정의 없는 키는 false 명시(silent omit 금지), UsrConditionPanel 없으면 condition/resetCondition false
  const hotkeyConfig: HotkeyConfig = {
    search: setFilters, // AS-IS FindButton (SCP0122_PlanActivityMgmt.cs:253 4줄)
    save: onSave, // AS-IS SaveButton SCP0122_PlanActivityMgmt.cs:283 6줄
    insert: handleInsertRow, // AS-IS InsertButton SCP0122_PlanActivityMgmt.cs:258 4줄
    delete: handleDeleteRow, // AS-IS DeleteButton SCP0122_PlanActivityMgmt.cs:263 7줄
    excel: false, // AS-IS ExcelButton 미정의
    upload: false, // AS-IS Upload/ImportButton 미정의
    manual: false,
    // condition/resetCondition: (생략 = 기본 활성) AS-IS UsrConditionPanel 있음
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <PlanActivityMgmtForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc?.length ?? 0}
        excelFileName='PlanActivityMgmt'
        hotkeyConfig={hotkeyConfig}
        searchParam={filters as Record<string, string> | undefined}
      />
      <PlanActivityMgmtGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc ?? []} staticColumns={staticColumns} />
    </>
  );
};
