"""[E20261013-DMF0082MANDRET] 조회 SP 전후 비교 (읽기 전용 — 조회 프로시저만 호출)

  python test_before_after.py before   # 적용 전 결과 저장
  python test_before_after.py after    # 적용 후 결과를 적용 전과 비교

케이스 = 프로시저 2종 × 사업부(81 · 82 · 40) × 사용자(Column Set 에 AS_FROM_SITE 있음 / 없음)
기대
  - 81 · 82 + 저장 내역에 없는 사용자 : 결과에 AS_FROM_SITE 컬럼이 새로 생긴다. 그 컬럼을 빼고 보면 행 내용은 적용 전과 같다
                                       (사내 81 · 82 원장의 AS From Site 는 모두 빈값이라 행이 나뉘지 않는다).
  - 81 · 82 + 저장 내역에 있는 사용자 : 컬럼 목록 · 행 내용 모두 적용 전과 같다.
  - 40 (이 컬럼의 대상 사업부 아님)    : 두 사용자 모두 적용 전과 같다.
"""
import sys, os, pickle, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SNAP = os.path.join(HERE, "_before.pkl")
USERS = ["minyonglee1", "k0101"]
PROCS = ["P_DMF0082_GET_MAIN_DATA", "P_DMF0082_GET_MAIN_DATA_CURRENT"]
# (사업부, 시작일, 종료일, 고객, Sales Site) — 전체 조회는 건당 5분이라 사이트를 지정한다 (사내 데이터가 있는 사이트)
DIVS = [("81", "20261001", "20261231", "ALL", "HKMC_KR_ASA"), ("82", "20261001", "20261231", "ALL", "NextEra_US_PHX"),
        ("40", "20261001", "20270331", "acer", "acer_CN_CKG")]


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
    cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE '%E20261013-DMF0082MANDRET%'")
    marker = cur.fetchone()[0]
    if (mode == "before") != (marker == 0):
        sys.exit(f"ABORT: mode={mode} 인데 BODY 마커 {marker}곳")
    has = {}
    for usr in USERS:
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND USER_ID=:u "
                    "AND USER_INQUIRY_COLUMN_TYPE_CODE='C' AND COLUMN_NAME='AS_FROM_SITE'", u=usr)
        has[usr] = cur.fetchone()[0] > 0
    print("Column Set 에 AS_FROM_SITE 저장:", has)
    res = {}
    for proc in PROCS:
        for div, f, t, cust, site in DIVS:
            for usr in USERS:
                cols, rows = call(cur, proc, div, f, t, usr, cust, site)
                con.rollback()
                res[(proc, div, usr)] = {"cols": cols, "n": len(rows), "full": digest(cols, rows),
                                         "noafs": digest(cols, rows, "AS_FROM_SITE"),
                                         "afs_vals": sorted({str(r[cols.index("AS_FROM_SITE")]) for r in rows})[:5] if "AS_FROM_SITE" in cols else None}
                print(f"  {proc[11:]:22s} {div} {usr:12s} rows {len(rows):6d} cols {len(cols)} AS_FROM_SITE {'있음' if 'AS_FROM_SITE' in cols else '없음'}")
    if mode == "before":
        pickle.dump(res, open(SNAP, "wb"))
        print("BEFORE SAVED", len(res))
        return
    bef = pickle.load(open(SNAP, "rb"))
    fail = 0
    for k, a in res.items():
        b = bef[k]
        proc, div, usr = k
        target = div in ("81", "82") and not has[usr]
        if target:
            ok = ("AS_FROM_SITE" not in b["cols"]) and ("AS_FROM_SITE" in a["cols"]) and a["n"] == b["n"] and a["noafs"] == b["noafs"] \
                 and set(a["cols"]) - set(b["cols"]) == {"AS_FROM_SITE"}
            note = f"AS_FROM_SITE 추가 · 그 외 컬럼·행 동일 · 값 예 {a['afs_vals']}"
        else:
            ok = a["full"] == b["full"] and a["n"] == b["n"]
            note = "적용 전과 동일"
        fail += (not ok)
        print("PASS" if ok else "FAIL", f"| {proc[11:]:22s} | {div} | {usr:12s} | rows {b['n']} → {a['n']} | cols {len(b['cols'])} → {len(a['cols'])} | {note}")
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
