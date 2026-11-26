# -*- coding: utf-8 -*-
"""
DMF0045 W/H BOH 보완 클라우드 패키지 2판 (PL/SQL 안 DDL 실행 없음)
  클라우드 20_PATCH 의 EXECUTE IMMEDIATE 가 ORA-01031(2026-11-25 14:4x 회신)이라,
  보완된 PKG 생성 문장을 DBMS_OUTPUT 으로 출력만 하고 사용자가 그 출력을 일반 스크립트로 실행한다.
  사내 ZIOUI1 ALL_SOURCE 재조회 · FRESH-GATE(사내 원문 == 적용본) 후 보완 구간 18줄을 넣는다.
"""
import os, sys, time, oracledb
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora

HERE = os.path.dirname(os.path.abspath(__file__))
PKG_DIR = r'C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0045_CLOUD_BOH_PATCH_20261125_1433'
sys.path.insert(0, HERE)
from build_cloud_patch import OLD_NORM  # noqa: E402


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
    tobe = open(os.path.join(HERE, 'PKG_DMF0045_BODY.TOBE.sql'), encoding='utf-8', newline='').read()
    # FRESH-GATE: 사내 현재 원문 == 사내 적용본
    assert ('CREATE OR REPLACE ' + ''.join(lines)) in tobe, 'FRESH-GATE 실패'
    s = [i for i, l in enumerate(lines) if 'E20261125-BOHONCE' in l][0]
    e = next(i for i in range(s, s + 30) if 'A.CUTOFF_DATE      = A.MAX_CUTOFF_DATE' in lines[i])
    new_block = [l.replace('\r', '').rstrip('\n') for l in lines[s:e + 1]]
    assert len(new_block) == 18
    stamp = (f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0045 PACKAGE BODY LAST_DDL={last_ddl} "
             f"FETCHED={time.strftime('%Y-%m-%d %H:%M')} DB=ZIOUI1\n")
    old_arr = '\n'.join(f"    v_old({i + 1}) := q'~{t}~';" for i, t in enumerate(OLD_NORM))
    new_arr = '\n'.join(f"    v_blk({i + 1}) := q'~{t}~';" for i, t in enumerate(new_block))

    def printer(patch):
        what = '보완본' if patch else '현재 원문(원복용)'
        return stamp + f"""/* DMF0045 PKG_DMF0045 BODY {what} 생성 문장 출력 (DDL 실행 없음 · 조회만)
 * 1) 이 파일 전체 실행(F5)
 * 2) 출력(Dbms Output 또는 Script Output)에서 'CREATE OR REPLACE PACKAGE BODY' 줄부터 마지막 '/' 줄까지 복사
 * 3) 새 워크시트에 붙여 전체 실행(F5) 또는 DBA 에게 전달 (SCM_MGR 소유 PKG 생성 권한 필요) */
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET FEEDBACK OFF
DECLARE
    TYPE t_txt IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    v_src  t_txt;
    v_old  t_txt;
    v_blk  t_txt;
    v_n    PLS_INTEGER := 0;
    v_hit  PLS_INTEGER := 0;
    v_at   PLS_INTEGER := 0;
    v_ok   BOOLEAN;
    c_patch CONSTANT BOOLEAN := {'TRUE' if patch else 'FALSE'};
    FUNCTION nz(p VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN TRIM(REGEXP_REPLACE(REGEXP_REPLACE(REPLACE(REPLACE(p, CHR(13)), CHR(10)), '/\\*.*?\\*/', ''), '\\s+', ' '));
    END;
    PROCEDURE pl(p VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(RTRIM(REPLACE(REPLACE(p, CHR(13)), CHR(10))));
    END;
BEGIN
{old_arr}
{new_arr}
    FOR r IN (SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        v_n := v_n + 1;
        v_src(v_n) := r.TEXT;
        IF c_patch AND INSTR(r.TEXT, 'E20261125-BOHONCE') > 0 THEN
            DBMS_OUTPUT.PUT_LINE('-- SKIP 이미 보완됨(' || r.LINE || '줄). 실행할 문장 없음');
            RETURN;
        END IF;
    END LOOP;
    IF v_n = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 - SCM_MGR.PKG_DMF0045 PACKAGE BODY 없음');
    END IF;
    IF c_patch THEN
        FOR i IN 1 .. v_n - v_old.COUNT + 1 LOOP
            v_ok := TRUE;
            FOR j IN 1 .. v_old.COUNT LOOP
                IF NVL(nz(v_src(i + j - 1)), '~') <> v_old(j) THEN v_ok := FALSE; EXIT; END IF;
            END LOOP;
            IF v_ok THEN v_hit := v_hit + 1; v_at := i; END IF;
        END LOOP;
        IF v_hit <> 1 THEN
            RAISE_APPLICATION_ERROR(-20011, '중단 - 보완 대상 17줄 구간 ' || v_hit || '건(1 기대)');
        END IF;
    END IF;
    FOR i IN 1 .. v_n LOOP
        IF i = 1 THEN
            pl(REGEXP_REPLACE(v_src(1), '^\\s*PACKAGE\\s+BODY\\s+"?PKG_DMF0045"?', 'CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0045', 1, 1, 'i'));
        ELSIF c_patch AND i = v_at THEN
            FOR k IN 1 .. v_blk.COUNT LOOP pl(v_blk(k)); END LOOP;
        ELSIF c_patch AND i > v_at AND i < v_at + v_old.COUNT THEN
            NULL;
        ELSE
            pl(v_src(i));
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('/');
END;
/
"""

    W = lambda n, t: open(os.path.join(PKG_DIR, n), 'w', encoding='utf-8', newline='\n').write(t)
    W('21_PRINT_PATCHED_BODY.sql', printer(True))
    W('06_PRINT_ORIGINAL_BODY.sql', printer(False))
    W('01_CHECK_PRIVS.sql', """/* 권한 확인 : 클라우드 20 실행 ORA-01031 원인 확인용 (조회만) */
SELECT USER AS LOGIN_USER, SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS CURRENT_SCHEMA FROM DUAL;
SELECT PRIVILEGE FROM SESSION_PRIVS
 WHERE PRIVILEGE IN ('CREATE PROCEDURE', 'CREATE ANY PROCEDURE', 'ALTER ANY PROCEDURE', 'CREATE TABLE', 'CREATE ANY TABLE')
 ORDER BY 1;
SELECT ROLE FROM SESSION_ROLES ORDER BY 1;
SELECT OWNER, TRIGGER_NAME, TRIGGERING_EVENT, BASE_OBJECT_TYPE, STATUS
  FROM ALL_TRIGGERS
 WHERE BASE_OBJECT_TYPE IN ('DATABASE', 'SCHEMA')
 ORDER BY 1, 2;
""")
    print('OK')


if __name__ == '__main__':
    main()
