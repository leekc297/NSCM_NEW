[LITE]

=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
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

=== FILE: web_components.md ===
# SSP0060 Web 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

### 1-1. 메인 `SSP0060_ShipmentPlan`: 상단 조건 패널 (usrConditionPanel1 > usrLayoutControl2)
| AS-IS 컨트롤 | 타입 | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|
| clbCompany_ID | UsrCombo | 확인 필요 (props 잘림) | Wijmo ComboBox |
| clbDivision_ID | UsrCombo | 확인 필요 | Wijmo ComboBox |
| clbPlantSite | UsrCheckedList | 확인 필요 | Wijmo MultiSelect |
| cboPlanDate | UsrCombo | LayoutItem 이름 `PlanDate`, Text는 확인 필요 | Wijmo ComboBox |
| cboBucketType | UsrCombo | LayoutItem `lblBucket`, Text는 확인 필요 | Wijmo ComboBox |
| drpPeriod | UsrDateRangePicker | 확인 필요 | 기간(From/To) InputDate 쌍 |
| txtItemId + btnItemId | UsrMultiLineEditor + UsrButton | LayoutItem `lblItemId`, Text는 확인 필요 | 다건 입력 + 품목 팝업 버튼 |
| clbProductLevel11 | UsrCheckedList | LayoutItem `lcProductLevel11`, Text는 확인 필요 | Wijmo MultiSelect |
| chkSum | UsrCheckBox | 확인 필요 | Checkbox |
| chkTotPSI | UsrCheckBox | 확인 필요 | Checkbox (변경 시 재조회) |
| btnMeasure | UsrButton | 확인 필요 | Measure 선택 버튼 |
| btnSimulation | UsrButton | LayoutItem `lcbtnSimulation`, Text는 확인 필요 | Button |
| usrButton1 | UsrButton | 확인 필요 (부모 없음) | 확인 필요 |
| (프레임워크) FindButton / SaveButton / EditButton | 공통 버튼 | – | 공통 버튼바 (menu-button-dynamic-fetch) |

### 1-2. 메인: 하단 Detail 영역 조건 (splitContainer1.Panel2 > usrLayoutControl3)
| AS-IS 컨트롤 | 타입 | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|
| txtRequestor + btnRequestor | UsrTextBox + UsrButton | LayoutItem `Requestor`, Text는 확인 필요 | 입력 + 사용자 팝업 |
| txtModel2 + btnItemID2 | UsrMultiLineEditor + UsrButton | 확인 필요 | 다건 입력 + 품목 팝업 |
| drpPeriod2 | UsrDateRangePicker | 확인 필요 | InputDate 쌍 (ValueChanged 처리) |
| drpPeriod3 | UsrDateRangePicker | 확인 필요 | InputDate 쌍 |
| clbResultType | UsrCheckedList | 확인 필요 | MultiSelect |
| txtBoxID | UsrMultiLineEditor | 확인 필요 | 다건 입력 |
| clbProductLevel12 | UsrCheckedList | LayoutItem `lcProductLevel12` | MultiSelect |
| btnSearch | SimpleButton | 확인 필요 | Detail 조회 버튼 |
| btnNew | UsrButton | LayoutItem `lcbtnNew` | 신규 버튼 |

### 1-3. RequestPopup (Form Text `"Shipment Request Popup"`)
| AS-IS 컨트롤 | 타입 | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|
| usrButtonList1 | UsrButtonList | – | 팝업 버튼바 |
| cboChangeReason | UsrComboBox | `Change Reason*` | ComboBox (필수) |
| txtReasonDetail | TextBox | `Reason Detail*` | Input (필수) |
| btnAutoSet | SimpleButton | Text `Auto Set` | Button |
| spdMain | FpSpread | 시트 Request Info | FlexGrid |

### 1-4. ConfirmDetailPopup (Form Text `"Request Info Popup"`)
| AS-IS 컨트롤 | 타입 | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|
| btnButtonList | UsrButtonList | – | 팝업 버튼바 |
| txtRequestNo | TextBox ReadOnly | `Request No` | readonly Input |
| txtRequestor | TextBox ReadOnly | `Requestor` | readonly Input |
| txtRequestDeptName | TextBox ReadOnly | `Dept Name` | readonly Input |
| txtApproval | TextBox ReadOnly | `Approval` | readonly Input |
| txtAppDeptName | TextBox ReadOnly | `Dept Name` | readonly Input |
| usrLabel2 | UsrLabel | `Request Confirm Detail` | 섹션 타이틀 |
| spdMain | FpSpread | 시트 Request Info | FlexGrid (조회 전용 여부는 확인 필요) |

## 2. 화면 배치

| 화면 | 구조(props.csv 원문) | 분할 |
|---|---|---|
| 메인 | usrConditionPanel1(조건), splitContainer1: Panel1=spdMain, Panel2=spdDetail + usrLayoutControl3 | splitContainer1의 Orientation, SplitterDistance, Size는 props.csv가 잘려 **확인 필요**. Panel1(상단 또는 좌측)=Main grid, Panel2=Detail 조건+Detail grid |
| RequestPopup | usrConditionPanel1 Dock=Top (1764×52), splitter1 Dock=Top (1764×3), spdMain Dock=Fill (1764×288) | 상하 배치: 조건 52 : 그리드 288 (≈15% : 85%) |
| ConfirmDetailPopup | usrConditionPanel1 Dock=Top (1764×52), panel1 Dock=Top (1764×158, 요청 정보 readonly), splitter1 Dock=Top (1764×3), spdMain Dock=Fill (1764×157) | 상하 3단: 52 : 158 : 157 (≈14% : 43% : 43%) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

모든 메타 시트는 14개 Division에서 표시가 같습니다(Division별 차이 없음). "기본"은 표시, "숨김"은 VISIBLE_FLAG≠Y 또는 숨김 처리입니다. CODE_LOOP 컬럼 `EDIT_YN_{sColumnName.Replace("D_","")}`(헤더 `E{COLUMN_LABEL_NAME}`)은 날짜 컬럼마다 코드가 추가하는 편집 여부 컬럼이며, grid_effective 표시는 `코드추가?`입니다.

### 3-1. Shipment Plan (메타 13 표시 / 5 숨김 + CODE_LOOP, MEASURE 14/6)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| DIVISION_ID | Div | 기본 |
| FROM_SITE_DESCRIPTION | From Site | 기본 |
| TO_SITE | To Site | 기본 |
| PRODUCT_LEVEL1 | Product Level1 | 기본 |
| ITEM_ID | Model | 기본 |
| NICK_NAME | Nick Name | 기본 |
| FCST_TYPE | FCST Type | 기본 |
| INCOTERMS | Incoterms | 기본 |
| TRANSPORT_MODE | Transmode | 기본 |
| BOH_TYPE | BOH_TYPE | 기본 |
| BOH_QTY | BOH_QTY | 기본 |
| PSI | PSI | 기본 |
| MEASURE_NAME | Measure | 기본 |
| FROM_SITE / MEASURE / BACK_COLOR / CONFIRM_DAY / LOT_YN | Site / Measure / Back Color / Confrim Day / Lot_YN | 숨김 |
| (날짜 컬럼) | SCP0009_GET_SHEET_CALENDAR_3SPAN 결과 + InitSpreadDateColumn | 코드 |
| EDIT_YN_* | E{라벨} | 코드추가? |

(메타 컬럼 순서는 SCM_MST_SHEET_COLUMNS 원문 순서를 따릅니다. 위 표는 알파벳 정렬된 grid_effective를 다시 묶은 것이므로 실제 순서는 메타에서 확인해야 합니다.)

### 3-2. Shipment Plan Detail (44 표시 / 27 숨김 + CODE_LOOP)
표시(44): A_COUNTRY "A Contry", A_PORT_CODE "A Port Code", A_PORT_NAME "A Port Name", ATTRIBUTE10, CHANGE_REASON_CODE "Change Reason*", CHANGE_REASON_DETAIL "Reason Detail*", CHANGE_REQ_NO "Change Request No", CITY_NAME, CONFIRM_ID "Confirm/Plan ID", COUNTRY_NAME, DIVISION_ID "Div", END_CUSTOMER, ERP_DO_NO "DO No", ERP_SO_NO "SO No", ETA, ETD, Expected_Shipping_Date, FCST_TYPE "FCST Type*", FROM_SITE_DESCRIPTION "From Site*", INCOTERMS "Incoterms*", ITEM_ID "Model*", LT_DAY "L/T(Day)", MKT_OWNER, MODEL_USER "Model PIC", NICK_NAME, PRODUCT_LEVEL1, PROJECT_CODE, PROJECT_NAME, REMARKS "Remarks", REMARKS2 "Building", REMARKS3 "Customer Requirement", REQUESTOR "Shipment Requestor", SHIPMENT_CONFIRM_QTY "Shipment Qty*", SHIPMENT_DATE "Shipment Date*", SHIPMENT_STATUS "Status", SHIPTO_CITY_NAME, SHIPTO_DESCRIPTION "Ship To Party", SHIPTO_REGION_NAME, SOLDTO_DESCRIPTION "Sold To Party", TEAM, TO_SITE_DESCRIPTION "To Site*", TRANSPORT_MODE "Trans Mode*", UPDATED_BY, UPDATED_DATE

숨김(27): BOD_ID, CHANGE_TYPE, CHECK_NEED_YN "Checked", EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE "From Site ID", TO_SITE "To Site ID", ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE

편집 관련 사실: TRANSPORT_MODE는 `SpdDetail_EditChange`(1380/1389)와 `SpdDetail_CellClick`(1987)에서 `CommonData [TransMode]`(SCP_MST_BOD_V)로 콤보 값을 다시 구합니다. `*` 라벨은 필수 입력 표시이며, 검증 로직은 `Validation_Check`에 있습니다.

### 3-3. Stock Location Detail (20 표시)
AVAILABLE_DATE, AVAILABLE_QTY, COMPANY_ID "Company", CUTOFF_DATE, DEFECT_QTY "Deffect Qty", DIVISION_ID "Div", FROM_SITE, HOLDING_DATE, ITEM_ID "Model", MOVING_QTY, NICK_NAME, OUTSOURCING_FACTORY, OUTSOURCING_FLAG, PLANT_ID "Plant", QTY_UOM "Qty Uom", STOCK_TYPE, STORAGE_DESCRIPTION "Storage", STORAGE_ID "Storage ID", TOTAL_QTY, WIPHOLD_YN "Wiphold Yn", 그리고 CODE_LOOP EDIT_YN_*

### 3-4. oWMS Detail (25 표시)
ALLOCATION_QTY, AVAILABLE_QTY, CAPA_GRADE "Capa. Grade", CUSTOMER_CODE, CUSTOMER_NAME, DIVISION_ID "Div", EXPIRATION_QTY, GRADE, HOLD_QTY, ITEM_ID "Model", LONG_TERM_QTY "Long-term Qty", LOT_ID, LOT_ISSUE_DATE, MOVING_QTY, NICK_NAME, PACKING_QTY, PACKING_STATUS, PALLET_ID, PLANT_ID, RECEIVING_QTY "Reciving Qty"(원문 오타), SOC, STOCK_QTY, STOCK_STATUS "Inventory Status", STORAGE_ID "Storage", UNDECIDED_QTY, 그리고 CODE_LOOP EDIT_YN_*

### 3-5. Hold stock (10 표시 / 2 숨김)
DIVISION_ID "Div", FROM_SITE_NM "From Site", ITEM_ID "Model", NICK_NAME, HOLD_QTY "Amend Qty*", HOLD_YYYYMMDD "Start Date", RELEASE_YYYYMMDD "End Date*", REMARKS, LAST_UPDATED_BY, LAST_UPDATE_DATE. 숨김: FROM_SITE "Site", HOLD_ID
- 라벨에 `*`가 있어 편집 시트로 보입니다. 저장 엔드포인트 `SSP.SSP0060_SAVE_HOLD_STOCK_DATA`는 FoxQuery와 DB 모두에 없습니다. **확인 필요**

### 3-6. Hold stock Detail (10 표시 / 2 숨김)
Hold stock과 같은 컬럼이며, 라벨에 `*`가 없습니다(HOLD_QTY "Amend Qty", RELEASE_YYYYMMDD "End Date"). 숨김: FROM_SITE, HOLD_ID

### 3-7. MES Stock (9 표시)
ITEM_ID "Model", NICK_NAME, TOTAL, AVAILABLE_STOCK, BEFORE_OQC, OQC_INSP_REQUEST, OQC_COMPLETE, OQC_NG, QMS_MES_HOLD "QMS/MES Hold", 그리고 CODE_LOOP EDIT_YN_*

### 3-8. MES Stock Detail (13 표시)
PRODID "Model", PRJT_NAME "Nick Name", LOTID "Lot ID", BOXID "Box ID", LOT_QTY, AVAILABLE_YN "Available stock YN", OQC_INSP_RESULT, EXP_INSP_VALID_DATE "Exp Insp Vaild Date"(원문 오타), PROD_VALID_DATE, MES_HOLD_YN, MES_UNHOLD_SCHD_DATE, QMS_HOLD_YN, QMS_UNHOLD_SCHD_DATE, 그리고 CODE_LOOP EDIT_YN_*

### 3-9. Shipment Result (16 표시)
CONFIRM_ID "Confirm/Plan ID", DIVISION_ID "Div", END_CUSTOMER, ERP_SO_NO "SO No", ETA_DATE "ETA", ETD_DATE "ETD", FROM_SITE, TO_SITE, INCOTERMS, ITEM_ID "Model", NICK_NAME, QTY "Shipment Qty", SHIP_TYPE, TRANSPORT_MODE "Trans Mode", TYPE "Status", YYYYMMDD "Shipment Date", 그리고 CODE_LOOP EDIT_YN_*

### 3-10. Request Info (두 팝업 모두 코드 하드코딩, 메타 없음)
헤더 2행이며, 상위 ColumnHeaderSpan은 `Confirmed`(LT_DAY부터 6칸)와 `Change`(NEW_LT_DAY부터 6칸)입니다.

| 필드 | 헤더 | 타입 | 폭 | ConfirmDetailPopup 표시 |
|---|---|---|---:|---|
| (CAppSetting.StringAction) | A | Text | 10 | 숨김 |
| CHANGE_REQ_NO | change_req_no | Text | 100 | 숨김 |
| DIVISION_ID | Division ID | Text | 100 | 숨김 |
| NEW_YN *(RequestPopup만)* | New YN | Text | 10 | 숨김 (RequestPopup) |
| CONFIRM_ID | Confirm/Plan ID | Text | 100 | 표시 |
| ERP_SO_NO | SO No | Text | 100 | 표시 |
| PROJECT_NAME | Project Name | Text | 100 | 표시 |
| FCST_TYPE | FCST Type | Combo (LookupCommon `SALES_TYPE_CODE`) | 100 | 표시 |
| ITEM_ID | Model | Text | 80 | 표시 |
| FROM_SITE | From Site | Text | 60 | 표시 |
| TO_SITE | To Site | Text | 100 | 표시 |
| INCOTERMS | Incoterms | Text | 65 | 표시 |
| LT_DAY / ETD / ETA / TRANSPORT_MODE / SHIPMENT_DATE / SHIPMENT_CONFIRM_QTY | [Confirmed] L/T(Day) / ETD / ETA / Trans Mode / Shipment Date / Qty | Text/Date/Date/Text/Date/Num | 60/70/70/45/70/60 | 표시 |
| NEW_LT_DAY / NEW_ETD / NEW_ETA / NEW_TRANSPORT_MODE / NEW_SHIPMENT_DATE / NEW_SHIPMENT_CONFIRM_QTY | [Change] 같은 헤더 | 같은 타입 | 같은 폭 | 표시 |
| DIFF_QTY | Diff Qty | Num | 60 | 표시 |
| CHANGE_REASON_CODE | Change Reason | Combo (`GetSSPInnerTable("CHANGE_REASON_CODE_ALL")`) | 100 | 표시 |
| CHANGE_REASON_DETAIL | Reason Detail | Text | 100 | 표시 |
| NEW_BOD_ID, NEW_ROUTE_ID, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_TO_COUNTRY | 같은 이름 | Text | 100 | 숨김 |
| **ELECTRODE_YN** | **NEW_TO_CITY** (원문 그대로, 헤더와 필드가 뒤바뀜) | Text | 100 | 숨김 |
| **NEW_TO_CITY** | **ELECTRODE_YN** (원문 그대로) | Text | 100 | 숨김 |
| ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, EDIT_REMARKS, EDIT_MAIN, REMARKS, REMARKS2, REMARKS3, PRODUCT_LEVEL1, NICK_NAME, FROM_SITE_DESCRIPTION, TO_SITE_DESCRIPTION, PROJECT_CODE | 같은 이름 | Text | 100 | 숨김 |

- ConfirmDetailPopup은 48컬럼, RequestPopup은 NEW_YN을 더해 49컬럼입니다.
- RequestPopup 각 컬럼의 표시 여부, 폭, 정렬은 grid_code가 잘려 **확인 필요**입니다.

## 4. 시트 연결 규칙

| 트리거 | 동작 | 대상 시트(호출 SP 기준) |
|---|---|---|
| 조회(FindButton), chkTotPSI 변경 | FindData_Main | Shipment Plan (`SSP0060_GET_SHIPMENT_PLAN`) |
| spdMain 셀 더블클릭 (`SpdMain_CellDoubleClick`) | FindData_Detail, Stock_Detail, oWMS_Detail, Shipment_Result, hold_stock, MES_stock, MES_stock_Detail | Shipment Plan Detail, Stock Location Detail, oWMS Detail, Shipment Result, Hold stock, MES Stock, MES Stock Detail |
| Detail 영역 btnSearch (`BtnSearch_Click`) | 위와 같되 hold_stock 제외 | 활성 시트 기준인지는 확인 필요 |
| spdDetail 시트 탭 (`SpdDetail_SheetTabClick`, `SpdDetail_ActiveSheetChanged`) | 시트 전환 처리 | 로직 내용은 확인 필요 |
| cboPlanDate / clbCompany_ID / btnMeasure | InitSpread > GetSpdTitle로 날짜 헤더 재구성 | Shipment Plan |
| 저장 후 (SaveData_Detail) | FindData_Main, FindData_Detail, FindData_hold_stock 재조회 | Shipment Plan, Shipment Plan Detail, Hold stock |
| spdMain/spdDetail TopChange | 스크롤 동기화 핸들러(SpdMain_TopChange, SpdDetail_TopChange) | 동기화 대상은 확인 필요 |

- 더블클릭한 셀(Measure 또는 컬럼)에 따라 어느 FindData_*가 실행되는지는 Fact Pack에 없습니다. **확인 필요**

=== FILE: oracle_migration.md ===
# SSP0060 Oracle 전환 분석

## 1. 호출 SP 인벤토리 (29개 + 미등록 1개)

| # | SP | 호출 키 | 쓰기(INSERT/UPDATE/DELETE) | 읽기/참조 | EXEC 체인 |
|---:|---|---|---|---|---|
| 1 | `SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` | SSP | – | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_FINAL_ITEM, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_PROJECT, SCM_MST_ITEM_SN, SCM_MST_SITE, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER; FN_GET_PROJECT_NAME, FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SITE_CUSTOMER_INFO | – |
| 2 | `SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM` | SSP | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM, SSP_MST_SEND_MAIL_REQ / INSERT SSP_MST_SEND_MAIL_REQ, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_H, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN, SCM_SYS_LOG_BATCH, #TBLSSPADJUSTMAILSEND | SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_PLAN_VERSION_V, SCM_MST_SITE, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_PROJECT, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER_EE, SCM_MST_SITE_CUSTOMER; FN_GET_SSP_ETA_DATE, FN_MULTY_TIME, FN_GET_SSP_SITE_INFO(_EXCEPTION), FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SITE_CUSTOMER_INFO, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_USER_NAME, FN_WEEKOFDAY_DATE, UF_FX_STRING_SPLIT, FN_NEXT_DAY, SCM_ARR_SPL_CNT/VAL; 임시 #T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT | PR_SCM_SYS_LOG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_MAIL_SEND_ADJUST_SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_DM_SSP_CONFIRM_SYNC, PR_SCP_SYS_LOG_BATCH, PR_SSP_PLN_FP_SHIP_TARGET_WA, PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| 3 | `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | SSP | – | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL | – |
| 4 | `SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK` (unreached) | SSP | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN, SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER; FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_SITE_CUSTOMER_INFO | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCP_SYS_LOG_BATCH |
| 5 | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | SSP | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE; SCM_ARR_SPL_CNT/VAL | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 6 | `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | SSP | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM / DELETE SSP_ANL_SHIP_CONFIRM / INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST; FN_GET_SSP_SITE_INFO(_EXCEPTION), FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS, SCM_ARR_SPL_CNT/VAL | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 7 | `SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN` | SSP | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, _DE / INSERT SCM_SYS_LOG_BATCH | SCM_ARR_SPL_CNT/VAL | PR_SCM_SYS_LOG_BATCH |
| 8 | `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | SSP | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST; FN_GET_SSP_SITE_INFO(_EXCEPTION), FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS | PR_SCP_SYS_LOG_BATCH |
| 9 | `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C` | SSP | #8과 같은 객체 집합 | #8과 같음 | PR_SCP_SYS_LOG_BATCH |
| 10 | `SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE` | SSP | INSERT SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM; SCM_ARR_SPL_CNT/VAL | PR_SCM_SYS_LOG_BATCH |
| 11 | `SSP0060_GET_ERP_SO_NO_CNT` | SSP | – | SSP_ANL_SHIP_CONFIRM | – |
| 12 | `SSP0060_GET_SHIPMENT_STATUS` | SSP | – | SSP_ANL_SHIP_CONFIRM; STRING_SPLIT | – |
| 13 | `SSP0060_GET_SHIPMENT_DIVISION` | SSP | INSERT #RETURNTABLE | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_CODE_LOOKUP_VALUE; FN_GET_LOOKUP_VALUE | – |
| 14 | `SSP0060_SAVE_SHIPMENT_PLAN` | SSP | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_MST_SITE_ITEM, SSP_MST_SITE_ITEM_EE_V, SCP_MST_SHIPMENT_LOT_SIZE, SSP_MST_PARTIAL_SEQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SCM_MST_SITE_CUSTOMER; STRING_SPLIT, FN_GET_SSP_ETA_DATE, FN_GET_SSP_SITE_INFO(_EXCEPTION), SCM_ARR_SPL_CNT/VAL | PR_SCM_SYS_LOG_BATCH |
| 15 | `SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING` | SSP | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ, _DE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST; FN_GET_SSP_ETA_DATE 외 | PR_SCM_SYS_LOG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCP_SYS_LOG_BATCH |
| 16 | `SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING` (unreached) | SSP | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, _DE / INSERT SCM_SYS_LOG_BATCH | – | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 17 | `DM0003_GET_BUCKET_TYPE_CODE` | DM | – | SCM_ADM_LOOKUP_MASTER_DETAIL | – |
| 18 | `SSP0060_GET_SHIPMENT_PLAN` | SSP | INSERT/UPDATE/DELETE 임시테이블만: #TBLDYNAMICTITLEST_SSP0060, #TMP_RESULT_TABLE, #TMP_RESULT_DETAIL_TABLE, #TMP_BOHDATA_STORAGE, #TMP_BOHDATA, #TMP_SHIPMENT_RESULT, #TMP_ROWDATA, #TMP_RESULT_PIVOT_TABLE, #TMP_RESULT_PIVOT_TABLE_OLD | SCM_MST_TITLESET_USER, SSP_DNM_GMES_STOCK_81_82, SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, MST_STOCK, MST_LOCATION, PACKER_STOCK, SCM_MST_SITE, SCM_MST_ITEM_SN, SCP_MST_FINAL_ITEM, SSP_DNM_STOCK_C, SSP_DNM_ESS_PACKER_STOCK_V, SSP_MST_LOCATION_V, SCM_DNM_EXFACTORY_RESULT, DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_CONFIRM, SSP_DNM_FP_PLAN_FROZEN, SCP_ANL_PRODUCTION_PLAN, SCP_PLAN_VERSION_V, SSP_DNM_FP_AMEND_SHIPAVAL, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCP_MST_SHIPMENT_LOT_SIZE, SSP_ANL_SHIP_PLAN_C, SCM_DNM_CELL_INHOUSE_PLAN_SN, SCP_MST_BOD_N_V; STRING_SPLIT, FN_GET_ANL_SHIP_FROZEN_DAY_CNT, FN_GET_SSP_ETA_DATE, UF_FX_STRING_SPLIT; **DYNAMIC SQL** | SSP0060_GET_SHIPMENT_PSI_COMMENTS |
| 19 | `SSP0060_GET_SHIPMENT_PLAN_DETAIL` | SSP | – | FN_GET_IN_STR, FN_SCM_SPLIT; **DYNAMIC SQL** (참조 테이블은 동적 SQL 안에 있어 추출되지 않음, 확인 필요) | – |
| 20 | `SSP0060_GET_STOCK_LOCATION_DETAIL` | SSP | – | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_DNM_STOCK_C, SCP_MST_FINAL_ITEM, SSP_DNM_ESS_PACKER_STOCK_V, SCM_MST_ITEM_SN; FN_GET_IN_STR, STRING_SPLIT, FN_GET_ITEM_NICKNAME, FN_SCM_SPLIT | – |
| 21 | `SSP0060_GET_OWMS_DETAIL` | SSP | – | SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_MST_MODEL_USER, SCP_MST_FINAL_ITEM, SCM_MST_ITEM_SN; FN_GET_IN_STR, FN_GET_ITEM_NICKNAME, STRING_SPLIT, FN_SCM_SPLIT | – |
| 22 | `SSP0060_GET_SHIPMENT_RESULT` | SSP | – | RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS (CTE 또는 실테이블인지 확인 필요), SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SCP_MST_FINAL_ITEM, SSP_MST_DELEGATE, SCM_DNM_EXFACTORY_RESULT, SCM_MST_ITEM_SN, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS; FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, STRING_SPLIT | – |
| 23 | `SSP0060_GET_HOLD_STOCK` | SSP | – | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SCP_MST_FINAL_ITEM, SCM_MST_SITE, SCM_MST_ITEM_SN; FN_GET_IN_STR, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_ITEM_NICKNAME, FN_CHAR_TO_DATE, STRING_SPLIT, FN_SCM_SPLIT | – |
| 24 | `SSP0060_GET_MES_STOCK` | SSP | – | SSP_DNM_GMES_STOCK_81_82, SCP_MST_FINAL_ITEM; FN_GET_IN_STR, STRING_SPLIT, FN_SCM_SPLIT | – |
| 25 | `SSP0060_GET_MES_STOCK_DETAIL` | SSP | – | #24와 같음 | – |
| 26 | `SSP0002_GET_NERP_CODE` | SSP | – | SCM_CODE_LOOKUP_VALUE | – |
| 27 | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP | – | SCM_SYS_CALENDAR_M | – |
| 28 | `SCM_SSP_CHECK_CONFIRM_CHANGETIME` | SSP | INSERT SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE; SCM_ARR_SPL_CNT/VAL | PR_SCM_SYS_LOG_BATCH |
| 29 | `SSP0002_GET_USER_INFO_LIST` | SSP | – | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | – |
| – | `SSP0060_SAVE_HOLD_STOCK_DATA` | SSP | **FoxQuery·DB 모두 없음** | – | – |

## 2. 공통코드 분기 (biz:CommonData.CommonDataList → UP_FX_GetCommonDataList)

| code | 사용처 | 참조 테이블 |
|---|---|---|
| LookupCommon (`SALES_TYPE_CODE`) | 두 팝업의 `dtFcstType` 필드(CP:37, RP:41), Request Info FCST Type 콤보 | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| TransMode | 메인 SpdDetail_EditChange(1380, 1389), SpdDetail_CellClick(1987) | SCP_MST_BOD_V |

추가로, 프레임워크 `DataService.GetSSPInnerTable`이 메타 코드 목록을 공급합니다. 호출 지점은 InitSpread:174, InitControls:171, SetChangeControl:366~391이며, 예로 `CHANGE_REASON_CODE_ALL`이 있습니다. 반환 컬럼은 CODE, NAME, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, PLANT_ID, SCM_SITE_ID입니다. 내부 SQL은 Fact Pack에 없습니다. **확인 필요**

## 3. FoxQuery 미등록 / 직접 호출 SP

| 키 | 호출 위치 | 상태 | 조치 |
|---|---|---|---|
| `SSP.SSP0060_SAVE_HOLD_STOCK_DATA` | SaveData_Detail (M:3460) | NOT_IN_FOXQUERY, DB에도 없음 | AS-IS 실운영에서 이 경로가 실행되는지, 또는 예외로 끝나는지 확인 필요. Hold stock 저장 로직의 실체(대체 SP 유무)를 AS-IS DB(SCM_ADM_DB_SCRIPT_BACKUP 337행 포함)에서 찾아야 합니다. |

주석 처리된 `SSP.SSP0046_GET_BUCKET_TYPE_CODE`(M:341)는 **주석 처리됨**이므로 전환 대상이 아닙니다.

## 4. Oracle 전환 확인 포인트 (Fact Pack 사실 기준)

| # | 포인트 | 해당 SP |
|---:|---|---|
| 1 | **STRING_SPLIT** (MSSQL 전용) 참조. Oracle 분해 함수로 대체 필요 | SSP0060_GET_SHIPMENT_PLAN, SSP0060_GET_SHIPMENT_STATUS, SSP0060_SAVE_SHIPMENT_PLAN, SSP0060_GET_STOCK_LOCATION_DETAIL, SSP0060_GET_OWMS_DETAIL, SSP0060_GET_SHIPMENT_RESULT, SSP0060_GET_HOLD_STOCK, SSP0060_GET_MES_STOCK, SSP0060_GET_MES_STOCK_DETAIL |
| 2 | 분해 계열 사용자 함수 FN_SCM_SPLIT, FN_GET_IN_STR, UF_FX_STRING_SPLIT, SCM_ARR_SPL_CNT/VAL의 Oracle 대응 객체 존재 여부 | 위 조회 SP, 저장 SP 다수 |
| 3 | **`#` 임시테이블**을 GTT 또는 WITH로 전환. 세션 상태가 남지 않도록 시작 시 비우기 필요 | SSP0060_GET_SHIPMENT_PLAN(9종), SSP0060_GET_SHIPMENT_DIVISION(#RETURNTABLE), SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM(#TMP_XIF_…_1106), SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM(#T_* 5종, #TEMP_SALES_RESULT, #TBLSSPADJUSTMAILSEND) |
| 4 | **동적 SQL** (DYNAMIC@). 피벗 결과셋 컬럼이 가변이라 REF CURSOR 설계와 컬럼 메타 연동 필요 | SSP0060_GET_SHIPMENT_PLAN, SSP0060_GET_SHIPMENT_PLAN_DETAIL |
| 5 | 결과셋 여러 개 반환: GetShipmentStatusChk가 Tables[0..2]를 사용 | SSP0060_GET_SHIPMENT_STATUS (커서 3개) |
| 6 | ERP/SCS 인터페이스 테이블 쓰기: XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN, XIF_ERP_PACK_SHIP_PLAN_S_SN. TO-BE에서 대상 테이블과 링크 경로 확인 필요 | #2, #4, #6, #8, #9, #15 |
| 7 | 메일 발송 체인: PR_SSP_MAIL_SEND_ADJUST_MST/SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, SSP_MST_SEND_MAIL_REQ | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM |
| 8 | 트랜잭션 로그 호출 `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`: 자율 트랜잭션이 필요한지 확인 | #4, #5, #6, #16 |
| 9 | 타 도메인 SP 연동: PR_DM_SSP_CONFIRM_SYNC(DM), PR_SSP_PLN_FP_SHIP_TARGET_WA(FP) | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM |
| 10 | 참조명이 실테이블인지 CTE/별칭인지 확인: MST_STOCK, MST_LOCATION, PACKER_STOCK (SSP0060_GET_SHIPMENT_PLAN), RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS (SSP0060_GET_SHIPMENT_RESULT) | 해당 SP 원문 |
| 11 | 타 도메인 공용 SP 재사용: `DM0003_GET_BUCKET_TYPE_CODE`, `SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SSP0002_GET_NERP_CODE`, `SSP0002_GET_USER_INFO_LIST`, `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`. 이미 전환되었는지 확인 | – |
| 12 | 같은 객체 집합을 쓰는 SP 쌍: `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`와 `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C`, `SCM_SSP_CHECK_CONFIRM_CHANGETIME`과 `SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE`. 참조 테이블은 같거나 비슷하지만 로직 차이는 원문 대조로 확인해야 함 | – |

## 5. 난이도 (사실 근거만)

| 구분 | SP | 근거 |
|---|---|---|
| 상 | SSP0060_GET_SHIPMENT_PLAN | 동적 SQL, # 임시테이블 9종, 참조 객체 50개 이상, 하위 EXEC |
| 상 | SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM | EXEC 체인 10종, 인터페이스와 메일 쓰기, # 임시테이블 7종 |
| 중 | SSP0060_GET_SHIPMENT_PLAN_DETAIL | 동적 SQL (참조 객체 미추출) |
| 중 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK, SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(_NEW_C), SSP0060_SAVE_SHIPMENT_PLAN | 인터페이스 쓰기 또는 임시테이블, 함수 다수, EXEC 체인 |
| 중 | SSP0060_GET_SHIPMENT_RESULT, SSP0060_GET_STOCK_LOCATION_DETAIL, SSP0060_GET_OWMS_DETAIL, SSP0060_GET_HOLD_STOCK | STRING_SPLIT, 분해 함수, 참조 10~20개 |
| 하 | SSP0060_GET_ERP_SO_NO_CNT, SSP0060_GET_SHIPMENT_STATUS, SSP0060_GET_MES_STOCK(_DETAIL), SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SSP_CHECK_CONFIRM_CHANGETIME(_DE), SSP0060_GET_SHIPMENT_DIVISION, SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING, SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 참조 테이블 1~18개, 동적 SQL 없음 (일부 STRING_SPLIT, #RETURNTABLE) |
| 하 | DM0003_GET_BUCKET_TYPE_CODE, SCP0009_GET_SHEET_CALENDAR_3SPAN, SSP0002_GET_NERP_CODE, SSP0002_GET_USER_INFO_LIST, SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 단순 조회, 공용 SP |

=== FILE: tobe_design.md ===
# SSP0060 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 메인 조회 (FindButton → `SSP0060_GET_SHIPMENT_PLAN`)
| 컨트롤 | 타입 | 데이터 소스 | 비고 |
|---|---|---|---|
| clbCompany_ID | 단일 콤보 | GetSSPInnerTable (InitControls) | 변경 시 InitSpread와 GetSpdTitle 재구성, cboPlanDate 이벤트 일시 해제 |
| clbDivision_ID | 단일 콤보 | `SSP0060_GET_SHIPMENT_DIVISION` (SetChangedControl) | 변경 시 `SSP0002_GET_NERP_CODE`(SEGMENT2) |
| clbPlantSite | 다중 선택 | GetSSPInnerTable 계열 (확인 필요) | GetCheckedListValue(CODE) |
| cboPlanDate | 단일 콤보 | 확인 필요 (CODE, FROM_DATE, TO_DATE1 사용) | 변경 시 GetSpdTitle과 InitSpreadDateColumn |
| cboBucketType | 단일 콤보 | `DM0003_GET_BUCKET_TYPE_CODE` | cboBucketType_SelectedIndexChanged |
| drpPeriod | 기간 | dtShipmentInputPeriod VALUE/Diff_VALUE 기반 기본값 (확인 필요) | |
| txtItemId (+btnItemId) | 다건 텍스트 + 품목 팝업 | – | |
| clbProductLevel11 | 다중 선택 | 확인 필요 | |
| chkTotPSI | 체크박스 | – | 변경 시 즉시 FindData_Main 재조회 |
| chkSum | 체크박스 | – | 합계 표시(클라이언트 Set_SumValues/CalculateSum, 확인 필요) |
| btnMeasure | 버튼 | SCM_MST_SHEET_MEASURE | Measure 선택 후 InitSpread |

### 1-2. Detail 조회 (btnSearch / spdMain 더블클릭)
txtRequestor(+btnRequestor), txtModel2(+btnItemID2), drpPeriod2(ValueChanged 처리), drpPeriod3, clbResultType, txtBoxID, clbProductLevel12. 컨트롤과 SP 파라미터의 대응 관계는 Fact Pack에 없습니다. **확인 필요**

라벨 원문은 메인 화면 props.csv가 잘려 **확인 필요**입니다. TO-BE에서는 `ui-category-setup-column-meta` 기준으로 라벨을 확정해야 합니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 SP(순서) | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | Form_Load > InitControls | SSP0060_GET_SHIPMENT_DIVISION, DM0003_GET_BUCKET_TYPE_CODE, SCP0009_GET_SHEET_CALENDAR_3SPAN | 초기 콤보 API(division, bucketType), 캘린더 헤더 API |
| 메인 조회 | FindButton / chkTotPSI | SSP0060_GET_SHIPMENT_PLAN (+ SCP0009 헤더) | 메인 PSI 조회 |
| Detail 조회 7종 | btnSearch / SpdMain_CellDoubleClick | SSP0060_GET_SHIPMENT_PLAN_DETAIL, SSP0060_GET_STOCK_LOCATION_DETAIL, SSP0060_GET_OWMS_DETAIL, SSP0060_GET_SHIPMENT_RESULT, SSP0060_GET_HOLD_STOCK(더블클릭만), SSP0060_GET_MES_STOCK, SSP0060_GET_MES_STOCK_DETAIL | 시트별 조회 API 7개 |
| 메인 저장 | SaveButton > SaveData_Main | SSP0060_SAVE_SHIPMENT_PLAN | 계획 저장 |
| Detail 저장 | SaveButton > SaveData_Detail | Validation_Check, chkERPIFBlockYn → SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM → GetERPInterface: SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, SSP0060_GET_ERP_SO_NO_CNT, SSP0060_GET_SHIPMENT_STATUS, SCM_SSP_CHECK_CONFIRM_CHANGETIME, SoNo/NonSoNo 분기 SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING, GetErpIFCheckNew 분기 PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH → 재조회 | 확정 저장. 하나의 트랜잭션으로 묶을지, 단계별 커밋을 유지할지 결정 필요 |
| Hold stock 저장 | SaveData_Detail:3460 | `SSP0060_SAVE_HOLD_STOCK_DATA` (없음) | **미확정** |
| 변경요청 팝업 조회 | RequestPopup Form_Load / Find | SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 변경요청 조회 |
| 변경요청 팝업 저장 | RequestPopup SaveButton / usrButtonList1 | ChkEngProcessing: SSP0003_GET_SSP_PLAN_PROCESSING_CHECK → SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM → GetERPInterface: ERROR_CONFIRM, DELETE_…_BY_CONFIRM, SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE, GET_ERP_SO_NO_CNT, GET_SHIPMENT_STATUS, SoNo: SAVE_…_DRAFTING_MAIN + PR_…_CHG_BATCH / NonSoNo: SAVE_…_DRAFTING_MAIN + PR_…_CHG_BATCH_NEW_C, GetErpIFCheckNew 분기 | 변경요청 저장 |
| 팝업 Auto Set | btnAutoSet_Click | 엔드포인트 없음 (클라이언트 로직) | FE 로직 |
| 확정 상세 팝업 | ConfirmDetailPopup Form_Load / Find | SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 조회 전용 팝업 |
| 수정 버튼 | EditButton > GetSSPUserCheck | SSP0002_GET_USER_INFO_LIST | 사용자 권한 체크 |
| Detail 셀 편집 | SpdDetail_EditChange / CellClick | CommonData [TransMode] | Trans Mode 콤보 API |
| Simulation / New / Requestor | BtnSimulation_Click / BtnNew_Click / BtnRequestor_Click | 엔드포인트 없음 (Simulation은 Container_Qty 기반 클라이언트 계산) | FE 로직과 공용 팝업 |

## 3. Division별 Grid 변형 요약
- 메타 기준으로 14개 Division 모두 컬럼 구성이 같습니다. Division 변형 없이 단일 컬럼 정의로 구현합니다.
- 다만 코드의 Division 분기(NERP 코드, 사이트 필터)는 조회 파라미터에 반영해야 합니다.
- 날짜 컬럼과 EDIT_YN_* 컬럼은 Plan Date와 Bucket에 따라 동적으로 만들어지므로 FE 동적 컬럼 생성이 필요합니다.

## 4. 권한(C/R/U/D) 관련 사실
| 사실 | 출처 |
|---|---|
| 메뉴 권한 메타 TB_FX_GroupMenuAuth 13행 (값 미포함) | DB 메타 §8 |
| 프레임워크 버튼 FindButton(R), SaveButton(C/U), EditButton 사용 | flow.csv |
| EditButton에서 `SSP0002_GET_USER_INFO_LIST`로 사용자, 그룹, 권한 확장(TB_FX_USERGROUPAUTHEXTENTION)을 확인 | endpoints.csv |
| Division과 Site 콤보를 TB_FX_USERGROUPAUTHEXTENTION 기준으로 필터 (`SSP0060_GET_SHIPMENT_DIVISION`) | endpoints.csv |
| UserInfoContext.Current.NowGroupID 사용 (InitControls, SetChangedControl, SetChangeControl, InitSpread) | meta_reads.csv |
| 삭제(D) 전용 버튼과 엔드포인트는 진입점에 연결되어 있지 않음 (`SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING`은 unreached) | flow.csv |

## 5. 미확정 사항
1. `SSP0060_SAVE_HOLD_STOCK_DATA`가 없는 상태에서 Hold stock 저장 기능을 유지할지, 대체할지
2. unreached 호출 4건(SSP0202_…_IF_CHECK, DELETE_…_DRAFTING ×2, NewNonSoNo)을 이관 대상에 포함할지
3. 메인 화면 조회조건 라벨, splitContainer1 분할 방향과 비율
4. 시트와 Spread(spdMain/spdDetail) 귀속, 더블클릭 셀 위치별 Detail 조회 분기 조건
5. Request Info의 ELECTRODE_YN과 NEW_TO_CITY 헤더/필드 교차를 TO-BE에서 그대로 둘지 (원문 결함 가능)
6. RequestPopup과 ConfirmDetailPopup을 메인에서 여는 조건과 전달 파라미터
7. 저장 체인(확정, ERP 인터페이스, 메일)의 트랜잭션 경계
8. TB_FX_GroupMenuAuth 그룹별 C/R/U/D 값
9. SCM_MST_SHEET_MEASURE의 Shipment Plan Measure 20행 상세(필수+기본 14 / 선택 6)
