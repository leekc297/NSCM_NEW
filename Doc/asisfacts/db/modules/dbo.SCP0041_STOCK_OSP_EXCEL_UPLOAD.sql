
/*
 * Program ID   : SCP0041_STOCK_OSP_EXCEL_UPLOAD
 * Description  : SCP0041_STOCK_OSP_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2018.12.26	hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.07.12	hwyoon			Plant Validation -> Plant/Sales로 변경
 * 2019.07.19	hwyoon			[CSR ID:4043239] Stock OSP 자체개선 - 조회조건(날짜) 추가
 * 2022.05.10	jahn1501		PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - Item 체크 로직 추가
 * 2024/06/05   mrchois			PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - Valuation Type 컬럼추가
 * 2024/08/21   mrchois			PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - Cell From Site 컬럼추가
 * 2024/10/21   mrchois			PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화 - Box 컬럼추가
 */

 CREATE PROCEDURE [dbo].[SCP0041_STOCK_OSP_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)
AS

BEGIN
    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'SCP0041';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'Osp Stock';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0041_STOCK_OSP_EXCEL_UPLOAD';
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
	--  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
		 
	IF @v_creation_date IS NULL BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'Data Not Found [' + CONVERT(CHAR(19), @v_creation_date, 121) +']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END;

	-- @p_mode = 0 이면 Validation
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
    	END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
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
		END;

	    BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
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
        END;
     
		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
		SET @v_log_type = '3';
		SET @v_log_message = '########## TITLE Header Line ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;


		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Column Data.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        --AND    (ISNULL(ATTRIBUTE2,'')='' OR ISNULL(ATTRIBUTE3,'')='' OR ISNULL(ATTRIBUTE4,'')='' OR ISNULL(ATTRIBUTE5,'')='');
		AND    (ISNULL(ATTRIBUTE2,'')='' OR ISNULL(ATTRIBUTE3,'')='' OR ISNULL(ATTRIBUTE4,'')='' OR ISNULL(ATTRIBUTE6,'')='');--VALUATION TYPE 추가
		END;


		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
		SET @v_log_type = '4';
		SET @v_log_message = '########## ERROR Invalid Column Data ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;


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
		            FROM  (SELECT X.ATTRIBUTE1 AS COL1
                                , X.ATTRIBUTE2 AS COL2
                                , X.ATTRIBUTE3 AS COL3
                                , X.ATTRIBUTE4 AS COL4
                                , X.ATTRIBUTE5 AS COL5	-- Valuation Type 컬럼추가
                                --, X.ATTRIBUTE6 AS COL6
                                , X.ATTRIBUTE7 AS COL7	-- Cell From Site 컬럼추가
                                --, X.ATTRIBUTE8  AS COL8
 	                            --, X.ATTRIBUTE9  AS COL9
			                    --, X.ATTRIBUTE10 AS COL10
								--, X.ATTRIBUTE11 AS COL11
								--, X.ATTRIBUTE12 AS COL12
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
                                  , X.ATTRIBUTE5	-- Valuation Type 컬럼추가
                                  --, X.ATTRIBUTE6
                                  , X.ATTRIBUTE7	-- Cell From Site 컬럼추가
                                  --, X.ATTRIBUTE8 
		                          --, X.ATTRIBUTE9 
			                      --, X.ATTRIBUTE10
								  --, X.ATTRIBUTE11
								  --, X.ATTRIBUTE12
                           HAVING COUNT(*) > 1 ) T
					WHERE 1 = 1										 
	 			    AND T.COL1 = ATTRIBUTE1
                    AND T.COL2 = ATTRIBUTE2
                    AND T.COL3 = ATTRIBUTE3
                    AND T.COL4 = ATTRIBUTE4
                    AND T.COL5 = ATTRIBUTE5	-- Valuation Type 컬럼추가
                    --AND T.COL6 = ATTRIBUTE6
                    AND T.COL7 = ATTRIBUTE7	-- Cell From Site 컬럼추가
                    --AND T.COL8 = ATTRIBUTE8
			        --AND T.COL9  =ATTRIBUTE9
		            --AND T.COL10 = ATTRIBUTE10 
					--AND T.COL11 = ATTRIBUTE11
					--AND T.COL12 = ATTRIBUTE12
				   );
		END

		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
		SET @v_log_type = '5';
		SET @v_log_message = '########## ERROR Key Duplication ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
			
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
		END;

		BEGIN -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    ATTRIBUTE1 = (
								SELECT D.DIVISION_ID
								FROM   [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
								WHERE  D.VALID_YN    = 'Y'
								AND    D.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
		                     )
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					   );
		END;

		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
		SET @v_log_type = '6';
	    SET @v_log_message = '########## Invalid Division ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;


		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Date.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		AND	   (ISNULL(ATTRIBUTE4,'')='' OR len(substring(replace(replace(ISNULL(ATTRIBUTE4,''),' ',''),'-',''),1,8))!=8)
		END;


		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    ATTRIBUTE4 = substring(replace(replace(ISNULL(ATTRIBUTE4,''),' ',''),'-',''),1,8)
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		END;


		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
		SET @v_log_type = '7';
	    SET @v_log_message = '########## Invalid Date ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
				
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Plant/Sales Site.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_MST_SITE] S      WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION] D2 WITH(NOLOCK)
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
						--AND    S.SITE_TYPE = 'PLANT'
						AND    S.SITE_TYPE  IN ('PLANT','SALES')
						AND    (S.SITE_TYPE = 'SALES' OR S.OSP_YN='Y')
						AND   ( S.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 or S.SITE_DESCRIPTION = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 )
						and   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 )
                        AND    S.VALID_YN    = 'Y');
		END;


		BEGIN -- Plant Site Validation은 끝났으니 코드로 정보를 치환해줌.
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    ATTRIBUTE2 = (
								--SELECT D.SCM_SITE_ID
								SELECT TOP(1) D.SCM_SITE_ID
								FROM   [dbo].[SCM_MST_SITE] D  WITH(NOLOCK)
								WHERE  D.VALID_YN    = 'Y'
								--AND    D.SITE_TYPE = 'PLANT'
								AND    D.SITE_TYPE IN ('PLANT','SALES')
								AND    D.SITE_DESCRIPTION = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
		                     )
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_MST_SITE] D  WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
						--AND    D.SITE_TYPE = 'PLANT'
						AND    D.SITE_TYPE IN ('PLANT','SALES')
                        AND    D.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					   );
		END;


		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		SET @v_log_type = '8';
	    SET @v_log_message = '########## Invalid Plant Site. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		--TODO. ITEM체크 필요
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Item.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                          FROM [dbo].[SCM_MST_DIVISION] D WITH(NOLOCK)
						      ,[dbo].[SCP_MST_FINAL_ITEM] I WITH(NOLOCK)
                         WHERE D.DIVISION_ID = I.DIVISION_ID                        
						   AND (D.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 )
						   AND (I.ITEM_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3)
						   );
		END;
	
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    ATTRIBUTE3 = (
								SELECT I.ITEM_ID 
								FROM   [dbo].[SCP_MST_FINAL_ITEM] I WITH(NOLOCK)
								WHERE  I.ITEM_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
		                     )
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                          FROM [dbo].[SCP_MST_FINAL_ITEM] I WITH(NOLOCK)
                         WHERE I.ITEM_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
					   );        
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Qty.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        --AND    isnumeric(ATTRIBUTE5)=0;
		AND    isnumeric(ATTRIBUTE6)=0;--VALUATION TYPE 추가
		END;


		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Qty.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        --AND    CHARINDEX('.', ATTRIBUTE5)>0;
        AND    CHARINDEX('.', ATTRIBUTE6)>0;--VALUATION TYPE 추가
		END;


		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Qty.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        --AND    CONVERT(INT, ATTRIBUTE5)<0;
		AND    CONVERT(INT, ATTRIBUTE6)<0;--VALUATION TYPE 추가
		END;


		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		SET @v_log_type = '9';
	    SET @v_log_message = '########## Invalid Qty. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		-- Cell From Site 컬럼추가에 대한 체크 추가 mrchois 2024-08-21 START --
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Valuation Type.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		AND    ISNULL(ATTRIBUTE5, '') NOT IN ('', 'PUR', 'PRD');--VALUATION TYPE에 NULL(공란), PUR, PRD 외의 값일 경우 ERROR
		END;

		BEGIN
        ------------------------------------------------------------------------
        SET @v_log_type = '9-1';
	    SET @v_log_message = '########## Invalid Valuation Type. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Cell From Site.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		AND	   ISNULL([dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7, '') != ''	-- 공백이 아니고 plant site에 등록된 PLANT_ID 이외의 값일 경우 , ERROR
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_MST_SITE] S      WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION] D2 WITH(NOLOCK)
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
						AND    S.SITE_TYPE = 'PLANT'
						AND   S.PLANT_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
						AND   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 )
                        AND    S.VALID_YN    = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        SET @v_log_type = '9-2';
	    SET @v_log_message = '########## Invalid Cell From Site. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		-- Cell From Site 컬럼추가에 대한 체크 추가 mrchois 2024-08-21 END   --

		-- Box 컬럼추가에 대한 체크 추가 mrchois 2024-10-21 START
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Box.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		AND    ISNULL(ATTRIBUTE9, '') NOT IN ('', 'C', 'R');--Box에 NULL(공란), C, R 외의 값일 경우 ERROR
		END;

		BEGIN
        ------------------------------------------------------------------------
        SET @v_log_type = '9-3';
	    SET @v_log_message = '########## Invalid Box. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		-- Box 컬럼추가에 대한 체크 추가 mrchois 2024-10-21 END

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';
		END;

		BEGIN
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	    SET @v_log_type = '10';
	    SET @v_log_message = '########## SUCCESS ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
		END;

	END;

	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = '11';
	SET @v_log_message = '########## INSERT DATA START ##########';
	SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
	END;

	--// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
    --//======================================================================================
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
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '12';
		SET @v_log_message = '########## INSERT/UPDATE STOCK OSP DATA START ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
		END;


		BEGIN TRANSACTION STOCK_OSP_UPLOAD;
		BEGIN TRY
			BEGIN

			----------------------------------------------------------------------------
			--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
			SET @v_log_type = '12-1';
			SET @v_log_message = '########## DELETE STOCK OSP DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------

			DELETE FROM S
			FROM [dbo].[SCM_DNM_STOCK_OSP] S
				 ,[dbo].[SCM_ADM_EXCEL_UPLOAD] T
			WHERE S.DIVISION_ID = T.ATTRIBUTE1
			  AND S.SCM_SITE_ID = T.ATTRIBUTE2
			  AND S.YYYYMMDD	= replace(replace(ISNULL(T.ATTRIBUTE4,''),' ',''),'-','')
			  AND T.PROGRAM_ID         = @v_program_id
			  AND T.SHEET_NAME         = @v_sheet_name
			  AND T.CREATED_BY         = @p_created_by
			  AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
			  AND T.UPLOAD_STATUS_CODE = 'SUCCESS' 
			;

			----------------------------------------------------------------------------
			--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
			SET @v_log_type = '12-1';
			SET @v_log_message = '########## DELETE STOCK OSP DATA END ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------

			END;


			/*
			----------------------------------------------------------------------------
			--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
			SET @v_log_type = '12-2';
			SET @v_log_message = '########## UPDATE STOCK OSP DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------

			UPDATE S
			SET  S.QTY				  = replace(replace(ISNULL(T.ATTRIBUTE5,''),' ',''),',','')
				,S.valid_yn			  = 'Y'
				,S.last_updated_by	  = @p_created_by
				,S.last_update_date	  = sysdatetime()
			FROM [dbo].[SCM_DNM_STOCK_OSP] S  WITH(NOLOCK)
				 ,[dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
			WHERE S.DIVISION_ID = T.ATTRIBUTE1
			  AND S.SCM_SITE_ID = T.ATTRIBUTE2
			  AND S.ITEM_ID		= T.ATTRIBUTE3
			  AND S.YYYYMMDD	= replace(replace(ISNULL(T.ATTRIBUTE4,''),' ',''),'-','')
			  AND T.PROGRAM_ID         = @v_program_id
			  AND T.SHEET_NAME         = @v_sheet_name
			  AND T.CREATED_BY         = @p_created_by
			  AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
			  AND T.UPLOAD_STATUS_CODE = 'SUCCESS' 
			;


			----------------------------------------------------------------------------
			--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
			SET @v_log_type = '12-2';
			SET @v_log_message = '########## UPDATE STOCK OSP DATA END ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------
			
			*/

			BEGIN

			----------------------------------------------------------------------------
			--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
			SET @v_log_type = '12-3';
			SET @v_log_message = '########## INSERT STOCK OSP DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------

			INSERT INTO [dbo].[SCM_DNM_STOCK_OSP]
			(
				DIVISION_ID
			  , SCM_SITE_ID
			  , ITEM_ID
			  , YYYYMMDD
			  , ATTRIBUTE1	--Valuation Type 추가
			  , QTY
			  , ATTRIBUTE2	--Cell From Site 추가
			  , COMMENT
			  , ATTRIBUTE3	--Box 추가
			  , VALID_YN
			  , CREATED_BY
			  , CREATION_DATE
			  , LAST_UPDATED_BY
			  , LAST_UPDATE_DATE
			)			
			SELECT T.ATTRIBUTE1, T.ATTRIBUTE2, T.ATTRIBUTE3, T.ATTRIBUTE4, T.ATTRIBUTE5, replace(replace(ISNULL(T.ATTRIBUTE6,''),' ',''),',',''), T.ATTRIBUTE7, T.ATTRIBUTE8--CONVERT(int,T.ATTRIBUTE5)
				 , T.ATTRIBUTE9	-- Box
				 , 'Y'
				 , @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
				 , @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
			FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T
			WHERE T.PROGRAM_ID         = @v_program_id
			  AND T.SHEET_NAME         = @v_sheet_name
			  AND T.CREATED_BY         = @p_created_by
			  AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
			  AND T.UPLOAD_STATUS_CODE = 'SUCCESS' 
			  AND NOT EXISTS( SELECT 'X'
								FROM [dbo].[SCM_DNM_STOCK_OSP] S
							   WHERE S.DIVISION_ID	= T.ATTRIBUTE1
							     AND S.SCM_SITE_ID	= T.ATTRIBUTE2
								 AND S.ITEM_ID		= T.ATTRIBUTE3
								 AND S.YYYYMMDD		= replace(replace(ISNULL(T.ATTRIBUTE4,''),' ',''),'-','')
								 AND S.ATTRIBUTE1	= T.ATTRIBUTE5	-- Valuation Type
								 AND S.ATTRIBUTE2	= T.ATTRIBUTE7	-- Cell From Site
							);

			----------------------------------------------------------------------------
			--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
			SET @v_log_type = '12-3';
			SET @v_log_message = '########## INSERT STOCK OSP DATA END ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------
			END;

		            
		    COMMIT WORK;
        END TRY
		BEGIN CATCH
			BEGIN
				ROLLBACK TRANSACTION STOCK_OSP_UPLOAD;
						
				INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
				VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
			END;
		END CATCH
				
		BEGIN
		----------------------------------------------------------------------------
		--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '12';
		SET @v_log_message = '########## INSERT/UPDATE STOCK OSP DATA END ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		----------------------------------------------------------------------------
		END;

    END;
	
	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = 'END';
	SET @v_log_message = '########## INSERT DATA END ##########';
	SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
	END;
		  
END;	
