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
