
CREATE PROCEDURE [dbo].[PR_XIF_PLM_FP_PLAN_S]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_PLM_FP_PLAN_S
-- Param               :
-- Batch Period        : 1 WEEK
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : PLM

-- Source Table        : FP_MOVE_PLAN_R
-- Destination Table   : XIF_PLM_FP_PLAN_S
--
-- Create Date		   : 2017.05.23
-- Update Date		   : 2017.11.10 PIYONG 1.1

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 PLAN_GROUP_ID 조회 조건 추가
-- ================================================================================================

-- PARAM


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PLM_FP_PLAN_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @if_id_code             NVARCHAR(50)  = 'OFP0_OPLM_FP_PLAN'
	DECLARE @send_if_seq            NVARCHAR(50)
	DECLARE @send_date              NVARCHAR(50)
	DECLARE @if_seq_next            BIGINT

	DECLARE @V_PLANT_ID				NVARCHAR(50);
	DECLARE @V_ITEM_ID				NVARCHAR(50);
	DECLARE @V_MIN_PLAN_DATE        NVARCHAR(10);
	DECLARE @V_NICK_NAME			NVARCHAR(50);
	DECLARE @V_APPLIED_MODEL        NVARCHAR(13);
	DECLARE @V_D_2_FLAN				NVARCHAR(1)
	DECLARE @V_D_4_FLAN				NVARCHAR(1)
	DECLARE @V_D_5_FLAN				NVARCHAR(1)



	DECLARE CUR_PLAN CURSOR FOR
		WITH CUR_WEEK AS ( SELECT DATEADD(DAY, 28, WEEKEND_DATE)  AS D5W
								  ,DATEADD(DAY, 21, WEEKEND_DATE)  AS D4W
								  ,DATEADD(DAY,  7, WEEKEND_DATE)  AS D2W
							 FROM DBO.SCM_SYS_CALENDAR_M WITH(NOLOCK)
							WHERE DATE_ID = CONVERT(DATE, GETDATE(), 120)
		                 ) 
		SELECT  B.PLANT_ID
			    ,B.ITEM_ID
			    ,SUBSTRING(CONVERT(NVARCHAR,B.MIN_PLAN_DATE, 120 ), 1, 10) AS MIN_PLAN_DATE
			    ,B.NICK_NAME
			    ,B.APPLIED_MODEL
			    ,B.D_2_FLAN
			    ,B.D_4_FLAN
			    ,B.D_5_FLAN
		  FROM  ( SELECT PPE.PLANT_ID
					     ,PPE.ITEM_ID
					     ,MIN(PPE.PLAN_DATE)      AS MIN_PLAN_DATE
					     ,MIN(SIM.NICK_NAME)      AS NICK_NAME
					     ,MIN(SIM.APPLIED_MODEL)  AS APPLIED_MODEL
					     ,CASE WHEN MIN(PPE.PLAN_DATE) <= MIN(CW.D2W) THEN
									'Y'
								END AS  D_2_FLAN
						 ,CASE WHEN MIN(PPE.PLAN_DATE) <= MIN(CW.D4W) THEN
									'Y'
								 END AS  D_4_FLAN
						 ,CASE WHEN MIN(PPE.PLAN_DATE) <= MIN(CW.D5W) THEN
									'Y'
								END AS  D_5_FLAN
				    FROM CUR_WEEK                           CW,
						 DBO.SCM_ITEM_M                     SIM WITH(NOLOCK),
						 DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R PPE WITH(NOLOCK),
						 ( SELECT DIVISION_ID
								  , FACTORY_ID
								  , PLAN_ID
							 FROM ( SELECT DIVISION_ID
											, FACTORY_ID
											, PLAN_ID AS PLAN_ID
									        ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, FACTORY_ID, INSTANCE_ID ORDER BY DIVISION_ID, FACTORY_ID, INSTANCE_ID, RELEASE_TIME DESC) AS REL_CNT
									        ,RELEASE_TIME
								       FROM DBO.SCM_FP_PLAN_DETAIL_H C WITH(NOLOCK)
								       WHERE RELEASE_FLAG = 'Y'
								  ) A
						    WHERE A.REL_CNT = 1) A
				   WHERE PPE.DIVISION_ID = A.DIVISION_ID
					 AND PPE.FACTORY_ID  = A.FACTORY_ID
					 AND PPE.FP_PLAN_ID  = A.PLAN_ID
					 AND PPE.DIVISION_ID = SIM.DIVISION_ID
					 AND PPE.SITE_ID     = SIM.SITE_ID
					 AND PPE.COMPANY_ID  = SIM.COMPANY_ID
					 AND PPE.ITEM_ID     = SIM.ITEM_ID
				   GROUP BY PPE.PLANT_ID
						 ,PPE.ITEM_ID )  B
		   WHERE B.D_5_FLAN = 'Y'
		   --2017-11-10 PIYONG PLAN_GROUP 조회 조건 추가 시작
		   ---------------------------------------------------------------------------------------------------------------------------------------
		   UNION ALL
		   SELECT B.PLANT_ID
				  ,B.ITEM_ID
				  ,SUBSTRING(CONVERT(NVARCHAR,B.MIN_PLAN_DATE, 120 ), 1, 10) AS MIN_PLAN_DATE
				  ,B.NICK_NAME
				  ,B.APPLIED_MODEL
				  ,B.D_2_FLAN
				  ,B.D_4_FLAN
				  ,B.D_5_FLAN
			 FROM ( SELECT PPE.PLANT_ID
							,PPE.ITEM_ID
							,MIN(PPE.PLAN_DATE)      AS MIN_PLAN_DATE
							,MIN(SIM.NICK_NAME)      AS NICK_NAME
							,MIN(SIM.APPLIED_MODEL)  AS APPLIED_MODEL
							,CASE WHEN MIN(PPE.PLAN_DATE) <= MIN(CW.D2W) THEN
									'Y'
								END AS  D_2_FLAN
							,CASE WHEN MIN(PPE.PLAN_DATE) <= MIN(CW.D4W) THEN
									'Y'
									END AS  D_4_FLAN
							,CASE WHEN MIN(PPE.PLAN_DATE) <= MIN(CW.D5W) THEN
									'Y'
								END AS  D_5_FLAN
					   FROM CUR_WEEK                           CW,
							DBO.SCM_ITEM_M                     SIM WITH(NOLOCK),
							DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R PPE WITH(NOLOCK),
							( SELECT PLAN_ID
									 ,PLAN_GROUP_ID
								FROM ( SELECT D.PLAN_GROUP_ID 
											  , D.PLAN_ID 
											  , ROW_NUMBER() OVER(PARTITION BY D.PLAN_GROUP_ID, D.INSTANCE_ID ORDER BY D.PLAN_GROUP_ID, D.INSTANCE_ID, D.RELEASE_TIME DESC) AS REL_CNT
										 FROM SCM_FP_PLAN_H        W WITH(NOLOCK)
											  ,SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
									    WHERE W.PLAN_ID =D.RELEASE_PLAN_ID
										  AND W.PLAN_TYPE = 'RELEASE'
										  AND D.RELEASE_FLAG = 'Y'
									) A
							  WHERE A.REL_CNT = 1
						    ) A
					  WHERE PPE.FP_PLAN_ID = A.PLAN_ID
						AND PPE.DIVISION_ID = SIM.DIVISION_ID
						AND PPE.SITE_ID     = SIM.SITE_ID
						AND PPE.COMPANY_ID  = SIM.COMPANY_ID
						AND PPE.ITEM_ID     = SIM.ITEM_ID
					    AND EXISTS (SELECT 1 
								      FROM SCM_LINE_M   SLM WITH(NOLOCK)
								     WHERE SLM.FACTORY_ID   = PPE.FACTORY_ID
								       AND SLM.LINE_ID      = PPE.LINE_ID
								       AND SLM.OPERATION_ID = PPE.OPERATION_ID
								       AND SLM.MODEL_TYPE   = A.PLAN_GROUP_ID
									)
					GROUP BY PPE.PLANT_ID
							,PPE.ITEM_ID
				  )  B
		    WHERE B.D_5_FLAN = 'Y'
		   ---------------------------------------------------------------------------------------------------------------------------------------
		   --2017-11-10 PIYONG PLAN_GROUP 조회 조건 추가 끝

		   ORDER BY B.PLANT_ID
			     ,B.ITEM_ID;
	-- ================================================
    -- Declare end
	-- ================================================

	SET @send_date = 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
			OPEN CUR_PLAN;
			FETCH NEXT FROM CUR_PLAN INTO @V_PLANT_ID
										 , @V_ITEM_ID
										 , @V_MIN_PLAN_DATE
										 , @V_NICK_NAME
										 , @V_APPLIED_MODEL
										 , @V_D_2_FLAN
										 , @V_D_4_FLAN
										 , @V_D_5_FLAN;

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				INSERT INTO [dbo].[SY_XIF_PLM_FP_PLAN_S] (
						   [IF_SEQ]
						   ,[IF_TYPE]
						   ,[IF_ID]
						   ,[IF_INS_DATE]
						   ,[IF_FLAG]
						   ,[IF_SND_DATE]
						   ,[PLANT_ID]
						   ,[ITEM_ID]
						   ,[MIN_PLAN_DATE]
						   ,[NICK_NAME]
						   ,[APPLIED_MODEL]
						   ,[D_2_FLAN]
						   ,[D_4_FLAN]
						   ,[D_5_FLAN]
						   ,[CREATE_DATE]
						   ,[CREATED_ID]
						   ,[UPDATE_DATE]
						   ,[UPDATE_ID]
				) VALUES(      								
							'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)
							,'S'                     
							,@if_id_code
							,GETDATE()             
							,'N'               
							,GETDATE()                   
						    ,@V_PLANT_ID
						    ,@V_ITEM_ID
						    ,@V_MIN_PLAN_DATE
						    ,@V_NICK_NAME
						    ,@V_APPLIED_MODEL
						    ,@V_D_2_FLAN
						    ,@V_D_4_FLAN
						    ,@V_D_5_FLAN
							,GETDATE()
							,'PR_XIF_PLM_FP_PLAN_S'
							,GETDATE()
							,'PR_XIF_PLM_FP_PLAN_S'
				)
			 ;
	
			 SET @ROWCOUNT = @@ROWCOUNT
			 				   	
				FETCH NEXT FROM CUR_PLAN INTO @V_PLANT_ID
										 , @V_ITEM_ID
										 , @V_MIN_PLAN_DATE
										 , @V_NICK_NAME
										 , @V_APPLIED_MODEL
										 , @V_D_2_FLAN
										 , @V_D_4_FLAN
										 , @V_D_5_FLAN;
			END;
			CLOSE CUR_PLAN;
			DEALLOCATE CUR_PLAN;      
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		SELECT ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
