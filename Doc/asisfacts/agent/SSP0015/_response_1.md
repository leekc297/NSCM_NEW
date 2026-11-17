=== FILE: analysis.md ===
# SSP0015 Shipment PSI — As-is 분석

> 근거: AsisFacts가 정적으로 추출한 Fact Pack이 유일한 근거다. Fact Pack에 없는 내용은 **확인 필요**로 적었다.
> 주석 처리된 호출 4건은 9장에만 '주석 처리됨'으로 적었다. 현행 기능 집계에는 넣지 않았다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0015 |
| 화면명(클래스) | `SSP0015_ShipmentPSI` (팝업 `SSP0015_ShipmentPSICommentsPopup`) |
| 도메인 | SSP |
| 프로젝트(current) | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.UIL.csproj` |
| Grid 구성 방식 | `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)` |
| 컨트롤 수 | 100개 (controls.csv) |
| 활성 엔드포인트 | 39종, 호출 지점 63곳 (endpoints.csv) |
| 이벤트 배선 | 34건, 핸들러 33종 (`Form_Load`가 본 화면과 팝업에 각 1번 배선됨) |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `...\SSP0015_ShipmentPSI.UIL\Properties\AssemblyInfo.cs` | 37 |
| current | `...\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.cs` | 9922 |
| current | `...\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.Designer.cs` | 1628 |
| current | `...\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSICommentsPopup.cs` | 447 |
| current | `...\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSICommentsPopup.Designer.cs` | 960 |
| shared | 없음. Fact Pack에 shared로 분류된 파일이 없다. | – |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0015_ShipmentPSICommentsPopup.cs` | 447 |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0015_ShipmentPSICommentsPopup.Designer.cs` | 960 |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0015_ShipmentPSI.cs` | 9857 |
| legacy | `06.UIL\GSCM.SSP.Plan.UIL\SSP0015_ShipmentPSI.Designer.cs` | 1624 |

- legacy와 current는 줄수가 다르다. 본문 .cs는 9857줄 대 9922줄이고, Designer는 1624줄 대 1628줄이다. 어떤 내용이 다른지는 **확인 필요**하다. 이 문서의 표는 모두 current 기준이다.

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | SP |
|---|---|---:|---|---|
| event:this.Load | Form_Load > InitControls | 568 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | – |
| event:this.Load | Form_Load > InitControls > GetBucketType | 2162 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 2202/2210/2218 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | – |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.Load | Form_Load > InitControls > GetDayRange | 9289 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | SCM0001_GET_SCP_DAY_PERIOD |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > GetDayRange | 9289 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | SCM0001_GET_SCP_DAY_PERIOD |
| event:clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged > SetChangedControl | 2202/2210/2218 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | – |
| event:clbDivision.SelectedIndexChanged | … > SetChangedControl > GetDayRange | 9289 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | SCM0001_GET_SCP_DAY_PERIOD |
| button:FindButton | FindButton > FindData_Main_Packer_Past | 2293 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` | SSP0015_GET_SHIPMENT_PSI_PACKER_PAST |
| button:FindButton | FindButton > FindData_Main_Packer | 2412 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` | SSP0015_GET_SHIPMENT_PSI_PACKER |
| button:FindButton | FindButton > FindData_Main | 2536 | `SSP.SSP0015_GET_SHIPMENT_PSI` | SSP0015_GET_SHIPMENT_PSI |
| button:FindButton | … > Re_Design > GetNERPCode | 2904 | `SSP.SSP0002_GET_NERP_CODE` | SSP0002_GET_NERP_CODE |
| button:FindButton | … > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:EditButton | EditButton | 1753/1757 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | – |
| button:EditButton | EditButton > GetSSPUserCheck | 9901 | `SSP.SSP0002_GET_USER_INFO_LIST` | SSP0002_GET_USER_INFO_LIST |
| button:SaveButton | SaveButton > SaveData (팝업) | 333 | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |
| button:SaveButton | SaveButton > SaveData_Main | 5412 | `SSP.SSP0015_SAVE_SHIPMENT_PSI` | SSP0015_SAVE_SHIPMENT_PSI |
| button:SaveButton | SaveButton > SaveData_Detail | 5841 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| button:SaveButton | SaveButton > SaveData_Detail | 6011 | `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` | SSP0015_SAVE_BLOCK_STOCK_DATA |
| button:SaveButton | SaveButton > SaveData_Detail | 6112/6219 | `SSP.SSP0015_SAVE_MES_STOCK` | SSP0015_SAVE_MES_STOCK |
| button:SaveButton | SaveButton > SaveData_Detail > FindData_Main / FindData_Detail / FindData_Detail_btnSearch / FindData_mes_stock / FindData_MesStock_btnSearch | 2536, 3165, 3303, 3705, 3966, 4528 | 재조회: `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_MES_STOCK` | 동일 |
| button:SaveButton | SaveButton > SaveData_Detail_Packer | 5602 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER |
| button:SaveButton | SaveData_Detail_Packer > chkSaveYN | 9821 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| button:SaveButton | SaveData_Detail_Packer > EngProcessingChk | 7903 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| button:SaveButton | SaveData_Detail_Packer > GetERPInterface | 6665 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| button:SaveButton | SaveData_Detail_Packer > GetERPInterface | 6706 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| button:SaveButton | … > GetERPInterface > NonSoNo | 6843 / 6847 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | 동일 |
| button:SaveButton | … > GetERPInterface > SoNo | 7076 / 7080 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | 동일 |
| button:SaveButton | … > GetERPInterface > GetErpSoNoCnt | 7185 | `SSP.SSP0015_GET_ERP_SO_NO_CNT` | SSP0015_GET_ERP_SO_NO_CNT |
| button:SaveButton | … > GetERPInterface > GetShipmentStatusChk | 7210 | `SSP.SSP0015_GET_SHIPMENT_STATUS` | SSP0015_GET_SHIPMENT_STATUS |
| button:SaveButton | … > GetERPInterface > ChkConfirmChangeTime | 9875 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| button:SaveButton | … > SoNo > GetErpIFCheckNew | 7363 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | 동일 |
| button:SaveButton | … > SoNo > GetErpIFCheckNew | 7389/7419 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| button:SaveButton | SaveData_Detail_Packer > FindData_Detail_Packer_btnSearch (> InitSpread > GetSpdTitle) | 3439 / 9247 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` / `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 동일 |
| event:this.btnButtonList.UsrButtonList_Click_Detected (팝업) | btnButtonList_UsrButtonList_Click_Detected > SaveData | 333 | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 동일 |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail_Packer_btnSearch | 3439 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` | 동일 |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Detail_btnSearch | 3705 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` | 동일 |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_WHstock | 3850 | `SSP.SSP0015_GET_WH_STOCK` | SSP0015_GET_WH_STOCK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_BolckStockDetail_btnSearch | 4193 | `SSP.SSP0015_GET_BLOCK_STOCK` | SSP0015_GET_BLOCK_STOCK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_shtStockLocationDetail_btnSearch (> GetNERPCode) | 4337 / 2904 | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` / `SSP.SSP0002_GET_NERP_CODE` | 동일 |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_ScsStock_btnSearch | 4437 | `SSP.SSP0015_GET_SCS_STOCK` | SSP0015_GET_SCS_STOCK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_MesStock_btnSearch | 4528 | `SSP.SSP0015_GET_MES_STOCK` | SSP0015_GET_MES_STOCK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Request_Detail | 4640 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` | SSP0026_GET_REQUEST_DETAIL_PACK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_WHinPlanDetail_btnSearch | 4723 | `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` | SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_ShipmentSCSResult_btnSearch (> InitSpread > GetSpdTitle) | 4832 / 9247 | `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` / `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 동일 |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_ShipmentResult_btnSearch | 4944 | `SSP.SSP0015_GET_SHIPMENT_RESULT` | SSP0015_GET_SHIPMENT_RESULT |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Main | 2536 | `SSP.SSP0015_GET_SHIPMENT_PSI` | 동일 |
| event:this.spdMain.CellDoubleClick | > FindData_Detail | 3165/3303 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` | 동일 |
| event:this.spdMain.CellDoubleClick | > FindData_WHstock | 3850 | `SSP.SSP0015_GET_WH_STOCK` | 동일 |
| event:this.spdMain.CellDoubleClick | > FindData_mes_stock | 3966 | `SSP.SSP0015_GET_MES_STOCK` | 동일 |
| event:this.spdMain.CellDoubleClick | > FindData_block_stock | 4070 | `SSP.SSP0015_GET_BLOCK_STOCK` | 동일 |
| event:this.spdMain.CellDoubleClick | > FindData_shtStockLocationDetail_btnSearch (> GetNERPCode, > InitSpread > GetSpdTitle) | 4337 / 2904 / 9247 | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` / `SSP.SSP0002_GET_NERP_CODE` / `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 동일 |
| event:this.spdMain.CellDoubleClick | > FindData_ScsStock_btnSearch | 4437 | `SSP.SSP0015_GET_SCS_STOCK` | 동일 |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged | 1400/1452 | `biz:CommonData.CommonDataList` [code=LookupCommon] | – |
| event:this.spdMain.ActiveSheetChanged | > SetChangedControl (> GetDayRange) | 2202/2210/2218 / 9289 | `biz:CommonData.CommonDataList` [code=PlanDateShip] / `SCP.SCM0001_GET_SCP_DAY_PERIOD` | – / 동일 |
| event:this.spdMain.ActiveSheetChanged | > InitSpread > GetSpdTitle | 9247 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 동일 |
| event:this.spdDetail.CellClick | SpdDetail_CellClick | 8583 | `biz:CommonData.CommonDataList` [code=TransMode] | – |
| event:this.spdDetail.CellClick | SpdDetail_CellClick | 8604 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | – |
| event:spdDetail.ClipboardPasted | SpdDetail_ClipboardPasted | 8954 | `biz:CommonData.CommonDataList` [code=TransMode] | – |
| unreached (진입점 미연결) | GetErpIFCheck | 7285 | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING |
| unreached | GetErpIFCheckNew_ | 9731 | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | 동일 |
| unreached | SCM_SYS_LOG_BATCH | 7876 | `SCP.PR_SCM_SYS_LOG_BATCH` | PR_SCM_SYS_LOG_BATCH |
| unreached | GetDivision | 9192 | `SCM.SCM0001_GET_DIVISION` | SCM0001_GET_DIVISION |
| unreached | SetChangedPeriod | 9207/9211 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] / [code=PERIOD2_{p:value}] | – |
| unreached | NewNonSoNo | 9611/9615 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | 동일 |

- **unreached**는 정적 파서가 진입점에서 이어지는 호출 경로를 찾지 못했다는 뜻이다. 실제로 쓰이지 않는 코드인지, 리플렉션이나 다른 경로로 불리는지는 **확인 필요**하다.
- FindButton과 EditButton과 SaveButton은 프레임워크 버튼이다. FindButton 안에서 FindData_Main, FindData_Main_Packer, FindData_Main_Packer_Past 중 무엇을 고르는지는 분기 조건이 Fact Pack에 없어 **확인 필요**하다.

## 3. 엔드포인트 전체 표 (39종)

| # | 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블과 EXEC 체인 (요약) |
|---:|---|---|---:|---|---|
| 1 | `biz:CommonData.CommonDataList` (code=PlanDateShip / LookupCommon / TransMode / ShipToCodeByDivision / PERIOD_{p:value} / PERIOD2_{p:value}) | BIZ_MATCH | 6+2+2+1+1+1 = 13 | UP_FX_GetCommonDataList (코드분기) | PlanDateShip: SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_PLAN_P, SSP_PLAN_VERSION_V, STRING_SPLIT / LookupCommon: SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL / TransMode: SCP_MST_BOD_V / ShipToCodeByDivision: SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE / PERIOD_*, PERIOD2_*: DB 보강 없음(확인 필요) |
| 2 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL |
| 3 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` | MATCH | 1 | SSP0015_GET_SHIPMENT_PSI_PACKER_PAST | SCM_MST_TITLESET_USER, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SSP_ANL_SHIP_PLAN_P, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_CODE_LOOKUP_VALUE, #TMP_*, 동적 SQL |
| 4 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` | MATCH | 1 | SSP0015_GET_SHIPMENT_PSI_PACKER | SSP_ANL_SHIP_REQ_P, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE, SCM_DNM_SCS_PROD_PLAN, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE, SCM_MST_TITLESET_USER, #TMP_*, 동적 SQL |
| 5 | `SSP.SSP0015_GET_SHIPMENT_PSI` | MATCH | 1 | SSP0015_GET_SHIPMENT_PSI | SSP_ANL_SHIP_PLAN_40, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, DM_PLN_SHIPMENT_REQ, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_MES_FCS_STOCK_40_C, SCP_MST_FINAL_ITEM, SSP_ANL_OWMS_STOCK_C, SSP_ANL_TCO_STOCK_C, SSP_ANL_HOLD_STOCK, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_MST_SITE, … / EXEC SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| 6 | `SSP.SSP0002_GET_NERP_CODE` | MATCH | 1 | SSP0002_GET_NERP_CODE | SCM_CODE_LOOKUP_VALUE |
| 7 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` | MATCH | 3 | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL | FN_GET_IN_STR, FN_SCM_SPLIT, 동적 SQL (내부 테이블은 동적 SQL이라 확인 필요) |
| 8 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` | MATCH | 1 | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | FN_GET_IN_STR, FN_SCM_SPLIT, 동적 SQL (확인 필요) |
| 9 | `SSP.SSP0015_GET_WH_STOCK` | MATCH | 1 | SSP0015_GET_WH_STOCK | SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_ITEM_SN |
| 10 | `SSP.SSP0015_GET_MES_STOCK` | MATCH | 2 | SSP0015_GET_MES_STOCK | SSP_ANL_MES_FCS_STOCK_40_C, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SCM_MST_ITEM_SN |
| 11 | `SSP.SSP0015_GET_BLOCK_STOCK` | MATCH | 2 | SSP0015_GET_BLOCK_STOCK | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN |
| 12 | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` | MATCH | 1 | SSP0015_GET_STOCK_LOCATION_DETAIL | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_MST_SLOC, SCM_DNM_STOCK_V, SCM_MST_ITEM_SN, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_CODE_LOOKUP_VALUE |
| 13 | `SSP.SSP0015_GET_SCS_STOCK` | MATCH | 1 | SSP0015_GET_SCS_STOCK | SCM_DNM_SCS_STOCK, SCM_MST_SITE, SSP_MST_MODEL_USER, SSP_MST_DELEGATE |
| 14 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` | MATCH | 1 | SSP0026_GET_REQUEST_DETAIL_PACK | 동적 SQL만 추출됨 (확인 필요) |
| 15 | `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` | MATCH | 1 | SSP0015_GET_SHIPMENT_PSI_COMMENTS | FN_GET_IN_STR, FN_SCM_SPLIT, 동적 SQL (확인 필요) |
| 16 | `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` | MATCH | 1 | SSP0015_GET_SHIPMENT_RESULT_PACKER | SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_P, SCP_MST_BOD_N_V, SCM_MST_CUSTOMER, SCM_MST_ITEM_SN, … |
| 17 | `SSP.SSP0015_GET_SHIPMENT_RESULT` | MATCH | 1 | SSP0015_GET_SHIPMENT_RESULT | SCM_DNM_EXFACTORY_RESULT, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SSP_ANL_SHIP_CONFIRM, SCP_MST_FINAL_ITEM, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, … |
| 18 | `SSP.SSP0015_SAVE_SHIPMENT_PSI` | MATCH | 1 | SSP0015_SAVE_SHIPMENT_PSI | UPDATE SSP_ANL_SHIP_PLAN_40, SSP_ANL_SHIP_PLAN_40_WH_IN_CMT(U/I), INSERT …_WH_IN_CMT_H, …_WH_IN_H, SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 19 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` | MATCH | 1 | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | SSP_ANL_SHIP_CONFIRM(U/I), SSP_ANL_SHIP_CONFIRM_H, XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN, SSP_MST_SEND_MAIL_REQ / EXEC PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SCM_SYS_LOG_BATCH(_CALL_TRAN) |
| 20 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | MATCH | 1 | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | SSP_ANL_SHIP_CONFIRM(U/I), _H, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SSP_ANL_SHIP_PLAN_40(D/I), DM_PLN_MKT_FCST_CONFIRM / EXEC PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| 21 | `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` | MATCH | 1 | SSP0015_SAVE_BLOCK_STOCK_DATA | SSP_ANL_HOLD_STOCK(S/U/I), SCM_SYS_LOG_BATCH |
| 22 | `SSP.SSP0015_SAVE_MES_STOCK` | MATCH | 2 | SSP0015_SAVE_MES_STOCK | MERGE SSP_ANL_MES_FCS_STOCK_40_C, MERGE SSP_ANL_SHIP_PLAN_40, #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP |
| 23 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH | 1 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE) |
| 24 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH | 2 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 |
| 25 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 3 | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCP_SYS_LOG_BATCH |
| 26 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | MATCH | 3 | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER |
| 27 | `SSP.SSP0015_GET_ERP_SO_NO_CNT` | MATCH | 1 | SSP0015_GET_ERP_SO_NO_CNT | SSP_ANL_SHIP_CONFIRM |
| 28 | `SSP.SSP0015_GET_SHIPMENT_STATUS` | MATCH | 1 | SSP0015_GET_SHIPMENT_STATUS | SSP_ANL_SHIP_CONFIRM, STRING_SPLIT |
| 29 | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 2 (모두 unreached) | SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE) |
| 30 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH | 2 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, NERP_CONV_MASTER, DM_PLN_MKT_FCST / EXEC PR_SCP_SYS_LOG_BATCH |
| 31 | `SCP.PR_SCM_SYS_LOG_BATCH` | MATCH | 1 (unreached) | PR_SCM_SYS_LOG_BATCH | INSERT SCM_SYS_LOG_BATCH |
| 32 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | MATCH | 1 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL |
| 33 | `SCM.SCM0001_GET_DIVISION` | MATCH | 1 (unreached) | SCM0001_GET_DIVISION | SCM_MST_DIVISION |
| 34 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M |
| 35 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | MATCH | 1 | SCM0001_GET_SCP_DAY_PERIOD | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL, FN_MULTY_TIME, FN_WEEKOFDAY_DATE, CTE_DATE |
| 36 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | MATCH | 1 | SSP0202_GET_SCS_CONFIRM_ID_CHECK | SCM_ADM_LOOKUP_MASTER_DETAIL, 동적 SQL |
| 37 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | MATCH | 1 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_SYS_LOG_BATCH |
| 38 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | 1 | SSP0002_GET_USER_INFO_LIST | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION |
| 39 | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | MATCH | 1 (팝업) | SSP0015_SAVE_SHIPMENT_PSI_COMMENTS | UPDATE SSP_ANL_SHIP_PLAN_40, SSP_ANL_SHIP_PLAN_40_WH_IN_CMT(U/I), …_WH_IN_CMT_H, …_WH_IN_H |

- `biz:CommonData.CommonDataList`는 code 값 6가지(13곳)를 엔드포인트 1종으로 묶어 39종에 포함했다.
- 동적 SQL(`DYNAMIC@…`)을 쓰는 SP는 7개다: CONFIRM_DETAIL, CONFIRM_DETAIL_PACKER, PSI, PSI_PACKER, PSI_PACKER_PAST, PSI_COMMENTS, SSP0026_GET_REQUEST_DETAIL_PACK, SSP0202_GET_SCS_CONFIRM_ID_CHECK. 이 SP들이 실제로 참조하는 테이블은 정적으로 다 뽑히지 않아 **확인 필요**하다.

## 4. 이벤트 배선 표 (34건)

| # | 대상 | 이벤트 | 핸들러 | 위치 |
|---:|---|---|---|---|
| 1 | this.spdMain | TextTipFetch | `spdMain_TextTipFetch` | Designer InitializeComponent:906 |
| 2 | this | Load | `Form_Load` | .ctor:422 |
| 3 | this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:1159 |
| 4 | this.spdMain | TopChange | `SpdMain_TopChange` | InitEvent:1161 |
| 5 | this.spdDetail | TopChange | `SpdDetail_TopChange` | InitEvent:1162 |
| 6 | this.btnMeasure | Click | `btnMeasure_Click` | InitEvent:1164 |
| 7 | this.cboBucketType | SelectedIndexChanged | `cboBucketType_SelectedIndexChanged` | InitEvent:1165 |
| 8 | this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitEvent:1166 |
| 9 | this.btnItemId | Click | `btnItemId_Click` | InitEvent:1167 |
| 10 | this.btnItemID2 | Click | `BtnItemID2_Click` | InitEvent:1168 |
| 11 | this.btnSearch | Click | `BtnSearch_Click` | InitEvent:1169 |
| 12 | this.btnRequestor | Click | `BtnRequestor_Click` | InitEvent:1170 |
| 13 | this.spdDetail | CellClick | `SpdDetail_CellClick` | InitEvent:1172 |
| 14 | this.spdDetail | ComboSelChange | `spdDetail_ComboSelChange` | InitEvent:1173 |
| 15 | this.spdDetail | SheetTabClick | `SpdDetail_SheetTabClick` | InitEvent:1174 |
| 16 | this.spdDetail | CellDoubleClick | `SpdDetail_CellDoubleClick` | InitEvent:1175 |
| 17 | this.spdMain | ActiveSheetChanged | `SpdMain_ActiveSheetChanged` | InitEvent:1177 |
| 18 | clbDivision | SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | InitEvent:1179 |
| 19 | cboPlanDate | SelectedIndexChanged | `CboPlanDate_SelectedIndexChanged` | InitEvent:1180 |
| 20 | spdDetail | ActiveSheetChanged | `SpdDetail_ActiveSheetChanged` | InitEvent:1181 |
| 21 | spdDetail | EditChange | `SpdDetail_EditChange` | InitEvent:1182 |
| 22 | spdDetail | ClipboardPasted | `SpdDetail_ClipboardPasted` | InitEvent:1183 |
| 23 | spdMain | EditModeOn | `SpdMain_EditModeOn` | InitEvent:1186 |
| 24 | spdMain | CellClick | `SpdMain_CellClick` | InitEvent:1187 |
| 25 | dsdm | Changed | `shtDetail_Change` | InitEvent:1190 |
| 26 | this.txtGap_Qty (팝업) | TextChanged | `txtGap_Qty_TextChanged` | Popup.Designer:192 |
| 27 | this.txtBefore_Qty (팝업) | TextChanged | `txtBefore_Qty_TextChanged` | Popup.Designer:227 |
| 28 | this.txtProd_Qty (팝업) | TextChanged | `txtProd_Qty_TextChanged` | Popup.Designer:262 |
| 29 | this.txtWHin_Qty (팝업) | TextChanged | `txtWHin_Qty_TextChanged` | Popup.Designer:297 |
| 30 | this.txtCurrent_Qty (팝업) | TextChanged | `txtCurrent_Qty_TextChanged` | Popup.Designer:474 |
| 31 | this.txtChange_Qty (팝업) | TextChanged | `txtChange_Qty_TextChanged` | Popup.Designer:509 |
| 32 | this.txtChange_Qty (팝업) | KeyPress | `txtChange_Qty_KeyPress` | Popup.Designer:510 |
| 33 | this.btnButtonList (팝업) | UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | Popup.Designer:657 |
| 34 | this (팝업) | Load | `Form_Load` | Popup.cs .ctor:207 |

- 엔드포인트 호출이 추출되지 않은 핸들러가 있다. 무엇을 하는지는 각 핸들러 본문을 직접 봐야 해서 **확인 필요**하다.
  - `spdMain_TextTipFetch`, `SpdMain_TopChange`, `SpdDetail_TopChange`, `cboBucketType_SelectedIndexChanged`, `chkSum_CheckedChanged`
  - `btnItemId_Click`, `BtnItemID2_Click`, `BtnRequestor_Click`
  - `spdDetail_ComboSelChange`, `SpdDetail_SheetTabClick`, `SpdDetail_CellDoubleClick`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_EditChange`
  - `SpdMain_EditModeOn`, `SpdMain_CellClick`, `shtDetail_Change`
  - 팝업의 txt*_TextChanged 계열과 `txtChange_Qty_KeyPress`
- SaveButton 경로에는 팝업 `SaveData`(333줄)도 있다. 파서가 본 화면 SaveButton과 팝업 SaveData를 하나의 경로로 묶은 것이다. 본 화면 SaveButton이 정말 팝업 저장을 부르는지는 **확인 필요**하다. 4-2장 기준으로 SaveButton:271과 팝업:430은 `PersonalSettingPopup.SaveData`로 해석돼 있어 이름이 충돌한다.

## 5. Grid 구성 방식과 division별 차이

- 구성 방식은 `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`이다.
  - **META**: `SpreadInfo.SetSheetHeaderColumn`이 SCM_MST_SHEET_COLUMNS에서 컬럼을 만든다. 호출 위치는 InitSpread:759, 786, 811, 826, 853, 866, 879, 892, 905, 918이고, grid_code.csv 기준으로는 941, 967, 978도 있다.
  - **DB루프**: 화면에 정의된 `InitSpreadDateColumn`이 `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과(dsSpdTitle)를 돌면서 날짜 컬럼을 추가한다.
    - `COLUMN_NAME`에 `B_`가 들어가면 AddTextColumn(폭 0, 숨김, 1110줄)을 쓴다.
    - 그 밖에는 AddNumColumn(폭 70, 표시, 1114줄)을 쓴다.
    - 토요일과 일요일 컬럼은 ForeColor를 바꾼다. SAT는 Blue, 그 밖(SUN)은 Red다(1118줄).
    - 3단 헤더(LARGE_CLASS/SMALL_CLASS 라벨)를 ColumnHeaderSpan으로 묶고 "SUM" 헤더를 넣는다(1125~1154줄).
  - **코드 표시 변경**: `SetSpreadColumn`이 cboBucketType 값(DAILY/WEEKLY/MONTHLY)과 chkSum에 따라 컬럼 Tag 접두어 `D_`/`W_`/`M_` 컬럼의 Visible을 바꾼다(2116~2148줄).
    - DAILY: D_와 W_ 컬럼에 Visible=true를 준다. M_와 W_ 컬럼은 Visible=chkSum이다.
    - WEEKLY: D_ 컬럼은 숨긴다. W_ 컬럼은 표시한다. M_ 컬럼은 Visible=chkSum이다.
    - MONTHLY: D_와 W_ 컬럼은 숨긴다. M_ 컬럼은 표시한다.
    - 같은 W_ 컬럼에 true와 chkSum 대입이 둘 다 걸리는데, 실행 순서에 따른 최종 값은 **확인 필요**하다.
  - **MergePolicy.Always**: Shipment PSI(Mobility & IT) 시트(776/778줄)와 Shipment PSI(Packer) 시트(803/805줄)에 적용된다.
  - **SetSoNoColumnVisible**: ichkbtn과 시트명(Shipment PSI(Packer) 여부)에 따라 SO No 계열 컬럼 Width를 80 또는 0으로 바꾼다(9778~9793줄). 대상 컬럼명은 **확인 필요**하다.
  - **FindData_Detail 계열의 Visible=false**: 3218~3221, 3356~3359, 3491~3493, 3758~3761줄이다. 대상 컬럼은 추출되지 않아 **확인 필요**하다.
  - **FindData_ShipmentResult_btnSearch**: `SHIP_TO`와 `SHIPTO_DESCRIPTION`을 숨긴다(4991/4992줄).
- **division별 차이: 없다.** grid_effective 기준으로 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)의 시트별 표시 컬럼 수가 모두 같다. 메타에 DIVISION_ID별로 다른 행이 없다.
- 실제 SP 실행 결과와 매칭되는 시트가 없다. Fact Pack 10장 기준으로 grid 단계가 실행되지 않았거나 시트명이 맞지 않았다. 그래서 SP가 돌려주는 컬럼과 메타가 맞는지는 **확인 필요**하다.

## 6. 확인 필요 항목

1. FindButton에서 FindData_Main, FindData_Main_Packer, FindData_Main_Packer_Past를 고르는 분기 조건(활성 시트 또는 기간 조건 등).
2. unreached 메서드 6개가 실제로 쓰이는지: GetErpIFCheck, GetErpIFCheckNew_, SCM_SYS_LOG_BATCH, GetDivision, SetChangedPeriod, NewNonSoNo.
3. 메타에만 있고 코드가 참조하지 않는 시트 2개의 용도: `Shipment PSI(IT & Mobile)`, `MES Stock Detail`. 프로그램 `SSP0015_TEMP2`의 Shipment Confirm Detail(31/0) 메타 행의 용도도 같이 확인해야 한다.
4. grid_effective에서 `SHIP_TO`와 `SHIPTO_DESCRIPTION`의 →숨김이 거의 모든 시트에 붙어 있다. 원 코드(4991/4992줄)는 FindData_ShipmentResult_btnSearch 안에 있다. 파서가 시트 연결을 넓게 잡았을 수 있다.
5. W/H stock Detail 시트를 조회하는 메서드와 엔드포인트가 추출되지 않았다.
6. 동적 SQL SP의 실제 참조 테이블.
7. EditButton의 PlanDateShip 공통코드 재조회(1753/1757줄)와 GetSSPUserCheck가 어떤 조건에서 편집을 허용하는지.
8. legacy와 current 파일의 차이.
9. Fact Pack 7장의 확인 필요 항목은 0건으로 보고됐다. 위 항목은 이 문서를 쓰면서 새로 찾은 미확정 사항이다.

## 7. 주석 처리된 호출 (집계 제외)

| 줄 | 값 | 비고 |
|---:|---|---|
| 3573 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | 주석 처리됨 (같은 SP의 활성 호출은 3439줄) |
| 9288 | SCP.GET_DATE_RANGE_1MONTH | 주석 처리됨 |
| 9308 | SCP.GET_DATE_RANGE_1MONTH | 주석 처리됨 |
| 9309 | SCP.SCM0001_GET_SCP_PERIOD | 주석 처리됨 |

=== FILE: source_links.md ===
# SSP0015 소스 링크 (파일·줄 기준)

경로 약어:
- **[S]** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.cs`
- **[SD]** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.Designer.cs`
- **[P]** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSICommentsPopup.cs`
- **[PD]** = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSICommentsPopup.Designer.cs`

## 1. 엔드포인트 호출 지점 (63곳, endpoints.csv 전체)

| # | 파일 | 메서드 | 줄 | 내용 |
|---:|---|---|---:|---|
| 1 | [S] | InitControls | 568 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 2 | [S] | SpdMain_ActiveSheetChanged | 1400 | biz:CommonData.CommonDataList [code=LookupCommon] |
| 3 | [S] | SpdMain_ActiveSheetChanged | 1452 | biz:CommonData.CommonDataList [code=LookupCommon] |
| 4 | [S] | EditButton | 1753 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 5 | [S] | EditButton | 1757 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 6 | [S] | GetBucketType | 2162 | DM.DM0003_GET_BUCKET_TYPE_CODE |
| 7 | [S] | SetChangedControl | 2202 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 8 | [S] | SetChangedControl | 2210 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 9 | [S] | SetChangedControl | 2218 | biz:CommonData.CommonDataList [code=PlanDateShip] |
| 10 | [S] | FindData_Main_Packer_Past | 2293 | SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST |
| 11 | [S] | FindData_Main_Packer | 2412 | SSP.SSP0015_GET_SHIPMENT_PSI_PACKER |
| 12 | [S] | FindData_Main | 2536 | SSP.SSP0015_GET_SHIPMENT_PSI |
| 13 | [S] | GetNERPCode | 2904 | SSP.SSP0002_GET_NERP_CODE |
| 14 | [S] | FindData_Detail | 3165 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| 15 | [S] | FindData_Detail | 3303 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| 16 | [S] | FindData_Detail_Packer_btnSearch | 3439 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER |
| 17 | [S] | FindData_Detail_btnSearch | 3705 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL |
| 18 | [S] | FindData_WHstock | 3850 | SSP.SSP0015_GET_WH_STOCK |
| 19 | [S] | FindData_mes_stock | 3966 | SSP.SSP0015_GET_MES_STOCK |
| 20 | [S] | FindData_block_stock | 4070 | SSP.SSP0015_GET_BLOCK_STOCK |
| 21 | [S] | FindData_BolckStockDetail_btnSearch | 4193 | SSP.SSP0015_GET_BLOCK_STOCK |
| 22 | [S] | FindData_shtStockLocationDetail_btnSearch | 4337 | SSP.SSP0015_GET_STOCK_LOCATION_DETAIL |
| 23 | [S] | FindData_ScsStock_btnSearch | 4437 | SSP.SSP0015_GET_SCS_STOCK |
| 24 | [S] | FindData_MesStock_btnSearch | 4528 | SSP.SSP0015_GET_MES_STOCK |
| 25 | [S] | FindData_Request_Detail | 4640 | SSP.SSP0026_GET_REQUEST_DETAIL_PACK |
| 26 | [S] | FindData_WHinPlanDetail_btnSearch | 4723 | SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| 27 | [S] | FindData_ShipmentSCSResult_btnSearch | 4832 | SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER |
| 28 | [S] | FindData_ShipmentResult_btnSearch | 4944 | SSP.SSP0015_GET_SHIPMENT_RESULT |
| 29 | [S] | SaveData_Main | 5412 | SSP.SSP0015_SAVE_SHIPMENT_PSI |
| 30 | [S] | SaveData_Detail_Packer | 5602 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER |
| 31 | [S] | SaveData_Detail | 5841 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| 32 | [S] | SaveData_Detail | 6011 | SSP.SSP0015_SAVE_BLOCK_STOCK_DATA |
| 33 | [S] | SaveData_Detail | 6112 | SSP.SSP0015_SAVE_MES_STOCK |
| 34 | [S] | SaveData_Detail | 6219 | SSP.SSP0015_SAVE_MES_STOCK |
| 35 | [S] | GetERPInterface | 6665 | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| 36 | [S] | GetERPInterface | 6706 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| 37 | [S] | NonSoNo | 6843 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| 38 | [S] | NonSoNo | 6847 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| 39 | [S] | SoNo | 7076 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| 40 | [S] | SoNo | 7080 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| 41 | [S] | GetErpSoNoCnt | 7185 | SSP.SSP0015_GET_ERP_SO_NO_CNT |
| 42 | [S] | GetShipmentStatusChk | 7210 | SSP.SSP0015_GET_SHIPMENT_STATUS |
| 43 | [S] | GetErpIFCheck (unreached) | 7285 | SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING |
| 44 | [S] | GetErpIFCheckNew | 7363 | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| 45 | [S] | GetErpIFCheckNew | 7389 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| 46 | [S] | GetErpIFCheckNew | 7419 | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| 47 | [S] | SCM_SYS_LOG_BATCH (unreached) | 7876 | SCP.PR_SCM_SYS_LOG_BATCH |
| 48 | [S] | EngProcessingChk | 7903 | SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| 49 | [S] | SpdDetail_CellClick | 8583 | biz:CommonData.CommonDataList [code=TransMode] |
| 50 | [S] | SpdDetail_CellClick | 8604 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] |
| 51 | [S] | SpdDetail_ClipboardPasted | 8954 | biz:CommonData.CommonDataList [code=TransMode] |
| 52 | [S] | GetDivision (unreached) | 9192 | SCM.SCM0001_GET_DIVISION |
| 53 | [S] | SetChangedPeriod (unreached) | 9207 | biz:CommonData.CommonDataList [code=PERIOD_{p:value}] |
| 54 | [S] | SetChangedPeriod (unreached) | 9211 | biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] |
| 55 | [S] | GetSpdTitle | 9247 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN |
| 56 | [S] | GetDayRange | 9289 | SCP.SCM0001_GET_SCP_DAY_PERIOD |
| 57 | [S] | NewNonSoNo (unreached) | 9611 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING |
| 58 | [S] | NewNonSoNo (unreached) | 9615 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| 59 | [S] | GetErpIFCheckNew_ (unreached) | 9731 | SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING |
| 60 | [S] | chkSaveYN | 9821 | SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| 61 | [S] | ChkConfirmChangeTime | 9875 | SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| 62 | [S] | GetSSPUserCheck | 9901 | SSP.SSP0002_GET_USER_INFO_LIST |
| 63 | [P] | SaveData | 333 | SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |

## 2. 주석 처리된 호출 (집계 제외)

| 파일 | 줄 | 내용 |
|---|---:|---|
| [S] | 3573 | SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER — 주석 처리됨 |
| [S] | 9288 | SCP.GET_DATE_RANGE_1MONTH — 주석 처리됨 |
| [S] | 9308 | SCP.GET_DATE_RANGE_1MONTH — 주석 처리됨 |
| [S] | 9309 | SCP.SCM0001_GET_SCP_PERIOD — 주석 처리됨 |

## 3. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [SD] | InitializeComponent | 906 | spdMain.TextTipFetch += spdMain_TextTipFetch |
| [S] | .ctor | 422 | Load += Form_Load |
| [S] | InitEvent | 1159 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| [S] | InitEvent | 1161 | spdMain.TopChange += SpdMain_TopChange |
| [S] | InitEvent | 1162 | spdDetail.TopChange += SpdDetail_TopChange |
| [S] | InitEvent | 1164 | btnMeasure.Click += btnMeasure_Click |
| [S] | InitEvent | 1165 | cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged |
| [S] | InitEvent | 1166 | chkSum.CheckedChanged += chkSum_CheckedChanged |
| [S] | InitEvent | 1167 | btnItemId.Click += btnItemId_Click |
| [S] | InitEvent | 1168 | btnItemID2.Click += BtnItemID2_Click |
| [S] | InitEvent | 1169 | btnSearch.Click += BtnSearch_Click |
| [S] | InitEvent | 1170 | btnRequestor.Click += BtnRequestor_Click |
| [S] | InitEvent | 1172 | spdDetail.CellClick += SpdDetail_CellClick |
| [S] | InitEvent | 1173 | spdDetail.ComboSelChange += spdDetail_ComboSelChange |
| [S] | InitEvent | 1174 | spdDetail.SheetTabClick += SpdDetail_SheetTabClick |
| [S] | InitEvent | 1175 | spdDetail.CellDoubleClick += SpdDetail_CellDoubleClick |
| [S] | InitEvent | 1177 | spdMain.ActiveSheetChanged += SpdMain_ActiveSheetChanged |
| [S] | InitEvent | 1179 | clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged |
| [S] | InitEvent | 1180 | cboPlanDate.SelectedIndexChanged += CboPlanDate_SelectedIndexChanged |
| [S] | InitEvent | 1181 | spdDetail.ActiveSheetChanged += SpdDetail_ActiveSheetChanged |
| [S] | InitEvent | 1182 | spdDetail.EditChange += SpdDetail_EditChange |
| [S] | InitEvent | 1183 | spdDetail.ClipboardPasted += SpdDetail_ClipboardPasted |
| [S] | InitEvent | 1186 | spdMain.EditModeOn += SpdMain_EditModeOn |
| [S] | InitEvent | 1187 | spdMain.CellClick += SpdMain_CellClick |
| [S] | InitEvent | 1190 | dsdm.Changed += shtDetail_Change |
| [PD] | InitializeComponent | 192 | txtGap_Qty.TextChanged |
| [PD] | InitializeComponent | 227 | txtBefore_Qty.TextChanged |
| [PD] | InitializeComponent | 262 | txtProd_Qty.TextChanged |
| [PD] | InitializeComponent | 297 | txtWHin_Qty.TextChanged |
| [PD] | InitializeComponent | 474 | txtCurrent_Qty.TextChanged |
| [PD] | InitializeComponent | 509 | txtChange_Qty.TextChanged |
| [PD] | InitializeComponent | 510 | txtChange_Qty.KeyPress |
| [PD] | InitializeComponent | 657 | btnButtonList.UsrButtonList_Click_Detected |
| [P] | .ctor | 207 | Load += Form_Load |

## 4. 프레임워크 메타 소비 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---|---|
| [S] | SetChangeControl | 456, 461, 466, 471, 476, 481, 486, 491 | DataService.GetSSPInnerTable |
| [S] | InitControls | 534, 545 | DataService.FP_Log2 |
| [S] | InitSpread | 753 | SpreadInfo.GetSpdTitle |
| [S] | InitSpread | 759, 786, 811, 826, 853, 866, 879, 892, 905, 918 (grid_code.csv: 941, 967, 978) | SpreadInfo.SetSheetHeaderColumn |
| [S] | InitSpread | 766, 793 | InitSpreadDateColumn (화면에서 직접 정의) |
| [S] | SpdMain_ActiveSheetChanged:1357, EditButton:1749/1761/1805/1842, SetChangedControl:2188, FindData_Main_Packer_Past:2253/2255 | – | CString.GetCheckedListValue |
| [S] / [P] | SaveButton:271 / btnButtonList_UsrButtonList_Click_Detected:430 | – | SaveData (PersonalSettingPopup.SaveData로 해석됨, 확인 필요) |

## 5. Grid 코드 정의 주요 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| [S] | CreateSpread | 656, 660 | spdMain AddSheet: Shipment PSI(Mobility & IT), Shipment PSI(Packer) |
| [S] | CreateSpread | 665~683 | spdDetail AddSheet 11개 (WH In Plan Detail은 680줄 `if(drPgmAuthId != null)`) |
| [S] | InitSpreadDateColumn | 1110 / 1114 / 1118 | 날짜 컬럼 DB루프 / 토·일 색상 |
| [S] | SetSpreadColumn | 2116~2148 | Bucket과 Sum에 따른 컬럼 표시 |
| [S] | FindData_ShipmentResult_btnSearch | 4991 / 4992 | SHIP_TO / SHIPTO_DESCRIPTION 숨김 |
| [S] | SpdDetail_CellClick | 8618 / 8653 / 8657 | 헤더 체크박스 전체 선택 토글 |
| [S] | SetSoNoColumnVisible | 9778~9793 | Width 80 또는 0 |

=== FILE: web_components.md ===
# SSP0015 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → React/Wijmo 매핑

라벨은 props.csv의 원문이다. LayoutControlItem.Text 또는 컨트롤 Text를 그대로 옮겼다. props.csv가 일부 잘린 탓에 라벨을 못 찾은 항목은 **확인 필요**로 적었다.

### 1-1. 조회조건 영역 (usrConditionPanel1 > usrLayoutControl2)

| 컨트롤 | AS-IS 유형 | 라벨(원문) | Size | TO-BE 후보 |
|---|---|---|---|---|
| clbDivision | UsrCombo (이름은 clb지만 유형은 Combo) | `Division*` (lblCombo1) | 162×20 | ComboBox (필수) |
| cboPlanDate | UsrCombo | `Plan-date*` (PlanDate) | 150×20 | ComboBox (필수) |
| drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | 205×20 | DateRange (InputDate 2개) |
| cboBucketType | UsrCombo | `Bucket` (lblBucket) | 137×20 | ComboBox |
| chkSum | UsrCheckBox | `Sum` | 84×25 | CheckBox |
| btnMeasure | UsrButton | 확인 필요 (Text 미추출) | 39×25 | Button (측정 항목 선택) |
| clbPlantSite | UsrCheckedList | `From Site` (layoutControlItem7) | 189×21 | MultiSelect |
| txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 100×21 | 멀티라인 입력 |
| btnItemId | UsrButton | 확인 필요 | 39×24 | Button (Model 팝업) |
| chkMyModel | UsrCheckBox | `My Model` (Checked=true, Visible=false) | 110×23 | 숨김 |
| chkPartLeader | UsrCheckBox | `Part Leader` (Visible=false) | 110×23 | 숨김 |
| chkTeamLeader | UsrCheckBox | `Team Leader` (Visible=false) | 110×23 | 숨김 |
| chkDelegateeModel | UsrCheckBox | `Delegatee Model` (Visible=false) | 136×23 | 숨김 |
| usrButton1 | UsrButton | 확인 필요 (부모 없음) | 75×23 | 확인 필요 |

### 1-2. 상세 영역 조회조건 (splitContainer1.Panel2 > usrLayoutControl3)

| 컨트롤 | AS-IS 유형 | 라벨(원문) | Size | TO-BE 후보 |
|---|---|---|---|---|
| clbResultType | UsrCheckedList | 확인 필요 | 104×21 | MultiSelect |
| txtRequestor | UsrTextBox | LayoutControlItem 이름은 `Requestor`, Text는 확인 필요 | 20×20 | Input |
| btnRequestor | UsrButton | 확인 필요 | 39×24 | Button (사용자 팝업) |
| txtModel2 | UsrMultiLineEditor | 확인 필요 | 264×21 | 멀티라인 입력 |
| btnItemID2 | UsrButton | 확인 필요 | 39×25 | Button (Model 팝업) |
| drpPeriod2 | UsrDateRangePicker | `Shipment Date` (layoutControlItem11) | 197×20 | DateRange |
| drpPeriod3 | UsrDateRangePicker | 확인 필요 | 197×20 | DateRange |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 207×21 | 멀티라인 입력 |
| btnSearch | DevExpress SimpleButton | `Search` | 47×25 | Button (상세 시트 조회) |

### 1-3. Grid

| 컨트롤 | AS-IS | TO-BE 후보 |
|---|---|---|
| spdMain | FpSpread (Panel1, Dock Fill, 1370×301) | Wijmo FlexGrid + 시트 탭 (PSI 시트 2개, 3단 헤더, 셀 병합) |
| spdDetail | FpSpread (Panel2, Dock Fill, 1370×225) | Wijmo FlexGrid + 시트 탭 (Detail 시트 11개) |

### 1-4. 팝업 SSP0015_ShipmentPSICommentsPopup

| 컨트롤 | AS-IS 유형 | 라벨 | TO-BE 후보 |
|---|---|---|---|
| txtGap_Qty, txtBefore_Qty, txtProd_Qty, txtWHin_Qty, txtCurrent_Qty, txtChange_Qty | UsrTextBox | 확인 필요 (props.csv 잘림) | Input (수량, txtChange_Qty는 KeyPress로 입력 제한 — 내용 확인 필요) |
| txtMeasure, txtFrom_Site, txtDivision_ID, txtDate, txtItem_ID, txtPlan_Date | UsrTextBox | 확인 필요 | 읽기전용 Input 후보 (ReadOnly 여부는 확인 필요) |
| rtxComments | RichTextBox | 확인 필요 | TextArea |
| usrLabel1 | UsrLabel | 확인 필요 | Label |
| btnButtonList | UsrButtonList | – | 버튼 그룹 (저장 → `SSP0015_SAVE_SHIPMENT_PSI_COMMENTS`) |

## 2. 화면 배치

| 영역 | 근거(props.csv) | 크기와 비율 |
|---|---|---|
| 조회조건 패널 | usrConditionPanel1: Dock=Top, Size 1370×79, UsrPanelType=HidePanel / usrLayoutControl2: Dock=Top, 1370×73 | 상단 고정 (높이 79) |
| 본문 분할 | splitContainer1: Dock=Fill, **Orientation=Horizontal**, Size 1370×570, **SplitterDistance=301** | **상/하 분할**. 상단 301 / 전체 570 = 약 52.8%. 하단은 나머지(약 47.2%)이며 스플리터 폭이 포함된다. 스플리터 폭은 미추출 |
| 상단 Panel1 | spdMain Dock=Fill, 1370×301 | Main Grid |
| 하단 Panel2 | usrLayoutControl3 Dock=Top 1370×40 + spdDetail Dock=Fill 1370×225 | 상세 조회조건(40) + Detail Grid(225) |

- 하단 내부 비율은 조회조건 40 : Grid 225이다(약 15% : 85%).
- 301 + 40 + 225 = 566이고, 570과의 차이 4는 스플리터 폭으로 보인다. 스플리터 폭이 미추출이라 이것도 **확인 필요**하다.

## 3. 시트별 Grid 컬럼

기준은 grid_effective.csv다. 모든 시트에서 14개 division의 값이 같아서 division별 표시 차이는 **없다**. "숨김"은 메타 VISIBLE_FLAG 기준이고, "→숨김"은 코드가 숨긴 것이다.

### 3-1. spdMain

#### `Shipment PSI(Mobility & IT)` — META+코드연결, 표시 10

- **표시(기본)**: DIVISION_ID(Div), FIGURE(Figure), FROM_SITE_NM(From Site), ITEM_ID(Model), LT_DAY(Aging L/T), MEASURE_NAME(Measure), NICK_NAME(Nick Name), PSI_NAME(PSI), TYPE(TYPE), YEILD(Yield(%))
- **숨김**: FROM_SITE(Site), LT_UPDATE_YN, MEASURE, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION (시트 연결이 맞는지 확인 필요, analysis.md 6장 4번)
- **코드 추가**:
  - 날짜 컬럼: InitSpreadDateColumn이 SCP0009_GET_SHEET_CALENDAR_3SPAN 결과로 만든다. `B_` 컬럼은 숨김 Text, 그 밖은 Num(폭 70)이며 SAT는 Blue, SUN은 Red다.
  - Bucket/Sum 표시 규칙: SetSpreadColumn(D_/W_/M_)
  - MergePolicy.Always
- **Measure 메타**: SCM_MST_SHEET_MEASURE 12/1 (필수 12, 선택 1)

#### `Shipment PSI(Packer)` — META+코드연결, 표시 8

- **표시**: DIVISION_ID(Div), FIGURE(Figure), FROM_SITE_NM(From Site), ITEM_ID(Model), MEASURE(Measure), NICK_NAME(Nick Name), PSI_NAME(PSI), TYPE(TYPE)
- **숨김**: FROM_SITE, LT_DAY, LT_UPDATE_YN, MEASURE_NAME, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN, YEILD
- **코드**:
  - 날짜 컬럼 DB루프, SetSpreadColumn, MergePolicy.Always
  - SetSoNoColumnVisible이 이 시트이면 Width 80 또는 0을 준다(ichkbtn에 따라 다름)
- **Measure 메타**: 6/0

#### `Shipment PSI(IT & Mobile)` — 메타 정의만 있고 코드는 참조하지 않음(미사용 가능), 메타상 표시 10

- 컬럼 구성은 Mobility & IT와 같고 라벨만 `Yeild(%)` 철자가 다르다.
- **Measure 메타**: 12/1
- 코드에서 AddSheet하지 않는다. TO-BE에 넣을지는 **확인 필요**하다.

### 3-2. spdDetail

#### `Shipment Confirm Detail` — META+코드연결, 표시 40 (메타 규칙 집계는 39/0)

- **표시**: ATTRIBUTE10, attribute3(PLM status), attribute6(OQC Result), CHANGE_REASON_CODE(Change Reason), CHANGE_REASON_DETAIL(Reason Detail), CHANGE_REQ_NO(Change Request No), CONFIRM_ID(Confirm/Plan ID), DIVISION_ID(Division), END_CUSTOMER(End Customer), ERP_SO_NO(SO No), ETA, ETD, Expected_Shipping_Date(Expected Shipping Date), FCST_TYPE(FCST Type), FROM_SITE_DESCRIPTION(From Site), INCOTERMS(Incoterms), ITEM_ID(Model), LT_DAY(L/T(Day)), MODEL_USER(Model PIC), MTK_OWNER(MKT Owner), NICK_NAME(Nick Name), REMARKS(Remarks), REMARKS2(Building), REMARKS3(Customer Requirement), REQUESTOR(Shipment Requestor), RTF3(RTF), RTF4(RTF ETD), RTF5(RTF QTY), RTF6(RTF Detail), SHIPMENT_CONFIRM_QTY(Shipment Qty), SHIPMENT_DATE(Shipment Date), SHIPMENT_STATUS(Status), SOLDTO_DESCRIPTION(Sold To Party), TEAM(Team), TO_SITE_DESCRIPTION(To Site), TO_SITE_SHIPTO_CODE(Ship to), TO_SITE_SOLDTO_CODE(Sold to), TRANSPORT_MODE(Trans Mode), UPDATED_BY(Updated By), UPDATED_DATE(Updated Date)
- **기본이지만 코드가 →숨김**: SHIPTO_DESCRIPTION(Ship To Party)
- **숨김**: BEFORE_QTY, BOD_ID, CHANGE_TYPE, CHECK_NEED_YN, CHK(ALL), EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE(Shipment Date*), NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PROJECT_CODE, PROJECT_NAME, TO_SITE
- **코드**:
  - FindData_Detail, FindData_Detail_btnSearch, FindData_Detail_Packer_btnSearch에 Visible=false가 있다. 대상 컬럼은 확인 필요하다.
  - SpdDetail_CellClick이 헤더 CheckBox로 전체를 선택하거나 해제한다.
  - TransMode와 ShipToCodeByDivision 콤보를 공통코드에서 채운다.
- 별도 메타 프로그램 `SSP0015_TEMP2`에 같은 이름의 시트(31/0)가 있다. 용도는 확인 필요하다.

#### `Shipment Request Detail` — META+코드연결, 표시 34

- **표시**: ATTRIBUTE3(RTF), ATTRIBUTE4(RTF ETD), ATTRIBUTE5(RTF QTY), ATTRIBUTE6(RTF Detail), BOD_ID, CHANGE_REQUEST_NO, DIVISION_ID(Div*), EDIT_FLAG, END_CUSTOMER, ETA_DATE(ETA), ETD_DATE(ETD), EXPECTED_SHIP_DATE, FCST_TYPE(FCST Type*), FROM_SITE(From Site*), INCOTERMS(Incoterms*), LAST_UPDATED_BY(Requestor), LAST_UPDATED_DATE(Request Date), LT_TOTAL(L/T(Day)), MKT_OWMER(MKT Owner), MODEL_ID(Model*), MODEL_PIC, NICK_NAME, ORDER_TYPE_DETAIL, QTY(Qty*), REMARK, REQUEST_ID(Confrim/Plan ID), SHIPTO_CODE(Ship to*), SHIPTO_NAME, SITE_DESCRIPTION(Plant Site), SOLDTO_CODE(Sold to), STATUS, TO_SITE(To Site*), TR_MODE(Trans Mode*), YYYYMMDD(Shipment Date*)
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION

#### `W/H stock` — META+코드연결, 메타 19/0

- 컬럼 상세는 grid_effective.csv가 잘려 **확인 필요**하다.

#### `W/H stock Detail` — META+코드연결, 메타 25/0

- 컬럼 상세는 **확인 필요**하다(CSV 잘림).

#### `Hold stock` — META+코드연결, 표시 10

- **표시**: DIVISION_ID(Div), FROM_SITE_NM(From Site), HOLD_QTY(Amend Qty*), HOLD_YYYYMMDD(Start Date), ITEM_ID(Model), LAST_UPDATE_DATE, LAST_UPDATED_BY, NICK_NAME, RELEASE_YYYYMMDD(End Date*), REMARKS
- **숨김**: FROM_SITE, HOLD_ID
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION
- 저장 SP는 `SSP0015_SAVE_BLOCK_STOCK_DATA`다.

#### `Hold stock Detail` — META+코드연결, 표시 10

- 컬럼은 Hold stock과 같다. 차이는 라벨에서 `Amend Qty`와 `End Date`에 `*`가 없다는 점이다.

#### `Stock Detail` — META+코드연결 (코드상 shtMesStock), 메타 26/0

- **표시(CSV에서 확인된 범위)**: AVAILABLE_YN, DIVISION_ID, FCS_HOLD_YN, FCS_SPECIAL_QTY, FROM_SITE(Site), ITEM_ID, JUDG_VLD_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY, LONGTERM_HOLD_YN, LOT_ID, LOT_QTY_FCS, LOT_QTY_MES, LOT_QTY_MES_NG, LOT_QTY_TOT, LOT_TYPE, MES_CHANGE_STATUS, MES_HOLD_RELEASE, MES_HOLD_YN, NICK_NAME, OWMS_STOCK_QTY, QMS_HOLD_RELEASE, QMS_HOLD_YN, REMARKS, USER_MOD_RELEASE_DATE(User Modified Release Date*), YYYYMMDD_LOT_ID_APPLIED_LT(D Day(Expected))
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION
- 저장 SP는 `SSP0015_SAVE_MES_STOCK`다.

#### `MES Stock Detail` — 메타 정의만 있고 코드는 참조하지 않음(미사용 가능), 메타 24

- 컬럼은 Stock Detail에서 LONGTERM_HOLD_YN과 LOT_QTY_MES_NG를 뺀 구성이다.
- TO-BE에 넣을지는 **확인 필요**하다.

#### `SCS Stock Detail` — META+코드연결, 표시 9

- **표시**: CUTOFF_DATE, DIVISION_ID, HOLD_YN, LAST_UPDATE_DATE(Update Date), MODEL_ID(Model), PLANT_ID, PLANT_NAME, PROD_DATE, QTY
- **코드 →숨김**: SHIP_TO, SHIPTO_DESCRIPTION

#### `Stock Location Detail` — META+코드연결, 메타 20/0

- **확인된 표시 컬럼**: AVAILABLE_DATE, AVAILABLE_QTY, COMPANY_ID, CUTOFF_DATE, DEFECT_QTY(Deffect Qty), DIVISION_ID 등
- 나머지는 **확인 필요**하다(CSV 잘림).

#### `WH In Plan Detail` — META+코드연결, 메타 11/0

- AddSheet 조건이 `if(drPgmAuthId != null)`이다(CreateSpread:680).
- 컬럼 상세는 **확인 필요**하다.

#### `Shipment Result` — META+코드연결, 표시 17 (메타 19 − 코드 숨김 2)

- **표시**: CONFIRM_ID, DIVISION_ID, END_CUSTOMER, ERP_SO_NO(SO No), ETA_DATE, ETD_DATE, FROM_SITE, INCOTERMS, ITEM_ID, NICK_NAME, QTY(Shipment Qty), SHIP_TYPE, TEAM, TO_SITE, TRANSPORT_MODE, TYPE(Status), YYYYMMDD(Shipment Date)
- **기본이지만 코드가 →숨김**: SHIP_TO(Ship to), SHIPTO_DESCRIPTION(Ship to Name) (4991/4992줄)

## 4. 시트 연결 규칙

| 시트 | Spread | 코드 상수 | 조회 메서드 → 엔드포인트 (메서드명 기준이라 확인 필요 포함) |
|---|---|---|---|
| Shipment PSI(Mobility & IT) | spdMain | SpdSheet.shtMain | FindButton > FindData_Main → `SSP.SSP0015_GET_SHIPMENT_PSI` |
| Shipment PSI(Packer) | spdMain | SpdSheet.shtPacker | FindButton > FindData_Main_Packer / FindData_Main_Packer_Past → `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` / `_PACKER_PAST` |
| Shipment Confirm Detail | spdDetail | shtDetail | SpdMain_CellDoubleClick > FindData_Detail, BtnSearch_Click > FindData_Detail_btnSearch → `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / FindData_Detail_Packer_btnSearch → `..._PACKER` |
| Shipment Request Detail | spdDetail | shtRequestDetail | FindData_Request_Detail → `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| W/H stock | spdDetail | shtWHstock | FindData_WHstock → `SSP.SSP0015_GET_WH_STOCK` |
| W/H stock Detail | spdDetail | shtWHstockDetail | 확인 필요 |
| Hold stock / Hold stock Detail | spdDetail | shtBolckStock / shtBolckStockDetail | FindData_block_stock / FindData_BolckStockDetail_btnSearch → `SSP.SSP0015_GET_BLOCK_STOCK` |
| Stock Detail | spdDetail | shtMesStock | FindData_mes_stock / FindData_MesStock_btnSearch → `SSP.SSP0015_GET_MES_STOCK` |
| SCS Stock Detail | spdDetail | shtScsStock | FindData_ScsStock_btnSearch → `SSP.SSP0015_GET_SCS_STOCK` |
| Stock Location Detail | spdDetail | shtStockLocationDetail | FindData_shtStockLocationDetail_btnSearch → `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` (+ GetNERPCode) |
| WH In Plan Detail | spdDetail | shtWHinPlanDetail | FindData_WHinPlanDetail_btnSearch → `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` |
| Shipment Result | spdDetail | shtShipmentResult | FindData_ShipmentResult_btnSearch → `SSP0015_GET_SHIPMENT_RESULT` / FindData_ShipmentSCSResult_btnSearch → `..._RESULT_PACKER` |

- CreateSpread는 마지막에 ChangeSheet를 W/H stock(740줄), Shipment Confirm Detail(741줄), Shipment PSI(Mobility & IT)(746줄) 순서로 부른다. 그래서 초기 활성 시트는 Main이 Mobility & IT, Detail이 Shipment Confirm Detail로 추정된다. 실행으로 **확인 필요**하다.
- Main에서 셀을 더블클릭하면 행의 DIVISION_ID, SITE, ITEM_ID, YYYYMMDD 값으로 Detail을 조회한다(8290~8293줄).

=== FILE: oracle_migration.md ===
# SSP0015 Oracle 전환 분석

## 1. 호출 SP 인벤토리 (38개)

| # | SP | 스키마 키 | 호출 위치 | 주요 참조 객체 | EXEC 체인 |
|---:|---|---|---|---|---|
| 1 | `DM0003_GET_BUCKET_TYPE_CODE` | DM | GetBucketType:2162 | SCM_ADM_LOOKUP_MASTER_DETAIL | – |
| 2 | `SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` | SSP | 2293 | SCM_MST_TITLESET_USER, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SSP_ANL_SHIP_PLAN_P, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_CODE_LOOKUP_VALUE | FN_GET_LOOKUP_VALUE, FN_GET_IN_STR, FN_SCM_SPLIT, STRING_SPLIT, #TMP_* 5종, 동적 SQL |
| 3 | `SSP0015_GET_SHIPMENT_PSI_PACKER` | SSP | 2412 | SSP_ANL_SHIP_REQ_P, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE, SCM_DNM_SCS_PROD_PLAN, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE, SCM_MST_TITLESET_USER | #TMP_* 9종, STRING_SPLIT, 동적 SQL |
| 4 | `SSP0015_GET_SHIPMENT_PSI` | SSP | 2536 | SSP_ANL_SHIP_PLAN_40, SSP_PLAN_VERSION_V, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, DM_PLN_SHIPMENT_REQ, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_MES_FCS_STOCK_40_C, SCP_MST_FINAL_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_OWMS_STOCK_C, SSP_ANL_TCO_STOCK_C, SSP_ANL_HOLD_STOCK, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE, SCM_MST_SITE | EXEC SSP0015_GET_SHIPMENT_PSI_COMMENTS, FN_GET_SSP_ANL_SHIP_FROZEN, FN_LIST_LOOKUP_VALUE, #TMP_ROWDATA, #TBLDYNAMICTITLEST_SSP0015, 동적 SQL |
| 5 | `SSP0002_GET_NERP_CODE` | SSP | 2904 | SCM_CODE_LOOKUP_VALUE | – |
| 6 | `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` | SSP | 3165, 3303, 3705 | 동적 SQL (확인 필요) | FN_GET_IN_STR, FN_SCM_SPLIT |
| 7 | `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` | SSP | 3439 | 동적 SQL (확인 필요) | FN_GET_IN_STR, FN_SCM_SPLIT |
| 8 | `SSP0015_GET_WH_STOCK` | SSP | 3850 | SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_ITEM_SN | FN_GET_IN_STR, FN_GET_ITEM_NICKNAME, FN_SCM_SPLIT, STRING_SPLIT |
| 9 | `SSP0015_GET_MES_STOCK` | SSP | 3966, 4528 | SSP_ANL_MES_FCS_STOCK_40_C, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SCM_MST_ITEM_SN | FN_GET_ITEM_NICKNAME, STRING_SPLIT |
| 10 | `SSP0015_GET_BLOCK_STOCK` | SSP | 4070, 4193 | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN | FN_GET_IN_STR, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_ITEM_NICKNAME, FN_CHAR_TO_DATE, FN_SCM_SPLIT, STRING_SPLIT |
| 11 | `SSP0015_GET_STOCK_LOCATION_DETAIL` | SSP | 4337 | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_MST_SLOC, SCM_DNM_STOCK_V, SCM_MST_ITEM_SN, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_CODE_LOOKUP_VALUE | FN_GET_LOOKUP_VALUE, FN_GET_IN_STR, FN_GET_ITEM_NICKNAME, FN_SCM_SPLIT, STRING_SPLIT |
| 12 | `SSP0015_GET_SCS_STOCK` | SSP | 4437 | SCM_DNM_SCS_STOCK, SCM_MST_SITE, SSP_MST_MODEL_USER, SSP_MST_DELEGATE | STRING_SPLIT |
| 13 | `SSP0026_GET_REQUEST_DETAIL_PACK` | SSP | 4640 | 동적 SQL만 추출됨 (확인 필요) | – |
| 14 | `SSP0015_GET_SHIPMENT_PSI_COMMENTS` | SSP | 4723 (그리고 #4 내부에서 EXEC) | 동적 SQL (확인 필요) | FN_GET_IN_STR, FN_SCM_SPLIT |
| 15 | `SSP0015_GET_SHIPMENT_RESULT_PACKER` | SSP | 4832 | SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_P, SCP_MST_BOD_N_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SCM_MST_CUSTOMER, SSP_MST_DELEGATE, SCM_MST_ITEM_SN (CTE 성격 이름: RESULT_SCS_EXIST, RESULT_ERP_C_NON, PLAN_SSP) | FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, STRING_SPLIT |
| 16 | `SSP0015_GET_SHIPMENT_RESULT` | SSP | 4944 | SCM_DNM_EXFACTORY_RESULT, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SSP_ANL_SHIP_CONFIRM, SCP_MST_FINAL_ITEM, SCM_MST_SITE_ITEM, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_ITEM_SN, SCM_CODE_LOOKUP_VALUE (CTE 성격 이름: RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS) | FN_LIST_LOOKUP_VALUE, STRING_SPLIT |
| 17 | `SSP0015_SAVE_SHIPMENT_PSI` | SSP | 5412 | SSP_ANL_SHIP_PLAN_40(S/U), SSP_ANL_SHIP_PLAN_40_WH_IN_CMT(S/U/I), _WH_IN_CMT_H(I), _WH_IN_H(I), SCM_SYS_LOG_BATCH(I) | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SCM_ARR_SPL_CNT/VAL |
| 18 | `SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` | SSP | 5602 | SSP_ANL_SHIP_CONFIRM(S/U/I), SSP_ANL_SHIP_CONFIRM_H(I), XIF_ERP_PACK_SHIP_PLAN_S_SN(I), XIF_SCS_PACK_SHIP_PLAN_S_SN(I), SSP_MST_SEND_MAIL_REQ(S/I), NERP_CONV_MASTER, SCM_MST_SSO_USER_INFO 등 | PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SSP_ANL_SHIP_CONFIRM_HIST, FN_GET_SSP_ETA_DATE, FN_ZERO_LPAD, FN_MULTY_TIME, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_SITE_CUSTOMER_INFO, FN_WEEKOFDAY_DATE, CTE_DATE |
| 19 | `SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | SSP | 5841 | SSP_ANL_SHIP_CONFIRM(S/U/I), _H(I), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN(I), SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE)(I), SSP_ANL_SHIP_PLAN_40(S/D/I), SSP_MST_SEND_MAIL_REQ, DM_PLN_MKT_FCST_CONFIRM(S/I), SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V, SCM_DNM_EXFACTORY_RESULT, DM_PLN_MKT_FCST_RESULT | PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, PR_SCM_SYS_LOG_BATCH(_CALL_TRAN), UF_FX_STRING_SPLIT, FN_SPLITSTRING, FN_NEXT_DAY, #T_* 및 #TEMP_* |
| 20 | `SSP0015_SAVE_BLOCK_STOCK_DATA` | SSP | 6011 | SSP_ANL_HOLD_STOCK(S/U/I), SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH |
| 21 | `SSP0015_SAVE_MES_STOCK` | SSP | 6112, 6219 | SSP_ANL_MES_FCS_STOCK_40_C(MERGE), SSP_ANL_SHIP_PLAN_40(MERGE), #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP | PR_SCM_SYS_LOG_BATCH |
| 22 | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | SSP | 6665 | SSP_ANL_SHIP_ERP_ERROR_CONFIRM(I), SSP_ANL_SHIP_CONFIRM_CHG_REQ(U), _DE(S/U) | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 23 | `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | SSP | 6706, 7363 | SSP_ANL_SHIP_CONFIRM(S/U/D), SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE(S/U), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN(I), DM_PLN_MKT_FCST, SCM_MST_SITE_CUSTOMER | #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, FN_GET_SSP_SITE_INFO(_EXCEPTION), FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS |
| 24 | `SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` | SSP | 6843, 7076, 9611(unreached) | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE)(I/U), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN(I), NERP_CONV_MASTER, DM_PLN_MKT_FCST | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH |
| 25 | `SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | SSP | 6847, 7080, 9615(unreached) | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE)(I/U), XIF_ERP_PACK_SHIP_PLAN_S_SN(I), XIF_SCS_PACK_SHIP_PLAN_S_SN(I) | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH |
| 26 | `SSP0015_GET_ERP_SO_NO_CNT` | SSP | 7185 | SSP_ANL_SHIP_CONFIRM | – |
| 27 | `SSP0015_GET_SHIPMENT_STATUS` | SSP | 7210 | SSP_ANL_SHIP_CONFIRM | STRING_SPLIT |
| 28 | `SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | SSP | 7285, 9731 (둘 다 unreached) | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE)(U), SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 29 | `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | SSP | 7389, 7419 | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN(I), SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE(S/U), SSP_ANL_SHIP_CONFIRM_CHG_REQ, NERP_CONV_MASTER, DM_PLN_MKT_FCST | PR_SCP_SYS_LOG_BATCH |
| 30 | `PR_SCM_SYS_LOG_BATCH` | SCP | 7876 (unreached) | SCM_SYS_LOG_BATCH(I) | – |
| 31 | `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | SSP | 7903 | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL | – |
| 32 | `SCM0001_GET_DIVISION` | SCM | 9192 (unreached) | SCM_MST_DIVISION | – |
| 33 | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP | 9247 | SCM_SYS_CALENDAR_M | – |
| 34 | `SCM0001_GET_SCP_DAY_PERIOD` | SCP | 9289 | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL | FN_MULTY_TIME, FN_WEEKOFDAY_DATE, CTE_DATE |
| 35 | `SSP0202_GET_SCS_CONFIRM_ID_CHECK` | SSP | 9821 | SCM_ADM_LOOKUP_MASTER_DETAIL, 동적 SQL | FN_GET_IN_STR, FN_SCM_SPLIT |
| 36 | `SCM_SSP_CHECK_CONFIRM_CHANGETIME` | SSP | 9875 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH |
| 37 | `SSP0002_GET_USER_INFO_LIST` | SSP | 9901 | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | – |
| 38 | `SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | SSP | Popup SaveData:333 | SSP_ANL_SHIP_PLAN_40(S/U), _WH_IN_H(I), _WH_IN_CMT(S/U/I), _WH_IN_CMT_H(I), SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |

## 2. 공통코드 분기 (`biz:CommonData.CommonDataList` → UP_FX_GetCommonDataList)

| code | 호출 위치 | 참조 테이블 |
|---|---|---|
| PlanDateShip | InitControls:568, EditButton:1753/1757, SetChangedControl:2202/2210/2218 | SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_PLAN_P, SSP_PLAN_VERSION_V, STRING_SPLIT 사용 |
| LookupCommon | SpdMain_ActiveSheetChanged:1400/1452 | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| TransMode | SpdDetail_CellClick:8583, SpdDetail_ClipboardPasted:8954 | SCP_MST_BOD_V |
| ShipToCodeByDivision | SpdDetail_CellClick:8604 | SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE |
| PERIOD_{p:value} / PERIOD2_{p:value} | SetChangedPeriod:9207/9211 (unreached) | DB 보강 없음. 동적 코드라서 분기 대상은 확인 필요 |

- InitControls에서 `dtShipmentInputPeriod.Rows[0/1]`의 `VALUE`와 `Diff_VALUE`를 읽는다(613~616줄). 이 값의 원천 코드가 무엇인지는 **확인 필요**하다.
- `dtCompany.Rows[0].COMPANY_ID`를 읽는 원천(598줄)도 **확인 필요**하다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- endpoints.csv의 fox 계열 호출은 모두 상태가 **MATCH**다. FoxQuery에 없는 호출(미등록)은 0건이다.
- SP 안에서 EXEC로만 불리는 하위 SP가 있다. 화면이 직접 부르지 않는 프로시저들이며, Oracle에서 함께 이관해야 한다.
  - 로그: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_SYS_LOG_BATCH
  - 확정 처리: PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_ANL_SHIP_CONFIRM_ROUTE
  - Packer 전용: PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER
- `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`는 화면이 직접 부르고(7389/7419줄), DRAFTING SP 안에서도 EXEC로 불린다.
- 주석 처리됨(이관 대상 아님): SCP.GET_DATE_RANGE_1MONTH (9288/9308줄), SCP.SCM0001_GET_SCP_PERIOD (9309줄).

## 4. Oracle 전환 시 확인 포인트 (추출된 사실 기준)

| 항목 | 해당 SP / 위치 | 사실 |
|---|---|---|
| `STRING_SPLIT` (MSSQL 전용) | PSI_PACKER, PSI_PACKER_PAST, WH_STOCK, MES_STOCK, BLOCK_STOCK, STOCK_LOCATION_DETAIL, SCS_STOCK, SHIPMENT_RESULT, SHIPMENT_RESULT_PACKER, SHIPMENT_STATUS, 공통코드 PlanDateShip 분기 | REF:STRING_SPLIT이 추출됐다. CLAUDE.md 절대 금지 ⑩ 대상이므로 Oracle 대체 구현이 필요하다 |
| `#` 임시 테이블 | PSI, PSI_PACKER, PSI_PACKER_PAST, SAVE_MES_STOCK, SAVE_SHIPMENT_REQUEST_CONFIRM_40, SCM_SSP_DELETE_..._BY_CONFIRM | CREATE/INSERT/SELECT #TMP_*, #T_*, #TEMP_*, #TBLDYNAMIC* 다수. GTT로 바꾸거나 쿼리를 재구성해야 한다. 사용자 메모리 규칙상 GTT는 세션 시작 시 비우는 것을 대조해야 한다 |
| 동적 SQL | PSI, PSI_PACKER, PSI_PACKER_PAST, PSI_COMMENTS, CONFIRM_DETAIL, CONFIRM_DETAIL_PACKER, SSP0026_GET_REQUEST_DETAIL_PACK, SSP0202_GET_SCS_CONFIRM_ID_CHECK | `DYNAMIC@`가 추출됐다. 동적 문자열 안의 MSSQL 문법은 정적 추출 범위 밖이라 원문 확인이 필요하다 |
| `MERGE` | SSP0015_SAVE_MES_STOCK | MERGE SSP_ANL_MES_FCS_STOCK_40_C, SSP_ANL_SHIP_PLAN_40. Oracle MERGE 문법으로 바꿔야 한다 |
| 배열 분할 함수 | 저장 계열 SP 다수 | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, UF_FX_STRING_SPLIT, FN_SPLITSTRING, FN_SCM_SPLIT, FN_GET_IN_STR. Oracle에 같은 함수가 있는지 확인 필요 |
| 외부 I/F 테이블 | CONFIRM_40, CONFIRM_PACKER, DRAFTING(_PACKER), CHG_BATCH, DELETE_..._BY_CONFIRM | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN에 INSERT한다. ERP/SCS 연계 테이블이므로 Oracle 쪽 대상과 시노님을 확인해야 한다 |
| CTE 이름 | SHIPMENT_RESULT(_PACKER), SCM0001_GET_SCP_DAY_PERIOD, CONFIRM_PACKER | RESULT_*, PLAN_SSP, RETURN_OWMS, CTE_DATE는 SELECT 대상으로 추출됐다. 실제로는 CTE로 보인다(확인 필요) |
| 공통 시스템 테이블 | GET_USER_INFO_LIST, MES_STOCK, BLOCK_STOCK, SHIPMENT_RESULT, CONFIRM_40/PACKER | TB_FX_USER, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USERGROUPAUTHEXTENTION 참조 |
| 트랜잭션 로그 | 저장 계열 전부 | INSERT SCM_SYS_LOG_BATCH (PR_SCM_SYS_LOG_BATCH(_CALL_TRAN)) |

### 난이도 근거 (사실만)

- 쓰기 SP는 11개다: SAVE_* 6개, DRAFTING 2개, ERROR_CONFIRM, DELETE_..._BY_CONFIRM, CHG_BATCH. SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING은 unreached라 제외했다.
- 이 가운데 하위 PR을 2개 이상 EXEC하는 SP는 SAVE_SHIPMENT_REQUEST_CONFIRM_40(PR 6종 이상), SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, DRAFTING(_PACKER)이다.
- 조회 SP 중 #임시테이블 + 동적 SQL + STRING_SPLIT이 모두 들어간 SP는 SSP0015_GET_SHIPMENT_PSI_PACKER와 SSP0015_GET_SHIPMENT_PSI_PACKER_PAST다.
- 상·중·하 같은 정량 등급은 Fact Pack에 기준이 없어 매기지 않았다.

=== FILE: tobe_design.md ===
# SSP0015 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 상단 조회조건

| 순서(Designer) | 컨트롤 | 라벨 | 필수 | 데이터 원천 | 연동 이벤트 |
|---|---|---|---|---|---|
| 1 | clbDivision | Division* | Y (`*`) | GetSSPInnerTable 계열 (SetChangeControl:456~491, 확인 필요) | clbDivision_SelectedIndexChanged → PlanDateShip 공통코드 재조회, GetDayRange |
| 2 | cboPlanDate | Plan-date* | Y | `biz:CommonData.CommonDataList` code=PlanDateShip | CboPlanDate_SelectedIndexChanged → `SCM0001_GET_SCP_DAY_PERIOD` |
| 3 | drpPeriod | Period* | Y | `SCM0001_GET_SCP_DAY_PERIOD`(GetDayRange) | – |
| 4 | cboBucketType | Bucket | – | `DM0003_GET_BUCKET_TYPE_CODE` (값 DAILY/WEEKLY/MONTHLY는 코드 비교식에서 확인) | cboBucketType_SelectedIndexChanged → 컬럼 표시 (SetSpreadColumn 추정, 확인 필요) |
| 5 | chkSum | Sum | – | – | chkSum_CheckedChanged → M_ 또는 W_ 합계 컬럼 표시 |
| 6 | btnMeasure | (Text 확인 필요) | – | – | btnMeasure_Click → InitSpread 재생성 (SCP0009_GET_SHEET_CALENDAR_3SPAN) |
| 7 | clbPlantSite | From Site | – | 확인 필요 | – |
| 8 | txtItemId + btnItemId | Model | – | btnItemId_Click (팝업, 내용 확인 필요) | – |
| – | chkMyModel / chkPartLeader / chkTeamLeader / chkDelegateeModel | My Model / Part Leader / Team Leader / Delegatee Model | – | Visible=false (chkMyModel Checked=true) | 숨김. 조회 파라미터로 쓰이는지 확인 필요 |

- 조회조건 순서는 위 표의 Designer 선언 순서가 아니라 LayoutControl 배치 좌표로 정해진다. 좌표가 추출되지 않아 실제 순서는 **확인 필요**하다.

### 1-2. 하단 상세 조회조건

| 컨트롤 | 라벨 | 비고 |
|---|---|---|
| clbResultType | 확인 필요 | Shipment Result 시트용으로 추정 (확인 필요) |
| txtRequestor + btnRequestor | Requestor (항목명) | BtnRequestor_Click |
| txtModel2 + btnItemID2 | 확인 필요 | BtnItemID2_Click |
| drpPeriod2 | Shipment Date | – |
| drpPeriod3 | 확인 필요 | – |
| txtLotID | 확인 필요 | – |
| btnSearch | Search | BtnSearch_Click → 활성 Detail 시트별 조회 |

## 2. 액션별 호출 API 후보

API 경로는 정하지 않았다. SP 단위의 후보만 적었다.

| 액션 | AS-IS 진입점 | 호출 SP (순서는 경로 기준) |
|---|---|---|
| 화면 진입 | Form_Load | CommonDataList(PlanDateShip) → `DM0003_GET_BUCKET_TYPE_CODE` → `SCM0001_GET_SCP_DAY_PERIOD` → `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| Division 변경 | clbDivision_SelectedIndexChanged | CommonDataList(PlanDateShip) → `SCM0001_GET_SCP_DAY_PERIOD` |
| Plan-date 변경 | CboPlanDate_SelectedIndexChanged | `SCM0001_GET_SCP_DAY_PERIOD` |
| Main 시트 전환 | SpdMain_ActiveSheetChanged | CommonDataList(LookupCommon, PlanDateShip) → `SCM0001_GET_SCP_DAY_PERIOD` → `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| 조회 (Mobility & IT) | FindButton > FindData_Main | `SSP0015_GET_SHIPMENT_PSI` (+ Re_Design > `SSP0002_GET_NERP_CODE`) |
| 조회 (Packer) | FindButton > FindData_Main_Packer / _Past | `SSP0015_GET_SHIPMENT_PSI_PACKER` / `SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` (분기 조건 확인 필요) |
| Measure 변경 | btnMeasure_Click | `SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| Main 더블클릭 | SpdMain_CellDoubleClick | 활성 Detail 시트에 따라 `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / `SSP0015_GET_WH_STOCK` / `SSP0015_GET_MES_STOCK` / `SSP0015_GET_BLOCK_STOCK` / `SSP0015_GET_STOCK_LOCATION_DETAIL` / `SSP0015_GET_SCS_STOCK` / `SSP0015_GET_SHIPMENT_PSI` |
| Detail Search | BtnSearch_Click | `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL(_PACKER)`, `SSP0015_GET_WH_STOCK`, `SSP0015_GET_BLOCK_STOCK`, `SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP0015_GET_SCS_STOCK`, `SSP0015_GET_MES_STOCK`, `SSP0026_GET_REQUEST_DETAIL_PACK`, `SSP0015_GET_SHIPMENT_PSI_COMMENTS`, `SSP0015_GET_SHIPMENT_RESULT(_PACKER)` |
| 편집 모드 | EditButton | CommonDataList(PlanDateShip) → `SSP0002_GET_USER_INFO_LIST` |
| 저장 (Main) | SaveButton > SaveData_Main | `SSP0015_SAVE_SHIPMENT_PSI` |
| 저장 (Detail 40 계열) | SaveButton > SaveData_Detail | `SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP0015_SAVE_BLOCK_STOCK_DATA`, `SSP0015_SAVE_MES_STOCK` → 재조회 |
| 저장 (Detail Packer) | SaveButton > SaveData_Detail_Packer | `SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` → `SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` → GetERPInterface (아래 행) → `SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` 재조회 |
| ERP I/F (Packer 저장 하위) | GetERPInterface | 사전 점검: `SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP0015_GET_ERP_SO_NO_CNT`, `SSP0015_GET_SHIPMENT_STATUS`, `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`<br>SoNo / NonSoNo: `SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING(_PACKER)`<br>GetErpIFCheckNew: `SCM_SSP_DELETE_..._BY_CONFIRM`, `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` |
| 코멘트 저장 (팝업) | btnButtonList_UsrButtonList_Click_Detected > SaveData | `SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` |
| Detail 콤보 | SpdDetail_CellClick / SpdDetail_ClipboardPasted | CommonDataList(TransMode, ShipToCodeByDivision) |
| (미연결) | GetErpIFCheck, GetErpIFCheckNew_, NewNonSoNo, GetDivision, SCM_SYS_LOG_BATCH, SetChangedPeriod | `SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SCM0001_GET_DIVISION`, `PR_SCM_SYS_LOG_BATCH`, PERIOD 공통코드. 이관 여부는 확인 필요 |

- Packer 저장 하위 단계의 실행 순서와 분기 조건(SoNo와 NonSoNo 중 무엇을 타는지)은 Fact Pack에 없어 **확인 필요**하다.
- Validation_Check는 저장 전에 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE를 읽는다(6318~6472줄). 검증 규칙의 상세는 **확인 필요**하다.
- chkERPIFBlockYn은 BLOCK_YN과 PERIOD를 읽는다(7449/7458줄). 이 데이터의 원천 엔드포인트는 추출되지 않아 **확인 필요**하다.

## 3. division별 Grid 변형 요약

- 14개 division 전부 시트별 표시 컬럼 수가 같다. **division별 변형은 없다.**
- 변형은 division이 아니라 다음 조건에서 생긴다.
  - Bucket(DAILY/WEEKLY/MONTHLY)과 Sum 체크: D_/W_/M_ 날짜 컬럼 표시
  - Main 시트 종류(Mobility & IT / Packer): MergePolicy, SO No 컬럼 Width(SetSoNoColumnVisible)
  - 권한 행(drPgmAuthId)이 있을 때만 WH In Plan Detail 시트 생성
  - Shipment Result 조회 시 SHIP_TO와 SHIPTO_DESCRIPTION 숨김

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 근거 |
|---|---|
| 메뉴 권한 메타 14행 | dbo.TB_FX_GroupMenuAuth (dbmeta, 14행) |
| WH In Plan Detail 시트는 권한 행이 있을 때만 생성 | CreateSpread:680/731/732, InitSpread:965/967 `if(drPgmAuthId != null)` |
| 편집 진입 시 사용자 정보 확인 | EditButton > GetSSPUserCheck:9901 → `SSP0002_GET_USER_INFO_LIST` (TB_FX_USERGROUPAUTHEXTENTION 등) |
| 그룹 기반 필터 | SetChangeControl:449/450 (Filter GROUP_ID, USER_ID / NowGroupID), InitControls:584, SpdMain_ActiveSheetChanged:1459, SetChangedControl:2209 |
| 시트 잠금 시 헤더 체크박스 동작이 다름 | SpdDetail_CellClick: `siDetail.IsLock(siDetail.SheetName)` 분기 (8618/8653/8657줄) |
| 모델 담당 범위 체크박스(My Model 등)는 숨김 | Designer Visible=false. 권한 범위로 쓰이는지 확인 필요 |
| 저장 전 계획 진행 여부 확인 | EngProcessingChk → `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` |
| C/R/U/D 버튼별 권한 매핑 | TB_FX_GroupMenuAuth 행 내용이 Fact Pack에 없어 **확인 필요** |

## 5. 미확정 사항

1. FindButton의 Main 조회 분기 조건. FindData_Main, _Packer, _Packer_Past 중 무엇을 부르는지 정하는 조건이다.
2. GetERPInterface 하위 단계의 순서와 분기, 오류 처리.
3. unreached 메서드 6개를 이관할지 여부.
4. 메타에만 있는 시트를 넣을지: Shipment PSI(IT & Mobile), MES Stock Detail, SSP0015_TEMP2.
5. 컬럼 상세가 잘린 시트 4개: W/H stock, W/H stock Detail, Stock Location Detail, WH In Plan Detail.
6. W/H stock Detail 시트의 조회 엔드포인트.
7. 라벨을 못 찾은 컨트롤: clbResultType, txtModel2, drpPeriod3, txtLotID, btnMeasure, btnItemId, 팝업 텍스트박스들.
8. 동적 SQL SP 8개가 실제로 참조하는 테이블과, 그 안의 MSSQL 문법.
9. SaveButton과 팝업 SaveData의 연결이 맞는지. 4-2장에서 `PersonalSettingPopup.SaveData`로 해석된 점과 충돌한다.
10. SP 실행 결과 컬럼과 메타 컬럼이 맞는지. grid 단계가 실행되지 않았다.
11. 주석 처리된 호출 4건(3573, 9288, 9308, 9309줄)은 TO-BE 기능에 넣지 않는다. 주석 처리됨.
