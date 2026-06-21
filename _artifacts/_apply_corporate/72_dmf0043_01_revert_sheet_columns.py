#!/usr/bin/env python3
"""
긴급 원복 — DMF0043_01 SHEET_COLUMNS UPDATE 사고 복구

사고:
  apply 70 (PROGRAM_ID: DMF0043 → DMF0043_01) + apply 71 (LRG=NULL, EDIT_FLAG DELETE)
  → title SP `DMF0043_GET_SALES_LIST_SPREAD_TITLE` body L44 `WHERE C.PROGRAM_ID = 'DMF0043'` 하드코딩
  → DMF0043 에 ContributeSalesList row 0 → SP 가 BASE 9 row 0 반환 → grid 빈 상태.

원복:
  PROGRAM_ID: DMF0043_01 → DMF0043 (apply 70 원복)
  LARGE_CLASS_LABEL_NAME = COLUMN_LABEL_NAME (apply 71 의 NULL 원복)
  EDIT_FLAG row INSERT 복원 (apply 71 의 DELETE 원복)

추후:
  사용자 요구 (admin UI Category Setup ↔ DMF0043_01 grid 연결) 만족 위해서는
  title SP body 의 PROGRAM_ID='DMF0043' 하드코딩 → 동적 (P_PROGRAM_ID 인자) 변경 필요.
  이는 SP body 변경 = Hard Boundary 분리 PR.
"""
import datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== 긴급 원복 — SHEET_COLUMNS DMF0043_01 → DMF0043 ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    try:
        # 1) PROGRAM_ID 원복 + LARGE_CLASS_LABEL_NAME 원복
        cur.execute("""
            UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
               SET PROGRAM_ID = 'DMF0043',
                   LARGE_CLASS_LABEL_NAME = COLUMN_LABEL_NAME,
                   LAST_UPDATED_BY = 'admin',
                   LAST_UPDATE_DATE = SYSDATE
             WHERE PROGRAM_ID = 'DMF0043_01' AND SHEET_NAME = 'ContributeSalesList'
        """)
        log.append(f"  [UPDATE PROGRAM_ID + LRG] rowcount: {cur.rowcount}")

        # 2) EDIT_FLAG row INSERT 복원
        cur.execute("""
            INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS
                (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
                 SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH,
                 HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DIVISION_ID,
                 DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, CREATED_BY, CREATION_DATE,
                 LAST_UPDATED_BY, LAST_UPDATE_DATE, INPUT_TP_CD)
            VALUES
                ('DMF0043', 'ContributeSalesList', 'EDIT_FLAG', 'Edit Flag', 800,
                 'Edit Flag', 'Edit Flag', 'N', 0,
                 'L', 'N', 'N', '40',
                 'N', 'Y', 'Y', 'admin', SYSDATE,
                 'admin', SYSDATE, 'S')
        """)
        log.append(f"  [INSERT EDIT_FLAG] rowcount: {cur.rowcount}")

        conn.commit()

        # 3) POST-CHECK — title SP 호출하여 BASE 9 + dynamic 18 = 27 row 복원 확인
        rc1 = cur.var(oracledb.CURSOR)
        cur.callproc('DMF0043_GET_SALES_LIST_SPREAD_TITLE', ['40', 'minyonglee1', 'DMF0043_01', rc1])
        rows = rc1.getvalue().fetchall()
        log.append(f"  [SP CHECK] title SP rows: {len(rows)} (expected 27 — BASE 9 + dynamic 18)")

        # 4) SHEET_COLUMNS 현재 상태
        cur.execute("""
            SELECT SORT_ORDER_NO, COLUMN_NAME, VISIBLE_FLAG, LARGE_CLASS_LABEL_NAME
              FROM SCM_MST_SHEET_COLUMNS
             WHERE PROGRAM_ID = 'DMF0043' AND SHEET_NAME = 'ContributeSalesList'
             ORDER BY SORT_ORDER_NO
        """)
        log.append(f"  [POST] DMF0043/ContributeSalesList:")
        for r in cur.fetchall():
            log.append(f"    SORT={r[0]:>3} COL={r[1]:<22} VIS={r[2]} LRG={r[3]}")

        log.append("  [DONE] 원복 완료 — title SP 정상 동작")
        print(f"[OK] 원복 완료 — title SP rows={len(rows)}")
    finally:
        (LOG_DIR / f"{ts}_DMF0043_01_REVERT.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
