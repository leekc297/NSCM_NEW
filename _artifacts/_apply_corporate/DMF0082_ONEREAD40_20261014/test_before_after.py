"""[E20261014-DMF0082ONEREAD40] P_DMF0082_GET_MAIN_DATA 전후 비교 (조회 프로시저만 호출, 매 호출 rollback)

  python test_before_after.py before [--resume]   # 적용 전 결과 저장 (_before.pkl, 케이스마다 즉시 저장)
  python test_before_after.py after  [--resume]   # 적용 후 결과를 적용 전과 비교

판정 (#129 §12.1)
  케이스마다 반환 커서 6개 전행 멀티셋·정렬순 해시 일치 (RC3 = 서버 현재 시각 → 컬럼·행수만).
  측정 사이 원장 변경 감시: 대상 원장 6종 사업부별 MAX(LAST_UPDATE_DATE)·건수를 전후로 기록해 같이 출력한다
  (RLXPRE 82-ALL 계보 — 공유 DB 에서 측정 사이 타 사용자 저장).
  1회 측정 (버전 조회 1회 수 분 — 2026-10-14 사용자 지적 반영).
"""
import sys, os, pickle, hashlib, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SNAP = {"before": os.path.join(HERE, "_before.pkl"), "after": os.path.join(HERE, "_after.pkl")}
MARK = "E20261014-DMF0082ONEREAD40"

# (케이스, 사업부, 버전, 시작, 종료, team, project, owner, qty_yn, sales_site, user)
CASES = [
    ("40-ALL",          "40", "Current",            "20260901", "20270228", "ALL",      "ALL",         "ALL",         "N", "ALL",          "minyonglee1"),
    ("40-ALL-k0101",    "40", "Current",            "20260901", "20270228", "ALL",      "ALL",         "ALL",         "N", "ALL",          "k0101"),
    ("40-ALL-1003",     "40", "Current",            "20261001", "20270331", "ALL",      "ALL",         "ALL",         "N", "ALL",          "minyonglee1"),
    ("40-ALL-QTYY",     "40", "Current",            "20260901", "20270228", "ALL",      "ALL",         "ALL",         "Y", "ALL",          "minyonglee1"),
    ("40-SITE",         "40", "Current",            "20261001", "20270331", "ALL",      "ALL",         "ALL",         "N", "acer_CN_CKG",  "minyonglee1"),
    ("40-P-HP",         "40", "Current",            "20260901", "20270228", "ALL",      "HP",          "ALL",         "N", "ALL",          "minyonglee1"),
    ("40-P-2PJT",       "40", "Current",            "20260901", "20270228", "ALL",      "Dell,Lenovo", "ALL",         "N", "ALL",          "minyonglee1"),
    ("40-T-58666055",   "40", "Current",            "20260901", "20270228", "58666055", "ALL",         "ALL",         "N", "ALL",          "minyonglee1"),
    ("40-O-MINSUN",     "40", "Current",            "20260901", "20270228", "ALL",      "ALL",         "MIN SUN KIM", "N", "ALL",          "minyonglee1"),
    ("40-SF-P",         "40", "SF_W_20260824_V001", "20260801", "20270131", "ALL",      "HP",          "ALL",         "N", "ALL",          "minyonglee1"),
    ("40-SP-P",         "40", "SP_W_20260921_V001", "20260901", "20270228", "ALL",      "Dell",        "ALL",         "N", "ALL",          "minyonglee1"),
    ("40-MF-T",         "40", "MF_W_20260824_V001", "20260801", "20270131", "58099468", "ALL",         "ALL",         "N", "ALL",          "minyonglee1"),
    ("81-ALL",          "81", "Current",            "20260901", "20270228", "ALL",      "ALL",         "ALL",         "N", "ALL",          "minyonglee1"),
    ("81-P-A15AI7001",  "81", "Current",            "20260901", "20270228", "ALL",      "A15AI7001",   "ALL",         "N", "ALL",          "minyonglee1"),
    ("82-ALL",          "82", "Current",            "20260901", "20270228", "ALL",      "ALL",         "ALL",         "N", "ALL",          "minyonglee1"),
]

LEDGERS = ["DM_PLN_CFM_MKT_DEMAND_PLAN", "DM_PLN_CFM_SELLING_PRICE", "DM_PLN_SALES_PLAN_RESULT",
           "DM_PLN_MKT_FCST", "SCM_MST_FUTURE_PRICE", "DM_PLN_SALES_PLAN"]


def ledger_state(cur):
    out = {}
    for t in LEDGERS:
        cur.execute(f"SELECT DIVISION_ID, TO_CHAR(MAX(LAST_UPDATE_DATE),'MM-DD HH24:MI:SS'), COUNT(*) FROM SCM_MGR.{t} "
                    f"WHERE DIVISION_ID IN ('40','81','82') AND LAST_UPDATE_DATE >= SYSDATE - 1 GROUP BY DIVISION_ID")
        for div, mx, n in cur.fetchall():
            out[(t, div)] = (mx, n)
    return out


def call(cur, c):
    _, div, ver, f, t, team, pjt, own, qty, site, usr = c
    args = [div, team, "ALL", "ALL", f, t, site, None, ver, qty, usr, "ADMIN", "ALL", pjt, own, "ALL"]
    outs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    t0 = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", args + outs)
    res = []
    for o in outs:
        rc = o.getvalue()
        res.append(([x[0] for x in rc.description], rc.fetchall()))
    el = time.time() - t0
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST")
    ldf = cur.fetchone()[0]
    return res, el, ldf


def digest(res):
    out = []
    for cols, rows in res:
        reps = [repr(r) for r in rows]
        out.append({"cols": cols, "n": len(rows),
                    "multiset": hashlib.sha256("\n".join(sorted(reps)).encode()).hexdigest(),
                    "ordered": hashlib.sha256("\n".join(reps).encode()).hexdigest()})
    return out


def same(a, b):
    return all(x == y for i, (x, y) in enumerate(zip(a, b)) if i != 2) and (a[2]["cols"], a[2]["n"]) == (b[2]["cols"], b[2]["n"])


def main():
    mode = sys.argv[1]
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone(), "mode", mode, flush=True)
    cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE :m", m=f"%{MARK}%")
    marker = cur.fetchone()[0]
    if (mode == "before") != (marker == 0):
        sys.exit(f"ABORT: mode={mode} 인데 BODY 마커 {marker}곳")
    path = SNAP[mode]
    out = pickle.load(open(path, "rb")) if os.path.exists(path) and "--resume" in sys.argv else {"_ledger_start": ledger_state(cur)}
    for c in CASES:
        if c[0] in out:
            continue
        res, el, ldf = call(cur, c)
        con.rollback()
        out[c[0]] = {"d": digest(res), "sec": el, "ldf": ldf}
        print(f"{c[0]:16s} rc1 {out[c[0]]['d'][0]['n']:6d} rows | {el:7.2f}s | LD_FCST {ldf}", flush=True)
        pickle.dump(out, open(path, "wb"))
    out["_ledger_end"] = ledger_state(cur)
    pickle.dump(out, open(path, "wb"))
    if mode == "before":
        print("BEFORE SAVED", len(CASES))
        return
    bef = pickle.load(open(SNAP["before"], "rb"))
    fail = 0
    print("\n=== 비교 ===")
    for c in CASES:
        k = c[0]; a, b = out[k], bef[k]
        ok = same(a["d"], b["d"])
        fail += (not ok)
        diff = "" if ok else " | " + ", ".join(f"RC{i+1}:{y['n']}→{x['n']}" for i, (x, y) in enumerate(zip(a["d"], b["d"])) if x != y and i != 2)
        print(f"{'PASS' if ok else 'FAIL'} | {k:16s} | rc1 {b['d'][0]['n']}→{a['d'][0]['n']} | {b['sec']:7.2f}s → {a['sec']:7.2f}s | LD_FCST {b['ldf']}→{a['ldf']}{diff}")
    print("\n=== 측정 사이 원장 변경 감시 (최근 1일 수정분: MAX 시각 · 건수) ===")
    keys = sorted(set(bef["_ledger_start"]) | set(out["_ledger_end"]))
    for kk in keys:
        s0, s1 = bef["_ledger_start"].get(kk), out["_ledger_end"].get(kk)
        flag = "" if s0 == s1 else "  ← 변경"
        print(f"  {kk[0]:28s} {kk[1]} | before-start {s0} | after-end {s1}{flag}")
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}", f"({len(CASES)} cases)")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
