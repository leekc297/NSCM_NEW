




-- =============================================
-- Author:		 P.C.I
-- Create date:  2024-04-17
-- Description:	 DM_PLN_MKT_FCST_RESULT Incoterms, Plant(A040,A041) Conversion
-- =============================================
/*
 *===================================================================================================
 * Program ID   : PR_TMP_NERP_DM_PLN_MKT_FCST_RESULT
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *	2024-04-17	P.C.I			DM_PLN_MKT_FCST_RESULT Incoterms, Plant(A040,A041) Conversion
 *	2025-06-23	KANG.H.J		[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 *===================================================================================================
 */
CREATE PROCEDURE [dbo].[PR_TMP_NERP_DM_PLN_MKT_FCST_RESULT_20250623_KHJ]

AS

BEGIN 

	--------------------------------------------------------------------------------------------	
	BEGIN TRANSACTION;
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------


	SET NOCOUNT ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_DM_PLN_MKT_FCST_RESULT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
	--@@ROWCOUNT
	DECLARE @UPDATE_CNT_INCOTERMS INT;
	DECLARE @UPDATE_CNT_PLANT INT;
	SET @UPDATE_CNT_INCOTERMS = 0;
	SET @UPDATE_CNT_PLANT = 0;
	/*
	print 'PR_TMP_NERP_DM_PLN_MKT_FCST_RESULT'
	
	IF OBJECT_ID (N'DBO.BACKUP_DM_PLN_MKT_FCST_RESULT', N'U') IS NOT NULL 	
		DROP TABLE DBO.BACKUP_DM_PLN_MKT_FCST_RESULT

	SELECT *
	INTO   DBO.BACKUP_DM_PLN_MKT_FCST_RESULT
	FROM   DM_PLN_MKT_FCST_RESULT;
	
	-- Conversion Table 기준으로 SITE Incoterms List 정리(2024.12.26) Start
	DELETE FROM DBO.ZNERP_TARGET_SITE;

	DELETE FROM DBO.ZNERP_TARGET_SITE_INCOTERMS;
		
	INSERT INTO DBO.ZNERP_TARGET_SITE
	SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID
	FROM  [dbo].DM_PLN_MKT_FCST_RESULT A with(nolock) --DM_PLN_MKT_FCST_RESULT
	WHERE  INCOTERMS IN ( SELECT DISTINCT OLD_INCOTERMS FROM DBO.ZNERP_TARGET_INCOTERMS)
	; 
		
	INSERT INTO DBO.ZNERP_TARGET_SITE_INCOTERMS
	SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID AS SALES_SITE_ID, ISNULL(B.DOM_EXP, 'E') AS DOM_EXP, C.OLD_INCOTERMS, C.NEW_INCOTERMS
	FROM  DBO.ZNERP_TARGET_SITE A with(nolock)
	LEFT JOIN  [dbo].[NERP_SALES_RESULT_IF_DOM_EXP] B with(nolock)
	ON  A.DIVISION_ID = B.DIVISION_ID
	AND A.SCM_SITE_ID = B.SALES_SITE_ID
	LEFT JOIN  DBO.ZNERP_TARGET_INCOTERMS C WITH(NOLOCK)
	ON   ISNULL(B.DOM_EXP, 'E') = C.DOM_EXP  
	;
	-- Conversion Table 기준으로 SITE Incoterms List 정리(2024.12.26) End

	
	DECLARE @oldIncoterms VARCHAR(10), @dom_exp VARCHAR(10), @newIncoterms VARCHAR(10) ;

	DECLARE @newCode VARCHAR(50);
	DECLARE @count int, @checkCode varchar(50);
	

	DECLARE cursorUpdate CURSOR FOR
	
		--Z03, Z04 -> DAP 동시에 발생하면 Merge 중복데이터 발생하므로 Cursor 사용
		--Z01, Z02 인 경우에만 DOM_EXP 구분 필요 함 
		SELECT DISTINCT OLD_INCOTERMS AS OLD_INCOTERMS--, CASE WHEN OLD_VALUE1 IN ('Z01', 'Z02')  THEN  OLD_VALUE2 ELSE 'E' END AS DOM_EXP, NEW_VALUE1 AS NEW_INCOTERMS -- Incoterms 만 대상 (2024.12.26)
		FROM   DBO.ZNERP_TARGET_INCOTERMS WITH(NOLOCK) --ZNERP_TARGET_INCOTERMS 변경 (2024.12.26)
		--WHERE  CODETYPE = 'INCOTERMS_ID'
		;
		;


	OPEN cursorUpdate;
	FETCH NEXT FROM cursorUpdate INTO  @oldIncoterms; --, @dom_exp ,@newIncoterms ;-- Incoterms 만 대상 (2024.12.26)

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		
		--Incoterms Conversion
		MERGE INTO DM_PLN_MKT_FCST_RESULT AS A
		USING (SELECT A.*, B.NEW_INCOTERMS AS NewCode --, @newIncoterms AS NewCode -- NEW_INCOTERMS 변경(2024.12.26)
				FROM DM_PLN_MKT_FCST_RESULT A with(nolock)
				--LEFT OUTER JOIN [dbo].[NERP_SALES_RESULT_IF_DOM_EXP] B with(nolock)
				INNER JOIN DBO.ZNERP_TARGET_SITE_INCOTERMS B with(nolock) -- Inner Join 변경(Conversion Table 기준으로 SITE Incoterms List만 대상)(2024.12.26)
				ON  A.DIVISION_ID = B.DIVISION_ID
				AND A.SCM_SITE_ID = B.SALES_SITE_ID
				AND A.INCOTERMS = B.OLD_INCOTERMS -- Incoterms Mapping 추가(2024.12.26)
				--AND B.DOM_EXP = (CASE WHEN @oldIncoterms IN ('Z01', 'Z02')  THEN  @dom_exp ELSE B.DOM_EXP END) --Z01, Z02 인 경우에만 DOM_EXP 구분 필요 함 
				WHERE INCOTERMS = @oldIncoterms 
				) AS B
		ON   (  A.incoterms = B.NewCode
			AND A.division_id= B.division_id
			AND A.project_code = B.project_code
			AND A.scm_site_id = B.scm_site_id
			AND A.item_id= B.item_id
			AND A.plant_site_id= B.plant_site_id
			AND A.dom_exp = B.dom_exp
			AND A.fcst_type= B.fcst_type
			AND A.measure = B.measure
			AND A.yyyymmdd = B.yyyymmdd )
		WHEN NOT MATCHED THEN 
			INSERT   
			VALUES (B.division_id , B.project_code , B.scm_site_id , B.item_id , B.dom_exp ,
					B.fcst_type , B.newCode, B.measure, B.plant_site_id , B.yyyymmdd ,B.qty , B.created_by , B.creation_date , B.last_updated_by, B.last_update_date ,
					B.attribute1 , B.attribute2 , B.attribute3 , B.attribute4 , B.attribute5 , B.attribute6 ,
					B.attribute7 , B.attribute8 , B.attribute9 , B.attribute10, B.so_rank, B.so_no, B.so_qty)
		WHEN MATCHED THEN 
			UPDATE SET 
				A.QTY = A.QTY + B.QTY, 
				A.attribute1 = CASE WHEN A.attribute1 IS NULL AND B.attribute1 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute1)=1 and ISNUMERIC(B.attribute1)=1)
										THEN CAST((CAST(A.attribute1 AS float) + CAST(B.attribute1 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute1, '') + IIF(ISNULL(A.attribute1,'')='' OR ISNULL(B.attribute1,'')='', '', ',') + ISNULL(B.attribute1, '')
							END,
				A.attribute2 = CASE WHEN A.attribute2 IS NULL AND B.attribute2 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute2)=1 and ISNUMERIC(B.attribute2)=1)
										THEN CAST((CAST(A.attribute2 AS float) + CAST(B.attribute2 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute2, '') + IIF(ISNULL(A.attribute2,'')='' OR ISNULL(B.attribute2,'')='', '', ',') + ISNULL(B.attribute2, '')
							END,
				A.attribute3 = CASE WHEN A.attribute3 IS NULL AND B.attribute3 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute3)=1 and ISNUMERIC(B.attribute3)=1)
										THEN CAST((CAST(A.attribute3 AS float) + CAST(B.attribute3 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute3, '') + IIF(ISNULL(A.attribute3,'')='' OR ISNULL(B.attribute3,'')='', '', ',') + ISNULL(B.attribute3, '')
							END,
				A.attribute4 = CASE WHEN A.attribute4 IS NULL AND B.attribute4 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute4)=1 and ISNUMERIC(B.attribute4)=1)
										THEN CAST((CAST(A.attribute4 AS float) + CAST(B.attribute4 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute4, '') + IIF(ISNULL(A.attribute4,'')='' OR ISNULL(B.attribute4,'')='', '', ',') + ISNULL(B.attribute4, '')
							END,
				A.attribute5 = CASE WHEN A.attribute5 IS NULL AND B.attribute5 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute5)=1 and ISNUMERIC(B.attribute5)=1)
										THEN CAST((CAST(A.attribute5 AS float) + CAST(B.attribute5 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute5, '') + IIF(ISNULL(A.attribute5,'')='' OR ISNULL(B.attribute5,'')='', '', ',') + ISNULL(B.attribute5, '')
							END,
				A.attribute6 = CASE WHEN A.attribute6 IS NULL AND B.attribute6 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute6)=1 and ISNUMERIC(B.attribute6)=1)
										THEN CAST((CAST(A.attribute6 AS float) + CAST(B.attribute6 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute6, '') + IIF(ISNULL(A.attribute6,'')='' OR ISNULL(B.attribute6,'')='', '', ',') + ISNULL(B.attribute6, '')
							END,
				A.attribute7 = CASE WHEN A.attribute7 IS NULL AND B.attribute7 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute7)=1 and ISNUMERIC(B.attribute7)=1)
										THEN CAST((CAST(A.attribute7 AS float) + CAST(B.attribute7 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute7, '') + IIF(ISNULL(A.attribute7,'')='' OR ISNULL(B.attribute7,'')='', '', ',') + ISNULL(B.attribute7, '')
							END,
				A.attribute8 = CASE WHEN A.attribute8 IS NULL AND B.attribute8 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute8)=1 and ISNUMERIC(B.attribute8)=1)
										THEN CAST((CAST(A.attribute8 AS float) + CAST(B.attribute8 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute8, '') + IIF(ISNULL(A.attribute8,'')='' OR ISNULL(B.attribute8,'')='', '', ',') + ISNULL(B.attribute8, '')
							END,
				A.attribute9 = CASE WHEN A.attribute9 IS NULL AND B.attribute9 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute9)=1 and ISNUMERIC(B.attribute9)=1)
										THEN CAST((CAST(A.attribute9 AS float) + CAST(B.attribute9 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute9, '') + IIF(ISNULL(A.attribute9,'')='' OR ISNULL(B.attribute9,'')='', '', ',') + ISNULL(B.attribute9, '')
							END,
				A.attribute10 = CASE WHEN A.attribute10 IS NULL AND B.attribute10 IS NULL THEN NULL
									WHEN (ISNUMERIC(A.attribute10)=1 and ISNUMERIC(B.attribute10)=1)
										THEN CAST((CAST(A.attribute10 AS float) + CAST(B.attribute10 AS float)) AS NVARCHAR(150))
									ELSE ISNULL(A.attribute10, '') + IIF(ISNULL(A.attribute10,'')='' OR ISNULL(B.attribute10,'')='', '', ',') + ISNULL(B.attribute10, '')
							END,
				A.SO_NO = ISNULL(A.SO_NO, '') + IIF(ISNULL(A.SO_NO,'')='' OR ISNULL(B.so_no,'')='', '', ',') + ISNULL(B.so_no, ''),
				A.SO_QTY = ISNULL(A.SO_QTY, '') + IIF(ISNULL(A.SO_QTY,'')='' OR ISNULL(B.so_qty,'')='', '', ',') + ISNULL(B.so_qty, '')
				;
				
		SET @UPDATE_CNT_INCOTERMS = @UPDATE_CNT_INCOTERMS +  @@ROWCOUNT;


		DELETE FROM DM_PLN_MKT_FCST_RESULT 
		WHERE INCOTERMS = @oldIncoterms 
		;



		FETCH NEXT FROM cursorUpdate INTO  @oldIncoterms; --, @dom_exp ,@newIncoterms ;-- Incoterms 만 대상 (2024.12.26)
	END

	CLOSE cursorUpdate;
	DEALLOCATE cursorUpdate;


	
	*/
	
	--Plant_Site Conversion
	MERGE INTO DM_PLN_MKT_FCST_RESULT AS A
	USING ( SELECT *
	             , CASE WHEN CHARINDEX('-', PLANT_SITE_ID) > 0 THEN 'A040' + SUBSTRING(PLANT_SITE_ID, CHARINDEX('-', PLANT_SITE_ID), LEN(PLANT_SITE_ID))
			            ELSE 'A040' END AS NewCode
			FROM DM_PLN_MKT_FCST_RESULT with(nolock)
			WHERE PLANT_SITE_ID LIKE 'A041%' ) AS B
	ON   (  A.PLANT_SITE_ID = B.NewCode
		AND A.division_id= B.division_id
		AND A.project_code = B.project_code
		AND A.scm_site_id = B.scm_site_id
		AND A.item_id= B.item_id
		AND A.dom_exp = B.dom_exp
		AND A.fcst_type= B.fcst_type
		AND A.incoterms= B.incoterms
		AND A.measure = B.measure
		AND A.yyyymmdd = B.yyyymmdd 
		AND A.cell_prod_site_id = B.cell_prod_site_id			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
		)
	WHEN NOT MATCHED THEN 
		INSERT   
		VALUES (B.division_id , B.project_code , B.scm_site_id , B.item_id , B.dom_exp ,
				B.fcst_type , B.incoterms, B.measure, B.newCode , B.yyyymmdd ,B.qty , B.created_by , B.creation_date , B.last_updated_by, B.last_update_date ,
				B.attribute1 , B.attribute2 , B.attribute3 , B.attribute4 , B.attribute5 , B.attribute6 ,
				B.attribute7 , B.attribute8 , B.attribute9 , B.attribute10, B.so_rank, B.so_no, B.so_qty ,
				B.cell_prod_site_id					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				)
	WHEN MATCHED THEN 
		UPDATE SET 
			A.QTY = A.QTY + B.QTY, 
			A.attribute1 = CASE WHEN A.attribute1 IS NULL AND B.attribute1 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute1)=1 and ISNUMERIC(B.attribute1)=1)
									THEN CAST((CAST(A.attribute1 AS float) + CAST(B.attribute1 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute1, '') + IIF(ISNULL(A.attribute1,'')='' OR ISNULL(B.attribute1,'')='', '', ',') + ISNULL(B.attribute1, '')
						END,
			A.attribute2 = CASE WHEN A.attribute2 IS NULL AND B.attribute2 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute2)=1 and ISNUMERIC(B.attribute2)=1)
									THEN CAST((CAST(A.attribute2 AS float) + CAST(B.attribute2 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute2, '') + IIF(ISNULL(A.attribute2,'')='' OR ISNULL(B.attribute2,'')='', '', ',') + ISNULL(B.attribute2, '')
						END,
			A.attribute3 = CASE WHEN A.attribute3 IS NULL AND B.attribute3 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute3)=1 and ISNUMERIC(B.attribute3)=1)
									THEN CAST((CAST(A.attribute3 AS float) + CAST(B.attribute3 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute3, '') + IIF(ISNULL(A.attribute3,'')='' OR ISNULL(B.attribute3,'')='', '', ',') + ISNULL(B.attribute3, '')
						END,
			A.attribute4 = CASE WHEN A.attribute4 IS NULL AND B.attribute4 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute4)=1 and ISNUMERIC(B.attribute4)=1)
									THEN CAST((CAST(A.attribute4 AS float) + CAST(B.attribute4 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute4, '') + IIF(ISNULL(A.attribute4,'')='' OR ISNULL(B.attribute4,'')='', '', ',') + ISNULL(B.attribute4, '')
						END,
			A.attribute5 = CASE WHEN A.attribute5 IS NULL AND B.attribute5 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute5)=1 and ISNUMERIC(B.attribute5)=1)
									THEN CAST((CAST(A.attribute5 AS float) + CAST(B.attribute5 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute5, '') + IIF(ISNULL(A.attribute5,'')='' OR ISNULL(B.attribute5,'')='', '', ',') + ISNULL(B.attribute5, '')
						END,
			A.attribute6 = CASE WHEN A.attribute6 IS NULL AND B.attribute6 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute6)=1 and ISNUMERIC(B.attribute6)=1)
									THEN CAST((CAST(A.attribute6 AS float) + CAST(B.attribute6 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute6, '') + IIF(ISNULL(A.attribute6,'')='' OR ISNULL(B.attribute6,'')='', '', ',') + ISNULL(B.attribute6, '')
						END,
			A.attribute7 = CASE WHEN A.attribute7 IS NULL AND B.attribute7 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute7)=1 and ISNUMERIC(B.attribute7)=1)
									THEN CAST((CAST(A.attribute7 AS float) + CAST(B.attribute7 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute7, '') + IIF(ISNULL(A.attribute7,'')='' OR ISNULL(B.attribute7,'')='', '', ',') + ISNULL(B.attribute7, '')
						END,
			A.attribute8 = CASE WHEN A.attribute8 IS NULL AND B.attribute8 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute8)=1 and ISNUMERIC(B.attribute8)=1)
									THEN CAST((CAST(A.attribute8 AS float) + CAST(B.attribute8 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute8, '') + IIF(ISNULL(A.attribute8,'')='' OR ISNULL(B.attribute8,'')='', '', ',') + ISNULL(B.attribute8, '')
						END,
			A.attribute9 = CASE WHEN A.attribute9 IS NULL AND B.attribute9 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute9)=1 and ISNUMERIC(B.attribute9)=1)
									THEN CAST((CAST(A.attribute9 AS float) + CAST(B.attribute9 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute9, '') + IIF(ISNULL(A.attribute9,'')='' OR ISNULL(B.attribute9,'')='', '', ',') + ISNULL(B.attribute9, '')
						END,
			A.attribute10 = CASE WHEN A.attribute10 IS NULL AND B.attribute10 IS NULL THEN NULL
								WHEN (ISNUMERIC(A.attribute10)=1 and ISNUMERIC(B.attribute10)=1)
									THEN CAST((CAST(A.attribute10 AS float) + CAST(B.attribute10 AS float)) AS NVARCHAR(150))
								ELSE ISNULL(A.attribute10, '') + IIF(ISNULL(A.attribute10,'')='' OR ISNULL(B.attribute10,'')='', '', ',') + ISNULL(B.attribute10, '')
						END,
			A.SO_NO = ISNULL(A.SO_NO, '') + IIF(ISNULL(A.SO_NO,'')='' OR ISNULL(B.so_no,'')='', '', ',') + ISNULL(B.so_no, ''),
			A.SO_QTY = ISNULL(A.SO_QTY, '') + IIF(ISNULL(A.SO_QTY,'')='' OR ISNULL(B.so_qty,'')='', '', ',') + ISNULL(B.so_qty, ''),
			A.CELL_PROD_SITE_ID = ISNULL(A.CELL_PROD_SITE_ID, '') + IIF(ISNULL(A.CELL_PROD_SITE_ID,'')='' OR ISNULL(B.CELL_PROD_SITE_ID,'')='', '', ',') + ISNULL(B.CELL_PROD_SITE_ID, '')	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			
			;

	SET @UPDATE_CNT_PLANT = @UPDATE_CNT_PLANT +  @@ROWCOUNT;
			
	DELETE FROM DM_PLN_MKT_FCST_RESULT 
	WHERE  PLANT_SITE_ID LIKE 'A041%' 
	;
	
	-- STEP
	SET @v_log_type = 'STEP';
	SET @v_log_message = '';
	SET @n_log_count = @UPDATE_CNT_INCOTERMS + @UPDATE_CNT_PLANT;
	SET @v_description = '@UPDATE_CNT_INCOTERMS : ' + CAST(@UPDATE_CNT_INCOTERMS AS NVARCHAR(1000)) + '/@UPDATE_CNT_PLANT : ' + CAST(@UPDATE_CNT_PLANT AS NVARCHAR(1000));
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	
	-- Incoterms 외 Converion 수행
	EXEC PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM @p_table_name = N'DM_PLN_MKT_FCST_RESULT'
	
	-- BACKUP_FLAG 변경
	UPDATE  ZNERP_TARGET_INFO_DM  
	SET CONVERSION_FLAG = 'Y'
	  , BACKUP_FLAG = 'N'
	  , MODIFY_USER_ID = 'PR_TMP_NERP_DM_PLN_MKT_FCST_RESULT'
	  , MODIFY_DATE = getDate()
	WHERE TABLE_NAME = 'DM_PLN_MKT_FCST_RESULT'
	AND CONVERSION_FLAG = 'N'
	;
	
	COMMIT;
	PRINT 'Transaction succeed!';
	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @n_log_count = 0;
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	
	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		ROLLBACK;
		PRINT 'Transaction is cancels cause of error';
		
		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @n_log_count = 0;
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	 
		
		DECLARE @fileCursorStatus INT;

		SET @fileCursorStatus = CURSOR_STATUS('GLOBAL', 'cursorUpdate');
 
		IF (@fileCursorStatus >= 0)
		BEGIN
			PRINT 'Closing fileCursor cursorUpdate';
			CLOSE cursorUpdate;
			DEALLOCATE cursorUpdate;
		END

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	


END






