# SSP0022 Shipment Request(Electrode) — 화면설계서

> **작성 근거**: Fact Pack SSP0022(controls.csv · events.csv · flow.csv · grid_*)와 1차 분석서(web_components.md의 props.csv 인용분)만 사용했다.
> props.csv 발췌가 잘려 Fact Pack에서 얻지 못한 값은 **확인 필요**로 적었다.
> 연계 문서: 업무분석서 `business_analysis.md` §5 데이터 흐름. 단위테스트 `unit_test.md`는 §3 컨트롤명을 절차 열에서 그대로 쓴다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0022 |
| 화면명 | Shipment Request(Electrode) |
| As-is 클래스 | `SSP0022_ShipmentRequestElectrode` (Designer 2286줄, cs 4792줄) |
| 공유 팝업 | `SSP0022_BodItemPopup`, `SSP0022_ShipmentRequestPopup` (`GSCM.SSP.Plan.UIL\Popup`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 2행 내용 미수록) |
| 화면 유형 | 상단 조회조건 + 분할(메인 PSI 그리드 / 하단 상세 조건·상세 그리드) |

---

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv)

```
SSP0022_ShipmentRequestElectrode (this)
├─ usrConditionPanel1 [UsrConditionPanel] Dock=Top, Size(1689,75), UsrPanelType=HidePanel
│   └─ usrLayoutControl2 [UsrLayoutControl] Dock=Top, Size(1689,72)  (layoutControlGroup2 Size(1689,78))
│        ├─ 조회조건: clbCompany_ID, clbDivision_ID, cboPlanDate, drpPeriod, cboBucketType,
│        │            clbPlantSite, txtItemId, btnItemId, txtModelId, btnModelId, textNickName,
│        │            clbCellType, lblUOMType, rdButton1, rdButton2, rdButton3, chkSum,
│        │            chkPastPeriod, btnMeasure, chkDelegateModel, chkTeamLeader, chkPartLeader, chkMyModel
│        └─ 버튼:     formDown("Excel Form"), btnExcelUpload("Upload")
└─ splitContainer1 [SplitContainer]  Orientation=확인 필요 · SplitterDistance=확인 필요 · Size=확인 필요
    ├─ Panel1
    │   └─ spdMain [FpSpread] → spdMain_Sheet1 / AddSheet "Shipment Request(Electrode)"
    └─ Panel2
        ├─ usrLayoutControl3 [UsrLayoutControl] (하단 상세 조회조건)
        │    └─ btnRequestor, drpPeriod2, txtModelId2, txtRequestor, textNickName2,
        │       btnSearch, txtItemld2, btnItemID2, txtLotID
        ├─ spdDetail [FpSpread] → spdDetail_Sheet1 / AddSheet "Stock Detail"(탭0), "Shipment Request Detail"(탭1)
        └─ spdSub [FpSpread] → spdSub_Sheet1 / AddSheet "Shipment Request Detail Excel"
```

- **분할 비율(%)은 계산할 수 없다.** splitContainer1의 Orientation·SplitterDistance·Size가 props.csv 발췌에서 잘렸기 때문이다. 원문은 `SSP0022_ShipmentRequestElectrode.Designer.cs`의 splitContainer1 속성 블록에서 확인해야 한다.
  - Orientation=Horizontal(기본)이면 Panel1이 위, Panel2가 아래다.
  - Vertical이면 Panel1이 왼쪽, Panel2가 오른쪽이다.
  - 비율 = SplitterDistance ÷ (해당 축 Size) × 100.
- Panel2 안에서 usrLayoutControl3 · spdDetail · spdSub의 Dock 배치는 **확인 필요**.
- `SpdDetail_SheetTabClick`은 TabIndex 2를 "Shipment Request Detail Excel"로 다룬다. 그런데 AddSheet 기준으로 이 시트는 spdSub에 붙어 있다. 실제 탭 구성을 확인해야 한다.
- `usrMultiLineEditor1`과 `usrLayoutControl1`(UsrMultiLineEditor / UsrLayoutControl)이 본 화면 소속인지 팝업 소속인지는 controls.csv 발췌가 잘려 **확인 필요**다.

### 2-2. 팝업 레이아웃 (parent 체인은 부분 확인)

```
SSP0022_BodItemPopup
├─ usrConditionPanel1 → usrLayoutControl1/2 (소속 확인 필요)
│    └─ clbDivision, clbFromSite, clbToSite, txtItemID(추정), usrMultiLineEditor1(추정)
├─ btnButtonList [UsrButtonList]
└─ spdMain → spdMain_Sheet1 / 하드코딩 시트 "Project"(추정)

SSP0022_ShipmentRequestPopup
├─ usrConditionPanel1 → usrLayoutControl1/2 (소속 확인 필요)
│    └─ clbDivision
├─ btnButtonList [UsrButtonList]
└─ spdMain → spdMain_Sheet1 / 하드코딩 시트 "Shipment Reqeust(Electrode)"(추정)
```

- clbFromSite / clbToSite를 BodItemPopup 소속으로 본 것은 추정이다. 근거는 BodItemPopup InitControls:173·174가 From/To Site 공통코드를 조회한다는 점이다. **확인 필요**.

### 2-3. 영역 정의
| 영역 | 구성 |
|---|---|
| 조회조건(상단) | usrConditionPanel1 / usrLayoutControl2 |
| 버튼(화면 내) | formDown, btnExcelUpload, btnMeasure, btnItemId, btnModelId |
| 버튼(프레임워크) | FindButton, InsertButton, EditButton, SaveButton |
| 그리드(메인) | spdMain (`Shipment Request(Electrode)`) |
| 조회조건(하단) | usrLayoutControl3 + btnSearch |
| 그리드(상세) | spdDetail (`Stock Detail`, `Shipment Request Detail`), spdSub (`Shipment Request Detail Excel`) |
| 팝업 | SSP0022_BodItemPopup (`Project`), SSP0022_ShipmentRequestPopup (`Shipment Reqeust(Electrode)`) |

---

## 3. 컨트롤 명세

- 라벨 = props.csv Text 원문(1차 web_components 인용).
- 필수 = 라벨의 '*' 표기 기준.
- '—' = 해당 없음. '확인 필요' = Fact Pack에서 값을 얻지 못함.

### 3-1. 본 화면 — 상단 (usrConditionPanel1 / usrLayoutControl2)
| # | 컨트롤명 | 타입 | 라벨(Text 원문) | 초기값 / 속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | usrConditionPanel1 | UsrConditionPanel | — | Dock=Top, Size(1689,75), HidePanel | — | — | 조회조건 패널(접기 가능) |
| 2 | usrLayoutControl2 | UsrLayoutControl | — | Dock=Top, Size(1689,72) | — | — | 조회조건 레이아웃(Grid/Flex) |
| 3 | clbCompany_ID | UsrCombo | Company* | Size(156,20). dtCompany.Rows[0].CODE를 쓰는지 확인 필요 | Y | `clbCompanyID_SelectedIndexChanged` | Wijmo ComboBox |
| 4 | clbDivision_ID | UsrCombo | Division* | Size(125,20) | Y | `clbDivision_ID_SelectedIndexChanged` | Wijmo ComboBox |
| 5 | cboPlanDate | UsrCombo | Plan-date* | Size(113,20) | Y | `cboPlanDate_SelectedIndexChanged` | Wijmo ComboBox |
| 6 | drpPeriod | UsrDateRangePicker | Period* | **Enabled=false**, Size(197,20) | Y | — | 날짜범위(읽기 전용) |
| 7 | cboBucketType | UsrCombo | Bucket | Size(70,20). 목록 = `DM.DM0003_GET_BUCKET_TYPE_CODE` | — | `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox |
| 8 | clbPlantSite | UsrCheckedList | Plant | Size(115,21) | — | — | Wijmo MultiSelect |
| 9 | txtItemId | UsrMultiLineEditor | Material | Size(100,21) | — | — | 멀티라인 입력 |
| 10 | btnItemId | UsrButton | 확인 필요 | Size(39,24) | — | `btnItemId_Click` | 아이콘 버튼(팝업) |
| 11 | txtModelId | UsrMultiLineEditor | 확인 필요 | — | — | — | 멀티라인 입력 |
| 12 | btnModelId | UsrButton | 확인 필요 | **Visible=false** | — | — | (숨김, 이관 여부 확인 필요) |
| 13 | textNickName | TextBox | 확인 필요 (lblNickname 항목 있음) | Size(104,20) | — | — | Input |
| 14 | clbCellType | UsrCheckedList | 확인 필요 | Size(86,21) | — | — | Wijmo MultiSelect |
| 15 | lblUOMType | UsrLabel | UOM Type | Size(66,25) | — | — | 라벨 |
| 16 | rdButton1 | UsrRadio | UOM | **Checked=true** | — | `rdButton_Changed` | Radio |
| 17 | rdButton2 | UsrRadio | Cell | — | — | `rdButton_Changed` | Radio |
| 18 | rdButton3 | UsrRadio | Pancake m | — | — | `rdButton_Changed` | Radio |
| 19 | chkSum | UsrCheckBox | Sum | 초기 Checked 확인 필요 | — | `chkSum_CheckedChanged` | CheckBox |
| 20 | chkPastPeriod | UsrCheckBox | Including Past Period | **Visible=false** | — | `chkPastPeriod_CheckedChanged`, `chkPastPeriod_CheckedChanged_1` | CheckBox(숨김) |
| 21 | btnMeasure | UsrButton | 확인 필요 (layoutControlItem10) | Size(39,25) | — | `BtnMeasure_Click` | 버튼 |
| 22 | chkDelegateModel | UsrCheckBox | Delegate Model | — | — | — | CheckBox |
| 23 | chkTeamLeader | UsrCheckBox | Team Leader | — | — | — | CheckBox |
| 24 | chkPartLeader | UsrCheckBox | Part Leader | — | — | — | CheckBox |
| 25 | chkMyModel | UsrCheckBox | My Model | **Visible=false** | — | — | CheckBox(숨김) |
| 26 | formDown | UsrButton | Excel Form | Size(90,25) | — | `btnExcelFormDownload_Click` | 버튼 |
| 27 | btnExcelUpload | UsrButton | Upload | Size(70,25) | — | `btnExcelUpload_Click` | 버튼(파일 업로드) |

### 3-2. 본 화면 — 그리드·하단 (splitContainer1)
| # | 컨트롤명 | 타입 | 라벨 | 초기값 / 속성 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 28 | spdMain | FpSpread | — | Panel1. 시트 `Shipment Request(Electrode)`(헤더 3단) | — | `SpdMain_TopChange`, `SpdMain_CellClick`, `spdMain_CellClick_1`, `SpdMain_CellDoubleClick`, `SpdMain_Change` | Wijmo FlexGrid |
| 29 | spdMain_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | (FlexGrid 단일 뷰) |
| 30 | spdDetail | FpSpread | — | Panel2. 시트 `Stock Detail`, `Shipment Request Detail` | — | `SpdDetail_TopChange`, `SpdDetail_ActiveSheetChanged`(2회 등록), `SpdDetail_SheetTabClick`, `SpdDetail_CellClick`, `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_ClipboardPasted`, `SpdDetail_EditChange` | 탭 + Wijmo FlexGrid |
| 31 | spdDetail_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | — |
| 32 | spdSub | FpSpread | — | Panel2. 시트 `Shipment Request Detail Excel` | — | — | Wijmo FlexGrid(양식) |
| 33 | spdSub_Sheet1 | SheetView | — | Designer 기본 시트 | — | — | — |
| 34 | usrLayoutControl3 | UsrLayoutControl | — | Panel2 하단 조회조건 | — | — | 상세 조회조건 레이아웃 |
| 35 | drpPeriod2 | UsrDateRangePicker | 확인 필요 | — | 확인 필요 | — | 날짜범위 |
| 36 | txtModelId2 | UsrMultiLineEditor | 확인 필요 | — | — | — | 멀티라인 입력 |
| 37 | txtRequestor | UsrMultiLineEditor | 확인 필요 | — | — | — | 멀티라인 입력 |
| 38 | btnRequestor | UsrButton | 확인 필요 | — | — | `BtnRequestor_Click` | 아이콘 버튼(사용자 팝업) |
| 39 | textNickName2 | TextBox | 확인 필요 | — | — | — | Input |
| 40 | txtItemld2 | UsrMultiLineEditor | 확인 필요 (컨트롤명 'ld' 원문 그대로) | — | — | — | 멀티라인 입력 |
| 41 | btnItemID2 | UsrButton | 확인 필요 | — | — | `BtnItemID2_Click` | 아이콘 버튼(팝업) |
| 42 | txtLotID | UsrMultiLineEditor | 확인 필요 | — | — | — | 멀티라인 입력 |
| 43 | btnSearch | SimpleButton | 확인 필요 | — | — | `BtnSearch_Click` | 상세 조회 버튼 |

### 3-3. 팝업 / 소속 확인 필요 컨트롤
| # | 컨트롤명 | 타입 | 소속 | 라벨 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|
| 44 | usrMultiLineEditor1 | UsrMultiLineEditor | 확인 필요 | 확인 필요 | — | 멀티라인 입력 |
| 45 | usrLayoutControl1 | UsrLayoutControl | 확인 필요 (팝업 레이아웃 추정) | — | — | 팝업 조회조건 레이아웃 |
| 46 | txtItemID | UsrMultiLineEditor | 팝업(추정, BodItemPopup) | 확인 필요 | — | 멀티라인 입력 |
| 47 | clbDivision | UsrCheckedList | BodItemPopup · ShipmentRequestPopup (각 1개) | 확인 필요 | `clbDivision_SelectedIndexChanged` | Wijmo MultiSelect |
| 48 | clbFromSite | UsrCheckedList | 팝업(추정, BodItemPopup) | 확인 필요 | — | Wijmo MultiSelect |
| 49 | clbToSite | UsrCheckedList | 팝업(추정, BodItemPopup) | 확인 필요 | — | Wijmo MultiSelect |
| 50 | btnButtonList | UsrButtonList | BodItemPopup · ShipmentRequestPopup | 버튼 구성 확인 필요 | `btnButtonList_UsrButtonList_Click_Detected` | 팝업 버튼 바 |

- 팝업 spdMain의 이벤트: BodItemPopup `spdMain_CellDoubleClick`. ShipmentRequestPopup `SpdMain_CellClick`, `SpdMain_EditChange`, `SpdMain_ComboSelChange`, `SpdMain_TextChanged`(Form_Load:160~164에서 연결).
- 두 팝업의 Load: `Form_Load`(BodItemPopup .ctor:137 / ShipmentRequestPopup .ctor:143).

---

## 4. 그리드 명세

- 출처 표기: META = SCM_MST_SHEET_COLUMNS / SCM_MST_SHEET_MEASURE, DB루프 = 3SPAN 결과로 만든 컬럼, HARDCODED = Add*Column.
- division별 표시: 14종 모두 같다(업무분석서 §6-1).
- 편집 가능 여부: 메타 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE) 값을 Fact Pack에서 얻지 못한 컬럼은 **확인 필요**다.

### 4-1. `Shipment Request(Electrode)` (spdMain, META+코드연결, 헤더 3단, 최종 표시 22 (?9))
| 컬럼 | 헤더 | 타입 | 출처 | division별 | 편집 | 비고 |
|---|---|---|---|---|---|---|
| DIVISION_ID | Div | 확인 필요 | META | 14종 동일 | 확인 필요 | |
| SCM_SITE_ID | SCM_SITE_ID | 확인 필요 | META | 동일 | 확인 필요 | |
| PLANT_ID | Plant | 확인 필요 | META | 동일 | 확인 필요 | |
| FROM_SITE / TO_SITE | From Site / To Site | 확인 필요 | META | 동일 | 확인 필요 | |
| MODEL_ID / ITEM_ID / NICK_NAME | Model / Material / Nick Name | 확인 필요 | META | 동일 | 확인 필요 | |
| CELL_TYPE / ELECTRODE_TYPE | Cell Type / Elec Type | 확인 필요 | META | 동일 | 확인 필요 | |
| BOD_ID / BOD_LT / OPERATION_LT | Bod ID / BOD L/T / Oper. L/T | 확인 필요 | META | 동일 | 확인 필요 | |
| INCOTERMS / TRANSPORT_MODE | Incoterms / Trans Mode | 확인 필요 | META | 동일 | 확인 필요 | |
| LAST_UPDATED_BY | Requestor | 확인 필요 | META | 동일 | 확인 필요 | |
| PSI_NAME / MEASURE_NAME | PSI / Measure | 확인 필요 | META (+MEASURE 10행) | 동일 | 확인 필요 | |
| TEMPCOLUMN | TEMPCOLUMN | 확인 필요 | META | 동일 | 확인 필요 | |
| TOT_BOH_QTY / JR_BOH_QTY / PC_BOH_QTY | BOH / J/R / Pancake | 확인 필요 | META + 코드 Visible | 동일 | 확인 필요 | rdButton1일 때 표시 |
| TOT/JR/PC_BOH_QTY_CELL | BOH / J/R / Pancake | 확인 필요 | META + 코드 Visible | 동일 | 확인 필요 | rdButton2일 때 표시 |
| TOT/JR/PC_BOH_QTY_PCM | BOH / J/R / Pancake | 확인 필요 | META + 코드 Visible | 동일 | 확인 필요 | rdButton3일 때 표시 |
| BACK_COLOR, CONFIRM_DAY("Confrim Day"), MEASURE, NPC_ITEM_ID("Noteched Pancake"), ORIGIN_DIVISION_ID, TOT_BOH_JR | (원문 오탈자 유지) | — | META 숨김 | 동일 | — | 숨김 |
| (동적) 날짜 컬럼 | COLUMN_LABEL_NAME. 3단 = LARGE / SMALL_CLASS_LABEL_NAME / "SUM" | `B_` 포함 = Text 숨김(폭 0), 그 외 = Num(폭 100, 우측, 소수 3자리, 천단위) | DB루프 (`SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`) | 동일 | 확인 필요 | Tag X_/Y_/Z_ × D_/W_/M_로 표시 토글. SAT=Blue, SUN=Red |

### 4-2. `Stock Detail` (spdDetail 탭0, META+코드연결, 헤더 3단, 최종 표시 31 (?9))
| 컬럼 | 헤더 | 출처 | division별 | 편집 |
|---|---|---|---|---|
| DIVISION_ID | Div | META | 동일 | 확인 필요 (조회 결과 시트로 보임 — 추정) |
| PLANT_ID | Plant | META | 동일 | 〃 |
| MODEL_ID / ITEM_ID / NICK_NAME | Model / Material / Nick Name | META | 동일 | 〃 |
| CELL_TYPE / VERSION | Cell Type / Version | META | 동일 | 〃 |
| LOT_ID / PALLET_ID / LANE | Lot ID / Pallet ID / Lane | META | 동일 | 〃 |
| OPERATION_ID / STORAGE_ID | Operation / Storage | META | 동일 | 〃 |
| TOTAL_QTY_UOM / TOTAL_QTY_PCM | UOM / Pancake M | META | 동일 | 〃 |
| GMES_QTY_UOM / GMES_QTY_PCM | UOM / Pancake M | META | 동일 | 〃 |
| IWMS_QTY_UOM / IWMS_QTY_PCM | UOM / Pancake M | META | 동일 | 〃 |
| OWMS_QTY_UOM / OWMS_QTY_PCM | UOM / Pancake M | META | 동일 | 〃 |
| MES_HOLD_YN / QMS_HOLD_YN / IWMS_HOLD_YN / OWMS_HOLD_YN | MES / QMS / iWMS / oWMS Hold YN | META | 동일 | 〃 |
| AVAILABLE_YN / CHANGE_STATUS | Available Stock YN / Change Status | META | 동일 | 〃 |
| EXPIRATION_DATE / PACKAGE_TYPE_CODE | Expiration Date / Package Type (oWMS) | META | 동일 | 〃 |
| FROM_SITE | Site | META 숨김 | 동일 | — |
| BOH 9컬럼(CODE_ONLY_CHANGE ?) | — | 코드(rdButton_Changed) | 동일 | 이 시트에 실제로 적용되는지 **확인 필요** |

### 4-3. `Shipment Request Detail` (spdDetail 탭1, META+코드연결, 헤더 1단, 최종 표시 19 (?9))
| 컬럼 | 헤더 | 출처 | 편집 | 비고 |
|---|---|---|---|---|
| DIVISION_ID / ORIGIN_DIVISION_ID | Div / Org Div | META | 확인 필요 | |
| FROM_SITE / TO_SITE | From Site* / To Site* | META + 셀 콤보(InsertRow:1481~1482) | 입력(콤보, 추정) | PlantByElectordeShipFromSite/ToSite |
| MODEL_ID / ITEM_ID / NICK_NAME | Model* / Material* / Nick Name | META | 확인 필요 | |
| SHIPMENT_DATE | Shipment ETA* | META | 확인 필요 | |
| SHIPMENT_QTY | Qty* | META | 확인 필요 | |
| INCOTERMS / TRANSPORT_MODE | Incoterms* / Trans Mode* | META | 확인 필요 | |
| BOD_ID / CONFIRM_DAY | (메타 라벨) | META | 확인 필요 | |
| REQUEST_DATE / REQUESTOR / EDIT_FLAG | Request Date / Requestor / EDIT_FLAG | META | 확인 필요 | |
| SCM_SITE_ID, PLANT_ID, LT, ETD, ETA, ROUTE_ID, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, ELECTRODE_YN, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID | — | META 숨김 | — | ROUTE_ID~TO_CITY 8종과 BOD_ID·INCOTERMS는 `SpdDetail_ClipboardPasted`가 채운다 |

### 4-4. `Shipment Request Detail Excel` (spdSub, META+코드연결, 헤더 1단, 최종 표시 12 (?9))
| 컬럼 | 헤더 | 출처 | 편집 |
|---|---|---|---|
| COMPANY_ID | Company* | META | 양식 컬럼 |
| DIVISION_ID | Div* | META | 〃 |
| FROM_SITE / TO_SITE | FromSite* / ToSite* | META | 〃 |
| ITEM_ID | Material* | META | 〃 |
| YYYYMMDD | yyyyMMdd* | META | 〃 |
| QTY | Qty* | META | 〃 |
| INCOTERMS / TRANSPORT_MODE | Incoterms* / Trans Mode* | META | 〃 |

### 4-5. `Project` (팝업 추정 — BodItemPopup, HARDCODED InitSpread:208~215, 8컬럼)
| 컬럼 | 헤더 | 타입 | 출처 | 편집 |
|---|---|---|---|---|
| DIVISION_ID | Division | Text | HARDCODED | 확인 필요 (`spdMain_CellDoubleClick`로 선택하는 것으로 보임 — 추정) |
| DIVISION_NAME | Division | Text | HARDCODED | 〃 |
| MODEL_ID | Model | Text | HARDCODED | 〃 |
| ITEM_ID | Material | Text | HARDCODED | 〃 |
| INCOTERMS | Incoterms | Text | HARDCODED | 〃 |
| TRANSPORT_MODE | Transport Mode | Text | HARDCODED | 〃 |
| BOD_ID | BOD ID | Text | HARDCODED | 〃 |
| CONFIRM_DAY | Confirm Day | Text | HARDCODED | 〃 |

### 4-6. `Shipment Reqeust(Electrode)` (팝업 추정 — ShipmentRequestPopup, HARDCODED InitSpread:257~285, 26컬럼, 시트명 오탈자 원문 유지)
| 컬럼 | 헤더(원문) | 타입 | 편집 |
|---|---|---|---|
| DIVISION_ID | Div* | Combo | 입력(ComboSelChange 대상) |
| SCM_SITE_ID | SCM Site* | Combo | 입력 |
| PLANT_ID | Plant | Combo | 입력 |
| FROM_SITE / TO_SITE | From Site* / To Site* | Combo | 입력 (PlantByElectorde* 콤보, 943·945) |
| MODEL_ID / ITEM_ID / NICK_NAME | Model* / Material* / Nick Name | Text | 입력(EditChange·TextChanged 대상, 추정) |
| SHIPMENT_DATE | Shipment Date* | Date | 입력 |
| SHIPMENT_QTY | "Qty* " | Num | 입력 |
| INCOTERMS / TRANSPORT_MODE | Incoterms* / "Trans Mode* " | Combo | 입력 |
| LT | L/T(Day) | Num | 확인 필요 |
| ETD / ETA | ETD / ETA | Date | 확인 필요 |
| ROUTE_ID, BOD_ID, CONFIRM_DAY, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, ELECTRODE_YN, ORIGIN_FROM_DIVISION_ID | 필드명과 같음 | Text | 확인 필요 (표시 여부 포함) |

---

## 5. 액션 명세

엔드포인트 표기는 업무분석서 §5와 같다.

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A01 | 화면 Load | `Form_Load` | InitControls > GetBucketType / CreateSpread > InitSpread > GetSpdTitle | `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | cboBucketType 목록, spdMain 날짜 컬럼 |
| A02 | cboPlanDate 변경 | `cboPlanDate_SelectedIndexChanged` | CODE/FROM_DATE/TO_DATE 읽음 > GetSpdTitle | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | 기간·날짜 컬럼 재구성 |
| A03 | clbCompany_ID 변경 | `clbCompanyID_SelectedIndexChanged` | cboPlanDate 이벤트 해제(3669) → PlantEE 조회 → 재연결(3673) > InitSpread | `biz:CommonData.CommonDataList`[PlantEE], `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | clbPlantSite 목록(추정), 그리드 재구성 |
| A04 | 조회(FindButton) | FindButton(프레임워크) | FindData_Main > InitSpread | `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | spdMain `Shipment Request(Electrode)` |
| A05 | UOM 라디오 / Sum / Bucket / Past Period | `rdButton_Changed`, `chkSum_CheckedChanged`, `cboBucketType_SelectedIndexChanged`, `chkPastPeriod_CheckedChanged`, `chkPastPeriod_CheckedChanged_1` | 컬럼 Visible 토글(SetSpreadColumn / rdButton_Changed:1823~1858) | 없음 | 표시 컬럼 변경(재조회 없음). Bucket·PastPeriod 핸들러 본문은 확인 필요 |
| A06 | clbDivision_ID 변경 | `clbDivision_ID_SelectedIndexChanged` | DIVISION_ID 읽음 | 없음(Fact Pack 기준) | 확인 필요 |
| A07 | btnMeasure | `BtnMeasure_Click` | InitSpread > GetSpdTitle | `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | 그리드 재구성 |
| A08 | spdMain 더블클릭 | `SpdMain_CellDoubleClick` | GetCheckedListValue(1405~1407) > FindData_Main | `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | spdMain 재조회 |
| A09 | spdMain 클릭·변경·스크롤 | `SpdMain_CellClick`, `spdMain_CellClick_1`, `SpdMain_Change`, `SpdMain_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| A10 | 행추가(InsertButton) | InsertButton(프레임워크) | InsertRow. IsLock==false이고 활성 시트 "Shipment Request Detail"이면 셀 콤보 설정 | `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite / PlantByElectordeShipToSite] | `Shipment Request Detail` 새 행 |
| A11 | btnSearch | `BtnSearch_Click` | FindData_Request_Detail > InitSpread / FindData_Detail | `SSP.SSP0022_GET_REQUEST_DETAIL`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0022_GET_STOCK_DETAIL` | spdDetail `Shipment Request Detail`, `Stock Detail` |
| A12 | spdDetail 콤보 변경 / 더블클릭 / 붙여넣기 | `SpdDetail_ComboSelChange`, `SpdDetail_CellDoubleClick`, `SpdDetail_ClipboardPasted` | FindData_BOD. 붙여넣기는 9개 필드 자동 채움 | `SSP.SSP0022_GET_ITEM_POPUP` | `Shipment Request Detail` 셀 값 |
| A12-2 | spdDetail 기타 | `SpdDetail_TopChange`, `SpdDetail_ActiveSheetChanged`, `SpdDetail_SheetTabClick`, `SpdDetail_CellClick`, `SpdDetail_EditChange` | 탭 전환(TabIndex 2 → Shipment Request Detail Excel), 그 외 확인 필요 | 없음 | 확인 필요 |
| A13 | 수정(EditButton) | EditButton(프레임워크) | GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 허용 여부(확인 필요) |
| A14 | 저장(SaveButton) | SaveButton(프레임워크) | SaveData_Detail → FindData_Request_Detail / SaveData → FindData_Main | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST`, `SSP.SSP0022_GET_REQUEST_DETAIL`, `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` | 저장 후 재조회 |
| A15 | formDown "Excel Form" | `btnExcelFormDownload_Click` | FindData_Request_Detail_DownLoad | `SSP.SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN` | `Shipment Request Detail Excel` 양식 |
| A16 | btnExcelUpload "Upload" | `btnExcelUpload_Click` | 업로드 처리(확인 필요) → FindData_Main / FindData_Request_Detail | `SSP.SSP0022_GET_SHIPMENT_PSI`, `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0022_GET_REQUEST_DETAIL` | 재조회 |
| A17 | BodItemPopup Load / 조회 | `Form_Load`, `btnButtonList_UsrButtonList_Click_Detected`, FindButton | InitControls(GetDivision, GetDivisionbyScmSite) / FindData | `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite/ToSite], `SCM.SCM0001_GET_DIVISION`, `SCM.SCM0001_GET_SITE_BY_DIVISION`, `SSP.SSP0022_GET_ITEM_POPUP` | 팝업 `Project` 그리드(추정) |
| A18 | BodItemPopup Division 변경 / 더블클릭 | `clbDivision_SelectedIndexChanged`, `spdMain_CellDoubleClick` | 확인 필요 | `SSP.SSP0022_GET_ITEM_POPUP`(BodItemPopup에서 연결되는지 확인 필요) | 선택값 반환(확인 필요) |
| A19 | ShipmentRequestPopup Load / Division 변경 | `Form_Load`, `clbDivision_SelectedIndexChanged` | GetDayRange / 공통코드 4종 + FindData | `SCP.GET_DATE_RANGE_1MONTH`, `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite·ToSite·Incoterms·TransportMode], `SSP.SSP0022_GET_ITEM_POPUP` | 팝업 기간·콤보·그리드 |
| A20 | ShipmentRequestPopup 셀 이벤트 | `SpdMain_ComboSelChange`, `SpdMain_EditChange`, `SpdMain_TextChanged`, `SpdMain_CellClick` | ComboSelChange: From/To 콤보 + FindData | `biz:CommonData.CommonDataList`[PlantByElectordeShipFromSite/ToSite], `SSP.SSP0022_GET_ITEM_POPUP` | `Shipment Reqeust(Electrode)` 셀 |
| A21 | ShipmentRequestPopup 저장 | `btnButtonList_UsrButtonList_Click_Detected`, SaveButton | SaveData:539 | `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` | 저장 |
| A22 | (진입점 미연결) 유효성 검사 | BodItemValidChk_main / BodItemValidChk / BodValidChk | 실행 여부 확인 필요 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK`, `SSP.SSP0002_GET_BOD_VALID_CHECK` | 확인 필요 |
| A23 | 팝업 열기 | `btnItemId_Click`, `BtnItemID2_Click`, `BtnRequestor_Click` | 어떤 팝업을 여는지 확인 필요 | 확인 필요 | txtItemId / txtItemld2 / txtRequestor 값 반영(추정) |

---

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| 필수 표시 | Company*, Division*, Plan-date*, Period* / 상세·Excel·팝업 시트 '*' 컬럼 | 검증 코드와 메시지 문구는 Fact Pack에 없음 → **확인 필요** |
| 행추가 조건 | `siDetail.IsLock(...) == false`이고 활성 시트 "Shipment Request Detail" | 조건 불충족 시 메시지 **확인 필요** |
| 수정 권한 | `SSP.SSP0002_GET_USER_INFO_LIST` 결과로 판정 | 실패 메시지 **확인 필요** |
| BOD 유효성 | `SSP.SSP0022_GET_BOD_ITEM_VALID_CHECK` / `SSP.SSP0002_GET_BOD_VALID_CHECK` 메서드 있음(진입점 미연결) | 실행 여부 **확인 필요** |
| 메시지 코드 | Fact Pack에 MessageBox / 메시지 ID 추출 없음 | **확인 필요** |

---

## 7. 권한(C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| R (조회) | FindButton 오버라이드. 상세는 btnSearch |
| C (생성) | InsertButton 오버라이드(InsertRow) |
| U (수정) | EditButton 오버라이드 → `SSP.SSP0002_GET_USER_INFO_LIST` 사용자 검사 |
| 저장 | SaveButton 오버라이드 → `SSP.SSP0022_SAVE_SHIPMENT_REQUEST` |
| D (삭제) | DeleteButton 오버라이드가 Fact Pack에 없음. 삭제가 SAVE SP 안의 플래그로 처리되는지 **확인 필요** |
| 그룹 메타 | TB_FX_GroupMenuAuth 13행. 그룹별 값 **확인 필요** |
| 사용자 필터 | SetChangeControl이 GROUP_ID / USER_ID를 NowGroupID로 필터 |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)

1. **Spread 다중 시트 → 화면 구성**
   - spdMain은 FlexGrid 1개로 바꾼다.
   - spdDetail(시트 2개)은 탭 + FlexGrid 2개로 바꾼다.
   - spdSub(양식)는 FlexGrid 또는 Excel 내보내기 전용으로 바꾼다.
   - `SpdDetail_SheetTabClick`의 탭 인덱스와 spdSub 시트의 대응을 확정한 뒤 구성한다.
2. **3단 헤더 + 동적 날짜 컬럼**
   - FlexGrid columnHeaders 다단 행 + allowMerging으로 LARGE / SMALL / "SUM"을 재현한다.
   - 컬럼 정의는 `SSP.SSP0022_GET_SHEET_CALENDAR_3SPAN` 결과로 런타임에 만든다.
   - `B_` 컬럼은 visible=false로 둔다.
   - SAT/SUN 색은 formatItem에서 칠한다.
3. **표시 토글 = 클라이언트 처리**
   - UOM 라디오, Bucket, Sum, Past Period는 As-is에서 재조회 없이 Visible만 바꾼다. To-Be도 컬럼 visible 토글로 구현한다.
   - DAILY일 때 W_ 컬럼의 최종 표시값을 먼저 확정해야 한다(업무분석서 §4-3).
4. **콤보 셀**: FROM_SITE·TO_SITE·INCOTERMS·TRANSPORT_MODE·DIVISION_ID는 DataMap으로 만든다. 소스는 `biz:CommonData.CommonDataList` code별 공통코드 API다.
5. **붙여넣기 BOD 자동 채움**: FlexGrid pasted / cellEditEnded 이벤트에서 BOD 조회 API(`SSP.SSP0022_GET_ITEM_POPUP` 대응)를 호출한다.
6. **Oracle 전환 포인트**
   - `SSP0022_GET_SHIPMENT_PSI`의 #임시테이블 다수, `SSP0022_SAVE_SHIPMENT_REQUEST`의 #TBLDYNAMIC_*는 GTT 또는 WITH절로 바꾼다.
   - STRING_SPLIT / UF_FX_STRING_SPLIT / SCM_ARR_SPL_*은 Oracle 분해 함수로 바꾼다.
   - 동적 SQL(DYNAMIC@)은 EXECUTE IMMEDIATE / SYS_REFCURSOR로 바꾼다.
   - `SCM0001_GET_SITE_BY_DIVISION`의 REF:VALUE / NODES(XML)는 XMLTABLE로 바꾼다.
   - SP를 재작성할 때 GTT를 시작 시 비우고 세션 시나리오로 대조해야 한다.
7. **팝업**: 두 팝업은 모달 컴포넌트로 만든다. 본 화면에서 여는 지점과 반환값은 §9에서 확정한 뒤 설계한다.
8. **숨김 컨트롤**: chkPastPeriod, chkMyModel, btnModelId(Visible=false)는 이관 여부를 따로 판정해야 한다.

---

## 9. 미확정

1. splitContainer1의 Orientation·SplitterDistance·Size, 그리고 분할 비율(%).
2. 라벨이 확인되지 않은 컨트롤: btnItemId, txtModelId, btnModelId, textNickName, clbCellType, btnMeasure, usrLayoutControl3 하위 전부, 팝업 컨트롤.
3. usrMultiLineEditor1, usrLayoutControl1, txtItemID, clbFromSite, clbToSite가 어느 파일·클래스 소속인지.
4. 하드코딩 시트 `Project` / `Shipment Reqeust(Electrode)`가 실제로 어느 팝업에 있는지.
5. 메타 컬럼 셀 타입·편집 가능 여부. SCM_MST_SHEET_COLUMNS 103행 원문으로 확인한다.
6. 엔드포인트가 없는 핸들러의 본문 동작(§5 A05·A06·A09·A12-2·A18·A23).
7. 주석 처리된 호출은 설계에 넣지 않았다: main 4003 SSP.SSP0002_GET_BOD_VALID_CHECK, BodItemPopup 396 DM.Get_Division, ShipmentRequestPopup 1226 SCP.SCM0001_GET_SCP_DAY_PERIOD.
