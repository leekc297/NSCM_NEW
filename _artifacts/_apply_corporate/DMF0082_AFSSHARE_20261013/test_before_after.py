"""[E20261013-DMF0082AFSSHARE] 조회 SP 전후 비교 (읽기 전용 — 조회 프로시저만 호출)

  python test_before_after.py before   # 적용 전 결과 저장
  python test_before_after.py after    # 적용 후 결과를 적용 전과 비교

사내 원장에는 당주 이후 MKT_FCST 에 AS From Site 값이 있는 행이 없다(81 · 82 모두 0건, 과거 구간은 실적 원천이라 값이 내려오지 않는다).
그래서 실제 조회는 "값이 없으면 아무것도 달라지지 않는다" 를 본다 — 모든 케이스가 적용 전과 같아야 한다.
값이 있을 때의 동작은 test_mock.py (임시 테이블 모의 행) 로 확인한다.
"""
import sys, os, pickle, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SNAP = os.path.join(HERE, "_before.pkl")
USERS = ["minyonglee1", "k0101"]
PROCS = ["P_DMF0082_GET_MAIN_DATA", "P_DMF0082_GET_MAIN_DATA_CURRENT"]
# (사업부, 시작일, 종료일, 고객, Sales Site) — 전체 조회는 건당 5분이라 사이트를 지정한다
DIVS = [("81", "20261001", "20261231", "ALL", "HKMC_KR_ASA"), ("81", "20260101", "20260430", "ALL", "Volvo AS_WA_SE_GOT"),
        ("82", "20261001", "20261231", "ALL", "NextEra_US_PHX"), ("40", "20261001", "20270331", "acer", "acer_CN_CKG")]

def call(cur, proc, div, f, t, user, cust="ALL", site="ALL"):
    args = [div, "ALL", cust, "ALL", f, t, site, "", "Current", "N", user, "ADMIN", "ALL", "ALL", "ALL", "ALL"]
    outs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    cur.callproc("SCM_MGR.PKG_DMF0082." + proc, args + outs)
    c = outs[0].getvalue()
    cols = [x[0] for x in c.description]
    rows = c.fetchall()
    return cols, rows


def digest(cols, rows, drop=None):
    idx = [i for i, c in enumerate(cols) if c != drop]
    names = [cols[i] for i in idx]
    order = sorted(range(len(names)), key=lambda i: names[i])   # 컬럼 순서 차이는 무시하고 이름 기준으로 맞춘다
    h = sorted(hashlib.md5(repr(tuple(r[idx[i]] for i in order)).encode()).hexdigest() for r in rows)
    return sorted(names), hashlib.md5("".join(h).encode()).hexdigest()


def main():
    mode = sys.argv[1]
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone(), "mode", mode)
    cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE '%E20261013-DMF0082AFSSHARE%'")
    marker = cur.fetchone()[0]
    if (mode == "before") != (marker == 0):
        sys.exit(f"ABORT: mode={mode} 인데 BODY 마커 {marker}곳")
    res = {}
    for proc in PROCS:
        for div, f, t, cust, site in DIVS:
            for usr in USERS:
                cols, rows = call(cur, proc, div, f, t, usr, cust, site)
                con.rollback()
                res[(proc, div, site, usr)] = {"cols": cols, "n": len(rows), "full": digest(cols, rows)}
    if mode == "before":
        pickle.dump(res, open(SNAP, "wb"))
        print("BEFORE SAVED", len(res))
        return
    bef = pickle.load(open(SNAP, "rb"))
    fail = 0
    for k, a in res.items():
        b = bef[k]
        ok = a["full"] == b["full"] and a["n"] == b["n"]
        fail += (not ok)
        print("PASS" if ok else "FAIL", f"| {k[0][11:]:22s} | {k[1]} | {k[2]:18s} | {k[3]:12s} | rows {b['n']} → {a['n']} | cols {len(b['cols'])} → {len(a['cols'])}")
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()