
CREATE PROCEDURE [dbo].[PR_XIF_ERP_LINE_BOM_PRIORITY_R]

-- ================================================================================================
-- Program ID          : FP00222
-- Program Name        : PR_XIF_ERP_LINE_BOM_PRIORITY_R
-- Param               :
-- Batch Period        : realtime
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_LINE_BOM_PRIORITY_R
-- Destination Table   : FP_LINE_BOM_PRIORITY_M
--
-- Create(Update) Date : 2022.07.15

-- Author              : 김 춘 동
-- Version             : 1.0 2021-05-04 초기 형성
--                       1.1 2022-07-15 kimcd SCM_EQUIPMENT_M에서 SCM_LINE_M으로 변경 설비를 필수 정보에서 Option으로 수정
-- ================================================================================================
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_LINE_BOM_PRIORITY_R'
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
	DECLARE @IFSEQNO         NVARCHAR(16)
	DECLARE @COMPANY_ID      NVARCHAR(30)
	DECLARE @DIVISION_ID     NVARCHAR(30)
	DECLARE @SITE_ID         NVARCHAR(30)
	DECLARE @PLANT_ID        NVARCHAR(4)
	DECLARE @LINE_ID         NVARCHAR(30)
	DECLARE @PARENT_ITEM_ID  NVARCHAR(18)
	DECLARE @CHILD_ITEM_ID   NVARCHAR(18)
	DECLARE @REPLACE_ITEM_ID NVARCHAR(18)
	DECLARE @PARENT_QTY      NUMERIC(20,10)
	DECLARE @CHILD_QTY       NUMERIC(20,10)
	DECLARE @EFF_START_DATE  DATETIME
	DECLARE @EFF_END_DATE    DATETIME
	DECLARE @ACTIVE_FLAG     NVARCHAR(1)

	DECLARE CUR_LINE_PRIORITY CURSOR FOR
		SELECT DISTINCT LBP.IFSEQNO
			  ,P.COMPANY_ID
			  ,P.DIVISION_ID
			  ,P.SITE_ID
		      ,LBP.[PLANT_ID]
			  ,E.LINE_ID
			  ,LBP.[PARENT_ITEM_ID]
			  ,BA.CHILD_ITEM_ID
			  ,LBP.[REPLACE_ITEM_ID]
			  ,BA.PARENT_QTY
			  ,BR.CHILD_QTY
			  ,CASE WHEN BR.EFF_START_DATE  >= CONVERT(DATE, LBP.EFF_START_DATE, 112) THEN
			       BR.EFF_START_DATE
			   ELSE CONVERT(DATE, LBP.EFF_START_DATE, 112) END  AS EFF_START_DATE
			  ,BR.EFF_END_DATE
			  ,BR.ACTIVE_FLAG
  		FROM   SY_XIF_ERP_LINE_BOM_PRIORITY_R  LBP (NOLOCK)
		      ,SCM_PLANT_M     P  (NOLOCK)
			  ,SCM_BOM_M_V       BA (NOLOCK)
			  ,SCM_BOM_M_V       BR (NOLOCK)
			  ,SCM_ITEM_LINE_ASSIGN_ERP ILA (NOLOCK)
			  ,SCM_LINE_M      E (NOLOCK) -- 2022-07-15 kimcd SCM_EQUIPMENT_M에서 SCM_LINE_M으로 변경 설비를 필수 정보에서 Option으로 수정
		WHERE  P.PLANT_ID        = LBP.PLANT_ID
		AND    BR.COMPANY_ID     = P.COMPANY_ID
		AND    BR.DIVISION_ID    = P.DIVISION_ID
		AND    BR.SITE_ID        = P.SITE_ID
		AND    BR.PLANT_ID       = LBP.PLANT_ID
		AND    BR.PARENT_ITEM_ID = LBP.PARENT_ITEM_ID
		AND    BR.CHILD_ITEM_ID  = LBP.REPLACE_ITEM_ID
		AND    BR.EFF_END_DATE  >= CONVERT(DATE, LBP.EFF_START_DATE, 112)
		AND    BA.COMPANY_ID     = BR.COMPANY_ID
		AND    BA.DIVISION_ID    = BR.DIVISION_ID
		AND    BA.SITE_ID        = BR.SITE_ID
		AND    BA.PLANT_ID       = BR.PLANT_ID
		AND    BA.PARENT_ITEM_ID = BR.PARENT_ITEM_ID
		AND    BA.ALT_ID         = BR.ALT_ID
		AND    BA.KEY_DATE       = BR.EFF_START_DATE
		AND    BA.ALT_PRIORITY   = 1
		AND    BR.ACTIVE_FLAG    = 'Y'
		AND    ILA.[COMPANY_ID]  = P.COMPANY_ID
		AND    ILA.[DIVISION_ID] = P.DIVISION_ID
		AND    ILA.[SITE_ID]     = P.SITE_ID
		AND    ILA.[PLANT_ID]    = LBP.PLANT_ID
		AND    ILA.[ITEM_ID]     = LBP.PARENT_ITEM_ID
		AND    ILA.[PROD_VERSION] = LBP.ERP_OPERATION_CODE
		AND    ILA.[ACTIVE_FLAG] = 'Y'
		AND    ILA.END_TIME     >= CONVERT(DATE, LBP.EFF_START_DATE, 112)
		AND    E.[COMPANY_ID]    = P.COMPANY_ID
		AND    E.[DIVISION_ID]   = P.DIVISION_ID
		AND    E.[SITE_ID]       = P.SITE_ID
		AND    E.[PLANT_ID]      = ILA.PLANT_ID
		AND    E.[WORK_CENTER_ID] = ILA.[WORK_CENTER_ID]
		-- AND    E.[EQUIPMENT_TYPE] = 'M' 2022-07-15 kimcd SCM_LINE_M으로 변경하면서 조건 제거
		AND    E.[ACTIVE_FLAG]   = 'Y'
		AND	   LBP.TRANSFER_FLAG = 'P'
		OPTION ( FORCE ORDER );

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
		 UPDATE [dbo].[SY_XIF_ERP_LINE_BOM_PRIORITY_R]
			SET TRANSFER_FLAG = 'P'
			   ,TRANSFER_DATE = GETDATE()
		  WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'

		  OPEN CUR_LINE_PRIORITY;
		  FETCH NEXT FROM CUR_LINE_PRIORITY INTO @IFSEQNO
												,@COMPANY_ID
												,@DIVISION_ID
												,@SITE_ID
												,@PLANT_ID
												,@LINE_ID
												,@PARENT_ITEM_ID
												,@CHILD_ITEM_ID
												,@REPLACE_ITEM_ID
												,@PARENT_QTY
												,@CHILD_QTY
												,@EFF_START_DATE
												,@EFF_END_DATE
												,@ACTIVE_FLAG;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
				MERGE INTO [dbo].[FP_LINE_BOM_PRIORITY_M] LBP
				USING ( SELECT   @COMPANY_ID       AS COMPANY_ID
								,@DIVISION_ID      AS DIVISION_ID
								,@SITE_ID          AS SITE_ID
								,@PLANT_ID         AS PLANT_ID
								,@LINE_ID          AS LINE_ID
								,@PARENT_ITEM_ID   AS PARENT_ITEM_ID
								,@CHILD_ITEM_ID    AS CHILD_ITEM_ID
								,@REPLACE_ITEM_ID  AS REPLACE_ITEM_ID
								,@PARENT_QTY       AS PARENT_QTY
								,@CHILD_QTY        AS CHILD_QTY
								,@EFF_START_DATE   AS EFF_START_DATE
								,@EFF_END_DATE     AS EFF_END_DATE
								,@ACTIVE_FLAG      AS ACTIVE_FLAG
              			) XXX
				ON (         LBP.PLANT_ID       = XXX.PLANT_ID
						AND  LBP.LINE_ID        = XXX.LINE_ID
              			AND  LBP.PARENT_ITEM_ID = XXX.PARENT_ITEM_ID
              			AND  LBP.CHILD_ITEM_ID  = XXX.CHILD_ITEM_ID
              			AND  LBP.EFF_START_DATE = XXX.EFF_START_DATE
				)
				WHEN MATCHED THEN
					UPDATE SET REPLACE_ITEM_ID = XXX.REPLACE_ITEM_ID
							  ,PARENT_QTY      = XXX.PARENT_QTY
              				  ,CHILD_QTY       = XXX.CHILD_QTY
              			  	  ,EFF_END_DATE    = XXX.EFF_END_DATE
              				  ,ACTIVE_FLAG     = 'Y'      
              				  ,UPDATE_ID       = @v_proc_name
              				  ,UPDATE_TIME     = GETDATE()     
				WHEN NOT MATCHED THEN
              		INSERT ( COMPANY_ID           
              				,DIVISION_ID          
              				,SITE_ID         
              				,PLANT_ID
							,LINE_ID     
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
							,XXX.LINE_ID
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

				FETCH NEXT FROM CUR_LINE_PRIORITY INTO   @IFSEQNO
														,@COMPANY_ID
														,@DIVISION_ID
														,@SITE_ID
														,@PLANT_ID
														,@LINE_ID
														,@PARENT_ITEM_ID
														,@CHILD_ITEM_ID
														,@REPLACE_ITEM_ID
														,@PARENT_QTY
														,@CHILD_QTY
														,@EFF_START_DATE
														,@EFF_END_DATE
														,@ACTIVE_FLAG;
		  END;
		  CLOSE CUR_LINE_PRIORITY;
		  DEALLOCATE CUR_LINE_PRIORITY;

		UPDATE LBP
		SET   LBP.EFF_END_DATE
			  = ISNULL((SELECT TOP 1 LBE.EFF_START_DATE
						FROM   [dbo].[FP_LINE_BOM_PRIORITY_M] LBE (NOLOCK)
						WHERE  LBE.PLANT_ID        = LBP.PLANT_ID
						AND    LBE.LINE_ID         = LBP.LINE_ID
						AND    LBE.PARENT_ITEM_ID  = LBP.PARENT_ITEM_ID
						AND    LBE.CHILD_ITEM_ID   = LBP.CHILD_ITEM_ID
						AND    LBE.EFF_START_DATE  > LBP.EFF_START_DATE
						ORDER  BY LBE.EFF_START_DATE), '9999-12-31')
	          ,UPDATE_ID       = @v_proc_name
		      ,UPDATE_TIME     = GETDATE()     
		FROM   [dbo].[FP_LINE_BOM_PRIORITY_M] LBP
			  ,(SELECT DISTINCT 
					   LBP.[PLANT_ID]
					  ,LBP.[PARENT_ITEM_ID]
					  ,BA.CHILD_ITEM_ID
				FROM   SCM_PLANT_M     P  (NOLOCK)
					  ,SCM_BOM_M_V       BA (NOLOCK)
					  ,SCM_BOM_M_V       BR (NOLOCK)
					  ,SY_XIF_ERP_LINE_BOM_PRIORITY_R  LBP (NOLOCK)
				WHERE  P.PLANT_ID        = LBP.PLANT_ID
				AND    BR.COMPANY_ID     = P.COMPANY_ID
				AND    BR.DIVISION_ID    = P.DIVISION_ID
				AND    BR.SITE_ID        = P.SITE_ID
				AND    BR.PLANT_ID       = LBP.PLANT_ID
				AND    BR.PARENT_ITEM_ID = LBP.PARENT_ITEM_ID
				AND    BR.CHILD_ITEM_ID  = LBP.REPLACE_ITEM_ID
				AND    BR.EFF_END_DATE  >= CONVERT(DATE, LBP.EFF_START_DATE, 112)
				AND    BA.COMPANY_ID     = BR.COMPANY_ID
				AND    BA.DIVISION_ID    = BR.DIVISION_ID
				AND    BA.SITE_ID        = BR.SITE_ID
				AND    BA.PLANT_ID       = BR.PLANT_ID
				AND    BA.PARENT_ITEM_ID = BR.PARENT_ITEM_ID
				AND    BA.ALT_ID         = BR.ALT_ID
				AND    BA.KEY_DATE       = BR.EFF_START_DATE
				AND    BA.ALT_PRIORITY   = 1
				AND	   LBP.TRANSFER_FLAG = 'P' ) B
		WHERE LBP.PLANT_ID       = B.PLANT_ID
		AND	  LBP.PARENT_ITEM_ID = B.PARENT_ITEM_ID
		AND	  LBP.CHILD_ITEM_ID	 = B.CHILD_ITEM_ID;

		 UPDATE [dbo].[SY_XIF_ERP_LINE_BOM_PRIORITY_R]
			SET TRANSFER_FLAG = 'Y'
			   ,TRANSFER_DATE = GETDATE()
		  WHERE TRANSFER_FLAG = 'P'
		-- ================================================
		-- 로직 추가 end
		-- ================================================

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		CLOSE CUR_LINE_PRIORITY;
		DEALLOCATE CUR_LINE_PRIORITY;

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END

