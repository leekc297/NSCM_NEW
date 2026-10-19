




/*  
 * Program ID   : PR_SCP_EGN_OTPT_SIPM_M
 * Description  : SCP엔진출력출하데이터 생성 프로시저
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2026.03.26	hrkim		Initial Release : PJ20264226 Next SCM Pilot 설계 및 개발
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_EGN_OTPT_SIPM_M]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_EGN_OTPT_SIPM_M';
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
				  ,@V_PLAN_END_YYYYMMDD		= PM.PLAN_END_DATE
				  ,@V_PLAN_GROUP			= PM.ATTRIBUTE2
			 FROM SCP_OPT_ENG_PLAN_MASTER_SN  PM WITH(NOLOCK)
			WHERE PM.PLAN_ID = @V_PLAN_ID

			-----------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' DELETE' 
			-----------------------------------------------------------------------
			DELETE TG
			  FROM SCP_EGN_OTPT_SIPM_M TG
			 WHERE TG.PLAN_ID = @V_PLAN_ID 

			-----------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' INSERT ' 
			/*  최적화 ODS 테이블 Order Shipping 테이블 데이터를 Main으로 참조한다.
				Demand Buffer Pegging 정보가 존재할시 Demand별 Pegging된 수량 기준으로 데이터 생성한다. 
				(Order Shipping 정보의 수량과 Demand Buffer Pegging의 수량이 일치할 경우만 pegging 참조) 
				1. Frozen 구간 외 : BOD ID등의 정보를 위해 Input BOD 테이블 SCP_OPT_ENG_BOD_SN를 참조한다. 
							        Frozen구간에 대해서는 SCP_OPT_ENG_BOD_SN BOD테이블 정보가 존재하지 않음. 
				2. Frozen 구간  : Scheduled Move와 Order Shippping 데이터를 참조하여 생성
								 - Order Shipping은 Id에 대해서 Suffix 처리가 된 데이터로 scheduled Move join시 scheduled Move id에 대해 Suffix 처리후 join함 
			*/
			-----------------------------------------------------------------------
			;WITH DBP_SHIPPING AS (
				SELECT BP.PROD_ORDER_ID
					 , BP.BUFFER_ID
					 , BP.FLOW_QTY
					 , CONVERT(INTEGER, BP.ATTRIBUTE14)	AS PEGGING_SEQ 
					 , SUM(CONVERT(FLOAT, BP.FLOW_QTY))
									OVER (PARTITION BY BP.PROD_ORDER_ID) 
										AS FLOW_QTY_SUM_FOR_ORDER
					 , CASE WHEN ED.ATTRIBUTE12	= 'DEMAND_GROUP'
							THEN 'Y'
							ELSE 'N'
						END				AS DEMAND_GROUP_YN
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
				  AND BP.PLAN_ID			= @V_plan_id
				  AND BP.PROD_ORDER_TYPE	= 'TransportationOrder'
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
			), SHIP_TGT_DATA AS (
				-----------------------------------
				-- 1. FROZEN 구간 외 
				-----------------------------------
				SELECT SI.SITE_ID										AS FROM_SITE_ID
					  ,SI.ITEM_ID
					  ,SI.STAGE
					  ,IM.OPERATION_GROUP
					  ,IM.OPERATION_ID
					  ,OS.DEPARTURE_DATE								
					  ,CONVERT(FLOAT, ISNULL(SP.FLOW_QTY,OS.QTY))		AS QTY
					  ,OS.ARRIVAL_DATE									
					  ,'OS'												AS SRC_TYPE			-- Order Shipping 
					  ,OS.TO_SITE_ID									AS TO_SITE_ID		-- To Site 
					  ,TS.STAGE											AS TO_STAGE 
					  ,BOD.ATTRIBUTE6									AS INCOTERMS
					  ,BOD.ATTRIBUTE7									AS BOD_ID
					  ,OS.TRANSPORT_MODE
					  ,SP.DEMAND_GROUP_YN
					  ,SP.DEMAND_SITE_ID
					  ,SP.DEMAND_ITEM_ID
					  ,SP.DEMAND_INCOTERMS
					  ,SP.PROJECT_CODE
					  ,SP.FCST_TYPE
					  ,SP.DEMAND_ID
					  ,OS.SHIPPING_ORDER_ID								AS ORDER_ID
					  ,ISNULL(SP.PEGGING_SEQ, 0)						AS PEGGING_SEQ 
				 FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN OS WITH(NOLOCK)
					  INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SI WITH(NOLOCK)
							  ON SI.PLAN_ID			= OS.PLAN_ID
							 AND SI.BUFFER_ID		= OS.FROM_BUFFER_ID -- From Site
					  INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN TS WITH(NOLOCK)
							  ON TS.PLAN_ID			= OS.PLAN_ID
							 AND TS.BUFFER_ID		= OS.TO_BUFFER_ID -- To Site
					  INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK)  -- 확정구간 제외 구간 
							  ON BOD.PLAN_ID		= OS.PLAN_ID
							 AND OS.BOD_ID			= BOD.BOD_ID
					  LEFT  HASH JOIN ITEM_MASTER IM 
							  ON IM.ITEM_ID			= SI.ITEM_ID
					  LEFT  JOIN DBP_SHIPPING SP
							  ON SP.PROD_ORDER_ID	= OS.SHIPPING_ORDER_ID
							 AND ROUND(SP.FLOW_QTY_SUM_FOR_ORDER,0) = ROUND(OS.QTY,0)  -- (order/pegging 수량 불일치 case 존재)  
				WHERE 1=1
				  AND OS.PLAN_ID = @V_plan_id
				-----------------------------------
				-- 2. FROZEN 구간
				-----------------------------------
				UNION ALL 
				SELECT SI.SITE_ID
					  ,SI.ITEM_ID
					  ,SI.STAGE
					  ,IM.OPERATION_GROUP
					  ,IM.OPERATION_ID
					  ,SM.DEPARTURE_DATE								
					  ,CONVERT(FLOAT, ISNULL(SP.FLOW_QTY, OS.QTY))	AS QTY
					  ,SM.ARRIVAL_DATE									
					  ,'SM'												AS SRC_TYPE			-- Scheduled Move 
					  ,SM.ATTRIBUTE4									AS TO_SITE_ID		-- To Site 
					  ,TS.STAGE											AS TO_STAGE 
					  ,SM.ATTRIBUTE6									AS INCOTERMS
					  ,SM.ATTRIBUTE7									AS BOD_ID
					  ,SM.TRANSPORT_MODE
					  ,SP.DEMAND_GROUP_YN
					  ,SP.DEMAND_SITE_ID
					  ,SP.DEMAND_ITEM_ID
					  ,SP.DEMAND_INCOTERMS
					  ,SP.PROJECT_CODE
					  ,SP.FCST_TYPE
					  ,SP.DEMAND_ID
					  ,SM.SHIPPING_ORDER_ID								AS ORDER_ID  
					  ,ISNULL(SP.PEGGING_SEQ, 0)						AS PEGGING_SEQ 
				 FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)  
					  INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN SI WITH(NOLOCK)
							  ON SI.PLAN_ID			= SM.PLAN_ID
							 AND SI.BUFFER_ID		= SM.FROM_BUFFER_ID -- From Site
					  INNER JOIN SCP_OPT_ENG_ITEM_SITE_SN TS WITH(NOLOCK)
							  ON TS.PLAN_ID			= SM.PLAN_ID
							 AND TS.BUFFER_ID		= SM.TO_BUFFER_ID -- To Site
					  LEFT  HASH JOIN ITEM_MASTER IM 
							  ON IM.ITEM_ID			= SI.ITEM_ID
					  INNER JOIN SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN OS WITH(NOLOCK)  -- ess 확정구간 scheduled move가 order shipping에 없는 경우 존재 (plan result와 맞추기 위해 join 추갸) 
							  ON OS.PLAN_ID				= SM.PLAN_ID
							 AND OS.SHIPPING_ORDER_ID	= SM.SHIPPING_ORDER_ID
							 AND CASE WHEN @V_DIVISION_ID LIKE '%EE%' AND IM.ELECTRODE_TYPE = 'ANODE'	THEN CONCAT(SM.SHIPPING_ORDER_ID,'_A')
									  WHEN @V_DIVISION_ID LIKE '%EE%' AND IM.ELECTRODE_TYPE = 'CATHODE'	THEN CONCAT(SM.SHIPPING_ORDER_ID,'_C')
									  ELSE SM.SHIPPING_ORDER_ID
								 END = OS.SHIPPING_ORDER_ID
					  LEFT  JOIN DBP_SHIPPING SP WITH(NOLOCK)
							  ON SP.PROD_ORDER_ID	= SM.SHIPPING_ORDER_ID 
							 AND ROUND(SP.FLOW_QTY_SUM_FOR_ORDER,0) = ROUND(OS.QTY,0)  -- (order/pegging 수량 불일치 case 존재)  
				WHERE SM.PLAN_ID = @V_PLAN_ID
				  AND SM.ATTRIBUTE6 ='IN'
			)
			 INSERT INTO SCP_EGN_OTPT_SIPM_M
						( PLAN_ID
						, PLAN_START_YYYYMMDD
						, DIVISION_ID
						, FROM_SITE_ID
						, ITEM_ID
						, STAGE
						, OPERATION_GROUP
						, OPERATION_ID
						, DEPARTURE_DATE
						, QTY
						, ARRIVAL_DATE
						, SRC_TYPE
						, TO_SITE_ID
						, TO_STAGE 
						, INCOTERMS
						, BOD_ID
						, TRANSPORT_MODE
						, DEMAND_GROUP_YN
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
				SELECT  @V_PLAN_ID					AS PLAN_ID
					  , @V_PLAN_START_YYYYMMDD		AS PLAN_START_YYYYMMDD
					  , @V_DIVISION_ID				AS DIVISION_ID
					  , TG.FROM_SITE_ID
					  , TG.ITEM_ID
					  , TG.STAGE
					  , TG.OPERATION_GROUP
					  , TG.OPERATION_ID
					  , TG.DEPARTURE_DATE
					  , TG.QTY
					  , TG.ARRIVAL_DATE
					  , TG.SRC_TYPE
					  , TG.TO_SITE_ID
					  , TG.TO_STAGE
					  , TG.INCOTERMS
					  , TG.BOD_ID
					  , TG.TRANSPORT_MODE
					  , TG.DEMAND_GROUP_YN
					  , TG.DEMAND_SITE_ID
					  , TG.DEMAND_ITEM_ID
					  , TG.DEMAND_INCOTERMS
					  , TG.PROJECT_CODE
					  , TG.FCST_TYPE
					  , TG.DEMAND_ID
					  , TG.ORDER_ID
					  , TG.PEGGING_SEQ
					  , @v_program_name				AS CREATED_BY
					  , GETDATE()					AS CREATION_DATE
					  , @v_program_name				AS LAST_UPDATED_BY
					  , GETDATE()					AS LAST_UPDATE_DATE
					  , @V_PLAN_GROUP				AS PLAN_GROUP		-- attribute1 (SHIP_REQ 구분용)
				 FROM SHIP_TGT_DATA TG 
				WHERE 1=1 

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
