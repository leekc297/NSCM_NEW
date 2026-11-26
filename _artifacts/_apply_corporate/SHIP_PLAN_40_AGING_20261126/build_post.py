# -*- coding: utf-8 -*-
"""PR_SSP_ANL_SHIP_PLAN_40 2-3 POSTP_PLAN GT_SSP_FORMATION_POST_CELL 적재(6fv7933qvycp9) : FP 생산계획 이력 인덱스 건너뛰기 힌트 (E20261126-POSTSS)
  python build_post.py fetch | apply   (원본 = 실행 때 ALL_SOURCE 새로 조회, 파일 접미사 .P)
"""
import sys, os
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, r'c:\Projects\NSCM\_artifacts\_apply_corporate\SHIP_PLAN_40_OWMSMAX_20261126')
import dbconn
from build_owmsmax import N, rd, wr, meta

W = os.path.dirname(os.path.abspath(__file__))
MARK = 'E20261126-POSTSS'
ANCHOR = '''        SELECT  P.DIVISION_ID               AS DIVISION_ID
        ,       NVL(IM.APPLIED_MODEL, P.CELL_ITEM_ID) AS ITEM_ID'''
NEW = '''        /* [E20261126-POSTSS] FP_MGR.SCM_FORMATION_POST_CELL_V(@SEL$3) 의 FP_DAILY_PRODUCTIOIN_PLAN_H 를 IX01(DIVISION_ID, COMPANY_ID, PLAN_DATE) 건너뛰기 스캔. */
        /* COMPANY_ID 조건이 없어 사업부 전체 이력(사내 40 사업부 3,179,539행)을 읽던 것을 회사별 PLAN_DATE 범위만 읽음. 클라우드 11-26 회차당 34 ~ 42초(6fv7933qvycp9) */
        SELECT  /*+ INDEX_SS(@SEL$3 DPP IX01_FP_DAILY_PRODUCTIOIN_PLAN_H) */
                P.DIVISION_ID               AS DIVISION_ID
        ,       NVL(IM.APPLIED_MODEL, P.CELL_ITEM_ID) AS ITEM_ID'''


def fetch_src(c):
    """작업 기준 원문 = 실행 때 DB 에서 새로 조회(ALL_SOURCE)"""
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = :1 AND TYPE = 'PROCEDURE' ORDER BY LINE", [N])
    return ''.join(r[0] for r in c.fetchall())


def build(asis):
    assert asis.count(ANCHOR) == 1, 'ANCHOR %d건' % asis.count(ANCHOR)
    i = asis.index('/* 2-3. [S]POSTP_PLAN'); j = asis.index(ANCHOR); k = asis.index('/* 2-4. [P]PROD_PLAN', i)
    assert i < j < k
    return asis.replace(ANCHOR, NEW)


def main():
    c = dbconn.connect('tobe').cursor()
    cmd = sys.argv[1]
    a, t = os.path.join(W, N + '.P.ASIS.sql'), os.path.join(W, N + '.P.TOBE.sql')
    if cmd == 'fetch':
        src = fetch_src(c); ddl, st, at = meta(c)
        assert MARK not in src
        assert all(m in src for m in ('E20261126-DS2', 'E20261126-OWMSMAX', 'E20261126-AGINGCUT', 'E20261126-WHSTKHD'))
        wr(a, src)
        wr(os.path.join(W, N + '.P.ASIS.meta'), 'LAST_DDL=%s STATUS=%s FETCHED=%s LINES=%d\n' % (ddl, st, at, src.count('\n')))
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
