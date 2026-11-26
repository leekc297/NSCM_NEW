# -*- coding: utf-8 -*-
"""BALANCE 1, 3단계 원문 vs 변경본 : 전 행 fetch 소요 (서브쿼리 계산 강제)"""
import sys, time, io, re
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
N = 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE'
def q(path, a, b):
    t = io.open(path, encoding='utf-8', newline='').read().replace('\r\n', '\n')
    i = t.index(a); s = t[i:t.index(b, i)]; s = s[:s.rindex(';')]
    return re.sub(r'\bV_(DIVISION_ID|PLAN_START_YYYYMMDD|PLAN_TYPE|SEQ|DATA_START_YYYYMMDD)\b', r':V_\1', s)
cx = dbconn.connect('tobe'); c = cx.cursor(); c.arraysize = 5000; c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
for p in sys.argv[1:]:
    B = dict(V_DIVISION_ID='40', V_PLAN_START_YYYYMMDD=p, V_PLAN_TYPE='SP', V_SEQ=1, V_DATA_START_YYYYMMDD=p)
    for st, (a, b) in (('1', ('WITH INSP AS', '/* TCO 모델은')), ('3', ('WITH BOH AS', '/* 4. UPDATE  WH_STOCK */'))):
        for rnd in (1, 2):
            for k in ('ASIS', 'TOBE'):
                s = q(N + '.%s.sql' % k, a, b)
                bb = {x: v for x, v in B.items() if ':' + x in s}
                t = time.time(); c.execute(s + ' /* F%d%s%s */' % (rnd, k, st), bb); rows = c.fetchall()
                print('PLAN', p, 'STEP', st, 'ROUND', rnd, k, len(rows), '%.1fs' % (time.time() - t), flush=True)
