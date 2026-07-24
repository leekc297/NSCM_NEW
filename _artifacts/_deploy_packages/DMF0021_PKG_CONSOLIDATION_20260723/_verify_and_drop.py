# -*- coding: utf-8 -*-
"""버튼→PKG 도달 검증 + 참조0 재확인 후 standalone 5 DROP + 고아 PROC_M 정리."""
import os, io, oracledb
conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()

print("== 버튼 → API_URL(PKG) 도달 (MNU_ID=DMF0021) ==")
cur.execute("""SELECT b.SHT_NM,b.MNU_BTN_CD,a.API_URL FROM SCM_ADM_MNU_BTN_MPG_M b
  JOIN SCM_ADM_API_M a ON a.API_ID=b.API_ID WHERE b.MNU_ID='DMF0021'
  AND UPPER(a.API_URL) LIKE '%DMF0021%' ORDER BY 1,2""")
for r in cur.fetchall(): print(f"   [{r[0]}/{r[1]}] -> {r[2]}")

DROP = ["DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX","DMF0021_GET_SPREAD_TITLE",
        "DMF0021_GET_SALES_PLAN_MEASUREINFO","DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL",
        "DMF0021_GET_SALES_PLAN_MEASUREINFO2"]

print("\n== 삭제 전 참조0 재확인 ==")
safe=True
for sa in DROP:
    cur.execute("SELECT COUNT(*) FROM SCM_ADM_API_M WHERE UPPER(API_URL)=:s", s=sa); api=cur.fetchone()[0]
    cur.execute("""SELECT COUNT(*) FROM all_dependencies WHERE referenced_name=:s AND referenced_owner='SCM_MGR'
       AND referenced_type IN ('PROCEDURE','FUNCTION') AND name<>:s""", s=sa); dep=cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM SCM_ADM_CMBO_SQL_M WHERE DBMS_LOB.INSTR(SQL_DTL_CTN,:s)>0", s=sa); cmb=cur.fetchone()[0]
    ok = (api==0 and dep==0 and cmb==0)
    safe = safe and ok
    print(f"   {sa}: API={api} DEP={dep} CMBO={cmb} {'SAFE' if ok else 'BLOCK'}")

if not safe:
    print("\n중단: 참조 잔존. DROP 안 함."); raise SystemExit(1)

print("\n== DROP standalone + 고아 PROC_M 정리 ==")
for sa in DROP:
    cur.execute(f'DROP PROCEDURE "SCM_MGR"."{sa}"'); print("  DROP PROC:", sa)
    cur.execute("DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM=:s", s=sa)
    if cur.rowcount: print(f"    PROC_M 고아 {cur.rowcount}행 삭제")
conn.commit()

print("\n== 최종 확인 ==")
cur.execute("""SELECT object_name,status FROM user_objects WHERE object_type='PROCEDURE' AND object_name LIKE '%DMF0021%'""")
print("  잔존 standalone DMF0021 PROC:", cur.fetchall() or "없음")
cur.execute("SELECT object_type,status FROM user_objects WHERE object_name='PKG_DMF0021'")
print("  PKG:", cur.fetchall())
