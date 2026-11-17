# SSP0200 소스 링크 표

**파일 약어**
| 약어 | 경로 |
|---|---|
| M | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0200_ShipmentChangeRequest.UIL\SSP0200_ShipmentChangeRequest.cs` |
| D | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0200_ShipmentChangeRequest.UIL\SSP0200_ShipmentChangeRequest.Designer.cs` |
| P | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0200_ShipmentChangeRequestInsertPopup.cs` |
| PD | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0200_ShipmentChangeRequestInsertPopup.Designer.cs` |

## 1. 엔드포인트 호출 지점 (현행 25건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | SaveButton | 862 | `SSP.SSP0200_GET_CHANGE_REQ_NO` |
| M | SaveButton | 1056 | `SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW` |
| M | FindData_Main | 1529 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST` |
| M | FindData_Main_Nonasync | 1650 | `SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N` |
| M | FindData_Sub_Draft | 2029 | `SSP.SSP0200_GET_SHIPMENT_REQUEST_DRAFTING` |
| M | SaveDataDrafting | 2463 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE` |
| M | DeleteDataDrafting | 2620 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| M | GetDayRange | 3129 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| M | GetERPInterface | 3950 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| M | GetERPInterface | 3989 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| M | GetShipmentStatusChk | 4096 | `SSP.SSP0200_GET_SHIPMENT_STATUS` |
| M | GetErpSoNoCnt | 4161 | `SSP.SSP0200_GET_ERP_SO_NO_CNT` |
| M | NewNonSoNo | 4297 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| M | NonSoNo | 4491 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| M | SoNo | 4771 | `SSP.SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| M | GetErpIFCheck | 4928 | `SSP.SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| M | GetErpIFCheckNew | 5009 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| M | GetErpIFSeqMerge | 5067 | `SSP.PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE` |
| M | SpdMain_CellClick | 5466 | `biz:CommonData.CommonDataList` [code=TransMode] (Data.Common → Data.CallBizCommonData) |
| M | FindData_BOD | 6711 | `SSP.SSP0026_GET_BOD_ITEM` |
| M | FindData_BOD | 6731 | `biz:CommonData.CommonDataList` [code=TransMode] |
| M | GetItemFromBOD | 6756 | `SSP.SSP0200_GET_ITEM_FROM_BOD` |
| M | GetDivision | 6781 | `SSP.SSP0200_GET_SHIPMENT_DIVISION` |
| M | GetShipmentPlanPlantSite | 6798 | `SSP.SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE` (NOT_IN_FOXQUERY) |
| M | GetPlantSiteByDivisionEEOperation | 6812 | `SSP.SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION` (NOT_IN_FOXQUERY) |

## 2. 주석 처리된 호출 (참고용, 현행 아님)
| 파일 | 줄 | 내용 |
|---|---:|---|
| M | 1343 | SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW — 주석 처리됨 |
| M | 1486 | SSP.SSP0200_GET_SHIPMENT_CHANGE_REQUEST — 주석 처리됨 |
| M | 1794 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING — 주석 처리됨 |
| M | 2170 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING — 주석 처리됨 |
| M | 3128 | SCP.GET_DATE_RANGE_1MONTH — 주석 처리됨 |
| M | 6826 | SSP.SSP0200_GET_SHIPMENT_PLAN_TO_SITE — 주석 처리됨 |

## 3. 이벤트 배선
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| D | InitializeComponent | 322 | btnInsertMultiple.Click += btnInsertMultiple_Click |
| M | .ctor | 310 | this.Load += Form_Load |
| M | InitEvent | 383 | clbDivision_ID.SelectedIndexChanged += clbDivision_ID_SelectedIndexChanged |
| M | InitEvent | 384 | spdMain.TopChange += SpdMain_TopChange |
| M | InitEvent | 385 | btnApprovalUser.Click += BtnApprovalUser_Click |
| M | InitEvent | 388 | dsdm.Changed += shtMain_Change |
| M | InitEvent | 393 | btnSave.Click += BtnSave_Click |
| M | InitEvent | 395 | btnChangeRe2.Click += BtnChangeRe_Click |
| M | InitEvent | 398 | btnCancel.Click += BtnCancel_Click |
| M | InitEvent | 399 | btnNew.Click += BtnNew_Click |
| M | InitEvent | 401 | spdMain.CellClick += SpdMain_CellClick |
| M | InitEvent | 402 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| M | InitEvent | 403 | spdMain.EditChange += SpdMain_EditChange |
| M | InitEvent | 404 | spdMain.ClipboardPasted += SpdMain_ClipboardPasted |
| M | InitEvent | 405 | spdMain.ComboSelChange += SpdMain_ComboSelChange |
| M | InitEvent | 406 | btnItemId.Click += btnItemId_Click |
| M | InitEvent | 408 | cboChangeType.SelectedIndexChanged += CboChangeType_SelectedIndexChanged |
| M | InitEvent | 410 | spdMain.CursorChanged += SpdMain_CursorChanged |
| PD | InitializeComponent | 228 | btnButtonList.UsrButtonList_Click_Detected += btnButtonList_UsrButtonList_Click_Detected |
| P | .ctor | 49 | this.Load += Form_Load |

## 4. Grid 구성 코드
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | CreateSpread | 573 | AddSheet(spdMain, "Shipment Change Request", 1, 1, 30) |
| M | CreateSpread | 577 | AddSheet(spdSub, "Change Request", 2, 1, 30) |
| M | CreateSpread | 587 | ChangeSheet |
| M | InitSpread | 598 | SetSheetHeaderColumn(spreadInfo, 1) — Shipment Change Request |
| M | InitSpread | 607–608 / 618–619 | ChangeType "P" ↔ 그 외: ERP_SO_NO·CONFIRM_ID Width 0 / 100·120 |
| M | InitSpread | 630–648 | Division 40/EE 분기: END_CUSTOMER·ERP_ATTR1~3 ↔ PROJECT_CODE·PROJECT_NAME |
| M | InitSpread | 659 | SetSheetHeaderColumn(spreadInfo, 2) — Change Request |
| M | InitSpread | 672–674 | CHK CellType=CheckBox, Value=false, Border |
| M | InitSpread | 696 | REMARKS Width=0 |
| M | InitSpread | 701–718 | "P": ERP_SO_NO 숨김, Header Span "Plan"/"Confirm" + 하위 라벨 |
| M | InitSpread | 723–740 | 그 외: ERP_SO_NO 표시, Header Span "Confirmed"/"Change" + 하위 라벨 |
| M | SetChangeRequestSOGrid | 2268 / 2275 / 2294 | spdSub 행 루프: 숨김 처리, CHK 숨김(sSearchType=="Exist") |
| M | InsertRow | 2728 / 2729 / 2765 | 콤보: FROM_SITE_DESCRIPTION / TO_SITE_DESCRIPTION / DIVISION_ID |
| M | InsertRowMultiple | 2854 / 2855 / 2891 | 위와 동일 (다건) |
| M | BtnNew_Click | 3381 / 3415 / 3416 / 3422 | DIVISION_ID / FROM_SITE / TO_SITE 콤보 |
| M | SpdMain_CellClick | 5468 | TRANSPORT_MODE 콤보 = Data.Common(TransMode) |
| M | SpdMain_CellClick | 5505 / 5540 / 5544 | 헤더 CheckBox 전체 선택/해제 |
| M | SpdMain_ComboSelChange | 5668–5679 | 행 Division 40/EE: END_CUSTOMER ↔ PROJECT_CODE/NAME |

## 5. 메타·데이터 컬럼 읽기 (주요)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| M | SetChangeControl | 334–335 | Filter GROUP_ID(NowGroupID), USER_ID |
| M | SetChangeControl | 341–372 | DataService.GetSSPInnerTable (7회) |
| M | InitControls | 442 / 451 | DataService.FP_Log2 |
| M | InitControls | 481 / 530–533 | CODE / dtShipmentInputPeriod VALUE·Diff_VALUE |
| M | SetChangedControl | 545 / 554 / 562 | GetCheckedListValue, ATTRIBUTE1, NowGroupID |
| M | SaveButton | 877 / 1138–1158 | GetCheckedListValue / reason_id·division_id·to_site |
| M | FindData_Main | 1466–1473 / 1562–1563 | GetCheckedListValue / ITEM_ID·OPERATION_GROUP |
| M | FindData_Main_Nonasync | 1627 | GetCheckedListValue |
| M | FindData_Sub_Draft | 2074–2084 | USER_ID·DEPT_ID·USER_NAME·DEPT_NAME_KO·USER_NAME_EN·DEPT_NAME_EN |
| M | SetChangeRequestInfo | 2219–2230 | CHANGE_REQ_NO … APPROVAL_DEPT_NAME (12컬럼) |
| M | SaveDataDrafting | 2521 | NowGroupID |
| M | chkERPIFBlockYn | 2950 / 2959 | BLOCK_YN / PERIOD |
| M | SSP_Main_Validation | 3609–3617 / 3659–3664 / 3734–3739 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks |
| M | GetShipmentStatusChk | 4110 / 4124 / 4139 | Tables[0..2] CONFIRM_ID |
| M | GetErpSoNoCnt | 4171 | CNT |
| M | NonSoNo | 4567–4587 | reason_id·division_id·to_site |
| M | SoNo | 4846–4853 | reason_id·division_id·to_site |
