




/*  
 * Program ID   : PR_SCP_EGN_OTPT_PRDN_M
 * Description  : SCP엔진출력생산데이터 생성 프로시저
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2026.03.26	hrkim		Initial Release : PJ20264226 Next SCM Pilot 설계 및 개발
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_EGN_OTPT_PRDN_M]
	@P_PLAN_ID	NVARCHAR(100)	= NULL
AS

BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE @V_PLAN_ID				NVARCHAR(100)	= @P_PLAN_ID;
	DECLARE @V_DIVISION_ID			NVARCHAR(50)	= '';
	DECLARE @V_PLAN_START_YYYYMMDD	NVARCHAR(8)		= '';
	DECLARE @V_PLAN_END_YYYYMMDD	NVARCHAR(8)		= '';
	DECLARE @V_PLAN_GROUP			NVARCHAR(100)	= ''

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_EGN_OTPT_PRDN_M';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	BEGIN TRY
	  BEGIN

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = CONCAT('[plan_id=', ISNULL(@V_PLAN_ID,''),  ']')
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

			-----------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Plan Master 정보 ' 
			-----------------------------------------------------------------------------------
		    SELECT @V_DIVISION_ID			= PM.ATTRIBUTE1
				  ,@V_PLAN_START_YYYYMMDD	= PM.PLAN_START_DATE
				  ,@V_PLAN_END_YYYYMMDD	= PM.PLAN_END_DATE
				  ,@V_PLAN_GROUP			= PM.ATTRIBUTE2
			 FROM SCP_OPT_ENG_PLAN_MASTER_SN  PM WITH(NOLOCK)
			WHERE PM.PLAN_ID = @V_PLAN_ID

			-----------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' DELETE ' 
			-----------------------------------------------------------------------
			DELETE TG
			  FROM SCP_EGN_OTPT_PRDN_M TG
			 WHERE TG.PLAN_ID = @V_PLAN_ID 

			-----------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' INSERT  ' 
			/*
				Order Production 데이터를 Main으로 참조하고,
				Demand Buffer Pegging기준의 수량으로 데이터를 생성한다. 
				Order Production과 Demand Buffer Pegging 수량이 일치하는 경우만 참조함.
				생산 LIne 정보는 SCP_OPT_ENG_ROUTING_SN 테이블의 Attribute14을 참조한다.
				 - GM은  동편/서편이 나눠서 모델링이 됨, 
				 - Attribute14에 동서 구분된 라인 정보가 저장됨
				 - GM은 Attribute13 컬럼을 라인 정보로 참조한다. 
			*/
			-----------------------------------------------------------------------
			;WITH DBP_PRODUCTION AS (
				SELECT BP.PROD_ORDER_ID
					 , BP.BUFFER_ID
					 , CONVERT(FLOAT, BP.FLOW_QTY)		AS FLOW_QTY
					 , CONVERT(INTEGER, BP.ATTRIBUTE14)	AS PEGGING_SEQ 
					 , SUM(CONVERT(FLOAT, BP.FLOW_QTY))
									OVER (PARTITION BY BP.PROD_ORDER_ID
													  ,BP.BUFFER_ID) 
										AS FLOW_QTY_SUM_FOR_ORDER
					 , ED.ATTRIBUTE1	AS DEMAND_SITE_ID
					 , ED.ATTRIBUTE2	AS DEMAND_ITEM_ID
					 , ED.ATTRIBUTE4	AS DEMAND_INCOTERMS
					 , ED.ATTRIBUTE5	AS PROJECT_CODE
					 , ED.ATTRIBUTE8	AS FCST_TYPE 
					 , ED.DEMAND_ID 	AS DEMAND_ID
				 FROM SCP_OPT_ENG_OUT_DEMAND_BUFFER_PEGGING_SN BP WITH(NOLOCK)
					  LEFT JOIN SCP_OPT_ENG_DEMAND_SN ED WITH(NOLOCK)
							  ON ED.PLAN_ID		= BP.PLAN_ID
							 AND ED.DEMAND_ID	= BP.DEMAND_NAME
				WHERE 1=1
				  AND BP.PLAN_ID			=  @V_plan_id
				  AND BP.PROD_ORDER_TYPE	= 'ProductionOrder'
			), DEMAND_ASSIGN_PEGGING AS (
				SELECT DISTINCT AP.PRODUCTION_ORDER_ID
				 FROM  SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_SN AP WITH(NOLOCK) 
				WHERE  1=1
				  AND  AP.PLAN_ID	= @V_plan_id 
			), ITEM_MASTER AS (
				SELECT ITEM_ID
					  ,MAX(ITEM_CLASS)				AS ITEM_CLASS
					  ,MAX(SCP_OPERATION_GROUP)		AS OPERATION_GROUP
					  ,MAX(LEFT(SCP_FLOW_ID, 5))	AS OPERATION_ID
					  ,CASE WHEN MAX(ITEM_CLASS) = 'ES0301' THEN 'ANODE'
							WHEN MAX(ITEM_CLASS) = 'ES0302' THEN 'CATHODE'
							WHEN MAX(ITEM_CLASS) = 'ES0303' THEN 'ONESIDE'
							WHEN MAX(ITEM_CLASS) = 'ES0305' THEN 'ONESIDE'
							ELSE '-'
						END AS ELECTRODE_TYPE 
				 FROM SCM_MST_ITEM_SN IM WITH(NOLOCK)
				WHERE IM.ACTIVE_FLAG = 'Y'
				  AND IM.SCP_OPERATION_GROUP IS NOT NULL 
				GROUP BY ITEM_ID 
			) 
			INSERT INTO SCP_EGN_OTPT_PRDN_M
					( PLAN_ID
					, PLAN_START_YYYYMMDD
					, DIVISION_ID
					, SCM_SITE_ID
					, ITEM_ID
					, STAGE
					, OPERATION_GROUP
					, OPERATION_ID
					, LINE_ID
					, START_DATE
					, END_DATE
					, OUT_QTY
					, DAP_YN
					, DEMAND_SITE_ID
					, DEMAND_ITEM_ID
					, DEMAND_INCOTERMS
					, PROJECT_CODE
					, FCST_TYPE
					, DEMAND_ID
					, ORDER_ID
					, PEGGING_SEQ
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE 
					, ATTRIBUTE1 )
			SELECT  @V_PLAN_ID										AS PLAN_ID
				  , @V_PLAN_START_YYYYMMDD							AS PLAN_START_YYYYMMDD
				  , @V_DIVISION_ID									AS DIVISION_ID
			      , SI.SITE_ID										AS SCM_SITE_ID
				  , SI.ITEM_ID
				  , SI.STAGE
				  , IM.OPERATION_GROUP
				  , IM.OPERATION_ID
				  , CASE WHEN RT.ATTRIBUTE14 IS NULL	
						 THEN '-'
						 ELSE ISNULL(RT.ATTRIBUTE13	
								   , RT.ATTRIBUTE14)
					 END											AS LINE_ID	-- 생산 Line Id 
				  , OP.START_DATE									
				  , OP.END_DATE										
				  , CONVERT(FLOAT, ISNULL(PP.FLOW_QTY
										, OP.OUT_QTY))				AS OUT_QTY
				  , CASE WHEN AP.PRODUCTION_ORDER_ID IS NOT NULL
						 THEN 'Y'
						 ELSE 'N'
					 END											AS DAP_YN	-- Demand Assign pegging 여부 
				  , PP.DEMAND_SITE_ID
				  , PP.DEMAND_ITEM_ID
				  , PP.DEMAND_INCOTERMS
				  , PP.PROJECT_CODE
				  , PP.FCST_TYPE
				  , PP.DEMAND_ID
				  , OP.PRODUCTION_ORDER_ID							AS ORDER_ID
				  , PP.PEGGING_SEQ
				  , @v_program_name									AS CREATED_BY
				  , GETDATE()										AS CREATION_DATE
				  , @v_program_name									AS LAST_UPDATED_BY
				  , GETDATE()										AS LAST_UPDATE_DATE
				  , @V_PLAN_GROUP									AS PLAN_GROUP		-- attribute1 (SHIP_REQ 구분용)
			 FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN OP WITH(NOLOCK)
				  INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SI WITH(NOLOCK)
						  ON SI.PLAN_ID					= OP.PLAN_ID
						 AND SI.BUFFER_ID				= OP.PRODUCED_BUFFER_ID
				  LEFT  JOIN ITEM_MASTER IM 
						  ON IM.ITEM_ID					= OP.ITEM_ID
				  LEFT  JOIN SCP_OPT_ENG_ITEM_BOM_ROUTING_SN IBR WITH(NOLOCK)
						  ON IBR.PLAN_ID				= OP.PLAN_ID
						 AND IBR.ROUTING_BOM_MAPPING_ID	= OP.ROUTING_BOM_MAPPING_ID
				  LEFT  JOIN SCP_OPT_ENG_ROUTING_SN RT WITH(NOLOCK)  
						  ON RT.PLAN_ID					= OP.PLAN_ID
						 AND RT.ROUTING_ID				= IBR.ROUTING_ID
						 AND RT.OP_SEQ					= 0 
				  LEFT  JOIN DBP_PRODUCTION PP
						  ON PP.PROD_ORDER_ID			= OP.PRODUCTION_ORDER_ID
						 AND PP.BUFFER_ID				= OP.PRODUCED_BUFFER_ID
						 AND ROUND(PP.FLOW_QTY_SUM_FOR_ORDER,0) = ROUND(OP.OUT_QTY,0)  --- for GM (order/pegging 수량 불일치)  
				  LEFT  JOIN DEMAND_ASSIGN_PEGGING AP
						  ON AP.PRODUCTION_ORDER_ID		= OP.PRODUCTION_ORDER_ID
			WHERE 1=1
			  AND OP.PLAN_ID = @V_plan_id

		    SET @n_log_count = @@ROWCOUNT;

	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

	  END			    
	END TRY

	BEGIN CATCH                  
		if (xact_state() <> 0) ROLLBACK TRAN; 

		-- ERROR LOG                  
		SET @v_log_type = N'ERROR';                  
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		SET @d_event_date = SYSDATETIME();                  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                  
		                          ,@p_log_type      = @v_log_type                  
		                          ,@p_log_count     = @n_log_count                   
		                          ,@p_log_message   = @v_log_message                   
		                          ,@p_description   = @v_description                   
		                          ,@p_event_date    = @d_event_date                   
		                          ,@p_user_id       = @v_batch_user                  
		                          ;                  
		PRINT @v_log_message      + ' : ' + @v_description ;  
		RETURN -1;    
		
    END CATCH;   

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'##### END of procedure #####';                  
    SET @v_description = CONCAT('[plan_id=', ISNULL(@V_PLAN_ID,''),  ']['  + @v_exec_time + ']') ;          
    SET @d_event_date  = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
	PRINT @v_log_message      + ' : ' + @v_description ;          
	RETURN 1;    

END
