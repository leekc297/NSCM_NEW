import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor()
c.execute("select owner, object_type from all_objects where object_name='SCM_DNM_STOCK_AGING_V_SN'"); print(c.fetchall())
c.execute("select table_owner, table_name from all_synonyms where synonym_name='SCM_DNM_STOCK_AGING_V_SN'"); print(c.fetchall())
c.execute("select owner, text from all_views where view_name='SCM_DNM_STOCK_AGING_V_SN'")
for o, t in c.fetchall(): print('== VIEW', o); print(t)
c.execute("""select i.owner, i.index_name, listagg(ic.column_name, ',') within group (order by ic.column_position)
 from all_indexes i join all_ind_columns ic on ic.index_owner=i.owner and ic.index_name=i.index_name
 where i.table_name='SCM_AGING_STOCK_H' group by i.owner, i.index_name""")
print(c.fetchall())
c.execute("select owner, num_rows, last_analyzed from all_tab_statistics where table_name='SCM_AGING_STOCK_H' and object_type='TABLE'"); print(c.fetchall())
