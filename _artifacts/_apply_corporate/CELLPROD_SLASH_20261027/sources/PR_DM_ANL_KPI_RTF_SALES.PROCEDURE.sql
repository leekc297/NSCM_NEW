PROCEDURE PR_DM_ANL_KPI_RTF_SALES
(
    P_START_DATE    IN VARCHAR2
)
/*
 * Program ID   : PR_DM_ANL_KPI_RTF_SALES
 * Description  : KPI_RTF_SALES (RTF 준수율, 사업계획 달성율 정보)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021. 07. 26    JSHEO      Initial Release
 * 2022.04.05		HWI1993 GM	JV 로직 적용
 * 2025.06.23		KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 *
 */
IS
    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_DM_ANL_KPI_RTF_SALES';
    V_LOG_TYPE              VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT             NUMBER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;

    /* 변수 */
    V_START_WEEK            VARCHAR2(8 CHAR);
    V_DELETE_YYYYMM         VARCHAR2(6 CHAR);
    V_PLAN_DELETE_YYYYMM    VARCHAR2(6 CHAR);

    /* 계획 시작, 종료 구간 */
    V_PERIOD_START_DATE     VARCHAR2(8 CHAR);
BEGIN


    /* 시작 LOG  (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;      /* <- 변수 재사용을 위하여 초기화해야함 */
    /* 시작 LOG  (END) */

    /* 트랜잭션 (START)  (원본 BEGIN TRANSACTION PR_DM_ANL_KPI_RTF_SALES -> Oracle 평면 트랜잭션) */

    /*------------------------------------------------------------------------------------------*/
    BEGIN
    /*------------------------------------------------------------------------------------------*/

    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎*/
    /*                                                                                                                                                   매출계획 적확도 (START)*/
    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎*/
    BEGIN
        /* 1.1 매출 실적 I/F 기준 일자 */
        V_START_WEEK        := CASE WHEN P_START_DATE IS NULL
                                    THEN TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')                              /* 당주 월요일 */
                                    ELSE TO_CHAR(FN_NEXT_DAY(TO_DATE(P_START_DATE, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                               END;  /* 해당 일자 월요일 */

        /* 1.2 매출 삭제 시작 월 */
        V_DELETE_YYYYMM     := CASE WHEN P_START_DATE IS NULL
                                    THEN TO_CHAR(ADD_MONTHS(SYSDATE, -2), 'YYYYMM')
                                    ELSE TO_CHAR(ADD_MONTHS(TO_DATE(P_START_DATE, 'YYYYMMDD'), -2), 'YYYYMM')
                               END;  /* 당월 기준 2달 전 지난 정보 삭제 */

        /* 1.3 RTF, BP 삭제 시작 월 */
        V_PLAN_DELETE_YYYYMM := CASE WHEN P_START_DATE IS NULL
                                     THEN TO_CHAR(SYSDATE, 'YYYYMM')
                                     ELSE TO_CHAR(TO_DATE(P_START_DATE, 'YYYYMMDD'), 'YYYYMM')
                                END;  /* 당월 정보 삭제 */

        /* 1.4 RTF 버전 및 계획 삭제, 시작 일자 */
        V_PERIOD_START_DATE := CASE WHEN P_START_DATE IS NULL
                                    THEN TO_CHAR(SYSDATE, 'YYYYMM') || '01'
                                    ELSE TO_CHAR(TO_DATE(P_START_DATE, 'YYYYMMDD'), 'YYYYMM') || '01'
                               END;  /* 계획 시작 구간. */

        /* 2.1 매출 삭제 */
        DELETE
          FROM DM_ANL_KPI_RTF_SALES
         WHERE YYYYMM >= V_DELETE_YYYYMM
           AND MEASURE = 'SALES';

        /* 2.2 RTF, BP  삭제 */
        DELETE
          FROM DM_ANL_KPI_RTF_SALES
         WHERE YYYYMM >= V_PLAN_DELETE_YYYYMM
           AND MEASURE IN ('RTF', 'BP');

        INSERT
          INTO DM_ANL_KPI_RTF_SALES
             ( DIVISION_ID
             , ITEM_ID
             , FCST_TYPE
             , YYYYMM
             , MEASURE
             , QTY
             , ACC_QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        WITH PLAN_AND_RESULT AS
        (
            /* BP CUTOFF 정보 */
            SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.FCST_TYPE
                 , A.YYYYMMDD
                 , A.QTY QTY
                 , CASE WHEN A.YYYYMMDD >= V_START_WEEK THEN A.QTY ELSE 0 END ACC_QTY
                 , 'BP' MEASURE
              FROM DM_PLN_SALES_PLAN_C A
                 , ( SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
                       FROM ( SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ
                                   , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ
                                FROM DM_MST_VERSION
                               WHERE VERSION_TYPE = 'SP_W'
                                 AND YYYYMMDD < V_PERIOD_START_DATE
                            ) A
                      WHERE A.SEQ = 1
                   ) B
             WHERE A.DIVISION_ID = B.DIVISION_ID
               AND A.VERSION_NO = B.VERSION_NO
               AND A.YYYYMMDD >= V_PERIOD_START_DATE
               AND A.MEASURE = 'RTF_SYS_RP'
               AND A.QTY >= 0

            UNION ALL

            /* RTF CUTOFF 정보 */
            SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.FCST_TYPE
                 , A.YYYYMMDD
                 , A.QTY QTY
                 , CASE WHEN A.YYYYMMDD >= V_START_WEEK THEN A.QTY ELSE 0 END ACC_QTY
                 , 'RTF' MEASURE
              FROM DM_PLN_SALES_PLAN_C A
                 , ( SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
                       FROM ( SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ
                                   , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ
                                FROM DM_MST_VERSION
                               WHERE VERSION_TYPE = 'SP_W'
                                 AND YYYYMMDD < V_PERIOD_START_DATE
                            ) A
                      WHERE A.SEQ = 1
                   ) B
             WHERE A.DIVISION_ID = B.DIVISION_ID
               AND A.VERSION_NO = B.VERSION_NO
               AND A.YYYYMMDD >= V_PERIOD_START_DATE
               AND A.MEASURE = 'RTF_SYS_RP'
               AND A.QTY >= 0

            UNION ALL

            /* 매출 실적 */
            SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.FCST_TYPE
                 , A.YYYYMMDD
                 /*-------------------------------------------------------------------------------------------------------------------------------*/
                 /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_SALES_PLAN_RESULT에 CELL_PROD_SITE_ID가 추가됨에 따라 SUM 처리 필요) */

                 /* , CASE WHEN A.YYYYMMDD < V_START_WEEK THEN A.QTY ELSE 0 END  ACC_QTY */
                 , SUM(A.QTY) QTY
                 , CASE WHEN A.YYYYMMDD < V_START_WEEK THEN SUM(A.QTY) ELSE 0 END ACC_QTY
                 /*-------------------------------------------------------------------------------------------------------------------------------*/
                 , 'SALES' MEASURE
              FROM DM_PLN_SALES_PLAN_RESULT A
             WHERE A.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ('40', '81', '82'))
               AND A.MEASURE = 'RTF_SYS_RP'   /* 20191121 KHSONG 'RTF_SYS_RP' MEASURE 추가전송 */
               AND YYYYMMDD >= V_DELETE_YYYYMM || '01'
               AND YYYYMMDD < V_START_WEEK
             /*-------------------------------------------------------------------------------------------------------------------------------*/
             /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_SALES_PLAN_RESULT에 CELL_PROD_SITE_ID가 추가됨에 따라 SUM 처리 필요) */
             GROUP BY A.DIVISION_ID
                    , A.ITEM_ID
                    , A.FCST_TYPE
                    , A.YYYYMMDD
             /*-------------------------------------------------------------------------------------------------------------------------------*/
        )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.FCST_TYPE
             , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
             , A.MEASURE
             , SUM(QTY) AS QTY
             , SUM(ACC_QTY) AS ACC_QTY
             , 'KPI_RTF_SALES' AS CREATED_BY
             , SYSDATE AS CREATION_DATE
             , 'KPI_RTF_SALES' AS LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
          FROM PLAN_AND_RESULT A
         WHERE A.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ('40', '81', '82'))
         GROUP
            BY A.DIVISION_ID
             , A.ITEM_ID
             , A.FCST_TYPE
             , SUBSTR(A.YYYYMMDD, 1, 6)
             , A.MEASURE
        ;

        /* RTF 준수율 KPI 재생성을 위한 추가 필드 */
        /* 대표코드/대표Nick_Name/Biz Type/Class Name/SCM User. (2021.07.22 hjs) */
        MERGE INTO DM_ANL_KPI_RTF_SALES A
        USING ( SELECT DIVISION_ID, ITEM_ID, DOE, BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME, MAX(SCM_PIC) AS SCM_PIC
                  FROM ( SELECT DIVISION_ID, ITEM_ID, NVL(DOE, ITEM_ID) AS DOE, SCP_EXTRA_SPEC, SCM_PIC, ITEM_CLASS_NAME
                              , ( SELECT NVL(NULLIF(B.NICK_NAME, ''), '-')
                                    FROM SCM_MST_ITEM_SN B
                                   WHERE 1 = 1
                                     AND B.DIVISION_ID = A.DIVISION_ID
                                     AND B.ITEM_ID = NVL(A.DOE, A.ITEM_ID)
                                     AND ROWNUM = 1
                                ) AS BASIC_NICK_NAME
                              , ( SELECT SEGMENT2
                                    FROM SCM_ADM_LOOKUP_MASTER_DETAIL C
                                   WHERE C.LOOKUP_TYPE = 'OPERATION_GROUP'
                                     AND C.SEGMENT1 = (SELECT FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, NVL(A.DOE, A.ITEM_ID)) FROM DUAL)
                                ) AS GROUP_TYPE
                           FROM SCM_MST_ITEM_SN A
                          WHERE DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ('40', '81', '82'))
                       ) IA
                 GROUP BY DIVISION_ID, ITEM_ID, DOE, BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME
              ) B
           ON (
                        A.YYYYMM        >= V_DELETE_YYYYMM
                    AND A.DIVISION_ID   = B.DIVISION_ID
                    AND A.ITEM_ID       = B.ITEM_ID
                  )
        WHEN MATCHED THEN
        UPDATE SET A.DOE = B.DOE
                 , A.BASIC_NICK_NAME = B.BASIC_NICK_NAME
                 , A.GROUP_TYPE      = B.GROUP_TYPE
                 , A.ITEM_CLASS_NAME = B.ITEM_CLASS_NAME
                 , A.SCM_PIC         = B.SCM_PIC
                 , A.ACCUMULATED_CHILD_QTY = NVL((SELECT MAX(ACCUMULATED_CHILD_QTY) AS CELL_QTY
                                                       FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V  C
                                                       WHERE  C.DIVISION_ID  = B.DIVISION_ID
                                                       AND    C.MODEL_ID     = B.ITEM_ID
                                                       AND    C.OPERATION_GROUP_ID = 'A'
                                                       AND    B.GROUP_TYPE   = 'Pack'
                                                     ), 1)
                 , A.QTY_CELL = A.QTY *
                                               NVL((SELECT MAX(ACCUMULATED_CHILD_QTY) AS CELL_QTY
                                                       FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V  C
                                                       WHERE  C.DIVISION_ID  = B.DIVISION_ID
                                                       AND    C.MODEL_ID     = B.ITEM_ID
                                                       AND    C.OPERATION_GROUP_ID = 'A'
                                                       AND    B.GROUP_TYPE   = 'Pack'
                                                     ), 1)
                 , A.ACC_QTY_CELL = A.ACC_QTY *
                                               NVL((SELECT MAX(ACCUMULATED_CHILD_QTY) AS CELL_QTY
                                                       FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V  C
                                                       WHERE  C.DIVISION_ID  = B.DIVISION_ID
                                                       AND    C.MODEL_ID     = B.ITEM_ID
                                                       AND    C.OPERATION_GROUP_ID = 'A'
                                                       AND    B.GROUP_TYPE   = 'Pack'
                                                     ), 1)

                                                     ;


        /* 자동차 사업부 : Pack Group 정보 Update 로직 추가 (2021.09.16 hjs) */
        MERGE INTO DM_ANL_KPI_RTF_SALES A
        USING ( SELECT DIVISION_ID, ITEM_ID, MAX(GROUP_CODE2) AS GROUP_CODE2
                  FROM SCP_MST_FINAL_ITEM
                 WHERE DIVISION_ID LIKE '81%'
                   AND GROUP_CODE2 IS NOT NULL
                 GROUP BY DIVISION_ID, ITEM_ID
              ) B
           ON (
                        A.YYYYMM        >= V_DELETE_YYYYMM
                    AND A.DIVISION_ID   = B.DIVISION_ID
                    AND A.ITEM_ID       = B.ITEM_ID
                  )
        WHEN MATCHED THEN
        UPDATE SET A.DOE             = B.GROUP_CODE2
                 , A.BASIC_NICK_NAME = B.GROUP_CODE2  ;

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
        /* 트랜잭션 (END)  (원본 ROLLBACK TRANSACTION PR_DM_ANL_KPI_RTF_SALES) */
        ROLLBACK;

        /* ERROR LOG VALUE SAVE */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;

        DBMS_OUTPUT.PUT_LINE('[' || SQLCODE || ']' || SQLERRM);   /* 에러메시지 DISPLAY */

        /* [C20200909-000203] LOG 표준화 적용 */

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                           , JSON_OBJECT('p_start_date' VALUE P_START_DATE RETURNING VARCHAR2(4000 CHAR))
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