
CREATE PROCEDURE [dbo].[PR_XIF_RCCP_FROZEN_PLAN_S]
-- ALTER PROCEDURE [dbo].[PR_XIF_RCCP_FROZEN_PLAN_S]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_RCCP_FROZEN_PLAN_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP
-- Destination System  : RCCP
-- Source Table        : FP_PRODUCTION_PLAN_R
-- Destination Table   : XIF_RCCP_FROZEN_PLAN_S
--
-- Create(Update) Date : 2016.08.16
-- Author              : 김 석
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_RCCP_FROZEN_PLAN_S'
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
	DECLARE @IF_SEQ       BIGINT

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		
	 SET @IF_SEQ = replace(replace(replace(convert(NVARCHAR(19),getdate(),121),'-',''),':',''),' ','') 
		
		 -- 동일 일자로 기존에 만들어진 정보 존재시 삭제
     DELETE [dbo].[SY_XIF_RCCP_FROZEN_PLAN_S]
      WHERE convert(NVARCHAR(8),IF_INS_DATE,112)  = convert(NVARCHAR(8),getdate(),112)
		  
  
		  -- Current 기준 유효한 Line별 TactTime 정보 전송
									
			--DELETE FROM [LGCE_INF].[DBO].[XIF_RCCP_FROZEN_PLAN_S]
			INSERT INTO [dbo].[SY_XIF_RCCP_FROZEN_PLAN_S]
			(
					 IF_SEQ
					,IF_TYPE
					,IF_ID
					,IF_INS_DATE
					,IF_FLAG
					,IF_SND_DATE
					,DIVISION_CODE
					,PLAN_START_YYYYMMDD
					,SITE_CODE
					,SITE_NAME
					,RESOURCE_CODE
					,RESOURCE_NAME
					,YYYYMMDD
					,ITEM_CODE
					,ITEM_NAME
					,PLAN_QTY
					,CREATE_USER_ID
					,CREATE_DATE
					,MODIFY_USER_ID
					,MODIFY_DATE
					,ATTR_01
					,ATTR_02
					,ATTR_03
					,ATTR_04
					,ATTR_05
					,ATTR_06
					,ATTR_07
					,ATTR_08
					,ATTR_09
					,ATTR_10
			)
			SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ] AS NVARCHAR)
			--SELECT  ''                       IF_SEQ
							,'I'                         IF_TYPE
							,'OFP0_ORCP_FP_FROZEN_PLAN'  IF_ID
							,GETDATE()                   IF_INS_DATE
							,'N'                         IF_FLAG
							,NULL                        IF_SND_DATE
							,[DIVISION_ID]
							,convert(NVARCHAR(8), DATEADD(D, (DATEPART(DW, GETDATE()) - 2 )*-1, GETDATE()), 112) [PLAN_START_YYYYMMDD]
							,[PLANT_ID]  SITE_ID
							,( 
							SELECT L.PLANT_NAME
							FROM [DBO].[SCM_PLANT_M] L WITH(NOLOCK)
							WHERE L.COMPANY_ID = PP.COMPANY_ID
							  AND L.DIVISION_ID = PP.DIVISION_ID
							  AND L.PLANT_ID = PP.PLANT_ID
							)  SITE_NAME
							,[LINE_ID]
							,(
							SELECT TOP 1 L.LINE_NAME
							FROM [DBO].[SCM_LINE_M] L WITH(NOLOCK)
							WHERE L.LINE_ID = PP.LINE_ID
							) LINE_NAME
							,CONVERT(NVARCHAR(8), [PLAN_DATE], 112)
							,[ITEM_ID]
							,(
							SELECT TOP 1 L.ITEM_NAME
							FROM [DBO].[SCM_ITEM_M] L WITH(NOLOCK)
							WHERE L.SITE_ID = PP.SITE_ID
							  AND L.DIVISION_ID = PP.DIVISION_ID
							  AND L.ITEM_ID = PP.ITEM_ID
							) ITEM_NAME
							,SUM([PLAN_QTY])    
							,MAX([INSERT_ID])     [CREATE_USER_ID]
							,MAX([INSERT_TIME])   [CREATE_DATE]
							,MAX([INSERT_ID])     [MODIFY_USER_ID]
							,MAX([INSERT_TIME])   [MODIFY_DATE]
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
							,NULL
			  FROM [DBO].[FP_PRODUCTION_PLAN_R] PP WITH(NOLOCK)
			  WHERE  PP.FP_PLAN_ID = ( SELECT MAX(XP.FP_PLAN_ID)
			                           FROM   [DBO].[FP_PRODUCTION_PLAN_R] XP WITH(NOLOCK)
									   WHERE  XP.INSTANCE_ID = PP.INSTANCE_ID)
			 GROUP BY  COMPANY_ID
			          ,SITE_ID
			          ,DIVISION_ID
			          ,PLANT_ID
					  ,LINE_ID
					  ,PLAN_DATE
					  ,ITEM_ID
					  ,INSTANCE_ID
					  ,FP_PLAN_ID
			;

			SET @ROWCOUNT = @@ROWCOUNT

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
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END


