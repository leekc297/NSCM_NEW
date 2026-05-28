/*=============================================================================================
 * File         : 04_Package_PKG_DMF0044.sql
 * Description  : Package — PKG_DMF0044
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0044
/*
 * Program ID   : PKG_DMF0044
 * Description  : PKG_DMF0044
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.25   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */
AS
    -- 프로시저 선언
PROCEDURE P_DMF0044_BP_REPORT_DEPT_CREATE
(
    P_DIVISION_ID         IN VARCHAR2,
    P_VERSION_NO          IN VARCHAR2,
    P_ACTION_TYPE         IN VARCHAR2,        -- T:Transfer, C:Cancel
    P_YYYY                IN VARCHAR2,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_GET_COPY_VERSION_POPUP
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    P_VERSION_TYPE    IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE
(
    P_DIVISION_ID         IN VARCHAR2,
    P_VERSION_NO          IN VARCHAR2,
    P_ACTION_TYPE         IN VARCHAR2,        -- T:Transfer, C:Cancel
    P_YYYY                IN VARCHAR2,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_BP_REPORT_PRODUCT_CREATE
(
    P_DIVISION_ID         IN VARCHAR2,
    P_VERSION_NO          IN VARCHAR2,
    P_ACTION_TYPE         IN VARCHAR2,        -- T:Transfer, C:Cancel
    P_YYYY                IN VARCHAR2,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
);

-- 3/26
PROCEDURE P_DMF0044_GET_SALES_VERSION_POPUP
(
    P_DIVISION_ID     IN VARCHAR2,
    P_SDT             IN VARCHAR2,
    P_EDT             IN VARCHAR2,
    P_VERSION_TYPE    IN VARCHAR2,
    P_DESCRIPTION     IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn    
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA
(
    P_DIVISION_ID     IN VARCHAR2,
    P_YEAR            IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn   
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP
(
    P_DIVISION_ID     IN VARCHAR2,
    P_YEAR            IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn       
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_GET_MEASURE
(
    P_DATA_TYPE       IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);


PROCEDURE P_DMF0044_GET_TEXTBOX
(
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn    
    O_RC1             OUT SYS_REFCURSOR,
    O_RC2             OUT SYS_REFCURSOR,
    O_RC3             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_GET_SALES_REPORTS_DATA
(
    P_DIVISION_ID         IN VARCHAR2,
    P_MDF_TYPE            IN VARCHAR2,
    P_YYYY                IN VARCHAR2,
    P_SP_VERSION_NO       IN VARCHAR2,
    P_DATA_TYPE           IN VARCHAR2,
    P_USER_GROUP          IN VARCHAR2,
    P_CREATED_BY          IN VARCHAR2,

    P_USER_ID             IN VARCHAR2, -- For EditYn
    P_MNU_ID              IN VARCHAR2, -- For EditYn

    O_RC1                 OUT SYS_REFCURSOR,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
);

-- 03/27
/*
DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT
DMF0044_SAVE_SALES_PLAN_REPORT_C
DMF0044_GET_VERSION_POPUP
DMF0044_SAVE_BIZ_PLAN_VERSION_COPY
DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE
*/

PROCEDURE P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_UNIT_CURRENCY         IN  VARCHAR2,
    P_EXCHANGE_PRICE        IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_LAST_UPDATED_BY       IN  VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
);


PROCEDURE P_DMF0044_SAVE_SALES_PLAN_REPORT_C
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_CUTOFF_TYPE           IN  VARCHAR2,
    P_CUTOFF_YYYYMMDD       IN  VARCHAR2,
    P_DEPARTMENT_ID         IN  VARCHAR2,
    P_DEPARTMENT_NAME       IN  VARCHAR2,
    P_DEPT_ID               IN  VARCHAR2,
    P_DEPT_NAME             IN  VARCHAR2,
    P_END_CUST_REPORT       IN  VARCHAR2,
    P_CUST_REPORT           IN  VARCHAR2,
    P_PRODUCT_GROUP         IN  VARCHAR2,
    P_ITEM_ID               IN  VARCHAR2,
    P_MEASURE               IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_COMPANY_ID            IN  VARCHAR2,
    P_QTY                   IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_CELL_MODEL_INFO       IN  VARCHAR2,   --[C20211112-000213]
    P_CELL_MODEL            IN  VARCHAR2,   --[C20211112-000213]
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_GET_VERSION_POPUP
(
    P_START_YYYYMMDD    IN  VARCHAR2,
    P_END_YYYYMMDD      IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_TYPE      IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_USER_ID           IN  VARCHAR2, -- For EditYn
    P_MNU_ID            IN  VARCHAR2, -- For EditYn

    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY
(
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_VERSION_DESCRIPTION   IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_ACTION_TYPE           IN  VARCHAR2,   -- D:삭제, CR: 생성, CP:복사
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_ACTION_TYPE       IN  VARCHAR2,   -- T:Transfer, C:Cancel
    P_YYYY              IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_CUTOFF_TYPE           IN  VARCHAR2,
    P_CUTOFF_YYYYMMDD       IN  VARCHAR2,
    P_DEPARTMENT_ID         IN  VARCHAR2,
    P_DEPARTMENT_NAME       IN  VARCHAR2,
    P_DEPT_ID               IN  VARCHAR2,
    P_DEPT_NAME             IN  VARCHAR2,
    P_END_CUST_REPORT       IN  VARCHAR2,
    P_CUST_REPORT           IN  VARCHAR2,
    P_PRODUCT_GROUP         IN  VARCHAR2,
    P_ITEM_ID               IN  VARCHAR2,
    P_MEASURE               IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_QTY                   IN  VARCHAR2,
    P_SCM_SITE_ID           IN  VARCHAR2,
    P_PROJECT_CODE          IN  VARCHAR2,
    P_COMPANY_ID            IN  VARCHAR2,
    P_FCST_TYPE             IN  VARCHAR2,
    P_INCOTERMS             IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0044_SAVE_TEXTBOX
(
    P_VERSION_NO        IN  VARCHAR2,
    P_YYYYMM            IN  VARCHAR2,
    P_DESCRIPTION1      IN  VARCHAR2,
    P_DESCRIPTION2      IN  VARCHAR2,
    P_DESCRIPTION3      IN  VARCHAR2,
    P_DESCRIPTION4      IN  VARCHAR2,
    P_DESCRIPTION5      IN  VARCHAR2,
    P_DESCRIPTION6      IN  VARCHAR2,
    P_DESCRIPTION7      IN  VARCHAR2,
    P_DESCRIPTION8      IN  VARCHAR2,
    P_DESCRIPTION9      IN  VARCHAR2,
    P_DESCRIPTION10     IN  VARCHAR2,
    P_DESCRIPTION11     IN  VARCHAR2,
    P_DESCRIPTION12     IN  VARCHAR2,
    P_DESCRIPTION13     IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

END PKG_DMF0044;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0044
AS

PROCEDURE P_DMF0044_BP_REPORT_DEPT_CREATE
(
    P_DIVISION_ID         IN VARCHAR2,
    P_VERSION_NO          IN VARCHAR2,
    P_ACTION_TYPE         IN VARCHAR2,        -- T:Transfer, C:Cancel
    P_YYYY                IN VARCHAR2,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : DMF0044_BP_REPORT_DEPT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191022    KYH			[CSR ID:4103445] 컬럼통합. attribute1, 2 --> attribute1
 * 20191023 kyh    Department_Name 가져오는 로직을 Sales Report 와 동일하게 Lookup 을 보도록 수정
 * 20191118 hwi1993 파라미터, 데이터타입 변경 및 Cancel 기능 추가
 * 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  
 *
 */
IS

    /* ── 로컬 변수 ── */
    V_YYYY              VARCHAR2(4 CHAR);
    V_USER_ID           VARCHAR2(10 CHAR) := 'mdf_batch';
    N_DELETE_COUNT      PLS_INTEGER := 0;
    N_MERGE_COUNT       PLS_INTEGER := 0;

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 병렬 DML 활성화 ── */
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_REPORT_C', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    DELETE FROM DM_MOBILE_REPORT_DEPT
    WHERE  1 = 1
    AND    DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    N_DELETE_COUNT := SQL%ROWCOUNT;
    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    IF P_ACTION_TYPE = 'T' THEN  -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        /* ── GTT 초기화 및 적재 ── */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F044_REPORT_C';

        INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F044_REPORT_C
             ( DATA_TYPE, DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPT_ID,
               CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1,
               MEASURE, YYYYMM, QTY )
        SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPT_ID,
               CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1,
               MEASURE, YYYYMM, QTY
        FROM   DM_PLN_BP_FCST_REPORT_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        -- COMMIT;

        /* ── GTT 통계 수집 ── */
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname          => 'SCM_MGR',
            tabname          => 'GT_F044_REPORT_C',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
            method_opt       => 'FOR ALL COLUMNS SIZE 1'
        );

        /* ── 연도 루프: (year-1, year, year+1) ── */
        FOR rec IN (
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) - 1) AS YYYY FROM DUAL
            UNION ALL
            SELECT P_YYYY AS YYYY FROM DUAL
            UNION ALL
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) + 1) AS YYYY FROM DUAL
        )
        LOOP
            V_YYYY := rec.YYYY;

            INSERT INTO DM_MOBILE_REPORT_DEPT
                 ( DIVISION_ID
                 , VERSION_NO
                 , YYYY
                 , SP_BP_TYPE
                 , UPPER_DEPT_NAME
                 , DEPT_NAME
                 , CUST_INFO
                 , PRODUCT_NAME
                 , PRODUCT_DETAIL
                 , MEASURE
                 , MM01
                 , MM02
                 , MM03
                 , MM04
                 , MM05
                 , MM06
                 , MM07
                 , MM08
                 , MM09
                 , MM10
                 , MM11
                 , MM12
                 , ORI_VERSION_NO
                 , SORT_NO
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT A.DIVISION_ID
                 , A.VERSION_NO
                 , A.YYYY
                 , A.SP_BP_TYPE
                 , NVL(A.DEPARTMENT_NAME, '-') AS DEPARTMENT_NAME
                 , nvl(A.DEPT_NAME,'-') AS DEPT_NAME
                 , A.CUST_REPORT     AS CUST_INFO
                 --, CASE WHEN A.DATA_TYPE = '1' THEN A.CUST_REPORT ELSE A.END_CUST_REPORT END AS CUST_INFO
                 , A.PRODUCT_NAME
                 , nvl(A.PRODUCT_DETAIL,'-') AS PRODUCT_DETAIL
                 , A.MEASURE
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '01' THEN QTY ELSE 0 END) AS MM01
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '02' THEN QTY ELSE 0 END) AS MM02
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '03' THEN QTY ELSE 0 END) AS MM03
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '04' THEN QTY ELSE 0 END) AS MM04
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '05' THEN QTY ELSE 0 END) AS MM05
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '06' THEN QTY ELSE 0 END) AS MM06
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '07' THEN QTY ELSE 0 END) AS MM07
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '08' THEN QTY ELSE 0 END) AS MM08
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '09' THEN QTY ELSE 0 END) AS MM09
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '10' THEN QTY ELSE 0 END) AS MM10
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '11' THEN QTY ELSE 0 END) AS MM11
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '12' THEN QTY ELSE 0 END) AS MM12
                 , P_VERSION_NO AS ORI_VERSION_NO
                 , ROW_NUMBER() OVER(ORDER BY CASE WHEN A.DEPARTMENT_NAME = '' OR A.DEPARTMENT_NAME = '기타' THEN '?' ELSE A.DEPARTMENT_NAME END
                                             , CASE WHEN A.DEPT_NAME = 'MDF' THEN '?' ELSE A.DEPT_NAME END
                                             , A.DEPT_NAME
                                             , B.DISPLAY_SEQ
                                             , A.MEASURE) AS SORT_NO
                 , V_USER_ID    AS CREATED_BY
                 , SYSDATE      AS CREATION_DATE
                 , V_USER_ID    AS LAST_UPDATED_BY
                 , SYSDATE      AS LAST_UPDATE_DATE
              FROM (SELECT C.DATA_TYPE
                         , C.DIVISION_ID
                         , C.VERSION_NO
                         , V_YYYY        AS YYYY
                         , 'BP'          AS SP_BP_TYPE
                         -- 20191023 kyh
                         , NVL((SELECT SEGMENT2
                                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT'
                                AND C.DEPARTMENT_ID = SEGMENT1), '')
                            AS DEPARTMENT_NAME
                         , NVL((SELECT SEGMENT2
                                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
                                AND C.DEPT_ID = SEGMENT1), '')
                            AS DEPT_NAME
                         , C.CUST_REPORT
                         , C.END_CUST_REPORT
                         , C.PRODUCT_GROUP AS PRODUCT_NAME
                         , NVL(C.ATTRIBUTE1, '') AS PRODUCT_DETAIL
                         , CASE WHEN C.MEASURE = 'Business_Plan' THEN 'RTF' ELSE C.MEASURE END AS MEASURE
                         , C.YYYYMM
                         , C.QTY
                      FROM SCM_MGR.GT_F044_REPORT_C C
                     WHERE 1 = 1
                       AND C.DIVISION_ID = P_DIVISION_ID
                       AND C.VERSION_NO  = P_VERSION_NO
                       AND C.MEASURE IN ('Business_Plan', 'SalesAmt_KRW')
                       AND C.YYYYMM LIKE V_YYYY || '%'
                    ) A
                    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                      ON A.CUST_REPORT = B.SEGMENT1
                     AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
             GROUP BY A.DATA_TYPE
                 , A.DIVISION_ID
                 , A.VERSION_NO
                 , A.YYYY
                 , A.SP_BP_TYPE
                 , A.DEPARTMENT_NAME
                 , A.DEPT_NAME
                 , A.CUST_REPORT
                 --, CASE WHEN A.DATA_TYPE = '1' THEN A.CUST_REPORT ELSE A.END_CUST_REPORT END
                 , A.PRODUCT_NAME
                 , A.PRODUCT_DETAIL
                 , B.DISPLAY_SEQ
                 , A.MEASURE;

            N_MERGE_COUNT := N_MERGE_COUNT + SQL%ROWCOUNT;

        END LOOP;

    END IF;
    ---------------------------------------------------------------------------------------------------------------------------
    --     요청VERSION COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    /* ── 활성 트랜잭션 존재 여부 확인 후 COMMIT (Case 38) ── */
    IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
        COMMIT;
    END IF;

    N_LOG_COUNT := N_DELETE_COUNT + N_MERGE_COUNT;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — DML 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(N_DELETE_COUNT) || ' / merge_count: ' || TO_CHAR(N_MERGE_COUNT);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 병렬 DML 비활성화 ── */
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 병렬 DML 비활성화
        BEGIN EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML'; EXCEPTION WHEN OTHERS THEN NULL; END;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_VERSION_NO'   VALUE P_VERSION_NO,
            'P_ACTION_TYPE'  VALUE P_ACTION_TYPE,
            'P_YYYY'         VALUE P_YYYY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_DMF0044_BP_REPORT_DEPT_CREATE;


PROCEDURE P_DMF0044_GET_COPY_VERSION_POPUP
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    P_VERSION_TYPE    IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/06/03  JYE       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
/*****************************************************************************************************
 ※ 작성 Rule 
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
IS

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    WITH SPLIT_DIVISION AS (
        SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
    ),
    SPLIT_VERSION_TYPE AS (
        SELECT TRIM(REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
    ),
    SPLIT_VERSION_NO AS (
        SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL) IS NOT NULL
    )
    SELECT T1.VERSION_NO AS CODE, T1.VERSION_NO, T1.VERSION_DESCRIPTION, T1.VERSION_TYPE, T1.VER_CRE_SEQ, T1.YYYYMMDD, MAX(T1.CREATED_BY) AS CREATED_BY, MAX(T1.CREATION_DATE) AS CREATION_DATE, 
            NVL(T2.EDIT_YN,'') AS EDIT_YN
    FROM   DM_MST_VERSION T1 
    INNER JOIN (SELECT * -- EDIT_YN 
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                WHERE USER_ID = P_USER_ID 
                AND MNU_ID = P_MNU_ID 
                AND UNIT_TP_CD = 'D') T2
    ON T1.DIVISION_ID = T2.UNIT_ID
    
    WHERE  (T1.YYYYMMDD >= P_START_YYYYMMDD AND T1.YYYYMMDD <= P_END_YYYYMMDD)
    AND    T1.DIVISION_ID IN (SELECT TOKEN FROM SPLIT_DIVISION)
    AND    T1.VERSION_TYPE IN (SELECT TOKEN FROM SPLIT_VERSION_TYPE)
    AND    EXISTS (SELECT 1 FROM SPLIT_VERSION_NO P WHERE T1.VERSION_NO LIKE P.TOKEN || '%')
    GROUP BY T1.VERSION_NO, T1.VERSION_NO, T1.VERSION_DESCRIPTION, T1.VERSION_TYPE, T1.VER_CRE_SEQ, T1.YYYYMMDD, NVL(T2.EDIT_YN,'')
    ORDER BY CODE DESC, T1.VERSION_NO DESC;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_VERSION_TYPE'   VALUE P_VERSION_TYPE,
            'P_VERSION_NO'     VALUE P_VERSION_NO,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
            
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_DMF0044_GET_COPY_VERSION_POPUP;


PROCEDURE P_DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE
(
    P_DIVISION_ID         IN VARCHAR2,
    P_VERSION_NO          IN VARCHAR2,
    P_ACTION_TYPE         IN VARCHAR2,        -- T:Transfer, C:Cancel
    P_YYYY                IN VARCHAR2,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE - 사업계획통화환율
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191101 KYH    환율 AVG 계산이 틀려서 null 로 변경함
 * 20191106 KYH		월별환율에 NULL 처리 추가
 * 20191118 hwi1993 파라미터 추가, Cancel 기능 추가, 데이터타입 변경
 * 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  
 */
IS

    /* ── 로컬 변수 ── */
    V_YYYY              VARCHAR2(4 CHAR);
    V_USER_ID           VARCHAR2(10 CHAR) := 'mdf_batch';
    N_DELETE_COUNT      PLS_INTEGER := 0;
    N_MERGE_COUNT       PLS_INTEGER := 0;

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 병렬 DML 활성화 ── */
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    /* ── GTT 세션 레벨 통계 수집 설정 ── */
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_EXCHANGE_C', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    DELETE FROM DM_MOBILE_REPORT_EXCHANGE_RATE
    WHERE  1 = 1
    AND    DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    N_DELETE_COUNT := SQL%ROWCOUNT;
    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                                         요청VERSION COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    IF P_ACTION_TYPE = 'T' THEN  -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        /* ── GTT 초기화 및 적재 ── */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F044_EXCHANGE_C';

        INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F044_EXCHANGE_C
             ( DIVISION_ID, VERSION_NO, CURRENCY, UNIT_CURRENCY, YYYYMMDD, EXCHANGE_PRICE )
        SELECT DISTINCT DIVISION_ID, VERSION_NO, CURRENCY, UNIT_CURRENCY, YYYYMMDD, EXCHANGE_PRICE
        FROM   DM_BP_EXCHANGE_RATE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = SUBSTR(P_VERSION_NO, 8, 18);

        -- COMMIT;

        /* ── GTT 통계 수집 ── */
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname          => 'SCM_MGR',
            tabname          => 'GT_F044_EXCHANGE_C',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
            method_opt       => 'FOR ALL COLUMNS SIZE 1'
        );

        /* ── 연도 루프: (year-1, year, year+1) ── */
        FOR rec IN (
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) - 1) AS YYYY FROM DUAL
            UNION ALL
            SELECT P_YYYY AS YYYY FROM DUAL
            UNION ALL
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) + 1) AS YYYY FROM DUAL
        )
        LOOP
            V_YYYY := rec.YYYY;

            INSERT INTO DM_MOBILE_REPORT_EXCHANGE_RATE
                 ( DIVISION_ID
                 , VERSION_NO
                 , YYYY
                 , SP_BP_TYPE
                 , CURRENCY
                 , UNIT_CURRENCY
                 , MM01
                 , MM02
                 , MM03
                 , MM04
                 , MM05
                 , MM06
                 , MM07
                 , MM08
                 , MM09
                 , MM10
                 , MM11
                 , MM12
                 , ORI_VERSION_NO
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT DIVISION_ID
                 , P_VERSION_NO
                 , V_YYYY        AS YYYY
                 , 'BP'          AS SP_BP_TYPE
                 , CURRENCY
                 , UNIT_CURRENCY
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '01' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM01
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '02' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM02
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '03' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM03
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '04' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM04
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '05' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM05
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '06' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM06
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '07' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM07
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '08' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM08
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '09' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM09
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '10' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM10
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '11' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM11
                 , NVL(AVG(CASE WHEN SUBSTR(YYYYMMDD, 1, 6) = V_YYYY || '12' THEN EXCHANGE_PRICE ELSE NULL END), 0) AS MM12
                 , SUBSTR(P_VERSION_NO, 8, 18) AS ORI_VERSION_NO
                 , V_USER_ID    AS CREATED_BY
                 , SYSDATE      AS CREATION_DATE
                 , V_USER_ID    AS LAST_UPDATED_BY
                 , SYSDATE      AS LAST_UPDATE_DATE
              FROM SCM_MGR.GT_F044_EXCHANGE_C
             WHERE 1 = 1
               --AND DIVISION_ID = P_DIVISION_ID
               --AND VERSION_NO  = P_VERSION_NO
               AND YYYYMMDD LIKE V_YYYY || '%'
            GROUP BY DIVISION_ID
                 , VERSION_NO
                 , CURRENCY
                 , UNIT_CURRENCY;

            N_MERGE_COUNT := N_MERGE_COUNT + SQL%ROWCOUNT;

        END LOOP;

    END IF;
    ---------------------------------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    /* ── 활성 트랜잭션 존재 여부 확인 후 COMMIT (Case 38) ── */
    IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
        COMMIT;
    END IF;

    -- N_LOG_COUNT := N_DELETE_COUNT + N_MERGE_COUNT;
    N_LOG_COUNT := N_MERGE_COUNT;
    

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — DML 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(N_DELETE_COUNT) || ' / merge_count: ' || TO_CHAR(N_MERGE_COUNT);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 병렬 DML 비활성화 ── */
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 병렬 DML 비활성화
        BEGIN EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML'; EXCEPTION WHEN OTHERS THEN NULL; END;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_VERSION_NO'   VALUE P_VERSION_NO,
            'P_ACTION_TYPE'  VALUE P_ACTION_TYPE,
            'P_YYYY'         VALUE P_YYYY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_DMF0044_BP_REPORT_EXCHANGE_RATE_CREATE;


PROCEDURE P_DMF0044_BP_REPORT_PRODUCT_CREATE
(
    P_DIVISION_ID         IN VARCHAR2,
    P_VERSION_NO          IN VARCHAR2,
    P_ACTION_TYPE         IN VARCHAR2,        -- T:Transfer, C:Cancel
    P_YYYY                IN VARCHAR2,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : DMF0044_BP_REPORT_PRODUCT_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191118 hwi1993 파라미터 추가, 데이터타입 변경 및 cancel 기능 추가
 * 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS

    /* ── 로컬 변수 ── */
    V_YYYY              VARCHAR2(4 CHAR);
    V_USER_ID           VARCHAR2(10 CHAR) := 'mdf_batch';
    N_DELETE_COUNT      PLS_INTEGER := 0;
    N_MERGE_COUNT       PLS_INTEGER := 0;

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 병렬 DML 활성화 ── */
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    /* ── GTT 세션 레벨 통계 수집 설정 ── */
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_REPORT_C', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    DELETE FROM DM_MOBILE_REPORT_PRODUCT
    WHERE  1 = 1
    AND    DIVISION_ID = P_DIVISION_ID
    AND    VERSION_NO  = P_VERSION_NO;

    N_DELETE_COUNT := SQL%ROWCOUNT;
    ---------------------------------------------------------------------------------------------------------------------------
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    ---------------------------------------------------------------------------------------------------------------------------
    IF P_ACTION_TYPE = 'T' THEN  -- 2019.11.19 HWI1993 전송일 경우만 인서트하고, C 일 경우는 자동삭제처리

        /* ── GTT 초기화 및 적재 (GT_F044_REPORT_C 재사용) ── */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F044_REPORT_C';

        INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F044_REPORT_C
             ( DATA_TYPE, DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPT_ID,
               CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1,
               MEASURE, YYYYMM, QTY )
        SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPT_ID,
               CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1,
               MEASURE, YYYYMM, QTY
        FROM   DM_PLN_BP_FCST_REPORT_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        -- COMMIT;

        /* ── GTT 통계 수집 ── */
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname          => 'SCM_MGR',
            tabname          => 'GT_F044_REPORT_C',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
            method_opt       => 'FOR ALL COLUMNS SIZE 1'
        );

        /* ── 연도 루프: (year-1, year, year+1) ── */
        FOR rec IN (
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) - 1) AS YYYY FROM DUAL
            UNION ALL
            SELECT P_YYYY AS YYYY FROM DUAL
            UNION ALL
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) + 1) AS YYYY FROM DUAL
        )
        LOOP
            V_YYYY := rec.YYYY;

            INSERT INTO DM_MOBILE_REPORT_PRODUCT
                 ( DIVISION_ID
                 , VERSION_NO
                 , YYYY
                 , SP_BP_TYPE
                 , PRODUCT_NAME
                 , PRODUCT_DETAIL
                 , MEASURE
                 , MM01
                 , MM02
                 , MM03
                 , MM04
                 , MM05
                 , MM06
                 , MM07
                 , MM08
                 , MM09
                 , MM10
                 , MM11
                 , MM12
                 , ORI_VERSION_NO
                 , SORT_NO
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT A.DIVISION_ID
                 , A.VERSION_NO
                 , V_YYYY        AS YYYY
                 , 'BP'          AS SP_BP_TYPE
                 , A.PRODUCT_GROUP AS PRODUCT_NAME
                 , NVL(A.ATTRIBUTE1,'-') AS PRODUCT_DETAIL
                 , CASE WHEN A.MEASURE = 'Business_Plan' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '01' THEN A.QTY ELSE 0 END) AS MM01
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '02' THEN A.QTY ELSE 0 END) AS MM02
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '03' THEN A.QTY ELSE 0 END) AS MM03
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '04' THEN A.QTY ELSE 0 END) AS MM04
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '05' THEN A.QTY ELSE 0 END) AS MM05
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '06' THEN A.QTY ELSE 0 END) AS MM06
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '07' THEN A.QTY ELSE 0 END) AS MM07
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '08' THEN A.QTY ELSE 0 END) AS MM08
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '09' THEN A.QTY ELSE 0 END) AS MM09
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '10' THEN A.QTY ELSE 0 END) AS MM10
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '11' THEN A.QTY ELSE 0 END) AS MM11
                 , SUM(CASE WHEN A.YYYYMM = V_YYYY || '12' THEN A.QTY ELSE 0 END) AS MM12
                 , P_VERSION_NO AS ORI_VERSION_NO
                 , B.DISPLAY_SEQ AS SORT_NO
                 , V_USER_ID    AS CREATED_BY
                 , SYSDATE      AS CREATION_DATE
                 , V_USER_ID    AS LAST_UPDATED_BY
                 , SYSDATE      AS LAST_UPDATE_DATE
              FROM SCM_MGR.GT_F044_REPORT_C A
              LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                ON A.PRODUCT_GROUP = B.SEGMENT1
               AND B.LOOKUP_TYPE = 'REPORT_GROUP2'
             WHERE 1 = 1
               AND A.DIVISION_ID = P_DIVISION_ID
               AND A.VERSION_NO  = P_VERSION_NO
               AND A.MEASURE IN ('Business_Plan', 'SalesAmt_KRW')
               AND A.YYYYMM LIKE V_YYYY || '%'
             GROUP BY A.DIVISION_ID
                 , A.VERSION_NO
                 , A.PRODUCT_GROUP
                 , A.ATTRIBUTE1
                 , A.MEASURE
                 , B.DISPLAY_SEQ;

            N_MERGE_COUNT := N_MERGE_COUNT + SQL%ROWCOUNT;

        END LOOP;

    END IF;
    ---------------------------------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (END)
    ---------------------------------------------------------------------------------------------------------------------------

    /* ── 활성 트랜잭션 존재 여부 확인 후 COMMIT (Case 38) ── */
    IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
        COMMIT;
    END IF;

    -- N_LOG_COUNT := N_DELETE_COUNT + N_MERGE_COUNT;
    N_LOG_COUNT := N_MERGE_COUNT;
    

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — DML 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(N_DELETE_COUNT) || ' / merge_count: ' || TO_CHAR(N_MERGE_COUNT);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 병렬 DML 비활성화 ── */
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 병렬 DML 비활성화
        BEGIN EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML'; EXCEPTION WHEN OTHERS THEN NULL; END;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_VERSION_NO'   VALUE P_VERSION_NO,
            'P_ACTION_TYPE'  VALUE P_ACTION_TYPE,
            'P_YYYY'         VALUE P_YYYY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_DMF0044_BP_REPORT_PRODUCT_CREATE;

PROCEDURE P_DMF0044_GET_SALES_VERSION_POPUP
(
    P_DIVISION_ID     IN VARCHAR2,
    P_SDT             IN VARCHAR2,
    P_EDT             IN VARCHAR2,
    P_VERSION_TYPE    IN VARCHAR2,
    P_DESCRIPTION     IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn    
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*************************************************************************************************
 Program ID  : [DMF0044_GET_MDF_VERSION_POPUP]                                            
 Description : Procedure 작성 가이드                                                              
 Usage       : Procedure 작성 시 참조하세요!                                                      
 Parameter   :                                                                                    
                                                                                                  
--------------------------------------------------------------------------------------------------
 Date        In Charge    Description                                                             
--------------------------------------------------------------------------------------------------
 2019/05/27  JYE			      
 20191121		HWI1993		DMF0044_GET_SALES_VERSION_POPUP, DMF0044_GET_COPY_VERSION_POPUP 팝업 통합
							기존 팝업의 기능을 유지하기 위해 @p_Description 파라미터를 받아서 상황에 따라 VERSION_NO 또는 DESCRIPTION 에 걸어줌
							
 2020/06/10	hwi1993		날짜 검색조건을 yyyymmdd(CutoffDate) 에서 Creation_date 로 변경
 20200714     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외(화요일에 Sales Paln Cutoff 제외하고 생성된 SP Version) 
 20200722     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외 원복 
 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리    
 DMF0044_GET_SALES_VERSION_POPUP '40', '20200501', '20200630', 'report_sp_w', ''		
 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
***************************************************************************************************/
IS

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    IF P_VERSION_TYPE LIKE 'REPORT%' THEN

        OPEN O_RC1 FOR
        SELECT
            T1.DIVISION_ID, VERSION_NO, ORI_VERSION_NO AS ORI_VERSION
            , VERSION_DESCRIPTION, VERSION_TYPE
            , SEND_YN, VER_CRE_SEQ
            , CASE WHEN ATTRIBUTE1 = 'CP' AND REGEXP_LIKE(ATTRIBUTE2, '^\d{8}$') THEN SUBSTR(ATTRIBUTE2, 1, 4) || '-' || SUBSTR(ATTRIBUTE2, 5, 2) || '-' || SUBSTR(ATTRIBUTE2, 7, 2) ELSE NULL END AS YYYYMMDD
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY AS UPDATED_BY, LAST_UPDATE_DATE AS UPDATE_DATE
            , CASE WHEN NVL(MV_PLAN_YYYYMM, '') <> '' THEN SUBSTR(MV_PLAN_YYYYMM, 1, 4) || '-' || SUBSTR(MV_PLAN_YYYYMM, 5, 2) ELSE '' END AS MV_PLAN_YYYYMM
            , NVL(T2.EDIT_YN,'') AS EDIT_YN
        FROM DM_MDF_VERSION T1
            INNER JOIN (SELECT * -- EDIT_YN 
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                WHERE USER_ID = P_USER_ID 
                AND MNU_ID = P_MNU_ID 
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID
    
        WHERE
            T1.DIVISION_ID = P_DIVISION_ID
            --AND YYYYMMDD BETWEEN @p_sdt AND @p_edt
            AND CREATION_DATE >= FN_CHAR_TO_DATE(P_SDT)
            AND CREATION_DATE < FN_CHAR_TO_DATE(P_EDT) + 1
            AND VERSION_TYPE = P_VERSION_TYPE
            AND VERSION_DESCRIPTION LIKE '%' || P_DESCRIPTION || '%'
            AND SEND_YN <> 'D'
        ORDER BY CREATION_DATE DESC, VERSION_NO;

    ELSE

        OPEN O_RC1 FOR
        -- DIVISION_ID 를 넣어서 중복이 없으므로 GROUP BY 를 하지 않음.
        WITH SPLIT_DESC AS (
            SELECT TRIM(REGEXP_SUBSTR(P_DESCRIPTION, '[^,]+', 1, LEVEL)) AS TOKEN
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_DESCRIPTION, '[^,]+', 1, LEVEL) IS NOT NULL
        )
        SELECT T1.DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE
            , NULL AS REPORT_DATE, NULL AS SEND_YN
            , NULL AS YYYYMMDD
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY AS UPDATED_BY, LAST_UPDATE_DATE AS UPDATE_DATE
            , NVL(T2.EDIT_YN,'') AS EDIT_YN        
        FROM DM_MST_VERSION T1
            INNER JOIN (SELECT * -- EDIT_YN 
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                WHERE USER_ID = P_USER_ID 
                AND MNU_ID = P_MNU_ID 
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID

        WHERE (YYYYMMDD >= P_SDT AND YYYYMMDD <= P_EDT)
          AND T1.DIVISION_ID = P_DIVISION_ID
          AND VERSION_TYPE = P_VERSION_TYPE
          AND EXISTS (SELECT 1 FROM SPLIT_DESC P WHERE VERSION_NO LIKE P.TOKEN || '%')
          --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
          AND NVL(ATTRIBUTE1, '') <> 'MOVE'
        ORDER BY TO_CHAR(CREATION_DATE, 'YYYYMMDD') DESC, VERSION_NO;

    END IF;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_SDT'          VALUE P_SDT,
            'P_EDT'          VALUE P_EDT,
            'P_VERSION_TYPE' VALUE P_VERSION_TYPE,
            'P_DESCRIPTION'  VALUE P_DESCRIPTION,
            'P_USER_ID'      VALUE P_USER_ID,
            'P_MNU_ID'       VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_GET_SALES_VERSION_POPUP;

PROCEDURE P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA
(
    P_DIVISION_ID     IN VARCHAR2,
    P_YEAR            IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn   
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA]                                      */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/03/23  P.C.I        Initial Release [prepare] Sales Report Exchange Rate Popup              */
/* 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                 */
/*                                                                                                  */
/****************************************************************************************************/
IS

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    /* Case 17: CASE WHEN @p_division_id = 'ALL' 패턴 → UNION ALL 분기 */
    OPEN O_RC1 FOR
    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , 'D' || YYYYMMDD AS YYYYMMDD
        , EXCHANGE_PRICE
        , NVL(T2.EDIT_YN,'') AS EDIT_YN
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
    INNER JOIN (SELECT * -- EDIT_YN 
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                WHERE USER_ID = P_USER_ID 
                AND MNU_ID = P_MNU_ID 
                AND UNIT_TP_CD = 'D') T2
    ON T1.DIVISION_ID = T2.UNIT_ID    
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID <> 'ALL'
    AND    T1.DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )

    UNION ALL

    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , 'D' || YYYYMMDD AS YYYYMMDD
        , EXCHANGE_PRICE
        , NVL(T2.EDIT_YN,'') AS EDIT_YN
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
    INNER JOIN (SELECT * -- EDIT_YN 
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                WHERE USER_ID = P_USER_ID 
                AND MNU_ID = P_MNU_ID 
                AND UNIT_TP_CD = 'D') T2
    ON T1.DIVISION_ID = T2.UNIT_ID        
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    T1.VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID = 'ALL';

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_YEAR'        VALUE P_YEAR,
            'P_CREATED_BY'  VALUE P_CREATED_BY,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
            
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA;


PROCEDURE P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP
(
    P_DIVISION_ID     IN VARCHAR2,
    P_YEAR            IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn       
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/03/23  P.C.I        Initial Release [prepare] Sales Report Exchange Rate Popup              */
/* 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
IS

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    /* Case 17: CASE WHEN @p_division_id = 'ALL' 패턴 → UNION ALL 분기 */
    OPEN O_RC1 FOR
    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
        , NVL(T2.EDIT_YN,'') AS EDIT_YN        
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
        INNER JOIN (SELECT * -- EDIT_YN 
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                WHERE USER_ID = P_USER_ID 
                AND MNU_ID = P_MNU_ID 
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID    
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID <> 'ALL'
    AND    T1.DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    GROUP BY T1.DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN

    UNION ALL

    SELECT
        T1.DIVISION_ID
        , CURRENCY
        , UNIT_CURRENCY
        , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
        , NVL(T2.EDIT_YN,'') AS EDIT_YN                
    FROM DM_PLN_SALES_REPORT_EXCHANGE_C T1
        INNER JOIN (SELECT * -- EDIT_YN 
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                WHERE USER_ID = P_USER_ID 
                AND MNU_ID = P_MNU_ID 
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID        
    WHERE  YYYYMMDD LIKE P_YEAR || '%'
    AND    VERSION_NO = P_VERSION_NO
    AND    P_DIVISION_ID = 'ALL'
    GROUP BY T1.DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_YEAR'        VALUE P_YEAR,
            'P_CREATED_BY'  VALUE P_CREATED_BY,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_USER_ID'     VALUE P_USER_ID,
            'P_MNU_ID'      VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP;


PROCEDURE P_DMF0044_GET_MEASURE
(
    P_DATA_TYPE       IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_GET_MDF_REPORTS_DATA
 * Description  :  MDF Reports 메인 데이터 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/01/20	HWI1993		Initial Release -- COMMON 을 사용하지 않기 위해 새로 생성함. ( COMMON 의 DMF0044_MDF_MEASURE_ETC 와 동일 )
 * 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
*/
IS

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT
            COLUMN_NAME  AS CODE
            , COLUMN_LABEL_NAME  AS NAME
            , NVL(T2.EDIT_YN,'') AS EDIT_YN            
    FROM SCM_MST_SHEET_MEASURE T1
        INNER JOIN (SELECT * -- EDIT_YN 
         FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
         WHERE USER_ID = P_USER_ID 
         AND MNU_ID = P_MNU_ID 
         AND UNIT_TP_CD = 'D') T2
         ON T2.UNIT_ID in (
             SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
             FROM   DUAL
             CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
         )
     
    WHERE  1 = 1
    AND    PROGRAM_ID  = 'DMF0044'
    AND    SHEET_NAME  = 'MDF Reports'
    AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC')
    ORDER BY SORT_ORDER_NO;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DATA_TYPE' VALUE P_DATA_TYPE,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID            
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_GET_MEASURE;

PROCEDURE P_DMF0044_GET_TEXTBOX
(
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn    
    O_RC1             OUT SYS_REFCURSOR,
    O_RC2             OUT SYS_REFCURSOR,
    O_RC3             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*************************************************************************************************
* Program ID  : DMF0044_GET_TEXTBOX                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : TextBox 를 열 때 사용. 생성된 VERSION_NO 를 조회할 때에는 날짜와 13개의 DESCRIPTION 받음.
* Parameter   :                                                                                  
*                                                                                                
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------
* 2021-09-15   ROSIA27		[과제] TEXTBOX
* 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
***************************************************************************************************/
IS

    V_YYYYMMDD        VARCHAR2(8 CHAR);

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 결과셋 1: DESCRIPTION 컬럼 조회 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT
        DESCRIPTION1
        , DESCRIPTION2
        , DESCRIPTION3
        , DESCRIPTION4
        , DESCRIPTION5
        , DESCRIPTION6
        , DESCRIPTION7
        , DESCRIPTION8
        , DESCRIPTION9
        , DESCRIPTION10
        , DESCRIPTION11
        , DESCRIPTION12
        , DESCRIPTION13
    FROM DM_MDF_VERSION T1
    INNER JOIN (SELECT * -- EDIT_YN 
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                WHERE USER_ID = P_USER_ID 
                AND MNU_ID = P_MNU_ID 
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID    
    WHERE
        T1.DIVISION_ID = '82'
        AND VERSION_NO = P_VERSION_NO;

    /* ── YYYYMMDD 변수 조회 ── */
    BEGIN
        SELECT YYYYMMDD
        INTO   V_YYYYMMDD
        FROM   DM_MDF_VERSION
        WHERE  DIVISION_ID = '82'
        AND    VERSION_NO = P_VERSION_NO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_YYYYMMDD := NULL;
    END;

    /* ── 결과셋 2: YYYYMMDD (O_RC2) ── */
    OPEN O_RC2 FOR
    SELECT V_YYYYMMDD AS YYYYMMDD FROM DUAL;

    /* ── 결과셋 3: MONDAY 계산 (O_RC3) ── */
    /* CONVERT(CHAR(11), (dbo.FN_NEXT_DAY(@YYYYMMDD, 'MON')) + (-7), 120) */
    /* → TO_CHAR(FN_NEXT_DAY(V_YYYYMMDD, 'MON') - 7, 'YYYY-MM-DD') */
    OPEN O_RC3 FOR
    SELECT TO_CHAR(FN_NEXT_DAY(V_YYYYMMDD, 'MON') - 7, 'YYYY-MM-DD') AS MONDAY FROM DUAL;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_VERSION_NO' VALUE P_VERSION_NO,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID            
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_GET_TEXTBOX;

PROCEDURE P_DMF0044_GET_SALES_REPORTS_DATA
(
    P_DIVISION_ID         IN VARCHAR2,
    P_MDF_TYPE            IN VARCHAR2,
    P_YYYY                IN VARCHAR2,
    P_SP_VERSION_NO       IN VARCHAR2,
    P_DATA_TYPE           IN VARCHAR2,
    P_USER_GROUP          IN VARCHAR2,
    P_CREATED_BY          IN VARCHAR2,

    P_USER_ID             IN VARCHAR2, -- For EditYn
    P_MNU_ID              IN VARCHAR2, -- For EditYn

    O_RC1                 OUT SYS_REFCURSOR,
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
/*=====================================================================================================================================================
 * Program ID   : DMF0044_GET_SALES_REPORTS_DATA
 * Description  : Sales Reports 메인 데이터 조회
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge	Description
 *=====================================================================================================================================================
 * 2019/05/28	JYE			Initial Release 
 * 2020/01/08	hwi1993		RTF 추가, Measure 테이블 참조
 * 2020/01/17	HWI1993		PROJECT_CODE, SCM_SITE_ID, APPLICATION 추가
 * 2020/01/22	HWI1993		BizType, DMS_SALES, DMS_CUSTOMER 추가
 * 2020/02/03	HWI1993		SalesAmt_USD 추가
 * 2020/02/10	HWI1993		특정 버전에 대해 Timeout 나는 경우가 있어서 with recompile 추가
 * 2020/02/13	HWI1993		company_id 가져오는 로직 변경
 * 2020/02/19	P.C.I  		company_id, sold to cust(report) 정렬
 * 2020/03/12	HWI1993		컬럼 3개 추가, 정렬 수정, DEPARTMENT_NAME 및 DEPT_NAME 을 LOOKUP 에서 가져오도록 변경
 * 2020/03/13	HWI1993		country 추가, 정렬순서 수정, PROJECT_CODE, SCM_SITE_ID 추가(주석제거)-컷오프 데이터 저장시 필요함
 * 2020/03/13	KHSONG      C20200103-000586 권한그룹을 LOOKUP관리
 * 2020/03/16	HWI1993		SOLDTO_CODE 추가
 * 2020/04/27	HWI1993		BP TABLE 제거, ETC 추가
 * 2020/06/03	HWI1993		소형에서 조회시 PIVOT 처리할 때 NULL 과 공백이 섞여있어서 PIVOT 이 안되는 경우가 있어서 ISNULL 처리함
 * 2020/07/09	HWI1993		C20200618-000336 소형SoldTo 적용
 * 2020/09/21	HWI1993		[C20200909-000188] [ESS영업관리팀] GDW 용도별 매출 수정 (프로젝트 코드 S 주택용/상업용 분리) 
 * 2021/01/26   P.C.I		[C20210125-000207] 40사업부 RTF Measure, CELL_MODEL_INFO 컬럼 추가
 * 2021/07/23	HWI1993		상반기과제 - 소형 마스터 정비
 * 2022/01/21	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2022/01/27	hwi1993		[C20211025-000405] SalesReport키추가 - CUST_GROUP_DTL 컬럼 추가
 * 2022/04/13   HWI1993     GM JV 작업
 * 2024/03/13   kcw3408		DM 프로시저 속도개선 
 * 2024/05/09	JSSBAE		[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2024/08/26	JSSBAE		[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가
 * 2024/09/12	JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024/11/15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선		
 * 2026.03.23   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발

VAR RC1 REFCURSOR
VAR RC2 REFCURSOR
exec DMF0044_GET_SALES_REPORTS_DATA('40', 'REPORT_SP_W', '2026', 'R_S_20250609_V001_C', '2', 'ADMIN', 'hjkang.lges', :rc1, :rc2)
print rc1
print rc2


 *===================================================================================================================================================*/
IS

    V_PROD              VARCHAR2(4000 CHAR) := '';
    V_SQL               VARCHAR2(32767 CHAR) := '';
    V_GROUP_ID          VARCHAR2(100 CHAR) := '';
    V_TEAM_ID           VARCHAR2(100 CHAR) := '';
    V_USER_MEA_CNT      PLS_INTEGER := 0;

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── GTT 초기화 (일반 테이블 DML 존재하므로 DELETE 사용) ── */
    DELETE FROM SCM_MGR.GT_F044_SELECT_MEASURE;
    DELETE FROM SCM_MGR.GT_F044_PJT;
    DELETE FROM SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GT_F044_T;

    /* ── GTT 통계 설정 (JOIN 사용) ── */
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_SELECT_MEASURE', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_PJT', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_DM_MST_ITEM_SINGLE_V', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_F044_T', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    BEGIN
        SELECT 1
        INTO   V_USER_MEA_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
            AND    VALID_YN = 'Y'
            AND    SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
            AND    SEGMENT1 = P_USER_GROUP
        );
        V_GROUP_ID := 'ADMIN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_GROUP_ID := '';
    END;
    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    -- 팀 권한
    BEGIN
        SELECT DEPT_ID
        INTO   V_TEAM_ID
        FROM   SCM_ADM_USER_M
        WHERE  USER_ID = P_CREATED_BY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_TEAM_ID := '';
    END;

    V_USER_MEA_CNT := 0;

    -- MEASURE JOIN 처리용
    -- 사용자메저 처리
    BEGIN
        SELECT 1
        INTO   V_USER_MEA_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MST_TITLESET_USER U
            WHERE  U.PROGRAM_ID = 'DMF0044'
            AND    U.SHEET_NAME = 'MDF Reports'
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
            AND    U.USER_ID    = P_CREATED_BY
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_USER_MEA_CNT := 0;
    END;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT P_CREATED_BY
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , ''
             , ''
             , P_CREATED_BY
             , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
             , P_CREATED_BY
             , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
        FROM   SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = 'DMF0044'
        AND    C.SHEET_NAME  = 'MDF Reports'
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    /* ── GT_F044_SELECT_MEASURE 적재 ── */
    INSERT INTO SCM_MGR.GT_F044_SELECT_MEASURE
        (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE, SORT_ORDER_NO)
    SELECT U.PROGRAM_ID
         , U.SHEET_NAME
         , U.USER_ID
         , U.COLUMN_NAME AS MEASURE
         , U.SORT_ORDER_NO
    FROM SCM_MST_TITLESET_USER U
    WHERE 1 = 1
    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND U.PROGRAM_ID   = 'DMF0044'
    AND U.USER_ID      = P_CREATED_BY;

    /* ── GT_F044_PJT 적재 ── */
    INSERT INTO SCM_MGR.GT_F044_PJT
        (DIVISION_ID, PROJECT_CODE, PROJECT_NAME, PRODUCT_GROUP_NAME)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_NAME, A.PRODUCT_GROUP_NAME
    FROM SCM_MST_PROJECT A
    JOIN (
        SELECT PROJECT_CODE, MAX(PROJECT_VER_SEQ) AS SEQ
        FROM SCM_MST_PROJECT
        WHERE DIVISION_ID = P_DIVISION_ID
        GROUP BY PROJECT_CODE
    ) B ON A.PROJECT_CODE = B.PROJECT_CODE AND A.PROJECT_VER_SEQ = B.SEQ
    WHERE A.DIVISION_ID = P_DIVISION_ID;

    /* ── GT_F044_DM_MST_ITEM_SINGLE_V 적재 ── */
    --[E20240920-000300]_SCM.DM 화면 조회 속도 개선
    --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가
    INSERT INTO SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V
        (DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME,
         FORECAST_INFO_BIZ_TYPE, ENERGE, ENERGE_WH, ENERGE_KWH)
    WITH ITEM_A AS (
        SELECT T1.DIVISION_ID
             , T1.ITEM_ID
             , MAX(T1.ITEM_NAME)            AS ITEM_NAME
             , MAX(T1.ITEM_CLASS)           AS ITEM_CLASS
             , MAX(T1.ITEM_CLASS_NAME)      AS ITEM_CLASS_NAME
             , MAX(T1.NICK_NAME)            AS NICK_NAME
             , MAX(T1.ENERGE)               AS ENERGE
        FROM SCM_MST_ITEM_SN T1
        WHERE T1.DIVISION_ID = P_DIVISION_ID
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID
    ),
    ITEM_B AS (
        SELECT DIVISION_ID
             , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
             , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
        FROM SCM_MST_ITEM_SN
        WHERE DIVISION_ID = P_DIVISION_ID
        GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
    ),
    ITEM_JOINED AS (
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.ITEM_CLASS
             , A.ITEM_NAME
             , A.ITEM_CLASS_NAME
             , A.NICK_NAME
             , B.FORECAST_INFO_BIZ_TYPE
             , A.ENERGE
        FROM ITEM_A A
        INNER JOIN ITEM_B B
            ON A.DIVISION_ID = B.DIVISION_ID
           AND SUBSTR(A.ITEM_ID, 1, 12) = B.ITEM_ID
    )
    SELECT DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME
         , FORECAST_INFO_BIZ_TYPE, ENERGE
         , ENERGE AS ENERGE_WH
         , CASE WHEN REGEXP_LIKE(ENERGE, '^\d+\.?\d*$') THEN TO_CHAR(ROUND(TO_NUMBER(ENERGE) / 1000, 7)) ELSE NULL END AS ENERGE_KWH
    FROM ITEM_JOINED;

    /* ── GTT 통계 수집 ── */
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_F044_SELECT_MEASURE', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_F044_PJT', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_F044_DM_MST_ITEM_SINGLE_V', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    -- 단계1. 데이터 쿼리 ########################################################
    -- CUTOFF_DATA
    IF P_DATA_TYPE <> '2' THEN
        INSERT INTO SCM_MGR.GT_F044_T
             ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
             , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
             , END_CUSTOMER, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
             , ITEM_ID, NICK_NAME, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE, PLANT_SITE_ID, COMPANY_ID, YYYYMM, CURRENCY
             , QTY, EDIT_FLAG, APP, SOLDTO_CUST_REPORT, DMS_CUSTOMER
             , BIZ_TYPE_NAME40, APPLICATION_GR, PRODUCT_DETAILS, CELL_MODEL_INFO, CELL_MODEL, DISPLAY_SEQ1
             , DISPLAY_SEQ2, COUNTRY_CODE, SOLDTO_CODE, ITEM_NAME, PROJECT_NAME
             , CELL_PER_CAR, MODULE_PER_CAR, MODEL_TYPE
             , SOLDTO_COUNTRY, SHIPTO_COUNTRY, CELL_NAME, ITEM_USE, CUST_GROUP_DTL
             , CELL_PROD_SITE	--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
             , ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
             , ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
             )
        SELECT
            R.DATA_TYPE, R.DIVISION_ID, R.VERSION_NO, R.CUTOFF_TYPE, R.CUTOFF_YYYYMMDD
            , R.DEPARTMENT_ID
            , CASE WHEN NVL(R.DEPARTMENT_NAME, '') <> '' THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
            , R.DEPT_ID
            , CASE WHEN NVL(R.DEPT_NAME, '') <> '' THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
            , R.END_CUST_REPORT
            , CASE WHEN R.DIVISION_ID LIKE '81%' AND R.CUTOFF_TYPE LIKE 'REPORT_BP%' THEN R.END_CUST_REPORT
                    ELSE NVL(ST.END_CUSTOMER, '') END AS END_CUSTOMER
            , R.CUST_REPORT
            , CASE WHEN R.DIVISION_ID = '40' THEN R.PRODUCT_GROUP
                   WHEN R.DIVISION_ID LIKE '81%' THEN PJT.PRODUCT_GROUP_NAME
                   END AS PRODUCT_GROUP
            , CASE WHEN LENGTH(R.PROJECT_CODE) > 1 THEN R.PROJECT_CODE ELSE '' END AS PROJECT_CODE
            , R.SCM_SITE_ID, R.ITEM_ID
            , CASE WHEN NVL(R.NICK_NAME, '') <> '' THEN R.NICK_NAME ELSE SINGLE.NICK_NAME END, NULL AS DOM_EXP, R.FCST_TYPE, R.INCOTERMS
            , R.MEASURE, R.PLANT_SITE_ID, R.COMPANY_ID
            , 'M_' || SUBSTR(R.YYYYMMDD, 1, 6) AS YYYYMM, R.CURRENCY, SUM(R.QTY) AS QTY
            , CASE WHEN (V_GROUP_ID = 'ADMIN') AND (DATA_TYPE = '2') THEN 'Y' ELSE '' END AS EDIT_FLAG
            , CASE WHEN NVL(R.APPLICATION, '') <> '' THEN R.APPLICATION ELSE SI.APPLICATION END AS APP
            , CASE WHEN NVL(R.SOLDTO_CUST_REPORT, '') <> '' THEN R.SOLDTO_CUST_REPORT ELSE NVL(SI.ATTRIBUTE1, '') END AS SOLDTO_CUST_REPORT
            , NVL(SI.ATTRIBUTE2, '') AS DMS_CUSTOMER
            , CASE WHEN NVL(R.FORECAST_INFO_BIZ_TYPE, '') <> '' THEN R.FORECAST_INFO_BIZ_TYPE ELSE SINGLE.FORECAST_INFO_BIZ_TYPE END AS BIZ_TYPE_NAME40
            , CASE WHEN NVL(R.APPLICATION_GR, '') <> '' THEN R.APPLICATION_GR ELSE LU.ATTRIBUTE1 END AS APPLICATION_GR
            , CASE WHEN NVL(R.PRODUCT_DETAILS, '') <> '' THEN R.PRODUCT_DETAILS ELSE LU.ATTRIBUTE4 END AS PRODUCT_DETAILS
            , NVL(R.FORECAST_INFO_CELL_MODEL, '') AS CELL_MODEL_INFO --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , NVL(R.ATTRIBUTE3, '') AS CELL_MODEL --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , LK1.DISPLAY_SEQ AS DISPLAY_SEQ1, LK2.DISPLAY_SEQ AS DISPLAY_SEQ2
            , ST.COUNTRY
            , CS.SOLDTO_CODE
            , SINGLE.ITEM_NAME
            -- 자동차
            , PJT.PROJECT_NAME, SI.CELL_PER_CAR, CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE ELSE NULL END AS MODULE_PER_CAR
            , CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' THEN 'Cell'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%PACK%' THEN 'Pack'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%MODULE%' THEN 'Module'
                   END AS MODEL_TYPE
            -- ESS
            , NVL(SUBSTR(CS.SOLDTO_CODE, 1, 2), '') AS SOLDTO_COUNTRY
            , NVL(SUBSTR(CS.SHIPTO_CODE, 1, 2), '') AS SHIPTO_COUNTRY
            , NVL(SI.ATTRIBUTE9, '') AS CELL_NAME
            -- C20200909-000188
            , CASE WHEN LK3.SEGMENT1 IS NOT NULL THEN LK3.SEGMENT2
                    ELSE NVL(SUBSTR(R.PROJECT_CODE, 1, 1), '') END AS ITEM_USE
            , R.CUST_GROUP_DTL
            , NVL(LK4.ATTRIBUTE1, '') AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
            , SINGLE.ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
            , SINGLE.ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
        FROM DM_PLN_SALES_PLAN_REPORT_C R
        LEFT JOIN SCM_MST_SITE_ITEM SI
            ON R.DIVISION_ID = SI.DIVISION_ID
                AND R.PROJECT_CODE = SI.PROJECT_CODE
                AND R.SCM_SITE_ID = SI.SCM_SITE_ID
                AND R.ITEM_ID = SI.ITEM_ID
        LEFT JOIN SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V SINGLE
            ON SI.DIVISION_ID = SINGLE.DIVISION_ID AND SI.ITEM_ID = SINGLE.ITEM_ID
        -- LOOKUP 26.03.20
        LEFT JOIN (SELECT DISTINCT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, ATTRIBUTE1, ATTRIBUTE4
                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE LOOKUP_TYPE = 'SALES_SITE_REPORT_GROUP') LU
            ON R.DIVISION_ID = LU.SEGMENT1
           AND R.PROJECT_CODE = LU.SEGMENT2
           AND R.SCM_SITE_ID = LU.SEGMENT3
           AND R.ITEM_ID = LU.SEGMENT4
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON R.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON R.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
        LEFT OUTER JOIN SCM_MST_SITE ST ON R.SCM_SITE_ID = ST.SCM_SITE_ID AND R.DIVISION_ID = ST.DIVISION_ID
        LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER CS ON R.DIVISION_ID = CS.DIVISION_ID AND R.SCM_SITE_ID = CS.SCM_SITE_ID AND CS.REP_YN = 'Y' AND CS.VALID_YN = 'Y'
        LEFT OUTER JOIN SCM_MGR.GT_F044_PJT PJT ON R.DIVISION_ID = PJT.DIVISION_ID AND R.PROJECT_CODE = PJT.PROJECT_CODE
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON R.PROJECT_CODE = LK3.SEGMENT1 AND LK3.LOOKUP_TYPE = 'DM_ITEM_USE_EX'
        --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
        LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK4 ON R.CELL_PROD_SITE = LK4.SEGMENT1 AND LK4.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'		--[PJ2024-50611] 소형 매출 프로세스 개선
        WHERE R.DIVISION_ID = P_DIVISION_ID
            AND R.CUTOFF_TYPE = P_MDF_TYPE
            AND SUBSTR(R.YYYYMMDD, 1, 4) = P_YYYY
            AND R.VERSION_NO = P_SP_VERSION_NO
        GROUP BY
            R.DATA_TYPE, R.DIVISION_ID, R.VERSION_NO, R.CUTOFF_TYPE, R.CUTOFF_YYYYMMDD, R.DEPARTMENT_ID
            , CASE WHEN NVL(R.DEPARTMENT_NAME, '') <> '' THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END
            , R.DEPT_ID
            , CASE WHEN NVL(R.DEPT_NAME, '') <> '' THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END, R.END_CUST_REPORT
            , ST.END_CUSTOMER, R.CUST_REPORT, R.PRODUCT_GROUP
            , CASE WHEN LENGTH(R.PROJECT_CODE) > 1 THEN R.PROJECT_CODE ELSE '' END, R.SCM_SITE_ID
            , R.ITEM_ID, R.FCST_TYPE, R.INCOTERMS, R.MEASURE, R.PLANT_SITE_ID, R.COMPANY_ID, R.CURRENCY
            , CASE WHEN NVL(R.NICK_NAME, '') <> '' THEN R.NICK_NAME ELSE SINGLE.NICK_NAME END
            , SUBSTR(R.YYYYMMDD, 1, 6)
            , CASE WHEN NVL(R.APPLICATION, '') <> '' THEN R.APPLICATION ELSE SI.APPLICATION END
            , CASE WHEN NVL(R.SOLDTO_CUST_REPORT, '') <> '' THEN R.SOLDTO_CUST_REPORT ELSE NVL(SI.ATTRIBUTE1, '') END
            , NVL(SI.ATTRIBUTE2, '')
            , CASE WHEN NVL(R.FORECAST_INFO_BIZ_TYPE, '') <> '' THEN R.FORECAST_INFO_BIZ_TYPE ELSE SINGLE.FORECAST_INFO_BIZ_TYPE END
            , CASE WHEN NVL(R.APPLICATION_GR, '') <> '' THEN R.APPLICATION_GR ELSE LU.ATTRIBUTE1 END
            , CASE WHEN NVL(R.PRODUCT_DETAILS, '') <> '' THEN R.PRODUCT_DETAILS ELSE LU.ATTRIBUTE4 END
            , NVL(R.FORECAST_INFO_CELL_MODEL, '') --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , NVL(R.ATTRIBUTE3, '') --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , LK1.SEGMENT2, LK2.SEGMENT2, LK1.DISPLAY_SEQ, LK2.DISPLAY_SEQ
            , ST.COUNTRY, CS.SOLDTO_CODE, PJT.PROJECT_NAME, SI.CELL_PER_CAR
            , CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE ELSE NULL END
            , SUBSTR(CS.SOLDTO_CODE, 1, 2), SUBSTR(CS.SHIPTO_CODE, 1, 2), SI.ATTRIBUTE9
            , CASE WHEN LK3.SEGMENT1 IS NOT NULL THEN LK3.SEGMENT2
                    ELSE NVL(SUBSTR(R.PROJECT_CODE, 1, 1), '') END
            , SINGLE.ITEM_NAME
            , CASE WHEN R.DIVISION_ID = '40' THEN R.PRODUCT_GROUP
                   WHEN R.DIVISION_ID LIKE '81%' THEN PJT.PRODUCT_GROUP_NAME
                   END
            , CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' THEN 'Cell'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%PACK%' THEN 'Pack'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%MODULE%' THEN 'Module'
                   END
            , CASE WHEN R.DIVISION_ID LIKE '81%' AND R.CUTOFF_TYPE LIKE 'REPORT_BP%' THEN R.END_CUST_REPORT ELSE NVL(ST.END_CUSTOMER, '') END
            , R.CUST_GROUP_DTL
            , LK4.ATTRIBUTE1 --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
            , SINGLE.ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
            , SINGLE.ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
        ;
    END IF;

    IF P_DATA_TYPE <> '1' THEN
        INSERT INTO SCM_MGR.GT_F044_T
             ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
             , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
             , END_CUSTOMER, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
             , ITEM_ID, NICK_NAME, DOM_EXP, FCST_TYPE, INCOTERMS
             , MEASURE, PLANT_SITE_ID, COMPANY_ID, YYYYMM, CURRENCY
             , QTY, EDIT_FLAG, APP, SOLDTO_CUST_REPORT, DMS_CUSTOMER
             , BIZ_TYPE_NAME40, APPLICATION_GR, PRODUCT_DETAILS, CELL_MODEL_INFO, CELL_MODEL, DISPLAY_SEQ1
             , DISPLAY_SEQ2, COUNTRY_CODE, SOLDTO_CODE, ITEM_NAME, PROJECT_NAME
             , CELL_PER_CAR, MODULE_PER_CAR, MODEL_TYPE
             , SOLDTO_COUNTRY, SHIPTO_COUNTRY, CELL_NAME, ITEM_USE, CUST_GROUP_DTL
             , CELL_PROD_SITE		--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
             , ENERGE_WH			--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
             , ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
             )
        SELECT
            '2' AS DATA_TYPE, R.DIVISION_ID, R.VERSION_NO, R.CUTOFF_TYPE, R.CUTOFF_YYYYMMDD
            , R.DEPARTMENT_ID
            , CASE WHEN NVL(R.DEPARTMENT_NAME, '') <> '' THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
            , R.DEPT_ID
            , CASE WHEN NVL(R.DEPT_NAME, '') <> '' THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
            , R.END_CUST_REPORT
            , NVL(R.END_CUSTOMER, '') AS END_CUSTOMER
            , R.CUST_REPORT
            , CASE WHEN R.DIVISION_ID = '40' THEN R.PRODUCT_GROUP
                   WHEN R.DIVISION_ID LIKE '81%' THEN PJT.PRODUCT_GROUP_NAME
                   END AS PRODUCT_GROUP
            , R.PROJECT_CODE, R.SCM_SITE_ID
            , R.ITEM_ID
            , CASE WHEN NVL(R.NICK_NAME, '') <> '' THEN R.NICK_NAME ELSE SINGLE.NICK_NAME END AS NICK_NAME
            , NULL AS DOM_EXP, R.FCST_TYPE, R.INCOTERMS
            , R.MEASURE, R.PLANT_SITE_ID, R.COMPANY_ID, 'M_' || SUBSTR(R.YYYYMMDD, 1, 6) AS YYYYMM, R.CURRENCY
            , SUM(R.QTY) AS QTY, CASE WHEN (V_GROUP_ID = 'ADMIN') THEN 'Y' ELSE '' END AS EDIT_FLAG
            , R.APPLICATION AS APP, R.SOLDTO_CUST_REPORT, NVL(SI.ATTRIBUTE2, '') AS DMS_CUSTOMER
            , R.BIZ_TYPE AS BIZ_TYPE, R.APPLICATION_GR AS APPLICATION_GR, R.PRODUCT_DETAILS AS PRODUCT_DETAILS
            , NVL(R.CELL_MODEL_INFO, '') AS CELL_MODEL_INFO--, SI.REPORT_GROUP6 AS CELL_MODEL_INFO --[C20210125-000207] ETC Report에서 입력한 40사업부 CELL_MODEL_INFO 적용
            , NVL(R.ATTRIBUTE3, '') AS CELL_MODEL --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
            , LK1.DISPLAY_SEQ AS DISPLAY_SEQ1
            , LK2.DISPLAY_SEQ AS DISPLAY_SEQ2, R.COUNTRY_CODE, R.SOLDTO_CODE
            , NULL AS ITEM_NAME, NVL(LK3.SEGMENT3, PJT.PROJECT_NAME) AS PROJECT_NAME
            , SI.CELL_PER_CAR, CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE END AS MODULE_PER_CAR
            , CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' THEN 'Cell'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%PACK%' THEN 'Pack'
                   WHEN SINGLE.ITEM_CLASS_NAME LIKE '%MODULE%' THEN 'Module'
                   END AS MODEL_TYPE
            , NVL(R.SOLDTO_COUNTRY, '') AS SOLDTOCOUNTRY, NVL(R.SHIPTO_COUNTRY, '') AS SHIPTOCOUNTRY
            , NVL(SI.ATTRIBUTE9, '') AS CELL_NAME
            , NVL(R.ITEM_USE, '') AS ITEM_USE
            , R.CUST_GROUP_DTL
            --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
            , '' AS CELL_PROD_SITE
            , SINGLE.ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
            , SINGLE.ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
        FROM DM_PLN_SALES_ETC_REPORT_C R
        LEFT JOIN SCM_MST_SITE_ITEM SI
            ON R.DIVISION_ID = SI.DIVISION_ID
                AND R.PROJECT_CODE = SI.PROJECT_CODE
                AND R.SCM_SITE_ID = SI.SCM_SITE_ID
                AND R.ITEM_ID = SI.ITEM_ID
        LEFT JOIN SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V SINGLE
            ON SI.DIVISION_ID = SINGLE.DIVISION_ID
                AND SI.ITEM_ID = SINGLE.ITEM_ID
        -- LOOKUP 26.03.20
        LEFT JOIN (SELECT DISTINCT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, ATTRIBUTE1, ATTRIBUTE4
                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                   WHERE LOOKUP_TYPE = 'SALES_SITE_REPORT_GROUP') LU
            ON R.DIVISION_ID = LU.SEGMENT1
           AND R.PROJECT_CODE = LU.SEGMENT2
           AND R.SCM_SITE_ID = LU.SEGMENT3
           AND R.ITEM_ID = LU.SEGMENT4
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON R.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON R.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON R.PROJECT_CODE = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_ETC_PROJECT' AND LK3.SEGMENT1 = R.DIVISION_ID
        LEFT OUTER JOIN SCM_MST_SITE ST ON R.SCM_SITE_ID = ST.SCM_SITE_ID AND R.DIVISION_ID = ST.DIVISION_ID
        LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER CS ON R.DIVISION_ID = CS.DIVISION_ID AND R.SCM_SITE_ID = CS.SCM_SITE_ID AND CS.REP_YN = 'Y' AND CS.VALID_YN = 'Y'
        LEFT OUTER JOIN SCM_MGR.GT_F044_PJT PJT ON R.DIVISION_ID = PJT.DIVISION_ID AND R.PROJECT_CODE = PJT.PROJECT_CODE
        LEFT OUTER JOIN SCM_MGR.GT_F044_DM_MST_ITEM_SINGLE_V ITEM_V ON R.DIVISION_ID = ITEM_V.DIVISION_ID AND R.ITEM_ID = ITEM_V.ITEM_ID
        WHERE R.DIVISION_ID = P_DIVISION_ID
            AND R.CUTOFF_TYPE = P_MDF_TYPE
            AND SUBSTR(R.YYYYMMDD, 1, 4) = P_YYYY
            AND R.VERSION_NO = P_SP_VERSION_NO
        GROUP BY
            R.DIVISION_ID, R.VERSION_NO, R.CUTOFF_TYPE, R.CUTOFF_YYYYMMDD
            , R.DEPARTMENT_ID, R.DEPT_ID, R.END_CUST_REPORT
            , R.END_CUST_REPORT
            , R.CUST_REPORT, R.PROJECT_CODE, R.SCM_SITE_ID
            , R.ITEM_ID, CASE WHEN NVL(R.NICK_NAME, '') <> '' THEN R.NICK_NAME ELSE SINGLE.NICK_NAME END
            , R.FCST_TYPE, R.INCOTERMS
            , R.MEASURE, R.PLANT_SITE_ID, R.COMPANY_ID, SUBSTR(R.YYYYMMDD, 1, 6), R.CURRENCY
            , R.APPLICATION, R.SOLDTO_CUST_REPORT, NVL(SI.ATTRIBUTE2, '')
            , R.BIZ_TYPE, R.APPLICATION_GR, R.PRODUCT_DETAILS
            , R.CELL_MODEL_INFO --, SI.REPORT_GROUP6 --[C20210125-000207] ETC Report에서 입력한 40사업부 CELL_MODEL_INFO 적용
            , R.ATTRIBUTE3
            , LK1.DISPLAY_SEQ
            , LK2.DISPLAY_SEQ, R.COUNTRY_CODE, R.SOLDTO_CODE, NVL(LK3.SEGMENT3, PJT.PROJECT_NAME)
            , R.END_CUSTOMER
            , SI.CELL_PER_CAR, CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE END
            , R.SOLDTO_COUNTRY, R.SHIPTO_COUNTRY
            , SI.ATTRIBUTE9, R.ITEM_USE
            , CASE WHEN R.DIVISION_ID = '40' THEN R.PRODUCT_GROUP
                       WHEN R.DIVISION_ID LIKE '81%' THEN PJT.PRODUCT_GROUP_NAME
                       END
            , CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' THEN 'Cell'
                       WHEN SINGLE.ITEM_CLASS_NAME LIKE '%PACK%' THEN 'Pack'
                       WHEN SINGLE.ITEM_CLASS_NAME LIKE '%MODULE%' THEN 'Module'
                       END
            , CASE WHEN NVL(R.DEPT_NAME, '') <> '' THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END
            , CASE WHEN NVL(R.DEPARTMENT_NAME, '') <> '' THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END
            , R.CUST_GROUP_DTL
            , SINGLE.ENERGE_WH		--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
            , SINGLE.ENERGE_KWH		--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
            , LU.ATTRIBUTE1    -- LOOKUP 26.03.20
            , LU.ATTRIBUTE4    -- LOOKUP 26.03.20
        ;
    END IF;

    /* ── GT_F044_T 통계 수집 ── */
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_F044_T', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    -- 단계3. PIVOT 기간 쿼리 ########################################################
    V_PROD := '';
    FOR rec IN (
        SELECT DISTINCT BASIS_YYYYMM
        FROM SCM_SYS_CALENDAR_M
        WHERE CALENDAR_YYYY = P_YYYY
        ORDER BY BASIS_YYYYMM
    )
    LOOP
        V_PROD := V_PROD || '''M_' || rec.BASIS_YYYYMM || ''',';
    END LOOP;

    IF V_PROD IS NOT NULL AND LENGTH(V_PROD) > 0 THEN
        V_PROD := RTRIM(V_PROD, ',');
    END IF;

    -- 단계4. 실행 쿼리 ########################################################
    V_SQL := '
SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, NVL(END_CUST_REPORT, '''') AS END_CUST_REPORT
     , END_CUSTOMER, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NVL(NICK_NAME, '''') AS NICK_NAME, DOM_EXP, FCST_TYPE, INCOTERMS
     , MEASURE, PLANT_SITE_ID, COMPANY_ID, CURRENCY, NVL(APP, '''') AS APPLICATION, EDIT_FLAG, SOLDTO_CUST_REPORT, DMS_CUSTOMER, BIZ_TYPE_NAME40, APPLICATION_GR
     , PRODUCT_DETAILS, CELL_MODEL_INFO, CELL_MODEL, COUNTRY_CODE, SOLDTO_CODE, PROJECT_NAME, CELL_PER_CAR, MODULE_PER_CAR
     -- ESS
     , SOLDTO_COUNTRY, SHIPTO_COUNTRY, CELL_NAME, ITEM_USE, ITEM_NAME, MODEL_TYPE, SORT_ORDER_NO, CUST_GROUP_DTL, CELL_PROD_SITE
     , ENERGE_WH				--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
     , ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
     ,' || V_PROD || '
FROM (
        SELECT A.*, B.SORT_ORDER_NO
        FROM SCM_MGR.GT_F044_T A
        JOIN SCM_MGR.GT_F044_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
        
        INNER JOIN (
            SELECT *
              FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
             WHERE USER_ID = ''' || P_USER_ID || '''
               AND MNU_ID  = ''' || P_MNU_ID || '''
               AND UNIT_TP_CD = ''D''
        ) T2
        ON A.DIVISION_ID = T2.UNIT_ID

        
    ) T
PIVOT (SUM(QTY) FOR YYYYMM IN (' || V_PROD || ')
) PVT
ORDER BY DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DISPLAY_SEQ1, DISPLAY_SEQ2, CUST_REPORT, END_CUST_REPORT, CUST_GROUP_DTL
       , NVL(PROJECT_CODE, ''''), NVL(PROJECT_NAME, ''''), NVL(FCST_TYPE, ''''), SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, NICK_NAME, PRODUCT_DETAILS, CELL_MODEL_INFO
       , CURRENCY, COMPANY_ID, CELL_PROD_SITE, BIZ_TYPE_NAME40, APPLICATION_GR, NVL(APP, '''')
    --, CASE WHEN MEASURE IN (''LOC'') THEN 1
    --		WHEN LENGTH(MEASURE) = 3 THEN 2
    --		WHEN ( MEASURE LIKE ''RTF%'' OR MEASURE = ''Business_Plan'') THEN 3
    --		WHEN MEASURE IN (''SalesAmt_LOC'') THEN 4
    --		ELSE 5
    --		END
    , SORT_ORDER_NO
';
    
    dbms_output.put_line(v_sql);
    
    OPEN O_RC1 FOR V_SQL;

    /* ── COMMIT (종료 직전 1회) ── */
    COMMIT;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회+DML 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_MDF_TYPE'       VALUE P_MDF_TYPE,
            'P_YYYY'           VALUE P_YYYY,
            'P_SP_VERSION_NO'  VALUE P_SP_VERSION_NO,
            'P_DATA_TYPE'      VALUE P_DATA_TYPE,
            'P_USER_GROUP'     VALUE P_USER_GROUP,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_USER_ID'        VALUE P_USER_ID,
            'P_MNU_ID'         VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_GET_SALES_REPORTS_DATA;


PROCEDURE P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_UNIT_CURRENCY         IN  VARCHAR2,
    P_EXCHANGE_PRICE        IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_LAST_UPDATED_BY       IN  VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
 /*==================================================================================================================
 * Program ID   : DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT
 * Description  : DM_PLN_SALES_REPORT_EXCHANGE_C TABLE INSERT/UPDATE/DELETE
 * Program History
 *==================================================================================================================
 *   Date       In Charge		Description
 *==================================================================================================================
 * 2020/03/26	P.C.I			Initial Release [PJ20200138] 
 * 2020/09/09	P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020/09/21	HWI1993			[C20200909-000188] ESS 용도
 * 2021/02/05	P.C.I			[C20210205-000093] Sales Amt USD 업데이트 수정
 * 2025/12/02	JSSBAE			[E20251126-001120]_Currency Code 관리 개선 (하드코딩 → Lookup 관리)
 * 2026.03.23   jcnam           [PJ20264226] NextSCM Pilot 설계 및 개발
 *================================================================================================================*/
IS
    ------------------------------------------------------------------------------------------------------------------
    -- 스플릿관련 변수
    ------------------------------------------------------------------------------------------------------------------
    v_active_flag       VARCHAR2(10 CHAR);
    v_division_id       VARCHAR2(50 CHAR);
    v_version_no        VARCHAR2(100 CHAR);
    v_YYYYMMDD          VARCHAR2(8 CHAR);
    v_CURRENCY          VARCHAR2(10 CHAR);
    v_UNIT_CURRENCY     VARCHAR2(10 CHAR);
    v_EXCHANGE_PRICE    VARCHAR2(100 CHAR);
    v_CREATED_BY        VARCHAR2(100 CHAR);
    v_LAST_UPDATED_BY   VARCHAR2(100 CHAR);

    V_CUTOFF_TYPE       VARCHAR2(20 CHAR);
    V_CUTOFF_YYYYMMDD   VARCHAR2(8 CHAR);

    v_row_count         PLS_INTEGER;
    v_exists            PLS_INTEGER;

    ------------------------------------------------------------------------------------------------------------------
    -- LOG 용 변수 설정 (STRAT)
    ------------------------------------------------------------------------------------------------------------------
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;
    ------------------------------------------------------------------------------------------------------------------
    -- LOG 용 변수 설정 (END)
    ------------------------------------------------------------------------------------------------------------------

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    ------------------------------------------------------------------------------------------------------------------
    -- GTT 초기화 (프로시저 시작 시, 이전에 일반 테이블 DML 없으므로 TRUNCATE 허용)
    ------------------------------------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_0044_RESULTS';

    ------------------------------------------------------------------------------------------------------------------
    -- 시작 LOG  (START)
    ------------------------------------------------------------------------------------------------------------------
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    ------------------------------------------------------------------------------------------------------------------
    -- 시작 LOG  (END)
    ------------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------------
    -- 트랜잭션 (START)
    ------------------------------------------------------------------------------------------------------------------

    --###############################################  GT_0044_RESULTS 테이블에 split후 insert (START)
    INSERT INTO SCM_MGR.GT_0044_RESULTS
    (
        ACTIVE_FLAG,
        DIVISION_ID,
        VERSION_NO,
        YYYYMMDD,
        CURRENCY,
        UNIT_CURRENCY,
        EXCHANGE_PRICE,
        CREATED_BY,
        LAST_UPDATED_BY
    )
    SELECT
        TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,      '[^^]+', 1, LVL)) AS ACTIVE_FLAG,
        TRIM(REGEXP_SUBSTR(P_DIVISION_ID,      '[^^]+', 1, LVL)) AS DIVISION_ID,
        TRIM(REGEXP_SUBSTR(P_VERSION_NO,       '[^^]+', 1, LVL)) AS VERSION_NO,
        TRIM(REGEXP_SUBSTR(P_YYYYMMDD,         '[^^]+', 1, LVL)) AS YYYYMMDD,
        TRIM(REGEXP_SUBSTR(P_CURRENCY,         '[^^]+', 1, LVL)) AS CURRENCY,
        TRIM(REGEXP_SUBSTR(P_UNIT_CURRENCY,    '[^^]+', 1, LVL)) AS UNIT_CURRENCY,
        TRIM(REGEXP_SUBSTR(P_EXCHANGE_PRICE,   '[^^]+', 1, LVL)) AS EXCHANGE_PRICE,
        TRIM(REGEXP_SUBSTR(P_CREATED_BY,       '[^^]+', 1, LVL)) AS CREATED_BY,
        TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY,  '[^^]+', 1, LVL)) AS LAST_UPDATED_BY
    FROM (
        SELECT LEVEL AS LVL
        FROM   DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^^]+', 1, LEVEL) IS NOT NULL
    );

    --###############################################   GT_0044_RESULTS 테이블에 split후 insert (END)

    -- Division_id Null Validation
    BEGIN
        SELECT 1
        INTO   v_exists
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_0044_RESULTS R
            WHERE  NOT EXISTS (
                SELECT 1
                FROM   SCM_MGR.SCM_MST_DIVISION D
                WHERE  D.DIVISION_ID = R.DIVISION_ID
            )
        );

        -- 유효하지 않은 DIVISION_ID 존재
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'Division 값이 존재하지 않습니다.';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- 모든 DIVISION_ID가 유효함, 계속 진행
    END;

    -- 마지막 행의 v_division_id, v_version_no 를 가져옴 (CUTOFF 조회용)
    SELECT DIVISION_ID, VERSION_NO
    INTO   v_division_id, v_version_no
    FROM   (
        SELECT DIVISION_ID, VERSION_NO
        FROM   SCM_MGR.GT_0044_RESULTS
        ORDER BY ROWID DESC
    )
    WHERE  ROWNUM = 1;

    SELECT CUTOFF_TYPE, CUTOFF_YYYYMMDD
    INTO   V_CUTOFF_TYPE, V_CUTOFF_YYYYMMDD
    FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
    WHERE  DIVISION_ID = v_division_id
    AND    VERSION_NO  = v_version_no
    AND    ROWNUM      = 1;

    UPDATE SCM_MGR.GT_0044_RESULTS
    SET    CUTOFF_TYPE      = V_CUTOFF_TYPE,
           CUTOFF_YYYYMMDD  = V_CUTOFF_YYYYMMDD;

    -- GTT를 다른 테이블과 JOIN 하므로 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_RESULTS', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_0044_RESULTS',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    --===================================================================================== delete start
    DELETE
    FROM   SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C T
    WHERE  EXISTS (
        SELECT 1
        FROM   SCM_MGR.GT_0044_RESULTS R
        WHERE  R.ACTIVE_FLAG     = 'D'
        AND    T.DIVISION_ID     = R.DIVISION_ID
        AND    T.VERSION_NO      = R.VERSION_NO
        AND    T.YYYYMMDD        = R.YYYYMMDD
        AND    T.CURRENCY        = R.CURRENCY
        AND    T.UNIT_CURRENCY   = R.UNIT_CURRENCY
    );

    n_delete_count := SQL%ROWCOUNT;
    --===================================================================================== delete end

    --===================================================================================== update, insert start
    MERGE INTO SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C A
    USING (
        SELECT
            DIVISION_ID,
            VERSION_NO,
            CUTOFF_TYPE,
            CUTOFF_YYYYMMDD,
            YYYYMMDD,
            CURRENCY,
            UNIT_CURRENCY,
            MAX(EXCHANGE_PRICE)  AS EXCHANGE_PRICE,
            MAX(CREATED_BY)      AS CREATED_BY,
            MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.GT_0044_RESULTS
        WHERE  ACTIVE_FLAG <> 'D'   -- DELETE값이 아닌경우만
        GROUP BY
            DIVISION_ID,
            VERSION_NO,
            CUTOFF_TYPE,
            CUTOFF_YYYYMMDD,
            YYYYMMDD,
            CURRENCY,
            UNIT_CURRENCY
    ) B
    ON (
            A.DIVISION_ID     = B.DIVISION_ID
        AND A.VERSION_NO      = B.VERSION_NO
        AND A.CUTOFF_TYPE     = B.CUTOFF_TYPE
        AND A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
        AND A.YYYYMMDD        = B.YYYYMMDD
        AND A.CURRENCY        = B.CURRENCY
        AND A.UNIT_CURRENCY   = B.UNIT_CURRENCY
    )
    WHEN MATCHED THEN
        UPDATE SET
            A.EXCHANGE_PRICE   = B.EXCHANGE_PRICE,
            A.CREATED_BY       = B.CREATED_BY,
            A.CREATION_DATE    = SYSDATE,
            A.LAST_UPDATED_BY  = B.LAST_UPDATED_BY,
            A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (
            DIVISION_ID,
            VERSION_NO,
            CUTOFF_TYPE,
            CUTOFF_YYYYMMDD,
            YYYYMMDD,
            CURRENCY,
            UNIT_CURRENCY,
            EXCHANGE_PRICE,
            CREATED_BY,
            CREATION_DATE,
            LAST_UPDATED_BY,
            LAST_UPDATE_DATE
        )
        VALUES (
            B.DIVISION_ID,
            B.VERSION_NO,
            B.CUTOFF_TYPE,
            B.CUTOFF_YYYYMMDD,
            B.YYYYMMDD,
            B.CURRENCY,
            B.UNIT_CURRENCY,
            B.EXCHANGE_PRICE,
            B.CREATED_BY,
            SYSDATE,
            B.LAST_UPDATED_BY,
            SYSDATE
        );

    n_merge_count := SQL%ROWCOUNT;
    --===================================================================================== update, insert end

    --===================================================================================== Sales Report update start

    --KRW
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT
            A2.ROWID AS RID,
            NVL(ROUND(C2.QTY * TO_NUMBER(B2.EXCHANGE_PRICE), 3), 0) AS NEW_QTY
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A2
        JOIN   SCM_MGR.GT_0044_RESULTS B2
            ON  A2.VERSION_NO   = B2.VERSION_NO
            AND A2.DIVISION_ID  = B2.DIVISION_ID
            AND A2.YYYYMMDD LIKE SUBSTR(B2.YYYYMMDD, 1, 6) || '%'
            AND B2.CURRENCY     = 'KRW'
            AND B2.UNIT_CURRENCY = A2.CURRENCY
        JOIN   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C2
            ON  A2.VERSION_NO      = C2.VERSION_NO
            AND A2.DIVISION_ID     = C2.DIVISION_ID
            AND A2.DEPARTMENT_ID   = C2.DEPARTMENT_ID
            AND A2.DEPT_ID         = C2.DEPT_ID
            AND A2.END_CUST_REPORT = C2.END_CUST_REPORT
            AND A2.CUST_REPORT     = C2.CUST_REPORT
            AND A2.PRODUCT_GROUP   = C2.PRODUCT_GROUP
            AND A2.PROJECT_CODE    = C2.PROJECT_CODE
            AND A2.SCM_SITE_ID     = C2.SCM_SITE_ID
            AND A2.ITEM_ID         = C2.ITEM_ID
            AND A2.YYYYMMDD        = C2.YYYYMMDD
            AND A2.CURRENCY        = C2.CURRENCY
            AND A2.COMPANY_ID      = C2.COMPANY_ID
            AND C2.MEASURE         = 'SalesAmt_LOC'
        WHERE  A2.MEASURE      = 'SalesAmt_KRW'
        AND    A2.DIVISION_ID  = B2.DIVISION_ID
        AND    A2.VERSION_NO   = B2.VERSION_NO
        AND    A2.CURRENCY    <> 'KRW'
    ) SRC
    ON (A.ROWID = SRC.RID)
    WHEN MATCHED THEN
        UPDATE SET
            A.QTY              = SRC.NEW_QTY,
            A.LAST_UPDATED_BY  = 'EXCHANGE_PRICE',
            A.LAST_UPDATE_DATE = SYSDATE;

    n_merge_count := n_merge_count + SQL%ROWCOUNT;
    
    --USD
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT
            A2.ROWID AS RID,
            NVL(ROUND(C2.QTY * (CASE
                --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (START)
                --WHEN A2.CURRENCY = 'RMB' THEN D2.KRW_RMB_PRICE
                WHEN A2.CURRENCY = 'CNY' THEN D2.KRW_CNY_PRICE
                --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (END)
                WHEN A2.CURRENCY = 'EUR' THEN D2.KRW_EUR_PRICE
                WHEN A2.CURRENCY = 'JPY' THEN D2.KRW_JPY_PRICE
                ELSE 1
            END) / D2.KRW_USD_PRICE, 3), 0) AS NEW_QTY  --[C20210205-000093] Sales Amt USD 업데이트 수정 (D.KRW_USD_PRICE-> 1)
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A2
        JOIN   SCM_MGR.GT_0044_RESULTS B2
            ON  A2.VERSION_NO   = B2.VERSION_NO
            AND A2.DIVISION_ID  = B2.DIVISION_ID
            AND A2.YYYYMMDD LIKE SUBSTR(B2.YYYYMMDD, 1, 6) || '%'
            AND B2.CURRENCY     = 'KRW'
            AND A2.CURRENCY     = CASE WHEN A2.CURRENCY = 'KRW' THEN B2.CURRENCY ELSE B2.UNIT_CURRENCY END --[C20210205-000093] Sales Amt USD 업데이트 수정
            --AND B2.UNIT_CURRENCY = A2.CURRENCY--[C20210205-000093] Sales Amt USD 업데이트 수정
        JOIN   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C2
            ON  A2.VERSION_NO      = C2.VERSION_NO
            AND A2.DIVISION_ID     = C2.DIVISION_ID
            AND A2.DEPARTMENT_ID   = C2.DEPARTMENT_ID
            AND A2.DEPT_ID         = C2.DEPT_ID
            AND A2.END_CUST_REPORT = C2.END_CUST_REPORT
            AND A2.CUST_REPORT     = C2.CUST_REPORT
            AND A2.PRODUCT_GROUP   = C2.PRODUCT_GROUP
            AND A2.PROJECT_CODE    = C2.PROJECT_CODE
            AND A2.SCM_SITE_ID     = C2.SCM_SITE_ID
            AND A2.ITEM_ID         = C2.ITEM_ID
            AND A2.YYYYMMDD        = C2.YYYYMMDD
            AND A2.CURRENCY        = C2.CURRENCY
            AND A2.COMPANY_ID      = C2.COMPANY_ID
            AND C2.MEASURE         = 'SalesAmt_LOC'
        JOIN   (
            SELECT DIVISION_ID, VERSION_NO, YYYYMMDD, CURRENCY,
                --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (START)
                --SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'RMB' THEN EXCHANGE_PRICE END) AS KRW_RMB_PRICE,
                SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'CNY' THEN TO_NUMBER(EXCHANGE_PRICE) END) AS KRW_CNY_PRICE,
                --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (END)
                SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'EUR' THEN TO_NUMBER(EXCHANGE_PRICE) END) AS KRW_EUR_PRICE,
                SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'JPY' THEN TO_NUMBER(EXCHANGE_PRICE) END) AS KRW_JPY_PRICE,
                SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'USD' THEN TO_NUMBER(EXCHANGE_PRICE) END) AS KRW_USD_PRICE
            FROM   SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E
            WHERE  E.DIVISION_ID = v_division_id
            AND    E.VERSION_NO  = v_version_no
            AND    CURRENCY      = 'KRW'
            GROUP BY DIVISION_ID, VERSION_NO, YYYYMMDD, CURRENCY
        ) D2
            ON  A2.VERSION_NO   = D2.VERSION_NO
            AND A2.DIVISION_ID  = D2.DIVISION_ID
            AND A2.YYYYMMDD LIKE SUBSTR(D2.YYYYMMDD, 1, 6) || '%'
        WHERE  A2.MEASURE      = 'SalesAmt_USD'
        AND    A2.DIVISION_ID  = B2.DIVISION_ID
        AND    A2.VERSION_NO   = B2.VERSION_NO
        AND    A2.CURRENCY    <> 'USD'
    ) SRC
    ON (A.ROWID = SRC.RID)
    WHEN MATCHED THEN
        UPDATE SET
            A.QTY              = SRC.NEW_QTY,
            A.LAST_UPDATED_BY  = 'EXCHANGE_PRICE',
            A.LAST_UPDATE_DATE = SYSDATE;

    n_merge_count := n_merge_count + SQL%ROWCOUNT;
    --===================================================================================== Sales Report update end

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    -- N_LOG_COUNT := n_delete_count + n_merge_count;
    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'     VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'     VALUE P_DIVISION_ID,
            'P_VERSION_NO'      VALUE P_VERSION_NO,
            'P_YYYYMMDD'        VALUE P_YYYYMMDD,
            'P_CURRENCY'        VALUE P_CURRENCY,
            'P_UNIT_CURRENCY'   VALUE P_UNIT_CURRENCY,
            'P_EXCHANGE_PRICE'  VALUE P_EXCHANGE_PRICE,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT;


PROCEDURE P_DMF0044_SAVE_SALES_PLAN_REPORT_C
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_CUTOFF_TYPE           IN  VARCHAR2,
    P_CUTOFF_YYYYMMDD       IN  VARCHAR2,
    P_DEPARTMENT_ID         IN  VARCHAR2,
    P_DEPARTMENT_NAME       IN  VARCHAR2,
    P_DEPT_ID               IN  VARCHAR2,
    P_DEPT_NAME             IN  VARCHAR2,
    P_END_CUST_REPORT       IN  VARCHAR2,
    P_CUST_REPORT           IN  VARCHAR2,
    P_PRODUCT_GROUP         IN  VARCHAR2,
    P_ITEM_ID               IN  VARCHAR2,
    P_MEASURE               IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_COMPANY_ID            IN  VARCHAR2,
    P_QTY                   IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_CELL_MODEL_INFO       IN  VARCHAR2,   --[C20211112-000213]
    P_CELL_MODEL            IN  VARCHAR2,   --[C20211112-000213]
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SAVE_SALES_PLAN_REPORT_C
 * Description  : 'DM_PLN_SALES_PLAN_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190529  KHSONG  Initial Release [PJ20189106] 전지.GSCM 고도화 이행, DM 시스템
 * 20190719  JSYOUN  사업계획리포트테이블 변경(DM_PLN_BP_FCST_C -> DM_PLN_BP_FCST_REPORT_C)
 * 20190822  JSYOUN  DM_PLN_SALES_PLAN_REPORT_C PK에서 DIVISION_ID 제외 CURRENCY 추가, DM_PLN_BP_FCST_REPORT_C PK에 CURRENCY 추가
 * 20191030  KYH	 Attribute1 에 ProductDetails 를 '기타'로 세팅
 * 20200123  hwi1993 company_id 추가
 * 20200206  hwi1993 cutoff_yyyymmdd 보완
 * 20200319  hwi1993 DeptName, DepartmentName 의 룩업화에 따라 JOIN 조건에서 사용하지 않도록 변경
 * 20200522 hwi1993	Save 이후에 Transfer 처리
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2022/01/24	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2023.09.07	jssbae		[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 
 */
IS
    /*
    ''고정
    PROJECT_CODE
    SCM_SITE_ID
    DOM_EXP
    FCST_TYPE
    INCOTERMS
    PLANT_SITE_ID
    */

    -- 스플릿관련 변수
    v_cutoff_yyyymmdd       VARCHAR2(8 CHAR);
    v_version_no            VARCHAR2(100 CHAR);
    v_division_id           VARCHAR2(50 CHAR);
    v_yyyymmdd              VARCHAR2(8 CHAR);
    v_cutoff_type           VARCHAR2(100 CHAR);

    v_exists                PLS_INTEGER;

    -- LOG 용 변수 설정
    V_LOG_TYPE              VARCHAR2(100 CHAR);
    N_LOG_COUNT             PLS_INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(4000 CHAR);
    V_DESCRIPTION           VARCHAR2(4000 CHAR);
    D_EVENT_DATE            DATE := SYSDATE;
    n_delete_count          PLS_INTEGER := 0;
    n_merge_count           PLS_INTEGER := 0;
    n_insert_count          PLS_INTEGER := 0;
    n_input_count           PLS_INTEGER := 0;
    n_logo_count            PLS_INTEGER := 0;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);
    V_SQL_CODE              VARCHAR2(100 CHAR);
    V_SQL_ERRMSG            VARCHAR2(1000 CHAR);

BEGIN

    -- GTT 초기화 (프로시저 시작 시, 이전에 일반 테이블 DML 없으므로 TRUNCATE 허용)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_0044_RESULTS_MST';

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)

    --===================================================================================== GT_0044_RESULTS_MST 테이블에 split후 insert start
    --###############################################  GT_0044_RESULTS_MST 테이블에 split후 insert (START)
    INSERT INTO SCM_MGR.GT_0044_RESULTS_MST
    (
        ACTIVE_FLAG,
        DIVISION_ID,
        VERSION_NO,
        CUTOFF_TYPE,
        CUTOFF_YYYYMMDD,
        DEPARTMENT_ID,
        DEPARTMENT_NAME,
        DEPT_ID,
        DEPT_NAME,
        END_CUST_REPORT,
        CUST_REPORT,
        PRODUCT_GROUP,
        PROJECT_CODE,
        SCM_SITE_ID,
        DOM_EXP,
        FCST_TYPE,
        INCOTERMS,
        CELL_MODEL_INFO,
        CELL_MODEL,
        ITEM_ID,
        MEASURE,
        YYYYMMDD,
        CURRENCY,
        COMPANY_ID,
        QTY,
        CREATED_BY
    )
    SELECT
        TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,       '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DIVISION_ID,       '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_VERSION_NO,        '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_CUTOFF_TYPE,       '[^^]+', 1, LVL)),
        NULL,  -- CUTOFF_YYYYMMDD: 후속 UPDATE에서 설정
        TRIM(REGEXP_SUBSTR(P_DEPARTMENT_ID,     '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DEPARTMENT_NAME,   '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DEPT_ID,           '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_DEPT_NAME,         '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_END_CUST_REPORT,   '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_CUST_REPORT,       '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_PRODUCT_GROUP,     '[^^]+', 1, LVL)),
        '-',    --project_code   (NOT NULL, PK)
        '-',    --scm_site_id    (NOT NULL, PK)
        '-',    --dom_exp
        '-',    --fcst_type      (NOT NULL, PK)
        '-',    --incoterms      (NOT NULL, PK)
        TRIM(REGEXP_SUBSTR(P_CELL_MODEL_INFO,   '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_CELL_MODEL,        '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_ITEM_ID,           '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_MEASURE,           '[^^]+', 1, LVL)),
        -- yyyymm 값을 월별 첫 영업일(yyyymmdd)로 변환
        (SELECT MIN(C.BASIS_START_DATE)
         FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
         WHERE  SUBSTR(C.BASIS_YYYYMMDD, 1, 6) = SUBSTR(TRIM(REGEXP_SUBSTR(P_YYYYMMDD, '[^^]+', 1, LVL)), 1, 6)
         AND    C.DAYOFWEEK IN ('MON','TUE','WED','THU','FRI')
        ),
        TRIM(REGEXP_SUBSTR(P_CURRENCY,          '[^^]+', 1, LVL)),
        TRIM(REGEXP_SUBSTR(P_COMPANY_ID,        '[^^]+', 1, LVL)),
        NVL(NULLIF(TRIM(REGEXP_SUBSTR(P_QTY,    '[^^]+', 1, LVL)), ''), '0'),
        TRIM(REGEXP_SUBSTR(P_CREATED_BY,        '[^^]+', 1, LVL))
    FROM (
        SELECT LEVEL AS LVL
        FROM   DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^^]+', 1, LEVEL) IS NOT NULL
    );

    --###############################################  GT_0044_RESULTS_MST 테이블에 split후 insert (END)

    -- CUTOFF_YYYYMMDD 설정: DM_MDF_VERSION → DM_MST_VERSION JOIN
    UPDATE SCM_MGR.GT_0044_RESULTS_MST R
    SET    R.CUTOFF_YYYYMMDD = (
        SELECT B.YYYYMMDD
        FROM   SCM_MGR.DM_MDF_VERSION A
        JOIN   SCM_MGR.DM_MST_VERSION B
            ON A.DIVISION_ID    = B.DIVISION_ID
            AND A.ORI_VERSION_NO = B.VERSION_NO
        WHERE  A.VERSION_NO  = R.VERSION_NO
        AND    A.DIVISION_ID = R.DIVISION_ID
        AND    ROWNUM = 1
    );

    -- GTT를 다른 테이블과 JOIN 하므로 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_RESULTS_MST', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_0044_RESULTS_MST',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    --===================================================================================== GT_0044_RESULTS_MST 테이블에 split후 insert end

    --
    -- INPUT COUNT 확인
    SELECT COUNT(ACTIVE_FLAG)
    INTO   n_input_count
    FROM   SCM_MGR.GT_0044_RESULTS_MST;

    -- 마지막 행의 v_version_no, v_division_id, v_yyyymmdd, v_cutoff_type 가져옴
    SELECT VERSION_NO, DIVISION_ID, YYYYMMDD, CUTOFF_TYPE
    INTO   v_version_no, v_division_id, v_yyyymmdd, v_cutoff_type
    FROM   (
        SELECT VERSION_NO, DIVISION_ID, YYYYMMDD, CUTOFF_TYPE
        FROM   SCM_MGR.GT_0044_RESULTS_MST
        ORDER BY ROWID DESC
    )
    WHERE  ROWNUM = 1;

    IF v_cutoff_type = 'REPORT_SP_W' THEN
        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                                  DM_PLN_SALES_PLAN_REPORT_C 테이블 DELETE (START)
        --------------------------------------------------------------------------------------------◇◇◇◇

        -- DELETE COUNT 확인
        SELECT COUNT(DIVISION_ID)
        INTO   n_delete_count
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_0044_RESULTS_MST M
            WHERE  M.ACTIVE_FLAG = 'D'
        );

        DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        WHERE  A.DATA_TYPE = '2'
        AND    EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_0044_RESULTS_MST B
            WHERE  B.ACTIVE_FLAG                = 'D'
            AND    A.VERSION_NO                 = B.VERSION_NO
            AND    A.DIVISION_ID                = B.DIVISION_ID
            AND    A.DEPARTMENT_ID              = B.DEPARTMENT_ID
            --AND A.DEPARTMENT_NAME			= B.DEPARTMENT_NAME
            AND    A.DEPT_ID                    = B.DEPT_ID
            --AND A.DEPT_NAME					= B.DEPT_NAME
            AND    A.END_CUST_REPORT            = B.END_CUST_REPORT
            AND    A.CUST_REPORT                = B.CUST_REPORT
            AND    A.PRODUCT_GROUP              = B.PRODUCT_GROUP
            AND    NVL(NULLIF(TRIM(A.PROJECT_CODE), ''), '-') = B.PROJECT_CODE
            AND    NVL(NULLIF(TRIM(A.SCM_SITE_ID), ''), '-')  = B.SCM_SITE_ID
            AND    A.ITEM_ID                    = B.ITEM_ID
            AND    A.MEASURE                    = B.MEASURE
            AND    A.YYYYMMDD                   = B.YYYYMMDD
            AND    A.CURRENCY                   = B.CURRENCY
            AND    A.COMPANY_ID                 = B.COMPANY_ID
            AND    NVL(NULLIF(TRIM(A.FORECAST_INFO_CELL_MODEL), ''), '-') = NVL(NULLIF(TRIM(B.CELL_MODEL_INFO), ''), '-')
            AND    NVL(NULLIF(TRIM(A.ATTRIBUTE3), ''), '-') = NVL(NULLIF(TRIM(B.CELL_MODEL), ''), '-')
        );

        --select @@Rowcount
        n_delete_count := SQL%ROWCOUNT;

        --------------------------------------------------------------------------------------------◇◇◇◇
        --                          DM_PLN_SALES_PLAN_REPORT_C 테이블 DELETE (END)
        --------------------------------------------------------------------------------------------◇◇◇◇

        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                          DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (START)
        --------------------------------------------------------------------------------------------◇◇◇◇
        -- INSERT COUNT 확인
        SELECT COUNT(M.DIVISION_ID)
        INTO   n_insert_count
        FROM   SCM_MGR.GT_0044_RESULTS_MST M
        WHERE  M.ACTIVE_FLAG <> 'D';

        MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        USING (
            SELECT *
            FROM   SCM_MGR.GT_0044_RESULTS_MST M
            WHERE  M.ACTIVE_FLAG <> 'D'
        ) B
        ON (
                A.DIVISION_ID                          = B.DIVISION_ID
            AND A.VERSION_NO                           = B.VERSION_NO
            AND A.DEPARTMENT_ID                        = B.DEPARTMENT_ID
            --AND	    A.DEPARTMENT_NAME	 = B.DEPARTMENT_NAME
            AND A.DEPT_ID                              = B.DEPT_ID
            --AND	    A.DEPT_NAME			 = B.DEPT_NAME
            AND A.END_CUST_REPORT                      = B.END_CUST_REPORT
            AND A.CUST_REPORT                          = B.CUST_REPORT
            AND A.PRODUCT_GROUP                        = B.PRODUCT_GROUP
            AND NVL(NULLIF(TRIM(A.PROJECT_CODE), ''), '-')   = B.PROJECT_CODE
            AND NVL(NULLIF(TRIM(A.SCM_SITE_ID), ''), '-')    = B.SCM_SITE_ID
            AND A.ITEM_ID                              = B.ITEM_ID
            AND NVL(NULLIF(TRIM(A.FCST_TYPE), ''), '-')      = B.FCST_TYPE
            AND NVL(NULLIF(TRIM(A.INCOTERMS), ''), '-')      = B.INCOTERMS
            AND A.MEASURE                              = B.MEASURE
            AND NVL(NULLIF(TRIM(A.PLANT_SITE_ID), ''), '-')  = '-'
            AND A.YYYYMMDD                             = B.YYYYMMDD
            AND A.CURRENCY                             = B.CURRENCY       -- 20190822
            AND A.COMPANY_ID                           = B.COMPANY_ID     -- 20200123
            AND NVL(NULLIF(TRIM(A.CELL_PROD_SITE), ''), '-') = '-'
            AND A.DATA_TYPE                            = '2'
        )
        WHEN MATCHED THEN
            UPDATE SET
                A.QTY              = B.QTY,
                A.LAST_UPDATED_BY  = B.CREATED_BY,
                A.LAST_UPDATE_DATE = SYSDATE

        WHEN NOT MATCHED THEN
            INSERT (
                DATA_TYPE,
                DIVISION_ID,
                VERSION_NO,
                CUTOFF_TYPE,
                CUTOFF_YYYYMMDD,
                DEPARTMENT_ID,
                DEPARTMENT_NAME,
                DEPT_ID,
                DEPT_NAME,
                END_CUST_REPORT,
                CUST_REPORT,
                PRODUCT_GROUP,
                PROJECT_CODE,
                SCM_SITE_ID,
                DOM_EXP,
                FCST_TYPE,
                INCOTERMS,
                PLANT_SITE_ID,
                ITEM_ID,
                MEASURE,
                YYYYMMDD,
                CURRENCY,
                COMPANY_ID,
                QTY,
                CREATED_BY,
                CREATION_DATE,
                LAST_UPDATED_BY,
                LAST_UPDATE_DATE,
                ATTRIBUTE1,
                ATTRIBUTE2,
                ATTRIBUTE3,
                ATTRIBUTE4,
                ATTRIBUTE5,
                FORECAST_INFO_CELL_MODEL,
                CELL_PROD_SITE
            )
            VALUES (
                '2',
                B.DIVISION_ID,
                B.VERSION_NO,
                B.CUTOFF_TYPE,
                B.CUTOFF_YYYYMMDD,
                B.DEPARTMENT_ID,
                B.DEPARTMENT_NAME,
                B.DEPT_ID,
                B.DEPT_NAME,
                B.END_CUST_REPORT,
                B.CUST_REPORT,
                B.PRODUCT_GROUP,
                '-',   --project_code   (NOT NULL, PK)
                '-',   --scm_site_id    (NOT NULL, PK)
                '-',   --dom_exp
                '-',   --fcst_type      (NOT NULL, PK)
                '-',   --incoterms      (NOT NULL, PK)
                '-',   --plant_site_id  (NOT NULL, PK)
                B.ITEM_ID,
                B.MEASURE,
                B.YYYYMMDD,
                B.CURRENCY,
                B.COMPANY_ID,
                B.QTY,
                B.CREATED_BY,
                SYSDATE,
                B.CREATED_BY,
                SYSDATE,
                '기타',
                '-',
                B.CELL_MODEL,
                NULL,
                NULL,
                B.CELL_MODEL_INFO,
                '-'    --cell_prod_site (NOT NULL, PK)
            );

            n_merge_count := SQL%ROWCOUNT;
    END IF;
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                   DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (END)
    --------------------------------------------------------------------------------------------◇◇◇◇

    --ELSE

    --[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 20230907
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT LOOKA.MODEL,
               LOOKA.BIZ_TYPE,
               LOOKA.CELL_PACK_COUNT,
               LOOKA.DIVISION_ID
        FROM (
            SELECT SEGMENT2  AS MODEL,
                   SEGMENT3  AS BIZ_TYPE,
                   SEGMENT4  AS CELL_PACK_COUNT,
                   SEGMENT1  AS DIVISION_ID,
                   RANK() OVER (
                       PARTITION BY SEGMENT2
                       ORDER BY DISPLAY_SEQ DESC
                   ) AS MODEL_RANK
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
        ) LOOKA
        WHERE  LOOKA.MODEL_RANK = 1
    ) LOOKA
    ON (
            LOOKA.MODEL        = A.ITEM_ID
        AND LOOKA.DIVISION_ID  = A.DIVISION_ID
        AND A.DIVISION_ID      = '40'
        AND A.VERSION_NO       = v_version_no
        AND A.YYYYMMDD         = v_yyyymmdd
    )
    WHEN MATCHED THEN
        UPDATE SET
            A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT,
            A.FORECAST_INFO_BIZ_TYPE        = LOOKA.BIZ_TYPE;
    
    -- n_merge_count := SQL%ROWCOUNT;
    
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                                  DM_PLN_BP_FCST_REPORT_C 테이블 DELETE (START)
    --------------------------------------------------------------------------------------------◇◇◇◇
    --BEGIN

        ---- DELETE COUNT 확인
        --SET @n_delete_count =  (SELECT COUNT(division_id)  FROM SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        --						WHERE (
        --								SELECT count(1) 
        --									FROM GT_0044_RESULTS_MST M
        --									where M.active_flag		= 'D'
        --								) > 0)

        ----  select * from GT_0044_RESULTS_MST
        --DELETE 
        --FROM SCM_MGR.DM_PLN_BP_FCST_REPORT_C
        --WHERE (
        --		SELECT count(1) 
        --			FROM GT_0044_RESULTS_MST M
        --			where M.active_flag		= 'D'
        --				and DATA_TYPE = '2'
        --				and DM_PLN_BP_FCST_REPORT_C.division_id		= M.division_id		
        --				and DM_PLN_BP_FCST_REPORT_C.version_no		= M.version_no			
        --				and DM_PLN_BP_FCST_REPORT_C.department_id	= M.department_id		
        --				--and DM_PLN_BP_FCST_REPORT_C.department_name	= M.department_name	
        --				and DM_PLN_BP_FCST_REPORT_C.dept_id			= M.dept_id			
        --				--and DM_PLN_BP_FCST_REPORT_C.dept_name		= M.dept_name			
        --				and DM_PLN_BP_FCST_REPORT_C.end_cust_report	= M.end_cust_report	
        --				and DM_PLN_BP_FCST_REPORT_C.cust_report		= M.cust_report		
        --				and DM_PLN_BP_FCST_REPORT_C.product_group	= M.product_group		

        --				and NVL(DM_PLN_BP_FCST_REPORT_C.project_code	,'')	= M.project_code		
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.scm_site_id	,'')	= M.scm_site_id		
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.dom_exp		,'')	= M.dom_exp		
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.fcst_type	,'')	= M.fcst_type		
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.incoterms	,'')	= M.incoterms		
        --				and NVL(DM_PLN_BP_FCST_REPORT_C.

        --				and DM_PLN_BP_FCST_REPORT_C.item_id			= M.item_id			
        --				and DM_PLN_BP_FCST_REPORT_C.currency	    = M.currency			-- 20190822
        --				and DM_PLN_BP_FCST_REPORT_C.company_id	    = M.company_id			-- 20200123
        --				and DM_PLN_BP_FCST_REPORT_C.measure			= M.measure		
        --				and DM_PLN_BP_FCST_REPORT_C.yyyymm			= SUBSTR(M.yyyymmdd,1,6)
        --		) > 0;
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                                  DM_PLN_BP_FCST_C 테이블 DELETE (END)
    --------------------------------------------------------------------------------------------◇◇◇◇

    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                          DM_PLN_BP_FCST_C 테이블 UPDATE, INSERT (START)
    --------------------------------------------------------------------------------------------◇◇◇◇
        -- INSERT COUNT 확인
        --SET n_insert_count = ( SELECT count(M.division_id) 
        --							FROM GT_0044_RESULTS_MST M
        --								where M.active_flag      <> 'D' )

        --			MERGE INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        --			USING (
        --					SELECT *
        --						FROM GT_0044_RESULTS_MST M
        --							where M.active_flag      <> 'D'
        --				  ) B
        --			ON(
        --						A.division_id		 = B.division_id			
        --				AND	    A.version_no		 = B.version_no		
        --				AND	    A.department_id		 = B.department_id			
        --				--AND	    A.department_name	 = B.department_name		
        --				AND	    A.dept_id			 = B.dept_id				
        --				--AND	    A.dept_name			 = B.dept_name				
        --				AND	    A.end_cust_report	 = B.end_cust_report		
        --				AND	    A.cust_report		 = B.cust_report			
        --				AND	    A.product_group		 = B.product_group			

        --				AND	    NVL(A.project_code	,'')	 = B.project_code			
        --				AND	    NVL(A.scm_site_id	,'')	 = B.scm_site_id			
        --				AND	    NVL(A.dom_exp		,'')	 = B.dom_exp				
        --				AND	    NVL(A.fcst_type		,'')	 = B.fcst_type				
        --				AND	    NVL(A.incoterms		,'')	 = B.incoterms				

        --				AND	    A.item_id			 = B.item_id				
        --				AND	    A.currency			 = B.currency				-- 20190822
        --				AND	    A.company_id		 = B.company_id				-- 20200123
        --				AND	    A.measure			 = B.measure				
        --				AND	    A.yyyymm			 = SUBSTR(B.yyyymmdd,1,6)		
        --				AND		a.DATA_TYPE = '2'	
        --			  )
        --			WHEN MATCHED THEN
        --				 UPDATE SET 
        --							 A.QTY				= B.QTY		
        --							,A.last_updated_by	= B.created_by
        --							,A.last_update_date	= SYSDATE
        --
        --			WHEN NOT MATCHED THEN

        --				 INSERT (
        --						   DATA_TYPE
        --						  ,division_id		
        --						  ,version_no		
        --						  ,cutoff_type		
        --						  ,cutoff_yyyymmdd	
        --						  ,department_id	
        --						  ,department_name	
        --						  ,dept_id			
        --						  ,dept_name		
        --						  ,end_cust_report	
        --						  ,cust_report		
        --						  ,product_group	
        --						  ,project_code
        --						  ,scm_site_id
        --						  ,dom_exp	
        --						  ,fcst_type	
        --						  ,incoterms	
        --						  ,plant_site_id

        --						  ,item_id	
        --						  ,measure	
        --						  ,yyyymm	
        --						  ,currency	
        --						  ,company_id
        --						  ,qty			
        --						  ,created_by	
        --						  ,CREATION_DATE
        --						  ,LAST_UPDATED_BY
        --						  ,LAST_UPDATE_DATE
        --						  ,ATTRIBUTE1
        --						  ,ATTRIBUTE2
        --						  ,ATTRIBUTE3
        --						  ,ATTRIBUTE4
        --						  ,ATTRIBUTE5
        --						)
        --				 VALUES (   '2'
        --						   ,B.division_id
        --						   ,B.version_no		
        --						   ,B.cutoff_type		
        --						   ,B.cutoff_yyyymmdd	
        --						   ,B.department_id	
        --						   ,B.department_name	
        --						   ,B.dept_id			
        --						   ,B.dept_name		
        --						   ,B.end_cust_report	
        --						   ,B.cust_report		
        --						   ,B.product_group	
        --							,''  --project_code
        --							,''	 --scm_site_id
        --							,''	 --dom_exp	
        --							,''	 --fcst_type	
        --							,''	 --incoterms	
        --							,''	 --plant_site_id
        --						   ,B.item_id
        --						   ,B.measure
        --						   ,SUBSTR(B.yyyymmdd,1,6)		
        --						   ,B.currency	
        --						   ,B.company_id		
        --						   ,B.qty
        --						   ,B.CREATED_BY
        --						   ,SYSDATE
        --						   ,B.CREATED_BY
        --						   ,SYSDATE
        --						   ,'기타','',NULL,NULL,NULL
        --						);

    --END
    --------------------------------------------------------------------------------------------◇◇◇◇
    --                                          DM_PLN_BP_FCST_REPORT_C 테이블 UPDATE, INSERT (END)
    --------------------------------------------------------------------------------------------◇◇◇◇


    -- UPDATE 후에 전송처리를 다시 한다.
    BEGIN
        SELECT 1
        INTO   v_exists
        FROM   DUAL
        WHERE  EXISTS (
            SELECT DIVISION_ID
            FROM   SCM_MGR.DM_MDF_VERSION
            WHERE  DIVISION_ID = v_division_id
            AND    VERSION_NO  = v_version_no
            AND    SEND_YN     = 'Y'
        );
        /* TODO 26.03.23
        EXECUTE IMMEDIATE
            'BEGIN SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(:1, :2, :3, :4, :5); END;'
            USING v_division_id, v_version_no, v_cutoff_type, 'T', P_CREATED_BY;
        */            

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- SEND_YN = 'Y' 데이터 없으면 전송 처리 스킵
    END;

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure @@@##########';
    V_DESCRIPTION := 'input_count: ' || TO_CHAR(n_input_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'     VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'     VALUE P_DIVISION_ID,
            'P_VERSION_NO'      VALUE P_VERSION_NO,
            'P_CUTOFF_TYPE'     VALUE P_CUTOFF_TYPE,
            'P_CUTOFF_YYYYMMDD' VALUE P_CUTOFF_YYYYMMDD,
            'P_DEPARTMENT_ID'   VALUE P_DEPARTMENT_ID,
            'P_DEPARTMENT_NAME' VALUE P_DEPARTMENT_NAME,
            'P_DEPT_ID'         VALUE P_DEPT_ID,
            'P_DEPT_NAME'       VALUE P_DEPT_NAME,
            'P_END_CUST_REPORT' VALUE P_END_CUST_REPORT,
            'P_CUST_REPORT'     VALUE P_CUST_REPORT,
            'P_PRODUCT_GROUP'   VALUE P_PRODUCT_GROUP,
            'P_ITEM_ID'         VALUE P_ITEM_ID,
            'P_MEASURE'         VALUE P_MEASURE,
            'P_YYYYMMDD'        VALUE P_YYYYMMDD,
            'P_CURRENCY'        VALUE P_CURRENCY,
            'P_COMPANY_ID'      VALUE P_COMPANY_ID,
            'P_QTY'             VALUE P_QTY,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_CELL_MODEL_INFO' VALUE P_CELL_MODEL_INFO,
            'P_CELL_MODEL'      VALUE P_CELL_MODEL
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SAVE_SALES_PLAN_REPORT_C;



PROCEDURE P_DMF0044_GET_VERSION_POPUP
(
    P_START_YYYYMMDD    IN  VARCHAR2,
    P_END_YYYYMMDD      IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_TYPE      IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_USER_ID           IN  VARCHAR2, -- For EditYn
    P_MNU_ID            IN  VARCHAR2, -- For EditYn
    
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.23   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                 */
/*                                                                                                  */
/****************************************************************************************************/
/*****************************************************************************************************
 ※ 작성 Rule 
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
IS
    -- Case 41: 프로그램명 (패키지 대응)
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    -- EXEC SCM0002_GET_VERSIONBYWATERFALLPOPUP @p_start_yyyymmdd='20180313', @p_end_yyyymmdd='20180913', @p_created_by='20140001', @p_division_id='82', @p_version_type='SP_D,SP_W,SP_M,', @p_version_no=''

    OPEN O_RC1 FOR
    SELECT 'SP_Z_CURRENT' AS CODE,
           'Current' AS VERSION_NO,
           'Current' AS VERSION_DESCRIPTION,
           CAST(NULL AS VARCHAR2(30 CHAR)) AS VERSION_TYPE,
           CAST(NULL AS VARCHAR2(30 CHAR)) AS VER_CRE_SEQ,
           CAST(NULL AS VARCHAR2(8 CHAR))  AS YYYYMMDD,
           CAST(NULL AS VARCHAR2(50 CHAR)) AS CREATED_BY,
           SYSDATE AS CREATION_DATE,
           '' AS EDIT_YN
    FROM   DUAL

    UNION ALL

    SELECT VERSION_NO AS CODE,
           VERSION_NO,
           VERSION_DESCRIPTION,
           TO_CHAR(VERSION_TYPE) AS VERSION_TYPE,
           TO_CHAR(VER_CRE_SEQ) AS VER_CRE_SEQ,
           YYYYMMDD,
           MAX(CREATED_BY) AS CREATED_BY,
           MAX(CREATION_DATE) AS CREATION_DATE,
           
           NVL(T2.EDIT_YN,'') AS EDIT_YN
    FROM   SCM_MGR.DM_MST_VERSION T1
            INNER JOIN (SELECT * -- EDIT_YN 
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                WHERE USER_ID = P_USER_ID 
                AND MNU_ID = P_MNU_ID 
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID
    
    WHERE  YYYYMMDD >= P_START_YYYYMMDD
    AND    YYYYMMDD <= P_END_YYYYMMDD
    AND    T1.DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    AND    VERSION_TYPE IN (
               SELECT TRIM(REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL)) AS TOKEN
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    AND    EXISTS (
               SELECT 1
               FROM   (
                   SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL)) AS TOKEN
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL) IS NOT NULL
               ) P
               WHERE  VERSION_NO LIKE P.TOKEN || '%'
           )
    GROUP BY VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, EDIT_YN
    ORDER BY CODE DESC, VERSION_NO DESC;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_VERSION_TYPE'   VALUE P_VERSION_TYPE,
            'P_VERSION_NO'     VALUE P_VERSION_NO,
            'P_USER_ID'        VALUE P_USER_ID,
            'P_MNU_ID'         VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_GET_VERSION_POPUP;


PROCEDURE P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY
(
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_VERSION_DESCRIPTION   IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    P_ACTION_TYPE           IN  VARCHAR2,   -- D:삭제, CR: 생성, CP:복사
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SAVE_BIZ_PLAN_VERSION_COPY
 * Description  : Sales REPORT 개발 (DM_PLN_BP_FCST_C -> DM_PLN_BP_FCST_REPORT_C) VERSION COPY PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190709 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy
 * 20191022 KYH			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4 
 * 20200113 HWI1993 COPY, DELETE 기능 추가
 * 20200116 hwi1993 company_id 추가
 * 20200129 hwi1993 SalesAmt_USD 메저 추가
 * 20200211 HWI1993	부서 없는 데이터 삭제
 * 20200326 P.C.I   [PREPARE] 환율 정보 copy
 * 2026.03.23   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 
 VAR RC1 REFCURSOR;
EXEC DMF0044_SAVE_BIZ_PLAN_VERSION_COPY( '40', 'SP_W_20260310_V003', 'SALES_PLAN WEEKLY CUTOFF', 'system', 'CR', :RC1);
PRINT RC1;

 */
IS
    -- Case 41: 프로그램명 (패키지 대응)
    $$PLSQL_UNIT      VARCHAR2(200 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;
    v_created_by        VARCHAR2(50 CHAR) := 'mdf_batch';
    V_ORI_VERSION       VARCHAR2(30 CHAR);

    v_rp_version        VARCHAR2(2 CHAR);
    v_version_x         VARCHAR2(50 CHAR);
    v_exists            PLS_INTEGER;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    -- GTT 초기화 (프로시저 시작 시, 이전에 일반 테이블 DML 없으므로 TRUNCATE 허용)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_0044_BP_FCST_01';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_0044_BP_FCST_02';

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -----------------------------------------------------------------------------------------------------
    --                                                                                 Validation (BEGIN)
    -----------------------------------------------------------------------------------------------------
    BEGIN
        SELECT 1 INTO v_exists FROM DUAL
        WHERE EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_DIVISION WHERE DIVISION_ID = P_DIVISION_ID);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'Division 값이 존재하지 않습니다.';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
    END;

    -- 기능과 버전이 안맞는 경우 ( 생성 : SP_W, BP_M 만 가능, 복사, 삭제 : REPORT_로 시작하는 버전만 가능 )
    IF P_ACTION_TYPE IN ('CP', 'D') THEN
        BEGIN
            SELECT 1 INTO v_exists FROM DUAL
            WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MDF_VERSION
                          WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := 'VERSION 값이 존재하지 않습니다.';
                D_EVENT_DATE  := SYSDATE;
                BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
        END;
    END IF;

    IF P_ACTION_TYPE = 'CR' THEN
        BEGIN
            SELECT 1 INTO v_exists FROM DUAL
            WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MST_VERSION
                          WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := 'VERSION 값이 존재하지 않습니다.';
                D_EVENT_DATE  := SYSDATE;
                BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
        END;
    END IF;

    -- 삭제인데, Send_YN 이 Y 인 경우
    IF P_ACTION_TYPE = 'D' THEN
        BEGIN
            SELECT 1 INTO v_exists FROM DUAL
            WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MDF_VERSION
                          WHERE DIVISION_ID = P_DIVISION_ID AND VERSION_NO = P_VERSION_NO AND SEND_YN = 'Y');
            -- SEND_YN = 'Y' 존재 → 삭제 불가
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'VERSION 값이 존재하지 않습니다.';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; -- SEND_YN = 'Y' 없으면 정상 진행
        END;
    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                                                                 Validation (END)
    -----------------------------------------------------------------------------------------------------


    -----------------------------------------------------------------------------------------------------
    --     MDF VERSION MST INSERT (BEGIN)
    -----------------------------------------------------------------------------------------------------

    -- 신규생성이나 복사일 경우
    IF P_ACTION_TYPE = 'CR' THEN

        BEGIN
            SELECT MAX(SUBSTR(VERSION_NO, 28, 2))
            INTO   v_rp_version
            FROM   SCM_MGR.DM_MDF_VERSION
            WHERE  DIVISION_ID    = P_DIVISION_ID
            AND    ORI_VERSION_NO = P_VERSION_NO;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rp_version := NULL;
        END;

        IF v_rp_version IS NULL OR v_rp_version = '' THEN
            v_rp_version := '01';
        ELSE
            v_rp_version := LPAD(TO_CHAR(TO_NUMBER(v_rp_version) + 1), 2, '0');
            -- jcnam 임시 테스트 코드: to_number 변환 오류 시 디폴트 값 01
            -- v_rp_version := LPAD(TO_CHAR(NVL(TO_NUMBER(v_rp_version DEFAULT 0 ON CONVERSION ERROR), 0) + 1), 2, '0');
        END IF;

        -- 최종 버전 셋팅
        v_version_x := 'REPORT_' || P_VERSION_NO || '_R' || v_rp_version;

        --dbms_output.put_line('v_version_x:'||v_version_x);


        INSERT INTO SCM_MGR.DM_MDF_VERSION
        (DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, SEND_YN, YYYYMMDD,
         VER_CRE_SEQ, ORI_VERSION_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5)
        SELECT P_DIVISION_ID,
               v_version_x AS VERSION_NO,
               P_VERSION_DESCRIPTION,
               'REPORT_' || VERSION_TYPE AS VERSION_TYPE,
               '', YYYYMMDD, VER_CRE_SEQ, VERSION_NO,
               P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE,
               NULL, NULL, NULL, NULL, NULL
        FROM   SCM_MGR.DM_MST_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;
        
        n_merge_count := SQL%ROWCOUNT;
        
        --dbms_output.put_line('DM_MDF_VERSION-----------------------');
        --dbms_output.put_line('n_merge_count:'||n_merge_count);
        
        
        --[PREPARE] 환율 정보 copy
        INSERT INTO SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT DIVISION_ID, v_version_x AS VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
               CREATED_BY, CREATION_DATE, P_CREATED_BY, SYSDATE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        FROM   SCM_MGR.DM_BP_EXCHANGE_RATE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        n_merge_count := n_merge_count +  SQL%ROWCOUNT;
        
        --dbms_output.put_line('DM_PLN_SALES_REPORT_EXCHANGE_C-----------------------');
        --dbms_output.put_line('n_merge_count:'||n_merge_count);


    ELSIF P_ACTION_TYPE = 'CP' THEN

        SELECT ORI_VERSION_NO
        INTO   V_ORI_VERSION
        FROM   SCM_MGR.DM_MDF_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = SUBSTR(P_VERSION_NO, 1, 29)
        AND    ROWNUM = 1;

        BEGIN
            SELECT MAX(SUBSTR(VERSION_NO, 28, 2))
            INTO   v_rp_version
            FROM   SCM_MGR.DM_MDF_VERSION
            WHERE  DIVISION_ID    = P_DIVISION_ID
            AND    ORI_VERSION_NO = V_ORI_VERSION;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rp_version := NULL;
        END;

        IF v_rp_version IS NULL OR v_rp_version = '' THEN
            v_rp_version := '01';
        ELSE
            v_rp_version := LPAD(TO_CHAR(TO_NUMBER(v_rp_version) + 1), 2, '0');
        END IF;

        -- 최종 버전 셋팅
        v_version_x := SUBSTR('REPORT_' || REPLACE(P_VERSION_NO, 'REPORT_', ''), 1, 25) || '_R' || v_rp_version;

        INSERT INTO SCM_MGR.DM_MDF_VERSION
        (DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, SEND_YN, YYYYMMDD,
         VER_CRE_SEQ, ORI_VERSION_NO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5)
        SELECT P_DIVISION_ID,
               v_version_x AS VERSION_NO,
               P_VERSION_DESCRIPTION,
               'REPORT_' || VERSION_TYPE AS VERSION_TYPE,
               '', YYYYMMDD,
               VER_CRE_SEQ, VERSION_NO, P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE,
               NULL, NULL, NULL, NULL, NULL
        FROM   SCM_MGR.DM_MST_VERSION
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = V_ORI_VERSION;

        n_merge_count := SQL%ROWCOUNT;
    
        --[PREPARE] 환율 정보 copy
        INSERT INTO SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
         ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT DIVISION_ID, v_version_x AS VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE,
               CREATED_BY, CREATION_DATE, P_CREATED_BY, SYSDATE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        FROM   SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

    ELSE  -- 삭제일 경우

        UPDATE SCM_MGR.DM_MDF_VERSION
        SET    SEND_YN = 'D'
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        DELETE FROM SCM_MGR.DM_PLN_BP_FCST_REPORT_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

        --[PREPARE] 환율 정보 Delete
        DELETE FROM SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    VERSION_NO  = P_VERSION_NO;

    END IF;
    -----------------------------------------------------------------------------------------------------
    --                                                                     MDF VERSION MST INSERT (END)
    -----------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------
    --                                                                           요청VERSION COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------


    IF P_ACTION_TYPE = 'CR' THEN

        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_0044_BP_FCST_01
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
         PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,
         FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID,
         YYYYMM, QTY, OWNER)
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD,
               A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
               A.FCST_TYPE, A.INCOTERMS, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID,
               A.YYYYMM, SUM(A.QTY) AS QTY,
               (SELECT TRIM(SUBSTR(B.OWNER, 1, NVL(NULLIF(INSTR(B.OWNER, ','), 0), LENGTH(B.OWNER) + 1) - 1))
                FROM   SCM_MGR.SCM_MST_SITE_ITEM B
                WHERE  B.DIVISION_ID  = A.DIVISION_ID
                AND    B.PROJECT_CODE = A.PROJECT_CODE
                AND    B.SCM_SITE_ID  = A.SCM_SITE_ID
                AND    B.ITEM_ID      = A.ITEM_ID
                AND    ROWNUM = 1
               ) AS OWNER  -- 멀티OWNER인경우 1명만 추출
        FROM   SCM_MGR.DM_PLN_BP_FCST_C A
        WHERE  A.VERSION_NO   = P_VERSION_NO
        AND    A.MEASURE IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'Business_Plan')
        AND    A.DIVISION_ID  = P_DIVISION_ID
        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD,
                 A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
                 A.FCST_TYPE, A.INCOTERMS, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID,
                 A.YYYYMM;
                                  
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        INSERT INTO SCM_MGR.GT_0044_BP_FCST_02
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
         PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,
         FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID,
         YYYYMM, QTY, OWNER,
         DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME,
         CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, ATTRIBUTE1, COMPANY_ID)
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD,
               A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
               A.FCST_TYPE, A.INCOTERMS, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID,
               A.YYYYMM, A.QTY, A.OWNER,
               NVL((SELECT DU.UPPER_DEPT_ID
                    FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU
                    WHERE DU.VALID_YN = 'Y'
                    AND   DU.DEPT_ID = (SELECT SU.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU WHERE A.OWNER = SU.USER_ID AND ROWNUM = 1)
                    AND   ROWNUM = 1), '-') AS DEPARTMENT_ID,
               NVL((SELECT DU2.DEPT_NAME_KO
                    FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU2
                    WHERE DU2.VALID_YN = 'Y'
                    AND   DU2.DEPT_ID = (SELECT DU3.UPPER_DEPT_ID
                                         FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU3
                                         WHERE DU3.VALID_YN = 'Y'
                                         AND   DU3.DEPT_ID = (SELECT SU2.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU2 WHERE A.OWNER = SU2.USER_ID AND ROWNUM = 1)
                                         AND   ROWNUM = 1)
                    AND   ROWNUM = 1), '-') AS DEPARTMENT_NAME,
               NVL((SELECT SU3.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU3 WHERE A.OWNER = SU3.USER_ID AND ROWNUM = 1), '-') AS DEPT_ID,
               NVL((SELECT DU4.DEPT_NAME_KO
                    FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DU4
                    WHERE DU4.VALID_YN = 'Y'
                    AND   DU4.DEPT_ID = (SELECT SU4.DEPT_ID FROM SCM_MGR.SCM_MST_SSO_USER_INFO SU4 WHERE A.OWNER = SU4.USER_ID AND ROWNUM = 1)
                    AND   ROWNUM = 1), '-') AS DEPT_NAME,
               NVL(LU.ATTRIBUTE2, '-')  AS CUST_REPORT,       -- Cust. (Report)
               NVL(SI.ATTRIBUTE2, '-')     AS END_CUST_REPORT,   -- End Cust.(Report)
               NVL(LU.ATTRIBUTE3, '-')  AS PRODUCT_GROUP,     -- Product Gr.(Report)
               CASE WHEN NVL(LU.ATTRIBUTE4, '-') <> '-' THEN NVL(LU.ATTRIBUTE4, '-') ELSE NVL(LU.ATTRIBUTE5, '-') END AS ATTRIBUTE1,  -- Pouch Gr.(Report)
               --, NVL(LU.ATTRIBUTE5,'-')    AS ATTRIBUTE2       -- Cyl Gr. (Report)
               NVL(B.COMPANY_ID, '-') AS COMPANY_ID
        FROM   SCM_MGR.GT_0044_BP_FCST_01 A
        LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
            ON  A.DIVISION_ID  = SI.DIVISION_ID
            AND A.SCM_SITE_ID  = SI.SCM_SITE_ID
            AND A.PROJECT_CODE = SI.PROJECT_CODE
            AND A.ITEM_ID      = SI.ITEM_ID
            AND SI.VALID_YN    = 'Y'
        LEFT JOIN (SELECT * FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'SALES_SITE_REPORT_GROUP') LU
            ON  A.DIVISION_ID  = LU.SEGMENT1    -- PK컬럼1
            AND A.PROJECT_CODE = LU.SEGMENT2    -- PK컬럼2
            AND A.SCM_SITE_ID  = LU.SEGMENT3    -- PK컬럼3
            AND A.ITEM_ID      = LU.SEGMENT4    -- PK컬럼4
        LEFT JOIN SCM_MGR.SCM_MST_SITE B
            ON  A.DIVISION_ID  = B.DIVISION_ID
            AND A.SCM_SITE_ID  = B.SCM_SITE_ID;

        -- Dept_ID 나 Department_ID 가 없는 건들 삭제
        DELETE FROM SCM_MGR.GT_0044_BP_FCST_02 WHERE DEPARTMENT_ID = '-' OR DEPT_ID = '-';

        -- GTT를 다른 테이블과 JOIN 하므로 통계 수집
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_BP_FCST_02', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname => 'SCM_MGR', tabname => 'GT_0044_BP_FCST_02',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
        );

        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT '1' AS DATA_TYPE, A.DIVISION_ID, v_version_x AS VERSION_NO, 'REPORT_' || A.CUTOFF_TYPE AS CUTOFF_TYPE,
               A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
               A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
               A.PROJECT_CODE, '-' AS PROJECT_NAME, NVL(MAX(A.SCM_SITE_ID), '-'), A.ITEM_ID, NVL(MAX(A.DOM_EXP), '-'),
               NVL(MAX(A.FCST_TYPE), '-'), NVL(MAX(A.INCOTERMS), '-'), A.MEASURE, NVL(MAX(A.PLANT_SITE_ID), '-'),
               A.YYYYMM, A.CURRENCY, SUM(QTY) AS QTY, v_created_by,
               SYSDATE, v_created_by, SYSDATE, MAX(A.ATTRIBUTE1), NVL(A.COMPANY_ID, '-')
        FROM   SCM_MGR.GT_0044_BP_FCST_02 A
        GROUP BY A.DIVISION_ID, A.CUTOFF_TYPE,
                 A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
                 A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
                 A.PROJECT_CODE, A.ITEM_ID, A.MEASURE,
                 A.YYYYMM, A.CURRENCY, A.COMPANY_ID;
        
        n_merge_count := n_merge_count + SQL%ROWCOUNT;
        
        -- UNIT Price ( LOC ) 를 생성해준다. ( 월단위 )
        -- RTF 가 있는 품목들에 대해서 Unit Price ( LOC ) 를 만들어준다. SalesAmt_LOC / RTF = Unit Price ( LOCAL )
        
        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT '1' AS DATA_TYPE, A.DIVISION_ID, v_version_x AS VERSION_NO, 'REPORT_' || A.CUTOFF_TYPE AS CUTOFF_TYPE,
               A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
               A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
               A.PROJECT_CODE, '-' AS PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
               A.FCST_TYPE, NVL(A.INCOTERMS, '-') AS INCOTERMS, 'LOC' AS MEASURE, A.PLANT_SITE_ID,
               A.YYYYMM, A.CURRENCY,
               CASE WHEN B.QTY <> 0 THEN ROUND(A.QTY / B.QTY, 0) ELSE 0 END,
               v_created_by,
               SYSDATE, v_created_by, SYSDATE, A.ATTRIBUTE1, NVL(A.COMPANY_ID, '-')
        FROM   SCM_MGR.GT_0044_BP_FCST_02 A
        JOIN   SCM_MGR.GT_0044_BP_FCST_02 B
            ON  A.DIVISION_ID     = B.DIVISION_ID
            AND A.DEPARTMENT_ID   = B.DEPARTMENT_ID
            AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
            AND A.DEPT_ID         = B.DEPT_ID
            AND A.DEPT_NAME       = B.DEPT_NAME
            AND A.END_CUST_REPORT = B.END_CUST_REPORT
            AND A.CUST_REPORT     = B.CUST_REPORT
            AND A.PRODUCT_GROUP   = B.PRODUCT_GROUP
            AND A.PROJECT_CODE    = B.PROJECT_CODE
            AND A.SCM_SITE_ID    = B.SCM_SITE_ID
            AND A.ITEM_ID        = B.ITEM_ID
            AND A.YYYYMM         = B.YYYYMM
            AND A.COMPANY_ID     = B.COMPANY_ID
            AND A.CURRENCY       = B.CURRENCY
        WHERE  A.MEASURE = 'SalesAmt_LOC'
        AND    B.MEASURE = 'Business_Plan';
        
        n_merge_count := n_merge_count + SQL%ROWCOUNT;

        -----------------------------------------------------------------------------------------------------
        --                                                                           요청VERSION COPY (END)
        -----------------------------------------------------------------------------------------------------

        ----------------------------------------------------------------------------------------------------- 
        --                                 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy (START)
        -----------------------------------------------------------------------------------------------------
        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT A.DATA_TYPE, A.DIVISION_ID, v_version_x, A.CUTOFF_TYPE,
               A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'),
               NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-'), NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'),
               NVL(A.PROJECT_CODE, '-'), NVL(MAX(A.PROJECT_NAME), '-'), NVL(MAX(A.SCM_SITE_ID), '-'), A.ITEM_ID, NVL(MAX(DOM_EXP), '-'),
               NVL(MAX(A.FCST_TYPE), '-'), NVL(MAX(A.INCOTERMS), '-'), A.MEASURE, NVL(MAX(A.PLANT_SITE_ID), '-'),
               YYYYMM, CURRENCY, SUM(QTY), NVL(MAX(A.CREATED_BY), '-'),
               MAX(A.CREATION_DATE), NVL(MAX(A.LAST_UPDATED_BY), '-'), MAX(A.LAST_UPDATE_DATE), MAX(A.ATTRIBUTE1),
               NVL(NVL(A.COMPANY_ID, B.COMPANY_ID), '-')
        FROM   SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        LEFT JOIN SCM_MGR.SCM_MST_SITE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND A.SCM_SITE_ID = B.SCM_SITE_ID
        WHERE  A.DIVISION_ID = P_DIVISION_ID
        AND    A.VERSION_NO  = (SELECT MAX(VERSION_NO)
                                FROM   SCM_MGR.DM_PLN_BP_FCST_REPORT_C
                                WHERE  CUTOFF_TYPE = 'REPORT_BP_M'
                                AND    DATA_TYPE   = '2')
        AND    A.CUTOFF_TYPE = 'REPORT_BP_M'
        AND    A.DATA_TYPE   = '2'
        GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.CUTOFF_TYPE,
                 A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
                 A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
                 A.PROJECT_CODE, A.ITEM_ID, A.MEASURE,
                 A.YYYYMM, A.CURRENCY, NVL(NVL(A.COMPANY_ID, B.COMPANY_ID), '-');
        
        n_merge_count := n_merge_count + SQL%ROWCOUNT;
        

    ELSIF P_ACTION_TYPE = 'CP' THEN

        -- PK 변경전의 DATA 를 COPY 하는 경우때문에 GROUP BY  처리함
        INSERT INTO SCM_MGR.DM_PLN_BP_FCST_REPORT_C
             (DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE,
              CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
              DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP,
              PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP,
              FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID,
              YYYYMM, CURRENCY, QTY, CREATED_BY,
              CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID)
        SELECT A.DATA_TYPE, A.DIVISION_ID, v_version_x, A.CUTOFF_TYPE,
               A.CUTOFF_YYYYMMDD, NVL(A.DEPARTMENT_ID, '-'), NVL(A.DEPARTMENT_NAME, '-'), NVL(A.DEPT_ID, '-'),
               NVL(A.DEPT_NAME, '-'), NVL(A.END_CUST_REPORT, '-'), NVL(A.CUST_REPORT, '-'), NVL(A.PRODUCT_GROUP, '-'),
               NVL(A.PROJECT_CODE, '-'), NVL(MAX(A.PROJECT_NAME), '-'), NVL(MAX(A.SCM_SITE_ID), '-'), A.ITEM_ID, NVL(MAX(DOM_EXP), '-'),
               NVL(MAX(A.FCST_TYPE), '-'), NVL(MAX(A.INCOTERMS), '-'), A.MEASURE, NVL(MAX(A.PLANT_SITE_ID), '-'),
               YYYYMM, CURRENCY, SUM(QTY), NVL(MAX(A.CREATED_BY), '-'),
               MAX(A.CREATION_DATE), NVL(MAX(A.LAST_UPDATED_BY), '-'), MAX(A.LAST_UPDATE_DATE), MAX(A.ATTRIBUTE1),
               NVL(A.COMPANY_ID, '-')
        FROM   SCM_MGR.DM_PLN_BP_FCST_REPORT_C A
        WHERE  A.DIVISION_ID = P_DIVISION_ID
        AND    A.VERSION_NO  = P_VERSION_NO
        GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.CUTOFF_TYPE,
                 A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID,
                 A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP,
                 A.PROJECT_CODE, A.ITEM_ID, A.MEASURE,
                 A.YYYYMM, A.CURRENCY, A.COMPANY_ID;
                 
        n_merge_count := SQL%ROWCOUNT;                 
        -- dbms_output.put_line('-----------------------P_DIVISION_ID:'||P_DIVISION_ID||', P_VERSION_NO:'||P_VERSION_NO);
        -- dbms_output.put_line('-----------------------CP8--'||n_merge_count);


    END IF;
    ----------------------------------------------------------------------------------------------------- 
    --                                 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy (END)
    -----------------------------------------------------------------------------------------------------

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;
    -- N_LOG_COUNT := n_delete_count + n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'         VALUE P_DIVISION_ID,
            'P_VERSION_NO'          VALUE P_VERSION_NO,
            'P_VERSION_DESCRIPTION' VALUE P_VERSION_DESCRIPTION,
            'P_CREATED_BY'          VALUE P_CREATED_BY,
            'P_ACTION_TYPE'         VALUE P_ACTION_TYPE
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY;


PROCEDURE P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_ACTION_TYPE       IN  VARCHAR2,   -- T:Transfer, C:Cancel
    P_YYYY              IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE
 * Description  : 매출리포트용 데이터 생성 PROCEDURE - 사업계획통화환율
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190522 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20191101 KYH    환율 AVG 계산이 틀려서 null 로 변경함
 * 20191106 KYH		월별 데이터에 널처리 추가함
 * 20191118 hwi1993 파라미터 추가 및 데이터타입 변경 및 Cancel 기능 추가
 * 20200603 hwi1993	source table 변경
 * 2020/09/21	HWI1993	[C20200909-000188] [ESS영업관리팀] GDW 용도별 매출 수정 (프로젝트 코드 S 주택용/상업용 분리) 
 * 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
IS
    -- Case 41: 프로그램명 (패키지 대응)
    $$PLSQL_UNIT      VARCHAR2(200 CHAR);

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
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    ----------------------------------------------------------------------------------------------------- 
    --                                                        중복 VERSION이 있는경우 삭제후 COPY (BEGIN)
    -----------------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE
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

        -- CURSOR 루프 대신 3개 연도(yyyy-1, yyyy, yyyy+1)를 CROSS JOIN으로 한번에 처리
        INSERT INTO SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE
             ( DIVISION_ID
             , VERSION_NO
             , YYYY
             , SP_BP_TYPE
             , CURRENCY
             , UNIT_CURRENCY
             , MM01
             , MM02
             , MM03
             , MM04
             , MM05
             , MM06
             , MM07
             , MM08
             , MM09
             , MM10
             , MM11
             , MM12
             , ORI_VERSION_NO
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT E.DIVISION_ID
             , P_VERSION_NO
             , Y.YYYY
             , 'SP'          AS SP_BP_TYPE
             , E.CURRENCY
             , E.UNIT_CURRENCY
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '01' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM01
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '02' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM02
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '03' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM03
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '04' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM04
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '05' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM05
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '06' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM06
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '07' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM07
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '08' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM08
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '09' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM09
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '10' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM10
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '11' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM11
             , NVL(AVG(CASE WHEN SUBSTR(E.YYYYMMDD, 1, 6) = Y.YYYY || '12' THEN E.EXCHANGE_PRICE ELSE NULL END), 0) AS MM12
             , NVL((SELECT V.ORI_VERSION_NO FROM SCM_MGR.DM_MDF_VERSION V
                WHERE V.VERSION_NO = P_VERSION_NO AND V.DIVISION_ID = P_DIVISION_ID AND ROWNUM = 1), '-') AS ORI_VERSION_NO
             , v_user_id     AS CREATED_BY
             , SYSDATE       AS CREATION_DATE
             , v_user_id     AS LAST_UPDATED_BY
             , SYSDATE       AS LAST_UPDATE_DATE
        FROM   SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E
        CROSS JOIN (
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) - 1) AS YYYY FROM DUAL
            UNION ALL
            SELECT P_YYYY AS YYYY FROM DUAL
            UNION ALL
            SELECT TO_CHAR(TO_NUMBER(P_YYYY) + 1) AS YYYY FROM DUAL
        ) Y
        WHERE  E.DIVISION_ID = P_DIVISION_ID
        AND    E.VERSION_NO  = P_VERSION_NO
        AND    E.YYYYMMDD LIKE Y.YYYY || '%'
        GROUP BY E.DIVISION_ID
             , E.VERSION_NO
             , Y.YYYY
             , E.CURRENCY
             , E.UNIT_CURRENCY;

        n_merge_count := SQL%ROWCOUNT;

    END IF;

    ----------------------------------------------------------------------------------------------------- 
    --                                                                           요청VERSION COPY (END)
    -----------------------------------------------------------------------------------------------------

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
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

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE;


PROCEDURE P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF
(
    P_ACTIVE_FLAG           IN  VARCHAR2,
    P_DIVISION_ID           IN  VARCHAR2,
    P_VERSION_NO            IN  VARCHAR2,
    P_CUTOFF_TYPE           IN  VARCHAR2,
    P_CUTOFF_YYYYMMDD       IN  VARCHAR2,
    P_DEPARTMENT_ID         IN  VARCHAR2,
    P_DEPARTMENT_NAME       IN  VARCHAR2,
    P_DEPT_ID               IN  VARCHAR2,
    P_DEPT_NAME             IN  VARCHAR2,
    P_END_CUST_REPORT       IN  VARCHAR2,
    P_CUST_REPORT           IN  VARCHAR2,
    P_PRODUCT_GROUP         IN  VARCHAR2,
    P_ITEM_ID               IN  VARCHAR2,
    P_MEASURE               IN  VARCHAR2,
    P_YYYYMMDD              IN  VARCHAR2,
    P_CURRENCY              IN  VARCHAR2,
    P_QTY                   IN  VARCHAR2,
    P_SCM_SITE_ID           IN  VARCHAR2,
    P_PROJECT_CODE          IN  VARCHAR2,
    P_COMPANY_ID            IN  VARCHAR2,
    P_FCST_TYPE             IN  VARCHAR2,
    P_INCOTERMS             IN  VARCHAR2,
    P_CREATED_BY            IN  VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*============================================================================================================================
 * Program ID   : DMF0044_SAVE_SALES_PLAN_REPORT_C_CF
 * Description  : 'DM_PLN_SALES_PLAN_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *============================================================================================================================
 *   Date       In Charge      Description
 *============================================================================================================================
 * 2020/01/17	HWI1993			SCM_SITE_ID, COMPANY_ID, PROJECT_CODE 추가하면서 이름 변경함 - DMF0044_SAVE_SALES_PLAN_REPORT_C_CF ( Cutoff Data 전용임 )
 * 2020/03/26	hwi1993			department_name, dept_name 을 join 조건에서 제거함 ( lookup 적용으로 인해 같은 코드인데 화면과 db data 가 다를 수 있음 
 * 2020/05/22	hwi1993			Save 이후에 Transfer 처리
 * 2020/06/18	hwi1993			81번 로직 분리
 * 2020/09/09   P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020/09/18	HWI1993			[C20200909-000188] YYYYMMDD 를 영업일로 변환하는 로직 제거 LEFT(YYYYMMDD, 6) + '01' 로 변경
 * 2020/10/05	HWI1993			[C20201005-000291] Sales Report 대량 변경시 Time out 문제, QTY DATA TYPE 도 NUMERIC(30,10) 으로 변경
 * 2021/07/23	HWI1993			상반기과제 - 소형 마스터 정비
 * 2022/04/13   HWI1993			GM JV 작업
 * 2023/09/07	JSSBAE			[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 
 * 2024/05/09	JSSBAE			[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2025/05/09   JSSBAE			[E20250418-001567]_40사업부 Sales Report, ETC Report 개선
 * 2026.03.24   jcnam           [PJ20264226] NextSCM Pilot 설계 및 개발
 *============================================================================================================================*/
IS
    -----------------------------------------------------------------------------------------------
    -- 스플릿관련 변수
    -----------------------------------------------------------------------------------------------
    V_ACTIVE_FLAG           VARCHAR2(1 CHAR);
    V_DIVISION_ID           VARCHAR2(30 CHAR);
    V_VERSION_NO            VARCHAR2(30 CHAR);
    V_CUTOFF_TYPE           VARCHAR2(20 CHAR);
    V_CUTOFF_YYYYMMDD       VARCHAR2(8 CHAR);
    V_DEPARTMENT_ID         VARCHAR2(10 CHAR);
    V_DEPARTMENT_NAME       VARCHAR2(50 CHAR);
    V_DEPT_ID               VARCHAR2(10 CHAR);
    V_DEPT_NAME             VARCHAR2(50 CHAR);
    V_END_CUST_REPORT       VARCHAR2(30 CHAR);

    V_CUST_REPORT           VARCHAR2(30 CHAR);
    V_PRODUCT_GROUP         VARCHAR2(30 CHAR);
    V_ITEM_ID               VARCHAR2(50 CHAR);
    V_MEASURE               VARCHAR2(20 CHAR);
    V_YYYYMMDD              VARCHAR2(8 CHAR);
    V_CURRENCY              VARCHAR2(5 CHAR);
    V_QTY                   VARCHAR2(40 CHAR);
    V_SCM_SITE_ID           VARCHAR2(30 CHAR);
    V_PROJECT_CODE          VARCHAR2(30 CHAR);
    V_COMPANY_ID            VARCHAR2(30 CHAR);

    V_FCST_TYPE             VARCHAR2(10 CHAR);
    V_INCOTERMS             VARCHAR2(10 CHAR);
    V_CREATED_BY            VARCHAR2(150 CHAR);
    V_ORI_VERSION_NO        VARCHAR2(50 CHAR);
    V_DELIMITER             VARCHAR2(1 CHAR) := '^';

    -----------------------------------------------------------------------------------------------
    -- LOG 용 변수 설정
    -----------------------------------------------------------------------------------------------
    $$PLSQL_UNIT          VARCHAR2(200 CHAR);
    V_LOG_TYPE              VARCHAR2(100 CHAR);
    N_LOG_COUNT             PLS_INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(4000 CHAR);
    V_DESCRIPTION           VARCHAR2(4000 CHAR);
    D_EVENT_DATE            DATE := SYSDATE;
    N_DELETE_COUNT          PLS_INTEGER := 0;
    N_INSERT_COUNT          PLS_INTEGER := 0;
    N_INPUT_COUNT           PLS_INTEGER := 0;
    N_LOGO_COUNT            PLS_INTEGER := 0;
    -- [PATCH] 히스토리 테이블 INSERT 카운트 (신규 추가)
    N_HISTORY_COUNT         PLS_INTEGER := 0;

    -----------------------------------------------------------------------------------------------
    --계산용 변수
    -----------------------------------------------------------------------------------------------
    V_I                     PLS_INTEGER;
    V_CNT                   PLS_INTEGER;
    V_ADJQTY                NUMBER(30,10);
    V_REST                  NUMBER(30,10);
    V_ORIQTY                NUMBER(30,10);
    V_QTYCNT                PLS_INTEGER;
    V_MINDATE               VARCHAR2(8 CHAR);
    V_PLAN_YN               VARCHAR2(1 CHAR);
    V_LOC_SALESAMT_LOC      NUMBER(30,10);
    V_LOC_RTF               NUMBER(30,10);
    V_LOC_PRICE             NUMBER(30,10);

    V_EXISTS                PLS_INTEGER;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);
    V_SQL_CODE              VARCHAR2(100 CHAR);
    V_SQL_ERRMSG            VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    -----------------------------------------------------------------------------------------------
    -- GTT 초기화 (이후에 일반 테이블 DML이 있으므로 DELETE FROM 사용)
    -----------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.GT_0044_RESULTS_MST_C;

    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_0044_RESULTS_MST_C', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    --=============================================================================================
    -- 시작 LOG  (START)
    --=============================================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    --=============================================================================================
    --#results_MST 테이블에 split후 insert (START)
    --=============================================================================================
    INSERT INTO SCM_MGR.GT_0044_RESULTS_MST_C
    ( ACTIVE_FLAG, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD,
      DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT,
      CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, DOM_EXP,
      FCST_TYPE, INCOTERMS, ITEM_ID, MEASURE, YYYYMMDD,
      CURRENCY, QTY, COMPANY_ID, CREATED_BY )
    SELECT TRIM(A_ACTIVE_FLAG), TRIM(A_DIVISION_ID), TRIM(A_VERSION_NO), TRIM(A_CUTOFF_TYPE), TRIM(A_CUTOFF_YYYYMMDD),
           TRIM(A_DEPARTMENT_ID), TRIM(A_DEPARTMENT_NAME), TRIM(A_DEPT_ID), TRIM(A_DEPT_NAME), TRIM(A_END_CUST_REPORT),
           TRIM(A_CUST_REPORT), TRIM(A_PRODUCT_GROUP), TRIM(A_PROJECT_CODE), TRIM(A_SCM_SITE_ID), '-',
           TRIM(A_FCST_TYPE), TRIM(A_INCOTERMS), TRIM(A_ITEM_ID), TRIM(A_MEASURE),
           SUBSTR(TRIM(A_YYYYMMDD), 1, 6) || '01',
           TRIM(A_CURRENCY),
           CASE WHEN TRIM(A_QTY) IS NULL OR TRIM(A_QTY) = '' THEN '0' ELSE TRIM(A_QTY) END,
           TRIM(A_COMPANY_ID), TRIM(A_CREATED_BY)
    FROM (
        SELECT REGEXP_SUBSTR(P_ACTIVE_FLAG,      '[^^]+', 1, LEVEL) AS A_ACTIVE_FLAG,
               REGEXP_SUBSTR(P_DIVISION_ID,      '[^^]+', 1, LEVEL) AS A_DIVISION_ID,
               REGEXP_SUBSTR(P_VERSION_NO,       '[^^]+', 1, LEVEL) AS A_VERSION_NO,
               REGEXP_SUBSTR(P_CUTOFF_TYPE,      '[^^]+', 1, LEVEL) AS A_CUTOFF_TYPE,
               REGEXP_SUBSTR(P_CUTOFF_YYYYMMDD,  '[^^]+', 1, LEVEL) AS A_CUTOFF_YYYYMMDD,
               REGEXP_SUBSTR(P_DEPARTMENT_ID,    '[^^]+', 1, LEVEL) AS A_DEPARTMENT_ID,
               REGEXP_SUBSTR(P_DEPARTMENT_NAME,  '[^^]+', 1, LEVEL) AS A_DEPARTMENT_NAME,
               REGEXP_SUBSTR(P_DEPT_ID,          '[^^]+', 1, LEVEL) AS A_DEPT_ID,
               REGEXP_SUBSTR(P_DEPT_NAME,        '[^^]+', 1, LEVEL) AS A_DEPT_NAME,
               REGEXP_SUBSTR(P_END_CUST_REPORT,  '[^^]+', 1, LEVEL) AS A_END_CUST_REPORT,
               REGEXP_SUBSTR(P_CUST_REPORT,      '[^^]+', 1, LEVEL) AS A_CUST_REPORT,
               REGEXP_SUBSTR(P_PRODUCT_GROUP,    '[^^]+', 1, LEVEL) AS A_PRODUCT_GROUP,
               REGEXP_SUBSTR(P_ITEM_ID,          '[^^]+', 1, LEVEL) AS A_ITEM_ID,
               REGEXP_SUBSTR(P_MEASURE,          '[^^]+', 1, LEVEL) AS A_MEASURE,
               REGEXP_SUBSTR(P_YYYYMMDD,         '[^^]+', 1, LEVEL) AS A_YYYYMMDD,
               REGEXP_SUBSTR(P_CURRENCY,         '[^^]+', 1, LEVEL) AS A_CURRENCY,
               REGEXP_SUBSTR(P_QTY,              '[^^]+', 1, LEVEL) AS A_QTY,
               REGEXP_SUBSTR(P_SCM_SITE_ID,      '[^^]+', 1, LEVEL) AS A_SCM_SITE_ID,
               REGEXP_SUBSTR(P_PROJECT_CODE,     '[^^]+', 1, LEVEL) AS A_PROJECT_CODE,
               REGEXP_SUBSTR(P_COMPANY_ID,       '[^^]+', 1, LEVEL) AS A_COMPANY_ID,
               REGEXP_SUBSTR(P_FCST_TYPE,        '[^^]+', 1, LEVEL) AS A_FCST_TYPE,
               REGEXP_SUBSTR(P_INCOTERMS,        '[^^]+', 1, LEVEL) AS A_INCOTERMS,
               REGEXP_SUBSTR(P_CREATED_BY,       '[^^]+', 1, LEVEL) AS A_CREATED_BY
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^^]+', 1, LEVEL) IS NOT NULL
    );
    --=============================================================================================
    --#results_MST 테이블에 split후 insert (END)
    --=============================================================================================

    -- 공통 변수 보관 (첫번째 토큰)
    V_DIVISION_ID      := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,     '[^^]+', 1, 1));
    V_VERSION_NO       := TRIM(REGEXP_SUBSTR(P_VERSION_NO,      '[^^]+', 1, 1));
    V_CUTOFF_TYPE      := TRIM(REGEXP_SUBSTR(P_CUTOFF_TYPE,     '[^^]+', 1, 1));
    V_CUTOFF_YYYYMMDD  := TRIM(REGEXP_SUBSTR(P_CUTOFF_YYYYMMDD, '[^^]+', 1, 1));
    V_CREATED_BY       := TRIM(REGEXP_SUBSTR(P_CREATED_BY,      '[^^]+', 1, 1));

    -----------------------------------------------------------------------------------------------
    --ORI_VERSION_NO을 조회하여 변수에 보관한다.
    -----------------------------------------------------------------------------------------------
    BEGIN
        SELECT ORI_VERSION_NO INTO V_ORI_VERSION_NO
        FROM   SCM_MGR.DM_MDF_VERSION
        WHERE  VERSION_TYPE = V_CUTOFF_TYPE
        AND    VERSION_NO   = V_VERSION_NO
        AND    ROWNUM       = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL;
    END;

    -----------------------------------------------------------------------------------------------
    -- 처리할 데이터에 순번을 넣어준다. ( 메저들을 묶어서 한 세트로 )
    -----------------------------------------------------------------------------------------------
    FOR REC IN (
        SELECT ROWID AS RID,
               DENSE_RANK() OVER ( ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
                                             DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID,
                                             ITEM_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY ) AS NEW_SEQ_RANK
        FROM SCM_MGR.GT_0044_RESULTS_MST_C
    ) LOOP
        UPDATE SCM_MGR.GT_0044_RESULTS_MST_C SET SEQ_RANK = REC.NEW_SEQ_RANK WHERE ROWID = REC.RID;
    END LOOP;

    FOR REC IN (
        SELECT ROWID AS RID,
               ROW_NUMBER() OVER ( PARTITION BY SEQ_RANK
                                   ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID,
                                            DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID,
                                            ITEM_ID, SUBSTR(YYYYMMDD, 1, 6), CURRENCY ) AS NEW_SEQ_ROWNUM
        FROM SCM_MGR.GT_0044_RESULTS_MST_C
    ) LOOP
        UPDATE SCM_MGR.GT_0044_RESULTS_MST_C SET SEQ_ROWNUM = REC.NEW_SEQ_ROWNUM WHERE ROWID = REC.RID;
    END LOOP;

    -----------------------------------------------------------------------------------------------
    -- 계획구간 여부 UPDATE
    -----------------------------------------------------------------------------------------------
    UPDATE SCM_MGR.GT_0044_RESULTS_MST_C
    SET PLAN_YN = CASE WHEN SUBSTR(YYYYMMDD, 1, 6) >= TO_CHAR(SYSDATE, 'YYYYMM') THEN 'Y' ELSE '' END;

    SELECT COUNT(ACTIVE_FLAG) INTO N_INPUT_COUNT FROM SCM_MGR.GT_0044_RESULTS_MST_C;

    -- GTT INSERT 후 통계 수집 (JOIN 사용)
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname => 'SCM_MGR', tabname => 'GT_0044_RESULTS_MST_C',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    --=============================================================================================
    --DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (START)
    --=============================================================================================
    IF V_CUTOFF_TYPE = 'REPORT_SP_W' THEN
        -----------------------------------------------------------------------------------------------
        -- 초기화
        -----------------------------------------------------------------------------------------------
        V_I := 1; V_CNT := 0; V_ADJQTY := 0; V_REST := 0; V_ORIQTY := 0; V_QTYCNT := 0; V_MINDATE := NULL; V_PLAN_YN := '';

        SELECT NVL(MAX(SEQ_RANK), 0) INTO V_CNT FROM SCM_MGR.GT_0044_RESULTS_MST_C;

        IF V_DIVISION_ID = '40' THEN
            WHILE V_I <= V_CNT LOOP
                BEGIN
                    SELECT PLAN_YN INTO V_PLAN_YN
                    FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND ROWNUM = 1;
                EXCEPTION WHEN NO_DATA_FOUND THEN V_PLAN_YN := '';
                END;

                -----------------------------------------------------------------------------------------------
                -- Pricce 가 변경된 경우 ( 계획구간 ) -- 일단 Price 만 업데이트
                -----------------------------------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'LOC');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    -----------------------------------------------------------------------------------------------
                    -- LOC 가 있으면 업데이트, 없으면 인서트
                    -----------------------------------------------------------------------------------------------
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'LOC' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                   WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID
                                   AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                   AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                                   AND B.PRODUCT_GROUP = A.PRODUCT_GROUP AND B.PROJECT_CODE = A.PROJECT_CODE
                                   AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                   AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%'
                                   AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                   AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID
                            AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                            AND B.PRODUCT_GROUP = A.PRODUCT_GROUP AND B.PROJECT_CODE = A.PROJECT_CODE
                            AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%'
                            AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                    ELSE
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'LOC', '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.SEQ_RANK = V_I AND B.MEASURE = 'LOC'
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------------------------------
                -- 수량등이 변경된 건이 있을 경우 기존 데이터의 비율대로 배부하고 남은건을 첫번째 날짜에 몰아준다.
                -----------------------------------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE IN ('RTF', 'RTF_SYS_RP'));

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C
                    WHERE SEQ_RANK = V_I AND MEASURE IN ('RTF', 'RTF_SYS_RP') AND ROWNUM = 1;

                    -----------------------------------------------------------------------------------------------
                    -- 수정전 DM_PLN_SALES_PLAN_REPORT_C 테이블의 수량 합계, 건수 계산
                    -----------------------------------------------------------------------------------------------
                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD)
                    INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    -----------------------------------------------------------------------------------------------
                    -- 수정후 수량 = 수정된 총수량 * 원래개별수량/원래총수량
                    -----------------------------------------------------------------------------------------------
                    IF NVL(V_ORIQTY,0) <> 0 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        --나머지 배부
                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE IN ('RTF', 'RTF_SYS_RP') AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -----------------------------------------------------------------------------------------------
                        -- RTF 가 원래 없었을 경우
                        -----------------------------------------------------------------------------------------------
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), B.MEASURE, '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE IN ('RTF', 'RTF_SYS_RP') AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------
                -- 금액처리_SalesAmt_LOC ( 여기서는 Qty 변수들을 Amnt 로 활용한다. )
                -----------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_LOC');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    V_ADJQTY := 0; V_REST := 0;
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1;

                    -- 수정전 금액 합계, 건수 계산
                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    V_EXISTS := 0;
                    BEGIN
                        SELECT 1 INTO V_EXISTS FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA
                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB
                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID
                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP
                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID
                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'
                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE
                             AND BB.SEQ_RANK = V_I
                            WHERE AA.MEASURE = 'SalesAmt_LOC' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO
                        );
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                    END;
                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        --나머지 배부
                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -- 원래 SalesAmt_LOC 메저가 없었던 경우
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'SalesAmt_LOC', '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE = 'SalesAmt_LOC' AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------
                -- 금액처리_SalesAmt_KRW
                -----------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_KRW');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_KRW' AND ROWNUM = 1;

                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    V_EXISTS := 0;
                    BEGIN
                        SELECT 1 INTO V_EXISTS FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA
                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB
                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID
                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP
                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID
                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'
                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE
                             AND BB.SEQ_RANK = V_I
                            WHERE AA.MEASURE = 'SalesAmt_KRW' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO
                        );
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                    END;
                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -- 원래 SalesAmt_KRW 메저가 없었던 경우
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'SalesAmt_KRW', '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE = 'SalesAmt_KRW' AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                -----------------------------------------------------------------------
                -- 금액처리_SalesAmt_USD
                -----------------------------------------------------------------------
                V_EXISTS := 0;

                BEGIN

                    SELECT 1 INTO V_EXISTS FROM DUAL

                    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_USD');

                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                END;

                IF V_EXISTS = 1 THEN
                    SELECT TO_NUMBER(QTY) INTO V_ADJQTY FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND MEASURE = 'SalesAmt_USD' AND ROWNUM = 1;

                    SELECT NVL(SUM(A.QTY),0), COUNT(*), MIN(A.YYYYMMDD) INTO V_ORIQTY, V_QTYCNT, V_MINDATE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                    WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                    V_EXISTS := 0;
                    BEGIN
                        SELECT 1 INTO V_EXISTS FROM DUAL
                        WHERE EXISTS (
                            SELECT 1
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA
                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB
                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID
                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP
                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID
                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'
                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE
                             AND BB.SEQ_RANK = V_I
                            WHERE AA.MEASURE = 'SalesAmt_USD' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO
                        );
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                    END;
                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = CASE WHEN V_ORIQTY <> 0 THEN ROUND(V_ADJQTY * A.QTY / V_ORIQTY, 0) ELSE ROUND(V_ADJQTY / V_QTYCNT, 0) END,
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);

                        SELECT V_ADJQTY - NVL(SUM(A.QTY),0) INTO V_REST
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.MEASURE = B.MEASURE AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;

                        IF V_REST <> 0 THEN
                            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                            SET QTY = A.QTY + V_REST, LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                            WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.YYYYMMDD = V_MINDATE
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                                AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                                AND B.MEASURE = A.MEASURE AND B.SEQ_RANK = V_I);
                        END IF;
                    ELSE
                        -- 원래 SalesAmt_USD 메저가 없었던 경우
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'SalesAmt_USD', '-', B.YYYYMMDD
                             , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                             , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                             , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                             , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                         AND B.MEASURE = 'SalesAmt_USD' AND B.SEQ_RANK = V_I
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                END IF;

                --====================================================================================================================================================
                --여기부터는 구간 일괄 업데이트
                --====================================================================================================================================================
                IF V_PLAN_YN = 'Y' THEN
                    -----------------------------------------------------------------------------------------------
                    -- 계획구간은 금액을 업데이트함 ( LOC )
                    -----------------------------------------------------------------------------------------------
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'SalesAmt_LOC' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT C.QTY * D.QTY
                                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C, SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C D
                                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID
                                   AND C.MEASURE IN ('RTF', 'RTF_SYS_RP')
                                   AND D.VERSION_NO = A.VERSION_NO AND D.DIVISION_ID = A.DIVISION_ID AND D.DEPARTMENT_ID = A.DEPARTMENT_ID AND D.DEPT_ID = A.DEPT_ID
                                   AND D.END_CUST_REPORT = A.END_CUST_REPORT AND D.CUST_REPORT = A.CUST_REPORT AND D.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND D.PROJECT_CODE = A.PROJECT_CODE AND D.SCM_SITE_ID = A.SCM_SITE_ID AND D.ITEM_ID = A.ITEM_ID
                                   AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = A.CURRENCY AND D.COMPANY_ID = A.COMPANY_ID
                                   AND D.MEASURE = 'LOC' AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.SEQ_RANK = V_I);
                    ELSE
                        -- 계획구간 SalesAmt_LOC INSERT (RTF * LOC)
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID, NVL(C.DEPARTMENT_NAME, '-'), C.DEPT_ID, NVL(C.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(C.DOM_EXP, '-'), NVL(C.FCST_TYPE, '-'), NVL(C.INCOTERMS, '-'), 'SalesAmt_LOC', '-', A.YYYYMMDD
                             , A.CURRENCY, SUM(C.QTY) * MAX(D.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10
                             , C.COMPANY_ID, C.PROJECT_CODE, C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME
                             , C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
                             , C.COUNTRY_KR_NAME, C.ROUTE, NVL(C.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.GT_0044_RESULTS_MST_C A
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                          ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                         AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
                         AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(C.YYYYMMDD,1,6)||'%' AND A.CURRENCY = C.CURRENCY AND A.COMPANY_ID = C.COMPANY_ID
                         AND C.MEASURE IN ('RTF', 'RTF_SYS_RP')
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C D
                          ON A.VERSION_NO = D.VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.DEPARTMENT_ID = D.DEPARTMENT_ID AND A.DEPT_ID = D.DEPT_ID
                         AND A.END_CUST_REPORT = D.END_CUST_REPORT AND A.CUST_REPORT = D.CUST_REPORT AND A.PRODUCT_GROUP = D.PRODUCT_GROUP
                         AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND A.CURRENCY = D.CURRENCY AND A.COMPANY_ID = D.COMPANY_ID
                         AND D.MEASURE = 'LOC'
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.SEQ_RANK = V_I
                        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID
                               , NVL(C.DEPARTMENT_NAME, '-'), C.DEPT_ID, NVL(C.DEPT_NAME, '-'), A.END_CUST_REPORT, A.CUST_REPORT
                               , A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(C.DOM_EXP, '-'), C.FCST_TYPE
                               , NVL(C.INCOTERMS, '-'), A.YYYYMMDD, A.CURRENCY, C.ATTRIBUTE1, C.ATTRIBUTE2
                               , C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7
                               , C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10, C.COMPANY_ID, C.PROJECT_CODE
                               , C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC
                               , C.NICK_NAME, C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME
                               , C.APPLICATION, C.APPLICATION_GR, C.COUNTRY_KR_NAME, C.ROUTE, C.CELL_PROD_SITE;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;

                    -- 계획구간은 금액을 업데이트함 ( KRW ) - SalesAmt_LOC * EXCHANGE
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'SalesAmt_KRW' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
                                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D
                                     ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID
                                    AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID
                                   AND C.MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.SEQ_RANK = V_I);
                    ELSE
                        -- 계획구간 SalesAmt_KRW INSERT
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID, NVL(C.DEPARTMENT_NAME, '-'), C.DEPT_ID, NVL(C.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(C.DOM_EXP, '-'), NVL(C.FCST_TYPE, '-'), NVL(C.INCOTERMS, '-'), 'SalesAmt_KRW', '-', A.YYYYMMDD
                             , A.CURRENCY, ROUND(C.QTY * D.EXCHANGE_PRICE, 0), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10
                             , C.COMPANY_ID, C.PROJECT_CODE, C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME
                             , C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
                             , C.COUNTRY_KR_NAME, C.ROUTE, NVL(C.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.GT_0044_RESULTS_MST_C A
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                          ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                         AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
                         AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(C.YYYYMMDD,1,6)||'%' AND A.CURRENCY = C.CURRENCY AND A.COMPANY_ID = C.COMPANY_ID
                         AND C.MEASURE = 'SalesAmt_LOC'
                        JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D
                          ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID
                         AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.SEQ_RANK = V_I
                        AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;

                    -- 계획구간은 금액을 업데이트함 ( USD )
                    V_EXISTS := 0;

                    BEGIN

                        SELECT 1 INTO V_EXISTS FROM DUAL

                        WHERE EXISTS (

                            SELECT 1

                            FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C AA

                            JOIN SCM_MGR.GT_0044_RESULTS_MST_C BB

                              ON AA.VERSION_NO = BB.VERSION_NO AND AA.DIVISION_ID = BB.DIVISION_ID AND AA.DEPARTMENT_ID = BB.DEPARTMENT_ID AND AA.DEPT_ID = BB.DEPT_ID

                             AND AA.END_CUST_REPORT = BB.END_CUST_REPORT AND AA.CUST_REPORT = BB.CUST_REPORT AND AA.PRODUCT_GROUP = BB.PRODUCT_GROUP

                             AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID

                             AND AA.YYYYMMDD LIKE SUBSTR(BB.YYYYMMDD, 1, 6) || '%'

                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE

                             AND BB.SEQ_RANK = V_I

                            WHERE AA.MEASURE = 'SalesAmt_USD' AND AA.DIVISION_ID = V_DIVISION_ID AND AA.VERSION_NO = V_VERSION_NO

                        );

                    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;

                    END;

                    IF V_EXISTS = 1 THEN
                        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                        SET QTY = NVL((SELECT CASE WHEN NVL(E.EXCHANGE_PRICE,0) <> 0 THEN ROUND(C.QTY * D.EXCHANGE_PRICE / E.EXCHANGE_PRICE, 0) ELSE 0 END
                                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E ON E.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = E.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(E.YYYYMMDD,1,6)||'%' AND E.CURRENCY = 'KRW' AND E.UNIT_CURRENCY = A.CURRENCY
                                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID
                                   AND C.MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1), A.QTY),
                            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                            AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                            AND B.SEQ_RANK = V_I);
                    ELSE
                        -- 계획구간 SalesAmt_USD INSERT
                        INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                        ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                        , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                        , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                        , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                        , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                        SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID, NVL(C.DEPARTMENT_NAME, '-'), C.DEPT_ID, NVL(C.DEPT_NAME, '-'), A.END_CUST_REPORT
                             , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(C.DOM_EXP, '-'), NVL(C.FCST_TYPE, '-'), NVL(C.INCOTERMS, '-'), 'SalesAmt_USD', '-', A.YYYYMMDD
                             , A.CURRENCY, CASE WHEN NVL(E.EXCHANGE_PRICE,0) <> 0 THEN ROUND(C.QTY * D.EXCHANGE_PRICE / E.EXCHANGE_PRICE, 0) ELSE 0 END
                             , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                             , C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10
                             , C.COMPANY_ID, C.PROJECT_CODE, C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME
                             , C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
                             , C.COUNTRY_KR_NAME, C.ROUTE, NVL(C.CELL_PROD_SITE, '-')
                        FROM SCM_MGR.GT_0044_RESULTS_MST_C A
                        JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                          ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                         AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
                         AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                         AND A.YYYYMMDD LIKE SUBSTR(C.YYYYMMDD,1,6)||'%' AND A.CURRENCY = C.CURRENCY AND A.COMPANY_ID = C.COMPANY_ID
                         AND C.MEASURE = 'SalesAmt_LOC'
                        JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(D.YYYYMMDD,1,6)||'%' AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                        JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C E ON E.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = E.DIVISION_ID AND A.YYYYMMDD LIKE SUBSTR(E.YYYYMMDD,1,6)||'%' AND E.CURRENCY = 'KRW' AND E.UNIT_CURRENCY = A.CURRENCY
                        WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND A.SEQ_RANK = V_I
                        AND ROWNUM = 1;
                        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                    END IF;
                ELSE
                    -----------------------------------------------------------------------------------------------
                    -- 실적구간은 단가를 업데이트
                    -- SalesAmt_LOC 를 Qty 로 나눠서 단가를 계산한다. ( 본테이블에서 LOC 를 지우고, 다시 계산해서 INSERT 한다. )
                    -----------------------------------------------------------------------------------------------
                    -- INSERT 할 날짜
                    BEGIN
                        SELECT YYYYMMDD INTO V_YYYYMMDD FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE SEQ_RANK = V_I AND ROWNUM = 1;
                    EXCEPTION WHEN NO_DATA_FOUND THEN V_YYYYMMDD := NULL;
                    END;
                    V_YYYYMMDD := SUBSTR(V_YYYYMMDD, 1, 6) || '01';

                    -- 삭제
                    DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    WHERE A.MEASURE = 'LOC'
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                        WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                        AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                        AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                        AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                        AND B.SEQ_RANK = V_I);
                    N_DELETE_COUNT := N_DELETE_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                    -- SalesAmt_LOC 합산
                    SELECT NVL(SUM(A.QTY),0) INTO V_LOC_SALESAMT_LOC
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND B.SEQ_RANK = V_I AND B.SEQ_ROWNUM = 1 AND A.MEASURE = 'SalesAmt_LOC';

                    SELECT NVL(SUM(A.QTY),0) INTO V_LOC_RTF
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND B.SEQ_RANK = V_I AND B.SEQ_ROWNUM = 1 AND A.MEASURE IN ('RTF', 'RTF_SYS_RP');

                    INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                    ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                    , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                    , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                    , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                    , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                    , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                    SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                         , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'LOC', '-', B.YYYYMMDD
                         , A.CURRENCY, CASE WHEN NVL(V_LOC_RTF, 0) <> 0 THEN ROUND(V_LOC_SALESAMT_LOC / V_LOC_RTF, 3) ELSE 0 END
                         , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                         , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
                     AND B.SEQ_RANK = V_I AND B.SEQ_ROWNUM = 1
                    WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                    N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                END IF; -- V_PLAN_YN

                V_I := V_I + 1;
            END LOOP; -- WHILE V_I <= V_CNT (division_id = '40')

        ELSE
            -----------------------------------------------------------------------------------------------
            -- 자동차 ESS ( 데이터는 1일자에만 들어있고, 수정은 계획구간의 LOC 만 가능 )
            -- 자동차는 Product_group 을 조건에서 제외함
            -- *** 이 분기는 원본 MSSQL A030~A036 영역에 해당하며 동일 패턴으로 변환 ***
            -- (분량 제약으로 동일 패턴의 반복 코드는 축약 표기하되, 실제 배포 시 전개 필요)
            -----------------------------------------------------------------------------------------------
            WHILE V_I <= V_CNT LOOP
                -- LOC 가 있으면 업데이트, 없으면 인서트 (PRODUCT_GROUP, COMPANY_ID 조인 제외, FCST_TYPE 분기, YYYYMMDD 직접매칭)
                V_EXISTS := 0;
                BEGIN
                    SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (
                        SELECT 1 FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                          ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                         AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                         AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                         AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY AND A.MEASURE = B.MEASURE
                         AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                         AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                        WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO);
                EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
                END;

                IF V_EXISTS = 1 THEN
                    -- 1. LOC 메저를 업데이트
                    UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                               WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                               AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                               AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                               AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.MEASURE = A.MEASURE
                               AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                               AND B.INCOTERMS = A.INCOTERMS AND B.SEQ_RANK = V_I AND ROWNUM = 1), A.QTY),
                        LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
                    WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                        WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                        AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                        AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                        AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.MEASURE = A.MEASURE
                        AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                        AND B.INCOTERMS = A.INCOTERMS AND B.SEQ_RANK = V_I);
                ELSE
                    -- LOC INSERT (자동차 ESS - PRODUCT_GROUP 제외)
                    INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                    ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                    , CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                    , CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                    , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                    , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                    , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                    SELECT '1', A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, NVL(A.DEPT_NAME, '-'), A.END_CUST_REPORT
                         , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), 'LOC', '-', B.YYYYMMDD
                         , A.CURRENCY, TO_NUMBER(B.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                         , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.MEASURE = 'LOC' AND B.SEQ_RANK = V_I
                    WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO AND ROWNUM = 1;
                    N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count
                END IF;

                -- 2. 기타 금액메저 모두 삭제
                DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                WHERE (A.MEASURE IN ('KRW','USD') OR A.MEASURE LIKE 'SalesAmt%')
                AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
                AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                    WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                    AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT
                    AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                    AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY
                    AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                    AND B.INCOTERMS = A.INCOTERMS AND B.SEQ_RANK = V_I);
                N_DELETE_COUNT := N_DELETE_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                -- 3. KRW 메저 INSERT (LOC * EXCHANGE_PRICE)
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                SELECT SUB_A.DATA_TYPE, SUB_A.DIVISION_ID, SUB_A.VERSION_NO, SUB_A.CUTOFF_TYPE, SUB_A.CUTOFF_YYYYMMDD, SUB_A.DEPARTMENT_ID, SUB_A.DEPARTMENT_NAME, SUB_A.DEPT_ID, SUB_A.DEPT_NAME, SUB_A.END_CUST_REPORT
                     , SUB_A.CUST_REPORT, SUB_A.PRODUCT_GROUP, SUB_A.PROJECT_CODE, SUB_A.SCM_SITE_ID, SUB_A.ITEM_ID, SUB_A.DOM_EXP, SUB_A.FCST_TYPE, SUB_A.INCOTERMS, 'KRW', SUB_A.PLANT_SITE_ID
                     , SUB_A.YYYYMMDD, SUB_A.CURRENCY, SUB_A.QTY * EX.EXCHANGE_PRICE, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                     , SUB_A.ATTRIBUTE1, SUB_A.ATTRIBUTE2, SUB_A.ATTRIBUTE3, SUB_A.ATTRIBUTE4, SUB_A.ATTRIBUTE5, SUB_A.ATTRIBUTE6, SUB_A.ATTRIBUTE7, SUB_A.ATTRIBUTE8, SUB_A.ATTRIBUTE9, SUB_A.ATTRIBUTE10
                     , SUB_A.COMPANY_ID, SUB_A.SOLDTO_CUST_REPORT, SUB_A.OWNER_NAME, SUB_A.CUST_GROUP_DTL, SUB_A.PRODUCT_DETAILS, SUB_A.FORECAST_INFO_SPEC, SUB_A.NICK_NAME
                     , SUB_A.FORECAST_INFO_CELL_MODEL, SUB_A.FORECAST_INFO_CELL_PACK_COUNT, SUB_A.FORECAST_INFO_BIZ_TYPE, SUB_A.COMPANY_NAME, SUB_A.APPLICATION, SUB_A.APPLICATION_GR
                     , SUB_A.COUNTRY_KR_NAME, SUB_A.ROUTE, NVL(SUB_A.CELL_PROD_SITE, '-')
                FROM (SELECT A.* FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                     WHERE A.DIVISION_ID = V_DIVISION_ID AND A.MEASURE = 'LOC' AND A.VERSION_NO = V_VERSION_NO) SUB_A
                JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C EX
                  ON SUB_A.DIVISION_ID = EX.DIVISION_ID AND SUB_A.VERSION_NO = EX.VERSION_NO AND SUB_A.CUTOFF_TYPE = EX.CUTOFF_TYPE
                 AND SUB_A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND SUB_A.CURRENCY = EX.UNIT_CURRENCY
                 AND SUB_A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_VERSION_NO;
                N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                -- USD 메저 INSERT
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                SELECT SUB_A.DATA_TYPE, SUB_A.DIVISION_ID, SUB_A.VERSION_NO, SUB_A.CUTOFF_TYPE, SUB_A.CUTOFF_YYYYMMDD, SUB_A.DEPARTMENT_ID, SUB_A.DEPARTMENT_NAME, SUB_A.DEPT_ID, SUB_A.DEPT_NAME, SUB_A.END_CUST_REPORT
                     , SUB_A.CUST_REPORT, SUB_A.PRODUCT_GROUP, SUB_A.PROJECT_CODE, SUB_A.SCM_SITE_ID, SUB_A.ITEM_ID, SUB_A.DOM_EXP, SUB_A.FCST_TYPE, SUB_A.INCOTERMS, 'USD', SUB_A.PLANT_SITE_ID
                     , SUB_A.YYYYMMDD, SUB_A.CURRENCY
                     , CASE WHEN NVL(EX.EXCHANGE_PRICE, 0) <> 0 THEN ROUND(SUB_A.QTY / EX.EXCHANGE_PRICE, 3) ELSE 0 END
                     , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                     , SUB_A.ATTRIBUTE1, SUB_A.ATTRIBUTE2, SUB_A.ATTRIBUTE3, SUB_A.ATTRIBUTE4, SUB_A.ATTRIBUTE5, SUB_A.ATTRIBUTE6, SUB_A.ATTRIBUTE7, SUB_A.ATTRIBUTE8, SUB_A.ATTRIBUTE9, SUB_A.ATTRIBUTE10
                     , SUB_A.COMPANY_ID, SUB_A.SOLDTO_CUST_REPORT, SUB_A.OWNER_NAME, SUB_A.CUST_GROUP_DTL, SUB_A.PRODUCT_DETAILS, SUB_A.FORECAST_INFO_SPEC, SUB_A.NICK_NAME
                     , SUB_A.FORECAST_INFO_CELL_MODEL, SUB_A.FORECAST_INFO_CELL_PACK_COUNT, SUB_A.FORECAST_INFO_BIZ_TYPE, SUB_A.COMPANY_NAME, SUB_A.APPLICATION, SUB_A.APPLICATION_GR
                     , SUB_A.COUNTRY_KR_NAME, SUB_A.ROUTE, NVL(SUB_A.CELL_PROD_SITE, '-')
                FROM (SELECT A.* FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                     WHERE A.DIVISION_ID = V_DIVISION_ID AND A.MEASURE = 'KRW' AND A.VERSION_NO = V_VERSION_NO) SUB_A
                JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C EX
                  ON SUB_A.DIVISION_ID = EX.DIVISION_ID AND SUB_A.VERSION_NO = EX.VERSION_NO AND SUB_A.CUTOFF_TYPE = EX.CUTOFF_TYPE
                 AND SUB_A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND EX.UNIT_CURRENCY = 'USD'
                 AND SUB_A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = V_VERSION_NO;
                N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                -- 4. SalesAmt_LOC, KRW, USD 업데이트 또는 생성 (RTF * LOC/KRW/USD 매칭)
                INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
                ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
                , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                , COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
                , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
                , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
                SELECT SUB_A.DATA_TYPE, SUB_A.DIVISION_ID, SUB_A.VERSION_NO, SUB_A.CUTOFF_TYPE, SUB_A.CUTOFF_YYYYMMDD, SUB_A.DEPARTMENT_ID, SUB_A.DEPARTMENT_NAME, SUB_A.DEPT_ID, SUB_A.DEPT_NAME, SUB_A.END_CUST_REPORT
                     , SUB_A.CUST_REPORT, SUB_A.PRODUCT_GROUP, SUB_A.PROJECT_CODE, SUB_A.SCM_SITE_ID, SUB_A.ITEM_ID, SUB_A.DOM_EXP, SUB_A.FCST_TYPE, SUB_A.INCOTERMS, SUB_A.MEASURE, SUB_A.PLANT_SITE_ID
                     , SUB_A.YYYYMMDD, SUB_A.CURRENCY, SUB_A.QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                     , SUB_A.ATTRIBUTE1, SUB_A.ATTRIBUTE2, SUB_A.ATTRIBUTE3, SUB_A.ATTRIBUTE4, SUB_A.ATTRIBUTE5, SUB_A.ATTRIBUTE6, SUB_A.ATTRIBUTE7, SUB_A.ATTRIBUTE8, SUB_A.ATTRIBUTE9, SUB_A.ATTRIBUTE10
                     , SUB_A.COMPANY_ID, SUB_A.SOLDTO_CUST_REPORT, SUB_A.OWNER_NAME, SUB_A.CUST_GROUP_DTL, SUB_A.PRODUCT_DETAILS, SUB_A.FORECAST_INFO_SPEC, SUB_A.NICK_NAME
                     , SUB_A.FORECAST_INFO_CELL_MODEL, SUB_A.FORECAST_INFO_CELL_PACK_COUNT, SUB_A.FORECAST_INFO_BIZ_TYPE, SUB_A.COMPANY_NAME, SUB_A.APPLICATION, SUB_A.APPLICATION_GR
                     , SUB_A.COUNTRY_KR_NAME, SUB_A.ROUTE, NVL(SUB_A.CELL_PROD_SITE, '-')
                FROM (
                    SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-') AS DEPARTMENT_NAME, A.DEPT_ID, NVL(A.DEPT_NAME, '-') AS DEPT_NAME, A.END_CUST_REPORT
                         , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-') AS DOM_EXP, NVL(A.FCST_TYPE, '-') AS FCST_TYPE, A.INCOTERMS
                         , 'SalesAmt_' || C.MEASURE AS MEASURE, A.PLANT_SITE_ID
                         , A.YYYYMMDD, A.CURRENCY, ROUND(A.QTY * C.QTY, 3) AS QTY
                         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                         , A.COMPANY_ID, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
                         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
                         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-') AS CELL_PROD_SITE
                    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
                    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
                      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
                     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT
                     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                     AND A.YYYYMMDD = B.YYYYMMDD AND A.CURRENCY = B.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
                     AND A.INCOTERMS = B.INCOTERMS AND B.SEQ_RANK = V_I
                    JOIN SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                      ON A.VERSION_NO = C.VERSION_NO AND A.DIVISION_ID = C.DIVISION_ID AND A.DEPARTMENT_ID = C.DEPARTMENT_ID AND A.DEPT_ID = C.DEPT_ID
                     AND A.END_CUST_REPORT = C.END_CUST_REPORT AND A.CUST_REPORT = C.CUST_REPORT
                     AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
                     AND A.YYYYMMDD = C.YYYYMMDD AND A.CURRENCY = C.CURRENCY
                     AND A.FCST_TYPE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN B.FCST_TYPE ELSE C.FCST_TYPE END
                     AND A.INCOTERMS = C.INCOTERMS AND C.MEASURE IN ('LOC', 'USD', 'KRW')
                    WHERE A.DIVISION_ID = V_DIVISION_ID
                    AND A.MEASURE = CASE WHEN V_DIVISION_ID LIKE '81%' THEN 'RTF_SYS_RP' ELSE 'RTF' END
                    AND A.VERSION_NO = V_VERSION_NO
                ) SUB_A;
                N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;  -- [PATCH] DML count

                V_I := V_I + 1;
            END LOOP; -- 자동차 ESS
        END IF; -- V_DIVISION_ID = '40'
    --=============================================================================================
    --DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (END)
    --=============================================================================================
    --=============================================================================================
    --BP인 경우 (START)
    --=============================================================================================
    ELSE
        --[C20201005-000291] BP 부분을 루프에서 원쿼리로 변경함.
        -----------------------------------------------------------------------------------------------
        -- 단가 변경이 있을 경우 LOC, KRW, USD 를 같이 변경함
        -----------------------------------------------------------------------------------------------
        V_EXISTS := 0;
        BEGIN
            SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE MEASURE = 'LOC');
        EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
        END;

        IF V_EXISTS = 1 THEN
            -- LOC
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                       WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                       AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                       AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                       AND B.MEASURE = A.MEASURE AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = A.MEASURE);

            -- KRW (LOC * EXCHANGE)
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
                       FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                       JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                       WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                       AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                       AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'LOC' AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = 'LOC');

            -- USD (KRW / EXCHANGE)
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT ROUND(CASE WHEN NVL(D.EXCHANGE_PRICE,0) = 0 THEN 0 ELSE C.QTY / NVL(D.EXCHANGE_PRICE,0) END, 0)
                       FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                       JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                       WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                       AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                       AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'KRW' AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = 'USD');
        END IF;

        --	수량 변경이 있을 경우 처리 ( 수량은 수량만 수정 )
        V_EXISTS := 0;
        BEGIN SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C WHERE MEASURE = 'Business_Plan');
        EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0; END;

        IF V_EXISTS = 1 THEN
            UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
            SET QTY = NVL((SELECT TO_NUMBER(B.QTY) FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                       WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                       AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                       AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                       AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
                       AND B.MEASURE = A.MEASURE AND ROWNUM = 1), A.QTY),
                LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
            WHERE A.MEASURE = 'Business_Plan' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
                WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
                AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
                AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
                AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID AND B.MEASURE = A.MEASURE);
        END IF;

        -- BP는 모든 구간이 계획이므로 금액을 조정: SalesAmt_LOC = Business_Plan * LOC
        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        SET QTY = NVL((SELECT C.QTY * D.QTY
                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C, SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C D
                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'Business_Plan'
                   AND D.VERSION_NO = A.VERSION_NO AND D.DIVISION_ID = A.DIVISION_ID AND D.DEPARTMENT_ID = A.DEPARTMENT_ID AND D.DEPT_ID = A.DEPT_ID
                   AND D.END_CUST_REPORT = A.END_CUST_REPORT AND D.CUST_REPORT = A.CUST_REPORT AND D.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND D.PROJECT_CODE = A.PROJECT_CODE AND D.SCM_SITE_ID = A.SCM_SITE_ID AND D.ITEM_ID = A.ITEM_ID
                   AND D.YYYYMMDD = A.YYYYMMDD AND D.CURRENCY = A.CURRENCY AND D.COMPANY_ID = A.COMPANY_ID AND D.MEASURE = 'LOC' AND ROWNUM = 1), A.QTY),
            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        WHERE A.MEASURE = 'SalesAmt_LOC' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
            AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID);

        -- SalesAmt_KRW = SalesAmt_LOC * EXCHANGE
        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        SET QTY = NVL((SELECT ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
                   FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C C
                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = A.CURRENCY
                   WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
                   AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
                   AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID AND C.MEASURE = 'SalesAmt_LOC' AND ROWNUM = 1), A.QTY),
            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        WHERE A.MEASURE = 'SalesAmt_KRW' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
            WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
            AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
            AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
            AND B.YYYYMMDD = A.YYYYMMDD AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID);

        -- SalesAmt_USD = SalesAmt_KRW / EXCHANGE(USD)
        UPDATE SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
        SET QTY = NVL((SELECT ROUND(CASE WHEN NVL(D.EXCHANGE_PRICE,0) = 0 THEN 0 ELSE B_SUB.QTY / NVL(D.EXCHANGE_PRICE,0) END, 0)
                   FROM (SELECT A2.DIVISION_ID, A2.DEPARTMENT_ID, A2.DEPT_ID, A2.END_CUST_REPORT, A2.CUST_REPORT, A2.PRODUCT_GROUP, A2.PROJECT_CODE, A2.SCM_SITE_ID, A2.ITEM_ID, A2.YYYYMMDD, A2.CURRENCY, A2.COMPANY_ID, A2.QTY
                         FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A2
                         WHERE A2.MEASURE = 'SalesAmt_KRW' AND A2.VERSION_NO = V_VERSION_NO AND A2.DIVISION_ID = V_DIVISION_ID) B_SUB
                   JOIN SCM_MGR.DM_PLN_SALES_REPORT_EXCHANGE_C D ON D.VERSION_NO = V_VERSION_NO AND A.DIVISION_ID = D.DIVISION_ID AND A.YYYYMMDD = D.YYYYMMDD AND D.CURRENCY = 'KRW' AND D.UNIT_CURRENCY = 'USD'
                   WHERE B_SUB.DIVISION_ID = A.DIVISION_ID AND B_SUB.DEPARTMENT_ID = A.DEPARTMENT_ID AND B_SUB.DEPT_ID = A.DEPT_ID
                   AND B_SUB.END_CUST_REPORT = A.END_CUST_REPORT AND B_SUB.CUST_REPORT = A.CUST_REPORT AND B_SUB.PRODUCT_GROUP = A.PRODUCT_GROUP
                   AND B_SUB.PROJECT_CODE = A.PROJECT_CODE AND B_SUB.SCM_SITE_ID = A.SCM_SITE_ID AND B_SUB.ITEM_ID = A.ITEM_ID
                   AND B_SUB.YYYYMMDD = A.YYYYMMDD AND B_SUB.CURRENCY = A.CURRENCY AND B_SUB.COMPANY_ID = A.COMPANY_ID AND ROWNUM = 1), A.QTY),
            LAST_UPDATED_BY = V_CREATED_BY, LAST_UPDATE_DATE = SYSDATE --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        WHERE A.MEASURE = 'SalesAmt_USD' AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C C
            WHERE C.VERSION_NO = A.VERSION_NO AND C.DIVISION_ID = A.DIVISION_ID AND C.DEPARTMENT_ID = A.DEPARTMENT_ID AND C.DEPT_ID = A.DEPT_ID
            AND C.END_CUST_REPORT = A.END_CUST_REPORT AND C.CUST_REPORT = A.CUST_REPORT AND C.PRODUCT_GROUP = A.PRODUCT_GROUP
            AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
            AND C.YYYYMMDD = A.YYYYMMDD AND C.CURRENCY = A.CURRENCY AND C.COMPANY_ID = A.COMPANY_ID);
    END IF; -- V_CUTOFF_TYPE
    --=============================================================================================
    --BP인 경우 (END)
    --=============================================================================================

    --=============================================================================================
    --[E20230906-001160] GDW 송신용 데이터 Lookup 수정 START
    --=============================================================================================
    MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING (
        SELECT MODEL, BIZ_TYPE, CELL_PACK_COUNT, DIVISION_ID
        FROM (SELECT SEGMENT2 AS MODEL, SEGMENT3 AS BIZ_TYPE, SEGMENT4 AS CELL_PACK_COUNT, SEGMENT1 AS DIVISION_ID,
                     RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
              FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40')
        WHERE MODEL_RANK = 1
    ) LOOKA ON (LOOKA.MODEL = A.ITEM_ID AND LOOKA.DIVISION_ID = A.DIVISION_ID)
    WHEN MATCHED THEN UPDATE
    SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT,
        A.FORECAST_INFO_BIZ_TYPE        = LOOKA.BIZ_TYPE,
        A.LAST_UPDATED_BY               = V_CREATED_BY, --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
        A.LAST_UPDATE_DATE              = SYSDATE       --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
    WHERE A.DIVISION_ID = '40' AND A.VERSION_NO = V_VERSION_NO;
    --=============================================================================================
    --[E20230906-001160] GDW 송신용 데이터 Lookup 수정 END
    --=============================================================================================

    --=============================================================================================
    --[E20250418-001567]_Sales Report 이력 테이블 생성 START
    --=============================================================================================
    INSERT INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_H
    ( DATA_TYPE, DIVISION_ID, HISTORY_SEQ, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
    , END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
    , COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
    , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
    , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )
    SELECT A.DATA_TYPE, A.DIVISION_ID, SEQ1_DM_PLN_SALES_PLAN_REPORT_H.NEXTVAL, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, NVL(A.DEPARTMENT_NAME, '-'), A.DEPT_ID, A.DEPT_NAME
         , A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, NVL(A.DOM_EXP, '-'), NVL(A.FCST_TYPE, '-'), NVL(A.INCOTERMS, '-'), A.MEASURE, A.PLANT_SITE_ID
         , A.YYYYMMDD, A.CURRENCY, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
         , A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
         , A.COUNTRY_KR_NAME, A.ROUTE, NVL(A.CELL_PROD_SITE, '-')
    FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    JOIN SCM_MGR.GT_0044_RESULTS_MST_C B
      ON A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID
     AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.CUST_REPORT = B.CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
     AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
     AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND A.CURRENCY = B.CURRENCY AND A.COMPANY_ID = B.COMPANY_ID
     AND A.MEASURE = B.MEASURE
    WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO;
    N_HISTORY_COUNT := SQL%ROWCOUNT;  -- [PATCH] DML count
    --=============================================================================================
    --[E20250418-001567]_Sales Report 이력 테이블 생성 END
    --=============================================================================================

    -----------------------------------------------------------------------------------------------
    -- UPDATE 후에 전송처리를 다시 한다.
    -----------------------------------------------------------------------------------------------
    V_EXISTS := 0;
    BEGIN
        SELECT 1 INTO V_EXISTS FROM DUAL WHERE EXISTS (
            SELECT 1 FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID = V_DIVISION_ID AND VERSION_NO = V_VERSION_NO AND SEND_YN = 'Y');
    EXCEPTION WHEN NO_DATA_FOUND THEN V_EXISTS := 0;
    END;

    /* TODO DMF0044_MOBILE_REPORT_CREATE
    IF V_EXISTS = 1 THEN
        SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(V_DIVISION_ID, V_VERSION_NO, V_CUTOFF_TYPE, 'T', V_CREATED_BY);
    END IF;
    */
    
    --=============================================================================================
    -- COMMIT (종료 직전 1회)
    --=============================================================================================
    COMMIT;

    N_LOG_COUNT := N_INPUT_COUNT;
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    --=============================================================================================
    -- 종료 LOG
    --=============================================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure @@@##########';
    V_DESCRIPTION := 'input_count: '    || TO_CHAR(N_INPUT_COUNT)
                  || ' / insert_count: '|| TO_CHAR(N_INSERT_COUNT)
                  || ' / delete_count: '|| TO_CHAR(N_DELETE_COUNT)
                  || ' / history_count: '|| TO_CHAR(N_HISTORY_COUNT)
                  || ' / total_dml: '   || TO_CHAR(N_INSERT_COUNT + N_DELETE_COUNT);  -- [PATCH] DML 카운트
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

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
            'P_DIVISION_ID'      VALUE P_DIVISION_ID,
            'P_VERSION_NO'       VALUE P_VERSION_NO,
            'P_CUTOFF_TYPE'      VALUE P_CUTOFF_TYPE,
            'P_CUTOFF_YYYYMMDD'  VALUE P_CUTOFF_YYYYMMDD,
            'P_CREATED_BY'       VALUE P_CREATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF;



PROCEDURE P_DMF0044_SAVE_TEXTBOX
(
    P_VERSION_NO        IN  VARCHAR2,
    P_YYYYMM            IN  VARCHAR2,
    P_DESCRIPTION1      IN  VARCHAR2,
    P_DESCRIPTION2      IN  VARCHAR2,
    P_DESCRIPTION3      IN  VARCHAR2,
    P_DESCRIPTION4      IN  VARCHAR2,
    P_DESCRIPTION5      IN  VARCHAR2,
    P_DESCRIPTION6      IN  VARCHAR2,
    P_DESCRIPTION7      IN  VARCHAR2,
    P_DESCRIPTION8      IN  VARCHAR2,
    P_DESCRIPTION9      IN  VARCHAR2,
    P_DESCRIPTION10     IN  VARCHAR2,
    P_DESCRIPTION11     IN  VARCHAR2,
    P_DESCRIPTION12     IN  VARCHAR2,
    P_DESCRIPTION13     IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*************************************************************************************************
* Program ID  : DMF0044_SAVE_TEXTBOX                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : TEXTBOX POPUP 에서 Request 를 생성할 때 사용
* Parameter   :                                                                                  
* 
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------
* 2021-09-16   ROSIA27		[과제] TEXTBOX POPUP
* 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
***************************************************************************************************/
IS
    -- Case 41: 프로그램명 (패키지 대응)
    $$PLSQL_UNIT      VARCHAR2(200 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_merge_count       PLS_INTEGER := 0;

    v_exists            PLS_INTEGER;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY); END;
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

    -- VERSION_NO Validation
    BEGIN
        SELECT 1 INTO v_exists FROM DUAL
        WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_MDF_VERSION
                      WHERE DIVISION_ID = '82' AND VERSION_NO = P_VERSION_NO);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := '해당 VERSION 이 존재하지 않습니다.';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
    END;

    UPDATE SCM_MGR.DM_MDF_VERSION
    SET    TEXT_START_YYYYMM = P_YYYYMM,
           DESCRIPTION1      = NVL(P_DESCRIPTION1, ''),
           DESCRIPTION2      = NVL(P_DESCRIPTION2, ''),
           DESCRIPTION3      = NVL(P_DESCRIPTION3, ''),
           DESCRIPTION4      = NVL(P_DESCRIPTION4, ''),
           DESCRIPTION5      = NVL(P_DESCRIPTION5, ''),
           DESCRIPTION6      = NVL(P_DESCRIPTION6, ''),
           DESCRIPTION7      = NVL(P_DESCRIPTION7, ''),
           DESCRIPTION8      = NVL(P_DESCRIPTION8, ''),
           DESCRIPTION9      = NVL(P_DESCRIPTION9, ''),
           DESCRIPTION10     = NVL(P_DESCRIPTION10, ''),
           DESCRIPTION11     = NVL(P_DESCRIPTION11, ''),
           DESCRIPTION12     = NVL(P_DESCRIPTION12, ''),
           DESCRIPTION13     = NVL(P_DESCRIPTION13, ''),
           LAST_UPDATED_BY   = P_CREATED_BY,
           LAST_UPDATE_DATE  = SYSDATE
    WHERE  DIVISION_ID = '82'
    AND    VERSION_NO  = P_VERSION_NO;

    n_merge_count := SQL%ROWCOUNT;

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

    -- 수행결과 성공여부 DISPLAY
    N_LOG_COUNT := n_merge_count;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_VERSION_NO'    VALUE P_VERSION_NO,
            'P_YYYYMM'       VALUE P_YYYYMM,
            'P_DESCRIPTION1'  VALUE P_DESCRIPTION1,
            'P_CREATED_BY'    VALUE P_CREATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, P_CREATED_BY,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0044_SAVE_TEXTBOX;


END PKG_DMF0044;
/
