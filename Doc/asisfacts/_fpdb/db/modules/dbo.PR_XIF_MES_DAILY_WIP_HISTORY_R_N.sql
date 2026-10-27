

CREATE PROCEDURE [dbo].[PR_XIF_MES_DAILY_WIP_HISTORY_R_N]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_MES_WIP_HISTORY_R
-- Param               :
-- Batch Period        : 1Day
-- Description         : FP00780 실행 Work Order 전환
--                       FP00830 생산 완료 실적 전환 > SCM_PRODUCT_RESULT_H
--                       FP00860 생산 투입 실적 전환 > SCM_PRODUCT_RESULT_H
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_WIP_HISTORY_R
-- Destination Table   : FP_MES_WORK_ORDER_STATUS_H, SCM_PRODUCT_RESULT_H
--
-- Create(Update) Date : 2017.04.11
-- Author              : PIYONG
-- Version             : 1.0


-- ================================================================================================


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'
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
	DECLARE @IF_ID        NVARCHAR(50)
	DECLARE @ACCUM_DATE   NVARCHAR(8)
	DECLARE @SITE_ID      NVARCHAR(50)

	DECLARE CUR_IF_MES_WIPHIST CURSOR FOR
				SELECT IF_ID, ACCUM_DATE, ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID
				FROM [SY_XIF_MES_DAILY_WIP_HISTORY_R]
				WHERE 1=1
			--	  and PROC_FLAG = 'N'
				  and ACCUM_DATE = '201704X4'                       -- test용
			--	  and ACCUM_DATE in ( '20170416','20170417' )       -- test용
				GROUP BY IF_ID, ACCUM_DATE
				HAVING COUNT(1) = MAX(ACCUM_COUNT) -- 전체를 수신받지 못한 경우에는 처리하지 않음.
				ORDER BY IF_ID, ACCUM_DATE


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

		  -- SITE 정보 추가
		  OPEN CUR_IF_MES_WIPHIST;
		  FETCH NEXT FROM CUR_IF_MES_WIPHIST INTO  @IF_ID        
												  ,@ACCUM_DATE
												  ,@SITE_ID
												  ;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
	

				MERGE INTO [dbo].[SCM_MES_WIP_HISTORY_H_N] A
				USING ( SELECT *
						  FROM (
						  
								 SELECT A.LOTID            
									   ,ISNULL(A.WIPSEQ, '1') WIPSEQ
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
									   ,A.WIPQTY2_ED
									   ,A.COATING_SIDE_TYPE_CODE  -- 추가
									   -- 양면 coating을 하는 경우에 Top과 Back의 LOT ID가 다르게 채번됨.
									   -- 양품 수량은 Back 기준으로 하면되나 Loss나 Dfct 같은 경우에는 top back을 더해야 함.
									   -- 단면 모델인 경우에는 top 수량을 생산실적으로 넣어야 함. 
									   ,ISNULL(CASE WHEN COATING_SIDE_TYPE_CODE = 'T' AND (select count(1) from scm_item_m w where w.item_id = A.PRODID  and w.item_class_level_3 = 'CS') = 0 THEN NULL ELSE WIPQTY2_ED END, 0) 
												+ ISNULL(A.CNFM_DFCT_QTY2, 0) + ISNULL(A.CNFM_PRDT_REQ_QTY2, 0) + ISNULL(A.CNFM_LOSS_QTY2, 0)  AS WIPQTY2_ENGINE -- 추가
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
									   ,( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID   -- 추가
									   ,ROW_NUMBER() over ( partition by lotid,WIPSEQ order by transfer_date desc) ROWUMBER       
								  FROM [dbo].[SY_XIF_MES_DAILY_WIP_HISTORY_R] A
								 WHERE A.WIP_TYPE_CODE IN ( 'INOUT','OUT' )
								   AND IF_ID       = @IF_ID
								   AND accum_date  = @ACCUM_DATE


							   )  C
						 WHERE C.ROWUMBER = 1
						) B
				 ON (    A.LOTID  = B.LOTID
					 AND A.WIPSEQ = B.WIPSEQ )
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
								,A.WIP_NOTE               = B.WIP_NOTE         
								,A.ERP_TRNF_FLAG          = B.ERP_TRNF_FLAG    
								,A.WO_DETL_ID             = B.WO_DETL_ID       
								,A.SCRAP_QTY              = B.SCRAP_QTY 
								,A.MODIFY_USER_ID         = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'
								,A.MODIFY_DATE            = GETDATE()
								,A.COATING_SIDE_TYPE_CODE = B.COATING_SIDE_TYPE_CODE    -- 추가
								,A.WIPQTY2_ENGINE         = B.WIPQTY2_ENGINE            -- 추가
								,A.attribute1             = B.SITE_ID                   -- 추가
					                
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
							 ,COATING_SIDE_TYPE_CODE       -- 추가
							 ,WIPQTY2_ENGINE               -- 추가
							 ,ATTRIBUTE1                   -- 추가
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
							,'PR_XIF_MES_DAILY_WIP_HISTORY_R'
							,GETDATE()
							,'PR_XIF_MES_DAILY_WIP_HISTORY_R'
							,GETDATE()
							,B.COATING_SIDE_TYPE_CODE  -- 추가
							,B.WIPQTY2_ENGINE          -- 추가
							,B.SITE_ID                 -- 추가
							)
				;

				-- [SCM_PRODUCT_RESULT_H] 에 data inesrt
				-- 기존 data 삭제 처리 
				DELETE FROM [dbo].[SCM_PRODUCT_RESULT_H_N]
				 WHERE CUTOFF_DATE = CAST(GETDATE() AS DATE)
				   AND INSERT_ID   = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'
				   AND SITE_ID     = @SITE_ID
				;

				SET @v_table = 'DELETE FROM [dbo].[SCM_PRODUCT_RESULT_H]'
				INSERT INTO [dbo].[SCM_PRODUCT_RESULT_H_N]
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
						   ,WIPQTY2_ENGINE        -- 추가
						   ,CNFM_DFCT_QTY2        -- 추가
						   ,CNFM_LOSS_QTY2        -- 추가
						   ,CNFM_PRDT_REQ_QTY2    -- 추가 
						   ,TOP_COATING_QTY2      -- 추가   
						   ,[PRODUCT_DATE]
						   ,[PRODUCTION_TYPE]
						   ,[DESCRIPTION]
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME])
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
							,WIPQTY2_ENGINE        -- 추가
							,CNFM_DFCT_QTY2        -- 추가
							,CNFM_LOSS_QTY2        -- 추가
							,CNFM_PRDT_REQ_QTY2    -- 추가 
							,TOP_COATING_QTY2      -- 추가                                                                                                                                    
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
												) AS LINE_ID 
									,L.WORK_CENTER_ID                                                                                                                         
									,SUM(WIPQTY_ED) AS QTY
									,SUM(WIPQTY2_ED) AS QTY_LANE                                                                                                                                                  
									,cal_wipdttm_ed AS PRODUCT_DATE
									,U.PRODUCTION_TYPE
									,NULL DESCRIPTION
									,'PR_XIF_MES_DAILY_WIP_HISTORY_R' AS INSERT_ID
									,GETDATE() AS INSERT_TIME
									,'PR_XIF_MES_DAILY_WIP_HISTORY_R' AS UPDATE_ID
									,GETDATE() AS UPDATE_TIME	          
									,SUM(WIPQTY2_ENGINE)     AS WIPQTY2_ENGINE         -- 추가     
									,SUM(CNFM_DFCT_QTY2)     AS CNFM_DFCT_QTY2        -- 추가
									,SUM(CNFM_LOSS_QTY2)     AS CNFM_LOSS_QTY2        -- 추가
									,SUM(CNFM_PRDT_REQ_QTY2) AS CNFM_PRDT_REQ_QTY2     -- 추가       
									,SUM(TOP_COATING_QTY2)   AS TOP_COATING_QTY2    -- 추가                                                                                                                      
							   FROM (SELECT  --CALDATE                                                                                                                                                  
							                 case when substring( convert(varchar,cast(WIPDTTM_ED as datetime),120), 12,2) < '06' and @SITE_ID = 'A001' then cast( convert( varchar, dateadd(DD,-1,WIPDTTM_ED), 112) as datetime ) 
											      when substring( convert(varchar,cast(WIPDTTM_ED as datetime),120), 12,2) < '08' and @SITE_ID = 'A002' then cast( convert( varchar, dateadd(DD,-1,WIPDTTM_ED), 112) as datetime ) 
												  when substring( convert(varchar,cast(WIPDTTM_ED as datetime),120), 12,2) < '07' and @SITE_ID = 'A003' then cast( convert( varchar, dateadd(DD,-1,WIPDTTM_ED), 112) as datetime ) 
											      else cast( convert( varchar,cast(WIPDTTM_ED as datetime),112) as datetime ) end  AS cal_wipdttm_ed          -- 추가 
											,PRODID                                                                                                                                                   
											,EQSGID                                                                                                                                                   
											,PROCID
											,W.EQPTID                                                                                                                                                   
											,WIPQTY_ED
											,WIPQTY2_ED
											,COATING_SIDE_TYPE_CODE -- 추가
											,WIPQTY2_ENGINE         -- 추가
											,CNFM_DFCT_QTY2         -- 추가
											,CNFM_LOSS_QTY2         -- 추가
											,CNFM_PRDT_REQ_QTY2     -- 추가
											,CASE WHEN COATING_SIDE_TYPE_CODE = 'T' THEN WIPQTY2_ED ELSE 0 END TOP_COATING_QTY2  -- 추가

											,(SELECT TOP 1 A.PRODUCTION_TYPE                                                                                                                       
												FROM [DBO].[FP_PRODUCTION_PLAN_R] A with(nolock)                                                                                                  
											    WHERE A.WORK_ORDER_ID = W.WOID
												  AND A.PRODUCTION_TYPE IS NOT NULL
												  ORDER BY FP_PLAN_ID  ) PRODUCTION_TYPE --PRODUCTION_TYPE WO를 연결해서 WO의 PRODUCTION TYPE을 구함.                                                                                    
									    FROM [dbo].[SCM_MES_WIP_HISTORY_H_N] W with(nolock)                                                                                                                  
									--   WHERE CAST(CALDATE AS DATE) >= CAST(DATEADD(DD,-7, GETDATE()) AS DATE)
									   -- wipdttm_ed 일자 기준으로 일주일의 실적을 가져옴.
									   WHERE cast( WIPDTTM_ED as datetime) >= CAST(DATEADD(DD,-7, GETDATE()) AS DATE)
										 AND W.WIP_TYPE_CODE IN ( 'INOUT','OUT' )
										 AND W.WIPQTY_ED > 0
										 AND W.ATTRIBUTE1 = @SITE_ID
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
														,MAX( A.LINE_ID) AS LINE_ID
														,ELECTRODE_TYPE
													FROM [DBO].SCM_EQUIPMENT_M A WITH(NOLOCK) 
													GROUP BY A.COMPANY_ID
														, A.DIVISION_ID
														, A.SITE_ID
														, A.PLANT_ID
														, A.FACTORY_ID
														, A.OPERATION_ID
														, A.MES_LINE_ID
													    , A.ELECTRODE_TYPE) C
							       ON  U.EQSGID =  C.MES_LINE_ID
								   and u.procid = C.OPERATION_ID
								   and substring(C.MES_LINE_ID,1,2)  =  L.FACTORY_ID
							--	 WHERE U.CALDATE IS NOT NULL
								 WHERE U.cal_wipdttm_ed IS NOT NULL
			 					   AND C.SITE_ID = @SITE_ID
								 GROUP BY ISNULL(L.COMPANY_ID, C.COMPANY_ID)                                                                                                                                             
									   ,ISNULL(L.DIVISION_ID, C.DIVISION_ID)                                                                                                                                         
									   ,ISNULL(L.SITE_ID, C.SITE_ID)                                                                                                                                                
									   ,ISNULL(L.PLANT_ID, C.PLANT_ID)                                                                                                                                           
									   ,ISNULL(L.FACTORY_ID, C.FACTORY_ID)
									--   ,CALDATE        
									   ,cal_wipdttm_ed                                                                                                                                         
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
													)
			  						   ,l.WORK_CENTER_ID                                                                                                                                          
									   ,PRODUCTION_TYPE
							)A
				;


				IF ( SELECT COUNT(1) 
				       FROM [dbo].[FP_MES_WORK_ORDER_STATUS_H]
					 WHERE CUTOFF_DATE = CAST(GETDATE() AS DATE)
					   AND SITE_ID     = @SITE_ID
					) = 0
					begin

					 -- [FP_MES_WORK_ORDER_STATUS_H] 생성
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
								  AND A.SITE_ID = @SITE_ID
								;

						OPEN CUR_INSTANCE_ID;
						FETCH NEXT FROM CUR_INSTANCE_ID INTO @INSTANCE_ID
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
										   ,@INSTANCE_ID  AS INSERT_ID                                                                                                                                      
										   ,GETDATE()     AS INSERT_TIME
									  FROM (SELECT (SELECT TOP 1 COMPANY_ID
													  FROM [dbo].[SCM_PLANT_M] with(nolock)
													 WHERE PLANT_ID = A.PLANT_ID )				AS COMPANY_ID
													,(SELECT TOP 1 DIVISION_ID
														FROM [dbo].[SCM_PLANT_M] with(nolock)
														WHERE PLANT_ID = A.PLANT_ID )			AS DIVISION_ID
													,(SELECT TOP 1 SITE_ID
														FROM [dbo].[SCM_PLANT_M] with(nolock)
														WHERE PLANT_ID = A.PLANT_ID )			 AS SITE_ID                                                                                                                                                             
													,A.PLANT_ID                                                                                                                                                               
													,A.BUILNO									 AS FACTORY_ID
													,CAST(GETDATE() AS DATE)					 AS CUTOFF_DATE                                                                                                                          
													,A.WO_DETAIL								 AS WORK_ORDER_SPL_ID                                                                                                                                           
													,A.WO										 AS WORK_ORDER_ID    
													,A.DEMAND_ID                                                                                                                                                            
													,A.WO_TYPE									 AS PRODUCTION_TYPE                                                                                                                                                      
													,A.ORDER_TYPE											                                                                                  
													,A.ITEM_ID                                                                                                                                     
													,A.OPERATION_ID								 AS OPERATION_ID                                                                                                                                                    
													,A.LINE_ID AS LINE_ID                                                                                                                               
													,A.EQUIPMENT_ID								 AS EQUIPMENT_ID                                                                                                                                       
													,A.PLAN_DATE
													,A.START_TIME								 AS PLAN_START_TIME                                                                                                                                                
													,A.END_TIME									 AS PLAN_END_TIME
													,A.IN_QTY									 AS PLAN_QTY
												FROM [dbo].[SY_XIF_MES_WO_S] A with(nolock)
											   WHERE A.PLAN_ID = ( SELECT TOP 1 D.RELEASE_PLAN_ID
																	 FROM SCM_FP_PLAN_H        W WITH(NOLOCK)
																		  ,SCM_FP_PLAN_DETAIL_H D WITH(NOLOCK)
																	WHERE W.PLAN_ID =D.RELEASE_PLAN_ID
																	  AND W.PLAN_TYPE = 'RELEASE'
																	  AND W.INSTANCE_ID = @INSTANCE_ID
																	  AND D.FACTORY_ID = A.BUILNO
																	ORDER BY D.RELEASE_TIME DESC
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
									 WHERE A.SITE_ID = @SITE_ID
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

					end

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
														, SUM(A.WIPQTY2_ED) + SUM(ISNULL(CONVERT(FLOAT,CNFM_DFCT_QTY2),0)) 
																		   + SUM(ISNULL(CONVERT(FLOAT,CNFM_LOSS_QTY2),0)) 
																		   + SUM(ISNULL(CONVERT(FLOAT,CNFM_PRDT_REQ_QTY2),0))                   
		   																   + SUM(ISNULL(CAST(A.SCRAP_QTY AS NUMERIC),0))    							AS ACTUAL_QTY
														, SUM(A.WIPQTY2_ED)                                                  							AS ACTUAL_GOOD_QTY
														, SUM(ISNULL(CONVERT(FLOAT,CNFM_DFCT_QTY2),0)) + SUM(ISNULL(CONVERT(FLOAT,CNFM_LOSS_QTY2),0)) 
																									 + SUM(ISNULL(CONVERT(FLOAT,CNFM_PRDT_REQ_QTY2),0))
		   																							 + SUM(ISNULL(CAST(A.SCRAP_QTY AS NUMERIC),0))		AS ACTUAL_SCRAP_QTY
												FROM [DBO].[SCM_MES_WIP_HISTORY_H] A with(nolock),
													 (SELECT DISTINCT WORK_ORDER_ID,
															 WORK_ORDER_SPL_ID,
															 ITEM_ID
														FROM [DBO].[FP_MES_WORK_ORDER_STATUS_H] A with(nolock)
													   WHERE A.CUTOFF_DATE = CAST(GETDATE() AS DATE)
														 AND A.SITE_ID = @SITE_ID
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
					  AND A.SITE_ID = @SITE_ID
					;


           -- [FP_MES_PRODUCTION_PLAN_M] value update
		--------------------------------------------------------------------------------------------------------------------------------------------------------
			UPDATE A
				SET  ACTUAL_QTY		    = ISNULL(B.ACTUAL_QTY, 0)
				    ,ACTUAL_GOOD_QTY    = ISNULL(B.ACTUAL_GOOD_QTY, 0)
				    ,ACTUAL_SCRAP_QTY	= ISNULL(B.ACTUAL_SCRAP_QTY, 0)
					,WO_STATUS          = CASE WHEN ISNULL(A.PLAN_QTY, 0) < ISNULL(B.ACTUAL_QTY, 0) THEN 'CLOSE'
					                      ELSE 'OPEN'
										   END
					,UPDATE_ID          = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'
					,UPDATE_TIME        = GETDATE()
			FROM [DBO].[FP_MES_PRODUCTION_PLAN_M] A 
					,(SELECT A.WOID
							, A.WO_DETL_ID
							, A.PRODID
							, MAX(CONVERT(NVARCHAR, MODIFY_DATE, 112))															AS MODIFY_DATE
							, CAST(MAX(A.[CALDATE]) AS DATETIME)																AS CUTOFF_DATE
							, MAX(CAST(A.WIPDTTM_ST  AS DATETIME))																AS ACTUAL_START_TIME
							, MAX(CAST(A.WIPDTTM_ED  AS DATETIME))																AS ACTUAL_END_TIME
							, SUM(A.WIPQTY2_ED) + SUM(ISNULL(CONVERT(FLOAT,CNFM_DFCT_QTY2),0)) 
												+ SUM(ISNULL(CONVERT(FLOAT,CNFM_LOSS_QTY2),0)) 
												+ SUM(ISNULL(CONVERT(FLOAT,CNFM_PRDT_REQ_QTY2),0))
												+ SUM(ISNULL(CAST(A.SCRAP_QTY AS NUMERIC),0))                       			AS ACTUAL_QTY
							, SUM(A.WIPQTY2_ED)                                              									AS ACTUAL_GOOD_QTY
							, SUM(ISNULL(CONVERT(FLOAT,CNFM_DFCT_QTY2),0))  + SUM(ISNULL(CONVERT(FLOAT,CNFM_LOSS_QTY2),0)) 
																			+ SUM(ISNULL(CONVERT(FLOAT,CNFM_PRDT_REQ_QTY2),0))
		   																	+ SUM(ISNULL(CAST(A.SCRAP_QTY AS NUMERIC),0))		AS ACTUAL_SCRAP_QTY
					    FROM [DBO].[SCM_MES_WIP_HISTORY_H_N] A with(nolock)
						-- 조건 변경
					    WHERE cast( WIPDTTM_ED as datetime) >= CAST(DATEADD(DD,-7, GETDATE()) AS DATE)
						AND A.WIP_TYPE_CODE IN ( 'INOUT','OUT' )
						AND A.WIPQTY_ED > 0
						AND A.ATTRIBUTE1 = @SITE_ID
					    GROUP BY A.WOID, A.WO_DETL_ID, A.PRODID
					) B
			WHERE A.WORK_ORDER_ID      = B.WOID
		      AND A.WORK_ORDER_SPL_ID  = B.WO_DETL_ID    
			  AND A.ITEM_ID            = B.PRODID
			  AND A.SITE_ID            = @SITE_ID

		--------------------------------------------------------------------------------------------------------------------------------------------------------


		UPDATE [dbo].[SY_XIF_MES_DAILY_WIP_HISTORY_R]
		   SET PROC_FLAG    = 'Y'
			  ,PROC_DATE    = GETDATE()
	     WHERE IF_ID        = @IF_ID  
		   AND ACCUM_DATE   = @ACCUM_DATE
		;


		  FETCH NEXT FROM CUR_IF_MES_WIPHIST INTO  @IF_ID        
												  ,@ACCUM_DATE
												  ,@SITE_ID
												  ;


		  END;
		  CLOSE CUR_IF_MES_WIPHIST;
		  DEALLOCATE CUR_IF_MES_WIPHIST;   



         --  [FP_MES_WORK_ORDER_STATUS_H] 부분... 추가 고민해 볼 것.


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



