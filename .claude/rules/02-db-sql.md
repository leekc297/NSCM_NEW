---
paths:
  - "**/*.sql"
  - "_artifacts/**"
  - "To-be_v2_converted/**"
  - "Doc/_analysis/db_migration/**"
---
# DB / SQL / SP 규약 (SQL·_artifacts 를 만질 때 자동 로드) — 구 CLAUDE.md 절대금지 ⑩ / Step 2 DB 룰 승계

## A. 진입 (T08 / T10 / T18 / T19 — 생략 금지)
1. `hooks/oracle-db-workflow.md` — **Oracle SP/DB 작업 전부의 통합 진입** (작업 타입 8종 분기 + 증상→원인 매핑)
2. `hooks/db-source-refresh-before-work.md` (#152) — 작업 기준 원문 = **착수 시 DB 에서 새로 조회**(`ALL_SOURCE` + `LAST_DDL_TIME`). 로컬 백업/패키지/이전 세션 기억 기준 ⛔. 적용 직전 **FRESH-GATE** 재조회(불일치 = 중단·최신 원문 위 재병합). 이관 패키지 객체 SQL = `-- SOURCE-FRESH: … FETCHED=… (24h)` 스탬프 — 실행 hook `check-db-fresh-source.ps1` 가 차단.
3. AS-IS 사실 확인은 **살아있는 DB 직접 접속**이 정본 (#151). 접속 불가 시 작업 중단 → 사용자 확인 후에만 DDL 파일 fallback (산출물에 "DB 미접속·파일 기준·사용자 승인 {일시}" 표기). 대상 DB 가 요청 환경(DEV/QA/PROD)과 일치하는지 보고문에 병기.
4. MSSQL→Oracle 변환: `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` (부록 C 실전 함정 12종) + `02_SP_CONVERSION_PIPELINE.md` (6-Stage) 필독.

## B. 절대 금지 / 표준
- MSSQL 키워드 잔존 0: `DATEADD / CHARINDEX / STRING_SPLIT / GETDATE / ISNULL / IIF / N'…' / WITH (NOLOCK)`.
- `ISNULL(x,'')` 의도 2종은 Oracle 빈문자=NULL 로 깨진다 → 센티널 **`'/'`** 통일(⭐ 2026-10-15 개정 — 신규 NULL 초기값·비교 센티널 = `'/'`, 원래 데이터가 `'-'` 인 값은 유지, 과도기 빈값 술어 `IN ('-','/')`), 비교·JOIN 은 **양변** `NVL(x,'/')`, NOT NULL INSERT 는 `NVL(x,'/')`/`NVL(x,0)`/DATE `SYSDATE`; `NVL(x,'-')`·`DEFAULT '-'` 신규 작성 금지 (#119 §0.5).
- DATE 파라미터 원시값·단일인자 `TO_DATE` 금지 — 세션 NLS 암묵 변환(클라우드 WAS 만 ORA-01861) (#109).
- 성능 개선 순서 고정: ①SELECT 목록 함수 제거(JOIN 치환) → ②인덱스 타도록 구문 변경 → ③힌트. 힌트 우선 금지 (#129).
- GTT 는 `TRUNCATE`(DDL) 금지 → `DELETE` (#107) · `@@FETCH_STATUS` 변환 시 FETCH 직후 `%NOTFOUND` 재할당 의무.
- `SCM_ADM_MSG_M` 클라우드 이관 취합 = `INSERT … NOT EXISTS` 전용 (MERGE/UPDATE/DELETE ⛔) (#140).
- `*_DBeaver*.sql` 에 SQL*Plus 토큰(`SET`/`PROMPT`/`DEFINE`/`/`) 금지 — 실행 hook `check-dbeaver-sql.ps1`. 메타 INSERT 는 `desc` 로 NOT NULL 인벤토리 선행 — `check-notnull-insert.ps1` · `SHEET_COLUMNS` 값 단언 `check-meta-sql.ps1`.
- 사내 DB 적용(T18): `hooks/db-corporate-apply.md` + `db-schema-divergence-check.md` + `corp-meta-integrity-and-wiring.md`(#98). 적용 결과는 `_artifacts/_apply_corporate/{…}/APPLIED_OPERATIONS.md` 기록.
- 이관 패키지(T16): `Doc/_dev_rules/22_PACKAGE_ARTIFACTS.md` + `hooks/deploy-package-completeness.md`.
- Oracle 직결 도구: `Doc/_dev_rules/32_CLAUDE_ORACLE_DIRECT.md` (`python _artifacts/_diagnostics/ora.py query|desc|args|compile|exec`).

## C. 완료 보고
- 컴파일 VALID 확인 + `ALL_ERRORS` 0 + 전/후 동등성 실측(행수·키·대표 쿼리) 첨부. 검증 미실행은 ERROR 로 보고 (#126).
