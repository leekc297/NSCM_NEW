# -*- coding: utf-8 -*-
"""적용 후: ZIOUI1 ALL_SOURCE(PKG_SCP0096 spec/body) == Doc/gen/SCP0096/SCP0096_PKG.sql 인지 대조 (hook #152 §3.3 적용 후 확인)
FRESH-GATE: 이 스크립트 자체가 DDL 을 실행하지 않는다 — 적용(run_sql.py) 직전 ALL_OBJECTS.LAST_DDL_TIME 재조회(2026-10-09 13:38:44 동일) 로 FRESH-GATE 통과 후 적용했고,
            여기서는 적용본 == DB 원문(ALL_SOURCE) 을 assert 한다."""
import os, sys, re, difflib
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..', 'tools', 'DbConn'))
from dbconn import connect
HERE = os.path.dirname(os.path.abspath(__file__))
f = open(os.path.join(HERE, '..', '..', '..', 'Doc', 'gen', 'SCP0096', 'SCP0096_PKG.sql'), encoding='utf-8').read()
# 파일에서 spec / body 추출 (CREATE OR REPLACE ... ~ 줄단독 '/')
parts = re.findall(r'CREATE OR REPLACE PACKAGE( BODY)? SCM_MGR\.PKG_SCP0096\n([\s\S]*?)\n/\n', f)
file_src = {('PACKAGE BODY' if p[0] else 'PACKAGE'): ('PACKAGE BODY PKG_SCP0096\n' if p[0] else 'PACKAGE PKG_SCP0096\n') + p[1] + '\n' for p in parts}
ok = True
with connect('tobe') as cx:
    cur = cx.cursor()
    for t in ('PACKAGE', 'PACKAGE BODY'):
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0096' AND TYPE=:t ORDER BY LINE", {'t': t})
        db = ''.join(r[0] for r in cur.fetchall())
        a = db.replace('\r\n', '\n').rstrip() + '\n'; b = file_src[t].replace('\r\n', '\n').rstrip() + '\n'
        same = a == b; ok &= same
        print(f'{t:13s} db={len(a):6d}B file={len(b):6d}B {"SAME" if same else "DIFF"}')
        if not same:
            for l in list(difflib.unified_diff(a.splitlines(), b.splitlines(), 'db', 'file', lineterm='', n=1))[:40]: print(l)
    cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0096' ORDER BY 1")
    print(cur.fetchall())
print('RESULT', 'PASS' if ok else 'FAIL')
