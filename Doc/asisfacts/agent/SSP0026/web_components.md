# SSP0026 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → 컴포넌트 매핑 (메인 화면)

라벨은 props.csv 에 있는 LayoutControlItem.Text 또는 컨트롤 Text 원문입니다. 원문이 없으면 '확인 필요'로 적었습니다.

### 1-1. 조회조건 패널 (usrConditionPanel1 → usrLayoutControl2)

| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | Division (LCI `clbDivision`) | 244×20 | 단일선택 ComboBox | SelectedIndexChanged → Grid 재구성(GetSpdTitle) |
| clbPlantSite | UsrCheckedList | Plant Site (lblPlantSite) | 244×21 | 다중선택 MultiSelect | |
| clbSalesSite | UsrCheckedList | Sales Site (lblSalesSite) | 242×21 | 다중선택 MultiSelect | |
| clbCustomer | UsrCheckedList | End Customer (lblCustomer) | 247×21 | 다중선택 MultiSelect | SelectedIndexChanged 배선 |
| clbTeam | UsrCheckedList | Team (lblTeam) | 306×21 | 다중선택 MultiSelect | SelectedIndexChanged 배선 |
| txtItemId | UsrMultiLineEditor | Model (lblModel) | 255×21 | 다중 입력 텍스트 + 팝업 버튼 | |
| btnItemId | UsrButton | (Text 확인 필요) | 37×20 | 아이콘 버튼 | BtnItemID_Click |
| txtProject | UsrMultiLineEditor | Project (lblProject) | 255×21 | 다중 입력 텍스트 + 팝업 버튼 | |
| btnProject | UsrButton | (Text 확인 필요) | 39×20 | 아이콘 버튼 | btnProject_Click |
| cboBucketType | UsrCombo | Bucket (lblBucket) | 256×20 | ComboBox | 값 DAILY/WEEKLY/MONTHLY (SetSpreadColumn 조건) |
| drpPeriod | UsrDateRangePicker | (LCI `Period` 의 Text 확인 필요) | 180×20 | DateRange | |
| btnMeasure | UsrButton | (Text 확인 필요) | 34×20 | 버튼 | btnMeasure_Click → Grid 재구성 |
| chkSum | UsrCheckBox | Sum | 70×21 | CheckBox | M_/W_ 컬럼 표시 전환 |
| chkPastPeriod | UsrCheckBox | Including Past Period | 180×21 | CheckBox | Checked=true, **Visible=false** |
| btnColumn | UsrButton | (Text 확인 필요) | 40×21 | — | **Visible=false** |
| formDown | UsrButton | Excel Form | 90×21 | 버튼 | 양식 다운로드 |
| btnExcelUpload | UsrButton | Upload | 70×21 | 버튼 | MSG00265 확인 후 업로드 |
| (lblItemType) | LayoutControlItem | Item Type | 297×24 | 확인 필요 | 연결된 Control 이 props 에 없음 |

### 1-2. 하단 상세 영역 (splitContainer1.Panel2 → usrLayoutControl3)

| As-is 컨트롤 | 유형 | 라벨(원문) | TO-BE 후보 | 비고 |
|---|---|---|---|---|
| drpPeriod2 | UsrDateRangePicker | 확인 필요 | DateRange | |
| txtRequestor / btnRequestor | UsrMultiLineEditor / UsrButton | 확인 필요 | 텍스트 + 팝업 버튼 | BtnRequestor_Click |
| txtItemld2 / btnItemID2 | UsrMultiLineEditor / UsrButton | 확인 필요 | 텍스트 + 팝업 버튼 | BtnItemID2_Click |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 다중 입력 텍스트 | |
| textNickName2 | TextBox | 확인 필요 | Input | |
| btnSearch | SimpleButton | 확인 필요 | 버튼 | BtnSearch_Click → 상세 조회 |

### 1-3. Grid

| As-is | 위치 | TO-BE |
|---|---|---|
| spdMain (FpSpread) | splitContainer1.Panel1 | Wijmo FlexGrid, 시트 탭(Pack Biz / Cell Biz), 3행 헤더 |
| spdDetail (FpSpread) | splitContainer1.Panel2 | Wijmo FlexGrid, 시트 탭(Shipment Request Detail / Shipment Result Detail) |
| spdSub (FpSpread) | splitContainer1.Panel2 | 화면 비표시용 Excel 양식 Grid(Shipment Request Detail Excel). 표시 여부는 **확인 필요** |

### 1-4. 공용 팝업

| 팝업 | 컨트롤 | 라벨 |
|---|---|---|
| SSP0026_BodItemPopup | clbDivision, clbFromSite, clbToSite, txtItemID, txtToSite, btnButtonList, spdMain | lblDivision / lblFromSite / lblToSite / lblItemID / lbl_ToSiteText (Text 원문 확인 필요) |
| SSP0026_ItembyDivisionPopup | clbDivision, clbScmSite, txtItemID, txtProject, btnButtonList, spdMain | 확인 필요 (controls.csv 절단) |

## 2. 화면 배치

| 영역 | 속성(원문) | 해석 |
|---|---|---|
| usrConditionPanel1 | Dock=Top, Size=1284×94, UsrPanelType=HidePanel | 상단 조회조건이며 접을 수 있음 |
| splitContainer1 | Dock=Fill, Orientation=Horizontal | **상/하 분할**: 상 Panel1=spdMain, 하 Panel2=usrLayoutControl3 + spdDetail + spdSub |
| splitContainer1.SplitterDistance | 확인 필요 (props.csv 절단) | 상/하 비율 미확정 |

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

표기: 필수 = USER_SELECTABLE_FLAG='N', 기본 = DEFAULT_FLAG='Y', 숨김 = 메타 VISIBLE/VALID 가 아님, →표시/→숨김 = 코드에서 변경.

### 3-1. `Pack Biz` (spdMain, META+코드연결, 3행 헤더)

| 컬럼 | 라벨 | 40 | 그 외 Division |
|---|---|---|---|
| DIVISION_ID | Division* | 필수 | — |
| END_CUSTOMER | End Customer | 필수 | — |
| TEAM_NAME_KO | Team | 필수 | — |
| LAST_UPDATED_BY | Requestor | 필수 | — |
| REMARK | Customer Requirement | 필수 | — |
| CONFIRM_DAY | CONFIRM_DAY | 기본 | — |
| FROM_SITE | From ( Plant )* | 기본 | — |
| SITE_DESCRIPTION | Plant site | 기본 | — |
| TO_SITE | To ( Sales-Site )* | 기본 | — |
| INCOTERMS | Incoterms* | 기본 | — |
| TR_MODE | Trans Mode* | 기본 | — |
| MODEL_ID | Model* | 기본 | — |
| NICK_NAME | Nick Name | 기본 | — |
| MEASURE | Measure* | 기본 | — |
| FCST_TYPE | FCST Type* | 기본 →숨김 | →숨김 |
| SHIPTO_CODE | (메타 없음) | →표시 | →표시 |
| ORDER_TYPE_DETAIL | (메타 없음) | →표시 | →표시 |
| BOD_ID / MEASURE_COLOR / PROJECT_CODE / SHIP_FROZEN | BOD ID* / MEASUR_COLOR / Project Code* / DMF0045 | 숨김 | — |

합계: 40 = 16, 그 외 = 2. 여기에 SP 와 GetSpdTitle 이 만드는 D_/W_/M_ 버킷 컬럼이 붙습니다(Measure 8건, Division 40).

### 3-2. `Cell Biz` (spdMain, META+코드연결, CreateSpread:340 `drPgmAuthId != null` 일 때만 생성)

| 컬럼 | 라벨 | 40 |
|---|---|---|
| DIVISION_ID | Division* | 필수 |
| END_CUSTOMER | End Customer | 필수 |
| TEAM_NAME_KO | Team | 필수 |
| LAST_UPDATED_BY | Requestor | 필수 |
| REMARK | Customer Requirement | 필수 |
| FCST_TYPE | FCST Type* | 기본 |
| FROM_SITE | Frorm ( Plant )* | 기본 |
| TO_SITE | To ( Sales-Site )* | 기본 |
| INCOTERMS | Incoterms* | 기본 |
| TR_MODE | Trans Mode* | 기본 |
| MODEL_ID | Model* | 기본 |
| NICK_NAME | Nick Name | 기본 |
| MEASURE | Measure* | 기본 |
| BOD_ID / MEASURE_COLOR / SHIP_FROZEN / SITE_DESCRIPTION | BOD ID* / MEASUR_COLOR / Confirm day / Plant site | 숨김 |

합계: 40 = 13, 그 외 Division 은 메타 없음. Measure 10건(Division 40). ORDER_TYPE_DETAIL 과 SHIPTO_CODE 는 CODE_ONLY_CHANGE 이지만 Cell Biz 에는 영향이 없습니다.

### 3-3. `Shipment Request Detail` (spdDetail, META+코드연결, MergePolicy.None) — 모든 Division 35

| 컬럼 | 라벨 | 컬럼 | 라벨 |
|---|---|---|---|
| DIVISION_ID | Div* | MODEL_ID | Model* |
| FROM_SITE | From Site* | NICK_NAME | Nick Name |
| SITE_DESCRIPTION | Plant Site | QTY | Qty* |
| TO_SITE | To Site* | YYYYMMDD | Shipment Date* |
| SHIPTO_CODE | Ship to* | EXPECTED_SHIP_DATE | Expected Shipping Date |
| SHIPTO_NAME | Ship to Name | ETD_DATE | ETD |
| SOLDTO_CODE | Sold to | ETA_DATE | ETA |
| END_CUSTOMER | End Customer | LT_TOTAL | L/T(Day) |
| INCOTERMS | Incoterms* | REQUEST_ID | Confrim/Plan ID |
| TR_MODE | Trans Mode* | CHANGE_REQUEST_NO | Change Request No |
| FCST_TYPE | FCST Type* | STATUS | Status |
| ORDER_TYPE_DETAIL | Order Type Detail | REMARK | Remark |
| BOD_ID | BOD_ID | LAST_UPDATED_BY | Requestor |
| MODEL_USER | Model PIC | LAST_UPDATED_DATE | Request Date |
| MKT_OWMER | MKT Owner | EDIT_FLAG | EDIT_FLAG |
| ATTRIBUTE3 | RTF | TEMP | TEMP |
| ATTRIBUTE4 | RTF ETD | ATTRIBUTE5 | RTF QTY |
| ATTRIBUTE6 | RTF Detail | (숨김) MODEL_PIC, MOEL_USER | Model PIC |

컬럼 순서는 SCM_MST_SHEET_COLUMNS 의 SORT_ORDER_NO 를 따릅니다. 이 표는 순서가 아니며, 실제 순서는 **확인 필요**입니다.

### 3-4. `Shipment Result Detail` (spdDetail, META+코드연결) — 모든 Division 12

DIVISION_ID(Division*), FROM_SITE(From ( Plant )*), SITE_DESCRIPTION(Plant site), TO_SITE(To ( Sales-Site )*), SHIP_TO(Ship to), SHIPTO_DESCRIPTION(Ship to Name), MODEL_ID(Model*), QTY(Qty*), YYYYMMDD(Shipment Date), LAST_UPDATED_BY(Last Updated by), LAST_UPDATED_DATE(Last Update Date), TEMP(TEMP). 숨김: SCM_SITE_ID.

### 3-5. `Shipment Request Detail Excel` (spdSub, META+코드연결) — 모든 Division 10

DIVISION_ID(Div*), FROM_SITE(FromSite*), TO_SITE(ToSite*), SHIPTO_CODE(ShipTo*), ITEM_ID(Model*), QTY(Qty*), YYYYMMDD(yyyyMMdd*), INCOTERMS(Incoterms*), TRANSPORT_MODE(Trans Mode*), FCST_TYPE(FCST Type*). Excel 양식 다운로드와 업로드의 기준 컬럼입니다. SCM_ADM_EXCEL_COLUMNS 2행과의 관계는 **확인 필요**합니다.

### 3-6. `Shipment Request Detail_BACKUP` — 메타 정의만 있고 코드 미참조(미사용 가능), 19

BOD_ID, DIVISION_ID, EDIT_FLAG, FCST_TYPE, FROM_SITE, INCOTERMS, LAST_UPDATED_BY, LAST_UPDATED_DATE, MODEL_ID, NICK_NAME, ORDER_TYPE_DETAIL, QTY, REMARK, SHIPTO_CODE, SHIPTO_NAME, SITE_DESCRIPTION, TO_SITE, TR_MODE, YYYYMMDD (숨김: FCST_TYPE2). TO-BE 에서 구현하지 않는 후보입니다.

### 3-7. `Project` — 코드 하드코딩 전용(메타 없음), 14 (공용 팝업 Grid)

| 줄 | 헤더 | 필드 |
|---:|---|---|
| 189 / 204 | Division | DIVISION_ID |
| 190 / 205 | Division | DIVISION_NAME |
| 191 | Project Code | PROJECT_CODE |
| 192 | Project | PROJECT_NAME |
| 193 | SCM Site | SCM_SITE_ID |
| 194 | Site | SITE_DESCRIPTION |
| 195 / 207 | Model Code / Material | ITEM_ID |
| 196 | Model | ITEM_NAME |
| 197 | Type | ITEM_TYPE |
| 198 | Nick Name | NICK_NAME |
| 199 | Class Name | ITEM_CLASS_NAME |
| 208 | Incoterms | INCOTERMS |
| 209 | Transport Mode | TRANSPORT_MODE |
| 210 | BOD ID | BOD_ID |

189~199 줄과 204~210 줄은 서로 다른 팝업 Grid 정의로 보입니다. 각 줄이 어느 파일(ItembyDivisionPopup / BodItemPopup)에 속하는지는 grid_code.csv 가 잘려 있어 **확인 필요**입니다. TO-BE 에서는 팝업별로 Grid 를 나눠 구현해야 합니다.

## 4. 시트 연결 규칙

1. spdMain 활성 시트(Pack Biz / Cell Biz)가 저장과 조회 SP 를 결정합니다.
   - FindData: ActiveSheetIndex 0 → PACK SP(787), 1 → CELL SP(848)
   - SaveData: PACK(1508) / CELL(1580)
2. `SpdMain_CellDoubleClick` 은 메인 행으로 spdDetail 의 Shipment Request Detail 을 조회합니다(FindData_Detail_DblClick → DETAIL_PACK 1232 / DETAIL_CELL 1274).
3. `SpdMain_ActiveSheetChanged` 에서 Pack Biz 로 바뀌었는데 spdDetail 에 Shipment Result Detail 시트가 없으면 AddSheet 합니다(3604). Cell Biz 일 때는 ChangeSheet 만 합니다(3629).
4. `BtnSearch_Click`: spdDetail.ActiveSheetIndex 가 0 이면 Request Detail 조회, 1 이면 Result Detail 조회입니다(3112 / 3120).
5. Excel Form 버튼은 spdSub(Shipment Request Detail Excel) 기준으로 양식을 내려받습니다(EXCEL_DOWN SP). Upload 버튼은 MSG00265 확인 후 Request Detail 시트로 반영합니다.
6. spdDetail 편집:
   - TO_SITE 를 바꾸면 SHIPTO_CODE 콤보를 ShipToCodeByDivision 으로 다시 채웁니다.
   - 콤보 선택이나 붙여넣기가 있으면 GET_BOD_ITEM 과 TransMode 를 조회합니다.
