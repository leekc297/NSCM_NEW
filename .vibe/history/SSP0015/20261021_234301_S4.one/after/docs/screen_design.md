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
