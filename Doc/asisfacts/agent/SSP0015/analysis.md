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
