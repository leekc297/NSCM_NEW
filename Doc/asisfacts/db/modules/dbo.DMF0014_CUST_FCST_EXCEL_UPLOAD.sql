
/*
 * Program ID   : DMF0014_CUST_FCST_EXCEL_UPLOAD
 * Description  : DMF0014_CUST_FCST_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2018. 01. 02   SongDH     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022. 10. 26	  KDW2819	 [C20221024-000507]CUST FCST Upload 오류 수정
 * 2023. 01. 25   kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
 * 2023. 02. 28   chano0612 [E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생 -- EXCEL UPLOAD
 * 2024. 02. 15   kcw3408   [E20240208-001344]고객 수요 분석 시스템_Cust.FCST upload 문의의 건(데이타 없는데 Ctrl + End 키로는 인식되어 Length가 0인 컬럼을 Check 추가)
 */

 --EXEC DMF0014_CUST_FCST_EXCEL_UPLOAD '1', 'hwayoung.lim'  

 CREATE PROCEDURE [dbo].[DMF0014_CUST_FCST_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)
AS

BEGIN
    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'DMF0014';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'FCST Upload';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_division		AS NVARCHAR(10); --[E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생
    DECLARE @v_err_cnt        AS INT;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0014_CUST_FCST_EXCEL_UPLOAD';
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

 --EXEC DMF0014_CUST_FCST_EXCEL_UPLOAD '1', 'hwayoung.lim'  
		BEGIN
			SELECT TOP 1  @v_division = ATTRIBUTE1 FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			WHERE  PROGRAM_ID    = @v_program_id
			AND    SHEET_NAME    = @v_sheet_name
			AND    CREATED_BY    = @p_created_by
			AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			AND    UPPER(ATTRIBUTE1) <> 'DIVISION*'
			AND    UPLOAD_STATUS_CODE = 'UPLOAD';
		END

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
	    SET @v_description = @p_mode;
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
        AND    (   ATTRIBUTE1  IS NULL 
	            OR LEN(ATTRIBUTE1) = 0 
	            OR UPPER(ATTRIBUTE1) = 'TOTAL') ;
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
        AND    UPPER(ATTRIBUTE1) = 'DIVISION*';    
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
                                , X.ATTRIBUTE5 AS COL5
                                , X.ATTRIBUTE6 AS COL6
                                , X.ATTRIBUTE7 AS COL7
                                , X.ATTRIBUTE8  AS COL8
 	                            , X.ATTRIBUTE9  AS COL9
			                    , X.ATTRIBUTE10 AS COL10
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
                                  , X.ATTRIBUTE5
                                  , X.ATTRIBUTE6
                                  , X.ATTRIBUTE7
                                  , X.ATTRIBUTE8 
		                          , X.ATTRIBUTE9 
			                      , X.ATTRIBUTE10
								  --, X.ATTRIBUTE11
								  --, X.ATTRIBUTE12
                           HAVING COUNT(*) > 1 ) T
					WHERE 1 = 1										 
	 			    AND T.COL1 = ATTRIBUTE1
                    AND T.COL2 = ATTRIBUTE2
                    AND T.COL3 = ATTRIBUTE3
                    AND T.COL4 = ATTRIBUTE4
                    AND T.COL5 = ATTRIBUTE5
                    AND T.COL6 = ATTRIBUTE6
                    AND T.COL7 = ATTRIBUTE7
                    AND T.COL8 = ATTRIBUTE8
			        AND T.COL9  =ATTRIBUTE9
		            AND T.COL10 = ATTRIBUTE10 
					--AND T.COL11 = ATTRIBUTE11
					--AND T.COL12 = ATTRIBUTE12
				   );
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END

		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
		SET @v_log_type = '4';
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
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
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
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Upload Bucket.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[DM_MST_CUSTOMER_FCST] D  WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION]     D2 WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
						AND   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 OR  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1  )
						AND    D.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
						AND    D.MEASURE     = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10
						AND    D.[UPLOAD_BUCKET_TYPE] IN (
						                                    SELECT CASE DATEDIFF( DAY, CAST( Z.ATTRIBUTE14 AS DATETIME) , CAST( Z.ATTRIBUTE15 AS DATETIME) )  WHEN 1 THEN 'DAILY' WHEN 7 THEN 'WEEKLY' ELSE 'MONTHLY' END
														    FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] Z  WITH(NOLOCK)
                                                            WHERE  Z.PROGRAM_ID = @v_program_id
															AND    Z.SHEET_NAME = @v_sheet_name
															AND    Z.CREATED_BY = @p_created_by
															AND    CONVERT(NVARCHAR(40), Z.CREATION_DATE, 121) = @v_creation_date
															AND    Z.UPLOAD_STATUS_CODE = '@TITLE'
						                                 )   
						);
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END;
		
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Upload UOM.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[DM_MST_CUSTOMER_FCST] D WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION]     D2 WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
						and   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1  )
						AND    D.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
						AND    D.MEASURE     = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10
						AND    D.UPLOAD_UOM =  [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11  
						);
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END;

		BEGIN
		------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
		SET @v_log_type = '5';
	    SET @v_log_message = '########## Invalid Division ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
				
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Scm Site.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_MST_SITE] S      WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION] D2 WITH(NOLOCK)
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
						AND    S.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
						and   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1  )
                        AND    S.VALID_YN    = 'Y');
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		SET @v_log_type = '6';
	    SET @v_log_message = '########## Invalid Scm Site. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Plant Site.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		AND    (ATTRIBUTE1 =  '81' or ATTRIBUTE1 = 'Automotive Battery')  -- ess는 제외
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_MST_SITE] S WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION] D2 WITH(NOLOCK)
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
						AND    S.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
						and   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1  )
                        AND    S.VALID_YN    = 'Y');
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		SET @v_log_type = '6';
	    SET @v_log_message = '########## Invalid Plant Site. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		/*
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customer Project.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[DM_MST_CUSTOMER_MODEL] CM  WITH(NOLOCK)
                        WHERE  CM.DIVISION_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Customer Project ', SQL%ROWCOUNT, 6, TRUE);
		SET @v_log_type = '7';
	    SET @v_log_message = '########## Invalid Customer Project ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		*/
		IF @v_division != '40'			
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customer Model.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[DM_MST_CUSTOMER_MODEL] CM WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION] D2 WITH(NOLOCK)
                        WHERE  CM.DIVISION_ID = D2.DIVISION_ID
					    AND    CM.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
						and   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1  )
                        AND    CM.VALID_YN              = 'Y'
						UNION
                        SELECT 1
                        FROM   [dbo].SCM_MST_SITE_ITEM si WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION] D3 WITH(NOLOCK)
                        WHERE  si.DIVISION_ID = D3.DIVISION_ID
					    AND    si.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					    AND    si.PROJECT_CODE          = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12 --ATTRIBUTE4 --2024.01.10 philsu.park 임시.
						AND    si.ITEM_ID               = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE13 --ATTRIBUTE5 --2024.01.10 philsu.park 임시.
						and   ( D3.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D3.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1  )
                        AND    si.VALID_YN              = 'Y'
						);
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
		SET @v_log_type = '8';
	    SET @v_log_message = '########## Invalid Customer Model ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
			
		
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Incoterms.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
						AND    L.LOOKUP_TYPE = 'INCOTERMS'
						AND    L.VALID_YN    = 'Y');
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '10';
		SET @v_log_message = '########## Invalid Incoterms. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Sales Type.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
						AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND    L.VALID_YN    = 'Y'
						union
						SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] D
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DESCRIPTION = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
					   );
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END;

		BEGIN -- validation이 끝났으니 code로 update
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    ATTRIBUTE7 = (
							SELECT D.SEGMENT1
							FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] D  WITH(NOLOCK)
							WHERE  D.VALID_YN    = 'Y'
							AND    D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
							AND    D.SEGMENT2    = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
		                    )
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
						AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND    L.VALID_YN    = 'Y'
					   );
		END;


		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '11';
		SET @v_log_message = '########## Invalid Sales Type. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;


		/*
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customs Handbook'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8
						AND    L.LOOKUP_TYPE = 'DOM/EXP'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '12';
		SET @v_log_message = '########## Invalid DOM/EXP. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		*/


		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Group.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9
						AND    L.LOOKUP_TYPE = 'MEASURE_GROUP_CODE'
						AND    L.SEGMENT1 = 'CUST_FCST'
						AND    L.VALID_YN    = 'Y');
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END;

		--20230125 kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
		BEGIN  
        ------------------------------------------------------------------------  
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);  
	    SET @v_log_type = '12';  
	    SET @v_log_message = '########## Invalid Alphabet, Decimal. ##########';  
	    SET @v_description = '';  
		SET @d_event_date = SYSDATETIME();  
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		------------------------------------------------------------------------  
	    END;  	

	    --문자열 체크
	    BEGIN

		UPDATE A
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				   , MESSAGE_TEXT = 'This file contains invalid quantity data such as ‘Alphabet’, ‘Decimal’, etc. (e.g. a, b, c, 130.2, 50.4 …).'
		   FROM SCM_ADM_EXCEL_UPLOAD A WITH(NOLOCK)     
			JOIN (SELECT UPLOAD_ID, SUM(IIF(ISNUMERIC(VALUE) = 0, 1, 0)) AS PRICE
					  FROM (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15  
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
								  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)  
								 WHERE 1 = 1  
									 AND PROGRAM_ID    = @v_program_id
									 AND SHEET_NAME    = @v_sheet_name
									 AND CREATED_BY    = @p_created_by
									 AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
									 AND UPLOAD_STATUS_CODE = 'UPLOAD') T  
							  UNPIVOT ( VALUE  FOR COLUMN_NAME IN  (ATTRIBUTE14, ATTRIBUTE15  
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
																							, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200)) AS X
					 WHERE 1 = 1
						 AND LTRIM(RTRIM(VALUE)) ! = ''
						 AND VALUE ! = '0'
						 AND VALUE IS NOT NULL GROUP BY UPLOAD_ID) B ON A.UPLOAD_ID = B.UPLOAD_ID				
		  WHERE B.PRICE > 0

            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
	    END;

	    --소수점 체크
	    BEGIN

		UPDATE A
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				   , MESSAGE_TEXT = 'This file contains invalid quantity data such as ‘Alphabet’, ‘Decimal’, etc. (e.g. a, b, c, 130.2, 50.4 …).'
		   FROM SCM_ADM_EXCEL_UPLOAD A WITH(NOLOCK)
		   JOIN (SELECT UPLOAD_ID, SUM(IIF(ROUND(CONVERT(decimal(20, 5), VALUE), 10) - FLOOR(ROUND(CONVERT(decimal(20, 5), VALUE), 10)) <> 0, 1, 0)) AS PRICE
					 FROM (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15  
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
							  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)  
							WHERE 1 = 1  
								AND PROGRAM_ID = @v_program_id
								AND SHEET_NAME    = @v_sheet_name
								AND CREATED_BY    = @p_created_by
								AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
								AND UPLOAD_STATUS_CODE = 'UPLOAD') T  
						UNPIVOT ( VALUE  FOR COLUMN_NAME IN  (ATTRIBUTE14, ATTRIBUTE15  
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
																						, ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200)) AS X
					WHERE 1 = 1
						AND LTRIM(RTRIM(VALUE)) ! = ''
						AND VALUE ! = '0'
						AND VALUE IS NOT NULL
					GROUP BY UPLOAD_ID) B ON A.UPLOAD_ID = B.UPLOAD_ID 
		  WHERE PRICE > 0

            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
	    END;


		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '13';
		SET @v_log_message = '########## Invalid Measure Group. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Upload UOM.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
						AND    L.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE'
						AND    L.VALID_YN    = 'Y');
            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '14';
		SET @v_log_message = '########## Invalid Upload UOM. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		-- Upload UOM by Model
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Upload UOM Costpmer FCST.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[DM_MST_CUSTOMER_FCST] CF WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION] D2 WITH(NOLOCK)
                        WHERE  CF.DIVISION_ID = D2.DIVISION_ID
					    AND    CF.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2						
						AND    CF.MEASURE     = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10			
						and   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1  )
						AND    CF.VALID_YN    = 'Y');

            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                RETURN;
            END;

		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '15';
		SET @v_log_message = '########## Invalid Upload UOM Costpmer FCST. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		
		/*
		BEGIN
	    UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Project.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[DM_MST_CUSTOMER_MODEL] CM  WITH(NOLOCK)
                        WHERE  CM.DIVISION_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
						AND    CM.PROJECT_CODE          = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12
                        AND    CM.VALID_YN              = 'Y');
		END;
		
		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '16';
		SET @v_log_message = '########## Invalid Project. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		*/
		/*
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Model.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[DM_MST_CUSTOMER_MODEL] CM  WITH(NOLOCK)
                        WHERE  CM.DIVISION_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
						AND    CM.PROJECT_CODE          = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12
						AND    CM.ITEM_ID               = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE13
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Model ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '17';
	    SET @v_log_message = '########## Invalid Model. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		*/

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

	END;




	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = '17';
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
		SET @v_start_yyyymmdd = '';
	    SET @v_end_yyyymmdd = '';
		END;
		
		BEGIN
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '18';
		SET @v_log_message = '########## DELETE DATE START ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
		END;

		BEGIN
		SELECT @v_start_yyyymmdd = D.MIN_YYYYMMDD
		     , @v_end_yyyymmdd = D.MAX_YYYYMMDD
		FROM  (				
		       SELECT MIN(YYYYMMDD) AS MIN_YYYYMMDD
		            , MAX(YYYYMMDD) AS MAX_YYYYMMDD
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
		        AND    CREATED_BY    = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
		        AND    UPLOAD_STATUS_CODE = '@TITLE'
               ) T
       UNPIVOT (    YYYYMMDD
                FOR COLUMN_NAME
		        IN   ( 
                       --ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, 
                       ATTRIBUTE15
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
				     )
		           ) AS X
		WHERE X.YYYYMMDD != ''	
		) AS D;			
        END;

        PRINT '@v_start_yyyymmdd:'+isnull(@v_start_yyyymmdd,'null')+','+'@v_end_yyyymmdd:'+isnull(@v_end_yyyymmdd,'null');

		BEGIN
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '19-1';
		SET @v_log_message = '########## DELETE DATE END ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
		END;

		BEGIN TRANSACTION FCST_UPLOAD;
		BEGIN TRY
			BEGIN

        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '20-1';
		SET @v_log_message = '########## DELETE DM_PLN_CUSTOMER_PSI DATE END ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------


			DELETE [dbo].[DM_PLN_CUSTOMER_PSI]  
			WHERE  1 = 1
			AND    MEASURE_GROUP = 'CUST_FCST'
			-- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
			AND    (
			          SELECT  count(1)
						FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
						WHERE  T.PROGRAM_ID         = @v_program_id
						AND    T.SHEET_NAME         = @v_sheet_name
						AND    T.CREATED_BY         = @p_created_by
						AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
						AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' 
						AND   [DM_PLN_CUSTOMER_PSI].DIVISION_ID           =  T.ATTRIBUTE1
						AND   [DM_PLN_CUSTOMER_PSI].SCM_SITE_ID           =  T.ATTRIBUTE2
						AND   [DM_PLN_CUSTOMER_PSI].PLANT_SITE_ID         =  T.ATTRIBUTE3
						AND   [DM_PLN_CUSTOMER_PSI].CUSTOMER_PROJECT_CODE =  T.ATTRIBUTE4
						AND   [DM_PLN_CUSTOMER_PSI].CUSTOMER_MODEL        =  T.ATTRIBUTE5
						AND   [DM_PLN_CUSTOMER_PSI].INCOTERMS             =  T.ATTRIBUTE6
						AND   [DM_PLN_CUSTOMER_PSI].FCST_TYPE             =  T.ATTRIBUTE7
						AND   [DM_PLN_CUSTOMER_PSI].DOM_EXP               =  T.ATTRIBUTE8
						AND   [DM_PLN_CUSTOMER_PSI].MEASURE               =  T.ATTRIBUTE10
			       ) > 0
			AND    YYYYMMDD BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd;

            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                PRINT 'MEASURE_GROUP = CUST_FCST'+CONVERT(NVARCHAR(MAX),@v_err_cnt);
            END;
            ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '20';
		SET @v_log_message = '########## DELETE DM_PLN_CUSTOMER_PSI DATE END ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------

			END;
PRINT '20'		

			BEGIN

			-- 엑셀로 업로드된 MEASURE를 MASTER의 MEASURE로 변경
			UPDATE  AA
			SET		ATTRIBUTE10 = BB.MEASURE
			FROM	SCM_ADM_EXCEL_UPLOAD  AS AA WITH(NOLOCK)
			INNER JOIN (
				SELECT DISTINCT
					A.DIVISION_ID 
					, B.DIVISION_NAME
					, A.SCM_SITE_ID
					, A.VALID_YN 
					, A.MEASURE
					, A.UPLOAD_UOM
					, A.UPLOAD_BUCKET_TYPE
				FROM DM_MST_CUSTOMER_FCST	 AS A WITH(NOLOCK)
				INNER JOIN SCM_MST_DIVISION  AS B WITH(NOLOCK)
				ON A.VALID_YN		= 'Y'
				AND A.DIVISION_ID	= B.DIVISION_ID
			) AS BB
			ON ( BB.DIVISION_ID = AA.ATTRIBUTE1 OR  BB.DIVISION_NAME = AA.ATTRIBUTE1  )
			AND  BB.SCM_SITE_ID = AA.ATTRIBUTE2
			AND  BB.MEASURE     = AA.ATTRIBUTE10
			AND  BB.UPLOAD_UOM	= AA.ATTRIBUTE11
			AND	 BB.UPLOAD_BUCKET_TYPE IN (

					SELECT CASE DATEDIFF( DAY, CAST( Z.ATTRIBUTE14 AS DATETIME) , CAST( Z.ATTRIBUTE15 AS DATETIME) )	WHEN 1 THEN 'DAILY' 
																														WHEN 7 THEN 'WEEKLY' 
																														ELSE 'MONTHLY' END
					FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] Z  WITH(NOLOCK)
					WHERE  Z.PROGRAM_ID = @v_program_id
					AND    Z.SHEET_NAME = @v_sheet_name
					AND    Z.CREATED_BY = @p_created_by
					AND    CONVERT(NVARCHAR(40), Z.CREATION_DATE, 121) = @v_creation_date
					AND    Z.UPLOAD_STATUS_CODE = '@TITLE'
			)
			WHERE AA.PROGRAM_ID = @v_program_id
			AND   AA.SHEET_NAME = @v_sheet_name
			AND   AA.CREATED_BY = @p_created_by
			AND   AA.UPLOAD_STATUS_CODE = 'SUCCESS'
			AND    CONVERT(NVARCHAR(40), AA.CREATION_DATE, 121) = @v_creation_date

            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                PRINT 'ATTRIBUTE10 = BB.MEASURE '+CONVERT(NVARCHAR(MAX),@v_err_cnt);
            END;

PRINT 'INSERT INTO [dbo].[DM_PLN_CUSTOMER_PSI] ========================================================================================================='
		
			INSERT INTO [dbo].[DM_PLN_CUSTOMER_PSI]
			(
				DIVISION_ID
			  , SCM_SITE_ID
			  , PLANT_SITE_ID
			  , CUSTOMER_PROJECT_CODE
			  , CUSTOMER_MODEL
			  , INCOTERMS
			  , FCST_TYPE
			  , DOM_EXP
			  , MEASURE_GROUP
			  , MEASURE
			  , UPLOAD_UOM
			  , PROJECT_CODE
			  , ITEM_ID
			  , YYYYMMDD
			  , QTY
			  , CREATED_BY
			  , CREATION_DATE
			  , LAST_UPDATED_BY
			  , LAST_UPDATE_DATE
			  , BATCH_RESULT
			)			
			SELECT V.ATTRIBUTE1, V.ATTRIBUTE2, V.ATTRIBUTE3, V.ATTRIBUTE4, V.ATTRIBUTE5
				 , V.ATTRIBUTE6, V.ATTRIBUTE7, V.ATTRIBUTE8, V.ATTRIBUTE9, V.ATTRIBUTE10
				 , V.ATTRIBUTE11, V.ATTRIBUTE12, V.ATTRIBUTE13
				 , C.YYYYMMDD  , CONVERT(int, V.VALUE), @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
				 , @p_created_by, CONVERT(varchar(19), GETDATE(), 121), 'UI'
			FROM  (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13
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
						   AND    CREATED_BY    = @p_created_by
						   -- modified by ytchoi 180305
						  -- AND    CREATION_DATE = @v_creation_date
						   AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) =  @v_creation_date
						   AND    UPLOAD_STATUS_CODE = '@TITLE'
						  ) T
				  UNPIVOT (    YYYYMMDD
						   FOR COLUMN_NAME
						   IN   ( ATTRIBUTE14, ATTRIBUTE15
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
								)
						  ) AS X
				  ) C
				, (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13
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
						   AND    CREATED_BY    = @p_created_by
						   AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
						   AND    UPLOAD_STATUS_CODE = 'SUCCESS'
						  ) T
				  UNPIVOT (    VALUE
						   FOR COLUMN_NAME
						   IN   ( ATTRIBUTE14, ATTRIBUTE15
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
								)
							) AS X
				  ) V               
			WHERE 1 = 1	
			AND   C.COLUMN_NAME = V.COLUMN_NAME
			AND   C.YYYYMMDD != ''
			AND   V.VALUE ! = ''

            SET @v_err_cnt = @@ROWCOUNT;
            IF @v_err_cnt > 0 BEGIN
                PRINT 'INSERT INTO [dbo].[DM_PLN_CUSTOMER_PSI] '+CONVERT(NVARCHAR(MAX),@v_err_cnt);
            END;

			END;

PRINT '21'		
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '21';
		SET @v_log_message = '########## INSERT DM_PLN_CUSTOMER_PSI DATE END ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------

		    IF(@v_division = '40') 
			BEGIN
				EXEC [dbo].[PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40] '40';		
	        END
			ELSE
			BEGIN
                IF TRY_CONVERT(NVARCHAR(MAX), GETDATE(), 112) > '20260412' BEGIN
				EXEC [dbo].[PR_DM_PLN_CUST_FCST_TO_MKT_FCST];
                END;
	        END;

		    COMMIT WORK;
        END TRY
		BEGIN CATCH
		    ROLLBACK TRANSACTION FCST_UPLOAD;
		END CATCH
				
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
