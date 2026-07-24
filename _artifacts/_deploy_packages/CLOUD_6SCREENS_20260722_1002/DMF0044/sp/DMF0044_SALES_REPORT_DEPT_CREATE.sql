CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_SALES_REPORT_DEPT_CREATE" 
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_ACTION_TYPE       IN  VARCHAR2,   -- T:Transfer, C:Cancel
    P_YYYY              IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SALES_REPORT_DEPT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191021 kyh    rownumber 가 group by 랑 같이있어서 중복오류, Group By 에 Data_Type 제거 - 수정함
 * 20191023 kyh    Department_Name 가져오는 로직을 Sales Report 와 동일하게 Lookup 을 보도록 수정
 * 20191113 KYH		PACK 일 경우 수량환산
 * 20191118 hwi1993 파라미터 추가 및 데이터타입 변경 및 Cancel 기능 추가
 * 20200512 hwi1993 ETC 매출 테이블 추가
 * 20200525 hwi1993 소형 1~3 담당 외에는 기타로 묶음.
 * 20200610 hwi1993	ETC Data 중 Product Detail 이 빠지는 문제 수정
 * 20210716	HWI1993	상반기과제 ( GDW 마스터정비 ) bp 메저관련 및 기간조정
 * 20220616 hwi1993 [C20220608-000333] GDW 전송시 버전 종류에 따른 데이터 오류 수정 요청의 건
 * 2026/06/05	NextSCM Migration	[PJ202650304] 기존 배포본(미완성 자동변환, INVALID) 재변환. #TEMP_REPORT_C→GTT(GT_DMF0044_DEPT_RPT_C), CURSOR 루프→연도 CROSS JOIN(+ROW_NUMBER PARTITION BY YYYY), UPDATE..FROM→상관 UPDATE/NOT EXISTS, GETDATE→SYSDATE, 로깅/EXCEPTION/O_RESULT_CURSOR 표준. 템플릿=DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE(VALID)
 */
IS
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);

    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;

    v_user_id           VARCHAR2(10 CHAR) := 'mdf_batch';
    v_ori_version_no    VARCHAR2(50 CHAR);
    V_SP_BP             VARCHAR2(2 CHAR);
    v_etc_department_id VARCHAR2(30 CHAR);
    v_bp_cnt            PLS_INTEGER := 0;

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
    V_LOG_MESSAGE := NULL;
    -- 시작 LOG  (END)

    -- 중복 VERSION이 있는경우 삭제후 COPY
    DELETE FROM SCM_MGR.DM_MOBILE_REPORT_DEPT
    WHERE  DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    n_delete_count := SQL%ROWCOUNT;

    IF P_ACTION_TYPE = 'T' THEN -- 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        SELECT NVL((SELECT ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION
                     WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND ROWNUM = 1), NULL)
          INTO v_ori_version_no FROM DUAL;

        -- GTT 초기화
        DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C;

        -- 20210716 : Business_Plan 존재 여부로 SP/BP 결정
        SELECT COUNT(*) INTO v_bp_cnt
        FROM DM_PLN_SALES_PLAN_REPORT_C A
        WHERE A.DIVISION_ID = P_DIVISION_ID
          AND A.VERSION_NO  = P_VERSION_NO
          AND A.MEASURE = 'Business_Plan'
          AND ROWNUM = 1;

        IF v_bp_cnt > 0 THEN
            V_SP_BP := 'BP';
        ELSE
            V_SP_BP := 'SP';
        END IF;

        -- #TEMP_REPORT_C 적재 (SALES_PLAN + ETC UNION ALL)
        INSERT INTO SCM_MGR.GT_DMF0044_DEPT_RPT_C
            ( DIVISION_ID, PRODUCT_GROUP, MEASURE, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, QTY )
        SELECT A.DIVISION_ID, A.PRODUCT_GROUP
             , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
             , A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT
             , CASE WHEN A.MEASURE IN ('RTF','Business_Plan','RTF_SYS_RP') AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
                    ELSE A.QTY
               END AS QTY
          FROM DM_PLN_SALES_PLAN_REPORT_C A
          LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
            ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW')
           AND A.DATA_TYPE = '1'
        UNION ALL
        SELECT A.DIVISION_ID, A.PRODUCT_GROUP
             , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF'
                    WHEN A.MEASURE = 'RTF_SYS_RP' THEN CASE WHEN V_SP_BP = 'BP' THEN 'RTF' ELSE A.MEASURE END
                    ELSE A.MEASURE
               END AS MEASURE
             , A.YYYYMMDD, A.PRODUCT_DETAILS, A.ATTRIBUTE2, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT
             , CASE WHEN A.MEASURE IN ('RTF','Business_Plan') AND B.FORECAST_INFO_BIZ_TYPE = 'PACK' AND B.FORECAST_INFO_CELL_PACK_COUNT <> 0 THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT, 1)
                    ELSE A.QTY
               END AS QTY
          FROM DM_PLN_SALES_ETC_REPORT_C A
          LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B
            ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW');

        -- 2020.05.25 1~3 담당 외에는 기타로 묶는다. (기타 부서코드 조회)
        BEGIN
            SELECT SEGMENT1 INTO v_etc_department_id
            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT' AND ATTRIBUTE1 = 'Y' AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN v_etc_department_id := NULL;
        END;

        -- GTT 의 미등록 부서 → 기타
        UPDATE SCM_MGR.GT_DMF0044_DEPT_RPT_C A
        SET A.DEPARTMENT_ID = v_etc_department_id
        WHERE NOT EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                           WHERE A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' );

        -- 원본 테이블의 미등록 부서 → 기타 (원본 MSSQL 동작 보존)
        UPDATE DM_PLN_SALES_PLAN_REPORT_C A
        SET A.DEPARTMENT_ID = v_etc_department_id
          , A.DEPT_ID = v_etc_department_id
        WHERE A.DIVISION_ID = P_DIVISION_ID
          AND A.VERSION_NO = P_VERSION_NO
          AND NOT EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                           WHERE A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' );

        UPDATE DM_PLN_SALES_ETC_REPORT_C A
        SET A.DEPARTMENT_ID = v_etc_department_id
          , A.DEPT_ID = v_etc_department_id
        WHERE A.DIVISION_ID = P_DIVISION_ID
          AND A.VERSION_NO = P_VERSION_NO
          AND NOT EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                           WHERE A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' );

        -- CURSOR 루프(연도) 대신 SALES_PLAN 연도 CROSS JOIN + ROW_NUMBER PARTITION BY YYYY
        INSERT INTO SCM_MGR.DM_MOBILE_REPORT_DEPT
             ( DIVISION_ID, VERSION_NO, YYYY, SP_BP_TYPE, UPPER_DEPT_NAME, DEPT_NAME, CUST_INFO
             , PRODUCT_NAME, PRODUCT_DETAIL, MEASURE
             , MM01, MM02, MM03, MM04, MM05, MM06, MM07, MM08, MM09, MM10, MM11, MM12
             , ORI_VERSION_NO, SORT_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.YYYY
             , A.SP_BP_TYPE
             , A.DEPARTMENT_NAME
             , A.DEPT_NAME
             , A.CUST_INFO
             , A.PRODUCT_NAME
             , A.PRODUCT_DETAIL
             , CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
             , A.MM01, A.MM02, A.MM03, A.MM04, A.MM05, A.MM06, A.MM07, A.MM08, A.MM09, A.MM10, A.MM11, A.MM12
             , v_ori_version_no AS ORI_VERSION_NO
             , ROW_NUMBER() OVER( PARTITION BY A.YYYY
                                  ORDER BY CASE WHEN A.DEPARTMENT_NAME = '' OR A.DEPARTMENT_NAME = '기타' THEN '힣' ELSE A.DEPARTMENT_NAME END
                                         , CASE WHEN A.DEPT_NAME = 'MDF' THEN '힣' ELSE A.DEPT_NAME END
                                         , A.DEPT_NAME
                                         , A.DISPLAY_SEQ
                                         , A.MEASURE) AS SORT_NO
             , v_user_id  AS CREATED_BY
             , SYSDATE    AS CREATION_DATE
             , v_user_id  AS LAST_UPDATED_BY
             , SYSDATE    AS LAST_UPDATE_DATE
        FROM (
                SELECT A.DIVISION_ID
                     , A.VERSION_NO
                     , A.YYYY
                     , A.SP_BP_TYPE
                     , A.DEPARTMENT_NAME
                     , A.DEPT_NAME
                     , A.CUST_REPORT AS CUST_INFO
                     , A.PRODUCT_NAME
                     , A.PRODUCT_DETAIL
                     , A.MEASURE
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '01' THEN A.QTY ELSE 0 END) AS MM01
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '02' THEN A.QTY ELSE 0 END) AS MM02
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '03' THEN A.QTY ELSE 0 END) AS MM03
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '04' THEN A.QTY ELSE 0 END) AS MM04
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '05' THEN A.QTY ELSE 0 END) AS MM05
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '06' THEN A.QTY ELSE 0 END) AS MM06
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '07' THEN A.QTY ELSE 0 END) AS MM07
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '08' THEN A.QTY ELSE 0 END) AS MM08
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '09' THEN A.QTY ELSE 0 END) AS MM09
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '10' THEN A.QTY ELSE 0 END) AS MM10
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '11' THEN A.QTY ELSE 0 END) AS MM11
                     , SUM(CASE WHEN A.YYYYMM = A.YYYY || '12' THEN A.QTY ELSE 0 END) AS MM12
                     , B.DISPLAY_SEQ
                  FROM (
                        SELECT C.DIVISION_ID
                             , P_VERSION_NO AS VERSION_NO
                             , Y.YYYY       AS YYYY
                             , 'SP'         AS SP_BP_TYPE
                             , NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT' AND C.DEPARTMENT_ID = SEGMENT1 AND ROWNUM = 1), '') AS DEPARTMENT_NAME
                             , NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' AND C.DEPT_ID = SEGMENT1 AND ROWNUM = 1), '') AS DEPT_NAME
                             , C.CUST_REPORT
                             , C.END_CUST_REPORT
                             , C.PRODUCT_GROUP AS PRODUCT_NAME
                             , C.ATTRIBUTE1 AS PRODUCT_DETAIL
                             , C.MEASURE
                             , SUBSTR(C.YYYYMMDD, 1, 6) AS YYYYMM
                             , C.QTY
                          FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C C
                          CROSS JOIN ( SELECT DISTINCT SUBSTR(YYYYMMDD, 1, 4) AS YYYY
                                       FROM DM_PLN_SALES_PLAN_REPORT_C
                                       WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO ) Y
                         WHERE 1 = 1
                           AND C.MEASURE IN ('Business_Plan', 'RTF','RTF_SYS_RP','SalesAmt_KRW')
                           AND C.YYYYMMDD LIKE Y.YYYY || '%'
                       ) A
                  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                    ON A.CUST_REPORT = B.SEGMENT1 AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
                 GROUP BY A.DIVISION_ID, A.VERSION_NO, A.YYYY, A.SP_BP_TYPE, A.DEPARTMENT_NAME, A.DEPT_NAME
                        , A.CUST_REPORT, A.PRODUCT_NAME, A.PRODUCT_DETAIL, B.DISPLAY_SEQ, A.MEASURE
             ) A;

        n_merge_count := SQL%ROWCOUNT;

    END IF;

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
END DMF0044_SALES_REPORT_DEPT_CREATE;
/
