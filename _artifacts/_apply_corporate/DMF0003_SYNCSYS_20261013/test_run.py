"""[E20261013-DMF0003SYNCSYS] 동기화 프로시저 실행 전후 비교 (사내 ZIOUI1)

⛔ 사용 중지 (2026-10-13 사용자 지시 "데이터를 일괄 수정할 필요는 없습니다").
   이 스크립트는 프로시저를 실제로 실행한다. 프로시저가 내부에서 COMMIT 하므로 ROLLBACK 으로 되돌려지지 않고,
   82 Sales Plan(당주 이후) 전 행이 다시 기록된다. 'old' 는 10-13 15:33 에 1회 실행됐고 'new' 는 실행하지 않았다.
   검증은 test_expr.py (테이블을 건드리지 않음) 로 한다.

  python test_run.py old   # 적용 전: 종전 프로시저를 실행해 결과 스냅샷 A 저장 → ROLLBACK
  python test_run.py new   # 적용 후: 보완 프로시저를 실행해 결과 B 를 A 와 행 단위 비교 → ROLLBACK

대상 = DM_PLN_SALES_PLAN · 82 · 당주 월요일 이후 (프로시저가 다시 쓰는 범위).
실행 사용자 = 'minyonglee1' (지금 사내 82 Sales Plan 전 행의 수정자와 같은 값 — 종전 프로시저 결과가 현재 상태와 같아지도록).
실행 뒤 ROLLBACK 하고, 실행 전 상태로 돌아왔는지(행 수·내용)를 확인해 출력한다.

기대 (B vs A)
  - 행 키 · 수량 · 통화 : 전 행 동일
  - 수량 메저 : 생성자 · 생성 시각 = A 와 동일(원장 값) / 수정자 = 'SYSTEM'
  - 금액 메저 : 생성자 = 'SYSTEM' (A 는 실행 사용자) / 수정자 = 'SYSTEM'
"""
import sys, os, pickle
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
SNAP = os.path.join(HERE, "_snapshot_old.pkl")
USER = "minyonglee1"
QTY_MEAS = {"MKT_FCST", "CUST_FCST", "TMM_FCST", "RTF", "RTF_SYS_RP"}
AMT_MEAS = {"SalesAmt_KRW", "SalesAmt_LOC", "SalesAmt_USD", "MKT_AMT_KRW", "MKT_AMT_LOC"}

Q = """SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
            , CURRENCY, QTY, CREATED_BY, TO_CHAR(CREATION_DATE, 'YYYYMMDDHH24MISS'), LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE, 'YYYYMMDDHH24MISS')
       FROM   SCM_MGR.DM_PLN_SALES_PLAN
       WHERE  DIVISION_ID = '82' AND YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')"""


def snap(cur):
    cur.execute(Q)
    d = {}
    for r in cur.fetchall():
        k = r[:10]
        assert k not in d, f"키 중복 {k}"
        d[k] = r[10:]
    return d


def run(cur):
    cur.execute("SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') FROM dual")
    t0 = cur.fetchone()[0]
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("SCM_MGR.PKG_DMF0003.P_DMF0003_MKT_FCST_SALES_PLAN_SYNC", ["82", USER, rc])
    c = rc.getvalue()
    res = c.fetchall() if c is not None else None
    return t0, res


def by_meas(d, idx=None, pred=None):
    out = {}
    for k, v in d.items():
        if pred is None or pred(k, v):
            out[k[6]] = out.get(k[6], 0) + 1
    return dict(sorted(out.items()))


def main():
    mode = sys.argv[1]
    u, p, dsn = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=dsn)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", dsn, cur.fetchone(), "mode", mode)
    cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0003' AND type='PACKAGE BODY' AND text LIKE '%E20261013-DMF0003SYNCSYS%'")
    marker = cur.fetchone()[0]
    if (mode == "old") != (marker == 0):
        sys.exit(f"ABORT: mode={mode} 인데 BODY 마커 {marker}곳 (old 는 0, new 는 1 이상이어야 함)")
    s0 = snap(cur)
    print("실행 전 행 수", len(s0), "수정자 분포", sorted({v[4] for v in s0.values()}))
    con.rollback()   # 조회 트랜잭션 종료 (프로시저가 세션 병렬 설정을 바꿀 수 있게)
    t0, res = run(cur)
    print("프로시저 결과 커서", res)
    after = snap(cur)
    con.rollback()
    back = snap(cur)
    restored = back == s0
    print("ROLLBACK 뒤 실행 전 상태 복원:", restored, "(False 면 프로시저 내부에서 확정됨 — 결과가 DB 에 남는다)")
    written = {k: v for k, v in after.items() if v[5] >= t0}
    print("이번 실행이 기록한 행", len(written), "/", len(after), "| 메저별", by_meas(written))
    if mode == "old":
        pickle.dump({"after": after, "t0": t0}, open(SNAP, "wb"))
        print("수정자 분포(기록한 행):", sorted({v[4] for v in written.values()}))
        print("생성자 분포(금액 메저):", sorted({v[2] for k, v in written.items() if k[6] in AMT_MEAS}))
        print("SNAPSHOT A SAVED", len(after))
        return
    A = pickle.load(open(SNAP, "rb"))["after"]
    B = after
    fail = []
    if set(A) != set(B):
        fail.append(f"키 집합 다름: A-B {len(set(A) - set(B))} / B-A {len(set(B) - set(A))}")
    common = set(A) & set(B)
    n_qty = sum(1 for k in common if A[k][1] != B[k][1])
    n_cur = sum(1 for k in common if A[k][0] != B[k][0])
    if n_qty or n_cur:
        fail.append(f"수량 다름 {n_qty} · 통화 다름 {n_cur}")
    wk = [k for k in common if B[k][5] >= t0]
    q = [k for k in wk if k[6] in QTY_MEAS]
    a = [k for k in wk if k[6] in AMT_MEAS]
    other = [k for k in wk if k[6] not in QTY_MEAS | AMT_MEAS]
    c1 = sum(1 for k in q if B[k][2] == A[k][2] and B[k][3] == A[k][3])
    c2 = sum(1 for k in q if B[k][4] == "SYSTEM")
    c3 = sum(1 for k in a if B[k][2] == "SYSTEM" and B[k][3] >= t0)
    c4 = sum(1 for k in a if B[k][4] == "SYSTEM")
    c5 = sum(1 for k in a if A[k][2] == USER)
    c6 = sum(1 for k in wk if A[k][4] == USER)
    print(f"수량 메저 {len(q)}행 | 생성자·생성 시각 = 종전과 동일 {c1} | 수정자 SYSTEM {c2}")
    print(f"금액 메저 {len(a)}행 | 생성자 SYSTEM·생성 시각 = 실행 시각 {c3} | 수정자 SYSTEM {c4} | (종전 생성자 = 실행 사용자 {c5})")
    print(f"종전 실행에서는 수정자 = 실행 사용자 {c6} / {len(wk)}")
    print("수량 메저 생성자 분포:", sorted({str(B[k][2]) for k in q})[:12])
    if other:
        fail.append(f"대상 밖 메저가 기록됨 {by_meas({k: B[k] for k in other})}")
    if c1 != len(q) or c2 != len(q):
        fail.append("수량 메저 규칙 불일치")
    if c3 != len(a) or c4 != len(a):
        fail.append("금액 메저 규칙 불일치")
    not_written = [k for k in common if B[k][5] < t0]
    print("이번 실행이 건드리지 않은 행", len(not_written), by_meas({k: B[k] for k in not_written}))
    print("RESULT", "PASS" if not fail else "FAIL " + " / ".join(fail))
    sys.exit(0 if not fail else 1)


if __name__ == "__main__":
    main()
