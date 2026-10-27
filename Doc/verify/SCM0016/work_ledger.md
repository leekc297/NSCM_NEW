# 작업 원장 — SCM0016 · 2026-10-26 12:51

> 검사 인스턴스 202건 중 PASS·NA 22건 외 **180건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 4 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 101 | 실행 → PASS |
| W7 | 기대값 확정 | 75 | 기대 확정 → PASS/FAIL |

- 담당: E2E 101 · 사람 판정 / AS-IS 원문 확인 → 재판정 75 · 하네스 4
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| H2 | DESIGN |  |  |  |  |  | 20 | 7 |  |  | 배경·글자색 규칙 |
| A5 | DESIGN |  |  |  |  |  | 20 | 6 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 20 | 6 |  |  | 라벨 명칭 |
| D5 | EDIT |  |  |  |  |  | 20 | 1 |  |  | 셀 에디터 유형 |
| X-LOC | GEN |  |  |  |  |  |  | 20 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 18 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 7 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 1 | 4 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| F4 | DB |  |  |  |  |  | 3 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 3 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G5 | POPUP |  |  |  |  | 1 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 |  | 1 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 1 | 1 |  |  | 팝업 선택값 반영 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C1 | CASCADE |  |  |  |  |  | 1 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| G4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| E4 | EDIT |  |  |  |  |  | 1 |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| G6 | GEN |  |  |  |  |  | 1 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| H10 | DESIGN |  |  |  |  |  |  | 1 |  |  | 메시지 표준(방식·코드 단일화) |

## W5 검사기 연결 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0016-0001 | F2 | SCM0016 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCM0016 화면 | 판단불가(대상 단위 SCREEN) | 1 (E4) |
| WK-SCM0016-0002 | G03-WIRE | SCM0016 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCM0016 화면 | 판단불가(대상 단위 SCREEN) | 5 (ACT:SCM0016_BatchLog..ctor ACT:SCM0016_B) |
| WK-SCM0016-0003 | G5 | JOB_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL JOB_ID | 있음(SHEET_COLUMNS) | 1 (E2) |
| WK-SCM0016-0004 | H6 | JOB_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL JOB_ID | 있음(SHEET_COLUMNS) | 1 (E2) |

## W6 검증 실행 (101)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0016-0005 | J2 | SCM0016 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCM0016 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 6 (E1 E2 E3 E4 R4 MSG00109 (EditButton 편집차단) |
| WK-SCM0016-0006 | C1 | clbRunStatus / Run Status | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbRunStatus / Run Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCM0016_BatchLog.InitControls:133:5) |
| WK-SCM0016-0007 | G3 | SCM0016 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCM0016 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 1 (usrConditionPanel1 (HidePanel)) |
| WK-SCM0016-0008 | K-SA | SCM0016 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCM0016 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (usrConditionPanel1 (HidePanel)) |
| WK-SCM0016-0009 | F1 | SCM0016 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCM0016 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 1 (E4) |
| WK-SCM0016-0010 | F5 | SCM0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCM0016 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (E4) |
| WK-SCM0016-0011 | F4 | PKG_SCM0016.P_SCM0016_GET_BATCH_LOG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0016.P_SCM0016_GET_BATCH_LOG · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 21 (Main ACT:SCM0016_BatchLog.FindButton ACT) |
| WK-SCM0016-0012 | F4 | PKG_SCM0016.P_SCM0016_GET_BATCH_LOG_HIST | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0016.P_SCM0016_GET_BATCH_LOG_HIST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 16 (Hist ACT:SCM0016_BatchLog.FindData_Hist ) |
| WK-SCM0016-0013 | F4 | PKG_SCM0016.P_SCM0016_GET_BATCH_STEP_INF | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0016.P_SCM0016_GET_BATCH_STEP_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 16 (Step ACT:SCM0016_BatchLog.FindData_Step ) |
| WK-SCM0016-0014 | A5 | EXEC_COMMAND | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EXEC_COMMAND · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0015 | A5 | JOB_DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — JOB_DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0016 | A5 | JOB_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — JOB_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 7 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0017 | A5 | JOB_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — JOB_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0018 | A5 | NEXT_RUN_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEXT_RUN_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0019 | A5 | ON_FAILURE_ACTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ON_FAILURE_ACTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0020 | A5 | ON_SUCCESS_ACTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ON_SUCCESS_ACTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0021 | A5 | RETRY_ATTEMPTS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — RETRY_ATTEMPTS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0022 | A5 | RETRY_INTERVAL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — RETRY_INTERVAL · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0023 | A5 | RUN_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — RUN_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0024 | A5 | RUN_DURATION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — RUN_DURATION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0025 | A5 | RUN_STATUS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — RUN_STATUS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0026 | A5 | RUN_STATUS_MESSAGE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — RUN_STATUS_MESSAGE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0027 | A5 | RUN_STATUS_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — RUN_STATUS_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0028 | A5 | SCHEDULE_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SCHEDULE_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0029 | A5 | SCHEDULE_UID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SCHEDULE_UID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0030 | A5 | STEP_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — STEP_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0031 | A5 | STEP_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — STEP_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0032 | A5 | STEP_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — STEP_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0033 | A5 | STEP_UID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — STEP_UID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0034 | G4 | clbRunStatus / Run Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbRunStatus / Run Status · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCM0016_BatchLog.InitControls ACT:SC) |
| WK-SCM0016-0035 | H2 | EXEC_COMMAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EXEC_COMMAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0036 | H2 | JOB_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — JOB_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0037 | H2 | JOB_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — JOB_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0038 | H2 | JOB_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — JOB_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0039 | H2 | NEXT_RUN_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEXT_RUN_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0040 | H2 | ON_FAILURE_ACTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ON_FAILURE_ACTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0041 | H2 | ON_SUCCESS_ACTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ON_SUCCESS_ACTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0042 | H2 | RETRY_ATTEMPTS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — RETRY_ATTEMPTS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0043 | H2 | RETRY_INTERVAL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — RETRY_INTERVAL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0044 | H2 | RUN_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — RUN_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0045 | H2 | RUN_DURATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — RUN_DURATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0046 | H2 | RUN_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — RUN_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0047 | H2 | RUN_STATUS_MESSAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — RUN_STATUS_MESSAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0048 | H2 | RUN_STATUS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — RUN_STATUS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0049 | H2 | SCHEDULE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SCHEDULE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0050 | H2 | SCHEDULE_UID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SCHEDULE_UID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0051 | H2 | STEP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — STEP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0052 | H2 | STEP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — STEP_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0053 | H2 | STEP_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — STEP_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0054 | H2 | STEP_UID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — STEP_UID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0055 | H5 | EXEC_COMMAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EXEC_COMMAND · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0056 | H5 | JOB_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — JOB_DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0057 | H5 | JOB_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — JOB_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 7 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0058 | H5 | JOB_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — JOB_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0059 | H5 | NEXT_RUN_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEXT_RUN_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0060 | H5 | ON_FAILURE_ACTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ON_FAILURE_ACTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0061 | H5 | ON_SUCCESS_ACTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ON_SUCCESS_ACTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0062 | H5 | RETRY_ATTEMPTS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — RETRY_ATTEMPTS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0063 | H5 | RETRY_INTERVAL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — RETRY_INTERVAL · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0064 | H5 | RUN_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — RUN_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0065 | H5 | RUN_DURATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — RUN_DURATION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0066 | H5 | RUN_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — RUN_STATUS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0067 | H5 | RUN_STATUS_MESSAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — RUN_STATUS_MESSAGE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0068 | H5 | RUN_STATUS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — RUN_STATUS_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0069 | H5 | SCHEDULE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SCHEDULE_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0070 | H5 | SCHEDULE_UID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SCHEDULE_UID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0071 | H5 | STEP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — STEP_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0072 | H5 | STEP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — STEP_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0073 | H5 | STEP_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — STEP_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0074 | H5 | STEP_UID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — STEP_UID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0075 | I1 | SCM0016 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCM0016 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 3 (E4 MSG00109 (EditButton 편집차단) ACT:SCM001) |
| WK-SCM0016-0076 | D5 | EXEC_COMMAND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — EXEC_COMMAND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0077 | D5 | JOB_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — JOB_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0078 | D5 | JOB_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — JOB_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 7 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0079 | D5 | JOB_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — JOB_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0080 | D5 | NEXT_RUN_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEXT_RUN_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0081 | D5 | ON_FAILURE_ACTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ON_FAILURE_ACTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0082 | D5 | ON_SUCCESS_ACTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ON_SUCCESS_ACTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0083 | D5 | RETRY_ATTEMPTS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — RETRY_ATTEMPTS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0084 | D5 | RETRY_INTERVAL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — RETRY_INTERVAL · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0085 | D5 | RUN_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — RUN_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0086 | D5 | RUN_DURATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — RUN_DURATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0087 | D5 | RUN_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — RUN_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0088 | D5 | RUN_STATUS_MESSAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — RUN_STATUS_MESSAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0089 | D5 | RUN_STATUS_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — RUN_STATUS_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0090 | D5 | SCHEDULE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCHEDULE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0091 | D5 | SCHEDULE_UID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCHEDULE_UID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0092 | D5 | STEP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — STEP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0093 | D5 | STEP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — STEP_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0094 | D5 | STEP_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — STEP_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0095 | D5 | STEP_UID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — STEP_UID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitSpread ACT:SCM0) |
| WK-SCM0016-0096 | D6 | SCM0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCM0016 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (E4) |
| WK-SCM0016-0097 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (E4 MSG00109 (EditButton 편집차단) ACT:SCM001) |
| WK-SCM0016-0098 | A10 | SCM0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCM0016 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 55 (ACT:SCM0016_BatchLog.Form_Load ACT:SCM00) |
| WK-SCM0016-0099 | A6 | PKG_SCM0016.P_SCM0016_GET_BATCH_LOG | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0016.P_SCM0016_GET_BATCH_LOG · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 21 (Main ACT:SCM0016_BatchLog.FindButton ACT) |
| WK-SCM0016-0100 | A6 | PKG_SCM0016.P_SCM0016_GET_BATCH_LOG_HIST | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0016.P_SCM0016_GET_BATCH_LOG_HIST · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 16 (Hist ACT:SCM0016_BatchLog.FindData_Hist ) |
| WK-SCM0016-0101 | A6 | PKG_SCM0016.P_SCM0016_GET_BATCH_STEP_INF | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0016.P_SCM0016_GET_BATCH_STEP_INFO · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 16 (Step ACT:SCM0016_BatchLog.FindData_Step ) |
| WK-SCM0016-0102 | G1 | clbRunStatus / Run Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbRunStatus / Run Status · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:SCM0016_BatchLog.FindData ACT:SCM001) |
| WK-SCM0016-0103 | G6 | clbRunStatus / Run Status | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbRunStatus / Run Status · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCM0016_BatchLog.InitControls ACT:SC) |
| WK-SCM0016-0104 | X-REOPEN | SCM0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCM0016 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCM0016_BatchLog.Dispose ACT:SCM0016) |
| WK-SCM0016-0105 | M4 | JOB_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — JOB_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (E2 ACT:SCM0016_BatchLog.spdMain_CellDoub) |

## W7 기대값 확정 (75)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCM0016-0106 | F4 | E3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — E3: 행 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (E3) |
| WK-SCM0016-0107 | A5 | E1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E1: 행 집계 — A5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (E1) |
| WK-SCM0016-0108 | A5 | E4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — E4: 행 집계 — A5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (E4) |
| WK-SCM0016-0109 | A5 | G1~G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G1~G3: 행 집계 — A5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (G1~G3) |
| WK-SCM0016-0110 | A5 | R6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R6: 행 집계 — A5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (R6) |
| WK-SCM0016-0111 | A5 | SCM0016_BatchLog.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCM0016_BatchLog.CreateSpread: 진입점 집계 — A5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCM0016_BatchLog.CreateSpread:159:1 ) |
| WK-SCM0016-0112 | A5 | spdMain / spdStep / spdHist (FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain / spdStep / spdHist (FpSpread): 행 집계 — A5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (spdMain / spdStep / spdHist (FpSpread)) |
| WK-SCM0016-0113 | H10 | SCM0016 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H10 기대값 확정 — SCM0016 화면: 메시지 호출 자체가 없음 — AS-IS 메시지 발생 조건(E4)과 대조 필요 |  | 2 (E4 MSG00109 (EditButton 편집차단)) |
| WK-SCM0016-0114 | H2 | (없음) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — (없음): 행 집계 — H2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 ((없음)) |
| WK-SCM0016-0115 | H2 | E1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E1: 행 집계 — H2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (E1) |
| WK-SCM0016-0116 | H2 | E4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — E4: 행 집계 — H2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (E4) |
| WK-SCM0016-0117 | H2 | G1~G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G1~G3: 행 집계 — H2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (G1~G3) |
| WK-SCM0016-0118 | H2 | R6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R6: 행 집계 — H2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (R6) |
| WK-SCM0016-0119 | H2 | SCM0016_BatchLog.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCM0016_BatchLog.CreateSpread: 진입점 집계 — H2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCM0016_BatchLog.CreateSpread:159:1 ) |
| WK-SCM0016-0120 | H2 | spdMain / spdStep / spdHist (FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain / spdStep / spdHist (FpSpread): 행 집계 — H2 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (spdMain / spdStep / spdHist (FpSpread)) |
| WK-SCM0016-0121 | H5 | E1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E1: 행 집계 — H5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (E1) |
| WK-SCM0016-0122 | H5 | E4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — E4: 행 집계 — H5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (E4) |
| WK-SCM0016-0123 | H5 | G1~G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G1~G3: 행 집계 — H5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (G1~G3) |
| WK-SCM0016-0124 | H5 | R6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R6: 행 집계 — H5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (R6) |
| WK-SCM0016-0125 | H5 | SCM0016_BatchLog.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCM0016_BatchLog.CreateSpread: 진입점 집계 — H5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCM0016_BatchLog.CreateSpread:159:1 ) |
| WK-SCM0016-0126 | H5 | spdMain / spdStep / spdHist (FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain / spdStep / spdHist (FpSpread): 행 집계 — H5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (spdMain / spdStep / spdHist (FpSpread)) |
| WK-SCM0016-0127 | D5 | SCM0016_BatchLog.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCM0016_BatchLog.CreateSpread: 진입점 집계 — D5 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCM0016_BatchLog.CreateSpread:159:1 ) |
| WK-SCM0016-0128 | A1 | E1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E1: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E1) |
| WK-SCM0016-0129 | A1 | E2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E2: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E2) |
| WK-SCM0016-0130 | A1 | E3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — E3: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (E3) |
| WK-SCM0016-0131 | A1 | PKG_SCM0016.P_SCM0016_GET_BATCH_LOG | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0016.P_SCM0016_GET_BATCH_LOG: 골든 비교 케이스 없음(PKG_SCM0016.P_SCM0016_GET_BATCH_LOG — 팝업·보조 SP 는 golden_cases.csv 에  |  | 21 (Main ACT:SCM0016_BatchLog.FindButton ACT) |
| WK-SCM0016-0132 | A1 | PKG_SCM0016.P_SCM0016_GET_BATCH_LOG_HIST | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0016.P_SCM0016_GET_BATCH_LOG_HIST: 골든 비교 케이스 없음(PKG_SCM0016.P_SCM0016_GET_BATCH_LOG_HIST — 팝업·보조 SP 는 golden_ca |  | 16 (Hist ACT:SCM0016_BatchLog.FindData_Hist ) |
| WK-SCM0016-0133 | A1 | PKG_SCM0016.P_SCM0016_GET_BATCH_STEP_INF | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0016.P_SCM0016_GET_BATCH_STEP_INFO: 골든 비교 케이스 없음(PKG_SCM0016.P_SCM0016_GET_BATCH_STEP_INFO — 팝업·보조 SP 는 golden_ |  | 16 (Step ACT:SCM0016_BatchLog.FindData_Step ) |
| WK-SCM0016-0134 | A1 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R4: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (R4) |
| WK-SCM0016-0135 | A6 | E3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — E3: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (E3) |
| WK-SCM0016-0136 | G1 | E1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E1: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E1) |
| WK-SCM0016-0137 | G1 | E2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E2: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E2) |
| WK-SCM0016-0138 | G1 | E3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — E3: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (E3) |
| WK-SCM0016-0139 | G1 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R4: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R4) |
| WK-SCM0016-0140 | X-LOC | (없음) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (없음): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((없음)) |
| WK-SCM0016-0141 | X-LOC | E1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — E1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (E1) |
| WK-SCM0016-0142 | X-LOC | E2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — E2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (E2) |
| WK-SCM0016-0143 | X-LOC | E3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — E3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (E3) |
| WK-SCM0016-0144 | X-LOC | E4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — E4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (E4) |
| WK-SCM0016-0145 | X-LOC | G1~G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G1~G3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G1~G3) |
| WK-SCM0016-0146 | X-LOC | Hist | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Hist: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Hist) |
| WK-SCM0016-0147 | X-LOC | MSG00109 (EditButton 편집차단) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00109 (EditButton 편집차단): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00109 (EditButton 편집차단)) |
| WK-SCM0016-0148 | X-LOC | Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Main: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Main) |
| WK-SCM0016-0149 | X-LOC | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R4) |
| WK-SCM0016-0150 | X-LOC | R6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — R6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (R6) |
| WK-SCM0016-0151 | X-LOC | Step | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Step: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Step) |
| WK-SCM0016-0152 | X-LOC | clbRunStatus (UsrCheckedList, single, AL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbRunStatus (UsrCheckedList, single, ALL_VIEW): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbRunStatus (UsrCheckedList, single, AL) |
| WK-SCM0016-0153 | X-LOC | spdHist | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdHist: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdHist) |
| WK-SCM0016-0154 | X-LOC | spdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdMain: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdMain) |
| WK-SCM0016-0155 | X-LOC | spdMain / spdStep / spdHist (FpSpread) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdMain / spdStep / spdHist (FpSpread): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdMain / spdStep / spdHist (FpSpread)) |
| WK-SCM0016-0156 | X-LOC | spdStep | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdStep: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdStep) |
| WK-SCM0016-0157 | X-LOC | splitContainer1 (Horizontal=상/하) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — splitContainer1 (Horizontal=상/하): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (splitContainer1 (Horizontal=상/하)) |
| WK-SCM0016-0158 | X-LOC | splitContainer2 (Vertical=좌/우) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — splitContainer2 (Vertical=좌/우): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (splitContainer2 (Vertical=좌/우)) |
| WK-SCM0016-0159 | X-LOC | usrConditionPanel1 (HidePanel) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — usrConditionPanel1 (HidePanel): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (usrConditionPanel1 (HidePanel)) |
| WK-SCM0016-0160 | X-ROW | Form SCM0016_BatchLog | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Form SCM0016_BatchLog: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Form SCM0016_BatchLog) |
| WK-SCM0016-0161 | X-ROW | SCM0016_BatchLog.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0016_BatchLog.CreateSpread) |
| WK-SCM0016-0162 | X-ROW | SCM0016_BatchLog.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0016_BatchLog.EditButton) |
| WK-SCM0016-0163 | X-ROW | SCM0016_BatchLog.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCM0016_BatchLog.FindButton) |
| WK-SCM0016-0164 | X-ROW | SCM0016_BatchLog.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.FindData: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · PASS:1 |  | 2 (ACT:SCM0016_BatchLog.FindData:298:14 ACT) |
| WK-SCM0016-0165 | X-ROW | SCM0016_BatchLog.FindData_Hist | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.FindData_Hist: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · PASS:1 |  | 2 (ACT:SCM0016_BatchLog.FindData_Hist:368:1) |
| WK-SCM0016-0166 | X-ROW | SCM0016_BatchLog.FindData_Step | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.FindData_Step: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · PASS:1 |  | 2 (ACT:SCM0016_BatchLog.FindData_Step:332:1) |
| WK-SCM0016-0167 | X-ROW | SCM0016_BatchLog.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0016_BatchLog.Form_Load) |
| WK-SCM0016-0168 | X-ROW | SCM0016_BatchLog.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0016_BatchLog.InitControls:133:5) |
| WK-SCM0016-0169 | X-ROW | SCM0016_BatchLog.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.InitEvent: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0016_BatchLog.InitEvent) |
| WK-SCM0016-0170 | X-ROW | SCM0016_BatchLog.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.InitSpread: 진입점 집계 81검사 — NOT_RUN:81 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0016_BatchLog.InitSpread) |
| WK-SCM0016-0171 | X-ROW | SCM0016_BatchLog.spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0016_BatchLog.spdMain_CellDoubleClick: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0016_BatchLog.spdMain_CellDoubleC) |
| WK-SCM0016-0172 | X-ROW | clbRunStatus (UsrCheckedList, single, AL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbRunStatus (UsrCheckedList, single, ALL_VIEW): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbRunStatus (UsrCheckedList, single, AL) |
| WK-SCM0016-0173 | X-ROW | spdHist | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — spdHist: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (spdHist) |
| WK-SCM0016-0174 | X-ROW | spdMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — spdMain: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (spdMain) |
| WK-SCM0016-0175 | X-ROW | spdStep | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — spdStep: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (spdStep) |
| WK-SCM0016-0176 | X-ROW | splitContainer1 (Horizontal=상/하) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — splitContainer1 (Horizontal=상/하): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (splitContainer1 (Horizontal=상/하)) |
| WK-SCM0016-0177 | X-ROW | splitContainer2 (Vertical=좌/우) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — splitContainer2 (Vertical=좌/우): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (splitContainer2 (Vertical=좌/우)) |
| WK-SCM0016-0178 | G5 | SCM0016_BatchLog.spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0016_BatchLog.spdMain_CellDoubleClick: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCM0016_BatchLog.spdMain_CellDoubleC) |
| WK-SCM0016-0179 | H6 | SCM0016_BatchLog.spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0016_BatchLog.spdMain_CellDoubleClick: 진입점 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCM0016_BatchLog.spdMain_CellDoubleC) |
| WK-SCM0016-0180 | M4 | SCM0016_BatchLog.spdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0016_BatchLog.spdMain_CellDoubleClick: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCM0016_BatchLog.spdMain_CellDoubleC) |
