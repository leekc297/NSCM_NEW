# 2-14 INSERT 문 그대로(사내 적용본 원문, 1행 추정 재현) : 원문(W.ASIS) vs 적용본(W.TOBE) 소요, 적재 행, 수량 합
import sys, io, re, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
import w2
def ins(fn):
    src = io.open(fn, encoding='utf-8').read()
    i = src.index('/* 2-14. [I]WH_STOC'); j = src.index('INSERT INTO GT_SSP_ANL_SHIP_PLAN_40', i); k = src.index('\n        ;', j)
    q = src[j:k]
    z = "          , Z AS (\n                    SELECT DISTINCT"
    assert q.count(z) == 1
    return q.replace(z, "          , Z AS (\n                    SELECT /*+ CARDINALITY(P 1) */ DISTINCT")
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 300000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2"); c.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE")
c.execute("""SELECT LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY COLUMN_ID) FROM ALL_TAB_COLUMNS T WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_SSP_ANL_SHIP_PLAN_40'
  AND EXISTS (SELECT 1 FROM ALL_TAB_COLUMNS S WHERE S.OWNER='SCM_MGR' AND S.TABLE_NAME='SSP_ANL_SHIP_PLAN_40' AND S.COLUMN_NAME=T.COLUMN_NAME)""")
gc = c.fetchone()[0]
c.execute("INSERT INTO GT_SSP_ANL_SHIP_PLAN_40 (" + gc + ") SELECT " + gc + """ FROM SSP_ANL_SHIP_PLAN_40 P
 WHERE P.DIVISION_ID='40' AND P.PLAN_START_YYYYMMDD='20261121' AND P.PLAN_TYPE='SP' AND P.SEQ=1 AND P.MEASURE NOT IN ('WH_STOCK','BALANCE')
   AND EXISTS (SELECT 1 FROM SCM_MST_SITE E WHERE E.DIVISION_ID='40' AND NVL(E.COMPANY_ID,'-')='HQ00' AND E.SCM_SITE_ID=P.FROM_SITE)""")
print('GT 적재', c.rowcount, flush=True)
c.execute("SAVEPOINT S0")
for nm, fn in [('ASIS', 'PR_SSP_ANL_SHIP_PLAN_40.W.ASIS.sql'), ('TOBE', 'PR_SSP_ANL_SHIP_PLAN_40.W.TOBE.sql')]:
    q, b = w2.prep(ins(fn), 'W14I_' + nm + time.strftime('%H%M%S'))
    t = time.time(); c.execute(q, b); n = c.rowcount; el = time.time() - t
    c.execute("SELECT COUNT(*), SUM(QTY), SUM(ORA_HASH(ITEM_ID||'|'||FROM_SITE||'|'||YYYYMMDD||'|'||QTY)) FROM GT_SSP_ANL_SHIP_PLAN_40 WHERE MEASURE='WH_STOCK'")
    print(nm, '%.2fs' % el, '적재', n, c.fetchone(), flush=True)
    c.execute("ROLLBACK TO SAVEPOINT S0")
cx.rollback()
