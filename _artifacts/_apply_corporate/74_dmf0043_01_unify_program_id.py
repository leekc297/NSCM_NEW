#!/usr/bin/env python3
"""
DMF0043_01 SHEET_COLUMNS PROGRAM_ID 통합 — DMF0043 → DMF0043_01

사용자 명시 (2026-06-19) — admin UI Category Setup 의 데이터를 DMF0043_01 에서 사용 시
모두 'DMF0043_01' PROGRAM_ID 로 등록.

작업:
  1) SP body `DMF0043_GET_SALES_LIST_SPREAD_TITLE` 의 L44 'DMF0043' → 'DMF0043_01' UPDATE
  2) DMF0043 + ContributeSalesList 10 row DELETE (DMF0043_01 자체 9 row 사용)

검증:
  - title SP 호출 시 BASE 9 (DMF0043_01) + dynamic 18 = 27 row 반환
  - admin endpoint 도 PROGRAM_ID='DMF0043_01' query → 9 row
  - DMF0002 popup SP 도 PROGRAM_ID='DMF0043_01' query → 9 row
"""
import re
import datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
SP_NAME = "DMF0043_GET_SALES_LIST_SPREAD_TITLE"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== DMF0043_01 PROGRAM_ID unify ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    try:
        # === Phase 1: SP body BACKUP + UPDATE 'DMF0043' → 'DMF0043_01' ============
        cur.execute(
            "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP_NAME
        )
        src = "".join((r[0] or "") for r in cur.fetchall())
        log.append(f"  [BACKUP] {len(src)} chars")
        (BACKUP_DIR / f"{SP_NAME}_unify_before_{ts}.sql").write_text("CREATE OR REPLACE " + src, encoding="utf-8")

        # 'DMF0043' 만 하드코딩 → 'DMF0043_01' (정확 매칭 — quoted string)
        # SP body L44 의 `WHERE C.PROGRAM_ID = 'DMF0043'` 가 유일 — 패턴 확인
        before_hits = len(re.findall(r"'DMF0043'", src))
        log.append(f"  [SCAN] 'DMF0043' literal hits: {before_hits} (expected 1)")
        if before_hits == 0:
            log.append("  [FAIL] 'DMF0043' literal 0 hit")
            return 2
        patched = src.replace("'DMF0043'", "'DMF0043_01'")
        after_hits = len(re.findall(r"'DMF0043'(?!_01')", patched))
        log.append(f"  [VERIFY-INTERNAL] 'DMF0043' (unprefixed) 잔존: {after_hits} (expected 0)")

        cur.execute("CREATE OR REPLACE " + patched)
        conn.commit()
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=SP_NAME)
        status = cur.fetchone()[0]
        log.append(f"  [SP STATUS] {status}")
        if status != "VALID":
            log.append("  [FAIL] SP INVALID")
            return 3

        # === Phase 2: DMF0043 ContributeSalesList row DELETE ====================
        cur.execute(
            "DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='ContributeSalesList'"
        )
        log.append(f"  [DELETE DMF0043 row] rowcount: {cur.rowcount}")
        conn.commit()

        # === Phase 3: 검증 — SP 호출 ==========================================
        rc1 = cur.var(oracledb.CURSOR)
        cur.callproc(SP_NAME, ['40', 'minyonglee1', 'DMF0043_01', rc1])
        rows = rc1.getvalue().fetchall()
        log.append(f"  [TITLE SP CHECK] rows: {len(rows)} (expected 27 — BASE 9 from DMF0043_01 + dynamic 18)")

        rc2 = cur.var(oracledb.CURSOR)
        cur.callproc('DMF0002_GET_TITLESET_POPUP', ['DMF0043_01', 'ContributeSalesList', 'C', 'minyonglee1', '40', 'DMF0043_01', rc2])
        popup_rows = rc2.getvalue().fetchall()
        log.append(f"  [POPUP SP CHECK] DMF0002 rows: {len(popup_rows)} (expected 9)")

        # 최종 SHEET_COLUMNS 상태
        cur.execute(
            "SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE SHEET_NAME='ContributeSalesList' GROUP BY PROGRAM_ID, SHEET_NAME"
        )
        log.append("  [POST] SHEET_COLUMNS ContributeSalesList:")
        for r in cur.fetchall():
            log.append(f"    PROG={r[0]:<12} SHT={r[1]:<22} count={r[2]}")

        log.append("  [DONE] PROGRAM_ID unify 완료 — DMF0043_01 단일 source")
        print(f"[OK] title={len(rows)}, popup={len(popup_rows)}")
    finally:
        (LOG_DIR / f"{ts}_DMF0043_01_UNIFY.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
