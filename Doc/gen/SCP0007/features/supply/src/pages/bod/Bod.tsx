// SCP0007 BOD — TobeGen 생성 골격 (As-is SCP0007_BOD, Fact Pack Doc/asisfacts/screens/SCP0007)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import type { RESPONSE_SET } from './bod.constants';
import { MENU_ID, SHEETS } from './bod.constants';
import { BodForm } from './components/BodForm';
import { BodGrid } from './components/BodGrid';
import { DistributionRouteModal } from './components/modals/DistributionRouteModal';
import { useBodStore } from './useBodStore';

export const Bod = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.BOD, RESPONSE_SET.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = useBodStore(state => state.filters);
  const setFilters = useBodStore(state => state.setFilters);
  const staticColumns = useBodStore(state => state.staticColumns);
  const fetchStaticColumns = useBodStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useBodStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useBodStore(state => state.setOpenSearchArea);
  const openDistributionRouteModal = useBodStore(state => state.openDistributionRouteModal);
  const setOpenDistributionRouteModal = useBodStore(state => state.setOpenDistributionRouteModal);
  const activeSheet = useBodStore(state => state.activeSheet);
  const { saveWithValidation } = useSaveWithValidation();

  // spdMain ← 시트 'BOD' / 'Distribution Route' (activeSheet 전환). As-is 조회 SP: SCP0007_GET_BOD, SCP0007_GET_COUNTRY_CITY, SCP0005_GET_DISTRIBUTION_ROUTE
  const { data: data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: activeSheet,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // As-is 저장: SCP0007_SAVE_BOD
  const { mutate } = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: activeSheet,
    tabId,
  });

  // As-is this.Load (Form_Load) → 메타 컬럼 + 저장된 조회조건
  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  const onSave = () => {
    const saveData = data?.o_rc?.filter?.(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumns[activeSheet] ?? [], mutate);
  };

  // AS-IS dsdm.Changed → SpdMain_Changed (SCP0007_BOD.cs:186)
  //   호출 엔드포인트: SCP.SCP0007_GET_ROUTE_CNT
  //   To-Be 패턴: onChange
  const handleSpdMain = () => {
    // TODO(이식): As-is SpdMain_Changed 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS dsdm.Changed → SpdMain_Changed (SCP0007_BOD.cs:1104)
  //   호출 엔드포인트: SCP.SCP0007_GET_ROUTE_CNT
  //   To-Be 패턴: onChange
  const handleSpdMain = () => {
    // TODO(이식): As-is SpdMain_Changed 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS dsdm.Changed → SpdMain_Changed (SCP0007_BOD.cs:1315)
  //   호출 엔드포인트: SCP.SCP0007_GET_ROUTE_CNT
  //   To-Be 패턴: onChange
  const handleSpdMain = () => {
    // TODO(이식): As-is SpdMain_Changed 로직 — Fact Pack flow.csv / Agent analysis.md 참조
  };

  // AS-IS 빈 override(기능 비활성으로 해석 → false): InsertButton(SCP0007_DistributionRoutePopup.cs:387 3줄 빈 본문), DeleteButton(SCP0007_DistributionRoutePopup.cs:391 3줄 빈 본문), SaveButton(SCP0007_DistributionRoutePopup.cs:399 3줄 빈 본문), EditButton(SCP0007_DistributionRoutePopup.cs:395 3줄 빈 본문)
  // 공통 버튼 — As-is BaseForm override 근거(members.csv). 룰 25 §1.5.1/§1.5.3: 정의 없는 키는 false 명시(silent omit 금지), UsrConditionPanel 없으면 condition/resetCondition false
  const hotkeyConfig: HotkeyConfig = {
    search: setFilters, // AS-IS FindButton (SCP0007_DistributionRoutePopup.cs:382 4줄)
    save: onSave, // AS-IS SaveButton 미정의 / 저장 SP 있음
    insert: false, // AS-IS InsertButton 미정의
    delete: false, // AS-IS DeleteButton 미정의
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
      <BodForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc?.length ?? 0}
        excelFileName='BOD'
        hotkeyConfig={hotkeyConfig}
        searchParam={filters as Record<string, string> | undefined}
      />
      <BodGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc ?? []} staticColumns={staticColumns[activeSheet] ?? []} />
      {/* AS-IS 팝업 SCP0007_DistributionRoutePopup — 열기: 해당 이벤트 핸들러에서 setOpenDistributionRouteModal(true) (TODO(이식): 트리거·파라미터·반환 처리) */}
      <DistributionRouteModal open={openDistributionRouteModal} modalClose={() => setOpenDistributionRouteModal(false)} />
    </>
  );
};
