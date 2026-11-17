# SSP0060 Web 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑

### 1-1. 메인 `SSP0060_ShipmentPlan`: 상단 조건 패널 (usrConditionPanel1 > usrLayoutControl2)
| AS-IS 컨트롤 | 타입 | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|
| clbCompany_ID | UsrCombo | 확인 필요 (props 잘림) | Wijmo ComboBox |
| clbDivision_ID | UsrCombo | 확인 필요 | Wijmo ComboBox |
| clbPlantSite | UsrCheckedList | 확인 필요 | Wijmo MultiSelect |
| cboPlanDate | UsrCombo | LayoutItem 이름 `PlanDate`, Text는 확인 필요 | Wijmo ComboBox |
| cboBucketType | UsrCombo | LayoutItem `lblBucket`, Text는 확인 필요 | Wijmo ComboBox |
| drpPeriod | UsrDateRangePicker | 확인 필요 | 기간(From/To) InputDate 쌍 |
| txtItemId + btnItemId | UsrMultiLineEditor + UsrButton | LayoutItem `lblItemId`, Text는 확인 필요 | 다건 입력 + 품목 팝업 버튼 |
| clbProductLevel11 | UsrCheckedList | LayoutItem `lcProductLevel11`, Text는 확인 필요 | Wijmo MultiSelect |
| chkSum | UsrCheckBox | 확인 필요 | Checkbox |
| chkTotPSI | UsrCheckBox | 확인 필요 | Checkbox (변경 시 재조회) |
| btnMeasure | UsrButton | 확인 필요 | Measure 선택 버튼 |
| btnSimulation | UsrButton | LayoutItem `lcbtnSimulation`, Text는 확인 필요 | Button |
| usrButton1 | UsrButton | 확인 필요 (부모 없음) | 확인 필요 |
| (프레임워크) FindButton / SaveButton / EditButton | 공통 버튼 | – | 공통 버튼바 (menu-button-dynamic-fetch) |

### 1-2. 메인: 하단 Detail 영역 조건 (splitContainer1.Panel2 > usrLayoutControl3)
| AS-IS 컨트롤 | 타입 | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|
| txtRequestor + btnRequestor | UsrTextBox + UsrButton | LayoutItem `Requestor`, Text는 확인 필요 | 입력 + 사용자 팝업 |
| txtModel2 + btnItemID2 | UsrMultiLineEditor + UsrButton | 확인 필요 | 다건 입력 + 품목 팝업 |
| drpPeriod2 | UsrDateRangePicker | 확인 필요 | InputDate 쌍 (ValueChanged 처리) |
| drpPeriod3 | UsrDateRangePicker | 확인 필요 | InputDate 쌍 |
| clbResultType | UsrCheckedList | 확인 필요 | MultiSelect |
| txtBoxID | UsrMultiLineEditor | 확인 필요 | 다건 입력 |
| clbProductLevel12 | UsrCheckedList | LayoutItem `lcProductLevel12` | MultiSelect |
| btnSearch | SimpleButton | 확인 필요 | Detail 조회 버튼 |
| btnNew | UsrButton | LayoutItem `lcbtnNew` | 신규 버튼 |

### 1-3. RequestPopup (Form Text `"Shipment Request Popup"`)
| AS-IS 컨트롤 | 타입 | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|
| usrButtonList1 | UsrButtonList | – | 팝업 버튼바 |
| cboChangeReason | UsrComboBox | `Change Reason*` | ComboBox (필수) |
| txtReasonDetail | TextBox | `Reason Detail*` | Input (필수) |
| btnAutoSet | SimpleButton | Text `Auto Set` | Button |
| spdMain | FpSpread | 시트 Request Info | FlexGrid |

### 1-4. ConfirmDetailPopup (Form Text `"Request Info Popup"`)
| AS-IS 컨트롤 | 타입 | 라벨(원문) | TO-BE 후보 |
|---|---|---|---|
| btnButtonList | UsrButtonList | – | 팝업 버튼바 |
| txtRequestNo | TextBox ReadOnly | `Request No` | readonly Input |
| txtRequestor | TextBox ReadOnly | `Requestor` | readonly Input |
| txtRequestDeptName | TextBox ReadOnly | `Dept Name` | readonly Input |
| txtApproval | TextBox ReadOnly | `Approval` | readonly Input |
| txtAppDeptName | TextBox ReadOnly | `Dept Name` | readonly Input |
| usrLabel2 | UsrLabel | `Request Confirm Detail` | 섹션 타이틀 |
| spdMain | FpSpread | 시트 Request Info | FlexGrid (조회 전용 여부는 확인 필요) |

## 2. 화면 배치

| 화면 | 구조(props.csv 원문) | 분할 |
|---|---|---|
| 메인 | usrConditionPanel1(조건), splitContainer1: Panel1=spdMain, Panel2=spdDetail + usrLayoutControl3 | splitContainer1의 Orientation, SplitterDistance, Size는 props.csv가 잘려 **확인 필요**. Panel1(상단 또는 좌측)=Main grid, Panel2=Detail 조건+Detail grid |
| RequestPopup | usrConditionPanel1 Dock=Top (1764×52), splitter1 Dock=Top (1764×3), spdMain Dock=Fill (1764×288) | 상하 배치: 조건 52 : 그리드 288 (≈15% : 85%) |
| ConfirmDetailPopup | usrConditionPanel1 Dock=Top (1764×52), panel1 Dock=Top (1764×158, 요청 정보 readonly), splitter1 Dock=Top (1764×3), spdMain Dock=Fill (1764×157) | 상하 3단: 52 : 158 : 157 (≈14% : 43% : 43%) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

모든 메타 시트는 14개 Division에서 표시가 같습니다(Division별 차이 없음). "기본"은 표시, "숨김"은 VISIBLE_FLAG≠Y 또는 숨김 처리입니다. CODE_LOOP 컬럼 `EDIT_YN_{sColumnName.Replace("D_","")}`(헤더 `E{COLUMN_LABEL_NAME}`)은 날짜 컬럼마다 코드가 추가하는 편집 여부 컬럼이며, grid_effective 표시는 `코드추가?`입니다.

### 3-1. Shipment Plan (메타 13 표시 / 5 숨김 + CODE_LOOP, MEASURE 14/6)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| DIVISION_ID | Div | 기본 |
| FROM_SITE_DESCRIPTION | From Site | 기본 |
| TO_SITE | To Site | 기본 |
| PRODUCT_LEVEL1 | Product Level1 | 기본 |
| ITEM_ID | Model | 기본 |
| NICK_NAME | Nick Name | 기본 |
| FCST_TYPE | FCST Type | 기본 |
| INCOTERMS | Incoterms | 기본 |
| TRANSPORT_MODE | Transmode | 기본 |
| BOH_TYPE | BOH_TYPE | 기본 |
| BOH_QTY | BOH_QTY | 기본 |
| PSI | PSI | 기본 |
| MEASURE_NAME | Measure | 기본 |
| FROM_SITE / MEASURE / BACK_COLOR / CONFIRM_DAY / LOT_YN | Site / Measure / Back Color / Confrim Day / Lot_YN | 숨김 |
| (날짜 컬럼) | SCP0009_GET_SHEET_CALENDAR_3SPAN 결과 + InitSpreadDateColumn | 코드 |
| EDIT_YN_* | E{라벨} | 코드추가? |

(메타 컬럼 순서는 SCM_MST_SHEET_COLUMNS 원문 순서를 따릅니다. 위 표는 알파벳 정렬된 grid_effective를 다시 묶은 것이므로 실제 순서는 메타에서 확인해야 합니다.)

### 3-2. Shipment Plan Detail (44 표시 / 27 숨김 + CODE_LOOP)
표시(44): A_COUNTRY "A Contry", A_PORT_CODE "A Port Code", A_PORT_NAME "A Port Name", ATTRIBUTE10, CHANGE_REASON_CODE "Change Reason*", CHANGE_REASON_DETAIL "Reason Detail*", CHANGE_REQ_NO "Change Request No", CITY_NAME, CONFIRM_ID "Confirm/Plan ID", COUNTRY_NAME, DIVISION_ID "Div", END_CUSTOMER, ERP_DO_NO "DO No", ERP_SO_NO "SO No", ETA, ETD, Expected_Shipping_Date, FCST_TYPE "FCST Type*", FROM_SITE_DESCRIPTION "From Site*", INCOTERMS "Incoterms*", ITEM_ID "Model*", LT_DAY "L/T(Day)", MKT_OWNER, MODEL_USER "Model PIC", NICK_NAME, PRODUCT_LEVEL1, PROJECT_CODE, PROJECT_NAME, REMARKS "Remarks", REMARKS2 "Building", REMARKS3 "Customer Requirement", REQUESTOR "Shipment Requestor", SHIPMENT_CONFIRM_QTY "Shipment Qty*", SHIPMENT_DATE "Shipment Date*", SHIPMENT_STATUS "Status", SHIPTO_CITY_NAME, SHIPTO_DESCRIPTION "Ship To Party", SHIPTO_REGION_NAME, SOLDTO_DESCRIPTION "Sold To Party", TEAM, TO_SITE_DESCRIPTION "To Site*", TRANSPORT_MODE "Trans Mode*", UPDATED_BY, UPDATED_DATE

숨김(27): BOD_ID, CHANGE_TYPE, CHECK_NEED_YN "Checked", EDIT_MAIN, EDIT_REMARKS, ELECTRODE_TYPE, ELECTRODE_YN, ERP_STATUS, FROM_SITE "From Site ID", TO_SITE "To Site ID", ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_BOD_ID, NEW_CUSTOMER_LT, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_ETA, NEW_ETD, NEW_INCOTERMS, NEW_LT_DAY, NEW_ROUTE_ID, NEW_SHIPMENT_DATE, NEW_TO_CITY, NEW_TO_COUNTRY, NEW_TRANSPORT_MODE

편집 관련 사실: TRANSPORT_MODE는 `SpdDetail_EditChange`(1380/1389)와 `SpdDetail_CellClick`(1987)에서 `CommonData [TransMode]`(SCP_MST_BOD_V)로 콤보 값을 다시 구합니다. `*` 라벨은 필수 입력 표시이며, 검증 로직은 `Validation_Check`에 있습니다.

### 3-3. Stock Location Detail (20 표시)
AVAILABLE_DATE, AVAILABLE_QTY, COMPANY_ID "Company", CUTOFF_DATE, DEFECT_QTY "Deffect Qty", DIVISION_ID "Div", FROM_SITE, HOLDING_DATE, ITEM_ID "Model", MOVING_QTY, NICK_NAME, OUTSOURCING_FACTORY, OUTSOURCING_FLAG, PLANT_ID "Plant", QTY_UOM "Qty Uom", STOCK_TYPE, STORAGE_DESCRIPTION "Storage", STORAGE_ID "Storage ID", TOTAL_QTY, WIPHOLD_YN "Wiphold Yn", 그리고 CODE_LOOP EDIT_YN_*

### 3-4. oWMS Detail (25 표시)
ALLOCATION_QTY, AVAILABLE_QTY, CAPA_GRADE "Capa. Grade", CUSTOMER_CODE, CUSTOMER_NAME, DIVISION_ID "Div", EXPIRATION_QTY, GRADE, HOLD_QTY, ITEM_ID "Model", LONG_TERM_QTY "Long-term Qty", LOT_ID, LOT_ISSUE_DATE, MOVING_QTY, NICK_NAME, PACKING_QTY, PACKING_STATUS, PALLET_ID, PLANT_ID, RECEIVING_QTY "Reciving Qty"(원문 오타), SOC, STOCK_QTY, STOCK_STATUS "Inventory Status", STORAGE_ID "Storage", UNDECIDED_QTY, 그리고 CODE_LOOP EDIT_YN_*

### 3-5. Hold stock (10 표시 / 2 숨김)
DIVISION_ID "Div", FROM_SITE_NM "From Site", ITEM_ID "Model", NICK_NAME, HOLD_QTY "Amend Qty*", HOLD_YYYYMMDD "Start Date", RELEASE_YYYYMMDD "End Date*", REMARKS, LAST_UPDATED_BY, LAST_UPDATE_DATE. 숨김: FROM_SITE "Site", HOLD_ID
- 라벨에 `*`가 있어 편집 시트로 보입니다. 저장 엔드포인트 `SSP.SSP0060_SAVE_HOLD_STOCK_DATA`는 FoxQuery와 DB 모두에 없습니다. **확인 필요**

### 3-6. Hold stock Detail (10 표시 / 2 숨김)
Hold stock과 같은 컬럼이며, 라벨에 `*`가 없습니다(HOLD_QTY "Amend Qty", RELEASE_YYYYMMDD "End Date"). 숨김: FROM_SITE, HOLD_ID

### 3-7. MES Stock (9 표시)
ITEM_ID "Model", NICK_NAME, TOTAL, AVAILABLE_STOCK, BEFORE_OQC, OQC_INSP_REQUEST, OQC_COMPLETE, OQC_NG, QMS_MES_HOLD "QMS/MES Hold", 그리고 CODE_LOOP EDIT_YN_*

### 3-8. MES Stock Detail (13 표시)
PRODID "Model", PRJT_NAME "Nick Name", LOTID "Lot ID", BOXID "Box ID", LOT_QTY, AVAILABLE_YN "Available stock YN", OQC_INSP_RESULT, EXP_INSP_VALID_DATE "Exp Insp Vaild Date"(원문 오타), PROD_VALID_DATE, MES_HOLD_YN, MES_UNHOLD_SCHD_DATE, QMS_HOLD_YN, QMS_UNHOLD_SCHD_DATE, 그리고 CODE_LOOP EDIT_YN_*

### 3-9. Shipment Result (16 표시)
CONFIRM_ID "Confirm/Plan ID", DIVISION_ID "Div", END_CUSTOMER, ERP_SO_NO "SO No", ETA_DATE "ETA", ETD_DATE "ETD", FROM_SITE, TO_SITE, INCOTERMS, ITEM_ID "Model", NICK_NAME, QTY "Shipment Qty", SHIP_TYPE, TRANSPORT_MODE "Trans Mode", TYPE "Status", YYYYMMDD "Shipment Date", 그리고 CODE_LOOP EDIT_YN_*

### 3-10. Request Info (두 팝업 모두 코드 하드코딩, 메타 없음)
헤더 2행이며, 상위 ColumnHeaderSpan은 `Confirmed`(LT_DAY부터 6칸)와 `Change`(NEW_LT_DAY부터 6칸)입니다.

| 필드 | 헤더 | 타입 | 폭 | ConfirmDetailPopup 표시 |
|---|---|---|---:|---|
| (CAppSetting.StringAction) | A | Text | 10 | 숨김 |
| CHANGE_REQ_NO | change_req_no | Text | 100 | 숨김 |
| DIVISION_ID | Division ID | Text | 100 | 숨김 |
| NEW_YN *(RequestPopup만)* | New YN | Text | 10 | 숨김 (RequestPopup) |
| CONFIRM_ID | Confirm/Plan ID | Text | 100 | 표시 |
| ERP_SO_NO | SO No | Text | 100 | 표시 |
| PROJECT_NAME | Project Name | Text | 100 | 표시 |
| FCST_TYPE | FCST Type | Combo (LookupCommon `SALES_TYPE_CODE`) | 100 | 표시 |
| ITEM_ID | Model | Text | 80 | 표시 |
| FROM_SITE | From Site | Text | 60 | 표시 |
| TO_SITE | To Site | Text | 100 | 표시 |
| INCOTERMS | Incoterms | Text | 65 | 표시 |
| LT_DAY / ETD / ETA / TRANSPORT_MODE / SHIPMENT_DATE / SHIPMENT_CONFIRM_QTY | [Confirmed] L/T(Day) / ETD / ETA / Trans Mode / Shipment Date / Qty | Text/Date/Date/Text/Date/Num | 60/70/70/45/70/60 | 표시 |
| NEW_LT_DAY / NEW_ETD / NEW_ETA / NEW_TRANSPORT_MODE / NEW_SHIPMENT_DATE / NEW_SHIPMENT_CONFIRM_QTY | [Change] 같은 헤더 | 같은 타입 | 같은 폭 | 표시 |
| DIFF_QTY | Diff Qty | Num | 60 | 표시 |
| CHANGE_REASON_CODE | Change Reason | Combo (`GetSSPInnerTable("CHANGE_REASON_CODE_ALL")`) | 100 | 표시 |
| CHANGE_REASON_DETAIL | Reason Detail | Text | 100 | 표시 |
| NEW_BOD_ID, NEW_ROUTE_ID, NEW_D_COUNTRY, NEW_D_PORT_CODE, NEW_A_COUNTRY, NEW_A_PORT_CODE, NEW_TO_COUNTRY | 같은 이름 | Text | 100 | 숨김 |
| **ELECTRODE_YN** | **NEW_TO_CITY** (원문 그대로, 헤더와 필드가 뒤바뀜) | Text | 100 | 숨김 |
| **NEW_TO_CITY** | **ELECTRODE_YN** (원문 그대로) | Text | 100 | 숨김 |
| ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, EDIT_REMARKS, EDIT_MAIN, REMARKS, REMARKS2, REMARKS3, PRODUCT_LEVEL1, NICK_NAME, FROM_SITE_DESCRIPTION, TO_SITE_DESCRIPTION, PROJECT_CODE | 같은 이름 | Text | 100 | 숨김 |

- ConfirmDetailPopup은 48컬럼, RequestPopup은 NEW_YN을 더해 49컬럼입니다.
- RequestPopup 각 컬럼의 표시 여부, 폭, 정렬은 grid_code가 잘려 **확인 필요**입니다.

## 4. 시트 연결 규칙

| 트리거 | 동작 | 대상 시트(호출 SP 기준) |
|---|---|---|
| 조회(FindButton), chkTotPSI 변경 | FindData_Main | Shipment Plan (`SSP0060_GET_SHIPMENT_PLAN`) |
| spdMain 셀 더블클릭 (`SpdMain_CellDoubleClick`) | FindData_Detail, Stock_Detail, oWMS_Detail, Shipment_Result, hold_stock, MES_stock, MES_stock_Detail | Shipment Plan Detail, Stock Location Detail, oWMS Detail, Shipment Result, Hold stock, MES Stock, MES Stock Detail |
| Detail 영역 btnSearch (`BtnSearch_Click`) | 위와 같되 hold_stock 제외 | 활성 시트 기준인지는 확인 필요 |
| spdDetail 시트 탭 (`SpdDetail_SheetTabClick`, `SpdDetail_ActiveSheetChanged`) | 시트 전환 처리 | 로직 내용은 확인 필요 |
| cboPlanDate / clbCompany_ID / btnMeasure | InitSpread > GetSpdTitle로 날짜 헤더 재구성 | Shipment Plan |
| 저장 후 (SaveData_Detail) | FindData_Main, FindData_Detail, FindData_hold_stock 재조회 | Shipment Plan, Shipment Plan Detail, Hold stock |
| spdMain/spdDetail TopChange | 스크롤 동기화 핸들러(SpdMain_TopChange, SpdDetail_TopChange) | 동기화 대상은 확인 필요 |

- 더블클릭한 셀(Measure 또는 컬럼)에 따라 어느 FindData_*가 실행되는지는 Fact Pack에 없습니다. **확인 필요**
