"""GAP 377 재현/검증 — 머리글 SP + 조회 SP 를 FE 실전송값(SCM_COM_SQL_LOG 10-06 minyonglee1 ONLY_WEEKLY 호출 형태)으로 호출.

사용: python repro.py <div> <from> <to> <createFrom> <createTo> [bucket ...]
출력: 머리글 기간 칸 수/목록 · 본문 기간 칸별 합계 (전체 / CUST_FCST)
"""
import sys, json, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info

div, frm, to, cf, ct = sys.argv[1:6]
buckets = sys.argv[6:] or ["ONLY_WEEKLY", "WEEKLY"]
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print("DB", cur.fetchone())
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0053' AND OBJECT_TYPE='PACKAGE BODY'"); print("LAST_DDL", cur.fetchone()[0])
USER = "minyonglee1"
out = {}
for bk in buckets:
    rc1, rr = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
    cur.callproc("SCM_MGR.PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE", [frm, to, USER, div, bk, USER, "DMF0053", rc1, rr])
    c = rc1.getvalue(); cols = [x[0] for x in c.description]
    title = [dict(zip(cols, r)) for r in c.fetchall()]
    res = rr.getvalue().fetchall()
    per = [t for t in title if t["COLUMN_NAME"] and t["COLUMN_NAME"][:2] in ("W_", "M_", "D_")]
    print(f"\n== {bk} TITLE result={res} 기간칸={len(per)}")
    for t in per:
        print("  ", t["COLUMN_NAME"], "|", t["COLUMN_LABEL_NAME"], "|", t["LARGE_CLASS_LABEL_NAME"], "| w", t["COLUMN_WIDTH"], "| sort", t["SORT_ORDER_NO"])
    args = [div, "ALL", "ALL", "ALL", "", "", "ALL", frm, to, USER, "ALL", "ALL", "", bk, "", "", "", cf, ct, USER, "DMF0053"]
    o = [cur.var(oracledb.CURSOR) for _ in range(4)]
    cur.callproc("SCM_MGR.PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL", args + o)
    print("   GET result", o[3].getvalue().fetchall())
    c = o[0].getvalue(); cols = [x[0] for x in c.description]; rows = c.fetchall()
    pc = [x for x in cols if x[:2] in ("W_", "M_", "D_")]
    mi = cols.index("MEASURE") if "MEASURE" in cols else None
    tot = {k: 0 for k in pc}; cf_ = {k: 0 for k in pc}
    for r in rows:
        for k in pc:
            v = r[cols.index(k)] or 0
            tot[k] += v
            if mi is not None and r[mi] == "CUST_FCST":
                cf_[k] += v
    print(f"   GET rows={len(rows)} 기간칸={len(pc)} 합계(전체)={sum(tot.values())} 합계(CUST_FCST)={sum(cf_.values())}")
    for k in pc:
        print(f"     {k}: 전체 {tot[k]} / CUST_FCST {cf_[k]}")
    out[bk] = {"title": [t["COLUMN_NAME"] for t in per], "tot": tot, "cf": cf_}
json.dump(out, open(sys.argv[0].replace("repro.py", f"_repro_{div}_{cf}.json"), "w"), ensure_ascii=False, default=str)
