"""[E20261014-DMF0082RLXPRE] P_DMF0082_GET_MAIN_DATA 전후 비교 (조회 프로시저만 호출, 매 호출 rollback)

  python test_before_after.py before   # 적용 전 결과 저장 (_before.pkl)
  python test_before_after.py after    # 적용 후 결과를 적용 전과 비교

판정 (#129 §12.1)
  케이스마다 반환 커서 6개(O_RC1~O_RC5, O_RESULT_CURSOR) 전부 — 컬럼 목록 · 행 수 · 전행 멀티셋 해시 · 정렬순 해시 일치.
  참고 지표: 호출 소요(2회 중 최소) · 호출 직후 같은 세션의 GT_DMF0082_TEMP_SITE_ITEM 행 수(선행축소 효과).
"""
import sys, os, pickle, hashlib, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SNAP = os.path.join(HERE, "_before.pkl")
MARK = "E20261014-DMF0082RLXPRE"
RUNS = 1   # 2026-10-14 15:40 사용자 지적(소요) 반영 — 버전 조회 1회 5~8분이라 2회 측정 중단, 케이스마다 즉시 저장

# (케이스, 사업부, 버전, 시작, 종료, team, project, owner, qty_yn, sales_site)
# 값 출처: 사내 조회 로그(SCM_SYS_LOG_BATCH 45일) + SCM_MST_SITE_ITEM 실데이터 (2026-10-14 조회)
CASES = [
    ("81-ALL",           "81", "Current",            "20260901", "20270228", "ALL",      "ALL",                 "ALL",           "N", "ALL"),
    ("81-P-A15AI7001",   "81", "Current",            "20260901", "20270228", "ALL",      "A15AI7001",           "ALL",           "N", "ALL"),
    ("81-P-A15BW7001",   "81", "Current",            "20260901", "20270228", "ALL",      "A15BW7001",           "ALL",           "N", "ALL"),
    ("81-P-2PJT",        "81", "Current",            "20260901", "20270228", "ALL",      "A15BW7001,A15BW7003", "ALL",           "N", "ALL"),
    ("81-P-A25PS1001",   "81", "Current",            "20261001", "20270331", "ALL",      "A25PS1001-M02",       "ALL",           "N", "ALL"),
    ("81-P-EMPTYTOKEN",  "81", "Current",            "20260901", "20270228", "ALL",      "A15BW7001,",          "ALL",           "N", "ALL"),
    ("81-P-NOMATCH",     "81", "Current",            "20260901", "20270228", "ALL",      "czxcZ",               "ALL",           "N", "ALL"),
    ("81-P-A15BW7002",   "81", "Current",            "20260901", "20270228", "ALL",      "A15BW7002",           "ALL",           "N", "ALL"),
    ("81-T-70000347",    "81", "Current",            "20260901", "20270228", "70000347", "ALL",                 "ALL",           "N", "ALL"),
    ("81-T-30277380",    "81", "Current",            "20260901", "20270228", "30277380", "ALL",                 "ALL",           "N", "ALL"),
    ("81-O-HAKSOO",      "81", "Current",            "20260901", "20270228", "ALL",      "ALL",                 "HAKSOO LEE",    "N", "ALL"),
    ("81-P+O",           "81", "Current",            "20260901", "20270228", "ALL",      "A15BW7002",           "Austin Kang",   "N", "ALL"),
    ("81-P+T",           "81", "Current",            "20260901", "20270228", "70000347", "A15BW7002",           "ALL",           "N", "ALL"),
    ("81-P-QTYY",        "81", "Current",            "20260901", "20270228", "ALL",      "A15AI7001",           "ALL",           "Y", "ALL"),
    ("81-MF-P",          "81", "MF_W_20260930_V001", "20261001", "20270331", "ALL",      "A15AI7001",           "ALL",           "N", "ALL"),
    ("81-SP-P",          "81", "SP_W_20260923_V001", "20260901", "20270228", "ALL",      "A15BW7002",           "ALL",           "N", "ALL"),
    ("40-ALL",           "40", "Current",            "20260901", "20270228", "ALL",      "ALL",                 "ALL",           "N", "ALL"),
    ("40-P-HP",          "40", "Current",            "20260901", "20270228", "ALL",      "HP",                  "ALL",           "N", "ALL"),
    ("40-P-2PJT",        "40", "Current",            "20260901", "20270228", "ALL",      "Dell,Lenovo",         "ALL",           "N", "ALL"),
    ("40-T-58666055",    "40", "Current",            "20260901", "20270228", "58666055", "ALL",                 "ALL",           "N", "ALL"),
    ("40-O-MINSUN",      "40", "Current",            "20260901", "20270228", "ALL",      "ALL",                 "MIN SUN KIM",   "N", "ALL"),
    ("40-SF-P",          "40", "SF_W_20260824_V001", "20260801", "20270131", "ALL",      "HP",                  "ALL",           "N", "ALL"),
    ("40-SP-P",          "40", "SP_W_20260921_V001", "20260901", "20270228", "ALL",      "Dell",                "ALL",           "N", "ALL"),
    ("40-MF-T",          "40", "MF_W_20260824_V001", "20260801", "20270131", "58099468", "ALL",                 "ALL",           "N", "ALL"),
    ("82-ALL",           "82", "Current",            "20260901", "20270228", "ALL",      "ALL",                 "ALL",           "N", "ALL"),
    ("82-P-G19176",      "82", "Current",            "20260901", "20270228", "ALL",      "G-19-176",            "ALL",           "N", "ALL"),
    ("82-O-SOOYOUNG",    "82", "Current",            "20260901", "20270228", "ALL",      "ALL",                 "SOOYOUNG KIM",  "N", "ALL"),
    ("82-T-71059521",    "82", "Current",            "20260901", "20270228", "71059521", "ALL",                 "ALL",           "N", "ALL"),
    ("82-SP-P",          "82", "SP_W_20260827_V001", "20260901", "20270228", "ALL",      "R-21-011",            "ALL",           "N", "ALL"),
    ("82-MF-P",          "82", "MF_W_20260825_V001", "20260801", "20270131", "ALL",      "G-19-176",            "ALL",           "N", "ALL"),
]


def call(cur, c):
    _, div, ver, f, t, team, pjt, own, qty, site = c
    # P_DIVISION_ID, P_TEAM_ID, P_CUSTOMER, P_BIZ_TYPE, P_FROM, P_TO, P_SCM_SITE_ID, P_ITEM_ID, P_VERSION_TYPE, P_QTY_YN,
    # P_CREATED_BY, P_USER_GROUP, P_PLANT_SITE_ID, P_PROJECT_CODE, P_OWNER, P_SENDER_CODE
    args = [div, team, "ALL", "ALL", f, t, site, None, ver, qty, "minyonglee1", "ADMIN", "ALL", pjt, own, "ALL"]
    outs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    t0 = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", args + outs)
    res = []
    for o in outs:
        rc = o.getvalue()
        cols = [x[0] for x in rc.description]
        rows = rc.fetchall()
        res.append((cols, rows))
    el = time.time() - t0
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM")
    si = cur.fetchone()[0]
    return res, el, si


def digest(res):
    out = []
    for cols, rows in res:
        reps = [repr(r) for r in rows]
        out.append({"cols": cols, "n": len(rows),
                    "multiset": hashlib.sha256("\n".join(sorted(reps)).encode()).hexdigest(),
                    "ordered": hashlib.sha256("\n".join(reps).encode()).hexdigest()})
    return out


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
    path = SNAP if mode == "before" else SNAP.replace("_before", "_after")
    out = pickle.load(open(path, "rb")) if os.path.exists(path) and "--resume" in sys.argv else {}
    for c in CASES:
        if c[0] in out:
            continue
        best, dg, si = None, None, None
        for _ in range(RUNS):
            res, el, si_ = call(cur, c)
            con.rollback()
            g = digest(res)
            if dg is not None and [x for i, x in enumerate(g) if i != 2] != [x for i, x in enumerate(dg) if i != 2]:
                print(f"  ⚠ {c[0]} 같은 모드 안 2회 결과 상이 — 원장 변동 의심")
            dg, si = g, si_
            best = el if best is None else min(best, el)
        out[c[0]] = {"d": dg, "sec": best, "site_item": si}
        print(f"{c[0]:17s} rc1 {dg[0]['n']:6d} rows | {best:6.2f}s | TEMP_SITE_ITEM {si}", flush=True)
        pickle.dump(out, open(SNAP if mode == "before" else SNAP.replace("_before", "_after"), "wb"))   # 케이스마다 즉시 저장
    if mode == "before":
        pickle.dump(out, open(SNAP, "wb"))
        print("BEFORE SAVED", len(out))
        return
    bef = pickle.load(open(SNAP, "rb"))
    fail = 0
    print("\n=== 비교 ===")
    for k, a in out.items():
        b = bef[k]
        # RC3 = 서버 현재 시각(YYYYMMDD·요일·HHMI) 1행 — 호출마다 값이 바뀌므로 컬럼·행수만 비교 (2026-10-14 15:35 실측: 같은 모드 2회 호출에서 HHMI 만 상이)
        same = all(x == y for i, (x, y) in enumerate(zip(a["d"], b["d"])) if i != 2) \
            and (a["d"][2]["cols"], a["d"][2]["n"]) == (b["d"][2]["cols"], b["d"][2]["n"])
        fail += (not same)
        diff = "" if same else " | " + ", ".join(f"RC{i+1}:{'cols' if x['cols'] != y['cols'] else ''}{y['n']}→{x['n']}"
                                                  for i, (x, y) in enumerate(zip(a["d"], b["d"])) if x != y and i != 2)
        print(f"{'PASS' if same else 'FAIL'} | {k:17s} | rows rc1 {b['d'][0]['n']}→{a['d'][0]['n']} | "
              f"{b['sec']:6.2f}s → {a['sec']:6.2f}s | TEMP_SITE_ITEM {b['site_item']} → {a['site_item']}{diff}")
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}", f"({len(out)} cases)")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
