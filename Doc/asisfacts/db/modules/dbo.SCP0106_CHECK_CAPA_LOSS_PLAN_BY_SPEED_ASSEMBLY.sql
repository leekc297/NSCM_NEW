
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ASSEMBLY
 * Description  : ASSIGN 테이블 구조의 데이터를 파라미터로 Speed Plan Insert/Update
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/07/31   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - capa 이외 재계산 제외
 * 2024/08/19   chaan        V1.1.6                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - PF_RT => 100% 변경
 * 2024/08/29   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DAY_CNT 로직 수정 - SOP 적용
 * 2024/11/21   chaan        V1.1.11               PJ20239037 LGES CPS VOE 반영 및 고도화                     - Loss Plan 삭제 로직 삭제함
 * 2024/12/11   chaan        V1.1.12               PJ20239037 LGES CPS VOE 반영 및 고도화                     - Partial 구간 오류 수정
 * 2025/02/10   mrchois      V1.1.13               PJ20249346  LGES SCP 개선과제 이행	 - Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
*/

--DROP PROCEDURE [dbo].[SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ASSEMBLY]
--CREATE PROCEDURE [dbo].[SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ASSEMBLY]  
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
 --   SELECT	  '202411'		AS VER_ID
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
 --   FROM	SCP_MST_CAPA_SPEED_PLAN WITH(NOLOCK)
 --   WHERE   1=1
 --       AND DIVISION_ID				= N'81'
 --       --AND COMPANY_ID				= N'G870'
 --       --AND SITE_ID					= N'A003'
 --       --AND PLANT_ID				= N'G871'
 --       --AND FACTORY_ID				= N'AJ'
 --       AND LINE_ID					= N'A8AF1'
 --       AND OPERATION_ID			= N'A5000'
 --       AND ELTR_LN_TP_CD			= N'Anode'
 --       AND ITEM_ID					= N'-'
 --       AND NICK_NAME				= N'E62B'
 --       AND MSR_TP_CD				= N'PPM'
 --       AND YYYYMM					IN ('202503', '2030')

------TESTING : NOK
--select * from @TBL_SCP_MST_CAPA_SPEED_PLAN;return;


   
	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;

	DECLARE @p_version			NVARCHAR(30)        = '';
    DECLARE @p_version_seq		TINYINT             = 0;

    SELECT    @p_version        = MAX(VER_ID)
            , @p_version_seq    = MAX(VER_SEQ)
    FROM    @TBL_SCP_MST_CAPA_SPEED_PLAN;


    DECLARE @v_from_yyyy        NVARCHAR(8)			= N'';

    SET @v_from_yyyy        = SUBSTRING(@p_version, 1, 4);

	DECLARE @v_result_to_yyyymm			NVARCHAR(6)         = N'';

    SET @v_result_to_yyyymm     = CONVERT(CHAR(8), DATEADD(MM, -1, CONVERT(DATETIME, @p_version + '01')), 112);




 	DECLARE @test_mode                          NVARCHAR(20)		= N'F';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ASSEMBLY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER			= 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


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
		FROM    SCP_MST_CAPA_LINE_SOP WITH(NOLOCK)
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
				, SOP_YM			        AS YYYYMM
				, SOP_DDN			        AS DAY_CNT
                , CASE
                    WHEN ISNULL(SOP_DT, '') = '' THEN 0--(DATEDIFF(DAY, CAST(SOP_YM AS VARCHAR) + '0101', CAST(SOP_YM AS VARCHAR) + '1231')) + 1
                    ELSE ((DATEDIFF(DAY, SOP_DT, SUBSTRING(SOP_YM, 1, 4) + '1231')) + 1)
                  END                       AS DAY_CNT_YEAR
                , SUBSTRING(SOP_YM, 1, 4)   AS YYYY
		FROM    SCP_MST_CAPA_LINE_SOP WITH(NOLOCK)
		WHERE   1=1
			AND VALID_YN        = 'Y'

--TESTING : NOK
--select * from #tbl_DAY_CNT_BASE where YYYYMM = '202408';rollback tran;return;

        BEGIN --Speed Plan Raw ########################################################################################################################################################################################
            -- 뷰 필터링을 위해 MEASURE 제외한 키목록 작성
		    IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_PLAN_KEYS') IS NOT NULL
			    DROP TABLE #tblSCP0105_SPEED_PLAN_KEYS;

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
	                , A.YYYYMM
            INTO    #tblSCP0105_SPEED_PLAN_KEYS
            FROM    @TBL_SCP_MST_CAPA_SPEED_PLAN A
            WHERE   1<>1

            INSERT INTO #tblSCP0105_SPEED_PLAN_KEYS
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
	                , A.YYYYMM
            FROM    @TBL_SCP_MST_CAPA_SPEED_PLAN A
            GROUP BY  A.VER_ID
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
	                , A.YYYYMM

--TESTING : NOK
--select * from #tblSCP0105_SPEED_PLAN_KEYS;rollback tran;return;


		    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_RAW') IS NOT NULL
			    DROP TABLE #tblSCP0106_SPEED_PLAN_RAW;

		    --빈테이블 생성
            SELECT	  T.VER_ID
			        , T.VER_SEQ
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
                    , A.DAY_CNT                 AS BASE_DAY_CNT
                    , A.DAY_CNT
            INTO    #tblSCP0106_SPEED_PLAN_RAW
            FROM	SCP_MST_CAPA_SPEED_PLAN_V A
                    JOIN #tblSCP0105_SPEED_PLAN_KEYS T ON
                            A.DIVISION_ID       = T.DIVISION_ID
	                    AND A.COMPANY_ID        = T.COMPANY_ID
	                    AND A.SITE_ID           = T.SITE_ID
	                    AND A.PLANT_ID          = T.PLANT_ID
	                    AND A.FACTORY_ID        = T.FACTORY_ID
	                    AND A.LINE_ID           = T.LINE_ID
	                    AND A.OPERATION_ID      = T.OPERATION_ID
	                    AND A.ELTR_LN_TP_CD     = T.ELTR_LN_TP_CD
	                    AND A.ITEM_ID           = T.ITEM_ID
	                    AND A.NICK_NAME         = T.NICK_NAME
	                    AND A.YYYYMM            = T.YYYYMM
			        LEFT JOIN #tbl_DAY_CNT_BASE DC ON
					        A.DIVISION_ID		= DC.DIVISION_ID
				        AND A.COMPANY_ID		= DC.COMPANY_ID
				        AND A.SITE_ID			= DC.SITE_ID
				        AND A.PLANT_ID			= DC.PLANT_ID
				        AND A.FACTORY_ID		= DC.FACTORY_ID
				        AND A.LINE_ID			= DC.LINE_ID
				        AND A.OPERATION_ID		= DC.OPERATION_ID
				        AND A.ELTR_LN_TP_CD		= DC.ELTR_LN_TP_CD
				        AND T.VER_ID			= DC.YYYYMM
            WHERE   1<>1
--return
            INSERT INTO #tblSCP0106_SPEED_PLAN_RAW                                                                  
            SELECT	  T.VER_ID                                      
			        , T.VER_SEQ
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
	                , ISNULL(A.QTY, A.BASE_QTY)     AS QTY
	                , A.UI_UPD_YN
	                , A.REMARK
	                , A.CREATED_BY
	                , A.CREATION_DATE
	                , A.LAST_UPDATED_BY
	                , A.LAST_UPDATE_DATE
                    , DAY(EOMONTH(CONVERT(DATETIME, T.VER_ID + '01', 112))) - DAY(CONVERT(DATETIME, T.VER_ID + '01', 112)) + 1  AS BASE_DAY_CNT
                    , A.DAY_CNT
            FROM	SCP_MST_CAPA_SPEED_PLAN_V A
                    JOIN #tblSCP0105_SPEED_PLAN_KEYS T ON
                            A.DIVISION_ID       = T.DIVISION_ID
	                    AND A.COMPANY_ID        = T.COMPANY_ID
	                    AND A.SITE_ID           = T.SITE_ID
	                    AND A.PLANT_ID          = T.PLANT_ID
	                    AND A.FACTORY_ID        = T.FACTORY_ID
	                    AND A.LINE_ID           = T.LINE_ID
	                    AND A.OPERATION_ID      = T.OPERATION_ID
	                    AND A.ELTR_LN_TP_CD     = T.ELTR_LN_TP_CD
	                    AND A.ITEM_ID           = T.ITEM_ID
	                    AND A.NICK_NAME         = T.NICK_NAME
	                    AND A.YYYYMM            = T.YYYYMM
			        LEFT JOIN #tbl_DAY_CNT_BASE DC ON
					        A.DIVISION_ID		= DC.DIVISION_ID
				        AND A.COMPANY_ID		= DC.COMPANY_ID
				        AND A.SITE_ID			= DC.SITE_ID
				        AND A.PLANT_ID			= DC.PLANT_ID
				        AND A.FACTORY_ID		= DC.FACTORY_ID
				        AND A.LINE_ID			= DC.LINE_ID
				        AND A.OPERATION_ID		= DC.OPERATION_ID
				        AND A.ELTR_LN_TP_CD		= DC.ELTR_LN_TP_CD
				        AND T.VER_ID			= DC.YYYYMM
            WHERE   1=1
                AND A.MSR_TP_CD   = 'PPM' --PPM 변경시 영향을 받으므로
--TESTING : NOK
--select * from SCP_MST_CAPA_SPEED_PLAN_V;
--select * from #tblSCP0106_SPEED_PLAN_RAW;rollback tran;return;
        END --Speed Plan Raw ########################################################################################################################################################################################




        BEGIN --Speed Plan Keys ########################################################################################################################################################################################
		    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_KEYS') IS NOT NULL
			    DROP TABLE #tblSCP0106_SPEED_PLAN_KEYS;

		    --빈테이블 생성
		    SELECT	  A.DIVISION_ID
				    , A.NICK_NAME       AS MDL_NM
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
				    , A.NICK_NAME       AS MDL_NM
				    , A.PLANT_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELTR_LN_TP_CD
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.FACTORY_ID
		    FROM    #tblSCP0106_SPEED_PLAN_RAW A
		    GROUP BY  A.DIVISION_ID
				    , A.NICK_NAME
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
	        FROM	SCP_MST_CAPA_LOSS_PLAN_MDL A
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
	        FROM	SCP_MST_CAPA_LOSS_PLAN_MDL A
                    INNER JOIN #tblSCP0106_SPEED_PLAN_KEYS B ON
                            A.DIVISION_ID        = B.DIVISION_ID      
                        AND A.COMPANY_ID         = B.COMPANY_ID
                        AND A.SITE_ID            = B.SITE_ID
                        AND A.PLANT_ID           = B.PLANT_ID
                        AND A.FACTORY_ID         = B.FACTORY_ID
                        AND A.LINE_ID            = B.LINE_ID
                        AND A.OPERATION_ID       = B.OPERATION_ID
                        AND A.ELTR_LN_TP_CD      = B.ELTR_LN_TP_CD
                        AND A.MDL_NM             = B.MDL_NM

--TESTING : NOK
--select * from #tblSCP0106_SPEED_PLAN_KEYS;rollback tran;return;
--select * from #tblSCP0106_RAW_BASE;rollback tran;return;


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
                    --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                    , A.YYYYMM
                    , A.PFRSLT_NVL
                    , A.BASE_NVL
                    --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
			        ------, CASE
           ------             WHEN A.LOSS_CD = 'PROD_OP_RT' AND A.LOSS_RT IS NULL THEN A.BASE_NVL
           ------             ELSE
           ------                 IIF(A.IPRV_GOL_DIVS_CD = 'G', 0.0, A.LOSS_RT)
           ------           END AS LOSS_RT
                    --, IIF(A.IPRV_GOL_DIVS_CD = 'G', 0.0, A.LOSS_RT) AS LOSS_RT
					, A.LOSS_RT	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
	        FROM	#tblSCP0106_RAW_BASE A
--TESTING : NOK
--select * from #tblSCP0106_RAW_BASE;
--select * from #tblSCP0106_RAW_BASE where YYYYMM = '202408';
--select * from #tblSCP0106_RAW_OPPLAN where YYYYMM = '2027';rollback tran;return;
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
--select * from #tblSCP0106_RAW_BASE WHERE YYYYMM = '202408';
--select * from #tblSCP0106_RAW_KEYS WHERE YYYYMM = '202408';rollback tran;return;
        END --Loss Plan Keys ########################################################################################################################################################################################


	    BEGIN --Base용 ########################################################################################################################################################################################
		    PRINT N'계산용 서브쿼리 - BEGIN';
            BEGIN
		        --조업율

		        --양품가동률만 모델별 ----------------------------------------------------------------------
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_MDL_QL_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_MDL_QL_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_MDL_QL_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_MDL_QL_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'QL_RT';

		        --나머지는 모두 라인별 ----------------------------------------------------------------------
		        --BM
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_BM_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_BM_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_BM_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_BM_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'BM_RT';

		        --CM
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_CM_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_CM_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_CM_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_CM_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'CM_RT';

		        --Idle_LOB 설비대기
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_ID_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_ID_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_ID_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_ID_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'ID_RT';

		        --재료교체
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_MR_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_MR_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_MR_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_MR_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'MR_RT';

		        --원자재 품절
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_NM_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_NM_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_NM_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_NM_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'NM_RT';

		        --PD
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PD_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_PD_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_PD_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_PD_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'PD_RT';

                BEGIN --2024.07.31
		            --OP
		            IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_OP_RT') IS NOT NULL
			            DROP TABLE #tblSCP0106_RAW_BASE_LN_OP_RT;

		            SELECT  *
		            INTO    #tblSCP0106_RAW_BASE_LN_OP_RT
		            FROM    #tblSCP0106_RAW_BASE
		            WHERE   1<>1;

		            INSERT INTO #tblSCP0106_RAW_BASE_LN_OP_RT
		            SELECT  *
		            FROM    #tblSCP0106_RAW_BASE
		            WHERE   1=1
			            AND LOSS_CD = 'OP_RT';


		            --LD
		            IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_LD_RT') IS NOT NULL
			            DROP TABLE #tblSCP0106_RAW_BASE_LN_LD_RT;

		            SELECT  *
		            INTO    #tblSCP0106_RAW_BASE_LN_LD_RT
		            FROM    #tblSCP0106_RAW_BASE
		            WHERE   1<>1;

		            INSERT INTO #tblSCP0106_RAW_BASE_LN_LD_RT
		            SELECT  *
		            FROM    #tblSCP0106_RAW_BASE
		            WHERE   1=1
			            AND LOSS_CD = 'LD_RT';


		            --TEEP
		            IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_TEEP') IS NOT NULL
			            DROP TABLE #tblSCP0106_RAW_BASE_LN_TEEP;

		            SELECT  *
		            INTO    #tblSCP0106_RAW_BASE_LN_TEEP
		            FROM    #tblSCP0106_RAW_BASE
		            WHERE   1<>1;

		            INSERT INTO #tblSCP0106_RAW_BASE_LN_TEEP
		            SELECT  *
		            FROM    #tblSCP0106_RAW_BASE
		            WHERE   1=1
			            AND LOSS_CD = 'TEEP';


		            --PROD_OP_RT
		            IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PROD_OP_RT') IS NOT NULL
			            DROP TABLE #tblSCP0106_RAW_BASE_LN_PROD_OP_RT;

		            SELECT  *
		            INTO    #tblSCP0106_RAW_BASE_LN_PROD_OP_RT
		            FROM    #tblSCP0106_RAW_BASE
		            WHERE   1<>1;

		            INSERT INTO #tblSCP0106_RAW_BASE_LN_PROD_OP_RT
		            SELECT  *
		            FROM    #tblSCP0106_RAW_BASE
		            WHERE   1=1
			            AND LOSS_CD = 'PROD_OP_RT';
--TESTING : NOK
--select * from #tblSCP0106_RAW_BASE_LN_PROD_OP_RT;rollback tran;return;
                END --2024.07.31

                --TESTING : NOK
                --select * from #tblSCP0106_RAW_BASE_LN_PROD_OP_RT where YYYYMM = '';rollback tran;return;
		        --AV
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_AV_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_AV_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_AV_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_AV_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'AV_RT';



		        --성능가동률
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PF_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_PF_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_PF_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_PF_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'PF_RT';

        --TESTING : NOK
        --select * from #tblSCP0106_RAW_BASE;rollback tran;return;
        --select * from #tblSCP0106_RAW_BASE_LN_PF_RT WHERE YYYYMM = '202410';rollback tran;return;

		        --PM
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PM_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_PM_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_PM_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_PM_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'PM_RT';

		        --생산준비
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PP_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_PP_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_PP_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_PP_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'PP_RT';

		        --UT Down
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_UD_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_BASE_LN_UD_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_BASE_LN_UD_RT
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_BASE_LN_UD_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_BASE
		        WHERE   1=1
			        AND LOSS_CD = 'UD_RT';
            END
            PRINT N'계산용 서브쿼리 - END';

--TESTING : NOK
--select * from #tblSCP0106_RAW_BASE_LN_UD_RT;rollback tran;return;

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
			        , CONVERT(FLOAT, NULL)				AS BM_RT
			        , CONVERT(FLOAT, NULL)				AS CM_RT
			        , CONVERT(FLOAT, NULL)				AS ID_RT
			        , CONVERT(FLOAT, NULL)				AS MR_RT
			        , CONVERT(FLOAT, NULL)				AS NM_RT
			        , CONVERT(FLOAT, NULL)				AS PD_RT
			        , CONVERT(FLOAT, NULL)				AS PM_RT
			        , CONVERT(FLOAT, NULL)				AS PP_RT
			        , CONVERT(FLOAT, NULL)				AS UD_RT

                    , CONVERT(FLOAT, NULL)				AS OP_RT
			        , CONVERT(FLOAT, NULL)				AS LD_RT
			        , CONVERT(FLOAT, NULL)              AS AV_RT
			        , CONVERT(FLOAT, NULL)				AS PF_RT
			        , CONVERT(FLOAT, NULL)				AS QL_RT

                    , CONVERT(FLOAT, NULL)				AS TEEP
                    , CONVERT(FLOAT, NULL)				AS PROD_OP_RT
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
			        , ISNULL(BM_RT.BASE_NVL, 0)						AS BM_RT
			        , CM_RT.BASE_NVL						        AS CM_RT
			        , ID_RT.BASE_NVL						        AS ID_RT
			        , MR_RT.BASE_NVL						        AS MR_RT
			        , NM_RT.BASE_NVL						        AS NM_RT
			        , PD_RT.BASE_NVL						        AS PD_RT
			        , PM_RT.BASE_NVL						        AS PM_RT
			        , PP_RT.BASE_NVL						        AS PP_RT
			        , UD_RT.BASE_NVL						        AS UD_RT

                    , OP_RT.BASE_NVL						        AS OP_RT
                    , LD_RT.BASE_NVL						        AS LD_RT
			        , AV_RT.BASE_NVL								AS AV_RT
			        ----, CONVERT(NUMERIC(20, 10), 1.0)						AS AV_RT
			        ----, PF_RT.BASE_NVL								AS PF_RT
			        , CONVERT(NUMERIC(20, 10), 1.0)					AS PF_RT
			        , QL_RT.BASE_NVL								AS QL_RT

			        , TEEP.BASE_NVL									AS TEEP
			        , PROD_OP_RT.BASE_NVL							AS PROD_OP_RT
            FROM    #tblSCP0106_RAW_KEYS A
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_BM_RT BM_RT ON --BM
					            A.DIVISION_ID			= BM_RT.DIVISION_ID
				            AND A.COMPANY_ID			= BM_RT.COMPANY_ID
				            AND A.SITE_ID				= BM_RT.SITE_ID
				            AND A.PLANT_ID				= BM_RT.PLANT_ID
				            AND A.FACTORY_ID			= BM_RT.FACTORY_ID
				            AND A.LINE_ID				= BM_RT.LINE_ID
				            AND A.OPERATION_ID			= BM_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= BM_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= BM_RT.MDL_NM
				            AND A.YYYYMM            	= BM_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_CM_RT CM_RT ON --CM
					            A.DIVISION_ID			= CM_RT.DIVISION_ID
				            AND A.COMPANY_ID			= CM_RT.COMPANY_ID
				            AND A.SITE_ID				= CM_RT.SITE_ID
				            AND A.PLANT_ID				= CM_RT.PLANT_ID
				            AND A.FACTORY_ID			= CM_RT.FACTORY_ID
				            AND A.LINE_ID				= CM_RT.LINE_ID
				            AND A.OPERATION_ID			= CM_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= CM_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= CM_RT.MDL_NM
				            AND A.YYYYMM            	= CM_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_ID_RT ID_RT ON --Idle_LOB 설비대기
					            A.DIVISION_ID			= ID_RT.DIVISION_ID
				            AND A.COMPANY_ID			= ID_RT.COMPANY_ID
				            AND A.SITE_ID				= ID_RT.SITE_ID
				            AND A.PLANT_ID				= ID_RT.PLANT_ID
				            AND A.FACTORY_ID			= ID_RT.FACTORY_ID
				            AND A.LINE_ID				= ID_RT.LINE_ID
				            AND A.OPERATION_ID			= ID_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= ID_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= ID_RT.MDL_NM
				            AND A.YYYYMM            	= ID_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_MR_RT MR_RT ON --재료교체
					            A.DIVISION_ID			= MR_RT.DIVISION_ID
				            AND A.COMPANY_ID			= MR_RT.COMPANY_ID
				            AND A.SITE_ID				= MR_RT.SITE_ID
				            AND A.PLANT_ID				= MR_RT.PLANT_ID
				            AND A.FACTORY_ID			= MR_RT.FACTORY_ID
				            AND A.LINE_ID				= MR_RT.LINE_ID
				            AND A.OPERATION_ID			= MR_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= MR_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= MR_RT.MDL_NM
				            AND A.YYYYMM            	= MR_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_NM_RT NM_RT ON --원자재 품절
					            A.DIVISION_ID			= NM_RT.DIVISION_ID
				            AND A.COMPANY_ID			= NM_RT.COMPANY_ID
				            AND A.SITE_ID				= NM_RT.SITE_ID
				            AND A.PLANT_ID				= NM_RT.PLANT_ID
				            AND A.FACTORY_ID			= NM_RT.FACTORY_ID
				            AND A.LINE_ID				= NM_RT.LINE_ID
				            AND A.OPERATION_ID			= NM_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= NM_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= NM_RT.MDL_NM
				            AND A.YYYYMM            	= NM_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_PD_RT PD_RT ON --PD
					            A.DIVISION_ID			= PD_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PD_RT.COMPANY_ID
				            AND A.SITE_ID				= PD_RT.SITE_ID
				            AND A.PLANT_ID				= PD_RT.PLANT_ID
				            AND A.FACTORY_ID			= PD_RT.FACTORY_ID
				            AND A.LINE_ID				= PD_RT.LINE_ID
				            AND A.OPERATION_ID			= PD_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PD_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PD_RT.MDL_NM
				            AND A.YYYYMM            	= PD_RT.YYYYMM

                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_OP_RT OP_RT ON --OP
					            A.DIVISION_ID			= OP_RT.DIVISION_ID
				            AND A.COMPANY_ID			= OP_RT.COMPANY_ID
				            AND A.SITE_ID				= OP_RT.SITE_ID
				            AND A.PLANT_ID				= OP_RT.PLANT_ID
				            AND A.FACTORY_ID			= OP_RT.FACTORY_ID
				            AND A.LINE_ID				= OP_RT.LINE_ID
				            AND A.OPERATION_ID			= OP_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= OP_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= OP_RT.MDL_NM
				            AND A.YYYYMM            	= OP_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_LD_RT LD_RT ON --LD
					            A.DIVISION_ID			= LD_RT.DIVISION_ID
				            AND A.COMPANY_ID			= LD_RT.COMPANY_ID
				            AND A.SITE_ID				= LD_RT.SITE_ID
				            AND A.PLANT_ID				= LD_RT.PLANT_ID
				            AND A.FACTORY_ID			= LD_RT.FACTORY_ID
				            AND A.LINE_ID				= LD_RT.LINE_ID
				            AND A.OPERATION_ID			= LD_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= LD_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= LD_RT.MDL_NM
				            AND A.YYYYMM            	= LD_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_AV_RT AV_RT ON --AV
					            A.DIVISION_ID			= AV_RT.DIVISION_ID
				            AND A.COMPANY_ID			= AV_RT.COMPANY_ID
				            AND A.SITE_ID				= AV_RT.SITE_ID
				            AND A.PLANT_ID				= AV_RT.PLANT_ID
				            AND A.FACTORY_ID			= AV_RT.FACTORY_ID
				            AND A.LINE_ID				= AV_RT.LINE_ID
				            AND A.OPERATION_ID			= AV_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= AV_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= AV_RT.MDL_NM
				            AND A.YYYYMM            	= AV_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_PF_RT PF_RT ON --성능가동률
					            A.DIVISION_ID			= PF_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PF_RT.COMPANY_ID
				            AND A.SITE_ID				= PF_RT.SITE_ID
				            AND A.PLANT_ID				= PF_RT.PLANT_ID
				            AND A.FACTORY_ID			= PF_RT.FACTORY_ID
				            AND A.LINE_ID				= PF_RT.LINE_ID
				            AND A.OPERATION_ID			= PF_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PF_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PF_RT.MDL_NM
				            AND A.YYYYMM            	= PF_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_PM_RT PM_RT ON --PM
					            A.DIVISION_ID			= PM_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PM_RT.COMPANY_ID
				            AND A.SITE_ID				= PM_RT.SITE_ID
				            AND A.PLANT_ID				= PM_RT.PLANT_ID
				            AND A.FACTORY_ID			= PM_RT.FACTORY_ID
				            AND A.LINE_ID				= PM_RT.LINE_ID
				            AND A.OPERATION_ID			= PM_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PM_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PM_RT.MDL_NM
				            AND A.YYYYMM            	= PM_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_PP_RT PP_RT ON --생산준비
					            A.DIVISION_ID			= PP_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PP_RT.COMPANY_ID
				            AND A.SITE_ID				= PP_RT.SITE_ID
				            AND A.PLANT_ID				= PP_RT.PLANT_ID
				            AND A.FACTORY_ID			= PP_RT.FACTORY_ID
				            AND A.LINE_ID				= PP_RT.LINE_ID
				            AND A.OPERATION_ID			= PP_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PP_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PP_RT.MDL_NM
				            AND A.YYYYMM            	= PP_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_MDL_QL_RT QL_RT ON --양품가동률
					            A.DIVISION_ID			= QL_RT.DIVISION_ID
				            AND A.COMPANY_ID			= QL_RT.COMPANY_ID
				            AND A.SITE_ID				= QL_RT.SITE_ID
				            AND A.PLANT_ID				= QL_RT.PLANT_ID
				            AND A.FACTORY_ID			= QL_RT.FACTORY_ID
				            AND A.LINE_ID				= QL_RT.LINE_ID
				            AND A.OPERATION_ID			= QL_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= QL_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= QL_RT.MDL_NM
				            AND A.YYYYMM            	= QL_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_UD_RT UD_RT ON --UT Down
					            A.DIVISION_ID			= UD_RT.DIVISION_ID
				            AND A.COMPANY_ID			= UD_RT.COMPANY_ID
				            AND A.SITE_ID				= UD_RT.SITE_ID
				            AND A.PLANT_ID				= UD_RT.PLANT_ID
				            AND A.FACTORY_ID			= UD_RT.FACTORY_ID
				            AND A.LINE_ID				= UD_RT.LINE_ID
				            AND A.OPERATION_ID			= UD_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= UD_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= UD_RT.MDL_NM
				            AND A.YYYYMM            	= UD_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_TEEP TEEP ON --TEEP
					            A.DIVISION_ID			= TEEP.DIVISION_ID
				            AND A.COMPANY_ID			= TEEP.COMPANY_ID
				            AND A.SITE_ID				= TEEP.SITE_ID
				            AND A.PLANT_ID				= TEEP.PLANT_ID
				            AND A.FACTORY_ID			= TEEP.FACTORY_ID
				            AND A.LINE_ID				= TEEP.LINE_ID
				            AND A.OPERATION_ID			= TEEP.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= TEEP.ELTR_LN_TP_CD
				            AND A.MDL_NM				= TEEP.MDL_NM
				            AND A.YYYYMM            	= TEEP.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_BASE_LN_PROD_OP_RT PROD_OP_RT ON --PROD_OP_RT
					            A.DIVISION_ID			= PROD_OP_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PROD_OP_RT.COMPANY_ID
				            AND A.SITE_ID				= PROD_OP_RT.SITE_ID
				            AND A.PLANT_ID				= PROD_OP_RT.PLANT_ID
				            AND A.FACTORY_ID			= PROD_OP_RT.FACTORY_ID
				            AND A.LINE_ID				= PROD_OP_RT.LINE_ID
				            AND A.OPERATION_ID			= PROD_OP_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PROD_OP_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PROD_OP_RT.MDL_NM
				            AND A.YYYYMM            	= PROD_OP_RT.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_RAW_KEYS WHERE YYYYMM = '202407';
--select * from #tblSCP0106_RAW_BASE_MDL_QL_RT WHERE YYYYMM = '202407';
--select * from #tblSCP0106_SPEED_PLAN_RAW;
--select * from #tblSCP0106_RAW_BASE_ALL WHERE YYYYMM = '202408';rollback tran;return;


	        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_FINAL_TEMP') IS NOT NULL
		        DROP TABLE #tblSCP0106_RAW_BASE_FINAL_TEMP;

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
			        , CONVERT(FLOAT, NULL)			AS BM_RT
			        , CONVERT(FLOAT, NULL)			AS CM_RT
			        , CONVERT(FLOAT, NULL)			AS ID_RT
			        , CONVERT(FLOAT, NULL)			AS MR_RT
			        , CONVERT(FLOAT, NULL)			AS NM_RT
			        , CONVERT(FLOAT, NULL)			AS PD_RT
			        , CONVERT(FLOAT, NULL)			AS PM_RT
			        , CONVERT(FLOAT, NULL)			AS PP_RT
			        , CONVERT(FLOAT, NULL)			AS UD_RT

			        , CONVERT(FLOAT, NULL)			AS OP_RT
			        , CONVERT(FLOAT, NULL)			AS LD_RT
			        , CONVERT(FLOAT, NULL)			AS AV_RT

			        , CONVERT(FLOAT, NULL)			AS PF_RT
			        , CONVERT(FLOAT, NULL)			AS QL_RT

			        , CONVERT(FLOAT, NULL)			AS TEEP
			        , CONVERT(FLOAT, NULL)			AS PROD_OP_RT

			        , CONVERT(FLOAT, NULL)			AS THRY_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS PROD_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS PROD_CAPA_M

			        , CONVERT(FLOAT, NULL)			AS BASE_THRY_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_M

                    , CONVERT(FLOAT, NULL)			AS PPM
                    , CONVERT(FLOAT, NULL)			AS BASE_PPM
	        INTO	#tblSCP0106_RAW_BASE_FINAL_TEMP
            FROM    #tblSCP0106_RAW_KEYS A
	        WHERE	1<>1;

	        INSERT INTO #tblSCP0106_RAW_BASE_FINAL_TEMP
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
			        , A.BM_RT
			        , A.CM_RT
			        , A.ID_RT
			        , A.MR_RT
			        , A.NM_RT
			        , A.PD_RT
			        , A.PM_RT
			        , A.PP_RT
			        , A.UD_RT

			        , A.OP_RT
			        , A.LD_RT
			        , A.AV_RT

			        , A.PF_RT
			        , A.QL_RT

			        , A.TEEP
			        , A.PROD_OP_RT
 
			        , CONVERT(FLOAT, (S.QTY * 1440.0))														AS THRY_CAPA_D
                    , CONVERT(FLOAT, (S.QTY * 1440.0 * A.PROD_OP_RT))						                AS PROD_CAPA_D
                    ------, CONVERT(FLOAT, (S.QTY * 1440.0 * A.PROD_OP_RT) * S.DAY_CNT * A.AV_RT)                 AS PROD_CAPA_M
                    , CONVERT(FLOAT, (S.QTY * 1440.0 * A.PROD_OP_RT) * S.DAY_CNT)                           AS PROD_CAPA_M

			        , CONVERT(FLOAT, (S.BASE_QTY * 1440.0))													AS BASE_THRY_CAPA_D
                    , CONVERT(FLOAT, (S.BASE_QTY * 1440.0 * A.PROD_OP_RT))						            AS BASE_PROD_CAPA_D
                    ------, CONVERT(FLOAT, (S.BASE_QTY * 1440.0 * A.PROD_OP_RT) * S.BASE_DAY_CNT * A.AV_RT)	    AS BASE_PROD_CAPA_M
                    , CONVERT(FLOAT, (S.BASE_QTY * 1440.0 * A.PROD_OP_RT) * S.BASE_DAY_CNT)	                AS BASE_PROD_CAPA_M

                    , S.QTY
                    , S.BASE_QTY
            FROM    #tblSCP0106_RAW_BASE_ALL A
                    INNER JOIN #tblSCP0106_RAW_KEYS B ON
					        A.DIVISION_ID			= B.DIVISION_ID
				        AND A.COMPANY_ID			= B.COMPANY_ID
				        AND A.SITE_ID				= B.SITE_ID
				        AND A.PLANT_ID				= B.PLANT_ID
				        AND A.FACTORY_ID			= B.FACTORY_ID
				        AND A.LINE_ID				= B.LINE_ID
				        AND A.OPERATION_ID			= B.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
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
				        AND A.ELTR_LN_TP_CD			= S.ELTR_LN_TP_CD
				        AND A.MDL_NM				= S.NICK_NAME
                        AND A.YYYYMM                = S.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_RAW_BASE_FINAL_TEMP;rollback tran;return;


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
			        , A.BM_RT
			        , A.CM_RT
			        , A.ID_RT
			        , A.MR_RT
			        , A.NM_RT
			        , A.PD_RT
			        , A.PM_RT
			        , A.PP_RT
			        , A.UD_RT
			        , A.OP_RT
			        , A.LD_RT
			        , A.AV_RT
			        , A.PF_RT
			        , A.QL_RT
			        , A.TEEP
			        , A.PROD_OP_RT
			        , A.THRY_CAPA_D
                    , A.PROD_CAPA_D
                    , A.PROD_CAPA_M
			        , A.BASE_THRY_CAPA_D
                    , A.BASE_PROD_CAPA_D
                    , A.BASE_PROD_CAPA_M
                    , A.PPM
                    , A.BASE_PPM
	        INTO	#tblSCP0106_RAW_BASE_FINAL
            FROM    #tblSCP0106_RAW_BASE_FINAL_TEMP A
            WHERE   1<>1

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
			        , MAX(A.BM_RT)					AS BM_RT
			        , MAX(A.CM_RT)					AS CM_RT
			        , MAX(A.ID_RT)					AS ID_RT
			        , MAX(A.MR_RT)					AS MR_RT
			        , MAX(A.NM_RT)					AS NM_RT
			        , MAX(A.PD_RT)					AS PD_RT
			        , MAX(A.PM_RT)					AS PM_RT
			        , MAX(A.PP_RT)					AS PP_RT
			        , MAX(A.UD_RT)					AS UD_RT
			        , MAX(A.OP_RT)					AS OP_RT
			        , MAX(A.LD_RT)					AS LD_RT
			        , MAX(A.AV_RT)					AS AV_RT
			        , MAX(A.PF_RT)					AS PF_RT
			        , MAX(A.QL_RT)					AS QL_RT
			        , MAX(A.TEEP)					AS TEEP
			        , MAX(A.PROD_OP_RT)				AS PROD_OP_RT
			        , MAX(A.THRY_CAPA_D)			AS THRY_CAPA_D
                    , MAX(A.PROD_CAPA_D)			AS PROD_CAPA_D
                    , MAX(A.PROD_CAPA_M)			AS PROD_CAPA_M
			        , MAX(A.BASE_THRY_CAPA_D)		AS BASE_THRY_CAPA_D
                    , MAX(A.BASE_PROD_CAPA_D)		AS BASE_PROD_CAPA_D
                    , MAX(A.BASE_PROD_CAPA_M)		AS BASE_PROD_CAPA_M
                    , MAX(A.PPM)					AS PPM
                    , MAX(A.BASE_PPM)				AS BASE_PPM
            FROM    #tblSCP0106_RAW_BASE_FINAL_TEMP A
            WHERE   1=1
            GROUP BY  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM



--TESTING : NOK
--select * from #tblSCP0106_RAW_BASE_FINAL_TEMP;rollback tran;return;
----select * from #tblSCP0106_SPEED_PLAN_RAW-- WHERE YYYYMM = '202408';
--select * from #tblSCP0106_RAW_KEYS WHERE YYYYMM = '202408';
--select * from #tblSCP0106_RAW_BASE_ALL WHERE YYYYMM = '202408';
--select * from #tblSCP0106_SPEED_PLAN_RAW WHERE YYYYMM = '202408';
--select * from #tblSCP0106_RAW_BASE_FINAL;rollback tran;return;
	    END --Base용 ########################################################################################################################################################################################


	    BEGIN --운영계획용 ########################################################################################################################################################################################
		    PRINT N'계산용 서브쿼리 - BEGIN';
            BEGIN
		        --조업율

		        --양품가동률만 모델별 ----------------------------------------------------------------------
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_MDL_QL_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_MDL_QL_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_MDL_QL_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_MDL_QL_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'QL_RT';

    --TESTING : NOK
    --select * from #tblSCP0106_RAW_OPPLAN_MDL_QL_RT;rollback tran;return;

		        --나머지는 모두 라인별 ----------------------------------------------------------------------
		        --BM
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_BM_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_BM_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_BM_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_BM_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'BM_RT';

		        --CM
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_CM_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_CM_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_CM_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_CM_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'CM_RT';

		        --Idle_LOB 설비대기
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_ID_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_ID_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_ID_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_ID_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'ID_RT';

		        --재료교체
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_MR_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_MR_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_MR_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_MR_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'MR_RT';

		        --원자재 품절
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_NM_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_NM_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_NM_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_NM_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'NM_RT';

		        --PD
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PD_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PD_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_PD_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_PD_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'PD_RT';

                BEGIN --2024.07.31
		            --OP
		            IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_OP_RT') IS NOT NULL
			            DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_OP_RT;

		            SELECT  *
		            INTO    #tblSCP0106_RAW_OPPLAN_LN_OP_RT
		            FROM    #tblSCP0106_RAW_OPPLAN
		            WHERE   1<>1;

		            INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_OP_RT
		            SELECT  *
		            FROM    #tblSCP0106_RAW_OPPLAN
		            WHERE   1=1
			            AND LOSS_CD = 'OP_RT';


		            --LD
		            IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_LD_RT') IS NOT NULL
			            DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_LD_RT;

		            SELECT  *
		            INTO    #tblSCP0106_RAW_OPPLAN_LN_LD_RT
		            FROM    #tblSCP0106_RAW_OPPLAN
		            WHERE   1<>1;

		            INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_LD_RT
		            SELECT  *
		            FROM    #tblSCP0106_RAW_OPPLAN
		            WHERE   1=1
			            AND LOSS_CD = 'LD_RT';


		            --TEEP
		            IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_TEEP') IS NOT NULL
			            DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_TEEP;

		            SELECT  *
		            INTO    #tblSCP0106_RAW_OPPLAN_LN_TEEP
		            FROM    #tblSCP0106_RAW_OPPLAN
		            WHERE   1<>1;

		            INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_TEEP
		            SELECT  *
		            FROM    #tblSCP0106_RAW_OPPLAN
		            WHERE   1=1
			            AND LOSS_CD = 'TEEP';


		            --PROD_OP_RT
		            IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT') IS NOT NULL
			            DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT;

		            SELECT  *
		            INTO    #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT
		            FROM    #tblSCP0106_RAW_OPPLAN
		            WHERE   1<>1;

		            INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT
		            SELECT  *
		            FROM    #tblSCP0106_RAW_OPPLAN
		            WHERE   1=1
			            AND LOSS_CD = 'PROD_OP_RT';
                END --2024.07.31


		        --AV
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_AV_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_AV_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_AV_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_AV_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'AV_RT';

--TESTING : NOK
--select * from #tblSCP0106_RAW_OPPLAN_LN_AV_RT;
		        --성능가동률
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PF_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PF_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_PF_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_PF_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'PF_RT';

        --TESTING : NOK
        --select * from #tblSCP0106_RAW_OPPLAN;rollback tran;return;
        --select * from #tblSCP0106_RAW_OPPLAN_LN_PF_RT WHERE YYYYMM = '202407';rollback tran;return;

		        --PM
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PM_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PM_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_PM_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_PM_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'PM_RT';

		        --생산준비
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PP_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PP_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_PP_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_PP_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'PP_RT';

		        --UT Down
		        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_UD_RT') IS NOT NULL
			        DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_UD_RT;

		        SELECT  *
		        INTO    #tblSCP0106_RAW_OPPLAN_LN_UD_RT
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1<>1;

		        INSERT INTO #tblSCP0106_RAW_OPPLAN_LN_UD_RT
		        SELECT  *
		        FROM    #tblSCP0106_RAW_OPPLAN
		        WHERE   1=1
			        AND LOSS_CD = 'UD_RT';
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
			        , CONVERT(FLOAT, NULL)				AS BM_RT
			        , CONVERT(FLOAT, NULL)				AS CM_RT
			        , CONVERT(FLOAT, NULL)				AS ID_RT
			        , CONVERT(FLOAT, NULL)				AS MR_RT
			        , CONVERT(FLOAT, NULL)				AS NM_RT
			        , CONVERT(FLOAT, NULL)				AS PD_RT
			        , CONVERT(FLOAT, NULL)				AS PM_RT
			        , CONVERT(FLOAT, NULL)				AS PP_RT
			        , CONVERT(FLOAT, NULL)				AS UD_RT

                    , CONVERT(FLOAT, NULL)				AS OP_RT
			        , CONVERT(FLOAT, NULL)				AS LD_RT
			        , CONVERT(FLOAT, NULL)              AS AV_RT

			        , CONVERT(FLOAT, NULL)				AS PF_RT
			        , CONVERT(FLOAT, NULL)				AS QL_RT

                    , CONVERT(FLOAT, NULL)				AS TEEP
                    , CONVERT(FLOAT, NULL)				AS PROD_OP_RT
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
			        , ISNULL(BM_RT.LOSS_RT, 0)						AS BM_RT
			        , CM_RT.LOSS_RT						            AS CM_RT
			        , ID_RT.LOSS_RT						            AS ID_RT
			        , MR_RT.LOSS_RT						            AS MR_RT
			        , NM_RT.LOSS_RT						            AS NM_RT
			        , PD_RT.LOSS_RT						            AS PD_RT
			        , PM_RT.LOSS_RT						            AS PM_RT
			        , PP_RT.LOSS_RT						            AS PP_RT
			        , UD_RT.LOSS_RT						            AS UD_RT

                    , OP_RT.LOSS_RT						            AS OP_RT
                    , LD_RT.LOSS_RT						            AS LD_RT
			        , AV_RT.LOSS_RT									AS AV_RT

			        ----, PF_RT.LOSS_RT									AS PF_RT
			        , CONVERT(NUMERIC(20, 10), 1.0)					AS PF_RT
			        , QL_RT.LOSS_RT									AS QL_RT

			        , TEEP.LOSS_RT									AS TEEP
			        , PROD_OP_RT.LOSS_RT							AS PROD_OP_RT
            FROM    #tblSCP0106_RAW_KEYS A
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_BM_RT BM_RT ON --BM
					            A.DIVISION_ID			= BM_RT.DIVISION_ID
				            AND A.COMPANY_ID			= BM_RT.COMPANY_ID
				            AND A.SITE_ID				= BM_RT.SITE_ID
				            AND A.PLANT_ID				= BM_RT.PLANT_ID
				            AND A.FACTORY_ID			= BM_RT.FACTORY_ID
				            AND A.LINE_ID				= BM_RT.LINE_ID
				            AND A.OPERATION_ID			= BM_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= BM_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= BM_RT.MDL_NM
				            AND A.YYYYMM			    = BM_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_CM_RT CM_RT ON --CM
					            A.DIVISION_ID			= CM_RT.DIVISION_ID
				            AND A.COMPANY_ID			= CM_RT.COMPANY_ID
				            AND A.SITE_ID				= CM_RT.SITE_ID
				            AND A.PLANT_ID				= CM_RT.PLANT_ID
				            AND A.FACTORY_ID			= CM_RT.FACTORY_ID
				            AND A.LINE_ID				= CM_RT.LINE_ID
				            AND A.OPERATION_ID			= CM_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= CM_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= CM_RT.MDL_NM
				            AND A.YYYYMM			    = CM_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_ID_RT ID_RT ON --Idle_LOB 설비대기
					            A.DIVISION_ID			= ID_RT.DIVISION_ID
				            AND A.COMPANY_ID			= ID_RT.COMPANY_ID
				            AND A.SITE_ID				= ID_RT.SITE_ID
				            AND A.PLANT_ID				= ID_RT.PLANT_ID
				            AND A.FACTORY_ID			= ID_RT.FACTORY_ID
				            AND A.LINE_ID				= ID_RT.LINE_ID
				            AND A.OPERATION_ID			= ID_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= ID_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= ID_RT.MDL_NM
				            AND A.YYYYMM			    = ID_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_MR_RT MR_RT ON --재료교체
					            A.DIVISION_ID			= MR_RT.DIVISION_ID
				            AND A.COMPANY_ID			= MR_RT.COMPANY_ID
				            AND A.SITE_ID				= MR_RT.SITE_ID
				            AND A.PLANT_ID				= MR_RT.PLANT_ID
				            AND A.FACTORY_ID			= MR_RT.FACTORY_ID
				            AND A.LINE_ID				= MR_RT.LINE_ID
				            AND A.OPERATION_ID			= MR_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= MR_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= MR_RT.MDL_NM
				            AND A.YYYYMM			    = MR_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_NM_RT NM_RT ON --원자재 품절
					            A.DIVISION_ID			= NM_RT.DIVISION_ID
				            AND A.COMPANY_ID			= NM_RT.COMPANY_ID
				            AND A.SITE_ID				= NM_RT.SITE_ID
				            AND A.PLANT_ID				= NM_RT.PLANT_ID
				            AND A.FACTORY_ID			= NM_RT.FACTORY_ID
				            AND A.LINE_ID				= NM_RT.LINE_ID
				            AND A.OPERATION_ID			= NM_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= NM_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= NM_RT.MDL_NM
				            AND A.YYYYMM			    = NM_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_PD_RT PD_RT ON --PD
					            A.DIVISION_ID			= PD_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PD_RT.COMPANY_ID
				            AND A.SITE_ID				= PD_RT.SITE_ID
				            AND A.PLANT_ID				= PD_RT.PLANT_ID
				            AND A.FACTORY_ID			= PD_RT.FACTORY_ID
				            AND A.LINE_ID				= PD_RT.LINE_ID
				            AND A.OPERATION_ID			= PD_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PD_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PD_RT.MDL_NM
				            AND A.YYYYMM			    = PD_RT.YYYYMM

                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_OP_RT OP_RT ON --OP
					            A.DIVISION_ID			= OP_RT.DIVISION_ID
				            AND A.COMPANY_ID			= OP_RT.COMPANY_ID
				            AND A.SITE_ID				= OP_RT.SITE_ID
				            AND A.PLANT_ID				= OP_RT.PLANT_ID
				            AND A.FACTORY_ID			= OP_RT.FACTORY_ID
				            AND A.LINE_ID				= OP_RT.LINE_ID
				            AND A.OPERATION_ID			= OP_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= OP_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= OP_RT.MDL_NM
				            AND A.YYYYMM            	= OP_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_LD_RT LD_RT ON --LD
					            A.DIVISION_ID			= LD_RT.DIVISION_ID
				            AND A.COMPANY_ID			= LD_RT.COMPANY_ID
				            AND A.SITE_ID				= LD_RT.SITE_ID
				            AND A.PLANT_ID				= LD_RT.PLANT_ID
				            AND A.FACTORY_ID			= LD_RT.FACTORY_ID
				            AND A.LINE_ID				= LD_RT.LINE_ID
				            AND A.OPERATION_ID			= LD_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= LD_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= LD_RT.MDL_NM
				            AND A.YYYYMM            	= LD_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_AV_RT AV_RT ON --AV
					            A.DIVISION_ID			= AV_RT.DIVISION_ID
				            AND A.COMPANY_ID			= AV_RT.COMPANY_ID
				            AND A.SITE_ID				= AV_RT.SITE_ID
				            AND A.PLANT_ID				= AV_RT.PLANT_ID
				            AND A.FACTORY_ID			= AV_RT.FACTORY_ID
				            AND A.LINE_ID				= AV_RT.LINE_ID
				            AND A.OPERATION_ID			= AV_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= AV_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= AV_RT.MDL_NM
				            AND A.YYYYMM            	= AV_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_PF_RT PF_RT ON --성능가동률
					            A.DIVISION_ID			= PF_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PF_RT.COMPANY_ID
				            AND A.SITE_ID				= PF_RT.SITE_ID
				            AND A.PLANT_ID				= PF_RT.PLANT_ID
				            AND A.FACTORY_ID			= PF_RT.FACTORY_ID
				            AND A.LINE_ID				= PF_RT.LINE_ID
				            AND A.OPERATION_ID			= PF_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PF_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PF_RT.MDL_NM
				            AND A.YYYYMM            	= PF_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_PM_RT PM_RT ON --PM
					            A.DIVISION_ID			= PM_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PM_RT.COMPANY_ID
				            AND A.SITE_ID				= PM_RT.SITE_ID
				            AND A.PLANT_ID				= PM_RT.PLANT_ID
				            AND A.FACTORY_ID			= PM_RT.FACTORY_ID
				            AND A.LINE_ID				= PM_RT.LINE_ID
				            AND A.OPERATION_ID			= PM_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PM_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PM_RT.MDL_NM
				            AND A.YYYYMM            	= PM_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_PP_RT PP_RT ON --생산준비
					            A.DIVISION_ID			= PP_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PP_RT.COMPANY_ID
				            AND A.SITE_ID				= PP_RT.SITE_ID
				            AND A.PLANT_ID				= PP_RT.PLANT_ID
				            AND A.FACTORY_ID			= PP_RT.FACTORY_ID
				            AND A.LINE_ID				= PP_RT.LINE_ID
				            AND A.OPERATION_ID			= PP_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PP_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PP_RT.MDL_NM
				            AND A.YYYYMM            	= PP_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_MDL_QL_RT QL_RT ON --양품가동률
					            A.DIVISION_ID			= QL_RT.DIVISION_ID
				            AND A.COMPANY_ID			= QL_RT.COMPANY_ID
				            AND A.SITE_ID				= QL_RT.SITE_ID
				            AND A.PLANT_ID				= QL_RT.PLANT_ID
				            AND A.FACTORY_ID			= QL_RT.FACTORY_ID
				            AND A.LINE_ID				= QL_RT.LINE_ID
				            AND A.OPERATION_ID			= QL_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= QL_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= QL_RT.MDL_NM
				            AND A.YYYYMM            	= QL_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_UD_RT UD_RT ON --UT Down
					            A.DIVISION_ID			= UD_RT.DIVISION_ID
				            AND A.COMPANY_ID			= UD_RT.COMPANY_ID
				            AND A.SITE_ID				= UD_RT.SITE_ID
				            AND A.PLANT_ID				= UD_RT.PLANT_ID
				            AND A.FACTORY_ID			= UD_RT.FACTORY_ID
				            AND A.LINE_ID				= UD_RT.LINE_ID
				            AND A.OPERATION_ID			= UD_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= UD_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= UD_RT.MDL_NM
				            AND A.YYYYMM            	= UD_RT.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_TEEP TEEP ON --TEEP
					            A.DIVISION_ID			= TEEP.DIVISION_ID
				            AND A.COMPANY_ID			= TEEP.COMPANY_ID
				            AND A.SITE_ID				= TEEP.SITE_ID
				            AND A.PLANT_ID				= TEEP.PLANT_ID
				            AND A.FACTORY_ID			= TEEP.FACTORY_ID
				            AND A.LINE_ID				= TEEP.LINE_ID
				            AND A.OPERATION_ID			= TEEP.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= TEEP.ELTR_LN_TP_CD
				            AND A.MDL_NM				= TEEP.MDL_NM
				            AND A.YYYYMM            	= TEEP.YYYYMM
                        LEFT JOIN #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT PROD_OP_RT ON --PROD_OP_RT
					            A.DIVISION_ID			= PROD_OP_RT.DIVISION_ID
				            AND A.COMPANY_ID			= PROD_OP_RT.COMPANY_ID
				            AND A.SITE_ID				= PROD_OP_RT.SITE_ID
				            AND A.PLANT_ID				= PROD_OP_RT.PLANT_ID
				            AND A.FACTORY_ID			= PROD_OP_RT.FACTORY_ID
				            AND A.LINE_ID				= PROD_OP_RT.LINE_ID
				            AND A.OPERATION_ID			= PROD_OP_RT.OPERATION_ID
				            AND A.ELTR_LN_TP_CD			= PROD_OP_RT.ELTR_LN_TP_CD
				            AND A.MDL_NM				= PROD_OP_RT.MDL_NM
				            AND A.YYYYMM            	= PROD_OP_RT.YYYYMM

--TESTING - NOK
--select * from #tblSCP0106_RAW_OPPLAN_ALL;rollback tran;return;


	        IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_FINAL_TEMP') IS NOT NULL
		        DROP TABLE #tblSCP0106_RAW_OPPLAN_FINAL_TEMP;

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
			        , CONVERT(FLOAT, NULL)			AS BM_RT
			        , CONVERT(FLOAT, NULL)			AS CM_RT
			        , CONVERT(FLOAT, NULL)			AS ID_RT
			        , CONVERT(FLOAT, NULL)			AS MR_RT
			        , CONVERT(FLOAT, NULL)			AS NM_RT
			        , CONVERT(FLOAT, NULL)			AS PD_RT
			        , CONVERT(FLOAT, NULL)			AS PM_RT
			        , CONVERT(FLOAT, NULL)			AS PP_RT
			        , CONVERT(FLOAT, NULL)			AS UD_RT

			        , CONVERT(FLOAT, NULL)			AS OP_RT
			        , CONVERT(FLOAT, NULL)			AS LD_RT
			        , CONVERT(FLOAT, NULL)			AS AV_RT
			        , CONVERT(FLOAT, NULL)			AS PF_RT
			        , CONVERT(FLOAT, NULL)			AS QL_RT

			        , CONVERT(FLOAT, NULL)			AS TEEP
			        , CONVERT(FLOAT, NULL)			AS PROD_OP_RT

			        , CONVERT(FLOAT, NULL)			AS THRY_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS PROD_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS PROD_CAPA_M

			        , CONVERT(FLOAT, NULL)			AS BASE_THRY_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_D
                    , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_M

                    , CONVERT(FLOAT, NULL)			AS PPM
                    , CONVERT(FLOAT, NULL)			AS BASE_PPM
	        INTO	#tblSCP0106_RAW_OPPLAN_FINAL_TEMP
            FROM    #tblSCP0106_RAW_KEYS A
	        WHERE	1<>1;

	        INSERT INTO #tblSCP0106_RAW_OPPLAN_FINAL_TEMP
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
			        , A.BM_RT
			        , A.CM_RT
			        , A.ID_RT
			        , A.MR_RT
			        , A.NM_RT
			        , A.PD_RT
			        , A.PM_RT
			        , A.PP_RT
			        , A.UD_RT

			        , A.OP_RT
			        , A.LD_RT
			        , A.AV_RT
			        , A.PF_RT
			        , A.QL_RT

			        , A.TEEP
			        , A.PROD_OP_RT

			        , CONVERT(FLOAT, (S.QTY * 1440.0))														AS THRY_CAPA_D
                    , CONVERT(FLOAT, (S.QTY * 1440.0 * A.PROD_OP_RT))						                AS PROD_CAPA_D
                    ------, CONVERT(FLOAT, (S.QTY * 1440.0 * A.PROD_OP_RT) * S.DAY_CNT * A.AV_RT)                 AS PROD_CAPA_M
                    , CONVERT(FLOAT, (S.QTY * 1440.0 * A.PROD_OP_RT) * S.DAY_CNT)                 AS PROD_CAPA_M

			        , CONVERT(FLOAT, (S.BASE_QTY * 1440.0))													AS BASE_THRY_CAPA_D
                    , CONVERT(FLOAT, (S.BASE_QTY * 1440.0 * A.PROD_OP_RT))						            AS BASE_PROD_CAPA_D
                    ------, CONVERT(FLOAT, (S.BASE_QTY * 1440.0 * A.PROD_OP_RT) * S.BASE_DAY_CNT * A.AV_RT)	    AS BASE_PROD_CAPA_M
                    , CONVERT(FLOAT, (S.BASE_QTY * 1440.0 * A.PROD_OP_RT) * S.BASE_DAY_CNT)	    AS BASE_PROD_CAPA_M

                    , S.QTY
                    , S.BASE_QTY
            FROM    #tblSCP0106_RAW_OPPLAN_ALL A
                    INNER JOIN #tblSCP0106_RAW_KEYS B ON
					        A.DIVISION_ID			= B.DIVISION_ID
				        AND A.COMPANY_ID			= B.COMPANY_ID
				        AND A.SITE_ID				= B.SITE_ID
				        AND A.PLANT_ID				= B.PLANT_ID
				        AND A.FACTORY_ID			= B.FACTORY_ID
				        AND A.LINE_ID				= B.LINE_ID
				        AND A.OPERATION_ID			= B.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
				        AND A.MDL_NM				= B.MDL_NM
				        AND A.YYYYMM				= B.YYYYMM
                    ----LEFT JOIN #tblSCP0106_SPEED_PLAN_RAW S ON
                    INNER JOIN #tblSCP0106_SPEED_PLAN_RAW S ON
                            A.DIVISION_ID			= S.DIVISION_ID
				        AND A.COMPANY_ID			= S.COMPANY_ID
				        AND A.SITE_ID				= S.SITE_ID
				        AND A.PLANT_ID				= S.PLANT_ID
				        AND A.FACTORY_ID			= S.FACTORY_ID
				        AND A.LINE_ID				= S.LINE_ID
				        AND A.OPERATION_ID			= S.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= S.ELTR_LN_TP_CD
				        AND A.MDL_NM				= S.NICK_NAME
				        AND A.YYYYMM				= S.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_RAW_KEYS;
--select * from #tblSCP0106_RAW_OPPLAN_ALL
--select * from #tblSCP0106_SPEED_PLAN_RAW
--select * from #tblSCP0106_RAW_OPPLAN_FINAL_TEMP;rollback tran;return;

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
			        , A.BM_RT
			        , A.CM_RT
			        , A.ID_RT
			        , A.MR_RT
			        , A.NM_RT
			        , A.PD_RT
			        , A.PM_RT
			        , A.PP_RT
			        , A.UD_RT
			        , A.OP_RT
			        , A.LD_RT
			        , A.AV_RT
			        , A.PF_RT
			        , A.QL_RT
			        , A.TEEP
			        , A.PROD_OP_RT
			        , A.THRY_CAPA_D
                    , A.PROD_CAPA_D
                    , A.PROD_CAPA_M
			        , A.BASE_THRY_CAPA_D
                    , A.BASE_PROD_CAPA_D
                    , A.BASE_PROD_CAPA_M
                    , A.PPM
                    , A.BASE_PPM
	        INTO	#tblSCP0106_RAW_OPPLAN_FINAL
            FROM    #tblSCP0106_RAW_OPPLAN_FINAL_TEMP A
            WHERE   1<>1

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
			        , MAX(A.BM_RT)					AS BM_RT
			        , MAX(A.CM_RT)					AS CM_RT
			        , MAX(A.ID_RT)					AS ID_RT
			        , MAX(A.MR_RT)					AS MR_RT
			        , MAX(A.NM_RT)					AS NM_RT
			        , MAX(A.PD_RT)					AS PD_RT
			        , MAX(A.PM_RT)					AS PM_RT
			        , MAX(A.PP_RT)					AS PP_RT
			        , MAX(A.UD_RT)					AS UD_RT
			        , MAX(A.OP_RT)					AS OP_RT
			        , MAX(A.LD_RT)					AS LD_RT
			        , MAX(A.AV_RT)					AS AV_RT
			        , MAX(A.PF_RT)					AS PF_RT
			        , MAX(A.QL_RT)					AS QL_RT
			        , MAX(A.TEEP)					AS TEEP
			        , MAX(A.PROD_OP_RT)				AS PROD_OP_RT
			        , MAX(A.THRY_CAPA_D)			AS THRY_CAPA_D
                    , MAX(A.PROD_CAPA_D)			AS PROD_CAPA_D
                    , MAX(A.PROD_CAPA_M)			AS PROD_CAPA_M
			        , MAX(A.BASE_THRY_CAPA_D)		AS BASE_THRY_CAPA_D
                    , MAX(A.BASE_PROD_CAPA_D)		AS BASE_PROD_CAPA_D
                    , MAX(A.BASE_PROD_CAPA_M)		AS BASE_PROD_CAPA_M
                    , MAX(A.PPM)					AS PPM
                    , MAX(A.BASE_PPM)				AS BASE_PPM
            FROM    #tblSCP0106_RAW_OPPLAN_FINAL_TEMP A
            WHERE   1=1
            GROUP BY  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.MDL_NM
			        , A.YYYYMM


	    END --운영계획용 ########################################################################################################################################################################################



--select * from #tblSCP0106_LOSS_PLAN_KEYS;
--select * from #tblSCP0106_RAW_BASE;
--select * from #tblSCP0106_RAW_BASE_FINAL;
--select * from #tblSCP0106_RAW_OPPLAN_FINAL;rollback tran;return;


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
            FROM    SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF A WITH(NOLOCK)
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
                        WHEN A.LOSS_CD = 'BM_RT'				THEN B.BM_RT
                        WHEN A.LOSS_CD = 'CM_RT'				THEN B.CM_RT
                        WHEN A.LOSS_CD = 'ID_RT'				THEN B.ID_RT
                        WHEN A.LOSS_CD = 'MR_RT'				THEN B.MR_RT
                        WHEN A.LOSS_CD = 'NM_RT'				THEN B.NM_RT
                        WHEN A.LOSS_CD = 'PD_RT'				THEN B.PD_RT
                        WHEN A.LOSS_CD = 'PM_RT'				THEN B.PM_RT
                        WHEN A.LOSS_CD = 'PP_RT'				THEN B.PP_RT
                        WHEN A.LOSS_CD = 'UD_RT'				THEN B.UD_RT

                        WHEN A.LOSS_CD = 'OP_RT'				THEN B.OP_RT
                        WHEN A.LOSS_CD = 'LD_RT'				THEN B.LD_RT
                        WHEN A.LOSS_CD = 'AV_RT'				THEN B.AV_RT
                        WHEN A.LOSS_CD = 'PF_RT'				THEN B.PF_RT
                        WHEN A.LOSS_CD = 'QL_RT'				THEN B.QL_RT

                        WHEN A.LOSS_CD = 'TEEP'				    THEN B.TEEP
                        WHEN A.LOSS_CD = 'PROD_OP_RT'			THEN B.PROD_OP_RT

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
                        WHEN A.LOSS_CD = 'BM_RT'				THEN O.BM_RT
                        WHEN A.LOSS_CD = 'CM_RT'				THEN O.CM_RT
                        WHEN A.LOSS_CD = 'ID_RT'				THEN O.ID_RT
                        WHEN A.LOSS_CD = 'MR_RT'				THEN O.MR_RT
                        WHEN A.LOSS_CD = 'NM_RT'				THEN O.NM_RT
                        WHEN A.LOSS_CD = 'PD_RT'				THEN O.PD_RT
                        WHEN A.LOSS_CD = 'PM_RT'				THEN O.PM_RT
                        WHEN A.LOSS_CD = 'PP_RT'				THEN O.PP_RT
                        WHEN A.LOSS_CD = 'UD_RT'				THEN O.UD_RT

                        WHEN A.LOSS_CD = 'OP_RT'				THEN O.OP_RT
                        WHEN A.LOSS_CD = 'LD_RT'				THEN O.LD_RT
                        WHEN A.LOSS_CD = 'AV_RT'				THEN O.AV_RT
                        WHEN A.LOSS_CD = 'PF_RT'				THEN O.PF_RT
                        WHEN A.LOSS_CD = 'QL_RT'				THEN O.QL_RT

                        WHEN A.LOSS_CD = 'TEEP'				    THEN O.TEEP
                        WHEN A.LOSS_CD = 'PROD_OP_RT'			THEN O.PROD_OP_RT

                        WHEN A.LOSS_CD = 'THRY_CAPA_D'	        THEN O.THRY_CAPA_D
                        WHEN A.LOSS_CD = 'PROD_CAPA_D'		    THEN O.PROD_CAPA_D
                        WHEN A.LOSS_CD = 'PROD_CAPA_M'		    THEN O.PROD_CAPA_M
                        ELSE
                            CONVERT(FLOAT, NULL)
                      END  AS MSR_NVL
            FROM    #tblSCP0106_LOSS_PLAN_KEYS K
                    INNER JOIN #tblSCP0106_SPEED_PLAN_RAW S ON
                            K.DIVISION_ID			= S.DIVISION_ID
				        AND K.COMPANY_ID			= S.COMPANY_ID
				        AND K.SITE_ID				= S.SITE_ID
				        AND K.PLANT_ID				= S.PLANT_ID
				        AND K.FACTORY_ID			= S.FACTORY_ID
				        AND K.LINE_ID				= S.LINE_ID
				        AND K.OPERATION_ID			= S.OPERATION_ID
				        AND K.ELTR_LN_TP_CD			= S.ELTR_LN_TP_CD
				        AND K.MDL_NM				= S.NICK_NAME
				        AND K.YYYYMM				= S.YYYYMM
                    LEFT JOIN #tblSCP0106_RAW_BASE A ON
                            K.DIVISION_ID			= A.DIVISION_ID
                        AND K.COMPANY_ID			= A.COMPANY_ID
                        AND K.SITE_ID				= A.SITE_ID
                        AND K.PLANT_ID				= A.PLANT_ID
                        AND K.FACTORY_ID			= A.FACTORY_ID
                        AND K.LINE_ID				= A.LINE_ID
                        AND K.OPERATION_ID			= A.OPERATION_ID
                        AND K.ELTR_LN_TP_CD			= A.ELTR_LN_TP_CD
                        AND K.MDL_NM				= A.MDL_NM
                        AND K.LOSS_CD               = A.LOSS_CD
                        AND K.YYYYMM                = A.YYYYMM
                    LEFT JOIN #tblSCP0106_RAW_BASE_FINAL B ON --Base용
                            A.DIVISION_ID			= B.DIVISION_ID
                        AND A.COMPANY_ID			= B.COMPANY_ID
                        AND A.SITE_ID				= B.SITE_ID
                        AND A.PLANT_ID				= B.PLANT_ID
                        AND A.FACTORY_ID			= B.FACTORY_ID
                        AND A.LINE_ID				= B.LINE_ID
                        AND A.OPERATION_ID			= B.OPERATION_ID
                        AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
                        AND A.MDL_NM				= B.MDL_NM
                        AND A.YYYYMM				= B.YYYYMM
                    LEFT JOIN #tblSCP0106_RAW_OPPLAN_FINAL O ON --운영계획용
                            A.DIVISION_ID			= O.DIVISION_ID
                        AND A.COMPANY_ID			= O.COMPANY_ID
                        AND A.SITE_ID				= O.SITE_ID
                        AND A.PLANT_ID				= O.PLANT_ID
                        AND A.FACTORY_ID			= O.FACTORY_ID
                        AND A.LINE_ID				= O.LINE_ID
                        AND A.OPERATION_ID			= O.OPERATION_ID
                        AND A.ELTR_LN_TP_CD			= O.ELTR_LN_TP_CD
                        AND A.MDL_NM				= O.MDL_NM
                        AND A.YYYYMM				= O.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_LOSS_PLAN_KEYS;
--select * from #tblSCP0106_RAW_FINAL_TEMP;rollback tran;return;


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
				    , AVG(A.BASE_NVL)              AS BASE_NVL
				    --, MAX(A.IPRV_GOL_DIVS_CD)      AS IPRV_GOL_DIVS_CD
				    --, AVG(A.IPRV_GOL_RT)           AS IPRV_GOL_RT			-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				    , A.MSR_GR_CD
				    , AVG(A.MSR_NVL)               AS MSR_NVL
            FROM    #tblSCP0106_RAW_FINAL_TEMP A
            WHERE   1=1
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
				    , A.MSR_GR_CD
				    , A.MSR_TP_CD
				    , A.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_RAW_FINAL_TEMP;
--select * from #tblSCP0106_RAW_FINAL;rollback tran;return;

	    END --최종 ########################################################################################################################################################################################

--TESTING : NOK
--SELECT  A.*
--FROM    SCP_MST_CAPA_LOSS_PLAN_MDL A
--        INNER JOIN #tblSCP0106_RAW_FINAL B ON
--				A.DIVISION_ID		    = B.DIVISION_ID
--			AND A.MDL_NM				= B.MDL_NM
--			AND A.PLANT_ID				= B.PLANT_ID
--			AND A.LINE_ID				= B.LINE_ID
--			AND A.OPERATION_ID			= B.OPERATION_ID
--			AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
--			AND A.COMPANY_ID			= B.COMPANY_ID
--			AND A.SITE_ID				= B.SITE_ID
--			AND A.FACTORY_ID			= B.FACTORY_ID
--			AND A.MSR_GR_CD				= B.MSR_GR_CD
--			AND A.MSR_TP_CD				= B.MSR_TP_CD
--			AND A.YYYYMM				= B.YYYYMM
--WHERE   1=1
--    --AND A.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')
--    AND A.YYYYMM = '2027'
--SELECT  A.*
--FROM    SCP_MST_CAPA_LOSS_PLAN_MDL A
--        INNER JOIN #tblSCP0106_RAW_FINAL B ON
--				A.DIVISION_ID		    = B.DIVISION_ID
--			AND A.MDL_NM				= B.MDL_NM
--			AND A.PLANT_ID				= B.PLANT_ID
--			AND A.LINE_ID				= B.LINE_ID
--			AND A.OPERATION_ID			= B.OPERATION_ID
--			AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
--			AND A.COMPANY_ID			= B.COMPANY_ID
--			AND A.SITE_ID				= B.SITE_ID
--			AND A.FACTORY_ID			= B.FACTORY_ID
--			AND A.MSR_GR_CD				= B.MSR_GR_CD
--			AND A.MSR_TP_CD				= B.MSR_TP_CD
--			AND A.YYYYMM				= B.YYYYMM
--WHERE   1=1
--    AND A.YYYYMM = '2027'
--rollback tran;return;


	    BEGIN --Update Loss Plan ########################################################################################################################################################################################
            PRINT N'INSERT - SCP_MST_CAPA_LOSS_PLAN - BEGIN'
			    MERGE INTO SCP_MST_CAPA_LOSS_PLAN_MDL A
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
				            --, IPRV_GOL_RT			-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				            , MSR_GR_CD
				            , MSR_NVL
                    FROM    #tblSCP0106_RAW_FINAL
                    WHERE   1=1
                        AND MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M', 'PF_RT') --CAPA, PF_RT 만 수정 2024.07.31
			    ) B ON
			    (
					    A.DIVISION_ID		    = B.DIVISION_ID
				    AND A.MDL_NM				= B.MDL_NM
				    AND A.PLANT_ID				= B.PLANT_ID
				    AND A.LINE_ID				= B.LINE_ID
				    AND A.OPERATION_ID			= B.OPERATION_ID
				    AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
				    AND A.COMPANY_ID			= B.COMPANY_ID
				    AND A.SITE_ID				= B.SITE_ID
				    AND A.FACTORY_ID			= B.FACTORY_ID
				    AND A.MSR_TP_CD				= B.MSR_TP_CD
				    AND A.YYYYMM				= B.YYYYMM
				    AND A.MSR_GR_CD				= B.MSR_GR_CD
                    --AND ((ISNULL(A.BASE_NVL, 0.0) <> ISNULL(B.BASE_NVL, 0.0)) OR (ISNULL(A.MSR_NVL, 0.0) <> ISNULL(B.MSR_NVL, 0.0))) --Base 나 운영계획이 변경된것만 수정
			    )
			    WHEN MATCHED THEN
			    UPDATE
			    SET
				    --  PFRSLT_NVL			= B.PFRSLT_NVL
				        BASE_NVL				= B.BASE_NVL
                    --, IPRV_GOL_RT			= B.IPRV_GOL_RT
                    , MSR_NVL				= B.MSR_NVL
    --Current에 MS_DDN 없음						, MSR_DDN				= B.MSR_DDN
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
                    
            PRINT N'INSERT - SCP_MST_CAPA_LOSS_PLAN - END'
	    END --Update Loss Plan ########################################################################################################################################################################################

        ------BEGIN
        ------    ;WITH tblNotValid AS
        ------    (
        ------        SELECT  *
        ------        FROM    SCP_MST_CAPA_LINE_ASSIGN
        ------        WHERE   1=1
        ------            AND ((ISNULL(ASSIGN_PRIORITY, 0) = 0 AND VALID_YN = 'Y' AND OPERATION_ID <> 'AFFFF') OR (VALID_YN <> 'Y'))
        ------    )
        ------        --SELECT  A.*
        ------        DELETE A -- 아예 삭제함
        ------        FROM    SCP_MST_CAPA_LOSS_PLAN_MDL A
        ------                INNER JOIN tblNotValid B ON
        ------                        A.DIVISION_ID		= B.DIVISION_ID
        ------                    AND A.COMPANY_ID		= B.COMPANY_ID
        ------                    AND A.SITE_ID			= B.SITE_ID
        ------                    AND A.PLANT_ID			= B.PLANT_ID
        ------                    AND A.FACTORY_ID		= B.FACTORY_ID
        ------                    AND A.LINE_ID			= B.LINE_ID
        ------                    AND A.OPERATION_ID		= B.OPERATION_ID
        ------                    AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
        ------                    AND A.MDL_NM			= B.NICK_NAME
        ------                    AND A.YYYYMM			= B.YYYYMM
        ------END


--TESTING : NOK
--SELECT  A.*
--FROM    SCP_MST_CAPA_LOSS_PLAN_MDL A
--        JOIN #tblSCP0106_RAW_FINAL B ON
--				A.DIVISION_ID		    = B.DIVISION_ID
--			AND A.MDL_NM				= B.MDL_NM
--			AND A.PLANT_ID				= B.PLANT_ID
--			AND A.LINE_ID				= B.LINE_ID
--			AND A.OPERATION_ID			= B.OPERATION_ID
--			AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
--			AND A.COMPANY_ID			= B.COMPANY_ID
--			AND A.SITE_ID				= B.SITE_ID
--			AND A.FACTORY_ID			= B.FACTORY_ID
--			AND A.MSR_GR_CD				= B.MSR_GR_CD
--			AND A.MSR_TP_CD				= B.MSR_TP_CD
--			AND A.YYYYMM				= B.YYYYMM
--WHERE   1=1
--    ----AND A.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')
--    --AND A.MSR_TP_CD IN ('PF_RT')
--    AND A.YYYYMM = '202503'
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
	    IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_PLAN_KEYS') IS NOT NULL
			DROP TABLE #tblSCP0105_SPEED_PLAN_KEYS;
	    IF OBJECT_ID('tempdb..#tblSCP0106_LOSS_PLAN_KEYS') IS NOT NULL
			DROP TABLE #tblSCP0106_LOSS_PLAN_KEYS;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_ALL') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_ALL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_FINAL') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_FINAL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_FINAL_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_FINAL_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_AV_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_AV_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_BM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_BM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_CM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_CM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_ID_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_ID_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_LD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_LD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_MR_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_MR_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_NM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_NM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_OP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_OP_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_PD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PF_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_PF_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_PM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_PP_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_PROD_OP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_PROD_OP_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_TEEP') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_TEEP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_LN_UD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_LN_UD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_BASE_MDL_QL_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_BASE_MDL_QL_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_FINAL') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_FINAL;
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
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_FINAL_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_FINAL_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_AV_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_AV_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_BM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_BM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_CM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_CM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_ID_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_ID_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_LD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_LD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_MR_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_MR_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_NM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_NM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_OP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_OP_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PF_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PF_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PP_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_PROD_OP_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_TEEP') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_TEEP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_LN_UD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_LN_UD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RAW_OPPLAN_MDL_QL_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RAW_OPPLAN_MDL_QL_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_KEYS') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN_KEYS;
	    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_RAW') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN_RAW;
	    IF OBJECT_ID('tempdb..#tbl_DAY_CNT') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT;
    END

END


