# -*- coding: utf-8 -*-
"""BALANCE 1단계(INSP_WIP), 3단계(WH_STOCK) 원문 vs 변경본 결과 대조 (조회만)"""
import sys, io, re, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
N = 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE'
def q(path, a, b):
    t = io.open(path, encoding='utf-8', newline='').read().replace('\r\n', '\n')
    i = t.index(a); j = t.index(';', t.index(b, i) - 40) if False else None
    s = t[i:t.index(b, i)]
    s = s[:s.rindex(';')]
    return re.sub(r'\bV_(DIVISION_ID|PLAN_START_YYYYMMDD|PLAN_TYPE|SEQ|DATA_START_YYYYMMDD)\b', r':V_\1', s)
STEPS = {'1': ('WITH INSP AS', '/* TCO 모델은'), '3': ('WITH BOH AS', '/* 4. UPDATE  WH_STOCK */')}
cx = dbconn.connect('tobe'); c = cx.cursor(); c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
for p in sys.argv[2:]:
    b = dict(V_DIVISION_ID='40', V_PLAN_START_YYYYMMDD=p, V_PLAN_TYPE='SP', V_SEQ=1, V_DATA_START_YYYYMMDD=p)
    for st in sys.argv[1].split(','):
        o = q(N + '.ASIS.sql', *STEPS[st]); n = q(N + '.TOBE.sql', *STEPS[st])
        res = {}
        for k, s in (('ASIS', o), ('TOBE', n)):
            bb = {x: v for x, v in b.items() if ':' + x in s}
            t = time.time(); c.execute('SELECT COUNT(*), ' + ('SUM(QTY)' if st == '3' else 'NULL') + ' FROM (' + s + ')', bb); r = c.fetchone()
            res[k] = (r, round(time.time() - t, 1))
        bb = {x: v for x, v in b.items() if ':' + x in o + n}
        c.execute('SELECT COUNT(*) FROM (SELECT * FROM (' + o + ') MINUS SELECT * FROM (' + n + '))', bb); d1 = c.fetchone()[0]
        c.execute('SELECT COUNT(*) FROM (SELECT * FROM (' + n + ') MINUS SELECT * FROM (' + o + '))', bb); d2 = c.fetchone()[0]
        print('PLAN', p, 'STEP', st, 'ASIS', res['ASIS'], 'TOBE', res['TOBE'], 'MINUS', d1, d2, flush=True)
