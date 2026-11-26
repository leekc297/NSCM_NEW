# 3단계 cy0a8kvgd0cw7 사내 측정 : GTT(계획 40/20261121 HQ00 전 측정값) → 같은 트랜잭션에서 SP 3단계 DELETE → INSERT(변형) → 결과 집계 → ROLLBACK
import sys, io, re, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
src = io.open('PR_SSP_ANL_SHIP_PLAN_40.P.TOBE.sql', encoding='utf-8').read()
i = src.index('/* 3. 최종 SSP_ANL_SHIP_PLAN_40 생성 */')
d0 = src.index('DELETE FROM SSP_ANL_SHIP_PLAN_40 A', i); d1 = src.index('\n        ;', d0)
n0 = src.index('INSERT INTO /* PR_SSP_ANL_SHIP_PLAN_40 */ SSP_ANL_SHIP_PLAN_40', i); n1 = src.index('\n        ;', n0)
VARS = r'\bV_(DIVISION_ID|COMPANY_ID|BATCH_USER|PLAN_START_YYYYMMDD|PLAN_TYPE|SEQ)\b'
dele = re.sub(VARS, r':V_\1', src[d0:d1]); ins = re.sub(VARS, r':V_\1', src[n0:n1])
B = dict(V_DIVISION_ID='40', V_COMPANY_ID='HQ00', V_BATCH_USER='ssp_batch', V_PLAN_START_YYYYMMDD='20261121', V_PLAN_TYPE='SP', V_SEQ=1)
def bb(q): return {k: v for k, v in B.items() if ':' + k in q}
V = {
 'OLD_EMU': ins.replace('SELECT DISTINCT', 'SELECT /*+ CARDINALITY(T 1) */ DISTINCT', 1),
 'HASH_EMU': ins.replace('SELECT DISTINCT', 'SELECT /*+ CARDINALITY(T 1) LEADING(T V E) USE_HASH(V E) */ DISTINCT', 1),
 'OLD': ins,
}
CHK = """SELECT COUNT(*), SUM(QTY), SUM(ORA_HASH(ITEM_ID||'|'||FROM_SITE||'|'||TO_SITE||'|'||MEASURE||'|'||YYYYMMDD||'|'||QTY||'|'||BIZ_TYPE||'|'||CONFIRM_FLAG||'|'||ATTRIBUTE1||'|'||ATTRIBUTE10))
  FROM SSP_ANL_SHIP_PLAN_40 A WHERE A.DIVISION_ID='40' AND A.PLAN_START_YYYYMMDD='20261121' AND A.PLAN_TYPE='SP' AND A.SEQ=1
   AND EXISTS (SELECT 1 FROM SCM_MST_SITE E WHERE E.DIVISION_ID='40' AND NVL(E.COMPANY_ID,'-')='HQ00' AND E.SCM_SITE_ID=A.FROM_SITE)"""
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 900000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2"); c.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE")
c.execute(CHK); print('현재 커밋본', c.fetchone(), flush=True)
c.execute("""SELECT LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY COLUMN_ID) FROM ALL_TAB_COLUMNS T WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_SSP_ANL_SHIP_PLAN_40'
  AND EXISTS (SELECT 1 FROM ALL_TAB_COLUMNS S WHERE S.OWNER='SCM_MGR' AND S.TABLE_NAME='SSP_ANL_SHIP_PLAN_40' AND S.COLUMN_NAME=T.COLUMN_NAME)""")
gc = c.fetchone()[0]
for name, q in V.items():
    c.execute("DELETE FROM GT_SSP_ANL_SHIP_PLAN_40")
    c.execute("INSERT INTO GT_SSP_ANL_SHIP_PLAN_40 (" + gc + ") SELECT " + gc + """ FROM SSP_ANL_SHIP_PLAN_40 P
     WHERE P.DIVISION_ID='40' AND P.PLAN_START_YYYYMMDD='20261121' AND P.PLAN_TYPE='SP' AND P.SEQ=1
       AND EXISTS (SELECT 1 FROM SCM_MST_SITE E WHERE E.DIVISION_ID='40' AND NVL(E.COMPANY_ID,'-')='HQ00' AND E.SCM_SITE_ID=P.FROM_SITE)""")
    g = c.rowcount
    t = time.time(); c.execute(dele, bb(dele)); nd = c.rowcount; td = time.time() - t
    t = time.time(); c.execute(q, bb(q)); ni = c.rowcount; ti = time.time() - t
    c.execute(CHK); r = c.fetchone()
    print(name, 'GT', g, 'DELETE %d행 %.2fs' % (nd, td), 'INSERT %d행 %.2fs' % (ni, ti), r, flush=True)
    t = time.time(); cx.rollback(); print('  ROLLBACK %.2fs' % (time.time() - t), flush=True)
c.execute(CHK); print('끝 커밋본', c.fetchone(), flush=True)
c.execute("SELECT DBMS_TRANSACTION.LOCAL_TRANSACTION_ID FROM DUAL"); print('open txn', c.fetchone()[0])
