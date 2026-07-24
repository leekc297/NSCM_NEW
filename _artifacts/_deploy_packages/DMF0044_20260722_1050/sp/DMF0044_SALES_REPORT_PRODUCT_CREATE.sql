CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_SALES_REPORT_PRODUCT_CREATE" 
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_ACTION_TYPE       IN  VARCHAR2,   -- T:Transfer, C:Cancel
    P_YYYY              IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SALES_REPORT_PRODUCT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191113 KYH 팩일 경우 QTY 조정
 * 20191118 hwi1993 파라미터 추가 및 데이터타입 변경, Cancel 기능 추가
 * 20200512 hwi1993 ETC 매출 테이블 추가
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2026/06/05	NextSCM Migration	[PJ202650304] 기존 배포본(미완성 자동변환, INVALID) 재변환. CURSOR 루프→3개년 CROSS JOIN, #TEMP_REPORT_C→인라인, GETDATE→SYSDATE, 로깅/EXCEPTION/O_RESULT_CURSOR 표준 적용. 템플릿=DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE(VALID)
 */
IS
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;

    -- local 변수선언
    v_user_id           VARCHAR2(10 CHAR) := 'mdf_batch';

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -----------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT
    WHERE  DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    n_delete_count := SQL%ROWCOUNT;
    -----------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
    -----------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------
    IF P_ACTION_TYPE = 'T' THEN -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        -- CURSOR 루프(yyyy-1, yyyy, yyyy+1) 대신 3개 연도 CROSS JOIN 으로 한번에 처리
        INSERT INTO SCM_MGR.DM_MOBILE_REPORT_PRODUCT
             ( DIVISION_ID
             , VERSION_NO
             , YYYY
             , SP_BP_TYPE
             , PRODUCT_NAME
             , PRODUCT_DETAIL
             , MEASURE
             , MM01, MM02, MM03, MM04, MM05, MM06, MM07, MM08, MM09, MM10, MM11, MM12
             , ORI_VERSION_NO
             , SORT_NO
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT A.DIVISION_ID
             , P_VERSION_NO AS VERSION_NO
             , Y.YYYY        AS YYYY
             , 'SP'          AS SP_BP_TYPE
             , A.PRODUCT_GROUP AS PRODUCT_NAME
             , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'')
                    WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'')
                    ELSE ''
               END           AS PRODUCT_DETAIL
             , A.MEASURE
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '01' THEN A.QTY ELSE 0 END) AS MM01
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '02' THEN A.QTY ELSE 0 END) AS MM02
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '03' THEN A.QTY ELSE 0 END) AS MM03
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '04' THEN A.QTY ELSE 0 END) AS MM04
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '05' THEN A.QTY ELSE 0 END) AS MM05
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '06' THEN A.QTY ELSE 0 END) AS MM06
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '07' THEN A.QTY ELSE 0 END) AS MM07
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '08' THEN A.QTY ELSE 0 END) AS MM08
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '09' THEN A.QTY ELSE 0 END) AS MM09
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '10' THEN A.QTY ELSE 0 END) AS MM10
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '11' THEN A.QTY ELSE 0 END) AS MM11
             , SUM(CASE WHEN SUBSTR(A.YYYYMMDD,1,6) = Y.YYYY || '12' THEN A.QTY ELSE 0 END) AS MM12
             , NVL((SELECT V.ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION V
                     WHERE V.DIVISION_ID = P_DIVISION_ID AND V.VERSION_NO = P_VERSION_NO AND ROWNUM = 1), '-') AS ORI_VERSION_NO
             , B.DISPLAY_SEQ AS SORT_NO
             , v_user_id   AS CREATED_BY
             , SYSDATE      AS CREATION_DATE
             , v_user_id   AS LAST_UPDATED_BY
             , SYSDATE      AS LAST_UPDATE_DATE
          FROM (
                SELECT A.DIVISION_ID, A.PRODUCT_GROUP
                     , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
                     , A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2
                     , CASE WHEN A.MEASURE = 'RTF' AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
                            ELSE A.QTY
                       END AS QTY
                  FROM DM_PLN_SALES_PLAN_REPORT_C A
                  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
                    ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
                 WHERE A.DIVISION_ID = P_DIVISION_ID
                   AND A.VERSION_NO  = P_VERSION_NO
                   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')
                UNION ALL
                SELECT A.DIVISION_ID, A.PRODUCT_GROUP
                     , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
                     , A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2
                     , CASE WHEN A.MEASURE = 'RTF' AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
                            ELSE A.QTY
                       END AS QTY
                  FROM DM_PLN_SALES_ETC_REPORT_C A
                  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
                    ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
                 WHERE A.DIVISION_ID = P_DIVISION_ID
                   AND A.VERSION_NO  = P_VERSION_NO
                   AND A.MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')
               ) A
          LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
            ON A.PRODUCT_GROUP = B.SEGMENT1 AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
          CROSS JOIN (
                SELECT TO_CHAR(TO_NUMBER(P_YYYY) - 1) AS YYYY FROM DUAL
                UNION ALL
                SELECT P_YYYY AS YYYY FROM DUAL
                UNION ALL
                SELECT TO_CHAR(TO_NUMBER(P_YYYY) + 1) AS YYYY FROM DUAL
               ) Y
         WHERE 1 = 1
           AND A.YYYYMMDD LIKE Y.YYYY || '%'
         GROUP BY A.DIVISION_ID
             , A.PRODUCT_GROUP
             , CASE WHEN A.PRODUCT_GROUP = '파우치형' THEN NVL(A.ATTRIBUTE1,'')
                    WHEN A.PRODUCT_GROUP = '원통형' THEN NVL(A.ATTRIBUTE2,'')
                    ELSE ''
               END
             , A.MEASURE
             , B.DISPLAY_SEQ
             , Y.YYYY;

        n_merge_count := SQL%ROWCOUNT;

    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (END)
    -----------------------------------------------------------------------------------------------------

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_ACTION_TYPE' VALUE P_ACTION_TYPE,
            'P_YYYY'        VALUE P_YYYY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0044_SALES_REPORT_PRODUCT_CREATE;
/
