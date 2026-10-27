

CREATE PROCEDURE [dbo].[PR_XXX_MANUAL_ORDER_CREATE]
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XXX_MANUAL_ORDER_CREATE'
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
	
	DECLARE @WO_BASE_DATE         NVARCHAR(1000)
	DECLARE @FACTORY_ID           NVARCHAR(1000)
	DECLARE @LINE_ID              NVARCHAR(1000)
	DECLARE @OPERATION_ID         NVARCHAR(1000)
	DECLARE @EQUIPMENT_ID         NVARCHAR(50)
	DECLARE @ITEM_ID              NVARCHAR(1000)
	DECLARE @WORK_CENTER_ID       NVARCHAR(1000)
	DECLARE @WO_ID                NVARCHAR(1000)
	DECLARE @MO_ID                NVARCHAR(1000)
	DECLARE @ORDER_TYPE           NVARCHAR(1000)
	DECLARE @WO_TYPE              NVARCHAR(1000)
	DECLARE @PLAN_DATE            NVARCHAR(1000)
	DECLARE @START_TIME           NVARCHAR(1000)
	DECLARE @END_TIME             NVARCHAR(1000)
	DECLARE @IN_QTY               float --NVARCHAR(1000)
	DECLARE @OUT_QTY              float --NVARCHAR(1000)
	DECLARE @LANE_QTY             float --NVARCHAR(1000)
	DECLARE @BATCH_QTY            float 
	DECLARE @MARKET               NVARCHAR(1000)	
	DECLARE @UPDATE_PSN_ID        NVARCHAR(1000)

	DECLARE @INSTANCE_ID          NVARCHAR(1000)
	DECLARE @INSTANCE_DATE        NVARCHAR(1000)
	DECLARE @RELEASE_PLAN_ID      NVARCHAR(1000)
	DECLARE @AMEND_PLAN_ID        NVARCHAR(1000)
	DECLARE @DIVISION_ID          NVARCHAR(1000)
	DECLARE @ELECTRODE_TYPE       NVARCHAR(1000)
	
	DECLARE @MES_LINE_ID          NVARCHAR(1000)	
	DECLARE @ERP_WORK_CENTER_ID   NVARCHAR(1000)	
	DECLARE @FP_LANE_QTY          float	
	DECLARE @NEW_WORK_ORDER       NVARCHAR(1000)	
	DECLARE @FP_PLANT_ID          NVARCHAR(1000)	
	DECLARE @FP_PLAN_ID           NVARCHAR(1000)	
	DECLARE @FP_SLITING_PLANT_ID  NVARCHAR(1000)	
	DECLARE @FP_SITE_ID           NVARCHAR(1000)	
	DECLARE @FP_WO_TYPE           NVARCHAR(1000)	
	DECLARE @UOM                  NVARCHAR(1000)	
	DECLARE @SEQ                  INT	
	DECLARE @ASSIGN_VAL           INT	
	DECLARE @ASSIGN_ERP_VAL       INT	
	DECLARE @ORDER_TYPE_VAL       INT	
	DECLARE @BOM_VAL              INT
	DECLARE @FLOW_VAL             INT
	DECLARE @PERIOD_VAL           INT
	DECLARE @PAST_VAL             INT
	DECLARE @WO_SEQ               INT
	DECLARE @TOTAL_IN_QTY         float	
	DECLARE @TOTAL_OUT_QTY        float	
	DECLARE @STATUS               NVARCHAR(100)	
	
	DECLARE @ERR_MESSAGE                  NVARCHAR(1000)	

	DECLARE CUR_MANUAL_WO_LIST CURSOR FOR
			SELECT [SEQ]
			      ,[WO_BASE_DATE]
				  ,[STATUS]
			      ,[FACTORY_ID]
			      ,[LINE_ID]
			      ,[OPERATION_ID]
			      ,[EQUIPMENT_ID]
			      ,[ITEM_ID]
			      ,[WORK_CENTER_ID]
			      ,[WO_ID]
			      ,[MO_ID]
			      ,[ORDER_TYPE]
			      ,[WO_TYPE]
			   --   ,[PLAN_DATE]
			      ,[START_TIME]
			      ,[END_TIME]
			      ,ISNULL([IN_QTY],0)
			      ,ISNULL([OUT_QTY],0)
			      ,[LANE_QTY]
				  ,BATCH_QTY
			      ,[MARKET]
			      ,[UPDATE_PSN_ID]
				  -- 전극 공정은 동일 날짜에 여러 값이 있더라도 설비별 summary를 하면 안됨. WO 1개에 WO Detail이 1개 생성되어야 함.
				  ,ROW_NUMBER() over ( partition by ( SELECT TOP 1 w.MES_LINE_ID
				                                        from dbo.SCM_EQUIPMENT_M w with(nolock)
					                                   WHERE w.equipment_id = a.equipment_id   )
					                                 , CASE WHEN SUBSTRING([OPERATION_ID], 1, 1) = 'E' THEN  wo_base_date + cast( seq as nvarchar)  ELSE [OPERATION_ID] END , [ITEM_ID], substring([START_TIME], 1,8)/*[PLAN_DATE]*/ order by equipment_id  desc ) WO_SEQ
				  ,SUM(cast(IN_QTY as numeric) ) over ( partition by ( SELECT TOP 1 w.MES_LINE_ID
				                                        from dbo.SCM_EQUIPMENT_M w with(nolock)
					                                   WHERE w.equipment_id = a.equipment_id   )
													 , CASE WHEN SUBSTRING([OPERATION_ID], 1, 1) = 'E' THEN  wo_base_date + cast( seq as nvarchar)  ELSE [OPERATION_ID] END, [ITEM_ID], substring([START_TIME], 1,8)/*[PLAN_DATE]*/ order by equipment_id) TOTAL_IN_QTY
				  ,SUM(cast(OUT_QTY as numeric) ) over ( partition by ( SELECT TOP 1 w.MES_LINE_ID
				                                        from dbo.SCM_EQUIPMENT_M w with(nolock)
					                                   WHERE w.equipment_id = a.equipment_id   )
													 , CASE WHEN SUBSTRING([OPERATION_ID], 1, 1) = 'E' THEN  wo_base_date + cast( seq as nvarchar)  ELSE [OPERATION_ID] END, [ITEM_ID], substring([START_TIME], 1,8)/*[PLAN_DATE]*/ order by equipment_id) TOTAL_OUT_QTY
			  FROM [dbo].[XXX_MANUAL_WO_CREATE] a WITH(NOLOCK)
			 where [PROCESSING_YN] = 'P'
             order by [WO_BASE_DATE], [OPERATION_ID], [ITEM_ID], substring([START_TIME], 1,8)/*[PLAN_DATE]*/ ,ROW_NUMBER() over ( partition by ( SELECT TOP 1 w.MES_LINE_ID
																								                                                   from dbo.SCM_EQUIPMENT_M w with(nolock)
																								                                                  WHERE w.equipment_id = a.equipment_id   )
											                                                                                                  ,CASE WHEN SUBSTRING([OPERATION_ID], 1, 1) = 'E' THEN  wo_base_date + cast( seq as nvarchar)  ELSE [OPERATION_ID] END
																																			  , [ITEM_ID]
																																			  , substring([START_TIME], 1,8)/*[PLAN_DATE]*/ 
																										                           order by equipment_id  desc ) 
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
			
			UPDATE [dbo].[XXX_MANUAL_WO_CREATE]
			  SET [PROCESSING_YN] = 'P'
			WHERE [PROCESSING_YN] = 'N'
			;

			SET @FP_PLAN_ID = 'MANUAL_ADJ_'+replace(replace( replace( convert(varchar, getdate(),120), ' ',''),':',''),'-','') + '-XX'
			
			OPEN CUR_MANUAL_WO_LIST;
			FETCH NEXT FROM CUR_MANUAL_WO_LIST INTO  @SEQ
			                                        ,@WO_BASE_DATE   
													,@STATUS 
													,@FACTORY_ID     
													,@LINE_ID        
													,@OPERATION_ID   
													,@EQUIPMENT_ID   
													,@ITEM_ID        
													,@WORK_CENTER_ID 
													,@WO_ID          
													,@MO_ID          
													,@ORDER_TYPE     
													,@WO_TYPE        
												--	,@PLAN_DATE      
													,@START_TIME     
													,@END_TIME       
													,@IN_QTY         
													,@OUT_QTY        
													,@LANE_QTY   
													,@BATCH_QTY    
													,@MARKET 
													,@UPDATE_PSN_ID
													,@WO_SEQ
													,@TOTAL_IN_QTY
													,@TOTAL_OUT_QTY
																							;
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
			       IF @WO_SEQ = 1 
				     BEGIN

					    SET @ERP_WORK_CENTER_ID = null
						SET @MES_LINE_ID = null
						SET @FP_PLANT_ID = null
						SET @DIVISION_ID = null
						SET @INSTANCE_ID = null
						SET @RELEASE_PLAN_ID = null
						SET @AMEND_PLAN_ID = null
						SET @PLAN_DATE = null
						SET @ELECTRODE_TYPE = null
						SET @FP_LANE_QTY = null
					 END
			
					SELECT TOP 1 @ERP_WORK_CENTER_ID = a.WORK_CENTER_ID, @MES_LINE_ID = a.MES_LINE_ID , @FP_PLANT_ID = a.PLANT_ID, @FP_SITE_ID = a.SITE_ID, @DIVISION_ID = a.DIVISION_ID
					  from dbo.SCM_EQUIPMENT_M a with(nolock)
					 WHERE 1=1
					   and a.equipment_id = @EQUIPMENT_ID
					   and a.factory_id = @FACTORY_ID     -- 공용설비가 존재함.
					 ;

					select top 1 @INSTANCE_ID = a.INSTANCE_ID
					  from FP_INSTANCE_FACTORY_M a
						  ,SCM_OPERATION_M b
					 where a.FACTORY_ID = @FACTORY_ID
					   and a.INSTANCE_TYPE = b.INSTANCE_TYPE
					   and b.OPERATION_ID = @OPERATION_ID   
					;
			
					SELECT TOP 1 @INSTANCE_DATE = x.INSTANCE_DATE , @RELEASE_PLAN_ID = x.RELEASE_PLAN_ID, @AMEND_PLAN_ID = x.AMEND_PLAN_ID
					  FROM (
							 SELECT INSTANCE_ID, INSTANCE_DATE, RELEASE_PLAN_ID , AMEND_PLAN_ID
								  , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, DIVISION_ID, FACTORY_ID ORDER BY INSERT_TIME DESC ) NUMS
							   FROM [LGCE_FPDEV_TR].[DBO].FP_RELEASE_PLAN_INFO_H WHERE INSTANCE_ID = @INSTANCE_ID  AND FACTORY_ID = @FACTORY_ID     
						   ) X
					WHERE X.NUMS = 1
					;

					SET @PLAN_DATE = SUBSTRING(@START_TIME,1,8)+'000000'


					select TOP 1 @ELECTRODE_TYPE = ELECTRODE_TYPE
					  from dbo.SCM_ITEM_LINE_ASSIGN_M
					 where LINE_ID = @LINE_ID        
					   and ITEM_ID = @ITEM_ID        
					   and ACTIVE_FLAG = 'Y'
                    ;


			        IF @LANE_QTY is not null OR @LANE_QTY > 0 
					      SET @FP_LANE_QTY = @LANE_QTY       ;
					else
				          select top 1 @FP_LANE_QTY = lane_qty
			                from dbo.SCM_ITEM_LANE_M
			               where item_id    =  @ITEM_ID
			                 and factory_id =  @FACTORY_ID
			               ; 
			
			        SELECT top 1 @UOM = item_uom
			          FROM dbo.scm_item_m 
			         where item_id    =  @ITEM_ID  
			          ; 
					
					IF @WO_SEQ = 1 
					   begin    
					     select top 1 @NEW_WORK_ORDER = orders
					  from ( 
								select ISNULL ( (
												substring( max(wo), 1,9) + ( CASE WHEN len(cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) ) = 1 THEN '00'+ cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) 
																		WHEN len(cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) ) = 2 THEN '0'+ cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) 
										    										ELSE cast( cast( substring( max(wo), 10,3) as numeric) + 1 as varchar) END )
											  ),
											  case @FP_SITE_ID when 'A001' THEN 'K' WHEN 'A002' THEN 'C' WHEN 'A003' THEN 'A' ELSE 'X' END
																						   + ISNULL( (SELECT TOP 1 KEY_VALUE FROM dbo.FP_INSTANCE_CONFIG_M  WHERE INSTANCE_ID = 'COMMON' AND CATEGORY_ID = 'DEMAND_TYPE' AND KEY_ID = @ORDER_TYPE ), '1' )
																						   + substring(@START_TIME,3,2) +
																						 case substring(@START_TIME,5,2)
																						          when '01' then '1' when '02' then '2' when '03' then '3' when '04' then '4' when '05' then '5' when '06' then '6'
																								  when '07' then '7' when '08' then '8' when '09' then '9' when '10' then 'A' when '11' then 'B' when '12' then 'C' ELSE 'X' END
																						   +'0X'+
																						 case @OPERATION_ID when 'E0500' then 'PM' when 'E1000' then 'MX' when 'E2000' then 'CT' when 'E2300' then 'IC' when 'E2500' then 'HS' when 'E3000' then 'RP' when 'E3500' then 'TP' when 'E4000' then 'SL'
																									  when 'A5000' then 'NT' when 'A6000' then 'VD' when 'A7000' then 'LM' when 'A8000' then 'ST' when 'A9000' then 'PK' 
																									  when 'P5000' then 'CP' when 'P5500' then 'CM' when 'P9500' then 'BM' 
																									  ELSE 'XX' END
																						   +'001'
											   )    orders
								  from  [LGCE_INFDEV].[dbo].[XIF_MES_WO_S] where wo like case @FP_SITE_ID when 'A001' THEN 'K' WHEN 'A002' THEN 'C' WHEN 'A003' THEN 'A' ELSE 'X' END
																						   + ISNULL( (SELECT TOP 1 KEY_VALUE FROM dbo.FP_INSTANCE_CONFIG_M  WHERE INSTANCE_ID = 'COMMON' AND CATEGORY_ID = 'DEMAND_TYPE' AND KEY_ID = @ORDER_TYPE ), '1' )
																						   + substring(@START_TIME,3,2) +
																						 case substring(@START_TIME,5,2) when '01' then '1' when '02' then '2' when '03' then '3' when '04' then '4' when '05' then '5' when '06' then '6'
																								                         when '07' then '7' when '08' then '8' when '09' then '9' when '10' then 'A' when '11' then 'B' when '12' then 'C' ELSE 'X' END
																						   +'0X'+
																						 case @OPERATION_ID when 'E0500' then 'PM' when 'E1000' then 'MX' when 'E2000' then 'CT' when 'E2300' then 'IC' when 'E2500' then 'HS' when 'E3000' then 'RP' when 'E3500' then 'TP' when 'E4000' then 'SL'
																									        when 'A5000' then 'NT' when 'A6000' then 'VD' when 'A7000' then 'LM' when 'A8000' then 'ST' when 'A9000' then 'PK' 
																									        when 'P5000' then 'CP' when 'P5500' then 'CM' when 'P9500' then 'BM' 
																									        ELSE 'XX' END
																						   +'%'

					       ) z
					     ;
                    end
					
			        select top 1 @ASSIGN_VAL = counta
						 from (
						      SELECT count(1) counta
						        FROM DBO.SCM_ITEM_LINE_ASSIGN_M la
						       WHERE la.ITEM_ID = @ITEM_ID
						         and la.LINE_ID = @LINE_ID
						       and la.ACTIVE_FLAG = 'Y' ) a
						     ;

                    select @FP_SLITING_PLANT_ID = CASE WHEN @OPERATION_ID  = 'E2000' THEN 
						                                  ISNULL( (
											                     select top 1 z.plant_id
											                       from [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] z
                                                                  where z.operation_id = 'E4000'
												                    and z.site_id      = @FP_SITE_ID
											                        and z.item_id      = @ITEM_ID  
											                        order by z.INSERT_TIME desc 
											                    ),(
											                     select top 1 ila.PLANT_ID
											                       from [dbo].[SCM_ITEM_LINE_ASSIGN_M] ila
                                                                  where ila.operation_id = 'E4000'
												                    and ila.site_id      = @FP_SITE_ID
											                        and ila.item_id      = @ITEM_ID  
												                    and ila.active_flag = 'Y'
											                      order by ila.INSERT_TIME desc 
											                    ) ) ELSE NULL END
							                           ;
						
						     
			        select top 1 @ASSIGN_ERP_VAL = counta
						 from (
						      SELECT count(1) counta
						        FROM [LGCE_INFDEV].dbo.[XIF_ERP_ITEM_LINE_ASSIGN_S] la
						       WHERE la.ITEM_ID = @ITEM_ID
						         and la.LINE_ID = @MES_LINE_ID
						       and la.ACTIVE_FLAG = 'Y' ) a
						     ;
			
			        select top 1 @BOM_VAL  = counta
						 from (
						      SELECT count(1) counta
						        FROM DBO.SCM_BOM_M bm
						       WHERE bm.parent_item_id = @ITEM_ID
						         and bm.plant_id  = @FP_PLANT_ID
						       and bm.ACTIVE_FLAG = 'Y' ) a
						     ;
						     
			        select top 1 @FLOW_VAL  = counta
						 from (
						      SELECT count(1) counta
						        FROM DBO.SCM_ITEM_M bm
							      ,dbo.scm_plant_m pm
						       WHERE bm.item_id  = @ITEM_ID
						         and bm.SITE_ID  = bm.SITE_ID
							   and pm.PLANT_ID = @FP_PLANT_ID
						       and bm.ACTIVE_FLAG = 'Y' ) a
						     ;
			
			        select top 1 @PERIOD_VAL = counta
						 from (
						      SELECT CASE  WHEN @START_TIME > @END_TIME THEN 0
							             ELSE 1 END counta
							 ) a
			                 ;          
			
			        select top 1 @PAST_VAL  = counta
						 from (
						      SELECT CASE  WHEN convert( varchar, getdate() , 112) > convert( varchar, cast( substring( @START_TIME ,1,8) as datetime), 112 ) THEN 0
							             ELSE 1 END counta
							 ) a
			                 ; 

			        select top 1 @ORDER_TYPE_VAL  = counta
						 from (
						         SELECT COUNT(1) counta
								   FROM dbo.FP_INSTANCE_CONFIG_M  
								  WHERE INSTANCE_ID = 'COMMON' 
								    AND CATEGORY_ID = 'DEMAND_TYPE' 
									AND KEY_ID = @ORDER_TYPE
						      ) a
						     ;

                SET @FP_WO_TYPE = 'MO'

			    IF (select count(1) -- WO인 경우에
					  from dbo.SCM_OPERATION_M  a
				          ,dbo.SCM_FACTORY_M  b
					 where a.operation_id = @OPERATION_ID   
					   and a.WO_FLAG      = 'Y'
					   and a.SITE_ID      = b.SITE_ID
					   and a.DIVISION_ID  = b.DIVISION_ID
					   and a.ACTIVE_FLAG  = 'Y'
					   and a.ACTIVE_FLAG  = b.ACTIVE_FLAG
					   and b.FACTORY_ID   = @FACTORY_ID     ) > 0
						   SET @FP_WO_TYPE = 'WO'			

			    SET @ERR_MESSAGE = ''
			
				IF  @ASSIGN_VAL = 0  AND @FP_WO_TYPE = 'WO'  AND @WO_ID is null			-- WO 일 경우에만 BOM 전송 validation이 필요함. 
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'LINE ASSIGN 없음'
		
				IF  @ASSIGN_ERP_VAL = 0 AND @FP_WO_TYPE = 'WO'  AND @WO_ID is null			-- WO 일 경우에만 ERP 전송 validation이 필요함.
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'ERP LINE ASSIGN 전송 정보 없음'
				  			  
				IF  @BOM_VAL = 0 AND @FP_WO_TYPE = 'WO'  AND @WO_ID is null			-- WO 일 경우에만 BOM 전송 validation이 필요함. 
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'BOM 없음'	
				  
				IF  @FLOW_VAL = 0  AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'MES FLOW 없음'		

				IF  @ORDER_TYPE_VAL = 0  AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'ORDER TYPE 확인필요'		
				  	
				IF  @PERIOD_VAL = 0  AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'시작일자가 종료일자보다 빠름'		

				IF  @PAST_VAL = 0 AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'시작일자가 오늘보다 과거임. 빠름'	
							  		  	  		   
                IF  @NEW_WORK_ORDER = '0'  AND @WO_ID is null
				    SET  @ERR_MESSAGE = @ERR_MESSAGE + ' | ' + N'WO를 채번할 수 없습니다'			  		  	  		   
				
			
		    IF @ERR_MESSAGE != ''
			   begin
		                 UPDATE [dbo].[XXX_MANUAL_WO_CREATE]
		                    SET [PROCESSING_YN] = 'N'
		                       ,ERROR_MSG = 'ERROR' + @ERR_MESSAGE
							   ,update_date = getdate()
		                  WHERE SEQ = @SEQ
						    AND WO_BASE_DATE  = @WO_BASE_DATE   
               end 
			ELSE
						 begin
						    -- ADJUST 인 경우
						    IF @STATUS in ( 'UPDATE','DELETE') -- @MO_ID IS NOT NULL OR LEN(@MO_ID) > 0 
						      BEGIN
							    IF @WO_SEQ = 1  --( @WO_ID IS NOT NULL OR LEN(@WO_ID) > 0 ) AND @WO_SEQ = 1 
								   BEGIN
						      	-- ERP로 WO 변경 정보 생성 전송
											
											insert into [LGCE_INFDEV].[dbo].[XIF_ERP_PRODUCTION_PLAN_S]
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
												   ,[MARKET]
												   ,[ATTRIBUTE1]
												   ,[ATTRIBUTE2]
												   ,[ATTRIBUTE3]
												   ,[ATTRIBUTE4]
												   ,[ATTRIBUTE5]
												   ,[ATTRIBUTE6]
												   ,[ATTRIBUTE7]
												   ,[ATTRIBUTE8]
												   ,[ATTRIBUTE9]
												   ,[ATTRIBUTE10])
											select REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]      ,row_number() over ( order by line_id, item_id) --[SEQ]
											      ,1 -- row_number() over ( order by line_id, item_id) --[SEQ]
												  ,ISNULL(@FP_PLAN_ID,FP_PLAN_ID) --[FP_PLAN_ID]
											      ,[PLANT_ID]
											      ,[FACTORY_ID]
											      ,ISNULL(@MES_LINE_ID,LINE_ID) -- [LINE_ID]
											      ,[OPERATION_ID]
											      ,[BOM_VERSION_ID]
											      ,[WORK_CENTER_ID]
											      ,[ITEM_ID]
											      ,[DEMAND_ID]
											      ,a.[WORK_ORDER_ID]
											      ,ISNULL(@ORDER_TYPE, [ORDER_TYPE] )
											      ,ISNULL(@PLAN_DATE, PLAN_DATE)      -- [PLAN_DATE]
											      ,ISNULL(@START_TIME, START_TIME)
											      ,ISNULL(@END_TIME, END_TIME)
											      ,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE ISNULL(@TOTAL_IN_QTY, PLAN_IN_QTY) END  -- [PLAN_IN_QTY]
											      ,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_OUT_QTY = 0 THEN PLAN_QTY ELSE ISNULL(@TOTAL_OUT_QTY, PLAN_QTY) END  -- [PLAN_QTY]
											      ,'Y' --[FIX_TYPE]
											      ,'N' --[TRANSFER_FLAG]
											      ,[TRANSFER_DATE]
											      ,[CREATE_USER_ID]
											      ,[CREATE_DATE]
											      ,@UPDATE_PSN_ID + '_MANUAL_ADJST' -- [MODIFY_USER_ID]
											      ,getdate() -- [MODIFY_DATE]
											      ,ISNULL(@FP_LANE_QTY, LANE_QTY) -- [LANE_QTY]
											      ,[BATCH_ORDER_ID]
											      ,ISNULL(@FP_SLITING_PLANT_ID, SLITTER_PLANT) --[SLITTER_PLANT]
											      ,ISNULL(@MARKET, MARKET) -- [MARKET]
											      ,[ATTRIBUTE1]
											      ,[ATTRIBUTE2]
											      ,[ATTRIBUTE3]
											      ,[ATTRIBUTE4]
											      ,[ATTRIBUTE5]
											      ,[ATTRIBUTE6]
											      ,[ATTRIBUTE7]
											      ,[ATTRIBUTE8]
											      ,[PLAN_IN_QTY]
											      ,[PLAN_QTY]
											  from LGCE_INFDEV.[dbo].[XIF_ERP_PRODUCTION_PLAN_S] a with(nolock)
											      ,(
												      select IFSEQNO, b.[WORK_ORDER_ID] , row_number() over( partition by [WORK_ORDER_ID] order by MODIFY_DATE desc) rownums
													    from LGCE_INFDEV.[dbo].[XIF_ERP_PRODUCTION_PLAN_S] b
                                                       where  b.[WORK_ORDER_ID]  = @WO_ID 
												   ) x
											 where a.[WORK_ORDER_ID]  = x.WORK_ORDER_ID
											   and a.IFSEQNO          = x.IFSEQNO
											   and x.rownums          = 1
											 ;

											IF @INSTANCE_ID IS NOT NULL AND @INSTANCE_DATE IS NOT NULL
											BEGIN
												UPDATE [LGCE_FPDEV_TR].[dbo].[FP_RELEASE_FIX_PLAN_H]
												   SET [PLAN_DATE]       = ISNULL(@PLAN_DATE, PLAN_DATE)
												      ,[START_TIME]      = ISNULL(@START_TIME, START_TIME)
													  ,[END_TIME]        = ISNULL(@END_TIME, END_TIME)
													  ,[PLAN_QTY]        = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_OUT_QTY = 0 THEN PLAN_QTY ELSE ISNULL(@TOTAL_OUT_QTY, PLAN_QTY) END
													  ,[PLAN_IN_QTY]     = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE ISNULL(@TOTAL_IN_QTY, PLAN_IN_QTY) END
													  ,[PRODUCTION_TYPE] = ISNULL(@ORDER_TYPE, [PRODUCTION_TYPE] )
													  ,[MARKET]          = ISNULL(@MARKET, MARKET)
													  ,[INSERT_ID]       = [INSERT_ID] + '_MANUAL_WO_ADJ'
													  ,[INSERT_TIME]     = getdate()
												 WHERE [INSTANCE_ID]   = @INSTANCE_ID
												   AND [INSTANCE_DATE] = @INSTANCE_DATE
												   AND [WORK_ORDER_ID] = @WO_ID
												;
												UPDATE [LGCE_FPDEV_TR].[dbo].[FP_RELEASE_FULL_PLAN_H]
												   SET [PLAN_DATE]       = ISNULL(@PLAN_DATE, PLAN_DATE)
												      ,[START_TIME]      = ISNULL(@START_TIME, START_TIME)
													  ,[END_TIME]        = ISNULL(@END_TIME, END_TIME)
													  ,[PLAN_QTY]        = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_OUT_QTY = 0 THEN PLAN_QTY ELSE ISNULL(@TOTAL_OUT_QTY, PLAN_QTY) END
													  ,[PLAN_IN_QTY]     = CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @TOTAL_IN_QTY = 0 THEN PLAN_IN_QTY ELSE ISNULL(@TOTAL_IN_QTY, PLAN_IN_QTY) END
													  ,[PRODUCTION_TYPE] = ISNULL(@ORDER_TYPE, [PRODUCTION_TYPE] )
													  ,[MARKET]          = ISNULL(@MARKET, MARKET)
													  ,[INSERT_ID]       = [INSERT_ID] + '_MANUAL_WO_ADJ'
													  ,[INSERT_TIME]     = getdate()
												 WHERE [INSTANCE_ID]   = @INSTANCE_ID
												   AND [INSTANCE_DATE] = @INSTANCE_DATE
												   AND [WORK_ORDER_ID] = @WO_ID
												;
											END
                                   END
						
						      	-- MES로 MO 변경 정보 생성 전송
											
											insert into [LGCE_INFDEV].[dbo].[XIF_MES_WO_S]
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
												   ,[ATTR_05]
												   ,[ATTR_06]
												   ,[ATTR_07]
												   ,[ATTR_08]
												   ,[ATTR_09]
												   ,[ATTR_10])
											select 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
											      ,[IF_TYPE]
											      ,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = SOURCES.[BUILNO] ),'') +'_'+'FP_WO' -- [IF_ID]
											      ,[IF_INS_DATE]
											      ,'N' --[IF_FLAG]
											      ,[IF_SND_DATE]
											      ,null -- [RSLT_IF_SEQ]
											      ,null--[RSLT_PROC_FLAG]
											      ,null--[RSLT_PROC_MSG]
											      ,ISNULL(@FP_PLAN_ID, PLAN_ID) --[PLAN_ID]
											      ,[PLANT_ID]
											      ,[BUILNO]
											      ,ISNULL(@MES_LINE_ID, LINE_ID) -- [LINE_ID]
											      ,[OPERATION_ID]
											      ,[EQUIPMENT_ID]
											      ,[ITEM_ID]
											      ,[DEMAND_ID]
											      ,SOURCES.[WO]
											      ,[WO_TYPE]
											      ,SOURCES.[WO_DETAIL]
											      ,ISNULL((substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) ), plan_date) -- [PLAN_DATE]
											      ,ISNULL((substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) ), start_time) -- [START_TIME]
											      ,ISNULL((substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) ), end_time) -- [END_TIME]
											      ,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @IN_QTY = 0 THEN IN_QTY ELSE ISNULL(@IN_QTY, IN_QTY) END  -- [IN_QTY]
											      ,CASE WHEN @STATUS = 'DELETE' THEN 0 WHEN @STATUS = 'UPDATE' AND @OUT_QTY = 0 THEN OUT_QTY ELSE ISNULL(@OUT_QTY, OUT_QTY) END  -- [OUT_QTY]
											      ,[IS_RELEASE]
											      ,[CREATE_PSN_ID]
											      ,getdate() --[CREATE_DATE]
											      ,@UPDATE_PSN_ID + '_MANUAL_ADJST' -- [UPDATE_PSN_ID]
											      ,getdate() --[UPDATE_DATE]
											      ,ISNULL(@FP_LANE_QTY, LANE_QTY) -- [LANE_QTY]
											      ,[UNIT]
											      ,ISNULL(@ORDER_TYPE, [ORDER_TYPE] )
											      ,[BATCH_ORDER_ID]
											      ,ISNULL(@FP_SLITING_PLANT_ID, SLITTER_PLANT) --[SLITTER_PLANT]
											      ,ISNULL(@MARKET, MARKET) -- [MARKET]
											      ,CASE WHEN [OPERATION_ID] in ( 'E0500','E1000' ) THEN @BATCH_QTY ELSE null END  -- [ATTR_01]
											      ,CASE WHEN [OPERATION_ID] in ( 'E0500','E1000' ) THEN @BATCH_QTY ELSE null END  -- [ATTR_02]
											      ,CASE WHEN [OPERATION_ID] in ( 'E0500','E1000' ) THEN @IN_QTY ELSE null END  -- [ATTR_03]
											      ,ISNULL(@MARKET, MARKET) -- [ATTR_04]
											      ,[ATTR_05]
											      ,[ATTR_06]
											      ,[ATTR_07]
											      ,[ATTR_08]
											      ,[ATTR_09]
											      ,[ATTR_10]
											  from [LGCE_INFDEV].[dbo].[XIF_MES_WO_S] SOURCES
											      ,(
												      select IF_SEQ, b.wo, b.WO_DETAIL , row_number() over( partition by b.wo, b.WO_DETAIL order by UPDATE_DATE desc) rownums
													    from LGCE_INFDEV.[dbo].[XIF_MES_WO_S] b
                                                       where  b.wo  = @WO_ID 
													     and  b.EQUIPMENT_ID = ISNULL( @EQUIPMENT_ID, b.EQUIPMENT_ID )
												   ) x
											 where SOURCES.[WO]      = x.WO
											   and sources.WO_DETAIL = x.WO_DETAIL
											   and sources.IF_SEQ    = x.IF_SEQ
											   and x.rownums = 1
											;            	
						
							                UPDATE [dbo].[XXX_MANUAL_WO_CREATE]
						                       SET [PROCESSING_YN] = 'Y'
						                          ,ERROR_MSG = 'SUCCESS'
						                          ,work_center_id = @ERP_WORK_CENTER_ID
										          ,lane_qty = @FP_LANE_QTY
												  ,UPDATE_DATE = getdate()
						                     WHERE SEQ = @SEQ
											   and WO_BASE_DATE = @WO_BASE_DATE
									         ;
						
						      END;  
						    -- 신규 추가인 경우
						    ELSE
						  begin

						        IF @FP_WO_TYPE = 'WO' AND @WO_SEQ = 1 
											BEGIN

												-- ERP로 WO 생성 정보 전송
														insert into [LGCE_INFDEV].[dbo].[XIF_ERP_PRODUCTION_PLAN_S]
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
															   ,[MARKET]
															   ,[ATTRIBUTE1]
															   ,[ATTRIBUTE2]
															   ,[ATTRIBUTE3]
															   ,[ATTRIBUTE4]
															   ,[ATTRIBUTE5]
															   ,[ATTRIBUTE6]
															   ,[ATTRIBUTE7]
															   ,[ATTRIBUTE8]
															   ,[ATTRIBUTE9]
															   ,[ATTRIBUTE10])
														select REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]      ,row_number() over ( order by line_id, item_id) --[SEQ]
														      ,1 -- row_number() over ( order by line_id, item_id) --[SEQ]
															  ,@FP_PLAN_ID --[FP_PLAN_ID]
														      ,@FP_PLANT_ID -- [PLANT_ID]
														      ,@FACTORY_ID -- [FACTORY_ID]
														      ,@MES_LINE_ID -- [LINE_ID]
														      ,@OPERATION_ID   -- [OPERATION_ID]
														      ,NULL -- [BOM_VERSION_ID]
														      ,@ERP_WORK_CENTER_ID -- [WORK_CENTER_ID]
														      ,@ITEM_ID -- [ITEM_ID]
														      ,'MANUAL_INPUT_WO' -- [DEMAND_ID]
														      ,@NEW_WORK_ORDER -- [WORK_ORDER_ID]
														      ,ISNULL(@ORDER_TYPE,'MASS') -- [ORDER_TYPE]
														      ,@PLAN_DATE      --[PLAN_DATE]
														      ,@START_TIME
														      ,@END_TIME
														      ,@TOTAL_IN_QTY -- [PLAN_IN_QTY]
														      ,@TOTAL_OUT_QTY -- [PLAN_QTY]
														      ,'Y' --[FIX_TYPE]
														      ,'N' --[TRANSFER_FLAG]
														      ,null -- [TRANSFER_DATE]
														      ,'MANUAL_ADJST' -- [CREATE_USER_ID]
														      ,getdate() -- [CREATE_DATE]
														      ,'MANUAL_ADJST' -- [MODIFY_USER_ID]
														      ,getdate() -- [MODIFY_DATE]
														      ,@FP_LANE_QTY -- [LANE_QTY]
														      ,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500' THEN @NEW_WORK_ORDER
														          ELSE NULL END -- [BATCH_ORDER_ID]
														      ,@FP_SLITING_PLANT_ID -- [SLITTER_PLANT]
														      ,@MARKET -- [MARKET]
														      ,null -- [ATTRIBUTE1]
														      ,null -- [ATTRIBUTE2]
														      ,null -- [ATTRIBUTE3]
														      ,null -- [ATTRIBUTE4]
														      ,null -- [ATTRIBUTE5]
														      ,null -- [ATTRIBUTE6]
														      ,null -- [ATTRIBUTE7]
														      ,null -- [ATTRIBUTE8]
														      ,null -- [ATTRIBUTE9]
														      ,null -- [ATTRIBUTE10]
												--		  from daul
												      ;

													  IF @INSTANCE_ID IS NOT NULL AND @INSTANCE_DATE IS NOT NULL
													    begin
														INSERT INTO [LGCE_FPDEV_TR].[dbo].[FP_RELEASE_FIX_PLAN_H]
															   ([INSTANCE_ID]
															   ,[INSTANCE_DATE]
															   ,[RELEASE_PLAN_ID]
															   ,[AMEND_PLAN_ID]
															   ,[DIVISION_ID]
															   ,[FACTORY_ID]
															   ,[WORK_ORDER_ID]
															   ,[ITEM_ID]
															   ,[LINE_ID]
															   ,[OPERATION_ID]
															   ,[ELECTRODE_TYPE]
															   ,[EQUIPMENT_ID]
															   ,[FIX_TYPE]
															   ,[PLAN_DATE]
															   ,[START_TIME]
															   ,[END_TIME]
															   ,[PLAN_QTY]
															   ,[PLAN_IN_QTY]
															   ,[PRODUCTION_TYPE]
															   ,[MARKET]
															   ,[BATCH_ORDER_ID]
															   ,[ACTUAL_FLAG]
															   ,[CLOSE_FLAG]
															   ,[INSERT_ID]
															   ,[INSERT_TIME])
														SELECT @INSTANCE_ID
															  ,@INSTANCE_DATE
															  ,@RELEASE_PLAN_ID
															  ,@AMEND_PLAN_ID
															  ,@DIVISION_ID
															  ,@FACTORY_ID 
															  ,@NEW_WORK_ORDER    
															  ,@ITEM_ID   
															  ,@LINE_ID   
															  ,@OPERATION_ID 
															  ,@ELECTRODE_TYPE 
															  ,CASE WHEN @INSTANCE_ID LIKE '%CELL%' OR @INSTANCE_ID LIKE '%PACK%' THEN
															              CASE WHEN @ELECTRODE_TYPE = '-' THEN @LINE_ID + '_' + @OPERATION_ID 
																		       ELSE  @LINE_ID + '_' + @OPERATION_ID + '_' + @ELECTRODE_TYPE   END
															        ELSE @EQUIPMENT_ID END --[EQUIPMENT_ID]  
															  ,'Y'             
															  ,cast ( substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) as datetime)
															  ,cast ( substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) as datetime)
															  ,cast ( substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) as datetime)
															  ,@OUT_QTY
															  ,@IN_QTY
															  ,@ORDER_TYPE
															  ,@MARKET
															  ,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500' THEN @NEW_WORK_ORDER
														          ELSE NULL END --
															  ,'Y' -- ACTUAL_FLAG
															  ,'N' -- CLOSE_FLAG
															  ,'MANUAL_WO_CREATION'
															  ,getdate()   -- [INSERT_TIME]
														  ;

														INSERT INTO [LGCE_FPDEV_TR].[dbo].[FP_RELEASE_FULL_PLAN_H]
															   ([INSTANCE_ID]
															   ,[INSTANCE_DATE]
															   ,[RELEASE_PLAN_ID]
															   ,[AMEND_PLAN_ID]
															   ,[DIVISION_ID]
															   ,[FACTORY_ID]
															   ,[WORK_ORDER_ID]
															   ,[ITEM_ID]
															   ,[LINE_ID]
															   ,[OPERATION_ID]
															   ,[ELECTRODE_TYPE]
															   ,[EQUIPMENT_ID]
															   ,[FIX_TYPE]
															   ,[PLAN_DATE]
															   ,[START_TIME]
															   ,[END_TIME]
															   ,[PLAN_QTY]
															   ,[PLAN_IN_QTY]
															   ,[PRODUCTION_TYPE]
															   ,[MARKET]
															   ,[BATCH_ORDER_ID]
															   ,[ACTUAL_FLAG]
															   ,[CLOSE_FLAG]
															   ,[INSERT_ID]
															   ,[INSERT_TIME])
														SELECT @INSTANCE_ID -- [INSTANCE_ID]
															  ,@INSTANCE_DATE -- [INSTANCE_DATE]
															  ,@RELEASE_PLAN_ID -- [RELEASE_PLAN_ID]
															  ,@AMEND_PLAN_ID --[AMEND_PLAN_ID]
															  ,@DIVISION_ID -- [DIVISION_ID]
															  ,@FACTORY_ID -- [FACTORY_ID]
															  ,@NEW_WORK_ORDER --[WORK_ORDER_ID]
															  ,@ITEM_ID --[ITEM_ID]
															  ,@LINE_ID --[LINE_ID]
															  ,@OPERATION_ID --[OPERATION_ID]
															  ,@ELECTRODE_TYPE
															  ,CASE WHEN @INSTANCE_ID LIKE '%CELL%' OR @INSTANCE_ID LIKE '%PACK%' THEN
															              CASE WHEN @ELECTRODE_TYPE = '-' THEN @LINE_ID + '_' + @OPERATION_ID 
																		       ELSE  @LINE_ID + '_' + @OPERATION_ID + '_' + @ELECTRODE_TYPE   END
															        ELSE @EQUIPMENT_ID END --[EQUIPMENT_ID]   -- Cell Pack인 경우에는 Line_id와 Operation_id, Electrode_type 컬럼을 합쳐서 만듬.
															  ,'Y' -- [FIX_TYPE]
															  ,cast ( substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) as datetime) -- [PLAN_DATE]
															  ,cast ( substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) as datetime) -- [START_TIME]
															  ,cast ( substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) as datetime) -- [END_TIME]
															  ,@OUT_QTY -- [PLAN_QTY]
															  ,@IN_QTY -- [PLAN_IN_QTY]
															  ,@ORDER_TYPE -- [PRODUCTION_TYPE]
															  ,@MARKET -- [MARKET]
															  ,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500' THEN @NEW_WORK_ORDER
														          ELSE NULL END -- [BATCH_ORDER_ID]
                                                                ,'Y' -- ACTUAL_FLAG
															  ,'N' -- CLOSE_FLAG
															  ,'MANUAL_WO_CREATION'
															  ,getdate()   -- [INSERT_TIME]
														;
														end

											END 		
						--	END
										;

										-- MES로 MO 생성 정보 전송
											insert into [LGCE_INFDEV].[dbo].[XIF_MES_WO_S]
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
													,[ATTR_05]
													,[ATTR_06]
													,[ATTR_07]
													,[ATTR_08]
													,[ATTR_09]
													,[ATTR_10])
											select 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
											      ,'S' --[IF_TYPE]
											      ,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = @FACTORY_ID ),'') +'_'+'FP_WO' -- [IF_ID]
											      ,getdate() -- [IF_INS_DATE]
											      ,'N' --[IF_FLAG]
											      ,null --[IF_SND_DATE]
											      ,null -- [RSLT_IF_SEQ]
											      ,null--[RSLT_PROC_FLAG]
											      ,null--[RSLT_PROC_MSG]
											      ,@FP_PLAN_ID  -- [PLAN_ID]
											      ,@FP_PLANT_ID -- [PLANT_ID]
											      ,@FACTORY_ID -- [BUILNO]
											      ,@MES_LINE_ID -- [LINE_ID]
											      ,@OPERATION_ID   -- [OPERATION_ID]
											      ,@EQUIPMENT_ID -- [EQUIPMENT_ID]
											      ,@ITEM_ID -- [ITEM_ID]
											      ,'MANUAL_INPUT_WO' -- [DEMAND_ID]
											      ,@NEW_WORK_ORDER -- [WO]
											      ,@FP_WO_TYPE -- [WO_TYPE]
											      ,@NEW_WORK_ORDER + cast(@WO_SEQ as varchar) -- [WO_DETAIL]
											      ,substring(@PLAN_DATE,1,4) + '-' + substring(@PLAN_DATE,5,2) + '-' + substring(@PLAN_DATE,7,2) +' '  + substring(@PLAN_DATE,9,2) +':' + substring(@PLAN_DATE,11,2) +':' + substring(@PLAN_DATE,13,2) -- [PLAN_DATE]
											      ,substring(@START_TIME,1,4) + '-' + substring(@START_TIME,5,2) + '-' + substring(@START_TIME,7,2) +' '  + substring(@START_TIME,9,2) +':' + substring(@START_TIME,11,2) +':' + substring(@START_TIME,13,2) -- [START_TIME]
											      ,substring(@END_TIME,1,4) + '-' + substring(@END_TIME,5,2) + '-' + substring(@END_TIME,7,2) +' '  + substring(@END_TIME,9,2) +':' + substring(@END_TIME,11,2) +':' + substring(@END_TIME,13,2) -- [END_TIME]
											      ,@IN_QTY -- [IN_QTY]
											      ,@OUT_QTY -- [OUT_QTY]
											      ,'Y' -- [IS_RELEASE]
											      ,'MANUAL_ADJST' -- [CREATE_PSN_ID]
											      ,getdate() --[CREATE_DATE]
											      ,'MANUAL_ADJST' -- [UPDATE_PSN_ID]
											      ,getdate() --[UPDATE_DATE]
											      ,@FP_LANE_QTY -- [LANE_QTY]
											      ,@UOM
											      ,ISNULL(@ORDER_TYPE,'MASS') -- [ORDER_TYPE]
											      ,CASE WHEN @OPERATION_ID = 'E1000' OR  @OPERATION_ID = 'E0500'  THEN @NEW_WORK_ORDER
														          ELSE NULL END -- [BATCH_ORDER_ID]
											      ,@FP_SLITING_PLANT_ID -- [SLITTER_PLANT]
											      ,@MARKET -- [MARKET]
											      ,CASE WHEN @OPERATION_ID in ( 'E0500','E1000' ) THEN @BATCH_QTY ELSE null END  -- [ATTR_01]
											      ,CASE WHEN @OPERATION_ID in ( 'E0500','E1000' ) THEN @BATCH_QTY ELSE null END  -- [ATTR_02]
											      ,CASE WHEN @OPERATION_ID in ( 'E0500','E1000' ) THEN @IN_QTY ELSE null END  -- [ATTR_03]
											      ,@MARKET -- [ATTR_04]
											      ,NULL -- [ATTR_05]
											      ,NULL -- [ATTR_06]
											      ,NULL -- [ATTR_07]
											      ,NULL -- [ATTR_08]
											      ,NULL -- [ATTR_09]
											      ,NULL -- [ATTR_10]
							--				  from dual
											;            								
						                 UPDATE [dbo].[XXX_MANUAL_WO_CREATE]
						                    SET [PROCESSING_YN] = 'Y'
						                       ,ERROR_MSG = 'SUCCESS'
									           ,WO_ID = CASE WHEN (select count(1)
												                     from dbo.SCM_OPERATION_M  a
												                         ,dbo.SCM_FACTORY_M  b
											                        where a.operation_id = @OPERATION_ID   
												                      and a.WO_FLAG      = 'Y'
												                      and a.SITE_ID      = b.SITE_ID
												                      and a.DIVISION_ID  = b.DIVISION_ID
												                      and a.ACTIVE_FLAG  = 'Y'
												                      and a.ACTIVE_FLAG  = b.ACTIVE_FLAG
												                      and b.FACTORY_ID   = @FACTORY_ID     ) > 0 
												             THEN @NEW_WORK_ORDER ELSE NULL END
						     				   ,MO_ID = @NEW_WORK_ORDER + cast(@WO_SEQ as varchar)
											   ,WO_TYPE = @FP_WO_TYPE
										       ,work_center_id = @ERP_WORK_CENTER_ID
										       ,lane_qty = @FP_LANE_QTY
										       ,ORDER_CREAT_DATE = getdate()
											   ,UPDATE_DATE = getdate()
						                  WHERE SEQ = @SEQ
										    and WO_BASE_DATE = @WO_BASE_DATE
						                   ;
						
						    end				
						
				end;
															  	
			FETCH NEXT FROM CUR_MANUAL_WO_LIST INTO  @SEQ
			                                        ,@WO_BASE_DATE   
													,@STATUS 
													,@FACTORY_ID     
													,@LINE_ID        
													,@OPERATION_ID   
													,@EQUIPMENT_ID   
													,@ITEM_ID        
													,@WORK_CENTER_ID 
													,@WO_ID          
													,@MO_ID          
													,@ORDER_TYPE     
													,@WO_TYPE        
												--	,@PLAN_DATE      
													,@START_TIME     
													,@END_TIME       
													,@IN_QTY         
													,@OUT_QTY        
													,@LANE_QTY      
													,@BATCH_QTY 
													,@MARKET 
													,@UPDATE_PSN_ID
													,@WO_SEQ
													,@TOTAL_IN_QTY
													,@TOTAL_OUT_QTY
													 ;
			END;
			
			CLOSE CUR_MANUAL_WO_LIST;
			DEALLOCATE CUR_MANUAL_WO_LIST;      
			
			

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		CLOSE CUR_MANUAL_WO_LIST;
		DEALLOCATE CUR_MANUAL_WO_LIST;    

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
  		SET @v_descr = ERROR_MESSAGE()																																												
	  	EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate																																												

	END CATCH

END
