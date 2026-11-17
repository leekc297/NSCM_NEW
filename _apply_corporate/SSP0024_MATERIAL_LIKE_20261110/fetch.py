import sys, os, datetime
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
sys.stdout.reconfigure(encoding='utf-8')
out = os.path.dirname(os.path.abspath(__file__))
con = dbconn.connect('tobe'); cur = con.cursor()
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('NOW', cur.fetchone()[0])
cur.execute("SELECT OBJECT_NAME,OBJECT_TYPE,STATUS,TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME LIKE '%SSP0024%'")
for r in cur: print(r)
for t in ('PACKAGE','PACKAGE BODY'):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SSP0024' AND TYPE=:t ORDER BY LINE", t=t)
    txt=''.join(r[0] for r in cur)
    fn = os.path.join(out, 'PKG_SSP0024.%s.ASIS.txt' % t.replace(' ','_'))
    open(fn,'w',encoding='utf-8',newline='').write(txt); print(fn, len(txt))
