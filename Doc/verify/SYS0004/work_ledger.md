# 작업 원장 — SYS0004 · 2026-10-26 13:00

> 검사 인스턴스 77건 중 PASS·NA 13건 외 **64건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 18 | 실행 → PASS |
| W7 | 기대값 확정 | 39 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 39 · E2E 18 · 하네스 7
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 32 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| DB-SYN | DB |  |  |  |  | 4 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| F4 | DB |  |  |  |  |  | 4 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E4 | EDIT |  |  |  |  |  | 2 | 2 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 3 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A6 | GEN |  |  |  |  |  | 2 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| M3 | POPUP |  |  |  |  |  | 2 |  |  |  | 팝업 내부 기능(조회·CRUD) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| C1 | CASCADE |  |  |  |  |  | 1 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| G4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 표시·라벨·활성 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| G6 | GEN |  |  |  |  |  | 1 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0004-0001 | F2 | SYS0004 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SYS0004 화면 | 판단불가(대상 단위 SCREEN) | 4 (ACT:SCM0004MOD_UI_CategorySetup.SaveButt) |
| WK-SYS0004-0002 | F6 | SYS0004 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SYS0004 화면 | 판단불가(대상 단위 SCREEN) | 4 (ACT:SCM0004MOD_UI_CategorySetup.SaveButt) |
| WK-SYS0004-0003 | DB-SYN | SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | 없음(PROC_M 대응 없음) | 5 (ACT:SCM0004_UICategorySetup.Find_Column:) |
| WK-SYS0004-0004 | DB-SYN | SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | 없음(PROC_M 대응 없음) | 10 (ACT:SCM0004MOD_UI_CategorySetup.Find_Mea) |
| WK-SYS0004-0005 | DB-SYN | SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN | 없음(PROC_M 대응 없음) | 6 (ACT:SCM0004MOD_UI_CategorySetup.Save_Dat) |
| WK-SYS0004-0006 | DB-SYN | SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE | 없음(PROC_M 대응 없음) | 6 (ACT:SCM0004MOD_UI_CategorySetup.Save_Dat) |
| WK-SYS0004-0007 | G03-WIRE | SYS0004 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SYS0004 화면 | 판단불가(대상 단위 SCREEN) | 6 (ACT:SCM0004MOD_UI_CategorySetup..ctor AC) |

## W6 검증 실행 (18)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0004-0008 | C1 | cboValid / Valid | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCM0004MOD_UI_CategorySetup.InitCont) |
| WK-SYS0004-0009 | F1 | SYS0004 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SYS0004 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 4 (ACT:SCM0004MOD_UI_CategorySetup.SaveButt) |
| WK-SYS0004-0010 | F4 | SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0004_GET_UI_CATEGORY_SETUP_COLUMN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 9 (ACT:SCM0004_UICategorySetup.FindButton A) |
| WK-SYS0004-0011 | F4 | SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0004_GET_UI_CATEGORY_SETUP_MEASURE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 18 (ACT:SCM0004MOD_UI_CategorySetup.FindButt) |
| WK-SYS0004-0012 | F4 | SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 10 (ACT:SCM0004MOD_UI_CategorySetup.SaveButt) |
| WK-SYS0004-0013 | F4 | SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 10 (ACT:SCM0004MOD_UI_CategorySetup.SaveButt) |
| WK-SYS0004-0014 | G4 | cboValid / Valid | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCM0004MOD_UI_CategorySetup.InitCont) |
| WK-SYS0004-0015 | I1 | SYS0004 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SYS0004 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 6 (ACT:SCM0004MOD_UI_CategorySetup.Save_Dat) |
| WK-SYS0004-0016 | D6 | SYS0004 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SYS0004 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (ACT:SCM0004MOD_UI_CategorySetup.InsertBu) |
| WK-SYS0004-0017 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCM0004MOD_UI_CategorySetup.Save_Dat) |
| WK-SYS0004-0018 | E4 | MSG00052 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00052 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCM0004MOD_UI_CategorySetup.Save_Dat) |
| WK-SYS0004-0019 | A10 | SYS0004 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SYS0004 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 152 (ACT:SCM0004MOD_UI_CategorySetup.Form_Loa) |
| WK-SYS0004-0020 | A6 | SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0004_GET_UI_CATEGORY_SETUP_COLUMN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 2 (ACT:SCM0004_UICategorySetup.FindButton A) |
| WK-SYS0004-0021 | A6 | SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCM0004_GET_UI_CATEGORY_SETUP_MEASURE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 4 (ACT:SCM0004MOD_UI_CategorySetup.FindButt) |
| WK-SYS0004-0022 | G6 | cboValid / Valid | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCM0004MOD_UI_CategorySetup.InitCont) |
| WK-SYS0004-0023 | X-REOPEN | SYS0004 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SYS0004 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 16 (ACT:SCM0004MOD_UI_CategorySetup.Dispose ) |
| WK-SYS0004-0024 | M3 | SCM0004MOD_UI_CategorySetup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCM0004MOD_UI_CategorySetup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 17 (ACT:SCM0004MOD_UI_CategorySetup..ctor AC) |
| WK-SYS0004-0025 | M3 | YOUR_CALL | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — YOUR_CALL · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:YOUR_CALL.MY_CALL) |

## W7 기대값 확정 (39)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SYS0004-0026 | DB-SYN | SCM0004MOD_UI_CategorySetup.Find_Column | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCM0004MOD_UI_CategorySetup.Find_Column: 진입점 집계 — DB-SYN 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCM0004MOD_UI_CategorySetup.Find_Col) |
| WK-SYS0004-0027 | F4 | SCM0004MOD_UI_CategorySetup.Find_Column | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCM0004MOD_UI_CategorySetup.Find_Column: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCM0004MOD_UI_CategorySetup.Find_Col) |
| WK-SYS0004-0028 | E4 | SCM0004_UICategorySetup.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM0004_UICategorySetup.SetSpreadInit: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCM0004_UICategorySetup.SetSpreadIni) |
| WK-SYS0004-0029 | E4 | SCM0004_UICategorySetup.Set_CellBackColo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCM0004_UICategorySetup.Set_CellBackColor: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCM0004_UICategorySetup.Set_CellBack) |
| WK-SYS0004-0030 | A1 | SCM0004MOD_UI_CategorySetup.Find_Column | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0004MOD_UI_CategorySetup.Find_Column: 진입점 집계 — A1 2요소: REVIEW:2 |  | 1 (ACT:SCM0004MOD_UI_CategorySetup.Find_Col) |
| WK-SYS0004-0031 | A1 | SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0004_GET_UI_CATEGORY_SETUP_COLUMN: 골든 비교 케이스 없음(SCM0004_GET_UI_CATEGORY_SETUP_COLUMN — 팝업·보조 SP 는 golden_cases.csv  |  | 3 (ACT:SCM0004_UICategorySetup.FindButton A) |
| WK-SYS0004-0032 | A1 | SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0004_GET_UI_CATEGORY_SETUP_MEASURE: 골든 비교 케이스 없음(SCM0004_GET_UI_CATEGORY_SETUP_MEASURE — 팝업·보조 SP 는 golden_cases.cs |  | 6 (ACT:SCM0004MOD_UI_CategorySetup.FindButt) |
| WK-SYS0004-0033 | X-ROW | SCM0004MOD_UI_CategorySetup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0004MOD_UI_CategorySetup..ctor:12) |
| WK-SYS0004-0034 | X-ROW | SCM0004MOD_UI_CategorySetup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCM0004MOD_UI_CategorySetup.CreateSp) |
| WK-SYS0004-0035 | X-ROW | SCM0004MOD_UI_CategorySetup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCM0004MOD_UI_CategorySetup.Dispose:) |
| WK-SYS0004-0036 | X-ROW | SCM0004MOD_UI_CategorySetup.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.EditButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCM0004MOD_UI_CategorySetup.EditButt) |
| WK-SYS0004-0037 | X-ROW | SCM0004MOD_UI_CategorySetup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:SCM0004MOD_UI_CategorySetup.FindButt) |
| WK-SYS0004-0038 | X-ROW | SCM0004MOD_UI_CategorySetup.Find_Column | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.Find_Column: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 26 (ACT:SCM0004MOD_UI_CategorySetup.Find_Col) |
| WK-SYS0004-0039 | X-ROW | SCM0004MOD_UI_CategorySetup.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.Find_Data: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCM0004MOD_UI_CategorySetup.Find_Dat) |
| WK-SYS0004-0040 | X-ROW | SCM0004MOD_UI_CategorySetup.Find_Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.Find_Measure: 진입점 집계 5검사 — NOT_RUN:3 · NOPATH:1 · REVIEW:1 |  | 28 (ACT:SCM0004MOD_UI_CategorySetup.Find_Mea) |
| WK-SYS0004-0041 | X-ROW | SCM0004MOD_UI_CategorySetup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCM0004MOD_UI_CategorySetup.Form_Loa) |
| WK-SYS0004-0042 | X-ROW | SCM0004MOD_UI_CategorySetup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.InitControls: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCM0004MOD_UI_CategorySetup.InitCont) |
| WK-SYS0004-0043 | X-ROW | SCM0004MOD_UI_CategorySetup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 59 (ACT:SCM0004MOD_UI_CategorySetup.InitSpre) |
| WK-SYS0004-0044 | X-ROW | SCM0004MOD_UI_CategorySetup.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.InsertButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0004MOD_UI_CategorySetup.InsertBu) |
| WK-SYS0004-0045 | X-ROW | SCM0004MOD_UI_CategorySetup.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.Insert_Row: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SCM0004MOD_UI_CategorySetup.Insert_R) |
| WK-SYS0004-0046 | X-ROW | SCM0004MOD_UI_CategorySetup.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.SaveButton: 진입점 집계 7검사 — NOT_RUN:5 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0004MOD_UI_CategorySetup.SaveButt) |
| WK-SYS0004-0047 | X-ROW | SCM0004MOD_UI_CategorySetup.Save_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.Save_Data: 진입점 집계 11검사 — NOT_RUN:8 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 197 (ACT:SCM0004MOD_UI_CategorySetup.Save_Dat) |
| WK-SYS0004-0048 | X-ROW | SCM0004MOD_UI_CategorySetup.SetSpreadIni | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.SetSpreadInit: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCM0004MOD_UI_CategorySetup.SetSprea) |
| WK-SYS0004-0049 | X-ROW | SCM0004MOD_UI_CategorySetup.Set_CellBack | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004MOD_UI_CategorySetup.Set_CellBackColor: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCM0004MOD_UI_CategorySetup.Set_Cell) |
| WK-SYS0004-0050 | X-ROW | SCM0004_UICategorySetup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0004_UICategorySetup.CreateSpread) |
| WK-SYS0004-0051 | X-ROW | SCM0004_UICategorySetup.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0004_UICategorySetup.EditButton) |
| WK-SYS0004-0052 | X-ROW | SCM0004_UICategorySetup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCM0004_UICategorySetup.FindButton) |
| WK-SYS0004-0053 | X-ROW | SCM0004_UICategorySetup.Find_Column | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.Find_Column: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:1 · REVIEW:1 |  | 26 (ACT:SCM0004_UICategorySetup.Find_Column ) |
| WK-SYS0004-0054 | X-ROW | SCM0004_UICategorySetup.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.Find_Data: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:SCM0004_UICategorySetup.Find_Data AC) |
| WK-SYS0004-0055 | X-ROW | SCM0004_UICategorySetup.Find_Measure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.Find_Measure: 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:1 · REVIEW:1 |  | 28 (ACT:SCM0004_UICategorySetup.Find_Measure) |
| WK-SYS0004-0056 | X-ROW | SCM0004_UICategorySetup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0004_UICategorySetup.Form_Load) |
| WK-SYS0004-0057 | X-ROW | SCM0004_UICategorySetup.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCM0004_UICategorySetup.InitControls) |
| WK-SYS0004-0058 | X-ROW | SCM0004_UICategorySetup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0004_UICategorySetup.InitSpread) |
| WK-SYS0004-0059 | X-ROW | SCM0004_UICategorySetup.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0004_UICategorySetup.InsertButton) |
| WK-SYS0004-0060 | X-ROW | SCM0004_UICategorySetup.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.Insert_Row: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/GRID_LOCK/GRID_SET/LOCAL, 연 |  | 23 (ACT:SCM0004_UICategorySetup.Insert_Row A) |
| WK-SYS0004-0061 | X-ROW | SCM0004_UICategorySetup.Save_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.Save_Data: 진입점 집계 12검사 — NOT_RUN:8 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 230 (ACT:SCM0004_UICategorySetup.Save_Data AC) |
| WK-SYS0004-0062 | X-ROW | SCM0004_UICategorySetup.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCM0004_UICategorySetup.SetSpreadIni) |
| WK-SYS0004-0063 | X-ROW | SCM0004_UICategorySetup.Set_CellBackColo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCM0004_UICategorySetup.Set_CellBackColor: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCM0004_UICategorySetup.Set_CellBack) |
| WK-SYS0004-0064 | X-ROW | YOUR_CALL.MY_CALL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — YOUR_CALL.MY_CALL: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:YOUR_CALL.MY_CALL ACT:YOUR_CALL.MY_C) |
