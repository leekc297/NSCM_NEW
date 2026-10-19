"""GAP 392 재현 — FE 실전송값(BE 로그 10-15 15:10)으로 두 SP 를 호출해 Project 순서를 AS-IS 콜레이션 정렬과 대조.

AS-IS 정렬 = 같은 값 목록을 AS-IS DB(LGCE_SCMDEV, Latin1_General_CI_AS)에서 ORDER BY 한 순서 (인덱스로 왕복 — 문자 인코딩 무관)
사용: python repro.py <label>   → <label>.out.txt
"""
import os, sys, subprocess, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info

HERE = os.path.dirname(os.path.abspath(__file__))
P = dict(div="40", ver="R_S_20260823_V003", fr="202501", to="202712", user="minyonglee1", menu="DMF0068")
PW = [l.split("=", 1)[1].strip() for l in open(r"C:\Projects\NSCM\.env.asis", encoding="utf-8") if l.startswith("ASIS_DB_PASS")][0]


def asis_order(vals):
    vs = ",".join(f"({i},N'" + v.replace("'", "''") + "')" for i, v in enumerate(vals))
    sql = f"SET NOCOUNT ON; SELECT i FROM (VALUES {vs}) t(i,v) ORDER BY v COLLATE Latin1_General_CI_AS"
    r = subprocess.run(["sqlcmd", "-S", "165.244.95.223,1433", "-d", "LGCE_SCMDEV", "-U", "scp_mgr_dev", "-P", PW, "-C", "-W", "-h", "-1", "-Q", sql], capture_output=True)
    idx = [int(x) for x in r.stdout.decode().split() if x.isdigit()]
    assert len(idx) == len(vals), f"AS-IS 정렬 실패 {r.stderr.decode('utf-8', 'replace')[:300]}"
    return [vals[i] for i in idx]


def main(label):
    u, p, d = conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    out = [f"DB {cur.fetchone()} params {P}"]
    # Project 셀 콤보
    rc1, rcr = cn.cursor(), cn.cursor()
    cur.callproc("SCM_MGR.PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT", [P["div"], P["ver"], P["user"], P["menu"], rc1, rcr])
    look = [r[0] for r in rc1]
    out.append(f"LOOKUP result={rcr.fetchall()} n={len(look)}")
    # 조회 결과
    rc1, rc2, rcr = cn.cursor(), cn.cursor(), cn.cursor()
    cur.callproc("SCM_MGR.PKG_DMF0068.P_DMF0068_GET_ORDERLIST", [P["div"], P["ver"], P["fr"], P["to"], P["user"], P["menu"], rc1, rc2, rcr])
    cols = [c[0] for c in rc1.description]
    rows = rc1.fetchall()
    pi = cols.index("PROJECT_NAME")
    seq = []
    for r in rows:
        if not seq or seq[-1] != r[pi]:
            seq.append(r[pi])
    out.append(f"ORDERLIST result={rcr.fetchall()} rows={len(rows)} project_runs={len(seq)} distinct={len(set(seq))}")
    for k, vals in (("LOOKUP", look), ("ORDERLIST", seq)):
        a = asis_order(vals)
        diff = [i for i, (x, y) in enumerate(zip(vals, a)) if x != y]
        out.append(f"== {k}: n={len(vals)} AS-IS 대비 위치 다름 {len(diff)}건 → {'PASS' if not diff else 'FAIL'}")
        for i, (x, y) in enumerate(zip(vals, a)):
            out.append(f"  {i+1:2} {'  ' if x == y else '≠ '}TOBE={x}  |  ASIS={y}")
    txt = "\n".join(out)
    open(os.path.join(HERE, f"{label}.out.txt"), "w", encoding="utf-8").write(txt)
    print("\n".join(l for l in out if not l.startswith("  ") or "≠" in l))


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "repro")
