"""[E20261014-DMF0005PARTIALGET] DMF0005 조회 프로시저 직접 호출 (읽기 전용 — 조회 프로시저만 호출)

  python test_call.py before   # 적용 전 결과를 _before.pkl 로 저장
  python test_call.py after    # 적용 후 결과와 비교

사업부 82 · 81 · 40, 조회조건 없음(Active = ALL).
비교: 행 수 동일 · 기존 컬럼 값 전부 동일(행 묶음 비교) · 새 컬럼은 PARTIAL_PLAN_YN 하나뿐(맨 끝) ·
      새 컬럼 값 = 원장 SCM_MST_SITE_ITEM.PARTIAL_PLAN_YN (사업부 · Sales Site · 프로젝트 · 모델 · 팀 키).
"""
import sys, os, pickle
from collections import Counter
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SNAP = os.path.join(HERE, "_before.pkl")
DIVS = ("82", "81", "40")
KEY = ("DIVISION_ID", "SCM_SITE_ID", "PROJECT_CODE", "ITEM_ID", "DEPT_ID")


def call(cur, div):
    o1, o2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("SCM_MGR.PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION",
                 [div, None, None, None, None, None, "ALL", None, "minyonglee1", o1, o2])
    c = o1.getvalue()
    cols = [x[0] for x in c.description]
    rows = c.fetchall()
    res = o2.getvalue().fetchall()
    return cols, rows, res


def main(mode):
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone())
    now = {}
    for div in DIVS:
        cols, rows, res = call(cur, div)
        con.rollback()
        now[div] = (cols, rows)
        print(f"{mode} | div {div} | rows {len(rows)} | cols {len(cols)} | result {res} | PARTIAL_PLAN_YN 컬럼 {'있음' if 'PARTIAL_PLAN_YN' in cols else '없음'}")
    if mode == "before":
        pickle.dump(now, open(SNAP, "wb"))
        print("SAVED", SNAP)
        return
    old = pickle.load(open(SNAP, "rb"))
    fail = 0
    for div in DIVS:
        oc, orows = old[div]
        nc, nrows = now[div]
        ok_cols = nc == oc + ["PARTIAL_PLAN_YN"]
        ok_cnt = len(nrows) == len(orows)
        ok_val = Counter(orows) == Counter(r[:len(oc)] for r in nrows)
        ok_ord = orows == [r[:len(oc)] for r in nrows]
        # 새 컬럼 값 = 원장 값
        cur.execute("SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, DEPT_ID, PARTIAL_PLAN_YN FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE DIVISION_ID = :d", d=div)
        led = {}
        for r in cur:
            led.setdefault(r[:5], set()).add(r[5])
        ki = [nc.index(k) for k in KEY]
        vi = nc.index("PARTIAL_PLAN_YN")
        bad = sum(1 for r in nrows if r[vi] not in led.get(tuple(r[i] for i in ki), ()))
        dist = dict(Counter(r[vi] for r in nrows))
        ok = ok_cols and ok_cnt and ok_val and bad == 0
        fail += (not ok)
        print("PASS" if ok else "FAIL", f"| div {div} | 컬럼 = 기존 {len(oc)} + PARTIAL_PLAN_YN: {ok_cols} | 행 수 {len(orows)} = {len(nrows)}: {ok_cnt}"
              f" | 기존 컬럼 값 동일: {ok_val} (순서까지 동일: {ok_ord}) | 원장과 다른 행 {bad} | 값 분포 {dist}")
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main(sys.argv[1])
