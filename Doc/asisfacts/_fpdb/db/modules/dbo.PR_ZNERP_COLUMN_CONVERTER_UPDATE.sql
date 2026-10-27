

-- =============================================
-- Author:		 victory25
-- Create date:  2024-02-15
-- Description:	 table info data converter
-- =============================================
create PROCEDURE [dbo].[PR_ZNERP_COLUMN_CONVERTER_UPDATE]
with recompile
AS
BEGIN
	DECLARE @TABLE_NAME   NVARCHAR(150) = N''; 
	DECLARE @TABLE_NAME_NEW   NVARCHAR(150) = N''; 
	DECLARE @COL_INFO   NVARCHAR(150) = N''; 
	DECLARE @TABLE_COL   NVARCHAR(150) = N''; 
	DECLARE @TABLE_COL2   NVARCHAR(150) = N''; 
	DECLARE @TABLE_COL3   NVARCHAR(150) = N''; 
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

	------------------------------------------------------
	--STEP 2. TARGET TABLE UPDATE 
	------------------------------------------------------
	BEGIN
		declare @p nvarchar(max) = '';
		DECLARE @WORK_AVALIABLE TABLE (TABLE_COL NVARCHAR(150), MASTER_CODETYPE NVARCHAR(150));

		DECLARE LOOKUP_CURSOR CURSOR FOR
		SELECT DISTINCT TABLE_NAME FROM ZNERP_TARGET_INFO WITH(NOLOCK) WHERE METHOD = 'UPDATE'

		OPEN LOOKUP_CURSOR;
		FETCH NEXT FROM LOOKUP_CURSOR
		INTO @TABLE_NAME

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM @WORK_AVALIABLE;

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC + 'SELECT DISTINCT TABLE_COL, MASTER_CODETYPE FROM ZNERP_TARGET_INFO WHERE TABLE_NAME = ''' + @TABLE_NAME + '''' +CHAR(10);	

			--PRINT @mEXEC;         

			INSERT @WORK_AVALIABLE EXEC SP_EXECUTESQL @mEXEC ;

			-----------------------------------------------
			-- STEP 2-1. DISTINCT COLUMN STRING MAKE
			-- DISTINCT A.COMPANY_ID, B1.TO_COMPANY_ID AS COMPANY_ID_B1, A.PLANT_ID, B2.TO_PLANT_ID AS PLANT_ID_B2, A.TO_PLANT_ID, B3.TO_PLANT_ID AS PLANT_ID_B3
			-----------------------------------------------
			BEGIN
				DECLARE  @mDisQuery NVARCHAR(MAX) = '';
				DECLARE  @mSubQuery NVARCHAR(MAX) = '';
				DECLARE  @mWhereQuery NVARCHAR(MAX) = '';
				DECLARE  @mGroupByQuery NVARCHAR(MAX) = '';
				DECLARE  @mUpdateQuery NVARCHAR(MAX) = '';
				DECLARE  @mUpdateWhereQuery NVARCHAR(MAX) = '';
				DECLARE  @mTableQuery NVARCHAR(MAX) = '';

				DECLARE  @MEXEC_UPDATE_RESULT_WHERE NVARCHAR(MAX);
				DECLARE  @COLUN_A NVARCHAR(MAX);
				
				SET @MEXEC_UPDATE_RESULT_WHERE = '';
				SET @COLUN_A = '';

				SET @mDisQuery = '';
				SET @mGroupByQuery = '';
				SET @mSubQuery = '';
				SET @mWhereQuery = '';
				SET @mUpdateQuery = '';
				SET @mUpdateWhereQuery = '';
				SET @mTableQuery = '';
				--SET @mDisQuery = @mDisQuery + 'DISTINCT ';
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
							SET @mDisQuery = @mDisQuery + '''' + @TABLE_NAME + ''' AS TABLE_NAME, COUNT(*) AS CNT,' + ' A.' + @TABLE_COL3 + ', ISNULL(B'  + CONVERT(VARCHAR, @CNT) + '.TO_' + @MASTER_CODETYPE3 +', '+ 'A.' + @TABLE_COL3 + ' ) AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
						END
						ELSE
						BEGIN --두번째인경우
							SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', ISNULL(B'  + CONVERT(VARCHAR, @CNT) + '.TO_' + @MASTER_CODETYPE3 +', '+ 'A.' + @TABLE_COL3 + ' ) AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
						END

						IF @mGroupByQuery = ''
						BEGIN  --처음인경우
							SET @mGroupByQuery = @mGroupByQuery + 'GROUP BY A.' + @TABLE_COL3 + ', ISNULL(B'  + CONVERT(VARCHAR, @CNT) + '.TO_' + @MASTER_CODETYPE3 +', '+ 'A.' + @TABLE_COL3 + ' ) '
						END
						ELSE
						BEGIN --두번째인경우
							SET @mGroupByQuery = @mGroupByQuery + ', A.' + @TABLE_COL3 + ', ISNULL(B'  + CONVERT(VARCHAR, @CNT) + '.TO_' + @MASTER_CODETYPE3 +', '+ 'A.' + @TABLE_COL3 + ' ) '
						END
					END

					-----------------------------------------------
					-- STEP 2-2. DISTINCT COLUMN STRING MAKE
					-- LEFT JOIN ZNERP_CONV_MASTER B1
					-- ON A.COMPANY_ID = B1.FROM_COMPANY_ID
					-- AND B1.CODETYPE = 'COMPANY_ID'
					-----------------------------------------------
					BEGIN
						--IF @mSubQuery = ''
						--BEGIN
						IF @MASTER_CODETYPE3 LIKE '%COMPANY%'
						BEGIN
							SET @mSubQuery = @mSubQuery + 'LEFT JOIN ZNERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.FROM_' + @MASTER_CODETYPE3 +'' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	
						END

						IF @MASTER_CODETYPE3 LIKE '%PLANT%'
						BEGIN
						SET @PRIFIX = N'';

						SELECT @PRIFIX = LEFT(@TABLE_COL3, CHARINDEX('_', @TABLE_COL3)-1);

						IF @PRIFIX = 'PLANT'
						BEGIN
							SET @mSubQuery = @mSubQuery + 'LEFT JOIN ZNERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.FROM_' + @MASTER_CODETYPE3 +'' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	

							--IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'SITE_ID' AND Object_ID = Object_ID(@TABLE_NAME))
							--BEGIN
							--	SET @mSubQuery = @mSubQuery + 'AND A.SITE_ID = B' + CONVERT(VARCHAR, @CNT) + '.FROM_SITE_ID' +CHAR(10);	
							--END
						END

						IF @PRIFIX <> 'PLANT'
						BEGIN
							SET @mSubQuery = @mSubQuery + 'LEFT JOIN ZNERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.FROM_' + @MASTER_CODETYPE3 +'' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	

							--IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = @PRIFIX+'_SITE_ID' AND Object_ID = Object_ID(@TABLE_NAME))
							--BEGIN
							--	SET @mSubQuery = @mSubQuery + 'AND A.' + @PRIFIX + '_SITE_ID = B' + CONVERT(VARCHAR, @CNT) + '.FROM_SITE_ID' +CHAR(10);	
							--END
						END
						END
					

						IF @MASTER_CODETYPE3 LIKE '%STORAGE%'
						BEGIN
							SET @PRIFIX = N'';

							SELECT @PRIFIX = LEFT(@TABLE_COL3, CHARINDEX('_', @TABLE_COL3)-1);

							IF @PRIFIX = 'STORAGE'
							BEGIN
								SET @mSubQuery = @mSubQuery + 'LEFT JOIN ZNERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.FROM_' + @MASTER_CODETYPE3 +'' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	

								--IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'SITE_ID' AND Object_ID = Object_ID(@TABLE_NAME))
								--BEGIN
								--	SET @mSubQuery = @mSubQuery + 'AND A.SITE_ID = B' + CONVERT(VARCHAR, @CNT) + '.FROM_SITE_ID' +CHAR(10);	
								--END 

								IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'PLANT_ID' AND Object_ID = Object_ID(@TABLE_NAME))
								BEGIN
									SET @mSubQuery = @mSubQuery + 'AND A.PLANT_ID = B' + CONVERT(VARCHAR, @CNT) + '.FROM_PLANT_ID' +CHAR(10);	
								END
							END

							IF @PRIFIX <> 'STORAGE'
							BEGIN
								SET @mSubQuery = @mSubQuery + 'LEFT JOIN ZNERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.FROM_' + @MASTER_CODETYPE3 +'' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	

								--IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = @PRIFIX+'_SITE_ID' AND Object_ID = Object_ID(@TABLE_NAME))
								--BEGIN
								--	SET @mSubQuery = @mSubQuery + 'AND A.' + @PRIFIX + '_SITE_ID = B' + CONVERT(VARCHAR, @CNT) + '.FROM_SITE_ID' +CHAR(10);	
								--END 

								IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = @PRIFIX+'_PLANT_ID' AND Object_ID = Object_ID(@TABLE_NAME))
								BEGIN
									SET @mSubQuery = @mSubQuery + 'AND A.' + @PRIFIX + '_PLANT_ID = B' + CONVERT(VARCHAR, @CNT) +  '.FROM_PLANT_ID' +CHAR(10);	
								END
								ELSE IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'PLANT_ID' AND Object_ID = Object_ID(@TABLE_NAME))
								BEGIN
									SET @mSubQuery = @mSubQuery + 'AND A.PLANT_ID = B' + CONVERT(VARCHAR, @CNT) + '.FROM_PLANT_ID' +CHAR(10);	
								END

							END
							
						END

						IF @MASTER_CODETYPE3 LIKE '%SUPPLIER%'
						BEGIN
							SET @mSubQuery = @mSubQuery + 'LEFT JOIN ZNERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.FROM_' + @MASTER_CODETYPE3 +'' +CHAR(10);	
							SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	
						END

						--END
						
						
					END

					BEGIN
						IF @mWhereQuery = ''
						BEGIN
							SET @mWhereQuery = @mWhereQuery + ' WHERE B'  + CONVERT(VARCHAR, @CNT) + '.TO_' + @MASTER_CODETYPE3 + ' IS NOT NULL'+CHAR(10);
						END
						ELSE
						BEGIN
							SET @mWhereQuery = @mWhereQuery + ' OR B'  + CONVERT(VARCHAR, @CNT) + '.TO_' + @MASTER_CODETYPE3 + ' IS NOT NULL'+CHAR(10);
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

					BEGIN
						IF @MEXEC_UPDATE_RESULT_WHERE = ''
							SET @MEXEC_UPDATE_RESULT_WHERE = @MEXEC_UPDATE_RESULT_WHERE + 'WHERE 1=1 AND ISNULL(A.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', ''-'') = ISNULL(B.' + @TABLE_COL3 + ', ''-'')'  +CHAR(10);	
						ELSE
							SET @MEXEC_UPDATE_RESULT_WHERE = @MEXEC_UPDATE_RESULT_WHERE + ' AND ISNULL(A.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', ''-'') = ISNULL(B.' + @TABLE_COL3 + ', ''-'')'  +CHAR(10);	

						IF @COLUN_A = ''
							SET @COLUN_A = @COLUN_A + @TABLE_COL3
						ELSE
							SET @COLUN_A = @COLUN_A + ',' + @TABLE_COL3
					END

					-----------------------------------------------
					-- STEP 2-4. DYNAMIC TABLE QUERY MAKE
					-- COMPANY_ID NVARCHAR(100), 
					-----------------------------------------------
					BEGIN
					IF @mTableQuery = ''
						BEGIN
							SET @mTableQuery = 'TABLE_NAME NVARCHAR(50), CNT NVARCHAR(10), ' + @TABLE_COL3 + ' NVARCHAR(100), ' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ' NVARCHAR(100) ' 
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
				CLOSE LOOKUP_CURSOR2;
				DEALLOCATE LOOKUP_CURSOR2;
				---------------------------------------------------------
				-- MEMORY TABLE CREATE

				--PRINT @mTableQuery;

				IF OBJECT_ID('ZNERP_TARGET_HIST') IS NOT NULL	
					DROP TABLE ZNERP_TARGET_HIST
			
				DECLARE @SQL NVARCHAR(MAX);
				SET @SQL = 'CREATE TABLE DBO.ZNERP_TARGET_HIST(';
				SELECT @SQL = @SQL + @mTableQuery;
				SELECT @SQL = @SQL + ')'

				--PRINT @SQL;

				EXEC(@SQL);

				

				DECLARE @mEXECSelInto NVARCHAR(MAX);
				SET @mEXECSelInto = '';
				SET @mEXECSelInto = @mEXECSelInto + 'INSERT INTO ZNERP_TARGET_HIST' +CHAR(10);	
				SET @mEXECSelInto = @mEXECSelInto + 'SELECT ' + @mDisQuery  +CHAR(10);	
				SET @mEXECSelInto = @mEXECSelInto + 'FROM ' + @TABLE_NAME + ' A'  +CHAR(10);	
				SET @mEXECSelInto = @mEXECSelInto + @mSubQuery +CHAR(10);  
				SET @mEXECSelInto = @mEXECSelInto + @mWhereQuery +CHAR(10); 
				SET @mEXECSelInto = @mEXECSelInto + @mGroupByQuery;

				--SET @PARAM = '@CNT10 INT OUTPUT';

				--INSERT @DAY_SCP_XLS_PSI_GLOBAL EXEC SP_EXECUTESQL @mEXECSelInto, @PARAM, @CNT10 = @COL_CNT1 OUTPUT ;
				EXEC SP_EXECUTESQL @mEXECSelInto ;
				PRINT @mEXECSelInto;

				SELECT  * FROM DBO.ZNERP_TARGET_HIST;
				
				--EXEC xp_cmdshell 'bcp "SELECT * FROM [LGCE_FPDEV_TR].dbo.[ZNERP_TARGET_HIST]" queryout "D:\@TABLE_NAME.txt" -S -T -c'

				--bcp "SELECT @TABLE_NAME AS TABLE_NAME, * FROM DBO.ZNERP_TARGET_HIST" queryout "C:\Path\To\@TABLE_NAME.csv" -c -t, -T -S YourServerName
				----PRINT 'UPDATE '+ @TABLE_NAME + ' SET ';
				----PRINT @mUpdateQuery;
				----PRINT 'FROM ' + @TABLE_NAME + ' A,  #DAY_SCP_XLS_PSI_GLOBAL C'
				----PRINT 'WHERE 1=1';
				----PRINT @mUpdateWhereQuery;
				--PRINT @TABLE_NAME + '2. ' +CONVERT(CHAR(23), GETDATE(), 21);
				SET @UPDATE_START_TIME = CONVERT(CHAR(23), GETDATE(), 21);

				DECLARE @mEXEC_UPDATE NVARCHAR(MAX);
				SET @mEXEC_UPDATE = '';
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'UPDATE '+ @TABLE_NAME + ' SET '  +CHAR(10);	
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + @mUpdateQuery  +CHAR(10);	
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'FROM ' + @TABLE_NAME + ' A,  ZNERP_TARGET_HIST C'  +CHAR(10);	
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'WHERE 1=1'  +CHAR(10);	
				SET @mEXEC_UPDATE = @mEXEC_UPDATE + @mUpdateWhereQuery;   

				DECLARE @UPDATE_CNT INT;
				PRINT @mEXEC_UPDATE;
				EXEC SP_EXECUTESQL @mEXEC_UPDATE ;

				SELECT @UPDATE_CNT = @@ROWCOUNT;

				SET @UPDATE_END_TIME = CONVERT(CHAR(23), GETDATE(), 21);

				PRINT @TABLE_NAME + '3. ' +CONVERT(CHAR(23), GETDATE(), 21);

				UPDATE  ZNERP_XLS_CHANGE_MASTER_CODE  
				SET UPDATE_QUERY = @mEXEC_UPDATE, 
				UPDATE_CNT = @UPDATE_CNT,
				UPDATE_START_TIME = @UPDATE_START_TIME, 
				UPDATE_END_TIME = @UPDATE_END_TIME
				WHERE PROCESS_TYPE = @TABLE_NAME;
				
			END


			BEGIN
				DECLARE @COLUMN_NAME NVARCHAR(100);
				DECLARE @SELECT_COL_NAME NVARCHAR(500);

				SET @SELECT_COL_NAME = '';

				DECLARE LOOKUP_CURSOR_X CURSOR FOR
				SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ZNERP_TARGET_HIST'

				OPEN LOOKUP_CURSOR_X;
				FETCH NEXT FROM LOOKUP_CURSOR_X
				INTO @COLUMN_NAME

				WHILE @@FETCH_STATUS = 0
				BEGIN
					IF @SELECT_COL_NAME = ''
						SET @SELECT_COL_NAME = @COLUMN_NAME;
					ELSE
						SET @SELECT_COL_NAME = @SELECT_COL_NAME+ ', ' +@COLUMN_NAME;
				
					PRINT @SELECT_COL_NAME;

					IF NOT EXISTS 
					(
						SELECT 1
						FROM DBO.SYSCOLUMNS COL INNER JOIN DBO.SYSOBJECTS TBL
						ON COL.ID = TBL.ID
						AND COL.NAME = @COLUMN_NAME
						AND TBL.NAME = 'ZNERP_XLS_CHANGE_MASTER_CHECK'
					)
					BEGIN
						print 1;
						DECLARE @MEXEC_ALTER NVARCHAR(MAX);
						SET @MEXEC_ALTER = '';
						SET @MEXEC_ALTER = @MEXEC_ALTER + 'ALTER TABLE ZNERP_XLS_CHANGE_MASTER_CHECK ADD ' + @COLUMN_NAME + ' NVARCHAR(100)' +CHAR(10);	
						

						PRINT @MEXEC_ALTER;
						EXEC SP_EXECUTESQL @MEXEC_ALTER ;
			
					END
				FETCH NEXT FROM LOOKUP_CURSOR_X
				INTO @COLUMN_NAME ;
				END

				CLOSE LOOKUP_CURSOR_X;
				DEALLOCATE LOOKUP_CURSOR_X;

				DECLARE @MEXEC_INSERT NVARCHAR(MAX);
				SET @MEXEC_INSERT = '';
				SET @MEXEC_INSERT = @MEXEC_INSERT + 'INSERT INTO ZNERP_XLS_CHANGE_MASTER_CHECK (' + @SELECT_COL_NAME + ')  SELECT '+ @SELECT_COL_NAME + ' FROM ZNERP_TARGET_HIST' +CHAR(10);	
				
				PRINT @MEXEC_INSERT;
				EXEC SP_EXECUTESQL @MEXEC_INSERT ;

				END


			BEGIN
			 PRINT 'AFTER CONVERT'
			 DECLARE @MEXEC_UPDATE_RESULT_GROUPBY NVARCHAR(MAX);
			 DECLARE @MEXEC_UPDATE_RESULT NVARCHAR(MAX);

				SET @MEXEC_UPDATE_RESULT = '';
				SET @MEXEC_UPDATE_RESULT = @MEXEC_UPDATE_RESULT + 'UPDATE ZNERP_XLS_CHANGE_MASTER_CHECK SET NEW_CNT = B.NEW_CNT FROM ZNERP_XLS_CHANGE_MASTER_CHECK A, ('+CHAR(10);
				SET @MEXEC_UPDATE_RESULT = @MEXEC_UPDATE_RESULT + 'SELECT '+ @COLUN_A + ', COUNT(*) AS NEW_CNT FROM ' + @TABLE_NAME +' GROUP BY '+ @COLUN_A + ' ) B '+CHAR(10);
				SET @MEXEC_UPDATE_RESULT = @MEXEC_UPDATE_RESULT + @MEXEC_UPDATE_RESULT_WHERE + CHAR(10);
				SET @MEXEC_UPDATE_RESULT = @MEXEC_UPDATE_RESULT + ' AND A.TABLE_NAME = ''' + @TABLE_NAME +'''' + CHAR(10);

				PRINT @MEXEC_UPDATE_RESULT;

				EXEC SP_EXECUTESQL @MEXEC_UPDATE_RESULT ;

			END
			-----------------------------------------------
			--STEP 2-2. JOIN QUERY AUTO MAKE 
			-----------------------------------------------
			FETCH NEXT FROM LOOKUP_CURSOR
			INTO @TABLE_NAME ;
			END


		END
		CLOSE LOOKUP_CURSOR;
		DEALLOCATE LOOKUP_CURSOR;
		
	------------------------------------------------------
	--STEP 3. MANUAL UPDATE
	------------------------------------------------------
	--UPDATE [TH_UIS_USER_MST]
	--SET CORPORATION = B.TO_COMPANY_ID
	--FROM [ZNERP_CONV_MASTER] B
	--WHERE [TH_UIS_USER_MST].CORPORATION = B.FROM_COMPANY_ID
	--AND B.CODETYPE = 'COMPANY_ID'

	--UPDATE [TH_UIS_USER_PLAN_GROUP_RELATE]
	--SET COMPANY_ID = B.TO_COMPANY_ID
	--FROM [ZNERP_CONV_MASTER] B
	--WHERE [TH_UIS_USER_PLAN_GROUP_RELATE].COMPANY_ID = B.FROM_COMPANY_ID
	--AND B.CODETYPE = 'COMPANY_ID'

	--DELETE FROM [DBO].[TH_MST_CODE]
	--WHERE CODE_GROUP_ID = 'DEFAULT_PLANT'
	--AND CODE_ID = 'G482'

	--UPDATE TH_MST_CODE
	--SET CODE_ID = 'WA00'
	--, CODE_NAME = 'WA00'
	--WHERE CODE_GROUP_ID = 'DEFAULT_PLANT'

	--UPDATE [DBO].[TH_MST_CODE]
	--SET CODE_ATTB1 = 'WA00'
	--WHERE 1=1
	--AND CODE_GROUP_ID = 'DEFAULT_SITE'
	------------------------------------------------------
	--STEP 4. DROP TABLE
	------------------------------------------------------
END
