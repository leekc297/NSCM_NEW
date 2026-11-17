# SSP0026 Shipment Request Pack — 화면설계서

> 근거: Fact Pack(controls.csv · props.csv · events.csv · flow.csv · grid_effective)과 1차 분석서. props.csv가 잘려 있어 확인하지 못한 속성은 **확인 필요**로 적었습니다.
> §5 액션 명세의 엔드포인트 이름은 업무분석서 §5와 같습니다. §3의 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0026 |
| 화면 명칭 | Shipment Request Pack (클래스 `SSP0026_ShipmentRequestPack`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행, TB_FX_ProgramInfo 2행. 값은 Fact Pack에 없음) |
| 프로젝트 | `06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0026_ShipmentRequestPack.UIL\SSP0026_ShipmentRequestPack.UIL.csproj` |
| 공용 팝업 | `SSP0026_BodItemPopup`, `SSP0026_ItembyDivisionPopup` (`06.UIL\GSCM.SSP.Plan.UIL\Popup\`) |
| Grid 구성 | HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경) |
| 시트 | `Pack Biz`, `Cell Biz`, `Shipment Request Detail`, `Shipment Result Detail`, `Shipment Request Detail Excel`, `Project`, `Shipment Request Detail_BACKUP`(코드 미참조) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)

```
SSP0026_ShipmentRequestPack (this)
├─ usrConditionPanel1   [Dock=Top · Size=1284×94 · UsrPanelType=HidePanel]  ← 조회조건 (접기 가능)
│   └─ usrLayoutControl2 [Dock=Fill · Size=1284×94]
│        ├─ cboDivision · clbPlantSite · clbSalesSite · clbCustomer · clbTeam
│        ├─ txtItemId + btnItemId · txtProject + btnProject
│        ├─ cboBucketType · drpPeriod · btnMeasure · chkSum · chkPastPeriod(Visible=false)
│        └─ formDown(Excel Form) · btnExcelUpload(Upload) · btnColumn(Visible=false)
└─ splitContainer1      [Dock=Fill · Orientation=Horizontal → 상/하 분할 · SplitterDistance=확인 필요]
    ├─ Panel1 (상)  ── spdMain (spdMain_Sheet1)            ← 메인 그리드: 시트 Pack Biz / Cell Biz
    └─ Panel2 (하)
         ├─ usrLayoutControl3                              ← 상세 조회조건
         │    drpPeriod2 · txtRequestor + btnRequestor · txtItemld2 + btnItemID2 · txtLotID · textNickName2 · btnSearch
         ├─ spdDetail (spdDetail_Sheet1)                   ← 상세 그리드: Shipment Request Detail / Shipment Result Detail
         └─ spdSub (spdSub_Sheet1)                         ← Excel 양식 그리드: Shipment Request Detail Excel (화면 표시 여부 확인 필요)

(부모 미기재) usrLayoutControl1 [Dock=Fill · Size=657×184] / layoutControlGroup1 [657×184]
   → controls.csv parent 값이 비어 있어 배치 위치를 알 수 없음. 확인 필요
```

| 영역 | 비율 | 근거 |
|---|---|---|
| 조회조건 : 그리드 영역 (세로) | 조회조건은 고정 높이 94px. 폼 전체 높이를 알 수 없어 %는 **확인 필요** | usrConditionPanel1 Size |
| splitContainer1 상(Panel1) : 하(Panel2) | **확인 필요** (SplitterDistance가 props.csv 절단 구간에 있음) | Orientation=Horizontal |
| Panel2 안의 usrLayoutControl3, spdDetail, spdSub 배치(Dock) | **확인 필요** | props.csv 절단 |

### 2-2. 팝업 레이아웃

```
SSP0026_BodItemPopup (this)
├─ usrConditionPanel1
│   └─ usrLayoutControl2: clbDivision(lblDivision) · clbFromSite(lblFromSite) · clbToSite(lblToSite)
│                         · txtItemID(lblItemID) · txtToSite(lbl_ToSiteText) · btnButtonList
└─ spdMain (spdMain_Sheet1)   ← 시트 Project(하드코딩 InitSpread 204~210, 소속 파일 확인 필요)

SSP0026_ItembyDivisionPopup (this)
├─ usrConditionPanel1
│   └─ usrLayoutControl2: clbDivision · clbScmSite · txtItemID · txtProject · btnButtonList
└─ spdMain (spdMain_Sheet1)   ← 시트 Project(하드코딩 InitSpread 189~199, 소속 파일 확인 필요)
```
팝업 컨트롤의 Dock과 Size는 **확인 필요**입니다(props.csv 절단).

## 3. 컨트롤 명세

라벨은 props.csv의 Text 원문(LayoutControlItem 포함)입니다. 원문을 확인하지 못한 것은 '확인 필요'로 적었습니다. 필수 여부를 표시한 원문은 없으므로 모두 **확인 필요**입니다.

### 3-1. 메인 화면

| 컨트롤명 | 타입 | 라벨(원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrLayoutControl1 | UsrLayoutControl | — | Dock=Fill, 657×184 | — | — | 레이아웃 컨테이너 (사용처 확인 필요) |
| usrConditionPanel1 | UsrConditionPanel | — | Dock=Top, 1284×94, HidePanel | — | — | 공통 조회조건 패널(접기) |
| usrLayoutControl2 | UsrLayoutControl | — | Dock=Fill, 1284×94 | — | — | 조회조건 레이아웃 |
| cboDivision | UsrCombo | Division (LCI `clbDivision`) | MyDivision 목록. 기본 선택값 **확인 필요** | 확인 필요 | cboDivision_SelectedIndexChanged | 단일선택 ComboBox |
| clbPlantSite | UsrCheckedList | Plant Site (lblPlantSite) | 확인 필요 | 확인 필요 | — | MultiSelect |
| clbSalesSite | UsrCheckedList | Sales Site (lblSalesSite) | 확인 필요 | 확인 필요 | — | MultiSelect |
| clbCustomer | UsrCheckedList | End Customer (lblCustomer) | 확인 필요 | 확인 필요 | clbCustomer_SelectedIndexChanged | MultiSelect |
| clbTeam | UsrCheckedList | Team (lblTeam) | 확인 필요 | 확인 필요 | clbTeam_SelectedIndexChanged | MultiSelect |
| txtItemId | UsrMultiLineEditor | Model (lblModel) | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| btnItemId | UsrButton | 확인 필요 | — | — | BtnItemID_Click | 팝업 아이콘 버튼 |
| txtProject | UsrMultiLineEditor | Project (lblProject) | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| btnProject | UsrButton | 확인 필요 | — | — | btnProject_Click | 팝업 아이콘 버튼 |
| cboBucketType | UsrCombo | Bucket (lblBucket) | `DM.DM0003_GET_BUCKET_TYPE_CODE` 목록(DAILY/WEEKLY/MONTHLY). 기본값 **확인 필요** | 확인 필요 | cboBucketType_SelectedIndexChanged | ComboBox |
| drpPeriod | UsrDateRangePicker | 확인 필요 (LCI `Period`) | 확인 필요 (InitControls가 FROM_DATE, TO_DATE, FIRST_DATE, CONFIRM_DAY를 읽음) | 확인 필요 | — | DateRange |
| btnMeasure | UsrButton | 확인 필요 | — | — | btnMeasure_Click | 버튼 |
| chkSum | UsrCheckBox | Sum | 확인 필요 | — | chkSum_CheckedChanged | CheckBox |
| chkPastPeriod | UsrCheckBox | Including Past Period | Checked=true, **Visible=false** | — | chkPastPeriod_CheckedChanged | CheckBox(숨김) |
| btnColumn | UsrButton | 확인 필요 | **Visible=false** | — | btnColumn_Click | (비노출) |
| formDown | UsrButton | Excel Form | — | — | btnExcelFormDownload_Click | 버튼 |
| btnExcelUpload | UsrButton | Upload | — | — | btnExcelUpload_Click | 버튼(파일 업로드) |
| spdMain | FpSpread | — | 시트 Pack Biz(+Cell Biz) | — | SpdMain_TopChange, SpdMain_CellDoubleClick, SpdMain_ComboSelChange, SpdMain_ClipboardPasted, SpdMain_ActiveSheetChanged | Wijmo FlexGrid + 시트 탭 |
| spdMain_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | (FlexGrid 시트) |
| usrLayoutControl3 | UsrLayoutControl | — | Panel2 | — | — | 상세 조회조건 레이아웃 |
| drpPeriod2 | UsrDateRangePicker | 확인 필요 | 확인 필요 | 확인 필요 | — | DateRange |
| txtRequestor | UsrMultiLineEditor | 확인 필요 | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| btnRequestor | UsrButton | 확인 필요 | — | — | BtnRequestor_Click | 팝업 아이콘 버튼 |
| txtItemld2 | UsrMultiLineEditor | 확인 필요 | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| btnItemID2 | UsrButton | 확인 필요 | — | — | BtnItemID2_Click | 팝업 아이콘 버튼 |
| txtLotID | UsrMultiLineEditor | 확인 필요 | 확인 필요 | 확인 필요 | — | 다중 입력 텍스트 |
| textNickName2 | TextBox | 확인 필요 | 확인 필요 | 확인 필요 | — | Input |
| btnSearch | SimpleButton | 확인 필요 | — | — | BtnSearch_Click | 버튼(상세 조회) |
| spdDetail | FpSpread | — | 시트 Shipment Request Detail / Shipment Result Detail | — | SpdDetail_TopChange, SpdDetail_ComboSelChange, SpdDetail_CellDoubleClick, SpdDetail_ClipboardPasted, SpdDetail_ActiveSheetChanged | Wijmo FlexGrid + 시트 탭 |
| spdDetail_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | (FlexGrid 시트) |
| spdSub | FpSpread | — | 시트 Shipment Request Detail Excel | — | — | 화면 비표시 양식 정의(표시 여부 확인 필요) |
| spdSub_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | — |

### 3-2. 공용 팝업

| 컨트롤명 | 타입 | 팝업 | 라벨(원문) | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|
| clbDivision | UsrCheckedList | BodItemPopup, ItembyDivisionPopup | lblDivision (Text 확인 필요) | clbDivision_SelectedIndexChanged | MultiSelect |
| clbFromSite | UsrCheckedList | BodItemPopup | lblFromSite (Text 확인 필요) | — | MultiSelect |
| clbToSite | UsrCheckedList | BodItemPopup | lblToSite (Text 확인 필요) | — | MultiSelect |
| txtToSite | UsrMultiLineEditor | BodItemPopup | lbl_ToSiteText (Text 확인 필요) | — | 텍스트 |
| txtItemID | UsrMultiLineEditor | BodItemPopup, ItembyDivisionPopup | lblItemID (Text 확인 필요) | — | 다중 입력 텍스트 |
| clbScmSite | UsrCheckedList | ItembyDivisionPopup | 확인 필요 | — | MultiSelect |
| btnButtonList | UsrButtonList | BodItemPopup, ItembyDivisionPopup | — | btnButtonList_UsrButtonList_Click_Detected | 팝업 버튼바(조회/선택 등, 구성 확인 필요) |
| spdMain (팝업) | FpSpread | 두 팝업 | — | spdMain_CellDoubleClick, (Form_Load) | Wijmo FlexGrid |
| txtProject (팝업) | UsrMultiLineEditor | ItembyDivisionPopup | 확인 필요 | — | 텍스트 |

> 메인 화면의 `clbDivision`은 컨트롤이 아니라 LayoutControlItem(cboDivision의 라벨)입니다. 팝업의 `clbDivision`은 UsrCheckedList입니다.

## 4. 그리드 명세

공통: 출처 META = SCM_MST_SHEET_COLUMNS(SetSheetHeaderColumn / CreateSheetHeaderColumn), HARDCODED = AddTextColumn. 셀 타입은 메타의 CELL_CONTROL_OBJECT_TYPE_CODE / CELL_COMBO_DATA_TYPE 값으로 정해지는데, 그 값이 Fact Pack에 없어 **확인 필요**입니다. 편집 가능 여부도 같은 이유로 **확인 필요**이며, 콤보 이벤트 근거가 있는 컬럼만 '콤보 편집'으로 적었습니다.
표기: 필수 = USER_SELECTABLE_FLAG='N', 기본 = DEFAULT_FLAG='Y', →표시/→숨김 = 코드에서 변경.

### 4-1. `Pack Biz` (spdMain, 3행 헤더, CreateSheetHeaderColumn@InitSpread:413)

| 컬럼 | 헤더 | 출처 | Div 40 | 그 외 Division | 편집 |
|---|---|---|---|---|---|
| DIVISION_ID | Division* | META | 필수 | — | 확인 필요 |
| END_CUSTOMER | End Customer | META | 필수 | — | 확인 필요 |
| TEAM_NAME_KO | Team | META | 필수 | — | 확인 필요 |
| LAST_UPDATED_BY | Requestor | META | 필수 | — | 확인 필요 |
| REMARK | Customer Requirement | META | 필수 | — | 확인 필요 |
| CONFIRM_DAY | CONFIRM_DAY | META | 기본 | — | 확인 필요 |
| FROM_SITE | From ( Plant )* | META | 기본 | — | 콤보(InsertRow 사용자 기준 필터) |
| SITE_DESCRIPTION | Plant site | META | 기본 | — | 확인 필요 |
| TO_SITE | To ( Sales-Site )* | META | 기본 | — | 콤보(InsertRow) |
| INCOTERMS | Incoterms* | META | 기본 | — | 확인 필요 |
| TR_MODE | Trans Mode* | META | 기본 | — | TransMode 반영(FindData_BOD_Main) |
| MODEL_ID | Model* | META | 기본 | — | 확인 필요 |
| NICK_NAME | Nick Name | META | 기본 | — | 확인 필요 |
| MEASURE | Measure* | META | 기본 | — | 확인 필요 |
| FCST_TYPE | FCST Type* | META | 기본 → **숨김**(3595) | →숨김 | — |
| SHIPTO_CODE | (메타 라벨 없음) | 코드 표시 | →표시(3592·3593) | →표시 | 확인 필요 |
| ORDER_TYPE_DETAIL | (메타 라벨 없음) | 코드 표시 | →표시(3594) | →표시 | 확인 필요 |
| BOD_ID / MEASURE_COLOR / PROJECT_CODE / SHIP_FROZEN | BOD ID* / MEASUR_COLOR / Project Code* / DMF0045 | META | 숨김 | — | — |
| D_* / W_* / M_* / SUM | GET_SPREAD_TITLE 결과(날짜) | 동적(SP) | Bucket·chkSum·chkPastPeriod 규칙 | 같음 | 확인 필요 |

최종 표시 컬럼 수: 40 = 16, 그 외 = 2. 그 외 Division의 실제 화면은 **확인 필요**입니다. Measure는 8건(Div 40)입니다.

### 4-2. `Cell Biz` (spdMain, 3행 헤더, `drPgmAuthId != null`일 때만 생성)

| 컬럼 | 헤더 | 출처 | Div 40 | 그 외 |
|---|---|---|---|---|
| DIVISION_ID | Division* | META | 필수 | 메타 없음 |
| END_CUSTOMER | End Customer | META | 필수 | 〃 |
| TEAM_NAME_KO | Team | META | 필수 | 〃 |
| LAST_UPDATED_BY | Requestor | META | 필수 | 〃 |
| REMARK | Customer Requirement | META | 필수 | 〃 |
| FCST_TYPE | FCST Type* | META | 기본 | 〃 |
| FROM_SITE | Frorm ( Plant )* | META | 기본 | 〃 |
| TO_SITE | To ( Sales-Site )* | META | 기본 | 〃 |
| INCOTERMS | Incoterms* | META | 기본 | 〃 |
| TR_MODE | Trans Mode* | META | 기본 | 〃 |
| MODEL_ID | Model* | META | 기본 | 〃 |
| NICK_NAME | Nick Name | META | 기본 | 〃 |
| MEASURE | Measure* | META | 기본 | 〃 |
| BOD_ID / MEASURE_COLOR / SHIP_FROZEN / SITE_DESCRIPTION | BOD ID* / MEASUR_COLOR / Confirm day / Plant site | META | 숨김 | 〃 |
| D_* / W_* / M_* / SUM | GET_SPREAD_TITLE 결과 | 동적 | 버킷 규칙 | — |

합계: 40 = 13, Measure 10건. 편집 가능 여부는 **확인 필요**입니다.

### 4-3. `Shipment Request Detail` (spdDetail, SetSheetHeaderColumn@InitSpread:386, MergePolicy.None) — 모든 Division 35컬럼, 출처 META

| 컬럼 | 헤더 | 컬럼 | 헤더 |
|---|---|---|---|
| DIVISION_ID | Div* | MODEL_ID | Model* |
| FROM_SITE | From Site* | NICK_NAME | Nick Name |
| SITE_DESCRIPTION | Plant Site | QTY | Qty* |
| TO_SITE | To Site* (콤보, 변경 시 SHIPTO_CODE 재설정) | YYYYMMDD | Shipment Date* |
| SHIPTO_CODE | Ship to* (콤보, ShipToCodeByDivision) | EXPECTED_SHIP_DATE | Expected Shipping Date |
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

컬럼 순서(SORT_ORDER_NO)와 다른 컬럼의 편집 여부는 **확인 필요**입니다.

### 4-4. `Shipment Result Detail` (spdDetail, InitSpread:398) — 모든 Division 12컬럼, 출처 META

DIVISION_ID(Division*), FROM_SITE(From ( Plant )*), SITE_DESCRIPTION(Plant site), TO_SITE(To ( Sales-Site )*), SHIP_TO(Ship to), SHIPTO_DESCRIPTION(Ship to Name), MODEL_ID(Model*), QTY(Qty*), YYYYMMDD(Shipment Date), LAST_UPDATED_BY(Last Updated by), LAST_UPDATED_DATE(Last Update Date), TEMP(TEMP). 숨김: SCM_SITE_ID. 조회 전용 여부는 **확인 필요**입니다.

### 4-5. `Shipment Request Detail Excel` (spdSub, InitSpread:407) — 모든 Division 10컬럼, 출처 META

DIVISION_ID(Div*), FROM_SITE(FromSite*), TO_SITE(ToSite*), SHIPTO_CODE(ShipTo*), ITEM_ID(Model*), QTY(Qty*), YYYYMMDD(yyyyMMdd*), INCOTERMS(Incoterms*), TRANSPORT_MODE(Trans Mode*), FCST_TYPE(FCST Type*). Excel Form과 Upload의 양식 기준입니다. SCM_ADM_EXCEL_COLUMNS 2행과의 관계는 **확인 필요**입니다.

### 4-6. `Project` (팝업 spdMain, HARDCODED AddTextColumn, 메타 없음) — 14컬럼

| 줄 | 헤더 | 필드 | 줄 | 헤더 | 필드 |
|---:|---|---|---:|---|---|
| 189/204 | Division | DIVISION_ID | 196 | Model | ITEM_NAME |
| 190/205 | Division | DIVISION_NAME | 197 | Type | ITEM_TYPE |
| 191 | Project Code | PROJECT_CODE | 198 | Nick Name | NICK_NAME |
| 192 | Project | PROJECT_NAME | 199 | Class Name | ITEM_CLASS_NAME |
| 193 | SCM Site | SCM_SITE_ID | 208 | Incoterms | INCOTERMS |
| 194 | Site | SITE_DESCRIPTION | 209 | Transport Mode | TRANSPORT_MODE |
| 195/207 | Model Code / Material | ITEM_ID | 210 | BOD ID | BOD_ID |

189~199줄과 204~210줄은 서로 다른 팝업 그리드 정의입니다. 각각 어느 팝업 파일에 속하는지는 **확인 필요**입니다. 편집 여부는 확인되지 않았고, 선택은 spdMain_CellDoubleClick으로 합니다.

### 4-7. `Shipment Request Detail_BACKUP` — 메타 정의만 있고 코드 미참조, 19컬럼

BOD_ID, DIVISION_ID, EDIT_FLAG, FCST_TYPE, FROM_SITE, INCOTERMS, LAST_UPDATED_BY, LAST_UPDATED_DATE, MODEL_ID, NICK_NAME, ORDER_TYPE_DETAIL, QTY, REMARK, SHIPTO_CODE, SHIPTO_NAME, SITE_DESCRIPTION, TO_SITE, TR_MODE, YYYYMMDD (숨김 FCST_TYPE2). 화면에 생성되지 않으며, TO-BE에서 구현하지 않는 후보입니다.

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A01 | 화면 Load | `Form_Load` | InitControls, GetBucketType, CreateSpread > InitSpread > GetSpdTitle | `biz:CommonData.CommonDataList`[MyDivision, Measure], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SSP.SSP0026_GET_SPREAD_TITLE` | cboDivision, cboBucketType, 시트 생성 |
| A02 | 조회(FindButton) | FindButton(프레임워크) | FindData | `biz:CommonData.CommonDataList`[Measure], `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` / `SSP.SSP0026_GET_SHIPMENT_REQUEST_CELL`, `SSP.SSP0026_GET_SPREAD_TITLE` | spdMain(Pack Biz / Cell Biz) |
| A03 | 저장(SaveButton) 메인 | SaveButton(프레임워크) | SaveData → FindData | `SSP.SSP0026_SAVE_SHIP_REQ_PACK` / `SSP.SSP0026_SAVE_SHIP_REQ_CELL` → 재조회(A02) | spdMain 재조회 |
| A04 | 저장(SaveButton) 상세 | SaveButton(프레임워크) | SaveData_Detail → FindData_Detail | `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_PACK` / `SSP.SSP0026_SAVE_SHIP_REQ_DETAIL_CELL`(⚠ DB 없음) → `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` | spdDetail 재조회 |
| A05 | btnSearch Click | `BtnSearch_Click` | 상세 시트 0 → FindData_Detail, 1 → FindData_Result_Detail | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL` / `SSP.SSP0026_GET_RESULT_DETAIL` + `SSP.SSP0026_GET_SPREAD_TITLE` | spdDetail |
| A06 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | FindData_Detail_DblClick | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `SSP.SSP0026_GET_REQUEST_DETAIL_CELL`, `SSP.SSP0026_GET_SPREAD_TITLE` | spdDetail(Shipment Request Detail) |
| A07 | formDown Click | `btnExcelFormDownload_Click` | FindData_Request_Detail_DownLoad | `SSP.SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN` | Excel 양식 파일(spdSub 기준) |
| A08 | btnExcelUpload Click | `btnExcelUpload_Click` | MSG00265 확인 → FindData, FindData_Detail | `biz:CommonData.CommonDataList`[Measure], `SSP.SSP0026_GET_SHIPMENT_REQUEST_PACK` / `_CELL`, `SSP.SSP0026_GET_REQUEST_DETAIL_PACK` / `_CELL`, `SSP.SSP0026_GET_SPREAD_TITLE` | spdMain, spdDetail |
| A09 | btnMeasure Click | `btnMeasure_Click` | InitSpread | `SSP.SSP0026_GET_SPREAD_TITLE` | spdMain 헤더 재구성 |
| A10 | btnColumn Click (Visible=false) | `btnColumn_Click` | InitSpread | `SSP.SSP0026_GET_SPREAD_TITLE` | 헤더 재구성 |
| A11 | cboDivision 변경 | `cboDivision_SelectedIndexChanged` | InitSpread (NowGroupID 사용) | `SSP.SSP0026_GET_SPREAD_TITLE` | 헤더 재구성 |
| A12 | chkSum 변경 | `chkSum_CheckedChanged` | SetSpreadColumn(2893) | 없음 | M_/W_ 컬럼 표시 전환 |
| A13 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | SetSpreadColumn(2124) | 없음 | D_/W_/M_ 표시 전환 |
| A14 | chkPastPeriod 변경 | `chkPastPeriod_CheckedChanged` | SetSpreadColumn(3776) | 없음 | 과거 날짜 컬럼 표시 전환 |
| A15 | btnProject Click | `btnProject_Click` | 확인 필요(팝업 연결 미확인) | 확인 필요 | txtProject (추정 금지, 확인 필요) |
| A16 | btnItemId Click | `BtnItemID_Click` | 확인 필요 | 확인 필요 | 확인 필요 |
| A17 | btnItemID2 Click | `BtnItemID2_Click` | 확인 필요 | 확인 필요 | 확인 필요 |
| A18 | btnRequestor Click | `BtnRequestor_Click` | 확인 필요 | 확인 필요 | 확인 필요 |
| A19 | clbCustomer 변경 | `clbCustomer_SelectedIndexChanged` | NowGroupID 사용. 내부 동작 확인 필요 | 확인 필요 | 확인 필요 |
| A20 | clbTeam 변경 | `clbTeam_SelectedIndexChanged` | NowGroupID 사용. 내부 동작 확인 필요 | 확인 필요 | 확인 필요 |
| A21 | spdMain 스크롤 | `SpdMain_TopChange` | 확인 필요(spdDetail 동기화 여부 미확인) | 없음 | 확인 필요 |
| A22 | spdDetail 스크롤 | `SpdDetail_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| A23 | spdMain 콤보 선택 | `SpdMain_ComboSelChange` | FindData_BOD_Main | `SSP.SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList`[TransMode] | spdMain 행 |
| A24 | spdMain 붙여넣기 | `SpdMain_ClipboardPasted` | FindData_BOD_Main | `SSP.SSP0026_GET_BOD_ITEM`, `biz:CommonData.CommonDataList`[TransMode] | spdMain 행 |
| A25 | spdDetail 콤보 선택 | `SpdDetail_ComboSelChange` | ShipTo 콤보 재설정 → FindData_BOD | `biz:CommonData.CommonDataList`[ShipToCodeByDivision], `SSP.SSP0026_GET_BOD_ITEM`, [TransMode] | spdDetail 행 |
| A26 | spdDetail 붙여넣기 | `SpdDetail_ClipboardPasted` | IsLock 확인(3466) → ShipTo → FindData_BOD | `biz:CommonData.CommonDataList`[ShipToCodeByDivision], `SSP.SSP0026_GET_BOD_ITEM`, [TransMode] | spdDetail 행 |
| A27 | spdDetail 더블클릭 | `SpdDetail_CellDoubleClick` | 확인 필요 | 없음 | 확인 필요 |
| A28 | spdDetail 시트 전환 | `SpdDetail_ActiveSheetChanged` | 확인 필요 | 없음 | 확인 필요 |
| A29 | spdMain 시트 전환 | `SpdMain_ActiveSheetChanged` | Pack Biz: SHIPTO_CODE·ORDER_TYPE_DETAIL 표시, FCST_TYPE 숨김, Result Detail 시트 AddSheet(3604) / Cell Biz: ChangeSheet(3629) / InitSpread | `SSP.SSP0026_GET_SPREAD_TITLE` | spdMain, spdDetail 시트 |
| P01 | BodItemPopup Load | `Form_Load` (팝업) | FindData, InitControls > GetDivision, GetDivisionbyScmSite | `SSP.SSP0026_GET_BOD_ITEM`, `SCM.SCM0001_GET_DIVISION`, `SCM.SCM0001_GET_SITE_BY_DIVISION` | 팝업 spdMain, clbDivision, clbFromSite/clbToSite(확인 필요) |
| P02 | ItembyDivisionPopup Load | `Form_Load` (팝업) | FindData, InitControls > GetDivision | `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP`, `SCM.SCM0001_GET_DIVISION` | 팝업 spdMain(Project), clbDivision |
| P03 | 팝업 버튼바 | `btnButtonList_UsrButtonList_Click_Detected` | FindData | BodItemPopup: `SSP.SSP0026_GET_BOD_ITEM` / ItembyDivisionPopup: `SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP` | 팝업 spdMain |
| P04 | 팝업 Division 변경 | `clbDivision_SelectedIndexChanged` | NowGroupID 사용. 하위 콤보 갱신 여부 확인 필요 | 확인 필요 | 확인 필요 |
| P05 | 팝업 그리드 더블클릭 | `spdMain_CellDoubleClick` | 선택 행 반환(구체 동작 확인 필요) | 없음 | 호출 화면 |
| X01 | (진입점 미연결) | GetBizTypebyDivision | 호출처 없음 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | — |
| X02 | (진입점 미연결) | BodValidChk_Main / BodValidChk | 호출처 없음 | `SSP.SSP0002_GET_BOD_VALID_CHECK` | — |
| X03 | (진입점 미연결) | ItembyDivisionPopup.GetDivisionbyScmSite | 호출처 없음 | `SCM.SCM0001_GET_SITE_BY_DIVISION` | — |

## 6. 검증·메시지

| 구분 | 내용 | 근거 |
|---|---|---|
| 업로드 확인 | MSG00265 (문구 원문은 **확인 필요**) | btnExcelUpload_Click |
| 편집 잠금 | IsLock 검사, bEdit_Mode_Detail 플래그 | SpdDetail_ClipboardPasted:3466, InsertRow:2049, EditButton:675·714 |
| Frozen/확정일 | SHIP_FROZEN, CONFIRM_DAY에 따른 셀 처리 (구체 동작 **확인 필요**) | Re_Design:4076·4088, ShowCell:4236 |
| 필수 표시 | 헤더 라벨의 `*`. 저장 전에 필수값을 검사하는 코드와 메시지는 **확인 필요** | SCM_MST_SHEET_COLUMNS |
| BOD 유효성 | `SSP.SSP0002_GET_BOD_VALID_CHECK`는 진입점이 미연결이라 현행 검증으로 보지 않습니다 | flow.csv |
| 그 밖의 메시지 코드 | Fact Pack에 없음 | **확인 필요** |

## 7. 권한 (C/R/U/D) 사실

| 항목 | 사실 |
|---|---|
| C/R/U/D 값 | TB_FX_GroupMenuAuth 12행이 있으나 값은 Fact Pack에 없음 → **확인 필요** |
| R (조회) | Division 목록이 MyDivision(TB_FX_USERGROUPAUTHEXTENTION)으로 제한됩니다 |
| 시트 노출 | Cell Biz는 `drPgmAuthId != null`일 때만 생성됩니다(LookupCommon) |
| C/U (행 입력) | InsertRow의 FROM_SITE/TO_SITE 콤보가 NowGroupID와 UserId 기준으로 필터링됩니다 |
| D (삭제) | 삭제 버튼이나 처리 사실이 Fact Pack에 없습니다 → **확인 필요** |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | As-is | To-Be |
|---|---|---|
| 메인 그리드 | FpSpread 3행 헤더, LARGE/SMALL Span, SUM 헤더 | Wijmo FlexGrid 다단 헤더(columnGroups 또는 columnHeaders 행 병합), SUM 컬럼 |
| 시트 | spdMain 시트 2개, spdDetail 시트 2개 | 탭 + FlexGrid. 활성 탭에 따라 조회/저장 API를 고릅니다(R-S1·R-S2·R-S5) |
| 버킷 표시 | SetSpreadColumn (D_/W_/M_ 태그) | FE 컬럼 visible 계산. 서버 재호출 없음 |
| 헤더 색 | SAT 파랑 / SUN 빨강 | FlexGrid formatItem으로 헤더 셀 스타일 지정(inline style 금지, class 사용) |
| 숨김 규칙 | 컬럼명에 `B_` 포함 → 숨김 | FE 컬럼 정의 필터 |
| Request Detail | MergePolicy.None | allowMerging 없음 |
| Excel | spdSub 양식 + EXCEL_DOWN SP / Upload MSG00265 | 공통 Excel 다운로드·업로드 컴포넌트 |
| SP | MSSQL: STRING_SPLIT, #임시테이블, 동적 SQL PIVOT, SCM_ARR_SPL_CNT/VAL | Oracle 19c PKG: 문자열 분해 함수, GTT(세션 시작 시 비우기), 동적 SQL은 EXECUTE IMMEDIATE / SYS_REFCURSOR. MSSQL 키워드가 남지 않게 합니다 |
| 미존재 SP | GET_REQUEST_DETAIL_CELL, SAVE_SHIP_REQ_DETAIL_CELL | 범위 결정 전까지는 구현 **보류(확인 필요)** |
| 미연결 호출 | X01~X03 | 구현 대상에서 빼는 후보입니다(업무 확인 후 확정) |
| 메타 라벨 오타 | Frorm, MEASUR_COLOR, Confrim, MKT_OWMER, MOEL_USER, "DMF0045" | 유지 여부를 결정해야 합니다(확인 필요) |

## 9. 미확정

1. SplitContainer의 SplitterDistance(상/하 비율)와 Panel2 내부 Dock 구성
2. usrLayoutControl1(부모 미기재)의 배치 위치
3. 하단 조회조건(drpPeriod2, txtRequestor, txtItemld2, txtLotID, textNickName2, btnSearch)의 라벨과 SP 파라미터 매핑
4. btnItemId, btnItemID2, btnProject, btnRequestor가 각각 여는 팝업
5. lblItemType(Item Type)에 연결된 컨트롤
6. 각 시트 컬럼의 셀 타입, 편집 가능 여부, 정렬 순서
7. 40 이외 Division에서 Pack Biz가 실제로 어떻게 보이는지
8. MSG00265와 그 밖의 메시지 원문
9. C/R/U/D 권한 값
10. Shipment Request Detail_BACKUP 시트 폐기 여부
