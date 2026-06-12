#!/usr/bin/env python3
"""
V2 SP에 PARALLEL/USE_HASH/LEADING 힌트 추가 — NESTED LOOPS 비효율 해소.

진단:
  V$SQL_PLAN: CARDINALITY=1 estimate (실제 36K+), 5 단계 NESTED LOOPS
    → 매 row db file sequential read (random I/O ~2ms)
    → 36K × 5 levels × 2ms = ~360s
  바람직한 plan: HASH JOIN (한 번에 build/probe — 분 단위 단축)

Fix: INSERT INTO GT_DMF0043_SALES_LIST_C 의 SELECT 에 힌트 추가
  /*+ LEADING(A) USE_HASH(I) USE_HASH(SC) USE_HASH(B) USE_HASH(C) USE_HASH(TEAM) */

대상: DMF0043_GET_CONTRIBUTION_SALES_LIST_V2 (이미 redirect 완료된 SP)
"""
import re, datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)
SP_NAME = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V2"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"
BACKUP_DIR.mkdir(parents=True, exist_ok=True); LOG_DIR.mkdir(parents=True, exist_ok=True)


def fetch_user_source(conn, name):
    cur = conn.cursor()
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=name)
    lines = [r[0] or "" for r in cur.fetchall()]
    cur.close()
    return "".join(lines)


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = LOG_DIR / f"{ts}_DMF0043_01_V2_HINTS.log"
    log_lines = [
        f"=== V2 hints: USE_HASH + LEADING + APPEND for INSERT INTO GT_DMF0043_SALES_LIST_C ===",
        f"  TIME: {datetime.datetime.now().isoformat()}",
    ]
    conn = oracledb.connect(**CONN_PARAMS)
    cur0 = conn.cursor()
    cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 180")
    cur0.close()

    try:
        src = fetch_user_source(conn, SP_NAME)
        if not src:
            log_lines.append(f"[FAIL] {SP_NAME} not found")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            return 2

        backup = BACKUP_DIR / f"{SP_NAME}_before_hints_{ts}.sql"
        backup.write_text("CREATE OR REPLACE " + src, encoding="utf-8")
        log_lines.append(f"  [BACKUP] {len(src)} chars → {backup.name}")

        # Pattern: INSERT INTO GT_DMF0043_SALES_LIST_C ... SELECT * FROM (SELECT SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
        # 힌트 위치: 외부 SELECT * 직후 또는 내부 SELECT 직후
        # 내부 SELECT 가 메인 — 힌트는 거기에 추가
        p = re.compile(
            r"(\(\s*SELECT\s+)(SUBSTR\(A\.YYYYMMDD,1,6\)\s+AS\s+YYYYMM)",
            re.IGNORECASE,
        )
        matches = p.findall(src)
        log_lines.append(f"  [MATCH] {len(matches)} 곳 (expected 1)")
        if len(matches) != 1:
            log_lines.append(f"  [WARN] 매치 ≠ 1 — 패턴 검토 필요")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            return 3

        hint = (
            "/*+ LEADING(A) USE_HASH(I) USE_HASH(SC) USE_HASH(B) USE_HASH(C) "
            "USE_HASH(TEAM) NO_NL(I SC B C TEAM) */ "
        )
        patched = p.sub(rf"\1{hint}\2", src)

        # 추가: INSERT 자체에 APPEND 힌트 (direct-path insert — GTT 도 가능)
        # 다만 GTT 에 APPEND 는 의미 약함 (이미 새 segment). PARALLEL 도 GTT 호환 X. APPEND 만.
        patched = re.sub(
            r"INSERT\s+INTO\s+GT_DMF0043_SALES_LIST_C",
            "INSERT /*+ APPEND */ INTO GT_DMF0043_SALES_LIST_C",
            patched,
            count=1,
            flags=re.IGNORECASE,
        )

        v2_backup = BACKUP_DIR / f"{SP_NAME}_after_hints_{ts}.sql"
        v2_backup.write_text("CREATE OR REPLACE " + patched, encoding="utf-8")
        log_lines.append(f"  [PATCHED] size: {len(patched)} (delta {len(patched)-len(src)}) → {v2_backup.name}")

        cur = conn.cursor()
        try:
            cur.execute("CREATE OR REPLACE " + patched)
            conn.commit()
            log_lines.append(f"  [OK] CREATE OR REPLACE {SP_NAME}")
        except oracledb.DatabaseError as e:
            log_lines.append(f"  [ERR] {e}")
            cur.execute(
                "SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY SEQUENCE",
                n=SP_NAME,
            )
            for ln, pos, text in cur.fetchall():
                log_lines.append(f"    Line {ln}:{pos}  {text}")
            log_file.write_text("\n".join(log_lines), encoding="utf-8")
            return 4
        finally:
            cur.close()

        cur = conn.cursor()
        cur.execute(
            "SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'",
            n=SP_NAME,
        )
        row = cur.fetchone()
        cur.close()
        status = row[0] if row else "?"
        log_lines.append(f"  [STATUS] {status}")

        log_file.write_text("\n".join(log_lines), encoding="utf-8")
        if status == "VALID":
            print(f"[OK] {SP_NAME} hints 적용 완료 (STATUS=VALID)")
            return 0
        print(f"[ERR] STATUS={status}")
        return 5
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
