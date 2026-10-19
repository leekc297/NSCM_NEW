





-- =============================================
-- Author:		 victory25 NERP_SSP
-- Create date:  2024-02-15
-- Description:	 table info data converter
-- =============================================
CREATE PROCEDURE [dbo].[PR_TMP_NERP_LOOKUP_CONVERTER_UPDATE_SSP]
AS
BEGIN
	DECLARE @LOOKUP_TYPE   NVARCHAR(150) = N''; 
	DECLARE @TABLE_NAME   NVARCHAR(150) = N''; 
	DECLARE @TABLE_NAME_NEW   NVARCHAR(150) = N''; 
	DECLARE @COL_INFO   NVARCHAR(150) = N''; 
	DECLARE @TABLE_COL   NVARCHAR(150) = N''; 
	DECLARE @TABLE_COL2   NVARCHAR(150) = N''; 
	DECLARE @TABLE_COL3   NVARCHAR(150) = N''; 
	DECLARE @PLANT_COL1   NVARCHAR(150) = N''; 
	DECLARE @MASTER_CODETYPE   NVARCHAR(150) = N''; 
	DECLARE @MASTER_CODETYPE2   NVARCHAR(150) = N''; 
	DECLARE @MASTER_CODETYPE3   NVARCHAR(150) = N''; 
	DECLARE @CNT INT;
	DECLARE @SELECT_COL NVARCHAR(MAX);
	DECLARE @mEXEC NVARCHAR(MAX);
	DECLARE @BACKUP_START_TIME  NVARCHAR(50) = N''; 
	DECLARE @BACKUP_END_TIME  NVARCHAR(50) = N''; 
	DECLARE @UPDATE_START_TIME  NVARCHAR(50) = N''; 
	DECLARE @UPDATE_END_TIME  NVARCHAR(50) = N''; 


	--------------------------------------------------
	--STEP 0. TARGET TABLE BACKUP 
	--------------------------------------------------
	BEGIN

		IF OBJECT_ID('SCM_ADM_LOOKUP_MASTER_DETAIL_SSP') IS NOT NULL	
			DROP TABLE SCM_ADM_LOOKUP_MASTER_DETAIL_SSP;

		--SELECT *
		--INTO DBO.SCM_ADM_LOOKUP_MASTER_DETAIL_SSP
		--FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
		--WHERE LOOKUP_TYPE IN (
		--'ADJUST_MAIL_SEND',
		--'BASIS_START_TIME_PLANT',
		--'CELL_SHIP_FROM_TO',
		--'ELECTRODE_ASSY_PLANT_MAPPING',
		--'ELECTRODE_OWMS_PLANT_MAPPING',
		--'ELECTRODE_SHIP_FROM_TO',
		--'ELECTRODE_SHIP_REQ_AUTO_CREATE',
		--'ELECTRODE_SHIP_REQ_OW_PERIOD',
		--'ELECTRODE_SHIP_STORAGE',
		--'IF_STOCK_CHECK',
		--'MY_MODEL_DEFAULT_CHECK',
		--'SHIP_PLAN_INTER_COM_MAIL_SEND',
		--'SHIP_REQ_DEL_MAIL_SEND',
		--'SHIP_RESULT_TO_SITE_MAPPING',
		--'SSP_ANL_SHIP_PLAN_ALL',
		--'SSP_AS_DIV_SLOC',
		--'SSP_IF_STOCK_CHECK',
		--'WARNING_MAIL_SEND',
		--'WARNING_MAIL_SEND_40',
		--'ESS_STOCK_STORAGE_ID',
		--'SSP_SHIP_RESULT_EXCEPT_STORAGE'
		--)


		SELECT *
		INTO DBO.SCM_ADM_LOOKUP_MASTER_DETAIL_SSP
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
		WHERE LOOKUP_TYPE IN (
								SELECT DISTINCT LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER WITH(NOLOCK)
								WHERE LOOKUP_GROUP = 'SSP'
  							  )
		AND   LOOKUP_TYPE != 'SSP_AS_DIV_SLOC'
		AND   LOOKUP_TYPE IN (SELECT DISTINCT LOOKUP_TYPE FROM ZNERP_LOOKUP_INFO_SSP WITH(NOLOCK))

	END
	
	------------------------------------------------------
	--STEP 2. TARGET TABLE UPDATE 
	------------------------------------------------------
	BEGIN
		declare @p nvarchar(max) = '';
		DECLARE @WORK_AVALIABLE TABLE (TABLE_COL NVARCHAR(150), MASTER_CODETYPE NVARCHAR(150));

		DECLARE LOOKUP_CURSOR CURSOR FOR
		SELECT DISTINCT LOOKUP_TYPE FROM ZNERP_LOOKUP_INFO_SSP WITH(NOLOCK) 

		OPEN LOOKUP_CURSOR;
		FETCH NEXT FROM LOOKUP_CURSOR
		INTO @LOOKUP_TYPE

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM @WORK_AVALIABLE;

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC + 'SELECT DISTINCT TABLE_COL, MASTER_CODETYPE FROM ZNERP_LOOKUP_INFO_SSP WHERE LOOKUP_TYPE = ''' + @LOOKUP_TYPE + '''' +CHAR(10);	

			PRINT @mEXEC;   
			INSERT @WORK_AVALIABLE EXEC SP_EXECUTESQL @mEXEC ;
			-----------------------------------------------
			-- STEP 2-1. DISTINCT COLUMN STRING MAKE
			-- DISTINCT A.COMPANY_ID, B1.TO_COMPANY_ID AS COMPANY_ID_B1, A.PLANT_ID, B2.TO_PLANT_ID AS PLANT_ID_B2, A.TO_PLANT_ID, B3.TO_PLANT_ID AS PLANT_ID_B3
			-----------------------------------------------
			BEGIN
				DECLARE  @mDisQuery NVARCHAR(MAX) = '';
				DECLARE  @mSubQuery NVARCHAR(MAX) = '';
				DECLARE  @mUpdateQuery NVARCHAR(MAX) = '';
				DECLARE  @mUpdateWhereQuery NVARCHAR(MAX) = '';
				DECLARE  @mTableQuery NVARCHAR(MAX) = '';

				SET @mDisQuery = '';
				SET @mSubQuery = '';
				SET @mUpdateQuery = '';
				SET @mUpdateWhereQuery = '';
				SET @mTableQuery = '';
				DECLARE @PRIFIX NVARCHAR(30);

				DECLARE LOOKUP_CURSOR2 CURSOR FOR SELECT TABLE_COL, MASTER_CODETYPE FROM @WORK_AVALIABLE ORDER BY TABLE_COL
				SET @CNT = 1;

				OPEN LOOKUP_CURSOR2;
				FETCH NEXT FROM LOOKUP_CURSOR2
				INTO  @TABLE_COL3, @MASTER_CODETYPE3;

				PRINT @TABLE_NAME + '1. ' +CONVERT(CHAR(23), GETDATE(), 21);

				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					-----------------------------------------------
					-- STEP 2-1. DISTINCT COLUMN STRING MAKE
					-- DISTINCT A.COMPANY_ID, B1.TO_COMPANY_ID AS COMPANY_ID_B1, A.PLANT_ID, B2.TO_PLANT_ID AS PLANT_ID_B2, A.TO_PLANT_ID, B3.TO_PLANT_ID AS PLANT_ID_B3
					-----------------------------------------------
					BEGIN
						IF @mDisQuery = ''
						BEGIN  --처음인경우
							IF @MASTER_CODETYPE3 = 'STORAGE_ID'
							BEGIN
								SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
							END
							ELSE 
							BEGIN
								SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
							END
						END
						ELSE
						BEGIN --두번째인경우
							IF @MASTER_CODETYPE3 = 'STORAGE_ID'
							BEGIN
								SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
							END
							ELSE 
							BEGIN
								SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
							END
						END
					END

					-----------------------------------------------
					-- STEP 2-2. DISTINCT COLUMN STRING MAKE
					-- LEFT JOIN NERP_CONV_MASTER B1
					-- ON A.COMPANY_ID = B1.FROM_COMPANY_ID
					-- AND B1.CODETYPE = 'COMPANY_ID'
					-----------------------------------------------
					BEGIN
						IF @MASTER_CODETYPE3 LIKE '%COMPANY%'
						BEGIN
							SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + ' AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''3rd''' +CHAR(10);	
						END

						IF @MASTER_CODETYPE3 LIKE '%END_CUSTOMER%'
						BEGIN
							SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + ' AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''3rd''' +CHAR(10);	
						END

						IF @MASTER_CODETYPE3 LIKE '%VENDOR%'
						BEGIN
							SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + ' AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''3rd''' +CHAR(10);	
						END

						IF @MASTER_CODETYPE3 LIKE '%SITE%'
						BEGIN
							SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + ' AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''3rd''' +CHAR(10);	
						END



						IF EXISTS (SELECT 1 FROM @WORK_AVALIABLE WHERE MASTER_CODETYPE = N'STORAGE_ID' )
						BEGIN
							IF @MASTER_CODETYPE3 LIKE '%STORAGE_ID%'
							BEGIN
								SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2' + '' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
								SET @mSubQuery = @mSubQuery + ' AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''3rd'' ' +CHAR(10);	

								SELECT @PLANT_COL1 = TABLE_COL
								FROM @WORK_AVALIABLE 
								WHERE MASTER_CODETYPE = N'PLANT_ID'; 

								SET @mSubQuery = @mSubQuery + 'AND A.'+ @PLANT_COL1 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);		
							END
							IF @MASTER_CODETYPE3 LIKE '%PLANT%'
							BEGIN
								SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + ' AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''3rd'' ' +CHAR(10);	
							END
						END

						ELSE
						BEGIN
							IF @MASTER_CODETYPE3 LIKE '%PLANT%'
							BEGIN
								SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + ' AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''3rd'' ' +CHAR(10);	
							END
						END

					END

					-----------------------------------------------
					-- STEP 2-3. UPDATE QUERY MAKE
					-- UPDATE TABLE_NAME SET
					--  COMPANY_ID = C.COMPANY_ID_B1
					-- , PLANT_ID = C.PLANT_ID_B2
					-- , TO_PLANT_ID = C.PLANT_ID_B3
					-----------------------------------------------
					BEGIN
						IF @mUpdateQuery = ''
						BEGIN
							SET @mUpdateQuery = @mUpdateQuery + @TABLE_COL3 + ' = ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ')'
						END
						ELSE
						BEGIN
							SET @mUpdateQuery = @mUpdateQuery + ', ' + @TABLE_COL3 + ' = ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ')'
						END

					END


					-----------------------------------------------
					-- STEP 2-4. UPDATE QUERY MAKE
					-- WHERE 1=1
					-- AND COMPANY_ID = C.COMPANY_ID
					-- AND PLANT_ID = C.PLANT_ID
					-- AND TO_PLANT_ID = C.TO_PLANT_ID
					-----------------------------------------------
					BEGIN
						SET @mUpdateWhereQuery = @mUpdateWhereQuery + ' AND ISNULL(A.' + @TABLE_COL3 + ', '''') = ISNULL(C.' + @TABLE_COL3 + ', '''')';
					END

					-----------------------------------------------
					-- STEP 2-4. DYNAMIC TABLE QUERY MAKE
					-- COMPANY_ID NVARCHAR(100), 
					-----------------------------------------------
					BEGIN
						IF @mTableQuery = ''
						BEGIN
							SET @mTableQuery = @mTableQuery + @TABLE_COL3 + ' NVARCHAR(100), ' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ' NVARCHAR(100) ' 
						END
						ELSE
						BEGIN
							SET @mTableQuery = @mTableQuery + ', '+ @TABLE_COL3 + ' NVARCHAR(100), ' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ' NVARCHAR(100) ' 
						END
					END


					SET @CNT = @CNT + 1;

					FETCH NEXT FROM LOOKUP_CURSOR2
					INTO @TABLE_COL3, @MASTER_CODETYPE3 ;
					
				END


				---------------------------------------------------------
				-- MEMORY TABLE CREATE

				--PRINT @mTableQuery;

				IF OBJECT_ID('ZNERP_LOOKUP_HIST') IS NOT NULL	
					DROP TABLE ZNERP_LOOKUP_HIST
			
				DECLARE @SQL NVARCHAR(MAX);
				SET @SQL = 'CREATE TABLE DBO.ZNERP_LOOKUP_HIST(';
				SELECT @SQL = @SQL + @mTableQuery;
				SELECT @SQL = @SQL + ')'

				PRINT @SQL;

				EXEC(@SQL);



				DECLARE @mEXECSelInto NVARCHAR(MAX);
				SET @mEXECSelInto = '';
				SET @mEXECSelInto = @mEXECSelInto + 'INSERT INTO ZNERP_LOOKUP_HIST' +CHAR(10);	
				SET @mEXECSelInto = @mEXECSelInto + 'SELECT ' + @mDisQuery  +CHAR(10);	
				SET @mEXECSelInto = @mEXECSelInto + 'FROM ' + 'SCM_ADM_LOOKUP_MASTER_DETAIL_SSP' + ' A'  +CHAR(10);	
				SET @mEXECSelInto = @mEXECSelInto + @mSubQuery;  
				SET @mEXECSelInto = @mEXECSelInto + ' WHERE  LOOKUP_TYPE = ''' + @LOOKUP_TYPE + '''';  
				


				PRINT @mEXECSelInto;
				EXEC SP_EXECUTESQL @mEXECSelInto ;


				PRINT @TABLE_NAME + '2. ' +CONVERT(CHAR(23), GETDATE(), 21);
				SET @UPDATE_START_TIME = CONVERT(CHAR(23), GETDATE(), 21);

				DECLARE @mEXEC_UPDATE NVARCHAR(MAX);
				SET @mEXEC_UPDATE = '';
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'UPDATE '+ 'SCM_ADM_LOOKUP_MASTER_DETAIL_SSP' + ' SET '  +CHAR(10);	
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + @mUpdateQuery  +CHAR(10);	
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'FROM ' + 'SCM_ADM_LOOKUP_MASTER_DETAIL_SSP' + ' A,  ZNERP_LOOKUP_HIST C'  +CHAR(10);	
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'WHERE 1=1'  +CHAR(10);	
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + @mUpdateWhereQuery;   
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + ' AND  LOOKUP_TYPE = ''' + @LOOKUP_TYPE + '''';

				DECLARE @UPDATE_CNT INT;
				PRINT @mEXEC_UPDATE;
				EXEC SP_EXECUTESQL @mEXEC_UPDATE ;

				SELECT @UPDATE_CNT = @@ROWCOUNT;

				SET @UPDATE_END_TIME = CONVERT(CHAR(23), GETDATE(), 21);

				PRINT @TABLE_NAME + '3. ' +CONVERT(CHAR(23), GETDATE(), 21);

				
				CLOSE LOOKUP_CURSOR2;
				DEALLOCATE LOOKUP_CURSOR2;
			END
			

			-----------------------------------------------
			--STEP 2-2. JOIN QUERY AUTO MAKE 
			-----------------------------------------------
			FETCH NEXT FROM LOOKUP_CURSOR
			INTO @LOOKUP_TYPE ;
			END


		END
		CLOSE LOOKUP_CURSOR;
		DEALLOCATE LOOKUP_CURSOR;

	------------------------------------------------------
	--STEP 3. CREATE TABLE INDEX
	------------------------------------------------------
	
	
		INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
		SELECT DISTINCT 
						[LOOKUP_TYPE]
						,[SEGMENT1]
						,[SEGMENT2]
						,[SEGMENT3]
						,[SEGMENT4]
						,[SEGMENT5]
						,[DISPLAY_SEQ]
						,[VALID_YN]
						,[DESCRIPTION]
						,'NERP_SSP' AS [CREATED_BY]
						,GETDATE() AS [CREATION_DATE]
						,'NERP_SSP' AS [LAST_UPDATED_BY]
						,GETDATE() AS [LAST_UPDATE_DATE]
						,[ATTRIBUTE1]
						,[ATTRIBUTE2]
						,[ATTRIBUTE3]
						,[ATTRIBUTE4]
						,[ATTRIBUTE5]
						,[ATTRIBUTE6]
						,[ATTRIBUTE7]
						,[ATTRIBUTE8]
						,[ATTRIBUTE9]
						,[ATTRIBUTE10]
						,[ATTRIBUTE11]
						,[ATTRIBUTE12]
						,[ATTRIBUTE13]
						,[ATTRIBUTE14]
						,[ATTRIBUTE15]
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL_SSP A
		WHERE NOT EXISTS (
				SELECT *
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
				WHERE A.LOOKUP_TYPE = B.LOOKUP_TYPE
				AND   A.SEGMENT1 = B.SEGMENT1
				AND   A.SEGMENT2 = B.SEGMENT2
				AND   A.SEGMENT3 = B.SEGMENT3
				AND   A.SEGMENT4 = B.SEGMENT4
				AND   A.SEGMENT5 = B.SEGMENT5
			)
		AND LOOKUP_TYPE NOT IN ('SSP_AS_DIV_SLOC')




		-- SSP_AS_DIV_SLOC 는 별도 처리할 것. STORAGE 중복에 의함
		-- TO-BE에서는 가용창고/반품창고 동일하게 운영하는지?

		INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
		SELECT DISTINCT 
						[LOOKUP_TYPE]
						,[SEGMENT1]
						,[SEGMENT2]
						,[SEGMENT3]
						,[SEGMENT4]
						,[SEGMENT5]
						,[DISPLAY_SEQ]
						,MAX([VALID_YN]) AS [VALID_YN]
						,MAX([DESCRIPTION]) AS [DESCRIPTION]
						,'NERP_SSP' AS [CREATED_BY]
						,GETDATE() AS [CREATION_DATE]
						,'NERP_SSP' AS [LAST_UPDATED_BY]
						,GETDATE() AS [LAST_UPDATE_DATE]
						,[ATTRIBUTE1]
						,[ATTRIBUTE2]
						,[ATTRIBUTE3]
						,[ATTRIBUTE4]
						,[ATTRIBUTE5]
						,[ATTRIBUTE6]
						,[ATTRIBUTE7]
						,[ATTRIBUTE8]
						,[ATTRIBUTE9]
						,[ATTRIBUTE10]
						,[ATTRIBUTE11]
						,[ATTRIBUTE12]
						,[ATTRIBUTE13]
						,[ATTRIBUTE14]
						,[ATTRIBUTE15]
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL_SSP A
		WHERE NOT EXISTS (
				SELECT *
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
				WHERE A.LOOKUP_TYPE = B.LOOKUP_TYPE
				AND   A.SEGMENT1 = B.SEGMENT1
				AND   A.SEGMENT2 = B.SEGMENT2
				AND   A.SEGMENT3 = B.SEGMENT3
				AND   A.SEGMENT4 = B.SEGMENT4
				AND   A.SEGMENT5 = B.SEGMENT5
			)
		AND LOOKUP_TYPE IN ('SSP_AS_DIV_SLOC')
		GROUP BY [LOOKUP_TYPE]
						,[SEGMENT1]
						,[SEGMENT2]
						,[SEGMENT3]
						,[SEGMENT4]
						,[SEGMENT5]
						,[DISPLAY_SEQ]
						,[ATTRIBUTE1]
						,[ATTRIBUTE2]
						,[ATTRIBUTE3]
						,[ATTRIBUTE4]
						,[ATTRIBUTE5]
						,[ATTRIBUTE6]
						,[ATTRIBUTE7]
						,[ATTRIBUTE8]
						,[ATTRIBUTE9]
						,[ATTRIBUTE10]
						,[ATTRIBUTE11]
						,[ATTRIBUTE12]
						,[ATTRIBUTE13]
						,[ATTRIBUTE14]
						,[ATTRIBUTE15]

	------------------------------------------------------
	--STEP 4. DROP TABLE
	------------------------------------------------------
END
