# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 clbDivision_ID / UsrCombo | ShipmentPlanAutoEssForm.tsx (Division CustomDropdown — `divisionOptions`) |  | 구현 |
| D00-1-002 | §1 clbPlantSite / UsrCheckedList | ShipmentPlanAutoEssForm.tsx (From Site 다중 CustomDropdown — `fromSiteOptions`) |  | 구현 |
| D00-1-003 | §1 cboBucketType / UsrCombo | ShipmentPlanAutoEssForm.tsx (Bucket CustomDropdown — `bucketOptions`) |  | 구현 |
| D00-1-004 | §1 chkSum / UsrCheckBox | ShipmentPlanAutoEssForm.tsx (Sum Checkbox — extraConditions) |  | 구현 |
| D00-1-005 | §1 btnMeasure / UsrButton | ShipmentPlanAutoEss.tsx (`customButtons` Measure → `handleMeasure`) |  | 구현 |
| D00-1-006 | §1 cboPlanDate / UsrCombo | ShipmentPlanAutoEssForm.tsx (Plan Date CustomDropdown — `handlePlanDateChange`) |  | 구현 |
| D00-1-007 | §1 drpPeriod / UsrDateRangePicker | ShipmentPlanAutoEssForm.tsx (Period InputField 표시전용 — PlanDate 파생) |  | 구현 |
| D00-1-008 | §1 txtItemId / UsrMultiLineEditor | ShipmentPlanAutoEssForm.tsx (Model InputField — `sc.itemId`) |  | 구현 |
| D00-1-009 | §1 btnItemId / UsrButton | ShipmentPlanAutoEssForm.tsx (FunctionSearchIcon → `onItemSearch`) |  | 구현 |
| D00-1-010 | §1 clbCompany_ID / UsrCombo | ShipmentPlanAutoEssForm.tsx (Company CustomDropdown — `companyOptions`) |  | 구현 |
| D00-1-011 | §1 btnSimulation / UsrButton | ShipmentPlanAutoEss.tsx (`customButtons` Simulation → `handleSimulation`) |  | 구현 |
| D00-1-012 | §1 btnItemID2 / UsrButton | ShipmentPlanAutoEssDetailBar.tsx (Model FunctionSearchIcon → `onModelSearch`) |  | 구현 |
| D00-1-013 | §1 btnRequestor / UsrButton | ShipmentPlanAutoEssDetailBar.tsx (Requestor FunctionSearchIcon → `onRequestorSearch`) |  | 구현 |
| D00-1-014 | §1 txtRequestor / UsrTextBox | ShipmentPlanAutoEssDetailBar.tsx (Requestor InputField — `sc.requestorName`) |  | 구현 |
| D00-1-015 | §1 btnSearch / SimpleButton | ShipmentPlanAutoEssDetailBar.tsx (Detail Search Button → `onDetailSearch`) |  | 구현 |
| D00-1-016 | §1 clbResultType / UsrCheckedList | ShipmentPlanAutoEssDetailBar.tsx (Result Type 다중 CustomDropdown — `resultTypes`) |  | 구현 |
| D00-1-017 | §1 txtBoxID / UsrMultiLineEditor | ShipmentPlanAutoEssDetailBar.tsx (Box ID InputField — `sc.boxId`) |  | 구현 |
| D00-1-018 | §1 txtModel2 / UsrMultiLineEditor | ShipmentPlanAutoEssDetailBar.tsx (Model InputField — `sc.model`) |  | 구현 |
| D00-1-019 | §1 drpPeriod2 / UsrDateRangePicker | ShipmentPlanAutoEssDetailBar.tsx (PeriodField period2 → `setPeriod2`) |  | 구현 |
| D00-1-020 | §1 drpPeriod3 / UsrDateRangePicker | ShipmentPlanAutoEssDetailBar.tsx (PeriodField period3 — ShipmentResult 전용) |  | 구현 |
| D00-1-021 | §1 usrConditionPanel1 / UsrConditionPanel | ShipmentPlanAutoEssForm.tsx (SearchArea — 조회조건 패널) |  | 구현 |
| D00-1-022 | §1 usrButton1 / UsrButton | — | dead/orphan(용도 불명, design 02 §7-5) — AS-IS 미배선 컨트롤이라 이식 대상 아님 | 제외 |
| D00-1-023 | §1 spdMain / FpSpread | ShipmentPlanAutoEssMainGrid.tsx (DataGrid — PSI pivot) |  | 구현 |
| D00-1-024 | §1 spdMain_Sheet1 / SheetView | ShipmentPlanAutoEssMainGrid.tsx (DataGrid 단일 시트 — FpSpread SheetView 대응) |  | 구현 |
| D00-1-025 | §1 spdDetail / FpSpread | ShipmentPlanAutoEssDetailGrid.tsx (TabWrapper + 7 DataGrid) |  | 구현 |
| D00-1-026 | §1 spdDetail_Sheet1 / SheetView | ShipmentPlanAutoEssDetailGrid.tsx (`DETAIL_SHEETS` TabItem 시트 — FpSpread SheetView 대응) |  | 구현 |
| D00-1-027 | §1 splitContainer1 / SplitContainer | ShipmentPlanAutoEss.tsx (`styles.gridArea` Main/Detail 수직 분할) |  | 구현 |
| D00-1-028 | §1 usrLayoutControl2 / UsrLayoutControl | ShipmentPlanAutoEssForm.tsx (1차 조회조건 SearchArea) |  | 구현 |
| D00-1-029 | §1 usrLayoutControl3 / UsrLayoutControl | ShipmentPlanAutoEssDetailBar.tsx (2차 조회조건 바) |  | 구현 |
| D00-1-030 | §1 layoutControlGroup2 / LayoutControlGroup | ShipmentPlanAutoEssForm.tsx (SearchArea Grid 그룹) |  | 구현 |
| D00-1-031 | §1 layoutControlGroup3 / LayoutControlGroup | ShipmentPlanAutoEssDetailBar.tsx (detailBarFields Grid 그룹) |  | 구현 |
| D00-1-032 | §1 PlanDate / LayoutControlItem | — | DevExpress LayoutControlItem(라벨 배치 컨테이너) — MUI FormItem label 이 흡수, TO-BE 무등가 컨트롤 | 해당없음 |
| D00-1-033 | §1 Requestor / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-034 | §1 lblBucket / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-035 | §1 lblCombo1 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-036 | §1 lblItemId / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-037 | §1 layoutControlItem1 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-038 | §1 layoutControlItem2 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-039 | §1 layoutControlItem3 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-040 | §1 layoutControlItem4 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-041 | §1 layoutControlItem5 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-042 | §1 layoutControlItem6 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-043 | §1 layoutControlItem7 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-044 | §1 layoutControlItem8 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-045 | §1 layoutControlItem9 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-046 | §1 layoutControlItem10 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-047 | §1 layoutControlItem11 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-048 | §1 layoutControlItem12 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-049 | §1 layoutControlItem13 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-050 | §1 layoutControlItem14 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-051 | §1 layoutControlItem17 / LayoutControlItem | — | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-052 | §1 emptySpaceItem1 / EmptySpaceItem | — | DevExpress 여백 아이템 — TO-BE Grid 레이아웃 무등가(00 §1 근거) | 해당없음 |
| D00-1-053 | §1 emptySpaceItem2 / EmptySpaceItem | — | DevExpress 여백 아이템 — TO-BE 무등가 | 해당없음 |
| D00-1-054 | §1 emptySpaceItem3 / EmptySpaceItem | — | DevExpress 여백 아이템 — TO-BE 무등가 | 해당없음 |
| D00-1-055 | §1 emptySpaceItem5 / EmptySpaceItem | — | DevExpress 여백 아이템 — TO-BE 무등가 | 해당없음 |
| D00-1-056 | §1 components / Container | — | WinForms 디자이너 인프라 Container(static) — TO-BE 무등가 | 해당없음 |
| D00-1-057 | §1 imageList1 / ImageList | — | WinForms 아이콘 리소스 컨테이너(static) — TO-BE 는 SVG 아이콘 컴포넌트 직접 사용, 무등가 | 해당없음 |
| D00-2-001 | §2 btnItemID2 / Click | ShipmentPlanAutoEss.tsx (`setOpenItemDetailBar` → ItemByDivisionModal 2차) |  | 구현 |
| D00-2-002 | §2 btnItemId / Click | ShipmentPlanAutoEss.tsx (`setOpenItemMain` → ItemByDivisionModal 1차) |  | 구현 |
| D00-2-003 | §2 btnMeasure / Click | ShipmentPlanAutoEss.tsx (`handleMeasure` → ColumnSettingModal TITLESET 'M') |  | 구현 |
| D00-2-004 | §2 btnRequestor / Click | ShipmentPlanAutoEss.tsx (`setOpenRequestor` → RequestorModal) |  | 구현 |
| D00-2-005 | §2 btnSearch / Click | ShipmentPlanAutoEss.tsx (`handleDetailSearch` → `setDetailFilter`) |  | 구현 |
| D00-2-006 | §2 btnSimulation / Click | ShipmentPlanAutoEss.tsx (`handleSimulation` → `simulate`) |  | 구현 |
| D00-2-007 | §2 cboBucketType / SelectedIndexChanged | ShipmentPlanAutoEssMainGrid.tsx (`isDynVisible` — bucketType 변경 시 D_/W_/M_ 표시 전환, 재조회 없음) |  | 구현 |
| D00-2-008 | §2 cboPlanDate / SelectedIndexChanged | ShipmentPlanAutoEssForm.tsx (`handlePlanDateChange` → `setPlanDate`, index0=realFlag) |  | 구현 |
| D00-2-009 | §2 chkSum / CheckedChanged | ShipmentPlanAutoEssMainGrid.tsx (`isDynVisible` — chkSum SUM 컬럼 표시 토글) |  | 구현 |
| D00-2-010 | §2 clbCompany_ID / SelectedIndexChanged | useShipmentPlanAutoEssStore.ts (`setCompany` — cascade PlanDate/FromSite 초기화) |  | 구현 |
| D00-2-011 | §2 clbDivision_ID / SelectedIndexChanged | useShipmentPlanAutoEssStore.ts (`setDivision` — cascade + 그리드 초기화) |  | 구현 |
| D00-2-012 | §2 drpPeriod2 / ValueChanged | useShipmentPlanAutoEssStore.ts (`setPeriod2` → `clampPeriod2` 범위 clamp) |  | 구현 |
| D00-2-013 | §2 dsdm / Changed | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — Detail 편집 파생/SO 전파) |  | 구현 |
| D00-2-014 | §2 spdDetail / ActiveSheetChanged | ShipmentPlanAutoEssDetailGrid.tsx (`setActiveDetailSheet` — TabWrapper 시트 전환) |  | 구현 |
| D00-2-015 | §2 spdDetail / CellClick | — | AS-IS CellClick 은 CHANGE_REQ_NO 셀 팝업(SCM0002_ShipmentPlanRequestPopup) 진입 트리거인데 TO-BE 팝업 부재로 미배선(04_react-gap.md 확인필요) — 나머지 활성그리드 전환은 `gotFocus`(DetailGrid.tsx)가 흡수 | 제외 |
| D00-2-016 | §2 spdDetail / CellDoubleClick | ShipmentPlanAutoEssDetailGrid.tsx (`dblClickHandler` — ITEM_ID/PROJECT_CODE 신규행 셀 팝업) |  | 구현 |
| D00-2-017 | §2 spdDetail / ClipboardPasted | ShipmentPlanAutoEssDetailGrid.tsx (`pastingCellHandler` + `pastedCell`→`cellEditEndedHandler`) |  | 구현 |
| D00-2-018 | §2 spdDetail / ComboSelChange | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — 셀 콤보 확정 = cellEditEnded 통합. TRANSPORT_MODE 콤보는 dead 라 텍스트) |  | 구현 |
| D00-2-019 | §2 spdDetail / EditChange | ShipmentPlanAutoEssDetailGrid.tsx (`beginningEditHandler` 편집 게이트 + `cellEditEndedHandler` 파생) |  | 구현 |
| D00-2-020 | §2 spdDetail / SheetTabClick | ShipmentPlanAutoEssDetailGrid.tsx (TabWrapper `setActiveTabIndex` → `setActiveDetailSheet`) |  | 구현 |
| D00-2-021 | §2 spdDetail / TopChange | — | FpSpread 가상 스크롤 top 동기화 배관 — Wijmo FlexGrid 네이티브 스크롤이 등가 처리, 이식 대상 아님 | 제외 |
| D00-2-022 | §2 spdMain / CellDoubleClick | ShipmentPlanAutoEssMainGrid.tsx (`dblClickHandler` → `onDrilldown`/`handleMainDrilldown`) |  | 구현 |
| D00-2-023 | §2 spdMain / Change | ShipmentPlanAutoEssMainGrid.tsx (`beginningEditHandler`+`deleteKeyHandler` — D_ 셀 편집·EditTracker 마킹) |  | 구현 |
| D00-2-024 | §2 spdMain / ClipboardPasted | ShipmentPlanAutoEssMainGrid.tsx (`pastingCellHandler` — 편집가능 D_ 셀만 붙여넣기 허용) |  | 구현 |
| D00-2-025 | §2 spdMain / TopChange | — | FpSpread 가상 스크롤 top 동기화 배관 — Wijmo FlexGrid 네이티브 스크롤이 등가 처리, 이식 대상 아님 | 제외 |
| D00-4b-001 | §4b Data_SCP.Common / SSPBlockCheckIF / dtERPBlockYnIF | — | ERP IF 블록 여부 사전체크 — Drafting/ERP IF 하위 SP 체인이 TO-BE 미배포(goal.md ②, 저장은 Confirm 경로만)라 블록체크도 미배선. convert-sp 후속(04_react-gap.md) | 제외 |
| D00-4b-002 | §4b Data_SCP.Common / Plan_Infor / Tmp_dtPlanDate | — | AS-IS 임시 PlanDate 캐시(Tmp) 배관 — TO-BE 는 `Plan_Infor_SCP` 콤보 단일 조회로 대체(D00-4b-004 와 동일 원천), 별도 임시 테이블 무등가 | 해당없음 |
| D00-4b-003 | §4b Data_SCP.Common / Com_FromSite / dtFromSite | shipment-plan-auto-ess.constants.ts (`COMBO.FROM_SITE`='Com_FromSite_SCP') + ShipmentPlanAutoEssForm.tsx (`fromSites` useTabComboQueries) |  | 구현 |
| D00-4b-004 | §4b Data_SCP.Common / Plan_Infor / dtPlanDate | shipment-plan-auto-ess.constants.ts (`COMBO.PLAN_INFOR`='Plan_Infor_SCP') + ShipmentPlanAutoEssForm.tsx (`planDates` useTabComboQueries) |  | 구현 |
| D00-4b-005 | §4b Data_SCP.Common / Container_Size / dtContainer | shipment-plan-auto-ess.constants.ts (`COMBO.CONTAINER_SIZE`='Container_Size_SCP') + ShipmentPlanAutoEss.tsx (`handleSimulation` getCombo) |  | 구현 |
| D00-4d-001 | §4d shtDetail_Change / `CanModelChange != true \ | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — 편집 전파 진입 조건; 셀 유효행 판정은 beginningEdit 게이트가 선행) |  | 구현 |
| D00-4d-002 | §4d shtDetail_Change / `siDetail.ActiveSheet.RowCount == 0` | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — `if (!row) return` 빈행 가드) |  | 구현 |
| D00-4d-003 | §4d shtDetail_Change / `siDetail.IsLock == false` | ShipmentPlanAutoEssDetailGrid.tsx (`beginningEditHandler` → `isDetailCellEditable`; `canEdit` 판정) |  | 구현 |
| D00-4d-004 | §4d shtDetail_Change / `sErpStatus == "C"` | shipment-plan-auto-ess.editLock.ts (`isDetailCellEditable` — `ERP_STATUS !== 'C'` 조건) + ShipmentPlanAutoEssDetailGrid.tsx (`ERP_DO_BLOCK` MSG01401) |  | 구현 |
| D00-4d-005 | §4d shtDetail_Change / `e.Column == TRANSPORT_MODE` | shipment-plan-auto-ess.constants.ts (`PLAN_DETAIL_EDITABLE_COLUMNS` TRANSPORT_MODE) + ShipmentPlanAutoEss.tsx (`handleSave` TRANSPORT_MODE 필수 검증) |  | 구현 |
| D00-4d-006 | §4d shtDetail_Change / `IsNullOrWhiteSpace(TRANSPORT_MODE)` | ShipmentPlanAutoEss.tsx (`handleSave` — TRANSPORT_MODE 공백 시 REQUIRED_VALUE 차단) |  | 구현 |
| D00-4d-007 | §4d shtDetail_Change / `e.Column == CHANGE_REASON_CODE` | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — CHANGE_REASON_CODE 분기) |  | 구현 |
| D00-4d-008 | §4d shtDetail_Change / `sNewChangeReasonCode=="-" \ | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — code==''/'-' 시 DETAIL 클리어) |  | 구현 |
| D00-4d-009 | §4d shtDetail_Change / `IsNullOrWhiteSpace(sSoNo)` | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — `soNo === ''` 시 EDIT_MAIN 세팅 없이 종료) |  | 구현 |
| D00-4d-010 | §4d SpdDetail_EditChange / `siDetail.IsLock == false` | ShipmentPlanAutoEssDetailGrid.tsx (`beginningEditHandler` → `isDetailCellEditable`) |  | 구현 |
| D00-4d-011 | §4d SpdDetail_EditChange / `SheetName == shtPlanDetail` | shipment-plan-auto-ess.editLock.ts (`isDetailCellEditable` — `sheet !== SHEETS.PLAN_DETAIL` 전면 잠금) |  | 구현 |
| D00-4d-012 | §4d SpdDetail_EditChange / `e.Column == CHANGE_REASON_DETAIL` | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — CHANGE_REASON_DETAIL 분기) |  | 구현 |
| D00-4d-013 | §4d SpdDetail_EditChange / `strReasonCode=="-" \ | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — code=='' /'-' 시 되돌림 + REASON_CODE_FIRST MSG01291) |  | 구현 |
| D00-4d-014 | §4d SpdDetail_ClipboardPasted / `siDetail.IsLock == false` | ShipmentPlanAutoEssDetailGrid.tsx (`pastingCellHandler` → `isDetailCellEditable`) |  | 구현 |
| D00-4d-015 | §4d SpdDetail_ClipboardPasted / `SheetName == shtPlanDetail` | shipment-plan-auto-ess.editLock.ts (`isDetailCellEditable` — PlanDetail 외 전면 잠금 = 붙여넣기 차단) |  | 구현 |
| D00-4d-016 | §4d SpdDetail_ClipboardPasted / `cell.Text != ""` | ShipmentPlanAutoEssDetailGrid.tsx (`pastedCell` → `cellEditEndedHandler` — 붙여넣은 값 파생/전파) |  | 구현 |
| D00-4d-017 | §4d SpdDetail_ClipboardPasted / `iCol == CHANGE_REASON_CODE` | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` CHANGE_REASON_CODE 분기 — paste 도 동일 핸들러 경유) |  | 구현 |
| D00-4d-018 | §4d SpdDetail_ClipboardPasted / `dr == null` | ShipmentPlanAutoEssDetailGrid.tsx (`cellEditEndedHandler` — `if (!row) return`) |  | 구현 |
| D00-4d-019 | §4d SpdDetail_ComboSelChange / `e.Column == TRANSPORT_MODE` | — | AS-IS TRANSPORT_MODE 셀 콤보는 원문 전량 주석(dead) — TO-BE 평문 텍스트 유지(콤보 복원 금지, dead 정합. §3 그리드 행 근거) | 제외 |
| D00-4d-020 | §4d SpdDetail_ComboSelChange / `IsNullOrWhiteSpace(TRANSPORT_MODE)` | ShipmentPlanAutoEss.tsx (`handleSave` — TRANSPORT_MODE 공백 저장 차단, 콤보 확정 대신 저장검증으로 재현) |  | 구현 |
| D00-4d-021 | §4d SpdDetail_CellClick / `e.Column == CHANGE_REQ_NO` | — | CHANGE_REQ_NO 셀 팝업(SCM0002_ShipmentPlanRequestPopup) 진입 — TO-BE 팝업 부재로 미배선(04_react-gap.md 확인필요, convert-sp/팝업 후속) | 제외 |
| D00-4d-022 | §4d SpdDetail_CellClick / `IsNullOrWhiteSpace(sRequestNo)` | — | CHANGE_REQ_NO 공백 시 팝업 미진입 가드 — 상위 팝업(D00-4d-021)이 미배선이라 함께 제외 | 제외 |
| D00-4d-023 | §4d BtnMeasure_Click / `fps != null` | ShipmentPlanAutoEss.tsx (`handleMeasure` — activeGrid 판정 후 팝업, activeGrid 존재 전제) |  | 구현 |
| D00-4d-024 | §4d BtnMeasure_Click / `fps.Name == "spdDetail"` | ShipmentPlanAutoEss.tsx (`handleMeasure` — `if (activeGrid === 'detail') return` spdDetail 이면 no-op) |  | 구현 |
| D00-4d-025 | §4d DrpPeriod2_ValueChanged / `intDiff1>0 \ | shipment-plan-auto-ess.editLock.ts (`clampPeriod2` — drpPeriod 범위 이탈 시 무메시지 clamp) |  | 구현 |
| D00-4d-026 | §4d EditButton / `isOK == false` (SSP 미등록 사용자) | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-027 | §4d EditButton / `fps.Name == "spdMain"` (읽기전용 즉시 return) | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-028 | §4d EditButton / `fps.Name == "spdDetail"` | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-4d-029 | §4d EditButton / `bRealFlag == false` (CutOff Data 수정불가) | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:RequestorModal | FE 실존 모달 (components/modals/RequestorModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/modals/RequestorModal.tsx (`RequestorModal` — AS-IS UserInfoPopup 대응, 00 §5 팝업 6종·02 §4.6) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | ShipmentPlanAutoEss.tsx (`handleInsert` → GridAction.addRow) — 공용 DataGrid keepRowVisibleUnderFilter 승계(화면이 DataGrid 사용) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | ShipmentPlanAutoEss.tsx (`handleSearch` — hasUnsaved 판정 후 confirm `CONFIRM_RESEARCH_UNSAVED`=MSG00703 → onConfirm=`runMainSearch`) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | ShipmentPlanAutoEss.tsx (ColumnSettingModal `onSave` → activeGrid==='main' 시 `refetchMain`) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ShipmentPlanAutoEss.tsx (mutateConfirm onSuccess → `setToast` success `SAVED`; setAlert 는 검증차단 전용) |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | ShipmentPlanAutoEss.tsx (SubTitle `excelFileName`='ShipmentPlan' + staticColumns/셀콤보 dataMap 전달 — 공용 DataGrid excel 이 dataMap Name 승계) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useShipmentPlanAutoEssStore.ts (`multiLine` — split(/[\n,]/), Model/Item/BoxID 콤마·개행 다중) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | ShipmentPlanAutoEss.tsx (그리드 mainGridFilterRef 전달) — 공용 DataGrid rebindFilterColumns 승계(화면이 DataGrid 사용) |  | 구현 |

## 1. 영역1 Layout 동적규칙 (design 01 §2 R1~R10)

| # | AS-IS (line) | 구현 위치 (TO-BE) | 비고 | 상태 |
|---|---|---|---|---|
| R1 | btnSimulation 권한 게이트(dtPgmAuthId) | ShipmentPlanAutoEss.tsx (`customButtons` Simulation 항상 노출) | AS-IS 권한 게이트(dtPgmAuthId) 재현수단 미확정 — 항상 노출로 대체(04_react-gap 확인필요 축) | 구현 |
| R2 | 초기 hidden 3필드(ResultType/ShipmentDate/BoxID) | shipment-plan-auto-ess.detailSheets.ts (`INITIAL_FIELDSET` = PlanDetail: period3/resultType/boxId=false) | | 구현 |
| R3 | 활성 detail시트별 조회바 show/hide 매트릭스 | shipment-plan-auto-ess.detailSheets.ts (`FIELDSETS` + `fieldSetOf` — HoldStock=직전 유지) | | 구현 |
| R4 | 탭클릭/더블클릭 시트전환 + 재조회 | ShipmentPlanAutoEssDetailGrid.tsx (TabWrapper) + useShipmentPlanAutoEssStore.ts (`setDetailFilter` — 2차 Search/드릴다운만) | | 구현 |
| R5 | Shipment Result 진입 ResultType 기본체크 | ShipmentPlanAutoEssDetailBar.tsx (`resultTypeDefaultAppliedRef` 1회 체크) | | 구현 |
| R6 | Edit 모드토글(SwitchLock/bEdit_Mode) | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, pre-decided (b) whole-project) — `canEdit=hasButton('EDIT')` 1회·편집 기본 ON(convert-core §2.4)으로 대체 | 제외 |
| R7 | 마스터 항상 읽기전용 | shipment-plan-auto-ess.editLock.ts (`isMainCellEditable` — SHIP_PLAN measure D_ 셀만 편집) | | 구현 |
| R8 | 편집권한 = SSP 등록사용자(GetSSPUserCheck/PKG_SSP0002) | ShipmentPlanAutoEss.tsx (`canEdit`=hasButton('EDIT') 대체) | PKG_SSP0002 미배포 → EDIT 버튼권한 fail-open 대체(convert-sp 후속, 04_react-gap 확인필요 축) | 구현 |
| R9 | CutOff(bRealFlag=false) 편집차단 | useShipmentPlanAutoEssStore.ts (`realFlag` PlanDate index0) → mainEditable/detailEditable 곱 | | 구현 |
| R10 | 시트탭 상시노출 | ShipmentPlanAutoEssDetailGrid.tsx (TabWrapper 7탭 상시 — `DETAIL_SHEETS`) | | 구현 |

### toolbarOverride 5 (design 01 §2)
| override | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| Find | FindData_Main | `handleSearch`→`setMainFilters` | 구현 |
| Save | SaveData_Detail | `handleSave`→Detail Confirm(`mutateConfirm`) | 구현 |
| Insert | InsertRow(shtPlanDetail 복사, SHIPMENT_STATUS='C') | `handleInsert`(가드 재현, copy-list) | 구현 |
| Delete | NO-OP 빈 몸체 | `() => undefined`(노출 유지, false·키생략 금지) | 구현 |
| Edit | 권한+모드토글 | 미이식(R6) | 미이식(근거) |

## 2. 영역2 조회조건 (design 02)

| 조건 | AS-IS 원천 | TO-BE | 상태 |
|---|---|---|---|
| Division/Company | `SSP0021_GET_SHIPMENT_DIVISION`(2결과셋, VP UNION·NERP·81_UC) | `P_SSP0021_GET_SHIPMENT_DIVISION`(SHEETS.DIVISION 2-cursor, O_RC2 클라필터) | 구현 — 배포 GET SP 로 §7-1 콤보격차 해소(04 §2) |
| From Site | `Com_FromSite_SCP` | 콤보 `Com_FromSite_SCP` @divisionId,@companyId | 구현 |
| Bucket | `BucketType` lookup(기본 DAILY) | 콤보 `BucketType` | 구현 |
| Plan Date | `Plan_Infor_SCP` @companyId | 콤보 `Plan_Infor_SCP`, index0=최신 → realFlag | 구현 |
| Period | PlanDate 파생 FROM_DATE/TO_DATE1 | `setPlanDate` 파생, 표시전용 | 구현 |
| Shipment Date(period2) | drpPeriod2, 범위 clamp | DetailBar PeriodField + `clampPeriod2` | 구현 |
| Shipment Date(period3) | drpPeriod3, 기본 오늘-9~-1 | period3(ShipmentResult) | 구현 |
| Result Type | lookup `SSP_SHIPMENT_RESULT_TYPE` | `useTabLookupQueries` | 구현 |
| Model×2 | ItembyDivisionPopup(txtItemId/txtModel2) | `ItemByDivisionModal` ×2 | 구현 |
| Requestor | UserInfoPopup(single) | `RequestorModal`(콤보 `SSP0021_UserInfoList` 미등록) | 부분(확인필요) |
| Box ID | 자유입력 | InputField(boxId) | 구현 |
| Measure | SCM0002_TitleSetForm_Popup | `ColumnSettingModal` TITLESET 'M' | 구현 |
| usrButton1 | dead/orphan | 미이식 (design 02 §7-5) | 미이식(근거) |

## 3. 영역3 그리드 (design 03)

| 항목 | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| 동적 pivot D_/W_/M_ | SCP0009 calendar 3span + InitSpreadDateColumn | MainGrid `dynamicColumns`(calendar 우선, 3단 헤더) | 구현 |
| bucket 토글 × chkSum | SetSpreadColumn | `isDynVisible`(design 03 §2.2 표) | 구현 |
| 토/일 헤더색·MEASURE freeze·병합 | DAY_CODE / Freeze / SmartColMerge | formatItem 색 / DataGrid staticColumns freeze / Main allowMerging(동적 제외)·detail allowMerging=None(iter-3 G7, AS-IS 병합 0) | 구현 |
| MEASURE 세로축 표시/개인화 | SCM_MST_SHEET_MEASURE(9행) | store `staticMeasures`/`fetchStaticMeasures`(mount·Search) → MainGrid display 필터(iter-3 G4) | 구현(복원은 도메인 게이트2/3 확인필요) |
| SHIP_PLAN 편집 + Simulation | Simulation() 5산식 | `simulate()`(Container_Size_SCP) | 구현 `calc.ts` |
| white-list 편집 5+2열 | LockRange/IsLock + 가드 | `isDetailCellEditable`(PlanDetail 7컬럼) | 구현 `editLock.ts` |
| ERP_SO_NO 그룹 동기화 | for iRow 전파 | DetailGrid `cellEditEnded` propagate | 구현 |
| 편집 가드(ERP_STATUS='C'/TRANSPORT 공백/CHANGE_REASON 종속) | MSG00189/278/287 | beginningEdit + handleSave 검증 | 구현 |
| drill-down | SpdMain_CellDoubleClick | `handleMainDrilldown`(BOH_DRILLDOWN/measureDrilldownOf) | 구현 |
| 편집마킹 = CRUD_TYPE | EDIT_MAIN='Y' | EditTracker CRUD_TYPE + EDIT_MAIN 병기(전파) | 구현 |
| 셀콤보 SHIPMENT_STATUS/FCST_TYPE/CHANGE_REASON_CODE/oWMS STOCK_STATUS | SetCellTypeCombo/SetComBoParam | iter-3 G1: `useTabComboQueries`(@lookupType 직접) → DataMap col.dataMap `updatedLayout` 재부착. STOCK_STATUS 는 lookup 0행이라 미주입(확인필요) | 구현(dataMap 주입) |
| 셀콤보 DIVISION_ID(Hold/Result) | SetCellTypeCombo(Division @param1) | admin 컬럼메타 자동 콤보셀(전체 division, @lookupType 무관) | 구현(메타 구동) |
| CHANGE_REASON_CODE_ALL @lookupType | SetComBoParam | iter-3 G1: FE 가 lookupType='CHANGE_REASON_CODE' CMBO 주입('-' 포함 33코드 VALID_YN='Y'). design 03 §0 "7행" 은 실측 33행으로 정정 | 구현 |
| TRANSPORT_MODE 콤보 | 전량 주석(dead) | 평문 텍스트(콤보 복원 금지, dead 정합) | 구현 |

## 4. 미이식 / 확인 필요 (조용한 제외 금지 — convert-core §1)

- **Edit 모드토글(R6)**: convert-core §2.4 전 화면 공통 결정 — 편집 기본 ON. self-check `editMode|setEditMode` 0 hit.
- **PKG_SSP0002(GetSSPUserCheck, R8)**: 미배포 → `hasButton('EDIT')` 대체(fail-open). convert-sp 후속.
- **Drafting 3경로(NonSoNo/SoNo/NewNonSoNo) ERP IF 하위 SP 체인**: 미배포(goal.md ②) — 저장은 Confirm 경로만. convert-sp 후속.
- **Hold stock / Hold stock Detail 편집**: AS-IS 임시 hold(표시전용), SAVE/Detail GET SP 미배포 — 표시전용 유지.
- **CHANGE_REQ_NO 셀 팝업(SCM0002_ShipmentPlanRequestPopup)·ERP_SO_NO(SSP0300 OrderDetail)**: TO-BE 팝업 부재 — 미배선(확인필요).
- **Division/Company 콤보격차(design 02 §7-1)**: 후보콤보 대신 배포 GET SP 로 해소 — plan §0 B2 "전용 콤보 등록" 대비 방침 변경(04_react-gap §2, 사용자 확인 축).
- **Requestor 콤보(`SSP0021_UserInfoList`)**: AS-IS UserInfoList SQL(SystemManager DB) 접근 불가 — 미등록(빈 목록). 메타 정비 대기.
- **usrButton1**: dead/orphan 미이식.
- **bRealFlag 서버근거**: PlanDate index0 로 재현 — GET_SHIPMENT_PLAN_DETAIL 반환플래그 대조는 브라우저 축(확인필요).
