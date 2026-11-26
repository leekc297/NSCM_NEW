import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor(); c.callTimeout = 120000
c.execute("""select i.index_name, listagg(ic.column_name, ',') within group (order by ic.column_position)
 from all_indexes i join all_ind_columns ic on ic.index_owner=i.owner and ic.index_name=i.index_name
 where i.owner='FP_MGR' and i.table_name='FP_DAILY_PRODUCTIOIN_PLAN_H' group by i.index_name"""); print(c.fetchall())
c.execute("select num_rows, last_analyzed from all_tab_statistics where owner='FP_MGR' and table_name='FP_DAILY_PRODUCTIOIN_PLAN_H' and object_type='TABLE'"); print(c.fetchall())
c.execute("""SELECT SLV.SEGMENT1, SLP.SEGMENT1 AS PLANT_ID, SLV.ATTRIBUTE1 FROM FP_MGR.SCM_SYS_LOOKUP_VALUE SLV, FP_MGR.SCM_SYS_LOOKUP_VALUE SLP, FP_MGR.SCM_PLANT_M PM
 WHERE SLP.SEGMENT2 = SLV.SEGMENT2 AND PM.SITE_ID = SLV.SEGMENT1 AND PM.PLANT_ID = SLP.SEGMENT1 AND SLV.LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG' AND SLV.ACTIVE_FLAG = 'Y'
   AND SLP.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT' AND SLP.ACTIVE_FLAG = 'Y'"""); print(c.fetchall())
c.execute("select column_name, data_type from all_tab_columns where owner='FP_MGR' and table_name='FP_DAILY_PRODUCTIOIN_PLAN_H' order by column_id"); print(c.fetchall())
