import sys
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn
c=dbconn.connect('tobe',dbconn.load_cfg()).cursor()
c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE"); now=''.join(r[0] or '' for r in c.fetchall())
b=open(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_HINT_20261102\00_BACKUP_PKG_DMF0082_BODY.sql",encoding='utf-8',newline='\n').read()
print('CHECK 현재 원문 == 적용 전 백업:', now.rstrip()==b.rstrip(), '· 마커', now.count('E20261102-DMF0082HINT'), '· 줄 수', now.count('\n'))
