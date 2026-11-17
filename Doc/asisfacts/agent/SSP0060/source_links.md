# SSP0060 소스 링크 표

경로 약어:
- **M** = `06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs`
- **MD** = `06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.Designer.cs`
- **RP** = `06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs`
- **RPD** = `06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.Designer.cs`
- **CP** = `06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanConfirmDetailPopup.cs`
- **CPD** = `06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanConfirmDetailPopup.Designer.cs`

(링크는 AS-IS 소스 루트 기준 상대경로)

## 1. 엔드포인트 호출 지점 (55건, endpoints.csv 전수)

### 1-1. ConfirmDetailPopup (2건)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CP:37](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanConfirmDetailPopup.cs#L37) | `<field:dtFcstType>` | 37 | biz:CommonData.CommonDataList [LookupCommon] (unreached, FCST Type 콤보 소스) |
| [CP:312](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanConfirmDetailPopup.cs#L312) | FindDataMain | 312 | SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING |

### 1-2. RequestPopup (20건)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [RP:41](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L41) | `<field:dtFcstType>` | 41 | biz:CommonData.CommonDataList [LookupCommon] (unreached) |
| [RP:371](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L371) | FindData_Main | 371 | SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING |
| [RP:584](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L584) | SaveData | 584 | SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM |
| [RP:716](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L716) | ChkEngProcessing | 716 | SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| [RP:842](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L842) | GetErpIFCheck | 842 | SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK (unreached) |
| [RP:1044](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1044) | GetERPInterface | 1044 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| [RP:1072](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1072) | GetERPInterface | 1072 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| [RP:1181](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1181) | SoNo | 1181 | SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN |
| [RP:1253](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1253) | SoNo | 1253 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| [RP:1385](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1385) | NonSoNo | 1385 | SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN |
| [RP:1408](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1408) | NonSoNo | 1408 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C |
| [RP:1525](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1525) | GetErpIFCheckNew | 1525 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| [RP:1551](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1551) | GetErpIFCheckNew | 1551 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C |
| [RP:1582](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1582) | GetErpIFCheckNew | 1582 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C |
| [RP:1642](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1642) | GetErpIFCheckNew | 1642 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| [RP:1668](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1668) | GetErpIFCheckNew | 1668 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| [RP:1699](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1699) | GetErpIFCheckNew | 1699 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| [RP:1731](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1731) | ChkConfirmChangeTime | 1731 | SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE |
| [RP:1759](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1759) | GetErpSoNoCnt | 1759 | SSP.SSP0060_GET_ERP_SO_NO_CNT |
| [RP:1784](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L1784) | GetShipmentStatusChk | 1784 | SSP.SSP0060_GET_SHIPMENT_STATUS |

### 1-3. ShipmentPlan 메인 (33건)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [M:514](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L514) | SetChangedControl | 514 | SSP.SSP0060_GET_SHIPMENT_DIVISION |
| [M:1380](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L1380) | SpdDetail_EditChange | 1380 | biz:CommonData.CommonDataList [TransMode] |
| [M:1389](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L1389) | SpdDetail_EditChange | 1389 | biz:CommonData.CommonDataList [TransMode] |
| [M:1987](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L1987) | SpdDetail_CellClick | 1987 | biz:CommonData.CommonDataList [TransMode] |
| [M:3029](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L3029) | SaveData_Main | 3029 | SSP.SSP0060_SAVE_SHIPMENT_PLAN |
| [M:3286](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L3286) | SaveData_Detail | 3286 | SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM |
| [M:3460](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L3460) | SaveData_Detail | 3460 | SSP.SSP0060_SAVE_HOLD_STOCK_DATA (**NOT_IN_FOXQUERY**) |
| [M:3990](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L3990) | GetERPInterface | 3990 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| [M:4031](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4031) | GetERPInterface | 4031 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| [M:4159](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4159) | NonSoNo | 4159 | SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING |
| [M:4380](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4380) | SoNo | 4380 | SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING |
| [M:4481](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4481) | GetErpSoNoCnt | 4481 | SSP.SSP0060_GET_ERP_SO_NO_CNT |
| [M:4506](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4506) | GetShipmentStatusChk | 4506 | SSP.SSP0060_GET_SHIPMENT_STATUS |
| [M:4579](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4579) | GetErpIFCheck | 4579 | SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING (unreached) |
| [M:4657](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4657) | GetErpIFCheckNew | 4657 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| [M:4683](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4683) | GetErpIFCheckNew | 4683 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| [M:4713](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4713) | GetErpIFCheckNew | 4713 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| [M:4928](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L4928) | NewNonSoNo | 4928 | SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING (unreached) |
| [M:5042](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L5042) | GetErpIFCheckNew_ | 5042 | SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING (unreached) |
| [M:5206](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L5206) | GetBucketType | 5206 | DM.DM0003_GET_BUCKET_TYPE_CODE |
| [M:5287](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L5287) | FindData_Main | 5287 | SSP.SSP0060_GET_SHIPMENT_PLAN |
| [M:5656](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L5656) | FindData_Detail | 5656 | SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL |
| [M:5781](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L5781) | FindData_Stock_Detail | 5781 | SSP.SSP0060_GET_STOCK_LOCATION_DETAIL |
| [M:5882](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L5882) | FindData_oWMS_Detail | 5882 | SSP.SSP0060_GET_OWMS_DETAIL |
| [M:5977](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L5977) | FindData_Shipment_Result | 5977 | SSP.SSP0060_GET_SHIPMENT_RESULT |
| [M:6117](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L6117) | FindData_Shipment_Result | 6117 | SSP.SSP0060_GET_SHIPMENT_RESULT |
| [M:6225](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L6225) | FindData_hold_stock | 6225 | SSP.SSP0060_GET_HOLD_STOCK |
| [M:6328](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L6328) | FindData_MES_stock | 6328 | SSP.SSP0060_GET_MES_STOCK |
| [M:6432](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L6432) | FindData_MES_stock_Detail | 6432 | SSP.SSP0060_GET_MES_STOCK_DETAIL |
| [M:7149](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L7149) | GetNERPCode | 7149 | SSP.SSP0002_GET_NERP_CODE |
| [M:7449](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L7449) | GetSpdTitle | 7449 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN |
| [M:7962](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L7962) | ChkConfirmChangeTime | 7962 | SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| [M:8017](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L8017) | GetSSPUserCheck | 8017 | SSP.SSP0002_GET_USER_INFO_LIST |

### 1-4. 주석 처리됨
| 파일 | 줄 | 내용 |
|---|---:|---|
| [M:341](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L341) | 341 | SSP.SSP0046_GET_BUCKET_TYPE_CODE (주석 처리됨, 현행 아님) |

## 2. 이벤트 배선 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CPD:171](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanConfirmDetailPopup.Designer.cs#L171) | InitializeComponent | 171 | btnButtonList → btnButtonList_UsrButtonList_Click_Detected |
| [CP:123](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanConfirmDetailPopup.cs#L123) | .ctor | 123 | Load → Form_Load |
| [RPD:159](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.Designer.cs#L159) | InitializeComponent | 159 | usrButtonList1 → usrButtonList1_UsrButtonList_Click_Detected |
| [RPD:189](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.Designer.cs#L189) | InitializeComponent | 189 | btnAutoSet.Click → btnAutoSet_Click |
| [RPD:278](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.Designer.cs#L278) | InitializeComponent | 278–280 | spdMain ClipboardPasted/Change/KeyDown |
| [RPD:341](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.Designer.cs#L341) | InitializeComponent | 341 | FormClosing → SSP0060_ShipmentPlanRequestPopup_FormClosing |
| [RP:140](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L140) | .ctor | 140–141 | Load → Form_Load / Shown → SSP0060_ShipmentPlanRequestPopup_Shown |
| [MD:910](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.Designer.cs#L910) | InitializeComponent | 910–911 | spdMain KeyDown/KeyUp |
| [M:306](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L306) | .ctor | 306–307 | Load → Form_Load / Shown → SSP0060_ShipmentPlan_Shown |
| [M:955](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L955) | InitEvent | 955–989 | 메인 이벤트 배선 26건 (analysis.md §4) |
| [M:7196](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L7196) | clbCompanyID_SelectedIndexChanged | 7196/7200 | cboPlanDate 이벤트 해제/재연결 |

## 3. Grid 정의 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [CP:160](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanConfirmDetailPopup.cs#L160) | CreateSpread | 160 | AddSheet "Request Info" (헤더 2행) |
| [CP:178](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanConfirmDetailPopup.cs#L178) | InitSpread | 178–250 | Request Info 하드코딩 컬럼과 ColumnHeaderSpan |
| [RP:184](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L184) | CreateSpread | 184 | AddSheet "Request Info" |
| [RP:202](06.UIL/GSCM.SSP.Plan.UIL/Popup/SSP0060_ShipmentPlanRequestPopup.cs#L202) | InitSpread | 202–254 | Request Info 하드코딩 컬럼 (NEW_YN 포함) |
| [M:632](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L632) | InitSpread | 632/662/685/696/736/746/756 | SetSheetHeaderColumn (메타) |
| [M:640](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L640) | InitSpread | 640 | InitSpreadDateColumn |
| [M:626](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L626) | InitSpread | 626 | GetSpdTitle |
| [M:7254](06.UIL/GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs#L7254) | cboPlanDate_SelectedIndexChanged | 7254/7257 | GetSpdTitle / InitSpreadDateColumn |
