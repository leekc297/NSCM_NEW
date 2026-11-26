# -*- coding: utf-8 -*-
"""E20261126-OWMSMAX 클라우드 이관 패키지 생성. python build_package_owmsmax.py <출력폴더>
FRESH-GATE : 사내 DB 원문 == ASIS(착수 기준본) 또는 TOBE(사내 적용본)일 때만 생성
"""
import sys, os, io
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
sys.path.insert(0, r'c:\Projects\NSCM\_artifacts\_apply_corporate\SHIP_PLAN_40_3SP_PERF_20261126')
import dbconn
from build_package import lines_hash, chunks, fetch, stamp
from build_owmsmax import N, MARK, ZB, HS, rd

W = os.path.dirname(os.path.abspath(__file__))


def replace_sql(tobe, al, ah):
    body = '\n'.join("    ap(v_new, q'~%s~');" % ch for ch in chunks(tobe))
    return '''/* %(n)s : 1-1 단계 '가장 최근 CUTOFF' MAX 조회의 함수 조건을 스칼라 서브쿼리로 감쌈 (%(mk)s)
 * 클라우드 원문이 사내 기준본과 같을 때만(줄 수 %(al)d, SUM(ORA_HASH(TEXT)) %(ah)d) 사내 적용본으로 교체.
 * 사내 기준본 = 패키지 SSP_SHIP_PLAN_40_BATCH_PERF_CLOUD_20261126 적용본. 이미 반영(표식 있음)이면 SKIP.
 * 원문이 다르면 -20011 로 중단(원문 무변경). 컴파일 실패면 원문 복원(-20012). SCM_MGR 접속, 전체 실행(F5). Output 창 문구 확인 */
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
    SELECT COUNT(*), SUM(ORA_HASH(TEXT)), COUNT(CASE WHEN INSTR(TEXT, '%(mk)s') > 0 THEN 1 END)
      INTO v_cnt, v_hash, v_mk
      FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE';
    IF v_mk > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  ' || c_name || ' 이미 반영됨(%(mk)s)');
        RETURN;
    END IF;
    IF v_cnt <> %(al)d OR v_hash <> %(ah)d THEN
        RAISE_APPLICATION_ERROR(-20011, c_name || ' : 클라우드 원문이 사내 기준본과 다름(줄 ' || v_cnt || ', 해시 ' || v_hash || '). 원문 무변경. 클라우드 원문 전달 필요');
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
    DBMS_OUTPUT.PUT_LINE('> APPLY ' || c_name || ' · ' || v_st);
END;
/
''' % dict(n=N, mk=MARK, al=al, ah=ah, hs=HS, body=body)


def precheck_sql(al, ah):
    return '''/* 사전 확인 (조회만) */
%(hs)s
/* [P1] SAME_AS_CORP_BASE = Y 여야 20 이 적용됨. MARK_OWMSMAX = 1 이면 이미 반영(20 은 SKIP) */
SELECT S.NAME
     , (SELECT MAX(O.STATUS) FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = S.NAME AND O.OBJECT_TYPE = 'PROCEDURE') AS STATUS
     , (SELECT TO_CHAR(MAX(O.LAST_DDL_TIME), 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = S.NAME AND O.OBJECT_TYPE = 'PROCEDURE') AS LAST_DDL_TIME
     , S.CLOUD_LINES
     , %(al)d AS CORP_LINES
     , CASE WHEN S.CLOUD_LINES = %(al)d AND S.CLOUD_HASH = %(ah)d THEN 'Y' ELSE 'N' END AS SAME_AS_CORP_BASE
     , S.MARK_DS2
     , S.MARK_OWMSMAX
  FROM (SELECT NAME
             , COUNT(*) AS CLOUD_LINES
             , SUM(ORA_HASH(TEXT)) AS CLOUD_HASH
             , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-DS2') > 0 THEN 1 END) AS MARK_DS2
             , COUNT(CASE WHEN INSTR(TEXT, '%(mk)s') > 0 THEN 1 END) AS MARK_OWMSMAX
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
''' % dict(hs=HS, al=al, ah=ah, mk=MARK, n=N)


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
    return '''/* 원복 : 05 보관 표 원문으로 %(n)s 되돌림 (문제 있을 때만). 되돌린 뒤에도 E20261126-DS2 는 남음(05 시점 원문) */
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


def verify_sql(tl, th):
    return '''/* 확인 (조회만). 기대값 : STATUS VALID, ERR_CNT 0, LINE_CNT %(tl)d, SAME_AS_CORP_TOBE Y, MARK_DS2 1, MARK_OWMSMAX 1 */
%(hs)s
SELECT O.OBJECT_NAME
     , O.STATUS
     , TO_CHAR(O.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL_TIME
     , (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER = 'SCM_MGR' AND E.NAME = O.OBJECT_NAME) AS ERR_CNT
     , S.LINE_CNT
     , CASE WHEN S.LINE_CNT = %(tl)d AND S.H = %(th)d THEN 'Y' ELSE 'N' END AS SAME_AS_CORP_TOBE
     , S.MARK_DS2
     , S.MARK_OWMSMAX
  FROM ALL_OBJECTS O
     , (SELECT COUNT(*) AS LINE_CNT
             , SUM(ORA_HASH(TEXT)) AS H
             , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-DS2') > 0 THEN 1 END) AS MARK_DS2
             , COUNT(CASE WHEN INSTR(TEXT, '%(mk)s') > 0 THEN 1 END) AS MARK_OWMSMAX
          FROM ALL_SOURCE
         WHERE OWNER = 'SCM_MGR' AND NAME = '%(n)s' AND TYPE = 'PROCEDURE') S
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME = '%(n)s'
   AND O.OBJECT_TYPE = 'PROCEDURE';
''' % dict(hs=HS, tl=tl, th=th, mk=MARK, n=N)


def main(out):
    cx = dbconn.connect('tobe'); c = cx.cursor()
    c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') FROM DUAL"); at = c.fetchone()[0]
    asis = rd(os.path.join(W, N + '.ASIS.sql')); tobe = rd(os.path.join(W, N + '.TOBE.sql'))
    now = fetch(c, N)
    assert now in (asis, tobe), 'FRESH-GATE 실패 : 사내 원문이 기준본, 적용본 어느 것과도 다름'
    print('FRESH-GATE DB =', 'ASIS' if now == asis else 'TOBE')
    al, ah = lines_hash(c, asis); tl, th = lines_hash(c, tobe)
    os.makedirs(os.path.join(out, 'A_DB'), exist_ok=True)
    files = {
        '00_PRECHECK.sql': precheck_sql(al, ah),
        '05_BACKUP.sql': backup_sql(),
        '20_REPLACE_%s.sql' % N: stamp(c, N, at) + '\n' + replace_sql(tobe, al, ah),
        '90_VERIFY.sql': verify_sql(tl, th),
        '99_ROLLBACK.sql': rollback_sql(),
    }
    for f, t in files.items():
        io.open(os.path.join(out, 'A_DB', f), 'w', encoding='utf-8', newline='\n').write(t)
        print('[OUT]', f, len(t))
    io.open(os.path.join(out, '_hash.txt'), 'w', encoding='utf-8').write('ASIS (%d, %d)\nTOBE (%d, %d)\nBUILT %s\n' % (al, ah, tl, th, at))
    print('ASIS', al, ah, 'TOBE', tl, th)


if __name__ == '__main__':
    main(sys.argv[1])
