# -*- coding: utf-8 -*-
import oracledb
env={}
for line in open(r'C:\Projects\NSCM\.env.asis',encoding='utf-8'):
    line=line.strip()
    if line and not line.startswith('#') and '=' in line:
        k,v=line.split('=',1); env[k.strip()]=v.strip()
conn=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],
                      dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur=conn.cursor()
def show(tag):
    cur.execute("SELECT SEGMENT1,SEGMENT2,ATTRIBUTE1,VALID_YN FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='DM_UI_EDITABLE_DIVISION' AND SEGMENT1='DMF0082'")
    rows=cur.fetchall(); print(tag,'DMF0082 rows:',rows)
show('[사전]')
cur.execute("""INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
(LOOKUP_TYPE,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,DISPLAY_SEQ,VALID_YN,DESCRIPTION,ATTRIBUTE1,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
SELECT 'DM_UI_EDITABLE_DIVISION','DMF0082','82','-','-','-',0,'Y','Fcst&Price MGMT','N','minyonglee1',SYSDATE,'minyonglee1',SYSDATE FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='DM_UI_EDITABLE_DIVISION' AND SEGMENT1='DMF0082' AND SEGMENT2='82')""")
print('inserted rows:',cur.rowcount)
conn.commit()
show('[적용후]')
cur.close(); conn.close()
