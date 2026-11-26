# -*- coding: utf-8 -*-
"""PR_SSP_ANL_SHIP_PLAN_40 2-14 WH_STOCK 적재(aj7nw6qjt4tjv) : HOLD 집계(HD) 조인 조건 밀어넣기 금지 힌트 (E20261126-WHSTKHD)
  python build_whstk.py fetch | apply   (원본 = 실행 때 ALL_SOURCE 새로 조회, 파일 접미사 .W)
"""
import sys, os, io
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, r'c:\Projects\NSCM\_artifacts\_apply_corporate\SHIP_PLAN_40_OWMSMAX_20261126')
import dbconn
from build_owmsmax import N, rd, wr, meta

W = os.path.dirname(os.path.abspath(__file__))
MARK = 'E20261126-WHSTKHD'
ANCHOR = '''        SELECT
             Z.DIVISION_ID
            ,Z.PLAN_START_YYYYMMDD
            ,Z.PLAN_TYPE
            ,Z.SEQ
            ,Z.ITEM_ID
            ,Z.FROM_SITE
            ,'-'   AS TO_SITE
            ,'WH_STOCK' AS MEASURE'''
NEW = '''        /* [E20261126-WHSTKHD] GTT 행 수를 1행으로 추정하면 Z 행마다 HD 를 다시 집계(SSP_ANL_HOLD_STOCK 인덱스 스킵 스캔 반복)함. */
        /* HD 는 한 번만 집계하도록 조인 조건 밀어넣기 금지. 클라우드 11-26 회차당 111 ~ 133초(aj7nw6qjt4tjv) */
        SELECT /*+ NO_PUSH_PRED(HD) */
             Z.DIVISION_ID
            ,Z.PLAN_START_YYYYMMDD
            ,Z.PLAN_TYPE
            ,Z.SEQ
            ,Z.ITEM_ID
            ,Z.FROM_SITE
            ,'-'   AS TO_SITE
            ,'WH_STOCK' AS MEASURE'''


def fetch_src(c):
    """작업 기준 원문 = 실행 때 DB 에서 새로 조회(ALL_SOURCE)"""
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = :1 AND TYPE = 'PROCEDURE' ORDER BY LINE", [N])
    return ''.join(r[0] for r in c.fetchall())


def build(asis):
    assert asis.count(ANCHOR) == 1, 'ANCHOR %d건' % asis.count(ANCHOR)
    i = asis.index('/* 2-14. [I]WH_STOC'); j = asis.index(ANCHOR); k = asis.index('/* 2-15.', i)
    assert i < j < k
    return asis.replace(ANCHOR, NEW)


def main():
    c = dbconn.connect('tobe').cursor()
    cmd = sys.argv[1]
    a, t = os.path.join(W, N + '.W.ASIS.sql'), os.path.join(W, N + '.W.TOBE.sql')
    if cmd == 'fetch':
        src = fetch_src(c); ddl, st, at = meta(c)
        assert MARK not in src
        assert all(m in src for m in ('E20261126-DS2', 'E20261126-OWMSMAX', 'E20261126-AGINGCUT'))
        wr(a, src)
        wr(os.path.join(W, N + '.W.ASIS.meta'), 'LAST_DDL=%s STATUS=%s FETCHED=%s LINES=%d\n' % (ddl, st, at, src.count('\n')))
        wr(t, build(src))
        print('ASIS', ddl, st, at)
    elif cmd == 'apply':
        asis, tobe = rd(a), rd(t)
        assert fetch_src(c) == asis, 'FRESH-GATE 실패 : 사내 원문이 착수 기준본과 다름. 중단'
        try:
            c.execute('CREATE OR REPLACE ' + tobe)
        except Exception as e:
            print('compile warn', str(e)[:200])
        ddl, st, at = meta(c)
        c.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER = 'SCM_MGR' AND NAME = :1", [N]); ec = c.fetchone()[0]
        print('APPLY', st, 'ERR', ec, 'LAST_DDL', ddl, 'DB==TOBE', fetch_src(c) == tobe)
        if st != 'VALID' or ec:
            c.execute('CREATE OR REPLACE ' + asis); print('복원', meta(c))


if __name__ == '__main__':
    main()
