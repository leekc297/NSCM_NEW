# -*- coding: utf-8 -*-
"""SHIP_PLAN_40 배치 3개 SP 속도 보완 클라우드 이관 패키지 생성 (E20261126-DS2, E20261126-BALCUM)
원문 기준 = 실행 때 ZIOUI1 ALL_SOURCE 새로 조회. 사내 적용본(TOBE)이 DB 원문과 같아야 생성함(FRESH-GATE)
  python build_package.py <출력폴더>
"""
import sys, os, io, re, datetime
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn

W = os.path.dirname(os.path.abspath(__file__))
SHIP, BAL, MAIL = 'PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40'
SPS = [SHIP, BAL, MAIL]
ZB = {SHIP: 'ZB_SSP40_SHIP_20261126', BAL: 'ZB_SSP40_BAL_20261126', MAIL: 'ZB_SSP40_MAIL_20261126'}
DS1 = "    /* [E20261126-DS2] GTT(통계 없음) 행 수 추정용. 클라우드 optimizer_dynamic_sampling = 0 (2026-11-26 확인) */"
DS2 = "    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';"
HEAD_SCHEMA = 'ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;'


def rd(p):
    return io.open(p, encoding='utf-8', newline='').read()


def fetch(c, n):
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = :1 AND TYPE = 'PROCEDURE' ORDER BY LINE", [n])
    return ''.join(r[0] for r in c.fetchall())


def stamp(c, n, at):
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = :1 AND OBJECT_TYPE = 'PROCEDURE'", [n])
    return '-- SOURCE-FRESH: SCM_MGR.%s PROCEDURE LAST_DDL=%s FETCHED=%s DB=ZIOUI1' % (n, c.fetchone()[0], at)


def split_lines(text):
    return re.findall(r'[^\n]*\n|[^\n]+$', text)


def lines_hash(c, text):
    """ALL_SOURCE 와 같은 줄 단위 SUM(ORA_HASH(TEXT)) 를 DB 에서 계산"""
    parts = split_lines(text)   # ALL_SOURCE 줄 = LF 까지
    tot = 0
    for i in range(0, len(parts), 500):   # 500줄씩 1회 왕복
        grp = parts[i:i + 500]
        sql = ' UNION ALL '.join('SELECT ORA_HASH(:%d) AS H FROM DUAL' % (k + 1) for k in range(len(grp)))
        c.execute('SELECT SUM(H) FROM (' + sql + ')', grp); tot += c.fetchone()[0] or 0
    return len(parts), tot


def ds_patch(n):
    return '''/* %(n)s : 본문 BEGIN 다음 줄에 dynamic_sampling 2 세션 설정 2줄 추가 (E20261126-DS2)
 * 클라우드 원문(ALL_SOURCE, OWNER SCM_MGR) 위에 넣음(다른 줄 그대로). 이미 있으면 SKIP. 0열 BEGIN 줄이 없으면 중단(원문 무변경).
 * 컴파일 실패면 원문으로 되돌리고 오류. SCM_MGR 접속, 전체 실행(F5). Output 창 문구 확인 */
SET SERVEROUTPUT ON SIZE UNLIMITED
%(hs)s
DECLARE
    c_name CONSTANT VARCHAR2(128) := '%(n)s';
    v_new  CLOB;
    v_old  CLOB;
    v_ins  BOOLEAN := FALSE;
    v_has  NUMBER;
    v_nl   VARCHAR2(2);
    v_st   VARCHAR2(30);
    PROCEDURE ap(c IN OUT NOCOPY CLOB, t VARCHAR2) IS
    BEGIN
        IF t IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(t), t); END IF;
    END;
BEGIN
    SELECT COUNT(*) INTO v_has FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE' AND INSTR(TEXT, 'E20261126-DS2') > 0;
    IF v_has > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  ' || c_name || ' 이미 반영됨(E20261126-DS2)');
        RETURN;
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_old, TRUE);
    ap(v_new, 'CREATE OR REPLACE ');
    ap(v_old, 'CREATE OR REPLACE ');
    FOR r IN (SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE' ORDER BY LINE) LOOP
        ap(v_new, r.TEXT);
        ap(v_old, r.TEXT);
        IF NOT v_ins AND REGEXP_LIKE(r.TEXT, '^BEGIN[[:space:]]*$') THEN
            v_nl := CASE WHEN INSTR(r.TEXT, CHR(13)) > 0 THEN CHR(13) || CHR(10) ELSE CHR(10) END;
            ap(v_new, q'~%(d1)s~' || v_nl);
            ap(v_new, q'~%(d2)s~' || v_nl);
            v_ins := TRUE;
        END IF;
    END LOOP;
    IF NOT v_ins THEN
        RAISE_APPLICATION_ERROR(-20011, c_name || ' : 0열 BEGIN 줄 없음. 원문 무변경. 클라우드 원문 전달 필요');
    END IF;
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
''' % dict(n=n, hs=HEAD_SCHEMA, d1=DS1, d2=DS2)


def chunks(text, size=30000):
    out, cur = [], ''
    for ln in split_lines(text):
        if len((cur + ln).encode('utf-8')) > size and cur:   # PL/SQL 문자 상수 32767 바이트 이하
            out.append(cur); cur = ''
        cur += ln
    if cur:
        out.append(cur)
    for x in out:
        assert "~'" not in x
    return out


def bal_replace(tobe, asis_lines, asis_hash):
    body = '\n'.join("    ap(v_new, q'~%s~');" % ch for ch in chunks(tobe))
    return '''/* %(n)s : 1단계 INSP_WIP, 3단계 WH_STOCK 행마다 재조회를 누적합으로 (E20261126-BALCUM) + dynamic_sampling 2 (E20261126-DS2)
 * 클라우드 원문이 사내 기준본과 같을 때만(줄 수 %(al)d, SUM(ORA_HASH(TEXT)) %(ah)d) 사내 적용본으로 교체.
 * 이미 반영(두 표식 있음)이면 SKIP. 원문이 다르면 -20011 로 중단(원문 무변경). 컴파일 실패면 원문 복원.
 * SCM_MGR 접속, 전체 실행(F5). Output 창 문구 확인 */
SET SERVEROUTPUT ON SIZE UNLIMITED
%(hs)s
DECLARE
    c_name CONSTANT VARCHAR2(128) := '%(n)s';
    v_new  CLOB;
    v_old  CLOB;
    v_cnt  NUMBER;
    v_hash NUMBER;
    v_m1   NUMBER;
    v_m2   NUMBER;
    v_st   VARCHAR2(30);
    PROCEDURE ap(c IN OUT NOCOPY CLOB, t VARCHAR2) IS
    BEGIN
        IF t IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(t), t); END IF;
    END;
BEGIN
    SELECT COUNT(*), SUM(ORA_HASH(TEXT))
         , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-BALCUM') > 0 THEN 1 END)
         , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-DS2') > 0 THEN 1 END)
      INTO v_cnt, v_hash, v_m1, v_m2
      FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE';
    IF v_m1 > 0 AND v_m2 > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  ' || c_name || ' 이미 반영됨');
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
''' % dict(n=BAL, al=asis_lines, ah=asis_hash, hs=HEAD_SCHEMA, body=body)


def backup_sql():
    out = ['/* 현재 클라우드 3개 SP 원문을 보관 표에 저장 (표가 이미 있으면 SKIP). 원복(99) 기준본 */',
           'SET SERVEROUTPUT ON', HEAD_SCHEMA]
    for n in SPS:
        out.append("""BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.%(t)s AS SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER = ''SCM_MGR'' AND NAME = ''%(n)s'' AND TYPE = ''PROCEDURE''';
    DBMS_OUTPUT.PUT_LINE('> BACKUP %(t)s 생성');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN DBMS_OUTPUT.PUT_LINE('> SKIP   %(t)s 이미 있음');
        ELSE RAISE; END IF;
END;
/""" % dict(t=ZB[n], n=n))
    out.append('SELECT \'%s\' AS NAME, COUNT(*) AS BACKUP_LINES FROM %s\nUNION ALL SELECT \'%s\', COUNT(*) FROM %s\nUNION ALL SELECT \'%s\', COUNT(*) FROM %s;'
               % (SHIP, ZB[SHIP], BAL, ZB[BAL], MAIL, ZB[MAIL]))
    return '\n'.join(out) + '\n'


def rollback_sql():
    out = ['/* 원복 : 05 보관 표 원문으로 3개 SP 되돌림 (문제 있을 때만). 보관 표가 없으면 그 SP 는 건너뜀 */',
           'SET SERVEROUTPUT ON SIZE UNLIMITED', HEAD_SCHEMA]
    for n in SPS:
        out.append('''DECLARE
    v    CLOB;
    v_st VARCHAR2(30);
    v_n  NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_n FROM ALL_TABLES WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = '%(t)s';
    IF v_n = 0 THEN DBMS_OUTPUT.PUT_LINE('> SKIP %(n)s 보관 표 없음'); RETURN; END IF;
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
    DBMS_LOB.WRITEAPPEND(v, LENGTH('CREATE OR REPLACE '), 'CREATE OR REPLACE ');
    FOR r IN (SELECT TEXT FROM SCM_MGR.%(t)s ORDER BY LINE) LOOP
        IF r.TEXT IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT); END IF;
    END LOOP;
    BEGIN EXECUTE IMMEDIATE v; EXCEPTION WHEN OTHERS THEN NULL; END;
    SELECT STATUS INTO v_st FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = '%(n)s' AND OBJECT_TYPE = 'PROCEDURE';
    DBMS_OUTPUT.PUT_LINE('> ROLLBACK %(n)s · ' || v_st);
END;
/''' % dict(t=ZB[n], n=n))
    return '\n'.join(out) + '\n'


def precheck_sql(vers):
    corp = '\n  UNION ALL '.join("SELECT '%s' AS NAME, %d AS CORP_LINES, %d AS CORP_HASH FROM DUAL" % (n, k, h) for n, k, h in vers)
    return '''/* 사전 확인 (조회만). 결과를 보고 10 ~ 20 실행 여부 판단 */
%(hs)s
/* [P1] 원문 판 : BALANCE 는 SAME_AS_CORP_ASIS = Y 여야 20 이 적용됨. SHIP_PLAN_40, MAIL 은 판과 무관하게 10, 11 적용 */
WITH CORP AS (
  %(corp)s
)
SELECT CORP.NAME
     , (SELECT MAX(O.STATUS) FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = CORP.NAME AND O.OBJECT_TYPE = 'PROCEDURE') AS STATUS
     , (SELECT TO_CHAR(MAX(O.LAST_DDL_TIME), 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = CORP.NAME AND O.OBJECT_TYPE = 'PROCEDURE') AS LAST_DDL_TIME
     , S.CLOUD_LINES
     , CORP.CORP_LINES
     , CASE WHEN S.CLOUD_LINES = CORP.CORP_LINES AND S.CLOUD_HASH = CORP.CORP_HASH THEN 'Y' ELSE 'N' END AS SAME_AS_CORP_ASIS
     , S.MARK_DS2
     , S.MARK_BALCUM
     , S.BEGIN_COL0
  FROM CORP
  LEFT JOIN (SELECT NAME
                  , COUNT(*) AS CLOUD_LINES
                  , SUM(ORA_HASH(TEXT)) AS CLOUD_HASH
                  , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-DS2') > 0 THEN 1 END) AS MARK_DS2
                  , COUNT(CASE WHEN INSTR(TEXT, 'E20261126-BALCUM') > 0 THEN 1 END) AS MARK_BALCUM
                  , COUNT(CASE WHEN REGEXP_LIKE(TEXT, '^BEGIN[[:space:]]*$') THEN 1 END) AS BEGIN_COL0
               FROM ALL_SOURCE
              WHERE OWNER = 'SCM_MGR'
                AND TYPE = 'PROCEDURE'
              GROUP BY NAME) S
    ON S.NAME = CORP.NAME
 ORDER BY CORP.NAME;

/* [P2] 지금 3개 SP 를 실행 중인 세션. 0행일 때 진행 (실행 중이면 교체가 끝나지 않고 대기함) */
SELECT S.SID, S.SERIAL#, S.USERNAME, S.MODULE, S.STATUS, S.SQL_ID, S.LAST_CALL_ET
  FROM GV$SESSION S
 WHERE S.PLSQL_ENTRY_OBJECT_ID IN (SELECT O.OBJECT_ID FROM ALL_OBJECTS O
                                    WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME IN ('%(a)s', '%(b)s', '%(c)s')
                                      AND O.OBJECT_TYPE = 'PROCEDURE');
''' % dict(hs=HEAD_SCHEMA, corp=corp, a=SHIP, b=BAL, c=MAIL)


def verify_sql(tobe_vers):
    exp = ' · '.join('%s %d줄' % (n, k) for n, k, h in tobe_vers)
    return '''/* 확인 (조회만) : VALID, 오류 0, 표식 수. 사내 적용본 기준 줄 수 : %(exp)s
 * MAIL 은 클라우드 원문이 사내와 달라 줄 수가 다를 수 있음(클라우드 원문 + 2줄) */
%(hs)s
SELECT O.OBJECT_NAME
     , O.STATUS
     , TO_CHAR(O.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL_TIME
     , (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER = 'SCM_MGR' AND E.NAME = O.OBJECT_NAME) AS ERR_CNT
     , (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER = 'SCM_MGR' AND S.NAME = O.OBJECT_NAME AND S.TYPE = 'PROCEDURE') AS LINE_CNT
     , (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER = 'SCM_MGR' AND S.NAME = O.OBJECT_NAME AND S.TYPE = 'PROCEDURE' AND INSTR(S.TEXT, 'E20261126-DS2') > 0) AS MARK_DS2
     , (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER = 'SCM_MGR' AND S.NAME = O.OBJECT_NAME AND S.TYPE = 'PROCEDURE' AND INSTR(S.TEXT, 'E20261126-BALCUM') > 0) AS MARK_BALCUM
  FROM ALL_OBJECTS O
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME IN ('%(a)s', '%(b)s', '%(c)s')
   AND O.OBJECT_TYPE = 'PROCEDURE'
 ORDER BY O.OBJECT_NAME;
/* 기대값 : STATUS VALID, ERR_CNT 0, MARK_DS2 = 1(BALANCE 1), MARK_BALCUM = BALANCE 만 7
 * 속도 확인 : 다음 회차 실행 뒤 BATCH_속도점검_SHIP_PLAN_40_3SP_실행일회차 쿼리 [C4] [C8] 재조회 */
''' % dict(exp=exp, hs=HEAD_SCHEMA, a=SHIP, b=BAL, c=MAIL)


def main(out):
    cx = dbconn.connect('tobe'); c = cx.cursor()
    c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') FROM DUAL"); at = c.fetchone()[0]
    asis, tobe = {}, {}
    for n in SPS:
        asis[n] = rd(os.path.join(W, n + '.ASIS.sql')); tobe[n] = rd(os.path.join(W, n + '.TOBE.sql'))
        # FRESH-GATE : 사내 DB 원문 == 착수 기준본(ASIS, 적용 전) 또는 사내 적용본(TOBE, 적용 후). 그 밖이면 다른 변경이 끼어든 것
        now = fetch(c, n)
        assert now in (asis[n], tobe[n]), 'FRESH-GATE 실패 : %s 사내 DB 원문이 기준본, 적용본 어느 것과도 다름. 중단' % n
        print('FRESH-GATE', n, 'DB = ' + ('ASIS' if now == asis[n] else 'TOBE'))
    av = [(n,) + lines_hash(c, asis[n]) for n in SPS]
    tv = [(n,) + lines_hash(c, tobe[n]) for n in SPS]
    os.makedirs(os.path.join(out, 'A_DB'), exist_ok=True)
    st = {n: stamp(c, n, at) for n in SPS}
    files = {
        '00_PRECHECK.sql': precheck_sql(av),
        '05_BACKUP.sql': backup_sql(),
        '10_PATCH_DS2_%s.sql' % SHIP: st[SHIP] + '\n' + ds_patch(SHIP),
        '11_PATCH_DS2_%s.sql' % MAIL: st[MAIL] + '\n' + ds_patch(MAIL),
        '20_REPLACE_%s.sql' % BAL: st[BAL] + '\n' + bal_replace(tobe[BAL], av[1][1], av[1][2]),
        '90_VERIFY.sql': verify_sql(tv),
        '99_ROLLBACK.sql': rollback_sql(),
    }
    for f, t in files.items():
        io.open(os.path.join(out, 'A_DB', f), 'w', encoding='utf-8', newline='\n').write(t)
        print('[OUT]', f, len(t))
    io.open(os.path.join(out, '_hash.txt'), 'w', encoding='utf-8').write('ASIS %r\nTOBE %r\nBUILT %s\n' % (av, tv, at))
    print('ASIS', av); print('TOBE', tv)


if __name__ == '__main__':
    main(sys.argv[1])
