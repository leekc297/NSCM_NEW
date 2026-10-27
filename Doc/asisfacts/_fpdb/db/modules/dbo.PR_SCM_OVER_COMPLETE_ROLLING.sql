
create PROCEDURE [dbo].[PR_SCM_OVER_COMPLETE_ROLLING]

-- ================================================================================================
-- Program ID          : FP00520
-- Program Name        : PR_XIF_OVER_COMPLETE_ROLLING
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : FP
-- Destination System  : ERP,  MES
-- Source Table        : FP_ERP_WORK_ORDER_STATUS_H, SY_XIF_MES_WO_S
-- Destination Table   : SY_XIF_ERP_PRODUCTION_PLAN_S, SY_XIF_MES_WO_S
--
-- Create(Update) Date : 2017.06.13
-- Author              : PIYONG
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_OVER_COMPLETE_ROLLING'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @SEQ		   INTEGER

	DECLARE @V_RELEASE_PLAN_ID	NVARCHAR(30)
	DECLARE @V_DIVISION_ID		NVARCHAR(30)
	DECLARE @V_SITE_ID			NVARCHAR(30)
	DECLARE @V_FACTORY_ID		NVARCHAR(30)
	DECLARE @V_OPERATION_ID		NVARCHAR(150)
	DECLARE @V_EQUIPMENT_ID		NVARCHAR(150)
	DECLARE @V_ITEM_ID			NVARCHAR(150)
	DECLARE @V_WORK_ORDER_ID	NVARCHAR(150)

	DECLARE @V_ACTUAL_QTY		NUMERIC(14,4)
	DECLARE @V_DETAIL_COUNT		NUMERIC(18,5)

	--erp에서 실적 조회  close 된것 중 계획 수량보다 실적이 큰것을 찾는다

	DECLARE CUR_OVER_COMPLETE CURSOR FOR
		SELECT E.DIVISION_ID
			   , E.SITE_ID
			   , E.FACTORY_ID
			   , E.OPERATION_ID
			   , (SELECT F.EQUIPMENT_ID
					FROM FP_RELEASE_FIX_PLAN_H F	
				   WHERE F.WORK_ORDER_ID = E.WORK_ORDER_ID
				     AND F.RELEASE_PLAN_ID = (SELECT MAX(RELEASE_PLAN_ID)
												FROM FP_RELEASE_FIX_PLAN_H	
											   WHERE WORK_ORDER_ID = E.WORK_ORDER_ID
											 )
				 ) AS EQUIPMENT_ID
			   , E.ITEM_ID
			   , E.WORK_ORDER_ID
			   , E.ACTUAL_QTY
		  FROM DBO.FP_ERP_WORK_ORDER_STATUS_H E
		 WHERE E.ACTUAL_QTY IS NOT NULL
		   AND E.WO_STATUS = 'CLOSE'
		   AND E.PLAN_QTY < E.ACTUAL_QTY
		   AND E.CUTOFF_DATE = CONVERT(NVARCHAR(10), GETDATE(), 120)
		   AND NOT EXISTS ( SELECT 1								 -- 오늘 전송한 WO은 제외
							  FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S
							 WHERE FP_PLAN_ID LIKE '%OVER%'
							   AND WORK_ORDER_ID = E.WORK_ORDER_ID
							   AND CONVERT(nvarchar(10), MODIFY_DATE, 120) = CONVERT(NVARCHAR(10), GETDATE(), 120)
						   )



	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			 OPEN CUR_OVER_COMPLETE;

			 FETCH NEXT FROM CUR_OVER_COMPLETE INTO @V_DIVISION_ID
													, @V_SITE_ID
													, @V_FACTORY_ID
												    , @V_OPERATION_ID
												    , @V_EQUIPMENT_ID
												    , @V_ITEM_ID
												    , @V_WORK_ORDER_ID
												    , @V_ACTUAL_QTY
			;

				WHILE (@@FETCH_STATUS = 0)
					BEGIN	

						SET @SEQ = NEXT VALUE FOR RELEASE_PLAN
	
						-- ERP 전송 WO 정보 생성
						INSERT INTO DBO.SY_XIF_ERP_PRODUCTION_PLAN_S
							   ([IFSEQNO]
							   ,[SEQ]
							   ,[FP_PLAN_ID]
							   ,[PLANT_ID]
							   ,[FACTORY_ID]
							   ,[LINE_ID]
							   ,[OPERATION_ID]
							   ,[BOM_VERSION_ID]
							   ,[WORK_CENTER_ID]
							   ,[ITEM_ID]
							   ,[DEMAND_ID]
							   ,[WORK_ORDER_ID]
							   ,[ORDER_TYPE]
							   ,[PLAN_DATE]
							   ,[START_TIME]
							   ,[END_TIME]
							   ,[PLAN_IN_QTY]
							   ,[PLAN_QTY]
							   ,[FIX_TYPE]
							   ,[TRANSFER_FLAG]
							   ,[TRANSFER_DATE]
							   ,[CREATE_USER_ID]
							   ,[CREATE_DATE]
							   ,[MODIFY_USER_ID]
							   ,[MODIFY_DATE]
							   ,[LANE_QTY]
							   ,[BATCH_ORDER_ID]
							   ,[SLITTER_PLANT]
							   ,[MARKET] -- 170208 Add
							   ,[ATTRIBUTE1]
							   ,[ATTRIBUTE2]
							   ,[ATTRIBUTE3]
							   ,[ATTRIBUTE4]
							   ,[ATTRIBUTE5]
							   ,[ATTRIBUTE6]
							   ,[ATTRIBUTE7]
							   ,[ATTRIBUTE8]
							   ,[ATTRIBUTE9]
							   ,[ATTRIBUTE10]
							   ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							   ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
							   ,[FP_PLAN_QTY]  -- FP Plan 수량
							   ,[FP_SNAP_QTY]  -- FP 실적 수량
							   ,TECO_IND )
						SELECT  REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]     
								,ROW_NUMBER() OVER ( ORDER BY A.LINE_ID, A.ITEM_ID) --[SEQ]      ,ROW_NUMBER() OVER ( ORDER BY LINE_ID, ITEM_ID) --[SEQ]
								,A.FP_PLAN_ID + '_OVER_'+ CAST( @SEQ AS VARCHAR )
								,A.[PLANT_ID]
								,A.[FACTORY_ID]
								,A.[LINE_ID]
								,A.[OPERATION_ID]
								,A.[BOM_VERSION_ID]
								,A.[WORK_CENTER_ID]
								,A.[ITEM_ID]
								,A.[DEMAND_ID]
								,A.[WORK_ORDER_ID]
								,A.[ORDER_TYPE]
								,A.[PLAN_DATE]
								,A.[START_TIME]
								,A.[END_TIME]
								,@V_ACTUAL_QTY -- + WO 실적 수량 [PLAN_IN_QTY] -- 수량 변경 필요
								,@V_ACTUAL_QTY-- + WO 실적 수량 [PLAN_QTY]    -- 수량 변경 필요
								,[FIX_TYPE]
								,'N' --[TRANSFER_FLAG]
								,A.[TRANSFER_DATE]
								,A.[CREATE_USER_ID]
								,A.[CREATE_DATE]
								,'OVER_COMPLETE' -- [MODIFY_USER_ID]
								,GETDATE() -- [MODIFY_DATE]
								,A.[LANE_QTY]
								,A.[BATCH_ORDER_ID]
								,A.[SLITTER_PLANT]
								,A.[MARKET]
								,A.[ATTRIBUTE1]
								,A.[ATTRIBUTE2]
								,A.[ATTRIBUTE3]
								,A.[ATTRIBUTE4]
								,A.[ATTRIBUTE5]
								,A.[ATTRIBUTE6]
								,A.[ATTRIBUTE7]
								,A.[ATTRIBUTE8]
								,A.[PLAN_IN_QTY]
								,A.[PLAN_QTY]
								,A.TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
								,A.LINK_WO      -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
								,A.FP_PLAN_QTY  -- FP PLAN 수량
								,A.FP_SNAP_QTY  -- FP 실적 수량
								,TECO_IND	
						   FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S A
						   		,(SELECT IFSEQNO, B.[WORK_ORDER_ID] , ROW_NUMBER() OVER( PARTITION BY [WORK_ORDER_ID] ORDER BY MODIFY_DATE DESC) ROWNUMS
									 FROM [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] B
                                    WHERE [WORK_ORDER_ID]  = @V_WORK_ORDER_ID 
								) B
						  WHERE A.WORK_ORDER_ID = B.WORK_ORDER_ID
							AND A.IFSEQNO = B.IFSEQNO
							AND B.ROWNUMS = 1
							;


						-- ERP 전송 WO 정보 생성
						INSERT INTO DBO.SY_XIF_ERP_PRODUCTION_PLAN_S
							   ([IFSEQNO]
							   ,[SEQ]
							   ,[FP_PLAN_ID]
							   ,[PLANT_ID]
							   ,[FACTORY_ID]
							   ,[LINE_ID]
							   ,[OPERATION_ID]
							   ,[BOM_VERSION_ID]
							   ,[WORK_CENTER_ID]
							   ,[ITEM_ID]
							   ,[DEMAND_ID]
							   ,[WORK_ORDER_ID]
							   ,[ORDER_TYPE]
							   ,[PLAN_DATE]
							   ,[START_TIME]
							   ,[END_TIME]
							   ,[PLAN_IN_QTY]
							   ,[PLAN_QTY]
							   ,[FIX_TYPE]
							   ,[TRANSFER_FLAG]
							   ,[TRANSFER_DATE]
							   ,[CREATE_USER_ID]
							   ,[CREATE_DATE]
							   ,[MODIFY_USER_ID]
							   ,[MODIFY_DATE]
							   ,[LANE_QTY]
							   ,[BATCH_ORDER_ID]
							   ,[SLITTER_PLANT]
							   ,[MARKET] -- 170208 Add
							   ,[ATTRIBUTE1]
							   ,[ATTRIBUTE2]
							   ,[ATTRIBUTE3]
							   ,[ATTRIBUTE4]
							   ,[ATTRIBUTE5]
							   ,[ATTRIBUTE6]
							   ,[ATTRIBUTE7]
							   ,[ATTRIBUTE8]
							   ,[ATTRIBUTE9]
							   ,[ATTRIBUTE10]
							   ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							   ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
							   ,[FP_PLAN_QTY]  -- FP Plan 수량
							   ,[FP_SNAP_QTY]  -- FP 실적 수량
							   ,TECO_IND )
						SELECT  REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]     
								,ROW_NUMBER() OVER ( ORDER BY A.LINE_ID, A.ITEM_ID) --[SEQ]      ,ROW_NUMBER() OVER ( ORDER BY LINE_ID, ITEM_ID) --[SEQ]
								,A.FP_PLAN_ID + '_OVER_'+ CAST( @SEQ AS VARCHAR )
								,A.[PLANT_ID]
								,A.[FACTORY_ID]
								,A.[LINE_ID]
								,A.[OPERATION_ID]
								,A.[BOM_VERSION_ID]
								,A.[WORK_CENTER_ID]
								,A.[ITEM_ID]
								,A.[DEMAND_ID]
								,A.[WORK_ORDER_ID]
								,A.[ORDER_TYPE]
								,A.[PLAN_DATE]
								,A.[START_TIME]
								,A.[END_TIME]
								,@V_ACTUAL_QTY -- + WO 실적 수량 [PLAN_IN_QTY] -- 수량 변경 필요
								,@V_ACTUAL_QTY-- + WO 실적 수량 [PLAN_QTY]    -- 수량 변경 필요
								,[FIX_TYPE]
								,'N' --[TRANSFER_FLAG]
								,A.[TRANSFER_DATE]
								,A.[CREATE_USER_ID]
								,A.[CREATE_DATE]
								,'OVER_COMPLETE' -- [MODIFY_USER_ID]
								,GETDATE() -- [MODIFY_DATE]
								,A.[LANE_QTY]
								,A.[BATCH_ORDER_ID]
								,A.[SLITTER_PLANT]
								,A.[MARKET]
								,A.[ATTRIBUTE1]
								,A.[ATTRIBUTE2]
								,A.[ATTRIBUTE3]
								,A.[ATTRIBUTE4]
								,A.[ATTRIBUTE5]
								,A.[ATTRIBUTE6]
								,A.[ATTRIBUTE7]
								,A.[ATTRIBUTE8]
								,A.[PLAN_IN_QTY]
								,A.[PLAN_QTY]
								,A.TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
								,A.LINK_WO      -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
								,A.FP_PLAN_QTY  -- FP PLAN 수량
								,A.FP_SNAP_QTY  -- FP 실적 수량
								,TECO_IND	
						   FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S A
						   		,(SELECT IFSEQNO, B.[LINK_WO] , ROW_NUMBER() OVER( PARTITION BY [WORK_ORDER_ID] ORDER BY MODIFY_DATE DESC) ROWNUMS
									 FROM [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] B
                                    WHERE [WORK_ORDER_ID]  = @V_WORK_ORDER_ID 
								) B
						  WHERE A.WORK_ORDER_ID = B.LINK_WO
							AND A.IFSEQNO = B.IFSEQNO
							AND B.ROWNUMS = 1
							;


						-- MES 전송 WO 정보 생성
						insert into [dbo].[SY_XIF_MES_WO_S]
										( [IF_SEQ]                                                                                                                                                                                                                                  
										,[IF_TYPE]                                                                                                                                                                                                                                   
										,[IF_ID]                                                                                                                                                                                                                                     
										,[IF_INS_DATE]                                                                                                                                                                                                                               
										,[IF_FLAG]                                                                                                                                                                                                                                   
										,[IF_SND_DATE]                                                                                                                                                                                                                               
										,[RSLT_IF_SEQ]                                                                                                                                                                                                                               
										,[RSLT_PROC_FLAG]                                                                                                                                                                                                                            
										,[RSLT_PROC_MSG]                                                                                                                                                                                                                             
										,[PLAN_ID]                                                                                                                                                                                                                                   
										,[PLANT_ID]                                                                                                                                                                                                                                  
										,[BUILNO]                                                                                                                                                                                                                                    
										,[LINE_ID]                                                                                                                                                                                                                                   
										,[OPERATION_ID]                                                                                                                                                                                                                              
										,[EQUIPMENT_ID]                                                                                                                                                                                                                              
										,[ITEM_ID]                                                                                                                                                                                                                                   
										,[DEMAND_ID]                                                                                                                                                                                                                                 
										,[WO]                                                                                                                                                                                                                                        
										,[WO_TYPE]                                                                                                                                                                                                                                   
										,[WO_DETAIL]                                                                                                                                                                                                                                 
										,[PLAN_DATE]                                                                                                                                                                                                                                 
										,[START_TIME]                                                                                                                                                                                                                                
										,[END_TIME]                                                                                                                                                                                                                                  
										,[IN_QTY]                                                                                                                                                                                                                                    
										,[OUT_QTY]                                                                                                                                                                                                                                   
										,[IS_RELEASE]                                                                                                                                                                                                                                
										,[CREATE_PSN_ID]                                                                                                                                                                                                                             
										,[CREATE_DATE]                                                                                                                                                                                                                               
										,[UPDATE_PSN_ID]                                                                                                                                                                                                                             
										,[UPDATE_DATE]                                                                                                                                                                                                                               
										,[LANE_QTY]                                                                                                                                                                                                                                  
										,[UNIT]                                                                                                                                                                                                                                      
										,[ORDER_TYPE]    
										,[BATCH_ORDER_ID]
										,[SLITTER_PLANT]
										,[MARKET]
										,[ATTR_01]
										,[ATTR_02]
										,[ATTR_03]
										,[ATTR_04]
										,[ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
										,[ATTR_06] -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
										,[ATTR_07] -- 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
										,[ATTR_08] -- FP PLAN 수량
										,[ATTR_09] -- FP 실적 수량
										,[ATTR_10])
						SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[DBO].[XIF_MES_SEND_SEQ])) 
									  + CAST( NEXT VALUE FOR [LGCE_INFDEV].[DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ      ,[IF_TYPE]
								,'S'
								,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = A.[BUILNO] ),'') +'_'+'FP_WO' -- [IF_ID]
								,A.[IF_INS_DATE]
								,'N' --[IF_FLAG]
								,A.[IF_SND_DATE]
								,NULL -- [RSLT_IF_SEQ]
								,NULL--[RSLT_PROC_FLAG]
								,NULL--[RSLT_PROC_MSG]
								,A.PLAN_ID + '_OVER_'--+ CAST( @SEQ AS VARCHAR )
								,A.[PLANT_ID]
								,A.[BUILNO]
								,A.[LINE_ID]
								,A.[OPERATION_ID]
								,A.[EQUIPMENT_ID]
								,A.[ITEM_ID]
								,A.[DEMAND_ID]
								,A.[WO]
								,A.[WO_TYPE]
								,A.[WO_DETAIL]
								,A.[PLAN_DATE]
								,A.[START_TIME]
								,A.[END_TIME]
								,@V_ACTUAL_QTY --[IN_QTY]
								,@V_ACTUAL_QTY --[OUT_QTY]
								,A.[IS_RELEASE]
								,A.[CREATE_PSN_ID]
								,A.[CREATE_DATE]
								,'OVER_COMPLETE' --[UPDATE_PSN_ID]
								,GETDATE() --[UPDATE_DATE]
								,A.[LANE_QTY]
								,A.[UNIT]
								,A.[ORDER_TYPE]
								,A.[BATCH_ORDER_ID]
								,A.[SLITTER_PLANT]
								,A.[MARKET]
								,A.[ATTR_01]
								,A.[ATTR_02]
								,A.[ATTR_03]
								,A.[ATTR_04]
								,A.[ATTR_05]
								,A.[ATTR_06]
								,A.[ATTR_07]
								,A.[ATTR_08]  -- ATTR_08 FP PLAN 수량
								,@V_ACTUAL_QTY AS ATTR_09  -- ATTR_09 FP 실적 수량
								,A.[ATTR_10]
						   FROM [DBO].[SY_XIF_MES_WO_S] A WITH(NOLOCK)
								,(SELECT B.IF_SEQ, B.WO, B.WO_DETAIL , ROW_NUMBER() OVER( PARTITION BY B.WO, B.WO_DETAIL ORDER BY B.UPDATE_DATE DESC) ROWNUMS
									 FROM [DBO].[SY_XIF_MES_WO_S] B
										  ,[DBO].[SY_XIF_MES_WO_S] C
                                    WHERE B.ATTR_06 = C.WO
									  AND B.ATTR_07 = C.WO_DETAIL
									  AND B.PLAN_ID = C.PLAN_ID
									  AND B.IF_ID   = C.IF_ID
									  AND C.IF_ID  != 'OFP0_OPLM_FP_WO'
									  AND C.WO  = @V_WORK_ORDER_ID 
									  AND C.EQUIPMENT_ID = ISNULL( @V_EQUIPMENT_ID, B.EQUIPMENT_ID )
								) B
						  WHERE A.[WO]      = B.WO
							AND A.WO_DETAIL = B.WO_DETAIL
							AND A.IF_SEQ    = B.IF_SEQ
							AND B.ROWNUMS = 1
						   ;

						   
						FETCH NEXT FROM CUR_OVER_COMPLETE INTO @V_DIVISION_ID
																, @V_SITE_ID
																, @V_FACTORY_ID
																, @V_OPERATION_ID
																, @V_EQUIPMENT_ID
																, @V_ITEM_ID
																, @V_WORK_ORDER_ID
																, @V_ACTUAL_QTY
						;

					END;

			  CLOSE CUR_OVER_COMPLETE;
			  DEALLOCATE CUR_OVER_COMPLETE;

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



