#!/usr/bin/env python3
"""SYS0001_API_TYPE_ADD/010_ADD_API_TO_MSG_TP_CD.sql 사내 적용."""
import re, pathlib, oracledb, sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
BE = ROOT / 'nscm-be' / 'src' / 'main' / 'resources' / 'config' / 'config-local.yml'
SQL = ROOT / '_artifacts' / '_deploy_packages' / 'SYS0001_API_TYPE_ADD' / '010_ADD_API_TO_MSG_TP_CD.sql'

def creds():
    t = BE.read_text(encoding='utf-8')
    url = next(re.match(r'jdbc-url:\s*(\S+)', l.strip()).group(1) for l in t.splitlines() if not l.strip().startswith('#') and 'jdbc-url:' in l)
    u = next(re.match(r'username:\s*"?([^"]+)"?', l.strip()).group(1) for l in t.splitlines() if not l.strip().startswith('#') and 'username:' in l).strip()
    p = next(re.match(r'password:\s*"([^"]+)"', l.strip()).group(1) for l in t.splitlines() if not l.strip().startswith('#') and 'password:' in l)
    m = re.search(r'@([^/]+)/(\S+)', url)
    return u, p, f'{m.group(1)}/{m.group(2)}'

def split_statements(text):
    out, buf = [], []
    for raw in text.splitlines():
        line = raw.rstrip()
        s = line.strip()
        if not s: continue
        up = s.upper()
        if up.startswith(('PROMPT', 'SET ', '--')) or up == 'SET DEFINE OFF': continue
        if s.endswith(';'):
            buf.append(line.rstrip(';'))
            out.append('\n'.join(buf).strip()); buf = []; continue
        buf.append(line)
    if buf and any(l.strip() for l in buf): out.append('\n'.join(buf).strip())
    return out

u, p, d = creds()
print(f'접속: {u} @ {d}')
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
stmts = split_statements(SQL.read_text(encoding='utf-8').replace('\r', ''))
for i, s in enumerate(stmts, 1):
    head = s.split('\n')[0][:80]
    cur.execute(s)
    if cur.description:
        rows = cur.fetchall()
        cols = [c[0] for c in cur.description]
        print(f'[{i}/{len(stmts)}] {head[:60]}...')
        print('     ', ' | '.join(cols))
        for r in rows[:20]:
            print('     ', ' | '.join(str('' if v is None else v) for v in r))
    else:
        print(f'[{i}/{len(stmts)}] OK ({cur.rowcount} row) — {head[:60]}')
con.commit()
con.close()
print('\n✅ 적용 완료')
