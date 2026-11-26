PROCEDURE         PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40
(
    P_COMPANY_ID1   IN  VARCHAR2
  , P_LOG_MESSGE    OUT VARCHAR2
)
/*
 * Program ID   : PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40
 * Description  : SSP Mail 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/11/24   KIMYONGHO      신규추가
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2026.07.31   ZIONEX      [PJ202650304] NextSCM Migration
 * 2026.10.30   ZIONEX       [PJ202650304] 티라엔진 제거 - SCP_PLN_SHIPMENT_PLAN(+PEGGING) -> SCP_OPT_SHIPMENT_PLAN_V(+PEGGING_V) 교체
 * 2026.11.25   ZIONEX       성능 개선 : PIVOT 적재 TEAM 조인 · 담당자 함수 캐시, WH_BOH_PLAN 미사용 누적 조인 제거, R01 회사 판정 함수 캐시, R02 MKT OWNER 대상 한정
 */
/*
 *     TEAM.USER_ID(+) IN (SELECT ...) 는 ORA-01799 로 거부됨(실측). 한 블록에서 ANSI+(+) 혼용은
 */
AS


    V_P_COMPANY_ID              VARCHAR2(10 CHAR);

    V_PLAN_START_YYYYMMDD       VARCHAR2(8 CHAR);
    V_FROM_YYYYMMDD             VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD               VARCHAR2(8 CHAR);

    V_SITE_FROM_YYYYMMDD        VARCHAR2(8 CHAR);
    V_SITE_TO_YYYYMMDD          VARCHAR2(8 CHAR);

    V_BOH_YYYYMMDD              VARCHAR2(8 CHAR);
    V_STOCK_YYYYMMDD            VARCHAR2(8 CHAR);

    V_PROGRAM_ID                VARCHAR2(50 CHAR);
    V_SHEET_NAME                VARCHAR2(50 CHAR);

    V_FROMSITE_CNT              NUMBER(10);
    V_FROMSITE_TMPCNT           NUMBER(10);

    V_RECEIVER_CNT              NUMBER(10);
    V_RECEIVER_TMPCNT           NUMBER(10);

    V_ITEM_CNT                  NUMBER(10);
    V_ITEM_TMPCNT               NUMBER(10);

    V_TESTCNT                   NUMBER(10) := 0;

    V_MEASURECNT                NUMBER(10) := 0;

    /* 원본 NVARCHAR(max) HTML 누적 -> CLOB (VARCHAR2 32767 초과 시 ORA-06502 방지) */
    V_HEAD_CONT                 CLOB;
    V_BODY_CONT                 CLOB;
    V_RECEIVER_TEMP             VARCHAR2(150 CHAR);
    V_TO_MAIL                   VARCHAR2(4000 CHAR);
    V_TABLE_BODY                CLOB;
    V_BODY_CONTENTS             VARCHAR2(4000 CHAR);
    V_MAIL_TITLE                VARCHAR2(100 CHAR);
    V_MAIL_RECEIVER             VARCHAR2(100 CHAR);

    V_DIVISION_ID               VARCHAR2(100 CHAR);
    V_COMPANY_ID                VARCHAR2(100 CHAR);
    V_FROM_SITE_DESCRIPTION     VARCHAR2(100 CHAR);
    V_TO_SITE_DESCRIPTION       VARCHAR2(100 CHAR);
    V_DEPT_NAME_KO              VARCHAR2(100 CHAR);
    V_MKT_USER                  VARCHAR2(100 CHAR);
    V_ITEM_ID                   VARCHAR2(100 CHAR);
    V_ITEM_ID_TEMP              VARCHAR2(100 CHAR);
    V_NICK_NAME                 VARCHAR2(100 CHAR);
    V_MEASURE_NAME              VARCHAR2(100 CHAR);
    V_SEQ                       VARCHAR2(100 CHAR);

    V_SEGMENT1                  NUMBER;
    V_SEGMENT2                  NUMBER;
    V_SEGMENT3                  NUMBER;
    V_SEGMENT4                  NUMBER;
    V_SEGMENT5                  NUMBER;
    V_ITEM_SEQ                  NUMBER;
    V_ITEM_SEQ_TEMP             NUMBER := 0;

    V_MEASURE_SEQ               NUMBER;
    V_ROWSPANCNT                NUMBER;
    V_ROWSPANCNT2               NUMBER;
    V_CNT                       NUMBER(10);

    /* SCP FINAL PLAN INFO */
    V_SCP_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR);
    V_SCP_PLAN_TYPE             VARCHAR2(10 CHAR);
    V_SCP_SEQ                   INTEGER;


    V_LAST_PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR)  := '';
    V_LAST_PLAN_TYPE            VARCHAR2(30 CHAR) := 'SP';
    V_LAST_SEQ                  INTEGER           := 0;

    V_P_SHEET_NAME              VARCHAR2(10 CHAR)   := 'Cell Biz';
    V_P_DIVISION_ID             VARCHAR2(30 CHAR)   := '40';
    V_P_TEAM_ID                 VARCHAR2(4000 CHAR);
    V_P_CUSTOMER                VARCHAR2(4000 CHAR);
    V_P_SCM_SITE_ID             VARCHAR2(4000 CHAR);
    V_P_PLANT_SITE_ID           VARCHAR2(4000 CHAR);
    V_P_PROJECT_CODE            VARCHAR2(4000 CHAR);
    V_P_ITEM_ID                 VARCHAR2(4000 CHAR);
    /* DECLARE @p_from_yyyymmdd  NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DD,21,GETDATE()),112);
       DECLARE @p_to_yyyymmdd    NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DD,25,GETDATE()),112); */
    V_P_FROM_YYYYMMDD           VARCHAR2(8 CHAR)  := '';
    V_P_TO_YYYYMMDD             VARCHAR2(8 CHAR)  := '';
    /* DECLARE @p_from_yyyymmdd  NVARCHAR(8) = '20201210';
       DECLARE @p_to_yyyymmdd    NVARCHAR(8) = '20201214'; */
    V_P_CREATED_BY              VARCHAR2(50 CHAR);
    V_DEBUG_MODE                VARCHAR2(1 CHAR)  := 'F';

    V_P_PROGRAM_ID              VARCHAR2(4000 CHAR) := 'SSP0026';

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40';
    V_LOG_TYPE                  VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT                 INTEGER := 0;
    V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
    V_DESCRIPTION               VARCHAR2(500 CHAR);
    D_EVENT_DATE                DATE;

    V_MAIL_COUNT                INTEGER := 0;

    V_ERROR_MESSAGE             VARCHAR2(1000 CHAR);

    /*       원본은 SCM_SYS_CALENDAR_M 에서 @v_site_from ~ @v_site_to(=from+4) 구간 basis_yyyymmdd 를 */
    V_D1                        VARCHAR2(8 CHAR);
    V_D2                        VARCHAR2(8 CHAR);
    V_D3                        VARCHAR2(8 CHAR);
    V_D4                        VARCHAR2(8 CHAR);
    V_D5                        VARCHAR2(8 CHAR);


    FUNCTION FMT_MONEY(P IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        IF P IS NULL THEN
            RETURN NULL;
        END IF;
        RETURN REPLACE(TO_CHAR(P, 'FM999,999,999,990.00'), '.00', '');
    END FMT_MONEY;
BEGIN
    /* [E20261126-DS2] GTT(통계 없음) 행 수 추정용. 클라우드 optimizer_dynamic_sampling = 0 (2026-11-26 확인) */
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    V_P_COMPANY_ID := P_COMPANY_ID1;

    V_FROMSITE_TMPCNT := 0;
    V_RECEIVER_TMPCNT := 0;
    V_PLAN_START_YYYYMMDD := TO_CHAR(SYSDATE, 'YYYYMMDD');

    SELECT COUNT(*)
      INTO V_MAIL_COUNT
      FROM SCM_ADM_SMS_MAIL_SEND_LOG
     WHERE SEGMENT1 = V_PROGRAM_NAME
       AND SEGMENT2 = '40'
       AND SEGMENT3 = V_P_COMPANY_ID
       AND TO_CHAR(CREATION_DATE, 'YYYYMMDD') = V_PLAN_START_YYYYMMDD;

    IF V_MAIL_COUNT > 0 THEN
        RETURN;
    END IF;

    /* 원본의 IF OBJECT_ID('tempdb..#xxx') IS NOT NULL DROP TABLE #xxx (선행 정리) -> */
    /* SHIPMENT BOH */
    DELETE FROM GT_SSP0026_SHIP_FG;
    /* SHIPMENT ROW DATA */
    DELETE FROM GT_SSP0026_ROW;
    DELETE FROM GT_SSP0026_RAW;
    DELETE FROM GT_SSP0026_R01;
    DELETE FROM GT_SSP0026_R02;
    DELETE FROM GT_SSP0026_MAIL;
    DELETE FROM GT_SSP0026_PIVOT;
    DELETE FROM GT_SSP0026_FG;
    DELETE FROM GT_SSP0026_STD;

    /********************************************************************************
    * 임시테이블만들기
    ********************************************************************************/


    V_PROGRAM_ID := 'SSP0026';
    V_SHEET_NAME := 'Cell Biz';

    BEGIN
        /* //시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;   /* SYSDATETIME() -> 대상 P_EVENT_DATE 가 DATE (CV-055) */
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* //LOG END */
        BEGIN
            /* SELECT TOP 1 .. ORDER BY -> 인라인뷰 ORDER BY 후 ROWNUM = 1 (CV-026).
               원본 컬럼폭(PLAN_START_YYYYMMDD 100 / PLAN_TYPE 50) > 변수폭 -> MSSQL 대입 절단과 동일하게 SUBSTR */
            SELECT PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ
              INTO V_SCP_PLAN_START_YYYYMMDD, V_SCP_PLAN_TYPE, V_SCP_SEQ
              FROM
              (
                  SELECT SUBSTR(A.PLAN_START_YYYYMMDD, 1, 8) AS PLAN_START_YYYYMMDD
                       , SUBSTR(A.PLAN_TYPE, 1, 10)          AS PLAN_TYPE
                       , A.PLAN_SEQ                          AS PLAN_SEQ
                    FROM SCP_PLAN_VERSION_V A
                   WHERE 1 = 1
                     AND A.DIVISION_ID = V_P_DIVISION_ID
                     AND A.PLAN_CYCLE  = 'WEEKLY'
                     AND A.PLAN_TYPE   = 'FN'
                   ORDER BY A.PLAN_START_YYYYMMDD DESC, A.PLAN_TYPE_ORDER DESC, A.PLAN_SEQ DESC
              )
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;   /* MSSQL SELECT TOP 1 은 무행이면 변수를 바꾸지 않는다(NULL 유지) */
        END;

        /* 가장 최근 출하계획 버전 확인 */
        SELECT SUBSTR(MAX(PLAN_START_YYYYMMDD), 1, 8)
             , MAX(PLAN_SEQ)
             , SUBSTR(MAX(PLAN_TYPE), 1, 30)
          INTO V_LAST_PLAN_START_YYYYMMDD, V_LAST_SEQ, V_LAST_PLAN_TYPE
          FROM SSP_PLAN_VERSION_V
         WHERE PLAN_TYPE    = 'SP'
           AND DIVISION_ID  = V_P_DIVISION_ID
           AND CONFIRM_FLAG = 'Y';

        V_P_FROM_YYYYMMDD := V_LAST_PLAN_START_YYYYMMDD;
        V_P_TO_YYYYMMDD   := TO_CHAR(TO_DATE(V_LAST_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 56, 'YYYYMMDD');

        /* SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다. */
        INSERT INTO GT_SSP0026_STD   /* 기준 데이터 저장 */
        (
            DIVISION_ID, FROM_SITE, PLAN_START_YYYYMMDD
        )
        SELECT DISTINCT
               DIVISION_ID
             , FROM_SITE
             , PLAN_START_YYYYMMDD
          FROM
          (
              SELECT SP.DIVISION_ID
                   , SP.FROM_SITE
                   , SP.PLAN_START_YYYYMMDD
                   , RANK() OVER (PARTITION BY SP.FROM_SITE ORDER BY SP.PLAN_START_YYYYMMDD DESC) AS "RANK"
                FROM SSP_ANL_SHIP_PLAN_40 SP
               WHERE SP.DIVISION_ID = V_P_DIVISION_ID
                 AND SP.PLAN_START_YYYYMMDD >= TO_CHAR(SYSDATE - 1, 'YYYYMMDD')   /* 전일 */
                 AND SP.PLAN_START_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')       /* 당일 */
                 AND SP.QTY > 0
          ) A
         WHERE A."RANK" = 1;

        INSERT INTO GT_SSP0026_FG
        (
            DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ORDER_ID
          , ALLOCATION_QTY, FCST_TYPE, MASTER_ID, PLAN_ID, OUT_VERSION_ID
        )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.ORDER_ID
             , A.ALLOCATION_QTY
             , A.FCST_TYPE
             , A.MASTER_ID
             , A.PLAN_ID
             , A.OUT_VERSION_ID
          FROM SCP_OPT_SHIPMENT_PLAN_PEGGING_V A
         WHERE A.DIVISION_ID = V_P_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_SCP_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_SCP_PLAN_TYPE
           AND A.SEQ                 = V_SCP_SEQ;

        INSERT INTO GT_SSP0026_SHIP_FG
        (
            DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, BIZ_TYPE, FCST_TYPE, ITEM_ID, TO_SITE
          , FROM_SITE, BOD_ID, TRANSPORT_MODE, MEASURE, YYYYMMDD, QTY, LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , MAX(OPERATION_GROUP)  AS BIZ_TYPE
             , FCST_TYPE
             , ITEM_ID
             , TO_SITE
             /* , INCOTERMS */
             , FROM_SITE
             , BOD_ID
             , TRANSPORT_MODE
             , MEASURE
             , YYYYMMDD
             , SUM(QTY)              AS QTY
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
          FROM
          (
              SELECT B.DIVISION_ID
                   , B.PLAN_START_YYYYMMDD
                   , B.PLAN_TYPE
                   , B.SEQ
                   , B.OPERATION_GROUP
                   , A.FCST_TYPE
                   , B.ITEM_ID
                   , B.TO_SITE
                   , B.FROM_SITE
                   , B.BOD_ID
                   , B.TRANSPORT_MODE
                   , B.MEASURE
                   , B.YYYYMMDD
                   , A.ALLOCATION_QTY  AS QTY
                   , REPLACE(B.LAST_UPDATED_BY, 'scp_batch', 'System') AS LAST_UPDATED_BY
                   , B.LAST_UPDATE_DATE
                FROM SCP_OPT_SHIPMENT_PLAN_V B
                   , GT_SSP0026_FG A
                   , SCM_MST_SITE T4
               WHERE 1 = 1
                 AND A.DIVISION_ID          = B.DIVISION_ID
                 AND A.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD
                 AND A.PLAN_TYPE            = B.PLAN_TYPE
                 AND A.SEQ                  = B.SEQ
                 AND A.ORDER_ID             = B.ORDER_ID
                 AND A.MASTER_ID            = B.MASTER_ID
                 AND A.PLAN_ID              = B.PLAN_ID
                 AND A.OUT_VERSION_ID       = B.OUT_VERSION_ID
                 AND B.DIVISION_ID          = T4.DIVISION_ID
                 AND B.TO_SITE              = T4.SCM_SITE_ID
                 AND T4.VALID_YN            = 'Y'
                 AND T4.OPERATION_GROUP IS NULL
                 AND B.DIVISION_ID          = V_P_DIVISION_ID
                 AND B.PLAN_START_YYYYMMDD  = V_SCP_PLAN_START_YYYYMMDD
                 AND B.PLAN_TYPE            = V_SCP_PLAN_TYPE
                 AND B.SEQ                  = V_SCP_SEQ
                 AND B.MEASURE              = 'SHIP_PLAN'
                 /* AND B.SEMI_YN              = 'N' */
                 AND B.OPERATION_GROUP      = 'A'
                 AND B.YYYYMMDD            >= V_P_FROM_YYYYMMDD
                 AND B.YYYYMMDD            <= V_P_TO_YYYYMMDD
          ) X
         GROUP BY DIVISION_ID
                , PLAN_START_YYYYMMDD
                , PLAN_TYPE
                , SEQ
                , FCST_TYPE
                , ITEM_ID
                , TO_SITE
                /* , INCOTERMS */
                , FROM_SITE
                , TRANSPORT_MODE
                , BOD_ID
                , MEASURE
                , YYYYMMDD
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE;

        /* -----------------------------------------------
           1. SCP Plan : SCP(Weekly) plant향 Shipment Plan
           ----------------------------------------------- */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT SP.DIVISION_ID
             , SP.ITEM_ID
             , SP.FROM_SITE
             , SP.TO_SITE
             , 'SCP_SHIP_PLAN'   AS MEASURE
             , SP.YYYYMMDD
             , SP.BOD_ID
             , NVL(SP.QTY, 0)    AS QTY
             , BOD.INCOTERMS
             , BOD.TRANSPORT_MODE
             /* , ISNULL(SP.FCST_TYPE,'') AS FCST_TYPE */
             , '-'               AS FCST_TYPE
             , 1                 AS SEQ
             , SP.LAST_UPDATED_BY
             , SP.LAST_UPDATE_DATE
             , '-'               AS REMARK
          FROM SCP_ANL_SHIPMENT_PLAN_SEMI SP

            , (
                  SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID, SORT_SEQ
                       , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
                                                ORDER BY PLAN_START_YYYYMMDD DESC, SORT_SEQ ASC, PLAN_SEQ DESC
                                           ) ROW_NUM
                    FROM
                    (
                        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
                             , CASE WHEN PLAN_TYPE = 'PR' THEN 4
                                    WHEN PLAN_TYPE = 'MA' THEN 3
                                    WHEN PLAN_TYPE = 'SE' THEN 2
                                    WHEN PLAN_TYPE = 'FN' THEN 1
                                    ELSE 9
                               END AS SORT_SEQ
                          FROM SCP_PLAN_VERSION_V
                         WHERE 1 = 1
                           AND DIVISION_ID          = V_P_DIVISION_ID   /* 변수 */
                           AND PLAN_CYCLE           = 'WEEKLY'
                           /* 191219 FN만 조회 */
                           /* AND    plan_type       NOT IN ('TE', 'TM') */
                           AND PLAN_TYPE            = 'FN'
                           AND PLAN_START_YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 14, 'YYYYMMDD')
                    ) A
              ) PV
             , SCP_MST_BOD_N_V BOD
             , SCM_MST_SITE FS
             , SCM_MST_SITE TS
         WHERE 1 = 1
           AND SP.DIVISION_ID         = PV.DIVISION_ID
           AND SP.PLAN_START_YYYYMMDD = PV.PLAN_START_YYYYMMDD
           AND SP.PLAN_TYPE           = PV.PLAN_TYPE
           AND SP.SEQ                 = PV.PLAN_SEQ
           AND PV.ROW_NUM             = 1
           AND SP.MEASURE             = 'SHIP_PLAN_AMEND'
           AND SP.QTY                 > 0
           AND SP.OPERATION_GROUP     = 'A'
           AND SP.YYYYMMDD           >= V_P_FROM_YYYYMMDD
           AND SP.YYYYMMDD           <= V_P_TO_YYYYMMDD
           /* 원본 ( @p IS NULL OR @p = '' ) -> Oracle 은 '' 가 NULL 이라 IS NULL 하나로 동치(CV-028/H-4) */
           AND ( ( V_P_SCM_SITE_ID IS NULL ) OR SP.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_P_SCM_SITE_ID, ','))) )
           AND ( ( V_P_ITEM_ID     IS NULL ) OR SP.ITEM_ID   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_P_ITEM_ID, ','))) )
           AND SP.DIVISION_ID = BOD.DIVISION_ID
           AND SP.BOD_ID      = BOD.BOD_ID
           AND FS.DIVISION_ID = SP.DIVISION_ID
           AND FS.SCM_SITE_ID = SP.FROM_SITE
           AND FS.VALID_YN    = 'Y'
           AND TS.DIVISION_ID = SP.DIVISION_ID
           AND TS.SCM_SITE_ID = SP.TO_SITE
           AND TS.VALID_YN    = 'Y'
           AND FS.PLANT_ID <> TS.PLANT_ID;

        /* SCP_SHIP_PLAN Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , 'SCP_SHIP_PLAN'      AS MEASURE
             , A.YYYYMMDD
             , A.BOD_ID
             , NVL(A.QTY, 0)        AS QTY
             , C.INCOTERMS
             , C.TRANSPORT_MODE
             /* 원본 ISNULL(A.FCST_TYPE,'') : 원천 GT_SSP0026_SHIP_FG.FCST_TYPE 는 PEGGING NOT NULL 유래라 */
             , A.FCST_TYPE          AS FCST_TYPE
             , 1                    AS SEQ
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , '-'                  AS REMARK
          FROM GT_SSP0026_SHIP_FG A
             , SCP_MST_BOD_N_V C
         WHERE C.DIVISION_ID(+)  = A.DIVISION_ID
           AND C.BOD_ID(+)       = A.BOD_ID
           AND C.DIVISION_ID(+)  = V_P_DIVISION_ID
           AND C.BOD_TYPE(+)     = 'SALES'
           AND A.DIVISION_ID  = V_P_DIVISION_ID
           AND A.MEASURE      = 'SHIP_PLAN'
           AND A.YYYYMMDD    >= V_P_FROM_YYYYMMDD
           AND A.YYYYMMDD    <= V_P_TO_YYYYMMDD;

        /* SHIP_REQ Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.PLANT_SITE_ID  AS FROM_SITE
             , A.SCM_SITE_ID    AS TO_SITE
             , 'SHIP_REQ'       AS MEASURE
             , A.YYYYMMDD
             , A.BOD_ID
             , A.QTY
             , A.INCOTERMS
             , A.TRANSPORT_MODE
             , A.FCST_TYPE
             , 2                AS SEQ
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , '-'              AS REMARK
          FROM DM_PLN_SHIPMENT_REQ A
             , SCP_MST_BOD_N_V C
             , SCM_MST_SITE T4
         WHERE 1 = 1
           AND C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.BOD_ID(+)      = A.BOD_ID
           AND C.DIVISION_ID(+) = V_P_DIVISION_ID
           /* AND C.BOD_TYPE     = 'SALES' */
           AND A.DIVISION_ID  = T4.DIVISION_ID
           AND A.SCM_SITE_ID  = T4.SCM_SITE_ID
           AND T4.VALID_YN    = 'Y'
           AND A.DIVISION_ID  = V_P_DIVISION_ID
           AND A.MEASURE      = 'SHIP_REQ'
           AND A.YYYYMMDD    >= V_P_FROM_YYYYMMDD
           AND A.YYYYMMDD    <= V_P_TO_YYYYMMDD;

        /* SHIP_PLAN Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT SSP.DIVISION_ID
             , SSP.ITEM_ID
             , SSP.FROM_SITE
             , SSP.TO_SITE
             , 'SHIP_PLAN'          AS MEASURE
             , SSP.YYYYMMDD
             , BOD.BOD_ID
             , SSP.QTY
             , BOD.INCOTERMS        AS INCOTERMS
             , BOD.TRANSPORT_MODE   AS TR_MODE
             , SSP.FCST_TYPE
             , 3                    AS SEQ
             , '-'                  AS LAST_UPDATED_BY
             , SSP.LAST_UPDATE_DATE
             , '-'                  AS REMARK
          FROM SSP_ANL_SHIP_CONFIRM SSP

            , (
                  SELECT DISTINCT DIVISION_ID, ITEM_ID, SCP_OPERATION_GROUP
                    FROM SCM_MST_ITEM_SN
                   WHERE DIVISION_ID          = V_P_DIVISION_ID
                     AND SCP_OPERATION_GROUP  = 'A'   /* CELL/PACK 구분 */
                     AND ACTIVE_FLAG          = 'Y'
              ) IT
             , SCM_MST_SITE TS
             , SCP_MST_BOD_N_V BOD
         WHERE SSP.DIVISION_ID = IT.DIVISION_ID
           AND SSP.ITEM_ID     = IT.ITEM_ID
           AND SSP.DIVISION_ID = TS.DIVISION_ID
           AND SSP.TO_SITE     = TS.SCM_SITE_ID
           AND TS.VALID_YN     = 'Y'
           /* AND TS.SITE_TYPE    = 'SALES' */
           AND SSP.DIVISION_ID = BOD.DIVISION_ID
           AND SSP.BOD_ID      = BOD.BOD_ID
           AND SSP.DIVISION_ID  = V_P_DIVISION_ID   /* 변수 */
           AND SSP.QTY          > 0
           AND SSP.YYYYMMDD    >= V_P_FROM_YYYYMMDD
           AND SSP.YYYYMMDD    <= V_P_TO_YYYYMMDD
           AND SSP.CHANGE_TYPE  = 'C'
        UNION ALL
        SELECT P.DIVISION_ID
             , P.ITEM_ID
             , P.PLANT_SITE_ID      AS FROM_SITE
             , P.SCM_SITE_ID        AS TO_SITE
             , 'SHIP_PLAN'          AS MEASURE
             , P.YYYYMMDD
             , P.BOD_ID
             , P.QTY
             , P.INCOTERMS
             , P.TRANSPORT_MODE
             , P.FCST_TYPE
             , 3                    AS SEQ
             , '-'                  AS LAST_UPDATED_BY
             , P.LAST_UPDATE_DATE
             , '-'                  AS REMARK
          FROM DM_PLN_SHIPMENT_REQ P
             , SCM_MST_SITE FZ
             , SCM_MST_SITE T4
         WHERE 1 = 1   /* P.YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD,ISNULL(FZ.SHIP_FROZEN,0),GETDATE()),112) -- 확정구간의 다음날짜가 나오므로 >= 로 처리함 */
           AND P.DIVISION_ID    = FZ.DIVISION_ID
           AND P.PLANT_SITE_ID  = FZ.SCM_SITE_ID
           AND FZ.VALID_YN      = 'Y'
           AND P.DIVISION_ID    = T4.DIVISION_ID
           AND P.SCM_SITE_ID    = T4.SCM_SITE_ID
           AND FZ.VALID_YN      = 'Y'
           /* AND T4.SITE_TYPE    = 'SALES' */
           AND P.YYYYMMDD >= V_P_FROM_YYYYMMDD
           AND P.YYYYMMDD <= V_P_TO_YYYYMMDD;

        /* POSTP_PLAN Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT P.DIVISION_ID                    AS DIVISION_ID
             , P.CELL_ITEM_ID                   AS ITEM_ID
             , P.SCM_SITE_ID                    AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'POSTP_PLAN'                     AS MEASURE
             , P.PLAN_DATE                      AS YYYYMMDD
             , '-'                              AS BOD_ID
             , P.PLAN_QTY                       AS QTY
             , '-'                              AS INCOTERMS
             , '-'                              AS TRANSPORT_MODE
             , '-'                              AS FCST_TYPE
             , 4                                AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_FORMATION_POST_CELL_V P
             , SCM_MST_SITE E
         WHERE E.DIVISION_ID = V_P_DIVISION_ID

           AND E.COMPANY_ID  = P_COMPANY_ID1
           AND E.DIVISION_ID = P.DIVISION_ID
           AND E.SCM_SITE_ID = P.SCM_SITE_ID
           AND P.DIVISION_ID  = V_P_DIVISION_ID
           AND P.PLAN_DATE   >= V_P_FROM_YYYYMMDD
           AND P.PLAN_DATE   <  V_P_TO_YYYYMMDD
           AND ( ( V_P_ITEM_ID IS NULL ) OR P.CELL_ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_P_ITEM_ID, ','))) );

        /* GROUP BY P.DIVISION_ID
           ,        P.CELL_ITEM_ID
           ,        P.SCM_SITE_ID
           ,        P.PLAN_DATE */

        /*        POSTP_PLAN Meausre 생성
        INSERT INTO #TMP_ROWDATA
        SELECT  P.DIVISION_ID               AS DIVISION_ID
            , P.ITEM_ID                 AS ITEM_ID
            , P.FROM_SITE                   AS FROM_SITE
            , '-'                       AS TO_SITE
            , 'POSTP_PLAN'                  AS MEASURE
            , P.YYYYMMDD                    AS YYYYMMDD
            , '-'                       AS BOD_ID
            , P.QTY                     AS QTY
            , '-'                       AS INCOTERMS
            , '-'                       AS TRANSPORT_MODE
            , '-'                       AS FCST_TYPE
            , 4                         AS SEQ
            , NULL                      AS LAST_UPDATED_BY
            , NULL                      AS LAST_UPDATE_DATE
            , '-'                       AS REMARK
         FROM SSP_ANL_SHIP_PLAN_40 P WITH(NOLOCK)
        INNER JOIN SCM_MST_SITE FS
           ON P.DIVISION_ID     = FS.DIVISION_ID
          AND P.FROM_SITE        = FS.SCM_SITE_ID
          AND FS.SITE_TYPE       = 'SALSE'
          AND FS.OPERATION_GROUP = 'A'
          AND FS.OSP_YN          = 'N'
          AND FS.VALID_YN        = 'Y'
        WHERE 1 = 1
          AND P.PLAN_START_YYYYMMDD = CONVERT(VARCHAR(8),GETDATE() , 112) -- 당일(현재는 현재일 -1)
          AND P.MEASURE     = 'POSTP_PLAN'
          AND P.DIVISION_ID      = @p_division_id
          AND P.YYYYMMDD         >= @p_from_yyyymmdd
          AND P.YYYYMMDD         <= @p_to_yyyymmdd
          AND (( @p_item_id       IS NULL OR @p_item_id ='')        OR P.ITEM_ID          IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
          AND (( @p_plant_site_id  IS NULL OR @p_plant_site_id ='')   OR P.FROM_SITE      IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_site_id , ',')))
          AND P.qty            >  0
          AND P.DIVISION_ID    = '40' -- 소형(40) 인 경우만 조회
        */

        /* SITE_MOVE Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT SSP.DIVISION_ID
             , SSP.ITEM_ID
             , SSP.FROM_SITE                    AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'SITE_MOVE'                      AS MEASURE
             , SSP.YYYYMMDD
             , ''                               AS BOD_ID
             , SSP.QTY
             , ''                               AS INCOTERMS
             , ''                               AS TRANSPORT_MODE
             , ''                               AS FCST_TYPE
             , 5                                AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_ANL_SHIP_CONFIRM SSP
             , SCM_MST_SITE TS
             , SCM_MST_SITE FS
         WHERE 1 = 1
           AND SSP.DIVISION_ID = TS.DIVISION_ID
           AND SSP.TO_SITE     = TS.SCM_SITE_ID
           AND TS.SITE_TYPE    = 'PLANT'
           AND TS.VALID_YN     = 'Y'
           AND SSP.DIVISION_ID = FS.DIVISION_ID
           AND SSP.FROM_SITE   = FS.SCM_SITE_ID
           AND FS.VALID_YN     = 'Y'
           AND TS.PLANT_ID    <> FS.PLANT_ID
           AND SSP.DIVISION_ID = V_P_DIVISION_ID
           AND SSP.QTY         > 0
           AND SSP.YYYYMMDD   >= V_P_FROM_YYYYMMDD
           AND SSP.YYYYMMDD   <= V_P_TO_YYYYMMDD
           AND SSP.BIZ_TYPE    = 'A'
           AND SSP.CHANGE_TYPE = 'C'
           AND ( ( V_P_ITEM_ID IS NULL ) OR SSP.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_P_ITEM_ID, ','))) )
        UNION ALL
        SELECT R.DIVISION_ID
             , R.ITEM_ID
             , R.PLANT_SITE_ID                  AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'SITE_MOVE'                      AS MEASURE
             , R.YYYYMMDD
             , ''                               AS BOD_ID
             , R.QTY
             , ''                               AS INCOTERMS
             , ''                               AS TRANSPORT_MODE
             , ''                               AS FCST_TYPE
             , 5                                AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM DM_PLN_SHIPMENT_REQ R
             , SCM_MST_SITE FS
             , SCM_MST_SITE TS
         WHERE 1 = 1
           AND FS.DIVISION_ID     = R.DIVISION_ID
           AND FS.SCM_SITE_ID     = R.PLANT_SITE_ID
           AND FS.SITE_TYPE       = 'PLANT'
           AND FS.OPERATION_GROUP = 'A'
           AND FS.OSP_YN          = 'N'
           AND FS.VALID_YN        = 'Y'
           AND TS.DIVISION_ID     = R.DIVISION_ID
           AND TS.SCM_SITE_ID     = R.SCM_SITE_ID
           AND TS.SITE_TYPE       = 'PLANT'
           AND TS.VALID_YN        = 'Y'
           AND R.DIVISION_ID      = V_P_DIVISION_ID
           AND R.MEASURE          = 'SHIP_REQ'
           AND R.YYYYMMDD        >= V_P_FROM_YYYYMMDD
           AND R.YYYYMMDD        <= V_P_TO_YYYYMMDD
           AND TS.PLANT_ID       <> FS.PLANT_ID
           AND R.QTY              > 0
           /* AND R.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, ISNULL(FS.SHIP_FROZEN,0), GETDATE()), 112) */
           AND ( ( V_P_ITEM_ID IS NULL ) OR R.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_P_ITEM_ID, ','))) );

        /* CUST_MOVE Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT SSP.DIVISION_ID
             , SSP.ITEM_ID
             , SSP.FROM_SITE                    AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'CUST_MOVE'                      AS MEASURE
             , SSP.YYYYMMDD
             , ''                               AS BOD_ID
             , SSP.QTY
             , ''                               AS INCOTERMS
             , ''                               AS TRANSPORT_MODE
             , ''                               AS FCST_TYPE
             , 5                                AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_ANL_SHIP_CONFIRM SSP
             , SCM_MST_SITE TS
             , SCM_MST_SITE FS
         WHERE 1 = 1
           AND SSP.DIVISION_ID = TS.DIVISION_ID
           AND SSP.TO_SITE     = TS.SCM_SITE_ID
           AND TS.SITE_TYPE    = 'SALES'
           AND TS.VALID_YN     = 'Y'
           AND SSP.DIVISION_ID = FS.DIVISION_ID
           AND SSP.FROM_SITE   = FS.SCM_SITE_ID
           AND FS.VALID_YN     = 'Y'
           AND TS.PLANT_ID    <> FS.PLANT_ID
           AND SSP.DIVISION_ID = V_P_DIVISION_ID
           AND SSP.QTY         > 0
           AND SSP.YYYYMMDD   >= V_P_FROM_YYYYMMDD
           AND SSP.YYYYMMDD   <= V_P_TO_YYYYMMDD
           AND SSP.BIZ_TYPE    = 'A'
           AND SSP.CHANGE_TYPE = 'C'
           AND ( ( V_P_ITEM_ID IS NULL ) OR SSP.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_P_ITEM_ID, ','))) )
        UNION ALL
        SELECT R.DIVISION_ID
             , R.ITEM_ID
             , R.PLANT_SITE_ID                  AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'CUST_MOVE'                      AS MEASURE
             , R.YYYYMMDD
             , ''                               AS BOD_ID
             , R.QTY
             , ''                               AS INCOTERMS
             , ''                               AS TRANSPORT_MODE
             , ''                               AS FCST_TYPE
             , 5                                AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM DM_PLN_SHIPMENT_REQ R
             , SCM_MST_SITE FS
             , SCM_MST_SITE TS
         WHERE 1 = 1
           AND FS.DIVISION_ID     = R.DIVISION_ID
           AND FS.SCM_SITE_ID     = R.PLANT_SITE_ID
           AND FS.SITE_TYPE       = 'PLANT'
           AND FS.OPERATION_GROUP = 'A'
           AND FS.OSP_YN          = 'N'
           AND FS.VALID_YN        = 'Y'
           AND TS.DIVISION_ID     = R.DIVISION_ID
           AND TS.SCM_SITE_ID     = R.SCM_SITE_ID
           AND TS.SITE_TYPE       = 'SALES'
           AND TS.VALID_YN        = 'Y'
           AND R.DIVISION_ID      = V_P_DIVISION_ID
           AND R.MEASURE          = 'SHIP_REQ'
           AND R.YYYYMMDD        >= V_P_FROM_YYYYMMDD
           AND R.YYYYMMDD        <= V_P_TO_YYYYMMDD
           /* AND TS.plant_id <> FS.plant_id */
           AND R.QTY              > 0
           /* AND R.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, ISNULL(FS.SHIP_FROZEN,0), GETDATE()), 112) */
           AND ( ( V_P_ITEM_ID IS NULL ) OR R.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_P_ITEM_ID, ','))) );

        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        /* WH_IN Meausre 생성 */
        SELECT T.DIVISION_ID
             , T.ITEM_ID
             , T.FROM_SITE
             , T.TO_SITE
             , 'WH_IN'                          AS MEASURE
             , T.YYYYMMDD
             , T.BOD_ID
             , T.QTY
             , T.INCOTERMS
             , T.TRANSPORT_MODE
             , T.FCST_TYPE
             , 6                                AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM SSP_ANL_SHIP_PLAN_40 T
             , GT_SSP0026_STD ST
         WHERE ST.DIVISION_ID         = T.DIVISION_ID
           AND ST.FROM_SITE           = T.FROM_SITE
           AND ST.PLAN_START_YYYYMMDD = T.PLAN_START_YYYYMMDD
           AND T.DIVISION_ID = V_P_DIVISION_ID
           AND T.MEASURE     = 'WH_IN'
           AND T.YYYYMMDD   >= V_P_FROM_YYYYMMDD
           AND T.YYYYMMDD   <= V_P_TO_YYYYMMDD
           AND T.BIZ_TYPE    = 'A';

        /* TOTAL_PLAN Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT DIVISION_ID
             , ITEM_ID
             , FROM_SITE                        AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'TOTAL_PLAN'                     AS MEASURE
             , YYYYMMDD
             , ''                               AS BOD_ID
             , SUM(QTY)                         AS QTY
             , ''                               AS INCOTERMS
             , ''                               AS TRANSPORT_MODE
             , ''                               AS FCST_TYPE
             , 7                                AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM
          (
              SELECT SSP.DIVISION_ID
                   , SSP.FROM_SITE
                   , SSP.ITEM_ID
                   , SSP.YYYYMMDD
                   , SSP.QTY
                FROM SSP_ANL_SHIP_CONFIRM SSP

                  , (
                        SELECT DISTINCT DIVISION_ID, ITEM_ID, SCP_OPERATION_GROUP
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID         = V_P_DIVISION_ID
                           AND SCP_OPERATION_GROUP = 'A'   /* CELL/PACK 구분 */
                           AND ACTIVE_FLAG         = 'Y'
                    ) IT
               WHERE SSP.DIVISION_ID = IT.DIVISION_ID
                 AND SSP.ITEM_ID     = IT.ITEM_ID
                 AND SSP.DIVISION_ID  = V_P_DIVISION_ID
                 AND SSP.YYYYMMDD    >= V_P_FROM_YYYYMMDD
                 AND SSP.YYYYMMDD    <= V_P_TO_YYYYMMDD
                 AND SSP.CHANGE_TYPE  = 'C'
                 AND SSP.QTY          > 0
              UNION ALL
              SELECT P.DIVISION_ID
                   , P.PLANT_SITE_ID  AS FROM_SITE
                   , P.ITEM_ID
                   , P.YYYYMMDD
                   , P.QTY
                FROM DM_PLN_SHIPMENT_REQ P
                   , SCM_MST_SITE FZ
               WHERE P.DIVISION_ID   = FZ.DIVISION_ID(+)
                 AND P.PLANT_SITE_ID = FZ.SCM_SITE_ID(+)
                 AND FZ.VALID_YN(+)  = 'Y'
                 AND P.DIVISION_ID = V_P_DIVISION_ID
                 /* AND P.YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD,ISNULL(FZ.SHIP_FROZEN,0),GETDATE()),112) -- 확정구간의 다음날짜가 나오므로 >= 로 처리함 */
                 AND P.YYYYMMDD >= V_P_FROM_YYYYMMDD
                 AND P.YYYYMMDD <= V_P_TO_YYYYMMDD
          ) A
         GROUP BY A.DIVISION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.FROM_SITE;

        /* TOTAL_REQ Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT DIVISION_ID
             , ITEM_ID
             , FROM_SITE                        AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'TOTAL_REQ'                      AS MEASURE
             , YYYYMMDD
             , ''                               AS BOD_ID
             , SUM(QTY)                         AS QTY
             , ''                               AS INCOTERMS
             , ''                               AS TRANSPORT_MODE
             , ''                               AS FCST_TYPE
             , 8                                AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM
          (
              SELECT P.DIVISION_ID
                   , P.PLANT_SITE_ID  AS FROM_SITE
                   , P.ITEM_ID
                   , P.YYYYMMDD
                   , P.QTY
                FROM DM_PLN_SHIPMENT_REQ P
                   , SCM_MST_SITE TS
               WHERE P.DIVISION_ID  = TS.DIVISION_ID
                 AND P.SCM_SITE_ID  = TS.SCM_SITE_ID
                 AND TS.VALID_YN    = 'Y'
                 /* AND P.SITE_TYPE    = 'SALES' */
                 AND P.DIVISION_ID = V_P_DIVISION_ID
                 AND P.YYYYMMDD   >= V_P_FROM_YYYYMMDD   /* @v_last_plan_start_yyyymmdd */
                 AND P.YYYYMMDD   <= V_P_TO_YYYYMMDD
          ) A
         GROUP BY A.DIVISION_ID
                , A.ITEM_ID
                , A.YYYYMMDD
                , A.FROM_SITE;

        /* WH_BOH_PLAN Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        SELECT A.DIVISION_ID
             , A.ITEM_ID                        AS ITEM_ID
             , A.FROM_SITE                      AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'WH_BOH_PLAN'                    AS MEASURE
             , A.YYYYMMDD
             , ''                               AS BOD_ID
             , NVL(A.STOCK_QTY, 0)              AS QTY  --  2026.11.25 ZIONEX 성능 : 원본 SUM(CASE … THEN 0 … ELSE 0 END) 는 항상 0 -> 재고 수량만 사용
             /* 원본 : , SUM(CASE WHEN C.MEASURE = 'TOTAL_PLAN' AND C.YYYYMMDD = TO_CHAR(SYSDATE - 1, 'YYYYMMDD') THEN 0 ELSE 0 END) + NVL(A.STOCK_QTY, 0) AS QTY */
             /* , ISNULL(A.STOCK_QTY, 0) AS QTY */
             , ''                               AS INCOTERMS
             , ''                               AS TRANSPORT_MODE
             , ''                               AS FCST_TYPE
             , 9                                AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM
          (
              SELECT A.DIVISION_ID
                   , A.FROM_SITE            AS FROM_SITE
                   , A.ITEM_ID              AS ITEM_ID
                   , A.YYYYMMDD             AS YYYYMMDD
                   , SUM(NVL(A.QTY, 0))     AS STOCK_QTY
                FROM SSP_ANL_SHIP_PLAN_40 A
                   , GT_SSP0026_STD ST
               WHERE 1 = 1
                 AND ST.DIVISION_ID         = A.DIVISION_ID
                 AND ST.FROM_SITE           = A.FROM_SITE
                 AND ST.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                 AND A.DIVISION_ID = V_P_DIVISION_ID
                 AND A.BIZ_TYPE    = 'A'
                 AND A.MEASURE     = 'WH_STOCK'
                 AND A.YYYYMMDD   >= V_P_FROM_YYYYMMDD   /* @v_last_plan_start_yyyymmdd */
                 AND A.YYYYMMDD   <= V_P_TO_YYYYMMDD
               GROUP BY A.DIVISION_ID
                      , A.FROM_SITE
                      , A.ITEM_ID
                      , A.YYYYMMDD
          ) A

         /* 2026.11.25 ZIONEX 성능 : 누적 조인 C(GT_SSP0026_ROW TOTAL_PLAN) 제거 - 수량 계산에 쓰이지 않고 A 는 집계 키로 유일 */
         /* 2026.11.25 ZIONEX 원본 (START)
        , (
              SELECT A.DIVISION_ID
                   , A.ITEM_ID AS ITEM_ID
                   , A.FROM_SITE
                   , A.YYYYMMDD
                   , A.MEASURE
                   , A.QTY
                FROM GT_SSP0026_ROW A
               WHERE 1 = 1
                 AND A.DIVISION_ID = V_P_DIVISION_ID
                 AND A.MEASURE    IN ('TOTAL_PLAN')
                 AND A.YYYYMMDD   >= V_LAST_PLAN_START_YYYYMMDD
                 AND A.YYYYMMDD   <= V_P_TO_YYYYMMDD
          ) C
         WHERE 1 = 1
           AND C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.ITEM_ID(+)     = A.ITEM_ID
           AND C.YYYYMMDD(+)   <= A.YYYYMMDD
           AND C.FROM_SITE(+)   = A.FROM_SITE
            2026.11.25 ZIONEX 원본 (END) */
         GROUP BY A.DIVISION_ID
                , A.ITEM_ID
                , A.FROM_SITE
                , A.YYYYMMDD
                , A.STOCK_QTY;

        /*        WH_BOH_REQ Meausre 생성
        INSERT INTO #TMP_ROWDATA
        SELECT A.DIVISION_ID
            , A.ITEM_ID     AS ITEM_ID
            , A.FROM_SITE       AS FROM_SITE
            , '-'           AS TO_SITE
            , 'WH_BOH_REQ'      AS MEASURE
            , A.YYYYMMDD
            , ''                AS BOD_ID
            , SUM(CASE WHEN C.MEASURE = 'TOTAL_REQ'  AND C.YYYYMMDD =  CONVERT(NVARCHAR(8), GETDATE()-1,    112) THEN 0
                     WHEN C.MEASURE = 'TOTAL_REQ'  AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD,21,GETDATE()),112) THEN -1 * ISNULL(C.QTY,0)
                     WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD =  CONVERT(NVARCHAR(8), GETDATE()-1,  112) THEN 0
                     WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(),    112) AND C.YYYYMMDD < A.YYYYMMDD THEN ISNULL(C.QTY, 0) ELSE 0 END)
              + ISNULL(A.STOCK_QTY, 0) AS QTY
            , ''                AS INCOTERMS
            , ''                AS TRANSPORT_MODE
            , ''                AS FCST_TYPE
            , 10                AS SEQ
            , NULL          AS LAST_UPDATED_BY
            , NULL          AS LAST_UPDATE_DATE
            , '-'           AS REMARK
        FROM (
            SELECT A.DIVISION_ID
                , A.FROM_SITE       AS FROM_SITE
                , A.ITEM_ID     AS ITEM_ID
                , A.YYYYMMDD        AS YYYYMMDD
                , SUM(ISNULL(A.QTY, 0))  AS STOCK_QTY
            FROM   SSP_ANL_SHIP_PLAN_40 A (NOLOCK)
            INNER JOIN #TblDynamic_SSP0026_40_STD ST
                ON ST.DIVISION_ID = A.DIVISION_ID
               AND ST.FROM_SITE   = A.FROM_SITE
               AND ST.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
            WHERE  1 = 1
            AND A.DIVISION_ID           = @p_division_id
            AND A.BIZ_TYPE          = 'A'
            AND A.MEASURE               = 'WH_STOCK'
            AND A.YYYYMMDD          >= @v_last_plan_start_yyyymmdd
            AND A.YYYYMMDD          <= @p_to_yyyymmdd
            AND (( @p_item_id       IS NULL OR @p_item_id ='')      OR A.ITEM_ID            IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
            AND (( @p_plant_site_id IS NULL OR @p_plant_site_id ='')   OR A.FROM_SITE           IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_site_id , ',')))
            GROUP BY A.DIVISION_ID
                , A.FROM_SITE
                , A.ITEM_ID
                , A.YYYYMMDD
        ) A
        LEFT OUTER JOIN (
                        SELECT A.DIVISION_ID
                            , A.ITEM_ID AS ITEM_ID
                            , A.FROM_SITE
                            , A.YYYYMMDD
                            , A.MEASURE
                            , A.QTY
                        FROM   #TMP_ROWDATA  A WITH(NOLOCK)
                        WHERE  1 = 1
                        AND    A.DIVISION_ID = @p_division_id
                        AND    A.YYYYMMDD   >= @v_last_plan_start_yyyymmdd
                        AND    A.YYYYMMDD   <= @p_to_yyyymmdd
                        AND    A.MEASURE    IN ('TOTAL_REQ')
        ) C
        ON   C.DIVISION_ID      = A.DIVISION_ID
            AND  C.ITEM_ID      = A.ITEM_ID
            AND  C.YYYYMMDD     <= A.YYYYMMDD
            AND  C.FROM_SITE    = A.FROM_SITE
        WHERE  1 = 1
        GROUP BY A.DIVISION_ID
            , A.ITEM_ID
            , A.FROM_SITE
            , A.YYYYMMDD
            , A.STOCK_QTY;
        */

        /* WH_BOH_REQ Meausre 생성 */
        INSERT INTO GT_SSP0026_ROW
        (
            DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY
          , INCOTERMS, TRANSPORT_MODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK
        )
        WITH Z AS
        (

            SELECT DISTINCT R.DIVISION_ID
                          , R.ITEM_ID
                          , R.FROM_SITE
                          , O.BASIS_YYYYMMDD AS YYYYMMDD
              FROM SCM_SYS_CALENDAR_M O

                 , (
                       SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , FROM_SITE
                         FROM GT_SSP0026_ROW
                   ) R
             WHERE O.BASIS_YYYYMMDD >= V_LAST_PLAN_START_YYYYMMDD
               AND O.BASIS_YYYYMMDD <= V_P_TO_YYYYMMDD
        )
      , BOH AS
        (
            SELECT A.DIVISION_ID
                 , A.FROM_SITE          AS FROM_SITE
                 , A.ITEM_ID            AS ITEM_ID
                 , A.YYYYMMDD           AS YYYYMMDD
                 , SUM(NVL(A.QTY, 0))   AS QTY
              FROM SSP_ANL_SHIP_PLAN_40 A
                 , GT_SSP0026_STD ST
             WHERE 1 = 1
               AND ST.DIVISION_ID         = A.DIVISION_ID
               AND ST.FROM_SITE           = A.FROM_SITE
               AND ST.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
               AND A.DIVISION_ID = V_P_DIVISION_ID
               AND A.BIZ_TYPE    = 'A'
               AND A.MEASURE     = 'WH_STOCK'
               AND A.YYYYMMDD    = V_LAST_PLAN_START_YYYYMMDD
               AND ( ( V_P_ITEM_ID       IS NULL ) OR A.ITEM_ID   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_P_ITEM_ID, ','))) )
               AND ( ( V_P_PLANT_SITE_ID IS NULL ) OR A.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_P_PLANT_SITE_ID, ','))) )
             GROUP BY A.DIVISION_ID
                    , A.FROM_SITE
                    , A.ITEM_ID
                    , A.YYYYMMDD
        )
        SELECT Z.DIVISION_ID
             , Z.ITEM_ID                        AS ITEM_ID
             , Z.FROM_SITE                      AS FROM_SITE
             , '-'                              AS TO_SITE
             , 'WH_BOH_REQ'                     AS MEASURE
             , Z.YYYYMMDD
             , ''                               AS BOD_ID
             , SUM(CASE WHEN X.MEASURE  = 'TOTAL_REQ' AND X.YYYYMMDD > V_LAST_PLAN_START_YYYYMMDD THEN -1 * NVL(X.QTY, 0)
                        WHEN X.MEASURE <> 'TOTAL_REQ' AND X.YYYYMMDD < Z.YYYYMMDD THEN NVL(X.QTY, 0)
                        ELSE 0 END) + NVL(BOH.QTY, 0)   AS QTY
             , ''                               AS INCOTERMS
             , ''                               AS TRANSPORT_MODE
             , ''                               AS FCST_TYPE
             , 10                               AS SEQ
             , CAST(NULL AS VARCHAR2(50 CHAR))  AS LAST_UPDATED_BY
             , CAST(NULL AS DATE)               AS LAST_UPDATE_DATE
             , '-'                              AS REMARK
          FROM Z
             , BOH
             , GT_SSP0026_ROW X
         WHERE Z.DIVISION_ID = BOH.DIVISION_ID(+)
           AND Z.ITEM_ID     = BOH.ITEM_ID(+)
           AND Z.FROM_SITE   = BOH.FROM_SITE(+)
           AND X.DIVISION_ID(+) = Z.DIVISION_ID
           AND X.ITEM_ID(+)     = Z.ITEM_ID
           AND X.YYYYMMDD(+)   <= Z.YYYYMMDD
           AND X.FROM_SITE(+)   = Z.FROM_SITE
           AND X.MEASURE(+)    IN ('TOTAL_REQ')
         GROUP BY Z.DIVISION_ID, Z.ITEM_ID, Z.YYYYMMDD, BOH.QTY, Z.FROM_SITE;

        INSERT INTO GT_SSP0026_RAW
        (
            DIVISION_ID
          , ITEM_ID
          , FROM_SITE
          , TO_SITE
          , MEASURE
          , MEASURE_NAME
          , YYYYMMDD
          , BOD_ID
          , QTY
          , INCOTERMS
          , TRANSPORT_MODE
          , FCST_TYPE
          , SEQ
          , REQUESTOR
        )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.ITEM_ID
             , X.FROM_SITE
             , X.TO_SITE AS TO_SITE
             , X.MEASURE
             , X.MEASURE_NAME
             , X.YYYYMMDD
             , '-'              AS BOD_ID
             , NVL(R.QTY, 0)    AS QTY
             , '-'              AS INCOTERMS
             , '-'              AS TRANSPORT_MODE
             , '-'              AS FCST_TYPE
             , X.SEQ
             , R.LAST_UPDATED_BY
          FROM
          (
              SELECT DISTINCT T.DIVISION_ID
                   , T.ITEM_ID
                   , NVL(T.FROM_SITE, '-')      AS FROM_SITE
                   , NVL(T.TO_SITE, '-')        AS TO_SITE
                   , T.BOD_ID
                   , T.QTY
                   , T.INCOTERMS
                   , T.TRANSPORT_MODE
                   , T.FCST_TYPE
                   , TT1.COLUMN_NAME            AS MEASURE
                   , TT1.COLUMN_LABEL_NAME      AS MEASURE_NAME
                   , TT1.ATTRIBUTE3             AS BACK_COLOR
                   , TT1.SORT_ORDER_NO          AS SEQ
                   , T.YYYYMMDD
                FROM GT_SSP0026_ROW T
                   , SCM_MST_SHEET_MEASURE TT1
               WHERE 1 = 1
                 /* 원본 INNER JOIN 의 ON 이 상수필터뿐(=사실상 CROSS JOIN + 필터). INNER 이므로 WHERE 이동은 동치 */
                 AND TT1.PROGRAM_ID = V_P_PROGRAM_ID
                 AND TT1.SHEET_NAME = V_P_SHEET_NAME
          ) X
             , GT_SSP0026_ROW R
         WHERE R.DIVISION_ID(+) = X.DIVISION_ID
           AND R.ITEM_ID(+)     = X.ITEM_ID
           AND R.MEASURE(+)     = X.MEASURE
           AND R.YYYYMMDD(+)    = X.YYYYMMDD
           AND R.FROM_SITE(+)   = X.FROM_SITE
           AND R.TO_SITE(+)     = X.TO_SITE
           AND ( X.TO_SITE = '-' AND X.MEASURE IN ('WH_BOH_PLAN', 'WH_BOH_REQ', 'TOTAL_PLAN', 'TOTAL_REQ', 'POSTP_PLAN', 'SITE_MOVE', 'CUST_MOVE', 'WH_IN') )
         /* WHERE ( X.TO_SITE != '-'    AND  X.MEASURE IN ( 'SCP_SHIP_PLAN','SHIP_REQ','SHIP_PLAN') )
              OR ( X.TO_SITE = '-'  AND  X.MEASURE IN ( 'WH_BOH_PLAN','WH_BOH_REQ','TOTAL_PLAN','TOTAL_REQ','POSTP_PLAN', 'SITE_MOVE','WH_IN') ) */
        UNION ALL
        SELECT DISTINCT
               X.DIVISION_ID
             , X.ITEM_ID
             , X.FROM_SITE
             , X.TO_SITE
             , X.MEASURE
             , X.MEASURE_NAME
             , X.YYYYMMDD
             , NVL(X.BOD_ID, '-')           AS BOD_ID
             , NVL(R.QTY, 0)                AS QTY
             , NVL(X.INCOTERMS, '-')        AS INCOTERMS
             , NVL(X.TRANSPORT_MODE, '-')   AS TRANSPORT_MODE
             , NVL(X.FCST_TYPE, '-')        AS FCST_TYPE
             , X.SEQ
             , R.LAST_UPDATED_BY
          FROM
          (
              SELECT DISTINCT T.DIVISION_ID
                   , T.ITEM_ID
                   , NVL(T.FROM_SITE, '-')      AS FROM_SITE
                   , NVL(T.TO_SITE, '-')        AS TO_SITE
                   , T.BOD_ID
                   , T.QTY
                   , T.INCOTERMS
                   , T.TRANSPORT_MODE
                   , T.FCST_TYPE
                   , TT1.COLUMN_NAME            AS MEASURE
                   , TT1.COLUMN_LABEL_NAME      AS MEASURE_NAME
                   , TT1.ATTRIBUTE3             AS BACK_COLOR
                   , TT1.SORT_ORDER_NO          AS SEQ
                   , T.YYYYMMDD
                FROM GT_SSP0026_ROW T

               INNER JOIN SCM_MST_SITE TS
                  ON T.DIVISION_ID = TS.DIVISION_ID
                 AND T.TO_SITE     = TS.SCM_SITE_ID
                 AND TS.VALID_YN   = 'Y'
                 /* AND TS.SITE_TYPE    = 'SALES' */
                LEFT JOIN SCM_MST_SHEET_MEASURE TT1
                  ON TT1.PROGRAM_ID = V_P_PROGRAM_ID
                 AND TT1.SHEET_NAME = V_P_SHEET_NAME
          ) X
             , GT_SSP0026_ROW R
         WHERE R.DIVISION_ID(+) = X.DIVISION_ID
           AND R.ITEM_ID(+)     = X.ITEM_ID
           AND R.MEASURE(+)     = X.MEASURE
           AND R.YYYYMMDD(+)    = X.YYYYMMDD
           AND R.FROM_SITE(+)   = X.FROM_SITE
           AND R.TO_SITE(+)     = X.TO_SITE
           AND R.BOD_ID(+)      = X.BOD_ID
           AND R.FCST_TYPE(+)   = X.FCST_TYPE
           AND ( X.TO_SITE != '-' AND X.MEASURE IN ('SCP_SHIP_PLAN', 'SHIP_REQ', 'SHIP_PLAN') );

        /* RETURN; */

        /* ////////////////////////////////////////////////////////////////////////////////--
           //5. PIVOT                                                                   //--
           ////////////////////////////////////////////////////////////////////////////////-- */
        INSERT INTO GT_SSP0026_PIVOT
        (
            DIVISION_ID, ITEM_ID, DEPT_NAME_KO, DEPT_ID, MKT_USER, FROM_SITE, TO_SITE, SOLDTO_CUSTOMER
          , MEASURE, MEASURE_NAME, BOD_ID, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, INCOTERMS, TRANSPORT_MODE
          , FCST_TYPE, SEQ, CONFIRM_DAY, ROW_NUM, REQUESTOR
        )
        SELECT DISTINCT T0.DIVISION_ID
             , T0.ITEM_ID
             , TEAM.DEPT_NAME_KO
             , TEAM.DEPT_ID
             , (SELECT FN_GET_SSP_PROJECT_OWNER(T0.DIVISION_ID, T0.TO_SITE, T0.ITEM_ID, NULL) FROM DUAL) AS MKT_USER   /* T2.MKT_USER */  --  2026.11.25 ZIONEX 성능 : 같은 인자는 1회 호출(스칼라 서브쿼리 캐시)
             /* , T2.MKT_USER */
             , T0.FROM_SITE
             , T0.TO_SITE
             , T4.SOLDTO_CUSTOMER
             , T0.MEASURE
             , T0.MEASURE_NAME
             , T0.BOD_ID
             /* , 'D_' + T0.YYYYMMDD                        AS YYYYMMDD */
             , T0.YYYYMMDD                                  AS YYYYMMDD
             , T1.BASIS_YYYYMM                              AS YYYYMM
             /*                한쪽만 NULL 인 경우가 갈린다 -> CASE 가드로 1:1 재현(T1 은 LEFT OUTER JOIN 대상) */
             , CASE WHEN T1.BASIS_YYYYMM IS NULL OR T1.ISO_WEEK IS NULL THEN NULL
                    ELSE SUBSTR(T1.BASIS_YYYYMM, -4) || T1.ISO_WEEK
               END                                          AS ISO_WEEK
             , T0.QTY AS QTY
             , T0.INCOTERMS
             , T0.TRANSPORT_MODE
             , T0.FCST_TYPE
             , T0.SEQ
             , T5.SHIP_FROZEN                               AS CONFIRM_DAY
             , RANK() OVER (PARTITION BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.TO_SITE, T0.MEASURE, T0.BOD_ID
                                ORDER BY T0.MEASURE, CASE WHEN T0.YYYYMMDD IS NULL THEN 'N' ELSE 'Y' END DESC
                           )                                AS ROW_NUM
             , T0.REQUESTOR
          FROM GT_SSP0026_RAW T0
         /* ★이 블록은 ANSI 유지 : 아래 TEAM 조인의 ON 이 IN (서브쿼리)라 TEAM.USER_ID(+) IN (SELECT ..) 가 */
         /* MEASURE가 10개가 안돼면 화면에 Display 하지 않음 */
         INNER JOIN
              (
                  SELECT AAA.ITEM_ID, AAA.FROM_SITE, COUNT(*) AS CNT
                    FROM
                    (
                        SELECT DISTINCT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE
                          FROM GT_SSP0026_RAW
                    ) AAA
                   GROUP BY AAA.ITEM_ID, AAA.FROM_SITE
                  HAVING COUNT(*) >= 10
              ) MC
            ON T0.ITEM_ID   = MC.ITEM_ID
           AND T0.FROM_SITE = MC.FROM_SITE
          LEFT OUTER JOIN SCM_MST_SITE T4
            ON T0.DIVISION_ID = T4.DIVISION_ID
           AND T0.TO_SITE     = T4.SCM_SITE_ID
           AND T4.VALID_YN    = 'Y'
          LEFT OUTER JOIN SCM_MST_SITE T5
            ON T0.DIVISION_ID = T5.DIVISION_ID
           AND T0.FROM_SITE   = T5.SCM_SITE_ID
           AND T5.VALID_YN    = 'Y'
          /* LEFT OUTER JOIN  SCM_MST_SITE_ITEM T6 WITH(NOLOCK)
                 ON T6.DIVISION_ID = T0.DIVISION_ID
                AND T6.SCM_SITE_ID = T0.TO_SITE
                AND T6.ITEM_ID = T0.ITEM_ID
                AND OWNER IS NOT  NULL */
          LEFT OUTER JOIN
              (
                  SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.OWNER
                       , RANK() OVER (PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID ORDER BY A.PROJECT_CODE, A.OWNER DESC) AS RN
                    FROM SCM_MST_SITE_ITEM A
                   WHERE A.DIVISION_ID = V_P_DIVISION_ID
                     AND A.OWNER IS NOT NULL
                     /* GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID */
              ) T6   /* 해당 ITEM_ID MCCE121501A2  SCM_MST_SITE_ITEM PROJECT_CODE 두개 확인! */
            ON T6.DIVISION_ID = T0.DIVISION_ID
           AND T6.SCM_SITE_ID = T0.TO_SITE
           AND T6.ITEM_ID     = T0.ITEM_ID
           AND T6.RN          = 1
          LEFT OUTER JOIN SCM_SYS_CALENDAR_M T1
            ON T0.YYYYMMDD = T1.BASIS_YYYYMMDD
          /* LEFT OUTER JOIN SSP_MKT_USER_V T2
                 ON T2.DIVISION_ID = T0.DIVISION_ID
                AND T2.ITEM_ID = T0.ITEM_ID
                AND T2.TO_SITE = T0.TO_SITE */
          LEFT JOIN
              (
                  SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                    FROM SCM_MST_SSO_USER_INFO B
                   INNER JOIN SCM_MST_SSO_DEPT_INFO C
                      ON B.DEPT_ID = C.DEPT_ID
              ) TEAM
            ON TEAM.USER_ID = TRIM(CASE WHEN INSTR(T6.OWNER, ',') > 0 THEN SUBSTR(T6.OWNER, 1, INSTR(T6.OWNER, ',') - 1)  --  2026.11.25 ZIONEX 성능 : STRING_SPLIT 첫 토큰을 식으로 계산(등호 조인)
                                        ELSE T6.OWNER
                                   END)
            /* 원본 : ON TEAM.USER_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(T6.OWNER, ',')) WHERE ROWNUM = 1) */
         WHERE 1 = 1;
         /* AND T0.TO_SITE = 'High Power (Icon)_CN_SZX' */

        /* SELECT * FROM #TMP_RESULT_PIVOT_TABLE_TEMP WHERE TO_sITE = 'High Power (Icon)_CN_SZX' */

        INSERT INTO GT_SSP0026_R01
        (
            DIVISION_ID, FROM_SITE, TO_SITE, DEPT_NAME_KO, MKT_USER, ITEM_ID, MEASURE, MEASURE_NAME
          , SEQ, CONFIRM_DAY, YYYYMMDD, QTY, ROW_NUM, REQUESTOR
        )
        SELECT DISTINCT
               T0.DIVISION_ID
             , T0.FROM_SITE
             , T0.TO_SITE
             , T0.DEPT_NAME_KO
             , T0.MKT_USER
             , T0.ITEM_ID
             , T0.MEASURE
             , T0.MEASURE_NAME
             , T0.SEQ
             /* , CONVERT(VARCHAR(8), DATEADD(DD, isnull(T0.CONFIRM_DAY,0), CONVERT(VARCHAR, '20201120', 121)), 112) AS CONFIRM_DAY */
             , TO_CHAR(SYSDATE + NVL(T0.CONFIRM_DAY, 0), 'YYYYMMDD')    AS CONFIRM_DAY
             , T0.YYYYMMDD
             , T0.QTY
             , RANK() OVER (PARTITION BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.TO_SITE, T0.MEASURE, T0.BOD_ID
                                ORDER BY T0.MEASURE, CASE WHEN T0.YYYYMMDD IS NULL THEN 'N' ELSE 'Y' END DESC
                           )                                            AS ROW_NUM
             , T0.REQUESTOR
          FROM GT_SSP0026_PIVOT T0
         WHERE T0.DIVISION_ID = V_P_DIVISION_ID
           AND (SELECT FN_GET_SSP_SITE_INFO(T0.DIVISION_ID, T0.FROM_SITE, 'COMPANY_ID') FROM DUAL) = V_P_COMPANY_ID;  --  2026.11.25 ZIONEX 성능 : 같은 From Site 는 1회 호출(스칼라 서브쿼리 캐시)

        /* //TEST-01 */

        /* SELECT * FROM #Tmp_Result_01 where measure = 'SHIP_REQ';
           ORDER BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, SEQ
           ;
           RETURN; */

        INSERT INTO GT_SSP0026_R02
        (
            RN, MAIL_RECEIVER, DIVISION_ID, FROM_SITE, TO_SITE, DEPT_NAME_KO, MKT_USER, ITEM_ID
          , MEASURE, MEASURE_NAME, SEQ, YYYYMMDD, QTY
        )
        WITH RESULT_DATA AS
        (
            SELECT DENSE_RANK() OVER (ORDER BY T0.CONFIRM_DAY) AS RN
                 , T0.DIVISION_ID
                 , T0.FROM_SITE
                 , T0.TO_SITE
                 , T0.DEPT_NAME_KO
                 , T0.MKT_USER
                 , T0.ITEM_ID
                 , T0.MEASURE
                 , T0.MEASURE_NAME
                 , T0.SEQ
                 , T0.YYYYMMDD
                 , T0.QTY AS QTY
                 , T0.REQUESTOR
              FROM GT_SSP0026_R01 T0
             WHERE 1 = 1
               AND T0.YYYYMMDD >= TO_CHAR(SYSDATE + 21, 'YYYYMMDD')
               AND T0.YYYYMMDD <= TO_CHAR(SYSDATE + 25, 'YYYYMMDD')
               AND EXISTS
                   (
                       SELECT *
                         FROM GT_SSP0026_R01 B
                        WHERE 1 = 1
                          AND B.MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')
                          AND B.YYYYMMDD >= TO_CHAR(SYSDATE + 21, 'YYYYMMDD')
                          AND B.YYYYMMDD <= TO_CHAR(SYSDATE + 25, 'YYYYMMDD')
                          AND B.QTY > 0
                          AND B.DIVISION_ID = T0.DIVISION_ID
                          AND B.DIVISION_ID = V_P_DIVISION_ID
                          AND B.FROM_SITE = T0.FROM_SITE
                          AND B.ITEM_ID = T0.ITEM_ID
                   )
               AND EXISTS
                   (
                       SELECT *
                         FROM GT_SSP0026_R01 B
                        WHERE 1 = 1
                          AND B.MEASURE = 'WH_BOH_PLAN'
                          AND B.YYYYMMDD >= TO_CHAR(SYSDATE + 21, 'YYYYMMDD')
                          AND B.YYYYMMDD <= TO_CHAR(SYSDATE + 25, 'YYYYMMDD')
                          AND B.QTY < 0
                          AND B.DIVISION_ID = T0.DIVISION_ID
                          AND B.DIVISION_ID = V_P_DIVISION_ID
                          AND B.FROM_SITE = T0.FROM_SITE
                          AND B.ITEM_ID = T0.ITEM_ID
                   )
               AND T0.DIVISION_ID = V_P_DIVISION_ID
        )
        SELECT T0.RN
             , T0.MAIL_RECEIVER
             , T0.DIVISION_ID
             , T0.FROM_SITE
             , T0.TO_SITE
             , T0.DEPT_NAME_KO
             , T0.MKT_USER
             , T0.ITEM_ID
             , T0.MEASURE
             , T0.MEASURE_NAME
             , T0.SEQ
             , T0.YYYYMMDD
             , SUM(T0.QTY) AS QTY
             /* , T0.REQUESTOR */
          FROM
          (
              SELECT DISTINCT
                     XX.RN
                     /* ,'kimyh8848'  as MAIL_RECEIVER --XX.MAIL_RECEIVER */
                   , XX.MAIL_RECEIVER
                   , XX.DIVISION_ID
                   , XX.FROM_SITE
                   , XX.TO_SITE
                   , XX.DEPT_NAME_KO
                   , XX.MKT_USER
                   , XX.ITEM_ID
                   , XX.MEASURE
                   , XX.MEASURE_NAME
                   , XX.SEQ
                   , XX.YYYYMMDD
                   , XX.QTY
                FROM
                (
                    SELECT X.RN
                         , U.SEGMENT2            AS MAIL_RECEIVER
                         , X.DIVISION_ID
                         , X.FROM_SITE
                         , X.TO_SITE
                         , X.DEPT_NAME_KO
                         , X.MKT_USER
                         , X.ITEM_ID
                         , X.MEASURE
                         , X.MEASURE_NAME
                         , X.SEQ
                         , X.YYYYMMDD
                         , X.QTY
                      FROM RESULT_DATA X

                    , (
                          SELECT M.SEGMENT2
                               , A.DIVISION_ID
                               , A.FROM_SITE
                               , A.TO_SITE
                               , A.ITEM_ID
                            FROM
                            (
                                SELECT DIVISION_ID
                                     , FROM_SITE
                                     , TO_SITE
                                     , ITEM_ID
                                     , MKT_USER
                                  FROM RESULT_DATA
                                 WHERE 1 = 1
                                   AND MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')
                            ) A
                               , SCM_ADM_LOOKUP_MASTER_DETAIL M
                           WHERE M.LOOKUP_TYPE = 'WARNING_MAIL_SEND_40'
                             AND M.VALID_YN    = 'Y'
                             AND M.SEGMENT1    = 'SSP'
                             AND M.SEGMENT3    = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE A.FROM_SITE END
                             AND M.SEGMENT4    = CASE WHEN M.SEGMENT4 = 'ALL' THEN 'ALL' ELSE A.TO_SITE END
                             AND M.SEGMENT5    = CASE WHEN M.SEGMENT5 = 'ALL' THEN 'ALL' ELSE A.ITEM_ID END
                           GROUP BY M.SEGMENT2, A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, A.ITEM_ID
                           /* GROUP BY A.DIVISION_ID,   A.FROM_SITE, A.ITEM_ID */
                      ) U
                     WHERE U.DIVISION_ID = X.DIVISION_ID AND U.FROM_SITE = X.FROM_SITE
                       AND U.ITEM_ID = X.ITEM_ID
                     GROUP BY X.RN
                            , U.SEGMENT2
                            , X.DIVISION_ID
                            , X.FROM_SITE
                            , X.TO_SITE
                            , X.DEPT_NAME_KO
                            , X.MKT_USER
                            , X.ITEM_ID
                            , X.MEASURE
                            , X.MEASURE_NAME
                            , X.SEQ
                            , X.YYYYMMDD
                            , X.QTY
                    UNION ALL
                    /* MKT OWNER (DIVISION_ID, ITEM_ID, TO_SITE) */
                    SELECT X.RN
                         , U.MKT_USER            AS MAIL_RECEIVER
                         , X.DIVISION_ID
                         , X.FROM_SITE
                         , X.TO_SITE
                         , X.DEPT_NAME_KO
                         , X.MKT_USER
                         , X.ITEM_ID
                         , X.MEASURE
                         , X.MEASURE_NAME
                         , X.SEQ
                         , X.YYYYMMDD
                         , X.QTY
                      FROM RESULT_DATA X

                    , (
                          SELECT B.MKT_USER
                               , A.DIVISION_ID
                               , A.FROM_SITE
                               , A.ITEM_ID
                            FROM
                            (
                                SELECT DIVISION_ID
                                     , FROM_SITE
                                     , TO_SITE
                                     , ITEM_ID
                                     , MKT_USER
                                  FROM RESULT_DATA
                                 WHERE 1 = 1
                                   AND MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')
                            ) A
                               , ( SELECT MU.DIVISION_ID  --  2026.11.25 ZIONEX 성능 : SSP_MKT_USER_V 와 같은 정의, 대상 키(사업부 · 품목 · To Site)만 계산
                                        , MU.ITEM_ID
                                        , MU.SCM_SITE_ID AS TO_SITE
                                        , MU.PROJECT_CODE
                                        , MU.MKT_USER
                                     FROM ( SELECT S.DIVISION_ID
                                                 , S.ITEM_ID
                                                 , S.SCM_SITE_ID
                                                 , S.PROJECT_CODE
                                                 , FN_SCM_SPLIT(S.OWNER, 1, ',') AS MKT_USER1
                                                 , FN_SCM_SPLIT(S.OWNER, 2, ',') AS MKT_USER2
                                                 , FN_SCM_SPLIT(S.OWNER, 3, ',') AS MKT_USER3
                                                 , FN_SCM_SPLIT(S.OWNER, 4, ',') AS MKT_USER4
                                                 , FN_SCM_SPLIT(S.OWNER, 5, ',') AS MKT_USER5
                                              FROM ( SELECT SI.DIVISION_ID
                                                          , SI.ITEM_ID
                                                          , SI.SCM_SITE_ID
                                                          , SI.PROJECT_CODE
                                                          , MAX(SI.OWNER) AS OWNER
                                                       FROM SCM_MST_SITE_ITEM SI
                                                      WHERE SI.VALID_YN = 'Y'
                                                        AND ( SI.DIVISION_ID, SI.ITEM_ID, SI.SCM_SITE_ID ) IN ( SELECT RD.DIVISION_ID
                                                                                                                  , RD.ITEM_ID
                                                                                                                  , RD.TO_SITE
                                                                                                               FROM RESULT_DATA RD
                                                                                                              WHERE RD.MEASURE IN ('SHIP_PLAN', 'SHIP_REQ') )
                                                      GROUP BY SI.DIVISION_ID
                                                             , SI.ITEM_ID
                                                             , SI.SCM_SITE_ID
                                                             , SI.PROJECT_CODE
                                                   ) S
                                          ) T
                                   UNPIVOT ( MKT_USER FOR AA IN ( MKT_USER1, MKT_USER2, MKT_USER3, MKT_USER4, MKT_USER5 ) ) MU
                                 ) B  /* 원본 : , SSP_MKT_USER_V B */
                           WHERE B.DIVISION_ID = A.DIVISION_ID
                             AND B.TO_SITE     = A.TO_SITE
                             AND B.ITEM_ID     = A.ITEM_ID
                             AND B.MKT_USER    = A.MKT_USER
                           GROUP BY B.MKT_USER, A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID
                      ) U
                     WHERE U.DIVISION_ID = X.DIVISION_ID AND U.FROM_SITE = X.FROM_SITE
                       AND U.ITEM_ID = X.ITEM_ID
                     GROUP BY X.RN
                            , U.MKT_USER
                            , X.DIVISION_ID
                            , X.FROM_SITE
                            , X.TO_SITE
                            , X.DEPT_NAME_KO
                            , X.MKT_USER
                            , X.ITEM_ID
                            , X.MEASURE
                            , X.MEASURE_NAME
                            , X.SEQ
                            , X.YYYYMMDD
                            , X.QTY
                    UNION ALL
                    /* REQUESTOR */
                    SELECT X.RN
                         , P.REQUESTOR           AS MAIL_RECEIVER
                         , X.DIVISION_ID         AS DIVISION_ID
                         , X.FROM_SITE           AS FROM_SITE
                         , X.TO_SITE             AS TO_SITE
                         , X.DEPT_NAME_KO
                         , X.MKT_USER
                         , X.ITEM_ID             AS ITEM_ID
                         , X.MEASURE
                         , X.MEASURE_NAME
                         , X.SEQ
                         , X.YYYYMMDD
                         , X.QTY
                         /* , X.REQUESTOR */
                      FROM RESULT_DATA X

                    , (
                          SELECT REQUESTOR
                               , DIVISION_ID
                               , FROM_SITE
                               , TO_SITE
                               , DEPT_NAME_KO
                               , MKT_USER
                               , ITEM_ID
                            FROM RESULT_DATA A
                           WHERE 1 = 1
                             AND MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')
                             AND REQUESTOR IS NOT NULL
                           GROUP BY REQUESTOR, DIVISION_ID, FROM_SITE, TO_SITE, DEPT_NAME_KO, MKT_USER, ITEM_ID
                      ) P
                      , SCM_ADM_USER_M U
                     WHERE 1 = 1
                       AND P.DIVISION_ID = X.DIVISION_ID AND P.FROM_SITE = X.FROM_SITE
                       AND P.ITEM_ID = X.ITEM_ID
                       AND UPPER(P.REQUESTOR) = UPPER(U.USER_ID)
                       AND U.USE_YN = 'Y'
                ) XX
          ) T0
         WHERE 1 = 1
         /* AND T0.MAIL_RECEIVER IN ('kimyh8848') */
         GROUP BY T0.RN
                , T0.MAIL_RECEIVER
                , T0.DIVISION_ID
                , T0.FROM_SITE
                , T0.TO_SITE
                , T0.DEPT_NAME_KO
                , T0.MKT_USER
                , T0.ITEM_ID
                , T0.MEASURE
                , T0.MEASURE_NAME
                , T0.SEQ
                , T0.YYYYMMDD
         ORDER BY T0.YYYYMMDD, T0.SEQ;

        V_FROMSITE_TMPCNT := 0;

        SELECT MAX(RN) INTO V_FROMSITE_CNT FROM GT_SSP0026_R02;

        /* //TEST-02
           SELECT * FROM #Tmp_Result_02;
           RETURN; */

        WHILE V_FROMSITE_TMPCNT < V_FROMSITE_CNT LOOP   /* FROM_SITE LOOP (MSSQL 과 동일하게 NULL 이면 즉시 종료) */

            DELETE FROM GT_SSP0026_MAIL;

            V_FROMSITE_TMPCNT := V_FROMSITE_TMPCNT + 1;

            V_SITE_FROM_YYYYMMDD := '';
            V_SITE_TO_YYYYMMDD   := '';
            /* FROM_YYYYMMDD. TO_YYYYMMDD 구하기 */
            SELECT MIN(YYYYMMDD)
                 , TO_CHAR(TO_DATE(MIN(YYYYMMDD), 'YYYYMMDD') + 4, 'YYYYMMDD')
              INTO V_SITE_FROM_YYYYMMDD, V_SITE_TO_YYYYMMDD
              /* @v_site_from_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, 21, CONVERT(VARCHAR, MIN(YYYYMMDD), 121)), 112), @v_site_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, 25, CONVERT(VARCHAR, MIN(YYYYMMDD), 121)), 112) */
              FROM GT_SSP0026_R02
             WHERE 1 = 1
               AND RN = V_FROMSITE_TMPCNT;

            /********************************************************************************
            * PIVOIT처리
            ********************************************************************************/
            /* 원본은 SCM_SYS_CALENDAR_M 에서 @v_site_from ~ @v_site_to(=from+4) 사이 basis_yyyymmdd 를 */
            /*          BEGIN
                DECLARE @mQuery NVARCHAR(MAX);
                DECLARE @mEXEC NVARCHAR(MAX);

                    -- PIVOIT 대상 날짜문자열 생성
                SELECT @mQuery = @mQuery + '[' + yyyymmdd + '], '
                FROM (
                    SELECT *
                    FROM(
                        SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
                            FROM [dbo].[scm_sys_calendar_m] a with(nolock)
                            WHERE a.basis_yyyymmdd  BETWEEN @v_site_from_yyyymmdd AND @v_site_to_yyyymmdd
                            --WHERE a.basis_yyyymmdd  BETWEEN '20210108' AND '20210111'
                        GROUP BY a.basis_yyyymm, a.month_name
                        SELECT a.basis_yyyymmdd   AS yyyymmdd
                                , a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
                            FROM [dbo].[scm_sys_calendar_m] a with(nolock)
                            WHERE a.basis_yyyymmdd  BETWEEN @v_site_from_yyyymmdd AND @v_site_to_yyyymmdd
                            --WHERE a.basis_yyyymmdd  BETWEEN '20210108' AND '20210111'
                        GROUP BY a.basis_yyyymmdd
                    ) A WHERE yyyymmdd NOT LIKE 'M_%'

                ORDER BY sort_order_no  ;

                BEGIN
                END;

                SET @mEXEC = '';
                SET @mEXEC = @mEXEC+'      SELECT  ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           RN AS SITE_SEQ ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,DENSE_RANK() OVER(PARTITION BY RN ORDER BY RN, MAIL_RECEIVER) AS REC_SEQ ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,DENSE_RANK() OVER(PARTITION BY RN, MAIL_RECEIVER ORDER BY RN, MAIL_RECEIVER, item_id) AS ITEM_SEQ ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,DENSE_RANK() OVER(PARTITION BY RN, MAIL_RECEIVER, ITEM_ID, from_site_description ORDER BY to_site_description) AS MEASURE_SEQ ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,MAIL_RECEIVER ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,division_id ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,COMPANY_ID ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,from_site_description      ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,to_site_description        ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,DEPT_NAME_KO       ' +CHAR(10);
                --SET @mEXEC = @mEXEC+'             ,[dbo].[FN_GET_SSP_MKT_OWNER_NAME](MKT_USER, '','', ''ko'') AS MKT_USER         ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,MKT_USER       ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,item_id    ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,[dbo].[FN_GET_ITEM_NICKNAME](division_id, item_id) AS NICK_NAME    ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,MEASURE AS MEASURE ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,MEASURE_NAME AS MEASURE_NAME   ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,seq    ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           ,'+@mQuery   +CHAR(10);
                SET @mEXEC = @mEXEC+'       FROM ' +CHAR(10);
                SET @mEXEC = @mEXEC+'       ( ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           SELECT  ' +CHAR(10);
                SET @mEXEC = @mEXEC+'               RN, MAIL_RECEIVER, division_id, ''' + @p_company_id + ''' AS COMPANY_ID, ' +CHAR(10);
                SET @mEXEC = @mEXEC+'               isnull(dbo.fn_get_scm_site_description(division_id, from_site ),''-'') AS from_site_description,  ' +CHAR(10);
                SET @mEXEC = @mEXEC+'               isnull(dbo.fn_get_scm_site_description(division_id, to_site ),''-'') AS to_site_description,  ' +CHAR(10);
                SET @mEXEC = @mEXEC+'               DEPT_NAME_KO, MKT_USER, ' +CHAR(10);
                SET @mEXEC = @mEXEC+'               item_id, MEASURE, MEASURE_NAME, seq, yyyymmdd, CEILING(qty) AS QTY ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           FROM #Tmp_Result_02 ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           WHERE 1 = 1 ' +CHAR(10);
                SET @mEXEC = @mEXEC+'           AND RN = ''' + CONVERT(NVARCHAR(MAX), @v_fromsite_tmpcnt) + ''' '+CHAR(10);
            --  SET @mEXEC = @mEXEC+'           AND MAIL_RECEIVER = ''kimkwanghee'' '+CHAR(10);
                SET @mEXEC = @mEXEC+'       ) T0 ' +CHAR(10);
                SET @mEXEC = @mEXEC+'       PIVOT ( ' +CHAR(10);
                SET @mEXEC = @mEXEC+'               SUM(qty) FOR  yyyymmdd IN ('+ @mQuery +') ' +CHAR(10);
                SET @mEXEC = @mEXEC+'             ) AS A'   +CHAR(10);
                SET @mEXEC = @mEXEC+'      ORDER BY RN, DENSE_RANK() OVER(PARTITION BY RN ORDER BY RN, MAIL_RECEIVER), item_id, DENSE_RANK() OVER(PARTITION BY RN, MAIL_RECEIVER ORDER BY RN, MAIL_RECEIVER, item_id), from_site_description, to_site_description desc , seq' +CHAR(10);
            END

            INSERT INTO #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
            EXEC (@mEXEC);

            */
            V_D1 := V_SITE_FROM_YYYYMMDD;
            V_D2 := TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');
            V_D3 := TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 2, 'YYYYMMDD');
            V_D4 := TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 3, 'YYYYMMDD');
            V_D5 := TO_CHAR(TO_DATE(V_SITE_FROM_YYYYMMDD, 'YYYYMMDD') + 4, 'YYYYMMDD');

            INSERT INTO GT_SSP0026_MAIL
            (
                SITE_SEQ, REC_SEQ, ITEM_SEQ, MEASURE_SEQ, MAIL_RECEIVER, DIVISION_ID, COMPANY_ID
              , FROM_SITE_DESCRIPTION, TO_SITE_DESCRIPTION, DEPT_NAME_KO, MKT_USER, ITEM_ID, NICK_NAME
              , MEASURE, MEASURE_NAME, SEQ, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
            )
            SELECT RN AS SITE_SEQ
                 , DENSE_RANK() OVER (PARTITION BY RN ORDER BY RN, MAIL_RECEIVER) AS REC_SEQ
                 , DENSE_RANK() OVER (PARTITION BY RN, MAIL_RECEIVER ORDER BY RN, MAIL_RECEIVER, ITEM_ID) AS ITEM_SEQ
                 , DENSE_RANK() OVER (PARTITION BY RN, MAIL_RECEIVER, ITEM_ID, FROM_SITE_DESCRIPTION ORDER BY TO_SITE_DESCRIPTION) AS MEASURE_SEQ
                 , MAIL_RECEIVER
                 , DIVISION_ID
                 , COMPANY_ID
                 , FROM_SITE_DESCRIPTION
                 , TO_SITE_DESCRIPTION
                 , DEPT_NAME_KO
                 /* , [dbo].[FN_GET_SSP_MKT_OWNER_NAME](MKT_USER, '', 'ko') AS MKT_USER */
                 , MKT_USER
                 , ITEM_ID
                 , FN_GET_ITEM_NICKNAME(DIVISION_ID, ITEM_ID) AS NICK_NAME
                 , MEASURE      AS MEASURE
                 , MEASURE_NAME AS MEASURE_NAME
                 , SEQ
                 , SUM(CASE WHEN YYYYMMDD = V_D1 THEN QTY END) AS SEGMENT1
                 , SUM(CASE WHEN YYYYMMDD = V_D2 THEN QTY END) AS SEGMENT2
                 , SUM(CASE WHEN YYYYMMDD = V_D3 THEN QTY END) AS SEGMENT3
                 , SUM(CASE WHEN YYYYMMDD = V_D4 THEN QTY END) AS SEGMENT4
                 , SUM(CASE WHEN YYYYMMDD = V_D5 THEN QTY END) AS SEGMENT5
              FROM
              (
                  SELECT RN, MAIL_RECEIVER, DIVISION_ID, V_P_COMPANY_ID AS COMPANY_ID
                       , NVL(FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                       , NVL(FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, TO_SITE), '-')   AS TO_SITE_DESCRIPTION
                       , DEPT_NAME_KO, MKT_USER
                       , ITEM_ID, MEASURE, MEASURE_NAME, SEQ, YYYYMMDD, CEIL(QTY) AS QTY
                    FROM GT_SSP0026_R02
                   WHERE 1 = 1
                     AND RN = V_FROMSITE_TMPCNT
                     /* AND MAIL_RECEIVER = 'kimkwanghee' */
              ) T0
             GROUP BY RN, MAIL_RECEIVER, DIVISION_ID, COMPANY_ID, FROM_SITE_DESCRIPTION, TO_SITE_DESCRIPTION
                    , DEPT_NAME_KO, MKT_USER, ITEM_ID, MEASURE, MEASURE_NAME, SEQ
             ORDER BY RN
                    , DENSE_RANK() OVER (PARTITION BY RN ORDER BY RN, MAIL_RECEIVER)
                    , ITEM_ID
                    , DENSE_RANK() OVER (PARTITION BY RN, MAIL_RECEIVER ORDER BY RN, MAIL_RECEIVER, ITEM_ID)
                    , FROM_SITE_DESCRIPTION
                    , TO_SITE_DESCRIPTION DESC
                    , SEQ;

            V_RECEIVER_TMPCNT := 0;

            SELECT MAX(REC_SEQ)
              INTO V_RECEIVER_CNT
              FROM GT_SSP0026_MAIL
             WHERE 1 = 1
               AND SITE_SEQ = V_FROMSITE_TMPCNT;

            /* SELECT * FROM #Tmp_Result_01;
               select * from #TMP_Tbl_SSP_MAIL_SEND_BATCH_N ;
               SET @v_log_type = 'END';
               SET @v_log_message = '########## END of procedure ##########';
               SET @v_description = '';
               SET @d_event_date = SYSDATETIME();
               EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
               return; */

            WHILE V_RECEIVER_TMPCNT < V_RECEIVER_CNT LOOP
                /* PRINT 'TEST' */
                /********************************************************************************
                * HEAD CONT
                ********************************************************************************/
                V_HEAD_CONT := '';
                V_HEAD_CONT := V_HEAD_CONT || '<tr>';

                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Div' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Company' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Model' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Nick Name' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'From Site' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'To Site' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Team' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'MKT Owner' || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || 'Measure' || '</th>';

                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(FN_CHAR_TO_DATE(V_SITE_FROM_YYYYMMDD),     'YYYY-MM-DD') || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(FN_CHAR_TO_DATE(V_SITE_FROM_YYYYMMDD) + 1, 'YYYY-MM-DD') || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(FN_CHAR_TO_DATE(V_SITE_FROM_YYYYMMDD) + 2, 'YYYY-MM-DD') || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(FN_CHAR_TO_DATE(V_SITE_FROM_YYYYMMDD) + 3, 'YYYY-MM-DD') || '</th>';
                V_HEAD_CONT := V_HEAD_CONT || '<th>' || TO_CHAR(FN_CHAR_TO_DATE(V_SITE_FROM_YYYYMMDD) + 4, 'YYYY-MM-DD') || '</th>';

                V_HEAD_CONT := V_HEAD_CONT || '</tr>';

                V_MAIL_TITLE := '[SSP_Early Warning] Shipping Schedule Nagative value';
                V_BODY_CONTENTS := 'The Negative stock vlaue of shipping schedule based on the shipment request. Please refer to the table below and adjust the shipping request.
                                        If you do not change the shipment request before entering the confirm period, the shipment plan will be deleted, so please check in advance
                                        Thank you
                                        Best regards.

                                    ';
                V_BODY_CONT := '';

                V_RECEIVER_TMPCNT := V_RECEIVER_TMPCNT + 1;
                V_ITEM_TMPCNT := 0;
                V_CNT := 0;

                SELECT MAX(MAIL_RECEIVER)
                     /* ,@v_item_seq_temp = MAX(ITEM_SEQ) */
                  INTO V_MAIL_RECEIVER
                  FROM GT_SSP0026_MAIL
                 WHERE 1 = 1
                   AND SITE_SEQ = V_FROMSITE_TMPCNT
                   AND REC_SEQ  = V_RECEIVER_TMPCNT;

                /*                   수신자 NULL 일 때 '@lgensol.com' 으로 오발송될 수 있으므로 CASE 로 1:1 재현 */
                V_TO_MAIL := CASE WHEN V_MAIL_RECEIVER IS NULL THEN NULL ELSE V_MAIL_RECEIVER || '@lgensol.com' END;
                /* SET @v_to_mail = 'kimyh8848@lgespartner.com'; */

                /* //TEST
                   SET @v_mail_title = @v_to_mail + '-' + @v_mail_title; */

                /* MSSQL DECLARE CUR_SEND CURSOR + WHILE @@FETCH_STATUS = 0 -> 커서 FOR 루프(CV-059). */
                FOR R IN
                (
                    SELECT MAIL_RECEIVER
                         , DIVISION_ID
                         , COMPANY_ID
                         , FROM_SITE_DESCRIPTION
                         , TO_SITE_DESCRIPTION
                         , NVL(DEPT_NAME_KO, '-') AS DEPT_NAME_KO
                         , NVL(MKT_USER, '-')     AS MKT_USER
                         , ITEM_ID
                         , NICK_NAME
                         , MEASURE_NAME
                         , NVL(SEGMENT1, 0)       AS SEGMENT1
                         , NVL(SEGMENT2, 0)       AS SEGMENT2
                         , NVL(SEGMENT3, 0)       AS SEGMENT3
                         , NVL(SEGMENT4, 0)       AS SEGMENT4
                         , NVL(SEGMENT5, 0)       AS SEGMENT5
                         , ITEM_SEQ
                         , MEASURE_SEQ
                      FROM GT_SSP0026_MAIL
                     WHERE 1 = 1
                       AND SITE_SEQ = V_FROMSITE_TMPCNT
                       AND REC_SEQ  = V_RECEIVER_TMPCNT
                       /* and item_id ='MCCM125010A2' */
                     ORDER BY MAIL_RECEIVER, DIVISION_ID, COMPANY_ID, ITEM_ID, FROM_SITE_DESCRIPTION, TO_SITE_DESCRIPTION DESC, SEQ
                ) LOOP

                    V_MAIL_RECEIVER         := R.MAIL_RECEIVER;
                    V_DIVISION_ID           := R.DIVISION_ID;
                    V_COMPANY_ID            := R.COMPANY_ID;
                    V_FROM_SITE_DESCRIPTION := R.FROM_SITE_DESCRIPTION;
                    V_TO_SITE_DESCRIPTION   := R.TO_SITE_DESCRIPTION;
                    V_DEPT_NAME_KO          := R.DEPT_NAME_KO;
                    V_MKT_USER              := R.MKT_USER;
                    V_ITEM_ID               := R.ITEM_ID;
                    V_NICK_NAME             := R.NICK_NAME;
                    V_MEASURE_NAME          := R.MEASURE_NAME;
                    V_SEGMENT1              := R.SEGMENT1;
                    V_SEGMENT2              := R.SEGMENT2;
                    V_SEGMENT3              := R.SEGMENT3;
                    V_SEGMENT4              := R.SEGMENT4;
                    V_SEGMENT5              := R.SEGMENT5;
                    V_ITEM_SEQ              := R.ITEM_SEQ;
                    V_MEASURE_SEQ           := R.MEASURE_SEQ;

                    /* SET @v_rowspanCnt = @@CURSOR_ROWS */
                    SELECT COUNT(*)
                      INTO V_ROWSPANCNT
                      FROM GT_SSP0026_MAIL
                     WHERE 1 = 1
                       AND REC_SEQ  = V_RECEIVER_TMPCNT
                       AND ITEM_SEQ = V_ITEM_SEQ;

                    /* print @v_item_seq +'-' +@v_item_seq_temp;
                       print @v_cnt;
                       PRINT @v_item_id; */

                    IF V_ITEM_SEQ_TEMP <> V_ITEM_SEQ THEN
                        V_CNT := 0;
                    END IF;

                    V_ITEM_SEQ_TEMP := V_ITEM_SEQ;

                    /* //+++++++++++++++++++++++++++++++++++++++++++++= */
                    IF V_CNT = 0 THEN
                        V_BODY_CONT := V_BODY_CONT || '<tr>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=' || TO_CHAR(V_ROWSPANCNT) || '>' || REPLACE(V_DIVISION_ID, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=' || TO_CHAR(V_ROWSPANCNT) || '>' || REPLACE(V_COMPANY_ID, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=' || TO_CHAR(V_ROWSPANCNT) || '>' || REPLACE(V_ITEM_ID, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=' || TO_CHAR(V_ROWSPANCNT) || '>' || REPLACE(V_NICK_NAME, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=' || TO_CHAR(V_ROWSPANCNT) || '>' || REPLACE(V_FROM_SITE_DESCRIPTION, CHR(10), ' ') || '</td>';
                    END IF;

                    /* IF @v_cnt = 0
                       BEGIN
                       print @v_rowspanCnt;
                       print @@CURSOR_ROWS;
                        set @v_rowspanCnt = @@CURSOR_ROWS;
                        SET @v_body_cont = @v_body_cont+ '< tr>';
                        SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '< /td>';
                        SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_company_id,''), CHAR(10),' ') + '< /td>';
                        SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '< /td>';
                        SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '< /td>';
                        SET @v_body_cont = @v_body_cont+ '< td rowspan='+@v_rowspanCnt+'>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '< /td>';
                       END */

                    /* PRINT CONVERT(VARCHAR(50),@v_MEASURE_SEQ) + ' -- ' +  CONVERT(VARCHAR(50),@MEASURECNT) + ' -- ' + CONVERT(VARCHAR(50),@v_to_site_description); */

                    IF V_MEASURE_SEQ <> 1 AND V_MEASURECNT = 0 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=3>' || REPLACE(V_TO_SITE_DESCRIPTION, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=3>' || REPLACE(V_DEPT_NAME_KO, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td rowspan=3>' || REPLACE(V_MKT_USER, CHR(10), ' ') || '</td>';
                    END IF;

                    IF V_MEASURE_SEQ = 1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_TO_SITE_DESCRIPTION, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_DEPT_NAME_KO, CHR(10), ' ') || '</td>';
                        V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_MKT_USER, CHR(10), ' ') || '</td>';
                    END IF;

                    /* SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_mkt_user,''), CHAR(10),' ') + '</td>' */
                    V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_MEASURE_NAME, CHR(10), ' ') || '</td>';

                    V_CNT := V_CNT + 1;

                    /* IF @v_cnt = 10
                       IF @v_cnt = @v_rowspanCnt
                       BEGIN
                        SET @v_cnt = 0
                       END */

                    IF (V_MEASURE_NAME = 'W/H BOH(Req)' OR V_MEASURE_NAME = 'W/H BOH(Plan)') AND SIGN(V_SEGMENT1) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(V_SEGMENT1), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(V_SEGMENT1), CHR(10), ' ') || '</td>';
                    END IF;

                    IF (V_MEASURE_NAME = 'W/H BOH(Req)' OR V_MEASURE_NAME = 'W/H BOH(Plan)') AND SIGN(V_SEGMENT2) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(V_SEGMENT2), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(V_SEGMENT2), CHR(10), ' ') || '</td>';
                    END IF;

                    IF (V_MEASURE_NAME = 'W/H BOH(Req)' OR V_MEASURE_NAME = 'W/H BOH(Plan)') AND SIGN(V_SEGMENT3) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(V_SEGMENT3), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(V_SEGMENT3), CHR(10), ' ') || '</td>';
                    END IF;

                    IF (V_MEASURE_NAME = 'W/H BOH(Req)' OR V_MEASURE_NAME = 'W/H BOH(Plan)') AND SIGN(V_SEGMENT4) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(V_SEGMENT4), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(V_SEGMENT4), CHR(10), ' ') || '</td>';
                    END IF;

                    IF (V_MEASURE_NAME = 'W/H BOH(Req)' OR V_MEASURE_NAME = 'W/H BOH(Plan)') AND SIGN(V_SEGMENT5) = -1 THEN
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''> <font color = ''red''> ' || REPLACE(FMT_MONEY(V_SEGMENT5), CHR(10), ' ') || '</font></td>';
                    ELSE
                        V_BODY_CONT := V_BODY_CONT || '<td align=''right''>' || REPLACE(FMT_MONEY(V_SEGMENT5), CHR(10), ' ') || '</td>';
                    END IF;
                    V_BODY_CONT := V_BODY_CONT || '</tr>';

                    V_MEASURECNT := V_MEASURECNT + 1;

                    IF V_MEASURE_SEQ = 1 THEN
                        V_MEASURECNT := 0;
                    END IF;

                    IF V_MEASURECNT = 3 THEN
                        V_MEASURECNT := 0;
                    END IF;

                END LOOP;

                V_TABLE_BODY := '';
                V_TABLE_BODY := ' <html>
                                    <head>
                                            <title>Untitled Document</title>
                                            <style>
                                                * {margin:0;padding:0;}
                                                body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
                                                table {border-collapse:collapse;width:100%;}
                                                table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
                                                table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
                                                table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
                                                table tbody td {padding:6px 8px;font-size:12px}
                                                table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
                                                .hori-table table thead td {text-align:center;padding:3px;}
                                                .hori-table table tbody td {text-align:center;padding:3px;}
                                                .vertical-table, .hori-table {margin-bottom:20px;}
                                            </style>
                                            </head>
                                            <body>' || '</br>' ||
                                                    '<b>' || REPLACE(V_BODY_CONTENTS, CHR(10), '<br>') || '</b>' ||
                                                    '<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">' ||
                                                '<table style=''border-top:2px solid #c8294b; width:1450px;''>
                                                <thead>' || V_HEAD_CONT || '</thead>
                                                <tbody>' || V_BODY_CONT || '</tbody>
                                                </div>
                                            </body>
                                    </html>';
                /*                   VARCHAR2 인자인 P_SEND_MAIL 대신 P_SEND_MAIL_CLOB 사용(절단 방지). */
                PKG_SEND_MAIL.P_SEND_MAIL_CLOB(V_TO_MAIL   /* //'kahonmalu@lgensol.com' */
--                                             , V_MAIL_TITLE
                                             , CASE WHEN SYS_CONTEXT('USERENV', 'DB_NAME') NOT LIKE 'OCGSCMP%' THEN 'DEV Oracle 개발서버 ' || V_MAIL_TITLE ELSE V_MAIL_TITLE END
                                             , V_TABLE_BODY
                                             , 'Y');

                /* MAIL 발송 LOG 저장 */
                SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG(
                    'MAIL'
                  , 0
                  , V_PROGRAM_NAME
                  , V_DIVISION_ID
                  , V_COMPANY_ID
                  , V_FROM_SITE_DESCRIPTION
                  , V_ITEM_ID
                  , V_NICK_NAME
                  , ''
                  , ''
                  , ''
                  , ''
                  , ''  /* p_send_pgm */
                  , V_TO_MAIL
                );

                /* print @v_body_cont; */

                /* 원본 진단용 결과셋 SELECT @v_to_mail, @v_mail_title, @v_body_cont, @TABLE_BODY; */
            END LOOP;
        END LOOP;

    EXCEPTION

        WHEN OTHERS THEN
            /* IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_SEND') BEGIN CLOSE CUR_SEND; DEALLOCATE CUR_SEND; END */
            V_ERROR_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            DBMS_OUTPUT.PUT_LINE(V_ERROR_MESSAGE);

            INSERT INTO SCM_SYS_LOG_BATCH
            (
                PROGRAM_NAME
              , LOG_TYPE
              , LOG_COUNT
              , LOG_MESSAGE
              , DESCRIPTION
              , EVENT_DATE
              , CREATION_DATE
              , CREATED_BY
              , LAST_UPDATE_DATE
              , LAST_UPDATED_BY
            )
            VALUES
            (
                V_PROGRAM_NAME
              , 'ERROR'
              , NULL
              , V_ERROR_MESSAGE
              , NULL
              , SYSDATE
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
            );

            /* MAIL 발송 LOG 저장 */
            SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG(
                'ERROR'
              , 0
              , V_PROGRAM_NAME
              , 'MAIN ERROR'
              , ''
              , ''
              , ''
              , ''
              , ''
              , ''
              , ''
              , ''
              , V_ERROR_MESSAGE  /* p_send_pgm */
              , ''
            );

            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /* error코드, errror 메시지 반환 : 배치라 결과셋 소비자 없음 -> 진단용 DBMS_OUTPUT (H-9) */
            DBMS_OUTPUT.PUT_LINE('F');
            DBMS_OUTPUT.PUT_LINE('[' || TO_CHAR(SQLCODE) || ']' || SUBSTR(SQLERRM, 1, 1000));

            P_LOG_MESSGE := V_ERROR_MESSAGE;
            RETURN;   /* return -1 : Oracle 프로시저는 반환값이 없어 OUT 에러채널만 유지 */

    END;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* 원본 종료부의 IF OBJECT_ID('tempdb..#xxx') IS NOT NULL DROP TABLE #xxx -> GTT 는 DROP 대상이 아니라 */
    /* SHIPMENT BOH */
    DELETE FROM GT_SSP0026_SHIP_FG;
    /* SHIPMENT ROW DATA */
    /* SHIPMENT BOH */
    DELETE FROM GT_SSP0026_SHIP_FG;
    /* SHIPMENT ROW DATA */
    DELETE FROM GT_SSP0026_ROW;
    DELETE FROM GT_SSP0026_RAW;
    DELETE FROM GT_SSP0026_R01;
    DELETE FROM GT_SSP0026_R02;
    DELETE FROM GT_SSP0026_MAIL;
    DELETE FROM GT_SSP0026_PIVOT;
    DELETE FROM GT_SSP0026_FG;
    DELETE FROM GT_SSP0026_STD;

    RETURN;   /* return 1 : Oracle 프로시저는 반환값이 없어 제거 */
END;