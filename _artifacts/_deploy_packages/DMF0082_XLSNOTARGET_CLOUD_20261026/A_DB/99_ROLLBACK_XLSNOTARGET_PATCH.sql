-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-21 22:47:30 FETCHED=2026-10-26 23:44:51 DB=ZIOUI1(localhost)
-- 99 ROLLBACK — [E20261026-DMF0082XLSNOTARGET] 삽입 블록 제거 (이 DB 의 USER_SOURCE 를 읽어 블록만 빼고 CREATE OR REPLACE). 전체 F5, 멱등
-- 표식 없으면 무동작. ⚠ 되돌리면 Model 빈칸 행의 대상 Model 이 0 이어도 다시 SUCCESS(저장 0행)가 된다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET SQLBLANKLINES ON
DECLARE
    c_mark  CONSTANT VARCHAR2(40) := 'E20261026-DMF0082XLSNOTARGET';
    c_tag   CONSTANT VARCHAR2(20) := 'XLSNOTARGET';
    c_anc   CONSTANT VARCHAR2(4000) :=
        '        V_LOG_MESSAGE := ''########## Invalid MODEL. ##########'';' || CHR(10) ||
        '        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);' || CHR(10) ||
        '        D_EVENT_DATE  := SYSDATE;' || CHR(10) ||
        '        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;' || CHR(10);
    c_blk   CONSTANT VARCHAR2(32767) :=
        '' || CHR(10) ||
        '        /* #################################################### */' || CHR(10) ||
        '        /* Model 빈칸 행 저장 대상 Model 체크						*/' || CHR(10) ||
        '        /* #################################################### */' || CHR(10) ||
        '        --[E20261026-DMF0082XLSNOTARGET] 사용자 지시 2026-10-26 — Model 빈칸 행은 저장 시 아래 조인으로 Model 을 펼친다' || CHR(10) ||
        '        --  (GT_F020_UPLOAD_MASTER_STEP1): 사이트(Div+End Customer) x SITE_ITEM(Project) x 품목 부서명(Team)' || CHR(10) ||
        '        --  x (SCM_MST_FUTURE_PRICE ''LOC'' 또는 DM_PLN_SALES_PLAN ''RTF_SYS_RP'').' || CHR(10) ||
        '        --  위 개별 검사는 값마다 따로 존재만 보므로 조합이 어긋나면 SUCCESS 후 저장 0행이었다 -> 같은 조인으로 대상 0 이면 ERROR.' || CHR(10) ||
        '        --  메시지 = 처음 끊긴 단계 (1) End Customer-Project (2) Team (3) LOC/RTF 대상.' || CHR(10) ||
        '        UPDATE SCM_ADM_EXCEL_UPLOAD EU' || CHR(10) ||
        '           SET EU.UPLOAD_STATUS_CODE = ''ERROR''' || CHR(10) ||
        '             , EU.MESSAGE_TEXT       = CASE' || CHR(10) ||
        '                    WHEN NOT EXISTS (' || CHR(10) ||
        '                         SELECT 1' || CHR(10) ||
        '                           FROM SCM_MST_SITE MS' || CHR(10) ||
        '                          INNER JOIN SCM_MST_SITE_ITEM ITM' || CHR(10) ||
        '                             ON ITM.DIVISION_ID  = EU.ATTRIBUTE1' || CHR(10) ||
        '                            AND ITM.PROJECT_CODE = EU.ATTRIBUTE4' || CHR(10) ||
        '                            AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID' || CHR(10) ||
        '                            AND ITM.VALID_YN     = ''Y''' || CHR(10) ||
        '                          WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1' || CHR(10) ||
        '                            AND MS.END_CUSTOMER = EU.ATTRIBUTE3' || CHR(10) ||
        '                            AND MS.VALID_YN     = ''Y''' || CHR(10) ||
        '                         ) THEN ''No MODEL for END CUSTOMER / PROJECT CODE.''' || CHR(10) ||
        '                    WHEN NOT EXISTS (' || CHR(10) ||
        '                         SELECT 1' || CHR(10) ||
        '                           FROM SCM_MST_SITE MS' || CHR(10) ||
        '                          INNER JOIN SCM_MST_SITE_ITEM ITM' || CHR(10) ||
        '                             ON ITM.DIVISION_ID  = EU.ATTRIBUTE1' || CHR(10) ||
        '                            AND ITM.PROJECT_CODE = EU.ATTRIBUTE4' || CHR(10) ||
        '                            AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID' || CHR(10) ||
        '                            AND ITM.VALID_YN     = ''Y''' || CHR(10) ||
        '                          INNER JOIN SCM_MST_SSO_DEPT_INFO DI' || CHR(10) ||
        '                             ON DI.DEPT_ID       = ITM.DEPT_ID' || CHR(10) ||
        '                            AND DI.DEPT_NAME_KO  = EU.ATTRIBUTE2' || CHR(10) ||
        '                            AND DI.VALID_YN      = ''Y''' || CHR(10) ||
        '                          WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1' || CHR(10) ||
        '                            AND MS.END_CUSTOMER = EU.ATTRIBUTE3' || CHR(10) ||
        '                            AND MS.VALID_YN     = ''Y''' || CHR(10) ||
        '                         ) THEN ''No MODEL for TEAM / PROJECT CODE.''' || CHR(10) ||
        '                    ELSE ''No Upload Target MODEL (LOC / RTF_SYS_RP).''' || CHR(10) ||
        '                END' || CHR(10) ||
        '         WHERE EU.PROGRAM_ID         = V_PROGRAM_ID' || CHR(10) ||
        '           AND EU.SHEET_NAME         = V_SHEET_NAME' || CHR(10) ||
        '           AND EU.CREATED_BY         = P_CREATED_BY' || CHR(10) ||
        '           AND TO_CHAR(EU.CREATION_DATE, ''YYYY-MM-DD HH24:MI:SS.FF3'') = V_CREATION_DATE' || CHR(10) ||
        '           AND EU.UPLOAD_STATUS_CODE = ''UPLOAD''' || CHR(10) ||
        '           AND EU.ATTRIBUTE6 IS NULL --item_id 입력 안된건' || CHR(10) ||
        '           AND NOT EXISTS (' || CHR(10) ||
        '                SELECT 1' || CHR(10) ||
        '                  FROM SCM_MST_SITE MS' || CHR(10) ||
        '                 INNER JOIN SCM_MST_SITE_ITEM ITM' || CHR(10) ||
        '                    ON ITM.DIVISION_ID  = EU.ATTRIBUTE1' || CHR(10) ||
        '                   AND ITM.PROJECT_CODE = EU.ATTRIBUTE4' || CHR(10) ||
        '                   AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID' || CHR(10) ||
        '                   AND ITM.VALID_YN     = ''Y''' || CHR(10) ||
        '                 INNER JOIN SCM_MST_SSO_DEPT_INFO DI' || CHR(10) ||
        '                    ON DI.DEPT_ID       = ITM.DEPT_ID' || CHR(10) ||
        '                   AND DI.DEPT_NAME_KO  = EU.ATTRIBUTE2' || CHR(10) ||
        '                   AND DI.VALID_YN      = ''Y''' || CHR(10) ||
        '                 WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1' || CHR(10) ||
        '                   AND MS.END_CUSTOMER = EU.ATTRIBUTE3' || CHR(10) ||
        '                   AND MS.VALID_YN     = ''Y''' || CHR(10) ||
        '                   AND (   EXISTS (SELECT 1' || CHR(10) ||
        '                                     FROM SCM_MST_FUTURE_PRICE FP' || CHR(10) ||
        '                                    WHERE FP.DIVISION_ID  = EU.ATTRIBUTE1' || CHR(10) ||
        '                                      AND FP.PROJECT_CODE = EU.ATTRIBUTE4' || CHR(10) ||
        '                                      AND FP.SCM_SITE_ID  = MS.SCM_SITE_ID' || CHR(10) ||
        '                                      AND FP.ITEM_ID      = ITM.ITEM_ID' || CHR(10) ||
        '                                      AND FP.MEASURE      = ''LOC'')' || CHR(10) ||
        '                        OR EXISTS (SELECT 1' || CHR(10) ||
        '                                     FROM DM_PLN_SALES_PLAN PN' || CHR(10) ||
        '                                    WHERE PN.DIVISION_ID  = EU.ATTRIBUTE1' || CHR(10) ||
        '                                      AND PN.PROJECT_CODE = EU.ATTRIBUTE4' || CHR(10) ||
        '                                      AND PN.SCM_SITE_ID  = MS.SCM_SITE_ID' || CHR(10) ||
        '                                      AND PN.ITEM_ID      = ITM.ITEM_ID' || CHR(10) ||
        '                                      AND PN.MEASURE      = ''RTF_SYS_RP'')' || CHR(10) ||
        '                       )' || CHR(10) ||
        '               );' || CHR(10) ||
        '' || CHR(10) ||
        '        N_LOG_COUNT   := N_LOG_COUNT + 1;' || CHR(10) ||
        '        V_LOG_TYPE    := ''UPDATE'';' || CHR(10) ||
        '        V_LOG_MESSAGE := ''########## No Upload Target MODEL. ##########'';' || CHR(10) ||
        '        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);' || CHR(10) ||
        '        D_EVENT_DATE  := SYSDATE;' || CHR(10) ||
        '        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;' || CHR(10);
    v_src   CLOB;
    v_span  CLOB;
    v_new   CLOB;
    v_s     PLS_INTEGER;
    v_e     PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_code  PLS_INTEGER := 0;
    v_msg   VARCHAR2(400);
    v_chk   PLS_INTEGER;
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (토큰은 LF 기준)
    IF cnt(v_src, CHR(10) || 'PROCEDURE P_DMF0082_EXCEL_UPLOAD' || CHR(10)) <> 1
       OR cnt(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA') <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'STOP - P_DMF0082_EXCEL_UPLOAD span not found. source unchanged');
    END IF;
    v_s := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_EXCEL_UPLOAD' || CHR(10));
    v_e := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA');
    v_span := SUBSTR(v_src, v_s, v_e - v_s);
    IF cnt(v_span, c_tag) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - tag not found (not applied). source unchanged');
        RETURN;
    END IF;
    IF cnt(v_span, c_anc || c_blk) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20003, 'STOP - inserted block match ' || cnt(v_span, c_anc || c_blk) || ' (expected 1, block edited?). source unchanged');
    END IF;
    v_span := REPLACE(v_span, c_anc || c_blk, c_anc);
    IF cnt(v_span, c_tag) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'STOP - tag remains after removal ' || cnt(v_span, c_tag) || '. source unchanged');
    END IF;
    v_new := SUBSTR(v_src, 1, v_s - 1) || v_span || SUBSTR(v_src, v_e);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        v_code := SQLCODE; v_msg := SUBSTR(SQLERRM, 1, 400);   -- ORA-24344(컴파일 오류 동반 생성)만 아래 STATUS 판정으로 진행
    END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20006, 'STOP - CREATE not executed: ' || v_msg || ' (PKG_DMF0082 in use? retry later). source unchanged');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
        RAISE_APPLICATION_ERROR(-20005, 'COMPILE FAILED -> original restored (now ' || v_st || '). run 90_VERIFY');
    END IF;
    SELECT COUNT(*) INTO v_chk FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, c_tag) > 0;
    IF v_chk <> 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'STOP - after CREATE, tag in USER_SOURCE = ' || v_chk || ' (expected 0). run 90_VERIFY');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK - PKG_DMF0082 BODY ' || v_st || ' / tag 0 / ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
