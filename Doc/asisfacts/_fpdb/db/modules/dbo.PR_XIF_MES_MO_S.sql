
CREATE PROCEDURE [dbo].[PR_XIF_MES_MO_S]

-- ================================================================================================
-- Program ID          : FP01660
-- Program Name        : PR_XIF_MES_MO_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF DEV
-- Source Table        : FP_MOVE_PLAN_R
-- Destination Table   : XIF_MES_MO_S
--
-- Create(Update) Date : 2022.07.29
-- Author              : 김 석
-- Version             : 1.0
--	                     1.1 2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                           동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                           라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--	                     1.2 2022-07-29 kimcd 설비정보 Option화에 따른 수정
-- ================================================================================================

-- PARAM PLAN_ID
@P_FP_PLAN_ID NVARCHAR(50) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_MO_S'
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
	DECLARE @if_id_code             NVARCHAR(50)  = 'OFP0_OMS1_FP_MO'
	DECLARE @send_if_seq            NVARCHAR(50)
	DECLARE @send_date              NVARCHAR(50)
	DECLARE @if_seq_next            BIGINT


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
		
			DELETE FROM [dbo].[SY_XIF_MES_MO_S]
			 WHERE PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
			;
			
			INSERT INTO [dbo].[SY_XIF_MES_MO_S]
					   ([IF_SEQ]
					   ,[IF_TYPE]
					   ,[IF_ID]
					   ,[IF_INS_DATE]
					   ,[IF_FLAG]
					   ,[IF_SND_DATE]
					   ,[RSLT_IF_SEQ]
					   ,[RSLT_PROC_FLAG]
					   ,[RSLT_PROC_MSG]
					   ,[PLAN_ID]
					   ,[MO]
					   ,[ITEM_ID]
					   ,[FROM_PLANT_ID]
					   ,[FROM_BUILNO]
					   ,[FROM_OPERATION_ID]
					   ,[FROM_LINE_ID]
					   ,[FROM_SLOC]
					   ,[FROM_WO]
					   ,[TO_PLANT_ID]
					   ,[TO_BUILNO]
					   ,[TO_OPERATION_ID]
					   ,[TO_LINE_ID]
					   ,[TO_SLOC]
					   ,[TO_WO]
					   ,[DEMAND_ID]
					   ,[BOD_ID]
					   ,[BOD_NAME]
					   ,[PLAN_DATE]
					   ,[START_TIME]
					   ,[END_TIME]
					   ,[QTY]
					   ,[IS_RELEASE]
					   ,[CREATE_PSN_ID]
					   ,[CREATE_DATE]
					   ,[UPDATE_PSN_ID]
					   ,[UPDATE_DATE]
					   ,[ATTR_01]
					   ,[ATTR_02]
					   ,[ATTR_03]
					   ,[ATTR_04]
					   ,[ATTR_05]
					   ,[ATTR_06]
					   ,[ATTR_07]
					   ,[ATTR_08]
					   ,[ATTR_09]
					   ,[ATTR_10])
        		SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)
				--SELECT ''
						,'S'                     
						--,@if_id_code           
						--,'OFP0'+'_'+( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WHERE F.FACTORY_ID = SOURCE_TABLE.FACTORY_ID ) +'_'+'FP_MO'
						--2021-05-28 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
						,'OFP0'+'_'+( SELECT ISNULL(L.MES_SOURCE_GROUP,(SELECT ISNULL(F.MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WITH(NOLOCK) WHERE F.FACTORY_ID = SOURCE_TABLE.FACTORY_ID)) FROM SCM_MMD_LINE_M L  WITH(NOLOCK) WHERE L.FACTORY_ID = SOURCE_TABLE.FACTORY_ID 
									         AND L.LINE_ID = (ISNULL( (SELECT TOP 1 CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END  FROM [dbo].[SCM_LINE_M] C -- 2022-07-29 kimcd 기본 Table을 Line으로 변경
						                                          WHERE C.COMPANY_ID = SOURCE_TABLE.COMPANY_ID
						                                            AND C.DIVISION_ID = SOURCE_TABLE.DIVISION_ID
						                                            AND C.SITE_ID = SOURCE_TABLE.SITE_ID
						                                            AND C.PLANT_ID = SOURCE_TABLE.PLANT_ID
						                                            AND C.LINE_ID = SOURCE_TABLE.LINE_ID
						                                           AND C.OPERATION_ID = SOURCE_TABLE.OPERATION_ID), SOURCE_TABLE.LINE_ID))) +'_'+'FP_MO'
						,GETDATE()               
						,'N'                     
						,NULL                    
						,NULL                    
						,NULL                    
						,NULL                    
                        ,FP_PLAN_ID              
                        ,MOVE_ORDER_ID           
                        ,ITEM_ID                 
                        ,PLANT_ID                
                        ,FACTORY_ID              
                        ,OPERATION_ID            
					    ,ISNULL((SELECT TOP 1 CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END  FROM [dbo].[SCM_LINE_M] C -- 2022-07-29 kimcd 기본 Table을 Line으로 변경
								   WHERE C.COMPANY_ID = SOURCE_TABLE.COMPANY_ID
									 AND C.DIVISION_ID = SOURCE_TABLE.DIVISION_ID
									 AND C.SITE_ID = SOURCE_TABLE.SITE_ID
									 AND C.PLANT_ID = SOURCE_TABLE.PLANT_ID
									 AND C.LINE_ID = SOURCE_TABLE.LINE_ID
									AND C.OPERATION_ID = SOURCE_TABLE.OPERATION_ID), SOURCE_TABLE.LINE_ID) AS FROM_LINE_ID
                        --,'' AS FROM_LINE_ID      
                        ,'' AS FROM_SLOC         
                        ,FROM_WORK_ORDER_ID      
                        ,'' AS TO_PLANT_ID       
                        ,TO_FACTORY_ID           
                        ,TO_OPERATION_ID         
					    ,ISNULL((SELECT TOP 1 CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END  FROM [dbo].[SCM_LINE_M] C -- 2022-07-29 kimcd 기본 Table을 Line으로 변경
								   WHERE C.COMPANY_ID = SOURCE_TABLE.COMPANY_ID
									 AND C.DIVISION_ID = SOURCE_TABLE.DIVISION_ID
									 AND C.SITE_ID = SOURCE_TABLE.SITE_ID
									 AND C.PLANT_ID = SOURCE_TABLE.PLANT_ID
									 AND C.LINE_ID = SOURCE_TABLE.TO_LINE_ID
									 AND C.OPERATION_ID = SOURCE_TABLE.TO_OPERATION_ID),SOURCE_TABLE.TO_LINE_ID) AS TO_LINE_ID
                        --,TO_LINE_ID              
                        ,'' AS TO_SLOC           
                        ,TO_WORK_ORDER_ID        
                        ,DEMAND_ID               
                        ,BOD_ID                  
                        ,'' AS BOD_NAME
						,CONVERT(NVARCHAR(50), PLAN_DATE, 120) AS PLAN_DATE
						,CONVERT(NVARCHAR(50), START_TIME, 120) AS START_TIME
						,CONVERT(NVARCHAR(50), END_TIME, 120) AS END_TIME						              
                        ,PLAN_QTY                
						,CASE WHEN FIX_TYPE = 'F' THEN 'Y'
								WHEN FIX_TYPE = 'N' THEN 'Y'
								WHEN FIX_TYPE = 'P' THEN '-'
						 ELSE FIX_TYPE 
						  END AS FIX_TYPE             
						,'PR_XIF_MES_MO_S'       
						,GETDATE()               
						,'PR_XIF_MES_MO_S'       
						,GETDATE()               
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
		           FROM [DBO].[FP_MOVE_PLAN_R] SOURCE_TABLE WITH(NOLOCK) 
				    --AND SOURCE_TABLE.FP_PLAN_ID LIKE '%99'
				  WHERE SOURCE_TABLE.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
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
