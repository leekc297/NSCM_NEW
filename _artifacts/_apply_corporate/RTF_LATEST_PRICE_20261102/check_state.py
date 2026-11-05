# -*- coding: utf-8 -*-
"""DB 원문 vs ASIS 백업 첫 차이 확인 (읽기 전용)."""
import sys, os
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
sys.stdout.reconfigure(encoding='utf-8')
import dbconn
from patch_def import PATCHES
HERE = os.path.dirname(os.path.abspath(__file__))
cx = dbconn.connect('tobe', dbconn.load_cfg()); c = cx.cursor()
c.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS'), sys_context('userenv','current_schema'), user from dual"); print(c.fetchone())
for n, t, _ in PATCHES:
    c.execute("select text from all_source where owner='SCM_MGR' and name=:n and type=:t order by line", n=n, t=t)
    db = [r[0] for r in c.fetchall()]
    a = open(os.path.join(HERE, f'{n}.ASIS.txt'), encoding='utf-8', newline='').read().splitlines(True)
    c.execute("select owner,status,to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects where object_name=:n and object_type=:t", n=n, t=t)
    print(n, c.fetchall(), 'lines db', len(db), 'asis', len(a))
    diffs = [i for i, (x, y) in enumerate(zip(db, a)) if x.rstrip() != y.rstrip()]
    print('  diff lines', len(diffs), diffs[:5])
    for i in diffs[:3]: print('   db  :', repr(db[i][:90])); print('   asis:', repr(a[i][:90]))
