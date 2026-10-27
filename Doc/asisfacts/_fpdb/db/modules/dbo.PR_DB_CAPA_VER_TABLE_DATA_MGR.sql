
CREATE PROCEDURE [dbo].[PR_DB_CAPA_VER_TABLE_DATA_MGR]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_DB_CAPA_VER_TABLE_DATA_MGR
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2022.09.29
--                       2024.02.26
-- Author              : kimcd
-- Version             : 1.0 2022.09.29 kimcd 최초 작성
--                       1.1 2022.10.27 kimcd 각 계획 유형별 보존 기간 수정
--                       2.0 2024.02.26 kimcd Division id 조건 제거
-- ================================================================================================
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_DB_CAPA_VER_TABLE_DATA_MGR'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @count		 INT
    DECLARE @VERSION_ID  VARCHAR(30)
	DECLARE @DIVISION_ID VARCHAR(30)
	DECLARE @INSERT_TIME DATETIME
	DECLARE @ROW_CNT     NUMERIC(10,1) = 1

    DECLARE CUR_VERSION_ID CURSOR FOR
		SELECT [VERSION_ID]
			  ,[DIVISION_ID]
			  ,[INSERT_TIME]
		FROM   [LGCE_FPDEV_TR].[dbo].[SCM_MASTER_VERSION_INFO_H] V
		WHERE  NOT EXISTS ( SELECT 1 
							FROM  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN_DETAIL] D WITH(NOLOCK),
								  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN]        P WITH(NOLOCK)
							WHERE 1=1
							AND   P.DIVISION_ID = D.DIVISION_ID
							AND   P.PLAN_ID     = D.PLAN_ID
							AND   D.DIVISION_ID = V.DIVISION_ID
							AND   D.ATTRIBUTE1  = V.VERSION_ID -- CAPA SIMULATION VERSION_ID 정보를 위한 컬럼 추가
							)
		AND   V.INSERT_TIME  < DATEADD(D,-30,GETDATE())
		UNION ALL
		SELECT V.VERSION_ID, V.DIVISION_ID, V.[INSERT_TIME]
		FROM   [LGCE_FPDEV_TR].[dbo].[SCM_MASTER_VERSION_INFO_H] V,
				(
				-- 1. FN 6개월 이전 Version ID 
				SELECT D.DIVISION_ID,
					   P.PLAN_NAME,
					   D.PLAN_SEQ,
					   D.PLAN_TYPE,
					   D.ATTRIBUTE1   AS VERSION_ID, -- CAPA SIMULATION VERSION_ID 정보를 위한 컬럼 추가
					   D.PLAN_STATUS
				FROM  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN_DETAIL] D WITH(NOLOCK),
					  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN]        P WITH(NOLOCK)
				WHERE 1=1
				AND   P.DIVISION_ID = D.DIVISION_ID
				AND   P.PLAN_CYCLE  = 'WEEKLY'
				AND   P.PLAN_ID     = D.PLAN_ID
				AND   D.PLAN_TYPE   = 'FN'
				AND   P.PLAN_NAME  <= CONVERT(NVARCHAR(8), DATEADD(WK, DATEDIFF(WK,0,DATEADD(D,-27*7,GETDATE())), 0),112) -- 6개월 보존
				UNION
				-- 2. MA 1개월 이전 Version ID 
				SELECT D.DIVISION_ID,
					   P.PLAN_NAME,
					   D.PLAN_SEQ,
					   D.PLAN_TYPE,
					   D.ATTRIBUTE1   AS VERSION_ID, -- CAPA SIMULATION VERSION_ID 정보를 위한 컬럼 추가
					   D.PLAN_STATUS
				FROM  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN_DETAIL] D WITH(NOLOCK),
					  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN]        P WITH(NOLOCK)
				WHERE 1=1
				AND   P.DIVISION_ID = D.DIVISION_ID
				AND   P.PLAN_CYCLE  = 'WEEKLY'
				AND   P.PLAN_ID     = D.PLAN_ID
				AND   D.PLAN_TYPE   = 'MA'
				AND   P.PLAN_NAME  <= CONVERT(NVARCHAR(8), DATEADD(WK, DATEDIFF(WK,0,DATEADD(D,-5*7,GETDATE())), 0),112) -- 1개월 보존
				UNION
				-- 3. FN/MA 외 1개월 이전 Version ID 
				SELECT D.DIVISION_ID,
					   P.PLAN_NAME,
					   D.PLAN_SEQ,
					   D.PLAN_TYPE,
					   D.ATTRIBUTE1   AS VERSION_ID, -- CAPA SIMULATION VERSION_ID 정보를 위한 컬럼 추가
					   D.PLAN_STATUS
				FROM  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN_DETAIL] D WITH(NOLOCK),
					  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN]        P WITH(NOLOCK)
				WHERE 1=1
				AND   P.DIVISION_ID = D.DIVISION_ID
				AND   P.PLAN_CYCLE  = 'WEEKLY'
				AND   P.PLAN_ID     = D.PLAN_ID
				AND   D.PLAN_TYPE NOT IN ('MA', 'FN')
				AND   P.PLAN_NAME  <= CONVERT(NVARCHAR(8), DATEADD(WK, DATEDIFF(WK,0,DATEADD(D,-4*7,GETDATE())), 0),112) -- 1개월 보존
				UNION
				-- 4. 오류 또는 삭제 Plan Version ID 
				SELECT D.DIVISION_ID,
					   P.PLAN_NAME,
					   D.PLAN_SEQ,
					   D.PLAN_TYPE,
					   D.ATTRIBUTE1   AS VERSION_ID, -- CAPA SIMULATION VERSION_ID 정보를 위한 컬럼 추가
					   D.PLAN_STATUS
				FROM  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN_DETAIL] D WITH(NOLOCK),
					  [LGCE_SCMDEV].[DBO].[SCM_MST_PLAN]        P WITH(NOLOCK)
				WHERE 1=1
				AND   P.DIVISION_ID = D.DIVISION_ID
				AND   P.PLAN_CYCLE  = 'WEEKLY'
				AND   P.PLAN_ID     = D.PLAN_ID
				AND   D.PLAN_STATUS <> '1'
				) A
		WHERE A.DIVISION_ID = V.DIVISION_ID
		AND   A.VERSION_ID  = V.VERSION_ID -- CAPA SIMULATION VERSION_ID 정보를 위한 컬럼 추가
		AND ISNULL(A.VERSION_ID, 'Y') NOT IN ('Y')
		ORDER BY 1,2;

	
    SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가
		-- ================================================

		OPEN CUR_VERSION_ID

        FETCH NEXT FROM CUR_VERSION_ID INTO @VERSION_ID
										   ,@DIVISION_ID
										   ,@INSERT_TIME;
        WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
        BEGIN
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_WORK_CAL_VER_H          WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_ITEM_LINE_ASSIGN_VER_H	WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_TACT_TIME_VER_H			WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_YIELD_VER_H				WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_LOSS_VER_H				WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_LOSS_REPORT_VER_H		WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_MASTER_MANAGER_VER_H	WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_TACT_TIME_EXCT_VER_H	WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_YIELD_EXCT_VER_H		WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;
		    SET @ROW_CNT = 1;
		    WHILE @ROW_CNT > 0
			    BEGIN
				    DELETE TOP (100000) FROM  LGCE_FPDEV_TR.DBO.SCM_LINE_ASSIGN_EXCT_VER_H	WHERE VERSION_ID = @VERSION_ID ; --AND DIVISION_ID = @DIVISION_ID; 2024.02.26 kimcd Division id 조건 제거
			        SET @ROW_CNT = @@ROWCOUNT;
				END;

			DELETE FROM  LGCE_FPDEV_TR.DBO.SCM_MASTER_VERSION_INFO_H	WHERE VERSION_ID = @VERSION_ID AND DIVISION_ID = @DIVISION_ID AND @INSERT_TIME < DATEADD(WK, DATEDIFF(WK,0,DATEADD(D,-37*7,GETDATE())), 0);
			
			FETCH NEXT FROM CUR_VERSION_ID INTO @VERSION_ID
											   ,@DIVISION_ID
											   ,@INSERT_TIME;
		END;  -- WHILE @@FETCH_STATUS = 0
        CLOSE CUR_VERSION_ID;
        DEALLOCATE CUR_VERSION_ID;   -- 메모리 해제

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
