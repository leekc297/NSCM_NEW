import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor()
c.execute("select owner, object_name, object_type from all_objects where object_name in ('SCM_MST_ITEM_SN') order by 1")
print(c.fetchall())
c.execute("select num_rows, blocks, last_analyzed from all_tab_statistics where owner='SCM_MGR' and table_name='SCM_MST_ITEM_SN' and object_type='TABLE'"); print(c.fetchall())
c.execute("""select q.sql_id, o.object_name, q.executions, round(q.elapsed_time/1e6,2), round(q.buffer_gets/nullif(q.executions,0),1), q.plan_hash_value, substr(q.sql_text,1,90)
 from v$sql q join all_objects o on o.object_id=q.program_id
 where o.owner='SCM_MGR' and o.object_name in ('FN_GET_ITEM_OPERATION_GROUP','FN_GET_SCM_SITE_ID_PLANT')""")
for r in c.fetchall(): print(r)
c.execute("select name, value from v$result_cache_statistics where name in ('Block Size (Bytes)','Block Count Maximum','Block Count Current','Create Count Success','Find Count','Delete Count Valid','Delete Count Invalid')"); print(c.fetchall())
