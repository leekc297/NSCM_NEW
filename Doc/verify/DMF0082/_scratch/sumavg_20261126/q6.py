import sys,re,json
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn
cx=dbconn.connect('tobe'); cx.call_timeout=60000; cur=cx.cursor()
cur.execute("SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=7214000")
p=cur.fetchone()[0].read()
p=re.sub(r'"@procInfo":\[.*?\],','',p,flags=re.S)
print(p[:1500])
