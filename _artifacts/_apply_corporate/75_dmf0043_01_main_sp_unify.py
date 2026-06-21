#!/usr/bin/env python3
"""
main SP `DMF0043_GET_CONTRIBUTION_SALES_LIST` body 의 PL/SQL 변수 'DMF0043' → 'DMF0043_01'.
L95: `va_program_id := 'DMF0043';` 이 SHEET_COLUMNS WHERE 절에서 사용 → 동적 SQL build →
   DMF0043 row 삭제 후 column 0 → main SELECT 결과 0.
"""
import re, datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== main SP unify ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    try:
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP)
        src = "".join((r[0] or "") for r in cur.fetchall())
        log.append(f"  [BACKUP] {len(src)} chars")
        (BACKUP_DIR / f"{SP}_unify_before_{ts}.sql").write_text("CREATE OR REPLACE " + src, encoding="utf-8")

        hits = len(re.findall(r"'DMF0043'", src))
        log.append(f"  [SCAN] 'DMF0043' literal hits: {hits}")
        if hits == 0:
            log.append("  [SKIP] no hits")
            (LOG_DIR / f"{ts}_MAIN_SP_UNIFY.log").write_text("\n".join(log), encoding="utf-8")
            return 0
        patched = src.replace("'DMF0043'", "'DMF0043_01'")
        try:
            cur.execute("CREATE OR REPLACE " + patched)
            conn.commit()
            log.append("  [CREATE OR REPLACE] OK")
        except oracledb.DatabaseError as e:
            log.append(f"  [ERR] {e}")
            cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n ORDER BY SEQUENCE", n=SP)
            for ln, pos, text in cur.fetchall():
                log.append(f"    L{ln}:{pos} {text}")
            return 5

        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=SP)
        status = cur.fetchone()[0]
        log.append(f"  [STATUS] {status}")

        # main SP 호출 검증 — verSeq=12 (2024) + REPORT_BP_M 최근 version
        rc_m = cur.var(oracledb.CURSOR); rc_s = cur.var(oracledb.CURSOR); rc_c = cur.var(oracledb.CURSOR)
        cur.callproc(SP, ['40', '12', 'R_B_20260223_V001', '', 'ALL', 'ALL', 'N', 'N', 'minyonglee1', rc_m, rc_s, rc_c])
        mrows = rc_m.getvalue().fetchall()
        cnt_rows = rc_c.getvalue().fetchall()
        log.append(f"  [CHECK 1] verSeq=12 (2024) + R_B_20260223_V001: main_rows={len(mrows)} cnt={cnt_rows[0][0] if cnt_rows else 'N/A'}")

        # 추가 verSeq 시도
        for ver_seq, label in [('8', '2023'), ('9', '2025'), ('7', '2022')]:
            for vno in ['R_B_20260223_V001', 'R_S_20260311_V002_C']:
                rc_m2 = cur.var(oracledb.CURSOR); rc_s2 = cur.var(oracledb.CURSOR); rc_c2 = cur.var(oracledb.CURSOR)
                cur.callproc(SP, ['40', ver_seq, vno, '', 'ALL', 'ALL', 'N', 'N', 'minyonglee1', rc_m2, rc_s2, rc_c2])
                r2 = rc_m2.getvalue().fetchall()
                if r2:
                    log.append(f"  [✓] verSeq={ver_seq} ({label}) + {vno}: main_rows={len(r2)}")

        print(f"[OK] STATUS={status}, main_rows(test)={len(mrows)}")
    finally:
        (LOG_DIR / f"{ts}_MAIN_SP_UNIFY.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
