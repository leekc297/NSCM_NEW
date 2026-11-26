# -*- coding: utf-8 -*-
"""추가 검증 쿼리 ZIOUI1 실행 시험(읽기 전용) — 오류 · 소요 시간 · 행 수"""
import sys, time, os
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dbconn
from vq_new import VQ
con = dbconn.connect('tobe'); cur = con.cursor()
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('시작', cur.fetchone()[0])
ok = 0; ng = 0
only = sys.argv[1:]
for i, cat, what, tabs, point, sql, binds in VQ:
    if only and i not in only: continue
    t0 = time.time()
    try:
        cur.execute(sql, binds); cols = [d[0] for d in cur.description]; rows = cur.fetchmany(2000)
        ok += 1; print(f'{i} OK {time.time() - t0:5.1f}s rows={len(rows)} cols={len(cols)} | {what}')
        for r in rows[:3]: print('     ', ' | '.join('' if v is None else str(v)[:28] for v in r))
    except Exception as e:
        ng += 1; print(f'{i} ERR {time.time() - t0:5.1f}s | {str(e)[:260]}')
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('종료', cur.fetchone()[0], f'· 정상 {ok} · 오류 {ng}')
con.close()
