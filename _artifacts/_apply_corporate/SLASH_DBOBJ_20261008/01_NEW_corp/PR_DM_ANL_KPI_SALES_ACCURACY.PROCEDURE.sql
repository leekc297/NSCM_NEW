PROCEDURE           "PR_DM_ANL_KPI_SALES_ACCURACY" 
/*
 * Program ID   : PR_DM_ANL_KPI_SALES_ACCURACY
 * Description  : KPI_SALES_ACCURACY (매출계획 적확도/전월 마지막에 짠 당월 RTF 대비 당월 실적 값의 비율)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 09. 21    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20181213 add SUM(RESULT_QTY) < 0 THEN 0
 * 20181214 RTF 음수값 제외처리 (sp.qty >= 0)
 * 20190121        KHSONG      FCST 상관없이 실적을 구함.
 * 20191121 KHSONG 'RTF_SYS_RP' MEASURE 추가전송
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2022.04.05   HWI1993		GM JV 로직 적용
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 *
 */
IS
    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_DM_ANL_KPI_SALES_ACCURACY';
    V_LOG_TYPE              VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT             NUMBER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;

    /* 변수 */
    V_YYYYMMDD              VARCHAR2(8 CHAR);
BEGIN


    V_YYYYMMDD := TO_CHAR(SYSDATE, 'YYYYMMDD');

    /* 시작 LOG  (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;      /* <- 변수 재사용을 위하여 초기화해야함 */
    /* 시작 LOG  (END) */

    /* 트랜잭션 (START)  (원본 BEGIN TRANSACTION PR_DM_ANL_KPI_SALES_ACCURACY -> Oracle 평면 트랜잭션) */

    /*------------------------------------------------------------------------------------------*/
    BEGIN
    /*------------------------------------------------------------------------------------------*/

    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎*/
    /*                                                                                                                                                   매출계획 적확도 (START)*/
    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎*/
    BEGIN
        /* INSERT 수행전 당일중복값 삭제 */
        DELETE
          FROM DM_ANL_KPI_SALES_ACCURACY
         WHERE WORK_YYYYMMDD = V_YYYYMMDD;

        INSERT
          INTO DM_ANL_KPI_SALES_ACCURACY
             ( WORK_YYYYMMDD
             , DIVISION_ID
             , DEPT_ID
             , END_CUSTOMER
             , SCM_SITE_ID
             , PROJECT_CODE
             , ITEM_ID
             , FCST_TYPE
             , YYYYMM
             , RESULT_QTY
             , MEASURE
             , WEIGHT
             , KPI_RATE
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
             , ATTRIBUTE10 )
        WITH SALESPLAN_ACCURACY AS
        (
            /* 금액은 KRW 기준? Currency를 쓰긴 어려우니... */
            SELECT A.DIVISION_ID
                 , A.SCM_SITE_ID
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.FCST_TYPE
                 , A.YYYYMMDD
                 , A.QTY PLAN_QTY
                 , 0 RESULT_QTY
                 , A.MEASURE
              FROM DM_PLN_SALES_PLAN_C A
                 , ( SELECT DIVISION_ID
                          , SUBSTR(YYYYMMDD, 1, 6) MONTHS
                          , MAX(VERSION_NO) VERSION_NO
                       FROM DM_MST_VERSION
                      WHERE VERSION_TYPE = 'SP_W'
                      GROUP BY DIVISION_ID, SUBSTR(YYYYMMDD, 1, 6)
                   ) B
             WHERE A.DIVISION_ID = B.DIVISION_ID
               AND A.VERSION_NO = B.VERSION_NO
               AND SUBSTR(A.YYYYMMDD, 1, 6) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(B.MONTHS || '01', 'YYYYMMDD'), 1), 'YYYYMMDD'), 1, 6)
               AND A.MEASURE IN ('RTF', 'SalesAmt_KRW', 'RTF_SYS_RP')   /* 20191121 KHSONG 'RTF_SYS_RP' MEASURE 추가전송 */
               AND A.QTY >= 0   /* 20181214 RTF 음수값 제외처리 (sp.qty >= 0) */
        )
        , PLAN_AND_RESULT AS
        (
            SELECT *
              FROM SALESPLAN_ACCURACY

            UNION ALL

            /* FCST 상관없이 실적을 구함. 20190121 추가 */
            SELECT A.DIVISION_ID
                 , A.SCM_SITE_ID
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.FCST_TYPE
                 , A.YYYYMMDD
                 , 0 PLAN_QTY
                 /*-------------------------------------------------------------------------------------------------------------------------------*/
                 /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (dm_pln_sales_plan_result에 CELL_PROD_SITE_ID가 추가됨에 따라 SUM 처리 필요) */
                 /* , A.QTY  RESULT_QTY */
                 , SUM(A.QTY) RESULT_QTY
                 /*-------------------------------------------------------------------------------------------------------------------------------*/
                 , A.MEASURE
              FROM DM_PLN_SALES_PLAN_RESULT A
                 , ( SELECT DISTINCT DIVISION_ID
                          , SUBSTR(YYYYMMDD, 1, 6) MONTHS
                       FROM SALESPLAN_ACCURACY
                   ) B
             WHERE A.DIVISION_ID = B.DIVISION_ID

               AND SUBSTR(A.YYYYMMDD, 1, 6) = B.MONTHS
               AND A.MEASURE IN ('RTF', 'SalesAmt_KRW', 'RTF_SYS_RP')   /* 20191121 KHSONG 'RTF_SYS_RP' MEASURE 추가전송 */
               /* AND A.QTY >= 0   20181214 RTF 음수값 제외처리 (sp.qty >= 0) */
               /* modified by ytchoi 181116 Data 검증이 용이하기 위해서 전주까지의 실적을 가지도록 함. */
               AND A.YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
             /*-------------------------------------------------------------------------------------------------------------------------------*/
             /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (dm_pln_sales_plan_result에 CELL_PROD_SITE_ID가 추가됨에 따라 SUM 처리 필요) */
             GROUP BY A.DIVISION_ID
                    , A.SCM_SITE_ID
                    , A.PROJECT_CODE
                    , A.ITEM_ID
                    , A.FCST_TYPE
                    , A.YYYYMMDD
                    , A.MEASURE
             /*-------------------------------------------------------------------------------------------------------------------------------*/
        )
        /*		-- 실적은 FCST가 있는것 기준으로 값을 구함. 20190121 주석처리
        select  sp.[DIVISION_ID]
               ,sp.[SCM_SITE_ID]
               ,sp.[PROJECT_CODE]
               ,sp.[ITEM_ID]
               ,sp.[FCST_TYPE]
               ,sp.YYYYMMDD
               ,0       plan_qty
               ,sp.qty  result_qty
              ,[MEASURE]
          from dm_pln_sales_plan_result sp WITH(NOLOCK)
              ,(
           select distinct division_id, scm_site_id, project_code, item_id, fcst_type, SUBSTRING( yyyymmdd, 1,6 ) months
             from salesplan_accuracy
            ) target_key
         where sp.measure				in ( 'RTF' , 'SalesAmt_KRW' )
           and sp.DIVISION_ID			= target_key.DIVISION_ID
           and sp.SCM_SITE_ID			= target_key.scm_site_id
           and sp.PROJECT_CODE			= target_key.PROJECT_CODE
           and sp.ITEM_ID				= target_key.ITEM_ID
           and sp.fcst_type				= target_key.fcst_type
           and SUBSTRING(YYYYMMDD, 1,6) = target_key.months
           -- modified by ytchoi 181116 Data 검증이 용이하기 위해서 전주까지의 실적을 가지도록 함.
           and yyyymmdd                 < CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
           )
        */
        SELECT V_YYYYMMDD
             , A.DIVISION_ID
--             , CASE WHEN A.DIVISION_ID = '40' THEN D.DEPT_ID ELSE B.DEPT_ID END DEPT_ID
             , C.DEPT_ID DEPT_ID                                                        -- 2026.09.03 AJS
             , CASE WHEN A.DIVISION_ID = '40' THEN NVL(C.PROJECT_CODE, '/') ELSE NVL(B.END_CUSTOMER, '-') END END_CUSTOMER
             , A.SCM_SITE_ID
             , A.PROJECT_CODE
             , A.ITEM_ID
             , A.FCST_TYPE
             , SUBSTR(A.YYYYMMDD, 1, 6) YYYYMM
             , SUM(A.RESULT_QTY) RESULT_QTY
             , A.MEASURE
             , SUM(A.PLAN_QTY) WEIGHT
             /* , CASE WHEN SUM(PLAN_QTY) = 0 THEN 0 WHEN SUM(RESULT_QTY)/SUM(PLAN_QTY) > 1 THEN 1 ELSE SUM(RESULT_QTY)/SUM(PLAN_QTY) END KPI_RATE */
             /* 20181213 add SUM(RESULT_QTY) < 0 THEN 0 */
             , CASE WHEN SUM(A.PLAN_QTY) = 0 THEN 0
                    WHEN SUM(A.RESULT_QTY) < 0 THEN 0
                    WHEN ABS(SUM(A.RESULT_QTY) - SUM(A.PLAN_QTY)) / SUM(A.PLAN_QTY) > 1 THEN 1
                    ELSE 1 - ABS(SUM(A.RESULT_QTY) - SUM(A.PLAN_QTY)) / SUM(A.PLAN_QTY)
               END KPI_RATE
             , 'KPI_SALES_ACCURACY'   /* CREATED_BY */
             , SYSDATE
             , 'KPI_SALES_ACCURACY'   /* LAST_UPDATED_BY */
             , SYSDATE
             , NULL   /* ATTRIBUTE1 */
             , NULL   /* ATTRIBUTE2 */
             , NULL   /* ATTRIBUTE3 */
             , NULL   /* ATTRIBUTE4 */
             , NULL   /* ATTRIBUTE5 */
             , NULL   /* ATTRIBUTE6 */
             , NULL   /* ATTRIBUTE7 */
             , NULL   /* ATTRIBUTE8 */
             , NULL   /* ATTRIBUTE9 */
             , NULL   /* ATTRIBUTE10 */
          FROM PLAN_AND_RESULT A
             , SCM_MST_SITE B
             , SCM_MST_SITE_ITEM C
--             , SCM_MST_SSO_USER_INFO D                                                                                                     -- 2026.09.06 AJS
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.SCM_SITE_ID = B.SCM_SITE_ID
           AND B.VALID_YN = 'Y'
           AND A.DIVISION_ID = C.DIVISION_ID(+)
           AND A.PROJECT_CODE = C.PROJECT_CODE(+)
           AND A.SCM_SITE_ID = C.SCM_SITE_ID(+)
           AND A.ITEM_ID = C.ITEM_ID(+)
           AND C.VALID_YN(+) = 'Y'
--           AND SUBSTR(C.OWNER, 1, CASE WHEN INSTR(C.OWNER, ',') = 0 THEN LENGTH(C.OWNER) ELSE INSTR(C.OWNER, ',') - 1 END) = D.USER_ID(+)   -- 2026.09.06 AJS
           AND A.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ('40', '81', '82'))
         GROUP BY A.DIVISION_ID
--                , CASE WHEN A.DIVISION_ID = '40' THEN D.DEPT_ID ELSE B.DEPT_ID END
                , C.DEPT_ID                                                             -- 2026.09.03 AJS
                , CASE WHEN A.DIVISION_ID = '40' THEN NVL(C.PROJECT_CODE, '/') ELSE NVL(B.END_CUSTOMER, '-') END
                , A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.FCST_TYPE
                , SUBSTR(A.YYYYMMDD, 1, 6)
                , A.MEASURE
        ;

    END;
    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎*/
    /*                                                                                                                                                   매출계획 적확도 (END)*/
    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎*/

    /* 트랜잭션 (COMMIT) */
        COMMIT;

    /*------------------------------------------------------------------------------------------*/
    EXCEPTION
    /*------------------------------------------------------------------------------------------*/
    WHEN OTHERS THEN
        /* 트랜잭션 (END)  (원본 ROLLBACK TRANSACTION PR_DM_ANL_KPI_SALES_ACCURACY) */
        ROLLBACK;

        /* ERROR LOG VALUE SAVE */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;

        DBMS_OUTPUT.PUT_LINE('[' || SQLCODE || ']' || SQLERRM);   /* 에러메시지 DISPLAY */

        /* [C20200909-000203] LOG 표준화 적용 */


        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                           , NULL
                           , SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END;

    /* 수행결과 성공여부 DISPLAY */
    IF V_LOG_MESSAGE IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('success');
    END IF;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END;