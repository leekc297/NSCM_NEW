# SSP0022 Web 컴포넌트 매핑 (React + Wijmo)

## 1. 화면 배치 (props.csv 기준)
| 영역 | 컨트롤 | 사실 |
|---|---|---|
| 조회조건 패널 | usrConditionPanel1 | Dock=Top, Size(1689, 75), UsrPanelType=HidePanel |
| 조회조건 레이아웃 | usrLayoutControl2 | Dock=Top, Size(1689, 72); layoutControlGroup2 Size(1689, 78) |
| 본문 분할 | splitContainer1 (parent=this) | Panel1 = spdMain, Panel2 = spdDetail + spdSub + usrLayoutControl3 |
| 하단 조회조건 | usrLayoutControl3 (Panel2) | btnRequestor, drpPeriod2, txtModelId2, txtRequestor, textNickName2, btnSearch, txtItemld2, btnItemID2, txtLotID |

- splitContainer1의 **Orientation, SplitterDistance, Size**는 props.csv 발췌가 잘려 **확인 필요**다. 따라서 상/하인지 좌/우인지, 분할 비율이 얼마인지 확정하지 않는다. 확인할 곳은 `SSP0022_ShipmentRequestElectrode.Designer.cs`의 splitContainer1 속성 블록이다.
- 구조로 보면 위(또는 앞) 영역은 PSI 메인 그리드(spdMain), 아래(또는 뒤) 영역은 상세 조건과 상세 그리드(spdDetail 탭, spdSub)다.

## 2. 컨트롤 → React/Wijmo 매핑

### 2-1. 상단 조회조건 (usrLayoutControl2)
| As-is 컨트롤 | 유형 | 라벨(원문) | 속성 사실 | TO-BE 후보 |
|---|---|---|---|---|
| clbCompany_ID | UsrCombo | "Company*" (layoutControlItem1) | Size(156,20) | Wijmo ComboBox (필수) |
| clbDivision_ID | UsrCombo | "Division*" (lblCombo1) | Size(125,20) | Wijmo ComboBox (필수) |
| cboPlanDate | UsrCombo | "Plan-date*" (PlanDate) | Size(113,20) | Wijmo ComboBox (필수) |
| drpPeriod | UsrDateRangePicker | "Period*" (layoutControlItem6) | **Enabled=false**, Size(197,20) | 날짜범위(읽기 전용) |
| cboBucketType | UsrCombo | "Bucket" (lblBucket) | Size(70,20) | Wijmo ComboBox |
| clbPlantSite | UsrCheckedList | "Plant" (layoutControlItem7) | Size(115,21) | Wijmo MultiSelect |
| txtItemId + btnItemId | UsrMultiLineEditor + UsrButton | "Material" (lblItemId) | Size(100,21) / (39,24) | 멀티라인 입력 + 팝업 버튼 |
| lblUOMType | UsrLabel | "UOM Type" | Size(66,25) | 라벨 |
| rdButton1 | UsrRadio | "UOM" | **Checked=true** | Radio |
| rdButton2 | UsrRadio | "Cell" | — | Radio |
| rdButton3 | UsrRadio | "Pancake m" | — | Radio |
| chkSum | UsrCheckBox | "Sum" | — | CheckBox |
| chkPastPeriod | UsrCheckBox | "Including Past Period" | **Visible=false** | CheckBox(숨김) |
| btnMeasure | UsrButton | 텍스트 확인 필요 (layoutControlItem10) | Size(39,25) | Measure 선택 버튼 |
| chkDelegateModel | UsrCheckBox | "Delegate Model" | — | CheckBox |
| chkTeamLeader | UsrCheckBox | "Team Leader" | — | CheckBox |
| chkPartLeader | UsrCheckBox | "Part Leader" | — | CheckBox |
| chkMyModel | UsrCheckBox | "My Model" | **Visible=false** | CheckBox(숨김) |
| txtModelId / btnModelId | UsrMultiLineEditor / UsrButton | 라벨 확인 필요 | btnModelId **Visible=false** | 입력 |
| textNickName | TextBox | 라벨 확인 필요 (lblNickname 항목 있음) | Size(104,20) | Input |
| clbCellType | UsrCheckedList | 라벨 확인 필요 | Size(86,21) | MultiSelect |
| formDown | UsrButton | "Excel Form" | Size(90,25) | 버튼 |
| btnExcelUpload | UsrButton | "Upload" | Size(70,25) | 버튼 |

### 2-2. 하단 상세 조건 (usrLayoutControl3)
| As-is 컨트롤 | 유형 | 라벨 | TO-BE 후보 |
|---|---|---|---|
| drpPeriod2 | UsrDateRangePicker | 확인 필요 | 날짜범위 |
| txtModelId2 | UsrMultiLineEditor | 확인 필요 | 입력 |
| txtRequestor + btnRequestor | UsrMultiLineEditor + UsrButton | 확인 필요 | 입력 + 사용자 팝업 |
| textNickName2 | TextBox | 확인 필요 | Input |
| txtItemld2 + btnItemID2 | UsrMultiLineEditor + UsrButton | 확인 필요 | 입력 + 팝업 |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 입력 |
| btnSearch | SimpleButton | 확인 필요 | 상세 조회 버튼 |

### 2-3. Grid
| As-is | 시트 | TO-BE |
|---|---|---|
| spdMain (Panel1) | Shipment Request(Electrode) | Wijmo FlexGrid (헤더 3단, 동적 날짜 컬럼) |
| spdDetail (Panel2) | Stock Detail, Shipment Request Detail | 탭 + Wijmo FlexGrid |
| spdSub (Panel2) | Shipment Request Detail Excel | Wijmo FlexGrid (엑셀 양식/업로드용) |
| BodItemPopup spdMain | `Project` (추정 — 확인 필요) | 팝업 FlexGrid |
| ShipmentRequestPopup spdMain | `Shipment Reqeust(Electrode)` (추정 — 확인 필요) | 팝업 FlexGrid (편집) |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

모든 시트에서 division 14종의 결과가 같다. division에 따른 표시 차이는 없다.

### 3-1. `Shipment Request(Electrode)` — META+코드연결, 표시 22 (?9)
메타 28/0과 MEASURE 10/0 위에 날짜 DB 루프 컬럼이 붙는다.

| 컬럼 | 라벨 | 메타 | 코드 변경 |
|---|---|---|---|
| DIVISION_ID | Div | 기본 | |
| SCM_SITE_ID | SCM_SITE_ID | 기본 | |
| PLANT_ID | Plant | 기본 | |
| FROM_SITE / TO_SITE | From Site / To Site | 기본 | |
| MODEL_ID / ITEM_ID / NICK_NAME | Model / Material / Nick Name | 기본 | |
| CELL_TYPE / ELECTRODE_TYPE | Cell Type / Elec Type | 기본 | |
| BOD_ID / BOD_LT / OPERATION_LT | Bod ID / BOD L/T / Oper. L/T | 기본 | |
| INCOTERMS / TRANSPORT_MODE | Incoterms / Trans Mode | 기본 | |
| LAST_UPDATED_BY | Requestor | 기본 | |
| PSI_NAME / MEASURE_NAME | PSI / Measure | 기본 | |
| TEMPCOLUMN | TEMPCOLUMN | 기본 | |
| TOT_BOH_QTY / JR_BOH_QTY / PC_BOH_QTY | BOH / J/R / Pancake | 기본 | UOM 라디오일 때 표시 |
| TOT/JR/PC_BOH_QTY_CELL | BOH / J/R / Pancake | 기본 | Cell 라디오일 때 표시 |
| TOT/JR/PC_BOH_QTY_PCM | BOH / J/R / Pancake | 기본 | Pancake m 라디오일 때 표시 |
| BACK_COLOR, CONFIRM_DAY("Confrim Day"), MEASURE, NPC_ITEM_ID("Noteched Pancake"), ORIGIN_DIVISION_ID, TOT_BOH_JR | — | 숨김 | |
| (동적) 날짜 컬럼 | SSP0022_GET_SHEET_CALENDAR_3SPAN COLUMN_LABEL_NAME | — | `B_` 포함이면 숨김, 아니면 숫자(3자리). Tag 접두어 X_/Y_/Z_ × D_/W_/M_에 따라 표시 |

라벨 원문의 오탈자("Confrim Day", "Noteched Pancake")는 메타 원문 그대로다.

### 3-2. `Stock Detail` — META+코드연결, 표시 31 (?9)
기본 표시 컬럼:

| 컬럼 | 라벨 |
|---|---|
| DIVISION_ID | Div |
| PLANT_ID | Plant |
| MODEL_ID / ITEM_ID / NICK_NAME | Model / Material / Nick Name |
| CELL_TYPE | Cell Type |
| VERSION | Version |
| LOT_ID / PALLET_ID / LANE | Lot ID / Pallet ID / Lane |
| OPERATION_ID / STORAGE_ID | Operation / Storage |
| TOTAL_QTY_UOM / TOTAL_QTY_PCM | UOM / Pancake M |
| GMES_QTY_UOM / GMES_QTY_PCM | UOM / Pancake M |
| IWMS_QTY_UOM / IWMS_QTY_PCM | UOM / Pancake M |
| OWMS_QTY_UOM / OWMS_QTY_PCM | UOM / Pancake M |
| MES_HOLD_YN / QMS_HOLD_YN / IWMS_HOLD_YN / OWMS_HOLD_YN | MES / QMS / iWMS / oWMS Hold YN |
| AVAILABLE_YN | Available Stock YN |
| CHANGE_STATUS | Change Status |
| EXPIRATION_DATE | Expiration Date |
| PACKAGE_TYPE_CODE | Package Type (oWMS) |

숨김: FROM_SITE("Site"). 그 밖에 BOH 9컬럼 CODE_ONLY_CHANGE(?)가 있으며, 실제로 이 시트에 적용되는지는 확인 필요다.

### 3-3. `Shipment Request Detail` — META+코드연결, 표시 19 (?9)
- 기본: DIVISION_ID(Div), ORIGIN_DIVISION_ID(Org Div), FROM_SITE(From Site*), TO_SITE(To Site*), MODEL_ID(Model*), ITEM_ID(Material*), NICK_NAME(Nick Name), SHIPMENT_DATE(**Shipment ETA***), SHIPMENT_QTY(Qty*), INCOTERMS(Incoterms*), TRANSPORT_MODE(Trans Mode*), BOD_ID, CONFIRM_DAY, REQUEST_DATE(Request Date), REQUESTOR(Requestor), EDIT_FLAG
- 숨김: SCM_SITE_ID, PLANT_ID, LT, ETD, ETA, ROUTE_ID, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, ELECTRODE_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID
- 숨김 컬럼 중 ROUTE_ID~TO_CITY 8종은 `SpdDetail_ClipboardPasted`가 BOD 조회 결과로 채운다.
- 셀 콤보: InsertRow:1481~1482에서 FROM_SITE·TO_SITE에 PlantByElectordeShipFromSite/ToSite 콤보를 설정한다.

### 3-4. `Shipment Request Detail Excel` — META+코드연결, 표시 12 (?9)
- 기본: COMPANY_ID(Company*), DIVISION_ID(Div*), FROM_SITE(FromSite*), TO_SITE(ToSite*), ITEM_ID(Material*), YYYYMMDD(yyyyMMdd*), QTY(Qty*), INCOTERMS(Incoterms*), TRANSPORT_MODE(Trans Mode*)

### 3-5. `Project` — 코드 하드코딩 전용(메타 없음), 8컬럼
DIVISION_ID(Division), DIVISION_NAME(Division), MODEL_ID(Model), ITEM_ID(Material), INCOTERMS(Incoterms), TRANSPORT_MODE(Transport Mode), BOD_ID(BOD ID), CONFIRM_DAY(Confirm Day) — InitSpread:208~215

### 3-6. `Shipment Reqeust(Electrode)` — 코드 하드코딩 전용(메타 없음), 26컬럼
시트명의 "Reqeust" 오탈자는 원문 그대로다. InitSpread:257~285.

| 유형 | 컬럼(라벨) |
|---|---|
| Combo | DIVISION_ID(Div*), SCM_SITE_ID(SCM Site*), PLANT_ID(Plant), FROM_SITE(From Site*), TO_SITE(To Site*), INCOTERMS(Incoterms*), TRANSPORT_MODE("Trans Mode* ") |
| Text | MODEL_ID(Model*), ITEM_ID(Material*), NICK_NAME(Nick Name) |
| Date | SHIPMENT_DATE(Shipment Date*), ETD, ETA |
| Num | SHIPMENT_QTY("Qty* "), LT(L/T(Day)) |
| Text(라벨=필드명) | ROUTE_ID, BOD_ID, CONFIRM_DAY, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, ELECTRODE_YN, ORIGIN_FROM_DIVISION_ID |

## 4. 시트 연결 규칙
| 시트 | 연결 규칙 | Spread | 헤더 행 수 (AddSheet 인자) |
|---|---|---|---|
| Shipment Request(Electrode) | META+코드연결 | spdMain | 3 ¦ 1 ¦ 35 |
| Stock Detail | META+코드연결 | spdDetail (탭 0) | 3 ¦ 1 ¦ 60 |
| Shipment Request Detail | META+코드연결 | spdDetail (탭 1) | 1 ¦ 1 ¦ 60 |
| Shipment Request Detail Excel | META+코드연결 | spdSub (AddSheet), SheetTabClick의 탭 2 | 1 ¦ 1 ¦ 60 |
| Project | 코드 하드코딩 전용 | 확인 필요 | — |
| Shipment Reqeust(Electrode) | 코드 하드코딩 전용 | 확인 필요 | — |

AddSheet 인자 `3 ¦ 1 ¦ 35` 중 둘째와 셋째 값이 무엇을 뜻하는지는 프레임워크 시그니처를 보고 **확인 필요**다.

## 5. 표시 규칙 (코드)
| 조건 | 결과 |
|---|---|
| rdButton1(UOM) | TOT/JR/PC_BOH_QTY 표시, _CELL·_PCM 숨김. 날짜 컬럼 X_ 표시, Y_·Z_ 숨김 |
| rdButton2(Cell) | _CELL 표시, 나머지 숨김. Y_ 표시, X_·Z_ 숨김 |
| rdButton3(Pancake m) | _PCM 표시, 나머지 숨김. Z_ 표시, X_·Y_ 숨김 |
| Bucket=DAILY | ?_D_·?_W_ 표시(1917 등), ?_M_·?_W_ = chkSum.Checked(1922 등). W가 두 조건에 모두 걸려 최종값은 확인 필요 |
| Bucket=WEEKLY | ?_D_ 숨김, ?_W_ 표시, ?_M_ = chkSum.Checked |
| Bucket=MONTHLY | ?_D_·?_W_ 숨김, ?_M_ 표시 |
| Including Past Period 미체크 | 헤더 2행이 "SUM"이 아닌 컬럼 중 날짜가 기준일보다 과거인 컬럼은 숨김 (SetSpreadColumn:2081) |
| 주말 | SAT=Blue, SUN=Red 글자색 |
