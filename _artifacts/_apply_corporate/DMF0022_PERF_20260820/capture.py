# -*- coding: utf-8 -*-
"""값 동등성 캡처 — 6 케이스 × rc1/rc2/rc3 전행 덤프.

사용: python capture.py <TAG>   (예: BEFORE / AFTER_A / AFTER_B)
비교: python capture.py --cmp BEFORE AFTER_A
"""
import decimal
import hashlib
import io
import json
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

CASES = [("C1 div40 CURRENT", "40", "CURRENT"),
         ("C2 div81 CURRENT", "81", "CURRENT"),
         ("C3 div82 CURRENT", "82", "CURRENT"),
         ("C4 div40 CUR+SP_W", "40", "CURRENT,SP_W_20260817_V001"),
         ("C5 div40 SP_W", "40", "SP_W_20260817_V001"),
         ("C6 div81 CUR+SP_W", "81", "CURRENT,SP_W_20260817_V001")]


def cell(v):
    if v is None:
        return None
    if isinstance(v, decimal.Decimal):
        return format(v.normalize(), "f")
    return str(v)


def capture(tag):
    import oracledb
    from ora import conn_info
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=227122")
    raw = cur.fetchone()[0].read()
    jk = lambda k: (re.search(r'"%s":"([^"]*)"' % k, raw).group(1)
                    if re.search(r'"%s":"([^"]*)"' % k, raw) else None)
    P = {k: jk(k) for k in ["deptId", "endCustomer", "scmSiteId", "projectCode", "itemId",
                            "itemType", "fromYyyymmdd", "toYyyymmdd", "sesUserId",
                            "plantSiteId", "bizType", "owner", "bucket", "userDeptId",
                            "groupId", "cellYn", "userId", "mnuId"]}
    out = {}
    for label, div, ver in CASES:
        o = [con.cursor() for _ in range(3)]
        cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", [
            div, P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"], P["projectCode"] or "",
            P["itemId"] or "", P["itemType"], P["fromYyyymmdd"], "20260817", P["toYyyymmdd"],
            P["sesUserId"], P["plantSiteId"], P["bizType"], P["owner"] or "", "N", P["cellYn"],
            ver, P["bucket"] or "MONTHLY", P["userDeptId"] or "", P["groupId"] or "",
            P["userId"], P["mnuId"]] + o)
        rcs = []
        for c in o:
            if not c.description:
                rcs.append({"cols": None, "rows": []})
                continue
            cols = [x[0] for x in c.description]
            rows = [[cell(v) for v in r] for r in c.fetchall()]
            rows.sort(key=lambda r: json.dumps(r, ensure_ascii=False))
            rcs.append({"cols": cols, "rows": rows})
        out[label] = rcs
        print(f"[{tag}] {label:20s} rc행수={[len(x['rows']) for x in rcs]} "
              f"컬럼수={[len(x['cols']) if x['cols'] else 0 for x in rcs]}")
    json.dump(out, open(f"cap_{tag}.json", "w", encoding="utf-8"), ensure_ascii=False)
    con.close()


def compare(a, b):
    A = json.load(open(f"cap_{a}.json", encoding="utf-8"))
    B = json.load(open(f"cap_{b}.json", encoding="utf-8"))
    ok = True
    print(f"\n{'케이스':22s} {'커서':5s} {'행수(A)':>9s} {'행수(B)':>9s} {'컬럼':>5s} {'전행일치':>9s}")
    for label, _, _ in CASES:
        for i in range(3):
            ra, rb = A[label][i], B[label][i]
            same_cols = ra["cols"] == rb["cols"]
            ha = hashlib.md5(json.dumps(ra["rows"], ensure_ascii=False).encode()).hexdigest()
            hb = hashlib.md5(json.dumps(rb["rows"], ensure_ascii=False).encode()).hexdigest()
            same = same_cols and ha == hb
            ok &= same
            print(f"{label:22s} rc{i+1:<4d} {len(ra['rows']):9d} {len(rb['rows']):9d} "
                  f"{'OK' if same_cols else 'DIFF':>5s} {'IDENTICAL' if same else 'MISMATCH':>9s}")
            if not same:
                if not same_cols:
                    print("     컬럼 A:", ra["cols"])
                    print("     컬럼 B:", rb["cols"])
                else:
                    sa = {json.dumps(r, ensure_ascii=False) for r in ra["rows"]}
                    sb = {json.dumps(r, ensure_ascii=False) for r in rb["rows"]}
                    print(f"     A-only {len(sa - sb)} / B-only {len(sb - sa)}")
                    for x in list(sa - sb)[:3]:
                        print("      A>", x[:220])
                    for x in list(sb - sa)[:3]:
                        print("      B>", x[:220])
    print("\n결과:", "값 동등성 PASS (전 케이스 전행 일치)" if ok else "⚠ 값 불일치 — 원복 필요")
    return ok


if __name__ == "__main__":
    if sys.argv[1] == "--cmp":
        sys.exit(0 if compare(sys.argv[2], sys.argv[3]) else 1)
    capture(sys.argv[1])
