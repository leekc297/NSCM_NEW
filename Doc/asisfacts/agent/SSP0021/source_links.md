# SSP0021 소스 링크 (파일·줄 번호 기준)

> 경로는 AS-IS 소스 루트 기준 상대경로다(루트 경로는 Fact Pack에 없음 → 환경에 맞게 붙일 것).
> - **CS** = `06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs` (6583줄)
> - **DS** = `06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.Designer.cs` (1566줄)

## 1. 엔드포인트 호출 지점 (endpoints.csv 28행 전체)

| # | 파일 | 메서드 | 줄 | 내용 |
|---:|---|---|---:|---|
| 1 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L493) | SetChangedControl | 493 | `SSP.SSP0021_GET_SHIPMENT_DIVISION` (MATCH) |
| 2 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L2664) | SaveData_Detail | 2664 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` (MATCH) |
| 3 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L2822) | SaveData_Detail | 2822 | `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` (MATCH, ⚠ DB에 SP 없음) |
| 4 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L3352) | GetERPInterface | 3352 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| 5 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L3393) | GetERPInterface | 3393 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| 6 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L3521) | NonSoNo | 3521 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| 7 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L3742) | SoNo | 3742 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| 8 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L3843) | GetErpSoNoCnt | 3843 | `SSP.SSP0021_GET_ERP_SO_NO_CNT` |
| 9 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L3868) | GetShipmentStatusChk | 3868 | `SSP.SSP0021_GET_SHIPMENT_STATUS` |
| 10 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L3941) | GetErpIFCheck | 3941 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` (진입점 미연결) |
| 11 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L4019) | GetErpIFCheckNew | 4019 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| 12 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L4045) | GetErpIFCheckNew | 4045 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| 13 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L4075) | GetErpIFCheckNew | 4075 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| 14 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L4290) | NewNonSoNo | 4290 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` (진입점 미연결) |
| 15 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L4404) | GetErpIFCheckNew_ | 4404 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` (진입점 미연결) |
| 16 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L4513) | GetBucketType | 4513 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| 17 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L4598) | FindData_Main | 4598 | `SSP.SSP0021_GET_SHIPMENT_PLAN` |
| 18 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L4877) | FindData_Detail | 4877 | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` |
| 19 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L4990) | FindData_Stock_Detail | 4990 | `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL` |
| 20 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L5087) | FindData_oWMS_Detail | 5087 | `SSP.SSP0021_GET_OWMS_DETAIL` |
| 21 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L5180) | FindData_Shipment_Result | 5180 | `SSP.SSP0021_GET_SHIPMENT_RESULT` |
| 22 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L5283) | FindData_hold_stock | 5283 | `SSP.SSP0021_GET_HOLD_STOCK` |
| 23 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L5382) | FindData_MES_stock | 5382 | `SSP.SSP0021_GET_MES_STOCK` |
| 24 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L5482) | FindData_MES_stock_Detail | 5482 | `SSP.SSP0021_GET_MES_STOCK_DETAIL` |
| 25 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L5850) | GetSSPUserCheck | 5850 | `SSP.SSP0002_GET_USER_INFO_LIST` |
| 26 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L5916) | clbCompanyID_SelectedIndexChanged | 5916 | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` (NOT_IN_FOXQUERY) |
| 27 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L6063) | GetSpdTitle | 6063 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| 28 | [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L6561) | ChkConfirmChangeTime | 6561 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` |

### 1.1 주석 처리됨 (현행 아님)
| 파일 | 줄 | 내용 |
|---|---:|---|
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L320) | 320 | `SSP.SSP0046_GET_BUCKET_TYPE_CODE`: 주석 처리됨 |

## 2. 이벤트 배선 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L295) | .ctor | 295 | this.Load += Form_Load |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L912) | InitEvent | 912 | spdMain.TopChange += SpdMain_TopChange |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L913) | InitEvent | 913 | spdDetail.TopChange += SpdDetail_TopChange |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L915) | InitEvent | 915 | cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L916) | InitEvent | 916 | chkSum.CheckedChanged += chkSum_CheckedChanged |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L917) | InitEvent | 917 | btnMeasure.Click += BtnMeasure_Click |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L918) | InitEvent | 918 | btnItemId.Click += btnItemId_Click |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L919) | InitEvent | 919 | btnItemID2.Click += BtnItemID2_Click |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L920) | InitEvent | 920 | btnSearch.Click += BtnSearch_Click |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L921) | InitEvent | 921 | btnRequestor.Click += BtnRequestor_Click |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L922) | InitEvent | 922 | btnSimulation.Click += BtnSimulation_Click |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L924) | InitEvent | 924 | spdDetail.SheetTabClick += SpdDetail_SheetTabClick |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L925) | InitEvent | 925 | spdDetail.ActiveSheetChanged += SpdDetail_ActiveSheetChanged |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L926) | InitEvent | 926 | spdDetail.CellClick += SpdDetail_CellClick |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L927) | InitEvent | 927 | spdDetail.ComboSelChange += SpdDetail_ComboSelChange |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L928) | InitEvent | 928 | spdDetail.CellDoubleClick += SpdDetail_CellDoubleClick |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L929) | InitEvent | 929 | spdDetail.EditChange += SpdDetail_EditChange |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L930) | InitEvent | 930 | spdDetail.ClipboardPasted += SpdDetail_ClipboardPasted |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L932) | InitEvent | 932 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L933) | InitEvent | 933 | spdMain.Change += SpdMain_Change |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L935) | InitEvent | 935 | drpPeriod2.ValueChanged += DrpPeriod2_ValueChanged |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L937) | InitEvent | 937 | spdMain.ClipboardPasted += SpdMain_ClipboardPasted |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L939) | InitEvent | 939 | clbDivision_ID.SelectedIndexChanged += clbDivision_ID_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L940) | InitEvent | 940 | clbCompany_ID.SelectedIndexChanged += clbCompanyID_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L941) | InitEvent | 941 | cboPlanDate.SelectedIndexChanged += cboPlanDate_SelectedIndexChanged |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L944) | InitEvent | 944 | dsdm.Changed += shtDetail_Change |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L5933) | clbCompanyID_SelectedIndexChanged | 5933 | cboPlanDate.SelectedIndexChanged -= (일시 해제) |
| [CS](06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0021_ShipmentPlan.UIL/SSP0021_ShipmentPlan.cs#L5937) | clbCompanyID_SelectedIndexChanged | 5937 | cboPlanDate.SelectedIndexChanged += (재연결) |

## 3. 프레임워크 메타 소비 호출 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---|---|
| CS | SetChangeControl | 345, 350, 355, 360, 365, 370, 375, 380 | DataService.GetSSPInnerTable |
| CS | InitControls | 408, 419 | DataService.FP_Log2 |
| CS | SetChangedControl / InitSpread / SaveData_Detail / FindData_Main | 508 / 724 / 2530, 2784 / 4563, 4564, 4569, 4571 | CString.GetCheckedListValue |
| CS | InitSpread / cboPlanDate_SelectedIndexChanged | 604 / 5981 | SpreadInfo.GetSpdTitle |
| CS | InitSpread | 610, 634, 647, 658, 698, 708, 718 | SpreadInfo.SetSheetHeaderColumn |
| CS | InitSpread / cboPlanDate_SelectedIndexChanged | 617 / 5983 | InitSpreadDateColumn (화면 로컬 메서드) |

## 4. Grid 코드 정의 지점 (주요)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 544 | AddSheet spdMain "Shipment Plan" |
| CS | CreateSpread | 548, 549, 550, 556, 557, 559 | AddSheet spdDetail: Shipment Plan Detail / Stock Location Detail / oWMS Detail / MES Stock / MES Stock Detail / Shipment Result |
| CS | InitSpread | 627 | Shipment Plan MergePolicy.Always |
| CS | InitSpread | 727 | Shipment Result CHILD_QTY Width 75 (division 82) |
| CS | InitSpreadDateColumn | 862, 866, 870, 877~906 | 날짜 컬럼 DB 루프, 주말 색상, 헤더 Span |
| CS | SpdDetail_CellClick | 1802, 1837, 1841 | 헤더 체크박스 Value 토글 |
| CS | BtnMeasure_Click | 1925~1927 | GetSheetInfo(spdDetail Sheets[0..2]) |
| CS | SpdMain_CellDoubleClick | 2059~2094 | 상세 시트 전환(ChangeSheet/ChangeActiveSheet) |
| CS | SpdDetail_SheetTabClick | 2138~2154 | 탭 인덱스 0·1·2·5 시트 전환 |
| CS | EditButton | 2461 | GetSheetInfo(spdDetail, ActiveSheetIndex) |
| CS | cboBucketType_SelectedIndexChanged / chkSum_CheckedChanged | 4451 / 4456 | SetSpreadColumn 호출 |
| CS | SetSpreadColumn | 4469~4501 | D_/W_/M_ 컬럼 Visible 전환 |
| CS | FindData_Main | 4558~4560, 4633 | GetSheetInfo(Sheets[0..2]), SetSpreadColumn |

## 5. Designer 주요 속성 지점
| 파일 | 줄 | 대상 | 속성 = 값 |
|---|---:|---|---|
| DS | 175 / 178 / 180 | usrConditionPanel1 | Dock=Top / Size(1689,73) / UsrPanelType=HidePanel |
| DS | 197 / 204 | usrLayoutControl2 | Dock=Top / Size(1689,77) |
| DS | 240 | chkSql | Text="Show SQL" |
| DS | 275 | btnSimulation | Text="Simulation" |
| DS | 345 | chkSum | Text="Sum" |
| DS | 471 | drpPeriod | Enabled=false |
| DS | 670 | layoutControlItem7 (clbPlantSite) | Text="From Site" |
| DS | 717 | lblCombo1 (clbDivision_ID) | Text="Division*" |
| DS | 742 | lblItemId (txtItemId) | Text="Model" |
| DS | 757 | layoutControlItem1 (clbCompany_ID) | Text="Company*" |
| DS | 769 | layoutControlItem6 (drpPeriod) | Text="Period*" |
| DS | 784 | PlanDate (cboPlanDate) | Text="Plan-date*" |
| DS | 809 | lblBucket (cboBucketType) | Text="Bucket" |
| DS | 834 / 839 | spdMain | Dock=Fill / Size(1689,303) |
| DS | 887 / 890 / 901 / 902 | splitContainer1 | Dock=Fill / Orientation=Horizontal / Size(1689,576) / SplitterDistance=303 |
| DS | 908 / 913 | spdDetail | Dock=Fill / Size(1689,229) |
| DS | 968 / 973 | usrLayoutControl3 | Dock=Top / Size(1689,40) |
| DS | 1056 | btnSearch | Text="Search" |
| DS | 1313 | layoutControlItem11 (drpPeriod2) | Text="Shipment Date" |
| DS | 1353 | layoutControlItem5 (btnItemID2) | Text="layoutControlItem2" |
| DS | 1379 | layoutControlItem4 (txtModel2) | Text="Model" |
| DS | 1391 | layoutControlItem13 (drpPeriod3) | Text="Shipment Date" |
