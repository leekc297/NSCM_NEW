#!/usr/bin/env python3
"""
DMF0043_01 SHEET_COLUMNS 신규 INSERT (DMF0043 master row 와 분리)

배경:
  - title SP `DMF0043_GET_SALES_LIST_SPREAD_TITLE` body 가 PROGRAM_ID='DMF0043' 하드코딩 →
    DMF0043 row 유지 필요 (title SP 호출 시 BASE 9 row 사용)
  - BE admin endpoint `/admin/menu/{mnuId}/column` 은 PROGRAM_ID=mnuId query →
    DMF0043_01 화면이 admin meta 사용 위해 PROGRAM_ID='DMF0043_01' row 필요
  - DMF0002_GET_TITLESET_POPUP 도 P_PROGRAM_ID 인자 사용 → DMF0043_01 row 필요
  - 사용자 권한 사고: menuId='DMF0043' (master) 사용 시 사용자 권한 없음 → 401/403

해결:
  DMF0043_01 row 별도 INSERT (BASE 9 컬럼만, LRG=NULL → wrapper TWO_DEPTH 판정).
  DMF0043 master row 는 그대로 (title SP body 의 PROGRAM_ID='DMF0043' 하드코딩 유지).
"""
import datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

# BASE 9 컬럼 (DMF0043 master 와 동일) — LRG=NULL (wrapper TWO_DEPTH 판정용)
ROWS = [
    # (SORT, COL_NM, COL_LBL, COL_WTH, ALG, VIS, FIX)
    (10,  'YYYYMM',             '년월',        100, 'L', 'Y', 'N'),
    (20,  'DEPARTMENT_NAME',    '부문',        100, 'L', 'Y', 'N'),
    (30,  'DEPT_NAME',          '팀',          100, 'L', 'Y', 'N'),
    (40,  'CUST_REPORT',        '고객군(보고)', 100, 'L', 'Y', 'N'),
    (50,  'END_CUST_REPORT',    '고객군',      100, 'L', 'Y', 'N'),
    (60,  'SHIPTO_CODE',        '판매처코드',   100, 'L', 'Y', 'N'),
    (70,  'SOLDTO_CUST_REPORT', '판매처',      100, 'L', 'Y', 'N'),
    (80,  'PRODUCT_GROUP',      '제품군',      100, 'L', 'Y', 'N'),
    (100, 'DM_BIZ_TYPE',        'Biz',         100, 'L', 'Y', 'N'),
]

def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== DMF0043_01 SHEET_COLUMNS INSERT ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    try:
        # PRE-CHECK 중복 방지
        cur.execute(
            "SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043_01' AND SHEET_NAME='ContributeSalesList'"
        )
        existing = cur.fetchone()[0]
        log.append(f"  [PRE] DMF0043_01/ContributeSalesList 기존 row: {existing}")
        if existing > 0:
            cur.execute(
                "DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043_01' AND SHEET_NAME='ContributeSalesList'"
            )
            log.append(f"  [DELETE existing] rowcount: {cur.rowcount}")

        # INSERT 9 row — SMALL=COL_LABEL, LARGE=NULL (wrapper TWO_DEPTH 판정용)
        for sort_ord, col_nm, col_lbl, col_wth, alg, vis, fix in ROWS:
            cur.execute(
                """
                INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS
                    (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO,
                     SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH,
                     HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DIVISION_ID,
                     DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, CREATED_BY, CREATION_DATE,
                     LAST_UPDATED_BY, LAST_UPDATE_DATE, INPUT_TP_CD)
                VALUES
                    ('DMF0043_01', 'ContributeSalesList', :col_nm, :col_lbl, :sort_ord,
                     :col_lbl, NULL, :fix, :col_wth,
                     :alg, 'N', :vis, '40',
                     'Y', 'Y', 'Y', 'admin', SYSDATE,
                     'admin', SYSDATE, 'S')
                """,
                col_nm=col_nm, col_lbl=col_lbl, sort_ord=sort_ord, col_wth=col_wth,
                alg=alg, vis=vis, fix=fix,
            )
        conn.commit()
        log.append(f"  [INSERT] 9 row OK")

        # POST-CHECK
        cur.execute(
            "SELECT SORT_ORDER_NO, COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, VISIBLE_FLAG FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043_01' AND SHEET_NAME='ContributeSalesList' ORDER BY SORT_ORDER_NO"
        )
        for r in cur.fetchall():
            log.append(f"    SORT={r[0]:>3} COL={r[1]:<22} LBL={r[2]:<12} SML={r[3]} LRG={r[4]} VIS={r[5]}")

        # DMF0002 SP 호출하여 9 row 반환 확인
        rc = cur.var(oracledb.CURSOR)
        cur.callproc('DMF0002_GET_TITLESET_POPUP', ['DMF0043_01', 'ContributeSalesList', 'C', 'minyonglee1', '40', 'DMF0043_01', rc])
        popup_rows = rc.getvalue().fetchall()
        log.append(f"  [POPUP SP CHECK] DMF0002 rows: {len(popup_rows)} (expected 9)")

        # title SP 도 27 row 그대로 (DMF0043 row 사용)
        rc1 = cur.var(oracledb.CURSOR)
        cur.callproc('DMF0043_GET_SALES_LIST_SPREAD_TITLE', ['40', 'minyonglee1', 'DMF0043_01', rc1])
        title_rows = rc1.getvalue().fetchall()
        log.append(f"  [TITLE SP CHECK] title rows: {len(title_rows)} (expected 27 — BASE 9 + dynamic 18)")

        log.append("  [DONE]")
        print(f"[OK] INSERT 완료 — popup_rows={len(popup_rows)}, title_rows={len(title_rows)}")
    finally:
        (LOG_DIR / f"{ts}_DMF0043_01_INSERT.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
