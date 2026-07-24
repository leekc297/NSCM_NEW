# -*- coding: utf-8 -*-
"""클라우드 배포용 SQL 생성: 01 wiring(API_M UPDATE + PROC_M 명시 MERGE) / 02 drop standalone. + GTT 복사."""
import os, io, shutil, oracledb
BASE = os.path.dirname(os.path.abspath(__file__))
SQL = os.path.join(BASE,"sql"); os.makedirs(SQL, exist_ok=True)
SP = os.path.join(BASE,"sp")
conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()

MAP = {
 "DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX":"PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX",
 "DMF0021_GET_SPREAD_TITLE":"PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE",
 "DMF0021_GET_SALES_PLAN_MEASUREINFO":"PKG_DMF0021.P_DMF0021_GET_SALES_PLAN_MEASUREINFO",
 "DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL":"PKG_DMF0021.P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL",
}
def esc(v): return "NULL" if v is None else "'"+str(v).replace("'","''")+"'"

out=["-- [DMF0021 PKG CONSOLIDATION 20260723] 배선 전환: standalone -> PKG한정명",
     "-- 적용 순서: PKG(SPEC/BODY) 배포 후 본 파일. audit='admin'.\n"]
out.append("-- ① API_M.API_URL 전환")
for sa,pk in MAP.items():
    out.append(f"UPDATE SCM_MGR.SCM_ADM_API_M SET API_URL='{pk}', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE UPPER(API_URL)='{sa}';")
out.append("\n-- ② PROC_M PKG한정 positional 등록 (명시값 — standalone 행 의존 없음)")
for sa,pk in MAP.items():
    cur.execute("SELECT COL_NM,DATA_TP_CD,COL_TP_CD,SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD",p=pk)
    for col,dt,ct,so in cur.fetchall():
        out.append(f"MERGE INTO SCM_MGR.SCM_ADM_PROC_M t USING (SELECT '{pk}' PROC_NM,{esc(col)} COL_NM,{esc(ct)} COL_TP_CD FROM DUAL) s "
                   f"ON (t.PROC_NM=s.PROC_NM AND t.COL_NM=s.COL_NM AND t.COL_TP_CD=s.COL_TP_CD) "
                   f"WHEN MATCHED THEN UPDATE SET t.DATA_TP_CD={esc(dt)},t.SORT_ORD={so},t.LAST_UPDATED_BY='admin',t.LAST_UPDATE_DATE=SYSDATE "
                   f"WHEN NOT MATCHED THEN INSERT (PROC_NM,COL_NM,DATA_TP_CD,COL_TP_CD,SORT_ORD,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE) "
                   f"VALUES ('{pk}',{esc(col)},{esc(dt)},{esc(ct)},{so},'admin',SYSDATE,'admin',SYSDATE);")
out.append("\nCOMMIT;")
with io.open(os.path.join(SQL,"01_wiring_API_PROC_M.sql"),"w",encoding="utf-8",newline="") as f: f.write("\n".join(out))
print("01_wiring written")

d=["-- [DMF0021 PKG CONSOLIDATION 20260723] standalone 삭제 (참조0 확인 후) + 고아 PROC_M 정리",
   "-- ⚠ 반드시 01_wiring 적용·검증 후 실행. 미존재(-4043) skip.\n"]
allsa=list(MAP.keys())+["DMF0021_GET_SALES_PLAN_MEASUREINFO2"]
for sa in allsa:
    d.append(f"BEGIN EXECUTE IMMEDIATE 'DROP PROCEDURE SCM_MGR.{sa}'; EXCEPTION WHEN OTHERS THEN IF SQLCODE!=-4043 THEN RAISE; END IF; END;\n/")
d.append("\nDELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM IN ("+",".join("'"+s+"'" for s in allsa)+");")
d.append("COMMIT;")
with io.open(os.path.join(SQL,"02_drop_standalone.sql"),"w",encoding="utf-8",newline="") as f: f.write("\n".join(d))
print("02_drop written")

# GTT 복사 (기존 배포본에서)
src=r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0021_20260722_1050\sp\00_GTT_DDL_DMF0021.sql"
if os.path.exists(src):
    shutil.copy(src, os.path.join(SP,"00_GTT_DDL_DMF0021.sql")); print("GTT copied")
else:
    print("GTT src 없음:", src)
