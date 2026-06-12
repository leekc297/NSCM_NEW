#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST 다중 조건 test (ORDER BY patch 적용 후).
어떤 (Division, VER_SEQ, Version) 조합에서 실제 row 가 나오는지 확인.
"""
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)

TESTS = [
    ("Div40 VER12 SP_W 2025", "40", 12, "R_S_20250820_V012_C"),
    ("Div40 VER5  SP_W 2026", "40", 5,  "R_S_20260205_V005_C"),
    ("Div40 VER8  BP_M 2025", "40", 8,  "R_B_20250820_V008_C"),
    ("Div40 VER10 BP_M 2025", "40", 10, "R_B_20250523_V010"),
    ("Div40 VER10 SP_W 2025", "40", 10, "R_S_20250820_V010"),
]


def main():
    conn = oracledb.connect(**CONN_PARAMS)
    print(f"{'Test':<30} {'main':>6} {'cnt':>6}")
    print("-" * 50)
    for label, div, ver_seq, ver_no in TESTS:
        cur = conn.cursor()
        rc_main = cur.var(oracledb.CURSOR)
        rc_sort = cur.var(oracledb.CURSOR)
        rc_cnt = cur.var(oracledb.CURSOR)
        try:
            cur.callproc(
                "DMF0043_GET_CONTRIBUTION_SALES_LIST",
                [div, str(ver_seq), ver_no, "", "", "", "N", "N", "minyonglee1",
                 rc_main, rc_sort, rc_cnt],
            )
            main_cur = rc_main.getvalue()
            cnt_cur = rc_cnt.getvalue()
            main_rows = sum(1 for _ in main_cur) if main_cur else 0
            cnt_val = "?"
            if cnt_cur:
                cnt_row = cnt_cur.fetchone()
                cnt_val = cnt_row[0] if cnt_row else "?"
            print(f"{label:<30} {main_rows:>6} {cnt_val:>6}")
            if main_cur: main_cur.close()
            if cnt_cur: cnt_cur.close()
        except oracledb.DatabaseError as e:
            print(f"{label:<30} ERR: {str(e).splitlines()[0]}")
        cur.close()
    conn.close()


if __name__ == "__main__":
    main()
