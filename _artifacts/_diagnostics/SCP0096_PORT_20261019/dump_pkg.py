# -*- coding: utf-8 -*-
"""사내오라클(ZIOUI1) PKG_SCP0096 현행 원문 덤프 — hook #152 (DB 새로고침 원문 기준)"""
import sys, os, datetime
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', '..', 'tools', 'DbConn'))
from dbconn import connect
OUT = os.path.dirname(os.path.abspath(__file__))
name = sys.argv[1] if len(sys.argv) > 1 else 'PKG_SCP0096'
with connect('tobe') as cx:
    cur = cx.cursor()
    cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n ORDER BY 1", {'n': name})
    meta = cur.fetchall()
    print(meta)
    for t in ('PACKAGE', 'PACKAGE BODY'):
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", {'n': name, 't': t})
        txt = ''.join(r[0] for r in cur.fetchall())
        fn = os.path.join(OUT, 'DB_%s_%s.sql' % (name, t.replace(' ', '_')))
        with open(fn, 'w', encoding='utf-8') as f:
            f.write('-- SOURCE-FRESH: SCM_MGR.%s %s FETCHED=%s FROM ZIOUI1 LAST_DDL=%s\n' % (name, t, datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), [m[2] for m in meta if m[0] == t]))
            f.write(txt)
        print(fn, len(txt.splitlines()), 'lines')
