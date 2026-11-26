# -*- coding: utf-8 -*-
"""
DMF0045 W/H BOH 보완 클라우드 전용 패치 생성기
  - 사내 ZIOUI1 ALL_SOURCE 를 새로 읽어 보완 구간(E20261125-BOHONCE)을 추출한다(FRESH-GATE: 사내 원문 == 적용본 TOBE).
  - 클라우드 본문은 사내와 줄 수가 달라(2436 / 2399) 전체 대조 패치가 중단되므로,
    줄 단위(주석·공백 무시) 17줄 일치 구간 1건만 바꾸는 PL/SQL 을 만든다.
"""
import os, sys, time, oracledb
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora

HERE = os.path.dirname(os.path.abspath(__file__))
STAMP = time.strftime('%Y%m%d_%H%M')
PKG_DIR = os.path.join(r'C:\Projects\NSCM\_artifacts\_deploy_packages', 'DMF0045_CLOUD_BOH_PATCH_20261125_1433')

OLD_NORM = [
    "FROM SSP_DNM_ESS_PACKER_STOCK_V A",
    ", SCM_MST_SITE B",
    ", SCP_MST_FINAL_ITEM C",
    ", (SELECT DIVISION_ID",
    ", SITE_ID",
    ", MAX(CUTOFF_DATE) AS MAX_CUTOFF_DATE",
    "FROM SSP_DNM_ESS_PACKER_STOCK_V",
    "WHERE DIVISION_ID = V_DIVISION_ID",
    "AND CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')",
    "AND CUTOFF_DATE <= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD')",
    "GROUP BY DIVISION_ID",
    ", SITE_ID",
    ") XA",
    "WHERE A.DIVISION_ID = XA.DIVISION_ID",
    "AND A.SITE_ID = XA.SITE_ID",
    "AND A.CUTOFF_DATE = XA.MAX_CUTOFF_DATE",
    "AND A.CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')",
]


def main():
    u, p, d = ora.conn_info()
    cx = oracledb.connect(user=u, password=p, dsn=d); cx.call_timeout = 60000
    cur = cx.cursor()
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' "
                "AND OBJECT_NAME='PKG_DMF0045' AND OBJECT_TYPE='PACKAGE BODY'")
    last_ddl = cur.fetchone()[0]
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0045' "
                "AND TYPE='PACKAGE BODY' ORDER BY LINE")
    lines = [r[0] for r in cur.fetchall()]
    now = ''.join(lines)
    tobe = open(os.path.join(HERE, 'PKG_DMF0045_BODY.TOBE.sql'), encoding='utf-8', newline='').read()
    # FRESH-GATE: 사내 현재 원문 == 사내 적용본
    assert ('CREATE OR REPLACE ' + now) in tobe, 'FRESH-GATE 실패: 사내 원문이 적용본과 다름'
    k = [i for i, l in enumerate(lines) if 'E20261125-BOHONCE' in l]
    assert len(k) == 1
    s = k[0]
    e = next(i for i in range(s, s + 30) if 'A.CUTOFF_DATE      = A.MAX_CUTOFF_DATE' in lines[i])
    new_block = [l.replace('\r', '').rstrip('\n') for l in lines[s:e + 1]]
    assert len(new_block) == 18, len(new_block)
    fetched = time.strftime('%Y-%m-%d %H:%M')
    stamp = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0045 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1\n"

    os.makedirs(PKG_DIR, exist_ok=True)
    W = lambda n, t: open(os.path.join(PKG_DIR, n), 'w', encoding='utf-8', newline='\n').write(t)

    old_arr = '\n'.join(f"    v_old({i + 1}) := q'~{t}~';" for i, t in enumerate(OLD_NORM))
    new_txt = '\n'.join(new_block)

    W('20_PATCH_PKG_DMF0045_BOH.sql', stamp + f"""/* DMF0045 W/H BOH 82 사업부 부분 : 재고 뷰 1회 읽기 (E20261125-BOHONCE)
 * 클라우드 PKG_DMF0045 PACKAGE BODY 에서 아래 17줄(주석·공백 무시 비교) 구간 1건만 바꿈.
 * 이미 바뀌었으면 SKIP · 구간 1건 아니면 중단(원문 무변경) · 컴파일 실패면 원문 복원.
 * SCM_MGR 로 접속해 전체 실행(F5). Output 창에서 SKIP / APPLY / 중단 문구 확인. */
SET SERVEROUTPUT ON SIZE UNLIMITED
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
DECLARE
    TYPE t_txt IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    v_src   t_txt;
    v_old   t_txt;
    v_n     PLS_INTEGER := 0;
    v_hit   PLS_INTEGER := 0;
    v_at    PLS_INTEGER := 0;
    v_ok    BOOLEAN;
    v_orig  CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_new_block CONSTANT VARCHAR2(32767) := q'~{new_txt}~';
    FUNCTION nz(p VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN TRIM(REGEXP_REPLACE(REGEXP_REPLACE(REPLACE(REPLACE(p, CHR(13)), CHR(10)), '/\\*.*?\\*/', ''), '\\s+', ' '));
    END;
    PROCEDURE ap(c IN OUT NOCOPY CLOB, t VARCHAR2) IS
    BEGIN
        IF t IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(t), t); END IF;
    END;
BEGIN
{old_arr}

    FOR r IN (SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        v_n := v_n + 1;
        v_src(v_n) := r.TEXT;
        IF INSTR(r.TEXT, 'E20261125-BOHONCE') > 0 THEN
            DBMS_OUTPUT.PUT_LINE('> SKIP  PKG_DMF0045 BODY - 이미 보완됨(' || r.LINE || '줄) · 원문 무변경');
            RETURN;
        END IF;
    END LOOP;
    IF v_n = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 - 클라우드에 PKG_DMF0045 PACKAGE BODY 없음');
    END IF;

    FOR i IN 1 .. v_n - v_old.COUNT + 1 LOOP
        v_ok := TRUE;
        FOR j IN 1 .. v_old.COUNT LOOP
            IF NVL(nz(v_src(i + j - 1)), '~') <> v_old(j) THEN v_ok := FALSE; EXIT; END IF;
        END LOOP;
        IF v_ok THEN v_hit := v_hit + 1; v_at := i; END IF;
    END LOOP;
    IF v_hit <> 1 THEN
        RAISE_APPLICATION_ERROR(-20011, '중단 - 보완 대상 17줄 구간 ' || v_hit || '건(1 기대) · 원문 무변경 · 결과 회신 바람');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> FOUND 보완 구간 ' || v_at || '~' || (v_at + v_old.COUNT - 1) || '줄');

    DBMS_LOB.CREATETEMPORARY(v_orig, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    ap(v_orig, 'CREATE OR REPLACE ');
    ap(v_new, 'CREATE OR REPLACE ');
    FOR i IN 1 .. v_n LOOP
        IF i = 1 THEN
            /* 현재 스키마와 관계없이 SCM_MGR 소유 PKG 를 교체 (클라우드 CURRENT_SCHEMA=FP_MGR 에서 ORA-01031) */
            v_src(1) := REGEXP_REPLACE(v_src(1), '^\\s*PACKAGE\\s+BODY\\s+"?PKG_DMF0045"?', 'PACKAGE BODY SCM_MGR.PKG_DMF0045', 1, 1, 'i');
        END IF;
        ap(v_orig, v_src(i));
        IF i = v_at THEN
            ap(v_new, v_new_block || CHR(10));
        ELSIF i > v_at AND i < v_at + v_old.COUNT THEN
            NULL;
        ELSE
            ap(v_new, v_src(i));
        END IF;
    END LOOP;

    EXECUTE IMMEDIATE v_new;

    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0045' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR ' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE v_orig;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20013, 'PKG_DMF0045 BODY 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') -> 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PKG_DMF0045 BODY - 보완 구간 교체 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
""")

    W('00_CHECK_RUNNING.sql', stamp + """/* 적용 전 확인 : DMF0045 조회가 돌고 있으면 PKG 교체가 대기함. 0행일 때 20 실행. (V$ 조회 권한 필요) */
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
SELECT S.SID, S.SERIAL#, S.USERNAME, S.MACHINE, S.STATUS, S.LAST_CALL_ET AS CALL_SEC, Q.PROGRAM_LINE# AS PROGRAM_LINE
  FROM V$SESSION S, V$SQL Q
 WHERE S.SQL_ID = Q.SQL_ID
   AND S.SQL_CHILD_NUMBER = Q.CHILD_NUMBER
   AND S.STATUS = 'ACTIVE'
   AND Q.PROGRAM_ID IN (SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0045');
/* 멈출 세션이 있으면 : ALTER SYSTEM CANCEL SQL '<SID>, <SERIAL#>'; (DBA 권한) */
""")

    W('05_BACKUP_PKG_DMF0045.sql', stamp + """/* 현재 클라우드 PKG_DMF0045 BODY 원문을 ZB_DMF0045_BODY_20261125 표에 보관 (이미 있으면 SKIP) */
SET SERVEROUTPUT ON
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.ZB_DMF0045_BODY_20261125 AS SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME = ''PKG_DMF0045'' AND TYPE = ''PACKAGE BODY''';
    DBMS_OUTPUT.PUT_LINE('> BACKUP ZB_DMF0045_BODY_20261125 생성');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN DBMS_OUTPUT.PUT_LINE('> SKIP  ZB_DMF0045_BODY_20261125 이미 있음');
        ELSE RAISE; END IF;
END;
/
SELECT COUNT(*) AS BACKUP_LINES FROM ZB_DMF0045_BODY_20261125;
""")

    W('90_VERIFY.sql', stamp + """/* 확인 : VALID · 오류 0 · 보완 표시 1줄 · 줄 수 (클라우드 종전 2436줄 → 2437줄) */
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL_TIME
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0045' ORDER BY OBJECT_TYPE;
SELECT COUNT(*) AS ERR_CNT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0045';
SELECT COUNT(*) AS LINE_CNT
     , COUNT(CASE WHEN INSTR(TEXT, 'E20261125-BOHONCE') > 0 THEN 1 END) AS MARK_CNT
  FROM USER_SOURCE WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY';
/* 속도 확인 : DMF0045_CLOUD_QUERY_CHECK_20261125.sql 3번(조회 1회 실행)을 다시 실행해 PROC_SEC 회신 */
""")

    W('99_ROLLBACK_PKG_DMF0045.sql', """/* 원복 : ZB_DMF0045_BODY_20261125 보관본으로 PKG_DMF0045 BODY 되돌림 (문제 있을 때만) */
SET SERVEROUTPUT ON
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
DECLARE
    v CLOB;
    v_st VARCHAR2(30);
BEGIN
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
    DBMS_LOB.WRITEAPPEND(v, LENGTH('CREATE OR REPLACE '), 'CREATE OR REPLACE ');
    FOR r IN (SELECT LINE, TEXT FROM SCM_MGR.ZB_DMF0045_BODY_20261125 ORDER BY LINE) LOOP
        IF r.LINE = 1 THEN
            DBMS_LOB.WRITEAPPEND(v, LENGTH('PACKAGE BODY SCM_MGR.PKG_DMF0045' || CHR(10)), 'PACKAGE BODY SCM_MGR.PKG_DMF0045' || CHR(10));
        ELSE
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END IF;
    END LOOP;
    EXECUTE IMMEDIATE v;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0045' AND OBJECT_TYPE = 'PACKAGE BODY';
    DBMS_OUTPUT.PUT_LINE('> ROLLBACK PKG_DMF0045 BODY · ' || v_st);
END;
/
""")
    print('OK', PKG_DIR, 'new_block', len(new_block))


if __name__ == '__main__':
    main()
