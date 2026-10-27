# 작업 원장 — SYS0016 · 2026-10-26 13:00

> 검사 인스턴스 50건 중 PASS·NA 24건 외 **26건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 3 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 8 | 실행 → PASS |
| W7 | 기대값 확정 | 15 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 15 · E2E 8 · 하네스 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 15 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
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
| WK-SYS0016-0001 | F2 | SYS0016 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0016 화면 | 판단불가(대상 단위 SCREEN) | 78 (ACT:BaseCode.SaveButton ACT:BaseCode.Sav) |
| WK-SYS0016-0002 | F6 | SYS0016 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0016 화면 | 판단불가(대상 단위 SCREEN) | 78 (ACT:BaseCode.SaveButton ACT:BaseCode.Sav) |
| WK-SYS0016-0003 | G03-WIRE | SYS0016 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0016 화면 | 판단불가(대상 단위 SCREEN) | 8 (ACT:BaseCode..ctor ACT:BaseCode..ctor:82) |

## W6 검증 실행 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0016-0004 | F1 | SYS0016 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0016 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 87 (ACT:BaseCode.DeleteButton ACT:BaseCode.D) |
| WK-SYS0016-0005 | F5 | SYS0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SYS0016 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 9 (ACT:BaseCode.DeleteButton ACT:BaseCode.D) |
| WK-SYS0016-0006 | I1 | SYS0016 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0016 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 3 (ACT:BaseCode.SaveData:356:27 ACT:BaseCod) |
| WK-SYS0016-0007 | D6 | SYS0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SYS0016 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:BaseCode.InsertButton ACT:BaseCode.I) |
| WK-SYS0016-0008 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:BaseCode.SaveData:356:27 ACT:BaseCod) |
| WK-SYS0016-0009 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:BaseCode.SaveData:423:64) |
| WK-SYS0016-0010 | A10 | SYS0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0016 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 47 (ACT:BaseCode.DefineProperty ACT:BaseCode) |
| WK-SYS0016-0011 | X-REOPEN | SYS0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0016 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:BaseCode.Dispose ACT:BaseCode.Dispos) |

## W7 기대값 확정 (15)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0016-0012 | X-ROW | BaseCode.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:BaseCode.CreateSpread) |
| WK-SYS0016-0013 | X-ROW | BaseCode.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:BaseCode.DefineProperty) |
| WK-SYS0016-0014 | X-ROW | BaseCode.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:BaseCode.EditButton) |
| WK-SYS0016-0015 | X-ROW | BaseCode.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:BaseCode.FindButton) |
| WK-SYS0016-0016 | X-ROW | BaseCode.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.FindData: 진입점 집계 6검사 — NOPATH:3 · NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:BaseCode.FindData ACT:BaseCode.FindD) |
| WK-SYS0016-0017 | X-ROW | BaseCode.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:BaseCode.Form_Load) |
| WK-SYS0016-0018 | X-ROW | BaseCode.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:BaseCode.InitSpread) |
| WK-SYS0016-0019 | X-ROW | BaseCode.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:BaseCode.InsertButton) |
| WK-SYS0016-0020 | X-ROW | BaseCode.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/GRID_SET/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 91 (ACT:BaseCode.InsertRow ACT:BaseCode.Inse) |
| WK-SYS0016-0021 | X-ROW | BaseCode.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.SaveData: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:BaseCode.SaveData:406:56 ACT:BaseCod) |
| WK-SYS0016-0022 | X-ROW | BaseCode.SpdLevel1_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.SpdLevel1_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:BaseCode.SpdLevel1_CellDoubleClick) |
| WK-SYS0016-0023 | X-ROW | BaseCode.SpdLevel1_LeaveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.SpdLevel1_LeaveCell: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:BaseCode.SpdLevel1_LeaveCell ACT:Bas) |
| WK-SYS0016-0024 | X-ROW | BaseCode.SpdLevel2_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.SpdLevel2_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:BaseCode.SpdLevel2_CellDoubleClick) |
| WK-SYS0016-0025 | X-ROW | BaseCode.SpdLevel2_LeaveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.SpdLevel2_LeaveCell: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:BaseCode.SpdLevel2_LeaveCell ACT:Bas) |
| WK-SYS0016-0026 | X-ROW | BaseCode.SpdLevel3_LeaveCell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — BaseCode.SpdLevel3_LeaveCell: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:BaseCode.SpdLevel3_LeaveCell ACT:Bas) |
