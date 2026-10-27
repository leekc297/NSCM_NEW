PROCEDURE PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK
(
      P_PLAN_CYCLE            IN  VARCHAR2                         /* NVARCHAR(0150) */
    , P_PLAN_START_YYYYMMDD   IN  VARCHAR2                         /* NVARCHAR(0008) */
    , P_PLAN_ID               IN  VARCHAR2                         /* NVARCHAR(4000) */
    , P_MODELING_ID           IN  VARCHAR2                         /* NVARCHAR(4000) */
    , P_SEQ                   IN  VARCHAR2                         /* NVARCHAR(4000) */
    , P_PLAN_TYPE             IN  VARCHAR2                         /* NVARCHAR(4000) */
    , P_MASTER_ID             IN  VARCHAR2                         /* NVARCHAR(4000) */
    , P_DIVISION_ID           IN  VARCHAR2                         /* NVARCHAR(0030) */
    , P_ENGINE_PLAN_ID        IN  VARCHAR2                         /* NVARCHAR(4000) */
    , P_USER_ID               IN  VARCHAR2 DEFAULT 'SCP_batch'     /* NVARCHAR(0150) = 'SCP_batch' */
    , P_IS_DEBUG              IN  VARCHAR2 DEFAULT '0'             /* bit = 0 --0 : RELEASE, 1 : DEBUG */
    , O_RETURN                OUT NUMBER                           /* AS-IS RETURN 값 → OUT 인자(반환값 규칙) */
)
/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :
    DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='KSK'

    EXEC PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK
                                 @p_plan_cycle          = 'WEEKLY'
                               , @p_plan_start_yyyymmdd = '20250324'
                               , @p_plan_id             = '1384'
                               , @p_modeling_id         = '1'
                               , @p_seq                 = '2'
                               , @p_plan_type           = 'PR'
                               , @p_master_id           = '40::WEEKLY'
                               , @p_division_id         = '40'
                               , @p_engine_plan_id      = '1384::PR::2'
                               , @p_user_id             = 'KSK'
                               , @P_IS_DEBUG     = 1

    SELECT TOP 30 * FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.02.21   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *              KSG         과거 이력 정리
 * 2021.03.26   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완
 * 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가
 * 2021.08.25   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021-08.26   KSW         CHILD_ITEM_ID 불일치 오류 수정 (cell requirement total 수식설정오류)
 * 2022-03-31   KSW         OSP LT 적용 :: 생산계획의 LT 컬럼에 OSP LT 값을 표시하고 Pack Model Inventory (EOH) 수식을 변경한다. (생산계획에 LT 적용)
 * 2022-07-01   KSW         PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
 * 2022-09-21   KSW         W-1주차 생산/출하계획을 표시하는 measure 추가 등 (소형SCM개선요청사항 적용)
 * 2023-01-13   KKH         소형팩 시뮬레이터 mkt_fcst수량 수정 (최종 월에 해당하는 값만 업데이트 -> 여러건을 group by에서 최종값 연결)
 * 2023.07.01   KSG         PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2 : 활성화 분리
 * 2023.10.10   KHJ         1년차와 2년차의 XLS_KEY1 값 일치화 작업
 * 2023.10.30   KHJ         특정 MEASURE 2년차의 데이터 미생성부분 BP_FLAG를 통해 분기 처리함.
 * 2024.11.12    KSK           MKT_FCST 메저관련 원본교체 DM_PLN_MKT_FCST_C => DM_PLN_MKT_FCST
 * 2025.02.27    KSK           TO SITE별 RTF 관련 메저 생성
 * 2025.03.05    KSK           출하계획의 SSP는 승인건수(CHANGE_TYPE=C)에 한정하도록 보완
 * 2025.03.13    KSK           SHIP_PLAN_ETA의 LT관련 필드조회
 * 2025.08.01   hrkim       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
AS
    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET NOCOUNT ON; SET XACT_ABORT ON; (Oracle 기본 동작) */
    /* SET ANSI_WARNINGS OFF : 임시 테이블 칸보다 긴 문자는 잘려 들어가던 것을 SUBSTR 로 재현(CELL_ITEM_ID 150→100 · MEASURE 200→100) */

    /* AS-IS 인자 선언 길이 재현 : NVARCHAR(0008) · NVARCHAR(0030) · NVARCHAR(0150) */
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)   := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_DIVISION_ID           VARCHAR2(30 CHAR)  := SUBSTR(P_DIVISION_ID, 1, 30);
    V_USER_ID               VARCHAR2(150 CHAR) := SUBSTR(P_USER_ID, 1, 150);
    N_SEQ                   NUMBER;            /* @p_seq(NVARCHAR) 를 BIGINT 칸과 비교하던 자리 : 숫자로 한 번 변환 */

    /* LOG 용 변수 설정 */
    V_BATCH_USER            VARCHAR2(150 CHAR) := 'SCP_batch';
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK';
    V_LOG_TYPE              VARCHAR2(30 CHAR);  /* START/END/ERROR/... */
    N_LOG_COUNT             NUMBER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    V_TABLE_ID              VARCHAR2(150 CHAR) := 'SCM_SYS_LOG_BATC';
    D_EVENT_DATE            DATE;

    /* 실행시간 확인용 */
    D_START_TIME            DATE               := SYSDATE;
    V_EXEC_TIME             VARCHAR2(10 CHAR)  := '';  /* --'00:00'; */

    V_PROGRAM_ID            VARCHAR2(30 CHAR)  := 'XLSPSI02';

    V_BP_FLAG               VARCHAR2(8 CHAR)   := '';
    V_TO_YYYYMMDD           VARCHAR2(8 CHAR);  /* --계획종료구간일 */
    N_ISUZU_CNT             NUMBER := 0;

    V_DT1                   VARCHAR2(100 CHAR);  /* -- 화요일 */
    V_DT2                   VARCHAR2(100 CHAR);  /* -- 화요일-7(전주) */
    V_VERSION_NO            VARCHAR2(100 CHAR) := '';

    N_ROWS                  NUMBER;
    V_CREATE_FROM_YYYYMMDD  VARCHAR2(8 CHAR);
    V_CREATE_TO_YYYYMMDD    VARCHAR2(8 CHAR);

BEGIN
    O_RETURN := 1;  /* 반환값 초기화 */
    V_BATCH_USER := V_USER_ID;

    DBMS_OUTPUT.PUT_LINE('Start of PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK');  /* PRINT */

    /* ------------------------------------------------------------------------------------------------------------------ */
    /* [PJ20257329] 2025.08.01  Cell 완성 공정 하드코딩 변경 */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' SCP Cell Final 공정 정보 - Cell Packaging/Assembly');  /* print */
    /* ------------------------------------------------------------------------------------------------------------------ */
    /* #SCP_CELL_FINAL_OPERATION : 한 번만 쓰이므로 아래 PROD_LINE 추가 INSERT 의 인라인 뷰(IC)로 옮김 */
    /*   LK.SEGMENT3	  = 'A'	 -- 공정그룹 (Cell) */
    /*   LK.ATTRIBUTE1  = 'Y'	 -- Final Operation */
    /* ------------------------------------------------------------------------------------------------------------------ */

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

    BEGIN  /* BEGIN TRY */
        N_SEQ := TO_NUMBER(P_SEQ);
        /*
        ALTER TABLE SCP_XLS_PSI_GLOBAL_SMALL_PACK
        ADD YIELD	NUMERIC(20,10) DEFAULT '0'
        */

        /* 원본 SELECT @v_bp_flag = .. : 행이 없으면 변수는 그대로('') */
        BEGIN
            SELECT CASE WHEN TO_DATE(HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(PLAN_NAME, 'YYYYMMDD') > 364 THEN 'Y' ELSE 'N' END
              INTO V_BP_FLAG
              /* --				, @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end) */
              FROM SCM_MST_PLAN
             WHERE DIVISION_ID = V_DIVISION_ID
               AND PLAN_ID     = (SELECT MAX(SA.PLAN_ID)
                                    FROM SCM_MST_PLAN SA
                                   WHERE SA.DIVISION_ID       = V_DIVISION_ID
                                     AND TO_NUMBER(SA.PLAN_ID) < 9999);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;

        V_TO_YYYYMMDD := CASE WHEN V_BP_FLAG = 'Y' THEN TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364 * 2, 'YYYYMMDD')
                              ELSE TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD')
                         END;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 정보 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 세팅값 추출 */
        /* #MEASURE → GT_XSPK_MEASURE */
        DELETE
          FROM GT_XSPK_MEASURE;

        /* --              INSERT INTO #MEASURE */
        INSERT
          INTO GT_XSPK_MEASURE
             ( COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
             , DIV
             , GUBUN
             )
        SELECT COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
             , CASE WHEN ATTRIBUTE1 = 'PACK' THEN 'P' WHEN ATTRIBUTE1 = 'CELL' THEN 'A' ELSE 'C' END AS DIV
             , ATTRIBUTE2 AS GUBUN  /* --,ATTRIBUTE1 */
          /* --SELECT * */
          FROM SCM_MST_SHEET_MEASURE
         WHERE PROGRAM_ID = V_PROGRAM_ID
           AND VALID_YN   = 'Y';

        /* ------------------------------------------------------------------------------------------------------------- */
        /* SCP_ANL_PSI_GLOBAL_SMALL  데이터 이관 ('SHIP_REQ','SHIP_PLAN','PRODUCTION') */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #PSI_GLOBAL_SMALL_PACK → GT_XSPK_PSI_GLOBAL_SMALL_PACK (원본 CREATE TABLE 칸 정의는 GTT DDL 로 옮김) */
        /* 원본 CREATE TABLE 칸 주석 :
           --                ,BOM_DESC             NVARCHAR(100)
           PROJECT_CODE         NVARCHAR(050)     --
           TO_BOH_QTY  numeric(20,10)    -- BIGINT
           FROM_BOH_QTY numeric(20,10)    -- BIGINT
           --                ,END_CUSTOMER         NVARCHAR(50)
           ATTRIBUTE9 NVARCHAR(150)   -- OPERATION_ID
        */
        /* 원본 '' AS PROJECT_CODE 는 Oracle 에서 NULL 이다. 이 칸은 원본에서 NULL 이 생기지 않으므로 NULL ⇔ '' 로 보고 비교한다. */
        DELETE
          FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK;

        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , SUBSTR(A.CELL_ITEM_ID, 1, 100)  AS CELL_ITEM_ID
             , A.ITEM_ID
             , CASE WHEN TRIM(A.TO_SITE) IS NULL THEN '-' ELSE A.TO_SITE END AS TO_SITE  /* isnull(NULLIF(A.TO_SITE, '') , '-') */
             , NULL                            AS PROJECT_CODE  /* '' */
             , 0                               AS TO_BOH_QTY
             , 0                               AS FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , NULL                            AS TRANSPORT_MODE
             , NULL                            AS PROD_LINE
             , SUBSTR(B.COLUMN_NAME, 1, 100)   AS MEASURE
             , A.YYYYMMDD
             , NVL(A.QTY, 0)                   AS QTY  /* 기존 INTRANSIT 무시하고 모두 0 */
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , A.BOD_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , NULL                            AS WEEK_COLUMN
          FROM SCP_ANL_PSI_GLOBAL_SMALL A
             , GT_XSPK_MEASURE B
         WHERE B.COLUMN_NAME           = CASE WHEN A.MEASURE = 'PRODUCTION' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                                              WHEN A.MEASURE = 'SHIP_PLAN'  AND A.OPERATION_GROUP = 'P' THEN 'PACK_SHIP_PLAN'
                                              WHEN A.MEASURE = 'SHIP_PLAN'  AND A.OPERATION_GROUP = 'A' THEN 'CELL_SHIP_PLAN'
                                              ELSE A.MEASURE
                                         END
           AND A.MEASURE               IN ('SHIP_REQ', 'PRODUCTION', 'SHIP_PLAN')
           AND A.DIVISION_ID            = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD    = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE              = P_PLAN_TYPE
           AND A.SEQ                    = N_SEQ
           AND A.YYYYMMDD              >= V_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD              <= V_TO_YYYYMMDD;  /* --말일포함(KSK, 20240814) */

        /* ------------------------------------------------------------------------------------------------------------- start */
        /* ISUZU SCP_ANL_SHIPMENT_PLAN_SEMI  데이터 이관 ('SHIP_REQ','SHIP_PLAN') */
        /* * PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 원본 COUNT(*) = 0 판정 → 1건 존재 확인 */
        SELECT COUNT(*)
          INTO N_ISUZU_CNT
          FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK
         WHERE MEASURE    IN ('SHIP_REQ', 'PRODUCTION', 'SHIP_PLAN')
           AND ATTRIBUTE9 = 'P5000'
           AND ROWNUM     = 1;

        IF N_ISUZU_CNT = 0 THEN

            /* 원본 SELECT TOP 1 (ORDER BY 없음) → ROWNUM = 1 */
            INSERT
              INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
                 , TRANSPORT_MODE_LINE
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
                 , ATTRIBUTE10
                 , WEEK_COLUMN
                 )
            SELECT IA.DIVISION_ID
                 , IA.OPERATION_GROUP
                 , (SELECT SA.CHILD_ITEM_ID
                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V SA
                     WHERE SA.DIVISION_ID        = IA.DIVISION_ID
                       AND SA.MODEL_ID           = (SELECT SB.MODEL_ID
                                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V SB
                                                     WHERE SB.DIVISION_ID   = IA.DIVISION_ID
                                                       AND SB.CHILD_ITEM_ID = IA.ITEM_ID
                                                       AND ROWNUM           = 1)
                       AND SA.OPERATION_GROUP_ID = 'A'
                       AND ROWNUM                = 1) AS CELL_ITEM_ID
                 , IA.ITEM_ID
                 , IA.TO_SITE
                 , IA.PROJECT_CODE
                 , IA.TO_BOH_QTY
                 , IA.FROM_BOH_QTY
                 , IA.INCOTERMS
                 , IA.FROM_SITE
                 , NULL                         AS TRANSPORT_MODE_LINE
                 , IA.TRANSPORT_MODE
                 , IA.PROD_LINE
                 , IA.MEASURE
                 , IA.YYYYMMDD
                 , IA.QTY
                 , IA.SORT_ORDER_NO
                 , IA.COLUMN_LABEL_NAME
                 , MAX(IA.BOD_ID)               AS BOD_ID  /* -- */
                 , IA.ATTRIBUTE1
                 , (SELECT SC.FLOW_ID
                      FROM SCM_MST_ITEM_SN SC
                     WHERE SC.DIVISION_ID = IA.DIVISION_ID
                       AND SC.ITEM_ID     = IA.ITEM_ID
                       AND ROWNUM         = 1) AS ATTRIBUTE9
                 , NULL                         AS ATTRIBUTE10
                 , NULL                         AS WEEK_COLUMN
              FROM ( SELECT A.DIVISION_ID
                          , A.OPERATION_GROUP
                          , NULL                          AS CELL_ITEM_ID  /* '' */
                          , A.ITEM_ID
                          , CASE WHEN TRIM(A.TO_SITE) IS NULL THEN '-' ELSE A.TO_SITE END AS TO_SITE  /* ISNULL(NULLIF(A.TO_SITE, '') , '-') */
                          , '-'                           AS PROJECT_CODE
                          , 0                             AS TO_BOH_QTY
                          , 0                             AS FROM_BOH_QTY
                          , '-'                           AS INCOTERMS
                          , A.FROM_SITE
                            /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                          , NVL((SELECT SD.TRANSPORT_MODE
                                   FROM SCP_MST_BOD_N_V SD
                                  WHERE SD.DIVISION_ID = A.DIVISION_ID
                                    AND SD.BOD_ID      = A.BOD_ID
                                    AND SD.FROM_SITE   = A.FROM_SITE
                                    AND ROWNUM         = 1), '-') AS TRANSPORT_MODE
                          , '-'                           AS PROD_LINE
                          , SUBSTR(B.COLUMN_NAME, 1, 100) AS MEASURE
                          , A.YYYYMMDD
                          , NVL(A.QTY, 0)                 AS QTY  /* 기존 INTRANSIT 무시하고 모두 0 */
                          , B.SORT_ORDER_NO
                          , B.COLUMN_LABEL_NAME
                          , A.BOD_ID
                          , 'SCP_ANL_SHIPMENT_PLAN_SEMI'  AS ATTRIBUTE1
                          , A.ATTRIBUTE9
                       FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                            /* --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) */
                            /* --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD */
                          , GT_XSPK_MEASURE B
                      WHERE B.COLUMN_NAME           IN ('PACK_SHIP_PLAN', 'SHIP_REQ')
                        AND CASE A.MEASURE WHEN 'SHIP_PLAN' THEN 'PACK_SHIP_PLAN' ELSE A.MEASURE END = B.COLUMN_NAME
                        AND A.ITEM_ID IN (SELECT DISTINCT
                                                 IB.CHILD_ITEM_ID
                                            FROM ( SELECT C.DIVISION_ID
                                                        , C.CHILD_ITEM_ID
                                                     FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V C
                                                    WHERE C.DIVISION_ID = V_DIVISION_ID
                                                      AND C.MODEL_ID IN (SELECT DISTINCT
                                                                                D.ITEM_ID
                                                                           FROM SCM_MST_ITEM_SN D
                                                                          WHERE D.DIVISION_ID = V_DIVISION_ID
                                                                            AND D.ACTIVE_FLAG = 'Y'
                                                                            AND D.NICK_NAME   LIKE '%ISUZU%'
                                                                            AND D.ITEM_TYPE   = 'P')
                                                 ) IB
                                               , SCM_MST_ITEM_SN E
                                           WHERE IB.DIVISION_ID   = E.DIVISION_ID
                                             AND IB.CHILD_ITEM_ID = E.ITEM_ID
                                             AND E.NICK_NAME      LIKE '%ISUZU%'
                                             AND E.ITEM_TYPE      = 'P')
                        AND A.MEASURE               IN ('SHIP_PLAN', 'SHIP_REQ')
                        AND A.DIVISION_ID            = V_DIVISION_ID
                        AND A.PLAN_START_YYYYMMDD    = V_PLAN_START_YYYYMMDD
                        AND A.PLAN_TYPE              = P_PLAN_TYPE
                        AND A.SEQ                    = N_SEQ
                        AND A.YYYYMMDD              >= V_PLAN_START_YYYYMMDD
                        AND A.YYYYMMDD              <= V_TO_YYYYMMDD  /* --말일포함(KSK, 20240814) */
                   ) IA
             GROUP BY IA.DIVISION_ID
                    , IA.OPERATION_GROUP
                    , IA.CELL_ITEM_ID
                    , IA.ITEM_ID
                    , IA.TO_SITE
                    , IA.PROJECT_CODE
                    , IA.TO_BOH_QTY
                    , IA.FROM_BOH_QTY
                    , IA.INCOTERMS
                    , IA.FROM_SITE
                    , IA.TRANSPORT_MODE
                    , IA.PROD_LINE
                    , IA.MEASURE
                    , IA.YYYYMMDD
                    , IA.QTY
                    , IA.SORT_ORDER_NO
                    , IA.COLUMN_LABEL_NAME
                    , IA.ATTRIBUTE1
                    , IA.ATTRIBUTE9;

            /* ISUZU SCP_ANL_SHIPMENT_PLAN_SEMI  데이터 이관 ('PACK_PROD') */
            INSERT
              INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
                 , TRANSPORT_MODE_LINE
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
                 , ATTRIBUTE10
                 , WEEK_COLUMN
                 )
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , (SELECT SA.CHILD_ITEM_ID
                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V SA
                     WHERE SA.DIVISION_ID        = A.DIVISION_ID
                       AND SA.MODEL_ID           = (SELECT SB.MODEL_ID
                                                      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V SB
                                                     WHERE SB.DIVISION_ID   = A.DIVISION_ID
                                                       AND SB.CHILD_ITEM_ID = A.ITEM_ID
                                                       AND ROWNUM           = 1)
                       AND SA.OPERATION_GROUP_ID = 'A'
                       AND ROWNUM                = 1) AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , '-'                          AS TO_SITE
                 , '-'                          AS PROJECT_CODE
                 , 0                            AS TO_BOH_QTY
                 , 0                            AS FROM_BOH_QTY
                 , '-'                          AS INCOTERMS
                 , A.SCM_SITE_ID                AS FROM_SITE
                 , NULL                         AS TRANSPORT_MODE_LINE
                 , '-'                          AS TRANSPORT_MODE
                 , A.LINE_ID                    AS PROD_LINE
                 , SUBSTR(B.COLUMN_NAME, 1, 100) AS MEASURE
                 , A.YYYYMMDD
                 , SUM(A.QTY)                   AS QTY
                 , B.SORT_ORDER_NO
                 , B.COLUMN_LABEL_NAME
                 , '-'                          AS BOD_ID
                 , 'SCP_ANL_PRODUCTION_PLAN'    AS ATTRIBUTE1
                 , A.OPERATION_ID               AS ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , NULL                         AS WEEK_COLUMN
              FROM SCP_ANL_PRODUCTION_PLAN A
                   /* --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) */
                   /* --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD */
                 , GT_XSPK_MEASURE B
             WHERE B.COLUMN_NAME           IN ('PACK_PROD')
               AND CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                        WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                        ELSE '-'
                   END = B.COLUMN_NAME
               AND A.ITEM_ID IN (SELECT DISTINCT
                                        IB.CHILD_ITEM_ID
                                   FROM ( SELECT C.DIVISION_ID
                                               , C.CHILD_ITEM_ID
                                            FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V C
                                           WHERE C.DIVISION_ID = V_DIVISION_ID
                                             AND C.MODEL_ID IN (SELECT DISTINCT
                                                                       D.ITEM_ID
                                                                  FROM SCM_MST_ITEM_SN D
                                                                 WHERE D.DIVISION_ID = V_DIVISION_ID
                                                                   AND D.ACTIVE_FLAG = 'Y'
                                                                   AND D.NICK_NAME   LIKE '%ISUZU%'
                                                                   AND D.ITEM_TYPE   = 'P')
                                        ) IB
                                      , SCM_MST_ITEM_SN E
                                  WHERE IB.DIVISION_ID   = E.DIVISION_ID
                                    AND IB.CHILD_ITEM_ID = E.ITEM_ID
                                    AND E.NICK_NAME      LIKE '%ISUZU%'
                                    AND E.ITEM_TYPE      = 'P')
               AND A.LINE_ID               <> '-'
               AND A.DIVISION_ID            = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD    = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE              = P_PLAN_TYPE
               AND A.SEQ                    = N_SEQ
             GROUP BY A.DIVISION_ID
                    , A.OPERATION_GROUP
                    , A.ITEM_ID
                    , A.SCM_SITE_ID
                    , A.LINE_ID
                    , B.COLUMN_NAME
                    , A.YYYYMMDD
                    , B.SORT_ORDER_NO
                    , B.COLUMN_LABEL_NAME
                    , A.OPERATION_ID
                    , A.ATTRIBUTE10;
        END IF;
        /* ------------------------------------------------------------------------------------------------------------- end */

        /* FG의 PROJECT_CODE 값이 다른 경우 UPDATE 로직 추가 */
        /* SCP_ANL_SHIPMENT_PLAN_FG SHIP_PLAN 입력 (FG) 로직으로 임시테이블 생성 */
        /* ------------------------------------------------------------------------------------------ */
        /* #tmp_SCP_ANL_SHIPMENT_PLAN_FG → GT_XSPK_TMP_SHIPMENT_PLAN_FG */
        DELETE
          FROM GT_XSPK_TMP_SHIPMENT_PLAN_FG;

        /* FG */
        /* 원본 LEFT OUTER JOIN B .. WHERE B.DIVISION_ID is not null → 내부조인과 같음 · ON 절의 A 조건은 WHERE 와 같아 WHERE 로 둠 */
        INSERT
          INTO GT_XSPK_TMP_SHIPMENT_PLAN_FG
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , PROJECT_CODE
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , BOD_ID
             , TRANSPORT_MODE
             , MEASURE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT IA.DIVISION_ID
             , IA.PLAN_START_YYYYMMDD
             , IA.PLAN_TYPE
             , IA.SEQ
             , MAX(IA.OPERATION_GROUP)      AS OPERATION_GROUP
             , NVL(IA.PROJECT_CODE, '-')    AS PROJECT_CODE
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.BOD_ID
             , IA.TRANSPORT_MODE
             , IA.MEASURE
             , IA.YYYYMMDD
             , SUM(IA.QTY)                  AS QTY  /* -- sum */
             , 'SCP_ANL_SHIPMENT_PLAN_FG'   AS ATTRIBUTE1
          FROM ( SELECT B.DIVISION_ID
                      , B.PLAN_START_YYYYMMDD  /* -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0) */
                      , B.PLAN_TYPE
                      , B.SEQ
                      , B.OPERATION_GROUP
                      , A.PROJECT_CODE
                      , B.ITEM_ID
                      , B.TO_SITE
                      , CASE WHEN B.INCOTERMS <> '-' AND B.INCOTERMS IS NOT NULL THEN B.INCOTERMS
                             ELSE (SELECT SA.INCOTERMS
                                     FROM SCP_MST_BOD_N_V SA  /* -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                                    WHERE SA.DIVISION_ID = B.DIVISION_ID
                                      AND SA.BOD_ID      = B.BOD_ID
                                      AND ROWNUM         = 1)
                        END AS INCOTERMS
                      , B.FROM_SITE
                      , B.BOD_ID
                      , B.TRANSPORT_MODE
                      , B.MEASURE
                      , B.YYYYMMDD
                      , A.ALLOCATION_QTY       AS QTY
                   FROM SCP_PLN_SHIPMENT_PLAN_PEGGING A
                      , SCP_PLN_SHIPMENT_PLAN B
                  WHERE A.DIVISION_ID          = B.DIVISION_ID
                    AND A.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD
                    AND A.PLAN_TYPE            = B.PLAN_TYPE
                    AND A.SEQ                  = B.SEQ
                    AND A.ORDER_ID             = B.ORDER_ID
                    AND B.MEASURE              = 'SHIP_PLAN'
                    AND B.SEMI_YN              = 'N'
                    /* --AND A.ENG_DEMAND_ID        <> 'UNPEGGING' */
                    AND A.DIVISION_ID          = V_DIVISION_ID
                    AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                    AND A.PLAN_TYPE            = P_PLAN_TYPE
                    AND A.SEQ                  = N_SEQ
               ) IA
         GROUP BY IA.DIVISION_ID
                , IA.PLAN_START_YYYYMMDD
                , IA.PLAN_TYPE
                , IA.SEQ
                , NVL(IA.PROJECT_CODE, '-')
                , IA.ITEM_ID
                , IA.TO_SITE
                , IA.INCOTERMS
                , IA.FROM_SITE
                , IA.TRANSPORT_MODE
                , IA.BOD_ID
                , IA.MEASURE
                , IA.YYYYMMDD;

        /* ------------------------------------------------------------------------------------------ */
        /* PROJECT_CODE UPDATE */
        /* ------------------------------------------------------------------------------------------ */
        /* 원본 UPDATE .. FROM JOIN : 한 행에 여러 PROJECT_CODE 가 걸리면 MSSQL 은 임의 1건 → MAX 로 고정 */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT DIVISION_ID
                     , ITEM_ID
                     , TO_SITE
                     , FROM_SITE
                     , YYYYMMDD
                     , MAX(PROJECT_CODE) AS PROJECT_CODE
                  FROM GT_XSPK_TMP_SHIPMENT_PLAN_FG
                 GROUP BY DIVISION_ID
                        , ITEM_ID
                        , TO_SITE
                        , FROM_SITE
                        , YYYYMMDD
              ) IA
           ON (     A.DIVISION_ID = IA.DIVISION_ID
                AND A.ITEM_ID     = IA.ITEM_ID
                AND A.TO_SITE     = IA.TO_SITE
                AND A.FROM_SITE   = IA.FROM_SITE
                AND A.YYYYMMDD    = IA.YYYYMMDD
                AND A.MEASURE     = 'PACK_SHIP_PLAN' )
         WHEN MATCHED THEN
       UPDATE
          SET A.PROJECT_CODE = IA.PROJECT_CODE;

        /* SSP입력(CELL_SHIP_PLAN_SSP) */
        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.BIZ_TYPE                   AS OPERATION_GROUP
             , A.ITEM_ID                    AS CELL_ITEM_ID
             , A.ITEM_ID
             , CASE WHEN TRIM(A.TO_SITE) IS NULL THEN '-' ELSE A.TO_SITE END AS TO_SITE  /* ISNULL(NULLIF(A.TO_SITE, '') , '-') */
             , NULL                         AS PROJECT_CODE  /* '' */
             , 0                            AS TO_BOH_QTY
             , 0                            AS FROM_BOH_QTY
             , C.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE             AS TRANSPORT_MODE_LINE
             , A.TRANSPORT_MODE
             , NULL                         AS PROD_LINE
             , SUBSTR(B.COLUMN_NAME, 1, 100) AS MEASURE
             , A.YYYYMMDD
             , NVL(A.QTY, 0)                AS QTY
             , B.SORT_ORDER_NO
             , B.COLUMN_LABEL_NAME
             , A.BOD_ID
             , 'SSP_ANL_SHIP_REQ'           AS ATTRIBUTE1
             , A.ATTRIBUTE9                               /* -- operation_id */
             , '3'                          AS ATTRIBUTE10  /* -- 3 */
             , NULL                         AS WEEK_COLUMN
          /* --                FROM SSP_ANL_SHIP_REQ A  WITH (NOLOCK) */
          FROM SSP_ANL_SHIP_CONFIRM A
             , GT_XSPK_MEASURE B
             , GT_XSPK_PSI_GLOBAL_SMALL_PACK C
         WHERE C.ITEM_ID         = A.ITEM_ID
           AND C.FROM_SITE       = A.FROM_SITE
           AND C.TO_SITE         = A.TO_SITE
           AND B.COLUMN_NAME     = 'CELL_SHIP_PLAN_SSP'
           AND C.OPERATION_GROUP = 'A'
           AND A.TO_SITE        <> '-'
           AND A.QTY             > 0.0  /* 수량이 있는 경우에만 TRANSPORT_MODE가 있음. */
           AND A.CHANGE_TYPE     = 'C'  /* 250306, KSK, 승인은 'C', 승인전은 'N' */
           AND A.YYYYMMDD       >= V_PLAN_START_YYYYMMDD;

        /* SSP_ANL_SHIP_REQ 에서 가져온 CELL_SHIP_PLAN_SSP OPERATION_ID 추가 */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING SCP_MST_FINAL_ITEM B
           ON (     A.ITEM_ID     = B.ITEM_ID
                AND A.DIVISION_ID = B.DIVISION_ID
                AND A.ATTRIBUTE1  = 'SSP_ANL_SHIP_REQ' )
         WHEN MATCHED THEN
       UPDATE
          SET A.ATTRIBUTE9 = SUBSTR(B.FLOW_ID, 1, 5);  /* -- OPERATION_ID */

        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING SCM_MST_SITE B
           ON (     B.DIVISION_ID = A.DIVISION_ID
                AND B.SCM_SITE_ID = A.FROM_SITE
                AND B.OSP_YN      = 'Y'
                AND A.ATTRIBUTE1  = 'SSP_ANL_SHIP_REQ' )
         WHEN MATCHED THEN
       UPDATE
          SET A.ATTRIBUTE9 = B.PLANT_ID;

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* SCP_MST_OUTSOURCING_CAPA --> PACK_PROD로 입력 */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT A.DIVISION_ID
             , 'P'                          AS OPERATION_GROUP
             , (SELECT SA.CELL_ITEM_ID
                  FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK SA
                 WHERE SA.ITEM_ID = A.ITEM_ID
                   AND ROWNUM     = 1) AS CELL_ITEM_ID
             , A.ITEM_ID
             , '-'                          AS TO_SITE
             , NULL                         AS PROJECT_CODE  /* '' -- 이후 UDPATE */
             , 0                            AS TO_BOH_QTY
             , 0                            AS FROM_BOH_QTY
             , '-'                          AS INCOTERMS
             , A.PLANT_SITE_ID              AS FROM_SITE
             , '-'                          AS TRANSPORT_MODE_LINE
             , NULL                         AS TRANSPORT_MODE
             , NULL                         AS PROD_LINE
             , 'PACK_PROD'                  AS MEASURE
             , D.BASIS_YYYYMMDD             AS YYYYMMDD
             , 0                            AS QTY  /* '0' */
             , C.SORT_ORDER_NO
             , C.COLUMN_LABEL_NAME
             , '-'                          AS BOD_ID
             , 'SCP_MST_OUTSOURCING_CAPA'   AS ATTRIBUTE1
             , 'ATTRIBUTE9'                 AS ATTRIBUTE9  /* -- OPERATION_ID */
             , '1'                          AS ATTRIBUTE10
             , NULL                         AS WEEK_COLUMN
          FROM SCP_MST_OUTSOURCING_CAPA A
             , SCM_MST_SITE_ITEM_PRIORITY B  /* -- -- DIVISION_ID, PLANT_SITE_ID, ITEM_ID */
             , GT_XSPK_MEASURE C
             , SCM_SYS_CALENDAR_M D
         WHERE A.DIVISION_ID     = B.DIVISION_ID
           AND A.ITEM_ID         = B.ITEM_ID
           AND A.PLANT_SITE_ID   = B.PLANT_SITE_ID
           AND A.ITEM_ID IN (SELECT DISTINCT
                                    XA.ITEM_ID
                               FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK XA)
           AND B.VALID_YN        = 'Y'
           AND C.COLUMN_NAME     = 'PACK_PROD'
           AND A.DIVISION_ID     = V_DIVISION_ID
           AND D.BASIS_YYYYMMDD >= V_PLAN_START_YYYYMMDD
           AND D.BASIS_YYYYMMDD <= V_TO_YYYYMMDD;  /* --말일포함(KSK, 20240814) */

        /* SCP_ANL_PSI_GLOBAL_SMALL, SCP_MST_OUTSOURCING_CAPA 중에 중복될 경우 삭제 */
        /* 원본 DELETE TBL FROM (SELECT ROW_NUMBER() .. AS ROWNUM ..) AS TBL WHERE TBL.ROWNUM > 1 → ROWID 로 지움 · ATTRIBUTE1 정렬은 MSSQL 정렬규칙(FN_ASIS_SORT_KEY) */
        DELETE
          FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK
         WHERE ROWID IN (SELECT IA.RID
                           FROM ( SELECT ROWID AS RID
                                       , ROW_NUMBER() OVER (PARTITION BY OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, INCOTERMS, FROM_SITE, MEASURE, YYYYMMDD
                                                                ORDER BY FN_ASIS_SORT_KEY(ATTRIBUTE1) NULLS FIRST) AS RN
                                       /* --                                 ,* */
                                    FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK
                                   WHERE MEASURE IN ('PACK_PROD')
                                ) IA
                          WHERE IA.RN > 1);

        /* SCP_MST_OUTSOURCING_CAPA 에서 가져온 PACK_PROD OPERATION_ID 추가 */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING SCP_MST_FINAL_ITEM B
           ON (     A.ITEM_ID     = B.ITEM_ID
                AND A.DIVISION_ID = B.DIVISION_ID
                AND A.ATTRIBUTE1  = 'SCP_MST_OUTSOURCING_CAPA' )
         WHEN MATCHED THEN
       UPDATE
          SET A.ATTRIBUTE9 = SUBSTR(B.FLOW_ID, 1, 5);  /* -- OPERATION_ID */

        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING SCM_MST_SITE B
           ON (     B.DIVISION_ID = A.DIVISION_ID
                AND B.SCM_SITE_ID = A.FROM_SITE
                AND B.OSP_YN      = 'Y'
                AND A.ATTRIBUTE1  = 'SCP_MST_OUTSOURCING_CAPA' )
         WHEN MATCHED THEN
       UPDATE
          SET A.ATTRIBUTE9 = B.PLANT_ID;

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK TO SITE별 */
        /*
                        DM_MKT_FCST	          MKT FCST					10	PACK,TO_SITE    DB
                        WHIN_TOTAL			  WH In						30	PACK,TO_SITE    CAL
                        TO_SITE_BOH	          Model inventory(BOH)	80	PACK,TO_SITE    DB
                        TO_SITE_EOH	          Model inventory(EOH)	90	PACK,TO_SITE    DB

                        SHIP_REQ					Ship Req					20	PACK,TO_SITE    DB
                        SHIP_PLAN_TOTAL	      Ship Plan	            40	PACK,TO_SITE    CAL
                        INTRANSIT_TOTAL	      In transit				50	PACK,TO_SITE    CAL
                        BALANCE						Balance					60	PACK,TO_SITE    CAL
                        BALANCE_CUM	          Balance(cum)	        70	PACK,TO_SITE    CAL
        */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* 원본 LEFT OUTER JOIN #MEASURE M ON DIV ='C' AND GUBUN = 'TO' (상수 조건만) : 짝이 없으면 MEASURE 가 NULL 이고
           뒤의 SUB.MEASURE <> 'SHIP_REQ' 에서 떨어지므로 내부조인과 결과가 같다 */
        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , CASE WHEN IA.MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN '-' ELSE IA.FROM_SITE END           AS FROM_SITE
             , CASE WHEN IA.MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN '-' ELSE IA.TRANSPORT_MODE_LINE END AS TRANSPORT_MODE_LINE
             , CASE WHEN IA.MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN '-' ELSE IA.TRANSPORT_MODE END      AS TRANSPORT_MODE
             , IA.PROD_LINE
             , IA.MEASURE
             , IA.YYYYMMDD
             , 0                            AS QTY
             , IA.SORT_ORDER_NO
             , IA.COLUMN_LABEL_NAME
             , CASE WHEN IA.MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN '-' ELSE IA.BOD_ID END              AS BOD_ID
             , IA.ATTRIBUTE1
             , CASE WHEN IA.MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN NULL ELSE IA.ATTRIBUTE9 END         AS ATTRIBUTE9
             , IA.ATTRIBUTE10
             , NULL                         AS WEEK_COLUMN
          FROM ( /* 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가 - start */
                 SELECT IB.DIVISION_ID
                      , IB.OPERATION_GROUP
                      , IB.CELL_ITEM_ID
                      , IB.ITEM_ID
                      , IB.TO_SITE
                      , IB.PROJECT_CODE
                      , IB.TO_BOH_QTY
                      , IB.FROM_BOH_QTY
                      , IB.INCOTERMS
                      , IB.FROM_SITE
                      , IB.TRANSPORT_MODE_LINE
                      , IB.TRANSPORT_MODE
                      , IB.PROD_LINE
                      , IB.MEASURE
                      , IC.YYYYMMDD
                      , IB.SORT_ORDER_NO
                      , IB.COLUMN_LABEL_NAME
                      , IB.BOD_ID
                      , IB.ATTRIBUTE1
                      , IB.ATTRIBUTE9
                      , IB.ATTRIBUTE10
                   FROM ( SELECT DISTINCT
                                 A.DIVISION_ID
                               , A.OPERATION_GROUP
                               , A.CELL_ITEM_ID
                               , A.ITEM_ID
                               , A.TO_SITE
                               , NULL                         AS PROJECT_CODE  /* '' */
                               , A.TO_BOH_QTY
                               , A.FROM_BOH_QTY
                               , A.INCOTERMS
                               , A.FROM_SITE
                               , A.TRANSPORT_MODE_LINE
                               , A.TRANSPORT_MODE
                               , A.PROD_LINE
                               , SUBSTR(B.COLUMN_NAME, 1, 100) AS MEASURE
                                 /* --, X.YYYYMMDD */
                               , B.SORT_ORDER_NO
                               , B.COLUMN_LABEL_NAME
                               , A.BOD_ID
                               , A.ATTRIBUTE1
                               , A.ATTRIBUTE9
                               , A.ATTRIBUTE10
                            FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK A
                               , GT_XSPK_MEASURE B
                           WHERE B.DIV     = 'C'
                             AND B.GUBUN   = 'TO'
                             AND A.MEASURE = 'SHIP_REQ'
                        ) IB
                      , ( SELECT BASIS_YYYYMMDD AS YYYYMMDD
                            FROM SCM_SYS_CALENDAR_M
                           WHERE BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_TO_YYYYMMDD
                        ) IC
                 /* 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가 - end */
               ) IA
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK XA
                            WHERE XA.DIVISION_ID         = IA.DIVISION_ID
                              AND XA.OPERATION_GROUP     = IA.OPERATION_GROUP
                              AND XA.CELL_ITEM_ID        = IA.CELL_ITEM_ID
                              AND XA.ITEM_ID             = IA.ITEM_ID
                              AND XA.TO_SITE             = IA.TO_SITE
                              AND XA.TO_BOH_QTY          = IA.TO_BOH_QTY
                              AND XA.FROM_BOH_QTY        = IA.FROM_BOH_QTY
                              AND XA.INCOTERMS           = IA.INCOTERMS
                              AND XA.FROM_SITE           = IA.FROM_SITE
                              AND XA.TRANSPORT_MODE_LINE = IA.TRANSPORT_MODE_LINE
                              AND XA.MEASURE             = IA.MEASURE
                              AND XA.YYYYMMDD            = IA.YYYYMMDD
                              AND XA.BOD_ID              = IA.BOD_ID
                              AND XA.ATTRIBUTE1          = IA.ATTRIBUTE1
                              AND XA.ATTRIBUTE9          = IA.ATTRIBUTE9
                              AND XA.ATTRIBUTE10         = IA.ATTRIBUTE10)
           AND IA.MEASURE <> 'SHIP_REQ';

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK TO SITE별 (DM_MKT_FCST) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* #DM_MKT_FCST → GT_XSPK_DM_MKT_FCST */
        DELETE
          FROM GT_XSPK_DM_MKT_FCST;

        V_DT1        := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');  /* -- 화요일 */
        V_DT2        := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD');  /* -- 화요일-7(전주) */
        V_VERSION_NO := '';

        /* --원본교체로 사용안함( KSK, 2024/11/12) */
        /* --    SELECT @p_version_no = MAX(VERSION_NO) */
        /* --    FROM  DBO.DM_PLN_MKT_FCST_C P WITH(NOLOCK) */
        /* --    WHERE P.DIVISION_ID       = @p_division_id */
        /* --      AND P.CUTOFF_TYPE       IN ('MF_W','MF_M') */
        /* --      AND P.MEASURE           = 'MKT_FCST' */
        /* --      AND P.CREATION_DATE   = ( */
        /* --                                SELECT MAX(X.CREATION_DATE) -- 강제 수정 DATA 일 경우 포함 하기 위해서 */
        /* --                                FROM   DBO.DM_PLN_MKT_FCST_C X WITH(NOLOCK) */
        /* --                                WHERE  X.DIVISION_ID      = @p_division_id */
        /* --                                  AND  X.CUTOFF_TYPE      IN ('MF_W','MF_M') */
        /* --                                  AND  X.MEASURE          = 'MKT_FCST' */
        /* --                                  AND  X.CUTOFF_YYYYMMDD <= @p_dt1 -- 화요일 -- */
        /* --                                  AND  X.CUTOFF_YYYYMMDD >= @p_dt2  -- 화요일-3일 --'20190219' */
        /* --                              GROUP BY  DIVISION_ID */
        /* --                                ) */
        /* --GROUP BY  DIVISION_ID, CREATION_DATE */

        /* 2023-01-13   KKH			소형팩 시뮬레이터 mkt_fcst수량 수정 (최종 월에 해당하는 값만 업데이트 -> 여러건을 group by에서 최종값 연결) */
        /* 원본 ISNULL(aa.attribute10, '') = '' : 기준 DB 에는 옛 빈 문자('')가 공백(' ')으로, 새로 쌓인 빈 값이 '-' 로 들어 있음 → 공백·NULL·'-' 를 빈 값으로 봄 */
        INSERT
          INTO GT_XSPK_DM_MKT_FCST
             ( YYYYMMDD
             , DIVISION_ID
             , ITEM_ID
             , SCM_SITE_ID
             , INCOTERMS
             , QTY
             )
        SELECT IA.YYYYMMDD
             , IA.DIVISION_ID
             , IA.ITEM_ID
             , IA.SCM_SITE_ID
             , IA.INCOTERMS
             , SUM(IA.QTY) AS QTY
          FROM ( SELECT A.DIVISION_ID
                      , A.PROJECT_CODE
                      , A.SCM_SITE_ID
                      , A.ITEM_ID
                      , A.DOM_EXP
                      , A.FCST_TYPE
                      , A.INCOTERMS
                      , A.PLANT_SITE_ID
                      , A.YYYYMMDD
                      , A.QTY
                        /* --                           , AA.MEASURE */
                      , 'DM_MKT_FCST' AS MEASURE
                   /* --원본교체 DM_PLN_MKT_FCST_C => DM_PLN_MKT_FCST  ( KSK, 2024/11/12) */
                   FROM DM_PLN_MKT_FCST A
                        /* -- VMI 비대상 SITE 조회 */
                      , ( SELECT DIVISION_ID
                               , SCM_SITE_ID
                               , VMI_YN
                               , OPERATION_GROUP
                            FROM SCM_MST_SITE
                           WHERE DIVISION_ID = V_DIVISION_ID
                             AND VALID_YN    = 'Y'
                        ) IB
                  WHERE A.DIVISION_ID = IB.DIVISION_ID
                    AND A.SCM_SITE_ID = IB.SCM_SITE_ID
                    /* -- 2018.07.06 참고) DM_PLN_MKT_FCST 관련 수정 시 PR_SCP_ENG_IN_SP_SET_INVENTORY 프로시저의 DM_PLN_MKT_FCST 테이블 사용부분도 수정해야함 */
                    /* -- 2018.07.03   DEMAND 기준을 DAILY CUTOFF FCST에서 실시간 MKT FCST로 변경 : CUTOFF 조건 제거 */
                    /* --AND    AA.CUTOFF_TYPE   IN ('MF_W','MF_M') */
                    /* --AND    AA.MEASURE       = 'MKT_FCST' */
                    AND A.MEASURE     = CASE WHEN IB.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                             WHEN IB.VMI_YN = 'Y' THEN 'VMI_In_Req'
                                             WHEN TRIM(A.ATTRIBUTE10) IS NULL OR A.ATTRIBUTE10 = '-' THEN 'MKT_FCST'
                                        END
                    AND A.FCST_TYPE  <> 'RMA'  /* -- 20181115 반품예정수량은 제외 */
                    AND A.QTY         > 0
                    /* --AND    AA.version_no    = @p_version_no */
                    AND A.DIVISION_ID = V_DIVISION_ID  /* --'81' */
               ) IA
         GROUP BY IA.YYYYMMDD
                , IA.DIVISION_ID
                , IA.ITEM_ID
                , IA.SCM_SITE_ID
                , IA.INCOTERMS;

        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING GT_XSPK_DM_MKT_FCST B
           ON (     A.DIVISION_ID = B.DIVISION_ID
                AND A.YYYYMMDD    = B.YYYYMMDD
                AND A.ITEM_ID     = B.ITEM_ID
                AND A.TO_SITE     = B.SCM_SITE_ID
                AND A.INCOTERMS   = B.INCOTERMS  /* -- 2022.07.20 Forcast 수량오류로 추가 */
                AND A.MEASURE     = 'DM_MKT_FCST' )
         WHEN MATCHED THEN
       UPDATE
          SET A.QTY = B.QTY;

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK FROM SITE별 */
        /*
            PACK_WHIN	          WH In	          210	PACK,TO_SITE,FROM_SITE	CALC
            PACK_INTRANSIT	    In transit	    220	PACK,TO_SITE,FROM_SITE	CALC
            PACK_INTRANSIT_ETA	In-Transit(ETA)	230	PACK,TO_SITE,FROM_SITE	DB
            PACK_SHIP_PLAN_ETA	Ship Plan(ETA)	240	PACK,TO_SITE,FROM_SITE	CALC
            PACK_SHIP_PLAN	    Ship Plan	      250	PACK,TO_SITE,FROM_SITE	DB
        */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* 원본 LEFT OUTER JOIN #MEASURE (상수 조건만) : 뒤의 SUB.MEASURE <> 'PACK_SHIP_PLAN' 에서 NULL 이 떨어지므로 내부조인과 같음 */
        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE_LINE
             , IA.TRANSPORT_MODE
             , IA.PROD_LINE
             , IA.MEASURE
             , IA.YYYYMMDD
             , 0                            AS QTY
             , IA.SORT_ORDER_NO
             , IA.COLUMN_LABEL_NAME
             /* --, (CASE WHEN MEASURE = 'PACK_SHIP_PLAN' THEN BOD_ID  ELSE '-' END) AS BOD_ID */
             , IA.BOD_ID
             , IA.ATTRIBUTE1
             , IA.ATTRIBUTE9
             , IA.ATTRIBUTE10
             , NULL                         AS WEEK_COLUMN
          FROM ( SELECT DISTINCT
                        A.DIVISION_ID
                      , A.OPERATION_GROUP
                      , A.CELL_ITEM_ID
                      , A.ITEM_ID
                      , A.TO_SITE
                      , NULL                         AS PROJECT_CODE  /* '' */
                      , A.TO_BOH_QTY
                      , A.FROM_BOH_QTY
                      , A.INCOTERMS
                      , A.FROM_SITE
                      , A.TRANSPORT_MODE_LINE
                      , A.TRANSPORT_MODE
                      , '-'                          AS PROD_LINE
                      , SUBSTR(B.COLUMN_NAME, 1, 100) AS MEASURE
                      , A.YYYYMMDD
                      , B.SORT_ORDER_NO
                      , B.COLUMN_LABEL_NAME
                      , A.BOD_ID
                      , A.ATTRIBUTE1
                      , A.ATTRIBUTE9
                      , A.ATTRIBUTE10
                   FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK A
                      , GT_XSPK_MEASURE B
                  WHERE B.DIV             = 'P'
                    AND B.GUBUN           = 'TO_FROM'  /* --PACK_SHIP_PLAN_ETA */
                    AND A.MEASURE         = 'PACK_SHIP_PLAN'
                    AND A.OPERATION_GROUP = 'P'
               ) IA
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK XA
                            WHERE XA.DIVISION_ID         = IA.DIVISION_ID
                              AND XA.OPERATION_GROUP     = IA.OPERATION_GROUP
                              AND XA.CELL_ITEM_ID        = IA.CELL_ITEM_ID
                              AND XA.ITEM_ID             = IA.ITEM_ID
                              AND XA.TO_SITE             = IA.TO_SITE
                              /* --                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE */
                              AND XA.TO_BOH_QTY          = IA.TO_BOH_QTY
                              AND XA.FROM_BOH_QTY        = IA.FROM_BOH_QTY
                              AND XA.INCOTERMS           = IA.INCOTERMS
                              AND XA.FROM_SITE           = IA.FROM_SITE
                              AND XA.TRANSPORT_MODE_LINE = IA.TRANSPORT_MODE_LINE
                              /* --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE */
                              /* --AND Z.PROD_LINE            = SUB.PROD_LINE */
                              AND XA.MEASURE             = IA.MEASURE
                              AND XA.YYYYMMDD            = IA.YYYYMMDD
                              AND XA.BOD_ID              = IA.BOD_ID
                              AND XA.ATTRIBUTE1          = IA.ATTRIBUTE1
                              AND XA.ATTRIBUTE9          = IA.ATTRIBUTE9
                              AND XA.ATTRIBUTE10         = IA.ATTRIBUTE10)
           AND IA.MEASURE <> 'PACK_SHIP_PLAN';

        /* RTF관련 */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* 원본 LEFT OUTER JOIN #MEASURE M ON M.COLUMN_NAME IN ('ALLOCATION', 'FCST_RTF_GAP', 'FCST_RTF_ACC') (상수 조건만 · 뒤 거르기 없음)
           → 짝이 있으면 내부조인 행, #MEASURE 에 세 메저가 하나도 없으면 MEASURE NULL 행 1벌 (UNION ALL 로 재현) */
        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , '-'                          AS FROM_SITE
             , '-'                          AS TRANSPORT_MODE_LINE
             , '-'                          AS TRANSPORT_MODE
             , '-'                          AS PROD_LINE
             , IA.MEASURE
             , IA.YYYYMMDD
             , 0                            AS QTY
             , IA.SORT_ORDER_NO
             , IA.COLUMN_LABEL_NAME
             , '-'                          AS BOD_ID
             , IA.ATTRIBUTE1
             , '-'                          AS ATTRIBUTE9
             , IA.ATTRIBUTE10
             , NULL                         AS WEEK_COLUMN
          FROM ( SELECT A.DIVISION_ID
                      , A.OPERATION_GROUP
                      , A.CELL_ITEM_ID
                      , A.ITEM_ID
                      , A.TO_SITE
                      , A.PROJECT_CODE
                      , A.TO_BOH_QTY
                      , A.FROM_BOH_QTY
                      , A.INCOTERMS
                      , SUBSTR(B.COLUMN_NAME, 1, 100) AS MEASURE
                      , A.YYYYMMDD
                      , B.SORT_ORDER_NO
                      , B.COLUMN_LABEL_NAME
                      , A.ATTRIBUTE1
                      , A.ATTRIBUTE10
                   FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK A
                      , GT_XSPK_MEASURE B
                  WHERE B.COLUMN_NAME     IN ('ALLOCATION', 'FCST_RTF_GAP', 'FCST_RTF_ACC')
                    AND A.MEASURE         = 'DM_MKT_FCST'
                    AND A.OPERATION_GROUP = 'P'
                  UNION ALL
                 SELECT A.DIVISION_ID
                      , A.OPERATION_GROUP
                      , A.CELL_ITEM_ID
                      , A.ITEM_ID
                      , A.TO_SITE
                      , A.PROJECT_CODE
                      , A.TO_BOH_QTY
                      , A.FROM_BOH_QTY
                      , A.INCOTERMS
                      , NULL                         AS MEASURE
                      , A.YYYYMMDD
                      , NULL                         AS SORT_ORDER_NO
                      , NULL                         AS COLUMN_LABEL_NAME
                      , A.ATTRIBUTE1
                      , A.ATTRIBUTE10
                   FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK A
                  WHERE NOT EXISTS (SELECT 1
                                      FROM GT_XSPK_MEASURE XB
                                     WHERE XB.COLUMN_NAME IN ('ALLOCATION', 'FCST_RTF_GAP', 'FCST_RTF_ACC'))
                    AND A.MEASURE         = 'DM_MKT_FCST'
                    AND A.OPERATION_GROUP = 'P'
               ) IA;

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK FROM SITE별 */
        /*
            PACK_PROD	      Production	          260	PACK,FROM_SITE	DB
            PACK_PROD_LOAD	Line Total Load	      270	PACK,FROM_SITE	DB
            PACK_BOH	      Model inventory(BOH)	280	PACK,FROM_SITE	DB,CALC
            PACK_EOH	      Model inventory(EOH)	290	PACK,FROM_SITE	CALC
        */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* 원본 LEFT OUTER JOIN #MEASURE (상수 조건만) : 뒤의 SUB.MEASURE <> 'PACK_PROD' 에서 NULL 이 떨어지므로 내부조인과 같음 */
        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE_LINE
             , IA.TRANSPORT_MODE
             , IA.PROD_LINE
             , IA.MEASURE
             , IA.YYYYMMDD
             , 0                            AS QTY
             , IA.SORT_ORDER_NO
             , IA.COLUMN_LABEL_NAME
             , IA.BOD_ID
             , IA.ATTRIBUTE1
             , IA.ATTRIBUTE9
             , IA.ATTRIBUTE10
             , NULL                         AS WEEK_COLUMN
          FROM ( SELECT DISTINCT
                        A.DIVISION_ID
                      , A.OPERATION_GROUP
                      , A.CELL_ITEM_ID
                      , A.ITEM_ID
                      , '-'                          AS TO_SITE
                      , NULL                         AS PROJECT_CODE  /* '' */
                      , A.TO_BOH_QTY
                      , A.FROM_BOH_QTY
                      , '-'                          AS INCOTERMS
                      , A.FROM_SITE
                      , '-'                          AS TRANSPORT_MODE_LINE
                      , '-'                          AS TRANSPORT_MODE
                      , '-'                          AS PROD_LINE
                      , SUBSTR(B.COLUMN_NAME, 1, 100) AS MEASURE
                      , A.YYYYMMDD
                      , B.SORT_ORDER_NO
                      , B.COLUMN_LABEL_NAME
                      , '-'                          AS BOD_ID
                      , A.ATTRIBUTE1
                      , A.ATTRIBUTE9
                      , A.ATTRIBUTE10
                   FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK A
                      , GT_XSPK_MEASURE B
                  WHERE B.DIV             = 'P'
                    AND B.GUBUN           = 'FROM'
                    AND A.MEASURE         = 'PACK_PROD'
                    AND A.OPERATION_GROUP = 'P'
               ) IA
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK XA
                            WHERE XA.DIVISION_ID         = IA.DIVISION_ID
                              AND XA.OPERATION_GROUP     = IA.OPERATION_GROUP
                              AND XA.CELL_ITEM_ID        = IA.CELL_ITEM_ID
                              AND XA.ITEM_ID             = IA.ITEM_ID
                              AND XA.TO_SITE             = IA.TO_SITE
                              /* --                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE */
                              AND XA.TO_BOH_QTY          = IA.TO_BOH_QTY
                              AND XA.FROM_BOH_QTY        = IA.FROM_BOH_QTY
                              AND XA.INCOTERMS           = IA.INCOTERMS
                              AND XA.FROM_SITE           = IA.FROM_SITE
                              AND XA.TRANSPORT_MODE_LINE = IA.TRANSPORT_MODE_LINE
                              /* --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE */
                              /* --AND Z.PROD_LINE            = SUB.PROD_LINE */
                              AND XA.MEASURE             = IA.MEASURE
                              AND XA.YYYYMMDD            = IA.YYYYMMDD
                              AND XA.BOD_ID              = IA.BOD_ID
                              AND XA.ATTRIBUTE1          = IA.ATTRIBUTE1
                              AND XA.ATTRIBUTE9          = IA.ATTRIBUTE9
                              AND XA.ATTRIBUTE10         = IA.ATTRIBUTE10)
           AND IA.MEASURE <> 'PACK_PROD';

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK FROM SITE별 */
        /*
            CELL_REQ	          Cell Requirement Total	410	CELL,TO_PACKER,FROM_SITE	CALC    TO
            CELL_BALANCE	      Balance	                420	CELL,TO_PACKER,FROM_SITE	CALC    TO
            CELL_WHIN	          WH In	                  430	CELL,TO_PACKER,FROM_SITE	CALC    TO

            CELL_INTRANSIT	    In transit	            440	CELL,TO_PACKER,FROM_SITE	CALC    FROM
            CELL_INTRANSIT_ETA	In-Transit(ETA)	        450	CELL,TO_PACKER,FROM_SITE	DB      FROM
            CELL_SHIP_PLAN_ETA	Ship Plan(ETA)	        460	CELL,TO_PACKER,FROM_SITE	CALC    FROM
            CELL_SHIP_PLAN      Ship Plan               470	CELL,TO_PACKER,FROM_SITE	DB      FROM
        */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* 원본 LEFT OUTER JOIN #MEASURE (상수 조건만) : 뒤의 SUB.MEASURE <> 'CELL_SHIP_PLAN' 에서 NULL 이 떨어지므로 내부조인과 같음 */
        /* 원본 Z.PROJECT_CODE = SUB.PROJECT_CODE 에서 SUB 는 '' 상수 → Oracle 에서는 Z.PROJECT_CODE IS NULL (이 칸의 NULL 은 원본 '' 자리) */
        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE_LINE
             , IA.TRANSPORT_MODE
             , IA.PROD_LINE
             , IA.MEASURE
             , IA.YYYYMMDD
             , 0                            AS QTY
             , IA.SORT_ORDER_NO
             , IA.COLUMN_LABEL_NAME
             , IA.BOD_ID
             , IA.ATTRIBUTE1
             , IA.ATTRIBUTE9
             , IA.ATTRIBUTE10
             , NULL                         AS WEEK_COLUMN
          FROM ( SELECT DISTINCT
                        A.DIVISION_ID
                      , 'A'                          AS OPERATION_GROUP
                      , A.CELL_ITEM_ID
                      , A.ITEM_ID
                      , A.TO_SITE
                      , NULL                         AS PROJECT_CODE  /* '' */
                      , A.TO_BOH_QTY
                      , A.FROM_BOH_QTY
                      , '-'                          AS INCOTERMS
                      , '-'                          AS FROM_SITE
                      , '-'                          AS TRANSPORT_MODE_LINE
                      , '-'                          AS TRANSPORT_MODE
                      , '-'                          AS PROD_LINE
                      , SUBSTR(B.COLUMN_NAME, 1, 100) AS MEASURE
                      , A.YYYYMMDD
                      , B.SORT_ORDER_NO
                      , B.COLUMN_LABEL_NAME
                      , '-'                          AS BOD_ID
                      , A.ATTRIBUTE1
                      , A.ATTRIBUTE9
                      , A.ATTRIBUTE10
                   FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK A
                      , GT_XSPK_MEASURE B
                  WHERE B.DIV   = 'A'
                    AND B.GUBUN = 'TO'
                    /* --                                AND X.MEASURE         = 'CELL_SHIP_PLAN' */
               ) IA
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK XA
                            WHERE XA.DIVISION_ID         = IA.DIVISION_ID
                              AND XA.OPERATION_GROUP     = IA.OPERATION_GROUP
                              AND XA.CELL_ITEM_ID        = IA.CELL_ITEM_ID
                              AND XA.ITEM_ID             = IA.ITEM_ID
                              AND XA.TO_SITE             = IA.TO_SITE
                              AND XA.PROJECT_CODE        IS NULL  /* Z.PROJECT_CODE = SUB.PROJECT_CODE('') */
                              AND XA.TO_BOH_QTY          = IA.TO_BOH_QTY
                              AND XA.FROM_BOH_QTY        = IA.FROM_BOH_QTY
                              AND XA.INCOTERMS           = IA.INCOTERMS
                              AND XA.FROM_SITE           = IA.FROM_SITE
                              AND XA.TRANSPORT_MODE_LINE = IA.TRANSPORT_MODE_LINE
                              AND XA.MEASURE             = IA.MEASURE
                              AND XA.YYYYMMDD            = IA.YYYYMMDD
                              AND XA.BOD_ID              = IA.BOD_ID
                              AND XA.ATTRIBUTE1          = IA.ATTRIBUTE1
                              AND XA.ATTRIBUTE9          = IA.ATTRIBUTE9
                              AND XA.ATTRIBUTE10         = IA.ATTRIBUTE10)
           AND IA.TO_SITE         <> '-'
           AND IA.OPERATION_GROUP = 'A'
           AND IA.MEASURE         <> 'CELL_SHIP_PLAN';

        /* 원본 LEFT OUTER JOIN #MEASURE (상수 조건만) : 뒤의 SUB.MEASURE NOT IN (..) 에서 NULL 이 떨어지므로 내부조인과 같음 */
        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE_LINE
             , IA.TRANSPORT_MODE
             , IA.PROD_LINE
             , IA.MEASURE
             , IA.YYYYMMDD
             , 0                            AS QTY
             , IA.SORT_ORDER_NO
             , IA.COLUMN_LABEL_NAME
             , IA.BOD_ID
             , IA.ATTRIBUTE1
             , IA.ATTRIBUTE9
             , IA.ATTRIBUTE10
             , NULL                         AS WEEK_COLUMN
          FROM ( /* 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가 - start */
                 SELECT IB.DIVISION_ID
                      , IB.OPERATION_GROUP
                      , IB.CELL_ITEM_ID
                      , IB.ITEM_ID
                      , IB.TO_SITE
                      , IB.PROJECT_CODE
                      , IB.TO_BOH_QTY
                      , IB.FROM_BOH_QTY
                      , IB.INCOTERMS
                      , IB.FROM_SITE
                      , IB.TRANSPORT_MODE_LINE
                      , IB.TRANSPORT_MODE
                      , IB.PROD_LINE
                      , IB.MEASURE
                      , IC.YYYYMMDD
                      , IB.SORT_ORDER_NO
                      , IB.COLUMN_LABEL_NAME
                      , IB.BOD_ID
                      , IB.ATTRIBUTE1
                      , IB.ATTRIBUTE9
                      , IB.ATTRIBUTE10
                   FROM ( SELECT DISTINCT
                                 A.DIVISION_ID
                               , A.OPERATION_GROUP
                               , A.CELL_ITEM_ID
                               , A.ITEM_ID
                               , A.TO_SITE
                               , NULL                         AS PROJECT_CODE  /* '' */
                               , A.TO_BOH_QTY
                               , A.FROM_BOH_QTY
                               , '-'                          AS INCOTERMS
                               , A.FROM_SITE
                               , '-'                          AS TRANSPORT_MODE_LINE
                               , '-'                          AS TRANSPORT_MODE
                               , '-'                          AS PROD_LINE
                               , SUBSTR(B.COLUMN_NAME, 1, 100) AS MEASURE
                                 /* --, X.YYYYMMDD */
                               , B.SORT_ORDER_NO
                               , B.COLUMN_LABEL_NAME
                               , '-'                          AS BOD_ID
                               , A.ATTRIBUTE1
                               , A.ATTRIBUTE9
                               , A.ATTRIBUTE10
                            FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK A
                               , GT_XSPK_MEASURE B
                           WHERE B.DIV     = 'A'
                             AND B.GUBUN   = 'FROM'
                             AND A.MEASURE = 'CELL_SHIP_PLAN'
                        ) IB
                      , ( SELECT BASIS_YYYYMMDD AS YYYYMMDD
                            FROM SCM_SYS_CALENDAR_M
                           WHERE BASIS_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_TO_YYYYMMDD  /* ---------DHJ */
                        ) IC
                 /* 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가 - end */
               ) IA
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK XA
                            WHERE XA.DIVISION_ID         = IA.DIVISION_ID
                              AND XA.OPERATION_GROUP     = IA.OPERATION_GROUP
                              AND XA.CELL_ITEM_ID        = IA.CELL_ITEM_ID
                              AND XA.ITEM_ID             = IA.ITEM_ID
                              AND XA.TO_SITE             = IA.TO_SITE
                              AND XA.PROJECT_CODE        IS NULL  /* Z.PROJECT_CODE = SUB.PROJECT_CODE('') */
                              AND XA.TO_BOH_QTY          = IA.TO_BOH_QTY
                              AND XA.FROM_BOH_QTY        = IA.FROM_BOH_QTY
                              AND XA.INCOTERMS           = IA.INCOTERMS
                              AND XA.FROM_SITE           = IA.FROM_SITE
                              AND XA.TRANSPORT_MODE_LINE = IA.TRANSPORT_MODE_LINE
                              /* --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE */
                              /* --AND Z.PROD_LINE            = SUB.PROD_LINE */
                              AND XA.MEASURE             = IA.MEASURE
                              AND XA.YYYYMMDD            = IA.YYYYMMDD
                              AND XA.BOD_ID              = IA.BOD_ID
                              AND XA.ATTRIBUTE1          = IA.ATTRIBUTE1
                              AND XA.ATTRIBUTE9          = IA.ATTRIBUTE9
                              AND XA.ATTRIBUTE10         = IA.ATTRIBUTE10)
           /* --AND SUB.MEASURE   <> 'CELL_SHIP_PLAN' */
           AND IA.MEASURE NOT IN ('CELL_SHIP_PLAN', 'CELL_SHIP_PLAN_SSP');
           /* --AND SUB.MEASURE   NOT IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH') */

        /* (OPERATION GROUP이 CELL이고, TO_SITE가 PLANT가 아닌것은 제외) */
        DELETE
          FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK A
         WHERE A.TO_SITE IN (SELECT XA.SCM_SITE_ID
                               FROM SCM_MST_SITE XA
                              WHERE XA.DIVISION_ID = A.DIVISION_ID
                                AND XA.SCM_SITE_ID = A.TO_SITE
                                /* --                   AND Y.SITE_TYPE    <> 'PLANT' */
                                AND XA.SITE_TYPE   = 'SALES')
           AND A.MEASURE         IN ('CELL_REQ', 'CELL_BALANCE', 'CELL_WHIN')
           AND A.OPERATION_GROUP = 'A';

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : PACK FROM SITE별 */
        /*
            CELL_PKG_PLAN_IN	    PKG Plan_In	          490	  CELL,TO_PACKER,FROM_SITE	  DB
            CELL_PKG_PLAN_OUT	    PKG Plan_Out	        500	  CELL,TO_PACKER,FROM_SITE	  DB,CALC
            CELL_FORMATION	      Formation	            510	  CELL,TO_PACKER,FROM_SITE	  DB
            CELL_BOH	            Model inventory(BOH)	520	  CELL,TO_PACKER,FROM_SITE	  CALC
            CELL_EOH	            Model inventory(EOH)	530	  CELL,TO_PACKER,FROM_SITE	  CALC
        */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* CELL_PKG_PLAN_IN */
        /* #CELL_PKG_PLAN_IN : 한 번만 쓰이므로 아래 MERGE 의 USING 으로 옮김 */
        /* 원본 UPDATE .. FROM JOIN : 한 행에 여러 행(ITEM_ID·INCOTERMS·BOD_ID 등이 다른)이 걸리면 MSSQL 은 임의 1건 → MAX 로 고정 */
        /* --INSERT INTO #PSI_GLOBAL_SMALL_PACK */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT IB.MEASURE
                     , IB.CELL_ITEM_ID
                     , IB.FROM_SITE
                     , IB.YYYYMMDD
                     , MAX(IB.QTY) AS QTY
                  FROM ( SELECT DISTINCT
                                B.DIVISION_ID
                              , B.OPERATION_GROUP
                              , B.CELL_ITEM_ID
                              , B.ITEM_ID
                              , B.INCOTERMS
                              , B.FROM_SITE
                              , C.COLUMN_NAME     AS MEASURE
                              , B.YYYYMMDD
                              , SUM(NVL(B.QTY, 0)) AS QTY
                              , C.SORT_ORDER_NO
                              , C.COLUMN_LABEL_NAME
                              , B.BOD_ID
                              , B.ATTRIBUTE1
                              , B.ATTRIBUTE9
                              , B.ATTRIBUTE10
                           FROM SCP_ANL_PSI_GLOBAL_SMALL B
                              , GT_XSPK_MEASURE C
                          WHERE C.COLUMN_NAME           = 'CELL_PKG_PLAN_IN'
                            AND B.MEASURE               = 'PRODUCTION'
                            AND B.OPERATION_GROUP       = 'A'
                            AND B.DIVISION_ID           = V_DIVISION_ID
                            AND B.PLAN_START_YYYYMMDD   = V_PLAN_START_YYYYMMDD
                            AND B.PLAN_TYPE             = P_PLAN_TYPE
                            AND B.SEQ                   = N_SEQ
                            AND B.YYYYMMDD             >= V_PLAN_START_YYYYMMDD
                            AND B.YYYYMMDD             <= V_TO_YYYYMMDD  /* --말일포함(KSK, 20240814) */
                          GROUP BY B.DIVISION_ID
                                 , B.OPERATION_GROUP
                                 , B.CELL_ITEM_ID
                                 , B.ITEM_ID
                                 , B.INCOTERMS
                                 , B.FROM_SITE
                                 , C.COLUMN_NAME
                                 , B.YYYYMMDD
                                 , C.SORT_ORDER_NO
                                 , C.COLUMN_LABEL_NAME
                                 , B.BOD_ID
                                 , B.ATTRIBUTE1
                                 , B.ATTRIBUTE9
                                 , B.ATTRIBUTE10
                       ) IB
                 GROUP BY IB.MEASURE
                        , IB.CELL_ITEM_ID
                        , IB.FROM_SITE
                        , IB.YYYYMMDD
              ) IA
           ON (     A.MEASURE      = IA.MEASURE
                AND A.CELL_ITEM_ID = IA.CELL_ITEM_ID
                /* --AND X.ITEM_ID      = Y.ITEM_ID */
                AND A.FROM_SITE    = IA.FROM_SITE
                AND A.YYYYMMDD     = IA.YYYYMMDD
                AND A.MEASURE      = 'CELL_PKG_PLAN_IN' )
         WHEN MATCHED THEN
       UPDATE
          SET A.QTY = NVL(IA.QTY, 0);

        /*
        INSERT INTO #PSI_GLOBAL_SMALL_PACK
        SELECT  DISTINCT
                DIVISION_ID
                , OPERATION_GROUP
                , CELL_ITEM_ID
                , ITEM_ID
                --, TO_SITE
           --   , PROJECT_CODE
              , (CASE WHEN MEASURE IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH') THEN '-' ELSE TO_SITE END )
              , (CASE WHEN MEASURE IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH') THEN '' ELSE PROJECT_CODE END )
                , TO_BOH_QTY
                , FROM_BOH_QTY
                , INCOTERMS
                , FROM_SITE
                , TRANSPORT_MODE_LINE
              , TRANSPORT_MODE
              , PROD_LINE
                , MEASURE
                , YYYYMMDD
              , 0    AS QTY
                , SORT_ORDER_NO
                , COLUMN_LABEL_NAME
                , BOD_ID
              , ATTRIBUTE1
                , ATTRIBUTE9
                , ATTRIBUTE10
              , NULL AS WEEK_COLUMN
                 FROM
                     (

                        SELECT  DISTINCT  X.DIVISION_ID
                                                  , X.OPERATION_GROUP
                                                  , X.CELL_ITEM_ID
                                                  , X.ITEM_ID
                                                  , X.TO_SITE
                                        , '' AS PROJECT_CODE
                                                  , X.TO_BOH_QTY
                                                  , X.FROM_BOH_QTY
                                                  , '-' AS INCOTERMS
                                                  , X.FROM_SITE
                                                  , '-' AS TRANSPORT_MODE_LINE
                                        , '-' AS TRANSPORT_MODE
                                        , '-' AS PROD_LINE
                                                  , M.COLUMN_NAME AS MEASURE
                                                        , X.YYYYMMDD
                                                  , M.SORT_ORDER_NO
                                                  , M.COLUMN_LABEL_NAME
                                                  , '-' AS BOD_ID
                                        , X.ATTRIBUTE1
                                                  , X.ATTRIBUTE9
                                                  , ATTRIBUTE10
                            FROM #PSI_GLOBAL_SMALL_PACK X WITH(NOLOCK)
                            LEFT OUTER JOIN #MEASURE M WITH (NOLOCK)
                            ON DIV ='A' AND GUBUN = 'FROM'
                          WHERE 1=1
                            AND X.MEASURE     = 'CELL_PKG_PLAN_IN'
                            AND M.COLUMN_NAME IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH')
                     ) SUB
                     WHERE 1=1
                       AND NOT EXISTS (
                                        SELECT 'X'
                                          FROM #PSI_GLOBAL_SMALL_PACK Z WITH(NOLOCK)
                                         WHERE 1=1
                                           AND Z.DIVISION_ID          = SUB.DIVISION_ID
                                           AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP
                                           AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID
                                           AND Z.ITEM_ID              = SUB.ITEM_ID
                                           --AND Z.TO_SITE              = SUB.TO_SITE
                                           AND Z.PROJECT_CODE         = SUB.PROJECT_CODE
                                           AND Z.TO_BOH_QTY           = SUB.TO_BOH_QTY
                                           AND Z.FROM_BOH_QTY         = SUB.FROM_BOH_QTY
                                           AND Z.INCOTERMS            = SUB.INCOTERMS
                                           AND Z.FROM_SITE            = SUB.FROM_SITE
                                           AND Z.TRANSPORT_MODE_LINE  = SUB.TRANSPORT_MODE_LINE
                                           --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE
                                           --AND Z.PROD_LINE            = SUB.PROD_LINE
                                           AND Z.MEASURE              = SUB.MEASURE
                                           AND Z.YYYYMMDD             = SUB.YYYYMMDD
                                           AND Z.BOD_ID               = SUB.BOD_ID
                                           AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1
                                                     AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9
                                                     AND Z.ATTRIBUTE10	        = SUB.ATTRIBUTE10
                                      )

                  AND SUB.MEASURE   <> 'CELL_PKG_PLAN_IN'
                --AND SUB.MEASURE   NOT IN ('CELL_SHIP_PLAN','CELL_SHIP_PLAN_SSP')
                */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* CELL_FORMATION(SCP_XLS_BOH) FROM_BOH_QTY */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #SCP_XLS_BOH → GT_XSPK_SCP_XLS_BOH */
        /* DATEADD(D, n, d) 는 n 의 소수점 아래를 버리고 더함 → d + TRUNC(n) */
        DELETE
          FROM GT_XSPK_SCP_XLS_BOH;

        INSERT
          INTO GT_XSPK_SCP_XLS_BOH
             ( CELL_ITEM_ID
             , YYYYMMDD
             , QTY
             , MEASURE
             )
        SELECT IA.CELL_ITEM_ID
               /* --,X.SCM_SITE_ID */
             , TO_CHAR(IA.AFTER_DTTM, 'YYYYMMDD') AS YYYYMMDD
             , SUM(IA.AFTER_QTY)                  AS QTY
             , CASE WHEN TO_CHAR(IA.AFTER_DTTM, 'YYYYMMDD') < V_PLAN_START_YYYYMMDD THEN 'CELL_BOH' ELSE 'CELL_FORMATION' END AS MEASURE
          FROM ( SELECT /* --SUB.*, */
                        CELL_ITEM_ID
                      , SCM_SITE_ID
                      , CASE WHEN (OSP_YN = 'N' AND LOC = '***' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%') THEN QTY * FORMATION_TOTAL_YIELD ELSE QTY END AS AFTER_QTY
                      , CASE WHEN (OSP_YN = 'N' AND LOC = '***' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN = 'Y')  /* --활성화 LT+ TOTAL TCO LT */
                             THEN RECEIVING_DTTM + TRUNC(TOTAL_LT_FORMATION + CELL_TO_TCO_TOTAL_BOD_LT)
                             WHEN (OSP_YN = 'N' AND LOC = '***' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN = 'N')  /* --활성화 LT */
                             THEN RECEIVING_DTTM + TRUNC(TOTAL_LT_FORMATION)
                             WHEN (OSP_YN = 'N' AND LOC = '001' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN = 'Y')  /* --TOTAL TCO LT */
                             THEN RECEIVING_DTTM + TRUNC(CELL_TO_TCO_TOTAL_BOD_LT)
                             WHEN (OSP_YN = 'N' AND LOC = '001' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN = 'N')  /* -- */
                             THEN RECEIVING_DTTM
                             WHEN (OSP_YN = 'N' AND LOC = '001' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN = 'Y')  /* --TOTAL TCO LT */
                             THEN RECEIVING_DTTM + TRUNC(CELL_TO_TCO_TOTAL_BOD_LT)
                             WHEN (OSP_YN = 'N' AND LOC = '001' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN = 'N')  /* -- */
                             THEN RECEIVING_DTTM
                             WHEN (OSP_YN = 'N' AND LOC = '002' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN = 'Y')  /* --TOTAL TCO LT */
                             THEN RECEIVING_DTTM + TRUNC(CELL_TO_TCO_TOTAL_BOD_LT)
                             WHEN (OSP_YN = 'N' AND LOC = '002' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN = 'N')  /* -- */
                             THEN RECEIVING_DTTM
                             WHEN (OSP_YN = 'N' AND LOC = '003' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN = 'Y')  /* -- */
                             THEN RECEIVING_DTTM
                             WHEN (OSP_YN = 'N' AND LOC = '003' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN = 'N')  /* -- */
                             THEN RECEIVING_DTTM
                             WHEN (OSP_YN = 'Y' AND LOC = '***' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'INT%' AND TCO_EXIST_YN = 'Y')  /* --TCO_TO_CELL_BOD_LT */
                             THEN RECEIVING_DTTM + TRUNC(TCO_TO_CELL_BOD_LT)
                             WHEN (OSP_YN = 'Y' AND LOC = '***' AND TCO_CELL_YN = 'N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN = 'Y')  /* --TCO_TO_CELL_BOD_LT */
                             THEN RECEIVING_DTTM + TRUNC(TCO_TO_CELL_BOD_LT)
                             WHEN (OSP_YN = 'Y' AND LOC = '***' AND TCO_CELL_YN = 'Y' AND DESCR LIKE 'WH%')  /* --TCO_TO_CELL_BOD_LT */
                             THEN RECEIVING_DTTM + TRUNC(TCO_TO_CELL_BOD_LT)
                             WHEN (OSP_YN = 'N' AND LOC = '002' AND TCO_CELL_YN = 'Y' AND DESCR LIKE 'INT%')  /* -- */
                             THEN RECEIVING_DTTM
                             WHEN (OSP_YN = 'N' AND LOC = '002' AND TCO_CELL_YN = 'Y' AND DESCR LIKE 'WH%')  /* -- */
                             THEN RECEIVING_DTTM
                             WHEN (OSP_YN = 'N' AND LOC = '003' AND TCO_CELL_YN = 'Y' AND DESCR LIKE 'WH%')  /* -- */
                             THEN RECEIVING_DTTM
                             ELSE RECEIVING_DTTM
                        END AS AFTER_DTTM
                   FROM SCP_XLS_BOH_SMALL_CELL
                  WHERE DESCR               <> 'INT'  /* -- 해상재고 제외 */
                    AND DIVISION_ID          = V_DIVISION_ID
                    AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                    AND PLAN_TYPE            = P_PLAN_TYPE
                    AND SEQ                  = N_SEQ
               ) IA
         GROUP BY IA.CELL_ITEM_ID
                  /* -- ,X.SCM_SITE_ID */
                , TO_CHAR(IA.AFTER_DTTM, 'YYYYMMDD');

        /*
        UPDATE X
          SET X.FROM_BOH_QTY = ISNULL(Y.QTY,0)
         FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
         INNER JOIN #SCP_XLS_BOH Y WITH (NOLOCK)
          ON 0 = 0
          --AND X.DIVISION_ID          = Y.DIVISION_ID
          --AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD
          --AND X.PLAN_TYPE            = Y.PLAN_TYPE
          --AND X.SEQ                  = Y.SEQ
          AND X.CELL_ITEM_ID         = Y.CELL_ITEM_ID
          AND X.MEASURE              = Y.MEASURE
          AND Y.MEASURE              =  'CELL_EOH'
          */

        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT CELL_ITEM_ID
                     , YYYYMMDD
                     , MEASURE
                     , QTY
                  FROM GT_XSPK_SCP_XLS_BOH
                 WHERE MEASURE = 'CELL_FORMATION'
              ) IA
           ON (     A.YYYYMMDD     = IA.YYYYMMDD
                AND A.CELL_ITEM_ID = IA.CELL_ITEM_ID
                AND A.MEASURE      = IA.MEASURE
                /* --AND X.DIVISION_ID          = Y.DIVISION_ID */
                /* --AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD */
                /* --AND X.PLAN_TYPE            = Y.PLAN_TYPE */
                /* --AND X.SEQ                  = Y.SEQ */
              )
         WHEN MATCHED THEN
       UPDATE
          SET A.QTY = NVL(IA.QTY, 0);

        /* ETA_PAST QTY의 엔진시작일자 보다 큰 일자의 SUM */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT CELL_ITEM_ID
                     , SUM(NVL(QTY, 0)) AS QTY
                  FROM GT_XSPK_SCP_XLS_BOH
                 WHERE MEASURE = 'CELL_BOH'  /* -- CELL_EOH */
                 GROUP BY CELL_ITEM_ID
              ) IA
           ON (     A.CELL_ITEM_ID = IA.CELL_ITEM_ID
                AND A.MEASURE      = 'CELL_BOH' )  /* -- CELL_EOH */
         WHEN MATCHED THEN
       UPDATE
          SET A.FROM_BOH_QTY = IA.QTY;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* TRANSPORT_MODE_CODE와 LIEN_ID 반영 */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE GT_XSPK_PSI_GLOBAL_SMALL_PACK A
           SET A.TRANSPORT_MODE = (SELECT MAX(SA.SEGMENT1)
                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                    WHERE SA.SEGMENT1    = A.TRANSPORT_MODE_LINE
                                      AND SA.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'
                                      AND SA.VALID_YN    = 'Y')
         WHERE EXISTS (SELECT 1
                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                        WHERE XA.SEGMENT1    = A.TRANSPORT_MODE_LINE
                          AND XA.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'
                          AND XA.VALID_YN    = 'Y');
        /* --                AND X.TRANSPORT_MODE IS NULL */

        UPDATE GT_XSPK_PSI_GLOBAL_SMALL_PACK A
           SET A.PROD_LINE = (SELECT MAX(SA.LINE_ID)
                                FROM SCM_MST_LINE_V SA
                               WHERE SA.LINE_ID     = A.TRANSPORT_MODE_LINE
                                 AND SA.DIVISION_ID = V_DIVISION_ID)
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_LINE_V XA
                        WHERE XA.LINE_ID     = A.TRANSPORT_MODE_LINE
                          AND XA.DIVISION_ID = V_DIVISION_ID);

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PROD, PROD_LOAD 0 채움 */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #tmp_SCP_MST_TACT_TIME · #MST_TACT_TIME : 한 번만 쓰이므로 아래 INSERT 의 인라인 뷰(IB)로 옮김 */
        /* --                  UNION */
        /* --                  SELECT DISTINCT DIVISION_ID,PLANT_SITE_ID,'-' AS LINE_ID,ITEM_ID, 'PACK_PROD' AS MEASURE   -- DAILY_CAPA_QTY */
        /* --                  --SELECT * */
        /* --                  FROM SCP_MST_OUTSOURCING_CAPA WITH (NOLOCK) */
        /* --                  WHERE 0 = 0 */
        /* --                  AND DIVISION_ID = '40' */
        /* --                  AND ITEM_ID IN (SELECT DISTINCT ITEM_ID */
        /* --                                    FROM #PSI_GLOBAL_SMALL_PACK WITH (NOLOCK) */
        /* --                                   WHERE  0 = 0 */
        /* --                                     AND DIVISION_ID  = '40' */
        /* ----                                     AND MEASURE      = 'PACK_PROD' */
        /* --                                  ) */

        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* PROD_LINE 추가 PACK_PROD,PACK_PROD_LOAD) */
        /* ------------------------------------------------------------------------------------------------------------------------- */
        /* 원본 LEFT OUTER JOIN #MST_TACT_TIME Y .. WHERE X.DIVISION_ID = Y.DIVISION_ID .. → 내부조인과 같음 */
        INSERT
          INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK
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
             , TRANSPORT_MODE_LINE
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
             , ATTRIBUTE10
             , WEEK_COLUMN
             )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.PROJECT_CODE
             , IA.TO_BOH_QTY
             , IA.FROM_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE_LINE
             , IA.TRANSPORT_MODE
             , IA.PROD_LINE
             , IA.MEASURE
             , IA.YYYYMMDD
             , 0                            AS QTY
             , IA.SORT_ORDER_NO
             , IA.COLUMN_LABEL_NAME
             , IA.BOD_ID
             , IA.ATTRIBUTE1
             , IA.ATTRIBUTE9
             , IA.ATTRIBUTE10
             , NULL                         AS WEEK_COLUMN
          FROM ( SELECT DISTINCT
                        A.DIVISION_ID
                      , A.OPERATION_GROUP
                      , A.CELL_ITEM_ID
                      , A.ITEM_ID
                      , '-'                          AS TO_SITE
                      , NULL                         AS PROJECT_CODE  /* '' */
                      , 0                            AS TO_BOH_QTY    /* '0' */
                      , 0                            AS FROM_BOH_QTY  /* '0' */
                      , '-'                          AS INCOTERMS
                      , A.FROM_SITE
                      , '-'                          AS TRANSPORT_MODE_LINE
                      , '-'                          AS TRANSPORT_MODE
                      , IB.LINE_ID                   AS PROD_LINE
                      , IB.MEASURE
                      , A.YYYYMMDD
                      , A.SORT_ORDER_NO
                      , A.COLUMN_LABEL_NAME
                      , '-'                          AS BOD_ID
                      , A.ATTRIBUTE1
                      , A.ATTRIBUTE9
                      , A.ATTRIBUTE10
                   FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK A
                      , ( SELECT DISTINCT
                                 IC.DIVISION_ID
                               , IC.PLANT_SITE_ID
                               , IC.LINE_ID
                               , IC.ITEM_ID
                               , 'PACK_PROD'   AS MEASURE
                            FROM ( SELECT DIVISION_ID
                                        , PLANT_SITE_ID
                                        , ITEM_ID
                                        , OPERATION_ID
                                        , LINE_ID
                                        , YIELD
                                     FROM SCP_MST_TACT_TIME
                                    WHERE DIVISION_ID = V_DIVISION_ID
                                    UNION ALL
                                   SELECT DIVISION_ID
                                        , PLANT_SITE_ID
                                        , ITEM_ID
                                        , OPERATION_ID
                                        , LINE_ID
                                        , YIELD
                                     FROM SCP_MST_TACT_TIME_OSP
                                    WHERE DIVISION_ID = V_DIVISION_ID
                                 ) IC
                                 /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 Start (INNER HASH JOIN 조인 힌트는 Oracle 문법에 없어 뺌) */
                               , ( SELECT DISTINCT
                                          SEGMENT1 AS OPERATION_ID
                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                      AND SEGMENT3    = 'A'  /* -- 공정그룹 (Cell) */
                                      AND ATTRIBUTE1  = 'Y'  /* -- Final Operation */
                                 ) IE
                                 /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 End */
                           WHERE IE.OPERATION_ID = IC.OPERATION_ID
                             AND IC.ITEM_ID IN (SELECT DISTINCT
                                                       XA.ITEM_ID
                                                  FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK XA
                                                 WHERE XA.DIVISION_ID = '40'
                                                   AND XA.MEASURE     = 'PACK_PROD')
                             AND IC.DIVISION_ID = '40'
                             /* -- [PJ20257329] 2025.08.01  변경전 AND OPERATION_ID         IN ( 'A3000','A9000') */
                        ) IB
                  WHERE A.DIVISION_ID = IB.DIVISION_ID
                    AND A.FROM_SITE   = IB.PLANT_SITE_ID
                    AND A.ITEM_ID     = IB.ITEM_ID
                    /* --                  AND X.PROD_LINE     <> LINE_ID */
                    AND A.MEASURE     IN ('PACK_PROD')
               ) IA
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK XB
                            WHERE XB.DIVISION_ID     = IA.DIVISION_ID
                              AND XB.OPERATION_GROUP = IA.OPERATION_GROUP
                              AND XB.CELL_ITEM_ID    = IA.CELL_ITEM_ID
                              AND XB.ITEM_ID         = IA.ITEM_ID
                              /* --                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE */
                              /* --                                               AND Z.TO_SITE              = SUB.TO_SITE */
                              /* --                                               AND Z.TO_BOH_QTY           = SUB.TO_BOH_QTY */
                              /* --                                               AND Z.FROM_BOH_QTY         = SUB.FROM_BOH_QTY */
                              /* --AND Z.INCOTERMS            = SUB.INCOTERMS */
                              AND XB.FROM_SITE       = IA.FROM_SITE
                              /* --AND Z.TRANSPORT_MODE_LINE  = SUB.TRANSPORT_MODE_LINE */
                              /* --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE */
                              AND XB.PROD_LINE       = IA.PROD_LINE
                              AND XB.MEASURE         = IA.MEASURE
                              AND XB.YYYYMMDD        = IA.YYYYMMDD
                              /* --                                               AND Z.BOD_ID               = SUB.BOD_ID */
                              AND XB.ATTRIBUTE1      = IA.ATTRIBUTE1
                              AND XB.ATTRIBUTE9      = IA.ATTRIBUTE9
                              AND XB.ATTRIBUTE10     = IA.ATTRIBUTE10);
        /* --                    AND SUB.MEASURE   <> 'SEMI_SHIP_PLAN' */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* INTRANSIT 반영 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #INTRANSIT → GT_XSPK_INTRANSIT */
        DELETE
          FROM GT_XSPK_INTRANSIT;

        INSERT
          INTO GT_XSPK_INTRANSIT
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , FROM_SITE
             , YYYYMMDD
             , QTY
             , ATTRIBUTE1
             )
        SELECT IA.DIVISION_ID
             , IA.PLAN_START_YYYYMMDD
             , IA.PLAN_TYPE
             , IA.SEQ
             , IA.OPERATION_GROUP
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.FROM_SITE
               /* --,MEASURE */
             , IA.YYYYMMDD
             , SUM(IA.QTY) AS QTY
             , IA.ATTRIBUTE1
          FROM ( SELECT V_DIVISION_ID                AS DIVISION_ID
                      , V_PLAN_START_YYYYMMDD        AS PLAN_START_YYYYMMDD
                      , P_PLAN_TYPE                  AS PLAN_TYPE
                      , P_SEQ                        AS SEQ
                      , B.OPERATION_GROUP
                      , A.ITEM_ID
                      , SUBSTR(A.SITE_ID, 1, FN_CHARINDEX_REV(A.SITE_ID, '~', 0) - 1)  AS TO_SITE
                      , SUBSTR(A.LOT_ID, FN_CHARINDEX_REV(A.LOT_ID, '::', 0) + 2, 100) AS FROM_SITE
                        /* --,'INTRANSIT_ALL' AS MEASURE */
                      , TO_CHAR(A.RECEIVING_DTTM, 'YYYYMMDD') AS YYYYMMDD
                      , A.QTY
                      , 'TH_ENG_STOCK_PLAN_SN'       AS ATTRIBUTE1
                   FROM TH_ENG_STOCK_PLAN_SN A
                      , SCP_MST_FINAL_ITEM_V B
                  WHERE A.ITEM_ID   = B.ITEM_ID
                    AND A.DESCR     = 'INT'
                    AND A.MASTER_ID = P_MASTER_ID
                    AND A.PLAN_ID   = P_ENGINE_PLAN_ID
                    /* --AND CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) = @p_plan_start_yyyymmdd */
               ) IA
         GROUP BY IA.DIVISION_ID
                , IA.PLAN_START_YYYYMMDD
                , IA.PLAN_TYPE
                , IA.SEQ
                , IA.OPERATION_GROUP
                , IA.ITEM_ID
                , IA.TO_SITE
                , IA.FROM_SITE
                  /* --,MEASURE */
                , IA.YYYYMMDD
                , IA.ATTRIBUTE1;

        /* 원본 UPDATE .. FROM JOIN : 한 행에 여러 행(OPERATION_GROUP 이 다른)이 걸리면 MSSQL 은 임의 1건 → MAX 로 고정 */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT ITEM_ID
                     , TO_SITE
                     , FROM_SITE
                     , YYYYMMDD
                     , MAX(QTY) AS QTY
                  FROM GT_XSPK_INTRANSIT
                 GROUP BY ITEM_ID
                        , TO_SITE
                        , FROM_SITE
                        , YYYYMMDD
              ) IA
           ON (     A.ITEM_ID   = IA.ITEM_ID
                AND A.TO_SITE   = IA.TO_SITE
                AND A.FROM_SITE = IA.FROM_SITE
                AND A.YYYYMMDD  = IA.YYYYMMDD
                AND A.MEASURE   = 'PACK_INTRANSIT_ETA' )
         WHEN MATCHED THEN
       UPDATE
          SET A.QTY = NVL(IA.QTY, 0);

        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT ITEM_ID
                     , TO_SITE
                     , FROM_SITE
                     , YYYYMMDD
                     , MAX(QTY) AS QTY
                  FROM GT_XSPK_INTRANSIT
                 GROUP BY ITEM_ID
                        , TO_SITE
                        , FROM_SITE
                        , YYYYMMDD
              ) IA
           ON (     A.ITEM_ID   = IA.ITEM_ID
                AND A.TO_SITE   = IA.TO_SITE
                AND A.FROM_SITE = IA.FROM_SITE
                AND A.YYYYMMDD  = IA.YYYYMMDD
                AND A.MEASURE   = 'CELL_INTRANSIT_ETA' )
         WHEN MATCHED THEN
       UPDATE
          SET A.QTY = NVL(IA.QTY, 0);

        /* ------------------------------------------------------------------------------------------------------------- */
        /* BOH 반영(SCP_XLS_BOH) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #BOH → GT_XSPK_BOH */
        DELETE
          FROM GT_XSPK_BOH;

        /* 원본 CASE WHEN INCOTERMS = '' THEN '-' ELSE ISNULL(INCOTERMS,'-') END : MSSQL 은 '' · 공백 문자를 같게 봄 */
        INSERT
          INTO GT_XSPK_BOH
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , SCM_SITE_ID
             , INCOTERMS
             , ITEM_ID
             , QTY
             , ORIGIN_ITEM_ID
             , ORIGIN_QTY
             )
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , SCM_SITE_ID
               /* --                         ,INCOTERMS */
             , CASE WHEN TRIM(INCOTERMS) IS NULL THEN '-' ELSE INCOTERMS END AS INCOTERMS
             , ITEM_ID
             , SUM(QTY)        AS QTY
             , ORIGIN_ITEM_ID
             , SUM(ORIGIN_QTY) AS ORIGIN_QTY
          FROM SCP_XLS_BOH
         WHERE DIVISION_ID          = V_DIVISION_ID
           AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND PLAN_TYPE            = P_PLAN_TYPE
           AND SEQ                  = N_SEQ
         GROUP BY DIVISION_ID
                , PLAN_START_YYYYMMDD
                , PLAN_TYPE
                , SEQ
                , SCM_SITE_ID
                  /* --                         ,INCOTERMS */
                , CASE WHEN TRIM(INCOTERMS) IS NULL THEN '-' ELSE INCOTERMS END
                , ITEM_ID
                  /* --                         ,QTY */
                , ORIGIN_ITEM_ID;
                  /* --                         ,ORIGIN_QTY */

        /* 원본 UPDATE .. FROM JOIN : ORIGIN_ITEM_ID 별로 여러 행이 걸리면 MSSQL 은 임의 1건 → MAX 로 고정 */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT SCM_SITE_ID
                     , ITEM_ID
                     , INCOTERMS
                     , MAX(QTY) AS QTY
                  FROM GT_XSPK_BOH
                 GROUP BY SCM_SITE_ID
                        , ITEM_ID
                        , INCOTERMS
              ) IA
           ON (     A.FROM_SITE = IA.SCM_SITE_ID
                AND A.ITEM_ID   = IA.ITEM_ID
                AND A.INCOTERMS = IA.INCOTERMS
                /* --AND X.DIVISION_ID          = Y.DIVISION_ID */
                /* --AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD */
                /* --AND X.PLAN_TYPE            = Y.PLAN_TYPE */
                /* --AND X.SEQ                  = Y.SEQ */
                AND A.YYYYMMDD  = V_PLAN_START_YYYYMMDD
                AND A.MEASURE   = 'PACK_BOH' )
         WHEN MATCHED THEN
       UPDATE
          SET A.QTY = NVL(IA.QTY, 0);

        /* 원본 MERGE .. WHEN NOT MATCHED : 원본 X.PROJECT_CODE = Y.PROJECT_CODE('') → Oracle 에서는 A.PROJECT_CODE IS NULL */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT DISTINCT
                       B.DIVISION_ID
                     , 'A'                          AS OPERATION_GROUP
                     , B.CELL_ITEM_ID
                     , B.CELL_ITEM_ID               AS ITEM_ID
                     , D.SCM_SITE_ID                AS TO_SITE
                     , NULL                         AS PROJECT_CODE  /* '' */
                     , B.TO_BOH_QTY
                     , B.FROM_BOH_QTY
                     , '-'                          AS INCOTERMS
                     , '-'                          AS FROM_SITE
                     , '-'                          AS TRANSPORT_MODE_LINE
                     , '-'                          AS TRANSPORT_MODE
                     , '-'                          AS PROD_LINE
                     , SUBSTR(C.COLUMN_NAME, 1, 100) AS MEASURE
                     , B.YYYYMMDD
                     , C.SORT_ORDER_NO
                     , C.COLUMN_LABEL_NAME
                     , '-'                          AS BOD_ID
                     , B.ATTRIBUTE1
                     , B.ATTRIBUTE9
                     , B.ATTRIBUTE10
                  FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK B
                     , GT_XSPK_MEASURE C  /* CROSS APPLY */
                     , GT_XSPK_BOH D
                 WHERE B.CELL_ITEM_ID = D.ITEM_ID
                   AND D.SCM_SITE_ID  LIKE '%-P'
                   AND C.DIV          = 'A'
                   AND C.GUBUN        = 'TO'
                   AND B.YYYYMMDD     = V_PLAN_START_YYYYMMDD  /* -- '20191118' */
                   AND B.TO_SITE     <> '-'
              ) IA
           ON (     A.OPERATION_GROUP = IA.OPERATION_GROUP
                AND A.CELL_ITEM_ID    = IA.CELL_ITEM_ID
                AND A.ITEM_ID         = IA.ITEM_ID
                AND A.TO_SITE         = IA.TO_SITE
                AND A.PROJECT_CODE    IS NULL  /* X.PROJECT_CODE = Y.PROJECT_CODE('') */
                AND A.INCOTERMS       = IA.INCOTERMS
                AND A.FROM_SITE       = IA.FROM_SITE
                AND A.BOD_ID          = IA.BOD_ID
                AND A.MEASURE         = IA.MEASURE )
         WHEN NOT MATCHED THEN
       INSERT ( DIVISION_ID
              , OPERATION_GROUP
              , CELL_ITEM_ID
              , ITEM_ID
              , TO_SITE
              , PROJECT_CODE
              , TO_BOH_QTY
              , FROM_BOH_QTY
              , INCOTERMS
              , FROM_SITE
              , TRANSPORT_MODE_LINE
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
              , ATTRIBUTE10
              , WEEK_COLUMN
              )
       VALUES ( IA.DIVISION_ID
              , IA.OPERATION_GROUP
              , IA.CELL_ITEM_ID
              , IA.ITEM_ID
              , IA.TO_SITE
              , IA.PROJECT_CODE
              , IA.TO_BOH_QTY
              , IA.FROM_BOH_QTY
              , IA.INCOTERMS
              , IA.FROM_SITE
              , IA.TRANSPORT_MODE_LINE
              , IA.TRANSPORT_MODE
              , IA.PROD_LINE
              , IA.MEASURE
              , IA.YYYYMMDD
              , 0
              , IA.SORT_ORDER_NO
              , IA.COLUMN_LABEL_NAME
              , IA.BOD_ID
              , IA.ATTRIBUTE1
              , IA.ATTRIBUTE9
              , IA.ATTRIBUTE10
              , 'A'
              );

        /* 원본 UPDATE .. FROM JOIN : ORIGIN_ITEM_ID 별로 여러 행이 걸리면 MSSQL 은 임의 1건 → MAX 로 고정 */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT SCM_SITE_ID
                     , ITEM_ID
                     , INCOTERMS
                     , MAX(QTY) AS QTY
                  FROM GT_XSPK_BOH
                 GROUP BY SCM_SITE_ID
                        , ITEM_ID
                        , INCOTERMS
              ) IA
           ON (     A.TO_SITE   = IA.SCM_SITE_ID
                AND A.ITEM_ID   = IA.ITEM_ID
                AND A.YYYYMMDD  = V_PLAN_START_YYYYMMDD
                AND A.MEASURE   = 'TO_SITE_BOH'
                AND A.INCOTERMS = IA.INCOTERMS )
         WHEN MATCHED THEN
       UPDATE
          SET A.QTY = NVL(IA.QTY, 0);  /* -- 임시로 100 */

        /* 원본 UPDATE .. FROM JOIN : INCOTERMS·ORIGIN_ITEM_ID 별로 여러 행이 걸리면 MSSQL 은 임의 1건 → MAX 로 고정 */
        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT SCM_SITE_ID
                     , ITEM_ID
                     , MAX(QTY) AS QTY
                  FROM GT_XSPK_BOH
                 GROUP BY SCM_SITE_ID
                        , ITEM_ID
              ) IA
           ON (     A.TO_SITE = IA.SCM_SITE_ID
                AND A.ITEM_ID = IA.ITEM_ID
                AND A.MEASURE = 'CELL_BALANCE' )
         WHEN MATCHED THEN
       UPDATE
          SET A.TO_BOH_QTY = NVL(IA.QTY, 0);

        /* ------------------------------------------------------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------------------------------------------------- */
        /* ##PSI_GLOBAL_SMALL_PACK : SELECT * INTO ##PSI_GLOBAL_SMALL_PACK FROM #PSI_GLOBAL_SMALL_PACK
           → 같은 세션 GTT GT_XSPK_PSI_GLOBAL_SMALL_PACK 를 PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S 가 그대로 읽음(복사 불필요) */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 1년단위 표준저장프로시저 호출부 */
        /* ------------------------------------------------------------------------------------------------------------- */
        V_CREATE_FROM_YYYYMMDD := V_PLAN_START_YYYYMMDD;
        V_CREATE_TO_YYYYMMDD   := TO_CHAR(TO_DATE(V_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD');

        DBMS_OUTPUT.PUT_LINE('BEFORE PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S');  /* PRINT */
        PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S( P_PLAN_CYCLE           => P_PLAN_CYCLE
                                          , P_PLAN_START_YYYYMMDD  => V_PLAN_START_YYYYMMDD
                                          , P_PLAN_ID              => P_PLAN_ID
                                          , P_MODELING_ID          => P_MODELING_ID
                                          , P_SEQ                  => P_SEQ
                                          , P_PLAN_TYPE            => P_PLAN_TYPE
                                          , P_MASTER_ID            => P_MASTER_ID
                                          , P_DIVISION_ID          => V_DIVISION_ID
                                          , P_ENGINE_PLAN_ID       => P_ENGINE_PLAN_ID
                                          , P_CREATE_FROM_YYYYMMDD => V_CREATE_FROM_YYYYMMDD
                                          , P_CREATE_TO_YYYYMMDD   => V_CREATE_TO_YYYYMMDD
                                          , P_USER_ID              => V_BATCH_USER
                                          , P_IS_DEBUG             => P_IS_DEBUG
                                          , O_RETURN               => N_ROWS
                                          );

        IF N_ROWS < 0 THEN
            O_RETURN := -1;  /* GOTO _RETURN_ERR_CODE : RETURN -1 */
            RETURN;
        END IF;

        IF V_BP_FLAG = 'Y' THEN
            /* 2 YEAR PIVOT DATS 생성 */
            V_CREATE_FROM_YYYYMMDD := TO_CHAR(TO_DATE(V_CREATE_TO_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');
            V_CREATE_TO_YYYYMMDD   := TO_CHAR(TO_DATE(V_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD');

            PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S( P_PLAN_CYCLE           => P_PLAN_CYCLE
                                              , P_PLAN_START_YYYYMMDD  => V_PLAN_START_YYYYMMDD
                                              , P_PLAN_ID              => P_PLAN_ID
                                              , P_MODELING_ID          => P_MODELING_ID
                                              , P_SEQ                  => P_SEQ
                                              , P_PLAN_TYPE            => P_PLAN_TYPE
                                              , P_MASTER_ID            => P_MASTER_ID
                                              , P_DIVISION_ID          => V_DIVISION_ID
                                              , P_ENGINE_PLAN_ID       => P_ENGINE_PLAN_ID
                                              , P_CREATE_FROM_YYYYMMDD => V_CREATE_FROM_YYYYMMDD
                                              , P_CREATE_TO_YYYYMMDD   => V_CREATE_TO_YYYYMMDD
                                              , P_USER_ID              => V_BATCH_USER
                                              , P_IS_DEBUG             => P_IS_DEBUG
                                              , O_RETURN               => N_ROWS
                                              );

            IF N_ROWS < 0 THEN
                O_RETURN := -1;  /* GOTO _RETURN_ERR_CODE : RETURN -1 */
                RETURN;
            END IF;

            /* 20231010 강현준 수정 */
            /* 1년차는 100000 번째의 XLS_KEY1 생성 */
            UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK
               SET XLS_KEY1 = XLS_KEY1 + 100000
             WHERE DIVISION_ID          = V_DIVISION_ID
               AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
               AND PLAN_TYPE            = P_PLAN_TYPE
               AND SEQ                  = N_SEQ
               AND CREATE_FROM_YYYYMMDD = V_PLAN_START_YYYYMMDD;  /* 1년차이므로 @p_plan_start_yyyymmdd로 활용 */

            /* 2년차는 1년차의 XLS_KEY1와 MAPPING 하여 생성 */
            /* 원본 UPDATE B .. FROM A, B : 2년차 한 행에 1년차 여러 행이 걸리면 MSSQL 은 임의 1건 → MAX 로 고정 */
            MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
            USING ( SELECT B.DIVISION_ID
                         , B.PLAN_START_YYYYMMDD
                         , B.PLAN_TYPE
                         , B.SEQ
                         , B.OPERATION_GROUP
                         , B.ITEM_ID
                         , B.CELL_ITEM_ID
                         , B.TO_SITE
                         , B.FROM_SITE
                         , B.MEASURE
                         , B.BOD_ID
                         , B.INCOTERMS
                         , B.PROJECT_CODE
                         , MAX(B.XLS_KEY1) AS XLS_KEY1
                      FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK B
                     WHERE B.DIVISION_ID          = V_DIVISION_ID
                       AND B.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                       AND B.PLAN_TYPE            = P_PLAN_TYPE
                       AND B.SEQ                  = N_SEQ
                       AND B.CREATE_FROM_YYYYMMDD = V_PLAN_START_YYYYMMDD  /* 1년차이므로 @p_plan_start_yyyymmdd로 활용 */
                     GROUP BY B.DIVISION_ID
                            , B.PLAN_START_YYYYMMDD
                            , B.PLAN_TYPE
                            , B.SEQ
                            , B.OPERATION_GROUP
                            , B.ITEM_ID
                            , B.CELL_ITEM_ID
                            , B.TO_SITE
                            , B.FROM_SITE
                            , B.MEASURE
                            , B.BOD_ID
                            , B.INCOTERMS
                            , B.PROJECT_CODE
                  ) IA
               ON (     A.DIVISION_ID          = IA.DIVISION_ID
                    AND A.PLAN_START_YYYYMMDD  = IA.PLAN_START_YYYYMMDD
                    AND A.PLAN_TYPE            = IA.PLAN_TYPE
                    AND A.SEQ                  = IA.SEQ
                    AND A.OPERATION_GROUP      = IA.OPERATION_GROUP
                    AND A.ITEM_ID              = IA.ITEM_ID
                    AND A.CELL_ITEM_ID         = IA.CELL_ITEM_ID
                    AND A.TO_SITE              = IA.TO_SITE
                    AND A.FROM_SITE            = IA.FROM_SITE
                    AND A.MEASURE              = IA.MEASURE
                    AND A.BOD_ID               = IA.BOD_ID
                    AND A.INCOTERMS            = IA.INCOTERMS
                    AND A.PROJECT_CODE         = IA.PROJECT_CODE
                    AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD )  /* 2년차이므로 @v_create_from_yyyymmdd로 활용 */
             WHEN MATCHED THEN
           UPDATE
              SET A.XLS_KEY1 = IA.XLS_KEY1;

            /* 2년차에 신규 생성된것은 200000 대로 처리 */
            UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK
               SET XLS_KEY1 = XLS_KEY1 + 200000
             WHERE DIVISION_ID          = V_DIVISION_ID
               AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
               AND PLAN_TYPE            = P_PLAN_TYPE
               AND SEQ                  = N_SEQ
               AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* 2년차이므로 @v_create_from_yyyymmdd로 활용 */
               AND XLS_KEY1             < 100000;                 /* 위의 UPDATE 로직 이외의 것은 100000 이하로 남아 있음. */
        END IF;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 임시 TEMP  테이블 DROP */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* GTT 는 지우지 않음(세션 GTT · 다음 실행 시작 때 DELETE) */

        /* ----------------------------------------------------------- */
        /* 실행 Logic END -- */
        /* ----------------------------------------------------------- */

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := 1;  /* @@ROWCOUNT : 바로 앞 SET @v_log_type = .. (단순 대입) 의 건수 1 — MSSQL 실측 */
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

    EXCEPTION  /* BEGIN CATCH */
        WHEN OTHERS THEN
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            IF P_IS_DEBUG = '0' THEN
                PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                                    , P_LOG_TYPE      => V_LOG_TYPE
                                    , P_LOG_COUNT     => N_LOG_COUNT
                                    , P_LOG_MESSAGE   => V_LOG_MESSAGE
                                    , P_DESCRIPTION   => V_DESCRIPTION
                                    , P_EVENT_DATE    => D_EVENT_DATE
                                    , P_USER_ID       => V_BATCH_USER
                                    , P_IN_PARA_DATA  => SUBSTR('{"P_PLAN_START_YYYYMMDD":"' || P_PLAN_START_YYYYMMDD || '","P_DIVISION_ID":"' || P_DIVISION_ID || '","P_PLAN_TYPE":"' || P_PLAN_TYPE || '","P_SEQ":"' || P_SEQ || '","P_MASTER_ID":"' || P_MASTER_ID || '","P_ENGINE_PLAN_ID":"' || P_ENGINE_PLAN_ID || '"}', 1, 4000)
                                    , P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
                                    , P_SQL_ERR_MSG   => SUBSTR(SQLERRM, 1, 4000)
                                    , P_SQL_BACKTRACE => SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000)
                                    );
            END IF;
            O_RETURN := -1;
            RETURN;  /* return -1 */
    END;  /* END CATCH; */

    /* 임시 운영반영시에 주석처리 할것. */
    /* 원본 REPLICATE('0', 2 - LEN(x)) + x : x 가 3자리 이상이면 REPLICATE 가 NULL → 전체 NULL (CASE 로 재현) */
    V_EXEC_TIME := CASE WHEN TRUNC(TRUNC((SYSDATE - D_START_TIME) * 86400) / 60) > 99 THEN NULL
                        ELSE LPAD(TO_CHAR(TRUNC(TRUNC((SYSDATE - D_START_TIME) * 86400) / 60)), 2, '0')
                             || ':' ||
                             LPAD(TO_CHAR(MOD(TRUNC((SYSDATE - D_START_TIME) * 86400), 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']';
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

    /* _RETURN_ERR_CODE: RETURN -1 → 위 두 호출부에서 O_RETURN := -1; RETURN; 으로 처리 */
END;