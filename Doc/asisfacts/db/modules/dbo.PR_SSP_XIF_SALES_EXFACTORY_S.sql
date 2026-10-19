
/*
 * Program ID   : PR_SSP_PLN_FP_SHIP_TARGET_WA 
 * Description  : FP 출하 WA법인 TARGET 전송 
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.06.21   jilee          오창 FP SSP 출하 계획 WA법인 FP로 송신
 * 2023.07.06   jilee          ACCUM_COUNT - PLAN_ID, DIVISION 기준으로 수량 변경
 */
 
CREATE PROCEDURE [dbo].[PR_SSP_XIF_SALES_EXFACTORY_S]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
 --   SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'ssp_batch'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_PLN_FP_SHIP_TARGET_WA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'XIF_FP_SSP_SALES_EXFACTORY_S_SN'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_PLAN INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;

    DECLARE @p_company_id               NVARCHAR(30) = 'ALL';
	DECLARE @p_plan_start_yyyymmdd      NVARCHAR(8);

	SET  @p_plan_start_yyyymmdd = CONVERT(VARCHAR, GETDATE() ,112) ;

	-- DATA 생성 FROM ~ TO 
    DECLARE @v_data_start_yyyymmdd  NVARCHAR(8) = '';
	DECLARE @v_data_end_yyyymmdd    NVARCHAR(8) = '';

	DECLARE @n_accum_count          INTEGER = 0;

	SET  @v_data_start_yyyymmdd = CONVERT(VARCHAR, GETDATE() - 1 ,112) ;
	SET  @v_data_end_yyyymmdd   = CONVERT(VARCHAR, DATEADD(D, 56, GETDATE()) ,112) ; --8주(56일)   
   
    BEGIN TRY
      BEGIN

        ----------------------------------------------------------- 
        -- 1. interface data creation
        -----------------------------------------------------------        
            DECLARE @X_CNT                     INT           = 0;

                                               
            DECLARE @X_IF_ID                   NVARCHAR(50)  = 'OSCM_PFP0_SSP_SALES_EXFACTORY';

                                               
            DECLARE @X_IF_RCV_DATE             DATETIME       = GETDATE();
            DECLARE @X_PROC_FLAG               NVARCHAR(1)    = 'N';
            DECLARE @X_PROC_DATE               DATETIME       =  NULL;
            DECLARE @X_PLAN_ID                 NVARCHAR(12);

 
            DECLARE @X_SEND_SEQ                INT           = 1;
			DECLARE @IFSEQNO			   	   NVARCHAR(50)	 = '';
			DECLARE @FP_SEND_SEQ               NVARCHAR(50)  = '';  
 
            SELECT @X_CNT = COUNT(1)
              FROM DBO.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
             WHERE PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
               --AND DIVISION_ID         = @p_company_id
               AND PLAN_TYPE           = 'SPE'-- 전극은 SPE로 구분 
               AND IF_ID               = @X_IF_ID;   
      
            IF (@X_CNT > 0)
               BEGIN
                    SELECT @X_CNT = MAX(IFSEQNO)
                      FROM SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
                     WHERE PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                       --AND DIVISION_ID         = @p_company_id
                       AND PLAN_TYPE           = 'SPE'-- 전극은 SPE로 구분 
                       AND IF_ID               = @X_IF_ID;  
                       
                    SET @X_SEND_SEQ = @X_CNT +1;    
               
               END

            -- 전송순차 = 해당일자 YYYYMMDD + '001' 일련번호
            SET @X_PLAN_ID = @p_plan_start_yyyymmdd + '_' + DBO.FN_ZERO_LPAD( @X_SEND_SEQ,3 );

			--SELECT @IFSEQNO = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_FP_IFSEQNO) ,6)
    
	        SET @FP_SEND_SEQ = NEXT VALUE FOR [LGCE_SCMDEV].[dbo].[XIF_FP_SEND_SEQ];

			SELECT @IFSEQNO = 'OFP0' + SUBStRING(CONVERT(NVARCHAR(12), GETDATE(), 112),3,6)
								     + REPLICATE('0', 10 - LEN(@FP_SEND_SEQ))
								     + CAST (@FP_SEND_SEQ AS NVARCHAR)

          IF OBJECT_ID('tempdb..#tmp_XIF_FP_SSP_SALES_EXFACTROY') IS NOT NULL
              DROP TABLE #tmp_XIF_FP_SSP_SALES_EXFACTROY

			CREATE TABLE #tmp_XIF_FP_SSP_SALES_EXFACTROY 
			(
				 IF_SEQ                   nvarchar(50)
				,IF_TYPE                  nvarchar(1)
				,IF_ID                    nvarchar(50)
				,IF_INS_DATE              datetime
				,IF_FLAG                  nvarchar(1)
				,IF_SND_DATE              datetime
				,PLAN_ID                  nvarchar(20)
				,SHIP_ID                  nvarchar(200)
				,ITEM_ID                  nvarchar(40)
				,OPERATION_GROUP          nvarchar(40)
				,SITE_CODE                nvarchar(40)
				,PLANT_ID                 nvarchar(40)
				,CUSTOMER_CODE            nvarchar(40)
				,CUSTOMER_NAME            nvarchar(100)
				,DEST_SITE_CODE           nvarchar(40)
				,DEST_PLANT_ID            nvarchar(40)
				,DESTINATION_SITE_TYPE    nvarchar(40)
				,EXFACTORY_YYYYMMDD       nvarchar(8)
				,EXFACTORY_QTY            numeric(18, 3)
				,ORDER_TYPE               nvarchar(40)
				,SHIP_METHOD              nvarchar(40)
				,PRIORITY                 nvarchar(200)
				,DIVISION                 nvarchar(20)
				,MARKET                   nvarchar(10)
				,CREATE_USER_ID           nvarchar(50)
				,CREATE_DATE              datetime
				,MODIFY_USER_ID           nvarchar(50)
				,MODIFY_DATE              datetime
				,SHIP_TO_PARTY            nvarchar(100)
				,RECEIVE_YYYYMMDD         nvarchar(8)
				,SHIP_TO_CODE             nvarchar(10)
				,GNRT_DTTM                datetime
				,ACCUM_COUNT              decimal(18, 5)
				,ATTR_01                  nvarchar(50) 
				,ATTR_02                  nvarchar(50) 
				,ATTR_03                  nvarchar(50) 
				,ATTR_04                  nvarchar(50) 
				,ATTR_05                  nvarchar(255)
			)
			
                INSERT INTO #tmp_XIF_FP_SSP_SALES_EXFACTROY
				(
					 [IF_SEQ] 
					,[IF_TYPE] 
					,[IF_ID] 
					,[IF_INS_DATE]
					,[IF_FLAG] 
					,[IF_SND_DATE]
					,[PLAN_ID] 
					,[SHIP_ID] 
					,[ITEM_ID] 
					,[OPERATION_GROUP] 
					,[SITE_CODE] 
					,[PLANT_ID] 
					,[CUSTOMER_CODE] 
					,[CUSTOMER_NAME] 
					,[DEST_SITE_CODE]
					,[DEST_PLANT_ID] 
					,[DESTINATION_SITE_TYPE] 
					,[EXFACTORY_YYYYMMDD] 
					,[EXFACTORY_QTY] 
					,[ORDER_TYPE] 
					,[SHIP_METHOD] 
					,[PRIORITY] 
					,[DIVISION] 
					,[MARKET] 
					,[CREATE_USER_ID] 
					,[CREATE_DATE] 
					,[MODIFY_USER_ID] 
					,[MODIFY_DATE]
					,[SHIP_TO_PARTY]
					,[RECEIVE_YYYYMMDD] 
					,[SHIP_TO_CODE] 
					,[GNRT_DTTM] 
					,[ACCUM_COUNT] 
					,[ATTR_01] 
					,[ATTR_02] 
					,[ATTR_03] 
					,[ATTR_04] 
					,[ATTR_05] 
				)
				SELECT    
				-- 인터페이스 공통 영역
				------------------------------------------------------------------------------------------------------
				 @IFSEQNO                                                                              AS IF_SEQ
				,'S'                                                                                   AS IF_TYPE
				,@X_IF_ID                                                                              AS IF_ID   
				,@x_if_rcv_date                                                                        AS IF_INS_DATE                                                               
				,@x_proc_flag                                                                          AS IF_FLAG                                                                 
				,@x_if_rcv_date                                                                        AS IF_SND_DATE         
				------------------------------------------------------------------------------------------------------
				,@X_PLAN_ID                                                                            AS PLAN_ID 
				,'EE' + '^' +X.ITEM_ID + '^' + X.SITE_CODE + '^' + X.DEST_SITE_CODE+ '^'               -- 전극 사업부 EE 
					+X.EXFACTORY_YYYYMMDD+ '^' + ISNULL(X.SHIP_METHOD,'')
					+ '^' +  'MPS' + '^' 
					+ [DBO].[FN_GET_SSP_DOM_EXP] (X.DIVISION, X.SITE_CODE, X.DEST_SITE_CODE)              AS SHIP_ID                                                              
				,X.ITEM_ID                                                                             AS ITEM_ID                                  
				,'E'                                                                                   AS OPERATION_GROUP                                                           
				,X.SITE_CODE                                                                           AS SITE_CODE  
				,FS.PLANT_ID                                                                           AS PLANT_ID
				,[DBO].[FN_GET_SITE_CUSTOMER_INFO] (X.ATTR_02, X.DEST_SITE_CODE,'SOLDTO_CODE')         AS CUSTOMER_CODE
				,[DBO].[FN_GET_SITE_CUSTOMER_INFO] (X.ATTR_02, X.DEST_SITE_CODE,'SOLDTO_DESCRIPTION')  AS CUSTOMER_NAME
				,X.DEST_SITE_CODE                                                                      AS DEST_SITE_CODE      
				,TS.PLANT_ID                                                                           AS DEST_PLANT_ID
				,TS.SITE_TYPE                                                                          AS DESTINATION_SITE_TYPE
				,X.EXFACTORY_YYYYMMDD                                                                  AS EXFACTORY_YYYYMMDD
				,SUM(X.EXFACTORY_QTY)                                                                  AS EXFACTORY_QTY                                                             
				, 'MPS'                                                                                AS ORDER_TYPE                                                               
				,X.SHIP_METHOD                                                                         AS SHIP_METHOD                                                               
				,'-'                                                                                   AS PRIORITY                                                                  
				,'EE'                                                                                  AS DIVISION  -- 전극은 EE로 전송                                                                  
				,[DBO].[FN_GET_SSP_DOM_EXP] (X.DIVISION, X.SITE_CODE, X.DEST_SITE_CODE)                AS MARKET                                                                    
				,'SSP'                                                                                 AS CREATE_USER_ID                                                            
				,@x_if_rcv_date                                                                        AS CREATE_DATE                                                               
				,'SSP'                                                                                 AS MODIFY_USER_ID                                                            
				,@x_if_rcv_date                                                                        AS MODIFY_DATE                             
				,[DBO].[FN_GET_SITE_CUSTOMER_INFO] (X.ATTR_02, X.DEST_SITE_CODE,'SHIPTO_DESCRIPTION')  AS SHIP_TO_PARTY
				,X.RECEIVE_YYYYMMDD                                                                    AS RECEIVE_YYYYMMDD  
				,[DBO].[FN_GET_SITE_CUSTOMER_INFO] (X.ATTR_02, X.DEST_SITE_CODE,'SHIPTO_CODE')         AS SHIP_TO_CODE 
				,@x_if_rcv_date                                                                        AS GNRT_DTTM 
				,0                                                                                     AS ACCUM_COUNT 
				,X.ATTR_01                                                                             AS ATTR_01    --ORIGIN_FROM_DIVISION_ID                                         
				,X.ATTR_02                                                                             AS ATTR_02    --ORIGIN_TO_DIVISION_ID     
				,ISNULL(X.ATTR_04, M.FACTORY_ID)                                                       AS ATTR_03    --FACTORY_ID    
				,LP.SEGMENT4                                                                           AS ATTR_04    --POST_OPER                                               
				,CASE WHEN X.ATTR_05 ='' THEN NULL ELSE  X.ATTR_05  END                                AS ATTR_05    --REMARKS   nvarchar(255)    
				FROM (
						SELECT C.DIVISION_ID									 AS DIVISION    
						,      C.FROM_SITE										 AS SITE_CODE
						,      C.ITEM_ID										 AS ITEM_ID 
						,      C.ORIGIN_TO_DIVISION_ID							 AS TO_DIVISION_ID 
						,      C.TO_SITE						                 AS DEST_SITE_CODE      
						,      C.YYYYMMDD						                 AS EXFACTORY_YYYYMMDD
						,      C.ETA_DATE						                 AS RECEIVE_YYYYMMDD
						,      C.QTY							                 AS EXFACTORY_QTY       
						,      C.TRANSPORT_MODE					                 AS SHIP_METHOD 
						,      C.ORIGIN_FROM_DIVISION_ID		                 AS ATTR_01    --ORIGIN_FROM_DIVISION_ID                                                    
						,      C.ORIGIN_TO_DIVISION_ID			                 AS ATTR_02    --ORIGIN_TO_DIVISION_ID  

						,      C.FACTORY_ID                                      AS ATTR_03    --FACTORY_ID
						,      NULL                                              AS ATTR_04    --POST_OPER
						,      C.REMARKS                                         AS ATTR_05    --REMARKS     
						,      'CONFIRM' 					                     AS TYPE	    
						FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
						WHERE 1=1 
						AND   C.CHANGE_TYPE = 'C'
						AND   C.BIZ_TYPE    = 'E'
						AND   C.FROM_SITE_COMPANY_ID = @p_company_id
						AND   C.YYYYMMDD    >= @v_data_start_yyyymmdd 
						AND   C.YYYYMMDD    <= @v_data_end_yyyymmdd
						--AND   C.QTY > 0 

						UNION ALL 

						SELECT R.FROM_DIVISION_ID                                AS DIVISION    
						,      R.FROM_SITE										 AS SITE_CODE
						,      R.ITEM_ID										 AS ITEM_ID 
						,      R.TO_DIVISION_ID									 AS TO_DIVISION_ID 
						,      R.TO_SITE										 AS DEST_SITE_CODE      
						,      R.ETD_DATE										 AS EXFACTORY_YYYYMMDD
						,      R.ETA_DATE						                 AS RECEIVE_YYYYMMDD
						,      R.QTY											 AS EXFACTORY_QTY       
						,      B.TRANSPORT_MODE					                 AS SHIP_METHOD 
						,      R.FROM_DIVISION_ID 		                         AS ATTR_01    --ORIGIN_FROM_DIVISION_ID                                                    
						,      R.TO_DIVISION_ID			                         AS ATTR_02    --ORIGIN_TO_DIVISION_ID    
						,      NULL                                              AS ATTR_03    --FACTORY_ID
						,      NULL                                              AS ATTR_04    --POST_OPER
						,      NULL                                              AS ATTR_05    --REMARKS 
						,      'REQUEST' 					                     AS TYPE											    
						FROM SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK)				        
							JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK)  
								ON B.DIVISION_ID = R.FROM_DIVISION_ID 
								AND B.BOD_ID      = R.BOD_ID 

						WHERE 1=1 
						--AND   R.FROM_COMPANY_ID = @p_company_id
						AND   R.ETD_DATE    >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID ,R.FROM_SITE) , CONVERT(DATETIME, @v_data_start_yyyymmdd ,112)) ,112)
						AND   R.ETD_DATE    <  @v_data_end_yyyymmdd
						--AND   R.QTY >0 
					) X
					JOIN SCM_MST_SITE FS WITH(NOLOCK) 
						ON FS.DIVISION_ID = X.DIVISION
						AND FS.SCM_SITE_ID = X.SITE_CODE 
						AND FS.OPERATION_GROUP  = 'E'

					JOIN SCM_MST_SITE TS WITH(NOLOCK) 
						ON TS.DIVISION_ID = X.TO_DIVISION_ID
						AND TS.SCM_SITE_ID = X.DEST_SITE_CODE 

					LEFT OUTER JOIN SSP_MST_SHIP_MASTER_EE  M WITH(NOLOCK) 
							ON M.DIVISION_ID  = X.DIVISION 
						AND M.SCM_SITE_ID = X.SITE_CODE 
						AND M.ITEM_ID     = X.ITEM_ID

					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LP WITH(NOLOCK) 
						ON LP.LOOKUP_TYPE = 'ELECTRODE_POST_OPER_CODE' 
						AND LP.SEGMENT1   = M.DIVISION_ID 
						AND LP.SEGMENT2   = M.ELECTRODE_POST_OPER_CODE
				GROUP BY X.DIVISION    
				,        X.SITE_CODE
				,        X.ITEM_ID 
				,        X.TO_DIVISION_ID 
				,        X.DEST_SITE_CODE      
				,        X.EXFACTORY_YYYYMMDD
				,        X.RECEIVE_YYYYMMDD
				,        X.SHIP_METHOD 
				,        X.ATTR_01           --ORIGIN_FROM_DIVISION_ID                                         
				,        X.ATTR_02           --ORIGIN_TO_DIVISION_ID     
				,        X.ATTR_03           --PACKAGE_TYPE                                                    
				,        X.ATTR_04           --FACTORY_ID                
				,        X.ATTR_05           --REMARKS   nvarchar(255)                
				,        M.PACKAGE_TYPE_CODE
				,        M.FACTORY_ID
				,        FS.PLANT_ID
				,        TS.PLANT_ID
				,        TS.SITE_TYPE
				,        LP.SEGMENT4

				UNION ALL

					SELECT 
					-- 인터페이스 공통 영역
					------------------------------------------------------------------------------------------------------
					 @IFSEQNO                                                                              AS IF_SEQ
					,'S'                                                                                   AS IF_TYPE
					,@X_IF_ID                                                                              AS IF_ID   
					,@x_if_rcv_date                                                                        AS IF_INS_DATE                                                               
					,@x_proc_flag                                                                          AS IF_FLAG                                                                 
					,@x_if_rcv_date                                                                        AS IF_SND_DATE         
					------------------------------------------------------------------------------------------------------
					,@X_PLAN_ID    AS PLAN_ID 
					,P.DIVISION_ID + '^' +P.ITEM_ID + '^' + P.FROM_SITE + '^' + P.TO_SITE+ '^' +P.YYYYMMDD+ '^' + ISNULL(P.TRANSPORT_MODE,'')
						+ '^' +  ( CASE P.FCST_TYPE WHEN '-' THEN 'MPS' ELSE P.FCST_TYPE END ) + '^' + [DBO].[FN_GET_SSP_DOM_EXP] (P.DIVISION_ID,P.FROM_SITE,P.TO_SITE)    
															AS SHIP_ID                                                              
					,P.ITEM_ID                                                                   
					,V.OPERATION_GROUP  AS OPERATION_GROUP                                                           
					,P.FROM_SITE AS SITE_CODE     
					, ( SELECT TOP 1 PLANT_ID 
						FROM SCM_MST_SITE WITH(NOLOCK)
						WHERE DIVISION_ID = P.DIVISION_ID
						AND SCM_SITE_ID = P.FROM_SITE ) AS PLANT_ID                        
					,[DBO].[FN_GET_SITE_CUSTOMER_INFO] (P.DIVISION_ID,P.TO_SITE,'SOLDTO_CODE')         AS CUSTOMER_CODE
					,[DBO].[FN_GET_SITE_CUSTOMER_INFO] (P.DIVISION_ID,P.TO_SITE,'SOLDTO_DESCRIPTION')  AS CUSTOMER_NAME
					,P.TO_SITE AS DEST_SITE_CODE
					, ( SELECT TOP 1 PLANT_ID 
						FROM SCM_MST_SITE WITH(NOLOCK)
						WHERE DIVISION_ID = P.DIVISION_ID
						AND SCM_SITE_ID = P.TO_SITE ) AS DEST_PLANT_ID
					, ( SELECT TOP 1 SITE_TYPE 
						FROM SCM_MST_SITE WITH(NOLOCK)
						WHERE DIVISION_ID = P.DIVISION_ID
						AND SCM_SITE_ID = P.TO_SITE ) AS DESTINATION_SITE_TYPE
                    ,P.YYYYMMDD AS EXFACTORY_YYYYMMDD  
					,SUM(P.QTY)      AS EXFACTORY_QTY  
					,CASE WHEN P.FCST_TYPE ='-' THEN 'MPS' ELSE P.FCST_TYPE END  AS ORDER_TYPE                                                               
					,P.TRANSPORT_MODE AS SHIP_METHOD                                                               
					,'-'   AS PRIORITY                                                                  
					,P.DIVISION_ID  AS DIVISION                                                                  
					,'E'  AS MARKET                                                                    
					,'SSP' AS CREATE_USER_ID                                                            
					,@x_if_rcv_date AS CREATE_DATE                                                               
					,'SSP' AS MODIFY_USER_ID                                                            
					,@x_if_rcv_date AS MODIFY_DATE                                                               
					,[DBO].[FN_GET_SITE_CUSTOMER_INFO] (P.DIVISION_ID,P.TO_SITE,'SHIPTO_DESCRIPTION')  AS SHIP_TO_PARTY
					,CONVERT(VARCHAR, DATEADD(D, MAX(B.LT_TOTAL), CONVERT(DATETIME, P.YYYYMMDD ,112)) ,112)  AS RECEIVE_YYYYMMDD  
					,[DBO].[FN_GET_SITE_CUSTOMER_INFO] (P.DIVISION_ID,P.TO_SITE,'SHIPTO_CODE')         AS SHIP_TO_CODE                                             
					,@x_if_rcv_date                                                                    AS GNRT_DTTM 
					,0                                                                                 AS ACCUM_COUNT 						 
					,P.DIVISION_ID AS ATTR_01               --ORIGIN_FROM_DIVISION_ID                                                    
					,P.DIVISION_ID AS ATTR_02               --ORIGIN_TO_DIVISION_ID             
					,NULL          AS ATTR_03
					,NULL          AS ATTR_04
					,NULL          AS ATTR_05
				FROM (
						SELECT 
								C.DIVISION_ID  				
							,C.ITEM_ID				
							,C.FROM_SITE			
							,C.TO_SITE				
							,C.YYYYMMDD				
							,C.BOD_ID					
							,C.QTY						
							,C.ROUTE_ID				
							,ISNULL(B.SSP_INCOTERMS, C.INCOTERMS)   AS INCOTERMS -- R.INCOTERMS			
							,C.TRANSPORT_MODE	
							,C.PROJECT_CODE		
							,C.FCST_TYPE			
							,C.FCST_ETD_DATE	
							,C.FCST_ETA_DATE	
							,C.ETD_DATE				
							,C.ETA_DATE				
							,'Y'        AS   CONFIRM_FLAG		
							,C.CONFIRM_ID		
							,C.REQUESTOR	
						FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
								LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK) 
								ON B.DIVISION_ID = C.DIVISION_ID
								AND B.BOD_ID       = C.BOD_ID
						WHERE C.YYYYMMDD >= @v_data_start_yyyymmdd 
						AND   C.YYYYMMDD <= @v_data_end_yyyymmdd
						AND   C.CHANGE_TYPE = 'C' -- 확정
						AND   C.BIZ_TYPE    <> 'E'
						--AND   [DBO].[FN_GET_SSP_SITE_INFO](C.DIVISION_ID, C.FROM_SITE, 'COMPANY_ID') = @v_company_id 
						--AND   C.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 

						UNION ALL 

						--확정기간 이후 출하요청 
						SELECT 
								R.DIVISION_ID  				
							,R.ITEM_ID				
							,R.FROM_SITE			
							,R.TO_SITE				
							,R.YYYYMMDD				
							,R.BOD_ID					
							,R.QTY						
							,R.ROUTE_ID				
							,R.INCOTERMS			
							,R.TRANSPORT_MODE	
							,R.PROJECT_CODE		
							,R.FCST_TYPE			
							,R.FCST_ETD_DATE	
							,R.FCST_ETA_DATE	
							,R.ETD_DATE				
							,R.ETA_DATE				
							,'N'        AS   CONFIRM_FLAG		
							,R.CONFIRM_ID	
							,R.REQUESTOR	
						FROM   (
								SELECT 
									 R.DIVISION_ID  				
									,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, R.PLANT_SITE_ID, 'COMPANY_ID')  AS COMPANY_ID           
									,R.ITEM_ID				
									,R.PLANT_SITE_ID		 AS FROM_SITE
									,R.SCM_SITE_ID           AS TO_SITE		
									,R.MEASURE				
									,R.YYYYMMDD				
									,B.BOD_ID					
									,SUM(R.QTY) AS QTY 					
									,B.ROUTE_ID	
									,ISNULL(B.SSP_INCOTERMS, R.INCOTERMS)   AS INCOTERMS -- R.INCOTERMS			
									,R.TRANSPORT_MODE	
									,R.PROJECT_CODE		
									,R.FCST_TYPE			
									,R.YYYYMMDD	 AS FCST_ETD_DATE	
									,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
									,R.YYYYMMDD	 AS ETD_DATE				
									,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS ETA_DATE							
									,NULL	AS CONFIRM_FLAG		
									,'-'	AS CONFIRM_ID	
									, MAX(R.LAST_UPDATED_BY) 	AS REQUESTOR
								FROM DM_PLN_SHIPMENT_REQ R WITH(NOLOCK) 
										LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK) 
										ON B.DIVISION_ID = R.DIVISION_ID
										AND B.FROM_SITE    = R.PLANT_SITE_ID
										AND B.BOD_ID       = R.BOD_ID
								WHERE R.MEASURE = 'SHIP_REQ'
								AND   R.YYYYMMDD >= CASE WHEN [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID,R.PLANT_SITE_ID) <= 0 THEN @p_plan_start_yyyymmdd
													ELSE  CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID,R.PLANT_SITE_ID) , @p_plan_start_yyyymmdd) ,112)
												END  
								AND   R.YYYYMMDD <= @v_data_end_yyyymmdd
								GROUP BY 
										R.DIVISION_ID  				
									,R.ITEM_ID				
									,R.PLANT_SITE_ID			
									,R.SCM_SITE_ID				
									,R.MEASURE				
									,R.YYYYMMDD				
									,B.BOD_ID					
									,B.ROUTE_ID				
									,R.INCOTERMS
									,B.SSP_INCOTERMS
									,R.TRANSPORT_MODE	
									,R.PROJECT_CODE		
									,R.FCST_TYPE	
									,B.BOD_ID		
									,B.ROUTE_ID	
								) R
					    ) P
					JOIN SCP_MST_BOD_N_V B WITH(NOLOCK) 
					ON B.BOD_ID = P.BOD_ID 
					AND B.DIVISION_ID = P.DIVISION_ID 
					JOIN SCP_MST_FINAL_ITEM V WITH(NOLOCK)
						ON V.ITEM_ID = P.ITEM_ID
						AND V.DIVISION_ID = P.DIVISION_ID 
				WHERE 1 = 1
				--AND   P.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd --'20190908'
				--AND   P.COMPANY_ID = @p_company_id --'C100'
				--AND   P.MEASURE = 'SHIP_PLAN'
				--AND   P.QTY > 0 
				GROUP BY P.DIVISION_ID 
				,        P.FROM_SITE
				,        P.ITEM_ID 
				,        P.TO_SITE 
				,        P.YYYYMMDD 
				,		 P.FCST_TYPE       
				,        P.TRANSPORT_MODE  
				,        V.OPERATION_GROUP 
				;   
					 
				--SELECT @n_accum_count = COUNT(*) from #tmp_XIF_FP_SSP_SALES_EXFACTROY;

                --UPDATE #tmp_XIF_FP_SSP_SALES_EXFACTROY SET ACCUM_COUNT = @n_accum_count WHERE PLAN_ID = @X_PLAN_ID;


				--변수 선언 조회한 컬럼을 담을 변수도 선언해야한다.
				DECLARE 
				@INDEX INT,
				@DIVISION VARCHAR(100)

				SET @INDEX = 0; --INDEX초기화

				DECLARE CUR CURSOR FOR   --CUR라는 이름의 커서 선언

				SELECT DISTINCT(DIVISION)
				FROM #tmp_XIF_FP_SSP_SALES_EXFACTROY with(nolock) where PLAN_ID = @X_PLAN_ID

				OPEN CUR      --커서 오픈
				FETCH NEXT FROM CUR INTO @DIVISION  --SELECT한 값을 @@DIVISION 변수에 넣는다.

				--커서를이용해 한ROW씩 읽음 
				WHILE @@FETCH_STATUS = 0
				BEGIN
				SET @INDEX = @INDEX + 1; --INDEX증가
				SET @n_accum_count =  0;

				SELECT @n_accum_count = COUNT(*) from #tmp_XIF_FP_SSP_SALES_EXFACTROY with(nolock)
				WHERE DIVISION = @DIVISION
				AND   PLAN_ID = @X_PLAN_ID ;

				UPDATE #tmp_XIF_FP_SSP_SALES_EXFACTROY SET ACCUM_COUNT = @n_accum_count 
				WHERE DIVISION = @DIVISION
				AND   PLAN_ID = @X_PLAN_ID ;
	
				FETCH NEXT FROM CUR INTO @DIVISION	--다음ROW로 이동
				END

				--커서 닫고 초기화
				CLOSE CUR
				DEALLOCATE CUR

				/******************************************
                * 출하타겟 송신용 테이블에 기록한다.
                ******************************************/       
                   
                INSERT INTO XIF_FP_SSP_SALES_EXFACTORY_S_SN
                (   IF_SEQ               ,
					IF_TYPE              ,
					IF_ID                ,
					IF_INS_DATE          ,
					IF_FLAG              ,
					IF_SND_DATE          ,
					PLAN_ID              ,
					SHIP_ID              ,
					ITEM_ID              ,
					OPERATION_GROUP      ,
					SITE_CODE            ,
					PLANT_ID             ,
					CUSTOMER_CODE        ,
					CUSTOMER_NAME        ,
					DEST_SITE_CODE       ,
					DEST_PLANT_ID        ,
					DESTINATION_SITE_TYPE,
					EXFACTORY_YYYYMMDD   ,
					EXFACTORY_QTY        ,
					ORDER_TYPE           ,
					SHIP_METHOD          ,
					PRIORITY             ,
					DIVISION             ,
					MARKET               ,
					CREATE_USER_ID       ,
					CREATE_DATE          ,
					MODIFY_USER_ID       ,
					MODIFY_DATE          ,
					SHIP_TO_PARTY        ,
					RECEIVE_YYYYMMDD     ,
					SHIP_TO_CODE         ,
					GNRT_DTTM            ,
					ACCUM_COUNT          ,                               
					ATTR_01              , --ORIGIN_FROM_DIVISION_ID
					ATTR_02              , --ORIGIN_TO_DIVISION_ID 
					ATTR_03              , --FACTORY_ID                                                      
					ATTR_04              , --POST_OPER              
					ATTR_05                --REMARKS   nvarchar(255)              
                ) 
				SELECT * FROM #tmp_XIF_FP_SSP_SALES_EXFACTROY WITH(NOLOCK) ;
				
                /******************************************
                 * 인터페이스 전송이력  테이블에 기록한다.
                 ******************************************/  
      
                INSERT INTO DBO.SCP_PLN_INTERFACE_SEND_H
                           ( PLAN_START_YYYYMMDD
                           , DIVISION_ID
                           , PLAN_TYPE
                           , IF_ID
                           , IFSEQNO
                           , CREATED_BY
                           , CREATION_DATE )
                           VALUES
                           (  
                             @p_plan_start_yyyymmdd
                           , @p_company_id
                           , 'SPE' -- 전극은 SPE로 구분 
                           , @X_IF_ID
                           , @X_SEND_SEQ
                           , @v_batch_user
                           , GETDATE()    
                           );
               
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      
   
        SET @v_log_type = N'END';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message =N'########## End of procedure ##########';
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      
      END;

    END TRY

    BEGIN CATCH

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

    END CATCH;


     RETURN 1  


  END;

