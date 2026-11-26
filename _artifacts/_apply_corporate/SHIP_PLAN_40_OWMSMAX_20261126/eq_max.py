# 1-1 단계 MAX(CUTOFF_DATE) 원문 vs 변경 : 결과 대조, 소요(사내 ZIOUI1, 세션 DS 2 = SP 와 같음)
import sys, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
OLD = """SELECT MAX(CUTOFF_DATE) /* OWMSMAX_OLD_%(t)s */
  FROM SSP_DNM_OWMS_STOCK O
       JOIN SCM_MST_SITE B
    ON B.DIVISION_ID = :d
   AND NVL(B.COMPANY_ID, '-') = NVL(:c, '-')
   AND B.DIVISION_ID = O.DIVISION_ID
   AND B.PLANT_ID = O.PLANT_ID
 WHERE 1 = 1
   AND O.PROD_GROUP = :d
   AND FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL"""
NEW = """SELECT MAX(O.CUTOFF_DATE) /* OWMSMAX_NEW_%(t)s */
  FROM SSP_DNM_OWMS_STOCK O
       JOIN SCM_MST_SITE B
    ON B.DIVISION_ID = :d
   AND NVL(B.COMPANY_ID, '-') = NVL(:c, '-')
   AND B.DIVISION_ID = O.DIVISION_ID
   AND B.PLANT_ID = O.PLANT_ID
       JOIN ( SELECT /*+ NO_MERGE */ P.PLANT_ID
                   , P.ITEM_ID
                FROM ( SELECT DISTINCT X.PLANT_ID
                            , X.ITEM_ID
                         FROM SSP_DNM_OWMS_STOCK X
                        WHERE X.PROD_GROUP = :d
                     ) P
               WHERE FN_GET_SCM_SITE_ID_PLANT(P.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(:d, P.ITEM_ID)) IS NOT NULL
            ) F
    ON F.PLANT_ID = O.PLANT_ID
   AND F.ITEM_ID  = O.ITEM_ID
 WHERE 1 = 1
   AND O.PROD_GROUP = :d"""
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 300000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
tag = time.strftime('%H%M%S')
for d, co in [('40', 'HQ00'), ('40', 'NJ00'), ('40', 'AZ00'), ('40', None), ('10', None), ('20', None)]:
    r = {}
    for k, s in [('OLD', OLD), ('NEW', NEW)]:
        t = time.time(); c.execute(s % dict(t=tag), d=d, c=co); r[k] = (c.fetchone()[0], round(time.time() - t, 2))
    print(d, co, r, 'SAME' if r['OLD'][0] == r['NEW'][0] else 'DIFF')
c.execute("select substr(sql_text,1,40), executions, round(elapsed_time/1e6,2), buffer_gets, plan_hash_value from v$sql where sql_text like '%%OWMSMAX_%%_" + tag + "%%' and sql_text not like '%%v$sql%%'")
for x in c.fetchall(): print(x)
