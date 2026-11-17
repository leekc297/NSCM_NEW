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
