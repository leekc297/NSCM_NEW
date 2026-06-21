#!/usr/bin/env python3
"""
DMF0043_01 SHEET_COLUMNS — DMF0043 master 와 정합화
  - LARGE_CLASS_LABEL_NAME = NULL (TWO_DEPTH 판정 — master 와 동일)
  - EDIT_FLAG row DELETE (FE 미사용 + dynamic 18 영역 침범 사고)

Root cause:
  DMF0043 master sheet=main : SML 채워짐, LRG=NULL → wrapper TWO_DEPTH (24+24=48)
  DMF0043_01 sheet=Cont... : SML/LRG 둘 다 채워짐 → wrapper ONE_DEPTH (48)
  ONE_DEPTH static + 2단 dynamic 동시 시 row 수 불일치 → header 높이 사고 + dynamic align 깨짐.
"""
import datetime
from pathlib import Path
import oracledb

CONN = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn="121.162.245.167:2521/OCGSCMD_P01",
)

LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== DMF0043_01 SHEET_COLUMNS align master ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    try:
        # 1) LARGE_CLASS_LABEL_NAME = NULL
        cur.execute(
            "UPDATE SCM_MST_SHEET_COLUMNS SET LARGE_CLASS_LABEL_NAME=NULL, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE PROGRAM_ID='DMF0043_01' AND SHEET_NAME='ContributeSalesList'"
        )
        log.append(f"  [UPDATE LRG=NULL] rowcount: {cur.rowcount}")

        # 2) EDIT_FLAG row DELETE
        cur.execute(
            "DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043_01' AND SHEET_NAME='ContributeSalesList' AND COLUMN_NAME='EDIT_FLAG'"
        )
        log.append(f"  [DELETE EDIT_FLAG] rowcount: {cur.rowcount}")

        conn.commit()

        # POST-CHECK
        cur.execute(
            "SELECT SORT_ORDER_NO, COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043_01' AND SHEET_NAME='ContributeSalesList' ORDER BY SORT_ORDER_NO"
        )
        rows = cur.fetchall()
        log.append(f"  [POST] DMF0043_01/ContributeSalesList row: {len(rows)} (expected 9)")
        for r in rows:
            log.append(f"    SORT={r[0]:>3} COL={r[1]:<22} LBL={r[2]:<12} SML={r[3]} LRG={r[4]}")

        log.append("  [DONE]")
        print("[OK] 완료")
    finally:
        (LOG_DIR / f"{ts}_DMF0043_01_ALIGN_MASTER.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
