# -*- coding: utf-8 -*-
"""SHIP_PLAN_40 2차 속도 보완 클라우드 패키지 : E20261126-OWMSMAX(1-1) + E20261126-AGINGCUT(1-6) + E20261126-WHSTKHD(2-14)
클라우드 원문이 두 기준본 중 하나일 때만 사내 최종본으로 교체
  기준본 A = SSP_SHIP_PLAN_40_BATCH_PERF_CLOUD_20261126 적용본(DS2, 3582줄)
  기준본 B = SSP_SHIP_PLAN_40_OWMSMAX_CLOUD_20261126 적용본(DS2 + OWMSMAX, 3583줄)
FRESH-GATE : 사내 DB 원문(ALL_SOURCE 새로 조회) == 사내 최종본(W.TOBE)
  python build_package_perf2.py <출력폴더>
"""
import sys, os, io
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, r'c:\Projects\NSCM\_artifacts\_apply_corporate\SHIP_PLAN_40_3SP_PERF_20261126')
import dbconn
from build_package import lines_hash, chunks, stamp

W = os.path.dirname(os.path.abspath(__file__))
N = 'PR_SSP_ANL_SHIP_PLAN_40'
ZB = 'ZB_SSP40_SHIP_20261126C'
HS = 'ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;'
MARKS = ['E20261126-DS2', 'E20261126-OWMSMAX', 'E20261126-AGINGCUT', 'E20261126-WHSTKHD']
BASE_A = r'c:\Projects\NSCM\_artifacts\_apply_corporate\SHIP_PLAN_40_OWMSMAX_20261126\PR_SSP_ANL_SHIP_PLAN_40.ASIS.sql'
BASE_B = r'c:\Projects\NSCM\_artifacts\_apply_corporate\SHIP_PLAN_40_OWMSMAX_20261126\PR_SSP_ANL_SHIP_PLAN_40.TOBE.sql'
FINAL = os.path.join(W, 'PR_SSP_ANL_SHIP_PLAN_40.W.TOBE.sql')


def rd(p):
    return io.open(p, encoding='utf-8', newline='').read()


def fetch_src(c):
    """작업 기준 원문 = 실행 때 DB 에서 새로 조회(ALL_SOURCE)"""
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = :1 AND TYPE = 'PROCEDURE' ORDER BY LINE", [N])
    return ''.join(r[0] for r in c.fetchall())


def mark_cols(alias=''):
    return '\n'.join("     , COUNT(CASE WHEN INSTR(%sTEXT, '%s') > 0 THEN 1 END) AS M_%s" % (alias, m, m.split('-')[1]) for m in MARKS)


def replace_sql(final, a, b):
    body = '\n'.join("    ap(v_new, q'~%s~');" % ch for ch in chunks(final))
    return '''/* %(n)s : 1-1 최근 CUTOFF 조회(E20261126-OWMSMAX), 1-6 AGING 적재(E20261126-AGINGCUT), 2-14 WH_STOCK(E20261126-WHSTKHD) 보완본으로 교체
 * 클라우드 원문이 기준본 A(줄 %(al)d, SUM(ORA_HASH(TEXT)) %(ah)d) 또는 기준본 B(줄 %(bl)d, %(bh)d)일 때만 교체.
 *   A = SSP_SHIP_PLAN_40_BATCH_PERF_CLOUD_20261126 적용본, B = A + SSP_SHIP_PLAN_40_OWMSMAX_CLOUD_20261126 적용본
 * 이미 반영(E20261126-WHSTKHD 표식 있음)이면 SKIP. 그 밖이면 -20011 중단(원문 무변경). 컴파일 실패면 원문 복원(-20012).
 * SCM_MGR 접속, 전체 실행(F5). Output 창 문구 확인 */
SET SERVEROUTPUT ON SIZE UNLIMITED
%(hs)s
DECLARE
    c_name CONSTANT VARCHAR2(128) := '%(n)s';
    v_new  CLOB;
    v_old  CLOB;
    v_cnt  NUMBER;
    v_hash NUMBER;
    v_mk   NUMBER;
    v_st   VARCHAR2(30);
    PROCEDURE ap(c IN OUT NOCOPY CLOB, t VARCHAR2) IS
    BEGIN
        IF t IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(t), t); END IF;
    END;
BEGIN
    SELECT COUNT(*), SUM(ORA_HASH(TEXT)), COUNT(CASE WHEN INSTR(TEXT, 'E20261126-WHSTKHD') > 0 THEN 1 END)
      INTO v_cnt, v_hash, v_mk
      FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE';
    IF v_mk > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  ' || c_name || ' 이미 반영됨(E20261126-WHSTKHD)');
        RETURN;
    END IF;
    IF NOT ((v_cnt = %(al)d AND v_hash = %(ah)d) OR (v_cnt = %(bl)d AND v_hash = %(bh)d)) THEN
        RAISE_APPLICATION_ERROR(-20011, c_name || ' : 클라우드 원문이 기준본 A, B 와 다름(줄 ' || v_cnt || ', 해시 ' || v_hash || '). 원문 무변경. 클라우드 원문 전달 필요');
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_old, TRUE);
    ap(v_old, 'CREATE OR REPLACE ');
    FOR r IN (SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE' ORDER BY LINE) LOOP
        ap(v_old, r.TEXT);
    END LOOP;
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    ap(v_new, 'CREATE OR REPLACE ');
%(body)s
    BEGIN
        EXECUTE IMMEDIATE v_new;
    EXCEPTION
        WHEN OTHERS THEN NULL;   /* ORA-24344 컴파일 오류는 아래 STATUS 로 판정 */
    END;
    SELECT STATUS INTO v_st FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = c_name AND OBJECT_TYPE = 'PROCEDURE';
    IF v_st <> 'VALID' THEN
        BEGIN EXECUTE IMMEDIATE v_old; EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20012, c_name || ' : 컴파일 실패로 원문 복원함. ALL_ERRORS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY ' || c_name || ' · ' || v_st || ' · 이전 원문 ' || CASE WHEN v_cnt = %(al)d THEN 'A' ELSE 'B' END);
END;
/
''' % dict(n=N, al=a[0], ah=a[1], bl=b[0], bh=b[1], hs=HS, body=body)


def precheck_sql(a, b):
    return '''/* 사전 확인 (조회만) */
%(hs)s
/* [P1] BASE = A 또는 B 면 20 적용 가능. FINAL 이면 이미 반영(20 은 SKIP). OTHER 면 원문 회신 필요 */
SELECT S.NAME
     , (SELECT MAX(O.STATUS) FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = S.NAME AND O.OBJECT_TYPE = 'PROCEDURE') AS STATUS
     , (SELECT TO_CHAR(MAX(O.LAST_DDL_TIME), 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = S.NAME AND O.OBJECT_TYPE = 'PROCEDURE') AS LAST_DDL_TIME
     , S.CLOUD_LINES
     , CASE WHEN S.CLOUD_LINES = %(al)d AND S.CLOUD_HASH = %(ah)d THEN 'A'
            WHEN S.CLOUD_LINES = %(bl)d AND S.CLOUD_HASH = %(bh)d THEN 'B'
            WHEN S.M_WHSTKHD > 0 THEN 'FINAL'
            ELSE 'OTHER' END AS BASE
     , S.M_DS2
     , S.M_OWMSMAX
     , S.M_AGINGCUT
     , S.M_WHSTKHD
  FROM (SELECT NAME
             , COUNT(*) AS CLOUD_LINES
             , SUM(ORA_HASH(TEXT)) AS CLOUD_HASH
%(mc)s
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
''' % dict(hs=HS, al=a[0], ah=a[1], bl=b[0], bh=b[1], n=N, mc=mark_cols())


def backup_sql():
    return """/* 현재 클라우드 %(n)s 원문을 보관 표 %(zb)s 에 저장 (표가 이미 있으면 SKIP). 원복(99) 기준본 */
SET SERVEROUTPUT ON
%(hs)s
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.%(zb)s AS SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER = ''SCM_MGR'' AND NAME = ''%(n)s'' AND TYPE = ''PROCEDURE''';
    DBMS_OUTPUT.PUT_LINE('> BACKUP %(zb)s 생성');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN DBMS_OUTPUT.PUT_LINE('> SKIP   %(zb)s 이미 있음');
        ELSE RAISE; END IF;
END;
/
SELECT '%(n)s' AS NAME, COUNT(*) AS BACKUP_LINES FROM SCM_MGR.%(zb)s;
""" % dict(n=N, zb=ZB, hs=HS)


def rollback_sql():
    return '''/* 원복 : 05 보관 표 원문으로 %(n)s 되돌림 (문제 있을 때만). 05 실행 시점 원문(기준본 A 또는 B)으로 돌아감 */
SET SERVEROUTPUT ON SIZE UNLIMITED
%(hs)s
DECLARE
    v    CLOB;
    v_st VARCHAR2(30);
    v_n  NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_n FROM ALL_TABLES WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = '%(zb)s';
    IF v_n = 0 THEN DBMS_OUTPUT.PUT_LINE('> SKIP %(n)s 보관 표 없음'); RETURN; END IF;
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
    DBMS_LOB.WRITEAPPEND(v, LENGTH('CREATE OR REPLACE '), 'CREATE OR REPLACE ');
    FOR r IN (SELECT TEXT FROM SCM_MGR.%(zb)s ORDER BY LINE) LOOP
        IF r.TEXT IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT); END IF;
    END LOOP;
    BEGIN EXECUTE IMMEDIATE v; EXCEPTION WHEN OTHERS THEN NULL; END;
    SELECT STATUS INTO v_st FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = '%(n)s' AND OBJECT_TYPE = 'PROCEDURE';
    DBMS_OUTPUT.PUT_LINE('> ROLLBACK %(n)s · ' || v_st);
END;
/
''' % dict(n=N, zb=ZB, hs=HS)


def verify_sql(f):
    return '''/* 확인 (조회만). 기대값 : STATUS VALID, ERR_CNT 0, LINE_CNT %(fl)d, SAME_AS_CORP_FINAL Y, 표식 4종 각 1 */
%(hs)s
SELECT O.OBJECT_NAME
     , O.STATUS
     , TO_CHAR(O.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL_TIME
     , (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER = 'SCM_MGR' AND E.NAME = O.OBJECT_NAME) AS ERR_CNT
     , S.LINE_CNT
     , CASE WHEN S.LINE_CNT = %(fl)d AND S.H = %(fh)d THEN 'Y' ELSE 'N' END AS SAME_AS_CORP_FINAL
     , S.M_DS2
     , S.M_OWMSMAX
     , S.M_AGINGCUT
     , S.M_WHSTKHD
  FROM ALL_OBJECTS O
     , (SELECT COUNT(*) AS LINE_CNT
             , SUM(ORA_HASH(TEXT)) AS H
%(mc)s
          FROM ALL_SOURCE
         WHERE OWNER = 'SCM_MGR' AND NAME = '%(n)s' AND TYPE = 'PROCEDURE') S
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME = '%(n)s'
   AND O.OBJECT_TYPE = 'PROCEDURE';
/* 속도 확인 : 다음 회차 실행 뒤 BATCH_속도점검_SHIP_PLAN_40_3SP_적용후실행일 쿼리 [C4] [C7] [C8] 재조회 */
''' % dict(hs=HS, fl=f[0], fh=f[1], n=N, mc=mark_cols())


def main(out):
    cx = dbconn.connect('tobe'); c = cx.cursor()
    c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') FROM DUAL"); at = c.fetchone()[0]
    final = rd(FINAL)
    assert fetch_src(c) == final, 'FRESH-GATE 실패 : 사내 원문이 사내 최종본과 다름'
    assert all(m in final for m in MARKS)
    a = lines_hash(c, rd(BASE_A)); b = lines_hash(c, rd(BASE_B)); f = lines_hash(c, final)
    os.makedirs(os.path.join(out, 'A_DB'), exist_ok=True)
    files = {
        '00_PRECHECK.sql': precheck_sql(a, b),
        '05_BACKUP.sql': backup_sql(),
        '20_REPLACE_%s.sql' % N: stamp(c, N, at) + '\n' + replace_sql(final, a, b),
        '90_VERIFY.sql': verify_sql(f),
        '99_ROLLBACK.sql': rollback_sql(),
    }
    for fn, t in files.items():
        io.open(os.path.join(out, 'A_DB', fn), 'w', encoding='utf-8', newline='\n').write(t)
        print('[OUT]', fn, len(t))
    io.open(os.path.join(out, '_hash.txt'), 'w', encoding='utf-8').write('BASE_A %r\nBASE_B %r\nFINAL %r\nBUILT %s\n' % (a, b, f, at))
    print('A', a, 'B', b, 'FINAL', f)


if __name__ == '__main__':
    main(sys.argv[1])
