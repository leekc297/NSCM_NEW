# SCP0111 ADMIN 'M' 저장 시험 - PLAN_START=20991231 · DIVISION_ID='ZZ' 전용 행만 만들고 끝에 삭제한다
import pathlib, sys
ROOT = pathlib.Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / '_artifacts' / '_diagnostics'))
import ora, oracledb
u, p, d = ora.conn_info()
con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute('ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR')
PS, DIV = '20991231', 'ZZ'
W = "PLAN_START_YYYYMMDD=:ps AND DIVISION_ID=:dv"
MONTHS = ['209912', '210001', '210002']
KEY = dict(company='C1', plant='P1', og='P', cell='CELLT', item='ITEMT', vt='VT', tp='TP', line='L1', site='S1', inc='FOB', pt='PT', seq='61')

def pre():
    cur.execute(f"SELECT COUNT(*) FROM SCP_ANL_PSI_INTEGRATION WHERE {W}", ps=PS, dv=DIV)
    n = cur.fetchone()[0]; assert n == 0, f'기존 시험 행 {n}건 - 중단'
    for m, boh, q in [('INV', 100, [10, 20, 30]), ('PROD_PLAN', 0, [1, 2, 3])]:
        for ym, qty in zip(MONTHS, q):
            cur.execute("""INSERT INTO SCP_ANL_PSI_INTEGRATION
              (DIVISION_ID,COMPANY_ID,PLANT_ID,PLAN_START_YYYYMMDD,SEQ,OPERATION_GROUP,FROM_SITE,CELL_ITEM_ID,ITEM_ID,MEASURE,
               VALUE_TYPE,TO_PRODUCT,LINE_ID,BOH_QTY,TO_SITE,INCOTERMS,SEQ_FLAG,YYYYMM,QTY,ATTRIBUTE2,
               CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
              VALUES (:dv,:co,:pl,:ps,1,:og,'-',:ce,:it,:me,:vt,:tp,:li,:boh,:si,:inc,:sq,:ym,:q,:pt,'SCP0111_TEST',SYSDATE,'SCP0111_TEST',SYSDATE)""",
              dv=DIV, co=KEY['company'], pl=KEY['plant'], ps=PS, og=KEY['og'], ce=KEY['cell'], it=KEY['item'], me=m,
              vt=KEY['vt'], tp=KEY['tp'], li=KEY['line'], boh=boh, si=KEY['site'], inc=KEY['inc'], sq=KEY['seq'], ym=ym, q=qty, pt=KEY['pt'])
    con.commit()

def call(cells):
    j = lambda f: '^'.join(f(c) for c in cells)
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc('PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN', [
        j(lambda c: 'M'), j(lambda c: KEY['pt']), j(lambda c: DIV), j(lambda c: KEY['company']), j(lambda c: KEY['plant']), PS,
        j(lambda c: KEY['og']), j(lambda c: KEY['cell']), j(lambda c: KEY['item']), j(lambda c: c[0]), j(lambda c: KEY['vt']),
        j(lambda c: KEY['tp']), j(lambda c: KEY['line']), j(lambda c: KEY['site']), j(lambda c: KEY['inc']), j(lambda c: str(c[2])),
        j(lambda c: KEY['seq']), j(lambda c: c[1]), j(lambda c: str(c[3])), 'SCP0111_TEST', rc])
    return rc.getvalue().fetchall()

def state():
    cur.execute(f"SELECT MEASURE,YYYYMM,BOH_QTY,QTY FROM SCP_ANL_PSI_INTEGRATION WHERE {W} ORDER BY MEASURE,YYYYMM", ps=PS, dv=DIV)
    return [tuple(r) for r in cur]

def check(name, res, expect):
    got = state(); ok = (res[0][3] == 'S') and got == expect
    print(name, 'PASS' if ok else 'FAIL', res[0][:5]); 
    if not ok: print('  got', got); print('  exp', expect)
    return ok

try:
    pre(); allok = True
    # cell = (measure, yyyymm, bohQty 절대값, modiQty 절대값) - 새 FE(AS-IS cs:1286~1368) 전송 형태
    # S1 INV BOH 100->150 : 전체 월, QTY 는 화면값 그대로
    r = call([('INV', ym, 150, q) for ym, q in zip(MONTHS, [10, 20, 30])])
    allok &= check('S1 INV BOH', r, [('INV','209912',150,10),('INV','210001',150,20),('INV','210002',150,30),('PROD_PLAN','209912',0,1),('PROD_PLAN','210001',0,2),('PROD_PLAN','210002',0,3)])
    # S2 INV 월 수량 210001 20->25 : 그 월만
    r = call([('INV', '210001', 150, 25)])
    allok &= check('S2 INV MONTH', r, [('INV','209912',150,10),('INV','210001',150,25),('INV','210002',150,30),('PROD_PLAN','209912',0,1),('PROD_PLAN','210001',0,2),('PROD_PLAN','210002',0,3)])
    # S3 PROD_PLAN BOH 0->5 : 전체 월 BOH, QTY 그대로
    r = call([('PROD_PLAN', ym, 5, q) for ym, q in zip(MONTHS, [1, 2, 3])])
    allok &= check('S3 PROD BOH', r, [('INV','209912',150,10),('INV','210001',150,25),('INV','210002',150,30),('PROD_PLAN','209912',5,1),('PROD_PLAN','210001',5,2),('PROD_PLAN','210002',5,3)])
    # S4 PROD_PLAN 월 수량 2개 동시 : 209912 1->7, 210002 3->0
    r = call([('PROD_PLAN', '209912', 5, 7), ('PROD_PLAN', '210002', 5, 0)])
    allok &= check('S4 PROD MONTHS', r, [('INV','209912',150,10),('INV','210001',150,25),('INV','210002',150,30),('PROD_PLAN','209912',5,7),('PROD_PLAN','210001',5,2),('PROD_PLAN','210002',5,0)])
    # S5 빈 BOH 문자열 = 0 (AS-IS '' -> 0 암묵 변환과 같음)
    r = call([('PROD_PLAN', '210001', '', 9)])
    allok &= check('S5 EMPTY BOH', r, [('INV','209912',150,10),('INV','210001',150,25),('INV','210002',150,30),('PROD_PLAN','209912',5,7),('PROD_PLAN','210001',0,9),('PROD_PLAN','210002',5,0)])
    print('ALL', 'PASS' if allok else 'FAIL')
finally:
    cur.execute(f"DELETE FROM SCP_ANL_PSI_INTEGRATION WHERE {W}", ps=PS, dv=DIV); print('deleted', cur.rowcount); con.commit()
    cur.execute(f"SELECT COUNT(*) FROM SCP_ANL_PSI_INTEGRATION WHERE {W}", ps=PS, dv=DIV); print('remain', cur.fetchone()[0])
