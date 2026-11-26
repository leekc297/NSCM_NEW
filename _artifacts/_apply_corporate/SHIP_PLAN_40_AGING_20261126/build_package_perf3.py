# -*- coding: utf-8 -*-
"""SHIP_PLAN_40 3차 클라우드 패치 패키지 : PERF2(OWMSMAX, AGINGCUT, WHSTKHD) + E20261126-POSTSS(2-3)
클라우드 원문 위에 보완 위치만 바꿈. 위치마다 표식이 있으면 SKIP. 클라우드에 PERF2 가 적용돼 있으면 POSTSS 1곳만 바뀜
FRESH-GATE : 사내 DB 원문(ALL_SOURCE 새로 조회) == 사내 최종본(P.TOBE)
  python build_package_perf3.py <출력폴더>
"""
import sys, os, io
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
import build_package_perf2 as bpk
import build_patch_perf2 as bp

W = os.path.dirname(os.path.abspath(__file__))
N = bpk.N
MARKS = ['E20261126-DS2', 'E20261126-OWMSMAX', 'E20261126-AGINGCUT', 'E20261126-WHSTKHD', 'E20261126-POSTSS']
ZB = 'ZB_SSP40_SHIP_20261126D'
FINAL2 = os.path.join(W, 'PR_SSP_ANL_SHIP_PLAN_40.W.TOBE.sql')
FINAL3 = os.path.join(W, 'PR_SSP_ANL_SHIP_PLAN_40.P.TOBE.sql')
bpk.MARKS = MARKS; bp.MARKS = MARKS; bpk.ZB = ZB


def fetch_src(c):
    """작업 기준 원문 = 실행 때 DB 에서 새로 조회(ALL_SOURCE)"""
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = :1 AND TYPE = 'PROCEDURE' ORDER BY LINE", [N])
    return ''.join(r[0] for r in c.fetchall())


def precheck_sql():
    return '''/* 사전 확인 (조회만). 표식 5종 중 이미 있는 것은 20 에서 SKIP. M_POSTSS = 1 이면 이미 반영 */
%(hs)s
SELECT S.NAME
     , (SELECT MAX(O.STATUS) FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = S.NAME AND O.OBJECT_TYPE = 'PROCEDURE') AS STATUS
     , (SELECT TO_CHAR(MAX(O.LAST_DDL_TIME), 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = S.NAME AND O.OBJECT_TYPE = 'PROCEDURE') AS LAST_DDL_TIME
     , S.CLOUD_LINES
%(mc)s
  FROM (SELECT NAME
             , COUNT(*) AS CLOUD_LINES
%(mc2)s
          FROM ALL_SOURCE
         WHERE OWNER = 'SCM_MGR'
           AND NAME  = '%(n)s'
           AND TYPE  = 'PROCEDURE'
         GROUP BY NAME) S;

/* [P2] 지금 SHIP_PLAN_40 을 실행 중인 세션. 0행일 때 진행 */
SELECT S.SID, S.SERIAL#, S.USERNAME, S.MODULE, S.STATUS, S.SQL_ID, S.LAST_CALL_ET
  FROM GV$SESSION S
 WHERE S.PLSQL_ENTRY_OBJECT_ID IN (SELECT O.OBJECT_ID FROM ALL_OBJECTS O
                                    WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = '%(n)s' AND O.OBJECT_TYPE = 'PROCEDURE');
''' % dict(hs=bpk.HS, n=N, mc='\n'.join('     , S.M_%s' % m.split('-')[1] for m in MARKS), mc2=bpk.mark_cols())


def verify_sql(f):
    return '''/* 확인 (조회만). 기대값 : STATUS VALID, ERR_CNT 0, 표식 5종 각 1. 클라우드 원문이 사내와 다른 줄(1752줄 공백)이 있어 SAME_AS_CORP_FINAL = N, LINE_CNT %(fl)d */
%(hs)s
SELECT O.OBJECT_NAME
     , O.STATUS
     , TO_CHAR(O.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL_TIME
     , (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER = 'SCM_MGR' AND E.NAME = O.OBJECT_NAME) AS ERR_CNT
     , S.LINE_CNT
     , CASE WHEN S.LINE_CNT = %(fl)d AND S.H = %(fh)d THEN 'Y' ELSE 'N' END AS SAME_AS_CORP_FINAL
%(mc)s
  FROM ALL_OBJECTS O
     , (SELECT COUNT(*) AS LINE_CNT
             , SUM(ORA_HASH(TEXT)) AS H
%(mc2)s
          FROM ALL_SOURCE
         WHERE OWNER = 'SCM_MGR' AND NAME = '%(n)s' AND TYPE = 'PROCEDURE') S
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME = '%(n)s'
   AND O.OBJECT_TYPE = 'PROCEDURE';
''' % dict(hs=bpk.HS, fl=f[0], fh=f[1], n=N, mc='\n'.join('     , S.M_%s' % m.split('-')[1] for m in MARKS), mc2=bpk.mark_cols())


def main(out):
    cx = dbconn.connect('tobe'); c = cx.cursor()
    A, B, F2, F3 = bpk.rd(bpk.BASE_A), bpk.rd(bpk.BASE_B), bpk.rd(FINAL2), bpk.rd(FINAL3)
    assert fetch_src(c) == F3, 'FRESH-GATE 실패 : 사내 원문이 사내 최종본과 다름'
    hs = bp.hunks(A, F3)
    for h in hs:
        print('hunk', h['line'], h['mark'], 'old lines', h['old'].count('\n'))
    # 자체 시험 : A, B, PERF2 최종본, PERF2 최종본(1752줄 공백 다름)에 패치하면 사내 최종본(또는 같은 공백 차이)과 같아야 함
    def tweak(s):
        a = s.split('\n'); k = [i for i, x in enumerate(a) if x == '        ' and i > 1700][0]; a[k] = ''; return '\n'.join(a)
    for nm, src, exp in (('A', A, F3), ('B', B, F3), ('F2', F2, F3), ("F2'", tweak(F2), tweak(F3))):
        x = src
        for h in hs:
            if h['mark'] in x:
                continue
            assert x.count(h['old']) == 1, (nm, h['line'])
            x = x.replace(h['old'], h['new'])
        assert x == exp, nm
        print('self-test', nm, 'OK')
    c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') FROM DUAL"); at = c.fetchone()[0]
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = :1 AND OBJECT_TYPE = 'PROCEDURE'", [N])
    st = '-- SOURCE-FRESH: SCM_MGR.%s PROCEDURE LAST_DDL=%s FETCHED=%s DB=ZIOUI1' % (N, c.fetchone()[0], at)
    d = os.path.join(out, 'A_DB'); os.makedirs(d, exist_ok=True)
    patch = bp.patch_sql(hs).replace('보완 3곳만 바꿈 (E20261126-OWMSMAX 1-1, E20261126-AGINGCUT 1-6, E20261126-WHSTKHD 2-14)',
                                     '보완 위치만 바꿈 (OWMSMAX 1-1, AGINGCUT 1-6, WHSTKHD 2-14, POSTSS 2-3)').replace('3곳 모두 이미 반영', '모든 위치 이미 반영')
    files = {
        '00_PRECHECK.sql': precheck_sql(),
        '05_BACKUP.sql': bpk.backup_sql(),
        '15_DIFF_SOURCE.sql': bp.diff_sql('PERF2 사내 최종본', bp.line_hashes(c, F2)),
        '20_PATCH_%s.sql' % N: st + '\n' + patch,
        '90_VERIFY.sql': verify_sql(bpk.lines_hash(c, F3)),
        '99_ROLLBACK.sql': bpk.rollback_sql(),
    }
    for fn, t in files.items():
        io.open(os.path.join(d, fn), 'w', encoding='utf-8', newline='\n').write(t)
        print('[OUT]', fn, len(t))


if __name__ == '__main__':
    main(sys.argv[1])
