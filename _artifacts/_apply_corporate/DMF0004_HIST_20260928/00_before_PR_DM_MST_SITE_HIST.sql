-- SOURCE-FRESH: SCM_MGR.PR_DM_MST_SITE_HIST PROCEDURE LAST_DDL=2026-09-02 17:30:30 FETCHED=2026-09-28 20:15 DB=ZIOUI1
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
