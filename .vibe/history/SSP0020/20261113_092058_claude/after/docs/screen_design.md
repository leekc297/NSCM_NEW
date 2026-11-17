# SSP0020 화면설계서 (Delegate)

> 근거: AsisFacts Fact Pack(SSP0020) props.csv / controls.csv / events.csv / grid_effective.csv / grid_code.csv.
> 라벨은 props.csv Text 원문이다. 없는 사실은 **확인 필요**로 적었다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0020 |
| 클래스 | `SSP0020_Delegate` |
| 명칭(Form Text 원문) | `Inventory Raw(Small)` (Designer:701). 클래스명 Delegate와 다르다 → **확인 필요** |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 존재) |
| 그리드 구성 | META(프레임워크, `SCM_MST_SHEET_COLUMNS` 16행) + 코드 표시 변경 |
| 시트 | `Delegate`, `Delegated List` |
| 소스 | SSP0020_Delegate.cs(958줄), SSP0020_Delegate.Designer.cs(764줄) |

## 2. 화면 레이아웃

### 2-1. 분할 구조
- props.csv에 **SplitContainer가 없다**. 그래서 Orientation과 SplitterDistance는 해당하지 않는다. 분할은 Dock(Top/Fill)으로 정해진다.
- parent 체인(controls.csv)과 Dock·Size(props.csv):

```
this (SSP0020_Delegate)  Text="Inventory Raw(Small)"
├─ usrConditionPanel1   [UsrConditionPanel, Dock=Top, 1192×83, UsrPanelType=HidePanel]   ← 상단 12.8%
│   └─ usrLayoutControl2  [UsrLayoutControl, Dock=Top, 1192×73, Text="usrLayoutControl2"]
│       │  (layoutControlGroup2 1192×78)
│       ├─ usrLabel1     "Division*"  59×54   (layoutControlItem3 63×58)
│       ├─ clbDivision   377×40               (layoutControlItem4 377×40)
│       ├─ chkAll        "All" 373×14         (layoutControlItem1 377×18)
│       ├─ txtDelegatee  170×21               (lblDelegatee "Delegatee*" 255×24)
│       ├─ btnDelegatee  38×24                (layoutControlItem2 42×28)
│       ├─ drpPeriod     200×20               (layoutControlItem6 "Period*" 255×24)
│       ├─ btnMeasure    39×24                (layoutControlItem10 43×28)
│       ├─ btnSave       "SAVE" 71×22         (lcBtnSave 75×26)
│       ├─ btnUnSet      "UnSet" 71×22        (lcBtnUnset 75×26)
│       └─ (emptySpaceItem2 285×26 / emptySpaceItem3 435×32 / emptySpaceItem4 255×10 / emptySpaceItem6 42×30)
└─ panel1               [Panel, Dock=Fill, 1192×566]                                      ← 하단 87.2%
    └─ spdMain          [FpSpread, Dock=Fill, 1192×566]
        └─ spdMain_Sheet1 [SheetView]  → 실행 시 AddSheet로 시트 'Delegate' / 'Delegated List' 생성(CreateSpread 181~182)

parent 없음: usrButton1 [UsrButton 75×23] — 화면에 배치되지 않은 것으로 보임(확인 필요), imageList1
```

- 상:하 비율(Designer 크기 기준) = 83 : 566 → **12.8% : 87.2%**. 실행 시 하단(Fill)이 남은 영역을 채운다.
- 조건 영역 안의 행/열 배치는 Fact Pack에 Location이 없다. 아래 와이어프레임은 컨트롤 크기를 기준으로 그린 **추정 배치**이므로 **확인 필요**.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ [조회조건 영역] usrConditionPanel1 (HidePanel, 접기 가능)        높이 83 (12.8%)│
│  Division*  ┌clbDivision──────────────┐  Delegatee* [txtDelegatee ][btnDelegatee]│
│ (usrLabel1) │ □ ... (dtMyDivision)     │  Period*    [drpPeriod From ~ To]       │
│             └──────────────────────────┘  [btnMeasure]                          │
│             □ All (chkAll)                          [SAVE btnSave][UnSet btnUnSet]│
├──────────────────────────────────────────────────────────────────────────────┤
│ [그리드 영역] panel1 > spdMain (Fill)                           높이 566 (87.2%)│
│  ┌──────────────────────────────────────────────────────────────────────────┐ │
│  │ ☐ALL │ Div │ Delegatee │ From │ To │ Valid │ Last Updated By │ Last Update Date│
│  │ ...                                                                      │ │
│  └──────────────────────────────────────────────────────────────────────────┘ │
│  [ Delegate ][ Delegated List ]   ← 시트 탭                                   │
└──────────────────────────────────────────────────────────────────────────────┘
팝업: 사용자 검색(UserPopup — BtnDelegatee_Click과 연결되는지 확인 필요)
```

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrConditionPanel1 | UsrConditionPanel | - (HidePanel) | - | - | - | 조회조건 패널(접기 가능) |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | - | - | - | 조회조건 레이아웃 그리드 |
| usrLabel1 | UsrLabel | `Division*` | - | `*` 표시 | - | 조건 라벨(필수 표시) |
| clbDivision | CheckedListBoxControl | (usrLabel1 `Division*`) | dtMyDivision의 CODE/NAME 목록(InitControls:160) | `*` 표시 | (chkAll 연동 **확인 필요**) | 다중 선택 체크 목록(MultiSelect 계열) |
| chkAll | UsrCheckBox | `All` | 확인 필요 | - | CheckStateChanged → `chkAll_CheckStateChanged` | Checkbox(Division 전체) |
| txtDelegatee | UsrMultiLineEditor | `Delegatee*` (lblDelegatee) | `""` (InitControls:168) | `*` 표시 | - | 텍스트 입력 + 사용자 검색 |
| btnDelegatee | UsrButton | Text 없음 | - | - | Click → `BtnDelegatee_Click` | 검색(팝업 호출) 버튼. 아이콘 **확인 필요** |
| drpPeriod | UsrDateRangePicker | `Period*` (layoutControlItem6) | 확인 필요 | `*` 표시 | - | 기간 From~To 입력 |
| btnMeasure | UsrButton | Text 없음 | - | - | 배선 없음 | 용도 **확인 필요** |
| btnSave | UsrButton | `SAVE` | - | - | Click → `BtnSave_Click` | Button(저장) |
| btnUnSet | UsrButton | `UnSet` | - | - | Click → `BtnUnSet_Click` | Button(해제) |
| usrButton1 | UsrButton | Text 없음 | - | - | 배선 없음, parent 없음 | 미사용 여부 **확인 필요** |
| spdMain | FpSpread | 시트 `Delegate` / `Delegated List` | - | - | SheetTabClick → `SpdMain_SheetTabClick`, CellClick → `SpdMain_CellClick` | Wijmo FlexGrid + 시트 탭 |
| spdMain_Sheet1 | SheetView | - (Designer 기본 시트) | - | - | - | 그리드 시트(코드 AddSheet로 대체) |
| this(Form) | Form | `Inventory Raw(Small)` | - | - | Load → `Form_Load` | 화면 페이지 |

- `*` 표시는 라벨 문자열 사실이다. 실제 필수값 검증 코드는 **확인 필요**.

## 4. 그리드 명세

- 컬럼은 모두 META(`SetSheetHeaderColumn` InitSpread:199 / 207)에서 생성된다. 코드 하드코딩으로 추가한 컬럼은 없다.
- 컬럼 순서: grid_effective.csv의 행 순서는 메타 순번이 아니다. 아래 표는 1차 분석서의 순서를 따랐으며 실제 순서는 **확인 필요**.
- 컬럼 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE)과 편집 여부는 Fact Pack에 값이 없음 → **확인 필요**. 예외: CHK는 코드로 체크박스 셀 타입을 지정한다(216~218, 시트 추정 Delegated List).

### 4-1. 시트 `Delegate` (Tables[0], 표시 8컬럼)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|
| CHK | ALL | 체크박스(헤더 토글 `SpdMain_CellClick`) | META | 14개 division 모두 기본 | 확인 필요 |
| DIVISION_ID | Div | 확인 필요 | META | 모두 기본 | 확인 필요 |
| DELEGATEE | Delegatee | 확인 필요 | META | 모두 기본 | 확인 필요 |
| FROM_DATE | From | 확인 필요 | META | 모두 기본 | 확인 필요 |
| TO_DATE | To | 확인 필요 | META | 모두 기본 | 확인 필요 |
| VALID | Valid | 확인 필요 | META | 모두 기본 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 모두 기본 | 확인 필요 |
| LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 모두 기본 | 확인 필요 |

### 4-2. 시트 `Delegated List` (Tables[1], 표시 7컬럼)

| 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---|---|---|---|---|---|
| CHK | ALL | chk / Value=false / Border=bevelbrdr (InitSpread 216~218, 시트 추정) | META | **숨김**(14개 division 모두) | - |
| DIVISION_ID | Div | 확인 필요 | META | 모두 기본 | 확인 필요 |
| DELEGATOR | Delegator | 확인 필요 | META | 모두 기본 | 확인 필요 |
| FROM_DATE | From | 확인 필요 | META | 모두 기본 | 확인 필요 |
| TO_DATE | To | 확인 필요 | META | 모두 기본 | 확인 필요 |
| VALID | Valid | 확인 필요 | META | 모두 기본 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 모두 기본 | 확인 필요 |
| LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 모두 기본 | 확인 필요 |

### 4-3. 공통 표시 설정
- 컬럼 헤더 기본 스타일(Designer 667~670): HorizontalAlignment=General, VerticalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced.
- AddSheet 인자 `1 ¦ 1 ¦ 35`(CreateSpread 181/182). 각 인자의 의미는 **확인 필요**.
- division별 표시 차이는 없다(40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC).

## 5. 액션 명세

| 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|
| 화면 Load | `Form_Load` | FindData_Main | `SSP.SSP0020_GET_DELEGATE` | Tables[0]>0 → `Delegate`, Tables[1]>0 && !isReLoad → `Delegated List`. 활성 시트는 intActiveSheetIdx로 정함 |
| 조회(FindButton) | FindButton | FindData_Main | `SSP.SSP0020_GET_DELEGATE` | 위와 같음 |
| chkAll 체크 변경 | `chkAll_CheckStateChanged` | 확인 필요 | 없음 | 확인 필요 |
| btnDelegatee 클릭 | `BtnDelegatee_Click` | 사용자 검색(UserPopup 연결 확인 필요) | 없음 | txtDelegatee.Text = item.UserName / item.UserName_E (841/843) |
| btnSave 클릭 | `BtnSave_Click` | UserName_Search / Validation_Check / SaveData / FindData_Main (순서 확인 필요) | `SSP.UP_FX_GetSSPUserUseInfoList`, `SSP.SSP0020_SAVE_DELEGATE`, `SSP.SSP0020_GET_DELEGATE` | txtDelegatee.Text 갱신(793/795), SSP_MST_DELEGATE INSERT, 재조회 |
| btnUnSet 클릭 | `BtnUnSet_Click` | UnSet(657 / 715) / FindData_Main | `SSP.SSP0020_SAVE_UNSET`, `SSP.SSP0020_GET_DELEGATE` | SSP_MST_DELEGATE UPDATE, 재조회 |
| spdMain 시트 탭 클릭 | `SpdMain_SheetTabClick` | 확인 필요 | 없음 | 확인 필요 |
| spdMain 셀 클릭 | `SpdMain_CellClick` | RowCount≥1 && 컬럼 헤더 && CheckBoxCellType이면 헤더 Value 반전 | 없음 | 헤더 체크 true→false(859) / false→true(863) |

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| Validation_Check | 행별로 DIVISION_ID, VALID, FROM_DATE, TO_DATE를 읽는다. 추가로 USER_ID(431~437)와 DELEGATEE_ID(445~451)를 읽는 블록이 있다 | 판정 규칙과 메시지 문구 **확인 필요** |
| 필수 표시 | `Division*`, `Delegatee*`, `Period*` | 검증 코드 **확인 필요** |
| 사용자 조회 | UP_FX_GetSSPUserUseInfoList 결과 Rows[0] 사용 | 0행일 때 메시지·동작 **확인 필요** |
| 저장·해제 확인창, 완료 메시지 | Fact Pack에 없음 | **확인 필요** |

## 7. 권한 (C/R/U/D)

- 메타 행: `TB_FX_GroupMenuAuth` 7행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행, `TB_FX_Favorite` 13행.
- 그룹별 C/R/U/D 값은 Fact Pack에 없음 → **확인 필요**.
- 코드에서 권한으로 btnSave·btnUnSet의 Enabled/Visible을 제어한다는 사실은 추출되지 않았다.

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | As-Is | To-Be 메모 |
|---|---|---|
| 조회조건 패널 | usrConditionPanel1(HidePanel) + DevExpress LayoutControl | 공용 조회조건 패널(접기). 배치는 As-Is Location 확인 후 결정 |
| Division | clbDivision(CheckedListBoxControl) + chkAll | 다중 선택 컴포넌트(전체 선택 포함). 목록 원천 = NowGroupID 기반 Division |
| Delegatee | txtDelegatee + btnDelegatee + UserPopup | 입력 + 공용 사용자 검색 팝업 |
| Period | drpPeriod(UsrDateRangePicker) | 날짜 범위 입력(From~To). 날짜 형식 **확인 필요** |
| 그리드 | FarPoint FpSpread 2시트 | Wijmo FlexGrid + 시트 탭 2개(`Delegate` / `Delegated List`). 컬럼은 SCM_MST_SHEET_COLUMNS 메타로 생성 |
| 헤더 체크 | SpdMain_CellClick로 헤더 CheckBox 토글 | FlexGrid 헤더 체크박스로 전체 선택/해제(RowCount≥1 조건 유지) |
| SP | MSSQL `SSP0020_GET_DELEGATE`(동적 SQL), `SSP0020_SAVE_DELEGATE`, `SSP0020_SAVE_UNSET`, `UP_FX_GetSSPUserUseInfoList` | Oracle 19c 변환. 동적 SQL과 배열 분해(SCM_ARR_SPL_CNT/VAL)는 Oracle 구문으로 바꾸고, 결과 셋 2개(Tables[0]/[1])를 각각 반환하도록 설계해야 함. 원문 **확인 필요** |
| 로그 | PR_SCM_SYS_LOG_BATCH_CALL_TRAN → SCM_SYS_LOG_BATCH | Oracle 측 대응 객체 **확인 필요** |
| 미사용 후보 | btnMeasure, usrButton1(배선 없음) | 구현 여부 **확인 필요** |

## 9. 미확정

1. 화면 명칭(`Inventory Raw(Small)`)과 메뉴 위치.
2. 조건 영역의 컨트롤 배치(Location).
3. 그리드 컬럼 순서, 셀 타입, 편집 가능 여부, CHK 코드 설정이 적용되는 시트.
4. `chkAll_CheckStateChanged`, `SpdMain_SheetTabClick`, `BtnDelegatee_Click`의 처리 내용.
5. `BtnSave_Click`의 호출 순서, Validation_Check 규칙과 메시지.
6. UnSet 657/715의 분기 조건.
7. btnMeasure, usrButton1의 용도.
8. 권한 그룹별 C/R/U/D 값.
