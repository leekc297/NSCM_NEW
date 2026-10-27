
CREATE PROCEDURE [dbo].[PR_XIF_RCCP_TACT_TIME_S]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_RCP_TACT_TIME_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP
-- Destination System  : RCCP
-- Source Table        : SCM_TACT_TIME_M
-- Destination Table   : XIF_RCCP_TACT_TIME_S
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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_RCCP_TACT_TIME_S'
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
		
	 SET @IF_SEQ = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),121),'-',''),':',''),' ','') 
		
		 -- 동일 일자로 기존에 만들어진 정보 존재시 삭제
     DELETE [dbo].[SY_XIF_RCCP_TACT_TIME_S]
      WHERE CONVERT(NVARCHAR(8),IF_INS_DATE,112)  = CONVERT(NVARCHAR(8),GETDATE(),112)
		  
  
		  -- Current 기준 유효한 Line별 TactTime 정보 전송
						
			--SELECT * FROM [LGCE_INF].[DBO].[XIF_RCCP_TACT_TIME_S]
			INSERT INTO [dbo].[SY_XIF_RCCP_TACT_TIME_S]
			(
			 IF_SEQ
			,IF_TYPE
			,IF_ID
			,IF_INS_DATE
			,IF_FLAG
			,IF_SND_DATE
			,DIVISION_CODE
			,RESOURCE_CODE
			,RESOURCE_NAME
			,ITEM_CODE
			,ITEM_NAME
			,TACT_TIME
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
			SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ] AS NVARCHAR) AS IF_SEQ
				   , AA.IF_TYPE
				   , AA.IF_ID
				   , AA.IF_INS_DATE
				   , AA.IF_FLAG
				   , AA.IF_SND_DATE
				   , AA.DIVISION_CODE
				   , AA.RESOURCE_CODE
				   , AA.RESOURCE_NAME
				   , AA.ITEM_CODE
				   , AA.ITEM_NAME
				   , ISNULL(AA.TACT_TIME, 0) AS TACT_TIME
				   , MAX(AA.CREATE_USER_ID) OVER (PARTITION BY AA.COMPANY_ID,AA.DIVISION_CODE,AA.SITE_ID,AA.LINE_ID,AA.ITEM_CODE )   AS CREATE_USER_ID
				   , MAX(AA.CREATE_DATE ) OVER (PARTITION BY AA.COMPANY_ID,AA.DIVISION_CODE,AA.SITE_ID,AA.LINE_ID,AA.ITEM_CODE ) AS CREATE_DATE
				   , MAX(AA.MODIFY_USER_ID ) OVER (PARTITION BY AA.COMPANY_ID,AA.DIVISION_CODE,AA.SITE_ID,AA.LINE_ID,AA.ITEM_CODE ) AS MODIFY_USER_ID
				   , MAX(AA.MODIFY_DATE ) OVER (PARTITION BY AA.COMPANY_ID,AA.DIVISION_CODE,AA.SITE_ID,AA.LINE_ID,AA.ITEM_CODE ) AS MODIFY_DATE
				   , AA.ATTR_01
				   , AA.ATTR_02
				   , AA.ATTR_03
				   , AA.ATTR_04
				   , AA.ATTR_05
				   , AA.ATTR_06
				   , AA.ATTR_07
				   , AA.ATTR_08
				   , AA.ATTR_09
				   , AA.ATTR_10
			 FROM ( SELECT 'I'                           IF_TYPE
							,'OFP0_ORCP_FP_TACT_TIME'      IF_ID
							,GETDATE()                     IF_INS_DATE
							,'N'                           IF_FLAG
							,NULL                          IF_SND_DATE
							,T.[DIVISION_ID] AS DIVISION_CODE
							,[LINE_ID]  AS RESOURCE_CODE
							,( SELECT TOP 1 L.LINE_NAME
								 FROM [DBO].[SCM_LINE_M] L WITH(NOLOCK)
								WHERE L.LINE_ID      = T.LINE_ID
									) AS RESOURCE_NAME
							,T.[ITEM_ID]  AS ITEM_CODE
							,BB.[ITEM_NAME]
							,  CASE WHEN T.INSTANCE_TYPE IN ('E1','E2','S') AND UPPER(BB.ITEM_UOM) != 'M'
									THEN T.TACT_TIME 
										 --/ (CASE WHEN A.LANE_QTY IS NULL OR A.LANE_QTY = 0 THEN 1.0 ELSE A.LANE_QTY END) 
										 / (CASE WHEN T.LINE_LANE_QTY IS NULL OR T.LINE_LANE_QTY = 0 THEN T.ITEM_LANE_QTY ELSE T.LINE_LANE_QTY END)
										 * CASE WHEN (ISNULL(BB.COATED_LENGTH,0) + ISNULL(BB.UNCOATED_LENGTH, 0)) = 0 THEN 1
												ELSE (ISNULL(BB.COATED_LENGTH,0) + ISNULL(BB.UNCOATED_LENGTH, 0))
										   END
										 / CASE UPPER(BB.LENGTH_UOM) WHEN 'M'  THEN 1
																	 WHEN 'CM' THEN 100
																	 WHEN 'MM' THEN 1000
																			   ELSE 1 
											END
										 / ISNULL(T.PATTERN_QTY,1)
										 * CASE T.TACT_TIME_UOM  WHEN 'SECOND' THEN 1
																 WHEN 'MINUTE' THEN 60
																 WHEN 'MIN'    THEN 60
																 WHEN 'HOUR'   THEN 3600
																			   ELSE 1 
											END
									WHEN T.INSTANCE_TYPE IN ('E1','E2','S') AND UPPER(BB.ITEM_UOM) = 'M'
									THEN T.TACT_TIME 
										 --/ (CASE WHEN A.LANE_QTY IS NULL OR A.LANE_QTY = 0 THEN 1.0 ELSE A.LANE_QTY END) 
										 / (CASE WHEN T.LINE_LANE_QTY IS NULL OR T.LINE_LANE_QTY = 0 THEN T.ITEM_LANE_QTY ELSE T.LINE_LANE_QTY END)
										 * CASE T.TACT_TIME_UOM WHEN 'SECOND' THEN 1
																WHEN 'MINUTE' THEN 60
																WHEN 'MIN'    THEN 60
																WHEN 'HOUR'   THEN 3600
																		   ELSE 1
																END                                                               
									ELSE T.TACT_TIME * CASE T.TACT_TIME_UOM WHEN 'SECOND' THEN 1
																		    WHEN 'MINUTE' THEN 60
																			WHEN 'MIN'    THEN 60
																			WHEN 'HOUR'   THEN 3600
																					ELSE 1
													   END                               
							END	                        AS TACT_TIME
							,T.[INSERT_ID] AS CREATE_USER_ID
							,T.[INSERT_TIME] AS CREATE_DATE
							,T.[UPDATE_ID] AS MODIFY_USER_ID
							,T.[UPDATE_TIME] AS MODIFY_DATE 
							,NULL AS ATTR_01
							,NULL AS ATTR_02
							,NULL AS ATTR_03
							,NULL AS ATTR_04
							,NULL AS ATTR_05
							,NULL AS ATTR_06
							,NULL AS ATTR_07
							,NULL AS ATTR_08
							,NULL AS ATTR_09
							,NULL AS ATTR_10
							,T.COMPANY_ID
							,T.SITE_ID
							,T.LINE_ID
					   FROM  (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, 
									 A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, 
									 A.LANE_QTY AS LINE_LANE_QTY,     -- SCM_ITEM_LINE_ASSIGN_M 의 LANE_QTY
									 A.MONTH,
									 A.PRIORITY,
									 C.TACT_TIME,
									 C.TACT_TIME_UOM,
									 CASE WHEN B.ITEM_LANE_QTY = 0 THEN 1 ELSE B.ITEM_LANE_QTY END AS ITEM_LANE_QTY,
									 B.PATTERN_QTY,
									 D.INSTANCE_TYPE,
		 							 C.[INSERT_ID],
									 C.[INSERT_TIME],
									 C.[UPDATE_ID],
									 C.[UPDATE_TIME]
							  FROM  DBO.SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)
									LEFT  OUTER JOIN DBO.SCM_TACT_TIME_M C WITH(NOLOCK)
									ON     A.COMPANY_ID = C.COMPANY_ID
									AND    A.DIVISION_ID = C.DIVISION_ID
									AND    A.SITE_ID = C.SITE_ID
									AND    A.PLANT_ID = C.PLANT_ID
									AND    A.ITEM_ID = C.ITEM_ID
									AND    A.OPERATION_ID = C.OPERATION_ID
									AND    A.FACTORY_ID = C.FACTORY_ID
									AND    A.LINE_ID = C.LINE_ID
									AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
									AND    A.MONTH = C.MONTH
									LEFT OUTER JOIN 
									(SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,
											A.PATTERN_QTY, A.HALF_SLIT_FLAG,
											A.LANE_QTY AS ITEM_LANE_QTY,
											ROW_NUMBER() OVER (  PARTITION BY    [COMPANY_ID]
																				,[DIVISION_ID]
																				,[SITE_ID]
																				,[PLANT_ID]
																				,[ITEM_ID]
																				,[FACTORY_ID]
																ORDER BY [COMPANY_ID]
																		,[DIVISION_ID]
																		,[SITE_ID]
																		,[PLANT_ID]
																		,[ITEM_ID]
																		,[FACTORY_ID]
																		,[LANE_QTY] ) AS ROW_NUM
									FROM   DBO.SCM_ITEM_LANE_M A WITH(NOLOCK)
									WHERE  A.ACTIVE_FLAG = 'Y'
									) B
									ON     B.ROW_NUM = 1
									AND    A.COMPANY_ID = B.COMPANY_ID
									AND    A.DIVISION_ID = B.DIVISION_ID
									AND    A.SITE_ID = B.SITE_ID
									AND    A.PLANT_ID = B.PLANT_ID
									AND    A.FACTORY_ID = B.FACTORY_ID
									AND    A.ITEM_ID = B.ITEM_ID,
									DBO.SCM_OPERATION_M    D
							WHERE  1=1
							AND    A.ACTIVE_FLAG = 'Y'
							AND    A.MONTH BETWEEN  CONVERT(NVARCHAR(6), GETDATE(), 112)  AND CONVERT(NVARCHAR(6), GETDATE()+30, 112)
							AND    A.COMPANY_ID   = D.COMPANY_ID
							AND    A.DIVISION_ID  = D.DIVISION_ID
							AND    A.SITE_ID      = D.SITE_ID
							AND    A.OPERATION_ID = D.OPERATION_ID
							AND    A.OPERATION_ID IN (SELECT L.SEGMENT1
														FROM LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
													   WHERE L.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
														 AND L.ACTIVE_FLAG      = 'Y')
							) T
							,DBO.SCM_ITEM_M BB WITH(NOLOCK)
					  WHERE T.COMPANY_ID = BB.COMPANY_ID
						AND T.DIVISION_ID = BB.DIVISION_ID
						AND T.SITE_ID = BB.SITE_ID
						AND T.ITEM_ID = BB.ITEM_ID
						AND T.TACT_TIME IS NOT NULL ) AA
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


