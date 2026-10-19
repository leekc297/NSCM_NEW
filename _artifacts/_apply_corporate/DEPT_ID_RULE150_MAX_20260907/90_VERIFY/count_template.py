# -*- coding: utf-8 -*-
"""P_DMF0020_GET_SALES_PRICE_TEMPLATE 커서 행수 실측 (배치 fetch·장시간 허용).

hook #150 §3 MAX 전환 전/후 대사용. 300s 하네스가 div40/81 커서1 에서 timeout 나서 분리.
사용: python count_template.py before|after [division ...]
"""
import sys
import json
import time
import hashlib
import pathlib

import oracledb

TAG = sys.argv[1]
DIVS = sys.argv[2:] or ["40", "81", "82"]
OUT = pathlib.Path(__file__).parent / f"count_{TAG}.json"
USER = "minyonglee1"
BASE = {
    "P_DEPT_ID": "ALL", "P_END_CUSTOMER": "ALL", "P_SCM_SITE_ID": "ALL", "P_PLANT_SITE_ID": "ALL",
    "P_PROJECT_CODE": "", "P_ITEM_ID": "", "P_CUSTOMER_PROJECT_CODE": "", "P_CUSTOMER_MODEL": "",
    "P_FROM_YYYYMMDD": "20260801", "P_TO_YYYYMMDD": "20270228", "P_NOW_YYYYMMDD": "20260824",
    "P_BIZTYPE": "ALL", "P_BIZ_TYPE": "ALL", "P_CREATED_BY": USER, "P_USER_ID": USER,
    "P_USERINFO": USER, "P_OWNER": "", "P_OWNER_ID": "ALL", "P_OVER_RANGE": "N",
    "P_INVALID_EXEC": "N", "P_VERSION_TYPE": "CURRENT", "P_VERSION_NO": "Current",
    "P_ITEM_TYPE": "ALL", "P_BUCKET": "MONTHLY", "P_INTERNAL_YN": "N", "P_CELL_YN": "N",
    "P_QTY_YN": "N", "P_USER_DEPT_ID": "", "P_GROUP_ID": "", "P_TEAM_ID": "ALL",
    "P_CUSTOMER": "ALL", "P_USER_GROUP": "DM ADMIN", "P_SENDER_CODE": "ALL", "P_DIFF_ONLY": "False",
}
PKG, PROC, MENU = "PKG_DMF0020", "P_DMF0020_GET_SALES_PRICE_TEMPLATE", "DMF0020"

cn = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/AJS")
cn.call_timeout = 3600000  # 1h — MAX 전 상태는 증식으로 매우 느리다
cur = cn.cursor()
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYYMMDD'")
cur.execute(
    "SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS "
    " WHERE PACKAGE_NAME=:k AND OBJECT_NAME=:o AND DATA_LEVEL=0 ORDER BY POSITION",
    k=PKG, o=PROC,
)
args = cur.fetchall()
res = {}
for div in DIVS:
    vals = {**BASE, "P_DIVISION_ID": div, "P_MENU_ID": MENU, "P_MNU_ID": MENU}
    ins, outs = [], []
    for a, io in args:
        (ins.append(vals.get(a, "")) if io == "IN" else outs.append(cn.cursor()))
    key = f"{PKG}.{PROC}|{div}"
    t0 = time.time()
    try:
        cur.callproc(f"{PKG}.{PROC}", ins + outs)
        call_s = round(time.time() - t0, 1)
        curs = []
        for i, oc in enumerate(outs):
            oc.arraysize = 5000
            t1 = time.time()
            n = 0
            h = hashlib.md5()
            try:
                while True:
                    batch = oc.fetchmany(5000)
                    if not batch:
                        break
                    n += len(batch)
                    if n <= 200000:
                        for r in batch:
                            h.update(("|".join("" if v is None else str(v) for v in r)).encode("utf-8", "ignore"))
                curs.append({"cursor": i + 1, "rows": n, "fetch_s": round(time.time() - t1, 1),
                             "hash": h.hexdigest() if n <= 200000 else None})
            except Exception as e:
                curs.append({"cursor": i + 1, "rows_so_far": n, "error": str(e)[:150]})
        res[key] = {"call_s": call_s, "cursors": curs}
        print(f"OK   {key:60s} call={call_s}s  " +
              "  ".join(f"c{c['cursor']}={c.get('rows', c.get('rows_so_far'))}"
                        f"({c.get('fetch_s', '?')}s)" for c in curs), flush=True)
    except Exception as e:
        res[key] = {"error": str(e).splitlines()[0][:200]}
        print(f"FAIL {key:60s} {str(e).splitlines()[0][:150]}", flush=True)
    cn.rollback()
OUT.write_text(json.dumps(res, indent=1, ensure_ascii=False), encoding="utf-8")
print("saved", OUT)
