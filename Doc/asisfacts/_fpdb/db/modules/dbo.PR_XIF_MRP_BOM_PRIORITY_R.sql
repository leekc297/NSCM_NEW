
CREATE PROCEDURE [dbo].[PR_XIF_MRP_BOM_PRIORITY_R]

-- ================================================================================================
-- Program ID          : FP00223
-- Program Name        : PR_XIF_MRP_BOM_PRIORITY_R
-- Param               :
-- Batch Period        : 30분 단위
-- Description         :
--
-- Source System       : MRP
-- Destination System  : FP SDB
-- Source Table        : XIF_MRP_BOM_PRIORITY_R
-- Destination Table   : FP_MRP_BOM_PRIORITY_M
--
-- Create(Update) Date : 2021.05.07

-- Author              : 김 춘 동
-- Version             : 1.0 2021-05-07 초기 형성
-- ================================================================================================
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MRP_BOM_PRIORITY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IFSEQNO         NVARCHAR(50)
	DECLARE @COMPANY_ID      NVARCHAR(30)
	DECLARE @DIVISION_ID     NVARCHAR(30)
	DECLARE @SITE_ID         NVARCHAR(30)
	DECLARE @PLANT_ID        NVARCHAR(30)
	DECLARE @PARENT_ITEM_ID  NVARCHAR(50)
	DECLARE @CHILD_ITEM_ID   NVARCHAR(50)
	DECLARE @REPLACE_ITEM_ID NVARCHAR(50)
	DECLARE @PARENT_QTY1     NUMERIC(20,10)
	DECLARE @CHILD_QTY1      NUMERIC(20,10)
	DECLARE @PARENT_QTY2     NUMERIC(20,10)
	DECLARE @CHILD_QTY2      NUMERIC(20,10)
	DECLARE @EFF_START_DATE  DATETIME
	DECLARE @EFF_END_DATE    DATETIME
	DECLARE @ACTIVE_FLAG     NVARCHAR(1)

	DECLARE CUR_BOM_PRIORITY CURSOR FOR
		SELECT MBP.IF_SEQ
			  ,P.COMPANY_ID
			  ,P.DIVISION_ID
			  ,P.SITE_ID
			  ,MBP.PLANT_ID
			  ,MBP.PARENT_ITEM_ID
			  ,MBP.CHILD_ITEM_ID
			  ,MBP.REPLACE_ITEM_ID
			  ,(SELECT TOP 1 B.PARENT_QTY
			    FROM   SCM_BOM_M B (NOLOCK)
				WHERE  B.COMPANY_ID     = P.COMPANY_ID
				AND    B.DIVISION_ID    = P.DIVISION_ID
				AND    B.SITE_ID        = P.SITE_ID
				AND    B.PLANT_ID       = MBP.PLANT_ID
				AND    B.PARENT_ITEM_ID = MBP.PARENT_ITEM_ID
				AND    B.CHILD_ITEM_ID  = MBP.CHILD_ITEM_ID
				AND    B.EFF_END_DATE  >= CONVERT(DATETIME, MBP.START_DATE, 112)
				ORDER  BY B.KEY_DATE)  AS PARENT_QUANTITY1
			  ,(SELECT TOP 1 B.CHILD_QTY
			    FROM   SCM_BOM_M B (NOLOCK)
				WHERE  B.COMPANY_ID     = P.COMPANY_ID
				AND    B.DIVISION_ID    = P.DIVISION_ID
				AND    B.SITE_ID        = P.SITE_ID
				AND    B.PLANT_ID       = MBP.PLANT_ID
				AND    B.PARENT_ITEM_ID = MBP.PARENT_ITEM_ID
				AND    B.CHILD_ITEM_ID  = MBP.CHILD_ITEM_ID
				AND    B.EFF_END_DATE  >= CONVERT(DATETIME, MBP.START_DATE, 112)
				ORDER  BY B.KEY_DATE)  AS CHILD_QUANTITY1
			  ,(SELECT TOP 1 B.PARENT_QTY
			    FROM   SCM_BOM_M B (NOLOCK)
				WHERE  B.COMPANY_ID     = P.COMPANY_ID
				AND    B.DIVISION_ID    = P.DIVISION_ID
				AND    B.SITE_ID        = P.SITE_ID
				AND    B.PLANT_ID       = MBP.PLANT_ID
				AND    B.PARENT_ITEM_ID = MBP.PARENT_ITEM_ID
				AND    B.CHILD_ITEM_ID  = MBP.REPLACE_ITEM_ID
				AND    B.EFF_END_DATE  >= CONVERT(DATETIME, MBP.START_DATE, 112)
				ORDER  BY B.KEY_DATE)  AS PARENT_QUANTITY2
			  ,(SELECT TOP 1 B.CHILD_QTY
			    FROM   SCM_BOM_M B (NOLOCK)
				WHERE  B.COMPANY_ID     = P.COMPANY_ID
				AND    B.DIVISION_ID    = P.DIVISION_ID
				AND    B.SITE_ID        = P.SITE_ID
				AND    B.PLANT_ID       = MBP.PLANT_ID
				AND    B.PARENT_ITEM_ID = MBP.PARENT_ITEM_ID
				AND    B.CHILD_ITEM_ID  = MBP.REPLACE_ITEM_ID
				AND    B.EFF_END_DATE  >= CONVERT(DATETIME, MBP.START_DATE, 112)
				ORDER  BY B.KEY_DATE)  AS CHILD_QUANTITY2
			  ,CONVERT(DATETIME, MBP.START_DATE, 112) AS START_DATE
			  ,CONVERT(DATETIME, ISNULL(MBP.END_DATE,'99991230'), 112)   AS END_DATE
			  ,MBP.USE_YN
		FROM   SCM_PLANT_M     P  (NOLOCK)
			  ,SY_XIF_MRP_BOM_PRIORITY_R  MBP (NOLOCK)
		WHERE  P.PLANT_ID        = MBP.PLANT_ID
		AND	   MBP.PROC_FLAG = 'P';

	SET @ROWCOUNT = @@ROWCOUNT

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가 start
		-- ================================================
		 UPDATE [dbo].[SY_XIF_MRP_BOM_PRIORITY_R]
			SET PROC_FLAG = 'P'
			   ,PROC_DATE = GETDATE()
		  WHERE PROC_FLAG = 'N'

		  OPEN CUR_BOM_PRIORITY;
		  FETCH NEXT FROM CUR_BOM_PRIORITY INTO  @IFSEQNO
												,@COMPANY_ID
												,@DIVISION_ID
												,@SITE_ID
												,@PLANT_ID
												,@PARENT_ITEM_ID
												,@CHILD_ITEM_ID
												,@REPLACE_ITEM_ID
												,@PARENT_QTY1
												,@CHILD_QTY1
												,@PARENT_QTY2
												,@CHILD_QTY2
												,@EFF_START_DATE
												,@EFF_END_DATE
												,@ACTIVE_FLAG;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
				IF @CHILD_QTY1 IS NOT NULL OR @CHILD_QTY2 IS NOT NULL
				BEGIN
					MERGE INTO [dbo].[FP_MRP_BOM_PRIORITY_M] MBP
					USING ( SELECT   @COMPANY_ID       AS COMPANY_ID
									,@DIVISION_ID      AS DIVISION_ID
									,@SITE_ID          AS SITE_ID
									,@PLANT_ID         AS PLANT_ID
									,@PARENT_ITEM_ID   AS PARENT_ITEM_ID
									,@CHILD_ITEM_ID    AS CHILD_ITEM_ID
									,@REPLACE_ITEM_ID  AS REPLACE_ITEM_ID
									,ISNULL(@PARENT_QTY2,@PARENT_QTY1)      AS PARENT_QTY
									,ISNULL(@CHILD_QTY2,@CHILD_QTY1)        AS CHILD_QTY
									,@EFF_START_DATE   AS EFF_START_DATE
									,@EFF_END_DATE     AS EFF_END_DATE
									,@ACTIVE_FLAG      AS ACTIVE_FLAG
              				) XXX
					ON ( 	MBP.[PARENT_ITEM_ID] = XXX.[PARENT_ITEM_ID]
						AND	MBP.[COMPANY_ID]     = XXX.[COMPANY_ID]
						AND	MBP.[DIVISION_ID]    = XXX.[DIVISION_ID]
						AND	MBP.[SITE_ID]        = XXX.[SITE_ID]
						AND	MBP.[PLANT_ID]       = XXX.[PLANT_ID]
						AND	MBP.[CHILD_ITEM_ID]  = XXX.[CHILD_ITEM_ID]
						AND	MBP.[EFF_START_DATE] = XXX.[EFF_START_DATE]
					)
					WHEN MATCHED THEN
						UPDATE SET REPLACE_ITEM_ID = XXX.REPLACE_ITEM_ID
									,PARENT_QTY      = XXX.PARENT_QTY
              						,CHILD_QTY       = XXX.CHILD_QTY
              			  			,EFF_END_DATE    = XXX.EFF_END_DATE
              						,ACTIVE_FLAG     = XXX.ACTIVE_FLAG
              						,UPDATE_ID       = @v_proc_name
              						,UPDATE_TIME     = GETDATE()     
					WHEN NOT MATCHED THEN
              			INSERT ( COMPANY_ID           
              					,DIVISION_ID          
              					,SITE_ID         
              					,PLANT_ID
              					,PARENT_ITEM_ID       
              					,CHILD_ITEM_ID        
								,REPLACE_ITEM_ID
								,PARENT_QTY
								,CHILD_QTY
              					,EFF_START_DATE       
              					,EFF_END_DATE         
              					,ACTIVE_FLAG 
								,INSERT_ID            
              					,INSERT_TIME          
              					,UPDATE_ID            
              					,UPDATE_TIME          
              					)
              			VALUES ( XXX.COMPANY_ID
								,XXX.DIVISION_ID
								,XXX.SITE_ID
								,XXX.PLANT_ID
								,XXX.PARENT_ITEM_ID
								,XXX.CHILD_ITEM_ID
								,XXX.REPLACE_ITEM_ID
								,XXX.PARENT_QTY
								,XXX.CHILD_QTY
								,XXX.EFF_START_DATE
								,XXX.EFF_END_DATE
								,XXX.ACTIVE_FLAG
              					,@v_proc_name         
              					,GETDATE()            
              					,@v_proc_name       
              					,GETDATE()       
              					);
				END;
				ELSE
				BEGIN
					UPDATE [dbo].[SY_XIF_MRP_BOM_PRIORITY_R]
					SET    PROC_FLAG = 'N'
						  ,PROC_DATE = GETDATE()
					WHERE  PROC_FLAG = 'P'
					AND    IF_SEQ    = @IFSEQNO
				END;
			

				FETCH NEXT FROM CUR_BOM_PRIORITY INTO    @IFSEQNO
														,@COMPANY_ID
														,@DIVISION_ID
														,@SITE_ID
														,@PLANT_ID
														,@PARENT_ITEM_ID
														,@CHILD_ITEM_ID
														,@REPLACE_ITEM_ID
														,@PARENT_QTY1
														,@CHILD_QTY1
														,@PARENT_QTY2
														,@CHILD_QTY2
														,@EFF_START_DATE
														,@EFF_END_DATE
														,@ACTIVE_FLAG;

		  END;
		  CLOSE CUR_BOM_PRIORITY;
		  DEALLOCATE CUR_BOM_PRIORITY;

		 UPDATE [dbo].[SY_XIF_MRP_BOM_PRIORITY_R]
			SET PROC_FLAG = 'Y'
			   ,PROC_DATE = GETDATE()
		  WHERE PROC_FLAG = 'P'
		-- ================================================
		-- 로직 추가 end
		-- ================================================

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		CLOSE CUR_BOM_PRIORITY;
		DEALLOCATE CUR_BOM_PRIORITY;

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END

