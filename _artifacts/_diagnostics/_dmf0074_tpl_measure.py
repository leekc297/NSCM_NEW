#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0074_tpl_measure.py — DMF0074 Excel Form(Template) 조회 건수 실측

P_DMF0074_GET_METAL_LINK_TEMPLATE 을 division 별로 실제 호출해 O_RC1 행수를 센다.
(읽기 전용 — OPEN CURSOR 만. 원장 변경 없음)

사용: python _dmf0074_tpl_measure.py [라벨]
"""
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

DIVISIONS = ["40", "81", "81_UC", "82"]
USER_ID = "minyonglee1"
MENU_ID = "DMF0074"


def main():
    import ora

    label = sys.argv[1] if len(sys.argv) > 1 else "measure"
    u, p, d = ora.conn_info()
    con = None
    for _ in range(10):
        try:
            con = oracledb.connect(user=u, password=p, dsn=d)
            break
        except Exception:  # noqa: BLE001
            time.sleep(10)
    if con is None:
        raise SystemExit("접속 실패")
    cur = con.cursor()

    print(f"[{label}] P_DMF0074_GET_METAL_LINK_TEMPLATE 조회 건수")
    print("=" * 80)
    print("DIVISION | O_RC1 행수 | 판정")
    print("-" * 80)
    for dv in DIVISIONS:
        rc1 = cur.var(oracledb.DB_TYPE_CURSOR)
        rc2 = cur.var(oracledb.DB_TYPE_CURSOR)
        try:
            cur.callproc(
                "SCM_MGR.PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE",
                [dv, USER_ID, MENU_ID, rc1, rc2],
            )
            rows = rc1.getvalue().fetchall()
            n = len(rows)
            print(f"{dv} | {n} | {'정상(템플릿 표시)' if n > 0 else '0건 → MSG00656 안내'}")
        except Exception as e:  # noqa: BLE001
            print(f"{dv} | ERROR | {str(e)[:90]}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
