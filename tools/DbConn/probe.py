# -*- coding: utf-8 -*-
"""
probe — 등록된 모든 DB 접속을 시험하고 리포트(Doc\db\probe_<날짜>.md)를 남긴다. 비밀번호는 기록하지 않는다.
  python probe.py            전체
  python probe.py tobe       하나만
종료코드: 0 전부 성공 / 1 실패 있음
"""
import sys as _sys
try: _sys.stdout.reconfigure(encoding='utf-8', errors='replace'); _sys.stderr.reconfigure(encoding='utf-8', errors='replace')
except Exception: pass
import sys, os, time, datetime, platform
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbconn

cfg = dbconn.load_cfg()
names = sys.argv[1:] or list(cfg['connections'])
rows, fail = [], 0
for n in names:
    t0 = time.time()
    try:
        desc = dbconn.describe(n, cfg)
    except Exception as e:
        rows.append((n, '설정 오류', dbconn.mask(str(e), cfg), '-')); fail += 1; continue
    try:
        cx = dbconn.connect(n, cfg)
        cur = cx.cursor()
        typ = cfg['connections'][n]['type']
        if typ == 'oracle':
            cur.execute("SELECT SYS_CONTEXT('USERENV','DB_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','CURRENT_SCHEMA'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
            db, host, schema, now = cur.fetchone()
            cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_TYPE IN ('PACKAGE','PROCEDURE')")
            objs = cur.fetchone()[0]
            cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M WHERE USE_YN='Y'")
            menus = cur.fetchone()[0]
            info = f"DB={db} host={host} schema={schema} now={now} · PKG/PROC {objs} · 사용 메뉴 {menus}"
        else:
            cur.execute("SELECT DB_NAME(), @@SERVERNAME, CONVERT(varchar(19), GETDATE(), 120), (SELECT COUNT(*) FROM sys.procedures)")
            db, host, now, procs = cur.fetchone()
            info = f"DB={db} server={host} now={now} · SP {procs}"
        cx.close()
        rows.append((n, 'OK', f"{desc} — {info}", f"{time.time()-t0:.1f}s"))
    except Exception as e:
        rows.append((n, 'FAIL', f"{desc} — {dbconn.mask(str(e), cfg).splitlines()[0][:300]}", f"{time.time()-t0:.1f}s")); fail += 1

stamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
out = os.path.join(cfg['outDir'], f'probe_{stamp}.md')
os.makedirs(cfg['outDir'], exist_ok=True)
md = [f"# DB 접속 점검 {stamp}", '', f"- 실행 PC: {platform.node()} / Python {platform.python_version()}", f"- 설정: dbconn.json → {cfg['envFile']} (비밀번호 미기록)", '', '| 접속 | 결과 | 내용 | 소요 |', '|---|---|---|---|']
for r in rows:
    md.append(f"| {r[0]} | {r[1]} | {r[2].replace('|','/')} | {r[3]} |")
open(out, 'w', encoding='utf-8').write('\n'.join(md) + '\n')
for r in rows:
    print(f"[{r[1]}] {r[0]}: {r[2]} ({r[3]})")
print(f"리포트: {out}")
sys.exit(1 if fail else 0)
