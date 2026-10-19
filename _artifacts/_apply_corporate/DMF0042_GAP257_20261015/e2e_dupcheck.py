# 범위 밖 관찰 확인(조회·시험키 전용, 종료 시 삭제): 기존 '-' 키 행(값 채워짐)을 같은 키로 재저장 시 '/' 행 중복 생성 여부 — 40
import sys, oracledb
sys.path.insert(0, '_artifacts/_diagnostics'); import ora
u, p, d = ora.conn_info(); cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
def show(t):
    cur.execute("SELECT MEASURE, YYYYMM, FCST_TYPE, INCOTERMS, DEPT_ID, END_CUSTOMER, BIZ_TYPE, ITEM_USE, QTY FROM DM_PLN_BP_FCST WHERE PROJECT_CODE='ZZGAP257' ORDER BY MEASURE, YYYYMM, DEPT_ID")
    print('--', t); [print('  ', r) for r in cur.fetchall()]
try:
    cur.execute("DELETE FROM DM_PLN_BP_FCST WHERE PROJECT_CODE='ZZGAP257'")
    for ms in ('Business_Plan', 'LOC'):
        cur.execute("""INSERT INTO DM_PLN_BP_FCST (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, MEASURE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE, YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY, INCOTERMS, CELL_PROD_SITE, PROJECT_NAME, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
          VALUES ('40','ZZGAP257','ZZGAP257_SITE','ZZGAP257K4','MPS',:ms,'-','-','-','-','202611','USD','-',0,'FCA','A01','ZZGAP257',10,'GAP257',SYSDATE,'GAP257',SYSDATE)""", ms=ms)
    cn.commit(); show('SEED (기존 40 행 형태: 키 센티널 -)')
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc('PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST', ['M','40','ZZGAP257','ZZGAP257','ZZGAP257_SITE','','ZZGAP257K4','MPS','FCA','-','0','Business_Plan','202611','7','USD','','','','A01','minyonglee1','minyonglee1', rc])
    print('CALL ->', rc.getvalue().fetchall()); show('AFTER 같은 키 Business_Plan 202611 = 7 저장')
finally:
    cur.execute("DELETE FROM DM_PLN_BP_FCST WHERE PROJECT_CODE='ZZGAP257'"); print('CLEANUP', cur.rowcount); cn.commit()
