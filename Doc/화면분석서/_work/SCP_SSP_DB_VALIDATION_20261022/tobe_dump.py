# -*- coding: utf-8 -*-
"""사내 ZIOUI1 SCM_MGR 의 SCP/SSP 관련 PL/SQL 원문 당일 재조회 (SELECT 전용)
대상: PKG_SCP% / PKG_SSP% (PACKAGE, PACKAGE BODY) + 그 PKG 가 참조하는 SCM_MGR 의 PROCEDURE/FUNCTION/PACKAGE (ALL_DEPENDENCIES 1단계 이상 BFS)
출력: tobe/src/<NAME>.<TYPE>.sql , tobe/objects.csv , tobe/deps.csv
"""
import os, sys, csv, datetime
sys.path.insert(0, r'C:/Projects/NSCM/_artifacts/_diagnostics')
import ora
import oracledb

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tobe')
os.makedirs(os.path.join(OUT, 'src'), exist_ok=True)
u, p, d = ora.conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME'), SYS_CONTEXT('USERENV','CON_NAME'), USER, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
env = cur.fetchone()
print('connected', env, 'dsn', d)

OWNER = 'SCM_MGR'
cur.execute("""SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                 FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')""", o=OWNER)
allobj = {}
for n, t, s, l in cur.fetchall():
    allobj.setdefault(n, {})[t] = (s, l)

seed = {n for n in allobj if n.startswith('PKG_SCP') or n.startswith('PKG_SSP')}
cur.execute("""SELECT NAME, REFERENCED_NAME FROM ALL_DEPENDENCIES
                WHERE OWNER=:o AND REFERENCED_OWNER=:o AND TYPE IN ('PACKAGE BODY','PROCEDURE','FUNCTION','PACKAGE')
                  AND REFERENCED_TYPE IN ('PACKAGE','PROCEDURE','FUNCTION')""", o=OWNER)
deps = {}
for n, r in cur.fetchall():
    deps.setdefault(n, set()).add(r)
todo, seen = list(seed), set()
while todo:
    n = todo.pop()
    if n in seen:
        continue
    seen.add(n)
    for r in deps.get(n, ()):
        if r in allobj and r not in seen and not r.startswith('DBMS_'):
            todo.append(r)

rows = []
for n in sorted(seen):
    for t, (s, l) in sorted(allobj[n].items()):
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=n, t=t)
        txt = ''.join(r[0] or '' for r in cur.fetchall())
        fn = f"{n}.{t.replace(' ', '_')}.sql"
        with open(os.path.join(OUT, 'src', fn), 'w', encoding='utf-8', newline='') as f:
            f.write(txt)
        rows.append([n, t, s, l, txt.count('\n') + 1, fn, 'seed' if n in seed else 'dep'])
with open(os.path.join(OUT, 'objects.csv'), 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.writer(f); w.writerow(['name', 'type', 'status', 'last_ddl', 'lines', 'file', 'origin']); w.writerows(rows)
with open(os.path.join(OUT, 'deps.csv'), 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.writer(f); w.writerow(['name', 'referenced'])
    for n in sorted(seen):
        for r in sorted(deps.get(n, ())):
            w.writerow([n, r])
with open(os.path.join(OUT, '_env.txt'), 'w', encoding='utf-8') as f:
    f.write(f"server_host={env[0]} db_name={env[1]} con={env[2]} user={env[3]} sysdate={env[4]} dsn_host={d.split(':')[0]}\n")
print('seed pkgs', len(seed), 'closure objects', len(seen), 'files', len(rows), 'lines', sum(r[4] for r in rows))
