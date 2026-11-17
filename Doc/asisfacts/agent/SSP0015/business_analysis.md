# SSP0015 Shipment PSI — 업무분석서 (As-Is 기준)

> **근거**: 정적 파서 Fact Pack(endpoints.csv · flow.csv · 이벤트 배선 · grid_rule/grid_code/grid_effective)과 1차 분석서(analysis.md · web_components.md · tobe_design.md)만 사용했다. Fact Pack에 없는 내용은 **확인 필요**로 적었다.
> 주석 처리된 호출 4건(3573 · 9288 · 9308 · 9309줄)은 현행 기능에서 뺐다.
> 같은 이름 사용: §5의 엔드포인트명 = 화면설계서 §5 액션 명세 = 단위테스트 '근거' 열.

---

## 1. 업무 목적·범위

| 항목 | 내용 |
|---|---|
| 화면 ID / 클래스 | SSP0015 / `SSP0015_ShipmentPSI` (+ 팝업 `SSP0015_ShipmentPSICommentsPopup`) |
| 도메인 | SSP |
| 현행 프로젝트 | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0015_ShipmentPSI.UIL\SSP0015_ShipmentPSI.UIL.csproj` |
| 업무 목적(사실 기반) | 출하 PSI(시트명 `Shipment PSI(Mobility & IT)`, `Shipment PSI(Packer)`)를 조회한다. 아래 Detail 시트에서 출하 확정·재고·출하 실적을 조회하고 저장한다. 출하 확정을 저장하면 ERP·SCS I/F 테이블(XIF_*)과 변경 요청(SSP_ANL_SHIP_CONFIRM_CHG_REQ*) 테이블에 기록한다. 업무 용어의 정식 정의는 **확인 필요** |
| 범위(현행) | 활성 엔드포인트 39종, 호출 지점 63곳, 이벤트 배선 34건(핸들러 33종), 코드가 생성하는 시트 13개, 메타에만 있는 시트 2개 |
| 범위 밖 | 주석 처리된 호출 4건. unreached(진입점 미연결) 메서드 6개는 현행 사용 여부가 **확인 필요**하다(§8). |
| 메뉴 위치 | TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행이 있으나 행 내용이 Fact Pack에 없다 → **확인 필요** |

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 > 메서드) | 엔드포인트 | 결과 |
|---|---|---|---|---|
| S1 | 화면을 연다 | `Form_Load` > InitControls · GetBucketType · GetDayRange · SetChangedControl / CreateSpread > InitSpread > GetSpdTitle | `biz:CommonData.CommonDataList`[PlanDateShip], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | Plan-date·Bucket·Period 콤보가 채워진다. spdMain·spdDetail 시트와 날짜 컬럼이 만들어진다. |
| S2 | Division을 바꾼다 | `clbDivision_SelectedIndexChanged` > SetChangedControl > GetDayRange | `biz:CommonData.CommonDataList`[PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD` | Plan-date 목록과 Period를 다시 계산한다. |
| S3 | Plan-date를 바꾼다 | `CboPlanDate_SelectedIndexChanged` > GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | Period(drpPeriod)를 다시 계산한다. |
| S4 | Main 시트 탭을 바꾼다 | `SpdMain_ActiveSheetChanged` > SetChangedControl / InitSpread | `biz:CommonData.CommonDataList`[LookupCommon, PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 조회조건과 시트 헤더를 다시 구성한다. |
| S5 | 조회(FindButton)를 누른다 | FindButton > FindData_Main / FindData_Main_Packer / FindData_Main_Packer_Past (분기 조건 **확인 필요**) > Re_Design > GetNERPCode | `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER`, `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST`, `SSP.SSP0002_GET_NERP_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain에 PSI 데이터를 표시한다. |
| S6 | Bucket을 바꾸거나 Sum을 체크한다 | `cboBucketType_SelectedIndexChanged` / `chkSum_CheckedChanged` (SetSpreadColumn 연결은 **확인 필요**) | 없음 | D_/W_/M_ 날짜 컬럼의 표시 여부가 바뀐다(§4 R5). |
| S7 | Measure 버튼을 누른다 | `btnMeasure_Click` > InitSpread > GetSpdTitle | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 헤더를 다시 만든다. |
| S8 | Main 셀을 더블클릭한다 | `SpdMain_CellDoubleClick` > FindData_Detail / FindData_WHstock / FindData_mes_stock / FindData_block_stock / FindData_shtStockLocationDetail_btnSearch / FindData_ScsStock_btnSearch / FindData_Main | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_WH_STOCK`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0015_GET_BLOCK_STOCK`, `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SSP.SSP0015_GET_SCS_STOCK`, `SSP.SSP0015_GET_SHIPMENT_PSI`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 행의 DIVISION_ID·SITE·ITEM_ID·YYYYMMDD 값(8290~8293줄)으로 Detail 시트를 조회한다. 활성 Detail 시트에 따른 분기는 **확인 필요**하다. |
| S9 | Detail 조회조건을 넣고 Search를 누른다 | `BtnSearch_Click` > 시트별 FindData_*_btnSearch | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SSP.SSP0015_GET_WH_STOCK`, `SSP.SSP0015_GET_BLOCK_STOCK`, `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SSP.SSP0015_GET_SCS_STOCK`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0026_GET_REQUEST_DETAIL_PACK`, `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS`, `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER`, `SSP.SSP0015_GET_SHIPMENT_RESULT`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 활성 Detail 시트에 결과를 표시한다. |
| S10 | Model·Requestor 팝업 버튼을 누른다 | `btnItemId_Click`, `BtnItemID2_Click`, `BtnRequestor_Click` | 추출되지 않음 | 처리 내용은 **확인 필요** |
| S11 | Detail 그리드를 편집한다(콤보·붙여넣기·헤더 체크) | `SpdDetail_CellClick`, `SpdDetail_ClipboardPasted`, `spdDetail_ComboSelChange`, `SpdDetail_EditChange`, `shtDetail_Change` | `biz:CommonData.CommonDataList`[TransMode, ShipToCodeByDivision] | Trans Mode와 Ship to 콤보를 채운다. 헤더 CheckBox로 전체 선택 또는 해제한다. |
| S12 | 편집(EditButton)을 누른다 | EditButton > GetSSPUserCheck | `biz:CommonData.CommonDataList`[PlanDateShip], `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 가능 여부를 확인한다. 허용 조건은 **확인 필요**하다. |
| S13 | Main PSI를 저장한다 | SaveButton > SaveData_Main | `SSP.SSP0015_SAVE_SHIPMENT_PSI` | SSP_ANL_SHIP_PLAN_40과 WH_IN_CMT 테이블을 갱신하고 이력을 쌓는다. |
| S14 | Detail(Mobility & IT 계열)을 저장한다 | SaveButton > SaveData_Detail (> Validation_Check 연결 **확인 필요**) | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA`, `SSP.SSP0015_SAVE_MES_STOCK` → 재조회 `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0002_GET_NERP_CODE` | 출하 확정, Hold 재고, MES 재고를 저장한 뒤 다시 조회한다. |
| S15 | Detail(Packer)을 저장한다 | SaveButton > SaveData_Detail_Packer > chkSaveYN · EngProcessingChk · GetERPInterface(ChkConfirmChangeTime · GetErpSoNoCnt · GetShipmentStatusChk · SoNo/NonSoNo · GetErpIFCheckNew) > FindData_Detail_Packer_btnSearch | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0015_GET_ERP_SO_NO_CNT`, `SSP.SSP0015_GET_SHIPMENT_STATUS`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 사전 점검 → 확정 저장 → ERP I/F 처리 → 재조회 순서로 진행한다. 단계 순서와 분기는 **확인 필요**하다. |
| S16 | 코멘트 팝업에서 저장 버튼을 누른다 | `btnButtonList_UsrButtonList_Click_Detected` > SaveData | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | WH In 코멘트와 수량 이력을 저장한다. |
| S17 | 팝업 수량 입력란에 입력한다 | `txtGap_Qty_TextChanged`, `txtBefore_Qty_TextChanged`, `txtProd_Qty_TextChanged`, `txtWHin_Qty_TextChanged`, `txtCurrent_Qty_TextChanged`, `txtChange_Qty_TextChanged`, `txtChange_Qty_KeyPress` | 없음 | 계산과 입력 제한 내용은 **확인 필요** |

- 팝업을 여는 진입점(메서드명)은 Fact Pack에 없어 **확인 필요**하다. 참고 사실: `SpdMain_CellDoubleClick`과 `TsmNotepad_Click`이 Comments의 GAP·BEFORE_QTY·USER_ADD_QTY 컬럼을 읽는다(§4 DB 컬럼 사용 표).

---

## 3. 업무 흐름도 (텍스트 단계)

```
[1] 화면 진입 (Form_Load)
    ├─ InitControls ─ CommonDataList[PlanDateShip] → cboPlanDate
    │               ├─ GetBucketType → DM.DM0003_GET_BUCKET_TYPE_CODE → cboBucketType
    │               ├─ GetDayRange → SCP.SCM0001_GET_SCP_DAY_PERIOD → drpPeriod
    │               └─ SetChangedControl → CommonDataList[PlanDateShip] (2202/2210/2218)
    └─ CreateSpread > InitSpread > GetSpdTitle → SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN
         └─ ChangeSheet: W/H stock(740) → Shipment Confirm Detail(741) → Shipment PSI(Mobility & IT)(746)
[2] 조회조건 변경 (Division / Plan-date / Main 시트 탭 / Bucket / Sum / Measure)
[3] 조회 (FindButton)
    ├─ FindData_Main            → SSP.SSP0015_GET_SHIPMENT_PSI
    ├─ FindData_Main_Packer     → SSP.SSP0015_GET_SHIPMENT_PSI_PACKER
    └─ FindData_Main_Packer_Past→ SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
         └─ Re_Design > GetNERPCode → SSP.SSP0002_GET_NERP_CODE
       (세 갈래 중 하나를 고르는 조건: 확인 필요)
[4] Detail 조회 (SpdMain_CellDoubleClick 또는 BtnSearch_Click) → 활성 Detail 시트별 SP
[5] 편집 진입 (EditButton) → CommonDataList[PlanDateShip] → SSP.SSP0002_GET_USER_INFO_LIST
[6] 저장 (SaveButton)
    ├─ SaveData_Main          → SSP.SSP0015_SAVE_SHIPMENT_PSI
    ├─ SaveData_Detail        → SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 / SSP.SSP0015_SAVE_BLOCK_STOCK_DATA / SSP.SSP0015_SAVE_MES_STOCK → 재조회
    └─ SaveData_Detail_Packer
         ├─ chkSaveYN          → SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK
         ├─ EngProcessingChk   → SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK
         ├─ (확정 저장)        → SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER
         ├─ GetERPInterface
         │    ├─ ChkConfirmChangeTime → SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME
         │    ├─ GetErpSoNoCnt        → SSP.SSP0015_GET_ERP_SO_NO_CNT
         │    ├─ GetShipmentStatusChk → SSP.SSP0015_GET_SHIPMENT_STATUS
         │    ├─ (6665)               → SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM
         │    ├─ (6706)               → SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
         │    ├─ NonSoNo / SoNo       → SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING / SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER
         │    └─ SoNo > GetErpIFCheckNew → SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH
         └─ FindData_Detail_Packer_btnSearch → SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER (재조회)
       (SaveData_Main / Detail / Detail_Packer 분기 조건, GetERPInterface 내부 순서: 확인 필요)
[7] 코멘트 팝업 저장 → SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS
```

---

## 4. 업무 규칙 (사실 근거만)

| ID | 규칙 | 근거 |
|---|---|---|
| R1 | 필수 조회조건 표기는 `Division*`, `Plan-date*`, `Period*`이다(라벨에 `*`). 필수를 검증하는 코드와 메시지는 **확인 필요** | web_components §1-1 (props.csv 원문 라벨) |
| R2 | Plan-date 목록은 공통코드 code=PlanDateShip(UP_FX_GetCommonDataList → SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_PLAN_P, SSP_PLAN_VERSION_V)에서 온다. | endpoints.csv 568/2202/2210/2218 |
| R3 | Period는 `SCM0001_GET_SCP_DAY_PERIOD`(SCM_SYS_CALENDAR_M, FN_WEEKOFDAY_DATE, FN_MULTY_TIME)로 계산한다. Division 변경, Plan-date 변경, Main 시트 변경, 화면 진입 때 다시 계산한다. | flow.csv 9289 |
| R4 | Bucket 값 DAILY / WEEKLY / MONTHLY는 `DM0003_GET_BUCKET_TYPE_CODE`(SCM_ADM_LOOKUP_MASTER_DETAIL)에서 온다. 코드 비교식에 이 세 값이 있다. | grid_code SetSpreadColumn 2116~2148 |
| R5 | 날짜 컬럼 표시 규칙(SetSpreadColumn, 컬럼 Tag 접두어 기준)<br>· DAILY: `D_`·`W_` → Visible=true(2116). `M_`·`W_` → Visible=chkSum(2121)<br>· WEEKLY: `D_` → false(2128). `W_` → true(2132). `M_` → chkSum(2137)<br>· MONTHLY: `D_`·`W_` → false(2144). `M_` → true(2148)<br>· DAILY일 때 `W_`의 최종 값(2116과 2121이 모두 걸림)은 **확인 필요** | grid_code.csv |
| R6 | 날짜 컬럼은 `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과를 돌면서 만든다.<br>· COLUMN_NAME에 `B_`가 있으면 Text 컬럼(숨김)으로 만든다(1110).<br>· 그 밖에는 Num 컬럼으로 만든다(1114).<br>· DAY_CODE가 SAT이면 Blue, SUN이면 Red로 표시한다(1118).<br>· 3단 헤더(LARGE/SMALL_CLASS)와 "SUM" 헤더를 만든다(1125~1154). | grid_code.csv, analysis §5 |
| R7 | `Shipment PSI(Mobility & IT)` 시트(776/778)와 `Shipment PSI(Packer)` 시트(803/805)는 MergePolicy.Always를 쓴다. | grid_code.csv |
| R8 | SetSoNoColumnVisible의 Width 규칙<br>· ichkbtn=1이면 Packer 시트는 80, 그 밖의 시트는 0이다.<br>· ichkbtn≠1이면 Packer 시트는 0, 그 밖의 시트는 80이다.<br>· 대상 컬럼명은 **확인 필요** | grid_code 9778~9793 |
| R9 | Shipment Result 조회(FindData_ShipmentResult_btnSearch)에서는 SHIP_TO와 SHIPTO_DESCRIPTION을 숨긴다(4991/4992). | grid_code.csv |
| R10 | `WH In Plan Detail` 시트는 `drPgmAuthId != null`일 때만 만든다. | CreateSpread:680/731/732, InitSpread:965/967 |
| R11 | Detail 헤더 CheckBox 클릭(SpdDetail_CellClick)<br>· 시트가 잠기지 않았고(IsLock=false) 행이 1개 이상이면 → Value=false(8618)<br>· 잠긴 시트이면 → 현재 값이 true일 때 false(8653), false일 때 true(8657) | grid_code.csv |
| R12 | 저장 전 Validation_Check는 confirm_id와 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE를 읽는다(Validationdr / SONoValidationdr). 검증 조건과 메시지는 **확인 필요** | DB 컬럼 사용 표 |
| R13 | Packer 저장 사전 점검 chkSaveYN은 `SSP0202_GET_SCS_CONFIRM_ID_CHECK` 결과 Tables[0]과 Tables[1]의 CNT를 읽는다. 판정 기준은 **확인 필요** | DB 컬럼 사용 표 9821 |
| R14 | GetErpSoNoCnt는 CNT를 읽는다. GetShipmentStatusChk는 Tables[0~2]의 CONFIRM_ID를 읽는다. 분기 기준은 **확인 필요** | DB 컬럼 사용 표 |
| R15 | chkERPIFBlockYn은 BLOCK_YN과 PERIOD를 읽는다. 데이터 원천 엔드포인트는 추출되지 않았다 → **확인 필요** | DB 컬럼 사용 표 7449/7458 |
| R16 | EngProcessingChk는 `SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`(SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL)로 계획 진행 여부를 확인한다. 차단 조건은 **확인 필요** | flow.csv 7903 |
| R17 | Main 더블클릭 시 Detail 조회 키는 DIVISION_ID, SITE, ITEM_ID, YYYYMMDD다. | SpdMain_CellDoubleClick row 컬럼 |
| R18 | 그룹 기반 필터는 UserInfoContext.Current.NowGroupID와 Filter GROUP_ID·USER_ID를 쓴다. | SetChangeControl:449/450, InitControls:584, SpdMain_ActiveSheetChanged:1459, SetChangedControl:2209 |
| R19 | InitControls는 dtShipmentInputPeriod.Rows[0·1]의 VALUE와 Diff_VALUE, dtCompany의 COMPANY_ID를 읽는다. 용도(입력 가능 기간 등)는 **확인 필요** | DB 컬럼 사용 표 |
| R20 | GetSSPInnerTable(SetChangeControl:456~491)은 CODE, NAME, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, PLANT_ID, SCM_SITE_ID를 읽는다. 어느 콤보에 바인딩하는지는 **확인 필요** | 4-2 프레임워크 메타 소비 |

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

- 읽기·쓰기 테이블은 SP 내부 EXEC 전이분까지 포함한 Fact Pack 참조 객체를 SELECT와 INSERT/UPDATE/DELETE/MERGE로 나눈 것이다.
- `#`으로 시작하는 임시 테이블과 CTE명은 별도로 표기했다.
- DYNAMIC은 동적 SQL이라 실제 테이블이 **확인 필요**하다는 뜻이다.

| # | 엔드포인트 | SP | 읽기 테이블 | 쓰기 테이블 / EXEC | 호출 경로(핸들러) |
|---:|---|---|---|---|---|
| 1 | `biz:CommonData.CommonDataList` | UP_FX_GetCommonDataList (코드 분기) | PlanDateShip: SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_PLAN_P, SSP_PLAN_VERSION_V / LookupCommon: SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL / TransMode: SCP_MST_BOD_V / ShipToCodeByDivision: SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE / PERIOD_{p:value}, PERIOD2_{p:value}: 보강 없음(확인 필요) | 없음 | Form_Load, clbDivision_SelectedIndexChanged, SpdMain_ActiveSheetChanged, EditButton, SpdDetail_CellClick, SpdDetail_ClipboardPasted, (unreached) SetChangedPeriod |
| 2 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL | 없음 | Form_Load > GetBucketType |
| 3 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` | SSP0015_GET_SHIPMENT_PSI_PACKER_PAST | SCM_MST_TITLESET_USER, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SSP_ANL_SHIP_PLAN_P, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_CODE_LOOKUP_VALUE | 임시만: #TBLDYNAMICTITLEST_SSP0015, #TMP_RESULT_TABLE, #TMP_WH_STOCK, #TMP_ERP_STOCK, #TMP_ROWDATA, #TMP_RESULT_PIVOT_TABLE / DYNAMIC | FindButton > FindData_Main_Packer_Past |
| 4 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` | SSP0015_GET_SHIPMENT_PSI_PACKER | SCM_MST_TITLESET_USER, SSP_ANL_SHIP_REQ_P, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE, SCM_DNM_SCS_PROD_PLAN, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE | 임시만: #TMP_SHIP_REQ, #TMP_PACK_RTF, #TMP_SHIP_CONFIRM, #TMP_PROD_PLAN, #TMP_WH_STOCK, #TMP_ERP_STOCK, #TMP_ROWDATA, #TMP_RESULT_TABLE, #TMP_RESULT_PIVOT_TABLE / DYNAMIC | FindButton > FindData_Main_Packer |
| 5 | `SSP.SSP0015_GET_SHIPMENT_PSI` | SSP0015_GET_SHIPMENT_PSI | SCM_MST_TITLESET_USER, SSP_PLAN_VERSION_V, SSP_ANL_SHIP_PLAN_40, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, DM_PLN_SHIPMENT_REQ, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_MES_FCS_STOCK_40_C, SCP_MST_FINAL_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_OWMS_STOCK_C, SSP_ANL_TCO_STOCK_C, SSP_ANL_HOLD_STOCK, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE, SCM_MST_SITE | 임시만: #TMP_ROWDATA, #TBLDYNAMICTITLEST_SSP0015 / EXEC SSP0015_GET_SHIPMENT_PSI_COMMENTS / DYNAMIC | FindButton > FindData_Main, SpdMain_CellDoubleClick, SaveButton > SaveData_Detail(재조회) |
| 6 | `SSP.SSP0002_GET_NERP_CODE` | SSP0002_GET_NERP_CODE | SCM_CODE_LOOKUP_VALUE (SEGMENT2 사용) | 없음 | Re_Design > GetNERPCode, FindData_shtStockLocationDetail_btnSearch > GetNERPCode |
| 7 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL | DYNAMIC(확인 필요), FN_GET_IN_STR, FN_SCM_SPLIT | 없음 | SpdMain_CellDoubleClick > FindData_Detail, BtnSearch_Click > FindData_Detail_btnSearch, SaveData_Detail 재조회 |
| 8 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | DYNAMIC(확인 필요), FN_GET_IN_STR, FN_SCM_SPLIT | 없음 | BtnSearch_Click > FindData_Detail_Packer_btnSearch, SaveData_Detail_Packer 재조회 |
| 9 | `SSP.SSP0015_GET_WH_STOCK` | SSP0015_GET_WH_STOCK | SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_ITEM_SN | 없음 | SpdMain_CellDoubleClick / BtnSearch_Click > FindData_WHstock |
| 10 | `SSP.SSP0015_GET_MES_STOCK` | SSP0015_GET_MES_STOCK | SSP_ANL_MES_FCS_STOCK_40_C, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SCM_MST_ITEM_SN | 없음 | SpdMain_CellDoubleClick > FindData_mes_stock, BtnSearch_Click > FindData_MesStock_btnSearch, SaveData_Detail 재조회 |
| 11 | `SSP.SSP0015_GET_BLOCK_STOCK` | SSP0015_GET_BLOCK_STOCK | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN | 없음 | SpdMain_CellDoubleClick > FindData_block_stock, BtnSearch_Click > FindData_BolckStockDetail_btnSearch |
| 12 | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` | SSP0015_GET_STOCK_LOCATION_DETAIL | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_MST_SLOC, SCM_DNM_STOCK_V, SCM_MST_ITEM_SN, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_CODE_LOOKUP_VALUE | 없음 | SpdMain_CellDoubleClick / BtnSearch_Click > FindData_shtStockLocationDetail_btnSearch |
| 13 | `SSP.SSP0015_GET_SCS_STOCK` | SSP0015_GET_SCS_STOCK | SCM_DNM_SCS_STOCK, SCM_MST_SITE, SSP_MST_MODEL_USER, SSP_MST_DELEGATE | 없음 | SpdMain_CellDoubleClick / BtnSearch_Click > FindData_ScsStock_btnSearch |
| 14 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` | SSP0026_GET_REQUEST_DETAIL_PACK | DYNAMIC만 추출(확인 필요) | 없음 | BtnSearch_Click > FindData_Request_Detail |
| 15 | `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` | SSP0015_GET_SHIPMENT_PSI_COMMENTS | DYNAMIC(확인 필요), FN_GET_IN_STR, FN_SCM_SPLIT | 없음 | BtnSearch_Click > FindData_WHinPlanDetail_btnSearch (그리고 #5 SP 내부 EXEC) |
| 16 | `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` | SSP0015_GET_SHIPMENT_RESULT_PACKER | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SCM_MST_CUSTOMER, SSP_MST_DELEGATE, SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_P, SCP_MST_BOD_N_V, SCM_MST_ITEM_SN (CTE: RESULT_SCS_EXIST, RESULT_ERP_C_NON, PLAN_SSP) | 없음 | BtnSearch_Click > FindData_ShipmentSCSResult_btnSearch |
| 17 | `SSP.SSP0015_GET_SHIPMENT_RESULT` | SSP0015_GET_SHIPMENT_RESULT | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_CONFIRM, SCM_DNM_EXFACTORY_RESULT, SCP_MST_FINAL_ITEM, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SCM_MST_ITEM_SN, SCM_CODE_LOOKUP_VALUE (CTE: RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS) | 없음 | BtnSearch_Click > FindData_ShipmentResult_btnSearch |
| 18 | `SSP.SSP0015_SAVE_SHIPMENT_PSI` | SSP0015_SAVE_SHIPMENT_PSI | SSP_ANL_SHIP_PLAN_40, SSP_ANL_SHIP_PLAN_40_WH_IN_CMT | UPDATE SSP_ANL_SHIP_PLAN_40 · UPDATE/INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT · INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H · INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_H · INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN | SaveButton > SaveData_Main |
| 19 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_PLAN_VERSION_V, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, NERP_CONV_MASTER, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_MST_SEND_MAIL_REQ, SCM_SYS_CALENDAR_M, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER (CTE_DATE) | UPDATE/INSERT SSP_ANL_SHIP_CONFIRM · INSERT SSP_ANL_SHIP_CONFIRM_H · INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN · INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN · INSERT SSP_MST_SEND_MAIL_REQ · INSERT SCM_SYS_LOG_BATCH / EXEC PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN | SaveButton > SaveData_Detail_Packer |
| 20 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | SSP_ANL_SHIP_PLAN_40, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_PLAN_VERSION_V, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, NERP_CONV_MASTER, TB_FX_USER, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_MST_SEND_MAIL_REQ, SCM_SYS_CALENDAR_M, DM_PLN_MKT_FCST_CONFIRM, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V, SCM_DNM_EXFACTORY_RESULT, DM_PLN_MKT_FCST_RESULT | UPDATE/INSERT SSP_ANL_SHIP_CONFIRM · INSERT SSP_ANL_SHIP_CONFIRM_H · INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN · INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ · INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE · DELETE/INSERT SSP_ANL_SHIP_PLAN_40 · INSERT SSP_MST_SEND_MAIL_REQ · INSERT DM_PLN_MKT_FCST_CONFIRM · DELETE A / UPDATE A(별칭, 실제 테이블 확인 필요) · INSERT SCM_SYS_LOG_BATCH / EXEC PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_ANL_SHIP_CONFIRM_ROUTE, PR_SCM_SYS_LOG_BATCH(_CALL_TRAN) | SaveButton > SaveData_Detail |
| 21 | `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` | SSP0015_SAVE_BLOCK_STOCK_DATA | SSP_ANL_HOLD_STOCK | UPDATE/INSERT SSP_ANL_HOLD_STOCK · INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH | SaveButton > SaveData_Detail |
| 22 | `SSP.SSP0015_SAVE_MES_STOCK` | SSP0015_SAVE_MES_STOCK | SSP_ANL_SHIP_PLAN_40, SSP_ANL_MES_FCS_STOCK_40_C | MERGE SSP_ANL_MES_FCS_STOCK_40_C · MERGE SSP_ANL_SHIP_PLAN_40 · INSERT SCM_SYS_LOG_BATCH · 임시 #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP | SaveButton > SaveData_Detail (6112, 6219) |
| 23 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM · UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ · UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE · INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN | SaveData_Detail_Packer > GetERPInterface |
| 24 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE · UPDATE/DELETE SSP_ANL_SHIP_CONFIRM · INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN · INSERT SCM_SYS_LOG_BATCH · 임시 #TMP_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN | GetERPInterface(6706), SoNo > GetErpIFCheckNew(7363) |
| 25 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ · INSERT/UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE · INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN · INSERT SCM_SYS_LOG_BATCH / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH | GetERPInterface > NonSoNo(6843) / SoNo(7076), (unreached) NewNonSoNo(9611) |
| 26 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER | INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ · INSERT/UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE · INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN · INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN · INSERT SCM_SYS_LOG_BATCH / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCP_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH | GetERPInterface > NonSoNo(6847) / SoNo(7080), (unreached) NewNonSoNo(9615) |
| 27 | `SSP.SSP0015_GET_ERP_SO_NO_CNT` | SSP0015_GET_ERP_SO_NO_CNT | SSP_ANL_SHIP_CONFIRM | 없음 | GetERPInterface > GetErpSoNoCnt |
| 28 | `SSP.SSP0015_GET_SHIPMENT_STATUS` | SSP0015_GET_SHIPMENT_STATUS | SSP_ANL_SHIP_CONFIRM (STRING_SPLIT) | 없음 | GetERPInterface > GetShipmentStatusChk |
| 29 | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING | 없음 | UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ · UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE · INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN | **unreached**: GetErpIFCheck(7285), GetErpIFCheckNew_(9731) |
| 30 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN · UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE · INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCP_SYS_LOG_BATCH | SoNo > GetErpIFCheckNew (7389, 7419) |
| 31 | `SCP.PR_SCM_SYS_LOG_BATCH` | PR_SCM_SYS_LOG_BATCH | 없음 | INSERT SCM_SYS_LOG_BATCH | **unreached**: SCM_SYS_LOG_BATCH(7876) |
| 32 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL | 없음 | SaveData_Detail_Packer > EngProcessingChk |
| 33 | `SCM.SCM0001_GET_DIVISION` | SCM0001_GET_DIVISION | SCM_MST_DIVISION | 없음 | **unreached**: GetDivision(9192) |
| 34 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP0009_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M | 없음 | InitSpread > GetSpdTitle (Form_Load, FindButton, btnMeasure_Click, SpdMain_ActiveSheetChanged, SpdMain_CellDoubleClick, BtnSearch_Click, SaveData_Detail_Packer) |
| 35 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | SCM0001_GET_SCP_DAY_PERIOD | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL (CTE_DATE, FN_MULTY_TIME, FN_WEEKOFDAY_DATE) | 없음 | GetDayRange (Form_Load, CboPlanDate_SelectedIndexChanged, clbDivision_SelectedIndexChanged, SpdMain_ActiveSheetChanged) |
| 36 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | SSP0202_GET_SCS_CONFIRM_ID_CHECK | SCM_ADM_LOOKUP_MASTER_DETAIL + DYNAMIC(확인 필요) | 없음 | SaveData_Detail_Packer > chkSaveYN |
| 37 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | SCM_SSP_CHECK_CONFIRM_CHANGETIME | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH | GetERPInterface > ChkConfirmChangeTime |
| 38 | `SSP.SSP0002_GET_USER_INFO_LIST` | SSP0002_GET_USER_INFO_LIST | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | 없음 | EditButton > GetSSPUserCheck |
| 39 | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | SSP0015_SAVE_SHIPMENT_PSI_COMMENTS | SSP_ANL_SHIP_PLAN_40, SSP_ANL_SHIP_PLAN_40_WH_IN_CMT | UPDATE SSP_ANL_SHIP_PLAN_40 · INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_H · UPDATE/INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT · INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H · INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN | (팝업) btnButtonList_UsrButtonList_Click_Detected > SaveData. 파서상 SaveButton > SaveData 경로도 있다(§8-9). |

- SP 목록 38개(엔드포인트 39종 중 biz 1종 제외)는 다음과 같다. DM0003_GET_BUCKET_TYPE_CODE · SSP0015_GET_SHIPMENT_PSI_PACKER_PAST · SSP0015_GET_SHIPMENT_PSI_PACKER · SSP0015_GET_SHIPMENT_PSI · SSP0002_GET_NERP_CODE · SSP0015_GET_SHIPMENT_CONFIRM_DETAIL · SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER · SSP0015_GET_WH_STOCK · SSP0015_GET_MES_STOCK · SSP0015_GET_BLOCK_STOCK · SSP0015_GET_STOCK_LOCATION_DETAIL · SSP0015_GET_SCS_STOCK · SSP0026_GET_REQUEST_DETAIL_PACK · SSP0015_GET_SHIPMENT_PSI_COMMENTS · SSP0015_GET_SHIPMENT_RESULT_PACKER · SSP0015_GET_SHIPMENT_RESULT · SSP0015_SAVE_SHIPMENT_PSI · SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER · SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 · SSP0015_SAVE_BLOCK_STOCK_DATA · SSP0015_SAVE_MES_STOCK · SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM · SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM · SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING · SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER · SSP0015_GET_ERP_SO_NO_CNT · SSP0015_GET_SHIPMENT_STATUS · SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING · PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH · PR_SCM_SYS_LOG_BATCH · SSP0003_GET_SSP_PLAN_PROCESSING_CHECK · SCM0001_GET_DIVISION · SCP0009_GET_SHEET_CALENDAR_3SPAN · SCM0001_GET_SCP_DAY_PERIOD · SSP0202_GET_SCS_CONFIRM_ID_CHECK · SCM_SSP_CHECK_CONFIRM_CHANGETIME · SSP0002_GET_USER_INFO_LIST · SSP0015_SAVE_SHIPMENT_PSI_COMMENTS
- 읽기·쓰기 목록은 EXEC로 전이된 하위 SP의 객체까지 합친 것이다. 어느 하위 SP가 어느 테이블을 쓰는지 나누는 일은 **확인 필요**하다.

---

## 6. Division·권한별 변형

### 6-1. Division
- grid_rule과 grid_effective 기준으로 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)의 시트별 컬럼 수가 모두 같다. **메타상 division별 변형은 없다.**
- division 값이 데이터에 영향을 주는 지점은 사실로 확인된 곳만 적는다.
  - `biz:CommonData.CommonDataList`의 code=ShipToCodeByDivision이 Ship to 콤보를 division 기준으로 조회한다(SpdDetail_CellClick:8604).
  - 저장 계열 SP는 SCM_MST_DIVISION을 읽는다(#24, #25, #30, #32).
- SP와 테이블 이름에 붙은 `_40`(SSP_ANL_SHIP_PLAN_40, SAVE_SHIPMENT_REQUEST_CONFIRM_40 등)이 Division 40을 뜻하는지는 Fact Pack에 근거가 없다 → **확인 필요**.

### 6-2. 권한
| 사실 | 근거 |
|---|---|
| 메뉴 권한 메타가 TB_FX_GroupMenuAuth에 14행 있다. C/R/U/D 값은 미수록 → **확인 필요** | dbmeta |
| `WH In Plan Detail` 시트는 프로그램 권한 행(drPgmAuthId)이 있을 때만 만든다. | R10 |
| EditButton은 GetSSPUserCheck(`SSP0002_GET_USER_INFO_LIST`, TB_FX_USERGROUPAUTHEXTENTION 포함)를 부른다. 허용 기준은 **확인 필요** | flow.csv 9901 |
| NowGroupID와 Filter GROUP_ID·USER_ID로 그룹 필터를 건다. | R18 |
| Detail 시트 잠금(IsLock) 여부에 따라 헤더 CheckBox 동작이 다르다. | R11 |
| 모델 담당 범위 CheckBox 4종(chkMyModel 등)은 Visible=false이고, chkMyModel만 Checked=true다. 조회 파라미터로 쓰이는지는 **확인 필요** | web_components §1-1 |
| 다수 조회 SP가 SSP_MST_MODEL_USER와 SSP_MST_DELEGATE를 읽는다. 담당 모델이나 위임 기준 필터로 보이지만 **확인 필요**하다. | §5 |

---

## 7. 외부 인터페이스 (사실에 있는 객체만)

| 방향 | 객체 | 기록·참조 SP | 비고 |
|---|---|---|---|
| 송신(INSERT) | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 이름상 ERP I/F 테이블이다. 수신 측 시스템은 **확인 필요** |
| 송신(INSERT) | XIF_ERP_PACK_SHIP_PLAN_S_SN | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | 위와 같음 |
| 송신(INSERT) | XIF_SCS_PACK_SHIP_PLAN_S_SN | 위 2개 Packer SP | 이름상 SCS I/F다. **확인 필요** |
| 메일 요청 | SSP_MST_SEND_MAIL_REQ (INSERT), EXEC PR_SSP_MAIL_SEND_ADJUST_MST | CONFIRM_40, CONFIRM_PACKER | 발송 주체는 **확인 필요** |
| DM 동기화 | EXEC PR_DM_SSP_CONFIRM_SYNC, INSERT DM_PLN_MKT_FCST_CONFIRM | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | – |
| 수신(SELECT) | SSP_ANL_MES_FCS_STOCK_40_C, SSP_ANL_OWMS_STOCK_C, SSP_ANL_TCO_STOCK_C, SCM_DNM_SCS_STOCK, SCM_DNM_SCS_PROD_PLAN, SCM_DNM_SCS_SHIP_RESULT, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SCM_DNM_EXFACTORY_RESULT, MST_STOCK, SCM_DNM_STOCK_V, NERP_CONV_MASTER | 조회 SP 다수 | 테이블명에 MES/OWMS/TCO/SCS/NERP가 들어 있다. 적재 배치와 원천 시스템은 **확인 필요** |
| 로그 | SCM_SYS_LOG_BATCH (INSERT), PR_SCM_SYS_LOG_BATCH(_CALL_TRAN), PR_SCP_SYS_LOG_BATCH | 저장 SP 전반 | – |

---

## 8. 미확정·확인 필요

1. FindButton이 FindData_Main, FindData_Main_Packer, FindData_Main_Packer_Past 중 하나를 고르는 조건.
2. SaveButton이 SaveData_Main, SaveData_Detail, SaveData_Detail_Packer 중 하나를 고르는 조건. SaveData_Detail 안에서 CONFIRM_40, BLOCK_STOCK_DATA, MES_STOCK을 고르는 조건.
3. GetERPInterface 하위 단계의 실행 순서와 분기(SoNo/NonSoNo), 오류 처리.
4. unreached 메서드 6개(GetErpIFCheck, GetErpIFCheckNew_, SCM_SYS_LOG_BATCH, GetDivision, SetChangedPeriod, NewNonSoNo)의 실제 사용 여부와 TO-BE 이관 여부. 관련 엔드포인트는 `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SCP.PR_SCM_SYS_LOG_BATCH`, `SCM.SCM0001_GET_DIVISION`, CommonDataList[PERIOD_*, PERIOD2_*]이다.
5. 메타에만 있는 시트 `Shipment PSI(IT & Mobile)`, `MES Stock Detail`과 프로그램 `SSP0015_TEMP2`의 용도.
6. `W/H stock Detail` 시트의 조회 엔드포인트(추출되지 않음).
7. 동적 SQL SP 8개(SSP0015_GET_SHIPMENT_CONFIRM_DETAIL, _DETAIL_PACKER, SSP0015_GET_SHIPMENT_PSI, _PACKER, _PACKER_PAST, _PSI_COMMENTS, SSP0026_GET_REQUEST_DETAIL_PACK, SSP0202_GET_SCS_CONFIRM_ID_CHECK)의 실제 참조 테이블.
8. R12~R16의 검증 조건, 차단 기준, 메시지 문구.
9. 본 화면 SaveButton:271과 팝업 btnButtonList:430의 SaveData가 `PersonalSettingPopup.SaveData`로 해석된 것(4-2장). SSP0015_SAVE_SHIPMENT_PSI_COMMENTS 경로와 충돌한다.
10. 팝업을 여는 진입점과 팝업 수량 텍스트박스들의 계산 규칙.
11. 메뉴 위치와 TB_FX_GroupMenuAuth 14행의 권한 값.
12. legacy와 current 파일의 차이(.cs 9857 대 9922줄, Designer 1624 대 1628줄).
13. 주석 처리된 호출 4건(3573, 9288, 9308, 9309줄)은 현행 기능에서 제외했다.
14. SP 실행 결과 컬럼과 메타 컬럼이 맞는지(grid 단계 미실행).
