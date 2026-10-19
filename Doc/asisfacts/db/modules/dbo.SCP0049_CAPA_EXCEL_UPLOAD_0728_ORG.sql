

/*
 * Program ID   : SCP0049_CAPA_EXCEL_UPLOAD
 * Description  : SCP0049_CAPA_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2021.01.05	khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2021.03.17	khj79			SCM PI Admin 수정 가능하도록 권한 추가
 * 2021.03.16	khj79			Invalid Line Operation YIELD 제외 추가
 * 2021.03.17	khj79			LANE QTY 변경 ( E3000 , E4000 ) 추가
 * 2021.08.24   khj79			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 이력 저장 및 LINE ASSIGN 삭제(TACT TIME, YIELD 삭제 동기화)

 * EX > Div*	Company*	FromSite*	Material*	yyyyMMdd*	Qty*
 */
 

CREATE PROCEDURE [dbo].[SCP0049_CAPA_EXCEL_UPLOAD_0728_ORG]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)
AS

BEGIN
    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'SCP0049';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'CAPA';
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0049_CAPA_EXCEL_UPLOAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_log_error	NVARCHAR(1000);

	DECLARE @v_std_yyyymmdd	NVARCHAR(8); -- 수정 가능 기준 날짜 설정
	DECLARE @v_std_yyyymm	NVARCHAR(6); -- 수정 가능 기준 날짜 설정
	DECLARE @v_std_yyyy		NVARCHAR(4); -- 수정 가능 기준 날짜 설정

	DECLARE @v_created_by	NVARCHAR(150);

	-- 수정 결과 카운트
	DECLARE @v_mod_cnt	INTEGER = 0;

	/* 기준 일자 설정 */
	SET @v_std_yyyymmdd	= CONVERT(NVARCHAR(8),getdate(),112);  -- 오늘 날짜
	SET @v_std_yyyymm	= CONVERT(NVARCHAR(6),getdate(),112);  -- 해당 월
	SET @v_std_yyyy		= CONVERT(NVARCHAR(4),getdate(),112);  -- 해당 월

	SET @v_log_type = 'START';
     SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	

	SELECT @v_creation_date = CONVERT(NVARCHAR(40), MAX(T.CREATION_DATE), 121)
	FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
	WHERE  T.PROGRAM_ID = @v_program_id
	AND    T.SHEET_NAME = @v_sheet_name
	AND    T.CREATED_BY = @p_created_by;
		 
	IF @v_creation_date IS NULL BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'Data Not Found [' + CONVERT(CHAR(19), @v_creation_date, 121) +']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END;

	-- 사용자 정보 설정
	SET @v_created_by = @p_created_by;

	-- @p_mode = 0 이면 Validation
	IF ISNULL(@p_mode, 0) = 0
	BEGIN
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = 'UPLOAD'
				 , MESSAGE_TEXT       = NULL
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T
			 WHERE T.PROGRAM_ID    = @v_program_id
			   AND T.SHEET_NAME    = @v_sheet_name
			   AND T.CREATED_BY    = @v_created_by
			   AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
			   AND ISNULL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD';

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## RESET Status = UPLOAD ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- ///////////////////////////// VALIDATION CHECK /////////////////////////

		/* ######################################################## */
		/* TITLE 처리												*/
		/* ######################################################## */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = '@TITLE'
			 WHERE PROGRAM_ID    = @v_program_id
			   AND SHEET_NAME    = @v_sheet_name
			   AND CREATED_BY    = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND (UPPER(ATTRIBUTE1) = 'DIV*' OR UPPER(ATTRIBUTE1) = 'DIV' OR UPPER(ATTRIBUTE1) = 'DIVISION') ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## TITLE Header Line ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* 필수 값 NULL 값 체크									*/
		/* ATTRIBUTE6  : Line*									*/
		/* ATTRIBUTE7  : Operation*								*/
		/* ATTRIBUTE8  : Line Type*								*/
		/* ATTRIBUTE10 : Level 1*								*/
		/* ATTRIBUTE11 : Level 2*								*/
		/* ATTRIBUTE12 : Material*								*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE	= 'ERROR'
				 , MESSAGE_TEXT			= CASE WHEN ISNULL(ATTRIBUTE6,'')=''  OR ISNULL(ATTRIBUTE8, '')=''	THEN 'NULL LINE & TYPE Data.' 
				 							   WHEN ISNULL(ATTRIBUTE7, '')=''								THEN 'NULL OPERATION Data.'
				 							   WHEN ISNULL(ATTRIBUTE10,'')=''								THEN 'NULL LEVEL 1 Data.'
				 							   WHEN ATTRIBUTE10 NOT IN ('LINE ASSIGN', 'TACT TIME', 'DAILY CAPA', 'YIELD') AND ISNULL(ATTRIBUTE11,'')=''	
				 							 																THEN 'NULL LEVEL 2(LOSS KEY) Data.'
				 							   WHEN ATTRIBUTE10 IN ('LINE ASSIGN', 'TACT TIME', 'DAILY CAPA', 'YIELD') AND ISNULL(ATTRIBUTE12,'')=''
				 							 																THEN 'NULL ITEM Data.'
										   END
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND (   ISNULL(ATTRIBUTE6,'')='' OR ISNULL(ATTRIBUTE7, '')='' OR ISNULL(ATTRIBUTE8, '')='' OR ISNULL(ATTRIBUTE10,'')='' 
					OR ( ATTRIBUTE10 NOT IN ('LINE ASSIGN', 'TACT TIME', 'DAILY CAPA', 'YIELD') AND ISNULL(ATTRIBUTE11,'')='' )
					OR ( ATTRIBUTE10 IN		('LINE ASSIGN', 'TACT TIME', 'DAILY CAPA', 'YIELD') AND ISNULL(ATTRIBUTE12,'')='' )
					) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## ERROR NULL Column Data ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* LOSS 값 체크											*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Loss Type.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE10 NOT IN ('LINE ASSIGN', 'TACT TIME', 'DAILY CAPA', 'YIELD')
			   AND NOT EXISTS  (  SELECT 1
								    FROM (SELECT   SEGMENT1 AS LOSS_CODE
												 , ATTRIBUTE1 AS LEVEL1
												 , ATTRIBUTE2 AS LEVEL2
										    FROM SCM_SYS_LOOKUP_VALUE_SN 
										   WHERE 1=1
										     AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT') LD
								   WHERE 1=1
								     AND LD.LEVEL1 = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10
								     AND LD.LEVEL2 = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Loss Type ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* LINE 체크												*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Line & Line Type.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE10		 != 'YIELD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_LINE_HIERARCHY_V_SN LH WITH(NOLOCK)
								   WHERE 1 = 1
									 AND LH.LINE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
									 AND LH.ELECTRODE_TYPE	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Line & Line Type. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* LINE 체크		YIELD									*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Line & Line Type. YIELD'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE10		  = 'YIELD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_LINE_HIERARCHY_V_SN LH WITH(NOLOCK)
								   WHERE 1 = 1
									 AND LH.LINE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Line & Line Type. YIELD ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;


		/* #################################################### */
		/* OPERATION_ID 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Line Operation.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE10		 != 'YIELD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_LINE_HIERARCHY_V_SN LH WITH(NOLOCK)
								   WHERE 1 = 1									 
									 AND LH.LINE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
									 AND LH.ELECTRODE_TYPE	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8
									 AND LH.OPERATION_ID	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Line Operation ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* OPERATION_ID 체크		YIELD							*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Line Operation. YIELD'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE10		 = 'YIELD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_LINE_HIERARCHY_V_SN LH WITH(NOLOCK)
								   WHERE 1 = 1									 
									 AND LH.LINE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
									 AND LH.OPERATION_ID	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Line Operation YIELD ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;


		/* #################################################### */
		/* 필수 항목 기준으로 다른 Data Update 					*/
		/* #################################################### */ 
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET ATTRIBUTE1 = B.DIVISION_ID
			   	 , ATTRIBUTE2 = B.COMPANY_ID
			   	 , ATTRIBUTE3 = B.SITE_ID
			   	 , ATTRIBUTE4 = B.PLANT_ID
			   	 , ATTRIBUTE5 = B.FACTORY_ID
			  FROM SCM_ADM_EXCEL_UPLOAD A WITH(NOLOCK),
				   SCM_LINE_HIERARCHY_V_SN B WITH(NOLOCK)
			 WHERE 1 = 1
			   AND A.PROGRAM_ID 		= @v_program_id
			   AND A.SHEET_NAME			= @v_sheet_name
			   AND A.CREATED_BY			= @v_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND A.ATTRIBUTE6 		= B.LINE_ID
			   AND A.ATTRIBUTE7			= B.OPERATION_ID
			   AND A.ATTRIBUTE8			= B.ELECTRODE_TYPE
			  ;
			
			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## LINE HIERACHY UPDATE ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* 권한 체크												*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Auth'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MASTER_MANAGER_M_SN LH WITH(NOLOCK)
								   WHERE 1 = 1
									 AND LH.DIVISION_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
									 AND LH.COMPANY_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
									 AND LH.SITE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
									 AND LH.PLANT_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
									 AND LH.FACTORY_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
									 AND LH.LINE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
									 AND LH.OPERATION_ID	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
									 AND LH.ELECTRODE_TYPE	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8
									 AND LH.LOSS_CODE		= (SELECT SEGMENT1
																 FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
																WHERE 1=1
																  AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
																  AND ACTIVE_FLAG = 'Y' 
																  AND ATTRIBUTE1 = CASE WHEN [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10 = 'DAILY CAPA' THEN 'TACT TIME' ELSE [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10 END 
																  AND ATTRIBUTE2 = CASE WHEN [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10 IN ( 'LINE ASSIGN','TACT TIME','DAILY CAPA','YIELD' ) THEN '-'
																						ELSE [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
																				   END
															  )
									 AND (LH.USER_ID_1 = @v_created_by OR LH.USER_ID_2 = @v_created_by OR LH.USER_ID_3 = @v_created_by OR LH.USER_ID_4 = @v_created_by OR LH.USER_ID_5 = @v_created_by
											OR LH.USER_ID_6 = @v_created_by OR LH.USER_ID_7 = @v_created_by OR LH.USER_ID_8 = @v_created_by OR LH.USER_ID_9 = @v_created_by OR LH.USER_ID_10 = @v_created_by
									 )
									UNION ALL
									SELECT 1
									  FROM TB_FX_USERGROUPINFO WITH(NOLOCK)
									 WHERE USERID = @v_created_by
									   AND USEYN = 'Y'
									   --AND GROUPID = 'SCM PI Admin'
									   AND GROUPID IN ('SCM PI Admin', 'FP Planner', 'SCP Planner') -- FP Planner, SCP Planner 권한 추가
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Auth ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		
		/* #################################################### */
		/* ITEM_ID 체크											*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Item.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE10 IN ( 'LINE ASSIGN','TACT TIME', 'DAILY CAPA', 'YIELD' )
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_ITEM_M_SN IT WITH(NOLOCK)
								   WHERE 1 = 1
									 AND IT.DIVISION_ID	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
									 AND IT.COMPANY_ID	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
									 AND IT.SITE_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
									 AND IT.ITEM_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12
									 AND IT.ACTIVE_FLAG = 'Y'
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Item ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* ITEM_ID - OPERATION 체크								*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Item - Operation'
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A,
				   SCM_ITEM_M_SN B
			 WHERE A.PROGRAM_ID 			= @v_program_id
			   AND A.SHEET_NAME				= @v_sheet_name
			   AND A.CREATED_BY				= @v_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND A.ATTRIBUTE10 IN ( 'LINE ASSIGN','TACT TIME', 'DAILY CAPA', 'YIELD' )
			   AND A.ATTRIBUTE1		= B.DIVISION_ID
			   AND A.ATTRIBUTE2		= B.COMPANY_ID
			   AND A.ATTRIBUTE3		= B.SITE_ID
			   AND A.ATTRIBUTE12	= B.ITEM_ID
			   AND B.ACTIVE_FLAG	= 'Y'
			   AND B.FLOW_ID				!= A.ATTRIBUTE7 -- OPERATION_ID
			   AND LEFT(B.FLOW_ID,5)		!= A.ATTRIBUTE7 -- OPERATION_ID
			   AND SUBSTRING(FLOW_ID,6,5)	!= A.ATTRIBUTE7 -- OPERATION_ID
			   AND SUBSTRING(FLOW_ID,11,5)	!= A.ATTRIBUTE7 -- OPERATION_ID
			   AND SUBSTRING(FLOW_ID,16,5)	!= A.ATTRIBUTE7 -- OPERATION_ID
			   AND SUBSTRING(FLOW_ID,12,5)	!= A.ATTRIBUTE7 -- OPERATION_ID
			   AND A.ATTRIBUTE7 NOT LIKE 'F%'
			  ;
			
			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Item - Operation ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* ITEM_ID - OPERATION (FORMATION) 체크					*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Item - Operation (FROMATION)'
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A,
				   SCM_ITEM_M_SN B
			 WHERE A.PROGRAM_ID 	= @v_program_id
			   AND A.SHEET_NAME		= @v_sheet_name
			   AND A.CREATED_BY		= @v_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND A.ATTRIBUTE10 IN ( 'LINE ASSIGN','TACT TIME', 'DAILY CAPA', 'YIELD' )
			   AND A.ATTRIBUTE1		= B.DIVISION_ID
			   AND A.ATTRIBUTE2		= B.COMPANY_ID
			   AND A.ATTRIBUTE3		= B.SITE_ID
			   AND A.ATTRIBUTE12	= B.ITEM_ID
			   AND B.ACTIVE_FLAG	= 'Y'
			   AND (B.FLOW_ID NOT IN ('A3000','A9000') OR B.FORMATION_FLOW_ID IS NULL)
			   AND A.ATTRIBUTE7 LIKE 'F%'
			  ;
			
			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Item - Operation (FORMATION) ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		
		/* #################################################### */
		/* ITEM , LANE QTY 체크 - E2000 공정만 체크				*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Item. Lane Qty'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE	= 'UPLOAD'
			   AND ATTRIBUTE10			= 'LINE ASSIGN'
			   AND ATTRIBUTE7			= 'E2000'
			   AND NOT EXISTS  (  SELECT 1
									FROM (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, 
												 A.ITEM_ID, B.LINE_ID, B.ELECTRODE_TYPE, B.OPERATION_ID, A.PROD_VERSION_TYPE, A.LANE_QTY
											FROM SCM_ITEM_LANE_M_SN A  WITH(NOLOCK)
											   , SCM_LINE_M_SN B WITH(NOLOCK)
										   WHERE A.ACTIVE_FLAG		= 'Y'
											 AND B.ACTIVE_FLAG		= 'Y'
											 AND A.COMPANY_ID		= B.COMPANY_ID
											 AND A.DIVISION_ID		= B.DIVISION_ID
											 AND A.SITE_ID			= B.SITE_ID
											 AND A.PLANT_ID			= B.PLANT_ID
											 AND A.FACTORY_ID		= B.FACTORY_ID
											 AND A.PROD_VERSION_TYPE= B.PROD_VERSION_TYPE
											 AND B.OPERATION_ID = 'E2000'  ) IL
								   WHERE IL.DIVISION_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
									 AND IL.COMPANY_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
									 AND IL.SITE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
									 AND IL.LINE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
									 AND IL.OPERATION_ID	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
									 AND IL.ELECTRODE_TYPE	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8
									 AND IL.ITEM_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12
									 AND CONVERT(INT,IL.LANE_QTY)	= ISNULL(CONVERT(INT,[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE13),0)
									);
		
			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Item. Lane Qty ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();
		
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* ######################################################## */
		/* 중복 값 체크(LOSS) 체크									*/
		/* ######################################################## */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Duplication Data.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND EXISTS (SELECT 1
							 FROM ( SELECT PROGRAM_ID, SHEET_NAME, CREATION_DATE
										 , ATTRIBUTE1	AS DIVISION_ID
										 , ATTRIBUTE2	AS COMPANY_ID
										 , ATTRIBUTE3	AS SITE_ID
										 , ATTRIBUTE4	AS PLANT_ID
										 , ATTRIBUTE5	AS FACTORY_ID
										 , ATTRIBUTE6	AS LINE_ID
										 , ATTRIBUTE7	AS OPERATION_ID
										 , ATTRIBUTE8	AS ELECTRODE_TYPE
										 , ATTRIBUTE10	AS DATA_TYPE_1
										 , ATTRIBUTE11	AS DATA_TYPE_2
									  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
									 WHERE X.PROGRAM_ID    = @v_program_id
									   AND X.SHEET_NAME    = @v_sheet_name
									   AND X.CREATED_BY    = @v_created_by
									   AND CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
									   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
									   AND X.ATTRIBUTE10 IN ('No-Load','No-Run','Not-Available','Performance(%)','Quality(%)')
									 GROUP BY PROGRAM_ID
											, SHEET_NAME
											, CREATION_DATE
											, ATTRIBUTE1
											, ATTRIBUTE2
											, ATTRIBUTE3
											, ATTRIBUTE4
											, ATTRIBUTE5
											, ATTRIBUTE6
											, ATTRIBUTE7
											, ATTRIBUTE8
											, ATTRIBUTE10
											, ATTRIBUTE11
									HAVING COUNT(1) > 1  ) T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID		= ATTRIBUTE1
							  AND T.COMPANY_ID		= ATTRIBUTE2
							  AND T.SITE_ID			= ATTRIBUTE3
							  AND T.PLANT_ID		= ATTRIBUTE4
							  AND T.FACTORY_ID		= ATTRIBUTE5
							  AND T.LINE_ID			= ATTRIBUTE6
							  AND T.OPERATION_ID	= ATTRIBUTE7
							  AND T.ELECTRODE_TYPE	= ATTRIBUTE8
							  AND T.DATA_TYPE_1		= ATTRIBUTE10
							  AND T.DATA_TYPE_2		= ATTRIBUTE11
						) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Duplication Data. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* ######################################################## */
		/* 중복 값 체크(LINE ASSIGN)									*/
		/* ######################################################## */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Duplication Item Data.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND EXISTS (SELECT 1
							 FROM ( SELECT PROGRAM_ID, SHEET_NAME, CREATION_DATE
										 , ATTRIBUTE1	AS DIVISION_ID
										 , ATTRIBUTE2	AS COMPANY_ID
										 , ATTRIBUTE3	AS SITE_ID
										 , ATTRIBUTE4	AS PLANT_ID
										 , ATTRIBUTE5	AS FACTORY_ID
										 , ATTRIBUTE6	AS LINE_ID
										 , ATTRIBUTE7	AS OPERATION_ID
										 , ATTRIBUTE8	AS ELECTRODE_TYPE
										 , ATTRIBUTE10	AS DATA_TYPE_1
										 , ATTRIBUTE12	AS ITEM_ID
									  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
									 WHERE X.PROGRAM_ID    = @v_program_id
									   AND X.SHEET_NAME    = @v_sheet_name
									   AND X.CREATED_BY    = @v_created_by
									   AND CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
									   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
									   AND X.ATTRIBUTE10 =  'LINE ASSIGN'
									 GROUP BY PROGRAM_ID
											, SHEET_NAME
											, CREATION_DATE
											, ATTRIBUTE1
											, ATTRIBUTE2
											, ATTRIBUTE3
											, ATTRIBUTE4
											, ATTRIBUTE5
											, ATTRIBUTE6
											, ATTRIBUTE7
											, ATTRIBUTE8
											, ATTRIBUTE10
											, ATTRIBUTE12
									HAVING COUNT(1) > 1  ) T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID		= ATTRIBUTE1
							  AND T.COMPANY_ID		= ATTRIBUTE2
							  AND T.SITE_ID			= ATTRIBUTE3
							  AND T.PLANT_ID		= ATTRIBUTE4
							  AND T.FACTORY_ID		= ATTRIBUTE5
							  AND T.LINE_ID			= ATTRIBUTE6
							  AND T.OPERATION_ID	= ATTRIBUTE7
							  AND T.ELECTRODE_TYPE	= ATTRIBUTE8
							  AND T.DATA_TYPE_1		= ATTRIBUTE10
							  AND T.ITEM_ID			= ATTRIBUTE12
						) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Duplication Item Data. Assign ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* ######################################################## */
		/* 중복 값 체크('TACT TIME','DAILY CAPA')					*/
		/* ######################################################## */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Duplication Item Data - Capa'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND EXISTS (SELECT 1
							 FROM ( SELECT PROGRAM_ID, SHEET_NAME, CREATION_DATE
										 , ATTRIBUTE1	AS DIVISION_ID
										 , ATTRIBUTE2	AS COMPANY_ID
										 , ATTRIBUTE3	AS SITE_ID
										 , ATTRIBUTE4	AS PLANT_ID
										 , ATTRIBUTE5	AS FACTORY_ID
										 , ATTRIBUTE6	AS LINE_ID
										 , ATTRIBUTE7	AS OPERATION_ID
										 , ATTRIBUTE8	AS ELECTRODE_TYPE
										 , ATTRIBUTE10	AS DATA_TYPE_1
										 , ATTRIBUTE12	AS ITEM_ID
									  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
									 WHERE X.PROGRAM_ID    = @v_program_id
									   AND X.SHEET_NAME    = @v_sheet_name
									   AND X.CREATED_BY    = @p_created_by
									   AND CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
									   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
									   AND X.ATTRIBUTE10 IN ('TACT TIME','DAILY CAPA')
									 GROUP BY PROGRAM_ID
											, SHEET_NAME
											, CREATION_DATE
											, ATTRIBUTE1
											, ATTRIBUTE2
											, ATTRIBUTE3
											, ATTRIBUTE4
											, ATTRIBUTE5
											, ATTRIBUTE6
											, ATTRIBUTE7
											, ATTRIBUTE8
											, ATTRIBUTE10
											, ATTRIBUTE12
									HAVING COUNT(1) > 1  ) T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID		= ATTRIBUTE1
							  AND T.COMPANY_ID		= ATTRIBUTE2
							  AND T.SITE_ID			= ATTRIBUTE3
							  AND T.PLANT_ID		= ATTRIBUTE4
							  AND T.FACTORY_ID		= ATTRIBUTE5
							  AND T.LINE_ID			= ATTRIBUTE6
							  AND T.OPERATION_ID	= ATTRIBUTE7
							  AND T.ELECTRODE_TYPE	= ATTRIBUTE8
							  AND T.DATA_TYPE_1		= ATTRIBUTE10
							  AND T.ITEM_ID			= ATTRIBUTE12
						) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Duplication Item Data - Capa ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* ######################################################## */
		/* 중복 값 체크('YIEDL')										*/
		/* ######################################################## */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Duplication Item Data - Yield'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND EXISTS (SELECT 1
							 FROM ( SELECT PROGRAM_ID, SHEET_NAME, CREATION_DATE
										 , ATTRIBUTE1	AS DIVISION_ID
										 , ATTRIBUTE2	AS COMPANY_ID
										 , ATTRIBUTE3	AS SITE_ID
										 , ATTRIBUTE4	AS PLANT_ID
										 , ATTRIBUTE5	AS FACTORY_ID
										 , ATTRIBUTE6	AS LINE_ID
										 , ATTRIBUTE7	AS OPERATION_ID
										 , ATTRIBUTE10	AS DATA_TYPE_1
										 , ATTRIBUTE12	AS ITEM_ID
									  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
									 WHERE X.PROGRAM_ID    = @v_program_id
									   AND X.SHEET_NAME    = @v_sheet_name
									   AND X.CREATED_BY    = @p_created_by
									   AND CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
									   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
									   AND X.ATTRIBUTE10 = 'YIELD'
									 GROUP BY PROGRAM_ID
											, SHEET_NAME
											, CREATION_DATE
											, ATTRIBUTE1
											, ATTRIBUTE2
											, ATTRIBUTE3
											, ATTRIBUTE4
											, ATTRIBUTE5
											, ATTRIBUTE6
											, ATTRIBUTE7
											, ATTRIBUTE10
											, ATTRIBUTE12
									HAVING COUNT(1) > 1  ) T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID		= ATTRIBUTE1
							  AND T.COMPANY_ID		= ATTRIBUTE2
							  AND T.SITE_ID			= ATTRIBUTE3
							  AND T.PLANT_ID		= ATTRIBUTE4
							  AND T.FACTORY_ID		= ATTRIBUTE5
							  AND T.LINE_ID			= ATTRIBUTE6
							  AND T.OPERATION_ID	= ATTRIBUTE7
							  AND T.DATA_TYPE_1		= ATTRIBUTE10
							  AND T.ITEM_ID			= ATTRIBUTE12
						) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Duplication Item Data - Yield ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* ################################################################ */
		/* CONFIRM 중복 값 체크(LINE ASSIGN,TACT TIME,DAILY CAPA,YIELD) 제외	*/
		/* ################################################################ */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Duplication Finish Data.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND EXISTS (SELECT 1
							 FROM ( SELECT PROGRAM_ID, SHEET_NAME, CREATION_DATE
										 , ATTRIBUTE1	AS DIVISION_ID
										 , ATTRIBUTE2	AS COMPANY_ID
										 , ATTRIBUTE3	AS SITE_ID
										 , ATTRIBUTE4	AS PLANT_ID
										 , ATTRIBUTE5	AS FACTORY_ID
										 , ATTRIBUTE6	AS LINE_ID
										 , ATTRIBUTE7	AS OPERATION_ID
										 , ATTRIBUTE8	AS ELECTRODE_TYPE
										 , ATTRIBUTE10	AS DATA_TYPE_1
										 , ATTRIBUTE11	AS DATA_TYPE_2
										 , ATTRIBUTE14	AS CONFIRM
									  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
									 WHERE X.PROGRAM_ID    = @v_program_id
									   AND X.SHEET_NAME    = @v_sheet_name
									   AND X.CREATED_BY    = @v_created_by
									   AND CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
									   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
									   AND X.ATTRIBUTE10 NOT IN ('LINE ASSIGN' , 'TACT TIME','DAILY CAPA', 'YIELD')
									 GROUP BY PROGRAM_ID
											, SHEET_NAME
											, CREATION_DATE
											, ATTRIBUTE1
											, ATTRIBUTE2
											, ATTRIBUTE3
											, ATTRIBUTE4
											, ATTRIBUTE5
											, ATTRIBUTE6
											, ATTRIBUTE7
											, ATTRIBUTE8
											, ATTRIBUTE10
											, ATTRIBUTE11
											, ATTRIBUTE14
									HAVING COUNT(1) > 1  ) T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID		= ATTRIBUTE1
							  AND T.COMPANY_ID		= ATTRIBUTE2
							  AND T.SITE_ID			= ATTRIBUTE3
							  AND T.PLANT_ID		= ATTRIBUTE4
							  AND T.FACTORY_ID		= ATTRIBUTE5
							  AND T.LINE_ID			= ATTRIBUTE6
							  AND T.OPERATION_ID	= ATTRIBUTE7
							  AND T.ELECTRODE_TYPE	= ATTRIBUTE8
							  AND T.DATA_TYPE_1		= ATTRIBUTE10
							  AND T.DATA_TYPE_2		= ATTRIBUTE11
							  AND T.CONFIRM			= ATTRIBUTE14
						) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Duplication Finish Data. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* ############################################################ */
		/* CONFIRM 중복 값 체크(LINE ASSIGN,TACT TIME,DAILY CAPA,YIELD) 	*/
		/* ############################################################ */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Duplication Finish LTY Data.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND EXISTS (SELECT 1
							 FROM ( SELECT PROGRAM_ID, SHEET_NAME, CREATION_DATE
										 , ATTRIBUTE1	AS DIVISION_ID
										 , ATTRIBUTE2	AS COMPANY_ID
										 , ATTRIBUTE3	AS SITE_ID
										 , ATTRIBUTE4	AS PLANT_ID
										 , ATTRIBUTE5	AS FACTORY_ID
										 , ATTRIBUTE6	AS LINE_ID
										 , ATTRIBUTE7	AS OPERATION_ID
										 , ATTRIBUTE8	AS ELECTRODE_TYPE
										 , ATTRIBUTE10	AS DATA_TYPE_1
										 , ATTRIBUTE12	AS ITEM_ID
										 , ATTRIBUTE13	AS LANE_QTY
										 , ATTRIBUTE14	AS CONFIRM
									  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
									 WHERE X.PROGRAM_ID    = @v_program_id
									   AND X.SHEET_NAME    = @v_sheet_name
									   AND X.CREATED_BY    = @v_created_by
									   AND CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
									   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
									   AND X.ATTRIBUTE10 IN ('LINE ASSIGN' , 'TACT TIME','DAILY CAPA', 'YIELD')
									 GROUP BY PROGRAM_ID
											, SHEET_NAME
											, CREATION_DATE
											, ATTRIBUTE1
											, ATTRIBUTE2
											, ATTRIBUTE3
											, ATTRIBUTE4
											, ATTRIBUTE5
											, ATTRIBUTE6
											, ATTRIBUTE7
											, ATTRIBUTE8
											, ATTRIBUTE10
											, ATTRIBUTE12
											, ATTRIBUTE13
											, ATTRIBUTE14
									HAVING COUNT(1) > 1  ) T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID		= ATTRIBUTE1
							  AND T.COMPANY_ID		= ATTRIBUTE2
							  AND T.SITE_ID			= ATTRIBUTE3
							  AND T.PLANT_ID		= ATTRIBUTE4
							  AND T.FACTORY_ID		= ATTRIBUTE5
							  AND T.LINE_ID			= ATTRIBUTE6
							  AND T.OPERATION_ID	= ATTRIBUTE7
							  AND T.ELECTRODE_TYPE	= ATTRIBUTE8
							  AND T.DATA_TYPE_1		= ATTRIBUTE10
							  AND T.ITEM_ID			= ATTRIBUTE12
							  AND T.LANE_QTY		= ATTRIBUTE13
							  AND T.CONFIRM			= ATTRIBUTE14
						) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Duplication Finish LTY Data. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;


		/* ############################################################ */
		/* LINE ASSIGN PRIORITY 체크 (1 ~ 9 정수 )					 	*/
		/* ############################################################ */
		BEGIN

			-- 임시 테이블 생성 변수
			--declare @v_program_id nvarchar(100) = 'scp0049'
			--declare @v_sheet_name nvarchar(100) = 'capa'
			--declare @v_created_by nvarchar(100) = 'khj79'
			--declare @v_creation_date nvarchar(100) = '2021-05-18 11:42:07.000'

			--SELECT * FROM #TMP_SCP0049_DATA_EXCEL_VALIDATION;

			SELECT V.ATTRIBUTE1 AS DIVISION_ID , V.ATTRIBUTE2 AS COMPANY_ID , V.ATTRIBUTE3 AS SITE_ID , V.ATTRIBUTE4 AS PLANT_ID , V.ATTRIBUTE5 AS FACTORY_ID
								, V.ATTRIBUTE6 AS LINE_ID , V.ATTRIBUTE7 AS OPERATION_ID , V.ATTRIBUTE8 AS ELECTRODE_TYPE , V.ATTRIBUTE9, V.ATTRIBUTE10 AS DATA_TYPE_1
								, V.ATTRIBUTE11 AS DATA_TYPE_2, V.ATTRIBUTE12 AS ITEM_ID , V.ATTRIBUTE13 AS LANE_QTY , V.ATTRIBUTE14 AS FINISH , V.ATTRIBUTE15 AS UOM
								, C.YYYYMMDD  ,V.VALUE AS QTY , @v_created_by AS CREATED_BY
						INTO #TMP_SCP0049_DATA_EXCEL_VALIDATION
					  FROM  (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
									, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
									, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13 , ATTRIBUTE14 , ATTRIBUTE15
									, COLUMN_NAME, YYYYMMDD
								FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
											, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
											, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
											, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
											, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
											, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
											, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
											, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
											, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
											, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
											, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
											, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
											, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
											, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
											, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
											, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
											, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
											, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
											, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
											, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
											, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
											, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
											, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
											, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
											, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
											, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
											, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
											, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
											, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
											, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
											, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
											, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
											, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
											, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
											, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
											, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
											, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
											, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
											, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
											, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
										FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
										WHERE  1 = 1
										AND    PROGRAM_ID    = @v_program_id
										AND    SHEET_NAME    = @v_sheet_name
										AND    CREATED_BY    = @v_created_by
										AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date
										AND    UPLOAD_STATUS_CODE = '@TITLE'
										) T
								UNPIVOT (    YYYYMMDD
										FOR COLUMN_NAME
									IN   (  ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
										, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
										, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30 
										, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
										, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
										, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
										, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
										, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
										, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
										, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
										, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
										, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
										, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
										, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
										, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
										, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
										, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
										, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
										, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
										, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
										, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
										, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
										, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
										, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
										, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
										, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
										, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
										, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
										, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
										, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
										, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
										, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
										, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
										, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
										, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
										, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
										, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
										)
									) AS X
										) C
										, (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
											, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
											, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
											, COLUMN_NAME, VALUE
										FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
													, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
													, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
													, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
													, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
													, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
													, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
													, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
													, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
													, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
													, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
													, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
													, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
													, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
													, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
													, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
													, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
													, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
													, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
													, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
													, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
													, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
													, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
													, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
													, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
													, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
													, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
													, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
													, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
													, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
													, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
													, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
													, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
													, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
													, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
													, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
													, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
													, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
													, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
													, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
												FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
												WHERE  1 = 1
												AND    PROGRAM_ID    = @v_program_id
												AND    SHEET_NAME    = @v_sheet_name
												AND    CREATED_BY    = @v_created_by
												AND    UPLOAD_STATUS_CODE = 'UPLOAD'
												AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date
												AND    ATTRIBUTE10 IN ( 'LINE ASSIGN' , 'YIELD')
												) T
										UNPIVOT (    VALUE
												FOR COLUMN_NAME
												IN   ( ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
													, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
													, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30 
													, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
													, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
													, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
													, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
													, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
													, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
													, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
													, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
													, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
													, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
													, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
													, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
													, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
													, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
													, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
													, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
													, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
													, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
													, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
													, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
													, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
													, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
													, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
													, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
													, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
													, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
													, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
													, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
													, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
													, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
													, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
													, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
													, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
													, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
													)
												) AS X
											) V               
											WHERE 1 = 1	
											AND   C.COLUMN_NAME = V.COLUMN_NAME
											AND   C.YYYYMMDD != ''
											AND   V.VALUE ! = ''
						;

			
			--select * from  #TMP_SCP0049_DATA_EXCEL_VALIDATION

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Priority(1~9)'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE10 = 'LINE ASSIGN'
			   AND EXISTS (SELECT 1
							  FROM #TMP_SCP0049_DATA_EXCEL_VALIDATION T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID		= ATTRIBUTE1
							  AND T.COMPANY_ID		= ATTRIBUTE2
							  AND T.SITE_ID			= ATTRIBUTE3
							  AND T.PLANT_ID		= ATTRIBUTE4
							  AND T.FACTORY_ID		= ATTRIBUTE5
							  AND T.LINE_ID			= ATTRIBUTE6
							  AND T.OPERATION_ID	= ATTRIBUTE7
							  AND T.ELECTRODE_TYPE	= ATTRIBUTE8
							  AND T.DATA_TYPE_1		= ATTRIBUTE10
							  AND T.ITEM_ID			= ATTRIBUTE12
							  AND ( CONVERT(NUMERIC(20,10),T.QTY)	< 1 
										OR CONVERT(NUMERIC(20,10),T.QTY)	> 9 
										OR ROUND(T.QTY, 10) - FLOOR(ROUND(T.QTY, 10)) <> 0
										)
							  AND CONVERT(NUMERIC(20,10),T.QTY) <> 0
						) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Priority(1~9). ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();


			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Yield(1~100)'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @v_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE10 = 'YIELD'
			   AND EXISTS (SELECT 1
							  FROM #TMP_SCP0049_DATA_EXCEL_VALIDATION T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID		= ATTRIBUTE1
							  AND T.COMPANY_ID		= ATTRIBUTE2
							  AND T.SITE_ID			= ATTRIBUTE3
							  AND T.PLANT_ID		= ATTRIBUTE4
							  AND T.FACTORY_ID		= ATTRIBUTE5
							  AND T.LINE_ID			= ATTRIBUTE6
							  AND T.OPERATION_ID	= ATTRIBUTE7
							  AND T.ELECTRODE_TYPE	= ATTRIBUTE8
							  AND T.DATA_TYPE_1		= ATTRIBUTE10
							  AND T.ITEM_ID			= ATTRIBUTE12
							  AND ( CONVERT(NUMERIC(20,10),T.QTY)	<= 1 
										OR CONVERT(NUMERIC(20,10),T.QTY)	> 100 
										--OR ROUND(T.QTY, 100) - FLOOR(ROUND(T.QTY, 100)) <> 0
										)
						) ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Yield(0~100). ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END





		-- 정상(SUCCESS) 처리
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
				SET UPLOAD_STATUS_CODE = 'SUCCESS'
				WHERE PROGRAM_ID       = @v_program_id
				AND SHEET_NAME         = @v_sheet_name
				AND CREATED_BY         = @v_created_by
				AND CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
				AND UPLOAD_STATUS_CODE = 'UPLOAD' ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## SUCCESS ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
	END;

	BEGIN
		SET @v_log_type = 'INSERT';
		SET @n_log_count = @n_log_count + 1;
		SET @v_log_message = '########## INSERT DATA START ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END;

	SELECT @v_count = COUNT(1)
	  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
	 WHERE T.PROGRAM_ID         = @v_program_id
	   AND T.SHEET_NAME         = @v_sheet_name
	   AND T.CREATED_BY         = @v_created_by
	   AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
	   AND T.UPLOAD_STATUS_CODE = 'ERROR' ;

	--IF @p_mode > 0 AND @v_count = 0
	IF @p_mode > 0 
	BEGIN
		




		-- TACT TIME , DAILY CAPA 정보가 변경될때 정보 수정
			IF OBJECT_ID('TEMPDB..#TMP_SCP0049_EXCEL_LOSS_UTIL_TACT') IS NOT NULL
				DROP TABLE #TMP_SCP0049_EXCEL_LOSS_UTIL_TACT;

			CREATE TABLE #TMP_SCP0049_EXCEL_LOSS_UTIL_TACT
			(
				COMPANY_ID			NVARCHAR(030)
				, DIVISION_ID		NVARCHAR(030)
				, SITE_ID			NVARCHAR(030)
				, PLANT_ID			NVARCHAR(030)
				, FACTORY_ID		NVARCHAR(030)
				, LINE_ID			NVARCHAR(030)
				, ELECTRODE_TYPE	NVARCHAR(030)
				, OPERATION_ID		NVARCHAR(030)
				, WORK_MONTH		NVARCHAR(008)
				, TACT_DATA_TYPE	NVARCHAR(010)
				, LOSS_UTIL			NVARCHAR(030)
			)
			;

			-- LOSS 정보가 변경될때 정보 수정
			IF OBJECT_ID('TEMPDB..#TMP_SCP0049_EXCEL_LOSS_UTIL_LOSS') IS NOT NULL
				DROP TABLE #TMP_SCP0049_EXCEL_LOSS_UTIL_LOSS;

			CREATE TABLE #TMP_SCP0049_EXCEL_LOSS_UTIL_LOSS
			(
				COMPANY_ID			NVARCHAR(030)
				, DIVISION_ID		NVARCHAR(030)
				, SITE_ID			NVARCHAR(030)
				, PLANT_ID			NVARCHAR(030)
				, FACTORY_ID		NVARCHAR(030)
				, LINE_ID			NVARCHAR(030)
				, ELECTRODE_TYPE	NVARCHAR(030)
				, OPERATION_ID		NVARCHAR(030)
				, WORK_MONTH		NVARCHAR(008)
				, TACT_DATA_TYPE	NVARCHAR(010)
				, LOSS_UTIL			NVARCHAR(030)
				, UPDATE_ID			NVARCHAR(100)
			)
			;

		
		BEGIN
			SET @v_log_type = 'INSERT';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## INSERT/UPDATE SCP0049 CAPA DATA START ##########';
			SET @v_description = @p_mode;
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		BEGIN TRANSACTION SCP0049_CAPA_UPLOAD;
		BEGIN TRY
			BEGIN

			SET @v_log_type = 'INSERT';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## MERGE SCP0049 CAPA DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------
			
			BEGIN
				/* #################################################### */
				/* 저장 전 임시 테이블 생성								*/
				/* #################################################### */
				BEGIN
					IF OBJECT_ID('TEMPDB..#TMP_SCP0049_DATA_EXCEL') IS NOT NULL
						DROP TABLE #TMP_SCP0049_DATA_EXCEL;

					-- 임시 테이블 생성 변수
					--declare @v_program_id nvarchar(100) = 'scp0049'
					--declare @v_sheet_name nvarchar(100) = 'capa'
					--declare @v_created_by nvarchar(100) = 'khj79'
					--declare @v_creation_date nvarchar(100) = '2021-08-25 15:57:01.000'

					SELECT V.ATTRIBUTE1 AS DIVISION_ID , V.ATTRIBUTE2 AS COMPANY_ID , V.ATTRIBUTE3 AS SITE_ID , V.ATTRIBUTE4 AS PLANT_ID , V.ATTRIBUTE5 AS FACTORY_ID
								, V.ATTRIBUTE6 AS LINE_ID , V.ATTRIBUTE7 AS OPERATION_ID , V.ATTRIBUTE8 AS ELECTRODE_TYPE , V.ATTRIBUTE9, V.ATTRIBUTE10 AS DATA_TYPE_1
								, V.ATTRIBUTE11 AS DATA_TYPE_2, V.ATTRIBUTE12 AS ITEM_ID , V.ATTRIBUTE13 AS LANE_QTY , V.ATTRIBUTE14 AS FINISH , V.ATTRIBUTE15 AS UOM
								, C.YYYYMMDD  ,V.VALUE AS QTY , @v_created_by AS CREATED_BY
						INTO #TMP_SCP0049_DATA_EXCEL
					  FROM  (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
									, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
									, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13 , ATTRIBUTE14 , ATTRIBUTE15
									, COLUMN_NAME, YYYYMMDD
								FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
											, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
											, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
											, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
											, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
											, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
											, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
											, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
											, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
											, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
											, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
											, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
											, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
											, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
											, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
											, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
											, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
											, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
											, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
											, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
											, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
											, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
											, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
											, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
											, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
											, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
											, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
											, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
											, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
											, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
											, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
											, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
											, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
											, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
											, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
											, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
											, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
											, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
											, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
											, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
										FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
										WHERE  1 = 1
										AND    PROGRAM_ID    = @v_program_id
										AND    SHEET_NAME    = @v_sheet_name
										AND    CREATED_BY    = @v_created_by
										AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date
										AND    UPLOAD_STATUS_CODE = '@TITLE'
										) T
								UNPIVOT (    YYYYMMDD
										FOR COLUMN_NAME
									IN   (  ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
										, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
										, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30 
										, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
										, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
										, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
										, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
										, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
										, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
										, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
										, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
										, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
										, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
										, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
										, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
										, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
										, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
										, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
										, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
										, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
										, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
										, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
										, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
										, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
										, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
										, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
										, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
										, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
										, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
										, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
										, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
										, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
										, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
										, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
										, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
										, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
										, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
										)
									) AS X
										) C
										, (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
											, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
											, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
											, COLUMN_NAME, VALUE
										FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
													, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
													, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
													, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
													, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
													, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
													, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
													, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
													, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
													, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
													, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
													, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
													, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
													, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
													, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
													, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
													, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
													, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
													, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
													, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
													, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
													, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
													, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
													, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
													, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
													, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
													, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
													, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
													, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
													, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
													, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
													, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
													, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
													, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
													, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
													, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
													, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
													, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
													, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
													, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
											
												FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
												WHERE  1 = 1
												AND    PROGRAM_ID    = @v_program_id
												AND    SHEET_NAME    = @v_sheet_name
												AND    CREATED_BY    = @v_created_by
												AND    UPLOAD_STATUS_CODE = 'SUCCESS'
												AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date
												) T
										UNPIVOT (    VALUE
												FOR COLUMN_NAME
												IN   ( ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
													, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
													, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30 
													, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
													, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
													, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
													, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
													, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
													, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
													, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
													, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
													, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
													, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
													, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
													, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
													, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
													, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
													, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
													, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
													, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
													, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
													, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
													, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
													, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
													, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
													, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
													, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
													, ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
													, ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
													, ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
													, ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
													, ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
													, ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
													, ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
													, ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
													, ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
													, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
													)
												) AS X
											) V               
											WHERE 1 = 1	
											AND   C.COLUMN_NAME = V.COLUMN_NAME
											AND   C.YYYYMMDD != ''
											AND   V.VALUE ! = ''
						;
						
						 

				END

				-- 임시 테이블 확인
				--SELECT * FROM #TMP_SCP0049_DATA_EXCEL

				

				/* #################################################### */
				/* 이력 저장				 								*/
				/* #################################################### */
				SET @v_log_error = 'CAPA HIST';

				DECLARE @SCP0049_HIST	AS DBO.SCP0049;
				DECLARE @SCP0049_DELETE	AS DBO.SCP0049;

				INSERT INTO @SCP0049_HIST
				(
					  P_DIVISION_ID
					, P_COMPANY_ID
					, P_SITE_ID
					, P_PLANT_ID
					, P_FACTORY_ID
					, P_LINE_ID
					, P_OPERATION_ID
					, P_ELECTRODE_TYPE
					, P_ITEM_ID
					, P_DATA_TABLE
					, P_DATA_TYPE
					, P_DAY_NAME
					, P_DAY_QTY
					, P_UPDATE_ID
				)
				SELECT DIVISION_ID
					 , COMPANY_ID
					 , SITE_ID
					 , PLANT_ID
					 , FACTORY_ID
					 , LINE_ID
					 , OPERATION_ID
					 , ELECTRODE_TYPE
					 , ITEM_ID
					 , CASE WHEN DATA_TYPE_1 = 'LINE ASSIGN' THEN 'LA'
							WHEN DATA_TYPE_1 IN ('DAILY CAPA','TACT TIME') THEN 'T'
							WHEN DATA_TYPE_1 = 'YIELD' THEN 'Y'
					   END			AS DATA_TABLE
					 , 'M'			AS DATA_TYPE -- MONTH DATA 만 존재 함
					 , YYYYMMDD		AS DAY_NAME
					 , QTY			AS DAY_QTY
					 , CREATED_BY	AS UPDATE_ID
				  FROM #TMP_SCP0049_DATA_EXCEL
				 WHERE DATA_TYPE_1 IN ( 'LINE ASSIGN','DAILY CAPA','TACT TIME','YIELD')
				   AND LEN(YYYYMMDD) = 6
				;

				-- 이력 저장
				EXEC [dbo].[PR_SCP_CAPA_HIST_DATASET] @SCP0049_HIST


				SET @v_log_error = 'LINE ASSIGN DELETE';

				-- LINE ASSIGN 삭제(TACT TIME,YIELD 삭제 동기화)
				INSERT INTO @SCP0049_DELETE
				SELECT *
				  FROM @SCP0049_HIST T
				 WHERE T.P_DATA_TABLE = 'LA'
				   AND ISNULL(CONVERT(INT,CONVERT(NUMERIC(20,10),P_DAY_QTY)),0) = 9
				;

				-- LINE ASSIGN 데이터 삭제
				DELETE X
				  FROM #TMP_SCP0049_DATA_EXCEL X
				  JOIN @SCP0049_DELETE A
				    ON X.FACTORY_ID		= A.P_FACTORY_ID
				   AND X.LINE_ID		= A.P_LINE_ID
				   AND X.OPERATION_ID	= A.P_OPERATION_ID
				   AND X.ELECTRODE_TYPE	= A.P_ELECTRODE_TYPE
				   AND X.ITEM_ID		= A.P_ITEM_ID
				   AND X.YYYYMMDD		= A.P_DAY_NAME
				   AND X.DATA_TYPE_1	= 'LINE ASSIGN'
				  ;

				DELETE X
				  FROM #TMP_SCP0049_DATA_EXCEL X
				  JOIN @SCP0049_DELETE A
					ON X.FACTORY_ID		= A.P_FACTORY_ID
				   AND X.LINE_ID		= A.P_LINE_ID
				   AND X.OPERATION_ID	= A.P_OPERATION_ID
				   AND X.ELECTRODE_TYPE	= A.P_ELECTRODE_TYPE
				   AND X.ITEM_ID		= A.P_ITEM_ID
				   AND X.YYYYMMDD		= A.P_DAY_NAME
				   AND X.DATA_TYPE_1	IN ('TACT TIME','DAILY CAPA')
				;


				DELETE X
				  FROM #TMP_SCP0049_DATA_EXCEL X
				  JOIN @SCP0049_DELETE A
					ON X.FACTORY_ID		= A.P_FACTORY_ID
				   AND X.LINE_ID		= A.P_LINE_ID
				   AND X.OPERATION_ID	= A.P_OPERATION_ID
				   AND X.ITEM_ID		= A.P_ITEM_ID
				   AND X.YYYYMMDD		= A.P_DAY_NAME
				   AND X.DATA_TYPE_1	= 'YIELD'
				;

				EXEC [dbo].[PR_SCP_CAPA_LINE_ASSIGN_DELETE_DATASET] @SCP0049_DELETE ;

				/* #################################################### */
				/* SCM_LOSS_M_SN		 								*/
				/* 월별 입력	(PM 은 일별 입력한다)						*/
				/* QTY 는 0 보다 크거나 같은(>=) 값 입력					*/
				/* #################################################### */
				BEGIN

				SET @v_log_error = 'LOSS MONTH';

				MERGE INTO SCM_LOSS_M_SN M
				USING (
						SELECT DIVISION_ID
							 , COMPANY_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , LINE_ID
							 , OPERATION_ID
							 , ELECTRODE_TYPE
							 , YYYYMMDD
							 , CREATED_BY
							 , CONVERT(NUMERIC(20,10),QTY ) AS QTY
							 , (SELECT SEGMENT1		AS LOSS_CODE
								 FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
								WHERE 1=1
								  AND LV.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
								  AND LV.ACTIVE_FLAG = 'Y' 
								  AND LV.ATTRIBUTE1 = T.DATA_TYPE_1
								  AND LV.ATTRIBUTE2 = T.DATA_TYPE_2
								) AS LOSS_CODE
						  FROM #TMP_SCP0049_DATA_EXCEL T
						 WHERE 1 = 1
						   AND DATA_TYPE_1 IN ( 'No-Run', 'Performance(%)','Quality(%)')
						   AND DATA_TYPE_2 <> 'PM'    -- PM 은 일별 입력한다.
						   AND LEN(YYYYMMDD) = 6    -- MONTH
						   AND YYYYMMDD		>=  @v_std_yyyymm
						   AND CONVERT(NUMERIC(20,10),QTY)	>= 0.0
						) B
						ON M.COMPANY_ID		= B.COMPANY_ID
					   AND M.DIVISION_ID	= B.DIVISION_ID
					   AND M.SITE_ID		= B.SITE_ID
					   AND M.PLANT_ID		= B.PLANT_ID
					   AND M.FACTORY_ID		= B.FACTORY_ID
					   AND M.OPERATION_ID	= B.OPERATION_ID
					   AND M.LINE_ID		= B.LINE_ID
					   AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					   AND M.LOSS_CODE		= B.LOSS_CODE
					   AND M.WORK_MONTH		= B.YYYYMMDD

					WHEN MATCHED THEN
						UPDATE SET
							  LOSS_RATE		= B.QTY / 100
							, UPDATE_ID		= B.CREATED_BY
							, UPDATE_TIME	= sysdatetime()

					WHEN NOT MATCHED THEN
						INSERT	(
								  COMPANY_ID	, DIVISION_ID	, SITE_ID			, PLANT_ID		, FACTORY_ID
								, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE	, WORK_MONTH	, LOSS_CODE
								, LOSS_RATE		, INSERT_ID		, INSERT_TIME		, UPDATE_ID		, UPDATE_TIME
							)
						VALUES  (
					 			  B.COMPANY_ID	, B.DIVISION_ID	, B.SITE_ID			, B.PLANT_ID	, B.FACTORY_ID
								, B.OPERATION_ID, B.LINE_ID		, B.ELECTRODE_TYPE	, B.YYYYMMDD	, B.LOSS_CODE
								, B.QTY/100		, B.CREATED_BY	, SYSDATETIME()		, B.CREATED_BY	, SYSDATETIME()
							);
				END

				/* #################################################### */
				/* SCM_LOSS_M_SN		 								*/
				/* 년도 입력 해당 년도에 월별 입력 한다.					*/
				/* 기준 월(현재월) 보다 크거나 같은(>=) 값 입력			*/
				/* QTY 는 0 보다 크거나 같은(>=) 값 입력					*/
				/* #################################################### */
				BEGIN

				SET @v_log_error = 'LOSS YEAR';

				MERGE INTO SCM_LOSS_M_SN M
				USING (
						SELECT DIVISION_ID
							 , COMPANY_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , LINE_ID
							 , OPERATION_ID
							 , ELECTRODE_TYPE
							 , X.BASIS_YYYYMM AS YYYYMMDD
							 , CREATED_BY
							 , CONVERT(NUMERIC(20,10), T.QTY ) AS QTY
							 , (SELECT SEGMENT1		AS LOSS_CODE
								 FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
								WHERE 1=1
								  AND LV.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
								  AND LV.ACTIVE_FLAG = 'Y' 
								  AND LV.ATTRIBUTE1 = T.DATA_TYPE_1
								  AND LV.ATTRIBUTE2 = T.DATA_TYPE_2
								) AS LOSS_CODE
						  FROM #TMP_SCP0049_DATA_EXCEL T
						 INNER JOIN (SELECT DISTINCT BASIS_YYYYMM , CALENDAR_YYYY
										FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
									   WHERE BASIS_YYYYMM >= @v_std_yyyymm   -- 기준월
									) X
							ON CALENDAR_YYYY = T.YYYYMMDD
						 WHERE 1 = 1
						   AND DATA_TYPE_1 IN ( 'No-Run', 'Performance(%)','Quality(%)')
						   AND DATA_TYPE_2 <> 'PM'    -- PM 은 일별 입력한다.
						   AND LEN(YYYYMMDD) = 4    -- YEAR
						   AND CONVERT(NUMERIC(20,10),T.QTY)	>= 0.0
						) B
						ON M.COMPANY_ID		= B.COMPANY_ID
					   AND M.DIVISION_ID	= B.DIVISION_ID
					   AND M.SITE_ID		= B.SITE_ID
					   AND M.PLANT_ID		= B.PLANT_ID
					   AND M.FACTORY_ID		= B.FACTORY_ID
					   AND M.OPERATION_ID	= B.OPERATION_ID
					   AND M.LINE_ID		= B.LINE_ID
					   AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					   AND M.LOSS_CODE		= B.LOSS_CODE
					   AND M.WORK_MONTH		= B.YYYYMMDD

					WHEN MATCHED THEN
						UPDATE SET
							  LOSS_RATE		= B.QTY / 100
							, UPDATE_ID		= B.CREATED_BY
							, UPDATE_TIME	= sysdatetime()

					WHEN NOT MATCHED THEN
						INSERT	(
								  COMPANY_ID	, DIVISION_ID	, SITE_ID			, PLANT_ID		, FACTORY_ID
								, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE	, WORK_MONTH	, LOSS_CODE
								, LOSS_RATE		, INSERT_ID		, INSERT_TIME		, UPDATE_ID		, UPDATE_TIME
							)
						VALUES  (
					 			  B.COMPANY_ID	, B.DIVISION_ID	, B.SITE_ID			, B.PLANT_ID	, B.FACTORY_ID
								, B.OPERATION_ID, B.LINE_ID		, B.ELECTRODE_TYPE	, B.YYYYMMDD	, B.LOSS_CODE
								, B.QTY/100		, B.CREATED_BY	, SYSDATETIME()		, B.CREATED_BY	, SYSDATETIME()
							);
				END

				/* #################################################### */
				/* SCM_MST_ITEM_LINE_ASSIGN_SN							*/
				/* LANE QTY 정보 UPDATE									*/
				/* #################################################### */
				BEGIN
					SET @v_log_error = 'LANE QTY MONTH UPDATE';

					MERGE INTO SCM_MST_ITEM_LINE_ASSIGN_SN M
					USING (
							SELECT T.ATTRIBUTE1		AS DIVISION_ID
								 , T.ATTRIBUTE2		AS COMPANY_ID
								 , T.ATTRIBUTE3		AS SITE_ID
								 , T.ATTRIBUTE4		AS PLANT_ID
								 , T.ATTRIBUTE5		AS FACTORY_ID
								 , T.ATTRIBUTE6		AS LINE_ID
								 , T.ATTRIBUTE7		AS OPERATION_ID
								 , T.ATTRIBUTE8		AS ELECTRODE_TYPE
								 , T.ATTRIBUTE12	AS ITEM_ID
								 , T.CREATED_BY		AS CREATED_BY
								 , T.ATTRIBUTE13	AS LANE_QTY
							  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
							 WHERE 1 = 1
							   AND PROGRAM_ID    = @v_program_id
							   AND SHEET_NAME    = @v_sheet_name
							   AND CREATED_BY    = @v_created_by
							   AND UPLOAD_STATUS_CODE = 'SUCCESS'
							   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date
							   AND T.ATTRIBUTE10 = 'LINE ASSIGN'
							   AND EXISTS (SELECT 1
											 FROM (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, 
												 A.ITEM_ID, B.LINE_ID, B.ELECTRODE_TYPE, B.OPERATION_ID, A.PROD_VERSION_TYPE, A.LANE_QTY
											FROM SCM_ITEM_LANE_M_SN A  WITH(NOLOCK)
											   , SCM_LINE_M_SN B WITH(NOLOCK)
										   WHERE A.ACTIVE_FLAG		= 'Y'
											 AND B.ACTIVE_FLAG		= 'Y'
											 AND A.COMPANY_ID		= B.COMPANY_ID
											 AND A.DIVISION_ID		= B.DIVISION_ID
											 AND A.SITE_ID			= B.SITE_ID
											 AND A.PLANT_ID			= B.PLANT_ID
											 AND A.FACTORY_ID		= B.FACTORY_ID
											 AND A.PROD_VERSION_TYPE= B.PROD_VERSION_TYPE
											 AND B.OPERATION_ID = 'E2000') IL
								   WHERE IL.DIVISION_ID		= T.ATTRIBUTE1
									 AND IL.COMPANY_ID		= T.ATTRIBUTE2
									 AND IL.SITE_ID			= T.ATTRIBUTE3
									 AND IL.LINE_ID			= T.ATTRIBUTE6
									 AND IL.OPERATION_ID	= T.ATTRIBUTE7
									 AND IL.ELECTRODE_TYPE	= T.ATTRIBUTE8
									 AND IL.ITEM_ID			= T.ATTRIBUTE12
									 AND CONVERT(INT,IL.LANE_QTY)	= ISNULL(CONVERT(INT,T.ATTRIBUTE13),0) 
									 )
							) B
						ON M.COMPANY_ID		= B.COMPANY_ID
					   AND M.DIVISION_ID	= B.DIVISION_ID
					   AND M.SITE_ID		= B.SITE_ID
					   AND M.PLANT_ID		= B.PLANT_ID
					   AND M.FACTORY_ID		= B.FACTORY_ID
					   AND M.ITEM_ID		= B.ITEM_ID
					   AND M.OPERATION_ID	= B.OPERATION_ID
					   AND M.LINE_ID		= B.LINE_ID
					   AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					   AND M.MONTH			>= @v_std_yyyymm

					WHEN MATCHED THEN
						UPDATE SET
							  LANE_QTY		= B.LANE_QTY
							, UPDATE_ID		= B.CREATED_BY
							, UPDATE_TIME	= sysdatetime()
							;
				END

				/* #################################################### */
				/* SCM_MST_ITEM_LINE_ASSIGN_EXCEPT_SN					*/
				/* LANE QTY 정보 UPDATE									*/
				/* #################################################### */
				BEGIN
					SET @v_log_error = 'LANE QTY MONTH DAILY';

					MERGE INTO  SCM_MST_ITEM_LINE_ASSIGN_EXCEPT_SN M
					USING (
							SELECT T.ATTRIBUTE1		AS DIVISION_ID
								 , T.ATTRIBUTE2		AS COMPANY_ID
								 , T.ATTRIBUTE3		AS SITE_ID
								 , T.ATTRIBUTE4		AS PLANT_ID
								 , T.ATTRIBUTE5		AS FACTORY_ID
								 , T.ATTRIBUTE6		AS LINE_ID
								 , T.ATTRIBUTE7		AS OPERATION_ID
								 , T.ATTRIBUTE8		AS ELECTRODE_TYPE
								 , T.ATTRIBUTE12	AS ITEM_ID
								 , T.CREATED_BY		AS CREATED_BY
								 , T.ATTRIBUTE13	AS LANE_QTY
							  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
							 WHERE 1 = 1
							   AND PROGRAM_ID    = @v_program_id
							   AND SHEET_NAME    = @v_sheet_name
							   AND CREATED_BY    = @v_created_by
							   AND UPLOAD_STATUS_CODE = 'SUCCESS'
							   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date
							   AND T.ATTRIBUTE10 = 'LINE ASSIGN'
							   AND EXISTS (SELECT 1
											 FROM (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, 
												 A.ITEM_ID, B.LINE_ID, B.ELECTRODE_TYPE, B.OPERATION_ID, A.PROD_VERSION_TYPE, A.LANE_QTY
											FROM SCM_ITEM_LANE_M_SN A  WITH(NOLOCK)
											   , SCM_LINE_M_SN B WITH(NOLOCK)
										   WHERE A.ACTIVE_FLAG		= 'Y'
											 AND B.ACTIVE_FLAG		= 'Y'
											 AND A.COMPANY_ID		= B.COMPANY_ID
											 AND A.DIVISION_ID		= B.DIVISION_ID
											 AND A.SITE_ID			= B.SITE_ID
											 AND A.PLANT_ID			= B.PLANT_ID
											 AND A.FACTORY_ID		= B.FACTORY_ID
											 AND A.PROD_VERSION_TYPE= B.PROD_VERSION_TYPE
											 AND B.OPERATION_ID = 'E2000') IL
								   WHERE IL.DIVISION_ID		= T.ATTRIBUTE1
									 AND IL.COMPANY_ID		= T.ATTRIBUTE2
									 AND IL.SITE_ID			= T.ATTRIBUTE3
									 AND IL.LINE_ID			= T.ATTRIBUTE6
									 AND IL.OPERATION_ID	= T.ATTRIBUTE7
									 AND IL.ELECTRODE_TYPE	= T.ATTRIBUTE8
									 AND IL.ITEM_ID			= T.ATTRIBUTE12
									 AND CONVERT(INT,IL.LANE_QTY)	= ISNULL(CONVERT(INT,T.ATTRIBUTE13),0) 
									 )
							) B
						ON M.COMPANY_ID		= B.COMPANY_ID
					   AND M.DIVISION_ID	= B.DIVISION_ID
					   AND M.SITE_ID		= B.SITE_ID
					   AND M.PLANT_ID		= B.PLANT_ID
					   AND M.FACTORY_ID		= B.FACTORY_ID
					   AND M.ITEM_ID		= B.ITEM_ID
					   AND M.OPERATION_ID	= B.OPERATION_ID
					   AND M.LINE_ID		= B.LINE_ID
					   AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					   AND CONVERT(NVARCHAR(6) , M.START_TIME,112) >= @v_std_yyyymm

					WHEN MATCHED THEN
						UPDATE SET
							  LANE_QTY		= B.LANE_QTY
							, UPDATE_ID		= B.CREATED_BY
							, UPDATE_TIME	= sysdatetime()
							;
				END


				/* #################################################### */
				/* SCM_ITEM_LINE_ASSIGN_M	month ,year					*/
				/* 기준 월(현재월) 보다 크거나 같은(>=) 값 입력			*/
				/* QTY 는 0 보다 크거나 같은(>=) 값 입력					*/
				/* LINE ASSIGN 은 LANE QTY 때문에 OPERATION 분리하여 수정한다.*/
				/* #################################################### */
				BEGIN

				SET @v_log_error = 'LINE ASSIGN MONTH';
				-- LANE QTY 가 존재하는 공정(E2000, E3000, E4000)
				MERGE INTO SCM_MST_ITEM_LINE_ASSIGN_SN M
				USING (
						SELECT DIVISION_ID
							 , COMPANY_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , LINE_ID
							 , OPERATION_ID
							 , ELECTRODE_TYPE
							 , YYYYMMDD
							 , CREATED_BY
							 , ISNULL((CASE WHEN LANE_QTY  = '' THEN 0.0 ELSE CONVERT(NUMERIC(20,10) , LANE_QTY) END ),0) AS LANE_QTY
							 , CONVERT(INT,CONVERT(NUMERIC(20,10),QTY))	AS QTY
							 , ITEM_ID
						  FROM #TMP_SCP0049_DATA_EXCEL T
						 WHERE 1 = 1
						   AND DATA_TYPE_1 = 'LINE ASSIGN'
						   AND LEN(YYYYMMDD) = 6			-- MONTH
						   AND YYYYMMDD >= @v_std_yyyymm	-- 수정 가능 기준 날짜
						   AND CONVERT(NUMERIC(20,10),T.QTY)	> 0.0
						   AND OPERATION_ID = 'E2000'
						) B
						ON M.COMPANY_ID		= B.COMPANY_ID
					   AND M.DIVISION_ID	= B.DIVISION_ID
					   AND M.SITE_ID		= B.SITE_ID
					   AND M.PLANT_ID		= B.PLANT_ID
					   AND M.FACTORY_ID		= B.FACTORY_ID
					   AND M.ITEM_ID		= B.ITEM_ID
					   AND M.OPERATION_ID	= B.OPERATION_ID
					   AND M.LINE_ID		= B.LINE_ID
					   AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					   AND M.MONTH			= B.YYYYMMDD

				WHEN MATCHED THEN
					UPDATE SET
						  PRIORITY		= B.QTY
						, UPDATE_ID		= B.CREATED_BY
						, UPDATE_TIME	= sysdatetime()
				WHEN NOT MATCHED THEN
					INSERT	(
							  COMPANY_ID, DIVISION_ID	, SITE_ID		, PLANT_ID		, FACTORY_ID
							, ITEM_ID	, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, MONTH
							, LANE_QTY
							, PRIORITY	, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
							)
					VALUES  (
					 		  B.COMPANY_ID	, B.DIVISION_ID	, B.SITE_ID		, B.PLANT_ID		, B.FACTORY_ID
							, B.ITEM_ID		, B.OPERATION_ID, B.LINE_ID		, B.ELECTRODE_TYPE	, B.YYYYMMDD
							, B.LANE_QTY
							, B.QTY			, B.CREATED_BY	, SYSDATETIME()	, B.CREATED_BY		, SYSDATETIME()
						);
				END


				BEGIN

				SET @v_log_error = 'LINE ASSIGN MONTH LQ';
				-- LANE QTY 가 존재하는 공정(E2000, E3000, E4000)
				MERGE INTO SCM_MST_ITEM_LINE_ASSIGN_SN M
				USING (
						SELECT DIVISION_ID
							 , COMPANY_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , LINE_ID
							 , OPERATION_ID
							 , ELECTRODE_TYPE
							 , YYYYMMDD
							 , CREATED_BY
							 , 0										AS LANE_QTY
							 , CONVERT(INT,CONVERT(NUMERIC(20,10),QTY))	AS QTY
							 , ITEM_ID
						  FROM #TMP_SCP0049_DATA_EXCEL T
						 WHERE 1 = 1
						   AND DATA_TYPE_1 = 'LINE ASSIGN'
						   AND LEN(YYYYMMDD) = 6			-- MONTH
						   AND YYYYMMDD >= @v_std_yyyymm	-- 수정 가능 기준 날짜
						   AND CONVERT(NUMERIC(20,10),T.QTY)	> 0.0
						   AND OPERATION_ID NOT IN ('E2000')
						) B
						ON M.COMPANY_ID		= B.COMPANY_ID
					   AND M.DIVISION_ID	= B.DIVISION_ID
					   AND M.SITE_ID		= B.SITE_ID
					   AND M.PLANT_ID		= B.PLANT_ID
					   AND M.FACTORY_ID		= B.FACTORY_ID
					   AND M.ITEM_ID		= B.ITEM_ID
					   AND M.OPERATION_ID	= B.OPERATION_ID
					   AND M.LINE_ID		= B.LINE_ID
					   AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					   AND M.MONTH			= B.YYYYMMDD

				WHEN MATCHED THEN
					UPDATE SET
						  PRIORITY		= B.QTY
						, LANE_QTY		= B.LANE_QTY
						, UPDATE_ID		= B.CREATED_BY
						, UPDATE_TIME	= sysdatetime()
				WHEN NOT MATCHED THEN
					INSERT	(
							  COMPANY_ID, DIVISION_ID	, SITE_ID		, PLANT_ID		, FACTORY_ID
							, ITEM_ID	, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, MONTH
							, LANE_QTY
							, PRIORITY	, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
							)
					VALUES  (
					 		  B.COMPANY_ID	, B.DIVISION_ID	, B.SITE_ID		, B.PLANT_ID		, B.FACTORY_ID
							, B.ITEM_ID		, B.OPERATION_ID, B.LINE_ID		, B.ELECTRODE_TYPE	, B.YYYYMMDD
							, B.LANE_QTY
							, B.QTY			, B.CREATED_BY	, SYSDATETIME()	, B.CREATED_BY		, SYSDATETIME()
						);
				END

				/* #################################################### */
				/* SCM_MST_TACT_TIME_SN								*/
				/* 기준 월(현재월) 보다 크거나 같은(>=) 값 입력			*/
				/* QTY 는 0 보다 크거나 같은(>=) 값 입력					*/
				/* #################################################### */
				BEGIN

				SET @v_log_error = 'TACT TIME MONTH';

				INSERT INTO #TMP_SCP0049_EXCEL_LOSS_UTIL_TACT
				(
					  COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, OPERATION_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, WORK_MONTH
					, LOSS_UTIL
				)
				SELECT A.COMPANY_ID
					 , A.DIVISION_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.FACTORY_ID
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ELECTRODE_TYPE
					 , A.WORK_MONTH
					  --, ROUND(EXP(SUM(ROUND(LOG(1-ISNULL(L.LOSS_RATE,0)),4))),4) AS LOSS_UTIL
					 , 1-ROUND(SUM(ISNULL(LOSS_RATE,0)),4)	AS UTIL
				FROM (SELECT DISTINCT 
							  COMPANY_ID
							, DIVISION_ID
							, SITE_ID
							, PLANT_ID
							, FACTORY_ID
							, OPERATION_ID
							, LINE_ID
							, ELECTRODE_TYPE
							, YYYYMMDD		AS WORK_MONTH
						 FROM #TMP_SCP0049_DATA_EXCEL T
						WHERE 1=1
						  AND DATA_TYPE_1 IN ( 'DAILY CAPA', 'TACT TIME')
						  AND LEN(YYYYMMDD) = 6			-- MONTH
						  AND YYYYMMDD >= @v_std_yyyymm	-- 수정 가능 기준 날짜
						  AND CONVERT(NUMERIC(20,10),T.QTY)	>= 0.0
					) A

				JOIN SCM_LOSS_M_SN L WITH(NOLOCK)     -- LOSS UTIL 값 조회
				  ON L.COMPANY_ID		= A.COMPANY_ID
				 AND L.DIVISION_ID		= A.DIVISION_ID
				 AND L.SITE_ID			= A.SITE_ID
				 AND L.PLANT_ID			= A.PLANT_ID
				 AND L.FACTORY_ID		= A.FACTORY_ID
				 AND L.OPERATION_ID		= A.OPERATION_ID
				 AND L.LINE_ID			= A.LINE_ID
				 AND L.ELECTRODE_TYPE	= A.ELECTRODE_TYPE
				 AND L.WORK_MONTH		= A.WORK_MONTH

				 JOIN (SELECT SEGMENT1	AS LOSS_CODE
					  FROM SCM_SYS_LOOKUP_VALUE_SN  SSLV WITH(NOLOCK)
					 WHERE LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
					   AND ATTRIBUTE5 = 'Y'
					) B
				ON L.LOSS_CODE	= B.LOSS_CODE

				GROUP BY A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.OPERATION_ID
					, A.LINE_ID
					, A.ELECTRODE_TYPE
					, A.WORK_MONTH
				;
				END


				

				BEGIN
				MERGE INTO SCM_MST_TACT_TIME_SN M
				USING (
						SELECT T.DIVISION_ID
							 , T.COMPANY_ID
							 , T.SITE_ID
							 , T.PLANT_ID
							 , T.FACTORY_ID
							 , T.LINE_ID
							 , T.OPERATION_ID
							 , T.ELECTRODE_TYPE
							 , T.YYYYMMDD
							 , T.CREATED_BY
							 --, CONVERT(NUMERIC(20,10),T.QTY )	QTY
							 , CASE WHEN DATA_TYPE_1 = 'DAILY CAPA' AND ISNULL(CONVERT(NUMERIC(20,10),T.QTY),0) = 0 THEN 0
									WHEN DATA_TYPE_1 = 'DAILY CAPA' THEN 86400/CONVERT(NUMERIC(20,10),T.QTY) * ISNULL(X.LOSS_UTIL,1)
									ELSE CONVERT(NUMERIC(20,10),T.QTY) END AS QTY_TACT
							 , CASE WHEN DATA_TYPE_1 = 'TACT TIME' AND ISNULL(CONVERT(NUMERIC(20,10),T.QTY),0) = 0 THEN 0
									WHEN DATA_TYPE_1 = 'TACT TIME' AND ISNULL(CONVERT(NUMERIC(20,10),T.QTY),0) > 0 THEN ROUND(86400/CONVERT(NUMERIC(20,10),T.QTY) * ISNULL(LOSS_UTIL,1), 0)
									ELSE CONVERT(NUMERIC(20,10),T.QTY) END AS QTY_DAILY
							 , ITEM_ID
							 , DATA_TYPE_1
						  FROM #TMP_SCP0049_DATA_EXCEL T

						  LEFT JOIN #TMP_SCP0049_EXCEL_LOSS_UTIL_TACT X
							ON T.COMPANY_ID		= X.COMPANY_ID
						   AND T.DIVISION_ID	= X.DIVISION_ID
						   AND T.SITE_ID		= X.SITE_ID
						   AND T.PLANT_ID		= X.PLANT_ID
						   AND T.FACTORY_ID		= X.FACTORY_ID
						   AND T.OPERATION_ID	= X.OPERATION_ID
						   AND T.LINE_ID		= X.LINE_ID
						   AND T.ELECTRODE_TYPE	= X.ELECTRODE_TYPE
						   AND T.YYYYMMDD		= X.WORK_MONTH

						 WHERE 1 = 1
						   AND DATA_TYPE_1 IN ( 'DAILY CAPA', 'TACT TIME')
						   AND LEN(YYYYMMDD) = 6    -- MONTH
						   AND YYYYMMDD >= @v_std_yyyymm	-- 수정 가능 기준 날짜
						   AND CONVERT(NUMERIC(20,10),T.QTY)	>= 0.0
						) B
						ON M.COMPANY_ID		= B.COMPANY_ID
					   AND M.DIVISION_ID	= B.DIVISION_ID
					   AND M.SITE_ID		= B.SITE_ID
					   AND M.PLANT_ID		= B.PLANT_ID
					   AND M.FACTORY_ID		= B.FACTORY_ID
					   AND M.ITEM_ID		= B.ITEM_ID
					   AND M.OPERATION_ID	= B.OPERATION_ID
					   AND M.LINE_ID		= B.LINE_ID
					   AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					   AND M.MONTH			= B.YYYYMMDD

				WHEN MATCHED THEN
					UPDATE SET
						  TACT_TIME		= QTY_TACT
						, DAILY_CAPA	= CONVERT(INT,QTY_DAILY)
						, UPDATE_ID		= B.CREATED_BY
						, UPDATE_TIME	= sysdatetime()

				WHEN NOT MATCHED THEN
					INSERT	(		
							  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID		, FACTORY_ID
							, ITEM_ID		, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, MONTH
							, TACT_TIME		, DAILY_CAPA
							, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
							)
					VALUES  (
					 		  B.COMPANY_ID		, B.DIVISION_ID	, B.SITE_ID		, B.PLANT_ID		, B.FACTORY_ID
							, B.ITEM_ID			, B.OPERATION_ID, B.LINE_ID		, B.ELECTRODE_TYPE	, B.YYYYMMDD
							, QTY_TACT			, CONVERT(INT,QTY_DAILY)
							, B.CREATED_BY		, SYSDATETIME()	, B.CREATED_BY		, SYSDATETIME()
							);
				END

				/* #################################################### */
				/* SCM_MST_YIELD_SN									*/
				/* 기준 월(현재월) 보다 크거나 같은(>=) 값 입력			*/
				/* QTY 는 0 보다 크거나 같은(>=) 값 입력					*/
				/* #################################################### */
				BEGIN

				SET @v_log_error = 'YIELD MONTH';

				MERGE INTO SCM_MST_YIELD_SN M
				USING (
						SELECT DIVISION_ID
							 , COMPANY_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , LINE_ID
							 , OPERATION_ID
							 , ELECTRODE_TYPE
							 , YYYYMMDD
							 , CREATED_BY
							 , CONVERT(NUMERIC(20,10),T.QTY) AS QTY
							 , ITEM_ID
						  FROM #TMP_SCP0049_DATA_EXCEL T
						 WHERE 1 = 1
						   AND DATA_TYPE_1 = 'YIELD'
						   AND LEN(YYYYMMDD) = 6    -- MONTH
						   AND YYYYMMDD >= @v_std_yyyymm	-- 수정 가능 기준 날짜
						   AND CONVERT(NUMERIC(20,10),T.QTY)		>= 0.0
						) B
						ON M.COMPANY_ID		= B.COMPANY_ID
					   AND M.DIVISION_ID	= B.DIVISION_ID
					   AND M.SITE_ID		= B.SITE_ID
					   AND M.PLANT_ID		= B.PLANT_ID
					   AND M.FACTORY_ID		= B.FACTORY_ID
					   AND M.ITEM_ID		= B.ITEM_ID
					   AND M.OPERATION_ID	= B.OPERATION_ID
					   AND M.LINE_ID		= B.LINE_ID
					   AND M.MONTH			= B.YYYYMMDD

				WHEN MATCHED THEN
					UPDATE SET
					  YIELD			= B.QTY / 100
					, UPDATE_ID		= B.CREATED_BY
					, UPDATE_TIME	= sysdatetime()

				WHEN NOT MATCHED THEN
					INSERT	(		
						  COMPANY_ID	, DIVISION_ID	, SITE_ID	, PLANT_ID	, FACTORY_ID
						, ITEM_ID		, OPERATION_ID	, LINE_ID	, MONTH		, YIELD
						, INSERT_ID		, INSERT_TIME	, UPDATE_ID	, UPDATE_TIME
						)
					VALUES  (
					 	  B.COMPANY_ID	, B.DIVISION_ID	, B.SITE_ID		, B.PLANT_ID	, B.FACTORY_ID
						, B.ITEM_ID		, B.OPERATION_ID, B.LINE_ID		, B.YYYYMMDD	, B.QTY /100
						, B.CREATED_BY	, SYSDATETIME()	, B.CREATED_BY	, SYSDATETIME()
						);
				END

				/* #################################################### */
				/* SCM_MASTER_MANAGER_M_SN	CONFIRM 저장					*/
				/* #################################################### */
				BEGIN
					SELECT @v_mod_cnt = COUNT(1)
					  FROM #TMP_SCP0049_DATA_EXCEL T

					  JOIN (SELECT SEGMENT1	AS LOSS_CODE
								, ATTRIBUTE1
								, ATTRIBUTE2
							  FROM SCM_SYS_LOOKUP_VALUE_SN  SSLV WITH(NOLOCK)
							 WHERE LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
							   AND ATTRIBUTE5 = 'Y'
							) B
						ON T.DATA_TYPE_1 = B.ATTRIBUTE1
					   AND T.DATA_TYPE_2 = B.ATTRIBUTE2

					 WHERE 1 = 1
					   AND DATA_TYPE_1 = 'No-Run'
					   AND DATA_TYPE_2 <> 'PM'    -- PM 은 일별 입력한다.
					   AND LEN(YYYYMMDD) = 6    -- MONTH
					   AND YYYYMMDD		>=  @v_std_yyyymm
					   AND CONVERT(NUMERIC(20,10),QTY)	>= 0.0
					;


					IF @v_mod_cnt > 0
					BEGIN
						/* ############################################################ */
						-- 1. TACT TIME, DAILY CAPA  정보의 일별 데이터를 추가/저장 한다.
						-- 2. 월별 년도별 데이터 수정은 별도의 테이블에 저장한다.
						-- 3. TACT TIME 정보를 수정 했을 때 DAILY CAPA 값을 산출해서 저장한다.
						-- 4. DAILY CAPA 정보를 수정 했을 때 TACT TIME 값을 산출해서 저장한다.
						-- 5. TACT TIME 과 DAILY CAPA 데이터 산출을 위해 LOSS 테이블의 조회 후 임시 테이블에 저장한다.
						/* ############################################################ */
			
						-- LOSS UTIL 임시 테이블 저장
						INSERT INTO #TMP_SCP0049_EXCEL_LOSS_UTIL_LOSS
						(
							  COMPANY_ID
							, DIVISION_ID
							, SITE_ID
							, PLANT_ID
							, FACTORY_ID
							, OPERATION_ID
							, LINE_ID
							, ELECTRODE_TYPE
							, WORK_MONTH
							, TACT_DATA_TYPE
							, LOSS_UTIL
							, UPDATE_ID
						)
						SELECT A.COMPANY_ID
							, A.DIVISION_ID
							, A.SITE_ID
							, A.PLANT_ID
							, A.FACTORY_ID
							, A.OPERATION_ID
							, A.LINE_ID
							, A.ELECTRODE_TYPE
							, A.WORK_MONTH
							, LV.TACT_DATA_TYPE
							--, ROUND(EXP(SUM(ROUND(LOG(1-ISNULL(L.LOSS_RATE,0)),4))),4) AS LOSS_UTIL
							, 1-ROUND(SUM(ISNULL(LOSS_RATE,0)),4) AS UTIL
							, A.CREATED_BY
						FROM (SELECT DISTINCT 
									COMPANY_ID
									, DIVISION_ID
									, SITE_ID
									, PLANT_ID
									, FACTORY_ID
									, OPERATION_ID
									, LINE_ID
									, ELECTRODE_TYPE
									, YYYYMMDD		AS WORK_MONTH
									, CREATED_BY
								FROM #TMP_SCP0049_DATA_EXCEL X
									
								WHERE 1 = 1
									AND DATA_TYPE_1 = 'No-Run'
									AND DATA_TYPE_2 <> 'PM'    -- PM 은 일별 입력한다.
									AND LEN(YYYYMMDD) = 6    -- MONTH
									AND YYYYMMDD		>=  @v_std_yyyymm
									AND CONVERT(NUMERIC(20,10),QTY)	>= 0.0
							) A

						   JOIN SCM_LOSS_M_SN L WITH(NOLOCK)     -- LOSS UTIL 값 조회
							ON L.COMPANY_ID			= A.COMPANY_ID
							AND L.DIVISION_ID		= A.DIVISION_ID
							AND L.SITE_ID			= A.SITE_ID
							AND L.PLANT_ID			= A.PLANT_ID
							AND L.FACTORY_ID		= A.FACTORY_ID
							AND L.OPERATION_ID		= A.OPERATION_ID
							AND L.LINE_ID			= A.LINE_ID
							AND L.ELECTRODE_TYPE	= A.ELECTRODE_TYPE
							AND L.WORK_MONTH		= A.WORK_MONTH

							JOIN (SELECT SEGMENT1	AS LOSS_CODE
									FROM SCM_SYS_LOOKUP_VALUE_SN  SSLV WITH(NOLOCK)
									WHERE LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
									AND ATTRIBUTE5 = 'Y'
								) B
							ON L.LOSS_CODE	= B.LOSS_CODE

							JOIN (SELECT LV.ATTRIBUTE1	AS TACT_DATA_TYPE
										, LV.SEGMENT2		AS PLANT_ID
										, LV.SEGMENT3		AS OPERATION_ID
									FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)   -- TACT TIME , DAILY CAPA 조회
									WHERE LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
									AND LV.SEGMENT1 			= 'LA002'
									AND LV.ACTIVE_FLAG		= 'Y'
								) LV
							ON A.PLANT_ID		= LV.PLANT_ID
							AND A.OPERATION_ID	= LV.OPERATION_ID

						GROUP BY A.COMPANY_ID
								, A.DIVISION_ID
								, A.SITE_ID
								, A.PLANT_ID
								, A.FACTORY_ID
								, A.OPERATION_ID
								, A.LINE_ID
								, A.ELECTRODE_TYPE
								, A.WORK_MONTH
								, LV.TACT_DATA_TYPE
								, A.CREATED_BY;

						/* ############################################################ */
						-- 이력저장
						/* ############################################################ */
						DECLARE @SCP0049_LOSS AS DBO.SCP0049 ;

						INSERT INTO @SCP0049_LOSS
						(
							  P_DATA_TABLE
							, P_DATA_TYPE
							, P_DIVISION_ID
							, P_COMPANY_ID
							, P_SITE_ID
							, P_PLANT_ID
							, P_FACTORY_ID
							, P_LINE_ID
							, P_ELECTRODE_TYPE
							, P_OPERATION_ID
							, P_ITEM_ID
							, P_DAY_NAME
							, P_UPDATE_ID
						)
						SELECT 'T'				AS DATA_TABLE
							 , 'M'				AS DATA_TYPE
							 , M.DIVISION_ID
							 , M.COMPANY_ID
							 , M.SITE_ID
							 , M.PLANT_ID
							 , M.FACTORY_ID
							 , M.LINE_ID
							 , M.ELECTRODE_TYPE
							 , M.OPERATION_ID
							 , M.ITEM_ID		AS ITEM_ID
							 , B.WORK_MONTH		AS DAY_NAME
							 , B.UPDATE_ID
						  FROM #TMP_SCP0049_EXCEL_LOSS_UTIL_LOSS B
						  JOIN SCM_MST_TACT_TIME_SN M WITH(NOLOCK)
							ON M.COMPANY_ID		= B.COMPANY_ID
							AND M.DIVISION_ID		= B.DIVISION_ID
							AND M.SITE_ID			= B.SITE_ID
							AND M.PLANT_ID			= B.PLANT_ID
							AND M.FACTORY_ID		= B.FACTORY_ID
							AND M.OPERATION_ID		= B.OPERATION_ID
							AND M.LINE_ID			= B.LINE_ID
							AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
							AND M.MONTH				= B.WORK_MONTH
						;


						INSERT INTO @SCP0049_LOSS
						(
							  P_DATA_TABLE
							, P_DATA_TYPE
							, P_DIVISION_ID
							, P_COMPANY_ID
							, P_SITE_ID
							, P_PLANT_ID
							, P_FACTORY_ID
							, P_LINE_ID
							, P_ELECTRODE_TYPE
							, P_OPERATION_ID
							, P_ITEM_ID
							, P_DAY_NAME
							, P_UPDATE_ID
						)
						SELECT 'T'				AS DATA_TABLE
							 , 'D'				AS DATA_TYPE
							 , M.DIVISION_ID
							 , M.COMPANY_ID
							 , M.SITE_ID
							 , M.PLANT_ID
							 , M.FACTORY_ID
							 , M.LINE_ID
							 , M.ELECTRODE_TYPE
							 , M.OPERATION_ID
							 , M.ITEM_ID								AS ITEM_ID
							 , CONVERT(VARCHAR(8),M.START_TIME,112)		AS DAY_NAME
							 , B.UPDATE_ID
						  FROM #TMP_SCP0049_EXCEL_LOSS_UTIL_LOSS B
						  JOIN SCM_MST_TACT_TIME_EXCEPT_SN M WITH(NOLOCK)
							ON M.COMPANY_ID							= B.COMPANY_ID
						   AND M.DIVISION_ID						= B.DIVISION_ID
						   AND M.SITE_ID							= B.SITE_ID
						   AND M.PLANT_ID							= B.PLANT_ID
						   AND M.FACTORY_ID							= B.FACTORY_ID
						   AND M.OPERATION_ID						= B.OPERATION_ID
						   AND M.LINE_ID							= B.LINE_ID
						   AND M.ELECTRODE_TYPE						= B.ELECTRODE_TYPE
						   AND CONVERT(VARCHAR(6),M.START_TIME,112)	= B.WORK_MONTH
						;

						EXEC [dbo].[PR_SCP_CAPA_HIST_DATASET] @SCP0049_LOSS;



						-- 데이터 추가/수정
						MERGE INTO SCM_MST_TACT_TIME_SN M
						USING (
								SELECT COMPANY_ID
										, DIVISION_ID
										, SITE_ID
										, PLANT_ID
										, FACTORY_ID
										, OPERATION_ID
										, LINE_ID
										, ELECTRODE_TYPE
										, WORK_MONTH
										, LOSS_UTIL
										, TACT_DATA_TYPE
										, UPDATE_ID
									FROM #TMP_SCP0049_EXCEL_LOSS_UTIL_LOSS
								)B
								ON M.COMPANY_ID		= B.COMPANY_ID
							AND M.DIVISION_ID		= B.DIVISION_ID
							AND M.SITE_ID			= B.SITE_ID
							AND M.PLANT_ID			= B.PLANT_ID
							AND M.FACTORY_ID		= B.FACTORY_ID
							AND M.OPERATION_ID		= B.OPERATION_ID
							AND M.LINE_ID			= B.LINE_ID
							AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
							AND M.MONTH				= B.WORK_MONTH

							WHEN MATCHED THEN
								UPDATE SET
									TACT_TIME		=  CASE WHEN B.TACT_DATA_TYPE = 'DAILY CAPA' AND ISNULL(M.DAILY_CAPA,0) = 0 THEN 0
														WHEN B.TACT_DATA_TYPE = 'DAILY CAPA' THEN 86400/M.DAILY_CAPA * ISNULL(B.LOSS_UTIL,1)
														ELSE M.TACT_TIME END
								, DAILY_CAPA	=  CONVERT(INT,(CASE WHEN B.TACT_DATA_TYPE = 'TACT TIME' AND ISNULL(M.TACT_TIME,0) = 0 THEN 0
																	WHEN B.TACT_DATA_TYPE = 'TACT TIME' AND ISNULL(M.TACT_TIME,0) > 0 THEN ROUND(86400/M.TACT_TIME * ISNULL(B.LOSS_UTIL,1), 0)
																	ELSE M.DAILY_CAPA END
																	))
								, UPDATE_ID		= B.UPDATE_ID
								, UPDATE_TIME	= sysdatetime()
									;


						-- 데이터 저장
						MERGE INTO SCM_MST_TACT_TIME_EXCEPT_SN M
						USING (
								SELECT COMPANY_ID
									 , DIVISION_ID
									 , SITE_ID
									 , PLANT_ID
									 , FACTORY_ID
									 , OPERATION_ID
									 , LINE_ID
									 , ELECTRODE_TYPE
									 , WORK_MONTH
									 , LOSS_UTIL
									 , TACT_DATA_TYPE
									 , UPDATE_ID
								  FROM #TMP_SCP0049_EXCEL_LOSS_UTIL_LOSS
								) B
							 ON M.COMPANY_ID							= B.COMPANY_ID
							AND M.DIVISION_ID							= B.DIVISION_ID
							AND M.SITE_ID								= B.SITE_ID
							AND M.PLANT_ID								= B.PLANT_ID
							AND M.FACTORY_ID							= B.FACTORY_ID
							AND M.OPERATION_ID							= B.OPERATION_ID
							AND M.LINE_ID								= B.LINE_ID
							AND M.ELECTRODE_TYPE						= B.ELECTRODE_TYPE
							AND CONVERT(VARCHAR(6),M.START_TIME,112)	= B.WORK_MONTH

						WHEN MATCHED THEN
							UPDATE SET
								  TACT_TIME		=  CASE WHEN B.TACT_DATA_TYPE = 'DAILY CAPA' AND ISNULL(M.DAILY_CAPA,0) = 0 THEN 0
														WHEN B.TACT_DATA_TYPE = 'DAILY CAPA' THEN 86400/M.DAILY_CAPA * ISNULL(B.LOSS_UTIL,1)
														ELSE M.TACT_TIME END
								, DAILY_CAPA	=  CONVERT(INT , (CASE WHEN B.TACT_DATA_TYPE = 'TACT TIME' AND ISNULL(M.TACT_TIME,0) = 0 THEN 0
																		WHEN B.TACT_DATA_TYPE = 'TACT TIME' AND ISNULL(M.TACT_TIME,0) > 0 THEN ROUND(86400/M.TACT_TIME * ISNULL(B.LOSS_UTIL,1), 0)
																		ELSE M.DAILY_CAPA END
																 ))
								, UPDATE_ID		= B.UPDATE_ID
								, UPDATE_TIME	= sysdatetime()
								;
					END

				END

				/* #################################################### */
				/* SCM_MASTER_MANAGER_M_SN	CONFIRM 저장					*/
				/* #################################################### */
				BEGIN
				SET @v_log_error = 'CONFIRM';

				MERGE INTO SCM_MASTER_MANAGER_M_SN M
				USING (
						SELECT DISTINCT DIVISION_ID
							 , COMPANY_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , LINE_ID
							 , OPERATION_ID
							 , ELECTRODE_TYPE
							 , CREATED_BY
							 , FINISH
							 ,T.DATA_TYPE_1
							 , (SELECT SEGMENT1
								 FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
								WHERE 1=1
								  AND LV.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
								  AND LV.ACTIVE_FLAG = 'Y' 
								  AND LV.ATTRIBUTE1 = ( CASE WHEN T.DATA_TYPE_1 = 'DAILY CAPA' THEN 'TACT TIME' ELSE T.DATA_TYPE_1 END )
								  --AND LV.ATTRIBUTE2 = T.DATA_TYPE2
								) AS LOSS_CODE
						  FROM #TMP_SCP0049_DATA_EXCEL T
						 WHERE 1 = 1
						   AND T.DATA_TYPE_1 IN ('LINE ASSIGN','TACT TIME','DAILY CAPA','YIELD')
						  UNION ALL
						  SELECT DISTINCT DIVISION_ID
							 , COMPANY_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , LINE_ID
							 , OPERATION_ID
							 , ELECTRODE_TYPE
							 , CREATED_BY
							 , FINISH
							 ,T.DATA_TYPE_1
							 , (SELECT SEGMENT1
								 FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
								WHERE 1=1
								  AND LV.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
								  AND LV.ACTIVE_FLAG = 'Y' 
								  AND LV.ATTRIBUTE1 = T.DATA_TYPE_1
								  AND LV.ATTRIBUTE2 = T.DATA_TYPE_2
								) AS LOSS_CODE
						  FROM #TMP_SCP0049_DATA_EXCEL T
						 WHERE 1 = 1
						   AND T.DATA_TYPE_1 NOT IN ('LINE ASSIGN','TACT TIME','DAILY CAPA','YIELD')
						) B
						ON M.COMPANY_ID		= B.COMPANY_ID
					   AND M.DIVISION_ID	= B.DIVISION_ID
					   AND M.SITE_ID		= B.SITE_ID
					   AND M.PLANT_ID		= B.PLANT_ID
					   AND M.FACTORY_ID		= B.FACTORY_ID
					   AND M.OPERATION_ID	= B.OPERATION_ID
					   AND M.LINE_ID		= B.LINE_ID
					   AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					   AND M.LOSS_CODE		= B.LOSS_CODE

					WHEN MATCHED THEN
						UPDATE SET
						   CONFIRM_FLAG = B.FINISH
						 , CONFIRM_ID	= B.CREATED_BY
						 , CONFIRM_TIME = sysdatetime()
						 , UPDATE_ID	= B.CREATED_BY
						 , UPDATE_TIME	= sysdatetime()
					;
					
				END

				END  --//MERGE END
				SET @v_log_type = 'INSERT';
				SET @n_log_count = @n_log_count + 1;
				SET @v_log_message = '########## MERGE SCP0049 CAPA DATA END ##########';
				SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
				SET @d_event_date = SYSDATETIME();
				
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------
			END;

			COMMIT TRANSACTION SCP0049_CAPA_UPLOAD;

		END TRY
		BEGIN CATCH
			BEGIN
				ROLLBACK TRANSACTION SCP0049_CAPA_UPLOAD;
				
				SET @v_log_error = @v_log_error + ' ::  '  + ERROR_MESSAGE();

				INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
				VALUES (ERROR_PROCEDURE(),'ERROR',NULL,@v_log_error,NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
			END;
		END CATCH
				
		BEGIN
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## INSERT/UPDATE SCP0049 CAPA DATA END ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

	END;

	BEGIN
		SET @v_log_type = 'INSERT';
		SET @n_log_count = @n_log_count + 1;
		SET @v_log_message = '########## INSERT DATA END ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END;

	BEGIN
		SET @v_log_type = 'END';
		SET @n_log_count = @n_log_count + 1;
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END;

	
END;
