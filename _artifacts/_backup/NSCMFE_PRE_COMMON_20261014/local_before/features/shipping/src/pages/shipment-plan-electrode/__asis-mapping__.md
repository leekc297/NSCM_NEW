# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md`, `04_impl-gap-audit.md`, `02_search-combo.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 PlanDate / LayoutControlItem | components/ShipmentPlanElectrodeForm.tsx:161-174 |  | 구현 |
| D00-1-002 | §1 Requestor / LayoutControlItem | — | Requestor 라벨 아이템 — UserInfoPopup(txtRequestor) 미이식으로 필드 미노출(04 excluded, 2026-09-27) | 제외 |
| D00-1-003 | §1 btnExcelUpload / UsrButton | — | Excel Upload UI 미이식 — AS-IS 엑셀 업로드 affordance(R15b)는 iter-1 범위 외(04 excluded 계열, upload SP 배선 후속). hotkeyConfig.upload=false, SHEETS.EXCEL 조회 배선만 | 제외 |
| D00-1-004 | §1 btnItemId / UsrButton | — | SCM0002_ItembyDivisionPopup 미이식 — Item 검색 팝업/버튼 미배치(04 excluded, §6) | 제외 |
| D00-1-005 | §1 btnItemId2 / UsrButton | — | SCM0002_ItembyDivisionPopup 미이식 — Item 검색 팝업/버튼 미배치(04 excluded, §6) | 제외 |
| D00-1-006 | §1 btnMeasure / UsrButton | ShipmentPlanElectrode.tsx:378-387 (customButtons Measure → handleMeasure) |  | 구현 |
| D00-1-007 | §1 btnRequestor / UsrButton | — | UserInfoPopup(btnRequestor) 공통 사용자검색 팝업 미이식(04 excluded, §6) | 제외 |
| D00-1-008 | §1 btnSearch / SimpleButton | ShipmentPlanElectrode.tsx:368-369 (hotkeyConfig.search=handleSearch), ShipmentPlanElectrodeForm.tsx:103-106 (SearchArea onSearch) |  | 구현 |
| D00-1-009 | §1 btnSimulation / UsrButton | ShipmentPlanElectrode.tsx:369-370 (hotkeyConfig.save=handleSave → SIMU 저장 main 경로 219-274) |  | 구현 |
| D00-1-010 | §1 cboBucketType / UsrCombo | components/ShipmentPlanElectrodeForm.tsx:193-206 (Bucket CustomDropdown, COMBO.BUCKET_TYPE) |  | 구현 |
| D00-1-011 | §1 cboPlanDate / UsrCombo | components/ShipmentPlanElectrodeForm.tsx:161-174 (Plan Date CustomDropdown, COMBO.PLAN_INFOR) |  | 구현 |
| D00-1-012 | §1 chkDelegateeModel / UsrCheckBox | — | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 04 §6 My Model auto-check(R09) 그룹 보류) | 제외 |
| D00-1-013 | §1 chkMyModel / UsrCheckBox | — | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 04 §6 R09 auto-check 보류) | 제외 |
| D00-1-014 | §1 chkPartLeader / UsrCheckBox | — | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 02 §1 검색 파라미터 그룹) | 제외 |
| D00-1-015 | §1 chkPastPeriod / UsrCheckBox | ShipmentPlanElectrode.tsx:433-439 (Past Period Checkbox → setChkPastPeriod) |  | 구현 |
| D00-1-016 | §1 chkSum / UsrCheckBox | ShipmentPlanElectrode.tsx:428-431 (Sum Checkbox → setChkSum) |  | 구현 |
| D00-1-017 | §1 chkTeamLeader / UsrCheckBox | — | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 02 §1 검색 파라미터 그룹) | 제외 |
| D00-1-018 | §1 clbCompany_ID / UsrCombo | components/ShipmentPlanElectrodeForm.tsx:127-141 (Company CustomDropdown, COMBO.COMPANY) |  | 구현 |
| D00-1-019 | §1 clbDivision_ID / UsrCombo | components/ShipmentPlanElectrodeForm.tsx:110-124 (Division CustomDropdown, COMBO.DIVISION) |  | 구현 |
| D00-1-020 | §1 clbFromSite / UsrCheckedList | components/ShipmentPlanElectrodeForm.tsx:144-158 (From Site CustomDropdown, COMBO.FROM_SITE) |  | 구현 |
| D00-1-021 | §1 clbResultType / UsrCheckedList | components/ShipmentPlanElectrodeDetailBar.tsx:53-69 (Result Type CustomDropdown, LOOKUP.RESULT_TYPE) |  | 구현 |
| D00-1-022 | §1 components / Container | — | Designer IContainer(WinForms 컴포넌트 컨테이너) — React 대응 없음 | 해당없음 |
| D00-1-023 | §1 drpPeriod / UsrDateRangePicker | components/ShipmentPlanElectrodeForm.tsx:177-190 (Period InputField 표시전용, PlanDate 파생) |  | 구현 |
| D00-1-024 | §1 drpPeriod2 / UsrDateRangePicker | components/ShipmentPlanElectrodeDetailBar.tsx:72-81 (Shipment Date 표시전용, 1차 period 파생) |  | 구현 |
| D00-1-025 | §1 drpPeriod3 / UsrDateRangePicker | components/ShipmentPlanElectrodeDetailBar.tsx:72-81 (Shipment Date 표시전용 — drpPeriod3 독립축 미구현, DetailBar 주석 G10) |  | 구현 |
| D00-1-026 | §1 emptySpaceItem1 / EmptySpaceItem | — | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-027 | §1 emptySpaceItem3 / EmptySpaceItem | — | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-028 | §1 emptySpaceItem4 / EmptySpaceItem | — | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-029 | §1 emptySpaceItem5 / EmptySpaceItem | — | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-030 | §1 formDown / UsrButton | — | Excel Download 폼 버튼 UI 미이식 — AS-IS 엑셀양식 다운로드(R15a·SP22 GET_..._EXCEL 은 배포됨)이나 iter-1 범위 외(04 excluded 계열, 다운로드 UI 후속) | 제외 |
| D00-1-031 | §1 imageList1 / ImageList | — | Designer ImageList(WinForms 아이콘 리소스) — React 대응 없음 | 해당없음 |
| D00-1-032 | §1 layoutControlGroup2 / LayoutControlGroup | — | Designer 레이아웃 그룹 컨테이너 — React 는 SearchArea/Grid 레이아웃으로 흡수 | 해당없음 |
| D00-1-033 | §1 layoutControlGroup3 / LayoutControlGroup | — | Designer 레이아웃 그룹 컨테이너 — React 는 DetailBar 레이아웃으로 흡수 | 해당없음 |
| D00-1-034 | §1 layoutControlItem1 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-035 | §1 layoutControlItem10 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-036 | §1 layoutControlItem12 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-037 | §1 layoutControlItem15 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-038 | §1 layoutControlItem16 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-039 | §1 layoutControlItem18 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-040 | §1 layoutControlItem19 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-041 | §1 layoutControlItem2 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-042 | §1 layoutControlItem21 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-043 | §1 layoutControlItem22 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-044 | §1 layoutControlItem23 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-045 | §1 layoutControlItem3 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-046 | §1 layoutControlItem4 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-047 | §1 layoutControlItem5 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-048 | §1 layoutControlItem6 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-049 | §1 layoutControlItem7 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-050 | §1 layoutControlItem8 / LayoutControlItem | — | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-051 | §1 layoutLotId / LayoutControlItem | — | Lot ID 상세 텍스트필터 라벨 — 초기 Never(숨김)·spdDetail 활성시트 조건부 상세필터(02 §275), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-052 | §1 layoutMaterialBtn / LayoutControlItem | — | Item(Material) 팝업 버튼 래퍼 — ItembyDivisionPopup 미이식(04 excluded, §6) | 제외 |
| D00-1-053 | §1 layoutMaterialDetail / LayoutControlItem | — | Material 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-054 | §1 layoutModelDetail / LayoutControlItem | — | Model 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-055 | §1 layoutNickNameDetail / LayoutControlItem | — | Nick Name 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-056 | §1 layoutRequestorBtn / LayoutControlItem | — | Requestor 팝업 버튼 래퍼 — UserInfoPopup 미이식(04 excluded, §6) | 제외 |
| D00-1-057 | §1 layoutResultType / LayoutControlItem | components/ShipmentPlanElectrodeDetailBar.tsx:53-69 (Result Type FormItem label) |  | 구현 |
| D00-1-058 | §1 layoutSearchBtn / LayoutControlItem | ShipmentPlanElectrodeForm.tsx:103-106 (SearchArea searchButton) |  | 구현 |
| D00-1-059 | §1 layoutShipmentDate1 / LayoutControlItem | components/ShipmentPlanElectrodeDetailBar.tsx:72-81 (Shipment Date FormItem label) |  | 구현 |
| D00-1-060 | §1 layoutShipmentDate2 / LayoutControlItem | components/ShipmentPlanElectrodeDetailBar.tsx:72-81 (Shipment Date FormItem label — drpPeriod3 축은 1차 period 로 통합) |  | 구현 |
| D00-1-061 | §1 lblBucket / LayoutControlItem | components/ShipmentPlanElectrodeForm.tsx:194-196 (Bucket FormItem label) |  | 구현 |
| D00-1-062 | §1 lblCombo1 / LayoutControlItem | — | Designer 정적 라벨(콤보 헤더) — 실 콤보 FormItem label 로 흡수, 별도 대응 없음 | 해당없음 |
| D00-1-063 | §1 lblItemId / LayoutControlItem | — | Item ID 라벨 — Item 텍스트 필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-064 | §1 lblUOMType / LayoutControlItem | ShipmentPlanElectrode.tsx:414-426 (BOH 3-radio 라벨 — UOM/Cell/Pancake m) |  | 구현 |
| D00-1-065 | §1 rdButton1 / UsrRadio | ShipmentPlanElectrode.tsx:416-425 (BOH_RADIO_ITEMS[0] Button → setBohRadio GENERAL) |  | 구현 |
| D00-1-066 | §1 rdButton2 / UsrRadio | ShipmentPlanElectrode.tsx:416-425 (BOH_RADIO_ITEMS[1] Button → setBohRadio CELL) |  | 구현 |
| D00-1-067 | §1 rdButton3 / UsrRadio | ShipmentPlanElectrode.tsx:416-425 (BOH_RADIO_ITEMS[2] Button → setBohRadio PCM) |  | 구현 |
| D00-1-068 | §1 spdDetail / FpSpread | components/ShipmentPlanElectrodeDetailGrid.tsx:228-250 (TabWrapper 3-sheet DataGrid) |  | 구현 |
| D00-1-069 | §1 spdDetail_Sheet1 / SheetView | components/ShipmentPlanElectrodeDetailGrid.tsx:234-248 (DETAIL_SHEETS TabItem 시트) |  | 구현 |
| D00-1-070 | §1 spdMain / FpSpread | components/ShipmentPlanElectrodeMainGrid.tsx:356-367 (Main pivot DataGrid) |  | 구현 |
| D00-1-071 | §1 spdMain_Sheet1 / SheetView | components/ShipmentPlanElectrodeMainGrid.tsx:356-367 (Main 단일 시트 = DataGrid) |  | 구현 |
| D00-1-072 | §1 spdSub / FpSpread | — | siSub 엑셀 다운로드 버퍼 그리드 — AS-IS 엑셀 폼(R15a/b) UI 미이식, iter-1 범위 외(SHEETS.EXCEL 조회 배선만) | 제외 |
| D00-1-073 | §1 spdSub_Sheet1 / SheetView | — | siSub 엑셀 버퍼 시트 — AS-IS 엑셀 폼 UI 미이식, iter-1 범위 외(SHEETS.EXCEL 조회 배선만) | 제외 |
| D00-1-074 | §1 splitContainer1 / SplitContainer | ShipmentPlanElectrode.tsx:411-482 (gridArea Main/Detail 수직 분할) |  | 구현 |
| D00-1-075 | §1 textNickName / UsrMultiLineEditor | — | Nick Name 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §72), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-076 | §1 txtItem2 / LayoutControlItem | — | Item 텍스트 필터 라벨 — Item 검색필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-077 | §1 txtItem3 / LayoutControlItem | — | Item 텍스트 필터 라벨 — Item 검색필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-078 | §1 txtItemId / UsrMultiLineEditor | — | Item ID 텍스트 검색필터 — Item 필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-079 | §1 txtItemId2 / UsrMultiLineEditor | — | Item ID 텍스트 검색필터 — Item 필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-080 | §1 txtLotID / UsrMultiLineEditor | — | Lot ID 상세 텍스트필터 에디터 — 초기 Never(숨김)·spdDetail 활성시트 조건부(02 §275), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-081 | §1 txtModel2 / UsrMultiLineEditor | — | Model 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-082 | §1 txtModelId / UsrMultiLineEditor | — | Model 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-083 | §1 txtNickName2 / UsrMultiLineEditor | — | Nick Name 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §72), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-084 | §1 txtRequestor / UsrTextBox | — | Requestor 텍스트박스 — UserInfoPopup 결과 채움용, 팝업 미이식으로 미노출(04 excluded, §6) | 제외 |
| D00-1-085 | §1 usrButton1 / UsrButton | — | Designer 미사용/dead 버튼 — 이벤트 인벤토리(§2)에 핸들러 없음, 대응 없음 | 해당없음 |
| D00-1-086 | §1 usrConditionPanel1 / UsrConditionPanel | ShipmentPlanElectrode.tsx:397 (ShipmentPlanElectrodeForm — 접이식 SearchArea) |  | 구현 |
| D00-1-087 | §1 usrLabel1 / UsrLabel | — | Designer 정적 라벨 — 실 라벨은 FormItem 으로 흡수, 별도 대응 없음 | 해당없음 |
| D00-1-088 | §1 usrLayoutControl2 / UsrLayoutControl | — | Designer 레이아웃 컨트롤 컨테이너 — SearchArea/Form 레이아웃으로 흡수 | 해당없음 |
| D00-1-089 | §1 usrLayoutControl3 / UsrLayoutControl | components/ShipmentPlanElectrodeDetailBar.tsx:49-97 (2차 조회조건 DetailBar 컨테이너) |  | 구현 |
| D00-2-001 | §2 btnExcelUpload / Click | — | Excel Upload Click 핸들러 — AS-IS 엑셀 업로드 UI(R15b) 미이식, iter-1 범위 외(D00-1-003 짝) | 제외 |
| D00-2-002 | §2 btnItemId / Click | — | ItembyDivisionPopup 미이식 — Item 팝업 열기 핸들러 없음(04 excluded, §6) | 제외 |
| D00-2-003 | §2 btnItemId2 / Click | — | ItembyDivisionPopup 미이식 — Item 팝업 열기 핸들러 없음(04 excluded, §6) | 제외 |
| D00-2-004 | §2 btnMeasure / Click | ShipmentPlanElectrode.tsx:362-365 (handleMeasure → setOpenMeasure, spdDetail 활성이면 no-op) |  | 구현 |
| D00-2-005 | §2 btnRequestor / Click | — | UserInfoPopup 미이식 — Requestor 팝업 열기 핸들러 없음(04 excluded, §6) | 제외 |
| D00-2-006 | §2 btnSearch / Click | ShipmentPlanElectrode.tsx:185-209 (handleSearch — 필수검증 + 미저장 confirm + runMainSearch) |  | 구현 |
| D00-2-007 | §2 btnSimulation / Click | ShipmentPlanElectrode.tsx:219-274 (handleSave main 경로 → SAVE_SHIPMENT_PLAN_SIMU call-proc) |  | 구현 |
| D00-2-008 | §2 cboBucketType / SelectedIndexChanged | components/ShipmentPlanElectrodeForm.tsx:199-204 (set bucketType → MainGrid 열 재구성, 재조회 없음) |  | 구현 |
| D00-2-009 | §2 cboPlanDate / SelectedIndexChanged | components/ShipmentPlanElectrodeForm.tsx:96-100 (handlePlanDateChange → setPlanDate period+realFlag) |  | 구현 |
| D00-2-010 | §2 chkPastPeriod / CheckedChanged | ShipmentPlanElectrode.tsx:434-437 (setChkPastPeriod → MainGrid isVisible 과거 D_/W_ 숨김) |  | 구현 |
| D00-2-011 | §2 chkSum / CheckedChanged | ShipmentPlanElectrode.tsx:429 (setChkSum → MainGrid isDynVisible SUM 열 토글) |  | 구현 |
| D00-2-012 | §2 clbCompany_ID / SelectedIndexChanged | components/ShipmentPlanElectrodeForm.tsx:137 (setCompany → FromSite/PlanDate 재조회 키), useShipmentPlanElectrodeStore.ts:141-152 |  | 구현 |
| D00-2-013 | §2 clbDivision_ID / SelectedIndexChanged | components/ShipmentPlanElectrodeForm.tsx:120 (setDivision → Company 화면단 필터), useShipmentPlanElectrodeStore.ts:125-139 |  | 구현 |
| D00-2-014 | §2 dsdm / Changed | — | AS-IS DataSet DataMember 바인딩 이벤트 — React SSOT(React Query) 로 대체, 대응 이벤트 없음 | 해당없음 |
| D00-2-015 | §2 formDown / Click | — | Excel Download Click 핸들러 — AS-IS 엑셀양식 다운로드 UI(R15a) 미이식, iter-1 범위 외(D00-1-030 짝) | 제외 |
| D00-2-016 | §2 rdButton1 / CheckedChanged | ShipmentPlanElectrode.tsx:421 (setBohRadio → span/BOH 전환), utils/shipment-plan-electrode.editLock.ts:41-42 activeSpanOf |  | 구현 |
| D00-2-017 | §2 rdButton2 / CheckedChanged | ShipmentPlanElectrode.tsx:421 (setBohRadio → span/BOH 전환), utils/shipment-plan-electrode.editLock.ts:41-42 activeSpanOf |  | 구현 |
| D00-2-018 | §2 spdDetail / ActiveSheetChanged | components/ShipmentPlanElectrodeDetailGrid.tsx:230-233 (TabWrapper setActiveTabIndex → setActiveDetailSheet), useShipmentPlanElectrodeStore.ts:189-193 |  | 구현 |
| D00-2-019 | §2 spdDetail / CellClick | components/ShipmentPlanElectrodeDetailGrid.tsx:245 (gotFocus → setActiveGrid('detail')) |  | 구현 |
| D00-2-020 | §2 spdDetail / CellDoubleClick | — | Detail 그리드 셀 더블클릭 드릴다운 — AS-IS 는 Main→Detail 방향(setDetailFilter dblFlag='Y', store 55-61); Detail 셀 자체 더블클릭 파생 없음 | 해당없음 |
| D00-2-021 | §2 spdDetail / ClipboardPasted | components/ShipmentPlanElectrodeDetailGrid.tsx:104-112 (pastingCell 게이트) + 189 (pastedCell → cellEditEndedHandler 파생) |  | 구현 |
| D00-2-022 | §2 spdDetail / ComboSelChange | components/ShipmentPlanElectrodeDetailGrid.tsx:133-187 (cellEditEnded — TRANSPORT_MODE 등 SO 그룹 전파/CHANGE_REASON 클리어) |  | 구현 |
| D00-2-023 | §2 spdDetail / EditChange | components/ShipmentPlanElectrodeDetailGrid.tsx:133-187 (cellEditEnded — CHANGE_REASON_DETAIL/CODE 파생) |  | 구현 |
| D00-2-024 | §2 spdDetail / SheetTabClick | components/ShipmentPlanElectrodeDetailGrid.tsx:230-233 (TabWrapper setActiveTabIndex — 탭 전환은 자동조회 없음, 주석 50) |  | 구현 |
| D00-2-025 | §2 spdMain / CellDoubleClick | components/ShipmentPlanElectrodeMainGrid.tsx:333-338 (hostElement click → setActiveGrid('main')); Main→Detail 드릴다운축은 store setDetailFilter overrides(56-61) |  | 구현 |
| D00-2-026 | §2 spdMain / Change | components/ShipmentPlanElectrodeMainGrid.tsx:326-330 (cellEditEnded/pastedCell → onCellEdited), 242-254 beginningEdit 편집 잠금 |  | 구현 |
| D00-2-027 | §2 spdMain / ClipboardPasted | components/ShipmentPlanElectrodeMainGrid.tsx:309-324 (pastingCell 게이트) + 330 (pastedCell → onEdited) |  | 구현 |
| D00-2-028 | §2 spdMain / TopChange | — | AS-IS FpSpread 스크롤 TopChange(가상 스크롤 상단행 동기) — Wijmo DataGrid 가상화 내장, 화면 재현 불요 | 해당없음 |
| D00-4b-001 | §4b Data_SCP.Common / SSPBlockCheckIF / dtERPBlockYnIF | — | CB01 SSPBlockCheckIF 는 조회 콤보 아닌 ERP 차단 플래그(저장 가드) — 확정 SAVE/ERP 체인(I2, 04 excluded SP03/04/12~14) 종속으로 iter-1 미배선 | 제외 |
| D00-4b-002 | §4b Data_SCP.Common / Plan_InforElectrode / Tmp_dtPlanDate | components/ShipmentPlanElectrodeForm.tsx:55 (COMBO.PLAN_INFOR useTabComboQueries) + 88-94 (index0 realFlag 파생) |  | 구현 |
| D00-4b-003 | §4b Data_SCP.Common / Com_FromSitePlantEE / dtFromSite | components/ShipmentPlanElectrodeForm.tsx:54 (COMBO.FROM_SITE useTabComboQueries, @divisionId @companyId) |  | 구현 |
| D00-4b-004 | §4b Data_SCP.Common / Plan_InforElectrode / dtPlanDate | components/ShipmentPlanElectrodeForm.tsx:55,67 (COMBO.PLAN_INFOR → planDateOptions) |  | 구현 |
| D00-4d-001 | §4d BtnMeasure_Click / fps != null | ShipmentPlanElectrode.tsx:362-365 (handleMeasure — activeGrid 판정 후 진행) |  | 구현 |
| D00-4d-002 | §4d BtnMeasure_Click / fps.Name == "spdDetail" | ShipmentPlanElectrode.tsx:363 (activeGrid === 'detail' 이면 조용히 return — spdDetail 활성 시 no-op) |  | 구현 |
| D00-4d-003 | §4d SpdDetail_ComboSelChange / e.Column == TRANSPORT_MODE | components/ShipmentPlanElectrodeDetailGrid.tsx:135,166-185 (SO_GROUP_PROPAGATE_COLUMNS 에 TRANSPORT_MODE 포함 → SO그룹 전파+EDIT_MAIN) |  | 구현 |
| D00-4d-004 | §4d SpdDetail_ComboSelChange / TRANSPORT_MODE 공란 | ShipmentPlanElectrode.tsx:290-299 (PLAN_DETAIL_REQUIRED_COLUMNS 저장부 공백검증) | AS-IS 셀콤보 revert-on-blank 는 I5(TRANSPORT_MODE 셀콤보 미배선·asis.py 차단 확인필요, 04 확인필요) — 저장부 공백검증으로 부분 재현, 콤보 실측 후속 | 제외 |
| D00-4d-005 | §4d SpdDetail_ClipboardPasted / siDetail.IsLock == false | components/ShipmentPlanElectrodeDetailGrid.tsx:104-112 (pastingCell → isDetailCellEditable 게이트) |  | 구현 |
| D00-4d-006 | §4d SpdDetail_ClipboardPasted / ActiveSheet == shtPlanDetail | components/ShipmentPlanElectrodeDetailGrid.tsx:74 (핸들러가 SHEETS.PLAN_DETAIL gridRef 에만 배선 — 타 시트 read-only) |  | 구현 |
| D00-4d-007 | §4d SpdDetail_ClipboardPasted / Cells[iRow,iCol].Text != "" | utils/shipment-plan-electrode.editLock.ts:100-113 (isDetailCellEditable — 화이트리스트/상태 판정으로 붙여넣기 대상 셀 한정) |  | 구현 |
| D00-4d-008 | §4d SpdDetail_ClipboardPasted / iCol == CHANGE_REASON_CODE | components/ShipmentPlanElectrodeDetailGrid.tsx:189 (pastedCell → cellEditEndedHandler, 155-164 CHANGE_REASON_CODE 파생) |  | 구현 |
| D00-4d-009 | §4d SpdDetail_ClipboardPasted / dr == null | components/ShipmentPlanElectrodeDetailGrid.tsx:109,137-138 (GridUtils.getRow row undefined 가드) |  | 구현 |
| D00-4d-010 | §4d SpdDetail_EditChange / siDetail.IsLock == false | components/ShipmentPlanElectrodeDetailGrid.tsx:83-101 (beginningEdit → isDetailCellEditable e.cancel 게이트) |  | 구현 |
| D00-4d-011 | §4d SpdDetail_EditChange / ActiveSheet == shtPlanDetail | components/ShipmentPlanElectrodeDetailGrid.tsx:72-74 (PlanDetail gridRef 전용 배선 — 타 시트 편집 이벤트 없음) |  | 구현 |
| D00-4d-012 | §4d SpdDetail_EditChange / e.Column == CHANGE_REASON_DETAIL | components/ShipmentPlanElectrodeDetailGrid.tsx:142-153 (CHANGE_REASON_DETAIL 분기) |  | 구현 |
| D00-4d-013 | §4d SpdDetail_EditChange / reasonCode == "-" or 공백 | components/ShipmentPlanElectrodeDetailGrid.tsx:144-152,157-163 (code 공백 or '-' 이면 DETAIL 클리어 + MSG01291) |  | 구현 |
| D00-4d-014 | §4d SpdDetail_CellClick / e.Column == CHANGE_REQ_NO | — | AS-IS CHANGE_REQ_NO 셀클릭 → 변경요청 이력 팝업 — 확정 SAVE/변경요청 SP 체인(I2, 04 excluded SP03/04/12~14) 종속 미이식 | 제외 |
| D00-4d-015 | §4d SpdDetail_CellClick / sRequestNo 공백 | — | AS-IS CHANGE_REQ_NO 공백이면 이력 팝업 skip — 변경요청 이력 팝업 자체가 SP 체인(I2, 04 excluded) 종속 미이식(D00-4d-014 짝) | 제외 |
| D00-4d-016 | §4d EditButton(Edit) / isOK == false | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-017 | §4d EditButton(Edit) / fps.Name == "spdMain" | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-018 | §4d EditButton(Edit) / bRealFlag == false | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-019 | §4d EditButton(Edit) / siMain.RowCount == 0 | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-020 | §4d EditButton(Edit) / fps.Name == "spdDetail" | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-021 | §4d EditButton(Edit) / ActiveSheet == shtStockDetail\ | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-022 | §4d EditButton(Edit) / bRealFlag == false | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-023 | §4d shtPlanDetail_Change / CanModelChange != true \ | utils/shipment-plan-electrode.editLock.ts:100-113 (isDetailCellEditable — 편집 허용 판정에 모델변경 가능성 반영, beginningEdit e.cancel 게이트) |  | 구현 |
| D00-4d-024 | §4d shtPlanDetail_Change / siDetail.RowCount == 0 | components/ShipmentPlanElectrodeDetailGrid.tsx:88,109,137-138 (GridUtils.getRow undefined → 조기 return, 빈 시트 no-op) |  | 구현 |
| D00-4d-025 | §4d shtPlanDetail_Change / siDetail.IsLock == false | components/ShipmentPlanElectrodeDetailGrid.tsx:89-90 (isDetailCellEditable editableRef 판정으로 잠금 상태 반영) |  | 구현 |
| D00-4d-026 | §4d shtPlanDetail_Change / sErpStatus == "C" | components/ShipmentPlanElectrodeDetailGrid.tsx:91-99 (ERP_STATUS=='C' → e.cancel + MSG.ERP_DO_BLOCK) |  | 구현 |
| D00-4d-027 | §4d shtPlanDetail_Change / e.Column == TRANSPORT_MODE | components/ShipmentPlanElectrodeDetailGrid.tsx:135,166-185 (propagateSet TRANSPORT_MODE → SO그룹 전파 + EDIT_MAIN='Y') |  | 구현 |
| D00-4d-028 | §4d shtPlanDetail_Change / TRANSPORT_MODE 공란 | ShipmentPlanElectrode.tsx:290-299 (저장부 공백검증) | AS-IS 공란 되돌림은 I5(TRANSPORT_MODE 셀콤보 미배선·asis.py 차단 확인필요, 04 확인필요) — 저장부 공백검증으로 부분 재현, 콤보 실측 후속(D00-4d-004 짝) | 제외 |
| D00-4d-029 | §4d shtPlanDetail_Change / e.Column == CHANGE_REASON_CODE | components/ShipmentPlanElectrodeDetailGrid.tsx:155-164 (CHANGE_REASON_CODE 분기) |  | 구현 |
| D00-4d-030 | §4d shtPlanDetail_Change / reasonCode == "-" or GetText 공백 | components/ShipmentPlanElectrodeDetailGrid.tsx:157-163 (code 공백 or '-' 이면 DETAIL 클리어, SO 공백이면 종료) |  | 구현 |
| D00-4d-031 | §4d shtPlanDetail_Change / sSoNo 공백 | components/ShipmentPlanElectrodeDetailGrid.tsx:159-162,173 (soNo==='' → 전파 skip / 비공백 시 SO그룹 전파) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:EP02:SEARCH | 툴바 SEARCH — 조회 실행(수정 중이면 MSG00703 confirm) | ShipmentPlanElectrode.tsx:369 (hotkeyConfig.search → handleSearch 185-209, 195-206 MSG00703) |  | 구현 |
| CRUD:EP03:SAVE | 툴바 SAVE — siMain 시뮬레이션 저장 | ShipmentPlanElectrode.tsx:370 (hotkeyConfig.save → handleSave 219-333, 255-256 MAIN SIMU call-proc, 267 Toast) |  | 구현 |
| CRUD:EP13:EXCEL | 툴바 EXCEL 다운로드 | ShipmentPlanElectrode.tsx:398-408 (SubTitle excelFileName='ShipmentPlanElectrode' 공용 다운로드 배선) |  | 구현 |
| CRUD:EP04:DELETE | 툴바 DELETE | ShipmentPlanElectrode.tsx:373 (hotkeyConfig.delete — AS-IS 빈 몸체 재현, NO-OP 노출) | AS-IS BtnDelete_Click 빈 몸체 — 삭제 로직 없음(03 §3.5). 버튼 노출 유지 + 명시적 무동작 | 해당없음 |
| CRUD:EP05:INSERT | 툴바 INSERT — 상세(PlanDetail) 신규행 추가 | ShipmentPlanElectrode.tsx:371 (hotkeyConfig.insert → handleInsert 336-356, GridAction.addRow 355) |  | 구현 |
| MODAL:ColumnSettingModal | Measure 설정 모달(btnMeasure → 공용 ColumnSettingModal, TITLESET 'M') | ShipmentPlanElectrode.tsx:3 (import) + 486-496 (usage, columnType=TITLESET_MEASURE_TYPE, onSave 재조회) |  | 구현 |
| MODAL:UserInfoPopup | 담당자 조회 팝업(txtRequestor/btnRequestor) | — | UserInfoPopup 어포던스 미이식 결정(04 excluded, 2026-09-23) — Requestor 키인/팝업 iter-1 범위 외 | 제외 |
| MODAL:SCM0002_ItembyDivisionPopup | Item 조회 팝업(btnItemId/btnItemId2) | — | SCM0002_ItembyDivisionPopup 어포던스 미이식 결정(04 excluded, 2026-09-23) — Item 키인/팝업 iter-1 범위 외 | 제외 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | ShipmentPlanElectrode.tsx:355 (GridAction.addRow 배선) | 신규행 Insert 대상 상세(PlanDetail) 저장은 확정 SAVE SP(I2) 미배포(04 부분구현·high)라 end-to-end 검증 불가 — 필터-유지 삽입 요건은 SAVE 배선(convert-sp) 완료 후 검증(현재 addRow 배선까지 완비) | 제외 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | ShipmentPlanElectrode.tsx:194-207 (hasUnsaved → MSG.CONFIRM_RESEARCH_UNSAVED confirm, onConfirm runMainSearch) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | ShipmentPlanElectrode.tsx:492-495 (ColumnSettingModal onSave → main 활성+filters 있으면 refetchMain) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ShipmentPlanElectrode.tsx:267 (저장 성공 setToast type='success', MSG.SAVED) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | — | 공용 SubTitle/gridAction 엑셀 다운로드에 위임(ShipmentPlanElectrode.tsx:398-408) — dataMap→Name 변환은 공용 컴포넌트 책임, 화면 오버라이드 없음 | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | — | SSP0023 1차/2차 조회조건은 전부 콤보 드롭다운(Division/Company/FromSite/PlanDate/Bucket) — 콤마 다중 key-in 텍스트 조회조건 없음. Item/Requestor key-in 필드는 iter-1 미이식(제외) | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | — | 공용 DataGrid(gridFilterRef 배선 ShipmentPlanElectrode.tsx:401,470-474)에 필터 유지·재적용 위임 — 화면 별도 rebind 오버라이드 없음 | 해당없음 |

## 0. 화면 구조 매핑

| AS-IS | TO-BE | 비고 |
|---|---|---|
| usrConditionPanel1(접이식 검색) | ShipmentPlanElectrodeForm + SearchArea(openSearchArea) | 1차 조회조건 |
| layoutControlGroup3(상세 조건, 활성시트별) | ShipmentPlanElectrodeDetailBar(detailFieldSet) | 2차 조회조건 |
| spdMain(이중 pivot spread) | ShipmentPlanElectrodeMainGrid | measure×기간(3span×3bucket) |
| spdDetail 3시트(PlanDetail/Stock/Result) | ShipmentPlanElectrodeDetailGrid(TabWrapper) | 편집=PlanDetail만 |
| spdSub(엑셀 상세) | (SHEETS.EXCEL — 업로드 경로만, 03 §1.5) | 조회 배선, UI 별도 |
| 툴바(toolbarOverride 5) | SubTitle hotkeyConfig + customButtons(Measure) | §2 |

## 1. controls 매핑 (영역2 조회조건 — 02 §1 인벤토리 25 중 콤보/파라미터)

| AS-IS control | TO-BE | 처리 |
|---|---|---|
| clbDivision_ID(C19) | Form Division select(COMBO.DIVISION) | cascade 상위, FE 후필터 CODE!='EE' |
| clbCompany_ID(C18) | Form Company select(COMBO.COMPANY) | Division 값 화면단 좁힘 + index0 기본(G6) |
| clbFromSite(C20) | Form FromSite select(COMBO.FROM_SITE) | Company 의존 재조회 |
| cboPlanDate(C11) | Form PlanDate select(COMBO.PLAN_INFOR) | index0=realFlag, onChange→period 파생 |
| drpPeriod(C23) | Form Period InputField(표시전용) | PlanDate FROM~TO 파생 |
| cboBucketType(C10) | Form Bucket select(BUCKET_TYPE) | 표시모드(그리드 재구성, 재조회 없음) |
| clbResultType(C21) | DetailBar Result Type(LOOKUP.RESULT_TYPE) | 상세 전용, FE 후필터 R 제외 |
| chkSum(C16) | MainGrid 컨트롤바 Sum Checkbox | 표시모드 |
| chkPastPeriod(C15) | MainGrid 컨트롤바 Past Period Checkbox | 표시모드 |
| rdButton1~3(C65~67) | MainGrid BOH 3-radio(Button 배타) | span X_/Y_/Z_ 전환 |
| drpPeriod2/3(C24/C25) | DetailBar Shipment Date(표시전용, 1차 period) | 독립축 미구현(G10) |
| txtRequestor(C84) | (팝업 결과 채움 — 미구현) | 제외: UserInfoPopup 미이식(§아래 제외목록) |
| btnItemId/btnItemId2(C04/C05) | (Item 팝업 — 미구현) | 제외: SCM0002_ItembyDivisionPopup 미이식 |
| btnMeasure(C06) | customButtons Measure → ColumnSettingModal | measure 재구성 |
| chkMyModel/PartLeader/TeamLeader/DelegateeModel(C12~14/17) | (검색 파라미터 — 미노출) | 보류: 조회 SP 파라미터, UI 미배치(iter-1 범위 외) |
| txtModelId/textNickName/txtItemId 등 텍스트 | (검색 필터 텍스트 — 미노출) | 보류: iter-1 핵심(cascade+pivot+저장) 우선 |

## 2. events 매핑 (영역2 — 02 §3)

| AS-IS event | TO-BE | 처리 |
|---|---|---|
| clbDivision_ID_SelectedIndexChanged(E13) | setDivision → Company 화면단 필터 | 필터 방식(재조회 아님) |
| clbCompanyID_SelectedIndexChanged(E12) | setCompany → FromSite/PlanDate react-query 키 | 재조회 방식 |
| cboPlanDate_SelectedIndexChanged(E09) | handlePlanDateChange → period 세팅 + realFlag | cascade 종단 |
| cboBucketType_SelectedIndexChanged(E08) | set bucketType → MainGrid 열 재구성 | 표시모드 |
| chkSum/chkPastPeriod(E11/E10) | setChkSum/setChkPastPeriod → MainGrid | 표시모드 |
| rdButton_Changed(E16/E17) | setBohRadio → span 전환 | 표시모드 |

## 3. gridSignals 매핑 (영역3 284건 — 00 §3 category 집계)

284 전건은 category(family)로 소진. 규칙성 그룹은 코드로 재현, 반복 Visible/SetValue 는 admin 메타가 정본.

| category(건수) | TO-BE 재현 | 처리 |
|---|---|---|
| value(91) | MainGrid dynamicColumns 값 바인딩 + save diff | 편집분은 EditTracker |
| visible(88) | SCM_MST_SHEET_COLUMNS 메타(staticColumns) | admin 정본, 코드 덮어쓰기 금지 |
| color(36) | MainGrid formatItem(변경셀 Red/불일치 LightPink/과거 회색/주말) | 03 §3.3 |
| lock(22) | editLock(P_SHIP_PLAN_SIMU_ETD 행 [plan_start~confirm] 비-SUM) + isDetailCellEditable | 03 §3.1 |
| span(10) | 3단 머지헤더(MONTH/WEEK/DAY) SmartColMerge | 03 §2.3 |
| merge(7) | allowMerging=AllowMerging.Cells(detail SO 그룹) | DetailGrid |
| dataSource(5) | 셀콤보 5(SHIPMENT_STATUS/DOM_EXP/PACKAGE_TYPE/CHANGE_REASON + Division) | comboParams mnuId |
| cellType(1) | SetCellTypeCombo(TRANSPORT_MODE) | FACTORY_ID cascade 는 미완(G4) |
| other(24) | InitSpread/산발 — staticColumns fetch 로 일괄 | 개별 재현 불요 |

## 4. SP 매핑 (00 §4-1 24건 → API)

| AS-IS SP | TO-BE API_ID | 처리 |
|---|---|---|
| SSP0023_GET_SHIPMENT_PLAN(SP16) | P_SSP0023_GET | main 조회(배포) |
| SSP0023_GET_SHEET_CALENDAR_3SPAN(SP20) | P_SSP0023_GET_CALENDAR | 동적칼럼 원천(배포) |
| SSP0023_GET_SHIPMENT_PLAN_DETAIL(SP17) | P_SSP0023_GET_PLAN_DETAIL | PlanDetail 조회 |
| SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL(SP18) | P_SSP0023_GET_STOCK_DETAIL | StockDetail 조회 |
| SSP0023_GET_SHIPMENT_PLAN_RESULT(SP19) | P_SSP0023_GET_RESULT | ShipmentResult 조회 |
| SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(SP22) | P_SSP0023_GET_DETAIL_EXCEL | 엑셀 상세 |
| SSP0023_SAVE_SHIPMENT_PLAN_SIMU(SP21) | P_SSP0023_SAVE_SIMU | main 시뮬 저장(배포·런타임 배선) |
| SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(SP01/02) | P_SSP0023_SAVE_CONFIRM | 확정 저장(미배포 G1 — payload만) |
| DM0003_GET_BUCKET_TYPE_CODE(SP15) | CMBO BUCKET_TYPE_CODE | Bucket 콤보로 대체 |

## 5. toolbarOverride 매핑 (00 §4-3)

| AS-IS | TO-BE | 처리 |
|---|---|---|
| FindButton(Search) | hotkeyConfig.search=handleSearch | hasButton('SEARCH') 조건부 |
| SaveButton(Save) | hotkeyConfig.save=handleSave | main SIMU 저장 + detail 보류 |
| InsertButton(Insert) | hotkeyConfig.insert=handleInsert | PlanDetail 신규행 복제 |
| DeleteButton(Delete) | hotkeyConfig.delete=()=>undefined | NO-OP(노출·무동작, plan §6) |
| EditButton(Edit) | canEdit=hasButton('EDIT')(mount 1회) | SwitchLock 미이식(edit default) |
| btnMeasure | customButtons Measure → ColumnSettingModal | — |
| btnExcelUpload/formDown | UPLOAD/EXCEL 버튼(SHEETS.EXCEL 배선) | iter-1 배선만 |

## 6. 제외 / 해당없음 (사유 필수)

- **UserInfoPopup(btnRequestor)**: 공통 사용자검색 팝업 미이식. iter-1 범위(cascade+pivot+저장) 외 —
  Requestor 필터 미노출. 후속 iter 에서 공통 팝업 컴포넌트 연결.
- **SCM0002_ItembyDivisionPopup(btnItemId/2)**: Item 검색 팝업 미이식(동상). 텍스트 필터 미노출.
- **SP03/04/12/13/14/23(ERP 에러/확정취소/확정변경 배치/체크)**: 초안·확정 SAVE 체인 부속 SP.
  G1(SAVE 미배포)에 종속 — SAVE 배선 자체가 보류라 함께 보류. convert-sp 후속.
- **SP24 SSP0002_GET_USER_INFO_LIST(Edit 권한체크)**: AS-IS EditButton 은 사용자정보로 편집권 재확인.
  TO-BE 는 hasButton('EDIT')(admin 권한 테이블)로 대체 — SwitchLock/사용자 재조회 미이식(plan §6 결정).
- **SP05/06(출하상태/ERP SO건수 체크)**: 확정 저장 전 가드 — G1 종속 보류.
- **CB01 SSPBlockCheckIF**: 조회 콤보 아님(기능차단 플래그, 02 §2-7). 저장 가드용 — iter-1 미배선.
- **My Model auto-check(R09)**: 로그인자 모델 자동체크 판정 컬럼 미확정(02 §7-4). chkMyModel 미노출로 보류.

## 7. 카운트 대사

| 백본 | n | 소진 |
|---|---|---|
| controls | 89 | 영역2 25(§1) + 영역1/3 나머지는 staticColumns 메타·MainGrid/DetailGrid 로 흡수 |
| gridSignals | 284 | §3 category 9군 전건(value91+visible88+color36+lock22+span10+merge7+dataSource5+cellType1+other24=284) |
| SP | 24 | §4 배선 8 + 제외/보류 16(§6 — G1 종속·팝업·플래그) |
| events 영역2 | 8 | §2 전건 |
| toolbarOverride | 5 | §5 전건 |

미해소(보류/제외)는 전부 §6 에 사유 기재. 침묵 누락 0.
