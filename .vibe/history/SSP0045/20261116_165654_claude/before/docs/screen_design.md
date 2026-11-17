# SSP0045 Shipment Request — 화면설계서

> 근거: Fact Pack(SSP0045)의 controls.csv, props.csv, events.csv, grid_effective.csv, grid_code.csv, flow.csv. 없는 사실은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0045 |
| 화면명 | `Shipment Request` (props `this.Text`, Designer.cs:631) |
| AS-IS 클래스 | `SSP0045_ShipmentRequest` (`06.UIL\GSCM.SSP.Plan.UIL`) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행 존재, 값 미첨부) |
| 시트 | `Shipment Request` 1개 (`SpdSheet.shtMain`, CreateSpread:286) |
| Grid 구성 방식 | HYBRID: META(프레임워크) + DB 루프(코드) (+코드 표시/라벨 변경) |
| 프레임워크 버튼 | FindButton(조회), SaveButton(저장), EditButton(449줄, 동작 **확인 필요**) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (controls.csv parent 체인 + props.csv Dock/Size)
- props.csv에 SplitContainer(Orientation·SplitterDistance) 항목이 **없다**. 분할은 Dock(Top/Fill)으로만 구성된다.
- 세로 합계: 75(Top) + 574(Fill) = 649. 비율은 상단 11.6%, 하단 88.4%이다(Size 기준 계산값).

```
this (Form, Text="Shipment Request")
├─ usrConditionPanel1   [UsrConditionPanel] Dock=Top  Size=1129×75  PanelType=HidePanel   ── 상단 11.6%
│   └─ usrLayoutControl2 [UsrLayoutControl] Dock=Fill Size=1129×75
│        (layoutControlGroup2 1129×75 — 레이아웃 아이템이 감싸는 컨트롤)
│        ├─ lblCombo           252×29  → cboBizType     "Operation Group*"
│        ├─ lblCombo1          217×29  → cboDivision    "Division*"
│        ├─ lblItemId          141×29  → txtItem_Id     "Model"
│        ├─ layoutControlItem4  43×29  → btnItem_Id     (텍스트 없음)
│        ├─ layoutControlItem3 212×29  → clbFromSite    "From Site"
│        ├─ emptySpaceItem1    244×29  (여백)
│        ├─ lblBucket          217×26  → cboBucketType  "Bucket"
│        ├─ layoutControlItem6 252×26  → drpPeriod      "Period*"
│        ├─ layoutControlItem9 184×26  → chkSum         "Sum"
│        └─ emptySpaceItem3    456×26  (여백)
└─ spdMain              [FpSpread] Dock=Fill Size=1129×574                                 ── 하단 88.4%
     └─ spdMain_Sheet1  [SheetView] → 실행 시 AddSheet로 "Shipment Request" 시트 생성

(parent 없음) usrButton1 [UsrButton] 75×23 — 배치 위치·용도 확인 필요
(parent 없음) imageList1 [ImageList]
```

- 레이아웃 아이템을 높이로 묶으면 두 줄로 나뉜다. 29px 줄은 252+217+141+43+212+244 = 1109, 26px 줄은 217+252+184+456 = 1109이다(Size 합 계산). 각 줄 안의 좌우 순서는 Location이 추출되지 않아 **확인 필요**이다. 위 트리 순서는 controls.csv 선언 순서를 따랐다.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────────────────────────────────────── 1129 ─┐
│ [조회조건 usrConditionPanel1 · HidePanel · 75px]                     │
│  Operation Group* [cboBizType▼]  Division* [cboDivision▼]             │
│  Model [txtItem_Id][btnItem_Id]  From Site [clbFromSite☑▼]  (여백)    │
│  Bucket [cboBucketType▼]  Period* [drpPeriod ~ ](비활성)  ☐ Sum (여백)│
├───────────────────────────────────────────────────────────────────────┤
│ [Grid spdMain · 시트 "Shipment Request" · 574px]                       │
│ 헤더 3행: │메타 컬럼(12 표시)│ 대분류 │ … │                            │
│           │                  │ SUM │ 소분류 │ … │                       │
│           │                  │     │ SUM │ 일/주/월 컬럼 … │           │
└───────────────────────────────────────────────────────────────────────┘
```

- 버튼 영역: 화면 자체 버튼 컨트롤은 `btnItem_Id`, `usrButton1`이다. 조회와 저장은 프레임워크 버튼(FindButton/SaveButton)이 담당한다.
- 팝업: `btnItem_Id` 클릭 시 Model 선택 팝업으로 보인다(1198줄 `txtItem_Id.Text = sItemId`). 팝업의 실체는 **확인 필요**.

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | - | PanelType=HidePanel, Dock=Top | - | - | 접기 가능한 조회조건 패널 |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (Text 속성 원문, 표시 라벨 아님) | Dock=Fill | - | - | 조회조건 레이아웃(그리드형 폼) |
| `cboBizType` | UsrCombo | `Operation Group*` (lblCombo) | **확인 필요** | Y | `CboBizType_SelectedIndexChanged` | Wijmo ComboBox |
| `cboDivision` | UsrCombo | `Division*` (lblCombo1) | **확인 필요** | Y | `CboDivision_SelectedIndexChanged` | Wijmo ComboBox |
| `cboBucketType` | UsrCombo | `Bucket` (lblBucket) | **확인 필요**(목록 = `DM.DM0003_GET_BUCKET_TYPE_CODE`) | N | `cboBucketType_SelectedIndexChanged` | Wijmo ComboBox (값 DAILY/WEEKLY/MONTHLY) |
| `txtItem_Id` | UsrMultiLineEditor | `Model` (lblItemId) | **확인 필요** | N | (`BtnItem_Id_Click`이 값 설정) | 다건 입력 텍스트 |
| `btnItem_Id` | UsrButton | (Text 없음) | - | - | `BtnItem_Id_Click` | 검색 팝업 버튼 |
| `drpPeriod` | UsrDateRangePicker | `Period*` (layoutControlItem6) | Enabled=false (CreateSpread:291), 값 = `SCP.SCM0001_GET_SCP_DAY_PERIOD` 관련(대입 **확인 필요**) | Y | - | DateRange(읽기 전용) |
| `clbFromSite` | UsrCheckedList | `From Site` (layoutControlItem3) | **확인 필요** | N | - (`SpdMain_CellClick`·FindData_Main에서 GetCheckedListValue로 읽음) | Wijmo MultiSelect |
| `chkSum` | UsrCheckBox | `Sum` | **확인 필요** | N | `chkSum_CheckedChanged` | CheckBox |
| `usrButton1` | UsrButton | 미추출 | - | - | 없음(배선 미추출) | **확인 필요** |
| `spdMain` | FpSpread | - | Dock=Fill | - | `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `SpdMain_CellClick`, `SpdMain_ComboSelChange` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | 시트 `Shipment Request` | 헤더 3행 | - | (spdMain 이벤트 공유) | FlexGrid 데이터 뷰 |
| (화면) | Form | `Shipment Request` | - | - | `Form_Load` | 페이지 |

## 4. 그리드 명세 — 시트 `Shipment Request`

연결 규칙: META+코드연결. 헤더 3행(`SetSheetHeaderColumn(siMain, 3)`, InitSpread_2:313). 마스터-디테일 연결은 없다.

### 4-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS 18행, grid_effective.csv 순서)

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시(14개 동일) | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | BOD_FROM_YYYYMMDD | BOD_FROM_YYYYMMDD | **확인 필요** | META | 숨김 | **확인 필요** |
| 2 | BOD_ID | BOD_ID | **확인 필요** | META | 숨김 | **확인 필요** |
| 3 | BOD_TO_YYYYMMDD | BOD_TO_YYYYMMDD | **확인 필요** | META | 숨김 | **확인 필요** |
| 4 | DIVISION_ID | Division* | **확인 필요** | META | 기본(표시) | **확인 필요** |
| 5 | FCST_TYPE | FCST Type | **확인 필요** | META | 기본 | **확인 필요** |
| 6 | FROM_SITE | From Site* | **확인 필요** | META | 기본 | **확인 필요** |
| 7 | FROZEN_YYYYMMDD | FROZEN_YYYYMMDD | **확인 필요** | META | 숨김 | **확인 필요** |
| 8 | INCOTERMS | Incoterms* | **확인 필요** | META | 기본 | **확인 필요** |
| 9 | ITEM_ID | Model* | 행 추가 시 콤보(SetCellTypeCombo 772·803) | META(+코드 셀타입) | 기본 | 시트가 잠겨 있지 않을 때 콤보 설정 |
| 10 | LAST_UPDATED_BY | Requestor | **확인 필요** | META | 기본 | **확인 필요** |
| 11 | LT_DAY | L/T(Day) | **확인 필요** | META | 기본 | **확인 필요** |
| 12 | MEASURE | Measure* | **확인 필요** | META | 숨김 | **확인 필요** |
| 13 | MEASURE_COLOR | MEASURE_COLOR | **확인 필요** | META | 숨김 | **확인 필요** |
| 14 | MEASURE_LABEL | Measure | **확인 필요** | META | 기본 | **확인 필요** |
| 15 | NICK_NAME | Nick Name | **확인 필요** | META | 기본 | **확인 필요** |
| 16 | PROJECT_CODE | Project Code | **확인 필요** | META | 기본 | **확인 필요** |
| 17 | TO_SITE | To Site* | **확인 필요** | META | 기본 | **확인 필요** |
| 18 | TR_MODE | Trans Mode* | **확인 필요** | META | 기본 | **확인 필요** |

- 표시 12, 숨김 6이다. 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 같다.
- 실제 표시 순서(SORT_ORDER), 셀 타입, 폭, 정렬, 편집 여부(CELL_CONTROL_OBJECT_TYPE_CODE 등 메타 값)는 행 값이 첨부되지 않아 **확인 필요**.
- 측정값 메타 `SCM_MST_SHEET_MEASURE`는 9행이며 division 간 차이가 없다. 측정값 이름은 **확인 필요**.

### 4-2. 코드 생성 달력 컬럼 (DB 루프 — `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과)

| 조건 | API | 헤더 | 필드 | 폭 | 표시 | 출처 | 줄 |
|---|---|---|---|---:|---|---|---:|
| 컬럼명에 `B_` 포함(`IndexOf("B_") > 0`) | AddTextColumn | COLUMN_LABEL_NAME | COLUMN_NAME | 0 | 숨김 | DB_DRIVEN(코드) | 354 |
| 그 외 | AddNumColumn(숫자) | COLUMN_LABEL_NAME | COLUMN_NAME | 70 | 표시 | DB_DRIVEN(코드) | 358 |
| DAY_CODE = SAT / SUN | ForeColor | - | - | - | Blue / Red | 코드 | 362 |

- 헤더 Span: 0행 = LARGE_CLASS_LABEL_NAME, 1행 = SMALL_CLASS_LABEL_NAME, 그룹 시작 열에 `"SUM"` 헤더(368~396줄, 높이 20/30)를 둔다.
- 표시와 숨김은 다시 SetSpreadColumn(Tag 접두어 `D_`/`W_`/`M_` × `cboBucketType` × `chkSum`)이 결정한다. 규칙은 업무분석서 §4-3 표와 같다.
- 편집 가능 여부: 숫자 컬럼에 저장 대상 수량을 입력하는 것으로 보이나 잠금 규칙은 **확인 필요**.

### 4-3. 헤더 기본 스타일 (Designer.cs 580~583)
HorizontalAlignment=General, VerticalAlignment=General, NoteIndicatorColor=Red, Parent=`ColumnHeaderDefaultEnhanced`.

## 5. 액션 명세

| # | 트리거(버튼/이벤트) | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A1 | 화면 로드 | `Form_Load` | InitControls → SetChangedControl / GetBucketType / FP_Log2 → CreateSpread(AddSheet, drpPeriod 비활성, GetDayRange, InitSpread_2) | `biz:CommonData.CommonDataList`[PlantByDivisionOperation], `DM.DM0003_GET_BUCKET_TYPE_CODE`, `SCP.SCM0001_GET_SCP_DAY_PERIOD`, `biz:CommonData.CommonDataList`[PlantSiteByDivision], `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 조회조건 콤보 채움, 시트 `Shipment Request` 생성(메타 헤더와 달력 컬럼) |
| A2 | cboDivision 변경 | `CboDivision_SelectedIndexChanged` | SetChangedControl | `biz:CommonData.CommonDataList`[PlantByDivisionOperation] | 연동 컨트롤 갱신(대상 **확인 필요**) |
| A3 | cboBizType 변경 | `CboBizType_SelectedIndexChanged` | Data.Common(PlantByDivisionOperation) | `biz:CommonData.CommonDataList`[PlantByDivisionOperation] | 연동 컨트롤 갱신(대상 **확인 필요**) |
| A4 | btnItem_Id 클릭 | `BtnItem_Id_Click` | Model 선택 | 팝업 API **확인 필요** | `txtItem_Id.Text = sItemId` |
| A5 | cboBucketType 변경 | `cboBucketType_SelectedIndexChanged` | `siMain != null`이면 SetSpreadColumn | 없음 | 달력 컬럼 표시와 숨김 재계산 |
| A6 | chkSum 체크 변경 | `chkSum_CheckedChanged` | `siMain != null`이면 SetSpreadColumn | 없음 | Sum 대상(`M_`, DAILY 시 `W_`) 컬럼 표시 토글 |
| A7 | 조회(FindButton) | (프레임워크) FindData_Main | GetCheckedListValue → InitSpread_2 → 조회 → Set_SumValues | `biz:CommonData.CommonDataList`[PlantSiteByDivision], `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, `SSP.SSP0045_GET_SHIPMENT_REQUEST` | 시트 재초기화와 데이터 바인딩 |
| A8 | 저장(SaveButton) | (프레임워크) SaveData | 저장 → 재조회(A7과 같음) | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` (+ A7 엔드포인트) | 저장 후 시트 갱신 |
| A9 | 시트 셀 클릭 | `SpdMain_CellClick` | GetCheckedListValue(1227·1228), ComboSelChange 해제(1252) 후 재등록(1334) | 서버 호출 여부 **확인 필요** | **확인 필요** |
| A10 | 시트 콤보 선택 | `SpdMain_ComboSelChange` | 미추출 | **확인 필요** | **확인 필요** |
| A11 | 시트 셀 더블클릭 | `SpdMain_CellDoubleClick` | 미추출 | **확인 필요** | **확인 필요** |
| A12 | 시트 스크롤 | `SpdMain_TopChange` | 미추출 | **확인 필요** | **확인 필요** |
| A13 | 행 추가 | InsertRow / InsertRow2 | ITEM_ID 콤보 = Data_SCP.Common(BODItemProjectRoute) | **확인 필요**(엔드포인트 목록에 없음) | 시트가 잠겨 있지 않으면 ITEM_ID 콤보 설정 |
| A14 | 편집(EditButton) | (프레임워크) EditButton | `fps.Name == "spdMain"`이면 GetSheetInfo | 없음 | **확인 필요** |

> 화면 834줄의 주석 처리된 호출은 현행 액션에 넣지 않았습니다.

## 6. 검증·메시지

| # | 검증 | 사실 | 메시지 |
|---|---|---|---|
| V1 | 필수 조회조건 | 라벨에 `*`: Operation Group*, Division*, Period* | 검증 코드와 메시지 **확인 필요** |
| V2 | 저장 행 키 비교 | checkValidN0: dr/cpDr의 p_division_id, p_scm_site_id, p_item_id, p_incoterms, p_transport_mode, p_plant_site_id, p_bod_id, p_project_code, p_fcst_type(+dr p_user_id) | **확인 필요** |
| V3 | 그리드 필수 컬럼 | 헤더 `*`: Division*, From Site*, Incoterms*, Model*, To Site*, Trans Mode*, Measure*(숨김) | 검증 위치와 메시지 **확인 필요** |
| V4 | 시트 잠금 | 행 추가 시 `siMain.IsLock(...) == false`일 때만 ITEM_ID 콤보 설정 | - |

## 7. 권한(C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| R | FindButton → `SSP.SSP0045_GET_SHIPMENT_REQUEST` |
| C/U | SaveButton → `SSP.SSP0045_SAVE_SHIPMENT_REQUEST` (SP 내부 INSERT DM_PLN_SHIPMENT_REQ / UPDATE:A) |
| D | 삭제 버튼과 삭제 처리 사실 없음 → **확인 필요** |
| 권한 메타 | TB_FX_GroupMenuAuth 11행, TB_FX_ProgramInfo 1행, TB_FX_MenuItemInfo 1행. 플래그 값 **확인 필요** |
| 사용자/그룹 필터 | SetChangeControl: Filter[GROUP_ID], NowGroupID, Filter[USER_ID] → GetSSPInnerTable |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | AS-IS | To-Be 고려사항 |
|---|---|---|
| 그리드 | FarPoint FpSpread, 헤더 3행 + ColumnHeaderSpan | Wijmo FlexGrid `columnHeaders` 3행 + 병합으로 대분류/소분류/SUM 헤더를 재현 |
| 동적 컬럼 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과 루프로 Add*Column | 같은 결과로 FE에서 컬럼 배열을 생성. `B_` 컬럼은 숨김, SAT 파랑/SUN 빨강 |
| 표시 토글 | SetSpreadColumn(Tag 접두어) | FE 상태(Bucket, Sum)로 column.visible 계산. 서버 호출 없음 |
| 메타 | SetSheetHeaderColumn(SCM_MST_SHEET_COLUMNS) | TO-BE 메타 컬럼 정의로 이관(18행, 표시 12) |
| 기간 | drpPeriod Enabled=false | 읽기 전용 DateRange, 값 = `SCP.SCM0001_GET_SCP_DAY_PERIOD` 결과 |
| SP 변환 | MSSQL SP, `#TBLDYNAMIC_*` 임시테이블, `STRING_SPLIT`, 동적 SQL | Oracle 19c: 임시테이블은 GTT/WITH절, STRING_SPLIT은 Oracle 분해 함수로 바꿔야 함. 동적 피벗(#TBLDYNAMIC_SHIP_PIVOT)은 변환 설계 필요 |
| 공통코드 | `biz:CommonData.CommonDataList`(UP_FX_GetCommonDataList / _SCP 코드분기) | TO-BE 공통코드 API(PlantByDivisionOperation, PlantSiteByDivision) |
| 저장 | `SSP.SSP0045_SAVE_SHIPMENT_REQUEST`(SCM_ARR_SPL_CNT/VAL 배열 문자열) | 행 단위 파라미터 전달 방식으로 재설계할지 **확인 필요** |

## 9. 미확정
- `usrButton1` 용도와 배치(parent 없음).
- 조회조건 줄 안의 좌우 순서(Location 미추출).
- 콤보 초기값, 데이터 원천, PlantByDivisionOperation 결과의 대상 컨트롤.
- `SpdMain_TopChange` / `SpdMain_CellDoubleClick` / `SpdMain_ComboSelChange` / `SpdMain_CellClick`의 상세 처리.
- InsertRow/InsertRow2 진입 버튼, BODItemProjectRoute 원천, EditButton 동작.
- 메타 컬럼 순서, 타입, 편집 여부, 측정값 9행.
- DAILY에서 `W_` 컬럼의 최종 표시.
- 권한 플래그 값.
