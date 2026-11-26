# 1-1 단계 MAX(CUTOFF_DATE) : 원문(함수) vs 스칼라 서브쿼리 vs JOIN(EXISTS). 결과, 소요(사내 ZIOUI1, 세션 DS 2), 3회 측정
import sys, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
BASE = """SELECT MAX(O.CUTOFF_DATE) /* OWMSMAX3_%(k)s_%(t)s */
  FROM SSP_DNM_OWMS_STOCK O
       JOIN SCM_MST_SITE B
    ON B.DIVISION_ID = :d
   AND NVL(B.COMPANY_ID, '-') = NVL(:c, '-')
   AND B.DIVISION_ID = O.DIVISION_ID
   AND B.PLANT_ID = O.PLANT_ID
 WHERE 1 = 1
   AND O.PROD_GROUP = :d
   AND %(p)s"""
P = {
 'FUNC': "FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL",
 'SCALAR': "(SELECT FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) FROM DUAL) IS NOT NULL",
 'JOIN': """EXISTS (SELECT 1
                 FROM SCM_MST_ITEM_SN S
                    , SCM_MST_SITE I
                WHERE S.DIVISION_ID     = O.PROD_GROUP
                  AND S.ITEM_ID         = O.ITEM_ID
                  AND I.PLANT_ID        = O.PLANT_ID
                  AND I.OPERATION_GROUP = S.SCP_OPERATION_GROUP
                  AND I.SITE_TYPE       = 'PLANT'
                  AND I.VALID_YN        = 'Y')""",
}
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 180000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
# 같은 키 다른 OPERATION_GROUP 48건이 OWMS(40) 데이터에 걸리는지
c.execute("""SELECT COUNT(DISTINCT O.PLANT_ID || '|' || O.ITEM_ID), COUNT(*)
  FROM SSP_DNM_OWMS_STOCK O
 WHERE O.PROD_GROUP = '40'
   AND (O.PROD_GROUP, O.ITEM_ID) IN (SELECT DIVISION_ID, ITEM_ID FROM SCM_MST_ITEM_SN
                                      GROUP BY DIVISION_ID, ITEM_ID HAVING COUNT(DISTINCT NVL(SCP_OPERATION_GROUP, '~')) > 1)""")
print('OWMS(40) 중 OP_GROUP 중복 키 품목 (쌍 수, 행 수)', c.fetchone(), flush=True)
tag = time.strftime('%H%M%S')
for rnd in (1, 2, 3):
    for co in ('HQ00', 'NJ00', 'AZ00'):
        r = {}
        for k, p in P.items():
            t = time.time(); c.execute(BASE % dict(k=k, t=tag, p=p), d='40', c=co); r[k] = (c.fetchone()[0], round(time.time() - t, 2))
        same = len(set(v[0] for v in r.values())) == 1
        print(rnd, co, r, 'SAME' if same else 'DIFF', flush=True)
c.execute("SELECT REGEXP_SUBSTR(SQL_TEXT, 'OWMSMAX3_[A-Z]+'), PLAN_HASH_VALUE, EXECUTIONS, ROUND(ELAPSED_TIME/1e6/EXECUTIONS, 3), ROUND(BUFFER_GETS/EXECUTIONS) "
          "FROM V$SQL WHERE SQL_TEXT LIKE '%OWMSMAX3%" + tag + "%' AND SQL_TEXT NOT LIKE '%V$SQL%' ORDER BY 1")
for x in c.fetchall(): print('V$SQL', x)
