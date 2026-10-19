


/*
 * Program ID   : [PR_SSP_XIF_DW_SHIP_CHANGE_HISTORY_S]  
 * Description  : 출하계획 변경사유 DW DATA 전송 
 *                매일 07:00 수행( BATCH JOB : JOB.PR_SSP_XIF_DW_SHIP_CHANGE_HISTORY ) 
 * Execute      : EXEC PR_SSP_XIF_DW_SHIP_CHANGE_HISTORY_S 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.09.09   ayj			   [CSR ID:4077005] [요청] GSCM 데이터 I/F table 구축 요청의 건
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_DW_SHIP_CHANGE_HISTORY_S]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
--    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_DW_SHIP_CHANGE_HISTORY_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'XIF_DW_SHIP_CHANGE_HISTORY_S_SN'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' XIF_DW_SHIP_CHANGE_HISTORY_S_SN INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
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
    -- 

	DECLARE @max_h_seq INT		SET     @max_h_seq = 0

    BEGIN TRY
      BEGIN
       BEGIN TRAN TX_SH;

		------------------------------------------------------------------------------------------------------------- 
		--  tmp_SSP_ANL_SHIP_CONFIRM_H 데이터 생성 시작
		-------------------------------------------------------------------------------------------------------------
		 WITH CONFIRM_LIST AS																																											
		 (                                                                                                                                                                                             
	 		SELECT                                                                                                                                                                                      
	 			tt0.DIVISION_ID, tt0.CONFIRM_ID, MAX(SUBMAX_SEQ) AS MAX_SEQ, tt0.YYYYMMDD                                                                                                                             
	 		FROM                                                                                                                                                                                        
	 		(                                                                                                                                                                                           
	 			SELECT                                                                                                                                                                                  
	 				a.DIVISION_ID, a.CONFIRM_ID, MAX(a.HISTORY_SEQ) AS SUBMAX_SEQ, a.YYYYMMDD                                                                                                                       
	 			FROM SSP_ANL_SHIP_CONFIRM_H a WITH(NOLOCK)                                                                                                                                              
	 			WHERE 1 = 1                                                                                                                                                                             
	 			GROUP BY a.DIVISION_ID, a.CONFIRM_ID, a.YYYYMMDD                                                                                                                                                    
	 		) tt0                                                                                                                                                                                       
	 		WHERE TT0.SUBMAX_SEQ = (SELECT MAX(T.HISTORY_SEQ) FROM SSP_ANL_SHIP_CONFIRM_H T WITH(NOLOCK) WHERE T.CONFIRM_ID = tt0.CONFIRM_ID )															
	 		GROUP BY tt0.DIVISION_ID, tt0.CONFIRM_ID, tt0.YYYYMMDD                                                                                                                           
		 )

			
		 SELECT * 
		 INTO tmp_SSP_ANL_SHIP_CONFIRM_H 
		 FROM 
		 ( 	
			 SELECT                                                                                                                                                                                        
	 			R.DIVISION_ID,                                                                                                                                                                              
	 			R.FROM_SITE,                                                                                                                                                                                
	 			R.ITEM_ID,                                                                                                                                                                                  
	 			DBO.FN_GET_ITEM_NICKNAME((CASE WHEN R.DIVISION_ID = 'EE' THEN R.ORIGIN_FROM_DIVISION_ID ELSE R.DIVISION_ID END), R.ITEM_ID ) AS NICK_NAME,                                                
	 			R.TO_SITE,                                                                                                                                                                                  
	 			ISNULL( CASE WHEN R.DIVISION_ID = '40' THEN 
	 						CASE WHEN R.PROJECT_CODE IS NOT NULL AND R.PROJECT_CODE != '-' THEN 
	 							R.PROJECT_CODE 
	 						ELSE 
	 							SI.PROJECT_CODE 
	 						END 
	 						 WHEN R.DIVISION_ID = 'EE' AND R.ORIGIN_TO_DIVISION_ID = '40' THEN 
	 							SI.PROJECT_CODE 
	 					ELSE 
	 						MS.END_CUSTOMER 
	 					END 
	 			, '-') AS END_CUSTOMER,                                                                                                                                                                      
	 			R.CONFIRM_ID,                                                                                                                                                                               
	 			R.H_SEQ AS SEQ,                                                                                                                                                                             
				R.SHIPMENT_DATE,
				R.SHIPMENT_YYMM,                                                                                                                                                                           
	 			R.QTY,                                                                                                                                                                                      
	 			R.TRANSPORT_MODE,                                                                                                                                                                           
	 			R.INCOTERMS,                                                                                                                                                                                
	 			R.CUSTOMER_LT,                                                                                                                                                                              
	 			R.ERP_SO_NO,																																													
	 			R.TYPE,                                                                                                                                                                                     
	 			R.CHANGE_TYPE,                                                                                                                                                                              
	 			R.CHANGE_REASON_CODE,                                                                                                                                                                       
	 			R.CHANGE_REASON_DETAIL,                                                                                                                                                                     
	 			CASE WHEN R.REQUEST_USER IS NULL THEN '' ELSE CASE 'KO' WHEN 'KO' THEN U.USERNAME ELSE U.USERNAME_E END + '(' + R.REQUEST_USER + ')' END AS REQUESTOR,                                                                                                            
	 			CASE 'KO' WHEN 'KO' THEN DT.DEPT_NAME_KO ELSE DT.DEPT_NAME_EN END AS REQUESTOR_DEPT_NAME,                                                                                            
	 			R.REQUEST_TIME AS REQUEST_DATE,                                                                                                                                                             
	 			CASE WHEN R.APPROVAL_USER IS NULL THEN '' ELSE CASE 'KO' WHEN 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END + '(' + R.APPROVAL_USER + ')' END AS APPROVAL,                                                                                                           
	 			CASE 'KO' WHEN 'KO' THEN DT2.DEPT_NAME_KO ELSE DT2.DEPT_NAME_EN END AS APPROVAL_DEPT_NAME,                                                                                         
	 			R.APPROVAL_TIME AS APPROVAL_DATE,                                                                                                                                                           
	 			ISNULL(R.CHANGE_REQ_NO, '-') AS REQUEST_NO,                                                                                                                                                                            
	 			R.REMARKS2 AS BUILDING,                                                                                                                                                                     
	 			R.REMARKS AS REMARKS,                                                                                                                                                                       
	 			CASE WHEN R.REQUESTOR IS NULL THEN '' ELSE CASE 'KO' WHEN 'KO' THEN U3.USERNAME ELSE U3.USERNAME_E END + '(' + R.REQUESTOR + ')' END AS SHIPMENT_REQUESTOR,                                                                                                                                                          
	 			R.REMARKS3 AS CUSTOMER_REQUIRMENT,                                                                                                                                                          
	 			(                                                                                                                                                                                           
	 				SELECT TOP 1                                                                                                                                                                            
	 					ISNULL(A.SOLDTO_DESCRIPTION, '-')                                                                                                                                                 
	 				FROM SCM_MST_CUSTOMER A WITH(NOLOCK)                                                                                                                                                    
	 				, SCM_MST_SITE_CUSTOMER B WITH(NOLOCK)                                                                                                                                                  
	 				WHERE 1 = 1                                                                                                                                                                             
	 				AND B.REP_YN         = 'Y'                                                                                                                                                            
	 				AND B.DIVISION_ID    = A.DIVISION_ID                                                                                                                                                    
	 				AND B.SOLDTO_CODE	 = A.SOLDTO_CODE                                                                                                                                                    
	 				AND B.SHIPTO_CODE    = A.SHIPTO_CODE                                                                                                                                                    
	 				AND A.DIVISION_ID	 = R.DIVISION_ID                                                                                                                                                    
	 				AND B.SCM_SITE_ID	 = R.TO_SITE                                                                                                                                                        
	 			) AS SOLD_TO_PARTY,                                                                                                                                                                         
	 			(                                                                                                                                                                                           
	 				SELECT TOP 1                                                                                                                                                                            
	 					ISNULL(A.SHIPTO_DESCRIPTION, '-')                                                                                                                                                 
	 				FROM SCM_MST_CUSTOMER A WITH(NOLOCK)                                                                                                                                                    
	 				, SCM_MST_SITE_CUSTOMER B WITH(NOLOCK)                                                                                                                                                  
	 				WHERE 1 = 1                                                                                                                                                                             
	 				AND B.REP_YN         = 'Y'                                                                                                                                                            
	 				AND B.DIVISION_ID    = A.DIVISION_ID                                                                                                                                                    
	 				AND B.SOLDTO_CODE	 = A.SOLDTO_CODE                                                                                                                                                    
	 				AND B.SHIPTO_CODE    = A.SHIPTO_CODE                                                                                                                                                    
	 				AND A.DIVISION_ID	 = R.DIVISION_ID                                                                                                                                                    
	 				AND B.SCM_SITE_ID	 = R.TO_SITE                                                                                                                                                        
	 			) AS SHIP_TO_PARTY,                                                                                                                                                                         
	 			CASE WHEN MU.[USER_ID] IS NULL THEN '' ELSE CASE 'KO' WHEN 'KO' THEN MU1.USERNAME ELSE MU1.USERNAME_E END + '(' + MU.[USER_ID] + ')' END AS MODEL_PIC,                                                                                                                                                                  
	 			R.PROJECT_CODE AS PROJECT_NAME,                                                                                                                                                             
	 			R.FCST_TYPE,                                                                                                                                                                                
	 			CASE WHEN ISNULL(SI.OWNER, '') = '' THEN NULL                                                                                                                                           
	 			ELSE                                                                                                                                                                                        
	 				CASE 'KO' WHEN 'KO' THEN (SELECT TOP 1 ISNULL(SU.USER_NAME, '') FROM SCM_MST_SSO_USER_INFO SU WHERE SU.USER_ID = SI.OWNER)                                                   
	 				ELSE (SELECT TOP 1 ISNULL(SU.USER_NAME_EN, '') FROM SCM_MST_SSO_USER_INFO SU WHERE SU.USER_ID = SI.OWNER )                                                                            
	 				END + '(' + SI.OWNER + ')'                                                                                                                                                                                    
	 			END AS MTK_OWNER,                                                                                                                                                                           
	 			R.LAST_CHANGE_DATE,                                                                                                                                                                         
	 			CASE WHEN R.H_SEQ = 1 THEN NULL ELSE CONVERT(DATE, R.BEFORE_SHIPMENT_DATE) END AS BEFORE_SHIPMENT_DATE,                                                                                                       
	 			CASE WHEN R.H_SEQ = 1 THEN NULL ELSE ISNULL(R.BEFORE_QTY, 0) END AS BEFORE_QTY,                                                                                                                                                      
	 			CASE WHEN R.H_SEQ = 1 THEN NULL ELSE R.BEFORE_TRANSPORT_MODE END AS BEFORE_TRANSPORT_MODE,                                                                                                                                                                    
	 			CASE WHEN R.H_SEQ = 1 THEN NULL ELSE R.BEFORE_INCOTERMS END AS BEFORE_INCOTERMS,                                                                                                                                                                         
	 			CASE WHEN ISNULL(R.BEFORE_SHIPMENT_DATE,'') <> ISNULL(R.NEW_YYYYMMDD,'') THEN 'Y' ELSE 'N' END AS SHIPMENT_DATE_CHANGE,                                                             
	 			CASE WHEN ISNULL(R.BEFORE_SHIPMENT_DATE,'') = '' THEN '-'                                                                                                                             
	 				 WHEN ISNULL(R.NEW_YYYYMMDD,'') = '' THEN '-'                                                                                                                                       
	 			ELSE                                                                                                                                                                                        
	 				CASE WHEN ISNULL(R.BEFORE_SHIPMENT_DATE,'') <> ISNULL(R.NEW_YYYYMMDD,'') THEN                                                                                                       
	 					CONVERT(NVARCHAR(MAX), DATEDIFF(DD, CONVERT(DATE, R.BEFORE_SHIPMENT_DATE), CONVERT(DATE, R.NEW_YYYYMMDD)))                                                                          
	 				ELSE '-'                                                                                                                                                                              
	 				END                                                                                                                                                                                     
	 			END AS VARIABLE_DATE,                                                                                                                                                                       
	 			CASE WHEN ISNULL(R.BEFORE_QTY,0) <> ISNULL(R.NEW_QTY,0) THEN 'Y' ELSE 'N' END  AS QTY_CHANGE,                                                                                           
	 			ABS(ISNULL(R.BEFORE_QTY,0) - ISNULL(R.NEW_QTY,0)) AS VARIABLE_QTY,                                                                                                                          
	 			CASE WHEN ISNULL(R.BEFORE_TRANSPORT_MODE,'') <> ISNULL(R.NEW_TRANSPORT_MODE,'') THEN 'Y' ELSE 'N' END  AS TRANS_MODE_CHANGE,                                                        
	 			CASE WHEN (R.BEFORE_SHIPMENT_DATE = R.NEW_YYYYMMDD AND R.BEFORE_QTY = R.NEW_QTY AND R.BEFORE_TRANSPORT_MODE = R.NEW_TRANSPORT_MODE) THEN 'Y' ELSE 'N' END AS REMARKS_CHANGE,			
	 			R.LAST_SEQ,
				MSF.PLANT_ID,
				R.HISTORY_SEQ                                                                                                                                                                                 
			 FROM                                                                                                                                                                                          
			 (                                                                                                                                                                                             
	 			SELECT                                                                                                                                                                                      
	 				T0.DIVISION_ID,                                                                                                                                                                         
	 				T0.ORIGIN_FROM_DIVISION_ID,                                                                                                                                                             
	 				T0.ORIGIN_TO_DIVISION_ID,                                                                                                                                                               
	 				T0.FROM_SITE,                                                                                                                                                                           
	 				T0.ITEM_ID,                                                                                                                                                                             
	 				T0.TO_SITE,                                                                                                                                                                             
	 				T0.CONFIRM_ID,                                                                                                                                                                          
	 				ROW_NUMBER() OVER(PARTITION BY T2.CONFIRM_ID ORDER BY T2.HISTORY_SEQ) AS H_SEQ,                                                                                                         
	 				T1.YYYYMMDD, 
					CONVERT(DATE, T2.YYYYMMDD) AS SHIPMENT_DATE,  
					SUBSTRING(T2.YYYYMMDD, 3, 4) AS SHIPMENT_YYMM,                                                                                                                   
	 				ISNULL(T2.QTY, 0) AS QTY,                                                                                                                                                               
	 				T2.TRANSPORT_MODE,                                                                                                                                                                      
	 				T2.INCOTERMS,                                                                                                                                                                           
	 				T2.CUSTOMER_LT,                                                                                                                                                                         
	 				T2.ERP_SO_NO,																																											
	 				CASE WHEN T2.CHANGE_REQ_NO IS NULL THEN 'New'                                                                                                                                         
	 				ELSE                                                                                                                                                                                    
	 					CASE WHEN T4.NEW_YN = 'Y' THEN 'New' ELSE 'Change' END                                                                                                                        
	 				END AS TYPE,                                                                                                                                                                            
	 				CASE WHEN ISNULL(T3.CHANGE_TYPE, 'System Create') = 'A' THEN 'Adjustment'                                                                                                         
	 					 WHEN ISNULL(T3.CHANGE_TYPE, 'System Create') IN('N', 'C', 'P') THEN 'Change Request'                                                                                            
	 				ELSE 'System Create' END AS CHANGE_TYPE,                                                                                                                                              
	 				T3.CHANGE_REASON_CODE,                                                                                                                                                                  
	 				T3.CHANGE_REASON_DETAIL,                                                                                                                                                                
	 				T3.REQUEST_USER,                                                                                                                                                                        
	 				T3.REQUEST_DEPT,                                                                                                                                                                        
	 				T3.REQUEST_TIME,                                                                                                                                                                        
	 				T3.APPROVAL_USER,                                                                                                                                                                       
	 				T3.APPROVAL_DEPT,                                                                                                                                                                       
	 				T3.APPROVAL_TIME,                                                                                                                                                                       
	 				T2.CHANGE_REQ_NO,                                                                                                                                                                       
	 				T2.REMARKS2,                                                                                                                                                                            
	 				T2.REMARKS,                                                                                                                                                                             
	 				T0.REQUESTOR,                                                                                                                                                                           
	 				T2.REMARKS3,                                                                                                                                                                            
	 				T0.PROJECT_CODE,                                                                                                                                                                        
	 				T0.FCST_TYPE,                                                                                                                                                                           
	 				ISNULL(T3.APPROVAL_TIME, T0.CREATION_DATE ) AS LAST_CHANGE_DATE,                                                                                                                        
	 				T4.YYYYMMDD AS BEFORE_SHIPMENT_DATE,                                                                                                                                                    
	 				T4.QTY AS BEFORE_QTY,                                                                                                                                                                   
	 				T4.TRANSPORT_MODE AS BEFORE_TRANSPORT_MODE,                                                                                                                                             
	 				T4.INCOTERMS AS BEFORE_INCOTERMS,                                                                                                                                                       
	 				T4.NEW_YYYYMMDD,                                                                                                                                                                        
	 				T4.NEW_QTY,                                                                                                                                                                             
	 				T4.NEW_TRANSPORT_MODE,                                                                                                                                                                  
	 				CASE WHEN T2.HISTORY_SEQ = T1.MAX_SEQ THEN 'C' ELSE 'H' END AS LAST_SEQ,
					T2.HISTORY_SEQ                                                                                                             
	 			FROM SSP_ANL_SHIP_CONFIRM T0 WITH(NOLOCK)                                                                                                                                                   
	 			INNER JOIN CONFIRM_LIST T1                                                                                                                                                                  
	 				ON T0.DIVISION_ID = T1.DIVISION_ID AND T0.CONFIRM_ID = T1.CONFIRM_ID                                                                                                                    
	 			INNER JOIN SSP_ANL_SHIP_CONFIRM_H T2 WITH(NOLOCK)                                                                                                                                           
	 				ON T0.DIVISION_ID = T2.DIVISION_ID AND T0.CONFIRM_ID = T2.CONFIRM_ID                                                                                                                    
	 			LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T3 WITH(NOLOCK)																																
	 				ON T2.CHANGE_REQ_NO = T3.CHANGE_REQ_NO AND T3.CHANGE_REQ_STATUS = 'A' AND T3.VALID_YN = 'Y'                                                                                         
	 			LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE T4 WITH(NOLOCK)                                                                                                                             
	 				ON T2.CHANGE_REQ_NO = T4.CHANGE_REQ_NO AND T2.CONFIRM_ID = T4.CONFIRM_ID AND T4.VALID_YN = 'Y'                                                                                        
	 			WHERE 1 = 1                                                                                                                                                                                 
	 			  AND T0.CHANGE_TYPE = 'C' 
				  --어제 변경된 출하계획만 조회
				  --AND CONVERT(VARCHAR(8), CONVERT(DATETIME, T0.LAST_UPDATE_DATE), 112) = CONVERT(VARCHAR(8), CONVERT(DATETIME, GETDATE()), 112) - 1                                                                                                                                                                               
			 ) AS R                                                                                                                                                                                        
			 LEFT OUTER JOIN TB_FX_USER U   WITH(NOLOCK)                                                                                                                                                               
	 			ON R.REQUEST_USER = U.USERID AND U.USEYN = 'Y'                                                                                                                                            
			 LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO DT  WITH(NOLOCK)                                                                                                                                                    
	 			ON R.REQUEST_DEPT = DT.DEPT_ID                                                                                                                                                              
			 LEFT OUTER JOIN TB_FX_USER U2   WITH(NOLOCK)                                                                                                                                                              
	 			ON R.APPROVAL_USER = U2.USERID AND U2.USEYN = 'Y'                                                                                                                                         
			 LEFT OUTER JOIN TB_FX_USER U3  WITH(NOLOCK)                                                                                                                                                               
	 			ON R.REQUESTOR = U3.USERID AND U3.USEYN = 'Y'                                                                                                                                         
			 LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO DT2   WITH(NOLOCK)                                                                                                                                                  
	 			ON R.APPROVAL_DEPT = DT2.DEPT_ID                                                                                                                                                            
			 LEFT OUTER JOIN SSP_MST_MODEL_USER MU WITH(NOLOCK)                                                                                                                                            
	 			ON MU.DIVISION_ID = R.DIVISION_ID AND MU.FROM_SITE = R.FROM_SITE AND MU.ITEM_ID = R.ITEM_ID AND MU.VALID_YN = 'Y'                                                                         
			 LEFT OUTER JOIN TB_FX_USER MU1 WITH(NOLOCK)                                                                                                                                            
	 			ON MU.USER_ID = MU1.USERID AND MU1.USEYN = 'Y'                                                                         
			 LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK)                                                                                                                                             
	 			ON SI.DIVISION_ID = (CASE WHEN R.DIVISION_ID = 'EE' THEN R.ORIGIN_TO_DIVISION_ID ELSE R.DIVISION_ID END)                                                                                  
	 			AND SI.SCM_SITE_ID = R.TO_SITE                                                                                                                                                              
	 			AND SI.ITEM_ID = R.ITEM_ID                                                                                                                                                                  
	 			AND SI.PROJECT_CODE = R.PROJECT_CODE                                                                                                                                                        
			 LEFT OUTER JOIN SCM_MST_SITE MS WITH(NOLOCK) ON MS.DIVISION_ID = R.ORIGIN_TO_DIVISION_ID AND MS.SCM_SITE_ID = R.TO_SITE
			 LEFT OUTER JOIN SCM_MST_SITE MSF WITH(NOLOCK) ON MSF.DIVISION_ID = R.ORIGIN_TO_DIVISION_ID AND MSF.SCM_SITE_ID = R.FROM_SITE																					
			 WHERE 1 = 1                                                                                                                                                                                   
			 AND R.H_SEQ = (CASE WHEN R.H_SEQ = 1 AND R.QTY = 0 THEN 0 ELSE R.H_SEQ END)
		 ) A

		 --저장되어있는 MAX(HISTORY_SEQ) 값을 구함
		 SET @max_h_seq = (
							SELECT MAX(HISTORY_SEQ)
							FROM XIF_DW_SHIP_CHANGE_HISTORY_S_SN WITH(NOLOCK)
						  )

		------------------------------------------------------------------------------------------------------------- 
		--  XIF_DW_SHIP_CHANGE_HISTORY_S_SN 데이터 INSERT 시작
		-------------------------------------------------------------------------------------------------------------
		INSERT INTO XIF_DW_SHIP_CHANGE_HISTORY_S_SN (
			HISTORY_SEQ
			,DIVISION_ID
			,FROM_SITE
			,ITEM_ID
			,NICK_NAME
			,TO_SITE
			,END_CUSTOMER
			,CONFIRM_ID
			,SEQ
			,SHIPMENT_DATE
			,QTY
			,TRANSPORT_MODE
			,INCOTERMS
			,BEFORE_SHIPMENT_DATE
			,BEFORE_QTY
			,BEFORE_TRANSPORT_MODE
			,BEFORE_INCOTERMS
			,CUSTOMER_LT
			,ERP_SO_NO
			,TYPE
			,CHANGE_TYPE
			,CHANGE_REASON_CODE
			,CHANGE_REASON_DETAIL
			,REQUESTOR
			,REQUESTOR_DEPT_NAME
			,REQUEST_DATE
			,APPROVAL
			,APPROVAL_DEPT_NAME
			,APPROVAL_DATE
			,REQUEST_NO
			,SOLD_TO_PARTY
			,SHIP_TO_PARTY
			,MODEL_PIC
			,PROJECT_NAME
			,FCST_TYPE
			,MTK_OWNER
			,LAST_CHANGE_DATE
			,SHIPMENT_DATE_CHANGE
			,VARIABLE_DATE
			,QTY_CHANGE
			,VARIABLE_QTY
			,TRANS_MODE_CHANGE
			,REMARKS_CHANGE
			,SHIPMENT_YYMM
			,PLANT_ID
			,CREATED_BY                      
			,CREATION_DATE 
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE   
		)
		SELECT
			 H.HISTORY_SEQ 
			--,H.DIVISION_ID
			,D.ATTRIBUTE3 AS DIVISION_ID
			,H.FROM_SITE
			,H.ITEM_ID
			,H.NICK_NAME
			,H.TO_SITE
			,H.END_CUSTOMER
			,H.CONFIRM_ID
			,H.SEQ
			,H.SHIPMENT_DATE
			,H.QTY
			,H.TRANSPORT_MODE
			,H.INCOTERMS
			,H.BEFORE_SHIPMENT_DATE
			,H.BEFORE_QTY
			,H.BEFORE_TRANSPORT_MODE
			,H.BEFORE_INCOTERMS
			,H.CUSTOMER_LT
			,H.ERP_SO_NO
			,H.TYPE
			,H.CHANGE_TYPE
			,H.CHANGE_REASON_CODE
			,H.CHANGE_REASON_DETAIL
			,H.REQUESTOR
			,H.REQUESTOR_DEPT_NAME
			,H.REQUEST_DATE
			,H.APPROVAL
			,H.APPROVAL_DEPT_NAME
			,H.APPROVAL_DATE
			,H.REQUEST_NO
			,H.SOLD_TO_PARTY
			,H.SHIP_TO_PARTY
			,H.MODEL_PIC
			,H.PROJECT_NAME
			,H.FCST_TYPE
			,H.MTK_OWNER
			,H.LAST_CHANGE_DATE
			,H.SHIPMENT_DATE_CHANGE
			,H.VARIABLE_DATE
			,H.QTY_CHANGE
			,H.VARIABLE_QTY
			,H.TRANS_MODE_CHANGE
			,H.REMARKS_CHANGE
			,H.SHIPMENT_YYMM
			,H.PLANT_ID
			,@v_batch_user  -- CREATED_BY                     
			,GETDATE()      -- CREATION_DATE 
			,@v_batch_user  -- LAST_UPDATED_BY                     
			,GETDATE()      -- LAST_UPDATE_DATE			   
		FROM tmp_SSP_ANL_SHIP_CONFIRM_H AS H WITH(NOLOCK) 
			JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
			ON H.DIVISION_ID   = D.DIVISION_ID

		WHERE H.HISTORY_SEQ > @max_h_seq
		;

		-- IF data  삭제 (90일 이전 데이터 삭제)  
		DELETE 
		FROM XIF_DW_SHIP_CHANGE_HISTORY_S_SN  
		WHERE CREATION_DATE < GETDATE() - 90 
		;

		DROP TABLE tmp_SSP_ANL_SHIP_CONFIRM_H

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT TRAN TX_SH;
          END;       


        -- TXN LOG
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

    END
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH

        END;
      
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
--      PRINT @@ERROR
      return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@v_program_name+'][' + @v_exec_time + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    return 1  

  END; 
