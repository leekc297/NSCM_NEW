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

## 라운드 3 (2026-11-19 10:24 ~ 10:4x · VM 🧪 미검증 해소 메뉴)

- 시작 상태: 라운드 2 뒤 CheckList 재실행 없음(원장 11-18 19:50). 분류 라운드 9(10:24:07) 미검증 32 = 처리 대상 12(판단 8, 엔진 4), 가이드 1, 사람 5, 집계 14
- 행별 조치 표 `_unverified_plan.md`(32행, 원장 미검증 32행과 같음). 재측정은 하지 않음(run_verify·개별 검사기 재실행 없음). 확인은 자기 시험, 단위 함수 호출, engine_selfcheck
- 11-19 승인 '사람 확인 일반 항목 = 권장안 판정, 필요할 때만 판정필요'를 판단 행에 적용함

### 묶음별 원인과 고친 곳

| 묶음 | 원인(실측 근거) | 고친 파일 | 확인 |
|---|---|---|---|
| G4 smoke 라벨 ES-f6cf77b0 | DB SCM_ADM_MSG_M LBL01150 = 'Qty < 0'(화면 사용, integration-psi.constants.ts:201). 계획 파일 후보 = 'Qty ＜ 0'(전각), LBL00689 'Qty ≥ 0' | `tools/E2E/lib/nscm.ts` fieldExistsAny (T339) | 'Qty ＜ 0'.normalize('NFKC') = 'Qty < 0'. engine_selfcheck TSC 0 |
| A2 INCOTERMS V-028e36d9 | buildCellCombo 값=표시값 DataMap. 그리드 응답 `calls/_grid_main.json` INCOTERMS 값 '-' 19, 'FCA' 1. 코드 표 FCA VALID_YN=Y | `tools/E2E/lib/disp2.ts` judgeCodeShown, `Doc/e2e/specs/_verify.spec.ts` A2 수집 (T338) | disp2 selftest 56/56(추가 3건) |
| I1 EG-c892f15f | MSG00002 KO '성공적으로 저장되었습니다.', MSG00606 KO '저장되었습니다.'. 화면 사용 = MSG00002 1개 | 수정 없음(11-18 20:2x i18n_static 제외 규칙) | 같은 조건 계산: 묶음 [MSG00002, MSG00606], 사용 [MSG00002] |
| MS1 EG-42d53d53 | PKG_SCP0111 3204줄 C_MSG_DUP, 3337줄 RAISE_APPLICATION_ERROR(-20010, C_MSG_DUP) | `tools/Harness/verify/i18n_static.py` msg_use_line, name_use, decl_use, const_lits, selftest. `eg_ingest.py` MS1 판정 (T340) | --selftest 7/7. 실제 PKG_SCP0111 P_SCP0111_SAVE_PSI_ADMIN 본문 함수 호출 결과 RAISE |
| F5 병합 Delete V-23d0a714 | AS-IS SCP0111_IntegrationPSI.cs:536~539 DeleteButton 본문 없음. TO-BE 알림 '신규 입력 (Insert) 한 행만 삭제할 수 있습니다.' | `tools/E2E/lib/mergecheck.ts` emptyOverrideLine, judgeMergeDelete, `_verify.spec.ts` asisNoDeleteAt (T341) | mergecheck selftest 32/32(추가 5건). 실제 소스 emptyOverride 줄 536 |
| H4 V-171648d3 · G4 EG-8451fc67, EG-caf2c4d2 | layout2.ts·eg-popup 이 낸 판정필요를 judge.py REVIEW_SWEEP 이 ERROR 로 바꿈 | `tools/Harness/verify/judge.py` REVIEW_SWEEP 앞 (T342) | engine_selfcheck PY_COMPILE 0 |
| F4 2행, B4 2행 | 라운드 1 원인 그대로(ADMIN 계정만 시험, AS-IS 개발 DB Plan date 0건) | 수정 없음 | 결정 D10, D6 |

### 집계 행 하위 원인(이번 라운드 확인)

- T-eb4e0e13: 하위 ERROR 1 = I1 화면 단위 검사(EG-c892f15f)
- T-7f7f309f, T-81c9a537: J2 화면 단위 검사 ERROR. `Doc/e2e/results/SCP0111/_summary.csv` authcrud FAIL(jooyong026 마커 행 저장, 재조회 후 신규 행). ES-cd72403b(D9)와 같은 원인

### 다음 CheckList 에서 예상되는 행 상태(검사기 판정 경로 기준, 미측정)

- 미검증 → FAIL: EG-42d53d53
- 미검증 → 판정필요: V-171648d3, EG-8451fc67, EG-caf2c4d2
- 미검증 → 해당없음: V-23d0a714, V-028e36d9(다른 이름 표시 콤보 칸에 코드 노출이 있으면 미검증 유지)
- 미검증 → 통과 또는 행 없음: ES-f6cf77b0, EG-c892f15f
- 미검증 유지: F4 2행(D10), B4 2행(D6), 사람 5행, 가이드 1행(G7)

### 점검

- engine_selfcheck 10:40 PASS(PY_COMPILE 0, TSC 0, selftest JS 30, PY 47)
- 새 도구 없음(inventory_check 등록부 갱신 대상 없음)
- 백업: `*.bak_20261119_t338`(_verify.spec·nscm·disp2.selftest), `*.bak_20261119_t340`(i18n_static·eg_ingest), `*.bak_20261119_t341`(mergecheck·mergecheck.selftest), `*.bak_20261119_t342`(judge)

### 라운드 3 추가 (2026-11-19 10:58)

- 사용자 지시로 보완 뒤 CheckList 재수행 전에는 보완 전 건수를 표시하지 않게 바꿈. 보완 표식 `_unverified_fix.json` 10:58 남김. 건수는 CheckList 재수행 뒤 표시
