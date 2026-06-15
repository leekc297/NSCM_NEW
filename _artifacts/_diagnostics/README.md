# `_artifacts/_diagnostics/` — As-Is DB cross-check 자동화

작성: 2026-06-01 (Plan Stage 4)
관련 룰: [21 §12](../Doc/_dev_rules/21_TROUBLESHOOTING.md) / [24 §6.5](../Doc/_dev_rules/24_ASIS_CROSSCHECK.md)
관련 hook (TODO): [`screen-entry-asis-baseline.md`](../Doc/_dev_rules/hooks/screen-entry-asis-baseline.md) — Stage 5 작성 예정

---

## §0. 목적

신규 화면 작업 진입 시 / DB 오류 발생 시 / row 수 불일치 발견 시
As-Is MSSQL 원본을 직접 조회하여 To-Be Oracle 과 cross-check.

추측/단순 fallback 대신 **원본 1차 자료 의무**.

---

## §1. 사용 자료

| 파일 | 용도 |
|---|---|
| `_connection.env.example` | DB 접속 정보 양식 (실제 `.env.asis` 는 gitignore) |
| `_mapping_asis_tobe.csv` | As-Is SP / 테이블 이름 ↔ To-Be 매핑 표 (수동 입력) |
| `sp_body_diff.sh` | As-Is `sys.sql_modules.definition` ↔ To-Be `USER_SOURCE` body diff |
| `row_count_diff.sh` | 동일 테이블 row count 비교 (As-Is vs To-Be Docker Oracle) |
| `column_inventory.sh` | `INFORMATION_SCHEMA.COLUMNS` vs `USER_TAB_COLUMNS` cross-check |
| `_run_diagnose.ps1` | Windows PowerShell wrapper (PSReadLine AMSI 회피, 룰 21 §11) |

---

## §2. 사전 조건

```bash
# 1. .env.asis 파일 존재 + 다음 5 변수 정의 (gitignore)
ASIS_DB_HOST=165.244.95.223
ASIS_DB_PORT=1433
ASIS_DB_NAME=LGCE_SCMDEV       # ← E 가 정확 (D 아님)
ASIS_DB_USER=scp_mgr_dev
ASIS_DB_PASS=...

# 2. sqlcmd 설치 (Windows: SQL Server Command Line Utilities)
sqlcmd -? 2>/dev/null | head -1

# 3. Docker Oracle 컨테이너 실행
docker ps --filter "name=nscm-oracle" --format "{{.Status}}"

# 4. To-Be 접속 정보 (이미 docker-mounted)
# scm_mgr/!SCMroqkf2026@//localhost:1521/FREEPDB1
```

---

## §3. 빠른 사용 (3 명령)

```bash
# SP 본문 diff (As-Is SP 1개 vs To-Be PKG body)
./sp_body_diff.sh "P_DMF0043_GET_CONTRIBUTE_MAIN_DATA" "PKG_DMF0043"

# Row count diff (As-Is 테이블 vs To-Be 테이블)
./row_count_diff.sh "DM_MST_CONTRIBUTE_RATIO_DTL"

# Column inventory (특정 테이블)
./column_inventory.sh "DM_MST_CONTRIBUTE_RATIO_DTL"
```

---

## §4. 트리거

다음 조건 시 본 폴더 사용:
1. ORA-XXXXX / PLS-00XXX 에러 발생
2. 화면 row 수 As-Is vs To-Be 불일치 ≥ 5%
3. 컬럼/스키마 의문 ("이 컬럼이 정말 있나?")
4. 사용자가 "As-Is 확인 요청"
5. **신규 화면 진입 시** (룰 25 §0.5 hook — Stage 5)

---

## §5. 매핑 표 양식 (`_mapping_asis_tobe.csv`)

```csv
DOMAIN,ASIS_SP_NAME,TOBE_PKG_NAME,TOBE_SP_NAME,ASIS_TABLE,TOBE_TABLE,NOTES
DM,SP_DMF0043_GET_CONTRIBUTE_MAIN_DATA,PKG_DMF0043,P_DMF0043_GET_CONTRIBUTE_MAIN_DATA,DM_MST_CONTRIBUTE_RATIO_DTL,DM_MST_CONTRIBUTE_RATIO_DTL,동일
DM,SP_DMF0043_GET_SPREAD_TITLE,PKG_DMF0043,P_DMF0043_GET_MAIN_SPREAD_TITLE,,,화면 컬럼 동적 생성
```

신규 화면 진입 시 1줄 추가 의무.

---

## §6. 변경 이력

- 2026-06-01: 폴더 신설 (Plan Stage 4). sp_body_diff / row_count_diff / column_inventory 3 sh + README + 매핑 표 양식. DMF0043 sample row 작성.

## 추가 도구 (2026-06-11 — SP 변환 파이프라인 연동)

| 스크립트 | 용도 | 파이프라인 Stage |
|---|---|---|
| `run_sql.sh` | Oracle SQL 1회 실행 wrapper (`ORA_CONN` env 또는 `.env.asis` TOBE_*, CRLF 자동 제거) | 공통 |
| `compile_check.sh` | 특정 object 또는 `--all-invalid` 재컴파일 + USER_ERRORS 리포트 (PASS/FAIL exit code) | Stage 2 |
| `silent_fail_audit.sql` | silent fail family 7종 일괄 검출 (SUBSTR-0 / TRUNCATE GT / GTT DELETE / cursor mismatch / LISTAGG / MSSQL 잔존 / EXCEPTION 가림) | Stage 3 |

> 파이프라인 본문: `Doc/_analysis/db_migration/02_SP_CONVERSION_PIPELINE.md`
