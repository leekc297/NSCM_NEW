"""캐시 통제 재측정 — 변수(바인드) 먼저, 함수 술어 나중 (40). 두 번째가 캐시 이득을 받는데도 함수 쪽이 느리면 계획 차이가 원인"""
import sys, json, time, os
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
import oracledb
HERE = os.path.dirname(os.path.abspath(__file__))
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
base = """SELECT COUNT(*), NVL(SUM(F.QTY),0) FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID
   AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = :div AND F.YYYYMMDD >= {d}
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')"""
R = {}
for div in ("40",):
    cur.execute("SELECT TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') FROM dual"); v = cur.fetchone()[0]
    t0 = time.time(); cur.execute(base.format(d=":v"), div=div, v=v); b = cur.fetchone(); tb = time.time() - t0
    t0 = time.time(); cur.execute(base.format(d="TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')"), div=div); a = cur.fetchone(); ta = time.time() - t0
    t0 = time.time(); cur.execute(base.format(d=":v"), div=div, v=v); c = cur.fetchone(); tc = time.time() - t0
    R[div] = dict(var_first_sec=round(tb, 1), func_second_sec=round(ta, 1), var_third_sec=round(tc, 1), cnt=[int(b[0]), int(a[0]), int(c[0])])
    for label, sql in (("var", base.format(d=":v")), ("func", base.format(d="TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')"))):
        cur.execute(f"EXPLAIN PLAN SET STATEMENT_ID = '{label}' FOR " + sql.replace(":div", "'40'").replace(":v", "'" + v + "'"))
        cur.execute(f"SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE', '{label}', 'BASIC +ROWS'))")
        R[div]["plan_" + label] = [r[0] for r in cur if r[0] and ("|" in r[0]) and "Id" not in r[0] and "---" not in r[0]]
print(json.dumps(R, ensure_ascii=False, indent=1))
json.dump(R, open(os.path.join(HERE, "_cache_control_result.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
