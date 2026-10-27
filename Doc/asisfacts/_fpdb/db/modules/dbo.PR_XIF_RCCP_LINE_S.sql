
CREATE PROCEDURE [dbo].[PR_XIF_RCCP_LINE_S]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_RCCP_LINE_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP
-- Destination System  : RCCP
-- Source Table        : SCM_LINE_M
-- Destination Table   : XIF_RCCP_LINE_S
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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_RCCP_LINE_S'
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
     DELETE [dbo].[SY_XIF_RCCP_LINE_S]
      WHERE convert(NVARCHAR(8),IF_INS_DATE,112)  = convert(NVARCHAR(8),getdate(),112)
		  
  
		  -- Current 기준 유효한 LINE 정보 전송
			INSERT INTO [dbo].[SY_XIF_RCCP_LINE_S]
			(
			    IF_SEQ
			   ,IF_TYPE
			   ,IF_ID
			   ,IF_INS_DATE
			   ,IF_FLAG
			   ,IF_SND_DATE
			   ,DIVISION_CODE
			   ,SITE_CODE
			   ,SITE_NAME
			   ,PLANT_CODE
			   ,RESOURCE_CODE
			   ,RESOURCE_NAME
			   ,RESOURCE_GROUP
			   ,YIELD_RATIO
			   ,CREATE_USER_ID
			   ,CREATE_DATE
			   ,MODIFY_USER_ID
			   ,MODIFY_DATE
			   ,[ATTR_01]                                                                                                                                                                                                                                   
			   ,[ATTR_02]                                                                                                                                                                                                                                   
			   ,[ATTR_03]                                                                                                                                                                                                                                   
			   ,[ATTR_04]                                                                                                                                                                                                                                   
			   ,[ATTR_05]                                                                                                                                                                                                                                   
			   ,[ATTR_06]                                                                                                                                                                                                                                   
			   ,[ATTR_07]                                                                                                                                                                                                                                   
			   ,[ATTR_08]                                                                                                                                                                                                                                   
			   ,[ATTR_09]                                                                                                                                                                                                                                   
			   ,[ATTR_10]
			)

			SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ] AS NVARCHAR)
			--SELECT ''
			       ,'I'                       IF_TYPE
			       ,'OFP0_ORCP_FP_LINE'       IF_ID
			       ,GETDATE()                 IF_INS_DATE
			       ,'N'                       IF_FLAG
			       ,NULL                      IF_SND_DATE
			       ,A.DIVISION_ID
				   ,A.SITE_ID
				   ,MAX(A.SITE_NAME) AS SITE_NAME
				   ,A.PLANT_ID
				   ,A.RESOURCE_CODE
				   ,MAX(A.RESOURCE_NAME) AS RESOURCE_NAME
				   ,MAX(A.RESOURCE_GROUP) AS RESOURCE_GROUP
				   ,MAX(A.YELD_RATIO) AS YELD_RATIO
				   ,MAX(A.INSERT_ID) AS INSERT_ID
				   ,MAX(A.INSERT_TIME) AS INSERT_TIME
				   ,MAX(A.UPDATE_ID) AS UPDATE_ID
				   ,MAX(A.UPDATE_TIME) AS UPDATE_TIME
				   ,NULL ATTR_01
				   ,NULL ATTR_02
				   ,NULL ATTR_03
				   ,NULL ATTR_04
				   ,NULL ATTR_05
				   ,NULL ATTR_06
				   ,NULL ATTR_07
				   ,NULL ATTR_08
				   ,NULL ATTR_09
				   ,NULL ATTR_10
			   FROM (

						SELECT [DIVISION_ID]
							  ,[SITE_ID]
								,(SELECT MAX( Y.SITE_NAME )
									FROM [DBO].SCM_SITE_M Y WITH(NOLOCK)
				     				WHERE Y.SITE_ID = X.SITE_ID
								 ) SITE_NAME
							  ,[PLANT_ID]
							  ,[LINE_ID]    RESOURCE_CODE
							  ,[LINE_NAME]  RESOURCE_NAME
							  ,(SELECT TOP 1 B.OPERATION_GROUP_ID 
							      FROM SCM_OPERATION_M B WITH(NOLOCK)
								 WHERE B.OPERATION_ID = X.OPERATION_ID) AS RESOURCE_GROUP
							  ,ISNULL( (
								 SELECT AVG(V.YIELD)
								   FROM [DBO].[SCM_YIELD_M] V WITH(NOLOCK)
									WHERE X.PLANT_ID = V.PLANT_ID
									  AND X.LINE_ID =  V.LINE_ID
									  AND X.FACTORY_ID = V.FACTORY_ID
									  AND V.MONTH = CONVERT(NVARCHAR(6), GETDATE(), 112) -- 추후 변경 필요.
									  AND V.OPERATION_ID IN (SELECT L.SEGMENT1
															   FROM LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
															  WHERE L.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
																AND L.ACTIVE_FLAG      = 'Y')
								 ), 1) YELD_RATIO
							  ,[INSERT_ID]
							  ,[INSERT_TIME]
							  ,[UPDATE_ID]
							  ,[UPDATE_TIME]
						 FROM [DBO].[SCM_LINE_M] X						
			            WHERE X.OPERATION_ID IN (SELECT L.SEGMENT1
			                                       FROM LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE L
										          WHERE L.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
										            AND L.ACTIVE_FLAG      = 'Y')
						
			        ) A
			  --WHERE RESOURCE_CODE = 'E4D01'
			  GROUP BY DIVISION_ID
					  ,SITE_ID
					  ,PLANT_ID
					  ,RESOURCE_CODE

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


