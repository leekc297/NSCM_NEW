PROCEDURE           "PR_DM_PLN_SALES_PLAN_RESULT_MOVE" 
(
    P_DIVISION_ID  IN VARCHAR2
)
/* ============================================================
 * Program ID   : PR_DM_PLN_SALES_PLAN_RESULT_MOVE
 * Description  :
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2018.03.29    JHBAEK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *                              [DM_PLN_MKT_FCST] -> [DM_PLN_MKT_FCST_RESULT] 테이블에 자료(과거 1주일) INSERT PROCEDURE
 *                              WEEKLY RUNNNG.
 * 2019.07.12    KHSONG         [CSR ID:4023158] 'RTF_SYS_RP' MEASURE 추가
 * 2020.02.13    HWI1993        COMPANY_ID 추가 안되서 오류발생
 * 2020.03.09    KHSONG         TMM_FCST ADD
 * 2022.04.07    hwi1993        GM JV 작업
 * 2025.04.22    JSSBAE         [E20250401-000548]_선감지(SMS) 대상 기준 정리
 * 2025.06.23    KANG.H.J       [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_DM_PLN_SALES_PLAN_RESULT_MOVE';
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    V_LOG_COUNT     NUMBER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    V_EVENT_DATE    DATE;
    V_DIVISION_ID   VARCHAR2(4000 CHAR);
BEGIN

    V_DIVISION_ID := NULL;

    /* START LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    V_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);
    V_LOG_MESSAGE := NULL;

    BEGIN

        IF P_DIVISION_ID = 'ALL' THEN
            V_DIVISION_ID := '';
        ELSE
            V_DIVISION_ID := P_DIVISION_ID;
        END IF;

        /* RESULT DATA DELETE */
        DELETE
          FROM DM_PLN_SALES_PLAN_RESULT L
         WHERE L.DIVISION_ID LIKE '%' || V_DIVISION_ID || '%'
           AND L.YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
           AND L.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7 * 2, 'YYYYMMDD')
           AND L.MEASURE IN ('MKT_FCST', 'CUST_FCST', 'RTF_SYS_RP', 'TMM_FCST');

        /* RESULT DATA INSERT */
        INSERT
          INTO DM_PLN_SALES_PLAN_RESULT
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , CURRENCY
             , QTY
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
             , COMPANY_ID
             , CELL_PROD_SITE_ID )
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , NVL(NULLIF(RTRIM(A.CURRENCY),''), '/') AS CURRENCY
             , SUM(A.QTY) AS QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , SYSDATE
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , ' ' AS COMPANY_ID
             , A.CELL_PROD_SITE_ID
          FROM DM_PLN_SALES_PLAN A
             , SCM_MST_DIVISION B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND B.DIVISION_ID LIKE '%' || V_DIVISION_ID || '%'
           AND 1 = 1
           AND A.YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
           AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7 * 2, 'YYYYMMDD')
           AND A.MEASURE IN ('MKT_FCST', 'CUST_FCST', 'RTF_SYS_RP', 'TMM_FCST')
      GROUP BY A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , NVL(NULLIF(RTRIM(A.CURRENCY),''), '/') /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식 */
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , A.CELL_PROD_SITE_ID;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            V_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);
    END;

    /* END LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    V_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

END;
