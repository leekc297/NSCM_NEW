
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ELTR
 * Description  : ASSIGN 테이블 구조의 데이터를 파라미터로 Speed Plan Insert/Update
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/07/08   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/07/14   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 재계산 로직 수정
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
 * 2024/08/29   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DAY_CNT 로직 수정 - SOP 적용
 * 2024/12/11   chaan        V1.1.12               PJ20239037 LGES CPS VOE 반영 및 고도화                     - Partial 구간 오류 수정
 * 2025/02/10   mrchois      V1.1.14               PJ20249346  LGES SCP 개선과제 이행	 - Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
*/

--DROP PROCEDURE [dbo].[SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ELTR]
--CREATE PROCEDURE [dbo].[SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ELTR]
CREATE PROCEDURE [dbo].[SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ELTR]  
	  @TBL_SCP_MST_CAPA_SPEED_PLAN   dbo.SCP_MST_CAPA_SPEED_PLAN_TYPE READONLY
	, @p_program_id				NVARCHAR(100)
	, @p_sheet_name				NVARCHAR(100)
	, @p_user_id				NVARCHAR(30)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_program_id		NVARCHAR(100)	    	= N'SCP0106';
	--DECLARE @p_sheet_name		NVARCHAR(100)	    	= N'CURRENT';
 --   DECLARE @p_user_id			NVARCHAR(30)	    	= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)		    	= N'F';



	--DECLARE @TBL_SCP_MST_CAPA_SPEED_PLAN   dbo.SCP_MST_CAPA_SPEED_PLAN_TYPE;

 --   INSERT INTO @TBL_SCP_MST_CAPA_SPEED_PLAN
 --   SELECT	  '202412'		AS VER_ID
	--		, 1				AS VER_SEQ
	--        , DIVISION_ID
	--        , COMPANY_ID
	--        , SITE_ID
	--        , PLANT_ID
	--        , FACTORY_ID
	--        , LINE_ID
	--        , OPERATION_ID
	--        , ELTR_LN_TP_CD
	--        , ITEM_ID
	--        , NICK_NAME
	--        , MSR_TP_CD
	--        , YYYYMM
	--        , BASE_QTY
	--        , QTY
	--        , UI_UPD_YN
	--        , REMARK
	--        , CREATED_BY
	--        , CREATION_DATE
	--        , LAST_UPDATED_BY
	--        , LAST_UPDATE_DATE
 --   FROM	SCP_MST_CAPA_ELTR_SPEED_PLAN WITH(NOLOCK)
 --   WHERE   1=1
 --       AND DIVISION_ID     = '81'
 --       --AND SITE_ID         = 'A004'
 --       --AND COMPANY_ID      = 'G480'
 --       --AND PLANT_ID        = 'G482'
 --       --AND FACTORY_ID      = 'ED'
 --       AND LINE_ID         = 'FP_EJM10_C'
 --       --AND ITEM_ID         = 'APCAN2383A'
 --       --AND YYYYMM          = '2029'


------TESTING : NOK
----select * from @TBL_SCP_MST_CAPA_SPEED_PLAN;return;


 	DECLARE @test_mode                          NVARCHAR(20)		= N'F';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER			= 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;


	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type						= 'START';
		SET @v_log_message					= '########## Start of procedure ##########';
		SET @v_description					= '';
		SET @d_event_date					= SYSDATETIME();

        IF @test_mode <> 'T'
        BEGIN
		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END


	    DECLARE @p_version			NVARCHAR(30)        = '';
        DECLARE @p_version_seq		TINYINT             = 0;

        SELECT    @p_version        = MAX(VER_ID)
                , @p_version_seq    = MAX(VER_SEQ)
        FROM    @TBL_SCP_MST_CAPA_SPEED_PLAN;

		IF OBJECT_ID('tempdb..#tbl_DAY_CNT_BASE') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT_BASE;

		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SOP_YM			        AS YYYYMM
				, SOP_DDN			        AS DAY_CNT
                , SOP_DDN			        AS DAY_CNT_YEAR
                , SUBSTRING(SOP_YM, 1, 4)   AS YYYY
        INTO    #tbl_DAY_CNT_BASE
		FROM    SCP_MST_CAPA_ELTR_LINE_SOP WITH(NOLOCK)
		WHERE   1<>1

        INSERT INTO #tbl_DAY_CNT_BASE
		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SOP_YM			AS YYYYMM
				, SOP_DDN			AS DAY_CNT
                , CASE
                    WHEN ISNULL(SOP_DT, '') = '' THEN 0--(DATEDIFF(DAY, CAST(SOP_YM AS VARCHAR) + '0101', CAST(SOP_YM AS VARCHAR) + '1231')) + 1
                    ELSE ((DATEDIFF(DAY, SOP_DT, SUBSTRING(SOP_YM, 1, 4) + '1231')) + 1)
                  END                       AS DAY_CNT_YEAR
                , SUBSTRING(SOP_YM, 1, 4)   AS YYYY
		FROM    SCP_MST_CAPA_ELTR_LINE_SOP WITH(NOLOCK)
		WHERE   1=1
			AND VALID_YN        = 'Y'

--TESTING : NOK
--select * from #tbl_DAY_CNT_BASE where YYYYMM = @p_version;rollback tran;return;

        BEGIN --Speed Plan Raw ########################################################################################################################################################################################
		    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_RAW') IS NOT NULL
			    DROP TABLE #tblSCP0106_SPEED_PLAN_RAW;

		    --빈테이블 생성
            SELECT	  A.VER_ID
			        , A.VER_SEQ
	                , A.DIVISION_ID
	                , A.COMPANY_ID
	                , A.SITE_ID
	                , A.PLANT_ID
	                , A.FACTORY_ID
	                , A.LINE_ID
	                , A.OPERATION_ID
	                , A.ELTR_LN_TP_CD
	                , A.ITEM_ID
	                , A.NICK_NAME
	                , A.MSR_TP_CD
	                , A.YYYYMM
	                , A.BASE_QTY
	                , A.QTY
	                , A.UI_UPD_YN
	                , A.REMARK
	                , A.CREATED_BY
	                , A.CREATION_DATE
	                , A.LAST_UPDATED_BY
	                , A.LAST_UPDATE_DATE
                    , DAY(EOMONTH(CONVERT(DATETIME, A.VER_ID + '01', 112))) - DAY(CONVERT(DATETIME, A.VER_ID + '01', 112)) + 1  AS BASE_DAY_CNT
			        , A.DAY_CNT
            INTO    #tblSCP0106_SPEED_PLAN_RAW
            FROM	SCP_MST_CAPA_ELTR_SPEED_PLAN_V A
			        LEFT JOIN #tbl_DAY_CNT_BASE DC ON
					        A.DIVISION_ID		= DC.DIVISION_ID
				        AND A.COMPANY_ID		= DC.COMPANY_ID
				        AND A.SITE_ID			= DC.SITE_ID
				        AND A.PLANT_ID			= DC.PLANT_ID
				        AND A.FACTORY_ID		= DC.FACTORY_ID
				        AND A.LINE_ID			= DC.LINE_ID
				        AND A.OPERATION_ID		= DC.OPERATION_ID
				        ------AND A.ELTR_LN_TP_CD		= DC.ELTR_LN_TP_CD
				        AND A.VER_ID			= DC.YYYYMM
            WHERE   1<>1

            INSERT INTO #tblSCP0106_SPEED_PLAN_RAW
            SELECT	  A.VER_ID
			        , A.VER_SEQ
	                , A.DIVISION_ID
	                , A.COMPANY_ID
	                , A.SITE_ID
	                , A.PLANT_ID
	                , A.FACTORY_ID
	                , A.LINE_ID
	                , A.OPERATION_ID
	                , A.ELTR_LN_TP_CD
	                , A.ITEM_ID
	                , A.NICK_NAME
	                , A.MSR_TP_CD
	                , A.YYYYMM
	                , A.BASE_QTY
	                , A.QTY
	                , A.UI_UPD_YN
	                , A.REMARK
	                , A.CREATED_BY
	                , A.CREATION_DATE
	                , A.LAST_UPDATED_BY
	                , A.LAST_UPDATE_DATE
                    , DAY(EOMONTH(CONVERT(DATETIME, A.VER_ID + '01', 112))) - DAY(CONVERT(DATETIME, A.VER_ID + '01', 112)) + 1  AS BASE_DAY_CNT
			        , A.DAY_CNT
            FROM	SCP_MST_CAPA_ELTR_SPEED_PLAN_V A
			        LEFT JOIN #tbl_DAY_CNT_BASE DC ON
					        A.DIVISION_ID		= DC.DIVISION_ID
				        AND A.COMPANY_ID		= DC.COMPANY_ID
				        AND A.SITE_ID			= DC.SITE_ID
				        AND A.PLANT_ID			= DC.PLANT_ID
				        AND A.FACTORY_ID		= DC.FACTORY_ID
				        AND A.LINE_ID			= DC.LINE_ID
				        AND A.OPERATION_ID		= DC.OPERATION_ID
				        ------AND A.ELTR_LN_TP_CD		= DC.ELTR_LN_TP_CD
				        AND A.VER_ID			= DC.YYYYMM

           -- BEGIN -- 변경된 모델만 재계산해야되는데 다른 모델들 데이터 삭제되서 테스트중!!!!! ######################################################
           -- --전극은 라인별 RAW 데이터 모두 필요하므로 MODEL별로 변경된 데이터만 파라미터로 넘어온 소스를 라인 기준으로 확장할 필요가 있음
           -- INSERT INTO #tblSCP0106_SPEED_PLAN_RAW
           -- SELECT	  B.VER_ID
			        --, B.VER_SEQ
	          --      , A.DIVISION_ID
	          --      , A.COMPANY_ID
	          --      , A.SITE_ID
	          --      , A.PLANT_ID
	          --      , A.FACTORY_ID
	          --      , A.LINE_ID
	          --      , A.OPERATION_ID
	          --      , A.ELTR_LN_TP_CD
	          --      , A.ITEM_ID
	          --      , A.NICK_NAME
	          --      , A.MSR_TP_CD
	          --      , A.YYYYMM
	          --      , A.BASE_QTY
	          --      , A.QTY
	          --      , A.UI_UPD_YN
	          --      , A.REMARK
	          --      , A.CREATED_BY
	          --      , A.CREATION_DATE
	          --      , A.LAST_UPDATED_BY
	          --      , A.LAST_UPDATE_DATE
           --         , C.DAY_CNT             AS BASE_DAY_CNT
           --         , D.DAY_CNT             AS DAY_CNT
           -- FROM	SCP_MST_CAPA_ELTR_SPEED_PLAN A
           --         INNER JOIN (
           --                         SELECT DISTINCT
	          --                                A.VER_ID 
	          --                              , A.VER_SEQ 
	          --                              , A.DIVISION_ID 
	          --                              , A.COMPANY_ID  
	          --                              , A.SITE_ID     
	          --                              , A.PLANT_ID    
	          --                              , A.FACTORY_ID  
	          --                              , A.LINE_ID     
	          --                              , A.OPERATION_ID
	          --                              , A.MSR_TP_CD   
	          --                              , A.YYYYMM      
           --                         FROM    @TBL_SCP_MST_CAPA_SPEED_PLAN A
           --                    ) B ON
	          --              A.DIVISION_ID   = B.DIVISION_ID
	          --          AND A.COMPANY_ID    = B.COMPANY_ID
	          --          AND A.SITE_ID       = B.SITE_ID
	          --          AND A.PLANT_ID      = B.PLANT_ID
	          --          AND A.FACTORY_ID    = B.FACTORY_ID
	          --          AND A.LINE_ID       = B.LINE_ID
	          --          AND A.OPERATION_ID  = B.OPERATION_ID
	          --          AND A.MSR_TP_CD     = B.MSR_TP_CD
	          --          AND A.YYYYMM        = B.YYYYMM
           --         LEFT JOIN #tblSCP0106_DAY_CNT C ON
           --                 B.VER_ID = C.YYYYMM
           --         LEFT JOIN #tblSCP0106_DAY_CNT D ON
           --                 A.YYYYMM = D.YYYYMM
           -- END -- 변경된 모델만 재계산해야되는데 다른 모델들 데이터 삭제되서 테스트중!!!!! ######################################################
                         

--TESTING : NOK
--select * from #tblSCP0106_DAY_CNT;
--select * from #tblSCP0106_SPEED_PLAN_RAW ;rollback tran;return;
        END --Speed Plan Raw ########################################################################################################################################################################################




        BEGIN --Speed Plan Keys ########################################################################################################################################################################################
		    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_KEYS') IS NOT NULL
			    DROP TABLE #tblSCP0106_SPEED_PLAN_KEYS;

		    --빈테이블 생성
		    SELECT	  A.DIVISION_ID
				    , A.ITEM_ID       AS MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
		    INTO    #tblSCP0106_SPEED_PLAN_KEYS
		    FROM    #tblSCP0106_SPEED_PLAN_RAW A
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_SPEED_PLAN_KEYS
		    SELECT	  A.DIVISION_ID
				    , A.ITEM_ID       AS MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
		    FROM    #tblSCP0106_SPEED_PLAN_RAW A
		    GROUP BY  A.DIVISION_ID
				    , A.ITEM_ID
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID;

--TESTING : NOK
--select * from #tblSCP0106_SPEED_PLAN_KEYS;rollback tran;return;
        END --Speed Plan Keys ########################################################################################################################################################################################



	    BEGIN --rawdata - ########################################################################################################################################################################################
	        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE') IS NOT NULL
		        DROP TABLE #tblSCP0106_RAW_BASE;
    
	        SELECT	  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.MSR_GR_CD
                    , A.MSR_TP_CD               AS LOSS_CD
                    --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                    , A.YYYYMM
                    , A.PFRSLT_NVL
                    , A.BASE_NVL
                    --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                    , A.MSR_NVL                 AS LOSS_RT
            INTO    #tblSCP0106_RAW_BASE
	        FROM	SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
            WHERE   1<>1

            INSERT INTO #tblSCP0106_RAW_BASE
	        SELECT	  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.MSR_GR_CD               AS LOSS_CD
                    , A.MSR_TP_CD
                    --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                    , A.YYYYMM
                    , A.PFRSLT_NVL
                    , A.BASE_NVL
                    --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                    , A.MSR_NVL                 AS LOSS_RT
	        FROM	SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
                    INNER JOIN #tblSCP0106_SPEED_PLAN_KEYS B ON
                            A.DIVISION_ID        = B.DIVISION_ID      
                        AND A.COMPANY_ID         = B.COMPANY_ID
                        AND A.SITE_ID            = B.SITE_ID
                        AND A.PLANT_ID           = B.PLANT_ID
                        AND A.FACTORY_ID         = B.FACTORY_ID
                        AND A.LINE_ID            = B.LINE_ID
                        AND A.OPERATION_ID       = B.OPERATION_ID

--TESTING : NOK
--select * from #tblSCP0106_RAW_BASE;rollback tran;return;
--select * from SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL where YYYYMM = '202409';
--select * from #tblSCP0106_SPEED_PLAN_KEYS;
--select * from #tblSCP0106_RAW_BASE where YYYYMM = '202409' AND LOSS_CD = 'THRY_CAPA_D';rollback tran;return;



	        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN') IS NOT NULL
		        DROP TABLE #tblSCP0106_RAW_OPPLAN;
    
	        SELECT	  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.MSR_GR_CD
                    , A.LOSS_CD
                    --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                    , A.YYYYMM
                    , A.PFRSLT_NVL
                    , A.BASE_NVL
                    --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                    , A.LOSS_RT
            INTO    #tblSCP0106_RAW_OPPLAN
	        FROM	#tblSCP0106_RAW_BASE A
            WHERE   1<>1

            INSERT INTO #tblSCP0106_RAW_OPPLAN
	        SELECT	  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.MSR_GR_CD
                    , A.LOSS_CD
                    --, A.IPRV_GOL_DIVS_CD	
                    , A.YYYYMM
                    , A.PFRSLT_NVL
                    , A.BASE_NVL
           --         , A.IPRV_GOL_RT
			        --, IIF(A.IPRV_GOL_DIVS_CD = 'G', 0.0, A.LOSS_RT)     AS LOSS_RT
					, A.LOSS_RT	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
	        FROM	#tblSCP0106_RAW_BASE A
--TESTING : NOK
--select * from #tblSCP0106_RAW_BASE;
--select * from #tblSCP0106_RAW_OPPLAN WHERE YYYYMM = '202409' AND LOSS_CD = 'THRY_CAPA_D';rollback tran;return;
	    END--rawdata - ########################################################################################################################################################################################



        BEGIN --Loss Plan Keys ########################################################################################################################################################################################
            --Measure 를 포함한 키값들 => Raw 재구성후 Loss Plan 조인시 필요
		    IF OBJECT_ID('tempdb..#tblSCP0106_LOSS_PLAN_KEYS') IS NOT NULL
			    DROP TABLE #tblSCP0106_LOSS_PLAN_KEYS;

		    --빈테이블 생성
	        SELECT	  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.MSR_GR_CD
                    , A.LOSS_CD
                    , A.YYYYMM
		    INTO    #tblSCP0106_LOSS_PLAN_KEYS
		    FROM    #tblSCP0106_RAW_BASE A
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_LOSS_PLAN_KEYS
	        SELECT	  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.MSR_GR_CD
                    , A.LOSS_CD
                    , A.YYYYMM
		    FROM    #tblSCP0106_RAW_BASE A
		    GROUP BY  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.MSR_GR_CD
                    , A.LOSS_CD
                    , A.YYYYMM

            --Measure 를 배제한 키값들 => Raw 재구성시 필요
		    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_KEYS') IS NOT NULL
			    DROP TABLE #tblSCP0106_RAW_KEYS;

		    --빈테이블 생성
	        SELECT	  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.YYYYMM
		    INTO    #tblSCP0106_RAW_KEYS
		    FROM    #tblSCP0106_LOSS_PLAN_KEYS A
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RAW_KEYS
	        SELECT	  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.YYYYMM
		    FROM    #tblSCP0106_LOSS_PLAN_KEYS A
		    GROUP BY  A.DIVISION_ID
                    , A.SITE_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.MDL_NM
                    , A.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_RAW_BASE WHERE YYYYMM = '202409';
--select * from #tblSCP0106_RAW_KEYS WHERE YYYYMM = '202409';rollback tran;return;
        END --Loss Plan Keys ########################################################################################################################################################################################


	    BEGIN --Base용 ########################################################################################################################################################################################
		    PRINT N'계산용 서브쿼리 - BEGIN';
            BEGIN
		        --나머지는 모두 라인별 ----------------------------------------------------------------------
		        --PROD_OP
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PROD_OP_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_PROD_OP_RT;

		        SELECT    DIVISION_ID
                        , SITE_ID
                        , COMPANY_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , MDL_NM
                        , MSR_GR_CD
                        , LOSS_CD
                        , YYYYMM
                        , PFRSLT_NVL
                        , BASE_NVL
                        --, IPRV_GOL_RT	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                        , LOSS_RT
		        INTO    #tblSCP0106_RAW_BASE_LN_PROD_OP_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_PROD_OP_RT
		        SELECT    DIVISION_ID
                        , SITE_ID
                        , COMPANY_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , MDL_NM
                        , MSR_GR_CD
                        , LOSS_CD
                        , YYYYMM
                        , MAX(PFRSLT_NVL)	AS PFRSLT_NVL
                        , MAX(BASE_NVL)	    AS BASE_NVL
                        --, MAX(IPRV_GOL_RT)	AS IPRV_GOL_RT	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                        , MAX(LOSS_RT)	    AS LOSS_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'PROD_OP_RT'
                GROUP BY  DIVISION_ID
                        , SITE_ID
                        , COMPANY_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , MDL_NM
                        , MSR_GR_CD
                        , LOSS_CD
                        , YYYYMM
            END
            PRINT N'계산용 서브쿼리 - END';

--TESTING : NOK
--select * from #tblSCP0106_RAW_KEYS;--rollback tran;return;
--select * from #tblSCP0106_RAW_BASE_LN_PROD_OP_RT WHERE YYYYMM = '202409';--rollback tran;return;

	        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_ALL') IS NOT NULL
		        DROP TABLE #tblSCP0106_RAW_BASE_ALL;

            --빈테이블 생성
	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM
			        , CONVERT(FLOAT, NULL)                  AS AV_RT
			        , CONVERT(FLOAT, NULL)				    AS PROD_OP_RT
            INTO    #tblSCP0106_RAW_BASE_ALL
            FROM    #tblSCP0106_RAW_KEYS A
            WHERE   1<>1;

            INSERT INTO #tblSCP0106_RAW_BASE_ALL
	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM

			        , CONVERT(FLOAT, 1.0)                 AS AV_RT--Current 조업율 100
			        , CONVERT(FLOAT, PROD_OP_RT.LOSS_RT)  AS PROD_OP_RT
            FROM    #tblSCP0106_RAW_KEYS A
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_PROD_OP_RT PROD_OP_RT ON --PROD_OP_RT
					            A.DIVISION_ID			= PROD_OP_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PROD_OP_RT.COMPANY_ID
				            AND A.SITE_ID				= PROD_OP_RT.SITE_ID
				            AND A.PLANT_ID				= PROD_OP_RT.PLANT_ID
				            AND A.FACTORY_ID			= PROD_OP_RT.FACTORY_ID
				            AND A.LINE_ID				= PROD_OP_RT.LINE_ID
				            AND A.OPERATION_ID			= PROD_OP_RT.OPERATION_ID
				            ----AND A.MDL_NM				= PROD_OP_RT.MDL_NM
				            AND A.YYYYMM            	= PROD_OP_RT.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_RAW_KEYS WHERE YYYYMM = '202409';
--select * from #tblSCP0106_SPEED_PLAN_RAW;
--select * from #tblSCP0106_RAW_BASE_LN_PF_RT WHERE YYYYMM = '202409';
--select * from #tblSCP0106_RAW_BASE_ALL WHERE YYYYMM = '202409';rollback tran;return;


	        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_FINAL') IS NOT NULL
		        DROP TABLE #tblSCP0106_RAW_BASE_FINAL;

            --빈테이블 생성
	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM
			        , CONVERT(FLOAT, NULL)			AS THRY_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS PROD_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS PROD_CAPA_M

			        , CONVERT(FLOAT, NULL)			AS BASE_THRY_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_M

                    , CONVERT(FLOAT, NULL)			AS PPM
                    , CONVERT(FLOAT, NULL)			AS BASE_PPM

                    , CONVERT(FLOAT, NULL)			AS DAY_CNT
	        INTO	#tblSCP0106_RAW_BASE_FINAL
            FROM    #tblSCP0106_RAW_KEYS A
	        WHERE	1<>1;

	        INSERT INTO #tblSCP0106_RAW_BASE_FINAL
	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM

			        , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.QTY * 1440.0))														AS THRY_CAPA_D
                    , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.QTY * 1440.0)      * (B.PROD_OP_RT))						            AS PROD_CAPA_D
                    ------, CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.QTY * 1440.0)      * (B.PROD_OP_RT) * (S.DAY_CNT * B.AV_RT))	        AS PROD_CAPA_M
                    , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.QTY * 1440.0)      * (B.PROD_OP_RT) * (S.DAY_CNT))	        AS PROD_CAPA_M

			        , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_QTY * 1440.0))														                        AS BASE_THRY_CAPA_D
                    , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_QTY * 1440.0) * (B.PROD_OP_RT))						            AS BASE_PROD_CAPA_D
                    ------, CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_QTY * 1440.0) * (B.PROD_OP_RT) * (S.BASE_DAY_CNT * B.AV_RT))	    AS BASE_PROD_CAPA_M
                    , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_QTY * 1440.0) * (B.PROD_OP_RT) * (S.BASE_DAY_CNT))	    AS BASE_PROD_CAPA_M

                    , S.QTY
                    , S.BASE_QTY

                    , S.DAY_CNT
            FROM    #tblSCP0106_RAW_KEYS A
                    LEFT JOIN #tblSCP0106_RAW_BASE_ALL B ON
					        A.DIVISION_ID			= B.DIVISION_ID
				        AND A.COMPANY_ID			= B.COMPANY_ID
				        AND A.SITE_ID				= B.SITE_ID
				        AND A.PLANT_ID				= B.PLANT_ID
				        AND A.FACTORY_ID			= B.FACTORY_ID
				        AND A.LINE_ID				= B.LINE_ID
				        AND A.OPERATION_ID			= B.OPERATION_ID
				        --AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
				        AND A.MDL_NM				= B.MDL_NM
                        AND A.YYYYMM                = B.YYYYMM
                    ----LEFT JOIN #tblSCP0106_SPEED_PLAN_RAW S ON
                    INNER JOIN #tblSCP0106_SPEED_PLAN_RAW S ON
                            A.DIVISION_ID			= S.DIVISION_ID
				        AND A.COMPANY_ID			= S.COMPANY_ID
				        AND A.SITE_ID				= S.SITE_ID
				        AND A.PLANT_ID				= S.PLANT_ID
				        AND A.FACTORY_ID			= S.FACTORY_ID
				        AND A.LINE_ID				= S.LINE_ID
				        AND A.OPERATION_ID			= S.OPERATION_ID
				        --AND A.ELTR_LN_TP_CD			= S.ELTR_LN_TP_CD
				        AND A.MDL_NM				= S.ITEM_ID
                        AND A.YYYYMM                = S.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_RAW_KEYS WHERE YYYYMM = '202409';
--select * from #tblSCP0106_RAW_BASE_ALL WHERE YYYYMM = '202409';
--select * from #tblSCP0106_SPEED_PLAN_RAW WHERE YYYYMM = '202409';
--select * from #tblSCP0106_RAW_BASE_FINAL WHERE YYYYMM = '202409';rollback tran;return;
	    END --Base용 ########################################################################################################################################################################################


	    BEGIN --운영계획용 ########################################################################################################################################################################################
		    PRINT N'계산용 서브쿼리 - BEGIN';
            BEGIN
		        --나머지는 모두 라인별 ----------------------------------------------------------------------
		        --PROD_OP
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT;

		        SELECT    DIVISION_ID
                        , SITE_ID
                        , COMPANY_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , MDL_NM
                        , MSR_GR_CD
                        , LOSS_CD
                        , YYYYMM
                        , PFRSLT_NVL
                        , BASE_NVL
                        --, IPRV_GOL_RT	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                        , LOSS_RT
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT
		        SELECT    DIVISION_ID
                        , SITE_ID
                        , COMPANY_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , MDL_NM
                        , MSR_GR_CD
                        , LOSS_CD
                        , YYYYMM
                        , MAX(PFRSLT_NVL)	AS PFRSLT_NVL
                        , MAX(BASE_NVL)	    AS BASE_NVL
                        --, MAX(IPRV_GOL_RT)	AS IPRV_GOL_RT	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                        , MAX(LOSS_RT)	    AS LOSS_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'PROD_OP_RT'
                GROUP BY  DIVISION_ID
                        , SITE_ID
                        , COMPANY_ID
                        , PLANT_ID
                        , FACTORY_ID
                        , LINE_ID
                        , OPERATION_ID
                        , ELTR_LN_TP_CD
                        , MDL_NM
                        , MSR_GR_CD
                        , LOSS_CD
                        , YYYYMM
            END
            PRINT N'계산용 서브쿼리 - END';



	        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_ALL') IS NOT NULL
		        DROP TABLE #tblSCP0106_RAW_OPPLAN_ALL;

            --빈테이블 생성
	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM
			        , CONVERT(FLOAT, NULL)                AS AV_RT
			        , CONVERT(FLOAT, NULL)                AS PROD_OP_RT
            INTO    #tblSCP0106_RAW_OPPLAN_ALL
            FROM    #tblSCP0106_RAW_KEYS A
            WHERE   1<>1;

            INSERT INTO #tblSCP0106_RAW_OPPLAN_ALL
	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM

			        , CONVERT(FLOAT, 1.0)                 AS AV_RT--Current 조업율 100
			        , CONVERT(FLOAT, PROD_OP_RT.LOSS_RT)  AS PROD_OP_RT
            FROM    #tblSCP0106_RAW_KEYS A
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT PROD_OP_RT ON --PROD_OP_RT
					            A.DIVISION_ID			= PROD_OP_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PROD_OP_RT.COMPANY_ID
				            AND A.SITE_ID				= PROD_OP_RT.SITE_ID
				            AND A.PLANT_ID				= PROD_OP_RT.PLANT_ID
				            AND A.FACTORY_ID			= PROD_OP_RT.FACTORY_ID
				            AND A.LINE_ID				= PROD_OP_RT.LINE_ID
				            AND A.OPERATION_ID			= PROD_OP_RT.OPERATION_ID
				            ----AND A.MDL_NM				= PROD_OP_RT.MDL_NM
				            AND A.YYYYMM			    = PROD_OP_RT.YYYYMM

--TESTING - NOK
--select * from #tblSCP0106_RAW_OPPLAN_ALL WHERE YYYYMM = '202409';rollback tran;return;


	        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_FINAL') IS NOT NULL
		        DROP TABLE #tblSCP0106_RAW_OPPLAN_FINAL;

            --빈테이블 생성
	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM

			        , CONVERT(FLOAT, NULL)			AS THRY_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS PROD_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS PROD_CAPA_M

			        , CONVERT(FLOAT, NULL)			AS BASE_THRY_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_M

                    , CONVERT(FLOAT, NULL)			AS PPM
                    , CONVERT(FLOAT, NULL)			AS BASE_PPM
	        INTO	#tblSCP0106_RAW_OPPLAN_FINAL
            FROM    #tblSCP0106_RAW_KEYS A
	        WHERE	1<>1;

	        INSERT INTO #tblSCP0106_RAW_OPPLAN_FINAL
	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM

			        , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.QTY * 1440.0))														AS THRY_CAPA_D
                    , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.QTY * 1440.0)      * (B.PROD_OP_RT))						            AS PROD_CAPA_D
                    ------, CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.QTY * 1440.0)      * (B.PROD_OP_RT) * (S.DAY_CNT * B.AV_RT))	        AS PROD_CAPA_M
                    , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.QTY * 1440.0)      * (B.PROD_OP_RT) * (S.DAY_CNT))	        AS PROD_CAPA_M

			        , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_QTY * 1440.0))														                        AS BASE_THRY_CAPA_D
                    , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_QTY * 1440.0) * (B.PROD_OP_RT))						            AS BASE_PROD_CAPA_D
                    ------, CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_QTY * 1440.0) * (B.PROD_OP_RT) * (S.BASE_DAY_CNT * B.AV_RT))	    AS BASE_PROD_CAPA_M
                    , CONVERT(FLOAT, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_QTY * 1440.0) * (B.PROD_OP_RT) * (S.BASE_DAY_CNT))	    AS BASE_PROD_CAPA_M

                    ,S.QTY
                    ,S.BASE_QTY
            FROM    #tblSCP0106_RAW_KEYS A
                    LEFT JOIN #tblSCP0106_RAW_OPPLAN_ALL B ON
					        A.DIVISION_ID			= B.DIVISION_ID
				        AND A.COMPANY_ID			= B.COMPANY_ID
				        AND A.SITE_ID				= B.SITE_ID
				        AND A.PLANT_ID				= B.PLANT_ID
				        AND A.FACTORY_ID			= B.FACTORY_ID
				        AND A.LINE_ID				= B.LINE_ID
				        AND A.OPERATION_ID			= B.OPERATION_ID
						AND A.MDL_NM				= B.MDL_NM
				        AND A.YYYYMM				= B.YYYYMM
                    INNER JOIN #tblSCP0106_SPEED_PLAN_RAW S ON
                            A.DIVISION_ID			= S.DIVISION_ID
				        AND A.COMPANY_ID			= S.COMPANY_ID
				        AND A.SITE_ID				= S.SITE_ID
				        AND A.PLANT_ID				= S.PLANT_ID
				        AND A.FACTORY_ID			= S.FACTORY_ID
				        AND A.LINE_ID				= S.LINE_ID
				        AND A.OPERATION_ID			= S.OPERATION_ID
				        AND A.MDL_NM				= S.ITEM_ID
				        AND A.YYYYMM				= S.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_RAW_OPPLAN_FINAL;rollback tran;return;
--select * from #tblSCP0106_RAW_OPPLAN_FINAL WHERE YYYYMM = '202409';rollback tran;return;
	    END --운영계획용 ########################################################################################################################################################################################


	    BEGIN --최종 ########################################################################################################################################################################################
            PRINT N'GET - RAW - BEGIN';
    	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_FINAL_TEMP') IS NOT NULL
			    DROP TABLE #tblSCP0106_RAW_FINAL_TEMP;

            --빈테이블 생성
            SELECT    A.VER_ID
				    , A.VER_SEQ
				    , A.DIVISION_ID
				    , A.MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
				    , A.MSR_TP_CD
				    , A.YYYYMM
				    ----실적은 수정 안함, A.PFRSLT_NVL
				    , A.BASE_NVL
				    --, A.IPRV_GOL_DIVS_CD
				    --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				    , A.MSR_GR_CD
				    , A.MSR_NVL
				    ----, A.MSR_DDN
            INTO    #tblSCP0106_RAW_FINAL_TEMP
            FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF A WITH(NOLOCK)
            WHERE   1<>1;

            INSERT INTO #tblSCP0106_RAW_FINAL_TEMP
            SELECT    @p_version		AS VER_ID   
				    , @p_version_seq    AS VER_SEQ
				    , A.DIVISION_ID
				    , A.MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
				    , A.LOSS_CD
				    , A.YYYYMM
                    , CASE
                        WHEN A.LOSS_CD = 'THRY_CAPA_D'	        THEN B.BASE_THRY_CAPA_D
                        WHEN A.LOSS_CD = 'PROD_CAPA_D'		    THEN B.BASE_PROD_CAPA_D
                        WHEN A.LOSS_CD = 'PROD_CAPA_M'		    THEN B.BASE_PROD_CAPA_M
                        ELSE
                            CONVERT(FLOAT, NULL)
                      END AS BASE_NVL
				    --, A.IPRV_GOL_DIVS_CD
				    --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				    , A.MSR_GR_CD
                    , CASE
                        WHEN A.LOSS_CD = 'THRY_CAPA_D'	        THEN O.THRY_CAPA_D
                        WHEN A.LOSS_CD = 'PROD_CAPA_D'		    THEN O.PROD_CAPA_D
                        WHEN A.LOSS_CD = 'PROD_CAPA_M'		    THEN O.PROD_CAPA_M
                        ELSE
                            CONVERT(FLOAT, NULL)
                      END  AS MSR_NVL
            FROM    (
                        SELECT  A.*
                        FROM    #tblSCP0106_RAW_BASE A
                        WHERE   1=1
                            AND A.LOSS_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')
                            AND A.MDL_NM <> '-'
                    ) A
                    -- INNER JOIN 해야 수정된 데이터로만 제한
                    INNER JOIN #tblSCP0106_RAW_BASE_FINAL B ON --Base용
                            A.DIVISION_ID			= B.DIVISION_ID
                        AND A.COMPANY_ID			= B.COMPANY_ID
                        AND A.SITE_ID				= B.SITE_ID
                        AND A.PLANT_ID				= B.PLANT_ID
                        AND A.FACTORY_ID			= B.FACTORY_ID
                        AND A.LINE_ID				= B.LINE_ID
                        AND A.OPERATION_ID			= B.OPERATION_ID
                        AND A.MDL_NM				= B.MDL_NM
                        AND A.YYYYMM				= B.YYYYMM
                    -- INNER JOIN 해야 수정된 데이터로만 제한
                    INNER JOIN #tblSCP0106_RAW_OPPLAN_FINAL O ON --운영계획용
                            A.DIVISION_ID			= O.DIVISION_ID
                        AND A.COMPANY_ID			= O.COMPANY_ID
                        AND A.SITE_ID				= O.SITE_ID
                        AND A.PLANT_ID				= O.PLANT_ID
                        AND A.FACTORY_ID			= O.FACTORY_ID
                        AND A.LINE_ID				= O.LINE_ID
                        AND A.OPERATION_ID			= O.OPERATION_ID
                        AND A.MDL_NM				= O.MDL_NM
                        AND A.YYYYMM				= O.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_SPEED_PLAN_KEYS;rollback tran;return;
--select * from #tblSCP0106_RAW_BASE WHERE YYYYMM = '202409';
--select * from #tblSCP0106_RAW_BASE_FINAL WHERE YYYYMM = '202409';
--select * from #tblSCP0106_RAW_OPPLAN_FINAL WHERE YYYYMM = '202409';
--select * from #tblSCP0106_RAW_FINAL_TEMP WHERE YYYYMM = '202409';rollback tran;return;


    	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_FINAL') IS NOT NULL
			    DROP TABLE #tblSCP0106_RAW_FINAL;

            --빈테이블 생성
            SELECT    A.VER_ID
				    , A.VER_SEQ
				    , A.DIVISION_ID
				    , A.MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
				    , A.MSR_TP_CD
				    , A.YYYYMM
				    ----실적은 수정 안함, A.PFRSLT_NVL
				    , A.BASE_NVL
				    --, A.IPRV_GOL_DIVS_CD
				    --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				    , A.MSR_GR_CD
				    , A.MSR_NVL
				    ----, A.MSR_DDN
            INTO    #tblSCP0106_RAW_FINAL
            FROM    #tblSCP0106_RAW_FINAL_TEMP A
            WHERE   1<>1;

            INSERT INTO #tblSCP0106_RAW_FINAL
            SELECT    A.VER_ID
				    , A.VER_SEQ
				    , A.DIVISION_ID
				    , A.MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
				    , A.MSR_TP_CD
				    , A.YYYYMM
				    ----실적은 수정 안함, A.PFRSLT_NVL
				    , MAX(A.BASE_NVL)
				    --, MAX(A.IPRV_GOL_DIVS_CD)
				    --, MAX(A.IPRV_GOL_RT)		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				    , MAX(A.MSR_GR_CD)
				    , MAX(A.MSR_NVL)
				    ----, A.MSR_DDN
            FROM    #tblSCP0106_RAW_FINAL_TEMP A
            GROUP BY  A.VER_ID
				    , A.VER_SEQ
				    , A.DIVISION_ID
				    , A.MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
				    , A.MSR_TP_CD
				    , A.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_RAW_FINAL;--rollback tran;return;
--select * from #tblSCP0106_RAW_FINAL WHERE YYYYMM = '2029';rollback tran;return;
        
            --BASE 변경되면 전체 구간의 BASE 재계산해야 하므로 FINAL 과 FINAL_BASE RAW 데이터 따로 구성
    	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_FINAL_BASE') IS NOT NULL
			    DROP TABLE #tblSCP0106_RAW_FINAL_BASE;

            --빈테이블 생성
            SELECT    A.VER_ID
				    , A.VER_SEQ
				    , A.DIVISION_ID
				    , A.MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
				    , A.MSR_TP_CD
				    , A.BASE_NVL
				    , A.MSR_GR_CD
            INTO    #tblSCP0106_RAW_FINAL_BASE
            FROM    .#tblSCP0106_RAW_FINAL A
            WHERE   1<>1;

            INSERT INTO #tblSCP0106_RAW_FINAL_BASE
            SELECT    A.VER_ID
				    , A.VER_SEQ
				    , A.DIVISION_ID
				    , A.MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
				    , A.MSR_TP_CD
				    , MAX(A.BASE_NVL)       AS BASE_NVL
				    , A.MSR_GR_CD
            FROM    .#tblSCP0106_RAW_FINAL A
            GROUP BY  A.VER_ID
				    , A.VER_SEQ
				    , A.DIVISION_ID
				    , A.MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
				    , A.MSR_TP_CD
				    , A.MSR_GR_CD

--TESTING : NOK
--select * from #tblSCP0106_RAW_FINAL WHERE YYYYMM = '2029';
--select * from #tblSCP0106_RAW_FINAL_BASE;rollback tran;return;

            
            -- 변경된 데이터만 수정되어야 하나 UI 구조상 키에 대한 전체 기간 데이터가 모두넘어 오므로 수정되지 않은 데이터들은 제외한다
            -- MERGE 에서 변경값들을 체크하면 추가가 되므로 여기서 체크할 것!!!

            BEGIN
                DELETE A
                FROM    #tblSCP0106_RAW_FINAL A
                        INNER JOIN SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL B ON
				                A.DIVISION_ID		    = B.DIVISION_ID
			                AND A.MDL_NM				= B.MDL_NM
			                AND A.PLANT_ID				= B.PLANT_ID
			                AND A.LINE_ID				= B.LINE_ID
			                AND A.OPERATION_ID			= B.OPERATION_ID
			                AND A.COMPANY_ID			= B.COMPANY_ID
			                AND A.SITE_ID				= B.SITE_ID
			                AND A.FACTORY_ID			= B.FACTORY_ID
			                AND A.MSR_TP_CD				= B.MSR_TP_CD
			                AND A.YYYYMM				= B.YYYYMM
			                AND A.MSR_GR_CD				= B.MSR_GR_CD
                WHERE   1=1
                    AND ((ISNULL(A.MSR_NVL, 0.0) = ISNULL(B.MSR_NVL, 0.0)) AND (ISNULL(A.ELTR_LN_TP_CD, '') = ISNULL(B.ELTR_LN_TP_CD, ''))) --운영계획, 전극타입 중 하나라도 변경되지 않았으면 제외

--TESTING : NOK
--select * from #tblSCP0106_RAW_FINAL;rollback tran;return;
--select * from #tblSCP0106_RAW_FINAL WHERE YYYYMM = '202409';

                DELETE A
                FROM    #tblSCP0106_RAW_FINAL_BASE A
                        INNER JOIN SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL B ON
				                A.DIVISION_ID		    = B.DIVISION_ID
			                AND A.MDL_NM				= B.MDL_NM
			                AND A.PLANT_ID				= B.PLANT_ID
			                AND A.LINE_ID				= B.LINE_ID
			                AND A.OPERATION_ID			= B.OPERATION_ID
			                AND A.COMPANY_ID			= B.COMPANY_ID
			                AND A.SITE_ID				= B.SITE_ID
			                AND A.FACTORY_ID			= B.FACTORY_ID
			                AND A.MSR_TP_CD				= B.MSR_TP_CD
			                AND A.MSR_GR_CD				= B.MSR_GR_CD
                WHERE   1=1
                    AND ((ISNULL(A.BASE_NVL, 0.0) = ISNULL(B.BASE_NVL, 0.0)) AND (ISNULL(A.ELTR_LN_TP_CD, '') = ISNULL(B.ELTR_LN_TP_CD, ''))) --BASE, 전극타입 중 하나라도 변경되지 않았으면 제외
            END

--TESTING : NOK
--select * from #tblSCP0106_RAW_FINAL;rollback tran;return;
--select * from #tblSCP0106_RAW_FINAL_BASE;rollback tran;return;

    	    END --최종 ########################################################################################################################################################################################

----TESTING : NOK
--SELECT  A.*
--FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--        JOIN #tblSCP0106_RAW_FINAL B ON
--				A.DIVISION_ID		    = B.DIVISION_ID
--			AND A.MDL_NM				= B.MDL_NM
--			AND A.PLANT_ID				= B.PLANT_ID
--			AND A.LINE_ID				= B.LINE_ID
--			AND A.OPERATION_ID			= B.OPERATION_ID
--			----AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
--			AND A.COMPANY_ID			= B.COMPANY_ID
--			AND A.SITE_ID				= B.SITE_ID
--			AND A.FACTORY_ID			= B.FACTORY_ID
--			AND A.MSR_GR_CD				= B.MSR_GR_CD
--			AND A.MSR_TP_CD				= B.MSR_TP_CD
--			AND A.YYYYMM				= B.YYYYMM
--WHERE   1=1
--    AND A.YYYYMM = '202409'
------rollback tran;return;

	    BEGIN --Update Loss Plan ########################################################################################################################################################################################
            PRINT N'INSERT - SCP_MST_CAPA_ELTR_LOSS_PLAN - 월별 운영계획 - BEGIN'
			    MERGE INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
			    USING
			    (
				    SELECT    DIVISION_ID
				            , MDL_NM
				            , PLANT_ID
				            , LINE_ID
				            , OPERATION_ID
				            , ELTR_LN_TP_CD
				            , COMPANY_ID
				            , SITE_ID
				            , FACTORY_ID
				            , MSR_TP_CD
				            , YYYYMM
				            ----, PFRSLT_NVL
				            , BASE_NVL
				            --, IPRV_GOL_DIVS_CD
				            --, IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				            , MSR_GR_CD
				            , MSR_NVL
                    FROM    #tblSCP0106_RAW_FINAL
                    WHERE   1=1
			    ) B ON
			    (
					    A.DIVISION_ID		    = B.DIVISION_ID
				    AND A.MDL_NM				= B.MDL_NM
				    AND A.PLANT_ID				= B.PLANT_ID
				    AND A.LINE_ID				= B.LINE_ID
				    AND A.OPERATION_ID			= B.OPERATION_ID
				    ----AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
				    AND A.COMPANY_ID			= B.COMPANY_ID
				    AND A.SITE_ID				= B.SITE_ID
				    AND A.FACTORY_ID			= B.FACTORY_ID
				    AND A.MSR_TP_CD				= B.MSR_TP_CD
				    AND A.YYYYMM				= B.YYYYMM
				    AND A.MSR_GR_CD				= B.MSR_GR_CD
			    )
			    WHEN MATCHED THEN
			    UPDATE
			    SET
				    ----  PFRSLT_NVL			= B.PFRSLT_NVL
				    ----  BASE_NVL				= B.BASE_NVL
                    ----, IPRV_GOL_RT			= B.IPRV_GOL_RT
                      MSR_NVL				= B.MSR_NVL
    --Current에 MS_DDN 없음						, MSR_DDN				= B.MSR_DDN
				    , ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
			        --, IPRV_GOL_DIVS_CD	    = B.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				    , LAST_UPDATED_BY		= CONCAT(@v_program_name, '-', @p_user_id)
				    , LAST_UPDATE_DATE		= SYSDATETIME()
                    ;
			    ----WHEN NOT MATCHED THEN
			    ----INSERT
			    ----(
				   ----   DIVISION_ID
				   ---- , MDL_NM
				   ---- , PLANT_ID
				   ---- , LINE_ID
				   ---- , OPERATION_ID
				   ---- , ELTR_LN_TP_CD
				   ---- , COMPANY_ID
				   ---- , SITE_ID
				   ---- , FACTORY_ID
				   ---- , MSR_TP_CD
				   ---- , YYYYMM
				   ---- --실적 수정 안함, PFRSLT_NVL
				   ---- , BASE_NVL
				   ---- , IPRV_GOL_DIVS_CD
				   ---- , IPRV_GOL_RT
				   ---- , MSR_GR_CD
				   ---- , MSR_NVL
       ----             --Current에 MS_DDN 없음 , MSR_DDN
				   ---- , CREATED_BY
				   ---- , CREATION_DATE
				   ---- , LAST_UPDATED_BY
				   ---- , LAST_UPDATE_DATE
			    ----)
			    ----VALUES
			    ----(
				   ----   B.DIVISION_ID
				   ---- , B.MDL_NM
				   ---- , B.PLANT_ID
				   ---- , B.LINE_ID
				   ---- , B.OPERATION_ID
				   ---- , B.ELTR_LN_TP_CD
				   ---- , B.COMPANY_ID
				   ---- , B.SITE_ID
				   ---- , B.FACTORY_ID
				   ---- , B.MSR_TP_CD
				   ---- , B.YYYYMM
				   ---- ----, B.PFRSLT_NVL
				   ---- , B.BASE_NVL
				   ---- , B.IPRV_GOL_DIVS_CD
				   ---- , B.IPRV_GOL_RT
				   ---- , B.MSR_GR_CD
				   ---- , B.MSR_NVL
       ----             --Current에 MS_DDN 없음						, B.MSR_DDN
				   ---- , @p_user_id
				   ---- , SYSDATETIME()
				   ---- , @p_user_id
				   ---- , SYSDATETIME()
			    ----);
            PRINT N'INSERT - SCP_MST_CAPA_ELTR_LOSS_PLAN - 월별 운영계획 - END'
--SELECT  A.*
--FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--        JOIN #tblSCP0106_RAW_FINAL B ON
--				A.DIVISION_ID		    = B.DIVISION_ID
--			AND A.MDL_NM				= B.MDL_NM
--			AND A.PLANT_ID				= B.PLANT_ID
--			AND A.LINE_ID				= B.LINE_ID
--			AND A.OPERATION_ID			= B.OPERATION_ID
--			----AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
--			AND A.COMPANY_ID			= B.COMPANY_ID
--			AND A.SITE_ID				= B.SITE_ID
--			AND A.FACTORY_ID			= B.FACTORY_ID
--			AND A.MSR_GR_CD				= B.MSR_GR_CD
--			AND A.MSR_TP_CD				= B.MSR_TP_CD
--			AND A.YYYYMM				= B.YYYYMM
--WHERE   1=1
--    AND A.YYYYMM = '202409'
----rollback tran;return;


--TESTING : NOK
--SELECT  A.*
--FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--        JOIN #tblSCP0106_RAW_FINAL_BASE B ON
--				A.DIVISION_ID		    = B.DIVISION_ID
--			AND A.MDL_NM				= B.MDL_NM
--			AND A.PLANT_ID				= B.PLANT_ID
--			AND A.LINE_ID				= B.LINE_ID
--			AND A.OPERATION_ID			= B.OPERATION_ID
--			AND A.COMPANY_ID			= B.COMPANY_ID
--			AND A.SITE_ID				= B.SITE_ID
--			AND A.FACTORY_ID			= B.FACTORY_ID
--			AND A.MSR_GR_CD				= B.MSR_GR_CD
--			AND A.MSR_TP_CD				= B.MSR_TP_CD
--WHERE   1=1
--    AND A.YYYYMM = '202409'

            PRINT N'INSERT - SCP_MST_CAPA_ELTR_LOSS_PLAN - BASE - BEGIN'
			    MERGE INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
			    USING
			    (
				    SELECT    DIVISION_ID
				            , MDL_NM
				            , PLANT_ID
				            , LINE_ID
				            , OPERATION_ID
				            , ELTR_LN_TP_CD
				            , COMPANY_ID
				            , SITE_ID
				            , FACTORY_ID
				            , MSR_TP_CD
				            ----, PFRSLT_NVL
				            , BASE_NVL
				            , MSR_GR_CD
                    FROM    #tblSCP0106_RAW_FINAL_BASE
                    WHERE   1=1
			    ) B ON
			    (
					    A.DIVISION_ID		    = B.DIVISION_ID
				    AND A.MDL_NM				= B.MDL_NM
				    AND A.PLANT_ID				= B.PLANT_ID
				    AND A.LINE_ID				= B.LINE_ID
				    AND A.OPERATION_ID			= B.OPERATION_ID
				    AND A.COMPANY_ID			= B.COMPANY_ID
				    AND A.SITE_ID				= B.SITE_ID
				    AND A.FACTORY_ID			= B.FACTORY_ID
				    AND A.MSR_TP_CD				= B.MSR_TP_CD
				    AND A.MSR_GR_CD				= B.MSR_GR_CD
			    )
			    WHEN MATCHED THEN
			    UPDATE
			    SET
				    --  PFRSLT_NVL			= B.PFRSLT_NVL
				        BASE_NVL				= B.BASE_NVL
    --Current에 MS_DDN 없음						, MSR_DDN				= B.MSR_DDN
				    , ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
				    , LAST_UPDATED_BY		= CONCAT(@v_program_name, '-', @p_user_id)
				    , LAST_UPDATE_DATE		= SYSDATETIME()
                    ;
            PRINT N'INSERT - SCP_MST_CAPA_ELTR_LOSS_PLAN - BASE - END'
	    END --Update Loss Plan ########################################################################################################################################################################################

--TESTING : NOK
--SELECT  A.*
--FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--        JOIN #tblSCP0106_RAW_FINAL_BASE B ON
--				A.DIVISION_ID		    = B.DIVISION_ID
--			AND A.MDL_NM				= B.MDL_NM
--			AND A.PLANT_ID				= B.PLANT_ID
--			AND A.LINE_ID				= B.LINE_ID
--			AND A.OPERATION_ID			= B.OPERATION_ID
--			AND A.COMPANY_ID			= B.COMPANY_ID
--			AND A.SITE_ID				= B.SITE_ID
--			AND A.FACTORY_ID			= B.FACTORY_ID
--			AND A.MSR_GR_CD				= B.MSR_GR_CD
--			AND A.MSR_TP_CD				= B.MSR_TP_CD
--WHERE   1=1
--    AND A.YYYYMM = '202409'
--rollback tran;return;

        -- LOG end
		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''
		SET @d_event_date   = SYSDATETIME()

        IF @test_mode <> 'T'
        BEGIN
		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		--SELECT  'S' AS result_code,  @v_all_cnt AS result_cnt;
	END TRY
	BEGIN CATCH
		  IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
		  BEGIN
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
				  ISNULL(ERROR_PROCEDURE(), 'SCP0006_SAVE_PROJECT_ROUTE_PLANT')
	 			, 'ERROR'
	 			, NULL
	 			, ERROR_MESSAGE()
	 			, NULL
	 			, SYSDATETIME()
	 			, SYSDATETIME()
	 			, ERROR_PROCEDURE()
	 			, SYSDATETIME()
				, ERROR_PROCEDURE()
			)

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;


		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;


    BEGIN -- 커서 해제 & 임시테이블 삭제------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#tblSCP0106_LOSS_PLAN_KEYS') IS NOT NULL
			DROP TABLE #tblSCP0106_LOSS_PLAN_KEYS;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_ALL') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_ALL;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_FINAL') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_FINAL;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PROD_OP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_PROD_OP_RT;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_FINAL') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_FINAL;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_FINAL_BASE') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_FINAL_BASE;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_FINAL_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_FINAL_TEMP;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_KEYS') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_KEYS;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_ALL') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_ALL;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_FINAL') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_FINAL;
		IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT;
		IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_KEYS') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN_KEYS;
		IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_RAW') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN_RAW;
		IF OBJECT_ID('tempdb..#tbl_DAY_CNT_BASE') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT_BASE;
    END

END


