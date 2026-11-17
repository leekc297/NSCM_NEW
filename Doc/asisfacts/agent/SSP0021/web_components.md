# SSP0021 웹 컴포넌트 매핑 (React + Wijmo)

> 라벨은 props.csv의 LayoutControlItem.Text 또는 컨트롤 Text 원문이다. props.csv는 일부가 잘려 있어 미확인 라벨을 **확인 필요**로 표기했다.
> Wijmo 컴포넌트명은 매핑 후보이며, 프로젝트 공용 컴포넌트를 쓸지는 TO-BE 표준에 따른다.

## 1. 컨트롤 → 컴포넌트 매핑

### 1.1 상단 조회조건 (usrConditionPanel1 > usrLayoutControl2)
| AS-IS 컨트롤 | 유형 | LayoutControlItem | 라벨 원문 | Size | 비고 | TO-BE 후보 |
|---|---|---|---|---|---|---|
| clbDivision_ID | UsrCombo | lblCombo1 | `Division*` | 150×20 | SelectedIndexChanged 연결 | Wijmo ComboBox (단일 선택) |
| clbCompany_ID | UsrCombo | layoutControlItem1 | `Company*` | 178×20 | 변경 시 `SSP.SSP0021_GET_SHIPMENT_FROM_SITE` 호출 | Wijmo ComboBox |
| clbPlantSite | UsrCheckedList | layoutControlItem7 | `From Site` | 220×21 | 다중 선택 | Wijmo MultiSelect |
| cboPlanDate | UsrCombo | PlanDate | `Plan-date*` | 138×20 | 변경 시 날짜 헤더 재구성 | Wijmo ComboBox |
| drpPeriod | UsrDateRangePicker | layoutControlItem6 | `Period*` | 197×20 | **Enabled=false** (읽기전용) | InputDate ×2 (비활성) |
| cboBucketType | UsrCombo | lblBucket | `Bucket` | 320×20 | DAILY/WEEKLY/MONTHLY 열 전환 | Wijmo ComboBox |
| chkSum | UsrCheckBox | layoutControlItem8 | `Sum` (컨트롤 Text) | 84×25 | 합계 열 표시 | CheckBox |
| txtItemId | UsrMultiLineEditor | lblItemId | `Model` | 695×21 | 다중 값 입력 | 다중값 TextInput |
| btnItemId | UsrButton | layoutControlItem2 | (Text 없음) | 39×24 | btnItemId_Click | 아이콘 버튼(팝업) |
| btnMeasure | UsrButton | layoutControlItem10 | (Text 없음) | 39×25 | BtnMeasure_Click | 아이콘 버튼 |
| btnSimulation | UsrButton | layoutControlItem12 | `Simulation` (컨트롤 Text) | 106×25 | BtnSimulation_Click | Button |
| chkSql | UsrCheckBox | lblSql | `Show SQL` (컨트롤 Text) | 98×20 | 이벤트 배선 없음 | 확인 필요(개발용 여부) |
| usrButton1 | UsrButton | — | — | 75×23 | parent 없음 | 확인 필요 |

### 1.2 하단 상세 조건 (splitContainer1.Panel2 > usrLayoutControl3)
| AS-IS 컨트롤 | 유형 | LayoutControlItem | 라벨 원문 | Size | 비고 | TO-BE 후보 |
|---|---|---|---|---|---|---|
| drpPeriod2 | UsrDateRangePicker | layoutControlItem11 | `Shipment Date` | 197×20 | DrpPeriod2_ValueChanged | InputDate ×2 |
| drpPeriod3 | UsrDateRangePicker | layoutControlItem13 | `Shipment Date` | 197×20 | 이벤트 배선 없음 | InputDate ×2 |
| txtModel2 | UsrMultiLineEditor | layoutControlItem4 | `Model` | 264×21 | | 다중값 TextInput |
| btnItemID2 | UsrButton | layoutControlItem5 | `layoutControlItem2` (원문 그대로. 기본값 텍스트로 보이나 표시 여부는 확인 필요) | 39×25 | BtnItemID2_Click | 아이콘 버튼 |
| txtRequestor | UsrTextBox | Requestor | 확인 필요 (props 잘림) | 147×25 | | TextInput |
| btnRequestor | UsrButton | layoutControlItem9 | (Text 없음) | 39×24 | BtnRequestor_Click | 아이콘 버튼(팝업) |
| clbResultType | UsrCheckedList | 확인 필요 | 확인 필요 | 104×21 | | Wijmo MultiSelect |
| txtBoxID | UsrMultiLineEditor | 확인 필요 | 확인 필요 | 205×21 | | 다중값 TextInput |
| btnSearch | SimpleButton | layoutControlItem3 | `Search` (컨트롤 Text) | 47×25 | BtnSearch_Click → 활성 상세 시트 재조회 | Button |

### 1.3 Grid
| AS-IS | 유형 | 위치 | 시트 | TO-BE 후보 |
|---|---|---|---|---|
| spdMain | FpSpread | splitContainer1.Panel1, Dock=Fill | Shipment Plan (헤더 3행) | Wijmo FlexGrid (다단 헤더 + 동적 날짜 열, MergePolicy Always → allowMerging) |
| spdDetail | FpSpread | splitContainer1.Panel2, Dock=Fill | 상세 시트 8개 (2.2절) | 탭 + 시트별 Wijmo FlexGrid |

## 2. 화면 배치

### 2.1 분할 (props.csv 기준)
| 영역 | Dock | Size | 비고 |
|---|---|---|---|
| usrConditionPanel1 | Top | 1689×73 | UsrPanelType=HidePanel (접기 가능 패널) |
| usrLayoutControl2 | Top | 1689×77 | 조회조건 레이아웃(LayoutControlGroup2 1689×77) |
| splitContainer1 | Fill | 1689×576 | **Orientation=Horizontal → 상/하 분할**, SplitterDistance=303 |
| ├ Panel1: spdMain | Fill | 1689×303 | 상단 |
| └ Panel2: usrLayoutControl3 | Top | 1689×40 | 하단 조건 줄 (LayoutControlGroup3 1689×49) |
| └ Panel2: spdDetail | Fill | 1689×229 | 하단 Grid |

- 상/하 비율(SplitterDistance ÷ 높이): 상단 303 / 576 = **52.6%**, 하단 (576−303) / 576 = **47.4%**.
- 하단 내부: 조건 줄 40 + spdDetail 229 = 269. 576 − 303 − 269 = 4px이 남는데, 이것이 Splitter 폭인지는 SplitterWidth 속성이 Fact Pack에 없어 확인 필요.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

- 9개 시트 모두 `META+코드연결`이다. 표시 판정은 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 **모두 같다**.
- 순서는 CSV의 알파벳순이다. 실제 표시 순서는 메타 SORT 정보 확인이 필요하다.
- "기본" = 메타 표시(VISIBLE·VALID=Y, DEFAULT), "숨김" = 메타 비표시.

### 3.1 Shipment Plan (spdMain, 표시 8 / 전체 13 + 날짜 DB루프 열)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| BACK_COLOR | Back Color | 숨김 |
| BOH_QTY | BOH_QTY | 기본 |
| BOH_TYPE | BOH_TYPE | 기본 |
| CONFIRM_DAY | Confrim Day | 숨김 |
| DIVISION_ID | Div | 기본 |
| FROM_SITE | Site | 숨김 |
| FROM_SITE_DESCRIPTION | From Site | 기본 |
| ITEM_ID | Model | 기본 |
| LOT_YN | Lot_YN | 숨김 |
| MEASURE | Measure | 숨김 |
| MEASURE_NAME | Measure | 기본 |
| NICK_NAME | Nick Name | 기본 |
| PSI | PSI | 기본 |

코드 추가 사항:
- MEASURE 다음 열부터(`GetColumnIndex(MEASURE)+1`) `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과로 날짜 열을 반복 생성한다.
- 컬럼명에 `B_`가 포함되면 Text, 너비 0, 숨김. 그 외는 Num, 너비 70, 표시. SAT는 파랑, SUN은 빨강 글자.
- 헤더 3행: LARGE_CLASS / SMALL_CLASS Span과 "SUM" 헤더.
- `SetSpreadColumn`이 Bucket과 Sum 값에 따라 열 표시를 바꾼다:

| Bucket | D_ 열 | W_ 열 | M_ 열 |
|---|---|---|---|
| DAILY | 표시 (D_ 또는 W_ 조건에 true) | D_/W_ 조건에 true, 이어서 M_/W_ 조건에 chkSum.Checked (실행 순서상 최종값은 확인 필요) | chkSum.Checked |
| WEEKLY | 숨김 | 표시 | chkSum.Checked |
| MONTHLY | 숨김 | 숨김 | 표시 |

- SCM_MST_SHEET_MEASURE에 Measure 9건(전 division)이 있다.
- MergePolicy = Always.

### 3.2 Shipment Plan Detail (표시 42 / 전체 69)
| 컬럼 | 라벨 | 표시 | | 컬럼 | 라벨 | 표시 |
|---|---|---|---|---|---|---|
| A_COUNTRY | A Contry | 기본 | | NEW_ETD | ETD | 숨김 |
| A_PORT_CODE | A Port Code | 기본 | | NEW_INCOTERMS | new incoterms | 숨김 |
| A_PORT_NAME | A Port Name | 기본 | | NEW_LT_DAY | L/T(Day) | 숨김 |
| ATTRIBUTE10 | ATTRIBUTE10 | 기본 | | NEW_ROUTE_ID | Route | 숨김 |
| BOD_ID | bod_id | 숨김 | | NEW_SHIPMENT_DATE | Shipment Date* | 숨김 |
| CHANGE_REASON_CODE | Change Reason | 기본 | | NEW_TO_CITY | To City | 숨김 |
| CHANGE_REASON_DETAIL | Reason Detail | 기본 | | NEW_TO_COUNTRY | To Country | 숨김 |
| CHANGE_REQ_NO | Change Request No | 기본 | | NEW_TRANSPORT_MODE | Trans Mode | 숨김 |
| CHANGE_TYPE | CHANGE_TYPE | 숨김 | | NICK_NAME | Nick Name | 기본 |
| CHECK_NEED_YN | Checked | 숨김 | | ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID | 숨김 |
| CITY_NAME | City Name | 기본 | | ORIGIN_TO_DIVISION_ID | ORIGIN_TO_DIVISION_ID | 숨김 |
| CONFIRM_ID | Confirm/Plan ID | 기본 | | PROJECT_CODE | Project Code | 기본 |
| COUNTRY_NAME | Country Name | 기본 | | PROJECT_NAME | Project Name | 기본 |
| DIVISION_ID | Div | 기본 | | REMARKS | Remarks | 기본 |
| EDIT_MAIN | EDIT_MAIN | 숨김 | | REMARKS2 | Building | 기본 |
| EDIT_REMARKS | EDIT_REMARKS | 숨김 | | REMARKS3 | Customer Requirement | 기본 |
| ELECTRODE_TYPE | ELECTRODE_TYPE | 숨김 | | REQUESTOR | Shipment Requestor | 기본 |
| ELECTRODE_YN | ELECTRODE_YN | 숨김 | | SHIPMENT_CONFIRM_QTY | Shipment Qty* | 기본 |
| END_CUSTOMER | End Customer | 기본 | | SHIPMENT_DATE | Shipment Date* | 기본 |
| ERP_SO_NO | SO No | 기본 | | SHIPMENT_STATUS | Status | 기본 |
| ERP_STATUS | erp_status | 숨김 | | SHIPTO_CITY_NAME | Ship To City Name | 기본 |
| ETA | ETA | 기본 | | SHIPTO_DESCRIPTION | Ship To Party | 기본 |
| ETD | ETD | 기본 | | SHIPTO_REGION_NAME | Ship To Region Name | 기본 |
| Expected_Shipping_Date | Expected Shipping Date | 기본 | | SOLDTO_DESCRIPTION | Sold To Party | 기본 |
| FCST_TYPE | FCST Type | 기본 | | TEAM | Team | 기본 |
| FROM_SITE | From Site ID | 숨김 | | TO_SITE | To Site ID | 숨김 |
| FROM_SITE_DESCRIPTION | From Site | 기본 | | TO_SITE_DESCRIPTION | To Site | 기본 |
| INCOTERMS | Incoterms | 기본 | | TRANSPORT_MODE | Trans Mode* | 기본 |
| ITEM_ID | Model | 기본 | | UPDATED_BY | Updated By | 기본 |
| LT_DAY | L/T(Day) | 기본 | | UPDATED_DATE | Updated Date | 기본 |
| MODEL_USER | Model PIC | 기본 | | NEW_A_COUNTRY | A Country | 숨김 |
| MTK_OWNER | MKT Owner | 기본 | | NEW_A_PORT_CODE | A Port | 숨김 |
| NEW_BOD_ID | new bod | 숨김 | | NEW_CUSTOMER_LT | Customer LT | 숨김 |
| NEW_D_COUNTRY | D Country | 숨김 | | NEW_D_PORT_CODE | D Port | 숨김 |
| NEW_ETA | ETA | 숨김 | | | | |

- Validation_Check 대상 필드: shipment_confirm_qty(Shipment Qty*), shipment_date(Shipment Date*), TRANSPORT_MODE(Trans Mode*), remarks2(Building), remarks(Remarks).
- 헤더 체크박스 전체 선택/해제(SpdDetail_CellClick)가 적용되는 열은 확인 필요.

### 3.3 Stock Location Detail (표시 20 / 전체 20)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| AVAILABLE_DATE | Available Date | 기본 |
| AVAILABLE_QTY | Available Qty | 기본 |
| COMPANY_ID | Company | 기본 |
| CUTOFF_DATE | Cutoff Date | 기본 |
| DEFECT_QTY | Deffect Qty | 기본 |
| DIVISION_ID | Div | 기본 |
| FROM_SITE | From Site | 기본 |
| HOLDING_DATE | Holding Date | 기본 |
| ITEM_ID | Model | 기본 |
| MOVING_QTY | Moving Qty | 기본 |
| NICK_NAME | Nick Name | 기본 |
| OUTSOURCING_FACTORY | Outsourcing Factory | 기본 |
| OUTSOURCING_FLAG | Outsourcing Flag | 기본 |
| PLANT_ID | Plant | 기본 |
| QTY_UOM | Qty Uom | 기본 |
| STOCK_TYPE | Stock Type | 기본 |
| STORAGE_DESCRIPTION | Storage | 기본 |
| STORAGE_ID | Storage ID | 기본 |
| TOTAL_QTY | Total Qty | 기본 |
| WIPHOLD_YN | Wiphold Yn | 기본 |

### 3.4 oWMS Detail (표시 25 / 전체 25)
| 컬럼 | 라벨 | 컬럼 | 라벨 |
|---|---|---|---|
| ALLOCATION_QTY | Allocation Qty | MOVING_QTY | Moving Qty |
| AVAILABLE_QTY | Available Qty | NICK_NAME | Nick Name |
| CAPA_GRADE | Capa. Grade | PACKING_QTY | Packing Qty |
| CUSTOMER_CODE | Customer Code | PACKING_STATUS | Packing Status |
| CUSTOMER_NAME | Customer Name | PALLET_ID | Pallet ID |
| DIVISION_ID | Div | PLANT_ID | Plant ID |
| EXPIRATION_QTY | Expiration Qty | RECEIVING_QTY | Reciving Qty |
| GRADE | Grade | SOC | SOC |
| HOLD_QTY | Hold Qty | STOCK_QTY | Stock Qty |
| ITEM_ID | Model | STOCK_STATUS | Inventory Status |
| LONG_TERM_QTY | Long-term Qty | STORAGE_ID | Storage |
| LOT_ID | Lot ID | UNDECIDED_QTY | Undecided Qty |
| LOT_ISSUE_DATE | Lot Issue Date | | |
(25개 모두 "기본" 표시)

### 3.5 Hold stock (표시 10 / 전체 12)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| DIVISION_ID | Div | 기본 |
| FROM_SITE | Site | 숨김 |
| FROM_SITE_NM | From Site | 기본 |
| HOLD_ID | HOLD_ID | 숨김 |
| HOLD_QTY | Amend Qty* | 기본 |
| HOLD_YYYYMMDD | Start Date | 기본 |
| ITEM_ID | Model | 기본 |
| LAST_UPDATE_DATE | Last Updated Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| NICK_NAME | Nick Name | 기본 |
| RELEASE_YYYYMMDD | End Date* | 기본 |
| REMARKS | Remarks | 기본 |

- 라벨의 `*`(Amend Qty*, End Date*)는 입력 필수 표기다. 저장 SP는 `SSP.SSP0021_SAVE_HOLD_STOCK_DATA`인데 DB에 SP가 없다 → 확인 필요.

### 3.6 Hold stock Detail (표시 10 / 전체 12)
| 컬럼 | 라벨 | 표시 |
|---|---|---|
| DIVISION_ID | Div | 기본 |
| FROM_SITE | Site | 숨김 |
| FROM_SITE_NM | From Site | 기본 |
| HOLD_ID | HOLD_ID | 숨김 |
| HOLD_QTY | Amend Qty | 기본 |
| HOLD_YYYYMMDD | Start Date | 기본 |
| ITEM_ID | Model | 기본 |
| LAST_UPDATE_DATE | Last Updated Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| NICK_NAME | Nick Name | 기본 |
| RELEASE_YYYYMMDD | End Date | 기본 |
| REMARKS | Remarks | 기본 |

- Hold stock과 컬럼 구성은 같고 `*` 표기만 없다. 이 시트를 코드에서 AddSheet/ChangeSheet하는 지점은 Fact Pack 표시 범위에서 확인되지 않았다 → 확인 필요.

### 3.7 MES Stock (표시 9 / 전체 9)
| 컬럼 | 라벨 |
|---|---|
| AVAILABLE_STOCK | Available Stock |
| BEFORE_OQC | Before OQC |
| ITEM_ID | Model |
| NICK_NAME | Nick Name |
| OQC_COMPLETE | OQC Complete |
| OQC_INSP_REQUEST | OQC Insp Request |
| OQC_NG | OQC NG |
| QMS_MES_HOLD | QMS/MES Hold |
| TOTAL | Total |

### 3.8 MES Stock Detail (표시 13 / 전체 13)
| 컬럼 | 라벨 |
|---|---|
| AVAILABLE_YN | Available stock YN |
| BOXID | Box ID |
| EXP_INSP_VALID_DATE | Exp Insp Vaild Date |
| LOT_QTY | Lot Qty |
| LOTID | Lot ID |
| MES_HOLD_YN | MES Hold YN |
| MES_UNHOLD_SCHD_DATE | MES Unhold Sched Date |
| OQC_INSP_RESULT | OQC Insp Result |
| PRJT_NAME | Nick Name |
| PROD_VALID_DATE | Prod Valid Date |
| PRODID | Model |
| QMS_HOLD_YN | QMS Hold YN |
| QMS_UNHOLD_SCHD_DATE | QMS Unhold Sched Date |

### 3.9 Shipment Result (표시 18 / 전체 18)
| 컬럼 | 라벨 | 비고 |
|---|---|---|
| CHILD_QTY | Shipment Pack Qty | division **82**일 때 Width=75 (InitSpread 727줄) |
| CONFIRM_ID | Confirm/Plan ID | |
| DIVISION_ID | Div | |
| END_CUSTOMER | End Customer | |
| ERP_SO_NO | SO No | |
| ETA_DATE | ETA | |
| ETD_DATE | ETD | |
| FROM_SITE | From Site | |
| INCOTERMS | Incoterms | |
| ITEM_ID | Model | |
| NICK_NAME | Nick Name | |
| PROJECT_CODE | Prj Code | |
| QTY | Shipment Qty | |
| SHIP_TYPE | Ship Type | |
| TO_SITE | To Site | |
| TRANSPORT_MODE | Trans Mode | |
| TYPE | Status | |
| YYYYMMDD | Shipment Date | |

## 4. 시트 연결 규칙

### 4.1 spdMain(Shipment Plan) 더블클릭 → spdDetail 시트 전환 (SpdMain_CellDoubleClick 2059~2094줄)
| 조건 | 전환 시트 | 조회 엔드포인트 (flow.csv) |
|---|---|---|
| 클릭 열 ≥ MEASURE+1 이고 MEASURE == "SHIP_PLAN" | Shipment Plan Detail | SSP.SSP0021_GET_SHIPMENT_PLAN_DETAIL |
| 클릭 열 = BOH_QTY 이고 BOH_TYPE == "ERP" | Stock Location Detail | SSP.SSP0021_GET_STOCK_LOCATION_DETAIL |
| 클릭 열 = BOH_QTY 이고 BOH_TYPE == "oWMS" | oWMS Detail | SSP.SSP0021_GET_OWMS_DETAIL |
| 클릭 열 = BOH_QTY 이고 BOH_TYPE == "HOLD" | Hold stock | SSP.SSP0021_GET_HOLD_STOCK |
| 클릭 열 = BOH_QTY 이고 BOH_TYPE == "MES" | MES Stock Detail(2088~2089줄) → MES Stock(2093~2094줄) | SSP.SSP0021_GET_MES_STOCK_DETAIL, SSP.SSP0021_GET_MES_STOCK |

### 4.2 spdDetail 탭 클릭 (SpdDetail_SheetTabClick 2138~2154줄)
| SheetTabIndex | 시트 |
|---:|---|
| 0 | Shipment Plan Detail |
| 1 | Stock Location Detail |
| 2 | oWMS Detail |
| 5 | Shipment Result |
| 3, 4 및 Hold stock 계열 | Fact Pack에 분기 없음 → 확인 필요 |

### 4.3 spdDetail 시트 생성 순서 (CreateSpread)
548 Shipment Plan Detail → 549 Stock Location Detail → 550 oWMS Detail → (551~555 미표시) → 556 MES Stock → 557 MES Stock Detail → 559 Shipment Result → 594 Shipment Plan Detail을 활성 시트로 설정.

### 4.4 상세 Search 버튼
`BtnSearch_Click`은 활성 상세 시트에 맞춰 PLAN_DETAIL / STOCK_LOCATION_DETAIL / OWMS_DETAIL / SHIPMENT_RESULT / MES_STOCK / MES_STOCK_DETAIL을 재조회한다(flow.csv). 시트와 SP의 분기 조건식은 Fact Pack에 없다 → 확인 필요.
