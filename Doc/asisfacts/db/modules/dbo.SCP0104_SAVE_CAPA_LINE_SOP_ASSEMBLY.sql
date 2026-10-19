
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY
 * Description  : CAPA LINE SOP
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/26   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2025/02/10   mrchois      V1.1.11               PJ20249346  LGES SCP 개선과제 이행	 - Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
*/

--CREATE PROCEDURE [dbo].[SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY]
	  @p_version			    NVARCHAR(10)
	, @p_version_seq		    TINYINT
	, @p_division_id		    NVARCHAR(MAX)
	, @p_company_id			    NVARCHAR(MAX)
	, @p_site_id			    NVARCHAR(MAX)
	, @p_plant_id			    NVARCHAR(MAX)
	, @p_factory_id			    NVARCHAR(MAX)
	, @p_line_id			    NVARCHAR(MAX)
	, @p_operation_id		    NVARCHAR(MAX)
	, @p_electrode_type		    NVARCHAR(MAX)
	, @p_valid_yn			    NVARCHAR(MAX)
	, @p_sop_dt  			    NVARCHAR(MAX)
	, @p_program_id			    NVARCHAR(100)
	, @p_sheet_name			    NVARCHAR(100)
	, @p_user_id			    NVARCHAR(30)
	, @debug_mode			    NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_version				NVARCHAR(30)			= N'202408';
	--DECLARE @p_version_seq		    TINYINT					= 12;
	--DECLARE @p_division_id		    NVARCHAR(MAX)			= N'81^81^';
	--DECLARE @p_company_id			NVARCHAR(MAX)			= N'G480^G480^';
	--DECLARE @p_site_id			    NVARCHAR(MAX)			= N'A004^A004^';
	--DECLARE @p_plant_id			    NVARCHAR(MAX)			= N'G481^G481^';
	--DECLARE @p_factory_id			NVARCHAR(MAX)			= N'A7^A7^';
	--DECLARE @p_line_id			    NVARCHAR(MAX)			= N'A7A21^A7A21^';
	--DECLARE @p_operation_id		    NVARCHAR(MAX)			= N'A5000^A5000^';
	--DECLARE @p_electrode_type		NVARCHAR(MAX)			= N'Anode^Cathode^';
	--DECLARE @p_valid_yn			    NVARCHAR(MAX)			= N'Y^Y^';
	--DECLARE @p_sop_dt  			    NVARCHAR(MAX)			= N'20291230^20291230^';
	--DECLARE @p_program_id		    NVARCHAR(100)			= N'SCP0104';
	--DECLARE @p_sheet_name		    NVARCHAR(100)			= N'ASSEMBLY';
 --   DECLARE @p_user_id			    NVARCHAR(30)			= N'iamarock';
 --   DECLARE @debug_mode			    NVARCHAR(1)				= N'F';

	
	DECLARE @test_mode                          NVARCHAR(20)		= N'F';
	--DECLARE @test_mode                          NVARCHAR(20)	= N'T';

	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY';
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


        BEGIN --String_Split 함수 속도이슈로 임시 테이블로 저장함 -------------------------------------------------------------------

		    IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP') IS NOT NULL
			    DROP TABLE #T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP;

			--빈테이블 만들기
            SELECT    @p_version                                       AS VER_ID
                    , @p_version_seq                                   AS VER_SEQ
					, CONVERT(NVARCHAR(30), NULL)                      AS DIVISION_ID
                    , CONVERT(NVARCHAR(30), NULL)                      AS COMPANY_ID
                    , CONVERT(NVARCHAR(30), NULL)                      AS SITE_ID
                    , CONVERT(NVARCHAR(30), NULL)                      AS PLANT_ID
                    , CONVERT(NVARCHAR(30), NULL)                      AS FACTORY_ID
                    , CONVERT(NVARCHAR(30), NULL)                      AS LINE_ID
                    , CONVERT(NVARCHAR(30), NULL)                      AS OPERATION_ID
                    , CONVERT(NVARCHAR(30), NULL)                      AS ELTR_LN_TP_CD
                    , CONVERT(NVARCHAR(30), NULL)                      AS VALID_YN
                    , CONVERT(NVARCHAR(30), NULL)                      AS SOP_DT
					, @p_user_id                                       AS CREATED_BY
					, SYSDATETIME()                                    AS CREATION_DATE
                    , @p_user_id                                       AS LAST_UPDATED_BY
                    , SYSDATETIME()                                    AS LAST_UPDATE_DATE
			INTO    #T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP
            WHERE   1<>1;


			WITH DIVISION AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_division_id,			'^')
			)
			,
			COMPANY AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_company_id,				'^')
			)
			,
			SITE AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_site_id,				'^')
			)
			,
			PLANT AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_plant_id,				'^')
			)
			,
			FACTORY AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_factory_id,				'^')
			)
			,
			LINE AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_line_id,				'^')
			)
			,
			OPERATION AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_operation_id,			'^')
			)
			,
			ELECTRODE_TYPE AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_electrode_type,			'^')
			)
			,
			VALID AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_valid_yn,				'^')
			)
			,
			SOP_DT AS
			(
				SELECT	  NR
						, TOKEN
				FROM	dbo.String_Split(@p_sop_dt,				'^')
			)
			    INSERT INTO #T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP
                SELECT    @p_version                                       AS VER_ID
                        , @p_version_seq                                   AS VER_SEQ
					    , D.TOKEN                                          AS DIVISION_ID
                        , C.TOKEN                                          AS COMPANY_ID
                        , S.TOKEN                                          AS SITE_ID
                        , P.TOKEN                                          AS PLANT_ID
                        , F.TOKEN                                          AS FACTORY_ID
                        , L.TOKEN                                          AS LINE_ID
                        , O.TOKEN                                          AS OPERATION_ID
                        , E.TOKEN                                          AS ELTR_LN_TP_CD
                        , V.TOKEN                                          AS VALID_YN
                        , X.TOKEN                                          AS SOP_DT
					    , @p_user_id                                       AS CREATED_BY
					    , SYSDATETIME()                                    AS CREATION_DATE
                        , @p_user_id                                       AS LAST_UPDATED_BY
                        , SYSDATETIME()                                    AS LAST_UPDATE_DATE
			    FROM    DIVISION  D
                        JOIN COMPANY			C ON D.NR = C.NR
                        JOIN SITE				S ON D.NR = S.NR
                        JOIN PLANT				P ON D.NR = P.NR
                        JOIN FACTORY			F ON D.NR = F.NR
                        JOIN LINE				L ON D.NR = L.NR
                        JOIN OPERATION			O ON D.NR = O.NR
                        JOIN ELECTRODE_TYPE		E ON D.NR = E.NR
                        JOIN VALID				V ON D.NR = V.NR
                        JOIN SOP_DT				X ON D.NR = X.NR

			PRINT CONCAT('ELAPSED_TIME-#T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP;rollback tran;return;
--select * from #T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP;rollback tran;return;
        END --String_Split 함수 속도이슈로 임시 테이블로 저장함 -------------------------------------------------------------------


		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_LINE_SOP') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_LINE_SOP;

		--빈테이블 만들기
		SELECT	  CONVERT(NVARCHAR(10), NULL)		AS VER_ID
				, CONVERT(TINYINT,		NULL)		AS VER_SEQ
				, DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, VALID_YN
				, SOP_DT
				, SOP_YM
				, SUBSTRING(SOP_YM, 1, 4)       AS SOP_YEAR
				, SOP_DDN                       AS SOP_DDN
				, SOP_DDN                       AS BASE_DDN
				, SOP_DDN                       AS SOP_DDN_YEAR
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
		INTO	#T_SCP0104_SCP_MST_CAPA_LINE_SOP
		FROM	SCP_MST_CAPA_LINE_SOP WITH(NOLOCK)
		WHERE	1<>1;


		INSERT INTO #T_SCP0104_SCP_MST_CAPA_LINE_SOP
		SELECT	  VER_ID
				, VER_SEQ
				, DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, VALID_YN
				, SOP_DT
                , SUBSTRING(SOP_DT, 1, 6)  AS SOP_YM
                , SUBSTRING(SOP_DT, 1, 4)  AS SOP_YEAR
                , CASE
                    WHEN LEN(SOP_DT) = 8 THEN 
                        DAY(EOMONTH(CONVERT(DATETIME, SUBSTRING(SOP_DT, 1, 6) + '01', 112))) - CONVERT(INT, SUBSTRING(SOP_DT, 7, 2)) + 1
                    ELSE NULL
                  END                                                                                                           AS SOP_DDN
                , DAY(EOMONTH(CONVERT(DATETIME, @p_version + '01', 112))) - DAY(CONVERT(DATETIME, @p_version + '01', 112)) + 1  AS BASE_DDN
                , DATEDIFF(DAY, SOP_DT, SUBSTRING(SOP_DT, 1, 4) + '1231') + 1                                                   AS SOP_DDN_YEAR
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
		FROM	#T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP
        WHERE   1=1
            AND ISNULL(DIVISION_ID, '') <> ''
            AND ISNULL(COMPANY_ID, '') <> ''
            AND ISNULL(SITE_ID, '') <> ''
            AND ISNULL(PLANT_ID, '') <> ''
            AND ISNULL(FACTORY_ID, '') <> ''
            AND ISNULL(LINE_ID, '') <> ''
            AND ISNULL(OPERATION_ID, '') <> ''
            AND ISNULL(ELTR_LN_TP_CD, '') <> ''

--TESTING : NOK
--select * from #T_SCP0104_SCP_MST_CAPA_LINE_SOP;rollback tran; return;


		DECLARE @v_all_cnt		        INTEGER		= 0;

        SELECT  @v_all_cnt = COUNT(*)
        FROM    #T_SCP0104_SCP_MST_CAPA_LINE_SOP;


    	PRINT 'SAVE - SCP_MST_CAPA_LINE_SOP - BEGIN';
		MERGE INTO SCP_MST_CAPA_LINE_SOP A
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
				    , VALID_YN
				    , SOP_DT
				    , SOP_YM
				    , SOP_DDN
					, @p_user_id				            AS CREATED_BY
					, SYSDATETIME()				            AS CREATION_DATE
					, @p_user_id				            AS LAST_UPDATED_BY
					, SYSDATETIME()				            AS LAST_UPDATE_DATE
            FROM    #T_SCP0104_SCP_MST_CAPA_LINE_SOP A
		) B ON
		(
				A.DIVISION_ID		= B.DIVISION_ID
			AND A.COMPANY_ID		= B.COMPANY_ID
			AND A.SITE_ID			= B.SITE_ID
			AND A.PLANT_ID			= B.PLANT_ID
			AND A.FACTORY_ID		= B.FACTORY_ID
			AND A.LINE_ID			= B.LINE_ID
			AND A.OPERATION_ID		= B.OPERATION_ID
			AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
		)
		WHEN MATCHED THEN
		UPDATE
		SET
			  VALID_YN				= B.VALID_YN
			, SOP_DT		        = B.SOP_DT
			, SOP_YM		        = B.SOP_YM
			, SOP_DDN		        = B.SOP_DDN
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
			, VALID_YN
			, SOP_DT
			, SOP_YM
			, SOP_DDN
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
			, B.VALID_YN
			, B.SOP_DT
			, B.SOP_YM
			, B.SOP_DDN
			, B.CREATED_BY
			, B.CREATION_DATE
			, B.LAST_UPDATED_BY
			, B.LAST_UPDATE_DATE
		);
    	PRINT 'SAVE - SCP_MST_CAPA_LINE_SOP - END';

--TESTING : NOK
--SELECT  A.*
--FROM    SCP_MST_CAPA_LINE_SOP A
--        INNER JOIN #T_SCP0104_SCP_MST_CAPA_LINE_SOP B ON
--				A.DIVISION_ID		= B.DIVISION_ID
--			AND A.COMPANY_ID		= B.COMPANY_ID
--			AND A.SITE_ID			= B.SITE_ID
--			AND A.PLANT_ID			= B.PLANT_ID
--			AND A.FACTORY_ID		= B.FACTORY_ID
--			AND A.LINE_ID			= B.LINE_ID
--			AND A.OPERATION_ID		= B.OPERATION_ID
--			AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
--WHERE   1=1
--;rollback tran;return;


        DECLARE @v_updated_cnt  INT = 0;

        SELECT  @v_updated_cnt  = COUNT(*)
        FROM    #T_SCP0104_SCP_MST_CAPA_LINE_SOP;

        PRINT CONCAT('@v_updated_cnt : ', @v_updated_cnt);
--rollback tran;return;


        IF @v_updated_cnt > 0
        BEGIN
		    IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_LOSS') IS NOT NULL
			    DROP TABLE #T_SCP0104_SCP_MST_CAPA_LOSS;

            SELECT    DIVISION_ID
                    , PLANT_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , MDL_NM
                    , COMPANY_ID
                    , SITE_ID
                    , FACTORY_ID
                    , MSR_TP_CD
                    , YYYYMM
                    , PFRSLT_NVL
                    , BASE_NVL
                    --, IPRV_GOL_DIVS_CD
                    --, IPRV_GOL_RT			-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois)
                    , MSR_GR_CD
                    , MSR_NVL
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE
            INTO    #T_SCP0104_SCP_MST_CAPA_LOSS
            FROM    SCP_MST_CAPA_LOSS_PLAN_MDL WITH(NOLOCK)
            WHERE   1<>1


            ;WITH tblSopKey AS
            (
                SELECT    DIVISION_ID
				        , COMPANY_ID
				        , SITE_ID
				        , PLANT_ID
				        , FACTORY_ID
				        , LINE_ID
				        , OPERATION_ID
				        , ELTR_LN_TP_CD
                FROM    #T_SCP0104_SCP_MST_CAPA_LINE_SOP
                GROUP BY  DIVISION_ID
				        , COMPANY_ID
				        , SITE_ID
				        , PLANT_ID
				        , FACTORY_ID
				        , LINE_ID
				        , OPERATION_ID
				        , ELTR_LN_TP_CD
            )
            ,
            ----tblAssign AS
            ----(
            ----    SELECT  A.*
            ----    FROM    SCP_MST_CAPA_LINE_ASSIGN A WITH(NOLOCK)
            ----            INNER JOIN tblSopKey B ON
            ----                    A.DIVISION_ID     = B.DIVISION_ID
				        ----    AND A.COMPANY_ID      = B.COMPANY_ID
				        ----    AND A.SITE_ID         = B.SITE_ID
				        ----    AND A.PLANT_ID        = B.PLANT_ID
				        ----    AND A.FACTORY_ID      = B.FACTORY_ID
				        ----    AND A.LINE_ID         = B.LINE_ID
				        ----    AND A.OPERATION_ID    = B.OPERATION_ID
				        ----    AND A.ELTR_LN_TP_CD   = B.ELTR_LN_TP_CD
            ----    WHERE   1=1
            ----        AND ISNULL(A.ASSIGN_PRIORITY, 0) > 0
            ----        AND A.VALID_YN = 'Y'
            ----)
            ----,
            tblSpeed_EQP_NBU AS
            (
                SELECT  *
                FROM    SCP_MST_CAPA_SPEED_PLAN WITH(NOLOCK)
                WHERE   1=1
                    AND MSR_TP_CD = 'EQP_NBU'
            )
            ,
            tblSpeed_PPM AS
            (
                SELECT  *
                FROM    SCP_MST_CAPA_SPEED_PLAN WITH(NOLOCK)
                WHERE   1=1
                    AND MSR_TP_CD = 'PPM'
            )
            ,
            tblLossRawAll AS
            (
				SELECT	A.*
				FROM	SCP_MST_CAPA_LOSS_PLAN_MDL A
                        INNER JOIN tblSopKey B ON
                                A.DIVISION_ID     = B.DIVISION_ID
				            AND A.COMPANY_ID      = B.COMPANY_ID
				            AND A.SITE_ID         = B.SITE_ID
				            AND A.PLANT_ID        = B.PLANT_ID
				            AND A.FACTORY_ID      = B.FACTORY_ID
				            AND A.LINE_ID         = B.LINE_ID
				            AND A.OPERATION_ID    = B.OPERATION_ID
				            AND A.ELTR_LN_TP_CD   = B.ELTR_LN_TP_CD
                WHERE   1=1
					AND MSR_TP_CD IN('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT', 'THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')
            )
            ,
            tblLoss_LD_RT AS
			(
				SELECT	*
				FROM	tblLossRawAll
				WHERE	1=1
					AND MSR_TP_CD = 'LD_RT'
			)
            ,
            tblLoss_OP_RT AS
			(
				SELECT	*
				FROM	tblLossRawAll
				WHERE	1=1
					AND MSR_TP_CD = 'OP_RT'
			)
            ,
            tblLoss_PF_RT AS
			(
				SELECT	*
				FROM	tblLossRawAll
				WHERE	1=1
					AND MSR_TP_CD = 'PF_RT'
			)
            ,
            tblLoss_QL_RT AS
			(
				SELECT	*
				FROM	tblLossRawAll
				WHERE	1=1
					AND MSR_TP_CD = 'QL_RT'
			)
            ,
            tblLossRawDDN AS
            (
                SELECT    A.DIVISION_ID
                        , A.PLANT_ID
                        , A.LINE_ID
                        , A.OPERATION_ID
                        , A.ELTR_LN_TP_CD
                        , A.MDL_NM
                        , A.COMPANY_ID
                        , A.SITE_ID
                        , A.FACTORY_ID
                        , A.MSR_TP_CD
                        , A.YYYYMM
                        , A.PFRSLT_NVL
                        , A.BASE_NVL
                        --, A.IPRV_GOL_DIVS_CD
                        --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois)
                        , A.MSR_GR_CD
                        , A.MSR_NVL
                        , A.CREATED_BY
                        , A.CREATION_DATE
                        , A.LAST_UPDATED_BY
                        , A.LAST_UPDATE_DATE
				        , CASE
                            WHEN B.DIVISION_ID IS NOT NULL THEN B.SOP_DT ELSE C.SOP_DT
                          END                                                                                               AS SOP_DT
				        , CASE
                            WHEN B.DIVISION_ID IS NOT NULL THEN B.SOP_YM
                            ELSE A.YYYYMM
                          END                                                                                               AS SOP_YM
				        , CASE
                            WHEN B.DIVISION_ID IS NOT NULL THEN B.SOP_YEAR
                            ELSE SUBSTRING(A.YYYYMM, 1, 4)
                          END                                                                                               AS SOP_YEAR
				        , CASE
                            WHEN LEN(A.YYYYMM) = 4 THEN                                                                             --연도별 
                                CASE
                                    WHEN C.DIVISION_ID IS NOT NULL THEN C.SOP_DDN_YEAR
                                    ELSE DATEDIFF(DAY, SUBSTRING(A.YYYYMM, 1, 4) + '0101', SUBSTRING(A.YYYYMM, 1, 4) + '1231') + 1  -- SOP 없을때
                                END
                            ELSE                                                                                                    -- 월별
                                CASE
                                    WHEN B.DIVISION_ID IS NOT NULL THEN B.SOP_DDN
                                    ELSE DAY(EOMONTH(CONVERT(DATE, A.YYYYMM + '01')))                                                -- SOP 없을때
                                END
                          END                                                                                               AS SOP_DDN
				        , CASE
                            WHEN LEN(A.YYYYMM) = 4 THEN                                                                                 --연도별 
                                CASE
                                    WHEN C.DIVISION_ID IS NOT NULL THEN C.BASE_DDN
                                    ELSE DATEDIFF(DAY, SUBSTRING(@p_version, 1, 4) + '0101', SUBSTRING(@p_version, 1, 4) + '1231') + 1  -- SOP 없을때
                                END
                            ELSE                                                                                                        -- 월별
                                CASE
                                    WHEN B.DIVISION_ID IS NOT NULL THEN B.BASE_DDN
                                    ELSE DAY(EOMONTH(CONVERT(DATE, @p_version + '01')))                                                 -- SOP 없을때
                                END
                          END                                                                                               AS BASE_DDN
                        , SE.BASE_QTY                                                                                       AS BASE_EQP_NBU
                        , SE.QTY                                                                                            AS EQP_NBU
                        , SP.BASE_QTY                                                                                       AS BASE_PPM
                        , SP.QTY                                                                                            AS PPM
                        , LL.BASE_NVL                                                                                       AS BASE_LD_RT
                        , LL.MSR_NVL                                                                                        AS LD_RT
                        , LO.BASE_NVL                                                                                       AS BASE_OP_RT
                        , LO.MSR_NVL                                                                                        AS OP_RT
                        , LP.BASE_NVL                                                                                       AS BASE_PF_RT
                        , LP.MSR_NVL                                                                                        AS PF_RT
                        , LQ.BASE_NVL                                                                                       AS BASE_QL_RT
                        , LQ.MSR_NVL                                                                                        AS QL_RT
                        , (SP.BASE_QTY * 1440.0)                                                                            AS BASE_THRY_CAPA_D
                        , (SP.QTY * 1440.0)                                                                                 AS THRY_CAPA_D
                        , (LL.BASE_NVL * LO.BASE_NVL  * LP.BASE_NVL  * LQ.BASE_NVL)			                                AS TEMP_BASE_PROD_CAPA_D
                        , (LL.MSR_NVL * LO.MSR_NVL  * LP.MSR_NVL  * LQ.MSR_NVL)			                                    AS TEMP_PROD_CAPA_D
                FROM    tblLossRawAll A
                        LEFT JOIN #T_SCP0104_SCP_MST_CAPA_LINE_SOP B ON
				                A.DIVISION_ID		= B.DIVISION_ID
			                AND A.COMPANY_ID		= B.COMPANY_ID
			                AND A.SITE_ID			= B.SITE_ID
			                AND A.PLANT_ID			= B.PLANT_ID
			                AND A.FACTORY_ID		= B.FACTORY_ID
			                AND A.LINE_ID			= B.LINE_ID
			                AND A.OPERATION_ID		= B.OPERATION_ID
			                AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
                            AND A.YYYYMM            = B.SOP_YM
                        LEFT JOIN #T_SCP0104_SCP_MST_CAPA_LINE_SOP C ON
				                A.DIVISION_ID		= C.DIVISION_ID
			                AND A.COMPANY_ID		= C.COMPANY_ID
			                AND A.SITE_ID			= C.SITE_ID
			                AND A.PLANT_ID			= C.PLANT_ID
			                AND A.FACTORY_ID		= C.FACTORY_ID
			                AND A.LINE_ID			= C.LINE_ID
			                AND A.OPERATION_ID		= C.OPERATION_ID
			                AND A.ELTR_LN_TP_CD	    = C.ELTR_LN_TP_CD
                            AND A.YYYYMM            = C.SOP_YEAR
                        LEFT JOIN tblSpeed_EQP_NBU SE ON
				                A.DIVISION_ID		= SE.DIVISION_ID
			                AND A.COMPANY_ID		= SE.COMPANY_ID
			                AND A.SITE_ID			= SE.SITE_ID
			                AND A.PLANT_ID			= SE.PLANT_ID
			                AND A.FACTORY_ID		= SE.FACTORY_ID
			                AND A.LINE_ID			= SE.LINE_ID
			                AND A.OPERATION_ID		= SE.OPERATION_ID
			                AND A.ELTR_LN_TP_CD	    = SE.ELTR_LN_TP_CD
			                AND A.MDL_NM	        = SE.NICK_NAME
                            AND A.YYYYMM            = SE.YYYYMM
                        LEFT JOIN tblSpeed_PPM SP ON
				                A.DIVISION_ID		= SP.DIVISION_ID
			                AND A.COMPANY_ID		= SP.COMPANY_ID
			                AND A.SITE_ID			= SP.SITE_ID
			                AND A.PLANT_ID			= SP.PLANT_ID
			                AND A.FACTORY_ID		= SP.FACTORY_ID
			                AND A.LINE_ID			= SP.LINE_ID
			                AND A.OPERATION_ID		= SP.OPERATION_ID
			                AND A.ELTR_LN_TP_CD	    = SP.ELTR_LN_TP_CD
			                AND A.MDL_NM	        = SP.NICK_NAME
                            AND A.YYYYMM            = SP.YYYYMM
                        LEFT JOIN tblLoss_LD_RT LL ON
				                A.DIVISION_ID		= LL.DIVISION_ID
			                AND A.COMPANY_ID		= LL.COMPANY_ID
			                AND A.SITE_ID			= LL.SITE_ID
			                AND A.PLANT_ID			= LL.PLANT_ID
			                AND A.FACTORY_ID		= LL.FACTORY_ID
			                AND A.LINE_ID			= LL.LINE_ID
			                AND A.OPERATION_ID		= LL.OPERATION_ID
			                AND A.ELTR_LN_TP_CD	    = LL.ELTR_LN_TP_CD
			                AND A.MDL_NM	        = LL.MDL_NM
                            AND A.YYYYMM            = LL.YYYYMM
                        LEFT JOIN tblLoss_OP_RT LO ON
				                A.DIVISION_ID		= LO.DIVISION_ID
			                AND A.COMPANY_ID		= LO.COMPANY_ID
			                AND A.SITE_ID			= LO.SITE_ID
			                AND A.PLANT_ID			= LO.PLANT_ID
			                AND A.FACTORY_ID		= LO.FACTORY_ID
			                AND A.LINE_ID			= LO.LINE_ID
			                AND A.OPERATION_ID		= LO.OPERATION_ID
			                AND A.ELTR_LN_TP_CD	    = LO.ELTR_LN_TP_CD
			                AND A.MDL_NM	        = LO.MDL_NM
                            AND A.YYYYMM            = LO.YYYYMM
                        LEFT JOIN tblLoss_PF_RT LP ON
				                A.DIVISION_ID		= LP.DIVISION_ID
			                AND A.COMPANY_ID		= LP.COMPANY_ID
			                AND A.SITE_ID			= LP.SITE_ID
			                AND A.PLANT_ID			= LP.PLANT_ID
			                AND A.FACTORY_ID		= LP.FACTORY_ID
			                AND A.LINE_ID			= LP.LINE_ID
			                AND A.OPERATION_ID		= LP.OPERATION_ID
			                AND A.ELTR_LN_TP_CD	    = LP.ELTR_LN_TP_CD
			                AND A.MDL_NM	        = LP.MDL_NM
                            AND A.YYYYMM            = LP.YYYYMM
                        LEFT JOIN tblLoss_QL_RT LQ ON
				                A.DIVISION_ID		= LQ.DIVISION_ID
			                AND A.COMPANY_ID		= LQ.COMPANY_ID
			                AND A.SITE_ID			= LQ.SITE_ID
			                AND A.PLANT_ID			= LQ.PLANT_ID
			                AND A.FACTORY_ID		= LQ.FACTORY_ID
			                AND A.LINE_ID			= LQ.LINE_ID
			                AND A.OPERATION_ID		= LQ.OPERATION_ID
			                AND A.ELTR_LN_TP_CD	    = LQ.ELTR_LN_TP_CD
			                AND A.MDL_NM	        = LQ.MDL_NM
                            AND A.YYYYMM            = LQ.YYYYMM
            )
            ,
            tblLossTemp1 AS
            (
                SELECT    A.DIVISION_ID
                        , A.PLANT_ID
                        , A.LINE_ID
                        , A.OPERATION_ID
                        , A.ELTR_LN_TP_CD
                        , A.MDL_NM
                        , A.COMPANY_ID
                        , A.SITE_ID
                        , A.FACTORY_ID
                        , A.MSR_TP_CD
                        , A.YYYYMM
                        , A.PFRSLT_NVL
                        , A.BASE_NVL
                        --, A.IPRV_GOL_DIVS_CD
                        --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois)
                        , A.MSR_GR_CD
                        , A.MSR_NVL
                        , A.CREATED_BY
                        , A.CREATION_DATE
                        , A.LAST_UPDATED_BY
                        , A.LAST_UPDATE_DATE
				        , A.SOP_DT
				        , A.SOP_YM
				        , A.SOP_YEAR
				        , A.SOP_DDN
				        , A.BASE_DDN
                        , A.BASE_EQP_NBU
                        , A.EQP_NBU
                        , A.BASE_PPM
                        , A.PPM
                        , A.BASE_LD_RT
                        , A.LD_RT
                        , A.BASE_OP_RT
                        , A.OP_RT
                        , A.BASE_PF_RT
                        , A.PF_RT
                        , A.BASE_QL_RT
                        , A.QL_RT
                        , A.BASE_THRY_CAPA_D
                        , A.THRY_CAPA_D
                        , A.BASE_THRY_CAPA_D * A.TEMP_BASE_PROD_CAPA_D                  AS BASE_PROD_CAPA_D
                        , A.THRY_CAPA_D * A.TEMP_PROD_CAPA_D                            AS PROD_CAPA_D
                        , A.BASE_THRY_CAPA_D * A.TEMP_BASE_PROD_CAPA_D * BASE_DDN       AS BASE_PROD_CAPA_M
                        , A.THRY_CAPA_D * A.TEMP_PROD_CAPA_D * SOP_DDN                  AS PROD_CAPA_M
                FROM    tblLossRawDDN A
            )
            --SELECT * FROM tblLossTemp1 WHERE YYYYMM = '2029';rollback tran;return;
            ,
            tblLossTemp AS
            (
                SELECT    A.DIVISION_ID
                        , A.PLANT_ID
                        , A.LINE_ID
                        , A.OPERATION_ID
                        , A.ELTR_LN_TP_CD
                        , A.MDL_NM
                        , A.COMPANY_ID
                        , A.SITE_ID
                        , A.FACTORY_ID
                        , A.MSR_TP_CD
                        , A.YYYYMM
                        , A.PFRSLT_NVL
                        , CASE
                            WHEN A.MSR_TP_CD = 'THRY_CAPA_D' THEN A.BASE_THRY_CAPA_D
                            WHEN A.MSR_TP_CD = 'PROD_CAPA_D' THEN A.BASE_PROD_CAPA_D
                            WHEN A.MSR_TP_CD = 'PROD_CAPA_M' THEN A.BASE_PROD_CAPA_M
                          END AS BASE_NVL
                        --, A.IPRV_GOL_DIVS_CD
                        --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois)
                        , A.MSR_GR_CD
                        , CASE
                            WHEN A.MSR_TP_CD = 'THRY_CAPA_D' THEN A.THRY_CAPA_D
                            WHEN A.MSR_TP_CD = 'PROD_CAPA_D' THEN A.PROD_CAPA_D
                            WHEN A.MSR_TP_CD = 'PROD_CAPA_M' THEN A.PROD_CAPA_M
                          END AS MSR_NVL                            
                        , A.CREATED_BY
                        , A.CREATION_DATE
                        , @p_user_id                                       AS LAST_UPDATED_BY
                        , SYSDATETIME()                                    AS LAST_UPDATE_DATE
                FROM    tblLossTemp1 A
                WHERE   1=1
                    AND A.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M')
            )
                INSERT INTO #T_SCP0104_SCP_MST_CAPA_LOSS
                SELECT    A.DIVISION_ID
                        , A.PLANT_ID
                        , A.LINE_ID
                        , A.OPERATION_ID
                        , A.ELTR_LN_TP_CD
                        , A.MDL_NM
                        , A.COMPANY_ID
                        , A.SITE_ID
                        , A.FACTORY_ID
                        , A.MSR_TP_CD
                        , A.YYYYMM
                        , A.PFRSLT_NVL
                        , A.BASE_NVL                            
                        --, A.IPRV_GOL_DIVS_CD
                        --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois)
                        , A.MSR_GR_CD
                        , A.MSR_NVL                            
                        , A.CREATED_BY
                        , A.CREATION_DATE
                        , A.LAST_UPDATED_BY
                        , A.LAST_UPDATE_DATE
                FROM    tblLossTemp A
                WHERE   1=1
                    --AND A.MSR_NVL IS NOT NULL


--TESTING : NOK;
--select * from #T_SCP0104_SCP_MST_CAPA_LOSS_TEMP;
--select  * 
--from    #T_SCP0104_SCP_MST_CAPA_LOSS 
--WHERE   1=1
--    AND YYYYMM = '2029' 
--    AND MSR_TP_CD IN ('PROD_CAPA_M', 'PROD_CAPA_D')
--rollback tran;return;


            BEGIN -- 데이터 저장 - Loss Plan
                PRINT 'SAVE - LOSS_PLAN_BY_ASSIGN - BEGIN';

		        MERGE INTO SCP_MST_CAPA_LOSS_PLAN_MDL A
		        USING
		        (
                    SELECT    A.DIVISION_ID
                            , A.PLANT_ID
                            , A.LINE_ID
                            , A.OPERATION_ID
                            , A.ELTR_LN_TP_CD
                            , A.MDL_NM
                            , A.COMPANY_ID
                            , A.SITE_ID
                            , A.FACTORY_ID
                            , A.MSR_TP_CD
                            , A.YYYYMM
                            , A.PFRSLT_NVL
                            , A.BASE_NVL
                            --, A.IPRV_GOL_DIVS_CD
                            --, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois)
                            , A.MSR_GR_CD
                            , A.MSR_NVL
                            , A.CREATED_BY
                            , A.CREATION_DATE
                            , A.LAST_UPDATED_BY
                            , A.LAST_UPDATE_DATE
                    FROM    #T_SCP0104_SCP_MST_CAPA_LOSS A
		        ) B ON
		        (
				        A.DIVISION_ID		= B.DIVISION_ID
			        AND A.COMPANY_ID		= B.COMPANY_ID
			        AND A.SITE_ID			= B.SITE_ID
			        AND A.PLANT_ID			= B.PLANT_ID
			        AND A.FACTORY_ID		= B.FACTORY_ID
			        AND A.LINE_ID			= B.LINE_ID
			        AND A.OPERATION_ID		= B.OPERATION_ID
			        AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
			        AND A.MDL_NM	        = B.MDL_NM
			        AND A.MSR_TP_CD	        = B.MSR_TP_CD
			        AND A.YYYYMM	        = B.YYYYMM
		        )
		        WHEN MATCHED THEN
		        UPDATE
		        SET
			          ----BASE_NVL		        = B.BASE_NVL
			          MSR_NVL		        = B.MSR_NVL
			        , LAST_UPDATED_BY		= B.LAST_UPDATED_BY
			        , LAST_UPDATE_DATE		= B.LAST_UPDATE_DATE
		        ;


                PRINT 'SAVE - LOSS_PLAN_BY_ASSIGN - END';
--TESTING : NOK;
--select * from SCP_MST_CAPA_LOSS_PLAN_MDL;rollback tran;return;
            END -- 데이터 저장 - Loss Plan
        END
--SELECT  A.*
--FROM    SCP_MST_CAPA_LOSS_PLAN_MDL A WITH(NOLOCK)
--        INNER JOIN #T_SCP0104_SCP_MST_CAPA_LOSS B ON
--				        A.DIVISION_ID		= B.DIVISION_ID
--			        AND A.COMPANY_ID		= B.COMPANY_ID
--			        AND A.SITE_ID			= B.SITE_ID
--			        AND A.PLANT_ID			= B.PLANT_ID
--			        AND A.FACTORY_ID		= B.FACTORY_ID
--			        AND A.LINE_ID			= B.LINE_ID
--			        AND A.OPERATION_ID		= B.OPERATION_ID
--			        AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
--			        AND A.MDL_NM	        = B.MDL_NM
--			        AND A.MSR_TP_CD	        = B.MSR_TP_CD
--			        AND A.YYYYMM	        = B.YYYYMM
--WHERE   1=1
--    AND A.YYYYMM = '2029'
--    AND A.MSR_TP_CD in ('PROD_CAPA_M', 'PROD_CAPA_D')
--rollback tran;return;

        -- LOG end
		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''
		SET @d_event_date   = SYSDATETIME()

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date


		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @v_all_cnt AS result_cnt;
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
				  ISNULL(ERROR_PROCEDURE(), 'SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY')
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
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP;
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_LINE_SOP') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_LINE_SOP;
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_LINE_SOP_TEMP;
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_LINE_SOP') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_LINE_SOP;
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_LOSS_TEMP') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_LOSS_TEMP;
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_LOSS') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_LOSS;
	END
END

