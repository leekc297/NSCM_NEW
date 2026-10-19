# GAP 257 E2E — 원장에 없는 시험 키(ZZGAP257*)만 사용, 종료 시 전량 삭제
#   K1 40 · 키/FCST/INCO 전부 '-'(이관 빈값)   → 채워져야 함
#   K2 40 · 키/FCST/INCO 전부 '/'(신규 빈값)   → 채워져야 함
#   K3 81 · FCST/INCO '-'                      → 40 조건으로 채우지 않아야 함
# 재현값 = FE 실전송값: 40 의 DEPT_ID/END_CUSTOMER/BIZ_TYPE 는 '' 전송(GT 에서 '/' 강제), ITEM_USE 는 그리드 표시값
import sys, oracledb
sys.path.insert(0, '_artifacts/_diagnostics'); import ora
u, p, d = ora.conn_info(); cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); print('HOST', cur.fetchone()[0])

KEYS = {  # div, item, sentinel, cps, item_use sent by FE, dept/ecust/biz sent
    'K1': ('40', 'ZZGAP257K1', '-', 'A01', '-', ('', '', '')),
    'K2': ('40', 'ZZGAP257K2', '/', 'A01', '', ('', '', '')),
    'K3': ('81', 'ZZGAP257K3', '-', 'Z01', '-', ('58124293', 'HKMC', '')),
}
INS = """INSERT INTO DM_PLN_BP_FCST (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, MEASURE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER,
 BIZ_TYPE, YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY, INCOTERMS, CELL_PROD_SITE, PROJECT_NAME, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 VALUES (:dv, 'ZZGAP257', 'ZZGAP257_SITE', :it, :s, :ms, :s, :dept, :ecust, :s, '202412', 'USD', :s, 0, :s, :cps, 'ZZGAP257', 10, 'GAP257', SYSDATE, 'GAP257', SYSDATE)"""

def show(tag):
    cur.execute("SELECT DIVISION_ID, ITEM_ID, MEASURE, YYYYMM, FCST_TYPE, INCOTERMS, DEPT_ID, END_CUSTOMER, BIZ_TYPE, ITEM_USE, QTY FROM DM_PLN_BP_FCST "
                "WHERE PROJECT_CODE='ZZGAP257' ORDER BY ITEM_ID, MEASURE, YYYYMM")
    print('--', tag)
    for r in cur.fetchall(): print('  ', r)

def cleanup():
    cur.execute("DELETE FROM DM_PLN_BP_FCST WHERE PROJECT_CODE='ZZGAP257'"); n = cur.rowcount; cn.commit(); return n

try:
    cleanup()
    for k, (dv, it, s, cps, iu, (dept, ec, bz)) in KEYS.items():
        sd = s if dv == '40' else dept
        se = s if dv == '40' else ec
        for ms in ('Business_Plan', 'LOC'):
            cur.execute(INS, dv=dv, it=it, s=s, ms=ms, cps=cps, dept=sd, ecust=se)
    cn.commit(); show('SEED')
    for k, (dv, it, s, cps, iu, (dept, ec, bz)) in KEYS.items():
        rc = cur.var(oracledb.DB_TYPE_CURSOR)
        cur.callproc('PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST',
                     ['M', dv, 'ZZGAP257', 'ZZGAP257', 'ZZGAP257_SITE', '' if dv == '40' else '-', it, 'MPS', 'FCA', iu, '0',
                      'Business_Plan', '202611', '5', 'USD', dept, ec, bz, cps, 'minyonglee1', 'minyonglee1', rc])
        res = rc.getvalue().fetchall() if rc.getvalue() else None
        print('CALL', k, dv, '->', res)
    show('AFTER')
finally:
    print('CLEANUP deleted', cleanup())
