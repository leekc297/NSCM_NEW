PROCEDURE           "PR_DM_ANL_MKT_PSI_DATA" 
/* ============================================================
 * Program ID   : PR_DM_ANL_MKT_PSI_DATA
 * Description  : 고객수요증감분석 데이터 기초값 생성 및 인터페이스 전송
 * 메인테이블
 *   DM_ANL_MKT_PSI
 *   DM_ANL_MKT_PSI_DETAIL
 *   XIF_DM_ANL_MKT_PSI_DW_S
 *   XIF_DM_ANL_MKT_PSI_DETAIL_DW_S
 * EXEC PR_DM_ANL_MKT_PSI_DATA
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2024.01.10    kcw3408        [개발요청] 고객수요증감분석_배치작업 신규(표준리포트/RPA팀 우혜라 요청)
 * 2024.02.08    kcw3408        XIF_DM_ANL_MKT_PSI_DETAIL_DW_S 테이블에 DEPT_NAME Sales Site Project Model 화면 ‘Team’칼럼 수정
 * 2024.06.19    kcw3408        Synonym 만들어서 변경  XIF_DM_ANL_MKT_PSI_DW_S_SN ,XIF_DM_ANL_MKT_PSI_DETAIL_DW_S_SN
 * 2024.10.16    KJJ            [PJ2024-50461] Team Mapping
 *                              => 운영과 개발이 내용이 달라서 운영의 스크립트로 작업
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
IS
    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME       VARCHAR2(150 CHAR) := 'PR_DM_ANL_MKT_PSI_DATA';
    V_LOG_TYPE           VARCHAR2(30 CHAR);       /* START/END/ERROR/... */
    N_LOG_COUNT          NUMBER(10)         := 0;
    V_LOG_MESSAGE        VARCHAR2(1000 CHAR);
    V_DESCRIPTION        VARCHAR2(500 CHAR);
    D_EVENT_DATE         DATE;
    N_DELETE_COUNT       NUMBER(10)         := 0;
    N_INSERT_COUNT       NUMBER(10)         := 0;
    V_CREATED_BY         VARCHAR2(150 CHAR) := 'SYS_PSI_DATA';

    V_0MONTH_TUESDAY     VARCHAR2(8 CHAR);        /* 당월의 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff */
    V_DELIMITER          VARCHAR2(1 CHAR);

    V_CNT                NUMBER(10)         := 0;
    V_CNT_PRE            NUMBER(10)         := 0;
    V_FROM_YYYYMMDD      VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD        VARCHAR2(8 CHAR);
    V_FROM_YYYYMMDD_R    VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD_R      VARCHAR2(8 CHAR);
BEGIN

    BEGIN

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY);

        DBMS_OUTPUT.PUT_LINE('A1--#TEMP_DATA ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        /* 테이블중복제거 */
        DELETE FROM GT_DAMP_DATA;

        BEGIN
            V_FROM_YYYYMMDD := SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, -12), 'YYYYMMDD'), 1, 6) || '01';
            /* V_TO_YYYYMMDD = 당월 말일 */
            V_TO_YYYYMMDD   := TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6) || '01', 'YYYYMMDD'), 1) - 1, 'YYYYMMDD');
        END;

        BEGIN
            /* YYYYMM  13개월 가져오기 */
            DELETE FROM GT_DAMP_SCM_SYS_CALENDAR_M;

            INSERT
              INTO GT_DAMP_SCM_SYS_CALENDAR_M
                 ( YYYYMM )
            SELECT DISTINCT BASIS_YYYYMM AS YYYYMM
              FROM SCM_SYS_CALENDAR_M A
             WHERE A.BASIS_YYYYMMDD >= V_FROM_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= V_TO_YYYYMMDD;

            /* 실적구간 / 계획구간 구분 */
            SELECT NVL(MAX(A.YYYYMMDD), TO_CHAR(TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD'))
                 , NVL(MAX(A.YYYYMMDD), V_TO_YYYYMMDD)
              INTO V_FROM_YYYYMMDD_R, V_TO_YYYYMMDD_R
              FROM DM_PLN_MKT_FCST_RESULT A
             WHERE 1 = 1
               AND A.DIVISION_ID LIKE '81%'
               AND A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
               AND A.YYYYMMDD >= V_FROM_YYYYMMDD
               AND A.YYYYMMDD <= V_TO_YYYYMMDD;
        END;

        /*
          대상추출(DM_ANL_MKT_PSI 에 없는건 추출(당월 ~ -12개월)
        */
        BEGIN
            INSERT
              INTO GT_DAMP_DATA
                 ( DIVISION_ID
                 , END_CUSTOMER
                 , PROJECT_CODE
                 , YYYYMM
                 , MEASURE )
            SELECT A.DIVISION_ID
                 , A.END_CUSTOMER
                 , A.PROJECT_CODE
                 , B.YYYYMM
                 , C.MEASURE
              FROM (SELECT A.DIVISION_ID
                         , A.END_CUSTOMER
                         , A.PROJECT_CODE
                      FROM (SELECT A.DIVISION_ID
                                 , C.END_CUSTOMER
                                 , A.PROJECT_CODE
                              FROM DM_PLN_MKT_FCST_RESULT A
                                 , SCM_MST_SITE_ITEM B
                                 , SCM_MST_SITE C
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL D
                             WHERE B.DIVISION_ID  = A.DIVISION_ID
                               AND B.PROJECT_CODE = A.PROJECT_CODE
                               AND B.SCM_SITE_ID  = A.SCM_SITE_ID
                               AND B.ITEM_ID      = A.ITEM_ID
                               AND B.DIVISION_ID  = C.DIVISION_ID
                               AND B.SCM_SITE_ID  = C.SCM_SITE_ID
                               AND D.SEGMENT1     = A.FCST_TYPE
                               AND D.LOOKUP_TYPE  = 'SALES_TYPE_CODE'
                               AND A.DIVISION_ID LIKE '81%'
                               AND A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
                               AND A.YYYYMMDD >= V_FROM_YYYYMMDD
                               AND A.YYYYMMDD <= V_TO_YYYYMMDD_R
                             GROUP BY A.DIVISION_ID
                                    , C.END_CUSTOMER
                                    , A.PROJECT_CODE
                            UNION ALL
                            SELECT A.DIVISION_ID
                                 , C.END_CUSTOMER
                                 , A.PROJECT_CODE
                              FROM DM_PLN_MKT_FCST A
                                 , SCM_MST_SITE_ITEM B
                                 , SCM_MST_SITE C
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL D
                             WHERE B.DIVISION_ID  = A.DIVISION_ID
                               AND B.PROJECT_CODE = A.PROJECT_CODE
                               AND B.SCM_SITE_ID  = A.SCM_SITE_ID
                               AND B.ITEM_ID      = A.ITEM_ID
                               AND B.DIVISION_ID  = C.DIVISION_ID
                               AND B.SCM_SITE_ID  = C.SCM_SITE_ID
                               AND D.SEGMENT1     = A.FCST_TYPE
                               AND D.LOOKUP_TYPE  = 'SALES_TYPE_CODE'
                               AND A.DIVISION_ID LIKE '81%'
                               AND A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
                               AND A.YYYYMMDD >  V_FROM_YYYYMMDD_R
                               AND A.YYYYMMDD <= V_TO_YYYYMMDD
                             GROUP BY A.DIVISION_ID
                                    , C.END_CUSTOMER
                                    , A.PROJECT_CODE
                           ) A
                     GROUP BY A.DIVISION_ID
                            , A.END_CUSTOMER
                            , A.PROJECT_CODE
                   ) A
                 , GT_DAMP_SCM_SYS_CALENDAR_M B
                 , (SELECT 'AN_RESULT' AS MEASURE FROM DUAL UNION ALL
                    SELECT 'AN_LOGIC'  AS MEASURE FROM DUAL UNION ALL
                    SELECT 'DP_INIT'   AS MEASURE FROM DUAL UNION ALL
                    SELECT 'DP_RESULT' AS MEASURE FROM DUAL
                   ) C
                 , (SELECT A.DIVISION_ID
                         , A.PROJECT_CODE
                         , A.END_CUSTOMER
                         , A.YYYYMM
                      FROM DM_ANL_MKT_PSI A
                         , GT_DAMP_SCM_SYS_CALENDAR_M B
                     WHERE A.YYYYMM = B.YYYYMM
                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.YYYYMM
                   ) D
             WHERE A.DIVISION_ID  = D.DIVISION_ID(+)
               AND A.END_CUSTOMER = D.END_CUSTOMER(+)
               AND A.PROJECT_CODE = D.PROJECT_CODE(+)
               AND B.YYYYMM       = D.YYYYMM(+)
               AND D.YYYYMM IS NULL;
        END;

        DBMS_OUTPUT.PUT_LINE('A2--DM_ANL_MKT_PSI INSERT ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        /*
          DM_ANL_MKT_PSI 저장
        */
        BEGIN
            INSERT
              INTO DM_ANL_MKT_PSI
                 ( DIVISION_ID
                 , END_CUSTOMER
                 , PROJECT_CODE
                 , YYYYMM
                 , CUST_FCST_M
                 , MEASURE
                 , P_VALUE
                 , S_VALUE
                 , I_VALUE
                 , V_VALUE
                 , M_VALUE
                 , MKT_FCST_M
                 , CUST_FCST_M_CELL
                 , P_VALUE_CELL
                 , S_VALUE_CELL
                 , I_VALUE_CELL
                 , V_VALUE_CELL
                 , M_VALUE_CELL
                 , MKT_FCST_M_CELL
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , CP_VALUE
                 , CP_VALUE_CELL )
            SELECT A.DIVISION_ID
                 , A.END_CUSTOMER
                 , A.PROJECT_CODE
                 , A.YYYYMM
                 , 0 AS CUST_FCST_M
                 , A.MEASURE
                 , 0 AS P_VALUE
                 , 0 AS S_VALUE
                 , 0 AS I_VALUE
                 , 0 AS V_VALUE
                 , 0 AS M_VALUE
                 , 0 AS MKT_FCST_M
                 , 0 AS CUST_FCST_M_CELL
                 , 0 AS P_VALUE_CELL
                 , 0 AS S_VALUE_CELL
                 , 0 AS I_VALUE_CELL
                 , 0 AS V_VALUE_CELL
                 , 0 AS M_VALUE_CELL
                 , 0 AS MKT_FCST_M_CELL
                 , 'BATCH SYSTEM' AS CREATED_BY
                 , SYSDATE AS CREATION_DATE
                 , 'BATCH SYSTEM' AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , 0 AS CP_VALUE
                 , 0 AS CP_VALUE_CELL
              FROM GT_DAMP_DATA A;
        END;

        DBMS_OUTPUT.PUT_LINE('A3-- PROJECT TRANSLATOR ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        /*
           환산자 추출
        */
        BEGIN
            DELETE FROM GT_DAMP_PROJECT_TRANSLATOR;

            INSERT
              INTO GT_DAMP_PROJECT_TRANSLATOR
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , ITEM_ID
                 , BIZ_TYPE
                 , TRANSLATOR )
            SELECT A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.BIZ_TYPE
                 , B.CELL_CF AS TRANSLATOR
              FROM (SELECT A.DIVISION_ID
                         , A.PROJECT_CODE
                         , A.ITEM_ID
                         , CASE WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'AP' THEN 'PACK'
                                WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'AM' THEN 'MODULE'
                                WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'AC' THEN 'CELL'
                           END BIZ_TYPE
                         , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE ORDER BY A.DIVISION_ID, A.PROJECT_CODE, SUBSTR(A.ITEM_ID, 2, 1) DESC) AS RNK
                      FROM (SELECT A.DIVISION_ID
                                 , A.PROJECT_CODE
                                 , B.ITEM_ID
                              FROM (SELECT DISTINCT DIVISION_ID, PROJECT_CODE
                                      FROM DM_ANL_MKT_PSI_DETAIL
                                   ) A
                                 , (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID
                                      FROM SCM_MST_SITE_ITEM A
                                         , DM_MST_ITEM_SINGLE_V B
                                     WHERE A.DIVISION_ID = B.DIVISION_ID
                                       AND A.ITEM_ID     = B.ITEM_ID
                                       AND A.DIVISION_ID LIKE '81%'
                                       AND A.VALID_YN = 'Y'
                                       AND B.ITEM_TYPE = 'P'
                                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID
                                   ) B
                             WHERE A.DIVISION_ID  = B.DIVISION_ID
                               AND A.PROJECT_CODE = B.PROJECT_CODE
                           ) A
                   ) A
                 , SCP_MST_FINAL_ITEM B
             WHERE A.ITEM_ID     = B.ITEM_ID
               AND A.DIVISION_ID = B.DIVISION_ID
               AND A.RNK = 1;
        END;

        DBMS_OUTPUT.PUT_LINE('A4-- DM_ANL_MKT_PSI UPDATE(DM_ANL_MKT_PSI_DETAIL SUM) ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        /*
           DM_ANL_MKT_PSI_DETAIL 입력값 반영
        */
        BEGIN
            MERGE INTO DM_ANL_MKT_PSI A
            USING (SELECT A.DIVISION_ID
                        , A.END_CUSTOMER
                        , A.PROJECT_CODE
                        , A.YYYYMM
                        , A.CUST_FCST_M
                        , A.MEASURE
                        , NVL(CEIL(A.P_VALUE), 0) AS P_VALUE
                        , NVL(CEIL(A.S_VALUE), 0) AS S_VALUE
                        , NVL(CEIL(A.I_VALUE), 0) AS I_VALUE
                        , NVL(CEIL(A.V_VALUE), 0) AS V_VALUE
                        , NVL(CEIL(A.M_VALUE), 0) AS M_VALUE
                        , CASE WHEN A.MEASURE = 'DP_RESULT'
                               THEN NVL(CEIL(A.MKT_FCST_M), 0)
                               ELSE NVL(CEIL(A.CUST_FCST_M - (CEIL(A.P_VALUE) + CEIL(A.S_VALUE) + CEIL(A.I_VALUE) + CEIL(A.V_VALUE) + CEIL(A.M_VALUE) + CEIL(A.CP_VALUE))), 0)
                          END  AS  MKT_FCST_M
                        , A.CUST_FCST_M * NVL(B.TRANSLATOR, 0) AS CUST_FCST_M_CELL
                        , NVL(CEIL(A.P_VALUE * NVL(B.TRANSLATOR, 0)), 0) AS P_VALUE_CELL
                        , NVL(CEIL(A.S_VALUE * NVL(B.TRANSLATOR, 0)), 0) AS S_VALUE_CELL
                        , NVL(CEIL(A.I_VALUE * NVL(B.TRANSLATOR, 0)), 0) AS I_VALUE_CELL
                        , NVL(CEIL(A.V_VALUE * NVL(B.TRANSLATOR, 0)), 0) AS V_VALUE_CELL
                        , NVL(CEIL(A.M_VALUE * NVL(B.TRANSLATOR, 0)), 0) AS M_VALUE_CELL
                        , CASE WHEN A.MEASURE = 'DP_RESULT'
                               THEN NVL(CEIL(A.MKT_FCST_M * NVL(B.TRANSLATOR, 0)), 0)
                               ELSE NVL(CEIL(CEIL(A.CUST_FCST_M - (CEIL(A.P_VALUE) + CEIL(A.S_VALUE) + CEIL(A.I_VALUE) + CEIL(A.V_VALUE) + CEIL(A.M_VALUE) + CEIL(A.CP_VALUE))) * NVL(B.TRANSLATOR, 0)), 0)
                          END  AS  MKT_FCST_M_CELL
                        , NVL(CEIL(A.CP_VALUE), 0)  AS CP_VALUE
                        , NVL(CEIL(A.CP_VALUE * NVL(B.TRANSLATOR, 0)), 0) AS CP_VALUE_CELL
                     FROM (SELECT DIVISION_ID
                                , END_CUSTOMER
                                , PROJECT_CODE
                                , YYYYMM
                                , CUST_FCST_M
                                , MEASURE
                                , MKT_FCST_M
                                , NVL(SUM(CASE WHEN QTYCD3 = 'PRODUCT'     THEN QTY END), 0) AS P_VALUE
                                , NVL(SUM(CASE WHEN QTYCD3 = 'SALES'       THEN QTY END), 0) AS S_VALUE
                                , NVL(SUM(CASE WHEN QTYCD3 = 'INVENTORY'   THEN QTY END), 0) AS I_VALUE
                                , NVL(SUM(CASE WHEN QTYCD3 = 'VPA'         THEN QTY END), 0) AS V_VALUE
                                , NVL(SUM(CASE WHEN QTYCD3 = 'MODELMIX'    THEN QTY END), 0) AS M_VALUE
                                , NVL(SUM(CASE WHEN QTYCD3 = 'SUPPLYISSUE' THEN QTY END), 0) AS CP_VALUE
                             FROM DM_ANL_MKT_PSI_DETAIL
                            WHERE 1 = 1
                              AND YYYYMM >= SUBSTR(V_FROM_YYYYMMDD, 1, 6)
                            GROUP BY DIVISION_ID
                                , END_CUSTOMER
                                , PROJECT_CODE
                                , YYYYMM
                                , CUST_FCST_M
                                , MEASURE
                                , MKT_FCST_M
                          ) A
                        , GT_DAMP_PROJECT_TRANSLATOR B
                    WHERE B.DIVISION_ID  = A.DIVISION_ID
                      AND B.PROJECT_CODE = A.PROJECT_CODE
                  ) B
            ON ( B.DIVISION_ID  = A.DIVISION_ID
             AND B.PROJECT_CODE = A.PROJECT_CODE
             AND B.END_CUSTOMER = A.END_CUSTOMER
             AND B.YYYYMM       = A.YYYYMM
             AND B.MEASURE      = A.MEASURE )
            WHEN MATCHED THEN UPDATE SET
                  A.P_VALUE       = B.P_VALUE
                , A.S_VALUE       = B.S_VALUE
                , A.I_VALUE       = B.I_VALUE
                , A.V_VALUE       = B.V_VALUE
                , A.M_VALUE       = B.M_VALUE
                , A.CP_VALUE      = B.CP_VALUE
                , A.P_VALUE_CELL  = B.P_VALUE_CELL
                , A.S_VALUE_CELL  = B.S_VALUE_CELL
                , A.I_VALUE_CELL  = B.I_VALUE_CELL
                , A.V_VALUE_CELL  = B.V_VALUE_CELL
                , A.M_VALUE_CELL  = B.M_VALUE_CELL
                , A.CP_VALUE_CELL = B.CP_VALUE_CELL
                , A.MKT_FCST_M    = B.MKT_FCST_M
                , A.CUST_FCST_M   = B.CUST_FCST_M
                , A.LAST_UPDATED_BY  = 'BATCH SYSTEM'
                , A.LAST_UPDATE_DATE = SYSDATE
             WHERE (A.P_VALUE + A.S_VALUE + A.I_VALUE + A.V_VALUE + A.M_VALUE + A.CP_VALUE) = 0
               AND (A.P_VALUE + A.S_VALUE + A.I_VALUE + A.V_VALUE + A.M_VALUE + A.CP_VALUE) <> (B.P_VALUE + B.S_VALUE + B.I_VALUE + B.V_VALUE + B.M_VALUE + B.CP_VALUE);
        END;

        DBMS_OUTPUT.PUT_LINE('A5--DP_RESULT(Demand Plan (final)) ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        /*
           DP_RESULT(Demand Plan (final)) ⓓMKT.FCST (DP) 에 MKTFCST 화면에 월 MKT FCST[R+P] Measure실적과 동일하게 관리
        */
        BEGIN

            /* SCM_MST_SITE 대상건만 추출 */
            BEGIN
                DELETE FROM GT_DAMP_SCM_MST_SITE;

                INSERT
                  INTO GT_DAMP_SCM_MST_SITE
                     ( DIVISION_ID
                     , SCM_SITE_ID
                     , END_CUSTOMER )
                SELECT DIVISION_ID
                     , SCM_SITE_ID
                     , END_CUSTOMER
                  FROM SCM_MST_SITE
                 WHERE DIVISION_ID LIKE '81%';
            END;

            MERGE INTO DM_ANL_MKT_PSI A
            USING (SELECT A.DIVISION_ID
                        , C.END_CUSTOMER
                        , A.PROJECT_CODE
                        , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
                        , NVL(CEIL(SUM(A.QTY)), 0) AS A_QTY
                     FROM DM_PLN_MKT_FCST_RESULT A
                        , SCM_MST_SITE_ITEM B
                        , GT_DAMP_SCM_MST_SITE C
                        , SCM_ADM_LOOKUP_MASTER_DETAIL D
                    WHERE B.DIVISION_ID  = A.DIVISION_ID
                      AND B.PROJECT_CODE = A.PROJECT_CODE
                      AND B.SCM_SITE_ID  = A.SCM_SITE_ID
                      AND B.ITEM_ID      = A.ITEM_ID
                      AND B.DIVISION_ID  = C.DIVISION_ID
                      AND B.SCM_SITE_ID  = C.SCM_SITE_ID
                      AND D.SEGMENT1     = A.FCST_TYPE
                      AND D.LOOKUP_TYPE  = 'SALES_TYPE_CODE'
                      AND A.DIVISION_ID LIKE '81%'
                      AND A.MEASURE = 'RTF_SYS_RP'
                      AND A.YYYYMMDD >= V_FROM_YYYYMMDD
                      AND SUBSTR(A.YYYYMMDD, 1, 6) <= TO_CHAR(ADD_MONTHS(TO_DATE(V_TO_YYYYMMDD, 'YYYYMMDD'), -1), 'YYYYMM')
                    GROUP BY A.DIVISION_ID
                        , C.END_CUSTOMER
                        , A.PROJECT_CODE
                        , SUBSTR(A.YYYYMMDD, 1, 6)
                  ) B
            ON ( B.DIVISION_ID  = A.DIVISION_ID
             AND B.PROJECT_CODE = A.PROJECT_CODE
             AND B.END_CUSTOMER = A.END_CUSTOMER
             AND B.YYYYMM       = A.YYYYMM
             AND A.MEASURE      = 'DP_RESULT' )
            WHEN MATCHED THEN UPDATE SET
                  A.MKT_FCST_M       = B.A_QTY
                , A.LAST_UPDATED_BY  = 'BATCH SYSTEM'
                , A.LAST_UPDATE_DATE = SYSDATE
             WHERE A.MKT_FCST_M <> B.A_QTY;

        END;

        /*
           CUST_FCST_M 작업
        */
        BEGIN
            DELETE FROM GT_DAMP_EDI_END_CUSTOMER;

            INSERT
              INTO GT_DAMP_EDI_END_CUSTOMER
                 ( DIVISION_ID
                 , END_CUSTOMER
                 , SCM_SITE_ID
                 , FROM_WEEK
                 , FROM_DAY
                 , TO_WEEK
                 , TO_DAY
                 , ACTIVE )
            SELECT A.DIVISION_ID AS DIVISION_ID
                 , A.END_CUSTOMER AS END_CUSTOMER
                 , NVL(NULLIF(RTRIM(B.SEGMENT4),''), '/') AS SCM_SITE_ID
                 , (CASE WHEN NVL(B.SEGMENT5, 'OFF') = 'OFF' THEN
                                      '-52'
                            ELSE NVL(B.ATTRIBUTE1, '-1')  END) AS FROM_WEEK
                 , NVL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
                 , NVL(B.ATTRIBUTE3, '0') AS TO_WEEK
                 , NVL(B.ATTRIBUTE4, 'MON') AS TO_DAY
                 , NVL(B.SEGMENT5, 'OFF') AS ACTIVE
              FROM SCM_MST_SITE A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
             WHERE B.LOOKUP_TYPE(+) = 'EDI_END_CUSTOMER'
               AND A.DIVISION_ID = B.SEGMENT1(+)
               AND A.END_CUSTOMER = B.SEGMENT2(+)
               AND B.VALID_YN(+) = 'Y'
               AND RTRIM(A.END_CUSTOMER) IS NOT NULL
             GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

            MERGE INTO DM_ANL_MKT_PSI A
            USING (SELECT A.DIVISION_ID
                        , A.END_CUSTOMER
                        , A.PROJECT_CODE
                        , A.YYYYMM
                        , NVL(SUM(B.QTY), 0) AS QTY
                     FROM (SELECT B.YYYYMM, A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE
                             FROM (SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
                                     FROM DM_PLN_MKT_FCST A
                                        , SCM_MST_SITE B
                                    WHERE A.DIVISION_ID = B.DIVISION_ID
                                      AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                      AND B.VALID_YN = 'Y'
                                      AND B.END_CUSTOMER IS NOT NULL
                                      AND A.DIVISION_ID LIKE '81%'
                                      AND RTRIM(A.PROJECT_CODE) IS NOT NULL
                                      AND A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
                                      AND A.YYYYMMDD >= V_FROM_YYYYMMDD
                                      AND A.YYYYMMDD <= V_TO_YYYYMMDD
                                    GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
                                  ) A , GT_DAMP_SCM_SYS_CALENDAR_M B
                          ) A
                        , (
                           /*                            *  ① SCM_MST_SITE C 아우터조인 ON절이 CASE식(RTRIM(CASE...C.END_CUSTOMER...) IS NOT NULL)에 C(널생성측) 참조 → (+)불가(ORA-30563 부류) */
                           SELECT A.DIVISION_ID, A.PROJECT_CODE, C.END_CUSTOMER, SUBSTR(A.YYYYMMDD, 1, 6) YYYYMM, SUM(A.QTY) QTY
                             FROM DM_PLN_MKT_FCST_RESULT A
                                  INNER JOIN
                                  SCM_MST_SITE_ITEM B
                                    ON A.DIVISION_ID = B.DIVISION_ID
                                   AND A.PROJECT_CODE = B.PROJECT_CODE
                                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                   AND A.ITEM_ID = B.ITEM_ID
                                   LEFT OUTER JOIN SCM_MST_SITE C
                                       ON A.DIVISION_ID = C.DIVISION_ID
                                      AND A.SCM_SITE_ID = C.SCM_SITE_ID
                                      AND C.SITE_TYPE = 'SALES'
                                      AND C.VALID_YN = 'Y'
                                      AND RTRIM(CASE WHEN A.DIVISION_ID = '40' THEN NVL(C.END_CUSTOMER, '-')
                                                     ELSE REPLACE(C.END_CUSTOMER, '-', '') END) IS NOT NULL
                                   LEFT OUTER JOIN GT_DAMP_EDI_END_CUSTOMER D
                                       ON D.DIVISION_ID = A.DIVISION_ID
                                      AND D.END_CUSTOMER = C.END_CUSTOMER
                                      AND D.SCM_SITE_ID = A.SCM_SITE_ID
                                   LEFT OUTER JOIN GT_DAMP_EDI_END_CUSTOMER E
                                       ON A.DIVISION_ID = E.DIVISION_ID
                                      AND E.END_CUSTOMER = C.END_CUSTOMER
                                      AND E.SCM_SITE_ID = NVL(D.SCM_SITE_ID, '/')
                                   WHERE 1 = 1
                                   AND A.QTY <> 0
                                   AND A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
                                   AND NVL(A.ATTRIBUTE9, '99999999') >= (SELECT BASIS_YYYYMMDD
                                                       FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK
                                                                           , A.BASIS_YYYYMMDD
                                                               FROM SCM_SYS_CALENDAR_M A
                                                               WHERE BASIS_YYYYMMDD <= (CASE WHEN TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=AMERICAN') = 'MON' THEN
                                                                                               TO_CHAR(SYSDATE - 1, 'YYYYMMDD')
                                                                                        ELSE TO_CHAR(SYSDATE, 'YYYYMMDD') END)
                                                               AND DAYOFWEEK = E.FROM_DAY) A
                                                       WHERE A.RK = E.FROM_WEEK)
                                   AND NVL(A.ATTRIBUTE9, '19999999') <= (SELECT BASIS_YYYYMMDD
                                                       FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD) - 2
                                                                          ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD) - 1 END) AS RK
                                                                           , A.BASIS_YYYYMMDD
                                                               FROM SCM_SYS_CALENDAR_M A
                                                               WHERE BASIS_YYYYMMDD >= (CASE WHEN TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=AMERICAN') = 'MON' THEN
                                                                                               TO_CHAR(SYSDATE - 1, 'YYYYMMDD')
                                                                                        ELSE TO_CHAR(SYSDATE, 'YYYYMMDD') END)
                                                               AND DAYOFWEEK = E.TO_DAY) A
                                                       WHERE A.RK = E.TO_WEEK)
                                   AND A.YYYYMMDD >= V_FROM_YYYYMMDD
                                   AND A.YYYYMMDD <= V_TO_YYYYMMDD
                                   AND A.DIVISION_ID LIKE '81%'
                                   GROUP BY A.DIVISION_ID, A.PROJECT_CODE, C.END_CUSTOMER, SUBSTR(A.YYYYMMDD, 1, 6)
                          ) B
                    WHERE A.DIVISION_ID  = B.DIVISION_ID(+)
                      AND A.END_CUSTOMER = B.END_CUSTOMER(+)
                      AND A.PROJECT_CODE = B.PROJECT_CODE(+)
                      AND A.YYYYMM       = B.YYYYMM(+)
                    GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.YYYYMM
                  ) B
            ON ( B.DIVISION_ID  = A.DIVISION_ID
             AND B.PROJECT_CODE = A.PROJECT_CODE
             AND B.END_CUSTOMER = A.END_CUSTOMER
             AND B.YYYYMM       = A.YYYYMM )
            WHEN MATCHED THEN UPDATE SET
                  A.CUST_FCST_M      = B.QTY
                , A.LAST_UPDATED_BY  = 'BATCH SYSTEM'
                , A.LAST_UPDATE_DATE = SYSDATE
             WHERE A.CUST_FCST_M <> B.QTY;

        END;

        DBMS_OUTPUT.PUT_LINE('A6-- DM_ANL_MKT_PSI_DETAIL INSERT ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        /*
           DM_ANL_MKT_PSI_DETAIL 키 생성
        */
        BEGIN
            INSERT
              INTO DM_ANL_MKT_PSI_DETAIL
                 ( DIVISION_ID
                 , END_CUSTOMER
                 , PROJECT_CODE
                 , YYYYMM
                 , CUST_FCST_M
                 , MEASURE
                 , QTYCD1
                 , QTYCD2
                 , QTYCD3
                 , SEQ
                 , QTY
                 , MKT_FCST_M
                 , "DESC"
                 , INPUT_LIMIT
                 , CUST_FCST_M_CELL
                 , QTY_CELL
                 , MKT_FCST_M_CELL
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT A.DIVISION_ID
                 , A.END_CUSTOMER
                 , A.PROJECT_CODE
                 , A.YYYYMM
                 , NVL(A.CUST_FCST_M, 0)
                 , A.MEASURE
                 , ' ' AS QTYCD1
                 , ' ' AS QTYCD2
                 , ' ' AS QTYCD3
                 , 1  AS SEQ
                 , 0  AS QTY
                 , NVL(A.MKT_FCST_M, 0)
                 , '' AS "DESC"
                 , '' AS INPUT_LIMIT
                 , NVL(A.CUST_FCST_M_CELL, 0)
                 , 0  AS QTY_CELL
                 , NVL(A.MKT_FCST_M_CELL, 0)
                 , 'BATCH SYSTEM' AS CREATED_BY
                 , SYSDATE AS CREATION_DATE
                 , 'BATCH SYSTEM' AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
              FROM DM_ANL_MKT_PSI A
                 , GT_DAMP_SCM_SYS_CALENDAR_M B
                 , (SELECT A.DIVISION_ID
                         , A.PROJECT_CODE
                         , A.END_CUSTOMER
                         , A.YYYYMM
                         , A.MEASURE
                      FROM DM_ANL_MKT_PSI_DETAIL A
                         , GT_DAMP_SCM_SYS_CALENDAR_M B
                     WHERE A.YYYYMM = B.YYYYMM
                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.YYYYMM, A.MEASURE
                   ) C
             WHERE A.YYYYMM       = B.YYYYMM
               AND A.DIVISION_ID  = C.DIVISION_ID(+)
               AND A.END_CUSTOMER = C.END_CUSTOMER(+)
               AND A.PROJECT_CODE = C.PROJECT_CODE(+)
               AND A.YYYYMM       = C.YYYYMM(+)
               AND A.MEASURE      = C.MEASURE(+)
               AND A.MEASURE IN ('DP_INIT', 'DP_RESULT')
               AND C.YYYYMM IS NULL;
        END;

        DBMS_OUTPUT.PUT_LINE('A7-- PROJECT_DEPT ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        BEGIN
            /*
             2024.02.08    kcw3408        XIF_DM_ANL_MKT_PSI_DETAIL_DW_S 테이블에 DEPT_NAME Sales Site Project Model 화면 ‘Team’칼럼 수정
            */
            DELETE FROM GT_DAMP_PROJECT_DEPT;

            INSERT
              INTO GT_DAMP_PROJECT_DEPT
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , END_CUSTOMER
                 , ITEM_ID
                 , DEPT_ID
                 , DEPT_NAME_KO )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.ITEM_ID, A.DEPT_ID, A.DEPT_NAME_KO
              FROM (SELECT DISTINCT
                           A.DIVISION_ID
                         , A.PROJECT_CODE
                         , B.END_CUSTOMER
                         , A.ITEM_ID
                         /* [PJ2024-50461] Team Mapping ------------------------------------ */
                         /*, B.DEPT_ID
                         , C.DEPT_NAME_KO
                         */
--                         , C.DEPT_ID
--                         , C.DEPT_NAME_KO
                         , A.DEPT_ID                                        -- 2026.09.03 AJS
                         , D.DEPT_NAME_KO                                   -- 2026.09.03 AJS
                         /* [PJ2024-50461] Team Mapping ------------------------------------ */
                         , RANK() OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, B.END_CUSTOMER ORDER BY A.SCM_SITE_ID) AS SEQ
                      FROM SCM_MST_SITE_ITEM A
                         , SCM_MST_SITE B
                         /* [PJ2024-50461] Team Mapping ------------------------------------
                         JOIN SCM_MST_SSO_DEPT_INFO C
                             ON  B.DEPT_ID = C.DEPT_ID
                         */
                         , (SELECT A.USER_ID, A.USER_NAME, A.USER_NAME_EN, A.DEPT_ID, B.DEPT_NAME_KO
                              FROM SCM_MST_SSO_USER_INFO A
                                 , SCM_MST_SSO_DEPT_INFO B
                             WHERE A.DEPT_ID = B.DEPT_ID
                           ) C
                         , SCM_MST_SSO_DEPT_INFO D                          -- 2026.09.03 AJS
                     WHERE A.DIVISION_ID  = B.DIVISION_ID
                       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                       AND B.VALID_YN = 'Y'
                       AND UPPER(C.USER_ID(+)) = UPPER(FN_SCM_SPLIT(A.OWNER, 1, ','))
                       AND A.DEPT_ID = D.DEPT_ID(+)                         -- 2026.09.03 AJS
                       /* [PJ2024-50461] Team Mapping ------------------------------------ */
                       AND A.DIVISION_ID LIKE '81%'
                   ) A
             WHERE A.SEQ = 1;

        END;

        DBMS_OUTPUT.PUT_LINE('A8-- DP, CF 값 송출 기준 변경 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        /* DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------START */
        BEGIN
            DELETE FROM GT_DAMP_DM_MST_ITEM_SINGLE_V;

            INSERT
              INTO GT_DAMP_DM_MST_ITEM_SINGLE_V
                 ( DIVISION_ID
                 , ITEM_ID
                 , PROJECT_CODE )
            SELECT A.DIVISION_ID, A.ITEM_ID, B.PROJECT_CODE
              FROM DM_MST_ITEM_SINGLE_V A
                 , SCM_MST_PROJECT_ITEM B
             WHERE A.DIVISION_ID = B.DIVISION_ID
               AND A.ITEM_ID     = B.ITEM_ID
               AND A.DIVISION_ID LIKE '81%'
               AND B.VALID_YN = 'Y'
               AND A.ITEM_TYPE = 'P'
             GROUP BY A.DIVISION_ID, A.ITEM_ID, B.PROJECT_CODE;

        END;

        DBMS_OUTPUT.PUT_LINE('A9-- XIF_DM_ANL_MKT_PSI_DW_S INSERT ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        BEGIN /* I/F 테이블 INSERT */
            /* **중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV) --Synonym 만들어서 변경(kcw3408) XIF_DM_ANL_MKT_PSI_DW_S_SN */
            BEGIN /* I/F 테이블 해당 PROJECT 삭제 */
                DELETE
                  FROM XIF_DM_ANL_MKT_PSI_DW_S_SN;
            END;

            INSERT
              INTO XIF_DM_ANL_MKT_PSI_DW_S_SN
                 ( DIVISION_ID
                 , END_CUSTOMER
                 , PROJECT_CODE
                 , YYYYMM
                 , CUST_FCST_M
                 , MEASURE
                 , P_VALUE
                 , S_VALUE
                 , I_VALUE
                 , V_VALUE
                 , M_VALUE
                 , MKT_FCST_M
                 , "DESC"
                 , INPUT_LIMIT
                 , CUST_FCST_M_CELL
                 , P_VALUE_CELL
                 , S_VALUE_CELL
                 , I_VALUE_CELL
                 , V_VALUE_CELL
                 , M_VALUE_CELL
                 , MKT_FCST_M_CELL
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , CP_VALUE
                 , CP_VALUE_CELL )
            SELECT DIVISION_ID
                 , END_CUSTOMER
                 , PROJECT_CODE
                 , YYYYMM
                 , CUST_FCST_M
                 , MEASURE
                 , P_VALUE
                 , S_VALUE
                 , I_VALUE
                 , V_VALUE
                 , M_VALUE
                 , MKT_FCST_M
                 , "DESC"
                 , INPUT_LIMIT
                 , CUST_FCST_M_CELL
                 , P_VALUE_CELL
                 , S_VALUE_CELL
                 , I_VALUE_CELL
                 , V_VALUE_CELL
                 , M_VALUE_CELL
                 , MKT_FCST_M_CELL
                 , CREATED_BY
                 , SYSDATE
                 , LAST_UPDATED_BY
                 , SYSDATE
                 , CP_VALUE
                 , CP_VALUE_CELL
              FROM DM_ANL_MKT_PSI
             WHERE YYYYMM IN (SELECT YYYYMM FROM GT_DAMP_SCM_SYS_CALENDAR_M);
        END;

        DBMS_OUTPUT.PUT_LINE('A10-- XIF_DM_ANL_MKT_PSI_DETAIL_DW_S INSERT ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        BEGIN /* I/F 테이블 INSERT */
            /* **중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV)--Synonym 만들어서 변경(kcw3408) XIF_DM_ANL_MKT_PSI_DW_S_SN */
            BEGIN /* I/F 테이블 해당 PROJECT 삭제 */
                DELETE
                  FROM XIF_DM_ANL_MKT_PSI_DETAIL_DW_S_SN;
            END;

            BEGIN

                INSERT
                  INTO XIF_DM_ANL_MKT_PSI_DETAIL_DW_S_SN
                     ( DIVISION_ID
                     , DEPT_ID
                     , DEPT_NAME_KO
                     , PROJECT_NAME
                     , PROJECT_CODE
                     , ITEM_ID
                     , END_CUSTOMER
                     , YYYYMM
                     , CUST_FCST_M
                     , MEASURE
                     , QTYCD1
                     , QTYCD2
                     , QTYCD3
                     , SEQ
                     , QTY
                     , MKT_FCST_M
                     , "DESC"
                     , INPUT_LIMIT
                     , CUST_FCST_M_CELL
                     , QTY_CELL
                     , MKT_FCST_M_CELL
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE )
                SELECT A.DIVISION_ID
                     , NVL(NULLIF(RTRIM(C.DEPT_ID),''), '/')
                     , NVL(C.DEPT_NAME_KO, ' ')
                     , SUBSTR(NVL(E.PROJECT_NAME, '-'), 1, 100)
                     , A.PROJECT_CODE
                     , NVL(NULLIF(RTRIM(B.ITEM_ID),''), '/')
                     , A.END_CUSTOMER
                     , A.YYYYMM
                     , A.CUST_FCST_M
                     , A.MEASURE
                     , A.QTYCD1
                     , A.QTYCD2
                     , A.QTYCD3
                     , A.SEQ
                     , A.QTY
                     , A.MKT_FCST_M
                     , A."DESC"
                     , A.INPUT_LIMIT
                     , A.CUST_FCST_M * NVL(D.TRANSLATOR, 0) /* A.CUST_FCST_M_CELL */
                     , A.QTY * NVL(D.TRANSLATOR, 0) /* A.QTY_CELL */
                     , A.MKT_FCST_M * NVL(D.TRANSLATOR, 0) /* A.MKT_FCST_M_CELL */
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                  FROM DM_ANL_MKT_PSI_DETAIL A
                  LEFT OUTER JOIN GT_DAMP_DM_MST_ITEM_SINGLE_V B
                  ON A.DIVISION_ID = B.DIVISION_ID
                  AND A.PROJECT_CODE = B.PROJECT_CODE
                  LEFT OUTER JOIN GT_DAMP_PROJECT_DEPT C
                  ON A.DIVISION_ID = C.DIVISION_ID
                  AND A.PROJECT_CODE = C.PROJECT_CODE
                  AND A.END_CUSTOMER = C.END_CUSTOMER
                  AND B.ITEM_ID      = C.ITEM_ID
                  LEFT OUTER JOIN GT_DAMP_PROJECT_TRANSLATOR D
                  ON A.DIVISION_ID = D.DIVISION_ID
                 AND A.PROJECT_CODE = D.PROJECT_CODE
                  LEFT OUTER JOIN SCM_MST_PROJECT E
                  ON A.DIVISION_ID = E.DIVISION_ID
                  AND A.PROJECT_CODE = E.PROJECT_CODE
                 WHERE A.YYYYMM IN (SELECT YYYYMM FROM GT_DAMP_SCM_SYS_CALENDAR_M);

            END;
        END;

        DBMS_OUTPUT.PUT_LINE('A11-- COMMIT ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;

            /* ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                ,V_LOG_TYPE
                ,N_LOG_COUNT
                ,V_LOG_MESSAGE
                ,V_DESCRIPTION
                ,D_EVENT_DATE
                ,NULL
                ,SQLCODE
                ,SQLERRM
                ,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            DBMS_OUTPUT.PUT_LINE('A12-- ERROR ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || V_LOG_MESSAGE);

    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
        ,V_LOG_TYPE
        ,N_LOG_COUNT
        ,V_LOG_MESSAGE
        ,V_DESCRIPTION
        ,D_EVENT_DATE);

    DBMS_OUTPUT.PUT_LINE('A13-- END ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

END;