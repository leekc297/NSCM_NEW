# UIPKG_CONSOLIDATION_20260915 — STEP 3 · 4 · 5 결과

## STEP 3 — META 전환 (사용자 추가 지시: 사내 오라클 실행)
- 대상: 8 PKG · 32건 · API 38 (내부 호출 전용 11건은 META 없음)
- 19:07:11 사내 적용·COMMIT — PROC_M 복제 MERGE + API_M.API_URL → `PKG.멤버` (영향 244행)
- 검증 `03_meta/VERIFY.md`: API_URL 38 OK · PROC_M 행수 = 멤버 인자 · IN/OUT 순서 일치 · `PR_GET_PROC_INFO_LIST` 버튼별 해석 전부 PKG 멤버 — 불일치 0
- BE 실호출(로컬 BE → 사내 DB) SEARCH 17 API 성공
- 발견·정정: `DMF0043_GET_MAIN_SPREAD_TITLE` PROC_M `createdBy` DATA_TP_CD='VARCHAR2'(06-29 등록 결함, 전환 전부터) → BE 가 값 미렌더 → PLS-00103. VARCHAR 로 정정(`31_PROC_M_DATATYPE_FIX.sql`) 후 FE 동일 파라미터 125행 성공
- 범위 밖 동일 결함(미조치·보고): SCM0005 11행 · SCM0008 11행 · DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL 1행

## STEP 4 — 미사용 standalone 삭제 SQL (미적용)
- `04_drop/<PKG>/40_DROP_STANDALONE_SCM_MGR.sql`(가드 블록) · `41_DROP_SYNONYM_SCMP_APP.sql` · `49_RESTORE.sql` — 43건
- 판정 전용 실행(`JUDGE.md`): 43 PASS · 음성 시험: 사용중 SP(API 참조·JOB·의존 180건) SKIP / 부재 SP ALREADY
- 가드 결함 정정: 의존 다수 SP 에서 사유 문자열 4000 초과 ORA-06502 → 건수+앞 5건 요약
- 복원 원문 = 생성 시점 DB 재조회본(실행 hook #152 가 백업 파일 사용을 차단 — STEP 2 에서 바뀐 래퍼 standalone 을 옛 본문으로 되돌리면 INVALID 되는 문제 예방)

## STEP 5 — 클라우드 폴더 `_artifacts/_deploy_packages/UIPKG_CONSOLIDATION_CLOUD_20260915/`
- 루트 `00_README.md`(전체 순서·주의·검증 근거) · `00_COMMON/`(재컴파일 2) · PKG 15 폴더(각 README.md) — 파일 183
- PKG 폴더: 00_PRECHECK · 10_SPEC · 11_BODY · 12_CALLER_* · 20_GRANT(SCM_MGR) · 21_SYNONYM(SCMP_APP) · 30/31/38/39 META · 40/41/49 DROP · 90_VERIFY
- PRECHECK 판정 = 원문 줄 해시(사내 적용 전 PRE / 적용 후 POST / ABSENT / DIFF) — 사내 자가시험 교체 객체 32 POST · standalone 43 SAME · 가짜 해시 DIFF 검출
- 객체 SQL = 사내 현재 원문 추출 + FRESH-GATE(추출본 == 사내 적용 산출물)
- **누락 게이트**: `02_apply/APPLIED_OPERATIONS.md` 사내 실행 작업 21건의 SQL 파일 47개 전부 폴더 포함 확인(권한·시노님·재컴파일·PROC_M 정정 포함)
- 전 산출물 .sql/.py 실행 hook(check-db-fresh-source) 통과 0 차단

## 로컬 검증
`LOCAL_VERIFY_GUIDE.md` — 기동 · 호출 경로 확인 SQL · 화면별 체크리스트 60행 · 이상 시 확인 순서 · 즉시 원복 방법
