PROCEDURE PR_SCP_XLS_ADD_XLSPSI06_S
(
      P_USER_ID                IN  VARCHAR2                     /* MSSQL @p_user_id               VARCHAR(100)  */
    , P_DIVISION_ID            IN  VARCHAR2                     /* MSSQL @p_division_id           NVARCHAR(030) */
    , P_PLAN_START_YYYYMMDD    IN  VARCHAR2                     /* MSSQL @p_plan_start_yyyymmdd   NVARCHAR(008) */
    , P_PLAN_TYPE              IN  VARCHAR2                     /* MSSQL @p_plan_type             NVARCHAR(050) */
    , P_SEQ                    IN  PLS_INTEGER
    , P_ITEM_ID                IN  VARCHAR2                     /* MSSQL @p_item_id               NVARCHAR(050) */
    , P_MEASURE                IN  VARCHAR2                     /* MSSQL @p_measure               NVARCHAR(050)  -- MEASURE별 */
    , P_DAY_WEEK_FLAG          IN  VARCHAR2                     /* MSSQL @p_day_week_flag         NVARCHAR(010)  -- (day,week) */
    , P_XLS_KEY1               IN  VARCHAR2                     /* MSSQL @p_xls_key1              NVARCHAR(200) */
    , P_CREATE_FROM_YYYYMMDD   IN  VARCHAR2                     /* MSSQL @p_create_from_yyyymmdd  NVARCHAR(008) */
    , P_CREATE_TO_YYYYMMDD     IN  VARCHAR2                     /* MSSQL @p_create_to_yyyymmdd    NVARCHAR(008) */
    , P_WQTY01 PLS_INTEGER DEFAULT 0 , P_WQTY02 PLS_INTEGER DEFAULT 0 , P_WQTY03 PLS_INTEGER DEFAULT 0 , P_WQTY04 PLS_INTEGER DEFAULT 0 , P_WQTY05 PLS_INTEGER DEFAULT 0
    , P_WQTY06 PLS_INTEGER DEFAULT 0 , P_WQTY07 PLS_INTEGER DEFAULT 0 , P_WQTY08 PLS_INTEGER DEFAULT 0 , P_WQTY09 PLS_INTEGER DEFAULT 0 , P_WQTY10 PLS_INTEGER DEFAULT 0
    , P_WQTY11 PLS_INTEGER DEFAULT 0 , P_WQTY12 PLS_INTEGER DEFAULT 0 , P_WQTY13 PLS_INTEGER DEFAULT 0 , P_WQTY14 PLS_INTEGER DEFAULT 0 , P_WQTY15 PLS_INTEGER DEFAULT 0
    , P_WQTY16 PLS_INTEGER DEFAULT 0 , P_WQTY17 PLS_INTEGER DEFAULT 0 , P_WQTY18 PLS_INTEGER DEFAULT 0 , P_WQTY19 PLS_INTEGER DEFAULT 0 , P_WQTY20 PLS_INTEGER DEFAULT 0
    , P_WQTY21 PLS_INTEGER DEFAULT 0 , P_WQTY22 PLS_INTEGER DEFAULT 0 , P_WQTY23 PLS_INTEGER DEFAULT 0 , P_WQTY24 PLS_INTEGER DEFAULT 0 , P_WQTY25 PLS_INTEGER DEFAULT 0
    , P_WQTY26 PLS_INTEGER DEFAULT 0 , P_WQTY27 PLS_INTEGER DEFAULT 0 , P_WQTY28 PLS_INTEGER DEFAULT 0 , P_WQTY29 PLS_INTEGER DEFAULT 0 , P_WQTY30 PLS_INTEGER DEFAULT 0
    , P_WQTY31 PLS_INTEGER DEFAULT 0 , P_WQTY32 PLS_INTEGER DEFAULT 0 , P_WQTY33 PLS_INTEGER DEFAULT 0 , P_WQTY34 PLS_INTEGER DEFAULT 0 , P_WQTY35 PLS_INTEGER DEFAULT 0
    , P_WQTY36 PLS_INTEGER DEFAULT 0 , P_WQTY37 PLS_INTEGER DEFAULT 0 , P_WQTY38 PLS_INTEGER DEFAULT 0 , P_WQTY39 PLS_INTEGER DEFAULT 0 , P_WQTY40 PLS_INTEGER DEFAULT 0
    , P_WQTY41 PLS_INTEGER DEFAULT 0 , P_WQTY42 PLS_INTEGER DEFAULT 0 , P_WQTY43 PLS_INTEGER DEFAULT 0 , P_WQTY44 PLS_INTEGER DEFAULT 0 , P_WQTY45 PLS_INTEGER DEFAULT 0
    , P_WQTY46 PLS_INTEGER DEFAULT 0 , P_WQTY47 PLS_INTEGER DEFAULT 0 , P_WQTY48 PLS_INTEGER DEFAULT 0 , P_WQTY49 PLS_INTEGER DEFAULT 0 , P_WQTY50 PLS_INTEGER DEFAULT 0
    , P_WQTY51 PLS_INTEGER DEFAULT 0 , P_WQTY52 PLS_INTEGER DEFAULT 0
    , O_RETURN_CODE          OUT NUMBER                     /* ★신설 : MSSQL 정수 반환값(return 1 / return -1)을 담는다.
                                                        XLSPSI 계열 반환코드 계약(사용자 결정 (a)안, 2026-08-07 확정).
                                                        부모 PR_SCP_XLS_ADD_XLSPSI06 이 이 값으로 IF V_ROWS < 0 게이트를 건다. */
)
/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI06_S
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      :
                 EXEC PR_SCP_XLS_ADD_XLSPSI06_S   @p_USER_ID             ='KTH'
                                                 ,@p_division_id         = '82'
                                                 ,@p_PLAN_START_YYYYMMDD = '2019128'
                                                 ,@p_PLAN_TYPE           ='PR'
                                                 ,@p_SEQ                 ='1'
                                                 ,@p_item_id             ='ACEN1063I-A3'
                                                 ,@p_measure             ='CELL_CHAR_PLAN'
                                                 ,@p_xls_key1            ='468'
                                                 ,@p_WQTY01 INT = 0.0  ,@p_WQTY02 INT = 0.0  ,@p_WQTY03 INT = 0.0  ,@p_WQTY04 INT = 0.0  ,@p_WQTY05 INT = 0.0
                                                 ,@p_WQTY06 INT = 0.0  ,@p_WQTY07 INT = 0.0  ,@p_WQTY08 INT = 0.0  ,@p_WQTY09 INT = 0.0  ,@p_WQTY10 INT = 0.0
                                                 ,@p_WQTY11 INT = 0.0  ,@p_WQTY12 INT = 0.0  ,@p_WQTY13 INT = 0.0  ,@p_WQTY14 INT = 0.0  ,@p_WQTY15 INT = 0.0
                                                 ,@p_WQTY16 INT = 0.0  ,@p_WQTY17 INT = 0.0  ,@p_WQTY18 INT = 0.0  ,@p_WQTY19 INT = 0.0  ,@p_WQTY20 INT = 0.0
                                                 ,@p_WQTY21 INT = 0.0  ,@p_WQTY22 INT = 0.0  ,@p_WQTY23 INT = 0.0  ,@p_WQTY24 INT = 0.0  ,@p_WQTY25 INT = 0.0
                                                 ,@p_WQTY26 INT = 0.0  ,@p_WQTY27 INT = 0.0  ,@p_WQTY28 INT = 0.0  ,@p_WQTY29 INT = 0.0  ,@p_WQTY30 INT = 0.0
                                                 ,@p_WQTY31 INT = 0.0  ,@p_WQTY32 INT = 0.0  ,@p_WQTY33 INT = 0.0  ,@p_WQTY34 INT = 0.0  ,@p_WQTY35 INT = 0.0
                                                 ,@p_WQTY36 INT = 0.0  ,@p_WQTY37 INT = 0.0  ,@p_WQTY38 INT = 0.0  ,@p_WQTY39 INT = 0.0  ,@p_WQTY40 INT = 0.0
                                                 ,@p_WQTY41 INT = 0.0  ,@p_WQTY42 INT = 0.0  ,@p_WQTY43 INT = 0.0  ,@p_WQTY44 INT = 0.0  ,@p_WQTY45 INT = 0.0
                                                 ,@p_WQTY46 INT = 0.0  ,@p_WQTY47 INT = 0.0  ,@p_WQTY48 INT = 0.0  ,@p_WQTY49 INT = 0.0  ,@p_WQTY50 INT = 0.0
                                                 ,@p_WQTY51 INT = 0.0  ,@p_WQTY52 INT = 0.0

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.06.27   KTH            Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2019.12.04   KTH            SHIP_PLAN 저장시 -9로 입력되는것은 0으로 처리 하는 로직 추가
 * 2020.01.09   KTH            저장로직 변경 : 모두 주 입력으로 변경
 * 2020.02.25   KTH            시물레이션 CELL,PACK 분리로 저장 프로시저 신규 생성
 * 2020.04.08   KTH            SCP_ANL_SHIPMENT_PLAN_FIX(FG) 변경조건 추가 (PROJECT_CODE)
 * 2021.03.17   KSW            temp table 일괄 drop 스크립트 추가
 * 2021.04.05   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ESS Pack 생산계획 (W/C) 적용
 * 2021.04.29   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ESS Pack 생산계획 (W/C) 적용 - 입력수량이 워킹타임 갯수보다 작을 경우 오류수정
 * 2021.06.08   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - 1 YEAR 단위로 저장
 * 2021.08.23   KSW            PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
 * 2021.10.07   KSW            Pack 생산계획 저장로직개선(튜닝)건 반영
 * 2021.10.19   KSW            CELL_PROD 는 PROD FROZEN 해제
 * 2021.10.25   KSW            튜닝개선요청에 따른 변경
 * 2022.08.17   KSW            중장기 버전 2 year 대응처리 - (중장기구간) 에 대한 XLS_KEY1 값 재확인
 * 2023.12.08   OIJ            전달 변수를 지역변수로 변경하여 사용하도록 수정, UPDATE->SELECT INTO형태로 변경, 코드 정리
 * 2025.05.15   KSK            완제품 및 반제품 출하계획의 확정구간 저장지원
 * 2025.09.03   KSK            E20250904-001373 ESS 시뮬레이터 저장시 특정숫자가 저장 안되는 이슈 보완
 * 2025.11.17   HRK               [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 계획 기준으로 JV 동기화 계획 반영
 *                                    1. 생산계획 : CELL_PROD (SCP_ANL_PRODUCTION_PLAN)
 *                                    2. SEMI 출하계획 : SEMI_SHIP_PLAN (SCP_ANL_SHIPMENT_PLAN_SEMI)
 *                                  - 2025.12.16 동기화 대상 데이터 from/to 사이트와 무관하게 origin from/to division_id 컬럼 division_id와 같은 값으로 저장(81_ST) : 김춘동 책임님
 *                                  - 2025.12.23 동기화 데이터 생성시 BOD_ID 매핑이 안되는 경우 ESS 가상 사이트 BOD_ID 유지
 * 2026.08.07   ZIONEX         [PJ202650304] NextSCM Migration
 *   - ★반환코드 : XLSPSI 계열 반환코드 계약(2026-08-07 사용자 결정 (a)안)에 따라 시그니처 마지막에
 *     O_RETURN_CODE OUT NUMBER 를 신설한다. 진입 직후 1 로 초기화하고 원본 return 지점마다 값을 덮어쓴다.
 *       · 원본 L151 (@v_batch_plan_type = 'FN' -> return -1) = ★정상 스킵(에러 아님)  -> O_RETURN_CODE := -1; RETURN;
 *       · 원본 L4504 (CATCH 안 return -1)      = 오류 경로               -> 로그 기록 후 O_RETURN_CODE := -1; RETURN;
 *       · 원본 L4526 (return 1)                = 정상 종료               -> O_RETURN_CODE := 1;  RETURN;
 *     원본 L154~L171 의 RETURN -1 블록은 MSSQL 에서 전부 주석 처리된 死코드라 주석 그대로 보존한다(활성화 금지).
 *   - 임시테이블 #temp 24종 -> GTT(GT_XPGT_*). DROP/CREATE 대신 각 사용 직전 DELETE 로 초기화한다.
 *       (원본 자식에도 #SCM_MST_SITE 의 CREATE/DROP 이 0건이고 활성 참조는 L3260 조인 하나뿐).
 *     CV-045(컬럼명 임의 변경 금지)를 우선해 인용식별자 "ROWNUM" 으로 보존하고 본문 참조도 전부 인용했다.
 *   - WITH (NOLOCK) / WITH (TABLOCK) 은 Oracle 다중버전 읽기일관성·잠금모델상 대응이 없어 전 구문에서 제거(H-13).
 *   - UPDATE .. FROM .. JOIN 은 원천 유일성이 보장되는 곳만 MERGE, 다중매치 가능성이 있는 곳은
 *     상관 UPDATE + EXISTS + ROWNUM = 1 로 옮겨 ORA-30926(비결정 갱신)을 원천 차단한다(CV-024).
 *   - MSSQL composable DML (INSERT .. SELECT FROM (MERGE .. OUTPUT $action) Changes WHERE Action=INSERT)
 *     은 Oracle 무대응이라 MERGE 직전에 NOT EXISTS 로 같은 집합을 뽑아 짝 행을 먼저 INSERT 한다(1:1 등가).
 */
AS
    /*  지역변수 선언 */
    V_BATCH_USER_ID                VARCHAR2(100 CHAR);      /* MSSQL @v_batch_user_id              VARCHAR(100) */
    V_BATCH_DIVISION_ID            VARCHAR2(30 CHAR);       /* MSSQL @v_batch_division_id          NVARCHAR(30) */
    V_BATCH_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR);        /* MSSQL @v_batch_plan_start_yyyymmdd  NVARCHAR(8)  */
    V_BATCH_PLAN_TYPE              VARCHAR2(50 CHAR);       /* MSSQL @v_batch_plan_type            NVARCHAR(50) */
    V_BATCH_SEQ                    NUMBER(19);              /* MSSQL @v_batch_seq                  BIGINT */
    V_BATCH_ITEM_ID                VARCHAR2(50 CHAR);
    V_BATCH_MEASURE                VARCHAR2(50 CHAR);       /* MSSQL @v_batch_measure              NVARCHAR(50) */
    V_BATCH_DAY_WEEK_FLAG          VARCHAR2(10 CHAR);       /* MSSQL @v_batch_day_week_flag        NVARCHAR(10) */
    V_BATCH_XLS_KEY1               NUMBER(10);              /* MSSQL @v_batch_xls_key1             INT */
    V_BATCH_CREATE_FROM_YYYYMMDD   VARCHAR2(8 CHAR);        /* MSSQL @v_batch_create_from_yyyymmdd NVARCHAR(8) */
    V_BATCH_CREATE_TO_YYYYMMDD     VARCHAR2(8 CHAR);
    /*  LOG 용 변수 설정 */
    V_BATCH_USER                   VARCHAR2(150 CHAR) := '';
    V_PROGRAM_NAME                 VARCHAR2(150 CHAR) := 'PR_SCP_XLS_ADD_XLSPSI06_S';
    V_LOG_TYPE                     VARCHAR2(30 CHAR);       /* START/END/ERROR/... */
    N_LOG_COUNT                    INTEGER := 0;
    V_LOG_MESSAGE                  VARCHAR2(1000 CHAR);
    V_DESCRIPTION                  VARCHAR2(500 CHAR);
    V_TABLE_ID                     VARCHAR2(150 CHAR) := 'SCP_XLS_PSI_GLOBAL_ESS';
    D_EVENT_DATE                   DATE;
    /*  임시 실행시간 확인용 */
    V_START_TIME                   DATE;
    V_EXEC_TIME                    VARCHAR2(10 CHAR);       /* '[00:00]'; */
    /*  저장할 요일 (월,화,수,목,금,토,일:2,3,4,5,6,7,1), 8이상은 일배분 */
    V_X_DAYOFWEEK_NO               PLS_INTEGER;
    V_P_TO_YYYYMMDD                VARCHAR2(8 CHAR);
    /*  XLS_KEY1 불일치 오류수정 - KSW 2022.08.18 */
    V_LINK_XLS_KEY1                VARCHAR2(200 CHAR);
    /*  BOD RANGE (PJ20209643 BOD L/T 2단계) */
    V_BOD_FROM                     VARCHAR2(20 CHAR);
    V_BOD_TO                       VARCHAR2(20 CHAR);
    /*  PACK_PROD Working Time 일배분용 */
    V_PROD_LINE                    VARCHAR2(12 CHAR);
    V_SCM_SITE                     VARCHAR2(20 CHAR);
    V_WKCNT                        PLS_INTEGER;
    /*  ↓ 원본 L490~494 의 활성 선언. 실제 사용처(WHILE 일배분 루프)는 2025.09.03 개선으로 전부 주석 처리되어 */
    V_LP                           PLS_INTEGER;
    V_DAYLP                        PLS_INTEGER;
    V_WEEKLP                       PLS_INTEGER;
    V_SQL                          CLOB;                    /* MSSQL @SQL NVARCHAR(MAX) */
    V_ADDDAY                       PLS_INTEGER;
    /*  SCP_ANL_SHIPMENT_PLAN_FG/SEMI · SCP_ANL_PRODUCTION_PLAN PK Parameter */
    V_X_ITEM_ID                    VARCHAR2(50 CHAR);
    V_X_OPERATION_GROUP            VARCHAR2(50 CHAR);       /* BIZ_TYPE */
    V_X_PROJECT_CODE               VARCHAR2(50 CHAR);
    V_X_TO_SITE                    VARCHAR2(50 CHAR);
    V_X_INCOTERMS                  VARCHAR2(50 CHAR);
    V_X_FROM_SITE                  VARCHAR2(50 CHAR);       /* SCM_SITE_ID */
    V_X_BOD_ID                     VARCHAR2(50 CHAR);
    V_X_LINE_ID                    VARCHAR2(50 CHAR);
    V_X_OPERATION_ID               VARCHAR2(50 CHAR);
    /*  LINE LOAD */
    V_LINE_ID                      VARCHAR2(100 CHAR);
    /*  동적 SQL 조립 버퍼. MSSQL NVARCHAR(MAX) 이고 실측 조립길이가 364컬럼 x 약 90자 = 33,000자를 넘어 */
    V_MQRY_SUM                     CLOB;
    V_MEXEC                        CLOB;
BEGIN

    O_RETURN_CODE := 1;


    /*        같은 폭의 SUBSTR 로 그 절단까지 1:1 재현한다. */
    V_BATCH_USER_ID              := SUBSTR(P_USER_ID, 1, 100);
    V_BATCH_DIVISION_ID          := SUBSTR(P_DIVISION_ID, 1, 30);
    V_BATCH_PLAN_START_YYYYMMDD  := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_BATCH_PLAN_TYPE            := SUBSTR(P_PLAN_TYPE, 1, 50);
    V_BATCH_SEQ                  := P_SEQ;
    V_BATCH_ITEM_ID              := SUBSTR(P_ITEM_ID, 1, 50);
    V_BATCH_MEASURE              := SUBSTR(P_MEASURE, 1, 50);
    V_BATCH_DAY_WEEK_FLAG        := SUBSTR(P_DAY_WEEK_FLAG, 1, 10);

    V_BATCH_XLS_KEY1             := TO_NUMBER(P_XLS_KEY1);
    V_BATCH_CREATE_FROM_YYYYMMDD := SUBSTR(P_CREATE_FROM_YYYYMMDD, 1, 8);
    V_BATCH_CREATE_TO_YYYYMMDD   := SUBSTR(P_CREATE_TO_YYYYMMDD, 1, 8);

    /*  LOG 용 변수 설정 */
    V_BATCH_USER      := V_BATCH_USER_ID;   /* MSSQL SET @v_batch_user = @p_user_id (NVARCHAR(150)) */

  /*  시작 LOG */
    V_LOG_TYPE        := 'START';
    V_LOG_MESSAGE     := '########## Start of procedure ##########';
    V_DESCRIPTION     := V_PROGRAM_NAME || ':' || ' SCP_XLS_PSI_GLOBAL_ESS SAVE LOGIC';
    D_EVENT_DATE      := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                        , P_LOG_TYPE      => V_LOG_TYPE
                        , P_LOG_COUNT     => N_LOG_COUNT
                        , P_LOG_MESSAGE   => V_LOG_MESSAGE
                        , P_DESCRIPTION   => V_DESCRIPTION
                        , P_EVENT_DATE    => D_EVENT_DATE
                        , P_USER_ID       => V_BATCH_USER
                        );


        /*  임시 실행시간 확인용 */
    V_START_TIME      := SYSDATE;
    V_EXEC_TIME       := '';

    /* PRINT @p_plan_type */
    /*  PLAN_TYPE이 FN일경우 수정금지 RETURN */
    IF V_BATCH_PLAN_TYPE = 'FN' THEN
        /*  MSSQL 원본 L151 : IF @v_batch_plan_type = 'FN' RETURN -1
            ★이 -1 은 에러가 아니라 '정상 스킵'이다(FN=Final Plan 은 수정 금지). 예외로 바꾸지 말 것. */
        O_RETURN_CODE := -1;
        RETURN;
    END IF;

    /* ---------------------------------------------------------------------------------------------
       원본 L154~L171 : 입력된 버전과 현재 버전이 다를 경우 RETURN 블록.
       ---------------------------------------------------------------------------------------------
           DECLARE   @v_division_id          NVARCHAR(030) = @v_batch_division_id
                   , @v_plan_start_yyyymmdd  NVARCHAR(008) = @v_batch_plan_start_yyyymmdd
                   , @v_plan_type            NVARCHAR(050) = @v_batch_plan_type
                   , @v_seq                  INT           = @v_batch_seq

           SELECT TOP 1  @v_division_id          = DIVISION_ID
                       , @v_plan_start_yyyymmdd  = PLAN_START_YYYYMMDD
                       , @v_plan_type            = PLAN_TYPE
                       , @v_seq                  = SEQ
             FROM SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)


         IF (@v_batch_division_id <> @v_division_id OR @v_batch_plan_start_yyyymmdd <> @v_plan_start_yyyymmdd OR @v_batch_plan_type <> @v_plan_type OR @v_batch_seq <> @v_seq)
           return -1
       --------------------------------------------------------------------------------------------- */

      /* PRINT @v_batch_plan_type */
    BEGIN
      BEGIN

            /* -------------------------------------------------------------------------------------------------------------------------------------------------------
            --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
            -------------------------------------------------------------------------------------------------------------------------------------------------------
            print  convert(varchar(30), getdate(), 121) + N' JV/ESS 라인 및 scm site 매핑 정보 추출'
            ------------------------------------------------------------------------------------------------------------------------------------------------------- */
            /*  IF OBJECT_ID('TEMPDB..#JV_ESS_LINE_MAP')     IS NOT NULL DROP TABLE #JV_ESS_LINE_MAP
                IF OBJECT_ID('TEMPDB..#JV_ESS_SCM_SITE_MAP') IS NOT NULL DROP TABLE #JV_ESS_SCM_SITE_MAP */
            DELETE FROM GT_XPGT_JV_ESS_LINE_MAP;


            INSERT INTO GT_XPGT_JV_ESS_LINE_MAP
                 ( VL_COMPANY_ID
                 , VL_DIVISION_ID
                 , VL_SITE_ID
                 , VL_PLANT_ID
                 , VL_FACTORY_ID
                 , VL_LINE_ID
                 , RL_COMPANY_ID
                 , RL_DIVISION_ID
                 , RL_SITE_ID
                 , RL_PLANT_ID
                 , RL_FACTORY_ID
                 , RL_LINE_ID )
            SELECT VL_COMPANY_ID
                 , VL_DIVISION_ID
                 , VL_SITE_ID
                 , VL_PLANT_ID
                 , VL_FACTORY_ID
                 , VL_LINE_ID
                 , RL_COMPANY_ID
                 , RL_DIVISION_ID
                 , RL_SITE_ID
                 , RL_PLANT_ID
                 , RL_FACTORY_ID
                 , RL_LINE_ID
              FROM TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP())
                 ;

            DELETE FROM GT_XPGT_JV_ESS_SCM_SITE_MAP;

            INSERT INTO GT_XPGT_JV_ESS_SCM_SITE_MAP
                 ( VP_COMPANY_ID
                 , VP_DIVISION_ID
                 , VP_SITE_ID
                 , VP_PLANT_ID
                 , VP_SCM_SITE_ID
                 , RP_COMPANY_ID
                 , RP_DIVISION_ID
                 , RP_SITE_ID
                 , RP_PLANT_ID
                 , RP_SCM_SITE_ID )
            SELECT VP_COMPANY_ID
                 , VP_DIVISION_ID
                 , VP_SITE_ID
                 , VP_PLANT_ID
                 , VP_SCM_SITE_ID
                 , RP_COMPANY_ID
                 , RP_DIVISION_ID
                 , RP_SITE_ID
                 , RP_PLANT_ID
                 , RP_SCM_SITE_ID
              FROM TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP())
                 ;
            /* ------------------------------------------------------------------------------------------------------------
            print  convert(varchar(30), getdate(), 121) + N' DIVISION 주차별 최종 수행 Plan 버전 정보 '
            -- ESS 가상 라인 매핑 JV division의 동기화 대상 버전 정보 확인을 위한 데이터
            -- Final Plan은 수정 대상에서 제외 ?
            ------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('TEMPDB..#DIVISION_LAST_PLAN_INFO') IS NOT NULL DROP TABLE #DIVISION_LAST_PLAN_INFO; */
            DELETE FROM GT_XPGT_DIVISION_LAST_PLAN_INFO;

            /*  MSSQL CONVERT(NVARCHAR(8), DATEADD(DAY, -20, GETDATE()), 112) -> TO_CHAR(SYSDATE - 20, 'YYYYMMDD') */
            INSERT INTO GT_XPGT_DIVISION_LAST_PLAN_INFO
                 ( DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , PLAN_SEQ
                 , HORIZON_END_DATE
                 , PLAN_STATUS
                 , INPUT_START_DATE
                 , RN )
            WITH SCP_PLAN_INFO AS (
                SELECT PD.DIVISION_ID
                     , PM.PLAN_NAME          AS PLAN_START_YYYYMMDD
                     , PD.PLAN_TYPE
                     , PD.PLAN_SEQ
                     , PM.HORIZON_END_DATE
                     , PD.PLAN_STATUS
                     , PD.INPUT_START_DATE
                     , ROW_NUMBER() OVER (PARTITION BY PD.DIVISION_ID
                                                     , PM.PLAN_NAME
                                             ORDER BY CASE WHEN PD.PLAN_TYPE = 'PR' THEN 4
                                                           WHEN PD.PLAN_TYPE = 'MA' THEN 3
                                                           WHEN PD.PLAN_TYPE = 'SE' THEN 2
                                                           WHEN PD.PLAN_TYPE = 'FN' THEN 1
                                                           ELSE 0
                                                      END
                                                    , PD.PLAN_SEQ DESC
                                                    , PD.INPUT_START_DATE DESC ) AS RN
                  FROM SCM_MST_PLAN PM
                       INNER JOIN SCM_MST_PLAN_DETAIL PD
                               ON PD.DIVISION_ID = PM.DIVISION_ID
                              AND PD.PLAN_ID     = PM.PLAN_ID
                              AND PD.PLAN_STATUS = 1
                       INNER JOIN SCM_MST_DIVISION DM
                               ON DM.DIVISION_ID = PM.DIVISION_ID
                              AND DM.ATTRIBUTE3 != 'EE'
                 WHERE 1 = 1
                   AND PM.PLAN_CYCLE = 'WEEKLY'
                   AND PM.PLAN_NAME >= TO_CHAR(SYSDATE - 20, 'YYYYMMDD')
            )
            SELECT DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , PLAN_SEQ
                 , HORIZON_END_DATE
                 , PLAN_STATUS
                 , INPUT_START_DATE
                 , RN
              FROM SCP_PLAN_INFO
             WHERE 1 = 1
               AND RN = 1
               AND PLAN_TYPE != 'FN'   /* Final plan 대상에서 제외 */
                 ;
            /* -------------------------------------------------------------------------------------------------------------------------------------------------------
            --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
            ------------------------------------------------------------------------------------------------------------------------------------------------------- */

            /* ------------------------------------------------------------------------------------------- */
            /*  SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE  ='DAYOFWEEK_NO' */
            /*  저장할 요일 (월,화,수,목,금,토,일:2,3,4,5,6,7,1), 8이상은 일배분 */
            /* ------------------------------------------------------------------------------------------- */
            V_X_DAYOFWEEK_NO := 8;   /* (1~7) 8은 일별배분 (월,화,수,목,금,토,일:2,3,4,5,6,7,1) */

            /* SELECT SEGMENT1, SEGMENT2,DESCRIPTION */
            /*  MSSQL SELECT TOP 1 @x_DAYOFWEEK_NO = ISNULL(SEGMENT2,8) : 0행이면 기존값 8 유지 -> 커서 FOR 루프 */
            FOR R IN ( SELECT NVL(SEGMENT2, '8') AS SEGMENT2
                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE  = 'SHIP_PLAN_SAVE_WEEK'   /* 'DAYOFWEEK_NO' */
                          AND SEGMENT1     = V_BATCH_DIVISION_ID           /* DIVISION_ID */
                          AND VALID_YN     = 'Y'
                          AND ROWNUM       = 1
                     )
            LOOP
                /*  MSSQL 은 nvarchar SEGMENT2 를 INT 변수에 대입하며 암묵 형변환한다 -> TO_NUMBER 로 명시 */
                V_X_DAYOFWEEK_NO := TO_NUMBER(R.SEGMENT2);
            END LOOP;

               /*  선택된 항목만 주로 변경해야 하기 때문에 반영하지 않도록 수정 2019.05.07 */
               /* SET @x_DAYOFWEEK_NO = '8' */

            /*  MSSQL DECLARE @p_to_yyyymmdd VARCHAR(8) = @v_batch_create_to_yyyymmdd;
                --CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112) */
            V_P_TO_YYYYMMDD := V_BATCH_CREATE_TO_YYYYMMDD;

            /*  XLS_KEY1 불일치 오류수정 - KSW 2022.08.18 - start */
            /*  30 주 (중장기구간) 에 대한 XLS_KEY1 값 재확인 */
            IF ( V_BATCH_PLAN_START_YYYYMMDD <> V_BATCH_CREATE_FROM_YYYYMMDD ) THEN

                V_LINK_XLS_KEY1 := '';

                /*  MSSQL 대입형 SELECT (ORDER BY 없음) : 0행이면 변수 기존값 유지, 다행이면 마지막 행이 남는다
                    -> SELECT INTO(ORA-01403/01422) 가 아니라 커서 FOR 루프로 1:1 재현. 원본에 없는 ORDER BY 추가 금지. */
                FOR R IN ( SELECT Y.XLS_KEY1
                             FROM ( SELECT *
                                      FROM SCP_XLS_PSI_GLOBAL_ESS
                                     WHERE PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                                       AND PLAN_TYPE            = V_BATCH_PLAN_TYPE
                                       AND SEQ                  = V_BATCH_SEQ
                                       AND CREATE_FROM_YYYYMMDD = V_BATCH_PLAN_START_YYYYMMDD
                                       AND DIVISION_ID          = V_BATCH_DIVISION_ID
                                       AND XLS_KEY1             = V_BATCH_XLS_KEY1
                                  ) X
                                , SCP_XLS_PSI_GLOBAL_ESS Y
                            WHERE Y.PLAN_START_YYYYMMDD  = X.PLAN_START_YYYYMMDD
                              AND Y.PLAN_TYPE            = X.PLAN_TYPE
                              AND Y.SEQ                  = X.SEQ
                              AND Y.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                              AND Y.DIVISION_ID          = X.DIVISION_ID
                              AND Y.OPERATION_GROUP      = X.OPERATION_GROUP
                              AND Y.CELL_ITEM_ID         = X.CELL_ITEM_ID
                              AND Y.ITEM_ID              = X.ITEM_ID
                              AND Y.TO_SITE              = X.TO_SITE
                              AND Y.PROJECT_CODE         = X.PROJECT_CODE
                              AND Y.INCOTERMS            = X.INCOTERMS
                              AND Y.FROM_SITE            = X.FROM_SITE
                              AND Y.TRANSPORT_MODE       = X.TRANSPORT_MODE
                              AND Y.PROD_LINE            = X.PROD_LINE
                              AND Y.BOD_ID               = X.BOD_ID
                              AND Y.MEASURE              = X.MEASURE
                         )
                LOOP
                    V_LINK_XLS_KEY1 := R.XLS_KEY1;
                END LOOP;


                V_BATCH_XLS_KEY1 := CASE WHEN V_LINK_XLS_KEY1 IS NULL THEN 0 ELSE TO_NUMBER(V_LINK_XLS_KEY1) END;
            END IF;
            /*  XLS_KEY1 불일치 오류수정 - KSW 2022.08.18 - end */

            /* ------------------------------------------------------------------------------------------- */
            /*  수정하기전의 테이블에 존재하는 데이타를 가져와서 임시 테이블에 담아둔다. */
            /* ------------------------------------------------------------------------------------------- */
            /*  SOURCE에 반영될 테이블 #DAY_SCP_XLS_PSI_GLOBAL */
            /*  IF OBJECT_ID('tempdb..#DAY_SCP_XLS_PSI_GLOBAL_TEMP') IS NOT NULL DROP TABLE #DAY_SCP_XLS_PSI_GLOBAL_TEMP */
            DELETE FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL_TEMP;

            /*  SELECT * INTO -> GTT 는 SCP_XLS_PSI_GLOBAL_ESS 와 컬럼명/순서/타입이 동일하게 선언되어 있다(CTAS 도출). */
            INSERT INTO GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL_TEMP
            SELECT *
              FROM SCP_XLS_PSI_GLOBAL_ESS
             WHERE 0 = 0
               AND DIVISION_ID          = V_BATCH_DIVISION_ID
               AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
               AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
               AND SEQ                  = V_BATCH_SEQ
               AND XLS_KEY1             = V_BATCH_XLS_KEY1
                 ;

            /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start */
            /*  BOD RANGE */
            /*  MSSQL SELECT @v_bod_from = .. , @v_bod_to = .. FROM #DAY_SCP_XLS_PSI_GLOBAL_TEMP (WHERE 없음) */
            V_BOD_FROM := '';
            V_BOD_TO   := '';

            FOR R IN ( SELECT (CASE WHEN ATTRIBUTE3 IS NULL THEN '19900101'
                                    ELSE SUBSTR(ATTRIBUTE3, 1, 8) END) AS BOD_FROM
                            , (CASE WHEN ATTRIBUTE3 IS NULL THEN '29991231'
                                    ELSE SUBSTR(ATTRIBUTE3, GREATEST(LENGTH(ATTRIBUTE3) - 7, 1)) END) AS BOD_TO
                         FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL_TEMP )
            LOOP
                V_BOD_FROM := R.BOD_FROM;
                V_BOD_TO   := R.BOD_TO;
            END LOOP;
            /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end */

            /*  SCP_XLS_PSI_GLOBAL_ESS에 반영될 테이블 #SCP_XLS_PSI_GLOBAL_ESS_ORG */
            /*  IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ESS_ORG') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS_ORG */
            DELETE FROM GT_XPGT_SCP_XLS_PSI_GLOBAL_ESS_ORG;

            INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_ESS_ORG
            SELECT *
              FROM SCP_XLS_PSI_GLOBAL_ESS
             WHERE 0 = 0
               AND DIVISION_ID          = V_BATCH_DIVISION_ID
               AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
               AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
               AND SEQ                  = V_BATCH_SEQ
               AND XLS_KEY1             = V_BATCH_XLS_KEY1
                 ;

            /* -------------------------------------------------------------------------------------------
               SCP_XLS_PSI_GLOBAL_ESS (XLSPSI06) 화면조회용 테이블에 해당 레코드를 수정한다.
               -------------------------------------------------------------------------------------------
                CELL_PROD,PACK_PROD         --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND'
                SEMI_SHIP_PLAN, SHIP_PLAN   --> SHIP_PLAN_AMEND
               -------------------------------------------------------------------------------------------
               WEEK DATA를 DAY DATA로 반영
               확정 구간이 주에 포함될 경우 수정금지 구간을 제외하고, 일 배분해야 함.
               ------------------------------------------------------------------------------------------- */

            /*  PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ESS Pack 생산계획 (W/C) 적용 - start */
            /*  PACK_PROD 만 적용 */
            IF V_BATCH_MEASURE IN ('PACK_PROD') THEN

                IF V_BATCH_DAY_WEEK_FLAG = 'week' THEN
                    /* -------------------------------- */
                    /*  Working Time 에 따른 daily 분배 */
                    /* -------------------------------- */
                    V_PROD_LINE := '';
                    V_SCM_SITE  := '';
                    V_WKCNT     := 0;

                    /*  라인정보 조회 */
                    /*  MSSQL 대입형 SELECT : 0행이면 변수 기존값 유지, 다행이면 마지막 행이 남는다 -> 커서 FOR 루프 */
                    FOR R IN ( SELECT PROD_LINE
                                    , FROM_SITE
                                 FROM SCP_XLS_PSI_GLOBAL_ESS
                                WHERE 0 = 0
                                  AND DIVISION_ID          = V_BATCH_DIVISION_ID
                                  AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                                  AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                                  AND SEQ                  = V_BATCH_SEQ
                                  AND XLS_KEY1             = V_BATCH_XLS_KEY1
                             )
                    LOOP
                        V_PROD_LINE := R.PROD_LINE;
                        V_SCM_SITE  := R.FROM_SITE;
                    END LOOP;

                    /* select @v_prod_line, @v_scm_site; */
                    /* PRINT 'start. '+CONVERT(CHAR(23), GETDATE(), 21); */

                    /*  Working Time 정보 가져오기 :: 364일 */
                    /*  IF OBJECT_ID('tempdb..#WORKING_TBL_TEMP') IS NOT NULL DROP TABLE #WORKING_TBL_TEMP
                        CREATE TABLE #WORKING_TBL_TEMP ( ROWNUM INT, XLS_KEY INT, YYYYMMDD NVARCHAR(010), WORKING_TIME NUMERIC(20,10), QTY NUMERIC(20,10) );
                        ★컬럼명 ROWNUM 은 Oracle 의사컬럼과 충돌하므로 인용식별자 "ROWNUM" 으로 보존한다. */
                    DELETE FROM GT_XPGT_WORKING_TBL_TEMP;

                    /*  IF OBJECT_ID('tempdb..#WORKING_TBL') IS NOT NULL DROP TABLE #WORKING_TBL */
                    DELETE FROM GT_XPGT_WORKING_TBL;

                    /*                                              CREATE TABLE #WORKING_TBL (
                                                   ROWNUM INT, XLS_KEY NVARCHAR(012), YYYYMMDD NVARCHAR(010), WORKING_TIME NUMERIC(20,10), QTY NUMERIC(20,10)
                                              );

                                            Pack 생산계획 저장로직개선(튜닝)건 반영 -- start

                                            변경전


                                           INSERT INTO #WORKING_TBL
                                           SELECT  ROW_NUMBER() OVER(ORDER BY YYYYMMDD) AS ROWNUM
                                                   , @p_xls_key1
                                                   , X.YYYYMMDD
                                                   , X.WORKING_TIME
                                                   , 0.0            AS QTY
                                               FROM (
                                           SELECT  A.DIVISION_ID
                                                   , A.OPERATION_ID
                                                   , A.LINE_ID
                                                   , C.YYYYMMDD
                                                   , A.WORKING_TIME
                                               FROM (SELECT BASIS_YYYYMMDD AS YYYYMMDD, 0 As WORKING_TIME FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD BETWEEN @v_batch_create_from_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)) C
                                               LEFT OUTER JOIN
                                                   (SELECT    DIVISION_ID
                                                           , PLANT_SITE_ID
                                                           , OPERATION_ID
                                                           , LINE_ID
                                                           , YYYYMMDD
                                                           , WORKING_TIME
                                                   from dbo.FN_LINE_WORKINGTIME_BY_LOSS(@v_batch_division_id, @v_batch_create_from_yyyymmdd, CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112), @v_prod_line )
                                                   WHERE PLANT_SITE_ID = @v_scm_site
                                                       AND LINE_ID <> '-') A
                                               ON C.YYYYMMDD = A.YYYYMMDD
                                               WHERE 1 = 1
                                           ) X
                                           order by X.YYYYMMDD
                                           ; */

                    /*  MSSQL CONVERT(VARCHAR(8), DATEADD(day, n, @v_batch_create_from_yyyymmdd), 112)
                        -> TO_CHAR(TO_DATE(x, 'YYYYMMDD') + n, 'YYYYMMDD') */
                    INSERT INTO GT_XPGT_WORKING_TBL_TEMP
                         ( "ROWNUM"
                         , XLS_KEY
                         , YYYYMMDD
                         , WORKING_TIME
                         , QTY )
                    SELECT ROW_NUMBER() OVER(ORDER BY X.YYYYMMDD) AS RN
                         , V_BATCH_XLS_KEY1
                         , X.YYYYMMDD
                         , X.WORKING_TIME
                         , 0.0            AS QTY
                      FROM ( SELECT A.DIVISION_ID
                                  , A.OPERATION_ID
                                  , A.LINE_ID
                                  , C.YYYYMMDD
                                  , A.WORKING_TIME
                               FROM ( SELECT BASIS_YYYYMMDD AS YYYYMMDD, 0 AS WORKING_TIME
                                        FROM SCM_SYS_CALENDAR_M
                                       WHERE BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                                AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD') ) C
                                  , ( SELECT DIVISION_ID
                                           , PLANT_SITE_ID
                                           , OPERATION_ID
                                           , LINE_ID
                                           , YYYYMMDD
                                           , WORKING_TIME
                                        FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS(V_BATCH_DIVISION_ID
                                                                             , V_BATCH_CREATE_FROM_YYYYMMDD
                                                                             , TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD')
                                                                             , V_PROD_LINE))
                                       WHERE PLANT_SITE_ID = V_SCM_SITE
                                         AND LINE_ID <> '-' ) A
                              WHERE 1 = 1
                                AND C.YYYYMMDD = A.YYYYMMDD(+)
                           ) X
                     ORDER BY X.YYYYMMDD
                         ;

                    /* select * from #WORKING_TBL */
                    V_LP     := 1;
                    V_DAYLP  := 1;
                    V_WEEKLP := 1;
                    V_ADDDAY := 0;

                    /*  입력된 Week 수량을 Daily로 분배하기 위한 처리 */
                    /*  IF OBJECT_ID('tempdb..#WEEK_QTY_TBL') IS NOT NULL DROP TABLE #WEEK_QTY_TBL
                        CREATE TABLE #WEEK_QTY_TBL ( WQTY01 INT , .. , WQTY52 INT ); */
                    DELETE FROM GT_XPGT_WEEK_QTY_TBL;

                    INSERT INTO GT_XPGT_WEEK_QTY_TBL
                         ( WQTY01, WQTY02, WQTY03, WQTY04, WQTY05
                         , WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                         , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15
                         , WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                         , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25
                         , WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                         , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35
                         , WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                         , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45
                         , WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                         , WQTY51, WQTY52
                         )
                    SELECT P_WQTY01, P_WQTY02, P_WQTY03, P_WQTY04, P_WQTY05
                         , P_WQTY06, P_WQTY07, P_WQTY08, P_WQTY09, P_WQTY10
                         , P_WQTY11, P_WQTY12, P_WQTY13, P_WQTY14, P_WQTY15
                         , P_WQTY16, P_WQTY17, P_WQTY18, P_WQTY19, P_WQTY20
                         , P_WQTY21, P_WQTY22, P_WQTY23, P_WQTY24, P_WQTY25
                         , P_WQTY26, P_WQTY27, P_WQTY28, P_WQTY29, P_WQTY30
                         , P_WQTY31, P_WQTY32, P_WQTY33, P_WQTY34, P_WQTY35
                         , P_WQTY36, P_WQTY37, P_WQTY38, P_WQTY39, P_WQTY40
                         , P_WQTY41, P_WQTY42, P_WQTY43, P_WQTY44, P_WQTY45
                         , P_WQTY46, P_WQTY47, P_WQTY48, P_WQTY49, P_WQTY50
                         , P_WQTY51, P_WQTY52
                      FROM DUAL   /*  MSSQL FROM 없는 스칼라 SELECT -> Oracle 은 FROM DUAL 필수(LS-014) */
                         ;

                /* START    E20250904-001373 ESS 시뮬레이터 저장시 특정숫자가 저장 안되는 이슈 보완(후순균등배분식) */
                    /*  MSSQL ;WITH SE1 AS (..) , se2 as (..) SELECT .. INTO #WORKING_TBL
                        -> Oracle 은 INSERT INTO <GTT> WITH .. SELECT 형태로 옮긴다.
                          (Oracle / 는 실수나눗셈이라 그대로 두면 WEEKNO 가 1.14 같은 값이 되어 주차가 깨진다).
                        ★MSSQL RIGHT('0'+CONVERT(VARCHAR, n), 2) -> LPAD(TO_CHAR(n), 2, '0') (CV-067). */
                    INSERT INTO GT_XPGT_WORKING_TBL
                         ( "ROWNUM"
                         , XLS_KEY
                         , YYYYMMDD
                         , WORKING_TIME
                         , RNO
                         , STEP1_QTY
                         , WEEKSUM
                         , CNT
                         , WEEKNO
                         , QTY )
                    WITH SE1 AS (
                        SELECT A."ROWNUM", A.XLS_KEY, A.YYYYMMDD, A.WORKING_TIME, A.WEEKNO, B.ITEM, B.CNT, R.WORKING_DAY
                             /*  E20250904-001373 반올림 대신에 최소일분배를 위해 FLOOR 적용 */
                             , CASE WHEN R.WORKING_DAY <= B.CNT THEN FLOOR(A.WORKING_TIME / R.WEEK_WORKING_TIME * B.CNT) ELSE 0.0 END AS STEP1_QTY
                          FROM
                             (
                              SELECT T."ROWNUM", T.XLS_KEY, T.YYYYMMDD, T.WORKING_TIME, T.QTY
                                   , TRUNC((T."ROWNUM" - 1) / 7) + 1 AS WEEKNO
                                   , 'WQTY' || LPAD(TO_CHAR(TRUNC((T."ROWNUM" - 1) / 7) + 1), 2, '0') AS ITEM
                                FROM GT_XPGT_WORKING_TBL_TEMP T
                             ) A
                             LEFT JOIN
                             (
                              SELECT TRUNC(("ROWNUM" - 1) / 7) + 1 AS WEEKNO
                                   , COUNT(WORKING_TIME) AS WORKING_DAY
                                   , CASE WHEN SUM(WORKING_TIME) = 0 THEN 1 ELSE SUM(WORKING_TIME) END AS WEEK_WORKING_TIME
                                FROM GT_XPGT_WORKING_TBL_TEMP
                               WHERE WORKING_TIME > 0
                               GROUP BY TRUNC(("ROWNUM" - 1) / 7) + 1
                             ) R
                               ON A.WEEKNO = R.WEEKNO
                             LEFT JOIN
                             (
                              SELECT ITEM, CNT
                                FROM GT_XPGT_WEEK_QTY_TBL
                               UNPIVOT ( CNT FOR ITEM IN (
                                            WQTY01 AS 'WQTY01', WQTY02 AS 'WQTY02', WQTY03 AS 'WQTY03', WQTY04 AS 'WQTY04', WQTY05 AS 'WQTY05'
                                          , WQTY06 AS 'WQTY06', WQTY07 AS 'WQTY07', WQTY08 AS 'WQTY08', WQTY09 AS 'WQTY09', WQTY10 AS 'WQTY10'
                                          , WQTY11 AS 'WQTY11', WQTY12 AS 'WQTY12', WQTY13 AS 'WQTY13', WQTY14 AS 'WQTY14', WQTY15 AS 'WQTY15'
                                          , WQTY16 AS 'WQTY16', WQTY17 AS 'WQTY17', WQTY18 AS 'WQTY18', WQTY19 AS 'WQTY19', WQTY20 AS 'WQTY20'
                                          , WQTY21 AS 'WQTY21', WQTY22 AS 'WQTY22', WQTY23 AS 'WQTY23', WQTY24 AS 'WQTY24', WQTY25 AS 'WQTY25'
                                          , WQTY26 AS 'WQTY26', WQTY27 AS 'WQTY27', WQTY28 AS 'WQTY28', WQTY29 AS 'WQTY29', WQTY30 AS 'WQTY30'
                                          , WQTY31 AS 'WQTY31', WQTY32 AS 'WQTY32', WQTY33 AS 'WQTY33', WQTY34 AS 'WQTY34', WQTY35 AS 'WQTY35'
                                          , WQTY36 AS 'WQTY36', WQTY37 AS 'WQTY37', WQTY38 AS 'WQTY38', WQTY39 AS 'WQTY39', WQTY40 AS 'WQTY40'
                                          , WQTY41 AS 'WQTY41', WQTY42 AS 'WQTY42', WQTY43 AS 'WQTY43', WQTY44 AS 'WQTY44', WQTY45 AS 'WQTY45'
                                          , WQTY46 AS 'WQTY46', WQTY47 AS 'WQTY47', WQTY48 AS 'WQTY48', WQTY49 AS 'WQTY49', WQTY50 AS 'WQTY50'
                                          , WQTY51 AS 'WQTY51', WQTY52 AS 'WQTY52'
                                                        ) ) UN
                             ) B
                               ON A.ITEM = B.ITEM

                    )

                  , SE2 AS ( SELECT SE1.*
                                     /*  E20250904-001373 훈순위로 일분배를 위해 주차별 역순위 필드추가 */
                                  , ROW_NUMBER() OVER( PARTITION BY WEEKNO, CASE WHEN WORKING_TIME > 0 THEN 1 ELSE 0 END
                                                           ORDER BY "ROWNUM" DESC) AS RNO
                               FROM SE1 )
                    SELECT A."ROWNUM", A.XLS_KEY, A.YYYYMMDD, A.WORKING_TIME, A.RNO, A.STEP1_QTY, C.WEEKSUM, A.CNT, A.WEEKNO
                         /*  E20250904-001373 최소분배로 일분배한 후에, 해당합계가 사용자가 입력한 값(주간수량) 보다 작을 때 */
                         , CASE WHEN C.WEEKSUM <= A.CNT THEN
                                     CASE WHEN C.WEEKSUM + A.RNO <= A.CNT AND A.WORKING_TIME > 0 THEN
                                               /*  E20250904-001373 남는 수량은 순서대로 추가배분(1개) */
                                               A.STEP1_QTY + 1
                                          ELSE A.STEP1_QTY END
                                ELSE
                                     CASE WHEN C.WEEKSUM = 0 AND C.MINDAY = A."ROWNUM" THEN A.CNT ELSE A.STEP1_QTY END
                           END AS QTY
                      FROM SE2 A
                           LEFT JOIN ( SELECT WEEKNO, MIN("ROWNUM") AS MINDAY
                                            , SUM(STEP1_QTY) AS WEEKSUM
                                         FROM SE1 WHERE WORKING_TIME > 0
                                        GROUP BY WEEKNO ) C
                             ON A.WEEKNO = C.WEEKNO ;
            /*  END -- E20250904-001373 ESS 시뮬레이터 저장시 특정숫자가 저장 안되는 이슈 보완 */

                    /*                                           WHILE (@v_lp < 365)
                                           BEGIN

                                               -- 당주 Working Time 이 있는 첫째요일
                                               SET @v_addday = 0;
                                               SELECT @v_addday = MIN(ROWNUM) FROM #WORKING_TBL WHERE ROWNUM BETWEEN @v_lp AND @v_lp + 6 AND WORKING_TIME > 0;

                                               --select @v_addday;

                                               -- 수량 분배 및 차이값 처리
                                               SET @v_daylp = @v_lp;

                                               WHILE (@v_daylp < @v_lp + 7)
                                               BEGIN

                                                   -- 2021.04.29   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ESS Pack 생산계획 (W/C) 적용 - 입력수량이 워킹타임 갯수보다 작을 경우 오류수정 - start
                                                   SELECT @v_wkcnt = COUNT(WORKING_TIME)
                                                     FROM #WORKING_TBL
                                                    WHERE ROWNUM BETWEEN CONVERT(VARCHAR, @v_lp) AND CONVERT(VARCHAR, @v_lp) + 6
                                                      AND WORKING_TIME > 0
                                                   ;
                                                   -- 2021.04.29   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ESS Pack 생산계획 (W/C) 적용 - 입력수량이 워킹타임 갯수보다 작을 경우 오류수정 - end

                                                   SET @SQL = '';
                                                   SET @SQL = 'UPDATE #WORKING_TBL ';
                                                   SET @SQL = @SQL + '   SET QTY = (CASE WHEN ' + CONVERT(VARCHAR, @v_wkcnt) + ' <= (SELECT WQTY' + RIGHT('0' + CONVERT(VARCHAR, @v_weeklp), 2) + ' FROM #WEEK_QTY_TBL) THEN ';
                                                   SET @SQL = @SQL + '                        (SELECT ROUND((SELECT WORKING_TIME ';
                                                   SET @SQL = @SQL + '                                         FROM #WORKING_TBL ';
                                                   SET @SQL = @SQL + '                                        WHERE ROWNUM = ' + CONVERT(VARCHAR, @v_daylp) + ') / (CASE WHEN SUM(WORKING_TIME) = 0 THEN 1 ';
                                                   SET @SQL = @SQL + '                                                                                                   ELSE SUM(WORKING_TIME) END) * (SELECT WQTY' + RIGHT('0' + CONVERT(VARCHAR, @v_weeklp), 2) + ' FROM #WEEK_QTY_TBL), 0) ';
                                                   SET @SQL = @SQL + '                           FROM #WORKING_TBL WHERE ROWNUM BETWEEN ' + CONVERT(VARCHAR, @v_lp) + ' AND ' + CONVERT(VARCHAR, @v_lp) + ' + 6 )';
                                                   SET @SQL = @SQL + '              ELSE 0 END)';
                                                   SET @SQL = @SQL + ' WHERE ROWNUM = ' + CONVERT(VARCHAR, @v_daylp) ;

                                                   --print @SQL;

                                                   EXEC(@SQL);

                                                   -- 차이값 처리
                                                   SET @SQL = 'UPDATE #WORKING_TBL ';
                                                   SET @SQL = @SQL + '   SET QTY = (CASE WHEN QTY + ((SELECT WQTY' + RIGHT('0' + CONVERT(VARCHAR, @v_weeklp), 2) + ' FROM #WEEK_QTY_TBL) - (SELECT SUM(QTY) FROM #WORKING_TBL WHERE ROWNUM BETWEEN ' + CONVERT(VARCHAR, @v_lp) + ' AND ' + CONVERT(VARCHAR, @v_lp) + ' + 6 )) < 0 THEN 0';
                                                   SET @SQL = @SQL + '                   ELSE QTY + ((SELECT WQTY' + RIGHT('0' + CONVERT(VARCHAR, @v_weeklp), 2) + ' FROM #WEEK_QTY_TBL) - (SELECT SUM(QTY) FROM #WORKING_TBL WHERE ROWNUM BETWEEN ' + CONVERT(VARCHAR, @v_lp) + ' AND ' + CONVERT(VARCHAR, @v_lp) + ' + 6 )) END)';
                                                   SET @SQL = @SQL + ' WHERE ROWNUM = ' + CONVERT(VARCHAR, @v_addday) ;
                                                   EXEC(@SQL);
                                                   print @SQL;
                                                   SET @v_daylp = @v_daylp + 1
                                               END;

                                               -- Next Week
                                               SET @v_lp     = @v_lp + 7;
                                               SET @v_weeklp = @v_weeklp + 1

                                               --SET @v_lp = 366;
                                           END;


                                           PRINT 'end. '+CONVERT(CHAR(23), GETDATE(), 21);

                                           select * from #WORKING_TBL;

                                            저장하기 쉽게 PIVOT 으로 변환
                                           DECLARE @v_cols                 NVARCHAR(MAX);
                                           DECLARE @v_cols2                NVARCHAR(MAX);
                                           DECLARE @v_cols3                NVARCHAR(MAX);
                                           SET @v_cols = '';
                                           SET @v_cols2 = '';
                                           SET @v_cols3 = '';
                                           SELECT  @v_cols = @v_cols + '[' + CONVERT(VARCHAR, ROWNUM) + '],'
                                                 , @v_cols2 = @v_cols2 + 'ISNULL([' + CONVERT(VARCHAR, ROWNUM) + '],0) AS [' + CONVERT(VARCHAR, ROWNUM) + '],'
                                                 , @v_cols3 = @v_cols3 + 'SUM([' + CONVERT(VARCHAR, ROWNUM) + ']) AS [QTY' + RIGHT('00' + CONVERT(VARCHAR, ROWNUM), 3) + '],'
                                             FROM (
                                                    SELECT ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) AS ROWNUM, C.BASIS_YYYYMMDD
                                                   FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
                                                   WHERE 0 = 0
                                                           AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
                                                       AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
                                                  ) AS days
                                            ORDER BY ROWNUM
                                            ;


                                           SET @v_cols = LEFT(@v_cols, LEN(@v_cols) - 1);
                                           SET @v_cols2 = LEFT(@v_cols2, LEN(@v_cols2) - 1);
                                           SET @v_cols3 = LEFT(@v_cols3, LEN(@v_cols3) - 1);

                                           SET @SQL = 'SELECT S.XLS_KEY, ' + @v_cols3;
                                           SET @SQL = @SQL + '  FROM (';
                                           SET @SQL = @SQL + '        SELECT P.XLS_KEY, ' + @v_cols2;
                                           SET @SQL = @SQL + '          FROM #WORKING_TBL';
                                           SET @SQL = @SQL + '         PIVOT (';
                                           SET @SQL = @SQL + '                SUM(QTY) FOR ROWNUM IN (' + @v_cols + ')';
                                           SET @SQL = @SQL + '               ) P';
                                           SET @SQL = @SQL + '       ) S GROUP BY S.XLS_KEY ';

                                           EXEC(@SQL); */
                    /* ▼ MSSQL 원본 L694~L780 원문 보존 ('변경후 ③ Week 별 물량 분배 처리 건' 死코드) ---------------------------------------------
                                            변경후
                                            ③ Week 별 물량 분배 처리 건
                                           INSERT INTO #WORKING_TBL
                                           SELECT A.ROWNUM, A.XLS_KEY, A.YYYYMMDD, A.WORKING_TIME
                                                , CASE WHEN A.RATE = 0
                                                            THEN 0
                                                       WHEN A.TOTAL_SUM > A.WEEK_QTY AND A.CALC_RN = 1
                                                            THEN A.DAY_QTY + (A.WEEK_QTY - TOTAL_SUM)
                                                       WHEN A.TOTAL_SUM < A.WEEK_QTY AND A.CALC_RN = 1
                                                            THEN A.DAY_QTY + (A.WEEK_QTY - TOTAL_SUM)
                                                       ELSE A.DAY_QTY
                                                  END  AS QTY
                                           FROM   (
                                                   SELECT A.*
                                                        , ROUND(B.WEEK_QTY * A.RATE, 0) AS DAY_QTY,  B.WEEK_QTY
                                                        , DENSE_RANK() OVER (PARTITION BY A.ISO_YYYYWW ORDER BY A.WORKING_TIME DESC, A.YYYYMMDD) AS CALC_RN
                                                        , DENSE_RANK() OVER (PARTITION BY A.ISO_YYYYWW ORDER BY A.YYYYMMDD) AS WEEK_RN
                                                        , SUM(ROUND(B.WEEK_QTY * A.RATE, 0)) OVER (PARTITION BY A.ISO_YYYYWW) AS TOTAL_SUM
                                                   FROM   (
                                                           -- ① Working Time 산출, Week별 Rate 산출,
                                                           SELECT  ROW_NUMBER() OVER(ORDER BY YYYYMMDD) AS ROWNUM
                                                                    , @p_xls_key1 AS XLS_KEY --@p_xls_key1
                                                                 , X.YYYYMMDD
                                                                 , X.ISO_YYYYWW
                                                                 , X.WORKING_TIME
                                                                 , CASE WHEN X.WEEK_WORKING_TIME = 0 THEN 0
                                                                        ELSE X.WORKING_TIME / X.WEEK_WORKING_TIME
                                                                   END  AS RATE
                                                            FROM (
                                                                  SELECT  A.DIVISION_ID
                                                                         , A.OPERATION_ID
                                                                        , A.LINE_ID
                                                                        , C.YYYYMMDD
                                                                        , A.WORKING_TIME
                                                                        , C.ISO_YYYYWW
                                                                        , SUM(A.WORKING_TIME) OVER (PARTITION BY C.ISO_YYYYWW) AS WEEK_WORKING_TIME
                                                                  FROM  (SELECT BASIS_YYYYMMDD AS YYYYMMDD, 0 As WORKING_TIME, ISO_YYYYWW
                                                                           FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
                                                                          WHERE BASIS_YYYYMMDD BETWEEN @p_create_from_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112)) C
                                                                         LEFT OUTER JOIN
                                                                        (SELECT    DIVISION_ID
                                                                                    , PLANT_SITE_ID
                                                                                 , OPERATION_ID
                                                                                 , LINE_ID
                                                                                 , YYYYMMDD
                                                                                 , WORKING_TIME
                                                                         from dbo.FN_LINE_WORKINGTIME_BY_LOSS(@p_division_id, @p_create_from_yyyymmdd, CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112), @v_prod_line )
                                                       WHERE PLANT_SITE_ID = @v_scm_site
                                                           AND LINE_ID <> '-') A
                                                                         ON C.YYYYMMDD = A.YYYYMMDD
                                                                  WHERE 1 = 1
                                                                )  X
                                                           ) A
                                                         , (
                                                            -- ② Week 별 저장 수량
                                                            SELECT A.ISO_YYYYWW
                                                                 , CASE WHEN A.RN = 1 THEN B.WQTY01 WHEN A.RN = 2 THEN B.WQTY02 WHEN A.RN = 3 THEN B.WQTY03 WHEN A.RN = 4 THEN B.WQTY04 WHEN A.RN = 5  THEN B.WQTY05
                                                                        WHEN A.RN = 6 THEN B.WQTY06 WHEN A.RN = 7 THEN B.WQTY07 WHEN A.RN = 8 THEN B.WQTY08 WHEN A.RN = 9 THEN B.WQTY09 WHEN A.RN = 10 THEN B.WQTY10
                                                                        WHEN A.RN = 11 THEN B.WQTY11 WHEN A.RN = 12 THEN B.WQTY12 WHEN A.RN = 13 THEN B.WQTY13 WHEN A.RN = 14 THEN B.WQTY14 WHEN A.RN = 15 THEN B.WQTY15
                                                                        WHEN A.RN = 16 THEN B.WQTY16 WHEN A.RN = 17 THEN B.WQTY17 WHEN A.RN = 18 THEN B.WQTY18 WHEN A.RN = 19 THEN B.WQTY19 WHEN A.RN = 20 THEN B.WQTY20
                                                                        WHEN A.RN = 21 THEN B.WQTY21 WHEN A.RN = 22 THEN B.WQTY22 WHEN A.RN = 23 THEN B.WQTY23 WHEN A.RN = 24 THEN B.WQTY24 WHEN A.RN = 25 THEN B.WQTY25
                                                                        WHEN A.RN = 26 THEN B.WQTY26 WHEN A.RN = 27 THEN B.WQTY27 WHEN A.RN = 28 THEN B.WQTY28 WHEN A.RN = 29 THEN B.WQTY29 WHEN A.RN = 30 THEN B.WQTY30
                                                                        WHEN A.RN = 31 THEN B.WQTY31 WHEN A.RN = 32 THEN B.WQTY32 WHEN A.RN = 33 THEN B.WQTY33 WHEN A.RN = 34 THEN B.WQTY34 WHEN A.RN = 35 THEN B.WQTY35
                                                                        WHEN A.RN = 36 THEN B.WQTY36 WHEN A.RN = 37 THEN B.WQTY37 WHEN A.RN = 38 THEN B.WQTY38 WHEN A.RN = 39 THEN B.WQTY39 WHEN A.RN = 40 THEN B.WQTY40
                                                                        WHEN A.RN = 41 THEN B.WQTY41 WHEN A.RN = 42 THEN B.WQTY42 WHEN A.RN = 43 THEN B.WQTY43 WHEN A.RN = 44 THEN B.WQTY44 WHEN A.RN = 45 THEN B.WQTY45
                                                                        WHEN A.RN = 46 THEN B.WQTY46 WHEN A.RN = 47 THEN B.WQTY47 WHEN A.RN = 48 THEN B.WQTY48 WHEN A.RN = 49 THEN B.WQTY49 WHEN A.RN = 50 THEN B.WQTY50
                                                                        WHEN A.RN = 51 THEN B.WQTY51 WHEN A.RN = 52 THEN B.WQTY52
                                                                        ELSE 0
                                                                   END  AS WEEK_QTY
                                                            FROM   (
                                                                    SELECT DISTINCT DENSE_RANK() OVER (ORDER BY ISO_YYYYWW) AS RN, ISO_YYYYWW
                                                                    FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
                                                                    WHERE  BASIS_YYYYMMDD BETWEEN @p_create_from_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112)
                                                                   ) A
                                                                 , (
                                                                    SELECT @p_WQTY01 WQTY01, @p_WQTY02 WQTY02, @p_WQTY03 WQTY03, @p_WQTY04 WQTY04, @p_WQTY05 WQTY05, @p_WQTY06 WQTY06, @p_WQTY07 WQTY07, @p_WQTY08 WQTY08, @p_WQTY09 WQTY09, @p_WQTY10 WQTY10
                                                                         , @p_WQTY11 WQTY11, @p_WQTY12 WQTY12, @p_WQTY13 WQTY13, @p_WQTY14 WQTY14, @p_WQTY15 WQTY15, @p_WQTY16 WQTY16, @p_WQTY17 WQTY17, @p_WQTY18 WQTY18, @p_WQTY19 WQTY19, @p_WQTY20 WQTY20
                                                                         , @p_WQTY21 WQTY21, @p_WQTY22 WQTY22, @p_WQTY23 WQTY23, @p_WQTY24 WQTY24, @p_WQTY25 WQTY25, @p_WQTY26 WQTY26, @p_WQTY27 WQTY27, @p_WQTY28 WQTY28, @p_WQTY29 WQTY29, @p_WQTY30 WQTY30
                                                                         , @p_WQTY31 WQTY31, @p_WQTY32 WQTY32, @p_WQTY33 WQTY33, @p_WQTY34 WQTY34, @p_WQTY35 WQTY35, @p_WQTY36 WQTY36, @p_WQTY37 WQTY37, @p_WQTY38 WQTY38, @p_WQTY39 WQTY39, @p_WQTY40 WQTY40
                                                                         , @p_WQTY41 WQTY41, @p_WQTY42 WQTY42, @p_WQTY43 WQTY43, @p_WQTY44 WQTY44, @p_WQTY45 WQTY45, @p_WQTY46 WQTY46, @p_WQTY47 WQTY47, @p_WQTY48 WQTY48, @p_WQTY49 WQTY49, @p_WQTY50 WQTY50
                                                                         , @p_WQTY51 WQTY51, @p_WQTY52 WQTY52
                                                                   ) B
                                                           ) B
                                                    WHERE  A.ISO_YYYYWW = B.ISO_YYYYWW
                                                  ) A
                                           WHERE  1 = 1
                                           ; */

                    /* ---------------------------------------- */
                    /*  Pack 생산계획 저장로직개선(튜닝)건 반영 -- end */
                    /* ---------------------------------------- */

                    /*  분배된 수량 업데이트 */
                    /*                        MSSQL PIVOT (SUM(QTY) FOR ROWNUM IN ([1]..[364])) 은 대괄호 식별자를 쓴다 -> Oracle 은
                        PIVOT (SUM(QTY) FOR "ROWNUM" IN (1 AS QTY001, ..)) 로 옮기고 중간 별칭을 최종 컬럼명으로 바로 준다
                        (MSSQL 은 [n] -> 바깥에서 SUM([n]) AS QTYnnn 2단계, 결과 동일). ISNULL -> NVL. */
                    MERGE INTO SCP_XLS_PSI_GLOBAL_ESS E
                     USING (
                            SELECT S.XLS_KEY
                                  , SUM(S.QTY001) AS QTY001, SUM(S.QTY002) AS QTY002, SUM(S.QTY003) AS QTY003, SUM(S.QTY004) AS QTY004, SUM(S.QTY005) AS QTY005
                                  , SUM(S.QTY006) AS QTY006, SUM(S.QTY007) AS QTY007, SUM(S.QTY008) AS QTY008, SUM(S.QTY009) AS QTY009, SUM(S.QTY010) AS QTY010
                                  , SUM(S.QTY011) AS QTY011, SUM(S.QTY012) AS QTY012, SUM(S.QTY013) AS QTY013, SUM(S.QTY014) AS QTY014, SUM(S.QTY015) AS QTY015
                                  , SUM(S.QTY016) AS QTY016, SUM(S.QTY017) AS QTY017, SUM(S.QTY018) AS QTY018, SUM(S.QTY019) AS QTY019, SUM(S.QTY020) AS QTY020
                                  , SUM(S.QTY021) AS QTY021, SUM(S.QTY022) AS QTY022, SUM(S.QTY023) AS QTY023, SUM(S.QTY024) AS QTY024, SUM(S.QTY025) AS QTY025
                                  , SUM(S.QTY026) AS QTY026, SUM(S.QTY027) AS QTY027, SUM(S.QTY028) AS QTY028, SUM(S.QTY029) AS QTY029, SUM(S.QTY030) AS QTY030
                                  , SUM(S.QTY031) AS QTY031, SUM(S.QTY032) AS QTY032, SUM(S.QTY033) AS QTY033, SUM(S.QTY034) AS QTY034, SUM(S.QTY035) AS QTY035
                                  , SUM(S.QTY036) AS QTY036, SUM(S.QTY037) AS QTY037, SUM(S.QTY038) AS QTY038, SUM(S.QTY039) AS QTY039, SUM(S.QTY040) AS QTY040
                                  , SUM(S.QTY041) AS QTY041, SUM(S.QTY042) AS QTY042, SUM(S.QTY043) AS QTY043, SUM(S.QTY044) AS QTY044, SUM(S.QTY045) AS QTY045
                                  , SUM(S.QTY046) AS QTY046, SUM(S.QTY047) AS QTY047, SUM(S.QTY048) AS QTY048, SUM(S.QTY049) AS QTY049, SUM(S.QTY050) AS QTY050
                                  , SUM(S.QTY051) AS QTY051, SUM(S.QTY052) AS QTY052, SUM(S.QTY053) AS QTY053, SUM(S.QTY054) AS QTY054, SUM(S.QTY055) AS QTY055
                                  , SUM(S.QTY056) AS QTY056, SUM(S.QTY057) AS QTY057, SUM(S.QTY058) AS QTY058, SUM(S.QTY059) AS QTY059, SUM(S.QTY060) AS QTY060
                                  , SUM(S.QTY061) AS QTY061, SUM(S.QTY062) AS QTY062, SUM(S.QTY063) AS QTY063, SUM(S.QTY064) AS QTY064, SUM(S.QTY065) AS QTY065
                                  , SUM(S.QTY066) AS QTY066, SUM(S.QTY067) AS QTY067, SUM(S.QTY068) AS QTY068, SUM(S.QTY069) AS QTY069, SUM(S.QTY070) AS QTY070
                                  , SUM(S.QTY071) AS QTY071, SUM(S.QTY072) AS QTY072, SUM(S.QTY073) AS QTY073, SUM(S.QTY074) AS QTY074, SUM(S.QTY075) AS QTY075
                                  , SUM(S.QTY076) AS QTY076, SUM(S.QTY077) AS QTY077, SUM(S.QTY078) AS QTY078, SUM(S.QTY079) AS QTY079, SUM(S.QTY080) AS QTY080
                                  , SUM(S.QTY081) AS QTY081, SUM(S.QTY082) AS QTY082, SUM(S.QTY083) AS QTY083, SUM(S.QTY084) AS QTY084, SUM(S.QTY085) AS QTY085
                                  , SUM(S.QTY086) AS QTY086, SUM(S.QTY087) AS QTY087, SUM(S.QTY088) AS QTY088, SUM(S.QTY089) AS QTY089, SUM(S.QTY090) AS QTY090
                                  , SUM(S.QTY091) AS QTY091, SUM(S.QTY092) AS QTY092, SUM(S.QTY093) AS QTY093, SUM(S.QTY094) AS QTY094, SUM(S.QTY095) AS QTY095
                                  , SUM(S.QTY096) AS QTY096, SUM(S.QTY097) AS QTY097, SUM(S.QTY098) AS QTY098, SUM(S.QTY099) AS QTY099, SUM(S.QTY100) AS QTY100
                                  , SUM(S.QTY101) AS QTY101, SUM(S.QTY102) AS QTY102, SUM(S.QTY103) AS QTY103, SUM(S.QTY104) AS QTY104, SUM(S.QTY105) AS QTY105
                                  , SUM(S.QTY106) AS QTY106, SUM(S.QTY107) AS QTY107, SUM(S.QTY108) AS QTY108, SUM(S.QTY109) AS QTY109, SUM(S.QTY110) AS QTY110
                                  , SUM(S.QTY111) AS QTY111, SUM(S.QTY112) AS QTY112, SUM(S.QTY113) AS QTY113, SUM(S.QTY114) AS QTY114, SUM(S.QTY115) AS QTY115
                                  , SUM(S.QTY116) AS QTY116, SUM(S.QTY117) AS QTY117, SUM(S.QTY118) AS QTY118, SUM(S.QTY119) AS QTY119, SUM(S.QTY120) AS QTY120
                                  , SUM(S.QTY121) AS QTY121, SUM(S.QTY122) AS QTY122, SUM(S.QTY123) AS QTY123, SUM(S.QTY124) AS QTY124, SUM(S.QTY125) AS QTY125
                                  , SUM(S.QTY126) AS QTY126, SUM(S.QTY127) AS QTY127, SUM(S.QTY128) AS QTY128, SUM(S.QTY129) AS QTY129, SUM(S.QTY130) AS QTY130
                                  , SUM(S.QTY131) AS QTY131, SUM(S.QTY132) AS QTY132, SUM(S.QTY133) AS QTY133, SUM(S.QTY134) AS QTY134, SUM(S.QTY135) AS QTY135
                                  , SUM(S.QTY136) AS QTY136, SUM(S.QTY137) AS QTY137, SUM(S.QTY138) AS QTY138, SUM(S.QTY139) AS QTY139, SUM(S.QTY140) AS QTY140
                                  , SUM(S.QTY141) AS QTY141, SUM(S.QTY142) AS QTY142, SUM(S.QTY143) AS QTY143, SUM(S.QTY144) AS QTY144, SUM(S.QTY145) AS QTY145
                                  , SUM(S.QTY146) AS QTY146, SUM(S.QTY147) AS QTY147, SUM(S.QTY148) AS QTY148, SUM(S.QTY149) AS QTY149, SUM(S.QTY150) AS QTY150
                                  , SUM(S.QTY151) AS QTY151, SUM(S.QTY152) AS QTY152, SUM(S.QTY153) AS QTY153, SUM(S.QTY154) AS QTY154, SUM(S.QTY155) AS QTY155
                                  , SUM(S.QTY156) AS QTY156, SUM(S.QTY157) AS QTY157, SUM(S.QTY158) AS QTY158, SUM(S.QTY159) AS QTY159, SUM(S.QTY160) AS QTY160
                                  , SUM(S.QTY161) AS QTY161, SUM(S.QTY162) AS QTY162, SUM(S.QTY163) AS QTY163, SUM(S.QTY164) AS QTY164, SUM(S.QTY165) AS QTY165
                                  , SUM(S.QTY166) AS QTY166, SUM(S.QTY167) AS QTY167, SUM(S.QTY168) AS QTY168, SUM(S.QTY169) AS QTY169, SUM(S.QTY170) AS QTY170
                                  , SUM(S.QTY171) AS QTY171, SUM(S.QTY172) AS QTY172, SUM(S.QTY173) AS QTY173, SUM(S.QTY174) AS QTY174, SUM(S.QTY175) AS QTY175
                                  , SUM(S.QTY176) AS QTY176, SUM(S.QTY177) AS QTY177, SUM(S.QTY178) AS QTY178, SUM(S.QTY179) AS QTY179, SUM(S.QTY180) AS QTY180
                                  , SUM(S.QTY181) AS QTY181, SUM(S.QTY182) AS QTY182, SUM(S.QTY183) AS QTY183, SUM(S.QTY184) AS QTY184, SUM(S.QTY185) AS QTY185
                                  , SUM(S.QTY186) AS QTY186, SUM(S.QTY187) AS QTY187, SUM(S.QTY188) AS QTY188, SUM(S.QTY189) AS QTY189, SUM(S.QTY190) AS QTY190
                                  , SUM(S.QTY191) AS QTY191, SUM(S.QTY192) AS QTY192, SUM(S.QTY193) AS QTY193, SUM(S.QTY194) AS QTY194, SUM(S.QTY195) AS QTY195
                                  , SUM(S.QTY196) AS QTY196, SUM(S.QTY197) AS QTY197, SUM(S.QTY198) AS QTY198, SUM(S.QTY199) AS QTY199, SUM(S.QTY200) AS QTY200
                                  , SUM(S.QTY201) AS QTY201, SUM(S.QTY202) AS QTY202, SUM(S.QTY203) AS QTY203, SUM(S.QTY204) AS QTY204, SUM(S.QTY205) AS QTY205
                                  , SUM(S.QTY206) AS QTY206, SUM(S.QTY207) AS QTY207, SUM(S.QTY208) AS QTY208, SUM(S.QTY209) AS QTY209, SUM(S.QTY210) AS QTY210
                                  , SUM(S.QTY211) AS QTY211, SUM(S.QTY212) AS QTY212, SUM(S.QTY213) AS QTY213, SUM(S.QTY214) AS QTY214, SUM(S.QTY215) AS QTY215
                                  , SUM(S.QTY216) AS QTY216, SUM(S.QTY217) AS QTY217, SUM(S.QTY218) AS QTY218, SUM(S.QTY219) AS QTY219, SUM(S.QTY220) AS QTY220
                                  , SUM(S.QTY221) AS QTY221, SUM(S.QTY222) AS QTY222, SUM(S.QTY223) AS QTY223, SUM(S.QTY224) AS QTY224, SUM(S.QTY225) AS QTY225
                                  , SUM(S.QTY226) AS QTY226, SUM(S.QTY227) AS QTY227, SUM(S.QTY228) AS QTY228, SUM(S.QTY229) AS QTY229, SUM(S.QTY230) AS QTY230
                                  , SUM(S.QTY231) AS QTY231, SUM(S.QTY232) AS QTY232, SUM(S.QTY233) AS QTY233, SUM(S.QTY234) AS QTY234, SUM(S.QTY235) AS QTY235
                                  , SUM(S.QTY236) AS QTY236, SUM(S.QTY237) AS QTY237, SUM(S.QTY238) AS QTY238, SUM(S.QTY239) AS QTY239, SUM(S.QTY240) AS QTY240
                                  , SUM(S.QTY241) AS QTY241, SUM(S.QTY242) AS QTY242, SUM(S.QTY243) AS QTY243, SUM(S.QTY244) AS QTY244, SUM(S.QTY245) AS QTY245
                                  , SUM(S.QTY246) AS QTY246, SUM(S.QTY247) AS QTY247, SUM(S.QTY248) AS QTY248, SUM(S.QTY249) AS QTY249, SUM(S.QTY250) AS QTY250
                                  , SUM(S.QTY251) AS QTY251, SUM(S.QTY252) AS QTY252, SUM(S.QTY253) AS QTY253, SUM(S.QTY254) AS QTY254, SUM(S.QTY255) AS QTY255
                                  , SUM(S.QTY256) AS QTY256, SUM(S.QTY257) AS QTY257, SUM(S.QTY258) AS QTY258, SUM(S.QTY259) AS QTY259, SUM(S.QTY260) AS QTY260
                                  , SUM(S.QTY261) AS QTY261, SUM(S.QTY262) AS QTY262, SUM(S.QTY263) AS QTY263, SUM(S.QTY264) AS QTY264, SUM(S.QTY265) AS QTY265
                                  , SUM(S.QTY266) AS QTY266, SUM(S.QTY267) AS QTY267, SUM(S.QTY268) AS QTY268, SUM(S.QTY269) AS QTY269, SUM(S.QTY270) AS QTY270
                                  , SUM(S.QTY271) AS QTY271, SUM(S.QTY272) AS QTY272, SUM(S.QTY273) AS QTY273, SUM(S.QTY274) AS QTY274, SUM(S.QTY275) AS QTY275
                                  , SUM(S.QTY276) AS QTY276, SUM(S.QTY277) AS QTY277, SUM(S.QTY278) AS QTY278, SUM(S.QTY279) AS QTY279, SUM(S.QTY280) AS QTY280
                                  , SUM(S.QTY281) AS QTY281, SUM(S.QTY282) AS QTY282, SUM(S.QTY283) AS QTY283, SUM(S.QTY284) AS QTY284, SUM(S.QTY285) AS QTY285
                                  , SUM(S.QTY286) AS QTY286, SUM(S.QTY287) AS QTY287, SUM(S.QTY288) AS QTY288, SUM(S.QTY289) AS QTY289, SUM(S.QTY290) AS QTY290
                                  , SUM(S.QTY291) AS QTY291, SUM(S.QTY292) AS QTY292, SUM(S.QTY293) AS QTY293, SUM(S.QTY294) AS QTY294, SUM(S.QTY295) AS QTY295
                                  , SUM(S.QTY296) AS QTY296, SUM(S.QTY297) AS QTY297, SUM(S.QTY298) AS QTY298, SUM(S.QTY299) AS QTY299, SUM(S.QTY300) AS QTY300
                                  , SUM(S.QTY301) AS QTY301, SUM(S.QTY302) AS QTY302, SUM(S.QTY303) AS QTY303, SUM(S.QTY304) AS QTY304, SUM(S.QTY305) AS QTY305
                                  , SUM(S.QTY306) AS QTY306, SUM(S.QTY307) AS QTY307, SUM(S.QTY308) AS QTY308, SUM(S.QTY309) AS QTY309, SUM(S.QTY310) AS QTY310
                                  , SUM(S.QTY311) AS QTY311, SUM(S.QTY312) AS QTY312, SUM(S.QTY313) AS QTY313, SUM(S.QTY314) AS QTY314, SUM(S.QTY315) AS QTY315
                                  , SUM(S.QTY316) AS QTY316, SUM(S.QTY317) AS QTY317, SUM(S.QTY318) AS QTY318, SUM(S.QTY319) AS QTY319, SUM(S.QTY320) AS QTY320
                                  , SUM(S.QTY321) AS QTY321, SUM(S.QTY322) AS QTY322, SUM(S.QTY323) AS QTY323, SUM(S.QTY324) AS QTY324, SUM(S.QTY325) AS QTY325
                                  , SUM(S.QTY326) AS QTY326, SUM(S.QTY327) AS QTY327, SUM(S.QTY328) AS QTY328, SUM(S.QTY329) AS QTY329, SUM(S.QTY330) AS QTY330
                                  , SUM(S.QTY331) AS QTY331, SUM(S.QTY332) AS QTY332, SUM(S.QTY333) AS QTY333, SUM(S.QTY334) AS QTY334, SUM(S.QTY335) AS QTY335
                                  , SUM(S.QTY336) AS QTY336, SUM(S.QTY337) AS QTY337, SUM(S.QTY338) AS QTY338, SUM(S.QTY339) AS QTY339, SUM(S.QTY340) AS QTY340
                                  , SUM(S.QTY341) AS QTY341, SUM(S.QTY342) AS QTY342, SUM(S.QTY343) AS QTY343, SUM(S.QTY344) AS QTY344, SUM(S.QTY345) AS QTY345
                                  , SUM(S.QTY346) AS QTY346, SUM(S.QTY347) AS QTY347, SUM(S.QTY348) AS QTY348, SUM(S.QTY349) AS QTY349, SUM(S.QTY350) AS QTY350
                                  , SUM(S.QTY351) AS QTY351, SUM(S.QTY352) AS QTY352, SUM(S.QTY353) AS QTY353, SUM(S.QTY354) AS QTY354, SUM(S.QTY355) AS QTY355
                                  , SUM(S.QTY356) AS QTY356, SUM(S.QTY357) AS QTY357, SUM(S.QTY358) AS QTY358, SUM(S.QTY359) AS QTY359, SUM(S.QTY360) AS QTY360
                                  , SUM(S.QTY361) AS QTY361, SUM(S.QTY362) AS QTY362, SUM(S.QTY363) AS QTY363, SUM(S.QTY364) AS QTY364
                              FROM ( SELECT P.XLS_KEY
                                        , NVL(P.QTY001, 0) AS QTY001, NVL(P.QTY002, 0) AS QTY002, NVL(P.QTY003, 0) AS QTY003, NVL(P.QTY004, 0) AS QTY004, NVL(P.QTY005, 0) AS QTY005
                                        , NVL(P.QTY006, 0) AS QTY006, NVL(P.QTY007, 0) AS QTY007, NVL(P.QTY008, 0) AS QTY008, NVL(P.QTY009, 0) AS QTY009, NVL(P.QTY010, 0) AS QTY010
                                        , NVL(P.QTY011, 0) AS QTY011, NVL(P.QTY012, 0) AS QTY012, NVL(P.QTY013, 0) AS QTY013, NVL(P.QTY014, 0) AS QTY014, NVL(P.QTY015, 0) AS QTY015
                                        , NVL(P.QTY016, 0) AS QTY016, NVL(P.QTY017, 0) AS QTY017, NVL(P.QTY018, 0) AS QTY018, NVL(P.QTY019, 0) AS QTY019, NVL(P.QTY020, 0) AS QTY020
                                        , NVL(P.QTY021, 0) AS QTY021, NVL(P.QTY022, 0) AS QTY022, NVL(P.QTY023, 0) AS QTY023, NVL(P.QTY024, 0) AS QTY024, NVL(P.QTY025, 0) AS QTY025
                                        , NVL(P.QTY026, 0) AS QTY026, NVL(P.QTY027, 0) AS QTY027, NVL(P.QTY028, 0) AS QTY028, NVL(P.QTY029, 0) AS QTY029, NVL(P.QTY030, 0) AS QTY030
                                        , NVL(P.QTY031, 0) AS QTY031, NVL(P.QTY032, 0) AS QTY032, NVL(P.QTY033, 0) AS QTY033, NVL(P.QTY034, 0) AS QTY034, NVL(P.QTY035, 0) AS QTY035
                                        , NVL(P.QTY036, 0) AS QTY036, NVL(P.QTY037, 0) AS QTY037, NVL(P.QTY038, 0) AS QTY038, NVL(P.QTY039, 0) AS QTY039, NVL(P.QTY040, 0) AS QTY040
                                        , NVL(P.QTY041, 0) AS QTY041, NVL(P.QTY042, 0) AS QTY042, NVL(P.QTY043, 0) AS QTY043, NVL(P.QTY044, 0) AS QTY044, NVL(P.QTY045, 0) AS QTY045
                                        , NVL(P.QTY046, 0) AS QTY046, NVL(P.QTY047, 0) AS QTY047, NVL(P.QTY048, 0) AS QTY048, NVL(P.QTY049, 0) AS QTY049, NVL(P.QTY050, 0) AS QTY050
                                        , NVL(P.QTY051, 0) AS QTY051, NVL(P.QTY052, 0) AS QTY052, NVL(P.QTY053, 0) AS QTY053, NVL(P.QTY054, 0) AS QTY054, NVL(P.QTY055, 0) AS QTY055
                                        , NVL(P.QTY056, 0) AS QTY056, NVL(P.QTY057, 0) AS QTY057, NVL(P.QTY058, 0) AS QTY058, NVL(P.QTY059, 0) AS QTY059, NVL(P.QTY060, 0) AS QTY060
                                        , NVL(P.QTY061, 0) AS QTY061, NVL(P.QTY062, 0) AS QTY062, NVL(P.QTY063, 0) AS QTY063, NVL(P.QTY064, 0) AS QTY064, NVL(P.QTY065, 0) AS QTY065
                                        , NVL(P.QTY066, 0) AS QTY066, NVL(P.QTY067, 0) AS QTY067, NVL(P.QTY068, 0) AS QTY068, NVL(P.QTY069, 0) AS QTY069, NVL(P.QTY070, 0) AS QTY070
                                        , NVL(P.QTY071, 0) AS QTY071, NVL(P.QTY072, 0) AS QTY072, NVL(P.QTY073, 0) AS QTY073, NVL(P.QTY074, 0) AS QTY074, NVL(P.QTY075, 0) AS QTY075
                                        , NVL(P.QTY076, 0) AS QTY076, NVL(P.QTY077, 0) AS QTY077, NVL(P.QTY078, 0) AS QTY078, NVL(P.QTY079, 0) AS QTY079, NVL(P.QTY080, 0) AS QTY080
                                        , NVL(P.QTY081, 0) AS QTY081, NVL(P.QTY082, 0) AS QTY082, NVL(P.QTY083, 0) AS QTY083, NVL(P.QTY084, 0) AS QTY084, NVL(P.QTY085, 0) AS QTY085
                                        , NVL(P.QTY086, 0) AS QTY086, NVL(P.QTY087, 0) AS QTY087, NVL(P.QTY088, 0) AS QTY088, NVL(P.QTY089, 0) AS QTY089, NVL(P.QTY090, 0) AS QTY090
                                        , NVL(P.QTY091, 0) AS QTY091, NVL(P.QTY092, 0) AS QTY092, NVL(P.QTY093, 0) AS QTY093, NVL(P.QTY094, 0) AS QTY094, NVL(P.QTY095, 0) AS QTY095
                                        , NVL(P.QTY096, 0) AS QTY096, NVL(P.QTY097, 0) AS QTY097, NVL(P.QTY098, 0) AS QTY098, NVL(P.QTY099, 0) AS QTY099, NVL(P.QTY100, 0) AS QTY100
                                        , NVL(P.QTY101, 0) AS QTY101, NVL(P.QTY102, 0) AS QTY102, NVL(P.QTY103, 0) AS QTY103, NVL(P.QTY104, 0) AS QTY104, NVL(P.QTY105, 0) AS QTY105
                                        , NVL(P.QTY106, 0) AS QTY106, NVL(P.QTY107, 0) AS QTY107, NVL(P.QTY108, 0) AS QTY108, NVL(P.QTY109, 0) AS QTY109, NVL(P.QTY110, 0) AS QTY110
                                        , NVL(P.QTY111, 0) AS QTY111, NVL(P.QTY112, 0) AS QTY112, NVL(P.QTY113, 0) AS QTY113, NVL(P.QTY114, 0) AS QTY114, NVL(P.QTY115, 0) AS QTY115
                                        , NVL(P.QTY116, 0) AS QTY116, NVL(P.QTY117, 0) AS QTY117, NVL(P.QTY118, 0) AS QTY118, NVL(P.QTY119, 0) AS QTY119, NVL(P.QTY120, 0) AS QTY120
                                        , NVL(P.QTY121, 0) AS QTY121, NVL(P.QTY122, 0) AS QTY122, NVL(P.QTY123, 0) AS QTY123, NVL(P.QTY124, 0) AS QTY124, NVL(P.QTY125, 0) AS QTY125
                                        , NVL(P.QTY126, 0) AS QTY126, NVL(P.QTY127, 0) AS QTY127, NVL(P.QTY128, 0) AS QTY128, NVL(P.QTY129, 0) AS QTY129, NVL(P.QTY130, 0) AS QTY130
                                        , NVL(P.QTY131, 0) AS QTY131, NVL(P.QTY132, 0) AS QTY132, NVL(P.QTY133, 0) AS QTY133, NVL(P.QTY134, 0) AS QTY134, NVL(P.QTY135, 0) AS QTY135
                                        , NVL(P.QTY136, 0) AS QTY136, NVL(P.QTY137, 0) AS QTY137, NVL(P.QTY138, 0) AS QTY138, NVL(P.QTY139, 0) AS QTY139, NVL(P.QTY140, 0) AS QTY140
                                        , NVL(P.QTY141, 0) AS QTY141, NVL(P.QTY142, 0) AS QTY142, NVL(P.QTY143, 0) AS QTY143, NVL(P.QTY144, 0) AS QTY144, NVL(P.QTY145, 0) AS QTY145
                                        , NVL(P.QTY146, 0) AS QTY146, NVL(P.QTY147, 0) AS QTY147, NVL(P.QTY148, 0) AS QTY148, NVL(P.QTY149, 0) AS QTY149, NVL(P.QTY150, 0) AS QTY150
                                        , NVL(P.QTY151, 0) AS QTY151, NVL(P.QTY152, 0) AS QTY152, NVL(P.QTY153, 0) AS QTY153, NVL(P.QTY154, 0) AS QTY154, NVL(P.QTY155, 0) AS QTY155
                                        , NVL(P.QTY156, 0) AS QTY156, NVL(P.QTY157, 0) AS QTY157, NVL(P.QTY158, 0) AS QTY158, NVL(P.QTY159, 0) AS QTY159, NVL(P.QTY160, 0) AS QTY160
                                        , NVL(P.QTY161, 0) AS QTY161, NVL(P.QTY162, 0) AS QTY162, NVL(P.QTY163, 0) AS QTY163, NVL(P.QTY164, 0) AS QTY164, NVL(P.QTY165, 0) AS QTY165
                                        , NVL(P.QTY166, 0) AS QTY166, NVL(P.QTY167, 0) AS QTY167, NVL(P.QTY168, 0) AS QTY168, NVL(P.QTY169, 0) AS QTY169, NVL(P.QTY170, 0) AS QTY170
                                        , NVL(P.QTY171, 0) AS QTY171, NVL(P.QTY172, 0) AS QTY172, NVL(P.QTY173, 0) AS QTY173, NVL(P.QTY174, 0) AS QTY174, NVL(P.QTY175, 0) AS QTY175
                                        , NVL(P.QTY176, 0) AS QTY176, NVL(P.QTY177, 0) AS QTY177, NVL(P.QTY178, 0) AS QTY178, NVL(P.QTY179, 0) AS QTY179, NVL(P.QTY180, 0) AS QTY180
                                        , NVL(P.QTY181, 0) AS QTY181, NVL(P.QTY182, 0) AS QTY182, NVL(P.QTY183, 0) AS QTY183, NVL(P.QTY184, 0) AS QTY184, NVL(P.QTY185, 0) AS QTY185
                                        , NVL(P.QTY186, 0) AS QTY186, NVL(P.QTY187, 0) AS QTY187, NVL(P.QTY188, 0) AS QTY188, NVL(P.QTY189, 0) AS QTY189, NVL(P.QTY190, 0) AS QTY190
                                        , NVL(P.QTY191, 0) AS QTY191, NVL(P.QTY192, 0) AS QTY192, NVL(P.QTY193, 0) AS QTY193, NVL(P.QTY194, 0) AS QTY194, NVL(P.QTY195, 0) AS QTY195
                                        , NVL(P.QTY196, 0) AS QTY196, NVL(P.QTY197, 0) AS QTY197, NVL(P.QTY198, 0) AS QTY198, NVL(P.QTY199, 0) AS QTY199, NVL(P.QTY200, 0) AS QTY200
                                        , NVL(P.QTY201, 0) AS QTY201, NVL(P.QTY202, 0) AS QTY202, NVL(P.QTY203, 0) AS QTY203, NVL(P.QTY204, 0) AS QTY204, NVL(P.QTY205, 0) AS QTY205
                                        , NVL(P.QTY206, 0) AS QTY206, NVL(P.QTY207, 0) AS QTY207, NVL(P.QTY208, 0) AS QTY208, NVL(P.QTY209, 0) AS QTY209, NVL(P.QTY210, 0) AS QTY210
                                        , NVL(P.QTY211, 0) AS QTY211, NVL(P.QTY212, 0) AS QTY212, NVL(P.QTY213, 0) AS QTY213, NVL(P.QTY214, 0) AS QTY214, NVL(P.QTY215, 0) AS QTY215
                                        , NVL(P.QTY216, 0) AS QTY216, NVL(P.QTY217, 0) AS QTY217, NVL(P.QTY218, 0) AS QTY218, NVL(P.QTY219, 0) AS QTY219, NVL(P.QTY220, 0) AS QTY220
                                        , NVL(P.QTY221, 0) AS QTY221, NVL(P.QTY222, 0) AS QTY222, NVL(P.QTY223, 0) AS QTY223, NVL(P.QTY224, 0) AS QTY224, NVL(P.QTY225, 0) AS QTY225
                                        , NVL(P.QTY226, 0) AS QTY226, NVL(P.QTY227, 0) AS QTY227, NVL(P.QTY228, 0) AS QTY228, NVL(P.QTY229, 0) AS QTY229, NVL(P.QTY230, 0) AS QTY230
                                        , NVL(P.QTY231, 0) AS QTY231, NVL(P.QTY232, 0) AS QTY232, NVL(P.QTY233, 0) AS QTY233, NVL(P.QTY234, 0) AS QTY234, NVL(P.QTY235, 0) AS QTY235
                                        , NVL(P.QTY236, 0) AS QTY236, NVL(P.QTY237, 0) AS QTY237, NVL(P.QTY238, 0) AS QTY238, NVL(P.QTY239, 0) AS QTY239, NVL(P.QTY240, 0) AS QTY240
                                        , NVL(P.QTY241, 0) AS QTY241, NVL(P.QTY242, 0) AS QTY242, NVL(P.QTY243, 0) AS QTY243, NVL(P.QTY244, 0) AS QTY244, NVL(P.QTY245, 0) AS QTY245
                                        , NVL(P.QTY246, 0) AS QTY246, NVL(P.QTY247, 0) AS QTY247, NVL(P.QTY248, 0) AS QTY248, NVL(P.QTY249, 0) AS QTY249, NVL(P.QTY250, 0) AS QTY250
                                        , NVL(P.QTY251, 0) AS QTY251, NVL(P.QTY252, 0) AS QTY252, NVL(P.QTY253, 0) AS QTY253, NVL(P.QTY254, 0) AS QTY254, NVL(P.QTY255, 0) AS QTY255
                                        , NVL(P.QTY256, 0) AS QTY256, NVL(P.QTY257, 0) AS QTY257, NVL(P.QTY258, 0) AS QTY258, NVL(P.QTY259, 0) AS QTY259, NVL(P.QTY260, 0) AS QTY260
                                        , NVL(P.QTY261, 0) AS QTY261, NVL(P.QTY262, 0) AS QTY262, NVL(P.QTY263, 0) AS QTY263, NVL(P.QTY264, 0) AS QTY264, NVL(P.QTY265, 0) AS QTY265
                                        , NVL(P.QTY266, 0) AS QTY266, NVL(P.QTY267, 0) AS QTY267, NVL(P.QTY268, 0) AS QTY268, NVL(P.QTY269, 0) AS QTY269, NVL(P.QTY270, 0) AS QTY270
                                        , NVL(P.QTY271, 0) AS QTY271, NVL(P.QTY272, 0) AS QTY272, NVL(P.QTY273, 0) AS QTY273, NVL(P.QTY274, 0) AS QTY274, NVL(P.QTY275, 0) AS QTY275
                                        , NVL(P.QTY276, 0) AS QTY276, NVL(P.QTY277, 0) AS QTY277, NVL(P.QTY278, 0) AS QTY278, NVL(P.QTY279, 0) AS QTY279, NVL(P.QTY280, 0) AS QTY280
                                        , NVL(P.QTY281, 0) AS QTY281, NVL(P.QTY282, 0) AS QTY282, NVL(P.QTY283, 0) AS QTY283, NVL(P.QTY284, 0) AS QTY284, NVL(P.QTY285, 0) AS QTY285
                                        , NVL(P.QTY286, 0) AS QTY286, NVL(P.QTY287, 0) AS QTY287, NVL(P.QTY288, 0) AS QTY288, NVL(P.QTY289, 0) AS QTY289, NVL(P.QTY290, 0) AS QTY290
                                        , NVL(P.QTY291, 0) AS QTY291, NVL(P.QTY292, 0) AS QTY292, NVL(P.QTY293, 0) AS QTY293, NVL(P.QTY294, 0) AS QTY294, NVL(P.QTY295, 0) AS QTY295
                                        , NVL(P.QTY296, 0) AS QTY296, NVL(P.QTY297, 0) AS QTY297, NVL(P.QTY298, 0) AS QTY298, NVL(P.QTY299, 0) AS QTY299, NVL(P.QTY300, 0) AS QTY300
                                        , NVL(P.QTY301, 0) AS QTY301, NVL(P.QTY302, 0) AS QTY302, NVL(P.QTY303, 0) AS QTY303, NVL(P.QTY304, 0) AS QTY304, NVL(P.QTY305, 0) AS QTY305
                                        , NVL(P.QTY306, 0) AS QTY306, NVL(P.QTY307, 0) AS QTY307, NVL(P.QTY308, 0) AS QTY308, NVL(P.QTY309, 0) AS QTY309, NVL(P.QTY310, 0) AS QTY310
                                        , NVL(P.QTY311, 0) AS QTY311, NVL(P.QTY312, 0) AS QTY312, NVL(P.QTY313, 0) AS QTY313, NVL(P.QTY314, 0) AS QTY314, NVL(P.QTY315, 0) AS QTY315
                                        , NVL(P.QTY316, 0) AS QTY316, NVL(P.QTY317, 0) AS QTY317, NVL(P.QTY318, 0) AS QTY318, NVL(P.QTY319, 0) AS QTY319, NVL(P.QTY320, 0) AS QTY320
                                        , NVL(P.QTY321, 0) AS QTY321, NVL(P.QTY322, 0) AS QTY322, NVL(P.QTY323, 0) AS QTY323, NVL(P.QTY324, 0) AS QTY324, NVL(P.QTY325, 0) AS QTY325
                                        , NVL(P.QTY326, 0) AS QTY326, NVL(P.QTY327, 0) AS QTY327, NVL(P.QTY328, 0) AS QTY328, NVL(P.QTY329, 0) AS QTY329, NVL(P.QTY330, 0) AS QTY330
                                        , NVL(P.QTY331, 0) AS QTY331, NVL(P.QTY332, 0) AS QTY332, NVL(P.QTY333, 0) AS QTY333, NVL(P.QTY334, 0) AS QTY334, NVL(P.QTY335, 0) AS QTY335
                                        , NVL(P.QTY336, 0) AS QTY336, NVL(P.QTY337, 0) AS QTY337, NVL(P.QTY338, 0) AS QTY338, NVL(P.QTY339, 0) AS QTY339, NVL(P.QTY340, 0) AS QTY340
                                        , NVL(P.QTY341, 0) AS QTY341, NVL(P.QTY342, 0) AS QTY342, NVL(P.QTY343, 0) AS QTY343, NVL(P.QTY344, 0) AS QTY344, NVL(P.QTY345, 0) AS QTY345
                                        , NVL(P.QTY346, 0) AS QTY346, NVL(P.QTY347, 0) AS QTY347, NVL(P.QTY348, 0) AS QTY348, NVL(P.QTY349, 0) AS QTY349, NVL(P.QTY350, 0) AS QTY350
                                        , NVL(P.QTY351, 0) AS QTY351, NVL(P.QTY352, 0) AS QTY352, NVL(P.QTY353, 0) AS QTY353, NVL(P.QTY354, 0) AS QTY354, NVL(P.QTY355, 0) AS QTY355
                                        , NVL(P.QTY356, 0) AS QTY356, NVL(P.QTY357, 0) AS QTY357, NVL(P.QTY358, 0) AS QTY358, NVL(P.QTY359, 0) AS QTY359, NVL(P.QTY360, 0) AS QTY360
                                        , NVL(P.QTY361, 0) AS QTY361, NVL(P.QTY362, 0) AS QTY362, NVL(P.QTY363, 0) AS QTY363, NVL(P.QTY364, 0) AS QTY364
                                       FROM GT_XPGT_WORKING_TBL
                                      PIVOT (
                                             SUM(QTY) FOR "ROWNUM" IN (
                                                        1 AS QTY001, 2 AS QTY002, 3 AS QTY003, 4 AS QTY004, 5 AS QTY005, 6 AS QTY006, 7 AS QTY007, 8 AS QTY008, 9 AS QTY009, 10 AS QTY010
                                                      , 11 AS QTY011, 12 AS QTY012, 13 AS QTY013, 14 AS QTY014, 15 AS QTY015, 16 AS QTY016, 17 AS QTY017, 18 AS QTY018, 19 AS QTY019, 20 AS QTY020
                                                      , 21 AS QTY021, 22 AS QTY022, 23 AS QTY023, 24 AS QTY024, 25 AS QTY025, 26 AS QTY026, 27 AS QTY027, 28 AS QTY028, 29 AS QTY029, 30 AS QTY030
                                                      , 31 AS QTY031, 32 AS QTY032, 33 AS QTY033, 34 AS QTY034, 35 AS QTY035, 36 AS QTY036, 37 AS QTY037, 38 AS QTY038, 39 AS QTY039, 40 AS QTY040
                                                      , 41 AS QTY041, 42 AS QTY042, 43 AS QTY043, 44 AS QTY044, 45 AS QTY045, 46 AS QTY046, 47 AS QTY047, 48 AS QTY048, 49 AS QTY049, 50 AS QTY050
                                                      , 51 AS QTY051, 52 AS QTY052, 53 AS QTY053, 54 AS QTY054, 55 AS QTY055, 56 AS QTY056, 57 AS QTY057, 58 AS QTY058, 59 AS QTY059, 60 AS QTY060
                                                      , 61 AS QTY061, 62 AS QTY062, 63 AS QTY063, 64 AS QTY064, 65 AS QTY065, 66 AS QTY066, 67 AS QTY067, 68 AS QTY068, 69 AS QTY069, 70 AS QTY070
                                                      , 71 AS QTY071, 72 AS QTY072, 73 AS QTY073, 74 AS QTY074, 75 AS QTY075, 76 AS QTY076, 77 AS QTY077, 78 AS QTY078, 79 AS QTY079, 80 AS QTY080
                                                      , 81 AS QTY081, 82 AS QTY082, 83 AS QTY083, 84 AS QTY084, 85 AS QTY085, 86 AS QTY086, 87 AS QTY087, 88 AS QTY088, 89 AS QTY089, 90 AS QTY090
                                                      , 91 AS QTY091, 92 AS QTY092, 93 AS QTY093, 94 AS QTY094, 95 AS QTY095, 96 AS QTY096, 97 AS QTY097, 98 AS QTY098, 99 AS QTY099, 100 AS QTY100
                                                      , 101 AS QTY101, 102 AS QTY102, 103 AS QTY103, 104 AS QTY104, 105 AS QTY105, 106 AS QTY106, 107 AS QTY107, 108 AS QTY108, 109 AS QTY109, 110 AS QTY110
                                                      , 111 AS QTY111, 112 AS QTY112, 113 AS QTY113, 114 AS QTY114, 115 AS QTY115, 116 AS QTY116, 117 AS QTY117, 118 AS QTY118, 119 AS QTY119, 120 AS QTY120
                                                      , 121 AS QTY121, 122 AS QTY122, 123 AS QTY123, 124 AS QTY124, 125 AS QTY125, 126 AS QTY126, 127 AS QTY127, 128 AS QTY128, 129 AS QTY129, 130 AS QTY130
                                                      , 131 AS QTY131, 132 AS QTY132, 133 AS QTY133, 134 AS QTY134, 135 AS QTY135, 136 AS QTY136, 137 AS QTY137, 138 AS QTY138, 139 AS QTY139, 140 AS QTY140
                                                      , 141 AS QTY141, 142 AS QTY142, 143 AS QTY143, 144 AS QTY144, 145 AS QTY145, 146 AS QTY146, 147 AS QTY147, 148 AS QTY148, 149 AS QTY149, 150 AS QTY150
                                                      , 151 AS QTY151, 152 AS QTY152, 153 AS QTY153, 154 AS QTY154, 155 AS QTY155, 156 AS QTY156, 157 AS QTY157, 158 AS QTY158, 159 AS QTY159, 160 AS QTY160
                                                      , 161 AS QTY161, 162 AS QTY162, 163 AS QTY163, 164 AS QTY164, 165 AS QTY165, 166 AS QTY166, 167 AS QTY167, 168 AS QTY168, 169 AS QTY169, 170 AS QTY170
                                                      , 171 AS QTY171, 172 AS QTY172, 173 AS QTY173, 174 AS QTY174, 175 AS QTY175, 176 AS QTY176, 177 AS QTY177, 178 AS QTY178, 179 AS QTY179, 180 AS QTY180
                                                      , 181 AS QTY181, 182 AS QTY182, 183 AS QTY183, 184 AS QTY184, 185 AS QTY185, 186 AS QTY186, 187 AS QTY187, 188 AS QTY188, 189 AS QTY189, 190 AS QTY190
                                                      , 191 AS QTY191, 192 AS QTY192, 193 AS QTY193, 194 AS QTY194, 195 AS QTY195, 196 AS QTY196, 197 AS QTY197, 198 AS QTY198, 199 AS QTY199, 200 AS QTY200
                                                      , 201 AS QTY201, 202 AS QTY202, 203 AS QTY203, 204 AS QTY204, 205 AS QTY205, 206 AS QTY206, 207 AS QTY207, 208 AS QTY208, 209 AS QTY209, 210 AS QTY210
                                                      , 211 AS QTY211, 212 AS QTY212, 213 AS QTY213, 214 AS QTY214, 215 AS QTY215, 216 AS QTY216, 217 AS QTY217, 218 AS QTY218, 219 AS QTY219, 220 AS QTY220
                                                      , 221 AS QTY221, 222 AS QTY222, 223 AS QTY223, 224 AS QTY224, 225 AS QTY225, 226 AS QTY226, 227 AS QTY227, 228 AS QTY228, 229 AS QTY229, 230 AS QTY230
                                                      , 231 AS QTY231, 232 AS QTY232, 233 AS QTY233, 234 AS QTY234, 235 AS QTY235, 236 AS QTY236, 237 AS QTY237, 238 AS QTY238, 239 AS QTY239, 240 AS QTY240
                                                      , 241 AS QTY241, 242 AS QTY242, 243 AS QTY243, 244 AS QTY244, 245 AS QTY245, 246 AS QTY246, 247 AS QTY247, 248 AS QTY248, 249 AS QTY249, 250 AS QTY250
                                                      , 251 AS QTY251, 252 AS QTY252, 253 AS QTY253, 254 AS QTY254, 255 AS QTY255, 256 AS QTY256, 257 AS QTY257, 258 AS QTY258, 259 AS QTY259, 260 AS QTY260
                                                      , 261 AS QTY261, 262 AS QTY262, 263 AS QTY263, 264 AS QTY264, 265 AS QTY265, 266 AS QTY266, 267 AS QTY267, 268 AS QTY268, 269 AS QTY269, 270 AS QTY270
                                                      , 271 AS QTY271, 272 AS QTY272, 273 AS QTY273, 274 AS QTY274, 275 AS QTY275, 276 AS QTY276, 277 AS QTY277, 278 AS QTY278, 279 AS QTY279, 280 AS QTY280
                                                      , 281 AS QTY281, 282 AS QTY282, 283 AS QTY283, 284 AS QTY284, 285 AS QTY285, 286 AS QTY286, 287 AS QTY287, 288 AS QTY288, 289 AS QTY289, 290 AS QTY290
                                                      , 291 AS QTY291, 292 AS QTY292, 293 AS QTY293, 294 AS QTY294, 295 AS QTY295, 296 AS QTY296, 297 AS QTY297, 298 AS QTY298, 299 AS QTY299, 300 AS QTY300
                                                      , 301 AS QTY301, 302 AS QTY302, 303 AS QTY303, 304 AS QTY304, 305 AS QTY305, 306 AS QTY306, 307 AS QTY307, 308 AS QTY308, 309 AS QTY309, 310 AS QTY310
                                                      , 311 AS QTY311, 312 AS QTY312, 313 AS QTY313, 314 AS QTY314, 315 AS QTY315, 316 AS QTY316, 317 AS QTY317, 318 AS QTY318, 319 AS QTY319, 320 AS QTY320
                                                      , 321 AS QTY321, 322 AS QTY322, 323 AS QTY323, 324 AS QTY324, 325 AS QTY325, 326 AS QTY326, 327 AS QTY327, 328 AS QTY328, 329 AS QTY329, 330 AS QTY330
                                                      , 331 AS QTY331, 332 AS QTY332, 333 AS QTY333, 334 AS QTY334, 335 AS QTY335, 336 AS QTY336, 337 AS QTY337, 338 AS QTY338, 339 AS QTY339, 340 AS QTY340
                                                      , 341 AS QTY341, 342 AS QTY342, 343 AS QTY343, 344 AS QTY344, 345 AS QTY345, 346 AS QTY346, 347 AS QTY347, 348 AS QTY348, 349 AS QTY349, 350 AS QTY350
                                                      , 351 AS QTY351, 352 AS QTY352, 353 AS QTY353, 354 AS QTY354, 355 AS QTY355, 356 AS QTY356, 357 AS QTY357, 358 AS QTY358, 359 AS QTY359, 360 AS QTY360
                                                      , 361 AS QTY361, 362 AS QTY362, 363 AS QTY363, 364 AS QTY364
                                                                      )
                                            ) P
                                   ) S
                             GROUP BY S.XLS_KEY
                           ) W
                       ON ( 0 = 0
                        AND E.XLS_KEY1              = W.XLS_KEY
                        AND E.DIVISION_ID           = V_BATCH_DIVISION_ID
                        AND E.PLAN_START_YYYYMMDD   = V_BATCH_PLAN_START_YYYYMMDD
                        AND E.CREATE_FROM_YYYYMMDD  = V_BATCH_CREATE_FROM_YYYYMMDD
                        AND E.SEQ                   = V_BATCH_SEQ
                        AND E.XLS_KEY1              = V_BATCH_XLS_KEY1 )

                     WHEN MATCHED THEN
                     UPDATE
                        SET E.QTY001 = W.QTY001
                            , E.QTY002 = W.QTY002, E.QTY003 = W.QTY003, E.QTY004 = W.QTY004, E.QTY005 = W.QTY005, E.QTY006 = W.QTY006
                            , E.QTY007 = W.QTY007, E.QTY008 = W.QTY008, E.QTY009 = W.QTY009, E.QTY010 = W.QTY010, E.QTY011 = W.QTY011
                            , E.QTY012 = W.QTY012, E.QTY013 = W.QTY013, E.QTY014 = W.QTY014, E.QTY015 = W.QTY015, E.QTY016 = W.QTY016
                            , E.QTY017 = W.QTY017, E.QTY018 = W.QTY018, E.QTY019 = W.QTY019, E.QTY020 = W.QTY020, E.QTY021 = W.QTY021
                            , E.QTY022 = W.QTY022, E.QTY023 = W.QTY023, E.QTY024 = W.QTY024, E.QTY025 = W.QTY025, E.QTY026 = W.QTY026
                            , E.QTY027 = W.QTY027, E.QTY028 = W.QTY028, E.QTY029 = W.QTY029, E.QTY030 = W.QTY030, E.QTY031 = W.QTY031
                            , E.QTY032 = W.QTY032, E.QTY033 = W.QTY033, E.QTY034 = W.QTY034, E.QTY035 = W.QTY035, E.QTY036 = W.QTY036
                            , E.QTY037 = W.QTY037, E.QTY038 = W.QTY038, E.QTY039 = W.QTY039, E.QTY040 = W.QTY040, E.QTY041 = W.QTY041
                            , E.QTY042 = W.QTY042, E.QTY043 = W.QTY043, E.QTY044 = W.QTY044, E.QTY045 = W.QTY045, E.QTY046 = W.QTY046
                            , E.QTY047 = W.QTY047, E.QTY048 = W.QTY048, E.QTY049 = W.QTY049, E.QTY050 = W.QTY050, E.QTY051 = W.QTY051
                            , E.QTY052 = W.QTY052, E.QTY053 = W.QTY053, E.QTY054 = W.QTY054, E.QTY055 = W.QTY055, E.QTY056 = W.QTY056
                            , E.QTY057 = W.QTY057, E.QTY058 = W.QTY058, E.QTY059 = W.QTY059, E.QTY060 = W.QTY060, E.QTY061 = W.QTY061
                            , E.QTY062 = W.QTY062, E.QTY063 = W.QTY063, E.QTY064 = W.QTY064, E.QTY065 = W.QTY065, E.QTY066 = W.QTY066
                            , E.QTY067 = W.QTY067, E.QTY068 = W.QTY068, E.QTY069 = W.QTY069, E.QTY070 = W.QTY070, E.QTY071 = W.QTY071
                            , E.QTY072 = W.QTY072, E.QTY073 = W.QTY073, E.QTY074 = W.QTY074, E.QTY075 = W.QTY075, E.QTY076 = W.QTY076
                            , E.QTY077 = W.QTY077, E.QTY078 = W.QTY078, E.QTY079 = W.QTY079, E.QTY080 = W.QTY080, E.QTY081 = W.QTY081
                            , E.QTY082 = W.QTY082, E.QTY083 = W.QTY083, E.QTY084 = W.QTY084, E.QTY085 = W.QTY085, E.QTY086 = W.QTY086
                            , E.QTY087 = W.QTY087, E.QTY088 = W.QTY088, E.QTY089 = W.QTY089, E.QTY090 = W.QTY090, E.QTY091 = W.QTY091
                            , E.QTY092 = W.QTY092, E.QTY093 = W.QTY093, E.QTY094 = W.QTY094, E.QTY095 = W.QTY095, E.QTY096 = W.QTY096
                            , E.QTY097 = W.QTY097, E.QTY098 = W.QTY098, E.QTY099 = W.QTY099, E.QTY100 = W.QTY100, E.QTY101 = W.QTY101
                            , E.QTY102 = W.QTY102, E.QTY103 = W.QTY103, E.QTY104 = W.QTY104, E.QTY105 = W.QTY105, E.QTY106 = W.QTY106
                            , E.QTY107 = W.QTY107, E.QTY108 = W.QTY108, E.QTY109 = W.QTY109, E.QTY110 = W.QTY110, E.QTY111 = W.QTY111
                            , E.QTY112 = W.QTY112, E.QTY113 = W.QTY113, E.QTY114 = W.QTY114, E.QTY115 = W.QTY115, E.QTY116 = W.QTY116
                            , E.QTY117 = W.QTY117, E.QTY118 = W.QTY118, E.QTY119 = W.QTY119, E.QTY120 = W.QTY120, E.QTY121 = W.QTY121
                            , E.QTY122 = W.QTY122, E.QTY123 = W.QTY123, E.QTY124 = W.QTY124, E.QTY125 = W.QTY125, E.QTY126 = W.QTY126
                            , E.QTY127 = W.QTY127, E.QTY128 = W.QTY128, E.QTY129 = W.QTY129, E.QTY130 = W.QTY130, E.QTY131 = W.QTY131
                            , E.QTY132 = W.QTY132, E.QTY133 = W.QTY133, E.QTY134 = W.QTY134, E.QTY135 = W.QTY135, E.QTY136 = W.QTY136
                            , E.QTY137 = W.QTY137, E.QTY138 = W.QTY138, E.QTY139 = W.QTY139, E.QTY140 = W.QTY140, E.QTY141 = W.QTY141
                            , E.QTY142 = W.QTY142, E.QTY143 = W.QTY143, E.QTY144 = W.QTY144, E.QTY145 = W.QTY145, E.QTY146 = W.QTY146
                            , E.QTY147 = W.QTY147, E.QTY148 = W.QTY148, E.QTY149 = W.QTY149, E.QTY150 = W.QTY150, E.QTY151 = W.QTY151
                            , E.QTY152 = W.QTY152, E.QTY153 = W.QTY153, E.QTY154 = W.QTY154, E.QTY155 = W.QTY155, E.QTY156 = W.QTY156
                            , E.QTY157 = W.QTY157, E.QTY158 = W.QTY158, E.QTY159 = W.QTY159, E.QTY160 = W.QTY160, E.QTY161 = W.QTY161
                            , E.QTY162 = W.QTY162, E.QTY163 = W.QTY163, E.QTY164 = W.QTY164, E.QTY165 = W.QTY165, E.QTY166 = W.QTY166
                            , E.QTY167 = W.QTY167, E.QTY168 = W.QTY168, E.QTY169 = W.QTY169, E.QTY170 = W.QTY170, E.QTY171 = W.QTY171
                            , E.QTY172 = W.QTY172, E.QTY173 = W.QTY173, E.QTY174 = W.QTY174, E.QTY175 = W.QTY175, E.QTY176 = W.QTY176
                            , E.QTY177 = W.QTY177, E.QTY178 = W.QTY178, E.QTY179 = W.QTY179, E.QTY180 = W.QTY180, E.QTY181 = W.QTY181
                            , E.QTY182 = W.QTY182, E.QTY183 = W.QTY183, E.QTY184 = W.QTY184, E.QTY185 = W.QTY185, E.QTY186 = W.QTY186
                            , E.QTY187 = W.QTY187, E.QTY188 = W.QTY188, E.QTY189 = W.QTY189, E.QTY190 = W.QTY190, E.QTY191 = W.QTY191
                            , E.QTY192 = W.QTY192, E.QTY193 = W.QTY193, E.QTY194 = W.QTY194, E.QTY195 = W.QTY195, E.QTY196 = W.QTY196
                            , E.QTY197 = W.QTY197, E.QTY198 = W.QTY198, E.QTY199 = W.QTY199, E.QTY200 = W.QTY200, E.QTY201 = W.QTY201
                            , E.QTY202 = W.QTY202, E.QTY203 = W.QTY203, E.QTY204 = W.QTY204, E.QTY205 = W.QTY205, E.QTY206 = W.QTY206
                            , E.QTY207 = W.QTY207, E.QTY208 = W.QTY208, E.QTY209 = W.QTY209, E.QTY210 = W.QTY210, E.QTY211 = W.QTY211
                            , E.QTY212 = W.QTY212, E.QTY213 = W.QTY213, E.QTY214 = W.QTY214, E.QTY215 = W.QTY215, E.QTY216 = W.QTY216
                            , E.QTY217 = W.QTY217, E.QTY218 = W.QTY218, E.QTY219 = W.QTY219, E.QTY220 = W.QTY220, E.QTY221 = W.QTY221
                            , E.QTY222 = W.QTY222, E.QTY223 = W.QTY223, E.QTY224 = W.QTY224, E.QTY225 = W.QTY225, E.QTY226 = W.QTY226
                            , E.QTY227 = W.QTY227, E.QTY228 = W.QTY228, E.QTY229 = W.QTY229, E.QTY230 = W.QTY230, E.QTY231 = W.QTY231
                            , E.QTY232 = W.QTY232, E.QTY233 = W.QTY233, E.QTY234 = W.QTY234, E.QTY235 = W.QTY235, E.QTY236 = W.QTY236
                            , E.QTY237 = W.QTY237, E.QTY238 = W.QTY238, E.QTY239 = W.QTY239, E.QTY240 = W.QTY240, E.QTY241 = W.QTY241
                            , E.QTY242 = W.QTY242, E.QTY243 = W.QTY243, E.QTY244 = W.QTY244, E.QTY245 = W.QTY245, E.QTY246 = W.QTY246
                            , E.QTY247 = W.QTY247, E.QTY248 = W.QTY248, E.QTY249 = W.QTY249, E.QTY250 = W.QTY250, E.QTY251 = W.QTY251
                            , E.QTY252 = W.QTY252, E.QTY253 = W.QTY253, E.QTY254 = W.QTY254, E.QTY255 = W.QTY255, E.QTY256 = W.QTY256
                            , E.QTY257 = W.QTY257, E.QTY258 = W.QTY258, E.QTY259 = W.QTY259, E.QTY260 = W.QTY260, E.QTY261 = W.QTY261
                            , E.QTY262 = W.QTY262, E.QTY263 = W.QTY263, E.QTY264 = W.QTY264, E.QTY265 = W.QTY265, E.QTY266 = W.QTY266
                            , E.QTY267 = W.QTY267, E.QTY268 = W.QTY268, E.QTY269 = W.QTY269, E.QTY270 = W.QTY270, E.QTY271 = W.QTY271
                            , E.QTY272 = W.QTY272, E.QTY273 = W.QTY273, E.QTY274 = W.QTY274, E.QTY275 = W.QTY275, E.QTY276 = W.QTY276
                            , E.QTY277 = W.QTY277, E.QTY278 = W.QTY278, E.QTY279 = W.QTY279, E.QTY280 = W.QTY280, E.QTY281 = W.QTY281
                            , E.QTY282 = W.QTY282, E.QTY283 = W.QTY283, E.QTY284 = W.QTY284, E.QTY285 = W.QTY285, E.QTY286 = W.QTY286
                            , E.QTY287 = W.QTY287, E.QTY288 = W.QTY288, E.QTY289 = W.QTY289, E.QTY290 = W.QTY290, E.QTY291 = W.QTY291
                            , E.QTY292 = W.QTY292, E.QTY293 = W.QTY293, E.QTY294 = W.QTY294, E.QTY295 = W.QTY295, E.QTY296 = W.QTY296
                            , E.QTY297 = W.QTY297, E.QTY298 = W.QTY298, E.QTY299 = W.QTY299, E.QTY300 = W.QTY300, E.QTY301 = W.QTY301
                            , E.QTY302 = W.QTY302, E.QTY303 = W.QTY303, E.QTY304 = W.QTY304, E.QTY305 = W.QTY305, E.QTY306 = W.QTY306
                            , E.QTY307 = W.QTY307, E.QTY308 = W.QTY308, E.QTY309 = W.QTY309, E.QTY310 = W.QTY310, E.QTY311 = W.QTY311
                            , E.QTY312 = W.QTY312, E.QTY313 = W.QTY313, E.QTY314 = W.QTY314, E.QTY315 = W.QTY315, E.QTY316 = W.QTY316
                            , E.QTY317 = W.QTY317, E.QTY318 = W.QTY318, E.QTY319 = W.QTY319, E.QTY320 = W.QTY320, E.QTY321 = W.QTY321
                            , E.QTY322 = W.QTY322, E.QTY323 = W.QTY323, E.QTY324 = W.QTY324, E.QTY325 = W.QTY325, E.QTY326 = W.QTY326
                            , E.QTY327 = W.QTY327, E.QTY328 = W.QTY328, E.QTY329 = W.QTY329, E.QTY330 = W.QTY330, E.QTY331 = W.QTY331
                            , E.QTY332 = W.QTY332, E.QTY333 = W.QTY333, E.QTY334 = W.QTY334, E.QTY335 = W.QTY335, E.QTY336 = W.QTY336
                            , E.QTY337 = W.QTY337, E.QTY338 = W.QTY338, E.QTY339 = W.QTY339, E.QTY340 = W.QTY340, E.QTY341 = W.QTY341
                            , E.QTY342 = W.QTY342, E.QTY343 = W.QTY343, E.QTY344 = W.QTY344, E.QTY345 = W.QTY345, E.QTY346 = W.QTY346
                            , E.QTY347 = W.QTY347, E.QTY348 = W.QTY348, E.QTY349 = W.QTY349, E.QTY350 = W.QTY350, E.QTY351 = W.QTY351
                            , E.QTY352 = W.QTY352, E.QTY353 = W.QTY353, E.QTY354 = W.QTY354, E.QTY355 = W.QTY355, E.QTY356 = W.QTY356
                            , E.QTY357 = W.QTY357, E.QTY358 = W.QTY358, E.QTY359 = W.QTY359, E.QTY360 = W.QTY360, E.QTY361 = W.QTY361
                            , E.QTY362 = W.QTY362, E.QTY363 = W.QTY363, E.QTY364 = W.QTY364

                            , WQTY01 = P_WQTY01, WQTY02 = P_WQTY02, WQTY03 = P_WQTY03, WQTY04 = P_WQTY04, WQTY05 = P_WQTY05
                            , WQTY06 = P_WQTY06, WQTY07 = P_WQTY07, WQTY08 = P_WQTY08, WQTY09 = P_WQTY09, WQTY10 = P_WQTY10
                            , WQTY11 = P_WQTY11, WQTY12 = P_WQTY12, WQTY13 = P_WQTY13, WQTY14 = P_WQTY14, WQTY15 = P_WQTY15
                            , WQTY16 = P_WQTY16, WQTY17 = P_WQTY17, WQTY18 = P_WQTY18, WQTY19 = P_WQTY19, WQTY20 = P_WQTY20
                            , WQTY21 = P_WQTY21, WQTY22 = P_WQTY22, WQTY23 = P_WQTY23, WQTY24 = P_WQTY24, WQTY25 = P_WQTY25
                            , WQTY26 = P_WQTY26, WQTY27 = P_WQTY27, WQTY28 = P_WQTY28, WQTY29 = P_WQTY29, WQTY30 = P_WQTY30
                            , WQTY31 = P_WQTY31, WQTY32 = P_WQTY32, WQTY33 = P_WQTY33, WQTY34 = P_WQTY34, WQTY35 = P_WQTY35
                            , WQTY36 = P_WQTY36, WQTY37 = P_WQTY37, WQTY38 = P_WQTY38, WQTY39 = P_WQTY39, WQTY40 = P_WQTY40
                            , WQTY41 = P_WQTY41, WQTY42 = P_WQTY42, WQTY43 = P_WQTY43, WQTY44 = P_WQTY44, WQTY45 = P_WQTY45
                            , WQTY46 = P_WQTY46, WQTY47 = P_WQTY47, WQTY48 = P_WQTY48, WQTY49 = P_WQTY49, WQTY50 = P_WQTY50
                            , WQTY51 = P_WQTY51, WQTY52 = P_WQTY52
                          , LAST_UPDATED_BY    = V_BATCH_USER_ID
                          , LAST_UPDATE_DATE   = SYSDATE
                          , ATTRIBUTE2         = 'Y'
                         ;

                    /*  IF OBJECT_ID('tempdb..#WORKING_TBL_TEMP') IS NOT NULL DROP TABLE #WORKING_TBL_TEMP; */
                    DELETE FROM GT_XPGT_WORKING_TBL_TEMP;

                    /*  IF OBJECT_ID('tempdb..#WORKING_TBL') IS NOT NULL DROP TABLE #WORKING_TBL; */
                    DELETE FROM GT_XPGT_WORKING_TBL;

                    /*  IF OBJECT_ID('tempdb..#WEEK_QTY_TBL') IS NOT NULL DROP TABLE #WEEK_QTY_TBL; */
                    DELETE FROM GT_XPGT_WEEK_QTY_TBL;


                    /* ▼ MSSQL 원본 L979~L1050 원문 보존 ('분배된 수량 Update' 死코드) ---------------------------------------------

                                            분배된 수량 Update

                                           UPDATE DBO.SCP_XLS_PSI_GLOBAL_ESS
                                               SET
                                                    QTY001 = @p_WQTY01/7 ,QTY002  = @p_WQTY01/7  ,QTY003 = @p_WQTY01/7 ,QTY004 = @p_WQTY01/7 ,QTY005  = @p_WQTY01/7 ,QTY006  = @p_WQTY01/7 ,QTY007 = ((@p_WQTY01/7)+(@p_WQTY01%7))
                                                   ,QTY008 = @p_WQTY02/7 ,QTY009  = @p_WQTY02/7  ,QTY010 = @p_WQTY02/7 ,QTY011 = @p_WQTY02/7 ,QTY012  = @p_WQTY02/7 ,QTY013  = @p_WQTY02/7 ,QTY014 = ((@p_WQTY02/7)+(@p_WQTY02%7))
                                                   ,QTY015 = @p_WQTY03/7 ,QTY016  = @p_WQTY03/7  ,QTY017 = @p_WQTY03/7 ,QTY018 = @p_WQTY03/7 ,QTY019  = @p_WQTY03/7 ,QTY020  = @p_WQTY03/7 ,QTY021 = ((@p_WQTY03/7)+(@p_WQTY03%7))
                                                   ,QTY022 = @p_WQTY04/7 ,QTY023  = @p_WQTY04/7  ,QTY024 = @p_WQTY04/7 ,QTY025 = @p_WQTY04/7 ,QTY026  = @p_WQTY04/7 ,QTY027  = @p_WQTY04/7 ,QTY028 = ((@p_WQTY04/7)+(@p_WQTY04%7))
                                                   ,QTY029 = @p_WQTY05/7 ,QTY030  = @p_WQTY05/7  ,QTY031 = @p_WQTY05/7 ,QTY032 = @p_WQTY05/7 ,QTY033  = @p_WQTY05/7 ,QTY034  = @p_WQTY05/7 ,QTY035 = ((@p_WQTY05/7)+(@p_WQTY05%7))
                                                   ,QTY036 = @p_WQTY06/7 ,QTY037  = @p_WQTY06/7  ,QTY038 = @p_WQTY06/7 ,QTY039 = @p_WQTY06/7 ,QTY040  = @p_WQTY06/7 ,QTY041  = @p_WQTY06/7 ,QTY042 = ((@p_WQTY06/7)+(@p_WQTY06%7))
                                                   ,QTY043 = @p_WQTY07/7 ,QTY044  = @p_WQTY07/7  ,QTY045 = @p_WQTY07/7 ,QTY046 = @p_WQTY07/7 ,QTY047  = @p_WQTY07/7 ,QTY048  = @p_WQTY07/7 ,QTY049 = ((@p_WQTY07/7)+(@p_WQTY07%7))
                                                   ,QTY050 = @p_WQTY08/7 ,QTY051  = @p_WQTY08/7  ,QTY052 = @p_WQTY08/7 ,QTY053 = @p_WQTY08/7 ,QTY054  = @p_WQTY08/7 ,QTY055  = @p_WQTY08/7 ,QTY056 = ((@p_WQTY08/7)+(@p_WQTY08%7))
                                                   ,QTY057 = @p_WQTY09/7 ,QTY058  = @p_WQTY09/7  ,QTY059 = @p_WQTY09/7 ,QTY060 = @p_WQTY09/7 ,QTY061  = @p_WQTY09/7 ,QTY062  = @p_WQTY09/7 ,QTY063 = ((@p_WQTY09/7)+(@p_WQTY09%7))
                                                   ,QTY064 = @p_WQTY10/7 ,QTY065  = @p_WQTY10/7  ,QTY066 = @p_WQTY10/7 ,QTY067 = @p_WQTY10/7 ,QTY068  = @p_WQTY10/7 ,QTY069  = @p_WQTY10/7 ,QTY070 = ((@p_WQTY10/7)+(@p_WQTY10%7))
                                                   ,QTY071 = @p_WQTY11/7 ,QTY072  = @p_WQTY11/7  ,QTY073 = @p_WQTY11/7 ,QTY074 = @p_WQTY11/7 ,QTY075  = @p_WQTY11/7 ,QTY076  = @p_WQTY11/7 ,QTY077 = ((@p_WQTY11/7)+(@p_WQTY11%7))
                                                   ,QTY078 = @p_WQTY12/7 ,QTY079  = @p_WQTY12/7  ,QTY080 = @p_WQTY12/7 ,QTY081 = @p_WQTY12/7 ,QTY082  = @p_WQTY12/7 ,QTY083  = @p_WQTY12/7 ,QTY084 = ((@p_WQTY12/7)+(@p_WQTY12%7))
                                                   ,QTY085 = @p_WQTY13/7 ,QTY086  = @p_WQTY13/7  ,QTY087 = @p_WQTY13/7 ,QTY088 = @p_WQTY13/7 ,QTY089  = @p_WQTY13/7 ,QTY090  = @p_WQTY13/7 ,QTY091 = ((@p_WQTY13/7)+(@p_WQTY13%7))
                                                   ,QTY092 = @p_WQTY14/7 ,QTY093  = @p_WQTY14/7  ,QTY094 = @p_WQTY14/7 ,QTY095 = @p_WQTY14/7 ,QTY096  = @p_WQTY14/7 ,QTY097  = @p_WQTY14/7 ,QTY098 = ((@p_WQTY14/7)+(@p_WQTY14%7))
                                                   ,QTY099 = @p_WQTY15/7 ,QTY100  = @p_WQTY15/7  ,QTY101 = @p_WQTY15/7 ,QTY102 = @p_WQTY15/7 ,QTY103  = @p_WQTY15/7 ,QTY104  = @p_WQTY15/7 ,QTY105 = ((@p_WQTY15/7)+(@p_WQTY15%7))
                                                   ,QTY106 = @p_WQTY16/7 ,QTY107  = @p_WQTY16/7  ,QTY108 = @p_WQTY16/7 ,QTY109 = @p_WQTY16/7 ,QTY110  = @p_WQTY16/7 ,QTY111  = @p_WQTY16/7 ,QTY112 = ((@p_WQTY16/7)+(@p_WQTY16%7))
                                                   ,QTY113 = @p_WQTY17/7 ,QTY114  = @p_WQTY17/7  ,QTY115 = @p_WQTY17/7 ,QTY116 = @p_WQTY17/7 ,QTY117  = @p_WQTY17/7 ,QTY118  = @p_WQTY17/7 ,QTY119 = ((@p_WQTY17/7)+(@p_WQTY17%7))
                                                   ,QTY120 = @p_WQTY18/7 ,QTY121  = @p_WQTY18/7  ,QTY122 = @p_WQTY18/7 ,QTY123 = @p_WQTY18/7 ,QTY124  = @p_WQTY18/7 ,QTY125  = @p_WQTY18/7 ,QTY126 = ((@p_WQTY18/7)+(@p_WQTY18%7))
                                                   ,QTY127 = @p_WQTY19/7 ,QTY128  = @p_WQTY19/7  ,QTY129 = @p_WQTY19/7 ,QTY130 = @p_WQTY19/7 ,QTY131  = @p_WQTY19/7 ,QTY132  = @p_WQTY19/7 ,QTY133 = ((@p_WQTY19/7)+(@p_WQTY19%7))
                                                   ,QTY134 = @p_WQTY20/7 ,QTY135  = @p_WQTY20/7  ,QTY136 = @p_WQTY20/7 ,QTY137 = @p_WQTY20/7 ,QTY138  = @p_WQTY20/7 ,QTY139  = @p_WQTY20/7 ,QTY140 = ((@p_WQTY20/7)+(@p_WQTY20%7))
                                                   ,QTY141 = @p_WQTY21/7 ,QTY142  = @p_WQTY21/7  ,QTY143 = @p_WQTY21/7 ,QTY144 = @p_WQTY21/7 ,QTY145  = @p_WQTY21/7 ,QTY146  = @p_WQTY21/7 ,QTY147 = ((@p_WQTY21/7)+(@p_WQTY21%7))
                                                   ,QTY148 = @p_WQTY22/7 ,QTY149  = @p_WQTY22/7  ,QTY150 = @p_WQTY22/7 ,QTY151 = @p_WQTY22/7 ,QTY152  = @p_WQTY22/7 ,QTY153  = @p_WQTY22/7 ,QTY154 = ((@p_WQTY22/7)+(@p_WQTY22%7))
                                                   ,QTY155 = @p_WQTY23/7 ,QTY156  = @p_WQTY23/7  ,QTY157 = @p_WQTY23/7 ,QTY158 = @p_WQTY23/7 ,QTY159  = @p_WQTY23/7 ,QTY160  = @p_WQTY23/7 ,QTY161 = ((@p_WQTY23/7)+(@p_WQTY23%7))
                                                   ,QTY162 = @p_WQTY24/7 ,QTY163  = @p_WQTY24/7  ,QTY164 = @p_WQTY24/7 ,QTY165 = @p_WQTY24/7 ,QTY166  = @p_WQTY24/7 ,QTY167  = @p_WQTY24/7 ,QTY168 = ((@p_WQTY24/7)+(@p_WQTY24%7))
                                                   ,QTY169 = @p_WQTY25/7 ,QTY170  = @p_WQTY25/7  ,QTY171 = @p_WQTY25/7 ,QTY172 = @p_WQTY25/7 ,QTY173  = @p_WQTY25/7 ,QTY174  = @p_WQTY25/7 ,QTY175 = ((@p_WQTY25/7)+(@p_WQTY25%7))
                                                   ,QTY176 = @p_WQTY26/7 ,QTY177  = @p_WQTY26/7  ,QTY178 = @p_WQTY26/7 ,QTY179 = @p_WQTY26/7 ,QTY180  = @p_WQTY26/7 ,QTY181  = @p_WQTY26/7 ,QTY182 = ((@p_WQTY26/7)+(@p_WQTY26%7))
                                                   ,QTY183 = @p_WQTY27/7 ,QTY184  = @p_WQTY27/7  ,QTY185 = @p_WQTY27/7 ,QTY186 = @p_WQTY27/7 ,QTY187  = @p_WQTY27/7 ,QTY188  = @p_WQTY27/7 ,QTY189 = ((@p_WQTY27/7)+(@p_WQTY27%7))
                                                   ,QTY190 = @p_WQTY28/7 ,QTY191  = @p_WQTY28/7  ,QTY192 = @p_WQTY28/7 ,QTY193 = @p_WQTY28/7 ,QTY194  = @p_WQTY28/7 ,QTY195  = @p_WQTY28/7 ,QTY196 = ((@p_WQTY28/7)+(@p_WQTY28%7))
                                                   ,QTY197 = @p_WQTY29/7 ,QTY198  = @p_WQTY29/7  ,QTY199 = @p_WQTY29/7 ,QTY200 = @p_WQTY29/7 ,QTY201  = @p_WQTY29/7 ,QTY202  = @p_WQTY29/7 ,QTY203 = ((@p_WQTY29/7)+(@p_WQTY29%7))
                                                   ,QTY204 = @p_WQTY30/7 ,QTY205  = @p_WQTY30/7  ,QTY206 = @p_WQTY30/7 ,QTY207 = @p_WQTY30/7 ,QTY208  = @p_WQTY30/7 ,QTY209  = @p_WQTY30/7 ,QTY210 = ((@p_WQTY30/7)+(@p_WQTY30%7))
                                                   ,QTY211 = @p_WQTY31/7 ,QTY212  = @p_WQTY31/7  ,QTY213 = @p_WQTY31/7 ,QTY214 = @p_WQTY31/7 ,QTY215  = @p_WQTY31/7 ,QTY216  = @p_WQTY31/7 ,QTY217 = ((@p_WQTY31/7)+(@p_WQTY31%7))
                                                   ,QTY218 = @p_WQTY32/7 ,QTY219  = @p_WQTY32/7  ,QTY220 = @p_WQTY32/7 ,QTY221 = @p_WQTY32/7 ,QTY222  = @p_WQTY32/7 ,QTY223  = @p_WQTY32/7 ,QTY224 = ((@p_WQTY32/7)+(@p_WQTY32%7))
                                                   ,QTY225 = @p_WQTY33/7 ,QTY226  = @p_WQTY33/7  ,QTY227 = @p_WQTY33/7 ,QTY228 = @p_WQTY33/7 ,QTY229  = @p_WQTY33/7 ,QTY230  = @p_WQTY33/7 ,QTY231 = ((@p_WQTY33/7)+(@p_WQTY33%7))
                                                   ,QTY232 = @p_WQTY34/7 ,QTY233  = @p_WQTY34/7  ,QTY234 = @p_WQTY34/7 ,QTY235 = @p_WQTY34/7 ,QTY236  = @p_WQTY34/7 ,QTY237  = @p_WQTY34/7 ,QTY238 = ((@p_WQTY34/7)+(@p_WQTY34%7))
                                                   ,QTY239 = @p_WQTY35/7 ,QTY240  = @p_WQTY35/7  ,QTY241 = @p_WQTY35/7 ,QTY242 = @p_WQTY35/7 ,QTY243  = @p_WQTY35/7 ,QTY244  = @p_WQTY35/7 ,QTY245 = ((@p_WQTY35/7)+(@p_WQTY35%7))
                                                   ,QTY246 = @p_WQTY36/7 ,QTY247  = @p_WQTY36/7  ,QTY248 = @p_WQTY36/7 ,QTY249 = @p_WQTY36/7 ,QTY250  = @p_WQTY36/7 ,QTY251  = @p_WQTY36/7 ,QTY252 = ((@p_WQTY36/7)+(@p_WQTY36%7))
                                                   ,QTY253 = @p_WQTY37/7 ,QTY254  = @p_WQTY37/7  ,QTY255 = @p_WQTY37/7 ,QTY256 = @p_WQTY37/7 ,QTY257  = @p_WQTY37/7 ,QTY258  = @p_WQTY37/7 ,QTY259 = ((@p_WQTY37/7)+(@p_WQTY37%7))
                                                   ,QTY260 = @p_WQTY38/7 ,QTY261  = @p_WQTY38/7  ,QTY262 = @p_WQTY38/7 ,QTY263 = @p_WQTY38/7 ,QTY264  = @p_WQTY38/7 ,QTY265  = @p_WQTY38/7 ,QTY266 = ((@p_WQTY38/7)+(@p_WQTY38%7))
                                                   ,QTY267 = @p_WQTY39/7 ,QTY268  = @p_WQTY39/7  ,QTY269 = @p_WQTY39/7 ,QTY270 = @p_WQTY39/7 ,QTY271  = @p_WQTY39/7 ,QTY272  = @p_WQTY39/7 ,QTY273 = ((@p_WQTY39/7)+(@p_WQTY39%7))
                                                   ,QTY274 = @p_WQTY40/7 ,QTY275  = @p_WQTY40/7  ,QTY276 = @p_WQTY40/7 ,QTY277 = @p_WQTY40/7 ,QTY278  = @p_WQTY40/7 ,QTY279  = @p_WQTY40/7 ,QTY280 = ((@p_WQTY40/7)+(@p_WQTY40%7))
                                                   ,QTY281 = @p_WQTY41/7 ,QTY282  = @p_WQTY41/7  ,QTY283 = @p_WQTY41/7 ,QTY284 = @p_WQTY41/7 ,QTY285  = @p_WQTY41/7 ,QTY286  = @p_WQTY41/7 ,QTY287 = ((@p_WQTY41/7)+(@p_WQTY41%7))
                                                   ,QTY288 = @p_WQTY42/7 ,QTY289  = @p_WQTY42/7  ,QTY290 = @p_WQTY42/7 ,QTY291 = @p_WQTY42/7 ,QTY292  = @p_WQTY42/7 ,QTY293  = @p_WQTY42/7 ,QTY294 = ((@p_WQTY42/7)+(@p_WQTY42%7))
                                                   ,QTY295 = @p_WQTY43/7 ,QTY296  = @p_WQTY43/7  ,QTY297 = @p_WQTY43/7 ,QTY298 = @p_WQTY43/7 ,QTY299  = @p_WQTY43/7 ,QTY300  = @p_WQTY43/7 ,QTY301 = ((@p_WQTY43/7)+(@p_WQTY43%7))
                                                   ,QTY302 = @p_WQTY44/7 ,QTY303  = @p_WQTY44/7  ,QTY304 = @p_WQTY44/7 ,QTY305 = @p_WQTY44/7 ,QTY306  = @p_WQTY44/7 ,QTY307  = @p_WQTY44/7 ,QTY308 = ((@p_WQTY44/7)+(@p_WQTY44%7))
                                                   ,QTY309 = @p_WQTY45/7 ,QTY310  = @p_WQTY45/7  ,QTY311 = @p_WQTY45/7 ,QTY312 = @p_WQTY45/7 ,QTY313  = @p_WQTY45/7 ,QTY314  = @p_WQTY45/7 ,QTY315 = ((@p_WQTY45/7)+(@p_WQTY45%7))
                                                   ,QTY316 = @p_WQTY46/7 ,QTY317  = @p_WQTY46/7  ,QTY318 = @p_WQTY46/7 ,QTY319 = @p_WQTY46/7 ,QTY320  = @p_WQTY46/7 ,QTY321  = @p_WQTY46/7 ,QTY322 = ((@p_WQTY46/7)+(@p_WQTY46%7))
                                                   ,QTY323 = @p_WQTY47/7 ,QTY324  = @p_WQTY47/7  ,QTY325 = @p_WQTY47/7 ,QTY326 = @p_WQTY47/7 ,QTY327  = @p_WQTY47/7 ,QTY328  = @p_WQTY47/7 ,QTY329 = ((@p_WQTY47/7)+(@p_WQTY47%7))
                                                   ,QTY330 = @p_WQTY48/7 ,QTY331  = @p_WQTY48/7  ,QTY332 = @p_WQTY48/7 ,QTY333 = @p_WQTY48/7 ,QTY334  = @p_WQTY48/7 ,QTY335  = @p_WQTY48/7 ,QTY336 = ((@p_WQTY48/7)+(@p_WQTY48%7))
                                                   ,QTY337 = @p_WQTY49/7 ,QTY338  = @p_WQTY49/7  ,QTY339 = @p_WQTY49/7 ,QTY340 = @p_WQTY49/7 ,QTY341  = @p_WQTY49/7 ,QTY342  = @p_WQTY49/7 ,QTY343 = ((@p_WQTY49/7)+(@p_WQTY49%7))
                                                   ,QTY344 = @p_WQTY50/7 ,QTY345  = @p_WQTY50/7  ,QTY346 = @p_WQTY50/7 ,QTY347 = @p_WQTY50/7 ,QTY348  = @p_WQTY50/7 ,QTY349  = @p_WQTY50/7 ,QTY350 = ((@p_WQTY50/7)+(@p_WQTY50%7))
                                                   ,QTY351 = @p_WQTY51/7 ,QTY352  = @p_WQTY51/7  ,QTY353 = @p_WQTY51/7 ,QTY354 = @p_WQTY51/7 ,QTY355  = @p_WQTY51/7 ,QTY356  = @p_WQTY51/7 ,QTY357 = ((@p_WQTY51/7)+(@p_WQTY51%7))
                                                   ,QTY358 = @p_WQTY52/7 ,QTY359  = @p_WQTY52/7  ,QTY360 = @p_WQTY52/7 ,QTY361 = @p_WQTY52/7 ,QTY362  = @p_WQTY52/7 ,QTY363  = @p_WQTY52/7 ,QTY364 = ((@p_WQTY52/7)+(@p_WQTY52%7))

                                                   ,WQTY01 = @p_WQTY01  ,WQTY02  = @p_WQTY02  ,WQTY03  = @p_WQTY03  ,WQTY04  = @p_WQTY04  ,WQTY05  = @p_WQTY05  ,WQTY06  = @p_WQTY06  ,WQTY07  = @p_WQTY07  ,WQTY08  = @p_WQTY08  ,WQTY09  = @p_WQTY09  ,WQTY10  = @p_WQTY10
                                                   ,WQTY11 = @p_WQTY11  ,WQTY12  = @p_WQTY12  ,WQTY13  = @p_WQTY13  ,WQTY14  = @p_WQTY14  ,WQTY15  = @p_WQTY15  ,WQTY16  = @p_WQTY16  ,WQTY17  = @p_WQTY17  ,WQTY18  = @p_WQTY18  ,WQTY19  = @p_WQTY19  ,WQTY20  = @p_WQTY20
                                                   ,WQTY21 = @p_WQTY21  ,WQTY22  = @p_WQTY22  ,WQTY23  = @p_WQTY23  ,WQTY24  = @p_WQTY24  ,WQTY25  = @p_WQTY25  ,WQTY26  = @p_WQTY26  ,WQTY27  = @p_WQTY27  ,WQTY28  = @p_WQTY28  ,WQTY29  = @p_WQTY29  ,WQTY30  = @p_WQTY30
                                                   ,WQTY31 = @p_WQTY31  ,WQTY32  = @p_WQTY32  ,WQTY33  = @p_WQTY33  ,WQTY34  = @p_WQTY34  ,WQTY35  = @p_WQTY35  ,WQTY36  = @p_WQTY36  ,WQTY37  = @p_WQTY37  ,WQTY38  = @p_WQTY38  ,WQTY39  = @p_WQTY39  ,WQTY40  = @p_WQTY40
                                                   ,WQTY41 = @p_WQTY41  ,WQTY42  = @p_WQTY42  ,WQTY43  = @p_WQTY43  ,WQTY44  = @p_WQTY44  ,WQTY45  = @p_WQTY45  ,WQTY46  = @p_WQTY46  ,WQTY47  = @p_WQTY47  ,WQTY48  = @p_WQTY48  ,WQTY49  = @p_WQTY49  ,WQTY50  = @p_WQTY50
                                                   ,WQTY51 = @p_WQTY51  ,WQTY52  = @p_WQTY52
                                                   ,LAST_UPDATED_BY    = @v_batch_user_id
                                                   ,LAST_UPDATE_DATE   = GETDATE()
                                                   ,ATTRIBUTE2         = 'Y'
                                             WHERE 0 = 0
                                               AND DIVISION_ID         = @v_batch_division_id
                                               AND PLAN_START_YYYYMMDD = @v_batch_plan_start_yyyymmdd
                                               AND SEQ                 = @v_batch_seq
                                               AND XLS_KEY1            = @v_batch_xls_key1; */

                END IF;
            END IF;
            /*  PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ESS Pack 생산계획 (W/C) 적용 - end */


            /*  PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ESS Pack 생산계획 (W/C) 적용 - start */
            /*  PACK_PROD 제외 */
            /* */
            /* IF @p_measure IN  ('PACK_PROD','CELL_CHAR_PLAN','CELL_PROD')    -- CELL_CHAR_PLAN SCP_XLS_PSI_GLOBAL_ESS 테이블에 저장만 처리함. */
            IF V_BATCH_MEASURE IN ('CELL_CHAR_PLAN', 'CELL_PROD') THEN   /* CELL_CHAR_PLAN SCP_XLS_PSI_GLOBAL_ESS 테이블에 저장만 처리함. */
            /*  PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ESS Pack 생산계획 (W/C) 적용 - end */

               /* PRINT @v_batch_measure + '00. ' +CONVERT(CHAR(23), GETDATE(), 21); */

                /* ▼ MSSQL 원본 L1066~L1097 원문 보존 (원본 블록주석 死코드(@p_day_week_flag = 'week' 구판 UPDATE)) ---------------------------------------------
                                   ( *IF  @v_batch_day_week_flag = 'week'
                                   BEGIN
                                        UPDATE X
                                           SET
                                                QTY001 = @p_QTY001 ,QTY002  = @p_QTY002  ,QTY003 = @p_QTY003 ,QTY004 = @p_QTY004 ,QTY005  = @p_QTY005 ,QTY006  = @p_QTY006 ,QTY007 = @p_QTY007
                                               ,QTY008 = @p_QTY008 ,QTY009  = @p_QTY009  ,QTY010 = @p_QTY010 ,QTY011 = @p_QTY011 ,QTY012  = @p_QTY012 ,QTY013  = @p_QTY013 ,QTY014 = @p_QTY014
                                               ,QTY015 = @p_QTY015 ,QTY016  = @p_QTY016  ,QTY017 = @p_QTY017 ,QTY018 = @p_QTY018 ,QTY019  = @p_QTY019 ,QTY020  = @p_QTY020 ,QTY021 = @p_QTY021
                                               ,QTY022 = @p_QTY022 ,QTY023  = @p_QTY023  ,QTY024 = @p_QTY024 ,QTY025 = @p_QTY025 ,QTY026  = @p_QTY026 ,QTY027  = @p_QTY027 ,QTY028 = @p_QTY028
                                               ,QTY029 = @p_QTY029 ,QTY030  = @p_QTY030  ,QTY031 = @p_QTY031 ,QTY032 = @p_QTY032 ,QTY033  = @p_QTY033 ,QTY034  = @p_QTY034 ,QTY035 = @p_QTY035
                                               ,QTY036 = @p_QTY036 ,QTY037  = @p_QTY037  ,QTY038 = @p_QTY038 ,QTY039 = @p_QTY039 ,QTY040  = @p_QTY040 ,QTY041  = @p_QTY041 ,QTY042 = @p_QTY042
                                               ,QTY043 = @p_QTY043 ,QTY044  = @p_QTY044  ,QTY045 = @p_QTY045 ,QTY046 = @p_QTY046 ,QTY047  = @p_QTY047 ,QTY048  = @p_QTY048 ,QTY049 = @p_QTY049
                                               ,QTY050 = @p_QTY050 ,QTY051  = @p_QTY051  ,QTY052 = @p_QTY052 ,QTY053 = @p_QTY053 ,QTY054  = @p_QTY054 ,QTY055  = @p_QTY055 ,QTY056 = @p_QTY056
                                               ,QTY057 = @p_QTY057 ,QTY058  = @p_QTY058  ,QTY059 = @p_QTY059 ,QTY060 = @p_QTY060 ,QTY061  = @p_QTY061 ,QTY062  = @p_QTY062 ,QTY063 = @p_QTY063
                                               ,QTY064 = @p_QTY064 ,QTY065  = @p_QTY065  ,QTY066 = @p_QTY066 ,QTY067 = @p_QTY067 ,QTY068  = @p_QTY068 ,QTY069  = @p_QTY069 ,QTY070 = @p_QTY070
                                               ,QTY071 = @p_QTY071 ,QTY072  = @p_QTY072  ,QTY073 = @p_QTY073 ,QTY074 = @p_QTY074 ,QTY075  = @p_QTY075 ,QTY076  = @p_QTY076 ,QTY077 = @p_QTY077
                                               ,QTY078 = @p_QTY078 ,QTY079  = @p_QTY079  ,QTY080 = @p_QTY080 ,QTY081 = @p_QTY081 ,QTY082  = @p_QTY082 ,QTY083  = @p_QTY083 ,QTY084 = @p_QTY084
                                               ,QTY085 = @p_QTY085 ,QTY086  = @p_QTY086  ,QTY087 = @p_QTY087 ,QTY088 = @p_QTY088 ,QTY089  = @p_QTY089 ,QTY090  = @p_QTY090 ,QTY091 = @p_QTY091
                                               ,QTY092 = @p_QTY092 ,QTY093  = @p_QTY093  ,QTY094 = @p_QTY094 ,QTY095 = @p_QTY095 ,QTY096  = @p_QTY096 ,QTY097  = @p_QTY097 ,QTY098 = @p_QTY098
                                               ,QTY099 = @p_QTY099 ,QTY100  = @p_QTY100  ,QTY101 = @p_QTY101 ,QTY102 = @p_QTY102 ,QTY103  = @p_QTY103 ,QTY104  = @p_QTY104 ,QTY105 = @p_QTY105
                                               ,QTY106 = @p_QTY106 ,QTY107  = @p_QTY107  ,QTY108 = @p_QTY108 ,QTY109 = @p_QTY109 ,QTY110  = @p_QTY110 ,QTY111  = @p_QTY111 ,QTY112 = @p_QTY112

                                               ,LAST_UPDATED_BY    = @p_user_id
                                               ,LAST_UPDATE_DATE   = GETDATE()
                                         FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                                         WHERE 0 = 0
                                           AND DIVISION_ID         = @p_division_id
                                           AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                                           AND SEQ                 = @p_seq
                                           AND XLS_KEY1            = @p_xls_key1;

                                   END  --  @p_day_week_flag = 'day'
                                   * ) */

                /*  ★원본 L1099 는 지역변수 @v_batch_day_week_flag 가 아니라 파라미터 @p_day_week_flag 를 직접 본다.
                    2023.12.08 지역변수 전환에서 빠진 자리이지만 값은 같으므로(대입만 하고 재대입 없음) 원본 그대로 옮긴다. */
                IF P_DAY_WEEK_FLAG = 'week' THEN


                    UPDATE SCP_XLS_PSI_GLOBAL_ESS
                       SET
                             QTY001 = TRUNC(P_WQTY01 / 7), QTY002 = TRUNC(P_WQTY01 / 7), QTY003 = TRUNC(P_WQTY01 / 7), QTY004 = TRUNC(P_WQTY01 / 7), QTY005 = TRUNC(P_WQTY01 / 7), QTY006 = TRUNC(P_WQTY01 / 7), QTY007 = (TRUNC(P_WQTY01 / 7) + MOD(P_WQTY01, 7))
                          , QTY008 = TRUNC(P_WQTY02 / 7), QTY009 = TRUNC(P_WQTY02 / 7), QTY010 = TRUNC(P_WQTY02 / 7), QTY011 = TRUNC(P_WQTY02 / 7), QTY012 = TRUNC(P_WQTY02 / 7), QTY013 = TRUNC(P_WQTY02 / 7), QTY014 = (TRUNC(P_WQTY02 / 7) + MOD(P_WQTY02, 7))
                          , QTY015 = TRUNC(P_WQTY03 / 7), QTY016 = TRUNC(P_WQTY03 / 7), QTY017 = TRUNC(P_WQTY03 / 7), QTY018 = TRUNC(P_WQTY03 / 7), QTY019 = TRUNC(P_WQTY03 / 7), QTY020 = TRUNC(P_WQTY03 / 7), QTY021 = (TRUNC(P_WQTY03 / 7) + MOD(P_WQTY03, 7))
                          , QTY022 = TRUNC(P_WQTY04 / 7), QTY023 = TRUNC(P_WQTY04 / 7), QTY024 = TRUNC(P_WQTY04 / 7), QTY025 = TRUNC(P_WQTY04 / 7), QTY026 = TRUNC(P_WQTY04 / 7), QTY027 = TRUNC(P_WQTY04 / 7), QTY028 = (TRUNC(P_WQTY04 / 7) + MOD(P_WQTY04, 7))
                          , QTY029 = TRUNC(P_WQTY05 / 7), QTY030 = TRUNC(P_WQTY05 / 7), QTY031 = TRUNC(P_WQTY05 / 7), QTY032 = TRUNC(P_WQTY05 / 7), QTY033 = TRUNC(P_WQTY05 / 7), QTY034 = TRUNC(P_WQTY05 / 7), QTY035 = (TRUNC(P_WQTY05 / 7) + MOD(P_WQTY05, 7))
                          , QTY036 = TRUNC(P_WQTY06 / 7), QTY037 = TRUNC(P_WQTY06 / 7), QTY038 = TRUNC(P_WQTY06 / 7), QTY039 = TRUNC(P_WQTY06 / 7), QTY040 = TRUNC(P_WQTY06 / 7), QTY041 = TRUNC(P_WQTY06 / 7), QTY042 = (TRUNC(P_WQTY06 / 7) + MOD(P_WQTY06, 7))
                          , QTY043 = TRUNC(P_WQTY07 / 7), QTY044 = TRUNC(P_WQTY07 / 7), QTY045 = TRUNC(P_WQTY07 / 7), QTY046 = TRUNC(P_WQTY07 / 7), QTY047 = TRUNC(P_WQTY07 / 7), QTY048 = TRUNC(P_WQTY07 / 7), QTY049 = (TRUNC(P_WQTY07 / 7) + MOD(P_WQTY07, 7))
                          , QTY050 = TRUNC(P_WQTY08 / 7), QTY051 = TRUNC(P_WQTY08 / 7), QTY052 = TRUNC(P_WQTY08 / 7), QTY053 = TRUNC(P_WQTY08 / 7), QTY054 = TRUNC(P_WQTY08 / 7), QTY055 = TRUNC(P_WQTY08 / 7), QTY056 = (TRUNC(P_WQTY08 / 7) + MOD(P_WQTY08, 7))
                          , QTY057 = TRUNC(P_WQTY09 / 7), QTY058 = TRUNC(P_WQTY09 / 7), QTY059 = TRUNC(P_WQTY09 / 7), QTY060 = TRUNC(P_WQTY09 / 7), QTY061 = TRUNC(P_WQTY09 / 7), QTY062 = TRUNC(P_WQTY09 / 7), QTY063 = (TRUNC(P_WQTY09 / 7) + MOD(P_WQTY09, 7))
                          , QTY064 = TRUNC(P_WQTY10 / 7), QTY065 = TRUNC(P_WQTY10 / 7), QTY066 = TRUNC(P_WQTY10 / 7), QTY067 = TRUNC(P_WQTY10 / 7), QTY068 = TRUNC(P_WQTY10 / 7), QTY069 = TRUNC(P_WQTY10 / 7), QTY070 = (TRUNC(P_WQTY10 / 7) + MOD(P_WQTY10, 7))
                          , QTY071 = TRUNC(P_WQTY11 / 7), QTY072 = TRUNC(P_WQTY11 / 7), QTY073 = TRUNC(P_WQTY11 / 7), QTY074 = TRUNC(P_WQTY11 / 7), QTY075 = TRUNC(P_WQTY11 / 7), QTY076 = TRUNC(P_WQTY11 / 7), QTY077 = (TRUNC(P_WQTY11 / 7) + MOD(P_WQTY11, 7))
                          , QTY078 = TRUNC(P_WQTY12 / 7), QTY079 = TRUNC(P_WQTY12 / 7), QTY080 = TRUNC(P_WQTY12 / 7), QTY081 = TRUNC(P_WQTY12 / 7), QTY082 = TRUNC(P_WQTY12 / 7), QTY083 = TRUNC(P_WQTY12 / 7), QTY084 = (TRUNC(P_WQTY12 / 7) + MOD(P_WQTY12, 7))
                          , QTY085 = TRUNC(P_WQTY13 / 7), QTY086 = TRUNC(P_WQTY13 / 7), QTY087 = TRUNC(P_WQTY13 / 7), QTY088 = TRUNC(P_WQTY13 / 7), QTY089 = TRUNC(P_WQTY13 / 7), QTY090 = TRUNC(P_WQTY13 / 7), QTY091 = (TRUNC(P_WQTY13 / 7) + MOD(P_WQTY13, 7))
                          , QTY092 = TRUNC(P_WQTY14 / 7), QTY093 = TRUNC(P_WQTY14 / 7), QTY094 = TRUNC(P_WQTY14 / 7), QTY095 = TRUNC(P_WQTY14 / 7), QTY096 = TRUNC(P_WQTY14 / 7), QTY097 = TRUNC(P_WQTY14 / 7), QTY098 = (TRUNC(P_WQTY14 / 7) + MOD(P_WQTY14, 7))
                          , QTY099 = TRUNC(P_WQTY15 / 7), QTY100 = TRUNC(P_WQTY15 / 7), QTY101 = TRUNC(P_WQTY15 / 7), QTY102 = TRUNC(P_WQTY15 / 7), QTY103 = TRUNC(P_WQTY15 / 7), QTY104 = TRUNC(P_WQTY15 / 7), QTY105 = (TRUNC(P_WQTY15 / 7) + MOD(P_WQTY15, 7))
                          , QTY106 = TRUNC(P_WQTY16 / 7), QTY107 = TRUNC(P_WQTY16 / 7), QTY108 = TRUNC(P_WQTY16 / 7), QTY109 = TRUNC(P_WQTY16 / 7), QTY110 = TRUNC(P_WQTY16 / 7), QTY111 = TRUNC(P_WQTY16 / 7), QTY112 = (TRUNC(P_WQTY16 / 7) + MOD(P_WQTY16, 7))
                          , QTY113 = TRUNC(P_WQTY17 / 7), QTY114 = TRUNC(P_WQTY17 / 7), QTY115 = TRUNC(P_WQTY17 / 7), QTY116 = TRUNC(P_WQTY17 / 7), QTY117 = TRUNC(P_WQTY17 / 7), QTY118 = TRUNC(P_WQTY17 / 7), QTY119 = (TRUNC(P_WQTY17 / 7) + MOD(P_WQTY17, 7))
                          , QTY120 = TRUNC(P_WQTY18 / 7), QTY121 = TRUNC(P_WQTY18 / 7), QTY122 = TRUNC(P_WQTY18 / 7), QTY123 = TRUNC(P_WQTY18 / 7), QTY124 = TRUNC(P_WQTY18 / 7), QTY125 = TRUNC(P_WQTY18 / 7), QTY126 = (TRUNC(P_WQTY18 / 7) + MOD(P_WQTY18, 7))
                          , QTY127 = TRUNC(P_WQTY19 / 7), QTY128 = TRUNC(P_WQTY19 / 7), QTY129 = TRUNC(P_WQTY19 / 7), QTY130 = TRUNC(P_WQTY19 / 7), QTY131 = TRUNC(P_WQTY19 / 7), QTY132 = TRUNC(P_WQTY19 / 7), QTY133 = (TRUNC(P_WQTY19 / 7) + MOD(P_WQTY19, 7))
                          , QTY134 = TRUNC(P_WQTY20 / 7), QTY135 = TRUNC(P_WQTY20 / 7), QTY136 = TRUNC(P_WQTY20 / 7), QTY137 = TRUNC(P_WQTY20 / 7), QTY138 = TRUNC(P_WQTY20 / 7), QTY139 = TRUNC(P_WQTY20 / 7), QTY140 = (TRUNC(P_WQTY20 / 7) + MOD(P_WQTY20, 7))
                          , QTY141 = TRUNC(P_WQTY21 / 7), QTY142 = TRUNC(P_WQTY21 / 7), QTY143 = TRUNC(P_WQTY21 / 7), QTY144 = TRUNC(P_WQTY21 / 7), QTY145 = TRUNC(P_WQTY21 / 7), QTY146 = TRUNC(P_WQTY21 / 7), QTY147 = (TRUNC(P_WQTY21 / 7) + MOD(P_WQTY21, 7))
                          , QTY148 = TRUNC(P_WQTY22 / 7), QTY149 = TRUNC(P_WQTY22 / 7), QTY150 = TRUNC(P_WQTY22 / 7), QTY151 = TRUNC(P_WQTY22 / 7), QTY152 = TRUNC(P_WQTY22 / 7), QTY153 = TRUNC(P_WQTY22 / 7), QTY154 = (TRUNC(P_WQTY22 / 7) + MOD(P_WQTY22, 7))
                          , QTY155 = TRUNC(P_WQTY23 / 7), QTY156 = TRUNC(P_WQTY23 / 7), QTY157 = TRUNC(P_WQTY23 / 7), QTY158 = TRUNC(P_WQTY23 / 7), QTY159 = TRUNC(P_WQTY23 / 7), QTY160 = TRUNC(P_WQTY23 / 7), QTY161 = (TRUNC(P_WQTY23 / 7) + MOD(P_WQTY23, 7))
                          , QTY162 = TRUNC(P_WQTY24 / 7), QTY163 = TRUNC(P_WQTY24 / 7), QTY164 = TRUNC(P_WQTY24 / 7), QTY165 = TRUNC(P_WQTY24 / 7), QTY166 = TRUNC(P_WQTY24 / 7), QTY167 = TRUNC(P_WQTY24 / 7), QTY168 = (TRUNC(P_WQTY24 / 7) + MOD(P_WQTY24, 7))
                          , QTY169 = TRUNC(P_WQTY25 / 7), QTY170 = TRUNC(P_WQTY25 / 7), QTY171 = TRUNC(P_WQTY25 / 7), QTY172 = TRUNC(P_WQTY25 / 7), QTY173 = TRUNC(P_WQTY25 / 7), QTY174 = TRUNC(P_WQTY25 / 7), QTY175 = (TRUNC(P_WQTY25 / 7) + MOD(P_WQTY25, 7))
                          , QTY176 = TRUNC(P_WQTY26 / 7), QTY177 = TRUNC(P_WQTY26 / 7), QTY178 = TRUNC(P_WQTY26 / 7), QTY179 = TRUNC(P_WQTY26 / 7), QTY180 = TRUNC(P_WQTY26 / 7), QTY181 = TRUNC(P_WQTY26 / 7), QTY182 = (TRUNC(P_WQTY26 / 7) + MOD(P_WQTY26, 7))
                          , QTY183 = TRUNC(P_WQTY27 / 7), QTY184 = TRUNC(P_WQTY27 / 7), QTY185 = TRUNC(P_WQTY27 / 7), QTY186 = TRUNC(P_WQTY27 / 7), QTY187 = TRUNC(P_WQTY27 / 7), QTY188 = TRUNC(P_WQTY27 / 7), QTY189 = (TRUNC(P_WQTY27 / 7) + MOD(P_WQTY27, 7))
                          , QTY190 = TRUNC(P_WQTY28 / 7), QTY191 = TRUNC(P_WQTY28 / 7), QTY192 = TRUNC(P_WQTY28 / 7), QTY193 = TRUNC(P_WQTY28 / 7), QTY194 = TRUNC(P_WQTY28 / 7), QTY195 = TRUNC(P_WQTY28 / 7), QTY196 = (TRUNC(P_WQTY28 / 7) + MOD(P_WQTY28, 7))
                          , QTY197 = TRUNC(P_WQTY29 / 7), QTY198 = TRUNC(P_WQTY29 / 7), QTY199 = TRUNC(P_WQTY29 / 7), QTY200 = TRUNC(P_WQTY29 / 7), QTY201 = TRUNC(P_WQTY29 / 7), QTY202 = TRUNC(P_WQTY29 / 7), QTY203 = (TRUNC(P_WQTY29 / 7) + MOD(P_WQTY29, 7))
                          , QTY204 = TRUNC(P_WQTY30 / 7), QTY205 = TRUNC(P_WQTY30 / 7), QTY206 = TRUNC(P_WQTY30 / 7), QTY207 = TRUNC(P_WQTY30 / 7), QTY208 = TRUNC(P_WQTY30 / 7), QTY209 = TRUNC(P_WQTY30 / 7), QTY210 = (TRUNC(P_WQTY30 / 7) + MOD(P_WQTY30, 7))
                          , QTY211 = TRUNC(P_WQTY31 / 7), QTY212 = TRUNC(P_WQTY31 / 7), QTY213 = TRUNC(P_WQTY31 / 7), QTY214 = TRUNC(P_WQTY31 / 7), QTY215 = TRUNC(P_WQTY31 / 7), QTY216 = TRUNC(P_WQTY31 / 7), QTY217 = (TRUNC(P_WQTY31 / 7) + MOD(P_WQTY31, 7))
                          , QTY218 = TRUNC(P_WQTY32 / 7), QTY219 = TRUNC(P_WQTY32 / 7), QTY220 = TRUNC(P_WQTY32 / 7), QTY221 = TRUNC(P_WQTY32 / 7), QTY222 = TRUNC(P_WQTY32 / 7), QTY223 = TRUNC(P_WQTY32 / 7), QTY224 = (TRUNC(P_WQTY32 / 7) + MOD(P_WQTY32, 7))
                          , QTY225 = TRUNC(P_WQTY33 / 7), QTY226 = TRUNC(P_WQTY33 / 7), QTY227 = TRUNC(P_WQTY33 / 7), QTY228 = TRUNC(P_WQTY33 / 7), QTY229 = TRUNC(P_WQTY33 / 7), QTY230 = TRUNC(P_WQTY33 / 7), QTY231 = (TRUNC(P_WQTY33 / 7) + MOD(P_WQTY33, 7))
                          , QTY232 = TRUNC(P_WQTY34 / 7), QTY233 = TRUNC(P_WQTY34 / 7), QTY234 = TRUNC(P_WQTY34 / 7), QTY235 = TRUNC(P_WQTY34 / 7), QTY236 = TRUNC(P_WQTY34 / 7), QTY237 = TRUNC(P_WQTY34 / 7), QTY238 = (TRUNC(P_WQTY34 / 7) + MOD(P_WQTY34, 7))
                          , QTY239 = TRUNC(P_WQTY35 / 7), QTY240 = TRUNC(P_WQTY35 / 7), QTY241 = TRUNC(P_WQTY35 / 7), QTY242 = TRUNC(P_WQTY35 / 7), QTY243 = TRUNC(P_WQTY35 / 7), QTY244 = TRUNC(P_WQTY35 / 7), QTY245 = (TRUNC(P_WQTY35 / 7) + MOD(P_WQTY35, 7))
                          , QTY246 = TRUNC(P_WQTY36 / 7), QTY247 = TRUNC(P_WQTY36 / 7), QTY248 = TRUNC(P_WQTY36 / 7), QTY249 = TRUNC(P_WQTY36 / 7), QTY250 = TRUNC(P_WQTY36 / 7), QTY251 = TRUNC(P_WQTY36 / 7), QTY252 = (TRUNC(P_WQTY36 / 7) + MOD(P_WQTY36, 7))
                          , QTY253 = TRUNC(P_WQTY37 / 7), QTY254 = TRUNC(P_WQTY37 / 7), QTY255 = TRUNC(P_WQTY37 / 7), QTY256 = TRUNC(P_WQTY37 / 7), QTY257 = TRUNC(P_WQTY37 / 7), QTY258 = TRUNC(P_WQTY37 / 7), QTY259 = (TRUNC(P_WQTY37 / 7) + MOD(P_WQTY37, 7))
                          , QTY260 = TRUNC(P_WQTY38 / 7), QTY261 = TRUNC(P_WQTY38 / 7), QTY262 = TRUNC(P_WQTY38 / 7), QTY263 = TRUNC(P_WQTY38 / 7), QTY264 = TRUNC(P_WQTY38 / 7), QTY265 = TRUNC(P_WQTY38 / 7), QTY266 = (TRUNC(P_WQTY38 / 7) + MOD(P_WQTY38, 7))
                          , QTY267 = TRUNC(P_WQTY39 / 7), QTY268 = TRUNC(P_WQTY39 / 7), QTY269 = TRUNC(P_WQTY39 / 7), QTY270 = TRUNC(P_WQTY39 / 7), QTY271 = TRUNC(P_WQTY39 / 7), QTY272 = TRUNC(P_WQTY39 / 7), QTY273 = (TRUNC(P_WQTY39 / 7) + MOD(P_WQTY39, 7))
                          , QTY274 = TRUNC(P_WQTY40 / 7), QTY275 = TRUNC(P_WQTY40 / 7), QTY276 = TRUNC(P_WQTY40 / 7), QTY277 = TRUNC(P_WQTY40 / 7), QTY278 = TRUNC(P_WQTY40 / 7), QTY279 = TRUNC(P_WQTY40 / 7), QTY280 = (TRUNC(P_WQTY40 / 7) + MOD(P_WQTY40, 7))
                          , QTY281 = TRUNC(P_WQTY41 / 7), QTY282 = TRUNC(P_WQTY41 / 7), QTY283 = TRUNC(P_WQTY41 / 7), QTY284 = TRUNC(P_WQTY41 / 7), QTY285 = TRUNC(P_WQTY41 / 7), QTY286 = TRUNC(P_WQTY41 / 7), QTY287 = (TRUNC(P_WQTY41 / 7) + MOD(P_WQTY41, 7))
                          , QTY288 = TRUNC(P_WQTY42 / 7), QTY289 = TRUNC(P_WQTY42 / 7), QTY290 = TRUNC(P_WQTY42 / 7), QTY291 = TRUNC(P_WQTY42 / 7), QTY292 = TRUNC(P_WQTY42 / 7), QTY293 = TRUNC(P_WQTY42 / 7), QTY294 = (TRUNC(P_WQTY42 / 7) + MOD(P_WQTY42, 7))
                          , QTY295 = TRUNC(P_WQTY43 / 7), QTY296 = TRUNC(P_WQTY43 / 7), QTY297 = TRUNC(P_WQTY43 / 7), QTY298 = TRUNC(P_WQTY43 / 7), QTY299 = TRUNC(P_WQTY43 / 7), QTY300 = TRUNC(P_WQTY43 / 7), QTY301 = (TRUNC(P_WQTY43 / 7) + MOD(P_WQTY43, 7))
                          , QTY302 = TRUNC(P_WQTY44 / 7), QTY303 = TRUNC(P_WQTY44 / 7), QTY304 = TRUNC(P_WQTY44 / 7), QTY305 = TRUNC(P_WQTY44 / 7), QTY306 = TRUNC(P_WQTY44 / 7), QTY307 = TRUNC(P_WQTY44 / 7), QTY308 = (TRUNC(P_WQTY44 / 7) + MOD(P_WQTY44, 7))
                          , QTY309 = TRUNC(P_WQTY45 / 7), QTY310 = TRUNC(P_WQTY45 / 7), QTY311 = TRUNC(P_WQTY45 / 7), QTY312 = TRUNC(P_WQTY45 / 7), QTY313 = TRUNC(P_WQTY45 / 7), QTY314 = TRUNC(P_WQTY45 / 7), QTY315 = (TRUNC(P_WQTY45 / 7) + MOD(P_WQTY45, 7))
                          , QTY316 = TRUNC(P_WQTY46 / 7), QTY317 = TRUNC(P_WQTY46 / 7), QTY318 = TRUNC(P_WQTY46 / 7), QTY319 = TRUNC(P_WQTY46 / 7), QTY320 = TRUNC(P_WQTY46 / 7), QTY321 = TRUNC(P_WQTY46 / 7), QTY322 = (TRUNC(P_WQTY46 / 7) + MOD(P_WQTY46, 7))
                          , QTY323 = TRUNC(P_WQTY47 / 7), QTY324 = TRUNC(P_WQTY47 / 7), QTY325 = TRUNC(P_WQTY47 / 7), QTY326 = TRUNC(P_WQTY47 / 7), QTY327 = TRUNC(P_WQTY47 / 7), QTY328 = TRUNC(P_WQTY47 / 7), QTY329 = (TRUNC(P_WQTY47 / 7) + MOD(P_WQTY47, 7))
                          , QTY330 = TRUNC(P_WQTY48 / 7), QTY331 = TRUNC(P_WQTY48 / 7), QTY332 = TRUNC(P_WQTY48 / 7), QTY333 = TRUNC(P_WQTY48 / 7), QTY334 = TRUNC(P_WQTY48 / 7), QTY335 = TRUNC(P_WQTY48 / 7), QTY336 = (TRUNC(P_WQTY48 / 7) + MOD(P_WQTY48, 7))
                          , QTY337 = TRUNC(P_WQTY49 / 7), QTY338 = TRUNC(P_WQTY49 / 7), QTY339 = TRUNC(P_WQTY49 / 7), QTY340 = TRUNC(P_WQTY49 / 7), QTY341 = TRUNC(P_WQTY49 / 7), QTY342 = TRUNC(P_WQTY49 / 7), QTY343 = (TRUNC(P_WQTY49 / 7) + MOD(P_WQTY49, 7))
                          , QTY344 = TRUNC(P_WQTY50 / 7), QTY345 = TRUNC(P_WQTY50 / 7), QTY346 = TRUNC(P_WQTY50 / 7), QTY347 = TRUNC(P_WQTY50 / 7), QTY348 = TRUNC(P_WQTY50 / 7), QTY349 = TRUNC(P_WQTY50 / 7), QTY350 = (TRUNC(P_WQTY50 / 7) + MOD(P_WQTY50, 7))
                          , QTY351 = TRUNC(P_WQTY51 / 7), QTY352 = TRUNC(P_WQTY51 / 7), QTY353 = TRUNC(P_WQTY51 / 7), QTY354 = TRUNC(P_WQTY51 / 7), QTY355 = TRUNC(P_WQTY51 / 7), QTY356 = TRUNC(P_WQTY51 / 7), QTY357 = (TRUNC(P_WQTY51 / 7) + MOD(P_WQTY51, 7))
                          , QTY358 = TRUNC(P_WQTY52 / 7), QTY359 = TRUNC(P_WQTY52 / 7), QTY360 = TRUNC(P_WQTY52 / 7), QTY361 = TRUNC(P_WQTY52 / 7), QTY362 = TRUNC(P_WQTY52 / 7), QTY363 = TRUNC(P_WQTY52 / 7), QTY364 = (TRUNC(P_WQTY52 / 7) + MOD(P_WQTY52, 7))

                          , WQTY01 = P_WQTY01, WQTY02 = P_WQTY02, WQTY03 = P_WQTY03, WQTY04 = P_WQTY04, WQTY05 = P_WQTY05
                          , WQTY06 = P_WQTY06, WQTY07 = P_WQTY07, WQTY08 = P_WQTY08, WQTY09 = P_WQTY09, WQTY10 = P_WQTY10
                          , WQTY11 = P_WQTY11, WQTY12 = P_WQTY12, WQTY13 = P_WQTY13, WQTY14 = P_WQTY14, WQTY15 = P_WQTY15
                          , WQTY16 = P_WQTY16, WQTY17 = P_WQTY17, WQTY18 = P_WQTY18, WQTY19 = P_WQTY19, WQTY20 = P_WQTY20
                          , WQTY21 = P_WQTY21, WQTY22 = P_WQTY22, WQTY23 = P_WQTY23, WQTY24 = P_WQTY24, WQTY25 = P_WQTY25
                          , WQTY26 = P_WQTY26, WQTY27 = P_WQTY27, WQTY28 = P_WQTY28, WQTY29 = P_WQTY29, WQTY30 = P_WQTY30
                          , WQTY31 = P_WQTY31, WQTY32 = P_WQTY32, WQTY33 = P_WQTY33, WQTY34 = P_WQTY34, WQTY35 = P_WQTY35
                          , WQTY36 = P_WQTY36, WQTY37 = P_WQTY37, WQTY38 = P_WQTY38, WQTY39 = P_WQTY39, WQTY40 = P_WQTY40
                          , WQTY41 = P_WQTY41, WQTY42 = P_WQTY42, WQTY43 = P_WQTY43, WQTY44 = P_WQTY44, WQTY45 = P_WQTY45
                          , WQTY46 = P_WQTY46, WQTY47 = P_WQTY47, WQTY48 = P_WQTY48, WQTY49 = P_WQTY49, WQTY50 = P_WQTY50
                          , WQTY51 = P_WQTY51, WQTY52 = P_WQTY52
                         , LAST_UPDATED_BY    = V_BATCH_USER_ID
                         , LAST_UPDATE_DATE   = SYSDATE
                         , ATTRIBUTE2         = 'Y'
                     WHERE 0 = 0
                       AND DIVISION_ID          = V_BATCH_DIVISION_ID
                       AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                       AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                       AND SEQ                  = V_BATCH_SEQ
                       AND XLS_KEY1             = V_BATCH_XLS_KEY1
                         ;

                    /* -------------------------------------------------------------------------------------------------------------------------------------------------------
                    --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (CELL_PROD)
                    ------------------------------------------------------------------------------------------------------------------------------------------------------- */
                    /*  MSSQL UPDATE JV SET .. FROM ES INNER JOIN SM INNER JOIN VD INNER JOIN MP INNER JOIN JV ..
                           MERGE 는 ORA-30926 위험이 있다 -> 상관 UPDATE + EXISTS + ROWNUM = 1 로 결정적으로 옮긴다(CV-024).
                        MSSQL CONCAT(@v_batch_user_id, '(XLSPSI06)') 는 NULL 을 빈문자로 취급한다. */
                    UPDATE SCP_XLS_PSI_GLOBAL JV
                       SET (
                             QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008
                           , QTY009, QTY010, QTY011, QTY012, QTY013, QTY014, QTY015, QTY016
                           , QTY017, QTY018, QTY019, QTY020, QTY021, QTY022, QTY023, QTY024
                           , QTY025, QTY026, QTY027, QTY028, QTY029, QTY030, QTY031, QTY032
                           , QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                           , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048
                           , QTY049, QTY050, QTY051, QTY052, QTY053, QTY054, QTY055, QTY056
                           , QTY057, QTY058, QTY059, QTY060, QTY061, QTY062, QTY063, QTY064
                           , QTY065, QTY066, QTY067, QTY068, QTY069, QTY070, QTY071, QTY072
                           , QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                           , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088
                           , QTY089, QTY090, QTY091, QTY092, QTY093, QTY094, QTY095, QTY096
                           , QTY097, QTY098, QTY099, QTY100, QTY101, QTY102, QTY103, QTY104
                           , QTY105, QTY106, QTY107, QTY108, QTY109, QTY110, QTY111, QTY112
                           , QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                           , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128
                           , QTY129, QTY130, QTY131, QTY132, QTY133, QTY134, QTY135, QTY136
                           , QTY137, QTY138, QTY139, QTY140, QTY141, QTY142, QTY143, QTY144
                           , QTY145, QTY146, QTY147, QTY148, QTY149, QTY150, QTY151, QTY152
                           , QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                           , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168
                           , QTY169, QTY170, QTY171, QTY172, QTY173, QTY174, QTY175, QTY176
                           , QTY177, QTY178, QTY179, QTY180, QTY181, QTY182, QTY183, QTY184
                           , QTY185, QTY186, QTY187, QTY188, QTY189, QTY190, QTY191, QTY192
                           , QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                           , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208
                           , QTY209, QTY210, QTY211, QTY212, QTY213, QTY214, QTY215, QTY216
                           , QTY217, QTY218, QTY219, QTY220, QTY221, QTY222, QTY223, QTY224
                           , QTY225, QTY226, QTY227, QTY228, QTY229, QTY230, QTY231, QTY232
                           , QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                           , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248
                           , QTY249, QTY250, QTY251, QTY252, QTY253, QTY254, QTY255, QTY256
                           , QTY257, QTY258, QTY259, QTY260, QTY261, QTY262, QTY263, QTY264
                           , QTY265, QTY266, QTY267, QTY268, QTY269, QTY270, QTY271, QTY272
                           , QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                           , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288
                           , QTY289, QTY290, QTY291, QTY292, QTY293, QTY294, QTY295, QTY296
                           , QTY297, QTY298, QTY299, QTY300, QTY301, QTY302, QTY303, QTY304
                           , QTY305, QTY306, QTY307, QTY308, QTY309, QTY310, QTY311, QTY312
                           , QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                           , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328
                           , QTY329, QTY330, QTY331, QTY332, QTY333, QTY334, QTY335, QTY336
                           , QTY337, QTY338, QTY339, QTY340, QTY341, QTY342, QTY343, QTY344
                           , QTY345, QTY346, QTY347, QTY348, QTY349, QTY350, QTY351, QTY352
                           , QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                           , QTY361, QTY362, QTY363, QTY364, WQTY01, WQTY02, WQTY03, WQTY04
                           , WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10, WQTY11, WQTY12
                           , WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                           , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28
                           , WQTY29, WQTY30, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36
                           , WQTY37, WQTY38, WQTY39, WQTY40, WQTY41, WQTY42, WQTY43, WQTY44
                           , WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50, WQTY51, WQTY52
                           , LAST_UPDATE_DATE, LAST_UPDATED_BY
                           ) =
                           ( SELECT
                               ES.QTY001, ES.QTY002, ES.QTY003, ES.QTY004, ES.QTY005, ES.QTY006, ES.QTY007, ES.QTY008
                             , ES.QTY009, ES.QTY010, ES.QTY011, ES.QTY012, ES.QTY013, ES.QTY014, ES.QTY015, ES.QTY016
                             , ES.QTY017, ES.QTY018, ES.QTY019, ES.QTY020, ES.QTY021, ES.QTY022, ES.QTY023, ES.QTY024
                             , ES.QTY025, ES.QTY026, ES.QTY027, ES.QTY028, ES.QTY029, ES.QTY030, ES.QTY031, ES.QTY032
                             , ES.QTY033, ES.QTY034, ES.QTY035, ES.QTY036, ES.QTY037, ES.QTY038, ES.QTY039, ES.QTY040
                             , ES.QTY041, ES.QTY042, ES.QTY043, ES.QTY044, ES.QTY045, ES.QTY046, ES.QTY047, ES.QTY048
                             , ES.QTY049, ES.QTY050, ES.QTY051, ES.QTY052, ES.QTY053, ES.QTY054, ES.QTY055, ES.QTY056
                             , ES.QTY057, ES.QTY058, ES.QTY059, ES.QTY060, ES.QTY061, ES.QTY062, ES.QTY063, ES.QTY064
                             , ES.QTY065, ES.QTY066, ES.QTY067, ES.QTY068, ES.QTY069, ES.QTY070, ES.QTY071, ES.QTY072
                             , ES.QTY073, ES.QTY074, ES.QTY075, ES.QTY076, ES.QTY077, ES.QTY078, ES.QTY079, ES.QTY080
                             , ES.QTY081, ES.QTY082, ES.QTY083, ES.QTY084, ES.QTY085, ES.QTY086, ES.QTY087, ES.QTY088
                             , ES.QTY089, ES.QTY090, ES.QTY091, ES.QTY092, ES.QTY093, ES.QTY094, ES.QTY095, ES.QTY096
                             , ES.QTY097, ES.QTY098, ES.QTY099, ES.QTY100, ES.QTY101, ES.QTY102, ES.QTY103, ES.QTY104
                             , ES.QTY105, ES.QTY106, ES.QTY107, ES.QTY108, ES.QTY109, ES.QTY110, ES.QTY111, ES.QTY112
                             , ES.QTY113, ES.QTY114, ES.QTY115, ES.QTY116, ES.QTY117, ES.QTY118, ES.QTY119, ES.QTY120
                             , ES.QTY121, ES.QTY122, ES.QTY123, ES.QTY124, ES.QTY125, ES.QTY126, ES.QTY127, ES.QTY128
                             , ES.QTY129, ES.QTY130, ES.QTY131, ES.QTY132, ES.QTY133, ES.QTY134, ES.QTY135, ES.QTY136
                             , ES.QTY137, ES.QTY138, ES.QTY139, ES.QTY140, ES.QTY141, ES.QTY142, ES.QTY143, ES.QTY144
                             , ES.QTY145, ES.QTY146, ES.QTY147, ES.QTY148, ES.QTY149, ES.QTY150, ES.QTY151, ES.QTY152
                             , ES.QTY153, ES.QTY154, ES.QTY155, ES.QTY156, ES.QTY157, ES.QTY158, ES.QTY159, ES.QTY160
                             , ES.QTY161, ES.QTY162, ES.QTY163, ES.QTY164, ES.QTY165, ES.QTY166, ES.QTY167, ES.QTY168
                             , ES.QTY169, ES.QTY170, ES.QTY171, ES.QTY172, ES.QTY173, ES.QTY174, ES.QTY175, ES.QTY176
                             , ES.QTY177, ES.QTY178, ES.QTY179, ES.QTY180, ES.QTY181, ES.QTY182, ES.QTY183, ES.QTY184
                             , ES.QTY185, ES.QTY186, ES.QTY187, ES.QTY188, ES.QTY189, ES.QTY190, ES.QTY191, ES.QTY192
                             , ES.QTY193, ES.QTY194, ES.QTY195, ES.QTY196, ES.QTY197, ES.QTY198, ES.QTY199, ES.QTY200
                             , ES.QTY201, ES.QTY202, ES.QTY203, ES.QTY204, ES.QTY205, ES.QTY206, ES.QTY207, ES.QTY208
                             , ES.QTY209, ES.QTY210, ES.QTY211, ES.QTY212, ES.QTY213, ES.QTY214, ES.QTY215, ES.QTY216
                             , ES.QTY217, ES.QTY218, ES.QTY219, ES.QTY220, ES.QTY221, ES.QTY222, ES.QTY223, ES.QTY224
                             , ES.QTY225, ES.QTY226, ES.QTY227, ES.QTY228, ES.QTY229, ES.QTY230, ES.QTY231, ES.QTY232
                             , ES.QTY233, ES.QTY234, ES.QTY235, ES.QTY236, ES.QTY237, ES.QTY238, ES.QTY239, ES.QTY240
                             , ES.QTY241, ES.QTY242, ES.QTY243, ES.QTY244, ES.QTY245, ES.QTY246, ES.QTY247, ES.QTY248
                             , ES.QTY249, ES.QTY250, ES.QTY251, ES.QTY252, ES.QTY253, ES.QTY254, ES.QTY255, ES.QTY256
                             , ES.QTY257, ES.QTY258, ES.QTY259, ES.QTY260, ES.QTY261, ES.QTY262, ES.QTY263, ES.QTY264
                             , ES.QTY265, ES.QTY266, ES.QTY267, ES.QTY268, ES.QTY269, ES.QTY270, ES.QTY271, ES.QTY272
                             , ES.QTY273, ES.QTY274, ES.QTY275, ES.QTY276, ES.QTY277, ES.QTY278, ES.QTY279, ES.QTY280
                             , ES.QTY281, ES.QTY282, ES.QTY283, ES.QTY284, ES.QTY285, ES.QTY286, ES.QTY287, ES.QTY288
                             , ES.QTY289, ES.QTY290, ES.QTY291, ES.QTY292, ES.QTY293, ES.QTY294, ES.QTY295, ES.QTY296
                             , ES.QTY297, ES.QTY298, ES.QTY299, ES.QTY300, ES.QTY301, ES.QTY302, ES.QTY303, ES.QTY304
                             , ES.QTY305, ES.QTY306, ES.QTY307, ES.QTY308, ES.QTY309, ES.QTY310, ES.QTY311, ES.QTY312
                             , ES.QTY313, ES.QTY314, ES.QTY315, ES.QTY316, ES.QTY317, ES.QTY318, ES.QTY319, ES.QTY320
                             , ES.QTY321, ES.QTY322, ES.QTY323, ES.QTY324, ES.QTY325, ES.QTY326, ES.QTY327, ES.QTY328
                             , ES.QTY329, ES.QTY330, ES.QTY331, ES.QTY332, ES.QTY333, ES.QTY334, ES.QTY335, ES.QTY336
                             , ES.QTY337, ES.QTY338, ES.QTY339, ES.QTY340, ES.QTY341, ES.QTY342, ES.QTY343, ES.QTY344
                             , ES.QTY345, ES.QTY346, ES.QTY347, ES.QTY348, ES.QTY349, ES.QTY350, ES.QTY351, ES.QTY352
                             , ES.QTY353, ES.QTY354, ES.QTY355, ES.QTY356, ES.QTY357, ES.QTY358, ES.QTY359, ES.QTY360
                             , ES.QTY361, ES.QTY362, ES.QTY363, ES.QTY364, ES.WQTY01, ES.WQTY02, ES.WQTY03, ES.WQTY04
                             , ES.WQTY05, ES.WQTY06, ES.WQTY07, ES.WQTY08, ES.WQTY09, ES.WQTY10, ES.WQTY11, ES.WQTY12
                             , ES.WQTY13, ES.WQTY14, ES.WQTY15, ES.WQTY16, ES.WQTY17, ES.WQTY18, ES.WQTY19, ES.WQTY20
                             , ES.WQTY21, ES.WQTY22, ES.WQTY23, ES.WQTY24, ES.WQTY25, ES.WQTY26, ES.WQTY27, ES.WQTY28
                             , ES.WQTY29, ES.WQTY30, ES.WQTY31, ES.WQTY32, ES.WQTY33, ES.WQTY34, ES.WQTY35, ES.WQTY36
                             , ES.WQTY37, ES.WQTY38, ES.WQTY39, ES.WQTY40, ES.WQTY41, ES.WQTY42, ES.WQTY43, ES.WQTY44
                             , ES.WQTY45, ES.WQTY46, ES.WQTY47, ES.WQTY48, ES.WQTY49, ES.WQTY50, ES.WQTY51, ES.WQTY52
                             , SYSDATE, V_BATCH_USER_ID || '(XLSPSI06)'
                               FROM SCP_XLS_PSI_GLOBAL_ESS ES
                                  , GT_XPGT_JV_ESS_SCM_SITE_MAP SM
                                  , GT_XPGT_DIVISION_LAST_PLAN_INFO VD
                                  , GT_XPGT_JV_ESS_LINE_MAP MP
                              WHERE SM.VP_DIVISION_ID          = ES.DIVISION_ID
                                AND SM.VP_SCM_SITE_ID          = ES.FROM_SITE
                                AND VD.DIVISION_ID             = SM.RP_DIVISION_ID
                                AND VD.PLAN_START_YYYYMMDD     = ES.PLAN_START_YYYYMMDD
                                AND MP.VL_COMPANY_ID           = SM.VP_COMPANY_ID
                                AND MP.VL_DIVISION_ID          = SM.VP_DIVISION_ID
                                AND MP.VL_SITE_ID              = SM.VP_SITE_ID
                                AND MP.VL_PLANT_ID             = SM.VP_PLANT_ID
                                AND MP.VL_LINE_ID              = ES.PROD_LINE
                                AND JV.DIVISION_ID             = VD.DIVISION_ID
                                AND JV.PLAN_START_YYYYMMDD     = VD.PLAN_START_YYYYMMDD
                                AND JV.PLAN_TYPE               = VD.PLAN_TYPE
                                AND JV.SEQ                     = VD.PLAN_SEQ
                                AND JV.FROM_SITE               = SM.RP_SCM_SITE_ID
                                AND JV.PROD_LINE               = MP.RL_LINE_ID
                                AND JV.MEASURE                 = ES.MEASURE
                                AND JV.ITEM_ID                 = ES.ITEM_ID
                                AND JV.CELL_ITEM_ID            = ES.CELL_ITEM_ID
                                AND JV.CREATE_FROM_YYYYMMDD    = ES.CREATE_FROM_YYYYMMDD
                                AND 0 = 0
                                AND ES.DIVISION_ID             = V_BATCH_DIVISION_ID
                                AND ES.PLAN_START_YYYYMMDD     = V_BATCH_PLAN_START_YYYYMMDD
                                AND ES.CREATE_FROM_YYYYMMDD    = V_BATCH_CREATE_FROM_YYYYMMDD
                                AND ES.SEQ                     = V_BATCH_SEQ
                                AND ES.XLS_KEY1                = V_BATCH_XLS_KEY1
                                AND ES.OPERATION_GROUP         = 'A'
                                AND ES.MEASURE                 = 'CELL_PROD'
                                AND ROWNUM = 1 )
                     WHERE EXISTS ( SELECT 1
                                      FROM SCP_XLS_PSI_GLOBAL_ESS ES
                                         , GT_XPGT_JV_ESS_SCM_SITE_MAP SM
                                         , GT_XPGT_DIVISION_LAST_PLAN_INFO VD
                                         , GT_XPGT_JV_ESS_LINE_MAP MP
                                     WHERE SM.VP_DIVISION_ID          = ES.DIVISION_ID
                                       AND SM.VP_SCM_SITE_ID          = ES.FROM_SITE
                                       AND VD.DIVISION_ID             = SM.RP_DIVISION_ID
                                       AND VD.PLAN_START_YYYYMMDD     = ES.PLAN_START_YYYYMMDD
                                       AND MP.VL_COMPANY_ID           = SM.VP_COMPANY_ID
                                       AND MP.VL_DIVISION_ID          = SM.VP_DIVISION_ID
                                       AND MP.VL_SITE_ID              = SM.VP_SITE_ID
                                       AND MP.VL_PLANT_ID             = SM.VP_PLANT_ID
                                       AND MP.VL_LINE_ID              = ES.PROD_LINE
                                       AND JV.DIVISION_ID             = VD.DIVISION_ID
                                       AND JV.PLAN_START_YYYYMMDD     = VD.PLAN_START_YYYYMMDD
                                       AND JV.PLAN_TYPE               = VD.PLAN_TYPE
                                       AND JV.SEQ                     = VD.PLAN_SEQ
                                       AND JV.FROM_SITE               = SM.RP_SCM_SITE_ID
                                       AND JV.PROD_LINE               = MP.RL_LINE_ID
                                       AND JV.MEASURE                 = ES.MEASURE
                                       AND JV.ITEM_ID                 = ES.ITEM_ID
                                       AND JV.CELL_ITEM_ID            = ES.CELL_ITEM_ID
                                       AND JV.CREATE_FROM_YYYYMMDD    = ES.CREATE_FROM_YYYYMMDD
                                       AND 0 = 0
                                       AND ES.DIVISION_ID             = V_BATCH_DIVISION_ID
                                       AND ES.PLAN_START_YYYYMMDD     = V_BATCH_PLAN_START_YYYYMMDD
                                       AND ES.CREATE_FROM_YYYYMMDD    = V_BATCH_CREATE_FROM_YYYYMMDD
                                       AND ES.SEQ                     = V_BATCH_SEQ
                                       AND ES.XLS_KEY1                = V_BATCH_XLS_KEY1
                                       AND ES.OPERATION_GROUP         = 'A'
                                       AND ES.MEASURE                 = 'CELL_PROD'
                                  )
                         ;
                    /* -------------------------------------------------------------------------------------------------------------------------------------------------------
                    --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (CELL_PROD)
                    ------------------------------------------------------------------------------------------------------------------------------------------------------- */
               END IF;   /*  @p_day_week_flag = 'week' */


            END IF;


            /* ------------------------------------------------------------------------------------------- */
            /*  'SHIP_PLAN','SEMI_SHIP_PLAN' 일경우 지정 요일에 저장 */
            /*   대상 주QTY가 -9 일경우는 기존 값(0)을 사용하고, +일경우는 값을 UPDATE한다. */
            /* ------------------------------------------------------------------------------------------- */
            /* ------------------------------------------------------------------------------------------- */
            IF V_BATCH_MEASURE IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN') THEN

                  /* PRINT 'eee' */
                IF V_BATCH_DAY_WEEK_FLAG = 'week' THEN

                /*  IF OBJECT_ID('tempdb..#tmp_PARTIAL_INFO') IS NOT NULL DROP TABLE #tmp_PARTIAL_INFO ;
                    CREATE TABLE #tmp_PARTIAL_INFO (C1 INT, C2 INT); */
                    DELETE FROM GT_XPGT_PARTIAL_INFO;

                    /*  MSSQL 다중행 VALUES (1,2),(2,3),.. 는 Oracle 미지원 -> INSERT ALL */
                    INSERT ALL
                      INTO GT_XPGT_PARTIAL_INFO ( C1, C2 ) VALUES (1, 2)
                      INTO GT_XPGT_PARTIAL_INFO ( C1, C2 ) VALUES (2, 3)
                      INTO GT_XPGT_PARTIAL_INFO ( C1, C2 ) VALUES (3, 4)
                      INTO GT_XPGT_PARTIAL_INFO ( C1, C2 ) VALUES (4, 5)
                      INTO GT_XPGT_PARTIAL_INFO ( C1, C2 ) VALUES (5, 6)
                      INTO GT_XPGT_PARTIAL_INFO ( C1, C2 ) VALUES (6, 7)
                      INTO GT_XPGT_PARTIAL_INFO ( C1, C2 ) VALUES (7, 1)
                    SELECT 1 FROM DUAL
                         ;

                /*  IF OBJECT_ID('tempdb..#WEEK_QTY_TBL2') IS NOT NULL DROP TABLE #WEEK_QTY_TBL2
                    CREATE TABLE #WEEK_QTY_TBL2 ( WQTY01 INT , .. , WQTY52 INT ); */
                    DELETE FROM GT_XPGT_WEEK_QTY_TBL2;

                    INSERT INTO GT_XPGT_WEEK_QTY_TBL2
                         ( WQTY01, WQTY02, WQTY03, WQTY04, WQTY05
                         , WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                         , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15
                         , WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                         , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25
                         , WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                         , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35
                         , WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                         , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45
                         , WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                         , WQTY51, WQTY52
                         )
                    SELECT P_WQTY01, P_WQTY02, P_WQTY03, P_WQTY04, P_WQTY05
                         , P_WQTY06, P_WQTY07, P_WQTY08, P_WQTY09, P_WQTY10
                         , P_WQTY11, P_WQTY12, P_WQTY13, P_WQTY14, P_WQTY15
                         , P_WQTY16, P_WQTY17, P_WQTY18, P_WQTY19, P_WQTY20
                         , P_WQTY21, P_WQTY22, P_WQTY23, P_WQTY24, P_WQTY25
                         , P_WQTY26, P_WQTY27, P_WQTY28, P_WQTY29, P_WQTY30
                         , P_WQTY31, P_WQTY32, P_WQTY33, P_WQTY34, P_WQTY35
                         , P_WQTY36, P_WQTY37, P_WQTY38, P_WQTY39, P_WQTY40
                         , P_WQTY41, P_WQTY42, P_WQTY43, P_WQTY44, P_WQTY45
                         , P_WQTY46, P_WQTY47, P_WQTY48, P_WQTY49, P_WQTY50
                         , P_WQTY51, P_WQTY52
                      FROM DUAL
                         ;

                /*  IF OBJECT_ID('tempdb..#TMP_PARTIAL_SHP_QTY') IS NOT NULL DROP TABLE #TMP_PARTIAL_SHP_QTY; */
                    DELETE FROM GT_XPGT_PARTIAL_SHP_QTY;


                    INSERT INTO GT_XPGT_PARTIAL_SHP_QTY
                         ( NUM
                         , ITEM
                         , WQTY )
                    SELECT TO_NUMBER(SUBSTR(ITEM, GREATEST(LENGTH(ITEM) - 1, 1))) AS NUM
                         , ITEM
                         , WQTY
                      FROM GT_XPGT_WEEK_QTY_TBL2
                     UNPIVOT ( WQTY FOR ITEM IN (
                                   WQTY01 AS 'WQTY01', WQTY02 AS 'WQTY02', WQTY03 AS 'WQTY03', WQTY04 AS 'WQTY04', WQTY05 AS 'WQTY05'
                                 , WQTY06 AS 'WQTY06', WQTY07 AS 'WQTY07', WQTY08 AS 'WQTY08', WQTY09 AS 'WQTY09', WQTY10 AS 'WQTY10'
                                 , WQTY11 AS 'WQTY11', WQTY12 AS 'WQTY12', WQTY13 AS 'WQTY13', WQTY14 AS 'WQTY14', WQTY15 AS 'WQTY15'
                                 , WQTY16 AS 'WQTY16', WQTY17 AS 'WQTY17', WQTY18 AS 'WQTY18', WQTY19 AS 'WQTY19', WQTY20 AS 'WQTY20'
                                 , WQTY21 AS 'WQTY21', WQTY22 AS 'WQTY22', WQTY23 AS 'WQTY23', WQTY24 AS 'WQTY24', WQTY25 AS 'WQTY25'
                                 , WQTY26 AS 'WQTY26', WQTY27 AS 'WQTY27', WQTY28 AS 'WQTY28', WQTY29 AS 'WQTY29', WQTY30 AS 'WQTY30'
                                 , WQTY31 AS 'WQTY31', WQTY32 AS 'WQTY32', WQTY33 AS 'WQTY33', WQTY34 AS 'WQTY34', WQTY35 AS 'WQTY35'
                                 , WQTY36 AS 'WQTY36', WQTY37 AS 'WQTY37', WQTY38 AS 'WQTY38', WQTY39 AS 'WQTY39', WQTY40 AS 'WQTY40'
                                 , WQTY41 AS 'WQTY41', WQTY42 AS 'WQTY42', WQTY43 AS 'WQTY43', WQTY44 AS 'WQTY44', WQTY45 AS 'WQTY45'
                                 , WQTY46 AS 'WQTY46', WQTY47 AS 'WQTY47', WQTY48 AS 'WQTY48', WQTY49 AS 'WQTY49', WQTY50 AS 'WQTY50'
                                 , WQTY51 AS 'WQTY51', WQTY52 AS 'WQTY52'
                                                ) ) UN
                         ;

              /*  IF OBJECT_ID('tempdb..#TMP_PARTIAL_SHP_DATA') IS NOT NULL DROP TABLE #TMP_PARTIAL_SHP_DATA
                    CREATE TABLE #TMP_PARTIAL_SHP_DATA( XLS_KEY1 INT NOT NULL, DIVISION_ID NVARCHAR(30) NOT NULL,
                      CREATE_FROM_YYYYMMDD NVARCHAR(8) NOT NULL, WEEKNO INT NOT NULL, LAST_MOD int NULL,
                      YYYYMMDD_COLUMN nvarchar(10) NULL, QTY int NULL ); */
                    DELETE FROM GT_XPGT_PARTIAL_SHP_DATA;


                    INSERT INTO GT_XPGT_PARTIAL_SHP_DATA
                         ( XLS_KEY1
                         , DIVISION_ID
                         , CREATE_FROM_YYYYMMDD
                         , WEEKNO
                         , LAST_MOD
                         , YYYYMMDD_COLUMN
                         , QTY )
                    SELECT XLS_KEY1
                         , DIVISION_ID
                         , CREATE_FROM_YYYYMMDD
                         , TRUNC((TO_NUMBER(SUBSTR(YYYYMMDD_COLUMN, GREATEST(LENGTH(YYYYMMDD_COLUMN) - 2, 1))) - 1) / 7) + 1 AS WEEKNO
                         , CASE WHEN MOD(TO_NUMBER(SUBSTR(YYYYMMDD_COLUMN, GREATEST(LENGTH(YYYYMMDD_COLUMN) - 2, 1))), 7) = 0 THEN 7
                                ELSE MOD(TO_NUMBER(SUBSTR(YYYYMMDD_COLUMN, GREATEST(LENGTH(YYYYMMDD_COLUMN) - 2, 1))), 7) END AS LAST_MOD
                         , YYYYMMDD_COLUMN
                         , QTY
                      FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL_TEMP
                     UNPIVOT (
                              QTY FOR YYYYMMDD_COLUMN IN (
                                            QTY001 AS 'QTY001', QTY002 AS 'QTY002', QTY003 AS 'QTY003', QTY004 AS 'QTY004', QTY005 AS 'QTY005'
                                          , QTY006 AS 'QTY006', QTY007 AS 'QTY007', QTY008 AS 'QTY008', QTY009 AS 'QTY009', QTY010 AS 'QTY010'
                                          , QTY011 AS 'QTY011', QTY012 AS 'QTY012', QTY013 AS 'QTY013', QTY014 AS 'QTY014', QTY015 AS 'QTY015'
                                          , QTY016 AS 'QTY016', QTY017 AS 'QTY017', QTY018 AS 'QTY018', QTY019 AS 'QTY019', QTY020 AS 'QTY020'
                                          , QTY021 AS 'QTY021', QTY022 AS 'QTY022', QTY023 AS 'QTY023', QTY024 AS 'QTY024', QTY025 AS 'QTY025'
                                          , QTY026 AS 'QTY026', QTY027 AS 'QTY027', QTY028 AS 'QTY028', QTY029 AS 'QTY029', QTY030 AS 'QTY030'
                                          , QTY031 AS 'QTY031', QTY032 AS 'QTY032', QTY033 AS 'QTY033', QTY034 AS 'QTY034', QTY035 AS 'QTY035'
                                          , QTY036 AS 'QTY036', QTY037 AS 'QTY037', QTY038 AS 'QTY038', QTY039 AS 'QTY039', QTY040 AS 'QTY040'
                                          , QTY041 AS 'QTY041', QTY042 AS 'QTY042', QTY043 AS 'QTY043', QTY044 AS 'QTY044', QTY045 AS 'QTY045'
                                          , QTY046 AS 'QTY046', QTY047 AS 'QTY047', QTY048 AS 'QTY048', QTY049 AS 'QTY049', QTY050 AS 'QTY050'
                                          , QTY051 AS 'QTY051', QTY052 AS 'QTY052', QTY053 AS 'QTY053', QTY054 AS 'QTY054', QTY055 AS 'QTY055'
                                          , QTY056 AS 'QTY056', QTY057 AS 'QTY057', QTY058 AS 'QTY058', QTY059 AS 'QTY059', QTY060 AS 'QTY060'
                                          , QTY061 AS 'QTY061', QTY062 AS 'QTY062', QTY063 AS 'QTY063', QTY064 AS 'QTY064', QTY065 AS 'QTY065'
                                          , QTY066 AS 'QTY066', QTY067 AS 'QTY067', QTY068 AS 'QTY068', QTY069 AS 'QTY069', QTY070 AS 'QTY070'
                                          , QTY071 AS 'QTY071', QTY072 AS 'QTY072', QTY073 AS 'QTY073', QTY074 AS 'QTY074', QTY075 AS 'QTY075'
                                          , QTY076 AS 'QTY076', QTY077 AS 'QTY077', QTY078 AS 'QTY078', QTY079 AS 'QTY079', QTY080 AS 'QTY080'
                                          , QTY081 AS 'QTY081', QTY082 AS 'QTY082', QTY083 AS 'QTY083', QTY084 AS 'QTY084', QTY085 AS 'QTY085'
                                          , QTY086 AS 'QTY086', QTY087 AS 'QTY087', QTY088 AS 'QTY088', QTY089 AS 'QTY089', QTY090 AS 'QTY090'
                                          , QTY091 AS 'QTY091', QTY092 AS 'QTY092', QTY093 AS 'QTY093', QTY094 AS 'QTY094', QTY095 AS 'QTY095'
                                          , QTY096 AS 'QTY096', QTY097 AS 'QTY097', QTY098 AS 'QTY098', QTY099 AS 'QTY099', QTY100 AS 'QTY100'
                                          , QTY101 AS 'QTY101', QTY102 AS 'QTY102', QTY103 AS 'QTY103', QTY104 AS 'QTY104', QTY105 AS 'QTY105'
                                          , QTY106 AS 'QTY106', QTY107 AS 'QTY107', QTY108 AS 'QTY108', QTY109 AS 'QTY109', QTY110 AS 'QTY110'
                                          , QTY111 AS 'QTY111', QTY112 AS 'QTY112', QTY113 AS 'QTY113', QTY114 AS 'QTY114', QTY115 AS 'QTY115'
                                          , QTY116 AS 'QTY116', QTY117 AS 'QTY117', QTY118 AS 'QTY118', QTY119 AS 'QTY119', QTY120 AS 'QTY120'
                                          , QTY121 AS 'QTY121', QTY122 AS 'QTY122', QTY123 AS 'QTY123', QTY124 AS 'QTY124', QTY125 AS 'QTY125'
                                          , QTY126 AS 'QTY126', QTY127 AS 'QTY127', QTY128 AS 'QTY128', QTY129 AS 'QTY129', QTY130 AS 'QTY130'
                                          , QTY131 AS 'QTY131', QTY132 AS 'QTY132', QTY133 AS 'QTY133', QTY134 AS 'QTY134', QTY135 AS 'QTY135'
                                          , QTY136 AS 'QTY136', QTY137 AS 'QTY137', QTY138 AS 'QTY138', QTY139 AS 'QTY139', QTY140 AS 'QTY140'
                                          , QTY141 AS 'QTY141', QTY142 AS 'QTY142', QTY143 AS 'QTY143', QTY144 AS 'QTY144', QTY145 AS 'QTY145'
                                          , QTY146 AS 'QTY146', QTY147 AS 'QTY147', QTY148 AS 'QTY148', QTY149 AS 'QTY149', QTY150 AS 'QTY150'
                                          , QTY151 AS 'QTY151', QTY152 AS 'QTY152', QTY153 AS 'QTY153', QTY154 AS 'QTY154', QTY155 AS 'QTY155'
                                          , QTY156 AS 'QTY156', QTY157 AS 'QTY157', QTY158 AS 'QTY158', QTY159 AS 'QTY159', QTY160 AS 'QTY160'
                                          , QTY161 AS 'QTY161', QTY162 AS 'QTY162', QTY163 AS 'QTY163', QTY164 AS 'QTY164', QTY165 AS 'QTY165'
                                          , QTY166 AS 'QTY166', QTY167 AS 'QTY167', QTY168 AS 'QTY168', QTY169 AS 'QTY169', QTY170 AS 'QTY170'
                                          , QTY171 AS 'QTY171', QTY172 AS 'QTY172', QTY173 AS 'QTY173', QTY174 AS 'QTY174', QTY175 AS 'QTY175'
                                          , QTY176 AS 'QTY176', QTY177 AS 'QTY177', QTY178 AS 'QTY178', QTY179 AS 'QTY179', QTY180 AS 'QTY180'
                                          , QTY181 AS 'QTY181', QTY182 AS 'QTY182', QTY183 AS 'QTY183', QTY184 AS 'QTY184', QTY185 AS 'QTY185'
                                          , QTY186 AS 'QTY186', QTY187 AS 'QTY187', QTY188 AS 'QTY188', QTY189 AS 'QTY189', QTY190 AS 'QTY190'
                                          , QTY191 AS 'QTY191', QTY192 AS 'QTY192', QTY193 AS 'QTY193', QTY194 AS 'QTY194', QTY195 AS 'QTY195'
                                          , QTY196 AS 'QTY196', QTY197 AS 'QTY197', QTY198 AS 'QTY198', QTY199 AS 'QTY199', QTY200 AS 'QTY200'
                                          , QTY201 AS 'QTY201', QTY202 AS 'QTY202', QTY203 AS 'QTY203', QTY204 AS 'QTY204', QTY205 AS 'QTY205'
                                          , QTY206 AS 'QTY206', QTY207 AS 'QTY207', QTY208 AS 'QTY208', QTY209 AS 'QTY209', QTY210 AS 'QTY210'
                                          , QTY211 AS 'QTY211', QTY212 AS 'QTY212', QTY213 AS 'QTY213', QTY214 AS 'QTY214', QTY215 AS 'QTY215'
                                          , QTY216 AS 'QTY216', QTY217 AS 'QTY217', QTY218 AS 'QTY218', QTY219 AS 'QTY219', QTY220 AS 'QTY220'
                                          , QTY221 AS 'QTY221', QTY222 AS 'QTY222', QTY223 AS 'QTY223', QTY224 AS 'QTY224', QTY225 AS 'QTY225'
                                          , QTY226 AS 'QTY226', QTY227 AS 'QTY227', QTY228 AS 'QTY228', QTY229 AS 'QTY229', QTY230 AS 'QTY230'
                                          , QTY231 AS 'QTY231', QTY232 AS 'QTY232', QTY233 AS 'QTY233', QTY234 AS 'QTY234', QTY235 AS 'QTY235'
                                          , QTY236 AS 'QTY236', QTY237 AS 'QTY237', QTY238 AS 'QTY238', QTY239 AS 'QTY239', QTY240 AS 'QTY240'
                                          , QTY241 AS 'QTY241', QTY242 AS 'QTY242', QTY243 AS 'QTY243', QTY244 AS 'QTY244', QTY245 AS 'QTY245'
                                          , QTY246 AS 'QTY246', QTY247 AS 'QTY247', QTY248 AS 'QTY248', QTY249 AS 'QTY249', QTY250 AS 'QTY250'
                                          , QTY251 AS 'QTY251', QTY252 AS 'QTY252', QTY253 AS 'QTY253', QTY254 AS 'QTY254', QTY255 AS 'QTY255'
                                          , QTY256 AS 'QTY256', QTY257 AS 'QTY257', QTY258 AS 'QTY258', QTY259 AS 'QTY259', QTY260 AS 'QTY260'
                                          , QTY261 AS 'QTY261', QTY262 AS 'QTY262', QTY263 AS 'QTY263', QTY264 AS 'QTY264', QTY265 AS 'QTY265'
                                          , QTY266 AS 'QTY266', QTY267 AS 'QTY267', QTY268 AS 'QTY268', QTY269 AS 'QTY269', QTY270 AS 'QTY270'
                                          , QTY271 AS 'QTY271', QTY272 AS 'QTY272', QTY273 AS 'QTY273', QTY274 AS 'QTY274', QTY275 AS 'QTY275'
                                          , QTY276 AS 'QTY276', QTY277 AS 'QTY277', QTY278 AS 'QTY278', QTY279 AS 'QTY279', QTY280 AS 'QTY280'
                                          , QTY281 AS 'QTY281', QTY282 AS 'QTY282', QTY283 AS 'QTY283', QTY284 AS 'QTY284', QTY285 AS 'QTY285'
                                          , QTY286 AS 'QTY286', QTY287 AS 'QTY287', QTY288 AS 'QTY288', QTY289 AS 'QTY289', QTY290 AS 'QTY290'
                                          , QTY291 AS 'QTY291', QTY292 AS 'QTY292', QTY293 AS 'QTY293', QTY294 AS 'QTY294', QTY295 AS 'QTY295'
                                          , QTY296 AS 'QTY296', QTY297 AS 'QTY297', QTY298 AS 'QTY298', QTY299 AS 'QTY299', QTY300 AS 'QTY300'
                                          , QTY301 AS 'QTY301', QTY302 AS 'QTY302', QTY303 AS 'QTY303', QTY304 AS 'QTY304', QTY305 AS 'QTY305'
                                          , QTY306 AS 'QTY306', QTY307 AS 'QTY307', QTY308 AS 'QTY308', QTY309 AS 'QTY309', QTY310 AS 'QTY310'
                                          , QTY311 AS 'QTY311', QTY312 AS 'QTY312', QTY313 AS 'QTY313', QTY314 AS 'QTY314', QTY315 AS 'QTY315'
                                          , QTY316 AS 'QTY316', QTY317 AS 'QTY317', QTY318 AS 'QTY318', QTY319 AS 'QTY319', QTY320 AS 'QTY320'
                                          , QTY321 AS 'QTY321', QTY322 AS 'QTY322', QTY323 AS 'QTY323', QTY324 AS 'QTY324', QTY325 AS 'QTY325'
                                          , QTY326 AS 'QTY326', QTY327 AS 'QTY327', QTY328 AS 'QTY328', QTY329 AS 'QTY329', QTY330 AS 'QTY330'
                                          , QTY331 AS 'QTY331', QTY332 AS 'QTY332', QTY333 AS 'QTY333', QTY334 AS 'QTY334', QTY335 AS 'QTY335'
                                          , QTY336 AS 'QTY336', QTY337 AS 'QTY337', QTY338 AS 'QTY338', QTY339 AS 'QTY339', QTY340 AS 'QTY340'
                                          , QTY341 AS 'QTY341', QTY342 AS 'QTY342', QTY343 AS 'QTY343', QTY344 AS 'QTY344', QTY345 AS 'QTY345'
                                          , QTY346 AS 'QTY346', QTY347 AS 'QTY347', QTY348 AS 'QTY348', QTY349 AS 'QTY349', QTY350 AS 'QTY350'
                                          , QTY351 AS 'QTY351', QTY352 AS 'QTY352', QTY353 AS 'QTY353', QTY354 AS 'QTY354', QTY355 AS 'QTY355'
                                          , QTY356 AS 'QTY356', QTY357 AS 'QTY357', QTY358 AS 'QTY358', QTY359 AS 'QTY359', QTY360 AS 'QTY360'
                                          , QTY361 AS 'QTY361', QTY362 AS 'QTY362', QTY363 AS 'QTY363', QTY364 AS 'QTY364'
                                                         )
                             ) UN
                         ;

                /*                    -> GTT GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL 재사용(계열 형제와 공유, SCP_XLS_PSI_GLOBAL_ESS 468컬럼 형상).
                    ★MSSQL SELECT INTO 는 367컬럼(DIVISION_ID, XLS_KEY1, CREATE_FROM_YYYYMMDD, QTY001~364)만 만들지만
                      GTT 는 그 상위집합이라 컬럼목록을 명시해 INSERT 한다(SELECT * 금지). 뒤의 소비도 전부 이름 참조다. */
                    DELETE FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL;

                    INSERT INTO GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL
                         ( DIVISION_ID
                         , XLS_KEY1
                         , CREATE_FROM_YYYYMMDD
                         , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008
                         , QTY009, QTY010, QTY011, QTY012, QTY013, QTY014, QTY015, QTY016
                         , QTY017, QTY018, QTY019, QTY020, QTY021, QTY022, QTY023, QTY024
                         , QTY025, QTY026, QTY027, QTY028, QTY029, QTY030, QTY031, QTY032
                         , QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                         , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048
                         , QTY049, QTY050, QTY051, QTY052, QTY053, QTY054, QTY055, QTY056
                         , QTY057, QTY058, QTY059, QTY060, QTY061, QTY062, QTY063, QTY064
                         , QTY065, QTY066, QTY067, QTY068, QTY069, QTY070, QTY071, QTY072
                         , QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                         , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088
                         , QTY089, QTY090, QTY091, QTY092, QTY093, QTY094, QTY095, QTY096
                         , QTY097, QTY098, QTY099, QTY100, QTY101, QTY102, QTY103, QTY104
                         , QTY105, QTY106, QTY107, QTY108, QTY109, QTY110, QTY111, QTY112
                         , QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                         , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128
                         , QTY129, QTY130, QTY131, QTY132, QTY133, QTY134, QTY135, QTY136
                         , QTY137, QTY138, QTY139, QTY140, QTY141, QTY142, QTY143, QTY144
                         , QTY145, QTY146, QTY147, QTY148, QTY149, QTY150, QTY151, QTY152
                         , QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                         , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168
                         , QTY169, QTY170, QTY171, QTY172, QTY173, QTY174, QTY175, QTY176
                         , QTY177, QTY178, QTY179, QTY180, QTY181, QTY182, QTY183, QTY184
                         , QTY185, QTY186, QTY187, QTY188, QTY189, QTY190, QTY191, QTY192
                         , QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                         , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208
                         , QTY209, QTY210, QTY211, QTY212, QTY213, QTY214, QTY215, QTY216
                         , QTY217, QTY218, QTY219, QTY220, QTY221, QTY222, QTY223, QTY224
                         , QTY225, QTY226, QTY227, QTY228, QTY229, QTY230, QTY231, QTY232
                         , QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                         , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248
                         , QTY249, QTY250, QTY251, QTY252, QTY253, QTY254, QTY255, QTY256
                         , QTY257, QTY258, QTY259, QTY260, QTY261, QTY262, QTY263, QTY264
                         , QTY265, QTY266, QTY267, QTY268, QTY269, QTY270, QTY271, QTY272
                         , QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                         , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288
                         , QTY289, QTY290, QTY291, QTY292, QTY293, QTY294, QTY295, QTY296
                         , QTY297, QTY298, QTY299, QTY300, QTY301, QTY302, QTY303, QTY304
                         , QTY305, QTY306, QTY307, QTY308, QTY309, QTY310, QTY311, QTY312
                         , QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                         , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328
                         , QTY329, QTY330, QTY331, QTY332, QTY333, QTY334, QTY335, QTY336
                         , QTY337, QTY338, QTY339, QTY340, QTY341, QTY342, QTY343, QTY344
                         , QTY345, QTY346, QTY347, QTY348, QTY349, QTY350, QTY351, QTY352
                         , QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                         , QTY361, QTY362, QTY363, QTY364
                         )
                    SELECT S.DIVISION_ID
                         , S.XLS_KEY1
                         , S.CREATE_FROM_YYYYMMDD
                         , SUM(S.QTY001) AS QTY001, SUM(S.QTY002) AS QTY002, SUM(S.QTY003) AS QTY003, SUM(S.QTY004) AS QTY004, SUM(S.QTY005) AS QTY005
                         , SUM(S.QTY006) AS QTY006, SUM(S.QTY007) AS QTY007, SUM(S.QTY008) AS QTY008, SUM(S.QTY009) AS QTY009, SUM(S.QTY010) AS QTY010
                         , SUM(S.QTY011) AS QTY011, SUM(S.QTY012) AS QTY012, SUM(S.QTY013) AS QTY013, SUM(S.QTY014) AS QTY014, SUM(S.QTY015) AS QTY015
                         , SUM(S.QTY016) AS QTY016, SUM(S.QTY017) AS QTY017, SUM(S.QTY018) AS QTY018, SUM(S.QTY019) AS QTY019, SUM(S.QTY020) AS QTY020
                         , SUM(S.QTY021) AS QTY021, SUM(S.QTY022) AS QTY022, SUM(S.QTY023) AS QTY023, SUM(S.QTY024) AS QTY024, SUM(S.QTY025) AS QTY025
                         , SUM(S.QTY026) AS QTY026, SUM(S.QTY027) AS QTY027, SUM(S.QTY028) AS QTY028, SUM(S.QTY029) AS QTY029, SUM(S.QTY030) AS QTY030
                         , SUM(S.QTY031) AS QTY031, SUM(S.QTY032) AS QTY032, SUM(S.QTY033) AS QTY033, SUM(S.QTY034) AS QTY034, SUM(S.QTY035) AS QTY035
                         , SUM(S.QTY036) AS QTY036, SUM(S.QTY037) AS QTY037, SUM(S.QTY038) AS QTY038, SUM(S.QTY039) AS QTY039, SUM(S.QTY040) AS QTY040
                         , SUM(S.QTY041) AS QTY041, SUM(S.QTY042) AS QTY042, SUM(S.QTY043) AS QTY043, SUM(S.QTY044) AS QTY044, SUM(S.QTY045) AS QTY045
                         , SUM(S.QTY046) AS QTY046, SUM(S.QTY047) AS QTY047, SUM(S.QTY048) AS QTY048, SUM(S.QTY049) AS QTY049, SUM(S.QTY050) AS QTY050
                         , SUM(S.QTY051) AS QTY051, SUM(S.QTY052) AS QTY052, SUM(S.QTY053) AS QTY053, SUM(S.QTY054) AS QTY054, SUM(S.QTY055) AS QTY055
                         , SUM(S.QTY056) AS QTY056, SUM(S.QTY057) AS QTY057, SUM(S.QTY058) AS QTY058, SUM(S.QTY059) AS QTY059, SUM(S.QTY060) AS QTY060
                         , SUM(S.QTY061) AS QTY061, SUM(S.QTY062) AS QTY062, SUM(S.QTY063) AS QTY063, SUM(S.QTY064) AS QTY064, SUM(S.QTY065) AS QTY065
                         , SUM(S.QTY066) AS QTY066, SUM(S.QTY067) AS QTY067, SUM(S.QTY068) AS QTY068, SUM(S.QTY069) AS QTY069, SUM(S.QTY070) AS QTY070
                         , SUM(S.QTY071) AS QTY071, SUM(S.QTY072) AS QTY072, SUM(S.QTY073) AS QTY073, SUM(S.QTY074) AS QTY074, SUM(S.QTY075) AS QTY075
                         , SUM(S.QTY076) AS QTY076, SUM(S.QTY077) AS QTY077, SUM(S.QTY078) AS QTY078, SUM(S.QTY079) AS QTY079, SUM(S.QTY080) AS QTY080
                         , SUM(S.QTY081) AS QTY081, SUM(S.QTY082) AS QTY082, SUM(S.QTY083) AS QTY083, SUM(S.QTY084) AS QTY084, SUM(S.QTY085) AS QTY085
                         , SUM(S.QTY086) AS QTY086, SUM(S.QTY087) AS QTY087, SUM(S.QTY088) AS QTY088, SUM(S.QTY089) AS QTY089, SUM(S.QTY090) AS QTY090
                         , SUM(S.QTY091) AS QTY091, SUM(S.QTY092) AS QTY092, SUM(S.QTY093) AS QTY093, SUM(S.QTY094) AS QTY094, SUM(S.QTY095) AS QTY095
                         , SUM(S.QTY096) AS QTY096, SUM(S.QTY097) AS QTY097, SUM(S.QTY098) AS QTY098, SUM(S.QTY099) AS QTY099, SUM(S.QTY100) AS QTY100
                         , SUM(S.QTY101) AS QTY101, SUM(S.QTY102) AS QTY102, SUM(S.QTY103) AS QTY103, SUM(S.QTY104) AS QTY104, SUM(S.QTY105) AS QTY105
                         , SUM(S.QTY106) AS QTY106, SUM(S.QTY107) AS QTY107, SUM(S.QTY108) AS QTY108, SUM(S.QTY109) AS QTY109, SUM(S.QTY110) AS QTY110
                         , SUM(S.QTY111) AS QTY111, SUM(S.QTY112) AS QTY112, SUM(S.QTY113) AS QTY113, SUM(S.QTY114) AS QTY114, SUM(S.QTY115) AS QTY115
                         , SUM(S.QTY116) AS QTY116, SUM(S.QTY117) AS QTY117, SUM(S.QTY118) AS QTY118, SUM(S.QTY119) AS QTY119, SUM(S.QTY120) AS QTY120
                         , SUM(S.QTY121) AS QTY121, SUM(S.QTY122) AS QTY122, SUM(S.QTY123) AS QTY123, SUM(S.QTY124) AS QTY124, SUM(S.QTY125) AS QTY125
                         , SUM(S.QTY126) AS QTY126, SUM(S.QTY127) AS QTY127, SUM(S.QTY128) AS QTY128, SUM(S.QTY129) AS QTY129, SUM(S.QTY130) AS QTY130
                         , SUM(S.QTY131) AS QTY131, SUM(S.QTY132) AS QTY132, SUM(S.QTY133) AS QTY133, SUM(S.QTY134) AS QTY134, SUM(S.QTY135) AS QTY135
                         , SUM(S.QTY136) AS QTY136, SUM(S.QTY137) AS QTY137, SUM(S.QTY138) AS QTY138, SUM(S.QTY139) AS QTY139, SUM(S.QTY140) AS QTY140
                         , SUM(S.QTY141) AS QTY141, SUM(S.QTY142) AS QTY142, SUM(S.QTY143) AS QTY143, SUM(S.QTY144) AS QTY144, SUM(S.QTY145) AS QTY145
                         , SUM(S.QTY146) AS QTY146, SUM(S.QTY147) AS QTY147, SUM(S.QTY148) AS QTY148, SUM(S.QTY149) AS QTY149, SUM(S.QTY150) AS QTY150
                         , SUM(S.QTY151) AS QTY151, SUM(S.QTY152) AS QTY152, SUM(S.QTY153) AS QTY153, SUM(S.QTY154) AS QTY154, SUM(S.QTY155) AS QTY155
                         , SUM(S.QTY156) AS QTY156, SUM(S.QTY157) AS QTY157, SUM(S.QTY158) AS QTY158, SUM(S.QTY159) AS QTY159, SUM(S.QTY160) AS QTY160
                         , SUM(S.QTY161) AS QTY161, SUM(S.QTY162) AS QTY162, SUM(S.QTY163) AS QTY163, SUM(S.QTY164) AS QTY164, SUM(S.QTY165) AS QTY165
                         , SUM(S.QTY166) AS QTY166, SUM(S.QTY167) AS QTY167, SUM(S.QTY168) AS QTY168, SUM(S.QTY169) AS QTY169, SUM(S.QTY170) AS QTY170
                         , SUM(S.QTY171) AS QTY171, SUM(S.QTY172) AS QTY172, SUM(S.QTY173) AS QTY173, SUM(S.QTY174) AS QTY174, SUM(S.QTY175) AS QTY175
                         , SUM(S.QTY176) AS QTY176, SUM(S.QTY177) AS QTY177, SUM(S.QTY178) AS QTY178, SUM(S.QTY179) AS QTY179, SUM(S.QTY180) AS QTY180
                         , SUM(S.QTY181) AS QTY181, SUM(S.QTY182) AS QTY182, SUM(S.QTY183) AS QTY183, SUM(S.QTY184) AS QTY184, SUM(S.QTY185) AS QTY185
                         , SUM(S.QTY186) AS QTY186, SUM(S.QTY187) AS QTY187, SUM(S.QTY188) AS QTY188, SUM(S.QTY189) AS QTY189, SUM(S.QTY190) AS QTY190
                         , SUM(S.QTY191) AS QTY191, SUM(S.QTY192) AS QTY192, SUM(S.QTY193) AS QTY193, SUM(S.QTY194) AS QTY194, SUM(S.QTY195) AS QTY195
                         , SUM(S.QTY196) AS QTY196, SUM(S.QTY197) AS QTY197, SUM(S.QTY198) AS QTY198, SUM(S.QTY199) AS QTY199, SUM(S.QTY200) AS QTY200
                         , SUM(S.QTY201) AS QTY201, SUM(S.QTY202) AS QTY202, SUM(S.QTY203) AS QTY203, SUM(S.QTY204) AS QTY204, SUM(S.QTY205) AS QTY205
                         , SUM(S.QTY206) AS QTY206, SUM(S.QTY207) AS QTY207, SUM(S.QTY208) AS QTY208, SUM(S.QTY209) AS QTY209, SUM(S.QTY210) AS QTY210
                         , SUM(S.QTY211) AS QTY211, SUM(S.QTY212) AS QTY212, SUM(S.QTY213) AS QTY213, SUM(S.QTY214) AS QTY214, SUM(S.QTY215) AS QTY215
                         , SUM(S.QTY216) AS QTY216, SUM(S.QTY217) AS QTY217, SUM(S.QTY218) AS QTY218, SUM(S.QTY219) AS QTY219, SUM(S.QTY220) AS QTY220
                         , SUM(S.QTY221) AS QTY221, SUM(S.QTY222) AS QTY222, SUM(S.QTY223) AS QTY223, SUM(S.QTY224) AS QTY224, SUM(S.QTY225) AS QTY225
                         , SUM(S.QTY226) AS QTY226, SUM(S.QTY227) AS QTY227, SUM(S.QTY228) AS QTY228, SUM(S.QTY229) AS QTY229, SUM(S.QTY230) AS QTY230
                         , SUM(S.QTY231) AS QTY231, SUM(S.QTY232) AS QTY232, SUM(S.QTY233) AS QTY233, SUM(S.QTY234) AS QTY234, SUM(S.QTY235) AS QTY235
                         , SUM(S.QTY236) AS QTY236, SUM(S.QTY237) AS QTY237, SUM(S.QTY238) AS QTY238, SUM(S.QTY239) AS QTY239, SUM(S.QTY240) AS QTY240
                         , SUM(S.QTY241) AS QTY241, SUM(S.QTY242) AS QTY242, SUM(S.QTY243) AS QTY243, SUM(S.QTY244) AS QTY244, SUM(S.QTY245) AS QTY245
                         , SUM(S.QTY246) AS QTY246, SUM(S.QTY247) AS QTY247, SUM(S.QTY248) AS QTY248, SUM(S.QTY249) AS QTY249, SUM(S.QTY250) AS QTY250
                         , SUM(S.QTY251) AS QTY251, SUM(S.QTY252) AS QTY252, SUM(S.QTY253) AS QTY253, SUM(S.QTY254) AS QTY254, SUM(S.QTY255) AS QTY255
                         , SUM(S.QTY256) AS QTY256, SUM(S.QTY257) AS QTY257, SUM(S.QTY258) AS QTY258, SUM(S.QTY259) AS QTY259, SUM(S.QTY260) AS QTY260
                         , SUM(S.QTY261) AS QTY261, SUM(S.QTY262) AS QTY262, SUM(S.QTY263) AS QTY263, SUM(S.QTY264) AS QTY264, SUM(S.QTY265) AS QTY265
                         , SUM(S.QTY266) AS QTY266, SUM(S.QTY267) AS QTY267, SUM(S.QTY268) AS QTY268, SUM(S.QTY269) AS QTY269, SUM(S.QTY270) AS QTY270
                         , SUM(S.QTY271) AS QTY271, SUM(S.QTY272) AS QTY272, SUM(S.QTY273) AS QTY273, SUM(S.QTY274) AS QTY274, SUM(S.QTY275) AS QTY275
                         , SUM(S.QTY276) AS QTY276, SUM(S.QTY277) AS QTY277, SUM(S.QTY278) AS QTY278, SUM(S.QTY279) AS QTY279, SUM(S.QTY280) AS QTY280
                         , SUM(S.QTY281) AS QTY281, SUM(S.QTY282) AS QTY282, SUM(S.QTY283) AS QTY283, SUM(S.QTY284) AS QTY284, SUM(S.QTY285) AS QTY285
                         , SUM(S.QTY286) AS QTY286, SUM(S.QTY287) AS QTY287, SUM(S.QTY288) AS QTY288, SUM(S.QTY289) AS QTY289, SUM(S.QTY290) AS QTY290
                         , SUM(S.QTY291) AS QTY291, SUM(S.QTY292) AS QTY292, SUM(S.QTY293) AS QTY293, SUM(S.QTY294) AS QTY294, SUM(S.QTY295) AS QTY295
                         , SUM(S.QTY296) AS QTY296, SUM(S.QTY297) AS QTY297, SUM(S.QTY298) AS QTY298, SUM(S.QTY299) AS QTY299, SUM(S.QTY300) AS QTY300
                         , SUM(S.QTY301) AS QTY301, SUM(S.QTY302) AS QTY302, SUM(S.QTY303) AS QTY303, SUM(S.QTY304) AS QTY304, SUM(S.QTY305) AS QTY305
                         , SUM(S.QTY306) AS QTY306, SUM(S.QTY307) AS QTY307, SUM(S.QTY308) AS QTY308, SUM(S.QTY309) AS QTY309, SUM(S.QTY310) AS QTY310
                         , SUM(S.QTY311) AS QTY311, SUM(S.QTY312) AS QTY312, SUM(S.QTY313) AS QTY313, SUM(S.QTY314) AS QTY314, SUM(S.QTY315) AS QTY315
                         , SUM(S.QTY316) AS QTY316, SUM(S.QTY317) AS QTY317, SUM(S.QTY318) AS QTY318, SUM(S.QTY319) AS QTY319, SUM(S.QTY320) AS QTY320
                         , SUM(S.QTY321) AS QTY321, SUM(S.QTY322) AS QTY322, SUM(S.QTY323) AS QTY323, SUM(S.QTY324) AS QTY324, SUM(S.QTY325) AS QTY325
                         , SUM(S.QTY326) AS QTY326, SUM(S.QTY327) AS QTY327, SUM(S.QTY328) AS QTY328, SUM(S.QTY329) AS QTY329, SUM(S.QTY330) AS QTY330
                         , SUM(S.QTY331) AS QTY331, SUM(S.QTY332) AS QTY332, SUM(S.QTY333) AS QTY333, SUM(S.QTY334) AS QTY334, SUM(S.QTY335) AS QTY335
                         , SUM(S.QTY336) AS QTY336, SUM(S.QTY337) AS QTY337, SUM(S.QTY338) AS QTY338, SUM(S.QTY339) AS QTY339, SUM(S.QTY340) AS QTY340
                         , SUM(S.QTY341) AS QTY341, SUM(S.QTY342) AS QTY342, SUM(S.QTY343) AS QTY343, SUM(S.QTY344) AS QTY344, SUM(S.QTY345) AS QTY345
                         , SUM(S.QTY346) AS QTY346, SUM(S.QTY347) AS QTY347, SUM(S.QTY348) AS QTY348, SUM(S.QTY349) AS QTY349, SUM(S.QTY350) AS QTY350
                         , SUM(S.QTY351) AS QTY351, SUM(S.QTY352) AS QTY352, SUM(S.QTY353) AS QTY353, SUM(S.QTY354) AS QTY354, SUM(S.QTY355) AS QTY355
                         , SUM(S.QTY356) AS QTY356, SUM(S.QTY357) AS QTY357, SUM(S.QTY358) AS QTY358, SUM(S.QTY359) AS QTY359, SUM(S.QTY360) AS QTY360
                         , SUM(S.QTY361) AS QTY361, SUM(S.QTY362) AS QTY362, SUM(S.QTY363) AS QTY363, SUM(S.QTY364) AS QTY364
                      FROM ( SELECT DIVISION_ID
                                  , XLS_KEY1
                                  , CREATE_FROM_YYYYMMDD
                                  , NVL(QTY001, 0) AS QTY001, NVL(QTY002, 0) AS QTY002, NVL(QTY003, 0) AS QTY003, NVL(QTY004, 0) AS QTY004, NVL(QTY005, 0) AS QTY005
                                  , NVL(QTY006, 0) AS QTY006, NVL(QTY007, 0) AS QTY007, NVL(QTY008, 0) AS QTY008, NVL(QTY009, 0) AS QTY009, NVL(QTY010, 0) AS QTY010
                                  , NVL(QTY011, 0) AS QTY011, NVL(QTY012, 0) AS QTY012, NVL(QTY013, 0) AS QTY013, NVL(QTY014, 0) AS QTY014, NVL(QTY015, 0) AS QTY015
                                  , NVL(QTY016, 0) AS QTY016, NVL(QTY017, 0) AS QTY017, NVL(QTY018, 0) AS QTY018, NVL(QTY019, 0) AS QTY019, NVL(QTY020, 0) AS QTY020
                                  , NVL(QTY021, 0) AS QTY021, NVL(QTY022, 0) AS QTY022, NVL(QTY023, 0) AS QTY023, NVL(QTY024, 0) AS QTY024, NVL(QTY025, 0) AS QTY025
                                  , NVL(QTY026, 0) AS QTY026, NVL(QTY027, 0) AS QTY027, NVL(QTY028, 0) AS QTY028, NVL(QTY029, 0) AS QTY029, NVL(QTY030, 0) AS QTY030
                                  , NVL(QTY031, 0) AS QTY031, NVL(QTY032, 0) AS QTY032, NVL(QTY033, 0) AS QTY033, NVL(QTY034, 0) AS QTY034, NVL(QTY035, 0) AS QTY035
                                  , NVL(QTY036, 0) AS QTY036, NVL(QTY037, 0) AS QTY037, NVL(QTY038, 0) AS QTY038, NVL(QTY039, 0) AS QTY039, NVL(QTY040, 0) AS QTY040
                                  , NVL(QTY041, 0) AS QTY041, NVL(QTY042, 0) AS QTY042, NVL(QTY043, 0) AS QTY043, NVL(QTY044, 0) AS QTY044, NVL(QTY045, 0) AS QTY045
                                  , NVL(QTY046, 0) AS QTY046, NVL(QTY047, 0) AS QTY047, NVL(QTY048, 0) AS QTY048, NVL(QTY049, 0) AS QTY049, NVL(QTY050, 0) AS QTY050
                                  , NVL(QTY051, 0) AS QTY051, NVL(QTY052, 0) AS QTY052, NVL(QTY053, 0) AS QTY053, NVL(QTY054, 0) AS QTY054, NVL(QTY055, 0) AS QTY055
                                  , NVL(QTY056, 0) AS QTY056, NVL(QTY057, 0) AS QTY057, NVL(QTY058, 0) AS QTY058, NVL(QTY059, 0) AS QTY059, NVL(QTY060, 0) AS QTY060
                                  , NVL(QTY061, 0) AS QTY061, NVL(QTY062, 0) AS QTY062, NVL(QTY063, 0) AS QTY063, NVL(QTY064, 0) AS QTY064, NVL(QTY065, 0) AS QTY065
                                  , NVL(QTY066, 0) AS QTY066, NVL(QTY067, 0) AS QTY067, NVL(QTY068, 0) AS QTY068, NVL(QTY069, 0) AS QTY069, NVL(QTY070, 0) AS QTY070
                                  , NVL(QTY071, 0) AS QTY071, NVL(QTY072, 0) AS QTY072, NVL(QTY073, 0) AS QTY073, NVL(QTY074, 0) AS QTY074, NVL(QTY075, 0) AS QTY075
                                  , NVL(QTY076, 0) AS QTY076, NVL(QTY077, 0) AS QTY077, NVL(QTY078, 0) AS QTY078, NVL(QTY079, 0) AS QTY079, NVL(QTY080, 0) AS QTY080
                                  , NVL(QTY081, 0) AS QTY081, NVL(QTY082, 0) AS QTY082, NVL(QTY083, 0) AS QTY083, NVL(QTY084, 0) AS QTY084, NVL(QTY085, 0) AS QTY085
                                  , NVL(QTY086, 0) AS QTY086, NVL(QTY087, 0) AS QTY087, NVL(QTY088, 0) AS QTY088, NVL(QTY089, 0) AS QTY089, NVL(QTY090, 0) AS QTY090
                                  , NVL(QTY091, 0) AS QTY091, NVL(QTY092, 0) AS QTY092, NVL(QTY093, 0) AS QTY093, NVL(QTY094, 0) AS QTY094, NVL(QTY095, 0) AS QTY095
                                  , NVL(QTY096, 0) AS QTY096, NVL(QTY097, 0) AS QTY097, NVL(QTY098, 0) AS QTY098, NVL(QTY099, 0) AS QTY099, NVL(QTY100, 0) AS QTY100
                                  , NVL(QTY101, 0) AS QTY101, NVL(QTY102, 0) AS QTY102, NVL(QTY103, 0) AS QTY103, NVL(QTY104, 0) AS QTY104, NVL(QTY105, 0) AS QTY105
                                  , NVL(QTY106, 0) AS QTY106, NVL(QTY107, 0) AS QTY107, NVL(QTY108, 0) AS QTY108, NVL(QTY109, 0) AS QTY109, NVL(QTY110, 0) AS QTY110
                                  , NVL(QTY111, 0) AS QTY111, NVL(QTY112, 0) AS QTY112, NVL(QTY113, 0) AS QTY113, NVL(QTY114, 0) AS QTY114, NVL(QTY115, 0) AS QTY115
                                  , NVL(QTY116, 0) AS QTY116, NVL(QTY117, 0) AS QTY117, NVL(QTY118, 0) AS QTY118, NVL(QTY119, 0) AS QTY119, NVL(QTY120, 0) AS QTY120
                                  , NVL(QTY121, 0) AS QTY121, NVL(QTY122, 0) AS QTY122, NVL(QTY123, 0) AS QTY123, NVL(QTY124, 0) AS QTY124, NVL(QTY125, 0) AS QTY125
                                  , NVL(QTY126, 0) AS QTY126, NVL(QTY127, 0) AS QTY127, NVL(QTY128, 0) AS QTY128, NVL(QTY129, 0) AS QTY129, NVL(QTY130, 0) AS QTY130
                                  , NVL(QTY131, 0) AS QTY131, NVL(QTY132, 0) AS QTY132, NVL(QTY133, 0) AS QTY133, NVL(QTY134, 0) AS QTY134, NVL(QTY135, 0) AS QTY135
                                  , NVL(QTY136, 0) AS QTY136, NVL(QTY137, 0) AS QTY137, NVL(QTY138, 0) AS QTY138, NVL(QTY139, 0) AS QTY139, NVL(QTY140, 0) AS QTY140
                                  , NVL(QTY141, 0) AS QTY141, NVL(QTY142, 0) AS QTY142, NVL(QTY143, 0) AS QTY143, NVL(QTY144, 0) AS QTY144, NVL(QTY145, 0) AS QTY145
                                  , NVL(QTY146, 0) AS QTY146, NVL(QTY147, 0) AS QTY147, NVL(QTY148, 0) AS QTY148, NVL(QTY149, 0) AS QTY149, NVL(QTY150, 0) AS QTY150
                                  , NVL(QTY151, 0) AS QTY151, NVL(QTY152, 0) AS QTY152, NVL(QTY153, 0) AS QTY153, NVL(QTY154, 0) AS QTY154, NVL(QTY155, 0) AS QTY155
                                  , NVL(QTY156, 0) AS QTY156, NVL(QTY157, 0) AS QTY157, NVL(QTY158, 0) AS QTY158, NVL(QTY159, 0) AS QTY159, NVL(QTY160, 0) AS QTY160
                                  , NVL(QTY161, 0) AS QTY161, NVL(QTY162, 0) AS QTY162, NVL(QTY163, 0) AS QTY163, NVL(QTY164, 0) AS QTY164, NVL(QTY165, 0) AS QTY165
                                  , NVL(QTY166, 0) AS QTY166, NVL(QTY167, 0) AS QTY167, NVL(QTY168, 0) AS QTY168, NVL(QTY169, 0) AS QTY169, NVL(QTY170, 0) AS QTY170
                                  , NVL(QTY171, 0) AS QTY171, NVL(QTY172, 0) AS QTY172, NVL(QTY173, 0) AS QTY173, NVL(QTY174, 0) AS QTY174, NVL(QTY175, 0) AS QTY175
                                  , NVL(QTY176, 0) AS QTY176, NVL(QTY177, 0) AS QTY177, NVL(QTY178, 0) AS QTY178, NVL(QTY179, 0) AS QTY179, NVL(QTY180, 0) AS QTY180
                                  , NVL(QTY181, 0) AS QTY181, NVL(QTY182, 0) AS QTY182, NVL(QTY183, 0) AS QTY183, NVL(QTY184, 0) AS QTY184, NVL(QTY185, 0) AS QTY185
                                  , NVL(QTY186, 0) AS QTY186, NVL(QTY187, 0) AS QTY187, NVL(QTY188, 0) AS QTY188, NVL(QTY189, 0) AS QTY189, NVL(QTY190, 0) AS QTY190
                                  , NVL(QTY191, 0) AS QTY191, NVL(QTY192, 0) AS QTY192, NVL(QTY193, 0) AS QTY193, NVL(QTY194, 0) AS QTY194, NVL(QTY195, 0) AS QTY195
                                  , NVL(QTY196, 0) AS QTY196, NVL(QTY197, 0) AS QTY197, NVL(QTY198, 0) AS QTY198, NVL(QTY199, 0) AS QTY199, NVL(QTY200, 0) AS QTY200
                                  , NVL(QTY201, 0) AS QTY201, NVL(QTY202, 0) AS QTY202, NVL(QTY203, 0) AS QTY203, NVL(QTY204, 0) AS QTY204, NVL(QTY205, 0) AS QTY205
                                  , NVL(QTY206, 0) AS QTY206, NVL(QTY207, 0) AS QTY207, NVL(QTY208, 0) AS QTY208, NVL(QTY209, 0) AS QTY209, NVL(QTY210, 0) AS QTY210
                                  , NVL(QTY211, 0) AS QTY211, NVL(QTY212, 0) AS QTY212, NVL(QTY213, 0) AS QTY213, NVL(QTY214, 0) AS QTY214, NVL(QTY215, 0) AS QTY215
                                  , NVL(QTY216, 0) AS QTY216, NVL(QTY217, 0) AS QTY217, NVL(QTY218, 0) AS QTY218, NVL(QTY219, 0) AS QTY219, NVL(QTY220, 0) AS QTY220
                                  , NVL(QTY221, 0) AS QTY221, NVL(QTY222, 0) AS QTY222, NVL(QTY223, 0) AS QTY223, NVL(QTY224, 0) AS QTY224, NVL(QTY225, 0) AS QTY225
                                  , NVL(QTY226, 0) AS QTY226, NVL(QTY227, 0) AS QTY227, NVL(QTY228, 0) AS QTY228, NVL(QTY229, 0) AS QTY229, NVL(QTY230, 0) AS QTY230
                                  , NVL(QTY231, 0) AS QTY231, NVL(QTY232, 0) AS QTY232, NVL(QTY233, 0) AS QTY233, NVL(QTY234, 0) AS QTY234, NVL(QTY235, 0) AS QTY235
                                  , NVL(QTY236, 0) AS QTY236, NVL(QTY237, 0) AS QTY237, NVL(QTY238, 0) AS QTY238, NVL(QTY239, 0) AS QTY239, NVL(QTY240, 0) AS QTY240
                                  , NVL(QTY241, 0) AS QTY241, NVL(QTY242, 0) AS QTY242, NVL(QTY243, 0) AS QTY243, NVL(QTY244, 0) AS QTY244, NVL(QTY245, 0) AS QTY245
                                  , NVL(QTY246, 0) AS QTY246, NVL(QTY247, 0) AS QTY247, NVL(QTY248, 0) AS QTY248, NVL(QTY249, 0) AS QTY249, NVL(QTY250, 0) AS QTY250
                                  , NVL(QTY251, 0) AS QTY251, NVL(QTY252, 0) AS QTY252, NVL(QTY253, 0) AS QTY253, NVL(QTY254, 0) AS QTY254, NVL(QTY255, 0) AS QTY255
                                  , NVL(QTY256, 0) AS QTY256, NVL(QTY257, 0) AS QTY257, NVL(QTY258, 0) AS QTY258, NVL(QTY259, 0) AS QTY259, NVL(QTY260, 0) AS QTY260
                                  , NVL(QTY261, 0) AS QTY261, NVL(QTY262, 0) AS QTY262, NVL(QTY263, 0) AS QTY263, NVL(QTY264, 0) AS QTY264, NVL(QTY265, 0) AS QTY265
                                  , NVL(QTY266, 0) AS QTY266, NVL(QTY267, 0) AS QTY267, NVL(QTY268, 0) AS QTY268, NVL(QTY269, 0) AS QTY269, NVL(QTY270, 0) AS QTY270
                                  , NVL(QTY271, 0) AS QTY271, NVL(QTY272, 0) AS QTY272, NVL(QTY273, 0) AS QTY273, NVL(QTY274, 0) AS QTY274, NVL(QTY275, 0) AS QTY275
                                  , NVL(QTY276, 0) AS QTY276, NVL(QTY277, 0) AS QTY277, NVL(QTY278, 0) AS QTY278, NVL(QTY279, 0) AS QTY279, NVL(QTY280, 0) AS QTY280
                                  , NVL(QTY281, 0) AS QTY281, NVL(QTY282, 0) AS QTY282, NVL(QTY283, 0) AS QTY283, NVL(QTY284, 0) AS QTY284, NVL(QTY285, 0) AS QTY285
                                  , NVL(QTY286, 0) AS QTY286, NVL(QTY287, 0) AS QTY287, NVL(QTY288, 0) AS QTY288, NVL(QTY289, 0) AS QTY289, NVL(QTY290, 0) AS QTY290
                                  , NVL(QTY291, 0) AS QTY291, NVL(QTY292, 0) AS QTY292, NVL(QTY293, 0) AS QTY293, NVL(QTY294, 0) AS QTY294, NVL(QTY295, 0) AS QTY295
                                  , NVL(QTY296, 0) AS QTY296, NVL(QTY297, 0) AS QTY297, NVL(QTY298, 0) AS QTY298, NVL(QTY299, 0) AS QTY299, NVL(QTY300, 0) AS QTY300
                                  , NVL(QTY301, 0) AS QTY301, NVL(QTY302, 0) AS QTY302, NVL(QTY303, 0) AS QTY303, NVL(QTY304, 0) AS QTY304, NVL(QTY305, 0) AS QTY305
                                  , NVL(QTY306, 0) AS QTY306, NVL(QTY307, 0) AS QTY307, NVL(QTY308, 0) AS QTY308, NVL(QTY309, 0) AS QTY309, NVL(QTY310, 0) AS QTY310
                                  , NVL(QTY311, 0) AS QTY311, NVL(QTY312, 0) AS QTY312, NVL(QTY313, 0) AS QTY313, NVL(QTY314, 0) AS QTY314, NVL(QTY315, 0) AS QTY315
                                  , NVL(QTY316, 0) AS QTY316, NVL(QTY317, 0) AS QTY317, NVL(QTY318, 0) AS QTY318, NVL(QTY319, 0) AS QTY319, NVL(QTY320, 0) AS QTY320
                                  , NVL(QTY321, 0) AS QTY321, NVL(QTY322, 0) AS QTY322, NVL(QTY323, 0) AS QTY323, NVL(QTY324, 0) AS QTY324, NVL(QTY325, 0) AS QTY325
                                  , NVL(QTY326, 0) AS QTY326, NVL(QTY327, 0) AS QTY327, NVL(QTY328, 0) AS QTY328, NVL(QTY329, 0) AS QTY329, NVL(QTY330, 0) AS QTY330
                                  , NVL(QTY331, 0) AS QTY331, NVL(QTY332, 0) AS QTY332, NVL(QTY333, 0) AS QTY333, NVL(QTY334, 0) AS QTY334, NVL(QTY335, 0) AS QTY335
                                  , NVL(QTY336, 0) AS QTY336, NVL(QTY337, 0) AS QTY337, NVL(QTY338, 0) AS QTY338, NVL(QTY339, 0) AS QTY339, NVL(QTY340, 0) AS QTY340
                                  , NVL(QTY341, 0) AS QTY341, NVL(QTY342, 0) AS QTY342, NVL(QTY343, 0) AS QTY343, NVL(QTY344, 0) AS QTY344, NVL(QTY345, 0) AS QTY345
                                  , NVL(QTY346, 0) AS QTY346, NVL(QTY347, 0) AS QTY347, NVL(QTY348, 0) AS QTY348, NVL(QTY349, 0) AS QTY349, NVL(QTY350, 0) AS QTY350
                                  , NVL(QTY351, 0) AS QTY351, NVL(QTY352, 0) AS QTY352, NVL(QTY353, 0) AS QTY353, NVL(QTY354, 0) AS QTY354, NVL(QTY355, 0) AS QTY355
                                  , NVL(QTY356, 0) AS QTY356, NVL(QTY357, 0) AS QTY357, NVL(QTY358, 0) AS QTY358, NVL(QTY359, 0) AS QTY359, NVL(QTY360, 0) AS QTY360
                                  , NVL(QTY361, 0) AS QTY361, NVL(QTY362, 0) AS QTY362, NVL(QTY363, 0) AS QTY363, NVL(QTY364, 0) AS QTY364
                               FROM (
                                      SELECT A.DIVISION_ID, A.CREATE_FROM_YYYYMMDD, A.XLS_KEY1, A.YYYYMMDD_COLUMN
                                           /* A.DIVISION_ID, A.CREATE_FROM_YYYYMMDD, A.XLS_KEY1, A.YYYYMMDD_COLUMN, B.ITEM, */
                                           , CASE WHEN B.WQTY < 0 THEN A.QTY ELSE (CASE WHEN C.C2 = V_X_DAYOFWEEK_NO THEN B.WQTY ELSE 0 END) END AS AAAAA
                                        FROM GT_XPGT_PARTIAL_SHP_DATA A
                                             LEFT JOIN GT_XPGT_PARTIAL_SHP_QTY B
                                                    ON A.WEEKNO = B.NUM
                                             LEFT JOIN GT_XPGT_PARTIAL_INFO C
                                                    ON A.LAST_MOD = C.C1
                                     )
                                     PIVOT (
                                            SUM(AAAAA) FOR YYYYMMDD_COLUMN IN (
                                                 'QTY001' AS QTY001, 'QTY002' AS QTY002, 'QTY003' AS QTY003, 'QTY004' AS QTY004, 'QTY005' AS QTY005, 'QTY006' AS QTY006
                                               , 'QTY007' AS QTY007, 'QTY008' AS QTY008, 'QTY009' AS QTY009, 'QTY010' AS QTY010, 'QTY011' AS QTY011, 'QTY012' AS QTY012
                                               , 'QTY013' AS QTY013, 'QTY014' AS QTY014, 'QTY015' AS QTY015, 'QTY016' AS QTY016, 'QTY017' AS QTY017, 'QTY018' AS QTY018
                                               , 'QTY019' AS QTY019, 'QTY020' AS QTY020, 'QTY021' AS QTY021, 'QTY022' AS QTY022, 'QTY023' AS QTY023, 'QTY024' AS QTY024
                                               , 'QTY025' AS QTY025, 'QTY026' AS QTY026, 'QTY027' AS QTY027, 'QTY028' AS QTY028, 'QTY029' AS QTY029, 'QTY030' AS QTY030
                                               , 'QTY031' AS QTY031, 'QTY032' AS QTY032, 'QTY033' AS QTY033, 'QTY034' AS QTY034, 'QTY035' AS QTY035, 'QTY036' AS QTY036
                                               , 'QTY037' AS QTY037, 'QTY038' AS QTY038, 'QTY039' AS QTY039, 'QTY040' AS QTY040, 'QTY041' AS QTY041, 'QTY042' AS QTY042
                                               , 'QTY043' AS QTY043, 'QTY044' AS QTY044, 'QTY045' AS QTY045, 'QTY046' AS QTY046, 'QTY047' AS QTY047, 'QTY048' AS QTY048
                                               , 'QTY049' AS QTY049, 'QTY050' AS QTY050, 'QTY051' AS QTY051, 'QTY052' AS QTY052, 'QTY053' AS QTY053, 'QTY054' AS QTY054
                                               , 'QTY055' AS QTY055, 'QTY056' AS QTY056, 'QTY057' AS QTY057, 'QTY058' AS QTY058, 'QTY059' AS QTY059, 'QTY060' AS QTY060
                                               , 'QTY061' AS QTY061, 'QTY062' AS QTY062, 'QTY063' AS QTY063, 'QTY064' AS QTY064, 'QTY065' AS QTY065, 'QTY066' AS QTY066
                                               , 'QTY067' AS QTY067, 'QTY068' AS QTY068, 'QTY069' AS QTY069, 'QTY070' AS QTY070, 'QTY071' AS QTY071, 'QTY072' AS QTY072
                                               , 'QTY073' AS QTY073, 'QTY074' AS QTY074, 'QTY075' AS QTY075, 'QTY076' AS QTY076, 'QTY077' AS QTY077, 'QTY078' AS QTY078
                                               , 'QTY079' AS QTY079, 'QTY080' AS QTY080, 'QTY081' AS QTY081, 'QTY082' AS QTY082, 'QTY083' AS QTY083, 'QTY084' AS QTY084
                                               , 'QTY085' AS QTY085, 'QTY086' AS QTY086, 'QTY087' AS QTY087, 'QTY088' AS QTY088, 'QTY089' AS QTY089, 'QTY090' AS QTY090
                                               , 'QTY091' AS QTY091, 'QTY092' AS QTY092, 'QTY093' AS QTY093, 'QTY094' AS QTY094, 'QTY095' AS QTY095, 'QTY096' AS QTY096
                                               , 'QTY097' AS QTY097, 'QTY098' AS QTY098, 'QTY099' AS QTY099, 'QTY100' AS QTY100, 'QTY101' AS QTY101, 'QTY102' AS QTY102
                                               , 'QTY103' AS QTY103, 'QTY104' AS QTY104, 'QTY105' AS QTY105, 'QTY106' AS QTY106, 'QTY107' AS QTY107, 'QTY108' AS QTY108
                                               , 'QTY109' AS QTY109, 'QTY110' AS QTY110, 'QTY111' AS QTY111, 'QTY112' AS QTY112, 'QTY113' AS QTY113, 'QTY114' AS QTY114
                                               , 'QTY115' AS QTY115, 'QTY116' AS QTY116, 'QTY117' AS QTY117, 'QTY118' AS QTY118, 'QTY119' AS QTY119, 'QTY120' AS QTY120
                                               , 'QTY121' AS QTY121, 'QTY122' AS QTY122, 'QTY123' AS QTY123, 'QTY124' AS QTY124, 'QTY125' AS QTY125, 'QTY126' AS QTY126
                                               , 'QTY127' AS QTY127, 'QTY128' AS QTY128, 'QTY129' AS QTY129, 'QTY130' AS QTY130, 'QTY131' AS QTY131, 'QTY132' AS QTY132
                                               , 'QTY133' AS QTY133, 'QTY134' AS QTY134, 'QTY135' AS QTY135, 'QTY136' AS QTY136, 'QTY137' AS QTY137, 'QTY138' AS QTY138
                                               , 'QTY139' AS QTY139, 'QTY140' AS QTY140, 'QTY141' AS QTY141, 'QTY142' AS QTY142, 'QTY143' AS QTY143, 'QTY144' AS QTY144
                                               , 'QTY145' AS QTY145, 'QTY146' AS QTY146, 'QTY147' AS QTY147, 'QTY148' AS QTY148, 'QTY149' AS QTY149, 'QTY150' AS QTY150
                                               , 'QTY151' AS QTY151, 'QTY152' AS QTY152, 'QTY153' AS QTY153, 'QTY154' AS QTY154, 'QTY155' AS QTY155, 'QTY156' AS QTY156
                                               , 'QTY157' AS QTY157, 'QTY158' AS QTY158, 'QTY159' AS QTY159, 'QTY160' AS QTY160, 'QTY161' AS QTY161, 'QTY162' AS QTY162
                                               , 'QTY163' AS QTY163, 'QTY164' AS QTY164, 'QTY165' AS QTY165, 'QTY166' AS QTY166, 'QTY167' AS QTY167, 'QTY168' AS QTY168
                                               , 'QTY169' AS QTY169, 'QTY170' AS QTY170, 'QTY171' AS QTY171, 'QTY172' AS QTY172, 'QTY173' AS QTY173, 'QTY174' AS QTY174
                                               , 'QTY175' AS QTY175, 'QTY176' AS QTY176, 'QTY177' AS QTY177, 'QTY178' AS QTY178, 'QTY179' AS QTY179, 'QTY180' AS QTY180
                                               , 'QTY181' AS QTY181, 'QTY182' AS QTY182, 'QTY183' AS QTY183, 'QTY184' AS QTY184, 'QTY185' AS QTY185, 'QTY186' AS QTY186
                                               , 'QTY187' AS QTY187, 'QTY188' AS QTY188, 'QTY189' AS QTY189, 'QTY190' AS QTY190, 'QTY191' AS QTY191, 'QTY192' AS QTY192
                                               , 'QTY193' AS QTY193, 'QTY194' AS QTY194, 'QTY195' AS QTY195, 'QTY196' AS QTY196, 'QTY197' AS QTY197, 'QTY198' AS QTY198
                                               , 'QTY199' AS QTY199, 'QTY200' AS QTY200, 'QTY201' AS QTY201, 'QTY202' AS QTY202, 'QTY203' AS QTY203, 'QTY204' AS QTY204
                                               , 'QTY205' AS QTY205, 'QTY206' AS QTY206, 'QTY207' AS QTY207, 'QTY208' AS QTY208, 'QTY209' AS QTY209, 'QTY210' AS QTY210
                                               , 'QTY211' AS QTY211, 'QTY212' AS QTY212, 'QTY213' AS QTY213, 'QTY214' AS QTY214, 'QTY215' AS QTY215, 'QTY216' AS QTY216
                                               , 'QTY217' AS QTY217, 'QTY218' AS QTY218, 'QTY219' AS QTY219, 'QTY220' AS QTY220, 'QTY221' AS QTY221, 'QTY222' AS QTY222
                                               , 'QTY223' AS QTY223, 'QTY224' AS QTY224, 'QTY225' AS QTY225, 'QTY226' AS QTY226, 'QTY227' AS QTY227, 'QTY228' AS QTY228
                                               , 'QTY229' AS QTY229, 'QTY230' AS QTY230, 'QTY231' AS QTY231, 'QTY232' AS QTY232, 'QTY233' AS QTY233, 'QTY234' AS QTY234
                                               , 'QTY235' AS QTY235, 'QTY236' AS QTY236, 'QTY237' AS QTY237, 'QTY238' AS QTY238, 'QTY239' AS QTY239, 'QTY240' AS QTY240
                                               , 'QTY241' AS QTY241, 'QTY242' AS QTY242, 'QTY243' AS QTY243, 'QTY244' AS QTY244, 'QTY245' AS QTY245, 'QTY246' AS QTY246
                                               , 'QTY247' AS QTY247, 'QTY248' AS QTY248, 'QTY249' AS QTY249, 'QTY250' AS QTY250, 'QTY251' AS QTY251, 'QTY252' AS QTY252
                                               , 'QTY253' AS QTY253, 'QTY254' AS QTY254, 'QTY255' AS QTY255, 'QTY256' AS QTY256, 'QTY257' AS QTY257, 'QTY258' AS QTY258
                                               , 'QTY259' AS QTY259, 'QTY260' AS QTY260, 'QTY261' AS QTY261, 'QTY262' AS QTY262, 'QTY263' AS QTY263, 'QTY264' AS QTY264
                                               , 'QTY265' AS QTY265, 'QTY266' AS QTY266, 'QTY267' AS QTY267, 'QTY268' AS QTY268, 'QTY269' AS QTY269, 'QTY270' AS QTY270
                                               , 'QTY271' AS QTY271, 'QTY272' AS QTY272, 'QTY273' AS QTY273, 'QTY274' AS QTY274, 'QTY275' AS QTY275, 'QTY276' AS QTY276
                                               , 'QTY277' AS QTY277, 'QTY278' AS QTY278, 'QTY279' AS QTY279, 'QTY280' AS QTY280, 'QTY281' AS QTY281, 'QTY282' AS QTY282
                                               , 'QTY283' AS QTY283, 'QTY284' AS QTY284, 'QTY285' AS QTY285, 'QTY286' AS QTY286, 'QTY287' AS QTY287, 'QTY288' AS QTY288
                                               , 'QTY289' AS QTY289, 'QTY290' AS QTY290, 'QTY291' AS QTY291, 'QTY292' AS QTY292, 'QTY293' AS QTY293, 'QTY294' AS QTY294
                                               , 'QTY295' AS QTY295, 'QTY296' AS QTY296, 'QTY297' AS QTY297, 'QTY298' AS QTY298, 'QTY299' AS QTY299, 'QTY300' AS QTY300
                                               , 'QTY301' AS QTY301, 'QTY302' AS QTY302, 'QTY303' AS QTY303, 'QTY304' AS QTY304, 'QTY305' AS QTY305, 'QTY306' AS QTY306
                                               , 'QTY307' AS QTY307, 'QTY308' AS QTY308, 'QTY309' AS QTY309, 'QTY310' AS QTY310, 'QTY311' AS QTY311, 'QTY312' AS QTY312
                                               , 'QTY313' AS QTY313, 'QTY314' AS QTY314, 'QTY315' AS QTY315, 'QTY316' AS QTY316, 'QTY317' AS QTY317, 'QTY318' AS QTY318
                                               , 'QTY319' AS QTY319, 'QTY320' AS QTY320, 'QTY321' AS QTY321, 'QTY322' AS QTY322, 'QTY323' AS QTY323, 'QTY324' AS QTY324
                                               , 'QTY325' AS QTY325, 'QTY326' AS QTY326, 'QTY327' AS QTY327, 'QTY328' AS QTY328, 'QTY329' AS QTY329, 'QTY330' AS QTY330
                                               , 'QTY331' AS QTY331, 'QTY332' AS QTY332, 'QTY333' AS QTY333, 'QTY334' AS QTY334, 'QTY335' AS QTY335, 'QTY336' AS QTY336
                                               , 'QTY337' AS QTY337, 'QTY338' AS QTY338, 'QTY339' AS QTY339, 'QTY340' AS QTY340, 'QTY341' AS QTY341, 'QTY342' AS QTY342
                                               , 'QTY343' AS QTY343, 'QTY344' AS QTY344, 'QTY345' AS QTY345, 'QTY346' AS QTY346, 'QTY347' AS QTY347, 'QTY348' AS QTY348
                                               , 'QTY349' AS QTY349, 'QTY350' AS QTY350, 'QTY351' AS QTY351, 'QTY352' AS QTY352, 'QTY353' AS QTY353, 'QTY354' AS QTY354
                                               , 'QTY355' AS QTY355, 'QTY356' AS QTY356, 'QTY357' AS QTY357, 'QTY358' AS QTY358, 'QTY359' AS QTY359, 'QTY360' AS QTY360
                                               , 'QTY361' AS QTY361, 'QTY362' AS QTY362, 'QTY363' AS QTY363, 'QTY364' AS QTY364
                                                                              )
                                           )
                           ) S
                     GROUP BY S.DIVISION_ID, S.XLS_KEY1, S.CREATE_FROM_YYYYMMDD
                         ;


                  /* ▼ MSSQL 원본 L1524~L1942 원문 보존 (지정요일 배분 UPDATE 死코드(2025.05.15 확정구간 지원으로 대체)) ---------------------------------------------
                                       UPDATE X
                                        SET
                                              X.QTY001 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY001 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY01 ELSE 0 END )  END)
                                             ,X.QTY002 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY002 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY01 ELSE 0 END )  END)
                                             ,X.QTY003 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY003 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY01 ELSE 0 END )  END)
                                             ,X.QTY004 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY004 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY01 ELSE 0 END )  END)
                                             ,X.QTY005 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY005 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY01 ELSE 0 END )  END)
                                             ,X.QTY006 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY006 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY01 ELSE 0 END )  END)
                                             ,X.QTY007 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY007 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY01 ELSE 0 END )  END)

                                             ,X.QTY008 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY008 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY02 ELSE 0 END )  END)
                                             ,X.QTY009 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY009 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY02 ELSE 0 END )  END)
                                             ,X.QTY010 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY010 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY02 ELSE 0 END )  END)
                                             ,X.QTY011 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY011 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY02 ELSE 0 END )  END)
                                             ,X.QTY012 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY012 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY02 ELSE 0 END )  END)
                                             ,X.QTY013 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY013 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY02 ELSE 0 END )  END)
                                             ,X.QTY014 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY014 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY02 ELSE 0 END )  END)

                                             ,X.QTY015 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY015 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY03 ELSE 0 END )  END)
                                             ,X.QTY016 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY016 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY03 ELSE 0 END )  END)
                                             ,X.QTY017 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY017 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY03 ELSE 0 END )  END)
                                             ,X.QTY018 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY018 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY03 ELSE 0 END )  END)
                                             ,X.QTY019 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY019 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY03 ELSE 0 END )  END)
                                             ,X.QTY020 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY020 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY03 ELSE 0 END )  END)
                                             ,X.QTY021 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY021 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY03 ELSE 0 END )  END)

                                             ,X.QTY022 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY022 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY04 ELSE 0 END )  END)
                                             ,X.QTY023 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY023 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY04 ELSE 0 END )  END)
                                             ,X.QTY024 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY024 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY04 ELSE 0 END )  END)
                                             ,X.QTY025 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY025 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY04 ELSE 0 END )  END)
                                             ,X.QTY026 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY026 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY04 ELSE 0 END )  END)
                                             ,X.QTY027 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY027 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY04 ELSE 0 END )  END)
                                             ,X.QTY028 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY028 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY04 ELSE 0 END )  END)

                                             ,X.QTY029 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY029 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY05 ELSE 0 END )  END)
                                             ,X.QTY030 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY030 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY05 ELSE 0 END )  END)
                                             ,X.QTY031 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY031 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY05 ELSE 0 END )  END)
                                             ,X.QTY032 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY032 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY05 ELSE 0 END )  END)
                                             ,X.QTY033 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY033 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY05 ELSE 0 END )  END)
                                             ,X.QTY034 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY034 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY05 ELSE 0 END )  END)
                                             ,X.QTY035 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY035 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY05 ELSE 0 END )  END)

                                             ,X.QTY036 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY036 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY06 ELSE 0 END )  END)
                                             ,X.QTY037 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY037 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY06 ELSE 0 END )  END)
                                             ,X.QTY038 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY038 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY06 ELSE 0 END )  END)
                                             ,X.QTY039 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY039 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY06 ELSE 0 END )  END)
                                             ,X.QTY040 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY040 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY06 ELSE 0 END )  END)
                                             ,X.QTY041 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY041 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY06 ELSE 0 END )  END)
                                             ,X.QTY042 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY042 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY06 ELSE 0 END )  END)

                                             ,X.QTY043 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY043 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY07 ELSE 0 END )  END)
                                             ,X.QTY044 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY044 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY07 ELSE 0 END )  END)
                                             ,X.QTY045 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY045 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY07 ELSE 0 END )  END)
                                             ,X.QTY046 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY046 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY07 ELSE 0 END )  END)
                                             ,X.QTY047 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY047 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY07 ELSE 0 END )  END)
                                             ,X.QTY048 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY048 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY07 ELSE 0 END )  END)
                                             ,X.QTY049 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY049 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY07 ELSE 0 END )  END)

                                             ,X.QTY050 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY050 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY08 ELSE 0 END )  END)
                                             ,X.QTY051 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY051 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY08 ELSE 0 END )  END)
                                             ,X.QTY052 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY052 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY08 ELSE 0 END )  END)
                                             ,X.QTY053 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY053 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY08 ELSE 0 END )  END)
                                             ,X.QTY054 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY054 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY08 ELSE 0 END )  END)
                                             ,X.QTY055 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY055 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY08 ELSE 0 END )  END)
                                             ,X.QTY056 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY056 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY08 ELSE 0 END )  END)

                                             ,X.QTY057 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY057 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY09 ELSE 0 END )  END)
                                             ,X.QTY058 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY058 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY09 ELSE 0 END )  END)
                                             ,X.QTY059 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY059 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY09 ELSE 0 END )  END)
                                             ,X.QTY060 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY060 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY09 ELSE 0 END )  END)
                                             ,X.QTY061 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY061 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY09 ELSE 0 END )  END)
                                             ,X.QTY062 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY062 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY09 ELSE 0 END )  END)
                                             ,X.QTY063 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY063 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY09 ELSE 0 END )  END)

                                             ,X.QTY064 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY064 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY10 ELSE 0 END )  END)
                                             ,X.QTY065 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY065 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY10 ELSE 0 END )  END)
                                             ,X.QTY066 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY066 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY10 ELSE 0 END )  END)
                                             ,X.QTY067 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY067 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY10 ELSE 0 END )  END)
                                             ,X.QTY068 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY068 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY10 ELSE 0 END )  END)
                                             ,X.QTY069 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY069 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY10 ELSE 0 END )  END)
                                             ,X.QTY070 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY070 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY10 ELSE 0 END )  END)

                                             ,X.QTY071 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY071 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY11 ELSE 0 END )  END)
                                             ,X.QTY072 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY072 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY11 ELSE 0 END )  END)
                                             ,X.QTY073 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY073 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY11 ELSE 0 END )  END)
                                             ,X.QTY074 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY074 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY11 ELSE 0 END )  END)
                                             ,X.QTY075 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY075 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY11 ELSE 0 END )  END)
                                             ,X.QTY076 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY076 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY11 ELSE 0 END )  END)
                                             ,X.QTY077 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY077 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY11 ELSE 0 END )  END)

                                             ,X.QTY078 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY078 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY12 ELSE 0 END )  END)
                                             ,X.QTY079 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY079 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY12 ELSE 0 END )  END)
                                             ,X.QTY080 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY080 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY12 ELSE 0 END )  END)
                                             ,X.QTY081 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY081 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY12 ELSE 0 END )  END)
                                             ,X.QTY082 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY082 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY12 ELSE 0 END )  END)
                                             ,X.QTY083 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY083 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY12 ELSE 0 END )  END)
                                             ,X.QTY084 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY084 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY12 ELSE 0 END )  END)

                                             ,X.QTY085 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY085 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY13 ELSE 0 END )  END)
                                             ,X.QTY086 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY086 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY13 ELSE 0 END )  END)
                                             ,X.QTY087 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY087 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY13 ELSE 0 END )  END)
                                             ,X.QTY088 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY088 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY13 ELSE 0 END )  END)
                                             ,X.QTY089 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY089 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY13 ELSE 0 END )  END)
                                             ,X.QTY090 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY090 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY13 ELSE 0 END )  END)
                                             ,X.QTY091 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY091 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY13 ELSE 0 END )  END)

                                             ,X.QTY092 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY092 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY14 ELSE 0 END )  END)
                                             ,X.QTY093 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY093 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY14 ELSE 0 END )  END)
                                             ,X.QTY094 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY094 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY14 ELSE 0 END )  END)
                                             ,X.QTY095 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY095 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY14 ELSE 0 END )  END)
                                             ,X.QTY096 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY096 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY14 ELSE 0 END )  END)
                                             ,X.QTY097 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY097 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY14 ELSE 0 END )  END)
                                             ,X.QTY098 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY098 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY14 ELSE 0 END )  END)

                                             ,X.QTY099 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY099 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY15 ELSE 0 END )  END)
                                             ,X.QTY100 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY100 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY15 ELSE 0 END )  END)
                                             ,X.QTY101 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY101 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY15 ELSE 0 END )  END)
                                             ,X.QTY102 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY102 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY15 ELSE 0 END )  END)
                                             ,X.QTY103 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY103 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY15 ELSE 0 END )  END)
                                             ,X.QTY104 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY104 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY15 ELSE 0 END )  END)
                                             ,X.QTY105 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY105 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY15 ELSE 0 END )  END)

                                             ,X.QTY106 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY106 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY16 ELSE 0 END )  END)
                                             ,X.QTY107 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY107 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY16 ELSE 0 END )  END)
                                             ,X.QTY108 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY108 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY16 ELSE 0 END )  END)
                                             ,X.QTY109 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY109 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY16 ELSE 0 END )  END)
                                             ,X.QTY110 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY110 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY16 ELSE 0 END )  END)
                                             ,X.QTY111 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY111 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY16 ELSE 0 END )  END)
                                             ,X.QTY112 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY112 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY16 ELSE 0 END )  END)
                                             ------------------------------------------------------------------------------------------------------------------------------------
                                             ,X.QTY113 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY113 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY17 ELSE 0 END )  END)
                                             ,X.QTY114 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY114 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY17 ELSE 0 END )  END)
                                             ,X.QTY115 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY115 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY17 ELSE 0 END )  END)
                                             ,X.QTY116 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY116 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY17 ELSE 0 END )  END)
                                             ,X.QTY117 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY117 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY17 ELSE 0 END )  END)
                                             ,X.QTY118 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY118 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY17 ELSE 0 END )  END)
                                             ,X.QTY119 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY119 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY17 ELSE 0 END )  END)

                                             ,X.QTY120 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY120 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY18 ELSE 0 END )  END)
                                             ,X.QTY121 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY121 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY18 ELSE 0 END )  END)
                                             ,X.QTY122 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY122 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY18 ELSE 0 END )  END)
                                             ,X.QTY123 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY123 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY18 ELSE 0 END )  END)
                                             ,X.QTY124 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY124 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY18 ELSE 0 END )  END)
                                             ,X.QTY125 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY125 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY18 ELSE 0 END )  END)
                                             ,X.QTY126 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY126 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY18 ELSE 0 END )  END)

                                             ,X.QTY127 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY127 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY19 ELSE 0 END )  END)
                                             ,X.QTY128 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY128 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY19 ELSE 0 END )  END)
                                             ,X.QTY129 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY129 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY19 ELSE 0 END )  END)
                                             ,X.QTY130 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY130 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY19 ELSE 0 END )  END)
                                             ,X.QTY131 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY131 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY19 ELSE 0 END )  END)
                                             ,X.QTY132 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY132 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY19 ELSE 0 END )  END)
                                             ,X.QTY133 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY133 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY19 ELSE 0 END )  END)

                                             ,X.QTY134 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY134 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY20 ELSE 0 END )  END)
                                             ,X.QTY135 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY135 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY20 ELSE 0 END )  END)
                                             ,X.QTY136 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY136 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY20 ELSE 0 END )  END)
                                             ,X.QTY137 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY137 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY20 ELSE 0 END )  END)
                                             ,X.QTY138 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY138 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY20 ELSE 0 END )  END)
                                             ,X.QTY139 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY139 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY20 ELSE 0 END )  END)
                                             ,X.QTY140 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY140 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY20 ELSE 0 END )  END)

                                             ,X.QTY141 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY141 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY21 ELSE 0 END )  END)
                                             ,X.QTY142 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY142 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY21 ELSE 0 END )  END)
                                             ,X.QTY143 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY143 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY21 ELSE 0 END )  END)
                                             ,X.QTY144 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY144 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY21 ELSE 0 END )  END)
                                             ,X.QTY145 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY145 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY21 ELSE 0 END )  END)
                                             ,X.QTY146 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY146 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY21 ELSE 0 END )  END)
                                             ,X.QTY147 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY147 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY21 ELSE 0 END )  END)

                                             ,X.QTY148 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY148 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY22 ELSE 0 END )  END)
                                             ,X.QTY149 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY149 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY22 ELSE 0 END )  END)
                                             ,X.QTY150 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY150 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY22 ELSE 0 END )  END)
                                             ,X.QTY151 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY151 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY22 ELSE 0 END )  END)
                                             ,X.QTY152 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY152 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY22 ELSE 0 END )  END)
                                             ,X.QTY153 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY153 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY22 ELSE 0 END )  END)
                                             ,X.QTY154 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY154 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY22 ELSE 0 END )  END)

                                             ,X.QTY155 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY155 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY23 ELSE 0 END )  END)
                                             ,X.QTY156 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY156 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY23 ELSE 0 END )  END)
                                             ,X.QTY157 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY157 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY23 ELSE 0 END )  END)
                                             ,X.QTY158 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY158 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY23 ELSE 0 END )  END)
                                             ,X.QTY159 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY159 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY23 ELSE 0 END )  END)
                                             ,X.QTY160 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY160 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY23 ELSE 0 END )  END)
                                             ,X.QTY161 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY161 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY23 ELSE 0 END )  END)

                                             ,X.QTY162 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY162 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY24 ELSE 0 END )  END)
                                             ,X.QTY163 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY163 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY24 ELSE 0 END )  END)
                                             ,X.QTY164 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY164 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY24 ELSE 0 END )  END)
                                             ,X.QTY165 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY165 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY24 ELSE 0 END )  END)
                                             ,X.QTY166 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY166 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY24 ELSE 0 END )  END)
                                             ,X.QTY167 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY167 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY24 ELSE 0 END )  END)
                                             ,X.QTY168 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY168 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY24 ELSE 0 END )  END)

                                             ,X.QTY169 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY169 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY25 ELSE 0 END )  END)
                                             ,X.QTY170 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY170 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY25 ELSE 0 END )  END)
                                             ,X.QTY171 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY171 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY25 ELSE 0 END )  END)
                                             ,X.QTY172 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY172 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY25 ELSE 0 END )  END)
                                             ,X.QTY173 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY173 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY25 ELSE 0 END )  END)
                                             ,X.QTY174 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY174 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY25 ELSE 0 END )  END)
                                             ,X.QTY175 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY175 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY25 ELSE 0 END )  END)

                                             ,X.QTY176 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY176 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY26 ELSE 0 END )  END)
                                             ,X.QTY177 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY177 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY26 ELSE 0 END )  END)
                                             ,X.QTY178 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY178 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY26 ELSE 0 END )  END)
                                             ,X.QTY179 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY179 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY26 ELSE 0 END )  END)
                                             ,X.QTY180 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY180 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY26 ELSE 0 END )  END)
                                             ,X.QTY181 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY181 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY26 ELSE 0 END )  END)
                                             ,X.QTY182 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY182 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY26 ELSE 0 END )  END)

                                             ,X.QTY183 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY183 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY27 ELSE 0 END )  END)
                                             ,X.QTY184 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY184 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY27 ELSE 0 END )  END)
                                             ,X.QTY185 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY185 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY27 ELSE 0 END )  END)
                                             ,X.QTY186 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY186 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY27 ELSE 0 END )  END)
                                             ,X.QTY187 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY187 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY27 ELSE 0 END )  END)
                                             ,X.QTY188 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY188 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY27 ELSE 0 END )  END)
                                             ,X.QTY189 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY189 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY27 ELSE 0 END )  END)

                                             ,X.QTY190 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY190 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY28 ELSE 0 END )  END)
                                             ,X.QTY191 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY191 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY28 ELSE 0 END )  END)
                                             ,X.QTY192 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY192 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY28 ELSE 0 END )  END)
                                             ,X.QTY193 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY193 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY28 ELSE 0 END )  END)
                                             ,X.QTY194 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY194 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY28 ELSE 0 END )  END)
                                             ,X.QTY195 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY195 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY28 ELSE 0 END )  END)
                                             ,X.QTY196 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY196 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY28 ELSE 0 END )  END)

                                             ,X.QTY197 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY197 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY29 ELSE 0 END )  END)
                                             ,X.QTY198 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY198 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY29 ELSE 0 END )  END)
                                             ,X.QTY199 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY199 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY29 ELSE 0 END )  END)
                                             ,X.QTY200 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY200 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY29 ELSE 0 END )  END)
                                             ,X.QTY201 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY201 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY29 ELSE 0 END )  END)
                                             ,X.QTY202 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY202 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY29 ELSE 0 END )  END)
                                             ,X.QTY203 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY203 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY29 ELSE 0 END )  END)

                                             ,X.QTY204 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY204 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY30 ELSE 0 END )  END)
                                             ,X.QTY205 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY205 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY30 ELSE 0 END )  END)
                                             ,X.QTY206 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY206 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY30 ELSE 0 END )  END)
                                             ,X.QTY207 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY207 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY30 ELSE 0 END )  END)
                                             ,X.QTY208 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY208 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY30 ELSE 0 END )  END)
                                             ,X.QTY209 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY209 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY30 ELSE 0 END )  END)
                                             ,X.QTY210 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY210 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY30 ELSE 0 END )  END)

                                             ,X.QTY211 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY211 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY31 ELSE 0 END )  END)
                                             ,X.QTY212 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY212 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY31 ELSE 0 END )  END)
                                             ,X.QTY213 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY213 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY31 ELSE 0 END )  END)
                                             ,X.QTY214 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY214 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY31 ELSE 0 END )  END)
                                             ,X.QTY215 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY215 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY31 ELSE 0 END )  END)
                                             ,X.QTY216 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY216 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY31 ELSE 0 END )  END)
                                             ,X.QTY217 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY217 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY31 ELSE 0 END )  END)

                                             ,X.QTY218 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY218 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY32 ELSE 0 END )  END)
                                             ,X.QTY219 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY219 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY32 ELSE 0 END )  END)
                                             ,X.QTY220 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY220 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY32 ELSE 0 END )  END)
                                             ,X.QTY221 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY221 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY32 ELSE 0 END )  END)
                                             ,X.QTY222 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY222 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY32 ELSE 0 END )  END)
                                             ,X.QTY223 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY223 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY32 ELSE 0 END )  END)
                                             ,X.QTY224 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY224 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY32 ELSE 0 END )  END)

                                             ,X.QTY225 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY225 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY33 ELSE 0 END )  END)
                                             ,X.QTY226 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY226 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY33 ELSE 0 END )  END)
                                             ,X.QTY227 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY227 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY33 ELSE 0 END )  END)
                                             ,X.QTY228 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY228 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY33 ELSE 0 END )  END)
                                             ,X.QTY229 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY229 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY33 ELSE 0 END )  END)
                                             ,X.QTY230 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY230 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY33 ELSE 0 END )  END)
                                             ,X.QTY231 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY231 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY33 ELSE 0 END )  END)

                                             ,X.QTY232 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY232 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY34 ELSE 0 END )  END)
                                             ,X.QTY233 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY233 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY34 ELSE 0 END )  END)
                                             ,X.QTY234 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY234 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY34 ELSE 0 END )  END)
                                             ,X.QTY235 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY235 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY34 ELSE 0 END )  END)
                                             ,X.QTY236 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY236 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY34 ELSE 0 END )  END)
                                             ,X.QTY237 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY237 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY34 ELSE 0 END )  END)
                                             ,X.QTY238 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY238 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY34 ELSE 0 END )  END)

                                             ,X.QTY239 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY239 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY35 ELSE 0 END )  END)
                                             ,X.QTY240 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY240 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY35 ELSE 0 END )  END)
                                             ,X.QTY241 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY241 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY35 ELSE 0 END )  END)
                                             ,X.QTY242 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY242 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY35 ELSE 0 END )  END)
                                             ,X.QTY243 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY243 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY35 ELSE 0 END )  END)
                                             ,X.QTY244 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY244 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY35 ELSE 0 END )  END)
                                             ,X.QTY245 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY245 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY35 ELSE 0 END )  END)

                                             ,X.QTY246 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY246 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY36 ELSE 0 END )  END)
                                             ,X.QTY247 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY247 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY36 ELSE 0 END )  END)
                                             ,X.QTY248 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY248 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY36 ELSE 0 END )  END)
                                             ,X.QTY249 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY249 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY36 ELSE 0 END )  END)
                                             ,X.QTY250 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY250 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY36 ELSE 0 END )  END)
                                             ,X.QTY251 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY251 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY36 ELSE 0 END )  END)
                                             ,X.QTY252 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY252 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY36 ELSE 0 END )  END)

                                             ,X.QTY253 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY253 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY37 ELSE 0 END )  END)
                                             ,X.QTY254 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY254 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY37 ELSE 0 END )  END)
                                             ,X.QTY255 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY255 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY37 ELSE 0 END )  END)
                                             ,X.QTY256 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY256 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY37 ELSE 0 END )  END)
                                             ,X.QTY257 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY257 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY37 ELSE 0 END )  END)
                                             ,X.QTY258 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY258 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY37 ELSE 0 END )  END)
                                             ,X.QTY259 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY259 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY37 ELSE 0 END )  END)

                                             ,X.QTY260 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY260 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY38 ELSE 0 END )  END)
                                             ,X.QTY261 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY261 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY38 ELSE 0 END )  END)
                                             ,X.QTY262 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY262 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY38 ELSE 0 END )  END)
                                             ,X.QTY263 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY263 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY38 ELSE 0 END )  END)
                                             ,X.QTY264 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY264 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY38 ELSE 0 END )  END)
                                             ,X.QTY265 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY265 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY38 ELSE 0 END )  END)
                                             ,X.QTY266 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY266 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY38 ELSE 0 END )  END)

                                             ,X.QTY267 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY267 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY39 ELSE 0 END )  END)
                                             ,X.QTY268 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY268 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY39 ELSE 0 END )  END)
                                             ,X.QTY269 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY269 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY39 ELSE 0 END )  END)
                                             ,X.QTY270 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY270 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY39 ELSE 0 END )  END)
                                             ,X.QTY271 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY271 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY39 ELSE 0 END )  END)
                                             ,X.QTY272 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY272 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY39 ELSE 0 END )  END)
                                             ,X.QTY273 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY273 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY39 ELSE 0 END )  END)

                                             ,X.QTY274 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY274 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY40 ELSE 0 END )  END)
                                             ,X.QTY275 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY275 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY40 ELSE 0 END )  END)
                                             ,X.QTY276 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY276 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY40 ELSE 0 END )  END)
                                             ,X.QTY277 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY277 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY40 ELSE 0 END )  END)
                                             ,X.QTY278 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY278 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY40 ELSE 0 END )  END)
                                             ,X.QTY279 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY279 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY40 ELSE 0 END )  END)
                                             ,X.QTY280 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY280 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY40 ELSE 0 END )  END)

                                             ,X.QTY281 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY281 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY41 ELSE 0 END )  END)
                                             ,X.QTY282 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY282 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY41 ELSE 0 END )  END)
                                             ,X.QTY283 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY283 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY41 ELSE 0 END )  END)
                                             ,X.QTY284 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY284 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY41 ELSE 0 END )  END)
                                             ,X.QTY285 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY285 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY41 ELSE 0 END )  END)
                                             ,X.QTY286 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY286 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY41 ELSE 0 END )  END)
                                             ,X.QTY287 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY287 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY41 ELSE 0 END )  END)

                                             ,X.QTY288 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY288 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY42 ELSE 0 END )  END)
                                             ,X.QTY289 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY289 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY42 ELSE 0 END )  END)
                                             ,X.QTY290 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY290 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY42 ELSE 0 END )  END)
                                             ,X.QTY291 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY291 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY42 ELSE 0 END )  END)
                                             ,X.QTY292 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY292 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY42 ELSE 0 END )  END)
                                             ,X.QTY293 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY293 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY42 ELSE 0 END )  END)
                                             ,X.QTY294 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY294 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY42 ELSE 0 END )  END)

                                             ,X.QTY295 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY295 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY43 ELSE 0 END )  END)
                                             ,X.QTY296 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY296 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY43 ELSE 0 END )  END)
                                             ,X.QTY297 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY297 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY43 ELSE 0 END )  END)
                                             ,X.QTY298 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY298 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY43 ELSE 0 END )  END)
                                             ,X.QTY299 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY299 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY43 ELSE 0 END )  END)
                                             ,X.QTY300 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY300 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY43 ELSE 0 END )  END)
                                             ,X.QTY301 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY301 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY43 ELSE 0 END )  END)

                                             ,X.QTY302 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY302 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY44 ELSE 0 END )  END)
                                             ,X.QTY303 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY303 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY44 ELSE 0 END )  END)
                                             ,X.QTY304 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY304 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY44 ELSE 0 END )  END)
                                             ,X.QTY305 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY305 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY44 ELSE 0 END )  END)
                                             ,X.QTY306 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY306 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY44 ELSE 0 END )  END)
                                             ,X.QTY307 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY307 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY44 ELSE 0 END )  END)
                                             ,X.QTY308 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY308 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY44 ELSE 0 END )  END)

                                             ,X.QTY309 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY309 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY45 ELSE 0 END )  END)
                                             ,X.QTY310 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY310 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY45 ELSE 0 END )  END)
                                             ,X.QTY311 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY311 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY45 ELSE 0 END )  END)
                                             ,X.QTY312 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY312 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY45 ELSE 0 END )  END)
                                             ,X.QTY313 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY313 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY45 ELSE 0 END )  END)
                                             ,X.QTY314 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY314 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY45 ELSE 0 END )  END)
                                             ,X.QTY315 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY315 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY45 ELSE 0 END )  END)

                                             ,X.QTY316 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY316 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY46 ELSE 0 END )  END)
                                             ,X.QTY317 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY317 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY46 ELSE 0 END )  END)
                                             ,X.QTY318 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY318 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY46 ELSE 0 END )  END)
                                             ,X.QTY319 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY319 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY46 ELSE 0 END )  END)
                                             ,X.QTY320 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY320 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY46 ELSE 0 END )  END)
                                             ,X.QTY321 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY321 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY46 ELSE 0 END )  END)
                                             ,X.QTY322 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY322 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY46 ELSE 0 END )  END)

                                             ,X.QTY323 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY323 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY47 ELSE 0 END )  END)
                                             ,X.QTY324 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY324 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY47 ELSE 0 END )  END)
                                             ,X.QTY325 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY325 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY47 ELSE 0 END )  END)
                                             ,X.QTY326 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY326 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY47 ELSE 0 END )  END)
                                             ,X.QTY327 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY327 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY47 ELSE 0 END )  END)
                                             ,X.QTY328 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY328 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY47 ELSE 0 END )  END)
                                             ,X.QTY329 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY329 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY47 ELSE 0 END )  END)

                                             ,X.QTY330 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY330 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY48 ELSE 0 END )  END)
                                             ,X.QTY331 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY331 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY48 ELSE 0 END )  END)
                                             ,X.QTY332 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY332 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY48 ELSE 0 END )  END)
                                             ,X.QTY333 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY333 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY48 ELSE 0 END )  END)
                                             ,X.QTY334 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY334 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY48 ELSE 0 END )  END)
                                             ,X.QTY335 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY335 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY48 ELSE 0 END )  END)
                                             ,X.QTY336 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY336 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY48 ELSE 0 END )  END)

                                             ,X.QTY337 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY337 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY49 ELSE 0 END )  END)
                                             ,X.QTY338 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY338 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY49 ELSE 0 END )  END)
                                             ,X.QTY339 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY339 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY49 ELSE 0 END )  END)
                                             ,X.QTY340 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY340 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY49 ELSE 0 END )  END)
                                             ,X.QTY341 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY341 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY49 ELSE 0 END )  END)
                                             ,X.QTY342 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY342 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY49 ELSE 0 END )  END)
                                             ,X.QTY343 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY343 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY49 ELSE 0 END )  END)

                                             ,X.QTY344 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY344 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY50 ELSE 0 END )  END)
                                             ,X.QTY345 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY345 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY50 ELSE 0 END )  END)
                                             ,X.QTY346 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY346 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY50 ELSE 0 END )  END)
                                             ,X.QTY347 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY347 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY50 ELSE 0 END )  END)
                                             ,X.QTY348 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY348 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY50 ELSE 0 END )  END)
                                             ,X.QTY349 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY349 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY50 ELSE 0 END )  END)
                                             ,X.QTY350 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY350 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY50 ELSE 0 END )  END)

                                             ,X.QTY351 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY351 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY51 ELSE 0 END )  END)
                                             ,X.QTY352 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY352 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY51 ELSE 0 END )  END)
                                             ,X.QTY353 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY353 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY51 ELSE 0 END )  END)
                                             ,X.QTY354 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY354 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY51 ELSE 0 END )  END)
                                             ,X.QTY355 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY355 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY51 ELSE 0 END )  END)
                                             ,X.QTY356 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY356 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY51 ELSE 0 END )  END)
                                             ,X.QTY357 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY357 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY51 ELSE 0 END )  END)

                                             ,X.QTY358 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY358 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY52 ELSE 0 END )  END)
                                             ,X.QTY359 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY359 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY52 ELSE 0 END )  END)
                                             ,X.QTY360 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY360 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY52 ELSE 0 END )  END)
                                             ,X.QTY361 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY361 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY52 ELSE 0 END )  END)
                                             ,X.QTY362 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY362 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY52 ELSE 0 END )  END)
                                             ,X.QTY363 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY363 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY52 ELSE 0 END )  END)
                                             ,X.QTY364 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY364 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY52 ELSE 0 END )  END)
                                        FROM #DAY_SCP_XLS_PSI_GLOBAL X
                                        ; */

                   /* PRINT 'ddd' */

                   /*  MSSQL UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL_ESS X INNER JOIN #DAY_SCP_XLS_PSI_GLOBAL Y
                       -> 원천 Y 는 (DIVISION_ID, XLS_KEY1, CREATE_FROM_YYYYMMDD) 로 GROUP BY 된 결과라 유일하지만
                          계열 형제와 동일하게 상관 UPDATE + EXISTS + ROWNUM = 1 로 옮겨 ORA-30926 을 원천 차단한다(CV-024). */
                    UPDATE SCP_XLS_PSI_GLOBAL_ESS X
                       SET (
                             QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008
                           , QTY009, QTY010, QTY011, QTY012, QTY013, QTY014, QTY015, QTY016
                           , QTY017, QTY018, QTY019, QTY020, QTY021, QTY022, QTY023, QTY024
                           , QTY025, QTY026, QTY027, QTY028, QTY029, QTY030, QTY031, QTY032
                           , QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                           , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048
                           , QTY049, QTY050, QTY051, QTY052, QTY053, QTY054, QTY055, QTY056
                           , QTY057, QTY058, QTY059, QTY060, QTY061, QTY062, QTY063, QTY064
                           , QTY065, QTY066, QTY067, QTY068, QTY069, QTY070, QTY071, QTY072
                           , QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                           , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088
                           , QTY089, QTY090, QTY091, QTY092, QTY093, QTY094, QTY095, QTY096
                           , QTY097, QTY098, QTY099, QTY100, QTY101, QTY102, QTY103, QTY104
                           , QTY105, QTY106, QTY107, QTY108, QTY109, QTY110, QTY111, QTY112
                           , QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                           , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128
                           , QTY129, QTY130, QTY131, QTY132, QTY133, QTY134, QTY135, QTY136
                           , QTY137, QTY138, QTY139, QTY140, QTY141, QTY142, QTY143, QTY144
                           , QTY145, QTY146, QTY147, QTY148, QTY149, QTY150, QTY151, QTY152
                           , QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                           , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168
                           , QTY169, QTY170, QTY171, QTY172, QTY173, QTY174, QTY175, QTY176
                           , QTY177, QTY178, QTY179, QTY180, QTY181, QTY182, QTY183, QTY184
                           , QTY185, QTY186, QTY187, QTY188, QTY189, QTY190, QTY191, QTY192
                           , QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                           , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208
                           , QTY209, QTY210, QTY211, QTY212, QTY213, QTY214, QTY215, QTY216
                           , QTY217, QTY218, QTY219, QTY220, QTY221, QTY222, QTY223, QTY224
                           , QTY225, QTY226, QTY227, QTY228, QTY229, QTY230, QTY231, QTY232
                           , QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                           , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248
                           , QTY249, QTY250, QTY251, QTY252, QTY253, QTY254, QTY255, QTY256
                           , QTY257, QTY258, QTY259, QTY260, QTY261, QTY262, QTY263, QTY264
                           , QTY265, QTY266, QTY267, QTY268, QTY269, QTY270, QTY271, QTY272
                           , QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                           , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288
                           , QTY289, QTY290, QTY291, QTY292, QTY293, QTY294, QTY295, QTY296
                           , QTY297, QTY298, QTY299, QTY300, QTY301, QTY302, QTY303, QTY304
                           , QTY305, QTY306, QTY307, QTY308, QTY309, QTY310, QTY311, QTY312
                           , QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                           , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328
                           , QTY329, QTY330, QTY331, QTY332, QTY333, QTY334, QTY335, QTY336
                           , QTY337, QTY338, QTY339, QTY340, QTY341, QTY342, QTY343, QTY344
                           , QTY345, QTY346, QTY347, QTY348, QTY349, QTY350, QTY351, QTY352
                           , QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                           , QTY361, QTY362, QTY363, QTY364, WQTY01, WQTY02, WQTY03, WQTY04
                           , WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10, WQTY11, WQTY12
                           , WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                           , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28
                           , WQTY29, WQTY30, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36
                           , WQTY37, WQTY38, WQTY39, WQTY40, WQTY41, WQTY42, WQTY43, WQTY44
                           , WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50, WQTY51, WQTY52
                           , LAST_UPDATED_BY, LAST_UPDATE_DATE
                           ) =
                           ( SELECT
                               Y.QTY001, Y.QTY002, Y.QTY003, Y.QTY004, Y.QTY005, Y.QTY006, Y.QTY007, Y.QTY008
                             , Y.QTY009, Y.QTY010, Y.QTY011, Y.QTY012, Y.QTY013, Y.QTY014, Y.QTY015, Y.QTY016
                             , Y.QTY017, Y.QTY018, Y.QTY019, Y.QTY020, Y.QTY021, Y.QTY022, Y.QTY023, Y.QTY024
                             , Y.QTY025, Y.QTY026, Y.QTY027, Y.QTY028, Y.QTY029, Y.QTY030, Y.QTY031, Y.QTY032
                             , Y.QTY033, Y.QTY034, Y.QTY035, Y.QTY036, Y.QTY037, Y.QTY038, Y.QTY039, Y.QTY040
                             , Y.QTY041, Y.QTY042, Y.QTY043, Y.QTY044, Y.QTY045, Y.QTY046, Y.QTY047, Y.QTY048
                             , Y.QTY049, Y.QTY050, Y.QTY051, Y.QTY052, Y.QTY053, Y.QTY054, Y.QTY055, Y.QTY056
                             , Y.QTY057, Y.QTY058, Y.QTY059, Y.QTY060, Y.QTY061, Y.QTY062, Y.QTY063, Y.QTY064
                             , Y.QTY065, Y.QTY066, Y.QTY067, Y.QTY068, Y.QTY069, Y.QTY070, Y.QTY071, Y.QTY072
                             , Y.QTY073, Y.QTY074, Y.QTY075, Y.QTY076, Y.QTY077, Y.QTY078, Y.QTY079, Y.QTY080
                             , Y.QTY081, Y.QTY082, Y.QTY083, Y.QTY084, Y.QTY085, Y.QTY086, Y.QTY087, Y.QTY088
                             , Y.QTY089, Y.QTY090, Y.QTY091, Y.QTY092, Y.QTY093, Y.QTY094, Y.QTY095, Y.QTY096
                             , Y.QTY097, Y.QTY098, Y.QTY099, Y.QTY100, Y.QTY101, Y.QTY102, Y.QTY103, Y.QTY104
                             , Y.QTY105, Y.QTY106, Y.QTY107, Y.QTY108, Y.QTY109, Y.QTY110, Y.QTY111, Y.QTY112
                             , Y.QTY113, Y.QTY114, Y.QTY115, Y.QTY116, Y.QTY117, Y.QTY118, Y.QTY119, Y.QTY120
                             , Y.QTY121, Y.QTY122, Y.QTY123, Y.QTY124, Y.QTY125, Y.QTY126, Y.QTY127, Y.QTY128
                             , Y.QTY129, Y.QTY130, Y.QTY131, Y.QTY132, Y.QTY133, Y.QTY134, Y.QTY135, Y.QTY136
                             , Y.QTY137, Y.QTY138, Y.QTY139, Y.QTY140, Y.QTY141, Y.QTY142, Y.QTY143, Y.QTY144
                             , Y.QTY145, Y.QTY146, Y.QTY147, Y.QTY148, Y.QTY149, Y.QTY150, Y.QTY151, Y.QTY152
                             , Y.QTY153, Y.QTY154, Y.QTY155, Y.QTY156, Y.QTY157, Y.QTY158, Y.QTY159, Y.QTY160
                             , Y.QTY161, Y.QTY162, Y.QTY163, Y.QTY164, Y.QTY165, Y.QTY166, Y.QTY167, Y.QTY168
                             , Y.QTY169, Y.QTY170, Y.QTY171, Y.QTY172, Y.QTY173, Y.QTY174, Y.QTY175, Y.QTY176
                             , Y.QTY177, Y.QTY178, Y.QTY179, Y.QTY180, Y.QTY181, Y.QTY182, Y.QTY183, Y.QTY184
                             , Y.QTY185, Y.QTY186, Y.QTY187, Y.QTY188, Y.QTY189, Y.QTY190, Y.QTY191, Y.QTY192
                             , Y.QTY193, Y.QTY194, Y.QTY195, Y.QTY196, Y.QTY197, Y.QTY198, Y.QTY199, Y.QTY200
                             , Y.QTY201, Y.QTY202, Y.QTY203, Y.QTY204, Y.QTY205, Y.QTY206, Y.QTY207, Y.QTY208
                             , Y.QTY209, Y.QTY210, Y.QTY211, Y.QTY212, Y.QTY213, Y.QTY214, Y.QTY215, Y.QTY216
                             , Y.QTY217, Y.QTY218, Y.QTY219, Y.QTY220, Y.QTY221, Y.QTY222, Y.QTY223, Y.QTY224
                             , Y.QTY225, Y.QTY226, Y.QTY227, Y.QTY228, Y.QTY229, Y.QTY230, Y.QTY231, Y.QTY232
                             , Y.QTY233, Y.QTY234, Y.QTY235, Y.QTY236, Y.QTY237, Y.QTY238, Y.QTY239, Y.QTY240
                             , Y.QTY241, Y.QTY242, Y.QTY243, Y.QTY244, Y.QTY245, Y.QTY246, Y.QTY247, Y.QTY248
                             , Y.QTY249, Y.QTY250, Y.QTY251, Y.QTY252, Y.QTY253, Y.QTY254, Y.QTY255, Y.QTY256
                             , Y.QTY257, Y.QTY258, Y.QTY259, Y.QTY260, Y.QTY261, Y.QTY262, Y.QTY263, Y.QTY264
                             , Y.QTY265, Y.QTY266, Y.QTY267, Y.QTY268, Y.QTY269, Y.QTY270, Y.QTY271, Y.QTY272
                             , Y.QTY273, Y.QTY274, Y.QTY275, Y.QTY276, Y.QTY277, Y.QTY278, Y.QTY279, Y.QTY280
                             , Y.QTY281, Y.QTY282, Y.QTY283, Y.QTY284, Y.QTY285, Y.QTY286, Y.QTY287, Y.QTY288
                             , Y.QTY289, Y.QTY290, Y.QTY291, Y.QTY292, Y.QTY293, Y.QTY294, Y.QTY295, Y.QTY296
                             , Y.QTY297, Y.QTY298, Y.QTY299, Y.QTY300, Y.QTY301, Y.QTY302, Y.QTY303, Y.QTY304
                             , Y.QTY305, Y.QTY306, Y.QTY307, Y.QTY308, Y.QTY309, Y.QTY310, Y.QTY311, Y.QTY312
                             , Y.QTY313, Y.QTY314, Y.QTY315, Y.QTY316, Y.QTY317, Y.QTY318, Y.QTY319, Y.QTY320
                             , Y.QTY321, Y.QTY322, Y.QTY323, Y.QTY324, Y.QTY325, Y.QTY326, Y.QTY327, Y.QTY328
                             , Y.QTY329, Y.QTY330, Y.QTY331, Y.QTY332, Y.QTY333, Y.QTY334, Y.QTY335, Y.QTY336
                             , Y.QTY337, Y.QTY338, Y.QTY339, Y.QTY340, Y.QTY341, Y.QTY342, Y.QTY343, Y.QTY344
                             , Y.QTY345, Y.QTY346, Y.QTY347, Y.QTY348, Y.QTY349, Y.QTY350, Y.QTY351, Y.QTY352
                             , Y.QTY353, Y.QTY354, Y.QTY355, Y.QTY356, Y.QTY357, Y.QTY358, Y.QTY359, Y.QTY360
                             , Y.QTY361, Y.QTY362, Y.QTY363, Y.QTY364
                             , Y.QTY001 + Y.QTY002 + Y.QTY003 + Y.QTY004 + Y.QTY005 + Y.QTY006 + Y.QTY007
                             , Y.QTY008 + Y.QTY009 + Y.QTY010 + Y.QTY011 + Y.QTY012 + Y.QTY013 + Y.QTY014
                             , Y.QTY015 + Y.QTY016 + Y.QTY017 + Y.QTY018 + Y.QTY019 + Y.QTY020 + Y.QTY021
                             , Y.QTY022 + Y.QTY023 + Y.QTY024 + Y.QTY025 + Y.QTY026 + Y.QTY027 + Y.QTY028
                             , Y.QTY029 + Y.QTY030 + Y.QTY031 + Y.QTY032 + Y.QTY033 + Y.QTY034 + Y.QTY035
                             , Y.QTY036 + Y.QTY037 + Y.QTY038 + Y.QTY039 + Y.QTY040 + Y.QTY041 + Y.QTY042
                             , Y.QTY043 + Y.QTY044 + Y.QTY045 + Y.QTY046 + Y.QTY047 + Y.QTY048 + Y.QTY049
                             , Y.QTY050 + Y.QTY051 + Y.QTY052 + Y.QTY053 + Y.QTY054 + Y.QTY055 + Y.QTY056
                             , Y.QTY057 + Y.QTY058 + Y.QTY059 + Y.QTY060 + Y.QTY061 + Y.QTY062 + Y.QTY063
                             , Y.QTY064 + Y.QTY065 + Y.QTY066 + Y.QTY067 + Y.QTY068 + Y.QTY069 + Y.QTY070
                             , Y.QTY071 + Y.QTY072 + Y.QTY073 + Y.QTY074 + Y.QTY075 + Y.QTY076 + Y.QTY007   /* ★원본 L1998 오타 : 마지막 항이 QTY077 이 아니라 QTY007 이다. 1:1 원칙상 그대로 보존한다(CV-001). */
                             , Y.QTY078 + Y.QTY079 + Y.QTY080 + Y.QTY081 + Y.QTY082 + Y.QTY083 + Y.QTY084
                             , Y.QTY085 + Y.QTY086 + Y.QTY087 + Y.QTY088 + Y.QTY089 + Y.QTY090 + Y.QTY091
                             , Y.QTY092 + Y.QTY093 + Y.QTY094 + Y.QTY095 + Y.QTY096 + Y.QTY097 + Y.QTY098
                             , Y.QTY099 + Y.QTY100 + Y.QTY101 + Y.QTY102 + Y.QTY103 + Y.QTY104 + Y.QTY105
                             , Y.QTY106 + Y.QTY107 + Y.QTY108 + Y.QTY109 + Y.QTY110 + Y.QTY111 + Y.QTY112
                             , Y.QTY113 + Y.QTY114 + Y.QTY115 + Y.QTY116 + Y.QTY117 + Y.QTY118 + Y.QTY119
                             , Y.QTY120 + Y.QTY121 + Y.QTY122 + Y.QTY123 + Y.QTY124 + Y.QTY125 + Y.QTY126
                             , Y.QTY127 + Y.QTY128 + Y.QTY129 + Y.QTY130 + Y.QTY131 + Y.QTY132 + Y.QTY133
                             , Y.QTY134 + Y.QTY135 + Y.QTY136 + Y.QTY137 + Y.QTY138 + Y.QTY139 + Y.QTY140
                             , Y.QTY141 + Y.QTY142 + Y.QTY143 + Y.QTY144 + Y.QTY145 + Y.QTY146 + Y.QTY147
                             , Y.QTY148 + Y.QTY149 + Y.QTY150 + Y.QTY151 + Y.QTY152 + Y.QTY153 + Y.QTY154
                             , Y.QTY155 + Y.QTY156 + Y.QTY157 + Y.QTY158 + Y.QTY159 + Y.QTY160 + Y.QTY161
                             , Y.QTY162 + Y.QTY163 + Y.QTY164 + Y.QTY165 + Y.QTY166 + Y.QTY167 + Y.QTY168
                             , Y.QTY169 + Y.QTY170 + Y.QTY171 + Y.QTY172 + Y.QTY173 + Y.QTY174 + Y.QTY175
                             , Y.QTY176 + Y.QTY177 + Y.QTY178 + Y.QTY179 + Y.QTY180 + Y.QTY181 + Y.QTY182
                             , Y.QTY183 + Y.QTY184 + Y.QTY185 + Y.QTY186 + Y.QTY187 + Y.QTY188 + Y.QTY189
                             , Y.QTY190 + Y.QTY191 + Y.QTY192 + Y.QTY193 + Y.QTY194 + Y.QTY195 + Y.QTY196
                             , Y.QTY197 + Y.QTY198 + Y.QTY199 + Y.QTY200 + Y.QTY201 + Y.QTY202 + Y.QTY203
                             , Y.QTY204 + Y.QTY205 + Y.QTY206 + Y.QTY207 + Y.QTY208 + Y.QTY209 + Y.QTY210
                             , Y.QTY211 + Y.QTY212 + Y.QTY213 + Y.QTY214 + Y.QTY215 + Y.QTY216 + Y.QTY217
                             , Y.QTY218 + Y.QTY219 + Y.QTY220 + Y.QTY221 + Y.QTY222 + Y.QTY223 + Y.QTY224
                             , Y.QTY225 + Y.QTY226 + Y.QTY227 + Y.QTY228 + Y.QTY229 + Y.QTY230 + Y.QTY231
                             , Y.QTY232 + Y.QTY233 + Y.QTY234 + Y.QTY235 + Y.QTY236 + Y.QTY237 + Y.QTY238
                             , Y.QTY239 + Y.QTY240 + Y.QTY241 + Y.QTY242 + Y.QTY243 + Y.QTY244 + Y.QTY245
                             , Y.QTY246 + Y.QTY247 + Y.QTY248 + Y.QTY249 + Y.QTY250 + Y.QTY251 + Y.QTY252
                             , Y.QTY253 + Y.QTY254 + Y.QTY255 + Y.QTY256 + Y.QTY257 + Y.QTY258 + Y.QTY259
                             , Y.QTY260 + Y.QTY261 + Y.QTY262 + Y.QTY263 + Y.QTY264 + Y.QTY265 + Y.QTY266
                             , Y.QTY267 + Y.QTY268 + Y.QTY269 + Y.QTY270 + Y.QTY271 + Y.QTY272 + Y.QTY273
                             , Y.QTY274 + Y.QTY275 + Y.QTY276 + Y.QTY277 + Y.QTY278 + Y.QTY279 + Y.QTY280
                             , Y.QTY281 + Y.QTY282 + Y.QTY283 + Y.QTY284 + Y.QTY285 + Y.QTY286 + Y.QTY287
                             , Y.QTY288 + Y.QTY289 + Y.QTY290 + Y.QTY291 + Y.QTY292 + Y.QTY293 + Y.QTY294
                             , Y.QTY295 + Y.QTY296 + Y.QTY297 + Y.QTY298 + Y.QTY299 + Y.QTY300 + Y.QTY301
                             , Y.QTY302 + Y.QTY303 + Y.QTY304 + Y.QTY305 + Y.QTY306 + Y.QTY307 + Y.QTY308
                             , Y.QTY309 + Y.QTY310 + Y.QTY311 + Y.QTY312 + Y.QTY313 + Y.QTY314 + Y.QTY315
                             , Y.QTY316 + Y.QTY317 + Y.QTY318 + Y.QTY319 + Y.QTY320 + Y.QTY321 + Y.QTY322
                             , Y.QTY323 + Y.QTY324 + Y.QTY325 + Y.QTY326 + Y.QTY327 + Y.QTY328 + Y.QTY329
                             , Y.QTY330 + Y.QTY331 + Y.QTY332 + Y.QTY333 + Y.QTY334 + Y.QTY335 + Y.QTY336
                             , Y.QTY337 + Y.QTY338 + Y.QTY339 + Y.QTY340 + Y.QTY341 + Y.QTY342 + Y.QTY343
                             , Y.QTY344 + Y.QTY345 + Y.QTY346 + Y.QTY347 + Y.QTY348 + Y.QTY349 + Y.QTY350
                             , Y.QTY351 + Y.QTY352 + Y.QTY353 + Y.QTY354 + Y.QTY355 + Y.QTY356 + Y.QTY357
                             , Y.QTY358 + Y.QTY359 + Y.QTY360 + Y.QTY361 + Y.QTY362 + Y.QTY363 + Y.QTY364
                                  , V_BATCH_USER_ID
                                  , SYSDATE
                               FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL Y
                              WHERE X.XLS_KEY1             = Y.XLS_KEY1
                                AND X.CREATE_FROM_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD
                                AND X.DIVISION_ID          = Y.DIVISION_ID
                                AND ROWNUM = 1 )
                     WHERE 0 = 0
                       AND X.DIVISION_ID          = V_BATCH_DIVISION_ID
                       AND X.PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                       AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                       AND X.SEQ                  = V_BATCH_SEQ
                       AND X.XLS_KEY1             = V_BATCH_XLS_KEY1   /* 43 */
                       AND X.MEASURE              IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
                       AND EXISTS ( SELECT 1
                                      FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL Y
                                     WHERE X.XLS_KEY1             = Y.XLS_KEY1
                                       AND X.CREATE_FROM_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD
                                       AND X.DIVISION_ID          = Y.DIVISION_ID )
                         ;

                    /* -------------------------------------------------------------------------------------------------------------------------------------------------------
                    --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (SEMI_SHIP_PLAN)
                    ------------------------------------------------------------------------------------------------------------------------------------------------------- */
                    /*  CELL_PROD 동기화와 같은 사유로 상관 UPDATE + EXISTS + ROWNUM = 1 (CV-024). */
                    UPDATE SCP_XLS_PSI_GLOBAL JV
                       SET (
                             QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008
                           , QTY009, QTY010, QTY011, QTY012, QTY013, QTY014, QTY015, QTY016
                           , QTY017, QTY018, QTY019, QTY020, QTY021, QTY022, QTY023, QTY024
                           , QTY025, QTY026, QTY027, QTY028, QTY029, QTY030, QTY031, QTY032
                           , QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                           , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048
                           , QTY049, QTY050, QTY051, QTY052, QTY053, QTY054, QTY055, QTY056
                           , QTY057, QTY058, QTY059, QTY060, QTY061, QTY062, QTY063, QTY064
                           , QTY065, QTY066, QTY067, QTY068, QTY069, QTY070, QTY071, QTY072
                           , QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                           , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088
                           , QTY089, QTY090, QTY091, QTY092, QTY093, QTY094, QTY095, QTY096
                           , QTY097, QTY098, QTY099, QTY100, QTY101, QTY102, QTY103, QTY104
                           , QTY105, QTY106, QTY107, QTY108, QTY109, QTY110, QTY111, QTY112
                           , QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                           , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128
                           , QTY129, QTY130, QTY131, QTY132, QTY133, QTY134, QTY135, QTY136
                           , QTY137, QTY138, QTY139, QTY140, QTY141, QTY142, QTY143, QTY144
                           , QTY145, QTY146, QTY147, QTY148, QTY149, QTY150, QTY151, QTY152
                           , QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                           , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168
                           , QTY169, QTY170, QTY171, QTY172, QTY173, QTY174, QTY175, QTY176
                           , QTY177, QTY178, QTY179, QTY180, QTY181, QTY182, QTY183, QTY184
                           , QTY185, QTY186, QTY187, QTY188, QTY189, QTY190, QTY191, QTY192
                           , QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                           , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208
                           , QTY209, QTY210, QTY211, QTY212, QTY213, QTY214, QTY215, QTY216
                           , QTY217, QTY218, QTY219, QTY220, QTY221, QTY222, QTY223, QTY224
                           , QTY225, QTY226, QTY227, QTY228, QTY229, QTY230, QTY231, QTY232
                           , QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                           , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248
                           , QTY249, QTY250, QTY251, QTY252, QTY253, QTY254, QTY255, QTY256
                           , QTY257, QTY258, QTY259, QTY260, QTY261, QTY262, QTY263, QTY264
                           , QTY265, QTY266, QTY267, QTY268, QTY269, QTY270, QTY271, QTY272
                           , QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                           , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288
                           , QTY289, QTY290, QTY291, QTY292, QTY293, QTY294, QTY295, QTY296
                           , QTY297, QTY298, QTY299, QTY300, QTY301, QTY302, QTY303, QTY304
                           , QTY305, QTY306, QTY307, QTY308, QTY309, QTY310, QTY311, QTY312
                           , QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                           , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328
                           , QTY329, QTY330, QTY331, QTY332, QTY333, QTY334, QTY335, QTY336
                           , QTY337, QTY338, QTY339, QTY340, QTY341, QTY342, QTY343, QTY344
                           , QTY345, QTY346, QTY347, QTY348, QTY349, QTY350, QTY351, QTY352
                           , QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                           , QTY361, QTY362, QTY363, QTY364, WQTY01, WQTY02, WQTY03, WQTY04
                           , WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10, WQTY11, WQTY12
                           , WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                           , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28
                           , WQTY29, WQTY30, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36
                           , WQTY37, WQTY38, WQTY39, WQTY40, WQTY41, WQTY42, WQTY43, WQTY44
                           , WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50, WQTY51, WQTY52
                           , LAST_UPDATE_DATE, LAST_UPDATED_BY
                           ) =
                           ( SELECT
                               ES.QTY001, ES.QTY002, ES.QTY003, ES.QTY004, ES.QTY005, ES.QTY006, ES.QTY007, ES.QTY008
                             , ES.QTY009, ES.QTY010, ES.QTY011, ES.QTY012, ES.QTY013, ES.QTY014, ES.QTY015, ES.QTY016
                             , ES.QTY017, ES.QTY018, ES.QTY019, ES.QTY020, ES.QTY021, ES.QTY022, ES.QTY023, ES.QTY024
                             , ES.QTY025, ES.QTY026, ES.QTY027, ES.QTY028, ES.QTY029, ES.QTY030, ES.QTY031, ES.QTY032
                             , ES.QTY033, ES.QTY034, ES.QTY035, ES.QTY036, ES.QTY037, ES.QTY038, ES.QTY039, ES.QTY040
                             , ES.QTY041, ES.QTY042, ES.QTY043, ES.QTY044, ES.QTY045, ES.QTY046, ES.QTY047, ES.QTY048
                             , ES.QTY049, ES.QTY050, ES.QTY051, ES.QTY052, ES.QTY053, ES.QTY054, ES.QTY055, ES.QTY056
                             , ES.QTY057, ES.QTY058, ES.QTY059, ES.QTY060, ES.QTY061, ES.QTY062, ES.QTY063, ES.QTY064
                             , ES.QTY065, ES.QTY066, ES.QTY067, ES.QTY068, ES.QTY069, ES.QTY070, ES.QTY071, ES.QTY072
                             , ES.QTY073, ES.QTY074, ES.QTY075, ES.QTY076, ES.QTY077, ES.QTY078, ES.QTY079, ES.QTY080
                             , ES.QTY081, ES.QTY082, ES.QTY083, ES.QTY084, ES.QTY085, ES.QTY086, ES.QTY087, ES.QTY088
                             , ES.QTY089, ES.QTY090, ES.QTY091, ES.QTY092, ES.QTY093, ES.QTY094, ES.QTY095, ES.QTY096
                             , ES.QTY097, ES.QTY098, ES.QTY099, ES.QTY100, ES.QTY101, ES.QTY102, ES.QTY103, ES.QTY104
                             , ES.QTY105, ES.QTY106, ES.QTY107, ES.QTY108, ES.QTY109, ES.QTY110, ES.QTY111, ES.QTY112
                             , ES.QTY113, ES.QTY114, ES.QTY115, ES.QTY116, ES.QTY117, ES.QTY118, ES.QTY119, ES.QTY120
                             , ES.QTY121, ES.QTY122, ES.QTY123, ES.QTY124, ES.QTY125, ES.QTY126, ES.QTY127, ES.QTY128
                             , ES.QTY129, ES.QTY130, ES.QTY131, ES.QTY132, ES.QTY133, ES.QTY134, ES.QTY135, ES.QTY136
                             , ES.QTY137, ES.QTY138, ES.QTY139, ES.QTY140, ES.QTY141, ES.QTY142, ES.QTY143, ES.QTY144
                             , ES.QTY145, ES.QTY146, ES.QTY147, ES.QTY148, ES.QTY149, ES.QTY150, ES.QTY151, ES.QTY152
                             , ES.QTY153, ES.QTY154, ES.QTY155, ES.QTY156, ES.QTY157, ES.QTY158, ES.QTY159, ES.QTY160
                             , ES.QTY161, ES.QTY162, ES.QTY163, ES.QTY164, ES.QTY165, ES.QTY166, ES.QTY167, ES.QTY168
                             , ES.QTY169, ES.QTY170, ES.QTY171, ES.QTY172, ES.QTY173, ES.QTY174, ES.QTY175, ES.QTY176
                             , ES.QTY177, ES.QTY178, ES.QTY179, ES.QTY180, ES.QTY181, ES.QTY182, ES.QTY183, ES.QTY184
                             , ES.QTY185, ES.QTY186, ES.QTY187, ES.QTY188, ES.QTY189, ES.QTY190, ES.QTY191, ES.QTY192
                             , ES.QTY193, ES.QTY194, ES.QTY195, ES.QTY196, ES.QTY197, ES.QTY198, ES.QTY199, ES.QTY200
                             , ES.QTY201, ES.QTY202, ES.QTY203, ES.QTY204, ES.QTY205, ES.QTY206, ES.QTY207, ES.QTY208
                             , ES.QTY209, ES.QTY210, ES.QTY211, ES.QTY212, ES.QTY213, ES.QTY214, ES.QTY215, ES.QTY216
                             , ES.QTY217, ES.QTY218, ES.QTY219, ES.QTY220, ES.QTY221, ES.QTY222, ES.QTY223, ES.QTY224
                             , ES.QTY225, ES.QTY226, ES.QTY227, ES.QTY228, ES.QTY229, ES.QTY230, ES.QTY231, ES.QTY232
                             , ES.QTY233, ES.QTY234, ES.QTY235, ES.QTY236, ES.QTY237, ES.QTY238, ES.QTY239, ES.QTY240
                             , ES.QTY241, ES.QTY242, ES.QTY243, ES.QTY244, ES.QTY245, ES.QTY246, ES.QTY247, ES.QTY248
                             , ES.QTY249, ES.QTY250, ES.QTY251, ES.QTY252, ES.QTY253, ES.QTY254, ES.QTY255, ES.QTY256
                             , ES.QTY257, ES.QTY258, ES.QTY259, ES.QTY260, ES.QTY261, ES.QTY262, ES.QTY263, ES.QTY264
                             , ES.QTY265, ES.QTY266, ES.QTY267, ES.QTY268, ES.QTY269, ES.QTY270, ES.QTY271, ES.QTY272
                             , ES.QTY273, ES.QTY274, ES.QTY275, ES.QTY276, ES.QTY277, ES.QTY278, ES.QTY279, ES.QTY280
                             , ES.QTY281, ES.QTY282, ES.QTY283, ES.QTY284, ES.QTY285, ES.QTY286, ES.QTY287, ES.QTY288
                             , ES.QTY289, ES.QTY290, ES.QTY291, ES.QTY292, ES.QTY293, ES.QTY294, ES.QTY295, ES.QTY296
                             , ES.QTY297, ES.QTY298, ES.QTY299, ES.QTY300, ES.QTY301, ES.QTY302, ES.QTY303, ES.QTY304
                             , ES.QTY305, ES.QTY306, ES.QTY307, ES.QTY308, ES.QTY309, ES.QTY310, ES.QTY311, ES.QTY312
                             , ES.QTY313, ES.QTY314, ES.QTY315, ES.QTY316, ES.QTY317, ES.QTY318, ES.QTY319, ES.QTY320
                             , ES.QTY321, ES.QTY322, ES.QTY323, ES.QTY324, ES.QTY325, ES.QTY326, ES.QTY327, ES.QTY328
                             , ES.QTY329, ES.QTY330, ES.QTY331, ES.QTY332, ES.QTY333, ES.QTY334, ES.QTY335, ES.QTY336
                             , ES.QTY337, ES.QTY338, ES.QTY339, ES.QTY340, ES.QTY341, ES.QTY342, ES.QTY343, ES.QTY344
                             , ES.QTY345, ES.QTY346, ES.QTY347, ES.QTY348, ES.QTY349, ES.QTY350, ES.QTY351, ES.QTY352
                             , ES.QTY353, ES.QTY354, ES.QTY355, ES.QTY356, ES.QTY357, ES.QTY358, ES.QTY359, ES.QTY360
                             , ES.QTY361, ES.QTY362, ES.QTY363, ES.QTY364, ES.WQTY01, ES.WQTY02, ES.WQTY03, ES.WQTY04
                             , ES.WQTY05, ES.WQTY06, ES.WQTY07, ES.WQTY08, ES.WQTY09, ES.WQTY10, ES.WQTY11, ES.WQTY12
                             , ES.WQTY13, ES.WQTY14, ES.WQTY15, ES.WQTY16, ES.WQTY17, ES.WQTY18, ES.WQTY19, ES.WQTY20
                             , ES.WQTY21, ES.WQTY22, ES.WQTY23, ES.WQTY24, ES.WQTY25, ES.WQTY26, ES.WQTY27, ES.WQTY28
                             , ES.WQTY29, ES.WQTY30, ES.WQTY31, ES.WQTY32, ES.WQTY33, ES.WQTY34, ES.WQTY35, ES.WQTY36
                             , ES.WQTY37, ES.WQTY38, ES.WQTY39, ES.WQTY40, ES.WQTY41, ES.WQTY42, ES.WQTY43, ES.WQTY44
                             , ES.WQTY45, ES.WQTY46, ES.WQTY47, ES.WQTY48, ES.WQTY49, ES.WQTY50, ES.WQTY51, ES.WQTY52
                             , SYSDATE, V_BATCH_USER_ID || '(XLSPSI06)'
                               FROM SCP_XLS_PSI_GLOBAL_ESS ES
                                  , GT_XPGT_JV_ESS_SCM_SITE_MAP SM
                                  , GT_XPGT_DIVISION_LAST_PLAN_INFO VD
                              WHERE SM.VP_DIVISION_ID          = ES.DIVISION_ID
                                AND SM.VP_SCM_SITE_ID          = ES.FROM_SITE
                                AND VD.DIVISION_ID             = SM.RP_DIVISION_ID
                                AND VD.PLAN_START_YYYYMMDD     = ES.PLAN_START_YYYYMMDD
                                AND JV.DIVISION_ID             = VD.DIVISION_ID
                                AND JV.PLAN_START_YYYYMMDD     = VD.PLAN_START_YYYYMMDD
                                AND JV.PLAN_TYPE               = VD.PLAN_TYPE
                                AND JV.SEQ                     = VD.PLAN_SEQ
                                AND JV.FROM_SITE               = SM.RP_SCM_SITE_ID
                                AND JV.TO_SITE                 = ES.TO_SITE
                                AND JV.MEASURE                 = ES.MEASURE
                                AND JV.ITEM_ID                 = ES.ITEM_ID
                                AND JV.CELL_ITEM_ID            = ES.CELL_ITEM_ID
                                AND JV.OPERATION_GROUP         = ES.OPERATION_GROUP
                                AND JV.CREATE_FROM_YYYYMMDD    = ES.CREATE_FROM_YYYYMMDD
                                AND 0 = 0
                                AND ES.DIVISION_ID             = V_BATCH_DIVISION_ID
                                AND ES.PLAN_START_YYYYMMDD     = V_BATCH_PLAN_START_YYYYMMDD
                                AND ES.CREATE_FROM_YYYYMMDD    = V_BATCH_CREATE_FROM_YYYYMMDD
                                AND ES.SEQ                     = V_BATCH_SEQ
                                AND ES.XLS_KEY1                = V_BATCH_XLS_KEY1
                                AND ES.OPERATION_GROUP         = 'A'
                                AND ES.MEASURE                 = 'SEMI_SHIP_PLAN'
                                AND ROWNUM = 1 )
                     WHERE EXISTS ( SELECT 1
                                      FROM SCP_XLS_PSI_GLOBAL_ESS ES
                                         , GT_XPGT_JV_ESS_SCM_SITE_MAP SM
                                         , GT_XPGT_DIVISION_LAST_PLAN_INFO VD
                                     WHERE SM.VP_DIVISION_ID          = ES.DIVISION_ID
                                       AND SM.VP_SCM_SITE_ID          = ES.FROM_SITE
                                       AND VD.DIVISION_ID             = SM.RP_DIVISION_ID
                                       AND VD.PLAN_START_YYYYMMDD     = ES.PLAN_START_YYYYMMDD
                                       AND JV.DIVISION_ID             = VD.DIVISION_ID
                                       AND JV.PLAN_START_YYYYMMDD     = VD.PLAN_START_YYYYMMDD
                                       AND JV.PLAN_TYPE               = VD.PLAN_TYPE
                                       AND JV.SEQ                     = VD.PLAN_SEQ
                                       AND JV.FROM_SITE               = SM.RP_SCM_SITE_ID
                                       AND JV.TO_SITE                 = ES.TO_SITE
                                       AND JV.MEASURE                 = ES.MEASURE
                                       AND JV.ITEM_ID                 = ES.ITEM_ID
                                       AND JV.CELL_ITEM_ID            = ES.CELL_ITEM_ID
                                       AND JV.OPERATION_GROUP         = ES.OPERATION_GROUP
                                       AND JV.CREATE_FROM_YYYYMMDD    = ES.CREATE_FROM_YYYYMMDD
                                       AND 0 = 0
                                       AND ES.DIVISION_ID             = V_BATCH_DIVISION_ID
                                       AND ES.PLAN_START_YYYYMMDD     = V_BATCH_PLAN_START_YYYYMMDD
                                       AND ES.CREATE_FROM_YYYYMMDD    = V_BATCH_CREATE_FROM_YYYYMMDD
                                       AND ES.SEQ                     = V_BATCH_SEQ
                                       AND ES.XLS_KEY1                = V_BATCH_XLS_KEY1
                                       AND ES.OPERATION_GROUP         = 'A'
                                       AND ES.MEASURE                 = 'SEMI_SHIP_PLAN'
                                  )
                         ;
                    /* -------------------------------------------------------------------------------------------------------------------------------------------------------
                    --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (SEMI_SHIP_PLAN)
                    ------------------------------------------------------------------------------------------------------------------------------------------------------- */
               END IF;   /* IF  @p_day_week_flag = 'week' */

            END IF;


            /* ------------------------------------------------------------------------------------------- */
            /*  SOURCE TABLE 반영 */
            /* ------------------------------------------------------------------------------------------- */

            /*  UI 작업자와 시물레이션 작업자를 구분하기 위해서 */
            /*                CASE 로 1:1 재현하고, NVARCHAR(150) 재대입 시의 조용한 절단도 SUBSTR 로 재현한다.
                ★07 과 달리 06_S 는 IN 파라미터가 아니라 별도 지역변수 @v_batch_user 에 담으므로 파라미터 재대입 문제가 없다. */
            V_BATCH_USER := CASE WHEN V_BATCH_USER_ID IS NULL
                                 THEN NULL
                                 ELSE SUBSTR(V_BATCH_USER_ID || '[SIMULATION]', 1, 150)
                            END;


            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FG UPDATE */
            /*  SHIP_PLAN  --> SCP_ANL_SHIPMENT_PLAN_FG.MEASURE 'SHIP_PLAN_AMEND' UPDATE */
            /* ------------------------------------------------------------------------------------------- */
            IF V_BATCH_MEASURE IN ('SHIP_PLAN') THEN   /* FG */

            /*  SHIP_PLAN */
               /*  IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL DROP TABLE #SCP_ANL_SHIPMENT_PLAN_FG */
               DELETE FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG;

               /*  MSSQL REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(..))) + CONVERT(NVARCHAR, ROW_NUMBER() OVER(..)) */
               INSERT INTO GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG
                    ( DIVISION_ID
                    , PLAN_START_YYYYMMDD
                    , PLAN_TYPE
                    , SEQ
                    , BIZ_TYPE
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
                    , ORIGIN_FROM_DIVISION_ID
                    , ORIGIN_TO_DIVISION_ID
                    , ELECTRODE_TYPE
                    , ATTRIBUTE1
                    , YYYYMMDD_COLUMN )
            SELECT X.DIVISION_ID
                 , X.PLAN_START_YYYYMMDD
                 , X.PLAN_TYPE
                 , X.SEQ
                 , X.OPERATION_GROUP AS BIZ_TYPE
                 , X.PROJECT_CODE
                 /* , X.CELL_ITEM_ID */
                 , X.ITEM_ID
                 , X.TO_SITE
                 , X.INCOTERMS
                 , X.FROM_SITE
                 , X.BOD_ID
                 , X.TRANSPORT_MODE
                 , 'SHIP_PLAN_AMEND' AS MEASURE
                 , Y.YYYYMMDD AS YYYYMMDD
                 , X.QTY
                 , '82' AS ORIGIN_FROM_DIVISION_ID
                 , '82' AS ORIGIN_TO_DIVISION_ID
                 , '' AS ELECTRODE_TYPE   /* Oracle 은 '' = NULL. 적재처 ELECTRODE_TYPE 은 NULL 허용이라 원본 '' 를 그대로 옮긴다. */
                 , X.ATTRIBUTE1
                 , Y.YYYYMMDD_COLUMN
              FROM ( SELECT *
                       FROM SCP_XLS_PSI_GLOBAL_ESS
                      WHERE 0 = 0
                        AND DIVISION_ID          = V_BATCH_DIVISION_ID
                        AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                        AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                        AND SEQ                  = V_BATCH_SEQ
                        AND XLS_KEY1             = V_BATCH_XLS_KEY1   /* 43 */
                   )
                   UNPIVOT ( QTY FOR YYYYMMDD_COLUMN IN (
                                         QTY001 AS 'QTY001', QTY002 AS 'QTY002', QTY003 AS 'QTY003', QTY004 AS 'QTY004', QTY005 AS 'QTY005'
                                       , QTY006 AS 'QTY006', QTY007 AS 'QTY007', QTY008 AS 'QTY008', QTY009 AS 'QTY009', QTY010 AS 'QTY010'
                                       , QTY011 AS 'QTY011', QTY012 AS 'QTY012', QTY013 AS 'QTY013', QTY014 AS 'QTY014', QTY015 AS 'QTY015'
                                       , QTY016 AS 'QTY016', QTY017 AS 'QTY017', QTY018 AS 'QTY018', QTY019 AS 'QTY019', QTY020 AS 'QTY020'
                                       , QTY021 AS 'QTY021', QTY022 AS 'QTY022', QTY023 AS 'QTY023', QTY024 AS 'QTY024', QTY025 AS 'QTY025'
                                       , QTY026 AS 'QTY026', QTY027 AS 'QTY027', QTY028 AS 'QTY028', QTY029 AS 'QTY029', QTY030 AS 'QTY030'
                                       , QTY031 AS 'QTY031', QTY032 AS 'QTY032', QTY033 AS 'QTY033', QTY034 AS 'QTY034', QTY035 AS 'QTY035'
                                       , QTY036 AS 'QTY036', QTY037 AS 'QTY037', QTY038 AS 'QTY038', QTY039 AS 'QTY039', QTY040 AS 'QTY040'
                                       , QTY041 AS 'QTY041', QTY042 AS 'QTY042', QTY043 AS 'QTY043', QTY044 AS 'QTY044', QTY045 AS 'QTY045'
                                       , QTY046 AS 'QTY046', QTY047 AS 'QTY047', QTY048 AS 'QTY048', QTY049 AS 'QTY049', QTY050 AS 'QTY050'
                                       , QTY051 AS 'QTY051', QTY052 AS 'QTY052', QTY053 AS 'QTY053', QTY054 AS 'QTY054', QTY055 AS 'QTY055'
                                       , QTY056 AS 'QTY056', QTY057 AS 'QTY057', QTY058 AS 'QTY058', QTY059 AS 'QTY059', QTY060 AS 'QTY060'
                                       , QTY061 AS 'QTY061', QTY062 AS 'QTY062', QTY063 AS 'QTY063', QTY064 AS 'QTY064', QTY065 AS 'QTY065'
                                       , QTY066 AS 'QTY066', QTY067 AS 'QTY067', QTY068 AS 'QTY068', QTY069 AS 'QTY069', QTY070 AS 'QTY070'
                                       , QTY071 AS 'QTY071', QTY072 AS 'QTY072', QTY073 AS 'QTY073', QTY074 AS 'QTY074', QTY075 AS 'QTY075'
                                       , QTY076 AS 'QTY076', QTY077 AS 'QTY077', QTY078 AS 'QTY078', QTY079 AS 'QTY079', QTY080 AS 'QTY080'
                                       , QTY081 AS 'QTY081', QTY082 AS 'QTY082', QTY083 AS 'QTY083', QTY084 AS 'QTY084', QTY085 AS 'QTY085'
                                       , QTY086 AS 'QTY086', QTY087 AS 'QTY087', QTY088 AS 'QTY088', QTY089 AS 'QTY089', QTY090 AS 'QTY090'
                                       , QTY091 AS 'QTY091', QTY092 AS 'QTY092', QTY093 AS 'QTY093', QTY094 AS 'QTY094', QTY095 AS 'QTY095'
                                       , QTY096 AS 'QTY096', QTY097 AS 'QTY097', QTY098 AS 'QTY098', QTY099 AS 'QTY099', QTY100 AS 'QTY100'
                                       , QTY101 AS 'QTY101', QTY102 AS 'QTY102', QTY103 AS 'QTY103', QTY104 AS 'QTY104', QTY105 AS 'QTY105'
                                       , QTY106 AS 'QTY106', QTY107 AS 'QTY107', QTY108 AS 'QTY108', QTY109 AS 'QTY109', QTY110 AS 'QTY110'
                                       , QTY111 AS 'QTY111', QTY112 AS 'QTY112', QTY113 AS 'QTY113', QTY114 AS 'QTY114', QTY115 AS 'QTY115'
                                       , QTY116 AS 'QTY116', QTY117 AS 'QTY117', QTY118 AS 'QTY118', QTY119 AS 'QTY119', QTY120 AS 'QTY120'
                                       , QTY121 AS 'QTY121', QTY122 AS 'QTY122', QTY123 AS 'QTY123', QTY124 AS 'QTY124', QTY125 AS 'QTY125'
                                       , QTY126 AS 'QTY126', QTY127 AS 'QTY127', QTY128 AS 'QTY128', QTY129 AS 'QTY129', QTY130 AS 'QTY130'
                                       , QTY131 AS 'QTY131', QTY132 AS 'QTY132', QTY133 AS 'QTY133', QTY134 AS 'QTY134', QTY135 AS 'QTY135'
                                       , QTY136 AS 'QTY136', QTY137 AS 'QTY137', QTY138 AS 'QTY138', QTY139 AS 'QTY139', QTY140 AS 'QTY140'
                                       , QTY141 AS 'QTY141', QTY142 AS 'QTY142', QTY143 AS 'QTY143', QTY144 AS 'QTY144', QTY145 AS 'QTY145'
                                       , QTY146 AS 'QTY146', QTY147 AS 'QTY147', QTY148 AS 'QTY148', QTY149 AS 'QTY149', QTY150 AS 'QTY150'
                                       , QTY151 AS 'QTY151', QTY152 AS 'QTY152', QTY153 AS 'QTY153', QTY154 AS 'QTY154', QTY155 AS 'QTY155'
                                       , QTY156 AS 'QTY156', QTY157 AS 'QTY157', QTY158 AS 'QTY158', QTY159 AS 'QTY159', QTY160 AS 'QTY160'
                                       , QTY161 AS 'QTY161', QTY162 AS 'QTY162', QTY163 AS 'QTY163', QTY164 AS 'QTY164', QTY165 AS 'QTY165'
                                       , QTY166 AS 'QTY166', QTY167 AS 'QTY167', QTY168 AS 'QTY168', QTY169 AS 'QTY169', QTY170 AS 'QTY170'
                                       , QTY171 AS 'QTY171', QTY172 AS 'QTY172', QTY173 AS 'QTY173', QTY174 AS 'QTY174', QTY175 AS 'QTY175'
                                       , QTY176 AS 'QTY176', QTY177 AS 'QTY177', QTY178 AS 'QTY178', QTY179 AS 'QTY179', QTY180 AS 'QTY180'
                                       , QTY181 AS 'QTY181', QTY182 AS 'QTY182', QTY183 AS 'QTY183', QTY184 AS 'QTY184', QTY185 AS 'QTY185'
                                       , QTY186 AS 'QTY186', QTY187 AS 'QTY187', QTY188 AS 'QTY188', QTY189 AS 'QTY189', QTY190 AS 'QTY190'
                                       , QTY191 AS 'QTY191', QTY192 AS 'QTY192', QTY193 AS 'QTY193', QTY194 AS 'QTY194', QTY195 AS 'QTY195'
                                       , QTY196 AS 'QTY196', QTY197 AS 'QTY197', QTY198 AS 'QTY198', QTY199 AS 'QTY199', QTY200 AS 'QTY200'
                                       , QTY201 AS 'QTY201', QTY202 AS 'QTY202', QTY203 AS 'QTY203', QTY204 AS 'QTY204', QTY205 AS 'QTY205'
                                       , QTY206 AS 'QTY206', QTY207 AS 'QTY207', QTY208 AS 'QTY208', QTY209 AS 'QTY209', QTY210 AS 'QTY210'
                                       , QTY211 AS 'QTY211', QTY212 AS 'QTY212', QTY213 AS 'QTY213', QTY214 AS 'QTY214', QTY215 AS 'QTY215'
                                       , QTY216 AS 'QTY216', QTY217 AS 'QTY217', QTY218 AS 'QTY218', QTY219 AS 'QTY219', QTY220 AS 'QTY220'
                                       , QTY221 AS 'QTY221', QTY222 AS 'QTY222', QTY223 AS 'QTY223', QTY224 AS 'QTY224', QTY225 AS 'QTY225'
                                       , QTY226 AS 'QTY226', QTY227 AS 'QTY227', QTY228 AS 'QTY228', QTY229 AS 'QTY229', QTY230 AS 'QTY230'
                                       , QTY231 AS 'QTY231', QTY232 AS 'QTY232', QTY233 AS 'QTY233', QTY234 AS 'QTY234', QTY235 AS 'QTY235'
                                       , QTY236 AS 'QTY236', QTY237 AS 'QTY237', QTY238 AS 'QTY238', QTY239 AS 'QTY239', QTY240 AS 'QTY240'
                                       , QTY241 AS 'QTY241', QTY242 AS 'QTY242', QTY243 AS 'QTY243', QTY244 AS 'QTY244', QTY245 AS 'QTY245'
                                       , QTY246 AS 'QTY246', QTY247 AS 'QTY247', QTY248 AS 'QTY248', QTY249 AS 'QTY249', QTY250 AS 'QTY250'
                                       , QTY251 AS 'QTY251', QTY252 AS 'QTY252', QTY253 AS 'QTY253', QTY254 AS 'QTY254', QTY255 AS 'QTY255'
                                       , QTY256 AS 'QTY256', QTY257 AS 'QTY257', QTY258 AS 'QTY258', QTY259 AS 'QTY259', QTY260 AS 'QTY260'
                                       , QTY261 AS 'QTY261', QTY262 AS 'QTY262', QTY263 AS 'QTY263', QTY264 AS 'QTY264', QTY265 AS 'QTY265'
                                       , QTY266 AS 'QTY266', QTY267 AS 'QTY267', QTY268 AS 'QTY268', QTY269 AS 'QTY269', QTY270 AS 'QTY270'
                                       , QTY271 AS 'QTY271', QTY272 AS 'QTY272', QTY273 AS 'QTY273', QTY274 AS 'QTY274', QTY275 AS 'QTY275'
                                       , QTY276 AS 'QTY276', QTY277 AS 'QTY277', QTY278 AS 'QTY278', QTY279 AS 'QTY279', QTY280 AS 'QTY280'
                                       , QTY281 AS 'QTY281', QTY282 AS 'QTY282', QTY283 AS 'QTY283', QTY284 AS 'QTY284', QTY285 AS 'QTY285'
                                       , QTY286 AS 'QTY286', QTY287 AS 'QTY287', QTY288 AS 'QTY288', QTY289 AS 'QTY289', QTY290 AS 'QTY290'
                                       , QTY291 AS 'QTY291', QTY292 AS 'QTY292', QTY293 AS 'QTY293', QTY294 AS 'QTY294', QTY295 AS 'QTY295'
                                       , QTY296 AS 'QTY296', QTY297 AS 'QTY297', QTY298 AS 'QTY298', QTY299 AS 'QTY299', QTY300 AS 'QTY300'
                                       , QTY301 AS 'QTY301', QTY302 AS 'QTY302', QTY303 AS 'QTY303', QTY304 AS 'QTY304', QTY305 AS 'QTY305'
                                       , QTY306 AS 'QTY306', QTY307 AS 'QTY307', QTY308 AS 'QTY308', QTY309 AS 'QTY309', QTY310 AS 'QTY310'
                                       , QTY311 AS 'QTY311', QTY312 AS 'QTY312', QTY313 AS 'QTY313', QTY314 AS 'QTY314', QTY315 AS 'QTY315'
                                       , QTY316 AS 'QTY316', QTY317 AS 'QTY317', QTY318 AS 'QTY318', QTY319 AS 'QTY319', QTY320 AS 'QTY320'
                                       , QTY321 AS 'QTY321', QTY322 AS 'QTY322', QTY323 AS 'QTY323', QTY324 AS 'QTY324', QTY325 AS 'QTY325'
                                       , QTY326 AS 'QTY326', QTY327 AS 'QTY327', QTY328 AS 'QTY328', QTY329 AS 'QTY329', QTY330 AS 'QTY330'
                                       , QTY331 AS 'QTY331', QTY332 AS 'QTY332', QTY333 AS 'QTY333', QTY334 AS 'QTY334', QTY335 AS 'QTY335'
                                       , QTY336 AS 'QTY336', QTY337 AS 'QTY337', QTY338 AS 'QTY338', QTY339 AS 'QTY339', QTY340 AS 'QTY340'
                                       , QTY341 AS 'QTY341', QTY342 AS 'QTY342', QTY343 AS 'QTY343', QTY344 AS 'QTY344', QTY345 AS 'QTY345'
                                       , QTY346 AS 'QTY346', QTY347 AS 'QTY347', QTY348 AS 'QTY348', QTY349 AS 'QTY349', QTY350 AS 'QTY350'
                                       , QTY351 AS 'QTY351', QTY352 AS 'QTY352', QTY353 AS 'QTY353', QTY354 AS 'QTY354', QTY355 AS 'QTY355'
                                       , QTY356 AS 'QTY356', QTY357 AS 'QTY357', QTY358 AS 'QTY358', QTY359 AS 'QTY359', QTY360 AS 'QTY360'
                                       , QTY361 AS 'QTY361', QTY362 AS 'QTY362', QTY363 AS 'QTY363', QTY364 AS 'QTY364'
                                         )
                           ) X
                 , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                  , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                         AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
                              /* WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                                   AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd */
                            ) Y
             WHERE X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
              /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start */
               AND Y.YYYYMMDD          >= V_BOD_FROM
               AND Y.YYYYMMDD          <= V_BOD_TO
              /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end */
                 ;

            /* ------------------------------------------------------------------------------------------- */
            /*  FROZEN 구간 UPDATE */
            /*  PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다. */
            /* ------------------------------------------------------------------------------------------- */
              /* ▼ MSSQL 원본 L2254~L2263 원문 보존 (FG FROZEN 삭제 死코드(06_S 에서는 주석 처리되어 있다 - 07 과 다름)) ---------------------------------------------
                               IF @v_batch_plan_type IN  ('PR','MA','SE')
                               BEGIN
                                 DELETE  FROM #SCP_ANL_SHIPMENT_PLAN_FG
                                         FROM #SCP_ANL_SHIPMENT_PLAN_FG X
                                       INNER JOIN #SCM_MST_SITE Y
                                          ON Y.DIVISION_ID = X.DIVISION_ID
                                         AND Y.SCM_SITE_ID = X.FROM_SITE
                                       WHERE
                                           X.YYYYMMDD < Y.SHIP_FROZEN_WEEK_DAY;
                               END */
               MERGE INTO SCP_ANL_SHIPMENT_PLAN_FG X
                USING ( SELECT DIVISION_ID
                             , PLAN_START_YYYYMMDD
                             , PLAN_TYPE
                             , SEQ
                             , BIZ_TYPE
                             , PROJECT_CODE
                             /* , CELL_ITEM_ID */
                             , ITEM_ID
                             , TO_SITE
                             , INCOTERMS
                             , FROM_SITE
                             , BOD_ID
                             /* , TRANSPORT_MODE */
                             , MEASURE
                             , YYYYMMDD
                             , QTY
                             , ORIGIN_FROM_DIVISION_ID
                             , ORIGIN_TO_DIVISION_ID
                             , ELECTRODE_TYPE
                          FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG
                         /* WHERE QTY > 0 */
                      ) Y
                   ON ( 0 = 0
                        AND X.DIVISION_ID               = Y.DIVISION_ID          /* @v_batch_division_id  2021.10.25 튜닝개선요청에 따른 변경 */
                        AND X.PLAN_START_YYYYMMDD       = Y.PLAN_START_YYYYMMDD  /* @v_batch_PLAN_START_YYYYMMDD */
                        AND X.PLAN_TYPE                 = Y.PLAN_TYPE            /* @v_batch_PLAN_TYPE */
                        AND X.SEQ                       = Y.SEQ                  /* @v_batch_SEQ */
                        AND X.BIZ_TYPE                  = Y.BIZ_TYPE
                        AND X.PROJECT_CODE              = Y.PROJECT_CODE
                        AND X.ITEM_ID                   = Y.ITEM_ID
                        AND X.TO_SITE                   = Y.TO_SITE
                        AND X.INCOTERMS                 = Y.INCOTERMS
                        AND X.FROM_SITE                 = Y.FROM_SITE
                        AND X.BOD_ID                    = Y.BOD_ID
                        AND X.MEASURE                   = Y.MEASURE
                        AND X.YYYYMMDD                  = Y.YYYYMMDD )
                WHEN MATCHED THEN
                UPDATE
                   SET X.QTY               = Y.QTY
                     /* , X.CREATED_BY         = @p_USER_ID */
                     /* , X.CREATION_DATE      = GETDATE()  */
                     , X.LAST_UPDATED_BY  = V_BATCH_USER
                     , X.LAST_UPDATE_DATE = SYSDATE
                WHEN NOT MATCHED THEN
                  INSERT ( DIVISION_ID
                         , PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , SEQ
                         , BIZ_TYPE
                         , PROJECT_CODE
                         /* , CELL_ITEM_ID */
                         , ITEM_ID
                         , TO_SITE
                         , INCOTERMS
                         , FROM_SITE
                         , BOD_ID
                         /* , TRANSPORT_MODE */
                         , MEASURE
                         , YYYYMMDD
                         , QTY
                         , ORIGIN_FROM_DIVISION_ID
                         , ORIGIN_TO_DIVISION_ID
                         , ELECTRODE_TYPE
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                 VALUES ( Y.DIVISION_ID
                        , Y.PLAN_START_YYYYMMDD
                        , Y.PLAN_TYPE
                        , Y.SEQ
                        , Y.BIZ_TYPE
                        , Y.PROJECT_CODE
                        /* , Y.CELL_ITEM_ID */
                        , Y.ITEM_ID
                        , Y.TO_SITE
                        , Y.INCOTERMS
                        , Y.FROM_SITE
                        , Y.BOD_ID
                        /* , Y.TRANSPORT_MODE */
                        , Y.MEASURE
                        , Y.YYYYMMDD
                        , Y.QTY
                        , Y.ORIGIN_FROM_DIVISION_ID
                        , Y.ORIGIN_TO_DIVISION_ID
                        , Y.ELECTRODE_TYPE
                        , V_BATCH_USER
                        , SYSDATE
                        , V_BATCH_USER
                        , SYSDATE )
                        ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FG_H : History 입력 */
            /* ------------------------------------------------------------------------------------------- */
            /*  SELECT top 10 * FROM dbo.SCP_ANL_SHIPMENT_PLAN_FG_H WITH (NOLOCK)     -- HISTORY_SEQ */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H */

                      INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG_H
                           ( HISTORY_SEQ
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , BIZ_TYPE
                           , PROJECT_CODE
                           , ITEM_ID
                           , TO_SITE
                           , INCOTERMS
                           , FROM_SITE
                           , BOD_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , ORIGIN_TO_DIVISION_ID
                           , ORIGIN_FROM_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H.NEXTVAL
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , BIZ_TYPE
                           , PROJECT_CODE
                           , ITEM_ID
                           , TO_SITE
                           , INCOTERMS
                           , FROM_SITE
                           , BOD_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , ORIGIN_TO_DIVISION_ID
                           , ORIGIN_FROM_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_BATCH_USER   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_BATCH_USER   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG
                           ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(FG) */
            /* ------------------------------------------------------------------------------------------- */
                        /*  FIX UPDATE */
                        /*  MSSQL UPDATE X SET .. FROM SCP_ANL_SHIPMENT_PLAN_FIX X INNER JOIN #FG Y ON ..
                            -> 원천 다중매치가 가능하므로 상관 UPDATE + EXISTS + ROWNUM = 1 (CV-024) */
                        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
                           SET ( QTY
                               , FIX_REASON
                               , ATTRIBUTE1
                               , LAST_UPDATED_BY
                               , LAST_UPDATE_DATE ) =
                               ( SELECT Y.QTY
                                      , 'SIMULATION UPDATE'
                                      , 'Y'                    /* History 구분을 위해 */
                                      , V_BATCH_USER
                                      , SYSDATE
                                   FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
                                  WHERE 0 = 0
                                    AND X.DIVISION_ID = Y.DIVISION_ID
                                    AND X.BIZ_TYPE    = Y.BIZ_TYPE
                                    AND X.PROJECT_CODE= Y.PROJECT_CODE
                                    AND X.ITEM_ID     = Y.ITEM_ID
                                    AND X.TO_SITE     = Y.TO_SITE
                                    AND X.FROM_SITE   = Y.FROM_SITE
                                    AND X.BOD_ID      = Y.BOD_ID
                                    AND X.YYYYMMDD    = Y.YYYYMMDD
                                    AND ROWNUM        = 1 )
                         WHERE EXISTS ( SELECT 1
                                          FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
                                         WHERE 0 = 0
                                           AND X.DIVISION_ID = Y.DIVISION_ID
                                           AND X.BIZ_TYPE    = Y.BIZ_TYPE
                                           AND X.PROJECT_CODE= Y.PROJECT_CODE
                                           AND X.ITEM_ID     = Y.ITEM_ID
                                           AND X.TO_SITE     = Y.TO_SITE
                                           AND X.FROM_SITE   = Y.FROM_SITE
                                           AND X.BOD_ID      = Y.BOD_ID
                                           AND X.YYYYMMDD    = Y.YYYYMMDD );

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력 */
            /* ------------------------------------------------------------------------------------------- */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX_H   -- 현재 사용안함. */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H -- SCP_ANL_PRODUCTION_PLAN_FIX 대신 사용중임. */
            /*  SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H */


                      INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
                           ( HISTORY_SEQ
                           , FIX_ID
                           , DIVISION_ID
                           , BIZ_TYPE
                           , ITEM_ID
                           , TO_SITE
                           , FROM_SITE
                           , PROJECT_CODE
                           , INCOTERMS
                           , BOD_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                           , FIX_ID
                           , DIVISION_ID
                           , BIZ_TYPE
                           , ITEM_ID
                           , TO_SITE
                           , FROM_SITE
                           , PROJECT_CODE
                           , INCOTERMS
                           , BOD_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_BATCH_USER   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_BATCH_USER   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM SCP_ANL_SHIPMENT_PLAN_FIX
                       WHERE ATTRIBUTE1 = 'Y'
                           ;


                  /*  History 구분을 위해 원상복구 */
                  UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
                     SET X.ATTRIBUTE1 = NULL
                   WHERE EXISTS ( SELECT 1
                                    FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
                                   WHERE 0 = 0
                                     AND X.DIVISION_ID = Y.DIVISION_ID
                                     AND X.BIZ_TYPE    = Y.BIZ_TYPE
                                     AND X.PROJECT_CODE= Y.PROJECT_CODE
                                     AND X.ITEM_ID     = Y.ITEM_ID
                                     AND X.TO_SITE     = Y.TO_SITE
                                     AND X.FROM_SITE   = Y.FROM_SITE
                                     AND X.BOD_ID      = Y.BOD_ID
                                     AND X.YYYYMMDD    = Y.YYYYMMDD )
                     AND X.ATTRIBUTE1 = 'Y';

            END IF;


            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_SEMI UPDATE */
            /*  SEMI_SHIP_PLAN --> SCP_ANL_SHIPMENT_PLAN_SEMI.MEASURE 'SHIP_PLAN_AMEND' UPDATE */
            /* ------------------------------------------------------------------------------------------- */
            IF V_BATCH_MEASURE IN ('SEMI_SHIP_PLAN') THEN   /* SEMI */

            /*  SEMI_SHIP_PLAN */
              /*  IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL DROP TABLE #SCP_ANL_SHIPMENT_PLAN_SEMI */
              DELETE FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI;

              /* ▼ MSSQL 원본 L2575~L2589 원문 보존 (PJ2025F254 2025.11.17 변경전 SELECT 목록 원문 보존) ---------------------------------------------
                                  PJ2025F254 변경전 2025.11.17 ELECT X.DIVISION_ID, X.PLAN_START_YYYYMMDD, X.PLAN_TYPE, X.SEQ
                                  PJ2025F254 변경전 2025.11.17      ,X.OPERATION_GROUP
                               -- PJ2025F254 변경전 2025.11.17        ,X.CELL_ITEM_ID
                                  PJ2025F254 변경전 2025.11.17      ,X.ITEM_ID
                                  PJ2025F254 변경전 2025.11.17      ,X.FROM_SITE
                                  PJ2025F254 변경전 2025.11.17      ,X.BOD_ID
                                  PJ2025F254 변경전 2025.11.17      ,'SHIP_PLAN_AMEND' AS MEASURE
                                  PJ2025F254 변경전 2025.11.17      ,Y.YYYYMMDD AS YYYYMMDD
                                  PJ2025F254 변경전 2025.11.17      ,X.TO_SITE
                                  PJ2025F254 변경전 2025.11.17      ,X.QTY
                                  PJ2025F254 변경전 2025.11.17      ,'82' AS ORIGIN_FROM_DIVISION_ID
                                  PJ2025F254 변경전 2025.11.17      ,'82' AS ORIGIN_TO_DIVISION_ID
                                  PJ2025F254 변경전 2025.11.17      ,'' AS ELECTRODE_TYPE
                                  PJ2025F254 변경전 2025.11.17      ,X.ATTRIBUTE1
                                  PJ2025F254 변경전 2025.11.17      ,Y.YYYYMMDD_COLUMN */
                /* -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                -------------------------------------------------------------------------------------------------------------------------------------------------------
                print  convert(varchar(30), getdate(), 121) + N'PJ2025F254 : 임시테이블 컬럼 사이즈 지정'
                ------------------------------------------------------------------------------------------------------------------------------------------------------- */
              /*  MSSQL CONVERT(NVARCHAR(30), x) 는 SELECT INTO 로 만들어질 임시테이블의 컬럼폭을 지정하려는 것이다.
                  Oracle 은 미리 선언된 GTT 에 INSERT 하므로 폭은 GTT DDL 이 정한다. 다만 원본이 명시한 절단 의미까지
                  살리기 위해 CAST 대신 SUBSTR 로 옮긴다(CAST 는 초과 시 ORA-25137 로 실패, MSSQL CONVERT 는 조용히 절단). */
              INSERT INTO GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI
                   ( DIVISION_ID
                   , PLAN_START_YYYYMMDD
                   , PLAN_TYPE
                   , SEQ
                   , OPERATION_GROUP
                   , ITEM_ID
                   , FROM_SITE
                   , BOD_ID
                   , MEASURE
                   , YYYYMMDD
                   , TO_SITE
                   , QTY
                   , ORIGIN_FROM_DIVISION_ID
                   , ORIGIN_TO_DIVISION_ID
                   , ELECTRODE_TYPE
                   , ATTRIBUTE1
                   , YYYYMMDD_COLUMN )
            SELECT SUBSTR(X.DIVISION_ID, 1, 30)          AS DIVISION_ID
                 , X.PLAN_START_YYYYMMDD
                 , SUBSTR(X.PLAN_TYPE, 1, 30)            AS PLAN_TYPE
                 , X.SEQ                                 AS SEQ
                 , X.OPERATION_GROUP
                 /* , X.CELL_ITEM_ID */
                 , X.ITEM_ID
                 , SUBSTR(X.FROM_SITE, 1, 30)            AS FROM_SITE
                 , X.BOD_ID
                 , 'SHIP_PLAN_AMEND'                     AS MEASURE
                 , Y.YYYYMMDD                            AS YYYYMMDD
                 , X.TO_SITE
                 , X.QTY
                 , SUBSTR('82', 1, 30)                   AS ORIGIN_FROM_DIVISION_ID
                 , SUBSTR('82', 1, 30)                   AS ORIGIN_TO_DIVISION_ID
                 , SUBSTR('', 1, 30)                     AS ELECTRODE_TYPE
                 , X.ATTRIBUTE1
                 , Y.YYYYMMDD_COLUMN
                /* -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                ------------------------------------------------------------------------------------------------------------------------------------------------------- */
              FROM ( SELECT *
                       FROM SCP_XLS_PSI_GLOBAL_ESS
                      WHERE 0 = 0
                        AND DIVISION_ID          = V_BATCH_DIVISION_ID
                        AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                        AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                        AND SEQ                  = V_BATCH_SEQ
                        AND XLS_KEY1             = V_BATCH_XLS_KEY1   /* 43 */
                   )
                   UNPIVOT ( QTY FOR YYYYMMDD_COLUMN IN (
                                         QTY001 AS 'QTY001', QTY002 AS 'QTY002', QTY003 AS 'QTY003', QTY004 AS 'QTY004', QTY005 AS 'QTY005'
                                       , QTY006 AS 'QTY006', QTY007 AS 'QTY007', QTY008 AS 'QTY008', QTY009 AS 'QTY009', QTY010 AS 'QTY010'
                                       , QTY011 AS 'QTY011', QTY012 AS 'QTY012', QTY013 AS 'QTY013', QTY014 AS 'QTY014', QTY015 AS 'QTY015'
                                       , QTY016 AS 'QTY016', QTY017 AS 'QTY017', QTY018 AS 'QTY018', QTY019 AS 'QTY019', QTY020 AS 'QTY020'
                                       , QTY021 AS 'QTY021', QTY022 AS 'QTY022', QTY023 AS 'QTY023', QTY024 AS 'QTY024', QTY025 AS 'QTY025'
                                       , QTY026 AS 'QTY026', QTY027 AS 'QTY027', QTY028 AS 'QTY028', QTY029 AS 'QTY029', QTY030 AS 'QTY030'
                                       , QTY031 AS 'QTY031', QTY032 AS 'QTY032', QTY033 AS 'QTY033', QTY034 AS 'QTY034', QTY035 AS 'QTY035'
                                       , QTY036 AS 'QTY036', QTY037 AS 'QTY037', QTY038 AS 'QTY038', QTY039 AS 'QTY039', QTY040 AS 'QTY040'
                                       , QTY041 AS 'QTY041', QTY042 AS 'QTY042', QTY043 AS 'QTY043', QTY044 AS 'QTY044', QTY045 AS 'QTY045'
                                       , QTY046 AS 'QTY046', QTY047 AS 'QTY047', QTY048 AS 'QTY048', QTY049 AS 'QTY049', QTY050 AS 'QTY050'
                                       , QTY051 AS 'QTY051', QTY052 AS 'QTY052', QTY053 AS 'QTY053', QTY054 AS 'QTY054', QTY055 AS 'QTY055'
                                       , QTY056 AS 'QTY056', QTY057 AS 'QTY057', QTY058 AS 'QTY058', QTY059 AS 'QTY059', QTY060 AS 'QTY060'
                                       , QTY061 AS 'QTY061', QTY062 AS 'QTY062', QTY063 AS 'QTY063', QTY064 AS 'QTY064', QTY065 AS 'QTY065'
                                       , QTY066 AS 'QTY066', QTY067 AS 'QTY067', QTY068 AS 'QTY068', QTY069 AS 'QTY069', QTY070 AS 'QTY070'
                                       , QTY071 AS 'QTY071', QTY072 AS 'QTY072', QTY073 AS 'QTY073', QTY074 AS 'QTY074', QTY075 AS 'QTY075'
                                       , QTY076 AS 'QTY076', QTY077 AS 'QTY077', QTY078 AS 'QTY078', QTY079 AS 'QTY079', QTY080 AS 'QTY080'
                                       , QTY081 AS 'QTY081', QTY082 AS 'QTY082', QTY083 AS 'QTY083', QTY084 AS 'QTY084', QTY085 AS 'QTY085'
                                       , QTY086 AS 'QTY086', QTY087 AS 'QTY087', QTY088 AS 'QTY088', QTY089 AS 'QTY089', QTY090 AS 'QTY090'
                                       , QTY091 AS 'QTY091', QTY092 AS 'QTY092', QTY093 AS 'QTY093', QTY094 AS 'QTY094', QTY095 AS 'QTY095'
                                       , QTY096 AS 'QTY096', QTY097 AS 'QTY097', QTY098 AS 'QTY098', QTY099 AS 'QTY099', QTY100 AS 'QTY100'
                                       , QTY101 AS 'QTY101', QTY102 AS 'QTY102', QTY103 AS 'QTY103', QTY104 AS 'QTY104', QTY105 AS 'QTY105'
                                       , QTY106 AS 'QTY106', QTY107 AS 'QTY107', QTY108 AS 'QTY108', QTY109 AS 'QTY109', QTY110 AS 'QTY110'
                                       , QTY111 AS 'QTY111', QTY112 AS 'QTY112', QTY113 AS 'QTY113', QTY114 AS 'QTY114', QTY115 AS 'QTY115'
                                       , QTY116 AS 'QTY116', QTY117 AS 'QTY117', QTY118 AS 'QTY118', QTY119 AS 'QTY119', QTY120 AS 'QTY120'
                                       , QTY121 AS 'QTY121', QTY122 AS 'QTY122', QTY123 AS 'QTY123', QTY124 AS 'QTY124', QTY125 AS 'QTY125'
                                       , QTY126 AS 'QTY126', QTY127 AS 'QTY127', QTY128 AS 'QTY128', QTY129 AS 'QTY129', QTY130 AS 'QTY130'
                                       , QTY131 AS 'QTY131', QTY132 AS 'QTY132', QTY133 AS 'QTY133', QTY134 AS 'QTY134', QTY135 AS 'QTY135'
                                       , QTY136 AS 'QTY136', QTY137 AS 'QTY137', QTY138 AS 'QTY138', QTY139 AS 'QTY139', QTY140 AS 'QTY140'
                                       , QTY141 AS 'QTY141', QTY142 AS 'QTY142', QTY143 AS 'QTY143', QTY144 AS 'QTY144', QTY145 AS 'QTY145'
                                       , QTY146 AS 'QTY146', QTY147 AS 'QTY147', QTY148 AS 'QTY148', QTY149 AS 'QTY149', QTY150 AS 'QTY150'
                                       , QTY151 AS 'QTY151', QTY152 AS 'QTY152', QTY153 AS 'QTY153', QTY154 AS 'QTY154', QTY155 AS 'QTY155'
                                       , QTY156 AS 'QTY156', QTY157 AS 'QTY157', QTY158 AS 'QTY158', QTY159 AS 'QTY159', QTY160 AS 'QTY160'
                                       , QTY161 AS 'QTY161', QTY162 AS 'QTY162', QTY163 AS 'QTY163', QTY164 AS 'QTY164', QTY165 AS 'QTY165'
                                       , QTY166 AS 'QTY166', QTY167 AS 'QTY167', QTY168 AS 'QTY168', QTY169 AS 'QTY169', QTY170 AS 'QTY170'
                                       , QTY171 AS 'QTY171', QTY172 AS 'QTY172', QTY173 AS 'QTY173', QTY174 AS 'QTY174', QTY175 AS 'QTY175'
                                       , QTY176 AS 'QTY176', QTY177 AS 'QTY177', QTY178 AS 'QTY178', QTY179 AS 'QTY179', QTY180 AS 'QTY180'
                                       , QTY181 AS 'QTY181', QTY182 AS 'QTY182', QTY183 AS 'QTY183', QTY184 AS 'QTY184', QTY185 AS 'QTY185'
                                       , QTY186 AS 'QTY186', QTY187 AS 'QTY187', QTY188 AS 'QTY188', QTY189 AS 'QTY189', QTY190 AS 'QTY190'
                                       , QTY191 AS 'QTY191', QTY192 AS 'QTY192', QTY193 AS 'QTY193', QTY194 AS 'QTY194', QTY195 AS 'QTY195'
                                       , QTY196 AS 'QTY196', QTY197 AS 'QTY197', QTY198 AS 'QTY198', QTY199 AS 'QTY199', QTY200 AS 'QTY200'
                                       , QTY201 AS 'QTY201', QTY202 AS 'QTY202', QTY203 AS 'QTY203', QTY204 AS 'QTY204', QTY205 AS 'QTY205'
                                       , QTY206 AS 'QTY206', QTY207 AS 'QTY207', QTY208 AS 'QTY208', QTY209 AS 'QTY209', QTY210 AS 'QTY210'
                                       , QTY211 AS 'QTY211', QTY212 AS 'QTY212', QTY213 AS 'QTY213', QTY214 AS 'QTY214', QTY215 AS 'QTY215'
                                       , QTY216 AS 'QTY216', QTY217 AS 'QTY217', QTY218 AS 'QTY218', QTY219 AS 'QTY219', QTY220 AS 'QTY220'
                                       , QTY221 AS 'QTY221', QTY222 AS 'QTY222', QTY223 AS 'QTY223', QTY224 AS 'QTY224', QTY225 AS 'QTY225'
                                       , QTY226 AS 'QTY226', QTY227 AS 'QTY227', QTY228 AS 'QTY228', QTY229 AS 'QTY229', QTY230 AS 'QTY230'
                                       , QTY231 AS 'QTY231', QTY232 AS 'QTY232', QTY233 AS 'QTY233', QTY234 AS 'QTY234', QTY235 AS 'QTY235'
                                       , QTY236 AS 'QTY236', QTY237 AS 'QTY237', QTY238 AS 'QTY238', QTY239 AS 'QTY239', QTY240 AS 'QTY240'
                                       , QTY241 AS 'QTY241', QTY242 AS 'QTY242', QTY243 AS 'QTY243', QTY244 AS 'QTY244', QTY245 AS 'QTY245'
                                       , QTY246 AS 'QTY246', QTY247 AS 'QTY247', QTY248 AS 'QTY248', QTY249 AS 'QTY249', QTY250 AS 'QTY250'
                                       , QTY251 AS 'QTY251', QTY252 AS 'QTY252', QTY253 AS 'QTY253', QTY254 AS 'QTY254', QTY255 AS 'QTY255'
                                       , QTY256 AS 'QTY256', QTY257 AS 'QTY257', QTY258 AS 'QTY258', QTY259 AS 'QTY259', QTY260 AS 'QTY260'
                                       , QTY261 AS 'QTY261', QTY262 AS 'QTY262', QTY263 AS 'QTY263', QTY264 AS 'QTY264', QTY265 AS 'QTY265'
                                       , QTY266 AS 'QTY266', QTY267 AS 'QTY267', QTY268 AS 'QTY268', QTY269 AS 'QTY269', QTY270 AS 'QTY270'
                                       , QTY271 AS 'QTY271', QTY272 AS 'QTY272', QTY273 AS 'QTY273', QTY274 AS 'QTY274', QTY275 AS 'QTY275'
                                       , QTY276 AS 'QTY276', QTY277 AS 'QTY277', QTY278 AS 'QTY278', QTY279 AS 'QTY279', QTY280 AS 'QTY280'
                                       , QTY281 AS 'QTY281', QTY282 AS 'QTY282', QTY283 AS 'QTY283', QTY284 AS 'QTY284', QTY285 AS 'QTY285'
                                       , QTY286 AS 'QTY286', QTY287 AS 'QTY287', QTY288 AS 'QTY288', QTY289 AS 'QTY289', QTY290 AS 'QTY290'
                                       , QTY291 AS 'QTY291', QTY292 AS 'QTY292', QTY293 AS 'QTY293', QTY294 AS 'QTY294', QTY295 AS 'QTY295'
                                       , QTY296 AS 'QTY296', QTY297 AS 'QTY297', QTY298 AS 'QTY298', QTY299 AS 'QTY299', QTY300 AS 'QTY300'
                                       , QTY301 AS 'QTY301', QTY302 AS 'QTY302', QTY303 AS 'QTY303', QTY304 AS 'QTY304', QTY305 AS 'QTY305'
                                       , QTY306 AS 'QTY306', QTY307 AS 'QTY307', QTY308 AS 'QTY308', QTY309 AS 'QTY309', QTY310 AS 'QTY310'
                                       , QTY311 AS 'QTY311', QTY312 AS 'QTY312', QTY313 AS 'QTY313', QTY314 AS 'QTY314', QTY315 AS 'QTY315'
                                       , QTY316 AS 'QTY316', QTY317 AS 'QTY317', QTY318 AS 'QTY318', QTY319 AS 'QTY319', QTY320 AS 'QTY320'
                                       , QTY321 AS 'QTY321', QTY322 AS 'QTY322', QTY323 AS 'QTY323', QTY324 AS 'QTY324', QTY325 AS 'QTY325'
                                       , QTY326 AS 'QTY326', QTY327 AS 'QTY327', QTY328 AS 'QTY328', QTY329 AS 'QTY329', QTY330 AS 'QTY330'
                                       , QTY331 AS 'QTY331', QTY332 AS 'QTY332', QTY333 AS 'QTY333', QTY334 AS 'QTY334', QTY335 AS 'QTY335'
                                       , QTY336 AS 'QTY336', QTY337 AS 'QTY337', QTY338 AS 'QTY338', QTY339 AS 'QTY339', QTY340 AS 'QTY340'
                                       , QTY341 AS 'QTY341', QTY342 AS 'QTY342', QTY343 AS 'QTY343', QTY344 AS 'QTY344', QTY345 AS 'QTY345'
                                       , QTY346 AS 'QTY346', QTY347 AS 'QTY347', QTY348 AS 'QTY348', QTY349 AS 'QTY349', QTY350 AS 'QTY350'
                                       , QTY351 AS 'QTY351', QTY352 AS 'QTY352', QTY353 AS 'QTY353', QTY354 AS 'QTY354', QTY355 AS 'QTY355'
                                       , QTY356 AS 'QTY356', QTY357 AS 'QTY357', QTY358 AS 'QTY358', QTY359 AS 'QTY359', QTY360 AS 'QTY360'
                                       , QTY361 AS 'QTY361', QTY362 AS 'QTY362', QTY363 AS 'QTY363', QTY364 AS 'QTY364'
                                         )
                           ) X
                 , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                  , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                         AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
                              /* WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                                   AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd */
                            ) Y
             WHERE X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
              /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start */
               AND Y.YYYYMMDD          >= V_BOD_FROM
               AND Y.YYYYMMDD          <= V_BOD_TO
              /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end */
                 ;

                /* ------------------------------------------------------------------------------------------- */
                /*  FROZEN 구간 UPDATE */
                /*  PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다. */
                /* ------------------------------------------------------------------------------------------- */
                /* ▼ MSSQL 원본 L2691~L2700 원문 보존 (SEMI FROZEN 삭제 死코드(06_S 에서는 주석 처리되어 있다 - 07 과 다름)) ---------------------------------------------
                                   IF @v_batch_plan_type IN  ('PR','MA','SE')
                                   BEGIN
                                     DELETE  FROM #SCP_ANL_SHIPMENT_PLAN_SEMI
                                             FROM #SCP_ANL_SHIPMENT_PLAN_SEMI X
                                           INNER JOIN #SCM_MST_SITE Y
                                              ON Y.DIVISION_ID = X.DIVISION_ID
                                             AND Y.SCM_SITE_ID = X.FROM_SITE
                                           WHERE
                                               X.YYYYMMDD < Y.SHIP_FROZEN_WEEK_DAY;
                                   END */

                /* -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                ------------------------------------------------------------------------------------------------------------
                print  convert(varchar(30), getdate(), 121) + N' BOD 및 BOD ITEM 정보'
                ------------------------------------------------------------------------------------------------------------------ */
                /*  IF OBJECT_ID('TEMPDB..#BOD_ITEM') IS NOT NULL DROP TABLE #BOD_ITEM */
                DELETE FROM GT_XPGT_BOD_ITEM;

                /*  MSSQL EXISTS (SELECT TOP 1 'X' FROM ..) -> Oracle EXISTS (SELECT 'X' FROM ..) (TOP 1 은 무의미).
                    CONVERT(NVARCHAR(8), DATEADD(DAY, -7, GETDATE()), 112) -> TO_CHAR(SYSDATE - 7, 'YYYYMMDD') */
                INSERT INTO GT_XPGT_BOD_ITEM
                     ( DIVISION_ID
                     , FROM_SITE
                     , TO_SITE
                     , INCOTERMS
                     , ITEM_ID
                     , BOD_ID
                     , RN )
                WITH BOD_ITEM AS (
                    SELECT BD.DIVISION_ID
                         , BD.FROM_SITE
                         , BD.TO_SITE
                         , BD.INCOTERMS
                         , BI.ITEM_ID
                         , BD.BOD_ID
                         , ROW_NUMBER() OVER (PARTITION BY BD.DIVISION_ID
                                                         , BD.FROM_SITE
                                                         , BD.TO_SITE
                                                         , BD.INCOTERMS
                                                         , BI.ITEM_ID
                                                 ORDER BY BD.PRIORITY
                                                         , BI.PRIORITY
                                                         , BD.ATTRIBUTE3 DESC
                                                         , BD.LAST_UPDATE_DATE DESC ) AS RN
                      FROM SCP_MST_BOD BD
                           INNER JOIN SCP_MST_BOD_ITEM BI
                                   ON BI.BOD_ID      = BD.BOD_ID
                                  AND BI.VALID_YN    = 'Y'
                                  AND BI.TO_YYYYMMDD >= TO_CHAR(SYSDATE - 7, 'YYYYMMDD')
                     WHERE 1 = 1
                       AND BD.ATTRIBUTE3 > TO_CHAR(SYSDATE - 7, 'YYYYMMDD')
                       AND BD.VALID_YN   = 'Y'
                       AND EXISTS ( SELECT 1
                                      FROM GT_XPGT_JV_ESS_SCM_SITE_MAP SM
                                     WHERE SM.RP_DIVISION_ID = BD.DIVISION_ID
                                       AND SM.RP_SCM_SITE_ID = BD.FROM_SITE )
                )
                SELECT DIVISION_ID
                     , FROM_SITE
                     , TO_SITE
                     , INCOTERMS
                     , ITEM_ID
                     , BOD_ID
                     , RN
                  FROM BOD_ITEM
                 WHERE RN = 1 ;
                /* -------------------------------------------------------------------------------------------------------------------------------------------------------
                print  convert(varchar(30), getdate(), 121) + N'PJ2025F254 : ESS 가상 라인에 매핑된 JV라인 SEMI 출하계획 추가'
                ------------------------------------------------------------------------------------------------------------------------------------------------------- */
                /*  ★자기 자신(GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI)을 읽어 자기 자신에 INSERT 하는 구문이다.
                    Oracle 은 INSERT .. SELECT 의 원천 스냅샷이 문장 시작시점으로 고정되므로 MSSQL 과 동일하게 동작한다. */
                INSERT INTO GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI
                     ( DIVISION_ID
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , SEQ
                     , OPERATION_GROUP
                     , ITEM_ID
                     , FROM_SITE
                     , BOD_ID
                     , MEASURE
                     , YYYYMMDD
                     , TO_SITE
                     , QTY
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , ELECTRODE_TYPE
                     , ATTRIBUTE1
                     , YYYYMMDD_COLUMN )
                SELECT SM.RP_DIVISION_ID                        AS DIVISION_ID
                     , PV.PLAN_START_YYYYMMDD
                     , PV.PLAN_TYPE
                     , PV.PLAN_SEQ                              AS SEQ
                     , SP.OPERATION_GROUP
                     , SP.ITEM_ID
                     , SM.RP_SCM_SITE_ID                        AS FROM_SITE
                     , NVL(NVL(BI.BOD_ID, SP.BOD_ID), '-')      AS P_BOD_ID   /* 2025.12.23 bod_id 매핑이 안되는 경우 ESS가상 사이트 기준 BOD_ID 유지 */
                     , SP.MEASURE
                     , SP.YYYYMMDD
                     , SP.TO_SITE
                     , SP.QTY
                     , SM.RP_DIVISION_ID                        AS ORIGIN_FROM_DIVISION_ID
                     , SM.RP_DIVISION_ID                        AS ORIGIN_TO_DIVISION_ID   /* 2025.12.16 division_id와 같은 값으로 */
                     , SP.ELECTRODE_TYPE
                     , SP.ATTRIBUTE1
                     , SP.YYYYMMDD_COLUMN
                  FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI SP
                       INNER JOIN GT_XPGT_JV_ESS_SCM_SITE_MAP SM
                               ON SM.VP_DIVISION_ID  = SP.DIVISION_ID
                              AND SM.VP_SCM_SITE_ID  = SP.FROM_SITE
                       INNER JOIN GT_XPGT_DIVISION_LAST_PLAN_INFO PV   /* JV Real Division */
                               ON PV.DIVISION_ID         = SM.RP_DIVISION_ID
                              AND PV.PLAN_START_YYYYMMDD = SP.PLAN_START_YYYYMMDD
                       LEFT  JOIN SCP_MST_BOD BO
                               ON BO.BOD_ID = SP.BOD_ID
                       LEFT  JOIN GT_XPGT_BOD_ITEM BI
                               ON BI.DIVISION_ID = SM.RP_DIVISION_ID
                              AND BI.FROM_SITE   = SM.RP_SCM_SITE_ID
                              AND BI.TO_SITE     = SP.TO_SITE
                              AND BI.INCOTERMS   = BO.INCOTERMS
                              AND BI.ITEM_ID     = SP.ITEM_ID
                 WHERE 1 = 1
                     ;
                /* -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                ------------------------------------------------------------------------------------------------------------------------------------------------------- */

               MERGE INTO SCP_ANL_SHIPMENT_PLAN_SEMI X
                USING ( SELECT DIVISION_ID
                             , PLAN_START_YYYYMMDD
                             , PLAN_TYPE
                             , SEQ
                             , OPERATION_GROUP
                             /* , CELL_ITEM_ID */
                             , ITEM_ID
                             , FROM_SITE
                             , BOD_ID
                             , MEASURE
                             , YYYYMMDD
                             , TO_SITE
                             , QTY
                             , ORIGIN_FROM_DIVISION_ID
                             , ORIGIN_TO_DIVISION_ID
                             , ELECTRODE_TYPE
                          FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI
                         /* WHERE QTY > 0 */
                      ) Y
                   ON ( 0 = 0
                        AND X.DIVISION_ID         = Y.DIVISION_ID          /* @v_batch_division_id  2021.10.25 튜닝개선요청에 따른 변경 */
                        AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD  /* @v_batch_PLAN_START_YYYYMMDD */
                        AND X.PLAN_TYPE           = Y.PLAN_TYPE            /* @v_batch_PLAN_TYPE */
                        AND X.SEQ                 = Y.SEQ                  /* @v_batch_SEQ */
                        AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                        AND X.ITEM_ID             = Y.ITEM_ID
                        AND X.FROM_SITE           = Y.FROM_SITE
                        AND X.BOD_ID              = Y.BOD_ID
                        AND X.MEASURE             = Y.MEASURE
                        AND X.YYYYMMDD            = Y.YYYYMMDD
                        AND X.TO_SITE             = Y.TO_SITE )
                WHEN MATCHED THEN
                UPDATE
                   SET X.QTY               = Y.QTY
                     /* , X.CREATED_BY         = @p_USER_ID */
                     /* , X.CREATION_DATE      = GETDATE()  */
                     , X.LAST_UPDATED_BY  = V_BATCH_USER
                     , X.LAST_UPDATE_DATE = SYSDATE
                WHEN NOT MATCHED THEN
                  INSERT ( DIVISION_ID
                         , PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , SEQ
                         , OPERATION_GROUP
                         , ITEM_ID
                         , FROM_SITE
                         , BOD_ID
                         , MEASURE
                         , YYYYMMDD
                         , TO_SITE
                         , QTY
                         , ORIGIN_FROM_DIVISION_ID
                         , ORIGIN_TO_DIVISION_ID
                         , ELECTRODE_TYPE
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                 VALUES ( Y.DIVISION_ID
                        , Y.PLAN_START_YYYYMMDD
                        , Y.PLAN_TYPE
                        , Y.SEQ
                        , Y.OPERATION_GROUP
                        , Y.ITEM_ID
                        , Y.FROM_SITE
                        , Y.BOD_ID
                        , Y.MEASURE
                        , Y.YYYYMMDD
                        , Y.TO_SITE
                        , Y.QTY
                        , Y.ORIGIN_FROM_DIVISION_ID
                        , Y.ORIGIN_TO_DIVISION_ID
                        , Y.ELECTRODE_TYPE
                        , V_BATCH_USER
                        , SYSDATE
                        , V_BATCH_USER
                        , SYSDATE )
                        ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_SEMI_H : History 입력(SEMI) */
            /* ------------------------------------------------------------------------------------------- */
                      INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI_H
                           ( HISTORY_SEQ
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , OPERATION_GROUP
                           , ITEM_ID
                           , FROM_SITE
                           , TO_SITE
                           , BOD_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , UPDATE_REASON_BOD
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H.NEXTVAL
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , OPERATION_GROUP
                           , ITEM_ID
                           , FROM_SITE
                           , TO_SITE
                           , BOD_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , NULL          AS UPDATE_REASON_BOD
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_BATCH_USER   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_BATCH_USER   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI
                           ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(SEMI) */
            /* ------------------------------------------------------------------------------------------- */
                        /*  FIX UPDATE */
                        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
                           SET ( QTY
                               , FIX_REASON
                               , ATTRIBUTE1 ) =
                               ( SELECT Y.QTY
                                      , 'SIMULATION UPDATE'
                                      , 'Y'                    /* History 구분을 위해 */
                                   FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
                                  WHERE 0 = 0
                                    AND X.DIVISION_ID = Y.DIVISION_ID
                                    AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                                    AND X.ITEM_ID     = Y.ITEM_ID
                                    AND X.TO_SITE     = Y.TO_SITE
                                    AND X.FROM_SITE   = Y.FROM_SITE
                                    AND X.BOD_ID      = Y.BOD_ID
                                    AND X.YYYYMMDD    = Y.YYYYMMDD
                                    AND ROWNUM        = 1 )
                         WHERE EXISTS ( SELECT 1
                                          FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
                                         WHERE 0 = 0
                                           AND X.DIVISION_ID = Y.DIVISION_ID
                                           AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                                           AND X.ITEM_ID     = Y.ITEM_ID
                                           AND X.TO_SITE     = Y.TO_SITE
                                           AND X.FROM_SITE   = Y.FROM_SITE
                                           AND X.BOD_ID      = Y.BOD_ID
                                           AND X.YYYYMMDD    = Y.YYYYMMDD );

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력(SEMI) */
            /* ------------------------------------------------------------------------------------------- */


                      INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
                           ( HISTORY_SEQ
                           , FIX_ID
                           , DIVISION_ID
                           , BIZ_TYPE
                           , ITEM_ID
                           , TO_SITE
                           , FROM_SITE
                           , PROJECT_CODE
                           , INCOTERMS
                           , BOD_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                           , FIX_ID
                           , DIVISION_ID
                           , BIZ_TYPE
                           , ITEM_ID
                           , TO_SITE
                           , FROM_SITE
                           , PROJECT_CODE
                           , INCOTERMS
                           , BOD_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_BATCH_USER   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_BATCH_USER   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM SCP_ANL_SHIPMENT_PLAN_FIX
                       WHERE ATTRIBUTE1 = 'Y'
                           ;


                  /*  History 구분을 위해 원상복구 */
                  UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
                     SET X.ATTRIBUTE1 = NULL
                   WHERE EXISTS ( SELECT 1
                                    FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
                                   WHERE 0 = 0
                                     AND X.DIVISION_ID = Y.DIVISION_ID
                                     AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                                     AND X.ITEM_ID     = Y.ITEM_ID
                                     AND X.TO_SITE     = Y.TO_SITE
                                     AND X.FROM_SITE   = Y.FROM_SITE
                                     AND X.BOD_ID      = Y.BOD_ID
                                     AND X.YYYYMMDD    = Y.YYYYMMDD )
                     AND X.ATTRIBUTE1 = 'Y';

            END IF;


            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN UPDATE */
            /*  CELL_PROD,PACK_PROD  --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND' UPDATE */
            /* ------------------------------------------------------------------------------------------- */
            IF V_BATCH_MEASURE IN ('PACK_PROD', 'CELL_PROD') THEN

               /*  IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL DROP TABLE #SCP_ANL_PRODUCTION_PLAN */
               DELETE FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN;

               /* ▼ MSSQL 원본 L3088~L3100 원문 보존 (PJ2025F254 2025.11.17 변경전 SELECT 목록 원문 보존) ---------------------------------------------
                                  PJ2025F254 2025.11.17 변경전 SELECT X.DIVISION_ID, X.PLAN_START_YYYYMMDD, X.PLAN_TYPE, X.SEQ
                                  PJ2025F254 2025.11.17 변경전       ,X.OPERATION_GROUP
                                  PJ2025F254 2025.11.17 변경전       ,X.FROM_SITE AS SCM_SITE_ID
                                  PJ2025F254 2025.11.17 변경전       ,X.ITEM_ID
                                  PJ2025F254 2025.11.17 변경전       ,X.PROD_LINE AS LINE_ID
                                  PJ2025F254 2025.11.17 변경전       ,ISNULL(X.ATTRIBUTE9,'') AS OPERATION_ID
                                  PJ2025F254 2025.11.17 변경전       ,'PROD_PLAN_AMEND' AS MEASURE
                                  PJ2025F254 2025.11.17 변경전       ,Y.YYYYMMDD AS YYYYMMDD
                                  PJ2025F254 2025.11.17 변경전       ,X.QTY
                                  PJ2025F254 2025.11.17 변경전       ,X.DIVISION_ID AS ORIGIN_DIVISION_ID
                                  PJ2025F254 2025.11.17 변경전       ,'' AS ELECTRODE_TYPE
                                  PJ2025F254 2025.11.17 변경전       ,CELL_QTY_PACK AS CELL_QTY
                                  PJ2025F254 2025.11.17 변경전       ,Y.YYYYMMDD_COLUMN */
            /* ------------------------------------------------------------------------------------------------------------------------------
            --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
            -------------------------------------------------------------------------------------------------------------------------------------------------------
            print  convert(varchar(30), getdate(), 121) + N'PJ2025F254 : 생산계획 임시 테이블 컬럼 사이즈 지정 '
            ------------------------------------------------------------------------------------------------------------------------------------------------------- */
               /*  MSSQL ISNULL(X.ATTRIBUTE9,'') 은 적재처 SCP_ANL_PRODUCTION_PLAN.OPERATION_ID(NOT NULL) 로 들어간다.
                   CONVERT(NVARCHAR(30), x) 는 임시테이블 컬럼폭 지정 목적이라 SUBSTR 로 옮긴다(위 SEMI 와 동일). */
               INSERT INTO GT_XPGT_SCP_ANL_PRODUCTION_PLAN
                    ( DIVISION_ID
                    , PLAN_START_YYYYMMDD
                    , PLAN_TYPE
                    , SEQ
                    , OPERATION_GROUP
                    , SCM_SITE_ID
                    , ITEM_ID
                    , LINE_ID
                    , OPERATION_ID
                    , MEASURE
                    , YYYYMMDD
                    , QTY
                    , ORIGIN_DIVISION_ID
                    , ELECTRODE_TYPE
                    , CELL_QTY
                    , YYYYMMDD_COLUMN )
            SELECT SUBSTR(X.DIVISION_ID, 1, 30)                    AS DIVISION_ID
                 , X.PLAN_START_YYYYMMDD
                 , SUBSTR(X.PLAN_TYPE, 1, 30)                      AS PLAN_TYPE
                 , X.SEQ                                           AS SEQ
                 , X.OPERATION_GROUP
                 /* , X.CELL_ITEM_ID */
                 , SUBSTR(X.FROM_SITE, 1, 30)                      AS SCM_SITE_ID
                 , X.ITEM_ID
                 , SUBSTR(X.PROD_LINE, 1, 30)                      AS LINE_ID
                 , SUBSTR(NVL(X.ATTRIBUTE9, '-'), 1, 30)           AS OPERATION_ID
                 , 'PROD_PLAN_AMEND'                               AS MEASURE
                 , Y.YYYYMMDD                                      AS YYYYMMDD
                 , X.QTY
                 , SUBSTR(X.DIVISION_ID, 1, 30)                    AS ORIGIN_DIVISION_ID
                 , SUBSTR('', 1, 30)                               AS ELECTRODE_TYPE
                 , X.CELL_QTY_PACK                                 AS CELL_QTY
                 , Y.YYYYMMDD_COLUMN
            /* ------------------------------------------------------------------------------------------------------------------------------
            --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
            ------------------------------------------------------------------------------------------------------------------------------------------------------- */
              FROM ( SELECT *
                       FROM SCP_XLS_PSI_GLOBAL_ESS
                      WHERE 0 = 0
                        AND DIVISION_ID          = V_BATCH_DIVISION_ID
                        AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                        AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                        AND SEQ                  = V_BATCH_SEQ
                        AND XLS_KEY1             = V_BATCH_XLS_KEY1   /* 43 */
                   )
                   UNPIVOT ( QTY FOR YYYYMMDD_COLUMN IN (
                                         QTY001 AS 'QTY001', QTY002 AS 'QTY002', QTY003 AS 'QTY003', QTY004 AS 'QTY004', QTY005 AS 'QTY005'
                                       , QTY006 AS 'QTY006', QTY007 AS 'QTY007', QTY008 AS 'QTY008', QTY009 AS 'QTY009', QTY010 AS 'QTY010'
                                       , QTY011 AS 'QTY011', QTY012 AS 'QTY012', QTY013 AS 'QTY013', QTY014 AS 'QTY014', QTY015 AS 'QTY015'
                                       , QTY016 AS 'QTY016', QTY017 AS 'QTY017', QTY018 AS 'QTY018', QTY019 AS 'QTY019', QTY020 AS 'QTY020'
                                       , QTY021 AS 'QTY021', QTY022 AS 'QTY022', QTY023 AS 'QTY023', QTY024 AS 'QTY024', QTY025 AS 'QTY025'
                                       , QTY026 AS 'QTY026', QTY027 AS 'QTY027', QTY028 AS 'QTY028', QTY029 AS 'QTY029', QTY030 AS 'QTY030'
                                       , QTY031 AS 'QTY031', QTY032 AS 'QTY032', QTY033 AS 'QTY033', QTY034 AS 'QTY034', QTY035 AS 'QTY035'
                                       , QTY036 AS 'QTY036', QTY037 AS 'QTY037', QTY038 AS 'QTY038', QTY039 AS 'QTY039', QTY040 AS 'QTY040'
                                       , QTY041 AS 'QTY041', QTY042 AS 'QTY042', QTY043 AS 'QTY043', QTY044 AS 'QTY044', QTY045 AS 'QTY045'
                                       , QTY046 AS 'QTY046', QTY047 AS 'QTY047', QTY048 AS 'QTY048', QTY049 AS 'QTY049', QTY050 AS 'QTY050'
                                       , QTY051 AS 'QTY051', QTY052 AS 'QTY052', QTY053 AS 'QTY053', QTY054 AS 'QTY054', QTY055 AS 'QTY055'
                                       , QTY056 AS 'QTY056', QTY057 AS 'QTY057', QTY058 AS 'QTY058', QTY059 AS 'QTY059', QTY060 AS 'QTY060'
                                       , QTY061 AS 'QTY061', QTY062 AS 'QTY062', QTY063 AS 'QTY063', QTY064 AS 'QTY064', QTY065 AS 'QTY065'
                                       , QTY066 AS 'QTY066', QTY067 AS 'QTY067', QTY068 AS 'QTY068', QTY069 AS 'QTY069', QTY070 AS 'QTY070'
                                       , QTY071 AS 'QTY071', QTY072 AS 'QTY072', QTY073 AS 'QTY073', QTY074 AS 'QTY074', QTY075 AS 'QTY075'
                                       , QTY076 AS 'QTY076', QTY077 AS 'QTY077', QTY078 AS 'QTY078', QTY079 AS 'QTY079', QTY080 AS 'QTY080'
                                       , QTY081 AS 'QTY081', QTY082 AS 'QTY082', QTY083 AS 'QTY083', QTY084 AS 'QTY084', QTY085 AS 'QTY085'
                                       , QTY086 AS 'QTY086', QTY087 AS 'QTY087', QTY088 AS 'QTY088', QTY089 AS 'QTY089', QTY090 AS 'QTY090'
                                       , QTY091 AS 'QTY091', QTY092 AS 'QTY092', QTY093 AS 'QTY093', QTY094 AS 'QTY094', QTY095 AS 'QTY095'
                                       , QTY096 AS 'QTY096', QTY097 AS 'QTY097', QTY098 AS 'QTY098', QTY099 AS 'QTY099', QTY100 AS 'QTY100'
                                       , QTY101 AS 'QTY101', QTY102 AS 'QTY102', QTY103 AS 'QTY103', QTY104 AS 'QTY104', QTY105 AS 'QTY105'
                                       , QTY106 AS 'QTY106', QTY107 AS 'QTY107', QTY108 AS 'QTY108', QTY109 AS 'QTY109', QTY110 AS 'QTY110'
                                       , QTY111 AS 'QTY111', QTY112 AS 'QTY112', QTY113 AS 'QTY113', QTY114 AS 'QTY114', QTY115 AS 'QTY115'
                                       , QTY116 AS 'QTY116', QTY117 AS 'QTY117', QTY118 AS 'QTY118', QTY119 AS 'QTY119', QTY120 AS 'QTY120'
                                       , QTY121 AS 'QTY121', QTY122 AS 'QTY122', QTY123 AS 'QTY123', QTY124 AS 'QTY124', QTY125 AS 'QTY125'
                                       , QTY126 AS 'QTY126', QTY127 AS 'QTY127', QTY128 AS 'QTY128', QTY129 AS 'QTY129', QTY130 AS 'QTY130'
                                       , QTY131 AS 'QTY131', QTY132 AS 'QTY132', QTY133 AS 'QTY133', QTY134 AS 'QTY134', QTY135 AS 'QTY135'
                                       , QTY136 AS 'QTY136', QTY137 AS 'QTY137', QTY138 AS 'QTY138', QTY139 AS 'QTY139', QTY140 AS 'QTY140'
                                       , QTY141 AS 'QTY141', QTY142 AS 'QTY142', QTY143 AS 'QTY143', QTY144 AS 'QTY144', QTY145 AS 'QTY145'
                                       , QTY146 AS 'QTY146', QTY147 AS 'QTY147', QTY148 AS 'QTY148', QTY149 AS 'QTY149', QTY150 AS 'QTY150'
                                       , QTY151 AS 'QTY151', QTY152 AS 'QTY152', QTY153 AS 'QTY153', QTY154 AS 'QTY154', QTY155 AS 'QTY155'
                                       , QTY156 AS 'QTY156', QTY157 AS 'QTY157', QTY158 AS 'QTY158', QTY159 AS 'QTY159', QTY160 AS 'QTY160'
                                       , QTY161 AS 'QTY161', QTY162 AS 'QTY162', QTY163 AS 'QTY163', QTY164 AS 'QTY164', QTY165 AS 'QTY165'
                                       , QTY166 AS 'QTY166', QTY167 AS 'QTY167', QTY168 AS 'QTY168', QTY169 AS 'QTY169', QTY170 AS 'QTY170'
                                       , QTY171 AS 'QTY171', QTY172 AS 'QTY172', QTY173 AS 'QTY173', QTY174 AS 'QTY174', QTY175 AS 'QTY175'
                                       , QTY176 AS 'QTY176', QTY177 AS 'QTY177', QTY178 AS 'QTY178', QTY179 AS 'QTY179', QTY180 AS 'QTY180'
                                       , QTY181 AS 'QTY181', QTY182 AS 'QTY182', QTY183 AS 'QTY183', QTY184 AS 'QTY184', QTY185 AS 'QTY185'
                                       , QTY186 AS 'QTY186', QTY187 AS 'QTY187', QTY188 AS 'QTY188', QTY189 AS 'QTY189', QTY190 AS 'QTY190'
                                       , QTY191 AS 'QTY191', QTY192 AS 'QTY192', QTY193 AS 'QTY193', QTY194 AS 'QTY194', QTY195 AS 'QTY195'
                                       , QTY196 AS 'QTY196', QTY197 AS 'QTY197', QTY198 AS 'QTY198', QTY199 AS 'QTY199', QTY200 AS 'QTY200'
                                       , QTY201 AS 'QTY201', QTY202 AS 'QTY202', QTY203 AS 'QTY203', QTY204 AS 'QTY204', QTY205 AS 'QTY205'
                                       , QTY206 AS 'QTY206', QTY207 AS 'QTY207', QTY208 AS 'QTY208', QTY209 AS 'QTY209', QTY210 AS 'QTY210'
                                       , QTY211 AS 'QTY211', QTY212 AS 'QTY212', QTY213 AS 'QTY213', QTY214 AS 'QTY214', QTY215 AS 'QTY215'
                                       , QTY216 AS 'QTY216', QTY217 AS 'QTY217', QTY218 AS 'QTY218', QTY219 AS 'QTY219', QTY220 AS 'QTY220'
                                       , QTY221 AS 'QTY221', QTY222 AS 'QTY222', QTY223 AS 'QTY223', QTY224 AS 'QTY224', QTY225 AS 'QTY225'
                                       , QTY226 AS 'QTY226', QTY227 AS 'QTY227', QTY228 AS 'QTY228', QTY229 AS 'QTY229', QTY230 AS 'QTY230'
                                       , QTY231 AS 'QTY231', QTY232 AS 'QTY232', QTY233 AS 'QTY233', QTY234 AS 'QTY234', QTY235 AS 'QTY235'
                                       , QTY236 AS 'QTY236', QTY237 AS 'QTY237', QTY238 AS 'QTY238', QTY239 AS 'QTY239', QTY240 AS 'QTY240'
                                       , QTY241 AS 'QTY241', QTY242 AS 'QTY242', QTY243 AS 'QTY243', QTY244 AS 'QTY244', QTY245 AS 'QTY245'
                                       , QTY246 AS 'QTY246', QTY247 AS 'QTY247', QTY248 AS 'QTY248', QTY249 AS 'QTY249', QTY250 AS 'QTY250'
                                       , QTY251 AS 'QTY251', QTY252 AS 'QTY252', QTY253 AS 'QTY253', QTY254 AS 'QTY254', QTY255 AS 'QTY255'
                                       , QTY256 AS 'QTY256', QTY257 AS 'QTY257', QTY258 AS 'QTY258', QTY259 AS 'QTY259', QTY260 AS 'QTY260'
                                       , QTY261 AS 'QTY261', QTY262 AS 'QTY262', QTY263 AS 'QTY263', QTY264 AS 'QTY264', QTY265 AS 'QTY265'
                                       , QTY266 AS 'QTY266', QTY267 AS 'QTY267', QTY268 AS 'QTY268', QTY269 AS 'QTY269', QTY270 AS 'QTY270'
                                       , QTY271 AS 'QTY271', QTY272 AS 'QTY272', QTY273 AS 'QTY273', QTY274 AS 'QTY274', QTY275 AS 'QTY275'
                                       , QTY276 AS 'QTY276', QTY277 AS 'QTY277', QTY278 AS 'QTY278', QTY279 AS 'QTY279', QTY280 AS 'QTY280'
                                       , QTY281 AS 'QTY281', QTY282 AS 'QTY282', QTY283 AS 'QTY283', QTY284 AS 'QTY284', QTY285 AS 'QTY285'
                                       , QTY286 AS 'QTY286', QTY287 AS 'QTY287', QTY288 AS 'QTY288', QTY289 AS 'QTY289', QTY290 AS 'QTY290'
                                       , QTY291 AS 'QTY291', QTY292 AS 'QTY292', QTY293 AS 'QTY293', QTY294 AS 'QTY294', QTY295 AS 'QTY295'
                                       , QTY296 AS 'QTY296', QTY297 AS 'QTY297', QTY298 AS 'QTY298', QTY299 AS 'QTY299', QTY300 AS 'QTY300'
                                       , QTY301 AS 'QTY301', QTY302 AS 'QTY302', QTY303 AS 'QTY303', QTY304 AS 'QTY304', QTY305 AS 'QTY305'
                                       , QTY306 AS 'QTY306', QTY307 AS 'QTY307', QTY308 AS 'QTY308', QTY309 AS 'QTY309', QTY310 AS 'QTY310'
                                       , QTY311 AS 'QTY311', QTY312 AS 'QTY312', QTY313 AS 'QTY313', QTY314 AS 'QTY314', QTY315 AS 'QTY315'
                                       , QTY316 AS 'QTY316', QTY317 AS 'QTY317', QTY318 AS 'QTY318', QTY319 AS 'QTY319', QTY320 AS 'QTY320'
                                       , QTY321 AS 'QTY321', QTY322 AS 'QTY322', QTY323 AS 'QTY323', QTY324 AS 'QTY324', QTY325 AS 'QTY325'
                                       , QTY326 AS 'QTY326', QTY327 AS 'QTY327', QTY328 AS 'QTY328', QTY329 AS 'QTY329', QTY330 AS 'QTY330'
                                       , QTY331 AS 'QTY331', QTY332 AS 'QTY332', QTY333 AS 'QTY333', QTY334 AS 'QTY334', QTY335 AS 'QTY335'
                                       , QTY336 AS 'QTY336', QTY337 AS 'QTY337', QTY338 AS 'QTY338', QTY339 AS 'QTY339', QTY340 AS 'QTY340'
                                       , QTY341 AS 'QTY341', QTY342 AS 'QTY342', QTY343 AS 'QTY343', QTY344 AS 'QTY344', QTY345 AS 'QTY345'
                                       , QTY346 AS 'QTY346', QTY347 AS 'QTY347', QTY348 AS 'QTY348', QTY349 AS 'QTY349', QTY350 AS 'QTY350'
                                       , QTY351 AS 'QTY351', QTY352 AS 'QTY352', QTY353 AS 'QTY353', QTY354 AS 'QTY354', QTY355 AS 'QTY355'
                                       , QTY356 AS 'QTY356', QTY357 AS 'QTY357', QTY358 AS 'QTY358', QTY359 AS 'QTY359', QTY360 AS 'QTY360'
                                       , QTY361 AS 'QTY361', QTY362 AS 'QTY362', QTY363 AS 'QTY363', QTY364 AS 'QTY364'
                                         )
                           ) X
                 , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                  , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                         AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
                              /* WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                                   AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd */
                            ) Y
             WHERE X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
                 ;

            /* ------------------------------------------------------------------------------------------------------------------------------
            --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
            -------------------------------------------------------------------------------------------------------------------------------------------------------
            print  convert(varchar(30), getdate(), 121) + N'PJ2025F254 : ESS 가상 라인에 매핑된 JV라인 생산 계획 추가'
            ------------------------------------------------------------------------------------------------------------------------------------------------------- */
            INSERT INTO GT_XPGT_SCP_ANL_PRODUCTION_PLAN
                 ( DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , LINE_ID
                 , OPERATION_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
                 , CELL_QTY
                 , YYYYMMDD_COLUMN )
            SELECT SM.RP_DIVISION_ID   AS DIVISION_ID
                 , PP.PLAN_START_YYYYMMDD
                 , PV.PLAN_TYPE
                 , PV.PLAN_SEQ         AS SEQ
                 , PP.OPERATION_GROUP
                 , SM.RP_SCM_SITE_ID   AS SCM_SITE_ID
                 , PP.ITEM_ID
                 , LM.RL_LINE_ID       AS LINE_ID
                 , PP.OPERATION_ID
                 , PP.MEASURE
                 , PP.YYYYMMDD
                 , PP.QTY
                 , SM.RP_DIVISION_ID   AS ORIGIN_DIVISION_ID
                 , PP.ELECTRODE_TYPE
                 , PP.CELL_QTY
                 , PP.YYYYMMDD_COLUMN
              FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN PP
                   INNER JOIN GT_XPGT_JV_ESS_SCM_SITE_MAP SM
                           ON SM.VP_DIVISION_ID = PP.DIVISION_ID
                          AND SM.VP_SCM_SITE_ID = PP.SCM_SITE_ID
                   INNER JOIN GT_XPGT_JV_ESS_LINE_MAP LM
                           ON LM.VL_COMPANY_ID  = SM.VP_COMPANY_ID
                          AND LM.VL_DIVISION_ID = SM.VP_DIVISION_ID
                          AND LM.VL_SITE_ID     = SM.VP_SITE_ID
                          AND LM.VL_PLANT_ID    = SM.VP_PLANT_ID
                          AND LM.VL_LINE_ID     = PP.LINE_ID
                   INNER JOIN GT_XPGT_DIVISION_LAST_PLAN_INFO PV
                           ON PV.DIVISION_ID         = LM.RL_DIVISION_ID
                          AND PV.PLAN_START_YYYYMMDD = PP.PLAN_START_YYYYMMDD
             WHERE 1 = 1
                 ;
            /* ------------------------------------------------------------------------------------------------------------------------------
            --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
            ------------------------------------------------------------------------------------------------------------------------------------ */

            /* ------------------------------------------------------------------------------------------- */
            /*  FROZEN 구간 UPDATE */
            /*  PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다. */
            /* ------------------------------------------------------------------------------------------- */
            /*  2021.10.19 - CELL_PROD 는 PROD FROZEN 해제 */
            /*  IF @p_plan_type IN  ('MA','SE') */
            /*  ★원본 L3256 은 지역변수가 아니라 파라미터 @p_plan_type 을 직접 본다(2023.12.08 지역변수 전환 누락분).
                  원본 자식에 #SCM_MST_SITE 의 CREATE/DROP 이 0건이므로 여기서 DELETE/INSERT 하지 않는다. */
            IF ( P_PLAN_TYPE IN ('MA', 'SE') AND V_BATCH_MEASURE = 'PACK_PROD' ) THEN
              /*  MSSQL DELETE FROM #T FROM #T X INNER JOIN #S Y ON .. WHERE .. -> DELETE FROM t WHERE EXISTS (CV-063) */
              DELETE FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN X
               WHERE EXISTS ( SELECT 1
                                FROM GT_XPGT_SCM_MST_SITE Y
                               WHERE Y.DIVISION_ID = X.DIVISION_ID
                                 AND Y.SCM_SITE_ID = X.SCM_SITE_ID
                                 AND X.YYYYMMDD    < Y.PROD_FROZEN_WEEK_DAY );
            END IF;

               /*  PROD_PLAN_AMEND */
               /*  MSSQL : INSERT INTO SCP_ANL_PRODUCTION_PLAN (..) SELECT .. FROM ( MERGE .. OUTPUT $action, Inserted.* )
                   AS Changes(..) WHERE Action = 'INSERT'   (composable DML - Oracle 무대응)
                   = MERGE 로 실제 INSERT 된 행마다 MEASURE='PROD_PLAN_ENGINE', QTY=0 짝 행을 하나 더 넣는 로직이다.
                   MERGE 가 INSERT 할 집합 = ON 절에 매칭되지 않는 원천행이므로, 같은 조건을 NOT EXISTS 로 뽑아
                   MERGE 직전에 짝 행을 먼저 INSERT 한다. 짝 행의 MEASURE 는 'PROD_PLAN_ENGINE' 이고
                   ON 절/PK 모두 MEASURE 를 포함하므로 뒤따르는 MERGE 의 매칭 결과에 영향을 주지 않는다(1:1 등가). */
               /*  INSERT 일경우 PROD_PLAN_ENGINE/PROD_PLAN_AMEND 쌍으로 입력한다. */
               INSERT INTO SCP_ANL_PRODUCTION_PLAN
                    ( DIVISION_ID
                    , PLAN_START_YYYYMMDD
                    , PLAN_TYPE
                    , SEQ
                    , OPERATION_GROUP
                    /* , CELL_ITEM_ID */
                    , SCM_SITE_ID
                    , ITEM_ID
                    , LINE_ID
                    , OPERATION_ID
                    , MEASURE
                    , YYYYMMDD
                    , QTY
                    , ORIGIN_DIVISION_ID
                    , ELECTRODE_TYPE
                    , CELL_QTY
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE )
               SELECT Y.DIVISION_ID
                    , Y.PLAN_START_YYYYMMDD
                    , Y.PLAN_TYPE
                    , Y.SEQ
                    , Y.OPERATION_GROUP
                    /* , Inserted.CELL_ITEM_ID */
                    , Y.SCM_SITE_ID
                    , Y.ITEM_ID
                    , Y.LINE_ID
                    , NVL(Y.OPERATION_ID, '-') AS OPERATION_ID
                    , 'PROD_PLAN_ENGINE' AS MEASURE
                    , Y.YYYYMMDD
                    , 0 AS QTY
                    , Y.ORIGIN_DIVISION_ID
                    , Y.ELECTRODE_TYPE
                    , Y.CELL_QTY
                    , V_BATCH_USER   AS CREATED_BY
                    , SYSDATE       AS CREATION_DATE
                    , V_BATCH_USER   AS LAST_UPDATED_BY
                    , SYSDATE       AS LAST_UPDATE_DATE
                 FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                WHERE NOT EXISTS ( SELECT 1
                                     FROM SCP_ANL_PRODUCTION_PLAN X
                                    WHERE 0 = 0
                        AND X.DIVISION_ID         = Y.DIVISION_ID          /* @v_batch_division_id  2021.10.25 튜닝개선요청에 따른 변경 */
                        AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD  /* @v_batch_PLAN_START_YYYYMMDD */
                        AND X.PLAN_TYPE           = Y.PLAN_TYPE            /* @v_batch_PLAN_TYPE */
                        AND X.SEQ                 = Y.SEQ                  /* @v_batch_SEQ */
                        AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID         = Y.SCM_SITE_ID
                        AND X.ITEM_ID             = Y.ITEM_ID
                        AND X.MEASURE             = Y.MEASURE
                        AND X.YYYYMMDD            = Y.YYYYMMDD
                        AND X.LINE_ID             = Y.LINE_ID
                        AND X.OPERATION_ID        = Y.OPERATION_ID
                        AND X.ORIGIN_DIVISION_ID  = Y.ORIGIN_DIVISION_ID
                        AND NVL(X.ELECTRODE_TYPE, ' ') = NVL(Y.ELECTRODE_TYPE, ' ') )
                    ;

                       MERGE INTO SCP_ANL_PRODUCTION_PLAN X
                        USING ( SELECT DIVISION_ID
                                     , PLAN_START_YYYYMMDD
                                     , PLAN_TYPE
                                     , SEQ
                                     , OPERATION_GROUP
                                     /* , CELL_ITEM_ID */
                                     , SCM_SITE_ID
                                     , ITEM_ID
                                     , LINE_ID
                                     , OPERATION_ID
                                     , MEASURE
                                     , YYYYMMDD
                                     , QTY
                                     , ORIGIN_DIVISION_ID
                                     , ELECTRODE_TYPE
                                     , CELL_QTY
                                  FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN
                                 /* WHERE QTY > 0 */
                              ) Y
                           ON ( 0 = 0
                        AND X.DIVISION_ID         = Y.DIVISION_ID          /* @v_batch_division_id  2021.10.25 튜닝개선요청에 따른 변경 */
                        AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD  /* @v_batch_PLAN_START_YYYYMMDD */
                        AND X.PLAN_TYPE           = Y.PLAN_TYPE            /* @v_batch_PLAN_TYPE */
                        AND X.SEQ                 = Y.SEQ                  /* @v_batch_SEQ */
                        AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID         = Y.SCM_SITE_ID
                        AND X.ITEM_ID             = Y.ITEM_ID
                        AND X.MEASURE             = Y.MEASURE
                        AND X.YYYYMMDD            = Y.YYYYMMDD
                        AND X.LINE_ID             = Y.LINE_ID
                        AND X.OPERATION_ID        = Y.OPERATION_ID
                        AND X.ORIGIN_DIVISION_ID  = Y.ORIGIN_DIVISION_ID
                        AND NVL(X.ELECTRODE_TYPE, ' ') = NVL(Y.ELECTRODE_TYPE, ' ') )
                        WHEN MATCHED THEN
                        UPDATE
                           SET X.QTY               = Y.QTY
                             /* , X.CREATED_BY         = @p_USER_ID */
                             /* , X.CREATION_DATE      = GETDATE()  */
                             , X.LAST_UPDATED_BY  = V_BATCH_USER
                             , X.LAST_UPDATE_DATE = SYSDATE
                        WHEN NOT MATCHED THEN
                          INSERT ( DIVISION_ID
                                 , PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , SEQ
                                 , OPERATION_GROUP
                                 /* , CELL_ITEM_ID */
                                 , SCM_SITE_ID
                                 , ITEM_ID
                                 , LINE_ID
                                 , OPERATION_ID
                                 , MEASURE
                                 , YYYYMMDD
                                 , QTY
                                 , ORIGIN_DIVISION_ID
                                 , ELECTRODE_TYPE
                                 , CELL_QTY
                                 , CREATED_BY
                                 , CREATION_DATE
                                 , LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE )
                         VALUES ( Y.DIVISION_ID
                                , Y.PLAN_START_YYYYMMDD
                                , Y.PLAN_TYPE
                                , Y.SEQ
                                , Y.OPERATION_GROUP
                                /* , Y.CELL_ITEM_ID */
                                , Y.SCM_SITE_ID
                                , Y.ITEM_ID
                                , Y.LINE_ID
                                , NVL(Y.OPERATION_ID, '-')
                                , Y.MEASURE
                                , Y.YYYYMMDD
                                , Y.QTY
                                , Y.ORIGIN_DIVISION_ID
                                , Y.ELECTRODE_TYPE
                                , Y.CELL_QTY
                                , V_BATCH_USER
                                , SYSDATE
                                , V_BATCH_USER
                                , SYSDATE )
                                ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN_H : History 입력 */
            /* ------------------------------------------------------------------------------------------- */
            /*  SELECT top 10 * FROM dbo.SCP_ANL_PRODUCTION_PLAN_H WITH (NOLOCK)     -- HISTORY_SEQ */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H */
                      INSERT INTO SCP_ANL_PRODUCTION_PLAN_H
                           ( HISTORY_SEQ
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , OPERATION_GROUP
                           , SCM_SITE_ID
                           , ITEM_ID
                           , LINE_ID
                           , OPERATION_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , ORIGIN_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_H.NEXTVAL
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , OPERATION_GROUP
                           , SCM_SITE_ID
                           , ITEM_ID
                           , LINE_ID
                           , OPERATION_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , ORIGIN_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_BATCH_USER   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_BATCH_USER   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN
                           ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN_FIX : FIX 입력 */
            /* ------------------------------------------------------------------------------------------- */
                      UPDATE SCP_ANL_PRODUCTION_PLAN_FIX X   /* FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD */
                         SET ( QTY
                             , ATTRIBUTE1
                             , FIX_REASON
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE ) =
                             ( SELECT Y.QTY
                                    , 'Y'
                                    , 'SIMULATION UPDATE'
                                    , V_BATCH_USER
                                    , SYSDATE
                                 FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                                WHERE 0 = 0
                                  AND X.DIVISION_ID       = Y.DIVISION_ID
                                  AND X.OPERATION_GROUP   = Y.OPERATION_GROUP
                                  AND X.SCM_SITE_ID       = Y.SCM_SITE_ID
                                  AND X.ITEM_ID           = Y.ITEM_ID
                                  AND X.LINE_ID           = Y.LINE_ID
                                  AND X.OPERATION_ID      = Y.OPERATION_ID
                                  AND X.YYYYMMDD          = Y.YYYYMMDD
                                  AND ROWNUM              = 1 )
                       WHERE EXISTS ( SELECT 1
                                        FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                                       WHERE 0 = 0
                                         AND X.DIVISION_ID       = Y.DIVISION_ID
                                         AND X.OPERATION_GROUP   = Y.OPERATION_GROUP
                                         AND X.SCM_SITE_ID       = Y.SCM_SITE_ID
                                         AND X.ITEM_ID           = Y.ITEM_ID
                                         AND X.LINE_ID           = Y.LINE_ID
                                         AND X.OPERATION_ID      = Y.OPERATION_ID
                                         AND X.YYYYMMDD          = Y.YYYYMMDD );

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN_FIX : FIX History 입력 */
            /* ------------------------------------------------------------------------------------------- */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H */
            /*  SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H */
                      INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
                           ( HISTORY_SEQ
                           , FIX_ID
                           , DIVISION_ID
                           , OPERATION_GROUP
                           , SCM_SITE_ID
                           , ITEM_ID
                           , LINE_ID
                           , OPERATION_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                           , FIX_ID
                           , DIVISION_ID
                           , OPERATION_GROUP
                           , SCM_SITE_ID
                           , ITEM_ID
                           , LINE_ID
                           , OPERATION_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_BATCH_USER   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_BATCH_USER   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM SCP_ANL_PRODUCTION_PLAN_FIX
                       WHERE ATTRIBUTE1 = 'Y'
                           ;

              /*  History 구분을 위해 원상복구 */
              UPDATE SCP_ANL_PRODUCTION_PLAN_FIX X   /* FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD */
                 SET X.ATTRIBUTE1 = NULL
               WHERE EXISTS ( SELECT 1
                                FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                               WHERE 0 = 0
                                 AND X.DIVISION_ID     = Y.DIVISION_ID
                                 AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                                 AND X.SCM_SITE_ID     = Y.SCM_SITE_ID
                                 AND X.ITEM_ID         = Y.ITEM_ID
                                 AND X.LINE_ID         = Y.LINE_ID
                                 AND X.OPERATION_ID    = Y.OPERATION_ID
                                 AND X.YYYYMMDD        = Y.YYYYMMDD )
                 AND X.ATTRIBUTE1 = 'Y';

            END IF;


              /* --------------------------------------------------------- */
              /*  FROZEN 구간 복구 */
              /* --------------------------------------------------------- */

               /* ------------------------------------------------------------------------------------------- */
                  /*  전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_ESS_MODIFY) */
                  /* ------------------------------------------------------------------------------------------- */
                  /*                      DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS_MODIFY
                      -- DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS_MODIFY
                      CREATE TABLE #SCP_XLS_PSI_GLOBAL_ESS_MODIFY ( XLS_KEY1 INT NOT NULL,
                        DIVISION_ID NVARCHAR(30) NOT NULL, CREATE_FROM_YYYYMMDD NVARCHAR(8) NOT NULL,
                        QTY001 NUMERIC(20,10) NULL, .. QTY364 NUMERIC(20,10) NULL ) */
                  DELETE FROM GT_XPGT_XP06S_SCP_XLS_PSI_GLOBAL_ESS_MODIFY;

                    V_X_ITEM_ID         := '';
                    /*  SCP_ANL_SHIPMENT_PLAN_FG/SEMI PK Parameter */
                    V_X_OPERATION_GROUP := '';   /* BIZ_TYPE */
                    V_X_PROJECT_CODE    := '';
                    V_X_TO_SITE         := '';
                    V_X_INCOTERMS       := '';
                    V_X_FROM_SITE       := '';   /* SCM_SITE_ID */
                    V_X_BOD_ID          := '';
                    /*  SCP_ANL_PRODUCTION_PLAN PK Parameter */
                    V_X_LINE_ID         := '';
                    V_X_OPERATION_ID    := '';

                    /*  MSSQL SELECT @X_.. = .. FROM .. WHERE XLS_KEY1 = @v_batch_xls_key1 : 0행이면 기존값 유지, */
                    FOR R IN ( SELECT OPERATION_GROUP
                                    , ITEM_ID
                                    , PROD_LINE
                                    , ATTRIBUTE9
                                    , PROJECT_CODE
                                    , TO_SITE
                                    , INCOTERMS
                                    , FROM_SITE
                                    , BOD_ID
                                 FROM SCP_XLS_PSI_GLOBAL_ESS
                                WHERE XLS_KEY1             = V_BATCH_XLS_KEY1
                                  AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD )
                    LOOP
                        V_X_OPERATION_GROUP := R.OPERATION_GROUP;
                        V_X_ITEM_ID         := R.ITEM_ID;
                        V_X_LINE_ID         := R.PROD_LINE;
                        V_X_OPERATION_ID    := R.ATTRIBUTE9;
                        V_X_PROJECT_CODE    := R.PROJECT_CODE;
                        V_X_TO_SITE         := R.TO_SITE;
                        V_X_INCOTERMS       := R.INCOTERMS;
                        V_X_FROM_SITE       := R.FROM_SITE;
                        V_X_BOD_ID          := R.BOD_ID;
                    END LOOP;

              IF V_BATCH_MEASURE <> 'CELL_CHAR_PLAN' THEN
                  /*  IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY_ROW') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY_ROW;
                CREATE TABLE #SCP_XLS_PSI_GLOBAL_MODIFY_ROW( YYYYMMDD VARCHAR(20) NOT NULL, QTY NUMERIC (20,10) NOT NULL, COLS_NAME NVARCHAR(30) NOT NULL ); */
                  DELETE FROM GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW;

                  /* ------------------------------------------------------------------------------------------- */
                  /*  저장후 시물레이션 데이터 UPDATE */
                  /* ------------------------------------------------------------------------------------------- */

                  /* ▼ MSSQL 원본 L3777~L3804 원문 보존 (동적 SQL(@mQry_sum2/@mEXEC2) 死코드 - 2025 개선으로 정적 INSERT 로 대체) ---------------------------------------------
                                         DECLARE @mQry_sum2 NVARCHAR(MAX);

                                             SET     @mQry_sum2 = '';
                                             SELECT  @mQry_sum2 = @mQry_sum2+','+
                                                 CASE
                                                 WHEN 1 = 1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+YYYYMMDD+'''    THEN QTY ELSE 0 END ) AS ' + 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY YYYYMMDD))
                                                 END +''+CHAR(10)
                                             FROM (
                                                 SELECT A.BASIS_YYYYMMDD                    AS YYYYMMDD
                                                 , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
                                                 FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)
                                                   WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                                              AND A.BASIS_YYYYMMDD     <  CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)        --@p_to_yyyymmdd
                                                  GROUP BY A.BASIS_YYYYMMDD
                                             ) AS A
                                             ORDER BY SORT_ORDER_NO  ;


                                         DECLARE @mEXEC2 NVARCHAR(MAX);

                                             SET @mEXEC2 = '';
                                         SET @mEXEC2 = @mEXEC2 + ' INSERT INTO #SCP_XLS_PSI_GLOBAL_ESS_MODIFY WITH (TABLOCK)  '+CHAR(10);


                                         -------------------------------------------------------------------------------------------------------------
                                         -- 'SHIP_PLAN'
                                         -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, YYYYMMDD, BIZ_TYPE, ITEM_ID, PROJECT_CODE, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, MEASURE
                                         ------------------------------------------------------------------------------------------------------------- */

                  /* ------------------------------------------------------------------------------------------- */
                  /*  'SHIP_PLAN' */
                  /*  PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, YYYYMMDD, BIZ_TYPE, ITEM_ID, PROJECT_CODE, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, MEASURE */
                  /* ------------------------------------------------------------------------------------------- */
                  IF V_BATCH_MEASURE = 'SHIP_PLAN' THEN   /* FG */
                      INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW
                           ( YYYYMMDD
                           , QTY
                           , COLS_NAME )
                      SELECT A.YYYYMMDD
                           , A.QTY
                           , B.COLS_NAME
                        FROM SCP_ANL_SHIPMENT_PLAN_FG A
                             INNER JOIN
                                    ( SELECT ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD) AS SORT_SEQ
                                           , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS COLS_NAME
                                           , A.BASIS_YYYYMMDD                  AS YYYYMMDD
                                           , A.BASIS_YYYYMMDD || TO_CHAR(31)   AS SORT_ORDER_NO
                                        FROM SCM_SYS_CALENDAR_M A
                                       WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                                  AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')   /* @p_to_yyyymmdd */
                                       GROUP BY A.BASIS_YYYYMMDD
                                    ) B
                                      ON A.YYYYMMDD = B.YYYYMMDD
                       WHERE 0 = 0
                         AND A.PLAN_START_YYYYMMDD =  V_BATCH_PLAN_START_YYYYMMDD
                         AND A.PLAN_TYPE           =  V_BATCH_PLAN_TYPE
                         AND A.SEQ                 =  V_BATCH_SEQ
                         AND A.DIVISION_ID         =  V_BATCH_DIVISION_ID
                         AND A.YYYYMMDD            <  V_P_TO_YYYYMMDD
                         AND A.BIZ_TYPE            =  V_X_OPERATION_GROUP
                         AND A.ITEM_ID             =  V_X_ITEM_ID
                         AND A.PROJECT_CODE        =  V_X_PROJECT_CODE
                         AND A.TO_SITE             =  V_X_TO_SITE
                         AND A.INCOTERMS           =  V_X_INCOTERMS
                         AND A.FROM_SITE           =  V_X_FROM_SITE
                         AND A.BOD_ID              =  V_X_BOD_ID
                         AND A.MEASURE             = 'SHIP_PLAN_AMEND'
                         AND A.QTY                 <> 0.0
                           ;
                  END IF;

                  /*                                         DECLARE @mFG NVARCHAR(MAX) = '';

                                             SET @mFG = @mFG + ' SELECT  '''+ @p_xls_key1  +''' AS XLS_KEY1  '+CHAR(10);

                                             SET @mFG = @mFG + '                 ' + @mQry_sum2 +'                                          '+CHAR(10);
                                           SET @mFG = @mFG + '         FROM SCP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)  '+CHAR(10);
                                         SET @mFG = @mFG + '         WHERE 0 = 0                                 '+CHAR(10);
                                         SET @mFG = @mFG + '         AND DIVISION_ID         =  '''+ @v_batch_division_id  +'''' +CHAR(10);
                                         SET @mFG = @mFG + '         AND PLAN_START_YYYYMMDD =  '''+ @v_batch_plan_start_yyyymmdd+'''' +CHAR(10);
                                         SET @mFG = @mFG + '         AND PLAN_TYPE           =  '''+ @v_batch_plan_type  +'''' +CHAR(10);
                                         SET @mFG = @mFG + '         AND SEQ                 =  '+ CONVERT(NVARCHAR,@p_seq)+'' +CHAR(10);

                                         SET @mFG = @mFG + '         AND BIZ_TYPE            =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);
                                         SET @mFG = @mFG + '         AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);
                                         SET @mFG = @mFG + '         AND PROJECT_CODE        =  '''+ @X_PROJECT_CODE+'''' +CHAR(10);
                                         SET @mFG = @mFG + '         AND TO_SITE             =  '''+ @X_TO_SITE+'''' +CHAR(10);
                                         SET @mFG = @mFG + '         AND INCOTERMS           =  '''+ @X_INCOTERMS+'''' +CHAR(10);
                                         SET @mFG = @mFG + '         AND FROM_SITE           =  '''+ @X_FROM_SITE+'''' +CHAR(10);
                                         SET @mFG = @mFG + '         AND BOD_ID              =  '''+ @X_BOD_ID+'''' +CHAR(10);

                                         SET @mFG = @mFG + '         AND MEASURE             = ''SHIP_PLAN_AMEND'' '+CHAR(10);
                                         SET @mFG = @mFG + '         AND YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);

                                         -------------------------------------------------------------------------------------------------------------
                                         -- 'SEMI_SHIP_PLAN'
                                         -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, FROM_SITE, BOD_ID, MEASURE, YYYYMMDD
                                         ------------------------------------------------------------------------------------------------------------- */

                  IF V_BATCH_MEASURE = 'SEMI_SHIP_PLAN' THEN   /* SEMI */
                      INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW
                           ( YYYYMMDD
                           , QTY
                           , COLS_NAME )
                      SELECT A.YYYYMMDD
                           , A.QTY
                           , B.COLS_NAME
                        FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                             INNER JOIN
                                    ( SELECT ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD) AS SORT_SEQ
                                           , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS COLS_NAME
                                           , A.BASIS_YYYYMMDD                  AS YYYYMMDD
                                           , A.BASIS_YYYYMMDD || TO_CHAR(31)   AS SORT_ORDER_NO
                                        FROM SCM_SYS_CALENDAR_M A
                                       WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                                  AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')   /* @p_to_yyyymmdd */
                                       GROUP BY A.BASIS_YYYYMMDD
                                    ) B
                                      ON A.YYYYMMDD = B.YYYYMMDD
                       WHERE 0 = 0
                         AND A.DIVISION_ID         =  V_BATCH_DIVISION_ID
                         AND A.PLAN_START_YYYYMMDD =  V_BATCH_PLAN_START_YYYYMMDD
                         AND A.PLAN_TYPE           =  V_BATCH_PLAN_TYPE
                         AND A.SEQ                 =  V_BATCH_SEQ
                         AND A.OPERATION_GROUP     =  V_X_OPERATION_GROUP
                         AND A.ITEM_ID             =  V_X_ITEM_ID
                         AND A.FROM_SITE           =  V_X_FROM_SITE
                         AND A.BOD_ID              =  V_X_BOD_ID
                         AND A.MEASURE             = 'SHIP_PLAN_AMEND'
                         AND A.YYYYMMDD            <  V_P_TO_YYYYMMDD
                         AND A.QTY                 <> 0
                           ;
                  END IF;

                  /* ▼ MSSQL 원본 L3901~L3924 원문 보존 (@mSEMI 동적 SQL 死코드) ---------------------------------------------
                                         DECLARE @mSEMI NVARCHAR(MAX) = '';

                                             SET @mSEMI = @mSEMI + ' SELECT  '''+ @p_xls_key1  +''' AS XLS_KEY1  '+CHAR(10);

                                             SET @mSEMI = @mSEMI + '                 ' + @mQry_sum2 +'                                          '+CHAR(10);
                                           SET @mSEMI = @mSEMI + '         FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)  '+CHAR(10);
                                         SET @mSEMI = @mSEMI + '         WHERE 0 = 0                                 '+CHAR(10);
                                         SET @mSEMI = @mSEMI + '         AND DIVISION_ID         =  '''+ @v_batch_division_id  +'''' +CHAR(10);
                                         SET @mSEMI = @mSEMI + '         AND PLAN_START_YYYYMMDD =  '''+ @v_batch_plan_start_yyyymmdd+'''' +CHAR(10);
                                         SET @mSEMI = @mSEMI + '     AND PLAN_TYPE           =  '''+ @v_batch_plan_type  +'''' +CHAR(10);
                                         SET @mSEMI = @mSEMI + '         AND SEQ                 =  '+ CONVERT(NVARCHAR,@p_seq)+'' +CHAR(10);

                                         SET @mSEMI = @mSEMI + '         AND OPERATION_GROUP     =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);
                                         SET @mSEMI = @mSEMI + '         AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);
                                         SET @mSEMI = @mSEMI + '         AND FROM_SITE           =  '''+ @X_FROM_SITE+'''' +CHAR(10);
                                         SET @mSEMI = @mSEMI + '         AND BOD_ID              =  '''+ @X_BOD_ID+'''' +CHAR(10);

                                         SET @mSEMI = @mSEMI + '         AND MEASURE             = ''SHIP_PLAN_AMEND'' '+CHAR(10);
                                         SET @mSEMI = @mSEMI + '         AND YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);

                                         -------------------------------------------------------------------------------------------------------------
                                         -- 'PACK_PROD','CELL_PROD'
                                         -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
                                         ------------------------------------------------------------------------------------------------------------- */

                  IF V_BATCH_MEASURE IN ('PACK_PROD', 'CELL_PROD') THEN   /* PROD */
                      INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW
                           ( YYYYMMDD
                           , QTY
                           , COLS_NAME )
                      SELECT A.YYYYMMDD
                           , A.QTY
                           , B.COLS_NAME
                        FROM SCP_ANL_PRODUCTION_PLAN A
                             INNER JOIN
                                    ( SELECT ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD) AS SORT_SEQ
                                           , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS COLS_NAME
                                           , A.BASIS_YYYYMMDD                  AS YYYYMMDD
                                           , A.BASIS_YYYYMMDD || TO_CHAR(31)   AS SORT_ORDER_NO
                                        FROM SCM_SYS_CALENDAR_M A
                                       WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                                  AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')   /* @p_to_yyyymmdd */
                                       GROUP BY A.BASIS_YYYYMMDD
                                    ) B
                                      ON A.YYYYMMDD = B.YYYYMMDD
                       WHERE 0 = 0
                         AND A.DIVISION_ID         =  V_BATCH_DIVISION_ID
                         AND A.PLAN_START_YYYYMMDD =  V_BATCH_PLAN_START_YYYYMMDD
                         AND A.PLAN_TYPE           =  V_BATCH_PLAN_TYPE
                         AND A.SEQ                 =  V_BATCH_SEQ
                         AND A.OPERATION_GROUP     =  V_X_OPERATION_GROUP
                         AND A.SCM_SITE_ID         =  V_X_FROM_SITE
                         AND A.ITEM_ID             =  V_X_ITEM_ID
                         AND A.LINE_ID             =  V_X_LINE_ID
                         AND A.OPERATION_ID        =  V_X_OPERATION_ID
                         AND A.MEASURE             = 'PROD_PLAN_AMEND'
                         AND A.YYYYMMDD            <  V_P_TO_YYYYMMDD
                         AND A.QTY                 <> 0
                           ;
                  END IF;

                  /* ▼ MSSQL 원본 L3959~L3990 원문 보존 (@mPROD 동적 SQL · sp_executesql 死코드) ---------------------------------------------
                                         DECLARE @mPROD NVARCHAR(MAX) = '';

                                             SET @mPROD = @mPROD + ' SELECT  '''+ @p_xls_key1  +''' AS XLS_KEY1  '+CHAR(10);

                                             SET @mPROD = @mPROD + '                 ' + @mQry_sum2 +'                                          '+CHAR(10);
                                           SET @mPROD = @mPROD + '         FROM SCP_ANL_PRODUCTION_PLAN WITH (NOLOCK)  '+CHAR(10);
                                         SET @mPROD = @mPROD + '         WHERE 0 = 0                                 '+CHAR(10);
                                         SET @mPROD = @mPROD + '         AND DIVISION_ID         =  '''+ @v_batch_division_id  +'''' +CHAR(10);
                                         SET @mPROD = @mPROD + '         AND PLAN_START_YYYYMMDD =  '''+ @v_batch_plan_start_yyyymmdd+'''' +CHAR(10);
                                         SET @mPROD = @mPROD + '     AND PLAN_TYPE           =  '''+ @v_batch_plan_type  +'''' +CHAR(10);
                                         SET @mPROD = @mPROD + '         AND SEQ                 =  '+ CONVERT(NVARCHAR,@p_seq)+'' +CHAR(10);
                                         SET @mPROD = @mPROD + '         AND OPERATION_GROUP     =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);
                                         SET @mPROD = @mPROD + '         AND SCM_SITE_ID         =  '''+ @X_FROM_SITE+'''' +CHAR(10);
                                         SET @mPROD = @mPROD + '         AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);
                                         SET @mPROD = @mPROD + '         AND LINE_ID             =  '''+ @X_LINE_ID+'''' +CHAR(10);
                                         SET @mPROD = @mPROD + '         AND OPERATION_ID        =  '''+ @X_OPERATION_ID+'''' +CHAR(10);
                                         SET @mPROD = @mPROD + '         AND MEASURE             = ''PROD_PLAN_AMEND'' '+CHAR(10);
                                         SET @mPROD = @mPROD + '         AND YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);
                                         -------------------------------------------------------------------------------------------------------------


                                         IF @v_batch_measure IN  ('SHIP_PLAN')   -- FG
                                           SET @mEXEC2 = @mEXEC2 + @mFG

                                         IF @v_batch_measure IN  ('SEMI_SHIP_PLAN')  -- SEMI
                                           SET @mEXEC2 = @mEXEC2 + @mSEMI

                                         IF @v_batch_measure IN  ('PACK_PROD','CELL_PROD')   -- PROD
                                           SET @mEXEC2 = @mEXEC2 + @mPROD

                                         EXEC sp_executesql @mEXEC2; */

                  /*  MSSQL INSERT INTO #.. WITH (TABLOCK) : TABLOCK 힌트는 Oracle 무대응이라 제거(H-13). */
                  INSERT INTO GT_XPGT_XP06S_SCP_XLS_PSI_GLOBAL_ESS_MODIFY
                       ( XLS_KEY1
                       , DIVISION_ID
                       , CREATE_FROM_YYYYMMDD
                       , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008
                       , QTY009, QTY010, QTY011, QTY012, QTY013, QTY014, QTY015, QTY016
                       , QTY017, QTY018, QTY019, QTY020, QTY021, QTY022, QTY023, QTY024
                       , QTY025, QTY026, QTY027, QTY028, QTY029, QTY030, QTY031, QTY032
                       , QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                       , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048
                       , QTY049, QTY050, QTY051, QTY052, QTY053, QTY054, QTY055, QTY056
                       , QTY057, QTY058, QTY059, QTY060, QTY061, QTY062, QTY063, QTY064
                       , QTY065, QTY066, QTY067, QTY068, QTY069, QTY070, QTY071, QTY072
                       , QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                       , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088
                       , QTY089, QTY090, QTY091, QTY092, QTY093, QTY094, QTY095, QTY096
                       , QTY097, QTY098, QTY099, QTY100, QTY101, QTY102, QTY103, QTY104
                       , QTY105, QTY106, QTY107, QTY108, QTY109, QTY110, QTY111, QTY112
                       , QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                       , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128
                       , QTY129, QTY130, QTY131, QTY132, QTY133, QTY134, QTY135, QTY136
                       , QTY137, QTY138, QTY139, QTY140, QTY141, QTY142, QTY143, QTY144
                       , QTY145, QTY146, QTY147, QTY148, QTY149, QTY150, QTY151, QTY152
                       , QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                       , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168
                       , QTY169, QTY170, QTY171, QTY172, QTY173, QTY174, QTY175, QTY176
                       , QTY177, QTY178, QTY179, QTY180, QTY181, QTY182, QTY183, QTY184
                       , QTY185, QTY186, QTY187, QTY188, QTY189, QTY190, QTY191, QTY192
                       , QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                       , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208
                       , QTY209, QTY210, QTY211, QTY212, QTY213, QTY214, QTY215, QTY216
                       , QTY217, QTY218, QTY219, QTY220, QTY221, QTY222, QTY223, QTY224
                       , QTY225, QTY226, QTY227, QTY228, QTY229, QTY230, QTY231, QTY232
                       , QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                       , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248
                       , QTY249, QTY250, QTY251, QTY252, QTY253, QTY254, QTY255, QTY256
                       , QTY257, QTY258, QTY259, QTY260, QTY261, QTY262, QTY263, QTY264
                       , QTY265, QTY266, QTY267, QTY268, QTY269, QTY270, QTY271, QTY272
                       , QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                       , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288
                       , QTY289, QTY290, QTY291, QTY292, QTY293, QTY294, QTY295, QTY296
                       , QTY297, QTY298, QTY299, QTY300, QTY301, QTY302, QTY303, QTY304
                       , QTY305, QTY306, QTY307, QTY308, QTY309, QTY310, QTY311, QTY312
                       , QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                       , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328
                       , QTY329, QTY330, QTY331, QTY332, QTY333, QTY334, QTY335, QTY336
                       , QTY337, QTY338, QTY339, QTY340, QTY341, QTY342, QTY343, QTY344
                       , QTY345, QTY346, QTY347, QTY348, QTY349, QTY350, QTY351, QTY352
                       , QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                       , QTY361, QTY362, QTY363, QTY364
                       )
                  SELECT V_BATCH_XLS_KEY1              AS XLS_KEY1
                       , V_BATCH_DIVISION_ID           AS DIVISION_ID
                       , V_BATCH_CREATE_FROM_YYYYMMDD  AS CREATE_FROM_YYYYMMDD
                       , SUM(NVL(QTY001, 0)) AS QTY001, SUM(NVL(QTY002, 0)) AS QTY002, SUM(NVL(QTY003, 0)) AS QTY003, SUM(NVL(QTY004, 0)) AS QTY004, SUM(NVL(QTY005, 0)) AS QTY005
                       , SUM(NVL(QTY006, 0)) AS QTY006, SUM(NVL(QTY007, 0)) AS QTY007, SUM(NVL(QTY008, 0)) AS QTY008, SUM(NVL(QTY009, 0)) AS QTY009, SUM(NVL(QTY010, 0)) AS QTY010
                       , SUM(NVL(QTY011, 0)) AS QTY011, SUM(NVL(QTY012, 0)) AS QTY012, SUM(NVL(QTY013, 0)) AS QTY013, SUM(NVL(QTY014, 0)) AS QTY014, SUM(NVL(QTY015, 0)) AS QTY015
                       , SUM(NVL(QTY016, 0)) AS QTY016, SUM(NVL(QTY017, 0)) AS QTY017, SUM(NVL(QTY018, 0)) AS QTY018, SUM(NVL(QTY019, 0)) AS QTY019, SUM(NVL(QTY020, 0)) AS QTY020
                       , SUM(NVL(QTY021, 0)) AS QTY021, SUM(NVL(QTY022, 0)) AS QTY022, SUM(NVL(QTY023, 0)) AS QTY023, SUM(NVL(QTY024, 0)) AS QTY024, SUM(NVL(QTY025, 0)) AS QTY025
                       , SUM(NVL(QTY026, 0)) AS QTY026, SUM(NVL(QTY027, 0)) AS QTY027, SUM(NVL(QTY028, 0)) AS QTY028, SUM(NVL(QTY029, 0)) AS QTY029, SUM(NVL(QTY030, 0)) AS QTY030
                       , SUM(NVL(QTY031, 0)) AS QTY031, SUM(NVL(QTY032, 0)) AS QTY032, SUM(NVL(QTY033, 0)) AS QTY033, SUM(NVL(QTY034, 0)) AS QTY034, SUM(NVL(QTY035, 0)) AS QTY035
                       , SUM(NVL(QTY036, 0)) AS QTY036, SUM(NVL(QTY037, 0)) AS QTY037, SUM(NVL(QTY038, 0)) AS QTY038, SUM(NVL(QTY039, 0)) AS QTY039, SUM(NVL(QTY040, 0)) AS QTY040
                       , SUM(NVL(QTY041, 0)) AS QTY041, SUM(NVL(QTY042, 0)) AS QTY042, SUM(NVL(QTY043, 0)) AS QTY043, SUM(NVL(QTY044, 0)) AS QTY044, SUM(NVL(QTY045, 0)) AS QTY045
                       , SUM(NVL(QTY046, 0)) AS QTY046, SUM(NVL(QTY047, 0)) AS QTY047, SUM(NVL(QTY048, 0)) AS QTY048, SUM(NVL(QTY049, 0)) AS QTY049, SUM(NVL(QTY050, 0)) AS QTY050
                       , SUM(NVL(QTY051, 0)) AS QTY051, SUM(NVL(QTY052, 0)) AS QTY052, SUM(NVL(QTY053, 0)) AS QTY053, SUM(NVL(QTY054, 0)) AS QTY054, SUM(NVL(QTY055, 0)) AS QTY055
                       , SUM(NVL(QTY056, 0)) AS QTY056, SUM(NVL(QTY057, 0)) AS QTY057, SUM(NVL(QTY058, 0)) AS QTY058, SUM(NVL(QTY059, 0)) AS QTY059, SUM(NVL(QTY060, 0)) AS QTY060
                       , SUM(NVL(QTY061, 0)) AS QTY061, SUM(NVL(QTY062, 0)) AS QTY062, SUM(NVL(QTY063, 0)) AS QTY063, SUM(NVL(QTY064, 0)) AS QTY064, SUM(NVL(QTY065, 0)) AS QTY065
                       , SUM(NVL(QTY066, 0)) AS QTY066, SUM(NVL(QTY067, 0)) AS QTY067, SUM(NVL(QTY068, 0)) AS QTY068, SUM(NVL(QTY069, 0)) AS QTY069, SUM(NVL(QTY070, 0)) AS QTY070
                       , SUM(NVL(QTY071, 0)) AS QTY071, SUM(NVL(QTY072, 0)) AS QTY072, SUM(NVL(QTY073, 0)) AS QTY073, SUM(NVL(QTY074, 0)) AS QTY074, SUM(NVL(QTY075, 0)) AS QTY075
                       , SUM(NVL(QTY076, 0)) AS QTY076, SUM(NVL(QTY077, 0)) AS QTY077, SUM(NVL(QTY078, 0)) AS QTY078, SUM(NVL(QTY079, 0)) AS QTY079, SUM(NVL(QTY080, 0)) AS QTY080
                       , SUM(NVL(QTY081, 0)) AS QTY081, SUM(NVL(QTY082, 0)) AS QTY082, SUM(NVL(QTY083, 0)) AS QTY083, SUM(NVL(QTY084, 0)) AS QTY084, SUM(NVL(QTY085, 0)) AS QTY085
                       , SUM(NVL(QTY086, 0)) AS QTY086, SUM(NVL(QTY087, 0)) AS QTY087, SUM(NVL(QTY088, 0)) AS QTY088, SUM(NVL(QTY089, 0)) AS QTY089, SUM(NVL(QTY090, 0)) AS QTY090
                       , SUM(NVL(QTY091, 0)) AS QTY091, SUM(NVL(QTY092, 0)) AS QTY092, SUM(NVL(QTY093, 0)) AS QTY093, SUM(NVL(QTY094, 0)) AS QTY094, SUM(NVL(QTY095, 0)) AS QTY095
                       , SUM(NVL(QTY096, 0)) AS QTY096, SUM(NVL(QTY097, 0)) AS QTY097, SUM(NVL(QTY098, 0)) AS QTY098, SUM(NVL(QTY099, 0)) AS QTY099, SUM(NVL(QTY100, 0)) AS QTY100
                       , SUM(NVL(QTY101, 0)) AS QTY101, SUM(NVL(QTY102, 0)) AS QTY102, SUM(NVL(QTY103, 0)) AS QTY103, SUM(NVL(QTY104, 0)) AS QTY104, SUM(NVL(QTY105, 0)) AS QTY105
                       , SUM(NVL(QTY106, 0)) AS QTY106, SUM(NVL(QTY107, 0)) AS QTY107, SUM(NVL(QTY108, 0)) AS QTY108, SUM(NVL(QTY109, 0)) AS QTY109, SUM(NVL(QTY110, 0)) AS QTY110
                       , SUM(NVL(QTY111, 0)) AS QTY111, SUM(NVL(QTY112, 0)) AS QTY112, SUM(NVL(QTY113, 0)) AS QTY113, SUM(NVL(QTY114, 0)) AS QTY114, SUM(NVL(QTY115, 0)) AS QTY115
                       , SUM(NVL(QTY116, 0)) AS QTY116, SUM(NVL(QTY117, 0)) AS QTY117, SUM(NVL(QTY118, 0)) AS QTY118, SUM(NVL(QTY119, 0)) AS QTY119, SUM(NVL(QTY120, 0)) AS QTY120
                       , SUM(NVL(QTY121, 0)) AS QTY121, SUM(NVL(QTY122, 0)) AS QTY122, SUM(NVL(QTY123, 0)) AS QTY123, SUM(NVL(QTY124, 0)) AS QTY124, SUM(NVL(QTY125, 0)) AS QTY125
                       , SUM(NVL(QTY126, 0)) AS QTY126, SUM(NVL(QTY127, 0)) AS QTY127, SUM(NVL(QTY128, 0)) AS QTY128, SUM(NVL(QTY129, 0)) AS QTY129, SUM(NVL(QTY130, 0)) AS QTY130
                       , SUM(NVL(QTY131, 0)) AS QTY131, SUM(NVL(QTY132, 0)) AS QTY132, SUM(NVL(QTY133, 0)) AS QTY133, SUM(NVL(QTY134, 0)) AS QTY134, SUM(NVL(QTY135, 0)) AS QTY135
                       , SUM(NVL(QTY136, 0)) AS QTY136, SUM(NVL(QTY137, 0)) AS QTY137, SUM(NVL(QTY138, 0)) AS QTY138, SUM(NVL(QTY139, 0)) AS QTY139, SUM(NVL(QTY140, 0)) AS QTY140
                       , SUM(NVL(QTY141, 0)) AS QTY141, SUM(NVL(QTY142, 0)) AS QTY142, SUM(NVL(QTY143, 0)) AS QTY143, SUM(NVL(QTY144, 0)) AS QTY144, SUM(NVL(QTY145, 0)) AS QTY145
                       , SUM(NVL(QTY146, 0)) AS QTY146, SUM(NVL(QTY147, 0)) AS QTY147, SUM(NVL(QTY148, 0)) AS QTY148, SUM(NVL(QTY149, 0)) AS QTY149, SUM(NVL(QTY150, 0)) AS QTY150
                       , SUM(NVL(QTY151, 0)) AS QTY151, SUM(NVL(QTY152, 0)) AS QTY152, SUM(NVL(QTY153, 0)) AS QTY153, SUM(NVL(QTY154, 0)) AS QTY154, SUM(NVL(QTY155, 0)) AS QTY155
                       , SUM(NVL(QTY156, 0)) AS QTY156, SUM(NVL(QTY157, 0)) AS QTY157, SUM(NVL(QTY158, 0)) AS QTY158, SUM(NVL(QTY159, 0)) AS QTY159, SUM(NVL(QTY160, 0)) AS QTY160
                       , SUM(NVL(QTY161, 0)) AS QTY161, SUM(NVL(QTY162, 0)) AS QTY162, SUM(NVL(QTY163, 0)) AS QTY163, SUM(NVL(QTY164, 0)) AS QTY164, SUM(NVL(QTY165, 0)) AS QTY165
                       , SUM(NVL(QTY166, 0)) AS QTY166, SUM(NVL(QTY167, 0)) AS QTY167, SUM(NVL(QTY168, 0)) AS QTY168, SUM(NVL(QTY169, 0)) AS QTY169, SUM(NVL(QTY170, 0)) AS QTY170
                       , SUM(NVL(QTY171, 0)) AS QTY171, SUM(NVL(QTY172, 0)) AS QTY172, SUM(NVL(QTY173, 0)) AS QTY173, SUM(NVL(QTY174, 0)) AS QTY174, SUM(NVL(QTY175, 0)) AS QTY175
                       , SUM(NVL(QTY176, 0)) AS QTY176, SUM(NVL(QTY177, 0)) AS QTY177, SUM(NVL(QTY178, 0)) AS QTY178, SUM(NVL(QTY179, 0)) AS QTY179, SUM(NVL(QTY180, 0)) AS QTY180
                       , SUM(NVL(QTY181, 0)) AS QTY181, SUM(NVL(QTY182, 0)) AS QTY182, SUM(NVL(QTY183, 0)) AS QTY183, SUM(NVL(QTY184, 0)) AS QTY184, SUM(NVL(QTY185, 0)) AS QTY185
                       , SUM(NVL(QTY186, 0)) AS QTY186, SUM(NVL(QTY187, 0)) AS QTY187, SUM(NVL(QTY188, 0)) AS QTY188, SUM(NVL(QTY189, 0)) AS QTY189, SUM(NVL(QTY190, 0)) AS QTY190
                       , SUM(NVL(QTY191, 0)) AS QTY191, SUM(NVL(QTY192, 0)) AS QTY192, SUM(NVL(QTY193, 0)) AS QTY193, SUM(NVL(QTY194, 0)) AS QTY194, SUM(NVL(QTY195, 0)) AS QTY195
                       , SUM(NVL(QTY196, 0)) AS QTY196, SUM(NVL(QTY197, 0)) AS QTY197, SUM(NVL(QTY198, 0)) AS QTY198, SUM(NVL(QTY199, 0)) AS QTY199, SUM(NVL(QTY200, 0)) AS QTY200
                       , SUM(NVL(QTY201, 0)) AS QTY201, SUM(NVL(QTY202, 0)) AS QTY202, SUM(NVL(QTY203, 0)) AS QTY203, SUM(NVL(QTY204, 0)) AS QTY204, SUM(NVL(QTY205, 0)) AS QTY205
                       , SUM(NVL(QTY206, 0)) AS QTY206, SUM(NVL(QTY207, 0)) AS QTY207, SUM(NVL(QTY208, 0)) AS QTY208, SUM(NVL(QTY209, 0)) AS QTY209, SUM(NVL(QTY210, 0)) AS QTY210
                       , SUM(NVL(QTY211, 0)) AS QTY211, SUM(NVL(QTY212, 0)) AS QTY212, SUM(NVL(QTY213, 0)) AS QTY213, SUM(NVL(QTY214, 0)) AS QTY214, SUM(NVL(QTY215, 0)) AS QTY215
                       , SUM(NVL(QTY216, 0)) AS QTY216, SUM(NVL(QTY217, 0)) AS QTY217, SUM(NVL(QTY218, 0)) AS QTY218, SUM(NVL(QTY219, 0)) AS QTY219, SUM(NVL(QTY220, 0)) AS QTY220
                       , SUM(NVL(QTY221, 0)) AS QTY221, SUM(NVL(QTY222, 0)) AS QTY222, SUM(NVL(QTY223, 0)) AS QTY223, SUM(NVL(QTY224, 0)) AS QTY224, SUM(NVL(QTY225, 0)) AS QTY225
                       , SUM(NVL(QTY226, 0)) AS QTY226, SUM(NVL(QTY227, 0)) AS QTY227, SUM(NVL(QTY228, 0)) AS QTY228, SUM(NVL(QTY229, 0)) AS QTY229, SUM(NVL(QTY230, 0)) AS QTY230
                       , SUM(NVL(QTY231, 0)) AS QTY231, SUM(NVL(QTY232, 0)) AS QTY232, SUM(NVL(QTY233, 0)) AS QTY233, SUM(NVL(QTY234, 0)) AS QTY234, SUM(NVL(QTY235, 0)) AS QTY235
                       , SUM(NVL(QTY236, 0)) AS QTY236, SUM(NVL(QTY237, 0)) AS QTY237, SUM(NVL(QTY238, 0)) AS QTY238, SUM(NVL(QTY239, 0)) AS QTY239, SUM(NVL(QTY240, 0)) AS QTY240
                       , SUM(NVL(QTY241, 0)) AS QTY241, SUM(NVL(QTY242, 0)) AS QTY242, SUM(NVL(QTY243, 0)) AS QTY243, SUM(NVL(QTY244, 0)) AS QTY244, SUM(NVL(QTY245, 0)) AS QTY245
                       , SUM(NVL(QTY246, 0)) AS QTY246, SUM(NVL(QTY247, 0)) AS QTY247, SUM(NVL(QTY248, 0)) AS QTY248, SUM(NVL(QTY249, 0)) AS QTY249, SUM(NVL(QTY250, 0)) AS QTY250
                       , SUM(NVL(QTY251, 0)) AS QTY251, SUM(NVL(QTY252, 0)) AS QTY252, SUM(NVL(QTY253, 0)) AS QTY253, SUM(NVL(QTY254, 0)) AS QTY254, SUM(NVL(QTY255, 0)) AS QTY255
                       , SUM(NVL(QTY256, 0)) AS QTY256, SUM(NVL(QTY257, 0)) AS QTY257, SUM(NVL(QTY258, 0)) AS QTY258, SUM(NVL(QTY259, 0)) AS QTY259, SUM(NVL(QTY260, 0)) AS QTY260
                       , SUM(NVL(QTY261, 0)) AS QTY261, SUM(NVL(QTY262, 0)) AS QTY262, SUM(NVL(QTY263, 0)) AS QTY263, SUM(NVL(QTY264, 0)) AS QTY264, SUM(NVL(QTY265, 0)) AS QTY265
                       , SUM(NVL(QTY266, 0)) AS QTY266, SUM(NVL(QTY267, 0)) AS QTY267, SUM(NVL(QTY268, 0)) AS QTY268, SUM(NVL(QTY269, 0)) AS QTY269, SUM(NVL(QTY270, 0)) AS QTY270
                       , SUM(NVL(QTY271, 0)) AS QTY271, SUM(NVL(QTY272, 0)) AS QTY272, SUM(NVL(QTY273, 0)) AS QTY273, SUM(NVL(QTY274, 0)) AS QTY274, SUM(NVL(QTY275, 0)) AS QTY275
                       , SUM(NVL(QTY276, 0)) AS QTY276, SUM(NVL(QTY277, 0)) AS QTY277, SUM(NVL(QTY278, 0)) AS QTY278, SUM(NVL(QTY279, 0)) AS QTY279, SUM(NVL(QTY280, 0)) AS QTY280
                       , SUM(NVL(QTY281, 0)) AS QTY281, SUM(NVL(QTY282, 0)) AS QTY282, SUM(NVL(QTY283, 0)) AS QTY283, SUM(NVL(QTY284, 0)) AS QTY284, SUM(NVL(QTY285, 0)) AS QTY285
                       , SUM(NVL(QTY286, 0)) AS QTY286, SUM(NVL(QTY287, 0)) AS QTY287, SUM(NVL(QTY288, 0)) AS QTY288, SUM(NVL(QTY289, 0)) AS QTY289, SUM(NVL(QTY290, 0)) AS QTY290
                       , SUM(NVL(QTY291, 0)) AS QTY291, SUM(NVL(QTY292, 0)) AS QTY292, SUM(NVL(QTY293, 0)) AS QTY293, SUM(NVL(QTY294, 0)) AS QTY294, SUM(NVL(QTY295, 0)) AS QTY295
                       , SUM(NVL(QTY296, 0)) AS QTY296, SUM(NVL(QTY297, 0)) AS QTY297, SUM(NVL(QTY298, 0)) AS QTY298, SUM(NVL(QTY299, 0)) AS QTY299, SUM(NVL(QTY300, 0)) AS QTY300
                       , SUM(NVL(QTY301, 0)) AS QTY301, SUM(NVL(QTY302, 0)) AS QTY302, SUM(NVL(QTY303, 0)) AS QTY303, SUM(NVL(QTY304, 0)) AS QTY304, SUM(NVL(QTY305, 0)) AS QTY305
                       , SUM(NVL(QTY306, 0)) AS QTY306, SUM(NVL(QTY307, 0)) AS QTY307, SUM(NVL(QTY308, 0)) AS QTY308, SUM(NVL(QTY309, 0)) AS QTY309, SUM(NVL(QTY310, 0)) AS QTY310
                       , SUM(NVL(QTY311, 0)) AS QTY311, SUM(NVL(QTY312, 0)) AS QTY312, SUM(NVL(QTY313, 0)) AS QTY313, SUM(NVL(QTY314, 0)) AS QTY314, SUM(NVL(QTY315, 0)) AS QTY315
                       , SUM(NVL(QTY316, 0)) AS QTY316, SUM(NVL(QTY317, 0)) AS QTY317, SUM(NVL(QTY318, 0)) AS QTY318, SUM(NVL(QTY319, 0)) AS QTY319, SUM(NVL(QTY320, 0)) AS QTY320
                       , SUM(NVL(QTY321, 0)) AS QTY321, SUM(NVL(QTY322, 0)) AS QTY322, SUM(NVL(QTY323, 0)) AS QTY323, SUM(NVL(QTY324, 0)) AS QTY324, SUM(NVL(QTY325, 0)) AS QTY325
                       , SUM(NVL(QTY326, 0)) AS QTY326, SUM(NVL(QTY327, 0)) AS QTY327, SUM(NVL(QTY328, 0)) AS QTY328, SUM(NVL(QTY329, 0)) AS QTY329, SUM(NVL(QTY330, 0)) AS QTY330
                       , SUM(NVL(QTY331, 0)) AS QTY331, SUM(NVL(QTY332, 0)) AS QTY332, SUM(NVL(QTY333, 0)) AS QTY333, SUM(NVL(QTY334, 0)) AS QTY334, SUM(NVL(QTY335, 0)) AS QTY335
                       , SUM(NVL(QTY336, 0)) AS QTY336, SUM(NVL(QTY337, 0)) AS QTY337, SUM(NVL(QTY338, 0)) AS QTY338, SUM(NVL(QTY339, 0)) AS QTY339, SUM(NVL(QTY340, 0)) AS QTY340
                       , SUM(NVL(QTY341, 0)) AS QTY341, SUM(NVL(QTY342, 0)) AS QTY342, SUM(NVL(QTY343, 0)) AS QTY343, SUM(NVL(QTY344, 0)) AS QTY344, SUM(NVL(QTY345, 0)) AS QTY345
                       , SUM(NVL(QTY346, 0)) AS QTY346, SUM(NVL(QTY347, 0)) AS QTY347, SUM(NVL(QTY348, 0)) AS QTY348, SUM(NVL(QTY349, 0)) AS QTY349, SUM(NVL(QTY350, 0)) AS QTY350
                       , SUM(NVL(QTY351, 0)) AS QTY351, SUM(NVL(QTY352, 0)) AS QTY352, SUM(NVL(QTY353, 0)) AS QTY353, SUM(NVL(QTY354, 0)) AS QTY354, SUM(NVL(QTY355, 0)) AS QTY355
                       , SUM(NVL(QTY356, 0)) AS QTY356, SUM(NVL(QTY357, 0)) AS QTY357, SUM(NVL(QTY358, 0)) AS QTY358, SUM(NVL(QTY359, 0)) AS QTY359, SUM(NVL(QTY360, 0)) AS QTY360
                       , SUM(NVL(QTY361, 0)) AS QTY361, SUM(NVL(QTY362, 0)) AS QTY362, SUM(NVL(QTY363, 0)) AS QTY363, SUM(NVL(QTY364, 0)) AS QTY364
                    FROM GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW
                   PIVOT (
                          SUM(QTY) FOR COLS_NAME IN (
                                        'QTY001' AS QTY001, 'QTY002' AS QTY002, 'QTY003' AS QTY003, 'QTY004' AS QTY004, 'QTY005' AS QTY005, 'QTY006' AS QTY006
                                      , 'QTY007' AS QTY007, 'QTY008' AS QTY008, 'QTY009' AS QTY009, 'QTY010' AS QTY010, 'QTY011' AS QTY011, 'QTY012' AS QTY012
                                      , 'QTY013' AS QTY013, 'QTY014' AS QTY014, 'QTY015' AS QTY015, 'QTY016' AS QTY016, 'QTY017' AS QTY017, 'QTY018' AS QTY018
                                      , 'QTY019' AS QTY019, 'QTY020' AS QTY020, 'QTY021' AS QTY021, 'QTY022' AS QTY022, 'QTY023' AS QTY023, 'QTY024' AS QTY024
                                      , 'QTY025' AS QTY025, 'QTY026' AS QTY026, 'QTY027' AS QTY027, 'QTY028' AS QTY028, 'QTY029' AS QTY029, 'QTY030' AS QTY030
                                      , 'QTY031' AS QTY031, 'QTY032' AS QTY032, 'QTY033' AS QTY033, 'QTY034' AS QTY034, 'QTY035' AS QTY035, 'QTY036' AS QTY036
                                      , 'QTY037' AS QTY037, 'QTY038' AS QTY038, 'QTY039' AS QTY039, 'QTY040' AS QTY040, 'QTY041' AS QTY041, 'QTY042' AS QTY042
                                      , 'QTY043' AS QTY043, 'QTY044' AS QTY044, 'QTY045' AS QTY045, 'QTY046' AS QTY046, 'QTY047' AS QTY047, 'QTY048' AS QTY048
                                      , 'QTY049' AS QTY049, 'QTY050' AS QTY050, 'QTY051' AS QTY051, 'QTY052' AS QTY052, 'QTY053' AS QTY053, 'QTY054' AS QTY054
                                      , 'QTY055' AS QTY055, 'QTY056' AS QTY056, 'QTY057' AS QTY057, 'QTY058' AS QTY058, 'QTY059' AS QTY059, 'QTY060' AS QTY060
                                      , 'QTY061' AS QTY061, 'QTY062' AS QTY062, 'QTY063' AS QTY063, 'QTY064' AS QTY064, 'QTY065' AS QTY065, 'QTY066' AS QTY066
                                      , 'QTY067' AS QTY067, 'QTY068' AS QTY068, 'QTY069' AS QTY069, 'QTY070' AS QTY070, 'QTY071' AS QTY071, 'QTY072' AS QTY072
                                      , 'QTY073' AS QTY073, 'QTY074' AS QTY074, 'QTY075' AS QTY075, 'QTY076' AS QTY076, 'QTY077' AS QTY077, 'QTY078' AS QTY078
                                      , 'QTY079' AS QTY079, 'QTY080' AS QTY080, 'QTY081' AS QTY081, 'QTY082' AS QTY082, 'QTY083' AS QTY083, 'QTY084' AS QTY084
                                      , 'QTY085' AS QTY085, 'QTY086' AS QTY086, 'QTY087' AS QTY087, 'QTY088' AS QTY088, 'QTY089' AS QTY089, 'QTY090' AS QTY090
                                      , 'QTY091' AS QTY091, 'QTY092' AS QTY092, 'QTY093' AS QTY093, 'QTY094' AS QTY094, 'QTY095' AS QTY095, 'QTY096' AS QTY096
                                      , 'QTY097' AS QTY097, 'QTY098' AS QTY098, 'QTY099' AS QTY099, 'QTY100' AS QTY100, 'QTY101' AS QTY101, 'QTY102' AS QTY102
                                      , 'QTY103' AS QTY103, 'QTY104' AS QTY104, 'QTY105' AS QTY105, 'QTY106' AS QTY106, 'QTY107' AS QTY107, 'QTY108' AS QTY108
                                      , 'QTY109' AS QTY109, 'QTY110' AS QTY110, 'QTY111' AS QTY111, 'QTY112' AS QTY112, 'QTY113' AS QTY113, 'QTY114' AS QTY114
                                      , 'QTY115' AS QTY115, 'QTY116' AS QTY116, 'QTY117' AS QTY117, 'QTY118' AS QTY118, 'QTY119' AS QTY119, 'QTY120' AS QTY120
                                      , 'QTY121' AS QTY121, 'QTY122' AS QTY122, 'QTY123' AS QTY123, 'QTY124' AS QTY124, 'QTY125' AS QTY125, 'QTY126' AS QTY126
                                      , 'QTY127' AS QTY127, 'QTY128' AS QTY128, 'QTY129' AS QTY129, 'QTY130' AS QTY130, 'QTY131' AS QTY131, 'QTY132' AS QTY132
                                      , 'QTY133' AS QTY133, 'QTY134' AS QTY134, 'QTY135' AS QTY135, 'QTY136' AS QTY136, 'QTY137' AS QTY137, 'QTY138' AS QTY138
                                      , 'QTY139' AS QTY139, 'QTY140' AS QTY140, 'QTY141' AS QTY141, 'QTY142' AS QTY142, 'QTY143' AS QTY143, 'QTY144' AS QTY144
                                      , 'QTY145' AS QTY145, 'QTY146' AS QTY146, 'QTY147' AS QTY147, 'QTY148' AS QTY148, 'QTY149' AS QTY149, 'QTY150' AS QTY150
                                      , 'QTY151' AS QTY151, 'QTY152' AS QTY152, 'QTY153' AS QTY153, 'QTY154' AS QTY154, 'QTY155' AS QTY155, 'QTY156' AS QTY156
                                      , 'QTY157' AS QTY157, 'QTY158' AS QTY158, 'QTY159' AS QTY159, 'QTY160' AS QTY160, 'QTY161' AS QTY161, 'QTY162' AS QTY162
                                      , 'QTY163' AS QTY163, 'QTY164' AS QTY164, 'QTY165' AS QTY165, 'QTY166' AS QTY166, 'QTY167' AS QTY167, 'QTY168' AS QTY168
                                      , 'QTY169' AS QTY169, 'QTY170' AS QTY170, 'QTY171' AS QTY171, 'QTY172' AS QTY172, 'QTY173' AS QTY173, 'QTY174' AS QTY174
                                      , 'QTY175' AS QTY175, 'QTY176' AS QTY176, 'QTY177' AS QTY177, 'QTY178' AS QTY178, 'QTY179' AS QTY179, 'QTY180' AS QTY180
                                      , 'QTY181' AS QTY181, 'QTY182' AS QTY182, 'QTY183' AS QTY183, 'QTY184' AS QTY184, 'QTY185' AS QTY185, 'QTY186' AS QTY186
                                      , 'QTY187' AS QTY187, 'QTY188' AS QTY188, 'QTY189' AS QTY189, 'QTY190' AS QTY190, 'QTY191' AS QTY191, 'QTY192' AS QTY192
                                      , 'QTY193' AS QTY193, 'QTY194' AS QTY194, 'QTY195' AS QTY195, 'QTY196' AS QTY196, 'QTY197' AS QTY197, 'QTY198' AS QTY198
                                      , 'QTY199' AS QTY199, 'QTY200' AS QTY200, 'QTY201' AS QTY201, 'QTY202' AS QTY202, 'QTY203' AS QTY203, 'QTY204' AS QTY204
                                      , 'QTY205' AS QTY205, 'QTY206' AS QTY206, 'QTY207' AS QTY207, 'QTY208' AS QTY208, 'QTY209' AS QTY209, 'QTY210' AS QTY210
                                      , 'QTY211' AS QTY211, 'QTY212' AS QTY212, 'QTY213' AS QTY213, 'QTY214' AS QTY214, 'QTY215' AS QTY215, 'QTY216' AS QTY216
                                      , 'QTY217' AS QTY217, 'QTY218' AS QTY218, 'QTY219' AS QTY219, 'QTY220' AS QTY220, 'QTY221' AS QTY221, 'QTY222' AS QTY222
                                      , 'QTY223' AS QTY223, 'QTY224' AS QTY224, 'QTY225' AS QTY225, 'QTY226' AS QTY226, 'QTY227' AS QTY227, 'QTY228' AS QTY228
                                      , 'QTY229' AS QTY229, 'QTY230' AS QTY230, 'QTY231' AS QTY231, 'QTY232' AS QTY232, 'QTY233' AS QTY233, 'QTY234' AS QTY234
                                      , 'QTY235' AS QTY235, 'QTY236' AS QTY236, 'QTY237' AS QTY237, 'QTY238' AS QTY238, 'QTY239' AS QTY239, 'QTY240' AS QTY240
                                      , 'QTY241' AS QTY241, 'QTY242' AS QTY242, 'QTY243' AS QTY243, 'QTY244' AS QTY244, 'QTY245' AS QTY245, 'QTY246' AS QTY246
                                      , 'QTY247' AS QTY247, 'QTY248' AS QTY248, 'QTY249' AS QTY249, 'QTY250' AS QTY250, 'QTY251' AS QTY251, 'QTY252' AS QTY252
                                      , 'QTY253' AS QTY253, 'QTY254' AS QTY254, 'QTY255' AS QTY255, 'QTY256' AS QTY256, 'QTY257' AS QTY257, 'QTY258' AS QTY258
                                      , 'QTY259' AS QTY259, 'QTY260' AS QTY260, 'QTY261' AS QTY261, 'QTY262' AS QTY262, 'QTY263' AS QTY263, 'QTY264' AS QTY264
                                      , 'QTY265' AS QTY265, 'QTY266' AS QTY266, 'QTY267' AS QTY267, 'QTY268' AS QTY268, 'QTY269' AS QTY269, 'QTY270' AS QTY270
                                      , 'QTY271' AS QTY271, 'QTY272' AS QTY272, 'QTY273' AS QTY273, 'QTY274' AS QTY274, 'QTY275' AS QTY275, 'QTY276' AS QTY276
                                      , 'QTY277' AS QTY277, 'QTY278' AS QTY278, 'QTY279' AS QTY279, 'QTY280' AS QTY280, 'QTY281' AS QTY281, 'QTY282' AS QTY282
                                      , 'QTY283' AS QTY283, 'QTY284' AS QTY284, 'QTY285' AS QTY285, 'QTY286' AS QTY286, 'QTY287' AS QTY287, 'QTY288' AS QTY288
                                      , 'QTY289' AS QTY289, 'QTY290' AS QTY290, 'QTY291' AS QTY291, 'QTY292' AS QTY292, 'QTY293' AS QTY293, 'QTY294' AS QTY294
                                      , 'QTY295' AS QTY295, 'QTY296' AS QTY296, 'QTY297' AS QTY297, 'QTY298' AS QTY298, 'QTY299' AS QTY299, 'QTY300' AS QTY300
                                      , 'QTY301' AS QTY301, 'QTY302' AS QTY302, 'QTY303' AS QTY303, 'QTY304' AS QTY304, 'QTY305' AS QTY305, 'QTY306' AS QTY306
                                      , 'QTY307' AS QTY307, 'QTY308' AS QTY308, 'QTY309' AS QTY309, 'QTY310' AS QTY310, 'QTY311' AS QTY311, 'QTY312' AS QTY312
                                      , 'QTY313' AS QTY313, 'QTY314' AS QTY314, 'QTY315' AS QTY315, 'QTY316' AS QTY316, 'QTY317' AS QTY317, 'QTY318' AS QTY318
                                      , 'QTY319' AS QTY319, 'QTY320' AS QTY320, 'QTY321' AS QTY321, 'QTY322' AS QTY322, 'QTY323' AS QTY323, 'QTY324' AS QTY324
                                      , 'QTY325' AS QTY325, 'QTY326' AS QTY326, 'QTY327' AS QTY327, 'QTY328' AS QTY328, 'QTY329' AS QTY329, 'QTY330' AS QTY330
                                      , 'QTY331' AS QTY331, 'QTY332' AS QTY332, 'QTY333' AS QTY333, 'QTY334' AS QTY334, 'QTY335' AS QTY335, 'QTY336' AS QTY336
                                      , 'QTY337' AS QTY337, 'QTY338' AS QTY338, 'QTY339' AS QTY339, 'QTY340' AS QTY340, 'QTY341' AS QTY341, 'QTY342' AS QTY342
                                      , 'QTY343' AS QTY343, 'QTY344' AS QTY344, 'QTY345' AS QTY345, 'QTY346' AS QTY346, 'QTY347' AS QTY347, 'QTY348' AS QTY348
                                      , 'QTY349' AS QTY349, 'QTY350' AS QTY350, 'QTY351' AS QTY351, 'QTY352' AS QTY352, 'QTY353' AS QTY353, 'QTY354' AS QTY354
                                      , 'QTY355' AS QTY355, 'QTY356' AS QTY356, 'QTY357' AS QTY357, 'QTY358' AS QTY358, 'QTY359' AS QTY359, 'QTY360' AS QTY360
                                      , 'QTY361' AS QTY361, 'QTY362' AS QTY362, 'QTY363' AS QTY363, 'QTY364' AS QTY364
                                                    )
                         ) UN
                       ;

                  /*  MSSQL UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL_ESS X INNER JOIN #SCP_XLS_PSI_GLOBAL_ESS_MODIFY Y
                      -> 원천 Y 는 집계(SUM) 결과 1행이지만 계열 형제와 동일하게 상관 UPDATE + EXISTS + ROWNUM = 1 로 */
                  UPDATE SCP_XLS_PSI_GLOBAL_ESS X
                     SET (
                           QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008
                         , QTY009, QTY010, QTY011, QTY012, QTY013, QTY014, QTY015, QTY016
                         , QTY017, QTY018, QTY019, QTY020, QTY021, QTY022, QTY023, QTY024
                         , QTY025, QTY026, QTY027, QTY028, QTY029, QTY030, QTY031, QTY032
                         , QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                         , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048
                         , QTY049, QTY050, QTY051, QTY052, QTY053, QTY054, QTY055, QTY056
                         , QTY057, QTY058, QTY059, QTY060, QTY061, QTY062, QTY063, QTY064
                         , QTY065, QTY066, QTY067, QTY068, QTY069, QTY070, QTY071, QTY072
                         , QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                         , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088
                         , QTY089, QTY090, QTY091, QTY092, QTY093, QTY094, QTY095, QTY096
                         , QTY097, QTY098, QTY099, QTY100, QTY101, QTY102, QTY103, QTY104
                         , QTY105, QTY106, QTY107, QTY108, QTY109, QTY110, QTY111, QTY112
                         , QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                         , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128
                         , QTY129, QTY130, QTY131, QTY132, QTY133, QTY134, QTY135, QTY136
                         , QTY137, QTY138, QTY139, QTY140, QTY141, QTY142, QTY143, QTY144
                         , QTY145, QTY146, QTY147, QTY148, QTY149, QTY150, QTY151, QTY152
                         , QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                         , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168
                         , QTY169, QTY170, QTY171, QTY172, QTY173, QTY174, QTY175, QTY176
                         , QTY177, QTY178, QTY179, QTY180, QTY181, QTY182, QTY183, QTY184
                         , QTY185, QTY186, QTY187, QTY188, QTY189, QTY190, QTY191, QTY192
                         , QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                         , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208
                         , QTY209, QTY210, QTY211, QTY212, QTY213, QTY214, QTY215, QTY216
                         , QTY217, QTY218, QTY219, QTY220, QTY221, QTY222, QTY223, QTY224
                         , QTY225, QTY226, QTY227, QTY228, QTY229, QTY230, QTY231, QTY232
                         , QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                         , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248
                         , QTY249, QTY250, QTY251, QTY252, QTY253, QTY254, QTY255, QTY256
                         , QTY257, QTY258, QTY259, QTY260, QTY261, QTY262, QTY263, QTY264
                         , QTY265, QTY266, QTY267, QTY268, QTY269, QTY270, QTY271, QTY272
                         , QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                         , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288
                         , QTY289, QTY290, QTY291, QTY292, QTY293, QTY294, QTY295, QTY296
                         , QTY297, QTY298, QTY299, QTY300, QTY301, QTY302, QTY303, QTY304
                         , QTY305, QTY306, QTY307, QTY308, QTY309, QTY310, QTY311, QTY312
                         , QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                         , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328
                         , QTY329, QTY330, QTY331, QTY332, QTY333, QTY334, QTY335, QTY336
                         , QTY337, QTY338, QTY339, QTY340, QTY341, QTY342, QTY343, QTY344
                         , QTY345, QTY346, QTY347, QTY348, QTY349, QTY350, QTY351, QTY352
                         , QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                         , QTY361, QTY362, QTY363, QTY364, WQTY01, WQTY02, WQTY03, WQTY04
                         , WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10, WQTY11, WQTY12
                         , WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                         , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28
                         , WQTY29, WQTY30, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36
                         , WQTY37, WQTY38, WQTY39, WQTY40, WQTY41, WQTY42, WQTY43, WQTY44
                         , WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50, WQTY51, WQTY52
                         , LAST_UPDATED_BY, LAST_UPDATE_DATE
                         ) =
                         ( SELECT
                             Y.QTY001, Y.QTY002, Y.QTY003, Y.QTY004, Y.QTY005, Y.QTY006, Y.QTY007, Y.QTY008
                           , Y.QTY009, Y.QTY010, Y.QTY011, Y.QTY012, Y.QTY013, Y.QTY014, Y.QTY015, Y.QTY016
                           , Y.QTY017, Y.QTY018, Y.QTY019, Y.QTY020, Y.QTY021, Y.QTY022, Y.QTY023, Y.QTY024
                           , Y.QTY025, Y.QTY026, Y.QTY027, Y.QTY028, Y.QTY029, Y.QTY030, Y.QTY031, Y.QTY032
                           , Y.QTY033, Y.QTY034, Y.QTY035, Y.QTY036, Y.QTY037, Y.QTY038, Y.QTY039, Y.QTY040
                           , Y.QTY041, Y.QTY042, Y.QTY043, Y.QTY044, Y.QTY045, Y.QTY046, Y.QTY047, Y.QTY048
                           , Y.QTY049, Y.QTY050, Y.QTY051, Y.QTY052, Y.QTY053, Y.QTY054, Y.QTY055, Y.QTY056
                           , Y.QTY057, Y.QTY058, Y.QTY059, Y.QTY060, Y.QTY061, Y.QTY062, Y.QTY063, Y.QTY064
                           , Y.QTY065, Y.QTY066, Y.QTY067, Y.QTY068, Y.QTY069, Y.QTY070, Y.QTY071, Y.QTY072
                           , Y.QTY073, Y.QTY074, Y.QTY075, Y.QTY076, Y.QTY077, Y.QTY078, Y.QTY079, Y.QTY080
                           , Y.QTY081, Y.QTY082, Y.QTY083, Y.QTY084, Y.QTY085, Y.QTY086, Y.QTY087, Y.QTY088
                           , Y.QTY089, Y.QTY090, Y.QTY091, Y.QTY092, Y.QTY093, Y.QTY094, Y.QTY095, Y.QTY096
                           , Y.QTY097, Y.QTY098, Y.QTY099, Y.QTY100, Y.QTY101, Y.QTY102, Y.QTY103, Y.QTY104
                           , Y.QTY105, Y.QTY106, Y.QTY107, Y.QTY108, Y.QTY109, Y.QTY110, Y.QTY111, Y.QTY112
                           , Y.QTY113, Y.QTY114, Y.QTY115, Y.QTY116, Y.QTY117, Y.QTY118, Y.QTY119, Y.QTY120
                           , Y.QTY121, Y.QTY122, Y.QTY123, Y.QTY124, Y.QTY125, Y.QTY126, Y.QTY127, Y.QTY128
                           , Y.QTY129, Y.QTY130, Y.QTY131, Y.QTY132, Y.QTY133, Y.QTY134, Y.QTY135, Y.QTY136
                           , Y.QTY137, Y.QTY138, Y.QTY139, Y.QTY140, Y.QTY141, Y.QTY142, Y.QTY143, Y.QTY144
                           , Y.QTY145, Y.QTY146, Y.QTY147, Y.QTY148, Y.QTY149, Y.QTY150, Y.QTY151, Y.QTY152
                           , Y.QTY153, Y.QTY154, Y.QTY155, Y.QTY156, Y.QTY157, Y.QTY158, Y.QTY159, Y.QTY160
                           , Y.QTY161, Y.QTY162, Y.QTY163, Y.QTY164, Y.QTY165, Y.QTY166, Y.QTY167, Y.QTY168
                           , Y.QTY169, Y.QTY170, Y.QTY171, Y.QTY172, Y.QTY173, Y.QTY174, Y.QTY175, Y.QTY176
                           , Y.QTY177, Y.QTY178, Y.QTY179, Y.QTY180, Y.QTY181, Y.QTY182, Y.QTY183, Y.QTY184
                           , Y.QTY185, Y.QTY186, Y.QTY187, Y.QTY188, Y.QTY189, Y.QTY190, Y.QTY191, Y.QTY192
                           , Y.QTY193, Y.QTY194, Y.QTY195, Y.QTY196, Y.QTY197, Y.QTY198, Y.QTY199, Y.QTY200
                           , Y.QTY201, Y.QTY202, Y.QTY203, Y.QTY204, Y.QTY205, Y.QTY206, Y.QTY207, Y.QTY208
                           , Y.QTY209, Y.QTY210, Y.QTY211, Y.QTY212, Y.QTY213, Y.QTY214, Y.QTY215, Y.QTY216
                           , Y.QTY217, Y.QTY218, Y.QTY219, Y.QTY220, Y.QTY221, Y.QTY222, Y.QTY223, Y.QTY224
                           , Y.QTY225, Y.QTY226, Y.QTY227, Y.QTY228, Y.QTY229, Y.QTY230, Y.QTY231, Y.QTY232
                           , Y.QTY233, Y.QTY234, Y.QTY235, Y.QTY236, Y.QTY237, Y.QTY238, Y.QTY239, Y.QTY240
                           , Y.QTY241, Y.QTY242, Y.QTY243, Y.QTY244, Y.QTY245, Y.QTY246, Y.QTY247, Y.QTY248
                           , Y.QTY249, Y.QTY250, Y.QTY251, Y.QTY252, Y.QTY253, Y.QTY254, Y.QTY255, Y.QTY256
                           , Y.QTY257, Y.QTY258, Y.QTY259, Y.QTY260, Y.QTY261, Y.QTY262, Y.QTY263, Y.QTY264
                           , Y.QTY265, Y.QTY266, Y.QTY267, Y.QTY268, Y.QTY269, Y.QTY270, Y.QTY271, Y.QTY272
                           , Y.QTY273, Y.QTY274, Y.QTY275, Y.QTY276, Y.QTY277, Y.QTY278, Y.QTY279, Y.QTY280
                           , Y.QTY281, Y.QTY282, Y.QTY283, Y.QTY284, Y.QTY285, Y.QTY286, Y.QTY287, Y.QTY288
                           , Y.QTY289, Y.QTY290, Y.QTY291, Y.QTY292, Y.QTY293, Y.QTY294, Y.QTY295, Y.QTY296
                           , Y.QTY297, Y.QTY298, Y.QTY299, Y.QTY300, Y.QTY301, Y.QTY302, Y.QTY303, Y.QTY304
                           , Y.QTY305, Y.QTY306, Y.QTY307, Y.QTY308, Y.QTY309, Y.QTY310, Y.QTY311, Y.QTY312
                           , Y.QTY313, Y.QTY314, Y.QTY315, Y.QTY316, Y.QTY317, Y.QTY318, Y.QTY319, Y.QTY320
                           , Y.QTY321, Y.QTY322, Y.QTY323, Y.QTY324, Y.QTY325, Y.QTY326, Y.QTY327, Y.QTY328
                           , Y.QTY329, Y.QTY330, Y.QTY331, Y.QTY332, Y.QTY333, Y.QTY334, Y.QTY335, Y.QTY336
                           , Y.QTY337, Y.QTY338, Y.QTY339, Y.QTY340, Y.QTY341, Y.QTY342, Y.QTY343, Y.QTY344
                           , Y.QTY345, Y.QTY346, Y.QTY347, Y.QTY348, Y.QTY349, Y.QTY350, Y.QTY351, Y.QTY352
                           , Y.QTY353, Y.QTY354, Y.QTY355, Y.QTY356, Y.QTY357, Y.QTY358, Y.QTY359, Y.QTY360
                           , Y.QTY361, Y.QTY362, Y.QTY363, Y.QTY364
                           , Y.QTY001 + Y.QTY002 + Y.QTY003 + Y.QTY004 + Y.QTY005 + Y.QTY006 + Y.QTY007
                           , Y.QTY008 + Y.QTY009 + Y.QTY010 + Y.QTY011 + Y.QTY012 + Y.QTY013 + Y.QTY014
                           , Y.QTY015 + Y.QTY016 + Y.QTY017 + Y.QTY018 + Y.QTY019 + Y.QTY020 + Y.QTY021
                           , Y.QTY022 + Y.QTY023 + Y.QTY024 + Y.QTY025 + Y.QTY026 + Y.QTY027 + Y.QTY028
                           , Y.QTY029 + Y.QTY030 + Y.QTY031 + Y.QTY032 + Y.QTY033 + Y.QTY034 + Y.QTY035
                           , Y.QTY036 + Y.QTY037 + Y.QTY038 + Y.QTY039 + Y.QTY040 + Y.QTY041 + Y.QTY042
                           , Y.QTY043 + Y.QTY044 + Y.QTY045 + Y.QTY046 + Y.QTY047 + Y.QTY048 + Y.QTY049
                           , Y.QTY050 + Y.QTY051 + Y.QTY052 + Y.QTY053 + Y.QTY054 + Y.QTY055 + Y.QTY056
                           , Y.QTY057 + Y.QTY058 + Y.QTY059 + Y.QTY060 + Y.QTY061 + Y.QTY062 + Y.QTY063
                           , Y.QTY064 + Y.QTY065 + Y.QTY066 + Y.QTY067 + Y.QTY068 + Y.QTY069 + Y.QTY070
                           , Y.QTY071 + Y.QTY072 + Y.QTY073 + Y.QTY074 + Y.QTY075 + Y.QTY076 + Y.QTY077
                           , Y.QTY078 + Y.QTY079 + Y.QTY080 + Y.QTY081 + Y.QTY082 + Y.QTY083 + Y.QTY084
                           , Y.QTY085 + Y.QTY086 + Y.QTY087 + Y.QTY088 + Y.QTY089 + Y.QTY090 + Y.QTY091
                           , Y.QTY092 + Y.QTY093 + Y.QTY094 + Y.QTY095 + Y.QTY096 + Y.QTY097 + Y.QTY098
                           , Y.QTY099 + Y.QTY100 + Y.QTY101 + Y.QTY102 + Y.QTY103 + Y.QTY104 + Y.QTY105
                           , Y.QTY106 + Y.QTY107 + Y.QTY108 + Y.QTY109 + Y.QTY110 + Y.QTY111 + Y.QTY112
                           , Y.QTY113 + Y.QTY114 + Y.QTY115 + Y.QTY116 + Y.QTY117 + Y.QTY118 + Y.QTY119
                           , Y.QTY120 + Y.QTY121 + Y.QTY122 + Y.QTY123 + Y.QTY124 + Y.QTY125 + Y.QTY126
                           , Y.QTY127 + Y.QTY128 + Y.QTY129 + Y.QTY130 + Y.QTY131 + Y.QTY132 + Y.QTY133
                           , Y.QTY134 + Y.QTY135 + Y.QTY136 + Y.QTY137 + Y.QTY138 + Y.QTY139 + Y.QTY140
                           , Y.QTY141 + Y.QTY142 + Y.QTY143 + Y.QTY144 + Y.QTY145 + Y.QTY146 + Y.QTY147
                           , Y.QTY148 + Y.QTY149 + Y.QTY150 + Y.QTY151 + Y.QTY152 + Y.QTY153 + Y.QTY154
                           , Y.QTY155 + Y.QTY156 + Y.QTY157 + Y.QTY158 + Y.QTY159 + Y.QTY160 + Y.QTY161
                           , Y.QTY162 + Y.QTY163 + Y.QTY164 + Y.QTY165 + Y.QTY166 + Y.QTY167 + Y.QTY168
                           , Y.QTY169 + Y.QTY170 + Y.QTY171 + Y.QTY172 + Y.QTY173 + Y.QTY174 + Y.QTY175
                           , Y.QTY176 + Y.QTY177 + Y.QTY178 + Y.QTY179 + Y.QTY180 + Y.QTY181 + Y.QTY182
                           , Y.QTY183 + Y.QTY184 + Y.QTY185 + Y.QTY186 + Y.QTY187 + Y.QTY188 + Y.QTY189
                           , Y.QTY190 + Y.QTY191 + Y.QTY192 + Y.QTY193 + Y.QTY194 + Y.QTY195 + Y.QTY196
                           , Y.QTY197 + Y.QTY198 + Y.QTY199 + Y.QTY200 + Y.QTY201 + Y.QTY202 + Y.QTY203
                           , Y.QTY204 + Y.QTY205 + Y.QTY206 + Y.QTY207 + Y.QTY208 + Y.QTY209 + Y.QTY210
                           , Y.QTY211 + Y.QTY212 + Y.QTY213 + Y.QTY214 + Y.QTY215 + Y.QTY216 + Y.QTY217
                           , Y.QTY218 + Y.QTY219 + Y.QTY220 + Y.QTY221 + Y.QTY222 + Y.QTY223 + Y.QTY224
                           , Y.QTY225 + Y.QTY226 + Y.QTY227 + Y.QTY228 + Y.QTY229 + Y.QTY230 + Y.QTY231
                           , Y.QTY232 + Y.QTY233 + Y.QTY234 + Y.QTY235 + Y.QTY236 + Y.QTY237 + Y.QTY238
                           , Y.QTY239 + Y.QTY240 + Y.QTY241 + Y.QTY242 + Y.QTY243 + Y.QTY244 + Y.QTY245
                           , Y.QTY246 + Y.QTY247 + Y.QTY248 + Y.QTY249 + Y.QTY250 + Y.QTY251 + Y.QTY252
                           , Y.QTY253 + Y.QTY254 + Y.QTY255 + Y.QTY256 + Y.QTY257 + Y.QTY258 + Y.QTY259
                           , Y.QTY260 + Y.QTY261 + Y.QTY262 + Y.QTY263 + Y.QTY264 + Y.QTY265 + Y.QTY266
                           , Y.QTY267 + Y.QTY268 + Y.QTY269 + Y.QTY270 + Y.QTY271 + Y.QTY272 + Y.QTY273
                           , Y.QTY274 + Y.QTY275 + Y.QTY276 + Y.QTY277 + Y.QTY278 + Y.QTY279 + Y.QTY280
                           , Y.QTY281 + Y.QTY282 + Y.QTY283 + Y.QTY284 + Y.QTY285 + Y.QTY286 + Y.QTY287
                           , Y.QTY288 + Y.QTY289 + Y.QTY290 + Y.QTY291 + Y.QTY292 + Y.QTY293 + Y.QTY294
                           , Y.QTY295 + Y.QTY296 + Y.QTY297 + Y.QTY298 + Y.QTY299 + Y.QTY300 + Y.QTY301
                           , Y.QTY302 + Y.QTY303 + Y.QTY304 + Y.QTY305 + Y.QTY306 + Y.QTY307 + Y.QTY308
                           , Y.QTY309 + Y.QTY310 + Y.QTY311 + Y.QTY312 + Y.QTY313 + Y.QTY314 + Y.QTY315
                           , Y.QTY316 + Y.QTY317 + Y.QTY318 + Y.QTY319 + Y.QTY320 + Y.QTY321 + Y.QTY322
                           , Y.QTY323 + Y.QTY324 + Y.QTY325 + Y.QTY326 + Y.QTY327 + Y.QTY328 + Y.QTY329
                           , Y.QTY330 + Y.QTY331 + Y.QTY332 + Y.QTY333 + Y.QTY334 + Y.QTY335 + Y.QTY336
                           , Y.QTY337 + Y.QTY338 + Y.QTY339 + Y.QTY340 + Y.QTY341 + Y.QTY342 + Y.QTY343
                           , Y.QTY344 + Y.QTY345 + Y.QTY346 + Y.QTY347 + Y.QTY348 + Y.QTY349 + Y.QTY350
                           , Y.QTY351 + Y.QTY352 + Y.QTY353 + Y.QTY354 + Y.QTY355 + Y.QTY356 + Y.QTY357
                           , Y.QTY358 + Y.QTY359 + Y.QTY360 + Y.QTY361 + Y.QTY362 + Y.QTY363 + Y.QTY364
                                , V_BATCH_USER
                                , SYSDATE
                             FROM GT_XPGT_XP06S_SCP_XLS_PSI_GLOBAL_ESS_MODIFY Y
                            WHERE X.XLS_KEY1             = Y.XLS_KEY1
                              AND X.DIVISION_ID          = Y.DIVISION_ID
                              AND X.CREATE_FROM_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD
                              AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                              AND ROWNUM = 1 )
                   WHERE EXISTS ( SELECT 1
                                    FROM GT_XPGT_XP06S_SCP_XLS_PSI_GLOBAL_ESS_MODIFY Y
                                   WHERE X.XLS_KEY1             = Y.XLS_KEY1
                                     AND X.DIVISION_ID          = Y.DIVISION_ID
                                     AND X.CREATE_FROM_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD
                                     AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD )
                       ;

            /*  IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY_ROW') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY_ROW; */
                  DELETE FROM GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW;

                 /* PRINT @v_batch_measure + '52. ' +CONVERT(CHAR(23), GETDATE(), 21); */

              IF V_BATCH_MEASURE IN ('PACK_PROD', 'CELL_PROD') THEN
              /* ------------------------------------------------------------------------------------------- */
              /*  LINE_TOTAL_LOAD_ENGINE UPDATE (TACT_TIME,WORKING_TIME)  , PACK_PROD_LOAD,CELL_PROD_LOAD */
              /* ------------------------------------------------------------------------------------------- */
              /* ------------------------------------------------------------------------------------------- */
              /*  Line Load 율 로직 작업중 */
              /* ------------------------------------------------------------------------------------------- */
              /*  IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL DROP TABLE #LINE_WORKINGTIME_BY_LOSS; */
              DELETE FROM GT_XPGT_LINE_WORKINGTIME_LOSS;

                V_LINE_ID := '';

                /*  MSSQL 대입형 SELECT -> 커서 FOR 루프(0행=변수유지, 다행=마지막행) */
                FOR R IN ( SELECT PROD_LINE
                             FROM SCP_XLS_PSI_GLOBAL_ESS
                            WHERE XLS_KEY1             = V_BATCH_XLS_KEY1
                              AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD )
                LOOP
                    V_LINE_ID := R.PROD_LINE;
                END LOOP;

                /* Working Time 추출 */
                /*  MSSQL 인라인 TVF dbo.FN_LINE_WORKINGTIME_BY_LOSS(..) -> Oracle 파이프라인 테이블함수 TABLE(..) (CV-039) */
                INSERT INTO GT_XPGT_LINE_WORKINGTIME_LOSS
                     ( DIVISION_ID
                     , SCM_SITE_ID
                     , OPERATION_ID
                     , LINE_ID
                     , YYYYMMDD
                     , WORKING_TIME )
                SELECT DIVISION_ID
                     , PLANT_SITE_ID AS SCM_SITE_ID
                     , OPERATION_ID
                     , LINE_ID
                     , YYYYMMDD
                     , WORKING_TIME
                  FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS(V_BATCH_DIVISION_ID, V_BATCH_CREATE_FROM_YYYYMMDD, V_P_TO_YYYYMMDD, V_LINE_ID))
                 WHERE LINE_ID = V_LINE_ID
                     ;

                /*  IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL DROP TABLE #LineLoad
                      이 프로시저는 그 컬럼을 쓰지 않는다) -> 컬럼목록 명시 INSERT 필수(SELECT * 금지). */
                DELETE FROM GT_XPGT_LINELOAD;

                INSERT INTO GT_XPGT_LINELOAD
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
                     , WEEK_COLUMN )
            SELECT /*DISTINCT */
                   A.DIVISION_ID
                 , A.SCM_SITE_ID
                 , A.OPERATION_GROUP
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                         WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                    END) AS MEASURE
                 , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
                        ELSE NVL(((ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME)), 0) * 100
                   END AS QTY
                 , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0) AS CAPA_TACT
                 , NVL(D.WORKING_TIME, 0) AS WORKING_TIME
                 , A.YYYYMMDD AS YYYYMMDD
                 , C.ISO_YYYYWW AS ISO_YYYYWW
                 , 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW)), 2, '0') AS WEEK_COLUMN
              FROM SCP_ANL_PRODUCTION_PLAN A
                 , SCM_SYS_CALENDAR_M C
                 , GT_XPGT_LINE_WORKINGTIME_LOSS D
                 , SCP_ANL_TACT_TIME E
             WHERE 1 = 1
               AND A.YYYYMMDD           = C.BASIS_YYYYMMDD
               AND A.DIVISION_ID        = D.DIVISION_ID(+)
               AND A.OPERATION_ID       = D.OPERATION_ID(+)
               AND A.SCM_SITE_ID        = D.SCM_SITE_ID(+)
               AND A.LINE_ID            = D.LINE_ID(+)
               AND A.YYYYMMDD           = D.YYYYMMDD(+)
               AND A.DIVISION_ID        = E.DIVISION_ID(+)
               AND A.OPERATION_ID       = E.OPERATION_ID(+)
               AND A.SCM_SITE_ID        = E.SCM_SITE_ID(+)
               AND A.LINE_ID            = E.LINE_ID(+)
               AND A.ITEM_ID            = E.ITEM_ID(+)
               AND A.YYYYMMDD           = E.YYYYMMDD(+)
               AND A.DIVISION_ID         = V_BATCH_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = V_BATCH_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_BATCH_PLAN_TYPE
               AND A.SEQ                 = V_BATCH_SEQ
               /*  AND A.YYYYMMDD           >= @v_batch_create_from_yyyymmdd
                   AND A.YYYYMMDD           <  CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)  --@p_to_yyyymmdd */
               AND A.YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                  AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
               AND A.MEASURE             = 'PROD_PLAN_AMEND'
               AND A.LINE_ID             = V_LINE_ID
             GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.OPERATION_ID, A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME, C.ISO_YYYYWW, A.OPERATION_GROUP
                 , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                         WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                    END)
                 ;

            /* ------------------------------------------------------------------------------------------- */
            /*   364일 데이터 생성(PIVOIT 대상 날짜문자열 생성) */
            /* ------------------------------------------------------------------------------------------- */
              /*  MSSQL SELECT @v = @v + .. FROM (..) ORDER BY .. (행별 문자열 누적 트릭, EP-013) */
              V_MQRY_SUM := '';
              FOR R IN ( SELECT ' SUM(CASE WHEN YYYYMMDD = ''' || A.YYYYMMDD || '''    THEN QTY ELSE 0 END ) AS '
                                || 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.YYYYMMDD)), 3, '0') AS COL_EXPR
                           FROM ( SELECT A.BASIS_YYYYMMDD                      AS YYYYMMDD
                                       , A.BASIS_YYYYMMDD || TO_CHAR(31)       AS SORT_ORDER_NO
                                    FROM SCM_SYS_CALENDAR_M A
                                   WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                              AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
                                   /* WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                                        AND A.BASIS_YYYYMMDD     <  CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112) --@p_to_yyyymmdd */
                                   GROUP BY A.BASIS_YYYYMMDD
                                ) A
                          ORDER BY A.SORT_ORDER_NO )
              LOOP
                  V_MQRY_SUM := V_MQRY_SUM || ',' || R.COL_EXPR || '' || CHR(10);
              END LOOP;

              /*  MSSQL 동적 UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL_ESS X INNER JOIN (GROUP BY 인라인뷰) Y ON ..
                  -> 원천이 GROUP BY 로 조인키당 유일하므로 MERGE 로 옮긴다(CV-024).
                  ★MSSQL 은 INNER JOIN 의 ON 절 마지막에 X.CREATE_FROM_YYYYMMDD 상수조건을 덧붙인다 */
              V_MEXEC := '';
              V_MEXEC := V_MEXEC || 'MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X' || CHR(10);
              V_MEXEC := V_MEXEC || ' USING ( SELECT A.DIVISION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.OPERATION_GROUP' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.SCM_SITE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.OPERATION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.MEASURE' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.LINE_ID ' || CHR(10);
              V_MEXEC := V_MEXEC || '               ' || V_MQRY_SUM || '  ' || CHR(10);
              V_MEXEC := V_MEXEC || '           FROM GT_XPGT_LINELOAD A' || CHR(10);
              V_MEXEC := V_MEXEC || '          GROUP BY  A.DIVISION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.OPERATION_GROUP' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.SCM_SITE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.OPERATION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.MEASURE' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.LINE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '       ) Y ' || CHR(10);
              V_MEXEC := V_MEXEC || '    ON ( 0 = 0' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.OPERATION_GROUP   = Y.OPERATION_GROUP' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.FROM_SITE         = Y.SCM_SITE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.ATTRIBUTE9        = Y.OPERATION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.PROD_LINE         = Y.LINE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.MEASURE           = Y.MEASURE' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.CREATE_FROM_YYYYMMDD = ''' || V_BATCH_CREATE_FROM_YYYYMMDD || ''' )' || CHR(10);
              V_MEXEC := V_MEXEC || ' WHEN MATCHED THEN UPDATE SET ' || CHR(10);
              V_MEXEC := V_MEXEC || '       X.QTY001 = Y.QTY001, X.QTY002 = Y.QTY002, X.QTY003 = Y.QTY003, X.QTY004 = Y.QTY004, X.QTY005 = Y.QTY005, X.QTY006 = Y.QTY006, X.QTY007 = Y.QTY007, X.QTY008 = Y.QTY008, X.QTY009 = Y.QTY009, X.QTY010 = Y.QTY010' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY011 = Y.QTY011, X.QTY012 = Y.QTY012, X.QTY013 = Y.QTY013, X.QTY014 = Y.QTY014, X.QTY015 = Y.QTY015, X.QTY016 = Y.QTY016, X.QTY017 = Y.QTY017, X.QTY018 = Y.QTY018, X.QTY019 = Y.QTY019, X.QTY020 = Y.QTY020' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY021 = Y.QTY021, X.QTY022 = Y.QTY022, X.QTY023 = Y.QTY023, X.QTY024 = Y.QTY024, X.QTY025 = Y.QTY025, X.QTY026 = Y.QTY026, X.QTY027 = Y.QTY027, X.QTY028 = Y.QTY028, X.QTY029 = Y.QTY029, X.QTY030 = Y.QTY030' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY031 = Y.QTY031, X.QTY032 = Y.QTY032, X.QTY033 = Y.QTY033, X.QTY034 = Y.QTY034, X.QTY035 = Y.QTY035, X.QTY036 = Y.QTY036, X.QTY037 = Y.QTY037, X.QTY038 = Y.QTY038, X.QTY039 = Y.QTY039, X.QTY040 = Y.QTY040' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY041 = Y.QTY041, X.QTY042 = Y.QTY042, X.QTY043 = Y.QTY043, X.QTY044 = Y.QTY044, X.QTY045 = Y.QTY045, X.QTY046 = Y.QTY046, X.QTY047 = Y.QTY047, X.QTY048 = Y.QTY048, X.QTY049 = Y.QTY049, X.QTY050 = Y.QTY050' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY051 = Y.QTY051, X.QTY052 = Y.QTY052, X.QTY053 = Y.QTY053, X.QTY054 = Y.QTY054, X.QTY055 = Y.QTY055, X.QTY056 = Y.QTY056, X.QTY057 = Y.QTY057, X.QTY058 = Y.QTY058, X.QTY059 = Y.QTY059, X.QTY060 = Y.QTY060' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY061 = Y.QTY061, X.QTY062 = Y.QTY062, X.QTY063 = Y.QTY063, X.QTY064 = Y.QTY064, X.QTY065 = Y.QTY065, X.QTY066 = Y.QTY066, X.QTY067 = Y.QTY067, X.QTY068 = Y.QTY068, X.QTY069 = Y.QTY069, X.QTY070 = Y.QTY070' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY071 = Y.QTY071, X.QTY072 = Y.QTY072, X.QTY073 = Y.QTY073, X.QTY074 = Y.QTY074, X.QTY075 = Y.QTY075, X.QTY076 = Y.QTY076, X.QTY077 = Y.QTY077, X.QTY078 = Y.QTY078, X.QTY079 = Y.QTY079, X.QTY080 = Y.QTY080' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY081 = Y.QTY081, X.QTY082 = Y.QTY082, X.QTY083 = Y.QTY083, X.QTY084 = Y.QTY084, X.QTY085 = Y.QTY085, X.QTY086 = Y.QTY086, X.QTY087 = Y.QTY087, X.QTY088 = Y.QTY088, X.QTY089 = Y.QTY089, X.QTY090 = Y.QTY090' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY091 = Y.QTY091, X.QTY092 = Y.QTY092, X.QTY093 = Y.QTY093, X.QTY094 = Y.QTY094, X.QTY095 = Y.QTY095, X.QTY096 = Y.QTY096, X.QTY097 = Y.QTY097, X.QTY098 = Y.QTY098, X.QTY099 = Y.QTY099, X.QTY100 = Y.QTY100' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY101 = Y.QTY101, X.QTY102 = Y.QTY102, X.QTY103 = Y.QTY103, X.QTY104 = Y.QTY104, X.QTY105 = Y.QTY105, X.QTY106 = Y.QTY106, X.QTY107 = Y.QTY107, X.QTY108 = Y.QTY108, X.QTY109 = Y.QTY109, X.QTY110 = Y.QTY110' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY111 = Y.QTY111, X.QTY112 = Y.QTY112, X.QTY113 = Y.QTY113, X.QTY114 = Y.QTY114, X.QTY115 = Y.QTY115, X.QTY116 = Y.QTY116, X.QTY117 = Y.QTY117, X.QTY118 = Y.QTY118, X.QTY119 = Y.QTY119, X.QTY120 = Y.QTY120' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY121 = Y.QTY121, X.QTY122 = Y.QTY122, X.QTY123 = Y.QTY123, X.QTY124 = Y.QTY124, X.QTY125 = Y.QTY125, X.QTY126 = Y.QTY126, X.QTY127 = Y.QTY127, X.QTY128 = Y.QTY128, X.QTY129 = Y.QTY129, X.QTY130 = Y.QTY130' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY131 = Y.QTY131, X.QTY132 = Y.QTY132, X.QTY133 = Y.QTY133, X.QTY134 = Y.QTY134, X.QTY135 = Y.QTY135, X.QTY136 = Y.QTY136, X.QTY137 = Y.QTY137, X.QTY138 = Y.QTY138, X.QTY139 = Y.QTY139, X.QTY140 = Y.QTY140' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY141 = Y.QTY141, X.QTY142 = Y.QTY142, X.QTY143 = Y.QTY143, X.QTY144 = Y.QTY144, X.QTY145 = Y.QTY145, X.QTY146 = Y.QTY146, X.QTY147 = Y.QTY147, X.QTY148 = Y.QTY148, X.QTY149 = Y.QTY149, X.QTY150 = Y.QTY150' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY151 = Y.QTY151, X.QTY152 = Y.QTY152, X.QTY153 = Y.QTY153, X.QTY154 = Y.QTY154, X.QTY155 = Y.QTY155, X.QTY156 = Y.QTY156, X.QTY157 = Y.QTY157, X.QTY158 = Y.QTY158, X.QTY159 = Y.QTY159, X.QTY160 = Y.QTY160' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY161 = Y.QTY161, X.QTY162 = Y.QTY162, X.QTY163 = Y.QTY163, X.QTY164 = Y.QTY164, X.QTY165 = Y.QTY165, X.QTY166 = Y.QTY166, X.QTY167 = Y.QTY167, X.QTY168 = Y.QTY168, X.QTY169 = Y.QTY169, X.QTY170 = Y.QTY170' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY171 = Y.QTY171, X.QTY172 = Y.QTY172, X.QTY173 = Y.QTY173, X.QTY174 = Y.QTY174, X.QTY175 = Y.QTY175, X.QTY176 = Y.QTY176, X.QTY177 = Y.QTY177, X.QTY178 = Y.QTY178, X.QTY179 = Y.QTY179, X.QTY180 = Y.QTY180' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY181 = Y.QTY181, X.QTY182 = Y.QTY182, X.QTY183 = Y.QTY183, X.QTY184 = Y.QTY184, X.QTY185 = Y.QTY185, X.QTY186 = Y.QTY186, X.QTY187 = Y.QTY187, X.QTY188 = Y.QTY188, X.QTY189 = Y.QTY189, X.QTY190 = Y.QTY190' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY191 = Y.QTY191, X.QTY192 = Y.QTY192, X.QTY193 = Y.QTY193, X.QTY194 = Y.QTY194, X.QTY195 = Y.QTY195, X.QTY196 = Y.QTY196, X.QTY197 = Y.QTY197, X.QTY198 = Y.QTY198, X.QTY199 = Y.QTY199, X.QTY200 = Y.QTY200' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY201 = Y.QTY201, X.QTY202 = Y.QTY202, X.QTY203 = Y.QTY203, X.QTY204 = Y.QTY204, X.QTY205 = Y.QTY205, X.QTY206 = Y.QTY206, X.QTY207 = Y.QTY207, X.QTY208 = Y.QTY208, X.QTY209 = Y.QTY209, X.QTY210 = Y.QTY210' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY211 = Y.QTY211, X.QTY212 = Y.QTY212, X.QTY213 = Y.QTY213, X.QTY214 = Y.QTY214, X.QTY215 = Y.QTY215, X.QTY216 = Y.QTY216, X.QTY217 = Y.QTY217, X.QTY218 = Y.QTY218, X.QTY219 = Y.QTY219, X.QTY220 = Y.QTY220' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY221 = Y.QTY221, X.QTY222 = Y.QTY222, X.QTY223 = Y.QTY223, X.QTY224 = Y.QTY224, X.QTY225 = Y.QTY225, X.QTY226 = Y.QTY226, X.QTY227 = Y.QTY227, X.QTY228 = Y.QTY228, X.QTY229 = Y.QTY229, X.QTY230 = Y.QTY230' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY231 = Y.QTY231, X.QTY232 = Y.QTY232, X.QTY233 = Y.QTY233, X.QTY234 = Y.QTY234, X.QTY235 = Y.QTY235, X.QTY236 = Y.QTY236, X.QTY237 = Y.QTY237, X.QTY238 = Y.QTY238, X.QTY239 = Y.QTY239, X.QTY240 = Y.QTY240' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY241 = Y.QTY241, X.QTY242 = Y.QTY242, X.QTY243 = Y.QTY243, X.QTY244 = Y.QTY244, X.QTY245 = Y.QTY245, X.QTY246 = Y.QTY246, X.QTY247 = Y.QTY247, X.QTY248 = Y.QTY248, X.QTY249 = Y.QTY249, X.QTY250 = Y.QTY250' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY251 = Y.QTY251, X.QTY252 = Y.QTY252, X.QTY253 = Y.QTY253, X.QTY254 = Y.QTY254, X.QTY255 = Y.QTY255, X.QTY256 = Y.QTY256, X.QTY257 = Y.QTY257, X.QTY258 = Y.QTY258, X.QTY259 = Y.QTY259, X.QTY260 = Y.QTY260' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY261 = Y.QTY261, X.QTY262 = Y.QTY262, X.QTY263 = Y.QTY263, X.QTY264 = Y.QTY264, X.QTY265 = Y.QTY265, X.QTY266 = Y.QTY266, X.QTY267 = Y.QTY267, X.QTY268 = Y.QTY268, X.QTY269 = Y.QTY269, X.QTY270 = Y.QTY270' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY271 = Y.QTY271, X.QTY272 = Y.QTY272, X.QTY273 = Y.QTY273, X.QTY274 = Y.QTY274, X.QTY275 = Y.QTY275, X.QTY276 = Y.QTY276, X.QTY277 = Y.QTY277, X.QTY278 = Y.QTY278, X.QTY279 = Y.QTY279, X.QTY280 = Y.QTY280' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY281 = Y.QTY281, X.QTY282 = Y.QTY282, X.QTY283 = Y.QTY283, X.QTY284 = Y.QTY284, X.QTY285 = Y.QTY285, X.QTY286 = Y.QTY286, X.QTY287 = Y.QTY287, X.QTY288 = Y.QTY288, X.QTY289 = Y.QTY289, X.QTY290 = Y.QTY290' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY291 = Y.QTY291, X.QTY292 = Y.QTY292, X.QTY293 = Y.QTY293, X.QTY294 = Y.QTY294, X.QTY295 = Y.QTY295, X.QTY296 = Y.QTY296, X.QTY297 = Y.QTY297, X.QTY298 = Y.QTY298, X.QTY299 = Y.QTY299, X.QTY300 = Y.QTY300' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY301 = Y.QTY301, X.QTY302 = Y.QTY302, X.QTY303 = Y.QTY303, X.QTY304 = Y.QTY304, X.QTY305 = Y.QTY305, X.QTY306 = Y.QTY306, X.QTY307 = Y.QTY307, X.QTY308 = Y.QTY308, X.QTY309 = Y.QTY309, X.QTY310 = Y.QTY310' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY311 = Y.QTY311, X.QTY312 = Y.QTY312, X.QTY313 = Y.QTY313, X.QTY314 = Y.QTY314, X.QTY315 = Y.QTY315, X.QTY316 = Y.QTY316, X.QTY317 = Y.QTY317, X.QTY318 = Y.QTY318, X.QTY319 = Y.QTY319, X.QTY320 = Y.QTY320' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY321 = Y.QTY321, X.QTY322 = Y.QTY322, X.QTY323 = Y.QTY323, X.QTY324 = Y.QTY324, X.QTY325 = Y.QTY325, X.QTY326 = Y.QTY326, X.QTY327 = Y.QTY327, X.QTY328 = Y.QTY328, X.QTY329 = Y.QTY329, X.QTY330 = Y.QTY330' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY331 = Y.QTY331, X.QTY332 = Y.QTY332, X.QTY333 = Y.QTY333, X.QTY334 = Y.QTY334, X.QTY335 = Y.QTY335, X.QTY336 = Y.QTY336, X.QTY337 = Y.QTY337, X.QTY338 = Y.QTY338, X.QTY339 = Y.QTY339, X.QTY340 = Y.QTY340' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY341 = Y.QTY341, X.QTY342 = Y.QTY342, X.QTY343 = Y.QTY343, X.QTY344 = Y.QTY344, X.QTY345 = Y.QTY345, X.QTY346 = Y.QTY346, X.QTY347 = Y.QTY347, X.QTY348 = Y.QTY348, X.QTY349 = Y.QTY349, X.QTY350 = Y.QTY350' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY351 = Y.QTY351, X.QTY352 = Y.QTY352, X.QTY353 = Y.QTY353, X.QTY354 = Y.QTY354, X.QTY355 = Y.QTY355, X.QTY356 = Y.QTY356, X.QTY357 = Y.QTY357, X.QTY358 = Y.QTY358, X.QTY359 = Y.QTY359, X.QTY360 = Y.QTY360' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY361 = Y.QTY361, X.QTY362 = Y.QTY362, X.QTY363 = Y.QTY363, X.QTY364 = Y.QTY364' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.LAST_UPDATED_BY = ''' || V_BATCH_USER || ''',' || CHR(10);
              V_MEXEC := V_MEXEC || '        X.LAST_UPDATE_DATE = SYSDATE ' || CHR(10);

              EXECUTE IMMEDIATE V_MEXEC;

              /* ▼ MSSQL 원본 L4366~L4376 원문 보존 (동적 SQL PRINT 분할 루프 死코드(원본에서도 블록주석)) ---------------------------------------------
                           ( *
                             DECLARE @POS int
                             DECLARE @LEN NVARCHAR(max)
                                     SET @POS =1;
                                     SET @LEN =LEN(@mEXEC);
                                     WHILE @POS <= @LEN
                                         BEGIN
                                             PRINT SUBSTRING(@mEXEC,@POS,4000);
                                             SET @POS = @POS+4000;
                                         END;
                             * ) */

            /* ------------------------------------------------------------------------------------------- */
            /*   WEEK SUM PIVOT 생성 후 UPDATE */
            /* ------------------------------------------------------------------------------------------- */
              /*  IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL DROP TABLE #LineLoad_WEEK; */
              DELETE FROM GT_XPGT_LINELOAD_WEEK;

                INSERT INTO GT_XPGT_LINELOAD_WEEK
                     ( DIVISION_ID
                     , SITE_ID
                     , OPERATION_ID
                     , PROD_LINE
                     , MEASURE
                     , WQTY
                     , ISO_YYYYWW
                     , WEEK_COLUMN )
                SELECT A.DIVISION_ID
                     , A.SCM_SITE_ID  AS SITE_ID
                     , A.OPERATION_ID
                     , A.LINE_ID AS PROD_LINE
                     , A.MEASURE
                     , CASE WHEN SUM(A.WORKING_TIME) <= 0.0 THEN 0
                            ELSE NVL((ROUND(SUM(A.CAPA_TACT), 0) / SUM(A.WORKING_TIME)), 0) * 100
                       END AS WQTY
                     , A.ISO_YYYYWW
                     , A.WEEK_COLUMN
                  FROM GT_XPGT_LINELOAD A
                 GROUP BY A.DIVISION_ID
                     , A.SCM_SITE_ID
                     , A.OPERATION_ID
                     , A.LINE_ID
                     , A.MEASURE
                     , A.ISO_YYYYWW
                     , A.WEEK_COLUMN ;

                /*  IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL DROP TABLE #LineLoad_WEEK_PIVOT; */
                DELETE FROM GT_XPGT_LINELOAD_WEEK_PIVOT;

                  INSERT INTO GT_XPGT_LINELOAD_WEEK_PIVOT
                  SELECT *
                    FROM ( SELECT DIVISION_ID, SITE_ID, OPERATION_ID, PROD_LINE, MEASURE, WQTY, WEEK_COLUMN
                             FROM GT_XPGT_LINELOAD_WEEK
                         )
                   PIVOT ( MIN(WQTY)
                           FOR WEEK_COLUMN IN (
                                 'WQTY01' AS WQTY01, 'WQTY02' AS WQTY02, 'WQTY03' AS WQTY03, 'WQTY04' AS WQTY04, 'WQTY05' AS WQTY05
                               , 'WQTY06' AS WQTY06, 'WQTY07' AS WQTY07, 'WQTY08' AS WQTY08, 'WQTY09' AS WQTY09, 'WQTY10' AS WQTY10
                               , 'WQTY11' AS WQTY11, 'WQTY12' AS WQTY12, 'WQTY13' AS WQTY13, 'WQTY14' AS WQTY14, 'WQTY15' AS WQTY15
                               , 'WQTY16' AS WQTY16, 'WQTY17' AS WQTY17, 'WQTY18' AS WQTY18, 'WQTY19' AS WQTY19, 'WQTY20' AS WQTY20
                               , 'WQTY21' AS WQTY21, 'WQTY22' AS WQTY22, 'WQTY23' AS WQTY23, 'WQTY24' AS WQTY24, 'WQTY25' AS WQTY25
                               , 'WQTY26' AS WQTY26, 'WQTY27' AS WQTY27, 'WQTY28' AS WQTY28, 'WQTY29' AS WQTY29, 'WQTY30' AS WQTY30
                               , 'WQTY31' AS WQTY31, 'WQTY32' AS WQTY32, 'WQTY33' AS WQTY33, 'WQTY34' AS WQTY34, 'WQTY35' AS WQTY35
                               , 'WQTY36' AS WQTY36, 'WQTY37' AS WQTY37, 'WQTY38' AS WQTY38, 'WQTY39' AS WQTY39, 'WQTY40' AS WQTY40
                               , 'WQTY41' AS WQTY41, 'WQTY42' AS WQTY42, 'WQTY43' AS WQTY43, 'WQTY44' AS WQTY44, 'WQTY45' AS WQTY45
                               , 'WQTY46' AS WQTY46, 'WQTY47' AS WQTY47, 'WQTY48' AS WQTY48, 'WQTY49' AS WQTY49, 'WQTY50' AS WQTY50
                               , 'WQTY51' AS WQTY51, 'WQTY52' AS WQTY52
                                              )
                         )
                       ;

                /*  MSSQL UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL_ESS X INNER JOIN #LineLoad_WEEK_PIVOT Y ON ..
                    -> 조인키에 MEASURE 가 없어 원천 다중매치가 가능하므로 상관 UPDATE + EXISTS + ROWNUM = 1 (CV-024) */
                UPDATE SCP_XLS_PSI_GLOBAL_ESS X
                   SET (
                         WQTY01, WQTY02, WQTY03, WQTY04, WQTY05
                       , WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                       , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15
                       , WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                       , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25
                       , WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                       , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35
                       , WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                       , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45
                       , WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                       , WQTY51, WQTY52
                       ) =
                       ( SELECT
                           Y.WQTY01, Y.WQTY02, Y.WQTY03, Y.WQTY04, Y.WQTY05
                         , Y.WQTY06, Y.WQTY07, Y.WQTY08, Y.WQTY09, Y.WQTY10
                         , Y.WQTY11, Y.WQTY12, Y.WQTY13, Y.WQTY14, Y.WQTY15
                         , Y.WQTY16, Y.WQTY17, Y.WQTY18, Y.WQTY19, Y.WQTY20
                         , Y.WQTY21, Y.WQTY22, Y.WQTY23, Y.WQTY24, Y.WQTY25
                         , Y.WQTY26, Y.WQTY27, Y.WQTY28, Y.WQTY29, Y.WQTY30
                         , Y.WQTY31, Y.WQTY32, Y.WQTY33, Y.WQTY34, Y.WQTY35
                         , Y.WQTY36, Y.WQTY37, Y.WQTY38, Y.WQTY39, Y.WQTY40
                         , Y.WQTY41, Y.WQTY42, Y.WQTY43, Y.WQTY44, Y.WQTY45
                         , Y.WQTY46, Y.WQTY47, Y.WQTY48, Y.WQTY49, Y.WQTY50
                         , Y.WQTY51, Y.WQTY52
                            FROM GT_XPGT_LINELOAD_WEEK_PIVOT Y
                           WHERE Y.PROD_LINE    = X.PROD_LINE
                             AND X.DIVISION_ID  = Y.DIVISION_ID
                             AND X.FROM_SITE    = Y.SITE_ID
                             AND X.ATTRIBUTE9   = Y.OPERATION_ID
                             AND ROWNUM         = 1 )
                 WHERE X.MEASURE IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD')
                   AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                   AND EXISTS ( SELECT 1
                                  FROM GT_XPGT_LINELOAD_WEEK_PIVOT Y
                                 WHERE Y.PROD_LINE    = X.PROD_LINE
                                   AND X.DIVISION_ID  = Y.DIVISION_ID
                                   AND X.FROM_SITE    = Y.SITE_ID
                                   AND X.ATTRIBUTE9   = Y.OPERATION_ID );

              END IF;

              END IF;   /*  IF @v_batch_measure <> 'CELL_CHAR_PLAN' */

        /*  IF OBJECT_ID('TEMPDB..#JV_ESS_LINE_MAP')         IS NOT NULL DROP TABLE #JV_ESS_LINE_MAP           -- PJ2025F254 : 임시테이블 정리
            IF OBJECT_ID('TEMPDB..#JV_ESS_SCM_SITE_MAP')     IS NOT NULL DROP TABLE #JV_ESS_SCM_SITE_MAP       -- PJ2025F254 : 임시테이블 정리
            IF OBJECT_ID('TEMPDB..#DIVISION_LAST_PLAN_INFO') IS NOT NULL DROP TABLE #DIVISION_LAST_PLAN_INFO;  -- PJ2025F254 : 임시테이블 정리 */
        DELETE FROM GT_XPGT_JV_ESS_LINE_MAP;
        DELETE FROM GT_XPGT_JV_ESS_SCM_SITE_MAP;
        DELETE FROM GT_XPGT_DIVISION_LAST_PLAN_INFO;

        /* --------------------------------------------------------- */
        /*  실행 Logic END -- */
        /* --------------------------------------------------------- */

        /*  TXN LOG */
        V_LOG_TYPE     := 'TXN';    /* 로그타입 */

        N_LOG_COUNT    := SQL%ROWCOUNT;
        V_LOG_MESSAGE  := 'INSERT INTO ' || V_TABLE_ID;
        /*  MSSQL CONVERT(CHAR(23), @d_event_date, 121) = 'YYYY-MM-DD HH:MI:SS.mmm'. */
        V_DESCRIPTION  := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYY-MM-DD HH24:MI:SS');
        D_EVENT_DATE   := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                            , P_LOG_TYPE      => V_LOG_TYPE
                            , P_LOG_COUNT     => N_LOG_COUNT
                            , P_LOG_MESSAGE   => V_LOG_MESSAGE
                            , P_DESCRIPTION   => V_DESCRIPTION
                            , P_EVENT_DATE    => D_EVENT_DATE
                            , P_USER_ID       => V_BATCH_USER_ID
                            );

      END;

    EXCEPTION
      WHEN OTHERS THEN

        /*           IF @@TRANCOUNT > 0
             BEGIN
               ROLLBACK;
             END; */

        /*  ERROR LOG */
        V_LOG_TYPE     := 'ERROR';
        V_LOG_MESSAGE  := SUBSTR(SQLERRM, 1, 1000);
        /*  MSSQL N'ERROR_LINE : ' + STR(ERROR_LINE()) + '[' + @p_measure + ']' 은 Oracle 무대응 -> */
        V_DESCRIPTION  := CASE WHEN P_MEASURE IS NULL
                               THEN NULL
                               ELSE SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || '[' || P_MEASURE || ']', 1, 500)
                          END;
        D_EVENT_DATE   := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                            , P_LOG_TYPE      => V_LOG_TYPE
                            , P_LOG_COUNT     => N_LOG_COUNT
                            , P_LOG_MESSAGE   => V_LOG_MESSAGE
                            , P_DESCRIPTION   => V_DESCRIPTION
                            , P_EVENT_DATE    => D_EVENT_DATE
                            , P_USER_ID       => V_BATCH_USER_ID
                            );

        /*  MSSQL 원본 L4504 : return -1  (CATCH 안 = 오류 경로) */
        O_RETURN_CODE := -1;
        RETURN;
    END;

    /*  임시 운영반영시에 주석처리 할것. */

    /*  MSSQL REPLICATE('0', 2 - LEN(x)) + x -> LPAD(x, 2, '0') (CV-067).
        ※원본은 x 가 3자리 이상이면 REPLICATE 인자가 음수가 되어 NULL 을 돌려주지만 LPAD 는 앞자리를 자른다. */
    V_EXEC_TIME  :=  LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0') || ':' ||
                     LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

    /*  종료 LOG */
    V_LOG_TYPE     := 'END';
    V_LOG_MESSAGE  := '########## END of procedure ##########';

    V_DESCRIPTION  := CASE WHEN P_DIVISION_ID IS NULL OR P_CREATE_FROM_YYYYMMDD IS NULL
                             OR P_MEASURE IS NULL OR V_BATCH_XLS_KEY1 IS NULL OR V_EXEC_TIME IS NULL
                           THEN NULL
                           ELSE '[' || P_DIVISION_ID || '][' || P_CREATE_FROM_YYYYMMDD || '][' || P_MEASURE
                                || '][' || LPAD(TO_CHAR(V_BATCH_XLS_KEY1), 10) || '][' || V_EXEC_TIME || ']'
                      END;
    D_EVENT_DATE   := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                        , P_LOG_TYPE      => V_LOG_TYPE
                        , P_LOG_COUNT     => N_LOG_COUNT
                        , P_LOG_MESSAGE   => V_LOG_MESSAGE
                        , P_DESCRIPTION   => V_DESCRIPTION
                        , P_EVENT_DATE    => D_EVENT_DATE
                        , P_USER_ID       => V_BATCH_USER_ID
                        );
    /*  MSSQL 원본 L4526 : return 1  (정상 종료) */
    O_RETURN_CODE := 1;
    RETURN;

END;