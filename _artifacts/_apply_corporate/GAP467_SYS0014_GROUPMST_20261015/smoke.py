"""GAP 467 화면 SP 스모크 — 그룹 목록 · 그룹별 사용자 · 그룹별 사업부 권한 (조회 전용)."""
import sys, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
u, p, d = conn_info(); cur = oracledb.connect(user=u, password=p, dsn=d).cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print("DB", cur.fetchone())
def call(name, args):
    o = [cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)]
    cur.callproc("SCM_MGR.PKG_SYS0014." + name, args + o)
    rows = o[0].getvalue().fetchall(); res = o[1].getvalue().fetchall()
    return rows, res
rows, res = call("P_SYS0014_GET_GROUP_LIST_M", [""])
print("GROUP LIST", len(rows), res); print("  ", [r[0] for r in rows])
for g in ["CAPA Planner", "System Monitor", "SSP ADMIN", "-"]:
    ur, r1 = call("P_SYS0014_GET_USER_BY_GROUP_M", [g])
    ar, r2 = call("P_SYS0014_GET_AUTH_LIST_M", [g, "", ""])
    print(f"  {g!r}: users {len(ur)} {r1[0][:2]} / auth {len(ar)} {r2[0][:2]}")
cur.execute("SELECT A.USER_GR_ID, A.USER_ID, COUNT(*) FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A WHERE A.USER_GR_ID IN ('CAPA Planner','System Monitor') AND A.UNIT_TP_CD='D' GROUP BY A.USER_GR_ID, A.USER_ID ORDER BY 3 DESC FETCH FIRST 1 ROWS ONLY")
for g, uid, n in cur.fetchall():
    ur, _ = call("P_SYS0014_GET_USER_BY_GROUP_M", [g])
    ar, r2 = call("P_SYS0014_GET_AUTH_LIST_M", [g, uid, "D"])
    print(f"  {g!r} user {uid}: in user list {uid in [r[0] for r in ur]} · auth rows {len(ar)} (ledger {n}) {r2[0][:2]}")
cur.execute("SELECT COUNT(*) FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A WHERE A.USER_GR_ID IN ('CAPA Planner','System Monitor') AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M M WHERE M.USER_GR_ID=A.USER_GR_ID AND M.USER_ID=A.USER_ID)")
print("  권한 행 중 사용자 목록에 없는 사용자의 행:", cur.fetchone()[0])
