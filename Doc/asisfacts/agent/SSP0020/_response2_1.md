=== FILE: business_analysis.md ===
# SSP0020 업무분석서 (Delegate)

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0020)과 1차 분석서(analysis.md · web_components.md · tobe_design.md).
> Fact Pack에 없는 내용은 **확인 필요**로 적었다. 업무 규칙은 지어내지 않았다.
> 이 문서 §5의 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트 '근거' 열과 같다.

## 1. 업무 목적·범위

| 항목 | 내용 |
|---|---|
| 화면 ID / 클래스 | SSP0020 / `SSP0020_Delegate` (프로젝트 `GSCM.SSP.Plan.UIL`) |
| Form Text 원문 | `"Inventory Raw(Small)"` (Designer:701). 클래스명(Delegate)과 다르다 → 실제 메뉴명 **확인 필요** |
| 업무 목적 | 저장 대상 테이블 `SSP_MST_DELEGATE`, 그리드 컬럼 `DELEGATEE`(Delegatee)·`DELEGATOR`(Delegator)·`FROM_DATE`·`TO_DATE`·`VALID`로 보아 **Division별 위임(Delegate) 등록·해제 화면**으로 보인다. 다만 업무 정의 문서가 Fact Pack에 없으므로 목적의 공식 정의는 **확인 필요** |
| 범위(사실) | ① 위임 내역 조회(`Delegate` 시트), 위임받은 내역 조회(`Delegated List` 시트) ② 위임 저장(INSERT `SSP_MST_DELEGATE`) ③ 위임 해제(UPDATE `SSP_MST_DELEGATE`) ④ 위임 대상 사용자 확인(`UP_FX_GetSSPUserUseInfoList`) |
| 범위 밖 | 주석 처리된 호출(commented_calls)은 0건이다. 현행 기능에서 제외할 항목은 없다 |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---:|---|---|---|
| S1 | 화면 진입 | `Form_Load` > FindData_Main → `SSP.SSP0020_GET_DELEGATE` (SP `SSP0020_GET_DELEGATE`) | 결과 Tables[0]의 행 수가 0보다 크면 `Delegate` 시트에 바인딩한다(290~291). Tables[1]의 행 수가 0보다 크고 `isReLoad == false`이면 `Delegated List` 시트에 바인딩한다(299~300) |
| S2 | 조회 버튼(FindButton) 클릭 | FindButton > FindData_Main → `SSP.SSP0020_GET_DELEGATE` | S1과 같다. `intActiveSheetIdx == 0`이면 `Delegate`, 아니면 `Delegated List`를 활성 시트로 만든다(312~318) |
| S3 | Division 전체 선택(chkAll) | `chkAll_CheckStateChanged` | 처리 내용은 Fact Pack에 없음 → **확인 필요** |
| S4 | 위임 대상 검색 버튼(btnDelegatee) 클릭 | `BtnDelegatee_Click`. 엔드포인트 없음 | UserPopup(841/843)에서 txtDelegatee.Text = `item.UserName` / `item.UserName_E`. `BtnDelegatee_Click` → UserPopup 호출 관계는 **확인 필요** |
| S5 | 저장(btnSave, `SAVE`) 클릭 | `BtnSave_Click` → `SSP.UP_FX_GetSSPUserUseInfoList`(UserName_Search) / Validation_Check / `SSP.SSP0020_SAVE_DELEGATE`(SaveData) / `SSP.SSP0020_GET_DELEGATE`(FindData_Main) | `SSP_MST_DELEGATE` INSERT, `SCM_SYS_LOG_BATCH` INSERT, 이어서 재조회. 호출 순서는 flow.csv에 없음 → **확인 필요** |
| S6 | 해제(btnUnSet, `UnSet`) 클릭 | `BtnUnSet_Click` > UnSet → `SSP.SSP0020_SAVE_UNSET`(호출 지점 657, 715) / FindData_Main → `SSP.SSP0020_GET_DELEGATE` | `SSP_MST_DELEGATE` UPDATE, `SCM_SYS_LOG_BATCH` INSERT, 이어서 재조회. 두 호출 지점의 분기 조건은 **확인 필요** |
| S7 | 시트 탭 클릭 | `SpdMain_SheetTabClick` | 처리 내용은 **확인 필요** |
| S8 | 그리드 컬럼 헤더 체크박스 클릭 | `SpdMain_CellClick` | 활성 시트 RowCount ≥ 1이고, 클릭한 곳이 컬럼 헤더이며, 그 셀 타입이 CheckBoxCellType이면 헤더 Value를 반전한다(true→false 859 / false→true 863) |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 진입] Form_Load
   └─ FindData_Main ── SSP.SSP0020_GET_DELEGATE ──▶ SSP0020_GET_DELEGATE (동적 SQL)
         ├─ Tables[0].Rows.Count > 0                       → Delegate 시트 바인딩
         ├─ Tables[1].Rows.Count > 0 && isReLoad == false  → Delegated List 시트 바인딩
         └─ intActiveSheetIdx == 0 ? Delegate 활성 : Delegated List 활성

[조회] FindButton → FindData_Main (위와 같음)

[조건 입력]
   clbDivision(+chkAll: chkAll_CheckStateChanged) / txtDelegatee(+btnDelegatee: BtnDelegatee_Click → UserPopup?) / drpPeriod

[저장] btnSave → BtnSave_Click
   ├─ UserName_Search ── SSP.UP_FX_GetSSPUserUseInfoList ──▶ UP_FX_GetSSPUserUseInfoList
   │        └─ Rows[0] UserID(791) / UserName(793)·UserName_E(795) → txtDelegatee.Text
   ├─ Validation_Check (DIVISION_ID·VALID·FROM_DATE·TO_DATE·USER_ID·DELEGATEE_ID 읽기)
   ├─ SaveData ── SSP.SSP0020_SAVE_DELEGATE ──▶ SSP0020_SAVE_DELEGATE
   │        └─ INSERT SSP_MST_DELEGATE / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN → INSERT SCM_SYS_LOG_BATCH
   └─ FindData_Main ── SSP.SSP0020_GET_DELEGATE (재조회)
   ※ 단계 순서와 Validation_Check 호출 여부·위치는 확인 필요

[해제] btnUnSet → BtnUnSet_Click
   ├─ UnSet ── SSP.SSP0020_SAVE_UNSET (657 / 715) ──▶ SSP0020_SAVE_UNSET
   │        └─ UPDATE SSP_MST_DELEGATE / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN → INSERT SCM_SYS_LOG_BATCH
   └─ FindData_Main ── SSP.SSP0020_GET_DELEGATE (재조회)
   ※ 657과 715의 분기 조건은 확인 필요
```

## 4. 업무 규칙 (사실 근거)

| # | 규칙 | 근거 | 상태 |
|---:|---|---|---|
| R1 | Division 선택 목록은 `dtMyDivision`의 `CODE`·`NAME`으로 만든다. `dtMyDivision`은 `UserInfoContext.Current.NowGroupID`를 사용해 얻는다 | meta_reads 52, 137, 160 | 사실. NowGroupID별 목록을 정하는 규칙은 **확인 필요** |
| R2 | 조건 라벨에 필수 표시 `*`가 붙어 있다: `Division*`, `Delegatee*`, `Period*` | props 188, 503, 558 | 라벨 사실. 실제 필수 검증 코드는 **확인 필요** |
| R3 | txtDelegatee는 초기화 때 빈 문자열이다 | props InitControls:168 | 사실 |
| R4 | 저장할 때 `UP_FX_GetSSPUserUseInfoList` 결과 첫 행의 `UserID`를 읽고, `UserName` 또는 `UserName_E`를 txtDelegatee.Text에 넣는다 | meta_reads 791~795, props 793/795 | 사실. 793과 795 중 어느 쪽을 쓰는지 정하는 분기 조건(언어 등)은 **확인 필요** |
| R5 | Validation_Check는 행(row) 단위로 3개 블록에서 값을 읽는다. ① DIVISION_ID·VALID·FROM_DATE·TO_DATE(417~422) ② ①에 USER_ID 추가(431~437) ③ ①에 DELEGATEE_ID 추가(445~451) | meta_reads | 읽는 컬럼은 사실. 판정 규칙(기간 중복 여부 등)과 메시지는 **확인 필요** |
| R6 | 조회 결과는 셋 2개로 사용된다. Tables[0] → `Delegate`, Tables[1] → `Delegated List` | grid_code 290~300 | 사실 |
| R7 | `Delegated List` 시트는 `isReLoad == false`일 때만 바인딩한다 | grid_code 299 | 사실. isReLoad 값을 설정하는 위치는 **확인 필요** |
| R8 | 활성 시트는 `intActiveSheetIdx`로 정한다. 0이면 `Delegate`, 그 외에는 `Delegated List` | grid_code 312~318 | 사실 |
| R9 | 헤더 체크박스 토글은 활성 시트 RowCount ≥ 1일 때만 동작한다 | grid_code 859/863 조건 | 사실 |
| R10 | 날짜·버킷 규칙: drpPeriod(From~To)가 FROM_DATE/TO_DATE에 어떻게 매핑되는지, 날짜 형식은 무엇인지 | - | Fact Pack에 없음 → **확인 필요** |
| R11 | SP 내부 분기 조건(`SSP0020_GET_DELEGATE` 동적 SQL, SAVE·UNSET의 `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL` 배열 분해) | endpoints objects | 참조 객체만 사실. SP 원문과 파라미터는 **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | SP | 호출 메서드(줄) | 진입 핸들러 | 읽기 | 쓰기 | EXEC 전이 |
|---|---|---|---|---|---|---|
| `SSP.SSP0020_GET_DELEGATE` | `SSP0020_GET_DELEGATE` | FindData_Main(268) | `Form_Load`, FindButton, `BtnSave_Click`, `BtnUnSet_Click` | 동적 SQL(DYNAMIC@SSP0020_GET_DELEGATE). 대상 테이블 **확인 필요** | 없음(사실 기준) | - |
| `SSP.SSP0020_SAVE_DELEGATE` | `SSP0020_SAVE_DELEGATE` | SaveData(507) | `BtnSave_Click` | REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL | INSERT:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| `SSP.SSP0020_SAVE_UNSET` | `SSP0020_SAVE_UNSET` | UnSet(657), UnSet(715) | `BtnUnSet_Click` | REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL | UPDATE:SSP_MST_DELEGATE, INSERT:SCM_SYS_LOG_BATCH | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| `SSP.UP_FX_GetSSPUserUseInfoList` | `UP_FX_GetSSPUserUseInfoList` | UserName_Search(781) | `BtnSave_Click` | SELECT:SCM_MST_SSO_DEPT_INFO, TB_FX_GROUPINFO, TB_FX_USERGROUPINFO, TB_FX_USER | 없음 | - |

- 4개 SP 모두 상태는 MATCH다. 입력 파라미터는 Fact Pack에 없음 → **확인 필요**.
- `BtnSave_Click`:352의 `SaveData`를 메타 분석기는 `PersonalSettingPopup.SaveData`로 해석했다. 엔드포인트 추출은 이 화면의 SaveData(507, `SSP.SSP0020_SAVE_DELEGATE`)를 가리킨다. 이름이 같아서 생긴 오해석으로 보이며 **확인 필요**.

## 6. Division·권한별 변형

| 구분 | 사실 |
|---|---|
| 그리드 컬럼 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 모두 같다. `Delegate` 8컬럼, `Delegated List` 7컬럼(CHK 숨김) |
| 코드 분기 | division 변수를 비교하는 분기는 없다(판단불가 0건) |
| Division 선택 목록 | `NowGroupID` 기반 `dtMyDivision`. 사용자 그룹에 따라 목록이 달라질 수 있으나 구체 규칙은 **확인 필요** |
| 권한 | `TB_FX_GroupMenuAuth` 7행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행, `TB_FX_Favorite` 13행이 있다. 그룹별 C/R/U/D 값과 코드상 버튼 권한 제어는 추출되지 않음 → **확인 필요** |

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 인터페이스(I/F) 사실은 없다.
- 참고(내부 객체): 저장·해제 SP가 `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`을 EXEC해 `SCM_SYS_LOG_BATCH`에 로그를 남긴다. `UP_FX_GetSSPUserUseInfoList`는 `SCM_MST_SSO_DEPT_INFO`를 SELECT한다. 이 두 객체가 외부 연계에 해당하는지는 **확인 필요**.

## 8. 미확정·확인 필요

1. 화면 명칭: Form Text `"Inventory Raw(Small)"`와 Delegate 기능이 맞지 않는다 → TB_FX_MenuItemInfo / TB_FX_ProgramInfo로 확정해야 한다.
2. 4개 SP의 입력 파라미터와 `SSP0020_GET_DELEGATE` 동적 SQL 원문.
3. `BtnSave_Click`의 내부 호출 순서(UserName_Search / Validation_Check / SaveData / FindData_Main).
4. Validation_Check의 판정 규칙과 메시지.
5. `UnSet`에서 `SSP.SSP0020_SAVE_UNSET`을 호출하는 두 지점(657/715)의 분기 조건.
6. `chkAll_CheckStateChanged`, `SpdMain_SheetTabClick`, `BtnDelegatee_Click`의 처리 내용.
7. `isReLoad`, `intActiveSheetIdx`를 설정하는 위치.
8. drpPeriod ↔ FROM_DATE/TO_DATE 매핑과 날짜 형식.
9. 권한 그룹별 C/R/U/D 값(TB_FX_GroupMenuAuth 7행).
10. TB_FX_SearchCondition 2행 → 조회조건 저장 기능이 있는지.
11. UP_FX_GetSSPUserUseInfoList 결과가 0행일 때 동작(코드가 Rows[0]에 접근함).

=== FILE: screen_design.md ===
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

=== FILE: unit_test.md ===
# SSP0020 단위테스트 (Delegate)

> 근거: Fact Pack(SSP0020). 절차 열의 컨트롤명은 화면설계서 §3과 같고, 근거 열의 엔드포인트·SP·핸들러·시트 이름은 업무분석서 §5·화면설계서 §5와 같다.
> 기대결과 중 Fact Pack에 사실이 없는 부분은 "확인 필요"로 적었다. 이 부분은 As-Is 실행 결과로 확정한 뒤 테스트에 반영한다.
> 주석 처리된 호출(commented_calls)은 0건이라 제외할 케이스가 없다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0020-001 | 초기화 | 로그인 사용자의 NowGroupID 존재 | 화면 SSP0020 열기 | - | `Form_Load`에서 FindData_Main이 `SSP.SSP0020_GET_DELEGATE`를 1회 호출. spdMain에 시트 `Delegate`, `Delegated List` 생성 | `Form_Load`, `SSP.SSP0020_GET_DELEGATE`, `SSP0020_GET_DELEGATE`, `Delegate`, `Delegated List` |
| TC-SSP0020-002 | 초기화 | 위와 같음 | 화면 열기 후 clbDivision 목록과 txtDelegatee 값 확인 | - | clbDivision 항목 = dtMyDivision의 CODE/NAME. txtDelegatee = "" | InitControls:160/168, `Form_Load`(InitControls 호출 시점은 확인 필요) |
| TC-SSP0020-003 | 초기화 | - | 화면 열기 후 조건 라벨 확인 | - | usrLabel1 `Division*`, txtDelegatee 라벨 `Delegatee*`, drpPeriod 라벨 `Period*`, chkAll `All`, btnSave `SAVE`, btnUnSet `UnSet` | props.csv Text, `Form_Load` |
| TC-SSP0020-004 | 조회 | 위임 데이터 존재(Tables[0]>0) | FindButton 클릭 | clbDivision 선택값, txtDelegatee, drpPeriod (조회 파라미터인지 확인 필요) | `SSP.SSP0020_GET_DELEGATE` 호출. Tables[0] 결과가 `Delegate` 시트에 바인딩됨(290~291) | `SSP.SSP0020_GET_DELEGATE`, `SSP0020_GET_DELEGATE`, `Delegate` |
| TC-SSP0020-005 | 조회 | Tables[1]>0, isReLoad == false | FindButton 클릭 | 위와 같음 | Tables[1] 결과가 `Delegated List` 시트에 바인딩됨(299~300) | `SSP.SSP0020_GET_DELEGATE`, `Delegated List` |
| TC-SSP0020-006 | 조회 | Tables[1]>0, isReLoad == true(설정 위치 확인 필요) | FindButton 클릭 | 위와 같음 | `Delegated List` 바인딩 블록(299~300)이 실행되지 않음 | `SSP.SSP0020_GET_DELEGATE`, `Delegated List` |
| TC-SSP0020-007 | 조회 | intActiveSheetIdx == 0 | FindButton 클릭 | - | `Delegate`가 활성 시트(312~313) | `SSP.SSP0020_GET_DELEGATE`, `Delegate` |
| TC-SSP0020-008 | 조회 | intActiveSheetIdx != 0 | `Delegated List` 탭 선택 후 FindButton 클릭 | - | `Delegated List`가 활성 시트(317~318) | `SSP.SSP0020_GET_DELEGATE`, `Delegated List`, `SpdMain_SheetTabClick`(intActiveSheetIdx 설정 여부 확인 필요) |
| TC-SSP0020-009 | 조회(빈 결과) | Tables[0], Tables[1] 모두 0행 | FindButton 클릭 | 결과 없는 조건 | 290~291, 299~300 바인딩 블록이 실행되지 않음. 화면 표시(빈 그리드·메시지)는 확인 필요 | `SSP.SSP0020_GET_DELEGATE`, `SSP0020_GET_DELEGATE`, `Delegate`, `Delegated List` |
| TC-SSP0020-010 | 조회(오류) | SP 실행 오류 유도(예: DB 객체 권한 제거) | FindButton 클릭 | - | 오류 처리 방식(메시지·그리드 상태)은 Fact Pack에 없음 → As-Is 실행으로 확정 | `SSP.SSP0020_GET_DELEGATE`, `SSP0020_GET_DELEGATE` |
| TC-SSP0020-011 | 저장 | 대상 사용자 존재 | clbDivision 선택 → txtDelegatee 입력 → drpPeriod 입력 → btnSave 클릭 | Division, 사용자명, From~To | `SSP.UP_FX_GetSSPUserUseInfoList` 호출. Rows[0]의 UserID 사용, txtDelegatee.Text에 UserName 또는 UserName_E 설정(793/795, 분기 조건 확인 필요) | `BtnSave_Click`, `SSP.UP_FX_GetSSPUserUseInfoList`, `UP_FX_GetSSPUserUseInfoList` |
| TC-SSP0020-012 | 저장(빈 결과) | 존재하지 않는 사용자 | txtDelegatee에 없는 사용자 입력 → btnSave 클릭 | 존재하지 않는 사용자명 | `SSP.UP_FX_GetSSPUserUseInfoList` 결과 0행. 코드가 Rows[0]에 접근하므로 이때의 처리(메시지·예외)는 확인 필요 | `BtnSave_Click`, `SSP.UP_FX_GetSSPUserUseInfoList`, `UP_FX_GetSSPUserUseInfoList` |
| TC-SSP0020-013 | 저장 | 검증 통과 조건(규칙 확인 필요) | 정상 입력 후 btnSave 클릭 | Division, Delegatee, Period | `SSP.SSP0020_SAVE_DELEGATE` 호출 → SSP_MST_DELEGATE INSERT, SCM_SYS_LOG_BATCH INSERT(PR_SCM_SYS_LOG_BATCH_CALL_TRAN). 이어서 `SSP.SSP0020_GET_DELEGATE` 재조회 → `Delegate` 시트에 신규 행 반영 | `BtnSave_Click`, `SSP.SSP0020_SAVE_DELEGATE`, `SSP0020_SAVE_DELEGATE`, `SSP.SSP0020_GET_DELEGATE`, `Delegate` |
| TC-SSP0020-014 | 저장(검증) | 기존 위임 행 존재 | 기존 행과 같은 DIVISION_ID·기간으로 btnSave 클릭 | 기존 행과 겹치는 Division/From~To | Validation_Check가 DIVISION_ID·VALID·FROM_DATE·TO_DATE·USER_ID·DELEGATEE_ID를 읽음(417~451). 차단 여부와 메시지는 확인 필요 | `BtnSave_Click`, Validation_Check, `SSP.SSP0020_SAVE_DELEGATE` |
| TC-SSP0020-015 | 저장(오류) | SP 오류 유도 | btnSave 클릭 | - | `SSP.SSP0020_SAVE_DELEGATE` 오류 시 롤백·메시지 처리 확인 필요. SSP_MST_DELEGATE 행 수가 변하지 않았는지 대조 | `BtnSave_Click`, `SSP.SSP0020_SAVE_DELEGATE`, `SSP0020_SAVE_DELEGATE` |
| TC-SSP0020-016 | 저장(해제) | `Delegate` 시트에 위임 행 존재 | `Delegate` 시트에서 CHK 선택 → btnUnSet 클릭 | 선택 행 | `SSP.SSP0020_SAVE_UNSET` 호출(UnSet:657) → SSP_MST_DELEGATE UPDATE, SCM_SYS_LOG_BATCH INSERT. 이어서 `SSP.SSP0020_GET_DELEGATE` 재조회 | `BtnUnSet_Click`, `SSP.SSP0020_SAVE_UNSET`, `SSP0020_SAVE_UNSET`, `SSP.SSP0020_GET_DELEGATE`, `Delegate` |
| TC-SSP0020-017 | 저장(해제) | UnSet:715 경로 조건(확인 필요) 충족 | btnUnSet 클릭 | 715 분기에 해당하는 입력(확인 필요) | `SSP.SSP0020_SAVE_UNSET`이 715 지점에서 호출됨. 657 경로와의 차이는 확인 필요 | `BtnUnSet_Click`, `SSP.SSP0020_SAVE_UNSET`, `SSP0020_SAVE_UNSET` |
| TC-SSP0020-018 | 저장(해제·빈 선택) | 선택 행 없음 | CHK 미선택 상태로 btnUnSet 클릭 | - | SP 호출 여부와 메시지는 확인 필요 | `BtnUnSet_Click`, `SSP.SSP0020_SAVE_UNSET` |
| TC-SSP0020-019 | 저장(해제·오류) | SP 오류 유도 | btnUnSet 클릭 | 선택 행 | 오류 처리 확인 필요. SSP_MST_DELEGATE 값이 변하지 않았는지 대조 | `BtnUnSet_Click`, `SSP.SSP0020_SAVE_UNSET`, `SSP0020_SAVE_UNSET` |
| TC-SSP0020-020 | 이벤트 | clbDivision 항목 2개 이상 | chkAll 체크 → 해제 | - | `chkAll_CheckStateChanged` 실행. clbDivision 전체 선택/해제 여부는 확인 필요 | `chkAll_CheckStateChanged` |
| TC-SSP0020-021 | 이벤트 | - | btnDelegatee 클릭 → 팝업에서 사용자 선택 | 사용자 1명 | `BtnDelegatee_Click` 실행. 엔드포인트 호출 없음. 팝업 선택 시 txtDelegatee = UserName / UserName_E(841/843, UserPopup 연결 확인 필요) | `BtnDelegatee_Click` |
| TC-SSP0020-022 | 이벤트 | 두 시트 모두 데이터 존재 | spdMain에서 `Delegate` ↔ `Delegated List` 탭 클릭 | - | `SpdMain_SheetTabClick` 실행. 처리 내용(intActiveSheetIdx 갱신 등)은 확인 필요 | `SpdMain_SheetTabClick`, `Delegate`, `Delegated List` |
| TC-SSP0020-023 | 그리드 | 활성 시트 RowCount ≥ 1, 헤더 CHK Value = true | spdMain 컬럼 헤더 CHK 클릭 | - | 헤더 Value = false(859) | `SpdMain_CellClick` |
| TC-SSP0020-024 | 그리드 | 활성 시트 RowCount ≥ 1, 헤더 CHK Value = false | spdMain 컬럼 헤더 CHK 클릭 | - | 헤더 Value = true(863) | `SpdMain_CellClick` |
| TC-SSP0020-025 | 그리드 | 활성 시트 RowCount = 0 | spdMain 컬럼 헤더 CHK 클릭 | - | 토글하지 않음(조건 RowCount ≥ 1 불충족) | `SpdMain_CellClick` |
| TC-SSP0020-026 | 그리드 | 조회 완료 | `Delegate` 시트 컬럼 확인 | - | 표시 8컬럼: CHK(ALL), DIVISION_ID(Div), DELEGATEE(Delegatee), FROM_DATE(From), TO_DATE(To), VALID(Valid), LAST_UPDATED_BY(Last Updated By), LAST_UPDATE_DATE(Last Update Date). 순서는 메타 순번으로 확인 | `Delegate`, SetSheetHeaderColumn(InitSpread:199), `SSP.SSP0020_GET_DELEGATE` |
| TC-SSP0020-027 | 그리드 | 조회 완료 | `Delegated List` 시트 컬럼 확인 | - | 표시 7컬럼: DIVISION_ID, DELEGATOR(Delegator), FROM_DATE, TO_DATE, VALID, LAST_UPDATED_BY, LAST_UPDATE_DATE. CHK(ALL)는 숨김 | `Delegated List`, SetSheetHeaderColumn(InitSpread:207) |
| TC-SSP0020-028 | 그리드 | 조회 완료 | CHK 셀 타입 확인 | - | CHK: CellType=chk, Value=false, Border=bevelbrdr(InitSpread 216~218). 적용 시트는 확인 필요 | `Delegated List`(추정), `Delegate` |
| TC-SSP0020-029 | division | Division 40 사용자 | 화면 열기 → 두 시트 컬럼 수 확인 | Division 40 | `Delegate` 8 / `Delegated List` 7 | `Delegate`, `Delegated List`, grid_effective(40) |
| TC-SSP0020-030 | division | Division 81 사용자 | 위와 같음 | Division 81 | `Delegate` 8 / `Delegated List` 7 (40과 같음) | `Delegate`, `Delegated List`, grid_effective(81) |
| TC-SSP0020-031 | division | Division EE 사용자 | 위와 같음 | Division EE | `Delegate` 8 / `Delegated List` 7. 14개 division 모두 같음(division 변형 없음) | `Delegate`, `Delegated List`, grid_effective(EE) |
| TC-SSP0020-032 | 권한 | TB_FX_GroupMenuAuth 7행 중 그룹별 계정 | 그룹별 계정으로 화면 열기 → btnSave·btnUnSet 사용 | 그룹별 계정 | 그룹별 C/R/U/D 값이 Fact Pack에 없어 기대결과는 메타 확인 후 확정. 코드상 버튼 권한 제어는 추출되지 않음 | `Form_Load`, `BtnSave_Click`, `BtnUnSet_Click`, TB_FX_GroupMenuAuth |

## 커버리지 대조

| 항목 | 대상 | TC |
|---|---|---|
| 핸들러 | `chkAll_CheckStateChanged` | 020 |
| | `Form_Load` | 001, 002, 003, 032 |
| | `BtnDelegatee_Click` | 021 |
| | `BtnSave_Click` | 011~015, 032 |
| | `BtnUnSet_Click` | 016~019, 032 |
| | `SpdMain_SheetTabClick` | 008, 022 |
| | `SpdMain_CellClick` | 023~025 |
| 엔드포인트 | `SSP.SSP0020_GET_DELEGATE` | 001, 004~010, 013, 016, 026 |
| | `SSP.SSP0020_SAVE_DELEGATE` | 013~015 |
| | `SSP.SSP0020_SAVE_UNSET` | 016~019 |
| | `SSP.UP_FX_GetSSPUserUseInfoList` | 011, 012 |
| 시트 | `Delegate` | 001, 004, 007, 009, 013, 016, 022, 026, 028~031 |
| | `Delegated List` | 001, 005, 006, 008, 009, 022, 027~031 |
| 빈 결과 / 오류 | - | 009, 012, 018 / 010, 015, 019 |
