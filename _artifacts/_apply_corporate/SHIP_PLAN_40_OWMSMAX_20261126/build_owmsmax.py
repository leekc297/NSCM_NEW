# -*- coding: utf-8 -*-
"""PR_SSP_ANL_SHIP_PLAN_40 1-1 단계 '가장 최근 CUTOFF' MAX 조회 : 행마다 함수 호출 -> 스칼라 서브쿼리 캐시 (E20261126-OWMSMAX)
  python build_owmsmax.py fetch    : 사내 ZIOUI1 원문 새로 조회 -> ASIS.sql, ASIS.meta, TOBE.sql
  python build_owmsmax.py apply    : FRESH-GATE(DB 원문 == ASIS) 뒤 사내 적용, VALID/ALL_ERRORS 확인
  python build_owmsmax.py package <출력폴더> : 클라우드 이관 패키지 생성(FRESH-GATE : DB 원문 == ASIS 또는 TOBE)
"""
import sys, os, io, re
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn

W = os.path.dirname(os.path.abspath(__file__))
N = 'PR_SSP_ANL_SHIP_PLAN_40'
MARK = 'E20261126-OWMSMAX'
ZB = 'ZB_SSP40_SHIP_20261126B'
HS = 'ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;'
OLD_PRED = 'AND FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL'
NEW_PRED = 'AND (SELECT FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) FROM DUAL) IS NOT NULL'
MARK_LINE = ('/* [%s] 행마다 함수 호출 -> 스칼라 서브쿼리 캐시(같은 PLANT_ID, ITEM_ID 는 1회). '
             '클라우드 11-26 회차당 73~76초(83wgypmy3wyvu) */' % MARK)


def rd(p):
    return io.open(p, encoding='utf-8', newline='').read()


def wr(p, t):
    io.open(p, 'w', encoding='utf-8', newline='').write(t)


def fetch_src(c):
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = :1 AND TYPE = 'PROCEDURE' ORDER BY LINE", [N])
    return ''.join(r[0] for r in c.fetchall())


def meta(c):
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS'), STATUS, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') "
              "FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = :1 AND OBJECT_TYPE = 'PROCEDURE'", [N])
    return c.fetchone()


def build(asis):
    # MAX(CUTOFF_DATE) 문장 안의 함수 조건 1줄만 바꿈(같은 조건이 COUNT 문장에도 있어 MAX 문장 구간으로 한정)
    m = re.search(r'SELECT MAX\(CUTOFF_DATE\)\s*\r?\n\s*INTO V_DATA_CUTOFF_YYYYMMDD.*?;', asis, re.S)
    assert m, 'MAX(CUTOFF_DATE) 문장 없음'
    blk = m.group(0)
    assert blk.count(OLD_PRED) == 1, '함수 조건 줄 매칭 %d건' % blk.count(OLD_PRED)
    i = blk.index(OLD_PRED)
    ls = blk.rfind('\n', 0, i) + 1
    ind = blk[ls:i]
    nl = '\r\n' if '\r\n' in blk else '\n'
    nb = blk[:ls] + ind + MARK_LINE + nl + ind + NEW_PRED + blk[i + len(OLD_PRED):]
    assert asis.count(blk) == 1
    return asis.replace(blk, nb)


def main():
    cx = dbconn.connect('tobe'); c = cx.cursor()
    cmd = sys.argv[1]
    if cmd == 'fetch':
        src = fetch_src(c); ddl, st, at = meta(c)
        assert MARK not in src, '이미 반영된 원문'
        wr(os.path.join(W, N + '.ASIS.sql'), src)
        wr(os.path.join(W, N + '.ASIS.meta'), 'LAST_DDL=%s STATUS=%s FETCHED=%s LINES=%d\n' % (ddl, st, at, src.count('\n')))
        tobe = build(src)
        wr(os.path.join(W, N + '.TOBE.sql'), tobe)
        print('ASIS', ddl, st, at, 'TOBE lines +%d' % (tobe.count('\n') - src.count('\n')))
    elif cmd == 'apply':
        asis = rd(os.path.join(W, N + '.ASIS.sql')); tobe = rd(os.path.join(W, N + '.TOBE.sql'))
        now = fetch_src(c)
        assert now == asis, 'FRESH-GATE 실패 : 사내 원문이 착수 기준본과 다름. 중단'
        try:
            c.execute('CREATE OR REPLACE ' + tobe)
        except Exception as e:
            print('compile warn', str(e)[:200])
        ddl, st, at = meta(c)
        c.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER = 'SCM_MGR' AND NAME = :1", [N]); ec = c.fetchone()[0]
        same = fetch_src(c) == tobe
        print('APPLY', st, 'ERR', ec, 'LAST_DDL', ddl, 'DB==TOBE', same)
        if st != 'VALID' or ec:
            c.execute('CREATE OR REPLACE ' + asis); print('복원', meta(c))
    else:
        raise SystemExit('fetch | apply | package')


if __name__ == '__main__':
    main()
