# -*- coding: utf-8 -*-
"""DMF0074 메타 배선 사내 적용 — 01_META/01_dmf0074_meta_wiring.sql 실행 (python-oracledb).
멱등 MERGE — 재실행 안전. 실행 후 검증 카운트 출력."""
import os, re, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
env = {}
for line in open(r'C:\Projects\NSCM\.env.asis', encoding='utf-8'):
    line = line.strip()
    if line and not line.startswith('#') and '=' in line:
        k, v = line.split('=', 1); env[k.strip()] = v.strip()
conn = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                        dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur = conn.cursor()

# 01_META/*.sql 전부 파일명 순서대로 실행 (01_meta_wiring → 02_upload_save)
meta_dir = os.path.join(HERE, '01_META')
files = sorted(f for f in os.listdir(meta_dir) if f.endswith('.sql'))
for fn in files:
    sql_text = open(os.path.join(meta_dir, fn), encoding='utf-8').read()
    # 주석 제거 후 ';' 단위 분리 (문자열 리터럴 내 세미콜론 없음 — 본 파일들 한정 안전)
    stmts = []
    clean = re.sub(r'^--.*$', '', sql_text, flags=re.M)
    for raw in clean.split(';'):
        s = raw.strip()
        if s and s.upper() != 'COMMIT':
            stmts.append(s)
    print(f'=== {fn} — {len(stmts)} statements ===')
    for i, s in enumerate(stmts, 1):
        head = ' '.join(s.split()[:4])
        try:
            cur.execute(s)
            print(f'  [{i}] OK ({cur.rowcount} rows) : {head}')
        except Exception as e:
            conn.rollback()
            print(f'  [{i}] FAIL : {head}\n      {e}')
            sys.exit(1)
    conn.commit()
    print(f'COMMIT OK ({fn})')

print('\n=== VERIFY ===')
ver = open(os.path.join(HERE, '04_VERIFY', 'verify_meta.sql'), encoding='utf-8').read()
vstmts = [v.strip() for v in re.sub(r'^--.*$', '', ver, flags=re.M).split(';') if v.strip()]
for v in vstmts:
    cur.execute(v)
    cols = [d[0] for d in cur.description]
    print(' | '.join(cols))
    for row in cur.fetchall():
        print(' | '.join(str(x) for x in row))
    print('-' * 40)
cur.close(); conn.close()
