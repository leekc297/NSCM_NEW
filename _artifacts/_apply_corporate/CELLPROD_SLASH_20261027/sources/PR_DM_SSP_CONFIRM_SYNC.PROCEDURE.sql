PROCEDURE PR_DM_SSP_CONFIRM_SYNC
(
    P_DIVISION_ID   IN  VARCHAR2                                                /* 사업부 확장에 대비해서 사업부별로 호출하도록 한다. */
   ,P_CONFIRM_ID    IN  VARCHAR2                                                /* CONFIRM 된 CONFIRM_ID 를 ^ 로 묶은 값 */
)
IS
/*
 *===================================================================================================
 * PROGRAM ID   : PR_DM_SSP_CONFIRM_SYNC
 * DESCRIPTION  : SSP에서 SHIPMENT CHANGE REQUEST 가 CONFIRM 되었을 때 DM 에서 동기화시켜주는 역할
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *===================================================================================================
 * 2020.09.16    HWI1993     INITIAL RELEASE [C20200804-000123]업무 정확도 향상을 위한 MKT FCST - SSP 동기화 기능 추가
 * 2021.01.08    HWI1993     INITIAL RELEASE [C20200804-000123]업무 정확도 향상을 위한 MKT FCST - SSP 동기화 기능 추가
 * 2021.01.14	 HWI1993	[C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( ATP 메저 보완 )
 * 2021.01.25	 KUNI		[C20210126-000023] [SCMPI팀] 소형 MKT FCST & SSP 동기화 시 내/외수 구분자 개선 요청건
 * 2021.02.09	 P.C.I 		   [C20210225-000385] 업데이트 된 CONFIRM 기준으로 동기화 적용
 * 2021.04.20	 P.C.I 		   [C20210420-000162] 매출실적이 없는 데이터만 동기화 대상으로 적용(네팅)
 * 2021.05.26	 P.C.I 		   [C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일)
 * 2021.07.01	HWI1993		[C20210625-000103] SSP - DM 연동 로직 수정 요청의 건
 * 2021.08.24	hwi1993		[pj20209643] bod 유효기간 추가 건
 * 2021.11.23	hwi1993		[C20211122-000433] GSCM SSP - DM간 동기화 대상 중 Pack 제외 요청의 건
 							[C20211122-000007]SSP-DM 사내 플랜트 동기화건 수정 요청의 건
 * 2022.07.11	hwi1993		[C20220707-000107] MKT FCST 입력 오류건(carry over 중복오류 )
 * 2022.07.11	hwi1993		[C20220704-000441] 소형수요 간소화 - dom_exp 를 e 로 고정
 * 2022.07.18	hwi1993		[C20220707-000107]	추가 - change_type 조건 추가 ( 'N':신규생성중, 'C':확정, 'P':계획 -- 현재 미사용)
 * 2022.07.27   SSP Pjt.    SHIP_CONFIRM_ROUTE 입력 : 출하확정계획물류경로기본 SSP_ANL_SHIP_CONFIRM_ROUTE
 * 2022.08.29	rosia27		[C20220809-000013] SSP-DM 동기화 로직 정비 요청의 건
 * 2023.02.27   chano0612   LOOKUP 세팅 LOOP 해결
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 *===================================================================================================
*/
    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'PR_DM_SSP_CONFIRM_SYNC';
    V_LOG_TYPE                  VARCHAR2(30 CHAR);                              /* START/END/ERROR/... */
    N_LOG_COUNT                 NUMBER := 0;
    V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
    V_DESCRIPTION               VARCHAR2(500 CHAR);
    D_EVENT_DATE                DATE;
    V_SYNC_DAY_CNT              NUMBER;                                         /* 동기화 구간 */
    V_START_YYYYMMDD            VARCHAR2(8 CHAR);
    V_END_YYYYMMDD              VARCHAR2(8 CHAR);
    V_DIVISION_ID               VARCHAR2(30 CHAR);
    /* 네팅 기간 */
    V_NET_START_YYYYMMDD        VARCHAR2(8 CHAR);
    V_NET_END_YYYYMMDD          VARCHAR2(8 CHAR);
    V_RESULT_START_YYYYMMDD     VARCHAR2(8 CHAR);                               /* [C20210225-000385] */
    V_CARRY_YYYYMMDD            VARCHAR2(8 CHAR);
    V_WEEK_DAY                  NUMBER;
    V_HH                        NUMBER;
    V_MI                        NUMBER;
BEGIN

    /* SHIP_CONFIRM_ROUTE 입력 : 출하확정계획물류경로기본 SSP_ANL_SHIP_CONFIRM_ROUTE */
    PR_SSP_ANL_SHIP_CONFIRM_ROUTE(P_CONFIRM_ID, NULL);

    /* 월요일에만 동작함. ( 개발에서 테스트때문에 조건 제거함 ) */
    /* 원문 DATEPART(WEEKDAY) 월=2 판정 : 기준일이 그 주 월요일인지로 옮긴다 */
    V_WEEK_DAY := TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW');
    V_HH := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
    V_MI := TO_NUMBER(TO_CHAR(SYSDATE, 'MI'));

    /* [C20210225-000385] 월요일 7:50 이전, 월요일 23:55 이후는 동기화 안됨 */
    IF V_WEEK_DAY <> 0
    OR ((V_HH <= 7 AND V_MI < 50)
     OR (V_HH = 23 AND V_MI > 55)) THEN
        RETURN;
    END IF;

    IF P_DIVISION_ID NOT LIKE '%40%' THEN
        RETURN;
    END IF;

    /* 시작 LOG */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := P_CONFIRM_ID;
    D_EVENT_DATE := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* 시작 LOG  (END) */
    V_LOG_MESSAGE := NULL;

    DELETE FROM GT_DM_SYNC_CONFIRM_ID;
    DELETE FROM GT_DM_SYNC_SSP;
    DELETE FROM GT_DM_SYNC_SSP_SUM;
    DELETE FROM GT_DM_SYNC_MKT_RESULT;
    DELETE FROM GT_DM_SYNC_MKT_RES_SUM;
    DELETE FROM GT_DM_SYNC_SHIP_RESULT;
    DELETE FROM GT_DM_SYNC_SALES_RESULT;
    DELETE FROM GT_DM_SYNC_CFM_MKT_FCST;

    BEGIN
        SELECT TOKEN
          INTO V_DIVISION_ID
          FROM (SELECT TOKEN
                  FROM TABLE(UF_FX_STRING_SPLIT(P_DIVISION_ID, '^'))
                 WHERE TOKEN IS NOT NULL)
         WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_DIVISION_ID := NULL;
    END;

    V_SYNC_DAY_CNT := 0;

    BEGIN
        SELECT TO_NUMBER(SEGMENT2 DEFAULT NULL ON CONVERSION ERROR)
             , TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')             /* 동기화구간 ( 금주월요일 부터 시작 ) */
          INTO V_SYNC_DAY_CNT
             , V_START_YYYYMMDD
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'DM_SSP_SYNC_OPTION'
           AND SEGMENT1 = V_DIVISION_ID
           AND VALID_YN = 'Y'
           AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_SYNC_DAY_CNT := NULL;
    END;

    IF (V_SYNC_DAY_CNT IS NULL OR V_SYNC_DAY_CNT < 1) THEN

        /* LOOKUP 정보가 없습니다. */
        V_LOG_TYPE := 'END';
        V_DESCRIPTION := 'LOOKUP 정보가 없습니다.';
        V_LOG_MESSAGE := '########## END OF PROCEDURE ##########';
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        RETURN;

    END IF;

    V_END_YYYYMMDD := TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') + (V_SYNC_DAY_CNT - 1), 'YYYYMMDD');

    /* [C20210225-000385] 실적 기준 Start YYYYMMDD (전월1일/1일은 전전월1일) */
    V_RESULT_START_YYYYMMDD := TO_CHAR(ADD_MONTHS(SYSDATE, CASE WHEN TO_CHAR(SYSDATE, 'MM') = '01' THEN -2 ELSE -1 END), 'YYYYMM') || '01';

    /* [C20210225-000385] 네팅 구간은 실적일 부터 적용 */
    V_NET_START_YYYYMMDD := V_RESULT_START_YYYYMMDD;
    V_NET_END_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7 - 1, 'YYYYMMDD');
    V_CARRY_YYYYMMDD := TO_CHAR(TO_DATE(V_NET_END_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');   /* 오늘 ( 첫번째 계획구간 일자) */

    INSERT INTO GT_DM_SYNC_CONFIRM_ID
    (
        DIVISION_ID
      , CONFIRM_ID
    )
    SELECT A.TOKEN AS DIVISION_ID
         , B.TOKEN AS CONFIRM_ID
      FROM TABLE(UF_FX_STRING_SPLIT(P_DIVISION_ID, '^')) A
         , TABLE(UF_FX_STRING_SPLIT(P_CONFIRM_ID, '^')) B
     WHERE A.NR = B.NR;

    SAVEPOINT SALES_SITE_MODEL_PRODUCTION;

    /*---------------------------------------------------------------------------------------------
    -- Start[C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 데이터 생성
    -- MKT Fcst Key/Confirm ID/SO_NO/Plan_qty/Result_QTY 관리
    ---------------------------------------------------------------------------------------------*/
    DELETE FROM DM_PLN_MKT_FCST_CONFIRM A
     WHERE EXISTS (SELECT 1
                     FROM GT_DM_SYNC_CONFIRM_ID SA
                    WHERE A.DIVISION_ID = SA.DIVISION_ID
                      AND A.CONFIRM_ID = SA.CONFIRM_ID)
       AND A.DIVISION_ID = V_DIVISION_ID
       AND (A.ETA BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
        OR A.SHIP_YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD); /* [C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일) */

    INSERT INTO DM_PLN_MKT_FCST_CONFIRM
    (
        DIVISION_ID, CONFIRM_ID, SO_NO
      , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ETA, PLAN_QTY
      , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, SHIP_YYYYMMDD                     /* [C20210528-000332] SHIP_YYYYMMDD 출하계획일 */
    )
    SELECT A.DIVISION_ID
         , A.CONFIRM_ID
         , NVL(A.ERP_SO_NO, 'X')
         , A.PROJECT_CODE
         , A.TO_SITE
         , A.ITEM_ID
         , 'E' AS DOM_EXP
         , A.FCST_TYPE
         , B.INCOTERMS
         , '' AS PLANT_SITE_ID
         , A.ETA_DATE AS ETA
         , SUM(A.QTY) AS CONFIRM_QTY
         , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
         , A.YYYYMMDD AS SHIP_YYYYMMDD
      FROM SSP_ANL_SHIP_CONFIRM A
         , SCP_MST_BOD_N_V B
         , SCP_MST_DISTRIBUTION_ROUTE C
         , GT_DM_SYNC_CONFIRM_ID D
         , SCM_MST_SITE E
     WHERE A.DIVISION_ID = B.DIVISION_ID
       AND A.BOD_ID = B.BOD_ID
       AND C.ROUTE_ID = B.ROUTE_ID
       AND A.DIVISION_ID = D.DIVISION_ID
       AND A.CONFIRM_ID = D.CONFIRM_ID
       AND A.DIVISION_ID = E.DIVISION_ID
       AND A.TO_SITE = E.SCM_SITE_ID
       AND E.SITE_TYPE = 'SALES'
       AND EXISTS (SELECT 1
                     FROM DM_MST_ITEM_SINGLE_V SA
                    WHERE SA.DIVISION_ID = A.DIVISION_ID
                      AND SA.ITEM_ID = A.ITEM_ID
                      AND SA.FORECAST_INFO_BIZ_TYPE IS NOT NULL)                /* [C20210225-000385] 전극대상은 동기화에서 제외 */
       AND (A.YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
        OR A.ETA_DATE BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD)       /* [C20210625-000103] */
       AND A.DIVISION_ID = V_DIVISION_ID
       AND A.FCST_TYPE <> '-'                                                   /* 문제임. MKT_FCST 없는 경우 */
       AND A.SHIPMENT_STATUS = 'C'
       AND A.BIZ_TYPE = 'A'                                                     /* [C20211122-000433] */
       AND A.CHANGE_TYPE = 'C'
     GROUP BY A.DIVISION_ID
            , A.CONFIRM_ID
            , A.ERP_SO_NO
            , A.PROJECT_CODE
            , A.TO_SITE
            , A.ITEM_ID
            , A.FCST_TYPE
            , B.INCOTERMS
            , A.ETA_DATE
            , A.YYYYMMDD;

    /* [C20220704-000441] 소형수요 간소화 - dom_exp 를 e 로 고정 */
    /* 문제임. DOM_EXP 못찾는 경우- 소형 영업관리에서 없는 건은 E로 하기로 함. */
    UPDATE DM_PLN_MKT_FCST_CONFIRM A
       SET A.DOM_EXP = 'E'
     WHERE EXISTS (SELECT 1
                     FROM GT_DM_SYNC_CONFIRM_ID SA
                    WHERE A.DIVISION_ID = SA.DIVISION_ID
                      AND A.CONFIRM_ID = SA.CONFIRM_ID)
       AND A.DOM_EXP IS NULL
       AND A.DIVISION_ID = V_DIVISION_ID
       AND (A.SHIP_YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
        OR A.ETA BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD);           /* [C20210625-000103] */

    /* Confrim ID/SO_NO 기준으로 출하 실적 업데이트 */
    /* DOC_TYPE : D10 생성, D20 공장출고, D30 운송중 재고, D40 매출, D90 삭제 */
    INSERT INTO GT_DM_SYNC_SHIP_RESULT
    (
        DIVISION_ID
      , CONFIRM_ID
      , SO_NO
      , ITEM_ID
      , SHIP_RESULT_QTY
    )
    SELECT A.DIVISION_ID
         , A.CONFIRM_ID
         , LPAD(RTRIM(A.ORDER_NO), 10, '0') AS SO_NO
         , A.ITEM_ID
         , SUM(A.EXFACTORY_QTY) AS SHIP_RESULT_QTY
      FROM SCM_DNM_EXFACTORY_RESULT A
         , SCM_ADM_LOOKUP_MASTER_DETAIL B
         , GT_DM_SYNC_CONFIRM_ID C
     WHERE B.LOOKUP_TYPE = 'ERP_SSP_TYPE'                                       /* LOOKUP에 등록된 공정만 */
       AND B.VALID_YN = 'Y'
       AND B.SEGMENT1 = A.SSP_TYPE
       AND A.DIVISION_ID = C.DIVISION_ID
       AND A.CONFIRM_ID = C.CONFIRM_ID
       AND NVL(A.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')                 /* D90: DO삭제 , D10:DO생성 */
       AND A.DIVISION_ID = V_DIVISION_ID
       AND A.CONFIRM_ID LIKE 'C%'
       AND A.EXFACTORY_DATE BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
       AND A.ORDER_TYPE_CODE NOT IN ('ZKM', 'ZKN')                              /* 소형마케팅에서 ORDER_TYPE을 다르게 선택하여 SO_NO가 달라서 사용 불가능 함 */
     GROUP BY A.DIVISION_ID, A.CONFIRM_ID, A.ORDER_NO, A.ITEM_ID;

    /* SCM_DNM_EXFACTORY_RESULT SO_NO 출하 실적 데이터 UPDATE */
    UPDATE DM_PLN_MKT_FCST_CONFIRM A
       SET (A.SHIP_RESULT_QTY, A.PLAN_QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE) =
           (SELECT SA.SHIP_RESULT_QTY
                 , CASE WHEN A.PLAN_QTY <> SA.SHIP_RESULT_QTY THEN SA.SHIP_RESULT_QTY ELSE A.PLAN_QTY END   /* 출하 실적 QTY 기준으로 Plan 맞춤 */
                 , 'SYSTEM_RESULT'
                 , SYSDATE
              FROM GT_DM_SYNC_SHIP_RESULT SA
             WHERE SA.DIVISION_ID = A.DIVISION_ID
               AND SA.SO_NO = A.SO_NO
               AND SA.ITEM_ID = A.ITEM_ID
               AND ROWNUM = 1)
     WHERE EXISTS (SELECT 1
                     FROM GT_DM_SYNC_SHIP_RESULT SA
                    WHERE SA.DIVISION_ID = A.DIVISION_ID
                      AND SA.SO_NO = A.SO_NO
                      AND SA.ITEM_ID = A.ITEM_ID)
       AND EXISTS (SELECT 1
                     FROM GT_DM_SYNC_CONFIRM_ID SA
                    WHERE A.DIVISION_ID = SA.DIVISION_ID
                      AND A.CONFIRM_ID = SA.CONFIRM_ID)
       AND A.DIVISION_ID = V_DIVISION_ID
       AND A.SHIP_YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
       AND (A.SHIP_YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
        OR A.ETA BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD);           /* [C20210625-000103] */

    /* SO_NO 기준으로 매출 실적 업데이트 */
    INSERT INTO GT_DM_SYNC_SALES_RESULT
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, QTY, SO_NO, SO_QTY, SPLIT_SO_NO, SO_NO_NUM
      , SPLIT_SO_QTY, SO_QTY_NUM
    )
    SELECT IA.DIVISION_ID
         , IA.PROJECT_CODE
         , IA.SCM_SITE_ID
         , IA.ITEM_ID
         , IA.QTY
         , IA.SO_NO
         , IA.SO_QTY
         , LPAD(RTRIM(B.VALUE), 10, '0') AS SPLIT_SO_NO
         , B.ID AS SO_NO_NUM
         , TO_NUMBER(C.VALUE DEFAULT NULL ON CONVERSION ERROR) AS SPLIT_SO_QTY
         , C.ID AS SO_QTY_NUM
      /*---------------------------------------------------------------------------------------
      -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (CELL_PROD_SITE_ID와 무관하게 GROUP BY에 의해 SUM(QTY) 처리함.
      ---------------------------------------------------------------------------------------*/
      FROM (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                 , SO_NO, SO_QTY
                 , SUM(QTY) AS QTY
              FROM DM_PLN_MKT_FCST_RESULT
             WHERE DIVISION_ID = V_DIVISION_ID
               AND YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
               AND MEASURE IN ('RTF')
               AND QTY <> 0
             GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                    , SO_NO, SO_QTY) IA
         , TABLE(FN_SPLITSTRING(IA.SO_NO, ',')) B
         , TABLE(FN_SPLITSTRING(IA.SO_QTY, ',')) C
     WHERE C.VALUE IS NOT NULL                                                  /* 2022.09.12 */
       AND B.ID = C.ID;

    UPDATE GT_DM_SYNC_SALES_RESULT A
       SET A.CONFIRM_ID = (SELECT SA.CONFIRM_ID
                             FROM XIF_ERP_SHIP_DOC_R_SN SA
                            WHERE A.SPLIT_SO_NO = SA.DOC_NO
                              AND ROWNUM = 1)
     WHERE EXISTS (SELECT 1
                     FROM XIF_ERP_SHIP_DOC_R_SN SA
                    WHERE A.SPLIT_SO_NO = SA.DOC_NO);

    /* SO_NO 기준으로 매출 실적 업데이트 */
    UPDATE DM_PLN_MKT_FCST_CONFIRM A
       SET (A.SALES_RESULT_QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE) =
           (SELECT SA.QTY, 'SYSTEM_SALES_RESULT', SYSDATE
              FROM (SELECT XA.DIVISION_ID
                         , XA.SPLIT_SO_NO
                         , XA.ITEM_ID
                         , SUM(CAST(CASE WHEN NVL(XA.SPLIT_SO_QTY, 0) = 0 THEN 0 ELSE XA.SPLIT_SO_QTY END AS NUMBER(30, 0))) AS QTY
                      FROM GT_DM_SYNC_SALES_RESULT XA
                     WHERE XA.DIVISION_ID = V_DIVISION_ID
                     GROUP BY XA.DIVISION_ID, XA.SPLIT_SO_NO, XA.ITEM_ID) SA
             WHERE SA.DIVISION_ID = A.DIVISION_ID
               AND SA.SPLIT_SO_NO = A.SO_NO
               AND SA.ITEM_ID = A.ITEM_ID
               AND ROWNUM = 1)
     WHERE EXISTS (SELECT 1
                     FROM GT_DM_SYNC_SALES_RESULT SA
                    WHERE SA.DIVISION_ID = A.DIVISION_ID
                      AND SA.SPLIT_SO_NO = A.SO_NO
                      AND SA.ITEM_ID = A.ITEM_ID
                      AND SA.DIVISION_ID = V_DIVISION_ID)
       AND EXISTS (SELECT 1
                     FROM GT_DM_SYNC_CONFIRM_ID SA
                    WHERE A.DIVISION_ID = SA.DIVISION_ID
                      AND A.CONFIRM_ID = SA.CONFIRM_ID);

    /* CONFIRM_ID 기준으로 매출 실적 업데이트 */
    UPDATE DM_PLN_MKT_FCST_CONFIRM A
       SET (A.SALES_RESULT_QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE) =
           (SELECT SA.QTY, 'SYSTEM_SALES_RESULT', SYSDATE
              FROM (SELECT XA.DIVISION_ID
                         , XA.ITEM_ID
                         , XA.CONFIRM_ID
                         , SUM(CAST(CASE WHEN NVL(XA.SPLIT_SO_QTY, 0) = 0 THEN 0 ELSE XA.SPLIT_SO_QTY END AS NUMBER(30, 0))) AS QTY
                      FROM GT_DM_SYNC_SALES_RESULT XA
                     WHERE XA.DIVISION_ID = V_DIVISION_ID
                     GROUP BY XA.DIVISION_ID, XA.SPLIT_SO_NO, XA.ITEM_ID, XA.CONFIRM_ID) SA
             WHERE SA.DIVISION_ID = A.DIVISION_ID
               AND SA.ITEM_ID = A.ITEM_ID
               AND SA.CONFIRM_ID = A.CONFIRM_ID
               AND ROWNUM = 1)
     WHERE EXISTS (SELECT 1
                     FROM GT_DM_SYNC_SALES_RESULT SA
                    WHERE SA.DIVISION_ID = A.DIVISION_ID
                      AND SA.ITEM_ID = A.ITEM_ID
                      AND SA.CONFIRM_ID = A.CONFIRM_ID
                      AND SA.DIVISION_ID = V_DIVISION_ID)
       AND EXISTS (SELECT 1
                     FROM GT_DM_SYNC_CONFIRM_ID SA
                    WHERE A.DIVISION_ID = SA.DIVISION_ID
                      AND A.CONFIRM_ID = SA.CONFIRM_ID)
       AND A.SALES_RESULT_QTY IS NULL;

    /*---------------------------------------------------------------------------------------------
    -- 2. MKT FCST 와 join 해서 INSERT/UPDATE 한다.
    ---------------------------------------------------------------------------------------------*/
    /* [C20210225-000385] 업데이트 된 CONFIRM 으로 MKT FCST Key 값 기준으로 동기화 재수행 */
    INSERT INTO GT_DM_SYNC_CFM_MKT_FCST
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
    )
    SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
      FROM DM_PLN_MKT_FCST_CONFIRM A
         , GT_DM_SYNC_CONFIRM_ID B
     WHERE A.DIVISION_ID = B.DIVISION_ID
       AND A.CONFIRM_ID = B.CONFIRM_ID;

    INSERT INTO GT_DM_SYNC_SSP
    (
        DIVISION_ID, CONFIRM_ID
      , PROJECT_CODE, TO_SITE, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ETA, QTY
    )
    SELECT A.DIVISION_ID, A.CONFIRM_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.ETA, SUM(A.PLAN_QTY) AS QTY
      FROM DM_PLN_MKT_FCST_CONFIRM A                                            /* [C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 사용 */
         , GT_DM_SYNC_CFM_MKT_FCST B
     WHERE A.DIVISION_ID = B.DIVISION_ID
       AND A.PROJECT_CODE = B.PROJECT_CODE
       AND A.SCM_SITE_ID = B.SCM_SITE_ID
       AND A.ITEM_ID = B.ITEM_ID
       AND A.DOM_EXP = B.DOM_EXP
       AND A.FCST_TYPE = B.FCST_TYPE
       AND A.INCOTERMS = B.INCOTERMS
       AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
       AND A.DIVISION_ID = V_DIVISION_ID
       /* [C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일), SHIP_YYYYMMDD 출하계획일 */
       AND A.SHIP_YYYYMMDD BETWEEN V_START_YYYYMMDD AND V_END_YYYYMMDD
       AND A.ETA >= V_START_YYYYMMDD                                            /* [C20210528-000332] 매출계획일 당주이후 동기화 데이터 적용 */
       AND NVL(A.SALES_RESULT_QTY, 0) = 0                                       /* [C20210420-000162] 매출실적이 없는 데이터만 동기화 대상으로 적용(네팅) */
     GROUP BY A.DIVISION_ID, A.CONFIRM_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
            , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.ETA;

    /* [C20210225-000385] CONFIRM_ID 추가 — 원문은 100개 칸 피벗으로 합계·연결을 만든다.
       같은 결과가 되도록 합계와 목록 연결로 옮기고, 키마다 최대 100건이라는 한도는 그대로 둔다 */
    INSERT INTO GT_DM_SYNC_SSP_SUM
    (
        DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID
      , FCST_TYPE, INCOTERMS, ETA, DOM_EXP, QTY, CONFIRM_ID
    )
    SELECT IA.DIVISION_ID
         , IA.PROJECT_CODE
         , IA.TO_SITE
         , IA.ITEM_ID
         , IA.FCST_TYPE
         , IA.INCOTERMS
         , IA.ETA
         , IA.DOM_EXP
         , NVL(SUM(IA.QTY), 0) AS QTY
         , LISTAGG(IA.CONFIRM_ID, ',') WITHIN GROUP (ORDER BY IA.CONFIRM_ID) AS CONFIRM_ID
      FROM (SELECT A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.TO_SITE
                 , A.ITEM_ID
                 , A.FCST_TYPE
                 , A.INCOTERMS
                 , A.ETA
                 , A.DOM_EXP
                 , A.QTY
                 , A.CONFIRM_ID
                 , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.TO_SITE, A.ITEM_ID, A.FCST_TYPE, A.INCOTERMS, A.ETA, A.DOM_EXP
                                          ORDER BY A.CONFIRM_ID) AS RN
              FROM GT_DM_SYNC_SSP A) IA
     WHERE IA.RN <= 100                                                         /* 원문 피벗 한도 100개와 같게 */
     GROUP BY IA.DIVISION_ID, IA.PROJECT_CODE, IA.TO_SITE, IA.ITEM_ID, IA.FCST_TYPE, IA.INCOTERMS, IA.ETA, IA.DOM_EXP;

    /* [C20210225-000385] 동기화 데이터 삭제 */
    UPDATE DM_PLN_MKT_FCST A
       SET A.QTY = CASE WHEN A.QTY - TO_NUMBER(A.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR) - TO_NUMBER(A.ATTRIBUTE3 DEFAULT NULL ON CONVERSION ERROR) > 0 THEN A.QTY
                        ELSE TO_NUMBER(A.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR)
                   END
         , A.ATTRIBUTE3 = ''
         , A.ATTRIBUTE4 = ''
     WHERE EXISTS (SELECT 1
                     FROM GT_DM_SYNC_SSP_SUM SA
                    WHERE A.DIVISION_ID = SA.DIVISION_ID
                      AND A.PROJECT_CODE = SA.PROJECT_CODE
                      AND A.SCM_SITE_ID = SA.TO_SITE
                      AND A.ITEM_ID = SA.ITEM_ID
                      AND A.DOM_EXP = SA.DOM_EXP
                      AND A.FCST_TYPE = SA.FCST_TYPE
                      AND A.INCOTERMS = SA.INCOTERMS)
       AND A.DIVISION_ID = V_DIVISION_ID
       /* [C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일), 매출계획일 당주이후 동기화 데이터 삭제 */
       AND A.YYYYMMDD >= V_START_YYYYMMDD
       AND A.MEASURE = 'MKT_FCST'
       AND TO_NUMBER(A.ATTRIBUTE3 DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL;

    /* MKT FCST 테이블에 인서트/업데이트 — 배치 성격이라 원문과 같이 한 문장으로 둔다 */
    MERGE INTO DM_PLN_MKT_FCST A
    USING (SELECT DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ETA, QTY, CONFIRM_ID
             FROM GT_DM_SYNC_SSP_SUM) B
       ON (A.DIVISION_ID = B.DIVISION_ID
       AND A.PROJECT_CODE = B.PROJECT_CODE
       AND A.SCM_SITE_ID = B.TO_SITE
       AND A.ITEM_ID = B.ITEM_ID
       AND A.DOM_EXP = B.DOM_EXP
       AND A.FCST_TYPE = B.FCST_TYPE
       AND A.INCOTERMS = B.INCOTERMS
       AND A.YYYYMMDD = B.ETA
       AND A.MEASURE = 'MKT_FCST')
    WHEN MATCHED THEN
        UPDATE SET A.QTY = CASE WHEN TO_NUMBER(A.ATTRIBUTE3 DEFAULT NULL ON CONVERSION ERROR) > 0
                                 AND A.QTY = TO_NUMBER(A.ATTRIBUTE3 DEFAULT NULL ON CONVERSION ERROR)
                                THEN B.QTY
                                ELSE CASE WHEN A.QTY > B.QTY THEN A.QTY ELSE B.QTY END
                           END
                 , A.ATTRIBUTE1 = CASE WHEN TO_NUMBER(A.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL THEN A.ATTRIBUTE1
                                       ELSE TO_CHAR(A.QTY)
                                  END                                           /* 동기화 수량에는 mkt fcst수량을 넣는다. */
                 , A.ATTRIBUTE2 = NULL
                 , A.ATTRIBUTE3 = TO_CHAR(B.QTY)
                 , A.ATTRIBUTE4 = B.CONFIRM_ID                                  /* [C20210225-000385] CONFIRM_ID 추가 */
                 , A.LAST_UPDATED_BY = 'SSP_CONFIRM_SYNC'
                 , A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
              , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
              , A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
              , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
              , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10)
        VALUES (B.DIVISION_ID, B.PROJECT_CODE, B.TO_SITE, B.ITEM_ID, B.DOM_EXP
              , B.FCST_TYPE, B.INCOTERMS, 'MKT_FCST', '', B.ETA
              , B.QTY, 'SSP_CONFIRM_SYNC', SYSDATE, 'SSP_CONFIRM_SYNC', SYSDATE
              , '0', '', TO_CHAR(B.QTY), B.CONFIRM_ID, '', '', '', '', '', '');  /* [C20210225-000385] CONFIRM_ID 추가 */

    /*---------------------------------------------------------------------------------------------
    -- 3. 네팅 대상 데이터를 가져와서 복사본을 만든다.
    -- ATTRIBUTE1 에는 동기화+네팅수량, ATTRIBUTE2 에는 네팅수량을 넣는다. ( SYNC 를 여러번 돌릴 경우 네팅중복 방지 )
    ---------------------------------------------------------------------------------------------*/
    /* Start [C20210225-000385] MKT Result CONFIRM_ID - SO_NO 데이터로 변경
       Plan 컨펌값이 존재하는 데이터 중 출하일이 지났으나 Result(ERP)에 일치하는 값이 없을 경우 미실행으로 보고 동기화 데이터에서 제외 */
    INSERT INTO GT_DM_SYNC_MKT_RESULT
    (
        DIVISION_ID, CONFIRM_ID, SO_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
      , FCST_TYPE, INCOTERMS, QTY, ROW_NUM
    )
    SELECT IA.DIVISION_ID, IA.CONFIRM_ID, IA.SO_NO, IA.PROJECT_CODE, IA.SCM_SITE_ID, IA.ITEM_ID, IA.DOM_EXP, IA.FCST_TYPE, IA.INCOTERMS
         , IA.QTY
         , ROWNUM AS ROW_NUM
      FROM (SELECT A.DIVISION_ID, A.CONFIRM_ID, A.SO_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                 , SUM(NVL(A.PLAN_QTY, 0) - NVL(A.SALES_RESULT_QTY, 0)) AS QTY
              FROM DM_PLN_MKT_FCST_CONFIRM A
                 , GT_DM_SYNC_CFM_MKT_FCST B
             WHERE A.DIVISION_ID = B.DIVISION_ID
               AND A.PROJECT_CODE = B.PROJECT_CODE
               AND A.SCM_SITE_ID = B.SCM_SITE_ID
               AND A.ITEM_ID = B.ITEM_ID
               AND A.DOM_EXP = B.DOM_EXP
               AND A.FCST_TYPE = B.FCST_TYPE
               AND A.INCOTERMS = B.INCOTERMS
               AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
               AND A.DIVISION_ID = V_DIVISION_ID
               AND (A.SHIP_YYYYMMDD BETWEEN V_NET_START_YYYYMMDD AND V_END_YYYYMMDD
                OR A.ETA BETWEEN V_NET_START_YYYYMMDD AND V_END_YYYYMMDD)       /* [C20210625-000103] */
               AND NVL(A.SHIP_RESULT_QTY, 0) <> 0
             GROUP BY A.DIVISION_ID, A.CONFIRM_ID, A.SO_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
            HAVING SUM(NVL(A.PLAN_QTY, 0)) <> SUM(NVL(A.SALES_RESULT_QTY, 0))) IA;

    /* [C20220707-000107] 일반 동기화에 들어있는 confirm id 는 carry over 대상에서 제거함 */
    DELETE FROM GT_DM_SYNC_MKT_RESULT A
     WHERE EXISTS (SELECT 1
                     FROM GT_DM_SYNC_SSP SA
                    WHERE A.CONFIRM_ID = SA.CONFIRM_ID);

    /* [C20210225-000385] 실적이 계획보다 적게 들어온 경우 SUM */
    INSERT INTO GT_DM_SYNC_MKT_RES_SUM
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
      , FCST_TYPE, INCOTERMS, QTY, CONFIRM_ID, ROW_NUM
    )
    SELECT IA.DIVISION_ID
         , IA.PROJECT_CODE
         , IA.SCM_SITE_ID
         , IA.ITEM_ID
         , IA.DOM_EXP
         , IA.FCST_TYPE
         , IA.INCOTERMS
         , NVL(SUM(IA.QTY), 0) AS QTY
         , LISTAGG(IA.CONFIRM_ID, ',') WITHIN GROUP (ORDER BY IA.CONFIRM_ID) AS CONFIRM_ID
         , ROW_NUMBER() OVER (ORDER BY IA.DIVISION_ID, IA.PROJECT_CODE, IA.SCM_SITE_ID, IA.ITEM_ID, IA.DOM_EXP, IA.FCST_TYPE, IA.INCOTERMS) AS ROW_NUM
      FROM (SELECT A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.DOM_EXP
                 , A.FCST_TYPE
                 , A.INCOTERMS
                 , A.QTY
                 , A.CONFIRM_ID
                 , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP
                                          ORDER BY A.CONFIRM_ID) AS RN
              FROM GT_DM_SYNC_MKT_RESULT A) IA
     WHERE IA.RN <= 100                                                         /* 원문 피벗 한도 100개와 같게 */
     GROUP BY IA.DIVISION_ID, IA.PROJECT_CODE, IA.SCM_SITE_ID, IA.ITEM_ID, IA.DOM_EXP, IA.FCST_TYPE, IA.INCOTERMS;

    /* QTY 의 부호에 따라 순번을 세팅 — 실적이 덜 들어온 경우에 오늘 날짜에 캐리오버 */
    UPDATE GT_DM_SYNC_MKT_RES_SUM A
       SET A.SEQ = (SELECT SA.SEQ
                      FROM (SELECT ROW_NUM, ROW_NUMBER() OVER (ORDER BY QTY) AS SEQ
                              FROM GT_DM_SYNC_MKT_RES_SUM
                             WHERE QTY > 0) SA
                     WHERE SA.ROW_NUM = A.ROW_NUM)
     WHERE A.QTY > 0;

    /* 실적이 더 들어온 경우에 미래 계획구간 네팅 */
    UPDATE GT_DM_SYNC_MKT_RES_SUM A
       SET A.SEQ = (SELECT SA.SEQ
                      FROM (SELECT ROW_NUM, ROW_NUMBER() OVER (ORDER BY QTY) AS SEQ
                              FROM GT_DM_SYNC_MKT_RES_SUM
                             WHERE QTY < 0) SA
                     WHERE SA.ROW_NUM = A.ROW_NUM)
     WHERE A.QTY < 0;

    /* [C20210225-000385] Carray Over 데이터 삭제 */
    UPDATE DM_PLN_MKT_FCST A
       SET A.QTY = CASE WHEN TO_NUMBER(A.ATTRIBUTE2 DEFAULT NULL ON CONVERSION ERROR) > 0
                        THEN A.QTY - TO_NUMBER(A.ATTRIBUTE2 DEFAULT NULL ON CONVERSION ERROR)
                        ELSE A.QTY
                   END
         , A.ATTRIBUTE2 = ''
         , A.ATTRIBUTE5 = ''
     WHERE EXISTS (SELECT 1
                     FROM GT_DM_SYNC_MKT_RES_SUM SA
                    WHERE A.DIVISION_ID = SA.DIVISION_ID
                      AND A.PROJECT_CODE = SA.PROJECT_CODE
                      AND A.SCM_SITE_ID = SA.SCM_SITE_ID
                      AND A.ITEM_ID = SA.ITEM_ID
                      AND A.DOM_EXP = SA.DOM_EXP
                      AND A.FCST_TYPE = SA.FCST_TYPE
                      AND A.INCOTERMS = SA.INCOTERMS
                      AND SA.QTY > 0)
       AND A.DIVISION_ID = V_DIVISION_ID
       AND A.YYYYMMDD = V_CARRY_YYYYMMDD                                        /* 오늘 ( 첫번째 계획구간 일자) */
       AND A.MEASURE = 'MKT_FCST'
       AND TO_NUMBER(A.ATTRIBUTE2 DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL;

    /* 실적이 계획보다 적게 들어온 경우를 먼저 일괄 업데이트 한다. */
    UPDATE DM_PLN_MKT_FCST A
       SET (A.QTY, A.ATTRIBUTE2, A.ATTRIBUTE5, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE) =
           (SELECT CASE WHEN TO_NUMBER(A.ATTRIBUTE2 DEFAULT NULL ON CONVERSION ERROR) > 0 THEN A.QTY
                        ELSE A.QTY + SA.QTY
                   END
                 /* ATTR1 은 있든없든 그대로 유지 · ATTR2 는 있으면 그대로 유지. 없으면 생성 */
                 , CASE WHEN TO_NUMBER(A.ATTRIBUTE2 DEFAULT NULL ON CONVERSION ERROR) > 0 THEN A.ATTRIBUTE2
                        ELSE TO_CHAR(SA.QTY)
                   END
                 /* [C20210225-000385] ATTRIBUTE5 는 CARRY OVER CONFIRM ID */
                 , SA.CONFIRM_ID
                 , 'SSP_CARRY_OVER'
                 , SYSDATE
              FROM GT_DM_SYNC_MKT_RES_SUM SA
             WHERE A.DIVISION_ID = SA.DIVISION_ID
               AND A.PROJECT_CODE = SA.PROJECT_CODE
               AND A.SCM_SITE_ID = SA.SCM_SITE_ID
               AND A.ITEM_ID = SA.ITEM_ID
               AND A.DOM_EXP = SA.DOM_EXP
               AND A.FCST_TYPE = SA.FCST_TYPE
               AND A.INCOTERMS = SA.INCOTERMS
               AND SA.QTY > 0
               AND ROWNUM = 1)
     WHERE EXISTS (SELECT 1
                     FROM GT_DM_SYNC_MKT_RES_SUM SA
                    WHERE A.DIVISION_ID = SA.DIVISION_ID
                      AND A.PROJECT_CODE = SA.PROJECT_CODE
                      AND A.SCM_SITE_ID = SA.SCM_SITE_ID
                      AND A.ITEM_ID = SA.ITEM_ID
                      AND A.DOM_EXP = SA.DOM_EXP
                      AND A.FCST_TYPE = SA.FCST_TYPE
                      AND A.INCOTERMS = SA.INCOTERMS
                      AND SA.QTY > 0)
       AND A.DIVISION_ID = V_DIVISION_ID
       AND A.YYYYMMDD = V_CARRY_YYYYMMDD                                        /* 오늘 ( 첫번째 계획구간 일자) */
       AND A.MEASURE = 'MKT_FCST';

    INSERT INTO DM_PLN_MKT_FCST
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
      , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
      , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
      , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
      , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
    )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
         , A.FCST_TYPE, A.INCOTERMS, 'MKT_FCST' AS MEASURE, '' AS PLANT_SITE_ID
         , V_CARRY_YYYYMMDD AS YYYYMMDD
         , A.QTY, 'SSP_SYNC' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'SSP_CARRY_OVER' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
         , '0' AS ATTRIBUTE1, TO_CHAR(A.QTY) AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4, A.CONFIRM_ID AS ATTRIBUTE5   /* [C20210225-000385] ATTRIBUTE5 는 CARRY OVER CONFIRM ID */
         , '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
      FROM GT_DM_SYNC_MKT_RES_SUM A
     WHERE A.QTY > 0
       AND NOT EXISTS (SELECT 1
                         FROM DM_PLN_MKT_FCST SA
                        WHERE A.DIVISION_ID = SA.DIVISION_ID
                          AND A.PROJECT_CODE = SA.PROJECT_CODE
                          AND A.SCM_SITE_ID = SA.SCM_SITE_ID
                          AND A.ITEM_ID = SA.ITEM_ID
                          AND A.DOM_EXP = SA.DOM_EXP
                          AND A.FCST_TYPE = SA.FCST_TYPE
                          AND A.INCOTERMS = SA.INCOTERMS
                          AND SA.YYYYMMDD = V_CARRY_YYYYMMDD                    /* 오늘 ( 첫번째 계획구간 일자) */
                          AND SA.MEASURE = 'MKT_FCST'
                          AND SA.DIVISION_ID = V_DIVISION_ID);

    COMMIT;

    /* 종료 LOG */
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END OF PROCEDURE ##########';
    D_EVENT_DATE := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

EXCEPTION
    WHEN OTHERS THEN

        ROLLBACK TO SALES_SITE_MODEL_PRODUCTION;

        /* ERROR LOG */
        V_LOG_TYPE := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 400);
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END PR_DM_SSP_CONFIRM_SYNC;