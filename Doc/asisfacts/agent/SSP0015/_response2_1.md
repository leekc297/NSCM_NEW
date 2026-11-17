[T 산출: SSP0015 업무분석서·화면설계서·단위테스트 3종 / 근거: 프롬프트의 Fact Pack·1차 분석서만 사용, 파일 쓰기 없음]

=== FILE: business_analysis.md ===
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

=== FILE: screen_design.md ===
# SSP0015 Shipment PSI — 화면설계서 (As-Is → To-Be)

> 근거: Fact Pack(controls · props 원문은 1차 web_components에 옮겨진 범위만 사용), grid_rule, grid_code, grid_effective. 없는 값은 **확인 필요**로 적었다.
> §5의 엔드포인트명은 업무분석서 §5와 단위테스트 '근거' 열과 같은 이름이다. §3의 컨트롤명은 단위테스트 '절차' 열에서 그대로 쓴다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0015 |
| 화면명 | Shipment PSI (`SSP0015_ShipmentPSI`) |
| 팝업 | `SSP0015_ShipmentPSICommentsPopup` (WH In 코멘트 저장) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행. 내용은 Fact Pack에 없음) |
| Grid 구성 | HYBRID: META(SCM_MST_SHEET_COLUMNS 395행, SCM_MST_SHEET_MEASURE 32행) + DB루프(SCP0009 날짜 컬럼) + 코드 표시 변경 |
| 컨트롤 | 100개(controls.csv). 이 문서 §3에는 주요 컨트롤 46개를 실었다. |
| 조회조건 저장 메타 | TB_FX_SearchCondition 766행, TB_FX_Favorite 117행, SCM_MST_TITLESET_USER 12행 |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv SplitContainer + controls.csv parent 체인)

```
SSP0015_ShipmentPSI (Form, 폭 1370)
├─ usrConditionPanel1        [UsrConditionPanel, Dock=Top, 1370×79, UsrPanelType=HidePanel]   ← 조회조건 영역
│   └─ usrLayoutControl2     [UsrLayoutControl, Dock=Top, 1370×73]
│        clbDivision · cboPlanDate · drpPeriod · cboBucketType · chkSum · btnMeasure ·
│        clbPlantSite · txtItemId · btnItemId · (숨김) chkMyModel · chkPartLeader · chkTeamLeader · chkDelegateeModel
├─ splitContainer1           [SplitContainer, Dock=Fill, Orientation=Horizontal(상/하), 1370×570, SplitterDistance=301]
│   ├─ Panel1 (상)  301 / 570 = 52.8 %
│   │   └─ spdMain           [FpSpread, Dock=Fill, 1370×301] ─ spdMain_Sheet1 (런타임 AddSheet: PSI 시트)
│   └─ Panel2 (하)  269 / 570 = 47.2 % (스플리터 폭 포함)
│       ├─ usrLayoutControl3 [UsrLayoutControl, Dock=Top, 1370×40]  = Panel2 내부 40/265 = 15.1 %
│       │    clbResultType · txtRequestor · btnRequestor · txtModel2 · btnItemID2 ·
│       │    drpPeriod2 · drpPeriod3 · txtLotID · btnSearch
│       └─ spdDetail         [FpSpread, Dock=Fill, 1370×225]          = Panel2 내부 225/265 = 84.9 %
│            └─ spdDetail_Sheet1 (런타임 AddSheet: Detail 시트)
└─ usrButton1                [UsrButton, 75×23, 부모 없음 — 배치 위치 확인 필요]
```
- 301 + 40 + 225 = 566이다. 570과의 차이 4는 스플리터 폭으로 보이지만, 스플리터 폭이 추출되지 않아 **확인 필요**하다.
- LayoutControl 안의 항목 배치 좌표가 추출되지 않았다. 조회조건 항목의 실제 좌→우 순서는 **확인 필요**하다(아래 와이어프레임은 Designer 선언 순서를 따랐다).

### 2-2. 텍스트 와이어프레임

```
┌───────────────────────────────────────────────────────────────────────────────────────┐
│ [툴바: 프레임워크 FindButton / EditButton / SaveButton — 위치·표시 버튼 확인 필요]          │
├──────────────────────── usrConditionPanel1 (H79, 접힘 패널) ─────────────────────────────┤
│ Division* [clbDivision ▼]  Plan-date* [cboPlanDate ▼]  Period* [drpPeriod ~ ]            │
│ Bucket [cboBucketType ▼] [☐ Sum chkSum] [btnMeasure]  From Site [clbPlantSite ☑▼]        │
│ Model [txtItemId     ][btnItemId]                                                         │
├═════════════ splitContainer1 (Horizontal) — Panel1 52.8 % ══════════════════════════════┤
│ spdMain : 탭 [Shipment PSI(Mobility & IT)] [Shipment PSI(Packer)]                        │
│   고정 컬럼(Div·From Site·Model·Nick Name·…·Measure) │ 3단 날짜 헤더(D_/W_/M_ + SUM)      │
├────────────────────────── splitter (Distance 301) ──────────────────────────────────────┤
│ usrLayoutControl3 (H40):                                                                  │
│ [clbResultType ☑▼] Requestor [txtRequestor][btnRequestor] [txtModel2][btnItemID2]         │
│ Shipment Date [drpPeriod2 ~ ] [drpPeriod3 ~ ] [txtLotID      ] [ Search btnSearch ]      │
├───────────────────────────── Panel2 47.2 % ─────────────────────────────────────────────┤
│ spdDetail : 탭 [Shipment Confirm Detail][Shipment Request Detail][W/H stock]              │
│            [W/H stock Detail][Hold stock][Hold stock Detail][Stock Detail]                │
│            [SCS Stock Detail][Stock Location Detail][WH In Plan Detail*권한][Shipment Result] │
└───────────────────────────────────────────────────────────────────────────────────────┘

[팝업 SSP0015_ShipmentPSICommentsPopup] (레이아웃 props 미수록 → 배치 확인 필요)
┌──────────────────────────────────────────┐
│ usrConditionPanel1 > usrLayoutControl1 / usrLayoutControl2 (팝업 내 parent 체인 확인 필요) │
│ txtPlan_Date txtDivision_ID txtFrom_Site txtItem_ID txtDate txtMeasure                  │
│ txtGap_Qty txtBefore_Qty txtProd_Qty txtWHin_Qty txtCurrent_Qty txtChange_Qty           │
│ usrLabel1   rtxComments (RichTextBox)                                                    │
│                                      [btnButtonList : 저장 등]                            │
└──────────────────────────────────────────┘
```

---

## 3. 컨트롤 명세 (46개)

- 라벨은 props.csv Text(또는 LayoutControlItem.Text) 원문이다. props.csv가 잘려서 원문이 없는 경우 **확인 필요**로 적었다.
- 필수 여부는 라벨의 `*` 표기만 근거로 삼았다.

| # | 컨트롤명 | 타입 | 라벨(원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | usrConditionPanel1 | UsrConditionPanel | – | Dock=Top, HidePanel | – | – | 조회조건 패널(접힘) |
| 2 | usrLayoutControl2 | UsrLayoutControl | – | Dock=Top 1370×73 | – | – | 조회조건 그리드 레이아웃 |
| 3 | clbDivision | UsrCombo | `Division*` (lblCombo1) | 확인 필요 (GetSSPInnerTable 바인딩 추정) | Y | `clbDivision_SelectedIndexChanged` | ComboBox |
| 4 | cboPlanDate | UsrCombo | `Plan-date*` (PlanDate) | CommonDataList[PlanDateShip] 결과. 기본 선택값은 확인 필요 | Y | `CboPlanDate_SelectedIndexChanged` | ComboBox |
| 5 | drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | GetDayRange(SCM0001_GET_SCP_DAY_PERIOD) 결과 | Y | – | DateRange(InputDate×2) |
| 6 | cboBucketType | UsrCombo | `Bucket` (lblBucket) | DM0003 결과(DAILY/WEEKLY/MONTHLY). 기본값은 확인 필요 | N | `cboBucketType_SelectedIndexChanged` | ComboBox |
| 7 | chkSum | UsrCheckBox | `Sum` | 확인 필요 | N | `chkSum_CheckedChanged` | CheckBox |
| 8 | btnMeasure | UsrButton | 확인 필요 | – | – | `btnMeasure_Click` | Button(Measure 선택) |
| 9 | clbPlantSite | UsrCheckedList | `From Site` (layoutControlItem7) | 확인 필요 | N | – | MultiSelect |
| 10 | txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 빈값(확인 필요) | N | – | 멀티라인 입력 |
| 11 | btnItemId | UsrButton | 확인 필요 | – | – | `btnItemId_Click` | Button(Model 팝업) |
| 12 | chkMyModel | UsrCheckBox | `My Model` | Checked=true, Visible=false | – | – | 숨김(파라미터 사용 확인 필요) |
| 13 | chkPartLeader | UsrCheckBox | `Part Leader` | Visible=false | – | – | 숨김 |
| 14 | chkTeamLeader | UsrCheckBox | `Team Leader` | Visible=false | – | – | 숨김 |
| 15 | chkDelegateeModel | UsrCheckBox | `Delegatee Model` | Visible=false | – | – | 숨김 |
| 16 | usrButton1 | UsrButton | 확인 필요 | 부모 없음 | – | – | 확인 필요 |
| 17 | spdMain | FpSpread | – | Dock=Fill, Panel1 | – | `spdMain_TextTipFetch`, `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `SpdMain_ActiveSheetChanged`, `SpdMain_EditModeOn`, `SpdMain_CellClick` | Wijmo FlexGrid + 시트 탭 |
| 18 | spdMain_Sheet1 | SheetView | – | Designer 기본 시트 | – | – | (런타임 시트로 대체됨. 확인 필요) |
| 19 | spdDetail | FpSpread | – | Dock=Fill, Panel2 | – | `SpdDetail_TopChange`, `SpdDetail_CellClick`, `spdDetail_ComboSelChange`, `SpdDetail_SheetTabClick`, `SpdDetail_CellDoubleClick`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_EditChange`, `SpdDetail_ClipboardPasted`, (dsdm) `shtDetail_Change` | Wijmo FlexGrid + 시트 탭 |
| 20 | spdDetail_Sheet1 | SheetView | – | Designer 기본 시트 | – | – | (위와 같음) |
| 21 | usrLayoutControl3 | UsrLayoutControl | – | Dock=Top 1370×40 | – | – | Detail 조회조건 레이아웃 |
| 22 | clbResultType | UsrCheckedList | 확인 필요 | 확인 필요 | – | – | MultiSelect |
| 23 | btnRequestor | UsrButton | 확인 필요 | – | – | `BtnRequestor_Click` | Button(사용자 팝업) |
| 24 | txtRequestor | UsrTextBox | LayoutItem 이름 `Requestor`(Text 확인 필요) | 확인 필요 | – | – | Input |
| 25 | btnSearch | SimpleButton | `Search` | – | – | `BtnSearch_Click` | Button |
| 26 | txtModel2 | UsrMultiLineEditor | 확인 필요 | 확인 필요 | – | – | 멀티라인 입력 |
| 27 | btnItemID2 | UsrButton | 확인 필요 | – | – | `BtnItemID2_Click` | Button(Model 팝업) |
| 28 | drpPeriod2 | UsrDateRangePicker | `Shipment Date` (layoutControlItem11) | 확인 필요 | – | – | DateRange |
| 29 | drpPeriod3 | UsrDateRangePicker | 확인 필요 | 확인 필요 | – | – | DateRange |
| 30 | txtLotID | UsrMultiLineEditor | 확인 필요 | 확인 필요 | – | – | 멀티라인 입력 |
| 31 | usrLayoutControl1 | UsrLayoutControl | – | (팝업) 확인 필요 | – | – | 팝업 레이아웃 |
| 32 | txtGap_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtGap_Qty_TextChanged` | InputNumber |
| 33 | txtBefore_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtBefore_Qty_TextChanged` | InputNumber |
| 34 | txtProd_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtProd_Qty_TextChanged` | InputNumber |
| 35 | txtWHin_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtWHin_Qty_TextChanged` | InputNumber |
| 36 | txtMeasure | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input(읽기전용 여부 확인 필요) |
| 37 | txtFrom_Site | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input(위와 같음) |
| 38 | txtDivision_ID | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input(위와 같음) |
| 39 | rtxComments | RichTextBox | 확인 필요 | 확인 필요 | – | – | TextArea |
| 40 | usrLabel1 | UsrLabel | 확인 필요 | – | – | – | Label |
| 41 | txtCurrent_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtCurrent_Qty_TextChanged` | InputNumber |
| 42 | txtChange_Qty | UsrTextBox | 확인 필요 | 확인 필요 | – | `txtChange_Qty_TextChanged`, `txtChange_Qty_KeyPress` | InputNumber(입력 제한 내용 확인 필요) |
| 43 | txtDate | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input |
| 44 | txtItem_ID | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input |
| 45 | txtPlan_Date | UsrTextBox | 확인 필요 | 확인 필요 | – | – | Input |
| 46 | btnButtonList | UsrButtonList | – | – | – | `btnButtonList_UsrButtonList_Click_Detected` | 버튼 그룹(저장) |

- 폼 이벤트: 본 화면 `Form_Load`(.ctor:422)와 팝업 `Form_Load`(.ctor:207)가 있다.

---

## 4. 그리드 명세

- 범례
  - 출처: META = SCM_MST_SHEET_COLUMNS, CODE = 화면 코드
  - division별 표시: 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 같으면 "공통"
  - 타입과 편집 가능: 메타 CELL_CONTROL_OBJECT_TYPE_CODE와 시트 잠금 값이 Fact Pack에 없어 `확인` 표기 = **확인 필요**. 라벨에 `*`가 붙은 컬럼은 편집·필수 후보로 따로 적었다.
  - 헤더 `—`: 원문 미수록

### 4-1. spdMain

#### (1) `Shipment PSI(Mobility & IT)` — META+코드연결, 표시 10 (14 div 공통), Measure 12/1, MergePolicy.Always

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 | META | 공통 표시 | 확인 |
| FIGURE | Figure | 확인 | META | 공통 표시 | 확인 |
| FROM_SITE_NM | From Site | 확인 | META | 공통 표시 | 확인 |
| ITEM_ID | Model | 확인 | META | 공통 표시 | 확인 |
| LT_DAY | Aging L/T | 확인 | META | 공통 표시 | 확인 |
| MEASURE_NAME | Measure | 확인 | META | 공통 표시 | 확인 |
| NICK_NAME | Nick Name | 확인 | META | 공통 표시 | 확인 |
| PSI_NAME | PSI | 확인 | META | 공통 표시 | 확인 |
| TYPE | TYPE | 확인 | META | 공통 표시 | 확인 |
| YEILD | Yield(%) | 확인 | META | 공통 표시 | 확인 |
| FROM_SITE(Site), LT_UPDATE_YN, MEASURE, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN | — | 확인 | META | 공통 숨김 | – |
| SHIP_TO, SHIPTO_DESCRIPTION | — | – | CODE(4991/4992) | →숨김(시트 연결이 맞는지 확인 필요) | – |
| 날짜 `D_*`/`W_*`/`M_*` | COLUMN_LABEL_NAME(3단 헤더 + SUM) | Num(폭 70) / `B_*`=Text(폭 0, 숨김) | CODE(DB루프 SCP0009) | Bucket/Sum 규칙(업무분석서 R5). SAT=Blue, SUN=Red | 확인 |

#### (2) `Shipment PSI(Packer)` — META+코드연결, 표시 8, Measure 6/0, MergePolicy.Always, SetSoNoColumnVisible(80/0)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 | META | 공통 표시 | 확인 |
| FIGURE | Figure | 확인 | META | 공통 표시 | 확인 |
| FROM_SITE_NM | From Site | 확인 | META | 공통 표시 | 확인 |
| ITEM_ID | Model | 확인 | META | 공통 표시 | 확인 |
| MEASURE | Measure | 확인 | META | 공통 표시 | 확인 |
| NICK_NAME | Nick Name | 확인 | META | 공통 표시 | 확인 |
| PSI_NAME | PSI | 확인 | META | 공통 표시 | 확인 |
| TYPE | TYPE | 확인 | META | 공통 표시 | 확인 |
| FROM_SITE, LT_DAY, LT_UPDATE_YN, MEASURE_NAME, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN, YEILD | — | 확인 | META | 공통 숨김 | – |
| 날짜 컬럼 | (1)과 같음 | (1)과 같음 | CODE | (1)과 같음 | 확인 |
| SO No 계열(컬럼명 확인 필요) | — | – | CODE(9778~9793) | ichkbtn에 따라 Width 80/0 | – |

#### (3) `Shipment PSI(IT & Mobile)` — 메타 정의만 있음. 코드가 AddSheet하지 않는다(미사용 가능). 메타상 표시 10, Measure 12/1
- 컬럼 구성은 (1)과 같다. 헤더만 `Yeild(%)`로 철자가 다르다. TO-BE 포함 여부는 **확인 필요**하다.

### 4-2. spdDetail

#### (4) `Shipment Confirm Detail` — META+코드연결, 표시 40 (메타 규칙 집계 39/0와 1 차이 → 확인 필요)

| 컬럼 | 헤더 | 출처 | 표시 | 비고 |
|---|---|---|---|---|
| ATTRIBUTE10 | — | META | 공통 | |
| attribute3 | PLM status | META | 공통 | |
| attribute6 | OQC Result | META | 공통 | |
| CHANGE_REASON_CODE | Change Reason | META | 공통 | |
| CHANGE_REASON_DETAIL | Reason Detail | META | 공통 | |
| CHANGE_REQ_NO | Change Request No | META | 공통 | |
| CONFIRM_ID | Confirm/Plan ID | META | 공통 | |
| DIVISION_ID | Division | META | 공통 | |
| END_CUSTOMER | End Customer | META | 공통 | |
| ERP_SO_NO | SO No | META | 공통 | |
| ETA | ETA | META | 공통 | |
| ETD | ETD | META | 공통 | |
| Expected_Shipping_Date | Expected Shipping Date | META | 공통 | |
| FCST_TYPE | FCST Type | META | 공통 | |
| FROM_SITE_DESCRIPTION | From Site | META | 공통 | |
| INCOTERMS | Incoterms | META | 공통 | |
| ITEM_ID | Model | META | 공통 | |
| LT_DAY | L/T(Day) | META | 공통 | |
| MODEL_USER | Model PIC | META | 공통 | |
| MTK_OWNER | MKT Owner | META | 공통 | |
| NICK_NAME | Nick Name | META | 공통 | |
| REMARKS | Remarks | META | 공통 | Validation_Check 대상 |
| REMARKS2 | Building | META | 공통 | Validation_Check 대상 |
| REMARKS3 | Customer Requirement | META | 공통 | |
| REQUESTOR | Shipment Requestor | META | 공통 | |
| RTF3 | RTF | META | 공통 | |
| RTF4 | RTF ETD | META | 공통 | |
| RTF5 | RTF QTY | META | 공통 | |
| RTF6 | RTF Detail | META | 공통 | |
| SHIPMENT_CONFIRM_QTY | Shipment Qty | META | 공통 | Validation_Check 대상 |
| SHIPMENT_DATE | Shipment Date | META | 공통 | Validation_Check 대상 |
| SHIPMENT_STATUS | Status | META | 공통 | |
| SOLDTO_DESCRIPTION | Sold To Party | META | 공통 | |
| TEAM | Team | META | 공통 | |
| TO_SITE_DESCRIPTION | To Site | META | 공통 | |
| TO_SITE_SHIPTO_CODE | Ship to | META | 공통 | Validation_Check 대상. ShipToCodeByDivision 콤보 |
| TO_SITE_SOLDTO_CODE | Sold to | META | 공통 | |
| TRANSPORT_MODE | Trans Mode | META | 공통 | Validation_Check 대상. TransMode 콤보 |
| UPDATED_BY | Updated By | META | 공통 | |
| UPDATED_DATE | Updated Date | META | 공통 | |
| SHIPTO_DESCRIPTION | Ship To Party | META 기본 → CODE | →숨김 | |
| BEFORE_QTY, BOD_ID, CHANGE_TYPE, CHECK_NEED_YN, CHK(ALL), EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE(Shipment Date*), NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PROJECT_CODE, PROJECT_NAME, TO_SITE | (괄호 안 원문) | META | 숨김 | CHK(ALL) = 헤더 CheckBox(SpdDetail_CellClick) |

- 코드 Visible=false: FindData_Detail 3218~3221, 3356~3359 / FindData_Detail_Packer_btnSearch 3491~3493 / FindData_Detail_btnSearch 3758~3761. 대상 컬럼은 **확인 필요**하다.
- 타입과 편집 가능 여부는 전 컬럼 **확인 필요**하다.
- `SSP0015_TEMP2` 프로그램에도 같은 이름의 시트(31/0)가 있다. 용도는 **확인 필요**하다.

#### (5) `Shipment Request Detail` — META+코드연결, 표시 34

| 컬럼(헤더) | 출처 | 표시 | `*` 표기(편집·필수 후보) |
|---|---|---|---|
| ATTRIBUTE3(RTF), ATTRIBUTE4(RTF ETD), ATTRIBUTE5(RTF QTY), ATTRIBUTE6(RTF Detail), BOD_ID, CHANGE_REQUEST_NO, EDIT_FLAG, END_CUSTOMER, ETA_DATE(ETA), ETD_DATE(ETD), EXPECTED_SHIP_DATE, LAST_UPDATED_BY(Requestor), LAST_UPDATED_DATE(Request Date), LT_TOTAL(L/T(Day)), MKT_OWMER(MKT Owner), MODEL_PIC, NICK_NAME, ORDER_TYPE_DETAIL, REMARK, REQUEST_ID(Confrim/Plan ID), SHIPTO_NAME, SITE_DESCRIPTION(Plant Site), SOLDTO_CODE(Sold to), STATUS | META | 공통 | – |
| DIVISION_ID(Div*), FCST_TYPE(FCST Type*), FROM_SITE(From Site*), INCOTERMS(Incoterms*), MODEL_ID(Model*), QTY(Qty*), SHIPTO_CODE(Ship to*), TO_SITE(To Site*), TR_MODE(Trans Mode*), YYYYMMDD(Shipment Date*) | META | 공통 | `*` (편집 여부 확인 필요) |
| SHIP_TO, SHIPTO_DESCRIPTION | CODE | →숨김 | – |

#### (6) `W/H stock` — META+코드연결, 메타 19/0 (14 div 공통)
- 컬럼 상세는 grid_effective가 잘려 **확인 필요**하다. 코드 →숨김: SHIP_TO, SHIPTO_DESCRIPTION(연결 확인 필요).

#### (7) `W/H stock Detail` — META+코드연결, 메타 25/0
- 컬럼 상세와 조회 엔드포인트 모두 **확인 필요**하다.

#### (8) `Hold stock` — META+코드연결, 표시 10, 저장 `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA`

| 컬럼 | 헤더 | 출처 | 표시 | `*` |
|---|---|---|---|---|
| DIVISION_ID | Div | META | 공통 | |
| FROM_SITE_NM | From Site | META | 공통 | |
| HOLD_QTY | Amend Qty* | META | 공통 | `*` |
| HOLD_YYYYMMDD | Start Date | META | 공통 | |
| ITEM_ID | Model | META | 공통 | |
| LAST_UPDATE_DATE | — | META | 공통 | |
| LAST_UPDATED_BY | — | META | 공통 | |
| NICK_NAME | — | META | 공통 | |
| RELEASE_YYYYMMDD | End Date* | META | 공통 | `*` |
| REMARKS | — | META | 공통 | |
| FROM_SITE, HOLD_ID | — | META | 숨김 | |
| SHIP_TO, SHIPTO_DESCRIPTION | — | CODE | →숨김 | |

#### (9) `Hold stock Detail` — META+코드연결, 표시 10
- 컬럼은 (8)과 같다. 헤더에서 `Amend Qty`와 `End Date`에 `*`가 없다는 점만 다르다.

#### (10) `Stock Detail` — META+코드연결(코드상 shtMesStock), 메타 26/0, 저장 `SSP.SSP0015_SAVE_MES_STOCK`

| 컬럼 | 헤더 | 출처 | 표시 |
|---|---|---|---|
| AVAILABLE_YN, DIVISION_ID, FCS_HOLD_YN, FCS_SPECIAL_QTY, ITEM_ID, JUDG_VLD_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY, LONGTERM_HOLD_YN, LOT_ID, LOT_QTY_FCS, LOT_QTY_MES, LOT_QTY_MES_NG, LOT_QTY_TOT, LOT_TYPE, MES_CHANGE_STATUS, MES_HOLD_RELEASE, MES_HOLD_YN, NICK_NAME, OWMS_STOCK_QTY, QMS_HOLD_RELEASE, QMS_HOLD_YN, REMARKS | — | META | 공통 |
| FROM_SITE | Site | META | 공통 |
| USER_MOD_RELEASE_DATE | User Modified Release Date* | META | 공통 (`*`) |
| YYYYMMDD_LOT_ID_APPLIED_LT | D Day(Expected) | META | 공통 |
| SHIP_TO, SHIPTO_DESCRIPTION | — | CODE | →숨김 |

#### (11) `MES Stock Detail` — 메타 정의만 있음, 코드 미참조(미사용 가능), 메타 24
- 컬럼은 (10)에서 LONGTERM_HOLD_YN과 LOT_QTY_MES_NG를 뺀 구성이다. TO-BE 포함 여부는 **확인 필요**하다.

#### (12) `SCS Stock Detail` — META+코드연결, 표시 9

| 컬럼 | 헤더 | 출처 | 표시 |
|---|---|---|---|
| CUTOFF_DATE, DIVISION_ID, HOLD_YN, PLANT_ID, PLANT_NAME, PROD_DATE, QTY | — | META | 공통 |
| LAST_UPDATE_DATE | Update Date | META | 공통 |
| MODEL_ID | Model | META | 공통 |
| SHIP_TO, SHIPTO_DESCRIPTION | — | CODE | →숨김 |

#### (13) `Stock Location Detail` — META+코드연결, 메타 20/0
- 확인된 표시 컬럼: AVAILABLE_DATE, AVAILABLE_QTY, COMPANY_ID, CUTOFF_DATE, DEFECT_QTY(Deffect Qty), DIVISION_ID. 나머지 14개는 **확인 필요**하다.

#### (14) `WH In Plan Detail` — META+코드연결, 메타 11/0, `drPgmAuthId != null`일 때만 생성
- 컬럼 상세는 **확인 필요**하다.

#### (15) `Shipment Result` — META+코드연결, 표시 17 (메타 19 − 코드 숨김 2)

| 컬럼 | 헤더 | 출처 | 표시 |
|---|---|---|---|
| CONFIRM_ID, DIVISION_ID, END_CUSTOMER, ETA_DATE, ETD_DATE, FROM_SITE, INCOTERMS, ITEM_ID, NICK_NAME, SHIP_TYPE, TEAM, TO_SITE, TRANSPORT_MODE | — | META | 공통 |
| ERP_SO_NO | SO No | META | 공통 |
| QTY | Shipment Qty | META | 공통 |
| TYPE | Status | META | 공통 |
| YYYYMMDD | Shipment Date | META | 공통 |
| SHIP_TO | Ship to | META 기본 → CODE(4991) | →숨김 |
| SHIPTO_DESCRIPTION | Ship to Name | META 기본 → CODE(4992) | →숨김 |

### 4-3. 시트 연결 (코드 상수 → 조회)
| 시트 | Spread | 코드 상수 | 조회 엔드포인트 |
|---|---|---|---|
| Shipment PSI(Mobility & IT) | spdMain | SpdSheet.shtMain | `SSP.SSP0015_GET_SHIPMENT_PSI` |
| Shipment PSI(Packer) | spdMain | SpdSheet.shtPacker | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` / `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` |
| Shipment Confirm Detail | spdDetail | shtDetail | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` |
| Shipment Request Detail | spdDetail | shtRequestDetail | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` |
| W/H stock | spdDetail | shtWHstock | `SSP.SSP0015_GET_WH_STOCK` |
| W/H stock Detail | spdDetail | shtWHstockDetail | 확인 필요 |
| Hold stock / Hold stock Detail | spdDetail | shtBolckStock / shtBolckStockDetail | `SSP.SSP0015_GET_BLOCK_STOCK` |
| Stock Detail | spdDetail | shtMesStock | `SSP.SSP0015_GET_MES_STOCK` |
| SCS Stock Detail | spdDetail | shtScsStock | `SSP.SSP0015_GET_SCS_STOCK` |
| Stock Location Detail | spdDetail | shtStockLocationDetail | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` (+ `SSP.SSP0002_GET_NERP_CODE`) |
| WH In Plan Detail | spdDetail | shtWHinPlanDetail | `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` |
| Shipment Result | spdDetail | shtShipmentResult | `SSP.SSP0015_GET_SHIPMENT_RESULT` / `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` |

- 초기 활성 시트: CreateSpread의 ChangeSheet 호출 순서(740 → 741 → 746)로 보면 Main은 Mobility & IT, Detail은 Shipment Confirm Detail로 추정된다. 실행으로 **확인 필요**하다.

---

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 로드 | `Form_Load` | InitControls, GetBucketType, GetDayRange, SetChangedControl, CreateSpread, InitSpread | `biz:CommonData.CommonDataList`[PlanDateShip], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | cboPlanDate, cboBucketType, drpPeriod, spdMain·spdDetail 시트 |
| A2 | Division 변경 | `clbDivision_SelectedIndexChanged` | SetChangedControl > GetDayRange | `biz:CommonData.CommonDataList`[PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD` | cboPlanDate, drpPeriod |
| A3 | Plan-date 변경 | `CboPlanDate_SelectedIndexChanged` | GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod |
| A4 | Bucket 변경 | `cboBucketType_SelectedIndexChanged` | 엔드포인트 없음. SetSpreadColumn 호출 여부는 확인 필요 | – | spdMain D_/W_/M_ 표시 |
| A5 | Sum 체크 | `chkSum_CheckedChanged` | 위와 같음 | – | spdMain M_/W_ 표시 |
| A6 | Measure 버튼 | `btnMeasure_Click` | InitSpread > GetSpdTitle | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 헤더 재구성 |
| A7 | Model 버튼(상단) | `btnItemId_Click` | 엔드포인트 미추출(팝업 추정, 확인 필요) | – | txtItemId(확인 필요) |
| A8 | Model 버튼(하단) | `BtnItemID2_Click` | 위와 같음 | – | txtModel2(확인 필요) |
| A9 | Requestor 버튼 | `BtnRequestor_Click` | 위와 같음 | – | txtRequestor(확인 필요) |
| A10 | Main 시트 탭 변경 | `SpdMain_ActiveSheetChanged` | LookupCommon 조회(1400/1452), SetChangedControl, InitSpread | `biz:CommonData.CommonDataList`[LookupCommon, PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 조회조건, spdMain 헤더 |
| A11 | 조회 | FindButton(프레임워크) | FindData_Main / FindData_Main_Packer / FindData_Main_Packer_Past (분기 확인 필요) > Re_Design > GetNERPCode, InitSpread | `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER`, `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST`, `SSP.SSP0002_GET_NERP_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain |
| A12 | Main 더블클릭 | `SpdMain_CellDoubleClick` | DIVISION_ID·SITE·ITEM_ID·YYYYMMDD로 Detail 조회 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_WH_STOCK`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0015_GET_BLOCK_STOCK`, `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SSP.SSP0015_GET_SCS_STOCK`, `SSP.SSP0015_GET_SHIPMENT_PSI`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail 활성 시트 |
| A13 | Main 셀 클릭 | `SpdMain_CellClick` | 엔드포인트 미추출 | – | 확인 필요 |
| A14 | Main 편집 시작 | `SpdMain_EditModeOn` | 엔드포인트 미추출 | – | 확인 필요 |
| A15 | Main 툴팁 | `spdMain_TextTipFetch` | 엔드포인트 미추출 | – | 셀 툴팁(내용 확인 필요) |
| A16 | Main 스크롤 | `SpdMain_TopChange` | 엔드포인트 미추출(spdDetail과 스크롤 동기화로 추정, 확인 필요) | – | 확인 필요 |
| A17 | Detail 스크롤 | `SpdDetail_TopChange` | 위와 같음 | – | 확인 필요 |
| A18 | Detail Search | `BtnSearch_Click` | 활성 Detail 시트별 FindData_*_btnSearch | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SSP.SSP0015_GET_WH_STOCK`, `SSP.SSP0015_GET_BLOCK_STOCK`, `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SSP.SSP0015_GET_SCS_STOCK`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0026_GET_REQUEST_DETAIL_PACK`, `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS`, `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER`, `SSP.SSP0015_GET_SHIPMENT_RESULT`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail 활성 시트. Shipment Result에서는 SHIP_TO·SHIPTO_DESCRIPTION 숨김 |
| A19 | Detail 셀 클릭 | `SpdDetail_CellClick` | Trans Mode·Ship to 콤보 구성, 헤더 CheckBox 전체 토글(IsLock 분기) | `biz:CommonData.CommonDataList`[TransMode, ShipToCodeByDivision] | spdDetail 셀 콤보, CHK |
| A20 | Detail 콤보 선택 | `spdDetail_ComboSelChange` | 엔드포인트 미추출 | – | 확인 필요 |
| A21 | Detail 탭 클릭 | `SpdDetail_SheetTabClick` | 엔드포인트 미추출 | – | 확인 필요 |
| A22 | Detail 탭 전환 | `SpdDetail_ActiveSheetChanged` | 엔드포인트 미추출 | – | 하단 조회조건 표시 전환 추정(확인 필요) |
| A23 | Detail 더블클릭 | `SpdDetail_CellDoubleClick` | 엔드포인트 미추출 | – | 확인 필요 |
| A24 | Detail 편집 | `SpdDetail_EditChange` | 엔드포인트 미추출 | – | 확인 필요 |
| A25 | Detail 붙여넣기 | `SpdDetail_ClipboardPasted` | TransMode 코드(CODE) 대조 | `biz:CommonData.CommonDataList`[TransMode] | 붙여넣은 Trans Mode 값 |
| A26 | Detail 데이터 변경 | `shtDetail_Change` (dsdm.Changed) | 엔드포인트 미추출 | – | 확인 필요 |
| A27 | 편집 | EditButton(프레임워크) | PlanDateShip 재조회(1753/1757), GetSSPUserCheck | `biz:CommonData.CommonDataList`[PlanDateShip], `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 가능 상태(조건 확인 필요) |
| A28 | 저장(Main) | SaveButton > SaveData_Main | – | `SSP.SSP0015_SAVE_SHIPMENT_PSI` | DB 반영 |
| A29 | 저장(Detail) | SaveButton > SaveData_Detail | Validation_Check(연결 확인 필요) → 저장 → 재조회 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA`, `SSP.SSP0015_SAVE_MES_STOCK` → `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0002_GET_NERP_CODE` | spdMain·spdDetail 재조회 |
| A30 | 저장(Detail Packer) | SaveButton > SaveData_Detail_Packer | chkSaveYN → EngProcessingChk → 확정 저장 → GetERPInterface → 재조회 (순서 확인 필요) | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0015_GET_ERP_SO_NO_CNT`, `SSP.SSP0015_GET_SHIPMENT_STATUS`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | Shipment Confirm Detail 재조회 |
| A31 | (팝업) 저장 | `btnButtonList_UsrButtonList_Click_Detected` | SaveData | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | DB 반영(팝업 닫힘·재조회 여부 확인 필요) |
| A32 | (팝업) 로드 | `Form_Load`(팝업 .ctor:207) | 엔드포인트 미추출 | – | 팝업 텍스트박스 초기값(확인 필요) |
| A33 | (팝업) 수량 입력 | `txtGap_Qty_TextChanged`, `txtBefore_Qty_TextChanged`, `txtProd_Qty_TextChanged`, `txtWHin_Qty_TextChanged`, `txtCurrent_Qty_TextChanged`, `txtChange_Qty_TextChanged` | 엔드포인트 미추출 | – | 계산 결과(확인 필요) |
| A34 | (팝업) 키 입력 | `txtChange_Qty_KeyPress` | 입력 문자 제한(내용 확인 필요) | – | txtChange_Qty |
| A35 | (미연결) | GetErpIFCheck, GetErpIFCheckNew_ | unreached | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | 화면 조작으로 호출되지 않음(확인 필요) |
| A36 | (미연결) | SCM_SYS_LOG_BATCH | unreached | `SCP.PR_SCM_SYS_LOG_BATCH` | 위와 같음 |
| A37 | (미연결) | GetDivision | unreached | `SCM.SCM0001_GET_DIVISION` | 위와 같음 |
| A38 | (미연결) | SetChangedPeriod, NewNonSoNo | unreached | `biz:CommonData.CommonDataList`[PERIOD_{p:value}, PERIOD2_{p:value}], `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | 위와 같음 |

---

## 6. 검증·메시지

| 항목 | 사실 | 메시지 문구 |
|---|---|---|
| 필수 조회조건 | Division*, Plan-date*, Period* (라벨 `*`) | 확인 필요 |
| 저장 전 Validation_Check | confirm_id, shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE를 읽는다 | 확인 필요 |
| SCS Confirm ID 점검 | chkSaveYN이 Tables[0]·[1].CNT를 읽는다 | 확인 필요 |
| 계획 진행 점검 | EngProcessingChk(`SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`) | 확인 필요 |
| 변경 시각 점검 | ChkConfirmChangeTime(`SCM_SSP_CHECK_CONFIRM_CHANGETIME`) | 확인 필요 |
| SO No 건수, 출하 상태 | GetErpSoNoCnt CNT, GetShipmentStatusChk CONFIRM_ID | 확인 필요 |
| ERP I/F Block | chkERPIFBlockYn: BLOCK_YN, PERIOD (원천 미추출) | 확인 필요 |
| Detail 그리드 필수 후보 | 라벨 `*`: Shipment Request Detail 10개 컬럼, Hold stock의 Amend Qty*·End Date*, Stock Detail의 User Modified Release Date*, Confirm Detail의 NEW_SHIPMENT_DATE(Shipment Date*, 숨김) | 확인 필요 |
| 팝업 입력 제한 | txtChange_Qty_KeyPress | 확인 필요 |

---

## 7. 권한 (C/R/U/D 사실)

| 구분 | 사실 |
|---|---|
| 메뉴 권한 | TB_FX_GroupMenuAuth 14행. C/R/U/D 값은 **확인 필요** |
| R (조회) | FindButton, BtnSearch_Click. 다수 SP가 SSP_MST_MODEL_USER·SSP_MST_DELEGATE를 읽는다(담당 범위 필터 여부 확인 필요). |
| U (편집 진입) | EditButton → GetSSPUserCheck(`SSP.SSP0002_GET_USER_INFO_LIST`) |
| C/U (저장) | SaveButton 3갈래. 팝업 btnButtonList 저장 |
| D (삭제) | 화면 삭제 버튼은 Fact Pack에 없다. 삭제는 저장 하위 SP 내부(DELETE SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN_40)에서만 일어난다. |
| 시트 단위 | WH In Plan Detail은 drPgmAuthId가 있을 때만 생성. Detail 시트 IsLock에 따라 헤더 CheckBox 동작이 다르다. |
| 그룹 필터 | NowGroupID, Filter GROUP_ID·USER_ID |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | As-Is | To-Be 메모 |
|---|---|---|
| 레이아웃 | SplitContainer Horizontal, SplitterDistance=301 / 570 | 상하 분할 52.8 : 47.2(스플리터 포함), 하단 내부 조회조건 40 : 그리드 225. 메뉴·버튼 배치는 reference 화면 패턴을 따른다. |
| 시트 탭 | FpSpread 다중 시트(Main 2 + Detail 11) | FlexGrid + 탭. 시트별 컬럼은 SCM_MST_SHEET_COLUMNS 메타를 그대로 쓴다. |
| 3단 날짜 헤더 | ColumnHeaderSpan, SUM 헤더, SAT Blue / SUN Red | FlexGrid columnHeaders 다행과 allowMerging. 주말 색은 formatItem으로 처리 |
| 셀 병합 | MergePolicy.Always (PSI 2개 시트) | allowMerging(Cells)과 컬럼별 allowMerging |
| Bucket/Sum | Tag 접두어 D_/W_/M_ 표시 토글 | 컬럼 visible 바인딩. DAILY일 때 W_ 최종값은 확인 후 결정 |
| 헤더 CheckBox | CHK(ALL) + IsLock 분기 | 헤더 체크 셀. 잠금 시트 동작 차이를 보존 |
| 셀 콤보 | TransMode, ShipToCodeByDivision | DataMap(공통코드 API) |
| 팝업 | CommentsPopup | Modal. 수량 계산·KeyPress 제한 확인 후 이식 |
| SP 변환 | MSSQL `#TMP_*`, `#TBLDYNAMIC*`, STRING_SPLIT, MERGE, 동적 SQL(8개 SP), CTE, FN_* 함수, EXEC 체인 | Oracle 19c: GTT 또는 WITH 절, STRING_SPLIT 대체(FN_SCM_SPLIT 계열 등), MERGE 문법 차이, 동적 SQL → EXECUTE IMMEDIATE 또는 정적화. 변환 전 원문 확인 필요 |
| 로그 | PR_SCM_SYS_LOG_BATCH(_CALL_TRAN), PR_SCP_SYS_LOG_BATCH | 로그 프로시저 Oracle 대응본 필요 |
| I/F | XIF_ERP_*, XIF_SCS_* INSERT | I/F 테이블 존재 여부와 시노님 확인 필요 |
| 미연결 코드 | unreached 6개 메서드 | 이관 범위 결정 전까지 구현 보류 |

---

## 9. 미확정

1. 조회조건 항목의 실제 배치 순서(LayoutControl 좌표 미추출)와 스플리터 폭.
2. 라벨 미추출 컨트롤: btnMeasure, btnItemId, clbResultType, txtRequestor(Text), btnRequestor, txtModel2, btnItemID2, drpPeriod3, txtLotID, usrButton1, 팝업 컨트롤 전부.
3. 팝업 레이아웃과 parent 체인(usrLayoutControl1 포함).
4. 컬럼 상세가 잘린 시트: W/H stock, W/H stock Detail, Stock Location Detail(14개), WH In Plan Detail.
5. 전 시트의 셀 타입과 편집 가능 여부(메타 CELL_CONTROL_OBJECT_TYPE_CODE와 잠금 값 미수록).
6. 엔드포인트가 추출되지 않은 핸들러 16종의 처리 내용(§5 A4, A5, A7~A9, A13~A17, A20~A24, A26, A32~A34).
7. 메타에만 있는 시트(Shipment PSI(IT & Mobile), MES Stock Detail)와 SSP0015_TEMP2.
8. FindButton과 SaveButton의 분기 조건.
9. 초기 활성 시트.

=== FILE: unit_test.md ===
# SSP0015 Shipment PSI — 단위테스트 케이스

> - 기대결과의 기준은 As-Is 동작이다. Fact Pack에서 처리 내용이 확인되지 않은 항목은 "AS-IS 실행 결과와 동일(기대값 확정 전 확인 필요)"로 적었다.
> - '근거' 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5와 화면설계서 §5의 원문과 같다.
> - '절차' 열의 컨트롤명은 화면설계서 §3의 이름을 그대로 쓴다.
> - 주석 처리된 호출은 테스트 대상에서 뺐다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0015-001 | 초기화 | 로그인(Division 권한 보유) | 메뉴에서 SSP0015 화면을 연다 | – | cboPlanDate에 PlanDateShip 공통코드 목록이 채워진다 | `Form_Load` > InitControls / `biz:CommonData.CommonDataList` [code=PlanDateShip] |
| TC-SSP0015-002 | 초기화 | 위와 같음 | 화면 로드 후 cboBucketType 목록을 확인한다 | – | DM0003 결과가 바인딩된다(DAILY/WEEKLY/MONTHLY 포함 여부 확인) | `Form_Load` > GetBucketType / `DM.DM0003_GET_BUCKET_TYPE_CODE` / SP DM0003_GET_BUCKET_TYPE_CODE |
| TC-SSP0015-003 | 초기화 | 위와 같음 | 화면 로드 후 drpPeriod 값을 확인한다 | – | GetDayRange 결과의 From~To가 설정된다 | `Form_Load` > GetDayRange / `SCP.SCM0001_GET_SCP_DAY_PERIOD` / SP SCM0001_GET_SCP_DAY_PERIOD |
| TC-SSP0015-004 | 초기화 | 위와 같음 | 화면 로드 후 spdMain과 spdDetail의 시트 탭과 날짜 헤더를 확인한다 | – | spdMain 탭 = Shipment PSI(Mobility & IT), Shipment PSI(Packer). spdDetail 탭 = 코드 생성 11개(WH In Plan Detail은 권한 시만). 날짜 컬럼 3단 헤더와 SUM이 생성된다. 초기 활성 시트는 AS-IS와 같다(확인 필요) | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle / `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` / SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| TC-SSP0015-005 | 초기화 | 위와 같음 | 화면 로드 후 chkMyModel, chkPartLeader, chkTeamLeader, chkDelegateeModel의 상태를 확인한다 | – | 4개 모두 Visible=false. chkMyModel만 Checked=true | `Form_Load` (Designer 속성) |
| TC-SSP0015-006 | 초기화 | 코멘트 팝업 진입 조건 충족(진입점 확인 필요) | 팝업을 연다 | 대상 행(DIVISION_ID, SITE, ITEM_ID, YYYYMMDD) | txtPlan_Date, txtDivision_ID, txtFrom_Site, txtItem_ID, txtDate, txtMeasure 초기값이 AS-IS와 같다(확인 필요) | `Form_Load`(팝업 .ctor:207) |
| TC-SSP0015-007 | 조회 | clbDivision·cboPlanDate·drpPeriod 입력, spdMain 활성 시트 = Shipment PSI(Mobility & IT) | 조회(FindButton)를 클릭한다 | Division=테스트 대상, Plan-date=최신, Period=기본값 | spdMain에 PSI 행이 표시된다. 행 수와 값이 AS-IS와 같다 | FindButton > FindData_Main / `SSP.SSP0015_GET_SHIPMENT_PSI` / SP SSP0015_GET_SHIPMENT_PSI / 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-008 | 조회 | TC-007과 같음 | 조회 후 NERP 코드가 반영된 셀(Re_Design)을 확인한다 | – | SEGMENT2 값이 반영된다(반영 위치는 확인 필요) | FindButton > Re_Design > GetNERPCode / `SSP.SSP0002_GET_NERP_CODE` / SP SSP0002_GET_NERP_CODE |
| TC-SSP0015-009 | 조회 | spdMain 활성 시트 = Shipment PSI(Packer) | 조회를 클릭한다 | 조회조건 기본값 | Packer PSI가 표시된다. MergePolicy.Always 병합이 적용된다 | FindButton > FindData_Main_Packer / `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` / SP SSP0015_GET_SHIPMENT_PSI_PACKER / 시트 `Shipment PSI(Packer)` |
| TC-SSP0015-010 | 조회 | Packer 시트, Past 분기 조건 충족(조건 확인 필요) | 조회를 클릭한다 | 과거 Plan-date 등(확인 필요) | 과거 Packer PSI가 표시된다. AS-IS와 같다 | FindButton > FindData_Main_Packer_Past / `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` / SP SSP0015_GET_SHIPMENT_PSI_PACKER_PAST |
| TC-SSP0015-011 | 조회(빈 결과) | 데이터가 없는 조건 | 조회를 클릭한다 | 존재하지 않는 Model(txtItemId) | 행 0건. 헤더만 표시되고 오류는 없다(AS-IS 메시지 확인 필요) | `SSP.SSP0015_GET_SHIPMENT_PSI` |
| TC-SSP0015-012 | 조회(오류) | SP 실행 오류를 유도(권한 없는 계정 또는 잘못된 파라미터) | 조회를 클릭한다 | – | 오류 메시지가 표시되고 그리드가 깨지지 않는다(문구 확인 필요) | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` |
| TC-SSP0015-013 | 조회(검증) | clbDivision 미선택 | 조회를 클릭한다 | Division 빈값 | 필수(`Division*`) 처리가 AS-IS와 같다(메시지 확인 필요) | FindButton / 컨트롤 clbDivision 라벨 `Division*` |
| TC-SSP0015-014 | 그리드 | TC-007 조회 완료, Detail 활성 시트 = Shipment Confirm Detail | spdMain 데이터 셀을 더블클릭한다 | 행의 DIVISION_ID·SITE·ITEM_ID·YYYYMMDD | spdDetail에 해당 키의 출하 확정 상세가 표시된다 | `SpdMain_CellDoubleClick` > FindData_Detail / `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / SP SSP0015_GET_SHIPMENT_CONFIRM_DETAIL / 시트 `Shipment Confirm Detail` |
| TC-SSP0015-015 | 그리드 | Detail 활성 시트 = W/H stock | spdMain 셀을 더블클릭한다 | 위와 같음 | W/H 재고가 표시된다 | `SpdMain_CellDoubleClick` > FindData_WHstock / `SSP.SSP0015_GET_WH_STOCK` / 시트 `W/H stock` |
| TC-SSP0015-016 | 그리드 | Detail 활성 시트 = Stock Detail | spdMain 셀을 더블클릭한다 | 위와 같음 | MES 재고 LOT 목록이 표시된다 | `SpdMain_CellDoubleClick` > FindData_mes_stock / `SSP.SSP0015_GET_MES_STOCK` / 시트 `Stock Detail` |
| TC-SSP0015-017 | 그리드 | Detail 활성 시트 = Hold stock | spdMain 셀을 더블클릭한다 | 위와 같음 | Hold 재고가 표시된다 | `SpdMain_CellDoubleClick` > FindData_block_stock / `SSP.SSP0015_GET_BLOCK_STOCK` / 시트 `Hold stock` |
| TC-SSP0015-018 | 그리드 | Detail 활성 시트 = Stock Location Detail | spdMain 셀을 더블클릭한다 | 위와 같음 | 위치별 재고가 표시된다. NERP 코드 조회와 헤더 재구성이 일어난다 | `SpdMain_CellDoubleClick` > FindData_shtStockLocationDetail_btnSearch / `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` / 시트 `Stock Location Detail` |
| TC-SSP0015-019 | 그리드 | Detail 활성 시트 = SCS Stock Detail | spdMain 셀을 더블클릭한다 | 위와 같음 | SCS 재고가 표시된다 | `SpdMain_CellDoubleClick` > FindData_ScsStock_btnSearch / `SSP.SSP0015_GET_SCS_STOCK` / 시트 `SCS Stock Detail` |
| TC-SSP0015-020 | 조회 | Detail 활성 시트 = Shipment Confirm Detail(Mobility & IT 계열) | usrLayoutControl3에 조건을 넣고 btnSearch를 클릭한다 | drpPeriod2(Shipment Date), txtModel2, txtRequestor | 조건에 맞는 출하 확정 상세가 표시된다 | `BtnSearch_Click` > FindData_Detail_btnSearch / `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| TC-SSP0015-021 | 조회 | Detail = Shipment Confirm Detail, Main = Packer | btnSearch를 클릭한다 | 위와 같음 | Packer 출하 확정 상세가 표시된다 | `BtnSearch_Click` > FindData_Detail_Packer_btnSearch / `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` / SP SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER |
| TC-SSP0015-022 | 조회 | Detail = Shipment Request Detail | btnSearch를 클릭한다 | drpPeriod2 등 | 출하 요청 상세 34컬럼이 표시된다 | `BtnSearch_Click` > FindData_Request_Detail / `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / SP SSP0026_GET_REQUEST_DETAIL_PACK / 시트 `Shipment Request Detail` |
| TC-SSP0015-023 | 조회 | Detail = W/H stock | btnSearch를 클릭한다 | txtModel2 | W/H 재고가 표시된다 | `BtnSearch_Click` > FindData_WHstock / `SSP.SSP0015_GET_WH_STOCK` / SP SSP0015_GET_WH_STOCK |
| TC-SSP0015-024 | 조회 | Detail = Hold stock Detail | btnSearch를 클릭한다 | drpPeriod3(라벨 확인 필요) | Hold 재고 상세가 표시된다 | `BtnSearch_Click` > FindData_BolckStockDetail_btnSearch / `SSP.SSP0015_GET_BLOCK_STOCK` / SP SSP0015_GET_BLOCK_STOCK / 시트 `Hold stock Detail` |
| TC-SSP0015-025 | 조회 | Detail = Stock Location Detail | btnSearch를 클릭한다 | txtModel2 | 위치별 재고가 표시된다 | `BtnSearch_Click` > FindData_shtStockLocationDetail_btnSearch / `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` / SP SSP0015_GET_STOCK_LOCATION_DETAIL, SP SSP0002_GET_NERP_CODE |
| TC-SSP0015-026 | 조회 | Detail = SCS Stock Detail | btnSearch를 클릭한다 | txtModel2 | SCS 재고가 표시된다 | `BtnSearch_Click` > FindData_ScsStock_btnSearch / `SSP.SSP0015_GET_SCS_STOCK` / SP SSP0015_GET_SCS_STOCK |
| TC-SSP0015-027 | 조회 | Detail = Stock Detail | btnSearch를 클릭한다 | txtLotID(여러 줄 LOT) | 입력한 LOT의 MES 재고가 표시된다 | `BtnSearch_Click` > FindData_MesStock_btnSearch / `SSP.SSP0015_GET_MES_STOCK` / SP SSP0015_GET_MES_STOCK |
| TC-SSP0015-028 | 조회 | Detail = WH In Plan Detail(권한 행 존재) | btnSearch를 클릭한다 | drpPeriod2 | WH In 계획 코멘트가 표시된다 | `BtnSearch_Click` > FindData_WHinPlanDetail_btnSearch / `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` / SP SSP0015_GET_SHIPMENT_PSI_COMMENTS / 시트 `WH In Plan Detail` |
| TC-SSP0015-029 | 조회 | Detail = Shipment Result(Mobility & IT) | clbResultType을 선택하고 btnSearch를 클릭한다 | clbResultType, drpPeriod2 | 출하 실적 17컬럼이 표시된다. SHIP_TO와 SHIPTO_DESCRIPTION은 숨김 | `BtnSearch_Click` > FindData_ShipmentResult_btnSearch / `SSP.SSP0015_GET_SHIPMENT_RESULT` / SP SSP0015_GET_SHIPMENT_RESULT / 시트 `Shipment Result` |
| TC-SSP0015-030 | 조회 | Detail = Shipment Result, Main = Packer | btnSearch를 클릭한다 | 위와 같음 | SCS 출하 실적이 표시되고 헤더가 재구성된다 | `BtnSearch_Click` > FindData_ShipmentSCSResult_btnSearch / `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` / SP SSP0015_GET_SHIPMENT_RESULT_PACKER, SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| TC-SSP0015-031 | 조회(빈 결과) | Detail 임의 시트 | 데이터가 없는 조건으로 btnSearch를 클릭한다 | txtModel2=존재하지 않는 모델 | 0건 표시, 오류 없음 | `BtnSearch_Click` / `SSP.SSP0015_GET_SCS_STOCK` |
| TC-SSP0015-032 | 조회 | Detail = W/H stock Detail | btnSearch를 클릭한다 | – | AS-IS 동작과 같다(조회 엔드포인트 미추출 → 확인 필요) | `BtnSearch_Click` / 시트 `W/H stock Detail` |
| TC-SSP0015-033 | 이벤트 | 화면 로드 완료 | btnMeasure를 클릭하고 Measure를 바꾼다 | Measure 선택값(확인 필요) | spdMain 헤더가 다시 만들어진다 | `btnMeasure_Click` > InitSpread > GetSpdTitle / `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-034 | 이벤트 | TC-007 조회 완료 | cboBucketType=DAILY를 선택한다 | chkSum 해제 | D_ 컬럼 표시, M_ 컬럼 숨김. W_ 최종 표시는 AS-IS와 같다(2116과 2121 충돌, 확인 필요) | `cboBucketType_SelectedIndexChanged` / SetSpreadColumn 2116·2121 |
| TC-SSP0015-035 | 이벤트 | 위와 같음 | cboBucketType=WEEKLY를 선택한다 | chkSum 해제 | D_ 숨김, W_ 표시, M_ 숨김 | `cboBucketType_SelectedIndexChanged` / SetSpreadColumn 2128·2132·2137 |
| TC-SSP0015-036 | 이벤트 | 위와 같음 | cboBucketType=MONTHLY를 선택한다 | – | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged` / SetSpreadColumn 2144·2148 |
| TC-SSP0015-037 | 이벤트 | cboBucketType=WEEKLY | chkSum을 체크했다가 해제한다 | chkSum on/off | 체크하면 M_ 표시, 해제하면 M_ 숨김 | `chkSum_CheckedChanged` / SetSpreadColumn 2137 |
| TC-SSP0015-038 | 이벤트 | 화면 로드 완료 | clbDivision 값을 바꾼다 | 다른 Division | cboPlanDate 목록과 drpPeriod가 다시 계산된다 | `clbDivision_SelectedIndexChanged` > SetChangedControl > GetDayRange / `biz:CommonData.CommonDataList` [PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0015-039 | 이벤트 | 화면 로드 완료 | cboPlanDate 값을 바꾼다 | 다른 Plan-date | drpPeriod가 다시 계산된다 | `CboPlanDate_SelectedIndexChanged` > GetDayRange / `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0015-040 | 이벤트 | 화면 로드 완료 | spdMain 탭을 Shipment PSI(Packer)로 바꾼다 | – | LookupCommon 조회, 조회조건 재구성, 헤더 재구성. SO No 계열 컬럼 Width가 SetSoNoColumnVisible 규칙(80/0)을 따른다 | `SpdMain_ActiveSheetChanged` / `biz:CommonData.CommonDataList` [LookupCommon, PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-041 | 이벤트 | 화면 로드 완료 | btnItemId를 클릭한다 | – | AS-IS와 같은 Model 선택 동작(팝업 여부와 결과 반영 확인 필요). 선택 결과가 txtItemId에 반영된다 | `btnItemId_Click` |
| TC-SSP0015-042 | 이벤트 | 화면 로드 완료 | btnItemID2를 클릭한다 | – | AS-IS와 같은 Model 선택 동작. 결과가 txtModel2에 반영된다(확인 필요) | `BtnItemID2_Click` |
| TC-SSP0015-043 | 이벤트 | 화면 로드 완료 | btnRequestor를 클릭한다 | – | AS-IS와 같은 사용자 선택 동작. 결과가 txtRequestor에 반영된다(확인 필요) | `BtnRequestor_Click` |
| TC-SSP0015-044 | 그리드 | Shipment Confirm Detail 조회 완료, 편집 모드 | TRANSPORT_MODE 셀과 TO_SITE_SHIPTO_CODE 셀을 클릭한다 | – | Trans Mode 콤보(TransMode)와 Ship to 콤보(Division 기준)가 채워진다 | `SpdDetail_CellClick` / `biz:CommonData.CommonDataList` [TransMode, ShipToCodeByDivision] |
| TC-SSP0015-045 | 그리드 | 잠기지 않은 Detail 시트, 행 1개 이상 | 헤더 CheckBox(CHK(ALL))를 클릭한다 | – | 8618줄 분기대로 헤더 Value=false가 설정되고, 행 체크는 AS-IS와 같다 | `SpdDetail_CellClick` (IsLock=false 분기) |
| TC-SSP0015-046 | 그리드 | 잠긴 Detail 시트, 행 1개 이상 | 헤더 CheckBox를 두 번 클릭한다 | – | true→false(8653), false→true(8657)로 토글된다 | `SpdDetail_CellClick` (IsLock 분기) |
| TC-SSP0015-047 | 그리드 | Detail 콤보 셀 존재 | 콤보 값을 선택한다 | Trans Mode 값 | AS-IS와 같은 후속 처리(확인 필요) | `spdDetail_ComboSelChange` |
| TC-SSP0015-048 | 그리드 | 화면 로드 완료 | spdDetail 시트 탭을 클릭한다 | Hold stock 탭 | AS-IS와 같은 탭 전환 처리(확인 필요) | `SpdDetail_SheetTabClick` / 시트 `Hold stock` |
| TC-SSP0015-049 | 그리드 | Detail 데이터 존재 | spdDetail 셀을 더블클릭한다 | – | AS-IS와 같은 동작(확인 필요) | `SpdDetail_CellDoubleClick` |
| TC-SSP0015-050 | 그리드 | 화면 로드 완료 | spdDetail 활성 시트를 Shipment Result로 바꾼다 | – | 하단 조회조건(clbResultType 등)의 표시와 활성 상태가 AS-IS와 같다(확인 필요) | `SpdDetail_ActiveSheetChanged` / 시트 `Shipment Result` |
| TC-SSP0015-051 | 그리드 | 편집 모드, Shipment Confirm Detail | SHIPMENT_CONFIRM_QTY 셀을 편집한다 | 수량 변경 | AS-IS와 같은 편집 처리(행 상태·연동 값 확인 필요) | `SpdDetail_EditChange` |
| TC-SSP0015-052 | 그리드 | 편집 모드, Shipment Confirm Detail | Excel에서 여러 행을 복사해 TRANSPORT_MODE 열에 붙여넣는다 | 유효·무효 Trans Mode 코드 혼합 | TransMode 코드(CODE)와 대조한 결과가 AS-IS와 같다 | `SpdDetail_ClipboardPasted` / `biz:CommonData.CommonDataList` [TransMode] |
| TC-SSP0015-053 | 그리드 | 조회 완료 | spdMain 셀 편집을 시작한다 | – | 편집 가능·불가 셀 처리가 AS-IS와 같다(확인 필요) | `SpdMain_EditModeOn` |
| TC-SSP0015-054 | 그리드 | 조회 완료 | spdMain 셀을 클릭한다 | – | AS-IS와 같은 동작(확인 필요) | `SpdMain_CellClick` |
| TC-SSP0015-055 | 그리드 | Detail 데이터 존재 | Detail 바인딩 데이터를 변경한다 | – | 변경 감지 처리가 AS-IS와 같다(확인 필요) | `shtDetail_Change` (dsdm.Changed) / 시트 `Shipment Confirm Detail` |
| TC-SSP0015-056 | 그리드 | 조회 완료 | spdMain 셀에 마우스를 올린다 | – | 툴팁 내용이 AS-IS와 같다(확인 필요) | `spdMain_TextTipFetch` |
| TC-SSP0015-057 | 그리드 | 조회 완료(행이 많음) | spdMain을 세로 스크롤한다 | – | spdDetail 연동 여부가 AS-IS와 같다(확인 필요) | `SpdMain_TopChange` |
| TC-SSP0015-058 | 그리드 | Detail 행이 많음 | spdDetail을 세로 스크롤한다 | – | AS-IS와 같다(확인 필요) | `SpdDetail_TopChange` |
| TC-SSP0015-059 | 이벤트 | 코멘트 팝업 열림 | txtGap_Qty 값을 바꾼다 | 숫자 | 연동 계산이 AS-IS와 같다(확인 필요) | `txtGap_Qty_TextChanged` |
| TC-SSP0015-060 | 이벤트 | 위와 같음 | txtBefore_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtBefore_Qty_TextChanged` |
| TC-SSP0015-061 | 이벤트 | 위와 같음 | txtProd_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtProd_Qty_TextChanged` |
| TC-SSP0015-062 | 이벤트 | 위와 같음 | txtWHin_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtWHin_Qty_TextChanged` |
| TC-SSP0015-063 | 이벤트 | 위와 같음 | txtCurrent_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtCurrent_Qty_TextChanged` |
| TC-SSP0015-064 | 이벤트 | 위와 같음 | txtChange_Qty 값을 바꾼다 | 숫자 | 위와 같음 | `txtChange_Qty_TextChanged` |
| TC-SSP0015-065 | 이벤트 | 위와 같음 | txtChange_Qty에 숫자가 아닌 문자를 입력한다 | `a`, `-`, `.` | 허용 문자 규칙이 AS-IS와 같다(확인 필요) | `txtChange_Qty_KeyPress` |
| TC-SSP0015-066 | 저장 | 코멘트 팝업 열림, rtxComments 입력 | btnButtonList의 저장 버튼을 클릭한다 | 코멘트 텍스트, txtChange_Qty | SSP_ANL_SHIP_PLAN_40·WH_IN_CMT가 갱신되고 _H 이력이 INSERT된다 | `btnButtonList_UsrButtonList_Click_Detected` > SaveData / `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` / SP SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |
| TC-SSP0015-067 | 저장(오류) | 위와 같음, DB 오류 유도 | 저장을 클릭한다 | – | 오류 메시지가 표시되고 부분 반영이 없다(트랜잭션 처리 확인 필요) | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` |
| TC-SSP0015-068 | 권한 | 편집 권한 사용자 / 비권한 사용자 | 편집(EditButton)을 클릭한다 | 두 계정 | 권한 사용자는 편집 모드로 들어간다. 비권한 사용자는 AS-IS와 같이 처리된다(기준 확인 필요) | EditButton > GetSSPUserCheck / `SSP.SSP0002_GET_USER_INFO_LIST` / SP SSP0002_GET_USER_INFO_LIST / `biz:CommonData.CommonDataList` [PlanDateShip] |
| TC-SSP0015-069 | 저장 | 편집 모드, Main(Mobility & IT) 값 변경 | 저장(SaveButton)을 클릭한다 | WH In 수량·코멘트 | SSP_ANL_SHIP_PLAN_40과 WH_IN_CMT가 갱신되고 _H 이력이 생긴다 | SaveButton > SaveData_Main / `SSP.SSP0015_SAVE_SHIPMENT_PSI` / SP SSP0015_SAVE_SHIPMENT_PSI |
| TC-SSP0015-070 | 저장 | 편집 모드, Shipment Confirm Detail(Mobility & IT) 행 수정 | 저장을 클릭한다 | SHIPMENT_CONFIRM_QTY, SHIPMENT_DATE, TRANSPORT_MODE, REMARKS2, REMARKS, TO_SITE_SHIPTO_CODE | 확정이 저장되고 spdMain과 spdDetail이 다시 조회된다 | SaveButton > SaveData_Detail / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 / 재조회 `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| TC-SSP0015-071 | 저장(검증) | TC-070과 같음 | 필수 후보 값을 비우고 저장한다 | shipment_date 빈값 / TRANSPORT_MODE 빈값 각각 | Validation_Check가 AS-IS와 같이 차단하거나 경고한다(조건·문구 확인 필요) | SaveData_Detail > Validation_Check / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |
| TC-SSP0015-072 | 저장 | 편집 모드, Hold stock 행 추가·수정 | 저장을 클릭한다 | HOLD_QTY(Amend Qty*), RELEASE_YYYYMMDD(End Date*) | SSP_ANL_HOLD_STOCK이 UPDATE 또는 INSERT된다 | SaveButton > SaveData_Detail / `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` / SP SSP0015_SAVE_BLOCK_STOCK_DATA / 시트 `Hold stock` |
| TC-SSP0015-073 | 저장 | 편집 모드, Stock Detail 행 수정 | 저장을 클릭한다 | USER_MOD_RELEASE_DATE | SSP_ANL_MES_FCS_STOCK_40_C와 SSP_ANL_SHIP_PLAN_40이 MERGE된다. Stock Detail이 다시 조회된다 | SaveButton > SaveData_Detail(6112/6219) / `SSP.SSP0015_SAVE_MES_STOCK` / SP SSP0015_SAVE_MES_STOCK / 재조회 `SSP.SSP0015_GET_MES_STOCK` |
| TC-SSP0015-074 | 저장 | 편집 모드, Packer Shipment Confirm Detail 수정 | 저장을 클릭한다 | 수정 행 | SCS Confirm ID 점검(CNT)이 수행된다. 판정 결과에 따른 진행·차단은 AS-IS와 같다 | SaveData_Detail_Packer > chkSaveYN / `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` / SP SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| TC-SSP0015-075 | 저장 | 위와 같음, 계획 처리 중 상태 | 저장을 클릭한다 | – | 계획 진행 점검 결과에 따른 처리가 AS-IS와 같다(차단 조건 확인 필요) | SaveData_Detail_Packer > EngProcessingChk / `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` / SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| TC-SSP0015-076 | 저장 | 위와 같음, 점검 통과 | 저장을 클릭한다 | – | SSP_ANL_SHIP_CONFIRM(_H), XIF_ERP_PACK_SHIP_PLAN_S_SN, XIF_SCS_PACK_SHIP_PLAN_S_SN에 반영된다. Confirm Detail이 다시 조회된다 | SaveData_Detail_Packer / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` / SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER / 재조회 `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-077 | 저장 | 변경 요청(CHG_REQ_DE) 존재 행 | 저장을 클릭한다 | – | 변경 시각 점검 결과에 따른 처리가 AS-IS와 같다 | GetERPInterface > ChkConfirmChangeTime / `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` / SP SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| TC-SSP0015-078 | 저장 | SO No가 있는 확정 행 | 저장을 클릭한다 | – | SO No 건수(CNT)에 따른 분기가 AS-IS와 같다 | GetERPInterface > GetErpSoNoCnt / `SSP.SSP0015_GET_ERP_SO_NO_CNT` / SP SSP0015_GET_ERP_SO_NO_CNT |
| TC-SSP0015-079 | 저장 | 출하 상태 점검 대상 행 | 저장을 클릭한다 | – | Tables[0~2]의 CONFIRM_ID 결과에 따른 처리가 AS-IS와 같다 | GetERPInterface > GetShipmentStatusChk / `SSP.SSP0015_GET_SHIPMENT_STATUS` / SP SSP0015_GET_SHIPMENT_STATUS |
| TC-SSP0015-080 | 저장 | ERP 오류 확인 대상 행 | 저장을 클릭한다 | – | SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT와 CHG_REQ(_DE) UPDATE가 AS-IS와 같다 | GetERPInterface(6665) / `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` / SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| TC-SSP0015-081 | 저장 | 기안 삭제 대상 확정 행 | 저장을 클릭한다 | – | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT가 AS-IS와 같다 | GetERPInterface(6706), SoNo > GetErpIFCheckNew(7363) / `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` / SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| TC-SSP0015-082 | 저장 | SO No 없는 행(NonSoNo 분기, 조건 확인 필요) | 저장을 클릭한다 | – | CHG_REQ와 CHG_REQ_DE INSERT, I/F INSERT가 AS-IS와 같다 | GetERPInterface > NonSoNo(6843/6847) / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` |
| TC-SSP0015-083 | 저장 | SO No 있는 행(SoNo 분기) | 저장을 클릭한다 | – | 기안 저장이 AS-IS와 같다 | GetERPInterface > SoNo(7076/7080) / SP SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING, SP SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| TC-SSP0015-084 | 저장 | SoNo 분기, 변경 배치 대상 | 저장을 클릭한다 | – | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT와 CHG_REQ_DE UPDATE가 AS-IS와 같다 | SoNo > GetErpIFCheckNew(7389/7419) / `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` / SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| TC-SSP0015-085 | 저장(오류) | Packer 저장 중 SP 오류 유도 | 저장을 클릭한다 | – | 오류 메시지가 표시되고 이후 단계로 진행하지 않는다(롤백 범위 확인 필요) | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` |
| TC-SSP0015-086 | 저장 | ERP I/F Block 데이터 존재 | 저장을 클릭한다 | BLOCK_YN=Y, PERIOD | Block 처리가 AS-IS와 같다(데이터 원천 확인 필요) | chkERPIFBlockYn (BLOCK_YN, PERIOD) |
| TC-SSP0015-087 | 그리드 | TC-007 조회 완료 | `Shipment PSI(Mobility & IT)` 컬럼을 확인한다 | – | 표시 10개(Div·Figure·From Site·Model·Aging L/T·Measure·Nick Name·PSI·TYPE·Yield(%)), 숨김 7개, MergePolicy.Always | 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-088 | 그리드 | TC-009 조회 완료 | `Shipment PSI(Packer)` 컬럼을 확인한다 | – | 표시 8개(Div·Figure·From Site·Model·Measure·Nick Name·PSI·TYPE), 숨김 9개 | 시트 `Shipment PSI(Packer)` |
| TC-SSP0015-089 | 그리드 | 화면 로드 완료 | 메타 전용 시트 `Shipment PSI(IT & Mobile)`가 있는지 확인한다 | – | 코드가 AddSheet하지 않으므로 탭이 없다(TO-BE 포함 여부 확인 필요) | 시트 `Shipment PSI(IT & Mobile)` |
| TC-SSP0015-090 | 그리드 | TC-014 조회 완료 | `Shipment Confirm Detail` 컬럼을 확인한다 | – | 표시 40개(설계서 §4 (4)), SHIPTO_DESCRIPTION 숨김 | 시트 `Shipment Confirm Detail` |
| TC-SSP0015-091 | 그리드 | TC-022 조회 완료 | `Shipment Request Detail` 컬럼을 확인한다 | – | 표시 34개. `*` 라벨 10개가 원문과 같다 | 시트 `Shipment Request Detail` |
| TC-SSP0015-092 | 그리드 | TC-023 조회 완료 | `W/H stock` 컬럼을 확인한다 | – | 메타 19개와 일치(컬럼 상세 확인 필요) | 시트 `W/H stock` |
| TC-SSP0015-093 | 그리드 | 화면 로드 완료 | `W/H stock Detail` 컬럼을 확인한다 | – | 메타 25개와 일치(컬럼 상세 확인 필요) | 시트 `W/H stock Detail` |
| TC-SSP0015-094 | 그리드 | TC-017 조회 완료 | `Hold stock` 컬럼을 확인한다 | – | 표시 10개. Amend Qty*, End Date* | 시트 `Hold stock` |
| TC-SSP0015-095 | 그리드 | TC-024 조회 완료 | `Hold stock Detail` 컬럼을 확인한다 | – | 표시 10개. Amend Qty, End Date(`*` 없음) | 시트 `Hold stock Detail` |
| TC-SSP0015-096 | 그리드 | TC-016 조회 완료 | `Stock Detail` 컬럼을 확인한다 | – | 메타 26개(USER_MOD_RELEASE_DATE = User Modified Release Date*) | 시트 `Stock Detail` |
| TC-SSP0015-097 | 그리드 | 화면 로드 완료 | 메타 전용 시트 `MES Stock Detail`이 있는지 확인한다 | – | 코드 미참조라 탭이 없다(TO-BE 포함 여부 확인 필요) | 시트 `MES Stock Detail` |
| TC-SSP0015-098 | 그리드 | TC-019 조회 완료 | `SCS Stock Detail` 컬럼을 확인한다 | – | 표시 9개 | 시트 `SCS Stock Detail` |
| TC-SSP0015-099 | 그리드 | TC-018 조회 완료 | `Stock Location Detail` 컬럼을 확인한다 | – | 메타 20개(확인된 6개 포함, 나머지 확인 필요) | 시트 `Stock Location Detail` |
| TC-SSP0015-100 | 그리드 | TC-028 조회 완료 | `WH In Plan Detail` 컬럼을 확인한다 | – | 메타 11개와 일치(상세 확인 필요) | 시트 `WH In Plan Detail` |
| TC-SSP0015-101 | 그리드 | TC-029 조회 완료 | `Shipment Result` 컬럼을 확인한다 | – | 표시 17개. Ship to와 Ship to Name 숨김 | 시트 `Shipment Result` |
| TC-SSP0015-102 | 그리드 | 날짜 헤더가 토·일을 포함하는 Period | 조회 후 날짜 헤더를 확인한다 | 주말 포함 기간 | SAT 컬럼은 Blue, SUN 컬럼은 Red. `B_` 컬럼은 숨김 | InitSpreadDateColumn 1110·1114·1118 / `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-103 | division | 14개 division 계정(또는 Division 선택) | Division을 하나씩 바꿔 각 시트 컬럼 수를 확인한다 | 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC | 모든 division에서 시트별 표시 컬럼 수가 같다(예: Shipment Confirm Detail 40, Shipment Result 17) | grid_effective / 시트 `Shipment Confirm Detail`, `Shipment Result` |
| TC-SSP0015-104 | division | Division A와 B의 Ship to 데이터가 다름 | Shipment Confirm Detail에서 TO_SITE_SHIPTO_CODE 콤보를 연다 | Division A / B | 콤보 목록이 division별로 다르게 조회된다 | `SpdDetail_CellClick` / `biz:CommonData.CommonDataList` [ShipToCodeByDivision] |
| TC-SSP0015-105 | 권한 | 프로그램 권한 행(drPgmAuthId) 없는 사용자 | 화면을 연다 | – | spdDetail에 `WH In Plan Detail` 탭이 생성되지 않는다 | CreateSpread:680 `if(drPgmAuthId != null)` / 시트 `WH In Plan Detail` |
| TC-SSP0015-106 | 권한 | TB_FX_GroupMenuAuth의 그룹별 권한(14행) | 그룹별 계정으로 조회·편집·저장 버튼 활성 상태를 확인한다 | 그룹 계정 | 버튼 활성 상태가 메뉴 권한과 같다(권한 값 확인 필요) | FindButton / EditButton / SaveButton |
| TC-SSP0015-107 | 회귀(미연결) | 화면 전 기능 수행 | 조회·저장·팝업 전체 시나리오를 수행하며 호출 로그를 확인한다 | – | 진입점 미연결 엔드포인트가 호출되지 않는다(사용 여부 확정 전 확인 필요) | unreached: GetErpIFCheck, GetErpIFCheckNew_ / `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` / SP SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0015-108 | 회귀(미연결) | 위와 같음 | 위와 같음 | – | 위와 같음 | unreached: SCM_SYS_LOG_BATCH / `SCP.PR_SCM_SYS_LOG_BATCH` / SP PR_SCM_SYS_LOG_BATCH |
| TC-SSP0015-109 | 회귀(미연결) | 위와 같음 | 위와 같음 | – | 위와 같음. Division 목록은 GetDivision이 아닌 경로로 채워진다(확인 필요) | unreached: GetDivision / `SCM.SCM0001_GET_DIVISION` / SP SCM0001_GET_DIVISION |
| TC-SSP0015-110 | 회귀(미연결) | 위와 같음 | 위와 같음 | – | CommonDataList code=PERIOD_*, PERIOD2_*와 NewNonSoNo 경로가 호출되지 않는다 | unreached: SetChangedPeriod, NewNonSoNo / `biz:CommonData.CommonDataList` [PERIOD_{p:value}, PERIOD2_{p:value}] |

### 커버리지 점검
| 대상 | 건수 | 커버 TC |
|---|---:|---|
| 이벤트 핸들러 | 33 / 33 | 001~006, 014~058(시트·이벤트), 059~066 |
| 엔드포인트 | 39 / 39 | `biz:CommonData.CommonDataList`(001, 038, 040, 044, 052, 068, 104, 110), DM0003(002), SCM0001_GET_SCP_DAY_PERIOD(003), SCP0009(004, 033), PSI 3종(007, 009, 010), NERP(008), CONFIRM_DETAIL(014, 020), _PACKER(021), WH_STOCK(015, 023), MES_STOCK(016, 027), BLOCK_STOCK(017, 024), STOCK_LOCATION(018, 025), SCS_STOCK(019, 026), SSP0026(022), PSI_COMMENTS(028), RESULT(029), RESULT_PACKER(030), SAVE_PSI_COMMENTS(066), USER_INFO_LIST(068), SAVE_SHIPMENT_PSI(069), CONFIRM_40(070), BLOCK_STOCK_DATA(072), SAVE_MES_STOCK(073), SSP0202(074), SSP0003(075), CONFIRM_PACKER(076), CHANGETIME(077), ERP_SO_NO_CNT(078), SHIPMENT_STATUS(079), ERP_ERROR_CONFIRM(080), DELETE_BY_CONFIRM(081), DRAFTING 2종(082, 083), CHG_BATCH(084), DELETE_DRAFTING(107), PR_SCM_SYS_LOG_BATCH(108), SCM0001_GET_DIVISION(109) |
| 시트 | 15 / 15 | 087~101 |
| division | 14 div 공통 1건 + division 의존 콤보 1건 | 103, 104 |
| 빈 결과·오류 | 6건 | 011, 012, 031, 067, 085 (+013 검증) |
