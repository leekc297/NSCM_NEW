# -*- coding: utf-8 -*-
"""PR_SSP_ANL_SHIP_PLAN_40 1-6 단계 GT_SCM_DNM_STOCK_AGING_V 적재(awr2c30u4h31c) : 바깥쪽 뷰에 조인에서 나오는 조건 2줄 명시 (E20261126-AGINGCUT)
  python build_aging.py fetch | apply
"""
import sys, os, io
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, r'c:\Projects\NSCM\_artifacts\_apply_corporate\SHIP_PLAN_40_OWMSMAX_20261126')
import dbconn
from build_owmsmax import N, rd, wr, meta


def fetch_src(c):
    """작업 기준 원문 = 실행 때 DB 에서 새로 조회(ALL_SOURCE)"""
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = :1 AND TYPE = 'PROCEDURE' ORDER BY LINE", [N])
    return ''.join(r[0] for r in c.fetchall())

W = os.path.dirname(os.path.abspath(__file__))
MARK = 'E20261126-AGINGCUT'
ANCHOR = '''           AND A.CUTOFF_DATE = B.CUTOFF_DATE
        ;
'''
NEW = '''           AND A.CUTOFF_DATE = B.CUTOFF_DATE
         /* [E20261126-AGINGCUT] 조인 조건에서 나오는 조건을 바깥쪽 뷰에 명시(결과 같음). 뷰 CUTOFF_DATE = 원장 CUTOFF_DATE - 1 이므로 */
         /* A.CUTOFF_DATE > SYSDATE - 5 = A.ORG_CUTOFF_DATE > SYSDATE - 4. 원장 SCM_AGING_STOCK_H 전체 읽기 → CUTOFF_DATE 인덱스 범위 */
         WHERE A.DIVISION_ID     = V_DIVISION_ID
           AND A.ORG_CUTOFF_DATE > SYSDATE - 4
        ;
'''


def build(asis):
    i = asis.index('INSERT INTO GT_SCM_DNM_STOCK_AGING_V')
    j = asis.index(ANCHOR, i)
    assert asis.count(ANCHOR) == 1, 'ANCHOR %d건' % asis.count(ANCHOR)
    assert j - i < 2000
    return asis[:j] + NEW + asis[j + len(ANCHOR):]


def main():
    c = dbconn.connect('tobe').cursor()
    cmd = sys.argv[1]
    if cmd == 'fetch':
        src = fetch_src(c); ddl, st, at = meta(c)
        assert MARK not in src
        assert 'E20261126-OWMSMAX' in src and 'E20261126-DS2' in src
        wr(os.path.join(W, N + '.ASIS.sql'), src)
        wr(os.path.join(W, N + '.ASIS.meta'), 'LAST_DDL=%s STATUS=%s FETCHED=%s LINES=%d\n' % (ddl, st, at, src.count('\n')))
        tobe = build(src); wr(os.path.join(W, N + '.TOBE.sql'), tobe)
        print('ASIS', ddl, st, at, 'TOBE lines +%d' % (tobe.count('\n') - src.count('\n')))
    elif cmd == 'apply':
        asis = rd(os.path.join(W, N + '.ASIS.sql')); tobe = rd(os.path.join(W, N + '.TOBE.sql'))
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
