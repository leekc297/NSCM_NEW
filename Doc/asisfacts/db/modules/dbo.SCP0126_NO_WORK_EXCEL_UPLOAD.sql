
/*
 * Program ID   : SCP0126_NO_WORK_EXCEL_UPLOAD
 * Description  : SCP0126_NO_WORK_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2025-07-23	mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025-08-21	mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - EE 사업부 엑셀업로드 불가
 * 2025-08-26	mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 사업부별 유효한 Operation 인지 체크
 * 2025/10/13   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 비조업 일괄입력 기능 추가
 * 2025/11/05   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Line Type 추가, 엑셀 업로드할때 YYYY-MM-DD도 처리되도록 변경
 * 2025/12/04   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Week 단위 조회 및 입력 방식 추가
 * 2026/06/30	YMH				E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
 * 2026/06/30	YMH				E20260714-000542 최적화 비조업 등록 Validation 로직 수정 요청의 건(OPT CAPA → No Work)
 * 2026/10/08	ymh				E20260929-000580 비조업 로직 수정 요청의 건(OPT CAPA - No Work)
 */

 CREATE PROCEDURE [dbo].[SCP0126_NO_WORK_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)
AS

BEGIN
	SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'SCP0126';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'No Work';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0126_NO_WORK_EXCEL_UPLOAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

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

	IF ISNULL(@p_mode, 0) = 0 BEGIN

		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'UPLOAD'
				 , MESSAGE_TEXT       = NULL             
			FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
			WHERE  T.PROGRAM_ID    = @v_program_id
			AND    T.SHEET_NAME    = @v_sheet_name
			AND    T.CREATED_BY    = @p_created_by
			AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
			AND    ISNULL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD';

			------------------------------------------------------------------------
			SET @v_log_type = '1';
			SET @v_log_message = '########## RESET Status = UPLOAD ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
    	END;

		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'SKIP'
			WHERE  PROGRAM_ID    = @v_program_id
			AND    SHEET_NAME    = @v_sheet_name
			AND    CREATED_BY    = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    (ISNULL(ATTRIBUTE1,'')='') ;

			------------------------------------------------------------------------
			SET @v_log_type = '2';
			SET @v_log_message = '########## SKIP EMPTY LINE ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
		END;

		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = '@TITLE'
			WHERE  PROGRAM_ID    = @v_program_id
			AND    SHEET_NAME    = @v_sheet_name
			AND    CREATED_BY    = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    (UPPER(ATTRIBUTE1) = 'DIV*' OR UPPER(ATTRIBUTE1) = 'DIV' OR UPPER(ATTRIBUTE1) = 'DIVISION');
		
			------------------------------------------------------------------------
			SET @v_log_type = '3';
			SET @v_log_message = '########## TITLE Header Line ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
        END;

		/* #################################################### */
		/* 필수 값 NULL 값 체크									*/
		/* ATTRIBUTE2  : Plant ID*								*/
		/* ATTRIBUTE3  : Line ID*								*/
		/* ATTRIBUTE4  : Operation ID*							*/
		/* ATTRIBUTE5  : Line Type*								*/
		/* ATTRIBUTE6  : Date(YYYYMMDD)*						*/
		/* ATTRIBUTE7  : Off Time(Sec)							*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Column Data.'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND    (ISNULL(ATTRIBUTE2,'')='' OR ISNULL(ATTRIBUTE3,'')='' OR ISNULL(ATTRIBUTE4,'')='' OR ISNULL(ATTRIBUTE5,'')='' OR ISNULL(ATTRIBUTE6,'')='' OR ISNULL(ATTRIBUTE7,'')='');	--[PJ20257329] Line Type 추가 (2025-11-05)
			
			------------------------------------------------------------------------
			SET @v_log_type = '4';
			SET @v_log_message = '########## ERROR Invalid Column Data ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
		END;

		/* ######################################################################## */
		/* Div, Plant ID, Line ID, Operation ID, Date(YYYYMMDD)에 대한 중복키 체크	*/
		/* ######################################################################## */
		BEGIN


			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Duplication Key.'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND EXISTS (SELECT 1
						FROM  (SELECT X.ATTRIBUTE1 AS COL1	-- Div
									, X.ATTRIBUTE2 AS COL2	-- Plant ID
									, X.ATTRIBUTE3 AS COL3	-- Line ID
									, X.ATTRIBUTE4 AS COL4	-- Operation ID
									-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 기존로직 주석처리.
									-- , X.ATTRIBUTE5 AS COL5	-- Line Type			--[PJ20257329] Line Type 추가 (2025-11-05)
									-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 시작
									, CASE WHEN X.ATTRIBUTE1 LIKE '%EE%' THEN X.ATTRIBUTE5 ELSE '-' END AS COL5	
									-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 끝
									, X.ATTRIBUTE6 AS COL6	-- Date(YYYYMMDD)
									, IIF(X.ATTRIBUTE8 IS NULL OR X.ATTRIBUTE8 = '','-',X.ATTRIBUTE8) AS COL8	-- E20260929-000580 TYPE
							   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
							   WHERE  X.PROGRAM_ID    = @v_program_id
							   AND    X.SHEET_NAME    = @v_sheet_name
							   AND    X.CREATED_BY    = @p_created_by
							   AND    CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
							   AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
							   GROUP BY X.ATTRIBUTE1
									  , X.ATTRIBUTE2
									  , X.ATTRIBUTE3
									  , X.ATTRIBUTE4
									  -- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 기존로직 주석처리.
									  --, X.ATTRIBUTE5 --[PJ20257329] Line Type 추가 (2025-11-05)
									  -- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 시작
									  , CASE WHEN X.ATTRIBUTE1 LIKE '%EE%' THEN X.ATTRIBUTE5 ELSE '-' END
									  -- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 끝
									  , X.ATTRIBUTE6	
									  , IIF(X.ATTRIBUTE8 IS NULL OR X.ATTRIBUTE8 = '','-',X.ATTRIBUTE8) -- E20260929-000580
							   HAVING COUNT(*) > 1 ) T
						WHERE 1 = 1										 
	 					AND T.COL1 = ATTRIBUTE1
						AND T.COL2 = ATTRIBUTE2
						AND T.COL3 = ATTRIBUTE3
						AND T.COL4 = ATTRIBUTE4
						-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 기존로직 주석처리.
						-- AND T.COL5 = ATTRIBUTE5 --[PJ20257329] Line Type 추가 (2025-11-05)
						-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 시작
						AND T.COL5 = CASE WHEN ATTRIBUTE1 LIKE '%EE%' THEN ATTRIBUTE5 ELSE '-' END
						-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 끝
						AND T.COL6 = ATTRIBUTE6			
						AND T.COL8 = IIF(ATTRIBUTE8 IS NULL OR ATTRIBUTE8 = '','-',ATTRIBUTE8)-- E20260929-000580
					   );
				   
			------------------------------------------------------------------------
			SET @v_log_type = '5';
			SET @v_log_message = '########## ERROR Key Duplication ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
		END;
			
		/* #################################################### */
		/* Division 체크											*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Division.'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND NOT EXISTS (SELECT 1
							FROM   [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
							WHERE  D.VALID_YN    = 'Y'
							AND    D.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
							union
							SELECT 1
							FROM   [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
							WHERE  D.VALID_YN    = 'Y'
							AND    D.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
						   );
						   
			------------------------------------------------------------------------
			SET @v_log_type = '6';
			SET @v_log_message = '########## Invalid Division ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
		END;

			
		/* #################################################### */
		/* Plant ID 체크											*/
		/* #################################################### */
		BEGIN
			--[PJ20257329] EE 사업부 엑셀업로드 불가(2025-08-21) START
			--UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			--SET    UPLOAD_STATUS_CODE = 'ERROR'
			--	 , MESSAGE_TEXT       = 'Invalid Plant ID.'
			--WHERE  PROGRAM_ID         = @v_program_id
			--AND    SHEET_NAME         = @v_sheet_name
			--AND    CREATED_BY         = @p_created_by
			--AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			--AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			--AND NOT EXISTS (SELECT 1
			--				FROM   [dbo].[SCM_MST_SITE] S      WITH(NOLOCK)
			--					  ,[dbo].[SCM_MST_DIVISION] D2 WITH(NOLOCK)
			--				WHERE  S.DIVISION_ID = D2.DIVISION_ID
			--				AND    S.SITE_TYPE  IN ('PLANT')
			--				AND    S.PLANT_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
			--				and   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 )
			--				AND    S.VALID_YN    = 'Y');
			if object_id('tempdb..#division_info') is not null drop table #division_info;

			select d.division_id
					 , r.division_id	as org_division_id 
					 , d.attribute3		as division_dv
			INTO #division_info
			from scm_mst_division d with(nolock)
					inner join scm_mst_division r with(nolock)
							on d.attribute4 = r.attribute4
							and ( (d.attribute3 != 'EE' and d.division_id = r.division_id)
								or
								(d.attribute3 = 'EE'  and r.attribute3 != 'EE') 
								) 
			where 1=1
				and d.valid_yn = 'Y'
				and r.valid_yn = 'Y'

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Plant ID.'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND NOT EXISTS (SELECT 1
							FROM   [dbo].[SCM_MST_SITE] S      WITH(NOLOCK)
								  , #division_info D2 WITH(NOLOCK)
							WHERE  S.DIVISION_ID = D2.org_division_id
							AND    S.SITE_TYPE  IN ('PLANT')
							AND    S.PLANT_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
							and   ( D2.division_id = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 )
							AND    S.VALID_YN    = 'Y');
			--[PJ20257329] EE 사업부 엑셀업로드 불가(2025-08-21) END
							
			------------------------------------------------------------------------
			SET @v_log_type = '7';
			SET @v_log_message = '########## Invalid Plant ID. ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
		END;


		/* #################################################### */
		/* LINE ID 체크											*/
		/* #################################################### */
		BEGIN
			--[PJ20257329] EE 사업부 엑셀업로드 불가(2025-08-21) START
			--UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			--   SET UPLOAD_STATUS_CODE = 'ERROR'
			--	 , MESSAGE_TEXT       = 'Invalid Line ID'
			-- WHERE PROGRAM_ID         = @v_program_id
			--   AND SHEET_NAME         = @v_sheet_name
			--   AND CREATED_BY         = @p_created_by
			--   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			--   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			--   AND NOT EXISTS  (  SELECT 1
			--						FROM SCM_LINE_HIERARCHY_V_SN LH WITH(NOLOCK)
			--					   WHERE 1 = 1
			--						 AND LH.DIVISION_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
			--						 AND LH.PLANT_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
			--						 AND LH.LINE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
			--						 AND LH.OPERATION_ID	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
			--						)	 ;
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Line ID'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_LINE_HIERARCHY_V_SN LH WITH(NOLOCK)
									    , #division_info D2 WITH(NOLOCK)
								   WHERE 1 = 1
								     AND LH.DIVISION_ID		= D2.org_division_id
									 AND D2.DIVISION_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
									 AND LH.PLANT_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
									 AND LH.LINE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
									 AND LH.OPERATION_ID	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
									)	 ;
			
			--[PJ20257329] EE 사업부 엑셀업로드 불가(2025-08-21) END

			SET @v_log_type = '8';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Line ID. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;


		/* #################################################### */
		/* OPERATION ID 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Operation ID.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_LINE_HIERARCHY_V_SN LH WITH(NOLOCK)
									--[PJ20257329]사업부별 유효한 Operation인지 체크(2025-08-26) START
								    LEFT JOIN scm_adm_lookup_master_detail ld WITH(NOLOCK)
									  ON ld.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION' AND ld.valid_yn = 'Y' AND ld.SEGMENT1 = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
								   WHERE 1 = 1									 
									 AND LH.OPERATION_ID	= ld.SEGMENT2	
									 --[PJ20257329]사업부별 유효한 Operation인지 체크(2025-08-26) END
									 AND LH.LINE_ID			= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
									 AND LH.OPERATION_ID	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
									)	 ;

			SET @v_log_type = '9';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Line Operation ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04) START
		/* #################################################### */
		/* Line Type 체크											*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Line Type.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE4 = 'A5000'
			   AND replace(ISNULL(ATTRIBUTE5,''), '', '-') = '-'	-- Operation이 A5000일 때, Line Type에 "-" 로 업로드
			   ;

			SET @v_log_type = '9';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Line Operation ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
		--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04) END
			
		/* #################################################### */
		/* Date 체크												*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Date.'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND	   1 =  (CASE WHEN TRY_CONVERT(DATE, replace(ATTRIBUTE6,'-',''), 112) IS NOT NULL THEN 0	--'유효한 날짜'		--[PJ20257329] Line Type 추가, 엑셀 업로드할때 YYYY-MM-DD도 처리되도록 변경 (2025-11-05)
							ELSE 1	--'유효하지 않은 날짜'
							END)
			--AND	   (ISNULL(ATTRIBUTE4,'')='' OR len(substring(replace(replace(ISNULL(ATTRIBUTE4,''),' ',''),'-',''),1,8))!=8)
			
			----------------------------------------------------------------------
			SET @v_log_type = '10';
			SET @v_log_message = '########## Invalid Date ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------
		END;


		/* #################################################### */
		/* Off Time(Sec) 체크									*/
		/* #################################################### */
		BEGIN

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Off Time(Sec).'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			--AND    (isnumeric(ATTRIBUTE7) = 0 OR CHARINDEX('.', ATTRIBUTE7) > 0 OR CONVERT(INT, ATTRIBUTE7) < 0)	--[PJ20257329] Line Type 추가 (2025-11-05)
			AND    (isnumeric(ATTRIBUTE7) = 0 OR CONVERT(NUMERIC(20,10), ATTRIBUTE7) < 0)	--[PJ20257329] Line Type 추가 (2025-11-05)	--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)
		
			-- E20260929-000580 SUM 한 값이 1보다 크면 오류
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Off Time(Sec).'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND EXISTS (SELECT 1
						FROM  (SELECT X.ATTRIBUTE1 AS COL1	-- Div
									, X.ATTRIBUTE2 AS COL2	-- Plant ID
									, X.ATTRIBUTE3 AS COL3	-- Line ID
									, X.ATTRIBUTE4 AS COL4	-- Operation ID
									-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 기존로직 주석처리.
									-- , X.ATTRIBUTE5 AS COL5	-- Line Type			--[PJ20257329] Line Type 추가 (2025-11-05)
									-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 시작
									, CASE WHEN X.ATTRIBUTE1 LIKE '%EE%' THEN X.ATTRIBUTE5 ELSE '-' END AS COL5	
									-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 끝
									, X.ATTRIBUTE6 AS COL6	-- Date(YYYYMMDD)
							   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
							   WHERE  X.PROGRAM_ID    = @v_program_id
							   AND    X.SHEET_NAME    = @v_sheet_name
							   AND    X.CREATED_BY    = @p_created_by
							   AND    CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
							   AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
							   AND    ISNUMERIC(ATTRIBUTE7) > 0 
							   GROUP BY X.ATTRIBUTE1
									  , X.ATTRIBUTE2
									  , X.ATTRIBUTE3
									  , X.ATTRIBUTE4
									  -- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 기존로직 주석처리.
									  --, X.ATTRIBUTE5 --[PJ20257329] Line Type 추가 (2025-11-05)
									  -- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 시작
									  , CASE WHEN X.ATTRIBUTE1 LIKE '%EE%' THEN X.ATTRIBUTE5 ELSE '-' END
									  -- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 끝
									  , X.ATTRIBUTE6	
							   HAVING SUM(CONVERT(INT, ROUND(CONVERT(NUMERIC(20,10) , replace(replace(ISNULL(X.ATTRIBUTE7,''),' ',''),',','')) * 86400, 1))) > 86400 ) T
						WHERE 1 = 1										 
	 					AND T.COL1 = ATTRIBUTE1
						AND T.COL2 = ATTRIBUTE2
						AND T.COL3 = ATTRIBUTE3
						AND T.COL4 = ATTRIBUTE4
						-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 기존로직 주석처리.
						-- AND T.COL5 = ATTRIBUTE5 --[PJ20257329] Line Type 추가 (2025-11-05)
						-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 시작
						AND T.COL5 = CASE WHEN ATTRIBUTE1 LIKE '%EE%' THEN ATTRIBUTE5 ELSE '-' END
						-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 끝
						AND T.COL6 = ATTRIBUTE6			
					   );

			--UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			--SET    UPLOAD_STATUS_CODE = 'ERROR'
			--	 , MESSAGE_TEXT       = 'Invalid Off Time(Sec).'
			--WHERE  PROGRAM_ID         = @v_program_id
			--AND    SHEET_NAME         = @v_sheet_name
			--AND    CREATED_BY         = @p_created_by
			--AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			--AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			--AND    CHARINDEX('.', ATTRIBUTE6) > 0;
			
			--UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			--SET    UPLOAD_STATUS_CODE = 'ERROR'
			--	 , MESSAGE_TEXT       = 'Invalid Off Time(Sec).'
			--WHERE  PROGRAM_ID         = @v_program_id
			--AND    SHEET_NAME         = @v_sheet_name
			--AND    CREATED_BY         = @p_created_by
			--AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			--AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			--AND    CONVERT(INT, ATTRIBUTE6) < 0;
			
			SET @v_log_type = '11';
			SET @v_log_message = '########## Invalid Off Time(Sec). ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END;

		/* #################################################### */
		/* Type 유효성 체크									*/
		/* #################################################### */
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Type is invalid.'
		WHERE  PROGRAM_ID         = @v_program_id
		AND    SHEET_NAME         = @v_sheet_name
		AND    CREATED_BY         = @p_created_by
		AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
		AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		AND	   NOT EXISTS  (   SELECT *
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD WITH(NOLOCK)
							WHERE LMD.LOOKUP_TYPE = 'NO_WORK_TYPE' 
							AND LMD.VALID_YN = 'Y'
							AND LMD.SEGMENT1 = CASE WHEN IIF(SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8 IS NULL OR SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8 = '','-',SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8) = '-' THEN LMD.SEGMENT1 ELSE SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8 END
						);

			SET @v_log_type = '11.5';
			SET @v_log_message = '########## Type is invalid.. ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'SUCCESS'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD';
			
			SET @v_log_type = '12';
			SET @v_log_message = '########## SUCCESS ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END;

	END;

	BEGIN
		----------------------------------------------------------------------------
		SET @v_log_type = '13';
		SET @v_log_message = '########## INSERT DATA START ##########';
		SET @v_description = @p_mode; 
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		----------------------------------------------------------------------------
	END;


    SELECT @v_count = COUNT(1)
    FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
    WHERE  T.PROGRAM_ID         = @v_program_id
    AND    T.SHEET_NAME         = @v_sheet_name
    AND    T.CREATED_BY         = @p_created_by
    AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
    AND    T.UPLOAD_STATUS_CODE = 'ERROR' ;

	-- Update Mode and No Errors
	IF @p_mode > 0 AND @v_count = 0	BEGIN

		BEGIN
			----------------------------------------------------------------------------
			SET @v_log_type = '14';
			SET @v_log_message = '########## INSERT/UPDATE NO WORK DATA START ##########';
			SET @v_description = @p_mode; 
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------
		END;

		BEGIN TRANSACTION NO_WOR_UPLOAD;
		BEGIN TRY
			
			BEGIN
				SET @v_log_type = '14-1';
				SET @v_log_message = '########## DELETE NO WORK DATA START ##########';
				SET @v_description = @p_mode; 
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				--엑셀 업로드한 데이터 전부 삭제
				--E20260929-000580 입력한 TYPE 구분없이 전체 삭제 
				DELETE FROM S
				FROM [dbo].[SCP_OPMZ_NO_WORK] S
				JOIN [dbo].[SCM_ADM_EXCEL_UPLOAD] T
					ON S.DIVISION_ID			= T.ATTRIBUTE1
					AND S.PLANT_ID				= T.ATTRIBUTE2
					AND S.LINE_ID				= T.ATTRIBUTE3
					AND S.OPERATION_ID			= T.ATTRIBUTE4
					-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 기존로직 주석처리
					--AND S.LINE_TYPE				= T.ATTRIBUTE5		--[PJ20257329] Line Type 추가 (2025-11-05)
					-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 시작
					AND 
						CASE WHEN S.DIVISION_ID LIKE '%EE%' THEN S.LINE_TYPE ELSE '-' END
						= CASE WHEN T.ATTRIBUTE1 LIKE '%EE%' THEN T.ATTRIBUTE5 ELSE '-' END
					-- E20260714-000542 전극이 아니면 라인타입 비교없이 삭제 신규로직 끝
					AND S.NO_WORK_DATE			= replace(replace(ISNULL(T.ATTRIBUTE6,''),' ',''),'-','')
				WHERE 1=1
					AND T.PROGRAM_ID			= @v_program_id
					AND T.SHEET_NAME			= @v_sheet_name
					AND T.CREATED_BY			= @p_created_by
					AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
					AND T.UPLOAD_STATUS_CODE = 'SUCCESS' 
				;

				SET @v_log_type = '14-2';
				SET @v_log_message = '########## DELETE NO WORK DATA END ##########';
				SET @v_description = @p_mode; 
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			END;
			

			BEGIN

				----------------------------------------------------------------------------
				SET @v_log_type = '14-3';
				SET @v_log_message = '########## INSERT NO WORK DATA START ##########';
				SET @v_description = @p_mode; 
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				----------------------------------------------------------------------------

				INSERT INTO [dbo].[SCP_OPMZ_NO_WORK]
				(
					DIVISION_ID
				  , PLANT_ID
				  , LINE_ID
				  , OPERATION_ID
				  , LINE_TYPE			--[PJ20257329] Line Type 추가 (2025-11-05)
				  , NO_WORK_DATE
				  , OFF_TIME
				  , [TYPE]				-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) -- E20260929-000580 ATTRIBUTE2 -> TYPE 변경
				  , [DESC]
				  , VALID_YN
				  , ATTRIBUTE1			--FIX [PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
				  , CREATED_BY
				  , CREATION_DATE
				  , LAST_UPDATED_BY
				  , LAST_UPDATE_DATE
				)			
				SELECT T.ATTRIBUTE1		--DIVISION_ID
					 , T.ATTRIBUTE2		--PLANT_ID
					 , T.ATTRIBUTE3		--LINE_ID
					 , T.ATTRIBUTE4		--OPERATION_ID
					 , replace(ISNULL(T.ATTRIBUTE5,''), '', '-')				--LINE_TYPE		[PJ20257329] Line Type 추가 (2025-11-05)
					 , replace(replace(ISNULL(T.ATTRIBUTE6,''),' ',''),'-','')	--NO_WORK_DATE	[PJ20257329] 엑셀 업로드할때 YYYY-MM-DD도 처리되도록 변경 (2025-11-05)
					 , CONVERT(INT, ROUND(CONVERT(NUMERIC(20,10) , replace(replace(ISNULL(T.ATTRIBUTE7,''),' ',''),',','')) * 86400, 1))	--OFF_TIME	-- 소수점 1자리 반올림	--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)

					 -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) 주석시작
					 -- , T.ATTRIBUTE8		--[DESC]
					 --, CASE WHEN ISNULL(T.ATTRIBUTE9, '') = '' THEN 'Y' ELSE T.ATTRIBUTE9 END	--VALID_YN, [PJ20257329]Valid 공백일 경우 Y값으로 변경(2025-08-26)
					 -- , T.ATTRIBUTE10		--ATTRIBUTE1 AS [FIX]	[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
					 -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) 주석끝
					 -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) 수정로직 시작
					 , T.ATTRIBUTE8																	--[TYPE]
					 , T.ATTRIBUTE9																	--[DESC]
					 , CASE WHEN ISNULL(T.ATTRIBUTE10, '') = '' THEN 'Y' ELSE T.ATTRIBUTE10 END		--VALID_YN
					 , T.ATTRIBUTE11																--[FIX]
					 -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) 수정로직 끝
					 
					 
					 , @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
					 , @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
				FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T WITH(NOLOCK)
				WHERE T.PROGRAM_ID         = @v_program_id
				  AND T.SHEET_NAME         = @v_sheet_name
				  AND T.CREATED_BY         = @p_created_by
				  AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
				  AND T.UPLOAD_STATUS_CODE = 'SUCCESS' 
				  AND NOT EXISTS( SELECT 'X'
									FROM [dbo].[SCP_OPMZ_NO_WORK] S
								   WHERE S.DIVISION_ID	= T.ATTRIBUTE1
									 AND S.PLANT_ID		= T.ATTRIBUTE2
									 AND S.LINE_ID		= T.ATTRIBUTE3
									 AND S.OPERATION_ID	= T.ATTRIBUTE4
									 AND S.LINE_TYPE	= T.ATTRIBUTE5		--[PJ20257329] Line Type 추가 (2025-11-05)
									 AND S.NO_WORK_DATE	= replace(replace(ISNULL(T.ATTRIBUTE6,''),' ',''),'-','')
								);

				----------------------------------------------------------------------------
				SET @v_log_type = '14-4';
				SET @v_log_message = '########## INSERT NO WORK DATA END ##########';
				SET @v_description = @p_mode; 
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				----------------------------------------------------------------------------
			END;

		            
		    COMMIT TRANSACTION NO_WOR_UPLOAD;

		
        END TRY
		BEGIN CATCH
			BEGIN
				ROLLBACK TRANSACTION NO_WOR_UPLOAD;
						
				INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
				VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
			END;
		END CATCH
				
		BEGIN
			----------------------------------------------------------------------------
			SET @v_log_type = '15';
			SET @v_log_message = '########## INSERT/UPDATE NO WORK DATA END ##########';
			SET @v_description = @p_mode; 
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------
		END;

	END;


	BEGIN
    ----------------------------------------------------------------------------
	SET @v_log_type = 'END';
	SET @v_log_message = '########## INSERT DATA END ##########';
	SET @v_description = @p_mode; 
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
	END;

END