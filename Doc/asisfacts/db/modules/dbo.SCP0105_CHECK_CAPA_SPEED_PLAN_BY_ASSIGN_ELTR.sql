
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ELTR
 * Description  : ASSIGN 테이블 구조의 데이터를 파라미터로 Speed Plan Insert/Update
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
 * 2024/12/11   chaan        V1.1.6                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 로그 수정
 * 2025/04/08   hrkim		 V1.1.7                PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - CPS 소형 확산
*/

--DROP PROCEDURE [dbo].[SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ELTR]
--CREATE PROCEDURE [dbo].[SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ELTR]
CREATE PROCEDURE [dbo].[SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ELTR]
	  @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN   dbo.SCP_MST_CAPA_LINE_ASSIGN_TYPE READONLY

	, @p_program_id				NVARCHAR(100)
	, @p_sheet_name				NVARCHAR(100)
	, @p_user_id				NVARCHAR(30)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

--	DECLARE @p_program_id		NVARCHAR(100)	    	= N'SCP0105';
--	DECLARE @p_sheet_name		NVARCHAR(100)	    	= N'ELTR';
--    DECLARE @p_user_id			NVARCHAR(30)	    	= N'iamarock';
--    DECLARE @debug_mode			NVARCHAR(1)		    	= N'F';



--	DECLARE @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN   dbo.SCP_MST_CAPA_LINE_ASSIGN_TYPE;

--    INSERT INTO @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
--    SELECT	  '202410'		AS VER_ID
--			, 2				AS VER_SEQ
--			, DIVISION_ID
--			, COMPANY_ID
--			, SITE_ID
--			, PLANT_ID
--			, FACTORY_ID
--			, LINE_ID
--			, OPERATION_ID
--			, ELTR_LN_TP_CD
--			, ITEM_ID
--			, NICK_NAME
--			, YYYYMM
--			, ASSIGN_PRIORITY
--			, DUMMY_YN
--			, VALID_YN
--			, CREATED_BY
--			, CREATION_DATE
--			, LAST_UPDATED_BY
--			, LAST_UPDATE_DATE
--    FROM	SCP_MST_CAPA_ELTR_LINE_ASSIGN WITH(NOLOCK)
--    WHERE   1=1
--        --AND DIVISION_ID			= N'81'
--        --AND COMPANY_ID			= N'G480'
--        --AND SITE_ID				= N'A004'
--        --AND PLANT_ID			= N'G482'
--        --AND FACTORY_ID			= N'EB'
--        --AND LINE_ID				= ''
--        --AND OPERATION_ID		= N'E2000'
--        --AND ELTR_LN_TP_CD		= N''
--        --AND ITEM_ID				= N'JF1&R'
--        --AND NICK_NAME			= N'-'
--        AND LINE_ID				IN('DMY_TE_ELR_L1')


----TESTING : NOK
----select * from @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN;return;

--EXEC SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ELTR      @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
--                                                , N'SCP0105'
--                                                , N'ELTR'
--	                                            , @p_user_id
--	                                            , @debug_mode;
--select * from SCP_MST_CAPA_ELTR_SPEED_PLAN;return;


	IF OBJECT_ID('tempdb..#tblSCP0105_NOT_VALID') IS NOT NULL
		DROP TABLE #tblSCP0105_NOT_VALID;
    
    --빈테이블 생성
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
	        , ELTR_LN_TP_CD
	        , ITEM_ID
	        , NICK_NAME
    INTO    #tblSCP0105_NOT_VALID
    FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1<>1;

    INSERT INTO #tblSCP0105_NOT_VALID
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
	        , ELTR_LN_TP_CD
	        , ITEM_ID
	        , NICK_NAME
    FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1=1
        AND VALID_YN <> 'Y'
    GROUP BY  DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
	        , ELTR_LN_TP_CD
	        , ITEM_ID
	        , NICK_NAME;

--TESTING : NOK
--select * from #tblSCP0105_NOT_VALID;return;


    DECLARE @v_not_valid_cnt            INT     = 0;

    SELECT  @v_not_valid_cnt = COUNT(*) 
    FROM    #tblSCP0105_NOT_VALID;

    PRINT CONCAT('@v_not_valid_cnt : ', @v_not_valid_cnt);


	DECLARE @v_division_id		NVARCHAR(MAX)		    = N'';

 	DECLARE @test_mode                          NVARCHAR(20)		= N'F';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ELTR';
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


	    DECLARE @p_version			NVARCHAR(30)        = '';
        DECLARE @p_version_seq		TINYINT             = 0;
        DECLARE @v_from_yyyy        NVARCHAR(8)			= N'';

        SET @v_from_yyyy        = SUBSTRING(@p_version, 1, 4);

	    DECLARE @v_to_yyyy			NVARCHAR(4)			= '';


        SELECT    @p_version        = MAX(VER_ID)
                , @p_version_seq    = MAX(VER_SEQ)
                , @v_division_id    = MAX(DIVISION_ID)
                , @v_from_yyyy      = MIN(SUBSTRING(YYYYMM, 1, 4))
                , @v_to_yyyy        = MAX(SUBSTRING(YYYYMM, 1, 4))
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN;

        PRINT CONCAT('@p_version : ', @p_version);
        PRINT CONCAT('@p_version_seq : ', @p_version_seq);
        PRINT CONCAT('@v_division_id : ', @v_division_id);
        PRINT CONCAT('@v_from_yyyy : ', @v_from_yyyy);
        PRINT CONCAT('@v_to_yyyy : ', @v_to_yyyy);
        PRINT CONCAT('@v_to_yyyy : ', @v_to_yyyy);

        --return;

	    DECLARE @v_result_to_yyyymm			NVARCHAR(6)         = N'';

        SET @v_result_to_yyyymm     = CONVERT(CHAR(8), DATEADD(MM, -1, CONVERT(DATETIME, @p_version + '01')), 112);

        PRINT CONCAT('@v_result_to_yyyymm : ', @v_result_to_yyyymm);
        --rollback tran;return;


	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_MEASURE') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_MEASURE;

        --빈테이블 생성
        SELECT    COLUMN_NAME           AS MEASURE	
                , COLUMN_LABEL_NAME     AS MEASURE_NAME
                , SORT_ORDER_NO
        INTO    #tblSCP0105_CHECK_MEASURE
        FROM    [SCM_MST_SHEET_MEASURE]
        WHERE   1<>1;

        INSERT INTO #tblSCP0105_CHECK_MEASURE
        SELECT    MEASURE
                , MEASURE_NAME
                , SORT_ORDER_NO
        FROM     [dbo].[FN_SCP0105_GET_CAPA_MEASURE](@p_program_Id, @p_sheet_name);

--TESTING : NOK
--select * from #tblSCP0105_CHECK_MEASURE;rollback tran;return;


	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_MEASURE_QTY') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_MEASURE_QTY;

        SELECT    MEASURE
                , MEASURE_NAME
                , SORT_ORDER_NO
        INTO    #tblSCP0105_CHECK_MEASURE_QTY
        FROM    #tblSCP0105_CHECK_MEASURE
        WHERE   1=1
            AND MEASURE = 'EQP_SPED';

--TESTING : NOK
--select * from #tblSCP0105_CHECK_MEASURE_QTY;rollback tran;return;

        DECLARE @p_prog_stat      NVARCHAR(2)     = '0'; -- Current 만 생성 가능하므로 고정

        PRINT CONCAT('@p_prog_stat : ', @p_prog_stat);
        --return;


        PRINT N'GET - RESULT - BEGIN';
    	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RAW_TEMP') IS NOT NULL
    	    DROP TABLE #tblSCP0105_CHECK_RAW_TEMP;

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
                , A.BASE_QTY                    AS PFRSLT_QTY
                , A.QTY
                , A.UI_UPD_YN
                , A.REMARK
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
        INTO    #tblSCP0105_CHECK_RAW_TEMP
        FROM    SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF A WITH(NOLOCK)
        WHERE   1<>1;

        INSERT INTO #tblSCP0105_CHECK_RAW_TEMP
		SELECT	  @p_version							AS VER_ID
				, @p_version_seq                        AS VER_SEQ
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
				, M.MEASURE                             AS MSR_TP_CD
				, A.YYYYMM
                , CONVERT(FLOAT, NULL)        AS BASE_QTY
                , CONVERT(FLOAT, NULL)        AS PFRSLT_QTY
                , CONVERT(FLOAT, NULL)        AS QTY
                , CONVERT(NVARCHAR(1), 'N')             AS UI_UPD_YN
                , CONVERT(NVARCHAR(3000), NULL)         AS REMARK
				, CONCAT(@v_program_name, '-', @p_user_id)  AS CREATED_BY
				, SYSDATETIME()		                        AS CREATION_DATE
				, CONCAT(@v_program_name, '-', @p_user_id)	AS LAST_UPDATED_BY
				, SYSDATETIME()		                        AS LAST_UPDATE_DATE
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
				LEFT JOIN SCP_MST_CAPA_ELTR_LINE B WITH(NOLOCK) ON
					    A.DIVISION_ID		= B.DIVISION_ID
					AND A.COMPANY_ID		= B.COMPANY_ID
					AND A.SITE_ID			= B.SITE_ID
					AND A.PLANT_ID			= B.PLANT_ID
					AND A.FACTORY_ID		= B.FACTORY_ID
					AND A.LINE_ID			= B.LINE_ID
					AND A.OPERATION_ID		= B.OPERATION_ID
					AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
                JOIN #tblSCP0105_CHECK_MEASURE_QTY M ON
                    1=1
        WHERE   1=1;

--TESTING : NOK
--select * from SCP_MST_CAPA_ELTR_LINE;
--select * from @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN;@TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
--select * from #tblSCP0105_CHECK_RAW_TEMP;rollback tran;return;


    	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RESULT_TEMP') IS NOT NULL
    	    DROP TABLE #tblSCP0105_CHECK_RESULT_TEMP;
            
        --빈테이블 생성
        SELECT    A.DIVISION_ID                 AS DIVISION_ID
                , A.COMPANY_ID                  AS COMPANY_ID
                , A.SITE_ID                     AS SITE_ID
                , A.PLANT_ID                    AS PLANT_ID
                , A.FACTORY_ID                  AS FACTORY_ID
                , A.LINE_ID                     AS LINE_ID
                , A.OPERATION_ID                AS OPERATION_ID
                , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
                , A.MDL_NM                      AS ITEM_ID
                , A.MDL_NM                      AS NICK_NAME
                , A.EQP_SPED_UNIT_CD
                , A.EQP_NBU
                , A.EQP_SPED
                , A.PFRSLT_YM                   AS YYYYMM
        INTO    #tblSCP0105_CHECK_RESULT_TEMP
        FROM    SCM_DNM_ELTR_EQP_SPED_MMLY A WITH(NOLOCK)
        WHERE   1<>1


        INSERT INTO #tblSCP0105_CHECK_RESULT_TEMP
        SELECT    A.DIVISION_ID                 AS DIVISION_ID
                , A.COMPANY_ID                  AS COMPANY_ID
                , A.SITE_ID                     AS SITE_ID
                , A.PLANT_ID                    AS PLANT_ID
                , A.FACTORY_ID                  AS FACTORY_ID
                , A.LINE_ID                     AS LINE_ID
                , A.OPERATION_ID                AS OPERATION_ID
                , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
                , A.MDL_NM                      AS ITEM_ID
                , '-'                           AS NICK_NAME
                , UPPER(A.EQP_SPED_UNIT_CD)     AS EQP_SPED_UNIT_CD
                , A.EQP_NBU
                , A.EQP_SPED
                , A.PFRSLT_YM                   AS YYYYMM
        FROM    SCM_DNM_ELTR_EQP_SPED_MMLY A WITH(NOLOCK)
        WHERE   1=1
            ----AND SUBSTRING(PFRSLT_YM, 1, 4) >= @v_from_yyyy
            ----AND SUBSTRING(PFRSLT_YM, 1, 4) <= @v_to_yyyy;
		    AND A.PERD_DIVS_CD		= '3'
            AND A.PFRSLT_YM			= @v_result_to_yyyymm

--TESTING : NOK
--select * from #tblSCP0105_CHECK_RESULT_TEMP;rollback tran;return;


    	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RESULT_QTY') IS NOT NULL
            DROP TABLE #tblSCP0105_CHECK_RESULT_QTY;

        --빈테이블 생성
        SELECT    DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
    	        , ITEM_ID
                , NICK_NAME
                , CONVERT(NVARCHAR(50), 'EQP_SPED')      AS MSR_TP_CD
                , CONVERT(FLOAT, EQP_SPED)     AS QTY
        INTO    #tblSCP0105_CHECK_RESULT_QTY
        FROM    #tblSCP0105_CHECK_RESULT_TEMP
        WHERE   1<>1;

        INSERT INTO #tblSCP0105_CHECK_RESULT_QTY
        SELECT    DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
    	        , ITEM_ID
                , '-'                                   AS NICK_NAME
                , CONVERT(NVARCHAR(50), 'EQP_SPED')     AS MSR_TP_CD
                , AVG(EQP_SPED)                         AS EQP_SPED
        FROM    #tblSCP0105_CHECK_RESULT_TEMP
        WHERE   1=1
        GROUP BY  DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
    	        , ITEM_ID
                , NICK_NAME;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_RESULT_QTY;rollback tran;return;
        PRINT N'GET - RESULT - END';


        PRINT N'GET - BASE - BEGIN';
		BEGIN --BASE 테이블을 SCP_MST_MDL_EQP_SPED => EQUIPMENT 로 대체-------------------------------------------------------------------------------------------------
--			IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE_TEMP') IS NOT NULL
--				DROP TABLE #tblSCP0105_CHECK_BASE_TEMP;
--
--			--빈테이블 생성
--			SELECT    A.DIVISION_ID                 AS DIVISION_ID
--					, A.COMPANY_ID                  AS COMPANY_ID
--					, A.SITE_ID                     AS SITE_ID
--					, A.PLANT_ID                    AS PLANT_ID
--					, A.FACTORY_ID                  AS FACTORY_ID
--					, A.LINE_ID                     AS LINE_ID
--					, A.OPERATION_ID                AS OPERATION_ID
--					, A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
--					, A.MDL_NM                      AS ITEM_ID
--					, A.MDL_NM                      AS NICK_NAME
--					, A.EQP_SPED_UNIT_CD
--					, A.EQP_NBU
--					, A.EQP_SPED
--					, A.UI_UPD_YN
--			INTO    #tblSCP0105_CHECK_BASE_TEMP
--			FROM    SCP_MST_MDL_EQP_SPED A WITH(NOLOCK)
--			WHERE   1<>1;
--
--			INSERT INTO #tblSCP0105_CHECK_BASE_TEMP
--			SELECT    A.DIVISION_ID                 AS DIVISION_ID
--					, A.COMPANY_ID                  AS COMPANY_ID
--					, A.SITE_ID                     AS SITE_ID
--					, A.PLANT_ID                    AS PLANT_ID
--					, A.FACTORY_ID                  AS FACTORY_ID
--					, A.LINE_ID                     AS LINE_ID
--					, A.OPERATION_ID                AS OPERATION_ID
--					, A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
--					, A.MDL_NM                      AS ITEM_ID
--					, '-'                           AS NICK_NAME
--					, UPPER(A.EQP_SPED_UNIT_CD)     AS EQP_SPED_UNIT_CD
--					, A.EQP_NBU
--					, A.EQP_SPED
--					, A.UI_UPD_YN
--			FROM    SCP_MST_MDL_EQP_SPED A WITH(NOLOCK)
--			WHERE   1=1
--				AND A.USE_YN = 'Y';



			IF OBJECT_ID('tempdb..#tblSCP0105_EQPUIPMENT_TEMP') IS NOT NULL
				DROP TABLE #tblSCP0105_EQPUIPMENT_TEMP;

				--빈테이블 생성
				SELECT	  A.COMPANY_ID
						, A.DIVISION_ID
						, A.SITE_ID
						, A.PLANT_ID
						, A.FACTORY_ID
						, A.LINE_ID
						, A.OPERATION_ID
						, B.BOM_ITEM_ID
						, A.EQUIPMENT_ID
						, A.EQUIPMENT_NAME
						, A.WIDE_ROLL_ENABLE_FLAG
						, CONVERT(NVARCHAR(30), IIF(A.WIDE_ROLL_ENABLE_FLAG = 'Y', 'W', 'S'))      AS ELTR_LN_TP_CD
						, B.EQP_SPED
						, B.UPDATE_TIME				AS SPEED_UPDATE_TIME
						, A.UPDATE_TIME				AS EQPT_UPDATE_TIME
						, CONVERT(BIGINT, NULL)     AS RN
				INTO	#tblSCP0105_EQPUIPMENT_TEMP
				FROM	SCM_MST_EQUIPMENT_SN A WITH(NOLOCK)
						INNER JOIN SCM_MMD_EQPT_PRDT_SPEED_SN B WITH(NOLOCK) ON 
								B.EQP_ID = A.EQUIPMENT_ID
				WHERE	1<>1

				INSERT INTO #tblSCP0105_EQPUIPMENT_TEMP
				SELECT	  A.COMPANY_ID
						, A.DIVISION_ID
						, A.SITE_ID
						, A.PLANT_ID
						, A.FACTORY_ID
						, A.LINE_ID
						, A.OPERATION_ID
						, B.BOM_ITEM_ID
						, A.EQUIPMENT_ID
						, A.EQUIPMENT_NAME
						, A.WIDE_ROLL_ENABLE_FLAG
						, CONVERT(NVARCHAR(30), IIF(A.WIDE_ROLL_ENABLE_FLAG = 'Y', 'W', 'S'))      AS ELTR_LN_TP_CD
						, B.EQP_SPED
						, B.UPDATE_TIME				AS SPEED_UPDATE_TIME
						, A.UPDATE_TIME				AS EQPT_UPDATE_TIME
						, ROW_NUMBER() OVER (PARTITION BY 
													  A.DIVISION_ID
													, A.SITE_ID
													, A.COMPANY_ID
													, A.PLANT_ID
													, A.LINE_ID
													, A.OPERATION_ID
													, B.BOM_ITEM_ID
											  ORDER BY 
													  B.UPDATE_TIME DESC
													, A.UPDATE_TIME DESC) AS RN 
				FROM	SCM_MST_EQUIPMENT_SN A WITH(NOLOCK)
						INNER JOIN SCM_MMD_EQPT_PRDT_SPEED_SN B WITH(NOLOCK) ON 
								B.EQP_ID = A.EQUIPMENT_ID
				WHERE	1=1
					-- 2025.04.08 소형확산 AND A.DIVISION_ID      != '40'		-- 소형제외
					AND A.OPERATION_ID LIKE 'E2000%'	-- 전극 Coating 공정 (현재는 E2000 공정 하나만 대상)  
					AND A.EQUIPMENT_TYPE   = 'M'		-- Main 설비
					AND A.ACTIVE_FLAG      = 'Y'


			IF OBJECT_ID('tempdb..#tblSCP0105_EQPUIPMENT') IS NOT NULL
				DROP TABLE #tblSCP0105_EQPUIPMENT;

			SELECT    A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
					, A.ELTR_LN_TP_CD
                    , A.BOM_ITEM_ID                     AS ITEM_ID
                    , CONVERT(FLOAT, NULL)    AS EQP_NBU
					, A.EQP_SPED
			INTO    #tblSCP0105_EQPUIPMENT
			FROM    #tblSCP0105_EQPUIPMENT_TEMP A
			WHERE   1<>1;

			INSERT INTO #tblSCP0105_EQPUIPMENT
			SELECT    A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
					, A.ELTR_LN_TP_CD
                    , A.BOM_ITEM_ID                     AS ITEM_ID
                    , CONVERT(FLOAT, NULL)    AS EQP_NBU
					, AVG(A.EQP_SPED)
			FROM    #tblSCP0105_EQPUIPMENT_TEMP A
			WHERE   1=1
				AND A.RN = 1
			GROUP BY  A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
					, A.ELTR_LN_TP_CD
                    , A.BOM_ITEM_ID

		--TESTING : NOK
		--select * from #tblSCP0105_EQPUIPMENT_TEMP;
		--select * from #tblSCP0105_EQPUIPMENT;return;


			IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE_TEMP') IS NOT NULL
				DROP TABLE #tblSCP0105_CHECK_BASE_TEMP;

            --빈테이블 생성
			SELECT    A.DIVISION_ID                     AS DIVISION_ID
					, A.COMPANY_ID                      AS COMPANY_ID
					, A.SITE_ID                         AS SITE_ID
					, A.PLANT_ID                        AS PLANT_ID
					, A.FACTORY_ID                      AS FACTORY_ID
					, A.LINE_ID                         AS LINE_ID
					, A.OPERATION_ID                    AS OPERATION_ID
					, A.ELTR_LN_TP_CD                   AS ELTR_LN_TP_CD
					, A.ITEM_ID                         AS ITEM_ID
					, A.ITEM_ID                         AS NICK_NAME
					, 'EQP_SPED'                        AS EQP_SPED_UNIT_CD
                    , CONVERT(FLOAT, NULL)    AS EQP_NBU
					, A.EQP_SPED
					, 'N'                               AS UI_UPD_YN
            INTO    #tblSCP0105_CHECK_BASE_TEMP
			FROM    #tblSCP0105_EQPUIPMENT A
            WHERE   1<>1


			INSERT INTO #tblSCP0105_CHECK_BASE_TEMP
			SELECT    A.DIVISION_ID                     AS DIVISION_ID
					, A.COMPANY_ID                      AS COMPANY_ID
					, A.SITE_ID                         AS SITE_ID
					, A.PLANT_ID                        AS PLANT_ID
					, A.FACTORY_ID                      AS FACTORY_ID
					, A.LINE_ID                         AS LINE_ID
					, A.OPERATION_ID                    AS OPERATION_ID
					, A.ELTR_LN_TP_CD                   AS ELTR_LN_TP_CD
					, A.ITEM_ID                         AS ITEM_ID
					, '-'                               AS NICK_NAME
					, 'EQP_SPED'                        AS EQP_SPED_UNIT_CD
                    , CONVERT(FLOAT, NULL)    AS EQP_NBU
					, A.EQP_SPED
					, 'N'                               AS UI_UPD_YN
			FROM    #tblSCP0105_EQPUIPMENT A
        END   --BASE 테이블을 SCP_MST_MDL_EQP_SPED => EQUIPMENT 로 대체-------------------------------------------------------------------------------------------------


--TESTING : NOK
--select * from #tblSCP0105_CHECK_BASE_TEMP;rollback tran;return;

    	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE_KEY') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_BASE_KEY;
            
        --빈테이블 생성
        SELECT    A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.ITEM_ID
                , A.NICK_NAME
                , A.UI_UPD_YN
        INTO    #tblSCP0105_CHECK_BASE_KEY
        FROM    #tblSCP0105_CHECK_BASE_TEMP A
        WHERE   1<>1;

        INSERT INTO #tblSCP0105_CHECK_BASE_KEY
        SELECT    A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.ITEM_ID
                , A.NICK_NAME
                , A.UI_UPD_YN
        FROM    #tblSCP0105_CHECK_BASE_TEMP A
        WHERE   1=1
        GROUP BY  A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.ITEM_ID
                , A.NICK_NAME
                , A.UI_UPD_YN;

--TESTING : NOK;
--select * from #tblSCP0105_CHECK_BASE_KEY;rollback tran;return;


    	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE_QTY') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_BASE_QTY;

        --빈테이블 생성
        SELECT    DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , CONVERT(NVARCHAR(50), 'EQP_SPED')      AS MSR_TP_CD
                , CONVERT(FLOAT, EQP_SPED)     AS QTY
        INTO    #tblSCP0105_CHECK_BASE_QTY
        FROM    #tblSCP0105_CHECK_BASE_TEMP
        WHERE   1<>1;

        INSERT INTO #tblSCP0105_CHECK_BASE_QTY
        SELECT    DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , CONVERT(NVARCHAR(50), 'EQP_SPED')      AS MSR_TP_CD
                , AVG(EQP_SPED)                          AS EQP_SPED
        FROM    #tblSCP0105_CHECK_BASE_TEMP
        WHERE   1=1
        GROUP BY  DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_BASE_QTY;rollback tran;return;
        PRINT N'GET - BASE - END';


    	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RAW1') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_RAW1;

        --빈테이블 생성
        SELECT    @p_version							AS VER_ID
				, @p_version_seq                        AS VER_SEQ
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
                , A.BASE_QTY                            AS PFRSLT_QTY
                , A.QTY
                , A.UI_UPD_YN
                , A.REMARK
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
        INTO    #tblSCP0105_CHECK_RAW1
        FROM    SCP_MST_CAPA_ELTR_SPEED_PLAN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0105_CHECK_RAW1
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
                , BQ.QTY                                                AS BASE_QTY
                , RQ.QTY                                                AS PFRSLT_QTY
                , BQ.QTY                                                AS QTY -- 기본값을 BASE 기준으로
                , ISNULL(BK.UI_UPD_YN, 'N')                             AS UI_UPD_YN
                , A.REMARK
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
        FROM    #tblSCP0105_CHECK_RAW_TEMP A
				LEFT JOIN #tblSCP0105_CHECK_RESULT_QTY RQ ON
					    A.DIVISION_ID		                            = RQ.DIVISION_ID
					AND A.COMPANY_ID		                            = RQ.COMPANY_ID
					AND A.SITE_ID			                            = RQ.SITE_ID
					AND A.PLANT_ID			                            = RQ.PLANT_ID
					AND A.FACTORY_ID		                            = RQ.FACTORY_ID
					AND A.LINE_ID			                            = RQ.LINE_ID
					AND A.OPERATION_ID		                            = RQ.OPERATION_ID
					AND A.ELTR_LN_TP_CD	                                = RQ.ELTR_LN_TP_CD
					AND A.ITEM_ID                                       = RQ.ITEM_ID
					--AND A.MSR_TP_CD	                        = RQ.MSR_TP_CD
                LEFT JOIN #tblSCP0105_CHECK_BASE_KEY BK ON
					    A.DIVISION_ID		                            = BK.DIVISION_ID
					AND A.COMPANY_ID		                            = BK.COMPANY_ID
					AND A.SITE_ID			                            = BK.SITE_ID
					AND A.PLANT_ID			                            = BK.PLANT_ID
					AND A.FACTORY_ID		                            = BK.FACTORY_ID
					AND A.LINE_ID			                            = BK.LINE_ID
					AND A.OPERATION_ID		                            = BK.OPERATION_ID
					AND A.ELTR_LN_TP_CD	                                = BK.ELTR_LN_TP_CD
					AND A.ITEM_ID                                       = BK.ITEM_ID
				LEFT JOIN #tblSCP0105_CHECK_BASE_QTY BQ ON
					    A.DIVISION_ID		                            = BQ.DIVISION_ID
					AND A.COMPANY_ID		                            = BQ.COMPANY_ID
					AND A.SITE_ID			                            = BQ.SITE_ID
					AND A.PLANT_ID			                            = BQ.PLANT_ID
					AND A.FACTORY_ID		                            = BQ.FACTORY_ID
					AND A.LINE_ID			                            = BQ.LINE_ID
					AND A.OPERATION_ID		                            = BQ.OPERATION_ID
					AND A.ELTR_LN_TP_CD	                                = BQ.ELTR_LN_TP_CD
					AND A.ITEM_ID                                       = BQ.ITEM_ID
					--AND A.MSR_TP_CD	                        = BQ.MSR_TP_CD

--TESTING : NOK
--select * from #tblSCP0105_CHECK_RAW_TEMP
--select * from #tblSCP0105_CHECK_RAW1;rollback tran;return;


    	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RAW') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_RAW;

        --빈테이블 생성
        SELECT    A.VER_ID
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
                , A.PFRSLT_QTY
                , A.QTY
                , A.UI_UPD_YN
                , A.REMARK
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
        INTO    #tblSCP0105_CHECK_RAW
        FROM    #tblSCP0105_CHECK_RAW1 A
        WHERE   1<>1;

        INSERT INTO #tblSCP0105_CHECK_RAW
        SELECT    A.VER_ID
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
                , A.PFRSLT_QTY
                , CASE
                    WHEN ISNULL(B.ASSIGN_PRIORITY, 0) = 0 THEN NULL
                    ELSE A.QTY
                    END AS QTY
                , A.UI_UPD_YN
                , A.REMARK
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
        FROM    #tblSCP0105_CHECK_RAW1 A
                LEFT JOIN @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
					    A.DIVISION_ID		= B.DIVISION_ID
					AND A.COMPANY_ID		= B.COMPANY_ID
					AND A.SITE_ID			= B.SITE_ID
					AND A.PLANT_ID			= B.PLANT_ID
					AND A.FACTORY_ID		= B.FACTORY_ID
					AND A.LINE_ID			= B.LINE_ID
					AND A.OPERATION_ID		= B.OPERATION_ID
					AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
					AND A.ITEM_ID           = B.ITEM_ID
					AND A.YYYYMM            = B.YYYYMM

--TESTING : NOK
--select * from #tblSCP0105_CHECK_RAW;rollback tran;return;


        IF @v_not_valid_cnt > 0
        BEGIN
            --Valid = N 이면 추가나 수정 대상에서 삭제

            DELETE  A 
            FROM    #tblSCP0105_CHECK_RAW A
                    INNER JOIN #tblSCP0105_NOT_VALID B ON
                            A.DIVISION_ID		= B.DIVISION_ID
                        AND A.COMPANY_ID		= B.COMPANY_ID
                        AND A.SITE_ID			= B.SITE_ID
                        AND A.PLANT_ID			= B.PLANT_ID
                        AND A.FACTORY_ID		= B.FACTORY_ID
                        AND A.LINE_ID			= B.LINE_ID
                        AND A.OPERATION_ID		= B.OPERATION_ID
                        AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
                        AND A.ITEM_ID			= B.ITEM_ID;
        END
                
--TESTING : NOK
--select * from #tblSCP0105_CHECK_RAW;rollback tran;return;

        PRINT N'INSERT - SCP_MST_CAPA_ELTR_SPEED_PLAN - BEGIN'
        BEGIN
			MERGE INTO SCP_MST_CAPA_ELTR_SPEED_PLAN A
			USING
			(
				SELECT    DIVISION_ID
				        , COMPANY_ID
				        , SITE_ID
				        , PLANT_ID
				        , FACTORY_ID
				        , LINE_ID
				        , OPERATION_ID
				        , ELTR_LN_TP_CD
				        , ITEM_ID
				        , NICK_NAME
				        , MSR_TP_CD
				        , YYYYMM
                        , BASE_QTY
                        , QTY
                        , UI_UPD_YN
                        , REMARK
				        , CREATED_BY
				        , CREATION_DATE
				        , LAST_UPDATED_BY
				        , LAST_UPDATE_DATE
                FROM    #tblSCP0105_CHECK_RAW
                WHERE   1=1
                    AND ISNULL(DIVISION_ID, '') <> ''
                    AND ISNULL(COMPANY_ID, '') <> ''
                    AND ISNULL(SITE_ID, '') <> ''
                    AND ISNULL(PLANT_ID, '') <> ''
                    AND ISNULL(FACTORY_ID, '') <> ''
                    AND ISNULL(LINE_ID, '') <> ''
                    AND ISNULL(OPERATION_ID, '') <> ''
                    ------AND ISNULL(ELTR_LN_TP_CD, '') <> ''
                    AND ISNULL(ITEM_ID, '') <> ''
                    AND ISNULL(NICK_NAME, '') <> ''
				    AND ISNULL(MSR_TP_CD, '') <> ''
                    AND ISNULL(YYYYMM, '') <> ''
			) B ON
			(
					A.DIVISION_ID		    = B.DIVISION_ID
				AND A.COMPANY_ID		    = B.COMPANY_ID
				AND A.SITE_ID			    = B.SITE_ID
				AND A.PLANT_ID			    = B.PLANT_ID
				AND A.FACTORY_ID		    = B.FACTORY_ID
				AND A.LINE_ID			    = B.LINE_ID
				AND A.OPERATION_ID		    = B.OPERATION_ID
				----AND A.ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
				AND A.ITEM_ID			    = B.ITEM_ID
				AND A.NICK_NAME			    = B.NICK_NAME
				AND A.MSR_TP_CD	            = B.MSR_TP_CD
				AND A.YYYYMM			    = B.YYYYMM
			)
			WHEN MATCHED THEN
			UPDATE
			SET
				----  BASE_QTY		        = B.BASE_QTY
				----, QTY		            = B.QTY
				----Line Assign 통한 Speed Plan 수정에서는 변경 불가!!!, ELTR_LN_TP_CD		    = B.ELTR_LN_TP_CD
				  UI_UPD_YN             = B.UI_UPD_YN
				, LAST_UPDATED_BY		= B.LAST_UPDATED_BY
				, LAST_UPDATE_DATE		= B.LAST_UPDATE_DATE
			WHEN NOT MATCHED THEN
			INSERT
			(
				  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, ITEM_ID
				, NICK_NAME
				, MSR_TP_CD
				, YYYYMM
				, BASE_QTY
				, QTY
				, UI_UPD_YN
				, REMARK
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
			)
			VALUES
			(
				  B.DIVISION_ID
				, B.COMPANY_ID
				, B.SITE_ID
				, B.PLANT_ID
				, B.FACTORY_ID
				, B.LINE_ID
				, B.OPERATION_ID
				, B.ELTR_LN_TP_CD
				, B.ITEM_ID
				, B.NICK_NAME
				, B.MSR_TP_CD
				, B.YYYYMM
				, B.BASE_QTY
				, B.QTY
				, B.UI_UPD_YN
				, B.REMARK
                , B.CREATED_BY
                , B.CREATION_DATE
                , B.LAST_UPDATED_BY
                , B.LAST_UPDATE_DATE
			);


            --실제 테이블에서도 삭제
            IF @v_not_valid_cnt > 0
            BEGIN
                DELETE  A 
                FROM    SCP_MST_CAPA_ELTR_SPEED_PLAN A
                        INNER JOIN #tblSCP0105_NOT_VALID B ON
                                A.DIVISION_ID		= B.DIVISION_ID
                            AND A.COMPANY_ID		= B.COMPANY_ID
                            AND A.SITE_ID			= B.SITE_ID
                            AND A.PLANT_ID			= B.PLANT_ID
                            AND A.FACTORY_ID		= B.FACTORY_ID
                            AND A.LINE_ID			= B.LINE_ID
                            AND A.OPERATION_ID		= B.OPERATION_ID
                            AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
                            AND A.ITEM_ID			= B.ITEM_ID;
            END
            

            PRINT N'UPDATE - SCP_MST_CAPA_ELTR_SPEED_PLAN - BEGIN'
            --우선순위가 없으면 사용자가 입력한 SPEED, PPM 월별 데이터도 클리어(삭제 영향도 판단하여 삭제 고려!!!)
            UPDATE A
            SET
                A.QTY = NULL
            FROM    SCP_MST_CAPA_ELTR_SPEED_PLAN A
                    INNER JOIN @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
					A.DIVISION_ID		= B.DIVISION_ID
				AND A.COMPANY_ID		= B.COMPANY_ID
				AND A.SITE_ID			= B.SITE_ID
				AND A.PLANT_ID			= B.PLANT_ID
				AND A.FACTORY_ID		= B.FACTORY_ID
				AND A.LINE_ID			= B.LINE_ID
				AND A.OPERATION_ID		= B.OPERATION_ID
				AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
				AND A.ITEM_ID           = B.ITEM_ID
				AND A.YYYYMM            = B.YYYYMM
            WHERE   1=1
                AND ISNULL(B.ASSIGN_PRIORITY, 0) = 0;

            PRINT N'UPDATE - SCP_MST_CAPA_ELTR_SPEED_PLAN - END'
        END
        PRINT N'INSERT - SCP_MST_CAPA_ELTR_SPEED_PLAN - END'

        BEGIN
            DELETE A -- 아예 삭제함
            FROM    SCP_MST_CAPA_ELTR_SPEED_PLAN A
                    INNER JOIN (
                                    SELECT  *
                                    FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
                                    WHERE   1=1
                                        AND (ASSIGN_PRIORITY = 0 OR VALID_YN <> 'Y')
                                ) B ON
                            A.DIVISION_ID		= B.DIVISION_ID
                        AND A.COMPANY_ID		= B.COMPANY_ID
                        AND A.SITE_ID			= B.SITE_ID
                        AND A.PLANT_ID			= B.PLANT_ID
                        AND A.FACTORY_ID		= B.FACTORY_ID
                        AND A.LINE_ID			= B.LINE_ID
                        AND A.OPERATION_ID		= B.OPERATION_ID
                        AND A.ITEM_ID			= B.ITEM_ID
                        AND A.YYYYMM			= B.YYYYMM
        END

        BEGIN
            DELETE A -- 아예 삭제함
            FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
                    INNER JOIN (
                                    SELECT  *
                                    FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
                                    WHERE   1=1
                                        AND (ASSIGN_PRIORITY = 0 OR VALID_YN <> 'Y')
                                ) B ON
                            A.DIVISION_ID		= B.DIVISION_ID
                        AND A.COMPANY_ID		= B.COMPANY_ID
                        AND A.SITE_ID			= B.SITE_ID
                        AND A.PLANT_ID			= B.PLANT_ID
                        AND A.FACTORY_ID		= B.FACTORY_ID
                        AND A.LINE_ID			= B.LINE_ID
                        AND A.OPERATION_ID		= B.OPERATION_ID
                        AND A.MDL_NM			= B.ITEM_ID
                        AND A.YYYYMM			= B.YYYYMM
        END

--            SELECT  A.* -- 아예 삭제함
--            FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--                    INNER JOIN (
--                                    SELECT  *
--                                    FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
--                                    WHERE   1=1
--                                        AND (ASSIGN_PRIORITY = 0 OR VALID_YN <> 'Y')
--                                ) B ON
--                            A.DIVISION_ID		= B.DIVISION_ID
--                        AND A.COMPANY_ID		= B.COMPANY_ID
--                        AND A.SITE_ID			= B.SITE_ID
--                        AND A.PLANT_ID			= B.PLANT_ID
--                        AND A.FACTORY_ID		= B.FACTORY_ID
--                        AND A.LINE_ID			= B.LINE_ID
--                        AND A.OPERATION_ID		= B.OPERATION_ID
--                        AND A.MDL_NM			= B.ITEM_ID
--                        AND A.YYYYMM			= B.YYYYMM
--ROLLBACK TRAN;RETURN;


--TESTING : NOK
--select * from SCP_MST_CAPA_ELTR_SPEED_PLAN;rollback tran;return;
--SELECT  A.*
--FROM    SCP_MST_CAPA_ELTR_SPEED_PLAN A
--        INNER JOIN @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
--		A.DIVISION_ID		= B.DIVISION_ID
--	AND A.COMPANY_ID		= B.COMPANY_ID
--	AND A.SITE_ID			= B.SITE_ID
--	AND A.PLANT_ID			= B.PLANT_ID
--	AND A.FACTORY_ID		= B.FACTORY_ID
--	AND A.LINE_ID			= B.LINE_ID
--	AND A.OPERATION_ID		= B.OPERATION_ID
--	----AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
--	AND A.ITEM_ID           = B.ITEM_ID
--	AND A.YYYYMM            = B.YYYYMM
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
				  ISNULL(ERROR_PROCEDURE(), 'SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ELTR')
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

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + CONCAT('[ERROR LINE : ', ERROR_PROCEDURE(), ' - ', ERROR_LINE(), ']') + ERROR_MESSAGE();

	END CATCH;


    BEGIN -- 커서 해제 & 임시테이블 삭제------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	    IF OBJECT_ID('tempdb..#tblSCP0105_EQPUIPMENT') IS NOT NULL
			DROP TABLE #tblSCP0105_EQPUIPMENT;
	    IF OBJECT_ID('tempdb..#tblSCP0105_EQPUIPMENT_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0105_EQPUIPMENT_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE_KEY') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_BASE_KEY;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE_QTY') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_BASE_QTY;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_BASE_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_MEASURE') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_MEASURE;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_MEASURE_QTY') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_MEASURE_QTY;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RAW1') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_RAW1;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RAW') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_RAW;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RAW_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_RAW_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RESULT_QTY') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_RESULT_QTY;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RESULT_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_RESULT_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0105_NOT_VALID') IS NOT NULL
			DROP TABLE #tblSCP0105_NOT_VALID;
    END

END

