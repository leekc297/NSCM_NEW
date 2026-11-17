=== FILE: analysis.md ===
# SSP0021 Shipment Plan — AS-IS 분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0021)만 사용했다. Fact Pack에 없는 내용은 **확인 필요**로 표기했다.
> 본문은 현행(current) 파일 기준이다. 구버전 사본(legacy)은 1.3절에 목록만 적었다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0021 |
| 클래스 | `SSP0021_ShipmentPlan` |
| 도메인 | SSP (Fact Pack 경로 `GSCM.SSP.Forms.UIL\Plan` 기준) |
| 화면명(클래스·프로젝트명 기준) | ShipmentPlan |
| Grid 구성 방식 | `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)` |
| FpSpread | 2개: `spdMain`(상단), `spdDetail`(하단, 시트 여러 개) |
| 컨트롤 수 | 58 (controls.csv) |
| 활성 엔드포인트 | 23종, 호출 지점 28개 (endpoints.csv) |
| 이벤트 배선 | 27행, 핸들러 26종 (events.csv) |
| 주석 처리된 호출 | 1건: `SSP.SSP0046_GET_BUCKET_TYPE_CODE` (320줄, **주석 처리됨**, 현행 기능 아님) |

### 1.1 파일 구성 — current
| 파일 | 프로젝트 | 줄수 |
|---|---|---:|
| 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\Properties\AssemblyInfo.cs | SSP0021_ShipmentPlan.UIL.csproj | 37 |
| 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\SSP0021_ShipmentPlan.cs | SSP0021_ShipmentPlan.UIL.csproj | 6583 |
| 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0021_ShipmentPlan.UIL\SSP0021_ShipmentPlan.Designer.cs | SSP0021_ShipmentPlan.UIL.csproj | 1566 |

### 1.2 파일 구성 — shared
- Fact Pack에 `shared` 구분 파일이 없다.
- 이 화면이 쓰는 프레임워크 메서드는 4-2절 표에 따라 `DataService.GetSSPInnerTable`, `DataService.FP_Log2`, `CString.GetCheckedListValue`, `SpreadInfo.GetSpdTitle`, `SpreadInfo.SetSheetHeaderColumn`, `SpreadInfo.InitSpreadDateColumn`이다. 이 메서드들의 소스 파일 경로는 **확인 필요**.

### 1.3 파일 구성 — legacy (구버전 사본, 본문 집계 제외)
| 파일 | 프로젝트 | 줄수 |
|---|---|---:|
| 06.UIL\GSCM.SSP.Plan.UIL\SSP0021_ShipmentPlan.cs | GSCM.SSP.Plan.UIL.csproj | 6577 |
| 06.UIL\GSCM.SSP.Plan.UIL\SSP0021_ShipmentPlan.Designer.cs | GSCM.SSP.Plan.UIL.csproj | 1564 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| # | 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 |
|---:|---|---|---:|---|---|
| 1 | event:this.Load (`Form_Load`) | Form_Load > InitControls > SetChangedControl | 493 | `SSP.SSP0021_GET_SHIPMENT_DIVISION` | MATCH |
| 2 | event:this.Load (`Form_Load`) | Form_Load > InitControls > GetBucketType | 4513 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH |
| 3 | event:this.Load (`Form_Load`) | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 6063 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 4 | button:FindButton | FindButton > FindData_Main | 4598 | `SSP.SSP0021_GET_SHIPMENT_PLAN` | MATCH |
| 5 | button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 6063 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 6 | button:EditButton | EditButton > GetSSPUserCheck | 5850 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH |
| 7 | button:SaveButton | SaveButton > SaveData_Detail | 2664 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| 8 | button:SaveButton | SaveButton > SaveData_Detail | 2822 | `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` | MATCH (⚠ DB에 SP 없음) |
| 9 | button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3352 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH |
| 10 | button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3393 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH |
| 11 | button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > NonSoNo | 3521 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| 12 | button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > SoNo | 3742 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| 13 | button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > GetErpSoNoCnt | 3843 | `SSP.SSP0021_GET_ERP_SO_NO_CNT` | MATCH |
| 14 | button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > GetShipmentStatusChk | 3868 | `SSP.SSP0021_GET_SHIPMENT_STATUS` | MATCH |
| 15 | button:SaveButton | … > GetERPInterface > SoNo > GetErpIFCheckNew | 4019 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH |
| 16 | button:SaveButton | … > GetERPInterface > SoNo > GetErpIFCheckNew | 4045 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH |
| 17 | button:SaveButton | … > GetERPInterface > SoNo > GetErpIFCheckNew | 4075 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH |
| 18 | button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface > ChkConfirmChangeTime | 6561 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | MATCH |
| 19 | button:SaveButton | SaveButton > SaveData_Detail > FindData_Main | 4598 | `SSP.SSP0021_GET_SHIPMENT_PLAN` | MATCH |
| 20 | button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 4877 | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` | MATCH |
| 21 | button:SaveButton | SaveButton > SaveData_Detail > FindData_hold_stock | 5283 | `SSP.SSP0021_GET_HOLD_STOCK` | MATCH |
| 22 | button:SaveButton | … > FindData_hold_stock > InitSpread > GetSpdTitle | 6063 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 23 | event:this.btnMeasure.Click (`BtnMeasure_Click`) | BtnMeasure_Click > InitSpread > GetSpdTitle | 6063 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 24 | event:this.btnSearch.Click (`BtnSearch_Click`) | BtnSearch_Click > FindData_Detail | 4877 | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` | MATCH |
| 25 | event:this.btnSearch.Click | BtnSearch_Click > FindData_Stock_Detail | 4990 | `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL` | MATCH |
| 26 | event:this.btnSearch.Click | BtnSearch_Click > FindData_oWMS_Detail | 5087 | `SSP.SSP0021_GET_OWMS_DETAIL` | MATCH |
| 27 | event:this.btnSearch.Click | BtnSearch_Click > FindData_Shipment_Result | 5180 | `SSP.SSP0021_GET_SHIPMENT_RESULT` | MATCH |
| 28 | event:this.btnSearch.Click | BtnSearch_Click > FindData_MES_stock | 5382 | `SSP.SSP0021_GET_MES_STOCK` | MATCH |
| 29 | event:this.btnSearch.Click | BtnSearch_Click > FindData_MES_stock_Detail | 5482 | `SSP.SSP0021_GET_MES_STOCK_DETAIL` | MATCH |
| 30 | event:this.btnSearch.Click | BtnSearch_Click > FindData_Shipment_Result > InitSpread > GetSpdTitle | 6063 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 31 | event:this.spdMain.CellDoubleClick (`SpdMain_CellDoubleClick`) | SpdMain_CellDoubleClick > FindData_Detail | 4877 | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` | MATCH |
| 32 | event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Stock_Detail | 4990 | `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL` | MATCH |
| 33 | event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_oWMS_Detail | 5087 | `SSP.SSP0021_GET_OWMS_DETAIL` | MATCH |
| 34 | event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_hold_stock | 5283 | `SSP.SSP0021_GET_HOLD_STOCK` | MATCH |
| 35 | event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_MES_stock | 5382 | `SSP.SSP0021_GET_MES_STOCK` | MATCH |
| 36 | event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_MES_stock_Detail | 5482 | `SSP.SSP0021_GET_MES_STOCK_DETAIL` | MATCH |
| 37 | event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_MES_stock > InitSpread > GetSpdTitle | 6063 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 38 | event:clbCompany_ID.SelectedIndexChanged (`clbCompanyID_SelectedIndexChanged`) | clbCompanyID_SelectedIndexChanged | 5916 | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` | **NOT_IN_FOXQUERY** |
| 39 | event:clbCompany_ID.SelectedIndexChanged | clbCompanyID_SelectedIndexChanged > InitSpread > GetSpdTitle | 6063 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 40 | event:cboPlanDate.SelectedIndexChanged (`cboPlanDate_SelectedIndexChanged`) | cboPlanDate_SelectedIndexChanged > GetSpdTitle | 6063 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 41 | unreached (진입점 미연결) | GetErpIFCheck | 3941 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| 42 | unreached (진입점 미연결) | NewNonSoNo | 4290 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| 43 | unreached (진입점 미연결) | GetErpIFCheckNew_ | 4404 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH |

- `FindButton`, `EditButton`, `SaveButton`은 events.csv에 배선 행이 없다. 프레임워크 툴바 버튼 진입점(flow.csv의 `entry_kind=button`)이다. 툴바 연결 구조는 **확인 필요**.
- 41~43행은 정적 분석으로 진입점에 연결되지 않은 메서드다. `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING`은 이 미연결 메서드 2개(GetErpIFCheck, GetErpIFCheckNew_)에서만 호출된다. 실제로 쓰이는지는 **확인 필요**.

## 3. 엔드포인트 전체 표 (23종)

| # | 엔드포인트 | 상태 | 호출 수 | SP | 쓰기 대상 테이블 | 읽기 대상 테이블 / 비고 |
|---:|---|---|---:|---|---|---|
| 1 | `SSP.SSP0021_GET_SHIPMENT_DIVISION` | MATCH | 1 | SSP0021_GET_SHIPMENT_DIVISION | (#RETURNTABLE 임시) | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_CODE_LOOKUP_VALUE / FN_GET_LOOKUP_VALUE |
| 2 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH | 1 | SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM | UPDATE SSP_ANL_SHIP_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM_H, INSERT/UPDATE SSP_MST_SEND_MAIL_REQ, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN, INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_PLAN_VERSION_V, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, NERP_CONV_MASTER, TB_FX_USER, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_PROJECT, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER_EE / EXEC 11종(oracle_migration.md 참조) |
| 3 | `SSP.SSP0021_SAVE_HOLD_STOCK_DATA` | MATCH | 1 | SSP0021_SAVE_HOLD_STOCK_DATA | 확인 필요 | ⚠ **DB에 SP 없음** (FoxQuery 등록은 있음) |
| 4 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH | 1 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| 5 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH | 2 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE/DELETE SSP_ANL_SHIP_CONFIRM, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST / 임시 #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 |
| 6 | `SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 3 | SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT/UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, INSERT SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST |
| 7 | `SSP.SSP0021_GET_ERP_SO_NO_CNT` | MATCH | 1 | SSP0021_GET_ERP_SO_NO_CNT | — | SSP_ANL_SHIP_CONFIRM (결과 컬럼 CNT) |
| 8 | `SSP.SSP0021_GET_SHIPMENT_STATUS` | MATCH | 1 | SSP0021_GET_SHIPMENT_STATUS | — | SSP_ANL_SHIP_CONFIRM / STRING_SPLIT / 결과 Tables[0]~[2]의 CONFIRM_ID 사용 |
| 9 | `SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 2 | SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH | 호출 지점 2곳 모두 진입점 미연결 |
| 10 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH | 2 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT SCM_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST |
| 11 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | — | SCM_ADM_LOOKUP_MASTER_DETAIL |
| 12 | `SSP.SSP0021_GET_SHIPMENT_PLAN` | MATCH | 1 | SSP0021_GET_SHIPMENT_PLAN | 임시 테이블만(#TBLDYNAMICTITLEST_SSP0021, #TMP_RESULT_TABLE, #TMP_BOHDATA_STORAGE, #TMP_BOHDATA, #TMP_ROWDATA, #TMP_RESULT_PIVOT_TABLE, #TMP_RESULT_PIVOT_TABLE_OLD), `UPDATE:C`(별칭 추정, 확인 필요), MERGE #TMP_RESULT_TABLE | SCM_MST_TITLESET_USER, SSP_DNM_GMES_STOCK_81_82, SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, MST_STOCK, MST_LOCATION, PACKER_STOCK, SCM_MST_SITE, SCM_MST_ITEM_SN, SSP_DNM_STOCK_C, SSP_DNM_ESS_PACKER_STOCK_V, SSP_MST_LOCATION_V, DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_CONFIRM, SSP_DNM_FP_PLAN_FROZEN, SCP_ANL_PRODUCTION_PLAN, SCP_PLAN_VERSION_V, SSP_DNM_FP_AMEND_SHIPAVAL, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_DNM_CELL_INHOUSE_PLAN_SN, SCP_MST_BOD_N_V, SCP_MST_SHIPMENT_LOT_SIZE, SSP_ANL_SHIP_PLAN_C, SCM_CODE_LOOKUP_VALUE / 동적 SQL |
| 13 | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL` | MATCH | 1 | SSP0021_GET_SHIPMENT_PLAN_DETAIL | — | 동적 SQL(DYNAMIC@), FN_GET_IN_STR, FN_SCM_SPLIT. 정적 추출된 테이블 없음 → **확인 필요** |
| 14 | `SSP.SSP0021_GET_STOCK_LOCATION_DETAIL` | MATCH | 1 | SSP0021_GET_STOCK_LOCATION_DETAIL | — | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_DNM_STOCK_C, SSP_DNM_ESS_PACKER_STOCK_V, SCM_MST_ITEM_SN |
| 15 | `SSP.SSP0021_GET_OWMS_DETAIL` | MATCH | 1 | SSP0021_GET_OWMS_DETAIL | — | SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_MST_MODEL_USER, SCM_MST_ITEM_SN |
| 16 | `SSP.SSP0021_GET_SHIPMENT_RESULT` | MATCH | 1 | SSP0021_GET_SHIPMENT_RESULT | — | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MODEL_COMP_TEMP_SN, SCM_ITEM_M_SN, SCM_ITEM_CLASS_M_SN, SCM_DNM_EXFACTORY_RESULT, SCM_MST_ITEM_SN, SCP_MST_FINAL_ITEM, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS. RESULT_ERP_C_EXIST, RESULT_CHILD_QTY, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS가 CTE인지 실제 객체인지는 **확인 필요** |
| 17 | `SSP.SSP0021_GET_HOLD_STOCK` | MATCH | 1 | SSP0021_GET_HOLD_STOCK | — | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SCM_MST_SITE, SCM_MST_ITEM_SN |
| 18 | `SSP.SSP0021_GET_MES_STOCK` | MATCH | 1 | SSP0021_GET_MES_STOCK | — | SSP_DNM_GMES_STOCK_81_82 |
| 19 | `SSP.SSP0021_GET_MES_STOCK_DETAIL` | MATCH | 1 | SSP0021_GET_MES_STOCK_DETAIL | — | SSP_DNM_GMES_STOCK_81_82 |
| 20 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | 1 | SSP0002_GET_USER_INFO_LIST | — | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION |
| 21 | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` | **NOT_IN_FOXQUERY** | 1 | (FoxQuery 미등록, DB 객체 존재 P) | — | SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (DB 보강 결과) |
| 22 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SCP0009_GET_SHEET_CALENDAR_3SPAN | — | SCM_SYS_CALENDAR_M |
| 23 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | MATCH | 1 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | INSERT SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |

**주석 처리됨(집계 제외)**: 320줄 `SSP.SSP0046_GET_BUCKET_TYPE_CODE` (commented:MATCH). 현행 기능이 아니다.

## 4. 이벤트 배선 표

| # | 대상 | 이벤트 | 핸들러 | 위치 | 연산 | 연결된 엔드포인트 (flow.csv) |
|---:|---|---|---|---|---|---|
| 1 | this | Load | `Form_Load` | .ctor:295 | += | SSP.SSP0021_GET_SHIPMENT_DIVISION, DM.DM0003_GET_BUCKET_TYPE_CODE, SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN |
| 2 | this.spdMain | TopChange | `SpdMain_TopChange` | InitEvent:912 | += | 없음 |
| 3 | this.spdDetail | TopChange | `SpdDetail_TopChange` | InitEvent:913 | += | 없음 |
| 4 | this.cboBucketType | SelectedIndexChanged | `cboBucketType_SelectedIndexChanged` | InitEvent:915 | += | 없음 (SetSpreadColumn 호출 4451줄, 열 표시 전환) |
| 5 | this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitEvent:916 | += | 없음 (SetSpreadColumn 호출 4456줄) |
| 6 | this.btnMeasure | Click | `BtnMeasure_Click` | InitEvent:917 | += | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN |
| 7 | this.btnItemId | Click | `btnItemId_Click` | InitEvent:918 | += | 없음 |
| 8 | this.btnItemID2 | Click | `BtnItemID2_Click` | InitEvent:919 | += | 없음 |
| 9 | this.btnSearch | Click | `BtnSearch_Click` | InitEvent:920 | += | GET_SHIPMENT_PLAN_DETAIL / STOCK_LOCATION_DETAIL / OWMS_DETAIL / SHIPMENT_RESULT / MES_STOCK / MES_STOCK_DETAIL, SCP0009 |
| 10 | this.btnRequestor | Click | `BtnRequestor_Click` | InitEvent:921 | += | 없음 |
| 11 | this.btnSimulation | Click | `BtnSimulation_Click` | InitEvent:922 | += | 없음 (`Simulation` 메서드가 6124줄 이후에 있으나 핸들러와 연결되는지는 Fact Pack에 없음 → 확인 필요) |
| 12 | this.spdDetail | SheetTabClick | `SpdDetail_SheetTabClick` | InitEvent:924 | += | 없음 (ChangeSheet/ChangeActiveSheet 2138~2154줄) |
| 13 | this.spdDetail | ActiveSheetChanged | `SpdDetail_ActiveSheetChanged` | InitEvent:925 | += | 없음 |
| 14 | this.spdDetail | CellClick | `SpdDetail_CellClick` | InitEvent:926 | += | 없음 (헤더 체크박스 전체 선택/해제 1802·1837·1841줄) |
| 15 | this.spdDetail | ComboSelChange | `SpdDetail_ComboSelChange` | InitEvent:927 | += | 없음 |
| 16 | this.spdDetail | CellDoubleClick | `SpdDetail_CellDoubleClick` | InitEvent:928 | += | 없음 |
| 17 | this.spdDetail | EditChange | `SpdDetail_EditChange` | InitEvent:929 | += | 없음 |
| 18 | this.spdDetail | ClipboardPasted | `SpdDetail_ClipboardPasted` | InitEvent:930 | += | 없음 (1509줄에서 c["CODE"] 읽음) |
| 19 | this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:932 | += | GET_SHIPMENT_PLAN_DETAIL / STOCK_LOCATION_DETAIL / OWMS_DETAIL / HOLD_STOCK / MES_STOCK / MES_STOCK_DETAIL, SCP0009 |
| 20 | this.spdMain | Change | `SpdMain_Change` | InitEvent:933 | += | 없음 |
| 21 | this.drpPeriod2 | ValueChanged | `DrpPeriod2_ValueChanged` | InitEvent:935 | += | 없음 |
| 22 | this.spdMain | ClipboardPasted | `SpdMain_ClipboardPasted` | InitEvent:937 | += | 없음 |
| 23 | clbDivision_ID | SelectedIndexChanged | `clbDivision_ID_SelectedIndexChanged` | InitEvent:939 | += | 없음 (5883줄 c["DIVISION_ID"], 5889줄 dtDiv_Company_ID NAME 읽음. dtDiv_Company_ID의 데이터 출처는 확인 필요) |
| 24 | clbCompany_ID | SelectedIndexChanged | `clbCompanyID_SelectedIndexChanged` | InitEvent:940 | += | SSP.SSP0021_GET_SHIPMENT_FROM_SITE, SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN |
| 25 | cboPlanDate | SelectedIndexChanged | `cboPlanDate_SelectedIndexChanged` | InitEvent:941 | += | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN |
| 26 | dsdm | Changed | `shtDetail_Change` | InitEvent:944 | += | 없음 (`dsdm` 개체의 정체는 확인 필요) |
| 27 | cboPlanDate | SelectedIndexChanged | `cboPlanDate_SelectedIndexChanged` | clbCompanyID_SelectedIndexChanged:5933 | **-=** | 회사 변경 처리 중 일시 해제 |
| 28 | cboPlanDate | SelectedIndexChanged | `cboPlanDate_SelectedIndexChanged` | clbCompanyID_SelectedIndexChanged:5937 | += | 재연결 |

## 5. Grid 구성 방식

**`HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

1. **META (프레임워크)**: `SpreadInfo.SetSheetHeaderColumn`이 SCM_MST_SHEET_COLUMNS의 메타 컬럼(COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG, VALID_YN, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, UPPERCASE_APPLY_FLAG, ATTRIBUTE1~5 등)을 읽어 헤더를 만든다. 호출 위치는 InitSpread 610(Shipment Plan, 헤더 3행), 634·647·658·698·708·718(각 상세 시트, 헤더 1행)이다.
2. **DB 루프 (코드)**: 화면 자체의 `InitSpreadDateColumn`(862·866줄)이 `GetSpdTitle`(`SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) 결과를 `foreach`로 돌면서 날짜 컬럼을 추가한다.
   - 컬럼명에 `B_`가 포함되면(`IndexOf("B_") > 0`) `AddTextColumn`(너비 0, 숨김)
   - 그 외에는 `AddNumColumn`(너비 70, 표시). DAY_CODE가 SAT이면 ForeColor Blue, SUN이면 Red
   - LARGE/SMALL_CLASS_LABEL_NAME으로 ColumnHeaderSpan을 만들고 "SUM" 헤더를 붙인다(877~906줄).
3. **코드 표시/라벨 변경**:
   - Shipment Plan `MergePolicy = Always` (627줄)
   - `SetSpreadColumn`(4469~4501줄): cboBucketType 값(DAILY/WEEKLY/MONTHLY)과 chkSum 체크 여부에 따라 `D_`/`W_`/`M_` 태그 컬럼의 Visible을 전환한다.
   - Shipment Result의 CHILD_QTY를 Width 75로 지정 (727줄, `p_division_id == "82"` 조건)
   - SpdDetail 헤더 체크박스 셀 Value 토글 (1802/1837/1841줄)

### 5.1 Division별 차이
- grid_effective 기준으로 9개 시트 모두 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)의 표시 컬럼 수가 같다.

| 시트 | 표시 컬럼 수 (전 division 동일) |
|---|---:|
| Hold stock | 10 |
| Hold stock Detail | 10 |
| MES Stock | 9 |
| MES Stock Detail | 13 |
| oWMS Detail | 25 |
| Shipment Plan | 8 (+ 날짜 DB루프 컬럼) |
| Shipment Plan Detail | 42 |
| Shipment Result | 18 |
| Stock Location Detail | 20 |

- 코드 분기 중 division에 따라 달라지는 것은 1건뿐이다: `InitSpread` 727줄, 조건 `spdInfo.SheetName == "Shipment Result"` 및 `p_division_id.ToString().Trim() == "82"` → `CHILD_QTY` Width = 75. 표시 여부가 아니라 너비만 바꾼다. grid_code.csv의 sheet_hint는 "Shipment Plan"으로 찍혀 있지만 조건식은 Shipment Result다.
- SCM_MST_SHEET_MEASURE(Shipment Plan)는 전 division에서 9건이다(측정 항목).

## 6. 화면 로직 사실 (DB 컬럼 사용)
| 메서드 | 내용 |
|---|---|
| InitControls | `UserInfoContext.Current.NowGroupID`, c["CODE"/"NAME"], `dtShipmentInputPeriod.Rows[0/1]`의 VALUE·Diff_VALUE 읽음. dtShipmentInputPeriod 데이터 출처는 확인 필요. FP_Log2 로그 호출(408·419줄) |
| SetChangeControl | GetSSPInnerTable 8회(345~380줄), Filter GROUP_ID·USER_ID(338~339줄) |
| SetChangedControl | `SSP.SSP0021_GET_SHIPMENT_DIVISION` 호출(493줄), c["DIVISION_ID"], dtMyCompany.Rows[0]["NAME"] 읽음 |
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0]의 BLOCK_YN(2930줄)·PERIOD(2939줄) 읽음. 조회 엔드포인트는 확인 필요 |
| Validation_Check | confirm_id 기준으로 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks 검증(3006~3011, 3053~3058, 3143~3148줄) |
| GetShipmentStatusChk | 결과 Tables[0]·[1]·[2]의 CONFIRM_ID 확인(3882/3896/3911줄) |
| GetErpSoNoCnt | 결과 CNT 확인(3853줄) |
| Plan_Current_Check | Tmp_dtPlanDate.Rows[0]의 CODE·NAME·FROM_DATE·TO_DATE 읽음(5540~5559줄) |
| cboPlanDate_SelectedIndexChanged | row CODE, dr FROM_DATE/TO_DATE(5963~5970줄) → GetSpdTitle·InitSpreadDateColumn(5981·5983줄) |
| CalculateSum / Set_SumValues | measure 컬럼 기준 합계(5630·5753·4675줄) |
| Simulation | row의 DIVISION_ID·FROM_SITE·ITEM_ID, dr["Container_Qty"](6124~6130줄). 엔드포인트 호출 없음 |

## 7. 확인 필요 항목
| # | 항목 | 근거 |
|---:|---|---|
| 1 | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`가 FoxQuery에 미등록됨. DB에는 객체(P)가 있으므로 직접 호출 방식인지 확인 필요 | 5916줄, NOT_IN_FOXQUERY |
| 2 | `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`는 FoxQuery에 등록(MATCH)돼 있지만 **DB에 SP 없음**. Hold stock 저장 경로가 실제로 동작하는지 확인 필요 | 2822줄 |
| 3 | 진입점 미연결 메서드 3개(GetErpIFCheck 3941, NewNonSoNo 4290, GetErpIFCheckNew_ 4404)가 실제로 쓰이는지 | flow.csv unreached |
| 4 | Hold stock / Hold stock Detail 시트의 AddSheet 위치. Fact Pack 11장의 '코드에서 생성하는 시트' 목록에 두 시트가 없다. CreateSpread 551~555줄 구간은 Fact Pack에 표시되지 않았다 | grid_code.csv |
| 5 | SpdDetail_SheetTabClick은 탭 인덱스 0·1·2·5만 분기한다(2138~2154줄). 인덱스 3·4와 Hold stock 계열 탭의 처리는 확인 필요 | grid_code.csv |
| 6 | grid_effective는 컬럼명 알파벳순이다. 실제 표시 순서(SORT_ORDER 등)는 메타 원본 확인 필요 | grid_effective.csv |
| 7 | "실제 SP 실행 결과와 매칭되는 시트 없음": grid 단계 미실행 또는 시트명 불일치 | Fact Pack 10장 |
| 8 | GetSSPInnerTable 8회 호출의 코드 값(code=X)은 Fact Pack에 없다 | 4-2절 |
| 9 | `SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL`은 동적 SQL이라 참조 테이블이 정적으로 추출되지 않았다 | endpoints.csv |
| 10 | props.csv 일부가 잘려 있다(5204자). Requestor·layoutControlItem14·17 등의 Text는 미확인 | props.csv |
| 11 | usrButton1(75×23)은 parent가 비어 있다. 화면에 배치되는지 확인 필요 | controls.csv |

=== FILE: source_links.md ===
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

=== FILE: web_components.md ===
# SSP0021 웹 컴포넌트 매핑 (React + Wijmo)

> 라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문이다. props.csv는 일부가 잘려 있어 미확인 라벨을 **확인 필요**로 표기했다.
> Wijmo 컴포넌트명은 매핑 후보이며, 프로젝트 공용 컴포넌트를 쓸지는 TO-BE 표준에 따른다.

## 1. 컨트롤 → 컴포넌트 매핑

### 1.1 상단 조회조건 (usrConditionPanel1 > usrLayoutControl2)
| AS-IS 컨트롤 | 유형 | LayoutControlItem | 라벨 원문 | Size | 비고 | TO-BE 후보 |
|---|---|---|---|---|---|---|
| clbDivision_ID | UsrCombo | lblCombo1 | `Division*` | 150×20 | SelectedIndexChanged 연결 | Wijmo ComboBox (단일 선택) |
| clbCompany_ID | UsrCombo | layoutControlItem1 | `Company*` | 178×20 | 변경 시 `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` 호출 | Wijmo ComboBox |
| clbPlantSite | UsrCheckedList | layoutControlItem7 | `From Site` | 220×21 | 다중 선택 | Wijmo MultiSelect |
| cboPlanDate | UsrCombo | PlanDate | `Plan-date*` | 138×20 | 변경 시 날짜 헤더 재구성 | Wijmo ComboBox |
| drpPeriod | UsrDateRangePicker | layoutControlItem6 | `Period*` | 197×20 | **Enabled=false** (읽기전용) | InputDate ×2 (비활성) |
| cboBucketType | UsrCombo | lblBucket | `Bucket` | 320×20 | DAILY/WEEKLY/MONTHLY 열 전환 | Wijmo ComboBox |
| chkSum | UsrCheckBox | layoutControlItem8 | `Sum` (컨트롤 Text) | 84×25 | 합계 열 표시 | CheckBox |
| txtItemId | UsrMultiLineEditor | lblItemId | `Model` | 695×21 | 다중 값 입력 | 다중값 TextInput |
| btnItemId | UsrButton | layoutControlItem2 | (Text 없음) | 39×24 | btnItemId_Click | 아이콘 버튼(팝업) |
| btnMeasure | UsrButton | layoutControlItem10 | (Text 없음) | 39×25 | BtnMeasure_Click | 아이콘 버튼 |
| btnSimulation | UsrButton | layoutControlItem12 | `Simulation` (컨트롤 Text) | 106×25 | BtnSimulation_Click | Button |
| chkSql | UsrCheckBox | lblSql | `Show SQL` (컨트롤 Text) | 98×20 | 이벤트 배선 없음 | 확인 필요(개발용 여부) |
| usrButton1 | UsrButton | — | — | 75×23 | parent 없음 | 확인 필요 |

### 1.2 하단 상세 조건 (splitContainer1.Panel2 > usrLayoutControl3)
| AS-IS 컨트롤 | 유형 | LayoutControlItem | 라벨 원문 | Size | 비고 | TO-BE 후보 |
|---|---|---|---|---|---|---|
| drpPeriod2 | UsrDateRangePicker | layoutControlItem11 | `Shipment Date` | 197×20 | DrpPeriod2_ValueChanged | InputDate ×2 |
| drpPeriod3 | UsrDateRangePicker | layoutControlItem13 | `Shipment Date` | 197×20 | 이벤트 배선 없음 | InputDate ×2 |
| txtModel2 | UsrMultiLineEditor | layoutControlItem4 | `Model` | 264×21 | | 다중값 TextInput |
| btnItemID2 | UsrButton | layoutControlItem5 | `layoutControlItem2` (원문 그대로. 기본값 텍스트로 보이나 표시 여부는 확인 필요) | 39×25 | BtnItemID2_Click | 아이콘 버튼 |
| txtRequestor | UsrTextBox | Requestor | 확인 필요 (props 잘림) | 147×25 | | TextInput |
| btnRequestor | UsrButton | layoutControlItem9 | (Text 없음) | 39×24 | BtnRequestor_Click | 아이콘 버튼(팝업) |
| clbResultType | UsrCheckedList | 확인 필요 | 확인 필요 | 104×21 | | Wijmo MultiSelect |
| txtBoxID | UsrMultiLineEditor | 확인 필요 | 확인 필요 | 205×21 | | 다중값 TextInput |
| btnSearch | SimpleButton | layoutControlItem3 | `Search` (컨트롤 Text) | 47×25 | BtnSearch_Click → 활성 상세 시트 재조회 | Button |

### 1.3 Grid
| AS-IS | 유형 | 위치 | 시트 | TO-BE 후보 |
|---|---|---|---|---|
| spdMain | FpSpread | splitContainer1.Panel1, Dock=Fill | Shipment Plan (헤더 3행) | Wijmo FlexGrid (다단 헤더 + 동적 날짜 열, MergePolicy Always → allowMerging) |
| spdDetail | FpSpread | splitContainer1.Panel2, Dock=Fill | 상세 시트 8개 (2.2절) | 탭 + 시트별 Wijmo FlexGrid |

## 2. 화면 배치

### 2.1 분할 (props.csv 기준)
| 영역 | Dock | Size | 비고 |
|---|---|---|---|
| usrConditionPanel1 | Top | 1689×73 | UsrPanelType=HidePanel (접기 가능 패널) |
| usrLayoutControl2 | Top | 1689×77 | 조회조건 레이아웃(LayoutControlGroup2 1689×77) |
| splitContainer1 | Fill | 1689×576 | **Orientation=Horizontal → 상/하 분할**, SplitterDistance=303 |
| ├ Panel1: spdMain | Fill | 1689×303 | 상단 |
| └ Panel2: usrLayoutControl3 | Top | 1689×40 | 하단 조건 줄 (LayoutControlGroup3 1689×49) |
| └ Panel2: spdDetail | Fill | 1689×229 | 하단 Grid |

- 상/하 비율(SplitterDistance ÷ 높이): 상단 303 / 576 = **52.6%**, 하단 (576−303) / 576 = **47.4%**.
- 하단 내부: 조건 줄 40 + spdDetail 229 = 269. 576 − 303 − 269 = 4px이 남는데, 이것이 Splitter 폭인지는 SplitterWidth 속성이 Fact Pack에 없어 확인 필요.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

- 9개 시트 모두 `META+코드연결`이다. 표시 판정은 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 **모두 같다**.
- 순서는 CSV의 알파벳순이다. 실제 표시 순서는 메타 SORT 정보 확인이 필요하다.
- "기본" = 메타 표시(VISIBLE·VALID=Y, DEFAULT), "숨김" = 메타 비표시.

### 3.1 Shipment Plan (spdMain, 표시 8 / 전체 13 + 날짜 DB루프 열)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| BACK_COLOR | Back Color | 숨김 |
| BOH_QTY | BOH_QTY | 기본 |
| BOH_TYPE | BOH_TYPE | 기본 |
| CONFIRM_DAY | Confrim Day | 숨김 |
| DIVISION_ID | Div | 기본 |
| FROM_SITE | Site | 숨김 |
| FROM_SITE_DESCRIPTION | From Site | 기본 |
| ITEM_ID | Model | 기본 |
| LOT_YN | Lot_YN | 숨김 |
| MEASURE | Measure | 숨김 |
| MEASURE_NAME | Measure | 기본 |
| NICK_NAME | Nick Name | 기본 |
| PSI | PSI | 기본 |

코드 추가 사항:
- MEASURE 다음 열부터(`GetColumnIndex(MEASURE)+1`) `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과로 날짜 열을 반복 생성한다.
- 컬럼명에 `B_`가 포함되면 Text, 너비 0, 숨김. 그 외는 Num, 너비 70, 표시. SAT는 파랑, SUN은 빨강 글자.
- 헤더 3행: LARGE_CLASS / SMALL_CLASS Span과 "SUM" 헤더.
- `SetSpreadColumn`이 Bucket과 Sum 값에 따라 열 표시를 바꾼다:

| Bucket | D_ 열 | W_ 열 | M_ 열 |
|---|---|---|---|
| DAILY | 표시 (D_ 또는 W_ 조건에 true) | D_/W_ 조건에 true, 이어서 M_/W_ 조건에 chkSum.Checked (실행 순서상 최종값은 확인 필요) | chkSum.Checked |
| WEEKLY | 숨김 | 표시 | chkSum.Checked |
| MONTHLY | 숨김 | 숨김 | 표시 |

- SCM_MST_SHEET_MEASURE에 Measure 9건(전 division)이 있다.
- MergePolicy = Always.

### 3.2 Shipment Plan Detail (표시 42 / 전체 69)
| 컬럼 | 라벨 | 표시 | | 컬럼 | 라벨 | 표시 |
|---|---|---|---|---|---|---|
| A_COUNTRY | A Contry | 기본 | | NEW_ETD | ETD | 숨김 |
| A_PORT_CODE | A Port Code | 기본 | | NEW_INCOTERMS | new incoterms | 숨김 |
| A_PORT_NAME | A Port Name | 기본 | | NEW_LT_DAY | L/T(Day) | 숨김 |
| ATTRIBUTE10 | ATTRIBUTE10 | 기본 | | NEW_ROUTE_ID | Route | 숨김 |
| BOD_ID | bod_id | 숨김 | | NEW_SHIPMENT_DATE | Shipment Date* | 숨김 |
| CHANGE_REASON_CODE | Change Reason | 기본 | | NEW_TO_CITY | To City | 숨김 |
| CHANGE_REASON_DETAIL | Reason Detail | 기본 | | NEW_TO_COUNTRY | To Country | 숨김 |
| CHANGE_REQ_NO | Change Request No | 기본 | | NEW_TRANSPORT_MODE | Trans Mode | 숨김 |
| CHANGE_TYPE | CHANGE_TYPE | 숨김 | | NICK_NAME | Nick Name | 기본 |
| CHECK_NEED_YN | Checked | 숨김 | | ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID | 숨김 |
| CITY_NAME | City Name | 기본 | | ORIGIN_TO_DIVISION_ID | ORIGIN_TO_DIVISION_ID | 숨김 |
| CONFIRM_ID | Confirm/Plan ID | 기본 | | PROJECT_CODE | Project Code | 기본 |
| COUNTRY_NAME | Country Name | 기본 | | PROJECT_NAME | Project Name | 기본 |
| DIVISION_ID | Div | 기본 | | REMARKS | Remarks | 기본 |
| EDIT_MAIN | EDIT_MAIN | 숨김 | | REMARKS2 | Building | 기본 |
| EDIT_REMARKS | EDIT_REMARKS | 숨김 | | REMARKS3 | Customer Requirement | 기본 |
| ELECTRODE_TYPE | ELECTRODE_TYPE | 숨김 | | REQUESTOR | Shipment Requestor | 기본 |
| ELECTRODE_YN | ELECTRODE_YN | 숨김 | | SHIPMENT_CONFIRM_QTY | Shipment Qty* | 기본 |
| END_CUSTOMER | End Customer | 기본 | | SHIPMENT_DATE | Shipment Date* | 기본 |
| ERP_SO_NO | SO No | 기본 | | SHIPMENT_STATUS | Status | 기본 |
| ERP_STATUS | erp_status | 숨김 | | SHIPTO_CITY_NAME | Ship To City Name | 기본 |
| ETA | ETA | 기본 | | SHIPTO_DESCRIPTION | Ship To Party | 기본 |
| ETD | ETD | 기본 | | SHIPTO_REGION_NAME | Ship To Region Name | 기본 |
| Expected_Shipping_Date | Expected Shipping Date | 기본 | | SOLDTO_DESCRIPTION | Sold To Party | 기본 |
| FCST_TYPE | FCST Type | 기본 | | TEAM | Team | 기본 |
| FROM_SITE | From Site ID | 숨김 | | TO_SITE | To Site ID | 숨김 |
| FROM_SITE_DESCRIPTION | From Site | 기본 | | TO_SITE_DESCRIPTION | To Site | 기본 |
| INCOTERMS | Incoterms | 기본 | | TRANSPORT_MODE | Trans Mode* | 기본 |
| ITEM_ID | Model | 기본 | | UPDATED_BY | Updated By | 기본 |
| LT_DAY | L/T(Day) | 기본 | | UPDATED_DATE | Updated Date | 기본 |
| MODEL_USER | Model PIC | 기본 | | NEW_A_COUNTRY | A Country | 숨김 |
| MTK_OWNER | MKT Owner | 기본 | | NEW_A_PORT_CODE | A Port | 숨김 |
| NEW_BOD_ID | new bod | 숨김 | | NEW_CUSTOMER_LT | Customer LT | 숨김 |
| NEW_D_COUNTRY | D Country | 숨김 | | NEW_D_PORT_CODE | D Port | 숨김 |
| NEW_ETA | ETA | 숨김 | | | | |

- Validation_Check 대상 필드: shipment_confirm_qty(Shipment Qty*), shipment_date(Shipment Date*), TRANSPORT_MODE(Trans Mode*), remarks2(Building), remarks(Remarks).
- 헤더 체크박스 전체 선택/해제(SpdDetail_CellClick)가 적용되는 열은 확인 필요.

### 3.3 Stock Location Detail (표시 20 / 전체 20)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| AVAILABLE_DATE | Available Date | 기본 |
| AVAILABLE_QTY | Available Qty | 기본 |
| COMPANY_ID | Company | 기본 |
| CUTOFF_DATE | Cutoff Date | 기본 |
| DEFECT_QTY | Deffect Qty | 기본 |
| DIVISION_ID | Div | 기본 |
| FROM_SITE | From Site | 기본 |
| HOLDING_DATE | Holding Date | 기본 |
| ITEM_ID | Model | 기본 |
| MOVING_QTY | Moving Qty | 기본 |
| NICK_NAME | Nick Name | 기본 |
| OUTSOURCING_FACTORY | Outsourcing Factory | 기본 |
| OUTSOURCING_FLAG | Outsourcing Flag | 기본 |
| PLANT_ID | Plant | 기본 |
| QTY_UOM | Qty Uom | 기본 |
| STOCK_TYPE | Stock Type | 기본 |
| STORAGE_DESCRIPTION | Storage | 기본 |
| STORAGE_ID | Storage ID | 기본 |
| TOTAL_QTY | Total Qty | 기본 |
| WIPHOLD_YN | Wiphold Yn | 기본 |

### 3.4 oWMS Detail (표시 25 / 전체 25)
| 컬럼 | 라벨 | 컬럼 | 라벨 |
|---|---|---|---|
| ALLOCATION_QTY | Allocation Qty | MOVING_QTY | Moving Qty |
| AVAILABLE_QTY | Available Qty | NICK_NAME | Nick Name |
| CAPA_GRADE | Capa. Grade | PACKING_QTY | Packing Qty |
| CUSTOMER_CODE | Customer Code | PACKING_STATUS | Packing Status |
| CUSTOMER_NAME | Customer Name | PALLET_ID | Pallet ID |
| DIVISION_ID | Div | PLANT_ID | Plant ID |
| EXPIRATION_QTY | Expiration Qty | RECEIVING_QTY | Reciving Qty |
| GRADE | Grade | SOC | SOC |
| HOLD_QTY | Hold Qty | STOCK_QTY | Stock Qty |
| ITEM_ID | Model | STOCK_STATUS | Inventory Status |
| LONG_TERM_QTY | Long-term Qty | STORAGE_ID | Storage |
| LOT_ID | Lot ID | UNDECIDED_QTY | Undecided Qty |
| LOT_ISSUE_DATE | Lot Issue Date | | |
(25개 모두 "기본" 표시)

### 3.5 Hold stock (표시 10 / 전체 12)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| DIVISION_ID | Div | 기본 |
| FROM_SITE | Site | 숨김 |
| FROM_SITE_NM | From Site | 기본 |
| HOLD_ID | HOLD_ID | 숨김 |
| HOLD_QTY | Amend Qty* | 기본 |
| HOLD_YYYYMMDD | Start Date | 기본 |
| ITEM_ID | Model | 기본 |
| LAST_UPDATE_DATE | Last Updated Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| NICK_NAME | Nick Name | 기본 |
| RELEASE_YYYYMMDD | End Date* | 기본 |
| REMARKS | Remarks | 기본 |

- 라벨의 `*`(Amend Qty*, End Date*)는 입력 필수 표기다. 저장 SP는 `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`인데 DB에 SP가 없다 → 확인 필요.

### 3.6 Hold stock Detail (표시 10 / 전체 12)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| DIVISION_ID | Div | 기본 |
| FROM_SITE | Site | 숨김 |
| FROM_SITE_NM | From Site | 기본 |
| HOLD_ID | HOLD_ID | 숨김 |
| HOLD_QTY | Amend Qty | 기본 |
| HOLD_YYYYMMDD | Start Date | 기본 |
| ITEM_ID | Model | 기본 |
| LAST_UPDATE_DATE | Last Updated Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| NICK_NAME | Nick Name | 기본 |
| RELEASE_YYYYMMDD | End Date | 기본 |
| REMARKS | Remarks | 기본 |

- Hold stock과 컬럼 구성은 같고 `*` 표기만 없다. 이 시트를 코드에서 AddSheet/ChangeSheet하는 지점은 Fact Pack 표시 범위에서 확인되지 않았다 → 확인 필요.

### 3.7 MES Stock (표시 9 / 전체 9)
| 컬럼 | 라벨 |
|---|---|
| AVAILABLE_STOCK | Available Stock |
| BEFORE_OQC | Before OQC |
| ITEM_ID | Model |
| NICK_NAME | Nick Name |
| OQC_COMPLETE | OQC Complete |
| OQC_INSP_REQUEST | OQC Insp Request |
| OQC_NG | OQC NG |
| QMS_MES_HOLD | QMS/MES Hold |
| TOTAL | Total |

### 3.8 MES Stock Detail (표시 13 / 전체 13)
| 컬럼 | 라벨 |
|---|---|
| AVAILABLE_YN | Available stock YN |
| BOXID | Box ID |
| EXP_INSP_VALID_DATE | Exp Insp Vaild Date |
| LOT_QTY | Lot Qty |
| LOTID | Lot ID |
| MES_HOLD_YN | MES Hold YN |
| MES_UNHOLD_SCHD_DATE | MES Unhold Sched Date |
| OQC_INSP_RESULT | OQC Insp Result |
| PRJT_NAME | Nick Name |
| PROD_VALID_DATE | Prod Valid Date |
| PRODID | Model |
| QMS_HOLD_YN | QMS Hold YN |
| QMS_UNHOLD_SCHD_DATE | QMS Unhold Sched Date |

### 3.9 Shipment Result (표시 18 / 전체 18)
| 컬럼 | 라벨 | 비고 |
|---|---|---|
| CHILD_QTY | Shipment Pack Qty | division **82**일 때 Width=75 (InitSpread 727줄) |
| CONFIRM_ID | Confirm/Plan ID | |
| DIVISION_ID | Div | |
| END_CUSTOMER | End Customer | |
| ERP_SO_NO | SO No | |
| ETA_DATE | ETA | |
| ETD_DATE | ETD | |
| FROM_SITE | From Site | |
| INCOTERMS | Incoterms | |
| ITEM_ID | Model | |
| NICK_NAME | Nick Name | |
| PROJECT_CODE | Prj Code | |
| QTY | Shipment Qty | |
| SHIP_TYPE | Ship Type | |
| TO_SITE | To Site | |
| TRANSPORT_MODE | Trans Mode | |
| TYPE | Status | |
| YYYYMMDD | Shipment Date | |

## 4. 시트 연결 규칙

### 4.1 spdMain(Shipment Plan) 더블클릭 → spdDetail 시트 전환 (SpdMain_CellDoubleClick 2059~2094줄)
| 조건 | 전환 시트 | 조회 엔드포인트 (flow.csv) |
|---|---|---|
| 클릭 열 ≥ MEASURE+1 이고 MEASURE == "SHIP_PLAN" | Shipment Plan Detail | SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL |
| 클릭 열 = BOH_QTY 이고 BOH_TYPE == "ERP" | Stock Location Detail | SSP.SSP0021_GET_STOCK_LOCATION_DETAIL |
| 클릭 열 = BOH_QTY 이고 BOH_TYPE == "oWMS" | oWMS Detail | SSP.SSP0021_GET_OWMS_DETAIL |
| 클릭 열 = BOH_QTY 이고 BOH_TYPE == "HOLD" | Hold stock | SSP.SSP0021_GET_HOLD_STOCK |
| 클릭 열 = BOH_QTY 이고 BOH_TYPE == "MES" | MES Stock Detail(2088~2089줄) → MES Stock(2093~2094줄) | SSP.SSP0021_GET_MES_STOCK_DETAIL, SSP.SSP0021_GET_MES_STOCK |

### 4.2 spdDetail 탭 클릭 (SpdDetail_SheetTabClick 2138~2154줄)
| SheetTabIndex | 시트 |
|---:|---|
| 0 | Shipment Plan Detail |
| 1 | Stock Location Detail |
| 2 | oWMS Detail |
| 5 | Shipment Result |
| 3, 4 및 Hold stock 계열 | Fact Pack에 분기 없음 → 확인 필요 |

### 4.3 spdDetail 시트 생성 순서 (CreateSpread)
548 Shipment Plan Detail → 549 Stock Location Detail → 550 oWMS Detail → (551~555 미표시) → 556 MES Stock → 557 MES Stock Detail → 559 Shipment Result → 594 Shipment Plan Detail을 활성 시트로 설정.

### 4.4 상세 Search 버튼
`BtnSearch_Click`은 활성 상세 시트에 맞춰 PLAN_DETAIL / STOCK_LOCATION_DETAIL / OWMS_DETAIL / SHIPMENT_RESULT / MES_STOCK / MES_STOCK_DETAIL을 재조회한다(flow.csv). 시트와 SP의 분기 조건식은 Fact Pack에 없다 → 확인 필요.

=== FILE: oracle_migration.md ===
# SSP0021 Oracle 전환 분석

> AS-IS: MSSQL SP (FoxQuery 경유). 참조 객체는 SP 내부 EXEC 전이까지 포함한 정적 추출 결과다.

## 1. 호출 SP 인벤토리

| # | SP | FoxQuery 키 | 호출 수 | EXEC 체인 (하위 SP) | 쓰기 | 읽기 | 함수/특수 |
|---:|---|---|---:|---|---|---|---|
| 1 | SSP0021_GET_SHIPMENT_DIVISION | SSP.SSP0021_GET_SHIPMENT_DIVISION | 1 | — | #RETURNTABLE(임시) | SCM_MST_DIVISION, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_CODE_LOOKUP_VALUE | FN_GET_LOOKUP_VALUE |
| 2 | SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM | SSP.SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM | 1 | PR_SCM_SYS_LOG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_PLN_FP_SHIP_TARGET_WA, PR_SCP_SYS_LOG_BATCH, PR_SSP_MAIL_SEND_ADJUST_SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_SSP_ANL_SHIP_CONFIRM_ROUTE (11종) | SSP_ANL_SHIP_CONFIRM(U/I), SSP_ANL_SHIP_CONFIRM_H(I), SSP_MST_SEND_MAIL_REQ(I/U), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN(I), XIF_SCS_PACK_SHIP_PLAN_S_SN(I), SSP_ANL_SHIP_CONFIRM_CHG_REQ(I), SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE(I), SCM_SYS_LOG_BATCH(I), #TBLSSPADJUSTMAILSEND | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SSP_MST_SEND_MAIL_REQ, SSP_PLAN_VERSION_V, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, NERP_CONV_MASTER, TB_FX_USER, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_PROJECT, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER_EE | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL, FN_GET_SSP_ETA_DATE, FN_MULTY_TIME, FN_GET_SSP_SITE_INFO(_EXCEPTION), FN_ZERO_LPAD, FN_GET_ITEM_NICKNAME, FN_GET_SITE_CUSTOMER_INFO, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_USER_NAME, FN_WEEKOFDAY_DATE, UF_FX_STRING_SPLIT, FN_NEXT_DAY / 임시 #T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT |
| 3 | SSP0021_SAVE_HOLD_STOCK_DATA | SSP.SSP0021_SAVE_HOLD_STOCK_DATA | 1 | — | 확인 필요 | 확인 필요 | ⚠ **DB에 SP 없음** |
| 4 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 1 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN | SSP_ANL_SHIP_ERP_ERROR_CONFIRM(I), SSP_ANL_SHIP_CONFIRM_CHG_REQ(U), SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE(U), SCM_SYS_LOG_BATCH(I) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| 5 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 2 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE(U), SSP_ANL_SHIP_CONFIRM(U/D), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN(I), SCM_SYS_LOG_BATCH(I), #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | SCM_ARR_SPL_CNT/VAL, FN_GET_SSP_SITE_INFO(_EXCEPTION), FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS |
| 6 | SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | SSP.SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING | 3 | PR_SCM_SYS_LOG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCP_SYS_LOG_BATCH | SSP_ANL_SHIP_CONFIRM_CHG_REQ(I), SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE(I/U), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN(I), SCM_SYS_LOG_BATCH(I) | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | SCM_ARR_SPL_CNT/VAL, FN_GET_SSP_ETA_DATE, FN_GET_SSP_SITE_INFO(_EXCEPTION), FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS |
| 7 | SSP0021_GET_ERP_SO_NO_CNT | SSP.SSP0021_GET_ERP_SO_NO_CNT | 1 | — | — | SSP_ANL_SHIP_CONFIRM | 결과 CNT |
| 8 | SSP0021_GET_SHIPMENT_STATUS | SSP.SSP0021_GET_SHIPMENT_STATUS | 1 | — | — | SSP_ANL_SHIP_CONFIRM | STRING_SPLIT / 결과셋 3개(Tables[0..2]) |
| 9 | SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | SSP.SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING | 2 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN | SSP_ANL_SHIP_CONFIRM_CHG_REQ(U), SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE(U), SCM_SYS_LOG_BATCH(I) | — | 호출 지점 모두 진입점 미연결 |
| 10 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 2 | PR_SCP_SYS_LOG_BATCH | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN(I), SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE(U), SCM_SYS_LOG_BATCH(I) | SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | FN_GET_SSP_SITE_INFO(_EXCEPTION), FN_GET_SSP_VMI_YN, FN_GET_SSP_MKT_FCST_INCOTERMS |
| 11 | DM0003_GET_BUCKET_TYPE_CODE | DM.DM0003_GET_BUCKET_TYPE_CODE | 1 | — | — | SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| 12 | SSP0021_GET_SHIPMENT_PLAN | SSP.SSP0021_GET_SHIPMENT_PLAN | 1 | — | 임시 7종(#TBLDYNAMICTITLEST_SSP0021, #TMP_RESULT_TABLE, #TMP_BOHDATA_STORAGE, #TMP_BOHDATA, #TMP_ROWDATA, #TMP_RESULT_PIVOT_TABLE, #TMP_RESULT_PIVOT_TABLE_OLD), `UPDATE:C`, MERGE #TMP_RESULT_TABLE | SCM_MST_TITLESET_USER, SSP_DNM_GMES_STOCK_81_82, SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, MST_STOCK, MST_LOCATION, PACKER_STOCK, SCM_MST_SITE, SCM_MST_ITEM_SN, SSP_DNM_STOCK_C, SSP_DNM_ESS_PACKER_STOCK_V, SSP_MST_LOCATION_V, DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_CONFIRM, SSP_DNM_FP_PLAN_FROZEN, SCP_ANL_PRODUCTION_PLAN, SCP_PLAN_VERSION_V, SSP_DNM_FP_AMEND_SHIPAVAL, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_DNM_CELL_INHOUSE_PLAN_SN, SCP_MST_BOD_N_V, SCP_MST_SHIPMENT_LOT_SIZE, SSP_ANL_SHIP_PLAN_C, SCM_CODE_LOOKUP_VALUE | STRING_SPLIT, FN_GET_ANL_SHIP_FROZEN_DAY_CNT, FN_GET_SSP_ETA_DATE, UF_FX_STRING_SPLIT, FN_LIST_LOOKUP_VALUE, **동적 SQL**, 피벗 |
| 13 | SSP0021_GET_SHIPMENT_PLAN_DETAIL | SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL | 1 | — | — | 정적 추출 없음(동적 SQL) → 확인 필요 | FN_GET_IN_STR, FN_SCM_SPLIT, **동적 SQL** |
| 14 | SSP0021_GET_STOCK_LOCATION_DETAIL | SSP.SSP0021_GET_STOCK_LOCATION_DETAIL | 1 | — | — | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_DNM_STOCK_C, SSP_DNM_ESS_PACKER_STOCK_V, SCM_MST_ITEM_SN | FN_GET_IN_STR, STRING_SPLIT, FN_GET_ITEM_NICKNAME, FN_SCM_SPLIT |
| 15 | SSP0021_GET_OWMS_DETAIL | SSP.SSP0021_GET_OWMS_DETAIL | 1 | — | — | SSP_ANL_OWMS_STOCK_C2, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SLOC, SSP_MST_MODEL_USER, SCM_MST_ITEM_SN | FN_GET_IN_STR, FN_GET_ITEM_NICKNAME, STRING_SPLIT, FN_SCM_SPLIT |
| 16 | SSP0021_GET_SHIPMENT_RESULT | SSP.SSP0021_GET_SHIPMENT_RESULT | 1 | — | — | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MODEL_COMP_TEMP_SN, SCM_ITEM_M_SN, SCM_ITEM_CLASS_M_SN, SCM_DNM_EXFACTORY_RESULT, SCM_MST_ITEM_SN, SCP_MST_FINAL_ITEM, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS (+ RESULT_ERP_C_EXIST, RESULT_CHILD_QTY, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS: CTE 여부 확인 필요) | FN_GET_ITEM_NICKNAME, FN_GET_SCM_SITE_DESCRIPTION, STRING_SPLIT |
| 17 | SSP0021_GET_HOLD_STOCK | SSP.SSP0021_GET_HOLD_STOCK | 1 | — | — | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SCM_MST_SITE, SCM_MST_ITEM_SN | FN_GET_IN_STR, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_ITEM_NICKNAME, FN_CHAR_TO_DATE, STRING_SPLIT, FN_SCM_SPLIT |
| 18 | SSP0021_GET_MES_STOCK | SSP.SSP0021_GET_MES_STOCK | 1 | — | — | SSP_DNM_GMES_STOCK_81_82 | FN_GET_IN_STR, STRING_SPLIT, FN_SCM_SPLIT |
| 19 | SSP0021_GET_MES_STOCK_DETAIL | SSP.SSP0021_GET_MES_STOCK_DETAIL | 1 | — | — | SSP_DNM_GMES_STOCK_81_82 | FN_GET_IN_STR, STRING_SPLIT, FN_SCM_SPLIT |
| 20 | SSP0002_GET_USER_INFO_LIST | SSP.SSP0002_GET_USER_INFO_LIST | 1 | — | — | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | — |
| 21 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 1 | — | — | SCM_SYS_CALENDAR_M | — |
| 22 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME | 1 | PR_SCM_SYS_LOG_BATCH | SCM_SYS_LOG_BATCH(I) | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |

## 2. 공통코드 분기 (code=X → 테이블)

| 호출 | 위치 | 프레임워크 구현 | 읽는 메타 컬럼 | code 값 |
|---|---|---|---|---|
| GetSSPInnerTable ×8 | SetChangeControl 345, 350, 355, 360, 365, 370, 375, 380 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID | **확인 필요** (Fact Pack에 인자 값 없음) |

- 화면 메타 행이 있는 SCM_ADM_LOOKUP_MASTER_DETAIL에는 4행이 있다(dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv). 그 값과 GetSSPInnerTable/InitControls(dtShipmentInputPeriod VALUE·Diff_VALUE), chkERPIFBlockYn(BLOCK_YN·PERIOD)이 어떻게 대응하는지는 **확인 필요**.
- SCM_ADM_LOOKUP_MASTER_DETAIL을 읽는 SP는 GET_SHIPMENT_DIVISION, SAVE_SHIPMENT_REQUEST_CONFIRM, DELETE_..._BY_CONFIRM, SAVE_..._DRAFTING, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, DM0003_GET_BUCKET_TYPE_CODE, GET_SHIPMENT_PLAN, GET_STOCK_LOCATION_DETAIL, GET_OWMS_DETAIL, GET_SHIPMENT_RESULT, GET_SHIPMENT_FROM_SITE이다.

## 3. FoxQuery 미등록 / 직접 호출 SP

| SP | 호출 위치 | 상태 | DB 보강 |
|---|---|---|---|
| SSP0021_GET_SHIPMENT_FROM_SITE | clbCompanyID_SelectedIndexChanged:5916 | NOT_IN_FOXQUERY | DB 객체 존재(P), SELECT: SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION. 직접 호출 방식 확인 필요 |
| SSP0021_SAVE_HOLD_STOCK_DATA | SaveData_Detail:2822 | FoxQuery MATCH, **DB에 SP 없음** | 전환 대상 원본이 없다. 운영 DB에서 재확인하거나 대체 로직을 확인해야 한다 |

- 주석 처리됨: `SSP0046_GET_BUCKET_TYPE_CODE` (320줄). 전환 대상이 아니다.

## 4. Oracle 전환 시 확인 포인트 (사실 기반)

| # | 항목 | 해당 SP | 근거 |
|---:|---|---|---|
| 1 | `STRING_SPLIT`(MSSQL 전용) 대체 | GET_SHIPMENT_PLAN, GET_SHIPMENT_STATUS, GET_STOCK_LOCATION_DETAIL, GET_OWMS_DETAIL, GET_SHIPMENT_RESULT, GET_HOLD_STOCK, GET_MES_STOCK, GET_MES_STOCK_DETAIL | REF:STRING_SPLIT |
| 2 | `#` 임시 테이블 → GTT 등 | GET_SHIPMENT_DIVISION(#RETURNTABLE), SAVE_SHIPMENT_REQUEST_CONFIRM(#T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #TBLSSPADJUSTMAILSEND), DELETE_..._BY_CONFIRM(#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106), GET_SHIPMENT_PLAN(7종) | CREATE/INSERT:# |
| 3 | 동적 SQL | GET_SHIPMENT_PLAN, GET_SHIPMENT_PLAN_DETAIL | DYNAMIC@ |
| 4 | MERGE 및 별칭 UPDATE(`UPDATE:C`) | GET_SHIPMENT_PLAN | MERGE:#TMP_RESULT_TABLE, UPDATE:C |
| 5 | 결과셋 여러 개 | GET_SHIPMENT_STATUS (Tables[0], [1], [2]의 CONFIRM_ID 사용) | GetShipmentStatusChk 3882/3896/3911줄 |
| 6 | 외부 시스템 인터페이스 테이블 쓰기 | SAVE_SHIPMENT_REQUEST_CONFIRM(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN), SAVE_..._DRAFTING / DELETE_..._BY_CONFIRM / PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN) | INSERT:XIF_* |
| 7 | 메일 발송 체인 | SAVE_SHIPMENT_REQUEST_CONFIRM → PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_MAIL_SEND_ADJUST_SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG | EXEC |
| 8 | 트랜잭션 로그 SP(`PR_SCM_SYS_LOG_BATCH_CALL_TRAN`) | SAVE_SHIPMENT_REQUEST_CONFIRM, ERP_ERROR_CONFIRM, DELETE_..._BY_CONFIRM, DELETE_SHIPMENT_REQUEST_DRAFTING | EXEC. 트랜잭션 경계 동작 확인 필요 |
| 9 | 조회성 SP가 로그 테이블에 쓰기 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | INSERT:SCM_SYS_LOG_BATCH |
| 10 | 소유가 불분명한 참조 객체 | GET_SHIPMENT_PLAN의 MST_STOCK, MST_LOCATION, PACKER_STOCK | 스키마·DB 링크 여부 확인 필요 |
| 11 | CTE/객체 판별 | GET_SHIPMENT_RESULT의 RESULT_ERP_C_EXIST 등 6개 | 확인 필요 |
| 12 | 배열 분해 함수 | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL (저장 계열 5종) | 저장 파라미터 구분자 규약 확인 필요 |
| 13 | 원본 SP 부재 | SSP0021_SAVE_HOLD_STOCK_DATA | DB에 SP 없음 |

## 5. 난이도 (Fact Pack 수치 기준)

| SP | 근거 수치 | 난이도 |
|---|---|---|
| SSP0021_GET_SHIPMENT_PLAN | 참조 48건, 임시 7종, 동적 SQL, MERGE, 피벗 | 상 |
| SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM | 참조 58건, EXEC 11종, 쓰기 테이블 9종, 메일·인터페이스 | 상 |
| SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 참조 27건, DELETE 포함, 임시 1종 | 중 |
| SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING / PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 참조 27 / 17건, XIF 쓰기 | 중 |
| SSP0021_GET_SHIPMENT_RESULT | 참조 25건, CTE 판별 필요 | 중 |
| SSP0021_GET_SHIPMENT_PLAN_DETAIL | 동적 SQL, 정적 참조 미추출 | 중 (원문 확인 후 재판정) |
| SSP0021_GET_SHIPMENT_DIVISION, SSP0021_GET_STOCK_LOCATION_DETAIL, SSP0021_GET_OWMS_DETAIL, SSP0021_GET_HOLD_STOCK, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SSP0021_DELETE_SHIPMENT_REQUEST_DRAFTING, SCM_SSP_CHECK_CONFIRM_CHANGETIME | 참조 5~12건 | 하~중 |
| SSP0021_GET_ERP_SO_NO_CNT, SSP0021_GET_SHIPMENT_STATUS, SSP0021_GET_MES_STOCK, SSP0021_GET_MES_STOCK_DETAIL, DM0003_GET_BUCKET_TYPE_CODE, SCP0009_GET_SHEET_CALENDAR_3SPAN, SSP0002_GET_USER_INFO_LIST | 참조 1~6건 | 하 |
| SSP0021_SAVE_HOLD_STOCK_DATA | 원본 없음 | 판정 불가 |

(참조 건수 = endpoints.csv objects 항목 수. EXEC 자기 자신을 포함한다.)

=== FILE: tobe_design.md ===
# SSP0021 TO-BE 설계 입력 (사실 기반)

> API 경로·이름은 **후보**다. 확정은 TO-BE 명명 규약을 따른다.

## 1. 조회조건 (컨트롤 기준)

### 1.1 메인 조회 (FindButton → `SSP.SSP0021_GET_SHIPMENT_PLAN`)
| 라벨 | AS-IS 컨트롤 | 필수 표기 | 값 원천 | 연쇄 동작 |
|---|---|---|---|---|
| Division* | clbDivision_ID (UsrCombo) | `*` | `SSP.SSP0021_GET_SHIPMENT_DIVISION` (SetChangedControl 493줄) | clbDivision_ID_SelectedIndexChanged |
| Company* | clbCompany_ID (UsrCombo) | `*` | 확인 필요 (dtMyCompany / dtDiv_Company_ID NAME 사용) | 변경 시 `SSP.SSP0021_GET_SHIPMENT_FROM_SITE`(From Site 목록) 호출, cboPlanDate 이벤트를 해제했다가 재연결, InitSpread 재실행 |
| From Site | clbPlantSite (UsrCheckedList) | — | `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` | 다중 선택(GetCheckedListValue) |
| Plan-date* | cboPlanDate (UsrCombo) | `*` | 확인 필요 (Plan_Current_Check: CODE·NAME·FROM_DATE·TO_DATE) | 변경 시 FROM_DATE/TO_DATE 반영, 날짜 헤더 재생성(`SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) |
| Period* | drpPeriod (UsrDateRangePicker) | `*` | Plan-date의 FROM/TO 반영(5967~5970줄) | **Enabled=false**(표시 전용) |
| Bucket | cboBucketType (UsrCombo) | — | `DM.DM0003_GET_BUCKET_TYPE_CODE` | DAILY/WEEKLY/MONTHLY 열 표시 전환(조회 없음) |
| Sum | chkSum | — | — | 합계 열 표시 전환(조회 없음) |
| Model | txtItemId (UsrMultiLineEditor) + btnItemId | — | 팝업(btnItemId_Click, 대상 확인 필요) | — |
| Show SQL | chkSql | — | — | 용도 확인 필요 |

### 1.2 상세 조회 (spdDetail 상단, btnSearch)
| 라벨 | 컨트롤 | 비고 |
|---|---|---|
| Shipment Date | drpPeriod2 | DrpPeriod2_ValueChanged 연결 |
| Shipment Date | drpPeriod3 | 라벨이 drpPeriod2와 같음. 어느 시트에 적용되는지 확인 필요 |
| Model | txtModel2 + btnItemID2 | |
| (Requestor, 라벨 확인 필요) | txtRequestor + btnRequestor | 요청자 팝업 |
| (라벨 확인 필요) | clbResultType (UsrCheckedList) | |
| (라벨 확인 필요) | txtBoxID (UsrMultiLineEditor) | MES Box ID로 보이나 확인 필요 |

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | 호출 순서 (flow.csv) | API 후보 |
|---|---|---|---|
| 화면 진입 | `Form_Load` | SSP0021_GET_SHIPMENT_DIVISION → DM0003_GET_BUCKET_TYPE_CODE → SCP0009_GET_SHEET_CALENDAR_3SPAN | 콤보 초기화 API(Division, Bucket), 캘린더 헤더 API |
| 회사 변경 | `clbCompanyID_SelectedIndexChanged` | SSP0021_GET_SHIPMENT_FROM_SITE → SCP0009 | From Site 콤보 API (FoxQuery 미등록 SP → Mapper 신규 등록) |
| Plan-date 변경 | `cboPlanDate_SelectedIndexChanged` | SCP0009 | 캘린더 헤더 API |
| 조회 | FindButton | SSP0021_GET_SHIPMENT_PLAN → SCP0009 | `GET /ssp0021/shipment-plan` (후보) |
| 메인 더블클릭 | `SpdMain_CellDoubleClick` | 셀 조건에 따라 PLAN_DETAIL / STOCK_LOCATION_DETAIL / OWMS_DETAIL / HOLD_STOCK / MES_STOCK / MES_STOCK_DETAIL | 시트별 상세 조회 API 6종 |
| 상세 Search | `BtnSearch_Click` | PLAN_DETAIL / STOCK_LOCATION_DETAIL / OWMS_DETAIL / SHIPMENT_RESULT / MES_STOCK / MES_STOCK_DETAIL | 위 상세 API 재사용 + Shipment Result API |
| Measure 선택 | `BtnMeasure_Click` | SCP0009 (InitSpread) | 클라이언트 측 열 재구성 + 캘린더 API |
| Bucket/Sum 전환 | `cboBucketType_SelectedIndexChanged`, `chkSum_CheckedChanged` | SetSpreadColumn (API 없음) | FE 열 표시 토글 |
| 편집 진입 | EditButton | SSP0002_GET_USER_INFO_LIST (GetSSPUserCheck) | 사용자 권한 확인 API |
| 저장 | SaveButton | SaveData_Detail: SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM, SSP0021_SAVE_HOLD_STOCK_DATA(⚠ DB 없음), GetERPInterface(SCM_SSP_CHECK_CONFIRM_CHANGETIME, SSP0021_GET_ERP_SO_NO_CNT, SSP0021_GET_SHIPMENT_STATUS, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, NonSoNo/SoNo → SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING, GetErpIFCheckNew → PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH ×2) → 재조회(GET_SHIPMENT_PLAN, PLAN_DETAIL, HOLD_STOCK) | 저장 API(Plan Detail 확정·변경요청), Hold stock 저장 API(원본 SP 확인 후) |
| Simulation | `BtnSimulation_Click` | 엔드포인트 없음 (Simulation 메서드는 DIVISION_ID·FROM_SITE·ITEM_ID·Container_Qty 사용) | FE 계산 여부 확인 필요 |
| 붙여넣기 | `SpdMain_ClipboardPasted`, `SpdDetail_ClipboardPasted` | 엔드포인트 없음 (Detail은 c["CODE"] 매칭) | FE 처리 |
| 기타 Grid 이벤트 | `SpdMain_TopChange`, `SpdDetail_TopChange`, `SpdDetail_SheetTabClick`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_CellClick`, `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_EditChange`, `SpdMain_Change`, `shtDetail_Change`, `DrpPeriod2_ValueChanged`, `btnItemId_Click`, `BtnItemID2_Click`, `BtnRequestor_Click` | 엔드포인트 없음 | FE 처리. 각 핸들러의 세부 로직은 원문 확인 필요 |

- 저장 전 검증(Validation_Check): Shipment Qty*, Shipment Date*, Trans Mode*, Building(remarks2), Remarks. SO No가 있는 행과 없는 행을 따로 검증한다(Validationdr / SONoValidationdr).
- ERP I/F 차단 확인: chkERPIFBlockYn이 BLOCK_YN·PERIOD를 읽는다. 데이터 출처는 확인 필요.
- 진입점 미연결(구현 제외 후보, 확인 필요): GetErpIFCheck, NewNonSoNo, GetErpIFCheckNew_.

## 3. Division별 Grid 변형 요약
- 9개 시트 × 14개 division 모두 표시 컬럼 수가 같다(Hold stock 10, Hold stock Detail 10, MES Stock 9, MES Stock Detail 13, oWMS Detail 25, Shipment Plan 8, Shipment Plan Detail 42, Shipment Result 18, Stock Location Detail 20).
- 유일한 division 분기: division **82**일 때 Shipment Result의 `CHILD_QTY` Width=75 (InitSpread 727줄).
- division과 무관한 동적 변형: Shipment Plan 날짜 열(캘린더 SP), Bucket/Sum에 따른 D_/W_/M_ 열 표시.

## 4. 권한(C/R/U/D) 관련 사실
| 구분 | 사실 |
|---|---|
| R | FindButton → `SSP.SSP0021_GET_SHIPMENT_PLAN`. Division 목록 SP가 TB_FX_USERGROUPAUTHEXTENTION을 참조한다 |
| U/C | EditButton → GetSSPUserCheck → `SSP.SSP0002_GET_USER_INFO_LIST`(TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION). SaveButton → 저장 체인 |
| D | 프레임워크 DeleteButton 진입점은 flow.csv에 없다. 삭제성 SP(SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, DELETE:SSP_ANL_SHIP_CONFIRM 포함)는 저장 체인 안에서 호출된다 |
| 그룹·사용자 | `UserInfoContext.Current.NowGroupID` 사용(InitControls 443, SetChangedControl 497, SetChangeControl 338, clbCompanyID_SelectedIndexChanged 5922). Filter GROUP_ID·USER_ID(338~339줄) |
| 잠금 | SpdDetail_CellClick이 `siDetail.IsLock(SheetName)`으로 편집 가능 여부를 분기한다 |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 14행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행(내용 확인 필요) |

## 5. 미확정 사항
1. `SSP0021_SAVE_HOLD_STOCK_DATA`가 DB에 없다. Hold stock 저장 기능을 유지할지와 원본 SP를 확보해야 한다.
2. `SSP0021_GET_SHIPMENT_FROM_SITE`가 FoxQuery에 미등록이다. 호출 방식과 파라미터를 확인해야 한다.
3. Hold stock / Hold stock Detail 시트를 생성하는 코드 위치와 탭 인덱스(3·4) 처리.
4. 상세 조건 라벨 미확인(txtRequestor, clbResultType, txtBoxID), drpPeriod2와 drpPeriod3의 용도 구분.
5. Company, Plan-date 콤보의 데이터 원천.
6. GetSSPInnerTable 8회 호출의 code 값.
7. Grid 컬럼의 실제 표시 순서(메타 원본).
8. Simulation 기능의 계산 로직과 데이터 출처.
9. chkSql(Show SQL), usrButton1(parent 없음)을 TO-BE에 반영할지.
10. 진입점 미연결 메서드 3개를 제외할지.
11. 주석 처리된 `SSP0046_GET_BUCKET_TYPE_CODE`는 현행 기능이 아니므로 제외(주석 처리됨).
