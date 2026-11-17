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
