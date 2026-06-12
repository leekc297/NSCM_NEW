# Hook — oracle-db-workflow (Oracle SP/DB 작업 단일 진입점) ⭐ 2026-06-11 신설

> **트리거**: "SP 변환 / PKG / PL/SQL / Oracle / ORA-XXXXX / PLS-XXXXX / DB 적용 / MSSQL 변환 / SP 오류 / 저장 안 됨"
> **목적**: SP/DB 관련 hook 11종이 사고 단위로 분산되어 작업 시작점이 없던 문제 해소.
> 모든 Oracle DB 작업은 **이 파일에서 시작**하여 작업 타입별로 분기한다.
> **상위 룰**: `anti-simplification.md` (최우선 — 일부만 fix 하고 끝내기 금지)

---

## §0 작업 타입별 진입 (Quick Navigation)

| 작업 타입 | 필독 순서 |
|---|---|
| **A. MSSQL → Oracle SP 신규 변환** | `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` (특히 부록 C 함정 9종) → `02_SP_CONVERSION_PIPELINE.md` (6-Stage 파이프라인) → 본 hook §1/§2 |
| **B. 신규 GET SP 작성 (조회)** | `sp-dual-cursor-pattern.md` §1 → `proc-meta-signature-match.md` §1 → `sheet-columns-binding-match.md` §1 → `sp-exception-handler-debug-friendly.md` §2 |
| **C. 신규 SAVE/MUTATION SP 작성** | `sp-dual-cursor-pattern.md` §1.3 (단일 cursor 허용) → `proc-meta-signature-match.md` §1 → 부록 C 함정: SUBSTR-0 / TRUNCATE GT / ^-delim bulk |
| **D. 기존 SP 보강 (cursor/EXCEPTION 추가)** | `sp-body-minimal-change.md` §1 (DBMS_METADATA.GET_DDL 원본 + 최소 변경) → `sp-utl-call-stack-safety.md` (SUBPROGRAM 사용 시) → `sp-exception-handler-debug-friendly.md` |
| **E. SP 버그/사고 진단** | 본 hook §3 증상→원인 매핑 → `sp-exception-handler-debug-friendly.md` §4 (5-step 진단) → `_dev_rules/21_TROUBLESHOOTING.md` §0 분기 |
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
6. **함정 회피**: 부록 C 9종 (SUBSTR-0 / TRUNCATE GT / LISTAGG OVERFLOW / JSON CLOB / GTT DELETE / cursor mismatch / ''=NULL / CMBO quote / ^-delim)

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
