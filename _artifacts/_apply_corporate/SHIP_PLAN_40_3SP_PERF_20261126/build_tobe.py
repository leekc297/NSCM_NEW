# -*- coding: utf-8 -*-
"""SHIP_PLAN_40 배치 3개 SP 속도 보완 (E20261126-DS2, E20261126-BALCUM) TO-BE 생성
기준본 = 실행 때 ZIOUI1 ALL_SOURCE 새로 조회(FRESH-GATE : 같은 폴더 *.ASIS.sql 과 같아야 진행)
  python build_tobe.py          -> *.TOBE.sql 생성 (DB 변경 없음)
  python build_tobe.py --apply  -> FRESH-GATE 통과 시 ZIOUI1 에 CREATE OR REPLACE
"""
import sys, os, io, re
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn

W = os.path.dirname(os.path.abspath(__file__))
SPS = ['PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40']
DS_LINE = ("    /* [E20261126-DS2] GTT(통계 없음) 행 수 추정용. 클라우드 optimizer_dynamic_sampling = 0 (2026-11-26 확인) */\n"
           "    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';\n")


def fetch(c, n):
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = :1 AND TYPE = 'PROCEDURE' ORDER BY LINE", [n])
    return ''.join(r[0] for r in c.fetchall())


def one(s, old, new, what):
    k = s.count(old)
    assert k == 1, '%s : 대상 매칭 %d건(1건이어야 함)' % (what, k)
    return s.replace(old, new)


def add_ds(src, n):
    # 본문 BEGIN = 첫 번째 0열 BEGIN 줄 (지역 함수 BEGIN 은 들여쓰기 있음). MAIL 원문은 CRLF
    m = re.search(r'(?m)^BEGIN(\r?\n)', src)
    assert m, n + ' BEGIN 위치 없음'
    assert 'E20261126-DS2' not in src, n + ' 이미 반영됨'
    nl = m.group(1)
    return src[:m.end()] + DS_LINE.replace('\n', nl) + src[m.end():]


def seg(src, a, b):
    i = src.index(a); j = src.index(b, i)
    return i, j


def balance(src):
    # ---------------- 1단계 INSP_WIP ----------------
    i, j = seg(src, '/* 1. 변경날짜 이후  INSP_WIP  산출 : */', '/* TCO 모델은 WH_IN과 관계없이')
    s = src[i:j]
    s = one(s, '''           , Z AS (
             SELECT DISTINCT
                    DIVISION_ID''', '''           , Z AS (   /* [E20261126-BALCUM] 일자별 누적합을 Z 에서 1회 계산 */
             SELECT DIVISION_ID''', '1단계 Z 머리')
    s = one(s, '''                  , YYYYMMDD
               FROM SSP_ANL_SHIP_PLAN_40
              WHERE 1 = 1
                AND DIVISION_ID          = V_DIVISION_ID
                AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                AND PLAN_TYPE            = V_PLAN_TYPE
                AND SEQ                  = V_SEQ
                AND YYYYMMDD            >= V_DATA_START_YYYYMMDD
                AND MEASURE              IN ( 'INCO_WIP' ,'WH_IN')''', '''                  , YYYYMMDD
                  , SUM(SUM(CASE WHEN MEASURE = 'INCO_WIP' AND YYYYMMDD > V_DATA_START_YYYYMMDD THEN NVL(QTY, 0) ELSE 0 END))
                        OVER (PARTITION BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE
                              ORDER BY YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)          AS INCO_CUM_QTY   /* 당일까지 INCO_WIP 합 */
                  , NVL(SUM(SUM(CASE WHEN MEASURE = 'WH_IN' THEN NVL(QTY, 0) ELSE 0 END))
                        OVER (PARTITION BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE
                              ORDER BY YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)   AS WHIN_PREV_QTY  /* 전일까지 WH_IN 합 */
               FROM SSP_ANL_SHIP_PLAN_40
              WHERE 1 = 1
                AND DIVISION_ID          = V_DIVISION_ID
                AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                AND PLAN_TYPE            = V_PLAN_TYPE
                AND SEQ                  = V_SEQ
                AND YYYYMMDD            >= V_DATA_START_YYYYMMDD
                AND MEASURE              IN ( 'INCO_WIP' ,'WH_IN')''', '1단계 Z 컬럼')
    a = s.index('( /* 당일까지 INCO_WIP의 합 */')
    b = s.index("               , '-'   AS INCOTERMS", a)
    old = s[a:b]
    assert old.count('SELECT') == 2 and '( /* 전일까지 WH_IN의 합 */' in old, '1단계 서브쿼리 구간 확인 실패'
    s = s[:a] + '''/* [E20261126-BALCUM] 당일까지 INCO_WIP의 합 (종전 : Z 행마다 SSP_ANL_SHIP_PLAN_40 재조회) */
                 Z.INCO_CUM_QTY
                 +
                 /* 전일까지 WH_IN의 합 * -1 */
                 Z.WHIN_PREV_QTY * -1
''' + s[b:]
    src = src[:i] + s + src[j:]

    # ---------------- 3단계 WH_STOCK ----------------
    i, j = seg(src, '/* 3. 변경날짜 이후  WH_STOCK  산출 : */', '/* 4. UPDATE  WH_STOCK */')
    s = src[i:j]
    s = one(s, '''           , Z AS (
             SELECT DISTINCT
                    DIVISION_ID''', '''           , Z AS (   /* [E20261126-BALCUM] 전일까지 수량 변동 누적합을 Z 에서 1회 계산 */
             SELECT DIVISION_ID''', '3단계 Z 머리')
    s = one(s, '''                  , YYYYMMDD
               FROM SSP_ANL_SHIP_PLAN_40
              WHERE 1 = 1
                AND DIVISION_ID         = V_DIVISION_ID         /* '81' */''', '''                  , YYYYMMDD
                  , NVL(SUM(SUM(CASE MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * NVL(QTY, 0)
                                             WHEN 'POSTP_PLAN'      THEN -1 * NVL(QTY, 0)
                                             WHEN 'MES_FCS_HOLD'    THEN -1 * NVL(QTY, 0)
                                             WHEN 'WH_IN'           THEN      NVL(QTY, 0)
                                             WHEN 'MES_FCS_RELEASE' THEN      NVL(QTY, 0)
                                ELSE 0.0
                                END))
                        OVER (PARTITION BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE
                              ORDER BY YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0)   AS WHSTK_PREV_QTY  /* 전일까지 WH_IN, SHIP_CONFIRM 등 */
               FROM SSP_ANL_SHIP_PLAN_40
              WHERE 1 = 1
                AND DIVISION_ID         = V_DIVISION_ID         /* '81' */''', '3단계 Z 컬럼')
    s = one(s, '''             )
        SELECT
               Z.DIVISION_ID''', '''             )
           , HD AS (   /* [E20261126-BALCUM] HOLD 재고 일자별 1회 집계 (종전 : Z 행마다 HOLD x 달력 재조회) */
             SELECT H.FROM_SITE
                  , H.ITEM_ID
                  , C.BASIS_YYYYMMDD
                  , SUM(H.HOLD_QTY) AS HOLD_QTY
               FROM SSP_ANL_HOLD_STOCK H
                  , SCM_SYS_CALENDAR_M C
              WHERE H.DIVISION_ID         = V_DIVISION_ID
                AND H.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                AND H.PLAN_TYPE           = V_PLAN_TYPE
                AND H.SEQ                 = V_SEQ
                AND C.BASIS_YYYYMMDD     >= H.HOLD_YYYYMMDD
                AND C.BASIS_YYYYMMDD     <= H.RELEASE_YYYYMMDD
                AND C.BASIS_YYYYMMDD     >= V_DATA_START_YYYYMMDD
                AND C.BASIS_YYYYMMDD     <= (SELECT MAX(Z2.YYYYMMDD) FROM Z Z2)
              GROUP BY
                    H.FROM_SITE
                  , H.ITEM_ID
                  , C.BASIS_YYYYMMDD
             )
        SELECT
               Z.DIVISION_ID''', '3단계 HD 추가')
    pat = re.compile(r'\(\s*/\* 전일 WH_IN , 전일 SHIP_CONFIRM \*/.*?AND X\.YYYYMMDD\s+<\s+Z\.YYYYMMDD\s*\)', re.S)
    k = len(pat.findall(s)); assert k == 2, '3단계 누적 서브쿼리 %d건(2건이어야 함)' % k
    s = pat.sub('Z.WHSTK_PREV_QTY   /* [E20261126-BALCUM] 전일까지 WH_IN, SHIP_CONFIRM 등 (종전 : 행마다 재조회) */', s)
    pat = re.compile(r'NVL\(\(\s*SELECT SUM\(H\.HOLD_QTY \)\s*/\* HOLD재고 제외 \*/.*?C\.BASIS_YYYYMMDD\s*\)\s*,0\)', re.S)
    k = len(pat.findall(s)); assert k == 1, '3단계 HOLD 서브쿼리 %d건(1건이어야 함)' % k
    s = pat.sub('NVL(HD.HOLD_QTY, 0)   /* HOLD재고 제외 [E20261126-BALCUM] */', s)
    s = one(s, '''          FROM Z
             , BOH
''', '''          FROM Z
             , BOH
             , HD
''', '3단계 FROM')
    s = one(s, '''           AND B.FROM_SITE(+)            = Z.FROM_SITE
''', '''           AND B.FROM_SITE(+)            = Z.FROM_SITE
           AND HD.FROM_SITE(+)           = Z.FROM_SITE
           AND HD.ITEM_ID(+)             = Z.ITEM_ID
           AND HD.BASIS_YYYYMMDD(+)      = Z.YYYYMMDD
''', '3단계 조인')
    src = src[:i] + s + src[j:]
    return src


def build(c):
    out = {}
    for n in SPS:
        base = fetch(c, n)
        asis = io.open(os.path.join(W, n + '.ASIS.sql'), encoding='utf-8', newline='').read()
        assert base == asis, 'FRESH-GATE 실패 : %s DB 원문이 착수 기준본과 다름. 중단' % n
        t = add_ds(base, n)
        if n.endswith('_BALANCE'):
            t = balance(t)
        io.open(os.path.join(W, n + '.TOBE.sql'), 'w', encoding='utf-8', newline='').write(t)
        out[n] = t
        print(n, 'ASIS %d줄 -> TOBE %d줄' % (base.count('\n'), t.count('\n')))
    return out


if __name__ == '__main__':
    cx = dbconn.connect('tobe'); c = cx.cursor()
    out = build(c)
    if '--apply' in sys.argv:
        c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
        for n, t in out.items():
            # FRESH-GATE : 적용 직전 재조회
            assert fetch(c, n) == io.open(os.path.join(W, n + '.ASIS.sql'), encoding='utf-8', newline='').read(), 'FRESH-GATE 실패 ' + n
            c.execute('CREATE OR REPLACE ' + t)   # 현재 스키마 SCM_MGR
            c.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = :1 AND OBJECT_TYPE = 'PROCEDURE'", [n])
            st = c.fetchone()
            c.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER = 'SCM_MGR' AND NAME = :1", [n]); er = c.fetchone()[0]
            same = fetch(c, n).rstrip() == t.rstrip()
            print('APPLY', n, st, 'ERRORS', er, '적용본==DB원문', same)
