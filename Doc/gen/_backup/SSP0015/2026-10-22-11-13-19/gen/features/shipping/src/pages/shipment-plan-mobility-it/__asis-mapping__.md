# __asis-mapping__.md — SSP0015 design 번호 1:1 대조표 (TobeGen 초기본 — Fact Pack 기준)

> 원천: Doc/asisfacts/screens/SSP0015 (controls/events/endpoints/grid_effective) · 생성: tools/Harness/gen.js
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수). 빈 칸 1개 = 게이트 실패.

## §1 컨트롤

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 usrButton1 / UsrButton | ShipmentPlanMobilityIt.tsx (SubTitle customButtons) | 버튼 배선·로직 이식 필요 | 미구현 |
| D00-1-002 | §1 usrLayoutControl2 / UsrLayoutControl |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-003 | §1 cboPlanDate / UsrCombo | components/ShipmentPlanMobilityItForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-004 | §1 chkSum / UsrCheckBox | components/ShipmentPlanMobilityItForm.tsx (Checkbox) |  | 구현 |
| D00-1-005 | §1 btnMeasure / UsrButton | ShipmentPlanMobilityIt.tsx (SubTitle MEASURE_SELECT) | 버튼 배선·로직 이식 필요 | 미구현 |
| D00-1-006 | §1 btnItemId / UsrButton | components/ShipmentPlanMobilityItForm.tsx (ItemField 내장 팝업) |  | 구현 |
| D00-1-007 | §1 clbPlantSite / UsrCheckedList | components/ShipmentPlanMobilityItForm.tsx (PlantSiteField 카탈로그) |  | 구현 |
| D00-1-008 | §1 drpPeriod / UsrDateRangePicker | components/ShipmentPlanMobilityItForm.tsx (PeriodField 카탈로그) |  | 구현 |
| D00-1-009 | §1 txtItemId / UsrMultiLineEditor | components/ShipmentPlanMobilityItForm.tsx (ItemField 카탈로그 + 팝업 내장) |  | 구현 |
| D00-1-010 | §1 cboBucketType / UsrCombo | components/ShipmentPlanMobilityItForm.tsx (BucketField 카탈로그) |  | 구현 |
| D00-1-011 | §1 clbDivision / UsrCombo | components/ShipmentPlanMobilityItForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-012 | §1 chkMyModel / UsrCheckBox | components/ShipmentPlanMobilityItForm.tsx (Checkbox) |  | 구현 |
| D00-1-013 | §1 chkPartLeader / UsrCheckBox | components/ShipmentPlanMobilityItForm.tsx (Checkbox) |  | 구현 |
| D00-1-014 | §1 chkTeamLeader / UsrCheckBox | components/ShipmentPlanMobilityItForm.tsx (Checkbox) |  | 구현 |
| D00-1-015 | §1 chkDelegateeModel / UsrCheckBox | components/ShipmentPlanMobilityItForm.tsx (Checkbox) |  | 구현 |
| D00-1-016 | §1 layoutControlGroup2 / LayoutControlGroup |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem3 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-018 | §1 layoutControlItem7 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-019 | §1 PlanDate / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-020 | §1 layoutControlItem6 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-021 | §1 layoutControlItem10 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-022 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-023 | §1 lblBucket / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-024 | §1 layoutControlItem8 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-025 | §1 lblCombo1 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-026 | §1 layoutControlItem1 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-027 | §1 layoutControlItem2 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-028 | §1 lblItemId / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-029 | §1 layoutControlItem12 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-030 | §1 layoutControlItem13 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-031 | §1 layoutControlItem16 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-032 | §1 spdMain / FpSpread | components/ShipmentPlanMobilityItGridMain.tsx (DataGrid ← WH In Plan Detail) |  | 구현 |
| D00-1-033 | §1 spdMain_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-034 | §1 splitContainer1 / SplitContainer |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-035 | §1 spdDetail / FpSpread | components/ShipmentPlanMobilityItGridDetail.tsx (DataGrid ← Hold stock Detail/Hold stock/MES Stock Detail/SCS Stock Detail/Shipment Confirm Detail/Shipment PSI(IT & Mobile)/Shipment PSI(Mobility & IT)/Shipment PSI(Packer)/Shipment Request Detail/Shipment Result/Stock Detail/Stock Location Detail/W/H stock/W/H stock Detail) |  | 구현 |
| D00-1-036 | §1 spdDetail_Sheet1 / SheetView |  | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-037 | §1 usrLayoutControl3 / UsrLayoutControl |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-038 | §1 clbResultType / UsrCheckedList | components/ShipmentPlanMobilityItForm.tsx (CustomDropdown) |  | 구현 |
| D00-1-039 | §1 btnRequestor / UsrButton | ShipmentPlanMobilityIt.tsx (SubTitle customButtons) | 버튼 배선·로직 이식 필요 | 미구현 |
| D00-1-040 | §1 txtRequestor / UsrTextBox | components/ShipmentPlanMobilityItForm.tsx (InputField) |  | 구현 |
| D00-1-041 | §1 btnSearch / SimpleButton |  | SearchArea 내장 조회 버튼 — 별도 생성 안 함 | 해당없음 |
| D00-1-042 | §1 txtModel2 / UsrMultiLineEditor | components/ShipmentPlanMobilityItForm.tsx (InputField) |  | 구현 |
| D00-1-043 | §1 btnItemID2 / UsrButton | ShipmentPlanMobilityIt.tsx (SubTitle customButtons) | 버튼 배선·로직 이식 필요 | 미구현 |
| D00-1-044 | §1 drpPeriod2 / UsrDateRangePicker | components/ShipmentPlanMobilityItForm.tsx (PeriodField 카탈로그) |  | 구현 |
| D00-1-045 | §1 drpPeriod3 / UsrDateRangePicker | components/ShipmentPlanMobilityItForm.tsx (PeriodField 카탈로그) |  | 구현 |
| D00-1-046 | §1 txtLotID / UsrMultiLineEditor | components/ShipmentPlanMobilityItForm.tsx (InputField) |  | 구현 |
| D00-1-047 | §1 layoutControlGroup3 / LayoutControlGroup |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-048 | §1 layoutControlItem11 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-049 | §1 Requestor / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-050 | §1 layoutControlItem9 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-051 | §1 layoutControlItem4 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-052 | §1 layoutControlItem5 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-053 | §1 layoutControlItem14 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-054 | §1 layoutControlItem15 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-055 | §1 layoutControlItem3 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-056 | §1 layoutControlItem17 / LayoutControlItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-057 | §1 emptySpaceItem2 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-058 | §1 imageList1 / ImageList |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-059 | §1 emptySpaceItem5 / EmptySpaceItem |  | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |

## §2 이벤트

| ID | 요지 (원천 1줄) | 구현 위치 (파일:라인) | 사유 | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 spdMain / TextTipFetch | components/ShipmentPlanMobilityItGridMain.tsx (handleMainTextTipFetch 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-002 | §2 this / Load | ShipmentPlanMobilityIt.tsx (useEffect) (handleForm 스텁) |  | 구현 |
| D00-2-003 | §2 spdMain / CellDoubleClick | components/ShipmentPlanMobilityItGridMain.tsx (handleSpdMain 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-004 | §2 spdMain / TopChange | components/ShipmentPlanMobilityItGridMain.tsx (handleSpdMainTopChange 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-005 | §2 spdDetail / TopChange | components/ShipmentPlanMobilityItGridDetail.tsx (handleSpdDetailTopChange 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-006 | §2 btnMeasure / Click | ShipmentPlanMobilityIt.tsx (handleMeasure 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-007 | §2 cboBucketType / SelectedIndexChanged | ShipmentPlanMobilityIt.tsx (handleBucketType 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-008 | §2 chkSum / CheckedChanged | ShipmentPlanMobilityIt.tsx (handleSum 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-009 | §2 btnItemId / Click | ShipmentPlanMobilityIt.tsx (handleItemId 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-010 | §2 btnItemID2 / Click | ShipmentPlanMobilityIt.tsx (handleItemID2 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-011 | §2 btnSearch / Click | ShipmentPlanMobilityIt.tsx (handleSearch 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-012 | §2 btnRequestor / Click | ShipmentPlanMobilityIt.tsx (handleRequestor 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-013 | §2 spdDetail / CellClick | components/ShipmentPlanMobilityItGridDetail.tsx (handleSpdDetailCell 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-014 | §2 spdDetail / ComboSelChange | components/ShipmentPlanMobilityItGridDetail.tsx (handleDetailComboSelChange 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-015 | §2 spdDetail / SheetTabClick | components/ShipmentPlanMobilityItGridDetail.tsx (handleSpdDetailSheetTab 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-016 | §2 spdDetail / CellDoubleClick | components/ShipmentPlanMobilityItGridDetail.tsx (handleSpdDetail 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-017 | §2 spdMain / ActiveSheetChanged | components/ShipmentPlanMobilityItGridMain.tsx (handleSpdMainActiveSheet 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-018 | §2 clbDivision / SelectedIndexChanged | ShipmentPlanMobilityIt.tsx (handleDivision 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-019 | §2 cboPlanDate / SelectedIndexChanged | ShipmentPlanMobilityIt.tsx (handleCboPlanDate 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-020 | §2 spdDetail / ActiveSheetChanged | components/ShipmentPlanMobilityItGridDetail.tsx (handleSpdDetailActiveSheet 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-021 | §2 spdDetail / EditChange | components/ShipmentPlanMobilityItGridDetail.tsx (handleSpdDetailEditChange 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-022 | §2 spdDetail / ClipboardPasted | components/ShipmentPlanMobilityItGridDetail.tsx (handleSpdDetailClipboardPasted 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-023 | §2 spdMain / EditModeOn | components/ShipmentPlanMobilityItGridMain.tsx (handleSpdMainEditModeOn 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-024 | §2 spdMain / CellClick | components/ShipmentPlanMobilityItGridMain.tsx (handleSpdMainCell 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |
| D00-2-025 | §2 dsdm / Changed | ShipmentPlanMobilityIt.tsx (handleshtDetailChange 스텁) | 스텁만 생성 — 로직 이식 후 구현으로 | 미구현 |

## §4 엔드포인트 (As-is SP → To-Be call-proc 3-키)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-4-001 | §4 biz:CommonData.CommonDataList /  | register.json → SSP0015/Hold stock/ACTION | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-002 | §4 DM.DM0003_GET_BUCKET_TYPE_CODE / DM0003_GET_BUCKET_TYPE_CODE |  | 공통코드 콤보 → 등록 콤보ID(useTabComboQueries) | 해당없음 |
| D00-4-003 | §4 SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST / SSP0015_GET_SHIPMENT_PSI_PACKER_PAST | register.json → SSP0015/Shipment Confirm Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-004 | §4 SSP.SSP0015_GET_SHIPMENT_PSI_PACKER / SSP0015_GET_SHIPMENT_PSI_PACKER | register.json → SSP0015/Shipment Confirm Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-005 | §4 SSP.SSP0015_GET_SHIPMENT_PSI / SSP0015_GET_SHIPMENT_PSI | register.json → SSP0015/Shipment Confirm Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-006 | §4 SSP.SSP0002_GET_NERP_CODE / SSP0002_GET_NERP_CODE | register.json → SSP0015/Hold stock/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-007 | §4 SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL / SSP0015_GET_SHIPMENT_CONFIRM_DETAIL | register.json → SSP0015/Shipment Confirm Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-008 | §4 SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER / SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | register.json → SSP0015/Shipment Confirm Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-009 | §4 SSP.SSP0015_GET_WH_STOCK / SSP0015_GET_WH_STOCK | register.json → SSP0015/Stock Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-010 | §4 SSP.SSP0015_GET_MES_STOCK / SSP0015_GET_MES_STOCK | register.json → SSP0015/Stock Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-011 | §4 SSP.SSP0015_GET_BLOCK_STOCK / SSP0015_GET_BLOCK_STOCK | register.json → SSP0015/Stock Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-012 | §4 SSP.SSP0015_GET_STOCK_LOCATION_DETAIL / SSP0015_GET_STOCK_LOCATION_DETAIL | register.json → SSP0015/Hold stock/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-013 | §4 SSP.SSP0015_GET_SCS_STOCK / SSP0015_GET_SCS_STOCK | register.json → SSP0015/SCS Stock Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-014 | §4 SSP.SSP0026_GET_REQUEST_DETAIL_PACK / SSP0026_GET_REQUEST_DETAIL_PACK | register.json → SSP0015/Shipment Request Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-015 | §4 SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS / SSP0015_GET_SHIPMENT_PSI_COMMENTS | register.json → SSP0015/Shipment Confirm Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-016 | §4 SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER / SSP0015_GET_SHIPMENT_RESULT_PACKER | register.json → SSP0015/Shipment Confirm Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-017 | §4 SSP.SSP0015_GET_SHIPMENT_RESULT / SSP0015_GET_SHIPMENT_RESULT | register.json → SSP0015/Shipment Confirm Detail/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-018 | §4 SSP.SSP0015_SAVE_SHIPMENT_PSI / SSP0015_SAVE_SHIPMENT_PSI | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-019 | §4 SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER / SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-020 | §4 SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 / SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-021 | §4 SSP.SSP0015_SAVE_BLOCK_STOCK_DATA / SSP0015_SAVE_BLOCK_STOCK_DATA | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-022 | §4 SSP.SSP0015_SAVE_MES_STOCK / SSP0015_SAVE_MES_STOCK | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-023 | §4 SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM / SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | register.json → SSP0015/Hold stock/ACTION | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-024 | §4 SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM / SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-025 | §4 SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING / SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-026 | §4 SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER / SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-027 | §4 SSP.SSP0015_GET_ERP_SO_NO_CNT / SSP0015_GET_ERP_SO_NO_CNT | register.json → SSP0015/Hold stock/ERP_SO_NO_CNT | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-028 | §4 SSP.SSP0015_GET_SHIPMENT_STATUS / SSP0015_GET_SHIPMENT_STATUS | register.json → SSP0015/Shipment Confirm Detail/SHIPMENT_STATUS | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-029 | §4 SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING / SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-030 | §4 SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH / PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | register.json → SSP0015/Hold stock/ACTION | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-031 | §4 SCP.PR_SCM_SYS_LOG_BATCH / PR_SCM_SYS_LOG_BATCH |  | 화면 사용 로그 → BE 공통(Aspect/LogController) — 화면 코드 대응 없음 | 해당없음 |
| D00-4-032 | §4 SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK / SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | register.json → SSP0015/Hold stock/SSP_PLAN_PROCESSING_CHECK | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-033 | §4 SCM.SCM0001_GET_DIVISION / SCM0001_GET_DIVISION |  | 공통 콤보 SP → 등록 콤보ID(MyDivision/TeambyDivision/SiteByEndCustomer/PlantSitebyEndCustomer/BizTypeByDivision…) useTabComboQueries | 해당없음 |
| D00-4-034 | §4 SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN / SCP0009_GET_SHEET_CALENDAR_3SPAN | register.json → SSP0015/calendar/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-035 | §4 SCP.SCM0001_GET_SCP_DAY_PERIOD / SCM0001_GET_SCP_DAY_PERIOD | register.json → SSP0015/Hold stock/SEARCH | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-036 | §4 SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK / SSP0202_GET_SCS_CONFIRM_ID_CHECK | register.json → SSP0015/SCS Stock Detail/SCS_CONFIRM_ID_CHECK | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-037 | §4 SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME / SCM_SSP_CHECK_CONFIRM_CHANGETIME | register.json → SSP0015/Hold stock/ACTION | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-038 | §4 SSP.SSP0002_GET_USER_INFO_LIST / SSP0002_GET_USER_INFO_LIST | register.json → SSP0015/Hold stock/USER_INFO_LIST | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |
| D00-4-039 | §4 SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS / SSP0015_SAVE_SHIPMENT_PSI_COMMENTS | register.json → SSP0015/Hold stock/SAVE | SCM_ADM_PROC_M 등록 + Oracle PKG 배포 후 구현으로 | 미구현 |

## POPUP 매핑 (룰 25 §3 — button/SP/event/validation 4축)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-P-001 | §P SSP0015_ShipmentPSICommentsPopup / 팝업(이벤트 9, SP 1: SSP0015_SAVE_SHIPMENT_PSI_COMMENTS) | components/modals/ShipmentPSICommentsModal.tsx | 골격만 — 트리거·조회 파라미터·반환·검증 4축 이식 후 구현으로 (공통 lookup 으로 대체하면 사유에 명시하고 파일 삭제) | 미구현 |

## §5 Grid 시트

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-5-001 | §5 시트 'Hold stock' / META+코드연결 (14컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.HOLD_STOCK) |  | 구현 |
| D00-5-002 | §5 시트 'Hold stock Detail' / META+코드연결 (14컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.HOLD_STOCK_DETAIL) |  | 구현 |
| D00-5-003 | §5 시트 'MES Stock Detail' / 메타 정의만, 코드 미참조(미사용 가능) (24컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.MES_STOCK_DETAIL) |  | 구현 |
| D00-5-004 | §5 시트 'SCS Stock Detail' / META+코드연결 (11컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.SCS_STOCK_DETAIL) |  | 구현 |
| D00-5-005 | §5 시트 'Shipment Confirm Detail' / META+코드연결 (73컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.SHIPMENT_CONFIRM_DETAIL) |  | 구현 |
| D00-5-006 | §5 시트 'Shipment PSI(IT & Mobile)' / 메타 정의만, 코드 미참조(미사용 가능) (17컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.SHIPMENT_PSI_IT_MOBILE) |  | 구현 |
| D00-5-007 | §5 시트 'Shipment PSI(Mobility & IT)' / META+코드연결 (19컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.SHIPMENT_PSI_MOBILITY_IT) |  | 구현 |
| D00-5-008 | §5 시트 'Shipment PSI(Packer)' / META+코드연결 (19컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.SHIPMENT_PSI_PACKER) |  | 구현 |
| D00-5-009 | §5 시트 'Shipment Request Detail' / META+코드연결 (36컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.SHIPMENT_REQUEST_DETAIL) |  | 구현 |
| D00-5-010 | §5 시트 'Shipment Result' / META+코드연결 (19컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.SHIPMENT_RESULT) |  | 구현 |
| D00-5-011 | §5 시트 'Stock Detail' / META+코드연결 (28컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.STOCK_DETAIL) |  | 구현 |
| D00-5-012 | §5 시트 'Stock Location Detail' / META+코드연결 (22컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.STOCK_LOCATION_DETAIL) |  | 구현 |
| D00-5-013 | §5 시트 'W/H stock' / META+코드연결 (21컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.W_H_STOCK) |  | 구현 |
| D00-5-014 | §5 시트 'W/H stock Detail' / META+코드연결 (27컬럼) | components/ShipmentPlanMobilityItGridDetail.tsx (SHEETS.W_H_STOCK_DETAIL) |  | 구현 |
| D00-5-015 | §5 시트 'WH In Plan Detail' / META+코드연결 (15컬럼) | components/ShipmentPlanMobilityItGridMain.tsx (SHEETS.WH_IN_PLAN_DETAIL) |  | 구현 |

## §6 동적 컬럼 (As-is 타이틀 SP · DB루프 컬럼 생성)

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| D00-6-001 | §6 동적 헤더 원천 SCP0009_GET_SHEET_CALENDAR_3SPAN → 시트 'calendar' (사내 PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN) | ShipmentPlanMobilityIt.tsx (useTabProcQuery SHEETS.CALENDAR) | 타이틀 시트를 조회기간으로 조회해 o_rc1 로 헤더 생성 후 구현으로(B27) | 미구현 |
| D00-6-002 | §6 InitSpreadDateColumn / 1110 (DB루프 컬럼 생성 ← 타이틀 SP 결과셋) | components/ShipmentPlanMobilityItGrid.tsx (dynamicColumns) | o_rc1 행(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE) → 컬럼 생성 후 구현으로(M08) | 미구현 |
| D00-6-003 | §6 InitSpreadDateColumn / 1114 (DB루프 컬럼 생성 ← 타이틀 SP 결과셋) | components/ShipmentPlanMobilityItGrid.tsx (dynamicColumns) | o_rc1 행(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE) → 컬럼 생성 후 구현으로(M08) | 미구현 |
