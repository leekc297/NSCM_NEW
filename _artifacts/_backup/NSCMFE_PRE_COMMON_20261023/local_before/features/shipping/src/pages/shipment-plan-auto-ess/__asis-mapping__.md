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

### 4-2. 자매 SSP0060 UI 정합 — 헤더·조회·합계·그리드이벤트 4축 (2026-10-12)

4축을 SSP0060 과 대조해 **격차의 성격별로** 처리했다. 같은 3단 캘린더 헤더 구조라 동일 결함을
그대로 갖고 있던 항목은 이식하고, SSP0021 AS-IS·설계가 다른 항목은 **맞추지 않았다**.

| 축 | 항목 | SSP0060 | SSP0021(종전) | 처리 |
| --- | --- | --- | --- | --- |
| 헤더 | 동적 3단 컬럼 `height: 16` | 있음 | **없음** → Wijmo 기본 48/단 → 헤더 48x3=144px | **이식** |
| 헤더 | `applyHeaderHeight`(총 48px 강제, updatedLayout) | 있음 | **없음** | **이식** |
| 헤더 | 그리드 `allowMerging` | `All`(헤더 병합) | `Cells` → **헤더 병합 풀림**(GRID-11 금지) | **이식**(All) |
| 합계 | 좌하단 `'Sum'` 라벨 | 있음 | 없음(공용 기본 'Σ') | **이식** — AS-IS cs **L769** `ColumnFooter.Cells[0,1].Value="Sum"` 실측 |
| 합계 | `col.aggregate` updatedLayout 재적용 | 있음 | 1회 대입만 → columnGroups 재생성 때 유실 | **이식** |
| 합계 | Sum 행 바닥 고정(0건에도 맨 아래) | 있음 | 없음 | **이식** |
| 합계 | `useAggregationRow` prop | 있음 | 없음 | **이식** — AS-IS 는 조회 전부터 Sum 행 노출 |
| 이벤트 | 셀 병합 `MergePolicy.Always` 다컬럼 | AS-IS cs L651~656 **6컬럼** + 전용 MergeManager | — | **미이식** |
| 이벤트 | Detail `allowMerging` | `Cells` | `None` | **유지**(변경 안 함) |
| 이벤트 | 편집 즉시 재계산(`onCellEdited`) | 있음 | 없음(Simulation 버튼 전용) | **미이식** |
| 조회 | Measure 타이틀셋 개인화(`visibleMeasures`) | 전용 `MeasureSelectModal` | 전용 `MeasureSelectModal` + `display` 플래그 | **이식 완료**(2026-10-12, 아래) |

- **셀 병합 미이식 근거**: SSP0021 AS-IS 의 `MergePolicy` 는 **전건 1줄**이다 —
  `siMain.ActiveSheet.Columns[DefColumns.PSI].MergePolicy = MergePolicy.Always`(cs **L624**).
  SSP0060 은 PSI·MEASURE_NAME·TO_SITE·TRANSPORT_MODE·INCOTERMS·FCST_TYPE **6컬럼**(L651~656)이다.
  6컬럼 전용 MergeManager 를 그대로 옮기면 AS-IS 에 없는 병합을 만든다 — 옮기지 않았다.
  PSI 1컬럼은 공용 `CustomMergeManager` 의 좌측 누적키(Restricted) 동작에 이미 포함된다(최좌측 컬럼).
- **Detail `allowMerging` 유지 근거**: 위와 같은 실측이다. 병합 신호가 `siMain` 전용이므로 Detail 은
  `None` 이 AS-IS 정합이다(기존 주석 "merge 전건 spdMain 전용 — design 03 §3.5" 와 일치).
- **편집 즉시 재계산 미이식 근거**: SSP0021 은 "재계산은 Simulation 버튼에서만"이 설계다(design 03 §2.3,
  MainGrid 헤더 주석). SSP0060 의 `onCellEdited` 즉시 재계산을 넣으면 그 설계를 깬다.
- **Main 그리드 읽기전용 전환 + Simulation 버튼 제거 + SHIP_PLAN 행 구분색 (사용자 분석 확인 2026-10-12)**

  사용자가 "AS-IS 에서 Edit 가 읽기전용으로 막혀 있고 결국 조회성 화면"이라고 분석했고, AS-IS 정본
  대조 결과 **맞다.** `SSP0021_ShipmentPlan.cs` `EditButton()` L2370~2375:

  ```csharp
  if (fps.Name == "spdMain") {
      // jilee 231004
      MessageHelper.GMessageBox("MSG00109", null);   // "읽기 전용입니다."
      return;                                        // ← 무조건 return
      CanModelChange = false;                        // 이하 전부 도달 불가(死코드)
      if (bEdit_Auth == true) { ... siMain.LockRange(i, j, i, j, false) ... }
  }
  ```

  2023-10-04(jilee)에 들어간 무조건 `return` 이라 그 아래 `bEdit_Auth` 분기·unlock 로직이 전부
  死코드다. **어떤 권한/그룹이어도 Main 은 편집 불가.** → `mainEditable = false` 로 고정했다.
  Detail 은 유지 — 같은 EditButton 의 else 분기(cs L2459~)가 spdDetail 에 `SwitchLock()` +
  LockColumn/LockRange 로 정상 편집을 연다. 차단은 **spdMain 한정**이다.

  이로써 design 03 §1.2 의 "Main SHIP_PLAN 편집 유일" · "편집 → Simulation → Detail Confirm 저장"
  기술은 **2023-10 차단 이전 기준의 낡은 기술**임이 확인됐다.

  **Simulation 버튼 — 제거(사용자 지시), 다만 SSP0060 과 사정이 다르다**:
  AS-IS 에 버튼 자체는 **있다**(`btnSimulation` Designer / `BtnSimulation_Click` cs L1869 /
  `Simulation()` cs L6053). Form_Load(cs L440~458)가 `PGM_AUTH_ID` 룩업에서
  `CODE='SSP0021' AND NAME=NowGroupID` 행을 찾아 `layoutControlItem12`(= btnSimulation 을 담은
  레이아웃 아이템, Designer L756)의 Visibility 를 가른다. 그 룩업에 **SSP0021 행이 3개 있다**
  (ADMIN · SCM Viewer · SSP Planner — AS-IS/TO-BE DB 동일 실측). 즉 SSP0060(행 0개 → 전원 비노출)과
  달리 **특정 그룹에는 보인다.** 그럼에도 제거한 근거는 (1) Main 편집이 하드 차단돼 Simulation 의
  입력 경로가 사라졌고(읽기전용 그리드 위 값만 흔드는 버튼), (2) 사용자 제공 AS-IS 캡처에도 툴바에
  없다는 것. 재계산 본체 `utils/shipment-plan-auto-ess.calc.ts` `simulate` 는 남겼다 —
  되살릴 때 `customButtons` 항목만 복구하면 된다.

  **SHIP_PLAN 행 구분색 이식** — AS-IS `Re_Design()` cs L4773~4780:
  `Cells[i, MEASURE+1, i, ColumnCount-1].BackColor = Color.FromArgb(80, Color.LightSkyBlue)`.
  LightSkyBlue rgb(135,206,250) 에 알파 80/255 ≈ 0.314 → `rgba(135,206,250,0.314)` 로 MainGrid
  `formatItem` 에 적용(동적 D_/W_/M_ 컬럼 한정). 비해당 셀은 명시적으로 비운다 — Wijmo 셀 DOM
  재사용으로 스크롤 잔상이 남기 때문. 사용자 제공 AS-IS 캡처의 'Shipment Plan' 행 하늘색과 일치.

  **조회전용 스타일까지 맞춤(사용자 지적 2026-10-12)**: 편집을 막았으면 스타일도 따라가야 한다.
  - `DataGrid isReadOnly` 적용 — 셀 편집 진입을 막고 rowHeaders 의 CRUD 마커 컬럼도 빠져
    "수정 가능한 그리드" 어포던스가 사라진다. 조회전용 자매 화면 공통 규약이다
    (shipment-change-history · shipment-change-request-confirm · delegate 등 실사용).
  - **편집가능 노랑(#FFFDE7) 제거** — `editable` 이 항상 false 라 도달 불가한 死분기였고, 남겨두면
    "여기는 고칠 수 있다"는 잘못된 어포던스가 된다. 셀 배경은 SHIP_PLAN 행 구분색만 쓴다.
  - 편집 전제로 쓰인 낡은 주석 3곳(prop 설명·그리드 머리·formatItem)을 조회전용 기준으로 정정.
  - `beginningEdit`/`pastingCell`/Delete 핸들러와 `isMainCellEditable` 판정은 **방어선으로 유지**한다
    (AS-IS 차단이 풀리면 `editable` 만 다시 열면 된다). Detail 그리드는 편집 가능이라 대상 아님.

  **미이식(같은 Re_Design 내)**: `CONTAINER` 행에서 `LOT_YN='N'` 이면 MEASURE+1~끝 값을 null 로
  비우는 처리(cs L4764~4771)와 ITEM_ID 그룹 경계 BevelBorder(cs L4783~4790)는 이번 범위 밖 —
  별건으로 남긴다.

- **Period 표시를 공용 PeriodField 로 교체 (사용자 지시 2026-10-12) — 편집은 AS-IS 대로 막음**

  종전에는 `disabled InputField` 에 `20260919 ~ 20261113` 처럼 **YYYYMMDD 원문을 이어 붙여** 보여줬다.
  AS-IS `drpPeriod` 는 날짜 피커라 `2026-09-19` 대시 표기다. 자매 SSP0060 이 쓰는 공용
  `PeriodField`(master/searchFields)로 바꿔 표기를 맞췄다 — store 의 8자 값을 그대로 받으므로
  변환이 필요 없다(`planPeriodOf` 가 이미 8자를 보장).

  **편집 가능 여부는 SSP0060 을 따라가지 않았다 — AS-IS 가 두 화면에서 다르다:**

  | 화면 | Designer 실측 | 결과 |
  |---|---|---|
  | **SSP0021** | `SSP0021_ShipmentPlan.Designer.cs:428` `this.drpPeriod.Enabled = false;` | **표시전용** |
  | SSP0060 | 해당 줄 없음(기본 enabled) | 편집 가능 |

  그래서 SSP0060 Form 은 editable `PeriodField` 를 쓰지만 여기서는 `disabled` 를 준다.
  (`disabled` 는 SSP0015 Packer 시트 선례가 있는 공용 prop — `SearchFields.tsx` L1120.)
  SSP0060 의 editable 전환은 "종전 disabled InputField 는 변경 불가였음"(2026-10-02 사용자 요청)
  이라 적혀 있는데, Designer 대조 결과 그건 **SSP0060 의 AS-IS 파리티 복원**이었고 SSP0021 에는
  해당하지 않는다. 편집까지 열려면 AS-IS 이탈 결정이 따로 필요하다.

  DetailBar 의 `drpPeriod2`(Shipment Date)·`drpPeriod3` 는 이미 `PeriodField`(편집 가능)였다 — 변경 없음.

- **Bucket 콤보가 빈 값으로 뜨던 문제 — CODE→BUCKET_TYPE 매핑 (사용자 신고 2026-10-12)**

  **증상**: Bucket 콤보가 바인딩돼도 'Daily' 가 선택돼 보이지 않았다.

  **원인**: 콤보 `BucketType` 은 룩업 `BUCKET_TYPE_CODE` 의 `SEGMENT1` 을 CODE 로 내리는데, 그 값이
  **풀워드** `DAILY`/`WEEKLY`/`MONTHLY` 다(ora.py 실측 3행, NAME = `Daily`/`Weekly`/`Monthly`).
  반면 store 기본값은 `bucketType: BUCKET_TYPE.DAILY` = **`'D'`** 이고, MainGrid 의
  `isDynVisible(kind, bucket, chkSum)`(ShipmentPlanAutoEssMainGrid.tsx L63~66)도 `D`/`W`/`M` 로
  분기한다. 종전 코드는 `toOptions(bucketRows)` 로 CODE 를 그대로 value 에 넣어
  `value='D'` ↔ `options[].value='DAILY'` 가 어긋났다 → 콤보 **빈 표시**.

  **부수 영향(표시만의 문제가 아니었다)**: 사용자가 항목을 고르면 `'DAILY'` 가 store 에 들어가
  `isDynVisible` 의 세 분기(`BUCKET_TYPE.DAILY`/`WEEKLY`/`MONTHLY`)에 모두 안 걸려
  **D_/W_/M_ 동적 컬럼 토글이 통째로 어긋난다.**

  **수정**: `BUCKET_CODE_TO_TYPE` 매핑으로 option value 를 `D`/`W`/`M` 로 변환한다(라벨은 NAME 유지).
  폴백 라벨도 룩업 NAME 표기(Title Case)에 맞췄다. 자매 SSP0060 이 2026-10-02 에 같은 증상으로
  도입한 처리와 동일하다(ShipmentPlanForm.tsx L38~43 · L151~166).

- **Model 검색박스 → Model/Nickname + 팝업 교체 (사용자 지시 2026-10-12) — 의도적 AS-IS 이탈**

  **라벨**: 1차(Form)·2차(DetailBar) 모두 `LBL.MODEL`(LBL00669 'Model') → `LBL.MODEL_NICKNAME`
  (**LBL00618**). `SCM_ADM_MSG_M` 실측상 KO/EN/CN 3개 언어 모두 'Model/Nickname' 으로 기등록이라
  신규 등록이 없다(CORE-08). 자매 SSP0060 도 같은 코드를 양쪽에 쓴다.

  **팝업**: 1차·2차를 `ItemByDivisionModal`(COM0008) → **`MaterialByDivisionModal`(COM0013)** 로 교체.

  **AS-IS 와 다르다 — 사용자 결정으로 채택**: AS-IS SSP0021 은 세 자리 모두
  `SCM0002_ItembyDivisionPopup` 을 new 한다(`SSP0021_ShipmentPlan.cs` L988 btnItemId / L2499 셀).
  그 클래스의 TO-BE 대응은 `ModelByDivisionPopup`(SCM0002/ModelPopup →
  `PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP`)이고, 자매 **SSP0060**(ShipmentPlan.tsx L805~814)
  ·**SSP0015** 가 그걸 쓴다. `ItemByDivisionModal`(COM0008, AS-IS `DM0002_ItembyDivisionPopup`)과
  `MaterialByDivisionModal`(COM0013)은 **SP·그리드 컬럼이 다른 별개 팝업**이다. 즉 교체 전 배선도
  AS-IS 와 달랐고, 이번 교체 역시 파리티 복원이 아니라 사용자 지시에 따른 선택이다.
  (참고: 'Model/Nickname' 라벨의 원래 근거는 2026-10-08 에 Model/Nickname 검색이 추가된
  `P_SCM0002_GET_ITEM_BY_DIVISION_POPUP` 쪽이다 — 라벨 근거와 채택 팝업이 서로 다른 SP 를 가리킨다.)

  **positional 계약 주의**: master 계약은 `(itemId, itemName, itemClassName, nickName)` 로
  **NickName 이 4번째**다. 종전 `ItemByDivisionModal` 은 5인자라 자리가 다르다 — 자리를 잘못 받으면
  모델 설명 문자열이 `NICK_NAME` 에 박힌다(자매 SSP0201 에서 실제로 난 사고).
  현재 1차·2차는 itemId 만 쓰므로 영향 없음.

  **미교체(확인 필요)**: Detail 그리드 `ITEM_ID` **셀 팝업**(신규행 한정, 03 §3.7)은 여전히
  `ItemByDivisionModal` 이다. "Model 검색박스" 범위 밖이라 건드리지 않았다. 이 자리는 `nickName` 을
  실제로 받아 `NICK_NAME` 에 쓰므로(5번째 인자) 교체하려면 positional 을 4번째로 바꿔야 한다.

- **조회 시 ORA-01843 수정 — Plan Date 기간을 콤보 날짜 대신 CODE 에서 계산 (사용자 신고 2026-10-12)**

  **증상**: 조회하면 SQL 오류. 백트레이스 `ORA-06512: at "SCM_MGR.PKG_SSP0021", line 2381` →
  `realFlag='Y'` 분기의 `INSERT INTO GT_0021_ROWDATA ... SELECT` 안, 구체적으로 **L2495**
  `TO_DATE(P_FROM_YYYYMMDD, 'YYYYMMDD')` 에서 `ORA-01843: invalid month`.

  **원인**: FE 가 조회기간으로 콤보 `Plan_Infor_SCP` 의 `FROM_DATE`/`TO_DATE1` 을 **그대로** 보냈다.
  그 SQL 은 `TO_CHAR(TO_DATE(...))` 처럼 포맷 인자 없이 날짜를 문자열화해 세션 NLS 를 탄다 —
  실측 `FROM_DATE='2026-09-19'`(NLS=YYYY-MM-DD) 또는 `'19-SEP-26'`(기본 DD-MON-RR)이고 `TO_DATE1`
  에서는 연도가 깨진 `00191120` 까지 관측됐다. 대시 섞인 값이 `fromYyyymmdd` 로 흘러가 터진 것.

  **자매 SSP0060 대조**: `PKG_SSP0060` 의 원본 파라미터 사용처 23곳을 전수 확인한 결과
  `TO_DATE(P_FROM_YYYYMMDD, ...)` 로 파싱하는 자리가 **하나도 없다**(선언 8 / 문자열 BETWEEN·<= 6 /
  `SUBSTR(REPLACE(...))` 정규화 4 / 전달·대입 5). 즉 SSP0060 이 멀쩡한 이유는 SP 방어가 아니라
  **FE 가 깨끗한 YYYYMMDD 를 보내기 때문**이다 — `ShipmentPlanForm.tsx` 의 `planPeriodOf(code)` 가
  콤보 날짜를 버리고 CODE 로 직접 계산한다(2026-10-02 에 같은 NLS 문제를 겪고 도입된 주석이 남아 있다).

  **수정**: 같은 방식을 SSP0021 Form 에 이식했다 — `planPeriodOf(code)` 로 CODE(`REPLACE` 로 만들어져
  항상 깨끗)에서 `from`/`to` 를 YYYYMMDD 8자로 계산하고, 기본값 effect 와 `handlePlanDateChange`
  양쪽이 그것만 쓴다. `ComboResponse` import 는 불필요해져 제거.

  **주의 — 오프셋은 베끼지 않았다**: AS-IS 가 두 화면에서 다른 컬럼을 쓴다.
  SSP0060 은 `drpPeriod.Value2 = dr["TO_DATE1"]`(cs L7241, +14일), **SSP0021 은
  `dr["TO_DATE"]`(cs L5943, +55일)** 다. 그래서 `PERIOD_TO_OFFSET_DAYS = 55` 로 뒀다 —
  SSP0060 의 +14 를 그대로 옮기면 조회기간이 AS-IS 대비 줄어든다.

  **검증(SP 직접 호출)**: 새 값 `from=20260919 / to=20261113` 으로 div=81 realFlag=Y → 36행,
  div=82 realFlag=Y → 378행 정상. 종전 값(`'2026-09-19'`/`'2026-10-03'`)은 동일 조건에서 ORA-01843 재현.

  **미해소(별건 하드닝)**: `PKG_SSP0021` L2495 는 이 패키지에서 **유일하게 `REPLACE` 가 없는**
  날짜 파싱이다(L1995~1998·2899·2900·3431·3432 는 전부 정규화). FE 가 정상값을 보내게 됐으므로
  지금 증상은 사라지지만, 방어 차원에서 다른 6곳과 같은 형태로 맞추는 것은 별도 과제로 남긴다.

- **Division 기본선택 누락 교정 (사용자 지시 2026-10-12) — 조회 전 날짜 헤더 미생성의 선행 원인**

  TO-BE Form 에는 Company·PlanDate 기본값 effect 는 있는데 **Division 기본값 effect 가 없었다.**
  그래서 `sc.divisionId` 가 빈 문자열로 남고, Company 기본값이 `!sc.divisionId` 로 즉시 return →
  PlanDate 기본값도 안 걸림 → CALENDAR 필터 미설정 → **조회 전 주차·일자 헤더 미생성**.
  아래 "헤더 생성 시점 교정"만으로는 해소되지 않았던 이유가 이것이다.

  AS-IS 파리티 근거(추정 아님): `clbDivision_ID` 는 Designer 실측상 **`UsrCombo`**(= WinForms
  `ComboBox` 파생, `SSP0021_ShipmentPlan.Designer.cs` L44·L1473)이고, Form_Load(cs L502)가
  `clsCtrl.setListBox(dtMyDivision, clbDivision_ID, false, "CODE", "NAME")` 로 DataSource 를
  바인딩한다 — 해석되는 overload 는 `CControl.cs` L338(`ComboBox`, 5인자)이고 `blnAllFlag=false`
  라 **'ALL' 항목이 없다.** ComboBox 는 DataSource 바인딩 시 첫 행이 자동 선택되며, 바로 다음 줄
  (cs L505~508)이 그 선택값으로 Company 목록을 만든다. 즉 AS-IS 도 "첫 division 자동 선택 →
  Company cascade" 이고, TO-BE 가 그걸 빠뜨린 것이다. 자매 SSP0060 Form(L172~179)에는 이미 있다.

  목록 원천도 대조했다 — TO-BE `PKG_SSP0021.P_SSP0021_GET_SHIPMENT_DIVISION(groupId, userId)`
  실측(ADMIN/minyonglee1) = 6행(81·81_HD·81_HG·81_HM·81_ST·82)로 AS-IS `MyDivisionOut40`
  (= 사용자 보유 division, 40 제외)과 같은 성격이다. 'ALL' 항목 없음도 일치.

- **Main 3단 날짜 헤더 생성 시점 교정 (사용자 지시 2026-10-12)**

  "로드되었을 때 주차 Column 이 생기도록" — 종전에는 `setMainFilters`(Search)에서만 CALENDAR 필터를
  채워 **조회 전까지 주차·일자 헤더가 비어 있었다.** AS-IS `cboPlanDate_SelectedIndexChanged`
  (cs L5947~5960)는 `drpPeriod` 가 채워지는 즉시 그 자리에서
  `GetSpdTitle()`(= `P_SCP0009_GET_SHEET_CALENDAR_3SPAN`) + `InitSpreadDateColumn(siMain, ...)` +
  `SetSpreadColumn()` 을 돌린다. 즉 Division→Company cascade 가 끝나 PlanDate index0 이 자동
  선택되는 순간 조회 전에 이미 날짜 컬럼이 서 있다.
  → store `setPlanDate` 에서 `filters[SHEETS.CALENDAR]` 를 채우도록 옮겼다(from/to 둘 다 있을 때만
  — AS-IS `!IsNullOrWhiteSpace(Text1 && Text2)` 가드 등가). 자매 SSP0060 에 이미 들어간 배선과 동일.

- **Main 헤더 AS-IS 불일치 교정 — 메타 3건 (사용자 지시 2026-10-12, `design/22_fix_main_header_parity.sql` 적용 완료)**

  양 DB 전건 실측(asis.py / ora.py, 'Shipment Plan' 13행)으로 확정했다. 라벨·폭·class 라벨은 양쪽이
  같고 **VISIBLE_FLAG 불일치는 `MEASURE` 1건**(AS-IS 'N' / TO-BE 'Y')뿐이었다.

  | # | 대상 | 수정 | 근거 |
  |---|---|---|---|
  | 1 | `MEASURE` | VISIBLE_FLAG `Y → N` | AS-IS 실측값 복사. `MEASURE_NAME`(LBL='Measure')과 `MEASURE`(LBL='Measure')가 나란히 떠 **"Measure" 헤더가 2개**였다. 코드값은 내부 축이라 `visible=false` 여도 itemsSource 에 그대로 실린다 |
  | 2 | 13행 전건 | `LARGE/SMALL_CLASS_LABEL_NAME → NULL` | 전부 `COLUMN_LABEL_NAME` 과 같은 값(Div/Div/Div …)이라 공용 `getColumnDepth` 가 THREE_DEPTH 로 판정 → 같은 글자가 헤더 3행에 반복되고 base 컬럼이 1칸으로 안 합쳐졌다. AS-IS(FarPoint)는 같은 라벨을 `ColumnHeaderSpan` 으로 세로 병합한다 |
  | 3 | `BOH_TYPE`·`BOH_QTY` | `COLUMN_LABEL_NAME → 'BOH'` | #2 로 class 라벨을 비우면 leaf 라벨(`BOH_TYPE`·`BOH_QTY` = 컬럼명 그대로)이 노출된다. AS-IS 는 메타가 아니라 코드로 한 칸을 만든다 — cs L611 `HeaderSpan(siMain, 0, BOH_TYPE, 3, 2, "BOH")`. TO-BE 는 헤더 병합이 켜져 있어 인접 두 컬럼 라벨이 같으면 한 칸이 된다 |

  자매 SSP0060 의 `design/11`·`13`·`15` 와 같은 사유·같은 방식이다(CLAUDE.md §2#4 — AS-IS 가 코드로
  처리하던 것은 코드가 아니라 메타로 정비). 컬럼을 숨기지 않으므로 BOH_QTY 더블클릭 드릴다운
  (BOH_TYPE 분기)은 그대로 살아 있다. 롤백 `22_fix_main_header_parity_rollback.sql`.

- **Measure 설정 교체 완료 (사용자 지시 2026-10-12 — 자매 SSP0060 과 동일 수정)**

  종전 배선(공용 `ColumnSettingModal` + `columnType='M'`)은 **목록이 항상 0건**이었다. 그 팝업의
  조회 proc `DMF0002_GET_TITLESET_POPUP` 이 (1) 목록 원천을 항상 `SCM_MST_SHEET_COLUMNS` 로 두고
  (`P_COLUMN_TYPE` 은 사용자 저장분 필터 전용 — Measure 분기 없음), (2) division 을
  `P_DIVISION_ID IN (split(C.DIVISION_ID, ','))` 로 걸러 `C.DIVISION_ID` 가 NULL 인 메타를 전부
  버리기 때문이다. SSP0021 메타는 `SCM_MST_SHEET_COLUMNS`('Shipment Plan' 13행)·
  `SCM_MST_SHEET_MEASURE`(9행) 모두 DIVISION_ID 가 NULL 이다.

  proc 직접 호출 실측(2026-10-12, `minyonglee1`):

  | 호출 | 결과 |
  |---|---|
  | `DMF0002_GET_TITLESET_POPUP(SSP0021,'Shipment Plan','M', div=40)` | **0행** |
  | 같은 호출, `div=NULL` | **0행** |
  | `PR_GET_SHEET_MEASURE_LIST(SSP0021,'Shipment Plan', div=40)` | 0행 |
  | 같은 호출, `div=NULL` | **9행** — SHIP_REQ·SHIP_PLAN·SHIP_AVAL·SHIP_AVAL_GAP·INTN_MOVEMENT·CONTAINER·PROD_PLAN·WH_STOCK·BALANCE |

  **수정**: 화면 전용 `components/modals/MeasureSelectModal.tsx`(+`.module.scss`) 신설. 조회는 store
  `fetchStaticMeasures`(이미 `/admin/menu/SSP0021/measure` 를 쓰고 있었다 — divisionId 미전달도
  그대로 맞다)를 재사용하고, store 에 `visibleMeasures`·`applyVisibleMeasures` 만 추가했다.
  OK → `saveTitleSet({ columnType: 'M' })` → `fetchStaticMeasures()`(MainGrid 의 `display` 게이트가
  따라간다) + `refetchMain`. 저장 proc `SCM0002_SET_TITLESET_POPUP` 의 DELETE 는 타입별이라
  (L91~95 `AND USER_INQUIRY_COLUMN_TYPE_CODE = P_COLUMN_TYPE`) 컬럼('C') 개인화는 보존된다.
  모달을 화면 전용으로 둔 이유는 `modals/OrderDetailModal`·`modals/RequestorModal` 과 같다
  (타 도메인 팝업 직접 import 금지 — 사용자 확정 2026-09-25).

- **미해소(DB) — `PKG_SSP0021` 타이틀셋 타입 필터 부재**: `P_SSP0021_GET_...`(body L2004~2030)이
  `SCM_MST_TITLESET_USER` 를 `PROGRAM_ID`·`SHEET_NAME`·`USER_ID` 로만 읽고
  **`USER_INQUIRY_COLUMN_TYPE_CODE` 를 보지 않는다.** 자매 SSP0060 은 이 결함으로 2026-10-06 에
  Grid1 이 통째로 0건이 됐고(`SSP0060/design/17_fix_titleset_user_measure.sql`) 2026-10-07 에
  SP 에 `AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M'` 을 넣어(L2092·L2116) 근본 해소했다. SSP0021 은
  그 필터가 없다. 현재 데이터는 `minyonglee1` 기준 'C' 9행(전부 measure 아님) + 'M' 9행(전부 measure)
  이라 measure 가 'M' 쪽에서 매칭돼 **지금은 Grid1 이 정상**이지만, 'M' 행만 사라지고 'C' 행이 남는
  상태가 되면 측정축이 전멸한다. SSP0060 과 같은 1줄 수정이 필요하다 — DB 변경이라 별건으로 보고.

### 4-1. 자매 SSP0060 수정분 이식 판정 (2026-10-12 — AS-IS SSP0021 정본 기준)

자매 SSP0060 이 SSP0015 갭감사에서 이식한 항목 + 그 뒤 사용자 결정분을 **SSP0021 AS-IS 정본**
(`GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0021_ShipmentPlan.cs`, 6557줄)으로 재판정했다.
SSP0060 에 있다는 이유만으로 옮긴 항목은 없다(SSP0060 커밋 `c52f2783` 이 세운 원칙 승계).

| 항목 | SSP0021 AS-IS 실측 | 판정 |
| --- | --- | --- |
| R7a USER_CHECK 가드 | L2360 `bool isOK = GetSSPUserCheck();` **활성** + L5836 구현체 | **이식** |
| OrderDetail 팝업(SSP0300) | L1603 `new SSP0300_OrderDetailPopup()` **활성** | **이식** |
| TransMode 행단위 cascade 재조회 | L1789 `//siDetail.SetCellTypeCombo(... TRANSPORT_MODE ...)` — **주석 처리된 死코드** | **미이식** |
| 음수 검증 셀 색(시안 #5CD1E5) | L2904 `//siMain.SetBGColor(..., ControlColor.InvalidColor)` — **주석 처리된 死코드** | **미이식** |
| 같은 셀 더블클릭 가드 | AS-IS 항목 아님(브라우저 거동 결함). SSP0021 도 Main/Detail 두 곳에 가드 없는 `dblclick` 리스너 보유 | **이식** |
| 확정구간(CONFIRM_DAY) 조회전용 | AS-IS·design 이탈 **정책 결정** | **이식**(사용자 결정) |

- **TransMode / 음수 셀 색 미이식 근거**: 둘 다 SSP0021 에서 주석 처리된 死코드다. SSP0060 은 TransMode 가
  **활성**이라 이식했고 SSP0015 는 死코드라 정적 전환했는데, SSP0021 은 SSP0015 쪽과 같은 상태다.
  기존 대사표의 `TRANSPORT_MODE 콤보 | 전량 주석(dead) | 평문 텍스트(콤보 복원 금지, dead 정합)` 과도 일치한다.
- **확정구간 조회전용(의도적 AS-IS 이탈)**: AS-IS `EditButton` 과 design 03 §1.2/§2.3 은
  `curPlanDate <= 일자 <= CONFIRM_DAY` 창을 **편집창**으로 적었다. 확정(frozen) 구간을 편집 표면으로
  두는 셈이라 사용자가 반대로 확정했다 — 확정구간은 잠그고 편집은 그 구간을 **지난** 일자에서만 허용한다.
  `utils/shipment-plan-auto-ess.editLock.ts` `isMainCellEditable` 의 CONFIRM_DAY 비교가 AS-IS·design 과
  반대 방향인 것은 이 결정 때문이다(자매 SSP0060 과 통일, convert-core §2.4 이탈 기록).
  방향이 다시 뒤집히지 않도록 `shipment-plan-auto-ess.editLock.test.ts` 로 고정했다.
- **선행 DB 등록**: USER_CHECK·GET_ORDER_DETAIL 두 버튼은 `SCM_ADM_MNU_BTN_MPG_M`(2행) +
  `SCM_ADM_USER_GR_MNU_BTN_MPG_M`(4행) 등록이 **선행 조건**이다. 없으면
  `PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST` 가 NO_DATA_FOUND 로 터지고(핸들러 없음) call-proc 이 실패한다.
  `design/21_register_sibling_port_btn_auth.sql` — QA 선반영 후 운영(사용자 지시).
  `SCM_ADM_API_M` 은 두 API_ID 가 공용으로 이미 등록돼 있어 **건드리지 않는다**.

- **Edit 모드토글(R6)**: convert-core §2.4 전 화면 공통 결정 — 편집 기본 ON. self-check `editMode|setEditMode` 0 hit.
- ~~**PKG_SSP0002(GetSSPUserCheck, R8)**: 미배포 → `hasButton('EDIT')` 대체(fail-open)~~ → **해소(2026-10-12)**. "미배포" 는 오판이었다 — `PKG_SSP0002` PACKAGE/BODY 모두 VALID(ora.py 실측). 자매 SSP0060 이식분으로 배선: AS-IS `EditButton` 첫 가드 `GetSSPUserCheck()`(cs L2358~2368 호출 / L5836~5858 구현, `SSP.SSP0002_GET_USER_INFO_LIST` Search=UserId·Language·SSOUserYN='N', **0행이면 false**)를 `USER_CHECK` call-proc 으로 이식. 0행이면 `canEdit=false` + MSG01261 1회 알럿(`ShipmentPlanAutoEss.tsx`). 편집 기본 ON 전환으로 Edit 클릭 시점이 없어 **판정 완료 시점 1회**로 옮겼다. 버튼 등록: `design/21_register_sibling_port_btn_auth.sql`.
- **Drafting 3경로(NonSoNo/SoNo/NewNonSoNo) ERP IF 하위 SP 체인**: 미배포(goal.md ②) — 저장은 Confirm 경로만. convert-sp 후속.
- **Hold stock / Hold stock Detail 편집**: AS-IS 임시 hold(표시전용), SAVE/Detail GET SP 미배포 — 표시전용 유지.
- **CHANGE_REQ_NO 셀 팝업(SCM0002_ShipmentPlanRequestPopup)**: TO-BE 팝업 부재 — 미배선(확인필요). (ERP_SO_NO 는 아래에서 해소)
- ~~**ERP_SO_NO(SSP0300 OrderDetail)**: TO-BE 팝업 부재 — 미배선~~ → **해소(2026-10-12)**. 조회 proc `P_SSP0300_GET_ORDER_DETAIL` 은 패키지가 아니라 **standalone PROCEDURE** 로 배포돼 있고(ALL_ARGUMENTS 4 IN + O_RC1 실측), `SCM_ADM_API_M` 에도 **화면 비종속 공용**으로 이미 등록돼 있다 — 종전 "부재" 는 패키지명으로만 찾아 생긴 오판이다. AS-IS cs L1591~1611(shtPlanDetail + ERP_SO_NO 셀 + 값 비공백 → `Form_Load(DIVISION_ID, ERP_SO_NO, CONFIRM_ID, ITEM_ID, "N")`)을 `components/modals/OrderDetailModal.tsx` 로 이식. 5번째 `electrode_yn` 은 상수 "N" 이고 TO-BE proc IN 은 4개라 보내지 않는다. **SO 없는 행은 공백이 아니라 `'-'`** 이므로(`PKG_SSP0021` L3880 `'-' AS ERP_SO_NO` 실측) 둘 다 거른다 — AS-IS 가드는 `""`·null 만 보지만 빈 팝업을 막기 위해 개선했다(자매 SSP0060 과 통일).
- **Division/Company 콤보격차(design 02 §7-1)**: 후보콤보 대신 배포 GET SP 로 해소 — plan §0 B2 "전용 콤보 등록" 대비 방침 변경(04_react-gap §2, 사용자 확인 축).
- **Requestor 콤보(`SSP0021_UserInfoList`)**: AS-IS UserInfoList SQL(SystemManager DB) 접근 불가 — 미등록(빈 목록). 메타 정비 대기.
- **usrButton1**: dead/orphan 미이식.
- **bRealFlag 서버근거**: PlanDate index0 로 재현 — GET_SHIPMENT_PLAN_DETAIL 반환플래그 대조는 브라우저 축(확인필요).
