# SCP0028 미검증 해소 작업 기록

## 라운드 1 (2026-11-19 16:35 ~ 17:1x · 일괄 보완)

- 입력: CheckList 원장 `verify_ledger.csv`(16:34:49), 분류 `unverified_triage.*`(16:35:20). 원장 미검증 278행 = 처리 대상 141(엔진 109, 판단 30, 자동 2), 집계 137
- 행별 조치 표 `_unverified_plan.md`(141행, 처리 대상 141행과 같음). 결정 목록 `_unverified_decisions.md`(D1~D19, 70행). 표 생성 `_unverified_plan_gen.py`
- 재측정: run_verify, 개별 검사기 재실행 안 함(사용자 지시 2026-11-18 일괄 보완 뒤 전체 검증). 확인은 단위 함수 시험, 사실 파일 재생성 diff, engine_selfcheck

### 묶음별 원인과 고친 곳

| 묶음 | 행 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|---|
| A BE 정지 | 12 | `e2e/results.json` 문서 시나리오(05:30Z 시작, 3,068초): '[BE 대기] 로그인 … 300초 안에 BE 가 뜨지 않음' 3회, '[openScreen] SCP0028: 주소 진입 뒤 Home 에 남음' 10회. Home 이동을 '화면 권한 없음'으로 기록. `_server_8080.log` 15:26:00 server_guard 기동 | `tools/E2E/lib/nscm.ts` openScreen(BE 포트 확인, waitBeUp, 재로그인, 1회 재시도, beDown), `Doc/e2e/specs/_verify.spec.ts` 시나리오 실패 문구, `tools/Harness/verify/unverified_classes.csv` 20행 (T360) | tsc 0. 실제 BE 정지 재현은 미측정 |
| B 조회 0행 메모 | 7 | 같은 results.json 05:27Z '버튼 경로 메시지·모달 조건' 테스트 출력 '[required] From Site: 후보 없음(목록 0개)'. 증거 '대안 없음 전부 0행 … 재시도 생략' = 대안 시도 0건인 실행이 메모를 남김 | `tools/E2E/lib/smoke-extra.ts` ensureRows 메모 조건 (T361) | tsc 0 |
| C Insert 무동작 | 26 | AS-IS SCP0028_Shipment_Lot_Size.cs:200~203 InsertButton → InsertRow(), 571~573 InsertRow 본문 비어 있음. TO-BE 실측 'Insert 무동작', 'Insert 뒤 신규 행 없음' | `tools/Harness/verify/facts_lockrules.py` insert_noop, `tools/Harness/verify/judge.py` _asis_insert_noop, insert_noop_na (T362) | 원장 단위 시험 26행 해당없음. facts_lockrules SCP0028 재생성 diff = new_row 열 UNKNOWN → NONE 18칸만. 빈 본문 판정 134화면(원문 확인 표본 SCP0096 cs:274, SSP0020 cs:897) |
| D Valid 별칭 | 8 | 원장 V-cd32453c '조회조건 실측 5 … CR-092', T-5fa3ec51 'TO-BE 헤더 Active'. 사내 오라클 LBL00007 KO·EN·CN = Active(16:5x). combo_runtime.json search 키에 Valid 없음 | `Doc/e2e/specs/_verify.spec.ts` findSearchBox, VERIFY_ALIASES (T363) | tsc 0 |
| E 기준표 없음 | 7 | `SCP_DM_화면별 조회조건 정리_260122_v0.4.xlsx` 6시트 SCP0028·Shipment Lot 0건. search_cond.csv SCP0028 0행 | `tools/Harness/verify/judge.py` 기준표 없는 화면 경로 (T364) | py_compile 0 |
| F 다른 화면 결함 유형 | 6 | 대상 칸(End Customer, Sold-to Customer, Sales Company, Sales Plant, Cust Group, Sales Site)이 원장 COLUMN 98행, SEARCH 7종에 없음 | `tools/Harness/verify/judge.py` cascade_entities, _absent_ents (T365) | 원장 모의 시험 6행 해당없음, 4행 유지(D7) |
| G Input 버튼 | 3 | 버튼 목록 '…Search(F5), 입력, Delete, Insert(F8)…'(계정 언어 KO). 사내 오라클 LBL00872 EN Input, KO 입력(16:5x) | 신규 `tools/E2E/lib/labeltrans.ts`, `Doc/e2e/specs/eg_popup.spec.ts` (T366) | labelVariants('Input') = ['입력'] |
| H 언어 전환 | 2 | 다른 화면 동시 실행 전환 생략(T200). 15:4x langacct.ts 로 보완된 상태 | 수정 없음 | 해당 없음 |

### 고치지 않고 결정 목록으로 보낸 행

- D1~D19 70행. D5(2행)는 SSP0014 세션 T355, D17(1행)은 T357 과 같은 증상이라 다음 CheckList 에서 다시 잼

### 다음 CheckList 에서 바뀔 판정(검사기 판정 경로 기준, 미측정)

- 미검증 → 해당없음: C 묶음 26행(D1 컬럼 15행은 원장 재생성 때 행이 만들어지지 않음), F 묶음 6행, SC1 V-119cf5cb
- 미검증 → 실측(통과 또는 오류): A 12행, B 7행, D 8행, G 3행, H 2행, H5 6행(라벨을 못 찾으면 사유를 붙인 미검증)
- 미검증 유지: 결정 목록 70행(D5, D17 은 다른 세션 보완분으로 바뀔 수 있음)
- 다른 화면: Insert 빈 본문 화면 134개의 신규 행 전제 행, 기준표 행 0 화면의 H5·SC1, 'Valid'·'Input' 처럼 별칭·다른 언어 라벨을 쓰는 화면

### 점검

- engine_selfcheck PASS(17:0x, PY_COMPILE 0, TSC 0, selftest JS 31, PY 53)
- inventory_check --write-registry: 도구 242, 등록부에 없는 도구 0. GATE_SCOPE·STAGE_WARN 실패는 다른 세션 run_verify.py 16:53 수정분(이번 수정 아님)
- 줄바꿈: judge.py LF, nscm.ts CRLF 를 수정 전 형식으로 되돌림. 추가 줄의 줄표를 쉼표로 바꿈
- 백업 `*.bak_20261119_scp28u`(_verify.spec, eg_popup.spec, nscm, smoke-extra, facts_lockrules, judge, unverified_classes)
- 시험 데이터: TO-BE 저장 없음. 사내 오라클 조회 1회(SCM_ADM_MSG_M LBL00872, LBL00007). Doc/asisfacts/screens/SCP0028 edit_expect.csv, lock_rules.csv, color_rules.csv 재생성(facts_lockrules)
- FE 가이드: 없음(이번 라운드 화면 결함 확정 0건)
