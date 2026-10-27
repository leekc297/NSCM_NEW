


CREATE PROCEDURE [dbo].[PR_XIF_MES_FORM_QUALITY_WIP_HIST_R]
-- ================================================================================================
-- PROGRAM ID          : FP00871
-- PROGRAM NAME        : PR_XIF_MES_FORM_QUALITY_WIP_HIST_R
-- PARAM               :
-- BATCH PERIOD        : 1HOUR
-- DESCRIPTION         :
--
-- SOURCE SYSTEM       : 활성화 MES
-- DESTINATION SYSTEM  : FP SDB
-- SOURCE TABLE        : SY_XIF_MES_CHAR_DAILY_RESULT_R
-- DESTINATION TABLE   : SCM_DAILY_PRODUCT_RESULT_H
--
-- CREATE DATE		   : 2021.12.03
-- UPDATE DATE		   : 2022.09.05 1.1

-- VERSION             : 1.0
--                       1.0 2021-12-03 김승일 초기 형성
--                       1.1 2022-09-05 김춘동 PLAN DATE를 일자로 변환하여 GROUP BY 수행
--                       1.2 2023-05-08 FP Pjt. 당일실적 제외(요청번호 : E20230504-000868)
-- ================================================================================================
-- PARAMETER
@P_SITE_ID NVARCHAR(50) = 'NULL',
@P_IF_ID NVARCHAR(50) = 'NULL'

AS

BEGIN

		

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_FORM_QUALITY_WIP_HIST_R'
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

	DECLARE @IF_ID       NVARCHAR(50)
	DECLARE @ACCUM_DATE          NVARCHAR(1000)
	DECLARE @SITE_ID          NVARCHAR(1000)

	
	-- ================================================
    -- Declare end
	-- ================================================

	DECLARE CUR_IF_FORM_RESULT CURSOR FOR
		SELECT IF_ID, ACCUM_DATE , ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z (NOLOCK) WHERE Z.FACTORY_ID = MAX(R.FACTORY_ID) ) SITE_ID
		FROM  SY_XIF_MES_CHAR_DAILY_RESULT_R R
		WHERE 1=1
		AND PROC_FLAG = 'N'
		AND IF_ID  = ( CASE WHEN @P_IF_ID = 'NULL' OR @P_IF_ID IS NULL THEN IF_ID  ELSE @P_IF_ID END)
		GROUP BY IF_ID, ACCUM_DATE
		HAVING ( COUNT(1) = MAX(ACCUM_COUNT) -- 전체를 수신받지 못한 경우에는 처리하지 않음.
				OR ( COUNT(1) = 1 AND MAX(ACCUM_COUNT) = 0 ) )
		ORDER BY IF_ID, ACCUM_DATE;

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
		


	BEGIN TRY
		OPEN CUR_IF_FORM_RESULT;
		FETCH NEXT FROM CUR_IF_FORM_RESULT INTO @IF_ID        
												,@ACCUM_DATE
												,@SITE_ID	

		WHILE (@@FETCH_STATUS = 0)
		BEGIN 
			BEGIN TRAN
				IF ( @P_SITE_ID != 'NULL' AND @P_SITE_ID IS NOT NULL AND @SITE_ID = @P_SITE_ID ) OR (@P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL)			
				BEGIN
					 UPDATE [dbo].[SY_XIF_MES_CHAR_DAILY_RESULT_R]
					 SET PROC_FLAG = 'P'
						,PROC_DATE = GETDATE()
					 WHERE  PROC_FLAG = 'N'
						 AND    IF_ID      = @IF_ID
						 AND    ACCUM_DATE = @ACCUM_DATE
				     ;

			MERGE SCM_DAILY_PRODUCT_RESULT_H A
			USING (
				  SELECT B.COMPANY_ID
						,B.DIVISION_ID
						,B.SITE_ID
						,B.PLANT_ID
						,B.FACTORY_ID
   						--,A.ITEM_ID AS TOP_ITEM_ID
						,ISNULL(M.APPLIED_MODEL, A.ITEM_ID) AS TOP_ITEM_ID
						,A.ITEM_ID AS ITEM_ID
   						,CASE WHEN OPERATION_ID = 'FFD101' THEN 'F4000' ELSE 'F6000' END AS OPERATION_ID			-- 2019-09-05 PIYONG ADD
   						,'-' AS [LOCATION]
						,'MASS' AS [PRODUCTION_TYPE]
   						,'D' AS [MARKET]
						,A.LINE_ID
						,'-' AS [ELECTRODE_TYPE]
						,'-' AS [EQUIPMENT_ID]
						,A.PLAN_DATE AS PLAN_DATE
						,A.INPUT_QTY AS ACTUAL_QTY
						,A.ACTUAL_SCRAP_QTY
						,A.ACTUAL_GOOD_QTY
						,A.[ACTUAL_GOOD_QTY] AS QTY_LANE
						,A.[ACTUAL_GOOD_QTY] AS QTY
						,A.[ACTUAL_SCRAP_QTY] AS DFCT_QTY2
						,@v_proc_name AS [INSERT_ID]
						,GETDATE() AS [INSERT_TIME]
						,@v_proc_name AS [UPDATE_ID]
						,GETDATE() AS [UPDATE_TIME]
					FROM (SELECT PLANT_ID
							   , [FACTORY_ID]
							   , SUM([ACTUAL_GOOD_QTY] + [ACTUAL_SCRAP_QTY]) AS  [INPUT_QTY]
							   , SUM([ACTUAL_SCRAP_QTY]) AS [ACTUAL_SCRAP_QTY]
							   , SUM(ACTUAL_GOOD_QTY) AS [ACTUAL_GOOD_QTY]  -- 2020-10-16 kimcd 양품 재작업 양품 실적 수량에서 제외
							   , CONVERT(DATE, PLAN_DATE, 112) AS [PLAN_DATE]
							   , LINE_ID
							   , [ITEM_ID]
							   , OPERATION_ID							-- 2019-09-05 PIYONG ADD
							   --,[LOT_ID]
							   --,[SHIFT]
							   --,SUM(CASE WHEN LOT_TYPE = 2 THEN ERR_QTY ELSE 0 END) AS GOOD_REWORK_ERR_QTY -- 2020-10-16 kimcd 양품 재작업 유형의 불량 수량 합 
							FROM 

						( SELECT   [ITEM_ID]
								,PLANT_ID
								,FACTORY_ID
								,LINE_ID
								,[PLAN_DATE]
								--,[LOT_ID]
								--,[INPUT_QTY]
								,[ACTUAL_SCRAP_QTY]
								,[ACTUAL_GOOD_QTY]
								--,[FORM_LINE_ID]
								--,[SHIFT]
								--,[LOT_TYPE]
								--,[TR_TYPE]
								--,LOT_COMMENT
								,OPERATION_ID
								--,LOSS_CODE
								--,UPD_TIME			
            
						  FROM ( --A1 start
									SELECT  ( SELECT TOP 1 PLANT_ID FROM SCM_FACTORY_M WHERE [FACTORY_ID] = ISNULL(LM.FACTORY_ID, A.[FACTORY_ID])) AS PLANT_ID
											,ISNULL(LM.FACTORY_ID, A.[FACTORY_ID]) AS FACTORY_ID 
											,ISNULL(LM.[LINE_ID], A.LINE_ID ) AS LINE_ID
											,[PLAN_DATE]
											,[ITEM_ID]
											--,[LOT_ID]
											--,[INPUT_QTY]
											,[ACTUAL_SCRAP_QTY]
											,[ACTUAL_GOOD_QTY]
											--,[FORM_LINE_ID]
											--,[SHIFT]
											--,[LOT_TYPE]
											--,[TR_TYPE]
											--,LOT_COMMENT
											,OPERATION_ID
											--,LOSS_CODE
											--,UPD_TIME
									FROM  ( --A   
												SELECT  @SITE_ID  AS SITE_ID
														--, [DIVISION_ID]
														,[PLANT_ID]
														,[FACTORY_ID]
														,[LINE_ID]
														,[PLAN_DATE]
														,[ITEM_ID]
														--,[LOT_ID]
														,[ACTUAL_SCRAP_QTY]
														,[ACTUAL_GOOD_QTY]
														--,[FORM_LINE_ID]	--2018-06-12 PIYONG ADD
														--,[SHIFT]			--2018-06-12 PIYONG ADD
														--,[LOT_TYPE]		--2018-06-12 PIYONG ADD
														--,[TR_TYPE]			--2018-06-12 PIYONG ADD
														--,LOT_COMMENT
														,OPERATION_ID			-- 2019-09-05 PIYONG ADD
														--,LOSS_CODE
														--,UPD_TIME
													FROM SY_XIF_MES_CHAR_DAILY_RESULT_R
													WHERE PROC_FLAG  = 'P'						
													AND   IF_ID      = @IF_ID
													AND   ACCUM_DATE = @ACCUM_DATE
													AND   OPERATION_ID IN  ( 'FF5101','FFD101')
													AND   PLAN_DATE < FORMAT(getdate(), 'yyyy-MM-dd')   --1.2 2023-05-08 FP Pjt. 당일실적 제외
											) A

											LEFT OUTER JOIN
											(			SELECT *
														FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
														WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
															AND ACTIVE_FLAG = 'Y'
											) SSLV   	
														ON A.LINE_ID = SSLV.SEGMENT2
														AND A.SITE_ID = SSLV.SEGMENT1
														AND A.FACTORY_ID = SSLV.ATTRIBUTE1

											LEFT OUTER JOIN 
											(			SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
														FROM SCM_LINE_M
														WHERE OPERATION_ID IN ( 'F4000', 'F6000')
															AND ACTIVE_FLAG = 'Y'
											) LM
														ON SSLV.SEGMENT5 = LM.LINE_ID
														AND SSLV.SEGMENT1 = LM.SITE_ID
																	
							) A1
						) R
						GROUP BY  PLANT_ID
								,[FACTORY_ID]
								,CONVERT(DATE, PLAN_DATE, 112)
								,LINE_ID
								--,FORM_LINE_ID
								,ITEM_ID
								--,SHIFT
								--,LOT_ID
								--,LOT_COMMENT
								,OPERATION_ID
								) A
					,SCM_FACTORY_M  B
					,SCM_ITEM_M M
				WHERE 1=1
					AND A.FACTORY_ID = B.FACTORY_ID
					AND A.PLANT_ID = B.PLANT_ID
					AND A.ITEM_ID		= M.ITEM_ID
					AND B.DIVISION_ID	= M.DIVISION_ID
					AND B.SITE_ID		= M.SITE_ID
					AND B.COMPANY_ID	= M.COMPANY_ID 			
			)
			B
			  ON ( A.[FACTORY_ID] = B.[FACTORY_ID]
							AND A.[LINE_ID] = B.[LINE_ID]
							AND A.[PLAN_DATE] = B.[PLAN_DATE]
							AND A.[OPERATION_ID] = B.[OPERATION_ID]
							AND A.[TOP_ITEM_ID] = B.[TOP_ITEM_ID]
							AND A.[ITEM_ID] = B.[ITEM_ID]
							AND A.[FP_PRODUCTION_TYPE] = B.[PRODUCTION_TYPE]
							AND A.[LOCATION] = B.[LOCATION]
							AND A.[MARKET] = B.[MARKET]
							AND A.[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
							AND A.[EQUIPMENT_ID] = B.[EQUIPMENT_ID]
						  )
					 WHEN MATCHED THEN
						UPDATE 
						   SET A.[COMPANY_ID]		 = B.COMPANY_ID
							   ,A.[DIVISION_ID]		 = B.[DIVISION_ID]
							   ,A.[SITE_ID]			 = B.[SITE_ID]
							   ,A.[PLANT_ID]		 = B.[PLANT_ID]
							   ,A.[ACTUAL_QTY]		 = B.[ACTUAL_QTY]
							   ,A.[ACTUAL_GOOD_QTY]	 = B.[ACTUAL_GOOD_QTY]
							   ,A.[ACTUAL_SCRAP_QTY] = B.[ACTUAL_SCRAP_QTY]
							   ,A.[QTY_LANE]		 = B.[QTY_LANE]
							   ,A.[QTY]				 = B.[QTY]
							   ,A.[DFCT_QTY2]		 = B.[DFCT_QTY2]
							   ,A.[UPDATE_ID]		 = B.[UPDATE_ID]
							   ,A.[UPDATE_TIME]		 = B.[UPDATE_TIME]
					 WHEN NOT MATCHED THEN
						INSERT (
						  [COMPANY_ID]
						  ,[DIVISION_ID]
						  ,[SITE_ID]
						  ,[PLANT_ID]
						  ,[FACTORY_ID]
						  ,[TOP_ITEM_ID]
						  ,[ITEM_ID]
						  ,[OPERATION_ID]
						  ,[LOCATION]
						  ,[PRODUCTION_TYPE]
						  ,[MARKET]
						  ,[LINE_ID]
						  ,[ELECTRODE_TYPE]
						  ,[PLAN_DATE]
						  ,[ACTUAL_QTY]
						  ,[ACTUAL_GOOD_QTY]
						  ,[ACTUAL_SCRAP_QTY]
						  ,[QTY_LANE]
						  ,[QTY]
						  ,[DFCT_QTY2]
						  ,[FP_PRODUCTION_TYPE]	--2018-04-10 piyong add
						  ,[EQUIPMENT_ID]
						  ,[INSERT_ID]
						  ,[INSERT_TIME]
						  ,[UPDATE_ID]
						  ,[UPDATE_TIME]
						) VALUES (
						  B.[COMPANY_ID]
						  ,B.[DIVISION_ID]
						  ,B.[SITE_ID]
						  ,B.[PLANT_ID]
						  ,B.[FACTORY_ID]
						  ,B.[TOP_ITEM_ID]
						  ,B.[ITEM_ID]
						  ,B.[OPERATION_ID]
						  ,B.[LOCATION]
						  ,B.[PRODUCTION_TYPE]
						  ,B.[MARKET]
						  ,B.[LINE_ID]
						  ,B.[ELECTRODE_TYPE]
						  ,B.[PLAN_DATE]
						  ,B.[ACTUAL_QTY]
						  ,B.[ACTUAL_GOOD_QTY]
						  ,B.[ACTUAL_SCRAP_QTY]
						  ,B.[QTY_LANE]
						  ,B.[QTY]
						  ,B.[DFCT_QTY2]
						  ,B.[PRODUCTION_TYPE]	--2018-04-10 piyong add
						  ,B.[EQUIPMENT_ID]
						  ,B.[INSERT_ID]
						  ,B.[INSERT_TIME]
						  ,B.[UPDATE_ID]
						  ,B.[UPDATE_TIME]
						)
					;
					
					SET @ROWCOUNT = @@ROWCOUNT

  					UPDATE [dbo].SY_XIF_MES_CHAR_DAILY_RESULT_R
					SET    PROC_FLAG = 'Y'
						  ,PROC_DATE = GETDATE()
					WHERE  PROC_FLAG  = 'P'
					AND    IF_ID      = @IF_ID
					AND    ACCUM_DATE = @ACCUM_DATE;
					 
				END;



			FETCH NEXT FROM CUR_IF_FORM_RESULT INTO @IF_ID        
													,@ACCUM_DATE
													,@SITE_ID;
			COMMIT TRAN
		END;



		CLOSE CUR_IF_FORM_RESULT;
		DEALLOCATE CUR_IF_FORM_RESULT;

		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END', @ROWCOUNT, @V_TEMP1, '############### END OF PROCEDURE ###############', NULL, @SYSDATE
		
	END TRY	
	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH



end
