=== FILE: analysis.md ===
# SSP0020 As-is 분석서 (Delegate)

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0020). Fact Pack에 없는 내용은 **확인 필요**로 적었다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0020 |
| 클래스 | `SSP0020_Delegate` |
| 도메인 | SSP (프로젝트 `GSCM.SSP.Plan.UIL`) |
| Form Text (Designer:701) | `"Inventory Raw(Small)"` — 클래스명(Delegate)과 맞지 않음. **확인 필요** |
| Grid 구성 방식 | `META(프레임워크) (+코드 표시/라벨 변경)` |
| 시트 | `Delegate`, `Delegated List` |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0020_Delegate.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 958 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0020_Delegate.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 764 |
| shared | 없음(Fact Pack 기준) | - | - |
| legacy | 없음(Fact Pack 기준) | - | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| event:this.Load | `Form_Load` > FindData_Main | 268 | `SSP.SSP0020_GET_DELEGATE` | MATCH | SSP0020_GET_DELEGATE |
| button:FindButton | FindButton > FindData_Main | 268 | `SSP.SSP0020_GET_DELEGATE` | MATCH | SSP0020_GET_DELEGATE |
| event:btnSave.Click | `BtnSave_Click` > UserName_Search | 781 | `SSP.UP_FX_GetSSPUserUseInfoList` | MATCH | UP_FX_GetSSPUserUseInfoList |
| event:btnSave.Click | `BtnSave_Click` > SaveData | 507 | `SSP.SSP0020_SAVE_DELEGATE` | MATCH | SSP0020_SAVE_DELEGATE |
| event:btnSave.Click | `BtnSave_Click` > FindData_Main | 268 | `SSP.SSP0020_GET_DELEGATE` | MATCH | SSP0020_GET_DELEGATE |
| event:btnUnSet.Click | `BtnUnSet_Click` > UnSet | 657 | `SSP.SSP0020_SAVE_UNSET` | MATCH | SSP0020_SAVE_UNSET |
| event:btnUnSet.Click | `BtnUnSet_Click` > UnSet | 715 | `SSP.SSP0020_SAVE_UNSET` | MATCH | SSP0020_SAVE_UNSET |
| event:btnUnSet.Click | `BtnUnSet_Click` > FindData_Main | 268 | `SSP.SSP0020_GET_DELEGATE` | MATCH | SSP0020_GET_DELEGATE |

- 위 표의 같은 진입점 안에서 호출 순서는 flow.csv에 명시되지 않았다. 표의 순서는 메서드 이름에서 짐작한 순서이므로 **확인 필요**.
- `BtnSave_Click`(진입 줄 352)에서 호출하는 `SaveData`를 프레임워크 메타 분석기는 `PersonalSettingPopup.SaveData`로 해석했다. 반면 엔드포인트 추출은 이 화면의 `SaveData`(507, `SSP.SSP0020_SAVE_DELEGATE`)를 가리킨다. 이름이 같아서 생긴 오해석으로 보이며 **확인 필요**.
- `UnSet` 메서드는 `SSP.SSP0020_SAVE_UNSET`을 두 곳(657, 715)에서 호출한다. 두 지점의 분기 조건(예: 시트별 처리)은 Fact Pack에 없어 **확인 필요**.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체 (EXEC 전이 포함) |
|---|---|---:|---|---|
| `SSP.SSP0020_GET_DELEGATE` | MATCH | 1 | SSP0020_GET_DELEGATE | EXEC:SSP0020_GET_DELEGATE, DYNAMIC@SSP0020_GET_DELEGATE (동적 SQL) |
| `SSP.SSP0020_SAVE_DELEGATE` | MATCH | 1 | SSP0020_SAVE_DELEGATE | EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH |
| `SSP.SSP0020_SAVE_UNSET` | MATCH | 2 | SSP0020_SAVE_UNSET | EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH |
| `SSP.UP_FX_GetSSPUserUseInfoList` | MATCH | 1 | UP_FX_GetSSPUserUseInfoList | SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER |

- 주석 처리된 호출(commented_calls): 0건.
- `SSP0020_GET_DELEGATE` 결과 사용: `FindData_Main`은 `dsBinding.Tables[0]`의 행 수로 `Delegate` 시트(290~291)를, `dsBinding.Tables[1]`의 행 수와 `isReLoad == false` 조건으로 `Delegated List` 시트(299~300)를 바인딩·활성화한다. 결과 셋은 2개로 보인다.

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 엔드포인트 연결 |
|---|---|---|---|---|
| this.chkAll | CheckStateChanged | `chkAll_CheckStateChanged` | Designer InitializeComponent:298 | 없음. 동작(clbDivision 전체 선택 여부)은 **확인 필요** |
| this | Load | `Form_Load` | .ctor:104 | `SSP.SSP0020_GET_DELEGATE` |
| btnDelegatee | Click | `BtnDelegatee_Click` | InitEvent:224 | 엔드포인트 없음. `UserPopup`(841/843에서 txtDelegatee.Text 설정)과의 호출 관계는 **확인 필요** |
| btnSave | Click | `BtnSave_Click` | InitEvent:225 | `SSP.UP_FX_GetSSPUserUseInfoList`, `SSP.SSP0020_SAVE_DELEGATE`, `SSP.SSP0020_GET_DELEGATE` |
| btnUnSet | Click | `BtnUnSet_Click` | InitEvent:226 | `SSP.SSP0020_SAVE_UNSET`, `SSP.SSP0020_GET_DELEGATE` |
| spdMain | SheetTabClick | `SpdMain_SheetTabClick` | InitEvent:228 | 없음. 동작은 **확인 필요** |
| spdMain | CellClick | `SpdMain_CellClick` | InitEvent:229 | 없음. 컬럼 헤더 CheckBoxCellType 클릭 시 헤더 Value를 true/false로 토글(859/863) |

## 5. 주요 메서드 사실

| 메서드 | 사실 |
|---|---|
| `<field:dtMyDivision>`(52) | `UserInfoContext.Current`의 `NowGroupID` 사용 |
| InitControls(137, 160, 168) | `dtMyDivision.Rows[i]`의 `CODE`, `NAME`으로 Division 목록 구성(160). `c["CODE"]` 참조(137). `txtDelegatee.Text = ""` 초기화(168) |
| Validation_Check(417~451) | `DIVISION_ID`, `VALID`, `FROM_DATE`, `TO_DATE`를 읽는 블록 3개(417~422 / 431~437 `USER_ID` 포함 / 445~451 `DELEGATEE_ID` 포함). 구체적인 판정 규칙(중복 기간 검사 등)은 **확인 필요** |
| UserName_Search(781~795) | `UP_FX_GetSSPUserUseInfoList` 결과의 `UserID`(791), `UserName`(793), `UserName_E`(795) 사용. 793/795는 txtDelegatee.Text에 각각 이름/영문명을 설정(언어 분기로 추정, **확인 필요**) |
| UserPopup(841/843) | txtDelegatee.Text = `item.UserName` / `item.UserName_E` |

## 6. Grid 구성 방식

- **구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**
- CreateSpread(181~189): `AddSheet`로 `Delegate`(SpdSheet.shtMain)와 `Delegated List`(SpdSheet.shtMainList)를 만든다. 인자는 `1 ¦ 1 ¦ 35`이다.
- InitSpread: 시트명이 `"Delegate"`이면 `SetSheetHeaderColumn(spdInfo, 1)`(199), `"Delegated List"`이면 `SetSheetHeaderColumn(spdInfo, 1)`(207)을 호출한다. 메타 테이블은 `SCM_MST_SHEET_COLUMNS` 16행이다.
- 코드 변경: InitSpread 216~218에서 `CHK` 컬럼에 CellType=chk, Value=false, Border=bevelbrdr를 설정한다(시트 추정 `Delegated List`, **확인 필요**).
- SpdMain_CellClick(859/863): 헤더 체크박스를 토글한다(전체 선택/해제).

### 6-1. Division별 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Delegate | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Delegated List | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |

→ 모든 division에서 같다. division별 분기 코드는 없다(판단불가 0건).

## 7. 확인 필요 항목

1. Form Text가 `"Inventory Raw(Small)"`(Designer:701)로 화면 명칭과 맞지 않는다. 실제 메뉴명은 TB_FX_MenuItemInfo / TB_FX_ProgramInfo로 확인해야 한다.
2. `BtnSave_Click` 안의 호출 순서(UserName_Search → Validation → SaveData → FindData_Main 여부).
3. `BtnSave_Click`:352의 `SaveData`가 `PersonalSettingPopup.SaveData`로 해석된 것이 오해석인지.
4. `UnSet`에서 `SSP0020_SAVE_UNSET`을 호출하는 두 지점(657, 715)의 분기 조건.
5. `BtnDelegatee_Click`과 `UserPopup`의 연결, 그리고 `btnMeasure`·`usrButton1`의 용도(이벤트 배선 없음).
6. `chkAll_CheckStateChanged`, `SpdMain_SheetTabClick`의 처리 내용.
7. InitSpread 216~218의 CHK 설정이 적용되는 시트(Delegate인지 Delegated List인지). grid_effective 기준으로 `Delegated List`의 CHK는 메타상 숨김이다.
8. `SSP0020_GET_DELEGATE` 동적 SQL의 내용과 조회 파라미터(Division·Period·Delegatee 등).
9. Validation_Check의 상세 판정 규칙과 메시지.

=== FILE: source_links.md ===
# SSP0020 소스 링크

기준 경로: `06.UIL\GSCM.SSP.Plan.UIL\`

## 1. 엔드포인트 호출 지점 (전수 5건)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.cs | FindData_Main | 268 | `SSP.SSP0020_GET_DELEGATE` 호출 (SP SSP0020_GET_DELEGATE) |
| SSP0020_Delegate.cs | SaveData | 507 | `SSP.SSP0020_SAVE_DELEGATE` 호출 (SP SSP0020_SAVE_DELEGATE) |
| SSP0020_Delegate.cs | UnSet | 657 | `SSP.SSP0020_SAVE_UNSET` 호출 (1번째) |
| SSP0020_Delegate.cs | UnSet | 715 | `SSP.SSP0020_SAVE_UNSET` 호출 (2번째) |
| SSP0020_Delegate.cs | UserName_Search | 781 | `SSP.UP_FX_GetSSPUserUseInfoList` 호출 |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.Designer.cs | InitializeComponent | 298 | `this.chkAll.CheckStateChanged += chkAll_CheckStateChanged` |
| SSP0020_Delegate.cs | .ctor | 104 | `this.Load += Form_Load` |
| SSP0020_Delegate.cs | InitEvent | 224 | `btnDelegatee.Click += BtnDelegatee_Click` |
| SSP0020_Delegate.cs | InitEvent | 225 | `btnSave.Click += BtnSave_Click` |
| SSP0020_Delegate.cs | InitEvent | 226 | `btnUnSet.Click += BtnUnSet_Click` |
| SSP0020_Delegate.cs | InitEvent | 228 | `spdMain.SheetTabClick += SpdMain_SheetTabClick` |
| SSP0020_Delegate.cs | InitEvent | 229 | `spdMain.CellClick += SpdMain_CellClick` |

## 3. Grid / 시트

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.cs | CreateSpread | 181 | AddSheet `Delegate` (SpdSheet.shtMain, 1,1,35) |
| SSP0020_Delegate.cs | CreateSpread | 182 | AddSheet `Delegated List` (SpdSheet.shtMainList, 1,1,35) |
| SSP0020_Delegate.cs | CreateSpread | 184~185 | GetSheetInfo / ChangeSheet `Delegate` |
| SSP0020_Delegate.cs | CreateSpread | 188~189 | GetSheetInfo / ChangeSheet `Delegated List` |
| SSP0020_Delegate.cs | InitSpread | 198~199 | InitSheet + `SetSheetHeaderColumn(spdInfo,1)` — Delegate |
| SSP0020_Delegate.cs | InitSpread | 206~207 | InitSheet + `SetSheetHeaderColumn(spdInfo,1)` — Delegated List |
| SSP0020_Delegate.cs | InitSpread | 216~218 | CHK CellType=chk / Value=false / Border=bevelbrdr |
| SSP0020_Delegate.cs | FindData_Main | 290~291 | `Tables[0].Rows.Count > 0` → ChangeSheet/ChangeActiveSheet Delegate |
| SSP0020_Delegate.cs | FindData_Main | 299~300 | `Tables[1].Rows.Count > 0 && isReLoad == false` → Delegated List |
| SSP0020_Delegate.cs | FindData_Main | 312~313 | `intActiveSheetIdx == 0` → Delegate 활성 |
| SSP0020_Delegate.cs | FindData_Main | 317~318 | 그 외 → Delegated List 활성 |
| SSP0020_Delegate.cs | SpdMain_CellClick | 859 / 863 | 헤더 CheckBox Value false / true 토글 |
| SSP0020_Delegate.Designer.cs | InitializeComponent | 667~670 | 컬럼 헤더 스타일(HorizontalAlignment.General, NoteIndicatorColor.Red, Parent=ColumnHeaderDefaultEnhanced, VerticalAlignment.General) |

## 4. 데이터 컬럼 사용

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.cs | `<field:dtMyDivision>` | 52 | `UserInfoContext.Current` NowGroupID |
| SSP0020_Delegate.cs | InitControls | 137 | `c["CODE"]` |
| SSP0020_Delegate.cs | InitControls | 160 | `dtMyDivision.Rows[i]` CODE, NAME |
| SSP0020_Delegate.cs | InitControls | 168 | `txtDelegatee.Text = ""` |
| SSP0020_Delegate.cs | Validation_Check | 417~422 | DIVISION_ID, VALID, FROM_DATE, TO_DATE |
| SSP0020_Delegate.cs | Validation_Check | 431~437 | DIVISION_ID, VALID, USER_ID, FROM_DATE, TO_DATE |
| SSP0020_Delegate.cs | Validation_Check | 445~451 | DIVISION_ID, VALID, DELEGATEE_ID, FROM_DATE, TO_DATE |
| SSP0020_Delegate.cs | UserName_Search | 791 | UserID |
| SSP0020_Delegate.cs | UserName_Search | 793 | `txtDelegatee.Text = UserName` |
| SSP0020_Delegate.cs | UserName_Search | 795 | `txtDelegatee.Text = UserName_E` |
| SSP0020_Delegate.cs | UserPopup | 841 / 843 | `txtDelegatee.Text = item.UserName / item.UserName_E` |
| SSP0020_Delegate.cs | BtnSave_Click | 352 | `SaveData` 호출(프레임워크 해석 = PersonalSettingPopup.SaveData, **확인 필요**) |

## 5. 화면 속성

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0020_Delegate.Designer.cs | InitializeComponent | 701 | `this.Text = "Inventory Raw(Small)"` |

=== FILE: web_components.md ===
# SSP0020 Web 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 컴포넌트 후보 |
|---|---|---|---|---|
| usrLabel1 (layoutControlItem3) | UsrLabel | `Division*` | 59×54 | 조회조건 라벨(필수 표시) |
| clbDivision (layoutControlItem4) | CheckedListBoxControl | (Division* 라벨 영역) | 377×40 | 다중 선택 체크 목록 (Division 다중 선택 컴포넌트) |
| chkAll (layoutControlItem1) | UsrCheckBox | `All` | 373×14 | Checkbox (Division 전체 선택) |
| txtDelegatee (lblDelegatee) | UsrMultiLineEditor | `Delegatee*` | 170×21 (Item 255×24) | 텍스트 입력 + 사용자 검색 팝업 |
| btnDelegatee (layoutControlItem2) | UsrButton | Text 없음(Fact Pack) | 38×24 | 사용자 검색(돋보기) 버튼. 아이콘은 **확인 필요** |
| drpPeriod (layoutControlItem6) | UsrDateRangePicker | `Period*` | 200×20 | 기간(From~To) DateRange 입력 |
| btnSave (lcBtnSave) | UsrButton | `SAVE` | 71×22 | Button (저장) |
| btnUnSet (lcBtnUnset) | UsrButton | `UnSet` | 71×22 | Button (해제) |
| btnMeasure (layoutControlItem10) | UsrButton | Text 없음 | 39×24 | 용도·이벤트 미배선 — **확인 필요** |
| usrButton1 | UsrButton | Text 없음 | 75×23 | parent 없음 — 미사용 여부 **확인 필요** |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | 시트 `Delegate`, `Delegated List` | 1192×566 | Wijmo FlexGrid + 시트 탭 |
| usrConditionPanel1 | UsrConditionPanel (HidePanel) | - | 1192×83 | 조회조건 패널(접기 가능) |
| usrLayoutControl2 / layoutControlGroup2 | UsrLayoutControl / LayoutControlGroup | - | 1192×73 / 1192×78 | 조건 영역 레이아웃 |
| panel1 | Panel | - | 1192×566 | Grid 컨테이너 |
| emptySpaceItem2/3/4/6 | EmptySpaceItem | - | 285×26 / 435×32 / 255×10 / 42×30 | 간격 |
| imageList1 | ImageList | - | - | 해당 없음 |

## 2. 화면 배치

- props.csv에는 SplitContainer가 없다. 분할 비율(Orientation·SplitterDistance)은 해당하지 않는다.
- 상/하 구성(Dock 기준)
  - 상단: `usrConditionPanel1` Dock=Top, 높이 83(내부 usrLayoutControl2 Dock=Top, 높이 73)
  - 하단: `panel1` Dock=Fill, 높이 566 → `spdMain` Dock=Fill
  - Designer 크기 기준 상:하 = 83 : 566 (약 12.8% : 87.2%). 실행 시 하단이 남은 영역을 채운다.
- 조건 영역 안의 컨트롤 좌표·순서는 Fact Pack에 Location이 없어 **확인 필요**.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

모든 컬럼은 메타(`SCM_MST_SHEET_COLUMNS`, `SetSheetHeaderColumn`)에서 생성된다. 코드 하드코딩 컬럼 추가는 없다.

### 3-1. `Delegate` (표시 8컬럼, 모든 division 동일)

| # | 컬럼 | 라벨 | 출처 | 표시 |
|---:|---|---|---|---|
| 1 | CHK | ALL | META | 기본 |
| 2 | DIVISION_ID | Div | META | 기본 |
| 3 | DELEGATEE | Delegatee | META | 기본 |
| 4 | FROM_DATE | From | META | 기본 |
| 5 | TO_DATE | To | META | 기본 |
| 6 | VALID | Valid | META | 기본 |
| 7 | LAST_UPDATED_BY | Last Updated By | META | 기본 |
| 8 | LAST_UPDATE_DATE | Last Update Date | META | 기본 |

> 컬럼 순서는 grid_effective.csv의 행 순서(알파벳 정렬로 보임)와 같지 않을 수 있다. 실제 순서는 메타의 컬럼 순번으로 **확인 필요**.

### 3-2. `Delegated List` (표시 7컬럼, 모든 division 동일)

| # | 컬럼 | 라벨 | 출처 | 표시 |
|---:|---|---|---|---|
| - | CHK | ALL | META | **숨김**(전 division) |
| 1 | DIVISION_ID | Div | META | 기본 |
| 2 | DELEGATOR | Delegator | META | 기본 |
| 3 | FROM_DATE | From | META | 기본 |
| 4 | TO_DATE | To | META | 기본 |
| 5 | VALID | Valid | META | 기본 |
| 6 | LAST_UPDATED_BY | Last Updated By | META | 기본 |
| 7 | LAST_UPDATE_DATE | Last Update Date | META | 기본 |

### 3-3. 코드 표시 변경

| 줄 | 대상 | 변경 |
|---:|---|---|
| InitSpread 216~218 | CHK (시트 추정 Delegated List) | CellType=chk, Value=false, Border=bevelbrdr |
| SpdMain_CellClick 859/863 | 활성 시트 컬럼 헤더 CheckBox | 헤더 클릭 시 Value true↔false 토글(전체 체크) |
| Designer 667~670 | 컬럼 헤더 기본 스타일 | Align General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced |

### 3-4. Division별 표시 차이
- 없음. 40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC 모두 Delegate 8, Delegated List 7.

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 데이터 원천 | 활성화 조건 |
|---|---|---|---|
| `Delegate` | META+코드연결 (SpdSheet.shtMain) | `SSP0020_GET_DELEGATE` 결과 Tables[0] | Rows>0일 때 바인딩(290~291). `intActiveSheetIdx == 0`이면 활성(312~313) |
| `Delegated List` | META+코드연결 (SpdSheet.shtMainList) | `SSP0020_GET_DELEGATE` 결과 Tables[1] | Rows>0이고 `isReLoad == false`일 때 바인딩(299~300). `intActiveSheetIdx != 0`이면 활성(317~318) |

- 시트 탭 클릭 이벤트(`SpdMain_SheetTabClick`)의 처리 내용은 **확인 필요**.

=== FILE: oracle_migration.md ===
# SSP0020 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 엔드포인트 | 용도(호출 위치 기준) | 참조 테이블/객체 | EXEC 체인 |
|---|---|---|---|---|
| `SSP0020_GET_DELEGATE` | SSP.SSP0020_GET_DELEGATE | 조회 (FindData_Main:268) | 동적 SQL(DYNAMIC@SSP0020_GET_DELEGATE). 참조 테이블은 정적 추출 불가 — **확인 필요** | 없음 |
| `SSP0020_SAVE_DELEGATE` | SSP.SSP0020_SAVE_DELEGATE | 위임 저장 (SaveData:507) | INSERT:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL | → PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| `SSP0020_SAVE_UNSET` | SSP.SSP0020_SAVE_UNSET | 위임 해제 (UnSet:657, 715) | UPDATE:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL | → PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| `UP_FX_GetSSPUserUseInfoList` | SSP.UP_FX_GetSSPUserUseInfoList | 사용자 조회 (UserName_Search:781) | SELECT:SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER | 없음 |

### 1-1. 결과 컬럼 사용 (화면 측)
- `SSP0020_GET_DELEGATE`: 결과 셋 2개(Tables[0] → Delegate, Tables[1] → Delegated List). 시트 메타 컬럼은 CHK, DIVISION_ID, DELEGATEE/DELEGATOR, FROM_DATE, TO_DATE, VALID, LAST_UPDATED_BY, LAST_UPDATE_DATE. Validation_Check는 USER_ID, DELEGATEE_ID도 읽는다.
- `UP_FX_GetSSPUserUseInfoList`: UserID, UserName, UserName_E.

## 2. 공통코드 분기
- Fact Pack에 `code=X → 테이블` 형태의 공통코드 분기는 없다.
- Division 목록(clbDivision)은 `dtMyDivision`(UserInfoContext.Current.NowGroupID 기반)의 CODE/NAME으로 구성된다. dtMyDivision을 채우는 원천 SP/쿼리는 Fact Pack에 없어 **확인 필요**.

## 3. FoxQuery 미등록 / 직접 호출 SP
- 엔드포인트 4개 모두 `MATCH`(FoxQuery 키와 SP가 대응됨). 미등록·직접 호출 SP는 없다.
- 주석 처리된 호출: 0건.

## 4. 사용 테이블 요약

| 테이블 | 작업 | SP |
|---|---|---|
| SSP_MST_DELEGATE | INSERT | SSP0020_SAVE_DELEGATE |
| SSP_MST_DELEGATE | UPDATE | SSP0020_SAVE_UNSET |
| SCM_SYS_LOG_BATCH | INSERT | SSP0020_SAVE_DELEGATE, SSP0020_SAVE_UNSET |
| SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER | SELECT | UP_FX_GetSSPUserUseInfoList |
| SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | REF(함수/객체 참조) | SSP0020_SAVE_DELEGATE, SSP0020_SAVE_UNSET |

## 5. Oracle 전환 시 확인 포인트

1. **동적 SQL**: `SSP0020_GET_DELEGATE`는 DYNAMIC 표기가 있다. 원문 SQL 문자열 안의 MSSQL 구문(GETDATE/ISNULL/CONVERT 등)과 참조 테이블은 정적 추출로 확인되지 않았다. 원문을 열어 전수 확인해야 한다.
2. **결과 셋 2개 반환**: 화면이 Tables[0]/Tables[1]을 사용하므로, Oracle에서는 SYS_REFCURSOR 2개(또는 조회 2개로 분리)로 구현해야 한다.
3. **배열 분할 객체**: `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` 참조 → 구분자 문자열 파라미터(다건 Division 등)를 분할하는 로직이다. Oracle의 대응 함수/객체가 있는지 확인해야 한다.
4. **로그 체인**: `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` → `SCM_SYS_LOG_BATCH` INSERT. 트랜잭션 경계(로그 커밋 분리 여부)를 확인해야 한다.
5. **UnSet 이중 호출**: `SSP0020_SAVE_UNSET`의 호출 지점이 2곳(657, 715)이다. 파라미터 차이를 확인해야 한다.
6. **공통 사용자 SP**: `UP_FX_GetSSPUserUseInfoList`는 프레임워크(TB_FX_*) 테이블을 조회한다. TO-BE 공통 사용자 조회 API와 중복되는지 확인해야 한다.
7. **파라미터 시그니처**: 4개 SP 모두 입력 파라미터 목록이 Fact Pack에 없어 **확인 필요**.

### 난이도 (사실 근거만)
| SP | 근거 | 판단 |
|---|---|---|
| SSP0020_GET_DELEGATE | 동적 SQL + 결과 셋 2개 | 원문 확인 전까지 상대적으로 높음 |
| SSP0020_SAVE_DELEGATE | 배열 분할 REF + 로그 EXEC 체인 + INSERT 1 테이블 | 중간 |
| SSP0020_SAVE_UNSET | 배열 분할 REF + 로그 EXEC 체인 + UPDATE 1 테이블 | 중간 |
| UP_FX_GetSSPUserUseInfoList | SELECT 4 테이블, EXEC 체인 없음 | 낮음 (공통 처리 여부에 따름) |

=== FILE: tobe_design.md ===
# SSP0020 TO-BE 설계 근거

## 1. 조회조건 (컨트롤 기준)

| 조건 | As-is 컨트롤 | 라벨 원문 | 필수 표시 | 비고 |
|---|---|---|---|---|
| Division | clbDivision (CheckedListBoxControl) + chkAll | `Division*` / `All` | `*` 있음 | 다중 선택. 목록 = dtMyDivision CODE/NAME |
| Delegatee | txtDelegatee (UsrMultiLineEditor) + btnDelegatee | `Delegatee*` | `*` 있음 | 사용자 검색 팝업(UserPopup)으로 UserName/UserName_E 설정 |
| Period | drpPeriod (UsrDateRangePicker) | `Period*` | `*` 있음 | From~To |

- 이 조건들이 조회(`SSP0020_GET_DELEGATE`) 파라미터인지 저장(`SSP0020_SAVE_DELEGATE`) 입력값인지는 Fact Pack에 파라미터 정보가 없어 **확인 필요**. 저장 시 `UserName_Search`가 호출되는 것으로 보아 Delegatee·Period는 저장 입력값일 가능성이 있으나 확정이 아니다.
- TB_FX_SearchCondition에 SSP0020 행이 2건 있다(내용 미포함) → 조회조건 저장 기능이 있는지 **확인 필요**.

## 2. 액션별 호출 API 후보

| 액션 | As-is 핸들러 | 호출 엔드포인트 | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | `Form_Load` | SSP.SSP0020_GET_DELEGATE | 조회 API (결과 2셋: Delegate / Delegated List) |
| 조회 버튼 | FindButton | SSP.SSP0020_GET_DELEGATE | 조회 API |
| 저장 | `BtnSave_Click` | SSP.UP_FX_GetSSPUserUseInfoList → (Validation_Check) → SSP.SSP0020_SAVE_DELEGATE → SSP.SSP0020_GET_DELEGATE | 사용자 확인 API + 위임 저장 API + 재조회. 순서는 **확인 필요** |
| 해제 | `BtnUnSet_Click` | SSP.SSP0020_SAVE_UNSET (2지점) → SSP.SSP0020_GET_DELEGATE | 위임 해제 API + 재조회 |
| 위임 대상 검색 | `BtnDelegatee_Click` | 엔드포인트 없음(팝업) | 공통 사용자 검색 팝업 |
| Division 전체 선택 | `chkAll_CheckStateChanged` | 없음 | FE 로컬 처리 |
| 시트 탭 전환 | `SpdMain_SheetTabClick` | 없음 | FE 탭 전환(처리 내용 **확인 필요**) |
| 헤더 전체 체크 | `SpdMain_CellClick` | 없음 | FE 헤더 체크박스 전체 선택/해제 |

## 3. Division별 Grid 변형 요약
- 변형 없음. `Delegate` 8컬럼, `Delegated List` 7컬럼(CHK 숨김)이 14개 division 모두 같다.
- Grid는 메타(`SCM_MST_SHEET_COLUMNS` 16행) 기반이며, 코드 변경은 CHK 체크박스 셀 타입과 헤더 토글뿐이다.

## 4. 권한(C/R/U/D) 관련 사실
- 메타 행 존재: `TB_FX_GroupMenuAuth` 7행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행, `TB_FX_Favorite` 13행.
- 그룹별 C/R/U/D 값은 Fact Pack에 없어 **확인 필요**.
- 화면 코드에서 권한으로 버튼을 제어하는 사실(btnSave/btnUnSet Enabled 분기 등)은 추출되지 않았다.
- Validation_Check가 `USER_ID`(431~437)와 `DELEGATEE_ID`(445~451)를 따로 검사한다. 위임자/수임자 기준의 중복 검증으로 보이나 규칙은 **확인 필요**.

## 5. 미확정 사항
1. 화면 명칭: Form Text `"Inventory Raw(Small)"` vs Delegate 기능. 메뉴 메타로 확정해야 한다.
2. 4개 SP의 입력 파라미터와 `SSP0020_GET_DELEGATE` 동적 SQL 원문.
3. `BtnSave_Click`의 내부 호출 순서와 Validation_Check 메시지·규칙.
4. `UnSet`의 2개 호출 지점(657/715) 분기 조건.
5. `btnMeasure`, `usrButton1`의 용도(이벤트 미배선).
6. 그리드 컬럼 표시 순서(메타 순번)와 Delegate 시트 편집 가능 컬럼.
7. 권한 그룹별 C/R/U/D 값(TB_FX_GroupMenuAuth 7행 내용).
