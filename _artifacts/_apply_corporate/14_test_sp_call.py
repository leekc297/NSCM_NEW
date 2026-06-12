#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST 직접 호출 test.
실제 row 반환 여부 + 첫 row sample 확인.
"""
import sys
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)


def test_call(div, ver_seq, ver_no, user, label):
    print(f"\n=== TEST {label}: div={div} ver_seq={ver_seq} ver={ver_no} ===")
    conn = oracledb.connect(**CONN_PARAMS)
    try:
        cursor = conn.cursor()
        # OUT cursor 3개
        rc_main = cursor.var(oracledb.CURSOR)
        rc_sort = cursor.var(oracledb.CURSOR)
        rc_cnt = cursor.var(oracledb.CURSOR)
        try:
            cursor.callproc(
                "DMF0043_GET_CONTRIBUTION_SALES_LIST",
                [div, str(ver_seq), ver_no, "", "", "", "N", "N", user, rc_main, rc_sort, rc_cnt],
            )
            for name, cur_var in [("main", rc_main), ("sort", rc_sort), ("cnt", rc_cnt)]:
                cur = cur_var.getvalue()
                if cur is None:
                    print(f"  {name}: None")
                    continue
                rows = cur.fetchmany(3)
                cols = [d[0] for d in cur.description] if cur.description else []
                # row count total — fetchall remaining
                remaining = sum(1 for _ in cur)
                total = len(rows) + remaining
                print(f"  {name}: total {total} rows, cols={cols[:8]}")
                for r in rows:
                    print(f"    Row: {str(r)[:200]}")
                cur.close()
        except oracledb.DatabaseError as e:
            print(f"  ERR: {e}")
    finally:
        conn.close()


def main():
    user = "minyonglee1"
    # Top 1 추천: Division 40, Year 2025, Version R_B_20250820_V008_C, VER_SEQ 8
    test_call("40", 8, "R_B_20250820_V008_C", user, "Top1 Div40 VER8 2025")
    # Top 3 추천: Division 40, Year 2026, R_S_20260205_V005_C, VER_SEQ 5
    test_call("40", 5, "R_S_20260205_V005_C", user, "Top3 Div40 VER5 2026")


if __name__ == "__main__":
    main()
