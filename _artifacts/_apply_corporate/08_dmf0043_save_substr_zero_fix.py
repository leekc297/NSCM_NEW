#!/usr/bin/env python3
"""
DMF0043 SAVE SP 2종의 SUBSTR(s, 0, n) → SUBSTR(s, 1, n-1) 변환.

사고 (2026-06-11 발견):
  NextSCM Pilot 변환기가 MSSQL SUBSTRING(s, 1, n) 을 Oracle SUBSTR(s, 0, n) 로 변환.
  Oracle SUBSTR(s, 0, n) = SUBSTR(s, 1, n) (Oracle position=0 → 1) → 첫 n chars 반환.
  근데 의도는 첫 (n-1) chars (^ 구분자 제외). 따라서 token 값에 trailing '^' 포함됨.
  → GT INSERT 시 모든 값에 '^' → MERGE INTO 시 VER_SEQ='^' TO_NUMBER fail
  → SP EXCEPTION silent catch → success 반환 + DB 미변경

Fix:
  SUBSTR(v_w_<col>, 0, v_index_<col>) → SUBSTR(v_w_<col>, 1, v_index_<col> - 1)

대상 SP:
  1. DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
  2. DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
"""
import re
import datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)

SP_NAMES = [
    "DMF0043_SAVE_DM_MST_CONTRIBUTE_VER",
    "DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO",
]

BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
BACKUP_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)


def fetch_user_source(conn, name: str) -> str:
    cursor = conn.cursor()
    cursor.execute(
        "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
        n=name,
    )
    lines = [row[0] or "" for row in cursor.fetchall()]
    cursor.close()
    return "".join(lines)


def fix_one(conn, sp_name: str, log_lines: list, ts: str) -> bool:
    src = fetch_user_source(conn, sp_name)
    if not src:
        log_lines.append(f"[FAIL] {sp_name} not found")
        return False

    backup_file = BACKUP_DIR / f"{sp_name}_substr_zero_before_{ts}.sql"
    backup_file.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
    log_lines.append(f"  [{sp_name}] Backup: {len(src)} chars → {backup_file.name}")

    # 패턴: SUBSTR(v_w_<col>, 0, v_index_<col>)
    # 변환: SUBSTR(v_w_<col>, 1, v_index_<col> - 1)
    pattern = re.compile(
        r"SUBSTR\(\s*(v_w_\w+)\s*,\s*0\s*,\s*(v_index_\w+)\s*\)",
        re.I,
    )
    matches = list(pattern.finditer(src))
    log_lines.append(f"  [{sp_name}] SUBSTR(v_w_*, 0, v_index_*) 매치: {len(matches)}")

    if not matches:
        log_lines.append(f"  [{sp_name}] 패턴 0건 — 이미 fix 됐거나 다른 형태")
        return True

    patched = pattern.sub(r"SUBSTR(\1, 1, \2 - 1)", src)
    log_lines.append(f"  [{sp_name}] Patched size: {len(patched)} (delta {len(patched)-len(src)})")

    ddl = "CREATE OR REPLACE " + patched
    cursor = conn.cursor()
    try:
        cursor.execute(ddl)
        log_lines.append(f"  [{sp_name}] [OK] CREATE OR REPLACE")
    except oracledb.DatabaseError as e:
        log_lines.append(f"  [{sp_name}] [ERR] {e}")
        cursor.execute(
            "SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY SEQUENCE",
            n=sp_name,
        )
        for line, pos, text in cursor.fetchall():
            log_lines.append(f"    Line {line}:{pos}  {text}")
        return False
    finally:
        cursor.close()

    cursor = conn.cursor()
    cursor.execute(
        "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
        n=sp_name,
    )
    status_row = cursor.fetchone()
    cursor.close()
    status = status_row[0] if status_row else "?"
    log_lines.append(f"  [{sp_name}] Final STATUS: {status}")
    return status == "VALID"


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{ts}_DMF0043_SAVE_SUBSTR_ZERO_FIX.log"
    log_lines = [
        f"=== FIX: DMF0043 SAVE SP SUBSTR(s, 0, n) → SUBSTR(s, 1, n-1) ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]

    conn = oracledb.connect(**CONN_PARAMS)
    all_ok = True
    try:
        for sp in SP_NAMES:
            log_lines.append("")
            ok = fix_one(conn, sp, log_lines, ts)
            if not ok:
                all_ok = False
        conn.commit()
    finally:
        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        conn.close()

    if all_ok:
        print("[OK] DMF0043 SAVE SP 2종 SUBSTR(s,0,n) → SUBSTR(s,1,n-1) 변환 완료")
    else:
        print(f"[ERR] 일부 실패 — see {log_file}")
    return 0 if all_ok else 2


if __name__ == "__main__":
    import sys
    sys.exit(main())
