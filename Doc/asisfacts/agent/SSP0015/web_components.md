# SSP0015 화면 컴포넌트 매핑 (WinForms → React/Wijmo)

> 라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. props.csv가 잘려서 라벨을 확인하지 못한 항목은 '확인 필요'로 표기했습니다.

## 1. 화면 배치

| 영역 | As-is | 크기 근거 | TO-BE 권장 |
|---|---|---|---|
| 조회조건 | usrConditionPanel1 (Dock Top, HidePanel 타입) > usrLayoutControl2 (Dock Top) | Size(1370,79) / (1370,73) | 접이식 SearchCondition 영역 |
| 본문 | splitContainer1 (Dock Fill, **Orientation=Horizontal → 상/하 분할**) | Size(1370,570), SplitterDistance=301 | 상/하 Splitter |
| 상단 패널(Panel1) | spdMain (Dock Fill) | 301 / 570 ≈ **52.8%** | 상단 Grid (시트 탭 2개) |
| 하단 패널(Panel2) | usrLayoutControl3 (Dock Top, 높이 40) + spdDetail (Dock Fill, 높이 225) | 나머지 ≈ **47.2%** (spliter 두께 포함 정확 값 확인 필요) | 하단 Detail 조회조건 바 + 탭 Grid (시트 11개) |
| 팝업 | SSP0015_ShipmentPSICommentsPopup | 크기 확인 필요 | Modal (Comments) |

## 2. 컨트롤 → 컴포넌트 매핑

### 2-1. 상단 조회조건 (usrLayoutControl2)
| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 후보 | 비고 |
|---|---|---|---|---|---|
| clbDivision | UsrCombo | `Division*` (lblCombo1) | 162×20 | ComboBox (필수) | 이름은 clb지만 타입은 UsrCombo. 변경 시 PlanDate / DayRange 갱신 |
| cboPlanDate | UsrCombo | `Plan-date*` (PlanDate) | 150×20 | ComboBox (필수) | 공통코드 PlanDateShip. 변경 시 GetDayRange |
| drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | 205×20 | DateRange (필수) | 기본값은 SCM0001_GET_SCP_DAY_PERIOD |
| clbPlantSite | UsrCheckedList | `From Site` (layoutControlItem7) | 189×21 | MultiSelect | 데이터 원천 확인 필요 (GetSSPInnerTable 가능성) |
| cboBucketType | UsrCombo | `Bucket` (lblBucket) | 137×20 | ComboBox | DM0003_GET_BUCKET_TYPE_CODE. DAILY/WEEKLY/MONTHLY 컬럼 전환 |
| chkSum | UsrCheckBox | `Sum` (Text) | 84×25 | CheckBox | Sum 컬럼 Visible 제어 |
| btnMeasure | UsrButton | 라벨 없음 (layoutControlItem10) | 39×25 | IconButton | 클릭 시 InitSpread 재구성. Measure 선택 팝업 여부 확인 필요 |
| txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 100×21 | MultiLine Text | |
| btnItemId | UsrButton | 라벨 없음 (layoutControlItem2) | 39×24 | 팝업 버튼 | Model 선택 팝업으로 보이나 확인 필요 |
| chkMyModel | UsrCheckBox | `My Model` / Checked=true / **Visible=false** | 110×23 | (숨김) | LayoutItem Text "layoutControlItem8" |
| chkPartLeader | UsrCheckBox | `Part Leader` / **Visible=false** | 110×23 | (숨김) | |
| chkTeamLeader | UsrCheckBox | `Team Leader` / **Visible=false** | 110×23 | (숨김) | |
| chkDelegateeModel | UsrCheckBox | `Delegatee Model` / **Visible=false** | 136×23 | (숨김) | |
| usrButton1 | UsrButton | 확인 필요 | 75×23 | — | parent 없음. 미사용 가능성 → 확인 필요 |

### 2-2. 하단 Detail 조회 바 (usrLayoutControl3, Panel2 상단)
| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 후보 |
|---|---|---|---|---|
| drpPeriod2 | UsrDateRangePicker | `Shipment Date` (layoutControlItem11) | 197×20 | DateRange |
| txtRequestor | UsrTextBox | LayoutItem `Requestor` (Text 원문 확인 필요) | 20×20 | Text |
| btnRequestor | UsrButton | 라벨 없음 (layoutControlItem9) | 39×24 | 사용자 선택 팝업 버튼 |
| clbResultType | UsrCheckedList | 확인 필요 | 104×21 | MultiSelect |
| txtModel2 | UsrMultiLineEditor | 확인 필요 | 264×21 | MultiLine Text |
| btnItemID2 | UsrButton | 확인 필요 | 39×25 | 팝업 버튼 |
| drpPeriod3 | UsrDateRangePicker | 확인 필요 | 197×20 | DateRange |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 207×21 | MultiLine Text |
| btnSearch | SimpleButton | `Search` | 47×25 | Button (Detail 시트별 조회) |

> layoutControlItem4 / 5 / 14 / 15 / 3 / 17의 Text와 Control 매핑은 props.csv가 잘려서 확인하지 못했습니다 → 확인 필요.

### 2-3. Grid
| As-is | 유형 | TO-BE |
|---|---|---|
| spdMain (+spdMain_Sheet1) | FpSpread, 시트 2 | Wijmo FlexGrid + 시트 탭, 3단 컬럼헤더, MergePolicy Always → allowMerging |
| spdDetail (+spdDetail_Sheet1) | FpSpread, 시트 11 | Wijmo FlexGrid + 시트 탭 (탭별 Grid) |

### 2-4. Comments 팝업 (SSP0015_ShipmentPSICommentsPopup)
| As-is 컨트롤 | 유형 | TO-BE 후보 | 비고 |
|---|---|---|---|
| txtDivision_ID, txtFrom_Site, txtItem_ID, txtPlan_Date, txtDate, txtMeasure | UsrTextBox | ReadOnly Text (추정) | 라벨 원문 확인 필요 |
| txtGap_Qty, txtBefore_Qty, txtProd_Qty, txtWHin_Qty, txtCurrent_Qty | UsrTextBox | Number Text | TextChanged 핸들러 있음 |
| txtChange_Qty | UsrTextBox | Number Input | TextChanged + KeyPress(입력 제한으로 보이나 확인 필요) |
| rtxComments | RichTextBox | TextArea | |
| usrLabel1 | UsrLabel | Label | Text 확인 필요 |
| btnButtonList | UsrButtonList | 버튼 그룹 (저장) | → SSP0015_SAVE_SHIPMENT_PSI_COMMENTS |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

규칙: 메타 `DIVISION_ID` 빈값 = 전체, VISIBLE_FLAG/VALID_YN='Y', USER_SELECTABLE_FLAG='N' = 필수, DEFAULT_FLAG='Y' = 기본. **14개 division 모두 같은 결과**이므로 division 열은 생략했습니다.

### 3-1. `Shipment PSI(Mobility & IT)` — spdMain 시트 0 / META+코드연결 / 표시 10
- 표시(기본): DIVISION_ID `Div`, FIGURE `Figure`, FROM_SITE_NM `From Site`, ITEM_ID `Model`, LT_DAY `Aging L/T`, MEASURE_NAME `Measure`, NICK_NAME `Nick Name`, PSI_NAME `PSI`, TYPE `TYPE`, YEILD `Yield(%)`
- 숨김: FROM_SITE `Site`, LT_UPDATE_YN, MEASURE, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN
- 코드: SetSheetHeaderColumn(헤더 3행), InitSpreadDateColumn(일자 컬럼 DB루프), SetSpreadColumn(Bucket/Sum), MergePolicy.Always
- Measure 메타(SCM_MST_SHEET_MEASURE): 필수+기본 12 / 선택 1

### 3-2. `Shipment PSI(Packer)` — spdMain 시트 1 / META+코드연결 / 표시 8
- 표시: DIVISION_ID `Div`, FIGURE `Figure`, FROM_SITE_NM `From Site`, ITEM_ID `Model`, MEASURE `Measure`, NICK_NAME `Nick Name`, PSI_NAME `PSI`, TYPE `TYPE`
- 숨김: FROM_SITE, LT_DAY, LT_UPDATE_YN, MEASURE_NAME, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SHIP_FROZEN, YEILD
- Mobility 시트와 다른 점: MEASURE를 표시하고 MEASURE_NAME은 숨김. LT_DAY / YEILD 숨김
- Measure 메타: 6 / 0
- SetSoNoColumnVisible: ichkbtn==1이면 Packer 시트 Width 80, 다른 시트 0 (반대 조건에서는 반대). 대상 컬럼명 확인 필요

### 3-3. `Shipment PSI(IT & Mobile)` — 메타 정의만 있고 코드 미참조(미사용 가능) / 표시 10
- 표시: DIVISION_ID, FIGURE, FROM_SITE_NM, ITEM_ID, LT_DAY, MEASURE_NAME, NICK_NAME, PSI_NAME, TYPE, YEILD `Yeild(%)`
- CreateSpread에서 생성되지 않습니다. TO-BE 이관 대상인지 확인 필요

### 3-4. `Shipment Confirm Detail` — spdDetail / META+코드연결 / 표시 40 (메타 필수+기본 39 — 차이 확인 필요)
- 표시(기본): ATTRIBUTE10, attribute3 `PLM status`, attribute6 `OQC Result`, CHANGE_REASON_CODE `Change Reason`, CHANGE_REASON_DETAIL `Reason Detail`, CHANGE_REQ_NO `Change Request No`, CONFIRM_ID `Confirm/Plan ID`, DIVISION_ID `Division`, END_CUSTOMER, ERP_SO_NO `SO No`, ETA, ETD, Expected_Shipping_Date, FCST_TYPE, FROM_SITE_DESCRIPTION `From Site`, INCOTERMS, ITEM_ID `Model`, LT_DAY `L/T(Day)`, MODEL_USER `Model PIC`, MTK_OWNER `MKT Owner`, NICK_NAME, REMARKS, REMARKS2 `Building`, REMARKS3 `Customer Requirement`, REQUESTOR `Shipment Requestor`, RTF3 `RTF`, RTF4 `RTF ETD`, RTF5 `RTF QTY`, RTF6 `RTF Detail`, SHIPMENT_CONFIRM_QTY `Shipment Qty`, SHIPMENT_DATE, SHIPMENT_STATUS `Status`, SOLDTO_DESCRIPTION `Sold To Party`, TEAM, TO_SITE_DESCRIPTION `To Site`, TO_SITE_SHIPTO_CODE `Ship to`, TO_SITE_SOLDTO_CODE `Sold to`, TRANSPORT_MODE `Trans Mode`, UPDATED_BY, UPDATED_DATE
- 기본 → 코드에서 숨김: SHIPTO_DESCRIPTION `Ship To Party`
- 숨김(메타): BEFORE_QTY, BOD_ID, CHANGE_TYPE, CHECK_NEED_YN, CHK `ALL`, EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE `Shipment Date*`, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, PROJECT_CODE, PROJECT_NAME, TO_SITE
- 코드: FindData_Detail / _btnSearch / _Packer_btnSearch에서 Visible=false 다수(대상 확인 필요). SpdDetail_CellClick 헤더 CheckBox 토글. TransMode / ShipToCodeByDivision 셀 콤보
- 메타 별도 프로그램: `SSP0015_TEMP2`의 Shipment Confirm Detail 31컬럼(사용 여부 확인 필요)

### 3-5. `Shipment Request Detail` — META+코드연결 / 표시 34 / 행높이 60
- 표시: ATTRIBUTE3 `RTF`, ATTRIBUTE4 `RTF ETD`, ATTRIBUTE5 `RTF QTY`, ATTRIBUTE6 `RTF Detail`, BOD_ID, CHANGE_REQUEST_NO, DIVISION_ID `Div*`, EDIT_FLAG, END_CUSTOMER, ETA_DATE `ETA`, ETD_DATE `ETD`, EXPECTED_SHIP_DATE, FCST_TYPE `FCST Type*`, FROM_SITE `From Site*`, INCOTERMS `Incoterms*`, LAST_UPDATED_BY `Requestor`, LAST_UPDATED_DATE `Request Date`, LT_TOTAL `L/T(Day)`, MKT_OWMER `MKT Owner`, MODEL_ID `Model*`, MODEL_PIC, NICK_NAME, ORDER_TYPE_DETAIL, QTY `Qty*`, REMARK, REQUEST_ID `Confrim/Plan ID`, SHIPTO_CODE `Ship to*`, SHIPTO_NAME, SITE_DESCRIPTION `Plant Site`, SOLDTO_CODE `Sold to`, STATUS, TO_SITE `To Site*`, TR_MODE `Trans Mode*`, YYYYMMDD `Shipment Date*`
- 원천: SSP0026_GET_REQUEST_DETAIL_PACK

### 3-6. `W/H stock` — META+코드연결 / 메타 필수+기본 19
- 원천: SSP0015_GET_WH_STOCK. 컬럼 상세는 grid_effective.csv가 잘려 있음 → CSV 원문 확인 필요

### 3-7. `W/H stock Detail` — META+코드연결 / 메타 25
- 컬럼 상세 확인 필요 (CSV 잘림). 원천 SP도 Fact Pack 흐름에 따로 표시되지 않음 → 확인 필요

### 3-8. `Hold stock` — META+코드연결 / 표시 10
- 표시: DIVISION_ID `Div`, FROM_SITE_NM `From Site`, HOLD_QTY `Amend Qty*`, HOLD_YYYYMMDD `Start Date`, ITEM_ID `Model`, LAST_UPDATE_DATE, LAST_UPDATED_BY, NICK_NAME, RELEASE_YYYYMMDD `End Date*`, REMARKS
- 숨김: FROM_SITE, HOLD_ID
- 원천 SSP0015_GET_BLOCK_STOCK, 저장 SSP0015_SAVE_BLOCK_STOCK_DATA

### 3-9. `Hold stock Detail` — META+코드연결 / 표시 10
- Hold stock과 같은 컬럼이며, 라벨만 다름: `Amend Qty`, `End Date` (필수 `*` 없음 → 조회 전용으로 보이나 확인 필요)

### 3-10. `Stock Detail` — META+코드연결 / 표시 26 (sheet 변수 shtMesStock)
- 표시: AVAILABLE_YN, DIVISION_ID, FCS_HOLD_YN, FCS_SPECIAL_QTY, FROM_SITE `Site`, ITEM_ID, JUDG_VLD_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY, LONGTERM_HOLD_YN, LOT_ID, LOT_QTY_FCS, LOT_QTY_MES, LOT_QTY_MES_NG, LOT_QTY_TOT, LOT_TYPE, MES_CHANGE_STATUS, MES_HOLD_RELEASE, MES_HOLD_YN, NICK_NAME, OWMS_STOCK_QTY, QMS_HOLD_RELEASE, QMS_HOLD_YN, REMARKS, USER_MOD_RELEASE_DATE `User Modified Release Date*`, YYYYMMDD_LOT_ID_APPLIED_LT `D Day(Expected)`
- 원천 SSP0015_GET_MES_STOCK, 저장 SSP0015_SAVE_MES_STOCK

### 3-11. `MES Stock Detail` — 메타 정의만 있고 코드 미참조(미사용 가능) / 표시 24
- Stock Detail에서 LONGTERM_HOLD_YN, LOT_QTY_MES_NG를 뺀 24컬럼. TO-BE 이관 대상인지 확인 필요

### 3-12. `SCS Stock Detail` — META+코드연결 / 표시 9
- 표시: CUTOFF_DATE, DIVISION_ID, HOLD_YN `Hold Y/N`, LAST_UPDATE_DATE `Update Date`, MODEL_ID `Model`, PLANT_ID, PLANT_NAME, PROD_DATE `Production Date`, QTY
- 원천 SSP0015_GET_SCS_STOCK

### 3-13. `Stock Location Detail` — META+코드연결 / 메타 20
- 일부 확인: AVAILABLE_DATE, AVAILABLE_QTY, COMPANY_ID, CUTOFF_DATE, DEFECT_QTY `Deffect Qty`, DIVISION_ID … 나머지는 CSV 잘림 → 확인 필요
- 원천 SSP0015_GET_STOCK_LOCATION_DETAIL (+ SSP0002_GET_NERP_CODE)

### 3-14. `WH In Plan Detail` — META+코드연결 / 메타 11
- **`drPgmAuthId != null`일 때만 시트를 생성**(권한 의존). 컬럼 상세는 확인 필요
- 원천 SSP0015_GET_SHIPMENT_PSI_COMMENTS

### 3-15. `Shipment Result` — META+코드연결 / 메타 19 → 표시 17
- 표시: CONFIRM_ID, DIVISION_ID, END_CUSTOMER, ERP_SO_NO `SO No`, ETA_DATE, ETD_DATE, FROM_SITE, INCOTERMS, ITEM_ID, NICK_NAME, QTY `Shipment Qty`, SHIP_TYPE, TEAM, TO_SITE, TRANSPORT_MODE, TYPE `Status`, YYYYMMDD `Shipment Date`
- 코드 숨김(4991/4992): SHIP_TO `Ship to`, SHIPTO_DESCRIPTION `Ship to Name`
- 원천 SSP0015_GET_SHIPMENT_RESULT / SSP0015_GET_SHIPMENT_RESULT_PACKER(SCS)

> 참고: grid_effective에서 SHIP_TO / SHIPTO_DESCRIPTION `CODE_ONLY_CHANGE →숨김`이 Hold stock, Hold stock Detail, SCS Stock Detail, Shipment Confirm Detail, Shipment PSI(Mobility & IT), Shipment PSI(Packer), Shipment Request Detail, Stock Detail, Stock Location Detail에도 붙어 있습니다. 근거 코드는 Shipment Result 전용 메서드(4991/4992)이므로 정적 분석의 시트 귀속 한계로 보입니다 → 확인 필요.

## 4. 시트 연결 규칙

| 시트 | Spread | 연결 규칙 | 생성 조건 |
|---|---|---|---|
| Shipment PSI(Mobility & IT) | spdMain | META+코드연결 | 항상 (CreateSpread:656) |
| Shipment PSI(Packer) | spdMain | META+코드연결 | 항상 (660) |
| Shipment Confirm Detail | spdDetail | META+코드연결 | 항상 (665) |
| Shipment Request Detail | spdDetail | META+코드연결 | 항상 (666) |
| W/H stock | spdDetail | META+코드연결 | 항상 (668) |
| W/H stock Detail | spdDetail | META+코드연결 | 항상 (669) |
| Hold stock | spdDetail | META+코드연결 | 항상 (670) |
| Hold stock Detail | spdDetail | META+코드연결 | 항상 (671) |
| Stock Detail | spdDetail | META+코드연결 | 항상 (672) |
| SCS Stock Detail | spdDetail | META+코드연결 | 항상 (673) |
| Stock Location Detail | spdDetail | META+코드연결 | 항상 (674) |
| WH In Plan Detail | spdDetail | META+코드연결 | `drPgmAuthId != null` (680) |
| Shipment Result | spdDetail | META+코드연결 | 항상 (683) |
| Shipment PSI(IT & Mobile) | — | 메타 정의만, 코드 미참조(미사용 가능) | 생성 안 함 |
| MES Stock Detail | — | 메타 정의만, 코드 미참조(미사용 가능) | 생성 안 함 |

- 상단 → 하단 연결: SpdMain_CellDoubleClick이 클릭한 셀의 row(DIVISION_ID / SITE / ITEM_ID / YYYYMMDD)로 하단 시트를 조회합니다(Confirm Detail, W/H stock, Stock Detail, Hold stock, Stock Location Detail, SCS Stock Detail). 셀/Measure별로 어느 시트를 고르는지는 확인 필요합니다.
- 상단 시트 전환(SpdMain_ActiveSheetChanged) 시 LookupCommon 공통코드, PlanDateShip, DayRange, 시트 재구성(GetSpdTitle)을 다시 호출합니다.
- CreateSpread 마지막 ChangeSheet 순서: W/H stock(740) → Shipment Confirm Detail(741) → Shipment PSI(Mobility & IT)(746). 따라서 초기 활성 시트는 Shipment Confirm Detail / Shipment PSI(Mobility & IT)로 보입니다(확인 필요).
