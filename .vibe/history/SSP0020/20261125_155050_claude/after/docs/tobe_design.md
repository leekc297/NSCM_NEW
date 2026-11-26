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
