/*
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_40_BALANCE
 * Description  : 전일자 CUTOFF : CONFIRM수량 변경 시 해당 날짜 이후 BOH, BALANCE UPDATE.
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_SHIP_PLAN_40_BALANCE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 <MEASURE>  
	[S]SHIP_REQ(Shipment Request)    : MKT 담당자가 출하요청한 수량         
	[S]SHIP_CONFIRM(Shipment Confirm): 출하 확정 수량   
	[S]POSTP_PLAN(Post Process Plan) : 활성화 후 공정에서 필요로 Barecell 소요량(남경)   	                    
	[P]WH_IN(WH in Plan)             : 제품 창고 인계 계획,Production과 동일(사용자 수정 가능)  
	[P]PROD_PLAN(Production)         : 조립실적+계획(활성화 L/T, 수율 적용) 
	[P]PROD_DATE(Production Date)    : 조립완료일(실적완료일)    
	[P]LOT(Lot)                      : SUBSTRIN(LOT_ID, 4,4)    	           
	[P]INCO_WIP(Incomming WIP)       : 활성화 Aging 후 일자별 특성검사 가능재고로 넘어 올 수량(Remain Lead Time 기준 향후 특성검사가능 재고)    
	[P]INSP_WIP(Inspection WIP)      : 특성 검사 가능 재고  당일 Inspection WIP : 전일 Inspection WIP + 당일 Incomming WIP - 전일 WH in Plan
    [I]MES_FCS_HOLD(Hold Stock)      : MES/FCS 재고중 출하불가 LOT수량(LOT_ID날짜에 L/T 고려)     
	[I]MES_FCS_RELEASE(Release Stock): MES/FCS 재고중 출하불가 LOT수량에 대해 사용자가 지정된 Release 일자의 LOT수량 
	[I]WH_STOC(Warehouse Stock)      : 당일 WH_STOC = OWMS 가용수량 , 익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM - 전일POSTP_PLAN - 전일 MES_FCS_HOLD수량 + 전일 MES_FCS_RELEASE수량      
	[I]BALANCE(Balance)              : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Confirm -당일 POSTP_PLAN
 -------------------------------------------------------------------------------------------------------------------------------------------------
 * 2021.11.01   SSP Pjt.       Create.
 * 2022.05.11   SSP Pjt.       cutoff 0값 제거
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_PLAN_40_BALANCE]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_PLAN_40_BALANCE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_ANL_SHIP_PLAN_40'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type		= N'START';
    SET @v_log_message	= N'########## Start of procedure ##########';
    SET @v_description	= @v_program_name + ':' + N' SHIP_PLAN UPDATE LOGIC';
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

	DECLARE @v_division_id    NVARCHAR(30) = '40';
    DECLARE @v_plan_start_yyyymmdd    NVARCHAR(8) = '';
	DECLARE @v_plan_type    NVARCHAR(50) = 'SP';
	DECLARE @v_seq    INTEGER = 1;

	DECLARE @v_data_start_yyyymmdd NVARCHAR(8) = ''; -- BOH계산을 위한 기준 일자  


    BEGIN TRY
    BEGIN
        BEGIN TRAN TX_SH
			------------------------------------------------------------------------------------------------------------- 
			-- 0. temp 테이블 생성 :
			------------------------------------------------------------------------------------------------------------- 
			IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_UPDATE_BOH_40') IS NOT NULL
				DROP TABLE #tmp_SSP_ANL_SHIP_UPDATE_BOH_40

			CREATE TABLE #tmp_SSP_ANL_SHIP_UPDATE_BOH_40 (
				   DIVISION_ID  			nvarchar(030)
				 , PLAN_START_YYYYMMDD		nvarchar(008)
				 , PLAN_TYPE				nvarchar(050)
				 , SEQ						INT	
				 , ITEM_ID					nvarchar(050)
				 , FROM_SITE				nvarchar(030)
				 , TO_SITE					nvarchar(030)
				 , MEASURE					nvarchar(050)
				 , YYYYMMDD					nvarchar(008)
				 , BOD_ID					nvarchar(150)
				 , QTY						numeric(20,10)
				 , INCOTERMS				nvarchar(010)   
				 , TRANSPORT_MODE			nvarchar(050)    
				 , PROJECT_CODE				nvarchar(050)
				 , FCST_TYPE				nvarchar(020)
				 , CONFIRM_ID				nvarchar(020)
			);

			------------------------------------------------------------------------------------------------------------- 
			-- 0. 최근 PLAN 정보 확인 :
			------------------------------------------------------------------------------------------------------------- 
 
			SELECT @v_plan_start_yyyymmdd	= MAX(PLAN_START_YYYYMMDD)
			     , @v_plan_type				= MAX(PLAN_TYPE)
			     , @v_seq					= MAX(PLAN_SEQ)
			  FROM SSP_PLAN_VERSION_V
			 WHERE 1 = 1
			   AND DIVISION_ID				= @v_division_id 
			   AND PLAN_TYPE				= @v_plan_type
			   AND CONFIRM_FLAG				= 'Y'
		       AND PLAN_START_YYYYMMDD = (
			                             SELECT MAX(PLAN_START_YYYYMMDD)
										   FROM SSP_PLAN_VERSION_V T
										  WHERE T.DIVISION_ID  = @v_division_id 
										    AND T.PLAN_TYPE    = 'SP'
										    AND T.CONFIRM_FLAG = 'Y'
										    AND T.PLAN_START_YYYYMMDD < CONVERT(varchar, getdate(), 112)
										 )

	        -- WH_IN 및 BALANCE계산은 PLAN_START_YYYYMMDD 기준으로 수행
			SET @v_data_start_yyyymmdd = CONVERT(VARCHAR, DATEADD(D, 0, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ;

			------------------------------------------------------------------------------------------------------------- 
			-- 1. 변경날짜 이후  INSP_WIP  산출 :
			-------------------------------------------------------------------------------------------------------------

			WITH INSP AS (   -- INCO_WIP(Incomming WIP)의 BOH    
				 SELECT DISTINCT  
				        DIVISION_ID  	     
				      , PLAN_START_YYYYMMDD 
				      , PLAN_TYPE	         
				      , SEQ	             
				      , ITEM_ID	         
				      , FROM_SITE  
				      , SUM(QTY) AS QTY      
				   FROM SSP_ANL_SHIP_PLAN_40  WITH(NOLOCK ) 
				  WHERE 1 = 1 
				    AND DIVISION_ID				= @v_division_id         
				    AND PLAN_START_YYYYMMDD		= @v_plan_start_yyyymmdd  
				    AND PLAN_TYPE				= @v_plan_type           
				    AND SEQ						= @v_seq                
				    AND YYYYMMDD				= @v_data_start_yyyymmdd
				    AND MEASURE					= 'INCO_WIP' 
				  GROUP BY 
				        DIVISION_ID  	     
				      , PLAN_START_YYYYMMDD 
				      , PLAN_TYPE	         
				      , SEQ	             
				      , ITEM_ID	         
				      , FROM_SITE  
                 ),
			     Z AS (
				 SELECT DISTINCT  
				 	    DIVISION_ID  	     
				      , PLAN_START_YYYYMMDD 
				      , PLAN_TYPE	         
				      , SEQ	             
				      , ITEM_ID	         
				      , FROM_SITE  
				      , YYYYMMDD     
				   FROM SSP_ANL_SHIP_PLAN_40  WITH(NOLOCK ) 
				  WHERE 1 = 1 
				    AND DIVISION_ID				= @v_division_id         
				    AND PLAN_START_YYYYMMDD		= @v_plan_start_yyyymmdd  
				    AND PLAN_TYPE				= @v_plan_type           
				    AND SEQ						= @v_seq                
				    AND YYYYMMDD			   >= @v_data_start_yyyymmdd
				    AND MEASURE					IN ( 'INCO_WIP' ,'WH_IN')							
				  GROUP BY 
				        DIVISION_ID  	     
				      , PLAN_START_YYYYMMDD 
				      , PLAN_TYPE	         
				      , SEQ	             
				      , ITEM_ID	         
				      , FROM_SITE  
				      , YYYYMMDD 
				 ) 

              INSERT INTO #tmp_SSP_ANL_SHIP_UPDATE_BOH_40 (
					 DIVISION_ID  	     
				   , PLAN_START_YYYYMMDD 
				   , PLAN_TYPE	         
				   , SEQ	             
				   , ITEM_ID	         
				   , FROM_SITE	         
				   , TO_SITE	         
				   , MEASURE	         
				   , YYYYMMDD	         
				   , BOD_ID	           
				   , QTY	             
				   , INCOTERMS         
				   , TRANSPORT_MODE    
				   , PROJECT_CODE	     
				   , FCST_TYPE	
				   , CONFIRM_ID        
                   )			 
			  SELECT   
					 Z.DIVISION_ID            
				   , Z.PLAN_START_YYYYMMDD            
				   , Z.PLAN_TYPE            
				   , Z.SEQ            
				   , Z.ITEM_ID            
				   , Z.FROM_SITE    
				   , '-'		AS TO_SITE         
				   , 'INSP_WIP' AS MEASURE
				   , Z.YYYYMMDD  
				   , '-'		AS BOD_ID
				   , ISNULL(INSP.QTY,0)  --INCO_WIP의 BOH
				     + 
					 (                   -- 당일까지 INCO_WIP의 합  
				     SELECT  ISNULL(SUM(ISNULL(X.QTY, 0)) ,0)   
				   	   FROM SSP_ANL_SHIP_PLAN_40 AS X WITH(NOLOCK)   
				   	  WHERE 1 = 1  
				   	    AND X.DIVISION_ID          = Z.DIVISION_ID  
				   	    AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
				   	    AND X.PLAN_TYPE            = Z.PLAN_TYPE  
				   	    AND X.SEQ                  = Z.SEQ  
				   	    AND X.ITEM_ID              = Z.ITEM_ID  
				   	    AND X.FROM_SITE            = Z.FROM_SITE  
				   	    AND X.MEASURE              = 'INCO_WIP' 
				   	    AND X.YYYYMMDD             > @v_data_start_yyyymmdd
				   	    AND X.YYYYMMDD             <= Z.YYYYMMDD  
					 )   	
				     + 
					 (                   -- 전일까지 WH_IN의 합 
				     SELECT  ISNULL(SUM(ISNULL(X.QTY,0)),0)   * -1
				   	   FROM SSP_ANL_SHIP_PLAN_40 AS X WITH(NOLOCK)   
				   	  WHERE 1 = 1  
				   	    AND X.DIVISION_ID          = Z.DIVISION_ID  
				   	    AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
				   	    AND X.PLAN_TYPE            = Z.PLAN_TYPE  
				   	    AND X.SEQ                  = Z.SEQ  
				   	    AND X.ITEM_ID              = Z.ITEM_ID  
				   	    AND X.FROM_SITE            = Z.FROM_SITE  
				   	    AND X.MEASURE              = 'WH_IN' 
				   	    AND X.YYYYMMDD             >= @v_data_start_yyyymmdd
				   	    AND X.YYYYMMDD             < Z.YYYYMMDD	
					 )   	
				   , '-'   AS INCOTERMS         
				   , '-'   AS TRANSPORT_MODE    
				   , '-'   AS PROJECT_CODE	
				   , '-'   AS FCST_TYPE	
				   , '-'   AS CONFIRM_ID	
			    FROM Z WITH(NOLOCK)   
					 LEFT OUTER JOIN INSP WITH(NOLOCK) 
				  ON Z.DIVISION_ID			= INSP.DIVISION_ID  
				 AND Z.PLAN_START_YYYYMMDD	= INSP.PLAN_START_YYYYMMDD  
				 AND Z.PLAN_TYPE			= INSP.PLAN_TYPE  
				 AND Z.SEQ					= INSP.SEQ  
				 AND Z.ITEM_ID				= INSP.ITEM_ID  
				 AND Z.FROM_SITE			= INSP.FROM_SITE  
			   WHERE 1 = 1 
 			        ;

		        -- TCO 모델은 WH_IN과 관계없이 전부 0으로 SETTING (2019.04.19 Requested by 김광희) 해당내용 변경시 PR_SSP_ANL_SHIP_PLAN_40 동시 변경필요  
			  UPDATE #tmp_SSP_ANL_SHIP_UPDATE_BOH_40
				 SET QTY = 0 
				FROM #tmp_SSP_ANL_SHIP_UPDATE_BOH_40 P WITH(NOLOCK) 
				     JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) 
				  ON F.ITEM_ID			= P.ITEM_ID
				 AND F.DIVISION_ID		= P.DIVISION_ID   
				 AND F.TCO_CELL_YN		= 'Y'
			   WHERE P.MEASURE			= 'INSP_WIP'
				;
          ------------------------------------------------------------------------------------------------------------- 
          -- 2. UPDATE  INSP_WIP  
          -------------------------------------------------------------------------------------------------------------
			UPDATE SSP_ANL_SHIP_PLAN_40
			   SET QTY  = C.QTY 
			     , LAST_UPDATED_BY			= @v_batch_user
			     , LAST_UPDATE_DATE			= SYSDATETIME()
			  FROM SSP_ANL_SHIP_PLAN_40 AS P WITH(NOLOCK) 
				   JOIN #tmp_SSP_ANL_SHIP_UPDATE_BOH_40 AS C WITH(NOLOCK)
				ON P.DIVISION_ID			= C.DIVISION_ID         
			   AND P.PLAN_START_YYYYMMDD	= C.PLAN_START_YYYYMMDD 
			   AND P.PLAN_TYPE				= C.PLAN_TYPE           
			   AND P.SEQ					= C.SEQ                 
			   AND P.ITEM_ID				= C.ITEM_ID             
			   AND P.FROM_SITE				= C.FROM_SITE           
			   AND P.TO_SITE				= C.TO_SITE             
			   AND P.YYYYMMDD				= C.YYYYMMDD            
			   AND P.BOD_ID					= C.BOD_ID              
			   AND P.INCOTERMS				= C.INCOTERMS           
			   AND P.TRANSPORT_MODE			= C.TRANSPORT_MODE      
			   AND P.PROJECT_CODE			= C.PROJECT_CODE        
			   AND P.FCST_TYPE				= C.FCST_TYPE   
			   AND P.MEASURE				= C.MEASURE
			   AND ISNULL(P.CONFIRM_ID,'-') = ISNULL(C.CONFIRM_ID,'-')  
			 WHERE 1 = 1 
			   AND P.DIVISION_ID			= @v_division_id
			   AND P.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd 
			   AND P.PLAN_TYPE				= @v_plan_type
			   AND P.SEQ					= @v_seq
			   AND P.YYYYMMDD              >= @v_data_start_yyyymmdd
			   AND P.MEASURE                = 'INSP_WIP'
			;

			------------------------------------------------------------------------------------------------------------- 
			-- 3. 변경날짜 이후  WH_STOCK  산출 :
			--      당일 WH_STOC = OWMS 가용수량 
			--      익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM - 전일POSTP_PLAN - 전일 MES_FCS_HOLD수량(MES/FCS) + 전일 MES_FCS_RELEASE수량(MES/FCS 사용자설정)
			-------------------------------------------------------------------------------------------------------------
			WITH BOH AS (   -- 수행시 최신 시점의 OWMS 재고정보 + B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 재고 수량 적용 (<--SSP_ANL_TCO_STOCK_C)
			     SELECT A.DIVISION_ID
				 	  , A.PLAN_START_YYYYMMDD
				 	  , A.PLAN_TYPE
				 	  , A.SEQ
				 	  , A.FROM_SITE
				 	  , A.ITEM_ID
				 	  , SUM(A.QTY)   AS QTY
				   FROM (
				 	    SELECT A.DIVISION_ID
				 	    	 , A.PLAN_START_YYYYMMDD
				 	    	 , A.PLAN_TYPE
				 	    	 , A.SEQ
				 	    	 , A.FROM_SITE
				 	    	 , A.ITEM_ID
				 	    	 , (CASE WHEN ISNULL(C.SEGMENT3, '-') = 'P' THEN SUM(A.LOT_QTY_MES) ELSE 0 END) AS QTY
				 	      FROM SSP_ANL_MES_FCS_STOCK_40_C AS A WITH(NOLOCK)
				 	    	   LEFT OUTER JOIN SCP_MST_FINAL_ITEM AS B WITH(NOLOCK)
				 	    	ON B.DIVISION_ID		= A.DIVISION_ID
				 	       AND B.ITEM_ID			= A.ITEM_ID
				 	    	   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) 
				 	    	ON C.LOOKUP_TYPE		= 'CELL_TYPE_CODE' 
				 	       AND C.VALID_YN			= 'Y' 
				 	       AND C.SEGMENT1			= B.CELL_TYPE_GROUP_CODE
				 	     WHERE 1 = 1
				 	       AND A.DIVISION_ID         = @v_division_id
				 	       AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				 	       AND A.PLAN_TYPE           = @v_plan_type
				 	       AND A.SEQ                 = @v_seq
				 	       AND A.AVAILABLE_YN <> 'N'
				 	       AND ISNULL(A.CHANGE_STATUS, '') <> 'D'
				 	     GROUP BY 
				 		       A.DIVISION_ID
				 	   	     , A.PLAN_START_YYYYMMDD
				 	   	     , A.PLAN_TYPE
				 	   	     , A.SEQ
				 	   	     , A.FROM_SITE
				 	   	     , A.ITEM_ID
				 	   	     , C.SEGMENT3

						 UNION ALL

						SELECT A.DIVISION_ID
							 , A.PLAN_START_YYYYMMDD
							 , A.PLAN_TYPE
							 , A.SEQ
							 , A.FROM_SITE
							 , A.ITEM_ID
							 , SUM(A.AVAILABLE_QTY) AS QTY
						  FROM SSP_ANL_OWMS_STOCK_C AS A WITH(NOLOCK)
						 WHERE 1 = 1
						   AND A.DIVISION_ID         = @v_division_id
						   AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						   AND A.PLAN_TYPE           = @v_plan_type
						   AND A.SEQ                 = @v_seq
						 GROUP BY 
						       A.DIVISION_ID
							 , A.PLAN_START_YYYYMMDD
							 , A.PLAN_TYPE
							 , A.SEQ
							 , A.FROM_SITE
							 , A.ITEM_ID

						UNION ALL

						--STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 외주 재고
						SELECT T.DIVISION_ID  	        AS DIVISION_ID   
						     , T.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
						     , T.PLAN_TYPE	            AS PLAN_TYPE
						     , T.SEQ 	                AS SEQ
						     , T.SCM_SITE_ID            AS FROM_SITE  
						     , T.ITEM_ID	            AS ITEM_ID   
						     , ROUND(SUM(T.QTY),0) AS  QTY	  
						  FROM SSP_ANL_TCO_STOCK_C AS T WITH(NOLOCK)  
						 GROUP BY 
							   T.DIVISION_ID 
						     , T.PLAN_START_YYYYMMDD
						     , T.PLAN_TYPE
						     , T.SEQ
						     , T.ITEM_ID
						     , T.SCM_SITE_ID
						) A
				  WHERE 1 = 1
				  GROUP BY 
					    A.DIVISION_ID
					  , A.PLAN_START_YYYYMMDD
					  , A.PLAN_TYPE
					  , A.SEQ
					  , A.FROM_SITE
					  , A.ITEM_ID
				 ),  
			     Z AS (
				 SELECT DISTINCT  
				        DIVISION_ID  	     
				      , PLAN_START_YYYYMMDD 
				      , PLAN_TYPE	         
				      , SEQ	             
				      , ITEM_ID	         
				      , FROM_SITE  
				      , YYYYMMDD     
				   FROM SSP_ANL_SHIP_PLAN_40 WITH(NOLOCK ) 
				  WHERE 1 = 1 
				    AND DIVISION_ID         = @v_division_id         -- '81'
				    AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd -- '20180429' 
				    AND PLAN_TYPE           = @v_plan_type           -- 'SP'
				    AND SEQ                 = @v_seq                 -- '3'
				    AND MEASURE IN ( 'SHIP_CONFIRM' ,'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
				    AND YYYYMMDD            >= @v_data_start_yyyymmdd
				  GROUP BY 
				        DIVISION_ID  	     
				      , PLAN_START_YYYYMMDD 
				      , PLAN_TYPE	         
				      , SEQ	             
				      , ITEM_ID	         
				      , FROM_SITE  
				      , YYYYMMDD 
				 )  

			INSERT INTO #tmp_SSP_ANL_SHIP_UPDATE_BOH_40 (
				   DIVISION_ID  	     
				 , PLAN_START_YYYYMMDD 
				 , PLAN_TYPE	         
				 , SEQ	             
				 , ITEM_ID	         
				 , FROM_SITE	         
				 , TO_SITE	         
				 , MEASURE	         
				 , YYYYMMDD	         
				 , BOD_ID	           
				 , QTY	             
				 , INCOTERMS         
				 , TRANSPORT_MODE    
				 , PROJECT_CODE	     
				 , FCST_TYPE
				 , CONFIRM_ID	      			 
				 )
			SELECT   
				   Z.DIVISION_ID            
				 , Z.PLAN_START_YYYYMMDD            
				 , Z.PLAN_TYPE            
				 , Z.SEQ            
				 , Z.ITEM_ID            
				 , Z.FROM_SITE    
				 , '-'			AS TO_SITE         
				 , 'WH_STOCK'	AS MEASURE
				 , Z.YYYYMMDD  
				 , '-'			AS BOD_ID
				 , --CASE WHEN CONVERT(NVARCHAR(8), getdate(), 112) < Z.YYYYMMDD THEN
				   CASE WHEN @v_plan_start_yyyymmdd < Z.YYYYMMDD THEN
						CASE WHEN (ISNULL(B.SEGMENT3, '-') = 'P') THEN
						          ( -- 전일 WH_IN , 전일 SHIP_CONFIRM
							      SELECT ISNULL( SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * ISNULL(X.QTY,0)  
																    WHEN 'POSTP_PLAN'      THEN -1 * ISNULL(X.QTY,0)   
							 								        WHEN 'MES_FCS_HOLD'    THEN -1 * ISNULL(X.QTY,0)
																    WHEN 'WH_IN'           THEN      ISNULL(X.QTY,0)  
																    WHEN 'MES_FCS_RELEASE' THEN      ISNULL(X.QTY,0)  
													 ELSE 0.0 
													 END) ,0)   
								    FROM SSP_ANL_SHIP_PLAN_40 AS X WITH(NOLOCK)   
				                   WHERE 1 = 1  
								     AND X.DIVISION_ID          = Z.DIVISION_ID  
								     AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
								     AND X.PLAN_TYPE            = Z.PLAN_TYPE  
								     AND X.SEQ                  = Z.SEQ  
								     AND X.ITEM_ID              = Z.ITEM_ID  
								     AND X.FROM_SITE            = Z.FROM_SITE  
								     AND X.MEASURE              IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
								     AND X.YYYYMMDD             >= @v_data_start_yyyymmdd
								     AND X.YYYYMMDD             <  Z.YYYYMMDD  
							      )
						ELSE
						          ( -- 전일 WH_IN , 전일 SHIP_CONFIRM
								  SELECT ISNULL( SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * ISNULL(X.QTY,0)  
																    WHEN 'POSTP_PLAN'      THEN -1 * ISNULL(X.QTY,0)   
																    WHEN 'MES_FCS_HOLD'    THEN -1 * ISNULL(X.QTY,0)
																    WHEN 'WH_IN'           THEN      ISNULL(X.QTY,0)  
																    WHEN 'MES_FCS_RELEASE' THEN      ISNULL(X.QTY,0)  
												     ELSE 0.0 
													 END) ,0)   
								    FROM SSP_ANL_SHIP_PLAN_40 AS X WITH(NOLOCK)   
							       WHERE 1 = 1  
								     AND X.DIVISION_ID          = Z.DIVISION_ID  
								     AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
								     AND X.PLAN_TYPE            = Z.PLAN_TYPE  
								     AND X.SEQ                  = Z.SEQ  
								     AND X.ITEM_ID              = Z.ITEM_ID  
								     AND X.FROM_SITE            = Z.FROM_SITE  
								     AND X.MEASURE              IN ('SHIP_CONFIRM','WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
								     AND X.YYYYMMDD             >= @v_data_start_yyyymmdd
								     AND X.YYYYMMDD             <  Z.YYYYMMDD  
							      )
						END
				   ELSE 0 
				   END
				   + 
				   ISNULL(BOH.QTY,0) 
				   - 
				   -- 2020.09.09 KBK : 'DCP', 'MDP', 'MIP', 'MTP' 처리
				   CASE WHEN @v_data_start_yyyymmdd <= Z.YYYYMMDD THEN
					    CASE WHEN ISNULL(B.SEGMENT3, '-') = 'P' THEN ISNULL(B.WH_IN_QTY2, 0)
						ELSE 0 
						END
				   ELSE 0 
				   END
				   - 
				   ISNULL((
					      SELECT SUM(H.HOLD_QTY )  -- HOLD재고 제외
						    FROM SSP_ANL_HOLD_STOCK AS H WITH(NOLOCK) 
						       , SCM_SYS_CALENDAR_M AS C WITH(NOLOCK)
						   WHERE H.DIVISION_ID         = @v_division_id 
						     AND H.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						     AND H.PLAN_TYPE           = @v_plan_type
						     AND H.SEQ                 = @v_seq
						     AND C.BASIS_YYYYMMDD     >= H.HOLD_YYYYMMDD
						     AND C.BASIS_YYYYMMDD     <= H.RELEASE_YYYYMMDD
						     AND C.BASIS_YYYYMMDD     >= @v_data_start_yyyymmdd
						     AND H.DIVISION_ID         = Z.DIVISION_ID 
						     AND H.FROM_SITE           = Z.FROM_SITE
						     AND H.ITEM_ID             = Z.ITEM_ID 
						     AND C.BASIS_YYYYMMDD      = Z.YYYYMMDD	
   						   GROUP BY 
						         H.DIVISION_ID 
						       , H.FROM_SITE
						       , H.ITEM_ID 
						       , C.BASIS_YYYYMMDD 
						  ) ,0) AS QTY
				 , '-'			AS INCOTERMS         
				 , '-'			AS TRANSPORT_MODE    
				 , '-'			AS PROJECT_CODE	
				 , '-'			AS FCST_TYPE	
				 , '-'			AS CONFIRM_ID	
			  FROM Z WITH(NOLOCK)   
				   LEFT OUTER JOIN BOH WITH(NOLOCK) 
			    ON Z.DIVISION_ID         = BOH.DIVISION_ID  
			   AND Z.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD  
			   AND Z.PLAN_TYPE           = BOH.PLAN_TYPE  
			   AND Z.SEQ                 = BOH.SEQ  
			   AND Z.ITEM_ID             = BOH.ITEM_ID  
			   AND Z.FROM_SITE           = BOH.FROM_SITE  
				   LEFT OUTER JOIN (
				            	   SELECT A.DIVISION_ID
				            	        , A.PLAN_START_YYYYMMDD
				            	        , A.PLAN_TYPE
				            	        , A.SEQ
				            	        , A.ITEM_ID
				            	        , A.FROM_SITE
				            	        , SUM(A.QTY)   AS WH_IN_QTY2
				            	        , C.SEGMENT3
				            	     FROM SSP_ANL_SHIP_PLAN_40 AS A WITH(NOLOCK)
				            	          LEFT OUTER JOIN SCP_MST_FINAL_ITEM AS B WITH(NOLOCK)
				            	       ON B.DIVISION_ID = A.DIVISION_ID
				            	      AND B.ITEM_ID = A.ITEM_ID
				            	          JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS C WITH(NOLOCK) 
				                      ON C.LOOKUP_TYPE			= 'CELL_TYPE_CODE' 
				                     AND C.VALID_YN				= 'Y' 
				                     AND C.SEGMENT3				= 'P'
				                     AND C.SEGMENT1				= B.CELL_TYPE_GROUP_CODE
				                         JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
				                      ON D.LOOKUP_TYPE			= 'POUCH_WH_IN_DAY' 
				                     AND D.SEGMENT1				= SUBSTRING(A.ITEM_ID, 1, 3)
				                     AND D.VALID_YN				= 'Y' 
				                   WHERE 1 = 1
				                     AND A.DIVISION_ID			= @v_division_id
				                     AND A.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
				                     AND A.PLAN_TYPE			= @v_plan_type
				                     AND A.SEQ					= @v_seq
				                     AND A.MEASURE				= 'WH_IN'
				                     AND A.YYYYMMDD				> @v_data_start_yyyymmdd
				                     AND A.YYYYMMDD				<= CONVERT(VARCHAR, DATEADD(D, CONVERT(INT, D.SEGMENT2), CONVERT(DATETIME, @v_data_start_yyyymmdd ,112)) ,112)
				                   GROUP BY 
				                         A.DIVISION_ID
				                       , A.PLAN_START_YYYYMMDD
				                       , A.PLAN_TYPE
				                       , A.SEQ
				                       , A.ITEM_ID
				                       , A.FROM_SITE
				                       , C.SEGMENT3
				                   )  B
			    ON B.DIVISION_ID			= Z.DIVISION_ID
			   AND B.PLAN_START_YYYYMMDD	= Z.PLAN_START_YYYYMMDD
			   AND B.PLAN_TYPE				= Z.PLAN_TYPE
			   AND B.SEQ					= Z.SEQ
			   AND B.ITEM_ID				= Z.ITEM_ID
			   AND B.FROM_SITE				= Z.FROM_SITE
			 WHERE 1 = 1 
			;


          ------------------------------------------------------------------------------------------------------------- 
          -- 4. UPDATE  WH_STOCK  
          -------------------------------------------------------------------------------------------------------------
			UPDATE SSP_ANL_SHIP_PLAN_40
			   SET QTY  = C.QTY 
			     , LAST_UPDATED_BY			= @v_batch_user
			     , LAST_UPDATE_DATE			= SYSDATETIME()
			  FROM SSP_ANL_SHIP_PLAN_40 AS P WITH(NOLOCK) 
				   JOIN #tmp_SSP_ANL_SHIP_UPDATE_BOH_40 AS C WITH(NOLOCK)
			    ON P.DIVISION_ID			= C.DIVISION_ID         
			   AND P.PLAN_START_YYYYMMDD	= C.PLAN_START_YYYYMMDD 
			   AND P.PLAN_TYPE				= C.PLAN_TYPE           
			   AND P.SEQ					= C.SEQ                 
			   AND P.ITEM_ID				= C.ITEM_ID             
			   AND P.FROM_SITE				= C.FROM_SITE           
			   AND P.TO_SITE				= C.TO_SITE             
			   AND P.YYYYMMDD				= C.YYYYMMDD            
			   AND P.BOD_ID					= C.BOD_ID              
			   AND P.INCOTERMS				= C.INCOTERMS           
			   AND P.TRANSPORT_MODE			= C.TRANSPORT_MODE      
			   AND P.PROJECT_CODE			= C.PROJECT_CODE        
			   AND P.FCST_TYPE				= C.FCST_TYPE   
			   AND P.MEASURE				= C.MEASURE
			   AND ISNULL(P.CONFIRM_ID,'-') =   ISNULL(C.CONFIRM_ID,'-')  
			 WHERE 1 = 1 
			   AND P.DIVISION_ID			= @v_division_id
			   AND P.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd 
			   AND P.PLAN_TYPE				= @v_plan_type
			   AND P.SEQ					= @v_seq
			   AND P.MEASURE				= 'WH_STOCK'
			   AND P.YYYYMMDD			   >= @v_data_start_yyyymmdd
			;


			------------------------------------------------------------------------------------------------------------- 
			-- 5. UPDATE BALANCE 
			-------------------------------------------------------------------------------------------------------------
			WITH BAL AS (
				 SELECT P.DIVISION_ID             
				      , P.PLAN_START_YYYYMMDD 
				      , P.PLAN_TYPE           
				      , P.SEQ                 
				      , P.ITEM_ID             
				      , P.FROM_SITE   
				      , '-'             AS TO_SITE     
				      , 'BALANCE'       AS MEASURE         
				      , P.YYYYMMDD       
				      , '-'             AS BOD_ID
				      , SUM(CASE WHEN P.MEASURE ='WH_STOCK'		THEN P.QTY ELSE 0 END ) 
				      - SUM(CASE WHEN P.MEASURE ='SHIP_CONFIRM' THEN P.QTY ELSE 0 END )  
				      - SUM(CASE WHEN P.MEASURE ='POSTP_PLAN'   THEN P.QTY ELSE 0 END ) 	AS QTY
				      , '-'             AS INCOTERMS         
				      , '-'             AS TRANSPORT_MODE    
				      , '-'             AS PROJECT_CODE	     
				      , '-'             AS FCST_TYPE
				      , '-'             AS CONFIRM_ID 	  
				  FROM  SSP_ANL_SHIP_PLAN_40 AS P WITH(NOLOCK) 
				 WHERE 1 = 1 
				   AND P.DIVISION_ID			= @v_division_id 
				   AND P.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd        
				   AND P.PLAN_TYPE				= @v_plan_type                  
				   AND P.SEQ					= @v_seq                           
				   AND P.MEASURE				IN ('WH_STOCK', 'SHIP_CONFIRM', 'POSTP_PLAN')
				   AND P.YYYYMMDD				>= @v_data_start_yyyymmdd       
				 GROUP BY 
					   P.DIVISION_ID         
					 , P.PLAN_START_YYYYMMDD 
					 , P.PLAN_TYPE           
					 , P.SEQ                 
					 , P.ITEM_ID             
					 , P.FROM_SITE           
					 , P.YYYYMMDD            
			     )


			UPDATE SSP_ANL_SHIP_PLAN_40
			   SET QTY						= BAL.QTY
			     , LAST_UPDATED_BY			= @v_batch_user
			     , LAST_UPDATE_DATE			= SYSDATETIME()
			  FROM SSP_ANL_SHIP_PLAN_40 AS B WITH(NOLOCK)   
				   JOIN BAL WITH(NOLOCK) 
				ON BAL.DIVISION_ID			= B.DIVISION_ID          
			   AND BAL.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD  
			   AND BAL.PLAN_TYPE			= B.PLAN_TYPE            
			   AND BAL.SEQ					= B.SEQ                  
			   AND BAL.ITEM_ID				= B.ITEM_ID              
			   AND BAL.FROM_SITE			= B.FROM_SITE            
			   AND BAL.TO_SITE				= B.TO_SITE              
			   AND BAL.YYYYMMDD				= B.YYYYMMDD             
			   AND BAL.BOD_ID				= B.BOD_ID               
			   AND BAL.INCOTERMS			= B.INCOTERMS            
			   AND BAL.TRANSPORT_MODE		= B.TRANSPORT_MODE       
			   AND BAL.PROJECT_CODE			= B.PROJECT_CODE         
			   AND BAL.FCST_TYPE			= B.FCST_TYPE
			 WHERE 1 = 1 
			   AND B.DIVISION_ID			= @v_division_id                     
			   AND B.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd        
			   AND B.PLAN_TYPE				= @v_plan_type                
			   AND B.SEQ					= @v_seq                          
			   AND B.MEASURE				= 'BALANCE'   
			   AND B.YYYYMMDD				>= @v_data_start_yyyymmdd     

			;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRAN TX_SH;
        END;  

		------------------------------------------------------------------------------------------------------------- 
		-- 6. 0값 제거
		-------------------------------------------------------------------------------------------------------------
		DELETE 
		  FROM  SSP_ANL_SHIP_PLAN_40  
		WHERE 1 = 1 
		AND DIVISION_ID				= @v_division_id 
		AND PLAN_START_YYYYMMDD		= @v_plan_start_yyyymmdd        
		AND PLAN_TYPE				= @v_plan_type                  
		AND SEQ						= @v_seq 
		AND QTY						= 0

        -- TXN LOG
        SET @v_log_type		= N'TXN';    -- ▶ 로그타입
        SET @n_log_count	= @@ROWCOUNT;
        SET @v_log_message	= N'INSERT INTO '+@v_table_id;
        SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date	= SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH
        END;
      
		-- ERROR LOG
		SET @v_log_type		= N'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
								  ,@p_log_type      =@v_log_type
								  ,@p_log_count     =@n_log_count 
								  ,@p_log_message   =@v_log_message 
								  ,@p_description   =@v_description 
								  ,@p_event_date    =@d_event_date 
								  ,@p_user_id       =@v_batch_user
                                ;
		IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_UPDATE_BOH_40') IS NOT NULL
			DROP TABLE #tmp_SSP_ANL_SHIP_UPDATE_BOH_40

		return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type		= N'END';
    SET @v_log_message	= N'########## END of procedure ##########';
    SET @v_description	= N'['+@v_program_name+'][' + @v_exec_time + ']';  
    SET @d_event_date	= SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;

	IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_UPDATE_BOH_40') IS NOT NULL
		DROP TABLE #tmp_SSP_ANL_SHIP_UPDATE_BOH_40
   
    return 1  

  END; 
