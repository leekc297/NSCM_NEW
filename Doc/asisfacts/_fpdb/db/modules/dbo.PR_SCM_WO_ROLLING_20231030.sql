
CREATE PROCEDURE [dbo].[PR_SCM_WO_ROLLING_20231020]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_WO_ROLLING
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : 
-- Destination System  : FP SDB
-- Source Table        : FP_RELEASE_FIX_PLAN_H
-- Destination Table   : FP_RELEASE_FIX_PLAN_H
--
-- Create Date		   : 2017.06.07
-- Update Date		   : 2017.06.09 PIYONG 1.1
--					   : 2017.06.14 PIYONG 1.2
--					     2017.06.23 PIYONG 1.3
--						 2017.07.13 PIYONG 1.5
--						 2017.08.25 PIYONG 1.6
--						 2017.08.29 KIMCD  1.7
--						 2017.11.10 PYONG  1.8

-- Author              : ZYTCHOI
-- Version             : 1.0
--					   : 1.1 FP_RELEASE_FIX_PLAN_H 테이블에 UPDATE_ID, UPDATE_TIME 추가
--						 1.2 실적 합산시 ADD_QTY 추가
--						 1.3 실적수량 조회시 ADD_QTY 삭제  양품 수량에 이미 포함되어 있음
--                       1.4  월 초 제한 로직 제거 kimcd 2017-06-24
--                            MES에서 월 초에는 ERP로  실적 전송 안 하는 것으로 결정되어  전월 WO도 사용 가능함
--						 1.5 실적 수량 조회 조건 추가
--						 1.6   SCM_MES_WIP_HISTORY_H 의 WIP_TYPE_CODE 조건에  PROD 추가
--                       1.7  오창 소형 조립 Pilot
--						 1.8  CUR_TARGET_PLAN CURSOR 변경( Plan Release Group 기준으로  RELEASE_PLAN_ID 찾기)
--                       1.9 2023-11-01 FP Pjt. 스마트 팩토리 핵심 IT 품질 시스템 구축_FP영역 / PDS 전송 추가
-- ================================================================================================
   @P_SITE_ID  NVARCHAR(30)
 , @RUN_TYPE  NVARCHAR(100) -- BASIC, ADVANCED
                            -- BASIC 는 Pegging 정보를 이용하지 않고, 과거 WO 별 실적을 비교해서 WO 계획수량보다 실적수량이 작은것만 당일자로 WO 일자 변경
						    -- ADVANCE는 Pegging 정보를 이용해서 과거 WO에 잔량뿐 아니라 미래 생산계획의 WO 수량까지도 차감시킴.
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_WO_ROLLING'
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
	DECLARE @plan_id       NVARCHAR(1000)
	DECLARE @FACTORY_ID    NVARCHAR(1000)
	DECLARE @INSTANCE_DATE NVARCHAR(1000)

	DECLARE @BASE_HOUR    NVARCHAR(10)

	DECLARE @SEQ		   INTEGER


	DECLARE @SITE_NAME    NVARCHAR(1000)
	DECLARE @COUNTRY_ID   NVARCHAR(1000)
	DECLARE @VALID_YN     NVARCHAR(1000)

	DECLARE @XIF_MES_WO_S TABLE(
		[IF_SEQ]			[nvarchar](50) NOT NULL,
		[IF_TYPE]			[nvarchar](1) NOT NULL,
		[IF_ID]				[nvarchar](50) NOT NULL,
		[IF_INS_DATE]		[datetime] NULL,
		[IF_FLAG]			[nvarchar](1) NOT NULL,
		[IF_SND_DATE]		[datetime] NULL,
		[RSLT_IF_SEQ]		[bigint] NULL,
		[RSLT_PROC_FLAG]	[nvarchar](1) NULL,
		[RSLT_PROC_MSG]		[nvarchar](1000) NULL,
		[PLAN_ID]			[nvarchar](50) NULL,
		[PLANT_ID]			[nvarchar](50) NULL,
		[BUILNO]			[nvarchar](50) NULL,
		[LINE_ID]			[nvarchar](50) NULL,
		[OPERATION_ID]		[nvarchar](50) NULL,
		[EQUIPMENT_ID]		[nvarchar](50) NULL,
		[ITEM_ID]			[nvarchar](50) NULL,
		[DEMAND_ID]			[nvarchar](150) NULL,
		[WO]				[nvarchar](50) NULL,
		[WO_TYPE]			[nvarchar](50) NULL,
		[WO_DETAIL]			[nvarchar](50) NULL,
		[PLAN_DATE]			[nvarchar](50) NULL,
		[START_TIME]		[nvarchar](50) NULL,
		[END_TIME]			[nvarchar](50) NULL,
		[IN_QTY]			[nvarchar](50) NULL,
		[OUT_QTY]			[nvarchar](50) NULL,
		[IS_RELEASE]		[nvarchar](50) NULL,
		[CREATE_PSN_ID]		[nvarchar](50) NULL,
		[CREATE_DATE]		[datetime] NULL,
		[UPDATE_PSN_ID]		[nvarchar](50) NULL,
		[UPDATE_DATE]		[datetime] NULL,
		[LANE_QTY]			[nvarchar](50) NULL,
		[UNIT]				[nvarchar](50) NULL,
		[ORDER_TYPE]		[nvarchar](50) NULL,
		[BATCH_ORDER_ID]	[nvarchar](30) NULL,
		[SLITTER_PLANT]		[nvarchar](30) NULL,
		[MARKET]			[nvarchar](1) NULL,
		[ATTR_01]			[nvarchar](50) NULL,
		[ATTR_02]			[nvarchar](50) NULL,
		[ATTR_03]			[nvarchar](50) NULL,
		[ATTR_04]			[nvarchar](50) NULL,
		[ATTR_05]			[nvarchar](50) NULL,
		[ATTR_06]			[nvarchar](50) NULL,
		[ATTR_07]			[nvarchar](50) NULL,
		[ATTR_08]			[nvarchar](50) NULL,
		[ATTR_09]			[nvarchar](50) NULL,
		[ATTR_10]			[nvarchar](50) NULL,
		[ATTR_11]			[nvarchar](50) NULL,
		[ATTR_12]			[nvarchar](50) NULL,
		[ATTR_13]			[nvarchar](50) NULL,
		[ATTR_14]			[nvarchar](50) NULL,
		[ATTR_15]			[nvarchar](50) NULL,
		[ATTR_16]			[nvarchar](50) NULL,
		[ATTR_17]			[nvarchar](50) NULL,
		[ATTR_18]			[nvarchar](50) NULL,
		[ATTR_19]			[nvarchar](50) NULL,
		[ATTR_20]			[nvarchar](50) NULL,
		[ATTR_21]			[nvarchar](1000) NULL,
		[ATTR_22]			[nvarchar](1000) NULL,
		[ATTR_23]			[nvarchar](1000) NULL,
		[ATTR_24]			[nvarchar](1000) NULL,
		[ATTR_25]			[nvarchar](1000) NULL,
		[ATTR_26]			[nvarchar](1000) NULL,
		[ATTR_27]			[nvarchar](1000) NULL,
		[ATTR_28]			[nvarchar](1000) NULL,
		[ATTR_29]			[nvarchar](1000) NULL,
		[ATTR_30]			[nvarchar](1000) NULL
		)  


	--2017-11-10 PIYONG  CURSOR 변경( Plan Release Group 기준으로  RELEASE_PLAN_ID 찾기)
	DECLARE CUR_TARGET_PLAN CURSOR FOR
        SELECT PLAN_ID, FACTORY_ID, INSTANCE_DATE       
          FROM (
				 SELECT B.SITE_ID
					   ,A.INSTANCE_ID
					   ,INSTANCE_DATE
					   ,DIVISION_ID
					   ,B.FACTORY_ID
					   ,A.PLAN_GROUP_ID
					   ,A.RELEASE_PLAN_ID AS PLAN_ID        
					   ,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, INSTANCE_TYPE, A.FACTORY_ID, A.PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION	--2017-11-10 PIYONG PARTITION BY A.PLAN_GROUP_ID ADD
				  FROM [DBO].FP_RELEASE_PLAN_INFO_H  A        
					   ,( SELECT A.[INSTANCE_ID]
								,INSTANCE_TYPE
								,B.SITE_ID
								,B.FACTORY_ID
								,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
								,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
						   FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
								,DBO.SCM_FACTORY_M B WITH(NOLOCK)  
								,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
								LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
											 ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
											AND MP.SEGMENT1 = SLV.SEGMENT1
											AND SLV.ATTRIBUTE1 = 'PLAN GROUP'  
						  WHERE A.FACTORY_ID = B.FACTORY_ID     
							AND A.ACTIVE_FLAG = 'Y'     
							AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
							AND B.SITE_ID = @P_SITE_ID
							AND A.FACTORY_ID = B.FACTORY_ID
							AND A.INSTANCE_ID != 'KR_CELL_M_P' -- KIMCD 2017-08-29
							AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							AND SLV.SEGMENT1 = A.INSTANCE_ID
						--PIYONG 1.6 엑셀 업로드 데이터도 적용 하기 위한 추가
						  UNION ALL
						  SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
							     ,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE  -- KIMCD 2017-08-29
							     ,B.SITE_ID
							     ,B.FACTORY_ID
							     ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
							     ,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
						    FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
							     ,DBO.SCM_FACTORY_M B WITH(NOLOCK)    
							     ,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
								 LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
											  ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
											 AND MP.SEGMENT1 = SLV.SEGMENT1
											 AND SLV.ATTRIBUTE1 = 'PLAN GROUP'  
						  WHERE A.FACTORY_ID = B.FACTORY_ID     
						    AND A.ACTIVE_FLAG = 'Y'     
						    AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
						    AND B.SITE_ID = @P_SITE_ID
						    AND A.FACTORY_ID = B.FACTORY_ID
						    AND A.INSTANCE_ID = 'KR_CELL_M_P'  -- KIMCD 2017-08-29
						    AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
						    AND SLV.SEGMENT1 = A.INSTANCE_ID
					) B      
				WHERE A.INSTANCE_ID = B.INSTANCE_ID
					AND A.FACTORY_ID = B.LINK_FACTORY_ID
					AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
			   ) ZZ       
		 WHERE ZZ.NUMS = 1     
		  AND EXISTS (
						 SELECT SUBSTRING(IF_ID,1,4)
						   FROM [SY_XIF_MES_DAILY_WIP_HISTORY_R] A -- NOLOCK 걸지 않음
							   ,SCM_FACTORY_M B
						  WHERE 1=1
							AND A.PROC_FLAG = 'Y'
							AND A.ACCUM_DATE = CONVERT( NVARCHAR(8), GETDATE(), 112)
						--	and SUBSTRING(IF_ID,1,4) = B.MES_SOURCE_GROUP
						--	AND IF_ID LIKE B.MES_SOURCE_GROUP + '%'
							AND IF_ID = B.MES_SOURCE_GROUP + '_OFP0_DAILY_WIPHISTORY'
							AND B.SITE_ID  = @P_SITE_ID  
							AND B.FACTORY_ID = ZZ.FACTORY_ID
		             )
		  AND NOT EXISTS ( SELECT 1
				             FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
						    WHERE SV.LOOKUP_TYPE_CODE = 'WO_ROLL_EXEC_FLAG'
							AND    SV.SEGMENT1 = @P_SITE_ID  
							AND    SV.SEGMENT2 = ZZ.FACTORY_ID
							AND    SV.ATTRIBUTE1 = CONVERT( NVARCHAR(8), GETDATE(), 112) )
    ;

	SET @ROWCOUNT = @@ROWCOUNT

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
		OPEN CUR_TARGET_PLAN;
		FETCH NEXT FROM CUR_TARGET_PLAN INTO  @plan_id       
											,@FACTORY_ID    
											,@INSTANCE_DATE
										;             

		WHILE (@@FETCH_STATUS = 0)
		BEGIN

		SET @BASE_HOUR = (	
							SELECT TOP 1 CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
							  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
								 , SCM_FACTORY_M F
							 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
							   AND V.ACTIVE_FLAG = 'Y'
							   AND V.SEGMENT1 = F.PLANT_ID
							   AND F.SITE_ID = @P_SITE_ID
							   AND F.FACTORY_ID = @FACTORY_ID
							)


		INSERT INTO DBO.HIS_FP_RELEASE_FIX_PLAN_H (
				    [INSTANCE_ID]
				  , [INSTANCE_DATE]
				  , [RELEASE_PLAN_ID]
				  , [AMEND_PLAN_ID]
				  , [DIVISION_ID]
				  , [FACTORY_ID]
				  , [WORK_ORDER_ID]
				  , [ITEM_ID]
				  , [LINE_ID]
				  , [OPERATION_ID]
				  , [ELECTRODE_TYPE]
				  , [EQUIPMENT_ID]
				  , [FIX_TYPE]
				  , [PLAN_DATE]
				  , [START_TIME]
				  , [END_TIME]
				  , [PLAN_QTY]
				  , [PLAN_IN_QTY]
				  , [PRODUCTION_TYPE]
				  , [MARKET]
				  , [BATCH_ORDER_ID]
				  , [LANE_QTY]
				  , [ACTUAL_FLAG]
				  , [CLOSE_FLAG]
				  , [INSERT_ID]
				  , [INSERT_TIME]
				  , [UPDATE_ID]
				  , [UPDATE_TIME]
				  , [MIN_ACTUAL_DATE]
				  , [RESULT_QTY]
				  , [RESULT_ERP_QTY]
				  , [EXTRA_RESULT_QTY]
				  , [LAST_M_RESULT_QTY]
				  , [PEGGING_RESULT_QTY]
				  , [ADJUST_PLAN_IN_QTY]
				  , [ADJUST_START_TIME]
				  , [JOB_USER_ID]
				  , [JOB_TIME]
				  , [JOB_TYPE]
		          )
		     SELECT [INSTANCE_ID]
				  , [INSTANCE_DATE]
				  , [RELEASE_PLAN_ID]
				  , [AMEND_PLAN_ID]
				  , [DIVISION_ID]
				  , [FACTORY_ID]
				  , [WORK_ORDER_ID]
				  , [ITEM_ID]
				  , [LINE_ID]
				  , [OPERATION_ID]
				  , [ELECTRODE_TYPE]
				  , [EQUIPMENT_ID]
				  , [FIX_TYPE]
				  , [PLAN_DATE]
				  , [START_TIME]
				  , [END_TIME]
				  , [PLAN_QTY]
				  , [PLAN_IN_QTY]
				  , [PRODUCTION_TYPE]
				  , [MARKET]
				  , [BATCH_ORDER_ID]
				  , [LANE_QTY]
				  , [ACTUAL_FLAG]
				  , [CLOSE_FLAG]
				  , [INSERT_ID]
				  , [INSERT_TIME]
				  , [UPDATE_ID]
				  , [UPDATE_TIME]
				  , [MIN_ACTUAL_DATE]
				  , [RESULT_QTY]
				  , [RESULT_ERP_QTY]
				  , [EXTRA_RESULT_QTY]
				  , [LAST_M_RESULT_QTY]
				  , [PEGGING_RESULT_QTY]
				  , [ADJUST_PLAN_IN_QTY]
				  , [ADJUST_START_TIME]
				  , 'PR_SCM_WO_ROLLING'
				  , GETDATE()
				  , 'INSERT'
		       FROM FP_RELEASE_FIX_PLAN_H
			  WHERE RELEASE_PLAN_ID  = @plan_id
			    AND FACTORY_ID	    = @FACTORY_ID	


			-- 초기화                
			update FP_RELEASE_FIX_PLAN_H                
			   set RESULT_QTY = null                
				 , PEGGING_RESULT_QTY = null                 
			     , ADJUST_PLAN_IN_QTY = null               
				 , ADJUST_START_TIME = null    
				 , EXTRA_RESULT_QTY = null -- Release 한 WO 이외의 WO로 실적이 수신된 수량
				 , LAST_M_RESULT_QTY = null -- 달이 바뀌는 경우에 전달의 실적 수량
			 where RELEASE_PLAN_ID  = @plan_id
			   AND FACTORY_ID	    = @FACTORY_ID	
			;

			-- WO 실적 update                
			update FP_RELEASE_FIX_PLAN_H                
			   set RESULT_QTY = (
								SELECT SUM(WIPQTY2_ED) PROD_RESULT             
								  FROM DBO.SCM_MES_WIP_HISTORY_H A WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))
								 WHERE A.WOID = FP_RELEASE_FIX_PLAN_H.WORK_ORDER_ID      
								   AND A.PROCID = FP_RELEASE_FIX_PLAN_H.OPERATION_ID
								   AND A.WIP_TYPE_CODE IN ( 'OUT','INOUT','PACKED', 'PROD' )	-- PIYONG 2017-08-25 PROD 추가
								   AND CAST(WIPDTTM_ED AS DATETIME) > CAST( FP_RELEASE_FIX_PLAN_H.INSTANCE_DATE + @BASE_HOUR AS DATETIME) -- 각 PLANT 별 마감시긴 이후
								)             
				 , LAST_M_RESULT_QTY = (                
										SELECT SUM(WIPQTY2_ED) PROD_RESULT             
										  FROM DBO.SCM_MES_WIP_HISTORY_H A WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))
										 WHERE A.WOID = FP_RELEASE_FIX_PLAN_H.WORK_ORDER_ID 
										   AND A.PROCID = FP_RELEASE_FIX_PLAN_H.OPERATION_ID        
										   AND A.WIP_TYPE_CODE IN ( 'OUT','INOUT','PACKED', 'PROD' ) 	-- PIYONG 2017-08-25 PROD 추가        
									--     AND CAST(WIPDTTM_ED AS DATETIME) > CAST( FP_RELEASE_FIX_PLAN_H.INSTANCE_DATE +' '+@BASE_HOUR+':00:00'  AS DATETIME) -- 각 SITE 별 마감시긴 이후
										   AND CAST(WIPDTTM_ED AS DATETIME) < CAST ( CONVERT(VARCHAR(10), DATEADD(S,-1,DATEADD(MM,DATEDIFF(M,0,GETDATE())+0,1)),112) + @BASE_HOUR  AS DATETIME) -- 이번달 1일 이전 실적값.
									)             
				 , insert_time = getdate()                
				 , INSERT_ID = 'RESULT_UPDATE'
				 , UPDATE_TIME = GETDATE()
				 , UPDATE_ID = 'PR_SCM_WO_ROLLING'
			 where RELEASE_PLAN_ID  = @plan_id
			   AND FACTORY_ID	    = @FACTORY_ID	
			;
			 
			-- Pegging 1차 처리 pegging result qty 를 update                
			update FP_RELEASE_FIX_PLAN_H                
			set PEGGING_RESULT_QTY = case when RESULT_QTY > plan_in_qty then plan_in_qty                
											else RESULT_QTY
										end
				,UPDATE_TIME = GETDATE()
				,UPDATE_ID = 'PR_SCM_WO_ROLLING'
			where RELEASE_PLAN_ID  = @plan_id
			AND FACTORY_ID	    = @FACTORY_ID             
			and RESULT_QTY is not null                
			;
			 
			-- WO Mapping 안되는 실적 update
			select substring(a.eqsgid, 1,2) factory_id, a.PRODID, a.PROCID,  sum(wipqty2_ed) extra_prod_result ,
																										(
																											select min(work_order_id)
																												from FP_RELEASE_FIX_PLAN_H z
																												where z.RELEASE_PLAN_ID = @plan_id
																												and z.ITEM_ID = a.prodid
																												and z.OPERATION_ID = a.PROCID
																												and z.FACTORY_ID   = substring(a.eqsgid, 1,2)
																										) MIN_WORKORDER_ID   
			    into #temp_extra_table        
				from dbo.SCM_MES_WIP_HISTORY_H a  WITH(NOLOCK)         
			where a.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD' )  	-- PIYONG 2017-08-25 PROD 추가
				and substring(a.eqsgid, 1,2) = @FACTORY_ID -- factory
				--2017-07-13 PIYONG ADD 
				and cast(a.WIPDTTM_ED as datetime) > cast( @INSTANCE_DATE + @BASE_HOUR  as datetime) -- 각 PLANT 별 마감시긴 이후
				and (
					select count(1)
						from FP_RELEASE_FIX_PLAN_H z
						where z.RELEASE_PLAN_ID = @plan_id
						and z.WORK_ORDER_ID = a.WOID
					)  = 0 
			group by substring(a.eqsgid, 1,2), a.PRODID, a.PROCID			 
			;


			update FP_RELEASE_FIX_PLAN_H                
			set EXTRA_RESULT_QTY = (            
						                select x.extra_prod_result         
						                    from #temp_extra_table x         
								        where FP_RELEASE_FIX_PLAN_H.WORK_ORDER_ID = x.MIN_WORKORDER_ID       
									)
				,UPDATE_TIME = GETDATE()
				,UPDATE_ID = 'PR_SCM_WO_ROLLING'
			where WORK_ORDER_ID in (                 
						            select x.MIN_WORKORDER_ID         
						            from #temp_extra_table x         
								    where FP_RELEASE_FIX_PLAN_H.WORK_ORDER_ID = x.MIN_WORKORDER_ID       
									)               
                and RELEASE_PLAN_ID  = @plan_id
			    AND FACTORY_ID	      = @FACTORY_ID      										   
			;                
			  			     		

			-- Pegging 2차 처리 over_completion 된 수량에 대해서 다른 WO로 pegging 햘당    	 
			select INSTANCE_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, SUM (( ISNULL(RESULT_QTY,0) - ISNULL(PEGGING_RESULT_QTY,0) ) + ISNULL(EXTRA_RESULT_QTY,0) ) ove_compl_qty                
			into #temp_result_table                
			from FP_RELEASE_FIX_PLAN_H                
			where RELEASE_PLAN_ID  = @plan_id
			AND FACTORY_ID	    = @FACTORY_ID                 
			and (  ( RESULT_QTY is not null and RESULT_QTY > PEGGING_RESULT_QTY ) OR (  EXTRA_RESULT_QTY is not null ) )
			group by INSTANCE_ID, FACTORY_ID, ITEM_ID, OPERATION_ID                
			;            


			select w.*                
				,sum( plan_in_qty - ISNULL(PEGGING_RESULT_QTY,0) ) over ( partition by w.INSTANCE_ID, w.FACTORY_ID, w.ITEM_ID, w.OPERATION_ID order by w.start_time, w.production_type,WORK_ORDER_ID) accum_need_qty                
				,row_number()  over ( partition by w.INSTANCE_ID, w.FACTORY_ID, w.ITEM_ID, w.OPERATION_ID order by w.start_time, w.production_type,WORK_ORDER_ID) row_seq               
				,i.ove_compl_qty               
				,case when sum( plan_in_qty - ISNULL(PEGGING_RESULT_QTY,0) ) over ( partition by w.INSTANCE_ID, w.FACTORY_ID, w.ITEM_ID, w.OPERATION_ID order by w.start_time, w.production_type,WORK_ORDER_ID) - i.ove_compl_qty <= 0 THEN 'ENOUGH' ELSE 'SHORT' END statuss               
				,sum( plan_in_qty - ISNULL(PEGGING_RESULT_QTY,0) ) over ( partition by w.INSTANCE_ID, w.FACTORY_ID, w.ITEM_ID, w.OPERATION_ID order by w.start_time, w.production_type,WORK_ORDER_ID) - ( plan_in_qty - ISNULL(PEGGING_RESULT_QTY,0) )  last_accum_need_qty               
				,case when ( sum( plan_in_qty - ISNULL(PEGGING_RESULT_QTY,0) ) over ( partition by w.INSTANCE_ID, w.FACTORY_ID, w.ITEM_ID, w.OPERATION_ID order by w.start_time, w.production_type,WORK_ORDER_ID) - ( plan_in_qty - ISNULL(PEGGING_RESULT_QTY,0) )  - i.ove_compl_qty )   <= 0 THEN 'ENOUGH' ELSE 'SHORT' END last_statuss               
			into #temp_result2_table  
			from FP_RELEASE_FIX_PLAN_H w                
				,#temp_result_table i                
			where w.RELEASE_PLAN_ID  = @plan_id
			AND w.FACTORY_ID	    = @FACTORY_ID   
			and w.item_id = i.ITEM_ID                
			and w.OPERATION_ID = i.OPERATION_ID                
			and w.INSTANCE_ID = i.INSTANCE_ID                
			and w.FACTORY_ID = i.FACTORY_ID    
			;	
							 
			-- plan_in_qty 만큼 Pegging 숫자를 update 해야 할 대상              
			update FP_RELEASE_FIX_PLAN_H                
			set PEGGING_RESULT_QTY = PLAN_IN_QTY
				,UPDATE_TIME = GETDATE()
				,UPDATE_ID = 'PR_SCM_WO_ROLLING'
			where WORK_ORDER_ID in (                 
									select x.WORK_ORDER_ID         
										from #temp_result2_table x         
										where FP_RELEASE_FIX_PLAN_H.WORK_ORDER_ID = x.WORK_ORDER_ID                
										and FP_RELEASE_FIX_PLAN_H.RELEASE_PLAN_ID = x.RELEASE_PLAN_ID         
										and x.statuss = 'ENOUGH'         
									)             
            AND RELEASE_PLAN_ID = @plan_id
			AND FACTORY_ID	    = @FACTORY_ID     									     
			;                
			     		
							   	
			-- short 수량에 대해서는 잔여 수량에 대해서만 Pegging 숫자를 update 해줌     
			update FP_RELEASE_FIX_PLAN_H                
			set PEGGING_RESULT_QTY = ISNULL(PEGGING_RESULT_QTY, 0) + (                 
																		select ove_compl_qty - x.last_accum_need_qty
																			from #temp_result2_table x
																		where FP_RELEASE_FIX_PLAN_H.WORK_ORDER_ID   = x.WORK_ORDER_ID
																			and FP_RELEASE_FIX_PLAN_H.RELEASE_PLAN_ID = x.RELEASE_PLAN_ID
																			and FP_RELEASE_FIX_PLAN_H.FACTORY_ID      = x.FACTORY_ID
																		)
					,UPDATE_TIME = GETDATE()
				    ,UPDATE_ID = 'PR_SCM_WO_ROLLING'
			where WORK_ORDER_ID in (                 
									select x.WORK_ORDER_ID         
										from #temp_result2_table x         
										where FP_RELEASE_FIX_PLAN_H.WORK_ORDER_ID    = x.WORK_ORDER_ID                
										and FP_RELEASE_FIX_PLAN_H.RELEASE_PLAN_ID  = x.RELEASE_PLAN_ID         
										and x.statuss                              = 'SHORT'         
										and x.last_statuss                         = 'ENOUGH'         
									)    
            AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )	  -- close 된것에 대해서는 Adjust 대상에서 제외	
			AND RELEASE_PLAN_ID = @plan_id
			AND FACTORY_ID	    = @FACTORY_ID     									     							              
			;                


		-- Adjust_plan_in_qty, Adjust_start_time 값을 update 함.     
		-- 과거인 경우에는 WO 일자를 금일자 마감시간으로 변경함.           
			update FP_RELEASE_FIX_PLAN_H                
			SET ADJUST_START_TIME = cast( substring( convert( varchar, getdate(), 120 ) , 1, 10 ) + @BASE_HOUR as datetime) -- 당일 마감시간 기준으로 변경 함.                
				-- 과거거에 대해서는                 
				,ADJUST_PLAN_IN_QTY = plan_in_qty - ISNULL( PEGGING_RESULT_QTY, 0 )
				,UPDATE_TIME = GETDATE()
				,UPDATE_ID = 'PR_SCM_WO_ROLLING'                
			WHERE RELEASE_PLAN_ID  = @plan_id
			AND FACTORY_ID	    = @FACTORY_ID   
			-- Pegging 기준으로 생산 잔량이 남거나, Pegging 기준으로 잔량은 없으나 WO 계획 수량보다 실적이 작은 경우에는 WO 일자와 시간을 변경해야 함.
			AND ( plan_in_qty > ISNULL( PEGGING_RESULT_QTY, 0 )  OR ( plan_in_qty = ISNULL( PEGGING_RESULT_QTY, 0 ) AND ISNULL(result_qty,0)  < plan_in_qty ) )
			--AND substring( convert( varchar, START_TIME, 120 ) , 1, 10 ) < substring( convert( varchar, getdate(), 120 ) , 1, 10 ) -- 금일 이전               
			AND START_TIME < cast( substring( convert( varchar, getdate(), 120 ) , 1, 10 ) + @BASE_HOUR as datetime)  -- 금일 이전               
			AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )  -- close 된것에 대해서는 Adjust 대상에서 제외
			;             
			-- Adjust_plan_in_qty, Adjust_start_time 값을 update 함.                
			-- 미래 ( 오늘 이후)에 대해서는 Pegging 값을 가지고 수량을 줄여줌.                 
			update FP_RELEASE_FIX_PLAN_H                
			SET ADJUST_PLAN_IN_QTY = plan_in_qty - ISNULL( PEGGING_RESULT_QTY, 0 )  
				,ADJUST_START_TIME = START_TIME
				,UPDATE_TIME = GETDATE()
				,UPDATE_ID = 'PR_SCM_WO_ROLLING'              
			WHERE RELEASE_PLAN_ID  = @plan_id
			AND FACTORY_ID	     = @FACTORY_ID 
			and ISNULL( PEGGING_RESULT_QTY, 0 ) > 0 
			and ISNULL(result_qty,0) < ISNULL( PEGGING_RESULT_QTY, 0 )                
			-- and substring( convert( varchar, START_TIME, 120 ) , 1, 10 ) >= substring( convert( varchar, getdate(), 120 ) , 1, 10 )   
			AND START_TIME >= cast( substring( convert( varchar, getdate(), 120 ) , 1, 10 ) + @BASE_HOUR as datetime)  -- 금일 이전               
			AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )  -- close 된것에 대해서는 Adjust 대상에서 제외             
			;     
					
        -- 변경처리를 해야 하는 대상 선정 

			SELECT *
			INTO #TEMP_RESULT3_TABLE
			FROM (
				SELECT RELEASE_PLAN_ID, WORK_ORDER_ID, ITEM_ID, LINE_ID, OPERATION_ID, ADJUST_PLAN_IN_QTY, ADJUST_START_TIME, 'TODAY' TYPE, A.DIVISION_ID, @P_SITE_ID SITE_ID , A.EQUIPMENT_ID, A.FACTORY_ID
						,(
							SELECT COUNT(DISTINCT WO_DETAIL)
							FROM DBO.SY_XIF_MES_WO_S Z  WITH(NOLOCK)
							WHERE Z.PLAN_ID = A.RELEASE_PLAN_ID
							AND Z.WO = A.WORK_ORDER_ID
							AND z.OPERATION_ID = a.OPERATION_ID
						) DETAIL_COUNT
					FROM FP_RELEASE_FIX_PLAN_H  A  WITH(NOLOCK)
				WHERE RELEASE_PLAN_ID  = @PLAN_ID
					AND FACTORY_ID	   = @FACTORY_ID 
					AND PLAN_IN_QTY    > ISNULL(RESULT_QTY,0)                                     -- OVERCOMPLETION 된것은 추가 전송하지 않음.
					AND CONVERT( VARCHAR, ADJUST_START_TIME, 112 ) = CONVERT( VARCHAR, GETDATE(), 112 )   
					AND ADJUST_START_TIME IS NOT NULL
					AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )
					AND @RUN_TYPE = 'ADVANCED'
				-- kimcd 2017-06-24 당월 조건 제거 and month(cast( instance_date +' '+@BASE_HOUR+':00:00'  as datetime)) = month(getdate()) -- 당월 내 Release 및 처리
				UNION ALL
				SELECT RELEASE_PLAN_ID, WORK_ORDER_ID, ITEM_ID, LINE_ID, OPERATION_ID, ADJUST_PLAN_IN_QTY, ADJUST_START_TIME, 'FUTURE' TYPE, A.DIVISION_ID, @P_SITE_ID SITE_ID , A.EQUIPMENT_ID, A.FACTORY_ID
						,(
							SELECT COUNT(DISTINCT WO_DETAIL)
							FROM DBO.SY_XIF_MES_WO_S Z  WITH(NOLOCK)
							WHERE Z.PLAN_ID = A.RELEASE_PLAN_ID
							AND Z.WO = A.WORK_ORDER_ID
							AND z.OPERATION_ID = a.OPERATION_ID
						) DETAIL_COUNT
					FROM FP_RELEASE_FIX_PLAN_H A  WITH(NOLOCK)
					WHERE RELEASE_PLAN_ID  = @PLAN_ID
					AND FACTORY_ID	   = @FACTORY_ID 
					AND PLAN_IN_QTY      <> ISNULL(ADJUST_PLAN_IN_QTY,0)                          -- 수량 변경이 있는 WO
					AND PLAN_IN_QTY    > ISNULL(RESULT_QTY, 0)                                    -- OVERCOMPLETION 된것은 추가 전송하지 않음.
					AND CONVERT( VARCHAR, START_TIME, 112 ) > CONVERT( VARCHAR, GETDATE(), 112 )  -- 당일 이후이면서  
					AND ADJUST_START_TIME IS NOT NULL
					AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )
					AND @RUN_TYPE = 'ADVANCED'
				/* kimcd 2017-06-24 전월 로직 제거
				UNION ALL
				SELECT RELEASE_PLAN_ID, WORK_ORDER_ID, ITEM_ID, LINE_ID, OPERATION_ID, ADJUST_PLAN_IN_QTY, ADJUST_START_TIME, 'TODAY' TYPE, A.DIVISION_ID, @P_SITE_ID SITE_ID , A.EQUIPMENT_ID, A.FACTORY_ID
						,(
							SELECT COUNT(DISTINCT WO_DETAIL)
							FROM DBO.SY_XIF_MES_WO_S Z  WITH(NOLOCK)
							WHERE Z.PLAN_ID = A.RELEASE_PLAN_ID
							AND Z.WO = A.WORK_ORDER_ID
							AND z.OPERATION_ID = a.OPERATION_ID
						) DETAIL_COUNT
					FROM FP_RELEASE_FIX_PLAN_H  A  WITH(NOLOCK)
				WHERE RELEASE_PLAN_ID  = @PLAN_ID
					AND FACTORY_ID	   = @FACTORY_ID 
					AND PLAN_IN_QTY    > ISNULL(RESULT_QTY,0)                                     -- OVERCOMPLETION 된것은 추가 전송하지 않음.
					AND CONVERT( VARCHAR, ADJUST_START_TIME, 112 ) = CONVERT( VARCHAR, GETDATE(), 112 )   
					AND ADJUST_START_TIME IS NOT NULL
					AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )
					AND LAST_M_RESULT_QTY IS NULL                        -- 전월 실적이 있는 WO에 대해서는 다음날로 넘기지 않음.
					AND @RUN_TYPE = 'ADVANCED'
					and month(cast( instance_date +' '+@BASE_HOUR+':00:00'  as datetime)) <> month(getdate()) -- 전월 Release 시 처리
					*/
				UNION ALL
				-- Basic 은 Pegging을 하지 않기 때문에 WO 별로 과거일자인 것을 오늘자로만 변경 함.
				SELECT RELEASE_PLAN_ID
						, WORK_ORDER_ID
						, ITEM_ID, LINE_ID
						, OPERATION_ID
						, ADJUST_PLAN_IN_QTY
						, cast( substring( convert( varchar, getdate(), 120 ) , 1, 10 ) + @BASE_HOUR as datetime ) ADJUST_START_TIME
						, 'TODAY' TYPE
						, A.DIVISION_ID
						, @P_SITE_ID SITE_ID
						, A.EQUIPMENT_ID
						, A.FACTORY_ID
						,(
							SELECT COUNT(DISTINCT WO_DETAIL)
								FROM DBO.SY_XIF_MES_WO_S Z  WITH(NOLOCK)
								WHERE Z.PLAN_ID = A.RELEASE_PLAN_ID
								AND Z.WO = A.WORK_ORDER_ID
								AND z.OPERATION_ID = a.OPERATION_ID
							) DETAIL_COUNT
					FROM FP_RELEASE_FIX_PLAN_H  A  WITH(NOLOCK)
					WHERE RELEASE_PLAN_ID  = @PLAN_ID
					AND FACTORY_ID	   = @FACTORY_ID 
					AND PLAN_IN_QTY    > ISNULL(RESULT_QTY,0)                                     -- 잔량이 있는 WO 선정
					AND CONVERT( VARCHAR, START_TIME, 112 ) < CONVERT( VARCHAR, GETDATE(), 112 )  -- Pegging 정보로 만들어진 시간이 아닌 최초 WO 시간을 기준으로 과거이면서 잔량이 있는 WO 처리
					AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )
					AND @RUN_TYPE = 'BASIC'
				-- kimcd 2017-06-24 당월 조건 제거	and month(cast( instance_date +' '+@BASE_HOUR+':00:00'  as datetime)) = month(getdate()) -- 당월 내 Release 및 처리
				/* block kimcd 2017-06-24 전월 로직
				UNION ALL
				SELECT RELEASE_PLAN_ID, WORK_ORDER_ID, ITEM_ID, LINE_ID, OPERATION_ID, ADJUST_PLAN_IN_QTY, cast( substring( convert( varchar, getdate(), 120 ) , 1, 10 ) + ' '+@BASE_HOUR+':00:00' as datetime) ADJUST_START_TIME, 'TODAY' TYPE, A.DIVISION_ID, @P_SITE_ID SITE_ID , A.EQUIPMENT_ID, A.FACTORY_ID
						,(
							SELECT COUNT(DISTINCT WO_DETAIL)
							FROM DBO.SY_XIF_MES_WO_S Z  WITH(NOLOCK)
							WHERE Z.PLAN_ID = A.RELEASE_PLAN_ID
							AND Z.WO = A.WORK_ORDER_ID
							AND z.OPERATION_ID = a.OPERATION_ID
						) DETAIL_COUNT
					FROM FP_RELEASE_FIX_PLAN_H  A  WITH(NOLOCK)
				WHERE RELEASE_PLAN_ID  = @PLAN_ID
					AND FACTORY_ID	   = @FACTORY_ID 
					AND CONVERT( VARCHAR, START_TIME, 112 ) < CONVERT( VARCHAR, GETDATE(), 112 )  -- Pegging 정보로 만들어진 시간이 아닌 최초 WO 시간을 기준으로 과거이면서 잔량이 있는 WO 처리
					AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )
					AND LAST_M_RESULT_QTY IS NULL  -- 전월이면서 실적이 없는것에 대해서만 이월 시킴,
					AND @RUN_TYPE = 'BASIC'
					and month(cast( instance_date +' '+@BASE_HOUR+':00:00'  as datetime)) <> month(getdate()) -- Release 일자와 Rolling 일자의 Month가 다른 경우에 처리
					*/
			) ZZ
			;

			SET @SEQ = NEXT VALUE FOR RELEASE_PLAN

			-- ERP 전송 WO 정보 생성
			insert into DBO.SY_XIF_ERP_PRODUCTION_PLAN_S 
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
			select 
					REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]     
					,row_number() over ( order by a.line_id, a.item_id) --[SEQ]      ,row_number() over ( order by line_id, item_id) --[SEQ]
					,a.FP_PLAN_ID + '_ADJ_'+ cast( @SEQ as varchar )
					,a.[PLANT_ID]
					,a.[FACTORY_ID]
					,a.[LINE_ID]
					,a.[OPERATION_ID]
					,a.[BOM_VERSION_ID]
					,a.[WORK_CENTER_ID]
					,a.[ITEM_ID]
					,a.[DEMAND_ID]
					,a.[WORK_ORDER_ID]
					,a.[ORDER_TYPE]
					,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),ADJUST_START_TIME ,120),'-',''),':',''),' ','') -- [PLAN_DATE]
					,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),ADJUST_START_TIME ,120),'-',''),':',''),' ','') -- [START_TIME]
					,CASE WHEN type = 'TODAY' THEN REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),dateadd(mi,10,ADJUST_START_TIME) ,120),'-',''),':',''),' ','') ELSE END_TIME END-- [END_TIME]
					,ADJUST_PLAN_IN_QTY + ISNULL(
												(
													SELECT ISNULL( SUM(ISNULL(WIPQTY2_ED,0)) 
																+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_DFCT_QTY2),0)) 
																+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_LOSS_QTY2),0)) 
																+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_PRDT_REQ_QTY2),0))
																+ SUM(ISNULL(CAST( W.SCRAP_QTY AS NUMERIC(14,3)),0))
															,0)
													FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))        
													WHERE W.WOID = A.[WORK_ORDER_ID]         
													AND W.PROCID = A.OPERATION_ID
													AND W.WIP_TYPE_CODE IN ( 'OUT','INOUT','PACKED', 'PROD' )	-- PIYONG 2017-08-25 PROD 추가
												)
												,0)							 -- + WO 실적 수량 [PLAN_IN_QTY] -- 수량 변경 필요
					,ADJUST_PLAN_IN_QTY + ISNULL(
												(
													SELECT ISNULL(SUM(ISNULL(WIPQTY2_ED,0))
															+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_DFCT_QTY2),0)) 
															+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_LOSS_QTY2),0)) 
															+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_PRDT_REQ_QTY2),0))
															+ SUM(ISNULL(CAST( W.SCRAP_QTY AS NUMERIC(14,3)),0))
															,0)
													FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))         
													WHERE W.WOID = A.[WORK_ORDER_ID] 
													AND W.PROCID = A.OPERATION_ID        
													AND W.WIP_TYPE_CODE IN ( 'OUT','INOUT','PACKED', 'PROD' )	-- PIYONG 2017-08-25 PROD 추가
												)
												,0) -- + WO 실적 수량 [PLAN_QTY]    -- 수량 변경 필요
					,[FIX_TYPE]
					,'N' --[TRANSFER_FLAG]
					,[TRANSFER_DATE]
					,A.[CREATE_USER_ID]
					,A.[CREATE_DATE]
					,'WO_ROLLING' -- [MODIFY_USER_ID]
					,getdate() -- [MODIFY_DATE]
					,[LANE_QTY]
					,[BATCH_ORDER_ID]
					,[SLITTER_PLANT]
					,[MARKET]
					,A.[ATTRIBUTE1]
					,A.[ATTRIBUTE2]
					,A.[ATTRIBUTE3]
					,A.[ATTRIBUTE4]
					,A.[ATTRIBUTE5]
					,A.[ATTRIBUTE6]
					,A.[ATTRIBUTE7]
					,A.[ATTRIBUTE8]
					,[PLAN_IN_QTY]
					,[PLAN_QTY]
					,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
								'B'
							END AS TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
					,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
							CASE WHEN SUBSTRING(A.WORK_ORDER_ID,7,1) = 'X' THEN
									SUBSTRING(A.WORK_ORDER_ID,1,6) + 'Y' + SUBSTRING(A.WORK_ORDER_ID,8,10)
									ELSE
									CASE WHEN A.WORK_ORDER_ID LIKE 'W%' OR A.WORK_ORDER_ID LIKE 'M%' THEN
											SUBSTRING(A.WORK_ORDER_ID,1,6) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(A.WORK_ORDER_ID,7,2)) + 50) + SUBSTRING(A.WORK_ORDER_ID,9,10)
											ELSE
											SUBSTRING(A.WORK_ORDER_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(A.WORK_ORDER_ID,6,2)) + 50) + SUBSTRING(A.WORK_ORDER_ID,8,10)
											END
									END
								END AS LINK_WO      -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
					,A.PLAN_IN_QTY AS FP_PLAN_QTY  -- FP PLAN 수량
					,ISNULL(
							(
								SELECT ISNULL( SUM(ISNULL(MWH.WIPQTY2_ED,0))
												+ SUM(ISNULL(CONVERT(NUMERIC(14,3), MWH.CNFM_DFCT_QTY2),0)) 
												+ SUM(ISNULL(CONVERT(NUMERIC(14,3), MWH.CNFM_LOSS_QTY2),0)) 
												+ SUM(ISNULL(CONVERT(NUMERIC(14,3), MWH.CNFM_PRDT_REQ_QTY2),0))
												+ SUM(ISNULL(CAST( MWH.SCRAP_QTY AS NUMERIC(14,3)),0))
										,0)
								FROM [DBO].SCM_MES_WIP_HISTORY_H MWH WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))
								WHERE MWH.WOID			= A.WORK_ORDER_ID
								AND MWH.PROCID			= A.OPERATION_ID
								AND MWH.WIP_TYPE_CODE IN ( 'OUT','INOUT','PACKED', 'PROD' ) 	-- PIYONG 2017-08-25 PROD 추가        
								AND MWH.PRODID			= A.ITEM_ID
							)
							,0) AS FP_SNAP_QTY  -- FP 실적 수량
					,TECO_IND	
				FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S A
					,#temp_result3_table B
				LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
					ON EQP.EQUIPMENT_ID = B.EQUIPMENT_ID
				AND EQP.OPERATION_ID = B.OPERATION_ID
				AND EQP.FACTORY_ID   = B.FACTORY_ID
				AND EQP.EQUIPMENT_TYPE = 'M'
				AND EQP.ACTIVE_FLAG    = 'Y'
				LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
					ON EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
				AND EQPC.SEGMENT1         = EQP.OPERATION_ID
				AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
				AND EQPC.ACTIVE_FLAG      = 'Y'
				LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
					ON IM.DIVISION_ID  = B.DIVISION_ID
				AND IM.SITE_ID      = B.SITE_ID
				AND IM.ITEM_ID      = B.ITEM_ID
				LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
					ON IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
				AND IMC.SEGMENT1         = IM.ITEM_CLASS
				AND IMC.ACTIVE_FLAG      = 'Y' 
				WHERE A.WORK_ORDER_ID = B.WORK_ORDER_ID
				AND A.FP_PLAN_ID = B.RELEASE_PLAN_ID
				;


			INSERT INTO [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S]
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
					,[FP_SNAP_QTY]) -- FP 실적 수량
			SELECT  REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]
					,2000 + ROW_NUMBER() OVER( ORDER BY A.[FP_PLAN_ID], A.[PLANT_ID], A.[FACTORY_ID], A.[LINE_ID], A.[OPERATION_ID], A.[ITEM_ID], A.[WORK_ORDER_ID] ) AS SEQ
					,A.[FP_PLAN_ID]
					,A.[PLANT_ID]
					,A.[FACTORY_ID]
					,A.[LINE_ID]
					,A.[OPERATION_ID]
					,A.[BOM_VERSION_ID]
					,A.[WORK_CENTER_ID]
					,A.[ITEM_ID]
					,A.[DEMAND_ID]
					,A.[LINK_WO]    -- [WORK_ORDER_ID]
					,A.[ORDER_TYPE]
					,A.[PLAN_DATE]
					,A.[START_TIME]
					,A.[END_TIME]
					,A.[PLAN_IN_QTY]
					,A.[PLAN_QTY]
					,A.[FIX_TYPE]
					,A.[TRANSFER_FLAG]
					,A.[TRANSFER_DATE]
					,A.[CREATE_USER_ID]
					,A.[CREATE_DATE]
					,A.[MODIFY_USER_ID]
					,A.[MODIFY_DATE]
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
					,A.[ATTRIBUTE9]
					,A.[ATTRIBUTE10]
					,'T'               -- [TOP_BACK_IND] 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
					,A.[WORK_ORDER_ID] -- [LINK_WO] 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
					,A.[FP_PLAN_QTY]   -- FP Plan 수량
					,A.[FP_SNAP_QTY]   -- FP 실적 수량
			FROM    [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] A WITH(NOLOCK)
			WHERE   A.[FP_PLAN_ID] IN  (SELECT B.RELEASE_PLAN_ID + '_ADJ_'+ cast( @SEQ as varchar )
											FROM #temp_result3_table B )
			AND     A.[TOP_BACK_IND] = 'B';


			-- MES 전송 WO 정보 생성
			insert into @XIF_MES_WO_S
					  ( [IF_SEQ]                                                                                                                                                                                                                                  
					  , [IF_TYPE]                                                                                                                                                                                                                                   
					  , [IF_ID]                                                                                                                                                                                                                                     
					  , [IF_INS_DATE]                                                                                                                                                                                                                               
					  , [IF_FLAG]                                                                                                                                                                                                                                   
					  , [IF_SND_DATE]                                                                                                                                                                                                                               
					  , [RSLT_IF_SEQ]                                                                                                                                                                                                                               
					  , [RSLT_PROC_FLAG]                                                                                                                                                                                                                            
					  , [RSLT_PROC_MSG]                                                                                                                                                                                                                             
					  , [PLAN_ID]                                                                                                                                                                                                                                   
					  , [PLANT_ID]                                                                                                                                                                                                                                  
					  , [BUILNO]                                                                                                                                                                                                                                    
					  , [LINE_ID]                                                                                                                                                                                                                                   
					  , [OPERATION_ID]                                                                                                                                                                                                                              
					  , [EQUIPMENT_ID]                                                                                                                                                                                                                              
					  , [ITEM_ID]                                                                                                                                                                                                                                   
					  , [DEMAND_ID]                                                                                                                                                                                                                                 
					  , [WO]                                                                                                                                                                                                                                        
					  , [WO_TYPE]                                                                                                                                                                                                                                   
					  , [WO_DETAIL]                                                                                                                                                                                                                                 
					  , [PLAN_DATE]                                                                                                                                                                                                                                 
					  , [START_TIME]                                                                                                                                                                                                                                
					  , [END_TIME]                                                                                                                                                                                                                                  
					  , [IN_QTY]                                                                                                                                                                                                                                    
					  , [OUT_QTY]                                                                                                                                                                                                                                   
					  , [IS_RELEASE]                                                                                                                                                                                                                                
					  , [CREATE_PSN_ID]                                                                                                                                                                                                                             
					  , [CREATE_DATE]                                                                                                                                                                                                                               
					  , [UPDATE_PSN_ID]                                                                                                                                                                                                                             
					  , [UPDATE_DATE]                                                                                                                                                                                                                               
					  , [LANE_QTY]                                                                                                                                                                                                                                  
					  , [UNIT]                                                                                                                                                                                                                                      
					  , [ORDER_TYPE]    
					  , [BATCH_ORDER_ID]
					  , [SLITTER_PLANT]
					  , [MARKET]
					  , [ATTR_01]
					  , [ATTR_02]
					  , [ATTR_03]
					  , [ATTR_04]
					  , [ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
					  , [ATTR_06] -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
					  , [ATTR_07] -- 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
					  , [ATTR_08] -- FP PLAN 수량
					  , [ATTR_09] -- FP 실적 수량
					  , [ATTR_10] )
			select 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ      ,[IF_TYPE]
					,'S'
					,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = SOURCES.[BUILNO] ),'') +'_'+'FP_WO' -- [IF_ID]
					,[IF_INS_DATE]
					,'N' --[IF_FLAG]
					,[IF_SND_DATE]
					,null -- [RSLT_IF_SEQ]
					,null--[RSLT_PROC_FLAG]
					,null--[RSLT_PROC_MSG]
					,SOURCES.PLAN_ID + '_ADJ_'+ cast( @SEQ as varchar )
					,SOURCES.[PLANT_ID]
					,SOURCES.[BUILNO]
					,SOURCES.[LINE_ID]
					,SOURCES.[OPERATION_ID]
					,SOURCES.[EQUIPMENT_ID]
					,SOURCES.[ITEM_ID]
					,SOURCES.[DEMAND_ID]
					,SOURCES.[WO]
					,SOURCES.[WO_TYPE]
					,SOURCES.[WO_DETAIL]
					,CONVERT(NVARCHAR(50), ADJUST_START_TIME, 120) -- [PLAN_DATE]
					,CONVERT(NVARCHAR(50), ADJUST_START_TIME, 120) -- [START_TIME]
					,CASE WHEN type = 'TODAY' THEN CONVERT(NVARCHAR(50), dateadd(mi,10,ADJUST_START_TIME), 120) ELSE END_TIME END --[END_TIME]
					,ADJUST_PLAN_IN_QTY/DETAIL_COUNT + ISNULL(
																(
																	SELECT ISNULL( SUM(ISNULL(WIPQTY2_ED,0))
																				+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_DFCT_QTY2),0)) 
																				+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_LOSS_QTY2),0)) 
																				+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_PRDT_REQ_QTY2),0))
																				+ SUM(ISNULL(CAST( W.SCRAP_QTY AS NUMERIC(14,3)),0))
																			,0)
																	FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)         
																	WHERE W.WOID = [WORK_ORDER_ID]         
																	AND W.PROCID = SOURCES.OPERATION_ID
																	AND W.WIP_TYPE_CODE IN ( 'OUT','INOUT','PACKED', 'PROD')  	-- PIYONG 2017-08-25 PROD 추가
																	AND W.WO_DETL_ID = [WO_DETAIL]
																)
																,0) --[IN_QTY]
					,ADJUST_PLAN_IN_QTY/DETAIL_COUNT + ISNULL(
																(
																	SELECT ISNULL( SUM(ISNULL(WIPQTY2_ED,0))
																				+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_DFCT_QTY2),0)) 
																				+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_LOSS_QTY2),0)) 
																				+ SUM(ISNULL(CONVERT(NUMERIC(14,3), W.CNFM_PRDT_REQ_QTY2),0))
																				+ SUM(ISNULL(CAST( W.SCRAP_QTY AS NUMERIC(14,3)),0))
																			,0)
																	FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)         
																	WHERE W.WOID = [WORK_ORDER_ID]       
																	AND W.PROCID = SOURCES.OPERATION_ID  
																	AND W.WIP_TYPE_CODE IN ( 'OUT','INOUT','PACKED', 'PROD' ) 	-- PIYONG 2017-08-25 PROD 추가
																	AND W.WO_DETL_ID = [WO_DETAIL]
																)
																,0) --[OUT_QTY]
					,[IS_RELEASE]
					,SOURCES.[CREATE_PSN_ID]
					,SOURCES.[CREATE_DATE]
					,'WO_ROLLING' --[UPDATE_PSN_ID]
					,getdate() --[UPDATE_DATE]
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
					,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
								'B'
							END AS TOP_BACK_IND -- ATTR_05 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
					,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
									CASE WHEN SUBSTRING(SOURCES.WO,7,1) = 'X' THEN
										SUBSTRING(SOURCES.WO,1,6) + 'Y' + SUBSTRING(SOURCES.WO,8,10)
									ELSE
										CASE WHEN SOURCES.WO LIKE 'W%' OR SOURCES.WO LIKE 'M%' THEN
											SUBSTRING(SOURCES.WO,1,6) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WO,7,2)) + 50) + SUBSTRING(SOURCES.WO,9,10)
										ELSE
											SUBSTRING(SOURCES.WO,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WO,6,2)) + 50) + SUBSTRING(SOURCES.WO,8,10)
										END
									END
								END) AS LINK_WO      -- ATTR_06 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
					,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
									CASE WHEN SUBSTRING(SOURCES.WO_DETAIL,7,1) = 'X' THEN
										SUBSTRING(SOURCES.WO_DETAIL,1,6) + 'Y' + SUBSTRING(SOURCES.WO_DETAIL,8,10)
									ELSE
										CASE WHEN SOURCES.WO_DETAIL LIKE 'W%' OR SOURCES.WO_DETAIL LIKE 'M%' THEN
											SUBSTRING(SOURCES.WO_DETAIL,1,6) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WO_DETAIL,7,2)) + 50) + SUBSTRING(SOURCES.WO_DETAIL,9,10)
										ELSE
											SUBSTRING(SOURCES.WO_DETAIL,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WO_DETAIL,6,2)) + 50) + SUBSTRING(SOURCES.WO_DETAIL,8,10)
										END
									END
								END) AS DETAIL_LINK_WO      -- ATTR_07 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
					,SOURCES.IN_QTY AS FP_PLAN_QTY  -- ATTR_08 FP PLAN 수량
					,ISNULL(
								(
									SELECT ISNULL( SUM(ISNULL(MWH.WIPQTY2_ED,0))
													+ SUM(ISNULL(CONVERT(NUMERIC(14,3), MWH.CNFM_DFCT_QTY2),0)) 
													+ SUM(ISNULL(CONVERT(NUMERIC(14,3), MWH.CNFM_LOSS_QTY2),0)) 
													+ SUM(ISNULL(CONVERT(NUMERIC(14,3), MWH.CNFM_PRDT_REQ_QTY2),0))
													+ SUM(ISNULL(CAST( MWH.SCRAP_QTY AS NUMERIC(14,3)),0))
													,0)
										FROM [DBO].SCM_MES_WIP_HISTORY_H MWH WITH(NOLOCK)
										WHERE MWH.WOID              = SOURCES.WO
										AND MWH.PROCID            = SOURCES.OPERATION_ID
										AND MWH.WO_DETL_ID        = SOURCES.WO_DETAIL
										AND MWH.WIP_TYPE_CODE IN ( 'OUT','INOUT','PACKED', 'PROD' ) 	-- PIYONG 2017-08-25 PROD 추가        
										AND MWH.PRODID            = SOURCES.ITEM_ID
								)
							,0) AS FP_SNAP_QTY  -- ATTR_09 FP 실적 수량
					,[ATTR_10]
				FROM [DBO].[SY_XIF_MES_WO_S] SOURCES WITH(NOLOCK) 
					,#temp_result3_table B
				LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
					ON EQP.EQUIPMENT_ID = B.EQUIPMENT_ID
				AND EQP.OPERATION_ID = B.OPERATION_ID
				AND EQP.FACTORY_ID   = B.FACTORY_ID
				AND EQP.EQUIPMENT_TYPE = 'M'
				AND EQP.ACTIVE_FLAG    = 'Y'
				LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
					ON EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
				AND EQPC.SEGMENT1         = EQP.OPERATION_ID
				AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
				AND EQPC.ACTIVE_FLAG      = 'Y'
				LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
					ON IM.DIVISION_ID  = B.DIVISION_ID
				AND IM.SITE_ID      = B.SITE_ID
				AND IM.ITEM_ID      = B.ITEM_ID
				LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
					ON IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
				AND IMC.SEGMENT1         = IM.ITEM_CLASS
				AND IMC.ACTIVE_FLAG      = 'Y'
				WHERE SOURCES.WO    = B.WORK_ORDER_ID
				AND SOURCES.PLAN_ID = B.RELEASE_PLAN_ID
				AND IF_ID <> 'OFP0_OPLM_FP_WO'
				;

 			INSERT INTO @XIF_MES_WO_S                                                                                                                                                                                                           
					  ( [IF_SEQ]                                                                                                                                                                                                                                  
					  , [IF_TYPE]                                                                                                                                                                                                                                   
					  , [IF_ID]                                                                                                                                                                                                                                     
					  , [IF_INS_DATE]                                                                                                                                                                                                                               
					  , [IF_FLAG]                                                                                                                                                                                                                                   
					  , [IF_SND_DATE]                                                                                                                                                                                                                               
					  , [RSLT_IF_SEQ]                                                                                                                                                                                                                               
					  , [RSLT_PROC_FLAG]                                                                                                                                                                                                                            
					  , [RSLT_PROC_MSG]                                                                                                                                                                                                                             
					  , [PLAN_ID]                                                                                                                                                                                                                                   
					  , [PLANT_ID]                                                                                                                                                                                                                                  
					  , [BUILNO]                                                                                                                                                                                                                                    
					  , [LINE_ID]                                                                                                                                                                                                                                   
					  , [OPERATION_ID]                                                                                                                                                                                                                              
					  , [EQUIPMENT_ID]                                                                                                                                                                                                                              
					  , [ITEM_ID]                                                                                                                                                                                                                                   
					  , [DEMAND_ID]                                                                                                                                                                                                                                 
					  , [WO]                                                                                                                                                                                                                                        
					  , [WO_TYPE]                                                                                                                                                                                                                                   
					  , [WO_DETAIL]                                                                                                                                                                                                                                 
					  , [PLAN_DATE]                                                                                                                                                                                                                                 
					  , [START_TIME]                                                                                                                                                                                                                                
					  , [END_TIME]                                                                                                                                                                                                                                  
					  , [IN_QTY]                                                                                                                                                                                                                                    
					  , [OUT_QTY]                                                                                                                                                                                                                                   
					  , [IS_RELEASE]                                                                                                                                                                                                                                
					  , [CREATE_PSN_ID]                                                                                                                                                                                                                             
					  , [CREATE_DATE]                                                                                                                                                                                                                               
					  , [UPDATE_PSN_ID]                                                                                                                                                                                                                             
					  , [UPDATE_DATE]                                                                                                                                                                                                                               
					  , [LANE_QTY]                                                                                                                                                                                                                                  
					  , [UNIT]                                                                                                                                                                                                                                      
					  , [ORDER_TYPE]    
					  , [BATCH_ORDER_ID]
					  , [SLITTER_PLANT]
					  , [MARKET]
					  , [ATTR_01]
					  , [ATTR_02]
					  , [ATTR_03]
					  , [ATTR_04]
					  , [ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
					  , [ATTR_06] -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
					  , [ATTR_07] -- 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
					  , [ATTR_08] -- FP PLAN 수량
					  , [ATTR_09] -- FP 실적 수량
					  , [ATTR_10]
					  )
				 SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
					  , [IF_TYPE]
					  , [IF_ID]
					  , [IF_INS_DATE]
					  , [IF_FLAG]
					  , [IF_SND_DATE]
					  , [RSLT_IF_SEQ]
					  , [RSLT_PROC_FLAG]
					  , [RSLT_PROC_MSG]
					  , [PLAN_ID]
					  , [PLANT_ID]
					  , [BUILNO]
					  , [LINE_ID]
					  , [OPERATION_ID]
					  , [EQUIPMENT_ID]
					  , [ITEM_ID]
					  , [DEMAND_ID]
					  , [ATTR_06] -- [WO]
					  , [WO_TYPE]
					  , [ATTR_07] -- [WO_DETAIL]
					  , [PLAN_DATE]
					  , [START_TIME]
					  , [END_TIME]
					  , [IN_QTY]
					  , [OUT_QTY]
					  , [IS_RELEASE]
					  , [CREATE_PSN_ID]
					  , [CREATE_DATE]
					  , [UPDATE_PSN_ID]
					  , [UPDATE_DATE]
					  , [LANE_QTY]
					  , [UNIT]
					  , [ORDER_TYPE]
					  , [BATCH_ORDER_ID]
					  , [SLITTER_PLANT]	
					  , [MARKET]				                                                                                                                                                                                                                            
					  , [ATTR_01]
					  , [ATTR_02]
					  , [ATTR_03]
					  , [ATTR_04]
					  , 'T'          -- [ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
					  , [WO]         -- [ATTR_06] -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
					  , [WO_DETAIL]  -- [ATTR_07] -- 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
					  , [ATTR_08] -- FP PLAN 수량
					  , [ATTR_09] -- FP 실적 수량
					  , [ATTR_10]
				   FROM [DBO].[SY_XIF_MES_WO_S] WITH(NOLOCK)
				  WHERE PLAN_ID IN  (SELECT B.RELEASE_PLAN_ID + '_ADJ_'+ cast( @SEQ as varchar )
										FROM #temp_result3_table B )
				    AND ATTR_05 = 'B'
				;


			--> LOOP 밖에서 MES/PDS 일괄 전송 (@XIF_MES_WO_S -> SY_XIF_MES_WO_S)


            -- Rolling 처리 여부를 Lookup에 저장
			MERGE INTO [DBO].[SCM_SYS_LOOKUP_VALUE] A
				USING ( 
					SELECT @P_SITE_ID            AS SITE_ID
							,@FACTORY_ID           AS FACTORY_ID
							,CONVERT( NVARCHAR(8), GETDATE(), 112) AS EXEC_DATE
							) B
				ON  (     A.LOOKUP_TYPE_CODE = 'WO_ROLL_EXEC_FLAG'
						AND A.SEGMENT1         = B.SITE_ID
						AND A.SEGMENT2         = B.FACTORY_ID)
				WHEN MATCHED THEN
				UPDATE SET A.[ATTRIBUTE1]     = B.[EXEC_DATE]
							,A.[MODIFY_USER_ID] = @v_proc_name
							,A.[MODIFY_DATE]    = GETDATE() 
				WHEN NOT MATCHED THEN
					INSERT ([LOOKUP_TYPE_CODE]
							,[SEGMENT1]
							,[SEGMENT2]
							,[SEGMENT3]
							,[SEGMENT4]
							,[SEGMENT5]
							,[ACTIVE_FLAG]
							,[CREATE_USER_ID]
							,[CREATE_DATE]
							,[MODIFY_USER_ID]
							,[MODIFY_DATE]
							,[ATTRIBUTE1])
				VALUES('WO_ROLL_EXEC_FLAG'
						,B.SITE_ID
						,B.FACTORY_ID
						,'-'
						,'-'
						,'-'
						,'Y'
						,@v_proc_name
						,GETDATE()
						,@v_proc_name
						,GETDATE()
						,B.[EXEC_DATE]);

			-- 사용한 Temp table drop
			drop table #temp_result_table;    
			drop table #temp_result2_table;
			drop table #temp_result3_table;
			drop table #temp_extra_table;

   								   
		FETCH NEXT FROM CUR_TARGET_PLAN INTO  @plan_id       
											,@FACTORY_ID    
											,@INSTANCE_DATE
										;              

		END;
		CLOSE CUR_TARGET_PLAN;
		DEALLOCATE CUR_TARGET_PLAN;      	  

		-- MES 전송
		INSERT INTO SY_XIF_MES_WO_S
                  ( [IF_SEQ]                                                                                                                                                                                                                                  
				  , [IF_TYPE]                                                                                                                                                                                                                                   
				  , [IF_ID]                                                                                                                                                                                                                                     
				  , [IF_INS_DATE]                                                                                                                                                                                                                               
				  , [IF_FLAG]                                                                                                                                                                                                                                   
				  , [IF_SND_DATE]                                                                                                                                                                                                                               
				  , [RSLT_IF_SEQ]                                                                                                                                                                                                                               
				  , [RSLT_PROC_FLAG]                                                                                                                                                                                                                            
				  , [RSLT_PROC_MSG]                                                                                                                                                                                                                             
				  , [PLAN_ID]                                                                                                                                                                                                                                   
				  , [PLANT_ID]                                                                                                                                                                                                                                  
				  , [BUILNO]                                                                                                                                                                                                                                    
				  , [LINE_ID]                                                                                                                                                                                                                                   
				  , [OPERATION_ID]                                                                                                                                                                                                                              
				  , [EQUIPMENT_ID]                                                                                                                                                                                                                              
				  , [ITEM_ID]                                                                                                                                                                                                                                   
				  , [DEMAND_ID]                                                                                                                                                                                                                                 
				  , [WO]                                                                                                                                                                                                                                        
				  , [WO_TYPE]                                                                                                                                                                                                                                   
				  , [WO_DETAIL]                                                                                                                                                                                                                                 
				  , [PLAN_DATE]                                                                                                                                                                                                                                 
				  , [START_TIME]                                                                                                                                                                                                                                
				  , [END_TIME]                                                                                                                                                                                                                                  
				  , [IN_QTY]                                                                                                                                                                                                                                    
				  , [OUT_QTY]                                                                                                                                                                                                                                   
				  , [IS_RELEASE]                                                                                                                                                                                                                                
				  , [CREATE_PSN_ID]                                                                                                                                                                                                                             
				  , [CREATE_DATE]                                                                                                                                                                                                                               
				  , [UPDATE_PSN_ID]                                                                                                                                                                                                                             
				  , [UPDATE_DATE]                                                                                                                                                                                                                               
				  , [LANE_QTY]                                                                                                                                                                                                                                  
				  , [UNIT]                                                                                                                                                                                                                                      
				  , [ORDER_TYPE]    
				  , [BATCH_ORDER_ID]
				  , [SLITTER_PLANT]
				  , [MARKET]
				  , [ATTR_01]
				  , [ATTR_02]
				  , [ATTR_03]
				  , [ATTR_04]
				  , [ATTR_05] 
				  , [ATTR_06] 
				  , [ATTR_07] 
				  , [ATTR_08] 
				  , [ATTR_09] 
				  , [ATTR_10] 
				  , [ATTR_11] 
				  , [ATTR_12] 
				  , [ATTR_13] 
				  , [ATTR_14] 
				  , [ATTR_15] 
				  , [ATTR_16] 
				  , [ATTR_17] 
				  , [ATTR_18] 
				  , [ATTR_19] 
				  , [ATTR_20] 
					)
			 SELECT 
				    [IF_SEQ]                                                                                                   
				  , [IF_TYPE]                                                                                                  
				  , [IF_ID]                                                                                                    
				  , [IF_INS_DATE]                                                                                              
				  , [IF_FLAG]                                                                                                  
				  , [IF_SND_DATE]                                                                                              
				  , [RSLT_IF_SEQ]                                                                                              
				  , [RSLT_PROC_FLAG]                                                                                           
				  , [RSLT_PROC_MSG]                                                                                            
				  , [PLAN_ID]                                                                                                  
				  , [PLANT_ID]                                                                                                 
				  , [BUILNO]                                                                                                   
				  , [LINE_ID]                                                                                                  
				  , [OPERATION_ID]                                                                                             
				  , [EQUIPMENT_ID]                                                                                             
				  , [ITEM_ID]                                                                                                  
				  , [DEMAND_ID]                                                                                                
				  , [WO]                                                                                                       
				  , [WO_TYPE]                                                                                                  
				  , [WO_DETAIL]                                                                                                
				  , [PLAN_DATE]                                                                                                
				  , [START_TIME]                                                                                               
				  , [END_TIME]                                                                                                 
				  , [IN_QTY]                                                                                                   
				  , [OUT_QTY]                                                                                                  
				  , [IS_RELEASE]                                                                                               
				  , [CREATE_PSN_ID]                                                                                            
				  , [CREATE_DATE]                                                                                              
				  , [UPDATE_PSN_ID]                                                                                            
				  , [UPDATE_DATE]                                                                                              
				  , [LANE_QTY]                                                                                                 
				  , [UNIT]                                                                                                     
				  , [ORDER_TYPE]    
				  , [BATCH_ORDER_ID]
				  , [SLITTER_PLANT]
				  , [MARKET]
				  , [ATTR_01]
				  , [ATTR_02]
				  , [ATTR_03]
				  , [ATTR_04]
				  , [ATTR_05] 
				  , [ATTR_06] 
				  , [ATTR_07] 
				  , [ATTR_08] 
				  , [ATTR_09] 
				  , [ATTR_10] 
				  , [ATTR_11] 
				  , [ATTR_12] 
				  , [ATTR_13] 
				  , [ATTR_14] 
				  , [ATTR_15] 
				  , [ATTR_16] 
				  , [ATTR_17] 
				  , [ATTR_18] 
				  , [ATTR_19] 
				  , [ATTR_20] 
			   FROM @XIF_MES_WO_S
			   ;


		-- PDS 전송
		INSERT INTO SY_XIF_PDS_WO_S
                  ( [IF_SEQ]                                                                                                                                                                                                                                  
				  , [IF_TYPE]                                                                                                                                                                                                                                   
				  , [IF_ID]                                                                                                                                                                                                                                     
				  , [IF_INS_DATE]                                                                                                                                                                                                                               
				  , [IF_FLAG]                                                                                                                                                                                                                                   
				  , [IF_SND_DATE]                                                                                                                                                                                                                               
				  , [RSLT_IF_SEQ]                                                                                                                                                                                                                               
				  , [RSLT_PROC_FLAG]                                                                                                                                                                                                                            
				  , [RSLT_PROC_MSG]                                                                                                                                                                                                                             
				  , [PLAN_ID]                                                                                                                                                                                                                                   
				  , [PLANT_ID]                                                                                                                                                                                                                                  
				  , [BUILNO]                                                                                                                                                                                                                                    
				  , [LINE_ID]                                                                                                                                                                                                                                   
				  , [OPERATION_ID]                                                                                                                                                                                                                              
				  , [EQUIPMENT_ID]                                                                                                                                                                                                                              
				  , [ITEM_ID]                                                                                                                                                                                                                                   
				  , [DEMAND_ID]                                                                                                                                                                                                                                 
				  , [WO]                                                                                                                                                                                                                                        
				  , [WO_TYPE]                                                                                                                                                                                                                                   
				  , [WO_DETAIL]                                                                                                                                                                                                                                 
				  , [PLAN_DATE]                                                                                                                                                                                                                                 
				  , [START_TIME]                                                                                                                                                                                                                                
				  , [END_TIME]                                                                                                                                                                                                                                  
				  , [IN_QTY]                                                                                                                                                                                                                                    
				  , [OUT_QTY]                                                                                                                                                                                                                                   
				  , [IS_RELEASE]                                                                                                                                                                                                                                
				  , [CREATE_PSN_ID]                                                                                                                                                                                                                             
				  , [CREATE_DATE]                                                                                                                                                                                                                               
				  , [UPDATE_PSN_ID]                                                                                                                                                                                                                             
				  , [UPDATE_DATE]                                                                                                                                                                                                                               
				  , [LANE_QTY]                                                                                                                                                                                                                                  
				  , [UNIT]                                                                                                                                                                                                                                      
				  , [ORDER_TYPE]    
				  , [BATCH_ORDER_ID]
				  , [SLITTER_PLANT]
				  , [MARKET]
				  , [ATTR_01]
				  , [ATTR_02]
				  , [ATTR_03]
				  , [ATTR_04]
				  , [ATTR_05] 
				  , [ATTR_06] 
				  , [ATTR_07] 
				  , [ATTR_08] 
				  , [ATTR_09] 
				  , [ATTR_10]
				  , [ATTR_11]							  
				  , [ATTR_12] 
				  , [ATTR_13] 
				  , [ATTR_14] 
				  , [ATTR_15] 
				  , [ATTR_16] 
				  , [ATTR_17] 
				  , [ATTR_18] 
				  , [ATTR_19] 
				  , [ATTR_20] 
				  )
			 SELECT 
				    X.[IF_SEQ]                                                                                                   
				  , X.[IF_TYPE]                                                                                                  
				  , 'OFP0_GPDS_FP_WO' --[IF_ID]                                                                                                    
				  , X.[IF_INS_DATE]                                                                                              
				  , X.[IF_FLAG]                                                                                                  
				  , X.[IF_SND_DATE]                                                                                              
				  , X.[RSLT_IF_SEQ]                                                                                              
				  , X.[RSLT_PROC_FLAG]                                                                                           
				  , X.[RSLT_PROC_MSG]                                                                                            
				  , X.[PLAN_ID]                                                                                                  
				  , X.[PLANT_ID]                                                                                                 
				  , X.[BUILNO]                                                                                                   
				  , X.[LINE_ID]                                                                                                  
				  , X.[OPERATION_ID]                                                                                             
				  , X.[EQUIPMENT_ID]                                                                                             
				  , X.[ITEM_ID]                                                                                                  
				  , X.[DEMAND_ID]                                                                                                
				  , X.[WO]                                                                                                       
				  , X.[WO_TYPE]                                                                                                  
				  , X.[WO_DETAIL]                                                                                                
				  , X.[PLAN_DATE]                                                                                                
				  , X.[START_TIME]                                                                                               
				  , X.[END_TIME]                                                                                                 
				  , X.[IN_QTY]                                                                                                   
				  , X.[OUT_QTY]                                                                                                  
				  , X.[IS_RELEASE]                                                                                               
				  , X.[CREATE_PSN_ID]                                                                                            
				  , X.[CREATE_DATE]                                                                                              
				  , X.[UPDATE_PSN_ID]                                                                                            
				  , X.[UPDATE_DATE]                                                                                              
				  , X.[LANE_QTY]                                                                                                 
				  , X.[UNIT]                                                                                                     
				  , X.[ORDER_TYPE]    
				  , X.[BATCH_ORDER_ID]
				  , X.[SLITTER_PLANT]
				  , X.[MARKET]
				  , X.[ATTR_01]
				  , X.[ATTR_02]
				  , X.[ATTR_03]
				  , X.[ATTR_04]
				  , X.[ATTR_05] 
				  , X.[ATTR_06] 
				  , X.[ATTR_07] 
				  , X.[ATTR_08] 
				  , X.[ATTR_09] 
				  , X.[ATTR_10] 
				  , X.[ATTR_11] 
				  , X.[ATTR_12] 
				  , X.[ATTR_13] 
				  , X.[ATTR_14] 
				  , X.[ATTR_15] 
				  , X.[ATTR_16] 
				  , X.[ATTR_17] 
				  , X.[ATTR_18] 
				  , X.[ATTR_19] 
				  , X.[ATTR_20] 
			   FROM @XIF_MES_WO_S as x
					join scm_factory_m as y with(nolock)
				 on x.[BUILNO] = y.factory_id
			  where y.company_id = 'G670'
			  ;

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH


		CLOSE CUR_TARGET_PLAN;
		DEALLOCATE CUR_TARGET_PLAN;     

	    ROLLBACK TRAN
	    -- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END