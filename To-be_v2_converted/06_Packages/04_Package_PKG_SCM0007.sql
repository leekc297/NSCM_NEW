/*=============================================================================================
 * File         : 04_Package_PKG_SCM0007.sql
 * Description  : Package — PKG_SCM0007
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCM0007 IS
    /*
    * Program ID   : PKG_SCM0007
    * Description  : PKG_SCM0007
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.30   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_SCM0007_GET_RECIPIENT_SMS_ASSIGN
    (
        P_CATEGORYID    VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0007_GET_RECIPIENT_SMS_GROUP_LIST
    (
        P_GROUP         VARCHAR2
       ,P_PHONE         VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0007_SAVE_RECIPIENT_SMS_ASSIGN
    (
        P_ACTIVE_FLAG     VARCHAR2
       ,P_CATEGORY_ID     VARCHAR2
       ,P_SMS_GROUP_NAME  VARCHAR2
       ,P_SMS_PHONE       VARCHAR2
       ,P_CREATED_BY      VARCHAR2
       ,P_CREATION_DATE   VARCHAR2
       ,P_LAST_UPDATED_BY VARCHAR2
       ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0007_SAVE_RECIPIENT_SMS_GROUP
    (
        P_ACTIVE_FLAG     VARCHAR2
       ,P_SMS_GROUP_NAME  VARCHAR2
       ,P_SMS_PHONE       VARCHAR2
       ,P_CREATED_BY      VARCHAR2
       ,P_CREATION_DATE   VARCHAR2
       ,P_LAST_UPDATED_BY VARCHAR2
       ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

END PKG_SCM0007;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCM0007 IS

    PROCEDURE P_SCM0007_GET_RECIPIENT_SMS_ASSIGN
    (
        P_CATEGORYID    VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    ) AS
    
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
    
        V_IN_PARA_DATA := JSON_OBJECT('p_categoryID' VALUE P_CATEGORYID);
    
        OPEN O_RC1 FOR
            SELECT A.CATEGORY_ID, A.SMS_GROUP_NAME, A.SMS_PHONE
            FROM   SCM_ADM_RECIPIENT_SMS_ASSIGN A
            WHERE  A.CATEGORY_ID = P_CATEGORYID
            ORDER  BY A.SMS_GROUP_NAME;
    
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
    END P_SCM0007_GET_RECIPIENT_SMS_ASSIGN;

    PROCEDURE P_SCM0007_GET_RECIPIENT_SMS_GROUP_LIST
    (
        P_GROUP         VARCHAR2
       ,P_PHONE         VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : SCM0007_GET_RECIPIENT_SMS_GROUP_LIST
        * Description  : SMS GROUP 조회
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2018/05/11   hwyoon   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
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
    
        V_IN_PARA_DATA := JSON_OBJECT('p_group' VALUE P_GROUP, 'p_phone' VALUE P_PHONE);
    
        OPEN O_RC1 FOR
            SELECT M.SMS_GROUP_NAME, M.SMS_PHONE
            FROM   SCM_ADM_RECIPIENT_SMS_GROUP M
            WHERE  1 = 1
            AND    (P_GROUP IS NULL OR M.SMS_GROUP_NAME LIKE '%' || P_GROUP || '%')
            AND    (P_PHONE IS NULL OR M.SMS_PHONE LIKE '%' || P_PHONE || '%')
            ORDER  BY M.SMS_GROUP_NAME;
    
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
    END P_SCM0007_GET_RECIPIENT_SMS_GROUP_LIST;

    PROCEDURE P_SCM0007_SAVE_RECIPIENT_SMS_ASSIGN
    (
        P_ACTIVE_FLAG     VARCHAR2
       ,P_CATEGORY_ID     VARCHAR2
       ,P_SMS_GROUP_NAME  VARCHAR2
       ,P_SMS_PHONE       VARCHAR2
       ,P_CREATED_BY      VARCHAR2
       ,P_CREATION_DATE   VARCHAR2
       ,P_LAST_UPDATED_BY VARCHAR2
       ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : SCM0007_SAVE_RECIPIENT_SMS_ASSIGN
        * Description  : SMS Category_ID별 수신자 리스트 저장
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2018/05/11   hwyoon   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        *
         * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        V_STEP VARCHAR2(4000 CHAR) := NULL;
    
        V_IN_PARA_DATA     CLOB;
        V_RECV_ACTIVE_FLAG VARCHAR2(4000 CHAR);
        V_ACTIVE_FLAG      VARCHAR2(4000 CHAR);
        V_CATEGORY_ID      VARCHAR2(4000 CHAR);
        V_SMS_GROUP_NAME   VARCHAR2(4000 CHAR);
        V_SMS_PHONE        VARCHAR2(4000 CHAR);
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
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        V_IN_PARA_DATA := JSON_OBJECT('p_active_flag' VALUE P_ACTIVE_FLAG
                                     ,'p_category_id' VALUE P_CATEGORY_ID
                                     ,'p_sms_group_name' VALUE P_SMS_GROUP_NAME
                                     ,'p_sms_phone' VALUE P_SMS_PHONE
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_creation_date' VALUE P_CREATION_DATE
                                     ,'p_last_updated_by' VALUE P_LAST_UPDATED_BY);
    
        V_RECV_ACTIVE_FLAG := NULL;
        V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;
    
        V_ACTIVE_FLAG     := NULL;
        V_CATEGORY_ID     := NULL;
        V_SMS_GROUP_NAME  := NULL;
        V_SMS_PHONE       := NULL;
        V_CREATED_BY      := NULL;
        V_CREATION_DATE   := NULL;
        V_LAST_UPDATED_BY := NULL;
    
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
        WHILE LENGTH(V_RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP
        
            -- v_mst_loop_cnt 1증가
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
        
            -- 각 컬럼들에 대한 스플릿처리로직 스타트
            BEGIN
            
                V_ACTIVE_FLAG     := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, V_DELIMITER, V_MST_LOOP_CNT);
                V_CATEGORY_ID     := SCM_ARR_SPL_VAL(P_CATEGORY_ID, V_DELIMITER, V_MST_LOOP_CNT);
                V_SMS_GROUP_NAME  := SCM_ARR_SPL_VAL(P_SMS_GROUP_NAME, V_DELIMITER, V_MST_LOOP_CNT);
                V_SMS_PHONE       := SCM_ARR_SPL_VAL(P_SMS_PHONE, V_DELIMITER, V_MST_LOOP_CNT);
                V_CREATED_BY      := SCM_ARR_SPL_VAL(P_CREATED_BY, V_DELIMITER, V_MST_LOOP_CNT);
                V_CREATION_DATE   := SCM_ARR_SPL_VAL(P_CREATION_DATE, V_DELIMITER, V_MST_LOOP_CNT);
                V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY, V_DELIMITER, V_MST_LOOP_CNT);
            
            END;
        
            IF V_MST_LOOP_CNT > 0 THEN
                IF V_ACTIVE_FLAG != 'D' THEN
                    MERGE INTO SCM_ADM_RECIPIENT_SMS_ASSIGN A
                    USING (SELECT V_CATEGORY_ID CATEGORY_ID, V_SMS_GROUP_NAME SMS_GROUP_NAME, V_SMS_PHONE SMS_PHONE FROM DUAL) B
                    ON (A.CATEGORY_ID = B.CATEGORY_ID AND A.SMS_GROUP_NAME = B.SMS_GROUP_NAME AND A.SMS_PHONE = B.SMS_PHONE)
                    WHEN MATCHED THEN
                        UPDATE SET LAST_UPDATED_BY = V_LAST_UPDATED_BY, LAST_UPDATE_DATE = SYSTIMESTAMP
                        
                    
                    WHEN NOT MATCHED THEN
                    
                        INSERT
                            (CATEGORY_ID, SMS_GROUP_NAME, SMS_PHONE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                        VALUES
                            (V_CATEGORY_ID, V_SMS_GROUP_NAME, V_SMS_PHONE, V_CREATED_BY, SYSTIMESTAMP, V_LAST_UPDATED_BY, SYSTIMESTAMP);
                
                ELSIF V_ACTIVE_FLAG = 'D' THEN
                    DELETE FROM SCM_ADM_RECIPIENT_SMS_ASSIGN
                    WHERE  CATEGORY_ID = V_CATEGORY_ID
                    AND    SMS_GROUP_NAME = V_SMS_GROUP_NAME
                    AND    SMS_PHONE = V_SMS_PHONE;
                END IF;
            END IF;
        END LOOP;
    
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    
        -- 결과코드, 결과 카운트 반환
    
        -- END TRY
    
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
        COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,'ERROR'
                                ,0
                                ,SQLERRM
                                ,NULL
                                ,SYSDATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_SCM0007_SAVE_RECIPIENT_SMS_ASSIGN;

    PROCEDURE P_SCM0007_SAVE_RECIPIENT_SMS_GROUP(
                                                 -- Add the parameters for the stored procedure here
                                                 P_ACTIVE_FLAG     VARCHAR2
                                                ,P_SMS_GROUP_NAME  VARCHAR2
                                                ,P_SMS_PHONE       VARCHAR2
                                                ,P_CREATED_BY      VARCHAR2
                                                ,P_CREATION_DATE   VARCHAR2
                                                ,P_LAST_UPDATED_BY VARCHAR2
                                                ,O_RESULT_CURSOR   OUT SYS_REFCURSOR)
    /*
        * Program ID   : SCM0007_SAVE_RECIPIENT_SMS_GROUP
        * Description  : SMS 수신자 리스트 저장
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2018/05/11   hwyoon   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        *
         * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS
    
        V_RECV_ACTIVE_FLAG VARCHAR2(4000 CHAR);
        V_ACTIVE_FLAG      VARCHAR2(4000 CHAR);
        V_SMS_GROUP_NAME   VARCHAR2(4000 CHAR);
        V_SMS_PHONE        VARCHAR2(4000 CHAR);
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
    
        V_RECV_ACTIVE_FLAG := NULL;
        V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;
    
        V_ACTIVE_FLAG     := NULL;
        V_SMS_GROUP_NAME  := NULL;
        V_SMS_PHONE       := NULL;
        V_CREATED_BY      := NULL;
        V_CREATION_DATE   := NULL;
        V_LAST_UPDATED_BY := NULL;
    
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
        WHILE LENGTH(V_RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP
        
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
        
            -- 각 컬럼들에 대한 스플릿처리로직 스타트
            BEGIN
            
                V_ACTIVE_FLAG     := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, V_DELIMITER, V_MST_LOOP_CNT);
                V_SMS_GROUP_NAME  := SCM_ARR_SPL_VAL(P_SMS_GROUP_NAME, V_DELIMITER, V_MST_LOOP_CNT);
                V_SMS_PHONE       := SCM_ARR_SPL_VAL(P_SMS_PHONE, V_DELIMITER, V_MST_LOOP_CNT);
                V_CREATED_BY      := SCM_ARR_SPL_VAL(P_CREATED_BY, V_DELIMITER, V_MST_LOOP_CNT);
                V_CREATION_DATE   := SCM_ARR_SPL_VAL(P_CREATION_DATE, V_DELIMITER, V_MST_LOOP_CNT);
                V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY, V_DELIMITER, V_MST_LOOP_CNT);
            
            END;
        
            IF V_MST_LOOP_CNT > 0 THEN
                IF V_ACTIVE_FLAG != 'D' THEN
                    MERGE INTO SCM_ADM_RECIPIENT_SMS_GROUP A
                    USING (SELECT V_SMS_GROUP_NAME SMS_GROUP_NAME, V_SMS_PHONE SMS_PHONE FROM DUAL) B
                    ON (A.SMS_GROUP_NAME = B.SMS_GROUP_NAME AND A.SMS_PHONE = B.SMS_PHONE)
                    WHEN MATCHED THEN
                        UPDATE SET LAST_UPDATED_BY = V_LAST_UPDATED_BY, LAST_UPDATE_DATE = SYSTIMESTAMP
                        
                    
                    WHEN NOT MATCHED THEN
                    
                        INSERT
                            (SMS_GROUP_NAME, SMS_PHONE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                        VALUES
                            (V_SMS_GROUP_NAME, V_SMS_PHONE, V_CREATED_BY, SYSTIMESTAMP, V_LAST_UPDATED_BY, SYSTIMESTAMP);
                
                ELSIF V_ACTIVE_FLAG = 'D' THEN
                    DELETE FROM SCM_ADM_RECIPIENT_SMS_GROUP
                    WHERE  SMS_GROUP_NAME = V_SMS_GROUP_NAME
                    AND    SMS_PHONE = V_SMS_PHONE;
                END IF;
            END IF;
        END LOOP;
    
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    
        COMMIT;
        -- 결과코드, 결과 카운트 반환
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
            -- END CATCH
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_SCM0007_SAVE_RECIPIENT_SMS_GROUP;

END PKG_SCM0007;
/
