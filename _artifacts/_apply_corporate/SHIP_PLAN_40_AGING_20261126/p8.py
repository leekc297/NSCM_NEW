# 2-3 : INSERT 형식 EXPLAIN 으로 힌트 반영 확인 → 원문 vs INDEX_SS 결과, 소요(사내)
import sys, io, re, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
src = io.open('PR_SSP_ANL_SHIP_PLAN_40.W.TOBE.sql', encoding='utf-8').read()
i = src.index('INSERT INTO GT_SSP_FORMATION_POST_CELL'); k = src.index('\n        ;', i)
ins = re.sub(r'\bV_(DIVISION_ID|COMPANY_ID)\b', r':V_\1', src[i:k])
HINT = 'INDEX_SS(@SEL$3 DPP IX01_FP_DAILY_PRODUCTIOIN_PLAN_H)'
ins_h = ins.replace('SELECT  P.DIVISION_ID', 'SELECT  /*+ %s */ P.DIVISION_ID' % HINT, 1)
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 900000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2"); c.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE")
c.execute("DELETE FROM PLAN_TABLE WHERE STATEMENT_ID = 'P23INS'")
c.execute("EXPLAIN PLAN SET STATEMENT_ID = 'P23INS' FOR " + ins_h.replace(':V_DIVISION_ID', "'40'").replace(':V_COMPANY_ID', "'HQ00'"))
c.execute("SELECT OPERATION || ' ' || OPTIONS, COST FROM PLAN_TABLE WHERE STATEMENT_ID='P23INS' AND OBJECT_NAME='IX01_FP_DAILY_PRODUCTIOIN_PLAN_H' AND PLAN_ID=(SELECT MAX(PLAN_ID) FROM PLAN_TABLE WHERE STATEMENT_ID='P23INS')")
print('INSERT EXPLAIN', c.fetchall(), flush=True)
cx.rollback()
chk = "SELECT COUNT(*), SUM(QTY), SUM(ORA_HASH(ITEM_ID||'|'||FROM_SITE||'|'||YYYYMMDD||'|'||QTY)) FROM GT_SSP_FORMATION_POST_CELL"
for co in ('NJ00', 'AZ00', 'HQ00'):
    for nm, q in (('NEW', ins_h), ('OLD', ins)):
        c.execute('DELETE FROM GT_SSP_FORMATION_POST_CELL')
        t = time.time(); c.execute(q, V_DIVISION_ID='40', V_COMPANY_ID=co); el = time.time() - t
        c.execute(chk); print(co, nm, '%.2fs' % el, c.fetchone(), flush=True)
        cx.rollback()
