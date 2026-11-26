# awr2c30u4h31c SELECT 원문 vs 변경안 : 결과(행 단위 다중집합) 대조, 소요, 블록. SYSDATE 대신 :sd (사내 데이터 마지막 CUTOFF 11-21)
import sys, time, collections
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
COLS = "A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.LOT_ID, A.QTY, A.WIPHOLD_YN, A.SPECIAL_YN, A.UNHOLD_EXP_DATE"
B = """JOIN ( SELECT C.DIVISION_ID, C.SITE_ID , MAX(C.CUTOFF_DATE) AS CUTOFF_DATE
                FROM SCM_DNM_STOCK_AGING_V C
               WHERE C.CUTOFF_DATE >  :sd - 5
                 AND C.DIVISION_ID = :d
               GROUP BY C.DIVISION_ID, C.SITE_ID ) B
    ON A.DIVISION_ID = B.DIVISION_ID
   AND A.SITE_ID     = B.SITE_ID
   AND A.CUTOFF_DATE = B.CUTOFF_DATE"""
Q = {
 'OLD': "SELECT /* AGT_OLD_%(t)s */ " + COLS + "\n  FROM SCM_DNM_STOCK_AGING_V A\n       " + B,
 'V1': "SELECT /* AGT_V1_%(t)s */ " + COLS + "\n  FROM SCM_DNM_STOCK_AGING_V A\n       " + B +
       "\n WHERE A.DIVISION_ID     = :d\n   AND A.ORG_CUTOFF_DATE > :sd - 4",
 'V2': """SELECT /* AGT_V2_%(t)s */ A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.LOT_ID, A.QTY, A.WIPHOLD_YN, A.SPECIAL_YN, A.UNHOLD_EXP_DATE
  FROM ( SELECT V.DIVISION_ID, V.SCM_SITE_ID, V.ITEM_ID, V.LOT_ID, V.QTY, V.WIPHOLD_YN, V.SPECIAL_YN, V.UNHOLD_EXP_DATE, V.CUTOFF_DATE
              , MAX(V.CUTOFF_DATE) OVER (PARTITION BY V.DIVISION_ID, V.SITE_ID) AS MAX_CUTOFF_DATE
           FROM SCM_DNM_STOCK_AGING_V V
          WHERE V.CUTOFF_DATE > :sd - 5
            AND V.DIVISION_ID = :d
            AND V.SITE_ID IS NOT NULL ) A
 WHERE A.CUTOFF_DATE = A.MAX_CUTOFF_DATE""",
}
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 300000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
tag = time.strftime('%H%M%S')
import datetime
for sd in [datetime.datetime(2026, 11, 21, 14, 0), datetime.datetime(2026, 11, 19, 9, 0)]:
    res = {}
    for rnd in (1, 2):
        for k, q in Q.items():
            t = time.time(); c.execute(q % dict(t=tag), d='40', sd=sd); rows = c.fetchall(); el = time.time() - t
            res[k] = collections.Counter(rows)
            print(sd, rnd, k, '%.2fs' % el, 'rows', len(rows), 'qty', round(sum(r[4] or 0 for r in rows), 3), flush=True)
    print('  V1 == OLD', res['V1'] == res['OLD'], '| V2 == OLD', res['V2'] == res['OLD'], flush=True)
c.execute("SELECT REGEXP_SUBSTR(SQL_TEXT, 'AGT_[A-Z0-9]+'), PLAN_HASH_VALUE, EXECUTIONS, ROUND(ELAPSED_TIME/1e6/EXECUTIONS, 2), ROUND(BUFFER_GETS/EXECUTIONS), ROUND(DISK_READS/EXECUTIONS) "
          "FROM V$SQL WHERE SQL_TEXT LIKE '%AGT_%" + tag + "%' AND SQL_TEXT NOT LIKE '%V$SQL%' ORDER BY 1")
for x in c.fetchall(): print('V$SQL', x)
