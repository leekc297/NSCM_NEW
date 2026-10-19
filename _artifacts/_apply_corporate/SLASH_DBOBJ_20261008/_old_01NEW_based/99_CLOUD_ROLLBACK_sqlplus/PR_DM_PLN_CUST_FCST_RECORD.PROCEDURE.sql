-- [E20261008-SLASHOBJ] PROCEDURE PR_DM_PLN_CUST_FCST_RECORD — 원복(사내 적용 전 원문)
CREATE OR REPLACE PROCEDURE         "PR_DM_PLN_CUST_FCST_RECORD" 
( 
      P_DIVISION_ID   IN VARCHAR2   /* division_id 전달받음 */
    , P_ACCEPT_FLAG   IN VARCHAR2   /* 업무구분(EDI, RPA) */
)
/* ============================================================
 * Program ID   : PR_DM_PLN_CUST_FCST_RECORD
 * Description  : EDI, CUST_FCST 데이터 HISTORY에 저장
 * Program History
 *------------------------------------------------------------
 *   Date         In Charge     Description
 *------------------------------------------------------------
 * 2023.04.11    chano0612      EDI, CUST_FCST 데이터 HISTORY에 저장
 * 2024.03.18    kcw3408        아래 속도 개선(DBA 정기훈 부장)
 * 2024.04.30    kcw3408        N:N Model Mapping_적재 추가(집계 시점에 Cust Item/Unloading Point/Plant 고려,Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음)
 * 2024.06.26    JSSBAE         [E20240620-001488]_SCM DM 고객수요분석- Cust Plant NULL인 데이터 처리로직 개선
 * 2025.01.20    KANG.H.J       [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 * 2025.03.18    JSSBAE         [E20250313-001202]_Customer Forecast Upload 데이터 오류 수정
 * 2025.10.31    JSSBAE         [E20251016-001453]_ERP NN Mapping 데이터 반영 수행시간 단축 및 로그 보완
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 *------------------------------------------------------------
 * [아래1] 20240315
 *  1.쿼리수정 - IDX_DM_DNM_EDI_CALLOFF_ITEM_N01 힌트추가
 *    FROM  DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK, INDEX(IDX_DM_DNM_EDI_CALLOFF_ITEM_N01))
 *  2.DM_DNM_EDI_CALLOFF_ITEM 테이블에 IFSEQNO를 선두컬럼으로 하는 인덱스 추가 (IDX_DM_DNM_EDI_CALLOFF_ITEM_N02)
 *  3.DM_PLN_CUST_FCST_H 테이블에 EDI_IF_SEQ를 선두컬럼으로 하는 인덱스 추가 (IDX_DM_PLN_CUST_FCST_H_N01)
 *  4.DM_PLN_CUST_FCST_H에 LAST_UPDATE_DATE 선두컬럼으로 하는 인덱스 추가 및 조건절 수정 (IDX_DM_PLN_CUST_FCST_H_N02)
 *
 *    EXEC PR_DM_PLN_CUST_FCST_RECORD '81', 'EDI'
 *    EXEC PR_DM_PLN_CUST_FCST_RECORD '81_UC', 'EDI'
 *    EXEC PR_DM_PLN_CUST_FCST_RECORD '81', 'RPA'
 *    EXEC PR_DM_PLN_CUST_FCST_RECORD '40', 'RPA'
 * ============================================================ */
IS
    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME     VARCHAR2(150 CHAR) := 'PR_DM_PLN_CUST_FCST_RECORD';
    V_LOG_TYPE         VARCHAR2(30 CHAR);        /* START/END/ERROR/... */
    N_LOG_COUNT        NUMBER(10)         := 0;
    V_LOG_MESSAGE      VARCHAR2(1000 CHAR);
    V_DESCRIPTION      VARCHAR2(500 CHAR);
    D_EVENT_DATE       DATE;

    V_DIVISION_ID      VARCHAR2(30 CHAR);
    V_IFSEQNO_INSERT   VARCHAR2(30 CHAR);
    V_ACCEPT_FLAG      VARCHAR2(10 CHAR);

    V_0WEEK_MONDAY     VARCHAR2(8 CHAR);   /* W0 월요일 */
    V_1WEEK_MONDAY     VARCHAR2(8 CHAR);   /* W1 월요일 */

    V_FROM_DATE        VARCHAR2(8 CHAR);

    V_CNT              NUMBER(10) := 0;
BEGIN

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := 'Div: ' || P_DIVISION_ID || '_' || P_ACCEPT_FLAG;
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    V_LOG_MESSAGE := NULL;      /*-- 변수 재사용을 위하여 초기화해야함 --*/

    BEGIN

        V_FROM_DATE    := TO_CHAR(TRUNC(SYSDATE) - 1, 'YYYYMMDD');
        V_0WEEK_MONDAY := TO_CHAR(FN_NEXT_DAY(TRUNC(SYSDATE), 'MON') - 7, 'YYYYMMDD');   /* W0월요일 */
        V_1WEEK_MONDAY := TO_CHAR(FN_NEXT_DAY(TRUNC(SYSDATE), 'MON'), 'YYYYMMDD');

        V_DIVISION_ID  := P_DIVISION_ID;
        V_ACCEPT_FLAG  := P_ACCEPT_FLAG;

        /* ******************** EDI DATA 생성 START ******************** */
        IF V_ACCEPT_FLAG = 'EDI' THEN

            DBMS_OUTPUT.PUT_LINE('EDI_01:' || V_ACCEPT_FLAG || ' ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

            /* 테이블중복제거 (tempdb../dbo.. 이중 DROP 은 Oracle 대응없음 → GTT 시작 DELETE 초기화) */
            DELETE
              FROM GT_PRDM_EDI_ALL;

            /* EDI STATUS_CODE가 SUCCESS인 DATA */
            INSERT
              INTO GT_PRDM_EDI_ALL ( NUM, IFSEQNO )
            SELECT ROW_NUMBER() OVER(ORDER BY A.IFSEQNO) AS NUM
                 , A.IFSEQNO
              FROM DM_DNM_EDI_CALLOFF_ITEM         A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL    B
             WHERE A.SENDER_CODE  = B.SEGMENT2(+)
               AND B.LOOKUP_TYPE(+) = 'EDI_SENDER_CODE'
               AND A.DIVISION_ID  = V_DIVISION_ID
               AND A.CREATE_DATE >= V_FROM_DATE
             GROUP BY A.IFSEQNO;

            DBMS_OUTPUT.PUT_LINE('EDI_02:' || V_ACCEPT_FLAG);

            SELECT COUNT(*)
              INTO V_CNT
              FROM GT_PRDM_EDI_ALL;
            DBMS_OUTPUT.PUT_LINE('EDI_04:' || V_CNT);

            IF V_CNT > 0 THEN

                /* 2024.03.19  kcw3408  DM 프로시저 속도개선: #TEMP_DM_MST_ITEM_SINGLE_V 테이블 변경 */
                DELETE
                  FROM GT_PRDM_DM_MST_ITEM_SINGLE_V;
                INSERT
                  INTO GT_PRDM_DM_MST_ITEM_SINGLE_V ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_TYPE )
                SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, A.ITEM_NAME, A.ITEM_TYPE
                  FROM (
                        SELECT T1.DIVISION_ID
                             , T1.ITEM_ID
                             , MAX(T1.ITEM_NAME)                                       AS ITEM_NAME   /* 해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일 */
                             , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1           /* 타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일 */
                                              WHEN T1.ITEM_TYPE = 'H' THEN 2           /* 또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함 */
                                              WHEN T1.ITEM_TYPE = 'Q' THEN 3
                                              ELSE 4 END )
                                    WHEN 1 THEN 'P'
                                    WHEN 2 THEN 'H'
                                    WHEN 3 THEN 'Q'
                                    ELSE 'R'
                               END                                                    AS ITEM_TYPE
                          FROM SCM_MST_ITEM_SN T1
                         WHERE T1.DIVISION_ID = V_DIVISION_ID
                           AND T1.ACTIVE_FLAG = 'Y'
                         GROUP BY T1.DIVISION_ID, T1.ITEM_ID
                       ) A
                 WHERE A.DIVISION_ID = V_DIVISION_ID;

                DELETE
                  FROM GT_PRDM_SCM_MST_SITE;
                INSERT
--                  INTO GT_PRDM_SCM_MST_SITE ( DIVISION_ID, SCM_SITE_ID, END_CUSTOMER, SOLDTO_CUSTOMER, VMI_YN, DEPT_ID, COUNTRY, CITY )
--                SELECT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER, SOLDTO_CUSTOMER, VMI_YN, DEPT_ID, COUNTRY, CITY
                  INTO GT_PRDM_SCM_MST_SITE ( DIVISION_ID, SCM_SITE_ID, END_CUSTOMER, SOLDTO_CUSTOMER, VMI_YN, COUNTRY, CITY )            -- 2026.09.03 AJS
                SELECT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER, SOLDTO_CUSTOMER, VMI_YN, COUNTRY, CITY                                     -- 2026.09.03 AJS
                  FROM SCM_MST_SITE
                 WHERE SITE_TYPE = 'SALES'
                   AND VALID_YN = 'Y'
                   AND DIVISION_ID = V_DIVISION_ID;

                DELETE
                  FROM GT_PRDM_SCM_MST_SITE_ITEM;
                INSERT
--                  INTO GT_PRDM_SCM_MST_SITE_ITEM ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PER_CAR, CELL_PER_MODULE, OWNER, ATTRIBUTE8 )
--                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PER_CAR, CELL_PER_MODULE, OWNER, ATTRIBUTE8
                  INTO GT_PRDM_SCM_MST_SITE_ITEM ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PER_CAR, CELL_PER_MODULE, OWNER, ATTRIBUTE8, DEPT_ID )   -- 2026.09.03 AJS
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PER_CAR, CELL_PER_MODULE, OWNER, ATTRIBUTE8, DEPT_ID                                 -- 2026.09.03 AJS
                  FROM SCM_MST_SITE_ITEM
                 WHERE VALID_YN = 'Y'
                   AND DIVISION_ID = V_DIVISION_ID;

                DELETE
                  FROM GT_PRDM_SCM_MST_PROJECT;
                INSERT
                  INTO GT_PRDM_SCM_MST_PROJECT ( DIVISION_ID, PROJECT_CODE, BIZ_TYPE, PROJECT_NAME, PROJECT_STATUS, PROJECT_OWNER )
                SELECT DIVISION_ID, PROJECT_CODE, BIZ_TYPE, PROJECT_NAME, PROJECT_STATUS, PROJECT_OWNER
                  FROM SCM_MST_PROJECT
                 WHERE DROP_YN = 'N'
                   AND DIVISION_ID = V_DIVISION_ID;

            END IF;

            /* [E20250313-001202]_Customer Forecast Upload 데이터 오류 수정 START
               한 SCM_SITE_ID기준으로 SOLDTO_CODE, SHIPTO_CODE가 다른건이 여러건 발생하여 MKT FCST와 동일한 형태로 수정 */
            DELETE
              FROM GT_PRDM_CUST_MODEL_MAP;
            INSERT
              INTO GT_PRDM_CUST_MODEL_MAP ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, PROJECT_CODE, FCST_TYPE, INCOTERMS, DOM_EXP, ITEM_ID, MAPPING_ITEM_ID
                                          , UNLOADING_POINT, CUSTOMER_PLANT, CUSTOMER_ITEM_ID, VALID_START_DATE, VALID_END_DATE )
            SELECT DISTINCT
                   A.DIVISION_ID
                 , A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE
                 , A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID, A.MAPPING_ITEM_ID
                 , NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), '-')
                 , NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), '-')
                 , NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)), '-')
                 , MAX(A.VALID_START_DATE), MAX(A.VALID_END_DATE)
              FROM DM_CUST_MODEL_MAPPING_M A
             WHERE A.ACTIVE_YN = 'Y'
             GROUP BY A.DIVISION_ID
                 , A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE
                 , A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID, A.MAPPING_ITEM_ID
                 , NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), '-')
                 , NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), '-')
                 , NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)), '-');
            /* [E20250313-001202]_Customer Forecast Upload 데이터 오류 수정 END */

            DBMS_OUTPUT.PUT_LINE('EDI_05:' || V_ACCEPT_FLAG);

            /* 테이블중복제거 (이중 DROP 무대응) */
            DELETE
              FROM GT_PRDM_EDI_CUST_FCST;
            DELETE
              FROM GT_PRDM_QTY_SUM;

            SELECT COUNT(*)
              INTO V_CNT
              FROM GT_PRDM_EDI_ALL;
            DBMS_OUTPUT.PUT_LINE('EDI_A:' || V_CNT);

            IF V_CNT > 0 THEN

                INSERT
                  INTO GT_PRDM_EDI_CUST_FCST (
                       EDI_IF_SEQ, SUB_NO, YYYYMMDD, DIVISION_ID, SCM_SITE_ID
                     , ITEM_ID, PROJECT_CODE
                     , ERP_FCST_TYPE
                     , BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID
                     , DOM_EXP
                     , COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, DOC_IDENTIFINER, MESSAGE_TYPE
                     , RDD_START, RDD_END, IFSEQNO, SCHEDULING_TYPE
                     , DELFOR_TYPE
                     , EDI_LT, CUST_MATERIAL_CODE, CREATE_DATE, SENDER_CODE, SENDER_NAME, CUSTOMER_PLANT, UNLOADING_POINT
                     , END_CUSTOMER
                     , NICK_NAME
                     , DEPT_NAME_KO
                     , TEAM_NAME_KO
                     , SOLDTO_CUSTOMER
                     , COUNTRY
                     , CITY, ITEM_NAME, ITEM_TYPE, OWNER, VMI_YN, BIZ_TYPE
                     , PROJECT_NAME, PROJECT_STATUS, PROJECT_OWNER
                     , CELL_PER_CAR, CELL_PER_MODULE
                     , MODULE_PER_CAR
                     , KWH_PER_CELL
                     , KWH_PER_MODULE
                     , KWH_PER_PACK )
                SELECT A.EDI_IF_SEQ, A.SUB_NO, A.YYYYMMDD, A.DIVISION_ID, A.SCM_SITE_ID
                     , A.ITEM_ID, A.PROJECT_CODE
                     , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END          AS ERP_FCST_TYPE
                     , A.BASIS_YYYYMMDD, A.QTY, A.EDI_INCOTERMS, A.SALES_PLANT_SITE_ID
                     , 'E'                                                                AS DOM_EXP
                     , A.COMPANY_ID, A.SOLDTO_CODE, A.SHIPTO_CODE, A.DOC_IDENTIFINER, A.MESSAGE_TYPE
                     , A.RDD_START, A.RDD_END, A.IFSEQNO, A.SCHEDULING_TYPE
                     , CASE WHEN A.MESSAGE_TYPE = 'DELFOR' AND A.SOLDTO_CODE = 'FR000064' AND A.RDD_START <> A.RDD_END AND A.RDD_START >= V_1WEEK_MONDAY THEN 'Periodic DELFOR'
                            ELSE ''
                       END                                                                AS DELFOR_TYPE
                     , A.EDI_LT, A.CUST_MATERIAL_CODE, A.CREATE_DATE, A.SENDER_CODE, A.SENDER_NAME, A.CUSTOMER_PLANT, A.UNLOADING_POINT
                     , C.END_CUSTOMER
                     , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)                     AS NICK_NAME
                     , E.DEPT_NAME_KO                                                     AS DEPT_NAME_KO
                     , F.DEPT_NAME_KO                                                     AS TEAM_NAME_KO
                     , C.SOLDTO_CUSTOMER
                     , G.COUNTRY, G.CITY, H.ITEM_NAME, H.ITEM_TYPE, D.OWNER, C.VMI_YN, I.BIZ_TYPE
                     , I.PROJECT_NAME, I.PROJECT_STATUS, I.PROJECT_OWNER
                     , D.CELL_PER_CAR, D.CELL_PER_MODULE
                     , CASE WHEN D.CELL_PER_MODULE <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE
                            ELSE 0
                       END                                                                AS MODULE_PER_CAR
                     , D.ATTRIBUTE8                                                       AS KWH_PER_CELL
                     , CASE WHEN (A.DIVISION_ID LIKE '81%' AND D.CELL_PER_MODULE > 0 AND NVL(D.ATTRIBUTE8, '''') <> '''') THEN (D.CELL_PER_MODULE * D.ATTRIBUTE8)
                            ELSE NULL
                       END                                                                AS KWH_PER_MODULE
                     , CASE WHEN (A.DIVISION_ID LIKE '81%' AND D.CELL_PER_CAR > 0 AND NVL(D.ATTRIBUTE8, '''') <> '''') THEN (D.CELL_PER_CAR * D.ATTRIBUTE8)
                            ELSE NULL
                       END                                                                AS KWH_PER_PACK
                  FROM ( /* 2024.04.29  kcw3408  고객수요 N:N Mapping. 전체 대상 추출후 N:N Model Mapping 작업. Valid Range 1~5 미포함 구간은 Calloff 미집계 */
                        SELECT X.EDI_IF_SEQ, X.SUB_NO, X.YYYYMMDD, X.DIVISION_ID, X.SCM_SITE_ID
                             , B.MAPPING_ITEM_ID AS ITEM_ID, X.PROJECT_CODE, X.ERP_FCST_TYPE
                             , X.BASIS_YYYYMMDD, X.QTY, X.EDI_INCOTERMS, X.SALES_PLANT_SITE_ID
                             , X.COMPANY_ID, X.SOLDTO_CODE, X.SHIPTO_CODE, X.DOC_IDENTIFINER, X.MESSAGE_TYPE
                             , X.RDD_START, X.RDD_END, X.IFSEQNO, X.SCHEDULING_TYPE
                             , X.EDI_LT
                             , NVL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), ' ') AS CUST_MATERIAL_CODE
                             , NVL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), ' ')     AS CUSTOMER_PLANT
                             , NVL(RTRIM(LTRIM(X.UNLOADING_POINT)), '-')    AS UNLOADING_POINT
                             , X.CREATE_DATE
                             , X.SENDER_CODE, X.SENDER_NAME
                          FROM DM_DNM_EDI_CALLOFF_ITEM  X
                             , GT_PRDM_CUST_MODEL_MAP   B
                         WHERE X.DIVISION_ID    = B.DIVISION_ID
                           AND X.SCM_SITE_ID    = B.SCM_SITE_ID
                           AND X.PROJECT_CODE   = B.PROJECT_CODE
                           AND X.EDI_INCOTERMS  = B.INCOTERMS
                           AND X.ITEM_ID        = B.ITEM_ID
                           AND NVL(RTRIM(LTRIM(X.UNLOADING_POINT)), '-')    = NVL(RTRIM(LTRIM(B.UNLOADING_POINT)), '-')
                           AND NVL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), ' ')     = NVL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), ' ')
                           AND NVL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), ' ') = NVL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), ' ')
                           AND X.BASIS_YYYYMMDD >= B.VALID_START_DATE
                           AND X.BASIS_YYYYMMDD <= B.VALID_END_DATE
                           AND B.MAPPING_ITEM_ID IS NOT NULL
                           AND X.DIVISION_ID = P_DIVISION_ID   /* [E20251016-001453] 실행하려는 사업부 데이터만 */
                       ) A
                     , GT_PRDM_SCM_MST_SITE            C
                     , GT_PRDM_SCM_MST_SITE_ITEM       D
                     , SCM_MST_SSO_DEPT_INFO           E
                     , SCM_MST_SSO_DEPT_INFO           F
                     , SCM_MST_CITY                    G
                     , GT_PRDM_DM_MST_ITEM_SINGLE_V    H
                     , GT_PRDM_SCM_MST_PROJECT         I
                 WHERE A.DIVISION_ID    = C.DIVISION_ID(+)
                   AND A.SCM_SITE_ID    = C.SCM_SITE_ID(+)
                   AND A.DIVISION_ID    = D.DIVISION_ID(+)
                   AND A.PROJECT_CODE   = D.PROJECT_CODE(+)
                   AND A.SCM_SITE_ID    = D.SCM_SITE_ID(+)
                   AND A.ITEM_ID        = D.ITEM_ID(+)
--                   AND C.DEPT_ID        = E.DEPT_ID(+)
                   AND D.DEPT_ID        = E.DEPT_ID(+)                      -- 2026.09.03 AJS
                   AND E.UPPER_DEPT_ID  = F.DEPT_ID(+)
                   AND C.COUNTRY        = G.COUNTRY(+)
                   AND C.CITY           = G.CITY(+)
                   AND A.DIVISION_ID    = H.DIVISION_ID(+)
                   AND A.ITEM_ID        = H.ITEM_ID(+)
                   AND A.DIVISION_ID    = I.DIVISION_ID(+)
                   AND A.PROJECT_CODE   = I.PROJECT_CODE(+);

                INSERT
                  INTO GT_PRDM_QTY_SUM (
                       IFSEQNO
                     , EDI_IF_SEQ
                     , CREATE_DATE
                     , DIVISION_ID
                     , PROJECT_CODE
                     , ERP_FCST_TYPE
                     , BASIS_YYYYMMDD
                     , SCM_SITE_ID
                     , ITEM_ID
                     , QTY
                     , EDI_INCOTERMS
                     , SALES_PLANT_SITE_ID
                     , DOM_EXP
                     , UNLOADING_POINT
                     , CUST_MATERIAL_CODE )
                SELECT IFSEQNO
                     , EDI_IF_SEQ
                     , CREATE_DATE
                     , DIVISION_ID
                     , PROJECT_CODE
                     , ERP_FCST_TYPE
                     , BASIS_YYYYMMDD
                     , SCM_SITE_ID
                     , ITEM_ID
                     , SUM(TO_NUMBER(REPLACE(QTY, ',', '')))                              AS QTY
                     , EDI_INCOTERMS
                     , SALES_PLANT_SITE_ID
                     , DOM_EXP
                     , UNLOADING_POINT
                     , CUST_MATERIAL_CODE
                  FROM GT_PRDM_EDI_CUST_FCST
                 WHERE DIVISION_ID = P_DIVISION_ID
                   AND SCHEDULING_TYPE <> '83'
                 GROUP BY IFSEQNO, EDI_IF_SEQ, CREATE_DATE, DIVISION_ID, PROJECT_CODE
                     , ERP_FCST_TYPE, BASIS_YYYYMMDD, SCM_SITE_ID, ITEM_ID
                     , EDI_INCOTERMS, SALES_PLANT_SITE_ID, DOM_EXP
                     , UNLOADING_POINT, CUST_MATERIAL_CODE;

                DELETE
                  FROM DM_PLN_CUST_FCST_H
                 WHERE EDI_IF_SEQ IN (SELECT DISTINCT X.EDI_IF_SEQ FROM GT_PRDM_EDI_CUST_FCST X);

                /* ------------------------------------------------------------------
                   날짜 중복데이터는 SUM한 값으로 입력
                   ------------------------------------------------------------------ */
                INSERT
                  INTO DM_PLN_CUST_FCST_H (
                       HISTORY_SEQ
                     , EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                     , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
                     , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                     , CREATE_DATE
                     , SENDER_CODE
                     , SENDER_NAME
                     , END_CUSTOMER
                     , CUSTOMER_PLANT
                     , UNLOADING_POINT
                     , NICK_NAME
                     , DEPT_NAME_KO
                     , TEAM_NAME_KO
                     , SOLDTO_CUSTOMER
                     , COUNTRY
                     , CITY
                     , ITEM_NAME
                     , ITEM_TYPE
                     , OWNER
                     , VMI_YN
                     , BIZ_TYPE
                     , PROJECT_NAME
                     , PROJECT_STATUS
                     , PROJECT_OWNER
                     , CELL_PER_CAR
                     , CELL_PER_MODULE
                     , MODULE_PER_CAR
                     , KWH_PER_CELL
                     , KWH_PER_MODULE
                     , KWH_PER_PACK
                     , SCHEDULING_TYPE
                     , CUST_MATERIAL_CODE )
                SELECT SEQ1_DM_PLN_CUST_FCST_H.NEXTVAL
                     , A.EDI_IF_SEQ, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
                     , A.EDI_INCOTERMS, 'CUST_FCST_EDI', NVL(A.SALES_PLANT_SITE_ID, ' '), A.BASIS_YYYYMMDD, B.QTY
                     , 'EDI', SYSDATE, 'EDI', SYSDATE
                     , A.CREATE_DATE
                     , A.SENDER_CODE
                     , A.SENDER_NAME
                     , A.END_CUSTOMER
                     , A.CUSTOMER_PLANT
                     , A.UNLOADING_POINT
                     , A.NICK_NAME
                     , A.DEPT_NAME_KO
                     , A.TEAM_NAME_KO
                     , A.SOLDTO_CUSTOMER
                     , A.COUNTRY
                     , A.CITY
                     , A.ITEM_NAME
                     , A.ITEM_TYPE
                     , A.OWNER
                     , A.VMI_YN
                     , A.BIZ_TYPE
                     , A.PROJECT_NAME
                     , A.PROJECT_STATUS
                     , A.PROJECT_OWNER
                     , A.CELL_PER_CAR
                     , A.CELL_PER_MODULE
                     , A.MODULE_PER_CAR
                     , A.KWH_PER_CELL
                     , A.KWH_PER_MODULE
                     , A.KWH_PER_PACK
                     , A.SCHEDULING_TYPE
                     , A.CUST_MATERIAL_CODE
                  FROM GT_PRDM_EDI_CUST_FCST A
                     , GT_PRDM_QTY_SUM       B
                 WHERE A.IFSEQNO      = B.IFSEQNO
                   AND A.EDI_IF_SEQ   = B.EDI_IF_SEQ
                   AND A.CREATE_DATE  = B.CREATE_DATE
                   AND A.DIVISION_ID  = B.DIVISION_ID
                   AND NVL(A.PROJECT_CODE, ' ')       = NVL(B.PROJECT_CODE, ' ')
                   AND NVL(A.SCM_SITE_ID, ' ')        = NVL(B.SCM_SITE_ID, ' ')
                   AND NVL(A.ITEM_ID, ' ')            = NVL(B.ITEM_ID, ' ')
                   AND A.DOM_EXP              = B.DOM_EXP
                   AND A.ERP_FCST_TYPE        = B.ERP_FCST_TYPE
                   AND A.EDI_INCOTERMS        = B.EDI_INCOTERMS
                   AND A.SALES_PLANT_SITE_ID  = B.SALES_PLANT_SITE_ID
                   AND A.BASIS_YYYYMMDD       = B.BASIS_YYYYMMDD
                   AND NVL(A.UNLOADING_POINT, '-')    = NVL(B.UNLOADING_POINT, '-')
                   AND NVL(A.CUST_MATERIAL_CODE, ' ') = NVL(B.CUST_MATERIAL_CODE, ' ');

                /* ------------------------------------------------------------------
                   MEASURE별 SUM한 값으로 생성
                   Oracle: SEQ.NEXTVAL 은 GROUP BY/집계 SELECT 직접 사용 불가(ORA-02287) → 집계결과를 인라인뷰 Q 로 감싸고 바깥에서 채번
                   ------------------------------------------------------------------ */
                INSERT
                  INTO DM_PLN_CUST_FCST_H (
                       HISTORY_SEQ
                     , EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , YYYYMMDD
                     , QTY
                     , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                     , CREATE_DATE
                     , SENDER_CODE
                     , SENDER_NAME
                     , END_CUSTOMER
                     , CUSTOMER_PLANT
                     , UNLOADING_POINT
                     , NICK_NAME
                     , DEPT_NAME_KO
                     , TEAM_NAME_KO
                     , SOLDTO_CUSTOMER
                     , COUNTRY
                     , CITY
                     , ITEM_NAME
                     , ITEM_TYPE
                     , OWNER
                     , VMI_YN
                     , BIZ_TYPE
                     , PROJECT_NAME
                     , PROJECT_STATUS
                     , PROJECT_OWNER
                     , CELL_PER_CAR
                     , CELL_PER_MODULE
                     , MODULE_PER_CAR
                     , KWH_PER_CELL
                     , KWH_PER_MODULE
                     , KWH_PER_PACK
                     , SCHEDULING_TYPE
                     , CUST_MATERIAL_CODE )
                SELECT SEQ1_DM_PLN_CUST_FCST_H.NEXTVAL
                     , Q.EDI_IF_SEQ, Q.DIVISION_ID, Q.PROJECT_CODE, Q.SCM_SITE_ID, Q.ITEM_ID, Q.DOM_EXP, Q.ERP_FCST_TYPE
                     , Q.EDI_INCOTERMS
                     , Q.MEASURE
                     , Q.PLANT_SITE_ID
                     , Q.BASIS_YYYYMMDD
                     , Q.QTY
                     , 'EDI', SYSDATE, 'EDI', SYSDATE
                     , Q.CREATE_DATE
                     , Q.SENDER_CODE
                     , Q.SENDER_NAME
                     , Q.END_CUSTOMER
                     , Q.CUSTOMER_PLANT
                     , Q.UNLOADING_POINT
                     , Q.NICK_NAME
                     , Q.DEPT_NAME_KO
                     , Q.TEAM_NAME_KO
                     , Q.SOLDTO_CUSTOMER
                     , Q.COUNTRY
                     , Q.CITY
                     , Q.ITEM_NAME
                     , Q.ITEM_TYPE
                     , Q.OWNER
                     , Q.VMI_YN
                     , Q.BIZ_TYPE
                     , Q.PROJECT_NAME
                     , Q.PROJECT_STATUS
                     , Q.PROJECT_OWNER
                     , Q.CELL_PER_CAR
                     , Q.CELL_PER_MODULE
                     , Q.MODULE_PER_CAR
                     , Q.KWH_PER_CELL
                     , Q.KWH_PER_MODULE
                     , Q.KWH_PER_PACK
                     , Q.SCHEDULING_TYPE
                     , Q.CUST_MATERIAL_CODE
                  FROM (
                        SELECT A.EDI_IF_SEQ, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
                             , A.EDI_INCOTERMS
                             , CASE WHEN A.SCHEDULING_TYPE = '4'  THEN 'Planning_Forecast'
                                    WHEN A.SCHEDULING_TYPE = '10' THEN 'Immidiate'
                                    WHEN A.SCHEDULING_TYPE = '24' THEN 'Commercial_Agreement'
                                    WHEN A.SCHEDULING_TYPE = '1'  THEN 'Firm_Temp'
                                    WHEN A.SCHEDULING_TYPE = '2'  THEN 'Manumacturing_Material_Temp'
                                    WHEN A.SCHEDULING_TYPE = '3'  THEN 'Material_Temp'
                                    WHEN A.SCHEDULING_TYPE = '83' THEN 'Backorder'
                               END                                                          AS MEASURE
                             , NVL(A.SALES_PLANT_SITE_ID, ' ')                              AS PLANT_SITE_ID
                             , A.BASIS_YYYYMMDD                                             AS BASIS_YYYYMMDD
                             , SUM(TO_NUMBER(REPLACE(A.QTY, ',', '')))                      AS QTY
                             , A.CREATE_DATE
                             , A.SENDER_CODE
                             , A.SENDER_NAME
                             , A.END_CUSTOMER
                             , A.CUSTOMER_PLANT
                             , A.UNLOADING_POINT
                             , A.NICK_NAME
                             , A.DEPT_NAME_KO
                             , A.TEAM_NAME_KO
                             , A.SOLDTO_CUSTOMER
                             , A.COUNTRY
                             , A.CITY
                             , A.ITEM_NAME
                             , A.ITEM_TYPE
                             , A.OWNER
                             , A.VMI_YN
                             , A.BIZ_TYPE
                             , A.PROJECT_NAME
                             , A.PROJECT_STATUS
                             , A.PROJECT_OWNER
                             , A.CELL_PER_CAR
                             , A.CELL_PER_MODULE
                             , A.MODULE_PER_CAR
                             , A.KWH_PER_CELL
                             , A.KWH_PER_MODULE
                             , A.KWH_PER_PACK
                             , A.SCHEDULING_TYPE
                             , A.CUST_MATERIAL_CODE
                          FROM GT_PRDM_EDI_CUST_FCST A
                         WHERE A.SCHEDULING_TYPE IS NOT NULL   /* 20240507 임시 */
                         GROUP BY A.EDI_IF_SEQ, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
                             , A.EDI_INCOTERMS, A.SCHEDULING_TYPE, NVL(A.SALES_PLANT_SITE_ID, ' '), A.BASIS_YYYYMMDD, A.CREATE_DATE
                             , A.SENDER_CODE, A.SENDER_NAME, A.END_CUSTOMER, A.CUSTOMER_PLANT, A.UNLOADING_POINT
                             , A.NICK_NAME, A.DEPT_NAME_KO, A.TEAM_NAME_KO, A.SOLDTO_CUSTOMER, A.COUNTRY, A.CITY
                             , A.ITEM_NAME, A.ITEM_TYPE, A.OWNER, A.VMI_YN, A.BIZ_TYPE, A.PROJECT_NAME, A.PROJECT_STATUS, A.PROJECT_OWNER
                             , A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, A.KWH_PER_CELL, A.KWH_PER_MODULE, A.KWH_PER_PACK
                             , A.CUST_MATERIAL_CODE
                       ) Q;

            END IF;

        END IF;
        /* ******************** EDI DATA 생성 END ******************** */


        /* ******************** RPA DATA 생성 START ******************** */
        IF V_ACCEPT_FLAG = 'RPA' THEN

            DELETE
              FROM DM_PLN_CUST_FCST_H
             WHERE MEASURE IN ('CUST_FCST', 'Customer FCST')
               AND DIVISION_ID = V_DIVISION_ID
               AND LAST_UPDATE_DATE >= TO_DATE(V_FROM_DATE, 'YYYYMMDD');

            DBMS_OUTPUT.PUT_LINE('RPA_A: @v_division_id:' || V_DIVISION_ID || ', @v_accept_flag:' || V_ACCEPT_FLAG || ', @v_from_date:' || V_FROM_DATE);

            IF (V_DIVISION_ID = '40') THEN

                INSERT
                  INTO DM_PLN_CUST_FCST_H (
                       HISTORY_SEQ
                     , EDI_IF_SEQ
                     , DIVISION_ID
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , YYYYMMDD, QTY
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     , CREATE_DATE
                     , SENDER_CODE
                     , SENDER_NAME
                     , END_CUSTOMER
                     , CUSTOMER_PLANT
                     , UNLOADING_POINT
                     , NICK_NAME
                     , DEPT_NAME_KO
                     , TEAM_NAME_KO
                     , SOLDTO_CUSTOMER
                     , COUNTRY
                     , CITY
                     , ITEM_NAME
                     , ITEM_TYPE
                     , OWNER
                     , VMI_YN
                     , BIZ_TYPE
                     , PROJECT_NAME
                     , PROJECT_STATUS
                     , PROJECT_OWNER
                     , CELL_PER_CAR
                     , CELL_PER_MODULE
                     , MODULE_PER_CAR
                     , KWH_PER_CELL
                     , KWH_PER_MODULE
                     , KWH_PER_PACK
                     , SCHEDULING_TYPE )
                SELECT SEQ1_DM_PLN_CUST_FCST_H.NEXTVAL
                     , ' '                                                                AS EDI_IF_SEQ    /* [MSSQL '' → NOT NULL 컬럼: 공백 sentinel] */
                     , AA.DIVISION_ID
                     , ' '                                                                AS PROJECT_CODE
                     , AA.SCM_SITE_ID
                     , AA.ITEM_ID
                     , AA.DOM_EXP
                     , AA.FCST_TYPE
                     , AA.INCOTERMS
                     , AA.MEASURE
                     , AA.PLANT_SITE_ID
                     , AA.YYYYMMDD
                     , CASE WHEN AA.QTY IS NULL THEN NULL ELSE CAST(AA.QTY AS NUMBER(30, 10)) END       AS QTY
                     , AA.CREATED_BY
                     , AA.CREATION_DATE
                     , AA.LAST_UPDATED_BY
                     , AA.LAST_UPDATE_DATE
                     , AA.CREATE_DATE
                     , AA.SENDER_CODE
                     , AA.SENDER_NAME
                     , AA.END_CUSTOMER
                     , AA.CUSTOMER_PLANT
                     , AA.UNLOADING_POINT
                     , AA.NICK_NAME
                     , AA.DEPT_NAME_KO
                     , AA.TEAM_NAME_KO
                     , AA.SOLDTO_CUSTOMER
                     , AA.COUNTRY_NAME
                     , AA.CITY_NAME
                     , AA.ITEM_NAME
                     , AA.ITEM_TYPE
                     , AA.OWNER
                     , AA.VMI_YN
                     , AA.BIZ_TYPE_NAME
                     , AA.PROJECT_NAME
                     , AA.PROJECT_STATUS
                     , AA.PROJECT_OWNER
                     , NVL(AA.CELL_PER_CAR, 0)                                            AS CELL_PER_CAR
                     , NVL(AA.CELL_PER_MODULE, 0)                                         AS CELL_PER_MODULE
                     , NVL(AA.MODULE_PER_CAR, 0)                                          AS MODULE_PER_CAR
                     , 0                                                                  AS KWH_PER_CELL  /* 원본: ISNULL(CONVERT(NUMERIC(30,10),AA.KWH_PER_CELL),0) 주석처리→0 고정 */
                     , NVL(AA.KWH_PER_MODULE, 0)                                          AS KWH_PER_MODULE
                     , NVL(AA.KWH_PER_PACK, 0)                                            AS KWH_PER_PACK
                     , ' '                                                                AS SCHEDULING_TYPE
                  FROM (
                        SELECT DISTINCT A.DIVISION_ID
                             , ' '                    AS SENDER_CODE
                             , ' '                    AS SENDER_NAME
                             , A.YYYYMMDD
                             , ' '                    AS CUSTOMER_PLANT
                             , '-'                    AS UNLOADING_POINT
                             , ' '                    AS CUST_MATERIAL_CODE
                             , C.END_CUSTOMER
                             , A.SCM_SITE_ID
                             , A.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                             , A.INCOTERMS
                             , A.FCST_TYPE
                             , A.DOM_EXP
                             , E.DEPT_NAME_KO         AS DEPT_NAME_KO
                             , F.DEPT_NAME_KO         AS TEAM_NAME_KO
                             , C.SOLDTO_CUSTOMER
                             , G.COUNTRY_NAME
                             , G.CITY_NAME
                             , H.ITEM_NAME
                             , H.ITEM_TYPE
                             , D.OWNER
                             , C.VMI_YN
                             , I.BIZ_TYPE_NAME
                             , A.PROJECT_CODE
                             , I.PROJECT_NAME
                             , I.PROJECT_STATUS
                             , I.PROJECT_OWNER
                             , A.PLANT_SITE_ID        AS PLANT_SITE_ID
                             , D.CELL_PER_CAR
                             , D.CELL_PER_MODULE
                             , CASE WHEN D.CELL_PER_MODULE <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR
                             , ' '                    AS SOLDTO_CODE
                             , ' '                    AS COMPANY_ID
                             , D.ATTRIBUTE8           AS KWH_PER_CELL
                             , CASE WHEN A.DIVISION_ID = V_DIVISION_ID AND D.CELL_PER_MODULE > 0 AND NVL(D.ATTRIBUTE8, '''') <> '''' THEN (D.CELL_PER_MODULE * D.ATTRIBUTE8)
                                    ELSE NULL
                               END                    AS KWH_PER_MODULE
                             , CASE WHEN A.DIVISION_ID = V_DIVISION_ID AND D.CELL_PER_CAR > 0 AND NVL(D.ATTRIBUTE8, '''') <> '''' THEN (D.CELL_PER_CAR * D.ATTRIBUTE8)
                                    ELSE NULL
                               END                    AS KWH_PER_PACK
                             , A.MEASURE
                             , A.QTY
                             , TO_CHAR(A.CREATION_DATE, 'YYYYMMDD') AS CREATE_DATE
                             , A.CREATED_BY
                             , A.CREATION_DATE
                             , A.LAST_UPDATED_BY
                             , A.LAST_UPDATE_DATE
                          FROM DM_PLN_MKT_FCST            A
                             , SCM_MST_SITE               C
                             , SCM_MST_SITE_ITEM          D
                             , SCM_MST_SSO_DEPT_INFO       E
                             , SCM_MST_SSO_DEPT_INFO       F
                             , SCM_MST_CITY               G
                             , DM_MST_ITEM_SINGLE_V       H
                             , SCM_MST_PROJECT            I
                         WHERE A.DIVISION_ID    = C.DIVISION_ID(+)
                           AND A.SCM_SITE_ID    = C.SCM_SITE_ID(+)
                           AND C.SITE_TYPE(+)   = 'SALES'
                           AND C.VALID_YN(+)    = 'Y'
                           AND A.DIVISION_ID    = D.DIVISION_ID(+)
                           AND A.SCM_SITE_ID    = D.SCM_SITE_ID(+)
                           AND A.ITEM_ID        = D.ITEM_ID(+)
--                           AND C.DEPT_ID        = E.DEPT_ID(+)
                           AND D.DEPT_ID        = E.DEPT_ID(+)              -- 2026.09.03 AJS
                           AND E.UPPER_DEPT_ID  = F.DEPT_ID(+)
                           AND C.COUNTRY        = G.COUNTRY(+)
                           AND C.CITY           = G.CITY(+)
                           AND A.DIVISION_ID    = H.DIVISION_ID(+)
                           AND A.ITEM_ID        = H.ITEM_ID(+)
                           AND A.DIVISION_ID    = I.DIVISION_ID(+)
                           AND A.MEASURE IN ('CUST_FCST', 'Customer FCST')   /* RPA는 CUST_FCST_EDI가 없기 때문인건지? */
                           AND A.DIVISION_ID = V_DIVISION_ID
                           AND TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') >= V_FROM_DATE
                       ) AA;

            ELSE

                INSERT
                  INTO DM_PLN_CUST_FCST_H (
                       HISTORY_SEQ
                     , EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID, YYYYMMDD, QTY
                     , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                     , CREATE_DATE
                     , SENDER_CODE
                     , SENDER_NAME
                     , END_CUSTOMER
                     , CUSTOMER_PLANT
                     , UNLOADING_POINT
                     , NICK_NAME
                     , DEPT_NAME_KO
                     , TEAM_NAME_KO
                     , SOLDTO_CUSTOMER
                     , COUNTRY
                     , CITY
                     , ITEM_NAME
                     , ITEM_TYPE
                     , OWNER
                     , VMI_YN
                     , BIZ_TYPE
                     , PROJECT_NAME
                     , PROJECT_STATUS
                     , PROJECT_OWNER
                     , CELL_PER_CAR
                     , CELL_PER_MODULE
                     , MODULE_PER_CAR
                     , KWH_PER_CELL
                     , KWH_PER_MODULE
                     , KWH_PER_PACK )
                SELECT SEQ1_DM_PLN_CUST_FCST_H.NEXTVAL
                     , ' '                                                                AS EDI_IF_SEQ    /* [MSSQL '' → NOT NULL 컬럼: 공백 sentinel] */
                     , AA.DIVISION_ID
                     , AA.PROJECT_CODE
                     , AA.SCM_SITE_ID
                     , AA.ITEM_ID
                     , AA.DOM_EXP
                     , AA.FCST_TYPE
                     , AA.INCOTERMS
                     , AA.MEASURE
                     , AA.PLANT_SITE_ID
                     , AA.YYYYMMDD
                     , CASE WHEN AA.QTY IS NULL THEN NULL ELSE CAST(AA.QTY AS NUMBER(30, 10)) END       AS QTY
                     , AA.CREATED_BY
                     , AA.CREATION_DATE
                     , AA.LAST_UPDATED_BY
                     , AA.LAST_UPDATE_DATE
                     , AA.CREATE_DATE
                     , AA.SENDER_CODE
                     , AA.SENDER_NAME
                     , AA.END_CUSTOMER
                     , AA.CUSTOMER_PLANT
                     , AA.UNLOADING_POINT
                     , AA.NICK_NAME
                     , AA.DEPT_NAME_KO
                     , AA.TEAM_NAME_KO
                     , AA.SOLDTO_CUSTOMER
                     , AA.COUNTRY_NAME
                     , AA.CITY_NAME
                     , AA.ITEM_NAME
                     , AA.ITEM_TYPE
                     , AA.OWNER
                     , AA.VMI_YN
                     , AA.BIZ_TYPE_NAME
                     , AA.PROJECT_NAME
                     , AA.PROJECT_STATUS
                     , AA.PROJECT_OWNER
                     , CASE WHEN AA.CELL_PER_CAR    IS NULL THEN NULL ELSE CAST(AA.CELL_PER_CAR    AS NUMBER(30, 10)) END AS CELL_PER_CAR
                     , CASE WHEN AA.CELL_PER_MODULE IS NULL THEN NULL ELSE CAST(AA.CELL_PER_MODULE AS NUMBER(30, 10)) END AS CELL_PER_MODULE
                     , CASE WHEN AA.MODULE_PER_CAR  IS NULL THEN NULL ELSE CAST(AA.MODULE_PER_CAR  AS NUMBER(30, 10)) END AS MODULE_PER_CAR
                     , CASE WHEN AA.KWH_PER_CELL    IS NULL THEN NULL ELSE CAST(AA.KWH_PER_CELL    AS NUMBER(30, 10)) END AS KWH_PER_CELL
                     , CASE WHEN AA.KWH_PER_MODULE  IS NULL THEN NULL ELSE CAST(AA.KWH_PER_MODULE  AS NUMBER(30, 10)) END AS KWH_PER_MODULE
                     , CASE WHEN AA.KWH_PER_PACK    IS NULL THEN NULL ELSE CAST(AA.KWH_PER_PACK    AS NUMBER(30, 10)) END AS KWH_PER_PACK
                  FROM (
                        SELECT DISTINCT A.DIVISION_ID
                             , ' '                    AS SENDER_CODE
                             , ' '                    AS SENDER_NAME
                             , A.YYYYMMDD
                             , ' '                    AS CUSTOMER_PLANT
                             , ' '                    AS UNLOADING_POINT
                             , ' '                    AS CUST_MATERIAL_CODE
                             , C.END_CUSTOMER
                             , A.SCM_SITE_ID
                             , A.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                             , A.INCOTERMS
                             , A.FCST_TYPE
                             , A.DOM_EXP
                             , E.DEPT_NAME_KO         AS DEPT_NAME_KO
                             , F.DEPT_NAME_KO         AS TEAM_NAME_KO
                             , C.SOLDTO_CUSTOMER
                             , G.COUNTRY_NAME
                             , G.CITY_NAME
                             , H.ITEM_NAME
                             , H.ITEM_TYPE
                             , D.OWNER
                             , C.VMI_YN
                             , I.BIZ_TYPE_NAME
                             , A.PROJECT_CODE
                             , I.PROJECT_NAME
                             , I.PROJECT_STATUS
                             , I.PROJECT_OWNER
                             , A.PLANT_SITE_ID        AS PLANT_SITE_ID
                             , D.CELL_PER_CAR
                             , D.CELL_PER_MODULE
                             , CASE WHEN D.CELL_PER_MODULE <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR
                             , ' '                    AS SOLDTO_CODE
                             , ' '                    AS COMPANY_ID
                             , D.ATTRIBUTE8           AS KWH_PER_CELL
                             , CASE WHEN A.DIVISION_ID = V_DIVISION_ID AND D.CELL_PER_MODULE > 0 AND NVL(D.ATTRIBUTE8, '''') <> '''' THEN (D.CELL_PER_MODULE * D.ATTRIBUTE8)
                                    ELSE NULL
                               END                    AS KWH_PER_MODULE
                             , CASE WHEN A.DIVISION_ID = V_DIVISION_ID AND D.CELL_PER_CAR > 0 AND NVL(D.ATTRIBUTE8, '''') <> '''' THEN (D.CELL_PER_CAR * D.ATTRIBUTE8)
                                    ELSE NULL
                               END                    AS KWH_PER_PACK
                             , A.MEASURE
                             , A.QTY
                             , TO_CHAR(A.CREATION_DATE, 'YYYYMMDD') AS CREATE_DATE
                             , A.CREATED_BY
                             , A.CREATION_DATE
                             , A.LAST_UPDATED_BY
                             , A.LAST_UPDATE_DATE
                          FROM DM_PLN_MKT_FCST            A
                             , SCM_MST_SITE               C
                             , SCM_MST_SITE_ITEM          D
                             , SCM_MST_SSO_DEPT_INFO       E
                             , SCM_MST_SSO_DEPT_INFO       F
                             , SCM_MST_CITY               G
                             , DM_MST_ITEM_SINGLE_V       H
                             , SCM_MST_PROJECT            I
                         WHERE A.DIVISION_ID    = C.DIVISION_ID(+)
                           AND A.SCM_SITE_ID    = C.SCM_SITE_ID(+)
                           AND C.SITE_TYPE(+)   = 'SALES'
                           AND C.VALID_YN(+)    = 'Y'
                           AND A.DIVISION_ID    = D.DIVISION_ID(+)
                           AND A.PROJECT_CODE   = D.PROJECT_CODE(+)
                           AND A.SCM_SITE_ID    = D.SCM_SITE_ID(+)
                           AND A.ITEM_ID        = D.ITEM_ID(+)
--                           AND C.DEPT_ID        = E.DEPT_ID(+)
                           AND D.DEPT_ID        = E.DEPT_ID(+)              -- 2026.09.03 AJS
                           AND E.UPPER_DEPT_ID  = F.DEPT_ID(+)
                           AND C.COUNTRY        = G.COUNTRY(+)
                           AND C.CITY           = G.CITY(+)
                           AND A.DIVISION_ID    = H.DIVISION_ID(+)
                           AND A.ITEM_ID        = H.ITEM_ID(+)
                           AND A.DIVISION_ID    = I.DIVISION_ID(+)
                           AND A.PROJECT_CODE   = I.PROJECT_CODE(+)
                           AND A.MEASURE IN ('CUST_FCST', 'Customer FCST')   /* RPA는 CUST_FCST_EDI가 없기 때문인건지? */
                           AND A.DIVISION_ID = V_DIVISION_ID
                           AND TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') >= V_FROM_DATE
                       ) AA;

            END IF;

        END IF;
        /* ******************** RPA DATA 생성 END ******************** */

        COMMIT;   /* MSSQL 문장단위 autocommit 재현(성공경로 확정). GTT(ON COMMIT DELETE ROWS)는 소비 완료 후라 안전 */

    EXCEPTION
        WHEN OTHERS THEN

            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE (' || P_DIVISION_ID || '_' || P_ACCEPT_FLAG || ') : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                , V_LOG_TYPE
                , N_LOG_COUNT
                , V_LOG_MESSAGE
                , V_DESCRIPTION
                , D_EVENT_DATE
                , JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_accept_flag' VALUE P_ACCEPT_FLAG RETURNING VARCHAR2(4000 CHAR))
                , SQLCODE
                , SQLERRM
                , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);


    END;

    /* 종료 LOG (EXCEPTION 바깥 = 정상·에러 모두 항상 기록) */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := V_FROM_DATE || '(' || P_DIVISION_ID || '_' || P_ACCEPT_FLAG || ')';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END;
/
SHOW ERRORS PROCEDURE PR_DM_PLN_CUST_FCST_RECORD
