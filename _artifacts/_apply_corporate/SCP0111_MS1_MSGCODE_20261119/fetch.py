import sys, os
sys.path.insert(0, 'tools/DbConn')
from dbconn import connect
D = '_artifacts/_apply_corporate/SCP0111_MS1_MSGCODE_20261119'
with connect('tobe') as cx:
    cur = cx.cursor()
    cur.execute("select object_type, status, to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects where owner='SCM_MGR' and object_name='PKG_SCP0111'")
    print(cur.fetchall())
    cur.execute("select text from all_source where owner='SCM_MGR' and name='PKG_SCP0111' and type='PACKAGE BODY' order by line")
    body = ''.join(t for (t,) in cur.fetchall())
    open(f'{D}/PKG_SCP0111_BODY.ASIS.sql', 'w', encoding='utf-8', newline='').write(body)
    print('lines', body.count('\n'))
    try:
        cur.execute("select count(*) from v$session s join all_objects o on o.object_id=s.plsql_entry_object_id where o.object_name='PKG_SCP0111'")
        print('running sessions', cur.fetchone())
    except Exception as e:
        print('v$session 조회 불가', str(e)[:80])
