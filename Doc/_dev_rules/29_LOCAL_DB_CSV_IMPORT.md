# 29. 로컬 Docker Oracle CSV 적재 표준 — sqlldr + 12GB 한도

> ⭐ **한 줄 요약**: 로컬 Docker Oracle Free Edition (12 GB 한도) 에 사용자 제공 CSV 를 적재할 때의 표준 패턴 + 사고 회피 절차.
> 작성: 2026-05-30
> 관련 룰: [21_TROUBLESHOOTING.md](21_TROUBLESHOOTING.md) §10 / [22_PACKAGE_ARTIFACTS.md](22_PACKAGE_ARTIFACTS.md)
> 관련 hook: [hooks/anti-simplification.md](hooks/anti-simplification.md)
> 적용 시점: 사용자 폴더 (예: `C:\TRANFILE\DB\DATA\`) 에 받은 CSV/DDL 을 로컬 컨테이너에 적재할 때

---

## §1. 배경

NSCM 로컬 개발 환경은 사내 클라우드 Oracle 대신 **Docker `gvenzl/oracle-free:23-slim-faststart`** 를 사용. Oracle Database Free Edition 의 라이센스 한도 (12 GB user data, single-pluggable-DB) 와 사용자 제공 CSV 의 데이터 형태 (multi-line SQL, `\r\n` line ending, 한글 UTF-8) 가 결합되어 매 적재마다 동일한 패턴의 사고가 반복됨.

본 룰은 그 패턴을 표준화하여 다음 적재 작업이 첫 시도에서 성공하도록 함.

---

## §2. 적재 범위 룰 (사용자 명시)

> **트리거 약속** (2026-05-30 사용자 명시):
> - **CSV 200 MB 이하** → **전체 이관** (모든 division)
> - **CSV 200 MB 초과** → **division 40 / 81 만 이관**
> - **DM_\* 테이블** → **기본 제외** (화면별로 필요 시 점진 적재)

| 카테고리 | 적재 정책 |
|---|---|
| `SCM_ADM_*` (메뉴/권한/메타) | 전체 |
| `SCM_MST_*` (마스터) | 전체 |
| `SCM_SYS_*` (시스템) | 전체 |
| `SCM_ITEM_M`, `FP_MGR.*`, `SCM_CODE_*`, `SCM_COM_*` | 전체 |
| `DM_*` (Demand 도메인 데이터) | 기본 제외, 화면 작업 시 SP 의 사용 테이블 확인 후 해당 CSV 만 적재 |

CSV 적재 결정 매트릭스:
```
size = (Get-Item $csv).Length / 1MB
if (size -le 200) { 전체 이관 } else { div in (40,81) 만 filter }
```

---

## §3. sqlldr 표준 ctl 자동 생성 — 6가지 필수 처리

CSV → Oracle 적재 시 sqlldr ctl 에 다음 6가지 가 모두 들어가야 첫 시도에 성공.

### 3.1 Windows CSV 의 `\r\n` 처리 — 마지막 컬럼 `\r` 잔존

**증상**: `ORA-12899: value too large for column "X" (actual: 2, maximum: 1)` — 마지막 컬럼 길이 1 인데 들어가는 값이 2 자.

**원인**: Windows CSV 는 `,LAST\r\n`. sqlldr 가 마지막 컬럼 값에 `\r` 포함하여 잔존. 사용자 데이터 `'N'` 이 `'N\r'` (2 chars) 가 됨.

**해결 (ctl 의 마지막 컬럼에만)**:
```sql
"LAST_COL" CHAR(4000) "REPLACE(:LAST_COL, CHR(13), '')"
```

### 3.2 컬럼명 quote — Reserved word / digit 시작

**증상**: `ORA-00903: invalid table name` 또는 `ORA-03050: 'LEVEL' is a reserved word` 또는 ctl 의 `SQL*Loader-350: syntax error` (e.g. `2LEVEL_DEPT_ID`).

**원인**: Oracle reserved word (`LEVEL`, `DATE`, `DESC`, `KEY`, `USER`, `ORDER`, `GROUP`, `COMMENT`) 또는 숫자로 시작하는 컬럼명 (`2LEVEL_DEPT_ID`) 이 unquoted 면 syntax error.

**해결 (ctl 의 field-list 의 모든 컬럼명을 quote)**:
```sql
"COL_NAME" CHAR(4000)
-- bind reference는 unquoted 유지:
"COL_NAME" "to_date(SUBSTR(:COL_NAME,1,19),'YYYY-MM-DD HH24:MI:SS')"
```

**금지**: bind reference 안에서 `:"COL_NAME"` (sqlldr 가 인식 못함, `ORA-06550`).

### 3.3 DATE / TIMESTAMP — millisecond 처리

**증상**: CSV 값 `'2026-04-01 15:24:11.000'` (milliseconds 포함) → DATE 컬럼에 직접 매핑 시 `ORA-01861: literal does not match format string`.

**해결**:
```sql
-- DATE 컬럼:
"CREATION_DATE" "to_date(SUBSTR(:CREATION_DATE,1,19),'YYYY-MM-DD HH24:MI:SS')"
-- TIMESTAMP 컬럼:
"XLS_PWD_CHG_DATE" "to_timestamp(:XLS_PWD_CHG_DATE,'YYYY-MM-DD HH24:MI:SS.FF3')"
```

### 3.4 컬럼 메타 dump 의 `(N,M)` precision/scale — regex 함정

**증상**: TIMESTAMP(6) / NUMBER(20,10) / VARCHAR2(30 CHAR) 등 괄호 포함 type 이 컬럼 메타 dump 의 단순 regex `^([A-Z0-9_]+)\t(\d+)\t([A-Z0-9_]+)\t([A-Z0-9]+)$` 에 매칭 안 되어 **컬럼 자체가 ctl 에서 누락** → CSV 의 컬럼이 옆 컬럼으로 시프트 → NOT NULL violation 또는 데이터 corruption.

**해결**: type 매칭은 `\t(.+)$` (greedy to end) 로 하고 base type 만 stripped 사용.
```powershell
if ($line -match "^([A-Z0-9_]+)`t(\d+)`t([A-Z0-9_]+)`t(.+)$") {
  $dt = ($matches[4].Trim() -replace '\(.+?\)$','')   # TIMESTAMP(6) → TIMESTAMP
}
```

### 3.5 Multi-line quoted CSV records

**증상**: CSV 의 한 row 가 여러 줄 (quoted field 안에 newline). sqlldr 가 record 잘못 분리 → ORA-01400 NOT NULL / 데이터 corruption (`SUMMARY_BUCKET_VALUE='EDIT_FLA'` 같이 다른 컬럼 값이 이상한 곳에 들어감).

**해결**: 사전 처리로 quoted field 안의 `\r\n` / `\n` 를 space 로 변환.
```powershell
# 상태머신: " 만나면 inQuoted toggle, inQuoted 안의 newline 만 space 치환
# 참고: _artifacts/local-docker-oracle/fix_multiline_csv.ps1
```

### 3.6 NOT NULL constraint relax (사용자 명시 승인 후)

**증상**: 새 DDL 의 NOT NULL 제약이 CSV 의 빈 값과 충돌 → `ORA-01400: cannot insert NULL into ...`.

**해결**: 사용자 명시 승인 후 NOT NULL 일괄 relax.
```sql
ALTER TABLE SCM_MGR.<TBL> MODIFY (<COL> NULL);
```

**금지**: 사용자 승인 없이 자동 relax (스키마 무결성 변경).

---

## §4. DDL clean replace 시 PL/SQL `/` 종료자 자동 삽입

**증상**: `09_packages_*.sql` / `07_functions.sql` / `08_procedures_*.sql` 등 PL/SQL 파일 적재 후 `PACKAGE BODY: 0 / FUNCTION: 0 / PROCEDURE: 0` — 객체 미생성.

**원인**: DBA dump 로 만든 DDL 파일에 `CREATE OR REPLACE PROCEDURE ... END xxx;` 다음 줄에 `/` (PL/SQL 종료자) 가 없음. sqlplus 가 다음 `CREATE` 로 PL/SQL block 이 종료되었다고 판단 못 함.

**해결**: 적재 전 PowerShell 으로 자동 삽입 (참고: `_artifacts/local-docker-oracle/add_slash_to_ddl.ps1`).
- 대상: `02_types.sql`, `06_views.sql`, `07_functions.sql`, `08_procedures_*.sql`, `09_packages_*.sql`
- 패턴: 각 `CREATE OR REPLACE (TYPE|FUNCTION|PROCEDURE|PACKAGE|VIEW|TRIGGER)` block 의 끝 (`END ...;`) 다음 줄에 `/` 추가.
- TABLE / INDEX / SEQUENCE / SYNONYM 은 `;` 만으로 OK (불필요).

---

## §5. sqlplus `$$PLSQL_UNIT` substitution 이슈

**증상**: source 파일에 `$$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;` 가 있는데 적재 후 DB source 에서는 `$PLSQL_UNIT` (single `$`) 로 변환됨 → `PLS-00181: unsupported preprocessor directive '$PLSQL_UNIT'`.

**원인**: sqlplus 의 `&` substitution. `$$` 가 PowerShell 또는 sqlplus 처리 단계에서 single `$` 로 변환.

**해결 순서** (한 단계로 안 되면 다음):
1. SQL 파일 첫 줄에 `SET DEFINE OFF` 추가 (대부분 해결).
2. `$$PLSQL_UNIT` 변수 선언/할당 부분을 `v_plsql_unit VARCHAR2(150 CHAR) := $$PLSQL_UNIT;` 로 rename (PKG_SCM0000 사례).
3. **회피 패턴**: PKG body 안 procedure 를 standalone 으로 분리해야 할 때, 가능하면 **현재 DB 의 valid procedure source 를 `dba_source` 에서 직접 dump 하여 사용** — 이미 컴파일 OK 인 source 라 위 변환 이슈가 없음.

---

## §6. 표준 적재 순서 (전체 reset 시)

```
1. 컨테이너 재생성        (docker compose down -v && up -d)
2. SCM_MGR 사용자 + role  (00_create_schema.sql)
3. tablespace 생성        (01_create_tablespaces.sql)
4. DDL clean replace      (§4 적용 후 02_types → 09_packages → 11_synonyms)
5. CSV 적재               (§2 범위 + §3 ctl 표준 + 200 MB 임계)
6. 사용자 메타 시드       (30_DMF0043 등 _artifacts/*.sql)
7. minyonglee1 권한 보강  (USER_M / GR_MPG / UGA × 모든 division)
8. INVALID 재컴파일       (DBMS_UTILITY.COMPILE_SCHEMA + ALTER ... COMPILE BODY)
9. BE 재기동              (MyBatis Query Cache 재로드 — §7 참조)
```

---

## §7. BE 재기동이 필요한 케이스 — MyBatis Query Cache

`SCM_ADM_CMBO_SQL_M` 의 row 변경 (CSV reload 등) 후 BE 가 stale cache 로 `Query is not exist` 반환. SP 이외에 BE 가 시작 시 한 번 cache 하는 메타 테이블이 다수 있음.

**원칙**: 다음 테이블 변경 후 BE 재기동 (또는 사용자에게 안내):
- `SCM_ADM_CMBO_SQL_M`
- `SCM_MST_SHEET_COLUMNS`
- `SCM_ADM_API_M`
- `SCM_ADM_PROC_M`
- `SCM_ADM_MNU_M`

BE 재기동 후 사용자에게 **시크릿 창 재로그인** 안내 (메모리 `feedback_be_restart_login.md`).

---

## §8. 자동화 스크립트 위치

| 스크립트 | 용도 |
|---|---|
| `_artifacts/local-docker-oracle/bulk_load_csv.ps1` | ctl 자동 생성 + sqlldr 일괄 호출 |
| `_artifacts/local-docker-oracle/fix_multiline_csv.ps1` | quoted field 의 newline → space (§3.5) |
| `_artifacts/local-docker-oracle/add_slash_to_ddl.ps1` | DDL 의 `/` 종료자 자동 삽입 (§4) |
| `_artifacts/local-docker-oracle/load_all.ps1` | 처음 reset 시 step 2~4 자동화 |
| `_artifacts/local-docker-oracle/relax_not_null.sql` | NOT NULL 일괄 relax (§3.6) |

---

## §9. 사고 회피 체크리스트 (적재 시작 전)

- [ ] 컨테이너 healthy 상태 (`DATABASE IS READY TO USE`)
- [ ] FREEPDB1 = `OPEN READ WRITE` (`SELECT name, open_mode FROM v$pdbs;`)
- [ ] 디스크 사용량 확인 (`du -sh /opt/oracle/oradata/FREE/FREEPDB1/`) — 12 GB 한도 대비 여유
- [ ] 적재 대상 CSV 가 200 MB 임계 분류됨 (§2)
- [ ] `DM_*` 제외 확인 (§2)
- [ ] ctl 의 6가지 처리 (§3) 모두 적용
- [ ] DDL 적재라면 `/` 종료자 (§4) 자동 삽입 완료
- [ ] 사용자 시드 (DMF 메뉴/메타) 가 CSV 보다 **나중에** 실행되도록 순서 보장
