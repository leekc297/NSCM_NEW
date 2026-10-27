PROCEDURE PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S
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
    , P_CREATE_FROM_YYYYMMDD  IN  VARCHAR2                         /* NVARCHAR(0008) */
    , P_CREATE_TO_YYYYMMDD    IN  VARCHAR2                         /* NVARCHAR(0008) */
    , P_USER_ID               IN  VARCHAR2 DEFAULT 'SCP_batch'     /* NVARCHAR(0150) = 'SCP_batch' */
    , P_IS_DEBUG              IN  VARCHAR2 DEFAULT '0'             /* bit = 0  : 0 :운영, 1 : 개발 */
    , O_RETURN                OUT NUMBER                           /* AS-IS RETURN 값 → OUT 인자(반환값 규칙) */
)
/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S
 * Description  : SCP SIMULATION CREATE
 * OutTable     :
 * Execute      :
                 EXEC PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S


 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.09.25   DHJ            Initial Release PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2
 * 2023.10.26   kHJ            동일 ITEM, 동일 FROM-TO SITE에서 2개 이상의 PROJECT_CODE 발생 ==> MIN으로 처리 (단, SHIP_AMEND는 PROJECT_CODE별로 분리가능)
 * 2025.09.02   kimcd          속도 개선 HASH 추가
 * 2026.07.24   YMH            E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
AS
    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET NOCOUNT ON; SET XACT_ABORT ON; SET ANSI_WARNINGS ON; SET ANSI_NULLS ON; (Oracle 기본 동작) */
    /* --SET ANSI_WARNINGS OFF; */

    /* AS-IS 인자 선언 길이 재현 : NVARCHAR(0150) · NVARCHAR(0008) · NVARCHAR(0030) */
    V_PLAN_CYCLE            VARCHAR2(150 CHAR) := SUBSTR(P_PLAN_CYCLE, 1, 150);
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)   := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_DIVISION_ID           VARCHAR2(30 CHAR)  := SUBSTR(P_DIVISION_ID, 1, 30);
    V_CREATE_FROM_YYYYMMDD  VARCHAR2(8 CHAR)   := SUBSTR(P_CREATE_FROM_YYYYMMDD, 1, 8);
    V_CREATE_TO_YYYYMMDD    VARCHAR2(8 CHAR)   := SUBSTR(P_CREATE_TO_YYYYMMDD, 1, 8);
    V_USER_ID               VARCHAR2(150 CHAR) := SUBSTR(P_USER_ID, 1, 150);
    N_SEQ                   NUMBER;            /* @p_seq(NVARCHAR) 를 BIGINT 칸과 비교하던 자리 : 숫자로 한 번 변환 */

    /* LOG 용 변수 설정 */
    V_BATCH_USER            VARCHAR2(150 CHAR) := 'SCP_batch';
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S';
    V_LOG_TYPE              VARCHAR2(30 CHAR);  /* START/END/ERROR/... */
    N_LOG_COUNT             NUMBER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    V_TABLE_ID              VARCHAR2(150 CHAR) := 'SCM_SYS_LOG_BATCH';
    D_EVENT_DATE            DATE;

    /* 실행시간 확인용 */
    D_START_TIME            DATE               := SYSDATE;
    V_EXEC_TIME             VARCHAR2(10 CHAR)  := '';  /* --'00:00'; */

    V_PROGRAM_ID            VARCHAR2(30 CHAR)  := 'XLSPSI02';
    /* --DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) */
    /* --DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112) */

    N_MAX_XLS_KEY1          NUMBER := 0;  /* @p_update가 'Y' 일경우  전체 xls_key1 MAX */

    /*
    IF @p_update = 'Y'
      BEGIN
        SELECT @v_Max_xls_key1 = ISNULL(MAX(xls_key1),0) +1
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
      END
      */
    /* --DECLARE @debug_mode            NVARCHAR(30) = 'T' */

    /* W-1 · W-2 주차 일자(원본 CONVERT(VARCHAR(8), DATEADD(day, n, ..), 112)) */
    V_PREV_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR);  /* @p_plan_start_yyyymmdd - 7 */
    V_PREV_CREATE_FROM_YYYYMMDD  VARCHAR2(8 CHAR);  /* @p_create_from_yyyymmdd - 7 */
    V_PREV2_PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR);  /* @p_plan_start_yyyymmdd - 14 */

    /* 원본에서 단계마다 반복하던 log step 호출(TXN · 건수 0) */
    PROCEDURE LOG_STEP ( P_STEP IN VARCHAR2 )
    IS
    BEGIN
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || P_STEP;
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );
    END LOG_STEP;

BEGIN
    O_RETURN := 1;  /* 반환값 초기화 */
    V_BATCH_USER := V_USER_ID;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    BEGIN  /* BEGIN TRY */
        N_SEQ                       := TO_NUMBER(P_SEQ);
        V_PREV_PLAN_START_YYYYMMDD  := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD');
        V_PREV_CREATE_FROM_YYYYMMDD := TO_CHAR(TO_DATE(V_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD');
        V_PREV2_PLAN_START_YYYYMMDD := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 14, 'YYYYMMDD');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* LT 계산용 테이블 생성 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #SCP_MST_BOD_V → GT_XSPK_BOD_V */
        DELETE
          FROM GT_XSPK_BOD_V;

        INSERT
          INTO GT_XSPK_BOD_V
             ( DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , BOD_ID
             )
        SELECT DISTINCT
               DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , BOD_ID
          FROM SCP_MST_BOD_N_V  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
         WHERE DIVISION_ID = V_DIVISION_ID;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 001 ');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* LINE_TOTAL_LOAD_ENGINE (TACT_TIME,WORKING_TIME) */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* Line Load 율 로직 작업중 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* Working Time 추출 : #LINE_WORKINGTIME_BY_LOSS 는 한 번만 쓰이므로 아래 INSERT 의 인라인 뷰(IA)로 옮김 */
        /* --		            FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS(@p_division_id, @p_plan_start_yyyymmdd, @p_create_to_yyyymmdd, '' ) */

        /* #LineLoad → GT_XSPK_LINELOAD */
        DELETE
          FROM GT_XSPK_LINELOAD;

        INSERT
          INTO GT_XSPK_LINELOAD
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
             , WEEK_COLUMN
             )
        SELECT /*DISTINCT */
               A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.OPERATION_GROUP
             , A.OPERATION_ID
             , A.LINE_ID
             , 'PACK_PROD_LOAD' AS MEASURE
             , CASE WHEN IA.WORKING_TIME <= 0.0 THEN 0 ELSE NVL(((ROUND(SUM(A.QTY * (C.TACT_TIME / 60)), 0) / IA.WORKING_TIME)), 0) * 100 END AS QTY
             , NVL(ROUND(SUM(A.QTY * (C.TACT_TIME / 60)), 0), 0) AS CAPA_TACT
             , NVL(IA.WORKING_TIME, 0) AS WORKING_TIME
             , A.YYYYMMDD
             , B.ISO_YYYYWW
               /* 원본 'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK() ..)) + CONVERT(NVARCHAR, DENSE_RANK() ..) */
             , 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY B.ISO_YYYYWW NULLS FIRST)), 2, '0') AS WEEK_COLUMN
          FROM SCP_ANL_PRODUCTION_PLAN A
             , SCM_SYS_CALENDAR_M B
             , ( SELECT XA.DIVISION_ID
                      , XA.PLANT_SITE_ID AS SCM_SITE_ID
                      , XA.OPERATION_ID
                      , XA.LINE_ID
                      , XA.YYYYMMDD
                      , XA.WORKING_TIME
                   FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS(V_DIVISION_ID, V_CREATE_FROM_YYYYMMDD, V_CREATE_TO_YYYYMMDD, NULL)) XA
               ) IA
             , SCP_ANL_TACT_TIME C
         WHERE A.YYYYMMDD               = B.BASIS_YYYYMMDD
           AND A.DIVISION_ID            = IA.DIVISION_ID(+)
           AND A.OPERATION_ID           = IA.OPERATION_ID(+)
           AND A.SCM_SITE_ID            = IA.SCM_SITE_ID(+)
           AND A.LINE_ID                = IA.LINE_ID(+)
           AND A.YYYYMMDD               = IA.YYYYMMDD(+)
           AND A.DIVISION_ID            = C.DIVISION_ID(+)
           AND A.OPERATION_ID           = C.OPERATION_ID(+)
           AND A.SCM_SITE_ID            = C.SCM_SITE_ID(+)
           AND A.LINE_ID                = C.LINE_ID(+)  /* --- LINE_ID ='-' */
           AND A.ITEM_ID                = C.ITEM_ID(+)
           AND A.YYYYMMDD               = C.YYYYMMDD(+)
           AND A.MEASURE                = 'PROD_PLAN_AMEND'
           AND A.OPERATION_GROUP        = 'P'
           AND A.DIVISION_ID            = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD    = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE              = P_PLAN_TYPE
           AND A.SEQ                    = N_SEQ
           AND A.YYYYMMDD              >= V_CREATE_FROM_YYYYMMDD
           AND A.YYYYMMDD              <= V_CREATE_TO_YYYYMMDD
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.OPERATION_ID
                , A.LINE_ID
                , A.YYYYMMDD
                , IA.WORKING_TIME
                , B.ISO_YYYYWW
                , A.OPERATION_GROUP;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 002 ');

        /* ##PSI_GLOBAL_SMALL_PACK → GT_XSPK_PSI_GLOBAL_SMALL_PACK (부르는 쪽 PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK 과 같은 세션 GTT) */
        /* 원본 UPDATE .. FROM JOIN : 한 행에 #LineLoad 여러 행(라인별)이 걸리면 MSSQL 은 임의 1건 → MAX 로 고정 */
        UPDATE GT_XSPK_PSI_GLOBAL_SMALL_PACK A
           SET A.QTY = (SELECT MAX(SA.QTY)
                          FROM GT_XSPK_LINELOAD SA
                         WHERE SA.DIVISION_ID = A.DIVISION_ID
                           AND SA.YYYYMMDD    = A.YYYYMMDD
                           AND SA.SCM_SITE_ID = A.FROM_SITE)
         WHERE EXISTS (SELECT 1
                         FROM GT_XSPK_LINELOAD XA
                        WHERE XA.DIVISION_ID = A.DIVISION_ID
                          AND XA.YYYYMMDD    = A.YYYYMMDD
                          AND XA.SCM_SITE_ID = A.FROM_SITE)
           AND A.MEASURE = 'PACK_PROD_LOAD';

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 003 ');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_SMALL_PACK) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #SCP_XLS_PSI_GLOBAL_SMALL_PACK → GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK (원본 CREATE TABLE 칸 정의는 GTT DDL 로 옮김) */
        /* --DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_PACKL */
        /* 원본 CREATE TABLE 칸 주석 :
           --				  CREATE_FROM_YYYYMMDD  NVARCHAR(008)     NULL,
           --				  CREATE_TO_YYYYMMDD    NVARCHAR(008)     NULL,
           OPERATION_GROUP_NAME -- 신규
           CELL_QTY_PACK -- 신규
           TO_SITE_DESCRIPTION -- SCM_SITE_DESCRIPTION
           PROJECT_CODE -- FG 때문에 추가
           FROM_SITE_DESCRIPTION -- SCM_SITE_DESCRIPTION
           MEASURE_LABEL -- COLUMN_LABEL_NAME
           --    CALC_YN               NVARCHAR(001)     NULL,
           --DISPLAY_YN            NVARCHAR(001)     NULL,
           QTY001 ~ QTY005 -- 신규
           --                CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
           ATTRIBUTE9 -- OPERATION_ID
        */
        DELETE
          FROM GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 364일 데이터 생성(PIVOIT 대상 날짜문자열 생성) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 원본 @mQry_sum 조립(SELECT @mQry_sum = @mQry_sum + ..)은 이후 어디에서도 쓰이지 않아 옮기지 않음 */
        /* --				  PRINT '364일 데이터 생성(PIVOIT 대상 날짜문자열 생성)'; */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 전체 DATA 생성 (#PSI_GLOBAL_SMALL_PACK --> #SCP_XLS_PSI_GLOBAL_SMALL_PACK) PIVOT */
        /* 속도 때문에 CASE문에서 PIVOT문으로 변경함. */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* --ALTER TABLE #PSI_GLOBAL_SMALL_PACK */
        /* --ADD WEEK_COLUMN NVARCHAR(6) */

        /* #WEEK_COLUMN : 한 번만 쓰이므로 아래 MERGE 의 USING 으로 옮김 */
        /* --              WHERE X.YYYYMMDD >= @p_plan_start_yyyymmdd */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 004 ');

        MERGE INTO GT_XSPK_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT DISTINCT
                       YYYYMMDD
                     , 'QTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(ORDER BY YYYYMMDD)), 3, '0') AS WEEK_COLUMN
                  FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK
                 WHERE YYYYMMDD >= V_CREATE_FROM_YYYYMMDD
                   AND YYYYMMDD <= V_CREATE_TO_YYYYMMDD
              ) IA
           ON ( A.YYYYMMDD = IA.YYYYMMDD )
         WHEN MATCHED THEN
       UPDATE
          SET A.WEEK_COLUMN = IA.WEEK_COLUMN;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 005 ');

        /* 원본 PIVOT(SUM(QTY) FOR WEEK_COLUMN IN ([QTY001]..[QTY364])) + ISNULL(QTYnnn,0) → SUM(CASE ..) + GROUP BY (PIVOT 문 미사용) */
        /* 원본 '0' AS CELL_QTY_PACK · '' AS LT_DAY 는 숫자 칸에 들어가며 MSSQL 이 0 으로 바꿈(CONVERT(int, '') = 0 실측) → 0 */
        INSERT
          INTO GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             /* --					  ,CREATE_FROM_YYYYMMDD */
             /* --					  ,CREATE_TO_YYYYMMDD */
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
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
             )
        SELECT V_DIVISION_ID                AS DIVISION_ID
             , V_PLAN_START_YYYYMMDD        AS PLAN_START_YYYYMMDD
             /* --			, @p_create_from_yyyymmdd  AS CREATE_FROM_YYYYMMDD */
             /* --			, @p_create_to_yyyymmdd    AS CREATE_TO_YYYYMMDD */
             , P_PLAN_TYPE                  AS PLAN_TYPE
             , N_SEQ                        AS SEQ
             , OPERATION_GROUP
             , NULL                         AS OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NULL                         AS NICK_NAME
             , 0                            AS CELL_QTY_PACK  /* 완료후 UPDATE */
             , TO_SITE
             , NULL                         AS TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CASE WHEN TRIM(INCOTERMS) IS NULL THEN '-' ELSE INCOTERMS END AS INCOTERMS  /* ISNULL(NULLIF( A.INCOTERMS, '') , '-') : MSSQL 은 '' · 공백 문자를 같게 봄 */
             , FROM_SITE
             , '-'                          AS FROM_SITE_DESCRIPTION
             , NVL(TRANSPORT_MODE, '-')     AS TRANSPORT_MODE
             , NVL(PROD_LINE, '-')          AS PROD_LINE
             , 0                            AS LT_DAY         /* 완료후 UPDATE */
             , BOD_ID
             , MEASURE
             , COLUMN_LABEL_NAME            AS MEASURE_LABEL
             , NULL                         AS XLS_KEY1
             , NULL                         AS XLS_KEY2
             , NULL                         AS XLS_KEY3
             , NULL                         AS XLS_KEY4
             , NULL                         AS XLS_KEY5
             , NULL                         AS XLS_ATTRIBUTE1
             , NULL                         AS XLS_ATTRIBUTE2
             , NULL                         AS XLS_ATTRIBUTE3
             , NULL                         AS XLS_ATTRIBUTE4
             , NULL                         AS XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY001' THEN QTY END), 0) AS QTY001
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY002' THEN QTY END), 0) AS QTY002
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY003' THEN QTY END), 0) AS QTY003
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY004' THEN QTY END), 0) AS QTY004
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY005' THEN QTY END), 0) AS QTY005
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY006' THEN QTY END), 0) AS QTY006
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY007' THEN QTY END), 0) AS QTY007
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY008' THEN QTY END), 0) AS QTY008
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY009' THEN QTY END), 0) AS QTY009
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY010' THEN QTY END), 0) AS QTY010
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY011' THEN QTY END), 0) AS QTY011
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY012' THEN QTY END), 0) AS QTY012
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY013' THEN QTY END), 0) AS QTY013
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY014' THEN QTY END), 0) AS QTY014
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY015' THEN QTY END), 0) AS QTY015
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY016' THEN QTY END), 0) AS QTY016
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY017' THEN QTY END), 0) AS QTY017
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY018' THEN QTY END), 0) AS QTY018
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY019' THEN QTY END), 0) AS QTY019
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY020' THEN QTY END), 0) AS QTY020
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY021' THEN QTY END), 0) AS QTY021
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY022' THEN QTY END), 0) AS QTY022
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY023' THEN QTY END), 0) AS QTY023
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY024' THEN QTY END), 0) AS QTY024
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY025' THEN QTY END), 0) AS QTY025
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY026' THEN QTY END), 0) AS QTY026
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY027' THEN QTY END), 0) AS QTY027
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY028' THEN QTY END), 0) AS QTY028
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY029' THEN QTY END), 0) AS QTY029
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY030' THEN QTY END), 0) AS QTY030
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY031' THEN QTY END), 0) AS QTY031
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY032' THEN QTY END), 0) AS QTY032
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY033' THEN QTY END), 0) AS QTY033
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY034' THEN QTY END), 0) AS QTY034
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY035' THEN QTY END), 0) AS QTY035
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY036' THEN QTY END), 0) AS QTY036
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY037' THEN QTY END), 0) AS QTY037
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY038' THEN QTY END), 0) AS QTY038
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY039' THEN QTY END), 0) AS QTY039
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY040' THEN QTY END), 0) AS QTY040
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY041' THEN QTY END), 0) AS QTY041
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY042' THEN QTY END), 0) AS QTY042
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY043' THEN QTY END), 0) AS QTY043
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY044' THEN QTY END), 0) AS QTY044
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY045' THEN QTY END), 0) AS QTY045
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY046' THEN QTY END), 0) AS QTY046
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY047' THEN QTY END), 0) AS QTY047
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY048' THEN QTY END), 0) AS QTY048
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY049' THEN QTY END), 0) AS QTY049
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY050' THEN QTY END), 0) AS QTY050
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY051' THEN QTY END), 0) AS QTY051
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY052' THEN QTY END), 0) AS QTY052
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY053' THEN QTY END), 0) AS QTY053
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY054' THEN QTY END), 0) AS QTY054
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY055' THEN QTY END), 0) AS QTY055
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY056' THEN QTY END), 0) AS QTY056
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY057' THEN QTY END), 0) AS QTY057
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY058' THEN QTY END), 0) AS QTY058
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY059' THEN QTY END), 0) AS QTY059
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY060' THEN QTY END), 0) AS QTY060
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY061' THEN QTY END), 0) AS QTY061
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY062' THEN QTY END), 0) AS QTY062
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY063' THEN QTY END), 0) AS QTY063
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY064' THEN QTY END), 0) AS QTY064
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY065' THEN QTY END), 0) AS QTY065
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY066' THEN QTY END), 0) AS QTY066
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY067' THEN QTY END), 0) AS QTY067
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY068' THEN QTY END), 0) AS QTY068
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY069' THEN QTY END), 0) AS QTY069
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY070' THEN QTY END), 0) AS QTY070
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY071' THEN QTY END), 0) AS QTY071
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY072' THEN QTY END), 0) AS QTY072
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY073' THEN QTY END), 0) AS QTY073
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY074' THEN QTY END), 0) AS QTY074
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY075' THEN QTY END), 0) AS QTY075
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY076' THEN QTY END), 0) AS QTY076
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY077' THEN QTY END), 0) AS QTY077
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY078' THEN QTY END), 0) AS QTY078
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY079' THEN QTY END), 0) AS QTY079
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY080' THEN QTY END), 0) AS QTY080
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY081' THEN QTY END), 0) AS QTY081
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY082' THEN QTY END), 0) AS QTY082
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY083' THEN QTY END), 0) AS QTY083
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY084' THEN QTY END), 0) AS QTY084
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY085' THEN QTY END), 0) AS QTY085
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY086' THEN QTY END), 0) AS QTY086
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY087' THEN QTY END), 0) AS QTY087
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY088' THEN QTY END), 0) AS QTY088
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY089' THEN QTY END), 0) AS QTY089
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY090' THEN QTY END), 0) AS QTY090
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY091' THEN QTY END), 0) AS QTY091
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY092' THEN QTY END), 0) AS QTY092
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY093' THEN QTY END), 0) AS QTY093
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY094' THEN QTY END), 0) AS QTY094
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY095' THEN QTY END), 0) AS QTY095
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY096' THEN QTY END), 0) AS QTY096
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY097' THEN QTY END), 0) AS QTY097
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY098' THEN QTY END), 0) AS QTY098
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY099' THEN QTY END), 0) AS QTY099
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY100' THEN QTY END), 0) AS QTY100
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY101' THEN QTY END), 0) AS QTY101
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY102' THEN QTY END), 0) AS QTY102
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY103' THEN QTY END), 0) AS QTY103
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY104' THEN QTY END), 0) AS QTY104
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY105' THEN QTY END), 0) AS QTY105
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY106' THEN QTY END), 0) AS QTY106
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY107' THEN QTY END), 0) AS QTY107
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY108' THEN QTY END), 0) AS QTY108
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY109' THEN QTY END), 0) AS QTY109
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY110' THEN QTY END), 0) AS QTY110
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY111' THEN QTY END), 0) AS QTY111
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY112' THEN QTY END), 0) AS QTY112
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY113' THEN QTY END), 0) AS QTY113
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY114' THEN QTY END), 0) AS QTY114
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY115' THEN QTY END), 0) AS QTY115
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY116' THEN QTY END), 0) AS QTY116
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY117' THEN QTY END), 0) AS QTY117
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY118' THEN QTY END), 0) AS QTY118
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY119' THEN QTY END), 0) AS QTY119
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY120' THEN QTY END), 0) AS QTY120
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY121' THEN QTY END), 0) AS QTY121
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY122' THEN QTY END), 0) AS QTY122
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY123' THEN QTY END), 0) AS QTY123
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY124' THEN QTY END), 0) AS QTY124
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY125' THEN QTY END), 0) AS QTY125
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY126' THEN QTY END), 0) AS QTY126
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY127' THEN QTY END), 0) AS QTY127
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY128' THEN QTY END), 0) AS QTY128
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY129' THEN QTY END), 0) AS QTY129
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY130' THEN QTY END), 0) AS QTY130
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY131' THEN QTY END), 0) AS QTY131
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY132' THEN QTY END), 0) AS QTY132
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY133' THEN QTY END), 0) AS QTY133
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY134' THEN QTY END), 0) AS QTY134
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY135' THEN QTY END), 0) AS QTY135
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY136' THEN QTY END), 0) AS QTY136
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY137' THEN QTY END), 0) AS QTY137
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY138' THEN QTY END), 0) AS QTY138
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY139' THEN QTY END), 0) AS QTY139
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY140' THEN QTY END), 0) AS QTY140
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY141' THEN QTY END), 0) AS QTY141
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY142' THEN QTY END), 0) AS QTY142
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY143' THEN QTY END), 0) AS QTY143
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY144' THEN QTY END), 0) AS QTY144
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY145' THEN QTY END), 0) AS QTY145
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY146' THEN QTY END), 0) AS QTY146
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY147' THEN QTY END), 0) AS QTY147
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY148' THEN QTY END), 0) AS QTY148
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY149' THEN QTY END), 0) AS QTY149
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY150' THEN QTY END), 0) AS QTY150
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY151' THEN QTY END), 0) AS QTY151
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY152' THEN QTY END), 0) AS QTY152
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY153' THEN QTY END), 0) AS QTY153
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY154' THEN QTY END), 0) AS QTY154
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY155' THEN QTY END), 0) AS QTY155
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY156' THEN QTY END), 0) AS QTY156
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY157' THEN QTY END), 0) AS QTY157
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY158' THEN QTY END), 0) AS QTY158
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY159' THEN QTY END), 0) AS QTY159
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY160' THEN QTY END), 0) AS QTY160
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY161' THEN QTY END), 0) AS QTY161
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY162' THEN QTY END), 0) AS QTY162
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY163' THEN QTY END), 0) AS QTY163
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY164' THEN QTY END), 0) AS QTY164
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY165' THEN QTY END), 0) AS QTY165
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY166' THEN QTY END), 0) AS QTY166
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY167' THEN QTY END), 0) AS QTY167
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY168' THEN QTY END), 0) AS QTY168
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY169' THEN QTY END), 0) AS QTY169
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY170' THEN QTY END), 0) AS QTY170
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY171' THEN QTY END), 0) AS QTY171
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY172' THEN QTY END), 0) AS QTY172
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY173' THEN QTY END), 0) AS QTY173
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY174' THEN QTY END), 0) AS QTY174
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY175' THEN QTY END), 0) AS QTY175
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY176' THEN QTY END), 0) AS QTY176
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY177' THEN QTY END), 0) AS QTY177
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY178' THEN QTY END), 0) AS QTY178
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY179' THEN QTY END), 0) AS QTY179
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY180' THEN QTY END), 0) AS QTY180
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY181' THEN QTY END), 0) AS QTY181
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY182' THEN QTY END), 0) AS QTY182
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY183' THEN QTY END), 0) AS QTY183
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY184' THEN QTY END), 0) AS QTY184
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY185' THEN QTY END), 0) AS QTY185
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY186' THEN QTY END), 0) AS QTY186
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY187' THEN QTY END), 0) AS QTY187
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY188' THEN QTY END), 0) AS QTY188
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY189' THEN QTY END), 0) AS QTY189
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY190' THEN QTY END), 0) AS QTY190
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY191' THEN QTY END), 0) AS QTY191
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY192' THEN QTY END), 0) AS QTY192
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY193' THEN QTY END), 0) AS QTY193
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY194' THEN QTY END), 0) AS QTY194
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY195' THEN QTY END), 0) AS QTY195
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY196' THEN QTY END), 0) AS QTY196
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY197' THEN QTY END), 0) AS QTY197
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY198' THEN QTY END), 0) AS QTY198
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY199' THEN QTY END), 0) AS QTY199
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY200' THEN QTY END), 0) AS QTY200
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY201' THEN QTY END), 0) AS QTY201
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY202' THEN QTY END), 0) AS QTY202
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY203' THEN QTY END), 0) AS QTY203
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY204' THEN QTY END), 0) AS QTY204
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY205' THEN QTY END), 0) AS QTY205
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY206' THEN QTY END), 0) AS QTY206
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY207' THEN QTY END), 0) AS QTY207
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY208' THEN QTY END), 0) AS QTY208
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY209' THEN QTY END), 0) AS QTY209
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY210' THEN QTY END), 0) AS QTY210
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY211' THEN QTY END), 0) AS QTY211
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY212' THEN QTY END), 0) AS QTY212
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY213' THEN QTY END), 0) AS QTY213
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY214' THEN QTY END), 0) AS QTY214
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY215' THEN QTY END), 0) AS QTY215
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY216' THEN QTY END), 0) AS QTY216
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY217' THEN QTY END), 0) AS QTY217
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY218' THEN QTY END), 0) AS QTY218
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY219' THEN QTY END), 0) AS QTY219
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY220' THEN QTY END), 0) AS QTY220
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY221' THEN QTY END), 0) AS QTY221
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY222' THEN QTY END), 0) AS QTY222
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY223' THEN QTY END), 0) AS QTY223
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY224' THEN QTY END), 0) AS QTY224
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY225' THEN QTY END), 0) AS QTY225
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY226' THEN QTY END), 0) AS QTY226
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY227' THEN QTY END), 0) AS QTY227
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY228' THEN QTY END), 0) AS QTY228
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY229' THEN QTY END), 0) AS QTY229
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY230' THEN QTY END), 0) AS QTY230
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY231' THEN QTY END), 0) AS QTY231
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY232' THEN QTY END), 0) AS QTY232
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY233' THEN QTY END), 0) AS QTY233
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY234' THEN QTY END), 0) AS QTY234
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY235' THEN QTY END), 0) AS QTY235
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY236' THEN QTY END), 0) AS QTY236
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY237' THEN QTY END), 0) AS QTY237
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY238' THEN QTY END), 0) AS QTY238
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY239' THEN QTY END), 0) AS QTY239
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY240' THEN QTY END), 0) AS QTY240
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY241' THEN QTY END), 0) AS QTY241
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY242' THEN QTY END), 0) AS QTY242
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY243' THEN QTY END), 0) AS QTY243
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY244' THEN QTY END), 0) AS QTY244
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY245' THEN QTY END), 0) AS QTY245
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY246' THEN QTY END), 0) AS QTY246
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY247' THEN QTY END), 0) AS QTY247
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY248' THEN QTY END), 0) AS QTY248
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY249' THEN QTY END), 0) AS QTY249
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY250' THEN QTY END), 0) AS QTY250
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY251' THEN QTY END), 0) AS QTY251
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY252' THEN QTY END), 0) AS QTY252
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY253' THEN QTY END), 0) AS QTY253
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY254' THEN QTY END), 0) AS QTY254
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY255' THEN QTY END), 0) AS QTY255
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY256' THEN QTY END), 0) AS QTY256
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY257' THEN QTY END), 0) AS QTY257
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY258' THEN QTY END), 0) AS QTY258
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY259' THEN QTY END), 0) AS QTY259
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY260' THEN QTY END), 0) AS QTY260
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY261' THEN QTY END), 0) AS QTY261
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY262' THEN QTY END), 0) AS QTY262
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY263' THEN QTY END), 0) AS QTY263
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY264' THEN QTY END), 0) AS QTY264
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY265' THEN QTY END), 0) AS QTY265
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY266' THEN QTY END), 0) AS QTY266
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY267' THEN QTY END), 0) AS QTY267
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY268' THEN QTY END), 0) AS QTY268
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY269' THEN QTY END), 0) AS QTY269
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY270' THEN QTY END), 0) AS QTY270
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY271' THEN QTY END), 0) AS QTY271
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY272' THEN QTY END), 0) AS QTY272
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY273' THEN QTY END), 0) AS QTY273
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY274' THEN QTY END), 0) AS QTY274
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY275' THEN QTY END), 0) AS QTY275
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY276' THEN QTY END), 0) AS QTY276
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY277' THEN QTY END), 0) AS QTY277
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY278' THEN QTY END), 0) AS QTY278
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY279' THEN QTY END), 0) AS QTY279
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY280' THEN QTY END), 0) AS QTY280
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY281' THEN QTY END), 0) AS QTY281
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY282' THEN QTY END), 0) AS QTY282
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY283' THEN QTY END), 0) AS QTY283
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY284' THEN QTY END), 0) AS QTY284
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY285' THEN QTY END), 0) AS QTY285
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY286' THEN QTY END), 0) AS QTY286
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY287' THEN QTY END), 0) AS QTY287
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY288' THEN QTY END), 0) AS QTY288
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY289' THEN QTY END), 0) AS QTY289
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY290' THEN QTY END), 0) AS QTY290
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY291' THEN QTY END), 0) AS QTY291
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY292' THEN QTY END), 0) AS QTY292
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY293' THEN QTY END), 0) AS QTY293
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY294' THEN QTY END), 0) AS QTY294
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY295' THEN QTY END), 0) AS QTY295
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY296' THEN QTY END), 0) AS QTY296
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY297' THEN QTY END), 0) AS QTY297
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY298' THEN QTY END), 0) AS QTY298
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY299' THEN QTY END), 0) AS QTY299
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY300' THEN QTY END), 0) AS QTY300
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY301' THEN QTY END), 0) AS QTY301
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY302' THEN QTY END), 0) AS QTY302
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY303' THEN QTY END), 0) AS QTY303
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY304' THEN QTY END), 0) AS QTY304
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY305' THEN QTY END), 0) AS QTY305
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY306' THEN QTY END), 0) AS QTY306
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY307' THEN QTY END), 0) AS QTY307
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY308' THEN QTY END), 0) AS QTY308
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY309' THEN QTY END), 0) AS QTY309
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY310' THEN QTY END), 0) AS QTY310
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY311' THEN QTY END), 0) AS QTY311
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY312' THEN QTY END), 0) AS QTY312
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY313' THEN QTY END), 0) AS QTY313
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY314' THEN QTY END), 0) AS QTY314
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY315' THEN QTY END), 0) AS QTY315
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY316' THEN QTY END), 0) AS QTY316
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY317' THEN QTY END), 0) AS QTY317
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY318' THEN QTY END), 0) AS QTY318
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY319' THEN QTY END), 0) AS QTY319
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY320' THEN QTY END), 0) AS QTY320
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY321' THEN QTY END), 0) AS QTY321
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY322' THEN QTY END), 0) AS QTY322
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY323' THEN QTY END), 0) AS QTY323
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY324' THEN QTY END), 0) AS QTY324
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY325' THEN QTY END), 0) AS QTY325
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY326' THEN QTY END), 0) AS QTY326
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY327' THEN QTY END), 0) AS QTY327
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY328' THEN QTY END), 0) AS QTY328
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY329' THEN QTY END), 0) AS QTY329
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY330' THEN QTY END), 0) AS QTY330
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY331' THEN QTY END), 0) AS QTY331
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY332' THEN QTY END), 0) AS QTY332
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY333' THEN QTY END), 0) AS QTY333
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY334' THEN QTY END), 0) AS QTY334
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY335' THEN QTY END), 0) AS QTY335
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY336' THEN QTY END), 0) AS QTY336
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY337' THEN QTY END), 0) AS QTY337
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY338' THEN QTY END), 0) AS QTY338
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY339' THEN QTY END), 0) AS QTY339
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY340' THEN QTY END), 0) AS QTY340
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY341' THEN QTY END), 0) AS QTY341
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY342' THEN QTY END), 0) AS QTY342
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY343' THEN QTY END), 0) AS QTY343
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY344' THEN QTY END), 0) AS QTY344
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY345' THEN QTY END), 0) AS QTY345
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY346' THEN QTY END), 0) AS QTY346
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY347' THEN QTY END), 0) AS QTY347
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY348' THEN QTY END), 0) AS QTY348
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY349' THEN QTY END), 0) AS QTY349
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY350' THEN QTY END), 0) AS QTY350
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY351' THEN QTY END), 0) AS QTY351
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY352' THEN QTY END), 0) AS QTY352
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY353' THEN QTY END), 0) AS QTY353
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY354' THEN QTY END), 0) AS QTY354
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY355' THEN QTY END), 0) AS QTY355
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY356' THEN QTY END), 0) AS QTY356
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY357' THEN QTY END), 0) AS QTY357
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY358' THEN QTY END), 0) AS QTY358
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY359' THEN QTY END), 0) AS QTY359
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY360' THEN QTY END), 0) AS QTY360
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY361' THEN QTY END), 0) AS QTY361
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY362' THEN QTY END), 0) AS QTY362
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY363' THEN QTY END), 0) AS QTY363
             , NVL(SUM(CASE WHEN WEEK_COLUMN = 'QTY364' THEN QTY END), 0) AS QTY364
               /* 2021.03.26   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - start */
               /* Measure 중복방지를 위한 처리 */
               /* --, A.ATTRIBUTE1 */
             , '-'                          AS ATTRIBUTE1
               /* 2021.03.26   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - end */
             , NULL                         AS ATTRIBUTE2
             , NULL                         AS ATTRIBUTE3
             , NULL                         AS ATTRIBUTE4
             , NULL                         AS ATTRIBUTE5
             , NULL                         AS ATTRIBUTE6
             , NULL                         AS ATTRIBUTE7
             , NULL                         AS ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
          FROM GT_XSPK_PSI_GLOBAL_SMALL_PACK
         WHERE YYYYMMDD >= V_CREATE_FROM_YYYYMMDD
           AND YYYYMMDD <= V_CREATE_TO_YYYYMMDD
         GROUP BY OPERATION_GROUP
                , CELL_ITEM_ID
                , ITEM_ID
                , TO_SITE
                , PROJECT_CODE
                , FROM_BOH_QTY
                , TO_BOH_QTY
                , CASE WHEN TRIM(INCOTERMS) IS NULL THEN '-' ELSE INCOTERMS END
                , FROM_SITE
                , NVL(TRANSPORT_MODE, '-')
                , NVL(PROD_LINE, '-')
                , BOD_ID
                , MEASURE
                , COLUMN_LABEL_NAME
                , SORT_ORDER_NO
                , ATTRIBUTE9
                , ATTRIBUTE10;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 006 ');

        UPDATE GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK A
           SET A.OPERATION_GROUP_NAME = (SELECT MAX(SA.SEGMENT2)
                                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                          WHERE SA.LOOKUP_TYPE = 'OPERATION_GROUP'
                                            AND SA.SEGMENT1    = A.OPERATION_GROUP)
         WHERE EXISTS (SELECT 1
                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                        WHERE XA.LOOKUP_TYPE = 'OPERATION_GROUP'
                          AND XA.SEGMENT1    = A.OPERATION_GROUP);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 007 ');

        /* LEFT JOIN 갱신 : 짝이 없으면 '-' (품목별 NICK_NAME 은 사이트가 달라도 한 값 — 실측 · 집계 서브쿼리라 짝이 없어도 1행(NULL) → '-') */
        UPDATE GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK A
           SET A.NICK_NAME = (SELECT CASE WHEN TRIM(MAX(SA.NICK_NAME)) IS NULL THEN '-' ELSE MAX(SA.NICK_NAME) END  /* ISNULL(NULLIF( Y.NICK_NAME, '') , '-') */
                                FROM SCM_MST_ITEM_SN SA
                               WHERE SA.ITEM_ID = A.ITEM_ID);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 008 ');

        UPDATE GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK A
           SET A.TO_SITE_DESCRIPTION = (SELECT CASE WHEN TRIM(MAX(SA.SITE_DESCRIPTION)) IS NULL THEN '-' ELSE MAX(SA.SITE_DESCRIPTION) END  /* ISNULL(NULLIF( Y.SITE_DESCRIPTION, '') , '-') */
                                          FROM SCM_MST_SITE SA
                                         WHERE SA.SCM_SITE_ID = A.TO_SITE);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 009 ');

        UPDATE GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK A
           SET A.FROM_SITE_DESCRIPTION = (SELECT CASE WHEN TRIM(MAX(SA.SITE_DESCRIPTION)) IS NULL THEN '-' ELSE MAX(SA.SITE_DESCRIPTION) END  /* ISNULL(NULLIF( Y.SITE_DESCRIPTION, '') , '-') */
                                            FROM SCM_MST_SITE SA  /* 250303, KSK, 키가 없을경우에도 작동하도록 */
                                           WHERE SA.SCM_SITE_ID = A.FROM_SITE);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 010 ');

        /* ---PRINT 'LABEL COMPLETE'; */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* TRANSPORT_MODE, LINE_ID 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #TRANSPORT_MODE : 한 번만 쓰이므로 아래 INSERT 의 인라인 뷰(IA)로 옮김 */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 011 ');

        /* 'SHIP_PLAN'의 TRANSPORT_MODE 종류 별 추가 */
        /* 원본 OUTER APPLY #TRANSPORT_MODE Y WHERE X.col = Y.col → 조건이 WHERE 에 있어 내부조인과 같음 */
        INSERT
          INTO GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
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
             )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             /* --		  	, @p_create_from_yyyymmdd */
             /* --			, @p_create_to_yyyymmdd */
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.OPERATION_GROUP_NAME
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.NICK_NAME
             , A.CELL_QTY_PACK
             , A.TO_SITE
             , A.TO_SITE_DESCRIPTION
             , A.PROJECT_CODE
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.FROM_SITE_DESCRIPTION
             , IA.TRANSPORT_MODE
             , A.PROD_LINE
             , TRUNC(IA.LT_TOTAL)           AS LT_DAY  /* INT 칸 : MSSQL 은 소수점 아래를 버림 */
             , IA.BOD_ID
             , A.MEASURE
             , A.MEASURE_LABEL
             , A.XLS_KEY1
             , A.XLS_KEY2
             , A.XLS_KEY3
             , A.XLS_KEY4
             , A.XLS_KEY5
             , A.XLS_ATTRIBUTE1
             , A.XLS_ATTRIBUTE2
             , A.XLS_ATTRIBUTE3
             , A.XLS_ATTRIBUTE4
             , A.XLS_ATTRIBUTE5
             /* --,CALC_YN */
             /* --,DISPLAY_YN */
             , A.SORT_ORDER_NO
             , 0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
             , 0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
             , 0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
             , 0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
             , 0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
             , 0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
             , 0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
             , 0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
             , 0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
             , 0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
             , 0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
             , 0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
             , 0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
             , 0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
             , 0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
             , 0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
             , 0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
             , 0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
             , 0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
             , 0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
             , 0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
             , 0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
             , 0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
             , 0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
             , 0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
             , 0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
             , 0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
             , 0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
             , 0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
             , 0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
             , 0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
             , 0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
             , 0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
             , 0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
             , 0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
             , 0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
             , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
             /* --,X.CREATED_BY */
             /* --,X.CREATION_DATE */
             /* --,X.LAST_UPDATED_BY */
             /* --,X.LAST_UPDATE_DATE */
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
          FROM GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK A
             , ( SELECT DISTINCT
                        B.DIVISION_ID
                      , B.FROM_SITE
                      , B.TO_SITE
                      , B.INCOTERMS
                      , B.TRANSPORT_MODE
                      , B.LT_TOTAL
                      , B.BOD_ID
                      , C.PROJECT_CODE
                   FROM GT_XSPK_BOD_V B
                      , GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK C
                  WHERE B.DIVISION_ID     = C.DIVISION_ID(+)
                    AND B.FROM_SITE       = C.FROM_SITE(+)
                    AND B.TO_SITE         = C.TO_SITE(+)
                    AND B.INCOTERMS       = C.INCOTERMS(+)
                    AND B.BOD_ID          = C.BOD_ID(+)  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
                    AND C.PROJECT_CODE(+) <> '-'
                    AND C.PROJECT_CODE    IS NOT NULL    /* ISNULL(Y.PROJECT_CODE ,'') <> '' */
               ) IA
         WHERE A.DIVISION_ID      = IA.DIVISION_ID
           AND A.FROM_SITE        = IA.FROM_SITE
           AND A.TO_SITE          = IA.TO_SITE
           AND A.INCOTERMS        = IA.INCOTERMS
           AND A.TRANSPORT_MODE  <> IA.TRANSPORT_MODE
           AND NOT EXISTS (SELECT 1
                             FROM GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK XA
                            WHERE XA.MEASURE     = 'PACK_SHIP_PLAN'
                              AND XA.DIVISION_ID = A.DIVISION_ID
                              AND XA.FROM_SITE   = A.FROM_SITE
                              AND XA.ITEM_ID     = A.ITEM_ID
                              AND XA.INCOTERMS   = A.INCOTERMS)
           AND A.MEASURE          = 'PACK_SHIP_PLAN';
        /* --PRINT '4444444444444444444444444444'; */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 012 ');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 보정 */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK
           SET LT_DAY = 0
         WHERE TRANSPORT_MODE = '-';

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 013 ');

        DELETE
          FROM GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK
         WHERE OPERATION_GROUP = 'A'
           AND TO_SITE         NOT LIKE '%-P'
           AND MEASURE         NOT IN ('CELL_REQ', 'CELL_BALANCE', 'CELL_WHIN');

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 014 ');

        /* ------------------------------------------------------------------------------------------------------------- start */
        /* 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: W-1 주차 PR 플랜에 대한 생산/출하 measure 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 매핑되지 않는 case 제거 */
        UPDATE GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK
           SET PROJECT_CODE = '-'
         WHERE MEASURE = 'PACK_PROD';

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 015 ');

        /* W-1 주차 추가 */
        INSERT
          INTO GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             /* --,CHILD_ITEM_ID */
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             /* --,END_CUSTOMER */
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , SORT_ORDER_NO
             /* --,CREATED_BY */
             /* --,CREATION_DATE */
             /* --,LAST_UPDATED_BY */
             /* --,LAST_UPDATE_DATE */
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
             /* --,YIELD */
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             /* --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25 */
             /* --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50 */
             /* --,WQTY51,WQTY52 */
             )
        /* W-1 주차 PR 플랜 */
        SELECT IA.DIVISION_ID
             , IA.PLAN_START_YYYYMMDD
             , IA.PLAN_TYPE
             , IA.SEQ
             , IA.OPERATION_GROUP
             , IA.OPERATION_GROUP_NAME
             , IA.CELL_ITEM_ID
             , IA.ITEM_ID
             , IA.NICK_NAME
             /* --,X.CHILD_ITEM_ID */
             , IA.CELL_QTY_PACK
             , IA.TO_SITE
             , IA.TO_SITE_DESCRIPTION
             , IA.PROJECT_CODE
             , 0                            AS FROM_BOH_QTY
             , 0                            AS TO_BOH_QTY
             , IA.INCOTERMS
             , IA.FROM_SITE
             , IA.FROM_SITE_DESCRIPTION
             , IA.TRANSPORT_MODE
             , IA.PROD_LINE
             /* --,X.END_CUSTOMER */
             , IA.LT_DAY
             , IA.BOD_ID
             , 'PREV_'  || IA.MEASURE       AS MEASURE
             , 'Prev. ' || IA.MEASURE_LABEL AS MEASURE_LABEL
             , NULL                         AS XLS_KEY1
             , CASE WHEN IA.MEASURE = 'PACK_SHIP_PLAN' THEN 245 ELSE 246 END AS SORT_ORDER_NO
             /* --,X.CREATED_BY */
             /* --,X.CREATION_DATE */
             /* --,X.LAST_UPDATED_BY */
             /* --,X.LAST_UPDATE_DATE */
             , IB.ATTRIBUTE1
             , IB.ATTRIBUTE2
             , IB.ATTRIBUTE3
             , IB.ATTRIBUTE4
             , IB.ATTRIBUTE5
             , IB.ATTRIBUTE6
             , IB.ATTRIBUTE7
             , IB.ATTRIBUTE8
             , IB.ATTRIBUTE9
             , IB.ATTRIBUTE10
             /* --,Y.YIELD */
             , NVL(IB.QTY008, 0) AS QTY001, NVL(IB.QTY009, 0) AS QTY002, NVL(IB.QTY010, 0) AS QTY003, NVL(IB.QTY011, 0) AS QTY004, NVL(IB.QTY012, 0) AS QTY005
             , NVL(IB.QTY013, 0) AS QTY006, NVL(IB.QTY014, 0) AS QTY007, NVL(IB.QTY015, 0) AS QTY008, NVL(IB.QTY016, 0) AS QTY009, NVL(IB.QTY017, 0) AS QTY010
             , NVL(IB.QTY018, 0) AS QTY011, NVL(IB.QTY019, 0) AS QTY012, NVL(IB.QTY020, 0) AS QTY013, NVL(IB.QTY021, 0) AS QTY014, NVL(IB.QTY022, 0) AS QTY015
             , NVL(IB.QTY023, 0) AS QTY016, NVL(IB.QTY024, 0) AS QTY017, NVL(IB.QTY025, 0) AS QTY018, NVL(IB.QTY026, 0) AS QTY019, NVL(IB.QTY027, 0) AS QTY020
             , NVL(IB.QTY028, 0) AS QTY021, NVL(IB.QTY029, 0) AS QTY022, NVL(IB.QTY030, 0) AS QTY023, NVL(IB.QTY031, 0) AS QTY024, NVL(IB.QTY032, 0) AS QTY025
             , NVL(IB.QTY033, 0) AS QTY026, NVL(IB.QTY034, 0) AS QTY027, NVL(IB.QTY035, 0) AS QTY028, NVL(IB.QTY036, 0) AS QTY029, NVL(IB.QTY037, 0) AS QTY030
             , NVL(IB.QTY038, 0) AS QTY031, NVL(IB.QTY039, 0) AS QTY032, NVL(IB.QTY040, 0) AS QTY033, NVL(IB.QTY041, 0) AS QTY034, NVL(IB.QTY042, 0) AS QTY035
             , NVL(IB.QTY043, 0) AS QTY036, NVL(IB.QTY044, 0) AS QTY037, NVL(IB.QTY045, 0) AS QTY038, NVL(IB.QTY046, 0) AS QTY039, NVL(IB.QTY047, 0) AS QTY040
             , NVL(IB.QTY048, 0) AS QTY041, NVL(IB.QTY049, 0) AS QTY042, NVL(IB.QTY050, 0) AS QTY043, NVL(IB.QTY051, 0) AS QTY044, NVL(IB.QTY052, 0) AS QTY045
             , NVL(IB.QTY053, 0) AS QTY046, NVL(IB.QTY054, 0) AS QTY047, NVL(IB.QTY055, 0) AS QTY048, NVL(IB.QTY056, 0) AS QTY049, NVL(IB.QTY057, 0) AS QTY050
             , NVL(IB.QTY058, 0) AS QTY051, NVL(IB.QTY059, 0) AS QTY052, NVL(IB.QTY060, 0) AS QTY053, NVL(IB.QTY061, 0) AS QTY054, NVL(IB.QTY062, 0) AS QTY055
             , NVL(IB.QTY063, 0) AS QTY056, NVL(IB.QTY064, 0) AS QTY057, NVL(IB.QTY065, 0) AS QTY058, NVL(IB.QTY066, 0) AS QTY059, NVL(IB.QTY067, 0) AS QTY060
             , NVL(IB.QTY068, 0) AS QTY061, NVL(IB.QTY069, 0) AS QTY062, NVL(IB.QTY070, 0) AS QTY063, NVL(IB.QTY071, 0) AS QTY064, NVL(IB.QTY072, 0) AS QTY065
             , NVL(IB.QTY073, 0) AS QTY066, NVL(IB.QTY074, 0) AS QTY067, NVL(IB.QTY075, 0) AS QTY068, NVL(IB.QTY076, 0) AS QTY069, NVL(IB.QTY077, 0) AS QTY070
             , NVL(IB.QTY078, 0) AS QTY071, NVL(IB.QTY079, 0) AS QTY072, NVL(IB.QTY080, 0) AS QTY073, NVL(IB.QTY081, 0) AS QTY074, NVL(IB.QTY082, 0) AS QTY075
             , NVL(IB.QTY083, 0) AS QTY076, NVL(IB.QTY084, 0) AS QTY077, NVL(IB.QTY085, 0) AS QTY078, NVL(IB.QTY086, 0) AS QTY079, NVL(IB.QTY087, 0) AS QTY080
             , NVL(IB.QTY088, 0) AS QTY081, NVL(IB.QTY089, 0) AS QTY082, NVL(IB.QTY090, 0) AS QTY083, NVL(IB.QTY091, 0) AS QTY084, NVL(IB.QTY092, 0) AS QTY085
             , NVL(IB.QTY093, 0) AS QTY086, NVL(IB.QTY094, 0) AS QTY087, NVL(IB.QTY095, 0) AS QTY088, NVL(IB.QTY096, 0) AS QTY089, NVL(IB.QTY097, 0) AS QTY090
             , NVL(IB.QTY098, 0) AS QTY091, NVL(IB.QTY099, 0) AS QTY092, NVL(IB.QTY100, 0) AS QTY093, NVL(IB.QTY101, 0) AS QTY094, NVL(IB.QTY102, 0) AS QTY095
             , NVL(IB.QTY103, 0) AS QTY096, NVL(IB.QTY104, 0) AS QTY097, NVL(IB.QTY105, 0) AS QTY098, NVL(IB.QTY106, 0) AS QTY099, NVL(IB.QTY107, 0) AS QTY100
             , NVL(IB.QTY108, 0) AS QTY101, NVL(IB.QTY109, 0) AS QTY102, NVL(IB.QTY110, 0) AS QTY103, NVL(IB.QTY111, 0) AS QTY104, NVL(IB.QTY112, 0) AS QTY105
             , NVL(IB.QTY113, 0) AS QTY106, NVL(IB.QTY114, 0) AS QTY107, NVL(IB.QTY115, 0) AS QTY108, NVL(IB.QTY116, 0) AS QTY109, NVL(IB.QTY117, 0) AS QTY110
             , NVL(IB.QTY118, 0) AS QTY111, NVL(IB.QTY119, 0) AS QTY112, NVL(IB.QTY120, 0) AS QTY113, NVL(IB.QTY121, 0) AS QTY114, NVL(IB.QTY122, 0) AS QTY115
             , NVL(IB.QTY123, 0) AS QTY116, NVL(IB.QTY124, 0) AS QTY117, NVL(IB.QTY125, 0) AS QTY118, NVL(IB.QTY126, 0) AS QTY119, NVL(IB.QTY127, 0) AS QTY120
             , NVL(IB.QTY128, 0) AS QTY121, NVL(IB.QTY129, 0) AS QTY122, NVL(IB.QTY130, 0) AS QTY123, NVL(IB.QTY131, 0) AS QTY124, NVL(IB.QTY132, 0) AS QTY125
             , NVL(IB.QTY133, 0) AS QTY126, NVL(IB.QTY134, 0) AS QTY127, NVL(IB.QTY135, 0) AS QTY128, NVL(IB.QTY136, 0) AS QTY129, NVL(IB.QTY137, 0) AS QTY130
             , NVL(IB.QTY138, 0) AS QTY131, NVL(IB.QTY139, 0) AS QTY132, NVL(IB.QTY140, 0) AS QTY133, NVL(IB.QTY141, 0) AS QTY134, NVL(IB.QTY142, 0) AS QTY135
             , NVL(IB.QTY143, 0) AS QTY136, NVL(IB.QTY144, 0) AS QTY137, NVL(IB.QTY145, 0) AS QTY138, NVL(IB.QTY146, 0) AS QTY139, NVL(IB.QTY147, 0) AS QTY140
             , NVL(IB.QTY148, 0) AS QTY141, NVL(IB.QTY149, 0) AS QTY142, NVL(IB.QTY150, 0) AS QTY143, NVL(IB.QTY151, 0) AS QTY144, NVL(IB.QTY152, 0) AS QTY145
             , NVL(IB.QTY153, 0) AS QTY146, NVL(IB.QTY154, 0) AS QTY147, NVL(IB.QTY155, 0) AS QTY148, NVL(IB.QTY156, 0) AS QTY149, NVL(IB.QTY157, 0) AS QTY150
             , NVL(IB.QTY158, 0) AS QTY151, NVL(IB.QTY159, 0) AS QTY152, NVL(IB.QTY160, 0) AS QTY153, NVL(IB.QTY161, 0) AS QTY154, NVL(IB.QTY162, 0) AS QTY155
             , NVL(IB.QTY163, 0) AS QTY156, NVL(IB.QTY164, 0) AS QTY157, NVL(IB.QTY165, 0) AS QTY158, NVL(IB.QTY166, 0) AS QTY159, NVL(IB.QTY167, 0) AS QTY160
             , NVL(IB.QTY168, 0) AS QTY161, NVL(IB.QTY169, 0) AS QTY162, NVL(IB.QTY170, 0) AS QTY163, NVL(IB.QTY171, 0) AS QTY164, NVL(IB.QTY172, 0) AS QTY165
             , NVL(IB.QTY173, 0) AS QTY166, NVL(IB.QTY174, 0) AS QTY167, NVL(IB.QTY175, 0) AS QTY168, NVL(IB.QTY176, 0) AS QTY169, NVL(IB.QTY177, 0) AS QTY170
             , NVL(IB.QTY178, 0) AS QTY171, NVL(IB.QTY179, 0) AS QTY172, NVL(IB.QTY180, 0) AS QTY173, NVL(IB.QTY181, 0) AS QTY174, NVL(IB.QTY182, 0) AS QTY175
             , NVL(IB.QTY183, 0) AS QTY176, NVL(IB.QTY184, 0) AS QTY177, NVL(IB.QTY185, 0) AS QTY178, NVL(IB.QTY186, 0) AS QTY179, NVL(IB.QTY187, 0) AS QTY180
             , NVL(IB.QTY188, 0) AS QTY181, NVL(IB.QTY189, 0) AS QTY182, NVL(IB.QTY190, 0) AS QTY183, NVL(IB.QTY191, 0) AS QTY184, NVL(IB.QTY192, 0) AS QTY185
             , NVL(IB.QTY193, 0) AS QTY186, NVL(IB.QTY194, 0) AS QTY187, NVL(IB.QTY195, 0) AS QTY188, NVL(IB.QTY196, 0) AS QTY189, NVL(IB.QTY197, 0) AS QTY190
             , NVL(IB.QTY198, 0) AS QTY191, NVL(IB.QTY199, 0) AS QTY192, NVL(IB.QTY200, 0) AS QTY193, NVL(IB.QTY201, 0) AS QTY194, NVL(IB.QTY202, 0) AS QTY195
             , NVL(IB.QTY203, 0) AS QTY196, NVL(IB.QTY204, 0) AS QTY197, NVL(IB.QTY205, 0) AS QTY198, NVL(IB.QTY206, 0) AS QTY199, NVL(IB.QTY207, 0) AS QTY200
             , NVL(IB.QTY208, 0) AS QTY201, NVL(IB.QTY209, 0) AS QTY202, NVL(IB.QTY210, 0) AS QTY203, NVL(IB.QTY211, 0) AS QTY204, NVL(IB.QTY212, 0) AS QTY205
             , NVL(IB.QTY213, 0) AS QTY206, NVL(IB.QTY214, 0) AS QTY207, NVL(IB.QTY215, 0) AS QTY208, NVL(IB.QTY216, 0) AS QTY209, NVL(IB.QTY217, 0) AS QTY210
             , NVL(IB.QTY218, 0) AS QTY211, NVL(IB.QTY219, 0) AS QTY212, NVL(IB.QTY220, 0) AS QTY213, NVL(IB.QTY221, 0) AS QTY214, NVL(IB.QTY222, 0) AS QTY215
             , NVL(IB.QTY223, 0) AS QTY216, NVL(IB.QTY224, 0) AS QTY217, NVL(IB.QTY225, 0) AS QTY218, NVL(IB.QTY226, 0) AS QTY219, NVL(IB.QTY227, 0) AS QTY220
             , NVL(IB.QTY228, 0) AS QTY221, NVL(IB.QTY229, 0) AS QTY222, NVL(IB.QTY230, 0) AS QTY223, NVL(IB.QTY231, 0) AS QTY224, NVL(IB.QTY232, 0) AS QTY225
             , NVL(IB.QTY233, 0) AS QTY226, NVL(IB.QTY234, 0) AS QTY227, NVL(IB.QTY235, 0) AS QTY228, NVL(IB.QTY236, 0) AS QTY229, NVL(IB.QTY237, 0) AS QTY230
             , NVL(IB.QTY238, 0) AS QTY231, NVL(IB.QTY239, 0) AS QTY232, NVL(IB.QTY240, 0) AS QTY233, NVL(IB.QTY241, 0) AS QTY234, NVL(IB.QTY242, 0) AS QTY235
             , NVL(IB.QTY243, 0) AS QTY236, NVL(IB.QTY244, 0) AS QTY237, NVL(IB.QTY245, 0) AS QTY238, NVL(IB.QTY246, 0) AS QTY239, NVL(IB.QTY247, 0) AS QTY240
             , NVL(IB.QTY248, 0) AS QTY241, NVL(IB.QTY249, 0) AS QTY242, NVL(IB.QTY250, 0) AS QTY243, NVL(IB.QTY251, 0) AS QTY244, NVL(IB.QTY252, 0) AS QTY245
             , NVL(IB.QTY253, 0) AS QTY246, NVL(IB.QTY254, 0) AS QTY247, NVL(IB.QTY255, 0) AS QTY248, NVL(IB.QTY256, 0) AS QTY249, NVL(IB.QTY257, 0) AS QTY250
             , NVL(IB.QTY258, 0) AS QTY251, NVL(IB.QTY259, 0) AS QTY252, NVL(IB.QTY260, 0) AS QTY253, NVL(IB.QTY261, 0) AS QTY254, NVL(IB.QTY262, 0) AS QTY255
             , NVL(IB.QTY263, 0) AS QTY256, NVL(IB.QTY264, 0) AS QTY257, NVL(IB.QTY265, 0) AS QTY258, NVL(IB.QTY266, 0) AS QTY259, NVL(IB.QTY267, 0) AS QTY260
             , NVL(IB.QTY268, 0) AS QTY261, NVL(IB.QTY269, 0) AS QTY262, NVL(IB.QTY270, 0) AS QTY263, NVL(IB.QTY271, 0) AS QTY264, NVL(IB.QTY272, 0) AS QTY265
             , NVL(IB.QTY273, 0) AS QTY266, NVL(IB.QTY274, 0) AS QTY267, NVL(IB.QTY275, 0) AS QTY268, NVL(IB.QTY276, 0) AS QTY269, NVL(IB.QTY277, 0) AS QTY270
             , NVL(IB.QTY278, 0) AS QTY271, NVL(IB.QTY279, 0) AS QTY272, NVL(IB.QTY280, 0) AS QTY273, NVL(IB.QTY281, 0) AS QTY274, NVL(IB.QTY282, 0) AS QTY275
             , NVL(IB.QTY283, 0) AS QTY276, NVL(IB.QTY284, 0) AS QTY277, NVL(IB.QTY285, 0) AS QTY278, NVL(IB.QTY286, 0) AS QTY279, NVL(IB.QTY287, 0) AS QTY280
             , NVL(IB.QTY288, 0) AS QTY281, NVL(IB.QTY289, 0) AS QTY282, NVL(IB.QTY290, 0) AS QTY283, NVL(IB.QTY291, 0) AS QTY284, NVL(IB.QTY292, 0) AS QTY285
             , NVL(IB.QTY293, 0) AS QTY286, NVL(IB.QTY294, 0) AS QTY287, NVL(IB.QTY295, 0) AS QTY288, NVL(IB.QTY296, 0) AS QTY289, NVL(IB.QTY297, 0) AS QTY290
             , NVL(IB.QTY298, 0) AS QTY291, NVL(IB.QTY299, 0) AS QTY292, NVL(IB.QTY300, 0) AS QTY293, NVL(IB.QTY301, 0) AS QTY294, NVL(IB.QTY302, 0) AS QTY295
             , NVL(IB.QTY303, 0) AS QTY296, NVL(IB.QTY304, 0) AS QTY297, NVL(IB.QTY305, 0) AS QTY298, NVL(IB.QTY306, 0) AS QTY299, NVL(IB.QTY307, 0) AS QTY300
             , NVL(IB.QTY308, 0) AS QTY301, NVL(IB.QTY309, 0) AS QTY302, NVL(IB.QTY310, 0) AS QTY303, NVL(IB.QTY311, 0) AS QTY304, NVL(IB.QTY312, 0) AS QTY305
             , NVL(IB.QTY313, 0) AS QTY306, NVL(IB.QTY314, 0) AS QTY307, NVL(IB.QTY315, 0) AS QTY308, NVL(IB.QTY316, 0) AS QTY309, NVL(IB.QTY317, 0) AS QTY310
             , NVL(IB.QTY318, 0) AS QTY311, NVL(IB.QTY319, 0) AS QTY312, NVL(IB.QTY320, 0) AS QTY313, NVL(IB.QTY321, 0) AS QTY314, NVL(IB.QTY322, 0) AS QTY315
             , NVL(IB.QTY323, 0) AS QTY316, NVL(IB.QTY324, 0) AS QTY317, NVL(IB.QTY325, 0) AS QTY318, NVL(IB.QTY326, 0) AS QTY319, NVL(IB.QTY327, 0) AS QTY320
             , NVL(IB.QTY328, 0) AS QTY321, NVL(IB.QTY329, 0) AS QTY322, NVL(IB.QTY330, 0) AS QTY323, NVL(IB.QTY331, 0) AS QTY324, NVL(IB.QTY332, 0) AS QTY325
             , NVL(IB.QTY333, 0) AS QTY326, NVL(IB.QTY334, 0) AS QTY327, NVL(IB.QTY335, 0) AS QTY328, NVL(IB.QTY336, 0) AS QTY329, NVL(IB.QTY337, 0) AS QTY330
             , NVL(IB.QTY338, 0) AS QTY331, NVL(IB.QTY339, 0) AS QTY332, NVL(IB.QTY340, 0) AS QTY333, NVL(IB.QTY341, 0) AS QTY334, NVL(IB.QTY342, 0) AS QTY335
             , NVL(IB.QTY343, 0) AS QTY336, NVL(IB.QTY344, 0) AS QTY337, NVL(IB.QTY345, 0) AS QTY338, NVL(IB.QTY346, 0) AS QTY339, NVL(IB.QTY347, 0) AS QTY340
             , NVL(IB.QTY348, 0) AS QTY341, NVL(IB.QTY349, 0) AS QTY342, NVL(IB.QTY350, 0) AS QTY343, NVL(IB.QTY351, 0) AS QTY344, NVL(IB.QTY352, 0) AS QTY345
             , NVL(IB.QTY353, 0) AS QTY346, NVL(IB.QTY354, 0) AS QTY347, NVL(IB.QTY355, 0) AS QTY348, NVL(IB.QTY356, 0) AS QTY349, NVL(IB.QTY357, 0) AS QTY350
             , NVL(IB.QTY358, 0) AS QTY351, NVL(IB.QTY359, 0) AS QTY352, NVL(IB.QTY360, 0) AS QTY353, NVL(IB.QTY361, 0) AS QTY354, NVL(IB.QTY362, 0) AS QTY355
             , NVL(IB.QTY363, 0) AS QTY356, NVL(IB.QTY364, 0) AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
             , 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364
             /* --,ISNULL(Y.WQTY01, 0) AS WQTY01, ISNULL(Y.WQTY02, 0) AS WQTY02, ISNULL(Y.WQTY03, 0) AS WQTY03, ISNULL(Y.WQTY04, 0) AS WQTY04, ISNULL(Y.WQTY05, 0) AS WQTY05, ISNULL(Y.WQTY06, 0) AS WQTY06, ISNULL(Y.WQTY07, 0) AS WQTY07, ISNULL(Y.WQTY08, 0) AS WQTY08, ISNULL(Y.WQTY09, 0) AS WQTY09, ISNULL(Y.WQTY10, 0) AS WQTY10 */
             /* --,ISNULL(Y.WQTY11, 0) AS WQTY11, ISNULL(Y.WQTY12, 0) AS WQTY12, ISNULL(Y.WQTY13, 0) AS WQTY13, ISNULL(Y.WQTY14, 0) AS WQTY14, ISNULL(Y.WQTY15, 0) AS WQTY15, ISNULL(Y.WQTY16, 0) AS WQTY16, ISNULL(Y.WQTY17, 0) AS WQTY17, ISNULL(Y.WQTY18, 0) AS WQTY18, ISNULL(Y.WQTY19, 0) AS WQTY19, ISNULL(Y.WQTY20, 0) AS WQTY20 */
             /* --,ISNULL(Y.WQTY21, 0) AS WQTY21, ISNULL(Y.WQTY22, 0) AS WQTY22, ISNULL(Y.WQTY23, 0) AS WQTY23, ISNULL(Y.WQTY24, 0) AS WQTY24, ISNULL(Y.WQTY25, 0) AS WQTY25, ISNULL(Y.WQTY26, 0) AS WQTY26, ISNULL(Y.WQTY27, 0) AS WQTY27, ISNULL(Y.WQTY28, 0) AS WQTY28, ISNULL(Y.WQTY29, 0) AS WQTY29, ISNULL(Y.WQTY30, 0) AS WQTY30 */
             /* --,ISNULL(Y.WQTY31, 0) AS WQTY31, ISNULL(Y.WQTY32, 0) AS WQTY32, ISNULL(Y.WQTY33, 0) AS WQTY33, ISNULL(Y.WQTY34, 0) AS WQTY34, ISNULL(Y.WQTY35, 0) AS WQTY35, ISNULL(Y.WQTY36, 0) AS WQTY36, ISNULL(Y.WQTY37, 0) AS WQTY37, ISNULL(Y.WQTY38, 0) AS WQTY38, ISNULL(Y.WQTY39, 0) AS WQTY39, ISNULL(Y.WQTY40, 0) AS WQTY40 */
             /* --,ISNULL(Y.WQTY41, 0) AS WQTY41, ISNULL(Y.WQTY42, 0) AS WQTY42, ISNULL(Y.WQTY43, 0) AS WQTY43, ISNULL(Y.WQTY44, 0) AS WQTY44, ISNULL(Y.WQTY45, 0) AS WQTY45, ISNULL(Y.WQTY46, 0) AS WQTY46, ISNULL(Y.WQTY47, 0) AS WQTY47, ISNULL(Y.WQTY48, 0) AS WQTY48, ISNULL(Y.WQTY49, 0) AS WQTY49, ISNULL(Y.WQTY50, 0) AS WQTY50 */
             /* --,ISNULL(Y.WQTY51, 0) AS WQTY51, ISNULL(Y.WQTY52, 0) AS WQTY52 */
          FROM ( SELECT DISTINCT *
                   FROM GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK  /* 당주플랜 */
                  /* -- WHERE DIVISION_ID         = @p_division_id */
                  /* --   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd */
                  /* --AND PLAN_TYPE           = @p_plan_type */
                  /* --AND SEQ                 = @p_seq */
                  WHERE MEASURE IN ('PACK_PROD', 'PACK_SHIP_PLAN')
               ) IA
             , ( SELECT *
                   FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  /* W-1 PR 플랜 */
                  WHERE PLAN_TYPE            = 'PR'
                    AND MEASURE              IN ('PACK_PROD', 'PACK_SHIP_PLAN')
                    AND DIVISION_ID          = V_DIVISION_ID
                    AND PLAN_START_YYYYMMDD  = V_PREV_PLAN_START_YYYYMMDD
                    AND CREATE_FROM_YYYYMMDD = V_PREV_CREATE_FROM_YYYYMMDD  /* --DHJ */
                    /* --AND SEQ                 = @p_seq */
               ) IB
         WHERE IA.DIVISION_ID  = IB.DIVISION_ID(+)
           AND IA.ITEM_ID      = IB.ITEM_ID(+)
           AND IA.CELL_ITEM_ID = IB.CELL_ITEM_ID(+)
           AND IA.FROM_SITE    = IB.FROM_SITE(+)
           AND IA.TO_SITE      = IB.TO_SITE(+)
           AND IA.PROD_LINE    = IB.PROD_LINE(+)
           AND IA.INCOTERMS    = IB.INCOTERMS(+)
           AND IA.BOD_ID       = IB.BOD_ID(+)
           AND IA.PROJECT_CODE = IB.PROJECT_CODE(+)
           AND IA.MEASURE      = IB.MEASURE(+);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 016 ');

        /* ------------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------- */
        /*			  PRINT '6666666666666666666';
          IF OBJECT_ID('tempdb..##PSI_GLOBAL_SMALL_PACK_CHARMM') IS NOT NULL
                      DROP TABLE ##PSI_GLOBAL_SMALL_PACK_CHARMM;

                    SELECT *
                    --INTO ##PSI_GLOBAL_SMALL_PACK_CHARMM
                    FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK
                    ;

                    return -1;
        --PREV_
        */
        /* ---------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------ */

        /* W-1 주차 불필요 data 삭제 */
        DELETE
          FROM GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK
         WHERE (CASE WHEN MEASURE = 'PREV_PACK_SHIP_PLAN' THEN ATTRIBUTE3 ELSE 'A' END) IS NULL;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 017 ');

        /* ------------------------------------------------------------------------------------------------------------- end */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 삭제 후 입력 */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
         WHERE DIVISION_ID          = V_DIVISION_ID  /* -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */
           AND PLAN_START_YYYYMMDD  = V_PREV2_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 지지난주차 플랜 PSI 삭제 */
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 018 ');

        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
         WHERE DIVISION_ID          = V_DIVISION_ID  /* -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */
           AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 당주차 당플랜 PSI 삭제 */
           AND PLAN_TYPE            = P_PLAN_TYPE
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 019 ');

        /* --,CREATE_FROM_YYYYMMDD,CREATE_TO_YYYYMMDD */
        /* --, @p_create_from_yyyymmdd  NVARCHAR(0008) */
        /* --, @p_create_to_yyyymmdd   NVARCHAR(0008) */

        /* XLS_KEY1 정렬 : MSSQL 정렬규칙(대소문자·하이픈 무시, NULL 은 오름차순 맨 앞)을 FN_ASIS_SORT_KEY + NULLS FIRST/LAST 로 재현 */
        INSERT
          INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             /* --,CALC_YN */
             /* --,DISPLAY_YN */
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             /* --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25 */
             /* --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50 */
             /* --,WQTY51,WQTY52 */
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
             , CREATE_FROM_YYYYMMDD
             , CREATE_TO_YYYYMMDD
             )
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
               /* 원본 CASE WHEN LEN(PROJECT_CODE) = 0 THEN '-' : 빈 문자('')는 Oracle 에서 NULL 이므로 NULL·공백 → '-' (이 칸은 원본에서 NULL 이 생기지 않음) */
             , CASE WHEN LENGTH(RTRIM(PROJECT_CODE)) IS NULL THEN '-' ELSE PROJECT_CODE END AS PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , ROW_NUMBER() OVER(ORDER BY DIVISION_ID NULLS FIRST
                                        , FN_ASIS_SORT_KEY(CELL_ITEM_ID) NULLS FIRST
                                        , OPERATION_GROUP DESC NULLS LAST
                                        , FN_ASIS_SORT_KEY(ITEM_ID) NULLS FIRST
                                        , FN_ASIS_SORT_KEY(CASE WHEN OPERATION_GROUP = 'A' THEN TO_SITE ELSE NULL END) NULLS FIRST
                                        , FN_ASIS_SORT_KEY(CASE WHEN (FROM_SITE = '-' AND MEASURE LIKE 'CELL%') THEN '-' ELSE FROM_SITE END) NULLS FIRST
                                        , FN_ASIS_SORT_KEY(TO_SITE) DESC NULLS LAST
                                        , FN_ASIS_SORT_KEY(PROJECT_CODE) NULLS FIRST
                                        /* --                                                ,ATTRIBUTE10 */
                                        , FN_ASIS_SORT_KEY(CASE WHEN (MEASURE LIKE 'CELL%') THEN NULL ELSE ATTRIBUTE10 END) NULLS FIRST
                                        /* --                                                ,(CASE WHEN (PROD_LINE = '-'  AND MEASURE LIKE 'PACK_CELL%' ) THEN 'ZZZ' ELSE PROD_LINE END) */
                                        , FN_ASIS_SORT_KEY(INCOTERMS) NULLS FIRST
                                        , SORT_ORDER_NO NULLS FIRST
                                        , FN_ASIS_SORT_KEY(TRANSPORT_MODE) NULLS FIRST
                                        , FN_ASIS_SORT_KEY(MEASURE_LABEL) DESC NULLS LAST) AS XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             /* --,'N' AS CALC_YN -- 사용안함 */
             /* --,'N' AS DISPLAY_YN -- 사용안함 */
             , SORT_ORDER_NO
             , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
             , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
             , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
             , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
             , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
             , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
             , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
             , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
             , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
             , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
             , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
             , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
             , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
             , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
             , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
             , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
             , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
             , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
             , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
             , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
             , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
             , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
             , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
             , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
             , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
             , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
             , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
             , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
             , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
             , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
             , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
             , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
             , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
             , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
             , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
             , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
             , QTY361, QTY362, QTY363, QTY364
             /* --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25 */
             /* --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50 */
             /* --,WQTY51,WQTY52 */
             , V_USER_ID                    AS CREATED_BY
             , SYSDATE                      AS CREATION_DATE
             , V_USER_ID                    AS LAST_UPDATED_BY
             , SYSDATE                      AS LAST_UPDATE_DATE
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
             , V_CREATE_FROM_YYYYMMDD       AS CREATE_FROM_YYYYMMDD
             , V_CREATE_TO_YYYYMMDD         AS CREATE_TO_YYYYMMDD
          FROM GT_XSPK_SCP_XLS_PSI_GLOBAL_SMALL_PACK;
        /*
        print 'aaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa';
        print @p_create_from_yyyymmdd;
        print @p_create_to_yyyymmdd;
        */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 020 ');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* CHILD_ITEM_ID UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* --                  SELECT X.CHILD_ITEM_ID , Y.CHILD_ITEM_ID, OPERATION_GROUP */
        /* -- 2025.09.02	kimcd	속도 개선 HASH 추가 (INNER HASH JOIN 조인 힌트는 Oracle 문법에 없어 뺌) */
        /* 원본 UPDATE .. FROM JOIN : 한 모델에 CHILD_ITEM_ID 가 여러 개면 MSSQL 은 임의 1건 → MAX 로 고정 */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK A
           SET A.CHILD_ITEM_ID = (SELECT MAX(SA.CHILD_ITEM_ID)
                                    FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V SA
                                   WHERE SA.MODEL_ID                 = A.ITEM_ID
                                     AND SA.OPERATION_GROUP_ID       = 'A'
                                     AND SUBSTR(SA.CHILD_ITEM_ID, 1, 1) = 'M'  /* -- KSW 2021-08-26 :: CHILD_ITEM_ID 불일치 오류 수정 (cell requirement total 수식설정오류) */
                                     AND SA.CELL_TYPE                IN ('CP', 'CA2'))  /* -- 20220701 PJ20230691 활성화 분리 */
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V XA
                              /* --,ROW_NUMBER() OVER (PARTITION BY MODEL_ID ORDER BY TCO_CELL_YN DESC) AS Rn		-- KSW 2021-08-26 :: CHILD_ITEM_ID 불일치 오류 수정 (cell requirement total 수식설정오류) */
                        WHERE XA.MODEL_ID IN (SELECT DISTINCT
                                                     XB.ITEM_ID
                                                FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK XB
                                               WHERE XB.OPERATION_GROUP      = 'P'
                                                 AND XB.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                                                 AND XB.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                                                 AND XB.PLAN_TYPE            = P_PLAN_TYPE
                                                 AND XB.SEQ                  = N_SEQ)
                          AND XA.MODEL_ID                 = A.ITEM_ID
                          AND XA.OPERATION_GROUP_ID       = 'A'
                          AND SUBSTR(XA.CHILD_ITEM_ID, 1, 1) = 'M'
                          AND XA.CELL_TYPE                IN ('CP', 'CA2'))
           /* --AND Y.Rn = 1				-- KSW 2021-08-26 :: CHILD_ITEM_ID 불일치 오류 수정 (cell requirement total 수식설정오류) */
           AND A.OPERATION_GROUP      = 'P'
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
           AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
           AND A.PLAN_TYPE            = P_PLAN_TYPE
           AND A.SEQ                  = N_SEQ;

        /* CELL_QTY_PACK */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK A
           SET A.CELL_QTY_PACK = (SELECT MAX(CEIL(SA.ACCUMULATED_CHILD_QTY))  /* CONVERT(NVARCHAR(50), CEILING(V.ACCUMULATED_CHILD_QTY)) */
                                    FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V SA
                                   WHERE SA.DIVISION_ID        = A.DIVISION_ID
                                     AND SA.MODEL_ID           = A.ITEM_ID
                                     AND SA.CHILD_ITEM_ID      = A.CELL_ITEM_ID
                                     AND SA.OPERATION_GROUP_ID = 'A')
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V XA
                        WHERE XA.DIVISION_ID        = A.DIVISION_ID
                          AND XA.MODEL_ID           = A.ITEM_ID
                          AND XA.CHILD_ITEM_ID      = A.CELL_ITEM_ID
                          AND XA.OPERATION_GROUP_ID = 'A')
           AND A.OPERATION_GROUP      = 'P'
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
           AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
           AND A.PLAN_TYPE            = P_PLAN_TYPE
           AND A.SEQ                  = N_SEQ;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 021 ');

        /* PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용 */
        /* ISUZU 모듈에 대한 CELL_QTY_PACK 업데이트 */
        /* 원본 UPDATE .. FROM JOIN : 한 모듈에 여러 행이 걸리면 MSSQL 은 임의 1건 → MAX 로 고정 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT IB.MODULE_ID
                     , MAX(NVL(IB.CELL_QTY_PACK, 1) / NVL(IB.MODULE_QTY_PACK, 1)) AS CELL_QTY_PACK
                  FROM ( SELECT DISTINCT
                                B.MODEL_ID              AS ITEM_ID
                              , B.CHILD_ITEM_ID         AS CELL_ITEM_ID
                              , B.ACCUMULATED_CHILD_QTY AS CELL_QTY_PACK
                              , IC.MODULE_ID
                              , IC.MODULE_QTY_PACK
                           FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                              , ( SELECT C.DIVISION_ID
                                       , C.MODEL_ID
                                       , C.CHILD_ITEM_ID AS MODULE_ID
                                       , C.CHILD_QTY     AS MODULE_QTY_PACK
                                    FROM SCM_MST_BOM_SN_V C  /* --2021-03-09	SCP 대치 BOM 적용 */
                                       , SCM_MST_ITEM_SN D
                                   WHERE C.CHILD_DIVISION_ID = D.DIVISION_ID
                                     AND C.CHILD_ITEM_ID     = D.ITEM_ID
                                     AND C.CHILD_COMPANY_ID  = D.COMPANY_ID  /* -- A002 빈강 추가 따른 조건 추가 */
                                     AND C.CHILD_SITE_ID     = D.SITE_ID
                                     AND D.FLOW_ID           = 'P5000'
                                     AND D.ACTIVE_FLAG       = 'Y'
                                     AND C.DIVISION_ID       = V_DIVISION_ID
                                ) IC
                          WHERE B.DIVISION_ID        = IC.DIVISION_ID
                            AND B.MODEL_ID           = IC.MODEL_ID
                            AND B.OPERATION_GROUP_ID = 'A'
                            AND B.DIVISION_ID        = V_DIVISION_ID
                       ) IB
                 GROUP BY IB.MODULE_ID
              ) IA
           ON (     A.ITEM_ID              = IA.MODULE_ID
                AND A.ATTRIBUTE9           = 'P5000'
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.CELL_QTY_PACK = IA.CELL_QTY_PACK;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 022 ');

        /* LT_DAY */
        /* 원본 CASE WHEN X.BOD_ID='-' THEN '-' ELSE CONVERT(NVARCHAR(50), (B.LT_TOTAL)) END → INT 칸에 '-' 는 MSSQL 이 0 으로 바꿈(CONVERT(int, N'-') = 0 실측) → 0 */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK A
           SET A.LT_DAY = CASE WHEN A.BOD_ID = '-' THEN 0
                               ELSE (SELECT MAX(SA.LT_TOTAL)
                                       FROM GT_XSPK_BOD_V SA
                                      WHERE SA.DIVISION_ID = A.DIVISION_ID
                                        AND SA.BOD_ID      = A.BOD_ID
                                        AND SA.FROM_SITE   = A.FROM_SITE)
                          END
         WHERE A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
           AND A.PLAN_TYPE            = P_PLAN_TYPE
           AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
           AND A.SEQ                  = N_SEQ;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 023 ');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* CELL_PKG_PLAN_OUT LT */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 원본 SELECT TOP 1 item_id_assy (ORDER BY 없음) → ROWNUM = 1 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT B.ROWID AS RID
                     , IA.TOTAL_LT_FORMATION
                  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK B
                     , ( SELECT MAX(IB.TOTAL_LT_FORMATION)    AS TOTAL_LT_FORMATION
                              , AVG(IB.FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                              , C.CELL_ITEM_ID
                           FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL C  /* 주의 CELL 테이블 참조함 */
                              , ( SELECT D.ITEM_ID
                                       , D.PLANT_SITE_ID
                                       , MAX(D.FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                                       , MAX(D.TOTAL_LT_FORMATION)    AS TOTAL_LT_FORMATION
                                       , ROW_NUMBER() OVER(PARTITION BY D.ITEM_ID ORDER BY MAX(D.TOTAL_LT_FORMATION) DESC NULLS LAST) AS RN
                                    FROM SCP_MST_FORMATION_V D
                                   WHERE D.DIVISION_ID = '40'
                                   GROUP BY D.ITEM_ID
                                          , D.PLANT_SITE_ID
                                ) IB
                          WHERE C.CELL_ITEM_ID = IB.ITEM_ID
                            /* -- AND X.SITE_ID     = Y.PLANT_SITE_ID */
                            AND C.MEASURE      = 'PROD'
                            AND IB.RN          = 1
                          GROUP BY C.CELL_ITEM_ID  /* --,FORMATION_TOTAL_YIELD */
                       ) IA
                       /* 활성화로 CP-CA 연계 필요 */
                       /* --ON XX.CELL_ITEM_ID = YY.CELL_ITEM_ID */
                 WHERE IA.CELL_ITEM_ID = (SELECT SA.ITEM_ID_ASSY
                                            FROM SCP_MST_CELL_PROD_ASSY_MAP SA
                                           WHERE SA.ITEM_ID_PROD = B.CELL_ITEM_ID
                                             AND SA.CELL_TYPE    = 'CA1'
                                             AND ROWNUM          = 1)
                   AND B.MEASURE              = 'CELL_PKG_PLAN_OUT'
                   AND B.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                   AND B.PLAN_TYPE            = P_PLAN_TYPE
                   AND B.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                   AND B.SEQ                  = N_SEQ
              ) IC
           ON ( A.ROWID = IC.RID )
         WHEN MATCHED THEN
       UPDATE
          SET A.LT_DAY = TRUNC(IC.TOTAL_LT_FORMATION);  /* INT 칸 : MSSQL 은 소수점 아래를 버림 */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 024 ');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* CELL_PKG_PLAN_OUT YIELD */
        /* [C20200513-000232] 소형SCP Pack Simulator Cell 활성화 수율 적용 요청 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* Cell 조립 수율 표기 (조립 수율 : GSCM - SSP - Shipment Plan(IT&Mobile)에 적용된 수율과 동일 수율 적용 */
        /* SSP0015_GET_SHIPMENT_PSI 와 동일 로직 적용 */
        /* 원본 ISNULL(CONVERT(NVARCHAR,(SELECT CONVERT(NUMERIC(5,2), ROUND(Y.SSP_MODIFY_YIELD*100,2) ))), '0.0') → 숫자 칸 : NVL(ROUND(..), 0) */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT B.DIVISION_ID
                     , B.PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.SEQ
                     , B.PLANT_SITE_ID
                     , B.ITEM_ID
                     , B.SSP_MODIFY_YIELD
                       /* --, ISNULL(CONVERT(NVARCHAR,(SELECT CONVERT(NUMERIC(5,2), ROUND(Y.SSP_MODIFY_YIELD*100,2) ))), '0') */
                  FROM SSP_ANL_FORMATION_C B
                     , ( SELECT DIVISION_ID
                              , MAX(PLAN_START_YYYYMMDD) AS PLAN_START_YYYYMMDD
                              , PLAN_TYPE
                              , SEQ
                              , PLANT_SITE_ID
                              , ITEM_ID
                           FROM SSP_ANL_FORMATION_C
                          GROUP BY DIVISION_ID
                                 , PLANT_SITE_ID
                                 , PLAN_TYPE
                                 , SEQ
                                 , ITEM_ID
                       ) IB
                 WHERE B.DIVISION_ID         = IB.DIVISION_ID
                   AND B.PLAN_START_YYYYMMDD = IB.PLAN_START_YYYYMMDD
                   AND B.PLAN_TYPE           = IB.PLAN_TYPE
                   AND B.SEQ                 = IB.SEQ
                   AND B.PLANT_SITE_ID       = IB.PLANT_SITE_ID
                   AND B.ITEM_ID             = IB.ITEM_ID
                   AND B.PLAN_TYPE           = 'SP'
                   AND B.SEQ                 = 1
              ) IA
           ON (     A.DIVISION_ID          = IA.DIVISION_ID
                AND A.FROM_SITE            = IA.PLANT_SITE_ID
                AND A.CELL_ITEM_ID         = IA.ITEM_ID
                /* -- AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD */
                AND A.MEASURE              = 'CELL_PKG_PLAN_OUT'
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.YIELD = NVL(ROUND(IA.SSP_MODIFY_YIELD * 100, 2), 0);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 025 ');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- start */
        /* BOD_ID에 대한 from_yyyymmdd, to_yyyymmdd 추가 --> ATTRIBUTE3 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 원본 Z.FROM_YYYYMMDD + ',' + Z.TO_YYYYMMDD : 한쪽이 NULL 이면 결과 NULL (MSSQL '+') → CASE 로 재현 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT BOD_ID
                     , FROM_YYYYMMDD
                     , TO_YYYYMMDD
                  FROM SCP_MST_BOD_N_V
              ) IA
           ON (     A.BOD_ID               = IA.BOD_ID
                AND A.MEASURE              IN ('PACK_SHIP_PLAN', 'CELL_SHIP_PLAN')
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.ATTRIBUTE3 = CASE WHEN IA.FROM_YYYYMMDD IS NULL OR IA.TO_YYYYMMDD IS NULL THEN NULL
                                  ELSE IA.FROM_YYYYMMDD || ',' || IA.TO_YYYYMMDD
                             END;
        /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- end */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 026 ');

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 52주 데이터 SCRIPT 생성후 UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 원본은 #Rn(WQTY01~52 ↔ 1~364) · #CALENDAR(@p_create_from_yyyymmdd ~ @p_create_to_yyyymmdd 미만 일자에 QTY001~ 번호)
           · #HEADER 로 'UPDATE X SET WQTYnn = (QTYa+..+QTYb), .. WHERE ..' 를 조립해 EXEC sp_executesql 로 실행한다.
           달력 SCM_SYS_CALENDAR_M 은 20090101~20501231 사이 일자 빠짐이 없고(15,340일 실측),
           부르는 쪽이 @p_create_to_yyyymmdd = @p_create_from_yyyymmdd + 363 으로 넘기므로 대응이 고정된다
           (WQTY01 = QTY001~007 … WQTY51 = QTY351~357, WQTY52 = QTY358~363) → 동적 SQL 없이 정적 UPDATE 로 옮김. */
        /* --  SELECT 'WQTY' + A.ISO_WEEK     AS WEEK_COLUMN */
        /* --  , ROW_NUMBER() OVER (ORDER BY ISO_WEEK) AS Rn */
        /* --  INTO #Rn */
        /* -- FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK) */
        /* --WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd */
        /* --    AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd */
        /* #CALENDAR : WHERE A.BASIS_YYYYMMDD  >= @p_create_from_yyyymmdd ------------------------------------------------DHJ**** */
        /* #CALENDAR : GROUP BY A.BASIS_YYYYMMDD--,ISO_WEEK--,A.BASIS_YYYYMM,ISO_WEEK */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 027 ');

        /* --SELECT * FROM #Rn */
        /* --order by rn */
        /* --SELECT * FROM #CALENDAR */
        /* --order by SORT_ORDER_NO */
        /* --              SELECT @mQry_sumWeek = @mQry_sumWeek + 'SET'+CHAR(10) */
        /* 원본 동적 WHERE 에는 DIVISION_ID 조건이 없음(그대로 둠) */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK
           SET
                WQTY01 = (QTY001 + QTY002 + QTY003 + QTY004 + QTY005 + QTY006 + QTY007)
              , WQTY02 = (QTY008 + QTY009 + QTY010 + QTY011 + QTY012 + QTY013 + QTY014)
              , WQTY03 = (QTY015 + QTY016 + QTY017 + QTY018 + QTY019 + QTY020 + QTY021)
              , WQTY04 = (QTY022 + QTY023 + QTY024 + QTY025 + QTY026 + QTY027 + QTY028)
              , WQTY05 = (QTY029 + QTY030 + QTY031 + QTY032 + QTY033 + QTY034 + QTY035)
              , WQTY06 = (QTY036 + QTY037 + QTY038 + QTY039 + QTY040 + QTY041 + QTY042)
              , WQTY07 = (QTY043 + QTY044 + QTY045 + QTY046 + QTY047 + QTY048 + QTY049)
              , WQTY08 = (QTY050 + QTY051 + QTY052 + QTY053 + QTY054 + QTY055 + QTY056)
              , WQTY09 = (QTY057 + QTY058 + QTY059 + QTY060 + QTY061 + QTY062 + QTY063)
              , WQTY10 = (QTY064 + QTY065 + QTY066 + QTY067 + QTY068 + QTY069 + QTY070)
              , WQTY11 = (QTY071 + QTY072 + QTY073 + QTY074 + QTY075 + QTY076 + QTY077)
              , WQTY12 = (QTY078 + QTY079 + QTY080 + QTY081 + QTY082 + QTY083 + QTY084)
              , WQTY13 = (QTY085 + QTY086 + QTY087 + QTY088 + QTY089 + QTY090 + QTY091)
              , WQTY14 = (QTY092 + QTY093 + QTY094 + QTY095 + QTY096 + QTY097 + QTY098)
              , WQTY15 = (QTY099 + QTY100 + QTY101 + QTY102 + QTY103 + QTY104 + QTY105)
              , WQTY16 = (QTY106 + QTY107 + QTY108 + QTY109 + QTY110 + QTY111 + QTY112)
              , WQTY17 = (QTY113 + QTY114 + QTY115 + QTY116 + QTY117 + QTY118 + QTY119)
              , WQTY18 = (QTY120 + QTY121 + QTY122 + QTY123 + QTY124 + QTY125 + QTY126)
              , WQTY19 = (QTY127 + QTY128 + QTY129 + QTY130 + QTY131 + QTY132 + QTY133)
              , WQTY20 = (QTY134 + QTY135 + QTY136 + QTY137 + QTY138 + QTY139 + QTY140)
              , WQTY21 = (QTY141 + QTY142 + QTY143 + QTY144 + QTY145 + QTY146 + QTY147)
              , WQTY22 = (QTY148 + QTY149 + QTY150 + QTY151 + QTY152 + QTY153 + QTY154)
              , WQTY23 = (QTY155 + QTY156 + QTY157 + QTY158 + QTY159 + QTY160 + QTY161)
              , WQTY24 = (QTY162 + QTY163 + QTY164 + QTY165 + QTY166 + QTY167 + QTY168)
              , WQTY25 = (QTY169 + QTY170 + QTY171 + QTY172 + QTY173 + QTY174 + QTY175)
              , WQTY26 = (QTY176 + QTY177 + QTY178 + QTY179 + QTY180 + QTY181 + QTY182)
              , WQTY27 = (QTY183 + QTY184 + QTY185 + QTY186 + QTY187 + QTY188 + QTY189)
              , WQTY28 = (QTY190 + QTY191 + QTY192 + QTY193 + QTY194 + QTY195 + QTY196)
              , WQTY29 = (QTY197 + QTY198 + QTY199 + QTY200 + QTY201 + QTY202 + QTY203)
              , WQTY30 = (QTY204 + QTY205 + QTY206 + QTY207 + QTY208 + QTY209 + QTY210)
              , WQTY31 = (QTY211 + QTY212 + QTY213 + QTY214 + QTY215 + QTY216 + QTY217)
              , WQTY32 = (QTY218 + QTY219 + QTY220 + QTY221 + QTY222 + QTY223 + QTY224)
              , WQTY33 = (QTY225 + QTY226 + QTY227 + QTY228 + QTY229 + QTY230 + QTY231)
              , WQTY34 = (QTY232 + QTY233 + QTY234 + QTY235 + QTY236 + QTY237 + QTY238)
              , WQTY35 = (QTY239 + QTY240 + QTY241 + QTY242 + QTY243 + QTY244 + QTY245)
              , WQTY36 = (QTY246 + QTY247 + QTY248 + QTY249 + QTY250 + QTY251 + QTY252)
              , WQTY37 = (QTY253 + QTY254 + QTY255 + QTY256 + QTY257 + QTY258 + QTY259)
              , WQTY38 = (QTY260 + QTY261 + QTY262 + QTY263 + QTY264 + QTY265 + QTY266)
              , WQTY39 = (QTY267 + QTY268 + QTY269 + QTY270 + QTY271 + QTY272 + QTY273)
              , WQTY40 = (QTY274 + QTY275 + QTY276 + QTY277 + QTY278 + QTY279 + QTY280)
              , WQTY41 = (QTY281 + QTY282 + QTY283 + QTY284 + QTY285 + QTY286 + QTY287)
              , WQTY42 = (QTY288 + QTY289 + QTY290 + QTY291 + QTY292 + QTY293 + QTY294)
              , WQTY43 = (QTY295 + QTY296 + QTY297 + QTY298 + QTY299 + QTY300 + QTY301)
              , WQTY44 = (QTY302 + QTY303 + QTY304 + QTY305 + QTY306 + QTY307 + QTY308)
              , WQTY45 = (QTY309 + QTY310 + QTY311 + QTY312 + QTY313 + QTY314 + QTY315)
              , WQTY46 = (QTY316 + QTY317 + QTY318 + QTY319 + QTY320 + QTY321 + QTY322)
              , WQTY47 = (QTY323 + QTY324 + QTY325 + QTY326 + QTY327 + QTY328 + QTY329)
              , WQTY48 = (QTY330 + QTY331 + QTY332 + QTY333 + QTY334 + QTY335 + QTY336)
              , WQTY49 = (QTY337 + QTY338 + QTY339 + QTY340 + QTY341 + QTY342 + QTY343)
              , WQTY50 = (QTY344 + QTY345 + QTY346 + QTY347 + QTY348 + QTY349 + QTY350)
              , WQTY51 = (QTY351 + QTY352 + QTY353 + QTY354 + QTY355 + QTY356 + QTY357)
              , WQTY52 = (QTY358 + QTY359 + QTY360 + QTY361 + QTY362 + QTY363)
         WHERE PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
           AND PLAN_TYPE            = P_PLAN_TYPE
           AND SEQ                  = N_SEQ;
        /* ----------------------------------------------------------DHJ */
        /*
        PRINT '@mQry_sumWeek'
        PRINT @mQry_sumWeek
        */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* WEEK SUM PIVOT 생성 후 UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #LineLoad_WEEK · #LineLoad_WEEK_PIVOT : 한 번만 쓰이므로 아래 MERGE 의 USING 으로 옮김 (PIVOT MIN(WQTY) → MIN(CASE ..) + GROUP BY) */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 028 ');

        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT IB.DIVISION_ID
                     , IB.SITE_ID
                     , IB.OPERATION_ID
                     , IB.PROD_LINE
                     , IB.MEASURE
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY01' THEN IB.WQTY END) AS WQTY01
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY02' THEN IB.WQTY END) AS WQTY02
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY03' THEN IB.WQTY END) AS WQTY03
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY04' THEN IB.WQTY END) AS WQTY04
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY05' THEN IB.WQTY END) AS WQTY05
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY06' THEN IB.WQTY END) AS WQTY06
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY07' THEN IB.WQTY END) AS WQTY07
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY08' THEN IB.WQTY END) AS WQTY08
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY09' THEN IB.WQTY END) AS WQTY09
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY10' THEN IB.WQTY END) AS WQTY10
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY11' THEN IB.WQTY END) AS WQTY11
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY12' THEN IB.WQTY END) AS WQTY12
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY13' THEN IB.WQTY END) AS WQTY13
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY14' THEN IB.WQTY END) AS WQTY14
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY15' THEN IB.WQTY END) AS WQTY15
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY16' THEN IB.WQTY END) AS WQTY16
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY17' THEN IB.WQTY END) AS WQTY17
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY18' THEN IB.WQTY END) AS WQTY18
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY19' THEN IB.WQTY END) AS WQTY19
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY20' THEN IB.WQTY END) AS WQTY20
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY21' THEN IB.WQTY END) AS WQTY21
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY22' THEN IB.WQTY END) AS WQTY22
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY23' THEN IB.WQTY END) AS WQTY23
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY24' THEN IB.WQTY END) AS WQTY24
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY25' THEN IB.WQTY END) AS WQTY25
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY26' THEN IB.WQTY END) AS WQTY26
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY27' THEN IB.WQTY END) AS WQTY27
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY28' THEN IB.WQTY END) AS WQTY28
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY29' THEN IB.WQTY END) AS WQTY29
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY30' THEN IB.WQTY END) AS WQTY30
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY31' THEN IB.WQTY END) AS WQTY31
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY32' THEN IB.WQTY END) AS WQTY32
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY33' THEN IB.WQTY END) AS WQTY33
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY34' THEN IB.WQTY END) AS WQTY34
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY35' THEN IB.WQTY END) AS WQTY35
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY36' THEN IB.WQTY END) AS WQTY36
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY37' THEN IB.WQTY END) AS WQTY37
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY38' THEN IB.WQTY END) AS WQTY38
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY39' THEN IB.WQTY END) AS WQTY39
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY40' THEN IB.WQTY END) AS WQTY40
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY41' THEN IB.WQTY END) AS WQTY41
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY42' THEN IB.WQTY END) AS WQTY42
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY43' THEN IB.WQTY END) AS WQTY43
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY44' THEN IB.WQTY END) AS WQTY44
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY45' THEN IB.WQTY END) AS WQTY45
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY46' THEN IB.WQTY END) AS WQTY46
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY47' THEN IB.WQTY END) AS WQTY47
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY48' THEN IB.WQTY END) AS WQTY48
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY49' THEN IB.WQTY END) AS WQTY49
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY50' THEN IB.WQTY END) AS WQTY50
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY51' THEN IB.WQTY END) AS WQTY51
                     , MIN(CASE WHEN IB.WEEK_COLUMN = 'WQTY52' THEN IB.WQTY END) AS WQTY52
                  FROM ( SELECT B.DIVISION_ID
                              , B.SCM_SITE_ID  AS SITE_ID
                              , B.OPERATION_ID
                              , B.LINE_ID      AS PROD_LINE
                              , B.MEASURE
                              , CASE WHEN SUM(B.WORKING_TIME) <= 0.0 THEN 0
                                     ELSE NVL((ROUND(SUM(B.CAPA_TACT), 0) / SUM(B.WORKING_TIME)), 0) * 100
                                END            AS WQTY
                              , B.ISO_YYYYWW
                              , B.WEEK_COLUMN
                           FROM GT_XSPK_LINELOAD B
                          GROUP BY B.DIVISION_ID
                                 , B.SCM_SITE_ID
                                 , B.OPERATION_ID
                                 , B.LINE_ID
                                 , B.MEASURE
                                 , B.ISO_YYYYWW
                                 , B.WEEK_COLUMN
                       ) IB
                 GROUP BY IB.DIVISION_ID
                        , IB.SITE_ID
                        , IB.OPERATION_ID
                        , IB.PROD_LINE
                        , IB.MEASURE
              ) IA
           ON (     IA.PROD_LINE           = A.PROD_LINE
                AND A.DIVISION_ID          = IA.DIVISION_ID
                AND A.FROM_SITE            = IA.SITE_ID
                AND A.ATTRIBUTE9           = IA.OPERATION_ID
                AND A.MEASURE              IN ('PACK_PROD_LOAD')
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET
               A.WQTY01 = IA.WQTY01
             , A.WQTY02 = IA.WQTY02
             , A.WQTY03 = IA.WQTY03
             , A.WQTY04 = IA.WQTY04
             , A.WQTY05 = IA.WQTY05
             , A.WQTY06 = IA.WQTY06
             , A.WQTY07 = IA.WQTY07
             , A.WQTY08 = IA.WQTY08
             , A.WQTY09 = IA.WQTY09
             , A.WQTY10 = IA.WQTY10
             , A.WQTY11 = IA.WQTY11
             , A.WQTY12 = IA.WQTY12
             , A.WQTY13 = IA.WQTY13
             , A.WQTY14 = IA.WQTY14
             , A.WQTY15 = IA.WQTY15
             , A.WQTY16 = IA.WQTY16
             , A.WQTY17 = IA.WQTY17
             , A.WQTY18 = IA.WQTY18
             , A.WQTY19 = IA.WQTY19
             , A.WQTY20 = IA.WQTY20
             , A.WQTY21 = IA.WQTY21
             , A.WQTY22 = IA.WQTY22
             , A.WQTY23 = IA.WQTY23
             , A.WQTY24 = IA.WQTY24
             , A.WQTY25 = IA.WQTY25
             , A.WQTY26 = IA.WQTY26
             , A.WQTY27 = IA.WQTY27
             , A.WQTY28 = IA.WQTY28
             , A.WQTY29 = IA.WQTY29
             , A.WQTY30 = IA.WQTY30
             , A.WQTY31 = IA.WQTY31
             , A.WQTY32 = IA.WQTY32
             , A.WQTY33 = IA.WQTY33
             , A.WQTY34 = IA.WQTY34
             , A.WQTY35 = IA.WQTY35
             , A.WQTY36 = IA.WQTY36
             , A.WQTY37 = IA.WQTY37
             , A.WQTY38 = IA.WQTY38
             , A.WQTY39 = IA.WQTY39
             , A.WQTY40 = IA.WQTY40
             , A.WQTY41 = IA.WQTY41
             , A.WQTY42 = IA.WQTY42
             , A.WQTY43 = IA.WQTY43
             , A.WQTY44 = IA.WQTY44
             , A.WQTY45 = IA.WQTY45
             , A.WQTY46 = IA.WQTY46
             , A.WQTY47 = IA.WQTY47
             , A.WQTY48 = IA.WQTY48
             , A.WQTY49 = IA.WQTY49
             , A.WQTY50 = IA.WQTY50
             , A.WQTY51 = IA.WQTY51
             , A.WQTY52 = IA.WQTY52;
        /* -- */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 029 ');

        /* END_CUSTOMER UPDATE */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING SCM_MST_SITE B
           ON (     A.DIVISION_ID          = B.DIVISION_ID
                AND A.TO_SITE              = B.SCM_SITE_ID
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.END_CUSTOMER = B.SOLDTO_CUSTOMER;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 030 ');

        /* PROJECT CODE UPDATE */
        /* MIN(PROJECT_CODE) : MSSQL 정렬규칙 기준 최솟값 → FN_ASIS_SORT_KEY 순서의 첫 값 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT DISTINCT  /* 2021.11.17 DISTINCT 추가 */
                       B.DIVISION_ID
                     , B.PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.SEQ
                     , B.BIZ_TYPE
                     , MIN(B.PROJECT_CODE) KEEP (DENSE_RANK FIRST ORDER BY FN_ASIS_SORT_KEY(B.PROJECT_CODE) NULLS LAST) AS MIN_PROJECT_CODE  /* 동일  조건에서 2개 이상의 프로젝트 코드가 있음 (AMEND를 제외하고는 하나로 합침. 20231026. 신재욱 책임) */
                     , B.ITEM_ID
                     , B.TO_SITE
                     , B.FROM_SITE
                  FROM SCP_ANL_SHIPMENT_PLAN_FG B
                 WHERE B.PROJECT_CODE        <> '-'
                   AND B.MEASURE             <> 'SHIP_PLAN_AMEND'  /* 2021.11.17 조건절 추가 */
                   /* --                                        AND A.BIZ_TYPE              =  'A' */
                   AND B.DIVISION_ID          = V_DIVISION_ID
                   AND B.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                   AND B.PLAN_TYPE            = P_PLAN_TYPE
                   AND B.SEQ                  = N_SEQ
                   /* --		                                    AND A.YYYYMMDD              =  @p_plan_start_yyyymmdd */
                   AND B.YYYYMMDD             = V_CREATE_FROM_YYYYMMDD
                 GROUP BY B.DIVISION_ID
                        , B.PLAN_START_YYYYMMDD
                        , B.PLAN_TYPE
                        , B.SEQ
                        , B.BIZ_TYPE
                        , B.ITEM_ID
                        , B.TO_SITE
                        , B.FROM_SITE
              ) IA
           ON (     A.DIVISION_ID          = IA.DIVISION_ID
                AND A.PLAN_START_YYYYMMDD  = IA.PLAN_START_YYYYMMDD
                AND A.PLAN_TYPE            = IA.PLAN_TYPE
                AND A.SEQ                  = IA.SEQ
                AND A.OPERATION_GROUP      = IA.BIZ_TYPE
                /* --                         AND X.PROJECT_CODE          = Y.PROJECT_CODE */
                AND A.ITEM_ID              = IA.ITEM_ID
                AND A.TO_SITE              = IA.TO_SITE    /* 2021.11.17 조건절 추가 */
                AND A.FROM_SITE            = IA.FROM_SITE  /* 2021.11.17 조건절 추가 */
                AND A.OPERATION_GROUP      = 'P'
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.PROJECT_CODE = IA.MIN_PROJECT_CODE;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 031 ');

        /* 20260615 튜닝. 주석처리 시작 */
        /*
                         SELECT  DISTINCT CELL_ITEM_ID,
                                            STUFF((SELECT ',' + PROJECT_CODE
                                                    FROM (
                                                            SELECT DISTINCT X.PROJECT_CODE
                                                            FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                                                            WHERE 0 = 0
                                                            AND X.OPERATION_GROUP ='P'
                                                            AND X.CELL_ITEM_ID = Y.CELL_ITEM_ID
                                                            AND X.PROJECT_CODE <> '-'
                                                            AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
                                                            AND X.PLAN_TYPE           = @p_plan_type
                                                            AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
                                                            AND X.SEQ                 = @p_seq
                                                            ) X
                                                            FOR XML PATH('')),1,1,''
                                                          ) AS PROJECT_CODE
                          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK Y  WITH (NOLOCK)
                          WHERE 0 = 0
                            AND Y.OPERATION_GROUP ='P'
                            AND Y.PROJECT_CODE <> '-'
                            AND Y.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
                            AND Y.PLAN_TYPE           = @p_plan_type
                            AND Y.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd -----------------------DHJ
                            AND Y.SEQ                 = @p_seq
        */
        /* 20260615 튜닝. 주석처리 끝 */
        /* 20260615 튜닝. 신규로직 시작 */
        /* 원본 STRING_AGG(PROJECT_CODE, ',') 는 순서 지정이 없어 순서가 정해지지 않음 → LISTAGG 는 MSSQL 정렬규칙 순으로 고정 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT IB.CELL_ITEM_ID
                     , LISTAGG(IB.PROJECT_CODE, ',') WITHIN GROUP (ORDER BY FN_ASIS_SORT_KEY(IB.PROJECT_CODE) NULLS FIRST, IB.PROJECT_CODE) AS PROJECT_CODE
                  FROM ( SELECT DISTINCT
                                CELL_ITEM_ID
                              , PROJECT_CODE
                           FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
                          WHERE OPERATION_GROUP      = 'P'
                            AND PROJECT_CODE         <> '-'
                            AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                            AND PLAN_TYPE            = P_PLAN_TYPE
                            AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
                            AND SEQ                  = N_SEQ
                       ) IB  /* LIST */
                 GROUP BY IB.CELL_ITEM_ID
                 /* 20260615 튜닝. 신규로직 끝 */
              ) IA
           ON (     A.CELL_ITEM_ID         = IA.CELL_ITEM_ID
                AND A.OPERATION_GROUP      = 'A'
                AND A.MEASURE              NOT IN ('DM_MKT_FCST', 'SHIP_REQ', 'WHIN_TOTAL', 'SHIP_PLAN_TOTAL', 'INTRANSIT_TOTAL', 'BALANCE', 'BALANCE_CUM', 'TO_SITE_BOH', 'TO_SITE_EOH')
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.PROJECT_CODE = IA.PROJECT_CODE;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 032 ');

        /* 보정 PACK_SHIP_PLAN 이 중복으로 나옴.. --> 추가 수정 할것, 상단 로직 다시 확인 해야 함. */
        /* 원본 DELETE TBL FROM (SELECT ROW_NUMBER() .. AS ROWNUM ..) AS TBL WHERE TBL.ROWNUM > 1 → ROWID 로 지움 (ROWNUM 은 Oracle 예약어라 RN) */
        /* 합계식은 원본 그대로(30·40번째 QTY310, 130·140번째 QTY110, 230·240번째 QTY210, 330·340번째 QTY310) */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
         WHERE ROWID IN (SELECT IA.RID
                           FROM ( SELECT ROWID AS RID
                                       , ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID, NICK_NAME, TO_SITE, PROJECT_CODE, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE, BOD_ID
                                                                ORDER BY ITEM_ID
                                                                       , (
                                                                         QTY001 + QTY002 + QTY003 + QTY004 + QTY005 + QTY006 + QTY007 + QTY008 + QTY009 + QTY010 +
                                                                         QTY011 + QTY012 + QTY013 + QTY014 + QTY015 + QTY016 + QTY017 + QTY018 + QTY019 + QTY020 +
                                                                         QTY021 + QTY022 + QTY023 + QTY024 + QTY025 + QTY026 + QTY027 + QTY028 + QTY029 + QTY310 +
                                                                         QTY031 + QTY032 + QTY033 + QTY034 + QTY035 + QTY036 + QTY037 + QTY038 + QTY039 + QTY310 +
                                                                         QTY041 + QTY042 + QTY043 + QTY044 + QTY045 + QTY046 + QTY047 + QTY048 + QTY049 + QTY050 +
                                                                         QTY051 + QTY052 + QTY053 + QTY054 + QTY055 + QTY056 + QTY057 + QTY058 + QTY059 + QTY060 +
                                                                         QTY061 + QTY062 + QTY063 + QTY064 + QTY065 + QTY066 + QTY067 + QTY068 + QTY069 + QTY070 +
                                                                         QTY071 + QTY072 + QTY073 + QTY074 + QTY075 + QTY076 + QTY077 + QTY078 + QTY079 + QTY080 +
                                                                         QTY081 + QTY082 + QTY083 + QTY084 + QTY085 + QTY086 + QTY087 + QTY088 + QTY089 + QTY090 +
                                                                         QTY091 + QTY092 + QTY093 + QTY094 + QTY095 + QTY096 + QTY097 + QTY098 + QTY099 + QTY100 +
                                                                         QTY101 + QTY102 + QTY103 + QTY104 + QTY105 + QTY106 + QTY107 + QTY108 + QTY109 + QTY110 +
                                                                         QTY111 + QTY112 + QTY113 + QTY114 + QTY115 + QTY116 + QTY117 + QTY118 + QTY119 + QTY120 +
                                                                         QTY121 + QTY122 + QTY123 + QTY124 + QTY125 + QTY126 + QTY127 + QTY128 + QTY129 + QTY110 +
                                                                         QTY131 + QTY132 + QTY133 + QTY134 + QTY135 + QTY136 + QTY137 + QTY138 + QTY139 + QTY110 +
                                                                         QTY141 + QTY142 + QTY143 + QTY144 + QTY145 + QTY146 + QTY147 + QTY148 + QTY149 + QTY150 +
                                                                         QTY151 + QTY152 + QTY153 + QTY154 + QTY155 + QTY156 + QTY157 + QTY158 + QTY159 + QTY160 +
                                                                         QTY161 + QTY162 + QTY163 + QTY164 + QTY165 + QTY166 + QTY167 + QTY168 + QTY169 + QTY170 +
                                                                         QTY171 + QTY172 + QTY173 + QTY174 + QTY175 + QTY176 + QTY177 + QTY178 + QTY179 + QTY180 +
                                                                         QTY181 + QTY182 + QTY183 + QTY184 + QTY185 + QTY186 + QTY187 + QTY188 + QTY189 + QTY190 +
                                                                         QTY191 + QTY192 + QTY193 + QTY194 + QTY195 + QTY196 + QTY197 + QTY198 + QTY199 + QTY200 +
                                                                         QTY201 + QTY202 + QTY203 + QTY204 + QTY205 + QTY206 + QTY207 + QTY208 + QTY209 + QTY210 +
                                                                         QTY211 + QTY212 + QTY213 + QTY214 + QTY215 + QTY216 + QTY217 + QTY218 + QTY219 + QTY220 +
                                                                         QTY221 + QTY222 + QTY223 + QTY224 + QTY225 + QTY226 + QTY227 + QTY228 + QTY229 + QTY210 +
                                                                         QTY231 + QTY232 + QTY233 + QTY234 + QTY235 + QTY236 + QTY237 + QTY238 + QTY239 + QTY210 +
                                                                         QTY241 + QTY242 + QTY243 + QTY244 + QTY245 + QTY246 + QTY247 + QTY248 + QTY249 + QTY250 +
                                                                         QTY251 + QTY252 + QTY253 + QTY254 + QTY255 + QTY256 + QTY257 + QTY258 + QTY259 + QTY260 +
                                                                         QTY261 + QTY262 + QTY263 + QTY264 + QTY265 + QTY266 + QTY267 + QTY268 + QTY269 + QTY270 +
                                                                         QTY271 + QTY272 + QTY273 + QTY274 + QTY275 + QTY276 + QTY277 + QTY278 + QTY279 + QTY280 +
                                                                         QTY281 + QTY282 + QTY283 + QTY284 + QTY285 + QTY286 + QTY287 + QTY288 + QTY289 + QTY290 +
                                                                         QTY291 + QTY292 + QTY293 + QTY294 + QTY295 + QTY296 + QTY297 + QTY298 + QTY299 + QTY300 +
                                                                         QTY301 + QTY302 + QTY303 + QTY304 + QTY305 + QTY306 + QTY307 + QTY308 + QTY309 + QTY310 +
                                                                         QTY311 + QTY312 + QTY313 + QTY314 + QTY315 + QTY316 + QTY317 + QTY318 + QTY319 + QTY320 +
                                                                         QTY321 + QTY322 + QTY323 + QTY324 + QTY325 + QTY326 + QTY327 + QTY328 + QTY329 + QTY310 +
                                                                         QTY331 + QTY332 + QTY333 + QTY334 + QTY335 + QTY336 + QTY337 + QTY338 + QTY339 + QTY310 +
                                                                         QTY341 + QTY342 + QTY343 + QTY344 + QTY345 + QTY346 + QTY347 + QTY348 + QTY349 + QTY350 +
                                                                         QTY351 + QTY352 + QTY353 + QTY354 + QTY355 + QTY356 + QTY357 + QTY358 + QTY359 + QTY360 +
                                                                         QTY361 + QTY362 + QTY363 + QTY364
                                                                         ) DESC NULLS LAST
                                                                       , XLS_KEY1 DESC NULLS LAST
                                                           ) AS RN
                                       /* --                                 ,* */
                                    FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
                                   WHERE MEASURE              IN ('PACK_SHIP_PLAN')
                                     AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                                     AND PLAN_TYPE            = P_PLAN_TYPE
                                     AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
                                     AND SEQ                  = N_SEQ
                                ) IA
                          WHERE IA.RN > 1);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 033 ');

        /* ---- 중복 제거 WHERE MEASURE IN ('CELL_REQ','CELL_BALANCE','CELL_WHIN') */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
         WHERE ROWID IN (SELECT IA.RID
                           FROM ( SELECT ROWID AS RID
                                         /* --ROW_NUMBER() OVER (PARTITION BY DIVISION_ID,OPERATION_GROUP,CELL_ITEM_ID,ITEM_ID,TO_SITE,PROJECT_CODE,FROM_BOH_QTY,TO_BOH_QTY,INCOTERMS,FROM_SITE,TRANSPORT_MODE,PROD_LINE,MEASURE */
                                         /* --                                  ORDER BY CELL_ITEM_ID) AS ROWNUM */
                                       , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE, MEASURE
                                                                ORDER BY CELL_ITEM_ID, FN_ASIS_SORT_KEY(ATTRIBUTE1) NULLS FIRST) AS RN
                                    FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
                                   WHERE MEASURE              IN ('CELL_REQ', 'CELL_BALANCE', 'CELL_WHIN')
                                     AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                                     AND PLAN_TYPE            = P_PLAN_TYPE
                                     AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
                                     AND SEQ                  = N_SEQ
                                ) IA
                          WHERE IA.RN > 1);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 034 ');

        /* PACK 일 경우 'DM_MKT_FCST','SHIP_REQ','WHIN_TOTAL','SHIP_PLAN_TOTAL','INTRANSIT_TOTAL','BALANCE','BALANCE_CUM','TO_SITE_BOH','TO_SITE_EOH' 삭제 */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
         WHERE OPERATION_GROUP      = 'A'
           AND MEASURE              IN ('DM_MKT_FCST', 'SHIP_REQ', 'WHIN_TOTAL', 'SHIP_PLAN_TOTAL', 'INTRANSIT_TOTAL', 'BALANCE', 'BALANCE_CUM', 'TO_SITE_BOH', 'TO_SITE_EOH')
           AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
           AND PLAN_TYPE            = P_PLAN_TYPE
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
           AND SEQ                  = N_SEQ;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 035 ');

        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK
           SET TO_SITE             = '-'
             , TO_SITE_DESCRIPTION = '-'
             , PROJECT_CODE        = '-'
         /* --                SELECT DISTINCT CELL_ITEM_ID, ITEM_ID */
         WHERE MEASURE              IN ('CELL_PKG_PLAN_IN', 'CELL_PKG_PLAN_OUT', 'CELL_FORMATION', 'CELL_BOH', 'CELL_EOH')
           AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
           AND PLAN_TYPE            = P_PLAN_TYPE
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
           AND SEQ                  = N_SEQ;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 036 ');

        /* ---- 중복 제거 WHERE MEASURE IN  ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH') */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
         WHERE ROWID IN (SELECT IA.RID
                           FROM ( SELECT ROWID AS RID
                                         /* --ROW_NUMBER() OVER (PARTITION BY DIVISION_ID,OPERATION_GROUP,CELL_ITEM_ID,ITEM_ID,TO_SITE,PROJECT_CODE,FROM_BOH_QTY,TO_BOH_QTY,INCOTERMS,FROM_SITE,TRANSPORT_MODE,PROD_LINE,MEASURE */
                                         /* --                                  ORDER BY CELL_ITEM_ID) AS ROWNUM */
                                       , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE, MEASURE
                                                                ORDER BY CELL_ITEM_ID, XLS_KEY1 DESC NULLS LAST) AS RN
                                    FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
                                   WHERE MEASURE              IN ('CELL_PKG_PLAN_IN', 'CELL_PKG_PLAN_OUT', 'CELL_FORMATION', 'CELL_BOH', 'CELL_EOH')
                                     AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                                     AND PLAN_TYPE            = P_PLAN_TYPE
                                     AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
                                     AND SEQ                  = N_SEQ
                                ) IA
                          WHERE IA.RN > 1);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 037 ');

        /* 2022-03-31   KSW         OSP LT 적용 :: 생산계획의 LT 컬럼에 OSP LT 값을 표시하고 Pack Midel Inventory (EOH) 수식을 변경한다. (생산계획에 LT 적용) - start */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT DIVISION_ID
                     , SCM_SITE_ID
                     , ITEM_ID
                     , LT_DAY
                  FROM SCP_MST_OPERATION_LT
                 WHERE LT_OPERATION = 'OSP_LT'
              ) IA
           ON (     A.DIVISION_ID          = IA.DIVISION_ID
                AND A.FROM_SITE            = IA.SCM_SITE_ID
                AND A.ITEM_ID              = IA.ITEM_ID
                AND A.MEASURE              = 'PACK_PROD'
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.LT_DAY = IA.LT_DAY;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 038 ');

        /* 2022-03-31   KSW         OSP LT 적용 :: 생산계획의 LT 컬럼에 OSP LT 값을 표시하고 Pack Midel Inventory (EOH) 수식을 변경한다. (생산계획에 LT 적용) - end */

        /* 2022-07-01   KSW         PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용 :: 불필요한 measure 삭제 - start */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
         WHERE MEASURE              IN ('CELL_REQ', 'CELL_BALANCE', 'CELL_WHIN')
           AND OPERATION_GROUP      = 'A'
           AND NICK_NAME            LIKE '%ISUZU%'
           AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
           AND PLAN_TYPE            = P_PLAN_TYPE
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
           AND SEQ                  = N_SEQ;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 039 ');

        /* 2022-07-01   KSW         ISUZU 적용 :: 불필요한 measure 삭제 - end */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PACK_PROD_LOAD ISUZU 예외처리 - 2022.07.29 */
        /* LINE ID UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 원본 UPDATE .. FROM JOIN(자기 테이블) : PACK_PROD 행이 라인별로 여러 개면 MSSQL 은 임의 1건 → MAX 로 고정 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT DIVISION_ID
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , SEQ
                     , ITEM_ID
                     , FROM_SITE
                     , ATTRIBUTE9
                     , MAX(PROD_LINE) AS PROD_LINE
                  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
                 WHERE MEASURE    = 'PACK_PROD'
                   AND ATTRIBUTE9 = 'P5000'
                 GROUP BY DIVISION_ID
                        , PLAN_START_YYYYMMDD
                        , PLAN_TYPE
                        , SEQ
                        , ITEM_ID
                        , FROM_SITE
                        , ATTRIBUTE9
              ) IA
           ON (     A.DIVISION_ID          = IA.DIVISION_ID
                AND A.PLAN_START_YYYYMMDD  = IA.PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.PLAN_TYPE            = IA.PLAN_TYPE
                AND A.SEQ                  = IA.SEQ
                AND A.ITEM_ID              = IA.ITEM_ID
                AND A.FROM_SITE            = IA.FROM_SITE
                AND A.ATTRIBUTE9           = IA.ATTRIBUTE9
                AND A.MEASURE              = 'PACK_PROD_LOAD'
                AND A.ATTRIBUTE9           = 'P5000'
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD  /* -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가 */
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* -----------------------DHJ */
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.PROD_LINE = IA.PROD_LINE;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 040 ');

        /* ------------------------------------------------------------------------------------------------------------- start */
        /* 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: W-1 주차 PR 플랜에 대한 생산/출하 measure 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* W-1 주차 PR 플랜 measure 에 해당 주차의 월 1일 ~ 해당주차 시작전일 까지 실적 SUM 조회 (컬럼) */
        /* #tmp_PLAN_WEEK_FROM_TO → GT_XSPK_PLAN_WEEK_FROM_TO */
        DELETE
          FROM GT_XSPK_PLAN_WEEK_FROM_TO;

        /* ------------------------------------------------------------------------------------------------ */
        /* -----------------------------------------------------------------------------------------------DHJ */
        /* 수행된 이력에 대한 주차 구간 :: 당월 각 플랜이 실행된 주차의 시작일(월요일) ~ 마지막일(일요일) 의 실적 (당주 제외) */
        INSERT
          INTO GT_XSPK_PLAN_WEEK_FROM_TO
             ( PLAN_START_YYYYMMDD
             , PLAN_SEQ
             , START_YYYYMMDD
             , END_YYYYMMDD
             )
        SELECT IA.PLAN_START_YYYYMMDD
             , IA.PLAN_SEQ
             /* --					  ,(CASE WHEN LEFT(X.START_YYYYMMDD, 6) <> LEFT(@p_plan_start_yyyymmdd, 6) THEN LEFT(@p_plan_start_yyyymmdd, 6) + '01' */
             , CASE WHEN SUBSTR(IA.START_YYYYMMDD, 1, 6) <> SUBSTR(V_CREATE_FROM_YYYYMMDD, 1, 6) THEN SUBSTR(V_CREATE_FROM_YYYYMMDD, 1, 6) || '01'
                    ELSE IA.START_YYYYMMDD
               END AS START_YYYYMMDD
             , IA.END_YYYYMMDD
          FROM ( SELECT IB.PLAN_START_YYYYMMDD
                      , MIN(A.BASIS_YYYYMMDD) AS START_YYYYMMDD
                      , MAX(A.BASIS_YYYYMMDD) AS END_YYYYMMDD
                      , IB.PLAN_SEQ
                   FROM SCM_SYS_CALENDAR_M A
                      , ( SELECT B.PLAN_NAME       AS PLAN_START_YYYYMMDD
                               , B.PLAN_ID
                               , MAX(C.PLAN_SEQ)   AS PLAN_SEQ
                            FROM SCM_MST_PLAN B
                               , SCM_MST_PLAN_DETAIL C
                           WHERE B.DIVISION_ID = C.DIVISION_ID
                             AND B.PLAN_ID     = C.PLAN_ID
                             AND B.PLAN_CYCLE  = 'WEEKLY'
                             AND C.PLAN_TYPE   = 'FN'
                             AND B.DIVISION_ID = V_DIVISION_ID
                           GROUP BY B.PLAN_NAME
                                  , B.PLAN_ID
                        ) IB
                  WHERE A.BASIS_YYYYMMDD BETWEEN IB.PLAN_START_YYYYMMDD AND TO_CHAR(TO_DATE(IB.PLAN_START_YYYYMMDD, 'YYYYMMDD') + 6, 'YYYYMMDD')
                  GROUP BY IB.PLAN_START_YYYYMMDD
                         , IB.PLAN_SEQ
               ) IA
         WHERE SUBSTR(IA.END_YYYYMMDD, 1, 6) = SUBSTR(V_CREATE_FROM_YYYYMMDD, 1, 6)  /* 당월 1일 부터 포함하기 위한 조건 */
           AND IA.PLAN_START_YYYYMMDD        < V_CREATE_FROM_YYYYMMDD                 /* (당주 제외) */
           /*
         WHERE LEFT(X.END_YYYYMMDD, 6) = LEFT(@p_plan_start_yyyymmdd, 6)	-- 당월 1일 부터 포함하기 위한 조건
           AND X.PLAN_START_YYYYMMDD < @p_plan_start_yyyymmdd	-- (당주 제외)
           */
        ;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 041 ');

        /* ------------------------------------------------------------------------------------------------ */
        /* -----------------------------------------------------------------------------------------------DHJ */
        /* 출하계획 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT B.ITEM_ID
                     , B.FROM_SITE
                     , B.TO_SITE
                     , B.INCOTERMS
                     , B.PROJECT_CODE
                     , B.BOD_ID
                     , SUM(C.QTY) AS LAST_QTY
                  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK B
                     , SCP_ANL_SHIPMENT_PLAN_FG C
                     , GT_XSPK_PLAN_WEEK_FROM_TO D
                 WHERE B.DIVISION_ID          = C.DIVISION_ID
                   AND B.ITEM_ID              = C.ITEM_ID
                   AND B.TO_SITE              = C.TO_SITE
                   AND B.FROM_SITE            = C.FROM_SITE
                   AND B.INCOTERMS            = C.INCOTERMS
                   AND B.PROJECT_CODE         = C.PROJECT_CODE
                   AND B.BOD_ID               = C.BOD_ID
                   AND C.PLAN_START_YYYYMMDD  = D.PLAN_START_YYYYMMDD
                   AND C.SEQ                  = D.PLAN_SEQ
                   AND C.YYYYMMDD             BETWEEN D.START_YYYYMMDD AND D.END_YYYYMMDD
                   AND B.MEASURE              = 'PACK_SHIP_PLAN'
                   AND C.PLAN_TYPE            = 'FN'
                   AND C.MEASURE              = 'SHIP_PLAN_AMEND'
                   AND C.BIZ_TYPE             = 'P'
                   AND B.DIVISION_ID          = V_DIVISION_ID
                   AND B.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                   AND B.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                   AND B.PLAN_TYPE            = P_PLAN_TYPE
                   AND B.SEQ                  = N_SEQ
                 GROUP BY B.ITEM_ID
                        , B.FROM_SITE
                        , B.TO_SITE
                        , B.INCOTERMS
                        , B.PROJECT_CODE
                        , B.BOD_ID
              ) IA
           ON (     A.ITEM_ID              = IA.ITEM_ID
                AND A.FROM_SITE            = IA.FROM_SITE
                AND A.TO_SITE              = IA.TO_SITE
                AND A.INCOTERMS            = IA.INCOTERMS
                AND A.PROJECT_CODE         = IA.PROJECT_CODE
                AND A.BOD_ID               = IA.BOD_ID
                AND A.MEASURE              = 'PREV_PACK_SHIP_PLAN'
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.LAST_QTY = IA.LAST_QTY;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 042 ');

        /* 생산계획 */
        MERGE INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK A
        USING ( SELECT B.ITEM_ID
                     , B.FROM_SITE
                     , B.PROD_LINE
                     , SUM(C.QTY) AS LAST_QTY
                  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK B
                     , SCP_ANL_PRODUCTION_PLAN C
                     , GT_XSPK_PLAN_WEEK_FROM_TO D
                 WHERE B.DIVISION_ID          = C.DIVISION_ID
                   AND B.ITEM_ID              = C.ITEM_ID
                   AND B.FROM_SITE            = C.SCM_SITE_ID
                   AND B.PROD_LINE            = C.LINE_ID
                   AND C.PLAN_START_YYYYMMDD  = D.PLAN_START_YYYYMMDD
                   AND C.SEQ                  = D.PLAN_SEQ
                   AND C.YYYYMMDD             BETWEEN D.START_YYYYMMDD AND D.END_YYYYMMDD
                   AND B.MEASURE              = 'PACK_PROD'
                   AND C.PLAN_TYPE            = 'FN'
                   AND C.MEASURE              = 'PROD_PLAN_AMEND'
                   AND B.DIVISION_ID          = V_DIVISION_ID
                   AND B.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                   AND B.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                   AND B.PLAN_TYPE            = P_PLAN_TYPE
                   AND B.SEQ                  = N_SEQ
                 GROUP BY B.ITEM_ID
                        , B.FROM_SITE
                        , B.PROD_LINE
              ) IA
           ON (     A.ITEM_ID              = IA.ITEM_ID
                AND A.FROM_SITE            = IA.FROM_SITE
                AND A.PROD_LINE            = IA.PROD_LINE
                AND A.MEASURE              = 'PREV_PACK_PROD'
                AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
                AND A.PLAN_TYPE            = P_PLAN_TYPE
                AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* ---------DHJ */
                AND A.SEQ                  = N_SEQ )
         WHEN MATCHED THEN
       UPDATE
          SET A.LAST_QTY = IA.LAST_QTY;

        DBMS_OUTPUT.PUT_LINE('CREATE  PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S END');  /* print */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        LOG_STEP(' 043 ');

        /* ------------------------------------------------------------------------------------------------------------- end */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 임시 TEMP  테이블 DROP */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* GTT 는 지우지 않음(세션 GTT · 다음 실행 시작 때 DELETE) */

        /* ----------------------------------------------------------- */
        /* 실행 Logic END -- */
        /* ----------------------------------------------------------- */
        /* --IF @@TRANCOUNT > 0 */
        /* --  BEGIN */
        /* --    COMMIT TRAN T1; */
        /* --  END; */

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := 1;  /* @@ROWCOUNT : 바로 앞 SET @v_log_type = .. (단순 대입) 의 건수 1 — MSSQL 실측 */
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

    EXCEPTION  /* BEGIN CATCH */
        WHEN OTHERS THEN
            /* --IF @@TRANCOUNT > 0 */
            /* --  BEGIN */
            /* --    ROLLBACK TRAN T1 */
            /* --  END; */

            /* ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                                , P_LOG_TYPE      => V_LOG_TYPE
                                , P_LOG_COUNT     => N_LOG_COUNT
                                , P_LOG_MESSAGE   => V_LOG_MESSAGE
                                , P_DESCRIPTION   => V_DESCRIPTION
                                , P_EVENT_DATE    => D_EVENT_DATE
                                , P_USER_ID       => V_BATCH_USER
                                , P_IN_PARA_DATA  => SUBSTR('{"P_PLAN_START_YYYYMMDD":"' || P_PLAN_START_YYYYMMDD || '","P_DIVISION_ID":"' || P_DIVISION_ID || '","P_PLAN_TYPE":"' || P_PLAN_TYPE || '","P_SEQ":"' || P_SEQ || '","P_CREATE_FROM_YYYYMMDD":"' || P_CREATE_FROM_YYYYMMDD || '","P_CREATE_TO_YYYYMMDD":"' || P_CREATE_TO_YYYYMMDD || '"}', 1, 4000)
                                , P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
                                , P_SQL_ERR_MSG   => SUBSTR(SQLERRM, 1, 4000)
                                , P_SQL_BACKTRACE => SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000)
                                );
            /* --      PRINT @@ERROR */
            O_RETURN := -1;
            RETURN;  /* return -1 */
    END;  /* END CATCH; */

    IF P_IS_DEBUG = '1' THEN
        /* 원본 REPLICATE('0', 2 - LEN(x)) + x : x 가 3자리 이상이면 REPLICATE 가 NULL → 전체 NULL (CASE 로 재현) */
        V_EXEC_TIME := CASE WHEN TRUNC(TRUNC((SYSDATE - D_START_TIME) * 86400) / 60) > 99 THEN NULL
                            ELSE LPAD(TO_CHAR(TRUNC(TRUNC((SYSDATE - D_START_TIME) * 86400) / 60)), 2, '0')
                                 || ':' ||
                                 LPAD(TO_CHAR(MOD(TRUNC((SYSDATE - D_START_TIME) * 86400), 60)), 2, '0')
                       END;
    END IF;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    O_RETURN := 1;
    RETURN;  /* return 1 */
END;