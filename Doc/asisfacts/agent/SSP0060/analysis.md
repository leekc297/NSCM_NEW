# SSP0060 As-is 분석서 (Shipment Plan)

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0060)만 사용했습니다. Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.
> 정적 추출 결과이므로 런타임 분기의 실제 실행 여부는 따로 확인해야 합니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0060 |
| 도메인 | SSP (프로젝트 `06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj`) |
| 메인 Form | `SSP0060_ShipmentPlan` |
| 팝업 1 | `SSP0060_ShipmentPlanRequestPopup`, Form Text `"Shipment Request Popup"` |
| 팝업 2 | `SSP0060_ShipmentPlanConfirmDetailPopup`, Form Text `"Request Info Popup"` |
| 메뉴/프로그램 메타 | TB_FX_ProgramInfo 1행, TB_FX_MenuItemInfo 1행, TB_FX_GroupMenuAuth 13행, TB_FX_Favorite 1행 (행 내용은 Fact Pack에 없어 확인 필요) |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0060_ShipmentPlan.cs | 8037 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0060_ShipmentPlan.Designer.cs | 1766 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0060_ShipmentPlanRequestPopup.cs | 2029 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0060_ShipmentPlanRequestPopup.Designer.cs | 388 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0060_ShipmentPlanConfirmDetailPopup.cs | 365 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0060_ShipmentPlanConfirmDetailPopup.Designer.cs | 556 |
| shared | 없음 (Fact Pack 미기재) | – |
| legacy | 없음 (모든 파일 variant = `only`) | – |

- 메인 화면에서 두 팝업을 여는 호출 지점(`new SSP0060_ShipmentPlanRequestPopup` 등)은 Fact Pack에 없습니다. **확인 필요**

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

### 2-1. 메인 `SSP0060_ShipmentPlan`

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 |
|---|---|---:|---|---|
| event `this.Load` | Form_Load > InitControls > SetChangedControl | 514 | `SSP.SSP0060_GET_SHIPMENT_DIVISION` | MATCH |
| event `this.Load` | Form_Load > InitControls > GetBucketType | 5206 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH |
| event `this.Load` | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 7449 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| button `FindButton` | FindButton > FindData_Main | 5287 | `SSP.SSP0060_GET_SHIPMENT_PLAN` | MATCH |
| button `FindButton` | FindButton > FindData_Main > InitSpread > GetSpdTitle | 7449 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| button `SaveButton` | SaveButton > SaveData_Main | 3029 | `SSP.SSP0060_SAVE_SHIPMENT_PLAN` | MATCH |
| button `SaveButton` | SaveButton > SaveData_Detail | 3286 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| button `SaveButton` | SaveButton > SaveData_Detail | 3460 | `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` | **NOT_IN_FOXQUERY** |
| button `SaveButton` | SaveData_Detail > GetERPInterface | 3990 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH |
| button `SaveButton` | SaveData_Detail > GetERPInterface | 4031 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH |
| button `SaveButton` | SaveData_Detail > GetERPInterface > NonSoNo | 4159 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| button `SaveButton` | SaveData_Detail > GetERPInterface > SoNo | 4380 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| button `SaveButton` | SaveData_Detail > GetERPInterface > GetErpSoNoCnt | 4481 | `SSP.SSP0060_GET_ERP_SO_NO_CNT` | MATCH |
| button `SaveButton` | SaveData_Detail > GetERPInterface > GetShipmentStatusChk | 4506 | `SSP.SSP0060_GET_SHIPMENT_STATUS` | MATCH |
| button `SaveButton` | SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4657 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH |
| button `SaveButton` | SaveData_Detail > GetERPInterface > SoNo > GetErpIFCheckNew | 4683, 4713 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH |
| button `SaveButton` | SaveData_Detail > GetERPInterface > ChkConfirmChangeTime | 7962 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | MATCH |
| button `SaveButton` | SaveData_Detail > FindData_Main / FindData_Detail / FindData_hold_stock | 5287 / 5656 / 6225 | `SSP.SSP0060_GET_SHIPMENT_PLAN` / `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` / `SSP.SSP0060_GET_HOLD_STOCK` | MATCH |
| button `SaveButton` | SaveData_Detail > FindData_hold_stock > InitSpread > GetSpdTitle | 7449 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| button `EditButton` | EditButton > GetSSPUserCheck | 8017 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH |
| event `clbDivision_ID.SelectedIndexChanged` | clbDivision_ID_SelectedIndexChanged > GetNERPCode | 7149 | `SSP.SSP0002_GET_NERP_CODE` | MATCH |
| event `clbCompany_ID.SelectedIndexChanged` | clbCompanyID_SelectedIndexChanged > InitSpread > GetSpdTitle | 7449 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| event `cboPlanDate.SelectedIndexChanged` | cboPlanDate_SelectedIndexChanged > GetSpdTitle | 7449 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| event `chkTotPSI.CheckedChanged` | chkTotPSI_CheckedChanged > FindData_Main (> InitSpread > GetSpdTitle) | 5287 / 7449 | `SSP.SSP0060_GET_SHIPMENT_PLAN`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| event `btnMeasure.Click` | BtnMeasure_Click > InitSpread > GetSpdTitle | 7449 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| event `btnSearch.Click` / `spdMain.CellDoubleClick` | BtnSearch_Click / SpdMain_CellDoubleClick > FindData_Detail | 5656 | `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` | MATCH |
| 〃 | > FindData_Stock_Detail | 5781 | `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL` | MATCH |
| 〃 | > FindData_oWMS_Detail | 5882 | `SSP.SSP0060_GET_OWMS_DETAIL` | MATCH |
| 〃 | > FindData_Shipment_Result (2곳) | 5977, 6117 | `SSP.SSP0060_GET_SHIPMENT_RESULT` | MATCH |
| 〃 | > FindData_Shipment_Result > InitSpread > GetSpdTitle | 7449 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 〃 | > FindData_MES_stock | 6328 | `SSP.SSP0060_GET_MES_STOCK` | MATCH |
| 〃 | > FindData_MES_stock_Detail | 6432 | `SSP.SSP0060_GET_MES_STOCK_DETAIL` | MATCH |
| `SpdMain_CellDoubleClick` 전용 | SpdMain_CellDoubleClick > FindData_hold_stock | 6225 | `SSP.SSP0060_GET_HOLD_STOCK` | MATCH |
| event `spdDetail.EditChange` | SpdDetail_EditChange | 1380, 1389 | `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH |
| event `spdDetail.CellClick` | SpdDetail_CellClick | 1987 | `biz:CommonData.CommonDataList` [code=TransMode] | BIZ_MATCH |

**진입점에 연결되지 않은 호출(unreached).** 주석 처리된 코드는 아닙니다. 다만 정적 분석으로는 어떤 진입점에서도 도달하지 않습니다.

| 메서드 | 줄 | 엔드포인트 |
|---|---:|---|
| GetErpIFCheck | 4579 | `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` |
| NewNonSoNo | 4928 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` |
| GetErpIFCheckNew_ | 5042 | `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` |

### 2-2. 팝업 `SSP0060_ShipmentPlanRequestPopup`

진입점은 `SaveButton`과 `usrButtonList1_UsrButtonList_Click_Detected` 두 가지이며, 둘 다 아래 SaveData 경로를 그대로 탑니다.

| 경로 | 줄 | 엔드포인트 |
|---|---:|---|
| Form_Load / FindButton > FindData_Main | 371 | `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| SaveData | 584 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` |
| SaveData > ChkEngProcessing | 716 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| SaveData > GetERPInterface | 1044 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` |
| SaveData > GetERPInterface | 1072 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| SaveData > GetERPInterface > SoNo | 1181 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN` |
| SaveData > GetERPInterface > SoNo | 1253 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| SaveData > GetERPInterface > NonSoNo | 1385 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN` |
| SaveData > GetERPInterface > NonSoNo | 1408 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` |
| SoNo > GetErpIFCheckNew | 1525, 1642 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` |
| SoNo > GetErpIFCheckNew | 1551, 1582 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` |
| SoNo > GetErpIFCheckNew | 1668, 1699 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| GetERPInterface > ChkConfirmChangeTime | 1731 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE` |
| GetERPInterface > GetErpSoNoCnt | 1759 | `SSP.SSP0060_GET_ERP_SO_NO_CNT` |
| GetERPInterface > GetShipmentStatusChk | 1784 | `SSP.SSP0060_GET_SHIPMENT_STATUS` |
| unreached: GetErpIFCheck | 842 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` |
| unreached: `<field:dtFcstType>` | 41 | `biz:CommonData.CommonDataList` [code=LookupCommon] |

### 2-3. 팝업 `SSP0060_ShipmentPlanConfirmDetailPopup`

| 경로 | 줄 | 엔드포인트 |
|---|---:|---|
| Form_Load / FindButton > FindDataMain | 312 | `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` |
| unreached: `<field:dtFcstType>` | 37 | `biz:CommonData.CommonDataList` [code=LookupCommon] |

- `<field:dtFcstType>`는 필드 초기화식입니다. grid_code에서 `FCST Type` 콤보 컬럼의 데이터 소스로 `Data.Common(Data.Type.LookupCommon, false, "SALES_TYPE_CODE")`가 쓰이므로, 진입점 미연결로 표시됐어도 실제로는 Request Info 시트 콤보에 사용됩니다.

### 2-4. 주석 처리됨 (현행 기능 아님)
- `SSP0060_ShipmentPlan.cs:341`의 `SSP.SSP0046_GET_BUCKET_TYPE_CODE`는 **주석 처리됨**이며 활성 집계에서 제외했습니다.

## 3. 엔드포인트 전체 표 (31종)

| # | 엔드포인트 | 상태 | 호출 수 | SP | 주요 참조/쓰기 객체 |
|---:|---|---|---:|---|---|
| 1 | `biz:CommonData.CommonDataList` [LookupCommon] | BIZ_MATCH | 2 | (UP_FX_GetCommonDataList 코드분기) | SELECT SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| 1' | `biz:CommonData.CommonDataList` [TransMode] | BIZ_MATCH | 3 | (UP_FX_GetCommonDataList 코드분기) | SELECT SCP_MST_BOD_V |
| 2 | `SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | MATCH | 2 | SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_FINAL_ITEM, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_PROJECT, SCM_MST_ITEM_SN, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER |
| 3 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH | 2 | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM | INSERT SSP_ANL_SHIP_CONFIRM / _H, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN, SSP_MST_SEND_MAIL_REQ; UPDATE SSP_ANL_SHIP_CONFIRM(_CHG_REQ_DE); EXEC PR_SSP_ANL_SHIP_CONFIRM_HIST 외 (oracle_migration.md §1 참조) |
| 4 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | MATCH | 1 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL |
| 5 | `SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` | MATCH (unreached) | 1 | SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN; EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER |
| 6 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH | 2 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM; UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE) |
| 7 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH | 5 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | DELETE/UPDATE SSP_ANL_SHIP_CONFIRM; INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN; #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 |
| 8 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN` | MATCH | 2 | SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE) |
| 9 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH | 5 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN; UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| 10 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` | MATCH | 3 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN; UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| 11 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE` | MATCH | 1 | SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE | SELECT SSP_ANL_SHIP_CONFIRM |
| 12 | `SSP.SSP0060_GET_ERP_SO_NO_CNT` | MATCH | 2 | SSP0060_GET_ERP_SO_NO_CNT | SELECT SSP_ANL_SHIP_CONFIRM |
| 13 | `SSP.SSP0060_GET_SHIPMENT_STATUS` | MATCH | 2 | SSP0060_GET_SHIPMENT_STATUS | SELECT SSP_ANL_SHIP_CONFIRM, REF STRING_SPLIT |
| 14 | `SSP.SSP0060_GET_SHIPMENT_DIVISION` | MATCH | 1 | SSP0060_GET_SHIPMENT_DIVISION | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_CODE_LOOKUP_VALUE, #RETURNTABLE |
| 15 | `SSP.SSP0060_SAVE_SHIPMENT_PLAN` | MATCH | 1 | SSP0060_SAVE_SHIPMENT_PLAN | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE; SELECT SCP_MST_SHIPMENT_LOT_SIZE, SSP_MST_PARTIAL_SEQ 외 |
| 16 | `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` | **NOT_IN_FOXQUERY** | 1 | 없음 | DB에도 없음 (폐기 또는 오타 가능), 확인 필요 |
| 17 | `SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 3 | SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ / _DE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN; EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| 18 | `SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH (unreached) | 2 | SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE) |
| 19 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL |
| 20 | `SSP.SSP0060_GET_SHIPMENT_PLAN` | MATCH | 1 | SSP0060_GET_SHIPMENT_PLAN | 동적 SQL, # 임시테이블 다수, SCM_MST_TITLESET_USER, SCM_MST_SHEET_MEASURE, SSP_ANL_SHIP_CONFIRM, DM_PLN_SHIPMENT_REQ 외, EXEC SSP0060_GET_SHIPMENT_PSI_COMMENTS |
| 21 | `SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL` | MATCH | 1 | SSP0060_GET_SHIPMENT_PLAN_DETAIL | 동적 SQL, FN_GET_IN_STR, FN_SCM_SPLIT |
| 22 | `SSP.SSP0060_GET_STOCK_LOCATION_DETAIL` | MATCH | 1 | SSP0060_GET_STOCK_LOCATION_DETAIL | SSP_MST_LOCATION_V, SSP_DNM_STOCK_C, SSP_DNM_ESS_PACKER_STOCK_V, SCM_MST_SLOC 외 |
| 23 | `SSP.SSP0060_GET_OWMS_DETAIL` | MATCH | 1 | SSP0060_GET_OWMS_DETAIL | SSP_ANL_OWMS_STOCK_C2, SCM_MST_SLOC, SSP_MST_MODEL_USER 외 |
| 24 | `SSP.SSP0060_GET_SHIPMENT_RESULT` | MATCH | 2 | SSP0060_GET_SHIPMENT_RESULT | SCM_DNM_EXFACTORY_RESULT, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS 외 |
| 25 | `SSP.SSP0060_GET_HOLD_STOCK` | MATCH | 1 | SSP0060_GET_HOLD_STOCK | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER 외 |
| 26 | `SSP.SSP0060_GET_MES_STOCK` | MATCH | 1 | SSP0060_GET_MES_STOCK | SSP_DNM_GMES_STOCK_81_82, SCP_MST_FINAL_ITEM |
| 27 | `SSP.SSP0060_GET_MES_STOCK_DETAIL` | MATCH | 1 | SSP0060_GET_MES_STOCK_DETAIL | SSP_DNM_GMES_STOCK_81_82, SCP_MST_FINAL_ITEM |
| 28 | `SSP.SSP0002_GET_NERP_CODE` | MATCH | 1 | SSP0002_GET_NERP_CODE | SCM_CODE_LOOKUP_VALUE |
| 29 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M |
| 30 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | MATCH | 1 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| 31 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | 1 | SSP0002_GET_USER_INFO_LIST | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION |

- 주석 처리됨: `SSP.SSP0046_GET_BUCKET_TYPE_CODE` (`SSP0060_ShipmentPlan.cs:341`), 현행 기능 아님

## 4. 이벤트 배선 표

| 클래스 | 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|---|
| ConfirmDetailPopup | this.btnButtonList | UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | Designer InitializeComponent:171 |
| ConfirmDetailPopup | this | Load | `Form_Load` | .ctor:123 |
| RequestPopup | this.usrButtonList1 | UsrButtonList_Click_Detected | `usrButtonList1_UsrButtonList_Click_Detected` | Designer:159 |
| RequestPopup | this.btnAutoSet | Click | `btnAutoSet_Click` | Designer:189 |
| RequestPopup | this.spdMain | ClipboardPasted | `spdMain_ClipboardPasted` | Designer:278 |
| RequestPopup | this.spdMain | Change | `spdMain_Change` | Designer:279 |
| RequestPopup | this.spdMain | KeyDown | `spdMain_KeyDown` | Designer:280 |
| RequestPopup | this | FormClosing | `SSP0060_ShipmentPlanRequestPopup_FormClosing` | Designer:341 |
| RequestPopup | this | Load | `Form_Load` | .ctor:140 |
| RequestPopup | this | Shown | `SSP0060_ShipmentPlanRequestPopup_Shown` | .ctor:141 |
| ShipmentPlan | this.spdMain | KeyDown | `spdMain_KeyDown` | Designer:910 |
| ShipmentPlan | this.spdMain | KeyUp | `spdMain_KeyUp` | Designer:911 |
| ShipmentPlan | this | Load | `Form_Load` | .ctor:306 |
| ShipmentPlan | this | Shown | `SSP0060_ShipmentPlan_Shown` | .ctor:307 |
| ShipmentPlan | this.spdMain | TopChange | `SpdMain_TopChange` | InitEvent:955 |
| ShipmentPlan | this.spdDetail | TopChange | `SpdDetail_TopChange` | InitEvent:956 |
| ShipmentPlan | this.cboBucketType | SelectedIndexChanged | `cboBucketType_SelectedIndexChanged` | InitEvent:958 |
| ShipmentPlan | this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitEvent:959 |
| ShipmentPlan | this.chkTotPSI | CheckedChanged | `chkTotPSI_CheckedChanged` | InitEvent:960 |
| ShipmentPlan | this.btnMeasure | Click | `BtnMeasure_Click` | InitEvent:961 |
| ShipmentPlan | this.btnItemId | Click | `btnItemId_Click` | InitEvent:962 |
| ShipmentPlan | this.btnItemID2 | Click | `BtnItemID2_Click` | InitEvent:963 |
| ShipmentPlan | this.btnSearch | Click | `BtnSearch_Click` | InitEvent:964 |
| ShipmentPlan | this.btnNew | Click | `BtnNew_Click` | InitEvent:965 |
| ShipmentPlan | this.btnRequestor | Click | `BtnRequestor_Click` | InitEvent:966 |
| ShipmentPlan | this.btnSimulation | Click | `BtnSimulation_Click` | InitEvent:967 |
| ShipmentPlan | this.spdDetail | SheetTabClick | `SpdDetail_SheetTabClick` | InitEvent:969 |
| ShipmentPlan | this.spdDetail | ActiveSheetChanged | `SpdDetail_ActiveSheetChanged` | InitEvent:970 |
| ShipmentPlan | this.spdDetail | CellClick | `SpdDetail_CellClick` | InitEvent:971 |
| ShipmentPlan | this.spdDetail | ComboSelChange | `SpdDetail_ComboSelChange` | InitEvent:972 |
| ShipmentPlan | this.spdDetail | CellDoubleClick | `SpdDetail_CellDoubleClick` | InitEvent:973 |
| ShipmentPlan | this.spdDetail | EditChange | `SpdDetail_EditChange` | InitEvent:974 |
| ShipmentPlan | this.spdDetail | ClipboardPasted | `SpdDetail_ClipboardPasted` | InitEvent:975 |
| ShipmentPlan | this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:977 |
| ShipmentPlan | this.spdMain | Change | `SpdMain_Change` | InitEvent:978 |
| ShipmentPlan | this.drpPeriod2 | ValueChanged | `DrpPeriod2_ValueChanged` | InitEvent:980 |
| ShipmentPlan | this.spdMain | ClipboardPasted | `SpdMain_ClipboardPasted` | InitEvent:982 |
| ShipmentPlan | clbDivision_ID | SelectedIndexChanged | `clbDivision_ID_SelectedIndexChanged` | InitEvent:984 |
| ShipmentPlan | clbCompany_ID | SelectedIndexChanged | `clbCompanyID_SelectedIndexChanged` | InitEvent:985 |
| ShipmentPlan | cboPlanDate | SelectedIndexChanged | `cboPlanDate_SelectedIndexChanged` | InitEvent:986 |
| ShipmentPlan | dsdm | Changed | `shtDetail_Change` | InitEvent:989 |
| ShipmentPlan | cboPlanDate | SelectedIndexChanged (`-=`) | `cboPlanDate_SelectedIndexChanged` | clbCompanyID_SelectedIndexChanged:7196 |
| ShipmentPlan | cboPlanDate | SelectedIndexChanged (`+=`) | `cboPlanDate_SelectedIndexChanged` | clbCompanyID_SelectedIndexChanged:7200 |

- 메인 화면 `spdMain`은 Designer에서 `spdMain_KeyDown`과 `spdMain_KeyUp`(소문자 s)을, InitEvent에서 `SpdMain_*`(대문자 S)를 따로 배선합니다. 서로 다른 핸들러입니다.
- `clbCompanyID_SelectedIndexChanged`는 `cboPlanDate` 이벤트를 잠시 해제(7196)했다가 다시 연결(7200)합니다. 연쇄 발생을 막기 위한 처리입니다.

## 5. Grid 구성 방식

**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)`**

| 축 | 내용 |
|---|---|
| META(프레임워크) | `SetSheetHeaderColumn`이 SCM_MST_SHEET_COLUMNS(196행)의 COLUMN_NAME, COLUMN_LABEL_NAME, VISIBLE_FLAG, VALID_YN, COLUMN_WIDTH, FIXED_FLAG, CELL_CONTROL_OBJECT_TYPE_CODE 등을 읽어 시트를 구성합니다. 호출 지점은 InitSpread:632/662/685/696/736/746/756입니다. |
| DB 루프(코드) | 화면이 직접 정의한 `InitSpreadDateColumn`과 `SetSpreadColumn`이 날짜 컬럼과 `EDIT_YN_{sColumnName.Replace("D_","")}` 컬럼(헤더 `E{COLUMN_LABEL_NAME}`)을 루프로 추가합니다. 날짜 축은 `SCP0009_GET_SHEET_CALENDAR_3SPAN`(GetSpdTitle:7449)에서 가져옵니다. |
| MEASURE | SCM_MST_SHEET_MEASURE 20행 중 Shipment Plan 시트는 필수+기본 14, 선택 6입니다. 사용자 타이틀셋은 SCM_MST_TITLESET_USER 140행이며, SP `SSP0060_GET_SHIPMENT_PLAN`이 직접 읽습니다. |
| HARDCODED | Request Info 시트(두 팝업)는 메타 없이 `AddTextColumn`, `AddComboColumn`, `AddDateColumn`, `AddNumColumn`으로 전부 하드코딩되어 있습니다. |
| 표시/라벨 변경 | Designer의 ColumnHeader 스타일(`HorizontalAlignment=General`, `NoteIndicatorColor=Red`, `Parent=ColumnHeaderDefaultEnhanced`), `ColumnHeaderSpan`의 `Confirmed`와 `Change` 2단 헤더 |

시트 목록(메타 기준): Hold stock, Hold stock Detail, MES Stock, MES Stock Detail, oWMS Detail, Shipment Plan, Shipment Plan Detail, Shipment Result, Stock Location Detail. 코드 전용 시트는 Request Info입니다.

### 5-1. Division별 차이
- grid_rule과 grid_effective 기준으로는 14개 Division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 **컬럼 구성이 같습니다**. 메타에 DIVISION_ID별 행이 없습니다.
- 코드에서 Division에 따라 갈리는 처리는 `clbDivision_ID_SelectedIndexChanged > GetNERPCode`(SEGMENT2 조회)와 `SetChangedControl`(DIVISION_ID 필터)입니다. 컬럼 표시가 Division별로 달라지는 분기는 grid_code에서 잘린 부분에 있을 수 있습니다. **확인 필요**
- SP `SSP0060_GET_SHIPMENT_DIVISION`의 결과로 Division과 Site 콤보가 정해집니다(TB_FX_USERGROUPAUTHEXTENTION 기준 권한 필터).

## 6. 화면 로직 사실 (DB 컬럼 사용)
- `Validation_Check`(3644~3786)는 confirm_id 단위로 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks를 비교합니다(Validationdr, SONoValidationdr).
- `chkERPIFBlockYn`(3568/3577)과 팝업의 `ChkERPIFBlockYn`(756/765)은 BLOCK_YN과 PERIOD를 확인합니다. 조회 소스는 Fact Pack에 없습니다. **확인 필요**
- `GetShipmentStatusChk`는 결과 테이블 3개(Tables[0..2])의 CONFIRM_ID를 확인합니다.
- `GetErpSoNoCnt`는 CNT를 확인하며, SO No 유무에 따라 `SoNo`와 `NonSoNo` 분기로 나뉩니다.
- `InitControls`는 dtShipmentInputPeriod 0·1행의 VALUE와 Diff_VALUE를 읽고(입력 기간), `FP_Log2`로 로그를 남깁니다(429, 440).
- `CalcPlanQty`, `CalculateSum`, `Set_SumValues`, `SetNote_Display`, `EditByChange`, `Simulation`은 클라이언트에서 계산하거나 표시하는 로직입니다(BOH_QTY, measure, NOTE, QTY/NOEDIT_QTY, Container_Qty).

## 7. 확인 필요 항목

| # | 항목 | 근거 |
|---:|---|---|
| 1 | `SSP.SSP0060_SAVE_HOLD_STOCK_DATA`: FoxQuery와 DB 모두에 없음 (SaveData_Detail:3460) | NOT_IN_FOXQUERY. 실제로 실패하는 경로인지, Hold stock 저장을 TO-BE에서 어떻게 대체할지 결정 필요 |
| 2 | unreached 호출 4종(`SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK`, `SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` ×2, NewNonSoNo의 `SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING`)을 이관 대상에 넣을지 | 정적 분석상 진입점 없음 |
| 3 | 메인 화면에서 RequestPopup과 ConfirmDetailPopup을 여는 지점 | Fact Pack 미기재 |
| 4 | 메인 화면 LayoutControlItem의 Text(조회조건 라벨) | props.csv가 잘려 미포함 |
| 5 | splitContainer1의 Orientation과 SplitterDistance | props.csv가 잘려 미포함 |
| 6 | 시트별로 어느 Spread에 올라가는지(spdMain/spdDetail) | grid_code가 잘림. flow 기준 추정만 가능 |
| 7 | Hold stock / Hold stock Detail 시트를 만드는 코드 위치 | 메타에는 있으나 "코드에서 생성하는 시트" 목록에는 없음 |
| 8 | Request Info 하드코딩 컬럼의 헤더와 필드가 뒤바뀜: `NEW_TO_CITY`→ELECTRODE_YN, `ELECTRODE_YN`→NEW_TO_CITY | ConfirmDetailPopup 215/216, RequestPopup 240/241 원문 그대로 |
| 9 | 표 4-2의 `SaveData`→`PersonalSettingPopup.SaveData` 매핑 | 같은 이름 때문에 파서가 오매칭했을 가능성. 화면 자체 SaveData와 구분 필요 |
| 10 | `GetSpdTitle`이 프레임워크(`SpreadInfo.GetSpdTitle`) 호출인지, 화면 자체 메서드(7449)인지 | 두 기록이 함께 존재 |
| 11 | SCM_MST_SHEET_MEASURE 행별 MEASURE 코드와 기본값 | 건수(14/6)만 있음 |
| 12 | TB_FX_GroupMenuAuth 13행의 권한 내용 | 행 수만 있음 |
