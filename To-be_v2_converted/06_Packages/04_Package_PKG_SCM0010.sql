/*=============================================================================================
 * File         : 04_Package_PKG_SCM0010.sql
 * Description  : Package — PKG_SCM0010
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - $$PLSQL_UNIT 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCM0010 IS
    /*
    * Program ID   : PKG_SCM0010
    * Description  : PKG_SCM0010
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.30   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_SCM0010_GET_NOTICE_CONTENT_MASTER
    (
        P_NOTICE_ID     VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0010_GET_NOTICE_MASTER
    (
        P_MODULE        VARCHAR2
       ,P_SUBMODULE     VARCHAR2
       ,P_ACTIVE        VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0010_SAVE_NOTICE_CONTENT_MASTER
    (
        P_ACTIVE_FLAG     VARCHAR2
       ,P_NOTICE_ID       VARCHAR2
       ,P_LANGUAGE        VARCHAR2
       ,P_TITLE           VARCHAR2
       ,P_CONTENT         VARCHAR2
       ,P_CREATED_BY      VARCHAR2
       ,P_CREATION_DATE   VARCHAR2
       ,P_LAST_UPDATED_BY VARCHAR2
       ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0010_SAVE_NOTICE_MASTER
    (
        P_ACTIVE_FLAG       VARCHAR2
       ,P_MODULE            VARCHAR2
       ,P_SUBMODULE         VARCHAR2
       ,P_NOTICE_ID         VARCHAR2
       ,P_NOTICE_DESC       VARCHAR2
       ,P_CYCLE_CLASS_CODE  VARCHAR2
       ,P_DETAIL_CLASS_CODE VARCHAR2
       ,P_SEND_TIME_TEXT    VARCHAR2
       ,P_ACTIVE            VARCHAR2
       ,P_CREATED_BY        VARCHAR2
       ,P_CREATION_DATE     VARCHAR2
       ,P_LAST_UPDATED_BY   VARCHAR2
       ,O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_SCM0010;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCM0010 IS

    PROCEDURE P_SCM0010_GET_NOTICE_CONTENT_MASTER
    (
        P_NOTICE_ID     VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : SCM0010_GET_NOTICE_CONTENT_MASTER
        * Description  : NOTICE MESSAGE 조회
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2018/02/22   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
         * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        V_IN_PARA_DATA CLOB;
        V_STEP         VARCHAR2(4000 CHAR) := NULL;
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        V_IN_PARA_DATA := JSON_OBJECT('p_notice_id' VALUE P_NOTICE_ID);
    
        OPEN O_RC1 FOR
            SELECT M.NOTICE_ID, R.NOTICE_TITLE NOTICE_MAIN_TITLE, M.LANGUAGE_CODE, LD.SEGMENT2 LANGUAGE, M.NOTICE_TITLE, M.NOTICE_CONTENT
            FROM   SCM_ADM_NOTICE_CONTENT_MASTER M
            INNER  JOIN SCM_ADM_NOTICE_MASTER R
            ON     R.NOTICE_ID = M.NOTICE_ID
            INNER  JOIN SCM_ADM_LOOKUP_MASTER LM
            ON     LM.LOOKUP_TYPE = 'LANGUAGE'
            AND    LM.VALID_YN = 'Y'
            INNER  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD
            ON     LD.LOOKUP_TYPE = LM.LOOKUP_TYPE
            AND    LD.SEGMENT1 = M.LANGUAGE_CODE
            AND    LD.VALID_YN = 'Y'
            WHERE  1 = 1
            AND    M.NOTICE_ID = P_NOTICE_ID;
    
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_SCM0010_GET_NOTICE_CONTENT_MASTER;

    PROCEDURE P_SCM0010_GET_NOTICE_MASTER
    (
        P_MODULE        VARCHAR2
       ,P_SUBMODULE     VARCHAR2
       ,P_ACTIVE        VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : SCM0010_GET_NOTICE_MASTER
        * Description  : NOTICE SET MASTER 조회
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2018/02/22   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
         * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        V_IN_PARA_DATA CLOB;
        V_STEP         VARCHAR2(4000 CHAR) := NULL;
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        V_IN_PARA_DATA := JSON_OBJECT('p_module' VALUE P_MODULE, 'p_submodule' VALUE P_SUBMODULE, 'p_active' VALUE P_ACTIVE);
    
        OPEN O_RC1 FOR
            SELECT M.NOTICE_ID
                  ,M.MODULE_CODE
                  ,M.SUB_MODULE_CODE
                  ,M.NOTICE_TITLE      NOTICE_MAIN_TITLE
                  ,M.CYCLE_CLASS_CODE
                  ,M.DETAIL_CLASS_CODE
                  ,M.SEND_TIME_TEXT
                  ,M.VALID_YN          ACTIVE_FLAG
            FROM   SCM_ADM_NOTICE_MASTER M
            WHERE  1 = 1
            AND    (P_MODULE IS NULL OR M.MODULE_CODE IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_MODULE, ','))))
            AND    (P_SUBMODULE IS NULL OR M.SUB_MODULE_CODE IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_SUBMODULE, ','))))
            AND    (P_ACTIVE IS NULL OR M.VALID_YN IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_ACTIVE, ','))))
            ORDER  BY M.MODULE_CODE, M.SUB_MODULE_CODE, M.NOTICE_ID, M.CYCLE_CLASS_CODE, M.DETAIL_CLASS_CODE, M.SEND_TIME_TEXT, M.VALID_YN;
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_SCM0010_GET_NOTICE_MASTER;

    PROCEDURE P_SCM0010_SAVE_NOTICE_CONTENT_MASTER
    (
        P_ACTIVE_FLAG     VARCHAR2
       ,P_NOTICE_ID       VARCHAR2
       ,P_LANGUAGE        VARCHAR2
       ,P_TITLE           VARCHAR2
       ,P_CONTENT         VARCHAR2
       ,P_CREATED_BY      VARCHAR2
       ,P_CREATION_DATE   VARCHAR2
       ,P_LAST_UPDATED_BY VARCHAR2
       ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : SCM0010_SAVE_NOTICE_CONTENT_MASTER
        * Description  : NOTICE_ID별 메세지 저장
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2018/02/22   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        * 2026.03.24   김준규    [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        V_RECV_ACTIVE_FLAG VARCHAR2(4000 CHAR);
        V_ACTIVE_FLAG      VARCHAR2(4000 CHAR);
        V_NOTICE_ID        VARCHAR2(4000 CHAR);
        V_LANGUAGE         VARCHAR2(4000 CHAR);
        V_TITLE            VARCHAR2(4000 CHAR);
        V_CONTENT          VARCHAR2(4000 CHAR);
        V_CREATED_BY       VARCHAR2(4000 CHAR);
        V_CREATION_DATE    VARCHAR2(4000 CHAR);
        V_LAST_UPDATED_BY  VARCHAR2(4000 CHAR);
        V_DELIMITER        VARCHAR2(1 CHAR);
        V_MAX_LOOP_CNT     INTEGER := 0;
        V_MST_LOOP_CNT     INTEGER := 0;
        $$PLSQL_UNIT     VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE         VARCHAR2(30 CHAR);
        N_LOG_COUNT        INTEGER := 0;
        V_LOG_MESSAGE      VARCHAR2(1000 CHAR);
        V_DESCRIPTION      VARCHAR2(500 CHAR);
        D_EVENT_DATE       DATE;
        V_IN_PARA_DATA     VARCHAR2(4000 CHAR);
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        --SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
        V_RECV_ACTIVE_FLAG := NULL;
        V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;
    
        V_ACTIVE_FLAG     := NULL;
        V_NOTICE_ID       := NULL;
        V_LANGUAGE        := NULL;
        V_CONTENT         := NULL;
        V_CREATED_BY      := NULL;
        V_CREATION_DATE   := NULL;
        V_LAST_UPDATED_BY := NULL;
    
        V_DELIMITER := '^';
        COMMIT;
    
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
    
        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    
        -- 프로시저 LOOP 길이를 판단
        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);
        --SELECT    v_max_loop_cnt;
        --  WHILE LENGTH(p_active_flag) > 0
        WHILE LENGTH(V_RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP
        
            -- v_mst_loop_cnt 1증가
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
            --SELECT v_mst_loop_cnt,'v_mst_loop_cnt'
            -- 각 컬럼들에 대한 스플릿처리로직 스타트
            BEGIN
            
                V_ACTIVE_FLAG     := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, V_DELIMITER, V_MST_LOOP_CNT);
                V_NOTICE_ID       := SCM_ARR_SPL_VAL(P_NOTICE_ID, V_DELIMITER, V_MST_LOOP_CNT);
                V_LANGUAGE        := SCM_ARR_SPL_VAL(P_LANGUAGE, V_DELIMITER, V_MST_LOOP_CNT);
                V_TITLE           := SCM_ARR_SPL_VAL(P_TITLE, V_DELIMITER, V_MST_LOOP_CNT);
                V_CONTENT         := SCM_ARR_SPL_VAL(P_CONTENT, V_DELIMITER, V_MST_LOOP_CNT);
                V_CREATED_BY      := SCM_ARR_SPL_VAL(P_CREATED_BY, V_DELIMITER, V_MST_LOOP_CNT);
                V_CREATION_DATE   := SCM_ARR_SPL_VAL(P_CREATION_DATE, V_DELIMITER, V_MST_LOOP_CNT);
                V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY, V_DELIMITER, V_MST_LOOP_CNT);
            
            END;
        
            --HISTORY INSERT INTO PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST(v_notice_id);
            --,v_language
            --,v_title
            --,v_content
            --,v_created_by
            --,v_creation_date
            --,v_last_updated_by
        
            IF V_MST_LOOP_CNT > 0 THEN
                IF V_ACTIVE_FLAG != 'D' THEN
                    MERGE INTO SCM_ADM_NOTICE_CONTENT_MASTER A
                    USING (SELECT V_NOTICE_ID NOTICE_ID, V_LANGUAGE LANGUAGE FROM DUAL) B
                    ON (A.NOTICE_ID = B.NOTICE_ID AND A.LANGUAGE_CODE = B.LANGUAGE)
                    WHEN MATCHED THEN
                        UPDATE SET NOTICE_TITLE = V_TITLE, NOTICE_CONTENT = V_CONTENT, LAST_UPDATED_BY = V_LAST_UPDATED_BY, LAST_UPDATE_DATE = SYSTIMESTAMP
                        
                    
                    WHEN NOT MATCHED THEN
                    
                        INSERT
                            (NOTICE_ID, LANGUAGE_CODE, NOTICE_TITLE, NOTICE_CONTENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                        VALUES
                            (V_NOTICE_ID, V_LANGUAGE, V_TITLE, V_CONTENT, V_CREATED_BY, SYSTIMESTAMP, V_LAST_UPDATED_BY, SYSTIMESTAMP);
                
                ELSIF V_ACTIVE_FLAG = 'D' THEN
                    DELETE FROM SCM_ADM_NOTICE_CONTENT_MASTER
                    WHERE  NOTICE_ID = V_NOTICE_ID
                    AND    LANGUAGE_CODE = V_LANGUAGE;
                END IF;
            END IF;
        END LOOP;
    
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    
        -- 결과코드, 결과 카운트 반환
        --SELECT  'S' AS result_code,  v_max_loop_cnt result_cnt 
        --FROM DUAL;
        -- END TRY
        COMMIT;
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            INSERT INTO SCM_SYS_LOG_BATCH
                (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES
                ($$PLSQL_UNIT
                ,'ERROR'
                ,NULL
                ,NULL --[[SQLERRM]]
                ,NULL
                ,SYSTIMESTAMP
                ,SYSTIMESTAMP
                ,$$PLSQL_UNIT
                ,SYSTIMESTAMP
                ,$$PLSQL_UNIT);
        
            COMMIT;
        
            -- error코드, errror 메시지 반환
            --SELECT 'F' AS result_code
            --FROM DUAL;
            --SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM
            --FROM DUAL;
            -- END CATCH
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_SCM0010_SAVE_NOTICE_CONTENT_MASTER;

    PROCEDURE P_SCM0010_SAVE_NOTICE_MASTER
    (
        P_ACTIVE_FLAG       VARCHAR2
       ,P_MODULE            VARCHAR2
       ,P_SUBMODULE         VARCHAR2
       ,P_NOTICE_ID         VARCHAR2
       ,P_NOTICE_DESC       VARCHAR2
       ,P_CYCLE_CLASS_CODE  VARCHAR2
       ,P_DETAIL_CLASS_CODE VARCHAR2
       ,P_SEND_TIME_TEXT    VARCHAR2
       ,P_ACTIVE            VARCHAR2
       ,P_CREATED_BY        VARCHAR2
       ,P_CREATION_DATE     VARCHAR2
       ,P_LAST_UPDATED_BY   VARCHAR2
       ,O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : SCM0010_SAVE_NOTICE_MASTER
        * Description  : NOTICE Master 저장(NOTICE_ID는 채번으로 저장)
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2018/02/22   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
         * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        V_IN_PARA_DATA      CLOB;
        V_RECV_ACTIVE_FLAG  VARCHAR2(4000 CHAR);
        V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
        V_USE_TYPE          VARCHAR2(4000 CHAR);
        V_MODULE            VARCHAR2(4000 CHAR);
        V_SUBMODULE         VARCHAR2(4000 CHAR);
        V_NOTICE_ID         VARCHAR2(4000 CHAR);
        V_NOTICE_DESC       VARCHAR2(4000 CHAR);
        V_CYCLE_CLASS_CODE  VARCHAR2(4000 CHAR);
        V_DETAIL_CLASS_CODE VARCHAR2(4000 CHAR);
        V_SEND_TIME_TEXT    VARCHAR2(4000 CHAR);
        V_ACTIVE            VARCHAR2(4000 CHAR);
        V_CREATED_BY        VARCHAR2(4000 CHAR);
        V_CREATION_DATE     VARCHAR2(4000 CHAR);
        V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR);
        V_SQL_LONG_TEXT     VARCHAR2(4000 CHAR);
        V_DELIMITER         VARCHAR2(1 CHAR);
        V_MAX_LOOP_CNT      INTEGER := 0;
        V_MST_LOOP_CNT      INTEGER := 0;
        $$PLSQL_UNIT      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        N_LOG_COUNT         INTEGER := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;
        N_HISTORY_SEQ       INTEGER;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        --SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
        V_RECV_ACTIVE_FLAG := NULL;
        V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;
    
        V_ACTIVE_FLAG       := NULL;
        V_USE_TYPE          := NULL;
        V_MODULE            := NULL;
        V_SUBMODULE         := NULL;
        V_NOTICE_ID         := NULL;
        V_NOTICE_DESC       := NULL;
        V_CYCLE_CLASS_CODE  := NULL;
        V_DETAIL_CLASS_CODE := NULL;
        V_SEND_TIME_TEXT    := NULL;
        V_ACTIVE            := NULL;
        V_CREATED_BY        := NULL;
        V_CREATION_DATE     := NULL;
        V_LAST_UPDATED_BY   := NULL;
        V_SQL_LONG_TEXT     := NULL;
    
        V_DELIMITER := '^';
    
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
    
        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    
        -- 프로시저 LOOP 길이를 판단
        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);
        --SELECT    v_max_loop_cnt;
        --  WHILE LENGTH(p_active_flag) > 0
        WHILE LENGTH(V_RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP
        
            -- v_mst_loop_cnt 1증가
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
            --SELECT v_mst_loop_cnt,'v_mst_loop_cnt'
            -- 각 컬럼들에 대한 스플릿처리로직 스타트
            BEGIN
            
                V_ACTIVE_FLAG       := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, V_DELIMITER, V_MST_LOOP_CNT);
                V_MODULE            := SCM_ARR_SPL_VAL(P_MODULE, V_DELIMITER, V_MST_LOOP_CNT);
                V_SUBMODULE         := SCM_ARR_SPL_VAL(P_SUBMODULE, V_DELIMITER, V_MST_LOOP_CNT);
                V_NOTICE_ID         := SCM_ARR_SPL_VAL(P_NOTICE_ID, V_DELIMITER, V_MST_LOOP_CNT);
                V_NOTICE_DESC       := SCM_ARR_SPL_VAL(P_NOTICE_DESC, V_DELIMITER, V_MST_LOOP_CNT);
                V_CYCLE_CLASS_CODE  := SCM_ARR_SPL_VAL(P_CYCLE_CLASS_CODE, V_DELIMITER, V_MST_LOOP_CNT);
                V_DETAIL_CLASS_CODE := SCM_ARR_SPL_VAL(P_DETAIL_CLASS_CODE, V_DELIMITER, V_MST_LOOP_CNT);
                V_SEND_TIME_TEXT    := SCM_ARR_SPL_VAL(P_SEND_TIME_TEXT, V_DELIMITER, V_MST_LOOP_CNT);
                V_ACTIVE            := SCM_ARR_SPL_VAL(P_ACTIVE, V_DELIMITER, V_MST_LOOP_CNT);
                V_CREATED_BY        := SCM_ARR_SPL_VAL(P_CREATED_BY, V_DELIMITER, V_MST_LOOP_CNT);
                V_CREATION_DATE     := SCM_ARR_SPL_VAL(P_CREATION_DATE, V_DELIMITER, V_MST_LOOP_CNT);
                V_LAST_UPDATED_BY   := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY, V_DELIMITER, V_MST_LOOP_CNT);
            
            END;
        
            IF (V_NOTICE_ID IS NULL) THEN
                N_HISTORY_SEQ := SEQ1_SCM_ADM_NOTICE_MASTER.NEXTVAL;
            ELSE
                N_HISTORY_SEQ := V_NOTICE_ID;
            
                --HISTORY INSERT INTO PR_SCM_ADM_NOTICE_MASTER_HIST(v_module);
                --                          ,v_submodule
                --                          ,v_notice_id
                --                          ,v_notice_desc
                --                          ,v_cycle_class_code
                --                          ,v_detail_class_code
                --                          ,v_send_time_text
                --                          ,v_active
                --                          ,V_sql_long_text
                --                          ,v_created_by
                --                          ,v_creation_date
                --                          ,v_last_updated_by
            
            END IF;
        
            IF V_MST_LOOP_CNT > 0 THEN
                IF V_ACTIVE_FLAG != 'D' THEN
                    BEGIN
                    
                        MERGE INTO SCM_ADM_NOTICE_MASTER A
                        USING (SELECT N_HISTORY_SEQ NOTICE_ID, V_MODULE MODULE_CODE, V_SUBMODULE SUB_MODULE_CODE FROM DUAL) B
                        ON (A.NOTICE_ID = B.NOTICE_ID AND A.MODULE_CODE = B.MODULE_CODE AND A.SUB_MODULE_CODE = B.SUB_MODULE_CODE)
                        WHEN MATCHED THEN
                            UPDATE
                            SET    NOTICE_TITLE      = V_NOTICE_DESC
                                  ,CYCLE_CLASS_CODE  = V_CYCLE_CLASS_CODE
                                  ,DETAIL_CLASS_CODE = V_DETAIL_CLASS_CODE
                                  ,SEND_TIME_TEXT    = V_SEND_TIME_TEXT
                                  ,VALID_YN          = V_ACTIVE
                                  ,LAST_UPDATED_BY   = V_LAST_UPDATED_BY
                                  ,LAST_UPDATE_DATE  = SYSTIMESTAMP
                            
                        
                        WHEN NOT MATCHED THEN
                        
                            INSERT
                                (NOTICE_ID
                                ,SUB_MODULE_CODE
                                ,MODULE_CODE
                                ,NOTICE_TITLE
                                ,CYCLE_CLASS_CODE
                                ,DETAIL_CLASS_CODE
                                ,SEND_TIME_TEXT
                                ,VALID_YN
                                ,CREATED_BY
                                ,CREATION_DATE
                                ,LAST_UPDATED_BY
                                ,LAST_UPDATE_DATE)
                            VALUES
                                (N_HISTORY_SEQ
                                ,V_SUBMODULE
                                ,V_MODULE
                                ,V_NOTICE_DESC
                                ,V_CYCLE_CLASS_CODE
                                ,V_DETAIL_CLASS_CODE
                                ,V_SEND_TIME_TEXT
                                ,V_ACTIVE
                                ,V_CREATED_BY
                                ,SYSTIMESTAMP
                                ,V_LAST_UPDATED_BY
                                ,SYSTIMESTAMP);
                    
                    END;
                ELSIF V_ACTIVE_FLAG = 'D' THEN
                    DELETE FROM SCM_ADM_NOTICE_MASTER
                    WHERE  MODULE_CODE = V_MODULE
                    AND    SUB_MODULE_CODE = V_SUBMODULE
                    AND    NOTICE_ID = N_HISTORY_SEQ;
                
                    /*해당 notice_ID로 등록되어 있는 메세지를 같이 삭제한다.*/
                    DELETE FROM SCM_ADM_NOTICE_CONTENT_MASTER WHERE NOTICE_ID = N_HISTORY_SEQ;
                END IF;
            END IF;
        END LOOP;
    
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    
        -- 결과코드, 결과 카운트 반환
        COMMIT;
        -- END TRY
    
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            INSERT INTO SCM_SYS_LOG_BATCH
                (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES
                ($$PLSQL_UNIT
                ,'ERROR'
                ,NULL
                ,NULL --[[SQLERRM]]
                ,NULL
                ,SYSTIMESTAMP
                ,SYSTIMESTAMP
                ,$$PLSQL_UNIT
                ,SYSTIMESTAMP
                ,$$PLSQL_UNIT);
        
            COMMIT;
        
            -- error코드, errror 메시지 반환
            NULL;
            -- END CATCH
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_SCM0010_SAVE_NOTICE_MASTER;

END PKG_SCM0010;
/
