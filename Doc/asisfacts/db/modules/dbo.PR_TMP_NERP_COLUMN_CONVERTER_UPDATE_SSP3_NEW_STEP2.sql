
-- =============================================
-- Author:		 victory25
-- Create date:  2024-02-15
-- Description:	 table info data converter
-- 2025.03.13 chkim.68 '1st' option 처리
-- =============================================
create  PROCEDURE [dbo].[PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_SSP3_NEW_STEP2]
AS
BEGIN
	DECLARE @TABLE_NAME   NVARCHAR(150) = N''; 
	DECLARE @TABLE_NAME_NEW   NVARCHAR(150) = N''; 
	DECLARE @STD_COLUMN   NVARCHAR(150) = N''; 	
	DECLARE @TERMS   NVARCHAR(150) = N''; 
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

	-- CURSOR 중복 대비
	DECLARE @cur int = 0
	SELECT @cur = count(*)
	FROM sys.dm_exec_cursors(0) -- 0은 현재 세션을 의미
	WHERE name = 'LOOKUP_CURSOR';
	if @cur > 0 begin
		DEALLOCATE LOOKUP_CURSOR
	end

	SELECT @cur = count(*)
	FROM sys.dm_exec_cursors(0) -- 0은 현재 세션을 의미
	WHERE name = 'LOOKUP_CURSOR2';
	if @cur > 0 begin
		DEALLOCATE LOOKUP_CURSOR2
	end
	-- end of CURSOR 중복대비

	-- 백업 주석 처리 241209
	--------------------------------------------------
	--STEP 0. TARGET TABLE BACKUP 
	--------------------------------------------------
	--BEGIN
	--	DECLARE LOOKUP_CURSOR_B CURSOR FOR
	--		SELECT DISTINCT B.TABLE_NAME, A.CONSTRAINT1, A.CONSTRAINT3
	--		FROM ZNERP_XLS_CHANGE_MASTER_CODE_SSP3 A WITH(NOLOCK)
	--		INNER JOIN ZNERP_TARGET_INFO_SSP3 B WITH(NOLOCK)
	--		ON A.PROGRAM_NAME = B.TABLE_NAME
	--		;

	--	OPEN LOOKUP_CURSOR_B;
	--	FETCH NEXT FROM LOOKUP_CURSOR_B
	--	INTO @TABLE_NAME, @STD_COLUMN ,@TERMS

	--	WHILE @@FETCH_STATUS = 0
	--	BEGIN
		
	--		PRINT @TABLE_NAME + 'BACKUP. ' +CONVERT(CHAR(23), GETDATE(), 21);
	--		SET @BACKUP_START_TIME = CONVERT(CHAR(23), GETDATE(), 21);

	--		SET @mEXEC = '';
	--		SET @mEXEC = @mEXEC + 'SELECT *   '+CHAR(10);	
	--		SET @mEXEC = @mEXEC + 'INTO DBO.BACKUP_' + @TABLE_NAME + '' +CHAR(10);	
	--		SET @mEXEC = @mEXEC + 'FROM ' + @TABLE_NAME + ' WITH(NOLOCK)' +CHAR(10);	

	--		SET @BACKUP_END_TIME = CONVERT(CHAR(23), GETDATE(), 21);
	--		PRINT @TABLE_NAME + 'END. ' +CONVERT(CHAR(23), GETDATE(), 21);
	--		PRINT @STD_COLUMN;
	--		PRINT @mEXEC;

	--		EXEC SP_EXECUTESQL @mEXEC;

	--		UPDATE  ZNERP_XLS_CHANGE_MASTER_CODE_SSP3  
	--		SET BACKUP_START_TIME = @BACKUP_START_TIME, 
	--			BACKUP_END_TIME = @BACKUP_END_TIME
	--		WHERE PROCESS_TYPE = @TABLE_NAME;

	--		FETCH NEXT FROM LOOKUP_CURSOR_B
	--		INTO @TABLE_NAME, @STD_COLUMN ,@TERMS
	--	END
	--	CLOSE LOOKUP_CURSOR_B;
	--	DEALLOCATE LOOKUP_CURSOR_B;
	--END
	
	-- 1st -- WA, HQ
	-- 2nd -- MI
	--DECLARE @IN_STEP nvarchar(10) = '''1st''' --
	DECLARE @IN_STEP nvarchar(100) = '5th' --
	-- 임시 테이블이 존재하는지 확인하고 삭제
	IF OBJECT_ID('tempdb..#STEPS') IS NOT NULL
	BEGIN
		DROP TABLE #STEPS;
	END;

	-- 새로운 임시 테이블 생성
	CREATE TABLE #STEPS (Step varchar(10));

	-- 값 삽입


	-- 테이블 내용 확인 (선택 사항)
	SELECT * FROM #STEPS;
	--return
	------------------------------------------------------
	--STEP 2. TARGET TABLE UPDATE 
	------------------------------------------------------
	BEGIN

		-- 자동변환 부분 실행 선택
		declare @auto_run int = 1

		declare @p nvarchar(max) = '';
		DECLARE @WORK_AVALIABLE TABLE (TABLE_COL NVARCHAR(150), MASTER_CODETYPE NVARCHAR(150));

		if @auto_run = 1 begin

			DECLARE LOOKUP_CURSOR CURSOR FOR
				SELECT DISTINCT B.TABLE_NAME, A.CONSTRAINT1, A.CONSTRAINT3
				FROM ZNERP_XLS_CHANGE_MASTER_CODE_SSP3 A WITH(NOLOCK)
				INNER JOIN ZNERP_TARGET_INFO_SSP3 B WITH(NOLOCK)
				ON A.PROGRAM_NAME = B.TABLE_NAME 
				WHERE A.CONSTRAINT4 = 'AUTO'
				--and b.TABLE_NAME = 'dm_pln_shipment_req'; 

			OPEN LOOKUP_CURSOR;
			FETCH NEXT FROM LOOKUP_CURSOR
			INTO @TABLE_NAME, @STD_COLUMN, @TERMS;
			
			print '----------sTART---------'
			PRINT @TABLE_NAME;
			PRINT @STD_COLUMN;
			PRINT @TERMS;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				DELETE FROM @WORK_AVALIABLE;

				SET @mEXEC = '';
				SET @mEXEC = @mEXEC + 'SELECT DISTINCT TABLE_COL, MASTER_CODETYPE FROM ZNERP_TARGET_INFO_SSP3 WHERE TABLE_NAME = ''' + @TABLE_NAME + '''' +CHAR(10);	

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
									SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
								END
								ELSE
								BEGIN
									SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
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
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''' + @IN_STEP+''''  + CHAR(10);
							END

							IF @MASTER_CODETYPE3 LIKE '%END_CUSTOMER%'
							BEGIN
								SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''' + @IN_STEP +'''' + CHAR(10);
							END

							IF @MASTER_CODETYPE3 LIKE '%VENDOR%'
							BEGIN
								SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''' + @IN_STEP+''''  + CHAR(10);
							END

							IF @MASTER_CODETYPE3 LIKE '%SITE%'
							BEGIN
								SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
								SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''' + @IN_STEP+''''  + CHAR(10);
							END

							IF EXISTS (SELECT 1 FROM @WORK_AVALIABLE WHERE MASTER_CODETYPE = N'STORAGE_ID' )
							BEGIN
								IF @MASTER_CODETYPE3 LIKE '%STORAGE_ID%'
								BEGIN
									SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
									SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2' + '' +CHAR(10);	
									SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
									SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''' + @IN_STEP+''''  + CHAR(10);
								

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
									SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''' + @IN_STEP+''''  + CHAR(10);
								END
							END

							ELSE
							BEGIN
								IF @MASTER_CODETYPE3 LIKE '%PLANT%'
								BEGIN
									SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER B' + CONVERT(VARCHAR, @CNT) +CHAR(10);	
									SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);	
									SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);	
									SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 <= ''' + @IN_STEP+''''  + CHAR(10);
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

					IF (@STD_COLUMN IS NOT NULL AND @STD_COLUMN != '')
					BEGIN
						SET @mUpdateWhereQuery = @mUpdateWhereQuery + ' AND A.' + @STD_COLUMN + ' > DATEADD(DAY, -' + @TERMS + ', ''20241228'') ' + CHAR(10);	
					END

					IF OBJECT_ID('ZNERP_TARGET_HIST_SSP') IS NOT NULL	
						DROP TABLE ZNERP_TARGET_HIST_SSP
			
					DECLARE @SQL NVARCHAR(MAX);
					SET @SQL = 'CREATE TABLE ZNERP_TARGET_HIST_SSP(';
					SELECT @SQL = @SQL + @mTableQuery;
					SELECT @SQL = @SQL + ');'

					PRINT @SQL;
					PRINT '--run TEMP Table Work'
					EXEC(@SQL);

					DECLARE @mEXECSelInto NVARCHAR(MAX);
					SET @mEXECSelInto = '';
					SET @mEXECSelInto = @mEXECSelInto + 'INSERT INTO ZNERP_TARGET_HIST_SSP' +CHAR(10);	
					SET @mEXECSelInto = @mEXECSelInto + 'SELECT ' + @mDisQuery  +CHAR(10);	
					SET @mEXECSelInto = @mEXECSelInto + 'FROM ' + @TABLE_NAME + ' A'  +CHAR(10);	
					SET @mEXECSelInto = @mEXECSelInto + @mSubQuery;   


					PRINT @mEXECSelInto;
					PRINT '--run TEMP Table Work2'
					EXEC SP_EXECUTESQL @mEXECSelInto ;

					PRINT @TABLE_NAME + '2. ' +CONVERT(CHAR(23), GETDATE(), 21);
					SET @UPDATE_START_TIME = CONVERT(CHAR(23), GETDATE(), 21);

					DECLARE @mEXEC_UPDATE NVARCHAR(MAX);
					SET @mEXEC_UPDATE = '';
					SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'UPDATE '+ @TABLE_NAME + ' SET '  +CHAR(10);	
					SET @mEXEC_UPDATE = @mEXEC_UPDATE + @mUpdateQuery  +CHAR(10);	
					SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'FROM ' + @TABLE_NAME + ' A,  ZNERP_TARGET_HIST_SSP C'  +CHAR(10);	
					SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'WHERE 1=1'  +CHAR(10);	
					SET @mEXEC_UPDATE = @mEXEC_UPDATE + @mUpdateWhereQuery;   

					DECLARE @UPDATE_CNT INT;
					PRINT @mEXEC_UPDATE;
					PRINT '--run Update'
					EXEC SP_EXECUTESQL @mEXEC_UPDATE ;

					SELECT @UPDATE_CNT = @@ROWCOUNT;

					SET @UPDATE_END_TIME = CONVERT(CHAR(23), GETDATE(), 21);

					PRINT @TABLE_NAME + '3. ' +CONVERT(CHAR(23), GETDATE(), 21);

					UPDATE  ZNERP_XLS_CHANGE_MASTER_CODE_SSP3  
					SET UPDATE_QUERY = @mEXEC_UPDATE, 
					UPDATE_CNT = @UPDATE_CNT,
					UPDATE_START_TIME = @UPDATE_START_TIME, 
					UPDATE_END_TIME = @UPDATE_END_TIME
					WHERE PROCESS_TYPE = @TABLE_NAME;
				
					CLOSE LOOKUP_CURSOR2;
					DEALLOCATE LOOKUP_CURSOR2;
				END
			

				-----------------------------------------------
				--STEP 2-2. JOIN QUERY AUTO MAKE 
				-----------------------------------------------
				FETCH NEXT FROM LOOKUP_CURSOR
				INTO @TABLE_NAME, @STD_COLUMN ,@TERMS;
			END


		
			CLOSE LOOKUP_CURSOR;
			DEALLOCATE LOOKUP_CURSOR;
		end
	END;


END


