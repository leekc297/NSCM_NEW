"""적용 후 검증 (사내 ZIOUI1) — ① VALID·마커 ② L384 첫 갈래 SELECT: 함수 술어 vs 변수(바인드) 건수·합계 동일 ③ 통계 갱신(DM_PLN_MKT_FCST · DM_PLN_CFM_MKT_DEMAND_PLAN)"""
import sys, json, time, os
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
import oracledb
HERE = os.path.dirname(os.path.abspath(__file__))
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
R = {}
cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND OBJECT_TYPE='PROCEDURE'")
R["object"] = cur.fetchone()
cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND TEXT LIKE '%E20261007-DATEVAR%'"); R["markers"] = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND TEXT LIKE '%TO_CHAR(FN_NEXT_DAY(SYSDATE, ''MON'')%' AND TEXT NOT LIKE '%V_FROM_%'"); R["func_predicates_left"] = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM ALL_DEPENDENCIES WHERE REFERENCED_OWNER='SCM_MGR' AND REFERENCED_NAME='PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND OWNER='SCM_MGR'"); R["dependents"] = cur.fetchone()[0]
cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID' AND OBJECT_TYPE IN ('PROCEDURE','PACKAGE BODY','FUNCTION','VIEW','TRIGGER')"); R["invalid_objects"] = cur.fetchall()
# ② 동치
base = """SELECT COUNT(*), NVL(SUM(F.QTY),0) FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID
   AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = :div AND F.YYYYMMDD >= {d}
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]')"""
for div in ("40", "81", "82"):
    t0 = time.time(); cur.execute(base.format(d="TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')"), div=div); a = cur.fetchone(); ta = time.time() - t0
    cur.execute("SELECT TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') FROM dual"); v = cur.fetchone()[0]
    t0 = time.time(); cur.execute(base.format(d=":v"), div=div, v=v); b = cur.fetchone(); tb = time.time() - t0
    R[f"equiv_{div}"] = dict(func=[int(a[0]), float(a[1])], var=[int(b[0]), float(b[1])], same=(a[0] == b[0] and float(a[1]) == float(b[1])), sec_func=round(ta, 1), sec_var=round(tb, 1), v_from_1w=v)
# ③ 통계 갱신 (사내)
for t in ("DM_PLN_MKT_FCST", "DM_PLN_CFM_MKT_DEMAND_PLAN"):
    t0 = time.time()
    cur.callproc("DBMS_STATS.GATHER_TABLE_STATS", keyword_parameters=dict(ownname="SCM_MGR", tabname=t, cascade=True, degree=4))
    cur.execute("SELECT NUM_ROWS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI:SS') FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=t)
    R[f"stats_{t}"] = dict(num_rows=cur.fetchone()[0], analyzed=cur.fetchone.__self__.fetchone() if False else None, sec=round(time.time() - t0, 1))
    cur.execute("SELECT TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI:SS') FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=t); R[f"stats_{t}"]["analyzed"] = cur.fetchone()[0]
json.dump(R, open(os.path.join(HERE, "_verify_result.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
print(json.dumps(R, ensure_ascii=False, indent=1, default=str))
