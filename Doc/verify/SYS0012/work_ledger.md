# 작업 원장 — SYS0012 · 2026-10-26 13:00

> 검사 인스턴스 70건 중 PASS·NA 21건 외 **49건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 5 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 24 | 실행 → PASS |
| W7 | 기대값 확정 | 20 | 기대 확정 → PASS/FAIL |

- 담당: E2E 24 · 사람 판정 / AS-IS 원문 확인 → 재판정 20 · 하네스 5
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 17 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  | 5 | 2 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| E4 | EDIT |  |  |  |  |  | 5 | 1 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G4 | DESIGN |  |  |  |  | 2 | 3 |  |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 3 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W5 검사기 연결 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0012-0001 | F2 | SYS0012 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0012 화면 | 판단불가(대상 단위 SCREEN) | 47 (ACT:SCM0009_Auth_Approval.SaveData ACT:S) |
| WK-SYS0012-0002 | F6 | SYS0012 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0012 화면 | 판단불가(대상 단위 SCREEN) | 47 (ACT:SCM0009_Auth_Approval.SaveData ACT:S) |
| WK-SYS0012-0003 | G4 | btnApproval | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnApproval | 없음 | 4 (ACT:SCM0009_Auth_Approval.DefineProperty) |
| WK-SYS0012-0004 | G4 | btnReject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnReject | 없음 | 4 (ACT:SCM0009_Auth_Approval.DefineProperty) |
| WK-SYS0012-0005 | G03-WIRE | SYS0012 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0012 화면 | 판단불가(대상 단위 SCREEN) | 7 (ACT:SCM0009_Auth_Approval..ctor ACT:SCM0) |

## W6 검증 실행 (24)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0012-0006 | J2 | SYS0012 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SYS0012 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 22 (ACT:SCM0009_Auth_Approval.BtnApproval_Cl) |
| WK-SYS0012-0007 | C1 | cboApprovalResult / Approval Result  / A | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboApprovalResult / Approval Result  / Approval Re · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0009_Auth_Approval.InitControls:3) |
| WK-SYS0012-0008 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0009_Auth_Approval.InitControls:3) |
| WK-SYS0012-0009 | K4 | SYS0012 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SYS0012 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 22 (ACT:SCM0009_Auth_Approval.BtnApproval_Cl) |
| WK-SYS0012-0010 | F1 | SYS0012 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0012 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 47 (ACT:SCM0009_Auth_Approval.SaveData ACT:S) |
| WK-SYS0012-0011 | G4 | cboApprovalResult / Approval Result  / A | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboApprovalResult / Approval Result  / Approval Re · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCM0009_Auth_Approval.DefineProperty) |
| WK-SYS0012-0012 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCM0009_Auth_Approval.InitControls A) |
| WK-SYS0012-0013 | G4 | drpReqPeriod / Request Date / Req Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpReqPeriod / Request Date / Req Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCM0009_Auth_Approval.InitControls A) |
| WK-SYS0012-0014 | I1 | SYS0012 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0012 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 5 (ACT:SCM0009_Auth_Approval.BtnApproval_Cl) |
| WK-SYS0012-0015 | E4 | MSG00005 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00005 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0009_Auth_Approval.InterlockTotal) |
| WK-SYS0012-0016 | E4 | MSG00020 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00020 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0009_Auth_Approval.SaveData:291:4) |
| WK-SYS0012-0017 | E4 | MSG00021 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00021 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0009_Auth_Approval.InterlockTotal) |
| WK-SYS0012-0018 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0009_Auth_Approval.BtnApproval_Cl) |
| WK-SYS0012-0019 | E4 | drpReqPeriod / Request Date / Req Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpReqPeriod / Request Date / Req Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시 |  | 4 (ACT:SCM0009_Auth_Approval.SetChangedPeri) |
| WK-SYS0012-0020 | A10 | SYS0012 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0012 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 52 (ACT:SCM0009_Auth_Approval.DefineProperty) |
| WK-SYS0012-0021 | G1 | cboApprovalResult / Approval Result  / A | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboApprovalResult / Approval Result  / Approval Re · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0009_Auth_Approval.FindData ACT:S) |
| WK-SYS0012-0022 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0009_Auth_Approval.FindData ACT:S) |
| WK-SYS0012-0023 | G1 | drpReqPeriod / Request Date / Req Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpReqPeriod / Request Date / Req Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:SCM0009_Auth_Approval.FindData ACT:S) |
| WK-SYS0012-0024 | G1 | txtDept / Department / Dept | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtDept / Department / Dept · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0009_Auth_Approval.FindData ACT:S) |
| WK-SYS0012-0025 | G1 | txtUser / User ID(Name) / User | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtUser / User ID(Name) / User · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0009_Auth_Approval.FindData ACT:S) |
| WK-SYS0012-0026 | G6 | cboApprovalResult / Approval Result  / A | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboApprovalResult / Approval Result  / Approval Re · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCM0009_Auth_Approval.DefineProperty) |
| WK-SYS0012-0027 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SCM0009_Auth_Approval.InitControls A) |
| WK-SYS0012-0028 | G6 | drpReqPeriod / Request Date / Req Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpReqPeriod / Request Date / Req Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (ACT:SCM0009_Auth_Approval.InitControls) |
| WK-SYS0012-0029 | X-REOPEN | SYS0012 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0012 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCM0009_Auth_Approval.Dispose ACT:SC) |

## W7 기대값 확정 (20)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0012-0030 | E4 | SCM0009_Auth_Approval.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM0009_Auth_Approval.SetChangedPeriod: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCM0009_Auth_Approval.SetChangedPeri) |
| WK-SYS0012-0031 | G1 | SCM0009_Auth_Approval.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCM0009_Auth_Approval.FindButton: 진입점 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCM0009_Auth_Approval.FindButton:414) |
| WK-SYS0012-0032 | G1 | SCM0009_Auth_Approval.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCM0009_Auth_Approval.FindData: 진입점 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SCM0009_Auth_Approval.FindData:423:1) |
| WK-SYS0012-0033 | X-ROW | SCM0009_Auth_Approval.BtnReject_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.BtnReject_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCM0009_Auth_Approval.BtnReject_Clic) |
| WK-SYS0012-0034 | X-ROW | SCM0009_Auth_Approval.ChangeAllCheckboxe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.ChangeAllCheckboxes: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/FLOW/GRID_SET/LOCAL, 연결된 요 |  | 13 (ACT:SCM0009_Auth_Approval.ChangeAllCheck) |
| WK-SYS0012-0035 | X-ROW | SCM0009_Auth_Approval.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0009_Auth_Approval.CreateSpread) |
| WK-SYS0012-0036 | X-ROW | SCM0009_Auth_Approval.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.DefineProperty: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0009_Auth_Approval.DefineProperty) |
| WK-SYS0012-0037 | X-ROW | SCM0009_Auth_Approval.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0009_Auth_Approval.FindButton) |
| WK-SYS0012-0038 | X-ROW | SCM0009_Auth_Approval.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.FindData: 진입점 집계 11검사 — NOT_RUN:6 · NA:4 · REVIEW:1 |  | 4 (ACT:SCM0009_Auth_Approval.FindData:460:2) |
| WK-SYS0012-0039 | X-ROW | SCM0009_Auth_Approval.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0009_Auth_Approval.Form_Load) |
| WK-SYS0012-0040 | X-ROW | SCM0009_Auth_Approval.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.GetDayRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0009_Auth_Approval.GetDayRange) |
| WK-SYS0012-0041 | X-ROW | SCM0009_Auth_Approval.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.InitControls: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0009_Auth_Approval.InitControls:3) |
| WK-SYS0012-0042 | X-ROW | SCM0009_Auth_Approval.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.InitEvent: 진입점 집계 4검사 — NOPATH:3 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0009_Auth_Approval.InitEvent) |
| WK-SYS0012-0043 | X-ROW | SCM0009_Auth_Approval.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0009_Auth_Approval.InitSpread ACT) |
| WK-SYS0012-0044 | X-ROW | SCM0009_Auth_Approval.InterlockTotalMiss | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.InterlockTotalMiss: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCM0009_Auth_Approval.InterlockTotal) |
| WK-SYS0012-0045 | X-ROW | SCM0009_Auth_Approval.NoCheckedBoxes | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.NoCheckedBoxes: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 6 (ACT:SCM0009_Auth_Approval.NoCheckedBoxes) |
| WK-SYS0012-0046 | X-ROW | SCM0009_Auth_Approval.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.SaveData: 진입점 집계 8검사 — NOT_RUN:4 · NOPATH:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0009_Auth_Approval.SaveData:248:1) |
| WK-SYS0012-0047 | X-ROW | SCM0009_Auth_Approval.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.SetChangedPeriod: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0009_Auth_Approval.SetChangedPeri) |
| WK-SYS0012-0048 | X-ROW | SCM0009_Auth_Approval.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.SpdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCM0009_Auth_Approval.SpdMain_CellCl) |
| WK-SYS0012-0049 | X-ROW | SCM0009_Auth_Approval.SpdMain_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0009_Auth_Approval.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0009_Auth_Approval.SpdMain_CellDo) |
