
/*
 * Program ID   : PR_DM_PLN_DEMANDID_PEGGING
 * Description  : Demand ID 생성으로 FCST 변경이력추적 및 원인을 파악하기 위해서
 * Program History
 *===================================================================================================
 *   Date           In Charge      Description
 *===================================================================================================
 * 2018. 04. 06     JHBAEK         DEMAND ID PEGGING을 위해 미래데이터 생성 로직
 *
 *

	PR_DM_PLN_DEMANDID_DATA_INIT '81'
	PR_DM_PLN_DEMANDID_DATA_INIT '82'

	PRIMARY KEY 제약 조건 'PK_DM_PLN_DEMANDID_PEGGING'을(를) 위반했습니다. 개체 'dbo.DM_PLN_DEMANDID_PEGGING'에 중복 키를 삽입할 수 없습니다. 중복 키 값은 (81, 20180115_00001_00, MF_W_20180403_V001)입니다.

	SELECT * FROM DM_PLN_DEMANDID_PEGGING


	--DELETE FROM DM_PLN_DEMANDID_PEGGING
 */



CREATE PROCEDURE [dbo].[PR_DM_PLN_DEMANDID_DATA_INIT]
   @p_division_id				NVARCHAR(60)
AS  

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	/*  000 **********************************************************************************
		DECLARATION
		****************************************************************************************
	*/
	-- CURSOR RETURN VALUE
	DECLARE	@v_division_id				NVARCHAR(60)
	DECLARE @v_version_no				NVARCHAR(100)
	DECLARE @v_bf_week					NVARCHAR(08)				-- 전주차정보
	DECLARE @v_work_week				NVARCHAR(08)				-- 작업주차정보

	---- LOG 용 변수 설정
    DECLARE @v_program_name				NVARCHAR(150) = 'PR_DM_PLN_DEMANDID_PEGGING';
    DECLARE @v_log_type					NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);
    DECLARE @d_event_date				DATETIME;

	/*
		-----------------------------------------------------------------------------------------
			: START LOG
		-----------------------------------------------------------------------------------------
	*/
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN

	BEGIN TRY
		SET @v_division_id = @p_division_id

		SELECT	@v_work_week = ISO_YYYYWW
		  FROM  SCM_SYS_CALENDAR_M WITH(NOLOCK)
		 WHERE	BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)	
	 
		SELECT	@v_bf_week = ISO_YYYYWW
		  FROM  SCM_SYS_CALENDAR_M WITH(NOLOCK)
		 WHERE	BASIS_YYYYMMDD = CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 

		SELECT @v_version_no = [VERSION_NO]							-- 당주 CUTOFF 자료 중 MAX VERSION
		FROM (
				SELECT	DIVISION_ID				,
						VERSION_NO				,
						VERSION_DESCRIPTION		,
						VERSION_TYPE			,
						YYYYMMDD				,
						VER_CRE_SEQ				,
						ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, CONVERT(CHAR(8), DATEADD(WW, -1, DBO.FN_NEXT_DAY(CAST( YYYYMMDD AS DATETIME), 'MON')), 112) ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC ) SEQ
					FROM  [DM_MST_VERSION] WITH(NOLOCK)
					WHERE	VERSION_TYPE = 'MF_W'
					AND  YYYYMMDD    >= CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 당주 월요일
					AND  YYYYMMDD    <  CONVERT(VARCHAR(08), DATEADD(WW, 0, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 차주 월요일
					AND DIVISION_ID  LIKE '%' + @p_division_id + '%'																	-- ★★★
				) AL
		WHERE AL.SEQ = 1

		-- DELETE를 먼저하고
		DELETE
		FROM	DM_PLN_DEMANDID_PEGGING
		WHERE	MEASURE			= 'MKT_FCST'
		AND		VERSION_NO		= @v_version_no
		AND		DIVISION_ID		= @v_division_id
		AND		YYYYMMDD BETWEEN CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) AND CONVERT(CHAR(8), DATEADD(DD, 7*11, DBO.FN_NEXT_DAY(GETDATE(), 'SUN')), 112)

		--------------------------------------------------------------------------------------------------------------------------------
		-- W1
		INSERT INTO DM_PLN_DEMANDID_PEGGING (
					[DIVISION_ID]
					,[DEMAND_ID]
					,[VERSION_NO]
					,[M_DEMAND_ID]
					,[M_VERSION_NO]
					,[CHANGE_DATE]
					,[DEMAND_CHANGE_TYPE]
					,[PROJECT_CODE]
					,[SCM_SITE_ID]
					,[ITEM_ID]
					,[DOM_EXP]
					,[FCST_TYPE]
					,[INCOTERMS]
					,[MEASURE]
					,[PLANT_SITE_ID]
					,[YYYYMMDD]
					,[M_YYYYMMDD]
					,[CHANGE_REASON]
					,[CREATION_WEEK]
					,[QTY]
					,[CREATED_BY]
					,[CREATION_DATE]
					,[LAST_UPDATED_BY]
					,[LAST_UPDATE_DATE] 
					)
		SELECT	     A.[DIVISION_ID]
					,A.[DEMAND_ID]
					,@v_version_no
					,A.[DEMAND_ID]
					,@v_version_no
					,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
					,'NEW'										-- NEW, CARRY_OVER, MOVE, INC, DEC, DEL
					,A.[PROJECT_CODE]
					,A.[SCM_SITE_ID]
					,A.[ITEM_ID]
					,A.[DOM_EXP]
					,A.FCST_TYPE
					,A.[INCOTERMS]
					,A.[MEASURE]
					,A.[PLANT_SITE_ID]
					,A.[YYYYMMDD]
					,A.[YYYYMMDD]												-- [2018-03-28][모 YYYYMMDD]
					,''
					,@v_work_week												-- [2018-03-30][추가][작업주차정보]
					,A.[QTY]
					,'SYSTEM'
					,GETDATE()
					,'SYSTEM'
					,GETDATE()
		  FROM
				(
				-- W1
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-11, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, -7*0, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				 UNION
				-- W2
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-10, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*0, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*1, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				 UNION
				-- W3
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-9, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*1, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*2, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				UNION
				-- W4
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-8, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*3, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				UNION
				-- W5
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-7, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*3, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*4, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				UNION
				-- W6
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-6, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*4, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*5, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				UNION
				-- W7
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-5, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*5, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*6, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				UNION
				-- W8
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-4, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*6, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*7, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				UNION
				-- W9
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-3, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*8, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				UNION
				-- W10
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-2, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*8, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*9, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				UNION
				-- W11
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-1, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*9, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*10, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				UNION
				-- W12
				select	CONVERT( VARCHAR(08), dateadd ( dd, 7*-0, cast( CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) as datetime) ), 112) + '_' + 
						RIGHT('00000' + CONVERT(VARCHAR(20), row_number() over ( partition by division_id order by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, yyyymmdd)), 5) + '_00' AS DEMAND_ID, 
						*
				  from dm_pln_mkt_fcst_c WITH(NOLOCK)
				 where measure		= 'MKT_FCST'
				   and version_no	= @v_version_no
				   and division_id	= @p_division_id
				   and yyyymmdd between CONVERT(CHAR(8), DATEADD(DD, 7*10, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) and CONVERT(CHAR(8), DATEADD(DD, 7*11, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)
				) A
			WHERE A.[QTY] > 0

		COMMIT TRAN ;	

	END TRY

	-- ERROR
	BEGIN CATCH
		ROLLBACK TRAN ;

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT ERROR_MESSAGE()

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END CATCH

	SET NOCOUNT OFF;

	/*
		-----------------------------------------------------------------------------------------
			: END LOG
		-----------------------------------------------------------------------------------------
	*/

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END

