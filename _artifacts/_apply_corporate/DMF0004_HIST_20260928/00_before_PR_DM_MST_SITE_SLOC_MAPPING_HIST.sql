-- SOURCE-FRESH: SCM_MGR.PR_DM_MST_SITE_SLOC_MAPPING_HIST PROCEDURE LAST_DDL=2026-09-02 17:30:31 FETCHED=2026-09-28 20:15 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE           "PR_DM_MST_SITE_SLOC_MAPPING_HIST" 
(
    P_LOCATION_SEQ         VARCHAR2
   ,P_DIVISION_ID          VARCHAR2
   ,P_LOCATION_CODE        VARCHAR2
   ,P_LOCATION_DESCRIPTION VARCHAR2
   ,P_SCM_SITE_ID          VARCHAR2
   ,P_PLANT_ID             VARCHAR2
   ,P_FACTORY_ID           VARCHAR2
   ,P_OPERATION_ID         VARCHAR2
   ,P_STORAGE_ID           VARCHAR2
   ,P_ELECTRODE_TYPE       VARCHAR2
   ,P_VALID_YN             VARCHAR2
   ,P_CREATED_BY           VARCHAR2
)
/*
    * Program ID   : PR_DM_MST_SITE_SLOC_MAPPING_HIST
    * Description  : SCM MST SITE LOCATION H HISTORYT
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    * 2017.11.29    DWOK/DWPARK      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
    * 2020/09/09     P.C.I     [C20200909-000203] LOG 표준화 적용
    * 2026-03-23    김준규        [PJ20264226] NextSCM Pilot 설계 및 개발
    *
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
    */
 AS

    V_DIVISION_ID   VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID   VARCHAR2(4000 CHAR);
    V_LOCATION_CODE VARCHAR2(4000 CHAR);
    V_VALID_YN      VARCHAR2(4000 CHAR);
    V_CREATED_BY    VARCHAR2(4000 CHAR);
    N_HISTORY_SEQ   INTEGER;
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
    V_IN_PARA_DATA  CLOB;
    V_STEP          VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('p_location_seq' VALUE P_LOCATION_SEQ
                                 ,'p_division_id' VALUE P_DIVISION_ID
                                 ,'p_location_code' VALUE P_LOCATION_CODE
                                 ,'p_location_description' VALUE P_LOCATION_DESCRIPTION
                                 ,'p_scm_site_id' VALUE P_SCM_SITE_ID
                                 ,'p_plant_id' VALUE P_PLANT_ID
                                 ,'p_factory_id' VALUE P_FACTORY_ID
                                 ,'p_operation_id' VALUE P_OPERATION_ID
                                 ,'p_storage_id' VALUE P_STORAGE_ID
                                 ,'p_electrode_type' VALUE P_ELECTRODE_TYPE
                                 ,'p_valid_yn' VALUE P_VALID_YN
                                 ,'p_created_by' VALUE P_CREATED_BY);

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* 트랜잭션 (START) */
    /* ----------------------------------------------------------------------------------------- */

    /* ----------------------------------------------------------------------------------------- */
    BEGIN
        N_HISTORY_SEQ := SEQ1_SCM_MST_LOCATION_H.NEXTVAL;

        BEGIN

            BEGIN
                INSERT
                  INTO SCM_MST_LOCATION_H
                     ( HISTORY_SEQ
                     , LOCATION_SEQ
                     , DIVISION_ID
                     , LOCATION_CODE
                     , LOCATION_DESCRIPTION
                     , SCM_SITE_ID
                     , PLANT_ID
                     , FACTORY_ID
                     , OPERATION_ID
                     , STORAGE_ID
                     , ELECTRODE_TYPE
                     , VALID_YN
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     , HISTORY_CREATION_DATE )
                VALUES ( N_HISTORY_SEQ
                       , P_LOCATION_SEQ
                       , P_DIVISION_ID
                       , P_LOCATION_CODE
                       , P_LOCATION_DESCRIPTION
                       , P_SCM_SITE_ID
                       , P_PLANT_ID
                       , P_FACTORY_ID
                       , P_OPERATION_ID
                       , P_STORAGE_ID
                       , P_ELECTRODE_TYPE
                       , P_VALID_YN
                       , P_CREATED_BY
                       , SYSTIMESTAMP
                       , P_CREATED_BY
                       , SYSTIMESTAMP
                       , SYSTIMESTAMP );
            END;

        END;

    END;

    COMMIT;

    /* ----------------------------------------------------------- */
EXCEPTION
    WHEN OTHERS THEN
        /* ----------------------------------------------------------- */
        /* [C20200909-000203] LOG 표준화 적용 */
        /* 트랜잭션 (END) */
        ROLLBACK;
        /* ERROR LOG */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
        D_EVENT_DATE  := SYSTIMESTAMP;
        V_LOG_MESSAGE := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            ,'ERROR'
                            ,0
                            ,SQLERRM
                            ,NULL
                            ,SYSDATE
                            ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                            ,P_SQL_ERR_CODE  => SQLCODE
                            ,P_SQL_ERR_MSG   => SQLERRM
                            ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        /* ----------------------------------------------------------- */

        /* ----------------------------------------------------------- */
        /* 종료 LOG */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
