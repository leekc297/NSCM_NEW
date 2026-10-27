
CREATE PROCEDURE [dbo].[PR_XIF_DW_WIP_HISTORY_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_DW_WIP_HISTORY_R
-- Param               :
-- Batch Period        : 1Day
-- Description         : FP00780 실행 Work Order 전환
--                       FP00830 생산 완료 실적 전환 > SCM_PRODUCT_RESULT_H
--                       FP00860 생산 투입 실적 전환 > SCM_PRODUCT_RESULT_H
-- Source System       : DW MES
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_WIP_HISTORY_R
-- Destination Table   : FP_MES_WORK_ORDER_STATUS_H, SCM_PRODUCT_RESULT_H
--
-- Create Date		   : 2016.08.16
-- Update Date         : 2017.04.12 Version 2.1  - PIYONG
-- Author              : 김 석
-- Version             : 1.0
--                     : 20160110 최영태K 요청 XIF_DW_WIP_HISTORY_R 테이블에 ACTQTY추가로 [SCM_MES_WIP_HISTORY_H] 조회 쿼리 수정
-- Version             : 2.0
--                       kimcd. update work order result to mes work order master table.
--                     : 2.1
--                     : SCM_PRODUCT_RESULT_H TABLE LINE_ID  DATA (ANODE, CATHODE) OPTION ADD  
-- ================================================================================================

-- ERP요청 SEQNO
@P_SITE_ID NVARCHAR(50) = 'NULL',
@P_IFSEQNO NVARCHAR(50) = 'NULL'


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_WIP_HISTORY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @v_table     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	--DECLARE @COMPANY     NVARCHAR(1000)


	-- ================================================
    -- Declare end
	-- ================================================
	--Violation of PRIMARY KEY constraint 'PK_FP_MES_WORK_ORDER_STATUS_H'. Cannot insert duplicate key in object 'dbo.FP_MES_WORK_ORDER_STATUS_H'. The duplicate key value is (C100, 81, A001, A040, A1, Nov 19 2016 12:00AM, WK116B03LM00N#1).

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================

		IF @P_IFSEQNO = 'NULL' OR @P_IFSEQNO IS NULL
		   SET @P_IFSEQNO = (SELECT MAX(IFSEQNO) FROM [dbo].[SY_XIF_DW_WIP_HISTORY_R] with(nolock)
							  WHERE TRANSFER_FLAG = 'N'
							)

		UPDATE [dbo].[SY_XIF_DW_WIP_HISTORY_R]
		   SET TRANSFER_FLAG = 'P'
	     WHERE IFSEQNO       = @P_IFSEQNO
		   AND TRANSFER_FLAG = 'N'
		;
		SET @v_table = 'UPDATE [dbo].[SY_XIF_DW_WIP_HISTORY_R]'
		/*
		 * SCM_MES_WIP_HISTORY_H 테이블 MERGE
		 */
		MERGE INTO [dbo].[SCM_MES_WIP_HISTORY_H] A
		USING ( 
		        select *
				  from (
						SELECT   A.LOTID            
								,A.WIPSEQ           
								,A.CALDATE          
								,A.SHIFT            
								,A.PRODID           
								,A.BOMREV           
								,A.ROUTID           
								,A.FLOWID           
								,A.PCSGID           
								,A.PROCID           
								,A.EQSGID           
								,A.EQPTID
								,A.WIPDTTM_ST
								,A.WIPDTTM_ED
								,A.WIPQTY_ED				           
								,A.WOID             
								,A.WIPQTY2_IN       
								,A.WIPQTY2_ST       
								,ISNULL(CASE WHEN COATING_SIDE_TYPE_CODE = 'T' THEN NULL ELSE WIPQTY2_ED END, 0) 
								        + ISNULL(A.CNFM_DFCT_QTY2, 0) + ISNULL(A.CNFM_PRDT_REQ_QTY2, 0) AS WIPQTY2_ED
								,A.WIPQTY2_OT       
								,A.WIP_TYPE_CODE    
								,A.CNFM_DFCT_QTY
								,A.CNFM_LOSS_QTY
								,A.CNFM_PRDT_REQ_QTY
								,A.CNFM_DFCT_QTY2
								,A.CNFM_LOSS_QTY2
								,A.CNFM_PRDT_REQ_QTY2
								,A.WIP_NOTE         
								,A.ERP_TRNF_FLAG    
								,A.WO_DETL_ID       
								,A.SCRAP_QTY
								,ROW_NUMBER() over ( partition by lotid,WIPSEQ order by transfer_date desc) ROWUMBER       
						  FROM   [dbo].[SY_XIF_DW_WIP_HISTORY_R] A
						  WHERE TRANSFER_FLAG = 'P'
						    AND A.WIP_TYPE_CODE IN ( 'INOUT','OUT' )
							AND IFSEQNO       = @P_IFSEQNO
				       )  C
                    where c.ROWUMBER = 1
				) B
		ON (     A.LOTID  = B.LOTID
			 AND A.WIPSEQ = B.WIPSEQ
			)
		WHEN MATCHED THEN
			UPDATE SET   A.CALDATE           = B.CALDATE          
						,A.SHIFT             = B.SHIFT            
						,A.PRODID            = B.PRODID           
						,A.BOMREV            = B.BOMREV           
						,A.ROUTID            = B.ROUTID           
						,A.FLOWID            = B.FLOWID           
						,A.PCSGID            = B.PCSGID           
						,A.PROCID            = B.PROCID           
						,A.EQSGID            = B.EQSGID           
						,A.EQPTID            = B.EQPTID         
						,A.WIPDTTM_ST		 = B.WIPDTTM_ST
						,A.WIPDTTM_ED		 = B.WIPDTTM_ED
						,A.WIPQTY_ED		 = B.WIPQTY_ED						  
						,A.WOID              = B.WOID             
						,A.WIPQTY2_IN        = B.WIPQTY2_IN       
						,A.WIPQTY2_ST        = B.WIPQTY2_ST       
						,A.WIPQTY2_ED        = B.WIPQTY2_ED       
						,A.WIPQTY2_OT        = B.WIPQTY2_OT       
						,A.WIP_TYPE_CODE     = B.WIP_TYPE_CODE    
						,A.CNFM_DFCT_QTY     = B.CNFM_DFCT_QTY    
						,A.CNFM_LOSS_QTY     = B.CNFM_LOSS_QTY    
						,A.CNFM_PRDT_REQ_QTY = B.CNFM_PRDT_REQ_QTY
						,A.CNFM_DFCT_QTY2     = B.CNFM_DFCT_QTY2    
						,A.CNFM_LOSS_QTY2     = B.CNFM_LOSS_QTY2   
						,A.CNFM_PRDT_REQ_QTY2 = B.CNFM_PRDT_REQ_QTY2
						,A.WIP_NOTE          = B.WIP_NOTE         
						,A.ERP_TRNF_FLAG     = B.ERP_TRNF_FLAG    
						,A.WO_DETL_ID        = B.WO_DETL_ID       
						,A.SCRAP_QTY         = B.SCRAP_QTY 
					    ,A.MODIFY_USER_ID    = 'PR_XIF_DW_WIP_HISTORY_R'
					    ,A.MODIFY_DATE       = GETDATE()
					                
		WHEN NOT MATCHED THEN
			INSERT (  LOTID            
                     ,WIPSEQ           
                     ,CALDATE          
                     ,SHIFT            
                     ,PRODID           
                     ,BOMREV           
                     ,ROUTID           
                     ,FLOWID           
                     ,PCSGID           
                     ,PROCID           
                     ,EQSGID           
                     ,EQPTID    
					 ,WIPDTTM_ST
					 ,WIPDTTM_ED
					 ,WIPQTY_ED				        
                     ,WOID             
                     ,WIPQTY2_IN       
                     ,WIPQTY2_ST       
                     ,WIPQTY2_ED       
                     ,WIPQTY2_OT       
                     ,WIP_TYPE_CODE    
                     ,CNFM_DFCT_QTY    
                     ,CNFM_LOSS_QTY    
                     ,CNFM_PRDT_REQ_QTY
					 ,CNFM_DFCT_QTY2
					 ,CNFM_LOSS_QTY2
					 ,CNFM_PRDT_REQ_QTY2
                     ,WIP_NOTE         
                     ,ERP_TRNF_FLAG    
                     ,WO_DETL_ID       
					 ,SCRAP_QTY
				     ,CREATE_USER_ID
				     ,CREATE_DATE
				     ,MODIFY_USER_ID
				     ,MODIFY_DATE
					)
			VALUES ( B.LOTID            
					,B.WIPSEQ           
					,B.CALDATE          
					,B.SHIFT            
					,B.PRODID           
					,B.BOMREV           
					,B.ROUTID           
					,B.FLOWID           
					,B.PCSGID           
					,B.PROCID           
					,B.EQSGID           
					,B.EQPTID    
					,B.WIPDTTM_ST
					,B.WIPDTTM_ED
					,B.WIPQTY_ED					       
					,B.WOID             
					,B.WIPQTY2_IN       
					,B.WIPQTY2_ST       
					,B.WIPQTY2_ED       
					,B.WIPQTY2_OT       
					,B.WIP_TYPE_CODE    
					,B.CNFM_DFCT_QTY    
					,B.CNFM_LOSS_QTY    
					,B.CNFM_PRDT_REQ_QTY
					,B.CNFM_DFCT_QTY2
					,B.CNFM_LOSS_QTY2
					,B.CNFM_PRDT_REQ_QTY2
					,B.WIP_NOTE         
					,B.ERP_TRNF_FLAG    
					,B.WO_DETL_ID       
					,B.SCRAP_QTY
				    ,'PR_XIF_DW_WIP_HISTORY_R'
				    ,GETDATE()
				    ,'PR_XIF_DW_WIP_HISTORY_R'
				    ,GETDATE()
					)
		;

		SET @ROWCOUNT = @@ROWCOUNT
		SET @v_table = 'MERGE INTO [dbo].[SCM_MES_WIP_HISTORY_H]'
		
		/*
		 * FP_MES_WORK_ORDER_STATUS_H 테이블 INSERT
		 */
		IF @ROWCOUNT > 0
			
			BEGIN
			
				DECLARE @INSTANCE_ID NVARCHAR(100)

				DECLARE CUR_INSTANCE_ID CURSOR FOR
						SELECT INSTANCE_ID
						  FROM (
								SELECT DISTINCT SITE_ID, 
									  ( 
									   SELECT DISTINCT B.INSTANCE_ID
										 FROM DBO.SCM_OPERATION_M C
											 ,DBO.FP_INSTANCE_FACTORY_M B
										WHERE C.INSTANCE_TYPE = B.INSTANCE_TYPE
										  AND C.OPERATION_ID  = A.OPERATION_ID    
										  AND C.DIVISION_ID = A.DIVISION_ID
										  AND B.FACTORY_ID = A.FACTORY_ID 
										  AND C.SITE_ID = A.SITE_ID
									  ) AS INSTANCE_ID
								  FROM DBO.SCM_EQUIPMENT_M A with(nolock)
								 WHERE OPERATION_ID <> '*'
							   ) A
						WHERE A.INSTANCE_ID IS NOT NULL
						  AND A.SITE_ID = ISNULL(@P_SITE_ID, A.SITE_ID)
						;


			    OPEN CUR_INSTANCE_ID;
			    FETCH NEXT FROM CUR_INSTANCE_ID INTO @INSTANCE_ID
			    ;

				--SELECT * FROM [dbo].[FP_MES_WORK_ORDER_STATUS_H]
			    DELETE FROM [dbo].[FP_MES_WORK_ORDER_STATUS_H]
				 WHERE CUTOFF_DATE = CAST(GETDATE() AS DATE)
				   AND SITE_ID     = case when @P_SITE_ID = 'NULL' or @P_SITE_ID is null then SITE_ID else @P_SITE_ID end    
				   AND [INSERT_ID] = @INSTANCE_ID
			    ;

			    WHILE (@@FETCH_STATUS = 0)
			       
				    BEGIN

						INSERT INTO [dbo].[FP_MES_WORK_ORDER_STATUS_H]
								   ([COMPANY_ID]
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
								   ,[PLAN_QTY]
								   ,[ACTUAL_START_TIME]
								   ,[ACTUAL_END_TIME]
								   ,[ACTUAL_QTY]
								   ,[ACTUAL_GOOD_QTY]
								   ,[ACTUAL_SCRAP_QTY]
								   ,[RUNNING_FLAG]
								   ,[WO_STATUS]
								   ,[INSERT_ID]
								   ,[INSERT_TIME])
							--DECLARE @INSTANCE_ID NVARCHAR(100) = 'KR_ASSY'
							--DECLARE @P_IFSEQNO NVARCHAR(100) = '20161213120333'
							SELECT A.COMPANY_ID
							      ,A.DIVISION_ID
								  ,A.SITE_ID
								  ,A.PLANT_ID
								  ,A.FACTORY_ID
								  ,A.CUTOFF_DATE
								  ,A.WORK_ORDER_SPL_ID
								  ,MAX(A.WORK_ORDER_ID) AS WORK_ORDER_ID
								  ,MAX(A.DEMAND_ID) AS DEMAND_ID
								  ,MAX(A.PRODUCTION_TYPE) AS PRODUCTION_TYPE
								  ,MAX(A.ORDER_TYPE) AS ORDER_TYPE
							      ,MAX(A.ITEM_ID) AS ITEM_ID
								  ,'-' AS TOP_ITEM_ID
								  ,MAX(A.OPERATION_ID) AS OPERATION_ID
								  ,MAX(A.LINE_ID) AS LINE_ID
								  ,'-' AS WORK_CENTER_ID
								  ,MAX(A.EQUIPMENT_ID) AS EQUIPMENT_ID
								  ,MAX(A.PLAN_DATE) AS PLAN_DATE
								  ,MAX(A.PLAN_START_TIME) AS PLAN_START_TIME
								  ,MAX(A.PLAN_END_TIME) AS PLAN_END_TIME
								  ,SUM(CAST(A.PLAN_QTY AS NUMERIC(14,4))) AS PLAN_QTY -- out_qty
							      ,CAST('1900-01-01' AS DATETIME) AS ACTUAL_START_TIME
								  ,NULL AS ACTUAL_END_TIME				                                                                                                                                           
								  ,0 AS ACTUAL_QTY                                                                                                                                              
								  ,NULL AS ACTUAL_GOOD_QTY                                                                                                                         
								  ,NULL AS ACTUAL_SCRAP_QTY                                                                                                                        
								  ,'-' AS RUNNING_FLAG                                                                                                                                                         
								  ,'-' AS WO_STATUS                                                                                                                                                            
								--  ,'PR_XIF_DW_WIP_HISTORY_R' AS INSERT_ID                                                                                                                                      
								  ,@INSTANCE_ID  AS INSERT_ID                                                                                                                                      
								  ,GETDATE()     AS INSERT_TIME
							  FROM (
									SELECT  --A.PLAN_ID,
											 (SELECT TOP 1 COMPANY_ID
												FROM [dbo].[SCM_PLANT_M] with(nolock)
												WHERE PLANT_ID = A.PLANT_ID
											) AS COMPANY_ID
											,(SELECT TOP 1 DIVISION_ID
												FROM [dbo].[SCM_PLANT_M] with(nolock)
												WHERE PLANT_ID = A.PLANT_ID
											) AS DIVISION_ID
											,(SELECT TOP 1 SITE_ID
												FROM [dbo].[SCM_PLANT_M] with(nolock)
												WHERE PLANT_ID = A.PLANT_ID
											) AS SITE_ID                                                                                                                                                             
											,A.PLANT_ID                                                                                                                                                               
											,A.BUILNO AS FACTORY_ID
											,CAST(GETDATE() AS DATE) AS CUTOFF_DATE                                                                                                                          
											,A.WO_DETAIL AS WORK_ORDER_SPL_ID                                                                                                                                           
											,A.WO AS WORK_ORDER_ID    
										    ,A.DEMAND_ID                                                                                                                                                            
										    ,A.WO_TYPE AS PRODUCTION_TYPE                                                                                                                                                      
										    ,A.ORDER_TYPE											                                                                                  
											,A.ITEM_ID                                                                                                                                     
											,A.OPERATION_ID AS OPERATION_ID                                                                                                                                                    
											,A.LINE_ID AS LINE_ID                                                                                                                               
											,A.EQUIPMENT_ID AS EQUIPMENT_ID                                                                                                                                       
											,A.PLAN_DATE
											,A.START_TIME AS PLAN_START_TIME                                                                                                                                                
											,A.END_TIME AS PLAN_END_TIME
											,A.IN_QTY AS PLAN_QTY
										FROM [dbo].[SY_XIF_MES_WO_S] A with(nolock)
										--SELECT * FROM [LGCE_INF].[DBO].[XIF_MES_WO_S]
									   WHERE A.PLAN_ID = (
															/* blocked by kimcd  2017-04-09 released per factory
															select top 1 plan_id
															  from SCM_FP_PLAN_H w
															 where PLAN_TYPE = 'RELEASE'
															   and INSTANCE_ID = @INSTANCE_ID
															 order by  ROW_NUMBER() over ( partition by INSTANCE_ID order by release_time desc ) */
															 -- kimcd add 2017-04-09
															 select top 1 d.release_plan_id
															  from SCM_FP_PLAN_H        w WITH(NOLOCK)
															      ,SCM_FP_PLAN_DETAIL_H d WITH(NOLOCK)
															 where w.plan_id =d.release_plan_id
															   and w.PLAN_TYPE = 'RELEASE'
															   and w.INSTANCE_ID = @INSTANCE_ID
															   and d.factory_id = a.BUILNO
															   order by d.release_time desc
									                      /* - 여러번 Release가 가능하고 이 경우 seq가 98 97로 줄어서 변경 처리 함.
									                      SELECT MAX(PLAN_ID) AS PLAN_ID FROM [dbo].[SY_XIF_MES_WO_S] with(nolock)
														   WHERE PLAN_ID LIKE @INSTANCE_ID + '%99'
														  */
														 )
										 AND A.UPDATE_DATE > CAST('20161209' AS DATE) /* 1209 이전 데이터는 문제가있어 우선 추가 */
										 AND A.IS_RELEASE = 'Y'
										 AND A.IF_FLAG = 'Y'
										 AND A.IF_ID  != 'OFP0_OPLM_FP_WO' -- kimcd add 2017-04-10
							       ) A
                               WHERE A.SITE_ID = case when @P_SITE_ID = 'NULL' or @P_SITE_ID is null then A.SITE_ID else @P_SITE_ID end   
							GROUP BY A.COMPANY_ID
							        ,A.DIVISION_ID
									,A.SITE_ID
									,A.PLANT_ID
									,A.FACTORY_ID
									,A.CUTOFF_DATE
									,A.WORK_ORDER_SPL_ID

							   ;

						FETCH NEXT FROM CUR_INSTANCE_ID INTO @INSTANCE_ID
						;



				    END

				SET @v_table = 'INSERT INTO [dbo].[FP_MES_WORK_ORDER_STATUS_H]'

			    CLOSE CUR_INSTANCE_ID;
		        DEALLOCATE CUR_INSTANCE_ID;

				--SELECT DISTINCT IFSEQNO FROM  [LGCE_INF].[DBO].[XIF_DW_WIP_HISTORY_R]
				--SELECT * FROM  [LGCE_INF].[DBO].[XIF_DW_WIP_HISTORY_R]
				--UPDATE [LGCE_INF].[DBO].[XIF_DW_WIP_HISTORY_R] SET TRANSFER_FLAG = 'N' WHERE IFSEQNO = '20161214120333'
				--SELECT * FROM  [LGCE_INF].[DBO].[XIF_DW_WIP_HISTORY_R] WHERE IFSEQNO = '20161212120333' AND WO_DETL_ID IS NOT NULL
				--DELETE FROM [LGCE_INFDEV].[DBO].[XIF_DW_WIP_HISTORY_R] WHERE IFSEQNO = '20161212112329'
				--DELETE FROM [LGCE_FPDEV_TR].[dbo].[SCM_MES_WIP_HISTORY_H]
				--DELETE FROM [dbo].[SCM_PRODUCT_RESULT_H]
				--SELECT * FROM [dbo].[SCM_MES_WIP_HISTORY_H]
				--SELECT * FROM [dbo].[FP_MES_WORK_ORDER_STATUS_H] WHERE CAST(INSERT_TIME AS DATE) = '2016-12-20'
				--SELECT * FROM [dbo].[SCM_PRODUCT_RESULT_H] ORDER BY UPDATE_TIME DESC				


				/*
				 * FP_MES_WORK_ORDER_STATUS_H 테이블 UPDATE
				 */
				UPDATE [DBO].[FP_MES_WORK_ORDER_STATUS_H] 
				   SET ACTUAL_START_TIME = ISNULL(B.ACTUAL_START_TIME,	CAST('1900-01-01' AS DATETIME))
				      ,ACTUAL_END_TIME	 = ISNULL(B.ACTUAL_END_TIME,	CAST('1900-01-01' AS DATETIME))
				      ,ACTUAL_QTY		 = ISNULL(B.ACTUAL_QTY, 0)
				      ,ACTUAL_GOOD_QTY   = ISNULL(B.ACTUAL_GOOD_QTY, 0)
				      ,ACTUAL_SCRAP_QTY	 = ISNULL(B.ACTUAL_SCRAP_QTY, 0)
					  ,WO_STATUS         = CASE WHEN ISNULL(A.PLAN_QTY, 0) < ISNULL(B.ACTUAL_QTY, 0) THEN 'CLOSE'
					                       ELSE 'OPEN'
										    END
				FROM [DBO].[FP_MES_WORK_ORDER_STATUS_H] A LEFT OUTER JOIN (
											SELECT
													  A.WOID
													, A.WO_DETL_ID
													, A.PRODID
													, MAX(CONVERT(NVARCHAR, MODIFY_DATE, 112))														AS MODIFY_DATE
													, CAST(MAX(A.[CALDATE]) AS DATETIME)															AS CUTOFF_DATE
													, MAX(CAST(A.WIPDTTM_ST  AS DATETIME))															AS ACTUAL_START_TIME
													, MAX(CAST(A.WIPDTTM_ED  AS DATETIME))															AS ACTUAL_END_TIME
													, SUM(A.WIPQTY2_ED)																				AS ACTUAL_QTY
													-- 이 부분 로직 확인 필요 함.
													, SUM(A.WIPQTY2_ED) - SUM(ISNULL(CONVERT(FLOAT,CNFM_DFCT_QTY2),0)) 
																	   - SUM(ISNULL(CONVERT(FLOAT,CNFM_LOSS_QTY2),0)) 
																	   - SUM(ISNULL(CONVERT(FLOAT,CNFM_PRDT_REQ_QTY2),0))                   
		   															   - SUM(ISNULL(CAST(A.SCRAP_QTY AS NUMERIC),0))								AS ACTUAL_GOOD_QTY
													, SUM(ISNULL(CONVERT(FLOAT,CNFM_DFCT_QTY2),0))  + SUM(ISNULL(CONVERT(FLOAT,CNFM_LOSS_QTY2),0)) 
																								 + SUM(ISNULL(CONVERT(FLOAT,CNFM_PRDT_REQ_QTY2),0))
		   																						 + SUM(ISNULL(CAST(A.SCRAP_QTY AS NUMERIC),0))		AS ACTUAL_SCRAP_QTY
											FROM [DBO].[SCM_MES_WIP_HISTORY_H] A with(nolock),
											     (SELECT DISTINCT WORK_ORDER_ID,
												         WORK_ORDER_SPL_ID,
														 ITEM_ID
												    FROM [DBO].[FP_MES_WORK_ORDER_STATUS_H] A with(nolock)
												   WHERE A.CUTOFF_DATE = CAST(GETDATE() AS DATE)
												     AND A.SITE_ID = case when @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL  then A.SITE_ID else @P_SITE_ID end   
												 ) B
										   WHERE A.WOID        = B.WORK_ORDER_ID
										     AND A.WO_DETL_ID  = B.WORK_ORDER_SPL_ID
											 AND A.PRODID      = B.ITEM_ID									
											GROUP BY A.WOID, A.WO_DETL_ID, A.PRODID
										) B
						ON  A.WORK_ORDER_ID      = B.WOID
						AND A.WORK_ORDER_SPL_ID  = B.WO_DETL_ID    
						AND A.ITEM_ID            = B.PRODID
				WHERE A.CUTOFF_DATE = CAST(GETDATE() AS DATE)
				  AND A.SITE_ID = case when @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL  then A.SITE_ID else @P_SITE_ID end   
				;

				SET @v_table = 'UPDATE [DBO].[FP_MES_WORK_ORDER_STATUS_H] '

				--SELECT * FROM [dbo].[SCM_PRODUCT_RESULT_H]
				DELETE FROM [dbo].[SCM_PRODUCT_RESULT_H]
				 WHERE CUTOFF_DATE = CAST(GETDATE() AS DATE)
				   AND INSERT_ID   = 'PR_XIF_DW_WIP_HISTORY_R'
				   AND SITE_ID     = case when @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL then SITE_ID else @P_SITE_ID end   
				;
				SET @v_table = 'DELETE FROM [dbo].[SCM_PRODUCT_RESULT_H]'
				INSERT INTO [dbo].[SCM_PRODUCT_RESULT_H]
						   ([COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[CUTOFF_DATE]
						   ,[SEQ]
						   ,[ITEM_ID]
						   ,[OPERATION_ID]
						   ,[LINE_ID]
						   ,[WORK_CENTER_ID]
						   ,[QTY]
						   ,[QTY_LANE]
						   ,[PRODUCT_DATE]
						   ,[PRODUCTION_TYPE]
						   ,[DESCRIPTION]
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME])
					--DECLARE @P_SITE_ID VARCHAR(50) = 'A001'
					 SELECT COMPANY_ID                                                                                                                                           
							,DIVISION_ID                                                                                                                                       
							,SITE_ID                                                                                                                                               
							,PLANT_ID                                                                                                                                          
							,FACTORY_ID
							,CUTOFF_DATE
							,ROW_NUMBER() OVER( ORDER BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PRODUCT_DATE) AS SEQ
							,ITEM_ID
							,OPERATION_ID  
							,LINE_ID 
							,WORK_CENTER_ID                                                                                                                         
							,QTY
							,QTY_LANE                                                                                                                                                  
							,PRODUCT_DATE
							,PRODUCTION_TYPE
							,DESCRIPTION
							,INSERT_ID
							,INSERT_TIME
							,UPDATE_ID
							,UPDATE_TIME	        
					   FROM (SELECT ISNULL(L.COMPANY_ID, C.COMPANY_ID)  AS  COMPANY_ID                                                                                                                                           
									,ISNULL(L.DIVISION_ID, C.DIVISION_ID)  AS DIVISION_ID                                                                                                                                       
									,ISNULL(L.SITE_ID, C.SITE_ID) AS SITE_ID                                                                                                                                               
									,ISNULL(L.PLANT_ID, C.PLANT_ID) AS PLANT_ID                                                                                                                                          
									,ISNULL(L.FACTORY_ID, C.FACTORY_ID) AS FACTORY_ID
									,CAST(GETDATE() AS DATE) AS CUTOFF_DATE
									,PRODID AS ITEM_ID
									,PROCID AS OPERATION_ID  
									,ISNULL(L.LINE_ID, CASE WHEN (CASE WHEN U.PROCID IN ( 'E1000','E2000','E2300','E2500','E3000','E8000','E4000', 'A5000' ,'A6000' ) THEN 
															  CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'ANODE'
																							  WHEN 'C' THEN 'CATHODE'
																							   ELSE '-' END
															WHEN U.PROCID IN ('A7000', 'E3800', 'E3900') THEN 
																	  CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'A'
																									  WHEN 'C' THEN 'C'
																									   ELSE '-' END
															WHEN U.PROCID = 'E2100' THEN
																	  CASE WHEN SUBSTRING(C.MES_LINE_ID,1,2) IN ('E1', 'E4') THEN 
																			 CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'Anode'
																											 WHEN 'C' THEN 'Cathode'
																											  ELSE '-' END
																		   ELSE
																			 CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'A'
																											 WHEN 'C' THEN 'C'
																											  ELSE '-' END
																			END
												
															ELSE '-' END) = C.ELECTRODE_TYPE THEN
																C.LINE_ID
														ELSE '-'
													END
												) AS LINE_ID					--2017-04-12 변경
									,L.WORK_CENTER_ID                                                                                                                         
									,SUM(WIPQTY_ED) AS QTY
									,SUM(WIPQTY2_ED) AS QTY_LANE                                                                                                                                                  
									,CAST(CALDATE AS DATETIME) AS PRODUCT_DATE
									,U.PRODUCTION_TYPE
									,NULL DESCRIPTION
									,'PR_XIF_DW_WIP_HISTORY_R' AS INSERT_ID
									,GETDATE() AS INSERT_TIME
									,'PR_XIF_DW_WIP_HISTORY_R' AS UPDATE_ID
									,GETDATE() AS UPDATE_TIME	                                                                                                                                            
							   FROM (SELECT CALDATE                                                                                                                                                  
											,PRODID                                                                                                                                                   
											,EQSGID                                                                                                                                                   
											,PROCID
											,W.EQPTID                                                                                                                                                   
											,WIPQTY_ED
											,WIPQTY2_ED
											/*
											,(SELECT DISTINCT EQ.WORK_CENTER_ID                                                                                                                                
												FROM LGCE_FP_TR.[DBO].[SCM_EQUIPMENT_M] EQ with(nolock)                                                                                                         
											   WHERE EQ.EQUIPMENT_ID = W.EQPTID  ) WORK_CENTER_ID
                                             */
											,(SELECT TOP 1 A.PRODUCTION_TYPE                                                                                                                       
												FROM [DBO].[FP_PRODUCTION_PLAN_R] A with(nolock)                                                                                                  
											    WHERE A.WORK_ORDER_ID = W.WOID
												  AND A.PRODUCTION_TYPE IS NOT NULL
												  ORDER BY FP_PLAN_ID  ) PRODUCTION_TYPE --PRODUCTION_TYPE WO를 연결해서 WO의 PRODUCTION TYPE을 구함.                                                                                    
									    FROM [dbo].[SCM_MES_WIP_HISTORY_H] W with(nolock)                                                                                                                  
									   WHERE CAST(CALDATE AS DATE) >= CAST(DATEADD(DD,-7, GETDATE()) AS DATE)
										 AND W.WIP_TYPE_CODE IN ( 'INOUT','OUT' )
										 AND W.WIPQTY_ED > 0
									) U                                                                                                                                                     
						      left outer JOIN [DBO].[SCM_EQUIPMENT_M] L WITH(NOLOCK) 
								   ON U.EQPTID  = L.EQUIPMENT_ID
								   and substring(L.MES_LINE_ID,1,2)  =  L.FACTORY_ID -- 남경에 전극 설비가 planning을 위해서 여러 building에 속해져 있음.
								   and u.procid = l.OPERATION_ID  -- 하나의 설비가 여러 공정에 속할 수 있다고 함.
                              -- 설비가 우리쪽에 없는 case에 대해서 company,division을 찾기 위함.
							  left outer JOIN (SELECT A.COMPANY_ID
												      , A.DIVISION_ID
												      , A.SITE_ID
												      , A.PLANT_ID
												      , A.FACTORY_ID
												      , A.OPERATION_ID
													  , A.MES_LINE_ID
													  , MAX( A.LINE_ID) AS LINE_ID
													  , A.ELECTRODE_TYPE		--2017-04-12 추가
										         FROM [DBO].SCM_EQUIPMENT_M A WITH(NOLOCK) 
										        GROUP BY A.COMPANY_ID
												      , A.DIVISION_ID
												      , A.SITE_ID
												      , A.PLANT_ID
												      , A.FACTORY_ID
												      , A.OPERATION_ID
													  , A.MES_LINE_ID
													  , A.ELECTRODE_TYPE
											) C
							             ON U.EQSGID =  C.MES_LINE_ID
								        AND U.PROCID = C.OPERATION_ID
								        AND SUBSTRING(C.MES_LINE_ID,1,2)  =  L.FACTORY_ID
								 WHERE U.CALDATE IS NOT NULL
			 					   AND C.SITE_ID = case when @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL then C.SITE_ID else @P_SITE_ID end   
								 GROUP BY ISNULL(L.COMPANY_ID, C.COMPANY_ID)                                                                                                                                             
									   ,ISNULL(L.DIVISION_ID, C.DIVISION_ID)                                                                                                                                         
									   ,ISNULL(L.SITE_ID, C.SITE_ID)                                                                                                                                                
									   ,ISNULL(L.PLANT_ID, C.PLANT_ID)                                                                                                                                           
									   ,ISNULL(L.FACTORY_ID, C.FACTORY_ID)
									   ,CALDATE                                                                                                                                                 
									   ,PRODID                                                                                                                                                  
									   ,PROCID
									   ,ISNULL(L.LINE_ID, CASE WHEN (CASE WHEN U.PROCID IN ( 'E1000','E2000','E2300','E2500','E3000','E8000','E4000', 'A5000' ,'A6000' ) THEN 
																  CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'ANODE'
																								  WHEN 'C' THEN 'CATHODE'
																								   ELSE '-' END
																WHEN U.PROCID IN ('A7000', 'E3800', 'E3900') THEN 
																		  CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'A'
																										  WHEN 'C' THEN 'C'
																										   ELSE '-' END
																WHEN U.PROCID = 'E2100' THEN
																		  CASE WHEN SUBSTRING(C.MES_LINE_ID,1,2) IN ('E1', 'E4') THEN 
																				 CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'Anode'
																												 WHEN 'C' THEN 'Cathode'
																												  ELSE '-' END
																			   ELSE
																				 CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'A'
																												 WHEN 'C' THEN 'C'
																												  ELSE '-' END
																				END
												
																ELSE '-' END) = C.ELECTRODE_TYPE THEN
																	C.LINE_ID
															ELSE '-'
														END
													)																--2017-04-12 변경                                                                                                                                        
			  						   ,l.WORK_CENTER_ID                                                                                                                                          
									   ,PRODUCTION_TYPE
							)A
				;



			END

		SET @ROWCOUNT = @@ROWCOUNT

		--------------------------------------------------------------------------------------------------------------------------------------------------------
		-- kimcd start add 2017-04-09 -- add production result to mes work order master

				UPDATE A
				   SET ACTUAL_QTY		 = ISNULL(B.ACTUAL_QTY, 0)
				      ,ACTUAL_GOOD_QTY   = ISNULL(B.ACTUAL_GOOD_QTY, 0)
				      ,ACTUAL_SCRAP_QTY	 = ISNULL(B.ACTUAL_SCRAP_QTY, 0)
					  ,WO_STATUS         = CASE WHEN ISNULL(A.PLAN_QTY, 0) < ISNULL(B.ACTUAL_QTY, 0) THEN 'CLOSE'
					                       ELSE 'OPEN'
										   END
					  ,UPDATE_ID         = 'PR_XIF_DW_WIP_HISTORY_R'
					  ,UPDATE_TIME       = GETDATE()
				FROM [DBO].[FP_MES_PRODUCTION_PLAN_M] A 
					,( SELECT A.WOID
							, A.WO_DETL_ID
							, A.PRODID
							, MAX(CONVERT(NVARCHAR, MODIFY_DATE, 112))														AS MODIFY_DATE
							, CAST(MAX(A.[CALDATE]) AS DATETIME)															AS CUTOFF_DATE
							, MAX(CAST(A.WIPDTTM_ST  AS DATETIME))															AS ACTUAL_START_TIME
							, MAX(CAST(A.WIPDTTM_ED  AS DATETIME))															AS ACTUAL_END_TIME
							, SUM(A.WIPQTY2_ED)																				AS ACTUAL_QTY
							-- 이 부분 로직 확인 필요 함.
							, SUM(A.WIPQTY2_ED) - SUM(ISNULL(CONVERT(FLOAT,CNFM_DFCT_QTY2),0)) 
												- SUM(ISNULL(CONVERT(FLOAT,CNFM_LOSS_QTY2),0)) 
												- SUM(ISNULL(CONVERT(FLOAT,CNFM_PRDT_REQ_QTY2),0))                   
		   										- SUM(ISNULL(CAST(A.SCRAP_QTY AS NUMERIC),0))								AS ACTUAL_GOOD_QTY
							, SUM(ISNULL(CONVERT(FLOAT,CNFM_DFCT_QTY2),0))  + SUM(ISNULL(CONVERT(FLOAT,CNFM_LOSS_QTY2),0)) 
																			+ SUM(ISNULL(CONVERT(FLOAT,CNFM_PRDT_REQ_QTY2),0))
		   																	+ SUM(ISNULL(CAST(A.SCRAP_QTY AS NUMERIC),0))		AS ACTUAL_SCRAP_QTY
					FROM [DBO].[SCM_MES_WIP_HISTORY_H] A with(nolock),
							(SELECT A.WOID             
								,A.WO_DETL_ID
								,A.PRODID
							FROM   [dbo].[SY_XIF_DW_WIP_HISTORY_R] A with(nolock)
							WHERE TRANSFER_FLAG = 'P'
							AND A.WIP_TYPE_CODE IN ( 'INOUT','OUT' )
							AND IFSEQNO       = @P_IFSEQNO
							GROUP BY A.WOID, A.WO_DETL_ID, A.PRODID
							) B
					WHERE A.WOID        = B.WOID
						AND A.WO_DETL_ID  = B.WO_DETL_ID
						AND A.PRODID      = B.PRODID
					GROUP BY A.WOID, A.WO_DETL_ID, A.PRODID
				) B
			  WHERE A.WORK_ORDER_ID      = B.WOID
				AND A.WORK_ORDER_SPL_ID  = B.WO_DETL_ID    
				AND A.ITEM_ID            = B.PRODID
				AND A.SITE_ID = case when @P_SITE_ID = 'NULL' OR @P_SITE_ID IS NULL  then A.SITE_ID else @P_SITE_ID end   
		-- kimcd start end 2017-04-09 -- add production result to mes work order master
		--------------------------------------------------------------------------------------------------------------------------------------------------------

		SET @v_table = 'INSERT INTO [dbo].[SCM_PRODUCT_RESULT_H]'
	
		UPDATE [dbo].[SY_XIF_DW_WIP_HISTORY_R]
		   SET TRANSFER_FLAG = 'Y'
			  ,TRANSFER_DATE = GETDATE()
	     WHERE IFSEQNO       = @P_IFSEQNO
		   AND TRANSFER_FLAG = 'P'
		;

		SET @v_table = 'UPDATE [dbo].[SY_XIF_DW_WIP_HISTORY_R]'

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, @v_table, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, @v_table, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END


