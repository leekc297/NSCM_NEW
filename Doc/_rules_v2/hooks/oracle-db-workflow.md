# Hook — oracle-db-workflow (Oracle SP/DB 작업 단일 진입점) ⭐ 2026-06-11 신설

> **트리거**: "SP 변환 / PKG / PL/SQL / Oracle / ORA-XXXXX / PLS-XXXXX / DB 적용 / MSSQL 변환 / SP 오류 / 저장 안 됨"
> **목적**: SP/DB 관련 hook 11종이 사고 단위로 분산되어 작업 시작점이 없던 문제 해소.
> 모든 Oracle DB 작업은 **이 파일에서 시작**하여 작업 타입별로 분기한다.
> **상위 룰**: `anti-simplification.md` (최우선 — 일부만 fix 하고 끝내기 금지)

---

## §0 작업 타입별 진입 (Quick Navigation)

| 작업 타입 | 필독 순서 |
|---|---|
| **A. MSSQL → Oracle SP 신규 변환** | `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` (부록 C 함정 11종 + ⭐ §7 성능 안티패턴 5룰) → `oracle-sp-perf-anti-patterns.md` (5 성능 룰 정밀) → `02_SP_CONVERSION_PIPELINE.md` (6-Stage 파이프라인) → 본 hook §1/§2 |
| **B. 신규 GET SP 작성 (조회)** | `sp-dual-cursor-pattern.md` §1 → `proc-meta-signature-match.md` §1 → `sheet-columns-binding-match.md` §1 → `sp-exception-handler-debug-friendly.md` §2 |
| **C. 신규 SAVE/MUTATION SP 작성** | `sp-dual-cursor-pattern.md` §1.3 (단일 cursor 허용) → `proc-meta-signature-match.md` §1 → 부록 C 함정: SUBSTR-0 / TRUNCATE GT / ^-delim bulk |
| **D. 기존 SP 보강 (cursor/EXCEPTION 추가)** | `sp-body-minimal-change.md` §1 (DBMS_METADATA.GET_DDL 원본 + 최소 변경) → `sp-utl-call-stack-safety.md` (SUBPROGRAM 사용 시) → `sp-exception-handler-debug-friendly.md` |
| **E. SP 버그/사고 진단** | 본 hook §3 증상→원인 매핑 → `sp-exception-handler-debug-friendly.md` §4 (5-step 진단) → **hang/무반응/폭주 = `sp-hang-runaway-loop-diagnosis.md`** → `_dev_rules/21_TROUBLESHOOTING.md` §0 분기 |
| **F. 사내 DB 적용 (Docker → 10.20.100.153)** | `db-schema-divergence-check.md` §2 PRE-CHECK → `db-corporate-apply.md` (apply.sh + Known error 분류) → REPORT.md 의무 |
| **G. 광범위 audit/sweep (silent fail family)** | `sp-substr-zero-index-audit.md` + `_artifacts/_diagnostics/silent_fail_audit.sql` (SUBSTR-0 / TRUNCATE GT / cursor mismatch / GTT DELETE 일괄) |
| **H. Claude(Code)가 DB 직접 질의/검증** | `Doc/_dev_rules/32_CLAUDE_ORACLE_DIRECT.md` (SQLcl MCP / python-oracledb / docker exec sqlplus 3 옵션) |

---

## §1 SP 작성·변경 공통 의무 (모든 타입)

1. **Signature**: GET = `O_RC`(소문자 매핑) + `O_RESULT_CURSOR` dual OUT 의무 / SAVE = 단일 cursor 허용 — `sp-dual-cursor-pattern.md`
2. **PROC_M**: 행 수 + SORT_ORD = `ALL_ARGUMENTS` positional 정확 일치 (PLS-00306 차단) — `proc-meta-signature-match.md`
3. **SHEET_COLUMNS**: COLUMN_NAME = SP SELECT alias case-sensitive 일치 — `sheet-columns-binding-match.md`
4. **Body 변경**: 원본 추출 후 최소 변경 (diff 5줄 초과 시 분리 작업) — `sp-body-minimal-change.md`
5. **EXCEPTION**: 개발 = SQLCODE/SQLERRM/BACKTRACE 노출 / 운영 = generic + LOG — `sp-exception-handler-debug-friendly.md`
6. **함정 회피**: 부록 C 11종 (SUBSTR-0 / TRUNCATE GT(+mutex hang) / LISTAGG OVERFLOW / JSON CLOB / GTT DELETE / cursor mismatch / ''=NULL / CMBO quote / ^-delim / **FETCH_STATUS 무한루프** / **NLS 암묵 형변환(C-11, #109)**)
7. ⭐ **성능 안티패턴 5 룰** (MSSQL → Oracle 변환 의무): `oracle-sp-perf-anti-patterns.md` — (1) column 안 REGEXP_SUBSTR/CONNECT BY → FROM 분리 (2) 분리자 split → GT 적재 (3) MASTER lookup → LEFT JOIN (4) GT MAIN KEY INDEX (5) WHERE 함수 → SARGable

## §2 POST-WRITE 검증 의무 (작성 직후 — 생략 금지)

```
1. 컴파일: ALTER PACKAGE PKG_X COMPILE → USER_ERRORS 0건
   → _artifacts/_diagnostics/compile_check.sh 사용
2. PROC_M ↔ SP 갯수 diff SQL (proc-meta-signature-match §3)
3. 실행 smoke: 실제 파라미터로 1회 호출 → O_RC fetch → row 수 확인
   ⚠️ "컴파일 PASS = 끝" 단정 금지. silent EXCEPTION 은 컴파일 통과함.
4. row count diff: As-Is 대비 (row_count_diff.sh) — 5% 이상 차이 시 중단·진단
5. FE 연동: 화면 진입 → 조회 → 저장 → DB SELECT 로 실반영 확인
   ⚠️ "저장 완료" alert ≠ DB 반영 (DMF0043 silent SAVE fail 사고)
```

## §3 증상 → 원인 매핑 (진단 시작표)

| 증상 | 1순위 원인 | Hook |
|---|---|---|
| FE grid 빈 칸 (row 는 있음) | SHEET_COLUMNS binding mismatch | sheet-columns-binding-match |
| FE grid column 0개 | 하드코딩 staticColumns | sheet-columns-binding-match |
| FE `data.o_rc` undefined | dual cursor 누락 | sp-dual-cursor-pattern |
| PLS-00306 (인수 갯수/유형) | PROC_M 행 수/SORT_ORD 불일치 | proc-meta-signature-match |
| ORA-06533 (subscript) | UTL_CALL_STACK COUNT 체크 누락 | sp-utl-call-stack-safety |
| ORA-04024 (self-deadlock) | SP body 임의 재작성 | sp-body-minimal-change |
| "저장 완료" + DB 미반영 | SUBSTR-0 / TRUNCATE GT / mutate array unfold | sp-substr-zero-index-audit + §2.5 |
| generic ORA-20001 만 보임 | EXCEPTION handler 가 SQLERRM 가림 | sp-exception-handler-debug-friendly |
| ORA-01722 (invalid number) | CMBO @varName quote 누락 / '' = NULL | oracle-cmbo-varname-quote |
| 사내 적용 시 ORA-01400/00904 | Docker↔사내 schema 8 차이 | db-schema-divergence-check |
| 조회 0건 (에러 없음) | GTT DELETE 누락 / bind NULL (FE filter key) | proc-meta-signature-match §0.2 |
| "동일 기간 두 개 이상 Currency" (실제 동일통화) | 편집 행을 `'I'` 저장 → 서버 "기존존재+'I'" 검증(통화비교 주석) 오탐 → **편집=`'M'`** | oracle-save-payload-integrity §1 |
| SAVE 시 "중복 오류" (실제 중복 아님) | FE dedup 키 ≠ SP GROUP BY 키(`COUNT>1`=그룹 행수) / 중복검증 PK에 MEASURE 누락 | oracle-save-payload-integrity §2·§5 |
| 신규 insert 시 ORA-01400 (NOT NULL) | 신규 행 NOT NULL 컬럼 빈값 → division placeholder(예 PLANT '-') 미채움 | oracle-save-payload-integrity §3 |
| 조회 0건 (에러 없음, PROC_M 행수는 정합) | PROC_M COL_NM **순서 뒤틀림** — VARCHAR 라 silent (P_STATUS 에 날짜 유입 등) | proc-meta-signature-match §0.4 + get-zero-dup-invisible-diagnosis §1 |
| GET 이 'Current' 류 DUAL 행만 반환 | WHERE `NVL(x, NULL)` 잔재 (ISNULL→NVL 변환 사고 — NULL 행 전멸) | get-zero-dup-invisible-diagnosis §2 |
| 동일 데이터 2행 중복 (특정 환경만) | 최종 PIVOT 암묵 GROUP BY 행 분열 — 원천 placeholder 표기차('-'/'--'/' ') | get-zero-dup-invisible-diagnosis §3 |
| 저장 성공(O_RESULT EVENT=N)인데 화면 미표시 | GET 마스터 EXISTS 필터(SITE_ITEM 등) 미통과 조합 / 신규행 정렬 위치 이동 | get-zero-dup-invisible-diagnosis §4 |
| 업로드/저장 무반응 (BE 무응답, FE hang — 파일 수신·파싱은 정상) | SP 내 GTT `TRUNCATE`(DDL) 동시세션 mutex 경합 (library cache/cursor/row cache) | sp-hang-runaway-loop-diagnosis §1·§2 + 부록 C-2 |
| 소량 입력인데 SP 영원히 실행 (V$SQL EXECUTIONS 수백만 폭증) | `@@FETCH_STATUS` 변환 누락 — `WHILE V_FETCH_STATUS=0` 재할당 없음 → 무한 루프 | sp-hang-runaway-loop-diagnosis §3 + 부록 C-10 |
| `CREATE OR REPLACE` 재배포가 안 끝남 (LAST_DDL_TIME 미변경) | 멈춘 세션이 SP library cache pin 보유 → DBA kill 선행 (SCM_MGR ORA-01031 / stale SERIAL# ORA-00026) | sp-hang-runaway-loop-diagnosis §4 |
| **로컬 BE·SP직접호출 OK, 클라우드 BE 만 실패** (ORA-01861 등) | **암묵 형변환 = 세션 NLS 의존** — DATE 파라미터 원시값/단일인자 TO_DATE. 권한·BE빌드 단정 금지 | oracle-nls-implicit-conversion(#109) + 부록 C-11 |
| 저장 시 **ORA-12841** (병렬 DML 상태 변경 불가) — 진입점 단독 호출은 정상 | SP 도입부 `ALTER SESSION DISABLE/ENABLE PARALLEL DML` 이 **DML 후 내부 호출** 경로에서 실행(활성 트랜잭션 중 PDML 상태 변경 불가). 변환 시 관성 삽입 코드 | sp-parallel-dml-txn-guard(#116) — 12841 허용 가드·비주석만 치환·LOCAL_TRANSACTION_ID(TRUE) 재현 검증 |
| 종속/상위 measure 행이 안 나옴 or 중복 (AS-IS는 정상) | ① **MSSQL CI 등가 상실** — 리터럴 대소문자 불일치로 DELETE/필터 미작동(예 'Customer Fcst'≠'Customer FCST') ② 해당 measure가 **GET이 아닌 저장/배치 생성 파생**인데 그 생성 주체 미실행 — 행 CREATED_BY 실측→sys.sql_modules INSERT 검색으로 주체 특정 | mssql-ci-collation-parity(#118) + titleset-cache-immunization(#115) |
| measure 그룹 내 순서 동률·뒤죽박죽 | `REPLACE(SORT,'.0',키)` 류가 원천 int/TO_CHAR 표기에 '.0' 없어 **사문**(AS-IS도 사문일 수 있음 — 주석의 설계 의도 복원이 정본) | mssql-ci-collation-parity(#118) §2 |
| **오류 없이 값만 틀림** — 부서명·모델명 등이 실제 값 대신 대체값(`CASE` 의 ELSE)만 표시 / 특정 행이 통째로 사라짐 / JOIN 결과 누락 | **MSSQL `ISNULL(x,'')` 오역** — Oracle 은 빈문자=NULL 이라 `NVL(x,'')<>''` 가 **항상 거짓**, `NVL(a,'')=b` 는 양쪽 NULL 행이 미매칭. 술어냐 표시냐로 판정 갈림 | **oracle-null-sentinel-and-notnull-default(#119)** + 부록 C-7/C-12 |
| 저장 시 **ORA-01400** (NOT NULL 위반) — AS-IS 는 정상 저장 | NOT NULL 컬럼에 `NVL(x,'')`(=NULL) 대입. 문자 `NVL(x,'-')` / 숫자 `NVL(x,0)` 로 보정. DATE 에 `TO_CHAR(SYSDATE,..)` 는 ORA-01861 | **oracle-null-sentinel-and-notnull-default(#119)** |
| BE 응답 `-9994` / 로그 `InvocationTargetException: null` | **래퍼가 실오류를 가림** — `SCM_COM_SYS_LOG.EXCT_MSG_CTN`(전체 ORA 체인) 또는 BE 콘솔 `Caused by:` 로 확보 (SCM_COM_SQL_LOG.EXCEPTION 은 null 로 잘림) | sp-exception-handler-debug-friendly §4.5 |
| 업로드 기간(동적) 컬럼 값이 스테이징에서 전부 빈값 → 'Invalid ... Bucket' 류 검증 실패 | `SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT` 파이프 수 < 파일 컬럼 수 — BE 가 파이프 수만큼만 매핑(초과분 절단). 사내↔클라우드 메타 불일치 1순위 | 사내값 대조 후 UPDATE 동기 (DMF0014 13_HEADER_SYNC 선례) |
| **조회 옵션/필터가 무효** (체크·지정해도 건수 동일 — 배선·파라미터·필터 블록은 전부 실존) | **변환 단순화** — 필터 의미가 AS-IS 와 다름 (예: AS-IS 키 단위 `NOT EXISTS+SUM(QTY)<>0` → 셀 단위 `WHERE QTY=0` DELETE). **형제 proc(_CURRENT 등)에 올바른 변환이 실존**할 수 있음 — 동형 SP 대조가 최단 진단. 판정은 증상 재현(N/Y 건수 실측)으로만 | [E20260831-QTYKEY] DMF0082 실사고 + hook #149 (존재 ≠ 동작) |

## §4 자기 점검 (작업 종료 직전)

```
✅ §0 작업 타입 분기 후 해당 hook 모두 읽었나?
✅ §2 의 1~5 전 단계 수행했나? (컴파일만 하고 끝 = 위반)
✅ 같은 family 의 다른 SP 도 sweep 했나? (1건 fix 후 종료 = anti-simplification 위반)
✅ fix script / SQL 은 _artifacts 에 멱등 형태로 보존했나?
✅ 사고였다면 메모리/룰 보강 (meta-rule-evolution.md 사이클) 했나?
```

---

> Cross-ref: 00_INDEX §A T08/T10/T18/T19 → 본 hook | `02_SP_CONVERSION_PIPELINE.md` (변환 절차 상세) | `32_CLAUDE_ORACLE_DIRECT.md` (DB 직결)
