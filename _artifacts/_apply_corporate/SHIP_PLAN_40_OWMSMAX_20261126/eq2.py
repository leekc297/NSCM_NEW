# 1-1 단계 MAX(CUTOFF_DATE) : 원문 vs 스칼라 서브쿼리 캐시판. 결과 대조, 소요, 함수 호출 수(사내 ZIOUI1, 세션 DS 2)
import sys, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
BASE = """SELECT MAX(CUTOFF_DATE) /* OWMSMAX_%(k)s_%(t)s */
  FROM SSP_DNM_OWMS_STOCK O
       JOIN SCM_MST_SITE B
    ON B.DIVISION_ID = :d
   AND NVL(B.COMPANY_ID, '-') = NVL(:c, '-')
   AND B.DIVISION_ID = O.DIVISION_ID
   AND B.PLANT_ID = O.PLANT_ID
 WHERE 1 = 1
   AND O.PROD_GROUP = :d
   AND %(p)s"""
OLDP = "FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL"
NEWP = "(SELECT FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) FROM DUAL) IS NOT NULL"
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 120000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
c.execute("select count(*) from (select division_id, item_id from scm_mst_item_sn group by division_id, item_id having count(distinct nvl(scp_operation_group,'~')) > 1)")
print('ITEM_SN 같은 키 다른 OP_GROUP', c.fetchone()[0], flush=True)
tag = time.strftime('%H%M%S')
for d, co in [('40', 'HQ00'), ('40', 'NJ00'), ('40', 'AZ00'), ('40', None), ('10', None), ('20', None)]:
    r = {}
    for k, p in [('OLD', OLDP), ('NEW', NEWP)]:
        t = time.time(); c.execute(BASE % dict(k=k, t=tag, p=p), d=d, c=co); r[k] = (c.fetchone()[0], round(time.time() - t, 2))
    print(d, co, r, 'SAME' if r['OLD'][0] == r['NEW'][0] else 'DIFF', flush=True)
c.execute("select substr(sql_text,1,36), executions, round(elapsed_time/1e6,2), buffer_gets, plan_hash_value from v$sql where sql_text like '%OWMSMAX\_%' escape '\' and sql_text like '%" + tag + "%' and sql_text not like '%v$sql%'")
for x in c.fetchall(): print(x)
