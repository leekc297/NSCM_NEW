# -*- coding: utf-8 -*-
"""패키지 SQL 파일을 사내 ZIOUI1 에서 파일 그대로 실행 (SQL*Plus 형식 : SET 줄 무시, PL/SQL 블록은 '/' 줄까지)"""
import sys, io, re
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
def stmts(path):
    t = io.open(path, encoding='utf-8').read().replace('\r\n', '\n')
    out, buf, plsql = [], [], False
    for ln in t.split('\n'):
        s = ln.strip()
        if s.upper().startswith('SET ') and not plsql:
            continue
        if not buf and (not s or s.startswith('--')):
            continue
        if not buf and re.match(r'^(DECLARE|BEGIN)\b', s, re.I):
            plsql = True
        if plsql:
            if s == '/':
                out.append('\n'.join(buf)); buf = []; plsql = False
            else:
                buf.append(ln)
            continue
        buf.append(ln)
        if s.endswith(';') and not s.startswith('/*'):
            x = '\n'.join(buf).strip()
            x = re.sub(r'^(\s*/\*.*?\*/\s*)+', '', x, flags=re.S).rstrip(';')
            if x.strip():
                out.append(x)
            buf = []
    return out
cx = dbconn.connect('tobe'); c = cx.cursor()
c.callproc('DBMS_OUTPUT.ENABLE', [None])
for f in sys.argv[1:]:
    print('#####', f.split('/')[-1])
    for s in stmts(f):
        head = re.sub(r'\s+', ' ', re.sub(r'/\*.*?\*/', '', s, flags=re.S)).strip()[:70]
        try:
            c.execute(s)
            if c.description:
                for r in c.fetchall(): print('   ', r)
            else:
                print('  OK', head)
        except Exception as e:
            print('  ERR', head, '|', str(e).split('\n')[0])
        lv = c.var(str); st = c.var(int)
        while True:
            c.callproc('DBMS_OUTPUT.GET_LINE', (lv, st))
            if st.getvalue() != 0: break
            print('   OUT', lv.getvalue())
    cx.commit()
