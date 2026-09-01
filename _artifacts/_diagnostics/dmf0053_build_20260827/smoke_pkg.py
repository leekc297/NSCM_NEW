# -*- coding: utf-8 -*-
"""PKG_DMF0053 R 스모크 — 40/81/82 직접 실행 (DBMS_OUTPUT + ref cursor 실측)"""
import io, sys, os, time
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

def get_conn():
    import re
    env = io.open(r"C:\Projects\NSCM\.env.asis", encoding="utf-8").read()
    d = dict(re.findall(r'^(TOBE_DB_\w+)=(.*)$', env, re.M))
    return oracledb.connect(user=d["TOBE_DB_USER"], password=d["TOBE_DB_PASS"],
                            dsn=f"{d['TOBE_DB_HOST']}:{d['TOBE_DB_PORT']}/{d['TOBE_DB_PDB']}")

conn = get_conn()
cur = conn.cursor()
cur.callproc("DBMS_OUTPUT.ENABLE", [None])

FROM_, TO_ = "20260101", "20260630"
CF, CT = "20260101", "20260331"

for div in ["40", "81", "82"]:
    print(f"\n===== division {div} =====")
    # 타이틀
    t0 = time.time()
    orc1 = cur.var(oracledb.DB_TYPE_CURSOR); ores = cur.var(oracledb.DB_TYPE_CURSOR)
    try:
        cur.callproc("PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE",
                     [FROM_, TO_, "minyonglee1", div, "MONTHLY", "minyonglee1", "DMF0053", orc1, ores])
        rc = orc1.getvalue(); rows = rc.fetchall()
        cols = [c[0] for c in rc.description]
        res = ores.getvalue().fetchall()
        print(f"[TITLE] {len(rows)}행 {time.time()-t0:.1f}s cols={cols[:8]} RESULT={res}")
        if rows:
            print("  첫행:", rows[0][:6], "/ 말행:", rows[-1][:6])
    except Exception as e:
        print(f"[TITLE][ERR] {e}")
    # 메인
    t0 = time.time()
    o1 = cur.var(oracledb.DB_TYPE_CURSOR); o2 = cur.var(oracledb.DB_TYPE_CURSOR)
    o3 = cur.var(oracledb.DB_TYPE_CURSOR); o4 = cur.var(oracledb.DB_TYPE_CURSOR)
    try:
        cur.callproc("PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL",
                     [div, "", "", "", "", "", "", FROM_, TO_, "minyonglee1", "", "", "", "MONTHLY",
                      "", "ADMIN", "", CF, CT, "minyonglee1", "DMF0053", o1, o2, o3, o4])
        rc1 = o1.getvalue(); data = rc1.fetchall(); cols = [c[0] for c in rc1.description]
        rc2 = o2.getvalue(); iso = rc2.fetchall() if rc2 else []
        rc3 = o3.getvalue(); order = rc3.fetchall() if rc3 else []
        res = o4.getvalue().fetchall() if o4.getvalue() else []
        el = time.time() - t0
        meas = sorted({r[cols.index("MEASURE")] for r in data}) if "MEASURE" in cols and data else []
        print(f"[MAIN] {len(data)}행 {el:.1f}s / MEASURE={meas} / ISO={iso[:1]} / ORDER={order[:1]} / RESULT={res}")
        print(f"  cols({len(cols)}) 앞 12: {cols[:12]}")
        dynno = [c for c in cols if c[:2] in ("M_", "W_", "D_", "B_")]
        print(f"  동적 컬럼 {len(dynno)}: {dynno[:6]} ... {dynno[-3:] if len(dynno)>3 else ''}")
    except Exception as e:
        print(f"[MAIN][ERR] {type(e).__name__}: {e}")
    # DBMS_OUTPUT
    lines = []
    line = cur.var(str); status = cur.var(int)
    while True:
        cur.callproc("DBMS_OUTPUT.GET_LINE", [line, status])
        if status.getvalue() != 0: break
        lines.append(line.getvalue())
    if lines:
        print("  [DBMS_OUTPUT]", " | ".join((x or "")[:100] for x in lines[:10]))
conn.rollback()
conn.close()
print("\n스모크 종료")
