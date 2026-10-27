
CREATE       PROCEDURE [dbo].[PR_XIF_PDS_BASE_INFO_S]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_PDS_BASE_INFO_S
-- Param               :
-- Batch Period        : 6 HOUR
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2022-03-28
--
-- Author              : FP Pjt.
-- Version             : 1.0 2023-09-01
--
--                
-- ================================================================================================
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PDS_BASE_INFO_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER	  = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @send_date              NVARCHAR(50)


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

		INSERT INTO [dbo].[SY_XIF_PDS_LINE_S]
				  ( [IF_SEQ]
				  , [IF_TYPE]
				  , [IF_ID]
				  , [IF_INS_DATE]
				  , [IF_FLAG]
				  , [IF_SND_DATE]
				  , [COMPANY_ID]
				  , [DIVISION_ID]
				  , [SITE_ID]
				  , [PLANT_ID]
				  , [FACTORY_ID]
				  , [OPERATION_ID]
				  , [LINE_ID]
				  , [LINE_NAME]
				  , [ACTIVE_FLAG]
				  , [ELECTRODE_TYPE]
				  , [DESCRIPTION]
				  , [INSERT_ID]
				  , [INSERT_TIME]
				  , [UPDATE_ID]
				  , [UPDATE_TIME]
				  , [ATTRIBUTE1]
				  ) 
		     SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
		     			   + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ])) 
		     			   + CAST( NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ] AS NVARCHAR) AS IF_SEQ
		     	  , 'S'           AS IF_TYPE
		     	  , 'OFP0_GPDS_FP_LINE'   AS IF_ID
		     	  , GETDATE()     AS IF_INS_DATE
		     	  , 'N'           AS IF_FLAG
		     	  , NULL          AS IF_SND_DATE
		     	  , A.COMPANY_ID
		     	  , ISNULL(PD.ORIGINAL_DIVISION_ID, A.DIVISION_ID) AS DIVISION_ID  
		     	  , A.SITE_ID
		     	  , ISNULL(F.MES_PLANT_ID, A.PLANT_ID) AS PLANT_ID	-- 2025-07-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
		     	  , A.FACTORY_ID
		     	  , A.OPERATION_ID
		     	  , A.LINE_ID
		     	  , A.LINE_NAME
		     	  , A.ACTIVE_FLAG
		     	  , A.ELECTRODE_TYPE
		     	  , A.DESCRIPTION
		     	  , A.INSERT_ID
		     	  , A.INSERT_TIME
		     	  , A.UPDATE_ID
		     	  , A.UPDATE_TIME
		     	  , A.MES_LINE_ID AS ATTRIBUTE1
		       FROM [dbo].[SCM_LINE_M] A with(nolock)
		            LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] AS PD with(NOLOCK)  
		     	 ON PD.PLANT_ID = A.PLANT_ID
					join [DBO].[SCM_SYS_LOOKUP_VALUE] AS W WITH(NOLOCK)
				 ON W.LOOKUP_TYPE_CODE = 'PDS_COMPANY'
				AND W.SEGMENT1 = A.COMPANY_ID
				AND W.SEGMENT2 = A.PLANT_ID
				AND W.ACTIVE_FLAG = 'Y'
					INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
					ON 1=1
					AND A.DIVISION_ID 	= F.DIVISION_ID
					AND A.FACTORY_ID 	= F.FACTORY_ID
	    WHERE 1 = 1
	    AND A.[UPDATE_TIME] >= CONVERT(NVARCHAR(20), DATEADD(HOUR, -7, GETDATE()),120)


		INSERT INTO [dbo].[SY_XIF_PDS_LINE_EQUIPMENT_S]
				  ( [IF_SEQ]
				  , [IF_TYPE]
				  , [IF_ID]
				  , [IF_INS_DATE]
				  , [IF_FLAG]
				  , [IF_SND_DATE]
				  , [COMPANY_ID]
				  , [DIVISION_ID]
				  , [SITE_ID]
				  , [PLANT_ID]
				  , [FACTORY_ID]
				  , [OPERATION_ID]
				  , [LINE_ID]
				  , [EQUIPMENT_ID]
				  , [FP_LINE_ID]
				  , [ACTIVE_FLAG]
				  , [DESCRIPTION]
				  , [INSERT_ID]
				  , [INSERT_TIME]
				  , [UPDATE_ID]
				  , [UPDATE_TIME]
				  ) 
		     SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
		     			   + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ])) 
		     			   + CAST( NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ] AS NVARCHAR) AS IF_SEQ
		     	  , 'S'           AS IF_TYPE
		     	  , 'OFP0_GPDS_FP_LINE_EQUIPMENT'   AS IF_ID
		     	  , GETDATE()     AS IF_INS_DATE
		     	  , 'N'           AS IF_FLAG
		     	  , NULL          AS IF_SND_DATE
		     	  , A.COMPANY_ID
		     	  , ISNULL(PD.ORIGINAL_DIVISION_ID, A.DIVISION_ID) AS DIVISION_ID  
		     	  , A.SITE_ID
		     	  , ISNULL(F.MES_PLANT_ID, A.PLANT_ID) AS PLANT_ID	-- 2025-07-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
		     	  , A.FACTORY_ID
		     	  , A.OPERATION_ID
		     	  , A.MES_LINE_ID AS LINE_ID
		     	  , A.EQUIPMENT_ID
		      	  , A.LINE_ID AS FP_LINE_ID
		     	  , A.ACTIVE_FLAG
		     	  , A.DESCRIPTION
		     	  , A.INSERT_ID
		     	  , A.INSERT_TIME
		     	  , A.UPDATE_ID
		     	  , A.UPDATE_TIME
		       FROM SCM_EQUIPMENT_M AS A WITH(NOLOCK)
		     	    JOIN SCM_FACTORY_M AS F WITH(NOLOCK)
		     	 ON 1=1
		     	 AND A.FACTORY_ID = F.FACTORY_ID
		     	 AND A.DIVISION_ID 	= F.DIVISION_ID
		        	LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK)  
		         ON PD.PLANT_ID = A.PLANT_ID
					join [DBO].[SCM_SYS_LOOKUP_VALUE] AS W WITH(NOLOCK)
				 ON W.LOOKUP_TYPE_CODE = 'PDS_COMPANY'
				AND W.SEGMENT1 = A.COMPANY_ID
				AND W.SEGMENT2 = A.PLANT_ID
				AND W.ACTIVE_FLAG = 'Y'
		      WHERE 1 = 1
		        AND A.OPERATION_ID != '*'
		        AND F.SHOP_GROUP_ID IN ('E', 'A')
		        AND A.EQUIPMENT_TYPE = 'M'
        	    AND A.[UPDATE_TIME] >= CONVERT(NVARCHAR(20), DATEADD(HOUR, -7, GETDATE()),120)


			
		INSERT INTO [dbo].[SY_XIF_PDS_ITEM_LINE_ASSIGN_S]
		          ( [IF_SEQ]
		          , [IF_TYPE]
		          , [IF_ID]
		          , [IF_INS_DATE]
		          , [IF_FLAG]
		          , [IF_SND_DATE]
		          , [COMPANY_ID]
		          , [DIVISION_ID]
		          , [SITE_ID]
		          , [PLANT_ID]
		          , [FACTORY_ID]
		          , [ITEM_ID]
		          , [OPERATION_ID]
		          , [LINE_ID]
		          , [ELECTRODE_TYPE]
		          , [MONTH]
		          , [LANE_QTY]
		          , [WORK_CENTER_ID]
		          , [PRIORITY]
		          , [CERTIFICATION_FLAG]
		          , [CERTIFICATION_DATE]
		          , [ACTIVE_FLAG]
		          , [DESCRIPTION]
		          , [INSERT_ID]
		          , [INSERT_TIME]
		          , [UPDATE_ID]
		          , [UPDATE_TIME]
		          , [WIP_LEVEL_QTY]
		          , [OLD_WIP_LEVEL_QTY]
		          )
		     SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
		     			  + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ])) 
		     			  + CAST( NEXT VALUE FOR [DBO].[XIF_PLM_SEND_SEQ] AS NVARCHAR) AS IF_SEQ
		     	  , 'S'           AS IF_TYPE
		     	  , 'OFP0_GPDS_FP_ITEM_LINE_ASSIGN'   AS IF_ID
		     	  , GETDATE()     AS IF_INS_DATE
		     	  , 'N'           AS IF_FLAG
		     	  , NULL          AS IF_SND_DATE
		     	  , A.[COMPANY_ID]
                  , ISNULL(PD.ORIGINAL_DIVISION_ID, A.DIVISION_ID) AS DIVISION_ID
                  , A.[SITE_ID]
                  , ISNULL(F.MES_PLANT_ID, A.PLANT_ID) AS PLANT_ID	-- 2025-07-03 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
               , A.[FACTORY_ID]
                  , A.[ITEM_ID]
                  , A.[OPERATION_ID]
                  , A.[LINE_ID]
                  , A.[ELECTRODE_TYPE]
                  , A.[MONTH]
                  , A.[LANE_QTY]
                  , A.[WORK_CENTER_ID]
                  , A.[PRIORITY]
                  , A.[CERTIFICATION_FLAG]
                  , A.[CERTIFICATION_DATE]
                  , A.[ACTIVE_FLAG]
 				  , A.[DESCRIPTION]
                  , A.[INSERT_ID]
                  , A.[INSERT_TIME]
                  , A.[UPDATE_ID]
                  , A.[UPDATE_TIME]
                  , A.[WIP_LEVEL_QTY]
                  , A.[OLD_WIP_LEVEL_QTY]
               FROM [dbo].[SCM_ITEM_LINE_ASSIGN_M] as A with(nolock)
		        	LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] AS PD (NOLOCK)  
		         ON PD.PLANT_ID = A.PLANT_ID
					join [DBO].[SCM_SYS_LOOKUP_VALUE] AS W WITH(NOLOCK)
				 ON W.LOOKUP_TYPE_CODE = 'PDS_COMPANY'
				AND W.SEGMENT1 = A.COMPANY_ID
				AND W.SEGMENT2 = A.PLANT_ID
				AND W.ACTIVE_FLAG = 'Y'
					INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
					ON 1=1
					AND A.DIVISION_ID 	= F.DIVISION_ID
					AND A.FACTORY_ID 	= F.FACTORY_ID
		      WHERE 1 = 1 
		      AND A.[UPDATE_TIME] >= CONVERT(NVARCHAR(20), DATEADD(HOUR, -7, GETDATE()),120)

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
