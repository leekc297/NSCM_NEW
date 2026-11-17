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
