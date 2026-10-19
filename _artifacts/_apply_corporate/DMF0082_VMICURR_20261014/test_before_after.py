"""[E20261014-DMF0082VMICURR] 조회 SP 전후 비교 (읽기 전용 — 조회 프로시저만 호출, 매 호출 rollback)

  python test_before_after.py before   # 적용 전 결과 저장
  python test_before_after.py after    # 적용 후 결과를 적용 전과 비교

판정
  A. VMI 가 아닌 행 = 적용 전과 완전히 같다 (행 수 · 전 컬럼 값)
  B. VMI 행 = CURRENCY 를 뺀 나머지 값이 적용 전과 같다 (행이 쪼개지거나 합쳐지지 않는다)
  C. VMI 행 CURRENCY = 같은 키(MEASURE · 기간 · 수치 컬럼을 뺀 표시 키) LOC 행의 CURRENCY 와 같다
     — LOC 행이 없거나 LOC 통화가 비어 있는 키는 '대상 없음' 으로 따로 센다
"""
import sys, os, pickle, hashlib, re
from collections import Counter, defaultdict
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SNAP = os.path.join(HERE, "_before.pkl")
MARK = "E20261014-DMF0082VMICURR"
USERS = ["minyonglee1", "k0101"]
PROCS = ["P_DMF0082_GET_MAIN_DATA", "P_DMF0082_GET_MAIN_DATA_CURRENT"]
# (사업부, 시작일, 종료일, 고객, Sales Site) — VMI 메저 원장 실재 사이트 (2026-10-14 실측)
CASES = [("40", "20261001", "20270331", "ALL", "acer_CN_CKG"),      # VMI_In_Req
         ("81", "20261001", "20261231", "ALL", "Ford_MX_CTN"),      # VMI_In_Req
         ("82", "20261001", "20261231", "ALL", "DeltaX_KR_SEL")]    # VMI_Inv · VMI_DIO
NON_KEY = re.compile(r"^(MEASURE|QTY|[MWD]_\d+|SORT_KEY|SORT_ORDER_NO|LAST_UPDATE_DATE|LAST_UPDATED_BY|EDIT_FLAG|BUCKET|MEASURE_GROUP|NOTATION|CURRENCY)$")


def call(cur, proc, div, f, t, user, cust="ALL", site="ALL"):
    args = [div, "ALL", cust, "ALL", f, t, site, "", "Current", "N", user, "ADMIN", "ALL", "ALL", "ALL", "ALL"]
    outs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    cur.callproc("SCM_MGR.PKG_DMF0082." + proc, args + outs)
    c = outs[0].getvalue()
    cols = [x[0] for x in c.description]
    return cols, c.fetchall()


def is_vmi(m):
    return str(m or "").startswith("VMI")


def rowhash(cols, r, drop=()):
    return hashlib.md5(repr(tuple((c, r[i]) for i, c in sorted(enumerate(cols), key=lambda x: x[1]) if c not in drop)).encode()).hexdigest()


def summarize(cols, rows):
    if "MEASURE" not in cols:
        return {"n": len(rows), "nonvmi": [], "vmi_nocur": [], "vmi": [], "check": None, "cur_by_measure": {}}
    mi = cols.index("MEASURE")
    ci = cols.index("CURRENCY") if "CURRENCY" in cols else None
    keyi = [i for i, c in enumerate(cols) if not NON_KEY.match(c)]
    nonvmi = sorted(rowhash(cols, r) for r in rows if not is_vmi(r[mi]))
    vmi_nocur = sorted(rowhash(cols, r, ("CURRENCY",)) for r in rows if is_vmi(r[mi]))
    vmi = [r for r in rows if is_vmi(r[mi])]
    cur_by_measure = defaultdict(Counter)
    for r in rows:
        cur_by_measure[r[mi]][(r[ci] if ci is not None else "<no col>")] += 1
    check = None
    if ci is not None:
        loc = defaultdict(set)
        for r in rows:
            if r[mi] == "LOC" and str(r[ci] or "").strip() not in ("", "-", "/"):
                loc[tuple(r[i] for i in keyi)].add(r[ci])
        check = Counter()
        for r in vmi:
            lc = loc.get(tuple(r[i] for i in keyi))
            if not lc:
                check["no LOC currency"] += 1
            elif len(lc) > 1:
                check["LOC multi currency"] += 1
            elif r[ci] in lc:
                check["== LOC"] += 1
            else:
                check["!= LOC"] += 1
    return {"n": len(rows), "nonvmi": nonvmi, "vmi_nocur": vmi_nocur, "vmi": len(vmi), "check": check,
            "cur_by_measure": {k: dict(v) for k, v in cur_by_measure.items()}}


def main():
    mode = sys.argv[1]
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone(), "mode", mode)
    cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE :m", m=f"%{MARK}%")
    marker = cur.fetchone()[0]
    if (mode == "before") != (marker == 0):
        sys.exit(f"ABORT: mode={mode} 인데 BODY 마커 {marker}곳")
    res = {}
    for proc in PROCS:
        for div, f, t, cust, site in CASES:
            for usr in USERS:
                cols, rows = call(cur, proc, div, f, t, usr, cust, site)
                con.rollback()
                res[(proc, div, site, usr)] = summarize(cols, rows)
    if mode == "before":
        pickle.dump(res, open(SNAP, "wb"))
        for k, a in res.items():
            print(f"{k[0][11:]:22s} | {k[1]} | {k[2]:14s} | {k[3]:12s} | rows {a['n']} vmi {a['vmi']} | {dict(a['check'] or {})}")
        print("BEFORE SAVED", len(res))
        return
    bef = pickle.load(open(SNAP, "rb"))
    fail = 0
    for k, a in res.items():
        b = bef[k]
        okA = a["nonvmi"] == b["nonvmi"]
        okB = a["vmi_nocur"] == b["vmi_nocur"] and a["n"] == b["n"]
        chk = dict(a["check"] or {})
        okC = chk.get("!= LOC", 0) == 0
        ok = okA and okB and okC
        fail += (not ok)
        print("PASS" if ok else "FAIL", f"| {k[0][11:]:22s} | {k[1]} | {k[2]:14s} | {k[3]:12s} | rows {b['n']}→{a['n']} vmi {a['vmi']}"
              f" | A {okA} B {okB} C {chk}")
        for m in sorted(a["cur_by_measure"]):
            if is_vmi(m) or m == "LOC":
                print(f"      {m:12s} before {b['cur_by_measure'].get(m)} → after {a['cur_by_measure'][m]}")
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
