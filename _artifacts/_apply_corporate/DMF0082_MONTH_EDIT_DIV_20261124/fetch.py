# 착수 원문 조회(ALL_SOURCE + LAST_DDL_TIME) — 기준본 저장
import sys,time,os
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
OUT='_artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124'
with connect('tobe') as cx:
    cx.call_timeout=60000
    cur=cx.cursor()
    for typ,fn in (('PACKAGE','PKG_DMF0082_spec.ASIS.sql'),('PACKAGE BODY','PKG_DMF0082_body.ASIS.sql')):
        t=time.time()
        cur.execute("select to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'),status from all_objects where owner='SCM_MGR' and object_name='PKG_DMF0082' and object_type=:t",t=typ)
        meta=cur.fetchone()
        cur.execute("select text from all_source where owner='SCM_MGR' and name='PKG_DMF0082' and type=:t order by line",t=typ)
        src=''.join(r[0] for r in cur.fetchall())
        open(os.path.join(OUT,fn),'w',encoding='utf-8',newline='').write(src)
        print(typ,meta,len(src.splitlines()),'lines',round(time.time()-t,1),'s')
    cur.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); print('fetched',cur.fetchone()[0])
