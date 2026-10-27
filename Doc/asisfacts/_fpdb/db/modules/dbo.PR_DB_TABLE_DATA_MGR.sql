
CREATE PROCEDURE [dbo].[PR_DB_TABLE_DATA_MGR]
--ALTER PROCEDURE [dbo].[PR_DB_TABLE_DATA_MGR]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_DB_TABLE_DATA_MGR
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2017.08.23
--                       2019.03.31
-- Author              : PIYONG
-- Version             : 1.0
--                       1.1 2019.03.31 kimcd 삭제되는 Table 정보 삭제 대상에서 제외로직 추가
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_DB_TABLE_DATA_MGR'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)



	DECLARE @SCHEMA_NAME		NVARCHAR(50)
	DECLARE @TABLE_NAME			NVARCHAR(100)
	DECLARE @CONSERVATION_DAY	NVARCHAR(100)
	DECLARE @QUERY			    NVARCHAR(2000)
	DECLARE @REPLACE_QUERY	    NVARCHAR(2000)
	DECLARE @count			    INT
	DECLARE @ParmStr			NVARCHAR(256)

		
	DECLARE CUR_FP_TR CURSOR FOR
		SELECT SCHEMA_NAME
			   ,TABLE_NAME
			   ,CONSERVATION_DAY
			   ,QUERY
		  FROM ZFP_DB_TABLE_DATA_MGR
		 WHERE RUN_YN = 'Y'
		   AND QUERY IS NOT NULL

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가
		-- ================================================
			INSERT INTO ZFP_DB_TABLE_DATA_MGR (
				SCHEMA_NAME
				 ,TABLE_NAME
				 ,RUN_YN
			) 
			 SELECT 'LGCE_FPDEV_TR'
					,NAME
					,'Y'
			  FROM LGCE_FPDEV_TR.SYS.TABLES S
			 WHERE NOT EXISTS ( SELECT 1
								  FROM ZFP_DB_TABLE_DATA_MGR M
								 WHERE M.TABLE_NAME = S.NAME
								   AND M.SCHEMA_NAME = 'LGCE_FPDEV_TR'
							  )
 
			INSERT INTO ZFP_DB_TABLE_DATA_MGR (
				SCHEMA_NAME
				,TABLE_NAME
				,RUN_YN
			) 
			 SELECT 'LGCE_INFDEV'
					,NAME
					,'Y'
			  FROM LGCE_INFDEV.SYS.TABLES S
			 WHERE NOT EXISTS ( SELECT 1
								  FROM ZFP_DB_TABLE_DATA_MGR M
								 WHERE M.TABLE_NAME = S.NAME
								   AND M.SCHEMA_NAME = 'LGCE_INFDEV'
							  )

			-- 2019-03-31 kimcd Table 삭제된 경우 대상 제외 시작
			UPDATE M SET RUN_YN = 'N'
			FROM   ZFP_DB_TABLE_DATA_MGR M
			WHERE  M.SCHEMA_NAME = 'LGCE_FPDEV_TR'
			AND    M.RUN_YN = 'Y'
			AND    NOT EXISTS ( SELECT NAME
							    FROM LGCE_FPDEV_TR.SYS.TABLES S
							    WHERE M.TABLE_NAME = S.NAME )


			UPDATE M SET RUN_YN = 'N'
			FROM   ZFP_DB_TABLE_DATA_MGR M
			WHERE  M.SCHEMA_NAME = 'LGCE_INFDEV'
			AND    M.RUN_YN = 'Y'
			AND    NOT EXISTS ( SELECT NAME
							    FROM LGCE_INFDEV.SYS.TABLES S
						        WHERE M.TABLE_NAME = S.NAME )
			-- 2019-03-31 kimcd Table 삭제된 경우 대상 제외 끝
		
			OPEN CUR_FP_TR;
			FETCH NEXT FROM CUR_FP_TR INTO @SCHEMA_NAME
										   ,@TABLE_NAME
										   ,@CONSERVATION_DAY   
										   ,@QUERY

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
		         
				SET @REPLACE_QUERY = REPLACE(@QUERY,'@PDAY',@CONSERVATION_DAY);

				SET @ParmStr =  N'@cnt int output'

				EXEC sp_executesql @REPLACE_QUERY,@ParmStr,@cnt=@count OUTPUT

				
				IF(@count > 0 )
					BEGIN
						UPDATE ZFP_DB_TABLE_DATA_MGR
						   SET DEL_CNT = @count
							   ,RUN_DATE = GETDATE()
						 WHERE TABLE_NAME = @TABLE_NAME
						   AND SCHEMA_NAME = @SCHEMA_NAME 
					END;

				SET @count = 0;

				FETCH NEXT FROM CUR_FP_TR INTO @SCHEMA_NAME
											   ,@TABLE_NAME
											   ,@CONSERVATION_DAY
											   ,@QUERY

			END;
			CLOSE CUR_FP_TR;
			DEALLOCATE CUR_FP_TR;


		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		
			
		
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



