PROCEDURE           "PR_DM_PLN_ESS_VMI_REFRESH" 
/* ============================================================
 * Program ID   : PR_DM_PLN_ESS_VMI_REFRESH
 * Description  : 월요일 저녁에 ESS VMI 메저를 리프레시 한다.
 * Usage        :
 * Parameter    :
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2021.06.09    HWI1993        신규생성 C20210603-000166 ESS VMI Request 월요일 배치 추가건
 * 2021.08.26    HWI1993        [C20210825-000022] ess 사업부 refresh 기능 적용 구간 변경
 * 2021.09.02    HWI1993        [C20210825-000022] 대상에서 누락되는 건이 있어서 모든 VMI SITE 를 대상으로 변경함.
 * 2023.07.18    CHANO0612      [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선
 * 2025.06.23    KANG.H.J       [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_DM_PLN_ESS_VMI_REFRESH';
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     NUMBER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
    V_CREATED_BY    VARCHAR2(150 CHAR) := 'VMI_REFRESH';
    V_MONDAY        VARCHAR2(8 CHAR);
    V_BINV_DAY      VARCHAR2(8 CHAR);   /* 실적구간 마지막일자 */
    V_EV_BINV       NUMBER;
    L_DIVISION_ID   VARCHAR2(30 CHAR);
    L_SCM_SITE_ID   VARCHAR2(50 CHAR);
    L_PROJECT_CODE  VARCHAR2(50 CHAR);
    L_ITEM_ID       VARCHAR2(50 CHAR);
    L_DOM_EXP       VARCHAR2(3 CHAR);
    L_FCST_TYPE     VARCHAR2(20 CHAR);
    L_INCOTERMS     VARCHAR2(10 CHAR);
    L_PLANT_SITE_ID VARCHAR2(30 CHAR);
    L_DIO           NUMBER;

    CURSOR C_ESSVMI IS
        SELECT DISTINCT A.V_DIVISION_ID
                      , A.V_SCM_SITE_ID
                      , A.V_PROJECT_CODE
                      , A.V_ITEM_ID
                      , A.V_DOM_EXP
                      , A.V_FCST_TYPE
                      , A.V_INCOTERMS
                      , A.V_PLANT_SITE_ID
                      , CASE WHEN REGEXP_LIKE(TRIM(NVL(C.INVENTORY_DAY, 'x')), '^[0-9]+$') THEN TO_NUMBER(C.INVENTORY_DAY) ELSE 0 END AS V_DIO
          FROM GT_EVMI_RESULTS   A
             , SCM_MST_SITE       B
             , SCM_MST_SITE_ITEM  C
         WHERE A.V_DIVISION_ID = B.DIVISION_ID
           AND A.V_SCM_SITE_ID = B.SCM_SITE_ID
           AND A.V_DIVISION_ID = C.DIVISION_ID
           AND A.V_SCM_SITE_ID = C.SCM_SITE_ID
           AND A.V_ITEM_ID     = C.ITEM_ID
           AND A.V_PROJECT_CODE = C.PROJECT_CODE
           AND B.VMI_YN        = 'Y'
           AND A.V_DIVISION_ID = '82';
BEGIN
    V_LOG_TYPE := 'START'; V_LOG_MESSAGE := '########## Start of procedure ##########'; V_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        DELETE
          FROM GT_EVMI_RESULTS;

        V_MONDAY   := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
        V_BINV_DAY := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 8, 'YYYYMMDD');

        /* 대상 선정 (VMI SITE, 계획구간 MKT FCST 있는 모든 건) */
        INSERT
          INTO GT_EVMI_RESULTS
             ( V_DIVISION_ID
             , V_PROJECT_CODE
             , V_SCM_SITE_ID
             , V_ITEM_ID
             , V_DOM_EXP
             , V_FCST_TYPE
             , V_INCOTERMS
             , V_PLANT_SITE_ID )
        SELECT DISTINCT A.DIVISION_ID
                      , A.PROJECT_CODE
                      , A.SCM_SITE_ID
                      , A.ITEM_ID
                      , A.DOM_EXP
                      , A.FCST_TYPE
                      , A.INCOTERMS
                      , A.PLANT_SITE_ID
          FROM DM_PLN_MKT_FCST  A
             , SCM_MST_SITE      B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.SCM_SITE_ID = B.SCM_SITE_ID
           AND A.DIVISION_ID = '82'
           AND A.MEASURE     = 'MKT_FCST'
           AND A.YYYYMMDD   >= V_MONDAY
           AND A.QTY        <> 0;

        OPEN C_ESSVMI;
        LOOP
            FETCH C_ESSVMI INTO L_DIVISION_ID, L_SCM_SITE_ID, L_PROJECT_CODE, L_ITEM_ID, L_DOM_EXP, L_FCST_TYPE, L_INCOTERMS, L_PLANT_SITE_ID, L_DIO;
            EXIT WHEN C_ESSVMI%NOTFOUND;

            /* 기초재고 */
            SELECT NVL(MAX(QTY), 0)
              INTO V_EV_BINV
              FROM DM_PLN_MKT_FCST_RESULT A
             WHERE A.DIVISION_ID      = '82'
               AND A.MEASURE          = 'VMI_Inv'
               AND A.YYYYMMDD         = V_BINV_DAY
               AND A.SCM_SITE_ID      = L_SCM_SITE_ID
               AND A.PROJECT_CODE     = L_PROJECT_CODE
               AND A.ITEM_ID          = L_ITEM_ID
               AND A.DOM_EXP          = L_DOM_EXP
               AND A.FCST_TYPE        = L_FCST_TYPE
               AND A.INCOTERMS        = L_INCOTERMS
               AND A.PLANT_SITE_ID    = L_PLANT_SITE_ID
               AND A.CELL_PROD_SITE_ID = '-';

            /* 미래구간 VMI_In_Req 삭제 */
            DELETE
              FROM DM_PLN_MKT_FCST A
             WHERE A.DIVISION_ID   = '82'
               AND A.MEASURE       = 'VMI_In_Req'
               AND A.YYYYMMDD     >= V_MONDAY
               AND A.SCM_SITE_ID   = L_SCM_SITE_ID
               AND A.PROJECT_CODE  = L_PROJECT_CODE
               AND A.ITEM_ID       = L_ITEM_ID
               AND A.DOM_EXP       = L_DOM_EXP
               AND A.FCST_TYPE     = L_FCST_TYPE
               AND A.INCOTERMS     = L_INCOTERMS
               AND A.PLANT_SITE_ID = L_PLANT_SITE_ID;


            INSERT
              INTO DM_PLN_MKT_FCST
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , YYYYMMDD
                 , PLANT_SITE_ID
                 , QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT X.DIVISION_ID
                 , X.PROJECT_CODE
                 , X.SCM_SITE_ID
                 , X.ITEM_ID
                 , X.DOM_EXP
                 , X.FCST_TYPE
                 , X.INCOTERMS
                 , 'VMI_In_Req'
                 , TO_CHAR(TO_DATE(X.YYYYMMDD, 'YYYYMMDD') - L_DIO, 'YYYYMMDD')
                 , X.PLANT_SITE_ID
                 , CASE WHEN ROW_NUM <= L_DIO THEN 0
                        WHEN ROW_NUM = L_DIO + 1 THEN CASE WHEN SUM_QTY > V_EV_BINV THEN SUM_QTY - V_EV_BINV ELSE 0 END
                        WHEN SUM_QTY > V_EV_BINV AND BF_SUM <= V_EV_BINV THEN SUM_QTY - V_EV_BINV
                        WHEN BF_SUM > V_EV_BINV THEN QTY
                        ELSE 0 END
                 , V_CREATED_BY
                 , SYSDATE
                 , V_CREATED_BY
                 , SYSDATE
              FROM ( SELECT A.DIVISION_ID
                          , A.PROJECT_CODE
                          , A.SCM_SITE_ID
                          , A.ITEM_ID
                          , A.DOM_EXP
                          , A.FCST_TYPE
                          , A.INCOTERMS
                          , A.YYYYMMDD
                          , A.PLANT_SITE_ID
                          , SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD ) AS SUM_QTY
                          , SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS BF_SUM
                          , A.QTY
                          , ROW_NUMBER() OVER ( ORDER BY A.YYYYMMDD ) AS ROW_NUM
                       FROM ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                   , 'MKT_FCST' AS MEASURE
                                   , NVL(B.QTY, 0) AS QTY
                                   , L_DIVISION_ID AS DIVISION_ID
                                   , L_SCM_SITE_ID AS SCM_SITE_ID
                                   , L_PROJECT_CODE AS PROJECT_CODE
                                   , L_ITEM_ID AS ITEM_ID
                                   , L_DOM_EXP AS DOM_EXP
                                   , L_FCST_TYPE AS FCST_TYPE
                                   , L_INCOTERMS AS INCOTERMS
                                   , L_PLANT_SITE_ID AS PLANT_SITE_ID
                                FROM SCM_SYS_CALENDAR_M  A
                                   , DM_PLN_MKT_FCST      B
                               WHERE A.BASIS_YYYYMMDD = B.YYYYMMDD(+)
                                 AND B.MEASURE(+)      = 'MKT_FCST'
                                 AND B.DIVISION_ID(+)  = '82'
                                 AND B.SCM_SITE_ID(+)  = L_SCM_SITE_ID
                                 AND B.PROJECT_CODE(+) = L_PROJECT_CODE
                                 AND B.ITEM_ID(+)      = L_ITEM_ID
                                 AND B.DOM_EXP(+)      = L_DOM_EXP
                                 AND B.FCST_TYPE(+)    = L_FCST_TYPE
                                 AND B.INCOTERMS(+)    = L_INCOTERMS
                                 AND B.PLANT_SITE_ID(+) = L_PLANT_SITE_ID
                                 AND A.BASIS_YYYYMMDD >= V_MONDAY
                                 AND A.BASIS_YYYYMMDD <= TO_CHAR(TO_DATE(V_MONDAY, 'YYYYMMDD') + (CASE WHEN L_DIO > 0 THEN L_DIO + 1 ELSE L_DIO + 10 END) + 7*84, 'YYYYMMDD')
                            ) A
                   ) X
             WHERE CASE WHEN ROW_NUM <= L_DIO THEN 0
                        WHEN ROW_NUM = L_DIO + 1 THEN CASE WHEN SUM_QTY > V_EV_BINV THEN SUM_QTY - V_EV_BINV ELSE 0 END
                        WHEN SUM_QTY > V_EV_BINV AND BF_SUM <= V_EV_BINV THEN SUM_QTY - V_EV_BINV
                        WHEN BF_SUM > V_EV_BINV THEN QTY
                        ELSE 0 END > 0;
        END LOOP;
        CLOSE C_ESSVMI;
    EXCEPTION
        WHEN OTHERS THEN
            V_LOG_TYPE := 'ERROR'; V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR : '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500); D_EVENT_DATE := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;

    V_LOG_TYPE := 'END'; V_LOG_MESSAGE := '########## END of procedure ##########'; V_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
END PR_DM_PLN_ESS_VMI_REFRESH;