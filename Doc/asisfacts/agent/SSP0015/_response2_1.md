=== FILE: business_analysis.md ===
# SSP0015 Shipment PSI — 업무분석서

> 이 문서는 AsisFacts 정적 추출 결과(Fact Pack)와 1차 분석서(analysis.md / web_components.md / tobe_design.md)만 근거로 작성했습니다.
> Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다. 업무 규칙을 추측해서 만들지 않았습니다.
> 주석 처리된 호출 4건(줄 3573 / 9288 / 9308 / 9309)은 현행 기능에서 뺐습니다.
> 엔드포인트 이름은 화면설계서 §5(액션 명세), 단위테스트 '근거' 열과 똑같이 씁니다.

## 1. 업무 목적·범위

### 1-1. 목적(사실 근거)
| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SSP0015 | 파일명 `SSP0015_ShipmentPSI` |
| 화면명 | Shipment PSI (파일명에서 가져옴. 메뉴 표시명은 확인 필요) | `SSP0015_ShipmentPSI.cs` |
| 도메인 | SSP | 프로젝트 경로 `06.UIL\GSCM.SSP.Forms.UIL\Plan\…` |
| 업무 대상 | 출하(Shipment) 계획 PSI 조회. 출하 요청·확정 상세, 창고/MES/SCS/Hold 재고, 출하 실적 조회. 출하 확정·재고·Comments 저장 | 엔드포인트 목록 §5 |
| 업무 목적 서술 | Fact Pack에 업무 목적 문구가 없음 → **확인 필요** | — |

### 1-2. 범위
| 구분 | 포함 내용 |
|---|---|
| 메인 화면 | `SSP0015_ShipmentPSI`: 상단 조회조건, 상단 Grid `spdMain`(시트 2개), 하단 Detail 조회 바, 하단 Grid `spdDetail`(시트 11개) |
| 팝업 | `SSP0015_ShipmentPSICommentsPopup`: Comments 입력·저장 |
| 엔드포인트 | 39종. FoxQuery 38종 + `biz:CommonData.CommonDataList`(코드 6종: PlanDateShip / LookupCommon / TransMode / ShipToCodeByDivision / PERIOD_{p:value} / PERIOD2_{p:value}) |
| 진입점 미연결 엔드포인트 | 정적 추적으로 호출부를 찾지 못한 것 3종: `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SCP.PR_SCM_SYS_LOG_BATCH`, `SCM.SCM0001_GET_DIVISION`. biz 코드 2종도 미연결: PERIOD_{p:value}, PERIOD2_{p:value}. 범위에는 넣되 런타임에서 실제로 쓰는지 **확인 필요** |
| 제외 | 주석 처리된 호출 4건. 구버전 사본(legacy) `06.UIL\GSCM.SSP.Plan.UIL\…` |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 > 메서드 > 엔드포인트) | 결과 |
|---:|---|---|---|
| S1 | 화면을 연다 | `Form_Load` > InitControls > `biz:CommonData.CommonDataList` [code=PlanDateShip] / GetBucketType > `DM.DM0003_GET_BUCKET_TYPE_CODE` / SetChangedControl > PlanDateShip / GetDayRange > `SCP.SCM0001_GET_SCP_DAY_PERIOD` / CreateSpread > InitSpread > GetSpdTitle > `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | Plan-date·Bucket 콤보와 Period 기본값이 채워짐. 상·하단 Grid 시트와 일자 컬럼이 만들어짐 |
| S2 | Division을 바꾼다 | `clbDivision_SelectedIndexChanged` > SetChangedControl > `biz:CommonData.CommonDataList` [PlanDateShip] > GetDayRange > `SCP.SCM0001_GET_SCP_DAY_PERIOD` | Plan-date 목록과 Period 다시 설정 |
| S3 | Plan-date를 바꾼다 | `CboPlanDate_SelectedIndexChanged` > GetDayRange > `SCP.SCM0001_GET_SCP_DAY_PERIOD` | Period 다시 설정 |
| S4 | 상단 시트를 바꾼다 (Mobility & IT ↔ Packer) | `SpdMain_ActiveSheetChanged` > `biz:CommonData.CommonDataList` [LookupCommon] (1400/1452) > SetChangedControl(PlanDateShip, GetDayRange) > InitSpread > GetSpdTitle > `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 조회조건과 시트 헤더 다시 구성 |
| S5 | Bucket을 바꾼다 / Sum을 체크한다 | `cboBucketType_SelectedIndexChanged` / `chkSum_CheckedChanged` (엔드포인트 호출 없음). SetSpreadColumn(2116~2148)이 D_/W_/M_ 컬럼 Visible 결정 | 일자/주/월 컬럼 표시 전환 |
| S6 | Measure 버튼을 누른다 | `btnMeasure_Click` > InitSpread > GetSpdTitle > `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | Grid 다시 구성 (Measure 선택 팝업이 있는지는 확인 필요) |
| S7 | 조회(툴바 Find) | FindButton > FindData_Main > `SSP.SSP0015_GET_SHIPMENT_PSI` / FindData_Main_Packer > `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` / FindData_Main_Packer_Past > `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` (+ Re_Design > GetNERPCode > `SSP.SSP0002_GET_NERP_CODE`, InitSpread > `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) | 상단 PSI Grid 조회. 세 메서드 중 무엇을 고르는지는 **확인 필요** |
| S8 | 상단 셀을 더블클릭한다 | `SpdMain_CellDoubleClick` > FindData_Detail(`SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`) / FindData_WHstock(`SSP.SSP0015_GET_WH_STOCK`) / FindData_mes_stock(`SSP.SSP0015_GET_MES_STOCK`) / FindData_block_stock(`SSP.SSP0015_GET_BLOCK_STOCK`) / FindData_shtStockLocationDetail_btnSearch(`SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` + `SSP.SSP0002_GET_NERP_CODE` + `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) / FindData_ScsStock_btnSearch(`SSP.SSP0015_GET_SCS_STOCK`) / FindData_Main(`SSP.SSP0015_GET_SHIPMENT_PSI`) | 클릭한 행의 DIVISION_ID / SITE / ITEM_ID / YYYYMMDD 기준으로 하단 Detail을 조회. Comments(GAP / BEFORE_QTY / USER_ADD_QTY)를 읽음. 셀별 분기는 **확인 필요** |
| S9 | 하단 조회 바에서 Search를 누른다 | `BtnSearch_Click` > 활성 Detail 시트별 FindData_* (§5 참조) | 하단 Detail 시트 조회 |
| S10 | 하단 셀을 클릭한다 | `SpdDetail_CellClick` > `biz:CommonData.CommonDataList` [TransMode] (8583), [ShipToCodeByDivision] (8604). 컬럼헤더 CheckBox 토글 (8618~8657) | 셀 콤보 목록 채움. 전체 선택/해제 |
| S11 | 하단에 붙여넣기 | `SpdDetail_ClipboardPasted` > `biz:CommonData.CommonDataList` [TransMode] (8954), c["CODE"] 사용 | 붙여넣은 Trans Mode 값을 코드 목록과 대조 (상세 처리는 확인 필요) |
| S12 | 편집(툴바 Edit) | EditButton > `biz:CommonData.CommonDataList` [PlanDateShip] (1753/1757) > GetSSPUserCheck > `SSP.SSP0002_GET_USER_INFO_LIST` | 사용자/그룹 정보 확인 뒤 편집 진입 (판정 기준은 확인 필요) |
| S13 | 저장 — 상단 PSI | SaveButton > SaveData_Main > `SSP.SSP0015_SAVE_SHIPMENT_PSI` | SSP_ANL_SHIP_PLAN_40 / _WH_IN_CMT 갱신과 이력 기록 |
| S14 | 저장 — Detail(40 계열) | SaveButton > SaveData_Detail > (Validation_Check) > `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` / `SSP.SSP0015_SAVE_MES_STOCK` → 재조회 `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0002_GET_NERP_CODE` | 출하 확정 / Hold 재고 / MES 재고 저장 후 재조회 |
| S15 | 저장 — Detail(Packer) | SaveButton > SaveData_Detail_Packer > chkSaveYN(`SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`) > EngProcessingChk(`SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`) > `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` > GetERPInterface{`SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0015_GET_ERP_SO_NO_CNT`, `SSP.SSP0015_GET_SHIPMENT_STATUS`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, SoNo/NonSoNo → `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER`, GetErpIFCheckNew → `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`} → 재조회 `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` (+ `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`) | Packer 출하 확정과 ERP/SCS 인터페이스 적재. 호출 순서는 **확인 필요** |
| S16 | Comments 팝업에서 저장 | `btnButtonList_UsrButtonList_Click_Detected` > SaveData > `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | SSP_ANL_SHIP_PLAN_40 / _WH_IN_CMT 갱신과 이력 기록 |

> 팝업을 여는 코드(SpdMain_CellDoubleClick / TsmNotepad_Click 에서 여는 것으로 보임)는 Fact Pack에 없음 → **확인 필요**.

## 3. 업무 흐름도 (텍스트)

```
[1] 화면 진입 (Form_Load)
    ├─ PlanDateShip 공통코드 → cboPlanDate
    ├─ DM0003_GET_BUCKET_TYPE_CODE → cboBucketType
    ├─ SCM0001_GET_SCP_DAY_PERIOD → drpPeriod 기본 기간
    └─ SCP0009_GET_SHEET_CALENDAR_3SPAN → spdMain 일자 컬럼(3단 헤더 + SUM)
        │
[2] 조회조건 조정
    ├─ Division 변경 → PlanDateShip 재조회 → DayRange
    ├─ Plan-date 변경 → DayRange
    ├─ 상단 시트 전환 → LookupCommon → PlanDateShip → DayRange → 헤더 재구성
    └─ Bucket / Sum → D_/W_/M_ 컬럼 표시 전환 (DB 호출 없음)
        │
[3] 조회 (FindButton)
    └─ SSP0015_GET_SHIPMENT_PSI | _PACKER | _PACKER_PAST  (분기 조건 확인 필요)
        │
[4] 상세 확인
    ├─ 상단 셀 더블클릭 → Confirm Detail / W/H stock / Stock Detail / Hold stock / Stock Location / SCS Stock 조회
    └─ 하단 Search → 활성 시트별 조회 (Request Detail, WH In Plan Detail, Shipment Result 포함)
        │
[5] 편집 (EditButton) → SSP0002_GET_USER_INFO_LIST 사용자 확인
        │
[6] 저장 (SaveButton)
    ├─ 상단 PSI → SSP0015_SAVE_SHIPMENT_PSI
    ├─ Detail(40) → Validation_Check → CONFIRM_40 / BLOCK_STOCK_DATA / MES_STOCK → 재조회
    └─ Detail(Packer) → SCS ID 체크 → 계획 진행 체크 → CONFIRM_PACKER → ERP 인터페이스(변경시각 체크, SO 건수, 상태, 오류확인, 삭제, Drafting, CHG_BATCH) → 재조회
        │
[7] Comments 팝업 저장 → SSP0015_SAVE_SHIPMENT_PSI_COMMENTS
```

## 4. 업무 규칙 (사실 근거만)

| ID | 규칙 | 근거 (메서드:줄) |
|---|---|---|
| BR-01 | Bucket=DAILY: Tag가 `D_`·`W_`로 시작하는 컬럼은 Visible=true. `M_`·`W_` 계열 Sum은 Visible=chkSum.Checked | SetSpreadColumn:2116, 2121 |
| BR-02 | Bucket=WEEKLY: `D_` 컬럼 Visible=false, `W_` 컬럼 Visible=true, `M_` 컬럼 Visible=chkSum.Checked | SetSpreadColumn:2128, 2132, 2137 |
| BR-03 | Bucket=MONTHLY: `D_`·`W_` 컬럼 Visible=false, `M_` 컬럼 Visible=true | SetSpreadColumn:2144, 2148 |
| BR-04 | 일자 컬럼은 `SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과를 행 단위로 돌며 만든다. 컬럼명에 `B_`가 있으면 Text 컬럼(너비 0, 비표시), 없으면 Num 컬럼(너비 70) | InitSpreadDateColumn:1110, 1114 |
| BR-05 | DAY_CODE가 SAT이면 글자색 파랑, SUN이면 빨강 | InitSpreadDateColumn:1118 |
| BR-06 | 일자 헤더는 LARGE_CLASS_LABEL_NAME / SMALL_CLASS_LABEL_NAME 기준 3단 ColumnHeaderSpan이며 "SUM" 소계 헤더를 붙인다 | InitSpreadDateColumn:1125~1154 (1차 분석서) |
| BR-07 | 시트 `Shipment PSI(Mobility & IT)`, `Shipment PSI(Packer)`는 MergePolicy.Always | InitSpread:776/778, 803/805 |
| BR-08 | `ichkbtn==1`이면 `Shipment PSI(Packer)` 시트에서 Width 80, 다른 시트는 0. 아니면 반대(0 / 80). 대상 컬럼명은 확인 필요(SO No 계열로 보이나 미확인) | SetSoNoColumnVisible:9778~9793 |
| BR-09 | `WH In Plan Detail` 시트는 `drPgmAuthId != null`일 때만 만든다 | CreateSpread:680 |
| BR-10 | 하단 시트가 잠겨 있지 않고(`IsLock==false`) 행이 1개 이상일 때, 컬럼헤더 CheckBox를 누르면 값을 토글한다(true→false, false→true) | SpdDetail_CellClick:8618, 8653, 8657 |
| BR-11 | Shipment Result 조회 시 SHIP_TO, SHIPTO_DESCRIPTION 컬럼 Visible=false | FindData_ShipmentResult_btnSearch:4991, 4992 |
| BR-12 | Confirm Detail 조회 시 일부 컬럼 Visible=false (대상 컬럼명 미추출 → 확인 필요) | FindData_Detail:3218~3221, 3356~3359 / FindData_Detail_Packer_btnSearch:3491~3493 / FindData_Detail_btnSearch:3758~3761 |
| BR-13 | Detail 저장 검증 `Validation_Check`는 confirm_id 기준으로 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE를 확인한다. SO No 유무에 따라 Validationdr / SONoValidationdr 두 세트가 있음. 판정 조건과 메시지는 **확인 필요** | Validation_Check |
| BR-14 | Packer 저장 전 `SSP0202_GET_SCS_CONFIRM_ID_CHECK` 결과 Tables[0], Tables[1]의 CNT를 판정에 쓴다(판정 기준값은 확인 필요) | chkSaveYN:9821 |
| BR-15 | ERP 인터페이스 단계에서 `SSP0015_GET_ERP_SO_NO_CNT` 결과의 CNT, `SSP0015_GET_SHIPMENT_STATUS` 결과 Tables[0..2]의 CONFIRM_ID를 쓴다(판정 기준은 확인 필요) | GetErpSoNoCnt:7185, GetShipmentStatusChk:7210 |
| BR-16 | ERP I/F 차단 여부는 dtERPBlockYnIF.Rows[0]의 BLOCK_YN, PERIOD로 판정한다. 데이터 원천 엔드포인트는 미추출 → **확인 필요** | chkERPIFBlockYn |
| BR-17 | 출하 입력 기간 초기값은 dtShipmentInputPeriod.Rows[0..1]의 VALUE, Diff_VALUE를 쓴다. 회사는 dtCompany.Rows[0].COMPANY_ID | InitControls |
| BR-18 | NERP 코드는 `SSP0002_GET_NERP_CODE` 결과 Rows[0].SEGMENT2 | GetNERPCode:2904 |
| BR-19 | 조회조건 원천: SetChangeControl이 GetSSPInnerTable을 8번 호출(456~491). CODE / COMPANY_ID / DEPT_ID / DIVISION_ID / END_CUSTOMER / LANGUAGE_CODE / NAME / PLANT_ID / SCM_SITE_ID를 쓰고 GROUP_ID / USER_ID / NowGroupID로 거른다 | SetChangeControl, §6-2 |
| BR-20 | 필수 조회조건(라벨 `*`): `Division*`, `Plan-date*`, `Period*`. 필수값 검증 코드는 Fact Pack에 없음 → 확인 필요 | props Text (web_components §2-1) |
| BR-21 | Bucket 코드값은 DAILY / WEEKLY / MONTHLY (`cboBucketType.ControlValues` 비교 리터럴) | SetSpreadColumn |
| BR-22 | 숨김 체크박스 chkMyModel(Checked=true) / chkPartLeader / chkTeamLeader / chkDelegateeModel은 Visible=false. SP 파라미터로 쓰이는지는 확인 필요. 조회 SP 다수가 SSP_MST_MODEL_USER, SSP_MST_DELEGATE를 참조함 | props, endpoints |
| BR-23 | 화면 그룹: 여러 메서드가 `UserInfoContext.Current.NowGroupID`를 읽는다 | InitControls, SetChangedControl, SpdMain_ActiveSheetChanged |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

> 쓰기 테이블은 **굵게** 표시했습니다. `#` 임시테이블과 REF 함수는 뺐습니다. "호출처"는 화면설계서 §5 액션 명세와 같은 이름을 씁니다.

| # | 엔드포인트 | SP | 호출처(메서드:줄) | 읽기 테이블 | 쓰기 테이블 / 내부 EXEC |
|---:|---|---|---|---|---|
| 1 | `biz:CommonData.CommonDataList` [code=PlanDateShip] | UP_FX_GetCommonDataList(코드분기, DB 보강) | InitControls:568, SetChangedControl:2202/2210/2218, EditButton:1753/1757 | SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_SHIP_PLAN_P, SSP_PLAN_VERSION_V | — |
| 1 | `biz:CommonData.CommonDataList` [code=LookupCommon] | UP_FX_GetCommonDataList | SpdMain_ActiveSheetChanged:1400/1452 | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| 1 | `biz:CommonData.CommonDataList` [code=TransMode] | UP_FX_GetCommonDataList | SpdDetail_CellClick:8583, SpdDetail_ClipboardPasted:8954 | SCP_MST_BOD_V | — |
| 1 | `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] | UP_FX_GetCommonDataList | SpdDetail_CellClick:8604 | SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER, SCM_MST_SITE | — |
| 1 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] / [code=PERIOD2_{p:value}] | 확인 필요 (DB 보강 없음) | SetChangedPeriod:9207/9211 (진입점 미연결) | 확인 필요 | — |
| 2 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | DM0003_GET_BUCKET_TYPE_CODE | GetBucketType:2162 | SCM_ADM_LOOKUP_MASTER_DETAIL | — |
| 3 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST` | SSP0015_GET_SHIPMENT_PSI_PACKER_PAST | FindData_Main_Packer_Past:2293 | SCM_MST_TITLESET_USER, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SSP_ANL_SHIP_PLAN_P, SCM_MST_SHEET_MEASURE, SCM_SYS_CALENDAR_M, SCM_CODE_LOOKUP_VALUE (+DYNAMIC) | 임시테이블만 씀 |
| 4 | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` | SSP0015_GET_SHIPMENT_PSI_PACKER | FindData_Main_Packer:2412 | SCM_MST_TITLESET_USER, SSP_ANL_SHIP_REQ_P, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE, SCM_DNM_SCS_PROD_PLAN, SCM_DNM_SCS_STOCK, MST_STOCK, SCM_DNM_STOCK_V, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE (+DYNAMIC) | 임시테이블만 씀 |
| 5 | `SSP.SSP0015_GET_SHIPMENT_PSI` | SSP0015_GET_SHIPMENT_PSI | FindData_Main:2536 | SCM_MST_TITLESET_USER, SSP_PLAN_VERSION_V, SSP_ANL_SHIP_PLAN_40, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, DM_PLN_SHIPMENT_REQ, SCP_MST_BOD_N_V, SSP_ANL_SHIP_CONFIRM, SSP_ANL_MES_FCS_STOCK_40_C, SCP_MST_FINAL_ITEM, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_ANL_OWMS_STOCK_C, SSP_ANL_TCO_STOCK_C, SSP_ANL_HOLD_STOCK, SCM_SYS_CALENDAR_M, SCM_MST_SHEET_MEASURE, SCM_CODE_LOOKUP_VALUE, SCM_MST_SITE (+DYNAMIC) | 임시테이블. EXEC SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| 6 | `SSP.SSP0002_GET_NERP_CODE` | SSP0002_GET_NERP_CODE | GetNERPCode:2904 | SCM_CODE_LOOKUP_VALUE | — |
| 7 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL | FindData_Detail:3165/3303, FindData_Detail_btnSearch:3705 | 동적 SQL이라 정적 테이블 미추출 → 확인 필요 | — |
| 8 | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` | SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | FindData_Detail_Packer_btnSearch:3439 | 동적 SQL → 확인 필요 | — |
| 9 | `SSP.SSP0015_GET_WH_STOCK` | SSP0015_GET_WH_STOCK | FindData_WHstock:3850 | SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_ITEM_SN | — |
| 10 | `SSP.SSP0015_GET_MES_STOCK` | SSP0015_GET_MES_STOCK | FindData_mes_stock:3966, FindData_MesStock_btnSearch:4528 | SSP_ANL_MES_FCS_STOCK_40_C, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SSP_ANL_OWMS_STOCK_C, SCM_MST_SLOC, SCM_MST_ITEM_SN | — |
| 11 | `SSP.SSP0015_GET_BLOCK_STOCK` | SSP0015_GET_BLOCK_STOCK | FindData_block_stock:4070, FindData_BolckStockDetail_btnSearch:4193 | SSP_ANL_HOLD_STOCK, TB_FX_USER, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SITE, SCM_MST_ITEM_SN | — |
| 12 | `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` | SSP0015_GET_STOCK_LOCATION_DETAIL | FindData_shtStockLocationDetail_btnSearch:4337 | SSP_MST_LOCATION_V, SCM_MST_SITE, SCM_MST_SLOC, SCM_DNM_STOCK_V, SCM_MST_ITEM_SN, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_CODE_LOOKUP_VALUE | — |
| 13 | `SSP.SSP0015_GET_SCS_STOCK` | SSP0015_GET_SCS_STOCK | FindData_ScsStock_btnSearch:4437 | SCM_DNM_SCS_STOCK, SCM_MST_SITE, SSP_MST_MODEL_USER, SSP_MST_DELEGATE | — |
| 14 | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` | SSP0026_GET_REQUEST_DETAIL_PACK | FindData_Request_Detail:4640 | 동적 SQL → 확인 필요 | — |
| 15 | `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` | SSP0015_GET_SHIPMENT_PSI_COMMENTS | FindData_WHinPlanDetail_btnSearch:4723 | 동적 SQL → 확인 필요 | — |
| 16 | `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER` | SSP0015_GET_SHIPMENT_RESULT_PACKER | FindData_ShipmentSCSResult_btnSearch:4832 | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SCM_MST_CUSTOMER, SSP_MST_DELEGATE, SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_PLAN_P, SCP_MST_BOD_N_V, SCM_MST_ITEM_SN (CTE: RESULT_SCS_EXIST, RESULT_ERP_C_NON, PLAN_SSP) | — |
| 17 | `SSP.SSP0015_GET_SHIPMENT_RESULT` | SSP0015_GET_SHIPMENT_RESULT | FindData_ShipmentResult_btnSearch:4944 | SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SSP_MST_MODEL_USER, SSP_MST_DELEGATE, SCM_MST_SSO_DEPT_INFO, TB_FX_USER, SCM_MST_SITE_ITEM, SSP_ANL_SHIP_CONFIRM, SCM_DNM_EXFACTORY_RESULT, SCP_MST_FINAL_ITEM, SSP_ANL_SHIP_PLAN_ALL, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SCM_MST_ITEM_SN, SCM_CODE_LOOKUP_VALUE (CTE: RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, PLAN_SSP, RESULT_OWMS, RETURN_OWMS) | — |
| 18 | `SSP.SSP0015_SAVE_SHIPMENT_PSI` | SSP0015_SAVE_SHIPMENT_PSI | SaveData_Main:5412 | SSP_ANL_SHIP_PLAN_40, SSP_ANL_SHIP_PLAN_40_WH_IN_CMT | **UPDATE/INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT**, **INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H**, **UPDATE SSP_ANL_SHIP_PLAN_40**, **INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_H**, **INSERT SCM_SYS_LOG_BATCH** / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 19 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | SaveData_Detail_Packer:5602 | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SSP_PLAN_VERSION_V, SSP_MST_SITE_ITEM_EE_V, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, SCM_ADM_LOOKUP_MASTER_DETAIL, NERP_CONV_MASTER, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_MST_SEND_MAIL_REQ, SCM_SYS_CALENDAR_M, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER | **UPDATE/INSERT SSP_ANL_SHIP_CONFIRM**, **INSERT SSP_ANL_SHIP_CONFIRM_H**, **INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN**, **INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN**, **INSERT SSP_MST_SEND_MAIL_REQ**, **INSERT SCM_SYS_LOG_BATCH** / EXEC PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SCM_SYS_LOG_BATCH, PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 20 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | SaveData_Detail:5841 | SSP_ANL_SHIP_PLAN_40, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SSP_PLAN_VERSION_V, SSP_MST_SITE_ITEM_EE_V, SCM_ADM_LOOKUP_MASTER_DETAIL, NERP_CONV_MASTER, TB_FX_USER, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_MST_SEND_MAIL_REQ, SCM_SYS_CALENDAR_M, DM_PLN_MKT_FCST_CONFIRM, SCP_MST_DISTRIBUTION_ROUTE, DM_MST_ITEM_SINGLE_V, SCM_DNM_EXFACTORY_RESULT, DM_PLN_MKT_FCST_RESULT | **UPDATE/INSERT SSP_ANL_SHIP_CONFIRM**, **INSERT SSP_ANL_SHIP_CONFIRM_H**, **INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN**, **INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ / _CHG_REQ_DE**, **DELETE/INSERT SSP_ANL_SHIP_PLAN_40**, **INSERT SSP_MST_SEND_MAIL_REQ**, **INSERT DM_PLN_MKT_FCST_CONFIRM**, **INSERT SCM_SYS_LOG_BATCH**, DELETE:A / UPDATE:A(별칭, 대상 확인 필요) / EXEC PR_DM_SSP_CONFIRM_SYNC, PR_SSP_ANL_SHIP_CONFIRM_HIST, PR_SSP_MAIL_SEND_ADJUST_MST, PR_SSP_ANL_SHIP_CONFIRM_ROUTE |
| 21 | `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` | SSP0015_SAVE_BLOCK_STOCK_DATA | SaveData_Detail:6011 | SSP_ANL_HOLD_STOCK | **UPDATE/INSERT SSP_ANL_HOLD_STOCK**, **INSERT SCM_SYS_LOG_BATCH** / EXEC PR_SCM_SYS_LOG_BATCH |
| 22 | `SSP.SSP0015_SAVE_MES_STOCK` | SSP0015_SAVE_MES_STOCK | SaveData_Detail:6112/6219 | SSP_ANL_SHIP_PLAN_40, SSP_ANL_MES_FCS_STOCK_40_C | **MERGE SSP_ANL_MES_FCS_STOCK_40_C**, **MERGE SSP_ANL_SHIP_PLAN_40**, **INSERT SCM_SYS_LOG_BATCH** |
| 23 | `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | GetERPInterface:6665 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | **INSERT SSP_ANL_SHIP_ERP_ERROR_CONFIRM**, **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ / _CHG_REQ_DE**, **INSERT SCM_SYS_LOG_BATCH** |
| 24 | `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` | SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | GetERPInterface:6706, GetErpIFCheckNew:7363 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, SSP_ANL_SHIP_CONFIRM, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE**, **UPDATE/DELETE SSP_ANL_SHIP_CONFIRM**, **INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN**, **INSERT SCM_SYS_LOG_BATCH** |
| 25 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING | NonSoNo:6843, SoNo:7076 (NewNonSoNo:9611 미연결) | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_DIVISION, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | **INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ / _CHG_REQ_DE**, **INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN**, **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE**, **INSERT SCM_SYS_LOG_BATCH** / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, PR_SCP_SYS_LOG_BATCH |
| 26 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` | SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | NonSoNo:6847, SoNo:7080 (NewNonSoNo:9615 미연결) | SSP_ANL_SHIP_CONFIRM, SCP_MST_BOD_N_V, SCP_MST_BOD_ITEM, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_SYS_CALENDAR_M, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_MST_SITE_ITEM, SSP_MST_MODEL_USER, TB_FX_USER, NERP_CONV_MASTER, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, SCM_MST_CUSTOMER, SCM_MST_SITE_CUSTOMER | **INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ / _CHG_REQ_DE**, **INSERT XIF_ERP_PACK_SHIP_PLAN_S_SN**, **INSERT XIF_SCS_PACK_SHIP_PLAN_S_SN**, **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE**, **INSERT SCM_SYS_LOG_BATCH** / EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, PR_SCP_SYS_LOG_BATCH |
| 27 | `SSP.SSP0015_GET_ERP_SO_NO_CNT` | SSP0015_GET_ERP_SO_NO_CNT | GetErpSoNoCnt:7185 | SSP_ANL_SHIP_CONFIRM | — |
| 28 | `SSP.SSP0015_GET_SHIPMENT_STATUS` | SSP0015_GET_SHIPMENT_STATUS | GetShipmentStatusChk:7210 | SSP_ANL_SHIP_CONFIRM | — |
| 29 | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` | SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING | GetErpIFCheck:7285, GetErpIFCheckNew_:9731 (둘 다 진입점 미연결) | — | **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ / _CHG_REQ_DE**, **INSERT SCM_SYS_LOG_BATCH** |
| 30 | `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` | PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | GetErpIFCheckNew:7389/7419 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_DIVISION, SCM_MST_SITE, NERP_CONV_MASTER, SCM_MST_SITE_CUSTOMER, DM_PLN_MKT_FCST | **INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN**, **UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE**, **INSERT SCM_SYS_LOG_BATCH** / EXEC PR_SCP_SYS_LOG_BATCH |
| 31 | `SCP.PR_SCM_SYS_LOG_BATCH` | PR_SCM_SYS_LOG_BATCH | SCM_SYS_LOG_BATCH:7876 (진입점 미연결) | — | **INSERT SCM_SYS_LOG_BATCH** |
| 32 | `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | EngProcessingChk:7903 | SCM_MST_PLAN, SCM_MST_DIVISION, SCM_MST_PLAN_DETAIL | — |
| 33 | `SCM.SCM0001_GET_DIVISION` | SCM0001_GET_DIVISION | GetDivision:9192 (진입점 미연결) | SCM_MST_DIVISION | — |
| 34 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP0009_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle:9247 | SCM_SYS_CALENDAR_M | — |
| 35 | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | SCM0001_GET_SCP_DAY_PERIOD | GetDayRange:9289 | SCM_SYS_CALENDAR_M, SCM_ADM_LOOKUP_MASTER_DETAIL (CTE_DATE, FN_MULTY_TIME, FN_WEEKOFDAY_DATE) | — |
| 36 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | SSP0202_GET_SCS_CONFIRM_ID_CHECK | chkSaveYN:9821 | SCM_ADM_LOOKUP_MASTER_DETAIL (+DYNAMIC) | — |
| 37 | `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | SCM_SSP_CHECK_CONFIRM_CHANGETIME | ChkConfirmChangeTime:9875 | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | **INSERT SCM_SYS_LOG_BATCH** / EXEC PR_SCM_SYS_LOG_BATCH |
| 38 | `SSP.SSP0002_GET_USER_INFO_LIST` | SSP0002_GET_USER_INFO_LIST | GetSSPUserCheck:9901 | SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION | — |
| 39 | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | SSP0015_SAVE_SHIPMENT_PSI_COMMENTS | (팝업) SaveData:333 | SSP_ANL_SHIP_PLAN_40, SSP_ANL_SHIP_PLAN_40_WH_IN_CMT | **UPDATE SSP_ANL_SHIP_PLAN_40**, **INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_H**, **UPDATE/INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT**, **INSERT SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H**, **INSERT SCM_SYS_LOG_BATCH** / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |

### 5-1. SP 점검표 (38종)
DM0003_GET_BUCKET_TYPE_CODE · SSP0015_GET_SHIPMENT_PSI_PACKER_PAST · SSP0015_GET_SHIPMENT_PSI_PACKER · SSP0015_GET_SHIPMENT_PSI · SSP0002_GET_NERP_CODE · SSP0015_GET_SHIPMENT_CONFIRM_DETAIL · SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER · SSP0015_GET_WH_STOCK · SSP0015_GET_MES_STOCK · SSP0015_GET_BLOCK_STOCK · SSP0015_GET_STOCK_LOCATION_DETAIL · SSP0015_GET_SCS_STOCK · SSP0026_GET_REQUEST_DETAIL_PACK · SSP0015_GET_SHIPMENT_PSI_COMMENTS · SSP0015_GET_SHIPMENT_RESULT_PACKER · SSP0015_GET_SHIPMENT_RESULT · SSP0015_SAVE_SHIPMENT_PSI · SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER · SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 · SSP0015_SAVE_BLOCK_STOCK_DATA · SSP0015_SAVE_MES_STOCK · SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM · SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM · SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING · SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER · SSP0015_GET_ERP_SO_NO_CNT · SSP0015_GET_SHIPMENT_STATUS · SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING · PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH · PR_SCM_SYS_LOG_BATCH · SSP0003_GET_SSP_PLAN_PROCESSING_CHECK · SCM0001_GET_DIVISION · SCP0009_GET_SHEET_CALENDAR_3SPAN · SCM0001_GET_SCP_DAY_PERIOD · SSP0202_GET_SCS_CONFIRM_ID_CHECK · SCM_SSP_CHECK_CONFIRM_CHANGETIME · SSP0002_GET_USER_INFO_LIST · SSP0015_SAVE_SHIPMENT_PSI_COMMENTS

## 6. division·권한별 변형

### 6-1. division
| 항목 | 사실 |
|---|---|
| 메타 Grid(SCM_MST_SHEET_COLUMNS / SCM_MST_SHEET_MEASURE) | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)의 컬럼 수가 모든 시트에서 같음. 메타 기준 division 차이 없음 |
| 최종 Grid(grid_effective) | 표시 컬럼 수도 division 간에 같음 |
| 실제 화면 변형 요인 | division이 아니라 시트명 분기(`Shipment PSI(Mobility & IT)` / `Shipment PSI(Packer)`), Bucket Type, chkSum, ichkbtn |
| 저장 SP 분기 | `_40`(SaveData_Detail) / `_PACKER`(SaveData_Detail_Packer)가 division과 연결되는지는 **확인 필요**. 이름상 Mobility & IT 계열 테이블은 SSP_ANL_SHIP_PLAN_40, Packer 계열은 SSP_ANL_SHIP_PLAN_P / SSP_ANL_SHIP_REQ_P를 참조함 |
| 셀 콤보 | ShipToCodeByDivision 공통코드로 division별 Ship-to 목록을 가져옴(파라미터는 확인 필요) |

### 6-2. 권한
| 항목 | 사실 |
|---|---|
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 14행, TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행. C/R/U/D 플래그 값은 **확인 필요** |
| 시트 권한 | `WH In Plan Detail`은 `drPgmAuthId != null`일 때만 생성 |
| 편집 진입 | EditButton > GetSSPUserCheck > `SSP.SSP0002_GET_USER_INFO_LIST` (TB_FX_USERGROUPINFO, TB_FX_USERGROUPAUTHEXTENTION 참조) |
| 그룹·사용자 필터 | SetChangeControl: GROUP_ID, USER_ID, NowGroupID |
| 시트 잠금 | `siDetail.IsLock(SheetName)`이 false일 때만 헤더 체크 토글 |
| 담당 모델 | 조회 SP 다수가 SSP_MST_MODEL_USER, SSP_MST_DELEGATE를 참조함. 숨김 체크박스와의 관계는 **확인 필요** |

## 7. 외부 인터페이스 (사실에 있는 것만)

| 방향 | 대상 테이블 | 적재 SP |
|---|---|---|
| → ERP (출하 확정) | XIF_ERP_SHIP_PLAN_CONFIRM_S_SN | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING, SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM, PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| → ERP (Packer) | XIF_ERP_PACK_SHIP_PLAN_S_SN | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| → SCS (Packer) | XIF_SCS_PACK_SHIP_PLAN_S_SN | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| → 메일 요청 | SSP_MST_SEND_MAIL_REQ | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40, SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER |
| → DM 동기화 | DM_PLN_MKT_FCST_CONFIRM (EXEC PR_DM_SSP_CONFIRM_SYNC) | SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| ← ERP 오류 확인 | SSP_ANL_SHIP_ERP_ERROR_CONFIRM | SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| ← 수신 원천(읽기) | SCM_DNM_SCS_STOCK, SCM_DNM_SCS_PROD_PLAN, SCM_DNM_SCS_SHIP_RESULT, SSP_ANL_OWMS_STOCK_C, SSP_ANL_TCO_STOCK_C, SSP_ANL_MES_FCS_STOCK_40_C, SSP_DNM_SHIP_RESULT_OWMS, SSP_DNM_SHIP_RETURN_OWMS, SCM_DNM_EXFACTORY_RESULT, NERP_CONV_MASTER | 조회 SP (§5) |

> 인터페이스의 전송 주기·수신 시스템 처리 방식은 Fact Pack에 없음 → **확인 필요**.

## 8. 미확정·확인 필요

| # | 항목 |
|---:|---|
| 1 | FindButton에서 FindData_Main / _Packer / _Packer_Past 중 하나를 고르는 분기 조건 |
| 2 | SaveButton에서 SaveData_Main / SaveData_Detail / SaveData_Detail_Packer를 고르는 조건과, 각 경로 안의 호출 순서 |
| 3 | GetERPInterface 안에서 SoNo / NonSoNo를 고르는 조건 |
| 4 | `SaveButton > SaveData(333)` 귀속이 맞는지. 팝업 SaveData와 메서드 이름이 같아 오귀속일 수 있음. Fact Pack §4-2는 SaveData를 PersonalSettingPopup.SaveData로도 귀속함 |
| 5 | 동적 SQL SP 5종의 실제 참조 테이블: SSP0015_GET_SHIPMENT_CONFIRM_DETAIL, SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER, SSP0015_GET_SHIPMENT_PSI_COMMENTS, SSP0026_GET_REQUEST_DETAIL_PACK, SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| 6 | 진입점 미연결 메서드(GetErpIFCheck, SCM_SYS_LOG_BATCH, GetDivision, SetChangedPeriod, NewNonSoNo, GetErpIFCheckNew_)를 런타임에 쓰는지 |
| 7 | chkERPIFBlockYn의 BLOCK_YN / PERIOD 데이터 원천 |
| 8 | Validation_Check 판정 조건과 메시지 문구 |
| 9 | 숨김 체크박스 4종이 SP 파라미터에 반영되는지 |
| 10 | Packer / 40 분기와 division의 관계 |
| 11 | Comments 팝업을 여는 코드와 넘기는 값 |
| 12 | W/H stock Detail 시트의 조회 SP (BtnSearch_Click 흐름에 이 시트 전용 FindData가 보이지 않음) |
| 13 | 주석 처리된 호출 4건(줄 3573, 9288, 9308, 9309)은 현행 기능 아님. 이관 대상에서 뺌 |
| 14 | 메뉴 위치, 업무 목적 문구, 메뉴 권한 C/R/U/D 값 |

=== FILE: screen_design.md ===
# SSP0015 Shipment PSI — 화면설계서

> 근거: Fact Pack(controls / props / events / grid_rule / grid_code / grid_effective)과 1차 분석서. 라벨은 props.csv Text 원문입니다. 원문을 확인하지 못한 라벨은 '확인 필요'로 표기했습니다.
> §5 액션 명세의 엔드포인트 이름은 업무분석서 §5와 같습니다. §3 컨트롤명은 단위테스트 '절차' 열에서 그대로 씁니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0015 |
| 명칭 | Shipment PSI (파일명 기준) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행 존재, 경로 미추출) |
| 메인 클래스 | `SSP0015_ShipmentPSI` |
| 팝업 클래스 | `SSP0015_ShipmentPSICommentsPopup` (Comments) |
| Grid 구성 방식 | HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경) |
| Grid | `spdMain`(상단, 시트 2개), `spdDetail`(하단, 시트 11개. `WH In Plan Detail`은 권한 조건부) |
| 툴바 버튼 | FindButton(조회), SaveButton(저장), EditButton(편집). 프레임워크 툴바 |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv SplitContainer + controls.csv parent 체인)

```
SSP0015_ShipmentPSI (Form)  — 폭 1370
├─ usrConditionPanel1        [UsrConditionPanel, Dock=Top, 1370×79]   ← 조회조건 영역
│   └─ usrLayoutControl2     [UsrLayoutControl,  Dock=Top, 1370×73]
│       ┌──────────────────────────────────────────────────────────────────────────────────────────┐
│       │ Division* [clbDivision ▼] Plan-date* [cboPlanDate ▼] Period* [drpPeriod ~ ]              │
│       │ From Site [clbPlantSite ☑▼] Bucket [cboBucketType ▼] [☐ chkSum Sum] [btnMeasure]          │
│       │ Model [txtItemId     ][btnItemId]                                                        │
│       │ (숨김) chkMyModel / chkPartLeader / chkTeamLeader / chkDelegateeModel                     │
│       └──────────────────────────────────────────────────────────────────────────────────────────┘
│       ※ 컨트롤의 줄/열 배치 좌표는 props.csv에서 추출하지 못함 → 순서는 1차 분석서 표 순서, 실제 배치는 확인 필요
└─ splitContainer1           [SplitContainer, Dock=Fill, 1370×570, Orientation=Horizontal → 상/하 분할, SplitterDistance=301]
    ├─ Panel1 (상) 301px = 52.8%
    │   └─ spdMain           [FpSpread, Dock=Fill] (spdMain_Sheet1)       ← 상단 Grid
    │        시트 탭: Shipment PSI(Mobility & IT) | Shipment PSI(Packer)
    ├─ Splitter 4px = 0.7%   (570 − 301 − 265 에서 계산)
    └─ Panel2 (하) 265px = 46.5%
        ├─ usrLayoutControl3 [UsrLayoutControl, Dock=Top, 높이 40 = Panel2의 15.1%]  ← 하단 Detail 조회 바
        │   ┌──────────────────────────────────────────────────────────────────────────────────────┐
        │   │ Shipment Date [drpPeriod2 ~ ] Requestor [txtRequestor][btnRequestor]                  │
        │   │ [clbResultType ☑▼] [txtModel2][btnItemID2] [drpPeriod3 ~ ] [txtLotID] [btnSearch Search] │
        │   └──────────────────────────────────────────────────────────────────────────────────────┘
        └─ spdDetail         [FpSpread, Dock=Fill, 높이 225 = Panel2의 84.9%] (spdDetail_Sheet1)  ← 하단 Grid
             시트 탭: Shipment Confirm Detail | Shipment Request Detail | W/H stock | W/H stock Detail |
                      Hold stock | Hold stock Detail | Stock Detail | SCS Stock Detail |
                      Stock Location Detail | WH In Plan Detail(권한 조건부) | Shipment Result

usrButton1  [UsrButton, 75×23] — parent 없음 (배치 위치 확인 필요, 미사용 가능성)
```

| 영역 | 높이(px) | 폼 본문 649px 대비 | 비고 |
|---|---:|---:|---|
| 조회조건(usrConditionPanel1) | 79 | 12.2% | 접이식 HidePanel 타입 |
| 상단 Grid(Panel1) | 301 | 46.4% | split 안에서 52.8% |
| Splitter | 4 | 0.6% | 계산값 |
| 하단 조회 바(usrLayoutControl3) | 40 | 6.2% | |
| 하단 Grid(spdDetail) | 225 | 34.7% | |

### 2-2. 팝업 레이아웃 (SSP0015_ShipmentPSICommentsPopup)

```
SSP0015_ShipmentPSICommentsPopup (크기 확인 필요)
├─ usrConditionPanel1 / usrLayoutControl1 / usrLayoutControl2 (팝업 쪽 사본으로 보임. parent 체인은 확인 필요)
│   ├─ txtDivision_ID  txtFrom_Site  txtItem_ID  txtPlan_Date  txtDate  txtMeasure
│   ├─ txtGap_Qty  txtBefore_Qty  txtProd_Qty  txtWHin_Qty  txtCurrent_Qty  txtChange_Qty
│   ├─ usrLabel1
│   └─ rtxComments (RichTextBox)
└─ btnButtonList (UsrButtonList — 저장)
```

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|:---:|---|---|
| 1 | usrConditionPanel1 | UsrConditionPanel | 확인 필요 | Dock=Top, 1370×79 | — | — | 접이식 SearchCondition 패널 |
| 2 | usrLayoutControl2 | UsrLayoutControl | — | Dock=Top, 1370×73 | — | — | 조회조건 Grid 레이아웃 |
| 3 | clbDivision | UsrCombo (이름은 clb지만 타입은 콤보) | `Division*` (lblCombo1) | 확인 필요 (원천 확인 필요) | Y | `clbDivision_SelectedIndexChanged` | ComboBox (필수) |
| 4 | cboPlanDate | UsrCombo | `Plan-date*` (PlanDate) | `biz:CommonData.CommonDataList` [PlanDateShip] | Y | `CboPlanDate_SelectedIndexChanged` | ComboBox (필수) |
| 5 | drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | Y | — | DateRange (필수) |
| 6 | clbPlantSite | UsrCheckedList | `From Site` (layoutControlItem7) | 확인 필요 | N | — | MultiSelect |
| 7 | cboBucketType | UsrCombo | `Bucket` (lblBucket) | `DM.DM0003_GET_BUCKET_TYPE_CODE` (DAILY/WEEKLY/MONTHLY) | N | `cboBucketType_SelectedIndexChanged` | ComboBox |
| 8 | chkSum | UsrCheckBox | `Sum` | 확인 필요 | N | `chkSum_CheckedChanged` | CheckBox |
| 9 | btnMeasure | UsrButton | 라벨 없음 (layoutControlItem10) | — | — | `btnMeasure_Click` | IconButton |
| 10 | txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 공백 | N | — | MultiLine Text |
| 11 | btnItemId | UsrButton | 라벨 없음 (layoutControlItem2) | — | — | `btnItemId_Click` | 팝업 버튼 |
| 12 | chkMyModel | UsrCheckBox | `My Model` | Checked=true, **Visible=false** | — | — | 숨김 (상태값만 유지) |
| 13 | chkPartLeader | UsrCheckBox | `Part Leader` | **Visible=false** | — | — | 숨김 |
| 14 | chkTeamLeader | UsrCheckBox | `Team Leader` | **Visible=false** | — | — | 숨김 |
| 15 | chkDelegateeModel | UsrCheckBox | `Delegatee Model` | **Visible=false** | — | — | 숨김 |
| 16 | usrButton1 | UsrButton | 확인 필요 | parent 없음 | — | — | 이관 여부 확인 필요 |
| 17 | spdMain | FpSpread | — | Dock=Fill (Panel1) | — | `spdMain_TextTipFetch`, `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `SpdMain_ActiveSheetChanged`, `SpdMain_EditModeOn`, `SpdMain_CellClick` | Wijmo FlexGrid + 시트 탭 |
| 18 | spdMain_Sheet1 | SheetView | — | 디자이너 기본 시트 | — | — | (시트 탭 1) |
| 19 | spdDetail | FpSpread | — | Dock=Fill (Panel2), 높이 225 | — | `SpdDetail_TopChange`, `SpdDetail_CellClick`, `spdDetail_ComboSelChange`, `SpdDetail_SheetTabClick`, `SpdDetail_CellDoubleClick`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_EditChange`, `SpdDetail_ClipboardPasted` | Wijmo FlexGrid + 시트 탭 |
| 20 | spdDetail_Sheet1 | SheetView | — | 디자이너 기본 시트 | — | (dsdm.Changed → `shtDetail_Change`) | (시트 탭) |
| 21 | usrLayoutControl3 | UsrLayoutControl | — | Dock=Top, 높이 40 | — | — | Detail 조회 바 |
| 22 | drpPeriod2 | UsrDateRangePicker | `Shipment Date` (layoutControlItem11) | 확인 필요 | N | — | DateRange |
| 23 | txtRequestor | UsrTextBox | LayoutItem `Requestor` (Text 원문 확인 필요) | 공백 | N | — | Text |
| 24 | btnRequestor | UsrButton | 라벨 없음 (layoutControlItem9) | — | — | `BtnRequestor_Click` | 사용자 선택 팝업 버튼 |
| 25 | clbResultType | UsrCheckedList | 확인 필요 | 확인 필요 | N | — | MultiSelect |
| 26 | txtModel2 | UsrMultiLineEditor | 확인 필요 | 공백 | N | — | MultiLine Text |
| 27 | btnItemID2 | UsrButton | 확인 필요 | — | — | `BtnItemID2_Click` | 팝업 버튼 |
| 28 | drpPeriod3 | UsrDateRangePicker | 확인 필요 | 확인 필요 | N | — | DateRange |
| 29 | txtLotID | UsrMultiLineEditor | 확인 필요 | 공백 | N | — | MultiLine Text |
| 30 | btnSearch | SimpleButton | `Search` | — | — | `BtnSearch_Click` | Button |
| 31 | usrLayoutControl1 | UsrLayoutControl (팝업) | — | 확인 필요 | — | — | 팝업 Form 레이아웃 |
| 32 | txtDivision_ID | UsrTextBox (팝업) | 확인 필요 | 부모 행 DIVISION_ID (확인 필요) | — | — | ReadOnly Text |
| 33 | txtFrom_Site | UsrTextBox (팝업) | 확인 필요 | 부모 행 SITE (확인 필요) | — | — | ReadOnly Text |
| 34 | txtItem_ID | UsrTextBox (팝업) | 확인 필요 | 부모 행 ITEM_ID (확인 필요) | — | — | ReadOnly Text |
| 35 | txtPlan_Date | UsrTextBox (팝업) | 확인 필요 | 확인 필요 | — | — | ReadOnly Text |
| 36 | txtDate | UsrTextBox (팝업) | 확인 필요 | 부모 행 YYYYMMDD (확인 필요) | — | — | ReadOnly Text |
| 37 | txtMeasure | UsrTextBox (팝업) | 확인 필요 | 확인 필요 | — | — | ReadOnly Text |
| 38 | txtGap_Qty | UsrTextBox (팝업) | 확인 필요 | Comments GAP (확인 필요) | — | `txtGap_Qty_TextChanged` | Number Text |
| 39 | txtBefore_Qty | UsrTextBox (팝업) | 확인 필요 | Comments BEFORE_QTY (확인 필요) | — | `txtBefore_Qty_TextChanged` | Number Text |
| 40 | txtProd_Qty | UsrTextBox (팝업) | 확인 필요 | 확인 필요 | — | `txtProd_Qty_TextChanged` | Number Text |
| 41 | txtWHin_Qty | UsrTextBox (팝업) | 확인 필요 | 확인 필요 | — | `txtWHin_Qty_TextChanged` | Number Text |
| 42 | txtCurrent_Qty | UsrTextBox (팝업) | 확인 필요 | 확인 필요 | — | `txtCurrent_Qty_TextChanged` | Number Text |
| 43 | txtChange_Qty | UsrTextBox (팝업) | 확인 필요 | 확인 필요 | 확인 필요 | `txtChange_Qty_TextChanged`, `txtChange_Qty_KeyPress` | Number Input |
| 44 | rtxComments | RichTextBox (팝업) | — | 공백 | 확인 필요 | — | TextArea |
| 45 | usrLabel1 | UsrLabel (팝업) | 확인 필요 | — | — | — | Label |
| 46 | btnButtonList | UsrButtonList (팝업) | 확인 필요 | — | — | `btnButtonList_UsrButtonList_Click_Detected` | 버튼 그룹 (저장) |

> 팝업에도 `usrConditionPanel1`, `usrLayoutControl2`라는 같은 이름의 컨트롤이 하나씩 더 있습니다(controls 집계에서 2개씩). 위 표의 1·2번은 메인 화면 기준입니다.

## 4. 그리드 명세

공통 규칙:
- 출처 **META** = SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SSP0015). SetSheetHeaderColumn이 COLUMN_NAME / COLUMN_LABEL_NAME / COLUMN_WIDTH / VISIBLE_FLAG / VALID_YN / FIXED_FLAG / CELL_CONTROL_OBJECT_TYPE_CODE / CELL_COMBO_DATA_TYPE / DATA_MAX_LENGTH / DATA_SCALE_NUMBER / HORIZONTAL_ALIGN_CODE / UPPERCASE_APPLY_FLAG / ATTRIBUTE1~5로 만듭니다.
- **타입**은 메타 CELL_CONTROL_OBJECT_TYPE_CODE 값을 따르는데, Fact Pack 발췌에 값이 없습니다 → "메타(확인 필요)".
- **편집 가능 여부**도 메타·시트 Lock 값이 Fact Pack에 없습니다 → 확인 필요. 라벨 끝의 `*`는 메타 원문 표기일 뿐이며, 편집·필수 판정 근거로 단정하지 않습니다.
- **division별 표시**는 14개 division 모두 같습니다(§10/§12 집계). 아래 표에서는 "전체"로 적었습니다.
- **HARDCODED** = 코드가 표시를 바꾸거나 컬럼을 추가하는 경우입니다(grid_code).

### 4-1. `Shipment PSI(Mobility & IT)` — spdMain / META+코드연결 / 표시 10 / Measure 메타 12+1
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 메타(확인 필요) | META | 전체 | 확인 필요 |
| FIGURE | Figure | 메타 | META | 전체 | 확인 필요 |
| FROM_SITE_NM | From Site | 메타 | META | 전체 | 확인 필요 |
| ITEM_ID | Model | 메타 | META | 전체 | 확인 필요 |
| LT_DAY | Aging L/T | 메타 | META | 전체 | 확인 필요 |
| MEASURE_NAME | Measure | 메타 | META | 전체 | 확인 필요 |
| NICK_NAME | Nick Name | 메타 | META | 전체 | 확인 필요 |
| PSI_NAME | PSI | 메타 | META | 전체 | 확인 필요 |
| TYPE | TYPE | 메타 | META | 전체 | 확인 필요 |
| YEILD | Yield(%) | 메타 | META | 전체 | 확인 필요 |
| (숨김) FROM_SITE `Site`, LT_UPDATE_YN, MEASURE, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN | — | — | META | 전체 | — |
| D_* / W_* / M_* 일자 컬럼 | SCP0009 LARGE/SMALL_CLASS_LABEL_NAME 3단 + SUM | Num(B_* 는 Text, 너비 0) | HARDCODED (DB루프 InitSpreadDateColumn) | 전체 | 확인 필요 |

코드 처리: 헤더 3행, MergePolicy.Always(776/778), SetSpreadColumn(Bucket/Sum), SAT 파랑 / SUN 빨강(1118).

### 4-2. `Shipment PSI(Packer)` — spdMain / META+코드연결 / 표시 8 / Measure 메타 6+0
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 메타 | META | 전체 | 확인 필요 |
| FIGURE | Figure | 메타 | META | 전체 | 확인 필요 |
| FROM_SITE_NM | From Site | 메타 | META | 전체 | 확인 필요 |
| ITEM_ID | Model | 메타 | META | 전체 | 확인 필요 |
| MEASURE | Measure | 메타 | META | 전체 | 확인 필요 |
| NICK_NAME | Nick Name | 메타 | META | 전체 | 확인 필요 |
| PSI_NAME | PSI | 메타 | META | 전체 | 확인 필요 |
| TYPE | TYPE | 메타 | META | 전체 | 확인 필요 |
| (숨김) FROM_SITE, LT_DAY, LT_UPDATE_YN, MEASURE_NAME, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN, YEILD | — | — | META | 전체 | — |
| 일자 컬럼 | 3단 헤더 + SUM | Num/Text | HARDCODED (DB루프) | 전체 | 확인 필요 |
| (SO No 계열로 보이는 컬럼, 컬럼명 확인 필요) | — | — | HARDCODED SetSoNoColumnVisible: ichkbtn==1 → Width 80 | 전체 | 확인 필요 |

코드 처리: 헤더 3행, MergePolicy.Always(803/805).

### 4-3. `Shipment Confirm Detail` — spdDetail / META+코드연결 / 최종 표시 40 (메타 필수+기본 39, 차이 확인 필요)
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| ATTRIBUTE10 | (라벨 확인 필요) | 메타 | META | 전체 | 확인 필요 |
| attribute3 | PLM status | 메타 | META | 전체 | 확인 필요 |
| attribute6 | OQC Result | 메타 | META | 전체 | 확인 필요 |
| CHANGE_REASON_CODE | Change Reason | 메타 | META | 전체 | 확인 필요 |
| CHANGE_REASON_DETAIL | Reason Detail | 메타 | META | 전체 | 확인 필요 |
| CHANGE_REQ_NO | Change Request No | 메타 | META | 전체 | 확인 필요 |
| CONFIRM_ID | Confirm/Plan ID | 메타 | META | 전체 | 확인 필요 |
| DIVISION_ID | Division | 메타 | META | 전체 | 확인 필요 |
| END_CUSTOMER | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| ERP_SO_NO | SO No | 메타 | META | 전체 | 확인 필요 |
| ETA | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| ETD | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| Expected_Shipping_Date | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| FCST_TYPE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| FROM_SITE_DESCRIPTION | From Site | 메타 | META | 전체 | 확인 필요 |
| INCOTERMS | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| ITEM_ID | Model | 메타 | META | 전체 | 확인 필요 |
| LT_DAY | L/T(Day) | 메타 | META | 전체 | 확인 필요 |
| MODEL_USER | Model PIC | 메타 | META | 전체 | 확인 필요 |
| MTK_OWNER | MKT Owner | 메타 | META | 전체 | 확인 필요 |
| NICK_NAME | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| REMARKS | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| REMARKS2 | Building | 메타 | META | 전체 | 확인 필요 |
| REMARKS3 | Customer Requirement | 메타 | META | 전체 | 확인 필요 |
| REQUESTOR | Shipment Requestor | 메타 | META | 전체 | 확인 필요 |
| RTF3 | RTF | 메타 | META | 전체 | 확인 필요 |
| RTF4 | RTF ETD | 메타 | META | 전체 | 확인 필요 |
| RTF5 | RTF QTY | 메타 | META | 전체 | 확인 필요 |
| RTF6 | RTF Detail | 메타 | META | 전체 | 확인 필요 |
| SHIPMENT_CONFIRM_QTY | Shipment Qty | 메타 | META | 전체 | 확인 필요 (Validation_Check 대상) |
| SHIPMENT_DATE | (확인 필요) | 메타 | META | 전체 | 확인 필요 (Validation_Check 대상) |
| SHIPMENT_STATUS | Status | 메타 | META | 전체 | 확인 필요 |
| SOLDTO_DESCRIPTION | Sold To Party | 메타 | META | 전체 | 확인 필요 |
| TEAM | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| TO_SITE_DESCRIPTION | To Site | 메타 | META | 전체 | 확인 필요 |
| TO_SITE_SHIPTO_CODE | Ship to | 메타 + 셀콤보 ShipToCodeByDivision | META+HARDCODED | 전체 | 확인 필요 (Validation_Check 대상) |
| TO_SITE_SOLDTO_CODE | Sold to | 메타 | META | 전체 | 확인 필요 |
| TRANSPORT_MODE | Trans Mode | 메타 + 셀콤보 TransMode | META+HARDCODED | 전체 | 확인 필요 (Validation_Check 대상) |
| UPDATED_BY | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| UPDATED_DATE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| SHIPTO_DESCRIPTION | Ship To Party | 메타 | 기본 → 코드에서 숨김 | 전체 | — |
| (숨김 메타) BEFORE_QTY, BOD_ID, CHANGE_TYPE, CHECK_NEED_YN, CHK `ALL`, EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE `Shipment Date*`, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PROJECT_CODE, PROJECT_NAME, TO_SITE | — | — | META | 전체 | — |

코드 처리: FindData_Detail / FindData_Detail_btnSearch / FindData_Detail_Packer_btnSearch에서 Visible=false 다수(대상 컬럼 확인 필요). SpdDetail_CellClick 헤더 CheckBox 전체 토글.

### 4-4. `Shipment Request Detail` — META+코드연결 / 표시 34 (행높이 60, 1차 분석서 기재)
| 컬럼 | 헤더 | 컬럼 | 헤더 |
|---|---|---|---|
| ATTRIBUTE3 | RTF | MODEL_ID | Model* |
| ATTRIBUTE4 | RTF ETD | MODEL_PIC | (확인 필요) |
| ATTRIBUTE5 | RTF QTY | NICK_NAME | (확인 필요) |
| ATTRIBUTE6 | RTF Detail | ORDER_TYPE_DETAIL | (확인 필요) |
| BOD_ID | (확인 필요) | QTY | Qty* |
| CHANGE_REQUEST_NO | (확인 필요) | REMARK | (확인 필요) |
| DIVISION_ID | Div* | REQUEST_ID | Confrim/Plan ID (원문 오탈자 그대로) |
| EDIT_FLAG | (확인 필요) | SHIPTO_CODE | Ship to* |
| END_CUSTOMER | (확인 필요) | SHIPTO_NAME | (확인 필요) |
| ETA_DATE | ETA | SITE_DESCRIPTION | Plant Site |
| ETD_DATE | ETD | SOLDTO_CODE | Sold to |
| EXPECTED_SHIP_DATE | (확인 필요) | STATUS | (확인 필요) |
| FCST_TYPE | FCST Type* | TO_SITE | To Site* |
| FROM_SITE | From Site* | TR_MODE | Trans Mode* |
| INCOTERMS | Incoterms* | YYYYMMDD | Shipment Date* |
| LAST_UPDATED_BY | Requestor | LT_TOTAL | L/T(Day) |
| LAST_UPDATED_DATE | Request Date | MKT_OWMER | MKT Owner |

타입: 메타(확인 필요) / 출처: META / division: 전체 / 편집: 확인 필요. 원천 `SSP.SSP0026_GET_REQUEST_DETAIL_PACK`.

### 4-5. `W/H stock` — META+코드연결 / 메타 필수+기본 19
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| (19컬럼 목록) | 확인 필요 — grid_effective.csv 잘림 | 메타 | META | 전체 | 확인 필요 |

원천 `SSP.SSP0015_GET_WH_STOCK`.

### 4-6. `W/H stock Detail` — META+코드연결 / 메타 25
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| (25컬럼 목록) | 확인 필요 — CSV 잘림 | 메타 | META | 전체 | 확인 필요 |

원천 SP 확인 필요.

### 4-7. `Hold stock` — META+코드연결 / 표시 10
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Div | 메타 | META | 전체 | 확인 필요 |
| FROM_SITE_NM | From Site | 메타 | META | 전체 | 확인 필요 |
| HOLD_QTY | Amend Qty* | 메타 | META | 전체 | 확인 필요 |
| HOLD_YYYYMMDD | Start Date | 메타 | META | 전체 | 확인 필요 |
| ITEM_ID | Model | 메타 | META | 전체 | 확인 필요 |
| LAST_UPDATE_DATE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| LAST_UPDATED_BY | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| NICK_NAME | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| RELEASE_YYYYMMDD | End Date* | 메타 | META | 전체 | 확인 필요 |
| REMARKS | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| (숨김) FROM_SITE, HOLD_ID | — | — | META | 전체 | — |

원천 `SSP.SSP0015_GET_BLOCK_STOCK`, 저장 `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA`.

### 4-8. `Hold stock Detail` — META+코드연결 / 표시 10
Hold stock과 컬럼이 같습니다. 라벨 차이: HOLD_QTY `Amend Qty`, RELEASE_YYYYMMDD `End Date` (`*` 없음). 타입: 메타 / 출처: META / division: 전체 / 편집: 확인 필요. 원천 `SSP.SSP0015_GET_BLOCK_STOCK`(FindData_BolckStockDetail_btnSearch).

### 4-9. `Stock Detail` — META+코드연결 / 표시 26 (shtMesStock)
| 컬럼 | 헤더 | 컬럼 | 헤더 |
|---|---|---|---|
| AVAILABLE_YN | (확인 필요) | LOT_TYPE | (확인 필요) |
| DIVISION_ID | (확인 필요) | MES_CHANGE_STATUS | (확인 필요) |
| FCS_HOLD_YN | (확인 필요) | MES_HOLD_RELEASE | (확인 필요) |
| FCS_SPECIAL_QTY | (확인 필요) | MES_HOLD_YN | (확인 필요) |
| FROM_SITE | Site | NICK_NAME | (확인 필요) |
| ITEM_ID | (확인 필요) | OWMS_STOCK_QTY | (확인 필요) |
| JUDG_VLD_DATE | (확인 필요) | QMS_HOLD_RELEASE | (확인 필요) |
| LAST_UPDATE_DATE | (확인 필요) | QMS_HOLD_YN | (확인 필요) |
| LAST_UPDATED_BY | (확인 필요) | REMARKS | (확인 필요) |
| LONGTERM_HOLD_YN | (확인 필요) | USER_MOD_RELEASE_DATE | User Modified Release Date* |
| LOT_ID | (확인 필요) | YYYYMMDD_LOT_ID_APPLIED_LT | D Day(Expected) |
| LOT_QTY_FCS | (확인 필요) | LOT_QTY_MES | (확인 필요) |
| LOT_QTY_MES_NG | (확인 필요) | LOT_QTY_TOT | (확인 필요) |

타입: 메타 / 출처: META / division: 전체 / 편집: 확인 필요. 원천 `SSP.SSP0015_GET_MES_STOCK`, 저장 `SSP.SSP0015_SAVE_MES_STOCK`.

### 4-10. `MES Stock Detail` — 메타 정의만 있고 코드 미참조(미사용 가능) / 표시 24
Stock Detail에서 LONGTERM_HOLD_YN, LOT_QTY_MES_NG를 뺀 24컬럼. CreateSpread에서 만들지 않습니다. TO-BE 이관 여부 확인 필요.

### 4-11. `SCS Stock Detail` — META+코드연결 / 표시 9
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| CUTOFF_DATE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| DIVISION_ID | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| HOLD_YN | Hold Y/N | 메타 | META | 전체 | 확인 필요 |
| LAST_UPDATE_DATE | Update Date | 메타 | META | 전체 | 확인 필요 |
| MODEL_ID | Model | 메타 | META | 전체 | 확인 필요 |
| PLANT_ID | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| PLANT_NAME | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| PROD_DATE | Production Date | 메타 | META | 전체 | 확인 필요 |
| QTY | (확인 필요) | 메타 | META | 전체 | 확인 필요 |

원천 `SSP.SSP0015_GET_SCS_STOCK`.

### 4-12. `Stock Location Detail` — META+코드연결 / 메타 20
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| AVAILABLE_DATE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| AVAILABLE_QTY | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| COMPANY_ID | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| CUTOFF_DATE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| DEFECT_QTY | Deffect Qty (원문 그대로) | 메타 | META | 전체 | 확인 필요 |
| DIVISION_ID | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| (나머지 14컬럼) | 확인 필요 — CSV 잘림 | 메타 | META | 전체 | 확인 필요 |

원천 `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL` (+ `SSP.SSP0002_GET_NERP_CODE`).

### 4-13. `WH In Plan Detail` — META+코드연결 / 메타 11 / **`drPgmAuthId != null`일 때만 생성**
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| (11컬럼 목록) | 확인 필요 | 메타 | META | 전체 | 확인 필요 |

원천 `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS`.

### 4-14. `Shipment Result` — META+코드연결 / 메타 19 → 표시 17
| 컬럼 | 헤더 | 타입 | 출처 | division | 편집 |
|---|---|---|---|---|---|
| CONFIRM_ID | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| DIVISION_ID | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| END_CUSTOMER | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| ERP_SO_NO | SO No | 메타 | META | 전체 | 확인 필요 |
| ETA_DATE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| ETD_DATE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| FROM_SITE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| INCOTERMS | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| ITEM_ID | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| NICK_NAME | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| QTY | Shipment Qty | 메타 | META | 전체 | 확인 필요 |
| SHIP_TYPE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| TEAM | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| TO_SITE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| TRANSPORT_MODE | (확인 필요) | 메타 | META | 전체 | 확인 필요 |
| TYPE | Status | 메타 | META | 전체 | 확인 필요 |
| YYYYMMDD | Shipment Date | 메타 | META | 전체 | 확인 필요 |
| SHIP_TO | Ship to | 메타 | HARDCODED 숨김 (4991) | 전체 | — |
| SHIPTO_DESCRIPTION | Ship to Name | 메타 | HARDCODED 숨김 (4992) | 전체 | — |

원천 `SSP.SSP0015_GET_SHIPMENT_RESULT` / `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER`(SCS).
> grid_effective에는 SHIP_TO / SHIPTO_DESCRIPTION 숨김이 다른 시트에도 붙어 있습니다. 근거 코드가 Shipment Result 전용 메서드라서, 정적 분석이 시트를 잘못 귀속한 것으로 보입니다 → 확인 필요.

### 4-15. `Shipment PSI(IT & Mobile)` — 메타 정의만 있고 코드 미참조(미사용 가능) / 표시 10
DIVISION_ID, FIGURE, FROM_SITE_NM, ITEM_ID, LT_DAY, MEASURE_NAME, NICK_NAME, PSI_NAME, TYPE, YEILD `Yeild(%)`. CreateSpread에서 만들지 않습니다. Measure 메타 12+1. 이관 여부 확인 필요.

> 별도 메타 프로그램 `SSP0015_TEMP2`에 Shipment Confirm Detail 31컬럼이 있습니다. 사용 여부 확인 필요.

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A01 | 화면 Load | `Form_Load` | InitControls, GetBucketType, SetChangedControl, GetDayRange, CreateSpread>InitSpread>GetSpdTitle | `biz:CommonData.CommonDataList` [PlanDateShip], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | cboPlanDate, cboBucketType, drpPeriod, spdMain/spdDetail 시트 |
| A02 | 팝업 Load | `Form_Load` (팝업 .ctor:207) | 팝업 초기화 | 없음 | 팝업 컨트롤 표시 (값 세팅은 확인 필요) |
| A03 | 툴바 조회 | FindButton | FindData_Main / _Packer / _Packer_Past, Re_Design>GetNERPCode, InitSpread>GetSpdTitle | `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER`, `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST`, `SSP.SSP0002_GET_NERP_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain |
| A04 | 툴바 저장(상단) | SaveButton | SaveData_Main | `SSP.SSP0015_SAVE_SHIPMENT_PSI` | 저장 후 동작 확인 필요 |
| A05 | 툴바 저장(Detail 40) | SaveButton | SaveData_Detail(Validation_Check) → 재조회 | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40`, `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA`, `SSP.SSP0015_SAVE_MES_STOCK`, `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0002_GET_NERP_CODE`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_MES_STOCK` | spdMain, spdDetail 재조회 |
| A06 | 툴바 저장(Detail Packer) | SaveButton | SaveData_Detail_Packer: chkSaveYN, EngProcessingChk, 저장, GetERPInterface(ChkConfirmChangeTime, GetErpSoNoCnt, GetShipmentStatusChk, SoNo/NonSoNo, GetErpIFCheckNew), 재조회 | `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK`, `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER`, `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME`, `SSP.SSP0015_GET_ERP_SO_NO_CNT`, `SSP.SSP0015_GET_SHIPMENT_STATUS`, `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM`, `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER`, `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail(Shipment Confirm Detail) 재조회 |
| A07 | 툴바 편집 | EditButton | PlanDateShip 확인, GetSSPUserCheck | `biz:CommonData.CommonDataList` [PlanDateShip], `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 가능 상태 (판정 확인 필요) |
| A08 | Division 변경 | `clbDivision_SelectedIndexChanged` | SetChangedControl > GetDayRange | `biz:CommonData.CommonDataList` [PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD` | cboPlanDate, drpPeriod |
| A09 | Plan-date 변경 | `CboPlanDate_SelectedIndexChanged` | GetDayRange | `SCP.SCM0001_GET_SCP_DAY_PERIOD` | drpPeriod |
| A10 | Bucket 변경 | `cboBucketType_SelectedIndexChanged` | SetSpreadColumn(추정 연계, 2116~2148) | 없음 | D_/W_/M_ 컬럼 Visible |
| A11 | Sum 체크 | `chkSum_CheckedChanged` | Sum 계열 컬럼 Visible | 없음 | spdMain 컬럼 |
| A12 | Measure 버튼 | `btnMeasure_Click` | InitSpread > GetSpdTitle | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdMain 재구성 |
| A13 | Model 선택 버튼 | `btnItemId_Click` | 확인 필요 (팝업으로 보임) | 없음 | txtItemId (확인 필요) |
| A14 | Detail Model 선택 | `BtnItemID2_Click` | 확인 필요 | 없음 | txtModel2 (확인 필요) |
| A15 | Requestor 선택 | `BtnRequestor_Click` | 확인 필요 | 없음 | txtRequestor (확인 필요) |
| A16 | Detail Search | `BtnSearch_Click` | 활성 시트별 FindData_* | `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_WH_STOCK`, `SSP.SSP0015_GET_BLOCK_STOCK`, `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SSP.SSP0015_GET_SCS_STOCK`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0026_GET_REQUEST_DETAIL_PACK`, `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS`, `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER`, `SSP.SSP0015_GET_SHIPMENT_RESULT`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | spdDetail 활성 시트 |
| A17 | 상단 셀 더블클릭 | `SpdMain_CellDoubleClick` | 행 키(DIVISION_ID/SITE/ITEM_ID/YYYYMMDD)로 Detail 조회. Comments(GAP/BEFORE_QTY/USER_ADD_QTY) 읽기 | `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL`, `SSP.SSP0015_GET_WH_STOCK`, `SSP.SSP0015_GET_MES_STOCK`, `SSP.SSP0015_GET_BLOCK_STOCK`, `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0015_GET_SCS_STOCK` | spdDetail. 팝업 여부 확인 필요 |
| A18 | 상단 시트 전환 | `SpdMain_ActiveSheetChanged` | LookupCommon, SetChangedControl, InitSpread | `biz:CommonData.CommonDataList` [LookupCommon], [PlanDateShip], `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 조회조건·헤더 재구성 |
| A19 | 하단 셀 클릭 | `SpdDetail_CellClick` | 셀 콤보 목록, 헤더 CheckBox 토글(IsLock=false) | `biz:CommonData.CommonDataList` [TransMode], [ShipToCodeByDivision] | 셀 콤보, 체크 |
| A20 | 하단 붙여넣기 | `SpdDetail_ClipboardPasted` | TransMode CODE 대조 | `biz:CommonData.CommonDataList` [TransMode] | 붙여넣은 셀 (처리 확인 필요) |
| A21 | 상단 TextTip | `spdMain_TextTipFetch` | 툴팁 표시 (내용 확인 필요) | 없음 | 툴팁 |
| A22 | 상단 스크롤 | `SpdMain_TopChange` | 확인 필요 (상·하 스크롤 동기화로 보이나 미확인) | 없음 | — |
| A23 | 하단 스크롤 | `SpdDetail_TopChange` | 확인 필요 | 없음 | — |
| A24 | 상단 편집모드 | `SpdMain_EditModeOn` | 확인 필요 | 없음 | — |
| A25 | 상단 셀 클릭 | `SpdMain_CellClick` | 확인 필요 | 없음 | — |
| A26 | 하단 콤보 선택 | `spdDetail_ComboSelChange` | 확인 필요 | 없음 | — |
| A27 | 하단 시트탭 클릭 | `SpdDetail_SheetTabClick` | 확인 필요 | 없음 | — |
| A28 | 하단 셀 더블클릭 | `SpdDetail_CellDoubleClick` | 확인 필요 | 없음 | — |
| A29 | 하단 시트 전환 | `SpdDetail_ActiveSheetChanged` | 확인 필요 (조회 바 컨트롤 전환으로 보이나 미확인) | 없음 | — |
| A30 | 하단 셀 편집 | `SpdDetail_EditChange` | 확인 필요 | 없음 | — |
| A31 | 하단 데이터 변경 | `shtDetail_Change` (dsdm.Changed) | 확인 필요 | 없음 | — |
| A32~A37 | 팝업 수량 변경 | `txtGap_Qty_TextChanged`, `txtBefore_Qty_TextChanged`, `txtProd_Qty_TextChanged`, `txtWHin_Qty_TextChanged`, `txtCurrent_Qty_TextChanged`, `txtChange_Qty_TextChanged` | 확인 필요 | 없음 | 팝업 수량 필드 |
| A38 | 팝업 변경수량 키입력 | `txtChange_Qty_KeyPress` | 입력 제한으로 보이나 확인 필요 | 없음 | — |
| A39 | 팝업 저장 | `btnButtonList_UsrButtonList_Click_Detected` | SaveData | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` | 팝업 저장 결과 (닫힘·재조회 확인 필요) |
| A40 | (진입점 미연결) | — | GetErpIFCheck / GetErpIFCheckNew_ / SCM_SYS_LOG_BATCH / GetDivision / SetChangedPeriod / NewNonSoNo | `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING`, `SCP.PR_SCM_SYS_LOG_BATCH`, `SCM.SCM0001_GET_DIVISION`, `biz:CommonData.CommonDataList` [PERIOD_{p:value}], [PERIOD2_{p:value}] | 런타임 사용 여부 확인 필요 |

## 6. 검증·메시지

| 검증 | 대상 | 근거 | 메시지 |
|---|---|---|---|
| 필수 조회조건 | Division*, Plan-date*, Period* | 라벨 `*` | 검증 코드·문구 확인 필요 |
| Detail 저장 검증 | confirm_id 기준 shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE | Validation_Check | 확인 필요 |
| SCS Confirm ID 체크 | Tables[0..1].CNT | chkSaveYN → `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` | 확인 필요 |
| 계획 진행 체크 | — | EngProcessingChk → `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` | 확인 필요 |
| 변경시각 체크 | — | ChkConfirmChangeTime → `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` | 확인 필요 |
| SO 건수 / 상태 체크 | CNT / CONFIRM_ID | `SSP.SSP0015_GET_ERP_SO_NO_CNT`, `SSP.SSP0015_GET_SHIPMENT_STATUS` | 확인 필요 |
| ERP I/F 차단 | BLOCK_YN, PERIOD | chkERPIFBlockYn | 확인 필요 |
| 붙여넣기 Trans Mode | CODE | SpdDetail_ClipboardPasted | 확인 필요 |
| 팝업 변경수량 입력 | — | txtChange_Qty_KeyPress | 확인 필요 |

> MSG 코드와 문구는 Fact Pack에 없습니다. SP 안의 검증(RAISERROR 등)도 미추출이므로 TO-BE 구현 전에 SP 원문을 먼저 대조해야 합니다.

## 7. 권한 (C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| R | FindButton, `BtnSearch_Click`, `SpdMain_CellDoubleClick` |
| C/U | SaveButton(SaveData_Main / SaveData_Detail / SaveData_Detail_Packer), 팝업 `btnButtonList_UsrButtonList_Click_Detected` |
| D | 별도 삭제 버튼 진입점 없음. 저장 경로 안의 `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`이 SSP_ANL_SHIP_CONFIRM에 DELETE |
| 편집 | EditButton > `SSP.SSP0002_GET_USER_INFO_LIST` |
| 시트 | `WH In Plan Detail`: `drPgmAuthId != null`일 때만 생성 |
| 잠금 | `siDetail.IsLock(SheetName)==false`일 때만 헤더 체크 토글 |
| 메타 | TB_FX_GroupMenuAuth 14행 / TB_FX_MenuItemInfo 2행 / TB_FX_ProgramInfo 2행. 플래그 값 확인 필요. MNU/BTN 메타는 Fact Pack에 없음 |

## 8. To-Be 전환 메모 (Wijmo · Oracle 관점)

| # | As-is | To-Be 고려 |
|---:|---|---|
| 1 | FpSpread 다중 시트(spdMain 2, spdDetail 11) | Wijmo FlexGrid + 시트 탭. 시트마다 그리드 인스턴스·컬럼 정의 분리 |
| 2 | 3단 ColumnHeaderSpan + "SUM" 헤더 | FlexGrid columnHeaders 행 3개 + allowMerging(ColumnHeaders) |
| 3 | MergePolicy.Always (상단 2시트) | allowMerging=Cells 와 컬럼 allowMerging |
| 4 | DB루프 일자 컬럼(B_ 숨김, SAT/SUN 색) | SCP0009_GET_SHEET_CALENDAR_3SPAN 결과로 컬럼을 동적으로 만들고, formatItem에서 헤더 색 지정 |
| 5 | SetSpreadColumn D_/W_/M_ Visible 토글 | Bucket·Sum 상태로 column.visible 다시 계산 |
| 6 | 헤더 CheckBox 전체 토글 | FlexGrid 헤더 셀 체크박스. IsLock은 시트 편집 가능 상태에 연결 |
| 7 | 셀 콤보(TransMode / ShipToCodeByDivision) | DataMap. 표시는 NAME |
| 8 | MSSQL SP (#임시테이블, STRING_SPLIT, 동적 SQL, MERGE) | Oracle PKG/SP 전환: # → GTT, STRING_SPLIT → 분할 함수/JSON_TABLE, 동적 SQL은 EXECUTE IMMEDIATE / REF CURSOR |
| 9 | 저장 SP 다단 호출(ERP I/F 체인) | 트랜잭션 경계·호출 순서를 As-is 원문으로 확정한 뒤 이관 (확인 필요) |
| 10 | 숨김 체크박스 4종 | UI는 숨기되 파라미터 사용 여부를 확정한 뒤 반영 |
| 11 | Comments 팝업 | Modal. 저장은 `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` |
| 12 | 메타 전용 시트 2종 / SSP0015_TEMP2 | 이관 제외 여부 결정 필요 |

## 9. 미확정

1. 조회조건 컨트롤의 실제 배치 좌표. Detail 조회 바 라벨 원문(clbResultType, txtModel2, btnItemID2, drpPeriod3, txtLotID). 팝업 라벨 원문
2. FindButton / SaveButton 분기 조건과 호출 순서
3. W/H stock, W/H stock Detail, Stock Location Detail, WH In Plan Detail 컬럼 전체
4. Shipment Confirm Detail 표시 40과 메타 39의 차이
5. 컬럼 타입·편집 가능 여부(메타 CELL_CONTROL_OBJECT_TYPE_CODE, Lock)
6. 엔드포인트 호출이 없는 핸들러들의 내부 동작
7. 팝업을 여는 경로, usrButton1의 용도
8. 메뉴 위치와 권한 플래그

=== FILE: unit_test.md ===
# SSP0015 Shipment PSI — 단위테스트

> 근거 열에는 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 기대결과에 "확인 필요"가 있으면, As-is 원문으로 기대값을 확정한 뒤 실행해야 합니다.
> 주석 처리된 호출은 테스트 대상이 아닙니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0015-001 | 초기화 | 로그인, SSP0015 메뉴 권한 있음 | 화면을 연다 | — | cboPlanDate에 PlanDateShip 코드 목록이 채워짐 | `Form_Load` > InitControls:568 `biz:CommonData.CommonDataList` [code=PlanDateShip] |
| TC-SSP0015-002 | 초기화 | 001과 같음 | 화면을 열고 cboBucketType 목록을 확인 | — | DAILY / WEEKLY / MONTHLY 코드가 표시됨 | `Form_Load` > GetBucketType `DM.DM0003_GET_BUCKET_TYPE_CODE` / SP DM0003_GET_BUCKET_TYPE_CODE |
| TC-SSP0015-003 | 초기화 | 001과 같음 | 화면을 열고 drpPeriod 기본값을 확인 | — | SP가 돌려준 기간이 drpPeriod에 세팅됨 | `Form_Load` > GetDayRange `SCP.SCM0001_GET_SCP_DAY_PERIOD` / SP SCM0001_GET_SCP_DAY_PERIOD |
| TC-SSP0015-004 | 초기화 | 001과 같음 | 화면을 열고 spdMain 헤더를 확인 | — | 3단 헤더 + SUM. `B_` 컬럼은 너비 0, 그 외 너비 70. SAT 헤더 파랑, SUN 헤더 빨강 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` / SP SCP0009_GET_SHEET_CALENDAR_3SPAN, 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-005 | 초기화 | 001과 같음 | spdMain 시트 탭을 확인 | — | 탭 2개: Shipment PSI(Mobility & IT), Shipment PSI(Packer). Shipment PSI(IT & Mobile)는 만들어지지 않음 | `Form_Load` CreateSpread:656/660, 시트 `Shipment PSI(Mobility & IT)`, `Shipment PSI(Packer)`, `Shipment PSI(IT & Mobile)` |
| TC-SSP0015-006 | 초기화 | drPgmAuthId 있는 사용자 | spdDetail 시트 탭을 확인 | — | Shipment Confirm Detail, Shipment Request Detail, W/H stock, W/H stock Detail, Hold stock, Hold stock Detail, Stock Detail, SCS Stock Detail, Stock Location Detail, WH In Plan Detail, Shipment Result가 만들어짐. MES Stock Detail은 만들어지지 않음 | `Form_Load` CreateSpread:665~683, 시트 `MES Stock Detail` |
| TC-SSP0015-007 | 초기화 | 001과 같음 | 조회조건 영역에서 chkMyModel, chkPartLeader, chkTeamLeader, chkDelegateeModel을 찾는다 | — | 4개 모두 화면에 보이지 않음. chkMyModel 값은 Checked=true | props(Visible=false), `Form_Load` |
| TC-SSP0015-008 | 초기화 | 상단 PSI 조회 완료 | Comments 팝업을 연다 (여는 경로 확인 필요) | — | 팝업이 뜨고 txtDivision_ID ~ rtxComments, btnButtonList가 표시됨 | 팝업 `Form_Load` (.ctor:207) |
| TC-SSP0015-009 | 이벤트 | 화면 로드 완료 | clbDivision 값을 바꾼다 | Division: 40 → 81 | PlanDateShip 재조회 → cboPlanDate 갱신, drpPeriod 재설정 | `clbDivision_SelectedIndexChanged` > SetChangedControl `biz:CommonData.CommonDataList` [PlanDateShip] > GetDayRange `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0015-010 | 이벤트 | 화면 로드 완료 | cboPlanDate 값을 바꾼다 | 다른 Plan-date | drpPeriod 재설정 | `CboPlanDate_SelectedIndexChanged` > GetDayRange `SCP.SCM0001_GET_SCP_DAY_PERIOD` |
| TC-SSP0015-011 | 이벤트 | 화면 로드 완료 | spdMain 시트를 Shipment PSI(Packer)로 바꾼다 | — | LookupCommon·PlanDateShip·DayRange를 다시 호출하고 헤더를 다시 구성함 | `SpdMain_ActiveSheetChanged` `biz:CommonData.CommonDataList` [LookupCommon] (1400/1452), SetChangedControl, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment PSI(Packer)` |
| TC-SSP0015-012 | 이벤트 | 011 수행 | spdMain 시트를 Shipment PSI(Mobility & IT)로 되돌린다 | — | 011과 같은 호출. Mobility 컬럼 구성 복원 | `SpdMain_ActiveSheetChanged`, 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-013 | 이벤트 | 화면 로드 완료 | btnMeasure를 누른다 | — | spdMain이 다시 구성됨 (Measure 선택 팝업 여부 확인 필요) | `btnMeasure_Click` > InitSpread > GetSpdTitle `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-014 | 이벤트 | 상단 조회 완료 | cboBucketType을 DAILY로 선택 | DAILY | D_·W_ 컬럼 Visible=true, M_ Sum 계열은 chkSum 값을 따름 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:2116/2121 |
| TC-SSP0015-015 | 이벤트 | 상단 조회 완료 | cboBucketType을 WEEKLY로 선택 | WEEKLY | D_ 숨김, W_ 표시, M_는 chkSum 값을 따름 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:2128/2132/2137 |
| TC-SSP0015-016 | 이벤트 | 상단 조회 완료 | cboBucketType을 MONTHLY로 선택 | MONTHLY | D_·W_ 숨김, M_ 표시 | `cboBucketType_SelectedIndexChanged`, SetSpreadColumn:2144/2148 |
| TC-SSP0015-017 | 이벤트 | Bucket=DAILY | chkSum을 체크 | Checked=true | Sum 계열 컬럼 표시 | `chkSum_CheckedChanged`, SetSpreadColumn:2121 |
| TC-SSP0015-018 | 이벤트 | 017 수행 | chkSum을 해제 | Checked=false | Sum 계열 컬럼 숨김 | `chkSum_CheckedChanged` |
| TC-SSP0015-019 | 이벤트 | 화면 로드 완료 | btnItemId를 누른다 | — | Model 선택 동작 (팝업 여부와 선택값 반영 위치 확인 필요). 엔드포인트 호출 없음 | `btnItemId_Click` |
| TC-SSP0015-020 | 이벤트 | 화면 로드 완료 | btnItemID2를 누른다 | — | 하단 Model 선택 동작 (확인 필요). 엔드포인트 호출 없음 | `BtnItemID2_Click` |
| TC-SSP0015-021 | 이벤트 | 화면 로드 완료 | btnRequestor를 누른다 | — | Requestor 선택 동작, txtRequestor 반영 (확인 필요) | `BtnRequestor_Click` |
| TC-SSP0015-022 | 이벤트 | 상단 조회 완료 | spdMain 셀에 마우스를 올린다 | — | TextTip 표시 (내용 확인 필요) | `spdMain_TextTipFetch` |
| TC-SSP0015-023 | 이벤트 | 상단 조회 완료(행 다수) | spdMain을 세로 스크롤 | — | As-is와 같은 동작 (내부 동작 확인 필요). 오류 없음 | `SpdMain_TopChange` |
| TC-SSP0015-024 | 이벤트 | 하단 조회 완료(행 다수) | spdDetail을 세로 스크롤 | — | As-is와 같은 동작 (확인 필요). 오류 없음 | `SpdDetail_TopChange` |
| TC-SSP0015-025 | 이벤트 | 편집 진입 완료 | spdMain 셀 편집을 시작한다 | — | 편집모드 진입 처리 (허용 셀 조건 확인 필요) | `SpdMain_EditModeOn` |
| TC-SSP0015-026 | 이벤트 | 상단 조회 완료 | spdMain 셀을 한 번 클릭 | — | As-is와 같은 동작 (확인 필요). 엔드포인트 호출 없음 | `SpdMain_CellClick` |
| TC-SSP0015-027 | 이벤트 | Shipment Confirm Detail 조회 완료 | spdDetail 콤보 셀 값을 고른다 | Trans Mode 값 | 선택값 반영 (연동 처리 확인 필요) | `spdDetail_ComboSelChange`, 시트 `Shipment Confirm Detail` |
| TC-SSP0015-028 | 이벤트 | 화면 로드 완료 | spdDetail 시트 탭을 누른다 | Hold stock 탭 | 시트 전환 처리 (확인 필요) | `SpdDetail_SheetTabClick`, 시트 `Hold stock` |
| TC-SSP0015-029 | 이벤트 | 하단 조회 완료 | spdDetail 셀을 더블클릭 | — | As-is와 같은 동작 (확인 필요) | `SpdDetail_CellDoubleClick` |
| TC-SSP0015-030 | 이벤트 | 화면 로드 완료 | spdDetail 활성 시트를 Stock Detail로 바꾼다 | — | 하단 조회 바 상태 전환 (확인 필요) | `SpdDetail_ActiveSheetChanged`, 시트 `Stock Detail` |
| TC-SSP0015-031 | 이벤트 | 편집 가능한 Detail 시트 | spdDetail 셀 값을 고친다 | 수량 변경 | 변경 표시 처리 (확인 필요) | `SpdDetail_EditChange` |
| TC-SSP0015-032 | 이벤트 | 031 수행 | dsdm 데이터 변경 이벤트 발생을 확인 | — | 변경 상태 반영 (확인 필요) | `shtDetail_Change` (dsdm.Changed) |
| TC-SSP0015-033 | 이벤트 | Shipment Confirm Detail 조회 완료 | TRANSPORT_MODE 셀을 클릭 | — | TransMode 코드로 셀 콤보 목록이 채워짐(NAME 표시) | `SpdDetail_CellClick`:8583 `biz:CommonData.CommonDataList` [code=TransMode] |
| TC-SSP0015-034 | 이벤트 | 033과 같음 | TO_SITE_SHIPTO_CODE 셀을 클릭 | — | ShipToCodeByDivision 목록이 채워짐 | `SpdDetail_CellClick`:8604 `biz:CommonData.CommonDataList` [code=ShipToCodeByDivision] |
| TC-SSP0015-035 | 이벤트 | Detail 시트 잠금 아님, 행 1개 이상 | 컬럼헤더 CheckBox(CHK `ALL`)를 두 번 누른다 | — | 1번째 클릭에서 전체 체크, 2번째 클릭에서 전체 해제 (값 토글) | `SpdDetail_CellClick`:8618/8653/8657, 시트 `Shipment Confirm Detail` |
| TC-SSP0015-036 | 이벤트 | `siDetail.IsLock(SheetName)==true` | 컬럼헤더 CheckBox를 누른다 | — | 토글되지 않음 | `SpdDetail_CellClick` (IsLock 분기) |
| TC-SSP0015-037 | 이벤트 | Shipment Confirm Detail 편집 가능 | Trans Mode 열에 값을 붙여넣는다 | 클립보드 Trans Mode 값 | TransMode CODE 목록과 대조 (불일치 처리 확인 필요) | `SpdDetail_ClipboardPasted`:8954 `biz:CommonData.CommonDataList` [code=TransMode] |
| TC-SSP0015-038 | 조회 | 시트 Mobility & IT, 필수조건 입력 | 툴바 조회 | Division=40, Plan-date, Period | 상단 PSI 데이터 표시 | FindButton > FindData_Main `SSP.SSP0015_GET_SHIPMENT_PSI` / SP SSP0015_GET_SHIPMENT_PSI, 시트 `Shipment PSI(Mobility & IT)` |
| TC-SSP0015-039 | 조회 | 시트 Packer | 툴바 조회 | Packer 조건 | Packer PSI 표시 | FindButton > FindData_Main_Packer `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` / SP SSP0015_GET_SHIPMENT_PSI_PACKER |
| TC-SSP0015-040 | 조회 | Packer, 과거 조건 (분기 조건 확인 필요) | 툴바 조회 | 과거 Plan-date | Past PSI 표시. NERP 코드 반영, 헤더 재구성 | FindButton > FindData_Main_Packer_Past `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST`, Re_Design > `SSP.SSP0002_GET_NERP_CODE` (SEGMENT2), `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-041 | 조회 | 데이터 없는 조건 | 툴바 조회 | 데이터 없는 Model | 빈 그리드. 오류 없음 (안내 메시지 확인 필요) | `SSP.SSP0015_GET_SHIPMENT_PSI` 빈 결과 |
| TC-SSP0015-042 | 조회 | SP 오류 유발(테스트 DB) | 툴바 조회 | — | 오류 메시지 표시, 그리드 유지 (문구 확인 필요) | `SSP.SSP0015_GET_SHIPMENT_PSI_PACKER` 오류 응답 |
| TC-SSP0015-043 | 조회 | 상단 조회 완료 | spdMain 셀 더블클릭 (Confirm 관련 Measure) | 행 DIVISION_ID/SITE/ITEM_ID/YYYYMMDD | Shipment Confirm Detail 조회 결과 표시 | `SpdMain_CellDoubleClick` > FindData_Detail `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| TC-SSP0015-044 | 조회 | 043과 같음 | W/H 재고 관련 셀 더블클릭 | 행 키 | W/H stock 조회 결과 | `SpdMain_CellDoubleClick` > FindData_WHstock `SSP.SSP0015_GET_WH_STOCK`, 시트 `W/H stock` |
| TC-SSP0015-045 | 조회 | 043과 같음 | MES 재고 관련 셀 더블클릭 | 행 키 | Stock Detail 조회 결과 | `SpdMain_CellDoubleClick` > FindData_mes_stock `SSP.SSP0015_GET_MES_STOCK` |
| TC-SSP0015-046 | 조회 | 043과 같음 | Hold 재고 관련 셀 더블클릭 | 행 키 | Hold stock 조회 결과 | `SpdMain_CellDoubleClick` > FindData_block_stock `SSP.SSP0015_GET_BLOCK_STOCK` |
| TC-SSP0015-047 | 조회 | 043과 같음 | 재고 위치 관련 셀 더블클릭 | 행 키 | Stock Location Detail 조회 결과, NERP 코드 반영 | `SpdMain_CellDoubleClick` > FindData_shtStockLocationDetail_btnSearch `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-048 | 조회 | 043과 같음 | SCS 재고 관련 셀 더블클릭 | 행 키 | SCS Stock Detail 조회 결과 | `SpdMain_CellDoubleClick` > FindData_ScsStock_btnSearch `SSP.SSP0015_GET_SCS_STOCK` |
| TC-SSP0015-049 | 조회 | 043과 같음 | 상단 재조회가 일어나는 셀 더블클릭 (조건 확인 필요) | 행 키 | 상단 PSI 재조회 | `SpdMain_CellDoubleClick` > FindData_Main `SSP.SSP0015_GET_SHIPMENT_PSI` |
| TC-SSP0015-050 | 조회 | Comments가 있는 셀 | spdMain 셀 더블클릭 | — | Comments의 GAP / BEFORE_QTY / USER_ADD_QTY를 읽음 (팝업 전달 여부 확인 필요) | `SpdMain_CellDoubleClick` (8290~8306) |
| TC-SSP0015-051 | 조회 | 활성 시트 Shipment Confirm Detail(40 계열) | drpPeriod2 입력 후 btnSearch 클릭 | Shipment Date 기간 | Confirm Detail 표시. 일부 컬럼 숨김 | `BtnSearch_Click` > FindData_Detail_btnSearch `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` / SP SSP0015_GET_SHIPMENT_CONFIRM_DETAIL, 시트 `Shipment Confirm Detail` |
| TC-SSP0015-052 | 조회 | 활성 시트 Shipment Confirm Detail(Packer 계열) | btnSearch 클릭 | Shipment Date 기간 | Packer Confirm Detail 표시 | `BtnSearch_Click` > FindData_Detail_Packer_btnSearch `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER` |
| TC-SSP0015-053 | 조회 | 활성 시트 Shipment Request Detail | txtRequestor 입력 후 btnSearch 클릭 | Requestor | 요청 상세 표시 | `BtnSearch_Click` > FindData_Request_Detail `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / SP SSP0026_GET_REQUEST_DETAIL_PACK, 시트 `Shipment Request Detail` |
| TC-SSP0015-054 | 조회 | 활성 시트 W/H stock | btnSearch 클릭 | txtModel2 | 창고 재고 표시 | `BtnSearch_Click` > FindData_WHstock `SSP.SSP0015_GET_WH_STOCK` |
| TC-SSP0015-055 | 조회 | 활성 시트 Hold stock Detail | btnSearch 클릭 | drpPeriod3 (매핑 확인 필요) | Hold 재고 상세 표시 | `BtnSearch_Click` > FindData_BolckStockDetail_btnSearch `SSP.SSP0015_GET_BLOCK_STOCK`, 시트 `Hold stock Detail` |
| TC-SSP0015-056 | 조회 | 활성 시트 Stock Detail | txtLotID 입력 후 btnSearch 클릭 | Lot ID | MES 재고 상세 표시 | `BtnSearch_Click` > FindData_MesStock_btnSearch `SSP.SSP0015_GET_MES_STOCK` |
| TC-SSP0015-057 | 조회 | 활성 시트 SCS Stock Detail | btnSearch 클릭 | txtModel2 | SCS 재고 표시 | `BtnSearch_Click` > FindData_ScsStock_btnSearch `SSP.SSP0015_GET_SCS_STOCK`, 시트 `SCS Stock Detail` |
| TC-SSP0015-058 | 조회 | 활성 시트 Stock Location Detail | btnSearch 클릭 | txtModel2 | 재고 위치 표시, NERP 반영 | `BtnSearch_Click` > FindData_shtStockLocationDetail_btnSearch `SSP.SSP0015_GET_STOCK_LOCATION_DETAIL`, `SSP.SSP0002_GET_NERP_CODE` |
| TC-SSP0015-059 | 조회 | 활성 시트 WH In Plan Detail (권한 있음) | btnSearch 클릭 | — | 입고계획 Comments 표시 | `BtnSearch_Click` > FindData_WHinPlanDetail_btnSearch `SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS` / SP SSP0015_GET_SHIPMENT_PSI_COMMENTS |
| TC-SSP0015-060 | 조회 | 활성 시트 Shipment Result (ERP 실적) | clbResultType 선택 후 btnSearch 클릭 | Result Type | 실적 표시. SHIP_TO, SHIPTO_DESCRIPTION 숨김 | `BtnSearch_Click` > FindData_ShipmentResult_btnSearch `SSP.SSP0015_GET_SHIPMENT_RESULT`:4991/4992 |
| TC-SSP0015-061 | 조회 | 활성 시트 Shipment Result (SCS 실적, 분기 조건 확인 필요) | btnSearch 클릭 | Result Type | SCS 실적 표시, 헤더 재구성 | `BtnSearch_Click` > FindData_ShipmentSCSResult_btnSearch `SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-062 | 조회 | 활성 Detail 시트 아무거나 | 데이터 없는 조건으로 btnSearch 클릭 | 데이터 없는 Lot | 빈 그리드, 오류 없음 | `BtnSearch_Click` 빈 결과 (`SSP.SSP0015_GET_MES_STOCK`) |
| TC-SSP0015-063 | 권한 | 편집 권한 있는 사용자 | 툴바 Edit | — | PlanDateShip 확인, 사용자 정보 조회 뒤 편집 가능 상태 | EditButton:1753/1757 `biz:CommonData.CommonDataList` [PlanDateShip], GetSSPUserCheck `SSP.SSP0002_GET_USER_INFO_LIST` / SP SSP0002_GET_USER_INFO_LIST |
| TC-SSP0015-064 | 권한 | 사용자 그룹 정보 없음 | 툴바 Edit | — | 사용자 조회 결과가 비었을 때 처리 (차단·메시지 확인 필요) | `SSP.SSP0002_GET_USER_INFO_LIST` 빈 결과 |
| TC-SSP0015-065 | 저장 | 상단 PSI 편집 완료 | 툴바 저장 | 입고 수량·Comment 변경 | SSP_ANL_SHIP_PLAN_40 / _WH_IN_CMT 갱신, 이력(_WH_IN_H, _WH_IN_CMT_H)과 SCM_SYS_LOG_BATCH 기록 | SaveButton > SaveData_Main `SSP.SSP0015_SAVE_SHIPMENT_PSI` / SP SSP0015_SAVE_SHIPMENT_PSI |
| TC-SSP0015-066 | 저장 | Shipment Confirm Detail(40) 편집, 필수항목 입력 | 툴바 저장 | Shipment Qty, Shipment Date, Trans Mode, Ship to | SSP_ANL_SHIP_CONFIRM 반영, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN 적재, DM_PLN_MKT_FCST_CONFIRM 반영. 저장 후 상단·Detail 재조회 | SaveButton > SaveData_Detail `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` / SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40, 재조회 `SSP.SSP0015_GET_SHIPMENT_PSI`, `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL` |
| TC-SSP0015-067 | 저장 | 066과 같지만 Trans Mode 빈칸 | 툴바 저장 | TRANSPORT_MODE='' | 검증에 걸려 저장 SP를 호출하지 않음 (메시지 확인 필요) | SaveData_Detail > Validation_Check (shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE) |
| TC-SSP0015-068 | 저장 | Hold stock 시트에서 행 편집 | 툴바 저장 | Amend Qty, End Date | SSP_ANL_HOLD_STOCK UPDATE/INSERT, 로그 기록 | SaveButton > SaveData_Detail:6011 `SSP.SSP0015_SAVE_BLOCK_STOCK_DATA` / SP SSP0015_SAVE_BLOCK_STOCK_DATA, 시트 `Hold stock` |
| TC-SSP0015-069 | 저장 | Stock Detail 편집 | 툴바 저장 | User Modified Release Date | SSP_ANL_MES_FCS_STOCK_40_C, SSP_ANL_SHIP_PLAN_40 MERGE. MES 재고 재조회 | SaveButton > SaveData_Detail:6112/6219 `SSP.SSP0015_SAVE_MES_STOCK` / SP SSP0015_SAVE_MES_STOCK, 재조회 `SSP.SSP0015_GET_MES_STOCK` |
| TC-SSP0015-070 | 저장 | Packer Confirm Detail 편집 | 툴바 저장 | Confirm ID | SCS Confirm ID 체크(CNT) 결과에 따라 진행 또는 중단 (기준 확인 필요) | SaveData_Detail_Packer > chkSaveYN `SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK` / SP SSP0202_GET_SCS_CONFIRM_ID_CHECK |
| TC-SSP0015-071 | 저장 | 070 통과 | 저장 계속 | — | 계획 진행 중 여부 체크 (진행 중일 때 동작 확인 필요) | SaveData_Detail_Packer > EngProcessingChk `SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK` / SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| TC-SSP0015-072 | 저장 | 071 통과 | 저장 계속 | — | SSP_ANL_SHIP_CONFIRM 반영, XIF_ERP_PACK_SHIP_PLAN_S_SN·XIF_SCS_PACK_SHIP_PLAN_S_SN·SSP_MST_SEND_MAIL_REQ 적재 | SaveData_Detail_Packer:5602 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` / SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER |
| TC-SSP0015-073 | 저장 | 072 수행, 변경 요청 있음 | ERP 인터페이스 단계 | — | 확정 변경시각 체크 수행 | GetERPInterface > ChkConfirmChangeTime `SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME` / SP SCM_SSP_CHECK_CONFIRM_CHANGETIME |
| TC-SSP0015-074 | 저장 | 073과 같음 | ERP 인터페이스 단계 | — | SO 건수(CNT) 조회 결과로 SoNo/NonSoNo 경로가 결정됨 (기준 확인 필요) | GetERPInterface > GetErpSoNoCnt `SSP.SSP0015_GET_ERP_SO_NO_CNT` / SP SSP0015_GET_ERP_SO_NO_CNT |
| TC-SSP0015-075 | 저장 | 073과 같음 | ERP 인터페이스 단계 | — | 출하 상태 Tables[0..2].CONFIRM_ID 확인 | GetERPInterface > GetShipmentStatusChk `SSP.SSP0015_GET_SHIPMENT_STATUS` / SP SSP0015_GET_SHIPMENT_STATUS |
| TC-SSP0015-076 | 저장 | ERP 오류 건 존재 | ERP 인터페이스 단계 | — | SSP_ANL_SHIP_ERP_ERROR_CONFIRM INSERT, CHG_REQ / CHG_REQ_DE UPDATE | GetERPInterface:6665 `SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` / SP SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM |
| TC-SSP0015-077 | 저장 | 확정 삭제 대상 존재 | ERP 인터페이스 단계 | — | SSP_ANL_SHIP_CONFIRM UPDATE/DELETE, XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT | GetERPInterface:6706 `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM` / SP SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM |
| TC-SSP0015-078 | 저장 | SO No 없음 | ERP 인터페이스 NonSoNo 경로 | — | CHG_REQ / CHG_REQ_DE INSERT. 40은 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, Packer는 XIF_ERP_PACK / XIF_SCS_PACK 적재 | NonSoNo:6843 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING` / SP SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING, :6847 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` / SP SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER |
| TC-SSP0015-079 | 저장 | SO No 있음 | ERP 인터페이스 SoNo 경로 | — | 078과 같은 Drafting SP 호출 | SoNo:7076 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, :7080 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` |
| TC-SSP0015-080 | 저장 | 079 수행 | GetErpIFCheckNew 단계 | — | 확정 삭제 처리 후 CHG 배치. XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT, CHG_REQ_DE UPDATE | GetErpIFCheckNew:7363 `SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM`, :7389/7419 `SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH` / SP PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH |
| TC-SSP0015-081 | 저장 | 072~080 완료 | 저장 완료 후 확인 | — | Packer Confirm Detail 재조회, 헤더 재구성 | SaveData_Detail_Packer > FindData_Detail_Packer_btnSearch `SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0015-082 | 저장 | SP 오류 유발(테스트 DB) | 툴바 저장 | — | 오류 메시지 표시, 부분 반영 없음 (트랜잭션 범위 확인 필요) | `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` 오류 응답 |
| TC-SSP0015-083 | 저장 | ERP I/F 차단 데이터(BLOCK_YN) 존재 | Packer 저장 | — | 차단 여부 판정 (원천과 동작 확인 필요) | chkERPIFBlockYn (BLOCK_YN, PERIOD) |
| TC-SSP0015-084 | 이벤트 | 팝업 열림 | txtGap_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtGap_Qty_TextChanged` |
| TC-SSP0015-085 | 이벤트 | 팝업 열림 | txtBefore_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtBefore_Qty_TextChanged` |
| TC-SSP0015-086 | 이벤트 | 팝업 열림 | txtProd_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtProd_Qty_TextChanged` |
| TC-SSP0015-087 | 이벤트 | 팝업 열림 | txtWHin_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtWHin_Qty_TextChanged` |
| TC-SSP0015-088 | 이벤트 | 팝업 열림 | txtCurrent_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtCurrent_Qty_TextChanged` |
| TC-SSP0015-089 | 이벤트 | 팝업 열림 | txtChange_Qty 값을 바꾼다 | 숫자 | 연동 처리 (확인 필요) | `txtChange_Qty_TextChanged` |
| TC-SSP0015-090 | 이벤트 | 팝업 열림 | txtChange_Qty에 문자를 입력 | `abc` | 입력 제한 여부 (확인 필요) | `txtChange_Qty_KeyPress` |
| TC-SSP0015-091 | 저장 | 팝업에 rtxComments 입력 | btnButtonList 저장 클릭 | Comment, 변경수량 | SSP_ANL_SHIP_PLAN_40 UPDATE, _WH_IN_CMT UPDATE/INSERT, 이력·로그 기록 | `btnButtonList_UsrButtonList_Click_Detected` > SaveData:333 `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` / SP SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |
| TC-SSP0015-092 | 저장 | SP 오류 유발 | 팝업 btnButtonList 저장 | — | 오류 메시지, 팝업 유지 (확인 필요) | `SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS` 오류 응답 |
| TC-SSP0015-093 | 저장 | 진입점 미연결 확인용 | 런타임 추적(SQL 로그)으로 호출 여부 확인 | Packer/40 저장 전체 시나리오 | 호출 0건이면 미사용으로 확정. 호출되면 CHG_REQ / CHG_REQ_DE UPDATE 검증 | GetErpIFCheck:7285, GetErpIFCheckNew_:9731 `SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING` / SP SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING |
| TC-SSP0015-094 | 저장 | 093과 같음 | 런타임 추적 | 저장 시나리오 | 호출 여부 확정. 호출되면 SCM_SYS_LOG_BATCH INSERT | SCM_SYS_LOG_BATCH:7876 `SCP.PR_SCM_SYS_LOG_BATCH` / SP PR_SCM_SYS_LOG_BATCH |
| TC-SSP0015-095 | 조회 | 093과 같음 | 런타임 추적 | 화면 로드·Division 변경 | 호출 여부 확정. 호출되면 SCM_MST_DIVISION 결과가 clbDivision에 반영되는지 확인 | GetDivision:9192 `SCM.SCM0001_GET_DIVISION` / SP SCM0001_GET_DIVISION |
| TC-SSP0015-096 | 조회 | 093과 같음 | 런타임 추적 | — | 호출 여부 확정. FROM_VALUE / TO_VALUE 사용처 확인 | SetChangedPeriod:9207/9211 `biz:CommonData.CommonDataList` [PERIOD_{p:value}], [PERIOD2_{p:value}] |
| TC-SSP0015-097 | 저장 | 093과 같음 | 런타임 추적 | — | NewNonSoNo 호출 여부 확정 | NewNonSoNo:9611/9615 `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING`, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER` |
| TC-SSP0015-098 | 그리드 | 상단 조회 완료 | Shipment PSI(Mobility & IT) 컬럼 확인 | — | 표시 10: Div, Figure, From Site, Model, Aging L/T, Measure, Nick Name, PSI, TYPE, Yield(%). 셀 병합(Always) | 시트 `Shipment PSI(Mobility & IT)`, SetSheetHeaderColumn InitSpread:759, MergePolicy 776/778 |
| TC-SSP0015-099 | 그리드 | Packer 조회 완료 | Shipment PSI(Packer) 컬럼 확인 | — | 표시 8: Div, Figure, From Site, Model, Measure(MEASURE), Nick Name, PSI, TYPE. LT_DAY / YEILD 숨김 | 시트 `Shipment PSI(Packer)`, InitSpread:786, MergePolicy 803/805 |
| TC-SSP0015-100 | 그리드 | ichkbtn==1 상태 (조건 확인 필요) | Packer 시트와 Mobility 시트의 SO No 계열 컬럼 폭 비교 | — | Packer 시트 Width 80, 다른 시트 0. ichkbtn≠1이면 반대 | SetSoNoColumnVisible:9778~9793, 시트 `Shipment PSI(Packer)` |
| TC-SSP0015-101 | 그리드 | 화면 로드 | 메타 전용 시트 확인 | — | Shipment PSI(IT & Mobile) 탭이 없음 (이관 여부 결정 후 확정) | 시트 `Shipment PSI(IT & Mobile)` (메타 정의만, 코드 미참조) |
| TC-SSP0015-102 | 그리드 | Confirm Detail 조회 완료 | 컬럼 확인 | — | 표시 40 (§4-3 목록). SHIPTO_DESCRIPTION 숨김. 메타 39와 1컬럼 차이 원인 확인 | 시트 `Shipment Confirm Detail`, FindData_Detail Visible 3218~3221 |
| TC-SSP0015-103 | 그리드 | Request Detail 조회 완료 | 컬럼 확인 | — | 표시 34 (§4-4 목록) | 시트 `Shipment Request Detail` |
| TC-SSP0015-104 | 그리드 | W/H stock 조회 완료 | 컬럼 확인 | — | 메타 19컬럼 표시 (목록은 메타 원문으로 확정) | 시트 `W/H stock` |
| TC-SSP0015-105 | 그리드 | W/H stock Detail 탭 선택 | 컬럼 확인 | — | 메타 25컬럼 표시 (목록·원천 SP 확인 필요) | 시트 `W/H stock Detail` |
| TC-SSP0015-106 | 그리드 | Hold stock 조회 완료 | 컬럼 확인 | — | 표시 10. 라벨 Amend Qty*, End Date*. FROM_SITE, HOLD_ID 숨김 | 시트 `Hold stock` |
| TC-SSP0015-107 | 그리드 | Hold stock Detail 조회 완료 | 컬럼 확인 | — | 표시 10. 라벨 Amend Qty, End Date (`*` 없음) | 시트 `Hold stock Detail` |
| TC-SSP0015-108 | 그리드 | Stock Detail 조회 완료 | 컬럼 확인 | — | 표시 26. LONGTERM_HOLD_YN, LOT_QTY_MES_NG 포함 | 시트 `Stock Detail` |
| TC-SSP0015-109 | 그리드 | 화면 로드 | 메타 전용 시트 확인 | — | MES Stock Detail 탭이 없음 (이관 여부 결정 후 확정) | 시트 `MES Stock Detail` (메타 정의만) |
| TC-SSP0015-110 | 그리드 | SCS Stock Detail 조회 완료 | 컬럼 확인 | — | 표시 9: CUTOFF_DATE, DIVISION_ID, Hold Y/N, Update Date, Model, PLANT_ID, PLANT_NAME, Production Date, QTY | 시트 `SCS Stock Detail` |
| TC-SSP0015-111 | 그리드 | Stock Location Detail 조회 완료 | 컬럼 확인 | — | 메타 20컬럼. 라벨 `Deffect Qty` 원문 유지 | 시트 `Stock Location Detail` |
| TC-SSP0015-112 | 그리드 | WH In Plan Detail 조회 완료 | 컬럼 확인 | — | 메타 11컬럼 표시 (목록 확인 필요) | 시트 `WH In Plan Detail` |
| TC-SSP0015-113 | 그리드 | Shipment Result 조회 완료 | 컬럼 확인 | — | 표시 17. SHIP_TO `Ship to`, SHIPTO_DESCRIPTION `Ship to Name` 숨김 | 시트 `Shipment Result`, FindData_ShipmentResult_btnSearch:4991/4992 |
| TC-SSP0015-114 | 권한 | drPgmAuthId == null 사용자 | 화면 열기 | — | WH In Plan Detail 탭이 만들어지지 않음 | CreateSpread:680, 시트 `WH In Plan Detail` |
| TC-SSP0015-115 | 권한 | 메뉴 권한 없는 그룹 | 메뉴 접근 | — | 접근·버튼 제한 (TB_FX_GroupMenuAuth 값으로 기대값 확정 필요) | TB_FX_GroupMenuAuth 14행, `Form_Load` |
| TC-SSP0015-116 | division | Division=40 | 모든 Detail 시트를 조회 | 40 | 시트별 표시 컬럼 수가 §12 집계와 같음 (예: Shipment Confirm Detail 40, Shipment Result 17) | grid_rule/grid_effective 40열, 시트 `Shipment Confirm Detail`, `Shipment Result` |
| TC-SSP0015-117 | division | Division=81 | 116과 같은 절차 | 81 | 컬럼 수가 40과 같음 | grid_effective 81열, `SpdDetail_CellClick` [ShipToCodeByDivision] |
| TC-SSP0015-118 | division | Division=82 | 116과 같은 절차 | 82 | 컬럼 수가 40과 같음 | grid_effective 82열 |
| TC-SSP0015-119 | division | Division=EE | 116과 같은 절차 | EE | 컬럼 수가 40과 같음 | grid_effective EE열 |
| TC-SSP0015-120 | division | Division 81_HD / EE_UC 등 하위 division | 116과 같은 절차 | 81_HD, EE_UC | 컬럼 수가 40과 같음 (Packer / 40 저장 분기와의 관계는 확인 필요) | grid_effective 81_HD·EE_UC열, `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER` / `SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40` |

### 커버리지 점검
| 대상 | 수 | 커버 TC |
|---|---:|---|
| 이벤트 핸들러 | 33 | 001~037, 084~091 (`Form_Load` 001·008) |
| 엔드포인트 | 39 | 001~004, 009~013, 033~034, 037~081, 091~097 |
| 시트 | 15 | 004~006, 011, 028, 030, 044, 051~061, 098~114, 116 |
| division | 14 (변형 없음) | 116~120 |
| 빈 결과 / 오류 | — | 041, 042, 062, 064, 082, 092 |
