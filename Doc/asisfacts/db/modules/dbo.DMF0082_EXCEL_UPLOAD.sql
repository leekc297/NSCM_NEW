/*
 * Program ID   : [DMF0082_EXCEL_UPLOAD]
 * Description  : Fcst&Price MGMT 엑셀 업로드
 * Program History
 *==================================================================================================
 *   Date       In Charge		Description
 *==================================================================================================
 * 2025.05.xx	KJY				최초 작성
 */

 --EXEC [DMF0082_EXCEL_UPLOAD] '1', 'kjj0070'  

 CREATE PROCEDURE [dbo].[DMF0082_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)		

AS

BEGIN

/*
1. 40 사업부만 대상으로 한다.
2. Validation Step
	step1. 필수값 확인
	step2. 중복값 확인 (LOC인 경우 currency도 포함하여 중복체크)
	step3. 코드/네임 맵핑 확인
			- 메져 확인(Unit Price(LOC),MKT FCST[R+P])
			- FCST Type
			- Dom/Exp  
*/
    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'DMF0082';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'FcstNPrice';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8) = CONVERT(VARCHAR(6), DATEADD(MONTH, 4, GETDATE()), 112); --당월 기준+4
	DECLARE @v_end_yyyymmdd  AS NVARCHAR(8) = CONVERT(VARCHAR(6), DATEADD(MONTH, 12, GETDATE()), 112); --당월 기준 +12
	DECLARE @v_division		 AS NVARCHAR(10); 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0082_EXCEL_UPLOAD';
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
	AND    T.CREATED_BY = @p_created_by
	AND    T.UPLOAD_STATUS_CODE = 'UPLOAD';
		 
	IF @v_creation_date IS NULL 
	BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'Data Not Found [' + CONVERT(CHAR(19), ISNULL(@v_creation_date,''), 121) +']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END;

	SELECT TOP 1  @v_division = ATTRIBUTE1 
	FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] 
	WHERE PROGRAM_ID    = @v_program_id
	AND SHEET_NAME    = @v_sheet_name
	AND CREATED_BY    = @p_created_by
	AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
	AND ATTRIBUTE1 != 'Div'
	AND UPLOAD_STATUS_CODE = 'UPLOAD';

	-- @p_mode = 0 이면 Validation
	IF ISNULL(@p_mode, 0) = 0 
	BEGIN
		PRINT @v_division

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL             
        FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
		WHERE  T.PROGRAM_ID    = @v_program_id
        AND    T.SHEET_NAME    = @v_sheet_name
        AND    T.CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
        --AND    ISNULL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD'
		;
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
        SET    UPLOAD_STATUS_CODE = '@TITLE'
        WHERE  PROGRAM_ID    = @v_program_id
        AND    SHEET_NAME    = @v_sheet_name
        AND    CREATED_BY    = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPPER(ATTRIBUTE1) = 'DIV';               
        END;

		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 2, TRUE);
		SET @v_log_type = '2';
		SET @v_log_message = '########## TITLE Header Line ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;



		--본격적 VALIDATION 시작

		/* ####################################################
		 필수 값 NULL 값 체크															
		ATTRIBUTE1	Div*
		ATTRIBUTE2	End Customer*
		ATTRIBUTE3	Sales Site*
		ATTRIBUTE4	Model*
		ATTRIBUTE5	Incoterms*
		ATTRIBUTE6	FCST Type*
		ATTRIBUTE7	Customs Handbook*
		ATTRIBUTE8	Cell Prod Site*
		ATTRIBUTE9	Currency*
		ATTRIBUTE10	Measure*
		 #################################################### */
		--Div	Team	End Customer	Project Code	Currency

		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE	= 'ERROR'
				 , MESSAGE_TEXT			= CASE WHEN ISNULL(ATTRIBUTE1,'')=''  THEN 'NULL Div' 
				 							   WHEN ISNULL(ATTRIBUTE2,'')=''  THEN 'NULL End Customer' 
				 							   WHEN ISNULL(ATTRIBUTE3,'')=''  THEN 'NULL Sales Site' 
				 							   WHEN ISNULL(ATTRIBUTE4,'')=''  THEN 'NULL Model' 	
				 							   WHEN ISNULL(ATTRIBUTE5,'')=''  THEN 'NULL Incoterms' 
				 							   WHEN ISNULL(ATTRIBUTE6,'')=''  THEN 'NULL FCST Type' 
				 							   WHEN ISNULL(ATTRIBUTE7,'')=''  THEN 'NULL Customs Handbook' 
				 							   WHEN ISNULL(ATTRIBUTE8,'')=''  THEN 'NULL Cell Prod Site' 
				 							   WHEN (ISNULL(ATTRIBUTE10,'')= 'Unit Price(LOC)' AND ISNULL(ATTRIBUTE9,'')='')  THEN 'NULL Currency'  --MEAUSRE가 Unit Price(LOC) 때만 필수값
				 							   WHEN ISNULL(ATTRIBUTE10,'')='' THEN 'NULL Measure' 
										   END
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND (   
					ISNULL(ATTRIBUTE1,'')='' 
					OR ISNULL(ATTRIBUTE2, '')='' 
					OR ISNULL(ATTRIBUTE3, '')='' 
					OR ISNULL(ATTRIBUTE4,'')='' 
					OR ISNULL(ATTRIBUTE5,'')='' 
					OR ISNULL(ATTRIBUTE6,'')='' 
					OR ISNULL(ATTRIBUTE7,'')='' 
					OR ISNULL(ATTRIBUTE8,'')='' 
					OR (ISNULL(ATTRIBUTE10,'')= 'Unit Price(LOC)' AND ISNULL(ATTRIBUTE9,'')='') 
					OR ISNULL(ATTRIBUTE10,'')=''					
					) ;
		END;

		BEGIN
			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## ERROR NULL Column Data ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* ####################################################
		Key기준 중복 체크									
		ATTRIBUTE1	Div*
		ATTRIBUTE2	End Customer*
		ATTRIBUTE3	Sales Site*
		ATTRIBUTE4	Model*
		ATTRIBUTE5	Incoterms*
		ATTRIBUTE6	FCST Type*
		ATTRIBUTE7	Customs Handbook*
		ATTRIBUTE8	Cell Prod Site*
		ATTRIBUTE9	Currency*
		ATTRIBUTE10	Measure*
		#################################################### */

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Duplication Model.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND EXISTS (SELECT 1
		            FROM  (--Unit Price(LOC) 외 메저는 Currency NULL
						   SELECT X.ATTRIBUTE1 AS COL1	--Div
                                , X.ATTRIBUTE2 AS COL2	--End Customer
                                , X.ATTRIBUTE3 AS COL3	--Sales Site
                                , X.ATTRIBUTE4 AS COL4	--Modele
                                , X.ATTRIBUTE5 AS COL5	--Incoterms
								, X.ATTRIBUTE6 AS COL6	--FCST Type
								, X.ATTRIBUTE7 AS COL7	--Customs Handbook
								, X.ATTRIBUTE8 AS COL8	--Cell Prod Site
								, ISNULL(X.ATTRIBUTE9,'') AS COL9	--Currency
								, X.ATTRIBUTE10 AS COL10 --Measure
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
                                  , X.ATTRIBUTE5
								  , X.ATTRIBUTE6
								  , X.ATTRIBUTE7
								  , X.ATTRIBUTE8
								  , ISNULL(X.ATTRIBUTE9,'')
								  , X.ATTRIBUTE10
                           HAVING COUNT(*) > 1 					   
						   ) T
					WHERE 1 = 1										 
	 			    AND T.COL1 = ATTRIBUTE1
                    AND T.COL2 = ATTRIBUTE2
                    AND T.COL3 = ATTRIBUTE3
                    AND T.COL4 = ATTRIBUTE4
					AND T.COL5 = ATTRIBUTE5
					AND T.COL6 = ATTRIBUTE6
					AND T.COL7 = ATTRIBUTE7
					AND T.COL8 = ATTRIBUTE8
					AND T.COL9 = ATTRIBUTE9
					AND T.COL10 = ATTRIBUTE10
				   );
		END

		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
		SET @v_log_type = 'UPDATE';
		SET @v_log_message = '########## ERROR Model Duplication ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		/* #################################################### */
		/* DIVISION  체크											*/
		--사업부 40 만 대상으로 함
		-- ATTRIBUTE1	Div	(검증전)
		-- ATTRIBUTE301 Div (검증후) - SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE301 = A.ATTRIBUTE1
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
		 	 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND A.ATTRIBUTE1 = '40'

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			SET    UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ',Invalid Division(40 Only).'
			WHERE  PROGRAM_ID         = @v_program_id
			AND    SHEET_NAME         = @v_sheet_name
			AND    CREATED_BY         = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPLOAD_STATUS_CODE = 'UPLOAD'
			AND	   ATTRIBUTE301 IS NULL
			END;

			BEGIN
			------------------------------------------------------------------------
			--scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
			SET @v_log_type = 'UPDATE';
			SET @v_log_message = '########## Invalid Division ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------
		END;

		/* #################################################### */
		/* END CUSTOMER 체크						*/
		--ATTRIBUTE2	End Customer (Name)
		--ATTRIBUTE302	End Customer (Code) - SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE302 = EC.CODE
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
			  JOIN (SELECT DISTINCT SI.PROJECT_CODE AS CODE
						 , ISNULL(D.SEGMENT3, SI.PROJECT_CODE) AS NAME
					  FROM SCM_MST_SITE_ITEM SI  WITH(NOLOCK)
					 INNER JOIN [SCM_MST_SSO_USER_INFO] UI  WITH(NOLOCK) 
						ON SI.OWNER = UI.USER_ID
					 INNER JOIN [SCM_MST_SSO_DEPT_INFO] DI  WITH(NOLOCK) 
						ON UI.DEPT_ID = DI.DEPT_ID
					  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
						ON SI.DIVISION_ID	= D.SEGMENT1 
					   AND SI.PROJECT_CODE	= D.SEGMENT2 
					   AND D.LOOKUP_TYPE	= 'END_CUSTOMER' 
					   AND D.VALID_YN		= 'Y'
					 WHERE UI.USER_ID	  = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(SI.OWNER,',') ) 
					   AND UI.DEPT_ID	  = DI.DEPT_ID
					   AND SI.DIVISION_ID = '40' 
					   AND SI.VALID_YN	  = 'Y'
					 UNION
					SELECT SEGMENT2 AS CODE 
						 , SEGMENT3 AS NAME
					  FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
					 WHERE LOOKUP_TYPE = 'END_CUSTOMER'
					   AND SEGMENT2 <> '-'
					   AND VALID_YN = 'Y'
					   AND SEGMENT1 = '40') EC
				ON (A.ATTRIBUTE2 = EC.NAME)
		 	 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(A.ATTRIBUTE2, '') <> ''


			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid End Customer'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE302 IS NULL

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid END CUSTOMER / SALES SITE ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;		
		
		/* #################################################### */
		/* SALES SITE 체크						*/
		--ATTRIBUTE3	Sales Site (Name)
		--ATTRIBUTE303	Sales Site (Code) - SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE303 = MS.SCM_SITE_ID
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
			  JOIN SCM_MST_SITE MS  WITH(NOLOCK)
			    ON (MS.SITE_TYPE = 'SALES'
			   AND MS.VALID_YN = 'Y'
			   AND MS.DIVISION_ID = '40'
			   AND MS.SCM_SITE_ID = A.ATTRIBUTE3)
		 	 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(A.ATTRIBUTE3, '') <> ''

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid Sales Site'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE303 IS NULL

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid END CUSTOMER / SALES SITE ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;		

		/* #################################################### */
		/* END CUSTOMER / SALES SITE Mapping 체크				*/
		--ATTRIBUTE2	End Customer (Name)
		--ATTRIBUTE3	Sales Site	 (Name)

		--ATTRIBUTE302	End Customer (Code) - SYSTEM UPDATE
		--ATTRIBUTE303	Sales Site	 (Code) - SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid End Customer/Sales Site.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM  SCM_MST_SITE AS MS WITH(NOLOCK)
									LEFT JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
									  ON MS.DIVISION_ID = SI.DIVISION_ID 
									 AND MS.SCM_SITE_ID = SI.SCM_SITE_ID
								   WHERE  1 = 1
									 AND MS.SITE_TYPE		= 'SALES'
									 AND MS.VALID_YN		= 'Y'
									 AND MS.DIVISION_ID		= '40'
									 AND SI.PROJECT_CODE	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE302
									 AND MS.SCM_SITE_ID		= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE303
									)	 ;

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid END CUSTOMER / SALES SITE ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;		
		
		/* #################################################### */
		/* MODEL 체크										*/
		-- ATTRIBUTE4    Model*
		-- ATTRIBUTE304  Model* - SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE304 = MS.ITEM_ID
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
			  JOIN DBO.SCM_MST_SITE_ITEM MS WITH(NOLOCK)
				ON (MS.DIVISION_ID = A.ATTRIBUTE301 --Div
				AND MS.SCM_SITE_ID = A.ATTRIBUTE303 --Sales Site
				AND MS.ITEM_ID	   = A.ATTRIBUTE4	--Model
				AND MS.VALID_YN	   = 'Y')
			   JOIN dbo.SCM_MST_ITEM_SN SN WITH(NOLOCK)
			     ON (MS.DIVISION_ID   = SN.DIVISION_ID
				AND MS.ITEM_ID        = SN.ITEM_ID
				AND SN.ACTIVE_FLAG	  = 'Y')
		 	 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(A.ATTRIBUTE4, '') <> ''

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid Model.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE304 IS NULL

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid MODEL ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		
		/* #################################################### */
		/* INCOTERMS 체크										*/
		-- ATTRIBUTE5   Incoterms*
		-- ATTRIBUTE305 Incoterms*  - SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE305 = LV.NAME
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
			  JOIN (SELECT L.SEGMENT1 AS CODE
						 , L.SEGMENT2 AS NAME
					  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L (NOLOCK)
					 WHERE L.LOOKUP_TYPE = 'INCOTERMS'
					   AND L.VALID_YN = 'Y' ) LV
				ON (LV.NAME = A.ATTRIBUTE5)
		 	 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(A.ATTRIBUTE5, '') <> ''

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid Incoterms.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE305 IS NULL

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid INCOTERMS ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		
		
		/* #################################################### */
		/* FCST TYPE 체크 										*/
		-- ATTRIBUTE6   Fcst Type (NAME)
		-- ATTRIBUTE306 Fcst Type (CODE) --SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE306 = LV.CODE
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
			  JOIN (SELECT L.SEGMENT1 AS CODE
						 , L.SEGMENT2 AS NAME
					  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L (NOLOCK)
					 WHERE L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND ISNULL(L.ATTRIBUTE2,'') <> 'Y' --AS전용여부
						AND L.VALID_YN = 'Y') LV
				ON (LV.NAME = A.ATTRIBUTE6) --Fcst Type name
			 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(A.ATTRIBUTE6, '') <> ''

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid Fcst Type'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE306 IS NULL

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid FCST TYPE ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		
		/* #################################################### */
		/* Customs Handbook 체크										*/
		-- ATTRIBUTE7	 Customs Handbook*							*/
		-- ATTRIBUTE307  Customs Handbook* --SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE307 = LV.CODE
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
			  JOIN (SELECT L.SEGMENT1 AS CODE
						 , L.SEGMENT2 AS NAME
					  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L (NOLOCK)
					 WHERE L.LOOKUP_TYPE = 'DM_CUSTOMS_HANDBOOK_40'
					   AND L.VALID_YN = 'Y') LV
				ON (LV.NAME = A.ATTRIBUTE7) --Fcst Type name
			 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(A.ATTRIBUTE7, '') <> ''


			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid Customs Handbook'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE307 IS NULL

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Customs Handbook ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		
		/* #################################################### */
		/* Cell Prod Site 체크										*/
		-- ATTRIBUTE8	 Cell Prod Site (NAME)
		-- ATTRIBUTE308  Cell Prod Site (CODE) --SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE308 = M.SEGMENT1
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
			  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)
				ON (M.LOOKUP_TYPE	= 'SP_CELL_PROD_SITE'
			   AND M.VALID_YN		= 'Y'
			   AND M.ATTRIBUTE1		= A.ATTRIBUTE8) ---CELL PROD SITE
			 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(A.ATTRIBUTE8, '') <> ''

			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid Cell Prod Site'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE308 IS NULL

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid Cell Prod Site ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;		

		/* #################################################### */
		/* MEASURE 체크										*/
		-- ATTRIBUTE10   Measure
		--			     LOC		: Unit Price(LOC)
		--			     MKT_FCST : MKT FCST[R+P]

		-- ATTRIBUTE310  MEASURE  (CODE) --SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE310 = L.SEGMENT3
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
			  JOIN SCM_MST_SITE MS WITH(NOLOCK)
				ON (MS.DIVISION_ID = A.ATTRIBUTE301 --DIV
			   AND MS.SCM_SITE_ID  = A.ATTRIBUTE303) --Sales Site
			  JOIN [SCM_ADM_LOOKUP_MASTER_DETAIL] L
			    ON (L.LOOKUP_TYPE	= 'DM_UI_EDITABLE_MEASURE'
			   AND L.SEGMENT1		= 'DMF0082'		-- PROGROM_ID
			   AND L.VALID_YN		= 'Y'			-- 사용여부
			   AND L.ATTRIBUTE1		= 'Y'			-- INSERT_YN 여부
			   AND L.SEGMENT2		= MS.DIVISION_ID
			   AND (
					( ISNULL(MS.VMI_YN,'N') = 'N' AND L.ATTRIBUTE3  <> 'Y' )  -- SCM_MST_SITE에 데이터가 없으면서 VMI_YN이 Y가 아닌 경우. 
					OR 
					( ISNULL(MS.VMI_YN,'N') = 'Y' ) -- SCM_MST_SITE에 데이터가 있을 경우.
					--두개 중에서 하나라도 걸린다면 가져온다.
					)
				AND L.SEGMENT4 = A.ATTRIBUTE10) --MEASURE Name
			 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(A.ATTRIBUTE10, '') <> ''


			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid Measure'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ATTRIBUTE310 IS NULL

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid CURRENCY. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/* #################################################### */
		/* CURRENCY 체크										*/
		-- ATTRIBUTE9  Currency
		-- ATTRIBUTE10 Measure 가 Unit Price(LOC) 인 대상으로만 통화 체크

		--ATTRIBUTE310  MEASURE  (CODE) --SYSTEM UPDATE
		/* #################################################### */
		BEGIN
			UPDATE A
			   SET A.ATTRIBUTE309 = LV.CODE
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
			  JOIN (SELECT L.SEGMENT1 AS CODE
						 , L.SEGMENT2 AS NAME 
					  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					 WHERE L.LOOKUP_TYPE = 'CURRENCY_LIST'
					   AND L.VALID_YN	 = 'Y') LV
				ON (LV.NAME	 = A.ATTRIBUTE9) --Fcst Type name
			 WHERE A.PROGRAM_ID         = @v_program_id
			   AND A.SHEET_NAME         = @v_sheet_name
			   AND A.CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date
			   AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(A.ATTRIBUTE310,'') ='LOC' --MEASURE가 LOC인 대상으로만.


			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid CURRENCY.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND ISNULL(ATTRIBUTE310,'') ='LOC' --MEASURE가 LOC인 대상으로만.
			   AND ATTRIBUTE309 IS NULL
			   
			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid CURRENCY. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		
		/* #################################################### */
		/* 숫자여부 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Invalid NUMERIC.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND 
			   (
					(ISNULL(ATTRIBUTE11, '') <> '' AND ISNUMERIC(ATTRIBUTE11) = 0) OR--M4
					(ISNULL(ATTRIBUTE12, '') <> '' AND ISNUMERIC(ATTRIBUTE12) = 0) OR--M5
					(ISNULL(ATTRIBUTE13, '') <> '' AND ISNUMERIC(ATTRIBUTE13) = 0) OR--M6
					(ISNULL(ATTRIBUTE14, '') <> '' AND ISNUMERIC(ATTRIBUTE14) = 0) OR--M7
					(ISNULL(ATTRIBUTE15, '') <> '' AND ISNUMERIC(ATTRIBUTE15) = 0) OR--M8
					(ISNULL(ATTRIBUTE16, '') <> '' AND ISNUMERIC(ATTRIBUTE16) = 0) OR--M9
					(ISNULL(ATTRIBUTE17, '') <> '' AND ISNUMERIC(ATTRIBUTE17) = 0) OR--M10
					(ISNULL(ATTRIBUTE18, '') <> '' AND ISNUMERIC(ATTRIBUTE18) = 0) OR--M11
					(ISNULL(ATTRIBUTE19, '') <> '' AND ISNUMERIC(ATTRIBUTE19) = 0) --M12
			   )

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Invalid NUMERIC. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;


		/* #################################################### */
		/* 마이너스 여부 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Negative Number.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND 
			   (
					(ISNULL(ATTRIBUTE11, '') <> '' AND ISNUMERIC(ATTRIBUTE11) = 1 AND CONVERT(FLOAT, ATTRIBUTE11) < 0) OR--M4
					(ISNULL(ATTRIBUTE12, '') <> '' AND ISNUMERIC(ATTRIBUTE12) = 1 AND CONVERT(FLOAT, ATTRIBUTE12) < 0) OR--M5
					(ISNULL(ATTRIBUTE13, '') <> '' AND ISNUMERIC(ATTRIBUTE13) = 1 AND CONVERT(FLOAT, ATTRIBUTE13) < 0) OR--M6
					(ISNULL(ATTRIBUTE14, '') <> '' AND ISNUMERIC(ATTRIBUTE14) = 1 AND CONVERT(FLOAT, ATTRIBUTE14) < 0) OR--M7
					(ISNULL(ATTRIBUTE15, '') <> '' AND ISNUMERIC(ATTRIBUTE15) = 1 AND CONVERT(FLOAT, ATTRIBUTE15) < 0) OR--M8
					(ISNULL(ATTRIBUTE16, '') <> '' AND ISNUMERIC(ATTRIBUTE16) = 1 AND CONVERT(FLOAT, ATTRIBUTE16) < 0) OR--M9
					(ISNULL(ATTRIBUTE17, '') <> '' AND ISNUMERIC(ATTRIBUTE17) = 1 AND CONVERT(FLOAT, ATTRIBUTE17) < 0) OR--M10
					(ISNULL(ATTRIBUTE18, '') <> '' AND ISNUMERIC(ATTRIBUTE18) = 1 AND CONVERT(FLOAT, ATTRIBUTE18) < 0) OR--M11
					(ISNULL(ATTRIBUTE19, '') <> '' AND ISNUMERIC(ATTRIBUTE19) = 1 AND CONVERT(FLOAT, ATTRIBUTE19) < 0) --M12
			   )

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Negative Number. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;


		/* #################################################### */
		/* 0 여부 체크										*/
		/* #################################################### */
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = ISNULL(MESSAGE_TEXT,'') + ', Zero Number.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND 
			   (
					(ISNULL(ATTRIBUTE11, '') <> '' AND ISNUMERIC(ATTRIBUTE11) = 1 AND CONVERT(FLOAT, ATTRIBUTE11) = 0) OR--M4
					(ISNULL(ATTRIBUTE12, '') <> '' AND ISNUMERIC(ATTRIBUTE12) = 1 AND CONVERT(FLOAT, ATTRIBUTE12) = 0) OR--M5
					(ISNULL(ATTRIBUTE13, '') <> '' AND ISNUMERIC(ATTRIBUTE13) = 1 AND CONVERT(FLOAT, ATTRIBUTE13) = 0) OR--M6
					(ISNULL(ATTRIBUTE14, '') <> '' AND ISNUMERIC(ATTRIBUTE14) = 1 AND CONVERT(FLOAT, ATTRIBUTE14) = 0) OR--M7
					(ISNULL(ATTRIBUTE15, '') <> '' AND ISNUMERIC(ATTRIBUTE15) = 1 AND CONVERT(FLOAT, ATTRIBUTE15) = 0) OR--M8
					(ISNULL(ATTRIBUTE16, '') <> '' AND ISNUMERIC(ATTRIBUTE16) = 1 AND CONVERT(FLOAT, ATTRIBUTE16) = 0) OR--M9
					(ISNULL(ATTRIBUTE17, '') <> '' AND ISNUMERIC(ATTRIBUTE17) = 1 AND CONVERT(FLOAT, ATTRIBUTE17) = 0) OR--M10
					(ISNULL(ATTRIBUTE18, '') <> '' AND ISNUMERIC(ATTRIBUTE18) = 1 AND CONVERT(FLOAT, ATTRIBUTE18) = 0) OR--M11
					(ISNULL(ATTRIBUTE19, '') <> '' AND ISNUMERIC(ATTRIBUTE19) = 1 AND CONVERT(FLOAT, ATTRIBUTE19) = 0) --M12
			   )

			SET @v_log_type = 'UPDATE';
			SET @n_log_count = @n_log_count + 1;
			SET @v_log_message = '########## Zero Number. ##########';
			SET @v_description = CONVERT(nvarchar,@@ROWCOUNT);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
				
		-- 정상(SUCCESS) 처리
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
	    SET @v_log_type = '16';
	    SET @v_log_message = '########## SUCCESS ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
		END;

		/*
		SELECT A.ATTRIBUTE301 AS DIVISION_ID
	 , A.ATTRIBUTE302 AS END_CUSTOMER
	 , A.ATTRIBUTE303 AS SCM_SITE_ID
	 , A.ATTRIBUTE304 AS ITEM_ID
	 , A.ATTRIBUTE305 AS INCOTERMS
	 , A.ATTRIBUTE306 AS FCST_TYPE
	 , A.ATTRIBUTE307 AS DOM_EXP
	 , A.ATTRIBUTE308 AS CELL_PROD_SITE
	 , A.ATTRIBUTE309 AS CURRENCY
	 , A.ATTRIBUTE310 AS MEASURE
	 , A.ATTRIBUTE11 AS M4
	 , A.ATTRIBUTE12 AS M5
	 , A.ATTRIBUTE13 AS M6
	 , A.ATTRIBUTE14 AS M7
	 , A.ATTRIBUTE15 AS M8
	 , A.ATTRIBUTE16 AS M9
	 , A.ATTRIBUTE17 AS M10
	 , A.ATTRIBUTE18 AS M11
	 , A.ATTRIBUTE19 AS M12
  INTO #FCST_PRICE_EXCEL
  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A
 WHERE 1=1
   AND A.PROGRAM_ID = 'DMF0082'
   AND A.SHEET_NAME = 'FcstNPrice_Mgmt'


SELECT A.DIVISION_ID
	 , A.END_CUSTOMER
	 , A.SCM_SITE_ID
	 , A.ITEM_ID
	 , A.INCOTERMS
	 , A.FCST_TYPE
	 , A.DOM_EXP
	 , A.CELL_PROD_SITE
	 , A.CURRENCY
	 , A.MEASURE
	 , CONCAT(A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.CELL_PROD_SITE, A.CURRENCY, A.MEASURE) AS KEY_VALUE
	 , CASE A.YYYYMM  WHEN 'M4' THEN '202509'  WHEN 'M5' THEN '202510'  WHEN 'M6' THEN '202511'  WHEN 'M7' THEN '202512'  WHEN 'M8' THEN '202601'  WHEN 'M9' THEN '202602'  WHEN 'M10' THEN '202603'  WHEN 'M11' THEN '202604'  WHEN 'M12' THEN '202605' END AS YYYYMM
	 , CONVERT(NUMERIC(23,2), IIF(ISNULL(A.QTY,'')='', '0', A.QTY)) AS QTY
  INTO #FCST_PRICE_UNPIVOT
  FROM DBO.#FCST_PRICE_EXCEL A
 UNPIVOT (QTY FOR YYYYMM IN (M4,M5,M6,M7,M8,M9,M10,M11,M12)) A

 --BUCKET 이 포함된 주차
SELECT  A.DIVISION_ID
	 , A.END_CUSTOMER
	 , A.SCM_SITE_ID
	 , A.ITEM_ID
	 , A.INCOTERMS
	 , A.FCST_TYPE
	 , A.DOM_EXP
	 , A.CELL_PROD_SITE
	 , A.CURRENCY
	 , A.MEASURE
	 , A.KEY_VALUE
	 , CM.BASIS_YYYYMM
	 , CM.BASIS_YYYYMMDD
	 , CM.ISO_YYYYWW
  --INTO #FCST_PRICE_BUCKET
  FROM #FCST_PRICE_UNPIVOT A
    JOIN (SELECT A.BASIS_YYYYMM
			  , A.BASIS_YYYYMMDD
			  , A.ISO_YYYYWW
			  , A.DAYOFWEEK
		   FROM [dbo].[SCM_SYS_CALENDAR_M] A
		  WHERE 1=1
			AND A.BASIS_YYYYMM BETWEEN FORMAT(DATEADD(MONTH, 4, GETDATE()), 'yyyyMM') AND  FORMAT(DATEADD(MONTH, 12, GETDATE()), 'yyyyMM')
		) CM
     ON (A.YYYYMM = CM.BASIS_YYYYMM)
    JOIN (SELECT BC.DIVISION_ID
					, BC.SCM_SITE_ID
					, BC.INCOTERMS
					, BC.BUCKET_PER
					, BC.YYYYMMDD
					, COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT
				   FROM DM_MST_BUCKET_CONVERSION BC
				  WHERE 1=1
				    AND BC.DIVISION_ID = '40') BC
	 ON (BC.DIVISION_ID = A.DIVISION_ID
	AND BC.SCM_SITE_ID = A.SCM_SITE_ID
	AND BC.INCOTERMS = A.INCOTERMS
	AND BC.YYYYMMDD = CM.DAYOFWEEK
	AND BC.BUCKET_PER = 'Y')
  WHERE 1=1
    AND A.MEASURE = 'MKT_FCST'

 --WEEK 별 수량 나누기
 WITH W_WEEKLY AS (
 SELECT A.DIVISION_ID
	 , A.END_CUSTOMER
	 , A.SCM_SITE_ID
	 , A.ITEM_ID
	 , A.INCOTERMS
	 , A.FCST_TYPE
	 , A.DOM_EXP
	 , A.CELL_PROD_SITE
	 , A.CURRENCY
	 , A.MEASURE
	 , A.KEY_VALUE
	 , A.YYYYMM
	 , CM.ISO_YYYYWW
	 , CM.WEEK_DAY_CNT
	 , A.QTY AS MONTHLY_QTY
	 , ROUND(A.QTY/CM.EOM*CM.WEEK_DAY_CNT,0) AS TEMP_WEEKLY_QTY
	 , SUM(ROUND(A.QTY/CM.EOM*CM.WEEK_DAY_CNT,0)) OVER (PARTITION BY A.KEY_VALUE,YYYYMM ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS CUM_SUM
	 , CASE WHEN LEAD(A.YYYYMM, 1) OVER (PARTITION BY A.KEY_VALUE,YYYYMM ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW ) IS NULL THEN 'Y' ELSE 'N' END AS LAST_WEEK_YN
   FROM #FCST_PRICE_UNPIVOT A
   JOIN (SELECT A.BASIS_YYYYMM
			  , A.ISO_YYYYWW
		  	  , COUNT(1) AS WEEK_DAY_CNT
			  , CONVERT(INT, FORMAT(EOMONTH(MAX(A.BASIS_DATE)),'dd')) AS EOM
		   FROM [dbo].[SCM_SYS_CALENDAR_M] A
		  WHERE 1=1
			AND A.BASIS_YYYYMM BETWEEN FORMAT(DATEADD(MONTH, 4, GETDATE()), 'yyyyMM') AND  FORMAT(DATEADD(MONTH, 12, GETDATE()), 'yyyyMM')
		  GROUP BY A.BASIS_YYYYMM
				 , A.ISO_YYYYWW
		) CM
     ON (A.YYYYMM = CM.BASIS_YYYYMM)
   JOIN (SELECT DISTINCT PB.KEY_VALUE
			  , PB.BASIS_YYYYMM
			  , PB.ISO_YYYYWW
		    FROM #FCST_PRICE_BUCKET PB) PB --버켓 요일이 있는 주차만 대상으로 함.
     ON (A.KEY_VALUE = PB.KEY_VALUE
	 AND A.YYYYMM = PB.BASIS_YYYYMM
	 AND CM.ISO_YYYYWW = PB.ISO_YYYYWW)
  WHERE 1=1
    AND A.MEASURE = 'MKT_FCST'
 )
 SELECT A.DIVISION_ID
	 , A.END_CUSTOMER
	 , A.SCM_SITE_ID
	 , A.ITEM_ID
	 , A.INCOTERMS
	 , A.FCST_TYPE
	 , A.DOM_EXP
	 , A.CELL_PROD_SITE
	 , A.CURRENCY
	 , A.MEASURE
	 , A.KEY_VALUE
	 , A.YYYYMM
	 , A.ISO_YYYYWW
	 , A.WEEK_DAY_CNT
	 , A.MONTHLY_QTY
	 --, A.TEMP_WEEKLY_QTY
	 --, A.CUM_SUM
	 , CASE WHEN A.LAST_WEEK_YN = 'Y' THEN A.MONTHLY_QTY - A.CUM_SUM
			ELSE A.TEMP_WEEKLY_QTY END AS WEEKLY_QTY
   INTO #FCST_PRICE_WEEKLY
   FROM W_WEEKLY A
  WHERE 1=1
    AND A.MEASURE = 'MKT_FCST'
 ORDER BY A.KEY_VALUE, A.YYYYMM
 ;

--DAILY QTY
 --DAILY 별 수량 나누기
 WITH W_DAILY AS (
 SELECT A.DIVISION_ID
	 , A.END_CUSTOMER
	 , A.SCM_SITE_ID
	 , A.ITEM_ID
	 , A.INCOTERMS
	 , A.FCST_TYPE
	 , A.DOM_EXP
	 , A.CELL_PROD_SITE
	 , A.CURRENCY
	 , A.MEASURE
	 , A.KEY_VALUE
	 , A.YYYYMM
	 , CM.BASIS_YYYYMMDD
	 , CM.ISO_YYYYWW
	 , BC.BUCKET_PER
	 , BC.BUCKET_CNT
	 , A.MONTHLY_QTY
	 , A.WEEKLY_QTY
	 , FLOOR(A.WEEKLY_QTY/BC.BUCKET_CNT) AS TEMP_DAILY_QTY
	 , SUM(FLOOR(A.WEEKLY_QTY/BC.BUCKET_CNT)) OVER (PARTITION BY A.KEY_VALUE,A.YYYYMM,A.ISO_YYYYWW ORDER BY A.KEY_VALUE, YYYYMM, CM.BASIS_YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS CUM_SUM
	 , CASE WHEN LEAD(A.ISO_YYYYWW, 1) OVER (PARTITION BY A.KEY_VALUE,YYYYMM,A.ISO_YYYYWW ORDER BY A.KEY_VALUE, YYYYMM, CM.BASIS_YYYYMMDD ) IS NULL THEN 'Y' ELSE 'N' END AS LAST_DAY_YN
   FROM #FCST_PRICE_WEEKLY A
   JOIN (SELECT A.BASIS_YYYYMM
			  , A.BASIS_YYYYMMDD
			  , A.ISO_YYYYWW
			  , A.DAYOFWEEK
		   FROM [dbo].[SCM_SYS_CALENDAR_M] A
		  WHERE 1=1
			AND A.BASIS_YYYYMM BETWEEN FORMAT(DATEADD(MONTH, 4, GETDATE()), 'yyyyMM') AND  FORMAT(DATEADD(MONTH, 12, GETDATE()), 'yyyyMM')
		) CM
     ON (A.YYYYMM = CM.BASIS_YYYYMM
	 AND A.ISO_YYYYWW = CM.ISO_YYYYWW)
    JOIN (SELECT BC.DIVISION_ID
					, BC.SCM_SITE_ID
					, BC.INCOTERMS
					, BC.BUCKET_PER
					, BC.YYYYMMDD
					, COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT
				   FROM DM_MST_BUCKET_CONVERSION BC
				  WHERE 1=1
				    AND BC.DIVISION_ID = '40') BC
	 ON (BC.DIVISION_ID = A.DIVISION_ID
	AND BC.SCM_SITE_ID = A.SCM_SITE_ID
	AND BC.INCOTERMS = A.INCOTERMS
	AND BC.YYYYMMDD = CM.DAYOFWEEK
	AND BC.BUCKET_PER = 'Y')
  WHERE 1=1
)
 SELECT A.DIVISION_ID
	 , A.END_CUSTOMER
	 , A.SCM_SITE_ID
	 , A.ITEM_ID
	 , A.INCOTERMS
	 , A.FCST_TYPE
	 , A.DOM_EXP
	 , A.CELL_PROD_SITE
	 , A.CURRENCY
	 , A.MEASURE
	 , A.KEY_VALUE
	 , A.YYYYMM
	 , A.BASIS_YYYYMMDD
	 , A.ISO_YYYYWW
	 , A.BUCKET_CNT
	 , A.MONTHLY_QTY
	 , A.WEEKLY_QTY
	 --, A.TEMP_DAILY_QTY
	 , A.CUM_SUM
	 ,A.LAST_DAY_YN
	 , CASE WHEN A.LAST_DAY_YN = 'Y' THEN A.WEEKLY_QTY - ISNULL(A.CUM_SUM,0)
			ELSE A.TEMP_DAILY_QTY END AS DAILY_QTY
   --INTO #FCST_PRICE_WEEKLY
   FROM W_DAILY A
  WHERE 1=1
 ORDER BY A.KEY_VALUE, A.YYYYMM
		*/
	END

	BEGIN
	----------------------------------------------------------------------------
	--scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = '21';
	SET @v_log_message = '########## INSERT DMF0028_EXCEL_UPLOAD END ##########';
	SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	----------------------------------------------------------------------------		   
	END;

END





