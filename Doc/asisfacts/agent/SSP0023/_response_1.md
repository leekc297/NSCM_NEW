=== FILE: analysis.md ===
# SSP0023 Shipment Plan(Electrode) — As-is 분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0023) 하나만 사용했습니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls)은 0건입니다. 아래 호출은 모두 활성 코드입니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0023 |
| 클래스 | `SSP0023_ShipmentPlanElectrode` |
| 도메인 | SSP (Plan) |
| 메인 소스 | `SSP0023_ShipmentPlanElectrode.cs` (6,823줄) |
| 디자이너 | `SSP0023_ShipmentPlanElectrode.Designer.cs` (2,382줄) |
| 컨트롤 수 | 88개 (controls.csv) |
| Spread | `spdMain`, `spdDetail`, `spdSub` (FpSpread 3개) |
| Grid 구성 방식 | **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\Properties\AssemblyInfo.cs | SSP0023_ShipmentPlanElectrode.UIL.csproj | 37 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.cs | SSP0023_ShipmentPlanElectrode.UIL.csproj | 6823 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.Designer.cs | SSP0023_ShipmentPlanElectrode.UIL.csproj | 2382 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0023_ShipmentPlanElectrode.cs | GSCM.SSP.Plan.UIL.csproj | 6730 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0023_ShipmentPlanElectrode.Designer.cs | GSCM.SSP.Plan.UIL.csproj | 2382 |

- shared(공용) 파일: Fact Pack에 별도로 분류된 파일이 없습니다(0건).
- legacy 사본(6,730줄)과 current 사본(6,823줄)은 93줄 차이가 납니다. 어떤 내용이 다른지는 **확인 필요**입니다. 이 문서는 current 기준입니다.

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| # | 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 |
|---:|---|---|---:|---|---|
| 1 | event:this.Load (`Form_Load`) | Form_Load > InitControls > GetBucketType | 4656 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH |
| 2 | event:this.Load (`Form_Load`) | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 3 | button:FindButton | FindButton > FindData_Main | 4732 | `SSP.SSP0023_GET_SHIPMENT_PLAN` | MATCH |
| 4 | button:FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 5 | button:EditButton | EditButton > GetSSPUserCheck | 6805 | `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH |
| 6 | button:SaveButton | SaveButton > SaveData_Detail | 2435 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| 7 | button:SaveButton | SaveButton > SaveData_Detail | 2643 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH |
| 8 | button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3278 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH |
| 9 | button:SaveButton | SaveButton > SaveData_Detail > GetERPInterface | 3319 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH |
| 10 | button:SaveButton | … > GetERPInterface > GetShipmentStatusChk | 3459 | `SSP.SSP0023_GET_SHIPMENT_STATUS` | MATCH |
| 11 | button:SaveButton | … > GetERPInterface > GetErpSoNoCnt | 3524 | `SSP.SSP0023_GET_ERP_SO_NO_CNT` | MATCH |
| 12 | button:SaveButton | … > GetERPInterface > NonSoNo | 3846 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| 13 | button:SaveButton | … > GetERPInterface > SoNo | 4081 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| 14 | button:SaveButton | … > SoNo > GetErpIFCheckNew | 4329 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH |
| 15 | button:SaveButton | … > SoNo > GetErpIFCheckNew | 4355 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH |
| 16 | button:SaveButton | … > SoNo > GetErpIFCheckNew | 4385 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH |
| 17 | button:SaveButton | … > GetERPInterface > ChkConfirmChangeTime | 6779 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | MATCH |
| 18 | button:SaveButton | SaveButton > SaveData_Detail > FindData_Main | 4732 | `SSP.SSP0023_GET_SHIPMENT_PLAN` | MATCH |
| 19 | button:SaveButton | SaveButton > SaveData_Detail > FindData_Detail | 5357 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | MATCH |
| 20 | button:SaveButton | … > FindData_Detail > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 21 | event:this.btnExcelUpload.Click (`btnExcelUpload_Click`) | btnExcelUpload_Click > FindData_Main | 4732 | `SSP.SSP0023_GET_SHIPMENT_PLAN` | MATCH |
| 22 | 〃 | btnExcelUpload_Click > FindData_Detail | 5357 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | MATCH |
| 23 | 〃 | btnExcelUpload_Click > FindData_Main > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 24 | event:this.formDown.Click (`btnExcelFormDownload_Click`) | btnExcelFormDownload_Click > FindData_Plan_Detail_DownLoad | 6505 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` | MATCH |
| 25 | 〃 | … > FindData_Plan_Detail_DownLoad > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 26 | event:this.btnMeasure.Click (`BtnMeasure_Click`) | BtnMeasure_Click > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 27 | event:this.btnSearch.Click (`BtnSearch_Click`) | BtnSearch_Click > FindData_Detail | 5357 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | MATCH |
| 28 | 〃 | BtnSearch_Click > FindData_Stock_Detail | 5468 | `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` | MATCH |
| 29 | 〃 | BtnSearch_Click > FindData_ShipmentResult | 5585 | `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` | MATCH |
| 30 | 〃 | BtnSearch_Click > FindData_ShipmentResult > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 31 | event:this.btnSimulation.Click (`BtnSimulation_Click`) | BtnSimulation_Click > Simulation | 6027 | `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` | MATCH |
| 32 | 〃 | BtnSimulation_Click > Simulation > FindData_Main | 4732 | `SSP.SSP0023_GET_SHIPMENT_PLAN` | MATCH |
| 33 | 〃 | BtnSimulation_Click > Simulation > FindData_Detail | 5357 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | MATCH |
| 34 | 〃 | … > Simulation > FindData_Detail > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 35 | event:this.spdMain.CellDoubleClick (`SpdMain_CellDoubleClick`) | SpdMain_CellDoubleClick > FindData_Detail | 5357 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | MATCH |
| 36 | 〃 | SpdMain_CellDoubleClick > FindData_Detail > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 37 | event:clbCompany_ID.SelectedIndexChanged (`clbCompanyID_SelectedIndexChanged`) | clbCompanyID_SelectedIndexChanged > InitSpread > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 38 | event:cboPlanDate.SelectedIndexChanged (`cboPlanDate_SelectedIndexChanged`) | cboPlanDate_SelectedIndexChanged > GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH |
| 39 | unreached (진입점 미연결) | NewNonSoNo | 3645 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| 40 | unreached (진입점 미연결) | GetErpIFCheckNew_ | 4195 | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH |
| 41 | unreached (진입점 미연결) | GetErpIFCheck | 4251 | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH |

- 저장(SaveButton)은 `SaveData_Detail` → `GetERPInterface` 순서로 실행되는 체인입니다. 한 번 저장할 때 최대 9종의 엔드포인트가 호출됩니다. 분기 조건(SO No 유무에 따라 `SoNo`/`NonSoNo`로 나뉘는 기준 등)은 Fact Pack에 없으므로 **확인 필요**입니다.
- `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING`은 진입점이 연결되지 않은 메서드(`GetErpIFCheckNew_`, `GetErpIFCheck`)에서만 호출됩니다. 정적 분석 기준으로 현행 화면에서는 실행되지 않습니다. 리플렉션이나 동적 호출 여부는 **확인 필요**입니다.
- `NewNonSoNo`(3645)도 진입점이 없습니다. 현행 경로는 `NonSoNo`(3846)입니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 주요 참조 테이블 (SP 내부 EXEC 전이 포함) |
|---|---|---:|---|---|
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | MATCH | 2 | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST / EXEC PR_SCP_SYS_LOG_BATCH |
| `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | MATCH | 1 | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SCM_SYS_LOG_BATCH / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | MATCH | 1 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | SELECT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH |
| `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | MATCH | 2 | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | DELETE/UPDATE/SELECT SSP_ANL_SHIP_CONFIRM / UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106, SCM_SYS_LOG_BATCH / SELECT SCM_MST_SITE(_CUSTOMER), SCM_MST_DIVISION, DM_PLN_MKT_FCST 등 |
| `SSP.SSP0002_GET_USER_INFO_LIST` | MATCH | 1 | SSP0002_GET_USER_INFO_LIST | SELECT SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION |
| `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 2 (unreached) | SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE / INSERT SCM_SYS_LOG_BATCH |
| `SSP.SSP0023_GET_ERP_SO_NO_CNT` | MATCH | 1 | SSP0023_GET_ERP_SO_NO_CNT | SELECT SSP_ANL_SHIP_CONFIRM |
| `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SSP0023_GET_SHEET_CALENDAR_3SPAN | SELECT SCM_SYS_CALENDAR_M |
| `SSP.SSP0023_GET_SHIPMENT_PLAN` | MATCH | 1 | SSP0023_GET_SHIPMENT_PLAN | SELECT SCM_MST_TITLESET_USER, SCM_SYS_CALENDAR_M, SSP_ANL_BOH_CUTOFF_EE, SSP_ANL_SHIP_PLAN_EE, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SSP_ANL_SHIP_REQ_EE, SSP_MST_SITE_ITEM_EE_V, SSP_DNM_FP_MRP_INTRANSIT_SN, SCP_MST_FINAL_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SSP_DNM_SHIP_RESULT_OWMS_V, SCM_MST_SHEET_MEASURE / #임시테이블 다수 / 동적 SQL |
| `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | MATCH | 1 | SSP0023_GET_SHIPMENT_PLAN_DETAIL | 동적 SQL(DYNAMIC) / FN_GET_IN_STR, FN_SCM_SPLIT (정적 참조 테이블은 추출되지 않음) |
| `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` | MATCH | 1 | SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL | 동적 SQL(DYNAMIC) (정적 참조 테이블은 추출되지 않음) |
| `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` | MATCH | 1 | SSP0023_GET_SHIPMENT_PLAN_RESULT | SELECT SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_SITE_ITEM_EE_V, SSP_MST_DELEGATE, SCM_DNM_EXFACTORY_RESULT, SCP_MST_FINAL_ITEM, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SCM_MST_ITEM_SN (RESULT_ERP_C_EXIST 등 5건은 CTE로 보이며 **확인 필요**) |
| `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` | MATCH | 1 | SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL | SELECT SSP_MST_SHIP_CALENDAR, SSP_ANL_SHIP_PLAN_EE |
| `SSP.SSP0023_GET_SHIPMENT_STATUS` | MATCH | 1 | SSP0023_GET_SHIPMENT_STATUS | SELECT SSP_ANL_SHIP_CONFIRM |
| `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` | MATCH | 1 | SSP0023_SAVE_SHIPMENT_PLAN_SIMU | INSERT SSP_ANL_SHIP_PLAN_SIMU_EE / MERGE SSP_ANL_SHIP_PLAN_EE / EXEC SP_EXECUTESQL |
| `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` | MATCH | 2 | SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM | INSERT/UPDATE SSP_ANL_SHIP_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM_H, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, DM_PLN_MKT_FCST_CONFIRM, SSP_MST_SEND_MAIL_REQ / EXEC PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_MAIL_SEND_ADJUST_MST/SUB, PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 등 |
| `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` | MATCH | 3 (현행 2 + unreached 1) | SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCP_SYS_LOG_BATCH 등 |

합계는 엔드포인트 18종, 호출 지점 24곳(endpoints.csv 24행)이며, 모두 FoxQuery(`fox`) 경유로 MATCH입니다.

## 4. 이벤트 배선 표

| 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---|---|---|---|
| this.formDown | Click | `btnExcelFormDownload_Click` | Designer InitializeComponent:299 |
| this.btnExcelUpload | Click | `btnExcelUpload_Click` | Designer InitializeComponent:339 |
| this | Load | `Form_Load` | .ctor:310 |
| this.spdMain | TopChange | `SpdMain_TopChange` | InitEvent:786 |
| this.cboBucketType | SelectedIndexChanged | `cboBucketType_SelectedIndexChanged` | InitEvent:787 |
| this.rdButton1 | CheckedChanged | `rdButton_Changed` | InitEvent:788 |
| this.rdButton2 | CheckedChanged | `rdButton_Changed` | InitEvent:789 |
| this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitEvent:790 |
| this.spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:792 |
| this.spdMain | Change | `SpdMain_Change` | InitEvent:793 |
| this.spdMain | ClipboardPasted | `spdMain_ClipboardPasted` | InitEvent:794 |
| this.btnMeasure | Click | `BtnMeasure_Click` | InitEvent:796 |
| this.btnItemId | Click | `btnItemId_Click` | InitEvent:797 |
| this.btnItemId2 | Click | `BtnMaterialId2_Click` | InitEvent:798 |
| this.btnSearch | Click | `BtnSearch_Click` | InitEvent:799 |
| this.btnRequestor | Click | `BtnRequestor_Click` | InitEvent:800 |
| this.btnSimulation | Click | `BtnSimulation_Click` | InitEvent:801 |
| this.spdDetail | SheetTabClick | `SpdDetail_SheetTabClick` | InitEvent:803 |
| this.spdDetail | ActiveSheetChanged | `SpdDetail_ActiveSheetChanged` | InitEvent:804 |
| this.spdDetail | CellClick | `SpdDetail_CellClick` | InitEvent:805 |
| this.spdDetail | ComboSelChange | `SpdDetail_ComboSelChange` | InitEvent:806 |
| this.spdDetail | CellDoubleClick | `SpdDetail_CellDoubleClick` | InitEvent:807 |
| this.spdDetail | EditChange | `SpdDetail_EditChange` | InitEvent:808 |
| this.spdDetail | ClipboardPasted | `SpdDetail_ClipboardPasted` | InitEvent:809 |
| clbDivision_ID | SelectedIndexChanged | `clbDivision_ID_SelectedIndexChanged` | InitEvent:811 |
| clbCompany_ID | SelectedIndexChanged | `clbCompanyID_SelectedIndexChanged` | InitEvent:812 |
| cboPlanDate | SelectedIndexChanged | `cboPlanDate_SelectedIndexChanged` | InitEvent:813 |
| this.chkPastPeriod | CheckedChanged | `chkPastPeriod_CheckedChanged` | InitEvent:815 |
| dsdm | Changed | `shtPlanDetail_Change` | InitEvent:818 |
| cboPlanDate | SelectedIndexChanged | `cboPlanDate_SelectedIndexChanged` (-=) | clbCompanyID_SelectedIndexChanged:5776 |
| cboPlanDate | SelectedIndexChanged | `cboPlanDate_SelectedIndexChanged` (+=) | clbCompanyID_SelectedIndexChanged:5780 |

- `rdButton3`(Pancake m)의 CheckedChanged 배선은 events.csv에 없습니다. rdButton1과 rdButton2만 `rdButton_Changed`에 연결되어 있습니다. 같은 그룹이라 rdButton3을 선택하면 rdButton1/2의 CheckedChanged가 발생하는 구조로 보이지만, 실제 동작은 **확인 필요**입니다.
- `clbCompanyID_SelectedIndexChanged`는 회사 콤보를 다시 채우는 동안 `cboPlanDate_SelectedIndexChanged` 배선을 떼었다가(5776) 다시 붙입니다(5780).
- `dsdm`(Changed → `shtPlanDetail_Change`)이 어떤 객체인지는 Fact Pack에 없으므로 **확인 필요**입니다.
- 프레임워크 버튼 FindButton, SaveButton, EditButton은 override 진입점입니다(flow.csv의 entry_kind=button).

## 5. Grid 구성 방식

**HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)**

| 구성 요소 | 내용 |
|---|---|
| META(프레임워크) | `SpreadInfo.SetSheetHeaderColumn` 5회 호출(InitSpread:585, 636, 674, 684, 695). SCM_MST_SHEET_COLUMNS의 COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG, VALID_YN, CELL_CONTROL_OBJECT_TYPE_CODE 등을 읽음 |
| DB루프(코드) | 화면 로컬 `InitSpreadDateColumn`(738/744)이 `dsSpdTitle`(= `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` 결과)을 돌며 날짜 컬럼을 추가. 컬럼명에 `B_`가 있으면 AddTextColumn(숨김), 그 외는 AddNumColumn(폭 100, 우측정렬, 소수 3자리). LARGE/SMALL_CLASS_LABEL_NAME으로 헤더 3단 span을 만들고 `SUM` 헤더를 붙임 |
| 코드 표시 변경 | `InitSpread`(597–629)와 `rdButton_Changed`(4420–4452): UOM / Cell / Pancake m 라디오 선택에 따라 BOH 컬럼 3세트(TOT/JR/PC × 기본·_CELL·_PCM) 중 1세트만 표시 |
| 코드 표시 변경 | `SetSpreadColumn`(4479–4642): 컬럼 Tag 접두어 `X_`(UOM)·`Y_`(Cell)·`Z_`(Pancake)와 `_D_`/`_W_`/`_M_`(Bucket DAILY/WEEKLY/MONTHLY), `chkSum`, `chkPastPeriod`에 따라 날짜 컬럼 Visible을 정함 |
| 코드 스타일 | `InitSpreadDateColumn`:747에서 DAY_CODE가 SAT이면 파랑, SUN이면 빨강 글자색 |

### 5-1. Division별 차이

- 메타 규칙을 전개한 결과(10장)와 최종 Grid(12장)에서 **모든 division(40, 81, 81_HD/HG/HM/ST/UC, 82, EE, EE_HD/HG/HM/ST/UC)의 컬럼 수가 같습니다.**
- 코드 분기에도 division 변수 비교가 없습니다. 판단불가(?) 2,268건은 모두 "런타임:화면컨트롤값"으로 분류됩니다.
- 따라서 Division별 Grid 변형은 없습니다. 표시 차이는 화면 컨트롤 값(라디오, Bucket, Sum, Past Period)으로만 생깁니다.

| 시트 | 메타(필수+기본/선택) | 최종 표시 (?=런타임 분기) |
|---|---|---|
| Shipment Plan(Electrode) | 19/0 (+SCM_MST_SHEET_MEASURE 11/0) | 13 (?9) |
| Shipment Plan Detail | 41/0 | 44 (?9) |
| Shipment Plan Detail Excel | 6/0 | 9 (?9) |
| Shipment Result | 17/0 | 20 (?9) |
| Stock Detail | 28/0 | 31 (?9) |

## 6. 확인 필요 항목

1. Fact Pack §7의 '확인 필요' 행은 0건입니다. 아래는 분석 중 나온 추가 항목입니다.
2. `SaveData_Detail`이 `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`을 2번(2435, 2643) 호출하는데, 두 호출의 분기 조건과 파라미터 차이.
3. `GetERPInterface`에서 `SoNo`와 `NonSoNo`가 나뉘는 기준(`GetErpSoNoCnt` 결과 CNT를 쓰는지 추정만 가능하며 원문 확인 필요).
4. `GetErpIFCheckNew`에서 `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`를 2번(4355, 4385) 호출하는 조건.
5. `chkERPIFBlockYn`이 읽는 `dtERPBlockYnIF`(BLOCK_YN, PERIOD)의 출처. 엔드포인트 목록에 없음.
6. `InitControls`가 읽는 `dtShipmentInputPeriod`(VALUE, Diff_VALUE)와 `dtCompany`의 출처. `GetSSPInnerTable` 경유인지.
7. unreached 메서드 3개(`NewNonSoNo`, `GetErpIFCheckNew_`, `GetErpIFCheck`)를 실제로 쓰지 않는지.
8. grid_effective에서 `Shipment Plan(Electrode)` 외 시트에도 BOH 컬럼(CODE_ONLY_CHANGE)이 붙어 있음. `rdButton_Changed`에 시트 힌트가 없어 전 시트에 전개된 것으로 보이며, 실제 적용 대상 시트는 확인 필요.
9. SSP0023_GET_SHIPMENT_PLAN_DETAIL과 STOCK_DETAIL은 동적 SQL이라 정적 참조 테이블이 추출되지 않음. SP 원문 확인 필요.
10. legacy 사본(GSCM.SSP.Plan.UIL)과 current 사본의 차이(93줄).

=== FILE: source_links.md ===
# SSP0023 소스 링크 표

> 기준 경로 접두어
> - `CS` = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.cs`
> - `DS` = `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0023_ShipmentPlanElectrode.UIL\SSP0023_ShipmentPlanElectrode.Designer.cs`

## 1. 엔드포인트 호출 지점 (24곳 전체)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SaveData_Detail | 2435 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` 호출 (1차) |
| CS | SaveData_Detail | 2643 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` 호출 (2차) |
| CS | GetERPInterface | 3278 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` 호출 |
| CS | GetERPInterface | 3319 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` 호출 |
| CS | GetShipmentStatusChk | 3459 | `SSP.SSP0023_GET_SHIPMENT_STATUS` 호출 |
| CS | GetErpSoNoCnt | 3524 | `SSP.SSP0023_GET_ERP_SO_NO_CNT` 호출 |
| CS | NewNonSoNo | 3645 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` 호출 (unreached) |
| CS | NonSoNo | 3846 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` 호출 |
| CS | SoNo | 4081 | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` 호출 |
| CS | GetErpIFCheckNew_ | 4195 | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` 호출 (unreached) |
| CS | GetErpIFCheck | 4251 | `SSP.SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` 호출 (unreached) |
| CS | GetErpIFCheckNew | 4329 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` 호출 |
| CS | GetErpIFCheckNew | 4355 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` 호출 (1차) |
| CS | GetErpIFCheckNew | 4385 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` 호출 (2차) |
| CS | GetBucketType | 4656 | `DM.DM0003_GET_BUCKET_TYPE_CODE` 호출 |
| CS | FindData_Main | 4732 | `SSP.SSP0023_GET_SHIPMENT_PLAN` 호출 |
| CS | FindData_Detail | 5357 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` 호출 |
| CS | FindData_Stock_Detail | 5468 | `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` 호출 |
| CS | FindData_ShipmentResult | 5585 | `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` 호출 |
| CS | GetSpdTitle | 5921 | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` 호출 |
| CS | Simulation | 6027 | `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` 호출 |
| CS | FindData_Plan_Detail_DownLoad | 6505 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` 호출 |
| CS | ChkConfirmChangeTime | 6779 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` 호출 |
| CS | GetSSPUserCheck | 6805 | `SSP.SSP0002_GET_USER_INFO_LIST` 호출 |

## 2. 이벤트 배선 위치

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| DS | InitializeComponent | 299 | formDown.Click += btnExcelFormDownload_Click |
| DS | InitializeComponent | 339 | btnExcelUpload.Click += btnExcelUpload_Click |
| CS | .ctor | 310 | this.Load += Form_Load |
| CS | InitEvent | 786 | spdMain.TopChange += SpdMain_TopChange |
| CS | InitEvent | 787 | cboBucketType.SelectedIndexChanged += cboBucketType_SelectedIndexChanged |
| CS | InitEvent | 788 | rdButton1.CheckedChanged += rdButton_Changed |
| CS | InitEvent | 789 | rdButton2.CheckedChanged += rdButton_Changed |
| CS | InitEvent | 790 | chkSum.CheckedChanged += chkSum_CheckedChanged |
| CS | InitEvent | 792 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| CS | InitEvent | 793 | spdMain.Change += SpdMain_Change |
| CS | InitEvent | 794 | spdMain.ClipboardPasted += spdMain_ClipboardPasted |
| CS | InitEvent | 796 | btnMeasure.Click += BtnMeasure_Click |
| CS | InitEvent | 797 | btnItemId.Click += btnItemId_Click |
| CS | InitEvent | 798 | btnItemId2.Click += BtnMaterialId2_Click |
| CS | InitEvent | 799 | btnSearch.Click += BtnSearch_Click |
| CS | InitEvent | 800 | btnRequestor.Click += BtnRequestor_Click |
| CS | InitEvent | 801 | btnSimulation.Click += BtnSimulation_Click |
| CS | InitEvent | 803 | spdDetail.SheetTabClick += SpdDetail_SheetTabClick |
| CS | InitEvent | 804 | spdDetail.ActiveSheetChanged += SpdDetail_ActiveSheetChanged |
| CS | InitEvent | 805 | spdDetail.CellClick += SpdDetail_CellClick |
| CS | InitEvent | 806 | spdDetail.ComboSelChange += SpdDetail_ComboSelChange |
| CS | InitEvent | 807 | spdDetail.CellDoubleClick += SpdDetail_CellDoubleClick |
| CS | InitEvent | 808 | spdDetail.EditChange += SpdDetail_EditChange |
| CS | InitEvent | 809 | spdDetail.ClipboardPasted += SpdDetail_ClipboardPasted |
| CS | InitEvent | 811 | clbDivision_ID.SelectedIndexChanged += clbDivision_ID_SelectedIndexChanged |
| CS | InitEvent | 812 | clbCompany_ID.SelectedIndexChanged += clbCompanyID_SelectedIndexChanged |
| CS | InitEvent | 813 | cboPlanDate.SelectedIndexChanged += cboPlanDate_SelectedIndexChanged |
| CS | InitEvent | 815 | chkPastPeriod.CheckedChanged += chkPastPeriod_CheckedChanged |
| CS | InitEvent | 818 | dsdm.Changed += shtPlanDetail_Change |
| CS | clbCompanyID_SelectedIndexChanged | 5776 | cboPlanDate.SelectedIndexChanged -= (일시 해제) |
| CS | clbCompanyID_SelectedIndexChanged | 5780 | cboPlanDate.SelectedIndexChanged += (재연결) |

## 3. Grid 정의 위치

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 544 | AddSheet spdMain "Shipment Plan(Electrode)" (인자 3 ¦ 1 ¦ 35) |
| CS | CreateSpread | 550 | AddSheet spdDetail "Shipment Plan Detail" (1 ¦ 1 ¦ 35) |
| CS | CreateSpread | 551 | AddSheet spdDetail "Stock Detail" (3 ¦ 1 ¦ 60) |
| CS | CreateSpread | 552 | AddSheet spdDetail "Shipment Result" (1 ¦ 1 ¦ 35) |
| CS | CreateSpread | 553 | AddSheet spdSub "Shipment Plan Detail Excel" (1 ¦ 1 ¦ 35) |
| CS | CreateSpread | 555–574 | GetSheetInfo / ChangeSheet 각 시트 초기화 |
| CS | InitSpread | 580 | GetSpdTitle 호출 |
| CS | InitSpread | 583–591 | Shipment Plan(Electrode): InitSheet, SetSheetHeaderColumn(3단 헤더), InitSpreadDateColumn, SetSpreadColumn |
| CS | InitSpread | 597–629 | rdButton1/2/3에 따라 BOH 컬럼 Visible 설정 |
| CS | InitSpread | 634–636 | Shipment Plan Detail: SetSheetHeaderColumn(1단) |
| CS | InitSpread | 652–659 | drRow/dr/drAllRow CODE·NAME 읽기 (콤보 데이터 구성으로 보이며 확인 필요) |
| CS | InitSpread | 672–674 | Shipment Plan Detail Excel: SetSheetHeaderColumn(1단) |
| CS | InitSpread | 682–684 | Stock Detail: SetSheetHeaderColumn(3단) |
| CS | InitSpread | 693–695 | Shipment Result: SetSheetHeaderColumn(1단) |
| CS | InitSpreadDateColumn | 738 | DB루프 AddTextColumn (`B_` 포함 컬럼, 숨김) |
| CS | InitSpreadDateColumn | 744 | DB루프 AddNumColumn (폭 100, Right, 소수 3) |
| CS | InitSpreadDateColumn | 747 | SAT 파랑 / SUN 빨강 ForeColor |
| CS | InitSpreadDateColumn | 754–781 | ColumnHeaderSpan (LARGE/SMALL 라벨 + "SUM") |
| CS | SpdDetail_SheetTabClick | 903–914 | 탭 0/1/2 → Plan Detail / Stock Detail / Shipment Result 전환 |
| CS | SpdDetail_CellClick | 1718 | FACTORY_ID 셀 콤보(dtBuildingForCell) 설정 |
| CS | SpdDetail_CellClick | 1727–1759 | 헤더 CheckBox 전체 선택/해제 |
| CS | SpdMain_CellDoubleClick | 1798–1799 | MEASURE = "P_SHIP_CONFIRM_ETD"인 행의 날짜 셀 더블클릭 → Shipment Plan Detail로 전환 |
| CS | EditButton | 2086 / 2270 | spdMain / spdDetail 시트 정보 읽기 |
| CS | cboBucketType_SelectedIndexChanged | 4413 | SetSpreadColumn 호출 |
| CS | rdButton_Changed | 4420–4452 | BOH 컬럼 Visible 전환 |
| CS | SetSpreadColumn | 4479–4625 | X_/Y_/Z_ × D_/W_/M_ 컬럼 Visible |
| CS | SetSpreadColumn | 4642 | chkPastPeriod가 꺼져 있으면 과거 날짜 컬럼 숨김 |
| CS | ExportExcel | 6668 / 6710 | 엑셀 내보내기 시 Formula / 헤더 스타일 처리 |

## 4. 검증·메타 읽기 위치

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 341–342 | Filter GROUP_ID / USER_ID, NowGroupID |
| CS | SetChangeControl | 348–383 | GetSSPInnerTable 8회 호출 |
| CS | DefineProperty | 420–421 | drAllRow CODE / NAME |
| CS | InitControls | 429, 445 | FP_Log2 (로그) |
| CS | InitControls | 462–509 | NowGroupID, dtShipmentInputPeriod VALUE/Diff_VALUE, dtCompany CODE |
| CS | SetChangedControl | 527–537 | CODE, DIVISION_ID, dtMyCompany NAME |
| CS | spdMain_ClipboardPasted | 1219–1225 | DIVISION_ID, PLANT_ID, MODEL_ID, FROM_SITE, ELECTRODE_TYPE, MEASURE, ITEM_ID |
| CS | SpdDetail_ClipboardPasted | 1427 | CODE |
| CS | SpdDetail_CellClick | 1691 / 1707–1714 | GetCheckedListValue / CODE·NAME |
| CS | EditButton | 2138 | GetCheckedListValue |
| CS | SaveData_Detail | 2337 | GetCheckedListValue |
| CS | chkERPIFBlockYn | 2772 / 2781 | BLOCK_YN / PERIOD |
| CS | ChangeData_Check | 2808–2815 | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type |
| CS | ChangeNotSendERP_Check | 2851–2885 | 위와 같은 항목 + SONoValidationdr |
| CS | Validation_Check | 2969–2977 | 위 항목 + dom_exp |
| CS | Validation_Check | 3067–3069~ | SONoValidationdr (이후 줄은 Fact Pack에서 잘림, 확인 필요) |
| CS | FindData_Main | 4683–4686 | GetCheckedListValue 4회 |
| CS | cboPlanDate_SelectedIndexChanged | 5825 | GetSpdTitle |

=== FILE: web_components.md ===
# SSP0023 Web 컴포넌트 매핑 (React + Wijmo)

> 라벨은 props.csv의 `LayoutControlItem.Text` 또는 컨트롤 `Text` 원문입니다. props.csv가 잘려서(41,721자) 일부 라벨은 Fact Pack에서 확인할 수 없고, 해당 항목은 **확인 필요**로 표기했습니다.

## 1. 컨트롤 → 컴포넌트 매핑

### 1-1. 상단 조회조건 패널 (usrConditionPanel1 / usrLayoutControl2)

| AS-IS 컨트롤 | 유형 | 라벨 원문 | TO-BE 후보 | 비고 |
|---|---|---|---|---|
| clbCompany_ID | UsrCombo | `Company*` (layoutControlItem1) | 단일 선택 콤보 (Wijmo ComboBox) | 필수. 변경 시 InitSpread와 GetSpdTitle 재호출 |
| clbDivision_ID | UsrCombo | `Division*` (lblCombo1) | 콤보 | 필수. 이름은 clb지만 유형은 UsrCombo |
| cboPlanDate | UsrCombo | `Plan-date*` (PlanDate) | 콤보 | 필수. 변경 시 `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` 호출 |
| drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | 기간 선택 | Designer에서 `Enabled=false` |
| cboBucketType | UsrCombo | `Bucket` (lblBucket) | 콤보 | 데이터: `DM.DM0003_GET_BUCKET_TYPE_CODE`. 값 DAILY / WEEKLY / MONTHLY |
| clbFromSite | UsrCheckedList | `From Site` (layoutControlItem7) | 다중 선택 콤보 (MultiSelect) | |
| txtItemId | UsrMultiLineEditor | `Material` (lblItemId) | 멀티라인 입력 + 팝업 버튼 | |
| btnItemId | UsrButton | 확인 필요 | 아이콘 버튼 (Material 팝업) | `btnItemId_Click` |
| txtModelId | UsrMultiLineEditor | 확인 필요 | 멀티라인 입력 | |
| textNickName | UsrMultiLineEditor | 확인 필요 | 멀티라인 입력 | |
| usrLabel1 | UsrLabel | `UOM Type` (lblUOMType) | 라벨 | |
| rdButton1 | UsrRadio | `UOM` | RadioGroup 항목 | 기본값 `Checked=true` |
| rdButton2 | UsrRadio | `Cell` | RadioGroup 항목 | |
| rdButton3 | UsrRadio | `Pancake m` | RadioGroup 항목 | |
| chkSum | UsrCheckBox | `Sum` | CheckBox | 날짜 컬럼 중 주·월 합계 표시 |
| btnMeasure | UsrButton | 확인 필요 | 아이콘 버튼 (Measure 선택) | `BtnMeasure_Click` |
| chkMyModel | UsrCheckBox | `My Model` | CheckBox | |
| chkDelegateeModel | UsrCheckBox | `Delegatee Model` | CheckBox | |
| chkTeamLeader | UsrCheckBox | `Team Leader` | CheckBox | |
| chkPartLeader | UsrCheckBox | `Part Leader` | CheckBox | |
| chkPastPeriod | UsrCheckBox | `Including Past Period` | CheckBox | 과거 날짜 컬럼 표시 |
| btnSimulation | UsrButton | `Simulation` | 버튼 | `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` |
| formDown | UsrButton | `Excel Form` | 버튼 | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` |
| btnExcelUpload | UsrButton | `Upload` | 버튼 (파일 업로드) | 업로드 후 Main과 Detail 재조회 |
| usrButton1 | UsrButton | 확인 필요 | 확인 필요 | 부모 없음(parent 빈값), Size 75×23. 미사용 여부 확인 필요 |

### 1-2. 하단 상세 조건 패널 (splitContainer1.Panel2 / usrLayoutControl3)

| AS-IS 컨트롤 | 유형 | 라벨 원문 | TO-BE 후보 | 비고 |
|---|---|---|---|---|
| txtNickName2 | UsrMultiLineEditor | 확인 필요 (layoutNickNameDetail) | 멀티라인 입력 | |
| txtModel2 | UsrMultiLineEditor | 확인 필요 (layoutModelDetail) | 멀티라인 입력 | |
| txtItemId2 | UsrMultiLineEditor | 확인 필요 (layoutMaterialDetail) | 멀티라인 입력 | |
| btnItemId2 | UsrButton | 확인 필요 (layoutMaterialBtn) | 팝업 버튼 | `BtnMaterialId2_Click` |
| txtLotID | UsrMultiLineEditor | 확인 필요 (layoutLotId) | 멀티라인 입력 | Stock Detail 조건으로 보이며 확인 필요 |
| clbResultType | UsrCheckedList | 확인 필요 (layoutResultType) | 다중 선택 | |
| drpPeriod2 | UsrDateRangePicker | 확인 필요 (layoutShipmentDate2) | 기간 선택 | |
| drpPeriod3 | UsrDateRangePicker | 확인 필요 (layoutShipmentDate1) | 기간 선택 | |
| txtRequestor | UsrTextBox | 확인 필요 (Requestor) | 텍스트 입력 | |
| btnRequestor | UsrButton | 확인 필요 (layoutRequestorBtn) | 사용자 팝업 버튼 | `BtnRequestor_Click` |
| btnSearch | SimpleButton | 확인 필요 (layoutSearchBtn) | 상세 조회 버튼 | Detail, Stock, Result 조회 |

### 1-3. Grid

| AS-IS | 시트 | TO-BE |
|---|---|---|
| spdMain (Panel1) | Shipment Plan(Electrode) | Wijmo FlexGrid (3단 헤더, 동적 날짜 컬럼) |
| spdDetail (Panel2) | Shipment Plan Detail / Stock Detail / Shipment Result | 탭 + FlexGrid 3개 |
| spdSub (Panel2) | Shipment Plan Detail Excel | 화면에 보이지 않는 엑셀 양식용 Grid (표시 여부 확인 필요) |

## 2. 화면 배치

| 컨트롤 | 속성 | 값 (props.csv) |
|---|---|---|
| usrConditionPanel1 | Dock / Size / UsrPanelType | Top / 1689×101 / HidePanel |
| usrLayoutControl2 | Dock / Size | Top / 1689×98 |
| layoutControlGroup2 | Size | 1689×106 |
| splitContainer1 | Orientation / SplitterDistance / Size | **확인 필요** (props.csv 잘림 구간) |

- 구조 사실: `spdMain`은 `splitContainer1.Panel1`, `spdDetail`·`usrLayoutControl3`·`spdSub`는 `splitContainer1.Panel2`에 있습니다(controls.csv parent).
- 상/하 분할인지 좌/우 분할인지, 분할 비율은 Orientation과 SplitterDistance 값이 없어 **확인 필요**입니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

Division별 차이는 없습니다. 14개 division 모두 같습니다.

### 3-1. Shipment Plan(Electrode) — spdMain, 최종 13 (?9)

| 컬럼 | 라벨 | 표시 |
|---|---|---|
| DIVISION_ID | Div | 기본 |
| ELECTRODE_POST_OPER_LT | Oper. L/T | 기본 |
| ELECTRODE_TYPE | Elec Type | 기본 |
| FROM_SITE | From Site | 기본 |
| ITEM_ID | Material | 기본 |
| MODEL_ID | Model | 기본 |
| NICK_NAME | Nick Name | 기본 |
| MEASURE_NAME | Measure | 기본 |
| PSI_NAME | PSI | 기본 |
| TEMPCOLUMN | TEMPCOLUMN | 기본 |
| TOT_BOH_QTY / _CELL / _PCM | BOH | 라디오 UOM / Cell / Pancake m 중 1개만 표시 |
| JR_BOH_QTY / _CELL / _PCM | J/R | 위와 같음 |
| PC_BOH_QTY / _CELL / _PCM | Pancake | 위와 같음 |
| BACK_COLOR, CONFIRM_DAY, GUBUN_NUM, LAST_UPDATED_BY(Requestor), MEASURE, PLANT_ID, SCM_SITE_ID | — | 숨김 |
| (동적) 날짜 컬럼 | SSP0023_GET_SHEET_CALENDAR_3SPAN의 COLUMN_LABEL_NAME | DB루프로 추가. Tag 접두어 X_/Y_/Z_ × D_/W_/M_로 표시 제어. `B_` 포함 컬럼은 숨김 텍스트 |

- Measure 행 정의: SCM_MST_SHEET_MEASURE 11행. 행 값은 Fact Pack에 없음(확인 필요).

### 3-2. Shipment Plan Detail — spdDetail 탭 0, 메타 41 / 최종 44 (?9)

표시(기본) 41개:
Div(DIVISION_ID), Confirm/Plan ID(CONFIRM_ID), Change Request No(CHANGE_REQ_NO), Status(SHIPMENT_STATUS), Model(MODEL_ID), Model PIC(MODEL_USER), Material(ITEM_ID), Nick Name(ITEM_ID_NICK_NAME), Cell Type(CELL_TYPE), Post Oper.(ELECTRODE_POST_OPER), From Site(FROM_SITE_DESCRIPTION), To Site(TO_SITE_DESCRIPTION), Sold To Party(SOLDTO_DESCRIPTION), Ship To Party(SHIPTO_DESCRIPTION), DOM/EXP.(DOM_EXP), Incoterms(INCOTERMS), Shipping Plan Qty(SHIPPING_PLAN_QTY), Confirm Qty*(SHIPMENT_CONFIRM_QTY), Gap(GAP), Confirm Qty (Cell)(CONFIRM_QTY_CELL), Confirm Qty (Jumboroll m)(CONFIRM_QTY_JR), Confirm Qty (Pancake m)(CONFIRM_QTY_PANCAKE), Confirm Qty (Cut)(CONFIRM_QTY_ROLL_LENGTH), Shipment Date*(SHIPMENT_DATE), Day(DAYOFWEEK_NAME), Expected Shipping Date(Expected_Shipping_Date), ETD, ETA, L/T(Day)(LT_DAY), Trans Mode*(TRANSPORT_MODE), Building Desc.*(FACTORY_ID), Package Type *(PACKAGE_TYPE), Package Qty(PACKAGE_QTY), PO No(ERP_SO_NO), Shipment No.(REMARKS2), Remarks(REMARKS), Customer Requirement(REMARKS3), Shipment Requestor(REQUESTOR), Updated By, Updated Date, ATTRIBUTE10.

숨김: BOD_ID, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, CHANGE_TYPE, EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, TO_SITE, MERGE_NUM, MODEL_ID_NICK_NAME, NEW_* 14개(NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE), ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID.

- 코드 동작: FACTORY_ID 셀을 클릭하면 Building 콤보를 동적으로 만듭니다(SpdDetail_CellClick:1718). 헤더 CheckBox로 전체 선택·해제합니다(1727–1759).
- 최종 44의 +3은 BOH 컬럼 CODE_ONLY_CHANGE 전개분입니다. 이 시트에 실제로 적용되는지는 **확인 필요**입니다.

### 3-3. Stock Detail — spdDetail 탭 1, 메타 28 / 최종 31 (?9)

모두 표시: Div, SCM Site(FROM_SITE), Plant, Storage, Model, Material, Nick Name, Version, Operation, Lot ID, Pallet ID, Lane, Expiration Date, Available Stock YN, Change Status, Package Type(oWMS), MES Hold YN, QMS Hold YN, iWMS Hold YN, oWMS Hold YN, Total UOM / Pancake M(TOTAL_QTY_UOM/PCM), GMES UOM / Pancake M, IWMS UOM / Pancake M, OWMS UOM / Pancake M.
- 헤더 3단(SetSheetHeaderColumn 인자 3). UOM / Pancake M 라벨이 반복되므로 상위 헤더 그룹(Total, GMES, iWMS, oWMS)이 메타 ATTRIBUTE로 구성되는 것으로 보입니다. 확인 필요.

### 3-4. Shipment Result — spdDetail 탭 2, 메타 17 / 최종 20 (?9)

모두 표시: Div, Confirm/Plan ID, SO No(ERP_SO_NO), Status(TYPE), Ship Type, Model, Material, Nick Name, From Site, To Site, End Customer, Shipment Date(YYYYMMDD), ETD(ETD_DATE), ETA(ETA_DATE), Trans Mode, Incoterms, Shipment Qty(QTY).

### 3-5. Shipment Plan Detail Excel — spdSub, 메타 6 / 최종 9 (?9)

모두 표시: Company*(COMPANY_ID), Div*(DIVISION_ID), FromSite*(FROM_SITE), Material*(ITEM_ID), yyyyMMdd*(YYYYMMDD), Qty*(QTY). 엑셀 양식 다운로드와 업로드에 쓰는 컬럼입니다.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | Spread | 진입 |
|---|---|---|---|
| Shipment Plan(Electrode) | META+코드연결 | spdMain | 조회(FindButton) |
| Shipment Plan Detail | META+코드연결 | spdDetail 탭 0 | spdMain 더블클릭(MEASURE = `P_SHIP_CONFIRM_ETD`, 날짜 컬럼) / btnSearch / 저장 후 재조회 |
| Stock Detail | META+코드연결 | spdDetail 탭 1 | btnSearch |
| Shipment Result | META+코드연결 | spdDetail 탭 2 | btnSearch |
| Shipment Plan Detail Excel | META+코드연결 | spdSub | Excel Form 다운로드 |

- 마스터→디테일: spdMain에서 `P_SHIP_CONFIRM_ETD` Measure 행의 날짜 셀을 더블클릭하면 Shipment Plan Detail로 시트를 전환하고(ChangeSheet / ChangeActiveSheet:1798–1799) `FindData_Detail`을 호출합니다.
- 탭 전환: `SpdDetail_SheetTabClick`의 SheetTabIndex 0/1/2가 위 세 시트에 대응합니다.
- `spdMain_ClipboardPasted`는 붙여넣은 행에서 DIVISION_ID, PLANT_ID, MODEL_ID, FROM_SITE, ELECTRODE_TYPE, MEASURE, ITEM_ID를 키로 씁니다(1219–1225). spdMain은 편집 가능한 Grid입니다(Simulation 입력으로 보이며 확인 필요).

=== FILE: oracle_migration.md ===
# SSP0023 Oracle 전환 분석

## 1. 호출 SP 인벤토리 (18종)

| # | SP | 호출 | 성격 | 주요 쓰기 대상 | EXEC 체인 |
|---:|---|---:|---|---|---|
| 1 | `SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM` | 2 | 저장 | INSERT/UPDATE SSP_ANL_SHIP_CONFIRM, INSERT SSP_ANL_SHIP_CONFIRM_H, SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, DM_PLN_MKT_FCST_CONFIRM, SSP_MST_SEND_MAIL_REQ(INSERT/UPDATE), SCM_SYS_LOG_BATCH / DELETE:A(별칭, 대상 확인 필요) | PR_SCM_SYS_LOG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_MAIL_SEND_ADJUST_SUB, PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_DM_SSP_CONFIRM_SYNC, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| 2 | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | 1 | 저장 | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE) | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 3 | `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | 2 | 삭제/저장 | DELETE/UPDATE SSP_ANL_SHIP_CONFIRM, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 4 | `SSP0023_GET_SHIPMENT_STATUS` | 1 | 조회 | — (SELECT SSP_ANL_SHIP_CONFIRM) | — |
| 5 | `SSP0023_GET_ERP_SO_NO_CNT` | 1 | 조회 | — (SELECT SSP_ANL_SHIP_CONFIRM) | — |
| 6 | `SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING` | 3 | 저장 | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE), XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | PR_SCM_SYS_LOG_BATCH, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCP_SYS_LOG_BATCH |
| 7 | `SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING` | 2 (unreached) | 저장 | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ(_DE) | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 8 | `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | 2 | 배치성 저장 | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | PR_SCP_SYS_LOG_BATCH |
| 9 | `DM0003_GET_BUCKET_TYPE_CODE` | 1 | 조회 | — (SELECT SCM_ADM_LOOKUP_MASTER_DETAIL) | — |
| 10 | `SSP0023_GET_SHIPMENT_PLAN` | 1 | 조회(피벗) | #임시테이블 13종 (#TBLDYNAMICTITLEST_SSP0023, #TMP_SSP0023_* 등) | 동적 SQL(DYNAMIC@SSP0023_GET_SHIPMENT_PLAN) |
| 11 | `SSP0023_GET_SHIPMENT_PLAN_DETAIL` | 1 | 조회 | — | 동적 SQL |
| 12 | `SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL` | 1 | 조회 | — | 동적 SQL |
| 13 | `SSP0023_GET_SHIPMENT_PLAN_RESULT` | 1 | 조회 | — | — |
| 14 | `SSP0023_GET_SHEET_CALENDAR_3SPAN` | 1 | 조회(헤더) | — (SELECT SCM_SYS_CALENDAR_M) | — |
| 15 | `SSP0023_SAVE_SHIPMENT_PLAN_SIMU` | 1 | 저장 | INSERT SSP_ANL_SHIP_PLAN_SIMU_EE, MERGE SSP_ANL_SHIP_PLAN_EE | PR_SCM_SYS_LOG_BATCH, SP_EXECUTESQL |
| 16 | `SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` | 1 | 조회 | — (SELECT SSP_MST_SHIP_CALENDAR, SSP_ANL_SHIP_PLAN_EE) | — |
| 17 | `SCM_SSP_CHECK_CONFIRM_CHANGETIME` | 1 | 조회/검증 | INSERT SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH |
| 18 | `SSP0002_GET_USER_INFO_LIST` | 1 | 조회(권한) | — (SELECT TB_FX_USER, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USERGROUPAUTHEXTENTION, SCM_MST_SSO_DEPT_INFO) | — |

### 1-1. 공통 참조 함수

| 함수 | 사용 SP |
|---|---|
| SCM_ARR_SPL_CNT / SCM_ARR_SPL_VAL | 1, 2, 3, 6, 15, 17 (배열 파라미터 분해) |
| FN_GET_SSP_SITE_INFO / FN_GET_SSP_SITE_INFO_EXCEPTION | 1, 3, 6, 8 |
| FN_GET_SSP_VMI_YN / FN_GET_SSP_MKT_FCST_INCOTERMS | 3, 6, 8 |
| FN_GET_SSP_ETA_DATE | 1, 6 |
| FN_GET_ITEM_NICKNAME / FN_GET_SCM_SITE_DESCRIPTION | 1, 13 |
| FN_GET_IN_STR / FN_SCM_SPLIT | 11, 16 |
| FN_GET_ANL_SHIP_FROZEN_DAY_CNT | 10 |
| FN_MULTY_TIME, FN_GET_SSP_MKT_OWNER_NAME, FN_GET_USER_NAME, FN_WEEKOFDAY_DATE, FN_NEXT_DAY, UF_FX_STRING_SPLIT | 1 |

## 2. 공통코드 분기 (code=X → 테이블)

- `SCM_ADM_LOOKUP_MASTER_DETAIL` 참조 SP: `DM0003_GET_BUCKET_TYPE_CODE`, `SSP0023_GET_SHIPMENT_PLAN`, `SSP0023_GET_SHIPMENT_PLAN_RESULT`, `SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`, `SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING`, `PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`.
- 각 SP가 어떤 LOOKUP 코드(code=X) 값을 쓰는지는 Fact Pack에 추출되지 않았습니다(**확인 필요**).
- 화면ID 값이 들어 있는 메타 행: SCM_ADM_LOOKUP_MASTER_DETAIL 3행, _H 4행. 행 내용은 dbmeta CSV 확인 필요.
- 화면 측 `GetSSPInnerTable`(SetChangeControl:348–383, 8회)이 CODE, NAME, COMPANY_ID, DIVISION_ID, PLANT_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER, LANGUAGE_CODE를 반환합니다. 내부 코드 키는 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접호출 SP

- 18종 모두 FoxQuery 키로 등록되어 있습니다(status=MATCH, kind=fox). 미등록 0건, 직접 SQL 0건입니다.
- 주석 처리된 호출: 0건.
- 진입점 미연결: `SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING`(GetErpIFCheckNew_:4195, GetErpIFCheck:4251), `SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING`의 NewNonSoNo:3645 호출. 이전 대상에 넣을지 판단이 필요합니다.

## 4. Oracle 전환 시 확인 포인트

| # | 항목 | 대상 SP | 사실 근거 |
|---:|---|---|---|
| 1 | `STRING_SPLIT`(MSSQL 전용) 치환 | SSP0023_GET_SHIPMENT_PLAN, SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL, SSP0023_GET_SHIPMENT_PLAN_RESULT, SSP0023_GET_SHIPMENT_STATUS | objects의 REF:STRING_SPLIT |
| 2 | `SP_EXECUTESQL` 동적 SQL → EXECUTE IMMEDIATE / 바인드 | SSP0023_SAVE_SHIPMENT_PLAN_SIMU | EXEC:SP_EXECUTESQL |
| 3 | 동적 SQL(피벗) 재설계 | SSP0023_GET_SHIPMENT_PLAN, SSP0023_GET_SHIPMENT_PLAN_DETAIL, SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL | DYNAMIC@… 표기. DETAIL과 STOCK_DETAIL은 정적 테이블이 추출되지 않아 원문 정밀 분석 필요 |
| 4 | `#임시테이블` → GTT 등 | SSP0023_GET_SHIPMENT_PLAN(13종), SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(#T_CONFIRM_ID, #T_SSP, #T_SSP_SUM, #T_MKT_RESULT, #T_MKT_RESULT_SUM, #TEMP_SALES_RESULT, #TBLSSPADJUSTMAILSEND), SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM(#TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106) | CREATE/INSERT:# 표기. 세션 내 재조회 시 GTT 잔존 데이터 비우기 대조가 필요함 |
| 5 | `MERGE` 문법 차이 | SSP0023_SAVE_SHIPMENT_PLAN_SIMU (SSP_ANL_SHIP_PLAN_EE) | MERGE:SSP_ANL_SHIP_PLAN_EE |
| 6 | ERP 인터페이스 테이블 쓰기 | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN ← SP 1, 3, 6, 8 | 외부 연계 테이블이므로 TO-BE 대상 스키마와 시노님 확인 필요 |
| 7 | 메일 발송 체인 | SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM → PR_SSP_MAIL_SEND_ADJUST_MST/SUB, SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG | EXEC 체인 |
| 8 | DM 동기화 체인 | SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM → PR_DM_SSP_CONFIRM_SYNC, DM_PLN_MKT_FCST_CONFIRM INSERT | EXEC/INSERT |
| 9 | 트랜잭션 로그 SP | PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_SYS_LOG_BATCH | 여러 SP가 공통으로 호출. 자율 트랜잭션 여부 확인 필요 |
| 10 | 별칭 DELETE (`DELETE:A`) | SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM | 실제 대상 테이블 확인 필요 (MSSQL `DELETE A FROM …` 형식으로 보임) |
| 11 | CTE/파생 테이블명 오인 | SSP0023_GET_SHIPMENT_PLAN_RESULT의 RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS | 실제 테이블이 아닐 수 있음. 확인 필요 |
| 12 | 뷰 의존 | SSP_MST_SITE_ITEM_EE_V, SSP_DNM_SHIP_RESULT_OWMS_V, SSP_PLAN_VERSION_V, SCP_MST_BOD_N_V | TO-BE에 해당 뷰가 있는지 확인 |
| 13 | 저장 체인 트랜잭션 경계 | SaveData_Detail → GetERPInterface에서 최대 9개 SP를 순차 호출 | 화면 코드가 개별로 호출하므로 원자성 경계 확인 필요 |

### 4-1. 난이도 (사실 기반)

| SP | 근거 | 판정 |
|---|---|---|
| SSP0023_GET_SHIPMENT_PLAN | 동적 SQL + #임시테이블 13종 + STRING_SPLIT + 피벗(RESULT_PIVOT_TABLE) | 상 |
| SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM | 쓰기 대상 다수 + EXEC 체인 8종 + #임시테이블 7종 | 상 |
| SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | #임시테이블 + DELETE + ERP IF INSERT | 중 |
| SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING | EXEC 체인(PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH) + ERP IF | 중 |
| SSP0023_SAVE_SHIPMENT_PLAN_SIMU | SP_EXECUTESQL + MERGE | 중 |
| SSP0023_GET_SHIPMENT_PLAN_DETAIL / STOCK_DETAIL | 동적 SQL(정적 추출 불가) | 원문 확인 전 판정 보류 |
| 그 외 조회 SP(STATUS, ERP_SO_NO_CNT, CALENDAR_3SPAN, BUCKET_TYPE, DETAIL_EXCEL, RESULT, CHECK_CONFIRM_CHANGETIME, SSP0002_GET_USER_INFO_LIST) | 참조 테이블 1~수개, 일부 STRING_SPLIT | 하~중 |
| PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM, SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING | 단일 쓰기 대상군 + 로그 SP | 중 |

=== FILE: tobe_design.md ===
# SSP0023 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

### 1-1. 메인 조회조건 (상단 패널)

| 순서 | 라벨 원문 | AS-IS 컨트롤 | 유형 | 필수 | 비고 |
|---:|---|---|---|---|---|
| 1 | Company* | clbCompany_ID | 콤보 | Y | 변경 시 InitSpread와 Plan-date 재구성 |
| 2 | Division* | clbDivision_ID | 콤보 | Y | `clbDivision_ID_SelectedIndexChanged`. DIVISION_ID로 하위 필터 |
| 3 | Plan-date* | cboPlanDate | 콤보 | Y | CODE, FROM_DATE, TO_DATE 사용. 변경 시 달력 헤더 재조회 |
| 4 | Period* | drpPeriod | 기간 | Y | 초기 `Enabled=false` (Plan-date에서 파생되는 것으로 보이며 확인 필요) |
| 5 | Bucket | cboBucketType | 콤보 | — | DAILY / WEEKLY / MONTHLY. `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| 6 | From Site | clbFromSite | 다중선택 | — | |
| 7 | Material | txtItemId (+btnItemId) | 멀티라인 + 팝업 | — | |
| 8 | (확인 필요) | txtModelId | 멀티라인 | — | |
| 9 | (확인 필요) | textNickName | 멀티라인 | — | |
| 10 | UOM Type | rdButton1 `UOM`(기본) / rdButton2 `Cell` / rdButton3 `Pancake m` | 라디오 | — | 표시 단위 전환 (재조회 없이 컬럼 Visible만 변경) |
| 11 | Sum | chkSum | 체크 | — | 합계 컬럼 표시 |
| 12 | (확인 필요) | btnMeasure | 버튼 | — | Measure 선택 후 InitSpread 재호출 |
| 13 | My Model / Delegatee Model / Team Leader / Part Leader | chkMyModel / chkDelegateeModel / chkTeamLeader / chkPartLeader | 체크 | — | SSP_MST_MODEL_USER, SSP_MST_DELEGATE 참조 SP와 연관된 것으로 보이며 확인 필요 |
| 14 | Including Past Period | chkPastPeriod | 체크 | — | 과거 날짜 컬럼 표시 (SetSpreadColumn:4642) |

- FindData_Main은 GetCheckedListValue를 4회 호출합니다(4683–4686). 어떤 컨트롤 4개인지는 확인 필요입니다.

### 1-2. 상세 조회조건 (하단 패널, btnSearch)

txtNickName2, txtModel2, txtItemId2(+btnItemId2), txtLotID, clbResultType, drpPeriod2, drpPeriod3, txtRequestor(+btnRequestor). 라벨 원문은 props.csv가 잘려 **확인 필요**입니다. 각 조건이 Detail, Stock, Result 중 어느 조회에 쓰이는지도 확인 필요입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | 호출 엔드포인트(순서) | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | `Form_Load` | `DM.DM0003_GET_BUCKET_TYPE_CODE` → `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | GET bucket-types, GET sheet-calendar |
| 조회 | FindButton | `SSP.SSP0023_GET_SHIPMENT_PLAN` (+ CALENDAR_3SPAN) | GET shipment-plan |
| Plan-date / Company 변경 | `cboPlanDate_SelectedIndexChanged`, `clbCompanyID_SelectedIndexChanged` | `SSP.SSP0023_GET_SHEET_CALENDAR_3SPAN` | GET sheet-calendar |
| Measure 변경 | `BtnMeasure_Click` | CALENDAR_3SPAN | GET sheet-calendar |
| 메인 더블클릭 | `SpdMain_CellDoubleClick` | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL` | GET shipment-plan/detail |
| 상세 조회 | `BtnSearch_Click` | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL`, `SSP.SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL`, `SSP.SSP0023_GET_SHIPMENT_PLAN_RESULT` | GET detail / stock-detail / shipment-result |
| 시뮬레이션 | `BtnSimulation_Click` | `SSP.SSP0023_SAVE_SHIPMENT_PLAN_SIMU` → GET_SHIPMENT_PLAN → GET_SHIPMENT_PLAN_DETAIL | POST shipment-plan/simulation |
| 엑셀 양식 | `btnExcelFormDownload_Click` | `SSP.SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL` | GET shipment-plan/excel-form |
| 엑셀 업로드 | `btnExcelUpload_Click` | 업로드 처리 엔드포인트는 Fact Pack에 없음(확인 필요) → GET_SHIPMENT_PLAN, GET_SHIPMENT_PLAN_DETAIL 재조회 | POST upload (확인 필요) |
| 편집 진입 | EditButton | `SSP.SSP0002_GET_USER_INFO_LIST` | GET user-auth |
| 저장 | SaveButton | `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM`(×2) → GetERPInterface: `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0023_GET_SHIPMENT_STATUS`, `SSP.SSP0023_GET_ERP_SO_NO_CNT`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, SoNo/NonSoNo: `SSP.SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING`, GetErpIFCheckNew: `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` → 재조회 | POST shipment-confirm (단일 트랜잭션으로 묶을지 결정 필요) |

- 저장 전 화면 검증(Validation_Check, ChangeData_Check, ChangeNotSendERP_Check)이 보는 컬럼: confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, factory_id, package_type, dom_exp. 오류 메시지와 조건 원문은 확인 필요입니다.
- `chkERPIFBlockYn`이 BLOCK_YN과 PERIOD로 ERP I/F 차단 여부를 확인합니다. 데이터 출처는 확인 필요입니다.

## 3. Division별 Grid 변형 요약

- 5개 시트 모두 division 14종에서 컬럼 구성이 **같습니다.** Division별 변형은 없습니다.
- 변형은 화면 컨트롤 값으로만 생깁니다.
  - UOM Type 라디오: BOH 3세트(기본 / _CELL / _PCM)와 날짜 컬럼 접두어 X_ / Y_ / Z_
  - Bucket: 날짜 컬럼 _D_ / _W_ / _M_
  - Sum: 주·월 합계 컬럼
  - Including Past Period: 과거 날짜 컬럼

## 4. 권한(C/R/U/D) 관련 사실

| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행 (내용 확인 필요) |
| 편집 권한 확인 | EditButton → `GetSSPUserCheck` → `SSP.SSP0002_GET_USER_INFO_LIST` (TB_FX_USERGROUPAUTHEXTENTION 참조) |
| 그룹·사용자 필터 | SetChangeControl:341–342에서 Filter GROUP_ID / USER_ID와 `UserInfoContext.Current.NowGroupID` 사용. InitControls:462에서도 NowGroupID 사용 |
| 잠금 | SpdDetail_CellClick에서 `siDetail.IsLock(SheetName)`으로 편집 가능 여부 분기 |
| C/R/U/D 버튼 | FindButton(R), SaveButton(C/U), EditButton 사용. Delete 버튼 override는 Fact Pack에 없음 |

## 5. 미확정 사항

1. splitContainer1의 분할 방향과 비율(props.csv 잘림).
2. 하단 상세 패널 및 일부 상단 컨트롤의 라벨 원문.
3. Excel Upload의 서버 처리 엔드포인트.
4. 저장 체인의 분기 조건(SoNo / NonSoNo, CONFIRM 2회 호출, CHG_BATCH 2회 호출)과 트랜잭션 경계.
5. unreached 메서드 3개(`NewNonSoNo`, `GetErpIFCheckNew_`, `GetErpIFCheck`)와 `SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING`을 이전 대상에서 제외할지.
6. SCM_MST_SHEET_MEASURE 11행의 Measure 정의와 `P_SHIP_CONFIRM_ETD` 외 더블클릭 대상.
7. BOH 컬럼 표시 제어가 Shipment Plan(Electrode) 외 시트에도 적용되는지.
8. rdButton3에 CheckedChanged가 배선되지 않은 상태에서의 실제 동작.
9. `usrButton1`(부모 없음)과 `dsdm` 객체의 정체.
10. legacy 사본(GSCM.SSP.Plan.UIL)과 current 사본의 차이 반영 여부.
