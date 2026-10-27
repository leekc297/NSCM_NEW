# 작업 원장 — SYS0011 · 2026-10-26 13:00

> 검사 인스턴스 115건 중 PASS·NA 55건 외 **60건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 4 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 24 | 실행 → PASS |
| W7 | 기대값 확정 | 32 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 32 · E2E 24 · 하네스 4
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 30 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 11 | 2 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G4 | DESIGN |  |  |  |  | 3 | 4 |  |  |  | 조회조건 표시·라벨·활성 |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  | 2 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W5 검사기 연결 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0011-0001 | G4 | btnAdd | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnAdd | 없음 | 2 (ACT:SCM0008_Auth_Request.InitEvent ACT:S) |
| WK-SYS0011-0002 | G4 | btnAuthDelete | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnAuthDelete | 없음 | 2 (ACT:SCM0008_Auth_Request.InitEvent ACT:S) |
| WK-SYS0011-0003 | G4 | btnRequest | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequest | 없음 | 2 (ACT:SCM0008_Auth_Request.InitEvent ACT:S) |
| WK-SYS0011-0004 | G03-WIRE | SYS0011 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0011 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SCM0008_Auth_Request..ctor ACT:SCM00) |

## W6 검증 실행 (24)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0011-0005 | J2 | SYS0011 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SYS0011 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 16 (ACT:SCM0008_Auth_Request.BtnAdd_Click AC) |
| WK-SYS0011-0006 | C1 | cboLanguage / Language | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboLanguage / Language · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0008_Auth_Request.InitControls:15) |
| WK-SYS0011-0007 | C1 | cboTimeZone / Time Zone | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboTimeZone / Time Zone · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0008_Auth_Request.InitControls:16) |
| WK-SYS0011-0008 | K4 | SYS0011 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SYS0011 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 16 (ACT:SCM0008_Auth_Request.BtnAdd_Click AC) |
| WK-SYS0011-0009 | G4 | cboLanguage / Language | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboLanguage / Language · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCM0008_Auth_Request.InitControls AC) |
| WK-SYS0011-0010 | G4 | cboTimeZone / Time Zone | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboTimeZone / Time Zone · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SCM0008_Auth_Request.InitControls AC) |
| WK-SYS0011-0011 | G4 | txtCellPhone / CellPhoneNum / Cell Phone | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtCellPhone / CellPhoneNum / Cell Phone · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SCM0008_Auth_Request.RequestAuthList) |
| WK-SYS0011-0012 | G4 | txtEMail / Email / EMail | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtEMail / Email / EMail · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (ACT:SCM0008_Auth_Request.RequestAuthList) |
| WK-SYS0011-0013 | I1 | SYS0011 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0011 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 5 (ACT:SCM0008_Auth_Request.BtnRequest_Clic) |
| WK-SYS0011-0014 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0008_Auth_Request.BtnRequest_Clic) |
| WK-SYS0011-0015 | E4 | MSG00031 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00031 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0008_Auth_Request.DelMyAuthList:4) |
| WK-SYS0011-0016 | E4 | MSG00154 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00154 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0008_Auth_Request.CheckIsNormalUs) |
| WK-SYS0011-0017 | E4 | MSG00158 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00158 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCM0008_Auth_Request.RequestAuthList) |
| WK-SYS0011-0018 | E4 | cboLanguage / Language | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboLanguage / Language · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 4 (ACT:SCM0008_Auth_Request.SetUserinfo ACT) |
| WK-SYS0011-0019 | E4 | cboTimeZone / Time Zone | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboTimeZone / Time Zone · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 4 (ACT:SCM0008_Auth_Request.SetUserinfo ACT) |
| WK-SYS0011-0020 | E4 | txtCellPhone / CellPhoneNum / Cell Phone | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtCellPhone / CellPhoneNum / Cell Phone · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시 |  | 2 (ACT:SCM0008_Auth_Request.SetUserinfo ACT) |
| WK-SYS0011-0021 | E4 | txtDeptName / Department / Dept Name | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtDeptName / Department / Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 2 (ACT:SCM0008_Auth_Request.SetUserinfo ACT) |
| WK-SYS0011-0022 | E4 | txtEMail / Email / EMail | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtEMail / Email / EMail · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 2 (ACT:SCM0008_Auth_Request.SetUserinfo ACT) |
| WK-SYS0011-0023 | E4 | txtUserId / User ID / User Id | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtUserId / User ID / User Id · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) |  | 2 (ACT:SCM0008_Auth_Request.SetUserinfo ACT) |
| WK-SYS0011-0024 | E4 | txtUserName / User Name | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtUserName / User Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 2 (ACT:SCM0008_Auth_Request.SetUserinfo ACT) |
| WK-SYS0011-0025 | A10 | SYS0011 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0011 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 80 (ACT:SCM0008_Auth_Request.DefineProperty ) |
| WK-SYS0011-0026 | G6 | cboLanguage / Language | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboLanguage / Language · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCM0008_Auth_Request.InitControls AC) |
| WK-SYS0011-0027 | G6 | cboTimeZone / Time Zone | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboTimeZone / Time Zone · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCM0008_Auth_Request.InitControls AC) |
| WK-SYS0011-0028 | X-REOPEN | SYS0011 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0011 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 12 (ACT:SCM0008_Auth_Request.AddMyAuthList:7) |

## W7 기대값 확정 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0011-0029 | E4 | SCM0008_Auth_Request.SetSpreadWidth | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM0008_Auth_Request.SetSpreadWidth: 진입점 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCM0008_Auth_Request.SetSpreadWidth:) |
| WK-SYS0011-0030 | E4 | SCM0008_Auth_Request.SetUserinfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM0008_Auth_Request.SetUserinfo: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCM0008_Auth_Request.SetUserinfo:104) |
| WK-SYS0011-0031 | X-ROW | SCM0008_Auth_Request.AddBlankRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.AddBlankRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/DATA_OP/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:SCM0008_Auth_Request.AddBlankRow ACT) |
| WK-SYS0011-0032 | X-ROW | SCM0008_Auth_Request.AddMyAuthList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.AddMyAuthList: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 42 (ACT:SCM0008_Auth_Request.AddMyAuthList A) |
| WK-SYS0011-0033 | X-ROW | SCM0008_Auth_Request.ChangeAllCheckboxes | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.ChangeAllCheckboxes: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/FLOW/GRID_SET/LOCAL, 연결된 요소 |  | 10 (ACT:SCM0008_Auth_Request.ChangeAllCheckb) |
| WK-SYS0011-0034 | X-ROW | SCM0008_Auth_Request.CheckIsNormalUser | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.CheckIsNormalUser: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0008_Auth_Request.CheckIsNormalUs) |
| WK-SYS0011-0035 | X-ROW | SCM0008_Auth_Request.CheckUserinfoInput | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.CheckUserinfoInput: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 9 (ACT:SCM0008_Auth_Request.CheckUserinfoIn) |
| WK-SYS0011-0036 | X-ROW | SCM0008_Auth_Request.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0008_Auth_Request.CreateSpread) |
| WK-SYS0011-0037 | X-ROW | SCM0008_Auth_Request.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCM0008_Auth_Request.DefineProperty ) |
| WK-SYS0011-0038 | X-ROW | SCM0008_Auth_Request.DelMyAuthList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.DelMyAuthList: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 30 (ACT:SCM0008_Auth_Request.DelMyAuthList A) |
| WK-SYS0011-0039 | X-ROW | SCM0008_Auth_Request.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0008_Auth_Request.FindButton) |
| WK-SYS0011-0040 | X-ROW | SCM0008_Auth_Request.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.FindData: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCM0008_Auth_Request.FindData ACT:SC) |
| WK-SYS0011-0041 | X-ROW | SCM0008_Auth_Request.FindData_Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.FindData_Division: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0008_Auth_Request.FindData_Divisi) |
| WK-SYS0011-0042 | X-ROW | SCM0008_Auth_Request.FindData_MyAddedAut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.FindData_MyAddedAuthList: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCM0008_Auth_Request.FindData_MyAdde) |
| WK-SYS0011-0043 | X-ROW | SCM0008_Auth_Request.FindData_Plant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.FindData_Plant: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0008_Auth_Request.FindData_Plant ) |
| WK-SYS0011-0044 | X-ROW | SCM0008_Auth_Request.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0008_Auth_Request.Form_Load) |
| WK-SYS0011-0045 | X-ROW | SCM0008_Auth_Request.GetInsertedUserInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.GetInsertedUserInfo: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCM0008_Auth_Request.GetInsertedUser) |
| WK-SYS0011-0046 | X-ROW | SCM0008_Auth_Request.GetTopAuthorityGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.GetTopAuthorityGroupID: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0008_Auth_Request.GetTopAuthority) |
| WK-SYS0011-0047 | X-ROW | SCM0008_Auth_Request.HasNoDuplicationAut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.HasNoDuplicationAuth: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL/RETURN, 연 |  | 18 (ACT:SCM0008_Auth_Request.HasNoDuplicatio) |
| WK-SYS0011-0048 | X-ROW | SCM0008_Auth_Request.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0008_Auth_Request.InitControls:15) |
| WK-SYS0011-0049 | X-ROW | SCM0008_Auth_Request.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.InitEvent: 진입점 집계 5검사 — NOPATH:4 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0008_Auth_Request.InitEvent) |
| WK-SYS0011-0050 | X-ROW | SCM0008_Auth_Request.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCM0008_Auth_Request.InitSpread ACT:) |
| WK-SYS0011-0051 | X-ROW | SCM0008_Auth_Request.InterlockTotalMiss | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.InterlockTotalMiss: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 17 (ACT:SCM0008_Auth_Request.InterlockTotalM) |
| WK-SYS0011-0052 | X-ROW | SCM0008_Auth_Request.LockUserInfoBoxes | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.LockUserInfoBoxes: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/STATE, 연결된 요소 검사 없음 |  | 3 (ACT:SCM0008_Auth_Request.LockUserInfoBox) |
| WK-SYS0011-0053 | X-ROW | SCM0008_Auth_Request.NoCheckedBoxes | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.NoCheckedBoxes: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/FLOW/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SCM0008_Auth_Request.NoCheckedBoxes ) |
| WK-SYS0011-0054 | X-ROW | SCM0008_Auth_Request.RequestAuthList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.RequestAuthList: 진입점 집계 9검사 — NOT_RUN:8 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 49 (ACT:SCM0008_Auth_Request.RequestAuthList) |
| WK-SYS0011-0055 | X-ROW | SCM0008_Auth_Request.SetSpreadWidth | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.SetSpreadWidth: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0008_Auth_Request.SetSpreadWidth) |
| WK-SYS0011-0056 | X-ROW | SCM0008_Auth_Request.SetUserinfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.SetUserinfo: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCM0008_Auth_Request.SetUserinfo ACT) |
| WK-SYS0011-0057 | X-ROW | SCM0008_Auth_Request.SpdCustomer_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.SpdCustomer_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0008_Auth_Request.SpdCustomer_Cel) |
| WK-SYS0011-0058 | X-ROW | SCM0008_Auth_Request.SpdMyAuthList_CellC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.SpdMyAuthList_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCM0008_Auth_Request.SpdMyAuthList_C) |
| WK-SYS0011-0059 | X-ROW | SCM0008_Auth_Request.SpdMyAuthList_CellD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.SpdMyAuthList_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0008_Auth_Request.SpdMyAuthList_C) |
| WK-SYS0011-0060 | X-ROW | SCM0008_Auth_Request.SpdPlant_CellDouble | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0008_Auth_Request.SpdPlant_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0008_Auth_Request.SpdPlant_CellDo) |
