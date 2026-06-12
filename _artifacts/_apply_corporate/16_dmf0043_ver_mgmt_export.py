#!/usr/bin/env python3
"""
DMF0043 기여율 버전관리 (VersionPopup) 관련 SP 변경분 → 클라우드 배포 SQL 생성.

대상 SP (사내 Oracle 의 현재 상태 = 클라우드 배포 목표):
  - DMF0043_SAVE_DM_MST_CONTRIBUTE_VER  (변경: TRUNCATE→DELETE + SUBSTR(s,0,n)→(s,1,n-1) 7건)
  - DMF0043_GET_MAIN_VARSION_DATA       (LAST_DDL today — 변경 가능성 — 동봉)

출력:
  _artifacts/_deploy_packages/DMF0043/01_SP_BODY/
    040_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER_VersionMgmt.sql
    041_DMF0043_GET_MAIN_VARSION_DATA_VersionMgmt.sql
    042_VersionMgmt_DEPLOY_README.md
    042_VersionMgmt_DEPLOY.sh   (apply script)
"""
import datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)

SPS = [
    ("DMF0043_SAVE_DM_MST_CONTRIBUTE_VER", "040_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER_VersionMgmt.sql"),
    ("DMF0043_GET_MAIN_VARSION_DATA",      "041_DMF0043_GET_MAIN_VARSION_DATA_VersionMgmt.sql"),
]

OUT_DIR = Path("C:/Projects/NSCM/_artifacts/_deploy_packages/DMF0043/01_SP_BODY")
OUT_DIR.mkdir(parents=True, exist_ok=True)


def fetch_source(conn, name):
    cur = conn.cursor()
    cur.execute(
        "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
        n=name,
    )
    body = "".join(r[0] or "" for r in cur.fetchall())
    cur.close()
    return body


def main():
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    conn = oracledb.connect(**CONN_PARAMS)
    try:
        for sp_name, fname in SPS:
            body = fetch_source(conn, sp_name)
            if not body:
                print(f"[FAIL] {sp_name} not found")
                continue

            header = (
                f"-- ========================================================================\n"
                f"-- Deploy SP body: {sp_name}\n"
                f"-- Source: 사내 Oracle (121.162.245.167:2521:ESSCMD) SCM_MGR @ {ts}\n"
                f"-- Target: 클라우드 Oracle 의 동일 schema\n"
                f"-- ========================================================================\n"
                f"-- 변경 내역 (2026-06-11 사용자 silent SAVE fail 진단 후):\n"
            )
            if "SAVE_DM_MST_CONTRIBUTE_VER" in sp_name:
                header += (
                    f"--   1) EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDMCV_RESULTS_MST_2'\n"
                    f"--      → DELETE FROM GT_SDMCV_RESULTS_MST_2\n"
                    f"--      이유: SCM_MGR DDL 권한 부족 ORA-01031 → silent EXCEPTION → DB 미반영\n"
                    f"--      메모리: feedback_sp_truncate_gtt_grant\n"
                    f"--   2) SUBSTR(v_w_X, 0, v_index_X)  →  SUBSTR(v_w_X, 1, v_index_X - 1)  (7 곳)\n"
                    f"--      이유: Oracle position=0→1 정규화로 ^ 구분자 포함 token 추출 → MERGE 매치 실패\n"
                    f"--      메모리: feedback_sp_substr_zero_index_pitfall\n"
                    f"--      hook : sp-substr-zero-index-audit.md\n"
                )
            else:
                header += (
                    f"--   LAST_DDL_TIME 변경 감지 (오늘 recompile 또는 minor fix).\n"
                    f"--   동봉 — 정합성 유지를 위해 같이 배포 권장.\n"
                )
            header += (
                f"-- ========================================================================\n"
                f"-- 실행 방법 (DBeaver / SQL*Plus 양쪽 호환):\n"
                f"--   1) 본 파일 1개를 그대로 실행 — CREATE OR REPLACE 가 기존 SP 갱신\n"
                f"--   2) 컴파일 후 STATUS=VALID 확인:\n"
                f"--      SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='{sp_name}';\n"
                f"--   3) 실 SAVE 후 DM_MST_CONTRIBUTE_VER 행 증가 확인\n"
                f"-- ========================================================================\n\n"
                f"CREATE OR REPLACE "
            )

            out_path = OUT_DIR / fname
            out_path.write_text(header + body + "\n", encoding="utf-8")
            print(f"[OK] {fname} ({len(body)} chars)")

        # README (deploy notes)
        readme = OUT_DIR / "042_VersionMgmt_DEPLOY_README.md"
        readme.write_text(
            f"""# DMF0043 기여율 버전관리 (VersionPopup) — 클라우드 배포 패키지

작성: {ts}
출처: 사내 Oracle (121.162.245.167:2521:ESSCMD) SCM_MGR

## 배포 파일

| # | 파일 | SP | 변경 내역 |
|---:|---|---|---|
| 1 | 040_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER_VersionMgmt.sql | `DMF0043_SAVE_DM_MST_CONTRIBUTE_VER` | TRUNCATE→DELETE (1) + SUBSTR(s,0,n)→(s,1,n-1) (7) |
| 2 | 041_DMF0043_GET_MAIN_VARSION_DATA_VersionMgmt.sql | `DMF0043_GET_MAIN_VARSION_DATA` | LAST_DDL 변경 (정합성 동봉) |

## 변경 이유 (1: SAVE SP)

VersionPopup 에서 신규 버전 추가/수정 후 "저장 완료" 메시지 노출되나 **DB 미반영** 사고:

### Root cause A — TRUNCATE GT_* 권한 부족
NextSCM Pilot 변환기가 MSSQL `#TEMP DROP/CREATE` 를 Oracle `EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDMCV_RESULTS_MST_2'` 로 변환.
SCM_MGR 는 DDL 권한 없음 → `ORA-01031: insufficient privileges` → SP 의 generic `EXCEPTION WHEN OTHERS` 가 catch 후 silent OK 반환.

**Fix**: `EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_*'` → `DELETE FROM GT_*` (PL/SQL DML, 권한 불요).

### Root cause B — SUBSTR(s, 0, n) Oracle pitfall
Oracle `SUBSTR(s, 0, n)` 의 position=0 은 1 로 정규화 → `SUBSTR(s, 1, n)` 과 동일.
즉 `^` 구분자 token 추출 시 token + `^` 까지 포함 → MERGE INTO 매치 실패 → silent EXCEPTION → DB 미반영.

**Fix**: 7곳 모두 `SUBSTR(v_w_X, 0, v_index_X)` → `SUBSTR(v_w_X, 1, v_index_X - 1)`.

## 배포 절차

### Step 1: 백업 (의무)
```sql
-- 클라우드 측 백업 (롤백 대비)
SET LONG 100000
SELECT DBMS_METADATA.GET_DDL('PROCEDURE','DMF0043_SAVE_DM_MST_CONTRIBUTE_VER') FROM DUAL;
SELECT DBMS_METADATA.GET_DDL('PROCEDURE','DMF0043_GET_MAIN_VARSION_DATA') FROM DUAL;
```

### Step 2: 적용
DBeaver / SQL*Plus 에서 다음 순서로 실행:
1. `040_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER_VersionMgmt.sql`
2. `041_DMF0043_GET_MAIN_VARSION_DATA_VersionMgmt.sql`

### Step 3: 검증
```sql
-- 1) STATUS=VALID
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('DMF0043_SAVE_DM_MST_CONTRIBUTE_VER','DMF0043_GET_MAIN_VARSION_DATA')
   AND OBJECT_TYPE='PROCEDURE';

-- 2) SUBSTR 패치 확인 (0건 = 모두 fix)
SELECT COUNT(*) AS substr_zero_remaining
  FROM USER_SOURCE
 WHERE NAME='DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'
   AND TYPE='PROCEDURE'
   AND REGEXP_LIKE(TEXT, 'SUBSTR\\s*\\([^,]+,\\s*0\\s*,');

-- 3) TRUNCATE 잔존 확인 (0건 = 모두 fix)
SELECT COUNT(*) AS truncate_remaining
  FROM USER_SOURCE
 WHERE NAME='DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'
   AND TYPE='PROCEDURE'
   AND UPPER(TEXT) LIKE '%TRUNCATE TABLE GT%';
```

### Step 4: 실 데이터 테스트
- VersionPopup 열고 신규 버전 추가 → 저장 → DM_MST_CONTRIBUTE_VER 행 증가 확인
- `SELECT * FROM DM_MST_CONTRIBUTE_VER ORDER BY VER_SEQ DESC FETCH FIRST 5 ROWS ONLY;`

## 롤백 절차 (만약 문제 발생 시)

```sql
-- Step 1 의 백업 DDL 을 그대로 실행하여 원복
```

## 참고

- 사내 적용 스크립트: `_artifacts/_apply_corporate/07_dmf0043_save_truncate_to_delete.py` + `08_dmf0043_save_substr_zero_fix.py`
- AS-IS 분석: `_artifacts/_diagnostics/DMF0043_SAVE_DM_MST_CONTRIBUTE_VER_*.sql` (before snapshots)
- 룰 메모리: feedback_sp_truncate_gtt_grant / feedback_sp_substr_zero_index_pitfall
""",
            encoding="utf-8",
        )
        print(f"[OK] README → {readme.name}")

        # Apply script for cloud
        apply_sh = OUT_DIR / "042_VersionMgmt_DEPLOY.sh"
        apply_sh.write_text(
            f"""#!/bin/bash
# DMF0043 기여율 버전관리 변경분 → 클라우드 적용 (예시 — 환경 변수 조정 필요)
# 사용:  ./042_VersionMgmt_DEPLOY.sh <user>/<pass>@<host>:<port>/<service>
set -e

CONN="${{1:?사용: $0 <user>/<pass>@<host>:<port>/<service>}}"
DIR="$(dirname "$0")"

echo "=== STEP 0: 백업 ==="
sqlplus -S "$CONN" <<EOF
SET LONG 100000 PAGESIZE 0 LINESIZE 200 TRIMSPOOL ON
SPOOL "$DIR/_backup_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER.sql"
SELECT DBMS_METADATA.GET_DDL('PROCEDURE','DMF0043_SAVE_DM_MST_CONTRIBUTE_VER') FROM DUAL;
SPOOL OFF
SPOOL "$DIR/_backup_DMF0043_GET_MAIN_VARSION_DATA.sql"
SELECT DBMS_METADATA.GET_DDL('PROCEDURE','DMF0043_GET_MAIN_VARSION_DATA') FROM DUAL;
SPOOL OFF
EOF

echo "=== STEP 1: SAVE SP 적용 ==="
sqlplus -S "$CONN" <"$DIR/040_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER_VersionMgmt.sql"

echo "=== STEP 2: GET SP 적용 ==="
sqlplus -S "$CONN" <"$DIR/041_DMF0043_GET_MAIN_VARSION_DATA_VersionMgmt.sql"

echo "=== STEP 3: 검증 ==="
sqlplus -S "$CONN" <<EOF
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('DMF0043_SAVE_DM_MST_CONTRIBUTE_VER','DMF0043_GET_MAIN_VARSION_DATA')
   AND OBJECT_TYPE='PROCEDURE';
EOF

echo "[DONE] 모든 STATUS=VALID 면 성공."
""",
            encoding="utf-8",
        )
        print(f"[OK] apply.sh → {apply_sh.name}")

    finally:
        conn.close()

    print(f"\n출력 디렉토리: {OUT_DIR}")
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
