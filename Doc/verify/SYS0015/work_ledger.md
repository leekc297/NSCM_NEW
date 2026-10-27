# 작업 원장 — SYS0015 · 2026-10-26 13:00

> 검사 인스턴스 40건 중 PASS·NA 14건 외 **26건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 11 | 실행 → PASS |
| W7 | 기대값 확정 | 12 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 12 · E2E 11 · 하네스 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 8 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  | 1 | 2 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| D1 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 행 값 기반 조건부 잠금 |
| E4 | EDIT |  |  |  |  |  | 2 |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
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
| WK-SYS0015-0001 | F2 | SYS0015 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0015 화면 | 판단불가(대상 단위 SCREEN) | 49 (ACT:ProgramInfo.SaveButton ACT:ProgramIn) |
| WK-SYS0015-0002 | F6 | SYS0015 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0015 화면 | 판단불가(대상 단위 SCREEN) | 49 (ACT:ProgramInfo.SaveButton ACT:ProgramIn) |
| WK-SYS0015-0003 | G03-WIRE | SYS0015 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0015 화면 | 판단불가(대상 단위 SCREEN) | 3 (ACT:ProgramInfo..ctor ACT:ProgramInfo..c) |

## W6 검증 실행 (11)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0015-0004 | F1 | SYS0015 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0015 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 51 (ACT:ProgramInfo.DeleteButton ACT:Program) |
| WK-SYS0015-0005 | F5 | SYS0015 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SYS0015 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (ACT:ProgramInfo.DeleteButton ACT:Program) |
| WK-SYS0015-0006 | I1 | SYS0015 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0015 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 2 (ACT:ProgramInfo.SaveData:253:23 ACT:Prog) |
| WK-SYS0015-0007 | D1 | P | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — P · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:ProgramInfo.EditButton) |
| WK-SYS0015-0008 | D3 | P | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — P · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:ProgramInfo.EditButton) |
| WK-SYS0015-0009 | D6 | SYS0015 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SYS0015 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:ProgramInfo.InsertButton ACT:Program) |
| WK-SYS0015-0010 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:ProgramInfo.SaveData:253:23) |
| WK-SYS0015-0011 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:ProgramInfo.SaveData:285:42) |
| WK-SYS0015-0012 | A10 | SYS0015 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0015 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 12 (ACT:ProgramInfo.Form_Load ACT:ProgramInf) |
| WK-SYS0015-0013 | G1 | txtSearch / Program ID (Name) / Search | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtSearch / Program ID (Name) / Search · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:ProgramInfo.FindData ACT:ProgramInfo) |
| WK-SYS0015-0014 | X-REOPEN | SYS0015 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0015 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:ProgramInfo.Dispose ACT:ProgramInfo.) |

## W7 기대값 확정 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0015-0015 | D1 | ProgramInfo.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — ProgramInfo.EditButton: 진입점 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:ProgramInfo.EditButton:155:1 ACT:Pro) |
| WK-SYS0015-0016 | D3 | ProgramInfo.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — ProgramInfo.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:ProgramInfo.EditButton:155:1 ACT:Pro) |
| WK-SYS0015-0017 | G1 | ProgramInfo.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ProgramInfo.FindButton: 진입점 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:ProgramInfo.FindButton:140:1) |
| WK-SYS0015-0018 | G1 | ProgramInfo.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ProgramInfo.FindData: 진입점 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 9 (ACT:ProgramInfo.FindData:172:1 ACT:Progr) |
| WK-SYS0015-0019 | X-ROW | ProgramInfo.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ProgramInfo.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:ProgramInfo.CreateSpread) |
| WK-SYS0015-0020 | X-ROW | ProgramInfo.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ProgramInfo.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:ProgramInfo.FindButton) |
| WK-SYS0015-0021 | X-ROW | ProgramInfo.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ProgramInfo.FindData: 진입점 집계 7검사 — NA:4 · NOT_RUN:2 · REVIEW:1 |  | 2 (ACT:ProgramInfo.FindData:190:11 ACT:Prog) |
| WK-SYS0015-0022 | X-ROW | ProgramInfo.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ProgramInfo.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:ProgramInfo.Form_Load) |
| WK-SYS0015-0023 | X-ROW | ProgramInfo.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ProgramInfo.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:ProgramInfo.InitSpread ACT:ProgramIn) |
| WK-SYS0015-0024 | X-ROW | ProgramInfo.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ProgramInfo.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:ProgramInfo.InsertButton) |
| WK-SYS0015-0025 | X-ROW | ProgramInfo.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ProgramInfo.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 11 (ACT:ProgramInfo.InsertRow ACT:ProgramInf) |
| WK-SYS0015-0026 | X-ROW | ProgramInfo.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ProgramInfo.SaveData: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:ProgramInfo.SaveData:269:34 ACT:Prog) |
