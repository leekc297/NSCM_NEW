# 작업 원장 — SYS0002 · 2026-10-26 13:00

> 검사 인스턴스 85건 중 PASS·NA 44건 외 **41건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 13 | 실행 → PASS |
| W7 | 기대값 확정 | 25 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 25 · E2E 13 · 하네스 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 23 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 5 |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 2 | 2 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W5 검사기 연결 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0002-0001 | F2 | SYS0002 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0002 화면 | 판단불가(대상 단위 SCREEN) | 95 (ACT:UserInfo.SaveButton ACT:UserInfo.Sav) |
| WK-SYS0002-0002 | F6 | SYS0002 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0002 화면 | 판단불가(대상 단위 SCREEN) | 95 (ACT:UserInfo.SaveButton ACT:UserInfo.Sav) |
| WK-SYS0002-0003 | G03-WIRE | SYS0002 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0002 화면 | 판단불가(대상 단위 SCREEN) | 4 (ACT:UserInfo..ctor ACT:UserInfo..ctor:10) |

## W6 검증 실행 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0002-0004 | F1 | SYS0002 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0002 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 97 (ACT:UserInfo.DeleteButton ACT:UserInfo.D) |
| WK-SYS0002-0005 | F5 | SYS0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SYS0002 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (ACT:UserInfo.DeleteButton ACT:UserInfo.D) |
| WK-SYS0002-0006 | I1 | SYS0002 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0002 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 7 (ACT:UserInfo.CheckValidation:579:17 ACT:) |
| WK-SYS0002-0007 | D6 | SYS0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SYS0002 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:UserInfo.InsertButton ACT:UserInfo.I) |
| WK-SYS0002-0008 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:UserInfo.SaveData:386:71) |
| WK-SYS0002-0009 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:UserInfo.SaveData:418:90) |
| WK-SYS0002-0010 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:UserInfo.CheckValidation:579:17) |
| WK-SYS0002-0011 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:UserInfo.SpdMain_CellClick:540:45) |
| WK-SYS0002-0012 | E4 | MSG00098 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00098 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:UserInfo.SpdMain_CellClick:466:7 ACT) |
| WK-SYS0002-0013 | A10 | SYS0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0002 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 51 (ACT:UserInfo.Form_Load ACT:UserInfo.Form) |
| WK-SYS0002-0014 | G1 | txtDept / Dept ID (Name) / Dept | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtDept / Dept ID (Name) / Dept · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:UserInfo.FindData ACT:UserInfo.FindD) |
| WK-SYS0002-0015 | G1 | txtSearch / User ID(Name) / Search | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtSearch / User ID(Name) / Search · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:UserInfo.FindData ACT:UserInfo.FindD) |
| WK-SYS0002-0016 | X-REOPEN | SYS0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0002 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:UserInfo.Dispose ACT:UserInfo.Dispos) |

## W7 기대값 확정 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0002-0017 | G1 | UserInfo.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — UserInfo.FindButton: 진입점 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:UserInfo.FindButton:199:1) |
| WK-SYS0002-0018 | G1 | UserInfo.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — UserInfo.FindData: 진입점 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 23 (ACT:UserInfo.FindData:234:1 ACT:UserInfo) |
| WK-SYS0002-0019 | X-ROW | UserInfo.CheckValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.CheckValidation: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 22 (ACT:UserInfo.CheckValidation ACT:UserInf) |
| WK-SYS0002-0020 | X-ROW | UserInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:UserInfo.CreateSpread) |
| WK-SYS0002-0021 | X-ROW | UserInfo.DeleteFavorite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.DeleteFavorite: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:UserInfo.DeleteFavorite ACT:UserInfo) |
| WK-SYS0002-0022 | X-ROW | UserInfo.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:UserInfo.EditButton) |
| WK-SYS0002-0023 | X-ROW | UserInfo.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:UserInfo.FindButton) |
| WK-SYS0002-0024 | X-ROW | UserInfo.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.FindData: 진입점 집계 8검사 — NA:4 · NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:UserInfo.FindData:273:26 ACT:UserInf) |
| WK-SYS0002-0025 | X-ROW | UserInfo.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:UserInfo.Form_Load) |
| WK-SYS0002-0026 | X-ROW | UserInfo.GetSecurityACL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.GetSecurityACL: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:UserInfo.GetSecurityACL) |
| WK-SYS0002-0027 | X-ROW | UserInfo.GetUserAuthenctication | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.GetUserAuthenctication: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:UserInfo.GetUserAuthenctication) |
| WK-SYS0002-0028 | X-ROW | UserInfo.GetUserGuestAuthenctication | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.GetUserGuestAuthenctication: 진입점 집계 4검사 — NOPATH:2 · TODO:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:UserInfo.GetUserGuestAuthenctication) |
| WK-SYS0002-0029 | X-ROW | UserInfo.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.InitControls: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:UserInfo.InitControls ACT:UserInfo.I) |
| WK-SYS0002-0030 | X-ROW | UserInfo.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:UserInfo.InitSpread) |
| WK-SYS0002-0031 | X-ROW | UserInfo.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:UserInfo.InsertButton) |
| WK-SYS0002-0032 | X-ROW | UserInfo.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/GRID_LOCK/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 12 (ACT:UserInfo.InsertRow ACT:UserInfo.Inse) |
| WK-SYS0002-0033 | X-ROW | UserInfo.ResetSearchCondition | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.ResetSearchCondition: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:UserInfo.ResetSearchCondition ACT:Us) |
| WK-SYS0002-0034 | X-ROW | UserInfo.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.SaveData: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:UserInfo.SaveData:329:32 ACT:UserInf) |
| WK-SYS0002-0035 | X-ROW | UserInfo.SaveFavorite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.SaveFavorite: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:UserInfo.SaveFavorite ACT:UserInfo.S) |
| WK-SYS0002-0036 | X-ROW | UserInfo.SaveMenuConnect | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.SaveMenuConnect: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:UserInfo.SaveMenuConnect ACT:UserInf) |
| WK-SYS0002-0037 | X-ROW | UserInfo.SaveNoticeConfirm | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.SaveNoticeConfirm: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:UserInfo.SaveNoticeConfirm ACT:UserI) |
| WK-SYS0002-0038 | X-ROW | UserInfo.SavePersonalSetting | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.SavePersonalSetting: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:UserInfo.SavePersonalSetting ACT:Use) |
| WK-SYS0002-0039 | X-ROW | UserInfo.SaveSearchCondition | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.SaveSearchCondition: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:UserInfo.SaveSearchCondition ACT:Use) |
| WK-SYS0002-0040 | X-ROW | UserInfo.SaveUserConnect | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.SaveUserConnect: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:UserInfo.SaveUserConnect ACT:UserInf) |
| WK-SYS0002-0041 | X-ROW | UserInfo.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — UserInfo.SpdMain_CellClick: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 46 (ACT:UserInfo.SpdMain_CellClick ACT:UserI) |
