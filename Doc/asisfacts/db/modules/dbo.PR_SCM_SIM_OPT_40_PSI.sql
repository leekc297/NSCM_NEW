


/*=====================================================================================================================================================
 * Program ID   : PR_SCM_SIM_OPT_40_PSI
 * Description  : 소형셀시뮬레이터에 사용할 RAW 데이터 집계용
 *                SCP PLAN완료시 소형셀시뮬레이터 VBA로 본 프로시저를 호출하여 SCM_SIM_DYN_COLS 테이블에 적재하는 단일 통합 프로시저.
 *                (PR_SCP_XLS_BOH+PR_SCP_XLS_PSI_GLOBAL_SMALL+PR_SCP_XLS_PSI_GLOBAL_SMALL_S+PR_SCP_XLS_DAILY_SMALL 를 본 SP 안에 인라인 통합)
 *                다음 단계를 수행:
 *                (1) #PSI_GLOBAL_SMALL_AUTO (LONG Format: ITEM × YYYYMMDD × QTY) 생성 --> 이후 WIDE format(Pivot)
 *                    ※ 메인 SP 가 자체적으로 dbo.scm_mst_plan.horizon_end_date 조회하여
 *                       1년/2년/N년 모든 일자 범위를 한 번에 처리함 (BP_FLAG 무관).
 *                (2) #PSI_GLOBAL_SMALL_AUTO 를 일자별 PIVOT 으로 SCM_SIM_DYN_COLS 에 적재
 *                    - 행 구조: LABEL(QTY번호) + LABEL2(주차) + LABEL3(YYMMDD일자) + DATA
 *                    - C 컬럼 동적 계산: C1~C25 = 비-시간 라벨, C26~CN = 일자별 QTY
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 2026.04.27	김준규		최초 릴리즈
 * 2026.07.20   YMH         E20260714-000705 소형 셀 신규 시뮬레이터 확인 요청의 건 SHIPMENT_PLAN_SEMI 가져오는 매저 SHIP_PLAN -> SHIP_PLAN_AMEND 로 수정
 * 2026.09.09   ymh         E20260908-000533 소형 시뮬레이터 조회 시 오류 팝업 발생
 *===================================================================================================================================================*/

/*
--
수정 변경후 아래 변경필요
--
DECLARE @V_RETVAL INT ;
DECLARE @V_STATUS INT ;
DECLARE @V_MSG    NVARCHAR(MAX);
DECLARE @V_BATCH_ID NVARCHAR(MAX) ;
DECLARE @V_USER_ID NVARCHAR(30) ='TEST_simulator';
DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(8) ='20260511';
DECLARE @V_PLAN_TYPE NVARCHAR(30) ='MA';
DECLARE @V_PLAN_SEQ INT=1;
DECLARE @V_PLANT_IDS NVARCHAR(254) ='AZ00-A,HQ06-A,HQ10-A,NJ01-A,NJ01-P';--'NJ01';
DECLARE @V_DIVISION_ID NVARCHAR(254) = '40';
--DECLARE @V_ITEM_IDS NVARCHAR(MAX) ='MCBB45821-A1,MCCH114030D3,MCCH129520B1-000,MCCH318867A1T000,MCCH318867A2T000,MCCH335080B1T000,MCCH335080B1T001,ECE0074N5-01,ECE0074N5-01-A01,ECE0074N5-01-A04,MCCE125001A2,MCCE125001A4,MCCE125001A8,MCCE130705A4,MCCE130705A4-M07,MCCE130705A4T001,MCCE132502A0,MCCE132502A1,MCCE132502A1-K,MCCE132502A1-M09,MCCE132502A1-M10,MCCE132502A1-M11,MCCE132502A1-M12,MCCE132502A1-M14,MCCE132502A1-M15,MCCE133512N1,MCCH112520C1,MCCH112520C1-M01,MCCH114030D1,MCCH114030D1-M02,MCCH114030D3-M01,MCCH114030D3-M07,MCCH114030L1,MCCH114510G1,MCCH119010A1,MCCH120020B1,MCCH120022B3,MCCH329530A1,MCCH329530A1-I01,MCCH329530A1-I02,MCCH329530A1-I03,MCCH329530A1-I04,MCCH330035A1,MCCH330035A1-D01,MCCH340030A2,MCCH340030A2-D01,MCCH340030A2-D02,MCCH340030A2-D03,MCCH340035A1,MCCH340035A1-D05'
DECLARE @V_ITEM_IDS NVARCHAR(MAX) ='MCMM9314U0A1-016,MCCH114030D3,MCCH129520B1-000,MCCH335080B1T000,MCCH350040A1,MCCH350040A1-000,MCCH350040A1T001,MCCH350040A2-000,MCCH350040A2T001,MCCM131012A1-M01,MCCM348014A3,MCCM348015A1-000,MCCM348017B1-M01,MCCM348018A3,MCCM348018A3-M04,MCCM349215A1,MCCM349215A1-002,MCCM349215A1-004,MCCM349215A1-M01,MCCM350415A1,MCCM351015B1,MCCM351015B1-D01,MCCM356015A1,MCCM356015A2,MCMM725075A1,MCMM726078A1T008,MCMM726078A2,MCMM729288A1T000,MCMM730070A1,MCMM730070A1T001,MCMM9314U0A1-016,MCMM931832A1-000,MCMM9319V9A1-005,MCMM932933A1,MCMMA38038A1-016,MCMMA38038A1-017,MCMMA38038A1-020,MCMMA38038A1-I01,MCMMA38038A1T001,MCMMA38038A1T007,MCMMC41042A1-000,MCMMC41042A1T000,MCMMC41042A1T003,MCCH114030L1,MCCH125020A1,MCCH129520B1,MCCH348525A1,MCCH348525A1T001,MCCH348525A2,MCCM127510A9,MCCM131012A1,MCCM131012B1,MCCM134010A1,MCCM346914A1,MCCM348014A2,MCCM348014A3,MCCM348018A2,MCCM348018A2-100,MCCM348018A3,MCCM349215A1,MCCM349215A1-104,MCCM349215A1-109,MCCM349215A1-111,MCCM349215A1-112,MCCM350415A1,MCCM350415B1,MCCM351015B1,MCCM356015A1,MCCM356015A2,MCCM356015A2-K,MCCM356015B1,MCCM356015B1T001,MCCM356015B2,MCCM356015B2T001,MCCM363518A1,MCP4547C8A10,MCP4690B4A10,MCP4848C8A10,MCP496079A10,MCP498170C10,MCP506578A10,MCP5290B4A10,MCSS22531-B1,MCSS22531-B2,MCSS22531-B3,MCSS22561-C1,MCSS56831-A1,MDP2949A9B11,MDP303994C11,MDP343993A11,MIF409858C11,MIF449066A11,MIF469958A11,MIF46B064A11,MIF489266C11,MIF519664A11,MIF548466C11,MIF548466D11,MIP474586B11,MIP474587E11,MIP475199C11,MIP484599A11,MTP3768B0B11,MCCM348018A3'
SET @V_BATCH_ID = NEXT VALUE FOR SEQ1_SCM_SIM_DYN_COLS;
EXEC @V_RETVAL = [LGCE_SCMTEST].[DBO].[PR_SCM_SIM_OPT_40_PSI]
     @P_BATCH_ID=@V_BATCH_ID
    ,@P_USER_ID=@V_USER_ID
    ,@P_DIVISION_ID = @V_DIVISION_ID
    ,@P_PLANT_IDS=@V_PLANT_IDS
    ,@P_ITEM_IDS = @V_ITEM_IDS
    ,@P_SNAP_YYYYMMDD=@V_PLAN_START_YYYYMMDD
    ,@P_PLAN_TYPE = @V_PLAN_TYPE
    ,@P_PLAN_SEQ = @V_PLAN_SEQ
    ,@P_IS_DEBUG = 1   -- 2026-06-05 김준규 추가: 디버그 출력 ON (운영/실배포 시 0)
    ,@X_STATUS=@V_STATUS OUTPUT
    ,@X_MSG=@V_MSG OUTPUT
PRINT '@V_RETVAL:'+ISNULL(CONVERT(NVARCHAR(MAX),@V_RETVAL),'NULL');
PRINT '@V_STATUS:'+ISNULL(CONVERT(NVARCHAR(MAX),@V_STATUS),'NULL');
PRINT '@V_MSG:'+ISNULL(CONVERT(NVARCHAR(MAX),@V_MSG),'NULL');
DECLARE @V_BP_FLAG NVARCHAR(30) ='N';
   EXEC PR_SCM_SIM_DYN_40_RPT
         @P_BATCH_ID      = @V_BATCH_ID
        ,@P_SNAP_YYYYMMDD = @V_PLAN_START_YYYYMMDD
        ,@P_REPORT_TITLE  = 'RAW'
        ,@P_BP_FLAG       = @V_BP_FLAG
        ,@P_DIVISION_ID   = @V_DIVISION_ID;
   EXEC PR_SCM_SIM_DYN_40_RPT
         @P_BATCH_ID      = @V_BATCH_ID
        ,@P_SNAP_YYYYMMDD = @V_PLAN_START_YYYYMMDD
        ,@P_REPORT_TITLE  = 'SHIP_SIM'
        ,@P_BP_FLAG       = @V_BP_FLAG
        ,@P_DIVISION_ID   = @V_DIVISION_ID;


*/
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_SCM_SIM_OPT_40_PSI]
    @P_BATCH_ID            NVARCHAR(30)   = '0'
   ,@P_USER_ID             NVARCHAR(30)   = ''
   ,@P_DIVISION_ID         NVARCHAR(30)   = ''
   ,@P_PLANT_IDS           NVARCHAR(4000) = ''
   ,@P_ITEM_IDS            NVARCHAR(MAX)  = ''
   ,@P_SNAP_YYYYMMDD       NVARCHAR(8)    = ''
   ,@P_PLAN_TYPE           NVARCHAR(30)   = ''
   ,@P_PLAN_SEQ            INT            = 1
   ,@P_IS_DEBUG            INT            = 0   -- 2026-06-05 김준규 추가: 디버그 출력 제어 (1=디버그 SELECT 출력, 0=미출력)
   ,@X_STATUS              INT            OUTPUT
   ,@X_MSG                 NVARCHAR(200)  OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET ANSI_NULLS ON;
    SET ANSI_WARNINGS ON;

    SET @X_STATUS = 1;
    SET @X_MSG    = N'';

    DECLARE @v_start_time    DATETIME        = SYSDATETIME();
    DECLARE @v_exec_time     NVARCHAR(10)    = N'';

PRINT '--A@X#00100--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    -- @P_BATCH_ID 는 호출자가 본인이 만든 시퀀스에서 NEXT VALUE 발급 후 전달.
    -- (본 SP 내부에서는 시퀀스를 호출하지 않음.)
    DECLARE @v_report_type  NVARCHAR(254)  = 'RAW';
    DECLARE @v_batch_id      BIGINT        = TRY_CONVERT(BIGINT, @P_BATCH_ID);
    DECLARE @v_user          NVARCHAR(150) = IIF(ISNULL(@P_USER_ID,N'')=N'', N'simulator', @P_USER_ID);

    -- ============================================================================================================
    -- 2026-05-13 김준규 [테스트 mode]: 분할 분기 (>364일) 시뮬레이션
    --   값 > 0 → #PSI_GLOBAL_SMALL_AUTO 채워진 후 첫 N일 데이터를 +(364)일 shift 하여 INSERT
    --           → @v_n_days = 364 + N → 분할 분기 발동
    --   값 = 0 → 비활성화 (운영 상태)
    --   사용법: 검증 끝나면 0 으로 변경 (또는 코드 제거)
    -- ============================================================================================================
    DECLARE @v_test_mode_split_extend_days INT = 0;    -- 2026-05-14 김준규: 운영 모드 (210→0)
                                                       -- 사용자 환경 728일 데이터에서 자연 분할 분기 발동
                                                       -- 테스트 시 210 등으로 변경하면 더 큰 일자 시뮬레이션 가능

    BEGIN TRY
        -------------------------------------------------------------------------------------
        -- (1) 메인 SP 1회 호출 → #PSI_GLOBAL_SMALL_AUTO (LONG) 생성
        --   메인 SP 는 자체적으로 dbo.scm_mst_plan.horizon_end_date 조회하여
        --   1년/2년 (BP_FLAG) 등 모든 일자 범위를 한 번에 처리함.
        --   따라서 wrapper 에서는 단순히 1회 호출만 하면 됨.
        -------------------------------------------------------------------------------------
        -- (1) [INLINED FROM PR_SCM_SIM_OPT_40_PSI]
        --   메인 LONG 데이터 생성 로직 인라인 (sub-SP 호출 제거)
        --   결과 임시테이블: #PSI_GLOBAL_SMALL_AUTO (LONG 형태)
        -------------------------------------------------------------------------------------

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;
    SET ANSI_NULLS ON;

    SET @X_STATUS = 1;
    SET @X_MSG    = N'';

    --=========================================================================================
    -- 디버그 / 로그용 로컬 변수 (운영 LOG SP 의존성 제거)
    --=========================================================================================
    DECLARE @v_is_debug      BIT             = CASE WHEN @P_IS_DEBUG = 1 THEN 1 ELSE 0 END;   -- 2026-06-05 김준규 수정: 입력 파라메터 @P_IS_DEBUG 와 연동
    -- 2026-06-04 김준규 [MCCH114030L1 NEXCON SEMI 누락 추적] (확인 후 제거)
    --   대상: ITEM_ID=MCCH114030L1 AND TO_SITE LIKE CN00254300%, SEMI_SHIP% measure

    DECLARE @v_program_name  NVARCHAR(150)   = N'PR_SCM_SIM_OPT_40_PSI';
    DECLARE @v_batch_user    NVARCHAR(150)   = IIF(ISNULL(@P_USER_ID,N'') = N'', N'simulator', @P_USER_ID);
    DECLARE @v_log_type      NVARCHAR(30);
    DECLARE @n_log_count     INT             = 0;
    DECLARE @v_log_message   NVARCHAR(1000);
    DECLARE @v_description   NVARCHAR(500);
    DECLARE @v_table_id      NVARCHAR(150)   = N'#PSI_GLOBAL_SMALL_AUTO';
    DECLARE @d_event_date    DATETIME;

    --=========================================================================================
    -- 기존 (메인+sub) 프로시저에서 사용하던 파라미터/로컬 변수 - 호환을 위해 로컬로 선언
    --=========================================================================================
    DECLARE @p_program_id            NVARCHAR(30)   = N'XLSPSI01';
    DECLARE @p_to_yyyymmdd           VARCHAR(8)     = N'';

    -- @p_plan_start_yyyymmdd 는 그 주의 월요일로 보정 (요구사항 #1)
    --   계산: @P_SNAP_YYYYMMDD 가 속한 ISO_WEEK 의 월요일
    --   SQL: DATEADD(DAY, -((DATEPART(WEEKDAY, dt) + @@DATEFIRST - 2) % 7), dt)
    --        @@DATEFIRST 가 7(SUN, 기본)이면 (요일+5) %7 일수 빼기 → 월요일
    DECLARE @p_plan_start_yyyymmdd   NVARCHAR(8);
    DECLARE @v_snap_dt               DATE = TRY_CONVERT(DATE, @P_SNAP_YYYYMMDD, 112);
    IF @v_snap_dt IS NULL
    BEGIN
        SET @X_STATUS = -1;
        SET @X_MSG    = N'Invalid @P_SNAP_YYYYMMDD format (expected yyyymmdd).';
        RETURN -1;
    END;
    SET @p_plan_start_yyyymmdd = CONVERT(NVARCHAR(8),
                                         DATEADD(DAY,
                                                 -((DATEPART(WEEKDAY, @v_snap_dt) + @@DATEFIRST - 2) % 7),
                                                 @v_snap_dt),
                                         112);
    DECLARE @p_cutoff_date           VARCHAR(8)     = CONVERT(VARCHAR(8), DATEADD(day, -1, @p_plan_start_yyyymmdd), 112);
    DECLARE @p_create_from_yyyymmdd  NVARCHAR(8)    = @p_plan_start_yyyymmdd;
    DECLARE @p_create_to_yyyymmdd    NVARCHAR(8)    = N'';
    DECLARE @p_seq                   NVARCHAR(20)   = CONVERT(NVARCHAR(20), @P_PLAN_SEQ);
    DECLARE @p_plan_cycle            NVARCHAR(150)  = N'WEEKLY';


    DECLARE @p_plan_id               NVARCHAR(4000) = N'';
    DECLARE @p_modeling_id           NVARCHAR(4000) = N'1';
    DECLARE @p_master_id             NVARCHAR(4000) = ISNULL(@P_DIVISION_ID, N'') + N'::WEEKLY';
    DECLARE @p_engine_plan_id        NVARCHAR(4000) = N''; --@p_engine_plan_id      = '1378::PR::2'
    DECLARE @rows                    INT            = 0;

    -------------------------------------------------------------------------------------------------------------
    -- PLAN 기간설정 - 2021.11.19
    -------------------------------------------------------------------------------------------------------------
    SELECT @p_to_yyyymmdd = p.horizon_end_date,
           @p_plan_id = p.PLAN_ID,
           @p_engine_plan_id = @p_plan_id+'::'+@P_PLAN_TYPE+'::'+CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ)
    FROM   dbo.scm_mst_plan p WITH(NOLOCK)
    WHERE  p.division_id = @P_DIVISION_ID
    AND    p.PLAN_NAME = @p_plan_start_yyyymmdd
    AND    p.plan_cycle  = 'WEEKLY'
    ;


PRINT '--A@X#00130--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    --=========================================================================================
    -- (선택) BP_FLAG (중장기 / 1년 / 2년 구간 결정)
    --=========================================================================================
    DECLARE @v_bp_flag               NVARCHAR(8)    = N'N';
    DECLARE @v_pet_date              NVARCHAR(12)   = N'';
    DECLARE @v_bp_days               INT            = 0;
    DECLARE @v_bp_plan_end_yyyymmdd  NVARCHAR(8)    = N'';


    --=========================================================================================
    -- (요구사항 #4) #SCP_XLS_BOH 임시테이블 생성 + 적재 (PR_SCP_XLS_BOH 본문 인라인)
    --   원본 PR_SCP_XLS_BOH 는 SCP_XLS_BOH 물리테이블에 INSERT 하지만,
    --   여기서는 #SCP_XLS_BOH 임시테이블에 SELECT INTO 로 동일 결과를 만든다.
    --   sub 본문 (인라인 영역) 안에서 SCP_XLS_BOH → #SCP_XLS_BOH 로 자동 치환됨.
    --=========================================================================================
    DECLARE @start_yyyymmdd NVARCHAR(8) = CONVERT(VARCHAR, DATEADD(day, -1, @p_plan_start_yyyymmdd), 112);

PRINT '--A@X#00140--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

PRINT CONCAT('@p_master_id:',@p_master_id,'@p_engine_plan_id:',@p_engine_plan_id,'@start_yyyymmdd:',@start_yyyymmdd);

    IF OBJECT_ID('tempdb..#SCP_XLS_BOH') IS NOT NULL DROP TABLE #SCP_XLS_BOH;

              SELECT  DIVISION_ID
                    , @p_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD
                    , @P_PLAN_TYPE              AS PLAN_TYPE
                    , @p_seq                    AS SEQ
                    , SCM_SITE_ID
                    , INCOTERMS
                    , ITEM_ID
                    , QTY
                    , ORIGIN_ITEM_ID
                    , ORIGIN_QTY
                    , @v_batch_user             AS CREATED_BY
                    , GETDATE()                 AS CREATION_DATE
                    , @v_batch_user             AS LAST_UPDATED_BY
                    , GETDATE()                 AS LAST_UPDATE_DATE
                    -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영 기존로직 주석
                    --, NULL                      AS ATTRIBUTE1
                    -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영 attribute1 에 반영.
                    , FROM_SCM_SITE_ID          AS ATTRIBUTE1
                    , NULL                      AS ATTRIBUTE2
                    , NULL                      AS ATTRIBUTE3
                    , NULL                      AS ATTRIBUTE4
                    , NULL                      AS ATTRIBUTE5
                    , NULL                      AS ATTRIBUTE6
                    , NULL                      AS ATTRIBUTE7
                    , NULL                      AS ATTRIBUTE8
                    , NULL                      AS ATTRIBUTE9
                    , DESCR                     AS ATTRIBUTE10          -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외(HOLD 확인을 위해 추가)
              INTO #SCP_XLS_BOH
              FROM (
                    SELECT  A.DIVISION_ID,
                            A.SCM_SITE_ID,
                            A.INCOTERMS,
                            B.CHILD_ITEM_ID       AS ITEM_ID,
                            (A.QTY * B.CHILD_QTY) AS QTY,
                            A.ITEM_ID             AS ORIGIN_ITEM_ID,
                            A.QTY                 AS ORIGIN_QTY,
                            A.DESCR               ,  -- Pack BOH 수량에서 Hold 수량제외(HOLD 확인을 위해 추가)
                            A.FROM_SCM_SITE_ID    -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영
                    FROM
                    (
                    SELECT
                            @P_DIVISION_ID AS DIVISION_ID
                           ,S.ITEM_ID
--                           ,dbo.FN_SCM_SPLIT(SITE_ID,1,'~') AS SCM_SITE_ID
                           ,SUBSTRING(S.SITE_ID,1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) AS SCM_SITE_ID
--                           ,SUBSTRING(S.SITE_ID,CHARINDEX('~', S.SITE_ID)+1,(CASE WHEN CHARINDEX('~',S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) AS INCOTERMS
                           ,(CASE WHEN T.SITE_TYPE = 'SALES' THEN SUBSTRING(S.SITE_ID,CHARINDEX('~', S.SITE_ID)+1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) ELSE ''  END)  AS INCOTERMS
                           , QTY
                           , DESCR      -- Pack BOH 수량에서 Hold 수량제외(HOLD 확인을 위해 추가)
                           , DBO.FN_SCM_SPLIT(S.lot_id ,6,'::') AS FROM_SCM_SITE_ID -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영
                      FROM dbo.SCP_PLN_TH_ENG_STOCK_PLAN S WITH(NOLOCK)
                          ,dbo.SCM_MST_SITE              T WITH(NOLOCK)
                     WHERE 1=1
                       AND S.MASTER_ID      = @p_master_id
                    --   AND S.PLAN_ID      ='1060'
                       AND S.PLAN_ID        = @p_engine_plan_id
                       AND S.LOT_ID       LIKE 'WH%'
                       AND S.ITEM_ID      LIKE 'AMDAU%'
                       AND CONVERT(VARCHAR,S.RECEIVING_DTTM,112) >= @start_yyyymmdd
                       AND dbo.FN_SCM_SPLIT(MASTER_ID,1,'::')   = T.DIVISION_ID
                       AND SUBSTRING(S.SITE_ID,1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END))  = T.SCM_SITE_ID
                       AND NOT ISNULL(S.INSP_TYPE, '') IN ('INSP_PRE', 'INSP_HOLD')     -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
                    ) A,
                    (  SELECT DISTINCT DIVISION_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,CHILD_QTY

                    --  2021.03.29   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 대체 BOM 적용 - start
                    -- SCM_MST_BOM_SN 에서 뷰로 변경됨
                         --FROM SCM_MST_BOM_SN WITH(NOLOCK)
                         FROM SCM_MST_BOM_SN_V WITH(NOLOCK)
                    --  2021.03.29   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 대체 BOM 적용 - end

                        WHERE DIVISION_ID     =    @P_DIVISION_ID
                          AND PARENT_ITEM_ID LIKE 'AMDAU%'
                          AND CHILD_ITEM_ID  LIKE 'ACE%'
                          AND ALT_PRIORITY    = 'Y'
                        --AND PARENT_ITEM_ID LIKE 'AMDAU0024N'
                      ) B
                    WHERE A.DIVISION_ID = B.DIVISION_ID
                      AND A.ITEM_ID     = B.PARENT_ITEM_ID
                    UNION ALL
                    -- * 2020.10.27   KSW         2020.08.11 추가된 DISTINCT를 SCM_MST_FINAL_ITEM_V 에 제한적으로 적용하는 것으로 변경 (자동차 TO_SITE_BOH 수량 누락보완)
                    --SELECT DISTINCT     -- KSW 2020-08-11 :: SCM_MST_FINAL_ITEM_V 에서 Nick Name 이 없는 건이 존재함 - DISTINCT 추가
                    SELECT
                            @P_DIVISION_ID  AS DIVISION_ID
                           ,SUBSTRING(S.SITE_ID,1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) AS SCM_SITE_ID
                           ,(CASE WHEN T.SITE_TYPE = 'SALES' THEN SUBSTRING(S.SITE_ID,CHARINDEX('~', S.SITE_ID)+1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) ELSE ''  END)
                           ,S.ITEM_ID
                           , QTY
                           ,NULL            AS ORIGIN_ITEM_ID
                           ,0               AS ORIGIN_QTY
                           ,S.DESCR     -- Pack BOH 수량에서 Hold 수량제외(HOLD 확인을 위해 추가)
                           , DBO.FN_SCM_SPLIT(S.lot_id ,6,'::') AS FROM_SCM_SITE_ID -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영
                      FROM dbo.SCP_PLN_TH_ENG_STOCK_PLAN  S WITH(NOLOCK)
                           -- * 2020.10.27   KSW         2020.08.11 추가된 DISTINCT를 SCM_MST_FINAL_ITEM_V 에 제한적으로 적용하는 것으로 변경 (자동차 TO_SITE_BOH 수량 누락보완)
                           --,dbo.SCM_MST_FINAL_ITEM_V      F WITH(NOLOCK)
                           ,(SELECT DISTINCT F.DIVISION_ID, F.ITEM_ID from dbo.SCM_MST_FINAL_ITEM_V      F WITH(NOLOCK) ) AS F    -- distinct 대상변경
                           ,dbo.SCM_MST_SITE              T WITH(NOLOCK)
                     WHERE 1=1
                       AND S.MASTER_ID  =   @p_master_id
                       --AND PLAN_ID    =   '1060'
                       AND S.PLAN_ID    =   @p_engine_plan_id
                       AND S.LOT_ID     LIKE 'WH%'
                       AND S.ITEM_ID    NOT LIKE 'AMDAU%'
                       AND CONVERT(VARCHAR,RECEIVING_DTTM,112)  >= @start_yyyymmdd --PLAN_START_YYYYMMDD -1일
                       AND dbo.FN_SCM_SPLIT(MASTER_ID,1,'::')   = F.DIVISION_ID
                       AND S.ITEM_ID                            = F.ITEM_ID

                       AND dbo.FN_SCM_SPLIT(MASTER_ID,1,'::')   = T.DIVISION_ID
                       AND SUBSTRING(S.SITE_ID,1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END))  = T.SCM_SITE_ID
                       AND NOT ISNULL(S.INSP_TYPE, '') IN ('INSP_PRE', 'INSP_HOLD')     -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
              ) X   ;

PRINT '--A@X#00150--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    -- 인덱스 (옵션) — sub의 GROUP BY (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SCM_SITE_ID, INCOTERMS, ITEM_ID) 가속용
    CREATE NONCLUSTERED INDEX IX_TMP_SCP_XLS_BOH_KEY
        ON #SCP_XLS_BOH (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SCM_SITE_ID, INCOTERMS, ITEM_ID);

PRINT '--A@X#00200--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

      --ADD 07/01/2023
-----------------------------------------------------------
-------------------------------------------------------------
DECLARE @V_IS_AUTO BIT = 0
SELECT @V_IS_AUTO = dbo.FN_IS_DIVISION( @P_DIVISION_ID, 'CREATE', '81')

;WITH VW_UPDATE_DATA AS
                    (
                    SELECT A.*
                         , B.ITEM_ID_ASSY
                         , ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID
                                                 ORDER BY B.ITEM_ID_ASSY) AS ROW_SEQ
                      FROM  #SCP_XLS_BOH A
                      JOIN SCP_MST_CELL_PROD_ASSY_MAP B WITH(NOLOCK)
                        ON B.ITEM_ID_PROD = A.ITEM_ID
                       AND B.PLANT_ID+'-A' = A.SCM_SITE_ID
                    WHERE A.DIVISION_ID = @P_DIVISION_ID
                     --JV 재고 지원
                      AND ( A.DIVISION_ID = '82' or @V_IS_AUTO  = 1)
                      AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                      AND A.PLAN_TYPE = @P_PLAN_TYPE
                      AND A.SEQ       = @p_seq
                     )
UPDATE A
   SET A.ITEM_ID = B.ITEM_ID_ASSY
FROM #SCP_XLS_BOH A
JOIN (SELECT B.* FROM VW_UPDATE_DATA B WHERE B.ROW_SEQ = 1) B
  ON A.SCM_SITE_ID = B.SCM_SITE_ID
  AND A.ITEM_ID    = B.ITEM_ID
WHERE A.DIVISION_ID = @P_DIVISION_ID
   --JV 재고 지원
  AND ( A.DIVISION_ID = '82' or @V_IS_AUTO  = 1)
  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
  AND A.PLAN_TYPE = @P_PLAN_TYPE
  AND A.SEQ       = @p_seq
;
-----------------------------------------------------------
-------------------------------------------------------------

PRINT '--A@X#00300--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            -------------------------------------------------------------------------------------------------------------
            -- (Option A) #SCP_XLS_PSI_GLOBAL_SMALL 미사용 (PIVOT 결과 테이블 제거됨)
            --   대신 결과를 LONG 형태(#PSI_GLOBAL_SMALL_AUTO)로 그대로 남김.
            -------------------------------------------------------------------------------------------------------------

--DECLARE @debug_mode            NVARCHAR(30) = 'T'
    -------------------------------------------------------------------------------------------------------------
    -- (Stage1) @P_ITEM_IDS 필터 처리 (CELL_ITEM_ID 우선, 빈값이면 ITEM_ID 매칭)
    --   값이 NULL/빈 문자열이면 결과 없이 즉시 종료.
    --   템플릿 형식과 호환을 위해 입력은 'ITEM_ID^PLANT_ID,ITEM_ID^PLANT_ID,...' 또는 'ITEM_ID,ITEM_ID,...'
    --   둘 다 허용 (ITEM_ID 부분만 추출).
    -------------------------------------------------------------------------------------------------------------
    IF @P_ITEM_IDS IS NULL OR LTRIM(RTRIM(@P_ITEM_IDS)) = N''
    BEGIN
        SET @X_STATUS = 0;
        SET @X_MSG    = N'@P_ITEM_IDS is NULL or empty - nothing to do.';
        RETURN;
    END;

    IF OBJECT_ID('tempdb..#FILTER_ITEM') IS NOT NULL DROP TABLE #FILTER_ITEM;
    CREATE TABLE #FILTER_ITEM (
        ITEM_ID NVARCHAR(150) NOT NULL PRIMARY KEY
    );

    -- [DEBUG] #FILTER_ITEM INSERT 사용 변수
    IF @v_is_debug = 1 SELECT CONCAT('@P_ITEM_IDS:', @P_ITEM_IDS) AS "#FILTER_ITEM 사용변수";

    WITH W_P_ITEM AS (
        SELECT DISTINCT
               CASE
                    WHEN CHARINDEX('^', LTRIM(RTRIM(TOKEN))) > 0
                    THEN LEFT(LTRIM(RTRIM(TOKEN)), CHARINDEX('^', LTRIM(RTRIM(TOKEN))) - 1)
                    ELSE LTRIM(RTRIM(TOKEN))
               END AS ITEM_ID
        FROM   STRING_SPLIT(@P_ITEM_IDS, N',')
        WHERE  LTRIM(RTRIM(TOKEN)) <> N''
    )
    INSERT INTO #FILTER_ITEM (ITEM_ID)
    SELECT DISTINCT W_P_ITEM.ITEM_ID
    FROM   SCP_MST_FINAL_ITEM MFI WITH(NOLOCK)
    JOIN   W_P_ITEM ON MFI.ITEM_ID = W_P_ITEM.ITEM_ID
    WHERE  MFI.DIVISION_ID = @P_DIVISION_ID
    AND    MFI.ATTRIBUTE8 = 'CP'
    ;
PRINT '--A@X#00310--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    -- [DEBUG] #FILTER_ITEM INSERT 결과
    IF @v_is_debug = 1 SELECT '#FILTER_ITEM' AS "#FILTER_ITEM", * FROM #FILTER_ITEM;

    IF NOT EXISTS (SELECT 1 FROM #FILTER_ITEM)
    BEGIN
        SET @X_STATUS = 0;
        SET @X_MSG    = N'Parsed @P_ITEM_IDS produced 0 items - nothing to do.';
        RETURN;
    END;

    ----------------------------------------------------------------------------------
    -- 2026-05-11 김준규 [@P_PLANT_IDS 필터 신규]
    --   @P_PLANT_IDS 가 콤마 분리 형식 (예: 'HQ06-A,NJ01-A') 으로 입력되면
    --   #FILTER_PLANT 임시테이블에 적재 → Stage1 DELETE 패턴으로 #PSI_GLOBAL_SMALL 필터.
    --   매칭 대상: #PSI_GLOBAL_SMALL.FROM_SITE (메인 INSERT 들의 FROM_SITE 컬럼 값)
    --   @P_PLANT_IDS 가 빈 값/NULL 이면 PLANT 필터 적용 안 함 (전체 PLANT 대상).
    ----------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#FILTER_PLANT') IS NOT NULL DROP TABLE #FILTER_PLANT;
    CREATE TABLE #FILTER_PLANT (
        PLANT_ID  NVARCHAR(30) NOT NULL PRIMARY KEY
    );

    IF ISNULL(@P_PLANT_IDS, N'') <> N''
    BEGIN
        -- 입력된 경우: 콤마 분리하여 PLANT 리스트 적재
        INSERT INTO #FILTER_PLANT (PLANT_ID)
        SELECT DISTINCT LTRIM(RTRIM(token))
          FROM STRING_SPLIT(@P_PLANT_IDS, N',')
         WHERE LTRIM(RTRIM(token)) <> N'';
    END
    ELSE
    BEGIN
        -- 2026-05-13 김준규 수정:
        --   기존: '*' 와일드카드 1행 INSERT → JOIN ON IN (컬럼, N'*') 이 OR 조건으로 풀려
        --         Hash Match + 카티시안 위험 → 성능 저하
        --   변경: SCM_MST_SITE 마스터의 유효 SCM_SITE_ID 전체 적재
        --         → 모든 JOIN 을 순수 equi-join (= 비교) 로 단순화 가능 → Index Seek
        --   매칭 대상: PRODUCTION_PLAN.SITE_ID / SCM_SITE_ID / FROM_SITE = SCM_SITE_ID (예: 'AZ00-A')
        INSERT INTO #FILTER_PLANT (PLANT_ID)
        SELECT DISTINCT SMS.SCM_SITE_ID
          FROM SCM_MST_SITE SMS WITH(NOLOCK)
         WHERE SMS.VALID_YN    = N'Y'
           AND SMS.DIVISION_ID = @P_DIVISION_ID
           AND SMS.SITE_TYPE   = N'PLANT'
           AND DATALENGTH(SMS.PLANT_ID) < 10
           AND SMS.SCM_SITE_ID IS NOT NULL;
    END

    -- [DEBUG] #FILTER_PLANT INSERT 결과
    IF @v_is_debug = 1 SELECT '#FILTER_PLANT' AS "#FILTER_PLANT", * FROM #FILTER_PLANT;
    PRINT '--A@X#00315_PLANT--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


    ----------------------------------------------------------------------------------
    -- 2026-05-06 김준규 신규 : #FILTER_ITEM_BOTH (사용자 입력 + BOM 양방향 확장)
    --
    --   [도메인]
    --   생산 순서: 전극 제조 → CELL 조립(전극 투입) → PACK 조립(CELL 다수 투입)
    --   BOM 트리 (MODEL_ID = 상위/완제품, CHILD_ITEM_ID = 하위/부품):
    --       PACK   (MODEL)        ← MCCH 의 BOM 부모
    --        ↓ CHILD
    --       CELL   (사용자 입력 MCCH 시리즈, ATTRIBUTE8='CP')
    --        ↓ CHILD
    --       전극   (CHILD)        ← MCCH 의 BOM 자식
    --
    --   [SCP_ANL_PRODUCTION_PLAN 매칭]
    --       OPERATION_GROUP='P' → ITEM_ID 가 PACK 단위
    --       OPERATION_GROUP='A' → ITEM_ID 가 전극 단위
    --       → 입력 CELL 의 BOM 양방향 (부모 PACK + 자식 전극) 모두 포함해야 매칭 가능.
    --
    --   [성능]
    --   SCM_MST_MODEL_FINAL_ITEM_BOM_V 뷰는 GROUP BY+SUM, 추가 뷰 join, 2중 active 검증
    --   으로 비용이 크므로(~15초) 베이스 테이블 SCM_MST_MODEL_BOM 직접 접근.
    --   ALT_PRIORITY='Y' 와 active_flag='Y' 만 검증.
    ----------------------------------------------------------------------------------
    -- (1) BOM 슬라이스 사전 캐싱 : 사용자 입력의 부모/자식 BOM 관계만 1회 추출
    IF OBJECT_ID('tempdb..#FILTER_BOM') IS NOT NULL DROP TABLE #FILTER_BOM;
    CREATE TABLE #FILTER_BOM (
         MODEL_ID      NVARCHAR(150) NOT NULL
        ,CHILD_ITEM_ID NVARCHAR(150) NOT NULL
        ,INDEX IX_FB_M  NONCLUSTERED (MODEL_ID)
        ,INDEX IX_FB_C  NONCLUSTERED (CHILD_ITEM_ID)
    );

    INSERT INTO #FILTER_BOM (MODEL_ID, CHILD_ITEM_ID)
    SELECT DISTINCT B.MODEL_ID, B.CHILD_ITEM_ID
      FROM DBO.SCM_MST_MODEL_BOM B WITH(NOLOCK)
      INNER JOIN #FILTER_ITEM FI ON B.MODEL_ID = FI.ITEM_ID            -- (자식 전극 방향)
     WHERE B.DIVISION_ID  = @P_DIVISION_ID
       AND B.ALT_PRIORITY = 'Y'
    UNION
    SELECT B.MODEL_ID, B.CHILD_ITEM_ID
      FROM DBO.SCM_MST_MODEL_BOM B WITH(NOLOCK)
      INNER JOIN #FILTER_ITEM FI ON B.CHILD_ITEM_ID = FI.ITEM_ID       -- (부모 PACK 방향)
     WHERE B.DIVISION_ID  = @P_DIVISION_ID
       AND B.ALT_PRIORITY = 'Y'
    OPTION (RECOMPILE);   -- 입력 행수 정확히 사용 (sniffing 방지)

    -- (2) #FILTER_ITEM_BOTH : 캐시된 BOM 으로부터 빠르게 구성
    IF OBJECT_ID('tempdb..#FILTER_ITEM_BOTH') IS NOT NULL DROP TABLE #FILTER_ITEM_BOTH;
    CREATE TABLE #FILTER_ITEM_BOTH (
        ITEM_ID NVARCHAR(150) NOT NULL PRIMARY KEY
    );

    INSERT INTO #FILTER_ITEM_BOTH (ITEM_ID)
    SELECT DISTINCT T.ITEM_ID
      FROM (
            -- (a) 사용자 입력 CELL 그대로
            SELECT ITEM_ID FROM #FILTER_ITEM
            UNION
            -- (b) BOM 부모 PACK
            SELECT MODEL_ID FROM #FILTER_BOM
            UNION
            -- (c) BOM 자식 전극
            SELECT CHILD_ITEM_ID FROM #FILTER_BOM
           ) T
     WHERE T.ITEM_ID IS NOT NULL AND T.ITEM_ID <> N''
    OPTION (RECOMPILE);

PRINT '--A@X#00320--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    -- [DEBUG] #FILTER_ITEM_BOTH INSERT 결과
    IF @v_is_debug = 1 SELECT '#FILTER_ITEM_BOTH' AS "#FILTER_ITEM_BOTH", * FROM #FILTER_ITEM_BOTH;

    ----------------------------------------------------------------------------------
    -- 2026-05-14 김준규 [STAGING PATTERN 1단계]: source 2개를 사전 필터링하여 임시테이블 빌드
    --   - SCP_ANL_PRODUCTION_PLAN: 6곳 사용 → 1회 빌드
    --   - SCP_ANL_SHIPMENT_PLAN_FG: 5곳 사용 → 1회 빌드
    --   - #FILTER_ITEM_BOTH + #FILTER_PLANT + PK 4개 (DIV/PLAN_START/TYPE/SEQ) 만 사전 적용
    --   - 사용처 추가 필터 (MEASURE, YYYYMMDD 등) 는 사용처에서 그대로 적용
    --   - 작업용 인덱스 추가 → 이후 사용처 SEEK 가능
    ----------------------------------------------------------------------------------

    -- (1) #STG_PROD_PLAN: SCP_ANL_PRODUCTION_PLAN 의 필터된 사본
    IF OBJECT_ID('tempdb..#STG_PROD_PLAN') IS NOT NULL DROP TABLE #STG_PROD_PLAN;

    -- 2026-05-15 김준규: PIVOT 결과 안전망 + row 대폭 감소
    --   - 첫 2일은 QTY=0 도 보존 → 모든 PK 조합이 PIVOT 행에 등장 보장
    --   - 그 외 일자는 QTY <> 0 만 → row 80%+ 감소
    --   - PIVOT 시 NULL → ISNULL(...,0) 처리되어 AS-IS 결과 100% 동일
    --   - UNION ALL 로 분리하여 각 부분 인덱스 SEEK (OR 조건은 SARGable 처리 어려움)
    DECLARE @v_stg_keep_until_yyyymmdd NVARCHAR(8) =
            CONVERT(NVARCHAR(8), DATEADD(DAY, 1, CONVERT(DATE, @p_plan_start_yyyymmdd, 112)), 112);

    SELECT A.*
      INTO #STG_PROD_PLAN
      FROM (
            -- (1-a) 첫 2일 전체 (PK 조합 안전망, QTY=0 포함)
            SELECT A.*
              FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
             INNER JOIN #FILTER_ITEM_BOTH F  WITH(NOLOCK) ON A.ITEM_ID    = F.ITEM_ID
             INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = A.SCM_SITE_ID
             WHERE A.DIVISION_ID         = @P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
               AND A.PLAN_TYPE           = @P_PLAN_TYPE
               AND A.SEQ                 = @p_seq
               AND A.YYYYMMDD            <= @v_stg_keep_until_yyyymmdd

            UNION ALL

            -- (1-b) 그 외 일자: QTY <> 0 만
            SELECT A.*
              FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
             INNER JOIN #FILTER_ITEM_BOTH F  WITH(NOLOCK) ON A.ITEM_ID    = F.ITEM_ID
             INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = A.SCM_SITE_ID
             WHERE A.DIVISION_ID         = @P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
               AND A.PLAN_TYPE           = @P_PLAN_TYPE
               AND A.SEQ                 = @p_seq
               AND A.YYYYMMDD            >  @v_stg_keep_until_yyyymmdd
               AND A.QTY                 <> 0
           ) A
    OPTION (RECOMPILE);

    CREATE NONCLUSTERED INDEX IX_stg_prod_plan_item
        ON #STG_PROD_PLAN (ITEM_ID, SCM_SITE_ID, MEASURE);

    CREATE NONCLUSTERED INDEX IX_stg_prod_plan_meas
        ON #STG_PROD_PLAN (MEASURE, OPERATION_GROUP, YYYYMMDD);

    -- 2026-05-14 김준규: L6361, L6474 복합 JOIN (가장 무거운 사용처) 최적화
    CREATE NONCLUSTERED INDEX IX_stg_prod_plan_join
        ON #STG_PROD_PLAN (OPERATION_ID, SCM_SITE_ID, LINE_ID, YYYYMMDD)
        INCLUDE (ITEM_ID, QTY, MEASURE);

    -- 2026-05-14 김준규: L1145, L1160 (UNION), L1785 (NOT EXISTS) 최적화
    CREATE NONCLUSTERED INDEX IX_stg_prod_plan_line
        ON #STG_PROD_PLAN (LINE_ID, MEASURE, OPERATION_GROUP)
        INCLUDE (ITEM_ID, SCM_SITE_ID, YYYYMMDD, QTY);

PRINT '--A@X#00320_STG_PROD--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    -- [DEBUG]
    IF @v_is_debug = 1 SELECT '#STG_PROD_PLAN' AS "#STG_PROD_PLAN", COUNT(*) AS row_cnt FROM #STG_PROD_PLAN;

    -- (2) #STG_SHIP_FG: SCP_ANL_SHIPMENT_PLAN_FG 의 필터된 사본
    IF OBJECT_ID('tempdb..#STG_SHIP_FG') IS NOT NULL DROP TABLE #STG_SHIP_FG;
    SELECT A.*
      INTO #STG_SHIP_FG
      FROM (
            -- (2-a) 첫 2일 전체 (PK 안전망)
            SELECT A.*
              FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
             INNER JOIN #FILTER_ITEM_BOTH F  WITH(NOLOCK) ON A.ITEM_ID    = F.ITEM_ID
             INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = A.FROM_SITE
             WHERE A.DIVISION_ID         = @P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
               AND A.PLAN_TYPE           = @P_PLAN_TYPE
               AND A.SEQ                 = @p_seq
               AND A.YYYYMMDD            >= @p_plan_start_yyyymmdd
               AND A.YYYYMMDD            <= @v_stg_keep_until_yyyymmdd

            UNION ALL

            -- (2-b) 그 외 일자: QTY <> 0 만
            SELECT A.*
              FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
             INNER JOIN #FILTER_ITEM_BOTH F  WITH(NOLOCK) ON A.ITEM_ID    = F.ITEM_ID
             INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = A.FROM_SITE
             WHERE A.DIVISION_ID         = @P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
               AND A.PLAN_TYPE           = @P_PLAN_TYPE
               AND A.SEQ                 = @p_seq
               AND A.YYYYMMDD            >  @v_stg_keep_until_yyyymmdd
               AND A.YYYYMMDD            <= @p_to_yyyymmdd
               AND A.QTY                 <> 0
           ) A
    OPTION (RECOMPILE);

    CREATE NONCLUSTERED INDEX IX_stg_ship_fg_item
        ON #STG_SHIP_FG (ITEM_ID, FROM_SITE, MEASURE);

    CREATE NONCLUSTERED INDEX IX_stg_ship_fg_meas
        ON #STG_SHIP_FG (MEASURE, YYYYMMDD);

    -- 2026-05-14 김준규: L959 #BOD_TRANSPORT LEFT JOIN 최적화
    CREATE NONCLUSTERED INDEX IX_stg_ship_fg_bod
        ON #STG_SHIP_FG (BOD_ID, FROM_SITE)
        INCLUDE (ITEM_ID, MEASURE, YYYYMMDD, QTY);

PRINT '--A@X#00320_STG_SHIPFG--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    -- [DEBUG]
    IF @v_is_debug = 1 SELECT '#STG_SHIP_FG' AS "#STG_SHIP_FG", COUNT(*) AS row_cnt FROM #STG_SHIP_FG;

    -- (3) #STG_SHIP_SEMI: SCP_ANL_SHIPMENT_PLAN_SEMI 의 필터된 사본
    -- 2026-05-15 김준규: SEMI 는 CELL 단위 → #FILTER_ITEM 만 적용 (BOM 양방향 X)
    --   #FILTER_PLANT 사용 안 함 (SEMI 사용처와 동일 — PLANT 필터 없음)
    IF OBJECT_ID('tempdb..#STG_SHIP_SEMI') IS NOT NULL DROP TABLE #STG_SHIP_SEMI;
    SELECT A.*
      INTO #STG_SHIP_SEMI
      FROM (
            -- (3-a) 첫 2일 전체 (PK 안전망)
            SELECT A.*
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)
             INNER JOIN #FILTER_ITEM F WITH(NOLOCK) ON A.ITEM_ID = F.ITEM_ID
             --2026-05-20 김준규 #FILTER_PLANT 추가
             INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = A.FROM_SITE
             WHERE A.DIVISION_ID         = @P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
               AND A.PLAN_TYPE           = @P_PLAN_TYPE
               AND A.SEQ                 = @p_seq
               AND A.YYYYMMDD            >= @p_plan_start_yyyymmdd
               AND A.YYYYMMDD            <= @v_stg_keep_until_yyyymmdd

            UNION ALL

            -- (3-b) 그 외 일자: QTY <> 0 만
            SELECT A.*
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)
             INNER JOIN #FILTER_ITEM F WITH(NOLOCK) ON A.ITEM_ID = F.ITEM_ID
             --2026-05-20 김준규 #FILTER_PLANT 추가
             INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = A.FROM_SITE
             WHERE A.DIVISION_ID         = @P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
               AND A.PLAN_TYPE           = @P_PLAN_TYPE
               AND A.SEQ                 = @p_seq
               AND A.YYYYMMDD            >  @v_stg_keep_until_yyyymmdd
               AND A.YYYYMMDD            <= @p_to_yyyymmdd
               AND A.QTY                 <> 0
           ) A
    OPTION (RECOMPILE);

    CREATE NONCLUSTERED INDEX IX_stg_ship_semi_item
        ON #STG_SHIP_SEMI (ITEM_ID, FROM_SITE, MEASURE)
        INCLUDE (TO_SITE, BOD_ID, YYYYMMDD, QTY);

    CREATE NONCLUSTERED INDEX IX_stg_ship_semi_meas
        ON #STG_SHIP_SEMI (MEASURE, YYYYMMDD);

PRINT '--A@X#00320_STG_SHIPSEMI--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    -- [DEBUG]
    IF @v_is_debug = 1 SELECT '#STG_SHIP_SEMI' AS "#STG_SHIP_SEMI", COUNT(*) AS row_cnt FROM #STG_SHIP_SEMI;

    ----------------------------------------------------------------------------------
    -- 2026-05-07 김준규 신규 : #BOM_FULL_CACHE
    --   목적 : SCM_MST_MODEL_FINAL_ITEM_BOM_V 뷰는 GROUP BY+SUM, 추가 뷰 join 등으로 비용 큼.
    --          이 뷰를 SP 내에서 여러 번 호출하면 성능 누적 영향.
    --          → 1회만 호출하여 임시테이블에 캐시 후, 모든 사용처에서 캐시 활용.
    --   사용처 : (1) SEMI_SHIP_PLAN INSERT 의 BOM 검증 (line 1673 부근, 00800~00900 구간)
    --            (2) CELL_ITEM_ID UPDATE (line 5851 부근, 02300~02400 구간)
    ----------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#BOM_FULL_CACHE') IS NOT NULL DROP TABLE #BOM_FULL_CACHE;
    CREATE TABLE #BOM_FULL_CACHE (
         DIVISION_ID         NVARCHAR(50)  NOT NULL
        ,PLANT_ID            NVARCHAR(50)  NOT NULL
        ,MODEL_ID            NVARCHAR(150) NOT NULL
        ,CHILD_ITEM_ID       NVARCHAR(150) NOT NULL
        ,OPERATION_GROUP_ID  NVARCHAR(10)  NULL
        ,ELECTRODE_TYPE      NVARCHAR(10)  NULL
        ,CELL_TYPE           NVARCHAR(10)  NULL
        ,INDEX IX_BFC_M_P  NONCLUSTERED (MODEL_ID, PLANT_ID, OPERATION_GROUP_ID, ELECTRODE_TYPE)
        ,INDEX IX_BFC_M_CT NONCLUSTERED (MODEL_ID, OPERATION_GROUP_ID, CELL_TYPE)
    );

    INSERT INTO #BOM_FULL_CACHE (DIVISION_ID, PLANT_ID, MODEL_ID, CHILD_ITEM_ID, OPERATION_GROUP_ID, ELECTRODE_TYPE, CELL_TYPE)
    SELECT DISTINCT V.DIVISION_ID, V.PLANT_ID, V.MODEL_ID, V.CHILD_ITEM_ID,
                    V.OPERATION_GROUP_ID, V.ELECTRODE_TYPE, V.CELL_TYPE
      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH(NOLOCK)
     WHERE V.DIVISION_ID = @P_DIVISION_ID
       AND V.OPERATION_GROUP_ID = 'A'    -- 2026-05-07 김준규: 사용처 모두 'A' 만 → 사전 필터로 캐시 row 수 대폭 감소
    OPTION (RECOMPILE);

PRINT '--A@X#00330--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    IF @v_is_debug = 1 SELECT '#BOM_FULL_CACHE' AS "#BOM_FULL_CACHE", COUNT(*) AS cnt FROM #BOM_FULL_CACHE;


    ----------------------------------------------------------------------------------
    -- 2026-05-19 김준규 신규 : #BOM_LINE_ASSIGN_CACHE
    --   목적 : SCM_MST_MODEL_FINAL_ITEM_BOM_V 뷰가 #LINE_ASSIGN 빌드 시 두 번 호출됨
    --          (V1: OPERATION_GROUP_ID <> 'E', V2: = 'A') → 9.3초 → 캐시로 단축
    --   사용처 : (1) #LINE_ASSIGN UNION ALL V1 분기
    --            (2) #LINE_ASSIGN UNION ALL V2 분기 (= 'A')
    --   #FILTER_PLANT 사전 필터로 row 수 추가 감소
    ----------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#BOM_LINE_ASSIGN_CACHE') IS NOT NULL DROP TABLE #BOM_LINE_ASSIGN_CACHE;
    CREATE TABLE #BOM_LINE_ASSIGN_CACHE (
         DIVISION_ID         NVARCHAR(50)  NOT NULL
        ,PLANT_ID            NVARCHAR(50)  NOT NULL
        ,MODEL_ID            NVARCHAR(150) NOT NULL
        ,CHILD_ITEM_ID       NVARCHAR(150) NOT NULL
        ,OPERATION_GROUP_ID  NVARCHAR(10)  NOT NULL
        ,INDEX IX_BLAC_P_M  NONCLUSTERED (PLANT_ID, MODEL_ID, OPERATION_GROUP_ID)
        ,INDEX IX_BLAC_M_C  NONCLUSTERED (MODEL_ID, CHILD_ITEM_ID, OPERATION_GROUP_ID)
    );

    INSERT INTO #BOM_LINE_ASSIGN_CACHE (DIVISION_ID, PLANT_ID, MODEL_ID, CHILD_ITEM_ID, OPERATION_GROUP_ID)
    SELECT DISTINCT V.DIVISION_ID, V.PLANT_ID, V.MODEL_ID, V.CHILD_ITEM_ID, V.OPERATION_GROUP_ID
      FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH(NOLOCK)
      INNER JOIN #FILTER_PLANT FP WITH(NOLOCK) ON FP.PLANT_ID = V.PLANT_ID
     WHERE V.DIVISION_ID = @P_DIVISION_ID
       AND V.OPERATION_GROUP_ID <> 'E'
    OPTION (RECOMPILE);

    IF @v_is_debug = 1 SELECT '#BOM_LINE_ASSIGN_CACHE' AS "#BOM_LINE_ASSIGN_CACHE", COUNT(*) AS cnt FROM #BOM_LINE_ASSIGN_CACHE;


----SELECT * FROM SCP_MST_CELL_PROD_ASSY_MAP WITH(NOLOCK) WHERE ITEM_ID_ASSY = 'MAP303994C10'
--    IF OBJECT_ID('tempdb..#FILTER_ITEM_FG') IS NOT NULL DROP TABLE FILTER_ITEM_FG;
--    CREATE TABLE #FILTER_ITEM_FG (
--        ITEM_ID NVARCHAR(50) NOT NULL,
--        ITEM_ID_FG NVARCHAR(50) NOT NULL
--        PRIMARY KEY(ITEM_ID,ITEM_ID_FG)
--    );

--    INSERT INTO #FILTER_ITEM_FG(ITEM_ID,ITEM_ID_FG)
--    SELECT DISTINCT ITEM_ID_ASSY,ITEM_ID_PROD
--    FROM   SCP_MST_CELL_PROD_ASSY_MAP PAM WITH(NOLOCK)
--    JOIN   #FILTER_ITEM FI ON FI.ITEM_ID = PAM.ITEM_ID_ASSY
--    WHERE  PAM.DIVISION_ID=@P_DIVISION_ID
--    AND    PAM.PLANT_ID=@P_PLANT_IDS;

--    -- [DEBUG] ##FILTER_ITEM_FG INSERT 결과
--    IF @v_is_debug = 1 SELECT '#FILTER_ITEM_FG' AS "#FILTER_ITEM_FG", * FROM #FILTER_ITEM_FG;


PRINT '--A@X#00400--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    -- ============================================================================================
    -- [Method B] #PSI_MEASURE_DAILY  : daily_small 비즈니스 로직에서 사용하는 MEASURE + ORDER
    --   목적: SP 전체에서 단일 source-of-truth 로 사용 (성능 + 유지보수)
    --   참고: PR_SCP_XLS_DAILY_SMALL 의 MEASURE_ORDER CASE WHEN (10..130) + 생산/재고 메저 (140..200)
    -- ============================================================================================
    IF OBJECT_ID('tempdb..#PSI_MEASURE_DAILY') IS NOT NULL DROP TABLE #PSI_MEASURE_DAILY;
    CREATE TABLE #PSI_MEASURE_DAILY (
         MEASURE        NVARCHAR(100) NOT NULL PRIMARY KEY
        ,MEASURE_ORDER  INT           NOT NULL                  -- level1 (대분류 순서)
        ,MEASURE_LEVEL2 INT           NOT NULL DEFAULT 100      -- 2026-05-30 김준규: level2 (동일 level1 그룹 내부 순서; 기본 1, SEMI 등만 1/2/3)
    );
    INSERT INTO #PSI_MEASURE_DAILY (MEASURE, MEASURE_ORDER, MEASURE_LEVEL2) VALUES
         (N'MKT_FCST', 10, 100)
        ,(N'ALLOCATION', 20, 100)
        ,(N'FCST_RTF_ACC', 30, 100)
        ,(N'TO_SITE_BOH', 40, 100)
        ,(N'TO_SITE_EOH', 50, 100)
        ,(N'INTRANSIT', 60, 100)
        ,(N'INTRANSIT_ETA', 70, 100)
        -- 2026-05-31 김준규: SEMI_INTRANSIT/SEMI_INTRANSIT_ETA 는 #PSI 명시 제외 → 마스터 보충(9999)로 맨뒤 정렬(기존처럼 미표시)
        ,(N'WHIN_TOTAL', 80, 100)
        ,(N'WHIN', 90, 100)
        ,(N'SHIP_REQ', 95, 100)
        ,(N'SHIP_PLAN_ETA', 100, 100)
        ,(N'SEMI_SHIP_PLAN_ORG', 105, 100)
        ,(N'SEMI_SHIP_PLAN', 105, 200)
        ,(N'SEMI_SHIP_GAP_ACC', 105, 300)
        ,(N'SHIP_PLAN', 120, 100)
        ,(N'SHIP_PLAN_PLANT', 130, 100)
        ,(N'WHIN_BALANCE', 150, 100)
        --
        ,(N'SEMI_SHIP_PLAN_TOTAL', 200, 100)             -- 2026-06-04 김준규: AS-WAS 순서 기준 (CELL_EOH 상단 보조1)
        ,(N'SHIP_PLAN_TOTAL', 210, 100)                  -- 보조2
        ,(N'CELL_EOH', 220, 100)                         -- 기준 행
        ,(N'CELL_FORM_HOLD_AFTER', 230, 100)             -- CELL_EOH 바로 아래 (AS-WAS)
        ,(N'CELL_FORM_PROGRESS', 240, 100)
        ,(N'CELL_FORM_HOLD_UNDER_AVAILABLE', 250, 100)
        ,(N'CELL_FOR_FORM_END', 260, 100)
        ,(N'CELL_PROD_FORM_END', 270, 100)
        ,(N'CELL_PROD', 280, 100)
        ,(N'CELL_CHAR_PLAN', 285, 100)                   -- 2026-06-04 김준규: 신규 등록 (데이터 있을 시 정렬)
        ,(N'CELL_SHIP_PLAN_TOTAL', 290, 100)             -- 2026-06-04 김준규: 신규 등록
        ,(N'CELL_CHAR_AVAILABLE', 295, 100)              -- 2026-06-04 김준규: 신규 등록
        ,(N'EOH_TOTAL', 999, 100);                       -- 그룹 맨 마지막

    -- 2026-05-30 김준규: 위 명시 measure 외 마스터(SCM_MST_SHEET_MEASURE)의 나머지 measure 보충
    --   목적: #PSI_MEASURE_DAILY 가 전체 measure 를 빠짐없이 포함하도록 하여
    --         PIVOT 직전 SORT_ORDER_NO sync(INNER JOIN) 가 100% 커버 → NULL 정렬 사고 차단.
    --   정렬값: 마스터에 신뢰할 정렬 컬럼이 없으므로 9999(맨뒤). 순서가 중요한 measure 는 위 명시 INSERT 에 둘 것.
    INSERT INTO #PSI_MEASURE_DAILY (MEASURE, MEASURE_ORDER, MEASURE_LEVEL2)
    SELECT M.COLUMN_NAME, 9999, 100
      FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
     WHERE M.PROGRAM_ID = @p_program_id
       AND NOT EXISTS (SELECT 1 FROM #PSI_MEASURE_DAILY D WHERE D.MEASURE = M.COLUMN_NAME);
    PRINT N'--A@X#00823_PMD_FILL-- #PSI_MEASURE_DAILY 마스터 보충(9999): ' + CAST(@@ROWCOUNT AS NVARCHAR(20)) + N' rows';

    -- [DEBUG] #PSI_MEASURE_DAILY INSERT 결과
    IF @v_is_debug = 1 SELECT '#PSI_MEASURE_DAILY' AS "#PSI_MEASURE_DAILY", * FROM #PSI_MEASURE_DAILY;


---------------------------------------------------------------------------------------------------------------
--            -- PLAN 기간설정 - 2021.11.19
--            -------------------------------------------------------------------------------------------------------------
--            -- [merged] DECLARE @v_bp_flag      NVARCHAR(8) = '';   (duplicate; declared in header)

--            SELECT @p_to_yyyymmdd = p.horizon_end_date,
--                   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end)
--            FROM   dbo.scm_mst_plan p WITH(NOLOCK)
--            WHERE  p.division_id = @P_DIVISION_ID
--            AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @P_DIVISION_ID and plan_id < 9999)
--            AND    p.plan_cycle  = 'WEEKLY'
--            ;

--            IF @v_bp_flag = 'Y'
--            BEGIN
--                -- 중장기일 경우 104주차로 변경
--                SET @p_to_yyyymmdd = CONVERT(VARCHAR(8), DATEADD(day, 363, (CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112))), 112);
--            END

            -------------------------------------------------------------------------------------------------------------
            -- MEASURE 정보
            -------------------------------------------------------------------------------------------------------------
                IF OBJECT_ID('tempdb..#MEASURE') IS NOT NULL
                  DROP TABLE #MEASURE;

              /* MEASURE 세팅값 추출 */
              -- MEASURE_ORDER (옵션 C: SHIP 16 + PROD 7)
              ;WITH W_M_SEQ AS (
                  -- 2026-05-30 김준규: measure 순서 단일 소스화 — #PSI_MEASURE_DAILY 참조로 통일
                  --   (기존 하드코딩 28종 리스트 제거. measure/순서는 #PSI_MEASURE_DAILY 한 곳에서만 관리)
                  SELECT MEASURE AS M_CODE
                       , MEASURE_ORDER * 1000 + MEASURE_LEVEL2 AS M_SEQ   -- 2026-05-30 김준규: level1*1000 + level2 합성 (level2 100단위라 사이 삽입 여유; level1 간 충돌 없음)
                    FROM #PSI_MEASURE_DAILY WITH(NOLOCK)
              )
              --SELECT * fROM W_M_SEQ
              --2026-05-20 김준규 추가(REPORT와 동일 하게 맞추기)
              --SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME,M.SORT_ORDER_NO,(CASE WHEN ATTRIBUTE1 ='PACK' THEN 'P' WHEN ATTRIBUTE1 ='CELL' THEN 'A'  ELSE 'C' END) AS DIV, ATTRIBUTE2 AS GUBUN
              SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME,ISNULL(M_SEQ,9999) AS SORT_ORDER_NO,(CASE WHEN ATTRIBUTE1 ='PACK' THEN 'P' WHEN ATTRIBUTE1 ='CELL' THEN 'A'  ELSE 'C' END) AS DIV, ATTRIBUTE2 AS GUBUN
              INTO #MEASURE
              FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
              LEFT JOIN W_M_SEQ ON M_CODE = M.COLUMN_NAME
                WHERE M.PROGRAM_ID      = @p_program_id --= N'XLSPSI01';
                  AND M.VALID_YN        = 'Y'
                AND M.COLUMN_NAME IN (   -- [Method B] 17 종 + 생산/재고 메저로 #MEASURE 사전 필터
                              N'MKT_FCST',
                              N'ALLOCATION',
                              N'FCST_RTF_ACC',
                              N'TO_SITE_BOH',
                              N'TO_SITE_EOH',
                              N'INTRANSIT',
                              N'INTRANSIT_ETA',
                              N'WHIN_TOTAL',
                              N'WHIN',
                              N'SHIP_REQ',
                              N'SHIP_PLAN',
                              N'SHIP_PLAN_ETA',
                              N'SHIP_PLAN_PLANT',
                              N'SEMI_SHIP_PLAN_ORG',
                              N'SEMI_SHIP_PLAN',
                              N'SEMI_SHIP_GAP_ACC',
                              N'CELL_EOH',
                              N'CELL_FOR_FORM_END',
                              N'CELL_PROD_FORM_END',
                              N'CELL_PROD',
                              N'CELL_FORM_PROGRESS',
                              N'CELL_FORM_HOLD_UNDER_AVAILABLE',
                              N'CELL_FORM_HOLD_AFTER',
                              -- 2026-05-22 김준규 신규: CELL_EOH 보정 후 추가되는 3종 measure
                              N'SEMI_SHIP_PLAN_TOTAL',
                              N'SHIP_PLAN_TOTAL',
                              N'EOH_TOTAL'
                          )

    -- [DEBUG] #MEASURE INSERT 결과
    IF @v_is_debug = 1 SELECT '#MEASURE' AS "#MEASURE", * FROM #MEASURE;

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## MEASURE SETTING ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE SETTING';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -------------------------------------------------------------------------------------------------------------
            --  데이터 이관 ('MKT_FCST','SHIP_PLAN','PRODUCTION')
            -------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL') IS NOT NULL
                DROP TABLE #PSI_GLOBAL_SMALL;

                CREATE TABLE #PSI_GLOBAL_SMALL (
                     DIVISION_ID          NVARCHAR(060)
                    ,OPERATION_GROUP      NVARCHAR(060)
                    ,CELL_ITEM_ID         NVARCHAR(100)
                    ,ITEM_ID              NVARCHAR(100)
                    ,TO_SITE              NVARCHAR(060)
                    ,PROJECT_CODE         NVARCHAR(050)     -- FG 때문에 추가
                    ,TO_BOH_QTY           numeric(20,10)    --BIGINT
                    ,FROM_BOH_QTY         numeric(20,10)    -- BIGINT
                    ,INCOTERMS            NVARCHAR(20)
                    ,FROM_SITE            NVARCHAR(60)
                    ,TRANSPORT_MODE       NVARCHAR(50)
                    ,PROD_LINE            NVARCHAR(50)
                    ,MEASURE              NVARCHAR(100)
                    ,YYYYMMDD             NVARCHAR(010)
                    ,QTY                  NUMERIC(19,3) -- E20260908-000533 형 시뮬레이터 조회 시 오류 팝업 발생 (20,10) -> (19, 3) 으로 변경
                    ,SORT_ORDER_NO        INT
                    ,COLUMN_LABEL_NAME    NVARCHAR(300)
                    ,BOD_ID               NVARCHAR(300)
                    ,ATTRIBUTE1           NVARCHAR(150)
                    ,ATTRIBUTE9           NVARCHAR(150)   -- OPERATION_ID
                );

            -------------------------------------------------------------------------------------------------------------------------
            -- SHIP_PLAN (FG) (팩,셀 공통) - MKT_FCST, SHIP_PLAN, SHIP_REQ
            -------------------------------------------------------------------------------------------------------------------------
            -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 / 기존 로직 주석처리
            /*
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
                        , A.MEASURE                                             -- SHIP_PLAN FG
                        , A.YYYYMMDD        AS YYYYMMDD
                  , ISNULL(A.QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
                        , M.SORT_ORDER_NO
                        , CASE WHEN A.MEASURE = 'SHIP_REQ' THEN 'SHIP REQ'  ELSE  M.COLUMN_LABEL_NAME END AS COLUMN_LABEL_NAME
                        , A.BOD_ID
                  , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1
                        , A.ATTRIBUTE9
                   FROM #STG_SHIP_FG A WITH(NOLOCK)
                 LEFT JOIN #MEASURE M WITH(NOLOCK)
                    ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST', 'SHIP_REQ')
                    AND A.MEASURE             = M.COLUMN_NAME
                 WHERE 1=1
                    AND A.MEASURE             IN ('SHIP_PLAN','MKT_FCST', 'SHIP_REQ')
                    -- 중복값 수정이 안되는 현상 발생하여 제거함 : KSK, 2023-07-10
                    --AND PROJECT_CODE != '-'
            */

            -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 시작
            IF OBJECT_ID('tempdb..#BOD_TRANSPORT') IS NOT NULL
                DROP TABLE #BOD_TRANSPORT;

            SELECT
                 B.DIVISION_ID
                ,B.BOD_ID
                ,B.FROM_SITE
                ,MIN(B.TRANSPORT_MODE) AS TRANSPORT_MODE   -- TOP 1과 동일 효과
            INTO #BOD_TRANSPORT
            FROM SCP_MST_BOD_N_V B WITH(NOLOCK)
            --2026-05-20 김준규 FROM SITEM 추가
            INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = B.FROM_SITE
            WHERE B.DIVISION_ID = @P_DIVISION_ID
            GROUP BY
                 B.DIVISION_ID
                ,B.BOD_ID
                ,B.FROM_SITE;

            CREATE CLUSTERED INDEX CX_BOD_TRANSPORT
                ON #BOD_TRANSPORT (DIVISION_ID, BOD_ID, FROM_SITE);

    -- [DEBUG] #MEASURE INSERT 결과
    IF @v_is_debug = 1 SELECT '#BOD_TRANSPORT' AS "#BOD_TRANSPORT", * FROM #BOD_TRANSPORT;

            -- Step 2: #MEASURE 필터링 (SHIP_PLAN, MKT_FCST, SHIP_REQ만 미리 필터)
            IF OBJECT_ID('tempdb..#MEASURE_FILTERED') IS NOT NULL
                DROP TABLE #MEASURE_FILTERED;

            WITH MEASURE AS (
            SELECT
                 M.COLUMN_NAME
                ,CASE WHEN M.COLUMN_NAME = 'WHIN'      THEN 'WH_IN'
                      WHEN M.COLUMN_NAME = 'SHIP_PLAN' THEN 'SHIP_PLAN_AMEND'   -- 2026-05-29 김준규: SHIPMENT_PLAN_FG 의 SHIP_PLAN 소스를 SHIP_PLAN_AMEND 로 변경 (출력은 SHIP_PLAN 유지)
                      ELSE M.COLUMN_NAME END QRY_COLUMN_NAME
                ,M.COLUMN_LABEL_NAME
                ,M.SORT_ORDER_NO
            --SELECT M.*
            FROM #MEASURE M WITH(NOLOCK)
            --WHERE M.COLUMN_NAME IN ('SHIP_PLAN','MKT_FCST') --,'SHIP_REQ')
            --2026-05-04 김준규 WHIN 추가
            WHERE M.COLUMN_NAME IN ('SHIP_PLAN','MKT_FCST','WHIN') --,'SHIP_REQ')
            UNION ALL
            SELECT N'SHIP_REQ' AS COLUMN_NAME
                  ,N'SHIP_REQ' AS QRY_COLUMN_NAME
                  ,N'SHIP REQ' AS COLUMN_LABEL_NAME
                  --,NULL AS SORT_ORDER_NO
                  --2026-05-04 김준규 NULL을 95로 변경함.
                  ,95 AS SORT_ORDER_NO
            )
            SELECT M.COLUMN_NAME
                ,M.QRY_COLUMN_NAME
                ,M.COLUMN_LABEL_NAME
                ,M.SORT_ORDER_NO
            INTO #MEASURE_FILTERED
            FROM  MEASURE M
            ;

            CREATE CLUSTERED INDEX CX_MEASURE_FILTERED
            ON #MEASURE_FILTERED (QRY_COLUMN_NAME);

    -- [DEBUG] #MEASURE_FILTERED INSERT 결과
    IF @v_is_debug = 1 SELECT '#MEASURE_FILTERED' AS "#MEASURE_FILTERED", * FROM #MEASURE_FILTERED;

            -- Step 3: 메인 INSERT - Hash Match 제거, 상관 서브쿼리 제거
            -- OPTION(LOOP JOIN) + MAXDOP(1) 또는 HASH JOIN 힌트 제거로
            -- 메모리 그랜트 최소화
            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 사용 변수
            IF @v_is_debug = 1 SELECT CONCAT('@P_DIVISION_ID:', @P_DIVISION_ID, '|', '@p_plan_start_yyyymmdd:', @p_plan_start_yyyymmdd, '|', '@P_PLAN_TYPE:', @P_PLAN_TYPE, '|', '@p_seq:', @p_seq, '|', '@p_to_yyyymmdd:', @p_to_yyyymmdd) AS "#PSI_GLOBAL_SMALL 사용변수";

            --SELECT '#FILTER_ITEM',*FROM #FILTER_ITEM;
            --SELECT '#FILTER_ITEM_FG',*FROM #FILTER_ITEM_FG;
            --SELECT '#MEASURE_FILTERED',*FROM #MEASURE_FILTERED;
            --SELECT '#BOD_TRANSPORT',*FROM #BOD_TRANSPORT;

            --2026-04-27 FN의 MEASURE 종류 참조
            --MEASURE
            --ALLOCATION
            --BALANCE
            --MKT_FCST
            --SHIP_PLAN
            --SHIP_PLAN_AMEND
            --SHIP_REQ
            --WH_IN

            INSERT INTO #PSI_GLOBAL_SMALL WITH (TABLOCKX)         -- INSERT 시 잠금 경합 최소화
            SELECT
                 A.DIVISION_ID
                ,A.BIZ_TYPE
                ,''                                                              AS CELL_ITEM_ID
                ,A.ITEM_ID
                ,ISNULL(NULLIF(A.TO_SITE, ''), '-')                             AS TO_SITE
                ,A.PROJECT_CODE
                ,0                                                              AS TO_BOH_QTY
                ,0                                                              AS FROM_BOH_QTY
                ,A.INCOTERMS
                ,A.FROM_SITE
                ,ISNULL(BT.TRANSPORT_MODE, '-')                                 AS TRANSPORT_MODE
                ,'-'                                                            AS PROD_LINE
                ,CASE WHEN A.MEASURE = 'SHIP_PLAN_AMEND' THEN 'SHIP_PLAN' ELSE A.MEASURE END  AS MEASURE   -- 2026-05-29 김준규: 출력은 SHIP_PLAN 유지
                ,A.YYYYMMDD
                ,ISNULL(A.QTY, 0)                                              AS QTY
                ,M.SORT_ORDER_NO
                --2026-05-04 값을 변경함.
                --,CASE WHEN A.MEASURE = 'SHIP_REQ'
                --      THEN 'SHIP REQ'
                --      ELSE M.COLUMN_LABEL_NAME
                -- END                                                            AS COLUMN_LABEL_NAME
                ,M.COLUMN_LABEL_NAME                                           AS COLUMN_LABEL_NAME
                ,A.BOD_ID
                ,'SCP_ANL_SHIPMENT_PLAN_FG'                                    AS ATTRIBUTE1
                ,A.ATTRIBUTE9
            FROM #STG_SHIP_FG A WITH(NOLOCK)
                -- Loop Join 유도: #MEASURE_FILTERED는 2~3건 소량 → Nested Loop 최적
                INNER JOIN #MEASURE_FILTERED M WITH(NOLOCK)
                    ON A.MEASURE = M.QRY_COLUMN_NAME
            --LEFT JOIN #MEASURE M WITH(NOLOCK)
            --                    ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST', 'SHIP_REQ')
            --                    AND A.MEASURE             = M.COLUMN_NAME
                -- Loop Join 유도: #BOD_TRANSPORT는 사전 집계된 소량 데이터
                LEFT JOIN #BOD_TRANSPORT BT WITH(NOLOCK)
                    ON  BT.DIVISION_ID = A.DIVISION_ID
                    AND BT.BOD_ID      = A.BOD_ID
                    AND BT.FROM_SITE   = A.FROM_SITE
            WHERE 1=1
                -- 2026-05-11 김준규 [옵션 A-2]: AS-IS 호환 위해 비활성화 (skeleton 보존) — AND A.QTY <> 0   -- [요구사항#4] 0 제거 (대량 테이블 감소)
                --AND A.MEASURE             IN ('SHIP_PLAN','MKT_FCST','SHIP_REQ')
                --2026-05-04 김준규 하단의 한번더 추출 WH_IN을 여기에 포함
                AND A.MEASURE             IN ('SHIP_PLAN_AMEND','MKT_FCST','SHIP_REQ','WH_IN')   -- 2026-05-29 김준규: SHIP_PLAN → SHIP_PLAN_AMEND
            OPTION (
                 LOOP JOIN                -- Hash Match 금지 → 메모리 그랜트 제거
                ,MAXDOP 1                 -- 병렬처리 금지 → MEMORY_ALLOCATION_EXT 대기 제거
                ,OPTIMIZE FOR UNKNOWN     -- 파라미터 스니핑 방지 (상수 하드코딩 불필요)
                                          -- 옵티마이저가 통계 기반 평균값으로 실행계획 수립
                                          -- → 특정 파라미터값에 종속된 실행계획 고착 방지
            );

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과


            -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 끝


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE SHIP_PLAN / MKT_FCST / SHIP_REQ ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#00500--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과

--            -------------------------------------------------------------------------------------------------------------------------
--            -- SHIP_PLAN (FG) (팩,셀 공통) - WH_IN
--            -------------------------------------------------------------------------------------------------------------------------
--            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 사용 변수

--            INSERT INTO #PSI_GLOBAL_SMALL
--                SELECT A.DIVISION_ID
--                        , A.BIZ_TYPE
--                        , '' AS CELL_ITEM_ID
--                        , A.ITEM_ID
--                        , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE
--                        , A.PROJECT_CODE
--                        , 0 AS TO_BOH_QTY
--                        , 0 AS FROM_BOH_QTY
--                        , A.INCOTERMS
--                        , A.FROM_SITE
--                        -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
--                        ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE  ),'-') AS TRANSPORT_MODE
--                        , '-'              AS PROD_LINE
--                        , M.COLUMN_NAME AS MEASURE                                              -- SHIP_PLAN FG
--                        , A.YYYYMMDD        AS YYYYMMDD
--                        , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
--                        , M.SORT_ORDER_NO
--                        , M.COLUMN_LABEL_NAME
--                        , A.BOD_ID
--                        , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1
--                        , A.ATTRIBUTE9
--                 FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
--                     INNER JOIN #FILTER_ITEM F WITH(NOLOCK) ON A.ITEM_ID = F.ITEM_ID   -- [요구사항#5] FILTER_ITEM 사전 필터링
--                 INNER JOIN #MEASURE M WITH(NOLOCK)
--                    ON M.COLUMN_NAME          IN ('WHIN')
--                    AND A.MEASURE             = 'WH_IN' --(CASE WHEN M.COLUMN_NAME ='WHIN' THEN 'WH_IN' ELSE M.COLUMN_NAME END )
--                 WHERE A.DIVISION_ID                =  @P_DIVISION_ID
--                        AND A.PLAN_START_YYYYMMDD   =  @p_plan_start_yyyymmdd
--                        AND A.PLAN_TYPE                 =  @P_PLAN_TYPE
--                        AND A.SEQ                           =  @p_seq
--                        AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
--                        AND A.YYYYMMDD            <=   @p_to_yyyymmdd          --말일포함 (KSK, 20240814)
--                        AND A.QTY <> 0   -- [요구사항#4] 0 제거 (대량 테이블 감소)
--                       AND A.MEASURE             IN ('WH_IN')

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과


--        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
--        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL ##########';

--            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과

--        SET @v_description = @v_program_name + ':' + N' WH_IN ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;

---------------------------------------------------------------------------------------------------------------
            -- SCP_ANL_PRODUCTION_PLAN - PACK_PROD, CELL_PROD
            -------------------------------------------------------------------------------------------------------------------------
            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 사용 변수
            --2026-05-04 김준규 재구성
            ---------------------------------------------------------------------------------------------------------------
            -- SCP_ANL_PRODUCTION_PLAN - PACK_PROD, CELL_PROD
            -------------------------------------------------------------------------------------------------------------------------
            --INSERT INTO #PSI_GLOBAL_SMALL
            --   SELECT
            --            A.DIVISION_ID
            --          , A.OPERATION_GROUP
            --          , '' AS CELL_ITEM_ID
            --          , A.ITEM_ID
            --          , '-' AS  TO_SITE
            --          , '-' AS PROJECT_CODE
            --          , 0 AS TO_BOH_QTY
            --          , 0 AS FROM_BOH_QTY
            --          , '-' AS INCOTERMS
            --          , A.SCM_SITE_ID  AS FROM_SITE
            --          , '-'        AS TRANSPORT_MODE
            --          , A.LINE_ID   AS PROD_LINE
            --          , M.COLUMN_NAME AS MEASURE
            --          , A.YYYYMMDD
            --          , SUM(A.QTY) AS QTY
            --          , M.SORT_ORDER_NO
            --                , M.COLUMN_LABEL_NAME
            --                ,  '-' AS BOD_ID
            --          , 'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1
            --                , OPERATION_ID AS ATTRIBUTE9
            --          FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
            --           --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK)
            --           --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD
            --           INNER JOIN #MEASURE M WITH(NOLOCK)
            --              ON M.COLUMN_NAME          IN ('PACK_PROD','CELL_PROD')
            --              AND (CASE  WHEN A.MEASURE ='PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
            --                         WHEN A.MEASURE ='PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
            --                         ELSE '-' END )  = M.COLUMN_NAME
            --          WHERE 1 = 1
            --             AND A.DIVISION_ID           = @p_division_id
            --             AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
            --             AND A.PLAN_TYPE             = @p_plan_type
            --             AND A.SEQ                   = @p_seq
            --             AND A.LINE_ID              <> '-'
            --             AND A.QTY <>0
            --         GROUP BY   A.DIVISION_ID
            --          , A.OPERATION_GROUP
            --          , A.ITEM_ID
            --          , A.SCM_SITE_ID
            --          , A.LINE_ID
            --          , M.COLUMN_NAME
            --          , A.YYYYMMDD
            --          , M.SORT_ORDER_NO
            --          , M.COLUMN_LABEL_NAME
            --          , A.OPERATION_ID

            --2026-05-04 김준규 재구성
                WITH W_PROD_RAW AS (
                  SELECT A.DIVISION_ID
                        , A.OPERATION_GROUP
                        , A.ITEM_ID
                        , A.SCM_SITE_ID
                        , A.LINE_ID
                        , A.YYYYMMDD
                        , A.OPERATION_ID
                        , A.QTY
                  FROM #STG_PROD_PLAN A WITH(NOLOCK)
                  WHERE 1 = 1
                     -- 2026-05-11 김준규 [옵션 A-2]: AS-IS 호환 위해 비활성화 (skeleton 보존) — AND A.QTY <> 0   -- [요구사항#4] 0 제거 (대량 테이블 감소)
                     AND A.LINE_ID              <> '-'
                     AND A.MEASURE              = 'PROD_PLAN_AMEND'
                     AND A.OPERATION_GROUP       = 'P'
                  UNION ALL
                  SELECT A.DIVISION_ID
                        , A.OPERATION_GROUP
                        , A.ITEM_ID
                        , A.SCM_SITE_ID
                        , A.LINE_ID
                        , A.YYYYMMDD
                        , A.OPERATION_ID
                        , A.QTY
                  FROM #STG_PROD_PLAN A WITH(NOLOCK)
                  WHERE 1 = 1
                     -- 2026-05-11 김준규 [옵션 A-2]: AS-IS 호환 위해 비활성화 (skeleton 보존) — AND A.QTY <> 0   -- [요구사항#4] 0 제거 (대량 테이블 감소)
                     AND A.LINE_ID              <> '-'
                     AND A.MEASURE              = 'PROD_PLAN_AMEND'
                     AND A.OPERATION_GROUP      = 'A'
                )
                INSERT INTO #PSI_GLOBAL_SMALL
                SELECT
                         WPR.DIVISION_ID
                       , WPR.OPERATION_GROUP
                       , '' AS CELL_ITEM_ID
                       , WPR.ITEM_ID
                       , '-' AS  TO_SITE
                       , '-' AS PROJECT_CODE
                       , 0 AS TO_BOH_QTY
                       , 0 AS FROM_BOH_QTY
                       , '-' AS INCOTERMS
                       , WPR.SCM_SITE_ID  AS FROM_SITE
                       , '-'        AS TRANSPORT_MODE
                       , WPR.LINE_ID   AS PROD_LINE
                       , M.COLUMN_NAME AS MEASURE
                       , WPR.YYYYMMDD
                       , SUM(WPR.QTY) AS QTY
                       , M.SORT_ORDER_NO
                             , M.COLUMN_LABEL_NAME
                             ,  '-' AS BOD_ID
                       , 'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1
                             , OPERATION_ID AS ATTRIBUTE9
                  FROM W_PROD_RAW WPR WITH (NOLOCK)
                       INNER JOIN #MEASURE M WITH(NOLOCK)
                          ON M.COLUMN_NAME          IN ('PACK_PROD','CELL_PROD')
                          --AND (CASE  WHEN WPR.MEASURE ='PROD_PLAN_AMEND' AND WPR.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                          --           WHEN WPR.MEASURE ='PROD_PLAN_AMEND' AND WPR.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                          --           ELSE '-' END )  = M.COLUMN_NAME
                          AND (CASE  WHEN WPR.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                                     WHEN WPR.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                                     ELSE '-' END )  = M.COLUMN_NAME
                  WHERE 1 = 1
                 GROUP BY   WPR.DIVISION_ID
                        , WPR.OPERATION_GROUP
                        , WPR.ITEM_ID
                        , WPR.SCM_SITE_ID
                        , WPR.LINE_ID
                        , M.COLUMN_NAME
                        , WPR.YYYYMMDD
                        , M.SORT_ORDER_NO
                        , M.COLUMN_LABEL_NAME
                        , WPR.OPERATION_ID

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL ##########';

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과

        SET @v_description = @v_program_name + ':' + N' PACK_PROD /  CELL_PROD ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -------------------------------------------------------------------------------------------------------------------------
            -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
            -- PACK_PROD, CELL_PROD - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가
            -------------------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#LINE_ASSIGN') IS NOT NULL
                DROP TABLE #LINE_ASSIGN
            IF OBJECT_ID('tempdb..#LINE_ASSIGN_ORG') IS NOT NULL
                DROP TABLE #LINE_ASSIGN_ORG

            -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 기존 로직 주석처리.
            /*
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
                    ON  TM.DIVISION_ID      = AN.DIVISION_ID
                    AND TM.COMPANY_ID       = AN.COMPANY_ID
                    AND TM.SITE_ID          = AN.SITE_ID
                    AND TM.PLANT_ID         = AN.PLANT_ID
                    AND TM.FACTORY_ID       = AN.FACTORY_ID
                    AND TM.OPERATION_ID     = AN.OPERATION_ID
                    AND TM.LINE_ID          = AN.LINE_ID
                    AND TM.ELECTRODE_TYPE   = AN.ELECTRODE_TYPE
                    AND TM.ITEM_ID          = AN.ITEM_ID
              INNER JOIN SCM_LINE_M_SN LM WITH (NOLOCK)
                    ON  LM.DIVISION_ID      = AN.DIVISION_ID
                    AND LM.COMPANY_ID       = AN.COMPANY_ID
                    AND LM.SITE_ID          = AN.SITE_ID
                    AND LM.PLANT_ID         = AN.PLANT_ID
                    AND LM.FACTORY_ID       = AN.FACTORY_ID
                    AND LM.OPERATION_ID     = AN.OPERATION_ID
                    AND LM.LINE_ID          = AN.LINE_ID
                    AND LM.ELECTRODE_TYPE   = AN.ELECTRODE_TYPE
                WHERE 1 = 1
                --AND AN.UPDATE_TIME >= convert(char(8), dateadd(D, -2, getdate()), 112)    -- 2022.11.03 주석해제 :: 불필요 생산계획 생성방지에 따른 최신 PRIORITY 값이 반영되지 않는 현상 개선
                AND AN.DIVISION_ID       = @P_DIVISION_ID
                AND TM.DAILY_CAPA       > 0.0
                AND AN.MONTH            >= LEFT(convert(char(8), getdate(), 112), 6)        -- 2021.08.10 capa. 적용기준 변경
                AND NOT AN.PRIORITY     IN (9, 8)   -- 2022.10.25 미적용기준을 변경
                AND LM.ACTIVE_FLAG = 'Y'  --'2024.07.04 활성화 상태 체크 (KSK)
                ;
                */


                -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 시작
                ;WITH
                /*
                 CTE_AN: AN 테이블을 조인 전에 미리 필터링
                 - DIVISION_ID, MONTH, PRIORITY 조건을 선행 적용하여 304K → 대폭 감소 기대
                 - PRIORITY 암묵적 형변환(CONVERT_IMPLICIT) 제거:
                     원본: NOT AN.PRIORITY IN (9, 8)
                     → PRIORITY 컬럼 타입이 nvarchar/varchar인 경우: NOT IN ('9', '8')
                     → PRIORITY 컬럼 타입이 int/numeric인 경우: NOT IN (9, 8) 그대로 사용
                   ※ 실행계획 경고 "CONVERT_IMPLICIT(int, [PRIORITY], 0)" 확인됨
                     → PRIORITY는 문자형으로 저장되어 int 비교 시 형변환 발생
                     → 아래 CTE에서 문자형 리터럴로 통일 (실제 타입 확인 후 조정 필요)
                */
                CTE_AN AS (
                    SELECT
                          AN.DIVISION_ID
                        , AN.COMPANY_ID
                        , AN.SITE_ID
                        , AN.PLANT_ID
                        , AN.FACTORY_ID
                        , AN.OPERATION_ID
                        , AN.LINE_ID
                        , AN.ELECTRODE_TYPE
                        , AN.ITEM_ID
                    FROM SCM_MST_ITEM_LINE_ASSIGN_SN AN WITH (NOLOCK)
                    -- 2026-05-07 김준규: ITEM 이 존재하지 않는 라인 매핑은 SP 처리 대상 아님 → 사전 필터로 row 대폭 감소
                    -- 2026-05-08 오류로 아래 막음
                    --INNER JOIN #FILTER_ITEM_BOTH FI ON AN.ITEM_ID = FI.ITEM_ID
                    WHERE AN.DIVISION_ID = @P_DIVISION_ID
                      AND AN.MONTH       >= LEFT(CONVERT(CHAR(8), GETDATE(), 112), 6)
                      /*
                        PRIORITY 형변환 제거 방법 선택:
                        [방법A] PRIORITY가 문자형(nvarchar/varchar) 컬럼인 경우 (권장)
                                → 리터럴을 문자로 지정하여 형변환 자체를 원천 제거
                      */
                      AND AN.PRIORITY NOT IN ('9', '8')
                      /*
                        [방법B] PRIORITY가 숫자형(int/numeric) 컬럼인 경우
                                → CAST 없이 숫자 리터럴 그대로 사용 (원본과 동일, 단 CTE 분리 효과는 유지)
                      */
                      -- AND AN.PRIORITY NOT IN (9, 8)
                )
                SELECT
                      TM.DIVISION_ID
                    , TM.PLANT_ID       AS FROM_SITE_ID
                    , TM.LINE_ID
                    , TRIM(TM.ITEM_ID)  AS ITEM_ID
                    , TM.OPERATION_ID
                    , TM.COMPANY_ID
                    , TM.SITE_ID
                    , TM.FACTORY_ID
                    , TM.ELECTRODE_TYPE
                INTO #LINE_ASSIGN_ORG
                FROM SCM_LINE_M_SN LM WITH (NOLOCK)    -- 드라이빙: division 3,031건 (가장 소규모)
                INNER HASH JOIN CTE_AN AN               -- HASH JOIN: NL 218K회 반복 → 단1회 Hash 처리
                    ON  AN.DIVISION_ID   = LM.DIVISION_ID
                    AND AN.COMPANY_ID    = LM.COMPANY_ID
                    AND AN.SITE_ID       = LM.SITE_ID
                    AND AN.PLANT_ID      = LM.PLANT_ID
                    AND AN.FACTORY_ID    = LM.FACTORY_ID
                    AND AN.OPERATION_ID  = LM.OPERATION_ID
                    AND AN.LINE_ID       = LM.LINE_ID
                    AND AN.ELECTRODE_TYPE= LM.ELECTRODE_TYPE
                INNER HASH JOIN SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)  -- HASH JOIN: division 221K건
                    ON  TM.DIVISION_ID   = AN.DIVISION_ID
                    AND TM.COMPANY_ID    = AN.COMPANY_ID
                    AND TM.SITE_ID       = AN.SITE_ID
                    AND TM.PLANT_ID      = AN.PLANT_ID
                    AND TM.FACTORY_ID    = AN.FACTORY_ID
                    AND TM.OPERATION_ID  = AN.OPERATION_ID
                    AND TM.LINE_ID       = AN.LINE_ID
                    AND TM.ELECTRODE_TYPE= AN.ELECTRODE_TYPE
                    AND TM.ITEM_ID       = AN.ITEM_ID
                WHERE LM.DIVISION_ID = @P_DIVISION_ID  -- LM 드라이빙 필터 (Index Seek 활용)
                  AND LM.ACTIVE_FLAG = 'Y'             -- LM의 CDX01 인덱스(ACTIVE_FLAG) Seek 활용
                  AND TM.DAILY_CAPA  > 0.0
                GROUP BY TM.DIVISION_ID
                    , TM.PLANT_ID
                    , TM.LINE_ID
                    , TM.ITEM_ID
                    , TM.OPERATION_ID
                    , TM.COMPANY_ID
                    , TM.SITE_ID
                    , TM.FACTORY_ID
                    , TM.ELECTRODE_TYPE
                OPTION (
                    FORCE ORDER             -- LM → AN → TM 조인 순서 강제 유지
                  , MAXDOP 1               -- 병렬처리 허용 (현재 DOP=1 강제, 4코어 서버 환경)
                    /*
                      MAXDOP 주석:
                      - 현재 실행계획은 DegreeOfParallelism="1" (직렬 처리)
                      - OptimizerHardwareDependentProperties: EstimatedAvailableDOP=4 확인됨
                      - HASH JOIN으로 변경 시 옵티마이저가 병렬 플랜을 선택할 수 있어 추가 성능 향상 기대
                      - 서버 부하 상황에 따라 MAXDOP 1로 제한하는 것이 나을 수 있으므로 테스트 후 결정
                      - 부하 우려 시 MAXDOP 1 사용
                    */
                )
                ;
                -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 끝


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INTO #LINE_ASSIGN_ORG ##########';
        SET @v_description = @v_program_name + ':' + N' #LINE_ASSIGN_ORG ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            PRINT '--A@X#00600--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            -------------------------
            -- 출하/생산계획 추가대상 건 확인
            -------------------------
-->> 콤마조인을 ANSI JOIN 변경 시작
--과거 쿼리 막아야 함.

            --SELECT DISTINCT
            --       X.DIVISION_ID, X.PLANT_ID, X.ITEM_ID, X.LINE_ID, X.MODEL_ID, X.CHILD_ITEM_ID, X.OPERATION_ID, X.OPERATION_GROUP_ID,
            --       X.COMPANY_ID, X.SITE_ID, X.FACTORY_ID, X.ELECTRODE_TYPE,
            --       (CASE WHEN X.ITEM_ID = X.CHILD_ITEM_ID THEN 'R' ELSE 'S' END) AS ITEM_TYPE
            --  INTO #LINE_ASSIGN
            --  FROM (
            --        SELECT  V1.DIVISION_ID, V1.PLANT_ID, A.ITEM_ID, A.LINE_ID, V1.MODEL_ID, V1.CHILD_ITEM_ID, A.OPERATION_ID, V1.OPERATION_GROUP_ID,
            --                A.COMPANY_ID, A.SITE_ID, A.FACTORY_ID, A.ELECTRODE_TYPE
            --          FROM #LINE_ASSIGN_ORG A WITH (NOLOCK),
            --               SCM_MST_MODEL_FINAL_ITEM_BOM_V V1 WITH (NOLOCK)  -- PACK 기준으로 종속된 CELL 까지
            --         WHERE V1.DIVISION_ID         =  A.DIVISION_ID
            --           AND V1.PLANT_ID            =  A.FROM_SITE_ID
            --           AND V1.MODEL_ID            =  A.ITEM_ID
            --           AND V1.OPERATION_GROUP_ID  <> 'E'
            --         UNION ALL
            --        SELECT  V2.DIVISION_ID, V2.PLANT_ID, A.ITEM_ID, A.LINE_ID, V2.MODEL_ID, V2.CHILD_ITEM_ID, A.OPERATION_ID, V2.OPERATION_GROUP_ID,
            --                A.COMPANY_ID, A.SITE_ID, A.FACTORY_ID, A.ELECTRODE_TYPE
            --          FROM #LINE_ASSIGN_ORG A WITH (NOLOCK),
            --               SCM_MST_MODEL_FINAL_ITEM_BOM_V V2 WITH (NOLOCK)  -- CELL 단독
            --         WHERE V2.DIVISION_ID         =  A.DIVISION_ID
            --           AND V2.PLANT_ID            =  A.FROM_SITE_ID
            --           AND V2.MODEL_ID            =  A.ITEM_ID
            --           AND V2.CHILD_ITEM_ID       =  A.ITEM_ID
            --           AND V2.OPERATION_GROUP_ID  = 'A'
            --       ) X
            --       , SCP_MST_FINAL_ITEM Z WITH (NOLOCK)
            --where  1 = 1
            --   AND Z.DIVISION_ID        = @P_DIVISION_ID
            --   AND Z.FCST_YN            = 'Y'
            --   AND X.DIVISION_ID        = Z.DIVISION_ID
            --   AND X.ITEM_ID            = Z.ITEM_ID
            --   AND X.OPERATION_GROUP_ID = Z.OPERATION_GROUP
            --   and x.OPERATION_ID       = Z.FLOW_ID
            --   ;


-->> 콤마조인을 ANSI JOIN 변경 종료

-->> 아래 변경 시작
            -- 2026-05-06 김준규 변경: 옛 콤마조인을 ANSI JOIN으로, 외부 SELECT DISTINCT는 GROUP BY로 대체
            -- 2026-05-19 김준규 변경: SCM_MST_MODEL_FINAL_ITEM_BOM_V 두 번 호출 → #BOM_LINE_ASSIGN_CACHE 한 번 호출
            --   예상 효과: 9.3초 → 3~5초 (▼4~6초)
            SELECT
                   X.DIVISION_ID, X.PLANT_ID, X.ITEM_ID, X.LINE_ID, X.MODEL_ID, X.CHILD_ITEM_ID, X.OPERATION_ID, X.OPERATION_GROUP_ID,
                   X.COMPANY_ID, X.SITE_ID, X.FACTORY_ID, X.ELECTRODE_TYPE,
                   (CASE WHEN X.ITEM_ID = X.CHILD_ITEM_ID THEN 'R' ELSE 'S' END) AS ITEM_TYPE
              INTO #LINE_ASSIGN
              FROM (
                    SELECT  V1.DIVISION_ID, V1.PLANT_ID, A.ITEM_ID, A.LINE_ID, V1.MODEL_ID, V1.CHILD_ITEM_ID, A.OPERATION_ID, V1.OPERATION_GROUP_ID,
                            A.COMPANY_ID, A.SITE_ID, A.FACTORY_ID, A.ELECTRODE_TYPE
                      FROM  #LINE_ASSIGN_ORG A WITH (NOLOCK)
                      INNER JOIN #BOM_LINE_ASSIGN_CACHE V1 WITH (NOLOCK)    -- 2026-05-19 김준규: BOM_V → 캐시
                         ON V1.DIVISION_ID         =  A.DIVISION_ID
                        AND V1.PLANT_ID            =  A.FROM_SITE_ID
                        AND V1.MODEL_ID            =  A.ITEM_ID
                       -- AND V1.OPERATION_GROUP_ID <> 'E' (캐시에서 이미 필터)
                     UNION ALL
                    SELECT  V2.DIVISION_ID, V2.PLANT_ID, A.ITEM_ID, A.LINE_ID, V2.MODEL_ID, V2.CHILD_ITEM_ID, A.OPERATION_ID, V2.OPERATION_GROUP_ID,
                            A.COMPANY_ID, A.SITE_ID, A.FACTORY_ID, A.ELECTRODE_TYPE
                      FROM  #LINE_ASSIGN_ORG A WITH (NOLOCK)
                      INNER JOIN #BOM_LINE_ASSIGN_CACHE V2 WITH (NOLOCK)    -- 2026-05-19 김준규: BOM_V → 캐시
                         ON V2.DIVISION_ID         =  A.DIVISION_ID
                        AND V2.PLANT_ID            =  A.FROM_SITE_ID
                        AND V2.MODEL_ID            =  A.ITEM_ID
                        AND V2.CHILD_ITEM_ID       =  A.ITEM_ID
                        AND V2.OPERATION_GROUP_ID  = 'A'
                   ) X
                   INNER JOIN SCP_MST_FINAL_ITEM Z WITH (NOLOCK)
                      ON Z.DIVISION_ID        = X.DIVISION_ID
                     AND Z.ITEM_ID            = X.ITEM_ID
                     AND Z.OPERATION_GROUP    = X.OPERATION_GROUP_ID
                     AND Z.FLOW_ID            = X.OPERATION_ID
            WHERE  Z.DIVISION_ID        = @P_DIVISION_ID
               AND Z.FCST_YN            = 'Y'
            GROUP BY  -- 외부 SELECT DISTINCT 대체
                   X.DIVISION_ID, X.PLANT_ID, X.ITEM_ID, X.LINE_ID, X.MODEL_ID, X.CHILD_ITEM_ID, X.OPERATION_ID, X.OPERATION_GROUP_ID,
                   X.COMPANY_ID, X.SITE_ID, X.FACTORY_ID, X.ELECTRODE_TYPE
               ;

            CREATE CLUSTERED INDEX CX_LINE_ASSIGN
            ON #LINE_ASSIGN (PLANT_ID,CHILD_ITEM_ID);

-->> 아래 변경 종료

            PRINT '--A@X#00610--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INTO #LINE_ASSIGN ##########';
        SET @v_description = @v_program_name + ':' + N' #LINE_ASSIGN ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -----------
            -- 출하계획
            -----------
            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 사용 변수
/*
            --INSERT INTO #PSI_GLOBAL_SMALL
            --    SELECT A.DIVISION_ID
            --            , A.BIZ_TYPE
            --            , '' AS CELL_ITEM_ID
            --            , A.ITEM_ID
            --            , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE
            --            , A.PROJECT_CODE
            --            , 0 AS TO_BOH_QTY
            --            , 0 AS FROM_BOH_QTY
            --            , A.INCOTERMS
            --            , A.FROM_SITE
            --      -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
            --      ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE    ),'-') AS TRANSPORT_MODE
            --      , '-'              AS PROD_LINE
            --            , A.MEASURE                                             -- SHIP_PLAN FG
            --            , A.YYYYMMDD        AS YYYYMMDD
            --      , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
            --            , M.SORT_ORDER_NO
            --            , M.COLUMN_LABEL_NAME
            --            , A.BOD_ID
            --      , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1
            --            , A.ATTRIBUTE9
            --       FROM (SELECT  DISTINCT
            --                     P.DIVISION_ID
            --                    ,LN.CHILD_ITEM_ID AS ITEM_ID
            --                    ,Y.SH_FG          AS BIZ_TYPE
            --                    ,P.PROJECT_CODE
            --                    ,P.SALES_SITE_ID  AS TO_SITE
            --                    ,P.PLANT_SITE_ID  AS FROM_SITE
            --                    ,@p_plan_start_yyyymmdd AS YYYYMMDD
            --                    ,B.INCOTERMS
            --                    ,B.BOD_ID
            --                    ,'SHIP_PLAN' AS MEASURE
            --                    ,0           AS QTY
            --                    ,NULL        AS ATTRIBUTE9
            --                FROM SCM_MST_SITE_ITEM_PRIORITY P WITH (NOLOCK),
            --                    #LINE_ASSIGN LN WITH (NOLOCK),
            --                    (SELECT DISTINCT
            --                            ITEM_ID, MEASURE, BIZ_TYPE AS SH_FG, INCOTERMS, TO_SITE
            --                        FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)  -- MKT_FCST 존재할 경우만
            --                        WHERE DIVISION_ID         = @P_DIVISION_ID
            --                        AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
            --                        AND PLAN_TYPE             = @P_PLAN_TYPE
            --                        AND SEQ                   = @p_seq
            --                        AND MEASURE               = 'MKT_FCST'
            --                    ) Y,
            --                    SCP_MST_BOD_N_V B WITH (NOLOCK)     -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
            --                WHERE P.DIVISION_ID  = LN.DIVISION_ID
            --                AND P.ITEM_ID      = LN.CHILD_ITEM_ID
            --                AND LEFT(P.PLANT_SITE_ID, 4) = LN.PLANT_ID
            --                -- 변경후
            --                AND P.FROM_YYYYMMDD <= @p_to_yyyymmdd
            --                AND P.VALID_YN     = 'Y'
            --                AND Y.ITEM_ID      = P.ITEM_ID
            --                AND Y.SH_FG        = LN.operation_group_id      --
            --                AND B.DIVISION_ID  = LN.DIVISION_ID
            --                AND B.FROM_SITE    = P.PLANT_SITE_ID
            --                AND B.TO_SITE      = P.SALES_SITE_ID
            --                AND  B.BOD_TYPE     = 'SALES'
            --                AND B.BOD_VALID_YN = 'Y'
            --                AND B.INCOTERMS    = Y.INCOTERMS
            --                AND B.TO_SITE      = Y.TO_SITE
            --                AND NOT EXISTS (SELECT 1
            --                                  FROM SCP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)   -- 출하계획 존재시 제외
            --                                 WHERE DIVISION_ID = @P_DIVISION_ID
            --                                   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
            --                                   AND PLAN_TYPE   = @P_PLAN_TYPE
            --                                   AND SEQ         = @p_seq
            --                                   AND FROM_SITE   = P.PLANT_SITE_ID
            --                                   AND ITEM_ID     = LN.CHILD_ITEM_ID
            --                                   AND BOD_ID      = B.BOD_ID
            --                                   AND MEASURE     = 'SHIP_PLAN'
            --                                   -- 중복값 수정이 안되는 현상 발생하여 제거함 : KSK, 2023-07-10
            --                                   -- AND PROJECT_CODE != '-'
            --                                   )
            --                ) A
            --     INNER JOIN #MEASURE M WITH(NOLOCK)   -- [Method B] inline subquery -> #MEASURE 캐시 재사용
            --        ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST')
            --        AND A.MEASURE             = M.COLUMN_NAME

*/
--추가 시작--
            -----------
            -- 출하계획
            -----------
            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 사용 변수
            IF @v_is_debug = 1 SELECT CONCAT(N'출하계획 @P_DIVISION_ID:', @P_DIVISION_ID, '|', '@p_plan_start_yyyymmdd:', @p_plan_start_yyyymmdd, '|', '@P_PLAN_TYPE:', @P_PLAN_TYPE, '|', '@p_seq:', @p_seq, '|', '@p_to_yyyymmdd:', @p_to_yyyymmdd) AS "#PSI_GLOBAL_SMALL 사용변수";

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
                  -- 2026-05-15 김준규: scalar subquery → #BOD_TRANSPORT LEFT JOIN (row 마다 SCP_MST_BOD_N_V scan 회피)
                  -- 기존: ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C WHERE ...),'-')
                  , ISNULL(BT.TRANSPORT_MODE, '-') AS TRANSPORT_MODE
                  , '-'              AS PROD_LINE
                        , A.MEASURE                                             -- SHIP_PLAN FG
                        , A.YYYYMMDD        AS YYYYMMDD
                  , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
                        , M.SORT_ORDER_NO
                        , M.COLUMN_LABEL_NAME
                        , A.BOD_ID
                  , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1
                        , A.ATTRIBUTE9
                   FROM (SELECT  DISTINCT
                                 P.DIVISION_ID
                                ,LN.CHILD_ITEM_ID AS ITEM_ID
                                ,Y.SH_FG          AS BIZ_TYPE
                                ,P.PROJECT_CODE
                                ,P.SALES_SITE_ID  AS TO_SITE
                                ,P.PLANT_SITE_ID  AS FROM_SITE
                                ,@p_plan_start_yyyymmdd AS YYYYMMDD
                                ,B.INCOTERMS
                                ,B.BOD_ID
                                ,'SHIP_PLAN' AS MEASURE
                                ,0           AS QTY
                                ,NULL        AS ATTRIBUTE9
                            FROM SCM_MST_SITE_ITEM_PRIORITY P WITH (NOLOCK)
                                --2026-05-20 김준규 FILTER_PLANT 추가
                                INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = P.PLANT_SITE_ID
                                INNER JOIN #FILTER_ITEM_BOTH FI_P  WITH (NOLOCK) ON FI_P.ITEM_ID  = P.ITEM_ID            -- 2026-05-06 김준규: P.ITEM_ID 는 PACK 단위 → BOTH
                                INNER JOIN #LINE_ASSIGN LN     WITH (NOLOCK) ON 1=1                                  -- (기존 cross 조인을 ANSI 로 변경)
                                INNER JOIN #FILTER_ITEM FI_LN WITH (NOLOCK) ON FI_LN.ITEM_ID = LN.CHILD_ITEM_ID     -- 2026-05-06 김준규: CHILD_ITEM_ID 는 CELL 단위 → 그대로 #FILTER_ITEM
                                INNER JOIN (SELECT DISTINCT
                                                   SP.ITEM_ID, SP.MEASURE, SP.BIZ_TYPE AS SH_FG, SP.INCOTERMS, SP.TO_SITE
                                              FROM #STG_SHIP_FG SP WITH(NOLOCK)
                                             WHERE 1=1
                                               AND SP.MEASURE             = 'MKT_FCST'
                                               -- 2026-05-11 김준규 [옵션 A-2]: AS-IS 호환 위해 비활성화 (skeleton 보존) — AND SP.QTY                <> 0
                                ) Y ON 1=1
                                INNER JOIN SCP_MST_BOD_N_V B WITH (NOLOCK) ON 1=1
                            WHERE P.DIVISION_ID  = LN.DIVISION_ID
                            AND P.ITEM_ID      = LN.CHILD_ITEM_ID
                            AND LEFT(P.PLANT_SITE_ID, 4) = LN.PLANT_ID
                            AND P.FROM_YYYYMMDD <= @p_to_yyyymmdd
                            AND P.VALID_YN     = 'Y'
                            AND Y.ITEM_ID      = P.ITEM_ID
                            AND Y.SH_FG        = LN.operation_group_id
                            AND B.DIVISION_ID  = LN.DIVISION_ID
                            AND B.FROM_SITE    = P.PLANT_SITE_ID
                            AND B.TO_SITE      = P.SALES_SITE_ID
                            AND B.BOD_TYPE     = 'SALES'
                            AND B.BOD_VALID_YN = 'Y'
                            AND B.INCOTERMS    = Y.INCOTERMS
                            AND B.TO_SITE      = Y.TO_SITE
                            AND NOT EXISTS (SELECT 1
                                              FROM #STG_SHIP_FG SP2 WITH(NOLOCK)
                                             WHERE 1=1
                                               AND SP2.FROM_SITE           = P.PLANT_SITE_ID
                                               AND SP2.ITEM_ID             = LN.CHILD_ITEM_ID
                                               AND SP2.BOD_ID              = B.BOD_ID
                                               AND SP2.MEASURE             = 'SHIP_PLAN'
                                               )
                            ) A
                 INNER JOIN #MEASURE M WITH(NOLOCK)   -- [Method B] inline subquery -> #MEASURE 캐시 재사용
                    ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST')
                    AND A.MEASURE             = M.COLUMN_NAME
                 -- 2026-05-15 김준규: scalar subquery 제거 → JOIN
                 LEFT JOIN #BOD_TRANSPORT BT WITH(NOLOCK)
                    ON  BT.DIVISION_ID = A.DIVISION_ID
                    AND BT.BOD_ID      = A.BOD_ID
                    AND BT.FROM_SITE   = A.FROM_SITE

--추가 종료--


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL ##########';

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과

        SET @v_description = @v_program_name + ':' + N' SHIP_PLAN / MKT_FCST ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            PRINT '--A@X#00700--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
-----------
            -- 생산계획
            -----------
            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 사용 변수
            IF @v_is_debug = 1 SELECT CONCAT(N'생산계획 @P_DIVISION_ID:', @P_DIVISION_ID, '|', '@p_plan_start_yyyymmdd:', @p_plan_start_yyyymmdd, '|', '@P_PLAN_TYPE:', @P_PLAN_TYPE, '|', '@p_seq:', @p_seq) AS "#PSI_GLOBAL_SMALL 사용변수";

            INSERT INTO #PSI_GLOBAL_SMALL
               SELECT
                        X.DIVISION_ID
                      , LEFT(X.OPERATION_ID, 1) AS OPERATION_GROUP_ID
                      , '' AS CELL_ITEM_ID
                      , X.ITEM_ID
                      , '-' AS  TO_SITE
                      , '-' AS PROJECT_CODE
                      , 0 AS TO_BOH_QTY
                      , 0 AS FROM_BOH_QTY
                      , '-' AS INCOTERMS
                      , X.SCM_SITE_ID  AS FROM_SITE
                      , '-'        AS TRANSPORT_MODE
                      , X.LINE_ID   AS PROD_LINE
                      , M.COLUMN_NAME AS MEASURE
                      , X.YYYYMMDD
                      , 0 AS QTY
                      , M.SORT_ORDER_NO
                      , M.COLUMN_LABEL_NAME
                      ,  '-' AS BOD_ID
                      , 'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1
                      , X.OPERATION_ID AS ATTRIBUTE9
                  FROM (SELECT  DISTINCT            -- LINE ASSIGN + DAILY CAPA + PACK 에 대한 CELL ITEM
                                X.DIVISION_ID
                              , S.SCM_SITE_ID
                              , X.ITEM_ID
                              , X.LINE_ID
                              --, X.MODEL_ID
                              --, X.CHILD_ITEM_ID
                              , X.OPERATION_ID
                              , @p_plan_start_yyyymmdd AS YYYYMMDD
                          FROM (
                                SELECT DISTINCT
                                        TM.DIVISION_ID
                                      , TM.PLANT_ID
                                      , TM.LINE_ID
                                      , TM.ITEM_ID
                                      , TM.OPERATION_ID
                                      , AN.OPERATION_GROUP_ID
                                  FROM #LINE_ASSIGN AN WITH (NOLOCK),
                                       SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)
                                 WHERE AN.ITEM_TYPE         = 'R'
                                   AND TM.DIVISION_ID       = AN.DIVISION_ID
                                   AND TM.COMPANY_ID        = AN.COMPANY_ID
                                   AND TM.SITE_ID           = AN.SITE_ID
                                   AND TM.PLANT_ID          = AN.PLANT_ID
                                   AND TM.FACTORY_ID        = AN.FACTORY_ID
                                   AND TM.OPERATION_ID      = AN.OPERATION_ID
                                   AND TM.LINE_ID           = AN.LINE_ID
                                   AND TM.ELECTRODE_TYPE    = AN.ELECTRODE_TYPE
                                   AND TM.ITEM_ID           = AN.ITEM_ID
                                 UNION ALL
                                SELECT DISTINCT
                                        TM.DIVISION_ID
                                      , TM.PLANT_ID
                                      , TM.LINE_ID
                                      , TM.ITEM_ID
                                      , TM.OPERATION_ID
                                      , AN.OPERATION_GROUP_ID
                                  FROM #LINE_ASSIGN AN WITH (NOLOCK),
                                       SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)
                                 WHERE AN.ITEM_TYPE         = 'S'
                                   AND TM.DIVISION_ID       = AN.DIVISION_ID
                                   AND TM.COMPANY_ID        = AN.COMPANY_ID
                                   AND TM.SITE_ID           = AN.SITE_ID
                                   AND TM.PLANT_ID          = AN.PLANT_ID
                                   AND TM.FACTORY_ID        = AN.FACTORY_ID
                                   AND TM.OPERATION_ID  = AN.OPERATION_ID
                                   AND TM.LINE_ID           = AN.LINE_ID
                                   AND TM.ELECTRODE_TYPE    = AN.ELECTRODE_TYPE
                                   AND TM.ITEM_ID           = AN.CHILD_ITEM_ID
                                   AND LEFT(TM.OPERATION_ID, 1) = 'A'
                               ) X,
                               (SELECT DIVISION_ID, SCM_SITE_ID, SITE_DESCRIPTION, OPERATION_GROUP
                                  FROM SCM_MST_SITE WITH (NOLOCK)
                                  WHERE DIVISION_ID = @P_DIVISION_ID
                               ) S
                        --2026-05-20 김준규 FILTER_PLANT 추가
                        INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = S.SCM_SITE_ID
                         WHERE 1 = 1
                           AND S.OPERATION_GROUP = X.OPERATION_GROUP_ID
                           AND LEFT(S.SCM_SITE_ID, 4) = X.PLANT_ID
                           AND NOT EXISTS (SELECT 1
                                          FROM #STG_PROD_PLAN WITH(NOLOCK)    -- 생산계획 존재시 제외
                                         WHERE 1=1
                                           AND SCM_SITE_ID = S.SCM_SITE_ID
                                           AND ITEM_ID     = X.ITEM_ID
                                           AND LINE_ID     = X.LINE_ID
                                           AND MEASURE     = 'PROD_PLAN_AMEND')) X
                       --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK)
                       --   ON X.YYYYMMDD           = C.BASIS_YYYYMMDD
                       INNER JOIN #MEASURE M WITH(NOLOCK)   -- [Method B] inline subquery -> #MEASURE 캐시 재사용
                          ON M.COLUMN_NAME          IN ('PACK_PROD','CELL_PROD')
                          AND (CASE  WHEN LEFT(X.OPERATION_ID, 1) = 'P' THEN 'PACK_PROD'
                                     WHEN LEFT(X.OPERATION_ID, 1) = 'A' THEN 'CELL_PROD'
                                     ELSE '-' END )  = M.COLUMN_NAME
                      WHERE 1 = 1


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL ##########';

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과

        SET @v_description = @v_program_name + ':' + N' SCP_ANL_PRODUCTION_PLAN  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            PRINT '--A@X#00800--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
--------------------------------------------
            -- SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN
            --------------------------------------------
            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 사용 변수
            IF @v_is_debug = 1 SELECT CONCAT(N'SHIP PLAN @P_DIVISION_ID:', @P_DIVISION_ID, '|', '@p_plan_start_yyyymmdd:', @p_plan_start_yyyymmdd, '|', '@P_PLAN_TYPE:', @P_PLAN_TYPE, '|', '@p_seq:', @p_seq) AS "#PSI_GLOBAL_SMALL 사용변수";

            INSERT INTO #PSI_GLOBAL_SMALL
                     SELECT   A.DIVISION_ID
                                  , A.OPERATION_GROUP
                                  , '' AS CELL_ITEM_ID
                                  , A.ITEM_ID
                                  , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE
                            , '-' AS PROJECT_CODE
                                  , 0 AS TO_BOH_QTY
                                  , 0 AS FROM_BOH_QTY
                                  , '-' AS INCOTERMS
                                  , A.FROM_SITE
                            -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                            ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE  ),'-') AS TRANSPORT_MODE
                            , '-'              AS PROD_LINE
                                  , M.COLUMN_NAME  AS MEASURE
                                  , A.YYYYMMDD        AS YYYYMMDD
                            , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
                                  , M.SORT_ORDER_NO
                                  , M.COLUMN_LABEL_NAME
                                  , A.BOD_ID
                            , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
                                  , A.ATTRIBUTE9
                             FROM (SELECT  LN.DIVISION_ID
                                          ,LN.CHILD_ITEM_ID AS ITEM_ID
                                          ,B.FROM_SITE
                                          ,B.TO_SITE
                                          ,B.BOD_ID
                                          ,@p_plan_start_yyyymmdd AS YYYYMMDD
                                          ,'SEMI_SHIP_PLAN' AS MEASURE
                                          ,LN.OPERATION_GROUP_ID AS OPERATION_GROUP
                                          ,0 AS QTY
                                          ,NULL        AS ATTRIBUTE9
                                      FROM #LINE_ASSIGN LN WITH (NOLOCK)            -- LN, B 는 콤마 조인 (연결조건은 아래 WHERE: B.DIVISION_ID=LN.DIVISION_ID, LEFT(B.FROM_SITE,4)=LN.PLANT_ID)
                                           -- 2026-06-02 김준규 수정 [버그픽스: 요청 범위 밖 PLANT 의 SEMI_SHIP_PLAN skeleton 생성 차단]
                                           --   증상: 이전 보존/복원 수정 이후, 요청 안 한 PLANT(site) 의 cell 까지 SEMI_SHIP_PLAN 으로 적재됨(RAW 오출력).
                                           --   조치: 입력(생성) 시점에서 요청 PLANT 로 제한 (Stage1 #STG_SHIP_SEMI L699 와 동일 기준).
                                           --   주의: #FILTER_ITEM_BOTH(ITEM) 조인은 제외함.
                                           --        → 정상 skeleton(예: KR01297200)의 cell(LN.CHILD_ITEM_ID)이 #FILTER_ITEM_BOTH 에 없어
                                           --          item 필터를 걸면 정상 행까지 사라지는 회귀 발생 → PLANT 필터만 적용.
                                           ,SCP_MST_BOD_N_V B WITH (NOLOCK)      -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                                           INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID = B.FROM_SITE
                                     WHERE LN.OPERATION_GROUP_ID = 'A'
                                       AND B.DIVISION_ID  = LN.DIVISION_ID
                                       AND LEFT(B.FROM_SITE, 4) = LN.PLANT_ID
                                       -- 2026-05-07 대체 막음 시작
                                       --AND B.TO_SITE      = (select DISTINCT LN.PLANT_ID + '-P'
                                       --                       from SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
                                       --                      where V.MODEL_ID = LN.CHILD_ITEM_ID
                                       --                        and V.PLANT_ID = LN.PLANT_ID
                                       --                        and V.OPERATION_GROUP_ID  = 'A'
                                       --                        and V.electrode_type = '')
                                       -- 2026-05-07 대체 막음 종료

                                       -- 2026-05-07 시작 김준규: BOM_V → #BOM_FULL_CACHE 로 변경 (서브쿼리 형태는 유지, 옵티마이저 안정)
                                       AND B.TO_SITE      = (SELECT DISTINCT LN.PLANT_ID + '-P'
                                                              FROM #BOM_FULL_CACHE V
                                                             WHERE V.MODEL_ID           = LN.CHILD_ITEM_ID
                                                               AND V.PLANT_ID           = LN.PLANT_ID
                                                               AND V.OPERATION_GROUP_ID = 'A'
                                                               AND V.ELECTRODE_TYPE     = '')
                                       -- 2026-05-07 종료 김준규: BOM_V → #BOM_FULL_CACHE 로 변경 (서브쿼리 형태는 유지, 옵티마이저 안정)
                                       AND B.BOD_TYPE     = 'PLANT'
                                       AND B.BOD_VALID_YN = 'Y'
                                       AND NOT EXISTS (SELECT 1
                                                          FROM #STG_SHIP_SEMI WITH(NOLOCK) -- SEMI 출하계획 존재시 제외
                                                         WHERE DIVISION_ID = @P_DIVISION_ID
                                                           AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                                                           AND PLAN_TYPE   = @P_PLAN_TYPE
                                                           AND SEQ         = @p_seq
                                                           AND FROM_SITE   = B.TO_SITE
                                                           AND ITEM_ID     = LN.CHILD_ITEM_ID
                                                           AND BOD_ID      = B.BOD_ID
                                                           AND MEASURE     = 'SHIP_PLAN') ) A
                           INNER JOIN #MEASURE M WITH(NOLOCK)   -- [Method B] inline subquery -> #MEASURE 캐시 재사용
                              ON M.COLUMN_NAME          IN ('SEMI_SHIP_PLAN')
                              AND (CASE A.MEASURE WHEN  'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN' ELSE A.MEASURE  END)              = M.COLUMN_NAME
                           WHERE 1 = 1
                           AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                              FROM #STG_SHIP_FG WITH(NOLOCK)   -- 출하계획 존재시 제외
                                             WHERE 1=1
                                               AND FROM_SITE   = A.FROM_SITE
                                               AND ITEM_ID     = A.ITEM_ID
                                               AND BOD_ID      = A.BOD_ID
                                               AND MEASURE     = 'MKT_FCST')
                           ;

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL ##########';
        SET @v_description = @v_program_name + ':' + N' SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -- CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - end

PRINT '--A@X#00900--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            -------------------------------------------------------------------------------------------------------------
            -- (Stage1) @P_ITEM_IDS 필터 적용 - #PSI_GLOBAL_SMALL 의 행 줄이기
            -------------------------------------------------------------------------------------------------------------
            DELETE P
              FROM #PSI_GLOBAL_SMALL P
             WHERE NOT EXISTS (
                       SELECT 1 FROM #FILTER_ITEM_BOTH F   -- 2026-05-06 김준규: PACK/CELL 혼재 → BOTH
                        WHERE F.ITEM_ID = (CASE WHEN ISNULL(P.CELL_ITEM_ID, N'') = N'' THEN P.ITEM_ID ELSE P.CELL_ITEM_ID END)
                   )
               -- 2026-05-11 김준규 [옵션 Y-1]: AS-IS 호환 — SEMI_ measure 의 BOM 자재 ID 보호 (메인 SP 와 동일)
               AND P.MEASURE NOT LIKE 'SEMI_%';

            -- 2026-05-11 김준규 [@P_PLANT_IDS 필터]: 입력된 경우만 PLANT 추가 필터 적용 (SEMI_ 보호 일관성 유지)
            IF EXISTS (SELECT 1 FROM #FILTER_PLANT)
            BEGIN
                DELETE P
                  FROM #PSI_GLOBAL_SMALL P
                 WHERE NOT EXISTS (
                           SELECT 1 FROM #FILTER_PLANT F
                            WHERE F.PLANT_ID = P.FROM_SITE
                       )
                   AND P.MEASURE NOT LIKE 'SEMI_%';
            END;

            IF OBJECT_ID('TEMPDB..#ANL_SHIPMENT_PLAN_FG') IS NOT NULL
                        DROP TABLE #ANL_SHIPMENT_PLAN_FG

                      SELECT *
                      INTO #ANL_SHIPMENT_PLAN_FG
                      FROM #PSI_GLOBAL_SMALL WITH (NOLOCK)
                      WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'

                    IF OBJECT_ID('TEMPDB..#ANL_PRODUCTION_PLAN') IS NOT NULL
                        DROP TABLE #ANL_PRODUCTION_PLAN

                      SELECT *
                      INTO #ANL_PRODUCTION_PLAN
                      FROM #PSI_GLOBAL_SMALL WITH (NOLOCK)
                      WHERE ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INTO #ANL_SHIPMENT_PLAN_FG / #ANL_PRODUCTION_PLAN  ##########';
        SET @v_description = @v_program_name + ':' + N' #ANL_SHIPMENT_PLAN_FG / #ANL_PRODUCTION_PLAN  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -------------------------------------------------------------------------------------------------------------------------
            -- SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN
            -------------------------------------------------------------------------------------------------------------------------
              -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 사용 변수
              IF @v_is_debug = 1 SELECT CONCAT(N'SHIP_PLAN (SEMI) @P_DIVISION_ID:', @P_DIVISION_ID, '|', '@p_engine_plan_id:', @p_engine_plan_id, '|', '@p_master_id:', @p_master_id, '|', '@p_plan_start_yyyymmdd:', @p_plan_start_yyyymmdd, '|', '@P_PLAN_TYPE:', @P_PLAN_TYPE, '|', '@p_seq:', @p_seq, '|', '@p_to_yyyymmdd:', @p_to_yyyymmdd) AS "#PSI_GLOBAL_SMALL 사용변수";

              INSERT INTO #PSI_GLOBAL_SMALL
                SELECT  X.DIVISION_ID
                       ,X.OPERATION_GROUP
                       ,X.CELL_ITEM_ID
                       ,X.ITEM_ID
                       ,X.TO_SITE
                       ,X.PROJECT_CODE
                       ,X.TO_BOH_QTY
                       ,X.FROM_BOH_QTY
                       ,X.INCOTERMS
                       ,X.FROM_SITE
                       ,X.TRANSPORT_MODE
                       ,X.PROD_LINE
                       ,X.MEASURE
                       ,X.YYYYMMDD
                       ,X.QTY
                       ,X.SORT_ORDER_NO
                       ,X.COLUMN_LABEL_NAME
                       ,MAX(X.BOD_ID) AS BOD_ID   --
                       ,X.ATTRIBUTE1
                       ,X.ATTRIBUTE9
                FROM (

                     SELECT   A.DIVISION_ID
                                  , A.OPERATION_GROUP
                                  , '' AS CELL_ITEM_ID
                                  , A.ITEM_ID
                                  , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE
                            , '-' AS PROJECT_CODE
                                  , 0 AS TO_BOH_QTY
                                  , 0 AS FROM_BOH_QTY
                                  , '-' AS INCOTERMS
                                  , A.FROM_SITE
                            -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                            ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE  ),'-') AS TRANSPORT_MODE
                            , '-'              AS PROD_LINE
                                  , M.COLUMN_NAME  AS MEASURE
                                  , A.YYYYMMDD        AS YYYYMMDD
                            , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
                                  , M.SORT_ORDER_NO
                                  , M.COLUMN_LABEL_NAME
                                  , A.BOD_ID
                            , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
                                  , A.ATTRIBUTE9
                            FROM #STG_SHIP_SEMI A WITH(NOLOCK)

                           INNER JOIN #MEASURE M WITH(NOLOCK)
                              ON M.COLUMN_NAME          IN ('SEMI_SHIP_PLAN')
                              -- E20260714-000705 소형 셀 신규 시뮬레이터 확인 요청의 건 매저 변경 ship_plan -> ship_plan_amend
                              -- AND (CASE A.MEASURE WHEN  'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN' ELSE A.MEASURE  END)              = M.COLUMN_NAME 
                              -- E20260714-000705 소형 셀 신규 시뮬레이터 확인 요청의 건 매저 변경 ship_plan -> ship_plan_amend
                              AND (CASE A.MEASURE WHEN  'SHIP_PLAN_AMEND' THEN 'SEMI_SHIP_PLAN' ELSE A.MEASURE  END)              = M.COLUMN_NAME 
                           WHERE 1=1
                                  -- 2026-05-11 김준규 [옵션 A-2]: AS-IS 호환 위해 비활성화 (skeleton 보존) — AND A.QTY <> 0   -- [요구사항#4] 0 제거 (대량 테이블 감소)
                           -- E20260714-000705 소형 셀 신규 시뮬레이터 확인 요청의 건 매저 변경 ship_plan -> ship_plan_amend
                           --   AND A.MEASURE             IN ('SHIP_PLAN') 
                           -- E20260714-000705 소형 셀 신규 시뮬레이터 확인 요청의 건 매저 변경 ship_plan -> ship_plan_amend
                           AND A.MEASURE             IN ('SHIP_PLAN_AMEND') 

                    -- SEMI SEMI_SHIP_PLAN없이 해상재고만 있는 경우 누락되는 로직 수정
                    UNION
                      SELECT DISTINCT
                                   @P_DIVISION_ID            AS DIVISION_ID
                                  ,C.OPERATION_GROUP
                                  , '' AS CELL_ITEM_ID
                                  ,A.ITEM_ID
                                  ,(SUBSTRING(SITE_ID, 1, DBO.FN_CHARINDEX_REV(SITE_ID, '~', 0)-1))  AS TO_SITE
                                  , '-' AS PROJECT_CODE
                                  , 0   AS TO_BOH_QTY
                                        , 0   AS FROM_BOH_QTY
                                  ,'-'  AS INCOTERMS
                                  ,(SUBSTRING(LOT_ID, DBO.FN_CHARINDEX_REV(LOT_ID, '::', 0)+2,100)) AS FROM_SITE
                                  ,'SEA' AS TRANSPORT_MODE    -- 해상재고 강제로 'SEA'
                                  , '-'              AS PROD_LINE
                                  , 'SEMI_SHIP_PLAN' AS MEASURE
                                  , @p_plan_start_yyyymmdd AS YYYYMMDD
        --                                ,CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) AS YYYYMMDD
                                  ,0      AS QTY
                                  , '360' AS SORT_ORDER_NO
                                  , 'Semi Ship Plan' AS COLUMN_LABEL_NAME
                                  -- 2026-05-20 김준규 수정: '-' 하드코딩 → BOD_N_V 조회 (FROM+TO+TRANSPORT_MODE='SEA' 매칭)
                                  --   배경: BOD_ID='-' 인 채로 INSERT 되면 후속 A.5.4 BOD_N_V 매칭 실패 → LT_DAY=0
                                  --   AS-WAS 1차 SP (L1989 와 동일 의도): SEMI_SHIP_PLAN row 는 BOD_N_V 의 BOD_ID 로 채워져야 함
                                  ,ISNULL((SELECT TOP 1 C.BOD_ID
                                            FROM SCP_MST_BOD_N_V C WITH(NOLOCK)
                                           WHERE C.DIVISION_ID    = @P_DIVISION_ID
                                             AND C.FROM_SITE      = (SUBSTRING(A.LOT_ID, DBO.FN_CHARINDEX_REV(A.LOT_ID, '::', 0)+2,100))
                                             AND C.TO_SITE        = (SUBSTRING(A.SITE_ID, 1, DBO.FN_CHARINDEX_REV(A.SITE_ID, '~', 0)-1))
                                             AND C.TRANSPORT_MODE = 'SEA'
                                             AND C.BOD_TYPE       = 'PLANT'
                                             AND C.BOD_VALID_YN   = 'Y'), '-')   AS BOD_ID
                                  ,'SCP_ANL_SHIPMENT_PLAN_SEMI'  AS  ATTRIBUTE1
                                  , NULL  AS ATTRIBUTE9
                              FROM DBO.TH_ENG_STOCK_PLAN_SN A WITH (NOLOCK)
                             INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)
                                ON 0 = 0
                               AND A.ITEM_ID      = C.ITEM_ID
                               -- 2026-06-02 김준규 수정 [미요청 ITEM(예: MCCH318867A1T000) SEMI_SHIP_PLAN 유입 차단]
                               --   원인: 이 UNION 분기(해상재고만 있는 SEMI 보완)는 요청 ITEM 필터가 없어
                               --        TH_ENG_STOCK_PLAN_SN 의 모든 ITEM 이 SEMI_SHIP_PLAN 으로 유입됨(예: MCCH318867A1T000).
                               --   조치: 요청 cell 만 통과하도록 #FILTER_ITEM 만 적용.
                               --   주의: #FILTER_PLANT(FROM_SITE = LOT_ID 유도) 는 적용하지 않음.
                               --        → 요청 ITEM(예: MCCH114030L1)의 정상 SEMI 출하(타 plant 발 CN00254300/KR01297200 행)가
                               --          FROM plant 가 요청목록에 없다는 이유로 사라지는 회귀가 있어 ITEM 필터만 적용.
                               --        (미요청 MCCH318867A1T000 은 #FILTER_ITEM 에 없으므로 ITEM 필터만으로 제거됨)
                             -- 2026-06-04 김준규: (되돌림) #FILTER_ITEM_BOTH → #FILTER_ITEM. 본 ITEM(MCCH114030L1) 해상재고 ITEM_ID 가 이미 CELL 코드라 효과 없었고, 미검증 변경 제거.
                             INNER JOIN #FILTER_ITEM       F  WITH(NOLOCK) ON F.ITEM_ID   = A.ITEM_ID
                             WHERE 1 = 1
                               AND A.MASTER_ID        = @p_master_id
                               AND A.PLAN_ID          = @p_engine_plan_id
                               AND A.DESCR            = 'INT'
                               --AND LEFT(A.SITE_ID, 6) = (SELECT TOP 1 S.SCM_SITE_ID FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.PLANT_ID = LEFT(A.SITE_ID, 6) AND S.PLANT_ID IS NOT NULL)        -- 2021.11.16 SEMI PACK 출하계획생성오류 수정
                                --AND A.ITEM_ID          = 'ACPN1034U-A1'

                               -->>> KSW 2020.09.03 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완) start
                               AND NOT A.ITEM_ID IN (SELECT ITEM_ID
                                                      FROM #STG_SHIP_SEMI WITH(NOLOCK)
                                                     WHERE DIVISION_ID          =  @P_DIVISION_ID
                                                       AND PLAN_START_YYYYMMDD  =  @p_plan_start_yyyymmdd
                                                       AND PLAN_TYPE            =  @P_PLAN_TYPE
                                                       AND SEQ                  =  @p_seq
                                                       AND YYYYMMDD             >=  @p_plan_start_yyyymmdd
                                                       AND YYYYMMDD             <=   @p_to_yyyymmdd       --말일포함 (KSK, 20240814)
                                                       -- SEMI SEMI_SHIP_PLAN없이 해상재고만 있는 경우 누락되는 로직 수정 주석처리
                                                       -- AND MEASURE              IN ('SHIP_PLAN'))
                                                       -- SEMI SEMI_SHIP_PLAN없이 해상재고만 있는 경우 누락되는 로직 수정 수정로직
                                                       AND MEASURE              IN ('SHIP_PLAN_AMEND'))
                               -->>> KSW 2020.09.03 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완) end

                        ) X

                        GROUP BY X.DIVISION_ID
                               ,X.OPERATION_GROUP
                               ,X.CELL_ITEM_ID
                               ,X.ITEM_ID
                               ,X.TO_SITE
                               ,X.PROJECT_CODE
                               ,X.TO_BOH_QTY
                               ,X.FROM_BOH_QTY
                               ,X.INCOTERMS
                               ,X.FROM_SITE
                               ,X.TRANSPORT_MODE
                               ,X.PROD_LINE
                               ,X.MEASURE
                               ,X.YYYYMMDD
                               ,X.QTY
                               ,X.SORT_ORDER_NO
                               ,X.COLUMN_LABEL_NAME
                               ,X.ATTRIBUTE1
                               ,X.ATTRIBUTE9


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL  ##########';

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과
                -- 2026-06-05 김준규 [DEBUG 대상] SEMI_SHIP_PLAN 누락 진단용 ITEM/BOD (필요 시 값만 변경)
                DECLARE @v_dbg_item NVARCHAR(100) = N'MCCH114030L1';
                DECLARE @v_dbg_bod  NVARCHAR(100) = N'7077';

                IF @v_is_debug = 1
                BEGIN
                    -- [진단2] AMEND 적용 '전' SEMI_SHIP_PLAN / SEMI_SHIP_PLAN_ORG 상태 (FROM_SITE+BOD 별)
                    --   → 동일키 SEMI_SHIP_PLAN 이 이미 있으면 Case 1, 없으면 Case 2 후보
                    SELECT N'DBG_1-2_PLAN_ORG_AFTER_INITIAL_INSERT' AS DBG_TAG, P.MEASURE, P.FROM_SITE, P.BOD_ID
                         , COUNT(*) AS CNT
                         , SUM(ISNULL(P.QTY,0))                        AS SUM_QTY
                         , SUM(CASE WHEN P.QTY IS NULL THEN 1 ELSE 0 END) AS NULL_QTY_CNT
                      FROM #PSI_GLOBAL_SMALL P
                     WHERE P.ITEM_ID = @v_dbg_item
                       AND P.BOD_ID = @v_dbg_bod
                       AND P.MEASURE IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG')
                     GROUP BY P.MEASURE, P.FROM_SITE, P.BOD_ID
                     ORDER BY P.MEASURE, P.FROM_SITE, P.BOD_ID;

                    SELECT N'DBG_1-4_RAW_PLAN_ORG_AFTER_INITIAL_INSERT' AS DBG_TAG
                         , P.*
                      FROM #PSI_GLOBAL_SMALL P
                     WHERE P.ITEM_ID = @v_dbg_item
                       AND P.BOD_ID = @v_dbg_bod
                       AND P.MEASURE IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG')
                     ORDER BY P.MEASURE, P.FROM_SITE, P.BOD_ID;

                END


           -- ============================================================================
            -- 2026-05-19 김준규 신규: SEMI_SHIP_PLAN row 를 두 measure 로 복제 INSERT
            --   요구사항: SEMI_SHIP_PLAN 이 존재할 경우, 모든 값 동일하게 + MEASURE/LABEL 만 다른
            --             SEMI_SHIP_PLAN_ORG (50) 와 SEMI_SHIP_GAP_ACC (50) 2개 measure 추가
            --   결과: RAW REPORT 에 3개 measure (SEMI_SHIP_PLAN_ORG, SEMI_SHIP_PLAN, SEMI_SHIP_GAP_ACC) 표시
            --   SORT_ORDER_NO / COLUMN_LABEL_NAME: #MEASURE 캐시 우선, 없으면 hardcoded fallback
            --   ATTRIBUTE1='SCP_ANL_SHIPMENT_PLAN_SEMI' 그대로 → 후속 #ANL_SHIPMENT_PLAN_SEMI 백업 자동 포함
            -- ============================================================================
            INSERT INTO #PSI_GLOBAL_SMALL
            SELECT  P.DIVISION_ID, P.OPERATION_GROUP, P.CELL_ITEM_ID, P.ITEM_ID, P.TO_SITE, P.PROJECT_CODE
                  , P.TO_BOH_QTY, P.FROM_BOH_QTY, P.INCOTERMS, P.FROM_SITE, P.TRANSPORT_MODE, P.PROD_LINE
                  , X.MEASURE_NEW                                          AS MEASURE
                  , P.YYYYMMDD
                  -- 2026-06-05 김준규 수정 [Case 3 사양준수: PLAN 有 + AMEND 無 → ORG = PLAN값]
                  --   ORG 를 PLAN 수량으로 시작. Case 1(AMEND 有)은 이후 3단계-A 0초기화 + 3단계-B/4단계가 AMEND값으로 덮어쓰므로 영향 없음.
                  --   GAP_ACC 는 Plan-Req=0 → 기존대로 NULL 유지.
                  , CASE WHEN X.MEASURE_NEW = N'SEMI_SHIP_PLAN_ORG' THEN P.QTY
                         ELSE CONVERT(INT,NULL) END                         AS QTY
                  , ISNULL(M.SORT_ORDER_NO, X.SORT_ORDER_DEFAULT)          AS SORT_ORDER_NO
                  , ISNULL(M.COLUMN_LABEL_NAME, X.LABEL_DEFAULT)           AS COLUMN_LABEL_NAME
                  , P.BOD_ID, P.ATTRIBUTE1, P.ATTRIBUTE9
              FROM #PSI_GLOBAL_SMALL P
             CROSS APPLY (VALUES
                    (N'SEMI_SHIP_PLAN_ORG', 50, N'SEMI SHIP REQ'),
                    (N'SEMI_SHIP_GAP_ACC',  50, N'ACC(Plan-Req)')
                 ) X(MEASURE_NEW, SORT_ORDER_DEFAULT, LABEL_DEFAULT)
              LEFT JOIN #MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME = X.MEASURE_NEW
             WHERE P.MEASURE = 'SEMI_SHIP_PLAN';

            -- ============================================================================
            -- 2026-05-21 김준규 신규: SHIP_PLAN_AMEND → SEMI_SHIP_PLAN_ORG MERGE 보충
            --   요구사항: SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN 의 SHIP_PLAN_AMEND 데이터로
            --             SEMI_SHIP_PLAN_ORG 를 MERGE 처리 (QTY 는 항상 AMEND 값이 최종).
            --       MATCHED     (같은 5키 PK): SEMI_SHIP_PLAN_ORG.QTY = AMEND.QTY 로 UPDATE
            --       NOT MATCHED (미존재 5키 ): 신규 INSERT (부가정보는 동일 ITEM+BOD+FROM 의
            --                                  SEMI_SHIP_PLAN_ORG 참조 → BOD_N_V lookup → default)
            --   PLAN_TYPE/SEQ : SEMI_SNAPSHOT_SN 내에서 동적 결정 (FN>SE>MA>PR + MAX(SEQ))
            --   5키 PK        : DIVISION_ID + ITEM_ID + FROM_SITE + BOD_ID + YYYYMMDD
            -- ============================================================================
            DECLARE @v_amend_plan_type NVARCHAR(30) = NULL;
            DECLARE @v_amend_seq        INT          = NULL;

            -- 2026-06-08 김준규 [AS-WAS 정렬재현] AMEND 추가경로 4키 테이블을 '무조건' 빈 상태로 선생성.
            --   사유: AMEND 블록(IF) 안에서만 채워지므로, AMEND 없는 실행에서도 뒤쪽 SORT_SEQ1 LEFT JOIN 이
            --         깨지지 않도록 빈 테이블을 항상 보장. (비어있으면 is_added 전부 0 → 순서 영향 없음)
            --   타입: #PSI_GLOBAL_SMALL 에서 SELECT TOP 0 으로 상속 → 이후 JOIN 타입 100% 일치.
            IF OBJECT_ID('tempdb..#AMEND_ADDED_KEYS') IS NOT NULL DROP TABLE #AMEND_ADDED_KEYS;
            SELECT TOP 0 DIVISION_ID, ITEM_ID, FROM_SITE, BOD_ID
              INTO #AMEND_ADDED_KEYS
              FROM #PSI_GLOBAL_SMALL;
            -- 2026-06-08 김준규: 인덱스 제거 (4키 NVARCHAR 합 1040byte > 900byte 클러스터드 키 한도 경고 해소;
            --   #AMEND_ADDED_KEYS 는 소형 테이블이라 JOIN 시 스캔/해시로 충분)

            -- [1단계] SHIP_PLAN_AMEND 대상 PLAN_TYPE/SEQ 동적 결정
            SELECT TOP 1
                   @v_amend_plan_type = PLAN_TYPE
                  ,@v_amend_seq       = SEQ
              FROM SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN WITH(NOLOCK)
             WHERE DIVISION_ID         = @P_DIVISION_ID
               AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
               AND MEASURE             = N'SHIP_PLAN_AMEND'
               AND OPERATION_GROUP     = 'A'
             ORDER BY
                   CASE PLAN_TYPE
                        WHEN 'FN' THEN 4
                        WHEN 'SE' THEN 3
                        WHEN 'MA' THEN 2
                        WHEN 'PR' THEN 1
                        ELSE 0
                   END DESC
                  ,SEQ DESC;

            IF @v_is_debug = 1
                SELECT CONCAT(N'SHIP_PLAN_AMEND(OPT) @v_amend_plan_type:', ISNULL(@v_amend_plan_type, N'<NULL>'),
                              N' | @v_amend_seq:',   ISNULL(CONVERT(NVARCHAR(20), @v_amend_seq), N'<NULL>'))
                       AS "SHIP_PLAN_AMEND 동적결정";

            IF @v_amend_plan_type IS NOT NULL AND @v_amend_seq IS NOT NULL
            BEGIN
                -- [성능 튜닝] 신규 5단계의 #PSI_GLOBAL_SMALL 5키 매칭 가속용 임시 인덱스
                --   대상 패턴 (모두 SEEK 전환):
                --     3단계 UPDATE         : MEASURE='ORG' + 5키 JOIN
                --     4단계 NOT EXISTS S2  : MEASURE='ORG' + 5키
                --     4단계 OUTER APPLY P  : MEASURE='ORG' + (DIV+ITEM+FROM+BOD)
                --     5단계 source FROM P  : MEASURE='ORG' filter
                --     5단계 NOT EXISTS S   : MEASURE='SEMI_SHIP_PLAN' + 5키
                --   효과: 기존 HEAP 풀스캔 누적 (수천 회) → SEEK 누적 (수천 회)
                --   인덱스 prefix (MEASURE, DIVISION_ID, ITEM_ID, FROM_SITE, BOD_ID, YYYYMMDD)
                CREATE NONCLUSTERED INDEX IX_PSI_AMEND_TMP
                    ON #PSI_GLOBAL_SMALL (MEASURE, DIVISION_ID, ITEM_ID, FROM_SITE, BOD_ID, YYYYMMDD);

                -- [2단계] SHIP_PLAN_AMEND 사전 집계 (5키 + SUM(QTY)) → #SHIP_AMEND_TMP
                IF OBJECT_ID('tempdb..#SHIP_AMEND_TMP') IS NOT NULL DROP TABLE #SHIP_AMEND_TMP;

                SELECT A.DIVISION_ID
                      ,A.ITEM_ID
                      ,A.FROM_SITE
                      ,A.BOD_ID
                      ,A.YYYYMMDD
                      ,MIN(A.OPERATION_GROUP)    AS OPERATION_GROUP
                      ,SUM(ISNULL(A.QTY, 0))     AS QTY
                  INTO #SHIP_AMEND_TMP
                  FROM SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN A WITH(NOLOCK)
                  -- 2026-06-02 김준규 수정 [미요청 ITEM(예: MCCH318867A1T000) SEMI_SHIP_PLAN 유입 차단]
                  --   원인: SEMI 는 cell 단위라 #FILTER_ITEM(입력 cell) 만 적용해야 하나(일반 SEMI 스테이징 #STG_SHIP_SEMI L697 동일),
                  --        이 AMEND 블록만 #FILTER_ITEM_BOTH(BOM 양방향 확장)를 써서 BOM 친척 ITEM 까지 유입됨.
                  --   조치: #FILTER_ITEM_BOTH → #FILTER_ITEM 로 통일.
                  --   주의: #FILTER_PLANT 는 적용하지 않음.
                  --        SEMI 는 설계상 plant 필터 비대상(후속 plant DELETE L2147/L2830 도 SEMI_ 제외, SEMI 전용 필터 L2842 는 #FILTER_ITEM).
                  --        plant 필터를 걸면 타 plant 발 정상 SEMI AMEND(예: MCCH114030L1 의 CN/KR 발 출하)가 사라지는 회귀 발생.
                  INNER JOIN #FILTER_ITEM        F  WITH(NOLOCK) ON F.ITEM_ID    = A.ITEM_ID
                 WHERE A.DIVISION_ID         = @P_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                   AND A.OPERATION_GROUP     = 'A'
                   AND A.MEASURE             = N'SHIP_PLAN_AMEND'
                   AND A.PLAN_TYPE           = @v_amend_plan_type
                   AND A.SEQ                 = @v_amend_seq
                   AND A.YYYYMMDD            BETWEEN @p_plan_start_yyyymmdd AND @p_to_yyyymmdd
                   -- 2026-06-04 김준규 추가 [BOD 유효성 검증: ITEM_ID + BOD_ID 가 유효 BOD 매핑/경로에 존재하는 행만 통과]
                   --   A.ITEM_ID → SCP_MST_BOD_ITEM (ITEM↔BOD 매핑), A.BOD_ID → SCP_MST_BOD_N_V (경로 마스터)
                   --   유효 조건: M.VALID_YN='Y' AND B.BOD_VALID_YN='Y' AND B.ROUTE_VALID_YN='Y'
                   --   목적: BOD 에 존재하지 않는(무효) ITEM_ID+BOD_ID 조합의 AMEND garbage 제외.
                   AND EXISTS ( SELECT 1
                                  FROM SCP_MST_BOD_N_V    B WITH(NOLOCK)
                                  INNER JOIN SCP_MST_BOD_ITEM M WITH(NOLOCK)
                                          ON  B.DIVISION_ID = M.DIVISION_ID
                                         AND  B.BOD_ID      = M.BOD_ID
                                 WHERE B.DIVISION_ID    = A.DIVISION_ID
                                   AND B.BOD_ID         = A.BOD_ID
                                   AND M.ITEM_ID        = A.ITEM_ID
                                   AND M.VALID_YN       = 'Y'
                                   AND B.BOD_VALID_YN   = 'Y'
                                   AND B.ROUTE_VALID_YN = 'Y' )
                 GROUP BY A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.BOD_ID, A.YYYYMMDD;

                CREATE CLUSTERED INDEX CX_SHIP_AMEND_TMP
                    ON #SHIP_AMEND_TMP (DIVISION_ID, ITEM_ID, FROM_SITE, BOD_ID, YYYYMMDD);

                -- ============================================================================
                -- 2026-06-08 김준규 [AS-WAS 정렬재현 — AMEND 신규 경로(추가분) 4키 캡처]
                --   목적: AS-WAS VBA(InsertSemiOptRows)가 OPT 추가분을 base 뒤에 끼워넣던 순서를
                --         TO-BE 에서 재현. 여기서 잡은 경로를 SORT_SEQ1 ORDER BY 에서 뒤로 보냄.
                --   정의: 4키(DIV+ITEM+FROM+BOD)에 base SEMI_SHIP_PLAN 이 '아예 없던' 경로(=Case 2 신규).
                --         (= [5단계] 복제 NOT EXISTS 4키 조건과 동일 정의)
                --   주의: 반드시 [3단계-A] 0초기화 '전'(base 원본 상태)에 판단해야 정확함.
                --         테이블은 위(AMEND IF 진입 전)에서 빈 상태로 선생성됨 → 여기선 INSERT 만.
                INSERT INTO #AMEND_ADDED_KEYS (DIVISION_ID, ITEM_ID, FROM_SITE, BOD_ID)
                SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.BOD_ID
                  FROM #SHIP_AMEND_TMP A
                 WHERE NOT EXISTS (
                          SELECT 1 FROM #PSI_GLOBAL_SMALL S
                           WHERE S.MEASURE     = N'SEMI_SHIP_PLAN'
                             AND S.DIVISION_ID = A.DIVISION_ID
                             AND S.ITEM_ID     = A.ITEM_ID
                             AND S.FROM_SITE   = A.FROM_SITE
                             AND S.BOD_ID      = A.BOD_ID );

                IF @v_is_debug = 1 SELECT '#AMEND_ADDED_KEYS' AS "#AMEND_ADDED_KEYS", COUNT(*) AS CNT FROM #AMEND_ADDED_KEYS;

                IF @v_is_debug = 1 SELECT '#SHIP_PLAN_AMEND_TMP' AS "#SHIP_PLAN_AMEND_TMP", COUNT(*) AS CNT FROM #SHIP_AMEND_TMP WHERE ITEM_ID = @v_dbg_item AND BOD_ID = @v_dbg_bod;

                -- ============================================================================
                -- 2026-06-05 김준규 [DEBUG] SEMI_SHIP_PLAN 누락 진단 — AMEND 블록 '진입 전' 스냅샷
                --   목적: 이번 건이 Case 1(동일키 PLAN 존재) / Case 2(PLAN 없음 + INTRANSIT) 중 어느 경로인지 확정
                -- ============================================================================
                IF @v_is_debug = 1
                BEGIN
                    -- [진단1] #SHIP_AMEND_TMP 에 대상 ITEM 일자별 수량 (AMEND 데이터 존재 여부)
                    SELECT N'DBG1_AMEND_TMP' AS DBG_TAG, A.*
                      FROM #SHIP_AMEND_TMP A
                     WHERE A.ITEM_ID = @v_dbg_item
                     ORDER BY A.FROM_SITE, A.BOD_ID, A.YYYYMMDD;

                    -- [진단2] AMEND 적용 '전' SEMI_SHIP_PLAN / SEMI_SHIP_PLAN_ORG 상태 (FROM_SITE+BOD 별)
                    --   → 동일키 SEMI_SHIP_PLAN 이 이미 있으면 Case 1, 없으면 Case 2 후보
                    SELECT N'DBG2_PRE_PLAN_ORG' AS DBG_TAG, P.MEASURE, P.FROM_SITE, P.BOD_ID
                         , COUNT(*) AS CNT
                         , SUM(ISNULL(P.QTY,0))                        AS SUM_QTY
                         , SUM(CASE WHEN P.QTY IS NULL THEN 1 ELSE 0 END) AS NULL_QTY_CNT
                      FROM #PSI_GLOBAL_SMALL P
                     WHERE P.ITEM_ID = @v_dbg_item
                       AND P.MEASURE IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG')
                     GROUP BY P.MEASURE, P.FROM_SITE, P.BOD_ID
                     ORDER BY P.MEASURE, P.FROM_SITE, P.BOD_ID;

                    -- [진단3] INTRANSIT(해상재고 INT) 존재 여부 (4단계 INTRANSIT 가드 / Case 2 전제)
                    SELECT N'DBG3_INTRANSIT' AS DBG_TAG
                         , IT.ITEM_ID
                         , (SUBSTRING(IT.LOT_ID,  DBO.FN_CHARINDEX_REV(IT.LOT_ID,  '::', 0)+2, 100)) AS FROM_SITE
                         , (SUBSTRING(IT.SITE_ID, 1, DBO.FN_CHARINDEX_REV(IT.SITE_ID, '~', 0)-1))    AS TO_SITE
                         , COUNT(*) AS INT_CNT
                      FROM DBO.TH_ENG_STOCK_PLAN_SN IT WITH(NOLOCK)
                     WHERE IT.MASTER_ID = @p_master_id
                       AND IT.PLAN_ID   = @p_engine_plan_id
                       AND IT.DESCR     = 'INT'
                       AND IT.ITEM_ID   = @v_dbg_item
                     GROUP BY IT.ITEM_ID
                            , (SUBSTRING(IT.LOT_ID,  DBO.FN_CHARINDEX_REV(IT.LOT_ID,  '::', 0)+2, 100))
                            , (SUBSTRING(IT.SITE_ID, 1, DBO.FN_CHARINDEX_REV(IT.SITE_ID, '~', 0)-1));
                END

                -- [3단계-A] 2026-06-04 김준규 추가 [AMEND 대상 경로의 SEMI_SHIP_PLAN_ORG.QTY 를 0 으로 초기화]
                --   목적: AMEND 기준으로 완전히 덮어쓰기. AMEND 대상 4키(DIVISION+ITEM+FROM_SITE+BOD_ID) 경로의
                --         모든 날짜 QTY 를 먼저 0 으로 리셋 → 이후 [3단계-B] UPDATE 가 AMEND 있는 날짜만 실제값으로 채움.
                --         → AMEND 에 없는(빠진) 날짜는 0 유지 (이전 잔존값 제거).
                --   주의: 날짜(YYYYMMDD)는 매칭에서 제외 (경로 단위 전체 날짜 초기화).
                DECLARE @v_amend_zero_cnt INT = 0;

                UPDATE T
                   SET T.QTY = 0
                  FROM #PSI_GLOBAL_SMALL T
                 WHERE T.MEASURE = N'SEMI_SHIP_PLAN_ORG'
                   AND EXISTS ( SELECT 1
                                  FROM #SHIP_AMEND_TMP A
                                 WHERE A.DIVISION_ID = T.DIVISION_ID
                                   AND A.ITEM_ID     = T.ITEM_ID
                                   AND A.FROM_SITE   = T.FROM_SITE
                                   AND A.BOD_ID      = T.BOD_ID );

                SET @v_amend_zero_cnt = @@ROWCOUNT;
                IF @v_is_debug = 1 SELECT 'SHIP_PLAN_AMEND_ZERO' AS "SHIP_PLAN_AMEND_ZERO", @v_amend_zero_cnt AS ROW_AFFECTED;

                -- [3단계-B] MATCHED: 동일 5키 SEMI_SHIP_PLAN_ORG.QTY 를 AMEND.QTY 로 UPDATE
                DECLARE @v_amend_upd_cnt INT = 0;

                UPDATE T
                   SET T.QTY = A.QTY
                  FROM #PSI_GLOBAL_SMALL T
                  INNER JOIN #SHIP_AMEND_TMP A
                    ON  T.DIVISION_ID = A.DIVISION_ID
                    AND T.ITEM_ID     = A.ITEM_ID
                    AND T.FROM_SITE   = A.FROM_SITE
                    AND T.BOD_ID      = A.BOD_ID
                    AND T.YYYYMMDD    = A.YYYYMMDD
                 WHERE T.MEASURE = N'SEMI_SHIP_PLAN_ORG';

                SET @v_amend_upd_cnt = @@ROWCOUNT;
                IF @v_is_debug = 1 SELECT 'SHIP_PLAN_AMEND_UPDATE' AS "SHIP_PLAN_AMEND_UPDATE", @v_amend_upd_cnt AS ROW_AFFECTED;

                -- [4단계] NOT MATCHED: 미존재 5키 의 AMEND row 를 신규 INSERT
                DECLARE @v_amend_ins_cnt INT = 0;

                INSERT INTO #PSI_GLOBAL_SMALL
                SELECT
                     A.DIVISION_ID
                    ,ISNULL(P.OPERATION_GROUP, A.OPERATION_GROUP)                   -- OPERATION_GROUP (BIZ_TYPE)
                    ,ISNULL(P.CELL_ITEM_ID, N'')                                    -- CELL_ITEM_ID
                    ,A.ITEM_ID
                    ,COALESCE(P.TO_SITE, B.TO_SITE, N'-')                           -- TO_SITE
                    ,ISNULL(P.PROJECT_CODE, N'-')                                   -- PROJECT_CODE
                    ,0                                                              -- TO_BOH_QTY
                    ,0                                                              -- FROM_BOH_QTY
                    ,ISNULL(P.INCOTERMS, N'-')                                      -- INCOTERMS
                    ,A.FROM_SITE
                    ,COALESCE(P.TRANSPORT_MODE, B.TRANSPORT_MODE, N'-')             -- TRANSPORT_MODE
                    ,ISNULL(P.PROD_LINE, N'-')                                      -- PROD_LINE
                    ,N'SEMI_SHIP_PLAN_ORG'                                          -- MEASURE
                    ,A.YYYYMMDD
                    ,A.QTY                                                          -- QTY (사전 집계된 SUM 값)
                    ,COALESCE(P.SORT_ORDER_NO, M.SORT_ORDER_NO, 50)                 -- SORT_ORDER_NO
                    ,COALESCE(P.COLUMN_LABEL_NAME, M.COLUMN_LABEL_NAME, N'SEMI SHIP REQ')
                    ,A.BOD_ID
                    ,ISNULL(P.ATTRIBUTE1, N'SCP_ANL_SHIPMENT_PLAN_SEMI')            -- ATTRIBUTE1
                    ,P.ATTRIBUTE9                                                   -- NULL fallback
                  FROM #SHIP_AMEND_TMP A
                  -- BOD lookup (TO_SITE / TRANSPORT_MODE 보강)
                  LEFT JOIN SCP_MST_BOD_N_V B WITH(NOLOCK)
                    ON  B.DIVISION_ID    = A.DIVISION_ID
                    AND B.BOD_ID         = A.BOD_ID
                    AND B.FROM_SITE      = A.FROM_SITE
                    AND B.bod_valid_yn   = 'Y'
                    AND B.ROUTE_VALID_YN = 'Y'
                  -- 부가정보 참조 (#PSI_GLOBAL_SMALL 의 SEMI_SHIP_PLAN_ORG / Q3: ITEM_ID + BOD_ID + FROM_SITE)
                  OUTER APPLY (
                        SELECT TOP 1
                               S.OPERATION_GROUP, S.CELL_ITEM_ID, S.TO_SITE, S.PROJECT_CODE
                              ,S.INCOTERMS, S.TRANSPORT_MODE, S.PROD_LINE
                              ,S.SORT_ORDER_NO, S.COLUMN_LABEL_NAME
                              ,S.ATTRIBUTE1, S.ATTRIBUTE9
                          FROM #PSI_GLOBAL_SMALL S
                         WHERE S.MEASURE     = N'SEMI_SHIP_PLAN_ORG'
                           AND S.DIVISION_ID = A.DIVISION_ID          -- 2026-05-22 김준규 추가: 임시 인덱스 prefix 활용
                           AND S.ITEM_ID     = A.ITEM_ID
                           AND S.BOD_ID      = A.BOD_ID
                           AND S.FROM_SITE   = A.FROM_SITE
                       ) P
                  LEFT JOIN #MEASURE M WITH(NOLOCK)
                    ON M.COLUMN_NAME = N'SEMI_SHIP_PLAN_ORG'
                 WHERE NOT EXISTS (
                          SELECT 1
                            FROM #PSI_GLOBAL_SMALL S2
                           WHERE S2.MEASURE     = N'SEMI_SHIP_PLAN_ORG'
                             AND S2.DIVISION_ID = A.DIVISION_ID
                             AND S2.ITEM_ID     = A.ITEM_ID
                             AND S2.FROM_SITE   = A.FROM_SITE
                             AND S2.BOD_ID      = A.BOD_ID
                             AND S2.YYYYMMDD    = A.YYYYMMDD
                       )
                   -- 2026-06-04 김준규 추가 [동일 경로에 INTRANSIT(해상재고 INT) 존재할 때만 AMEND SEMI 신규 INSERT]
                   --   사유: NEXCON(CN00254300) 등 INTRANSIT 이 있는 목적지의 AMEND SEMI 가 누락되는 회귀 차단.
                   --   주의: 이 INSERT(L2507) 시점에는 #INTRANSIT / #PSI_GLOBAL_SMALL 의 INTRANSIT 이 아직 미적재 → 원본 TH_ENG_STOCK_PLAN_SN 직접 참조.
                   --   INTRANSIT 정의 = #INTRANSIT 생성부(L4417~) 와 동일: MASTER_ID/PLAN_ID/DESCR='INT' + ITEM_ID + FROM_SITE(LOT_ID) + TO_SITE(SITE_ID).
                   --   TO_SITE 매칭 = INSERT 될 TO_SITE ( COALESCE(P.TO_SITE, B.TO_SITE, '-') ) 와 동일 (B 안).
                   -- 2026-06-11 김준규 수정 [버그픽스: 기존 경로의 누락 AMEND 일자(예: 7/20만 나오고 8/21 이후 누락) 복원]
                   --   증상: SEMI_SHIP_PLAN_ORG 가 base SEMI_SHIP_PLAN 에 있던 일자(7/20)만 표시되고,
                   --         base 에 없던 AMEND 일자(8/21, 9/01 ...)는 INTRANSIT 가드에 막혀 INSERT 누락.
                   --   조치: INTRANSIT 가드를 '신규 경로(#AMEND_ADDED_KEYS = base SEMI_SHIP_PLAN 없음)' 에만 적용.
                   --         기존 경로(base 존재)는 INTRANSIT 무관하게 누락 AMEND 일자 INSERT → 8/21 이후 복원.
                   --         #AMEND_ADDED_KEYS = base SEMI_SHIP_PLAN 이 '없던' 4키(=신규/Case 2) 이므로
                   --         NOT EXISTS(#AMEND_ADDED_KEYS) = 기존 경로. NEXCON(Case 2) 회귀는 OR 분기로 그대로 보존.
                   AND (
                         -- (가) 기존 경로(base SEMI_SHIP_PLAN 존재): INTRANSIT 무관 — 누락 AMEND 일자 INSERT
                         NOT EXISTS (
                             SELECT 1 FROM #AMEND_ADDED_KEYS K
                              WHERE K.DIVISION_ID = A.DIVISION_ID
                                AND K.ITEM_ID     = A.ITEM_ID
                                AND K.FROM_SITE   = A.FROM_SITE
                                AND K.BOD_ID      = A.BOD_ID )
                      OR -- (나) 신규 경로(base 없음): 기존대로 INTRANSIT 존재 시에만 INSERT (NEXCON Case 2 회귀 방지)
                         EXISTS (
                             SELECT 1
                               FROM DBO.TH_ENG_STOCK_PLAN_SN IT WITH(NOLOCK)
                              -- 2026-06-04 김준규: TH_ENG_STOCK_PLAN_SN 에 DIVISION_ID 컬럼 없음 → MASTER_ID(=DIVISION::WEEKLY)/PLAN_ID 로 division 구분
                              WHERE IT.MASTER_ID   = @p_master_id
                                AND IT.PLAN_ID     = @p_engine_plan_id
                                AND IT.DESCR       = 'INT'
                                AND IT.ITEM_ID     = A.ITEM_ID
                                AND (SUBSTRING(IT.LOT_ID,  DBO.FN_CHARINDEX_REV(IT.LOT_ID,  '::', 0)+2, 100)) = A.FROM_SITE
                                AND (SUBSTRING(IT.SITE_ID, 1, DBO.FN_CHARINDEX_REV(IT.SITE_ID, '~', 0)-1))    = COALESCE(P.TO_SITE, B.TO_SITE, N'-') )
                       );

                SET @v_amend_ins_cnt = @@ROWCOUNT;
                IF @v_is_debug = 1 SELECT 'SHIP_PLAN_AMEND_INSERT' AS "SHIP_PLAN_AMEND_INSERT", @v_amend_ins_cnt AS ROW_AFFECTED;

                -- [5단계] AMEND 로 신규 INSERT 된 SEMI_SHIP_PLAN_ORG row 를
                --         SEMI_SHIP_PLAN + SEMI_SHIP_GAP_ACC 로 복제 (3종 measure 일관성 유지)
                --   대상 조건: 동일 5키 (DIV+ITEM+FROM+BOD+YYYYMMDD) 의 SEMI_SHIP_PLAN 이 없는
                --              SEMI_SHIP_PLAN_ORG row (= 4단계 INSERT 결과)
                --   참고: UPDATE 된 row 는 이미 SEMI_SHIP_PLAN 이 존재하므로 NOT EXISTS 에 걸려 제외
                DECLARE @v_amend_dup_cnt INT = 0;

                INSERT INTO #PSI_GLOBAL_SMALL
                SELECT  P.DIVISION_ID, P.OPERATION_GROUP, P.CELL_ITEM_ID, P.ITEM_ID, P.TO_SITE, P.PROJECT_CODE
                      , P.TO_BOH_QTY, P.FROM_BOH_QTY, P.INCOTERMS, P.FROM_SITE, P.TRANSPORT_MODE, P.PROD_LINE
                      , X.MEASURE_NEW                                          AS MEASURE
                      , P.YYYYMMDD
                      -- 2026-06-05 김준규 수정 [Case 2 사양준수: 경로에 PLAN 無 → PLAN = ORG(=AMEND)값]
                      --   아래 NOT EXISTS 4키화로 이 INSERT 는 Case 2 에서만 실행됨 → PLAN 을 ORG(P.QTY)와 동일하게.
                      --   GAP_ACC 는 Plan-Req=0 → NULL 유지.
                      , CASE WHEN X.MEASURE_NEW = N'SEMI_SHIP_PLAN' THEN P.QTY
                             ELSE CONVERT(INT,NULL) END                        AS QTY
                      , ISNULL(M.SORT_ORDER_NO, X.SORT_ORDER_DEFAULT)          AS SORT_ORDER_NO
                      , ISNULL(M.COLUMN_LABEL_NAME, X.LABEL_DEFAULT)           AS COLUMN_LABEL_NAME
                      , P.BOD_ID, P.ATTRIBUTE1, P.ATTRIBUTE9
                  FROM #PSI_GLOBAL_SMALL P
                 CROSS APPLY (VALUES
                        (N'SEMI_SHIP_PLAN',    50, N'Semi Ship Plan'),
                        (N'SEMI_SHIP_GAP_ACC', 50, N'ACC(Plan-Req)')
                     ) X(MEASURE_NEW, SORT_ORDER_DEFAULT, LABEL_DEFAULT)
                  LEFT JOIN #MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME = X.MEASURE_NEW
                 WHERE P.MEASURE = N'SEMI_SHIP_PLAN_ORG'
                   -- 2026-06-05 김준규 수정 [(가) 사양준수: 존재판단 = 4키(DIV+ITEM+FROM+BOD, 날짜 제외)]
                   --   경로(4키)에 SEMI_SHIP_PLAN 이 '아예 없을' 때만(=Case 2) PLAN 신규 생성.
                   --   Case 1(경로에 PLAN 존재)은 PLAN 손대지 않음 → AMEND 신규일자는 ORG만 존재(=의도된 GAP).
                   AND NOT EXISTS (
                          SELECT 1 FROM #PSI_GLOBAL_SMALL S
                           WHERE S.MEASURE     = N'SEMI_SHIP_PLAN'
                             AND S.DIVISION_ID = P.DIVISION_ID
                             AND S.ITEM_ID     = P.ITEM_ID
                             AND S.FROM_SITE   = P.FROM_SITE
                             AND S.BOD_ID      = P.BOD_ID
                       );

                SET @v_amend_dup_cnt = @@ROWCOUNT;
                IF @v_is_debug = 1 SELECT 'SHIP_PLAN_AMEND_DUPLICATE' AS "SHIP_PLAN_AMEND_DUPLICATE", @v_amend_dup_cnt AS ROW_AFFECTED;

                -- ============================================================================
                -- 2026-06-05 김준규 [DEBUG] SEMI_SHIP_PLAN 누락 진단 — AMEND 3·4·5단계 '적용 후' 스냅샷
                --   판정: ORG 는 SUM_QTY 有 / PLAN 은 NULL_QTY_CNT 多·SUM_QTY 0 이면 → 5단계 NULL 채움 결함(Case 2)
                -- ============================================================================
                IF @v_is_debug = 1
                BEGIN
                    -- [진단4] 적용 후 SEMI_SHIP_PLAN / ORG / GAP 상태 (FROM_SITE+BOD 별)
                    SELECT N'DBG4_POST_PLAN_ORG_GAP' AS DBG_TAG, P.MEASURE, P.FROM_SITE, P.BOD_ID
                         , COUNT(*) AS CNT
                         , SUM(ISNULL(P.QTY,0))                          AS SUM_QTY
                         , SUM(CASE WHEN P.QTY IS NULL THEN 1 ELSE 0 END) AS NULL_QTY_CNT
                      FROM #PSI_GLOBAL_SMALL P
                     WHERE P.ITEM_ID = @v_dbg_item
                       AND P.MEASURE IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG', N'SEMI_SHIP_GAP_ACC')
                     GROUP BY P.MEASURE, P.FROM_SITE, P.BOD_ID
                     ORDER BY P.FROM_SITE, P.BOD_ID, P.MEASURE;

                    -- [진단5] 대상 BOD 일자별 상세 (ORG vs PLAN 수량 직접 대조)
                    SELECT N'DBG5_POST_BY_DATE' AS DBG_TAG, P.MEASURE, P.FROM_SITE, P.BOD_ID, P.YYYYMMDD, P.QTY
                      FROM #PSI_GLOBAL_SMALL P
                     WHERE P.ITEM_ID = @v_dbg_item
                       AND P.BOD_ID  = @v_dbg_bod
                       AND P.MEASURE IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG')
                     ORDER BY P.FROM_SITE, P.YYYYMMDD, P.MEASURE;
                END

                IF OBJECT_ID('tempdb..#SHIP_AMEND_TMP') IS NOT NULL DROP TABLE #SHIP_AMEND_TMP;

                -- [성능 튜닝] 임시 인덱스 DROP (후속 INSERT 단계의 인덱스 유지 비용 0)
                DROP INDEX IX_PSI_AMEND_TMP ON #PSI_GLOBAL_SMALL;

                PRINT N'--A@X#00640_SHIP_PLAN_AMEND-- UPD:' + CONVERT(NVARCHAR(20), @v_amend_upd_cnt)
                                                  + N' INS:' + CONVERT(NVARCHAR(20), @v_amend_ins_cnt)
                                                  + N' DUP:' + CONVERT(NVARCHAR(20), @v_amend_dup_cnt)
                                                  + N' ' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
            END
            ELSE
            BEGIN
                PRINT N'--A@X#00640_SHIP_PLAN_AMEND_SKIP-- ' + N'(대상 PLAN_TYPE/SEQ 없음)';
            END

            -- [DEBUG] SHIP_PLAN_AMEND MERGE+복제 결과 (3종 measure 총합 / 건수)
            IF @v_is_debug = 1
                SELECT '#PSI_GLOBAL_SMALL_AMEND_AFTER' AS "#PSI_GLOBAL_SMALL_AMEND_AFTER",
                       MEASURE, COUNT(*) AS CNT, SUM(QTY) AS SUM_QTY
                  FROM #PSI_GLOBAL_SMALL
                 WHERE MEASURE IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG', N'SEMI_SHIP_GAP_ACC')
                 GROUP BY MEASURE
                 ORDER BY MEASURE;

            -- [DEBUG] 복제 결과 검증 (3개 measure: SEMI_SHIP_PLAN_ORG / SEMI_SHIP_PLAN / SEMI_SHIP_GAP_ACC)
            --IF @v_is_debug = 1 SELECT '#PSI_GLOBAL_SMALL_6b_AFTER_SEMI_DUPLICATE' AS "#PSI_GLOBAL_SMALL_6b",
                   --MEASURE, COUNT(*) AS CNT, SUM(QTY) AS SUM_QTY
              --FROM #PSI_GLOBAL_SMALL
             --WHERE MEASURE IN ('SEMI_SHIP_PLAN', 'SEMI_SHIP_PLAN_ORG', 'SEMI_SHIP_GAP_ACC')
             --GROUP BY MEASURE;

        SET @v_description = @v_program_name + ':' + N' SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#01000--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

                      SELECT *
                      INTO #ANL_SHIPMENT_PLAN_SEMI
                      FROM #PSI_GLOBAL_SMALL WITH (NOLOCK)
                      WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INTO ##ANL_SHIPMENT_PLAN_SEMI ##########';
        SET @v_description = @v_program_name + ':' + N' #ANL_SHIPMENT_PLAN_SEMI  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -------------------------------------------------------------------------------------------------------------------------
            -- CELL_CHAR_PLAN (SCP_PLN_PRODUCTION_PLAN)   ACTIVATE_COMPLETED --> CELL_CHAR_PLAN
            -------------------------------------------------------------------------------------------------------------------------

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 사용 변수
            IF @v_is_debug = 1 SELECT CONCAT(N'CELL_CHAR_PLAN @P_DIVISION_ID:', @P_DIVISION_ID, '|', '@p_plan_start_yyyymmdd:', @p_plan_start_yyyymmdd, '|', '@P_PLAN_TYPE:', @P_PLAN_TYPE, '|', '@p_seq:', @p_seq) AS "#PSI_GLOBAL_SMALL 사용변수";

            INSERT INTO #PSI_GLOBAL_SMALL
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
                      , MAX(X.PROD_LINE)
                      , X.MEASURE
                      , X.YYYYMMDD
                      , MAX(X.QTY) AS QTY
                      , X.SORT_ORDER_NO
                            , X.COLUMN_LABEL_NAME
                            , X.BOD_ID
                      , MAX(X.ATTRIBUTE1) AS ATTRIBUTE1
                            , MAX(X.ATTRIBUTE9)  AS ATTRIBUTE9
                  FROM
                      (

                        SELECT    A.DIVISION_ID
                                , A.OPERATION_GROUP
                                , '' AS CELL_ITEM_ID
                                , A.ITEM_ID
                                , '-' AS  TO_SITE
                                , '-' AS PROJECT_CODE
                                , 0 AS TO_BOH_QTY
                                , 0 AS FROM_BOH_QTY
                                , '-' AS INCOTERMS
                                , A.SITE_ID                AS FROM_SITE
                                , '-'        AS TRANSPORT_MODE
                                , '-'                       AS PROD_LINE
                                , 'CELL_CHAR_PLAN'     AS MEASURE                    -- ACTIVATE_COMPLETED
                                , CONVERT(VARCHAR(8),A.END_TIME,112)   AS YYYYMMDD
                                , SUM(ISNULL(A.COMPLETE_QTY,0))  AS QTY
                                , M.SORT_ORDER_NO
                                      , M.COLUMN_LABEL_NAME
                                      ,  '-' AS BOD_ID
                                , 'SCP_PLN_PRODUCTION_PLAN' AS ATTRIBUTE1
                                      , A.OPERATION_ID AS ATTRIBUTE9
                          FROM SCP_PLN_PRODUCTION_PLAN A WITH(NOLOCK)
                           INNER JOIN #MEASURE M WITH(NOLOCK)
                         ON M.COLUMN_NAME          IN ('CELL_CHAR_PLAN')
                           -- 2026-05-07 김준규: 사용자 입력 ITEM 외는 의미 없음 → 사전 필터
                           INNER JOIN #FILTER_ITEM_BOTH F WITH(NOLOCK) ON A.ITEM_ID = F.ITEM_ID
                           INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID = A.SITE_ID   -- 2026-05-11 김준규 [@P_PLANT_IDS 필터]
                         WHERE 1 = 1
                           AND A.DIVISION_ID           = @P_DIVISION_ID
                           AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
                           AND A.PLAN_TYPE             = @P_PLAN_TYPE
                           AND A.SEQ                   = @p_seq
                           AND A.OPERATION_ID          = 'F6000'
                        GROUP BY A.DIVISION_ID
                                , A.OPERATION_GROUP
                                , A.ITEM_ID
                                , A.SITE_ID
                                , CONVERT(VARCHAR(8),A.END_TIME,112)
                                , M.SORT_ORDER_NO
                                      , M.COLUMN_LABEL_NAME
                                      , OPERATION_ID

                          UNION
                                SELECT DISTINCT A.DIVISION_ID
                                      , A.OPERATION_GROUP
                                      , '' AS CELL_ITEM_ID
                                      , A.ITEM_ID
                                      , '-' AS  TO_SITE
                                      , '-' AS PROJECT_CODE
                                      , 0 AS TO_BOH_QTY
                                      , 0 AS FROM_BOH_QTY
                                      , '-' AS INCOTERMS
                                      , A.FROM_SITE
                                      , '-'        AS TRANSPORT_MODE
                                      , '-'                       AS PROD_LINE
                                      , 'CELL_CHAR_PLAN'     AS MEASURE                    -- ACTIVATE_COMPLETED
                                      , YYYYMMDD
                                      , 0 AS QTY
                                      , '440' AS SORT_ORDER_NO
                                            , 'Char. Plan' AS COLUMN_LABEL_NAME
                                            ,  '-' AS BOD_ID
                                      , '' AS ATTRIBUTE1
                                            , '' AS ATTRIBUTE9
                                 FROM #ANL_PRODUCTION_PLAN  A WITH (NOLOCK)
                                WHERE 0 = 0

                                -- KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - Start
                            UNION
                                SELECT DISTINCT A.DIVISION_ID
                                      , A.OPERATION_GROUP
                                      , '' AS CELL_ITEM_ID
                                      , A.ITEM_ID
                                      , '-' AS  TO_SITE
                                      , '-' AS PROJECT_CODE
                                      , 0 AS TO_BOH_QTY
                                      , 0 AS FROM_BOH_QTY
                                      , '-' AS INCOTERMS
                                      , A.FROM_SITE
                                      , '-'        AS TRANSPORT_MODE
                                      , '-'                       AS PROD_LINE
                                      , 'CELL_CHAR_PLAN'     AS MEASURE                    -- ACTIVATE_COMPLETED
                                      , YYYYMMDD
                                      , 0 AS QTY
                                      , '440' AS SORT_ORDER_NO
                                            , 'Char. Plan' AS COLUMN_LABEL_NAME
                                            ,  '-' AS BOD_ID
                                      , '' AS ATTRIBUTE1
                                            , '' AS ATTRIBUTE9
                                 FROM #ANL_SHIPMENT_PLAN_SEMI A WITH (NOLOCK)
                                 WHERE 0 = 0
                                 -- KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - End
                      ) X

                    GROUP BY
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
--                        , X.PROD_LINE
                             , X.MEASURE
                             , X.YYYYMMDD
                             --, MAX(X.QTY) AS QTY
                             , X.SORT_ORDER_NO
                             , X.COLUMN_LABEL_NAME
                             , X.BOD_ID
                             --, X.ATTRIBUTE1
                             --, X.ATTRIBUTE9


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL  ##########';

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과

        SET @v_description = @v_program_name + ':' + N' CELL_CHAR_PLAN (SCP_PLN_PRODUCTION_PLAN)   ACTIVATE_COMPLETED --> CELL_CHAR_PLAN  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#01100--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

                      SELECT *
                      INTO #SCP_PLN_PRODUCTION_PLAN
                      FROM #PSI_GLOBAL_SMALL WITH (NOLOCK)
                      WHERE ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INTO #SCP_PLN_PRODUCTION_PLAN  ##########';
        SET @v_description = @v_program_name + ':' + N' #PSI_GLOBAL_SMALL ATTRIBUTE1.SCP_PLN_PRODUCTION_PLAN   ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -------------------------------------------------------------------------------------------------------------
            -- (Stage1) @P_ITEM_IDS 필터 적용 - #PSI_GLOBAL_SMALL 의 행 줄이기
            -------------------------------------------------------------------------------------------------------------
            DELETE P
              FROM #PSI_GLOBAL_SMALL P
             WHERE NOT EXISTS (
                       SELECT 1 FROM #FILTER_ITEM_BOTH F   -- 2026-05-06 김준규: PACK/CELL 혼재 → BOTH
                        WHERE F.ITEM_ID = (CASE WHEN ISNULL(P.CELL_ITEM_ID, N'') = N'' THEN P.ITEM_ID ELSE P.CELL_ITEM_ID END)
                   )
               -- 2026-05-11 김준규 [옵션 Y-1]: AS-IS 호환 — SEMI_ measure 의 BOM 자재 ID 보호 (메인 SP 와 동일)
               AND P.MEASURE NOT LIKE 'SEMI_%';

            -- 2026-05-11 김준규 [@P_PLANT_IDS 필터]: 입력된 경우만 PLANT 추가 필터 적용 (SEMI_ 보호 일관성 유지)
            IF EXISTS (SELECT 1 FROM #FILTER_PLANT)
            BEGIN
                DELETE P
                  FROM #PSI_GLOBAL_SMALL P
                 WHERE NOT EXISTS (
                           SELECT 1 FROM #FILTER_PLANT F
                            WHERE F.PLANT_ID = P.FROM_SITE
                       )
                   AND P.MEASURE NOT LIKE 'SEMI_%';
            END;
            -- 추가된 SEMI/CELL_CHAR INSERT 결과 및 파생 임시테이블도 동일 필터 적용
            DELETE S
              FROM #ANL_SHIPMENT_PLAN_SEMI S
             WHERE NOT EXISTS (
                       SELECT 1 FROM #FILTER_ITEM F        -- 2026-05-06 김준규: SEMI 는 CELL 단위 → 그대로 #FILTER_ITEM
                        WHERE F.ITEM_ID = (CASE WHEN ISNULL(S.CELL_ITEM_ID, N'') = N'' THEN S.ITEM_ID ELSE S.CELL_ITEM_ID END)
                   );
            DELETE S
              FROM #SCP_PLN_PRODUCTION_PLAN S
             WHERE NOT EXISTS (
                       SELECT 1 FROM #FILTER_ITEM_BOTH F   -- 2026-05-06 김준규: PROD_PLAN.ITEM_ID 는 PACK 단위 → BOTH
                        WHERE F.ITEM_ID = (CASE WHEN ISNULL(S.CELL_ITEM_ID, N'') = N'' THEN S.ITEM_ID ELSE S.CELL_ITEM_ID END)
                   );
            IF @v_is_debug = 1 SELECT 'PSI_GLOBAL_SMALL_LAST' AS PSI_GLOBAL_SMALL_LAST, * FROM #PSI_GLOBAL_SMALL;

            -------------------------------------------------------------------------------------------------------------------------
            -- 대상 ITEM_ID 추출
            -------------------------------------------------------------------------------------------------------------------------

              SELECT DISTINCT
                     DIVISION_ID
                    ,OPERATION_GROUP
                    ,CELL_ITEM_ID
                    ,ITEM_ID
                    ,TO_SITE
                    ,PROJECT_CODE
                    ,MAX(TO_BOH_QTY) AS TO_BOH_QTY
                    ,MAX(FROM_BOH_QTY) AS FROM_BOH_QTY
                    ,INCOTERMS
                    ,FROM_SITE
                    ,TRANSPORT_MODE
                    ,PROD_LINE
                    ,MEASURE
                    ,@p_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
                    ,MAX(QTY) AS QTY
                    ,SORT_ORDER_NO
                    ,COLUMN_LABEL_NAME
                    ,BOD_ID
                    ,MAX(ATTRIBUTE1) AS ATTRIBUTE1
                    ,MAX(ATTRIBUTE9) AS ATTRIBUTE9
              INTO #ITEM_ID
              FROM #PSI_GLOBAL_SMALL WITH (NOLOCK)
              WHERE 0 = 0
              GROUP BY
                     DIVISION_ID
                    ,OPERATION_GROUP
                    ,CELL_ITEM_ID
                    ,ITEM_ID
                    ,TO_SITE
                    ,PROJECT_CODE
                    ,INCOTERMS
                    ,FROM_SITE
                    ,TRANSPORT_MODE
                    ,PROD_LINE
                    ,MEASURE
                    ,SORT_ORDER_NO
                    ,COLUMN_LABEL_NAME
                    ,BOD_ID
                    --,ATTRIBUTE1
                    --,ATTRIBUTE9

                IF @v_is_debug = 1  BEGIN SELECT '995_#ITEM_ID' AS "#ITEM_ID" , * FROM  #ITEM_ID ; END


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INTO #ITEM_ID  ##########';
        SET @v_description = @v_program_name + ':' + N' 대상 ITEM_ID 추출   ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


                IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL_AUTO') IS NOT NULL
                   DROP TABLE #PSI_GLOBAL_SMALL_AUTO;

                   CREATE TABLE #PSI_GLOBAL_SMALL_AUTO (
                        DIVISION_ID          NVARCHAR(060)
                       ,OPERATION_GROUP      NVARCHAR(060)
                       ,CELL_ITEM_ID         NVARCHAR(100)
                       ,ITEM_ID              NVARCHAR(100)
                       ,TO_SITE              NVARCHAR(060)
                       ,PROJECT_CODE         NVARCHAR(050)     -- FG 때문에 추가
                       ,TO_BOH_QTY           numeric(20,10)    --BIGINT
                       ,FROM_BOH_QTY         numeric(20,10)    -- BIGINT
                       ,INCOTERMS            NVARCHAR(20)
                       ,FROM_SITE            NVARCHAR(60)
                       ,TRANSPORT_MODE       NVARCHAR(50)
                       ,PROD_LINE            NVARCHAR(50)
                       ,MEASURE              NVARCHAR(100)
                       ,YYYYMMDD             NVARCHAR(010)
                       ,QTY                  NUMERIC(20,10)
                       ,SORT_ORDER_NO        INT
                       ,COLUMN_LABEL_NAME    NVARCHAR(300)
                       ,BOD_ID               NVARCHAR(300)
                       ,ATTRIBUTE1           NVARCHAR(150)
                       ,ATTRIBUTE9           NVARCHAR(150)   -- OPERATION_ID
                   );

                -- 2026-05-06 김준규 추가: MERGE 시 ON 조건 컬럼에 인덱스 추가 (풀스캔 방지)
                CREATE NONCLUSTERED INDEX IX_PGSA_MERGE
                    ON #PSI_GLOBAL_SMALL_AUTO (MEASURE, ITEM_ID, FROM_SITE, YYYYMMDD)
                    INCLUDE (QTY, ATTRIBUTE1, ATTRIBUTE9, OPERATION_GROUP);

                -- 2026-05-14 김준규: 작업 2, 3 (02400~02500) 의 EXISTS 가속
                --   FROM SCP_MST_BOD_N_V WHERE EXISTS (SELECT 1 FROM #PSI WHERE MEASURE=... AND FROM_SITE=... AND TO_SITE=...)
                --   대량 NL Join 의 inner 쪽 → SEEK 필수
                CREATE NONCLUSTERED INDEX IX_PGSA_EXISTS
                    ON #PSI_GLOBAL_SMALL_AUTO (MEASURE, FROM_SITE, TO_SITE)
                    INCLUDE (INCOTERMS, TRANSPORT_MODE, BOD_ID);

PRINT '--A@X#01200--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
            -------------------------------------------------------------------------------------------------------------------------
            -- MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_SMALL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID
                                    , X.OPERATION_GROUP
                                    , X.CELL_ITEM_ID
                                    , X.ITEM_ID
                                    , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
                                    , '0' AS TO_BOH_QTY
                                    , '0' AS FROM_BOH_QTY
                                    , '-' AS INCOTERMS
                                    , '-' AS FROM_SITE
                              , '-' AS TRANSPORT_MODE
                              , '-' AS PROD_LINE
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.PLAN_START_YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , '-' AS BOD_ID
                              , 'MKT_FCST_PACK_TOTAL' AS ATTRIBUTE1
                                    , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND M.DIV       ='C'
                AND M.GUBUN       = 'ITEM_ID'
                AND X.MEASURE   = 'MKT_FCST'
                AND X.OPERATION_GROUP ='P'

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL) ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -------------------------------------------------------------------------------------------------------------------------
            -- MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_SMALL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID
                                    , X.OPERATION_GROUP
                                    , X.CELL_ITEM_ID
                                    , X.ITEM_ID
                                    , X.TO_SITE
                            , '-' AS PROJECT_CODE
                                    , X.TO_BOH_QTY
                                    , X.FROM_BOH_QTY
                                    , X.INCOTERMS
                                    , X.FROM_SITE
                                    , X.TRANSPORT_MODE
                              , X.PROD_LINE
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.PLAN_START_YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , X.BOD_ID
                              , X.ATTRIBUTE1
                                    , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND M.DIV       ='C'
                AND M.GUBUN       = 'TO'
                AND X.MEASURE   = 'MKT_FCST'


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL)  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -------------------------------------------------------------------------------------------------------------------------
            -- MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_SMALL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID
                                    , X.OPERATION_GROUP
                                    , X.CELL_ITEM_ID
                                    , X.ITEM_ID
                                    , X.TO_SITE
                              , (CASE WHEN M.COLUMN_NAME   = 'SHIP_PLAN' THEN X.PROJECT_CODE ELSE '-' END) AS PROJECT_CODE
                                    , X.TO_BOH_QTY
                                    , X.FROM_BOH_QTY
                                    , X.INCOTERMS
                                    , X.FROM_SITE
                              , (CASE WHEN M.COLUMN_NAME   = 'SHIP_PLAN' THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE
                              , X.PROD_LINE
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.PLAN_START_YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , (CASE WHEN M.COLUMN_NAME = 'SHIP_PLAN' THEN BOD_ID  ELSE '-' END) AS BOD_ID
                              -- 2026-05-18 김준규 [패치 2-B]: 통합 INSERT(L4600 부근) 와 ATTRIBUTE1 통일 →
                              --   SCM_SIM_DYN_COLS GROUP BY 시 skeleton + 실데이터 SUM 합쳐짐 (중복 row 방지)
                              -- AS-WAS: , X.ATTRIBUTE1
                              , N'SCP_ANL_SHIPMENT_PLAN_FG'   AS ATTRIBUTE1
                                    , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND M.DIV       ='C'
                AND M.GUBUN     = 'FROM'
                AND X.MEASURE   IN ('SHIP_PLAN','WHIN')
                AND NOT M.COLUMN_NAME = 'SHIP_PLAN_MEMO'        -- 2022.10.19   KSW         Memo measure 추가
                ;

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT) ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#01300--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


            -- 2022.10.19   KSW         Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 - START
            INSERT #PSI_GLOBAL_SMALL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID
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
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.PLAN_START_YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , X.BOD_ID
                              , X.ATTRIBUTE1
                                    , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND M.DIV       ='C'
                AND M.GUBUN     = 'FROM'
                AND X.MEASURE   = 'SHIP_PLAN'
                AND M.COLUMN_NAME = 'SHIP_PLAN_MEMO'
                ;

            -- 2022.10.19   KSW         Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 - END

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -------------------------------------------------------------------------------------------------------------------------
            -- MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_SMALL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID
                                    , X.OPERATION_GROUP
                                    , X.CELL_ITEM_ID
                                    , X.ITEM_ID
                                    , X.TO_SITE
                              , X.PROJECT_CODE
                                    , X.TO_BOH_QTY
                                    , X.FROM_BOH_QTY
                                    , X.INCOTERMS
                                    , X.FROM_SITE
                              , (CASE WHEN M.COLUMN_NAME  IN ( 'PACK_BOH','CELL_BOH','PACK_EOH','CELL_EOH')  THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE
                              , (CASE WHEN M.COLUMN_NAME  IN ( 'PACK_BOH','CELL_BOH','PACK_EOH','CELL_EOH', 'PACK_BOH_HOLD', 'PACK_BOH_WAIT_FOR_INSP', 'PACK_BOH_EXP_INSP_DATE')  THEN '-' ELSE X.PROD_LINE END) AS PROD_LINE       -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.PLAN_START_YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , (CASE WHEN M.COLUMN_NAME IN ( 'PACK_BOH','CELL_BOH','PACK_EOH','CELL_EOH') THEN X.BOD_ID  ELSE '-' END) AS BOD_ID
                              , X.ATTRIBUTE1
                                    , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND M.DIV       ='P'
                AND M.GUBUN     = 'FROM'
                AND X.MEASURE   = 'PACK_PROD'
                AND X.OPERATION_GROUP   = 'P'
                -- 전진검사 MEASURE 는 대상 모델만 추가
                AND (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH_WAIT_FOR_INSP', 'PACK_BOH_EXP_INSP_DATE') THEN
                               (CASE WHEN ISNULL((SELECT DISTINCT ITEM_ID
                                              FROM SCP_MST_OPERATION_LT C WITH (NOLOCK)
                                             WHERE C.DIVISION_ID = @P_DIVISION_ID
                                               AND C.SCM_SITE_ID = X.FROM_SITE
                                               AND C.ITEM_ID     = X.ITEM_ID
                                               AND C.LT_OPERATION = 'PRE_INSP'
                                               AND C.ATTRIBUTE1   = 'Y'
                                           ), 'N') = 'N' THEN 'N' ELSE 'Y'
                                END) ELSE 'Y'
                     END) = 'Y'


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH)  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#01400--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


           -------------------------------------------------------------------------------------------------------------------------
            -- MEASURE 추가 : CELL TO   SITE별 (SEMI_WHIN_TOTAL)
            -- MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_SMALL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID
                                    , X.OPERATION_GROUP
                                    , X.CELL_ITEM_ID
                                    , X.ITEM_ID
                                    , X.TO_SITE
                              , X.PROJECT_CODE
                                    , X.TO_BOH_QTY
                                    , X.FROM_BOH_QTY
                                    , X.INCOTERMS
                                    , X.FROM_SITE
                              , (CASE WHEN M.COLUMN_NAME   IN ('SEMI_SHIP_PLAN','SEMI_SHIP_PLAN_MEMO') THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE        -- 2022.10.19   KSW         Memo measure 추가 :: IN 으로 변경하고 SEMI_SHIP_PLAN_MEMO 추가
                              , X.PROD_LINE
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.PLAN_START_YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , (CASE WHEN M.COLUMN_NAME IN ('SEMI_SHIP_PLAN','SEMI_SHIP_PLAN_MEMO') THEN X.BOD_ID  ELSE '-' END) AS BOD_ID       -- 2022.10.19   KSW         Memo measure 추가 :: IN 으로 변경하고 SEMI_SHIP_PLAN_MEMO 추가
                              , X.ATTRIBUTE1
                              , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND M.DIV       ='A'
                AND M.GUBUN     = 'FROM'
                AND M.COLUMN_NAME LIKE 'SEMI%'
                AND X.MEASURE   = 'SEMI_SHIP_PLAN'
                AND X.OPERATION_GROUP   = 'A'
            -- SEMI_WHIN_TOTAL
            UNION ALL
                SELECT  DISTINCT  X.DIVISION_ID
                                    , X.OPERATION_GROUP
                                    , X.CELL_ITEM_ID
                                    , X.ITEM_ID
                       , X.TO_SITE
                              , '-' AS PROJECT_CODE
                                    , X.TO_BOH_QTY
                                    , X.FROM_BOH_QTY
                                    , '-' AS INCOTERMS
                                    , '-' AS FROM_SITE
                              , '-' AS TRANSPORT_MODE
                              , '-' AS PROD_LINE
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.PLAN_START_YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , '-' AS BOD_ID
                              -- 2026-05-18 김준규 [패치 2-B]: 통합 INSERT(L4600 부근) 와 ATTRIBUTE1 통일 →
                              --   SCM_SIM_DYN_COLS GROUP BY 시 skeleton + 실데이터 SUM 합쳐짐 (중복 row 방지)
                              -- AS-WAS: , X.ATTRIBUTE1
                              , N'SCP_ANL_SHIPMENT_PLAN_FG'   AS ATTRIBUTE1
                                    , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND M.DIV       ='A'
                AND M.GUBUN     = 'TO'
                AND M.COLUMN_NAME LIKE 'SEMI%'
                AND X.MEASURE   = 'SEMI_SHIP_PLAN'
                AND X.OPERATION_GROUP   = 'A'


            -- =====================================================================================================
            -- 2026-06-02 김준규 추가 [문제②: SEMI skeleton ORG/GAP 복원]
            --   배경: #PSI_GLOBAL_SMALL_AUTO 재생성(L2904) + PLAN-only 재seed(직전 블록, WHERE X.MEASURE='SEMI_SHIP_PLAN')
            --        로 SEMI_SHIP_PLAN_ORG / SEMI_SHIP_GAP_ACC 가 AUTO 에 적재되지 않음.
            --        (#ITEM_ID 에는 release2 복제분이 존재하나 재seed 가 PLAN 만 옮김)
            --   증상: KR01297200(DAP) 처럼 실제 출하 없는 skeleton 은 #ANL 재생성 경로가 없어 RAW 에 ORG/GAP 2행 누락.
            --   조치: 방금 seed 된 SEMI_SHIP_PLAN skeleton 행을 ORG/GAP 2종으로 복제(QTY 등 동일, measure 이름만 변경).
            --        skeleton 은 모두 QTY 0 placeholder 라 단순 복제로 정합성 유지(사용자 확인).
            --   가드: 실제 출하(#ANL_SHIPMENT_PLAN_SEMI 에 TO_SITE 존재)는 이후 L4174 재생성으로 정확한 ORG/GAP 가
            --        부활하므로 제외(중복/오값 방지) — L4139 DELETE 의 ②정밀 보존(L4169)과 동일 기준.
            --   복제 패턴: release2(L2520~2546) 와 동일 (CROSS APPLY VALUES + LEFT JOIN #MEASURE, sort/label fallback).
            -- =====================================================================================================
            INSERT INTO #PSI_GLOBAL_SMALL_AUTO (
                 DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                ,TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
                ,MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
            )
            SELECT  A.DIVISION_ID, A.OPERATION_GROUP, A.CELL_ITEM_ID, A.ITEM_ID, A.TO_SITE, A.PROJECT_CODE
                  , A.TO_BOH_QTY, A.FROM_BOH_QTY, A.INCOTERMS, A.FROM_SITE, A.TRANSPORT_MODE, A.PROD_LINE
                  , V.MEASURE_NEW                                  AS MEASURE
                  , A.YYYYMMDD
                  , A.QTY
                  , ISNULL(M.SORT_ORDER_NO,    V.SORT_DEFAULT)     AS SORT_ORDER_NO
                  , ISNULL(M.COLUMN_LABEL_NAME, V.LABEL_DEFAULT)   AS COLUMN_LABEL_NAME
                  , A.BOD_ID, A.ATTRIBUTE1, A.ATTRIBUTE9
              FROM #PSI_GLOBAL_SMALL_AUTO A WITH(NOLOCK)
             CROSS APPLY (VALUES
                    (N'SEMI_SHIP_PLAN_ORG', 50, N'SEMI SHIP REQ'),
                    (N'SEMI_SHIP_GAP_ACC',  50, N'ACC(Plan-Req)')
                 ) V(MEASURE_NEW, SORT_DEFAULT, LABEL_DEFAULT)
              LEFT JOIN #MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME = V.MEASURE_NEW
             WHERE A.MEASURE     = N'SEMI_SHIP_PLAN'
               AND A.ATTRIBUTE1  = N'SCP_ANL_SHIPMENT_PLAN_SEMI'        -- 진짜 SEMI skeleton 만 (FG 귀속 TO-branch 제외)
               AND NOT EXISTS (SELECT 1 FROM #ANL_SHIPMENT_PLAN_SEMI ANL WITH(NOLOCK)
                                WHERE ANL.TO_SITE = A.TO_SITE)          -- 실제 출하 제외 = skeleton 만 (L4169 동일 기준)
               AND NOT EXISTS (SELECT 1 FROM #PSI_GLOBAL_SMALL_AUTO E WITH(NOLOCK)   -- 이미 있으면 중복 방지(idempotent)
                                WHERE E.MEASURE     = V.MEASURE_NEW
                                  AND E.DIVISION_ID = A.DIVISION_ID
                                  AND E.ITEM_ID     = A.ITEM_ID
                                  AND E.FROM_SITE   = A.FROM_SITE
                                  AND E.TO_SITE     = A.TO_SITE
                                  AND E.YYYYMMDD    = A.YYYYMMDD
                                  AND ISNULL(E.BOD_ID, N'') = ISNULL(A.BOD_ID, N''));

            -- [검증용] 복원 직후 KR01297200/KR00995200 SEMI 3종 카운트 (확정 후 제거)

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : CELL TO   SITE별 (SEMI_WHIN_TOTAL)  / CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN)   ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -------------------------------------------------------------------------------------------------------------------------
            -- MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN
            --                                 ,CELL_CHAR_AVAILABLE,CELL_FORM_PROGRESS,CELL_FORM_HOLD,CELL_FOR_FORM_END,CELL_PROD_FORM_END
            -------------------------------------------------------------------------------------------------------------------------
            IF @v_is_debug = 1 BEGIN IF OBJECT_ID('TEMPDB..##XLS_ITEM_ID') IS NOT NULL  DROP TABLE ##XLS_ITEM_ID;  SELECT *  INTO ##XLS_ITEM_ID FROM #ITEM_ID           END

            INSERT #PSI_GLOBAL_SMALL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID
                                    , X.OPERATION_GROUP
                                    , X.CELL_ITEM_ID
                                    , X.ITEM_ID
                                    , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
                                    , X.TO_BOH_QTY
                                    , X.FROM_BOH_QTY
                                    , '-' AS INCOTERMS
                                    , X.FROM_SITE
                              , '-' AS  TRANSPORT_MODE
                              , '-' AS  PROD_LINE
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.PLAN_START_YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , '-'  AS BOD_ID
                              , X.ATTRIBUTE1
                                    , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND M.DIV       ='A'
                AND M.GUBUN     = 'FROM'
                AND M.COLUMN_NAME LIKE 'CELL%'
                AND ( X.MEASURE   = 'CELL_CHAR_PLAN' )
                AND X.OPERATION_GROUP   = 'A'
                AND M.COLUMN_NAME NOT IN ('CELL_PROD','CELL_PROD_LOAD', 'CELL_PROD_MEMO')       -- 2022.10.19   KSW         Memo measure 추가

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN ,CELL_CHAR_AVAILABLE,CELL_FORM_PROGRESS,CELL_FORM_HOLD,CELL_FOR_FORM_END,CELL_PROD_FORM_END  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#01500--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            IF @v_is_debug = 1 BEGIN SELECT '1304_ITEM_ID' "#ITEM_ID",  * FROM #ITEM_ID;  END

            -------------------------------------------------------------------------------------------------------------------------
            -- MEASURE 추가 :CELL_BOH, CELL_EOH  (KSK, 250414)
            -------------------------------------------------------------------------------------------------------------------------

            INSERT #PSI_GLOBAL_SMALL_AUTO
                SELECT  DISTINCT  X.DIVISION_ID
                                , X.OPERATION_GROUP
                                , X.CELL_ITEM_ID
                                , X.ITEM_ID
                                , '-' AS TO_SITE
                            , '-' AS PROJECT_CODE
                                , X.TO_BOH_QTY
                                , X.FROM_BOH_QTY
                                , '-' AS INCOTERMS
                                , X.FROM_SITE
                            , '-' AS  TRANSPORT_MODE
                            , '-' AS  PROD_LINE
                                , M.COLUMN_NAME AS MEASURE
                                        , X.PLAN_START_YYYYMMDD
                            , 0    AS QTY
                                , M.SORT_ORDER_NO
                                , M.COLUMN_LABEL_NAME
                                , '-'  AS BOD_ID
                            , X.ATTRIBUTE1
                                , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              -- 2026-05-07 막음
              --INNER JOIN  SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
              -- 2026-05-07 김준규: BOM_V 호출 → #BOM_FULL_CACHE 캐시 활용
              INNER JOIN  #BOM_FULL_CACHE AS Y
                ON  Y.DIVISION_ID        =  X.DIVISION_ID
                AND Y.MODEL_ID           = X.ITEM_ID
                AND Y.model_id <> Y.child_item_id
                AND X.FROM_SITE =  (Y.plant_id + '-A')
                AND Y.CELL_TYPE          = 'CA1'
                AND Y.OPERATION_GROUP_ID = 'A'
             WHERE X.DIVISION_ID = @P_DIVISION_ID
              AND X.MEASURE = 'MKT_FCST'
              AND  M.COLUMN_NAME  IN ('CELL_BOH', 'CELL_EOH')
              AND  NOT EXISTS (SELECT 1
                                          FROM #PSI_GLOBAL_SMALL_AUTO S
                                          WHERE S.ITEM_ID = X.ITEM_ID
                                          AND S.FROM_SITE = X.FROM_SITE
                                          AND S.MEASURE = 'CELL_CHAR_PLAN'
                                          ) ;


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE 추가 :CELL_BOH, CELL_EOH   ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -------------------------------------------------------------------------------------------------------------------------
            -- MEASURE 추가 : CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD)
            -------------------------------------------------------------------------------------------------------------------------

               INSERT #PSI_GLOBAL_SMALL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID
                                    , X.OPERATION_GROUP
                                    , X.CELL_ITEM_ID
                                    , X.ITEM_ID
                                    , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
                                , X.TO_BOH_QTY
                                    , X.FROM_BOH_QTY
                                    , '-' AS INCOTERMS
                                    , X.FROM_SITE
                              , '-' AS  TRANSPORT_MODE
                              , X.PROD_LINE
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.PLAN_START_YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , '-'  AS BOD_ID
                              , X.ATTRIBUTE1
                                    , X.ATTRIBUTE9
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND M.DIV       ='A'
                AND M.GUBUN     = 'FROM'
                AND X.OPERATION_GROUP   = 'A'
                AND M.COLUMN_NAME IN ('CELL_PROD','CELL_PROD_LOAD', 'CELL_PROD_MEMO')       -- 2022.10.19   KSW         Memo measure 추가
                AND X.PROD_LINE <> '-'



        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE 추가 :CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD)   ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#01600--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


    -- 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장
                IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_SMALL_AUTO') IS NOT NULL
                        DROP TABLE #tmp_PSI_GLOBAL_SMALL_AUTO

        -- 0 값을 플랜시작일자만 추가한다. - 모든 item 의 모든 measure
                 SELECT  DIVISION_ID
                       ,OPERATION_GROUP
                       ,CELL_ITEM_ID
                       ,ITEM_ID
                       ,TO_SITE
                       ,PROJECT_CODE
                       ,TO_BOH_QTY
                       ,FROM_BOH_QTY
                       ,INCOTERMS
                       ,FROM_SITE
                       ,TRANSPORT_MODE
                       ,PROD_LINE
                       ,MEASURE
                       , Y.YYYYMMDD
                       ,'0' AS QTY
                       ,SORT_ORDER_NO
                       ,COLUMN_LABEL_NAME
                       ,BOD_ID
                       ,ATTRIBUTE1
                       ,ATTRIBUTE9
                 INTO #tmp_PSI_GLOBAL_SMALL_AUTO
                 FROM (SELECT DISTINCT
                                DIVISION_ID
                               ,OPERATION_GROUP
                               ,CELL_ITEM_ID
                               ,ITEM_ID
                               ,TO_SITE
                               ,PROJECT_CODE
                               ,TO_BOH_QTY
                               ,FROM_BOH_QTY
                               ,INCOTERMS
                               ,FROM_SITE
                               ,TRANSPORT_MODE
                               ,PROD_LINE
                               ,MEASURE
                               ,SORT_ORDER_NO
                               ,COLUMN_LABEL_NAME
                               ,BOD_ID
                               ,ATTRIBUTE1
                               ,ATTRIBUTE9
                         FROM #PSI_GLOBAL_SMALL_AUTO WITH (NOLOCK)
                      ) X
                 CROSS APPLY
                 (  -- 364 DAYS
                    SELECT DISTINCT YYYYMMDD
                      FROM (
                           --SELECT YYYYMMDD
                            --FROM #PSI_GLOBAL_SMALL    C WITH(NOLOCK)
                           --UNION ALL
                           SELECT @p_plan_start_yyyymmdd AS YYYYMMDD
                           -- 2026-05-29 김준규 [skeleton 축소: 2일 → 1일]
                           --   AS-WAS 사유: SCP_XLS_PSI_GLOBAL_SMALL 은 데이터 컬럼이 QTY001~QTY364(364개) 뿐.
                           --              horizon > 364일(BP_FLAG='Y')이면 364컬럼 초과분을 담을 수 없어,
                           --              day-364 를 2번째 구간(day 365~727) 적재의 시드로 써서 2-pass 처리.
                           --   TO-BE 사유: SCM_SIM_DYN_COLS 는 QTY 컬럼이 ~800개 → 전체 horizon(@p_to=horizon_end)을
                           --              단일 pass 로 적재 가능. 2-pass 불필요 → day-364 시드 잉여.
                           --              (@v_bp_flag 도 vestigial: 계산만 되고 2-pass 미구동)
                           --   효과: 모든 (key+measure) skeleton row 절반 감소 → DELETE/INSERT/PIVOT 부하 감소.
                           --         @v_n_days(=DATEDIFF(plan_start, horizon_end)) / 8060byte 분할(@v_split_required)에는 영향 없음.
                           --   복구: 아래 UNION ALL 주석 해제 시 원복.
                           --UNION ALL
                           --SELECT CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) AS YYYYMMDD
                          ) X
                  ) Y
                WHERE 0 = 0
                ;

        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INTO #tmp_PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' INTO #tmp_PSI_GLOBAL_SMALL_AUTO  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#01700--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

                -- 0 값(플랜시작일자만)이 추가된 작업용 테이블의 DATA 를 #PSI_GLOBAL_SMALL_AUTO 으로 복제
                DELETE #PSI_GLOBAL_SMALL_AUTO;
                INSERT #PSI_GLOBAL_SMALL_AUTO
                    SELECT * FROM #tmp_PSI_GLOBAL_SMALL_AUTO X WITH (NOLOCK) ;

                IF @v_is_debug  = 1  SELECT '#tmp_PSI_GLOBAL_SMALL_AUTO'  "#tmp_PSI_GLOBAL_SMALL_AUTO",  * FROM #tmp_PSI_GLOBAL_SMALL_AUTO X WITH (NOLOCK) ;

               IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_SMALL_AUTO') IS NOT NULL
                  DROP TABLE #tmp_PSI_GLOBAL_SMALL_AUTO;

               IF @v_is_debug = 1 SELECT 'MKT_FCST' "#ANL_SHIPMENT_PLAN_FG",  * FROM #ANL_SHIPMENT_PLAN_FG WITH (NOLOCK) WHERE MEASURE         = 'MKT_FCST'


----ANL/PLN 5개 MERGE → 1개 통합 INSERT (그룹 A) 통합 시작.
--                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
--                USING (SELECT DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            , '-'               AS PROJECT_CODE         -- 중복방지
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SUM(QTY) AS QTY
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                            ,ATTRIBUTE9
--                        FROM #ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)
--                        WHERE MEASURE         = 'MKT_FCST'
--                        GROUP BY DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                            ,ATTRIBUTE9
--                      ) AS Z
--                ON 0 = 0
--                AND X.OPERATION_GROUP = Z.OPERATION_GROUP
--                AND X.ITEM_ID         = Z.ITEM_ID
--                AND X.FROM_SITE     = Z.FROM_SITE  -- 셀생산지수집관련(KSK, 250402)
--                AND X.TO_SITE         = Z.TO_SITE
--                AND X.PROJECT_CODE    = Z.PROJECT_CODE
--                AND X.INCOTERMS       = Z.INCOTERMS
--                AND X.MEASURE         = Z.MEASURE
--                AND X.YYYYMMDD        = Z.YYYYMMDD
--                WHEN MATCHED  THEN
--                UPDATE
--                   SET X.QTY = Z.QTY
--                WHEN NOT MATCHED  THEN
--                INSERT (
--                         DIVISION_ID
--                        ,OPERATION_GROUP
--                        ,CELL_ITEM_ID
--                        ,ITEM_ID
--                        ,TO_SITE
--                        ,PROJECT_CODE
--                        ,TO_BOH_QTY
--                        ,FROM_BOH_QTY
--                        ,INCOTERMS
--                        ,FROM_SITE
--                        ,TRANSPORT_MODE
--                        ,PROD_LINE
--                        ,MEASURE
--                        ,YYYYMMDD
--                        ,QTY
--                        ,SORT_ORDER_NO
--                        ,COLUMN_LABEL_NAME
--                        ,BOD_ID
--                        ,ATTRIBUTE1
--                        ,ATTRIBUTE9
--                       )
--                VALUES (
--                         Z.DIVISION_ID
--                        ,Z.OPERATION_GROUP
--                        ,Z.CELL_ITEM_ID
--                        ,Z.ITEM_ID
--                        ,Z.TO_SITE
--                        ,Z.PROJECT_CODE
--                        ,Z.TO_BOH_QTY
--                        ,Z.FROM_BOH_QTY
--                        ,Z.INCOTERMS
--                        ,Z.FROM_SITE
--                        ,Z.TRANSPORT_MODE
--                        ,Z.PROD_LINE
--                        ,Z.MEASURE
--                        ,Z.YYYYMMDD
--                        ,Z.QTY
--                        ,Z.SORT_ORDER_NO
--                        ,Z.COLUMN_LABEL_NAME
--                        ,Z.BOD_ID
--                        ,Z.ATTRIBUTE1
--                        ,Z.ATTRIBUTE9
--                       );


--        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
--        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
--        SET @v_description = @v_program_name + ':' + N' MEASURE MKT_FCST  ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;


--                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
--                USING (SELECT DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE           -- 중복방지
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SUM(QTY) AS QTY
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                            ,ATTRIBUTE9
--                        FROM #ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)
--                        WHERE MEASURE         IN ( 'SHIP_PLAN' , 'SHIP_REQ')
--                        GROUP BY DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                            ,ATTRIBUTE9
--                      ) AS Z
--                ON 0 = 0
--                AND X.TO_SITE         = Z.TO_SITE
--                AND X.FROM_SITE       = Z.FROM_SITE
--                AND X.MEASURE         = Z.MEASURE
--                AND X.ITEM_ID         = Z.ITEM_ID
--                AND X.YYYYMMDD        = Z.YYYYMMDD
--                AND X.INCOTERMS       = Z.INCOTERMS
--                AND X.TRANSPORT_MODE  = Z.TRANSPORT_MODE
--                AND X.PROJECT_CODE    = Z.PROJECT_CODE
--                AND X.BOD_ID          = Z.BOD_ID            -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
--                AND X.MEASURE         = 'SHIP_PLAN'
--                WHEN MATCHED  THEN
--                UPDATE
--                   SET X.QTY = Z.QTY
--                WHEN NOT MATCHED  THEN
--                INSERT (
--                         DIVISION_ID
--                        ,OPERATION_GROUP
--                        ,CELL_ITEM_ID
--                        ,ITEM_ID
--                        ,TO_SITE
--                        ,PROJECT_CODE
--                        ,TO_BOH_QTY
--                        ,FROM_BOH_QTY
--                        ,INCOTERMS
--                        ,FROM_SITE
--                        ,TRANSPORT_MODE
--                        ,PROD_LINE
--                        ,MEASURE
--                        ,YYYYMMDD
--                        ,QTY
--                        ,SORT_ORDER_NO
--                        ,COLUMN_LABEL_NAME
--                        ,BOD_ID
--                        ,ATTRIBUTE1
--                        ,ATTRIBUTE9
--                       )
--                VALUES (
--                         Z.DIVISION_ID
--                        ,Z.OPERATION_GROUP
--                        ,Z.CELL_ITEM_ID
--                        ,Z.ITEM_ID
--                        ,Z.TO_SITE
--                        ,Z.PROJECT_CODE
--                        ,Z.TO_BOH_QTY
--                        ,Z.FROM_BOH_QTY
--                        ,Z.INCOTERMS
--                        ,Z.FROM_SITE
--                        ,Z.TRANSPORT_MODE
--                        ,Z.PROD_LINE
--                        ,Z.MEASURE
--                        ,Z.YYYYMMDD
--                        ,Z.QTY
--                        ,Z.SORT_ORDER_NO
--                        ,Z.COLUMN_LABEL_NAME
--                        ,Z.BOD_ID
--                        ,Z.ATTRIBUTE1
--                        ,Z.ATTRIBUTE9
--                       );

--        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
--        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
--        SET @v_description = @v_program_name + ':' + N' FROM #ANL_SHIPMENT_PLAN_FG  ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;


--                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
--                USING (SELECT DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SUM(QTY) AS QTY
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                        ,ATTRIBUTE9
--                        FROM #ANL_PRODUCTION_PLAN WITH (NOLOCK)
--                        GROUP BY DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                        ,ATTRIBUTE9
--                      ) AS Z
--                ON 0 = 0
--                AND X.OPERATION_GROUP = Z.OPERATION_GROUP
--                AND X.ITEM_ID   = Z.ITEM_ID
--                AND X.TO_SITE   = Z.TO_SITE
--                AND X.FROM_SITE = Z.FROM_SITE
--                AND X.MEASURE   = Z.MEASURE
--                AND X.YYYYMMDD  = Z.YYYYMMDD
--                AND X.PROD_LINE = Z.PROD_LINE
--                WHEN MATCHED  THEN
--                UPDATE
--                   SET X.QTY = Z.QTY
--                WHEN NOT MATCHED  THEN
--                INSERT (
--                         DIVISION_ID
--                        ,OPERATION_GROUP
--                        ,CELL_ITEM_ID
--                        ,ITEM_ID
--                        ,TO_SITE
--                        ,PROJECT_CODE
--                        ,TO_BOH_QTY
--                        ,FROM_BOH_QTY
--                        ,INCOTERMS
--                        ,FROM_SITE
--                        ,TRANSPORT_MODE
--                        ,PROD_LINE
--                        ,MEASURE
--                        ,YYYYMMDD
--                        ,QTY
--                        ,SORT_ORDER_NO
--                        ,COLUMN_LABEL_NAME
--                        ,BOD_ID
--                        ,ATTRIBUTE1
--                        ,ATTRIBUTE9
--                       )
--                VALUES (
--                         Z.DIVISION_ID
--                        ,Z.OPERATION_GROUP
--                        ,Z.CELL_ITEM_ID
--                        ,Z.ITEM_ID
--                        ,Z.TO_SITE
--                        ,Z.PROJECT_CODE
--                        ,Z.TO_BOH_QTY
--                        ,Z.FROM_BOH_QTY
--                        ,Z.INCOTERMS
--                        ,Z.FROM_SITE
--                        ,Z.TRANSPORT_MODE
--                        ,Z.PROD_LINE
--                        ,Z.MEASURE
--                        ,Z.YYYYMMDD
--                        ,Z.QTY
--                        ,Z.SORT_ORDER_NO
--                        ,Z.COLUMN_LABEL_NAME
--                        ,Z.BOD_ID
--                        ,Z.ATTRIBUTE1
--                        ,Z.ATTRIBUTE9
--                       );

--        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
--        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
--        SET @v_description = @v_program_name + ':' + N' FROM #ANL_PRODUCTION_PLAN ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;


--                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
--                USING (SELECT DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SUM(QTY) AS QTY
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                            ,ATTRIBUTE9
--                        FROM #ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)
--                        GROUP BY DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                            ,ATTRIBUTE9
--                      ) AS Z
--                ON 0 = 0
--                AND X.OPERATION_GROUP = Z.OPERATION_GROUP
--                AND X.ITEM_ID   = Z.ITEM_ID
--                AND X.TO_SITE   = Z.TO_SITE
--                AND X.FROM_SITE = Z.FROM_SITE
--                AND X.MEASURE   = Z.MEASURE
--                AND X.YYYYMMDD  = Z.YYYYMMDD
--                AND X.TRANSPORT_MODE  = Z.TRANSPORT_MODE
--                AND X.BOD_ID          = Z.BOD_ID
--                WHEN MATCHED  THEN
--                UPDATE
--                   SET X.QTY = Z.QTY
--                WHEN NOT MATCHED  THEN
--                INSERT (
--                         DIVISION_ID
--                        ,OPERATION_GROUP
--                        ,CELL_ITEM_ID
--                        ,ITEM_ID
--                        ,TO_SITE
--                        ,PROJECT_CODE
--                        ,TO_BOH_QTY
--                        ,FROM_BOH_QTY
--                        ,INCOTERMS
--                        ,FROM_SITE
--                        ,TRANSPORT_MODE
--                        ,PROD_LINE
--                        ,MEASURE
--                        ,YYYYMMDD
--                        ,QTY
--                        ,SORT_ORDER_NO
--                        ,COLUMN_LABEL_NAME
--                        ,BOD_ID
--                        ,ATTRIBUTE1
--                        ,ATTRIBUTE9
--                       )
--                VALUES (
--                         Z.DIVISION_ID
--                        ,Z.OPERATION_GROUP
--                        ,Z.CELL_ITEM_ID
--                        ,Z.ITEM_ID
--                        ,Z.TO_SITE
--                        ,Z.PROJECT_CODE
--                        ,Z.TO_BOH_QTY
--                        ,Z.FROM_BOH_QTY
--                        ,Z.INCOTERMS
--                        ,Z.FROM_SITE
--                        ,Z.TRANSPORT_MODE
--                        ,Z.PROD_LINE
--                        ,Z.MEASURE
--                        ,Z.YYYYMMDD
--                        ,Z.QTY
--                        ,Z.SORT_ORDER_NO
--                        ,Z.COLUMN_LABEL_NAME
--                        ,Z.BOD_ID
--                        ,Z.ATTRIBUTE1
--                        ,Z.ATTRIBUTE9
--                       );

--                IF @v_is_debug = 1  SELECT '#SCP_PLN_PRODUCTION_PLAN' AS "#SCP_PLN_PRODUCTION_PLAN",  * FROM #SCP_PLN_PRODUCTION_PLAN

--        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
--        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
--        SET @v_description = @v_program_name + ':' + N' FROM #ANL_SHIPMENT_PLAN_SEMI ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;


--PRINT '--A@X#01800--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

--                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
--                USING (SELECT DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SUM(QTY) AS QTY
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                            ,ATTRIBUTE9
--                        FROM #SCP_PLN_PRODUCTION_PLAN WITH (NOLOCK)
--                        GROUP BY DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                            ,ATTRIBUTE9
--                      ) AS Z
--                ON 0 = 0
--                AND X.OPERATION_GROUP = Z.OPERATION_GROUP
--                AND X.ITEM_ID   = Z.ITEM_ID
--                AND X.TO_SITE   = Z.TO_SITE
--                AND X.FROM_SITE = Z.FROM_SITE
--                AND X.MEASURE   = Z.MEASURE
--                AND X.YYYYMMDD  = Z.YYYYMMDD
--                AND X.PROD_LINE = Z.PROD_LINE
--                WHEN MATCHED  THEN
--                UPDATE
--                   SET X.QTY = Z.QTY
--                WHEN NOT MATCHED  THEN
--                INSERT (
--                         DIVISION_ID
--                        ,OPERATION_GROUP
--                        ,CELL_ITEM_ID
--                        ,ITEM_ID
--                        ,TO_SITE
--                        ,PROJECT_CODE
--                        ,TO_BOH_QTY
--                        ,FROM_BOH_QTY
--                        ,INCOTERMS
--                        ,FROM_SITE
--                        ,TRANSPORT_MODE
--                        ,PROD_LINE
--                        ,MEASURE
--                        ,YYYYMMDD
--                        ,QTY
--                        ,SORT_ORDER_NO
--                        ,COLUMN_LABEL_NAME
--                        ,BOD_ID
--                        ,ATTRIBUTE1
--                        ,ATTRIBUTE9
--                       )
--                VALUES (
--                         Z.DIVISION_ID
--                        ,Z.OPERATION_GROUP
--                        ,Z.CELL_ITEM_ID
--                        ,Z.ITEM_ID
--                        ,Z.TO_SITE
--                        ,Z.PROJECT_CODE
--                        ,Z.TO_BOH_QTY
--                        ,Z.FROM_BOH_QTY
--                        ,Z.INCOTERMS
--                        ,Z.FROM_SITE
--                        ,Z.TRANSPORT_MODE
--                        ,Z.PROD_LINE
--                        ,Z.MEASURE
--                        ,Z.YYYYMMDD
--                        ,Z.QTY
--                        ,Z.SORT_ORDER_NO
--                        ,Z.COLUMN_LABEL_NAME
--                        ,Z.BOD_ID
--                        ,Z.ATTRIBUTE1
--                        ,Z.ATTRIBUTE9
--                       );

--        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
--        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
--        SET @v_description = @v_program_name + ':' + N' FROM #SCP_PLN_PRODUCTION_PLAN ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;

--ANL/PLN 5개 MERGE → 1개 통합 INSERT (그룹 A) 통합 종료.

--ANL/PLN 1개 통합 INSERT 시작.


        ---------------------------------------------------------------------------------
        -- [성능 통합] ANL/PLN 5개 MERGE → 1개 통합 INSERT (그룹 A)
        --   기존: MKT_FCST, SHIP_PLAN/SHIP_REQ, PRODUCTION_PLAN, SHIPMENT_PLAN_SEMI, SCP_PLN_PRODUCTION_PLAN 각 MERGE
        --   변경: UNION ALL + GROUP BY 로 1회 INSERT
        --   효과: 약 5배 빠른 처리 (스캔 5회 → 1회)
        --   소스: #ANL_SHIPMENT_PLAN_FG, #ANL_PRODUCTION_PLAN, #ANL_SHIPMENT_PLAN_SEMI, #SCP_PLN_PRODUCTION_PLAN
        ---------------------------------------------------------------------------------

        -- [DEBUG] ANL/PLN 통합 INSERT 사용 변수

        -- [안전] 기존 MERGE 의 'WHEN MATCHED THEN UPDATE' 시멘틱 보장: 동일 출처 행 사전 삭제
        -- 2026-05-11 김준규 [옵션 X-1]: AS-IS 호환 — 카르테시안 INSERT (L2401/L2452) 가 만든 skeleton 보존
        --   대상 measure: PACK TO SITE별 (ALLOCATION, FCST_RTF_ACC, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL)
        --               + PACK FROM SITE별 (WHIN, SHIP_PLAN_ETA, SHIP_PLAN_PLANT)
        -- 2026-05-18 김준규 [패치 3]: INTRANSIT skeleton 보존 추가
        --   카르테시안 expand(L2708/L2896)가 만든 INTRANSIT/INTRANSIT_ETA/SEMI_INTRANSIT/SEMI_INTRANSIT_ETA skeleton
        --   의 ATTRIBUTE1='SCP_ANL_SHIPMENT_PLAN_FG' 도 이 DELETE 대상이라 사라지던 문제 수정
        DELETE FROM #PSI_GLOBAL_SMALL_AUTO
         WHERE ATTRIBUTE1 IN ('SCP_ANL_SHIPMENT_PLAN_FG', 'SCP_ANL_PRODUCTION_PLAN',
                              'SCP_ANL_SHIPMENT_PLAN_SEMI', 'SCP_PLN_PRODUCTION_PLAN')
           AND MEASURE NOT IN ('ALLOCATION', 'FCST_RTF_ACC', 'TO_SITE_BOH', 'TO_SITE_EOH',
                               'WHIN', 'WHIN_TOTAL', 'SHIP_PLAN_ETA', 'SHIP_PLAN_PLANT',
                               -- 2026-05-18 김준규 [패치 3]: 카르테시안 skeleton 보존
                               'INTRANSIT', 'INTRANSIT_ETA',
                               'SEMI_INTRANSIT', 'SEMI_INTRANSIT_ETA'
                               )
           -- 2026-05-29 김준규 [CELL_EOH 소멸 버그픽스]: 경로1/경로2 로 합성된 CELL measure 보존.
           --   원인: 경로2(CA1) CELL_EOH 가 source(MKT_FCST) 의 ATTRIBUTE1='SCP_ANL_SHIPMENT_PLAN_FG' 를 상속 →
           --         이 DELETE 에 걸려 삭제되나, 재INSERT 는 #ANL_* 원본에서만 복구 → CELL_EOH 영구 소멸.
           --   조치: 합성 CELL measure(CELL% 중 CELL_PROD/LOAD/MEMO/CHAR_PLAN 제외)는 DELETE 대상에서 제외.
           --         (CELL_PROD/CELL_CHAR_PLAN 은 원본 재INSERT 대상이라 그대로 삭제 허용 — 중복 방지)
           AND NOT ( MEASURE LIKE 'CELL[_]%'
                     AND MEASURE NOT IN ('CELL_PROD','CELL_PROD_LOAD','CELL_PROD_MEMO','CELL_CHAR_PLAN') )
           -- 2026-06-01 김준규 [SEMI_SHIP_PLAN skeleton 보존 — ②정밀]: 실제출하(#ANL_SHIPMENT_PLAN_SEMI)에
           --   TO_SITE 가 없는 SEMI_SHIP_PLAN/ORG/GAP_ACC 는 재생성(L4168 UNION) 대상이 아닌 skeleton 이므로 삭제 제외.
           --   (KR01297200/DAP 처럼 실제 출하 없이 #LINE_ASSIGN skeleton 으로만 생성된 행 보존)
           AND NOT ( MEASURE IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG', N'SEMI_SHIP_GAP_ACC')
                     AND NOT EXISTS (SELECT 1 FROM #ANL_SHIPMENT_PLAN_SEMI ANL WITH(NOLOCK)
                                     WHERE ANL.TO_SITE = #PSI_GLOBAL_SMALL_AUTO.TO_SITE) );

        INSERT INTO #PSI_GLOBAL_SMALL_AUTO (
             DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
            ,TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
            ,MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
        )
        SELECT
             DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
            ,SUM(TO_BOH_QTY)   AS TO_BOH_QTY
            ,SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
            ,INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
            ,MEASURE, YYYYMMDD
            ,SUM(QTY) AS QTY
            ,SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
        FROM (
            ----------------------------------------------------------------------
            -- (1) MKT_FCST 만 (PROJECT_CODE = '-' 강제)
            -- 출처: #ANL_SHIPMENT_PLAN_FG / WHERE MEASURE='MKT_FCST'
            ----------------------------------------------------------------------
            SELECT  DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE
                   ,'-' AS PROJECT_CODE                  -- 강제: 중복방지
                   ,TO_BOH_QTY, FROM_BOH_QTY
                   ,INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
                   ,MEASURE, YYYYMMDD, QTY
                   ,SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   ,ATTRIBUTE1, ATTRIBUTE9
              FROM #ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)
             WHERE MEASURE = 'MKT_FCST'

            UNION ALL
            ----------------------------------------------------------------------
            -- (2) SHIP_PLAN, SHIP_REQ
            -- 출처: #ANL_SHIPMENT_PLAN_FG / WHERE MEASURE IN ('SHIP_PLAN','SHIP_REQ')
            ----------------------------------------------------------------------
            SELECT  DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                   ,TO_BOH_QTY, FROM_BOH_QTY
                   ,INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
                   ,MEASURE, YYYYMMDD, QTY
                   ,SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   ,ATTRIBUTE1, ATTRIBUTE9
              FROM #ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)
             WHERE MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')

            UNION ALL
            ----------------------------------------------------------------------
            -- (3) #ANL_PRODUCTION_PLAN 전체
            ----------------------------------------------------------------------
            SELECT  DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                   ,TO_BOH_QTY, FROM_BOH_QTY
                   ,INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
                   ,MEASURE, YYYYMMDD, QTY
                   ,SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   ,ATTRIBUTE1, ATTRIBUTE9
              FROM #ANL_PRODUCTION_PLAN WITH (NOLOCK)

            UNION ALL
            ----------------------------------------------------------------------
            -- (4) #ANL_SHIPMENT_PLAN_SEMI 전체
            ----------------------------------------------------------------------
            SELECT  DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                   ,TO_BOH_QTY, FROM_BOH_QTY
                   ,INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
                   ,MEASURE, YYYYMMDD, QTY
                   ,SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   ,ATTRIBUTE1, ATTRIBUTE9
              FROM #ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)

            UNION ALL
            ----------------------------------------------------------------------
            -- (5) #SCP_PLN_PRODUCTION_PLAN 전체
            ----------------------------------------------------------------------
            SELECT  DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                   ,TO_BOH_QTY, FROM_BOH_QTY
                   ,INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
                   ,MEASURE, YYYYMMDD, QTY
                   ,SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID
                   ,ATTRIBUTE1, ATTRIBUTE9
              FROM #SCP_PLN_PRODUCTION_PLAN WITH (NOLOCK)
        ) AS UNIFIED
        -- 2026-05-13 김준규 [to_date 필터]: TO_YYYYMMDD 이후 일자 데이터는 PIVOT 단계에서 사용되지 않음 → INSERT 단계에서 사전 제거
        WHERE UNIFIED.YYYYMMDD IS NULL          -- 메타데이터 (QTY=0, 일자 없음) 행은 통과
           OR UNIFIED.YYYYMMDD <= @p_to_yyyymmdd
        GROUP BY DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                ,INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
                ,MEASURE, YYYYMMDD
                ,SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9;

        -- [DEBUG] ANL/PLN 통합 INSERT 결과
        IF @v_is_debug = 1 SELECT N'#PSI_GLOBAL_SMALL_AUTO (ANL/PLN 통합 후)' AS "ANL_PLN 통합", *
                             FROM #PSI_GLOBAL_SMALL_AUTO
                            WHERE ATTRIBUTE1 IN ('SCP_ANL_SHIPMENT_PLAN_FG', 'SCP_ANL_PRODUCTION_PLAN',
                                                  'SCP_ANL_SHIPMENT_PLAN_SEMI', 'SCP_PLN_PRODUCTION_PLAN');


IF @v_is_debug = 1
BEGIN
SELECT N'ANL/PLN_1' "ANL/PLN_1", ATTRIBUTE1, COUNT(*) AS cnt, SUM(QTY) AS sum_qty, SUM(FROM_BOH_QTY) AS sum_from_boh
  FROM #PSI_GLOBAL_SMALL_AUTO
 WHERE ATTRIBUTE1 IN ('SCP_ANL_SHIPMENT_PLAN_FG', 'SCP_ANL_SHIPMENT_PLAN_SEMI', 'SCP_PLN_PRODUCTION_PLAN')
 GROUP BY ATTRIBUTE1
 ORDER BY ATTRIBUTE1;

SELECT N'ANL/PLN_2' "ANL/PLN_2", MEASURE, COUNT(*) cnt, SUM(QTY) sum_qty, SUM(FROM_BOH_QTY) sum_from_boh
  FROM #PSI_GLOBAL_SMALL_AUTO
 WHERE ATTRIBUTE1 IN ('SCP_ANL_SHIPMENT_PLAN_FG', 'SCP_ANL_SHIPMENT_PLAN_SEMI')
 GROUP BY MEASURE
 ORDER BY MEASURE;
END;

--ANL/PLN 1개 통합 INSERT 종료.
--ANL/PLN 1개 통합 INSERT 종료.


            -------------------------------------------------------------------------------------------------------------
            -- INTRANSIT 반영
            -------------------------------------------------------------------------------------------------------------
                  SELECT
                        X.DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,X.OPERATION_GROUP
                        ,ITEM_ID
                        ,INCOTERMS
                        ,TO_SITE
                        ,FROM_SITE
                        ,YYYYMMDD
                        ,SUM(QTY) AS QTY
                        , X.ATTRIBUTE1
                        -- TODO : SALES와 PLANT로 분리하여 처리토록
                        , SITE_TYPE
                  INTO #INTRANSIT
                  FROM (
                          SELECT
                                 @P_DIVISION_ID            AS DIVISION_ID
                                ,@p_plan_start_yyyymmdd   AS PLAN_START_YYYYMMDD
                                ,@P_PLAN_TYPE             AS PLAN_TYPE
                                ,@p_seq                   AS SEQ
                                ,C.OPERATION_GROUP
                                ,A.ITEM_ID
                                ,dbo.FN_SCM_SPLIT(A.SITE_ID, 2,'~') AS INCOTERMS
                                ,(SUBSTRING(SITE_ID, 1, DBO.FN_CHARINDEX_REV(SITE_ID, '~', 0)-1))  AS TO_SITE
                                ,(SUBSTRING(LOT_ID, DBO.FN_CHARINDEX_REV(LOT_ID, '::', 0)+2,100)) AS FROM_SITE
                                ,CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) AS YYYYMMDD
                                ,(A.QTY)     AS QTY
                                ,'TH_ENG_STOCK_PLAN_SN'  AS  ATTRIBUTE1
                            FROM DBO.TH_ENG_STOCK_PLAN_SN A WITH (NOLOCK)
                            INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)
                               ON 0 = 0
                               AND A.ITEM_ID      = C.ITEM_ID
                            WHERE 1 = 1
                              AND A.MASTER_ID        = @p_master_id
                              AND A.PLAN_ID          = @p_engine_plan_id
                              AND A.DESCR            = 'INT'
                              --AND LEFT(A.SITE_ID, 6) = (SELECT TOP 1 S.SCM_SITE_ID FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.PLANT_ID = LEFT(A.SITE_ID, 6) AND S.PLANT_ID IS NOT NULL)     -- 2021.11.16 SEMI PACK 출하계획생성오류 수정
                          ) X
                    --2026-05-20 김준규 FROM_SITE 추가
                    INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = X.FROM_SITE
                    LEFT JOIN DBO.SCM_MST_SITE S WITH (NOLOCK)     -- 250105(KSK) PLAN_TYPE 추가
                        ON S.DIVISION_ID = X.DIVISION_ID
                        AND S.SCM_SITE_ID = X.TO_SITE
                    GROUP BY X.DIVISION_ID
                    ,PLAN_START_YYYYMMDD
                    ,PLAN_TYPE
                    ,SEQ
                    ,X.OPERATION_GROUP
                    ,ITEM_ID
                    ,INCOTERMS
                    ,TO_SITE
                    , S.SITE_TYPE
                    ,FROM_SITE
                    --,MEASURE
                    ,YYYYMMDD
                    , X.ATTRIBUTE1
                    ;

                IF @v_is_debug = 1  SELECT '#INTRANSIT' "#INTRANSIT",  * FROM #INTRANSIT


        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
        SET @v_log_message = N'########## INTO #INTRANSIT ##########';
        SET @v_description = @v_program_name + ':' + N' INTO #INTRANSIT ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


-->>INTRANSIT 통합 여기서 부터 막아야 됨 시작
--                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
--                USING (SELECT A.DIVISION_ID
--                            ,A.OPERATION_GROUP
--                            ,''              AS CELL_ITEM_ID
--                            ,A.ITEM_ID
--                            ,A.TO_SITE
--                            ,'-'             AS PROJECT_CODE
--                            ,0               AS TO_BOH_QTY
--                            ,0               AS FROM_BOH_QTY
--                            ,A.INCOTERMS
--                            ,A.FROM_SITE
--                            ,'-'             AS TRANSPORT_MODE
--                            ,'-'             AS PROD_LINE
--                            ,'INTRANSIT_ETA' AS MEASURE
--                            ,A.YYYYMMDD
--                            ,SUM(QTY) AS QTY
--                            ,B.SORT_ORDER_NO
--                            ,B.COLUMN_LABEL_NAME
--                            ,'-'            AS BOD_ID
--                            ,'SCP_ANL_SHIPMENT_PLAN_FG'  AS ATTRIBUTE1
--                        FROM #INTRANSIT A WITH (NOLOCK),
--                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'INTRANSIT_ETA') B
--                       WHERE 1 = 1
--                       AND A.SITE_TYPE = 'SALES'
--                        GROUP BY A.DIVISION_ID
--                            ,A.OPERATION_GROUP
--                            ,A.ITEM_ID
--                            ,A.TO_SITE
--                            ,A.INCOTERMS
--                            ,A.FROM_SITE
--                            ,A.YYYYMMDD
--                            ,B.SORT_ORDER_NO
--                            ,B.COLUMN_LABEL_NAME
--                      ) AS Y
--                ON  X.ITEM_ID    = Y.ITEM_ID
--                AND X.INCOTERMS  = Y.INCOTERMS
--                AND X.TO_SITE    = Y.TO_SITE
--                AND X.FROM_SITE  = Y.FROM_SITE
--                AND X.YYYYMMDD   = Y.YYYYMMDD
--                AND X.MEASURE    = 'INTRANSIT_ETA'
--                WHEN MATCHED  THEN
--                UPDATE
--                   SET X.QTY = ISNULL(Y.QTY,0)
--                WHEN NOT MATCHED  THEN
--                INSERT (
--                         DIVISION_ID
--                        ,OPERATION_GROUP
--                        ,CELL_ITEM_ID
--                        ,ITEM_ID
--                        ,TO_SITE
--                        ,PROJECT_CODE
--                        ,TO_BOH_QTY
--                        ,FROM_BOH_QTY
--                        ,INCOTERMS
--                        ,FROM_SITE
--                        ,TRANSPORT_MODE
--                        ,PROD_LINE
--                        ,MEASURE
--                        ,YYYYMMDD
--                        ,QTY
--                        ,SORT_ORDER_NO
--                        ,COLUMN_LABEL_NAME
--                        ,BOD_ID
--                        ,ATTRIBUTE1
--                       )
--                VALUES (
--                         Y.DIVISION_ID
--                        ,Y.OPERATION_GROUP
--                        ,Y.CELL_ITEM_ID
--                        ,Y.ITEM_ID
--                        ,Y.TO_SITE
--                        ,Y.PROJECT_CODE
--                        ,Y.TO_BOH_QTY
--                        ,Y.FROM_BOH_QTY
--                        ,Y.INCOTERMS
--                        ,Y.FROM_SITE
--                        ,Y.TRANSPORT_MODE
--                        ,Y.PROD_LINE
--                        ,Y.MEASURE
--                        ,Y.YYYYMMDD
--                        ,Y.QTY
--                        ,Y.SORT_ORDER_NO
--                        ,Y.COLUMN_LABEL_NAME
--                        ,Y.BOD_ID
--                        ,Y.ATTRIBUTE1
--                       );

--        -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
--        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
--        SET @v_description = @v_program_name + ':' + N' FROM #INTRANSIT INTRANSIT_ETA ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;

--PRINT '--A@X#01900--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


--                -- 2022.05.17 중복오류 수정
--                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
--                USING (SELECT DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SUM(QTY) AS QTY
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                      FROM (
--                            SELECT A.DIVISION_ID
--                                    ,A.OPERATION_GROUP
--                                    ,''              AS CELL_ITEM_ID
--                                    ,A.ITEM_ID
--                                    ,A.TO_SITE
--                                    ,'-'             AS PROJECT_CODE
--                                    ,0               AS TO_BOH_QTY
--                                    ,0               AS FROM_BOH_QTY
--                                    ,'-'             AS INCOTERMS
--                                    ,A.FROM_SITE
--                                    ,'-'             AS TRANSPORT_MODE
--                                    ,'-'             AS PROD_LINE
--                                    ,'SEMI_INTRANSIT_ETA' AS MEASURE
--                                    ,A.YYYYMMDD
--                                    ,SUM(QTY) AS QTY
--                                    ,B.SORT_ORDER_NO
--                                    ,B.COLUMN_LABEL_NAME
--                                    ,'-'            AS BOD_ID
--                                    ,'SCP_ANL_SHIPMENT_PLAN_SEMI'   AS ATTRIBUTE1
--                                FROM #INTRANSIT A WITH (NOLOCK),
--                                        (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'SEMI_INTRANSIT_ETA') B
--                                WHERE 1 = 1
--                                AND A.SITE_TYPE = 'PLANT'
--                                GROUP BY A.DIVISION_ID
--                                    ,A.OPERATION_GROUP
--                                    ,A.ITEM_ID
--                                    ,A.TO_SITE
--                                    ,A.INCOTERMS
--                                    ,A.FROM_SITE
--                                    ,A.YYYYMMDD
--                                    ,B.SORT_ORDER_NO
--                                    ,B.COLUMN_LABEL_NAME
--                                ) XX
--                            GROUP BY DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,YYYYMMDD
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                      ) AS Y
--                ON  X.ITEM_ID    = Y.ITEM_ID
--                AND X.TO_SITE    = Y.TO_SITE
--                AND X.FROM_SITE  = Y.FROM_SITE
--                AND X.YYYYMMDD   = Y.YYYYMMDD
--                AND X.MEASURE    = 'SEMI_INTRANSIT_ETA'
--                WHEN MATCHED  THEN
--                UPDATE
--                   SET X.QTY = ISNULL(Y.QTY,0)
--                WHEN NOT MATCHED  THEN
--                INSERT (
--                         DIVISION_ID
--                        ,OPERATION_GROUP
--                        ,CELL_ITEM_ID
--                        ,ITEM_ID
--                        ,TO_SITE
--                        ,PROJECT_CODE
--                        ,TO_BOH_QTY
--                        ,FROM_BOH_QTY
--                        ,INCOTERMS
--                        ,FROM_SITE
--                        ,TRANSPORT_MODE
--                        ,PROD_LINE
--                        ,MEASURE
--                        ,YYYYMMDD
--                        ,QTY
--                        ,SORT_ORDER_NO
--                        ,COLUMN_LABEL_NAME
--                        ,BOD_ID
--                        ,ATTRIBUTE1
--                       )
--                VALUES (
--                         Y.DIVISION_ID
--                        ,Y.OPERATION_GROUP
--                        ,Y.CELL_ITEM_ID
--                        ,Y.ITEM_ID
--                        ,Y.TO_SITE
--                        ,Y.PROJECT_CODE
--                        ,Y.TO_BOH_QTY
--                        ,Y.FROM_BOH_QTY
--                        ,Y.INCOTERMS
--                        ,Y.FROM_SITE
--                        ,Y.TRANSPORT_MODE
--                        ,Y.PROD_LINE
--                        ,Y.MEASURE
--                        ,Y.YYYYMMDD
--                        ,Y.QTY
--                        ,Y.SORT_ORDER_NO
--                        ,Y.COLUMN_LABEL_NAME
--                        ,Y.BOD_ID
--                        ,Y.ATTRIBUTE1
--                       );


--        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
--        SET @v_description = @v_program_name + ':' + N' FROM #INTRANSIT SEMI_INTRANSIT_ETA ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;


--                 --UPDATE X
--                 --   SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
--                 --  FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
--                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,TO_SITE,INCOTERMS, SUM(Y.QTY) AS FROM_BOH_QTY
--                 --                FROM #INTRANSIT Y
--                 --               GROUP BY ITEM_ID, FROM_SITE,TO_SITE,INCOTERMS
--                 --            )  Z
--                 --     ON X.ITEM_ID    = Z.ITEM_ID
--                 --    AND X.INCOTERMS  = Z.INCOTERMS
--                 --    AND X.FROM_SITE  = Z.FROM_SITE
--                 --    AND X.TO_SITE    = Z.TO_SITE
--                 --    AND X.MEASURE    = 'INTRANSIT'

--                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
--                USING (SELECT A.DIVISION_ID
--                            ,A.OPERATION_GROUP
--                            ,''              AS CELL_ITEM_ID
--                            ,A.ITEM_ID
--                            ,A.TO_SITE
--                            ,'-'             AS PROJECT_CODE
--                            ,0               AS TO_BOH_QTY
--                            ,SUM(QTY)        AS FROM_BOH_QTY
--                            ,A.INCOTERMS
--                            ,A.FROM_SITE
--                            ,'-'             AS TRANSPORT_MODE
--                            ,'-'             AS PROD_LINE
--                            ,'INTRANSIT'     AS MEASURE
--                            ,0               AS QTY
--                            ,B.SORT_ORDER_NO
--                            ,B.COLUMN_LABEL_NAME
--                            ,'-'            AS BOD_ID
--                            ,'SCP_ANL_SHIPMENT_PLAN_FG'  AS ATTRIBUTE1
--                        FROM #INTRANSIT A WITH (NOLOCK),
--                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'INTRANSIT') B
--                       WHERE 1 = 1
--                        GROUP BY A.DIVISION_ID
--                            ,A.OPERATION_GROUP
--                            ,A.ITEM_ID
--                            ,A.TO_SITE
--                            ,A.INCOTERMS
--                            ,A.FROM_SITE
--                            ,B.SORT_ORDER_NO
--                            ,B.COLUMN_LABEL_NAME
--                      ) AS Y
--                ON  X.ITEM_ID    = Y.ITEM_ID
--                AND X.INCOTERMS  = Y.INCOTERMS
--                AND X.FROM_SITE  = Y.FROM_SITE
--                AND X.TO_SITE    = Y.TO_SITE
--                AND X.MEASURE    = 'INTRANSIT'
--                WHEN MATCHED  THEN
--                UPDATE
--                   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY,0)
--                WHEN NOT MATCHED  THEN
--                INSERT (
--                         DIVISION_ID
--                        ,OPERATION_GROUP
--                        ,CELL_ITEM_ID
--                        ,ITEM_ID
--                        ,TO_SITE
--                        ,PROJECT_CODE
--                        ,TO_BOH_QTY
--                        ,FROM_BOH_QTY
--                        ,INCOTERMS
--                        ,FROM_SITE
--                        ,TRANSPORT_MODE
--                        ,PROD_LINE
--                        ,MEASURE
--                        ,YYYYMMDD
--                        ,QTY
--                        ,SORT_ORDER_NO
--                        ,COLUMN_LABEL_NAME
--                        ,BOD_ID
--                        ,ATTRIBUTE1
--                       )
--                VALUES (
--                         Y.DIVISION_ID
--                        ,Y.OPERATION_GROUP
--                        ,Y.CELL_ITEM_ID
--                        ,Y.ITEM_ID
--                        ,Y.TO_SITE
--                        ,Y.PROJECT_CODE
--                        ,Y.TO_BOH_QTY
--                        ,Y.FROM_BOH_QTY
--                        ,Y.INCOTERMS
--                        ,Y.FROM_SITE
--                        ,Y.TRANSPORT_MODE
--                        ,Y.PROD_LINE
--                        ,Y.MEASURE
--                        ,@p_plan_start_yyyymmdd
--                        ,Y.QTY
--                        ,Y.SORT_ORDER_NO
--                        ,Y.COLUMN_LABEL_NAME
--                        ,Y.BOD_ID
--                        ,Y.ATTRIBUTE1
--                       );

--        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
--        SET @v_description = @v_program_name + ':' + N' FROM #INTRANSIT INTRANSIT ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;


--                 --UPDATE X
--                 --   SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
--                 --  FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
--                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,TO_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
--                 --                FROM #INTRANSIT Y
--                 --               GROUP BY ITEM_ID, FROM_SITE,TO_SITE
--                 --            )  Z
--                 --     ON X.ITEM_ID    = Z.ITEM_ID
--                 --    AND X.FROM_SITE  = Z.FROM_SITE
--                 --    AND X.TO_SITE    = Z.TO_SITE
--                 --    AND X.MEASURE    = 'SEMI_INTRANSIT'
--                -- 중복오류 수정 :: 2022.05.17
--                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
--                USING (SELECT DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,SUM(FROM_BOH_QTY)        AS FROM_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,QTY
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                        FROM (
--                                SELECT A.DIVISION_ID
--                                        ,A.OPERATION_GROUP
--                                        ,''              AS CELL_ITEM_ID
--                                        ,A.ITEM_ID
--                                        ,A.TO_SITE
--                                        ,'-'             AS PROJECT_CODE
--                                        ,0               AS TO_BOH_QTY
--                                        ,SUM(QTY)        AS FROM_BOH_QTY
--                                        ,'-'             AS INCOTERMS
--                                        ,A.FROM_SITE
--                                        ,'-'             AS TRANSPORT_MODE
--                                        ,'-'             AS PROD_LINE
--                                        ,'SEMI_INTRANSIT'     AS MEASURE
--                                        ,0               AS QTY
--                                        ,B.SORT_ORDER_NO
--                                        ,B.COLUMN_LABEL_NAME
--                                        ,'-'            AS BOD_ID
--                                        ,'SCP_ANL_SHIPMENT_PLAN_SEMI'   AS ATTRIBUTE1
--                                    FROM #INTRANSIT A WITH (NOLOCK),
--                                         (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'SEMI_INTRANSIT') B
--                                   WHERE 1 = 1
--                                    GROUP BY A.DIVISION_ID
--                                        ,A.OPERATION_GROUP
--                                        ,A.ITEM_ID
--                                        ,A.TO_SITE
--                                        ,A.INCOTERMS
--                                        ,A.FROM_SITE
--                                        ,B.SORT_ORDER_NO
--                                        ,B.COLUMN_LABEL_NAME
--                            ) XX
--                            GROUP BY DIVISION_ID
--                            ,OPERATION_GROUP
--                            ,CELL_ITEM_ID
--                            ,ITEM_ID
--                            ,TO_SITE
--                            ,PROJECT_CODE
--                            ,TO_BOH_QTY
--                            ,INCOTERMS
--                            ,FROM_SITE
--                            ,TRANSPORT_MODE
--                            ,PROD_LINE
--                            ,MEASURE
--                            ,QTY
--                            ,SORT_ORDER_NO
--                            ,COLUMN_LABEL_NAME
--                            ,BOD_ID
--                            ,ATTRIBUTE1
--                      ) AS Y
--                ON  X.ITEM_ID    = Y.ITEM_ID
--                AND X.INCOTERMS  = Y.INCOTERMS
--                AND X.FROM_SITE  = Y.FROM_SITE
--                AND X.TO_SITE    = Y.TO_SITE
--                AND X.MEASURE    = 'SEMI_INTRANSIT'
--                WHEN MATCHED  THEN
--                UPDATE
--                   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY,0)
--                WHEN NOT MATCHED  THEN
--                INSERT (
--                         DIVISION_ID
--                        ,OPERATION_GROUP
--                        ,CELL_ITEM_ID
--                        ,ITEM_ID
--                        ,TO_SITE
--                        ,PROJECT_CODE
--                        ,TO_BOH_QTY
--                        ,FROM_BOH_QTY
--                        ,INCOTERMS
--                        ,FROM_SITE
--                        ,TRANSPORT_MODE
--                        ,PROD_LINE
--                        ,MEASURE
--                        ,YYYYMMDD
--                        ,QTY
--                        ,SORT_ORDER_NO
--                        ,COLUMN_LABEL_NAME
--                        ,BOD_ID
--                        ,ATTRIBUTE1
--                       )
--                VALUES (
--                         Y.DIVISION_ID
--                        ,Y.OPERATION_GROUP
--                        ,Y.CELL_ITEM_ID
--                        ,Y.ITEM_ID
--                        ,Y.TO_SITE
--                        ,Y.PROJECT_CODE
--                        ,Y.TO_BOH_QTY
--                        ,Y.FROM_BOH_QTY
--                        ,Y.INCOTERMS
--                        ,Y.FROM_SITE
--                        ,Y.TRANSPORT_MODE
--                        ,Y.PROD_LINE
--                        ,Y.MEASURE
--                        ,@p_plan_start_yyyymmdd
--                        ,Y.QTY
--                        ,Y.SORT_ORDER_NO
--                        ,Y.COLUMN_LABEL_NAME
--                        ,Y.BOD_ID
--                        ,Y.ATTRIBUTE1
--                       );

--        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
--        SET @v_description = @v_program_name + ':' + N' FROM #INTRANSIT SEMI_INTRANSIT ';
--        SET @d_event_date = SYSDATETIME();
--        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
----                                ,@p_log_type      = @v_log_type
----                                ,@p_log_count     = @n_log_count
----                                ,@p_log_message   = @v_log_message
----                                ,@p_description   = @v_description
----                                ,@p_event_date    = @d_event_date
----                                ,@P_USER_ID       = @v_batch_user
----                                  ;

--            -------------------------------------------------------------------------------------------------------------
--            -- CELL_FOR_FORM_END
--            -------------------------------------------------------------------------------------------------------------


-->>INTRANSIT 통합 여기서 부터 막아야 됨 종료.

-->> 합친것 추가 시작.


        ---------------------------------------------------------------------------------
        -- [성능 통합] INTRANSIT 4개 MERGE → 1개 통합 INSERT (그룹 B)
        --   기존: INTRANSIT_ETA, SEMI_INTRANSIT_ETA, INTRANSIT, SEMI_INTRANSIT 각각 MERGE
        --   변경: UNION ALL + GROUP BY 로 1회 INSERT
        --   효과: 약 4배 빠른 처리 (테이블 스캔 4회 → 1회)
        --   소스: 모두 #INTRANSIT, JOIN 키만 다름
        ---------------------------------------------------------------------------------

        -- [DEBUG] INTRANSIT 통합 INSERT 사용 변수
        IF @v_is_debug = 1 SELECT CONCAT('INTRANSIT @p_plan_start_yyyymmdd:', @p_plan_start_yyyymmdd) AS "#PSI_GLOBAL_SMALL_AUTO_INTRANSIT 사용변수";

        -- [안전] 기존 MERGE 의 'WHEN MATCHED THEN UPDATE' 시멘틱 보장: 동일 MEASURE 행 사전 삭제
        -- 2026-05-11 김준규 [옵션 X-1]: AS-IS 호환 — 카르테시안 INSERT (L2708/L2896) 가 만든 INTRANSIT/INTRANSIT_ETA skeleton 보존
        --   skeleton 식별: ATTRIBUTE1='SCP_ANL_SHIPMENT_PLAN_FG' (MKT_FCST seed × #MEASURE 카르테시안)
        --   실데이터 INSERT 는 다음 단계에서 별도 행으로 추가됨 (key 다르면 PIVOT 후 별행)
        -- 2026-05-19 김준규 [복구]: 패치 2-B 로 카르테시안 expand 의 ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG' 통일됨.
        --   이 DELETE 는 그 외 ATTRIBUTE1 의 INTRANSIT row 만 정리 → 안전 가드 역할 유지.
        -- 2026-05-19 김준규 [MERGE 회귀]: SEMI 카르테시안 expand (L2913) 의 ATTRIBUTE1='SCP_ANL_SHIPMENT_PLAN_SEMI' 도 보존 필요
        --   SEMI skeleton 보존 안 하면 SEMI_INTRANSIT/SEMI_INTRANSIT_ETA MERGE 가 NOT MATCHED 만 동작 → CELL_ITEM_ID='' 누락 발생
        DELETE FROM #PSI_GLOBAL_SMALL_AUTO
         WHERE MEASURE IN ('INTRANSIT_ETA', 'SEMI_INTRANSIT_ETA', 'INTRANSIT', 'SEMI_INTRANSIT')
           AND ATTRIBUTE1 NOT IN ('SCP_ANL_SHIPMENT_PLAN_FG', 'SCP_ANL_SHIPMENT_PLAN_SEMI');

        -- ============================================================================
        -- 2026-05-19 김준규 [옵션 A]: AS-WAS PR_SCP_XLS_PSI_GLOBAL_SMALL_S MERGE 패턴 회귀
        --   목적: PACK INTRANSIT/INTRANSIT_ETA/SEMI_INTRANSIT/SEMI_INTRANSIT_ETA row 가
        --         SCM_SIM_DYN_COLS 에 적재되도록 (CELL_ITEM_ID 채워진 카르테시안 PACK/SEMI skeleton 보존)
        --   AS-WAS 동작: 카르테시안 skeleton (CELL_ITEM_ID 채워진) 위에 MERGE 가 QTY/FROM_BOH_QTY 만 UPDATE
        --   이전 TO-BE (INSERT GROUP BY): CELL_ITEM_ID='' 인 신규 row 추가 → PACK row 누락 (진단 결과 OPERATION_GROUP='P' row 0건)
        --   주의: L4577 사전 DELETE 의 NOT IN 리스트에 'SCP_ANL_SHIPMENT_PLAN_SEMI' 도 추가 필요 (SEMI skeleton 보존)
        -- ============================================================================

        -- [성능 보조] IX_INTRANSIT_MERGE 인덱스 — 2026-05-19 김준규 [제거됨]
        --   원인: #INTRANSIT.INCOTERMS 가 dbo.FN_SCM_SPLIT() 결과로 NVARCHAR(MAX)/LOB 타입
        --         → "Column 'INCOTERMS' is of a type that is invalid for use as a key column in an index"
        --   영향: #INTRANSIT row 수가 통상 적어서 인덱스 없이도 MERGE JOIN 성능 영향 미미

        -- ============================================================================
        -- 2026-05-19 김준규 [강제 skeleton]: PACK + CELL INTRANSIT skeleton 명시적 생성
        --   배경: 진단A 결과 카르테시안 PACK/SEMI expand 가 INTRANSIT skeleton 을 생성하지 않음
        --        (#MEASURE 마스터의 INTRANSIT 의 ATTRIBUTE2 가 'FROM' 매핑 안 됨 / GUBUN=NULL 환경)
        --   동작: #ITEM_ID 의 SHIP_PLAN seed × (INTRANSIT/INTRANSIT_ETA/SEMI_INTRANSIT/SEMI_INTRANSIT_ETA)
        --        OPERATION_GROUP='P' → INTRANSIT/INTRANSIT_ETA   (ATTRIBUTE1='SCP_ANL_SHIPMENT_PLAN_FG')
        --        OPERATION_GROUP='A' → SEMI_INTRANSIT/SEMI_INTRANSIT_ETA (ATTRIBUTE1='SCP_ANL_SHIPMENT_PLAN_SEMI')
        --   CELL_ITEM_ID 는 #ITEM_ID 의 값 보존 (없으면 후속 L6404 UPDATE 가 BOM_V 로 채움)
        --   NOT EXISTS 가드: 이미 카르테시안 expand 가 만든 skeleton 과 중복 방지
        -- ============================================================================
        INSERT INTO #PSI_GLOBAL_SMALL_AUTO (
            DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE,
            TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE,
            MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
        )
        SELECT  X.DIVISION_ID
               ,X.OPERATION_GROUP
               ,X.CELL_ITEM_ID
               ,X.ITEM_ID
               ,X.TO_SITE
               ,X.PROJECT_CODE
               ,0                                            AS TO_BOH_QTY
               ,0                                            AS FROM_BOH_QTY
               ,X.INCOTERMS
               ,X.FROM_SITE
               ,X.TRANSPORT_MODE
               ,'-'                                          AS PROD_LINE
               ,V.MEASURE_NEW                                AS MEASURE
               ,@p_plan_start_yyyymmdd                       AS YYYYMMDD
               ,0                                            AS QTY
               ,ISNULL(M.SORT_ORDER_NO, V.SORT_DEFAULT)      AS SORT_ORDER_NO
               ,ISNULL(M.COLUMN_LABEL_NAME, V.LABEL_DEFAULT) AS COLUMN_LABEL_NAME
               ,X.BOD_ID
               ,V.ATTR1_NEW                                  AS ATTRIBUTE1
               ,X.ATTRIBUTE9
          FROM #ITEM_ID X WITH(NOLOCK)
         CROSS APPLY (VALUES
               (N'INTRANSIT',          N'P', N'SCP_ANL_SHIPMENT_PLAN_FG',   60,  N'In-Transit'),
               (N'INTRANSIT_ETA',      N'P', N'SCP_ANL_SHIPMENT_PLAN_FG',   70,  N'In-Transit ETA'),
               (N'SEMI_INTRANSIT',     N'A', N'SCP_ANL_SHIPMENT_PLAN_SEMI', 62,  N'Semi In-Transit'),
               (N'SEMI_INTRANSIT_ETA', N'A', N'SCP_ANL_SHIPMENT_PLAN_SEMI', 72,  N'Semi In-Transit ETA')
              ) V(MEASURE_NEW, TARGET_OP_GRP, ATTR1_NEW, SORT_DEFAULT, LABEL_DEFAULT)
          LEFT JOIN #MEASURE M WITH(NOLOCK)
            ON M.COLUMN_NAME = V.MEASURE_NEW
         WHERE X.MEASURE = N'SHIP_PLAN'
           AND X.OPERATION_GROUP = V.TARGET_OP_GRP
           AND NOT EXISTS (
               SELECT 1
                 FROM #PSI_GLOBAL_SMALL_AUTO E WITH(NOLOCK)
                WHERE E.DIVISION_ID     = X.DIVISION_ID
                  AND E.OPERATION_GROUP = X.OPERATION_GROUP
                  -- 2026-06-02 김준규 수정: CELL_ITEM_ID 미완성(채움 UPDATE = L6956~L7031) 이전 구간이므로 직접 등호(=) 대신 NULL/'' 동일 취급으로 안전화
                  --   (원칙: L7031 이전에는 CELL_ITEM_ID 직접 등호 조인 금지 — 상단 UPDATE 블록 주석 참조)
                  AND ISNULL(E.CELL_ITEM_ID, N'') = ISNULL(X.CELL_ITEM_ID, N'')
                  AND E.ITEM_ID         = X.ITEM_ID
                  AND E.FROM_SITE       = X.FROM_SITE
                  AND E.TO_SITE         = X.TO_SITE
                  AND E.INCOTERMS       = X.INCOTERMS
                  AND E.MEASURE         = V.MEASURE_NEW
           );


        -- ----------------------------------------------------------------------
        -- (1) INTRANSIT_ETA  (SITE_TYPE='SALES', QTY 채움)
        -- ----------------------------------------------------------------------
        MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
        USING (SELECT A.DIVISION_ID
                    ,A.OPERATION_GROUP
                    ,''              AS CELL_ITEM_ID
                    ,A.ITEM_ID
                    ,A.TO_SITE
                    ,'-'             AS PROJECT_CODE
                    ,0               AS TO_BOH_QTY
                    ,0               AS FROM_BOH_QTY
                    ,A.INCOTERMS
                    ,A.FROM_SITE
                    ,'-'             AS TRANSPORT_MODE
                    ,'-'             AS PROD_LINE
                    ,'INTRANSIT_ETA' AS MEASURE
                    ,A.YYYYMMDD
                    ,SUM(A.QTY)      AS QTY
                    ,B.SORT_ORDER_NO
                    ,B.COLUMN_LABEL_NAME
                    ,'-'             AS BOD_ID
                    ,'SCP_ANL_SHIPMENT_PLAN_FG'  AS ATTRIBUTE1
                FROM #INTRANSIT A WITH (NOLOCK)
                INNER JOIN (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'INTRANSIT_ETA') B ON 1=1
               WHERE A.SITE_TYPE = 'SALES'
                GROUP BY A.DIVISION_ID
                    ,A.OPERATION_GROUP
                    ,A.ITEM_ID
                    ,A.TO_SITE
                    ,A.INCOTERMS
                    ,A.FROM_SITE
                    ,A.YYYYMMDD
                    ,B.SORT_ORDER_NO
                    ,B.COLUMN_LABEL_NAME
              ) AS Y
        ON  X.ITEM_ID    = Y.ITEM_ID
        AND X.INCOTERMS  = Y.INCOTERMS
        AND X.TO_SITE    = Y.TO_SITE
        AND X.FROM_SITE  = Y.FROM_SITE
        AND X.YYYYMMDD   = Y.YYYYMMDD
        AND X.MEASURE    = 'INTRANSIT_ETA'
        WHEN MATCHED  THEN
        UPDATE SET X.QTY = ISNULL(Y.QTY, 0)
        WHEN NOT MATCHED  THEN
        INSERT (DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
               ,TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
               ,MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1)
        VALUES (Y.DIVISION_ID, Y.OPERATION_GROUP, Y.CELL_ITEM_ID, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE
               ,Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE, Y.TRANSPORT_MODE, Y.PROD_LINE
               ,Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1);

        -- ----------------------------------------------------------------------
        -- (2) SEMI_INTRANSIT_ETA  (SITE_TYPE='PLANT', QTY 채움)
        -- ----------------------------------------------------------------------
        MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
        USING (SELECT A.DIVISION_ID
                    ,A.OPERATION_GROUP
                    ,''              AS CELL_ITEM_ID
                    ,A.ITEM_ID
                    ,A.TO_SITE
                    ,'-'             AS PROJECT_CODE
                    ,0               AS TO_BOH_QTY
                    ,0               AS FROM_BOH_QTY
                    ,'-'             AS INCOTERMS
                    ,A.FROM_SITE
                    ,'-'             AS TRANSPORT_MODE
                    ,'-'             AS PROD_LINE
                    ,'SEMI_INTRANSIT_ETA' AS MEASURE
                    ,A.YYYYMMDD
                    ,SUM(A.QTY)      AS QTY
                    ,B.SORT_ORDER_NO
                    ,B.COLUMN_LABEL_NAME
                    ,'-'             AS BOD_ID
                    ,'SCP_ANL_SHIPMENT_PLAN_SEMI'   AS ATTRIBUTE1
                FROM #INTRANSIT A WITH (NOLOCK)
                INNER JOIN (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'SEMI_INTRANSIT_ETA') B ON 1=1
               WHERE A.SITE_TYPE = 'PLANT'
                GROUP BY A.DIVISION_ID
                    ,A.OPERATION_GROUP
                    ,A.ITEM_ID
                    ,A.TO_SITE
                    ,A.INCOTERMS
                    ,A.FROM_SITE
                    ,A.YYYYMMDD
                    ,B.SORT_ORDER_NO
                    ,B.COLUMN_LABEL_NAME
              ) AS Y
        ON  X.ITEM_ID    = Y.ITEM_ID
        AND X.TO_SITE    = Y.TO_SITE
        AND X.FROM_SITE  = Y.FROM_SITE
        AND X.YYYYMMDD   = Y.YYYYMMDD
        AND X.MEASURE    = 'SEMI_INTRANSIT_ETA'
        WHEN MATCHED  THEN
        UPDATE SET X.QTY = ISNULL(Y.QTY, 0)
        WHEN NOT MATCHED  THEN
        INSERT (DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
               ,TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
               ,MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1)
        VALUES (Y.DIVISION_ID, Y.OPERATION_GROUP, Y.CELL_ITEM_ID, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE
               ,Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE, Y.TRANSPORT_MODE, Y.PROD_LINE
               ,Y.MEASURE, Y.YYYYMMDD, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1);

        -- ----------------------------------------------------------------------
        -- (3) INTRANSIT  (FROM_BOH_QTY 채움, YYYYMMDD = plan_start)
        -- ----------------------------------------------------------------------
        MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
        USING (SELECT A.DIVISION_ID
                    ,A.OPERATION_GROUP
                    ,''              AS CELL_ITEM_ID
                    ,A.ITEM_ID
                    ,A.TO_SITE
                    ,'-'             AS PROJECT_CODE
                    ,0               AS TO_BOH_QTY
                    ,SUM(A.QTY)      AS FROM_BOH_QTY
                    ,A.INCOTERMS
                    ,A.FROM_SITE
                    ,'-'             AS TRANSPORT_MODE
                    ,'-'             AS PROD_LINE
                    ,'INTRANSIT'     AS MEASURE
                    ,0               AS QTY
                    ,B.SORT_ORDER_NO
                    ,B.COLUMN_LABEL_NAME
                    ,'-'             AS BOD_ID
                    ,'SCP_ANL_SHIPMENT_PLAN_FG'  AS ATTRIBUTE1
                FROM #INTRANSIT A WITH (NOLOCK)
                INNER JOIN (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'INTRANSIT') B ON 1=1
               WHERE 1 = 1
                GROUP BY A.DIVISION_ID
                    ,A.OPERATION_GROUP
                    ,A.ITEM_ID
                    ,A.TO_SITE
                    ,A.INCOTERMS
                    ,A.FROM_SITE
                    ,B.SORT_ORDER_NO
                    ,B.COLUMN_LABEL_NAME
              ) AS Y
        ON  X.ITEM_ID    = Y.ITEM_ID
        AND X.INCOTERMS  = Y.INCOTERMS
        AND X.FROM_SITE  = Y.FROM_SITE
        AND X.TO_SITE    = Y.TO_SITE
        AND X.MEASURE    = 'INTRANSIT'
        WHEN MATCHED  THEN
        UPDATE SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY, 0)
        WHEN NOT MATCHED  THEN
        INSERT (DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
               ,TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
               ,MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1)
        VALUES (Y.DIVISION_ID, Y.OPERATION_GROUP, Y.CELL_ITEM_ID, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE
               ,Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE, Y.TRANSPORT_MODE, Y.PROD_LINE
               ,Y.MEASURE, @p_plan_start_yyyymmdd, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1);

        -- ----------------------------------------------------------------------
        -- (4) SEMI_INTRANSIT  (FROM_BOH_QTY 채움, INCOTERMS='-')
        -- ----------------------------------------------------------------------
        MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
        USING (SELECT A.DIVISION_ID
                    ,A.OPERATION_GROUP
                    ,''              AS CELL_ITEM_ID
                    ,A.ITEM_ID
                    ,A.TO_SITE
                    ,'-'             AS PROJECT_CODE
                    ,0               AS TO_BOH_QTY
                    ,SUM(A.QTY)      AS FROM_BOH_QTY
                    ,'-'             AS INCOTERMS
                    ,A.FROM_SITE
                    ,'-'             AS TRANSPORT_MODE
                    ,'-'             AS PROD_LINE
                    ,'SEMI_INTRANSIT' AS MEASURE
                    ,0               AS QTY
                    ,B.SORT_ORDER_NO
                    ,B.COLUMN_LABEL_NAME
                    ,'-'             AS BOD_ID
                    ,'SCP_ANL_SHIPMENT_PLAN_SEMI'   AS ATTRIBUTE1
                FROM #INTRANSIT A WITH (NOLOCK)
                INNER JOIN (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'SEMI_INTRANSIT') B ON 1=1
               WHERE 1 = 1
                GROUP BY A.DIVISION_ID
                    ,A.OPERATION_GROUP
                    ,A.ITEM_ID
                    ,A.TO_SITE
                    ,A.INCOTERMS
                    ,A.FROM_SITE
                    ,B.SORT_ORDER_NO
                    ,B.COLUMN_LABEL_NAME
              ) AS Y
        ON  X.ITEM_ID    = Y.ITEM_ID
        AND X.FROM_SITE  = Y.FROM_SITE
        AND X.TO_SITE    = Y.TO_SITE
        AND X.MEASURE    = 'SEMI_INTRANSIT'
        WHEN MATCHED  THEN
        UPDATE SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY, 0)
        WHEN NOT MATCHED  THEN
        INSERT (DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
               ,TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
               ,MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1)
        VALUES (Y.DIVISION_ID, Y.OPERATION_GROUP, Y.CELL_ITEM_ID, Y.ITEM_ID, Y.TO_SITE, Y.PROJECT_CODE
               ,Y.TO_BOH_QTY, Y.FROM_BOH_QTY, Y.INCOTERMS, Y.FROM_SITE, Y.TRANSPORT_MODE, Y.PROD_LINE
               ,Y.MEASURE, @p_plan_start_yyyymmdd, Y.QTY, Y.SORT_ORDER_NO, Y.COLUMN_LABEL_NAME, Y.BOD_ID, Y.ATTRIBUTE1);


        -- [DEBUG] INTRANSIT 통합 INSERT 결과
        IF @v_is_debug = 1 SELECT N'#PSI_GLOBAL_SMALL_AUTO (INTRANSIT 통합 후)' AS "INTRANSIT 통합", *
                             FROM #PSI_GLOBAL_SMALL_AUTO
                            WHERE MEASURE IN ('INTRANSIT_ETA', 'SEMI_INTRANSIT_ETA', 'INTRANSIT', 'SEMI_INTRANSIT');


-->> 합친것 추가 종료.

-- 2026-05-15 김준규: 진단용 SELECT 를 IF @v_is_debug = 1 으로 감싸기
IF @v_is_debug = 1
SELECT N'intransit' "intransit", MEASURE, COUNT(*) AS cnt, SUM(QTY) AS sum_qty, SUM(FROM_BOH_QTY) AS sum_from_boh
  FROM #PSI_GLOBAL_SMALL_AUTO
 WHERE MEASURE IN ('INTRANSIT_ETA', 'SEMI_INTRANSIT_ETA', 'INTRANSIT', 'SEMI_INTRANSIT')
 GROUP BY MEASURE
 ORDER BY MEASURE;

-- 적용 후 동일 결과여야 함 (행 수, QTY 합계, FROM_BOH_QTY 합계 일치)


            IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN') IS NOT NULL
                    DROP TABLE #PLN_TH_ENG_STOCK_PLAN

                -- 2026-05-07 김준규 신규: SCP_PLN_TH_ENG_STOCK_PLAN 이 SP 내 두 곳에서 호출됨(line 4331, 4569).
                -- 한 번만 호출 + #FILTER_ITEM_BOTH 사전 필터로 row 수 감소 → 두 INSERT 모두 캐시 활용.
                IF OBJECT_ID('tempdb..#SPN_CACHE') IS NOT NULL DROP TABLE #SPN_CACHE;
                SELECT A.MASTER_ID, A.SITE_ID, A.ITEM_ID, A.RECEIVING_DTTM, A.QTY, A.DESCR, A.INSP_TYPE
                  INTO #SPN_CACHE
                  FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)
                 --2026-05-20 김준규 #FILTER_PLANT 추가
                 INNER JOIN #FILTER_PLANT     FP WITH(NOLOCK) ON FP.PLANT_ID  = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
                 INNER JOIN #FILTER_ITEM_BOTH F ON A.ITEM_ID = F.ITEM_ID
                 WHERE A.MASTER_ID = @p_master_id
                   AND A.PLAN_ID   = @p_engine_plan_id
                OPTION (RECOMPILE);

                CREATE NONCLUSTERED INDEX IX_SPN_ITEM ON #SPN_CACHE(ITEM_ID, INSP_TYPE);

                IF @v_is_debug = 1 SELECT '#SPN_CACHE' AS "#SPN_CACHE", COUNT(*) AS cnt FROM #SPN_CACHE;

              -- 2026-05-07 김준규 변경: 뷰 직접 호출 → #SPN_CACHE 캐시 사용
              SELECT SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
                      ,A.ITEM_ID
                      ,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
                      ,SUM(ISNULL(A.QTY,0))   AS QTY
                      ,A.DESCR
                INTO #PLN_TH_ENG_STOCK_PLAN
              -- 2026-05-07 김준규 변경 시작: 뷰 직접 호출 → #SPN_CACHE 캐시 사용
                FROM #SPN_CACHE A
              -- 2026-05-07 김준규 변경 시작: 뷰 직접 호출 → #SPN_CACHE 캐시 사용
              -- 2026-05-07 김준규 막음 변경 시작
              --  FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)
              --   WHERE 1 = 1
              --    AND A.MASTER_ID   = @p_master_id
              --    AND A.PLAN_ID     = @p_engine_plan_id
--            --      AND A.LOT_ID LIKE 'FOR%'
              -- 2026-05-07 김준규 막음 변경 종료
                GROUP BY
                       SUBSTRING(A.MASTER_ID,1,2)
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
                      ,A.ITEM_ID
                      , CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)
                      , DESCR

        SET @v_log_message = N'########## INTO #PLN_TH_ENG_STOCK_PLAN ##########';
        SET @v_description = @v_program_name + ':' + N' FROM SCP_PLN_TH_ENG_STOCK_PLAN ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'A'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,0               AS FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'CELL_FOR_FORM_END' AS MEASURE
                            ,A.YYYYMMDD
                            ,ISNULL(A.QTY,0) AS QTY
                            ,B.SORT_ORDER_NO
                            ,B.COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                            ,''        AS ATTRIBUTE1            -- 중복방지
                            ,''        AS ATTRIBUTE9            -- 중복방지
                        FROM (SELECT ITEM_ID, FROM_SITE, YYYYMMDD, SUM(Y.QTY) AS QTY
                                FROM #PLN_TH_ENG_STOCK_PLAN Y WITH (NOLOCK)
                               WHERE DESCR LIKE 'FOR%'
                               GROUP BY ITEM_ID,FROM_SITE,YYYYMMDD
                             ) A,
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FOR_FORM_END') B
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'CELL_FOR_FORM_END'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.QTY = ISNULL(Y.QTY,0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                        ,ATTRIBUTE1
                        ,ATTRIBUTE9
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,Y.YYYYMMDD
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                        ,Y.ATTRIBUTE1
                        ,Y.ATTRIBUTE9
                       );

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #PLN_TH_ENG_STOCK_PLAN ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


                UPDATE #PSI_GLOBAL_SMALL_AUTO
                   SET ATTRIBUTE1 = '',
                       ATTRIBUTE9 = ''
                 WHERE MEASURE    = 'CELL_FOR_FORM_END'
                   ;

        SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' #PSI_GLOBAL_SMALL_AUTO  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'A'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,A.FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'CELL_FORM_PROGRESS' AS MEASURE
                            ,0               AS QTY
                            ,B.SORT_ORDER_NO
                            ,B.COLUMN_LABEL_NAME
                            ,'-'             AS BOD_ID
                        FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='FOR'
--                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd
                                GROUP BY ITEM_ID, FROM_SITE
                             ) A,
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_PROGRESS') B
                      ) AS Y
                ON   X.DIVISION_ID = Y.DIVISION_ID
                AND X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.MEASURE    = 'CELL_FORM_PROGRESS'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY,0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,@p_plan_start_yyyymmdd
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                       );

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' CELL_FORM_PROGRESS  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#02000--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            -------------------------------------------------------------------------------------------------------------
            -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가 - start
            -------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_INSP') IS NOT NULL
                    DROP TABLE #PLN_TH_ENG_STOCK_PLAN_INSP

              SELECT SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
                      ,A.ITEM_ID
                      ,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
                      ,SUM(ISNULL(A.QTY,0))   AS QTY
                      ,A.DESCR
                      ,A.INSP_TYPE
                INTO #PLN_TH_ENG_STOCK_PLAN_INSP
              -- 2026-05-07 김준규 변경 시작: 뷰 직접 호출 → #SPN_CACHE 캐시 사용
                FROM #SPN_CACHE A
              -- 2026-05-07 김준규 변경 종료: 뷰 직접 호출 → #SPN_CACHE 캐시 사용
              -- 2026-05-07 김준규 막음 시작
              --  FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)
              --   WHERE 1 = 1
              --    AND A.MASTER_ID   = @p_master_id
              --    AND A.PLAN_ID     = @p_engine_plan_id
              -- 2026-05-07 김준규 막음 종료
                GROUP BY
                       SUBSTRING(A.MASTER_ID,1,2)
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
                      ,A.ITEM_ID
                      , CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)
                      ,A.DESCR
                      , INSP_TYPE

PRINT '--A@X#02010--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


        SET @v_log_message = N'########## INTO #PLN_TH_ENG_STOCK_PLAN_INSP ##########';
        SET @v_description = @v_program_name + ':' + N' #PLN_TH_ENG_STOCK_PLAN_INSP  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

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

                -- 2026-05-06 김준규 변경: 상관 서브쿼리 2개를 사전 집계 CTE로 분리 (PSI_GLOBAL_SMALL_AUTO 풀스캔 N회 → 2회로 축소)
                ;WITH PROD_ATTR9 AS (
                    -- 행마다 반복되던 서브쿼리(line 4515)를 1회 집계로 대체
                    SELECT ITEM_ID, MAX(ATTRIBUTE9) AS ATTRIBUTE9
                      FROM #PSI_GLOBAL_SMALL_AUTO WITH (NOLOCK)
                     WHERE MEASURE IN ('PACK_PROD','CELL_PROD')
                       AND ATTRIBUTE9 IS NOT NULL
                     GROUP BY ITEM_ID
                ),
                PACK_PROD_ITEM AS (
                    -- 행마다 반복되던 서브쿼리(line 4520)를 1회 집계로 대체 (CELL 제외 = OPERATION_GROUP='P')
                    SELECT DISTINCT ITEM_ID
                      FROM #PSI_GLOBAL_SMALL_AUTO WITH (NOLOCK)
                     WHERE MEASURE = 'PACK_PROD'
                       AND OPERATION_GROUP = 'P'
                )
                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'P'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,0               AS FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'PACK_BOH_HOLD' AS MEASURE
                            ,A.YYYYMMDD
                            ,ISNULL(A.QTY,0) AS QTY
                            ,B.SORT_ORDER_NO
                            ,B.COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                            ,'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1        --  중복방지
                            ,ISNULL(PA.ATTRIBUTE9, '') AS ATTRIBUTE9
                        FROM (SELECT Y.ITEM_ID, Y.FROM_SITE, Y.YYYYMMDD, SUM(Y.QTY) AS QTY
                                FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
                                INNER JOIN PACK_PROD_ITEM PI ON PI.ITEM_ID = Y.ITEM_ID   -- CELL 제외 사전필터
                               WHERE (Y.INSP_TYPE = 'INSP_HOLD' OR Y.DESCR LIKE '%HOLD')
                                 AND NOT Y.INSP_TYPE = 'INSP_PRE'
                               GROUP BY Y.ITEM_ID, Y.FROM_SITE, Y.YYYYMMDD
                             ) A
                             LEFT JOIN PROD_ATTR9 PA ON PA.ITEM_ID = A.ITEM_ID
                             CROSS JOIN (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_BOH_HOLD') B
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'PACK_BOH_HOLD'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.QTY = ISNULL(Y.QTY,0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                        ,ATTRIBUTE1
                        ,ATTRIBUTE9
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,Y.YYYYMMDD
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                        ,Y.ATTRIBUTE1
                        ,Y.ATTRIBUTE9
                       );

PRINT '--A@X#02020--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #PLN_TH_ENG_STOCK_PLAN_INSP PACK_BOH_HOLD  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


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

                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'P'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,0               AS FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'PACK_BOH_EXP_INSP_DATE' AS MEASURE
                            ,A.YYYYMMDD
                            ,ISNULL(A.QTY,0) AS QTY
                            ,B.SORT_ORDER_NO
                            ,B.COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                        FROM (SELECT ITEM_ID, FROM_SITE, YYYYMMDD, SUM(Y.QTY) AS QTY
                                FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
                               WHERE INSP_TYPE = 'INSP_PRE'
                               GROUP BY ITEM_ID, FROM_SITE,YYYYMMDD
                             ) A,
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_BOH_EXP_INSP_DATE') B
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'PACK_BOH_EXP_INSP_DATE'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.QTY = ISNULL(Y.QTY,0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,Y.YYYYMMDD
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                       );

PRINT '--A@X#02030--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #PLN_TH_ENG_STOCK_PLAN_INSP PACK_BOH_EXP_INSP_DATE  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -- Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정 - start
                UPDATE #PSI_GLOBAL_SMALL_AUTO
                   SET ATTRIBUTE1 = '',
                       ATTRIBUTE9 = ''
                 WHERE MEASURE    = 'PACK_BOH_EXP_INSP_DATE'

PRINT '--A@X#02034--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' PACK_BOH_EXP_INSP_DATE  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

                   ;
            -- Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정 - end

            -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가 - end

            -------------------------------------------------------------------------------------------------------------
            -- CELL_FORM_HOLD_UNDER 추가
            -- [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS)
            -------------------------------------------------------------------------------------------------------------

        IF @v_is_debug = 1 SELECT CONCAT('@p_cutoff_date:', @p_cutoff_date,'@P_DIVISION_ID:', @P_DIVISION_ID) AS "#STOCK_AGING_CACHE 사용변수";

            -- ============================================================================
            -- 2026-05-22 김준규 변경: SCM_DNM_STOCK_AGING_V 호출 → SP 내 inline 펼치기
            --   기존 view 의 무거운 부분 제거:
            --     (1) FN_GET_SCP_EXC_ITEM_ASSY_MAP(null) → (@P_DIVISION_ID) + 사전 캐시 1회 호출
            --         mTVF + 테이블변수 + 재귀CTE 로 매우 무거움 (14초 병목의 핵심)
            --     (2) FN_GET_SCM_SITE_ID_PLANT(sa.PLANT_ID, 'A') → SCM_MST_SITE INNER JOIN 펼치기
            --         (row 별 scalar UDF 호출 제거 → set-based 처리)
            --     (3) ESS 가상 line (UNION ALL Part 2) 제외
            --         사업부 40 무관 확인 (FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP() = NULL)
            --     (4) view 의 cutoff_date = (raw - 1) → sa.cutoff_date = (@p_cutoff_date + 1) 로 sargable
            --   유지:
            --     (a) scp_mst_final_item LEFT JOIN (packer_plan_item_id 692건 존재)
            --     (b) FCS 예외공정 lookup (E20251028-000588)
            -- ============================================================================

            -- [Step 1] EXC_ASSY 캐시 (division 한정, 함수 1회만 호출)
            IF OBJECT_ID('tempdb..#EXC_ASSY_CACHE') IS NOT NULL DROP TABLE #EXC_ASSY_CACHE;
            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SCP_EXC_ITEM_ID, CELL_ASSY_ITEM_ID
              INTO #EXC_ASSY_CACHE
              FROM dbo.FN_GET_SCP_EXC_ITEM_ASSY_MAP(@P_DIVISION_ID);

            CREATE NONCLUSTERED INDEX IX_EXC_ASSY
                ON #EXC_ASSY_CACHE (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SCP_EXC_ITEM_ID);

            IF @v_is_debug = 1 SELECT '#EXC_ASSY_CACHE' AS "#EXC_ASSY_CACHE", COUNT(*) AS cnt FROM #EXC_ASSY_CACHE;

            -- [Step 2] FCS 예외공정 lookup (E20251028-000588)
            IF OBJECT_ID('tempdb..#FCS_EXC_OP') IS NOT NULL DROP TABLE #FCS_EXC_OP;
            SELECT DISTINCT SEGMENT1 AS OPERATION_ID
              INTO #FCS_EXC_OP
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
             WHERE LOOKUP_TYPE = 'FCS_INVENTORY_EXCEPTION_OPERATION'
               AND VALID_YN    = 'Y';

            -- [Step 3] cutoff_date sargable 변환: view 의 출력 cutoff = raw - 1 일
            --          → WHERE 매칭 시 sa.cutoff_date = (@p_cutoff_date 변수 + 1일)
            DECLARE @v_raw_cutoff_date DATETIME = DATEADD(DAY, 1, CONVERT(DATE, @p_cutoff_date));

            -- [Step 4] STOCK_AGING_CACHE 생성 (View 로직 inline)
            --   컬럼 매핑 (view 출력 → inline):
            --     SCM_SITE_ID     : CASE WHEN FCS 예외공정 IS NULL THEN S.SCM_SITE_ID ELSE NULL END
            --     ITEM_ID         : FN_SCM_SYS_NVL(fi.packer_plan_item_id, ISNULL(EA.CELL_ASSY_ITEM_ID, RTRIM(LTRIM(sa.item_id))))
            --     QTY             : sa.qty
            --     AVAILABLE_DATE  : MAX(aging_available_date, unhold_exp_date) — view 와 동일
            --     UNHOLD_EXP_DATE : sa.unhold_exp_date
            IF OBJECT_ID('tempdb..#STOCK_AGING_CACHE') IS NOT NULL DROP TABLE #STOCK_AGING_CACHE;

            SELECT
                 CAST(
                    CASE WHEN FCS_EXC.OPERATION_ID IS NULL THEN S.SCM_SITE_ID
                         ELSE NULL
                    END AS NVARCHAR(50)
                 ) AS SCM_SITE_ID
                ,CAST(
                    dbo.FN_SCM_SYS_NVL(fi.packer_plan_item_id,
                                       RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID, sa.item_id))))
                    AS NVARCHAR(50)
                 ) AS ITEM_ID
                ,sa.qty AS QTY
                ,CASE WHEN ISNULL(sa.aging_available_date, '1999-01-01') >= ISNULL(sa.unhold_exp_date, '1999-01-01')
                      THEN sa.aging_available_date
                      ELSE sa.unhold_exp_date
                 END AS AVAILABLE_DATE
                ,sa.unhold_exp_date AS UNHOLD_EXP_DATE
              INTO #STOCK_AGING_CACHE
              FROM SCM_DNM_STOCK_AGING_V_SN sa WITH(NOLOCK)
              -- (1) FN_GET_SCM_SITE_ID_PLANT(sa.PLANT_ID, 'A') 펼치기
              INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                ON  S.PLANT_ID        = sa.PLANT_ID
                AND S.OPERATION_GROUP = 'A'
                AND S.SITE_TYPE       = 'PLANT'
                AND S.VALID_YN        = 'Y'
              -- (2) SP-level 사전 필터 (perf 패치 B 유지)
              INNER JOIN #FILTER_PLANT FP WITH(NOLOCK)
                ON FP.PLANT_ID = S.SCM_SITE_ID
              -- (3) EXC_ASSY 캐시 (LEFT JOIN: 해당 없으면 NULL)
              LEFT JOIN #EXC_ASSY_CACHE EA
                ON  sa.COMPANY_ID  = EA.COMPANY_ID
                AND sa.DIVISION_ID = EA.DIVISION_ID
                AND sa.SITE_ID     = EA.SITE_ID
                AND sa.PLANT_ID    = EA.PLANT_ID
                AND RTRIM(LTRIM(sa.ITEM_ID)) = EA.SCP_EXC_ITEM_ID
              -- (4) packer_plan_item_id 보강 (692건 존재)
              LEFT JOIN scp_mst_final_item fi WITH(NOLOCK)
                ON  sa.DIVISION_ID = fi.DIVISION_ID
                AND RTRIM(LTRIM(ISNULL(EA.CELL_ASSY_ITEM_ID, sa.item_id))) = fi.item_id
              -- (5) FCS 예외공정 (E20251028-000588)
              LEFT JOIN #FCS_EXC_OP FCS_EXC
                ON sa.OPERATION_ID = FCS_EXC.OPERATION_ID
             WHERE sa.DIVISION_ID = @P_DIVISION_ID
               AND sa.cutoff_date = @v_raw_cutoff_date              -- sargable
               AND ISNULL(sa.wiphold_yn, 'N') = 'Y'
            OPTION (RECOMPILE, MAXDOP 8);

PRINT '--A@X#02040--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            CREATE NONCLUSTERED INDEX IX_SAC_ITEM ON #STOCK_AGING_CACHE(ITEM_ID, SCM_SITE_ID);

            IF @v_is_debug = 1 SELECT '#STOCK_AGING_CACHE' AS "#STOCK_AGING_CACHE", COUNT(*) AS cnt FROM #STOCK_AGING_CACHE;

            IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_AGING_V') IS NOT NULL
                    DROP TABLE #tmp_SCM_DNM_STOCK_AGING_V

            SELECT SCM_SITE_ID AS FROM_SITE, ITEM_ID
                  ,(CASE WHEN UNHOLD_EXP_DATE <= @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd ELSE CONVERT(NVARCHAR, UNHOLD_EXP_DATE,112) END ) AS YYYYMMDD
                    ,SUM(QTY) AS QTY
              INTO  #tmp_SCM_DNM_STOCK_AGING_V
            -- 2026-05-07 김준규 변경 시작: 뷰 직접 호출 → #STOCK_AGING_CACHE 캐시 사용
              FROM   #STOCK_AGING_CACHE
            -- 2026-05-07 김준규 변경 종료: 뷰 직접 호출 → #STOCK_AGING_CACHE 캐시 사용
            -- 2026-05-07 김준규 변경 막음 시작
            --  FROM   SCM_DNM_STOCK_AGING_V WITH(NOLOCK)
            --  WHERE  CUTOFF_DATE = @p_cutoff_date
            --  AND    DIVISION_ID = @P_DIVISION_ID -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
            --  AND  WIPHOLD_YN = 'Y'
            --  AND  UNHOLD_EXP_DATE                 IS NOT NULL
            -- 2026-05-07 김준규 변경 막음 종료
             WHERE UNHOLD_EXP_DATE IS NOT NULL    -- 2026-05-22 김준규 추가: AS-WAS L3691 복원 (Warning 제거 + YYYYMMDD=NULL row 방지)
              GROUP BY SCM_SITE_ID,ITEM_ID
                  ,(CASE WHEN UNHOLD_EXP_DATE <= @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd ELSE CONVERT(NVARCHAR, UNHOLD_EXP_DATE,112) END )


PRINT '--A@X#02050--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


        SET @v_log_message = N'########## INTO  #tmp_SCM_DNM_STOCK_AGING_V  ##########';
        SET @v_description = @v_program_name + ':' + N' FROM SCM_DNM_STOCK_AGING_V  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


                 --UPDATE X
                 --   SET X.QTY = Z.QTY
                 --  FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN #tmp_SCM_DNM_STOCK_AGING_V  Z
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'

                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'A'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,0               AS FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'CELL_FORM_HOLD_UNDER' AS MEASURE
                            ,A.YYYYMMDD
                            ,ISNULL(A.QTY,0) AS QTY
                            ,B.SORT_ORDER_NO
                            ,B.COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                            ,'SCP_PLN_PRODUCTION_PLAN'        AS ATTRIBUTE1         -- 중복방지
                            ,'F6000'                          AS ATTRIBUTE9         -- 중복방지
                        FROM #tmp_SCM_DNM_STOCK_AGING_V A  WITH (NOLOCK),
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') B
                       WHERE A.FROM_SITE IS NOT NULL
                         AND A.YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @p_to_yyyymmdd       -- 플랜구간만 유효 :: 2022.08.30   KSW         Cell 재고 개선건
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.QTY = ISNULL(Y.QTY,0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                        ,ATTRIBUTE1
                        ,ATTRIBUTE9
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,Y.YYYYMMDD
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                        ,Y.ATTRIBUTE1
                        ,Y.ATTRIBUTE9
                       );

PRINT '--A@X#02060--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #tmp_SCM_DNM_STOCK_AGING_V  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

                UPDATE #PSI_GLOBAL_SMALL_AUTO
                   SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN',
                       ATTRIBUTE9 = 'F6000'
                 WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER'
                  -- 아래조건 전체를 'CELL_FORM_HOLD_UNDER'메저의   AND 조건으로 설정
                   AND ( ISNULL(ATTRIBUTE1, '') = '' OR ISNULL(ATTRIBUTE9, '') = '' )
                   ;

        SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' CELL_FORM_HOLD_UNDER  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


                  -- BOH


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

                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'A'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,A.FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'CELL_FORM_HOLD_UNDER' AS MEASURE
                            ,0               AS QTY
                            ,B.SORT_ORDER_NO
                            ,B.COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                        --FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS FROM_BOH_QTY
      --                           FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
      --                          WHERE DESCR ='FOR_HOLD'
      --                          GROUP BY FROM_SITE, ITEM_ID
                        --   ) A,
                        FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS FROM_BOH_QTY
                                FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
                               WHERE (Y.YYYYMMDD    < @p_plan_start_yyyymmdd
                                      OR Y.YYYYMMDD > @p_to_yyyymmdd)           -- (플랜범위이전 + 플랜범위초과) 영역 :: 2022.08.30   KSW         Cell 재고 개선건
                                GROUP BY FROM_SITE, ITEM_ID
                             ) A,
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') B
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY,0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,@p_plan_start_yyyymmdd
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                       );

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #tmp_SCM_DNM_STOCK_AGING_V CELL_FORM_HOLD_UNDER  ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#02100--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

-- 2022.08.30   KSW         Cell 재고 개선건 - 주석처리
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
                --USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                --          ,'A'             AS OPERATION_GROUP
                --          ,A.ITEM_ID
                --          ,'-'             AS TO_SITE
                --          ,'-'             AS PROJECT_CODE
                --          ,0               AS TO_BOH_QTY
                --          ,ISNULL(A.QTY,0) AS FROM_BOH_QTY
                --          ,'-'             AS INCOTERMS
                --          ,A.FROM_SITE
                --          ,'-'             AS TRANSPORT_MODE
                --          ,'-'             AS PROD_LINE
                --          ,'CELL_FORM_HOLD_UNDER' AS MEASURE
                --          ,0               AS QTY
                --          ,B.SORT_ORDER_NO
                --          ,B.COLUMN_LABEL_NAME
                --          ,'-'            AS BOD_ID
                --      FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
    --                             FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
    --                            GROUP BY FROM_SITE, ITEM_ID) A,
                --           (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') B
                --     WHERE A.FROM_SITE IS NOT NULL
                --      ) AS Y
                --ON  X.ITEM_ID    = Y.ITEM_ID
    --            AND X.FROM_SITE  = Y.FROM_SITE
    --            AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
                --WHEN MATCHED  THEN
                --UPDATE
                --   SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Y.FROM_BOH_QTY
                --WHEN NOT MATCHED  THEN
                --INSERT (
                --       DIVISION_ID
                --      ,OPERATION_GROUP
                --      ,ITEM_ID
                --      ,TO_SITE
                --      ,PROJECT_CODE
                --      ,TO_BOH_QTY
                --      ,FROM_BOH_QTY
                --      ,INCOTERMS
                --      ,FROM_SITE
                --      ,TRANSPORT_MODE
                --      ,PROD_LINE
                --      ,MEASURE
                --      ,YYYYMMDD
                --      ,QTY
                --      ,SORT_ORDER_NO
                --      ,COLUMN_LABEL_NAME
                --      ,BOD_ID
                --       )
                --VALUES (
                --       Y.DIVISION_ID
                --      ,Y.OPERATION_GROUP
                --      ,Y.ITEM_ID
                --      ,Y.TO_SITE
                --      ,Y.PROJECT_CODE
                --      ,Y.TO_BOH_QTY
                --      ,Y.FROM_BOH_QTY
                --      ,Y.INCOTERMS
                --      ,Y.FROM_SITE
                --      ,Y.TRANSPORT_MODE
                --      ,Y.PROD_LINE
                --      ,Y.MEASURE
                --      ,@p_plan_start_yyyymmdd
                --      ,Y.QTY
                --      ,Y.SORT_ORDER_NO
                --      ,Y.COLUMN_LABEL_NAME
                --      ,Y.BOD_ID
                --       );


            IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_AGING_V2') IS NOT NULL
                    DROP TABLE #tmp_SCM_DNM_STOCK_AGING_V2

                  -- 2026-05-06 김준규 변경: GROUP BY의 CASE/CONVERT 중복평가 제거 (서브쿼리 1회 평가)
                  SELECT FROM_SITE, ITEM_ID, YYYYMMDD, SUM(QTY) AS QTY
                  INTO   #tmp_SCM_DNM_STOCK_AGING_V2
                  FROM (
                        SELECT SCM_SITE_ID AS FROM_SITE
                              ,ITEM_ID
                              ,QTY
                              ,(CASE WHEN AVAILABLE_DATE <= @p_plan_start_yyyymmdd
                                     THEN @p_plan_start_yyyymmdd
                                     ELSE CONVERT(NVARCHAR, AVAILABLE_DATE,112) END) AS YYYYMMDD
                         -- 2026-05-07 김준규 변경 시작: 뷰 직접 호출 → #STOCK_AGING_CACHE 캐시 사용
                          FROM #STOCK_AGING_CACHE
                         -- 2026-05-07 김준규 변경 시작: 뷰 직접 호출 → #STOCK_AGING_CACHE 캐시 사용
                         -- 2026-05-07 김준규 변경 막음 시작
                         -- FROM SCM_DNM_STOCK_AGING_V WITH(NOLOCK)
                         --WHERE CUTOFF_DATE = @p_cutoff_date
                         --  AND DIVISION_ID = @P_DIVISION_ID
                         --  AND WIPHOLD_YN  = 'Y'
                         -- 2026-05-07 김준규 변경 막음 종료
                       ) T
                  GROUP BY FROM_SITE, ITEM_ID, YYYYMMDD

PRINT '--A@X#02110--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        SET @v_log_message = N'########## INTO #tmp_SCM_DNM_STOCK_AGING_V2  ##########';
        SET @v_description = @v_program_name + ':' + N' FROM SCM_DNM_STOCK_AGING_V ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


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

                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'A'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,0               AS FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'CELL_FORM_HOLD_UNDER_AVAILABLE' AS MEASURE
                            ,A.YYYYMMDD
                            ,ISNULL(A.QTY,0) AS QTY
                            ,B.SORT_ORDER_NO
                            ,B.COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                            ,'SCP_PLN_PRODUCTION_PLAN'        AS ATTRIBUTE1         -- 중복방지
                            ,'F6000'                          AS ATTRIBUTE9         -- 중복방지
                        FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #tmp_SCM_DNM_STOCK_AGING_V2 Y  WITH (NOLOCK)
                                WHERE 0 = 0
                                --AND DESCR ='WH_HOLD'
                                GROUP BY ITEM_ID,FROM_SITE,Y.YYYYMMDD
                             )  A,
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER_AVAILABLE') B
                       WHERE A.FROM_SITE IS NOT NULL
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.QTY = ISNULL(Y.QTY,0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                        ,ATTRIBUTE1
                        ,ATTRIBUTE9
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,Y.YYYYMMDD
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                        ,Y.ATTRIBUTE1
                        ,Y.ATTRIBUTE9
                       );

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #tmp_SCM_DNM_STOCK_AGING_V2 CELL_FORM_HOLD_UNDER_AVAILABLE ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


                -- 2026-05-06 김준규 제거: MERGE 시 이미 ATTRIBUTE1/ATTRIBUTE9 INSERT됨 (line 5116~5117) → 후행 UPDATE 불필요
                -- 2026-05-27 김준규 복구: 이전 단계 INSERT 의 NULL ATTRIBUTE1 row 가 정규화되지 않아 PIVOT 분리 발생
                --                       → 후행 UPDATE 활성화하여 ATTRIBUTE1='SCP_PLN_PRODUCTION_PLAN' 통일
                --                       L5968 CELL_FORM_HOLD_UNDER 패턴과 동일 (비대칭 해소)
                UPDATE #PSI_GLOBAL_SMALL_AUTO
                   SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN',
                       ATTRIBUTE9 = 'F6000'
                 WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
                   -- 특정메저에서만 작동하도록 괄호조건 추가(KSK, 2024-05-21)
                   AND ( ISNULL(ATTRIBUTE1, '') = '' OR ISNULL(ATTRIBUTE9, '') = '' )
                   ;
                DECLARE @v_fha_norm INT = @@ROWCOUNT;
PRINT N'--A@X#02080_FHA_NORM-- CELL_FORM_HOLD_UNDER_AVAILABLE ATTRIBUTE1 정규화: ' + CAST(@v_fha_norm AS NVARCHAR(20));

        SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' CELL_FORM_HOLD_UNDER_AVAILABLE ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

PRINT '--A@X#02200--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


            -------------------------------------------------------------------------------------------------------------
            -- CELL_FORM_HOLD_AFTER 추가
            -- [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS)
            -------------------------------------------------------------------------------------------------------------


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

                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'A'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,0               AS FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'CELL_FORM_HOLD_AFTER' AS MEASURE
                            ,A.YYYYMMDD
                            ,ISNULL(A.QTY,0) AS QTY
                            ,B.SORT_ORDER_NO
                            ,B.COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                        FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                 WHERE DESCR ='WH_HOLD'
                                   AND (SELECT OPERATION_GROUP FROM SCM_MST_SITE WITH (NOLOCK) WHERE SCM_SITE_ID = Y.FROM_SITE) = 'A'       -- CELL 생산 사이트 한정
                                   AND Y.YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @p_to_yyyymmdd     -- 플랜구간만 유효 :: 2022.08.30   KSW         Cell 재고 개선건
                                GROUP BY ITEM_ID, FROM_SITE, YYYYMMDD
                             )  A,
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_AFTER') B
                       WHERE A.FROM_SITE IS NOT NULL
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.QTY = ISNULL(Y.QTY,0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,Y.YYYYMMDD
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                       );

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' #PLN_TH_ENG_STOCK_PLAN CELL_FORM_HOLD_AFTER ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


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

                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'A'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,A.FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'CELL_FORM_HOLD_AFTER' AS MEASURE
                            ,0               AS QTY
                            ,B.SORT_ORDER_NO
                            ,B.COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                        FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='WH_HOLD'
                                   AND (SELECT OPERATION_GROUP FROM SCM_MST_SITE WITH (NOLOCK) WHERE SCM_SITE_ID = Y.FROM_SITE) = 'A'       -- CELL 생산 사이트 한정
                                   AND (Y.YYYYMMDD    < @p_plan_start_yyyymmdd
                                       OR Y.YYYYMMDD > @p_to_yyyymmdd)          -- (플랜범위이전 + 플랜범위초과) 영역 :: 2022.08.30   KSW         Cell 재고 개선건
                                GROUP BY ITEM_ID,FROM_SITE
                             )  A,
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_AFTER') B
                       WHERE A.FROM_SITE IS NOT NULL
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY, 0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,@p_plan_start_yyyymmdd
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                       );

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' #PLN_TH_ENG_STOCK_PLAN CELL_FORM_HOLD_AFTER ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


                UPDATE #PSI_GLOBAL_SMALL_AUTO
                   SET ATTRIBUTE1 = '',
                       ATTRIBUTE9 = ''
                 WHERE MEASURE    = 'CELL_FORM_HOLD_AFTER'
                   ;

        SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' CELL_FORM_HOLD_AFTER ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -------------------------------------------------------------------------------------------------------------
            -- * 2022.08.30   KSW           Cell 재고 개선건
            -- *                            2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 -- start
            -------------------------------------------------------------------------------------------------------------
            -- PACK_CELL_BOH 가 존재하는 모델을 참고로 해서 PACK_CELL_BOH_HOLD MEASURE 생성
                INSERT #PSI_GLOBAL_SMALL_AUTO (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                       )
                SELECT   DISTINCT Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,'-'                    AS PROD_LINE
                        ,'PACK_CELL_BOH_HOLD'   AS MEASURE
                        ,Y.YYYYMMDD
                        ,0              AS QTY
                        ,B.SORT_ORDER_NO + 5    AS SORT_ORDER_NO
                        ,'Cell BOH(Hold)'       AS COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                  FROM #PSI_GLOBAL_SMALL_AUTO Y WITH (NOLOCK)
                  INNER JOIN (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_CELL_BOH') B
                     ON 1 = 1
                 WHERE Y.MEASURE    = 'PACK_CELL_BOH'
                   -- 2026-05-13 김준규 [to_date 필터]: source(#PSI_GLOBAL_SMALL_AUTO) 의 미래 행 제외 → GROUP BY/DISTINCT 부하 감소
                   AND (Y.YYYYMMDD IS NULL OR Y.YYYYMMDD <= @p_to_yyyymmdd)
                 ;

        SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO  ##########';
        SET @v_description = @v_program_name + ':' + N' PACK_CELL_BOH 가 존재하는 모델을 참고로 해서 PACK_CELL_BOH_HOLD MEASURE 생성 ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -- Cell BOH(Hold) new measure 에 주차별 표시
                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'P'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,0               AS FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'PACK_CELL_BOH_HOLD'   AS MEASURE
                            ,A.YYYYMMDD
                            ,ISNULL(A.QTY,0)        AS QTY
                            ,B.SORT_ORDER_NO + 5    AS SORT_ORDER_NO
                            ,'Cell BOH(Hold)'       AS COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                        FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                 WHERE DESCR ='WH_HOLD'
                                   AND (SELECT OPERATION_GROUP FROM SCM_MST_SITE WITH (NOLOCK) WHERE SCM_SITE_ID = Y.FROM_SITE) = 'P'       -- PACK 생산 사이트 한정
                                   AND Y.YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @p_to_yyyymmdd     -- 플랜구간만 유효
                                GROUP BY ITEM_ID, FROM_SITE, YYYYMMDD
                             )  A,
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_CELL_BOH') B
                       WHERE A.FROM_SITE IS NOT NULL
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'PACK_CELL_BOH_HOLD'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.QTY = ISNULL(Y.QTY,0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,Y.YYYYMMDD
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                       );

        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #PLN_TH_ENG_STOCK_PLAN PACK_CELL_BOH SET QTY ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -- FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
                MERGE INTO #PSI_GLOBAL_SMALL_AUTO AS X
                USING (SELECT @P_DIVISION_ID AS DIVISION_ID
                            ,'P'             AS OPERATION_GROUP
                            ,A.ITEM_ID
                            ,'-'             AS TO_SITE
                            ,'-'             AS PROJECT_CODE
                            ,0               AS TO_BOH_QTY
                            ,A.FROM_BOH_QTY
                            ,'-'             AS INCOTERMS
                            ,A.FROM_SITE
                            ,'-'             AS TRANSPORT_MODE
                            ,'-'             AS PROD_LINE
                            ,'PACK_CELL_BOH_HOLD'   AS MEASURE
                            ,0                      AS QTY
                            ,B.SORT_ORDER_NO + 5    AS SORT_ORDER_NO
                            ,'Cell BOH(Hold)'       AS COLUMN_LABEL_NAME
                            ,'-'            AS BOD_ID
                        FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='WH_HOLD'
                                  AND (SELECT OPERATION_GROUP FROM SCM_MST_SITE WITH (NOLOCK) WHERE SCM_SITE_ID = Y.FROM_SITE) = 'P'        -- PACK 생산 사이트 한정
                                  AND (Y.YYYYMMDD    < @p_plan_start_yyyymmdd
                                       OR Y.YYYYMMDD > @p_to_yyyymmdd)          -- (플랜범위이전 + 플랜범위초과) 영역
                                GROUP BY ITEM_ID,FROM_SITE
                             )  A,
                             (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_CELL_BOH') B
                       WHERE A.FROM_SITE IS NOT NULL
                      ) AS Y
                ON  X.ITEM_ID    = Y.ITEM_ID
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.MEASURE    = 'PACK_CELL_BOH_HOLD'
                WHEN MATCHED  THEN
                UPDATE
                   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY, 0)
                WHEN NOT MATCHED  THEN
                INSERT (
                         DIVISION_ID
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,PROJECT_CODE
                        ,TO_BOH_QTY
                        ,FROM_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,TRANSPORT_MODE
                        ,PROD_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,SORT_ORDER_NO
                        ,COLUMN_LABEL_NAME
                        ,BOD_ID
                       )
                VALUES (
                         Y.DIVISION_ID
                        ,Y.OPERATION_GROUP
                        ,Y.ITEM_ID
                        ,Y.TO_SITE
                        ,Y.PROJECT_CODE
                        ,Y.TO_BOH_QTY
                        ,Y.FROM_BOH_QTY
                        ,Y.INCOTERMS
                        ,Y.FROM_SITE
                        ,Y.TRANSPORT_MODE
                        ,Y.PROD_LINE
                        ,Y.MEASURE
                        ,@p_plan_start_yyyymmdd
                        ,Y.QTY
                        ,Y.SORT_ORDER_NO
                        ,Y.COLUMN_LABEL_NAME
                        ,Y.BOD_ID
                       );


        SET @v_log_message = N'########## MERGE INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #PLN_TH_ENG_STOCK_PLAN PACK_CELL_BOH SET FROM_BOH_QTY ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


                UPDATE #PSI_GLOBAL_SMALL_AUTO
                   SET ATTRIBUTE1 = '',
                       ATTRIBUTE9 = ''
                 WHERE MEASURE    = 'PACK_CELL_BOH_HOLD'
                   ;

        SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' PACK_CELL_BOH_HOLD ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -- *                            2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 -- end
            -------------------------------------------------------------------------------------------------------------

PRINT '--A@X#02300--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            -------------------------------------------------------------------------------------------------------------
            -- LT 계산용 테이블 생성
            -------------------------------------------------------------------------------------------------------------
             IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL
                    DROP TABLE #SCP_MST_BOD_V;

                SELECT DISTINCT X.DIVISION_ID,X.FROM_SITE,X.TO_SITE,X.INCOTERMS,X.TRANSPORT_MODE,X.LT_TOTAL, X.BOD_ID
                    , CEILING(LT_TOTAL/7.0) AS LT_TOTAL_BY_WEEK
                INTO #SCP_MST_BOD_V
                FROM SCP_MST_BOD_N_V  X WITH (NOLOCK)       -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                WHERE DIVISION_ID =@P_DIVISION_ID

        SET @v_log_message = N'########## INTO #SCP_MST_BOD_V ##########';
        SET @v_description = @v_program_name + ':' + N' FROM SCP_MST_BOD_N_V ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -- =====================================================================================================
            -- 2026-06-02 김준규: [원칙] CELL_ITEM_ID 완성(채움) 시점 정의
            --   - #PSI_GLOBAL_SMALL / #PSI_GLOBAL_SMALL_AUTO 의 모든 INSERT 는 CELL_ITEM_ID 를 '' 로 적재한다.
            --   - CELL_ITEM_ID 의 실제 값은 아래 UPDATE 블록(PACK → FINAL_ITEM CELL_LIST → MEB P5200, 끝 ~L7031)에서 비로소 채워진다.
            --   - 따라서 이 블록보다 '위(L7031 이전)'에서는 CELL_ITEM_ID 가 대부분 '' 이다.
            --
            --   ▶ 규칙: L7031 이전에는 CELL_ITEM_ID 를 직접 등호(=) 로 조인/비교하지 말 것.
            --       (양쪽 다 '' 라 우연히 맞물려 동작하더라도, INSERT 순서/소스 변경 시 한쪽만 채워져 조용히 깨짐)
            --       반드시 다음 둘 중 하나로 안전화한다:
            --         (a) CASE WHEN ISNULL(CELL_ITEM_ID, N'') = N'' THEN ITEM_ID ELSE CELL_ITEM_ID END  -- 빈값이면 ITEM_ID 폴백 (필터/존재판정용)
            --         (b) ISNULL(A.CELL_ITEM_ID, N'') = ISNULL(B.CELL_ITEM_ID, N'')                     -- NULL/'' 동일 취급 (중복판정용)
            --   ▶ 단, OPERATION_GROUP='A'(SEMI) skeleton 은 이 UPDATE 에서 채우지 않으므로 끝까지 '' 로 남는다(의도).
            --       후속 로직은 (CELL_ITEM_ID = ITEM_ID) ? FG : SEMI 로 '' 를 SEMI 취급한다.
            -- =====================================================================================================

            -----------------------------------------------------------------------------------------------------------------
            ---- PACK공장 CELL 재고 UPDATE
            ---------------------------------------------------------------------------------------------------------------
                -- PACK 일경우

                -- 2026-04-27  YMH      E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청  기존 로직 주석처리
                /*
                UPDATE X
                   SET  CELL_ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                               FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                              WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                                AND Y.MODEL_ID           = X.ITEM_ID
                                                AND Y.CELL_TYPE          = 'CP'     -- 활성화코드 분리 대응(Cell Product 조건 추가) :: 2023.06.15 , KSK
                                                AND Y.OPERATION_GROUP_ID = 'A')
                FROM #PSI_GLOBAL_SMALL_AUTO X
                 WHERE OPERATION_GROUP   = 'P';
                 */
                 -- 2026-04-27  YMH      E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청  기존 로직 주석처리 끝

                 -- 2026-04-27  YMH      E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청  신규로직 시작
                 ;
                with model_child_item_id as
                (
                    -- 2026-05-07 막음 시작
                    --SELECT Y.DIVISION_ID , MODEL_ID , MIN(CHILD_ITEM_ID) AS CHILD_ITEM_ID FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH(NOLOCK)
                    --WHERE Y.DIVISION_ID = @p_division_id
                    --AND Y.CELL_TYPE            = 'CP'     -- 활성화코드 분리 대응(CELL PRODUCT 조건 추가) :: 2023.06.15 , KSK
                    --AND Y.OPERATION_GROUP_ID = 'A'
                    --GROUP BY Y.DIVISION_ID , MODEL_ID
                    -- 2026-05-07 막음 종료

                    -- 2026-05-07 시작 김준규: BOM_V 호출 → #BOM_FULL_CACHE 캐시 활용
                    SELECT Y.DIVISION_ID , Y.MODEL_ID , MIN(Y.CHILD_ITEM_ID) AS CHILD_ITEM_ID
                      FROM #BOM_FULL_CACHE Y
                     WHERE Y.DIVISION_ID         = @p_division_id
                       AND Y.CELL_TYPE           = 'CP'
                       AND Y.OPERATION_GROUP_ID  = 'A'
                     GROUP BY Y.DIVISION_ID , Y.MODEL_ID
                    -- 2026-05-07 종료 김준규: BOM_V 호출 → #BOM_FULL_CACHE 캐시 활용

                )
                UPDATE X
                    SET X.CELL_ITEM_ID      = Y.CHILD_ITEM_ID
                FROM #PSI_GLOBAL_SMALL_AUTO X
                    JOIN model_child_item_id AS Y
                    ON Y.DIVISION_ID        = X.DIVISION_ID
                    AND Y.MODEL_ID           = X.ITEM_ID
                WHERE OPERATION_GROUP   = 'P';
                -- 2026-04-27  YMH      E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청  신규로직 끝


        SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

               -- START E20251001-000977 셀-조립모델 매핑로직 변경(250930)
                UPDATE X
                   SET X.CELL_ITEM_ID      = Y.CELL_LIST
                 FROM #PSI_GLOBAL_SMALL_AUTO  X WITH (NOLOCK)
                 INNER JOIN SCP_MST_FINAL_ITEM_V Y WITH (NOLOCK)
                 ON 0 = 0
                 AND X.ITEM_ID          = Y.ITEM_ID
                 AND X.OPERATION_GROUP  = Y.OPERATION_GROUP
                 AND Y.CELL_LIST        IS NOT NULL
                 ;
                -- END 셀-아이템 매핑로직 변경(250930, 변상현 책임)

       SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' JOIN SCP_MST_FINAL_ITEM_V ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


             --  CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가) :: 2023.06.15 , KSK - START
            ------------------------------------------------------------------------------------------------------------------------------
            --  PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update, 2023.06.15, KSK - start
            ------------------------------------------------------------------------------------------------------------------------------
            UPDATE X
               SET X.CELL_ITEM_ID = Z.CELL_ITEM_ID
              FROM #PSI_GLOBAL_SMALL_AUTO X WITH (NOLOCK)
            INNER JOIN (SELECT distinct z.model_id as item_id, z.child_item_id as cell_item_id, z.accumulated_child_qty as cell_qty_pack, y.module_id, y.module_qty_pack
                          FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V z WITH(NOLOCK),
                               ( SELECT x.DIVISION_ID, x.model_id, x.child_item_id as module_id, x.child_qty as module_qty_pack
                                   FROM dbo.scm_mst_bom_sn_V x WITH(NOLOCK) --2021-03-09    SCP 대치 BOM 적용
                                        INNER JOIN dbo.scm_mst_item_sn i WITH(NOLOCK)
                                        ON  x.child_division_id = i.division_id
                                        AND x.child_item_id     = i.item_id
                                        AND I.FLOW_ID = 'P5200'
                                        AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
                                        AND x.child_site_id     = i.site_id
                                        AND i.active_flag       = 'Y'
                                        AND x.DIVISION_ID       = @P_DIVISION_ID -- 20250828 추가 CSR E20250829-001508 속도개선위해 추가
                                  WHERE 1=1
                                ) Y
                         WHERE z.DIVISION_ID        = Y.DIVISION_ID
                            AND z.MODEL_ID           = Y.model_id
                            AND z.CELL_TYPE          = 'CP' -- 2023.06.08 활성화코드 분리 대응(Cell Product 조건 추가)
                            AND z.OPERATION_GROUP_ID = 'A'
                            AND z.DIVISION_ID       = @P_DIVISION_ID -- 20250828 추가 CSR E20250829-0015086 속도개선위해 추가
                       ) Z
                 ON X.ITEM_ID    = Z.MODULE_ID
              WHERE X.ATTRIBUTE9 = 'P5200'

       SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V P5200 ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -------------------------------------------------------------------------------------------------------------
            -- LINE_TOTAL_LOAD_ENGINE (TACT_TIME,WORKING_TIME)
            -------------------------------------------------------------------------------------------------------------
            -------------------------------------------------------------------------------------------------------------
              -- Line Load 율 로직 작업중
              -------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL
                  DROP TABLE #LINE_WORKINGTIME_BY_LOSS;

                -- ============================================================================================
                -- 2026-06-17 김준규 [성능튜닝 C+D] FN_LINE_WORKINGTIME_BY_LOSS 인라인 전개 + UNION ALL + 조인 인덱스
                --   배경 : 함수 결과 141,502건(229라인×620일). 생산계획이 2028.04까지 실재 → 날짜 cap 불가.
                --   원인 : 함수 내부 UNION(중복제거 정렬)이 14만건을 정렬 → 해당 구간 ~28초.
                --   조치 : (C) 함수 본문을 SP 에 인라인 전개하고 UNION → UNION ALL 로 교체.
                --              두 SELECT 는 OSP_YN/ATTRIBUTE1/LINE_ID 조건으로 상호배타 → distinct 불필요(출력 동일).
                --          (D) #LINE_WORKINGTIME_BY_LOSS 에 조인키(DIVISION/OPERATION/SCM_SITE/LINE/YYYYMMDD) 인덱스 부여.
                --   호출 파라미터 매핑 : @p_division_id→@P_DIVISION_ID, from→@p_plan_start_yyyymmdd, to→@p_to_yyyymmdd, line_id→'' (전체).
                --   함수(dbo.FN_LINE_WORKINGTIME_BY_LOSS) 는 공용이므로 수정하지 않음(타 SP 영향 없음).
                -- ============================================================================================
                --Working Time 추출 (인라인)
                ;WITH target_division AS (
                    SELECT DISTINCT dt.division_id
                    FROM scm_mst_division dm WITH(NOLOCK)
                         INNER JOIN scm_mst_division dt WITH(NOLOCK)
                                 ON dt.attribute4 = dm.attribute4
                                AND dt.division_id = CASE WHEN dm.attribute3 = 'EE' THEN dt.division_id ELSE dm.division_id END
                                AND dt.attribute3 != 'EE'
                                AND dt.valid_yn   = 'Y'
                    WHERE dm.division_id = @P_DIVISION_ID
                      AND dm.valid_yn    = 'Y'
                )
                SELECT  Q.DIVISION_ID
                      , Q.PLANT_SITE_ID AS SCM_SITE_ID
                      , Q.OPERATION_ID
                      , Q.LINE_ID
                      , Q.YYYYMMDD
                      , Q.WORKING_TIME
                INTO #LINE_WORKINGTIME_BY_LOSS
                FROM (
                        -- [SELECT 1] 내주/외주(Line Capa 대상) Working Time (Loss 반영)
                        SELECT a.division_id, a.plant_site_id, a.operation_id, a.line_id, a.yyyymmdd
                             , ( CASE WHEN c.loss_start_date IS NOT NULL
                                      THEN a.working_time - ROUND(ISNULL(c.setup_loss_time_min, 0), 0, 1)
                                      ELSE a.working_time - ROUND((a.working_time_rate * ISNULL(b.setup_loss_time_min, 0)), 0, 1)
                                 END ) AS WORKING_TIME
                        FROM ( SELECT *, working_time / 1440.0 AS working_time_rate
                                 FROM scp_mst_working_time wt WITH (NOLOCK)
                                -- 2026-06-17 김준규 [선필터] 전 사업부 2년치 스캔 차단: 40 사업부군 + 생산계획 실재 (site,op,line) 만
                                WHERE wt.division_id IN (SELECT division_id FROM target_division)
                                  AND wt.yyyymmdd >= @p_plan_start_yyyymmdd
                                  AND wt.yyyymmdd <= @p_to_yyyymmdd
                                  AND EXISTS ( SELECT 1 FROM #STG_PROD_PLAN sp WITH(NOLOCK)
                                              WHERE sp.DIVISION_ID         = @P_DIVISION_ID
                                                AND sp.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                                                AND sp.PLAN_TYPE           = @P_PLAN_TYPE
                                                AND sp.SEQ                 = @p_seq
                                                AND sp.SCM_SITE_ID         = wt.plant_site_id
                                                AND sp.OPERATION_ID        = wt.operation_id
                                                AND sp.LINE_ID             = wt.line_id ) ) a
                             INNER JOIN target_division dt ON dt.division_id = a.division_id
                             JOIN SCM_MST_SITE S ON S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.PLANT_SITE_ID
                                 AND ( S.OSP_YN = 'N'
                                       OR (S.OSP_YN = 'Y' AND ISNULL(S.ATTRIBUTE1,'N') = 'Y' AND A.LINE_ID <> '-') )
                             LEFT JOIN ( SELECT * FROM scp_mst_loss_time WITH (NOLOCK) ) b
                                    ON a.division_id = b.division_id AND a.plant_site_id = b.plant_site_id
                                   AND a.factory_id = b.factory_id AND a.operation_id = b.operation_id AND a.line_id = b.line_id
                             LEFT JOIN ( SELECT division_id, plant_site_id, factory_id, operation_id, line_id
                                              , loss_start_date, loss_end_date, loss_time_min, setup_loss_time_min
                                           FROM scp_mst_loss_time_except WITH (NOLOCK) ) c
                                    ON a.division_id = c.division_id AND a.plant_site_id = c.plant_site_id
                                   AND a.factory_id = c.factory_id AND a.operation_id = c.operation_id AND a.line_id = c.line_id
                                   AND a.yyyymmdd >= c.loss_start_date AND a.yyyymmdd <= c.loss_end_date
                        WHERE 1=1
                          AND a.yyyymmdd >= @p_plan_start_yyyymmdd
                          AND a.yyyymmdd <= @p_to_yyyymmdd

                        UNION ALL    -- 2026-06-17 김준규: 두 SELECT 는 상호배타(OSP_YN/ATTRIBUTE1/LINE_ID) → UNION ALL 안전

                        -- [SELECT 2] 외주(Line Capa 비대상) Outsourcing Daily Capa
                        SELECT A.DIVISION_ID, A.PLANT_SITE_ID, A.OPERATION_ID, A.LINE_ID, A.YYYYMMDD
                             , ( SELECT ISNULL(SUM(ISNULL(C.DAILY_CAPA_QTY,0)),0)
                                   FROM SCP_MST_OUTSOURCING_CAPA C WITH(NOLOCK)
                                  WHERE C.DIVISION_ID = A.DIVISION_ID AND C.PLANT_SITE_ID = A.PLANT_SITE_ID AND C.ITEM_ID = '-' ) AS WORKING_TIME
                        FROM ( SELECT w.*, w.working_time / 1440.0 AS working_time_rate
                                 FROM scp_mst_working_time W WITH (NOLOCK)
                                      INNER JOIN target_division dt ON dt.division_id = w.division_id
                                    , scm_mst_site s WITH (NOLOCK)
                                WHERE 1=1
                                  AND w.division_id   = s.division_id
                                  AND w.plant_site_id = s.scm_site_id
                                  AND s.osp_yn = 'Y'
                                  AND ( ISNULL(S.ATTRIBUTE1,'N') IN ('','N') OR W.LINE_ID = '-' )
                                  -- 2026-06-17 김준규 [선필터] 생산계획 실재 (site,op,line) 만
                                  AND EXISTS ( SELECT 1 FROM #STG_PROD_PLAN sp WITH(NOLOCK)
                                              WHERE sp.DIVISION_ID         = @P_DIVISION_ID
                                                AND sp.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                                                AND sp.PLAN_TYPE           = @P_PLAN_TYPE
                                                AND sp.SEQ                 = @p_seq
                                                AND sp.SCM_SITE_ID         = W.plant_site_id
                                                AND sp.OPERATION_ID        = W.operation_id
                                                AND sp.LINE_ID             = W.line_id )
                             ) a
                        WHERE 1=1
                          AND A.YYYYMMDD >= @p_plan_start_yyyymmdd
                          AND A.YYYYMMDD <= @p_to_yyyymmdd
                     ) Q
                ;

                -- (D) 2-pass(L7332/L7429) 조인키 인덱스 — LEFT/HASH JOIN 가속
                CREATE CLUSTERED INDEX IX_LWBL_JOINKEY
                    ON #LINE_WORKINGTIME_BY_LOSS (DIVISION_ID, OPERATION_ID, SCM_SITE_ID, LINE_ID, YYYYMMDD);

        SET @v_log_message = N'########## INTO #LINE_WORKINGTIME_BY_LOSS ##########';
        SET @v_description = @v_program_name + ':' + N' INTO #LINE_WORKINGTIME_BY_LOSS FROM FN_LINE_WORKINGTIME_BY_LOSS ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 시작

                IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL
                    DROP TABLE #LineLoad;

                SELECT
                    A.DIVISION_ID
                  , A.SCM_SITE_ID
                  , A.OPERATION_GROUP
                  , A.OPERATION_ID
                  , A.LINE_ID
                  , CASE
                        WHEN A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                        WHEN A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                    END                                                             AS MEASURE
                  , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE ISNULL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) / D.WORKING_TIME ) ),0 ) * 100  END AS QTY
                  , ISNULL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60.0)), 0), 0)          AS CAPA_TACT
                  , ISNULL(D.WORKING_TIME, 0)                                       AS WORKING_TIME
                  , A.YYYYMMDD
                  , C.ISO_YYYYWW
                  , M.TIME_TERM
                  , 'WQTY'
                    + REPLICATE('0',
                          2 - LEN(DENSE_RANK() OVER (PARTITION BY A.LINE_ID
                                                         ORDER BY C.ISO_YYYYWW)))
                    + CONVERT(NVARCHAR,
                          DENSE_RANK() OVER (PARTITION BY A.LINE_ID
                                                 ORDER BY C.ISO_YYYYWW))            AS WEEK_COLUMN
                INTO #LineLoad
                FROM #STG_PROD_PLAN A WITH(NOLOCK)
                     -- SCP_ANL_PRODUCTION_PLAN(A)
                     --   division=40: 약 13,816,914건 / 전체: 66,428,150건
                     --   IX06 인덱스: (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ,
                     --                 LINE_ID, MEASURE, YYYYMMDD, ...) 활용
                     --   최종 결과: 약 402,309건 → 31,920건 GROUP BY 후

                     -- SCM_SYS_CALENDAR_M(C): 날짜범위 내 약 2,520건 (소규모)
                     --   Build 입력으로 HASH JOIN → Probe 입력(A)의 YYYYMMDD와 매칭
                     INNER HASH JOIN SCM_SYS_CALENDAR_M C WITH (NOLOCK)
                             ON  C.BASIS_YYYYMMDD = A.YYYYMMDD

                     -- #LINE_WORKINGTIME_BY_LOSS(D): 95,776건
                     --   Build 입력으로 HASH JOIN
                     LEFT  HASH JOIN #LINE_WORKINGTIME_BY_LOSS D WITH (NOLOCK)
                             ON  D.DIVISION_ID  = A.DIVISION_ID
                            AND  D.OPERATION_ID = A.OPERATION_ID
                            AND  D.SCM_SITE_ID  = A.SCM_SITE_ID
                            AND  D.LINE_ID      = A.LINE_ID
                            AND  D.YYYYMMDD     = A.YYYYMMDD

                     -- SCP_ANL_TACT_TIME(E): division=40 기준 7,242,428건 / 전체 12,601,519건
                     --   대용량 → LEFT HASH JOIN 명시하여 Nested Loop 방지
                     LEFT  HASH JOIN SCP_ANL_TACT_TIME E WITH (NOLOCK)
                             ON  E.DIVISION_ID  = A.DIVISION_ID
                            AND  E.OPERATION_ID = A.OPERATION_ID
                            AND  E.SCM_SITE_ID  = A.SCM_SITE_ID
                            AND  E.LINE_ID      = A.LINE_ID
                            AND  E.ITEM_ID      = A.ITEM_ID
                            AND  E.YYYYMMDD     = A.YYYYMMDD

                     --   LEFT HASH JOIN으로 통일 → OPTION(HASH JOIN) 없이도 충돌 없음
                     LEFT HASH JOIN SCM_WORK_CALENDAR_M_SN M  WITH (NOLOCK)
                             ON  M.DIVISION_ID  = A.DIVISION_ID
                            AND  M.OPERATION_ID = A.OPERATION_ID
                            AND  M.PLANT_ID     = LEFT(A.SCM_SITE_ID, 4)
                            AND  M.WORK_DATE    = CONVERT(DATETIME, A.YYYYMMDD)
                            AND  M.LINE_ID      = A.LINE_ID
                            AND  M.LOSS_CODE    = N'XC031'

                WHERE  A.DIVISION_ID         = @p_division_id
                  AND  A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                  AND  A.PLAN_TYPE           = @p_plan_type
                  AND  A.SEQ                 = CAST(@p_seq AS BIGINT)
                  AND  A.YYYYMMDD            >= @p_plan_start_yyyymmdd
                  AND  A.YYYYMMDD            <= @p_to_yyyymmdd
                    -- 2026-05-11 김준규 [옵션 A-2]: AS-IS 호환 위해 비활성화 (skeleton 보존) — AND A.QTY <> 0   -- [요구사항#4] 0 제거 (대량 테이블 감소)
                  AND  A.MEASURE             = 'PROD_PLAN_AMEND'

                GROUP BY
                    A.DIVISION_ID
                  , A.SCM_SITE_ID
                  , A.OPERATION_ID
                  , A.LINE_ID
                  , A.YYYYMMDD
                  , D.WORKING_TIME
                  , C.ISO_YYYYWW
                  , A.OPERATION_GROUP
                  , CASE
                        WHEN A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                        WHEN A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                    END
                  , M.TIME_TERM
                OPTION (MAXDOP 4, NO_PERFORMANCE_SPOOL)
                --   MAXDOP 4: 병렬도 제한으로 RESERVED_MEMORY_ALLOCATION_EXT 대기 최소화
                --   NO_PERFORMANCE_SPOOL: 불필요한 Spool 연산 방지
                ;


            -- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 신규로직 끝


        SET @v_log_message = N'########## INTO #LineLoad ##########';
        SET @v_description = @v_program_name + ':' + N' FROM SCP_ANL_PRODUCTION_PLAN ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
        --                        ,@p_log_type      = @v_log_type
        --                        ,@p_log_count     = @n_log_count
        --                        ,@p_log_message   = @v_log_message
        --                        ,@p_description   = @v_description
        --                        ,@p_event_date    = @d_event_date
        --                        ,@p_user_id       = @v_batch_user
  --                                ;


-- E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 로직 주석처리

    /*

                  IF OBJECT_ID('tempdb..#LineLoad_temp') IS NOT NULL
                    DROP TABLE #LineLoad_temp;


                SELECT /*DISTINCT */
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
                    , M.TIME_TERM       -- 형교환(Model Change)
                    ,'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW) )) + CONVERT(NVARCHAR,DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW))  AS WEEK_COLUMN
                INTO #LineLoad_temp
                      FROM #STG_PROD_PLAN A WITH(NOLOCK)
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
                        AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd
                    AND A.YYYYMMDD           <=  @p_to_yyyymmdd --말일포함(KSK, 20240814)
--                  AND A.MEASURE             IN ('CELL_PROD','PACK_PROD')
                  AND A.MEASURE             IN ('PROD_PLAN_AMEND')
              GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP
                      ,(CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END )
                      , M.TIME_TERM     -- 형교환(Model Change)
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
        */


PRINT '--A@X#02400--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

             INSERT INTO #PSI_GLOBAL_SMALL_AUTO
                SELECT DISTINCT A.DIVISION_ID
                          , A.OPERATION_GROUP
                          , A.CELL_ITEM_ID
                          , A.ITEM_ID
                          , '-' AS TO_SITE
                    , A.PROJECT_CODE
                          , A.TO_BOH_QTY
                          , A.FROM_BOH_QTY
                          , '-' AS INCOTERMS
                          , A.FROM_SITE
                    , '-' AS TRANSPORT_MODE
                    , A.PROD_LINE
                          , B.MEASURE
                          , A.YYYYMMDD
                    , B.QTY
                          , M.SORT_ORDER_NO
                          , M.COLUMN_LABEL_NAME
                          , A.BOD_ID
                        , A.ATTRIBUTE1
                         , A.ATTRIBUTE9
                FROM #PSI_GLOBAL_SMALL_AUTO A WITH(NOLOCK)
                INNER JOIN #LineLoad B WITH(NOLOCK)
                    ON  A.DIVISION_ID         = B.DIVISION_ID
                    AND A.OPERATION_GROUP     = B.OPERATION_GROUP
                    AND A.FROM_SITE           = B.SCM_SITE_ID
                    AND A.ATTRIBUTE9          = B.OPERATION_ID
                    AND A.PROD_LINE           = B.LINE_ID
                    AND A.YYYYMMDD            = B.YYYYMMDD
             INNER JOIN #MEASURE M  WITH (NOLOCK)
                ON B.MEASURE   = M.COLUMN_NAME
             -- 2026-05-13 김준규 [to_date 필터]: A.YYYYMMDD = B.YYYYMMDD JOIN 이라 양쪽 모두 동일 필터 효과
             --   #LineLoad 측에 인덱스 있으면 옵티마이저가 더 일찍 차단
             WHERE B.YYYYMMDD <= @p_to_yyyymmdd
                ;

            -- [DEBUG] #PSI_GLOBAL_SMALL INSERT 결과


       SET @v_log_message = N'########## INSERT INTO #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #PSI_GLOBAL_SMALL_AUTO ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


---------------- E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경)  ---------START
                -- [DEBUG] #PSI_GLOBAL_SMALL_AUTO INSERT 사용 변수
                IF @v_is_debug = 1 SELECT CONCAT('SHIP_PLAN BOD @P_DIVISION_ID:', @P_DIVISION_ID, '|', '@p_plan_start_yyyymmdd:', @p_plan_start_yyyymmdd, '|', '@p_to_yyyymmdd:', @p_to_yyyymmdd) AS "#PSI_GLOBAL_SMALL_AUTO 사용변수";

PRINT '--A@X#02410_BOD_SHIP_START--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

                INSERT INTO #PSI_GLOBAL_SMALL_AUTO
                    SELECT
                            B.DIVISION_ID
                            ,  F.OPERATION_GROUP
                            , ISNULL(F.CELL_ITEM_ID, M.ITEM_ID)  AS CELL_ITEM_ID
                            , M.ITEM_ID
                            , B.to_site

                            , '-'  AS PROJECT_CODE
                            , 0 AS TO_BOH_QTY
                            , 0 AS FROM_BOH_QTY
                            , B.incoterms
                            , B.from_site
                            , B.transport_mode

                            , '-' AS PROD_LINE
                            ,  'SHIP_PLAN' AS MEASURE
                            , @p_plan_start_yyyymmdd AS YYYYMMDD
                            , 0 AS QTY
                            , MS.SORT_ORDER_NO
                            , MS.COLUMN_LABEL_NAME
                            , B.bod_id

                             ,'SCP_ANL_SHIPMENT_PLAN_FG'  AS  ATTRIBUTE1
                             , NULL  AS ATTRIBUTE9
                      FROM [dbo].[SCP_MST_BOD_N_V] B
                      INNER JOIN SCP_MST_BOD_ITEM AS M  WITH (NOLOCK)
                        ON  B.DIVISION_ID  = M.DIVISION_ID
                        AND B.BOD_ID = M.BOD_ID
                        AND M.VALID_YN = 'Y' AND B.bod_valid_yn = 'Y' AND B.ROUTE_VALID_YN = 'Y' -- KSK,250709
                       INNER JOIN SCP_MST_FINAL_ITEM F
                         ON M.DIVISION_ID = F.DIVISION_ID
                        AND M.ITEM_ID = F.ITEM_ID
                        AND F.OPERATION_GROUP = 'A'
                        AND F.ATTRIBUTE8 = 'CP'
                        INNER JOIN #MEASURE MS WITH(NOLOCK)
                            ON MS.COLUMN_NAME = 'SHIP_PLAN'
                      where 1= 1
                      AND B.BOD_VALID_YN = 'Y'
                      AND B.DIVISION_ID = @P_DIVISION_ID
                      AND B.BOD_TYPE =  'SALES'
                     AND  B.transport_mode <> 'AIR'
                      AND B.FROM_YYYYMMDD <= @p_to_yyyymmdd
                      AND B.TO_YYYYMMDD   >= @p_plan_start_yyyymmdd
                      AND  EXISTS (SELECT  BOD_ID, TO_SITE, from_site, INCOTERMS, TRANSPORT_MODE
                             FROM #PSI_GLOBAL_SMALL_AUTO S WITH (NOLOCK)
                             WHERE MEASURE = 'SHIP_PLAN'
                             AND S.TO_SITE = B.to_site
                             AND S.FROM_SITE = B.from_site
                             AND ( S.INCOTERMS = B.incoterms OR S.INCOTERMS = '-')
                             AND S.TRANSPORT_MODE = B.transport_mode
                             AND S.BOD_ID <> B.BOD_ID
                             )

       SET @v_log_message = N'########## INSERT INTO #PSI_GLOBAL_SMALL_AUTO ##########';

                -- [DEBUG] #PSI_GLOBAL_SMALL_AUTO INSERT 결과

        SET @v_description = @v_program_name + ':' + N' FROM [SCP_MST_BOD_N_V] SHIP_PLAN ';
        SET @d_event_date = SYSDATETIME();

PRINT '--A@X#02420_BOD_SEMI_START--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

                -- [DEBUG] #PSI_GLOBAL_SMALL_AUTO INSERT 사용 변수
                IF @v_is_debug = 1 SELECT CONCAT('SEMI_SHIP_PLAN BOD @P_DIVISION_ID:', @P_DIVISION_ID, '|', '@p_plan_start_yyyymmdd:', @p_plan_start_yyyymmdd, '|', '@p_to_yyyymmdd:', @p_to_yyyymmdd) AS "#PSI_GLOBAL_SMALL_AUTO 사용변수";

                INSERT INTO #PSI_GLOBAL_SMALL_AUTO
                    SELECT
                            B.DIVISION_ID
                            ,  F.OPERATION_GROUP
                            , ISNULL(F.CELL_ITEM_ID, M.ITEM_ID ) AS CELL_ITEM_ID
                            , M.ITEM_ID
                            , B.to_site

                            , '-'  AS PROJECT_CODE
                            , 0 AS TO_BOH_QTY
                            , 0 AS FROM_BOH_QTY
                            , B.incoterms
                            , B.from_site
                            , B.transport_mode

                            , '-' AS PROD_LINE
                            ,  'SEMI_SHIP_PLAN' AS MEASURE
                            , @p_plan_start_yyyymmdd AS YYYYMMDD
                            , 0 AS QTY
                            , MS.SORT_ORDER_NO
                            , MS.COLUMN_LABEL_NAME
                            , B.bod_id

                             ,'SCP_ANL_SHIPMENT_PLAN_SEMI'  AS  ATTRIBUTE1
                             , NULL  AS ATTRIBUTE9
                      FROM [dbo].[SCP_MST_BOD_N_V] B
                      INNER JOIN SCP_MST_BOD_ITEM AS M  WITH (NOLOCK)
                        ON  B.DIVISION_ID  = M.DIVISION_ID
                        AND B.BOD_ID = M.BOD_ID
                        AND M.VALID_YN = 'Y' AND B.bod_valid_yn = 'Y' AND B.ROUTE_VALID_YN = 'Y' -- KSK,250709
                       INNER JOIN SCP_MST_FINAL_ITEM F
                         ON M.DIVISION_ID = F.DIVISION_ID
                        AND M.ITEM_ID = F.ITEM_ID
                        AND F.OPERATION_GROUP = 'A'
                        AND F.ATTRIBUTE8 = 'CP'
                    INNER JOIN #MEASURE MS WITH(NOLOCK)
                            ON MS.COLUMN_NAME = 'SEMI_SHIP_PLAN'
                      where 1= 1
                      AND B.BOD_VALID_YN = 'Y'
                      AND B.DIVISION_ID = @P_DIVISION_ID
                      AND B.BOD_TYPE =  'PLANT'
                     AND  B.transport_mode <> 'AIR'
                      AND B.FROM_YYYYMMDD <= @p_to_yyyymmdd
                      AND B.TO_YYYYMMDD   >= @p_plan_start_yyyymmdd
                      AND  EXISTS (SELECT  BOD_ID, TO_SITE, from_site, INCOTERMS, TRANSPORT_MODE
                             FROM #PSI_GLOBAL_SMALL_AUTO S WITH (NOLOCK)
                             WHERE MEASURE = 'SEMI_SHIP_PLAN'
                             AND S.TO_SITE = B.to_site
                             AND S.FROM_SITE = B.from_site
                             AND ( S.INCOTERMS = B.incoterms OR S.INCOTERMS = '-')
                             AND S.TRANSPORT_MODE = B.transport_mode
                             AND S.BOD_ID <> B.BOD_ID
                             )

       SET @v_log_message = N'########## INSERT INTO #PSI_GLOBAL_SMALL_AUTO ##########';

                -- [DEBUG] #PSI_GLOBAL_SMALL_AUTO INSERT 결과

        SET @v_description = @v_program_name + ':' + N' FROM [SCP_MST_BOD_N_V] SEMI_SHIP_PLAN ';
        SET @d_event_date = SYSDATETIME();

PRINT '--A@X#02430_PACK_CELL_PROD_START--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

----------- E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경)  -------- END


            ----------------------------------------------------
            -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화
            -- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - start
            INSERT #PSI_GLOBAL_SMALL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID
                                    , X.OPERATION_GROUP
                                    , X.CELL_ITEM_ID
                                    , X.ITEM_ID
                                    , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
                                , 0 AS TO_BOH_QTY
                                    , 0 AS FROM_BOH_QTY
                                    , '-' AS INCOTERMS
                                    , X.FROM_SITE
                              , '-' AS  TRANSPORT_MODE
                              , X.PROD_LINE
                                    , M.COLUMN_NAME AS MEASURE
                                          , X.YYYYMMDD
                              , 0    AS QTY
                                    , M.SORT_ORDER_NO
                                    , M.COLUMN_LABEL_NAME
                                    , '-'  AS BOD_ID
                              , X.ATTRIBUTE1
                                , X.ATTRIBUTE9
              FROM (SELECT  DISTINCT
                            DIVISION_ID
                           ,OPERATION_GROUP
                           ,CELL_ITEM_ID
                           ,ITEM_ID
                           ,FROM_SITE
                           ,PROD_LINE
                           ,MEASURE
                           ,YYYYMMDD
                           ,ATTRIBUTE1
                            ,ATTRIBUTE9
                      FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
                     WHERE MEASURE    IN ('PACK_PROD', 'CELL_PROD')
                       AND PROD_LINE   <> '-'
                       -- 2026-05-13 김준규 [to_date 필터, 퍼포먼스 핵심]
                       --   서브쿼리 X 내부에서 차단 → 후속 CROSS APPLY #MEASURE 의 카티시안 row 수까지 감소
                       --   PROD_LINE <> '-' 조건이 메타데이터 행 제외하므로 YYYYMMDD NULL 행 없음
                       AND YYYYMMDD <= @p_to_yyyymmdd
                   ) X
              CROSS APPLY #MEASURE M WITH (NOLOCK)
              WHERE 1=1
                AND X.MEASURE    IN ('PACK_PROD', 'CELL_PROD')
                AND M.GUBUN       = 'FROM'
                AND M.COLUMN_NAME = (CASE WHEN X.MEASURE = 'PACK_PROD' THEN 'PACK_MODEL_CHANGE' ELSE 'CELL_MODEL_CHANGE'END)
                AND X.PROD_LINE   <> '-'
                ;


       SET @v_log_message = N'########## INSERT #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' FROM #PSI_GLOBAL_SMALL_AUTO PACK_PROD / CELL_PROD ';
        SET @d_event_date = SYSDATETIME();

PRINT '--A@X#02440_DELETE_UPDATE_START--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            DELETE FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE MEASURE    IN ('PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE')
               AND PROD_LINE   = '-'
               ;

       SET @v_log_message = N'########## DELETE #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' PACK_MODEL_CHANGE / CELL_MODEL_CHANGE ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - end

            -- KSW 2021.07.29 형교환 - start
            UPDATE X
            SET X.QTY = ISNULL(B.TIME_TERM, 0)
            FROM #PSI_GLOBAL_SMALL_AUTO X  WITH (NOLOCK)
            INNER JOIN SCM_WORK_CALENDAR_M_SN B  WITH (NOLOCK)
            ON 0 = 0
            AND X.DIVISION_ID        = B.DIVISION_ID
            AND LEFT(X.FROM_SITE, 4) = B.PLANT_ID
            AND X.attribute9   = B.OPERATION_ID
            AND X.YYYYMMDD     = B.WORK_DATE
            AND X.PROD_LINE    = B.LINE_ID
            AND B.LOSS_CODE    = 'XC031'
            WHERE X.MEASURE   IN ('PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE')

       SET @v_log_message = N'########## UPDATE #PSI_GLOBAL_SMALL_AUTO ##########';
        SET @v_description = @v_program_name + ':' + N' JOIN SCM_WORK_CALENDAR_M_SN ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;

            -- KSW 2021.07.29 형교환 - end
            ----------------------------------------------------
PRINT '--A@X#02500--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            if @v_is_debug = 1  SELECT '#PSI_GLOBAL_SMALL_AUTO_10'  "PSI_GLOBAL_SMALL_AUTO_10",  * FROM   #PSI_GLOBAL_SMALL_AUTO

            -------------------------------------------------------------------------------------------------------------
            -- (Stage1) #PSI_GLOBAL_SMALL_AUTO 안전장치 필터
            -------------------------------------------------------------------------------------------------------------
            DELETE A
              FROM #PSI_GLOBAL_SMALL_AUTO A
             WHERE NOT EXISTS (
                       SELECT 1 FROM #FILTER_ITEM_BOTH F   -- 2026-05-06 김준규: PACK/CELL 혼재 → BOTH
                        WHERE F.ITEM_ID = (CASE WHEN ISNULL(A.CELL_ITEM_ID, N'') = N'' THEN A.ITEM_ID ELSE A.CELL_ITEM_ID END)
                   )
               -- 2026-06-02 김준규 추가: SEMI_SHIP_PLAN skeleton 보존 (KR01297200(DAP) 손실 대응)
               --   배경: 실제 출하 없이 #LINE_ASSIGN 로만 생성된 SEMI skeleton 은 CHILD_ITEM_ID(cell)가
               --        #FILTER_ITEM_BOTH 에 없어 이 안전필터(2026-05-06 신규)에 잘려나감 → RAW 미출력.
               --   조치: 3개 SEMI measure 는 이 필터에서 제외(보존). 실제 출하행(예: KR00995200)은
               --        ITEM_ID 가 필터를 통과하므로 NOT EXISTS=false → 어차피 삭제 대상이 아니라 무영향.
               --   주의: 보존 후 RAW SEMI 행이 과도하게 늘면(범위 밖 ITEM 유입) NOT EXISTS(#ANL_SHIPMENT_PLAN_SEMI)
               --        조건으로 좁힐 것. 현재는 #LINE_ASSIGN 스코프 내라 광역 보존으로 충분 판단.
               AND A.MEASURE NOT IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG', N'SEMI_SHIP_GAP_ACC');

            -- 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
            --  구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)


            -- 기존 플랜의 구 data 삭제
            -- (Option A) DELETE FROM #SCP_XLS_PSI_GLOBAL_SMALL 제거 (PIVOT 결과 테이블 미사용)
                -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @P_PLAN_TYPE AND SEQ = @p_seq

       SET @v_log_message = N'########## DELETE #SCP_XLS_PSI_GLOBAL_SMALL DIVISION ##########';
        SET @v_description = @v_program_name + ':' + N' 기존 플랜의 구 data 삭제 ';
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                ,@p_log_type      = @v_log_type
--                                ,@p_log_count     = @n_log_count
--                                ,@p_log_message   = @v_log_message
--                                ,@p_description   = @v_description
--                                ,@p_event_date    = @d_event_date
--                                ,@P_USER_ID       = @v_batch_user
--                                  ;


            -- (duplicate DECLARE removed; declared in header)
            -- (duplicate DECLARE removed; declared in header)
            -- (duplicate DECLARE removed; declared in header)

            --  Plan End Date
            -- [merged] -- [merged] DECLARE @v_pet_date     NVARCHAR(12) = '';   (duplicate; declared in header)   (duplicate; declared in header)
            SET @v_bp_flag          = '';
            -- [merged] -- [merged] DECLARE @v_bp_days      INT = 0;   (duplicate; declared in header)   (duplicate; declared in header)
            -- [merged] -- [merged] DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = '';   (duplicate; declared in header)   (duplicate; declared in header)

            SELECT @v_pet_date = p.horizon_end_date,
                   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end),
                   @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end)
            FROM   dbo.scm_mst_plan p WITH(NOLOCK)
            WHERE  p.division_id = @P_DIVISION_ID
            AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @P_DIVISION_ID and plan_id < 9999)
            ;

            SET @p_create_from_yyyymmdd = @p_plan_start_yyyymmdd;
            SET @p_create_to_yyyymmdd   = @v_pet_date;--CONVERT(VARCHAR(8), DATEADD(day, 363, @p_create_from_yyyymmdd), 112);

            PRINT CONCAT('@p_create_from_yyyymmdd:',@p_create_from_yyyymmdd,'@p_create_to_yyyymmdd:',@p_create_to_yyyymmdd)
            ----------------------------------------------------------------
            -- (Option A) PIVOT 로직 제거됨
            -- PR_SCP_XLS_PSI_GLOBAL_SMALL_S 의 인라인 본문 전체 제거.
            -- 결과 LONG 임시테이블 = #PSI_GLOBAL_SMALL_AUTO  (DIVISION_ID, ITEM_ID, ..., YYYYMMDD, QTY)
            -- 후속 PIVOT(SCM_SIM_DYN_COLS 적재) 은 별도 외부 SP 에서 수행함.
            ----------------------------------------------------------------
            -- (Option A) BP_FLAG='Y' 중장기 2YEAR 분기 비활성화
            --   PIVOT 로직 제거에 따라 동일 구간을 두 번 PIVOT 할 필요가 없어짐.
            --   필요 시 #PSI_GLOBAL_SMALL_AUTO 에 두 번째 구간 데이터를 추가 INSERT 하도록 별도 처리 필요.
            ----------------------------------------------------------------

                -- IF (@rows < 0) GOTO _RETURN_ERR_CODE  -- (inlined; kept for reference)

            --PRINT N'임시 TEMP  테이블 DROP'
            -------------------------------------------------------------------------------------------------------------
            -- 임시 TEMP  테이블 DROP
            -------------------------------------------------------------------------------------------------------------
              -- 2026-05-21 김준규 추가 (이후) 단계에서 사용되므로 여기서 DROP 안 함.
              --IF OBJECT_ID('tempdb..#MEASURE')    IS NOT NULL
              --      DROP TABLE #MEASURE;

              --마지막에서 데이터 검증용 쿼리 출력을 위해서 삭제하지 않고 나중에 안정화시 삭제
              --IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL') IS NOT NULL
              --    DROP TABLE #PSI_GLOBAL_SMALL;

              IF OBJECT_ID('tempdb..#ANL_SHIPMENT_PLAN_FG') IS NOT NULL
                  DROP TABLE #ANL_SHIPMENT_PLAN_FG;

              --마지막에서 데이터 검증용 쿼리 출력을 위해서 삭제하지 않고 나중에 안정화시 삭제
              --IF OBJECT_ID('tempdb..#ANL_PRODUCTION_PLAN') IS NOT NULL
              --    DROP TABLE #ANL_PRODUCTION_PLAN;

              IF OBJECT_ID('tempdb..#ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL
                  DROP TABLE #ANL_SHIPMENT_PLAN_SEMI;

              IF OBJECT_ID('tempdb..#SCP_PLN_PRODUCTION_PLAN') IS NOT NULL
                  DROP TABLE #SCP_PLN_PRODUCTION_PLAN;

              IF OBJECT_ID('tempdb..#ITEM_ID') IS NOT NULL
                  DROP TABLE #ITEM_ID;

              -- [Option A] #PSI_GLOBAL_SMALL_AUTO 는 PIVOT 적재 (이후) 단계에서 사용되므로 여기서 DROP 안 함.
              -- IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL_AUTO') IS NOT NULL
              --     DROP TABLE #PSI_GLOBAL_SMALL_AUTO;

              --마지막에서 데이터 검증용 쿼리 출력을 위해서 삭제하지 않고 나중에 안정화시 삭제
              --IF OBJECT_ID('tempdb..#INTRANSIT')  IS NOT NULL
              --      DROP TABLE #INTRANSIT

              -- 2026-05-09 김준규 수정: #PLN_TH_ENG_STOCK_PLAN DROP 보류 — POST-PIVOT 패치(A.2.3 WH_HOLD 차감)에서 사용
              -- IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN') IS NOT NULL
              --     DROP TABLE #PLN_TH_ENG_STOCK_PLAN

              IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_FOR_HOLD') IS NOT NULL
                  DROP TABLE #PLN_TH_ENG_STOCK_PLAN_FOR_HOLD

              IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD') IS NOT NULL
                    DROP TABLE #PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD

              --2026-05-04 이후에서 사용으로 막지않음
              --IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL
              --    DROP TABLE #SCP_MST_BOD_V;

              IF OBJECT_ID('tempdb..#LineLoad')   IS NOT NULL
                  DROP TABLE #LineLoad

              IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT')   IS NOT NULL
                  DROP TABLE #LineLoad_WEEK_PIVOT

              IF OBJECT_ID('tempdb..#TRANSPORT_MODE') IS NOT NULL
                  DROP TABLE #TRANSPORT_MODE;

              IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_AUTO_MODEL_INVENTORY') IS NOT NULL
                  DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_AUTO_MODEL_INVENTORY;

              IF OBJECT_ID('tempdb..#Rn') IS NOT NULL
                  DROP TABLE #Rn

              IF OBJECT_ID('tempdb..#CALENDAR') IS NOT NULL
                  DROP TABLE #CALENDAR

              IF OBJECT_ID('tempdb..#HEADER') IS NOT NULL
                  DROP TABLE #HEADER

              IF OBJECT_ID('tempdb..#PLN_PLANT_ONHAND')  IS NOT NULL
                    DROP TABLE #PLN_PLANT_ONHAND

                -- 2026-05-09 김준규 수정: #BOH DROP 보류 — POST-PIVOT 패치(A.1.1)에서 새로 생성/사용 후 끝에서 DROP
                -- IF OBJECT_ID('tempdb..#BOH')        IS NOT NULL
                --     DROP TABLE #BOH

               -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - HOLD 가 포함되지 않음 - PACK HOLD 만 해당
               IF OBJECT_ID('tempdb..#BOH_NHOLD') IS NOT NULL
                    DROP TABLE #BOH_NHOLD

                IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_AUTO') IS NOT NULL
                    DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_AUTO

               -- 2026-05-09 김준규 수정: #tmp_SCP_MST_TACT_TIME DROP 보류 — POST-PIVOT 패치(A.1.3)에서 새로 생성/사용 후 끝에서 DROP
               -- IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL
               --   DROP TABLE #tmp_SCP_MST_TACT_TIME

               -------------------------------------------------------------------------------------------------------------------------
               -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
               -- PACK_PROD, CELL_PROD - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가 - 임시테이블 삭제
               -------------------------------------------------------------------------------------------------------------------------
               IF OBJECT_ID('tempdb..#LINE_ASSIGN') IS NOT NULL
                    DROP TABLE #LINE_ASSIGN

               IF OBJECT_ID('tempdb..#LINE_ASSIGN_ORG') IS NOT NULL
                    DROP TABLE #LINE_ASSIGN_ORG

               -- MODULE 의 상위 모델을 찾기위한 temp 테이블
               IF OBJECT_ID('tempdb..#temp_MODEL_INFO') IS NOT NULL
                  DROP TABLE #temp_MODEL_INFO;

                -------------------------------------------------------------------------------------------------------------
                -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가
        ---------------------------------------------------------------------------------
        -- (1.5) [요구사항 #2] PIVOT 직전 후처리 — daily_small SP 의 비즈니스 로직을 인라인
        --   1) OPERATION_GROUP = 'A' 필터
        --   2) MEASURE 17 종 제한 (#PSI_MEASURE_DAILY)
        --   3) CELL_EOH 의 FROM_BOH_QTY 보정 (SCP_MST_FINAL_ITEM CP/CA1/CA2 합산)
        --   4) CELL_FORM_HOLD_AFTER 의 QTY 보정 (CP/CA1 합산, 1차/2차년도 중복방지)
        ---------------------------------------------------------------------------------
PRINT '--A@X#02600--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        -- (2-1) OPERATION_GROUP = 'A' 필터
        -- 2026-05-19 김준규 [PACK INTRANSIT 예외 보존]:
        --   요구사항: RAW REPORT 에 PACK INTRANSIT / INTRANSIT_ETA 표시 (AS-WAS 회귀)
        --   기존: OPERATION_GROUP <> 'A' 모두 삭제 → PACK INTRANSIT row 도 함께 손실
        --   변경: PACK + INTRANSIT/INTRANSIT_ETA 만 보존, 그 외 비-'A' row 는 기존대로 삭제
        --   주의: SEMI_INTRANSIT / SEMI_INTRANSIT_ETA 는 #PSI_MEASURE_DAILY 에 미등록 → (2-2) 에서 자동 제거 (의도된 동작 유지)
        DELETE A
          FROM #PSI_GLOBAL_SMALL_AUTO A
         WHERE A.OPERATION_GROUP <> N'A'
           AND NOT (A.OPERATION_GROUP = N'P' AND A.MEASURE IN (N'INTRANSIT', N'INTRANSIT_ETA'));

        -- (2-2) MEASURE 제한 (#PSI_MEASURE_DAILY 는 SP 시작부에서 이미 생성됨)
        --   (Method B) 시작부에서 만든 #PSI_MEASURE_DAILY 를 그대로 재사용
        DELETE A
          FROM #PSI_GLOBAL_SMALL_AUTO A
         WHERE NOT EXISTS (SELECT 1 FROM #PSI_MEASURE_DAILY M WHERE M.MEASURE = A.MEASURE);

        -- (2-3) CELL_EOH 의 FROM_BOH_QTY 보정
        --   Original logic from PR_SCP_XLS_DAILY_SMALL:
        --     CELL_ITEM_ID = ITEM_ID (FG)   → SCP_MST_FINAL_ITEM JOIN SCP_XLS_BOH 합산 (attribute8 LIKE 'C%', WH_HOLD 제외)
        --     CELL_ITEM_ID <> ITEM_ID (SEMI)→ FROM_BOH_QTY + sum of SEMI siblings' FROM_BOH_QTY
        IF OBJECT_ID('tempdb..#CELL_EOH_BOH_FG') IS NOT NULL DROP TABLE #CELL_EOH_BOH_FG;
        SELECT
             A.attribute1   AS CELL_ITEM_ID
            ,B.SCM_SITE_ID  AS FROM_SITE
            ,SUM(B.QTY)     AS BOH_QTY
        INTO #CELL_EOH_BOH_FG
        FROM SCP_MST_FINAL_ITEM A WITH(NOLOCK)
        INNER JOIN #SCP_XLS_BOH B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
        WHERE A.attribute8 LIKE 'C%'
          AND ISNULL(B.ATTRIBUTE10, N'') <> N'WH_HOLD'   -- E20251112-000986: 보류재고 제외
        GROUP BY A.attribute1, B.SCM_SITE_ID;

        IF OBJECT_ID('tempdb..#CELL_EOH_BOH_SEMI') IS NOT NULL DROP TABLE #CELL_EOH_BOH_SEMI;
        SELECT
             A.CELL_ITEM_ID
            ,A.FROM_SITE
            ,SUM(A.FROM_BOH_QTY) AS BOH_SUM
        INTO #CELL_EOH_BOH_SEMI
        FROM #PSI_GLOBAL_SMALL_AUTO A
        WHERE A.MEASURE = N'CELL_EOH'
          AND A.CELL_ITEM_ID <> A.ITEM_ID
        GROUP BY A.CELL_ITEM_ID, A.FROM_SITE;

        -- 보정: SEMI 행은 본인 FROM_BOH_QTY + SEMI 형제들 합산
        UPDATE A
           SET A.FROM_BOH_QTY = A.FROM_BOH_QTY + ISNULL(S.BOH_SUM, 0)
          FROM #PSI_GLOBAL_SMALL_AUTO A
          LEFT JOIN #CELL_EOH_BOH_SEMI S
            ON S.CELL_ITEM_ID = A.CELL_ITEM_ID
           AND S.FROM_SITE    = A.FROM_SITE
         WHERE A.MEASURE      = N'CELL_EOH'
           AND A.CELL_ITEM_ID <> A.ITEM_ID;

        -- 보정: FG 행 (CELL_ITEM_ID = ITEM_ID)은 SCP_MST_FINAL_ITEM 합산값으로 대체
        UPDATE A
           SET A.FROM_BOH_QTY = ISNULL(F.BOH_QTY, 0)
          FROM #PSI_GLOBAL_SMALL_AUTO A
          LEFT JOIN #CELL_EOH_BOH_FG F
            ON F.CELL_ITEM_ID = A.CELL_ITEM_ID
           AND F.FROM_SITE    = A.FROM_SITE
         WHERE A.MEASURE      = N'CELL_EOH'
           AND A.CELL_ITEM_ID = A.ITEM_ID;

        IF OBJECT_ID('tempdb..#CELL_EOH_BOH_FG')   IS NOT NULL DROP TABLE #CELL_EOH_BOH_FG;
        IF OBJECT_ID('tempdb..#CELL_EOH_BOH_SEMI') IS NOT NULL DROP TABLE #CELL_EOH_BOH_SEMI;

        -- ============================================================================
        -- 2026-05-22 김준규 신규: CELL_EOH 기반 3종 measure 추가 (PRODUCTION 표시용)
        --   [1] CELL_EOH row → SEMI_SHIP_PLAN_TOTAL + SHIP_PLAN_TOTAL 복제 (1:2, 모든 YYYYMMDD)
        --       SEMI_SHIP_PLAN 의 CROSS APPLY 복제 패턴 (40_PSI L2323~) 과 동일
        --   [2] CELL_ITEM_ID + FROM_SITE 그룹별 YYYYMMDD MAX row → EOH_TOTAL 복제 (1:1)
        --   QTY 는 모두 NULL (사용자 요구: 표시용 measure, 값 없음)
        --   #PSI_GLOBAL_SMALL_AUTO 기존 인덱스 IX_PGSA_MERGE (MEASURE, ITEM_ID, FROM_SITE, YYYYMMDD) 활용
        -- ============================================================================

        -- ============================================================================
        -- 2026-05-22 김준규 DEBUG: ITEM_TYPE 판단 검증용
        --   가설: #BOM_FULL_CACHE.MODEL_ID 등장 여부 = SEMI/FG 분류
        --   현상: CELL_EOH 가 안 보임 → DELETE 가 FG 까지 잡았을 가능성
        --   확인: CELL_EOH 의 ITEM_ID 들이 BOM 에 어떻게 등장하는지 분석
        -- ============================================================================
        IF @v_is_debug = 1
        BEGIN
            -- DBG-1: #BOM_FULL_CACHE 전체 통계
            SELECT '#DBG_1_BOM_FULL_CACHE_STATS' AS DBG_TAG,
                   COUNT(*)                       AS TOTAL_ROW,
                   COUNT(DISTINCT MODEL_ID)       AS DISTINCT_MODEL_ID,
                   COUNT(DISTINCT CHILD_ITEM_ID)  AS DISTINCT_CHILD_ITEM_ID
              FROM #BOM_FULL_CACHE WITH(NOLOCK);

            -- DBG-2: CELL_EOH 의 ITEM_ID 별 BOM 매핑 분포 (TOP 30)
            ;WITH CE AS (
                SELECT P.ITEM_ID, COUNT(*) AS CE_CNT
                  FROM #PSI_GLOBAL_SMALL_AUTO P
                 WHERE P.MEASURE = N'CELL_EOH'
                 GROUP BY P.ITEM_ID
            )
            SELECT TOP 30 '#DBG_2_CELL_EOH_ITEM_BOM_MAPPING' AS DBG_TAG,
                   CE.ITEM_ID,
                   CE.CE_CNT,
                   CASE WHEN EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK) WHERE B.MODEL_ID = CE.ITEM_ID)
                        THEN 'YES' ELSE 'NO' END AS IS_MODEL,
                   CASE WHEN EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK) WHERE B.CHILD_ITEM_ID = CE.ITEM_ID)
                        THEN 'YES' ELSE 'NO' END AS IS_CHILD,
                   CASE WHEN EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK) WHERE B.MODEL_ID = CE.ITEM_ID)
                        THEN 'SEMI(MODEL)' ELSE 'FG(NOT-MODEL)' END AS CLASSIFIED_AS
              FROM CE
             ORDER BY CE.ITEM_ID;

            -- DBG-3: CELL_EOH 전체 row 의 분류 집계 (FG vs SEMI 카운트)
            SELECT '#DBG_3_CELL_EOH_CLASSIFICATION' AS DBG_TAG,
                   SUM(IS_MODEL)              AS SEMI_CNT_WILL_DELETE,
                   SUM(1 - IS_MODEL)          AS FG_CNT_WILL_KEEP,
                   COUNT(*)                   AS TOTAL_CELL_EOH
              FROM (
                    SELECT CASE WHEN EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                                              WHERE B.MODEL_ID = P.ITEM_ID)
                                THEN 1 ELSE 0 END AS IS_MODEL
                      FROM #PSI_GLOBAL_SMALL_AUTO P WITH(NOLOCK)
                     WHERE P.MEASURE = N'CELL_EOH'
                   ) X;

            -- DBG-7: 특정 ITEM (MCCM/MACM 등) 의 BOM 등장 패턴 상세 (CELL_TYPE 포함)
            --   CELL_EOH 의 DISTINCT ITEM_ID 만 대상으로 BOM 의 상세 매핑 분석
            ;WITH CE_ITEMS AS (
                SELECT DISTINCT ITEM_ID FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK) WHERE MEASURE = N'CELL_EOH'
            )
            SELECT '#DBG_7_BOM_DETAIL_AS_CHILD' AS DBG_TAG,
                   CE.ITEM_ID, B.MODEL_ID, B.CELL_TYPE, B.ELECTRODE_TYPE, COUNT(*) AS BOM_CNT
              FROM CE_ITEMS CE
             INNER JOIN #BOM_FULL_CACHE B WITH(NOLOCK) ON B.CHILD_ITEM_ID = CE.ITEM_ID
             GROUP BY CE.ITEM_ID, B.MODEL_ID, B.CELL_TYPE, B.ELECTRODE_TYPE
             ORDER BY CE.ITEM_ID, B.CELL_TYPE;

            ;WITH CE_ITEMS AS (
                SELECT DISTINCT ITEM_ID FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK) WHERE MEASURE = N'CELL_EOH'
            )
            SELECT '#DBG_7_BOM_DETAIL_AS_MODEL' AS DBG_TAG,
                   CE.ITEM_ID, B.CHILD_ITEM_ID, B.CELL_TYPE, B.ELECTRODE_TYPE, COUNT(*) AS BOM_CNT
              FROM CE_ITEMS CE
             INNER JOIN #BOM_FULL_CACHE B WITH(NOLOCK) ON B.MODEL_ID = CE.ITEM_ID
             GROUP BY CE.ITEM_ID, B.CHILD_ITEM_ID, B.CELL_TYPE, B.ELECTRODE_TYPE
             ORDER BY CE.ITEM_ID, B.CELL_TYPE;

            -- DBG-8: 가설 검증 — CELL_TYPE='CP' 의 CHILD 로 등장 시 FG
            --   기대: MCCM(cell) = FG, MACM(module) = SEMI
            ;WITH CE AS (
                SELECT P.ITEM_ID, COUNT(*) AS CE_CNT
                  FROM #PSI_GLOBAL_SMALL_AUTO P WITH(NOLOCK)
                 WHERE P.MEASURE = N'CELL_EOH'
                 GROUP BY P.ITEM_ID
            )
            SELECT '#DBG_8_FG_BY_CELL_TYPE_CP' AS DBG_TAG,
                   CE.ITEM_ID, CE.CE_CNT,
                   CASE WHEN EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                                      WHERE B.CHILD_ITEM_ID = CE.ITEM_ID AND B.CELL_TYPE = 'CP')
                        THEN 'YES' ELSE 'NO' END AS IS_CP_CHILD,
                   CASE WHEN EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                                      WHERE B.MODEL_ID = CE.ITEM_ID AND B.CELL_TYPE = 'CP')
                        THEN 'YES' ELSE 'NO' END AS IS_CP_MODEL,
                   CASE WHEN EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                                      WHERE B.CHILD_ITEM_ID = CE.ITEM_ID AND B.CELL_TYPE = 'CP')
                        THEN 'FG (CP-Child)' ELSE 'SEMI' END AS TYPE_GUESS_A
              FROM CE
             ORDER BY CE.ITEM_ID;
        END;

        -- 2026-05-28 김준규 비활성화: [C-0.5] CELL_EOH 누락 보정 블록 전체 주석처리.
        --   사유: 메인 파이프라인(L3305 경로1 / L3362 경로2)이 AS-WAS CELL_EOH 생성을
        --         100% 포팅함을 확인. [C-0.5] 보정은 중복/과다 생성 위험.
        --   조치: 재실행하여 AS-WAS 와 CELL_EOH 비교 후 문제없으면 완전 제거 예정.
        --   복구: 아래 /* */ 제거 시 원복.
        -- ============================================================================
        /* ===== [C-0.5] DISABLED START =====
        -- ============================================================================
        -- [C-0.5] 2026-05-27 김준규 신규: CELL_EOH 누락 보정 (FG only)
        --   배경: SHEET_TYPE='PROD' 인 (FROM_SITE, CELL_ITEM_ID) 그룹에 CELL_EOH 가
        --         반드시 존재해야 함. 누락 시 [1] 복제도 빠져 RPT PROD sheet 가 비게 됨.
        --   범위: FG (CP-Child) 만 — SEMI 는 후속 [C-3] 에서 CELL_EOH 제거되므로 제외
        --   source: 모든 PROD measure (CELL_PROD 만 있는 게 아니므로 — 신규 ITEM 대응)
        --   처리: 그룹별 TOP 1 row 만 추가
        --   YYYYMMDD: @p_plan_start_yyyymmdd ([C-2] EOH_TOTAL 패턴 동일)
        --   ATTRIBUTE1: N'SCP_ANL_SHIPMENT_PLAN_FG' (원본 CELL_EOH/SHIP measure 와 동일 — 2026-05-28 변경, 기존 SCP_SYNTHETIC_CELL_EOH 에서)
        --     → [1] 복제 시 SEMI_SHIP_PLAN_TOTAL/SHIP_PLAN_TOTAL 에도 마커 전파
        --     → 후속 디버깅/감사 시 합성 row 식별 가능
        -- ============================================================================
        INSERT INTO #PSI_GLOBAL_SMALL_AUTO
        SELECT  S.DIVISION_ID, S.OPERATION_GROUP, S.CELL_ITEM_ID, S.CELL_ITEM_ID AS ITEM_ID, S.TO_SITE, S.PROJECT_CODE     -- 2026-05-27 김준규: ITEM_ID=CELL_ITEM_ID 강제 (Pure FG view, PIVOT L9437 통과 보장)
              , S.TO_BOH_QTY, S.FROM_BOH_QTY, S.INCOTERMS, S.FROM_SITE, S.TRANSPORT_MODE, S.PROD_LINE
              , N'CELL_EOH'                                          AS MEASURE
              , @p_plan_start_yyyymmdd                               AS YYYYMMDD          -- 의견 2
              , CONVERT(NUMERIC(20,10), NULL)                        AS QTY                -- 사용자 요구: NULL
              , ISNULL(M.SORT_ORDER_NO, 200)                         AS SORT_ORDER_NO
              , ISNULL(M.COLUMN_LABEL_NAME, N'CELL EOH')             AS COLUMN_LABEL_NAME
              , S.BOD_ID
              , N'SCP_ANL_SHIPMENT_PLAN_FG'                          AS ATTRIBUTE1        -- 2026-05-28 김준규: 원본 CELL_EOH 와 동일 값 (기존 SCP_SYNTHETIC_CELL_EOH → SHIPMENT_PLAN_FG 통일)
              , S.ATTRIBUTE9
          FROM (
                SELECT P.*
                     , ROW_NUMBER() OVER (PARTITION BY P.CELL_ITEM_ID, P.FROM_SITE
                                          ORDER BY CASE WHEN P.MEASURE = N'CELL_PROD' THEN 0                          -- 1순위: CELL_PROD
                                                        WHEN P.MEASURE IN (N'CELL_FOR_FORM_END', N'CELL_PROD_FORM_END',
                                                                           N'CELL_FORM_PROGRESS', N'CELL_FORM_HOLD_UNDER_AVAILABLE',
                                                                           N'CELL_FORM_HOLD_AFTER') THEN 1               -- 2순위: 기타 PROD measure
                                                        WHEN P.MEASURE = N'CELL_EOH' THEN 3                          -- 후순위: 하이브리드 CELL_EOH (가능하면 회피)
                                                        ELSE 2 END                                          ASC     -- 3순위: 그 외 모든 measure (shipment 등) — 2026-05-28 폴백
                                                  ,P.MEASURE                                            ASC     -- 결정성 보장
                                                  ,P.YYYYMMDD                                           ASC) AS RN
                  FROM #PSI_GLOBAL_SMALL_AUTO P WITH(NOLOCK)
                 -- 2026-05-28 김준규: MEASURE IN (...) 필터 제거 — 리스트 외 measure(shipment 등)만 가진 FG 그룹도
                 --                    누락 보정 대상에 포함. 템플릿은 위 ORDER BY 로 PROD measure 우선 선택, 없으면 폴백.
                 WHERE EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                                WHERE B.CHILD_ITEM_ID = P.CELL_ITEM_ID                                    -- 2026-05-27 김준규: ITEM_ID -> CELL_ITEM_ID (하이브리드 (FG cell, SEMI item) 대응)
                                  AND B.CELL_TYPE     = 'CP')                                            -- FG (CP-Child) 만
                   AND NOT EXISTS (SELECT 1 FROM #PSI_GLOBAL_SMALL_AUTO P2 WITH(NOLOCK)
                                    WHERE P2.CELL_ITEM_ID = P.CELL_ITEM_ID
                                      AND P2.FROM_SITE    = P.FROM_SITE
                                      AND P2.CELL_ITEM_ID = P2.ITEM_ID                                   -- 2026-05-27 김준규: Pure FG(CELL_ITEM_ID=ITEM_ID) CELL_EOH 만 인정 (하이브리드 row 는 PIVOT 단계 L9437 에서 제외되므로 미포함)
                                      AND P2.MEASURE      = N'CELL_EOH')                                 -- CELL_EOH 누락 그룹만
               ) S
          LEFT JOIN #MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME = N'CELL_EOH'
         WHERE S.RN = 1;                                                                                  -- TOP 1
        DECLARE @v_c05_ins INT = @@ROWCOUNT;
PRINT N'--A@X#02610_C05_INS-- 누락 CELL_EOH 보정: ' + CAST(@v_c05_ins AS NVARCHAR(20));

        -- DBG-8.5: [C-0.5] 합성 row 확인
        IF @v_is_debug = 1
        BEGIN
            SELECT '#DBG_8_5_C05_SYNTHETIC' AS DBG_TAG,
                   CELL_ITEM_ID, FROM_SITE, ITEM_ID, OPERATION_GROUP,
                   YYYYMMDD, MEASURE, ATTRIBUTE1, ATTRIBUTE9
              FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
             WHERE MEASURE  = N'CELL_EOH'                            -- 2026-05-28: 합성 row 식별 (ATTRIBUTE1 통일로 QTY/YYYYMMDD 기준 변경)
               AND QTY      IS NULL
               AND YYYYMMDD = @p_plan_start_yyyymmdd
             ORDER BY CELL_ITEM_ID, FROM_SITE;
        END;
        ===== [C-0.5] DISABLED END ===== */

        -- ════════════════════════════════════════════════════════════════════
        -- 2026-05-29 김준규 [합성 CELL measure 중복 제거] (CELL_EOH 2줄 현상 해결)
        --   원인: #ITEM_ID 가 (CELL_ITEM_ID,ITEM_ID,FROM_SITE) 당 TO_SITE/PROD_LINE 변형마다 여러 행 →
        --         경로1/경로2 가 변형마다 합성 CELL measure 생성 (FROM_BOH_QTY/ATTRIBUTE1 차이로
        --         SELECT DISTINCT 가 dedup 못함). 기존엔 L4190 DELETE 가 전부 지워 0개로 가려졌으나,
        --         CELL_EOH 소멸 버그픽스 이후 2개가 모두 살아남아 중복 출력됨.
        --   조치: 동일 (key, MEASURE, YYYYMMDD) 합성 CELL measure 는 1행만 유지 (FROM_BOH_QTY/QTY 큰 것 우선).
        --   대상: CELL% 중 CELL_PROD/LOAD/MEMO/CHAR_PLAN(원본 재INSERT) 제외.
        ;WITH cell_dup AS (
            SELECT ROW_NUMBER() OVER (
                       PARTITION BY DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD
                       ORDER BY ISNULL(FROM_BOH_QTY,0) DESC, ISNULL(QTY,0) DESC, ATTRIBUTE1, ATTRIBUTE9
                   ) AS rn
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE MEASURE LIKE 'CELL[_]%'
               AND MEASURE NOT IN (N'CELL_PROD', N'CELL_PROD_LOAD', N'CELL_PROD_MEMO', N'CELL_CHAR_PLAN')
        )
        DELETE FROM cell_dup WHERE rn > 1;
        DECLARE @v_cell_dedup INT = @@ROWCOUNT;
        PRINT N'--A@X#02610_CELL_DEDUP-- 합성 CELL 중복 제거: ' + CAST(@v_cell_dedup AS NVARCHAR(20));

        -- [1] CELL_EOH → SEMI_SHIP_PLAN_TOTAL + SHIP_PLAN_TOTAL 복제 (CELL_EOH 모든 row × 2)
        INSERT INTO #PSI_GLOBAL_SMALL_AUTO
        SELECT  P.DIVISION_ID, P.OPERATION_GROUP, P.CELL_ITEM_ID, P.ITEM_ID
              -- 2026-05-29 김준규 [Issue1]: TOTAL measure 는 속성 blank (CELL_EOH 값 복사 금지). FROM_BOH_QTY/PROD_LINE 등 → '-'/NULL
              , N'-' AS TO_SITE, N'-' AS PROJECT_CODE
              , CONVERT(NUMERIC(20,10), NULL) AS TO_BOH_QTY, CONVERT(NUMERIC(20,10), NULL) AS FROM_BOH_QTY
              , N'-' AS INCOTERMS, P.FROM_SITE, N'-' AS TRANSPORT_MODE, N'-' AS PROD_LINE
              , X.MEASURE_NEW                                          AS MEASURE
              , P.YYYYMMDD
              , CONVERT(NUMERIC(20,10), NULL)                          AS QTY                -- 사용자 요구: NULL
              , ISNULL(M.SORT_ORDER_NO, X.SORT_ORDER_DEFAULT)          AS SORT_ORDER_NO
              , ISNULL(M.COLUMN_LABEL_NAME, X.LABEL_DEFAULT)           AS COLUMN_LABEL_NAME
              , N'-' AS BOD_ID, P.ATTRIBUTE1, P.ATTRIBUTE9
          FROM #PSI_GLOBAL_SMALL_AUTO P
         CROSS APPLY (VALUES
                (N'SEMI_SHIP_PLAN_TOTAL', 190, N'SEMI SHIP PLAN TOTAL'),
                (N'SHIP_PLAN_TOTAL',      195, N'SHIP PLAN TOTAL')
             ) X(MEASURE_NEW, SORT_ORDER_DEFAULT, LABEL_DEFAULT)
          LEFT JOIN #MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME = X.MEASURE_NEW
         WHERE P.MEASURE = N'CELL_EOH'
           AND EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                        WHERE B.CHILD_ITEM_ID = P.ITEM_ID    -- 2026-05-27 김준규: rollback to ITEM_ID (하이브리드 row 의 SHIP_PLAN_TOTAL 중복 복제 방지, [C-0.5] 합성 Pure FG row 만 복제됨)
                          AND B.CELL_TYPE     = 'CP');   -- 2026-05-22 김준규: FG = Cell Product (CP-Child)
        DECLARE @v_c1_ins INT = @@ROWCOUNT;
PRINT '--A@X#02611_C1_INS-- ' + CAST(@v_c1_ins AS NVARCHAR(20));

        -- [2] CELL_ITEM_ID + FROM_SITE 그룹별 YYYYMMDD MAX row 1개씩 → EOH_TOTAL 복제
        --   2026-05-22 김준규 변경 (옵션 B): WHERE MEASURE='CELL_EOH' → OPERATION_GROUP='A'
        --     이유: CELL_EOH 가 없는 그룹도 EOH_TOTAL 보장 (RPT 의 그룹별 마지막 line)
        --     ORDER BY 결정성: YYYYMMDD DESC → CELL_EOH 우선 → MEASURE 알파벳 (동률 처리)
        --     [C-1] 에서 방금 추가된 SEMI_SHIP_PLAN_TOTAL/SHIP_PLAN_TOTAL 은 사본이므로 제외
        INSERT INTO #PSI_GLOBAL_SMALL_AUTO
        SELECT  T.DIVISION_ID, T.OPERATION_GROUP, T.CELL_ITEM_ID, T.ITEM_ID
              -- 2026-05-29 김준규 [Issue1]: EOH_TOTAL 속성 blank (그룹 MAX row 의 값 복사 금지)
              , N'-' AS TO_SITE, N'-' AS PROJECT_CODE
              , CONVERT(NUMERIC(20,10), NULL) AS TO_BOH_QTY, CONVERT(NUMERIC(20,10), NULL) AS FROM_BOH_QTY
              , N'-' AS INCOTERMS, T.FROM_SITE, N'-' AS TRANSPORT_MODE, N'-' AS PROD_LINE
              , N'EOH_TOTAL'                                           AS MEASURE
              , @p_plan_start_yyyymmdd                                  AS YYYYMMDD          -- 2026-05-22 김준규 수정: T.YYYYMMDD (그룹별 MAX) → @p_plan_start_yyyymmdd (계획 시작일 고정)
              , CONVERT(NUMERIC(20,10), NULL)                          AS QTY                -- 사용자 요구: NULL
              , ISNULL(M.SORT_ORDER_NO, 270)                           AS SORT_ORDER_NO
              , ISNULL(M.COLUMN_LABEL_NAME, N'EOH TOTAL')              AS COLUMN_LABEL_NAME
              , N'-' AS BOD_ID, T.ATTRIBUTE1, T.ATTRIBUTE9
          FROM (
                SELECT P.*
                     , ROW_NUMBER() OVER (PARTITION BY P.CELL_ITEM_ID, P.FROM_SITE
                                          ORDER BY P.YYYYMMDD                                       DESC
                                                  ,CASE WHEN P.MEASURE = N'CELL_EOH' THEN 0 ELSE 1 END  ASC
                                                  ,P.MEASURE                                        ASC) AS RN
                  FROM #PSI_GLOBAL_SMALL_AUTO P
                 WHERE P.OPERATION_GROUP = 'A'
                   AND P.MEASURE NOT IN (N'SEMI_SHIP_PLAN_TOTAL', N'SHIP_PLAN_TOTAL')
                   AND NOT EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                                    WHERE B.CHILD_ITEM_ID = P.ITEM_ID
                                      AND B.CELL_TYPE     = 'CP')   -- 2026-05-22 김준규: SEMI = NOT Cell Product
               ) T
          LEFT JOIN #MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME = N'EOH_TOTAL'
         WHERE T.RN = 1;
        DECLARE @v_c2_ins INT = @@ROWCOUNT;
PRINT '--A@X#02612_C2_INS-- EOH_TOTAL:' + CAST(@v_c2_ins AS NVARCHAR(20));

        -- ============================================================================
        -- 2026-06-09 김준규 [C-2-보충]: CELL_EOH 존재 그룹 중 EOH_TOTAL 누락분 추가
        --   사유: 위 [2] 드라이버는 'NOT EXISTS(BOM CP)'(SEMI) 필터라, CELL_EOH 의 ITEM_ID 가
        --         Cell Product(CP) 인 그룹은 드라이버에서 제외되어 EOH_TOTAL 이 누락됨.
        --   요구: (FROM_SITE, CELL_ITEM_ID) 별 CELL_EOH 가 존재하면 반드시 EOH_TOTAL 표시.
        --   방식: CELL_EOH 그룹 중 EOH_TOTAL 미존재 그룹만 가산(중복 방지 NOT EXISTS).
        -- ============================================================================
        INSERT INTO #PSI_GLOBAL_SMALL_AUTO
        SELECT  Z.DIVISION_ID, Z.OPERATION_GROUP, Z.CELL_ITEM_ID, Z.ITEM_ID
              , N'-' AS TO_SITE, N'-' AS PROJECT_CODE
              , CONVERT(NUMERIC(20,10), NULL) AS TO_BOH_QTY, CONVERT(NUMERIC(20,10), NULL) AS FROM_BOH_QTY
              , N'-' AS INCOTERMS, Z.FROM_SITE, N'-' AS TRANSPORT_MODE, N'-' AS PROD_LINE
              , N'EOH_TOTAL'                                           AS MEASURE
              , @p_plan_start_yyyymmdd                                  AS YYYYMMDD
              , CONVERT(NUMERIC(20,10), NULL)                          AS QTY
              , ISNULL(M.SORT_ORDER_NO, 270)                           AS SORT_ORDER_NO
              , ISNULL(M.COLUMN_LABEL_NAME, N'EOH TOTAL')              AS COLUMN_LABEL_NAME
              , N'-' AS BOD_ID, Z.ATTRIBUTE1, Z.ATTRIBUTE9
          FROM (
                SELECT P.DIVISION_ID, P.OPERATION_GROUP, P.CELL_ITEM_ID, P.ITEM_ID
                     , P.FROM_SITE, P.ATTRIBUTE1, P.ATTRIBUTE9
                     , ROW_NUMBER() OVER (PARTITION BY P.CELL_ITEM_ID, P.FROM_SITE
                                          ORDER BY P.YYYYMMDD DESC) AS RN
                  FROM #PSI_GLOBAL_SMALL_AUTO P WITH(NOLOCK)
                 WHERE P.MEASURE = N'CELL_EOH'                                  -- CELL_EOH 존재 그룹
                   AND NOT EXISTS (SELECT 1 FROM #PSI_GLOBAL_SMALL_AUTO E WITH(NOLOCK)
                                    WHERE E.MEASURE      = N'EOH_TOTAL'
                                      AND E.CELL_ITEM_ID = P.CELL_ITEM_ID
                                      AND E.FROM_SITE    = P.FROM_SITE)         -- 이미 있으면 제외(중복 방지)
               ) Z
          LEFT JOIN #MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME = N'EOH_TOTAL'
         WHERE Z.RN = 1;
        DECLARE @v_c2b_ins INT = @@ROWCOUNT;
PRINT '--A@X#02612_C2B_INS-- EOH_TOTAL(CELL_EOH 보충):' + CAST(@v_c2b_ins AS NVARCHAR(20));

        -- DBG-9: [C-2] 직후 EOH_TOTAL row 상세 (속성 포함)
        IF @v_is_debug = 1
        BEGIN
            SELECT '#DBG_9_EOH_TOTAL_AFTER_C2_DETAIL' AS DBG_TAG,
                   COUNT(*) AS EOH_TOTAL_CNT
              FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
             WHERE MEASURE = N'EOH_TOTAL';

            SELECT TOP 5 '#DBG_9_EOH_TOTAL_ROW' AS DBG_TAG,
                   DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, FROM_SITE,
                   YYYYMMDD, MEASURE, ATTRIBUTE1, ATTRIBUTE9, SORT_ORDER_NO, COLUMN_LABEL_NAME
              FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
             WHERE MEASURE = N'EOH_TOTAL';

            -- DBG-10: [C-2] source 가 어떻게 보이는지 (NOT EXISTS 통과한 row 중 RN=1 후보)
            SELECT TOP 10 '#DBG_10_C2_SOURCE_TOP' AS DBG_TAG,
                   ITEM_ID, CELL_ITEM_ID, FROM_SITE, YYYYMMDD, MEASURE,
                   ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, FROM_SITE
                                      ORDER BY YYYYMMDD DESC,
                                              CASE WHEN MEASURE = N'CELL_EOH' THEN 0 ELSE 1 END,
                                              MEASURE) AS RN
              FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
             WHERE OPERATION_GROUP = 'A'
               AND MEASURE NOT IN (N'SEMI_SHIP_PLAN_TOTAL', N'SHIP_PLAN_TOTAL', N'EOH_TOTAL')
               AND NOT EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                                WHERE B.CHILD_ITEM_ID = #PSI_GLOBAL_SMALL_AUTO.ITEM_ID
                                  AND B.CELL_TYPE     = 'CP')
             ORDER BY CELL_ITEM_ID, FROM_SITE, YYYYMMDD DESC;

            -- DBG-11: SEMI ITEM 만 골라 measure 별 분포
            SELECT '#DBG_11_SEMI_ITEM_MEASURE_DIST' AS DBG_TAG,
                   ITEM_ID, MEASURE, COUNT(*) AS CNT
              FROM #PSI_GLOBAL_SMALL_AUTO P WITH(NOLOCK)
             WHERE P.OPERATION_GROUP = 'A'
               AND NOT EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                                WHERE B.CHILD_ITEM_ID = P.ITEM_ID
                                  AND B.CELL_TYPE     = 'CP')
             GROUP BY ITEM_ID, MEASURE
             ORDER BY ITEM_ID, MEASURE;
        END;

        IF @v_is_debug = 1
            SELECT '#PSI_GLOBAL_SMALL_AUTO_NEW_MEASURE' AS "#PSI_GLOBAL_SMALL_AUTO_NEW_MEASURE",
                   MEASURE, COUNT(*) AS CNT
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE MEASURE IN (N'CELL_EOH', N'SEMI_SHIP_PLAN_TOTAL', N'SHIP_PLAN_TOTAL', N'EOH_TOTAL')
             GROUP BY MEASURE
             ORDER BY MEASURE;

        -- ============================================================================
        -- 2026-05-22 김준규 신규: ITEM_TYPE 별 부적합 measure 제거
        --   목적: AS-WAS PR_SCP_XLS_DAILY_SMALL L306~307 의 동일 패턴
        --   ITEM_TYPE 판단: #BOM_FULL_CACHE 의 CELL_TYPE='CP' CHILD_ITEM_ID 등장 여부
        --     FG  (Cell Product, CHILD AND CELL_TYPE='CP' 으로 등장,    EXISTS) : FORM 4종 제외
        --     SEMI (NOT Cell Product, 위 조건 NOT EXISTS)                : CELL_EOH, CELL_FORM_HOLD_AFTER 제외
        --   검증 (DBG-8): MCCM(cell)=FG, MACM(module)=SEMI 정상 동작
        --   #BOM_FULL_CACHE 인덱스 활용 가능 (CHILD_ITEM_ID 는 별도 인덱스 없지만 캐시 row 작음)
        -- ============================================================================
        DECLARE @v_itype_filter_cnt INT;

        -- DBG-4: DELETE 직전 PROD 측 measure 분포
        IF @v_is_debug = 1
            SELECT '#DBG_4_BEFORE_DELETE_BY_MEASURE' AS DBG_TAG,
                   MEASURE, COUNT(*) AS CNT
              FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
             WHERE OPERATION_GROUP = 'A'
             GROUP BY MEASURE
             ORDER BY MEASURE;

        DELETE X
          FROM #PSI_GLOBAL_SMALL_AUTO X
         WHERE X.OPERATION_GROUP = 'A'
           AND (
               -- FG (Cell Product): FORM 관련 4종 제외
               (EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                         WHERE B.CHILD_ITEM_ID = X.ITEM_ID AND B.CELL_TYPE = 'CP')
                AND X.MEASURE IN (N'CELL_FOR_FORM_END', N'CELL_PROD_FORM_END',
                                  N'CELL_FORM_PROGRESS', N'CELL_FORM_HOLD_UNDER_AVAILABLE'))
            OR -- SEMI (NOT Cell Product): CELL_EOH, CELL_FORM_HOLD_AFTER 제외
               (NOT EXISTS (SELECT 1 FROM #BOM_FULL_CACHE B WITH(NOLOCK)
                             WHERE B.CHILD_ITEM_ID = X.CELL_ITEM_ID                   -- 2026-05-27 김준규: ITEM_ID -> CELL_ITEM_ID (하이브리드 (FG cell, SEMI item) 대응)
                               AND B.CELL_TYPE = 'CP')
                AND X.MEASURE IN (N'CELL_EOH', N'CELL_FORM_HOLD_AFTER'))
               );
        SET @v_itype_filter_cnt = @@ROWCOUNT;

        -- DBG-5: DELETE 직후 PROD 측 measure 분포 (변화 확인)
        IF @v_is_debug = 1
            SELECT '#DBG_5_AFTER_DELETE_BY_MEASURE' AS DBG_TAG,
                   MEASURE, COUNT(*) AS CNT
              FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
             WHERE OPERATION_GROUP = 'A'
             GROUP BY MEASURE
             ORDER BY MEASURE;

        -- DBG-6: 잔여 CELL_EOH 의 ITEM_ID 분포 (FG ITEM 만 남아야 정상)
        IF @v_is_debug = 1
            BEGIN
            SELECT TOP 20 '#DBG_6_REMAINING_CELL_EOH_ITEMS' AS DBG_TAG,
                   ITEM_ID, COUNT(*) AS CNT
              FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
             WHERE OPERATION_GROUP = 'A' AND MEASURE = N'CELL_EOH'
             GROUP BY ITEM_ID
             ORDER BY ITEM_ID;

            SELECT TOP 100 '#CELL_EOH_ITEM' AS DBG_TAG, *
              FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
             WHERE OPERATION_GROUP = 'A' AND MEASURE = N'CELL_EOH'
             ORDER BY ITEM_ID;

            SELECT TOP 100 '#CELL_EOH_TOTAL_ITEM' AS DBG_TAG, *
              FROM #PSI_GLOBAL_SMALL_AUTO WITH(NOLOCK)
             WHERE OPERATION_GROUP = 'A' AND MEASURE = N'EOH_TOTAL'
             ORDER BY ITEM_ID;
        END;

        IF @v_is_debug = 1
            SELECT '#PSI_GLOBAL_SMALL_AUTO_AFTER_ITYPE_FILTER' AS "#PSI_GLOBAL_SMALL_AUTO_AFTER_ITYPE_FILTER",
                   MEASURE, COUNT(*) AS CNT
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE OPERATION_GROUP = 'A'
             GROUP BY MEASURE
             ORDER BY MEASURE;

PRINT '--A@X#02620_ITYPE_FILTER-- DEL:' + CAST(@v_itype_filter_cnt AS NVARCHAR(20)) + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

PRINT '--A@X#02610_NEW_MEASURE--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        -- (2-4) CELL_FORM_HOLD_AFTER 의 QTY 보정 (CP/CA1 합산, FG 만)
        IF OBJECT_ID('tempdb..#HOLD_AFTER_AGG') IS NOT NULL DROP TABLE #HOLD_AFTER_AGG;
        SELECT
             FI.attribute1                  AS CELL_ITEM_ID
            ,A.FROM_SITE
            ,A.YYYYMMDD
            ,SUM(A.QTY)                     AS QTY_SUM
        INTO #HOLD_AFTER_AGG
        FROM #PSI_GLOBAL_SMALL_AUTO A
        INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
            ON FI.ITEM_ID = A.ITEM_ID
           AND FI.attribute8 IN ('CP', 'CA1')
        WHERE A.MEASURE = N'CELL_FORM_HOLD_AFTER'
        GROUP BY FI.attribute1, A.FROM_SITE, A.YYYYMMDD;

        UPDATE A
           SET A.QTY = ISNULL(H.QTY_SUM, 0)
          FROM #PSI_GLOBAL_SMALL_AUTO A
          LEFT JOIN #HOLD_AFTER_AGG H
            ON H.CELL_ITEM_ID = A.CELL_ITEM_ID
           AND H.FROM_SITE    = A.FROM_SITE
           AND H.YYYYMMDD     = A.YYYYMMDD
         WHERE A.MEASURE      = N'CELL_FORM_HOLD_AFTER'
           AND A.CELL_ITEM_ID = A.ITEM_ID;

        IF OBJECT_ID('tempdb..#HOLD_AFTER_AGG') IS NOT NULL DROP TABLE #HOLD_AFTER_AGG;


        ----------------------------------------------------------------------
        -- 2026-05-09 김준규 신규: [PATCH] PR_SCP_XLS_PSI_GLOBAL_SMALL_S PIVOT 이후 UPDATE 보완 — 시작
        --   원본 출처: PR_SCP_XLS_PSI_GLOBAL_SMALL_S (라인 915~2724)
        --   적용 위치: (2-5) DELETE QTY=0 직전 (skeleton 행 보존된 상태)
        --   적용 정책: UPDATE FROM JOIN (MERGE 불필요, 행 이미 존재)
        --   옵션 B 적용: #PSI_GLOBAL_SMALL_AUTO 에 LT_DAY/ATTRIBUTE3/ATTRIBUTE10 컬럼 추가
        --     → ALTER TABLE 사용으로 기존 31개 INSERT 무수정 (모든 INSERT 완료된 후 컬럼 추가)
        ----------------------------------------------------------------------
        PRINT '--A@X#02400_PATCH_START--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        -- A.0 옵션 B: 4개 컬럼 추가 (NULL 허용)
        --   기존 INSERT 31건은 이미 완료되어 새 컬럼은 자동으로 NULL
        --   2026-05-12 김준규: TEAM 추가 (DBO.FN_XLS_TEAM 으로 PRE-PIVOT UPDATE)
        ALTER TABLE #PSI_GLOBAL_SMALL_AUTO ADD
             LT_DAY       NUMERIC(20,4)  NULL
            ,ATTRIBUTE3   NVARCHAR(150)  NULL
            ,ATTRIBUTE10  NVARCHAR(150)  NULL
            ,TEAM         NVARCHAR(50)   NULL;     -- 신규: DBO.FN_XLS_TEAM 결과 저장용

PRINT '--A@X#02401_TEAM_START--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        -- 2026-05-12 김준규: PRE-PIVOT TEAM UPDATE (unique 키별 캐싱 — 가장 빠름)
        --   FN_XLS_TEAM 인자 = (DIVISION_ID, TO_SITE, ITEM_ID, PROJECT_CODE)
        --   같은 조합 = 같은 TEAM → DISTINCT 후 함수 호출 → JOIN UPDATE
        --   효과: 함수 호출 = 전체 행 → unique 키 수 (보통 100~1000배 감소)
        IF OBJECT_ID('tempdb..#TEAM_CACHE') IS NOT NULL DROP TABLE #TEAM_CACHE;
        SELECT DISTINCT A.DIVISION_ID, A.TO_SITE, A.ITEM_ID, A.PROJECT_CODE,
               DBO.FN_XLS_TEAM(A.DIVISION_ID, A.TO_SITE, A.ITEM_ID, A.PROJECT_CODE) AS TEAM
          INTO #TEAM_CACHE
          FROM #PSI_GLOBAL_SMALL_AUTO A WITH(NOLOCK);

        CREATE UNIQUE CLUSTERED INDEX IX_TC ON #TEAM_CACHE
            (DIVISION_ID, TO_SITE, ITEM_ID, PROJECT_CODE);

        UPDATE A
           SET A.TEAM = T.TEAM
          FROM #PSI_GLOBAL_SMALL_AUTO A
         INNER JOIN #TEAM_CACHE T WITH(NOLOCK)
            ON  A.DIVISION_ID  = T.DIVISION_ID
            AND A.TO_SITE      = T.TO_SITE
            AND A.ITEM_ID      = T.ITEM_ID
            AND A.PROJECT_CODE = T.PROJECT_CODE;

PRINT '--A@X#02402_BOH_START--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        -- [DEBUG] TEAM 적재 결과 확인
        IF @v_is_debug = 1
            SELECT '#PSI_GLOBAL_SMALL_AUTO_TEAM' AS "TEAM_CHECK",
                   COUNT(*)                AS TOTAL_ROWS,
                   COUNT(TEAM)             AS TEAM_NOT_NULL_ROWS,
                   COUNT(*) - COUNT(TEAM)  AS TEAM_NULL_ROWS
              FROM #PSI_GLOBAL_SMALL_AUTO;

        ----------------------------------------------------------------------
        -- A.1 임시테이블 생성 (S 원본 그대로)
        ----------------------------------------------------------------------

        -- 2026-05-14 김준규 [STAGING]: SCP_XLS_BOH 2번 스캔 → 1번으로 통합
        --   #BOH 와 #BOH_NHOLD 가 동일 source + 동일 필터 5개 + GROUP BY 만 약간 다름
        --   → #STG_BOH 사전 빌드 후 두 곳에서 재사용
        IF OBJECT_ID('tempdb..#STG_BOH') IS NOT NULL DROP TABLE #STG_BOH;
        SELECT *
          INTO #STG_BOH
          FROM SCP_XLS_BOH WITH(NOLOCK)
         WHERE DIVISION_ID         = @P_DIVISION_ID
           AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
           AND PLAN_TYPE           = @P_PLAN_TYPE
           AND SEQ                 = @P_PLAN_SEQ
           AND ISNULL(ORIGIN_ITEM_ID,'') = ''
        OPTION (RECOMPILE);

        CREATE NONCLUSTERED INDEX IX_stg_boh_group
            ON #STG_BOH (SCM_SITE_ID, ITEM_ID, INCOTERMS)
            INCLUDE (QTY, ATTRIBUTE1, ATTRIBUTE10);

PRINT '--A@X#02403_STG_BOH--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        -- [DEBUG]
        IF @v_is_debug = 1 SELECT '#STG_BOH' AS "#STG_BOH", COUNT(*) AS row_cnt FROM #STG_BOH;

        -- A.1.1 #BOH (S:1937~1962)
        IF OBJECT_ID('tempdb..#BOH') IS NOT NULL DROP TABLE #BOH;
        SELECT  DIVISION_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_TYPE
               ,SEQ
               ,SCM_SITE_ID
               ,INCOTERMS
               ,ITEM_ID
               ,MAX(ATTRIBUTE1) AS FROM_SCM_SITE_ID
               ,SUM(QTY)        AS QTY
          INTO #BOH
          FROM #STG_BOH WITH (NOLOCK)
         GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ
                , SCM_SITE_ID, INCOTERMS, ITEM_ID;

        CREATE NONCLUSTERED INDEX IX_BOH_KEY ON #BOH (SCM_SITE_ID, ITEM_ID, INCOTERMS, FROM_SCM_SITE_ID);

        -- A.1.2 #BOH_NHOLD (Hold 미포함, S:1981~2006)
        IF OBJECT_ID('tempdb..#BOH_NHOLD') IS NOT NULL DROP TABLE #BOH_NHOLD;
        SELECT  DIVISION_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_TYPE
               ,SEQ
               ,SCM_SITE_ID
               ,INCOTERMS
               ,ITEM_ID
               ,SUM(QTY) AS QTY
          INTO #BOH_NHOLD
          FROM #STG_BOH WITH (NOLOCK)
         WHERE NOT ATTRIBUTE10 LIKE '%HOLD'
         GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ
                , SCM_SITE_ID, INCOTERMS, ITEM_ID;

        CREATE NONCLUSTERED INDEX IX_BOH_NHOLD_KEY ON #BOH_NHOLD (SCM_SITE_ID, ITEM_ID);

        -- A.1.3 #tmp_SCP_MST_TACT_TIME (S:915~929)
        IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL DROP TABLE #tmp_SCP_MST_TACT_TIME;
        SELECT *
          INTO #tmp_SCP_MST_TACT_TIME
          FROM (
                SELECT DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID, YIELD
                  FROM SCP_MST_TACT_TIME WITH(NOLOCK)
                 WHERE DIVISION_ID = @P_DIVISION_ID
                UNION ALL
                SELECT DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID, YIELD
                  FROM SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
                 WHERE DIVISION_ID = @P_DIVISION_ID
               ) X;

        CREATE NONCLUSTERED INDEX IX_TACT_KEY ON #tmp_SCP_MST_TACT_TIME (PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID);

        -- A.1.4 #tmp_SCP_MST_DIO_OLD (S:2220~2237) — DIVISION='81' 제외
        --   2026-05-09 김준규 수정: 단일 CREATE TABLE 후 조건부 INSERT 패턴
        --     사유: IF/ELSE 분기 양쪽에 CREATE 동작이 있으면 SQL Server 컴파일러가 중복 객체 에러 (Msg 2714)
        IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO_OLD') IS NOT NULL DROP TABLE #tmp_SCP_MST_DIO_OLD;
        CREATE TABLE #tmp_SCP_MST_DIO_OLD (
             DIVISION_ID  NVARCHAR(20)
            ,PLANT_ID     NVARCHAR(20)
            ,ITEM_ID      NVARCHAR(50)
            ,GRO_STD_DIO  NUMERIC(28,8)
            ,MIN_STD_DIO  NUMERIC(28,8)
        );

        IF @P_DIVISION_ID <> '81'
        BEGIN
            INSERT INTO #tmp_SCP_MST_DIO_OLD (DIVISION_ID, PLANT_ID, ITEM_ID, GRO_STD_DIO, MIN_STD_DIO)
            SELECT a.DIVISION_ID, a.PLANT_ID, a.ITEM_ID, a.GRO_STD_DIO, a.MIN_STD_DIO
              FROM SCP_MST_DIO A WITH(NOLOCK)
              INNER JOIN (SELECT DIVISION_ID, PLANT_ID, MAX(YYYYQ) AS YYYYQ
                            FROM SCP_MST_DIO WITH(NOLOCK)
                           WHERE DIVISION_ID IS NOT NULL
                           GROUP BY DIVISION_ID, PLANT_ID
                         ) B
                ON A.DIVISION_ID = B.DIVISION_ID
               AND A.PLANT_ID    = B.PLANT_ID
               AND A.YYYYQ       = B.YYYYQ
               AND A.DIVISION_ID = @P_DIVISION_ID;
        END

        CREATE NONCLUSTERED INDEX IX_DIO_KEY ON #tmp_SCP_MST_DIO_OLD (ITEM_ID);

        PRINT '--A@X#02410_PATCH_TMP--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        ----------------------------------------------------------------------
        -- A.2 BOH 데이터 UPDATE (6건) — S 원본 JOIN 키 그대로
        --   #PSI_GLOBAL_SMALL_AUTO 는 LONG 포맷이므로 QTY001 → QTY (WHERE YYYYMMDD=@p_create_from_yyyymmdd)
        ----------------------------------------------------------------------

        -- A.2.1 PACK_BOH ← #BOH_NHOLD (S:2021~2030)
        UPDATE X
           SET X.QTY = ISNULL(Y.QTY, 0)
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN #BOH_NHOLD Y
            ON X.FROM_SITE = Y.SCM_SITE_ID
           AND X.ITEM_ID   = Y.ITEM_ID
         WHERE X.MEASURE     = N'PACK_BOH'
           AND X.YYYYMMDD    = @p_create_from_yyyymmdd
           AND X.DIVISION_ID = @P_DIVISION_ID;

        -- A.2.2 CELL_BOH / PACK_CELL_BOH ← #BOH (S:2046~2060)
        UPDATE X
           SET X.QTY = ISNULL(Y.QTY, 0)
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN #BOH Y
            ON X.FROM_SITE = Y.SCM_SITE_ID
           AND X.ITEM_ID   = Y.ITEM_ID
         WHERE X.MEASURE     IN (N'CELL_BOH', N'PACK_CELL_BOH')
           AND X.YYYYMMDD    = @p_create_from_yyyymmdd
           AND X.DIVISION_ID = @P_DIVISION_ID;

        -- A.2.3 CELL_BOH/PACK_CELL_BOH 보류중 해제일자 없는 수량 차감 (S:2073~2087)
        --   원본: #PLN_TH_ENG_STOCK_PLAN 의 DESCR='WH_HOLD' 행 사용
        IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN') IS NOT NULL
        BEGIN
            UPDATE X
               SET X.QTY = ISNULL(X.QTY, 0) - ISNULL(Y.QTY, 0)
              FROM #PSI_GLOBAL_SMALL_AUTO X
             INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(QTY) AS QTY
                           FROM #PLN_TH_ENG_STOCK_PLAN WITH (NOLOCK)
                          WHERE DESCR ='WH_HOLD'
                          GROUP BY ITEM_ID, FROM_SITE
                         ) Y
                ON X.FROM_SITE = Y.FROM_SITE
               AND X.ITEM_ID   = Y.ITEM_ID
             WHERE X.MEASURE     IN (N'CELL_BOH', N'PACK_CELL_BOH')
               AND X.YYYYMMDD    = @p_create_from_yyyymmdd
               AND X.DIVISION_ID = @P_DIVISION_ID;
        END

        -- A.2.4 TO_SITE_BOH ← #BOH (FROM_SITE 매칭 없는 경우, S:2102~2138)
        UPDATE X
           SET X.QTY = ISNULL(Y.QTY, 0)
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN #BOH Y
            ON X.TO_SITE   = Y.SCM_SITE_ID
           AND X.ITEM_ID   = Y.ITEM_ID
           AND X.INCOTERMS = Y.INCOTERMS
         WHERE X.MEASURE     = N'TO_SITE_BOH'
           AND X.YYYYMMDD    = @p_create_from_yyyymmdd
           AND X.DIVISION_ID = @P_DIVISION_ID
           AND NOT EXISTS (
                SELECT 1 FROM #BOH AS XX
                 WHERE XX.SCM_SITE_ID      = X.TO_SITE
                   AND XX.ITEM_ID          = X.ITEM_ID
                   AND XX.INCOTERMS        = X.INCOTERMS
                   AND XX.FROM_SCM_SITE_ID = X.FROM_SITE
           );

        -- A.2.5 TO_SITE_BOH ← #BOH (FROM_SITE 매칭, S:2155~2168)
        UPDATE X
           SET X.QTY = ISNULL(Y.QTY, 0)
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN #BOH Y
            ON X.TO_SITE   = Y.SCM_SITE_ID
           AND X.ITEM_ID   = Y.ITEM_ID
           AND X.INCOTERMS = Y.INCOTERMS
           AND X.FROM_SITE = Y.FROM_SCM_SITE_ID
         WHERE X.MEASURE     = N'TO_SITE_BOH'
           AND X.YYYYMMDD    = @p_create_from_yyyymmdd
           AND X.DIVISION_ID = @P_DIVISION_ID;

        -- A.2.6 PACK_BOH_WAIT_FOR_INSP ← #PLN_TH_ENG_STOCK_PLAN_INSP (S:2184~)
        --   2026-05-09 김준규 수정: 실제 컬럼명 FROM_SITE 로 보정 (SCM_SITE_ID 컬럼 없음)
        IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_INSP') IS NOT NULL
        BEGIN
            UPDATE X
               SET X.QTY = ISNULL(Y.QTY, 0)
              FROM #PSI_GLOBAL_SMALL_AUTO X
             INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(QTY) AS QTY
                           FROM #PLN_TH_ENG_STOCK_PLAN_INSP WITH (NOLOCK)
                          GROUP BY ITEM_ID, FROM_SITE
                         ) Y
                ON X.FROM_SITE = Y.FROM_SITE
               AND X.ITEM_ID   = Y.ITEM_ID
             WHERE X.MEASURE     = N'PACK_BOH_WAIT_FOR_INSP'
               AND X.YYYYMMDD    = @p_create_from_yyyymmdd
               AND X.DIVISION_ID = @P_DIVISION_ID;
        END

        PRINT '--A@X#02420_PATCH_BOH--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        ----------------------------------------------------------------------
        ----------------------------------------------------------------------
        -- 2026-06-04 김준규: FORM 메저 ITEM_TYPE 제외를 ITEM_ID 보정(A.3) 前에 선적용
        --   사유: 아래 A.3.2(L8643) 가 ITEM_ID = CELL_ITEM_ID 로 덮으면 SEMI 행이 FG 로
        --         둔갑하여, PIVOT WHERE(CELL_ITEM_ID=ITEM_ID 기준) 제외가 무력화됨.
        --         → 원본 ITEM_ID 기준(=AS-WAS ITEM_TYPE 판정)으로 여기서 미리 DELETE.
        --   FG  (CELL_ITEM_ID =  ITEM_ID): FORM 4종 제외
        --   SEMI(CELL_ITEM_ID <> ITEM_ID): CELL_EOH / CELL_FORM_HOLD_AFTER 제외
        ----------------------------------------------------------------------
        DELETE X
          FROM #PSI_GLOBAL_SMALL_AUTO X
         WHERE X.DIVISION_ID = @P_DIVISION_ID
           AND (
                 (X.CELL_ITEM_ID  = X.ITEM_ID  AND X.MEASURE IN (N'CELL_FOR_FORM_END', N'CELL_PROD_FORM_END', N'CELL_FORM_PROGRESS', N'CELL_FORM_HOLD_UNDER_AVAILABLE'))
              OR (X.CELL_ITEM_ID <> X.ITEM_ID  AND X.MEASURE IN (N'CELL_EOH', N'CELL_FORM_HOLD_AFTER'))
               );
        
        PRINT '--A@X#02415_PRE_FORM_EXCL--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 1) AS DECIMAL(10,1)) AS NVARCHAR(30));
        
        -- A.3 ITEM_ID/필드 보정 (2건, S:1712~1788)
        ----------------------------------------------------------------------

        -- A.3.1 PACK_CELL_BOH/PACK_CELL_EOH 의 5개 필드 보정 (S:1712~1742, OG='P')
        UPDATE X
           SET X.ITEM_ID      = (SELECT TOP 1 CHILD_ITEM_ID
                                   FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                  WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                    AND Y.MODEL_ID           = X.ITEM_ID
                                    AND Y.OPERATION_GROUP_ID = 'A'
                                    AND Y.CELL_TYPE          = 'CP')
              ,X.TO_SITE      = '-'
              ,X.PROJECT_CODE = '-'
              ,X.INCOTERMS    = '-'
              ,X.PROD_LINE    = '-'
          FROM #PSI_GLOBAL_SMALL_AUTO X
         WHERE X.OPERATION_GROUP = 'P'
           AND X.MEASURE         IN (N'PACK_CELL_BOH', N'PACK_CELL_EOH')
           AND X.DIVISION_ID     = @P_DIVISION_ID;

        -- A.3.2 활성화코드 PACK 의 ITEM_ID = CELL_ITEM_ID (S:1784~1788, IS_CA='Y')
        UPDATE X
           SET X.ITEM_ID = X.CELL_ITEM_ID
          FROM #PSI_GLOBAL_SMALL_AUTO X
         WHERE X.OPERATION_GROUP = 'P'
           AND X.DIVISION_ID     = @P_DIVISION_ID
           AND DBO.FN_GET_FINAL_ITEM(X.DIVISION_ID, X.ITEM_ID, 'IS_CA') = 'Y';

        PRINT '--A@X#02430_PATCH_ITEM--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        ----------------------------------------------------------------------
        -- A.4 SEMI_SHIP_PLAN 정리 — NULL BOD/TRANSPORT_MODE 행 삭제 (S:2647)
        ----------------------------------------------------------------------
        DELETE X
          FROM #PSI_GLOBAL_SMALL_AUTO X
         WHERE X.MEASURE        = N'SEMI_SHIP_PLAN'
           AND X.BOD_ID         IS NULL
           AND X.TRANSPORT_MODE IS NULL
           AND X.DIVISION_ID    = @P_DIVISION_ID;

        PRINT '--A@X#02440_PATCH_SEMI--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        ----------------------------------------------------------------------
        -- A.5 LT_DAY/ATTRIBUTE3/ATTRIBUTE10 다단계 UPDATE (S 원본 시퀀스 그대로)
        --   순서 매우 중요: ATTRIBUTE10 = 'NO_LT_DIVIDE' 마킹/해제 토글이 후속 처리 분기 결정
        ----------------------------------------------------------------------

        -- A.5.1 LT_DAY = 0 WHERE TRANSPORT_MODE = '-' (S:1400, 보정)
        UPDATE X
           SET X.LT_DAY = 0
          FROM #PSI_GLOBAL_SMALL_AUTO X
         WHERE X.TRANSPORT_MODE = '-'
           AND X.DIVISION_ID    = @P_DIVISION_ID;

        -- A.5.2 PACK_BOH LT_DAY 초기화 후 PRE_INSP 적용 (S:1660~1683)
        --   원본은 IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd) 가드 — 첫 1년만 적용
        IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd)
        BEGIN
            -- 0 으로 초기화
            UPDATE X
               SET X.LT_DAY = 0
              FROM #PSI_GLOBAL_SMALL_AUTO X
             WHERE X.MEASURE     = N'PACK_BOH'
               AND X.DIVISION_ID = @P_DIVISION_ID;

            -- 실제값 (PRE_INSP) 적용
            UPDATE X
               SET X.LT_DAY = Y.LT_DAY
              FROM #PSI_GLOBAL_SMALL_AUTO X
             INNER JOIN (SELECT LT_DAY, SCM_SITE_ID, ITEM_ID
                           FROM SCP_MST_OPERATION_LT WITH (NOLOCK)
                          WHERE DIVISION_ID  = @P_DIVISION_ID
                            AND LT_OPERATION = 'PRE_INSP'
                        ) Y
                ON X.ITEM_ID    = Y.ITEM_ID
               AND X.FROM_SITE  = Y.SCM_SITE_ID
             WHERE X.MEASURE     = N'PACK_BOH'
               AND X.DIVISION_ID = @P_DIVISION_ID;
        END

        -- A.5.3 LT_DAY 5키 매칭 (S:2568, BOD_N_V daily) + ATTRIBUTE10 = 'NO_LT_DIVIDE' 마킹
        UPDATE X
           SET X.LT_DAY      = Y.LT_TOTAL
              ,X.ATTRIBUTE10 = N'NO_LT_DIVIDE'
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN SCP_MST_BOD_N_V Y WITH (NOLOCK)
            ON X.DIVISION_ID    = Y.DIVISION_ID
           AND X.FROM_SITE      = Y.FROM_SITE
           AND X.TO_SITE        = Y.TO_SITE
           AND X.TRANSPORT_MODE = Y.TRANSPORT_MODE
           AND X.BOD_ID         = Y.BOD_ID
         WHERE X.DIVISION_ID = @P_DIVISION_ID;

        -- A.5.3.4 [2026-05-20 김준규 신규] AS-WAS PR_SCP_XLS_PSI_GLOBAL_SMALL_S 의 #TRANSPORT_MODE 임시테이블 생성
        --   목적: A.5.3.5/A.5.3.6 의 SEMI_SHIP_PLAN UPDATE JOIN source
        --   AS-WAS 와 동일 구조: #SCP_MST_BOD_V (BOD_N_V 추출, X 측) + #PSI_GLOBAL_SMALL_AUTO (Y 측, PROJECT_CODE 추출)
        --   #SCP_MST_BOD_V 에는 PROJECT_CODE 컬럼 부재 → 별도 임시테이블 생성 필요
        IF OBJECT_ID('tempdb..#TRANSPORT_MODE') IS NOT NULL
            DROP TABLE #TRANSPORT_MODE;

        SELECT DISTINCT
               X.DIVISION_ID
              ,X.FROM_SITE
              ,X.TO_SITE
              ,X.INCOTERMS
              ,X.TRANSPORT_MODE
              ,X.LT_TOTAL
              ,X.BOD_ID
              ,Y.PROJECT_CODE
              ,X.LT_TOTAL_BY_WEEK
          INTO #TRANSPORT_MODE
          FROM #SCP_MST_BOD_V X
          LEFT OUTER JOIN #PSI_GLOBAL_SMALL_AUTO Y WITH(NOLOCK)
            ON X.DIVISION_ID = Y.DIVISION_ID
           AND X.FROM_SITE   = Y.FROM_SITE
           AND X.TO_SITE     = Y.TO_SITE
           AND X.INCOTERMS   = Y.INCOTERMS
           AND X.BOD_ID      = Y.BOD_ID
           AND Y.PROJECT_CODE <> N'-';

        -- A.5.3.5 [2026-05-20 김준규 v2] SEMI_SHIP_PLAN(_ORG/_GAP_ACC) 의 TRANSPORT_MODE/LT_DAY/BOD_ID 채우기
        --   AS-WAS PR_SCP_XLS_PSI_GLOBAL_SMALL_S (L700~855) 의 SEMI_SHIP_PLAN 분할 INSERT 패턴을 UPDATE 로 압축
        --   AS-WAS 정확 JOIN 키: DIV + FROM + TO + ISNULL(PROJECT,'-') + BOD_ID + MEASURE='SEMI_SHIP_PLAN'
        --   AS-WAS SET 컬럼: Y.TRANSPORT_MODE, Y.LT_TOTAL_BY_WEEK AS LT_DAY, Y.BOD_ID
        --   source: #TRANSPORT_MODE (A.5.3.4 에서 생성, PROJECT_CODE 포함)
        UPDATE X
           SET X.TRANSPORT_MODE = Y.TRANSPORT_MODE
              ,X.LT_DAY         = Y.LT_TOTAL_BY_WEEK   -- AS-WAS L794: weekly 값 직접 저장 (후속 A.5.4 가 daily 로 덮어쓰기)
              ,X.BOD_ID         = Y.BOD_ID
              ,X.ATTRIBUTE10    = N'NO_LT_DIVIDE'
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN #TRANSPORT_MODE Y
            ON X.DIVISION_ID  = Y.DIVISION_ID
           AND X.FROM_SITE    = Y.FROM_SITE
           AND X.TO_SITE      = Y.TO_SITE
           AND ISNULL(X.PROJECT_CODE, '-') = ISNULL(Y.PROJECT_CODE, '-')   -- AS-WAS L830: ISNULL 처리
           AND X.BOD_ID       = Y.BOD_ID                                   -- AS-WAS L831: BOD_ID 매칭
         WHERE X.MEASURE IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG', N'SEMI_SHIP_GAP_ACC')
           AND X.DIVISION_ID = @P_DIVISION_ID;

        -- A.5.3.6 [2026-05-20 김준규 fallback] AS-WAS BOD_ID 매칭 실패한 SEMI_SHIP row 에 대한 보강
        --   TO-BE 의 SEMI_SHIP_PLAN row 가 BOD_ID='-' 로 INSERT 되어 위 A.5.3.5 매칭 안 되는 경우 대응
        --   (DIV+FROM+TO+ISNULL(PROJECT,'-')) 매칭으로 SHIP_PLAN 의 대표 TRANSPORT_MODE/BOD_ID/LT 가져옴
        UPDATE X
           SET X.TRANSPORT_MODE = Y.TRANSPORT_MODE
              ,X.LT_DAY         = Y.LT_TOTAL_BY_WEEK
              ,X.BOD_ID         = Y.BOD_ID
              ,X.ATTRIBUTE10    = N'NO_LT_DIVIDE'
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN (
            SELECT DIVISION_ID, FROM_SITE, TO_SITE,
                   ISNULL(PROJECT_CODE, '-') AS PROJECT_CODE,
                   MAX(TRANSPORT_MODE)        AS TRANSPORT_MODE,
                   MAX(BOD_ID)                AS BOD_ID,
                   MAX(LT_TOTAL_BY_WEEK)      AS LT_TOTAL_BY_WEEK
              FROM #TRANSPORT_MODE
             WHERE TRANSPORT_MODE <> N'-'
               AND BOD_ID <> N'-'
             GROUP BY DIVISION_ID, FROM_SITE, TO_SITE, ISNULL(PROJECT_CODE, '-')
         ) Y
            ON X.DIVISION_ID  = Y.DIVISION_ID
           AND X.FROM_SITE    = Y.FROM_SITE
           AND X.TO_SITE      = Y.TO_SITE
           AND ISNULL(X.PROJECT_CODE, '-') = Y.PROJECT_CODE
         WHERE X.MEASURE IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG', N'SEMI_SHIP_GAP_ACC')
           AND X.TRANSPORT_MODE = N'-'      -- A.5.3.5 가 매칭 못 한 row 만 (TRANSPORT_MODE 그대로 '-')
           AND X.BOD_ID         = N'-'
           AND X.DIVISION_ID    = @P_DIVISION_ID;


        -- A.5.4 SEMI_SHIP_PLAN BOD='-' 일 때 BOD_N_V 매칭 (S:2596, 4-key) — BOD_ID/LT_DAY/ATTRIBUTE3/ATTRIBUTE10 갱신
        -- 2026-05-20 김준규 수정: MEASURE 조건에 SEMI_SHIP_PLAN_ORG / SEMI_SHIP_GAP_ACC 추가 — 복제 measure 도 LT_DAY 채움
        UPDATE X
           SET X.LT_DAY      = Y.LT_TOTAL
              ,X.BOD_ID      = Y.BOD_ID
              ,X.ATTRIBUTE3  = Y.FROM_YYYYMMDD + ',' + Y.TO_YYYYMMDD
              ,X.ATTRIBUTE10 = N'NO_LT_DIVIDE'
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN SCP_MST_BOD_N_V Y WITH (NOLOCK)
            ON X.DIVISION_ID    = Y.DIVISION_ID
           AND X.FROM_SITE      = Y.FROM_SITE
           AND X.TO_SITE        = Y.TO_SITE
           AND X.TRANSPORT_MODE = Y.TRANSPORT_MODE
         WHERE X.BOD_ID      = '-'
           AND X.MEASURE     IN (N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG', N'SEMI_SHIP_GAP_ACC')
           AND X.DIVISION_ID = @P_DIVISION_ID;


        -- A.5.5 VMI 전진검사 LT 가산 (S:2653) + ATTRIBUTE10 = NULL 해제
        UPDATE X
           SET X.LT_DAY      = ISNULL(X.LT_DAY, 0) + ISNULL(Y.LT_DAY, 0)
              ,X.ATTRIBUTE10 = NULL
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN (SELECT  S.DIVISION_ID
                            ,S.SCM_SITE_ID
                            ,S.ITEM_ID
                            ,MAX(ISNULL(S.SCP_VMI_LT, 0)) AS LT_DAY
                       FROM SCM_MST_SITE_ITEM S WITH(NOLOCK)
                       INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL MD WITH(NOLOCK)
                          ON  S.DIVISION_ID  = MD.SEGMENT1
                         AND S.SCM_SITE_ID  = MD.SEGMENT2
                         AND MD.LOOKUP_TYPE = 'VMI_LT_SITE'
                         AND S.VALID_YN     = 'Y'
                         AND MD.VALID_YN    = 'Y'
                       GROUP BY S.DIVISION_ID, S.SCM_SITE_ID, S.ITEM_ID
                    ) Y
            ON X.DIVISION_ID = Y.DIVISION_ID
           AND X.TO_SITE     = Y.SCM_SITE_ID
           AND X.ITEM_ID     = Y.ITEM_ID
         WHERE X.DIVISION_ID = @P_DIVISION_ID;

        -- A.5.6 LT_DAY 반올림 (S:2696) — ATTRIBUTE10 = 'NO_LT_DIVIDE' 인 행만 (즉 5.5 에서 NULL 안 된 = VMI 가산 안 된 행)
        UPDATE X
           SET X.LT_DAY      = (CASE WHEN X.LT_DAY < 7.0 THEN ROUND(X.LT_DAY, 0) ELSE CEILING(X.LT_DAY) END)
              ,X.ATTRIBUTE10 = NULL
          FROM #PSI_GLOBAL_SMALL_AUTO X
         WHERE X.DIVISION_ID = @P_DIVISION_ID
           AND X.ATTRIBUTE10 = N'NO_LT_DIVIDE';

        -- A.5.7 CELL_PROD LT_DAY (S:2724) = CEILING((LT_FORMATION + ATTRIBUTE1) / 7)
        UPDATE X
           SET X.LT_DAY = (CEILING(ISNULL(Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')), 0) / 7.0))
          FROM #PSI_GLOBAL_SMALL_AUTO X
         INNER JOIN SCP_MST_FORMATION Y WITH (NOLOCK)
            ON X.DIVISION_ID = Y.DIVISION_ID
           AND X.FROM_SITE   = Y.PLANT_SITE_ID
           AND X.ITEM_ID     = Y.ITEM_ID
         WHERE X.MEASURE     = N'CELL_PROD'
           AND X.DIVISION_ID = @P_DIVISION_ID;

        -- A.5.8 SHIP_PLAN/SEMI_SHIP_PLAN ATTRIBUTE3 = BOD 일자 (S:2289)
        UPDATE X
           SET X.ATTRIBUTE3 = (SELECT TOP 1 B.FROM_YYYYMMDD + ',' + B.TO_YYYYMMDD
                                 FROM SCP_MST_BOD_V B WITH(NOLOCK)
                                WHERE B.DIVISION_ID = X.DIVISION_ID
                                  AND B.BOD_ID      = X.BOD_ID)
          FROM #PSI_GLOBAL_SMALL_AUTO X
         WHERE X.MEASURE IN (N'SHIP_PLAN', N'SEMI_SHIP_PLAN')
           AND X.DIVISION_ID = @P_DIVISION_ID
           AND X.ATTRIBUTE3 IS NULL;

        PRINT '--A@X#02450_PATCH_END--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
        ----------------------------------------------------------------------
        -- 2026-05-09 김준규 신규: [PATCH] 끝
        ----------------------------------------------------------------------

        -- (2-5) [요구사항 #4] QTY = 0 행 일괄 삭제
        -- 2026-05-11 김준규 수정 [옵션 A]: QTY=0 skeleton 행 보존 (AS-IS 호환 위해 DELETE 비활성화)
        --   효과: OLD (SCP_XLS_PSI_GLOBAL_SMALL) 와 동일하게 모든 MEASURE 의 0-row skeleton 유지
        --   부담: PIVOT INSERT GROUP BY 처리 시간 증가 가능 → 측정 후 불가시 다른 대안 검토
        --   원복 시: 아래 줄에서 -- 만 제거
        -- DELETE FROM #PSI_GLOBAL_SMALL_AUTO WHERE QTY = 0;

        -- (2-6) [TODO 완성] LT_DAY 2차 처리용 임시테이블
        --   5키 매칭 (DIVISION+FROM+TO+TRANSPORT_MODE+BOD_ID) 으로 raw LT_TOTAL 조회.
        --   PIVOT INSERT 시 LEFT JOIN 으로 사용 → 매칭되면 daily LT_TOTAL, 안 되면 weekly LT_TOTAL_BY_WEEK.
        --   매칭된 행은 ATTRIBUTE10 = 'NO_LT_DIVIDE' 마킹 (메인 SP 원본 동일).
        IF OBJECT_ID('tempdb..#SCP_MST_BOD_N_V_DAILY') IS NOT NULL DROP TABLE #SCP_MST_BOD_N_V_DAILY;
        SELECT DISTINCT
             X.DIVISION_ID
            ,X.FROM_SITE
            ,X.TO_SITE
            ,X.TRANSPORT_MODE
            ,X.BOD_ID
            ,X.LT_TOTAL
        INTO #SCP_MST_BOD_N_V_DAILY
        FROM SCP_MST_BOD_N_V X WITH (NOLOCK)
        WHERE X.DIVISION_ID = @P_DIVISION_ID;

        CREATE NONCLUSTERED INDEX IX_BOD_N_V_DAILY
            ON #SCP_MST_BOD_N_V_DAILY (DIVISION_ID, FROM_SITE, TO_SITE, TRANSPORT_MODE, BOD_ID);

        IF @v_is_debug = 1 SELECT '#SCP_MST_BOD_N_V_DAILY' AS "#SCP_MST_BOD_N_V_DAILY", * FROM #SCP_MST_BOD_N_V_DAILY;

---------------------------------------------------------------------------------
                IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_INSP') IS NOT NULL
                        DROP TABLE #PLN_TH_ENG_STOCK_PLAN_INSP


                -- 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장
                IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_SMALL_AUTO') IS NOT NULL
                        DROP TABLE #tmp_PSI_GLOBAL_SMALL_AUTO

              --2026-05-10 김준규 PIVOT에서 사용하므로 막음
              --IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO_OLD') IS NOT NULL
              --    DROP TABLE #tmp_SCP_MST_DIO_OLD

              IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO') IS NOT NULL
                  DROP TABLE #tmp_SCP_MST_DIO

              IF OBJECT_ID('tempdb..#tmp_NICK_NAME') IS NOT NULL
                  DROP TABLE #tmp_NICK_NAME

PRINT '--A@X#02700--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        --IF @@TRANCOUNT > 0
        --  BEGIN
        --    COMMIT TRAN ;
        --  END;

         --PRINT N'완료 로깅 시작'


                    -- TXN LOG
        SET @v_log_type     = N'TXN';
        SET @n_log_count    = @@ROWCOUNT;
        SET @v_log_message  = N'INSERT INTO '+@v_table_id;
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date   = SYSDATETIME();
        --IF @v_is_debug  = 0
--          EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
--                                    ,@p_log_type      = @v_log_type
--                                    ,@p_log_count     = @n_log_count
--                                    ,@p_log_message   = @v_log_message
--                                    ,@p_description   = @v_description
--                                    ,@p_event_date    = @d_event_date
--                                    ,@P_USER_ID       = @v_batch_user
--                                  ;
         --PRINT N'완료'

        IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL_AUTO') IS NULL
        BEGIN
            SET @X_STATUS = -1;
            SET @X_MSG    = N'#PSI_GLOBAL_SMALL_AUTO not created.';
            RETURN -1;
        END;

        IF NOT EXISTS (SELECT 1 FROM #PSI_GLOBAL_SMALL_AUTO)
        BEGIN
            SET @X_STATUS = 0;
            SET @X_MSG    = N'No data in #PSI_GLOBAL_SMALL_AUTO - nothing to pivot.';
            RETURN 0;
        END;

        -------------------------------------------------------------------------------------
        -- (2) PIVOT 적재 : #PSI_GLOBAL_SMALL_AUTO  →  SCM_SIM_DYN_COLS
        --
        --   행 구조 :
        --     SORT_SEQ1 = 10  → LABEL  행 (C1~C25 = 고정 라벨,  C26~CN = 'QTY001','QTY002',...)
        --     SORT_SEQ1 = 20  → LABEL2 행 (C1~C25 = NULL,        C26~CN = 'Wxx'  주차)
        --     SORT_SEQ1 = 30  → LABEL3 행 (C1~C25 = NULL,        C26~CN = 'YYMMDD' 일자)
        --     SORT_SEQ1 = 40+ → DATA   행 (C1~C25 = 실데이터,    C26~CN = QTY 값)
        -------------------------------------------------------------------------------------

        -- 시작/끝 일자 결정
        --   시작일 = @p_plan_start_yyyymmdd (헤더에서 SNAP 의 그 주 월요일로 이미 보정됨)
        -- 2026-05-13 김준규 수정:
        --   기존: @v_data_end_dt = MAX(YYYYMMDD) FROM #PSI_GLOBAL_SMALL_AUTO
        --   변경: @v_data_end_dt = @p_to_yyyymmdd (라인 178 SELECT, scm_mst_plan.horizon_end_date)
        --   이유: source 테이블 데이터 없거나 일부 measure 만 적재된 경우
        --         MAX = NULL → RETURN 0 으로 분할 분기 PRINT 로그까지 도달 못함
        --         scm_mst_plan 의 horizon_end_date 가 PLAN 기간의 권위 있는 종료일자
        DECLARE @v_data_end_dt DATE = TRY_CONVERT(DATE, @p_to_yyyymmdd, 112);

        DECLARE @v_start_dt DATE = TRY_CONVERT(DATE, @p_plan_start_yyyymmdd, 112);
        DECLARE @v_end_dt   DATE = @v_data_end_dt;

        -- 2026-05-13 김준규 수정: SELECT * → COUNT + TOP 5
        --   기존: SELECT * → 수만~수십만 row 출력 → SSMS 그리드 부하 + 이후 ResultSet 가려짐
        --   변경: 행수 카운트 + 샘플 5건만 출력 (전체 조회는 별도 쿼리로)
        IF @v_is_debug = 1
        BEGIN
            SELECT '#PSI_GLOBAL_SMALL_AUTO_11_COUNT' AS step, COUNT(*) AS row_cnt FROM #PSI_GLOBAL_SMALL_AUTO;
            SELECT TOP 5 '#PSI_GLOBAL_SMALL_AUTO_11_SAMPLE' AS step, * FROM #PSI_GLOBAL_SMALL_AUTO;
        END;

        -- 2026-05-13 김준규 수정:
        --   기존: @v_end_dt NULL/역전 시 RETURN 0 → 이후 분할 분기 PRINT 로그 출력 불가
        --   변경: RETURN 제거, PRINT 경고 후 안전 폴백 (@v_end_dt = @v_start_dt)
        --         → 분할 분기 (@v_split_required) PRINT 까지 도달 보장
        IF @v_end_dt IS NULL OR @v_end_dt < @v_start_dt
        BEGIN
            PRINT N'======================================================================';
            PRINT N'[WARN] @v_end_dt 비정상 (NULL 또는 @v_start_dt 보다 작음)';
            PRINT N'  @p_to_yyyymmdd  = [' + ISNULL(@p_to_yyyymmdd, N'<NULL>') + N']';
            PRINT N'  @v_start_dt     = [' + ISNULL(CONVERT(NVARCHAR(20), @v_start_dt, 121), N'<NULL>') + N']';
            PRINT N'  @v_end_dt (raw) = [' + ISNULL(CONVERT(NVARCHAR(20), @v_end_dt,   121), N'<NULL>') + N']';
            PRINT N'  → 폴백: @v_end_dt = @v_start_dt (1일 처리)';
            PRINT N'======================================================================';
            SET @v_end_dt = @v_start_dt;
            SET @X_STATUS = 0;
            SET @X_MSG    = N'WARN: @v_end_dt invalid - fallback to @v_start_dt.';
        END;

        -- ============================================================================================================
        -- 2026-05-13 김준규 [테스트 mode 적용]: 분할 분기 (>364일) 시뮬레이션
        --   @v_test_mode_split_extend_days > 0 시:
        --     1) #PSI_GLOBAL_SMALL_AUTO 의 첫 N일 데이터를 +364일 shift 하여 INSERT
        --        (겹침 회피: 원본 [start, start+N-1] → shift [start+364, start+364+N-1])
        --     2) @v_end_dt, @v_data_end_dt, @p_to_yyyymmdd 갱신
        --   결과: @v_n_days = 364 + N → 분할 분기 발동
        -- ============================================================================================================
        IF @v_test_mode_split_extend_days > 0
        BEGIN
            DECLARE @v_test_shift_days   INT  = 364;  -- 기존 1년 + shift 양
            DECLARE @v_test_orig_end_dt  DATE = @v_end_dt;
            DECLARE @v_test_new_end_dt   DATE = DATEADD(DAY, @v_test_mode_split_extend_days, @v_end_dt);
            DECLARE @v_test_inserted     INT;

            RAISERROR(N'======================================================================', 10, 1) WITH NOWAIT;
            RAISERROR(N'[TEST MODE] 분할 분기 시뮬레이션 시작', 10, 1) WITH NOWAIT;
            RAISERROR(N'  extend_days = %d, shift_days = %d', 10, 1, @v_test_mode_split_extend_days, @v_test_shift_days) WITH NOWAIT;

            -- 원본 첫 N일 데이터를 +shift_days 일 shift 하여 INSERT
            INSERT INTO #PSI_GLOBAL_SMALL_AUTO (
                 DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                ,TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
                ,MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
            )
            SELECT
                 DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE, PROJECT_CODE
                ,TO_BOH_QTY, FROM_BOH_QTY, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE
                ,MEASURE
                ,CONVERT(NVARCHAR(8), DATEADD(DAY, @v_test_shift_days, TRY_CONVERT(DATE, YYYYMMDD, 112)), 112) AS YYYYMMDD
                ,QTY, SORT_ORDER_NO, COLUMN_LABEL_NAME, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
              FROM #PSI_GLOBAL_SMALL_AUTO WITH (NOLOCK)
             WHERE YYYYMMDD IS NOT NULL
               AND TRY_CONVERT(DATE, YYYYMMDD, 112) BETWEEN @v_start_dt
                                                        AND DATEADD(DAY, @v_test_mode_split_extend_days - 1, @v_start_dt);
            SET @v_test_inserted = @@ROWCOUNT;

            -- @v_end_dt / @v_data_end_dt / @p_to_yyyymmdd 갱신
            SET @v_end_dt        = @v_test_new_end_dt;
            SET @v_data_end_dt   = @v_test_new_end_dt;
            SET @p_to_yyyymmdd   = CONVERT(NVARCHAR(8), @v_test_new_end_dt, 112);

            DECLARE @v_test_orig_end_str NVARCHAR(20) = CONVERT(NVARCHAR(20), @v_test_orig_end_dt, 121);
            DECLARE @v_test_new_end_str  NVARCHAR(20) = CONVERT(NVARCHAR(20), @v_test_new_end_dt,  121);
            RAISERROR(N'  shift INSERT row    = %d', 10, 1, @v_test_inserted) WITH NOWAIT;
            RAISERROR(N'  원본 @v_end_dt      = %s', 10, 1, @v_test_orig_end_str) WITH NOWAIT;
            RAISERROR(N'  새 @v_end_dt        = %s', 10, 1, @v_test_new_end_str) WITH NOWAIT;
            RAISERROR(N'  새 @p_to_yyyymmdd   = %s', 10, 1, @p_to_yyyymmdd) WITH NOWAIT;
            RAISERROR(N'======================================================================', 10, 1) WITH NOWAIT;
        END;

        DECLARE @v_n_days INT = DATEDIFF(DAY, @v_start_dt, @v_end_dt) + 1;
        IF @v_n_days < 1 SET @v_n_days = 1;

        -- 2026-06-08 김준규 [8060 회피 — LABEL 만 364 컬럼 / DATA 는 전체 일자 적재]
        --   배경: 8060 은 '행 최종 크기' 한계. LABEL 행(10/20/30)은 모든 일자컬럼이 짧은 텍스트로 꽉 차
        --         588컬럼이면 dense → 8060 초과(검증됨: LABEL3 일자 8957B). DATA 행은 일자별 sparse
        --         (값 있는 날만 채움)라 588컬럼이어도 row-overflow 로 적재 가능.
        --   조치: (a) @v_n_days CAP 제거 → DATA 는 전체 일자(예: 588) 그대로 단일 INSERT.
        --         (b) @v_split_required = 0 강제 (분할 UPDATE 미사용).
        --         (c) LABEL 행의 일자컬럼만 364 로 제한(헤더이므로 365+ 라벨 표시 불요) → @v_cn_cols_label.
        --   주의: DATA 행이 특정 측정값에서 dense + 긴 값이면 588컬럼에서 8060 재발 가능(값 길이 의존).
        --         그 경우 YEARBLOCK(연도블록) 전환 필요.
        IF @v_n_days > 364
            PRINT N'--A@X#NDAYS_FULL-- @v_n_days ' + CAST(@v_n_days AS NVARCHAR(10)) + N' (DATA 전체 적재 / LABEL 364 제한)';

        -- ============================================================
        -- 2026-05-13 김준규 [#PSI_GLOBAL_SMALL_AUTO to_date 안전망 DELETE]
        --   목적: TO_YYYYMMDD 이후 일자 데이터는 PIVOT 단계에서 사용되지 않음 → 사전 제거
        --   메인 차단: 통합 INSERT (라인 3717, 4391) 의 outer WHERE 에 적용 완료
        --   안전망 (여기): 그 외 INSERT/MERGE 누락 케이스 100% 차단
        --   효과: PIVOT GROUP BY 부하 + tempdb 메모리 감소
        --   주의: YYYYMMDD IS NULL 행 (메타데이터 QTY=0) 은 보존 — > 비교는 NULL 안전
        -- ============================================================
        DECLARE @v_psi_auto_purged INT;
        -- 2026-05-19 김준규 [INTRANSIT_ETA 보존]: MERGE NOT MATCHED INSERT 한 INTRANSIT_ETA/SEMI_INTRANSIT_ETA 의
        --   YYYYMMDD = #INTRANSIT.Y.YYYYMMDD (실제 입고 예정일자, plan range 외 미래 일자 가능)
        --   안전망 DELETE 가 이 row 까지 제거 → PACK INTRANSIT_ETA 손실 → AS-WAS 결과 회귀
        --   해결: 두 measure 는 plan range 외도 보존 (PIVOT 단계에서 IN 절 매핑 안 되는 일자는 자동 무시)
        DELETE FROM #PSI_GLOBAL_SMALL_AUTO
         WHERE YYYYMMDD > @p_to_yyyymmdd
           AND MEASURE NOT IN (N'INTRANSIT_ETA', N'SEMI_INTRANSIT_ETA'
                               -- 2026-06-01 김준규 [SEMI_SHIP_PLAN skeleton 보존 — ②정밀]: plan range 외도 보존 (PIVOT 자동 무시). KR01297200/DAP skeleton 손실 방지
                               , N'SEMI_SHIP_PLAN', N'SEMI_SHIP_PLAN_ORG', N'SEMI_SHIP_GAP_ACC');
        SET @v_psi_auto_purged = @@ROWCOUNT;
        IF @v_is_debug = 1
            RAISERROR(N'[#PSI_GLOBAL_SMALL_AUTO 안전망 DELETE] @p_to_yyyymmdd = %s, 제거된 행수 = %d', 10, 1, @p_to_yyyymmdd, @v_psi_auto_purged) WITH NOWAIT;

        -- ============================================================================
        -- 2026-05-31 김준규 [SEMI_INTRANSIT/ETA 제거 — AS-WAS RAW 미표시 항목]
        --   SEMI_INTRANSIT/SEMI_INTRANSIT_ETA 는 빈 skeleton(QTY 0)이며 후속 계산에 미사용.
        --   출처가 카르테시안 expand(L2708/2896, L4143 에서 보존) + L4914 강제 skeleton 둘이라,
        --   PIVOT 직전에 일괄 DELETE 하여 RAW 미표시(AS-WAS 동일) 보장.
        -- ============================================================================
        DELETE FROM #PSI_GLOBAL_SMALL_AUTO WHERE MEASURE IN (N'SEMI_INTRANSIT', N'SEMI_INTRANSIT_ETA');
        PRINT N'--A@X#02614_SEMI_INTRANSIT_DEL-- SEMI_INTRANSIT/ETA 제거: ' + CAST(@@ROWCOUNT AS NVARCHAR(20)) + N' rows';

        -- 2026-06-02 김준규 [CELL_EOH 중복 제거 — (FROM_SITE, CELL_ITEM_ID) 조합당 1행 보장]
        --   요구: CELL_EOH 는 (SHIP_FROM=FROM_SITE, CELL_ITEM_ID) 조합당 정확히 1행만.
        --   현상: 동일 (FROM_SITE, CELL_ITEM_ID) 에 CELL_EOH 가 2행 이상 잔존
        --         (cell=item 셀 본인 + cell<>item phantom 모듈, 또는 cell=item 끼리 변형 row).
        --   조치: (DIVISION, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID) 당 1행만 유지하고 나머지 삭제.
        --     유지 우선순위:
        --       1) cell=item (셀 본인) 우선  → 모듈/하이브리드 row 제거
        --       2) 실재고 큰 것 (FROM_BOH_QTY, QTY DESC)
        --       3) 이른 날짜 (YYYYMMDD ASC)
        ;WITH celleoh_uniq AS (
            SELECT ROW_NUMBER() OVER (
                       PARTITION BY DIVISION_ID, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID
                       ORDER BY CASE WHEN CELL_ITEM_ID = ITEM_ID THEN 0 ELSE 1 END ASC
                              , ISNULL(FROM_BOH_QTY, 0) DESC
                              , ISNULL(QTY, 0)          DESC
                              , YYYYMMDD                ASC
                              , ATTRIBUTE1, ATTRIBUTE9
                   ) AS rn
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE MEASURE = N'CELL_EOH'
        )
        DELETE FROM celleoh_uniq WHERE rn > 1;
        PRINT N'--A@X#02614_CELLEOH_UNIQ-- CELL_EOH (FROM_SITE,CELL_ITEM_ID) 중복 제거: ' + CAST(@@ROWCOUNT AS NVARCHAR(20)) + N' rows';

        -- ============================================================================
        -- 2026-05-30 김준규 [SORT_ORDER_NO 단일 소스화 — MEASURE_ORDER 하드코딩 제거]
        --   SEMI 복제(SEMI_SHIP_PLAN_ORG/PLAN/GAP_ACC)·SHIP_REQ 등은 마스터(SCM_MST_SHEET_MEASURE)에
        --   없어 #MEASURE 경로에서 SORT_ORDER_NO 가 fallback(50)·NULL 로 채워짐
        --   → C30(MEASURE_ORDER)이 비어 정렬이 엉킴.
        --   PIVOT 직전에 #PSI_MEASURE_DAILY 합성값(level1*1000+level2)으로 강제 통일하여
        --   하드코딩을 무력화하고 순서를 정확히 잡는다.
        --   (단일/분할 PIVOT 모두 #PSI_GLOBAL_SMALL_AUTO 를 입력으로 하므로 이 한 곳이면 공통 적용)
        -- ============================================================================
        UPDATE A
           SET A.SORT_ORDER_NO = M.MEASURE_ORDER   -- 2026-05-31 김준규: level1 만 저장 (level2 는 PIVOT 에서 #PSI_MEASURE_DAILY JOIN 으로 C779 에 별도 적재 → magic number 제거)
          FROM #PSI_GLOBAL_SMALL_AUTO A
         INNER JOIN #PSI_MEASURE_DAILY M WITH(NOLOCK) ON M.MEASURE = A.MEASURE;
        PRINT N'--A@X#02613_SORT_SYNC-- SORT_ORDER_NO <- #PSI_MEASURE_DAILY 통일: ' + CAST(@@ROWCOUNT AS NVARCHAR(20)) + N' rows';
        -- 2026-05-30 김준규 [안전망] sync 후 SORT_ORDER_NO 가 NULL 인 measure 가 있으면 #PSI_MEASURE_DAILY 누락이므로 경고
        IF EXISTS (SELECT 1 FROM #PSI_GLOBAL_SMALL_AUTO WHERE SORT_ORDER_NO IS NULL)
        BEGIN
            DECLARE @v_null_sort_cnt INT = (SELECT COUNT(*) FROM #PSI_GLOBAL_SMALL_AUTO WHERE SORT_ORDER_NO IS NULL);
            RAISERROR(N'[경고] SORT_ORDER_NO 가 NULL 인 행 %d 개 — #PSI_MEASURE_DAILY 에 누락된 measure 가 있습니다. 정렬이 엉킬 수 있음.', 10, 1, @v_null_sort_cnt) WITH NOWAIT;
            IF @v_is_debug = 1
                SELECT DISTINCT MEASURE AS [SORT_ORDER_NO_NULL_MEASURE] FROM #PSI_GLOBAL_SMALL_AUTO WHERE SORT_ORDER_NO IS NULL;
        END


        -- 2026-05-13 김준규 [@v_n_days 계산 디버그]
        --   목적: @v_n_days 자동 계산 출처 추적 (출처 = scm_mst_plan.horizon_end_date)
        --   단계별 출력:
        --     1) @p_plan_start_yyyymmdd  (사용자 입력 시작 일자)
        --     2) @v_start_dt              (DATE 변환 결과)
        --     3) @p_to_yyyymmdd           (scm_mst_plan.horizon_end_date — 라인 178 SELECT)
        --     4) @v_data_end_dt           (TRY_CONVERT(DATE, @p_to_yyyymmdd, 112))
        --     5) @v_end_dt                (실제 끝 일자)
        --     6) DATEDIFF                 (일자 차이)
        --     7) @v_n_days                (최종 계산값)
        IF @v_is_debug = 1
        BEGIN
            PRINT N'======================================================================';
            PRINT N'[@v_n_days 계산 추적]';
            PRINT N'  1) @p_plan_start_yyyymmdd = [' + ISNULL(@p_plan_start_yyyymmdd, N'<NULL>') + N']';
            PRINT N'  2) @v_start_dt            = [' + ISNULL(CONVERT(NVARCHAR(20), @v_start_dt, 121), N'<NULL>') + N']';
            PRINT N'  3) @p_to_yyyymmdd         = [' + ISNULL(@p_to_yyyymmdd, N'<NULL>') + N']  (scm_mst_plan.horizon_end_date)';
            PRINT N'  4) @v_data_end_dt         = [' + ISNULL(CONVERT(NVARCHAR(20), @v_data_end_dt, 121), N'<NULL>') + N']  (TRY_CONVERT @p_to_yyyymmdd)';
            PRINT N'  5) @v_end_dt              = [' + ISNULL(CONVERT(NVARCHAR(20), @v_end_dt, 121), N'<NULL>') + N']';
            PRINT N'  6) DATEDIFF(DAY)          = ' + CAST(DATEDIFF(DAY, @v_start_dt, @v_end_dt) AS NVARCHAR(10));
            PRINT N'  7) @v_n_days              = ' + CAST(@v_n_days AS NVARCHAR(10)) + N' (= DATEDIFF + 1)';
            PRINT N'======================================================================';

            --   SELECT 식별을 위한 PRINT 마커 + COUNT(*) 사전 확인
            --   목적: #PSI_GLOBAL_SMALL_AUTO 가 비어있는 경우 명시적 알림
            DECLARE @v_psi_auto_cnt INT;
            SELECT @v_psi_auto_cnt = COUNT(*) FROM #PSI_GLOBAL_SMALL_AUTO;
            RAISERROR(N'[#PSI_GLOBAL_SMALL_AUTO] 총 행수 = %d', 10, 1, @v_psi_auto_cnt) WITH NOWAIT;

            IF @v_psi_auto_cnt = 0
            BEGIN
                RAISERROR(N'[WARN] #PSI_GLOBAL_SMALL_AUTO 가 비어 있음 — DATE_RANGE/DATE_BY_MEASURE SELECT 의미 없음', 10, 1) WITH NOWAIT;
            END;

            RAISERROR(N'>>> SELECT [1/2] #PSI_GLOBAL_SMALL_AUTO_DATE_RANGE', 10, 1) WITH NOWAIT;
            -- #PSI_GLOBAL_SMALL_AUTO 의 일자 분포 상세
            SELECT N'#PSI_GLOBAL_SMALL_AUTO_DATE_RANGE'                 AS step
                  ,MIN(YYYYMMDD)                                        AS min_yyyymmdd
                  ,MAX(YYYYMMDD)                                        AS max_yyyymmdd
                  ,COUNT(DISTINCT YYYYMMDD)                             AS distinct_days
                  ,COUNT(*)                                             AS total_rows
                  ,DATEDIFF(DAY,
                       TRY_CONVERT(DATE, MIN(YYYYMMDD), 112),
                       TRY_CONVERT(DATE, MAX(YYYYMMDD), 112)) + 1       AS span_days
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE YYYYMMDD IS NOT NULL;

            RAISERROR(N'>>> SELECT [2/2] #PSI_GLOBAL_SMALL_AUTO_DATE_BY_MEASURE', 10, 1) WITH NOWAIT;
            -- MEASURE 별 일자 범위 (어느 measure 가 14.5개월치 데이터 가지는지)
            SELECT TOP 30 N'#PSI_GLOBAL_SMALL_AUTO_DATE_BY_MEASURE'     AS step
                  ,MEASURE
                  ,MIN(YYYYMMDD)                                        AS min_yyyymmdd
                  ,MAX(YYYYMMDD)                                        AS max_yyyymmdd
                  ,COUNT(DISTINCT YYYYMMDD)                             AS distinct_days
                  ,COUNT(*)                                             AS row_cnt
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE YYYYMMDD IS NOT NULL
             GROUP BY MEASURE
             ORDER BY MAX(YYYYMMDD) DESC, MEASURE;
        END

        -- 2026-05-12 김준규 [INSERT 분할 분기 변수]
        --   일자 ≤ 364: 단일 INSERT (현재 패턴, row size 안전)
        --   일자 > 364: 2분할 INSERT — Phase 1 (메타+전반) + Phase 2 (후반 UPDATE)
        --   매칭: #GROUP_META 임시테이블의 GRP_ID 기반 SORT_SEQ1 (옵션 C)
        -- 2026-06-08 김준규: LABEL만 364 / DATA 전체 방식 → 분할(UPDATE) 미사용. 항상 단일 INSERT.
        DECLARE @v_split_required BIT  = 0;  -- (원래: CASE WHEN @v_n_days > 364 THEN 1 ELSE 0 END)
        DECLARE @v_split_mid_idx  INT  = CASE WHEN @v_split_required = 1
                                              THEN @v_n_days / 2
                                              ELSE @v_n_days END;
        IF @v_is_debug = 1
            PRINT '--A@X#02600_SPLIT-- @v_n_days=' + CAST(@v_n_days AS NVARCHAR(10))
                + ' @v_split_required=' + CAST(@v_split_required AS NVARCHAR(2))
                + ' @v_split_mid_idx=' + CAST(@v_split_mid_idx AS NVARCHAR(10));

        DECLARE @v_total_cols INT = 41 + @v_n_days;  -- [Excel layout] 31 head + n days + 10 tail

        ---------------------------------------------------------------------------------
        -- 일자/주차/QTY번호 라벨 임시테이블 (CN 매핑)
        ---------------------------------------------------------------------------------
        IF OBJECT_ID('tempdb..#TMP_DATE_AXIS') IS NOT NULL DROP TABLE #TMP_DATE_AXIS;
        CREATE TABLE #TMP_DATE_AXIS (
             RNUM        INT NOT NULL PRIMARY KEY    -- 1..N (C26 = RNUM 1)
            ,YYYYMMDD    NVARCHAR(8)  NOT NULL       -- 해당 일자 (yyyymmdd)
            ,YYMMDD      NVARCHAR(6)  NOT NULL       -- 화면용 6자리
            ,QTY_LABEL   NVARCHAR(20) NOT NULL       -- 'QTY001'..'QTYn'
            ,WEEK_LABEL  NVARCHAR(10) NOT NULL       -- 'Wxx' (ISO)
            ,CN          NVARCHAR(10) NOT NULL       -- 'C26'..
        );

        -- [DEBUG] #TMP_DATE_AXIS INSERT 사용 변수
        IF @v_is_debug = 1 SELECT CONCAT('@v_start_dt:', @v_start_dt) AS "#TMP_DATE_AXIS 사용변수";

        ;WITH N AS (
            SELECT TOP (@v_n_days) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS R
              FROM sys.all_objects a, sys.all_objects b
        )
        INSERT INTO #TMP_DATE_AXIS (RNUM, YYYYMMDD, YYMMDD, QTY_LABEL, WEEK_LABEL, CN)
        SELECT
             N.R                                                          AS RNUM
            ,CONVERT(NVARCHAR(8),  DATEADD(DAY, N.R - 1, @v_start_dt), 112) AS YYYYMMDD
            ,RIGHT(CONVERT(NVARCHAR(8), DATEADD(DAY, N.R - 1, @v_start_dt), 112), 6) AS YYMMDD
            ,'QTY' + RIGHT('000' + CONVERT(NVARCHAR(10), N.R), 3)         AS QTY_LABEL
            ,'W'   + RIGHT('00'  + CONVERT(NVARCHAR(10), DATEPART(ISO_WEEK, DATEADD(DAY, N.R - 1, @v_start_dt))), 2) AS WEEK_LABEL
            ,'C'   + CONVERT(NVARCHAR(10), N.R + 31)                      AS CN  -- [Excel layout] head=31
          FROM N;

        -- [DEBUG] #TMP_DATE_AXIS INSERT 결과
        IF @v_is_debug = 1 SELECT '#TMP_DATE_AXIS' AS "#TMP_DATE_AXIS", * FROM #TMP_DATE_AXIS;

        -- 2026-05-13 김준규 제거: 라인 7708 과 동일한 중복 SELECT — ResultSet 갯수 줄이기 위해 제거
        -- IF @v_is_debug = 1 SELECT '#TMP_DATE_AXIS' AS "#TMP_DATE_AXIS", * FROM   #TMP_DATE_AXIS

PRINT '--A@X#02800--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
        ---------------------------------------------------------------------------------
        -- 2026-05-12 김준규 [DELETE 변경]: 타인 작업 보호 — 31일 이전 데이터만 삭제 (housekeeping)
        --   기존: 같은 SNAP+REPORT+PLANT+DIVISION 조건의 모든 데이터 삭제 (타인 작업도 영향)
        --   변경: CREATION_DATE 기준 31일 이전 자료만 정리
        --         (Oracle TRUNCATE(GETDATE()-31) → SQL Server: CAST(DATEADD(DAY,-31,GETDATE()) AS DATE))
        --   본인 BATCH_ID 정리는 아래 두 번째 DELETE 에서 처리.
        ---------------------------------------------------------------------------------
        DELETE SCM_SIM_DYN_COLS
         WHERE CREATION_DATE <= CAST(DATEADD(DAY, -31, GETDATE()) AS DATE);

        DELETE FROM SCM_SIM_DYN_COLS
         WHERE BATCH_ID = @P_BATCH_ID;

        ---------------------------------------------------------------------------------
        -- 동적 SQL 빌드용 CN 컬럼 리스트
        ---------------------------------------------------------------------------------
         ---------------------------------------------------------------------------------
        -- 동적 SQL 빌드용 CN 컬럼 리스트
        ---------------------------------------------------------------------------------
        DECLARE @v_cn_cols     NVARCHAR(MAX);  -- "C26,C27,...,Cn" (DATA 전체)
        DECLARE @v_cn_cols_label NVARCHAR(MAX);  -- 2026-06-08 김준규: LABEL 전용 컬럼리스트(최대 364)
        DECLARE @v_cn_qty_labels  NVARCHAR(MAX);  -- LABEL  : ',''QTY001'' AS C26, ''QTY002'' AS C27, ...'
        DECLARE @v_cn_week_labels NVARCHAR(MAX);  -- LABEL2 : ',''Wxx'' AS C26, ...'
        DECLARE @v_cn_date_labels NVARCHAR(MAX);  -- LABEL3 : ',''260413'' AS C26, ...'
        DECLARE @v_cn_data_pivot  NVARCHAR(MAX);  -- DATA   : ',NULLIF(SUM(CASE WHEN A.YYYYMMDD = ''20260413'' THEN A.QTY END),0) AS C26, ...'

        -- 2026-05-13 김준규 [DECIMAL CAST 정밀도 변수화]
        --   목적: SUM 결과를 DECIMAL(p,s) 로 CAST → NVARCHAR(508) 컬럼 적재 시 길이 단축
        --   현재 (NUMERIC SUM 기본): "12345678.0000000000" (~38 byte/NVARCHAR)
        --   변경 (DECIMAL(15,0)):    "12345678"            (~16 byte/NVARCHAR)
        --   효과: 컬럼당 ~22 byte 절감 × NOT NULL 컬럼 ~307개 = 약 6,754 byte
        --         → 9,214 byte → ~2,460 byte (8060 한도 안전)
        --   향후 고객 요구 시: @v_dyn_dec_scale = 1 로만 변경 → "12345678.0" (1자리 표시)
        --                     DECIMAL(15,1) 도 9 byte storage (DECIMAL p<=9는 5 byte, 10~19는 9 byte)
        --   주의: max_abs_qty = 1.4억 < 999,999,999,999,999 (15자리) → DECIMAL(15,0) 안전
        --        소수점 < 0.5 데이터는 절단됨 (절단 OK 라고 사용자 확인됨)
        DECLARE @v_dyn_dec_precision INT = 15;
        -- 2026-05-13 김준규 수정: scale 0 → 1 → 2
        --   판정 근거 (이전 실행 #QTY_CAST_IMPACT_SUMMARY):
        --     - data_lost_rows = 0 (데이터 소멸 없음)
        --     - precision_lost_rows = 565 / 19,701 (2.87%)
        --     - SHIP_PLAN 영향 7.95% (228/2867 행) — 무시 불가
        --     - max_loss_amount = 0.4995 (반올림 한계점)
        --   scale=2 변경 영향:
        --     - row size +2 byte/컬럼 × 307 = +614 byte → 약 4,302 byte (8060 안전, 47% 여유)
        --     - 정밀도 손실 거의 0 (0.005 미만 반올림만)
        --     - max_abs_qty 1.4억(9자리) << 정수부 한도(13자리) → overflow 없음
        DECLARE @v_dyn_dec_scale     INT = 2;  -- (사용 안 함, 변수 유지만)
        -- 2026-05-22 김준규 변경: DECIMAL(15,2) → FLOAT
        --   사용자 요구: Production 입력값을 그대로 표시 (반올림 회피)
        --     DECIMAL(15,2): 179658.396953822 → 179658.40 (소수 2자리 반올림)
        --     FLOAT:         179658.396953822 → 179658.396953822 (가변 자릿수)
        --   안전성:
        --     SCM 데이터 max 약 1.4억(9자리) << FLOAT 일반표기 한도(1e15) → 지수표기 회피
        --     SUM 누적 부정확 우려 → 사용자 확인 "표시용이라 우려 없음"
        --     row size: FLOAT(8 byte) < DECIMAL(15,2)(9 byte)
        DECLARE @v_dyn_dec_spec      NVARCHAR(30) = N'FLOAT';

        IF @v_is_debug = 1
            RAISERROR(N'[DECIMAL CAST] @v_dyn_dec_spec = %s', 10, 1, @v_dyn_dec_spec) WITH NOWAIT;

        SELECT @v_cn_cols         = STRING_AGG(CAST(CN AS NVARCHAR(MAX)), N',') WITHIN GROUP (ORDER BY RNUM)
          FROM #TMP_DATE_AXIS;

        -- 2026-06-08 김준규: LABEL 전용 컬럼리스트(최대 364) — DATA 는 위 @v_cn_cols(전체) 사용
        SELECT @v_cn_cols_label   = STRING_AGG(CAST(CN AS NVARCHAR(MAX)), N',') WITHIN GROUP (ORDER BY RNUM)
          FROM #TMP_DATE_AXIS WHERE RNUM <= 364;

        SELECT @v_cn_qty_labels   = STRING_AGG(CAST(',N''' + QTY_LABEL  + ''' AS ' + CN AS NVARCHAR(MAX)), N'') WITHIN GROUP (ORDER BY RNUM)
          FROM #TMP_DATE_AXIS WHERE RNUM <= 364;

        SELECT @v_cn_week_labels  = STRING_AGG(CAST(',N''' + WEEK_LABEL + ''' AS ' + CN AS NVARCHAR(MAX)), N'') WITHIN GROUP (ORDER BY RNUM)
          FROM #TMP_DATE_AXIS WHERE RNUM <= 364;

        SELECT @v_cn_date_labels  = STRING_AGG(CAST(',N''' + YYMMDD     + ''' AS ' + CN AS NVARCHAR(MAX)), N'') WITHIN GROUP (ORDER BY RNUM)
          FROM #TMP_DATE_AXIS WHERE RNUM <= 364;

        -- 2026-05-13 김준규 [DECIMAL CAST 적용]
        --   기존: CONVERT(NVARCHAR(MAX), NULLIF(SUM(...),0))
        --         → SUM 결과 NUMERIC 의 implicit 변환 = "12345678.0000000000" (38 byte)
        --   변경: CONVERT(NVARCHAR(MAX), CAST(NULLIF(SUM(...),0) AS DECIMAL(15,0)))
        --         → "12345678" (16 byte) — 약 22 byte 절감/컬럼
        --   변수: @v_dyn_dec_spec (DECIMAL(15,0) ↔ DECIMAL(15,1) 즉시 전환)
        --SELECT @v_cn_data_pivot   = STRING_AGG(CAST(',CONVERT(NVARCHAR(MAX), CAST(NULLIF(SUM(CASE WHEN A.YYYYMMDD = N''' + YYYYMMDD + ''' THEN A.QTY END),0) AS ' + @v_dyn_dec_spec + N')) AS ' + CN AS NVARCHAR(MAX)), N'')
        SELECT @v_cn_data_pivot   = STRING_AGG(CAST(',CONVERT(NVARCHAR(MAX), FORMAT(CAST(NULLIF(SUM(CASE WHEN A.YYYYMMDD = N''' + YYYYMMDD + ''' THEN A.QTY END),0) AS FLOAT), N''G15'')) AS ' + CN AS NVARCHAR(MAX)), N'')
                                    WITHIN GROUP (ORDER BY RNUM)
          FROM #TMP_DATE_AXIS;

        DECLARE @SQL NVARCHAR(MAX);

PRINT '--A@X#02810--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        ---------------------------------------------------------------------------------
        -- LABEL 행 (SORT_SEQ1=10) : C1~C25 고정 라벨 + C26~CN = QTY번호
        --
        -- 2026-05-12 김준규: INSERT 절 / SELECT 절 변수 분리
        --   - @SQL_INSERT = "INSERT INTO ... (컬럼리스트)" 부분
        --   - @SQL_SELECT = "SELECT ... values" 부분
        --   - @v_is_debug = 1 시 SELECT 만 별도 실행하여 결과 화면 확인 가능
        --   - 실제 INSERT 는 @SQL_INSERT + @SQL_SELECT 로 합쳐서 실행
        ---------------------------------------------------------------------------------
        DECLARE @SQL_INSERT_LABEL1  NVARCHAR(MAX);
        DECLARE @SQL_SELECT_LABEL1  NVARCHAR(MAX);

        SET @SQL_INSERT_LABEL1 = N'
            INSERT INTO SCM_SIM_DYN_COLS
                (SNAP_YYYYMMDD, REPORT_TITLE, PLANT_ID, PLAN_GROUP, DIVISION_ID
                ,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20
                ,C21,C22,C23,C24,C25,C26,C27,C28,C29,C30,C31
                ,' + @v_cn_cols_label + N'
                -- 2026-05-09 김준규 수정: tail 컬럼 C771~C778 고정 (이전: C771~C776 6개)
                --   사유1: Excel layout 상 tail 메타데이터 위치를 데이터 일자수와 무관하게 고정
                --   사유2: CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE 4건 제거 (실제 audit 컬럼과 중복)
                --   사유3: ITEM_TYPE/SHEET_TYPE 2건 추가 (다른 SP 와 동일한 tail 구조)
                ,C771,C772,C773,C774,C775,C776,C777,C778,C779
                ,SORT_SEQ1, CREATED_BY, LAST_UPDATED_BY, BATCH_ID)
        ';

        SET @SQL_SELECT_LABEL1 = N'
            SELECT
                 @P_SNAP_YYYYMMDD                       AS SNAP_YYYYMMDD
                ,@v_report_type                         AS REPORT_TITLE
                ,@P_PLANT_IDS                           AS PLANT_ID
                ,N''''                                  AS PLAN_GROUP
                ,@P_DIVISION_ID                         AS DIVISION_ID
                -- [Excel RAW B~AF : 31 head metadata]
                ,N''DIVISION''             AS C1
                ,N''PLAN_START_YYYYMMDD''  AS C2
                ,N''CREATE_FROM_YYYYMMDD'' AS C3
                ,N''PLAN_TYPE''            AS C4
                ,N''SEQ''                  AS C5
                ,N''OPERATION''            AS C6
                ,N''FROM_SITE''            AS C7
                ,N''FROM SITE''            AS C8
                ,N''CELL ITEM ID''         AS C9
                ,N''ITEM ID''              AS C10
                ,N''NICK''                 AS C11
                ,N''TEAM''                 AS C12
                ,N''CELL QTY''             AS C13
                ,N''MEASURE''              AS C14
                ,N''FROM BOH QTY''         AS C15
                ,N''MEASURE LABEL''        AS C16
                ,N''PROJECT''              AS C17
                ,N''TO_SITE''              AS C18
                ,N''TO SITE''              AS C19
                ,N''INCOTERMS''            AS C20
                ,N''BOD ID''               AS C21
                ,N''TRANS''                AS C22
                ,N''YIELD''                AS C23
                ,N''LINE''                 AS C24
                ,N''ITEM_TYPE''            AS C25
                ,N''LT_DAY''               AS C26
                ,N''PRIORITY''             AS C27
                ,N''GRO STD DIO''          AS C28
                ,N''MIN STD DIO''          AS C29
                ,N''MEASURE_ORDER''        AS C30
                ,N''XLS_KEY1''             AS C31
                ' + @v_cn_qty_labels + N'
                -- [Excel RAW : 8 tail metadata]
                ,N''ATTRIBUTE1''           AS C771
                ,N''ATTRIBUTE3''           AS C772
                ,N''ATTRIBUTE9''           AS C773
                ,N''ATTRIBUTE10''          AS C774
                ,N''SHEET_TYPE''           AS C775
                ,N''RNO''                  AS C776
                ,N''ITEM_TYPE''            AS C777
                ,N''SHEET_TYPE''           AS C778
                ,N''MEASURE_LEVEL2''       AS C779
                ,10                                     AS SORT_SEQ1
                ,@v_user                                AS CREATED_BY
                ,@v_user                                AS LAST_UPDATED_BY
                ,@v_batch_id                            AS BATCH_ID
        ';

        -- [DEBUG] @v_is_debug = 1 시 SELECT 결과 화면 출력
        IF @v_is_debug = 1
        BEGIN
            PRINT '--A@X#02810_DEBUG_SELECT_LABEL1--';
            EXEC sp_executesql @SQL_SELECT_LABEL1,
                N'@P_SNAP_YYYYMMDD NVARCHAR(8), @v_report_type NVARCHAR(254), @P_PLANT_IDS NVARCHAR(30), @P_DIVISION_ID NVARCHAR(30), @v_user NVARCHAR(150), @v_batch_id BIGINT',
                @P_SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD, @v_report_type = @v_report_type, @P_PLANT_IDS = @P_PLANT_IDS, @P_DIVISION_ID = @P_DIVISION_ID, @v_user = @v_user, @v_batch_id = @v_batch_id;
        END

        -- 실제 INSERT: 두 동적 SQL 합쳐서 실행
        SET @SQL = @SQL_INSERT_LABEL1 + @SQL_SELECT_LABEL1 + N';';
        EXEC sp_executesql @SQL,
            N'@P_SNAP_YYYYMMDD NVARCHAR(8), @v_report_type NVARCHAR(254), @P_PLANT_IDS NVARCHAR(30), @P_DIVISION_ID NVARCHAR(30), @v_user NVARCHAR(150), @v_batch_id BIGINT',
            @P_SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD, @v_report_type = @v_report_type, @P_PLANT_IDS = @P_PLANT_IDS, @P_DIVISION_ID = @P_DIVISION_ID, @v_user = @v_user, @v_batch_id = @v_batch_id;

PRINT '--A@X#02820--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
        ---------------------------------------------------------------------------------
        -- LABEL2 행 (SORT_SEQ1=20) : C1~C25 NULL + C26~CN = 주차
        ---------------------------------------------------------------------------------
        SET @SQL = N'
            INSERT INTO SCM_SIM_DYN_COLS
                (SNAP_YYYYMMDD, REPORT_TITLE, PLANT_ID, PLAN_GROUP, DIVISION_ID
                ,' + @v_cn_cols_label + N'
                ,SORT_SEQ1, CREATED_BY, LAST_UPDATED_BY, BATCH_ID)
            SELECT @P_SNAP_YYYYMMDD, @v_report_type, @P_PLANT_IDS, N'''' AS PLAN_GROUP_REMOVED, @P_DIVISION_ID
                ' + @v_cn_week_labels + N'
                ,20, @v_user, @v_user, @v_batch_id;
        ';  -- [Excel layout] head 31 / tail 10 은 NULL (생략)
        EXEC sp_executesql @SQL,
            N'@P_SNAP_YYYYMMDD NVARCHAR(8), @v_report_type NVARCHAR(254), @P_PLANT_IDS NVARCHAR(30), @P_DIVISION_ID NVARCHAR(30), @v_user NVARCHAR(150), @v_batch_id BIGINT',
            @P_SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD, @v_report_type = @v_report_type, @P_PLANT_IDS = @P_PLANT_IDS, @P_DIVISION_ID = @P_DIVISION_ID, @v_user = @v_user, @v_batch_id = @v_batch_id;

PRINT '--A@X#02830--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
        ---------------------------------------------------------------------------------
        -- LABEL3 행 (SORT_SEQ1=30) : C1~C25 NULL + C26~CN = YYMMDD 6자리 일자
        ---------------------------------------------------------------------------------
        SET @SQL = N'
            INSERT INTO SCM_SIM_DYN_COLS
                (SNAP_YYYYMMDD, REPORT_TITLE, PLANT_ID, PLAN_GROUP, DIVISION_ID
                ,' + @v_cn_cols_label + N'
                ,SORT_SEQ1, CREATED_BY, LAST_UPDATED_BY, BATCH_ID)
            SELECT @P_SNAP_YYYYMMDD, @v_report_type, @P_PLANT_IDS, N'''' AS PLAN_GROUP_REMOVED, @P_DIVISION_ID
                ' + @v_cn_date_labels + N'
                ,30, @v_user, @v_user, @v_batch_id;
        ';
        EXEC sp_executesql @SQL,
            N'@P_SNAP_YYYYMMDD NVARCHAR(8), @v_report_type NVARCHAR(254), @P_PLANT_IDS NVARCHAR(30), @P_DIVISION_ID NVARCHAR(30), @v_user NVARCHAR(150), @v_batch_id BIGINT',
            @P_SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD, @v_report_type = @v_report_type, @P_PLANT_IDS = @P_PLANT_IDS, @P_DIVISION_ID = @P_DIVISION_ID, @v_user = @v_user, @v_batch_id = @v_batch_id;

PRINT '--A@X#02840--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        -- ============================================================
        -- 2026-05-12 김준규 [DATA INSERT 분기 — SKELETON]
        --   일자 > 364 분할 케이스 안전망. 본격 분할 로직 구현 전 단계.
        --   현재: 분할 케이스 발생 시 명시적 차단 (운영 사고 방지)
        --   향후 본격 구현 시 #GROUP_META + Phase 1 INSERT + Phase 2 UPDATE 패턴
        -- ============================================================
        -- 2026-05-13 김준규 수정: PRINT → RAISERROR(..., 10, 1) WITH NOWAIT
        --   PRINT 는 버퍼링되어 SP 종료 시점에 일괄 flush — 중간 에러 시 누락 가능
        --   RAISERROR severity 10 + NOWAIT 은 즉시 클라이언트로 flush → 로그 유실 방지

        -- @v_split_required = 0 인 경우 (일자 ≤ 364): 아래 현재 단일 INSERT 그대로 실행
            IF @v_is_debug = 1 SELECT 'SCM_SIM_DYN_COLS_1' AS "SCM_SIM_DYN_COLS_1", * FROM  SCM_SIM_DYN_COLS WHERE BATCH_ID= @v_batch_id ORDER BY SORT_SEQ1

        ---------------------------------------------------------------------------------
        -- DATA 행 (SORT_SEQ1=40+) : 실데이터 + 일자별 PIVOT
        --   GROUP BY = 비-시간 식별 컬럼 (DIVISION_ID + ITEM 그룹 + MEASURE 등)
        ---------------------------------------------------------------------------------

        -- ============================================================
        -- 2026-05-11 김준규 진단: PIVOT 직전 #PSI_GLOBAL_SMALL_AUTO MEASURE 분포
        --   결과 = SCM_SIM_DYN_COLS DATA 행 생성 직전의 raw 분포
        --   진단 완료 후 제거 가능
        -- ============================================================
        IF @v_is_debug = 1
        BEGIN
            SELECT N'#PSI_GLOBAL_SMALL_AUTO_PRE_PIVOT' AS step
                  ,MEASURE
                  ,OPERATION_GROUP                                AS OG
                  ,COUNT(*)                                       AS cnt
                  ,SUM(CASE WHEN QTY = 0 THEN 0 ELSE 1 END)       AS nonzero_cnt
                  ,COUNT(DISTINCT ITEM_ID)                        AS distinct_items
              FROM #PSI_GLOBAL_SMALL_AUTO
             GROUP BY MEASURE, OPERATION_GROUP
             ORDER BY OPERATION_GROUP, MEASURE;

            -- ============================================================
            -- 2026-05-12 김준규 진단: PIVOT INSERT row size 8060 초과 후보
            --   각 PIVOT GROUP BY 키 (PIVOT 결과 1 row) 별 분석:
            --     - distinct_days  : 채워진 일자 수 (730 = 모든 일자 채움 → row size 위험)
            --     - nonzero_days   : 0 이 아닌 QTY 의 일자 수 (NULLIF 후 row 크기 결정)
            --     - sum_abs_qty    : 절대값 합계 (값 크기 → ROW 압축 효과 예측)
            --     - max_meta_len   : 메타 컬럼 최대 길이 (8060 byte 영향 추가)
            --   ORDER BY nonzero_days DESC: 가장 위험한 그룹 먼저
            --   해석:
            --     - nonzero_days > 400 + ROW 압축 미적용 → INSERT 실패 가능
            --     - ROW 압축 적용 시 nonzero_days 700 까지 안전 (값 작을 때)
            -- ============================================================
            SELECT TOP 30 N'#PSI_GLOBAL_SMALL_AUTO_ROW_SIZE' AS step
                  ,A.CELL_ITEM_ID
                  ,A.ITEM_ID
                  ,A.MEASURE
                  ,A.FROM_SITE
                  ,A.TO_SITE
                  ,A.PROD_LINE
                  ,COUNT(DISTINCT A.YYYYMMDD)                     AS distinct_days
                  ,SUM(CASE WHEN A.QTY <> 0 THEN 1 ELSE 0 END)    AS nonzero_days
                  ,SUM(ABS(ISNULL(A.QTY, 0)))                     AS sum_abs_qty
                  ,MAX(ABS(ISNULL(A.QTY, 0)))                     AS max_abs_qty
                  ,( ISNULL(LEN(A.CELL_ITEM_ID), 0)
                   + ISNULL(LEN(A.ITEM_ID), 0)
                   + ISNULL(LEN(A.MEASURE), 0)
                   + ISNULL(LEN(A.FROM_SITE), 0)
                   + ISNULL(LEN(A.TO_SITE), 0)
                   + ISNULL(LEN(A.PROJECT_CODE), 0)
                   + ISNULL(LEN(A.INCOTERMS), 0)
                   + ISNULL(LEN(A.BOD_ID), 0)
                   + ISNULL(LEN(A.TRANSPORT_MODE), 0)
                   + ISNULL(LEN(A.PROD_LINE), 0) )                AS meta_total_len
                  ,/* 예상 in-row byte */
                   ( SUM(CASE WHEN A.QTY <> 0 THEN 1 ELSE 0 END) * 9   /* QTY NUMERIC 9 byte */
                   + ( ISNULL(LEN(A.CELL_ITEM_ID), 0)
                     + ISNULL(LEN(A.ITEM_ID), 0)
                     + ISNULL(LEN(A.MEASURE), 0)
                     + ISNULL(LEN(A.FROM_SITE), 0)
                     + ISNULL(LEN(A.TO_SITE), 0)
                     + ISNULL(LEN(A.PROJECT_CODE), 0)
                     + ISNULL(LEN(A.INCOTERMS), 0)
                     + ISNULL(LEN(A.BOD_ID), 0)
                     + ISNULL(LEN(A.TRANSPORT_MODE), 0)
                     + ISNULL(LEN(A.PROD_LINE), 0)
                     ) * 2                                             /* NVARCHAR 2 byte/char */
                   + 400                                               /* tail + audit + overhead */
                   )                                              AS est_row_byte
              FROM #PSI_GLOBAL_SMALL_AUTO A
             GROUP BY A.CELL_ITEM_ID, A.ITEM_ID, A.MEASURE, A.FROM_SITE, A.TO_SITE,
                      A.PROJECT_CODE, A.FROM_BOH_QTY, A.TO_BOH_QTY, A.INCOTERMS,
                      A.TRANSPORT_MODE, A.PROD_LINE, A.BOD_ID,
                      A.ATTRIBUTE1, A.ATTRIBUTE9
             ORDER BY est_row_byte DESC;

            -- ============================================================
            -- 2026-05-12 김준규 진단: ROW 압축 적용 상태 확인
            -- ============================================================
            SELECT N'SCM_SIM_DYN_COLS_COMPRESSION' AS step,
                   o.name                          AS table_name,
                   p.partition_number,
                   p.data_compression_desc         AS compression_state,
                   p.rows                          AS approx_rows
              FROM sys.partitions p
              JOIN sys.objects o ON o.object_id = p.object_id
             WHERE o.name = N'SCM_SIM_DYN_COLS';

            -- ============================================================
            -- 2026-05-13 김준규 진단 [QTY 값 분포 + 자릿수]
            --   목적: DECIMAL(15,0) / (15,1) / (15,2) 변환 정밀도 결정
            --   결과 컬럼:
            --     - max_abs_qty   : 가장 큰 절대값 (NUMERIC 표현)
            --     - max_digits    : 텍스트화 시 자릿수 (DECIMAL 정밀도 기준)
            --     - min_abs_qty   : 가장 작은 NOT NULL 값
            --     - total_rows    : NOT NULL + NOT 0 행 수
            -- ============================================================
            SELECT N'#PSI_GLOBAL_SMALL_AUTO_QTY_RANGE'    AS step
                  ,MAX(ABS(QTY))                          AS max_abs_qty
                  ,MAX(LEN(CAST(ABS(QTY) AS NVARCHAR(30)))) AS max_digits
                  ,MIN(ABS(QTY))                          AS min_abs_qty
                  ,COUNT(*)                               AS total_rows
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE QTY IS NOT NULL AND QTY <> 0;

            -- ============================================================
            -- 2026-05-13 김준규 진단 [소수점 있는 QTY 샘플]
            --   목적: 소수점 손실 영향 확인 (정수만이면 DECIMAL(15,0) 안전)
            --   결과 컬럼:
            --     - QTY           : 원본 값
            --     - decimal_part  : QTY - FLOOR(QTY) (소수 부분)
            --     - decimal_part_len : 소수 부분 자릿수
            --   결과 0건 = 모든 QTY 가 정수 (DECIMAL(15,0) 손실 0)
            -- ============================================================
            SELECT TOP 10
                   N'#PSI_GLOBAL_SMALL_AUTO_QTY_DECIMAL'  AS step
                  ,QTY
                  ,QTY - FLOOR(QTY)                       AS decimal_part
                  ,LEN(CAST(QTY - FLOOR(QTY) AS NVARCHAR(30)))  AS decimal_part_len
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE QTY IS NOT NULL
               AND QTY <> 0
               AND QTY <> FLOOR(QTY)   -- 소수 있는 행만
             ORDER BY NEWID();

            -- ============================================================
            -- 2026-05-13 김준규 진단 [DECIMAL(15,0) CAST 절단 영향 분석]
            --   목적: 현재 @v_dyn_dec_scale=0 적용 시 발생하는 정밀도 손실 정량화
            --        고객 요구 시 @v_dyn_dec_scale=1 로 변경 결정 근거
            --   판정 규칙:
            --     - CAST_VAL = CAST(QTY AS DECIMAL(15,0))  (현재 적용되는 값, 반올림됨)
            --     - "절단 영향" = (CAST_VAL <> QTY) — 값이 바뀐 모든 행
            --     - "데이터 소멸" = (QTY <> 0 AND CAST_VAL = 0) — 가장 위험
            --                       예: 0.4 → 0, -0.3 → 0 (의미 있는 값이 사라짐)
            --     - "정밀도 손실" = (QTY <> 0 AND CAST_VAL <> 0 AND CAST_VAL <> QTY)
            --                       예: 123.7 → 124 (값은 보존되나 소수점 손실)
            -- ============================================================

            ---------------------------------------------------------------
            -- ① 절단 영향 요약 (전체 1 row)
            ---------------------------------------------------------------
            SELECT N'#QTY_CAST_IMPACT_SUMMARY'                         AS step
                  ,COUNT(*)                                            AS total_qty_rows
                  ,SUM(CASE WHEN QTY <> CAST(QTY AS DECIMAL(15,0))                                  THEN 1 ELSE 0 END) AS affected_rows
                  ,SUM(CASE WHEN QTY <> 0 AND CAST(QTY AS DECIMAL(15,0)) = 0                        THEN 1 ELSE 0 END) AS data_lost_rows
                  ,SUM(CASE WHEN QTY <> 0 AND CAST(QTY AS DECIMAL(15,0)) <> 0
                            AND QTY <> CAST(QTY AS DECIMAL(15,0))                                   THEN 1 ELSE 0 END) AS precision_lost_rows
                  ,CAST(100.0 * SUM(CASE WHEN QTY <> CAST(QTY AS DECIMAL(15,0)) THEN 1 ELSE 0 END)
                              / NULLIF(COUNT(*),0) AS DECIMAL(5,2))                                                   AS affected_pct
                  ,MAX(ABS(QTY - CAST(QTY AS DECIMAL(15,0))))                                       AS max_loss_amount
                  ,SUM(ABS(QTY - CAST(QTY AS DECIMAL(15,0))))                                       AS total_loss_amount
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE QTY IS NOT NULL AND QTY <> 0;

            ---------------------------------------------------------------
            -- ② MEASURE 별 절단 영향 분포 (TOP 30) — 어느 measure 가 위험한지
            ---------------------------------------------------------------
            SELECT TOP 30
                   N'#QTY_CAST_IMPACT_BY_MEASURE'                      AS step
                  ,MEASURE
                  ,COUNT(*)                                            AS total_rows
                  ,SUM(CASE WHEN QTY <> CAST(QTY AS DECIMAL(15,0))                                  THEN 1 ELSE 0 END) AS affected_rows
                  ,SUM(CASE WHEN QTY <> 0 AND CAST(QTY AS DECIMAL(15,0)) = 0                        THEN 1 ELSE 0 END) AS data_lost_rows
                  ,CAST(100.0 * SUM(CASE WHEN QTY <> CAST(QTY AS DECIMAL(15,0)) THEN 1 ELSE 0 END)
                              / NULLIF(COUNT(*),0) AS DECIMAL(5,2))                                                   AS affected_pct
                  ,MAX(ABS(QTY - CAST(QTY AS DECIMAL(15,0))))                                       AS max_loss_amount
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE QTY IS NOT NULL AND QTY <> 0
             GROUP BY MEASURE
            HAVING SUM(CASE WHEN QTY <> CAST(QTY AS DECIMAL(15,0)) THEN 1 ELSE 0 END) > 0  -- 영향 있는 measure 만
             ORDER BY affected_rows DESC, MEASURE;

            ---------------------------------------------------------------
            -- ③ 데이터 소멸 위험 샘플 (CAST 후 0 되는 행, TOP 10)
            --    이 결과가 비어있으면 DECIMAL(15,0) 으로 데이터 손실 없음
            ---------------------------------------------------------------
            SELECT TOP 10
                   N'#QTY_CAST_DATA_LOST_SAMPLE'                       AS step
                  ,MEASURE
                  ,ITEM_ID
                  ,FROM_SITE
                  ,YYYYMMDD
                  ,QTY                                                 AS original_qty
                  ,CAST(QTY AS DECIMAL(15,0))                          AS cast_qty
                  ,QTY                                                 AS lost_amount
              FROM #PSI_GLOBAL_SMALL_AUTO
             WHERE QTY IS NOT NULL
               AND QTY <> 0
               AND CAST(QTY AS DECIMAL(15,0)) = 0  -- 절단 후 0이 되는 행
             ORDER BY ABS(QTY) DESC;
        END

        -- ============================================================================
        -- 2026-06-08 김준규 [worktable 8060 회피] SORT_SEQ1/RNO 사전계산 → 본 INSERT 는 JOIN 만
        --   배경: 단일 INSERT 가 GROUP BY + ROW_NUMBER(OVER ORDER BY) 를 한 문장에서 수행 →
        --         정렬 worktable 이 588 PIVOT 컬럼 행을 담아 8060 초과.
        --   조치: ROW_NUMBER 를 PIVOT 없는 좁은 쿼리(#SORT_MAP)에서 사전계산 → 정렬 worktable 좁아짐.
        --         본 INSERT 는 ROW_NUMBER 제거 + #SORT_MAP JOIN 으로 RN 만 가져옴.
        --   순서정의: 단일 INSERT 의 기존 ROW_NUMBER ORDER BY 와 100% 동일 (is_added 포함).
        --   주의: WHERE 필터 없음(단일 INSERT 와 동일 그룹). GROUP BY 집계 worktable 은 옵티마이저 의존.
        -- ============================================================================
        IF OBJECT_ID('tempdb..#SORT_MAP') IS NOT NULL DROP TABLE #SORT_MAP;
        ;WITH SM_BASE AS (
            SELECT  A.DIVISION_ID, A.OPERATION_GROUP, A.CELL_ITEM_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE
                   ,A.PROJECT_CODE, A.FROM_BOH_QTY, A.TO_BOH_QTY, A.INCOTERMS
                   ,A.TRANSPORT_MODE, A.PROD_LINE, A.MEASURE, A.BOD_ID, A.ATTRIBUTE1, A.ATTRIBUTE9
                   ,MAX(A.ATTRIBUTE10)         AS MAX_ATTRIBUTE10
                   ,MIN(A.SORT_ORDER_NO)       AS MIN_SORT_ORDER_NO
                   ,MAX(A.COLUMN_LABEL_NAME)   AS MAX_COLUMN_LABEL_NAME
                   ,MAX(CASE WHEN K2.BOD_ID IS NULL THEN 0 ELSE 1 END) AS IS_AMEND_ADDED
              FROM #PSI_GLOBAL_SMALL_AUTO A WITH (NOLOCK)
              LEFT JOIN #AMEND_ADDED_KEYS K2 WITH (NOLOCK)
                ON  K2.DIVISION_ID = A.DIVISION_ID AND K2.ITEM_ID = A.ITEM_ID
                AND K2.FROM_SITE   = A.FROM_SITE   AND K2.BOD_ID  = A.BOD_ID
             GROUP BY A.DIVISION_ID, A.OPERATION_GROUP, A.CELL_ITEM_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE
                     ,A.PROJECT_CODE, A.FROM_BOH_QTY, A.TO_BOH_QTY, A.INCOTERMS
                     ,A.TRANSPORT_MODE, A.PROD_LINE, A.MEASURE, A.BOD_ID
                     ,A.ATTRIBUTE1, A.ATTRIBUTE9
        )
        SELECT  DIVISION_ID, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, FROM_SITE, TO_SITE
               ,PROJECT_CODE, FROM_BOH_QTY, TO_BOH_QTY, INCOTERMS
               ,TRANSPORT_MODE, PROD_LINE, MEASURE, BOD_ID, ATTRIBUTE1, ATTRIBUTE9
               ,ROW_NUMBER() OVER (ORDER BY
                       DIVISION_ID
                      ,OPERATION_GROUP DESC
                      ,CELL_ITEM_ID
                      ,CASE WHEN OPERATION_GROUP = 'P' THEN '0'
                            WHEN OPERATION_GROUP = 'A' THEN DBO.FN_GET_FINAL_ITEM(DIVISION_ID, ITEM_ID, 'CELL_SORT')
                            ELSE '9' END
                      ,(CASE WHEN ATTRIBUTE1 = 'DIO' THEN '-' ELSE OPERATION_GROUP END) DESC
                      ,ITEM_ID
                      ,IS_AMEND_ADDED
                      ,(CASE WHEN (TO_SITE = '-' AND MEASURE = 'MKT_FCST_PACK_TOTAL') THEN 'ZZZ'
                             WHEN (TO_SITE = '-' AND MEASURE = 'MKT_FCST_CELL_TOTAL') THEN 'AAA'
                             ELSE TO_SITE END) DESC
                      ,ITEM_ID
                      ,INCOTERMS
                      ,(CASE WHEN (FROM_SITE = '-' AND MEASURE LIKE 'CELL%') THEN 'AAA' ELSE FROM_SITE END)
                      ,PROJECT_CODE
                      ,MAX_ATTRIBUTE10
                      ,(CASE WHEN MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH') THEN 'ZZZ' ELSE PROD_LINE END)
                      ,MIN_SORT_ORDER_NO
                      ,TRANSPORT_MODE
                      ,MAX_COLUMN_LABEL_NAME DESC
                   ) AS RN
          INTO #SORT_MAP
          FROM SM_BASE;

        -- ========================================================================
        -- 2026-06-08 김준규 [YEARBLOCK] DATA 를 364일 블록별 '별도 물리행' 으로 분리 INSERT
        --   목적: 한 행 ≤364 컬럼 → 저장/worktable/정렬 8060 모두 회피 (값길이 무관, 항상 안전).
        --   구조: 블록 b 의 일자(RNUM blk_start~blk_end)를 블록상대 컬럼 C32~C(31+len) 에 적재,
        --         C3(CREATE_FROM)=블록 시작일. 40_RPT 는 ORDER BY C3 로 블록 구분/정렬(기존 지원).
        --   값표현: FLOAT G15 (DECIMAL 복원 — 블록분리로 길이 무관).
        --   빈 블록행은 HAVING 으로 생략 (해당 블록에 일자 데이터 있는 그룹만 INSERT).
        --   SORT_SEQ1/RNO 는 #SORT_MAP.RN 공통 사용 (RPT 가 C3 우선정렬 → 블록간 동일 RN 무방).
        -- ========================================================================
        DECLARE @v_blk_size INT = 364;
        DECLARE @v_blk_cnt  INT = (@v_n_days + @v_blk_size - 1) / @v_blk_size;  -- ceil
        DECLARE @v_b INT = 1, @v_blk_start INT, @v_blk_end INT, @v_blk_len INT;
        DECLARE @v_blk_from NVARCHAR(8), @v_blk_to NVARCHAR(8);
        DECLARE @v_cn_cols_blk NVARCHAR(MAX), @v_cn_data_pivot_blk NVARCHAR(MAX);
        IF @v_is_debug = 1 PRINT N'--A@X#YEARBLOCK-- @v_n_days=' + CAST(@v_n_days AS NVARCHAR(10)) + N' blocks=' + CAST(@v_blk_cnt AS NVARCHAR(10));

        -- ============================================================================================
        -- 2026-06-17 김준규 [성능튜닝] SCP_MST_FORMATION_V → #FORMATION_V_CACHE (PIVOT 그룹/블록마다 뷰 재평가 제거)
        --   사유 : DATA INSERT(동적SQL) 의 YIELD 스칼라 서브쿼리가 SCP_MST_FORMATION_V(뷰) 를 그룹×블록마다 재평가.
        --   조치 : 뷰를 분기 전 1회만 #temp 에 적재 후 동적SQL 에서 #FORMATION_V_CACHE 로 조회 (서브쿼리 로직 동일 → 출력 불변).
        --   주의 : WITH(CTE)는 참조 시 재평가되어 효과 없음 → #temp 필수.
        -- ============================================================================================
        IF OBJECT_ID('tempdb..#FORMATION_V_CACHE') IS NOT NULL DROP TABLE #FORMATION_V_CACHE;
        SELECT F.DIVISION_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.SSP_MODIFY_YIELD, F.FORMATION_TOTAL_YIELD
          INTO #FORMATION_V_CACHE
          FROM dbo.SCP_MST_FORMATION_V F WITH(NOLOCK)
         WHERE F.DIVISION_ID = @P_DIVISION_ID;
        CREATE CLUSTERED INDEX IX_FVC_KEY ON #FORMATION_V_CACHE (DIVISION_ID, PLANT_SITE_ID, ITEM_ID);

        WHILE @v_b <= @v_blk_cnt
        BEGIN
            SET @v_blk_start = (@v_b - 1) * @v_blk_size + 1;
            SET @v_blk_end   = CASE WHEN @v_b * @v_blk_size < @v_n_days THEN @v_b * @v_blk_size ELSE @v_n_days END;
            SET @v_blk_len   = @v_blk_end - @v_blk_start + 1;
            SET @v_blk_from  = CONVERT(NVARCHAR(8), DATEADD(DAY, @v_blk_start - 1, @v_start_dt), 112);
            SET @v_blk_to    = CONVERT(NVARCHAR(8), DATEADD(DAY, @v_blk_end   - 1, @v_start_dt), 112);

            -- 블록상대 컬럼리스트 (C32..C(31+len))
            SELECT @v_cn_cols_blk = STRING_AGG(CAST('C' + CONVERT(NVARCHAR(10), RNUM - @v_blk_start + 32) AS NVARCHAR(MAX)), N',') WITHIN GROUP (ORDER BY RNUM)
              FROM #TMP_DATE_AXIS WHERE RNUM BETWEEN @v_blk_start AND @v_blk_end;

            -- 블록상대 DATA PIVOT (FLOAT G15 복원)
            --개발8k에러
            SELECT @v_cn_data_pivot_blk = STRING_AGG(CAST(',CONVERT(NVARCHAR(MAX), FORMAT(CAST(NULLIF(SUM(CASE WHEN A.YYYYMMDD = N''' + YYYYMMDD + ''' THEN A.QTY END),0) AS FLOAT), N''G15'')) AS C' + CONVERT(NVARCHAR(10), RNUM - @v_blk_start + 32) AS NVARCHAR(MAX)), N'') WITHIN GROUP (ORDER BY RNUM)
            --개발8k에러 방지책
            --SELECT @v_cn_data_pivot_blk = STRING_AGG(CAST(',CONVERT(NVARCHAR(30), CAST(NULLIF(SUM(CASE WHEN A.YYYYMMDD = N''' + YYYYMMDD + ''' THEN A.QTY END),0) AS DECIMAL(20,4))) AS C' + CONVERT(NVARCHAR(10), RNUM - @v_blk_start + 32) AS NVARCHAR(MAX)), N'') WITHIN GROUP (ORDER BY RNUM)
              FROM #TMP_DATE_AXIS WHERE RNUM BETWEEN @v_blk_start AND @v_blk_end;

        SET @SQL = N'
            INSERT INTO SCM_SIM_DYN_COLS
                (SNAP_YYYYMMDD, REPORT_TITLE, PLANT_ID, PLAN_GROUP, DIVISION_ID
                -- [Excel RAW B~AF : 31 head metadata]
                ,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10
                ,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20
                ,C21,C22,C23,C24,C25,C26,C27,C28,C29,C30,C31
                ,' + @v_cn_cols_blk + N'
                -- 2026-05-09 김준규 수정: tail 컬럼 C771~C778 고정 (이전: C771~C776 6개)
                --   사유1: Excel layout 상 tail 메타데이터 위치를 데이터 일자수와 무관하게 고정
                --   사유2: CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE 4건 제거 (실제 audit 컬럼과 중복)
                --   사유3: ITEM_TYPE/SHEET_TYPE 2건 추가 (다른 SP 와 동일한 tail 구조)
                ,C771,C772,C773,C774,C775,C776,C777,C778,C779
                ,SORT_SEQ1, CREATED_BY, LAST_UPDATED_BY, BATCH_ID)
            SELECT
                 @P_SNAP_YYYYMMDD, @v_report_type, @P_PLANT_IDS, N'''' AS PLAN_GROUP_REMOVED, @P_DIVISION_ID
                -- ── 31 head metadata (Excel RAW B4~AF4 순서) ──
                ,A.DIVISION_ID                                  -- C1  DIVISION
                ,@p_plan_start_yyyymmdd                         -- C2  PLAN_START_YYYYMMDD
                ,@v_blk_from                                    -- C3  CREATE_FROM_YYYYMMDD (YEARBLOCK 블록시작일)
                ,@P_PLAN_TYPE                                   -- C4  PLAN_TYPE
                ,CONVERT(NVARCHAR(20), @P_PLAN_SEQ)             -- C5  SEQ
                ,A.OPERATION_GROUP                              -- C6  OPERATION
                ,A.FROM_SITE                                    -- C7  FROM_SITE
                ,ISNULL(NULLIF((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M WITH(NOLOCK) WHERE M.SCM_SITE_ID = A.FROM_SITE), N''''), N''-'')   -- C8  FROM SITE (desc) [sub SP 라인 359]
                ,A.CELL_ITEM_ID                                 -- C9  CELL ITEM ID
                ,A.ITEM_ID                                      -- C10 ITEM ID
                ,(SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL OR X.NICK_NAME = N'''' THEN N''-'' ELSE X.NICK_NAME END) FROM dbo.SCM_MST_ITEM_SN X WITH(NOLOCK) WHERE X.ITEM_ID = A.ITEM_ID AND X.NICK_NAME IS NOT NULL)   -- C11 NICK [sub SP 라인 350]
                ,MAX(A.TEAM)                                    -- C12 TEAM [2026-05-12 김준규: PRE-PIVOT UPDATE 캐싱 → MAX 집계]
                ,0                                              -- C13 CELL QTY (sub SP도 0 고정)
                ,A.MEASURE                                      -- C14 MEASURE
                ,(CASE WHEN A.MEASURE IN (N''SEMI_SHIP_PLAN_TOTAL'', N''SHIP_PLAN_TOTAL'', N''EOH_TOTAL'')
                       THEN CONVERT(NVARCHAR(50), NULL)
                       ELSE FORMAT(A.FROM_BOH_QTY, N''G15'') END)   -- C15 FROM BOH QTY [2026-05-22 김준규: FORMAT G15 (trailing zero 제거)]
                ,MAX(A.COLUMN_LABEL_NAME)                       -- C16 MEASURE LABEL
                ,A.PROJECT_CODE                                 -- C17 PROJECT
                ,A.TO_SITE                                      -- C18 TO_SITE
                ,ISNULL(NULLIF((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M WITH(NOLOCK) WHERE M.SCM_SITE_ID = A.TO_SITE), N''''), N''-'')   -- C19 TO SITE (desc) [sub SP 라인 353]
                ,A.INCOTERMS                                    -- C20 INCOTERMS
                ,A.BOD_ID                                       -- C21 BOD ID
                ,A.TRANSPORT_MODE                               -- C22 TRANS
                -- 2026-05-09 김준규 수정: PACK_PROD YIELD 추가 (원본 S:1619, OPERATION_ID P9500/P5500/P5200 + ATTRIBUTE9 + PROD_LINE 매칭)
                -- 2026-05-22 김준규 수정: AS-WAS 빈칸 measure 추가 (CELL_EOH/CELL_FORM_PROGRESS/CELL_PROD/신규 3종)
                -- 2026-05-22 김준규 수정: 모든 분기 NVARCHAR(50) 통일 (overflow 회피)
                ,(CASE WHEN A.MEASURE IN (N''SEMI_SHIP_PLAN_TOTAL'', N''SHIP_PLAN_TOTAL'', N''EOH_TOTAL'',
                                          N''CELL_EOH'', N''CELL_FORM_PROGRESS'', N''CELL_PROD'')
                       THEN N''''                                  -- 2026-05-22 김준규: N''-'' → N'''' (빈 문자, Excel 빈칸 표시)
                       WHEN A.MEASURE IN (N''CELL_CHAR_AVAILABLE'', N''CELL_FOR_FORM_END'', N''CELL_PROD_FORM_END'')
                       THEN FORMAT(ISNULL((SELECT TOP 1 (CASE WHEN ISNULL(F.SSP_MODIFY_YIELD, 0) > 0.0
                                                       THEN ISNULL(F.SSP_MODIFY_YIELD, 0)
                                                       ELSE ISNULL(F.FORMATION_TOTAL_YIELD, 0) END)
                                      FROM #FORMATION_V_CACHE F WITH(NOLOCK)   -- 2026-06-17 김준규: SCP_MST_FORMATION_V → #temp 캐시
                                     WHERE F.DIVISION_ID    = A.DIVISION_ID
                                       AND F.ITEM_ID        IN (A.ITEM_ID, A.CELL_ITEM_ID)
                                       AND F.PLANT_SITE_ID  = A.FROM_SITE
                                     /* 2026-05-22 김준규: 다중 row 중 SSP_MODIFY_YIELD 또는 FORMATION_TOTAL_YIELD > 0 인 row 우선 (TOP 1 비결정성 해결) */
                                     ORDER BY (CASE WHEN ISNULL(F.SSP_MODIFY_YIELD, 0) > 0.0 OR ISNULL(F.FORMATION_TOTAL_YIELD, 0) > 0.0 THEN 0 ELSE 1 END)), 0), N''G15'')
                       WHEN A.MEASURE = N''PACK_PROD''
                       THEN FORMAT(ISNULL((SELECT TOP 1 T.YIELD
                                      FROM #tmp_SCP_MST_TACT_TIME T WITH(NOLOCK)
                                     WHERE T.DIVISION_ID    = A.DIVISION_ID
                                       AND T.ITEM_ID        = A.ITEM_ID
                                       AND T.PLANT_SITE_ID  = A.FROM_SITE
                                       AND T.OPERATION_ID   = A.ATTRIBUTE9
                                       AND T.LINE_ID        = A.PROD_LINE
                                       AND T.OPERATION_ID   IN (''P9500'', ''P5500'', ''P5200'')), 0), N''G15'')
                       -- 2026-05-29 김준규 [Issue1: YIELD]: ELSE N''1'' → HOLD measure 만 1, 나머지 blank.
                       --   기존 ELSE N''1'' 은 formation/PACK_PROD 외 모든 measure(CELL_EOH/SHIP/TOTAL 등)에 1.00 부여 →
                       --   좌측(AS-WAS) 은 HOLD measure 만 1.00, 나머지 공란. blank vs value 불일치 해결.
                       WHEN A.MEASURE IN (N''CELL_FORM_HOLD'', N''CELL_FORM_HOLD_AFTER'', N''CELL_FORM_HOLD_UNDER'', N''CELL_FORM_HOLD_UNDER_AVAILABLE'')
                       THEN N''1''
                       ELSE N'''' END)                          -- C23 YIELD [2026-05-29 김준규: HOLD=1, 그 외 blank]
                ,A.PROD_LINE                                    -- C24 LINE
                ,(CASE WHEN A.CELL_ITEM_ID = A.ITEM_ID THEN N''FG'' ELSE N''SEMI'' END)   -- C25 ITEM_TYPE [daily_small 라인 181]
                -- 2026-05-09 김준규 수정: LT_DAY inline CASE 적용
                --   2026-05-22 김준규 수정: 우선순위 재정렬 — measure 우선 분기를 LT_DAY=0 분기보다 앞으로
                --   1) CELL_PROD → SCP_MST_FORMATION 의 LT_FORMATION + ATTRIBUTE1 (LT_DAY 0/NULL 무관 우선)
                --   2) VMI 사이트 (LOOKUP_TYPE = VMI_LT_SITE) → MAX(SCP_VMI_LT)
                --   3) PACK_BOH PRE_INSP → SCP_MST_OPERATION_LT.LT_DAY
                --   4) Y.LT_DAY (PRE-PIVOT) 가 0/NULL → 0 (위 1~3 안 탄 경우)
                --   5) ELSE → BD.LT_TOTAL (daily)
                ,(CASE WHEN A.MEASURE = N''CELL_PROD''
                       THEN CONVERT(NVARCHAR(50),
                            ISNULL((SELECT TOP 1 F.LT_FORMATION + CONVERT(INT, ISNULL(F.ATTRIBUTE1, 0))
                                      FROM SCP_MST_FORMATION F WITH(NOLOCK)
                                     WHERE F.DIVISION_ID    = A.DIVISION_ID
                                       AND F.PLANT_SITE_ID  = A.FROM_SITE
                                       AND F.ITEM_ID        IN (A.ITEM_ID, A.CELL_ITEM_ID)
                                     /* 2026-05-22 김준규: 다중 row 중 LT_FORMATION > 0 인 row 우선 (TOP 1 비결정성 해결) */
                                     ORDER BY (CASE WHEN ISNULL(F.LT_FORMATION, 0) > 0 THEN 0 ELSE 1 END)), 0))
                       WHEN ISNULL(MAX(A.LT_DAY), 0) = 0 THEN N''0''                -- 2026-05-22 김준규: CELL_PROD 뒤로 이동 (CELL_PROD 우선 처리)
                       WHEN EXISTS (SELECT 1
                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL MD WITH(NOLOCK)
                                      INNER JOIN SCM_MST_SITE_ITEM S WITH(NOLOCK)
                                         ON  S.DIVISION_ID  = MD.SEGMENT1
                                        AND S.SCM_SITE_ID  = MD.SEGMENT2
                                        AND MD.LOOKUP_TYPE = ''VMI_LT_SITE''
                                        AND S.VALID_YN     = ''Y''
                                        AND MD.VALID_YN    = ''Y''
                                     WHERE S.DIVISION_ID = A.DIVISION_ID
                                       AND S.SCM_SITE_ID = A.FROM_SITE)
                       THEN CONVERT(NVARCHAR(50),
                            ISNULL((SELECT MAX(ISNULL(S.SCP_VMI_LT, 0))
                                      FROM SCM_MST_SITE_ITEM S WITH(NOLOCK)
                                     WHERE S.DIVISION_ID = A.DIVISION_ID
                                       AND S.SCM_SITE_ID = A.FROM_SITE), 0))
                       WHEN A.MEASURE = N''PACK_BOH''
                            AND EXISTS (SELECT 1 FROM SCP_MST_OPERATION_LT OP WITH(NOLOCK)
                                         WHERE OP.DIVISION_ID  = A.DIVISION_ID
                                           AND OP.ITEM_ID      = A.ITEM_ID
                                           AND OP.SCM_SITE_ID  = A.FROM_SITE
                                           AND OP.LT_OPERATION = ''PRE_INSP'')
                       THEN CONVERT(NVARCHAR(50),
                            ISNULL((SELECT TOP 1 OP.LT_DAY
                                      FROM SCP_MST_OPERATION_LT OP WITH(NOLOCK)
                                     WHERE OP.DIVISION_ID  = A.DIVISION_ID
                                       AND OP.ITEM_ID      = A.ITEM_ID
                                       AND OP.SCM_SITE_ID  = A.FROM_SITE
                                       AND OP.LT_OPERATION = ''PRE_INSP''), 0))
                       ELSE CONVERT(NVARCHAR(50), ISNULL(MAX(BD.LT_TOTAL), 0))       -- 2026-05-20 김준규 v2: BOD(INCOTERMS 5키) → BD(TRANSPORT_MODE 5키, A.5.4 JOIN 동일) — INCOTERMS=''-'' 매칭 실패 회피
                  END)                                          -- C26 LT_DAY [김준규: inline 5분기 CASE]
                ,ISNULL(CONVERT(NVARCHAR(50), NULLIF((SELECT TOP 1 priority FROM SCP_MST_BOD_V WITH(NOLOCK) WHERE division_id = A.DIVISION_ID AND bod_id = A.BOD_ID), 0)), N'''')   -- C27 PRIORITY [2026-05-20 김준규: 0 → 빈 문자 (AS-WAS 동일)]
                -- 2026-05-09 김준규 수정: ALLOCATION_DIO 일 때 GRO STD DIO 매핑 (원본 S:2255, JOIN: CELL_ITEM_ID = ITEM_ID)
                ,(CASE WHEN A.MEASURE = N''ALLOCATION_DIO''
                       THEN CONVERT(NVARCHAR(50),
                            ISNULL((SELECT TOP 1 D.GRO_STD_DIO
                                      FROM #tmp_SCP_MST_DIO_OLD D WITH(NOLOCK)
                                     WHERE D.ITEM_ID = A.CELL_ITEM_ID), 0))
                       ELSE N''N'' END)                         -- C28 GRO STD DIO [2026-05-20 김준규: 0 → N (AS-WAS 동일)] [김준규: ALLOCATION_DIO 매핑]
                ,(CASE WHEN A.MEASURE = N''ALLOCATION_DIO''
                       THEN CONVERT(NVARCHAR(50),
                            ISNULL((SELECT TOP 1 D.MIN_STD_DIO
                                      FROM #tmp_SCP_MST_DIO_OLD D WITH(NOLOCK)
                                     WHERE D.ITEM_ID = A.CELL_ITEM_ID), 0))
                       ELSE N''N'' END)                         -- C29 MIN STD DIO [2026-05-20 김준규: 0 → N (AS-WAS 동일)] MIN STD DIO [김준규: ALLOCATION_DIO 매핑]
                ,MIN(A.SORT_ORDER_NO)                           -- C30 MEASURE_ORDER
                ,CONVERT(NVARCHAR(200), NULL)                   -- C31 XLS_KEY1 (sub SP도 NULL)
                ' + @v_cn_data_pivot_blk + N'
                -- ── 6 tail metadata (CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE 4건 제거: 실제 audit 컬럼과 중복) ──
                ,A.ATTRIBUTE1                                   -- C771 ATTRIBUTE1
                -- 2026-05-09 김준규 수정: ATTRIBUTE3 옵션 B 적용 — PRE-PIVOT A.5.4/A.5.8 결과 사용
                ,MAX(A.ATTRIBUTE3)                               -- C772 ATTRIBUTE3 [김준규: PRE-PIVOT 처리]
                ,A.ATTRIBUTE9                                   -- C773 ATTRIBUTE9
                -- 2026-05-09 김준규 수정: ATTRIBUTE10 옵션 B 적용 — PRE-PIVOT A.5.6 까지 마지막 토글 결과 사용
                ,MAX(A.ATTRIBUTE10)                              -- C774 ATTRIBUTE10 [김준규: PRE-PIVOT 처리]
                ,(CASE WHEN A.MEASURE IN (N''CELL_EOH'', N''CELL_FOR_FORM_END'', N''CELL_PROD_FORM_END'', N''CELL_PROD'', N''CELL_FORM_PROGRESS'', N''CELL_FORM_HOLD_UNDER_AVAILABLE'', N''CELL_FORM_HOLD_AFTER'', N''SEMI_SHIP_PLAN_TOTAL'', N''SHIP_PLAN_TOTAL'', N''EOH_TOTAL'') THEN N''PROD'' ELSE N''SHIP'' END)   -- C775 SHEET_TYPE [daily_small 라인 182~184]
                ,CONVERT(NVARCHAR(20), SM.RN)   -- C776 RNO [2026-05-11 김준규: SORT_SEQ1 ORDER BY 와 동일 — Simulation 표시 순서 일관성]
                -- 2026-05-09 김준규 추가: C777 ITEM_TYPE, C778 SHEET_TYPE (다른 SP 와 동일 tail 구조)
                ,(CASE WHEN A.CELL_ITEM_ID = A.ITEM_ID THEN N''FG'' ELSE N''SEMI'' END)   -- C777 ITEM_TYPE [김준규 추가]
                ,(CASE WHEN A.MEASURE IN (N''CELL_EOH'', N''CELL_FOR_FORM_END'', N''CELL_PROD_FORM_END'', N''CELL_PROD'', N''CELL_FORM_PROGRESS'', N''CELL_FORM_HOLD_UNDER_AVAILABLE'', N''CELL_FORM_HOLD_AFTER'', N''SEMI_SHIP_PLAN_TOTAL'', N''SHIP_PLAN_TOTAL'', N''EOH_TOTAL'') THEN N''PROD'' ELSE N''SHIP'' END)   -- C778 SHEET_TYPE [김준규 추가]
                ,MIN(PMD.MEASURE_LEVEL2)                        -- C779 (level2: #PSI_MEASURE_DAILY JOIN)
                ,100000 + 1000 * SM.RN   -- 2026-06-08 김준규 [worktable 회피: #SORT_MAP.RN 사전계산]
                ,@v_user, @v_user, @v_batch_id
              FROM #PSI_GLOBAL_SMALL_AUTO A WITH (NOLOCK)
              LEFT JOIN #AMEND_ADDED_KEYS K2 WITH (NOLOCK)
                  ON  K2.DIVISION_ID = A.DIVISION_ID AND K2.ITEM_ID = A.ITEM_ID
                 AND K2.FROM_SITE   = A.FROM_SITE   AND K2.BOD_ID  = A.BOD_ID
              LEFT JOIN #PSI_MEASURE_DAILY PMD WITH(NOLOCK) ON PMD.MEASURE = A.MEASURE   -- 2026-05-31 김준규: level2(C779) 용 JOIN
              -- [TODO 완성] LT_DAY 1차 (weekly) — #SCP_MST_BOD_V 사용 (메인 SP 라인 5168 에서 생성됨)
              -- JOIN 키 (sub SP 라인 384~388 동일): DIVISION_ID, BOD_ID, FROM_SITE, TO_SITE, INCOTERMS
              LEFT OUTER JOIN #SCP_MST_BOD_V BOD WITH (NOLOCK)
                  ON  BOD.DIVISION_ID  = A.DIVISION_ID
                 AND BOD.BOD_ID        = A.BOD_ID
                 AND BOD.FROM_SITE     = A.FROM_SITE
                 AND BOD.TO_SITE       = A.TO_SITE
                 AND BOD.INCOTERMS     = A.INCOTERMS
              -- [TODO 완성] LT_DAY 2차 (daily) — 5키 매칭 시 raw LT_TOTAL 사용 (메인 SP UPDATE 로직 동일)
              -- JOIN 키 5개: DIVISION_ID, FROM_SITE, TO_SITE, TRANSPORT_MODE, BOD_ID
              LEFT OUTER JOIN #SCP_MST_BOD_N_V_DAILY BD WITH (NOLOCK)
                  ON  BD.DIVISION_ID    = A.DIVISION_ID
                 AND BD.FROM_SITE      = A.FROM_SITE
                 AND BD.TO_SITE        = A.TO_SITE
                 AND BD.TRANSPORT_MODE = A.TRANSPORT_MODE
                 AND BD.BOD_ID         = A.BOD_ID
              LEFT JOIN #SORT_MAP SM WITH (NOLOCK)
                  ON  ISNULL(CONVERT(NVARCHAR(100),SM.DIVISION_ID),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.DIVISION_ID),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.OPERATION_GROUP),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.OPERATION_GROUP),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.CELL_ITEM_ID),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.CELL_ITEM_ID),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.ITEM_ID),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.ITEM_ID),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.FROM_SITE),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.FROM_SITE),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.TO_SITE),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.TO_SITE),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.PROJECT_CODE),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.PROJECT_CODE),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.FROM_BOH_QTY),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.FROM_BOH_QTY),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.TO_BOH_QTY),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.TO_BOH_QTY),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.INCOTERMS),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.INCOTERMS),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.TRANSPORT_MODE),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.TRANSPORT_MODE),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.PROD_LINE),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.PROD_LINE),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.MEASURE),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.MEASURE),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.BOD_ID),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.BOD_ID),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.ATTRIBUTE1),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.ATTRIBUTE1),N''~'')
                  AND ISNULL(CONVERT(NVARCHAR(100),SM.ATTRIBUTE9),N''~'')=ISNULL(CONVERT(NVARCHAR(100),A.ATTRIBUTE9),N''~'')
             GROUP BY A.DIVISION_ID, A.OPERATION_GROUP, A.CELL_ITEM_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE
                     ,A.PROJECT_CODE, A.FROM_BOH_QTY, A.TO_BOH_QTY, A.INCOTERMS
                     ,A.TRANSPORT_MODE, A.PROD_LINE, A.MEASURE, A.BOD_ID
                     ,A.ATTRIBUTE1, A.ATTRIBUTE9, SM.RN
             HAVING MAX(CASE WHEN A.YYYYMMDD BETWEEN @v_blk_from AND @v_blk_to THEN 1 ELSE 0 END) = 1;
        ';
--PRINT @SQL_STMT;
IF @v_is_debug = 1
BEGIN
    -- 2026-05-22 김준규: 분할 분기와 동일한 청크 분할 PRINT 패턴 적용
    --   기존 LEFT/SUBSTRING(@DUMMY) 방식 → 문장 부정확 (수작업 변경 필요했음)
    --   변경: SUBSTRING(@SQL, pos, len) + CRLF 위치 청크 분할 (4000자 한도 안전)
    DECLARE @v_dbg_chunk_max INT          = 3900;
    DECLARE @v_dbg_pp        INT          = 1;
    DECLARE @v_dbg_total     INT          = LEN(@SQL);
    DECLARE @v_dbg_chunk_len INT;
    DECLARE @v_dbg_substr    NVARCHAR(4000);
    DECLARE @v_dbg_rev_lf    INT;

    PRINT N'--A@X#RAW_SQL_PRINT_START-- (SINGLE_INSERT) len=' + CAST(@v_dbg_total AS NVARCHAR(20));

    WHILE @v_dbg_pp <= @v_dbg_total
    BEGIN
        IF @v_dbg_pp + @v_dbg_chunk_max - 1 >= @v_dbg_total
            SET @v_dbg_chunk_len = @v_dbg_total - @v_dbg_pp + 1;
        ELSE
        BEGIN
            SET @v_dbg_substr = SUBSTRING(@SQL, @v_dbg_pp, @v_dbg_chunk_max);
            SET @v_dbg_rev_lf = CHARINDEX(CHAR(10), REVERSE(@v_dbg_substr));
            IF @v_dbg_rev_lf > 0 AND @v_dbg_rev_lf < @v_dbg_chunk_max
                SET @v_dbg_chunk_len = LEN(@v_dbg_substr) - @v_dbg_rev_lf + 1;
            ELSE
                SET @v_dbg_chunk_len = @v_dbg_chunk_max;
        END
        PRINT SUBSTRING(@SQL, @v_dbg_pp, @v_dbg_chunk_len);
        SET @v_dbg_pp = @v_dbg_pp + @v_dbg_chunk_len;
    END
    PRINT N'--A@X#RAW_SQL_PRINT_END-- (SINGLE_INSERT)';
END;

        EXEC sp_executesql @SQL,
            N'@P_SNAP_YYYYMMDD NVARCHAR(8), @v_report_type NVARCHAR(254), @P_PLANT_IDS NVARCHAR(30), @P_DIVISION_ID NVARCHAR(30),@P_PLAN_START_YYYYMMDD  NVARCHAR(8), @P_PLAN_TYPE NVARCHAR(30), @P_PLAN_SEQ INT, @v_user NVARCHAR(150), @v_batch_id BIGINT, @v_blk_from NVARCHAR(8), @v_blk_to NVARCHAR(8)',
            @P_SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD, @v_report_type = @v_report_type, @P_PLANT_IDS = @P_PLANT_IDS, @P_DIVISION_ID = @P_DIVISION_ID, @P_PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD, @P_PLAN_TYPE = @P_PLAN_TYPE, @P_PLAN_SEQ = @P_PLAN_SEQ, @v_user = @v_user, @v_batch_id = @v_batch_id, @v_blk_from = @v_blk_from, @v_blk_to = @v_blk_to;

            SET @v_b = @v_b + 1;
        END   -- WHILE YEARBLOCK


            IF @v_is_debug = 1 SELECT 'SCM_SIM_DYN_COLS_2' AS "SCM_SIM_DYN_COLS_2", * FROM  SCM_SIM_DYN_COLS WHERE BATCH_ID= @v_batch_id ORDER BY SORT_SEQ1

        -- DBG-14: 단일 INSERT 직후 신규 3종 measure 적재 여부 (사용자 환경 = 단일 분기 사용)
        IF @v_is_debug = 1
            SELECT '#DBG_14_SCM_DYN_NEW_MEASURE_SINGLE' AS DBG_TAG,
                   C14 AS MEASURE, COUNT(*) AS CNT
              FROM SCM_SIM_DYN_COLS WITH(NOLOCK)
             WHERE BATCH_ID = @v_batch_id
               AND C14 IN (N'CELL_EOH', N'SEMI_SHIP_PLAN_TOTAL', N'SHIP_PLAN_TOTAL', N'EOH_TOTAL',
                           N'CELL_FORM_HOLD_AFTER', N'CELL_FORM_PROGRESS')
             GROUP BY C14
             ORDER BY C14;

        -- DBG-15: 신규 3종 metadata (FROM_BOH_QTY/YIELD/LABEL) 검증 - AS-WAS Excel 빈칸 비교
        IF @v_is_debug = 1
            SELECT '#DBG_15_NEW_MEASURE_METADATA' AS DBG_TAG,
                   C14 AS MEASURE,
                   C15 AS FROM_BOH_QTY,        -- 빈칸 (NULL) 기대
                   C16 AS COLUMN_LABEL,        -- 'SEMI SHIP PLAN TOTAL'/'SHIP PLAN TOTAL'/'EOH TOTAL'
                   C23 AS YIELD,               -- '-' 기대
                   C24 AS LINE,
                   C25 AS ITEM_TYPE
              FROM SCM_SIM_DYN_COLS WITH(NOLOCK)
             WHERE BATCH_ID = @v_batch_id
               AND C14 IN (N'SEMI_SHIP_PLAN_TOTAL', N'SHIP_PLAN_TOTAL', N'EOH_TOTAL',
                           N'CELL_EOH', N'CELL_FORM_PROGRESS', N'CELL_PROD',
                           N'CELL_FOR_FORM_END', N'CELL_PROD_FORM_END')
             ORDER BY C14;

        -- DBG-16: SCP_MST_FORMATION/V 의 ITEM_ID vs CELL_ITEM_ID 매칭 검증
        --   YIELD (0.98) / LT_DAY (12) 누락 원인 추적
        IF @v_is_debug = 1
            SELECT DISTINCT '#DBG_16_FORMATION_MATCH' AS DBG_TAG,
                   A.MEASURE, A.ITEM_ID, A.CELL_ITEM_ID, A.FROM_SITE, A.DIVISION_ID,
                   (SELECT TOP 1 F.SSP_MODIFY_YIELD FROM SCP_MST_FORMATION_V F WITH(NOLOCK)
                     WHERE F.DIVISION_ID = A.DIVISION_ID AND F.ITEM_ID = A.ITEM_ID
                       AND F.PLANT_SITE_ID = A.FROM_SITE) AS YIELD_BY_ITEM,
                   (SELECT TOP 1 F.SSP_MODIFY_YIELD FROM SCP_MST_FORMATION_V F WITH(NOLOCK)
                     WHERE F.DIVISION_ID = A.DIVISION_ID AND F.ITEM_ID = A.CELL_ITEM_ID
                       AND F.PLANT_SITE_ID = A.FROM_SITE) AS YIELD_BY_CELL_ITEM,
                   (SELECT TOP 1 F.LT_FORMATION FROM SCP_MST_FORMATION F WITH(NOLOCK)
                     WHERE F.DIVISION_ID = A.DIVISION_ID AND F.ITEM_ID = A.ITEM_ID
                       AND F.PLANT_SITE_ID = A.FROM_SITE) AS LT_BY_ITEM,
                   (SELECT TOP 1 F.LT_FORMATION FROM SCP_MST_FORMATION F WITH(NOLOCK)
                     WHERE F.DIVISION_ID = A.DIVISION_ID AND F.ITEM_ID = A.CELL_ITEM_ID
                       AND F.PLANT_SITE_ID = A.FROM_SITE) AS LT_BY_CELL_ITEM
              FROM #PSI_GLOBAL_SMALL_AUTO A WITH(NOLOCK)
             WHERE A.MEASURE IN (N'CELL_FOR_FORM_END', N'CELL_PROD_FORM_END', N'CELL_PROD');

        -- DBG-17: SCP_MST_FORMATION_V 의 실제 데이터 (어떤 ITEM_ID/PLANT_SITE_ID 가 저장되어 있나)
        --   PLANT_SITE_ID 조건 없이 ITEM_ID 만으로 검색 → 사용자 환경의 PLANT_SITE_ID 값 확인
        IF @v_is_debug = 1
            SELECT TOP 20 '#DBG_17_FORMATION_V_DATA' AS DBG_TAG,
                   F.DIVISION_ID, F.ITEM_ID, F.PLANT_SITE_ID, 
                   F.SSP_MODIFY_YIELD, F.FORMATION_TOTAL_YIELD
              FROM dbo.SCP_MST_FORMATION_V F WITH(NOLOCK)
             WHERE F.DIVISION_ID = @P_DIVISION_ID
               AND F.ITEM_ID IN (
                    SELECT DISTINCT A.ITEM_ID FROM #PSI_GLOBAL_SMALL_AUTO A
                     WHERE A.MEASURE IN (N'CELL_FOR_FORM_END', N'CELL_PROD_FORM_END', N'CELL_PROD')
                    UNION
                    SELECT DISTINCT A.CELL_ITEM_ID FROM #PSI_GLOBAL_SMALL_AUTO A
                     WHERE A.MEASURE IN (N'CELL_FOR_FORM_END', N'CELL_PROD_FORM_END', N'CELL_PROD')
               );

        -- DBG-18: SCP_MST_FORMATION 의 실제 데이터 (LT_FORMATION 매핑 확인)
        IF @v_is_debug = 1
            SELECT TOP 20 '#DBG_18_FORMATION_DATA' AS DBG_TAG,
                   F.DIVISION_ID, F.ITEM_ID, F.PLANT_SITE_ID, 
                   F.LT_FORMATION, F.ATTRIBUTE1
              FROM SCP_MST_FORMATION F WITH(NOLOCK)
             WHERE F.DIVISION_ID = @P_DIVISION_ID
               AND F.ITEM_ID IN (
                    SELECT DISTINCT A.ITEM_ID FROM #PSI_GLOBAL_SMALL_AUTO A
                     WHERE A.MEASURE IN (N'CELL_FOR_FORM_END', N'CELL_PROD_FORM_END', N'CELL_PROD')
                    UNION
                    SELECT DISTINCT A.CELL_ITEM_ID FROM #PSI_GLOBAL_SMALL_AUTO A
                     WHERE A.MEASURE IN (N'CELL_FOR_FORM_END', N'CELL_PROD_FORM_END', N'CELL_PROD')
               );

        -- DBG-19: SCP_MST_FORMATION_V 의 컬럼 리스트 (혹시 다른 컬럼명?)
        IF @v_is_debug = 1
            SELECT '#DBG_19_FORMATION_V_COLUMNS' AS DBG_TAG,
                   COLUMN_NAME, DATA_TYPE
              FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_NAME = 'SCP_MST_FORMATION_V'
             ORDER BY ORDINAL_POSITION;
PRINT '--A@X#02900--' + ' ' + CAST(CAST(ROUND(DATEDIFF(MS, @v_start_time, SYSDATETIME()) / 1000.0, 0) AS INT) AS VARCHAR(20)) + 's ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        ---------------------------------------------------------------------------------
        -- 정리
        ---------------------------------------------------------------------------------

-- 2026-05-15 김준규: 진단용 SELECT 7개를 IF @v_is_debug = 1 으로 감싸기
IF @v_is_debug = 1
BEGIN
    -- 1) #PSI_GLOBAL_SMALL 에는 있는가? (CELL_PROD 흐름의 시작점)
    SELECT '1_PSI_GLOBAL_SMALL' AS step, MEASURE, COUNT(*) AS cnt, SUM(QTY) AS qty_sum
      FROM #PSI_GLOBAL_SMALL
     WHERE MEASURE IN ('CELL_PROD','INTRANSIT_ETA','PACK_PROD')
     GROUP BY MEASURE;

    -- 2) #ANL_PRODUCTION_PLAN 에는 있는가? (CELL_PROD 흐름 중간)
    SELECT '2_ANL_PROD_PLAN' AS step, MEASURE, COUNT(*) AS cnt
      FROM #ANL_PRODUCTION_PLAN
     WHERE MEASURE IN ('CELL_PROD','PACK_PROD')
     GROUP BY MEASURE;

    -- 3) #INTRANSIT 에는 있는가? (INTRANSIT_ETA 흐름)
    SELECT '3_INTRANSIT' AS step, COUNT(*) AS cnt FROM #INTRANSIT;

    -- 4) 최종 #PSI_GLOBAL_SMALL_AUTO 에는?
    SELECT '4_PSI_GLOBAL_SMALL_AUTO' AS step, MEASURE, COUNT(*) AS cnt, SUM(QTY) AS qty_sum
      FROM #PSI_GLOBAL_SMALL_AUTO
     WHERE MEASURE IN ('CELL_PROD','INTRANSIT_ETA','PACK_PROD','SEMI_INTRANSIT_ETA')
     GROUP BY MEASURE
     ORDER BY MEASURE;

    -- 5) #FILTER_ITEM에 어떤 ITEM_ID가 있는가
    SELECT '5 #FILTER_ITEM' "5_#FILTER_ITEM", FI.ITEM_ID, MFI.ATTRIBUTE8, MFI.OPERATION_GROUP
    FROM #FILTER_ITEM FI
    LEFT JOIN SCP_MST_FINAL_ITEM MFI WITH(NOLOCK)
       ON MFI.ITEM_ID = FI.ITEM_ID AND MFI.DIVISION_ID = @P_DIVISION_ID;

    -- 6) SCP_ANL_PRODUCTION_PLAN의 OPERATION_GROUP='A' 행이 #FILTER_ITEM에 매칭되는가
    SELECT TOP 100 '6 #FILTER_ITEM LEFT' "6_#FILTER_ITEM LEFT", A.ITEM_ID, A.OPERATION_GROUP,
           (CASE WHEN F.ITEM_ID IS NULL THEN 'MISSING' ELSE 'OK' END) AS in_filter
    FROM #STG_PROD_PLAN A WITH(NOLOCK)
    LEFT JOIN #FILTER_ITEM F ON A.ITEM_ID = F.ITEM_ID
    WHERE 1=1
      AND A.OPERATION_GROUP = 'A'  -- CELL
      AND A.MEASURE = 'PROD_PLAN_AMEND';

    -- 7) #INTRANSIT의 SITE_TYPE 분포
    SELECT '7 #FILTER_ITEM' "7_#INTRANSIT", SITE_TYPE, COUNT(*) FROM #INTRANSIT GROUP BY SITE_TYPE;
END

        IF OBJECT_ID('tempdb..#TMP_DATE_AXIS') IS NOT NULL DROP TABLE #TMP_DATE_AXIS;
        IF OBJECT_ID('tempdb..#SCP_MST_BOD_N_V_DAILY') IS NOT NULL DROP TABLE #SCP_MST_BOD_N_V_DAILY;

        -- 2026-05-09 김준규 추가: 패치 임시테이블 정리
        IF OBJECT_ID('tempdb..#BOH')                   IS NOT NULL DROP TABLE #BOH;
        IF OBJECT_ID('tempdb..#BOH_NHOLD')             IS NOT NULL DROP TABLE #BOH_NHOLD;
        IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO_OLD')   IS NOT NULL DROP TABLE #tmp_SCP_MST_DIO_OLD;
        IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL DROP TABLE #tmp_SCP_MST_TACT_TIME;

        SET @X_STATUS = 1;
        SET @X_MSG    = N'OK';
        RETURN 0;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        SET @X_STATUS = -1;
        SET @X_MSG    = LEFT(ISNULL(ERROR_MESSAGE(), N''), 200);
        RETURN -1;
    END CATCH;
END;
