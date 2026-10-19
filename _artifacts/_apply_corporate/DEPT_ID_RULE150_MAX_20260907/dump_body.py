# -*- coding: utf-8 -*-
"""대상 객체 USER_SOURCE 원문 덤프 (CREATE OR REPLACE 헤더 부착) — 원복본 겸 편집 입력"""
import os, sys, oracledb, pathlib
root = pathlib.Path(__file__).resolve().parents[3]
env = {}
for ln in open(root/'.env.asis', encoding='utf-8'):
    ln = ln.strip()
    if '=' in ln and not ln.startswith('#'):
        k, v = ln.split('=', 1); env[k] = v
c = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                     dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur = c.cursor()
name = sys.argv[1]; out = pathlib.Path(sys.argv[2])
cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE='PACKAGE BODY' ORDER BY LINE", [name])
body = ''.join(r[0] for r in cur)
out.write_text("CREATE OR REPLACE \n" + body.rstrip('\n') + "\n/\n", encoding='utf-8')
print(f"{name} -> {out} ({body.count(chr(10))+1} lines)")
c.close()
