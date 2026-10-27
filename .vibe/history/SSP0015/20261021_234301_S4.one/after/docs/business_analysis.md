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
