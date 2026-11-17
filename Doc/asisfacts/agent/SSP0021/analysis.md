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
