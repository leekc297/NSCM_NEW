# SCP0111 미검증 해소 작업 기록

## 라운드 1 (2026-11-18 17:46 ~ 18:19)

- 입력: `unverified_triage.*`(17:44:39, CheckList 16:34:35~17:44:37 실행 결과). 원장 미검증 47행, 처리 대상 26, 사람 3, 집계 18
- 행별 조치 표: `_unverified_plan.md`. 결정 목록: `_unverified_decisions.md`(판정 기준 D 10건, 계정 A 3건)
- 재측정: 묶음별 --only 재실행 안 함(사용자 지시 2026-11-18 '일괄 보완 뒤 전체 검증'). 확인은 자기 시험, 디버그 스펙, engine_selfcheck 로만 함

### 묶음별 원인과 고친 곳

| 묶음 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|
| F7·F8 저장 감사(2행) | save_audit.json 17:39:47 'CRUD 실제 저장 정리 기록 없음'. 같은 실행 restore_touched '시험 계정 변경 행 12 → 되돌림 12'. cleanup_spec mode=editonly 라 정리 백업 없음 | `tools/Harness/verify/restore_touched.py` keyless, write_trace, main(지난 기록 지움), `tools/Harness/verify/save_audit.py` judge_trace, from_trace, selftest, strip_tsql_comments, asis_targets 별칭 | restore_touched --selftest 8/8, save_audit --selftest 6/6. AS-IS 저장 SP 74개 대상 표 신·구 대조 10개 차이 전부 원문 확인(별칭 8, 주석 안 INSERT 2, 줄바꿈 INSERT 1) |
| I2 언어 전환(2행) + I3(1행) | lang_texts.json 3언어 'SCP0096 동시 실행 전환 생략(T200)'. 16:34 로그 I2 6.1분 대기 뒤 생략 | `tools/Harness/verify/run_verify.py` lang_skipped, lang_retry, E2E 종료 뒤 호출 | py_compile 통과, lang_skipped(SCP0111) = KO·EN·CN |
| J4 결함원장(2행) | _trace.spec.ts:1897 '측정 코드 없음' 고정 기록 | 신규 `tools/Harness/verify/menu_auth_sync.py`, `run_verify.py` 사후 단계 연결(예정 단계 수 39 → 40), `judge.py` J4 결함원장 연결 | menu_auth_sync --selftest 6/6. 18:05:03 SCP0111 실측 PASS(그룹 5↔5, R·C·U·D·SAVE 일치, TO-BE 전용 EXCEL·SAVEDETAIL 비교 제외) |
| 기간 칸 G1·E2·M2(4행) | 18:0x 디버그 실측: Period = `_periodSplit_`, 입력 칸 2개('2026.10', '2027.03'), 달력 버튼 2개, MUI 월 팝오버(연도 머리글 + 월 버튼 12개). 범위 달력용 함수가 팝오버를 못 찾음 | `tools/E2E/lib/smoke-extra.ts` isSplitPeriod, pickSplitMonth, periodShiftEnd, periodReverseTry, `Doc/e2e/specs/_verify.spec.ts` E2 달력 보조 경로, M2 조회조건 칸 아이콘 제외 | 디버그 스펙 `_debug_scp0111_period.spec.ts` 1 passed: 끝 202703 → 202702, 역전 시작 202704 > 끝 202703 입력됨. tsc 오류 0 |
| K4 추가 노출 버튼(1행) | Delete 가 AS-IS 버튼 목록에 없음. CR-070 노출 조건(화면 기능 + 버튼 권한) | `judge.py` K4 CR-070 판정 경로 | 핸들러 검출 IntegrationPsi.tsx:465 확인, py_compile 통과 |
| F1 신규 행 저장(1행) | 디버그 실측 DOM 37 → 37, 그리드 1259 → 1260, 신규 행 1259번 CRUD_TYPE I | `tools/E2E/lib/crud.ts` 삽입 판정, 신규 행 위치, editonly 저장 보류, `unverified_classes.csv` 저장보류(45) | tsc 오류 0. editonly 27개 화면 중 신규 행 모드 최근 결과 3개(SCP0111·SSP0023·SSP0060), 3개 inserted=N 이었음(저장 경로 줄어든 화면 없음) |
| 미분류 H4·G4 팝업(3행) | 증거 끝 '기계 판정 불가, 수동 검수 대상' | `unverified_classes.csv` 판단(95) | classify 시험 3건 의도대로 |
| X-LOC 대조표(1행) | 대조표 45줄 SCP0111_DERIV_MISMATCH 가 소스에 없음. 소스 = MSG01502 | DB MODE: `FE_GUIDE_20261118_1816.md` G7(1건) | doc_style 위반 0 |

### 고치지 않고 결정 목록으로 보낸 행

- F4 main/SAVE 2행(D10), B4 Plan Date 2행(D6), 판단 7행(D1·D3·D4·D5·D7·D8·D11), F1 저장 1행(D9), 계정 3행(A1~A3)

### 점검

- engine_selfcheck 18:16:09 실행 PASS(PY_COMPILE 0, TSC 0, selftest JS 30, PY 46)
- inventory_check --write-registry: tools/Harness/README.md 373줄 menu_auth_sync.py 등록
- 디버그 스펙 2개(`Doc/e2e/specs/_debug_scp0111_period.spec.ts`, `_debug_scp0111_insert.spec.ts`)는 조회·저장 없음. 화면 조회조건 값만 바꿈
- 백업: `*.bak_20261118_svtrace`(restore_touched·save_audit), `*.bak_20261118_i2retry`(run_verify), `*.bak_20261118_j4auth`(judge), `*.bak_20261118_splitper`(smoke-extra·_verify), `*.bak_20261118_virtins`(crud), `*.bak_20261118_svhold`(unverified_classes)

### 남은 사유

- 재측정 전이라 원장 미검증 수는 47 그대로임. 다음 CheckList 전체 실행(VM 체인)에서 바뀜

## 라운드 2 (2026-11-18 18:22 ~ 19:51)

- 시작 상태: 라운드 1 뒤 CheckList 재실행 없음(원장 17:43 그대로, 18:21 분류 47행). 이번 지시대로 고친 묶음 규칙만 --only 로 재측정함

### 재측정 명령과 결과

| 명령 | 시각 | 결과 |
|---|---|---|
| `run_verify.py SCP0111 --only F1,F7,F8,I2,I3,J4,K4,E2,G1,M2` | 18:23~18:58 | 미검증 47 → 33. F7, F8 PASS(변경 18행 감사 칸 정상), I2 KO, EN PASS, I3 PASS, J4 V-d9598564 PASS, K4 PASS(CR-070), G1 V-a30ef64b PASS, M2 NA(화면 전용 버튼 없음, 보이는 버튼 11개), G1 V-c73d3323 FAIL(기간 역전 조회 요청 나감) |
| `run-e2e.cmd authcrud SCP0111` 뒤 `--only E2` | 19:06~19:20 | E2 V-ce8459b6 FAIL. F1 authcrud: Insert 행 추가 확인(그리드 1898 → 1899), 저장 보류 → 분류 저장보류. F7, F8 이 미검증으로 되돌아감(T321) |
| `--only F1,F7,F8` | 19:21~19:38 | F7, F8 PASS 회복. E4 2행이 NA → 판정필요로 덮임(T322) |
| `--only E4` | 19:40~19:50 | E4 2행 NA 회복. 미검증 32 |

### 묶음별 원인과 고친 곳

| 묶음 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|
| E2 기간 역전 | AS-IS cs:845 `DateTime.Compare(dtFrom, dtTo) > 0` 를 E2 근거 정규식이 못 잡음 | `Doc/e2e/specs/_verify.spec.ts` E2 asisGuard | V-ce8459b6 FAIL |
| F7, F8 회귀 | --only E2(저장 없음)에서 restore_touched 가 save_trace.json 을 지움 | `restore_touched.py` --keep-trace, `run_verify.py` --only 때 전달 | 19:38 F7, F8 PASS |
| E4 회귀 | W4 E4 시험이 판정 넘김 문구로 앞 실행 NA 를 덮음 | `Doc/e2e/specs/_trace.spec.ts` PREV · prevVerdict | 19:50 V-f679aa42, V-8f1324a1 NA |

### 화면 결함으로 확인된 것

- 기간 역전 2행(V-c73d3323 G1, V-ce8459b6 E2): TO-BE 조회 처리(IntegrationPsi.tsx:242~246)에 시작 월 > 끝 월 검사 없음. 안내 코드 MSG00219 는 상수만 있고 쓰지 않으며 DB 미등록. DB MODE 라 `FE_GUIDE_20261118_1859.md` G8 로 남김. fixlist FX-SCP0111-004, FX-SCP0111-009 status=보류(가이드)

### 시험 행 복원 확인(DB 직접 조회)

- 18:20 이후, 19:00 이후, 19:20 이후, 19:40 이후 시험 계정 수정 행 0, 생성 행 0

### 점검

- engine_selfcheck 19:21 PASS. _trace.spec 수정 뒤 tsc 오류 0
- 남은 처리 대상 13행 = 판단 8, 엔진 4(F4 2행 D10, B4 2행 D6), 대조표 1(G7 가이드). 13행 결정 목록 또는 가이드 대상
