PROCEDURE         "PR_DM_BPS_SALES_PLAN_S" 
(
      P_DIVISION_ID       IN VARCHAR2   /* DIVISION_ID */
    , P_CUT_OFF_VERSION   IN VARCHAR2   /* Version */
)
/* =====================================================================================================================================================
 * Program ID   : PR_DM_BPS_SALES_PLAN_S
 * Description  : 이동계획 IF_매출
 *                이동계획 수립 주차에는 Version Popup에서 이동계획 여부(Y/N)을 Y인 것이 대상
 *                테이블 : XIF_BPS_SALES_PLAN_S --> XIF_BPS_SALES_PLAN_S_SN
 * Program History
 * -----------------------------------------------------------------------------------------------------------------------------------------------------
 *  Date          In Charge    Description
 * -----------------------------------------------------------------------------------------------------------------------------------------------------
 * 2024.05.30    kcw3408      이동계획 IF_매출 배치작업 신규
 * 2024.07.05    JSSBAE       [E20240703-001284]_이동계획 BPS I/F 관련 개선요청 (CUTOFF 주차 오매핑으로 수정)
 * 2024.09.13    KJJ          [PJ2024-50461] Team Mapping 로직 변경 - Sales Site Project Model 의 Owner 팀 적용(40번 사업부와 동일. 81, 81_JV, 82 사업부 적용)
 * 2024.10.24.   KJJ          [PJ2024-50611] 소형 이동계획 확산
 * 2024.11.15    KANG.H.J     [PJ2024-50611] 소형 매출 프로세스 개선
 * 2024.12.03    KJJ          [PJ2024-50611] 소형사업부 Sales Plan Catch Up 수량 추가
 * 2024.12.06    KANG.H.J     [PJ2024-50611] FROM_SITE_ID 전사업부 확대 적용
 * 2024.12.19    KJJ          [PJ2024-50611] 기타매출, Catch Up 테이블 분리 - 작업중
 * 2025.04.03    KANG.H.J     [PJ2025-50017] FROM_SITE_ID를 SALES_PLAN의 CELL_PROD_SITE_ID로 정의함.
 * 2025.04.08    KANG.H.J     [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.22    KANG.H.J     [PJ2025-50017] 소형 매출계획 동기화 개선 - FUTURE_PRICE를 사업부 단위로 구분처리 (임시테이블 활용)
 * 2025.04.28    KANG.H.J     [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
 * 2025.06.23    KANG.H.J     [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.06.23    KANG.H.J     [PJ2025-50188] 칼럼 위치 잘못되어 재조정함
 * 2025.07.23    KANG.H.J     [PJ2025-50188] RESULT의 ATTRIBUTE2는 CELL_PROD_SITE_ID와 관계없는 데이터이므로 CELL_PROD_SITE_ID 만으로 조정함.
 * 2025.08.27    JSSBAE       [E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선
 * EXEC PR_DM_BPS_SALES_PLAN_S_KJJ2 N'40',N'SP_W_20241205_V002'
 * EXEC PR_DM_BPS_SALES_PLAN_S N'81',N'SP_W_20240613_V001'
 * 2026-07-06    ZIONEX       [PJ202650304]  NextSCM Migration
 * -----------------------------------------------------------------------------------------------------------------------------------------------------
 *   - ★최종 XIF INSERT 의 3-UNION ALL 본문은 ANSI LEFT OUTER JOIN 유지: 가격 인라인뷰 B 의 조인술어가
 *     CASE 식(A.PROJECT_CODE = CASE WHEN B.DIVISION_ID='40' THEN B.END_CUSTOMER ELSE B.PROJECT_CODE END)이라
 * ===================================================================================================================================================== */
AS
    V_PROGRAM_NAME    VARCHAR2(150 CHAR) := 'PR_DM_BPS_SALES_PLAN_S';
    V_LOG_TYPE        VARCHAR2(30 CHAR);
    N_LOG_COUNT       INTEGER := 0;
    V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
    V_DESCRIPTION     VARCHAR2(500 CHAR);
    D_EVENT_DATE      DATE;
    V_CREATED_BY      VARCHAR2(150 CHAR) := 'SYS_BATCH_DATA';
    V_YYYYMMDD        VARCHAR2(8 CHAR);
    V_FROM_YYYYMMDD   VARCHAR2(8 CHAR);   /* Cutoff 월 01일 */
    V_TO_YYYYMMDD     VARCHAR2(8 CHAR);   /* Cutoff 주차 월요일(룩업 주차 적용) */
    V_PLAN_WEEK       VARCHAR2(30 CHAR);
BEGIN
    /* 시작 LOG (START) : PR_DM_SYS_LOG_BATCH (7 positional) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := 'PR_DM_BATCH_IF:' || P_DIVISION_ID || '/' || P_CUT_OFF_VERSION;
    D_EVENT_DATE  := SYSDATE;
    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY);

    BEGIN

        DELETE
          FROM GT_BPS_PRICE;
        DELETE
          FROM GT_BPS_CAL;
        DELETE
          FROM GT_BPS_VERNO;
        DELETE
          FROM GT_BPS_VERSEQ;
        DELETE
          FROM GT_BPS_SITE;


        IF P_DIVISION_ID = 'ALL' OR P_CUT_OFF_VERSION = 'ALL' THEN
            V_YYYYMMDD := TO_CHAR(SYSDATE, 'YYYYMMDD');
        ELSE
            V_YYYYMMDD := SUBSTR(P_CUT_OFF_VERSION, 6, 8);
        END IF;

        /* [E20250825-000297] BPS 전송 주차를 룩업(DM_BPS_PLAN_WEEK)에서 사업부별로 조정 */
        /* MSSQL "SELECT @var = col" (0행이면 NULL 유지) -> MAX() 로 등가 처리 */
        SELECT MAX(A.SEGMENT2)
          INTO V_PLAN_WEEK
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
         WHERE A.LOOKUP_TYPE = 'DM_BPS_PLAN_WEEK'
           AND A.SEGMENT1 = P_DIVISION_ID;

        /* 기간설정 */
        V_FROM_YYYYMMDD := SUBSTR(V_YYYYMMDD, 1, 6) || '01';
        V_TO_YYYYMMDD   := TO_CHAR((FN_NEXT_DAY(TO_DATE(V_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7) + TO_NUMBER(V_PLAN_WEEK) * 7 - 1, 'YYYYMMDD');

        /* BPS I/F 진행할 캘린더 TEMP (집계 1행) */
        INSERT
          INTO GT_BPS_CAL
             ( BASIS_YYYYMMDD_WK_FROM
             , BASIS_YYYYMMDD_WK_TO
             , VERSION_NO_T
             , ISO_WEEK )
        SELECT MIN(B.BASIS_YYYYMMDD)
             , MAX(B.BASIS_YYYYMMDD)
             , MAX(SUBSTR(A.CALENDAR_YYYY, 3, 2) || 'RF_DM_' || A.CALENDAR_YYYY || '_' || A.WEEK_NAME || '_V')
             , MAX(A.ISO_WEEK)
          FROM SCM_SYS_CALENDAR_M A
             , SCM_SYS_CALENDAR_M B
         WHERE A.ISO_YYYYWW = B.ISO_YYYYWW
           AND A.BASIS_YYYYMMDD = V_YYYYMMDD;


        INSERT
          INTO GT_BPS_VERNO
             ( DIVISION_ID
             , VERSION_NO
             , MONTHLY_ROLLING_FCST
             , VERSION_NO_T
             , ISO_WEEK
             , CUTOFF_YYYYMM
             , TO_YYYYMMDD_R )
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.MONTHLY_ROLLING_FCST
             , A.VERSION_NO_T
             , A.ISO_WEEK
             , SUBSTR(A.YYYYMMDD, 1, 6)
             , TO_CHAR(FN_NEXT_DAY(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
          FROM ( SELECT ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) AS RNK
                      , A.DIVISION_ID
                      , A.VERSION_NO
                      , A.VERSION_TYPE
                      , B.VERSION_NO_T
                      , B.ISO_WEEK
                      , A.YYYYMMDD
                      , NVL(A.ATTRIBUTE7, 'N') AS MONTHLY_ROLLING_FCST
                   FROM DM_MST_VERSION A
                      , GT_BPS_CAL      B
                  WHERE 1 = 1
                    AND A.VERSION_TYPE = 'SP_W'
                    AND A.DIVISION_ID = CASE WHEN P_DIVISION_ID = 'ALL' OR P_CUT_OFF_VERSION = 'ALL' THEN A.DIVISION_ID ELSE P_DIVISION_ID END
                    AND A.VERSION_NO = CASE WHEN P_DIVISION_ID = 'ALL' OR P_CUT_OFF_VERSION = 'ALL' THEN A.VERSION_NO ELSE P_CUT_OFF_VERSION END
                    AND NVL(A.ATTRIBUTE7, 'N') = 'Y'
                    AND A.YYYYMMDD BETWEEN B.BASIS_YYYYMMDD_WK_FROM AND B.BASIS_YYYYMMDD_WK_TO ) A
         WHERE A.RNK = 1;

        /* [PJ2025-50017] FUTURE_PRICE 사업부 단위 구분 처리 (40 = CFM_SELLING, 그외 = FUTURE_PRICE) */
        INSERT
          INTO GT_BPS_PRICE
             ( DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , END_CUSTOMER
             , SCM_SITE_ID
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , ITEM_ID
             , YYYYMMDD
             , CURRENCY
             , MEASURE
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , PRICE )
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.CUTOFF_TYPE
             , A.CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.ITEM_ID
             , A.YYYYMMDD
             , A.CURRENCY
             , A.MEASURE
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.PRICE
          FROM DM_PLN_CFM_SELLING_PRICE_C A
             , ( SELECT DIVISION_ID
                      , VERSION_NO
                   FROM GT_BPS_VERNO
                  WHERE DIVISION_ID = '40'
                  GROUP BY DIVISION_ID, VERSION_NO ) B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.VERSION_NO = B.VERSION_NO
        UNION ALL
        SELECT A.DIVISION_ID
             , A.VERSION_NO
             , A.CUTOFF_TYPE
             , A.CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID
             , A.ITEM_ID
             , A.YYYYMMDD
             , A.CURRENCY
             , A.MEASURE
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.PRICE
          FROM SCM_MST_FUTURE_PRICE_C A
             , ( SELECT DIVISION_ID
                      , VERSION_NO
                   FROM GT_BPS_VERNO
                  WHERE DIVISION_ID <> '40'
                  GROUP BY DIVISION_ID, VERSION_NO ) B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.VERSION_NO = B.VERSION_NO;


        INSERT
          INTO GT_BPS_VERSEQ
             ( DIVISION_ID
             , VERSION_SEQ )
        SELECT A.DIVISION_ID
             , LPAD(TO_CHAR(A.VERSION_SEQ), 2, '0') AS VERSION_SEQ
          FROM ( SELECT A.DIVISION_ID
                      , TO_NUMBER(SUBSTR(MAX(A.VERSION_NO), 19, 2)) + 1 AS VERSION_SEQ
                   FROM XIF_BPS_SALES_PLAN_S_SN A
                      , GT_BPS_VERNO             Z
                  WHERE 1 = 1
                    AND A.DIVISION_ID = Z.DIVISION_ID
                    AND A.VERSION_NO LIKE Z.VERSION_NO_T || '%'
                  GROUP BY A.DIVISION_ID ) A;


        INSERT
          INTO GT_BPS_SITE
             ( SCM_SITE_ID
             , DIVISION_ID
--             , DEPT_ID
             , SOLDTO_CODE
             , SHIPTO_CODE
             , VMI_YN
             , END_CUSTOMER
             , CITY_NAME
             , COUNTRY_NAME
             , SHIPTO_DESCRIPTION
             , SOLDTO_DESCRIPTION
             , VALID_YN )
        SELECT B.SCM_SITE_ID
             , B.DIVISION_ID
--             , B.DEPT_ID
             , K.SOLDTO_CODE
             , K.SHIPTO_CODE
             , B.VMI_YN
             , B.END_CUSTOMER
             , H.CITY_NAME
             , J.COUNTRY_NAME
             , L.SHIPTO_DESCRIPTION
             , L.SOLDTO_DESCRIPTION
             , B.VALID_YN
          FROM SCM_MST_SITE          B
             , SCM_MST_SITE_CUSTOMER  K
             , SCM_MST_CITY           H
             , SCM_MST_COUNTRY        J
             , SCM_MST_CUSTOMER       L
         WHERE B.DIVISION_ID = K.DIVISION_ID(+)
           AND B.SCM_SITE_ID = K.SCM_SITE_ID(+)
           AND K.REP_YN(+) = 'Y'
           AND B.CITY = H.CITY(+)
           AND B.COUNTRY = J.COUNTRY(+)
           AND K.DIVISION_ID = L.DIVISION_ID(+)
           AND K.SHIPTO_CODE = L.SHIPTO_CODE(+)
           AND K.SOLDTO_CODE = L.SOLDTO_CODE(+);

        /* 최종 XIF INSERT (3-UNION ALL -> 집계)  : GUID 자동채번 제외 */
        /* ★ANSI LEFT OUTER JOIN 유지(포맷표준 §4 예외): 가격 인라인뷰 B 조인술어가 CASE 식이라 (+) 표현 불가 */
        INSERT
          INTO XIF_BPS_SALES_PLAN_S_SN
             ( IFDATE
             , IFTIME
             , IFUSER
             , IFSERVICE
             , CUTOFF_YYYYMM
             , VERSION_NO
             , CUTOFF_ISO_WEEK
             , CUTOFF_YYYYMMDD
             , DIVISION_ID
             , DEPT_ID
             , DEPT_NAME
             , SCM_SITE_ID
             , FCST_TYPE
             , FCST_TYPE_NAME
             , COMPANY_ID
             , SALES_PLANT
             , SOLDTO_CODE
             , SHIPTO_CODE
             , END_CUSTOMER
             , INCOTERMS
             , PROJECT_CODE
             , PLANT_SITE_ID
             , ITEM_ID
             , BIZ_TYPE
             , BIZ_TYPE_NAME
             , CURRENCY
             , PLAN_YYYYMM
             , SALES_QTY
             , ITEM_UOM
             , SALES_PRICE
             , CELL_PER_MODULE
             , MODULE_PER_CAR
             , KWH_PER_CELL
             , CELL_PER_CAR
             , ENERGE
             , CREATION_DATE
             , TRANSFER_DATE
             , TRANSFER_FLAG
             , ETL_LOAD_DATE
             , VALUE_TBL_INFO
             , SRC_SYS_CD
             , FROM_SITE_ID
             , CATCH_UP_QTY )
        SELECT NULL                                          AS IFDATE
             , NULL                                          AS IFTIME
             , NULL                                          AS IFUSER
             , NULL                                          AS IFSERVICE
             , T1.CUTOFF_YYYYMM
             , T1.VERSION_NO
             , T1.CUTOFF_ISO_WEEK
             , T1.CUTOFF_YYYYMMDD
             , T1.DIVISION_ID
             , T1.DEPT_ID
             , T2.DEPT_NAME_KO                               AS DEPT_NAME
             , T1.SCM_SITE_ID
             , T1.FCST_TYPE
             , T3.SEGMENT2                                   AS FCST_TYPE_NAME
             , T1.COMPANY_ID
             , T1.SALES_PLANT
             , T1.SOLDTO_CODE
             , T1.SHIPTO_CODE
             , T1.END_CUSTOMER
             , T1.INCOTERMS
             , T1.PROJECT_CODE
             , T1.PLANT_SITE_ID
             , T1.ITEM_ID
             , T1.BIZ_TYPE
             , T4.SEGMENT2                                   AS BIZ_TYPE_NAME
             , T1.CURRENCY
             , T1.PLAN_YYYYMM
             , ROUND(SUM(T1.SALES_QTY), 5)                   AS SALES_QTY
             , T1.ITEM_UOM
             , ROUND(AVG(T1.SALES_PRICE), 5)                 AS SALES_PRICE
             , ROUND(NVL(T1.CELL_PER_MODULE, 0), 5)          AS CELL_PER_MODULE
             , ROUND(NVL(T1.MODULE_PER_CAR, 0), 5)           AS MODULE_PER_CAR
             , ROUND(NVL(T1.KWH_PER_CELL, 0), 5)             AS KWH_PER_CELL
             , ROUND(NVL(T1.CELL_PER_CAR, 0), 5)             AS CELL_PER_CAR
    --         , ROUND(NVL(T1.ENERGE, 0), 5)                   AS ENERGE
             , ROUND(NVL(TO_NUMBER(TRIM(T1.ENERGE)), 0), 5)  AS ENERGE
             , SYSDATE                                       AS CREATION_DATE
             , SYSDATE                                       AS TRANSFER_DATE
             , 'N'                                           AS TRANSFER_FLAG
             , SYSDATE                                       AS ETL_LOAD_DATE
             , NULL                                          AS VALUE_TBL_INFO
             , 'SCM'                                         AS SRC_SYS_CD
             , T1.FROM_SITE_ID
             , ROUND(AVG(T1.CATCHUP_QTY), 5)                 AS CATCH_UP_QTY
          FROM ( /* (1) DM_PLN_SALES_PLAN_C : RTF_SYS_RP */
                 SELECT SUBSTR(A.CUTOFF_YYYYMMDD, 1, 6)                     AS CUTOFF_YYYYMM
                      , Z.VERSION_NO_T || NVL(Y.VERSION_SEQ, '01')          AS VERSION_NO
                      , Z.ISO_WEEK                                          AS CUTOFF_ISO_WEEK
                      , A.CUTOFF_YYYYMMDD                                   AS CUTOFF_YYYYMMDD
                      , A.DIVISION_ID                                       AS DIVISION_ID
--                      , SU.DEPT_ID                                          AS DEPT_ID
                      , D.DEPT_ID                                          AS DEPT_ID   -- 2026.09.03 AJS
                      , A.SCM_SITE_ID                                       AS SCM_SITE_ID
                      , A.FCST_TYPE                                         AS FCST_TYPE
                      , D.SALES_COMPANY                                     AS COMPANY_ID
                      , D.SALES_PLANT                                       AS SALES_PLANT
                      , C.SOLDTO_CODE                                       AS SOLDTO_CODE
                      , C.SHIPTO_CODE                                       AS SHIPTO_CODE
                      , A.INCOTERMS                                         AS INCOTERMS
                      , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE C.END_CUSTOMER END  AS END_CUSTOMER
                      , CASE WHEN A.DIVISION_ID = '40' THEN NULL ELSE A.PROJECT_CODE END            AS PROJECT_CODE
                      , A.PLANT_SITE_ID                                     AS PLANT_SITE_ID
                      , A.ITEM_ID                                           AS ITEM_ID
                      , CASE WHEN A.DIVISION_ID = '40' THEN NULL ELSE G.BIZ_TYPE END               AS BIZ_TYPE
                      , A.CURRENCY                                          AS CURRENCY
                      , SUBSTR(A.YYYYMMDD, 1, 6)                            AS PLAN_YYYYMM
                      , CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN NVL(A.QTY, 0) ELSE 0 END            AS SALES_QTY
                      , H.ITEM_UOM                                          AS ITEM_UOM
                      , NVL(B.PRICE, 0)                                     AS SALES_PRICE
                      , NVL(D.CELL_PER_MODULE, 0)                           AS CELL_PER_MODULE
                      , CASE WHEN NVL(D.CELL_PER_MODULE, 0) <> 0 THEN NVL(D.CELL_PER_CAR, 0) / NVL(D.CELL_PER_MODULE, 0) ELSE 0 END  AS MODULE_PER_CAR
                      , NVL(D.ATTRIBUTE8, 0)                                AS KWH_PER_CELL
                      , NVL(D.CELL_PER_CAR, 0)                              AS CELL_PER_CAR
                      , H.ENERGE                                            AS ENERGE
                      , CASE WHEN (A.DIVISION_ID = '40' AND NVL(A.CELL_PROD_SITE_ID, '-') = '-') THEN NVL(A.ATTRIBUTE2, '-') ELSE NVL(A.CELL_PROD_SITE_ID, '-') END  AS FROM_SITE_ID
                      , CASE WHEN A.MEASURE = 'Catch_Up' THEN NVL(A.QTY, 0) ELSE 0 END             AS CATCHUP_QTY
                      , A.MEASURE                                           AS MEASURE
                   FROM DM_PLN_SALES_PLAN_C A
                   LEFT OUTER JOIN GT_BPS_VERNO  Z ON A.DIVISION_ID = Z.DIVISION_ID
                   LEFT OUTER JOIN GT_BPS_VERSEQ Y ON A.DIVISION_ID = Y.DIVISION_ID
                   LEFT OUTER JOIN GT_BPS_SITE   C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
                   LEFT OUTER JOIN SCM_MST_SITE_ITEM D
                     ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
--                   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO SU                                     -- 2026.09.06 AJS
--                     ON SU.USER_ID = TRIM(REGEXP_SUBSTR(D.OWNER, '[^,]+', 1, 1))                 -- 2026.09.06 AJS
                   LEFT OUTER JOIN SCM_MST_PROJECT G ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
                   LEFT OUTER JOIN ( SELECT T1.DIVISION_ID, T1.ITEM_ID, MAX(T1.ITEM_UOM) AS ITEM_UOM, MAX(T1.ENERGE) AS ENERGE
                                       FROM SCM_MST_ITEM_SN T1
                                      GROUP BY T1.DIVISION_ID, T1.ITEM_ID ) H
                     ON A.DIVISION_ID = H.DIVISION_ID AND A.ITEM_ID = H.ITEM_ID
                   LEFT OUTER JOIN SCM_SYS_CALENDAR_M F ON A.YYYYMMDD = F.BASIS_YYYYMMDD
                   LEFT OUTER JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP
                                          , A.FCST_TYPE, A.CURRENCY, A.MEASURE, A.YYYYMMDD, A.PRICE, A.CELL_PROD_SITE_ID
                                       FROM GT_BPS_PRICE A
                                       LEFT OUTER JOIN GT_BPS_VERNO Z ON A.DIVISION_ID = Z.DIVISION_ID
                                      WHERE A.YYYYMMDD >= Z.TO_YYYYMMDD_R
                                        AND A.YYYYMMDD <= V_TO_YYYYMMDD
                                        AND A.MEASURE = 'LOC'
                                        AND A.VERSION_NO = Z.VERSION_NO ) B
                     ON  A.DIVISION_ID = B.DIVISION_ID
                     AND A.PROJECT_CODE = CASE WHEN B.DIVISION_ID = '40' THEN B.END_CUSTOMER ELSE B.PROJECT_CODE END
                     AND A.SCM_SITE_ID = B.SCM_SITE_ID
                     AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                     AND A.ITEM_ID = B.ITEM_ID
                     AND A.INCOTERMS = B.INCOTERMS
                     AND A.DOM_EXP = B.DOM_EXP
                     AND A.FCST_TYPE = B.FCST_TYPE
                     AND A.CURRENCY = B.CURRENCY
                     AND F.BASIS_START_DATE = B.YYYYMMDD
                  WHERE A.YYYYMMDD >= Z.TO_YYYYMMDD_R
                    AND A.YYYYMMDD <= V_TO_YYYYMMDD
                    AND A.MEASURE = 'RTF_SYS_RP'
                    AND A.QTY <> 0
                    AND NVL(B.PRICE, 0) <> 0
                    AND A.VERSION_NO = Z.VERSION_NO
                    AND CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END
                      = CASE WHEN A.DIVISION_ID = '40' THEN B.CELL_PROD_SITE_ID ELSE '-' END
                 UNION ALL
                 /* (2) DM_PLN_SALES_ETC_PLAN_C : Catch_Up */
                 SELECT SUBSTR(A.CUTOFF_YYYYMMDD, 1, 6)                     AS CUTOFF_YYYYMM
                      , Z.VERSION_NO_T || NVL(Y.VERSION_SEQ, '01')          AS VERSION_NO
                      , Z.ISO_WEEK                                          AS CUTOFF_ISO_WEEK
                      , A.CUTOFF_YYYYMMDD                                   AS CUTOFF_YYYYMMDD
                      , A.DIVISION_ID                                       AS DIVISION_ID
--                      , SU.DEPT_ID                                          AS DEPT_ID
                      , D.DEPT_ID                                          AS DEPT_ID   -- 2026.09.03 AJS
                      , A.SCM_SITE_ID                                       AS SCM_SITE_ID
                      , A.FCST_TYPE                                         AS FCST_TYPE
                      , D.SALES_COMPANY                                     AS COMPANY_ID
                      , D.SALES_PLANT                                       AS SALES_PLANT
                      , C.SOLDTO_CODE                                       AS SOLDTO_CODE
                      , C.SHIPTO_CODE                                       AS SHIPTO_CODE
                      , A.INCOTERMS                                         AS INCOTERMS
                      , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE C.END_CUSTOMER END  AS END_CUSTOMER
                      , CASE WHEN A.DIVISION_ID = '40' THEN NULL ELSE A.PROJECT_CODE END            AS PROJECT_CODE
                      , A.PLANT_SITE_ID                                     AS PLANT_SITE_ID
                      , A.ITEM_ID                                           AS ITEM_ID
                      , CASE WHEN A.DIVISION_ID = '40' THEN NULL ELSE G.BIZ_TYPE END               AS BIZ_TYPE
                      , A.CURRENCY                                          AS CURRENCY
                      , SUBSTR(A.YYYYMMDD, 1, 6)                            AS PLAN_YYYYMM
                      , CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN NVL(A.QTY, 0) ELSE 0 END            AS SALES_QTY
                      , H.ITEM_UOM                                          AS ITEM_UOM
                      , NVL(B.PRICE, 0)                                     AS SALES_PRICE
                      , NVL(D.CELL_PER_MODULE, 0)                           AS CELL_PER_MODULE
                      , CASE WHEN NVL(D.CELL_PER_MODULE, 0) <> 0 THEN NVL(D.CELL_PER_CAR, 0) / NVL(D.CELL_PER_MODULE, 0) ELSE 0 END  AS MODULE_PER_CAR
                      , NVL(D.ATTRIBUTE8, 0)                                AS KWH_PER_CELL
                      , NVL(D.CELL_PER_CAR, 0)                              AS CELL_PER_CAR
                      , H.ENERGE                                            AS ENERGE
                      , '-'                                                 AS FROM_SITE_ID
                      , CASE WHEN A.MEASURE = 'Catch_Up' THEN NVL(A.QTY, 0) ELSE 0 END             AS CATCHUP_QTY
                      , A.MEASURE                                           AS MEASURE
                   FROM DM_PLN_SALES_ETC_PLAN_C A
                   LEFT OUTER JOIN GT_BPS_VERNO  Z ON A.DIVISION_ID = Z.DIVISION_ID
                   LEFT OUTER JOIN GT_BPS_VERSEQ Y ON A.DIVISION_ID = Y.DIVISION_ID
                   LEFT OUTER JOIN GT_BPS_SITE   C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
                   LEFT OUTER JOIN SCM_MST_SITE_ITEM D
                     ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
--                   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO SU                                     -- 2026.09.06 AJS
--                     ON SU.USER_ID = TRIM(REGEXP_SUBSTR(D.OWNER, '[^,]+', 1, 1))                 -- 2026.09.06 AJS
                   LEFT OUTER JOIN SCM_MST_PROJECT G ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
                   LEFT OUTER JOIN ( SELECT T1.DIVISION_ID, T1.ITEM_ID, MAX(T1.ITEM_UOM) AS ITEM_UOM, MAX(T1.ENERGE) AS ENERGE
                                       FROM SCM_MST_ITEM_SN T1
                                      GROUP BY T1.DIVISION_ID, T1.ITEM_ID ) H
                     ON A.DIVISION_ID = H.DIVISION_ID AND A.ITEM_ID = H.ITEM_ID
                   LEFT OUTER JOIN SCM_SYS_CALENDAR_M F ON A.YYYYMMDD = F.BASIS_YYYYMMDD
                   LEFT OUTER JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP
                                          , A.FCST_TYPE, A.CURRENCY, A.MEASURE, A.YYYYMMDD, A.PRICE
                                       FROM SCM_MST_FUTURE_PRICE_C A
                                       LEFT OUTER JOIN GT_BPS_VERNO Z ON A.DIVISION_ID = Z.DIVISION_ID
                                      WHERE A.YYYYMMDD >= Z.TO_YYYYMMDD_R
                                        AND A.YYYYMMDD <= V_TO_YYYYMMDD
                                        AND A.MEASURE = 'LOC'
                                        AND A.VERSION_NO = Z.VERSION_NO ) B
                     ON  A.DIVISION_ID = B.DIVISION_ID
                     AND A.PROJECT_CODE = B.PROJECT_CODE
                     AND A.SCM_SITE_ID = B.SCM_SITE_ID
                     AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                     AND A.ITEM_ID = B.ITEM_ID
                     AND A.INCOTERMS = B.INCOTERMS
                     AND A.DOM_EXP = B.DOM_EXP
                     AND A.FCST_TYPE = B.FCST_TYPE
                     AND A.CURRENCY = B.CURRENCY
                     AND F.BASIS_START_DATE = B.YYYYMMDD
                  WHERE A.YYYYMMDD >= Z.TO_YYYYMMDD_R
                    AND A.YYYYMMDD <= V_TO_YYYYMMDD
                    AND A.MEASURE = 'Catch_Up'
                    AND A.QTY <> 0
                    AND NVL(B.PRICE, 0) <> 0
                    AND A.VERSION_NO = Z.VERSION_NO
                 UNION ALL
                 /* (3) DM_PLN_SALES_PLAN_RESULT_C : 실적 (단가 = SALESAMT_LOC / RTF_SYS_RP) */
                 SELECT SUBSTR(A.CUTOFF_YYYYMMDD, 1, 6)                     AS CUTOFF_YYYYMM
                      , Z.VERSION_NO_T || NVL(Y.VERSION_SEQ, '01')          AS VERSION_NO
                      , Z.ISO_WEEK                                          AS CUTOFF_ISO_WEEK
                      , A.CUTOFF_YYYYMMDD                                   AS CUTOFF_YYYYMMDD
                      , A.DIVISION_ID                                       AS DIVISION_ID
--                      , SU.DEPT_ID                                          AS DEPT_ID
                      , D.DEPT_ID                                          AS DEPT_ID   -- 2026.09.03 AJS
                      , A.SCM_SITE_ID                                       AS SCM_SITE_ID
                      , A.FCST_TYPE                                         AS FCST_TYPE
                      , A.COMPANY_ID                                        AS COMPANY_ID
                      , D.SALES_PLANT                                       AS SALES_PLANT
                      , C.SOLDTO_CODE                                       AS SOLDTO_CODE
                      , C.SHIPTO_CODE                                       AS SHIPTO_CODE
                      , A.INCOTERMS                                         AS INCOTERMS
                      , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE C.END_CUSTOMER END  AS END_CUSTOMER
                      , CASE WHEN A.DIVISION_ID = '40' THEN NULL ELSE A.PROJECT_CODE END            AS PROJECT_CODE
                      , A.PLANT_SITE_ID                                     AS PLANT_SITE_ID
                      , A.ITEM_ID                                           AS ITEM_ID
                      , CASE WHEN A.DIVISION_ID = '40' THEN NULL ELSE G.BIZ_TYPE END               AS BIZ_TYPE
                      , A.CURRENCY                                          AS CURRENCY
                      , SUBSTR(A.YYYYMMDD, 1, 6)                            AS PLAN_YYYYMM
                      , A.QTY                                               AS SALES_QTY
                      , H.ITEM_UOM                                          AS ITEM_UOM
                      , NVL(B.PRICE, 0)                                     AS SALES_PRICE
                      , NVL(D.CELL_PER_MODULE, 0)                           AS CELL_PER_MODULE
                      , CASE WHEN NVL(D.CELL_PER_MODULE, 0) <> 0 THEN NVL(D.CELL_PER_CAR, 0) / NVL(D.CELL_PER_MODULE, 0) ELSE 0 END  AS MODULE_PER_CAR
                      , NVL(D.ATTRIBUTE8, 0)                                AS KWH_PER_CELL
                      , NVL(D.CELL_PER_CAR, 0)                              AS CELL_PER_CAR
                      , H.ENERGE                                            AS ENERGE
                      , NVL(A.CELL_PROD_SITE_ID, '-')                       AS FROM_SITE_ID
                      , 0                                                   AS CATCHUP_QTY
                      , A.MEASURE                                           AS MEASURE
                   FROM DM_PLN_SALES_PLAN_RESULT_C A
                   LEFT OUTER JOIN GT_BPS_VERNO  Z ON A.DIVISION_ID = Z.DIVISION_ID
                   LEFT OUTER JOIN GT_BPS_VERSEQ Y ON A.DIVISION_ID = Y.DIVISION_ID
                   LEFT OUTER JOIN GT_BPS_SITE   C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
                   LEFT OUTER JOIN SCM_MST_SITE_ITEM D
                     ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
--                   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO SU                                     -- 2026.09.06 AJS
--                     ON SU.USER_ID = TRIM(REGEXP_SUBSTR(D.OWNER, '[^,]+', 1, 1))                 -- 2026.09.06 AJS
                   LEFT OUTER JOIN SCM_MST_PROJECT G ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
                   LEFT OUTER JOIN ( SELECT T1.DIVISION_ID, T1.ITEM_ID, MAX(T1.ITEM_UOM) AS ITEM_UOM, MAX(T1.ENERGE) AS ENERGE
                                       FROM SCM_MST_ITEM_SN T1
                                      GROUP BY T1.DIVISION_ID, T1.ITEM_ID ) H
                     ON A.DIVISION_ID = H.DIVISION_ID AND A.ITEM_ID = H.ITEM_ID
                   LEFT OUTER JOIN SCM_SYS_CALENDAR_M F ON A.YYYYMMDD = F.BASIS_YYYYMMDD
                   LEFT OUTER JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
                                          , A.CURRENCY, A.YYYYMMDD, A.CELL_PROD_SITE_ID
                                          , (A.SUM_QTY / B.SUM_QTY) AS PRICE
                                       FROM ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
                                                   , A.CURRENCY, A.YYYYMMDD, A.CELL_PROD_SITE_ID, SUM(A.QTY) AS SUM_QTY
                                                FROM DM_PLN_SALES_PLAN_RESULT_C A
                                                LEFT OUTER JOIN GT_BPS_VERNO Z ON A.DIVISION_ID = Z.DIVISION_ID
                                               WHERE 1 = 1
                                                 AND A.VERSION_NO = Z.VERSION_NO
                                                 AND A.YYYYMMDD >= V_FROM_YYYYMMDD
--                                               AND A.MEASURE IN ('SALESAMT_LOC')   --  2026.10.08 AJS
                                                 AND A.MEASURE IN ('SalesAmt_LOC')   --  2026.10.08 AJS
                                               GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
                                                   , A.CURRENCY, A.YYYYMMDD, A.CELL_PROD_SITE_ID ) A
                                       INNER JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
                                                         , A.CURRENCY, A.YYYYMMDD, A.CELL_PROD_SITE_ID, SUM(A.QTY) AS SUM_QTY
                                                      FROM DM_PLN_SALES_PLAN_RESULT_C A
                                                      LEFT OUTER JOIN GT_BPS_VERNO Z ON A.DIVISION_ID = Z.DIVISION_ID
                                                     WHERE 1 = 1
                                                       AND A.VERSION_NO = Z.VERSION_NO
                                                       AND A.YYYYMMDD >= V_FROM_YYYYMMDD
                                                       AND A.MEASURE IN ('RTF_SYS_RP')
                                                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
                                                         , A.CURRENCY, A.YYYYMMDD, A.CELL_PROD_SITE_ID ) B
                                         ON  A.DIVISION_ID = B.DIVISION_ID
                                         AND A.PROJECT_CODE = B.PROJECT_CODE
                                         AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                         AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                         AND A.ITEM_ID = B.ITEM_ID
                                         AND A.INCOTERMS = B.INCOTERMS
                                         AND A.DOM_EXP = B.DOM_EXP
                                         AND A.FCST_TYPE = B.FCST_TYPE
                                         AND A.CURRENCY = B.CURRENCY
                                         AND A.YYYYMMDD = B.YYYYMMDD
                                         AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                                      WHERE B.SUM_QTY != 0 ) B
                     ON  A.DIVISION_ID = B.DIVISION_ID
                     AND A.PROJECT_CODE = B.PROJECT_CODE
                     AND A.SCM_SITE_ID = B.SCM_SITE_ID
                     AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                     AND A.ITEM_ID = B.ITEM_ID
                     AND A.INCOTERMS = B.INCOTERMS
                     AND A.DOM_EXP = B.DOM_EXP
                     AND A.FCST_TYPE = B.FCST_TYPE
                     AND A.CURRENCY = B.CURRENCY
                     AND A.YYYYMMDD = B.YYYYMMDD
                     AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                  WHERE A.YYYYMMDD >= V_FROM_YYYYMMDD
                    AND A.YYYYMMDD < V_TO_YYYYMMDD
                    AND A.MEASURE = 'RTF_SYS_RP'
                    AND A.QTY <> 0
                    AND NVL(B.PRICE, 0) <> 0
                    AND A.VERSION_NO = Z.VERSION_NO ) T1
          LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO T2 ON T1.DEPT_ID = T2.DEPT_ID
          LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T3 ON T1.FCST_TYPE = T3.SEGMENT1 AND T3.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND T3.VALID_YN = 'Y'
          LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T4 ON T1.BIZ_TYPE = T4.SEGMENT1 AND T4.LOOKUP_TYPE = 'BIZ_TYPE_BPMS' AND T4.VALID_YN = 'Y'
         WHERE CASE WHEN T1.MEASURE = 'RTF_SYS_RP' THEN ROUND(T1.SALES_QTY, 5) ELSE 1 END <> 0
         GROUP BY T1.CUTOFF_YYYYMM
                , T1.VERSION_NO
                , T1.CUTOFF_ISO_WEEK
                , T1.CUTOFF_YYYYMMDD
                , T1.DIVISION_ID
                , T1.DEPT_ID
                , T2.DEPT_NAME_KO
                , T1.SCM_SITE_ID
                , T1.FCST_TYPE
                , T3.SEGMENT2
                , T1.COMPANY_ID
                , T1.SALES_PLANT
                , T1.SOLDTO_CODE
                , T1.SHIPTO_CODE
                , T1.END_CUSTOMER
                , T1.INCOTERMS
                , T1.PROJECT_CODE
                , T1.PLANT_SITE_ID
                , T1.ITEM_ID
                , T1.BIZ_TYPE
                , T4.SEGMENT2
                , T1.CURRENCY
                , T1.PLAN_YYYYMM
                , T1.ITEM_UOM
                , T1.CELL_PER_MODULE
                , T1.MODULE_PER_CAR
                , T1.KWH_PER_CELL
                , T1.CELL_PER_CAR
                , T1.ENERGE
                , T1.FROM_SITE_ID
         ORDER BY T1.DIVISION_ID, T1.DEPT_ID, T1.SCM_SITE_ID, T1.PROJECT_CODE, T1.ITEM_ID;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;

    /* 종료 LOG (END) */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'PR_DM_BATCH_IF:' || P_DIVISION_ID || '/' || P_CUT_OFF_VERSION;
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
END;