import sys, os, time
sys.stdout.reconfigure(encoding='utf-8')
ROOT = os.getcwd(); D = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect
with connect('tobe') as cx:
    cx.call_timeout = 60000
    cur = cx.cursor()
    def q(n, s, **b):
        t = time.time(); cur.execute(s, b); r = cur.fetchall(); print('##', n, f'{time.time()-t:.2f}s'); [print(x) for x in r]; return r
    q('who', "select sys_context('userenv','current_user'), sys_context('userenv','db_name'), to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual")
    q('objs', "select object_name, object_type, status, to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects where owner='SCM_MGR' and object_name in ('PKG_SYS0016','PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST','SCM_ADM_NOTICE_CONTENT_MASTER','SCM_ADM_NOTICE_CONTENT_MASTER_H') order by 1,2")
    q('comments', "select table_name, column_name, comments from all_col_comments where owner='SCM_MGR' and table_name in ('SCM_ADM_NOTICE_CONTENT_MASTER','SCM_ADM_NOTICE_CONTENT_MASTER_H') and column_name='NOTICE_CONTENT'")
    q('cons', "select table_name, constraint_name, constraint_type, search_condition_vc from all_constraints where owner='SCM_MGR' and table_name in ('SCM_ADM_NOTICE_CONTENT_MASTER','SCM_ADM_NOTICE_CONTENT_MASTER_H')")
    q('grants', "select table_name, grantee, privilege from all_tab_privs where table_schema='SCM_MGR' and table_name in ('SCM_ADM_NOTICE_CONTENT_MASTER','SCM_ADM_NOTICE_CONTENT_MASTER_H','PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST','PKG_SYS0016')")
    q('rows', "select 'M', count(*), sum(nvl(lengthb(notice_content),0)) from SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER union all select 'H', count(*), sum(nvl(lengthb(notice_content),0)) from SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER_H")
    q('param', "select name, value from v$parameter where name in ('db_securefile','max_string_size','compatible')")
    q('ts', "select tablespace_name, segment_space_management from dba_tablespaces where tablespace_name='TS_SCM_D01'")
    for typ, name, fn in [('TABLE','SCM_ADM_NOTICE_CONTENT_MASTER','TBL_M.ASIS.sql'),('TABLE','SCM_ADM_NOTICE_CONTENT_MASTER_H','TBL_H.ASIS.sql'),('PROCEDURE','PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST','PR_HIST.ASIS.sql'),('PACKAGE_BODY','PKG_SYS0016','PKG_SYS0016_body.ASIS.sql'),('PACKAGE_SPEC','PKG_SYS0016','PKG_SYS0016_spec.ASIS.sql')]:
        try:
            cur.execute("select dbms_metadata.get_ddl(:t,:n,'SCM_MGR') from dual", t=typ, n=name)
            open(os.path.join(D, fn), 'w', encoding='utf-8', newline='\n').write(cur.fetchone()[0].read())
            print('saved', fn)
        except Exception as e: print('ERR', fn, str(e)[:200])
