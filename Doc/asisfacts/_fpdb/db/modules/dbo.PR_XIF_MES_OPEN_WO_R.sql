
CREATE PROCEDURE [dbo].[PR_XIF_MES_OPEN_WO_R]
--ALTER PROCEDURE [dbo].[PR_XIF_MES_OPEN_WO_R]

-- ================================================================================================
-- Program ID          : FP00781
-- Program Name        : PR_XIF_MES_OPEN_WO_R
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_OPEN_WO_R
-- Destination Table   : FP_MES_WORK_ORDER_STATUS_H
--
-- Create(Update) Date : 2017-06-15
-- Update Date		   : 2017-07-06 1.1 kimcd
--						 2017-08-21 1.2 PIYONG
--						 2017-11-07 1.3 PIYONG
--                       2017-12-30 1.4 kimcd
--						 2018-04-20 1.5 PIYONG
--						 2018-10-16 1.6 PIYONG
--                       2019-11-23 1.7 kimcd
--                       2022-11-08 1.8 leeseonmgin
--                       2023-01-12 1.9 kimcd
--
-- Author              : PIYONG
-- Version             : 1.0
--                       1.1 kimcd Top Coating WO 제거 2017-07-06
--						 1.2 PIYONG  엑셀업로드한 데이터 구분 추가
--						 1.3 PIYONG	 TOP_ITME_ID 값을 수신받은 ATTR_02 값으로 변경
--                       1.4 kimcd   MES Work Order Plant 없는 오류 정보 제거
--						 1.5 FP_ERP_PRODUCTION_PLAN_M, FP_MES_PRODUCTION_PLAN_M ACTUAL_QTY 수량, ACTUAL_GOOD_QTY 수량, ACTUAL_SCRAP_QTY 수량, 상태값 변경
--						 1.6 2018-11-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
--                       1.7 2019-11-23 kimcd    폴란드 RTS 적용에 따른 RTS Order 수신 제외
--                       1.8 2022-11-08 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
--                       1.9 2023-01-12 kimcd    전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 open wo에는 줄 수 없다고 하여 수정
--                       2.0 2026-05-12 kimcd    [PJ20266179] AZ 법인 증설 SCM 대응
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_OPEN_WO_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @CNT		INTEGER	   = 0
	DECLARE @IF_ID		NVARCHAR(50)
	DECLARE @ACCUM_DATE NVARCHAR(8)


	DECLARE CUR_OPEN_WO CURSOR FOR
		SELECT IF_ID
			   , ACCUM_DATE
		  FROM DBO.[SY_XIF_MES_OPEN_WO_R]
		 WHERE PROC_FLAG = 'N'
		 -- AND ACCUM_DATE = CONVERT(CHAR(10), GETDATE(), 112) [PJ20266179] AZ 법인 증설 SCM 대응 한국 시간으로 일자 조건 제거 
		 GROUP BY IF_ID, ACCUM_DATE
		HAVING ( COUNT(1) = MAX(ACCUM_COUNT) OR ( COUNT(1) = 1 AND MAX(ACCUM_COUNT) = 0 ) ) 
		 ORDER BY IF_ID
			   , ACCUM_DATE

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			OPEN CUR_OPEN_WO;

			FETCH NEXT FROM CUR_OPEN_WO INTO  @IF_ID        
											  ,@ACCUM_DATE
		  ;

			WHILE (@@FETCH_STATUS = 0)
		  
				BEGIN
					UPDATE [DBO].[SY_XIF_MES_OPEN_WO_R]
					   SET PROC_FLAG = 'P'
					 WHERE PROC_FLAG = 'N'
					   AND IF_ID        = @IF_ID  
					   AND ACCUM_DATE   = @ACCUM_DATE


					INSERT INTO [dbo].[FP_MES_WORK_ORDER_STATUS_H] (
						[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[CUTOFF_DATE]
						,[WORK_ORDER_SPL_ID]
						,[WORK_ORDER_ID]
						,[DEMAND_ID]
						,[PRODUCTION_TYPE]
						,[ORDER_TYPE]
						,[ITEM_ID]
						,[TOP_ITEM_ID]
						,[OPERATION_ID]
						,[LINE_ID]
						,[WORK_CENTER_ID]
						,[EQUIPMENT_ID]
						,[PLAN_DATE]
						,[PLAN_START_TIME]
						,[PLAN_END_TIME]
						,[PLAN_IN_QTY]
						,[PLAN_QTY]
						,[ACTUAL_START_TIME]
						,[ACTUAL_END_TIME]
						,[ACTUAL_QTY]
						,[ACTUAL_GOOD_QTY]
						,[ACTUAL_SCRAP_QTY]
						,[RUNNING_FLAG]
						,[WO_STATUS]
						,[MARKET]
						,[BATCH_ORDER_ID]
						,[LANE_QTY]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[FP_PRODUCTION_TYPE]  -- FP 내부용 수요 유형
						,[WORK_REQUEST_MODEL_ID]	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,[VERSION]	                -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,[PROD_SEQ]	                -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,[PLM_EC_NO]	            -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리	

					)
					SELECT   A.COMPANY_ID
							,A.DIVISION_ID
							,A.SITE_ID
							,A.PLANT_ID
							,A.FACTORY_ID
							,A.CUTOFF_DATE
							,A.WORK_ORDER_SPL_ID
							,A.WO
							,A.DEMAND_ID
							,A.PRODUCTION_TYPE
							,A.ORDER_TYPE
							,A.ITEM_ID
							,A.TOP_ITEM_ID
							,A.OPERATION_ID
							,A.LINE_ID
							,A.WORK_CENTER_ID
							,A.EQUIPMENT_ID
							,A.PLAN_DATE
							,A.START_TIME
							,A.END_TIME
							,A.PLAN_IN_QTY
							,A.PLAN_QTY
							,A.ACTUAL_START_TIME
							,A.ACTUAL_END_TIME
							,A.ACTUAL_QTY
							,A.ACTUAL_GOOD_QTY
							,A.ACTUAL_SCRAP_QTY
							,A.RUNNING_FLAG   
							,A.WO_STATUS
							,A.MARKET
							,A.BATCH_ORDER_ID
							,A.LANE_QTY
							,A.INSERT_ID
							,A.INSERT_TIME
							,A.FP_PRODUCTION_TYPE
					        ,A.WORK_REQUEST_MODEL_ID   -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,A.[VERSION]               -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 open wo에는 줄 수 없다고 하여 수정
							,A.[PROD_SEQ]              -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 open wo에는 줄 수 없다고 하여 수정
							,A.PLM_EC_NO	           -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					FROM  ( SELECT /*	--2018-11-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
									CASE WHEN (SELECT TOP 1 SITE_ID FROM [dbo].[SCM_PLANT_M] with(nolock) WHERE PLANT_ID = A.PLANT_ID ) = 'A002' THEN
											CASE WHEN A.NJ_ELEC_CHECK IN ('G452', 'A') AND BUILNO = 'E7' THEN
													'G450'
												 ELSE
													(SELECT TOP 1 COMPANY_ID FROM [dbo].[SCM_PLANT_M] with(nolock) WHERE PLANT_ID = A.PLANT_ID )
												  END
											ELSE
												(SELECT TOP 1 COMPANY_ID FROM [dbo].[SCM_PLANT_M] with(nolock) WHERE PLANT_ID = A.PLANT_ID )
											END																												AS COMPANY_ID
									,CASE WHEN (SELECT TOP 1 SITE_ID FROM [dbo].[SCM_PLANT_M] with(nolock) WHERE PLANT_ID = A.PLANT_ID ) = 'A002' THEN
											CASE WHEN A.NJ_ELEC_CHECK IN ('G452', 'A') AND BUILNO = 'E7' THEN
													'81'
												 ELSE
													(SELECT TOP 1 DIVISION_ID FROM [dbo].[SCM_PLANT_M] with(nolock) WHERE PLANT_ID = A.PLANT_ID )
												  END
											ELSE
												(SELECT TOP 1 DIVISION_ID FROM [dbo].[SCM_PLANT_M] with(nolock) WHERE PLANT_ID = A.PLANT_ID )
											END																												AS DIVISION_ID
									,(SELECT TOP 1 SITE_ID
										FROM [dbo].[SCM_PLANT_M] with(nolock)
									   WHERE PLANT_ID = A.PLANT_ID )																						AS SITE_ID
									,PLANT_ID
									,CASE WHEN (SELECT TOP 1 SITE_ID FROM [dbo].[SCM_PLANT_M] with(nolock) WHERE PLANT_ID = A.PLANT_ID ) = 'A002' THEN
											CASE WHEN A.NJ_ELEC_CHECK IN ('G452', 'A') AND BUILNO = 'E7' THEN
													'E8'
												 ELSE
													A.BUILNO
												  END
										  ELSE
											BUILNO
										   END										AS FACTORY_ID
									*/
									(SELECT TOP 1 COMPANY_ID FROM [dbo].[SCM_PLANT_M] with(nolock) WHERE PLANT_ID = A.PLANT_ID )						AS COMPANY_ID
									,(SELECT TOP 1 DIVISION_ID FROM [dbo].[SCM_PLANT_M] with(nolock) WHERE PLANT_ID = A.PLANT_ID )						AS DIVISION_ID
									,(SELECT TOP 1 SITE_ID
										FROM [dbo].[SCM_PLANT_M] with(nolock)
									   WHERE PLANT_ID = A.PLANT_ID )																					AS SITE_ID
									,A.PLANT_ID
									,A.BUILNO AS FACTORY_ID
									,CAST(A.ACCUM_DATE AS DATE)						AS CUTOFF_DATE  -- 2026-05-12 kimcd [PJ20266179] AZ 법인 증설 SCM 대응 MES 전송 일자로 CUTOFF DATE 설정
									,A.WO_DETAIL									AS WORK_ORDER_SPL_ID
									,A.WO
									,A.DEMAND_ID
									,A.ORDER_TYPE AS PRODUCTION_TYPE
									,A.WO_TYPE    AS ORDER_TYPE
									,A.ITEM_ID
									,ISNULL(A.ATTR_02,'-') AS TOP_ITEM_ID											--2017-12-07 PIYONG 수신 데이터로 변경
									,A.OPERATION_ID
									,ISNULL(A.FP_LINE_ID, A.LINE_ID) AS LINE_ID
									,'-' AS WORK_CENTER_ID
									,A.EQUIPMENT_ID
									,CAST( A.PLAN_DATE AS DATETIME)  AS PLAN_DATE
									,CAST( A.START_TIME AS DATETIME) AS START_TIME
									,CAST( A.END_TIME AS DATETIME)   AS END_TIME
									,A.PLAN_QTY AS PLAN_IN_QTY
									,A.PLAN_QTY
									,CAST( A.ACTUAL_START_TIME AS DATETIME) AS ACTUAL_START_TIME
									,CAST( A.ACTUAL_END_TIME AS DATETIME)   AS ACTUAL_END_TIME
									,ISNULL(A.ACTUAL_QTY,0)          AS ACTUAL_QTY
									,A.ACTUAL_GOOD_QTY
									,A.ACTUAL_SCRAP_QTY
									,'-' AS RUNNING_FLAG   
									,CASE WHEN ATTR_01 = 'Y' THEN		--CHANGE  PIYONG 2017-08-21	KR_CELL_M_P 구분 적용
											'PILOT'
										  ELSE	
											A.WO_STATUS
										   END AS WO_STATUS
									,A.MARKET
									,A.BATCH_ORDER_ID
									,A.LANE_QTY
									,'PR_XIF_MES_OPEN_WO_R'  AS INSERT_ID
									,GETDATE()               AS INSERT_TIME
									,ISNULL( B.ATTRIBUTE5, A.ORDER_TYPE )   AS FP_PRODUCTION_TYPE    -- 2018-04-09 kimcd fp_product_type FP내부용 수요 유형 정보 추가
								    ,ISNULL(B.[WORK_REQUEST_MODEL_ID],'-')  AS WORK_REQUEST_MODEL_ID -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 open wo에는 줄 수 없다고 하여 수정
								    ,ISNULL(B.[VERSION],'-')                AS VERSION               -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 open wo에는 줄 수 없다고 하여 수정
								    ,B.[PROD_SEQ]                                                    -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 open wo에는 줄 수 없다고 하여 수정
									,ISNULL(A.ATTR_06,'-')                  AS PLM_EC_NO	         -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							  FROM [DBO].[SY_XIF_MES_OPEN_WO_R] A
								   LEFT OUTER JOIN [DBO].[FP_MES_PRODUCTION_PLAN_M] B (NOLOCK)
									   ON  A.WO_DETAIL    = B.WORK_ORDER_SPL_ID
									   AND A.WO           = B.WORK_ORDER_ID
							  WHERE A.WO_STATUS = 'OPEN'
								AND A.OVER_CMPL_FLAG = 'N'
								AND A.WO_STATUS IS NOT NULL
								AND A.OVER_CMPL_FLAG IS NOT NULL
								AND A.PROC_FLAG = 'P'
								AND A.IF_ID        = @IF_ID  
								AND A.ACCUM_DATE   = @ACCUM_DATE
								--AND A.START_TIME IS NOT NULL --운영에는 없음 확인필요
								AND A.PLANT_ID IS NOT NULL  -- 2017-12-30 kimcd mes 오류 work order 제거
								AND A.PLANT_ID != ''        -- 2017-12-30 kimcd mes 오류 work order 제거
								AND A.WO_TYPE  != 'RTS'     -- 2019-11-23 kimcd RTS에서 형성된 Order 제거
								-- kimcd add 2017-07-06 top work order 제거 시작
								AND NOT EXISTS ( SELECT  1
												 FROM    [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
														,[DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
														,[DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
														,[DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
														,[DBO].[SCM_PLANT_M] PM with(nolock)
												 WHERE   EQP.EQUIPMENT_ID = A.EQUIPMENT_ID
												 AND     EQP.OPERATION_ID = A.OPERATION_ID
												 AND     EQP.FACTORY_ID   = A.BUILNO
												 AND     EQP.EQUIPMENT_TYPE = 'M'
												 AND     EQP.ACTIVE_FLAG    = 'Y'
												 AND     EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
												 AND     EQPC.SEGMENT1         = EQP.OPERATION_ID
												 AND     EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
												 AND     EQPC.ACTIVE_FLAG      = 'Y'
												 AND     PM.PLANT_ID     = A.PLANT_ID
												 AND     IM.DIVISION_ID  = PM.DIVISION_ID
												 AND     IM.SITE_ID      = PM.SITE_ID
												 AND     IM.ITEM_ID      = A.ITEM_ID
												 AND     IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
												 AND     IMC.SEGMENT1         = IM.ITEM_CLASS
												 AND     IMC.ACTIVE_FLAG      = 'Y'
												 AND      A.COATING_SIDE_TYPE_CODE = 'T')
												 -- kimcd add 2017-07-06 top work order 제거 끝						
							) A

					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					--2018-04-20 PIYONG ADD START
					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- FP_MES_PRODUCTION_PLAN_M 수량, 상태값 변경
					UPDATE B
					   SET B.ACTUAL_QTY        = A.ACTUAL_QTY
						   ,B.ACTUAL_GOOD_QTY  = A.ACTUAL_GOOD_QTY
						   ,B.ACTUAL_SCRAP_QTY = A.ACTUAL_SCRAP_QTY
						   ,B.WO_STATUS        = A.WO_STATUS
						   ,B.UPDATE_ID        = 'PR_XIF_MES_OPEN_WO_R'
						   ,B.UPDATE_TIME      = GETDATE()
					  FROM [DBO].[SY_XIF_MES_OPEN_WO_R]     A WITH(NOLOCK)
						   ,[DBO].[FP_MES_PRODUCTION_PLAN_M] B
					 WHERE A.WO_DETAIL    = B.WORK_ORDER_SPL_ID
					   AND A.WO           = B.WORK_ORDER_ID
					   AND A.PROC_FLAG    = 'P'
					   AND A.IF_ID        = @IF_ID  
					   AND A.ACCUM_DATE   = @ACCUM_DATE
					    AND A.ACTUAL_QTY   > 0 -- 2023-01-12 kimcd 실적 수량만 변경해서 복원 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리 조건 삭제

					-- FP_ERP_PRODUCTION_PLAN_M 수량, 상태값 변경
					UPDATE B
					   SET B.ACTUAL_QTY       = A.ACTUAL_QTY
						   ,B.ACTUAL_GOOD_QTY  = A.ACTUAL_GOOD_QTY
						   ,B.ACTUAL_SCRAP_QTY = A.ACTUAL_SCRAP_QTY
						   ,B.WO_STATUS        = CASE WHEN A.ACTUAL_QTY >= B.PLAN_IN_QTY THEN 'Completed' ELSE 'Running' END  -- 생산 진행 현황 Deleted, Running, Completed
						   ,B.UPDATE_ID        = 'PR_XIF_MES_OPEN_WO_R'
						   ,B.UPDATE_TIME      = GETDATE()
					  FROM ( SELECT A.WO
								    ,SUM(A.ACTUAL_QTY)        AS  ACTUAL_QTY
								    ,SUM(A.ACTUAL_GOOD_QTY)   AS  ACTUAL_GOOD_QTY
								    ,SUM(A.ACTUAL_SCRAP_QTY)  AS  ACTUAL_SCRAP_QTY
							   FROM [DBO].[SY_XIF_MES_OPEN_WO_R]     A WITH(NOLOCK)
							  WHERE A.PROC_FLAG    = 'P'
							    AND A.IF_ID        = @IF_ID  
							    AND A.ACCUM_DATE   = @ACCUM_DATE
							    AND A.ACTUAL_QTY   > 0
							    AND A.WO_TYPE      = 'WO' 
							  GROUP BY A.WO
						   ) A
						   ,[DBO].[FP_ERP_PRODUCTION_PLAN_M] B 
					 WHERE A.WO = B.WORK_ORDER_ID

					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					--2018-04-20 PIYONG ADD END
					----------------------------------------------------------------------------------------------------------------------------------------------------------------

					-- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - WO 실적 기반으로 생산 버전 갱신 시작
					UPDATE A
					SET    A.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
						  ,A.[VERSION]	             = B.[VERSION]
						  ,A.[PROD_SEQ]	             = B.[PROD_SEQ]
						  ,A.[INSERT_TIME]           = GETDATE()
					FROM   [FP_MES_WORK_ORDER_STATUS_H] A
						   INNER JOIN ( SELECT   B.WO_DETAIL
												,B.WO
												,B.[WORK_REQUEST_MODEL_ID]
												,B.[VERSION]
												,B.[PROD_SEQ]
												,CAST(@ACCUM_DATE AS DATE) AS CUTOFF_DATE -- 2026-05-12 kimcd [PJ20266179] AZ 법인 증설 SCM 대응 MES 전송 일자로 CUTOFF DATE 설정
										  FROM  ( SELECT A.WO_DETAIL
														,A.WO
														,B.[WORK_REQUEST_MODEL_ID]
														,B.[VERSION]
														,B.[PROD_SEQ]
														,ROW_NUMBER() over ( partition by A.WO_DETAIL, A.WO 
																				order by B.[MODIFY_DATE] DESC ) ROWUMBER
												  FROM [DBO].[SY_XIF_MES_OPEN_WO_R] A
													   INNER JOIN [dbo].[SCM_MES_WIP_HISTORY_H] B (NOLOCK)
														   ON  A.WO_DETAIL    = B.WO_DETL_ID
														   AND A.WO           = B.WOID
														   AND A.OPERATION_ID = B.PROCID
												  WHERE A.WO_STATUS = 'OPEN'
													AND A.OVER_CMPL_FLAG = 'N'
													AND A.WO_STATUS IS NOT NULL
													AND A.OVER_CMPL_FLAG IS NOT NULL
													AND A.PROC_FLAG = 'P'
													AND A.IF_ID        = @IF_ID  
													AND A.ACCUM_DATE   = @ACCUM_DATE
													AND B.[VERSION]   != '' ) B
										 WHERE  B.ROWUMBER = 1 ) B
								ON  A.[WORK_ORDER_SPL_ID] = B.WO_DETAIL
								AND A.[WORK_ORDER_ID]     = B.WO
								AND A.[CUTOFF_DATE]       = B.[CUTOFF_DATE];
					-- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - WO 실적 기반으로 생산 버전 갱신 종료


					 UPDATE [DBO].[SY_XIF_MES_OPEN_WO_R]
					    SET PROC_FLAG = 'Y'
				      WHERE PROC_FLAG = 'P'
					    AND IF_ID        = @IF_ID  
					    AND ACCUM_DATE   = @ACCUM_DATE
					;


					FETCH NEXT FROM CUR_OPEN_WO INTO @IF_ID        
													,@ACCUM_DATE												
					;

			  END;

		  CLOSE CUR_OPEN_WO;
		  DEALLOCATE CUR_OPEN_WO;  

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END