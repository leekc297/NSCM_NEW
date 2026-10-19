-- 롤백 전용: standalone HIST 3종 본문 + GRANT + SCMP_APP 시노님 복원 (사내 원문 · 권한 = 사내 실측 RL_SCM_DML EXECUTE/DEBUG · RL_SCM_SEL EXECUTE · SCMP_APP EXECUTE)
CREATE OR REPLACE PROCEDURE           "PR_DM_MST_SITE_HIST" 
(
      P_DIVISION_ID        IN VARCHAR2
    , P_SCM_SITE_ID        IN VARCHAR2
    , P_SITE_DESCRIPTION   IN VARCHAR2
    , P_SITE_TYPE          IN VARCHAR2
    , P_CITY               IN VARCHAR2
    , P_COUNTRY            IN VARCHAR2
    , P_PLANT_ID           IN VARCHAR2
    , P_OPERATION_GROUP    IN VARCHAR2
    , P_DEPT_ID            IN VARCHAR2
    , P_VMI_YN             IN VARCHAR2
    , P_VALID_YN           IN VARCHAR2
    , P_NEW_YN             IN VARCHAR2
    , P_SITE_HRCY_ID       IN VARCHAR2
    , P_OSP_YN             IN VARCHAR2
    , P_SHIP_FROZEN        IN VARCHAR2
    , P_PROD_FROZEN        IN VARCHAR2
    , P_END_CUSTOMER       IN VARCHAR2
    , P_SOLDTO_CUSTOMER    IN VARCHAR2
    , P_FP_PLAN_PERIOD     IN VARCHAR2
    , P_BUILD_AHEAD        IN VARCHAR2
    , P_LOGISTIC_PLANT_ID  IN VARCHAR2
    , P_COMPANY_ID         IN VARCHAR2
    , P_SITE_ID            IN VARCHAR2
    , P_CREATED_BY         IN VARCHAR2
    , P_LAST_UPDATED_BY    IN VARCHAR2
    , P_ATTRIBUTE1         IN VARCHAR2
    , P_ATTRIBUTE2         IN VARCHAR2
    , P_ATTRIBUTE3         IN VARCHAR2   /* [PJ20200138] */
    , P_ATTRIBUTE5         IN VARCHAR2   /* [PJ20200138] */
)
/*
 * Program ID   : PR_DM_MST_SITE_HIST
 * Description  : Site Master History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.25   okaniel      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.03.26   KHSONG       modify
 * 20200306 hwi1993 [CSR:C20200303-000235 ] Ship plan Auto 추가 ( Attribute2 컬럼 사용 ) 에 따라 Attribute2 추가
 * 2020/04/22  P.C.I         [PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선-유통경로 추가(Attribute3)
 * 2020/11/11  hwi1993       SI mkt fcst 입력시 vmi req 자동 산출. site 별로 vmi 재고일수 추가 ( attribute5)
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 */
AS

    N_HISTORY_SEQ    INTEGER;

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME   VARCHAR2(150 CHAR) := 'PR_DM_MST_SITE_HIST';
    V_LOG_TYPE       VARCHAR2(30 CHAR);       /* START/END/ERROR/... */
    N_LOG_COUNT      INTEGER := 0;
    V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
    V_DESCRIPTION    VARCHAR2(500 CHAR);
    D_EVENT_DATE     DATE;
    V_IN_PARA_DATA   VARCHAR2(4000 CHAR);

BEGIN

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    N_HISTORY_SEQ := SEQ1_SCM_MST_SITE_H.NEXTVAL;

    INSERT
      INTO SCM_MST_SITE_H
         ( HISTORY_SEQ
         , DIVISION_ID
         , SCM_SITE_ID
         , SITE_DESCRIPTION
         , SITE_TYPE
         , CITY
         , COUNTRY
         , PLANT_ID
         , OPERATION_GROUP
         , DEPT_ID
         , VMI_YN
         , VALID_YN
         , NEW_YN
         , SITE_HRCY_ID
         , OSP_YN
         , SHIP_FROZEN
         , PROD_FROZEN
         , END_CUSTOMER
         , SOLDTO_CUSTOMER
         , FP_PLAN_PERIOD
         , BUILD_AHEAD
         , LOGISTIC_PLANT_ID
         , COMPANY_ID
         , SITE_ID
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE
         , ATTRIBUTE1
         , ATTRIBUTE2
         , ATTRIBUTE3
         , ATTRIBUTE4
         , ATTRIBUTE5
         , ATTRIBUTE6
         , ATTRIBUTE7
         , ATTRIBUTE8
         , ATTRIBUTE9
         , ATTRIBUTE10
         , HISTORY_CREATION_DATE )
    VALUES ( N_HISTORY_SEQ
           , P_DIVISION_ID
           , P_SCM_SITE_ID
           , P_SITE_DESCRIPTION
           , P_SITE_TYPE
           , P_CITY
           , P_COUNTRY
           , P_PLANT_ID
           , P_OPERATION_GROUP
           , P_DEPT_ID
           , P_VMI_YN
           , P_VALID_YN
           , P_NEW_YN
           , P_SITE_HRCY_ID
           , P_OSP_YN
           , P_SHIP_FROZEN
           , P_PROD_FROZEN
           , P_END_CUSTOMER
           , P_SOLDTO_CUSTOMER
           , P_FP_PLAN_PERIOD
           , P_BUILD_AHEAD
           , P_LOGISTIC_PLANT_ID
           , P_COMPANY_ID
           , P_SITE_ID
           , P_CREATED_BY
           , SYSDATE
           , P_LAST_UPDATED_BY
           , SYSDATE
           /* [PJ20200138] 유통경로 추가(Attribute3) */
           , P_ATTRIBUTE1
           , P_ATTRIBUTE2
           , P_ATTRIBUTE3
           , NULL
           , P_ATTRIBUTE5
           , NULL
           , NULL
           , NULL
           , NULL
           , NULL
           , SYSDATE );

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

EXCEPTION
    WHEN OTHERS THEN
        V_IN_PARA_DATA := JSON_OBJECT(
                                'p_division_id'       VALUE P_DIVISION_ID
                              , 'p_scm_site_id'       VALUE P_SCM_SITE_ID
                              , 'p_site_description'  VALUE P_SITE_DESCRIPTION
                              , 'p_site_type'         VALUE P_SITE_TYPE
                              , 'p_city'              VALUE P_CITY
                              , 'p_country'           VALUE P_COUNTRY
                              , 'p_plant_id'          VALUE P_PLANT_ID
                              , 'p_operation_group'   VALUE P_OPERATION_GROUP
                              , 'p_dept_id'           VALUE P_DEPT_ID
                              , 'p_vmi_yn'            VALUE P_VMI_YN
                              , 'p_valid_yn'          VALUE P_VALID_YN
                              , 'p_new_yn'            VALUE P_NEW_YN
                              , 'p_site_hrcy_id'      VALUE P_SITE_HRCY_ID
                              , 'p_osp_yn'            VALUE P_OSP_YN
                              , 'p_ship_frozen'       VALUE P_SHIP_FROZEN
                              , 'p_prod_frozen'       VALUE P_PROD_FROZEN
                              , 'p_end_customer'      VALUE P_END_CUSTOMER
                              , 'p_soldto_customer'   VALUE P_SOLDTO_CUSTOMER
                              , 'p_fp_plan_period'    VALUE P_FP_PLAN_PERIOD
                              , 'p_build_ahead'       VALUE P_BUILD_AHEAD
                              , 'p_logistic_plant_id' VALUE P_LOGISTIC_PLANT_ID
                              , 'p_company_id'        VALUE P_COMPANY_ID
                              , 'p_site_id'           VALUE P_SITE_ID
                              , 'p_created_by'        VALUE P_CREATED_BY
                              , 'p_last_updated_by'   VALUE P_LAST_UPDATED_BY
                              , 'p_attribute1'        VALUE P_ATTRIBUTE1
                              , 'p_attribute2'        VALUE P_ATTRIBUTE2
                              , 'p_attribute3'        VALUE P_ATTRIBUTE3
                              , 'p_attribute5'        VALUE P_ATTRIBUTE5
                                RETURNING VARCHAR2(4000 CHAR) );

        /* ERROR LOG */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                            , V_IN_PARA_DATA, TO_CHAR(SQLCODE), SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        RAISE_APPLICATION_ERROR(-20001, '[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM);
END;
/
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_SITE_HIST TO RL_SCM_DML;
GRANT DEBUG ON SCM_MGR.PR_DM_MST_SITE_HIST TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_SITE_HIST TO RL_SCM_SEL;
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_SITE_HIST TO SCMP_APP;
CREATE OR REPLACE SYNONYM SCMP_APP.PR_DM_MST_SITE_HIST FOR SCM_MGR.PR_DM_MST_SITE_HIST;
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
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_SITE_SLOC_MAPPING_HIST TO RL_SCM_DML;
GRANT DEBUG ON SCM_MGR.PR_DM_MST_SITE_SLOC_MAPPING_HIST TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_SITE_SLOC_MAPPING_HIST TO RL_SCM_SEL;
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_SITE_SLOC_MAPPING_HIST TO SCMP_APP;
CREATE OR REPLACE SYNONYM SCMP_APP.PR_DM_MST_SITE_SLOC_MAPPING_HIST FOR SCM_MGR.PR_DM_MST_SITE_SLOC_MAPPING_HIST;
CREATE OR REPLACE PROCEDURE           "PR_DM_MST_BUCKET_CONVERSION_HIST" 
(
    P_DIVISION_ID     VARCHAR2
   ,P_SCM_SITE_ID     VARCHAR2
   ,P_INCOTERMS       VARCHAR2
   ,P_YYYYMMDD        VARCHAR2
   ,P_BUCKET_PER      VARCHAR2
   ,P_CONVERSION_TYPE VARCHAR2
   ,P_CREATED_BY      VARCHAR2
    -- 자식 프로시저 성공/에러 셋팅
    --p_OK_description     OUT VARCHAR2
)
/*
    * Program ID   : PR_DM_MST_BUCKET_CONVERSION_HIST
    * Description  : PR_DM_MST_BUCKET_CONVERSION_HIST History
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    * 2018.01.25   okaniel      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
    * 2020/09/09     P.C.I     [C20200909-000203] LOG 표준화 적용
    * 2026-03-23   김준규        [PJ20264226] NextSCM Pilot 설계 및 개발
    *
    */
 AS

    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE     VARCHAR2(30 CHAR);
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    N_HISTORY_SEQ  INTEGER;
    V_IN_PARA_DATA CLOB;
    V_STEP         VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    -- LOG 용 변수 설정
    -- 시작 LOG
    V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                 ,'p_scm_site_id' VALUE P_SCM_SITE_ID
                                 ,'p_Incoterms' VALUE P_INCOTERMS
                                 ,'p_yyyymmdd' VALUE P_YYYYMMDD
                                 ,'p_bucket_per' VALUE P_BUCKET_PER
                                 ,'p_conversion_type' VALUE P_CONVERSION_TYPE
                                 ,'p_created_by' VALUE P_CREATED_BY);
    V_LOG_TYPE     := 'START';
    V_LOG_MESSAGE  := '########## Start of procedure ##########';
    V_DESCRIPTION  := NULL;
    D_EVENT_DATE   := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    -- 트랜잭션 (START)
    -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        N_HISTORY_SEQ := SEQ1_DM_MST_BUCKET_CONVERSION_H.NEXTVAL;

        BEGIN

            INSERT INTO DM_MST_BUCKET_CONVERSION_H
                (DIVISION_ID
                ,HISTORY_SEQ
                ,SCM_SITE_ID
                ,PROJECT_CODE
                ,INCOTERMS
                ,ITEM_ID
                ,YYYYMMDD
                ,BUCKET_PER
                ,CONVERSION_TYPE
                ,VALID_YN
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE)
            VALUES
                (P_DIVISION_ID
                ,N_HISTORY_SEQ
                ,P_SCM_SITE_ID
                ,'***'
                ,P_INCOTERMS
                ,'***'
                ,P_YYYYMMDD
                ,P_BUCKET_PER
                ,P_CONVERSION_TYPE
                ,'Y'
                ,P_CREATED_BY
                ,SYSTIMESTAMP
                ,P_CREATED_BY
                ,SYSTIMESTAMP);

        END;

    END;

    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    --p_OK_description := 'OK';     -- 정상적인 로그처리 됐을때 'OK'를 셋팅한다
    --RETURN;
    COMMIT;

    -- END TRY

    -- -----------------------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        -- -----------------------------------------------------------
        --[C20200909-000203] LOG 표준화 적용
        -- 트랜잭션 (END)
        ROLLBACK;
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
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_BUCKET_CONVERSION_HIST TO RL_SCM_DML;
GRANT DEBUG ON SCM_MGR.PR_DM_MST_BUCKET_CONVERSION_HIST TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_BUCKET_CONVERSION_HIST TO RL_SCM_SEL;
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_BUCKET_CONVERSION_HIST TO SCMP_APP;
CREATE OR REPLACE SYNONYM SCMP_APP.PR_DM_MST_BUCKET_CONVERSION_HIST FOR SCM_MGR.PR_DM_MST_BUCKET_CONVERSION_HIST;
