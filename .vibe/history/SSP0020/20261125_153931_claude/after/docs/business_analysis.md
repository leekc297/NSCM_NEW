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
