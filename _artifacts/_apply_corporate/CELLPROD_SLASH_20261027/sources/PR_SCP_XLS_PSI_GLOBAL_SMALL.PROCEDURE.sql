PROCEDURE PR_SCP_XLS_PSI_GLOBAL_SMALL
( P_PLAN_CYCLE             IN VARCHAR2                        /* NVARCHAR(0150) */
, P_PLAN_START_YYYYMMDD    IN VARCHAR2                        /* NVARCHAR(0008) */
, P_PLAN_ID                IN VARCHAR2                        /* NVARCHAR(4000) */
, P_MODELING_ID            IN VARCHAR2                        /* NVARCHAR(4000) */
, P_SEQ                    IN VARCHAR2                        /* NVARCHAR(4000) */
, P_PLAN_TYPE              IN VARCHAR2                        /* NVARCHAR(4000) */
, P_MASTER_ID              IN VARCHAR2                        /* NVARCHAR(4000) */
, P_DIVISION_ID            IN VARCHAR2                        /* NVARCHAR(0030) */
, P_ENGINE_PLAN_ID         IN VARCHAR2                        /* NVARCHAR(4000) */
, P_USER_ID                IN VARCHAR2 DEFAULT 'SCP_batch'    /* NVARCHAR(0150) = 'SCP_batch' */
, P_IS_DEBUG               IN VARCHAR2 DEFAULT '0'            /* BIT = 0 : 0 : RELEASE, 1 : DEBUG */
, O_RETURN                 OUT NUMBER                         /* AS-IS RETURN 값 */
)
/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_SMALL
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :

    EXEC PR_SCP_XLS_PSI_GLOBAL_SMALL
               @p_plan_cycle          = 'WEEKLY'
             , @p_plan_start_yyyymmdd = '20250210'
             , @p_plan_id             = '1378'
             , @p_plan_type           = 'PR'
             , @p_seq                 = '2'
             , @p_modeling_id         = '1'
             , @p_master_id           = '40::WEEKLY'
             , @p_division_id         = '40'
             , @p_engine_plan_id      = '1378::PR::2'
             , @p_user_id             = 'luckydohan'
             , @p_is_debug              = 1

    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_SMALL' order by CREATION_DATE desc

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.02.04  KSK      Initial Release 최초생성
 * 2025.04.02  KSK        FROM_SITE의 셀생산지 수집관련 필터링조건 변경
 * 2025.07.11  KSK        멀티구간 BOD 로직보완(BOD_VALID_YN, ROUTE VALID)
 * 2025.08-29  YMH        CSR E20250829-001508 실행계획개선 (속도개선)
 * 2025-09-30  KSK        E20251001-000977 셀-조립모델 매핑로직 변경(250930)
 * 2026-04-27  YMH      E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
/* --DROP PROC dbo.PR_SCP_XLS_PSI_GLOBAL_SMALL */
IS
    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET NOCOUNT ON; SET XACT_ABORT ON; (Oracle 기본 동작) */
    /* --SET ANSI_WARNINGS OFF; */
    /* SET ANSI_WARNINGS ON; SET ANSI_NULLS ON; */

    /* AS-IS 인자 선언 길이 재현 */
    V_PLAN_CYCLE             VARCHAR2(150 CHAR)  := SUBSTR(P_PLAN_CYCLE, 1, 150);
    V_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR)    := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_PLAN_ID                VARCHAR2(4000 CHAR) := SUBSTR(P_PLAN_ID, 1, 4000);
    V_MODELING_ID            VARCHAR2(4000 CHAR) := SUBSTR(P_MODELING_ID, 1, 4000);
    V_SEQ_TXT                VARCHAR2(4000 CHAR) := SUBSTR(P_SEQ, 1, 4000);
    V_PLAN_TYPE              VARCHAR2(4000 CHAR) := SUBSTR(P_PLAN_TYPE, 1, 4000);
    V_MASTER_ID              VARCHAR2(4000 CHAR) := SUBSTR(P_MASTER_ID, 1, 4000);
    V_DIVISION_ID            VARCHAR2(30 CHAR)   := SUBSTR(P_DIVISION_ID, 1, 30);
    V_ENGINE_PLAN_ID         VARCHAR2(4000 CHAR) := SUBSTR(P_ENGINE_PLAN_ID, 1, 4000);
    V_USER_ID                VARCHAR2(150 CHAR)  := SUBSTR(P_USER_ID, 1, 150);
    V_SEQ                    NUMBER(19);         /* SEQ(BIGINT) 칸 비교용 */

    /* LOG 용 변수 설정 */
    V_BATCH_USER             VARCHAR2(150 CHAR)  := 'SCP_batch';
    V_PROGRAM_NAME           VARCHAR2(150 CHAR)  := 'PR_SCP_XLS_PSI_GLOBAL_SMALL';
    V_LOG_TYPE               VARCHAR2(30 CHAR);  /* START/END/ERROR/... */
    N_LOG_COUNT              NUMBER(10)          := 0;
    V_LOG_MESSAGE            VARCHAR2(1000 CHAR);
    V_DESCRIPTION            VARCHAR2(500 CHAR);
    V_TABLE_ID               VARCHAR2(150 CHAR)  := 'SCM_SYS_LOG_BATC';
    D_EVENT_DATE             DATE;

    /* 실행시간 확인용 */
    V_START_TIME             DATE                := SYSDATE;
    V_EXEC_TIME              VARCHAR2(10 CHAR)   := NULL;  /* '00:00' */
    N_EXEC_SEC               NUMBER;

    V_PROGRAM_ID             VARCHAR2(30 CHAR)   := 'XLSPSI01';
    V_TO_YYYYMMDD            VARCHAR2(8 CHAR)    := NULL;  /* CONVERT(VARCHAR(8), DATEADD(day, 728, @p_plan_start_yyyymmdd), 112) */
    V_CUTOFF_DATE            VARCHAR2(8 CHAR)    := TO_CHAR(TO_DATE(SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8), 'YYYYMMDD') - 1, 'YYYYMMDD');
    V_PLAN_START_364         VARCHAR2(8 CHAR);   /* DATEADD(day, 364, @p_plan_start_yyyymmdd) */

    V_BP_FLAG                VARCHAR2(8 CHAR)    := NULL;

    N_ROWS                   NUMBER;             /* 하위 프로시저 반환값 */
    V_CREATE_FROM_YYYYMMDD   VARCHAR2(8 CHAR);
    V_CREATE_TO_YYYYMMDD     VARCHAR2(8 CHAR);

    /* Plan End Date */
    V_PET_DATE               VARCHAR2(12 CHAR)   := NULL;
    V_BP_DAYS                NUMBER(10)          := 0;
    V_BP_PLAN_END_YYYYMMDD   VARCHAR2(8 CHAR)    := NULL;

    /* 오류 로그용 */
    V_SQL_ERR_CODE           VARCHAR2(100 CHAR);
    V_SQL_ERR_MSG            VARCHAR2(2000 CHAR);
    V_SQL_BACKTRACE          VARCHAR2(4000 CHAR);
BEGIN
    O_RETURN     := 1;  /* 반환값 초기화 */
    V_BATCH_USER := V_USER_ID;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;

    IF P_IS_DEBUG = '0' THEN
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );
    END IF;

    /* 실행시간 확인용 : V_START_TIME 선언부 초기화 */

    /* --DECLARE @debug_mode            NVARCHAR(30) = 'T' */
    BEGIN  /* BEGIN TRY */

        V_SEQ            := TO_NUMBER(V_SEQ_TXT);
        V_PLAN_START_364 := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PLAN 기간설정 - 2021.11.19 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* AS-IS SELECT @변수 = ... : 행이 없으면 초기값 유지, 여러 행이면 마지막 행 값 → 커서 반복으로 재현 */
        FOR CUR_PLAN IN (SELECT P.HORIZON_END_DATE
                              , CASE WHEN TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD') > 364 THEN 'Y'
                                     ELSE 'N'
                                END                                     AS BP_FLAG
                           FROM SCM_MST_PLAN P
                          WHERE P.PLAN_ID     = (SELECT MAX(SA.PLAN_ID)
                                                   FROM SCM_MST_PLAN SA
                                                  WHERE SA.DIVISION_ID          = V_DIVISION_ID
                                                    AND TO_NUMBER(SA.PLAN_ID) < 9999)
                            AND P.PLAN_CYCLE  = 'WEEKLY'
                            AND P.DIVISION_ID = V_DIVISION_ID)
        LOOP
            V_TO_YYYYMMDD := CUR_PLAN.HORIZON_END_DATE;
            V_BP_FLAG     := CUR_PLAN.BP_FLAG;
        END LOOP;

        IF V_BP_FLAG = 'Y' THEN
            /* 중장기일 경우 104주차로 변경 */
            V_TO_YYYYMMDD := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364 + 363, 'YYYYMMDD');
        END IF;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 정보 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#MEASURE') IS NOT NULL DROP TABLE #MEASURE */
        DELETE FROM GT_XPGS_MEASURE;

        /* MEASURE 세팅값 추출 */
        INSERT
          INTO GT_XPGS_MEASURE
             ( COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
             , DIV
             , GUBUN
             )
        SELECT M.COLUMN_NAME
             , M.COLUMN_LABEL_NAME
             , M.SORT_ORDER_NO
             , (CASE WHEN M.ATTRIBUTE1 = 'PACK' THEN 'P' WHEN M.ATTRIBUTE1 = 'CELL' THEN 'A' ELSE 'C' END) AS DIV
             , M.ATTRIBUTE2                                                                                 AS GUBUN
          FROM SCM_MST_SHEET_MEASURE M
         WHERE M.PROGRAM_ID = V_PROGRAM_ID
           AND M.VALID_YN   = 'Y'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MEASURE SETTING ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE SETTING';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 데이터 이관 ('MKT_FCST','SHIP_PLAN','PRODUCTION') */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL') IS NOT NULL DROP TABLE #PSI_GLOBAL_SMALL;
           CREATE TABLE #PSI_GLOBAL_SMALL (...) → GTT GT_XPGS_PSI_GLOBAL_SMALL 사전 생성
           칸 주석 : PROJECT_CODE -- FG 때문에 추가 / TO_BOH_QTY --BIGINT / FROM_BOH_QTY -- BIGINT / ATTRIBUTE9 -- OPERATION_ID */
        DELETE FROM GT_XPGS_PSI_GLOBAL_SMALL;

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* SHIP_PLAN (FG) (팩,셀 공통) - MKT_FCST, SHIP_PLAN, SHIP_REQ */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 / 기존 로직 주석처리 */
        /* AS-IS L177~L213 (원문 그대로 보존)
                       ( *
                       INSERT INTO #PSI_GLOBAL_SMALL
                           SELECT A.DIVISION_ID
                                   , A.BIZ_TYPE
                                   , '' AS CELL_ITEM_ID
                                   , A.ITEM_ID
                                   , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE
                             , A.PROJECT_CODE
                                   , 0 AS TO_BOH_QTY
                                   , 0 AS FROM_BOH_QTY
                                   , A.INCOTERMS
                                   , A.FROM_SITE
                             -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                             ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE    ),'-') AS TRANSPORT_MODE
                                   , '-'   AS PROD_LINE
                                   , A.MEASURE                                                -- SHIP_PLAN FG
                                   , A.YYYYMMDD        AS YYYYMMDD
                             , ISNULL(A.QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
                                   , M.SORT_ORDER_NO
                                   , CASE WHEN A.MEASURE = 'SHIP_REQ' THEN 'SHIP REQ'  ELSE  M.COLUMN_LABEL_NAME END AS COLUMN_LABEL_NAME
                                   , A.BOD_ID
                             , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1
                                   , A.ATTRIBUTE9
                              FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
                            LEFT JOIN #MEASURE M WITH(NOLOCK)
                               ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST', 'SHIP_REQ')
                               AND A.MEASURE             = M.COLUMN_NAME
                            WHERE A.DIVISION_ID                =  @p_division_id
                                   AND A.PLAN_START_YYYYMMDD    =  @p_plan_start_yyyymmdd
                                   AND A.PLAN_TYPE                    =  @p_plan_type
                                   AND A.SEQ                            =  @p_seq
                                   AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
                                   AND A.YYYYMMDD            <=   @p_to_yyyymmdd           --말일포함 (KSK, 20240814)
                               AND A.MEASURE             IN ('SHIP_PLAN','MKT_FCST', 'SHIP_REQ')
                               -- 중복값 수정이 안되는 현상 발생하여 제거함 : KSK, 2023-07-10
                               --AND PROJECT_CODE != '-'
                       * )
        */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 시작 */
        /* IF OBJECT_ID('tempdb..#BOD_TRANSPORT') IS NOT NULL DROP TABLE #BOD_TRANSPORT;
           #BOD_TRANSPORT : MIN(TRANSPORT_MODE) AS TRANSPORT_MODE -- TOP 1과 동일 효과 / CREATE CLUSTERED INDEX CX_BOD_TRANSPORT ON #BOD_TRANSPORT (DIVISION_ID, BOD_ID, FROM_SITE);
           Step 2: #MEASURE 필터링 (SHIP_PLAN, MKT_FCST, SHIP_REQ만 미리 필터) : IF OBJECT_ID('tempdb..#MEASURE_FILTERED') IS NOT NULL DROP TABLE #MEASURE_FILTERED;
           WITH MEASURE AS (... --SELECT M.* ... WHERE M.COLUMN_NAME IN ('SHIP_PLAN','MKT_FCST') --,'SHIP_REQ') UNION ALL SELECT N'SHIP_REQ' ...)
           CREATE CLUSTERED INDEX CX_MEASURE_FILTERED ON #MEASURE_FILTERED (COLUMN_NAME);
           → 두 임시 테이블은 아래 INSERT 한 곳에서만 쓰여 인라인 뷰(IA·IB)로 옮김 */

        /* Step 3: 메인 INSERT - Hash Match 제거, 상관 서브쿼리 제거 */
        /* OPTION(LOOP JOIN) + MAXDOP(1) 또는 HASH JOIN 힌트 제거로 */
        /* 메모리 그랜트 최소화 */
        INSERT /* WITH (TABLOCKX) -- INSERT 시 잠금 경합 최소화 */
          INTO GT_XPGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.BIZ_TYPE
             , NULL                                AS CELL_ITEM_ID  /* AS-IS '' */
             , A.ITEM_ID
             , NVL(A.TO_SITE, '-')                 AS TO_SITE       /* ISNULL(NULLIF(A.TO_SITE, ''), '-') */
             , A.PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , NVL(IB.TRANSPORT_MODE, '-')         AS TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , A.MEASURE
             , A.YYYYMMDD
             , NVL(A.QTY, 0)                       AS QTY
             , IA.SORT_ORDER_NO
             , CASE WHEN A.MEASURE = 'SHIP_REQ'
                    THEN 'SHIP REQ'
                    ELSE IA.COLUMN_LABEL_NAME
               END                                 AS COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_FG'          AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM SCP_ANL_SHIPMENT_PLAN_FG A
               /* Loop Join 유도: #MEASURE_FILTERED는 2~3건 소량 → Nested Loop 최적 */
             , (SELECT SA.COLUMN_NAME
                     , SA.COLUMN_LABEL_NAME
                     , SA.SORT_ORDER_NO
                  FROM GT_XPGS_MEASURE SA
                 WHERE SA.COLUMN_NAME IN ('SHIP_PLAN', 'MKT_FCST')  /* --,'SHIP_REQ') */
                 UNION ALL
                SELECT 'SHIP_REQ'                  AS COLUMN_NAME
                     , 'SHIP_REQ'                  AS COLUMN_LABEL_NAME
                     , NULL                        AS SORT_ORDER_NO
                  FROM DUAL
               )                          IA  /* AS-IS #MEASURE_FILTERED */
               /* --LEFT JOIN #MEASURE M WITH(NOLOCK) */
               /* --  ON M.COLUMN_NAME IN ('SHIP_PLAN','MKT_FCST', 'SHIP_REQ') */
               /* -- AND A.MEASURE = M.COLUMN_NAME */
               /* Loop Join 유도: #BOD_TRANSPORT는 사전 집계된 소량 데이터 */
             , (SELECT SB.DIVISION_ID
                     , SB.BOD_ID
                     , SB.FROM_SITE
                     , MIN(SB.TRANSPORT_MODE)      AS TRANSPORT_MODE  /* TOP 1과 동일 효과 */
                  FROM SCP_MST_BOD_N_V SB
                 WHERE SB.DIVISION_ID = V_DIVISION_ID
                 GROUP BY SB.DIVISION_ID
                        , SB.BOD_ID
                        , SB.FROM_SITE
               )                          IB  /* AS-IS #BOD_TRANSPORT */
         WHERE IA.COLUMN_NAME           = A.MEASURE
           AND IB.DIVISION_ID(+)        = A.DIVISION_ID
           AND IB.BOD_ID(+)             = A.BOD_ID
           AND IB.FROM_SITE(+)          = A.FROM_SITE
           AND A.DIVISION_ID            = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD    = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE              = V_PLAN_TYPE
           AND A.SEQ                    = V_SEQ
           AND A.YYYYMMDD              >= V_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD              <= V_TO_YYYYMMDD
           AND A.MEASURE               IN ('SHIP_PLAN', 'MKT_FCST', 'SHIP_REQ')
           /* OPTION ( LOOP JOIN -- Hash Match 금지 → 메모리 그랜트 제거
                     , MAXDOP 1 -- 병렬처리 금지 → MEMORY_ALLOCATION_EXT 대기 제거
                     , OPTIMIZE FOR UNKNOWN -- 파라미터 스니핑 방지 (상수 하드코딩 불필요)
                       -- 옵티마이저가 통계 기반 평균값으로 실행계획 수립
                       -- → 특정 파라미터값에 종속된 실행계획 고착 방지 ) : Oracle 힌트 미사용 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 끝 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE SHIP_PLAN / MKT_FCST / SHIP_REQ ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* IF @p_is_debug = 1 SELECT '#PSI_GLOBAL_SMALL_1' AS "PSI_GLOBAL_SMALL_1", * FROM #PSI_GLOBAL_SMALL : 디버그 결과 집합 없음 */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* SHIP_PLAN (FG) (팩,셀 공통) - WH_IN */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.BIZ_TYPE
             , NULL                                AS CELL_ITEM_ID  /* AS-IS '' */
             , A.ITEM_ID
             , NVL(A.TO_SITE, '-')                 AS TO_SITE       /* ISNULL(NULLIF(A.TO_SITE, '') , '-') */
             , A.PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
               /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
             , NVL((SELECT C.TRANSPORT_MODE
                      FROM SCP_MST_BOD_N_V C
                     WHERE 0 = 0
                       AND C.DIVISION_ID = A.DIVISION_ID
                       AND C.BOD_ID      = A.BOD_ID
                       AND C.FROM_SITE   = A.FROM_SITE
                       AND ROWNUM        = 1), '-')        AS TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE  /* SHIP_PLAN FG */
             , A.YYYYMMDD                          AS YYYYMMDD
             , NVL(A.QTY, 0)                       AS QTY      /* 기존 INTRANSIT 무시하고 모두 0 */
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_FG'          AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM SCP_ANL_SHIPMENT_PLAN_FG A
             , GT_XPGS_MEASURE          M
         WHERE M.COLUMN_NAME IN ('WHIN')
           AND A.MEASURE              = 'WH_IN'  /* (CASE WHEN M.COLUMN_NAME ='WHIN' THEN 'WH_IN' ELSE M.COLUMN_NAME END ) */
           AND A.DIVISION_ID          = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE            = V_PLAN_TYPE
           AND A.SEQ                  = V_SEQ
           AND A.YYYYMMDD            >= V_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD            <= V_TO_YYYYMMDD  /* 말일포함 (KSK, 20240814) */
           AND A.MEASURE             IN ('WH_IN')
        ;

        /* IF @p_is_debug = 1 SELECT '#PSI_GLOBAL_SMALL_2' AS "PSI_GLOBAL_SMALL_2", * FROM #PSI_GLOBAL_SMALL : 디버그 결과 집합 없음 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' WH_IN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* --------------------------------------------------------------------------------------------------------------- */
        /* SCP_ANL_PRODUCTION_PLAN - PACK_PROD, CELL_PROD */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , NULL                                AS CELL_ITEM_ID  /* AS-IS '' */
             , A.ITEM_ID
             , '-'                                 AS TO_SITE
             , '-'                                 AS PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , A.SCM_SITE_ID                       AS FROM_SITE
             , '-'                                 AS TRANSPORT_MODE
             , A.LINE_ID                           AS PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , A.YYYYMMDD
             , SUM(A.QTY)                          AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                                 AS BOD_ID
             , 'SCP_ANL_PRODUCTION_PLAN'           AS ATTRIBUTE1
             , A.OPERATION_ID                      AS ATTRIBUTE9
          FROM SCP_ANL_PRODUCTION_PLAN A
               /* --INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) */
               /* --        ON A.YYYYMMDD = C.BASIS_YYYYMMDD */
             , GT_XPGS_MEASURE         M
         WHERE 1 = 1
           AND M.COLUMN_NAME IN ('PACK_PROD', 'CELL_PROD')
           AND (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                     WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                     ELSE '-'
                END) = M.COLUMN_NAME
           AND A.DIVISION_ID          = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE            = V_PLAN_TYPE
           AND A.SEQ                  = V_SEQ
           AND A.LINE_ID             <> '-'
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.ITEM_ID
                , A.SCM_SITE_ID
                , A.LINE_ID
                , M.COLUMN_NAME
                , A.YYYYMMDD
                , M.SORT_ORDER_NO
                , M.COLUMN_LABEL_NAME
                , A.OPERATION_ID
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' PACK_PROD / CELL_PROD ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) */
        /* PACK_PROD, CELL_PROD - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가 */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#LINE_ASSIGN') IS NOT NULL DROP TABLE #LINE_ASSIGN */
        /* IF OBJECT_ID('tempdb..#LINE_ASSIGN_ORG') IS NOT NULL DROP TABLE #LINE_ASSIGN_ORG */
        DELETE FROM GT_XPGS_LINE_ASSIGN;
        DELETE FROM GT_XPGS_LINE_ASSIGN_ORG;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 기존 로직 주석처리. */
        /* AS-IS L463~L503 (원문 그대로 보존)
                       ( *
                       SELECT DISTINCT
                                   TM.DIVISION_ID
                               , TM.PLANT_ID AS FROM_SITE_ID
                               , TM.LINE_ID
                               , TM.ITEM_ID
                               , TM.OPERATION_ID
                               , TM.COMPANY_ID
                               , TM.SITE_ID
                               , TM.FACTORY_ID
                               , TM.ELECTRODE_TYPE
                           INTO #LINE_ASSIGN_ORG
                           FROM  SCM_MST_ITEM_LINE_ASSIGN_SN AN WITH (NOLOCK)
                           INNER JOIN SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)
                               ON  TM.DIVISION_ID        = AN.DIVISION_ID
                               AND TM.COMPANY_ID        = AN.COMPANY_ID
                               AND TM.SITE_ID            = AN.SITE_ID
                               AND TM.PLANT_ID            = AN.PLANT_ID
                               AND TM.FACTORY_ID        = AN.FACTORY_ID
                               AND TM.OPERATION_ID        = AN.OPERATION_ID
                               AND TM.LINE_ID            = AN.LINE_ID
                               AND TM.ELECTRODE_TYPE    = AN.ELECTRODE_TYPE
                               AND TM.ITEM_ID            = AN.ITEM_ID
                         INNER JOIN SCM_LINE_M_SN LM WITH (NOLOCK)
                               ON  LM.DIVISION_ID        = AN.DIVISION_ID
                               AND LM.COMPANY_ID        = AN.COMPANY_ID
                               AND LM.SITE_ID            = AN.SITE_ID
                               AND LM.PLANT_ID            = AN.PLANT_ID
                               AND LM.FACTORY_ID        = AN.FACTORY_ID
                               AND LM.OPERATION_ID        = AN.OPERATION_ID
                               AND LM.LINE_ID            = AN.LINE_ID
                               AND LM.ELECTRODE_TYPE    = AN.ELECTRODE_TYPE
                           WHERE 1 = 1
                           --AND AN.UPDATE_TIME >= convert(char(8), dateadd(D, -2, getdate()), 112)    -- 2022.11.03 주석해제 :: 불필요 생산계획 생성방지에 따른 최신 PRIORITY 값이 반영되지 않는 현상 개선
                           AND AN.DIVISION_ID       = @p_division_id
                           AND TM.DAILY_CAPA       > 0.0
                           AND AN.MONTH            >= LEFT(convert(char(8), getdate(), 112), 6)        -- 2021.08.10 capa. 적용기준 변경
                           AND NOT AN.PRIORITY     IN (9, 8)    -- 2022.10.25 미적용기준을 변경
                           AND LM.ACTIVE_FLAG = 'Y'  --'2024.07.04 활성화 상태 체크 (KSK)
                           ;
                           * )
        */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 시작 */
        /* AS-IS L508~L518 (원문 그대로 보존)
                           ( *
                            CTE_AN: AN 테이블을 조인 전에 미리 필터링
                            - DIVISION_ID, MONTH, PRIORITY 조건을 선행 적용하여 304K → 대폭 감소 기대
                            - PRIORITY 암묵적 형변환(CONVERT_IMPLICIT) 제거:
                                원본: NOT AN.PRIORITY IN (9, 8)
                                → PRIORITY 컬럼 타입이 nvarchar/varchar인 경우: NOT IN ('9', '8')
                                → PRIORITY 컬럼 타입이 int/numeric인 경우: NOT IN (9, 8) 그대로 사용
                              ※ 실행계획 경고 "CONVERT_IMPLICIT(int, [PRIORITY], 0)" 확인됨
                                → PRIORITY는 문자형으로 저장되어 int 비교 시 형변환 발생
                                → 아래 CTE에서 문자형 리터럴로 통일 (실제 타입 확인 후 조정 필요)
                           * )
        */
        INSERT
          INTO GT_XPGS_LINE_ASSIGN_ORG
             ( DIVISION_ID
             , FROM_SITE_ID
             , LINE_ID
             , ITEM_ID
             , OPERATION_ID
             , COMPANY_ID
             , SITE_ID
             , FACTORY_ID
             , ELECTRODE_TYPE
             )
        SELECT TM.DIVISION_ID
             , TM.PLANT_ID                         AS FROM_SITE_ID
             , TM.LINE_ID
             , TRIM(TM.ITEM_ID)                    AS ITEM_ID
             , TM.OPERATION_ID
             , TM.COMPANY_ID
             , TM.SITE_ID
             , TM.FACTORY_ID
             , TM.ELECTRODE_TYPE
          FROM SCM_LINE_M_SN       LM  /* 드라이빙: division 3,031건 (가장 소규모) */
             , (SELECT AN.DIVISION_ID
                     , AN.COMPANY_ID
                     , AN.SITE_ID
                     , AN.PLANT_ID
                     , AN.FACTORY_ID
                     , AN.OPERATION_ID
                     , AN.LINE_ID
                     , AN.ELECTRODE_TYPE
                     , AN.ITEM_ID
                  FROM SCM_MST_ITEM_LINE_ASSIGN_SN AN
                 WHERE AN.DIVISION_ID = V_DIVISION_ID
                   AND AN.MONTH      >= TO_CHAR(SYSDATE, 'YYYYMM')  /* LEFT(CONVERT(CHAR(8), GETDATE(), 112), 6) */
                   /* AS-IS L533~L537 (원문 그대로 보존)
                                            ( *
                                              PRIORITY 형변환 제거 방법 선택:
                                              [방법A] PRIORITY가 문자형(nvarchar/varchar) 컬럼인 경우 (권장)
                                                      → 리터럴을 문자로 지정하여 형변환 자체를 원천 제거
                                            * )
                   */
                   AND AN.PRIORITY NOT IN ('9', '8')
                   /* AS-IS L539~L543 (원문 그대로 보존)
                                            ( *
                                              [방법B] PRIORITY가 숫자형(int/numeric) 컬럼인 경우
                                                      → CAST 없이 숫자 리터럴 그대로 사용 (원본과 동일, 단 CTE 분리 효과는 유지)
                                            * )
                                            -- AND AN.PRIORITY NOT IN (9, 8)
                   */
               )                   AN  /* AS-IS CTE_AN : HASH JOIN: NL 218K회 반복 → 단1회 Hash 처리 */
             , SCM_MST_TACT_TIME_SN TM  /* HASH JOIN: division 221K건 */
         WHERE AN.DIVISION_ID    = LM.DIVISION_ID
           AND AN.COMPANY_ID     = LM.COMPANY_ID
           AND AN.SITE_ID        = LM.SITE_ID
           AND AN.PLANT_ID       = LM.PLANT_ID
           AND AN.FACTORY_ID     = LM.FACTORY_ID
           AND AN.OPERATION_ID   = LM.OPERATION_ID
           AND AN.LINE_ID        = LM.LINE_ID
           AND AN.ELECTRODE_TYPE = LM.ELECTRODE_TYPE
           AND TM.DIVISION_ID    = AN.DIVISION_ID
           AND TM.COMPANY_ID     = AN.COMPANY_ID
           AND TM.SITE_ID        = AN.SITE_ID
           AND TM.PLANT_ID       = AN.PLANT_ID
           AND TM.FACTORY_ID     = AN.FACTORY_ID
           AND TM.OPERATION_ID   = AN.OPERATION_ID
           AND TM.LINE_ID        = AN.LINE_ID
           AND TM.ELECTRODE_TYPE = AN.ELECTRODE_TYPE
           AND TM.ITEM_ID        = AN.ITEM_ID
           AND LM.DIVISION_ID    = V_DIVISION_ID  /* LM 드라이빙 필터 (Index Seek 활용) */
           AND LM.ACTIVE_FLAG    = 'Y'            /* LM의 CDX01 인덱스(ACTIVE_FLAG) Seek 활용 */
           AND TM.DAILY_CAPA     > 0.0
         GROUP BY TM.DIVISION_ID
                , TM.PLANT_ID
                , TM.LINE_ID
                , TM.ITEM_ID
                , TM.OPERATION_ID
                , TM.COMPANY_ID
                , TM.SITE_ID
                , TM.FACTORY_ID
                , TM.ELECTRODE_TYPE
           /* OPTION ( FORCE ORDER -- LM → AN → TM 조인 순서 강제 유지
                     , MAXDOP 1 -- 병렬처리 허용 (현재 DOP=1 강제, 4코어 서버 환경) ) : Oracle 힌트 미사용 */
           /* AS-IS L591~L598 (원문 그대로 보존)
                                  ( *
                                    MAXDOP 주석:
                                    - 현재 실행계획은 DegreeOfParallelism="1" (직렬 처리)
                                    - OptimizerHardwareDependentProperties: EstimatedAvailableDOP=4 확인됨
                                    - HASH JOIN으로 변경 시 옵티마이저가 병렬 플랜을 선택할 수 있어 추가 성능 향상 기대
                                    - 서버 부하 상황에 따라 MAXDOP 1로 제한하는 것이 나을 수 있으므로 테스트 후 결정
                                    - 부하 우려 시 MAXDOP 1 사용
                                  * )
           */
        ;
        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 끝 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INTO #LINE_ASSIGN_ORG ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' #LINE_ASSIGN_ORG ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------- */
        /* 출하/생산계획 추가대상 건 확인 */
        /* ------------------------- */
        INSERT
          INTO GT_XPGS_LINE_ASSIGN
             ( DIVISION_ID
             , PLANT_ID
             , ITEM_ID
             , LINE_ID
             , MODEL_ID
             , CHILD_ITEM_ID
             , OPERATION_ID
             , OPERATION_GROUP_ID
             , COMPANY_ID
             , SITE_ID
             , FACTORY_ID
             , ELECTRODE_TYPE
             , ITEM_TYPE
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.PLANT_ID
             , X.ITEM_ID
             , X.LINE_ID
             , X.MODEL_ID
             , X.CHILD_ITEM_ID
             , X.OPERATION_ID
             , X.OPERATION_GROUP_ID
             , X.COMPANY_ID
             , X.SITE_ID
             , X.FACTORY_ID
             , X.ELECTRODE_TYPE
             , (CASE WHEN X.ITEM_ID = X.CHILD_ITEM_ID THEN 'R' ELSE 'S' END) AS ITEM_TYPE
          FROM (SELECT V1.DIVISION_ID
                     , V1.PLANT_ID
                     , A.ITEM_ID
                     , A.LINE_ID
                     , V1.MODEL_ID
                     , V1.CHILD_ITEM_ID
                     , A.OPERATION_ID
                     , V1.OPERATION_GROUP_ID
                     , A.COMPANY_ID
                     , A.SITE_ID
                     , A.FACTORY_ID
                     , A.ELECTRODE_TYPE
                  FROM GT_XPGS_LINE_ASSIGN_ORG        A
                     , SCM_MST_MODEL_FINAL_ITEM_BOM_V V1  /* PACK 기준으로 종속된 CELL 까지 */
                 WHERE V1.DIVISION_ID         = A.DIVISION_ID
                   AND V1.PLANT_ID            = A.FROM_SITE_ID
                   AND V1.MODEL_ID            = A.ITEM_ID
                   AND V1.OPERATION_GROUP_ID <> 'E'
                 UNION ALL
                SELECT V2.DIVISION_ID
                     , V2.PLANT_ID
                     , A.ITEM_ID
                     , A.LINE_ID
                     , V2.MODEL_ID
                     , V2.CHILD_ITEM_ID
                     , A.OPERATION_ID
                     , V2.OPERATION_GROUP_ID
                     , A.COMPANY_ID
                     , A.SITE_ID
                     , A.FACTORY_ID
                     , A.ELECTRODE_TYPE
                  FROM GT_XPGS_LINE_ASSIGN_ORG        A
                     , SCM_MST_MODEL_FINAL_ITEM_BOM_V V2  /* CELL 단독 */
                 WHERE V2.DIVISION_ID        = A.DIVISION_ID
                   AND V2.PLANT_ID           = A.FROM_SITE_ID
                   AND V2.MODEL_ID           = A.ITEM_ID
                   AND V2.CHILD_ITEM_ID      = A.ITEM_ID
                   AND V2.OPERATION_GROUP_ID = 'A'
               )                  X
             , SCP_MST_FINAL_ITEM Z
         WHERE 1 = 1
           AND X.DIVISION_ID        = Z.DIVISION_ID
           AND X.ITEM_ID            = Z.ITEM_ID
           AND X.OPERATION_GROUP_ID = Z.OPERATION_GROUP
           AND X.OPERATION_ID       = Z.FLOW_ID
           AND Z.DIVISION_ID        = V_DIVISION_ID
           AND Z.FCST_YN            = 'Y'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INTO #LINE_ASSIGN ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' #LINE_ASSIGN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ----------- */
        /* 출하계획 */
        /* ----------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.BIZ_TYPE
             , NULL                                AS CELL_ITEM_ID  /* AS-IS '' */
             , A.ITEM_ID
             , NVL(A.TO_SITE, '-')                 AS TO_SITE       /* ISNULL(NULLIF(A.TO_SITE, '') , '-') */
             , A.PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
               /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
             , NVL((SELECT C.TRANSPORT_MODE
                      FROM SCP_MST_BOD_N_V C
                     WHERE 0 = 0
                       AND C.DIVISION_ID = A.DIVISION_ID
                       AND C.BOD_ID      = A.BOD_ID
                       AND C.FROM_SITE   = A.FROM_SITE
                       AND ROWNUM        = 1), '-')        AS TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , A.MEASURE                                       /* SHIP_PLAN FG */
             , A.YYYYMMDD                          AS YYYYMMDD
             , NVL(A.QTY, 0)                       AS QTY      /* 기존 INTRANSIT 무시하고 모두 0 */
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_FG'          AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM (SELECT DISTINCT
                       P.DIVISION_ID
                     , LN.CHILD_ITEM_ID            AS ITEM_ID
                     , Y.SH_FG                     AS BIZ_TYPE
                     , P.PROJECT_CODE
                     , P.SALES_SITE_ID             AS TO_SITE
                     , P.PLANT_SITE_ID             AS FROM_SITE
                     , V_PLAN_START_YYYYMMDD       AS YYYYMMDD
                     , B.INCOTERMS
                     , B.BOD_ID
                     , 'SHIP_PLAN'                 AS MEASURE
                     , 0                           AS QTY
                     , CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE9
                  FROM SCM_MST_SITE_ITEM_PRIORITY P
                     , GT_XPGS_LINE_ASSIGN        LN
                     , (SELECT DISTINCT
                               SA.ITEM_ID
                             , SA.MEASURE
                             , SA.BIZ_TYPE         AS SH_FG
                             , SA.INCOTERMS
                             , SA.TO_SITE
                          FROM SCP_ANL_SHIPMENT_PLAN_FG SA  /* MKT_FCST 존재할 경우만 */
                         WHERE SA.DIVISION_ID         = V_DIVISION_ID
                           AND SA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                           AND SA.PLAN_TYPE           = V_PLAN_TYPE
                           AND SA.SEQ                 = V_SEQ
                           AND SA.MEASURE             = 'MKT_FCST'
                       )                          Y
                     , SCP_MST_BOD_N_V            B  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                 WHERE P.DIVISION_ID                 = LN.DIVISION_ID
                   AND P.ITEM_ID                     = LN.CHILD_ITEM_ID
                   AND SUBSTR(P.PLANT_SITE_ID, 1, 4) = LN.PLANT_ID
                   AND Y.ITEM_ID                     = P.ITEM_ID
                   AND Y.SH_FG                       = LN.OPERATION_GROUP_ID
                   AND B.DIVISION_ID                 = LN.DIVISION_ID
                   AND B.FROM_SITE                   = P.PLANT_SITE_ID
                   AND B.TO_SITE                     = P.SALES_SITE_ID
                   AND B.INCOTERMS                   = Y.INCOTERMS
                   AND B.TO_SITE                     = Y.TO_SITE
                   AND NOT EXISTS (SELECT 1
                                     FROM SCP_ANL_SHIPMENT_PLAN_FG SB  /* 출하계획 존재시 제외 */
                                    WHERE SB.DIVISION_ID         = V_DIVISION_ID
                                      AND SB.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND SB.PLAN_TYPE           = V_PLAN_TYPE
                                      AND SB.SEQ                 = V_SEQ
                                      AND SB.FROM_SITE           = P.PLANT_SITE_ID
                                      AND SB.ITEM_ID             = LN.CHILD_ITEM_ID
                                      AND SB.BOD_ID              = B.BOD_ID
                                      AND SB.MEASURE             = 'SHIP_PLAN'
                                      /* 중복값 수정이 안되는 현상 발생하여 제거함 : KSK, 2023-07-10 */
                                      /* --                           AND PROJECT_CODE != '-' */
                                  )
                   /* 변경후 */
                   AND P.FROM_YYYYMMDD              <= V_TO_YYYYMMDD
                   AND P.VALID_YN                    = 'Y'
                   AND B.BOD_TYPE                    = 'SALES'
                   AND B.BOD_VALID_YN                = 'Y'
               )  A
             , (SELECT SC.COLUMN_NAME
                     , SC.COLUMN_LABEL_NAME
                     , SC.SORT_ORDER_NO
                     , (CASE WHEN SC.ATTRIBUTE1 = 'PACK' THEN 'P' WHEN SC.ATTRIBUTE1 = 'CELL' THEN 'A' ELSE 'C' END) AS DIV
                     , SC.ATTRIBUTE2               AS GUBUN
                  FROM SCM_MST_SHEET_MEASURE SC
                 WHERE SC.PROGRAM_ID = V_PROGRAM_ID
                   AND SC.VALID_YN   = 'Y'
               )  M
         WHERE A.MEASURE      = M.COLUMN_NAME
           AND M.COLUMN_NAME IN ('SHIP_PLAN', 'MKT_FCST')
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SHIP_PLAN / MKT_FCST ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ----------- */
        /* 생산계획 */
        /* ----------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT X.DIVISION_ID
             , SUBSTR(X.OPERATION_ID, 1, 1)        AS OPERATION_GROUP_ID
             , NULL                                AS CELL_ITEM_ID  /* AS-IS '' */
             , X.ITEM_ID
             , '-'                                 AS TO_SITE
             , '-'                                 AS PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , X.SCM_SITE_ID                       AS FROM_SITE
             , '-'                                 AS TRANSPORT_MODE
             , X.LINE_ID                           AS PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , X.YYYYMMDD
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                                 AS BOD_ID
             , 'SCP_ANL_PRODUCTION_PLAN'           AS ATTRIBUTE1
             , X.OPERATION_ID                      AS ATTRIBUTE9
          FROM (SELECT DISTINCT  /* LINE ASSIGN + DAILY CAPA + PACK 에 대한 CELL ITEM */
                       X.DIVISION_ID
                     , S.SCM_SITE_ID
                     , X.ITEM_ID
                     , X.LINE_ID
                       /* --, X.MODEL_ID */
                       /* --, X.CHILD_ITEM_ID */
                     , X.OPERATION_ID
                     , V_PLAN_START_YYYYMMDD       AS YYYYMMDD
                  FROM (SELECT DISTINCT
                               TM.DIVISION_ID
                             , TM.PLANT_ID
                             , TM.LINE_ID
                             , TM.ITEM_ID
                             , TM.OPERATION_ID
                             , AN.OPERATION_GROUP_ID
                          FROM GT_XPGS_LINE_ASSIGN  AN
                             , SCM_MST_TACT_TIME_SN TM
                         WHERE TM.DIVISION_ID    = AN.DIVISION_ID
                           AND TM.COMPANY_ID     = AN.COMPANY_ID
                           AND TM.SITE_ID        = AN.SITE_ID
                           AND TM.PLANT_ID       = AN.PLANT_ID
                           AND TM.FACTORY_ID     = AN.FACTORY_ID
                           AND TM.OPERATION_ID   = AN.OPERATION_ID
                           AND TM.LINE_ID        = AN.LINE_ID
                           AND TM.ELECTRODE_TYPE = AN.ELECTRODE_TYPE
                           AND TM.ITEM_ID        = AN.ITEM_ID
                           AND AN.ITEM_TYPE      = 'R'
                         UNION ALL
                        SELECT DISTINCT
                               TM.DIVISION_ID
                             , TM.PLANT_ID
                             , TM.LINE_ID
                             , TM.ITEM_ID
                             , TM.OPERATION_ID
                             , AN.OPERATION_GROUP_ID
                          FROM GT_XPGS_LINE_ASSIGN  AN
                             , SCM_MST_TACT_TIME_SN TM
                         WHERE TM.DIVISION_ID    = AN.DIVISION_ID
                           AND TM.COMPANY_ID     = AN.COMPANY_ID
                           AND TM.SITE_ID        = AN.SITE_ID
                           AND TM.PLANT_ID       = AN.PLANT_ID
                           AND TM.FACTORY_ID     = AN.FACTORY_ID
                           AND TM.OPERATION_ID   = AN.OPERATION_ID
                           AND TM.LINE_ID        = AN.LINE_ID
                           AND TM.ELECTRODE_TYPE = AN.ELECTRODE_TYPE
                           AND TM.ITEM_ID        = AN.CHILD_ITEM_ID
                           AND AN.ITEM_TYPE      = 'S'
                           AND SUBSTR(TM.OPERATION_ID, 1, 1) = 'A'
                       ) X
                     , (SELECT SA.DIVISION_ID
                             , SA.SCM_SITE_ID
                             , SA.SITE_DESCRIPTION
                             , SA.OPERATION_GROUP
                          FROM SCM_MST_SITE SA
                         WHERE SA.DIVISION_ID = V_DIVISION_ID
                       ) S
                 WHERE 1 = 1
                   AND S.OPERATION_GROUP           = X.OPERATION_GROUP_ID
                   AND SUBSTR(S.SCM_SITE_ID, 1, 4) = X.PLANT_ID
                   AND NOT EXISTS (SELECT 1
                                     FROM SCP_ANL_PRODUCTION_PLAN SB  /* 생산계획 존재시 제외 */
                                    WHERE SB.DIVISION_ID         = V_DIVISION_ID
                                      AND SB.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND SB.PLAN_TYPE           = V_PLAN_TYPE
                                      AND SB.SEQ                 = V_SEQ
                                      AND SB.SCM_SITE_ID         = S.SCM_SITE_ID
                                      AND SB.ITEM_ID             = X.ITEM_ID
                                      AND SB.LINE_ID             = X.LINE_ID
                                      AND SB.MEASURE             = 'PROD_PLAN_AMEND')
               ) X
               /* --INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) */
               /* --        ON X.YYYYMMDD = C.BASIS_YYYYMMDD */
             , (SELECT SC.COLUMN_NAME
                     , SC.COLUMN_LABEL_NAME
                     , SC.SORT_ORDER_NO
                     , (CASE WHEN SC.ATTRIBUTE1 = 'PACK' THEN 'P' WHEN SC.ATTRIBUTE1 = 'CELL' THEN 'A' ELSE 'C' END) AS DIV
                     , SC.ATTRIBUTE2               AS GUBUN
                       /* --INTO #MEASURE */
                  FROM SCM_MST_SHEET_MEASURE SC
                 WHERE SC.PROGRAM_ID = V_PROGRAM_ID
                   AND SC.VALID_YN   = 'Y'
               ) M
         WHERE 1 = 1
           AND M.COLUMN_NAME IN ('PACK_PROD', 'CELL_PROD')
           AND (CASE WHEN SUBSTR(X.OPERATION_ID, 1, 1) = 'P' THEN 'PACK_PROD'
                     WHEN SUBSTR(X.OPERATION_ID, 1, 1) = 'A' THEN 'CELL_PROD'
                     ELSE '-'
                END) = M.COLUMN_NAME
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SCP_ANL_PRODUCTION_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* -------------------------------------------- */
        /* SHIP_PLAN (SEMI) -- SEMI_SHIP_PLAN */
        /* -------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , NULL                                AS CELL_ITEM_ID  /* AS-IS '' */
             , A.ITEM_ID
             , NVL(A.TO_SITE, '-')                 AS TO_SITE       /* ISNULL(NULLIF(A.TO_SITE, '') , '-') */
             , '-'                                 AS PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , A.FROM_SITE
               /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
             , NVL((SELECT C.TRANSPORT_MODE
                      FROM SCP_MST_BOD_N_V C
                     WHERE 0 = 0
                       AND C.DIVISION_ID = A.DIVISION_ID
                       AND C.BOD_ID      = A.BOD_ID
                       AND C.FROM_SITE   = A.FROM_SITE
                       AND ROWNUM        = 1), '-')        AS TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , A.YYYYMMDD                          AS YYYYMMDD
             , NVL(A.QTY, 0)                       AS QTY      /* 기존 INTRANSIT 무시하고 모두 0 */
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_SEMI'        AS ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM (SELECT LN.DIVISION_ID
                     , LN.CHILD_ITEM_ID            AS ITEM_ID
                     , B.FROM_SITE
                     , B.TO_SITE
                     , B.BOD_ID
                     , V_PLAN_START_YYYYMMDD       AS YYYYMMDD
                     , 'SEMI_SHIP_PLAN'            AS MEASURE
                     , LN.OPERATION_GROUP_ID       AS OPERATION_GROUP
                     , 0                           AS QTY
                     , CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE9
                  FROM GT_XPGS_LINE_ASSIGN LN
                     , SCP_MST_BOD_N_V     B  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                 WHERE B.DIVISION_ID                = LN.DIVISION_ID
                   AND SUBSTR(B.FROM_SITE, 1, 4)    = LN.PLANT_ID
                   AND B.TO_SITE                    = (SELECT DISTINCT LN.PLANT_ID || '-P'
                                                         FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V
                                                        WHERE V.MODEL_ID           = LN.CHILD_ITEM_ID
                                                          AND V.PLANT_ID           = LN.PLANT_ID
                                                          AND V.OPERATION_GROUP_ID = 'A'
                                                          AND V.ELECTRODE_TYPE IS NULL)  /* AS-IS V.electrode_type = '' */
                   AND NOT EXISTS (SELECT 1
                                     FROM SCP_ANL_SHIPMENT_PLAN_SEMI SB  /* SEMI 출하계획 존재시 제외 */
                                    WHERE SB.DIVISION_ID         = V_DIVISION_ID
                                      AND SB.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND SB.PLAN_TYPE           = V_PLAN_TYPE
                                      AND SB.SEQ                 = V_SEQ
                                      AND SB.FROM_SITE           = B.TO_SITE
                                      AND SB.ITEM_ID             = LN.CHILD_ITEM_ID
                                      AND SB.BOD_ID              = B.BOD_ID
                                      AND SB.MEASURE             = 'SHIP_PLAN')
                   AND LN.OPERATION_GROUP_ID        = 'A'
                   AND B.BOD_TYPE                   = 'PLANT'
                   AND B.BOD_VALID_YN               = 'Y'
               ) A
             , (SELECT SC.COLUMN_NAME
                     , SC.COLUMN_LABEL_NAME
                     , SC.SORT_ORDER_NO
                     , (CASE WHEN SC.ATTRIBUTE1 = 'PACK' THEN 'P' WHEN SC.ATTRIBUTE1 = 'CELL' THEN 'A' ELSE 'C' END) AS DIV
                     , SC.ATTRIBUTE2               AS GUBUN
                       /* --INTO #MEASURE */
                  FROM SCM_MST_SHEET_MEASURE SC
                 WHERE SC.PROGRAM_ID = V_PROGRAM_ID
                   AND SC.VALID_YN   = 'Y'
               ) M
         WHERE 1 = 1
           AND M.COLUMN_NAME IN ('SEMI_SHIP_PLAN')
           AND (CASE A.MEASURE WHEN 'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN' ELSE A.MEASURE END) = M.COLUMN_NAME
           AND A.ITEM_ID IN (SELECT DISTINCT SD.ITEM_ID
                               FROM SCP_ANL_SHIPMENT_PLAN_FG SD  /* 출하계획 존재시 제외 */
                              WHERE SD.DIVISION_ID         = V_DIVISION_ID
                                AND SD.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                AND SD.PLAN_TYPE           = V_PLAN_TYPE
                                AND SD.SEQ                 = V_SEQ
                                AND SD.FROM_SITE           = A.FROM_SITE
                                AND SD.ITEM_ID             = A.ITEM_ID
                                AND SD.BOD_ID              = A.BOD_ID
                                AND SD.MEASURE             = 'MKT_FCST')
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SHIP_PLAN (SEMI) -- SEMI_SHIP_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - end */

        /* IF OBJECT_ID('TEMPDB..#ANL_SHIPMENT_PLAN_FG') IS NOT NULL DROP TABLE #ANL_SHIPMENT_PLAN_FG
           SELECT * INTO #ANL_SHIPMENT_PLAN_FG FROM #PSI_GLOBAL_SMALL WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'
           IF OBJECT_ID('TEMPDB..#ANL_PRODUCTION_PLAN') IS NOT NULL DROP TABLE #ANL_PRODUCTION_PLAN
           SELECT * INTO #ANL_PRODUCTION_PLAN FROM #PSI_GLOBAL_SMALL WHERE ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'
           → 이후 GT_XPGS_PSI_GLOBAL_SMALL 에 두 ATTRIBUTE1 값으로 추가되는 행이 없어 사본 대신 같은 GTT 를 ATTRIBUTE1 조건으로 조회 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INTO #ANL_SHIPMENT_PLAN_FG / #ANL_PRODUCTION_PLAN  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' #ANL_SHIPMENT_PLAN_FG / #ANL_PRODUCTION_PLAN  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* SHIP_PLAN (SEMI) -- SEMI_SHIP_PLAN */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , X.MEASURE
             , X.YYYYMMDD
             , X.QTY
             , X.SORT_ORDER_NO
             , X.COLUMN_LABEL_NAME
             , MAX(X.BOD_ID)                       AS BOD_ID  /* -- */
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM (SELECT A.DIVISION_ID
                     , A.OPERATION_GROUP
                     , CAST(NULL AS VARCHAR2(100 CHAR)) AS CELL_ITEM_ID  /* AS-IS '' */
                     , A.ITEM_ID
                     , NVL(A.TO_SITE, '-')         AS TO_SITE  /* ISNULL(NULLIF(A.TO_SITE, '') , '-') */
                     , '-'                         AS PROJECT_CODE
                     , 0                           AS TO_BOH_QTY
                     , 0                           AS FROM_BOH_QTY
                     , '-'                         AS INCOTERMS
                     , A.FROM_SITE
                       /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                     , NVL((SELECT C.TRANSPORT_MODE
                              FROM SCP_MST_BOD_N_V C
                             WHERE 0 = 0
                               AND C.DIVISION_ID = A.DIVISION_ID
                               AND C.BOD_ID      = A.BOD_ID
                               AND C.FROM_SITE   = A.FROM_SITE
                               AND ROWNUM        = 1), '-') AS TRANSPORT_MODE
                     , '-'                         AS PROD_LINE
                     , M.COLUMN_NAME               AS MEASURE
                     , A.YYYYMMDD                  AS YYYYMMDD
                     , NVL(A.QTY, 0)               AS QTY  /* 기존 INTRANSIT 무시하고 모두 0 */
                     , M.SORT_ORDER_NO
                     , M.COLUMN_LABEL_NAME
                     , A.BOD_ID
                     , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
                     , A.ATTRIBUTE9
                  FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                     , GT_XPGS_MEASURE            M
                 WHERE M.COLUMN_NAME IN ('SEMI_SHIP_PLAN')
                   AND (CASE A.MEASURE WHEN 'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN' ELSE A.MEASURE END) = M.COLUMN_NAME
                   AND A.DIVISION_ID          = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE            = V_PLAN_TYPE
                   AND A.SEQ                  = V_SEQ
                   AND A.YYYYMMDD            >= V_PLAN_START_YYYYMMDD
                   AND A.YYYYMMDD            <= V_TO_YYYYMMDD  /* 말일포함 (KSK, 20240814) */
                   AND A.MEASURE             IN ('SHIP_PLAN')

                 /* SEMI SEMI_SHIP_PLAN없이 해상재고만 있는 경우 누락되는 로직 수정 */
                 UNION
                SELECT DISTINCT
                       V_DIVISION_ID               AS DIVISION_ID
                     , C.OPERATION_GROUP
                     , CAST(NULL AS VARCHAR2(100 CHAR)) AS CELL_ITEM_ID  /* AS-IS '' */
                     , A.ITEM_ID
                     , (SUBSTR(A.SITE_ID, 1, FN_CHARINDEX_REV(A.SITE_ID, '~', 0) - 1)) AS TO_SITE
                     , '-'                         AS PROJECT_CODE
                     , 0                           AS TO_BOH_QTY
                     , 0                           AS FROM_BOH_QTY
                     , '-'                         AS INCOTERMS
                     , (SUBSTR(A.LOT_ID, FN_CHARINDEX_REV(A.LOT_ID, '::', 0) + 2, 100)) AS FROM_SITE
                     , 'SEA'                       AS TRANSPORT_MODE  /* 해상재고 강제로 'SEA' */
                     , '-'                         AS PROD_LINE
                     , 'SEMI_SHIP_PLAN'            AS MEASURE
                     , V_PLAN_START_YYYYMMDD       AS YYYYMMDD
                       /* -- ,CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) AS YYYYMMDD */
                     , 0                           AS QTY
                     , 360                         AS SORT_ORDER_NO  /* '360' */
                     , 'Semi Ship Plan'            AS COLUMN_LABEL_NAME
                     , '-'                         AS BOD_ID  /* -- */
                     , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
                     , CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE9
                  FROM TH_ENG_STOCK_PLAN_SN  A
                     , SCP_MST_FINAL_ITEM_V  C
                 WHERE 1 = 1
                   AND A.ITEM_ID   = C.ITEM_ID
                   AND A.MASTER_ID = V_MASTER_ID
                   AND A.PLAN_ID   = V_ENGINE_PLAN_ID
                   AND A.DESCR     = 'INT'
                   /* --AND LEFT(A.SITE_ID, 6) = (SELECT TOP 1 S.SCM_SITE_ID FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.PLANT_ID = LEFT(A.SITE_ID, 6) AND S.PLANT_ID IS NOT NULL) -- 2021.11.16 SEMI PACK 출하계획생성오류 수정 */
                   /* --AND A.ITEM_ID = 'ACPN1034U-A1' */

                   /* -->>> KSW 2020.09.03 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완) start */
                   AND NOT EXISTS (SELECT 1
                                     FROM SCP_ANL_SHIPMENT_PLAN_SEMI SA
                                    WHERE SA.ITEM_ID             = A.ITEM_ID
                                      AND SA.DIVISION_ID         = V_DIVISION_ID
                                      AND SA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND SA.PLAN_TYPE           = V_PLAN_TYPE
                                      AND SA.SEQ                 = V_SEQ
                                      AND SA.YYYYMMDD           >= V_PLAN_START_YYYYMMDD
                                      AND SA.YYYYMMDD           <= V_TO_YYYYMMDD  /* 말일포함 (KSK, 20240814) */
                                      AND SA.MEASURE            IN ('SHIP_PLAN'))  /* AS-IS NOT A.ITEM_ID IN (...) */
                   /* -->>> KSW 2020.09.03 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완) end */
               ) X
         GROUP BY X.DIVISION_ID
                , X.OPERATION_GROUP
                , X.CELL_ITEM_ID
                , X.ITEM_ID
                , X.TO_SITE
                , X.PROJECT_CODE
                , X.TO_BOH_QTY
                , X.FROM_BOH_QTY
                , X.INCOTERMS
                , X.FROM_SITE
                , X.TRANSPORT_MODE
                , X.PROD_LINE
                , X.MEASURE
                , X.YYYYMMDD
                , X.QTY
                , X.SORT_ORDER_NO
                , X.COLUMN_LABEL_NAME
                , X.ATTRIBUTE1
                , X.ATTRIBUTE9
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* SELECT * INTO #ANL_SHIPMENT_PLAN_SEMI FROM #PSI_GLOBAL_SMALL WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
           → 이후 같은 ATTRIBUTE1 값으로 추가되는 행이 없어 같은 GTT 를 ATTRIBUTE1 조건으로 조회 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INTO ##ANL_SHIPMENT_PLAN_SEMI ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' #ANL_SHIPMENT_PLAN_SEMI  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* CELL_CHAR_PLAN (SCP_PLN_PRODUCTION_PLAN) ACTIVATE_COMPLETED --> CELL_CHAR_PLAN */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , MAX(X.PROD_LINE)                    AS PROD_LINE
             , X.MEASURE
             , X.YYYYMMDD
             , MAX(X.QTY)                          AS QTY
             , X.SORT_ORDER_NO
             , X.COLUMN_LABEL_NAME
             , X.BOD_ID
             , MAX(X.ATTRIBUTE1)                   AS ATTRIBUTE1
             , MAX(X.ATTRIBUTE9)                   AS ATTRIBUTE9
          FROM (SELECT A.DIVISION_ID
                     , A.OPERATION_GROUP
                     , CAST(NULL AS VARCHAR2(100 CHAR)) AS CELL_ITEM_ID  /* AS-IS '' */
                     , A.ITEM_ID
                     , '-'                         AS TO_SITE
                     , '-'                         AS PROJECT_CODE
                     , 0                           AS TO_BOH_QTY
                     , 0                           AS FROM_BOH_QTY
                     , '-'                         AS INCOTERMS
                     , A.SITE_ID                   AS FROM_SITE
                     , '-'                         AS TRANSPORT_MODE
                     , '-'                         AS PROD_LINE
                     , 'CELL_CHAR_PLAN'            AS MEASURE  /* ACTIVATE_COMPLETED */
                     , TO_CHAR(A.END_TIME, 'YYYYMMDD') AS YYYYMMDD
                     , SUM(NVL(A.COMPLETE_QTY, 0)) AS QTY
                     , M.SORT_ORDER_NO
                     , M.COLUMN_LABEL_NAME
                     , '-'                         AS BOD_ID
                     , 'SCP_PLN_PRODUCTION_PLAN'   AS ATTRIBUTE1
                     , A.OPERATION_ID              AS ATTRIBUTE9
                  FROM SCP_PLN_PRODUCTION_PLAN A
                     , GT_XPGS_MEASURE         M
                 WHERE 1 = 1
                   AND M.COLUMN_NAME IN ('CELL_CHAR_PLAN')
                   AND A.DIVISION_ID          = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE            = V_PLAN_TYPE
                   AND A.SEQ                  = V_SEQ
                   AND A.OPERATION_ID         = 'F6000'
                 GROUP BY A.DIVISION_ID
                        , A.OPERATION_GROUP
                        , A.ITEM_ID
                        , A.SITE_ID
                        , TO_CHAR(A.END_TIME, 'YYYYMMDD')
                        , M.SORT_ORDER_NO
                        , M.COLUMN_LABEL_NAME
                        , A.OPERATION_ID

                 UNION
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.OPERATION_GROUP
                     , CAST(NULL AS VARCHAR2(100 CHAR)) AS CELL_ITEM_ID  /* AS-IS '' */
                     , A.ITEM_ID
                     , '-'                         AS TO_SITE
                     , '-'                         AS PROJECT_CODE
                     , 0                           AS TO_BOH_QTY
                     , 0                           AS FROM_BOH_QTY
                     , '-'                         AS INCOTERMS
                     , A.FROM_SITE
                     , '-'                         AS TRANSPORT_MODE
                     , '-'                         AS PROD_LINE
                     , 'CELL_CHAR_PLAN'            AS MEASURE  /* ACTIVATE_COMPLETED */
                     , A.YYYYMMDD
                     , 0                           AS QTY
                     , 440                         AS SORT_ORDER_NO  /* '440' */
                     , 'Char. Plan'                AS COLUMN_LABEL_NAME
                     , '-'                         AS BOD_ID
                     , CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE1  /* AS-IS '' */
                     , CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE9  /* AS-IS '' */
                  FROM GT_XPGS_PSI_GLOBAL_SMALL A  /* AS-IS #ANL_PRODUCTION_PLAN */
                 WHERE 0 = 0
                   AND A.ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'

                 /* KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - Start */
                 UNION
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.OPERATION_GROUP
                     , CAST(NULL AS VARCHAR2(100 CHAR)) AS CELL_ITEM_ID  /* AS-IS '' */
                     , A.ITEM_ID
                     , '-'                         AS TO_SITE
                     , '-'                         AS PROJECT_CODE
                     , 0                           AS TO_BOH_QTY
                     , 0                           AS FROM_BOH_QTY
                     , '-'                         AS INCOTERMS
                     , A.FROM_SITE
                     , '-'                         AS TRANSPORT_MODE
                     , '-'                         AS PROD_LINE
                     , 'CELL_CHAR_PLAN'            AS MEASURE  /* ACTIVATE_COMPLETED */
                     , A.YYYYMMDD
                     , 0                           AS QTY
                     , 440                         AS SORT_ORDER_NO  /* '440' */
                     , 'Char. Plan'                AS COLUMN_LABEL_NAME
                     , '-'                         AS BOD_ID
                     , CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE1  /* AS-IS '' */
                     , CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE9  /* AS-IS '' */
                  FROM GT_XPGS_PSI_GLOBAL_SMALL A  /* AS-IS #ANL_SHIPMENT_PLAN_SEMI */
                 WHERE 0 = 0
                   AND A.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                 /* KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - End */
               ) X
         GROUP BY X.DIVISION_ID
                , X.OPERATION_GROUP
                , X.CELL_ITEM_ID
                , X.ITEM_ID
                , X.TO_SITE
                , X.PROJECT_CODE
                , X.TO_BOH_QTY
                , X.FROM_BOH_QTY
                , X.INCOTERMS
                , X.FROM_SITE
                , X.TRANSPORT_MODE
                /* --, X.PROD_LINE */
                , X.MEASURE
                , X.YYYYMMDD
                /* --, MAX(X.QTY) AS QTY */
                , X.SORT_ORDER_NO
                , X.COLUMN_LABEL_NAME
                , X.BOD_ID
                /* --, X.ATTRIBUTE1 */
                /* --, X.ATTRIBUTE9 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' CELL_CHAR_PLAN (SCP_PLN_PRODUCTION_PLAN)   ACTIVATE_COMPLETED --> CELL_CHAR_PLAN  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* SELECT * INTO #SCP_PLN_PRODUCTION_PLAN FROM #PSI_GLOBAL_SMALL WHERE ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
           → 이후 GT_XPGS_PSI_GLOBAL_SMALL 추가 적재가 없어 같은 GTT 를 ATTRIBUTE1 조건으로 조회 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INTO #SCP_PLN_PRODUCTION_PLAN  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' #PSI_GLOBAL_SMALL ATTRIBUTE1.SCP_PLN_PRODUCTION_PLAN   ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* 대상 ITEM_ID 추출 */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_XPGS_ITEM_ID;

        INSERT
          INTO GT_XPGS_ITEM_ID
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.TO_SITE
             , A.PROJECT_CODE
             , MAX(A.TO_BOH_QTY)                   AS TO_BOH_QTY
             , MAX(A.FROM_BOH_QTY)                 AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE
             , A.PROD_LINE
             , A.MEASURE
             , MAX(A.QTY)                          AS QTY
             , A.SORT_ORDER_NO
             , A.COLUMN_LABEL_NAME
             , A.BOD_ID
             , MAX(A.ATTRIBUTE1)                   AS ATTRIBUTE1
             , MAX(A.ATTRIBUTE9)                   AS ATTRIBUTE9
          FROM GT_XPGS_PSI_GLOBAL_SMALL A
         WHERE 0 = 0
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.CELL_ITEM_ID
                , A.ITEM_ID
                , A.TO_SITE
                , A.PROJECT_CODE
                , A.INCOTERMS
                , A.FROM_SITE
                , A.TRANSPORT_MODE
                , A.PROD_LINE
                , A.MEASURE
                , A.SORT_ORDER_NO
                , A.COLUMN_LABEL_NAME
                , A.BOD_ID
                /* --,ATTRIBUTE1 */
                /* --,ATTRIBUTE9 */
        ;
        /* AS-IS #ITEM_ID.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd(상수) : GTT 칸 대신 V_PLAN_START_YYYYMMDD 직접 사용 */

        /* IF @p_is_debug = 1 BEGIN SELECT '995_#ITEM_ID' AS "#ITEM_ID" , * FROM #ITEM_ID ; END : 디버그 결과 집합 없음 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INTO #ITEM_ID  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 대상 ITEM_ID 추출   ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL_AUTO') IS NOT NULL DROP TABLE #PSI_GLOBAL_SMALL_AUTO;
           CREATE TABLE #PSI_GLOBAL_SMALL_AUTO (...) → GTT GT_XPGS_PSI_GLOBAL_SMALL_AUTO 사전 생성
           칸 주석 : PROJECT_CODE -- FG 때문에 추가 / TO_BOH_QTY --BIGINT / FROM_BOH_QTY -- BIGINT / ATTRIBUTE9 -- OPERATION_ID */
        DELETE FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO;

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                                 AS TO_SITE
             , '-'                                 AS PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , '-'                                 AS FROM_SITE
             , '-'                                 AS TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                                 AS BOD_ID
             , 'MKT_FCST_PACK_TOTAL'               AS ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.DIV             = 'C'
           AND M.GUBUN           = 'ITEM_ID'
           AND X.MEASURE         = 'MKT_FCST'
           AND X.OPERATION_GROUP = 'P'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL) ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , '-'                                 AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , X.BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.DIV     = 'C'
           AND M.GUBUN   = 'TO'
           AND X.MEASURE = 'MKT_FCST'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL) ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* IF @p_is_debug = 1 SELECT '#PSI_GLOBAL_SMALL_AUTO_1' AS "#PSI_GLOBAL_SMALL_AUTO_1", * FROM #PSI_GLOBAL_SMALL_AUTO --TEST : 디버그 결과 집합 없음 */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , (CASE WHEN M.COLUMN_NAME = 'SHIP_PLAN' THEN X.PROJECT_CODE ELSE '-' END)   AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , (CASE WHEN M.COLUMN_NAME = 'SHIP_PLAN' THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , (CASE WHEN M.COLUMN_NAME = 'SHIP_PLAN' THEN X.BOD_ID ELSE '-' END)         AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.DIV         = 'C'
           AND M.GUBUN       = 'FROM'
           AND X.MEASURE    IN ('SHIP_PLAN', 'WHIN')
           AND NOT M.COLUMN_NAME = 'SHIP_PLAN_MEMO'  /* 2022.10.19 KSW Memo measure 추가 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT) ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* IF @p_is_debug = 1 SELECT '#PSI_GLOBAL_SMALL_AUTO_2' AS "#PSI_GLOBAL_SMALL_AUTO_2", * FROM #PSI_GLOBAL_SMALL_AUTO --TEST : 디버그 결과 집합 없음 */

        /* 2022.10.19 KSW Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 - START */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , X.BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.DIV         = 'C'
           AND M.GUBUN       = 'FROM'
           AND X.MEASURE     = 'SHIP_PLAN'
           AND M.COLUMN_NAME = 'SHIP_PLAN_MEMO'
        ;
        /* 2022.10.19 KSW Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 - END */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH', 'CELL_BOH', 'PACK_EOH', 'CELL_EOH') THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE
             , (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH', 'CELL_BOH', 'PACK_EOH', 'CELL_EOH', 'PACK_BOH_HOLD', 'PACK_BOH_WAIT_FOR_INSP', 'PACK_BOH_EXP_INSP_DATE') THEN '-' ELSE X.PROD_LINE END) AS PROD_LINE  /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 */
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH', 'CELL_BOH', 'PACK_EOH', 'CELL_EOH') THEN X.BOD_ID ELSE '-' END) AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.DIV             = 'P'
           AND M.GUBUN           = 'FROM'
           AND X.MEASURE         = 'PACK_PROD'
           AND X.OPERATION_GROUP = 'P'
           /* 전진검사 MEASURE 는 대상 모델만 추가 */
           AND (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH_WAIT_FOR_INSP', 'PACK_BOH_EXP_INSP_DATE') THEN
                          (CASE WHEN NVL((SELECT DISTINCT C.ITEM_ID
                                            FROM SCP_MST_OPERATION_LT C
                                           WHERE C.DIVISION_ID  = V_DIVISION_ID
                                             AND C.SCM_SITE_ID  = X.FROM_SITE
                                             AND C.ITEM_ID      = X.ITEM_ID
                                             AND C.LT_OPERATION = 'PRE_INSP'
                                             AND C.ATTRIBUTE1   = 'Y'
                                         ), 'N') = 'N' THEN 'N'
                                ELSE 'Y'
                           END)
                     ELSE 'Y'
                END) = 'Y'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH) ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : CELL TO SITE별 (SEMI_WHIN_TOTAL) */
        /* MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , (CASE WHEN M.COLUMN_NAME IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_PLAN_MEMO') THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE  /* 2022.10.19 KSW Memo measure 추가 :: IN 으로 변경하고 SEMI_SHIP_PLAN_MEMO 추가 */
             , X.PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , (CASE WHEN M.COLUMN_NAME IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_PLAN_MEMO') THEN X.BOD_ID ELSE '-' END) AS BOD_ID  /* 2022.10.19 KSW Memo measure 추가 :: IN 으로 변경하고 SEMI_SHIP_PLAN_MEMO 추가 */
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.DIV             = 'A'
           AND M.GUBUN           = 'FROM'
           AND M.COLUMN_NAME  LIKE 'SEMI%'
           AND X.MEASURE         = 'SEMI_SHIP_PLAN'
           AND X.OPERATION_GROUP = 'A'
         /* SEMI_WHIN_TOTAL */
         UNION ALL
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , '-'                                 AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , '-'                                 AS FROM_SITE
             , '-'                                 AS TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                                 AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.DIV             = 'A'
           AND M.GUBUN           = 'TO'
           AND M.COLUMN_NAME  LIKE 'SEMI%'
           AND X.MEASURE         = 'SEMI_SHIP_PLAN'
           AND X.OPERATION_GROUP = 'A'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : CELL TO   SITE별 (SEMI_WHIN_TOTAL)  / CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN) ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN */
        /*                                ,CELL_CHAR_AVAILABLE,CELL_FORM_PROGRESS,CELL_FORM_HOLD,CELL_FOR_FORM_END,CELL_PROD_FORM_END */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* IF @P_IS_DEBUG = 1 BEGIN IF OBJECT_ID('TEMPDB..##XLS_ITEM_ID') IS NOT NULL DROP TABLE ##XLS_ITEM_ID; SELECT * INTO ##XLS_ITEM_ID FROM #ITEM_ID END : 디버그 전용, 대상 없음 */

        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                                 AS TO_SITE
             , '-'                                 AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , X.FROM_SITE
             , '-'                                 AS TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                                 AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.DIV             = 'A'
           AND M.GUBUN           = 'FROM'
           AND M.COLUMN_NAME  LIKE 'CELL%'
           AND (X.MEASURE = 'CELL_CHAR_PLAN')
           AND X.OPERATION_GROUP = 'A'
           AND M.COLUMN_NAME NOT IN ('CELL_PROD', 'CELL_PROD_LOAD', 'CELL_PROD_MEMO')  /* 2022.10.19 KSW Memo measure 추가 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* IF @P_IS_DEBUG = 1 BEGIN SELECT '1304_ITEM_ID' "#ITEM_ID", * FROM #ITEM_ID; END : 디버그 결과 집합 없음 */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 :CELL_BOH, CELL_EOH (KSK, 250414) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                                 AS TO_SITE
             , '-'                                 AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , X.FROM_SITE
             , '-'                                 AS TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                                 AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID                X
             , GT_XPGS_MEASURE                M  /* CROSS APPLY */
             , SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
         WHERE Y.DIVISION_ID         = X.DIVISION_ID
           AND Y.MODEL_ID            = X.ITEM_ID
           AND Y.MODEL_ID           <> Y.CHILD_ITEM_ID
           AND X.FROM_SITE           = (Y.PLANT_ID || '-A')
           AND Y.CELL_TYPE           = 'CA1'
           AND Y.OPERATION_GROUP_ID  = 'A'
           AND NOT EXISTS (SELECT 1
                             FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO S
                            WHERE S.ITEM_ID   = X.ITEM_ID
                              AND S.FROM_SITE = X.FROM_SITE
                              AND S.MEASURE   = 'CELL_CHAR_PLAN')
           AND X.MEASURE             = 'MKT_FCST'
           AND M.COLUMN_NAME        IN ('CELL_BOH', 'CELL_EOH')
           AND X.DIVISION_ID         = V_DIVISION_ID
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 :CELL_BOH, CELL_EOH   ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                                 AS TO_SITE
             , '-'                                 AS PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , X.FROM_SITE
             , '-'                                 AS TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD  /* X.PLAN_START_YYYYMMDD */
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                                 AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_ITEM_ID X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.DIV             = 'A'
           AND M.GUBUN           = 'FROM'
           AND X.OPERATION_GROUP = 'A'
           AND M.COLUMN_NAME    IN ('CELL_PROD', 'CELL_PROD_LOAD', 'CELL_PROD_MEMO')  /* 2022.10.19 KSW Memo measure 추가 */
           AND X.PROD_LINE      <> '-'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE 추가 :CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD)   ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* IF @p_is_debug = 1 SELECT '#PSI_GLOBAL_SMALL_AUTO_2' "#PSI_GLOBAL_SMALL_AUTO_2", * FROM #PSI_GLOBAL_SMALL_AUTO : 디버그 결과 집합 없음 */

        /* 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장 */
        /* IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_SMALL_AUTO') IS NOT NULL DROP TABLE #tmp_PSI_GLOBAL_SMALL_AUTO */
        DELETE FROM GT_XPGS_TMP_PSI_GLOBAL_SMALL_AUTO;

        /* 0 값을 플랜시작일자만 추가한다. - 모든 item 의 모든 measure */
        INSERT
          INTO GT_XPGS_TMP_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , X.MEASURE
             , Y.YYYYMMDD
             , 0                                   AS QTY  /* '0' */
             , X.SORT_ORDER_NO
             , X.COLUMN_LABEL_NAME
             , X.BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM (SELECT DISTINCT
                       SA.DIVISION_ID
                     , SA.OPERATION_GROUP
                     , SA.CELL_ITEM_ID
                     , SA.ITEM_ID
                     , SA.TO_SITE
                     , SA.PROJECT_CODE
                     , SA.TO_BOH_QTY
                     , SA.FROM_BOH_QTY
                     , SA.INCOTERMS
                     , SA.FROM_SITE
                     , SA.TRANSPORT_MODE
                     , SA.PROD_LINE
                     , SA.MEASURE
                     , SA.SORT_ORDER_NO
                     , SA.COLUMN_LABEL_NAME
                     , SA.BOD_ID
                     , SA.ATTRIBUTE1
                     , SA.ATTRIBUTE9
                  FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO SA
               ) X
             , (/* 364 DAYS */
                SELECT DISTINCT
                       XA.YYYYMMDD
                  FROM (/* --SELECT YYYYMMDD */
                        /* --  FROM #PSI_GLOBAL_SMALL C WITH(NOLOCK) */
                        /* --UNION ALL */
                        SELECT V_PLAN_START_YYYYMMDD AS YYYYMMDD
                          FROM DUAL
                         UNION ALL
                        SELECT V_PLAN_START_364      AS YYYYMMDD
                          FROM DUAL
                       ) XA
               ) Y  /* CROSS APPLY */
         WHERE 0 = 0
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INTO #tmp_PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' INTO #tmp_PSI_GLOBAL_SMALL_AUTO  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* 0 값(플랜시작일자만)이 추가된 작업용 테이블의 DATA 를 #PSI_GLOBAL_SMALL_AUTO 으로 복제 */
        DELETE FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO;

        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.TO_SITE
             , X.PROJECT_CODE
             , X.TO_BOH_QTY
             , X.FROM_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , X.MEASURE
             , X.YYYYMMDD
             , X.QTY
             , X.SORT_ORDER_NO
             , X.COLUMN_LABEL_NAME
             , X.BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM GT_XPGS_TMP_PSI_GLOBAL_SMALL_AUTO X
        ;

        /* IF @p_is_debug = 1 SELECT '#tmp_PSI_GLOBAL_SMALL_AUTO' "#tmp_PSI_GLOBAL_SMALL_AUTO", * FROM #tmp_PSI_GLOBAL_SMALL_AUTO X WITH (NOLOCK) ; : 디버그 결과 집합 없음 */

        /* IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_SMALL_AUTO') IS NOT NULL DROP TABLE #tmp_PSI_GLOBAL_SMALL_AUTO; */
        DELETE FROM GT_XPGS_TMP_PSI_GLOBAL_SMALL_AUTO;

        /* IF @P_IS_DEBUG = 1 SELECT 'MKT_FCST' "#ANL_SHIPMENT_PLAN_FG", * FROM #ANL_SHIPMENT_PLAN_FG WITH (NOLOCK) WHERE MEASURE = 'MKT_FCST' : 디버그 결과 집합 없음 */

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , A.CELL_ITEM_ID
                    , A.ITEM_ID
                    , A.TO_SITE
                    , '-'                          AS PROJECT_CODE  /* 중복방지 */
                    , A.TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , A.TRANSPORT_MODE
                    , A.PROD_LINE
                    , A.MEASURE
                    , A.YYYYMMDD
                    , SUM(A.QTY)                   AS QTY
                    , A.SORT_ORDER_NO
                    , A.COLUMN_LABEL_NAME
                    , A.BOD_ID
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE9
                 FROM GT_XPGS_PSI_GLOBAL_SMALL A  /* AS-IS #ANL_SHIPMENT_PLAN_FG */
                WHERE A.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'
                  AND A.MEASURE    = 'MKT_FCST'
                GROUP BY A.DIVISION_ID
                       , A.OPERATION_GROUP
                       , A.CELL_ITEM_ID
                       , A.ITEM_ID
                       , A.TO_SITE
                       , A.TO_BOH_QTY
                       , A.FROM_BOH_QTY
                       , A.INCOTERMS
                       , A.FROM_SITE
                       , A.TRANSPORT_MODE
                       , A.PROD_LINE
                       , A.MEASURE
                       , A.YYYYMMDD
                       , A.SORT_ORDER_NO
                       , A.COLUMN_LABEL_NAME
                       , A.BOD_ID
                       , A.ATTRIBUTE1
                       , A.ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.OPERATION_GROUP = Z.OPERATION_GROUP
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.FROM_SITE       = Z.FROM_SITE  /* 셀생산지수집관련(KSK, 250402) */
               AND X.TO_SITE         = Z.TO_SITE
               AND X.PROJECT_CODE    = Z.PROJECT_CODE
               AND X.INCOTERMS       = Z.INCOTERMS
               AND X.MEASURE         = Z.MEASURE
               AND X.YYYYMMDD        = Z.YYYYMMDD)
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' MEASURE MKT_FCST  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , A.CELL_ITEM_ID
                    , A.ITEM_ID
                    , A.TO_SITE
                    , A.PROJECT_CODE  /* 중복방지 */
                    , A.TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , A.TRANSPORT_MODE
                    , A.PROD_LINE
                    , A.MEASURE
                    , A.YYYYMMDD
                    , SUM(A.QTY)                   AS QTY
                    , A.SORT_ORDER_NO
                    , A.COLUMN_LABEL_NAME
                    , A.BOD_ID
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE9
                 FROM GT_XPGS_PSI_GLOBAL_SMALL A  /* AS-IS #ANL_SHIPMENT_PLAN_FG */
                WHERE A.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'
                  AND A.MEASURE   IN ('SHIP_PLAN', 'SHIP_REQ')
                GROUP BY A.DIVISION_ID
                       , A.OPERATION_GROUP
                       , A.CELL_ITEM_ID
                       , A.ITEM_ID
                       , A.TO_SITE
                       , A.PROJECT_CODE
                       , A.TO_BOH_QTY
                       , A.FROM_BOH_QTY
                       , A.INCOTERMS
                       , A.FROM_SITE
                       , A.TRANSPORT_MODE
                       , A.PROD_LINE
                       , A.MEASURE
                       , A.YYYYMMDD
                       , A.SORT_ORDER_NO
                       , A.COLUMN_LABEL_NAME
                       , A.BOD_ID
                       , A.ATTRIBUTE1
                       , A.ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.TO_SITE         = Z.TO_SITE
               AND X.FROM_SITE       = Z.FROM_SITE
               AND X.MEASURE         = Z.MEASURE
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.YYYYMMDD        = Z.YYYYMMDD
               AND X.INCOTERMS       = Z.INCOTERMS
               AND X.TRANSPORT_MODE  = Z.TRANSPORT_MODE
               AND X.PROJECT_CODE    = Z.PROJECT_CODE
               AND X.BOD_ID          = Z.BOD_ID  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
               AND X.MEASURE         = 'SHIP_PLAN')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #ANL_SHIPMENT_PLAN_FG  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , A.CELL_ITEM_ID
                    , A.ITEM_ID
                    , A.TO_SITE
                    , A.PROJECT_CODE
                    , A.TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , A.TRANSPORT_MODE
                    , A.PROD_LINE
                    , A.MEASURE
                    , A.YYYYMMDD
                    , SUM(A.QTY)                   AS QTY
                    , A.SORT_ORDER_NO
                    , A.COLUMN_LABEL_NAME
                    , A.BOD_ID
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE9
                 FROM GT_XPGS_PSI_GLOBAL_SMALL A  /* AS-IS #ANL_PRODUCTION_PLAN */
                WHERE A.ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'
                GROUP BY A.DIVISION_ID
                       , A.OPERATION_GROUP
                       , A.CELL_ITEM_ID
                       , A.ITEM_ID
                       , A.TO_SITE
                       , A.PROJECT_CODE
                       , A.TO_BOH_QTY
                       , A.FROM_BOH_QTY
                       , A.INCOTERMS
                       , A.FROM_SITE
                       , A.TRANSPORT_MODE
                       , A.PROD_LINE
                       , A.MEASURE
                       , A.YYYYMMDD
                       , A.SORT_ORDER_NO
                       , A.COLUMN_LABEL_NAME
                       , A.BOD_ID
                       , A.ATTRIBUTE1
                       , A.ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.OPERATION_GROUP = Z.OPERATION_GROUP
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.TO_SITE         = Z.TO_SITE
               AND X.FROM_SITE       = Z.FROM_SITE
               AND X.MEASURE         = Z.MEASURE
               AND X.YYYYMMDD        = Z.YYYYMMDD
               AND X.PROD_LINE       = Z.PROD_LINE)
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #ANL_PRODUCTION_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , A.CELL_ITEM_ID
                    , A.ITEM_ID
                    , A.TO_SITE
                    , A.PROJECT_CODE
                    , A.TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , A.TRANSPORT_MODE
                    , A.PROD_LINE
                    , A.MEASURE
                    , A.YYYYMMDD
                    , SUM(A.QTY)                   AS QTY
                    , A.SORT_ORDER_NO
                    , A.COLUMN_LABEL_NAME
                    , A.BOD_ID
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE9
                 FROM GT_XPGS_PSI_GLOBAL_SMALL A  /* AS-IS #ANL_SHIPMENT_PLAN_SEMI */
                WHERE A.ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                GROUP BY A.DIVISION_ID
                       , A.OPERATION_GROUP
                       , A.CELL_ITEM_ID
                       , A.ITEM_ID
                       , A.TO_SITE
                       , A.PROJECT_CODE
                       , A.TO_BOH_QTY
                       , A.FROM_BOH_QTY
                       , A.INCOTERMS
                       , A.FROM_SITE
                       , A.TRANSPORT_MODE
                       , A.PROD_LINE
                       , A.MEASURE
                       , A.YYYYMMDD
                       , A.SORT_ORDER_NO
                       , A.COLUMN_LABEL_NAME
                       , A.BOD_ID
                       , A.ATTRIBUTE1
                       , A.ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.OPERATION_GROUP = Z.OPERATION_GROUP
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.TO_SITE         = Z.TO_SITE
               AND X.FROM_SITE       = Z.FROM_SITE
               AND X.MEASURE         = Z.MEASURE
               AND X.YYYYMMDD        = Z.YYYYMMDD
               AND X.TRANSPORT_MODE  = Z.TRANSPORT_MODE
               AND X.BOD_ID          = Z.BOD_ID)
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;

        /* IF @P_IS_DEBUG = 1 SELECT '#SCP_PLN_PRODUCTION_PLAN' AS "#SCP_PLN_PRODUCTION_PLAN", * FROM #SCP_PLN_PRODUCTION_PLAN : 디버그 결과 집합 없음 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #ANL_SHIPMENT_PLAN_SEMI ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , A.CELL_ITEM_ID
                    , A.ITEM_ID
                    , A.TO_SITE
                    , A.PROJECT_CODE
                    , A.TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , A.TRANSPORT_MODE
                    , A.PROD_LINE
                    , A.MEASURE
                    , A.YYYYMMDD
                    , SUM(A.QTY)                   AS QTY
                    , A.SORT_ORDER_NO
                    , A.COLUMN_LABEL_NAME
                    , A.BOD_ID
                    , A.ATTRIBUTE1
                    , A.ATTRIBUTE9
                 FROM GT_XPGS_PSI_GLOBAL_SMALL A  /* AS-IS #SCP_PLN_PRODUCTION_PLAN */
                WHERE A.ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
                GROUP BY A.DIVISION_ID
                       , A.OPERATION_GROUP
                       , A.CELL_ITEM_ID
                       , A.ITEM_ID
                       , A.TO_SITE
                       , A.PROJECT_CODE
                       , A.TO_BOH_QTY
                       , A.FROM_BOH_QTY
                       , A.INCOTERMS
                       , A.FROM_SITE
                       , A.TRANSPORT_MODE
                       , A.PROD_LINE
                       , A.MEASURE
                       , A.YYYYMMDD
                       , A.SORT_ORDER_NO
                       , A.COLUMN_LABEL_NAME
                       , A.BOD_ID
                       , A.ATTRIBUTE1
                       , A.ATTRIBUTE9
              ) Z
           ON (    0 = 0
               AND X.OPERATION_GROUP = Z.OPERATION_GROUP
               AND X.ITEM_ID         = Z.ITEM_ID
               AND X.TO_SITE         = Z.TO_SITE
               AND X.FROM_SITE       = Z.FROM_SITE
               AND X.MEASURE         = Z.MEASURE
               AND X.YYYYMMDD        = Z.YYYYMMDD
               AND X.PROD_LINE       = Z.PROD_LINE)
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = Z.QTY
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Z.DIVISION_ID
                   , Z.OPERATION_GROUP
                   , Z.CELL_ITEM_ID
                   , Z.ITEM_ID
                   , Z.TO_SITE
                   , Z.PROJECT_CODE
                   , Z.TO_BOH_QTY
                   , Z.FROM_BOH_QTY
                   , Z.INCOTERMS
                   , Z.FROM_SITE
                   , Z.TRANSPORT_MODE
                   , Z.PROD_LINE
                   , Z.MEASURE
                   , Z.YYYYMMDD
                   , Z.QTY
                   , Z.SORT_ORDER_NO
                   , Z.COLUMN_LABEL_NAME
                   , Z.BOD_ID
                   , Z.ATTRIBUTE1
                   , Z.ATTRIBUTE9
                   )
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #SCP_PLN_PRODUCTION_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* INTRANSIT 반영 */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_XPGS_INTRANSIT;

        INSERT
          INTO GT_XPGS_INTRANSIT
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , INCOTERMS
             , TO_SITE
             , FROM_SITE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             , SITE_TYPE
             )
        SELECT X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , X.OPERATION_GROUP
             , X.ITEM_ID
             , X.INCOTERMS
             , X.TO_SITE
             , X.FROM_SITE
             , X.YYYYMMDD
             , SUM(X.QTY)                          AS QTY
             , X.ATTRIBUTE1
               /* TODO : SALES와 PLANT로 분리하여 처리토록 */
             , S.SITE_TYPE
          FROM (SELECT V_DIVISION_ID               AS DIVISION_ID
                     , V_PLAN_START_YYYYMMDD       AS PLAN_START_YYYYMMDD
                     , V_PLAN_TYPE                 AS PLAN_TYPE
                     , V_SEQ_TXT                   AS SEQ
                     , C.OPERATION_GROUP
                     , A.ITEM_ID
                     , FN_SCM_SPLIT(A.SITE_ID, 2, '~')                                      AS INCOTERMS
                     , (SUBSTR(A.SITE_ID, 1, FN_CHARINDEX_REV(A.SITE_ID, '~', 0) - 1))       AS TO_SITE
                     , (SUBSTR(A.LOT_ID, FN_CHARINDEX_REV(A.LOT_ID, '::', 0) + 2, 100))      AS FROM_SITE
                     , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')                                 AS YYYYMMDD
                     , (A.QTY)                     AS QTY
                     , 'TH_ENG_STOCK_PLAN_SN'      AS ATTRIBUTE1
                  FROM TH_ENG_STOCK_PLAN_SN A
                     , SCP_MST_FINAL_ITEM_V C
                 WHERE 1 = 1
                   AND A.ITEM_ID   = C.ITEM_ID
                   AND A.MASTER_ID = V_MASTER_ID
                   AND A.PLAN_ID   = V_ENGINE_PLAN_ID
                   AND A.DESCR     = 'INT'
                   /* --AND LEFT(A.SITE_ID, 6) = (SELECT TOP 1 S.SCM_SITE_ID FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.PLANT_ID = LEFT(A.SITE_ID, 6) AND S.PLANT_ID IS NOT NULL) -- 2021.11.16 SEMI PACK 출하계획생성오류 수정 */
               )            X
             , SCM_MST_SITE S  /* 250105(KSK) PLAN_TYPE 추가 */
         WHERE S.DIVISION_ID(+) = X.DIVISION_ID
           AND S.SCM_SITE_ID(+) = X.TO_SITE
         GROUP BY X.DIVISION_ID
                , X.PLAN_START_YYYYMMDD
                , X.PLAN_TYPE
                , X.SEQ
                , X.OPERATION_GROUP
                , X.ITEM_ID
                , X.INCOTERMS
                , X.TO_SITE
                , S.SITE_TYPE
                , X.FROM_SITE
                /* --,MEASURE */
                , X.YYYYMMDD
                , X.ATTRIBUTE1
        ;

        /* IF @p_is_debug = 1 SELECT '#INTRANSIT' "#INTRANSIT", * FROM #INTRANSIT : 디버그 결과 집합 없음 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## INTO #INTRANSIT ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' INTO #INTRANSIT ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , CAST(NULL AS VARCHAR2(100 CHAR)) AS CELL_ITEM_ID  /* AS-IS '' */
                    , A.ITEM_ID
                    , A.TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'INTRANSIT_ETA'              AS MEASURE
                    , A.YYYYMMDD
                    , SUM(A.QTY)                   AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_ANL_SHIPMENT_PLAN_FG'   AS ATTRIBUTE1
                 FROM GT_XPGS_INTRANSIT A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'INTRANSIT_ETA'
                      )                 B
                WHERE 1 = 1
                  AND A.SITE_TYPE = 'SALES'
                GROUP BY A.DIVISION_ID
                       , A.OPERATION_GROUP
                       , A.ITEM_ID
                       , A.TO_SITE
                       , A.INCOTERMS
                       , A.FROM_SITE
                       , A.YYYYMMDD
                       , B.SORT_ORDER_NO
                       , B.COLUMN_LABEL_NAME
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.INCOTERMS = Y.INCOTERMS
               AND X.TO_SITE   = Y.TO_SITE
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'INTRANSIT_ETA')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.CELL_ITEM_ID
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   , Y.ATTRIBUTE1
                   )
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #INTRANSIT INTRANSIT_ETA ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* 2022.05.17 중복오류 수정 */
        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT XX.DIVISION_ID
                    , XX.OPERATION_GROUP
                    , XX.CELL_ITEM_ID
                    , XX.ITEM_ID
                    , XX.TO_SITE
                    , XX.PROJECT_CODE
                    , XX.TO_BOH_QTY
                    , XX.FROM_BOH_QTY
                    , XX.INCOTERMS
                    , XX.FROM_SITE
                    , XX.TRANSPORT_MODE
                    , XX.PROD_LINE
                    , XX.MEASURE
                    , XX.YYYYMMDD
                    , SUM(XX.QTY)                  AS QTY
                    , XX.SORT_ORDER_NO
                    , XX.COLUMN_LABEL_NAME
                    , XX.BOD_ID
                    , XX.ATTRIBUTE1
                 FROM (SELECT A.DIVISION_ID
                            , A.OPERATION_GROUP
                            , CAST(NULL AS VARCHAR2(100 CHAR)) AS CELL_ITEM_ID  /* AS-IS '' */
                            , A.ITEM_ID
                            , A.TO_SITE
                            , '-'                  AS PROJECT_CODE
                            , 0                    AS TO_BOH_QTY
                            , 0                    AS FROM_BOH_QTY
                            , '-'                  AS INCOTERMS
                            , A.FROM_SITE
                            , '-'                  AS TRANSPORT_MODE
                            , '-'                  AS PROD_LINE
                            , 'SEMI_INTRANSIT_ETA' AS MEASURE
                            , A.YYYYMMDD
                            , SUM(A.QTY)           AS QTY
                            , B.SORT_ORDER_NO
                            , B.COLUMN_LABEL_NAME
                            , '-'                  AS BOD_ID
                            , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
                         FROM GT_XPGS_INTRANSIT A
                            , (SELECT SA.SORT_ORDER_NO
                                    , SA.COLUMN_LABEL_NAME
                                 FROM GT_XPGS_MEASURE SA
                                WHERE SA.COLUMN_NAME = 'SEMI_INTRANSIT_ETA'
                              )                 B
                        WHERE 1 = 1
                          AND A.SITE_TYPE = 'PLANT'
                        GROUP BY A.DIVISION_ID
                               , A.OPERATION_GROUP
                               , A.ITEM_ID
                               , A.TO_SITE
                               , A.INCOTERMS
                               , A.FROM_SITE
                               , A.YYYYMMDD
                               , B.SORT_ORDER_NO
                               , B.COLUMN_LABEL_NAME
                      ) XX
                GROUP BY XX.DIVISION_ID
                       , XX.OPERATION_GROUP
                       , XX.CELL_ITEM_ID
                       , XX.ITEM_ID
                       , XX.TO_SITE
                       , XX.PROJECT_CODE
                       , XX.TO_BOH_QTY
                       , XX.FROM_BOH_QTY
                       , XX.INCOTERMS
                       , XX.FROM_SITE
                       , XX.TRANSPORT_MODE
                       , XX.PROD_LINE
                       , XX.MEASURE
                       , XX.YYYYMMDD
                       , XX.SORT_ORDER_NO
                       , XX.COLUMN_LABEL_NAME
                       , XX.BOD_ID
                       , XX.ATTRIBUTE1
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.TO_SITE   = Y.TO_SITE
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'SEMI_INTRANSIT_ETA')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.CELL_ITEM_ID
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   , Y.ATTRIBUTE1
                   )
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #INTRANSIT SEMI_INTRANSIT_ETA ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L2913~L2924 (원문 그대로 보존)
                            --UPDATE X
                            --   SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
                            --  FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                            --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,TO_SITE,INCOTERMS, SUM(Y.QTY) AS FROM_BOH_QTY
                            --                FROM #INTRANSIT Y
                            --               GROUP BY ITEM_ID, FROM_SITE,TO_SITE,INCOTERMS
                            --            )  Z
                            --     ON X.ITEM_ID    = Z.ITEM_ID
                            --    AND X.INCOTERMS  = Z.INCOTERMS
                            --    AND X.FROM_SITE  = Z.FROM_SITE
                            --    AND X.TO_SITE    = Z.TO_SITE
                            --    AND X.MEASURE    = 'INTRANSIT'
        */

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , CAST(NULL AS VARCHAR2(100 CHAR)) AS CELL_ITEM_ID  /* AS-IS '' */
                    , A.ITEM_ID
                    , A.TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , SUM(A.QTY)                   AS FROM_BOH_QTY
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'INTRANSIT'                  AS MEASURE
                    , 0                            AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_ANL_SHIPMENT_PLAN_FG'   AS ATTRIBUTE1
                 FROM GT_XPGS_INTRANSIT A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'INTRANSIT'
                      )                 B
                WHERE 1 = 1
                GROUP BY A.DIVISION_ID
                       , A.OPERATION_GROUP
                       , A.ITEM_ID
                       , A.TO_SITE
                       , A.INCOTERMS
                       , A.FROM_SITE
                       , B.SORT_ORDER_NO
                       , B.COLUMN_LABEL_NAME
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.INCOTERMS = Y.INCOTERMS
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.TO_SITE   = Y.TO_SITE
               AND X.MEASURE   = 'INTRANSIT')
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.CELL_ITEM_ID
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , V_PLAN_START_YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   , Y.ATTRIBUTE1
                   )
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #INTRANSIT INTRANSIT ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L3023~L3034 (원문 그대로 보존)
                            --UPDATE X
                            --   SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
                            --  FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                            --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,TO_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                            --                FROM #INTRANSIT Y
                            --               GROUP BY ITEM_ID, FROM_SITE,TO_SITE
                            --            )  Z
                            --     ON X.ITEM_ID    = Z.ITEM_ID
                            --    AND X.FROM_SITE  = Z.FROM_SITE
                            --    AND X.TO_SITE    = Z.TO_SITE
                            --    AND X.MEASURE    = 'SEMI_INTRANSIT'
                           -- 중복오류 수정 :: 2022.05.17
        */
        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT XX.DIVISION_ID
                    , XX.OPERATION_GROUP
                    , XX.CELL_ITEM_ID
                    , XX.ITEM_ID
                    , XX.TO_SITE
                    , XX.PROJECT_CODE
                    , XX.TO_BOH_QTY
                    , SUM(XX.FROM_BOH_QTY)         AS FROM_BOH_QTY
                    , XX.INCOTERMS
                    , XX.FROM_SITE
                    , XX.TRANSPORT_MODE
                    , XX.PROD_LINE
                    , XX.MEASURE
                    , XX.QTY
                    , XX.SORT_ORDER_NO
                    , XX.COLUMN_LABEL_NAME
                    , XX.BOD_ID
                    , XX.ATTRIBUTE1
                 FROM (SELECT A.DIVISION_ID
                            , A.OPERATION_GROUP
                            , CAST(NULL AS VARCHAR2(100 CHAR)) AS CELL_ITEM_ID  /* AS-IS '' */
                            , A.ITEM_ID
                            , A.TO_SITE
                            , '-'                  AS PROJECT_CODE
                            , 0                    AS TO_BOH_QTY
                            , SUM(A.QTY)           AS FROM_BOH_QTY
                            , '-'                  AS INCOTERMS
                            , A.FROM_SITE
                            , '-'                  AS TRANSPORT_MODE
                            , '-'                  AS PROD_LINE
                            , 'SEMI_INTRANSIT'     AS MEASURE
                            , 0                    AS QTY
                            , B.SORT_ORDER_NO
                            , B.COLUMN_LABEL_NAME
                            , '-'                  AS BOD_ID
                            , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
                         FROM GT_XPGS_INTRANSIT A
                            , (SELECT SA.SORT_ORDER_NO
                                    , SA.COLUMN_LABEL_NAME
                                 FROM GT_XPGS_MEASURE SA
                                WHERE SA.COLUMN_NAME = 'SEMI_INTRANSIT'
                              )                 B
                        WHERE 1 = 1
                        GROUP BY A.DIVISION_ID
                               , A.OPERATION_GROUP
                               , A.ITEM_ID
                               , A.TO_SITE
                               , A.INCOTERMS
                               , A.FROM_SITE
                               , B.SORT_ORDER_NO
                               , B.COLUMN_LABEL_NAME
                      ) XX
                GROUP BY XX.DIVISION_ID
                       , XX.OPERATION_GROUP
                       , XX.CELL_ITEM_ID
                       , XX.ITEM_ID
                       , XX.TO_SITE
                       , XX.PROJECT_CODE
                       , XX.TO_BOH_QTY
                       , XX.INCOTERMS
                       , XX.FROM_SITE
                       , XX.TRANSPORT_MODE
                       , XX.PROD_LINE
                       , XX.MEASURE
                       , XX.QTY
                       , XX.SORT_ORDER_NO
                       , XX.COLUMN_LABEL_NAME
                       , XX.BOD_ID
                       , XX.ATTRIBUTE1
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.INCOTERMS = Y.INCOTERMS
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.TO_SITE   = Y.TO_SITE
               AND X.MEASURE   = 'SEMI_INTRANSIT')
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , CELL_ITEM_ID
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.CELL_ITEM_ID
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , V_PLAN_START_YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   , Y.ATTRIBUTE1
                   )
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #INTRANSIT SEMI_INTRANSIT ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* CELL_FOR_FORM_END */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN') IS NOT NULL DROP TABLE #PLN_TH_ENG_STOCK_PLAN */
        DELETE FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN;

        INSERT
          INTO GT_XPGS_PLN_TH_ENG_STOCK_PLAN
             ( DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY
             , DESCR
             )
        SELECT SUBSTR(A.MASTER_ID, 1, 2)                              AS DIVISION_ID
             , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)        AS FROM_SITE
             , A.ITEM_ID
             , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')                  AS YYYYMMDD
             , SUM(NVL(A.QTY, 0))                                     AS QTY
             , A.DESCR
          FROM SCP_PLN_TH_ENG_STOCK_PLAN A
         WHERE 1 = 1
           AND A.MASTER_ID = V_MASTER_ID
           AND A.PLAN_ID   = V_ENGINE_PLAN_ID
           /* --        AND A.LOT_ID LIKE 'FOR%' */
         GROUP BY SUBSTR(A.MASTER_ID, 1, 2)
                , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
                , A.ITEM_ID
                , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')
                , A.DESCR
        ;

        V_LOG_MESSAGE := '########## INTO #PLN_TH_ENG_STOCK_PLAN ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM SCP_PLN_TH_ENG_STOCK_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'A'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'CELL_FOR_FORM_END'          AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE1  /* '' 중복방지 */
                    , CAST(NULL AS VARCHAR2(150 CHAR)) AS ATTRIBUTE9  /* '' 중복방지 */
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , Y.YYYYMMDD
                            , SUM(Y.QTY)           AS QTY
                         FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR LIKE 'FOR%'
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'CELL_FOR_FORM_END'
                      ) B
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'CELL_FOR_FORM_END')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   , Y.ATTRIBUTE1
                   , Y.ATTRIBUTE9
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #PLN_TH_ENG_STOCK_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        UPDATE GT_XPGS_PSI_GLOBAL_SMALL_AUTO
           SET ATTRIBUTE1 = NULL  /* '' */
             , ATTRIBUTE9 = NULL  /* '' */
         WHERE MEASURE    = 'CELL_FOR_FORM_END'
        ;

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' #PSI_GLOBAL_SMALL_AUTO  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'A'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'CELL_FORM_PROGRESS'         AS MEASURE
                    , 0                            AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY)           AS FROM_BOH_QTY
                         FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'FOR'
                          /* --                 WHERE YYYYMMDD = @p_plan_start_yyyymmdd */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'CELL_FORM_PROGRESS'
                      ) B
              ) Y
           ON (    X.DIVISION_ID = Y.DIVISION_ID
               AND X.ITEM_ID     = Y.ITEM_ID
               AND X.FROM_SITE   = Y.FROM_SITE
               AND X.MEASURE     = 'CELL_FORM_PROGRESS')
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , V_PLAN_START_YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' CELL_FORM_PROGRESS  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가 - start */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_INSP') IS NOT NULL DROP TABLE #PLN_TH_ENG_STOCK_PLAN_INSP */
        DELETE FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN_INSP;

        INSERT
          INTO GT_XPGS_PLN_TH_ENG_STOCK_PLAN_INSP
             ( DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY
             , DESCR
             , INSP_TYPE
             )
        SELECT SUBSTR(A.MASTER_ID, 1, 2)                              AS DIVISION_ID
             , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)        AS FROM_SITE
             , A.ITEM_ID
             , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')                  AS YYYYMMDD
             , SUM(NVL(A.QTY, 0))                                     AS QTY
             , A.DESCR
             , A.INSP_TYPE
          FROM SCP_PLN_TH_ENG_STOCK_PLAN A
         WHERE 1 = 1
           AND A.MASTER_ID = V_MASTER_ID
           AND A.PLAN_ID   = V_ENGINE_PLAN_ID
         GROUP BY SUBSTR(A.MASTER_ID, 1, 2)
                , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
                , A.ITEM_ID
                , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD')
                , A.DESCR
                , A.INSP_TYPE
        ;

        V_LOG_MESSAGE := '########## INTO #PLN_TH_ENG_STOCK_PLAN_INSP ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' #PLN_TH_ENG_STOCK_PLAN_INSP  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L3440~L3453 (원문 그대로 보존)
                       -- PACK BOH (Hold), 전진검사 HOLD + 전진검사 이외 HOLD
                       --     UPDATE X
                       --        SET X.QTY = ISNULL(Z.QTY,0)
                       --       FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                       --       INNER JOIN (SELECT ITEM_ID, FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
                       --                    FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
                       --                   WHERE (INSP_TYPE = 'INSP_HOLD' OR DESCR LIKE '%HOLD')
                                            --AND NOT INSP_TYPE = 'INSP_PRE'
                       --                   GROUP BY ITEM_ID, FROM_SITE,YYYYMMDD
                       --                  ) Z
                       --          ON X.ITEM_ID    = Z.ITEM_ID
                       --         AND X.FROM_SITE  = Z.FROM_SITE
                       --         AND X.YYYYMMDD   = Z.YYYYMMDD
                       --         AND X.MEASURE    = 'PACK_BOH_HOLD'
        */

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'P'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'PACK_BOH_HOLD'              AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_ANL_PRODUCTION_PLAN'    AS ATTRIBUTE1  /* 중복방지 */
                      /* AS-IS ISNULL((SELECT TOP 1 ATTRIBUTE9 ... AND ATTRIBUTE9 IS NOT NULL), '') */
                    , (SELECT SB.ATTRIBUTE9
                         FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO SB
                        WHERE SB.ITEM_ID  = A.ITEM_ID
                          AND SB.MEASURE IN ('PACK_PROD', 'CELL_PROD')
                          AND SB.ATTRIBUTE9 IS NOT NULL
                          AND ROWNUM      = 1)     AS ATTRIBUTE9
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , Y.YYYYMMDD
                            , SUM(Y.QTY)           AS QTY
                         FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN_INSP Y
                        WHERE (Y.INSP_TYPE = 'INSP_HOLD' OR Y.DESCR LIKE '%HOLD')
                          AND NOT Y.INSP_TYPE = 'INSP_PRE'
                          AND (SELECT SC.OPERATION_GROUP
                                 FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO SC
                                WHERE SC.ITEM_ID = Y.ITEM_ID
                                  AND SC.MEASURE = 'PACK_PROD'
                                  AND ROWNUM     = 1) = 'P'  /* CELL 이 함께 존재하므로 CELL을 제외한다. */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'PACK_BOH_HOLD'
                      ) B
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'PACK_BOH_HOLD')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   , Y.ATTRIBUTE1
                   , Y.ATTRIBUTE9
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #PLN_TH_ENG_STOCK_PLAN_INSP PACK_BOH_HOLD  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L3548~L3560 (원문 그대로 보존)
                       -- Pack BOH(Expected Inspection date)
                            --UPDATE X
                            --   SET X.QTY = ISNULL(Z.QTY,0)
                            --  FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                            --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
                            --               FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
                            --              WHERE INSP_TYPE = 'INSP_PRE'
                            --              GROUP BY ITEM_ID, FROM_SITE,YYYYMMDD
                            --             ) Z
                            --     ON X.ITEM_ID    = Z.ITEM_ID
                            --    AND X.FROM_SITE  = Z.FROM_SITE
                            --    AND X.YYYYMMDD   = Z.YYYYMMDD
                            --    AND X.MEASURE    = 'PACK_BOH_EXP_INSP_DATE'
        */

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'P'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'PACK_BOH_EXP_INSP_DATE'     AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , Y.YYYYMMDD
                            , SUM(Y.QTY)           AS QTY
                         FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN_INSP Y
                        WHERE Y.INSP_TYPE = 'INSP_PRE'
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'PACK_BOH_EXP_INSP_DATE'
                      ) B
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'PACK_BOH_EXP_INSP_DATE')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #PLN_TH_ENG_STOCK_PLAN_INSP PACK_BOH_EXP_INSP_DATE  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정 - start */
        UPDATE GT_XPGS_PSI_GLOBAL_SMALL_AUTO
           SET ATTRIBUTE1 = NULL  /* '' */
             , ATTRIBUTE9 = NULL  /* '' */
         WHERE MEASURE    = 'PACK_BOH_EXP_INSP_DATE'
        ;

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' PACK_BOH_EXP_INSP_DATE  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정 - end */

        /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가 - end */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* CELL_FORM_HOLD_UNDER 추가 */
        /* [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_AGING_V') IS NOT NULL DROP TABLE #tmp_SCM_DNM_STOCK_AGING_V */
        DELETE FROM GT_XPGS_TMP_SCM_DNM_STOCK_AGING_V;

        INSERT
          INTO GT_XPGS_TMP_SCM_DNM_STOCK_AGING_V
             ( FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY
             )
        SELECT A.SCM_SITE_ID                                          AS FROM_SITE
             , A.ITEM_ID
             , (CASE WHEN A.UNHOLD_EXP_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                     ELSE TO_CHAR(A.UNHOLD_EXP_DATE, 'YYYYMMDD')
                END)                                                  AS YYYYMMDD
             , SUM(A.QTY)                                             AS QTY
          FROM SCM_DNM_STOCK_AGING_V A
         WHERE A.CUTOFF_DATE     = TO_DATE(V_CUTOFF_DATE, 'YYYYMMDD')
           AND A.DIVISION_ID     = V_DIVISION_ID  /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
           AND A.WIPHOLD_YN      = 'Y'
           AND A.UNHOLD_EXP_DATE IS NOT NULL
         GROUP BY A.SCM_SITE_ID
                , A.ITEM_ID
                , (CASE WHEN A.UNHOLD_EXP_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                        ELSE TO_CHAR(A.UNHOLD_EXP_DATE, 'YYYYMMDD')
                   END)
        ;

        V_LOG_MESSAGE := '########## INTO  #tmp_SCM_DNM_STOCK_AGING_V  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM SCM_DNM_STOCK_AGING_V  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L3703~L3710 (원문 그대로 보존)
                            --UPDATE X
                            --   SET X.QTY = Z.QTY
                            --  FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                            --  INNER JOIN #tmp_SCM_DNM_STOCK_AGING_V  Z
                            --     ON X.ITEM_ID    = Z.ITEM_ID
                            --    AND X.FROM_SITE  = Z.FROM_SITE
                            --    AND X.YYYYMMDD   = Z.YYYYMMDD
                            --    AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
        */

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'A'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER'       AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_PLN_PRODUCTION_PLAN'    AS ATTRIBUTE1  /* 중복방지 */
                    , 'F6000'                      AS ATTRIBUTE9  /* 중복방지 */
                 FROM GT_XPGS_TMP_SCM_DNM_STOCK_AGING_V A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'CELL_FORM_HOLD_UNDER'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
                  AND A.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_TO_YYYYMMDD  /* 플랜구간만 유효 :: 2022.08.30 KSW Cell 재고 개선건 */
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'CELL_FORM_HOLD_UNDER')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   , Y.ATTRIBUTE1
                   , Y.ATTRIBUTE9
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #tmp_SCM_DNM_STOCK_AGING_V  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        UPDATE GT_XPGS_PSI_GLOBAL_SMALL_AUTO
           SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
             , ATTRIBUTE9 = 'F6000'
         WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER'
           /* 아래조건 전체를 'CELL_FORM_HOLD_UNDER'메저의 AND 조건으로 설정 */
           AND (ATTRIBUTE1 IS NULL OR ATTRIBUTE9 IS NULL)  /* ISNULL(ATTRIBUTE1, '') = '' OR ISNULL(ATTRIBUTE9, '') = '' */
        ;

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' CELL_FORM_HOLD_UNDER  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* BOH */

        /* AS-IS L3824~L3835 (원문 그대로 보존)
                            -- 보류중 해제일자가 없는수량
                             --UPDATE X
                             --  SET X.FROM_BOH_QTY = Z.QTY
                             -- FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                             -- INNER JOIN (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
                             --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                             --              WHERE DESCR ='FOR_HOLD'
                             --              GROUP BY FROM_SITE, ITEM_ID
                             --           )  Z
                             --    ON X.ITEM_ID    = Z.ITEM_ID
                             --   AND X.FROM_SITE  = Z.FROM_SITE
                             --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
        */

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'A'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER'       AS MEASURE
                    , 0                            AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                      /* AS-IS L3854~L3858 (원문 그대로 보존)
                                                 --FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS FROM_BOH_QTY
                               --                           FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                               --                          WHERE DESCR ='FOR_HOLD'
                               --                          GROUP BY FROM_SITE, ITEM_ID
                                                 --     ) A,
                      */
                 FROM (SELECT Y.FROM_SITE
                            , Y.ITEM_ID
                            , SUM(Y.QTY)           AS FROM_BOH_QTY
                         FROM GT_XPGS_TMP_SCM_DNM_STOCK_AGING_V Y
                        WHERE (   Y.YYYYMMDD < V_PLAN_START_YYYYMMDD
                               OR Y.YYYYMMDD > V_TO_YYYYMMDD)  /* (플랜범위이전 + 플랜범위초과) 영역 :: 2022.08.30 KSW Cell 재고 개선건 */
                        GROUP BY Y.FROM_SITE
                               , Y.ITEM_ID
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'CELL_FORM_HOLD_UNDER'
                      ) B
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.MEASURE   = 'CELL_FORM_HOLD_UNDER')
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , V_PLAN_START_YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #tmp_SCM_DNM_STOCK_AGING_V CELL_FORM_HOLD_UNDER  ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L3926~L4008 (원문 그대로 보존)
           -- 2022.08.30   KSW            Cell 재고 개선건 - 주석처리
               --              -- 보류중 해제일자가 없는수량
               --              -- BOH
               --              --UPDATE X
               --              --  SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Z.QTY
               --              -- FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
               --              -- INNER JOIN (
               --              --           SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
               --              --               FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
               --              --              GROUP BY FROM_SITE, ITEM_ID
               --              --              ) Z
               --              --    ON X.ITEM_ID    = Z.ITEM_ID
               --              --   AND X.FROM_SITE  = Z.FROM_SITE
               --              --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'

                           --MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                           --USING (SELECT @p_division_id AS DIVISION_ID
                           --            ,'A'             AS OPERATION_GROUP
                           --            ,A.ITEM_ID
                           --            ,'-'             AS TO_SITE
                           --            ,'-'             AS PROJECT_CODE
                           --            ,0               AS TO_BOH_QTY
                           --            ,ISNULL(A.QTY,0) AS FROM_BOH_QTY
                           --            ,'-'             AS INCOTERMS
                           --            ,A.FROM_SITE
                           --            ,'-'             AS TRANSPORT_MODE
                           --            ,'-'             AS PROD_LINE
                           --            ,'CELL_FORM_HOLD_UNDER' AS MEASURE
                           --            ,0               AS QTY
                           --            ,B.SORT_ORDER_NO
                           --            ,B.COLUMN_LABEL_NAME
                           --            ,'-'            AS BOD_ID
                           --        FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
               --                             FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
               --                            GROUP BY FROM_SITE, ITEM_ID) A,
                           --             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') B
                           --       WHERE A.FROM_SITE IS NOT NULL
                           --      ) AS Y
                           --ON  X.ITEM_ID    = Y.ITEM_ID
               --            AND X.FROM_SITE  = Y.FROM_SITE
               --            AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
                           --WHEN MATCHED  THEN
                           --UPDATE
                           --   SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Y.FROM_BOH_QTY
                           --WHEN NOT MATCHED  THEN
                           --INSERT (
                           --         DIVISION_ID
                           --        ,OPERATION_GROUP
                           --        ,ITEM_ID
                           --        ,TO_SITE
                           --        ,PROJECT_CODE
                           --        ,TO_BOH_QTY
                           --        ,FROM_BOH_QTY
                           --        ,INCOTERMS
                           --        ,FROM_SITE
                           --        ,TRANSPORT_MODE
                           --        ,PROD_LINE
                           --        ,MEASURE
                           --        ,YYYYMMDD
                           --        ,QTY
                           --        ,SORT_ORDER_NO
                           --        ,COLUMN_LABEL_NAME
                           --        ,BOD_ID
                           --       )
                           --VALUES (
                           --         Y.DIVISION_ID
                           --        ,Y.OPERATION_GROUP
                           --        ,Y.ITEM_ID
                           --        ,Y.TO_SITE
                           --        ,Y.PROJECT_CODE
                           --        ,Y.TO_BOH_QTY
                           --        ,Y.FROM_BOH_QTY
                           --        ,Y.INCOTERMS
                           --        ,Y.FROM_SITE
                           --        ,Y.TRANSPORT_MODE
                           --        ,Y.PROD_LINE
                           --        ,Y.MEASURE
                           --        ,@p_plan_start_yyyymmdd
                           --        ,Y.QTY
                           --        ,Y.SORT_ORDER_NO
                           --        ,Y.COLUMN_LABEL_NAME
                           --        ,Y.BOD_ID
                           --       );
        */

        /* IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_AGING_V2') IS NOT NULL DROP TABLE #tmp_SCM_DNM_STOCK_AGING_V2
           #tmp_SCM_DNM_STOCK_AGING_V2 는 아래 MERGE 한 곳에서만 쓰여 인라인 뷰로 옮김 (--AND UNHOLD_EXP_DATE IS NOT NULL) */

        V_LOG_MESSAGE := '########## INTO #tmp_SCM_DNM_STOCK_AGING_V2  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM SCM_DNM_STOCK_AGING_V ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L4041~L4054 (원문 그대로 보존)
                             --aging에서 hold 수량중 available_date or 예상해제일 늦은날짜 기준
                             --UPDATE X
                             --  SET X.QTY = Z.QTY
                             -- FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                             -- INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                             --               FROM #tmp_SCM_DNM_STOCK_AGING_V2 Y  WITH (NOLOCK)
                             --              WHERE 0 = 0
                             --              --AND DESCR ='WH_HOLD'
                             --              GROUP BY ITEM_ID,FROM_SITE,Y.YYYYMMDD
                             --           )  Z
                             --    ON X.ITEM_ID    = Z.ITEM_ID
                             --   AND X.FROM_SITE  = Z.FROM_SITE
                             --   AND X.YYYYMMDD   = Z.YYYYMMDD
                             --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
        */

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'A'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'CELL_FORM_HOLD_UNDER_AVAILABLE' AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                    , 'SCP_PLN_PRODUCTION_PLAN'    AS ATTRIBUTE1  /* 중복방지 */
                    , 'F6000'                      AS ATTRIBUTE9  /* 중복방지 */
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY)           AS QTY
                            , Y.YYYYMMDD
                         FROM (SELECT SC.SCM_SITE_ID                       AS FROM_SITE
                                    , SC.ITEM_ID
                                    , (CASE WHEN SC.AVAILABLE_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                                            ELSE TO_CHAR(SC.AVAILABLE_DATE, 'YYYYMMDD')
                                       END)                                AS YYYYMMDD
                                    , SUM(SC.QTY)                          AS QTY
                                 FROM SCM_DNM_STOCK_AGING_V SC
                                WHERE SC.CUTOFF_DATE = TO_DATE(V_CUTOFF_DATE, 'YYYYMMDD')
                                  AND SC.DIVISION_ID = V_DIVISION_ID  /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
                                  AND SC.WIPHOLD_YN  = 'Y'
                                  /* --AND UNHOLD_EXP_DATE IS NOT NULL */
                                GROUP BY SC.SCM_SITE_ID
                                       , SC.ITEM_ID
                                       , (CASE WHEN SC.AVAILABLE_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') THEN V_PLAN_START_YYYYMMDD
                                               ELSE TO_CHAR(SC.AVAILABLE_DATE, 'YYYYMMDD')
                                          END)
                              ) Y  /* AS-IS #tmp_SCM_DNM_STOCK_AGING_V2 */
                        WHERE 0 = 0
                          /* --AND DESCR ='WH_HOLD' */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'CELL_FORM_HOLD_UNDER_AVAILABLE')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   , ATTRIBUTE1
                   , ATTRIBUTE9
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   , Y.ATTRIBUTE1
                   , Y.ATTRIBUTE9
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #tmp_SCM_DNM_STOCK_AGING_V2 CELL_FORM_HOLD_UNDER_AVAILABLE ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        UPDATE GT_XPGS_PSI_GLOBAL_SMALL_AUTO
           SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
             , ATTRIBUTE9 = 'F6000'
         WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
           /* 특정메저에서만 작동하도록 괄호조건 추가(KSK, 2024-05-21) */
           AND (ATTRIBUTE1 IS NULL OR ATTRIBUTE9 IS NULL)  /* ISNULL(ATTRIBUTE1, '') = '' OR ISNULL(ATTRIBUTE9, '') = '' */
        ;

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' CELL_FORM_HOLD_UNDER_AVAILABLE ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* CELL_FORM_HOLD_AFTER 추가 */
        /* [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS) */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* AS-IS L4178~L4189 (원문 그대로 보존)
                            --UPDATE X
                            --   SET X.QTY = Z.QTY
                            --  FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                            --  INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                            --                FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                            --                WHERE DESCR ='WH_HOLD'
                            --               GROUP BY ITEM_ID, FROM_SITE, YYYYMMDD
                            --            )  Z
                            --     ON X.ITEM_ID    = Z.ITEM_ID
                            --    AND X.FROM_SITE  = Z.FROM_SITE
                            --    AND X.YYYYMMDD   = Z.YYYYMMDD
                            --    AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
        */

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'A'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'CELL_FORM_HOLD_AFTER'       AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY)           AS QTY
                            , Y.YYYYMMDD
                         FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'WH_HOLD'
                          AND (SELECT SC.OPERATION_GROUP
                                 FROM SCM_MST_SITE SC
                                WHERE SC.SCM_SITE_ID = Y.FROM_SITE) = 'A'  /* CELL 생산 사이트 한정 */
                          AND Y.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_TO_YYYYMMDD  /* 플랜구간만 유효 :: 2022.08.30 KSW Cell 재고 개선건 */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'CELL_FORM_HOLD_AFTER'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'CELL_FORM_HOLD_AFTER')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' #PLN_TH_ENG_STOCK_PLAN CELL_FORM_HOLD_AFTER ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L4280~L4291 (원문 그대로 보존)
                             -- -- 보류중 해제일자가 없는수량
                             --UPDATE X
                             --  SET X.FROM_BOH_QTY = Z.QTY
                             -- FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                             -- INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY
                             --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                             --              WHERE DESCR ='WH_HOLD'
                             --              GROUP BY ITEM_ID,FROM_SITE
                             --           )  Z
                             --    ON X.ITEM_ID    = Z.ITEM_ID
                             --   AND X.FROM_SITE  = Z.FROM_SITE
                             --   AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
        */

        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'A'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'CELL_FORM_HOLD_AFTER'       AS MEASURE
                    , 0                            AS QTY
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY)           AS FROM_BOH_QTY
                         FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'WH_HOLD'
                          AND (SELECT SC.OPERATION_GROUP
                                 FROM SCM_MST_SITE SC
                                WHERE SC.SCM_SITE_ID = Y.FROM_SITE) = 'A'  /* CELL 생산 사이트 한정 */
                          AND (   Y.YYYYMMDD < V_PLAN_START_YYYYMMDD
                               OR Y.YYYYMMDD > V_TO_YYYYMMDD)  /* (플랜범위이전 + 플랜범위초과) 영역 :: 2022.08.30 KSW Cell 재고 개선건 */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                            , SA.COLUMN_LABEL_NAME
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'CELL_FORM_HOLD_AFTER'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.MEASURE   = 'CELL_FORM_HOLD_AFTER')
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , V_PLAN_START_YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' #PLN_TH_ENG_STOCK_PLAN CELL_FORM_HOLD_AFTER ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        UPDATE GT_XPGS_PSI_GLOBAL_SMALL_AUTO
           SET ATTRIBUTE1 = NULL  /* '' */
             , ATTRIBUTE9 = NULL  /* '' */
         WHERE MEASURE    = 'CELL_FORM_HOLD_AFTER'
        ;

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' CELL_FORM_HOLD_AFTER ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* * 2022.08.30 KSW Cell 재고 개선건 */
        /* * 2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 -- start */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* PACK_CELL_BOH 가 존재하는 모델을 참고로 해서 PACK_CELL_BOH_HOLD MEASURE 생성 */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             )
        SELECT DISTINCT
               Y.DIVISION_ID
             , Y.OPERATION_GROUP
             , Y.ITEM_ID
             , Y.TO_SITE
             , Y.PROJECT_CODE
             , Y.TO_BOH_QTY
             , Y.FROM_BOH_QTY
             , Y.INCOTERMS
             , Y.FROM_SITE
             , Y.TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , 'PACK_CELL_BOH_HOLD'                AS MEASURE
             , Y.YYYYMMDD
             , 0                                   AS QTY
             , B.SORT_ORDER_NO + 5                 AS SORT_ORDER_NO
             , 'Cell BOH(Hold)'                    AS COLUMN_LABEL_NAME
             , Y.BOD_ID
          FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO Y
             , (SELECT SA.SORT_ORDER_NO
                  FROM GT_XPGS_MEASURE SA
                 WHERE SA.COLUMN_NAME = 'PACK_CELL_BOH'
               )                             B  /* ON 1 = 1 */
         WHERE Y.MEASURE = 'PACK_CELL_BOH'
        ;

        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO  ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' PACK_CELL_BOH 가 존재하는 모델을 참고로 해서 PACK_CELL_BOH_HOLD MEASURE 생성 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* Cell BOH(Hold) new measure 에 주차별 표시 */
        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'P'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , 0                            AS FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'PACK_CELL_BOH_HOLD'         AS MEASURE
                    , A.YYYYMMDD
                    , NVL(A.QTY, 0)                AS QTY
                    , B.SORT_ORDER_NO + 5          AS SORT_ORDER_NO
                    , 'Cell BOH(Hold)'             AS COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY)           AS QTY
                            , Y.YYYYMMDD
                         FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'WH_HOLD'
                          AND (SELECT SC.OPERATION_GROUP
                                 FROM SCM_MST_SITE SC
                                WHERE SC.SCM_SITE_ID = Y.FROM_SITE) = 'P'  /* PACK 생산 사이트 한정 */
                          AND Y.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_TO_YYYYMMDD  /* 플랜구간만 유효 */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                               , Y.YYYYMMDD
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'PACK_CELL_BOH'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.YYYYMMDD  = Y.YYYYMMDD
               AND X.MEASURE   = 'PACK_CELL_BOH_HOLD')
         WHEN MATCHED THEN
              UPDATE
                 SET X.QTY = NVL(Y.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #PLN_TH_ENG_STOCK_PLAN PACK_CELL_BOH SET QTY ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 */
        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT V_DIVISION_ID                AS DIVISION_ID
                    , 'P'                          AS OPERATION_GROUP
                    , A.ITEM_ID
                    , '-'                          AS TO_SITE
                    , '-'                          AS PROJECT_CODE
                    , 0                            AS TO_BOH_QTY
                    , A.FROM_BOH_QTY
                    , '-'                          AS INCOTERMS
                    , A.FROM_SITE
                    , '-'                          AS TRANSPORT_MODE
                    , '-'                          AS PROD_LINE
                    , 'PACK_CELL_BOH_HOLD'         AS MEASURE
                    , 0                            AS QTY
                    , B.SORT_ORDER_NO + 5          AS SORT_ORDER_NO
                    , 'Cell BOH(Hold)'             AS COLUMN_LABEL_NAME
                    , '-'                          AS BOD_ID
                 FROM (SELECT Y.ITEM_ID
                            , Y.FROM_SITE
                            , SUM(Y.QTY)           AS FROM_BOH_QTY
                         FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN Y
                        WHERE Y.DESCR = 'WH_HOLD'
                          AND (SELECT SC.OPERATION_GROUP
                                 FROM SCM_MST_SITE SC
                                WHERE SC.SCM_SITE_ID = Y.FROM_SITE) = 'P'  /* PACK 생산 사이트 한정 */
                          AND (   Y.YYYYMMDD < V_PLAN_START_YYYYMMDD
                               OR Y.YYYYMMDD > V_TO_YYYYMMDD)  /* (플랜범위이전 + 플랜범위초과) 영역 */
                        GROUP BY Y.ITEM_ID
                               , Y.FROM_SITE
                      ) A
                    , (SELECT SA.SORT_ORDER_NO
                         FROM GT_XPGS_MEASURE SA
                        WHERE SA.COLUMN_NAME = 'PACK_CELL_BOH'
                      ) B
                WHERE A.FROM_SITE IS NOT NULL
              ) Y
           ON (    X.ITEM_ID   = Y.ITEM_ID
               AND X.FROM_SITE = Y.FROM_SITE
               AND X.MEASURE   = 'PACK_CELL_BOH_HOLD')
         WHEN MATCHED THEN
              UPDATE
                 SET X.FROM_BOH_QTY = NVL(Y.FROM_BOH_QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( DIVISION_ID
                   , OPERATION_GROUP
                   , ITEM_ID
                   , TO_SITE
                   , PROJECT_CODE
                   , TO_BOH_QTY
                   , FROM_BOH_QTY
                   , INCOTERMS
                   , FROM_SITE
                   , TRANSPORT_MODE
                   , PROD_LINE
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , SORT_ORDER_NO
                   , COLUMN_LABEL_NAME
                   , BOD_ID
                   )
              VALUES
                   ( Y.DIVISION_ID
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.PROJECT_CODE
                   , Y.TO_BOH_QTY
                   , Y.FROM_BOH_QTY
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.TRANSPORT_MODE
                   , Y.PROD_LINE
                   , Y.MEASURE
                   , V_PLAN_START_YYYYMMDD
                   , Y.QTY
                   , Y.SORT_ORDER_NO
                   , Y.COLUMN_LABEL_NAME
                   , Y.BOD_ID
                   )
        ;

        V_LOG_MESSAGE := '########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #PLN_TH_ENG_STOCK_PLAN PACK_CELL_BOH SET FROM_BOH_QTY ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        UPDATE GT_XPGS_PSI_GLOBAL_SMALL_AUTO
           SET ATTRIBUTE1 = NULL  /* '' */
             , ATTRIBUTE9 = NULL  /* '' */
         WHERE MEASURE    = 'PACK_CELL_BOH_HOLD'
        ;

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' PACK_CELL_BOH_HOLD ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* * 2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 -- end */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* LT 계산용 테이블 생성 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL DROP TABLE #SCP_MST_BOD_V; */
        DELETE FROM GT_XPGS_SCP_MST_BOD_V;

        INSERT
          INTO GT_XPGS_SCP_MST_BOD_V
             ( DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , BOD_ID
             , LT_TOTAL_BY_WEEK
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.FROM_SITE
             , X.TO_SITE
             , X.INCOTERMS
             , X.TRANSPORT_MODE
             , X.LT_TOTAL
             , X.BOD_ID
             , CEIL(X.LT_TOTAL / 7.0)              AS LT_TOTAL_BY_WEEK
          FROM SCP_MST_BOD_N_V X  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
         WHERE X.DIVISION_ID = V_DIVISION_ID
        ;

        V_LOG_MESSAGE := '########## INTO #SCP_MST_BOD_V ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM SCP_MST_BOD_N_V ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ----------------------------------------------------------------------------------------------------------------- */
        /* ---- PACK공장 CELL 재고 UPDATE */
        /* --------------------------------------------------------------------------------------------------------------- */
        /* PACK 일경우 */

        /* 2026-04-27 YMH E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 기존 로직 주석처리 */
        /* AS-IS L4691~L4701 (원문 그대로 보존)
                           ( *
                           UPDATE X
                              SET    CELL_ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                                          FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                                         WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                                           AND Y.MODEL_ID           = X.ITEM_ID
                                                           AND Y.CELL_TYPE             = 'CP'        -- 활성화코드 분리 대응(Cell Product 조건 추가) :: 2023.06.15 , KSK
                                                           AND Y.OPERATION_GROUP_ID = 'A')
                           FROM #PSI_GLOBAL_SMALL_AUTO X
                            WHERE OPERATION_GROUP   = 'P';
                            * )
        */
        /* 2026-04-27 YMH E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 기존 로직 주석처리 끝 */

        /* 2026-04-27 YMH E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 시작 */
        /* AS-IS WITH model_child_item_id AS (...) UPDATE X ... FROM ... JOIN : 모델별 1건(MIN) 원천이라 MERGE 로 이관 */
        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
        USING (SELECT Y.DIVISION_ID
                    , Y.MODEL_ID
                    , MIN(Y.CHILD_ITEM_ID)         AS CHILD_ITEM_ID
                 FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
                WHERE Y.DIVISION_ID        = V_DIVISION_ID
                  AND Y.CELL_TYPE          = 'CP'  /* 활성화코드 분리 대응(CELL PRODUCT 조건 추가) :: 2023.06.15 , KSK */
                  AND Y.OPERATION_GROUP_ID = 'A'
                GROUP BY Y.DIVISION_ID
                       , Y.MODEL_ID
              ) Y  /* model_child_item_id */
           ON (    Y.DIVISION_ID     = X.DIVISION_ID
               AND Y.MODEL_ID        = X.ITEM_ID
               AND X.OPERATION_GROUP = 'P')
         WHEN MATCHED THEN
              UPDATE
                 SET X.CELL_ITEM_ID = Y.CHILD_ITEM_ID
        ;
        /* 2026-04-27 YMH E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 끝 */

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* START E20251001-000977 셀-조립모델 매핑로직 변경(250930) */
        /* AS-IS UPDATE ... FROM JOIN : 대상 1행에 원천 여러 행이면 임의 1건 반영 → ROWID 기준 1건으로 MERGE */
        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO T
        USING (SELECT IB.RID
                    , IB.CELL_LIST
                 FROM (SELECT X.ROWID                 AS RID
                            , Y.CELL_LIST
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                         FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
                            , SCP_MST_FINAL_ITEM_V          Y
                        WHERE 0 = 0
                          AND X.ITEM_ID         = Y.ITEM_ID
                          AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                          AND Y.CELL_LIST IS NOT NULL
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (T.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET T.CELL_ITEM_ID = S.CELL_LIST
        ;
        /* END 셀-아이템 매핑로직 변경(250930, 변상현 책임) */

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' JOIN SCP_MST_FINAL_ITEM_V ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가) :: 2023.06.15 , KSK - START */
        /* ------------------------------------------------------------------------------------------------------------------------------ */
        /* PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update, 2023.06.15, KSK - start */
        /* ------------------------------------------------------------------------------------------------------------------------------ */
        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO T
        USING (SELECT IB.RID
                    , IB.CELL_ITEM_ID
                 FROM (SELECT X.ROWID                 AS RID
                            , Z.CELL_ITEM_ID
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                         FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
                            , (SELECT DISTINCT
                                      Z.MODEL_ID              AS ITEM_ID
                                    , Z.CHILD_ITEM_ID         AS CELL_ITEM_ID
                                    , Z.ACCUMULATED_CHILD_QTY AS CELL_QTY_PACK
                                    , Y.MODULE_ID
                                    , Y.MODULE_QTY_PACK
                                 FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Z
                                    , (SELECT X.DIVISION_ID
                                            , X.MODEL_ID
                                            , X.CHILD_ITEM_ID AS MODULE_ID
                                            , X.CHILD_QTY     AS MODULE_QTY_PACK
                                         FROM SCM_MST_BOM_SN_V X  /* --2021-03-09 SCP 대치 BOM 적용 */
                                            , SCM_MST_ITEM_SN  I
                                        WHERE X.CHILD_DIVISION_ID = I.DIVISION_ID
                                          AND X.CHILD_ITEM_ID     = I.ITEM_ID
                                          AND X.CHILD_COMPANY_ID  = I.COMPANY_ID  /* A002 빈강 추가 따른 조건 추가 */
                                          AND X.CHILD_SITE_ID     = I.SITE_ID
                                          AND I.FLOW_ID           = 'P5200'
                                          AND I.ACTIVE_FLAG       = 'Y'
                                          AND X.DIVISION_ID       = V_DIVISION_ID  /* 20250828 추가 CSR E20250829-001508 속도개선위해 추가 */
                                      ) Y
                                WHERE Z.DIVISION_ID        = Y.DIVISION_ID
                                  AND Z.MODEL_ID           = Y.MODEL_ID
                                  AND Z.CELL_TYPE          = 'CP'  /* 2023.06.08 활성화코드 분리 대응(Cell Product 조건 추가) */
                                  AND Z.OPERATION_GROUP_ID = 'A'
                                  AND Z.DIVISION_ID        = V_DIVISION_ID  /* 20250828 추가 CSR E20250829-0015086 속도개선위해 추가 */
                              ) Z
                        WHERE X.ITEM_ID    = Z.MODULE_ID
                          AND X.ATTRIBUTE9 = 'P5200'
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (T.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET T.CELL_ITEM_ID = S.CELL_ITEM_ID
        ;

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V P5200 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* LINE_TOTAL_LOAD_ENGINE (TACT_TIME,WORKING_TIME) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* Line Load 율 로직 작업중 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL DROP TABLE #LINE_WORKINGTIME_BY_LOSS; */
        DELETE FROM GT_XPGS_LINE_WORKINGTIME_BY_LOSS;

        /* --Working Time 추출 */
        INSERT
          INTO GT_XPGS_LINE_WORKINGTIME_BY_LOSS
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
             )
        SELECT A.DIVISION_ID
             , A.PLANT_SITE_ID                     AS SCM_SITE_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.YYYYMMDD
             , A.WORKING_TIME
          FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS(V_DIVISION_ID, V_PLAN_START_YYYYMMDD, V_TO_YYYYMMDD, NULL)) A  /* AS-IS 마지막 인자 '' */
        ;

        V_LOG_MESSAGE := '########## INTO #LINE_WORKINGTIME_BY_LOSS ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' INTO #LINE_WORKINGTIME_BY_LOSS FROM FN_LINE_WORKINGTIME_BY_LOSS ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 시작 */

        /* IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL DROP TABLE #LineLoad; */
        DELETE FROM GT_XPGS_LINELOAD;

        INSERT
          INTO GT_XPGS_LINELOAD
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_GROUP
             , OPERATION_ID
             , LINE_ID
             , MEASURE
             , QTY
             , CAPA_TACT
             , WORKING_TIME
             , YYYYMMDD
             , ISO_YYYYWW
             , TIME_TERM
             , WEEK_COLUMN
             )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.OPERATION_GROUP
             , A.OPERATION_ID
             , A.LINE_ID
             , CASE WHEN A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                    WHEN A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
               END                                                                      AS MEASURE
             , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
                    ELSE NVL(((ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME)), 0) * 100
               END                                                                      AS QTY
             , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60.0)), 0), 0)                      AS CAPA_TACT
             , NVL(D.WORKING_TIME, 0)                                                   AS WORKING_TIME
             , A.YYYYMMDD
             , C.ISO_YYYYWW
             , M.TIME_TERM
               /* AS-IS 'WQTY' + REPLICATE('0', 2 - LEN(순번)) + 순번 : 순번 세 자리 이상이면 REPLICATE 가 NULL → 결과 NULL */
             , CASE WHEN DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW) < 100
                    THEN 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW)), 2, '0')
               END                                                                      AS WEEK_COLUMN
          FROM SCP_ANL_PRODUCTION_PLAN          A
               /* SCP_ANL_PRODUCTION_PLAN(A) */
               /* division=40: 약 13,816,914건 / 전체: 66,428,150건 */
               /* IX06 인덱스: (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, */
               /*              LINE_ID, MEASURE, YYYYMMDD, ...) 활용 */
               /* 최종 결과: 약 402,309건 → 31,920건 GROUP BY 후 */
               /* SCM_SYS_CALENDAR_M(C): 날짜범위 내 약 2,520건 (소규모) */
               /* Build 입력으로 HASH JOIN → Probe 입력(A)의 YYYYMMDD와 매칭 */
             , SCM_SYS_CALENDAR_M               C  /* INNER HASH JOIN */
               /* #LINE_WORKINGTIME_BY_LOSS(D): 95,776건 */
               /* Build 입력으로 HASH JOIN */
             , GT_XPGS_LINE_WORKINGTIME_BY_LOSS D  /* LEFT HASH JOIN */
               /* SCP_ANL_TACT_TIME(E): division=40 기준 7,242,428건 / 전체 12,601,519건 */
               /* 대용량 → LEFT HASH JOIN 명시하여 Nested Loop 방지 */
             , SCP_ANL_TACT_TIME                E  /* LEFT HASH JOIN */
               /* LEFT HASH JOIN으로 통일 → OPTION(HASH JOIN) 없이도 충돌 없음 */
             , SCM_WORK_CALENDAR_M_SN           M  /* LEFT HASH JOIN */
         WHERE C.BASIS_YYYYMMDD       = A.YYYYMMDD
           AND D.DIVISION_ID(+)       = A.DIVISION_ID
           AND D.OPERATION_ID(+)      = A.OPERATION_ID
           AND D.SCM_SITE_ID(+)       = A.SCM_SITE_ID
           AND D.LINE_ID(+)           = A.LINE_ID
           AND D.YYYYMMDD(+)          = A.YYYYMMDD
           AND E.DIVISION_ID(+)       = A.DIVISION_ID
           AND E.OPERATION_ID(+)      = A.OPERATION_ID
           AND E.SCM_SITE_ID(+)       = A.SCM_SITE_ID
           AND E.LINE_ID(+)           = A.LINE_ID
           AND E.ITEM_ID(+)           = A.ITEM_ID
           AND E.YYYYMMDD(+)          = A.YYYYMMDD
           AND M.DIVISION_ID(+)       = A.DIVISION_ID
           AND M.OPERATION_ID(+)      = A.OPERATION_ID
           AND M.PLANT_ID(+)          = SUBSTR(A.SCM_SITE_ID, 1, 4)
           AND M.WORK_DATE(+)         = TO_DATE(A.YYYYMMDD, 'YYYYMMDD')
           AND M.LINE_ID(+)           = A.LINE_ID
           AND M.LOSS_CODE(+)         = 'XC031'
           AND A.DIVISION_ID          = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE            = V_PLAN_TYPE
           AND A.SEQ                  = V_SEQ  /* CAST(@p_seq AS BIGINT) */
           AND A.YYYYMMDD            >= V_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD            <= V_TO_YYYYMMDD
           AND A.MEASURE              = 'PROD_PLAN_AMEND'
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.OPERATION_ID
                , A.LINE_ID
                , A.YYYYMMDD
                , D.WORKING_TIME
                , C.ISO_YYYYWW
                , A.OPERATION_GROUP
                , CASE WHEN A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                       WHEN A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                  END
                , M.TIME_TERM
           /* OPTION (MAXDOP 4, NO_PERFORMANCE_SPOOL)
              -- MAXDOP 4: 병렬도 제한으로 RESERVED_MEMORY_ALLOCATION_EXT 대기 최소화
              -- NO_PERFORMANCE_SPOOL: 불필요한 Spool 연산 방지 : Oracle 힌트 미사용 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 끝 */

        V_LOG_MESSAGE := '########## INTO #LineLoad ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM SCP_ANL_PRODUCTION_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 로직 주석처리 */
        /* AS-IS L4960~L5037 (원문 그대로 보존)
               ( *

                             IF OBJECT_ID('tempdb..#LineLoad_temp') IS NOT NULL
                               DROP TABLE #LineLoad_temp;



                           SELECT ( *DISTINCT * )
                                             A.DIVISION_ID
                                         , A.SCM_SITE_ID
                               , A.OPERATION_GROUP
                                   , A.OPERATION_ID
                                   , A.LINE_ID
                               , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END ) AS MEASURE
                               , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE ISNULL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) / D.WORKING_TIME ) ) ,0 ) *100  END AS QTY
                                         , ISNULL(ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0), 0) AS CAPA_TACT
                                         , ISNULL( D.WORKING_TIME ,0 ) AS WORKING_TIME
                               , A.YYYYMMDD AS YYYYMMDD
                               , C.ISO_YYYYWW AS ISO_YYYYWW
                               , M.TIME_TERM        -- 형교환(Model Change)
                               ,'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW) )) + CONVERT(NVARCHAR,DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW))  AS WEEK_COLUMN
                           INTO #LineLoad_temp
                                 FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
                           INNER JOIN SCM_SYS_CALENDAR_M C   WITH (NOLOCK)
                                   ON A.YYYYMMDD = C.BASIS_YYYYMMDD
                                 LEFT OUTER JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
                                ON   A.DIVISION_ID   = D.DIVISION_ID
                                 AND A.OPERATION_ID  = D.OPERATION_ID
                                           AND A.SCM_SITE_ID   = D.SCM_SITE_ID
                                           AND A.LINE_ID       = D.LINE_ID
                                           AND A.YYYYMMDD      = D.YYYYMMDD
                                 LEFT OUTER JOIN SCP_ANL_TACT_TIME E WITH(NOLOCK)
                                 ON A.DIVISION_ID    = E.DIVISION_ID
                                AND A.OPERATION_ID   = E.OPERATION_ID
                                        AND A.SCM_SITE_ID    = E.SCM_SITE_ID
                                        AND A.LINE_ID        = E.LINE_ID
                                AND A.ITEM_ID        = E.ITEM_ID
                                        AND A.YYYYMMDD       = E.YYYYMMDD
                           -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현
                           -- 형교환(Model Change) 적용 - start
                             LEFT OUTER JOIN SCM_WORK_CALENDAR_M_SN M  WITH (NOLOCK)
                               ON A.DIVISION_ID           = M.DIVISION_ID
                               AND LEFT(A.SCM_SITE_ID, 4) = M.PLANT_ID
                               AND A.OPERATION_ID         = M.OPERATION_ID
                               AND convert(datetime, A.YYYYMMDD)             = M.WORK_DATE
                               AND A.LINE_ID              = M.LINE_ID
                               AND M.LOSS_CODE            = 'XC031'
                           -- 형교환(Model Change) 적용 - end
                                 WHERE 1=1
                              AND A.DIVISION_ID         = @p_division_id
                             AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                             AND A.PLAN_TYPE           = @p_plan_type
                             AND A.SEQ                 = @p_seq
                                   AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd
                               AND A.YYYYMMDD           <=  @p_to_yyyymmdd --말일포함(KSK, 20240814)
           --                    AND A.MEASURE             IN ('CELL_PROD','PACK_PROD')
                             AND A.MEASURE             IN ('PROD_PLAN_AMEND')
                         GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP
                                 ,(CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END )
                                 , M.TIME_TERM        -- 형교환(Model Change)
                                 ;


                  SET @v_log_message = N'########## INTO #LineLoad_temp  ##########';
                   SET @v_description = @v_program_name + ':' + N' FROM SCP_ANL_PRODUCTION_PLAN ';
                   SET @d_event_date = SYSDATETIME();
                   EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                             ,@p_log_type      = @v_log_type
                                             ,@p_log_count     = @n_log_count
                                             ,@p_log_message   = @v_log_message
                                             ,@p_description   = @v_description
                                             ,@p_event_date    = @d_event_date
                                             ,@p_user_id       = @v_batch_user
                                             ;

                   select '#LineLoad_temp'
                   select * from #LineLoad_temp
                   * )
        */

        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                                 AS TO_SITE
             , A.PROJECT_CODE
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , A.FROM_SITE
             , '-'                                 AS TRANSPORT_MODE
             , A.PROD_LINE
             , B.MEASURE
             , A.YYYYMMDD
             , B.QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE9
          FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO A
             , GT_XPGS_LINELOAD              B
             , GT_XPGS_MEASURE               M
         WHERE A.DIVISION_ID     = B.DIVISION_ID
           AND A.OPERATION_GROUP = B.OPERATION_GROUP
           AND A.FROM_SITE       = B.SCM_SITE_ID
           AND A.ATTRIBUTE9      = B.OPERATION_ID
           AND A.PROD_LINE       = B.LINE_ID
           AND A.YYYYMMDD        = B.YYYYMMDD
           AND B.MEASURE         = M.COLUMN_NAME
        ;

        V_LOG_MESSAGE := '########## INSERT INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #PSI_GLOBAL_SMALL_AUTO ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ---------------- E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경) ---------START */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT B.DIVISION_ID
             , F.OPERATION_GROUP
             , NVL(F.CELL_ITEM_ID, M.ITEM_ID)      AS CELL_ITEM_ID
             , M.ITEM_ID
             , B.TO_SITE
             , '-'                                 AS PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , B.INCOTERMS
             , B.FROM_SITE
             , B.TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , 'SHIP_PLAN'                         AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD
             , 0                                   AS QTY
             , MS.SORT_ORDER_NO
             , MS.COLUMN_LABEL_NAME
             , B.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_FG'          AS ATTRIBUTE1
             , NULL                                AS ATTRIBUTE9
          FROM SCP_MST_BOD_N_V    B
             , SCP_MST_BOD_ITEM   M
             , SCP_MST_FINAL_ITEM F
             , GT_XPGS_MEASURE    MS
         WHERE B.DIVISION_ID      = M.DIVISION_ID
           AND B.BOD_ID           = M.BOD_ID
           AND M.DIVISION_ID      = F.DIVISION_ID
           AND M.ITEM_ID          = F.ITEM_ID
           AND EXISTS (SELECT 1  /* BOD_ID, TO_SITE, from_site, INCOTERMS, TRANSPORT_MODE */
                         FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO S
                        WHERE S.MEASURE        = 'SHIP_PLAN'
                          AND S.TO_SITE        = B.TO_SITE
                          AND S.FROM_SITE      = B.FROM_SITE
                          AND (S.INCOTERMS = B.INCOTERMS OR S.INCOTERMS = '-')
                          AND S.TRANSPORT_MODE = B.TRANSPORT_MODE
                          AND S.BOD_ID        <> B.BOD_ID
                      )
           AND M.VALID_YN         = 'Y'
           AND B.BOD_VALID_YN     = 'Y'
           AND B.ROUTE_VALID_YN   = 'Y'  /* KSK,250709 */
           AND F.OPERATION_GROUP  = 'A'
           AND F.ATTRIBUTE8       = 'CP'
           AND MS.COLUMN_NAME     = 'SHIP_PLAN'
           AND 1 = 1
           AND B.BOD_VALID_YN     = 'Y'
           AND B.DIVISION_ID      = V_DIVISION_ID
           AND B.BOD_TYPE         = 'SALES'
           AND B.TRANSPORT_MODE  <> 'AIR'
           AND B.FROM_YYYYMMDD   <= V_TO_YYYYMMDD
           AND B.TO_YYYYMMDD     >= V_PLAN_START_YYYYMMDD
        ;

        V_LOG_MESSAGE := '########## INSERT INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM [SCP_MST_BOD_N_V] SHIP_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT B.DIVISION_ID
             , F.OPERATION_GROUP
             , NVL(F.CELL_ITEM_ID, M.ITEM_ID)      AS CELL_ITEM_ID
             , M.ITEM_ID
             , B.TO_SITE
             , '-'                                 AS PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , B.INCOTERMS
             , B.FROM_SITE
             , B.TRANSPORT_MODE
             , '-'                                 AS PROD_LINE
             , 'SEMI_SHIP_PLAN'                    AS MEASURE
             , V_PLAN_START_YYYYMMDD               AS YYYYMMDD
             , 0                                   AS QTY
             , MS.SORT_ORDER_NO
             , MS.COLUMN_LABEL_NAME
             , B.BOD_ID
             , 'SCP_ANL_SHIPMENT_PLAN_SEMI'        AS ATTRIBUTE1
             , NULL                                AS ATTRIBUTE9
          FROM SCP_MST_BOD_N_V    B
             , SCP_MST_BOD_ITEM   M
             , SCP_MST_FINAL_ITEM F
             , GT_XPGS_MEASURE    MS
         WHERE B.DIVISION_ID      = M.DIVISION_ID
           AND B.BOD_ID           = M.BOD_ID
           AND M.DIVISION_ID      = F.DIVISION_ID
           AND M.ITEM_ID          = F.ITEM_ID
           AND EXISTS (SELECT 1  /* BOD_ID, TO_SITE, from_site, INCOTERMS, TRANSPORT_MODE */
                         FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO S
                        WHERE S.MEASURE        = 'SEMI_SHIP_PLAN'
                          AND S.TO_SITE        = B.TO_SITE
                          AND S.FROM_SITE      = B.FROM_SITE
                          AND (S.INCOTERMS = B.INCOTERMS OR S.INCOTERMS = '-')
                          AND S.TRANSPORT_MODE = B.TRANSPORT_MODE
                          AND S.BOD_ID        <> B.BOD_ID
                      )
           AND M.VALID_YN         = 'Y'
           AND B.BOD_VALID_YN     = 'Y'
           AND B.ROUTE_VALID_YN   = 'Y'  /* KSK,250709 */
           AND F.OPERATION_GROUP  = 'A'
           AND F.ATTRIBUTE8       = 'CP'
           AND MS.COLUMN_NAME     = 'SEMI_SHIP_PLAN'
           AND 1 = 1
           AND B.BOD_VALID_YN     = 'Y'
           AND B.DIVISION_ID      = V_DIVISION_ID
           AND B.BOD_TYPE         = 'PLANT'
           AND B.TRANSPORT_MODE  <> 'AIR'
           AND B.FROM_YYYYMMDD   <= V_TO_YYYYMMDD
           AND B.TO_YYYYMMDD     >= V_PLAN_START_YYYYMMDD
        ;

        V_LOG_MESSAGE := '########## INSERT INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM [SCP_MST_BOD_N_V] SEMI_SHIP_PLAN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ----------- E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경) -------- END */

        /* ---------------------------------------------------- */
        /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 */
        /* KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - start */
        INSERT
          INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , PROJECT_CODE
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , PROD_LINE
             , MEASURE
             , YYYYMMDD
             , QTY
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE1
             , ATTRIBUTE9
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.OPERATION_GROUP
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , '-'                                 AS TO_SITE
             , '-'                                 AS PROJECT_CODE
             , 0                                   AS TO_BOH_QTY
             , 0                                   AS FROM_BOH_QTY
             , '-'                                 AS INCOTERMS
             , X.FROM_SITE
             , '-'                                 AS TRANSPORT_MODE
             , X.PROD_LINE
             , M.COLUMN_NAME                       AS MEASURE
             , X.YYYYMMDD
             , 0                                   AS QTY
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , '-'                                 AS BOD_ID
             , X.ATTRIBUTE1
             , X.ATTRIBUTE9
          FROM (SELECT DISTINCT
                       SA.DIVISION_ID
                     , SA.OPERATION_GROUP
                     , SA.CELL_ITEM_ID
                     , SA.ITEM_ID
                     , SA.FROM_SITE
                     , SA.PROD_LINE
                     , SA.MEASURE
                     , SA.YYYYMMDD
                     , SA.ATTRIBUTE1
                     , SA.ATTRIBUTE9
                  FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO SA
                 WHERE SA.MEASURE   IN ('PACK_PROD', 'CELL_PROD')
                   AND SA.PROD_LINE <> '-'
               )               X
             , GT_XPGS_MEASURE M  /* CROSS APPLY */
         WHERE 1 = 1
           AND X.MEASURE    IN ('PACK_PROD', 'CELL_PROD')
           AND M.GUBUN       = 'FROM'
           AND M.COLUMN_NAME = (CASE WHEN X.MEASURE = 'PACK_PROD' THEN 'PACK_MODEL_CHANGE' ELSE 'CELL_MODEL_CHANGE' END)
           AND X.PROD_LINE  <> '-'
        ;

        V_LOG_MESSAGE := '########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' FROM #PSI_GLOBAL_SMALL_AUTO PACK_PROD / CELL_PROD ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        DELETE
          FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO
         WHERE MEASURE  IN ('PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE')
           AND PROD_LINE = '-'
        ;

        V_LOG_MESSAGE := '########## DELETE #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' PACK_MODEL_CHANGE / CELL_MODEL_CHANGE ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - end */

        /* KSW 2021.07.29 형교환 - start */
        MERGE
         INTO GT_XPGS_PSI_GLOBAL_SMALL_AUTO T
        USING (SELECT IB.RID
                    , IB.QTY
                 FROM (SELECT X.ROWID                 AS RID
                            , NVL(B.TIME_TERM, 0)     AS QTY
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                         FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO X
                            , SCM_WORK_CALENDAR_M_SN        B
                        WHERE 0 = 0
                          AND X.DIVISION_ID                    = B.DIVISION_ID
                          AND SUBSTR(X.FROM_SITE, 1, 4)        = B.PLANT_ID
                          AND X.ATTRIBUTE9                     = B.OPERATION_ID
                          AND TO_DATE(X.YYYYMMDD, 'YYYYMMDD')  = B.WORK_DATE  /* AS-IS 문자 YYYYMMDD = DATETIME 비교(문자 → 날짜 변환) */
                          AND X.PROD_LINE                      = B.LINE_ID
                          AND B.LOSS_CODE                      = 'XC031'
                          AND X.MEASURE                       IN ('PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE')
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (T.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET T.QTY = S.QTY
        ;

        V_LOG_MESSAGE := '########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' JOIN SCM_WORK_CALENDAR_M_SN ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* KSW 2021.07.29 형교환 - end */
        /* ---------------------------------------------------- */

        /* if @p_is_debug = 1 SELECT '#PSI_GLOBAL_SMALL_AUTO_3' "PSI_GLOBAL_SMALL_AUTO_3", * FROM #PSI_GLOBAL_SMALL_AUTO : 디버그 결과 집합 없음 */

        /* 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성 */
        /*            구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결) */

        /* 기존 플랜의 구 data 삭제 */
        IF P_IS_DEBUG = '0' THEN
            DELETE
              FROM SCP_XLS_PSI_GLOBAL_SMALL
             WHERE DIVISION_ID = V_DIVISION_ID
               /* --  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */
            ;
        END IF;

        V_LOG_MESSAGE := '########## DELETE SCP_XLS_PSI_GLOBAL_SMALL DIVISION ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 기존 플랜의 구 data 삭제 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* Plan End Date : AS-IS SELECT @변수 = ... (행 없으면 초기값 유지, 여러 행이면 마지막 행) → 커서 반복 */
        V_BP_FLAG := NULL;
        FOR CUR_PLAN IN (SELECT P.HORIZON_END_DATE
                              , CASE WHEN TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD') > 364 THEN 'Y'
                                     ELSE 'N'
                                END                                     AS BP_FLAG
                              , CASE WHEN TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD') > 364
                                     THEN TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD') - 363
                                     ELSE 0
                                END                                     AS BP_DAYS
                           FROM SCM_MST_PLAN P
                          WHERE P.PLAN_ID     = (SELECT MAX(SA.PLAN_ID)
                                                   FROM SCM_MST_PLAN SA
                                                  WHERE SA.DIVISION_ID          = V_DIVISION_ID
                                                    AND TO_NUMBER(SA.PLAN_ID) < 9999)
                            AND P.DIVISION_ID = V_DIVISION_ID)
        LOOP
            V_PET_DATE := CUR_PLAN.HORIZON_END_DATE;
            V_BP_FLAG  := CUR_PLAN.BP_FLAG;
            V_BP_DAYS  := CUR_PLAN.BP_DAYS;
        END LOOP;

        V_CREATE_FROM_YYYYMMDD := V_PLAN_START_YYYYMMDD;
        V_CREATE_TO_YYYYMMDD   := TO_CHAR(TO_DATE(V_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD');

        IF P_IS_DEBUG = '0' THEN
            PR_SCP_XLS_PSI_GLOBAL_SMALL_S( P_PLAN_CYCLE           => V_PLAN_CYCLE
                                         , P_PLAN_START_YYYYMMDD  => V_PLAN_START_YYYYMMDD
                                         , P_PLAN_ID              => V_PLAN_ID
                                         , P_MODELING_ID          => V_MODELING_ID
                                         , P_SEQ                  => V_SEQ_TXT
                                         , P_PLAN_TYPE            => V_PLAN_TYPE
                                         , P_MASTER_ID            => V_MASTER_ID
                                         , P_DIVISION_ID          => V_DIVISION_ID
                                         , P_ENGINE_PLAN_ID       => V_ENGINE_PLAN_ID
                                         , P_CREATE_FROM_YYYYMMDD => V_CREATE_FROM_YYYYMMDD
                                         , P_CREATE_TO_YYYYMMDD   => V_CREATE_TO_YYYYMMDD
                                         , P_USER_ID              => V_BATCH_USER
                                         , P_IS_DEBUG             => P_IS_DEBUG
                                         , O_RETURN               => N_ROWS
                                         );
        END IF;

        IF (N_ROWS < 0) THEN  /* GOTO _RETURN_ERR_CODE */
            O_RETURN := -1;
            RETURN;
        END IF;

        /* --PRINT 'PR_SCP_XLS_PSI_GLOBAL_SMALL_S START' */

        IF V_BP_FLAG = 'Y' THEN
            /* 2 YEAR PIVOT data 생성 */
            V_CREATE_FROM_YYYYMMDD := TO_CHAR(TO_DATE(V_CREATE_TO_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');
            V_CREATE_TO_YYYYMMDD   := TO_CHAR(TO_DATE(V_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD');
            IF P_IS_DEBUG = '0' THEN
                PR_SCP_XLS_PSI_GLOBAL_SMALL_S( P_PLAN_CYCLE           => V_PLAN_CYCLE
                                             , P_PLAN_START_YYYYMMDD  => V_PLAN_START_YYYYMMDD
                                             , P_PLAN_ID              => V_PLAN_ID
                                             , P_MODELING_ID          => V_MODELING_ID
                                             , P_SEQ                  => V_SEQ_TXT
                                             , P_PLAN_TYPE            => V_PLAN_TYPE
                                             , P_MASTER_ID            => V_MASTER_ID
                                             , P_DIVISION_ID          => V_DIVISION_ID
                                             , P_ENGINE_PLAN_ID       => V_ENGINE_PLAN_ID
                                             , P_CREATE_FROM_YYYYMMDD => V_CREATE_FROM_YYYYMMDD
                                             , P_CREATE_TO_YYYYMMDD   => V_CREATE_TO_YYYYMMDD
                                             , P_USER_ID              => V_BATCH_USER
                                             , P_IS_DEBUG             => P_IS_DEBUG
                                             , O_RETURN               => N_ROWS
                                             );
            END IF;
            IF (N_ROWS < 0) THEN  /* GOTO _RETURN_ERR_CODE */
                O_RETURN := -1;
                RETURN;
            END IF;
        END IF;

        /* --PRINT '임시 TEMP 테이블 DROP' */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 임시 TEMP 테이블 DROP */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* AS-IS DROP TABLE #MEASURE, #PSI_GLOBAL_SMALL, #ANL_SHIPMENT_PLAN_FG, #ANL_PRODUCTION_PLAN, #ANL_SHIPMENT_PLAN_SEMI,
           #SCP_PLN_PRODUCTION_PLAN, #ITEM_ID, #PSI_GLOBAL_SMALL_AUTO, #INTRANSIT, #PLN_TH_ENG_STOCK_PLAN,
           #PLN_TH_ENG_STOCK_PLAN_FOR_HOLD, #PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD, #SCP_MST_BOD_V, #LineLoad, #LineLoad_WEEK_PIVOT,
           #TRANSPORT_MODE, #SCP_XLS_PSI_GLOBAL_SMALL_AUTO_MODEL_INVENTORY, #Rn, #CALENDAR, #HEADER, #PLN_PLANT_ONHAND, #BOH,
           #BOH_NHOLD, #SCP_XLS_PSI_GLOBAL_SMALL_AUTO, #tmp_SCP_MST_TACT_TIME, #LINE_ASSIGN, #LINE_ASSIGN_ORG, #temp_MODEL_INFO,
           #PLN_TH_ENG_STOCK_PLAN_INSP, #tmp_PSI_GLOBAL_SMALL_AUTO, #tmp_SCP_MST_DIO_OLD, #tmp_SCP_MST_DIO, #tmp_NICK_NAME
           → GTT 는 세션 종료 시 정리되고 다음 실행 시작 시 DELETE 로 초기화
           -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - HOLD 가 포함되지 않음 - PACK HOLD 만 해당
           -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
           -- PACK_PROD, CELL_PROD - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가 - 임시테이블 삭제
           -- MODULE 의 상위 모델을 찾기위한 temp 테이블
           -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가
           -- 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장 */

        /* ----------------------------------------------------------- */
        /* 실행 Logic END -- */
        /* ----------------------------------------------------------- */
        /* --IF @@TRANCOUNT > 0 */
        /* --  BEGIN */
        /* --    COMMIT TRAN ; */
        /* --  END; */

        /* --PRINT '완료 로깅 시작' */

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        IF P_IS_DEBUG = '0' THEN
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );
        END IF;
        /* --PRINT '완료' */

    EXCEPTION  /* BEGIN CATCH */
        WHEN OTHERS THEN
            /* --IF @@TRANCOUNT > 0 */
            /* --  BEGIN */
            /* --    ROLLBACK TRAN T1 */
            /* --  END; */

            /* ERROR LOG */
            /* --PRINT @@ERROR */
            /* --PRINT ERROR_MESSAGE(); */
            /* --PRINT ERROR_LINE(); */
            V_SQL_ERR_CODE  := TO_CHAR(SQLCODE);
            V_SQL_ERR_MSG   := SUBSTR(SQLERRM, 1, 2000);
            V_SQL_BACKTRACE := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
            V_LOG_TYPE      := 'ERROR';
            V_LOG_MESSAGE   := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION   := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || V_SQL_BACKTRACE, 1, 500);
            D_EVENT_DATE    := SYSDATE;
            IF P_IS_DEBUG = '0' THEN
                PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                                    , P_LOG_TYPE      => V_LOG_TYPE
                                    , P_LOG_COUNT     => N_LOG_COUNT
                                    , P_LOG_MESSAGE   => V_LOG_MESSAGE
                                    , P_DESCRIPTION   => V_DESCRIPTION
                                    , P_EVENT_DATE    => D_EVENT_DATE
                                    , P_USER_ID       => V_BATCH_USER
                                    , P_SQL_ERR_CODE  => V_SQL_ERR_CODE
                                    , P_SQL_ERR_MSG   => V_SQL_ERR_MSG
                                    , P_SQL_BACKTRACE => V_SQL_BACKTRACE
                                    );
            END IF;
            O_RETURN := -1;
            RETURN;  /* return -1 */
    END;  /* END CATCH; */

    /* 임시 운영반영시에 주석처리 할것. */
    N_EXEC_SEC  := ROUND((SYSDATE - V_START_TIME) * 86400);
    V_EXEC_TIME := CASE WHEN TRUNC(N_EXEC_SEC / 60) < 100
                        THEN LPAD(TO_CHAR(TRUNC(N_EXEC_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(N_EXEC_SEC, 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[' || V_MASTER_ID || '][' || V_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    IF P_IS_DEBUG = '0' THEN
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );
    END IF;
    O_RETURN := 1;
    RETURN;  /* return 1 */

    /* _RETURN_ERR_CODE: BEGIN RETURN -1 END; → 하위 호출 직후 O_RETURN := -1; RETURN; 으로 이관 */
END;