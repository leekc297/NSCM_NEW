



/*
 * Program ID   : SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM
 * Description  : Shipment Change Request Detail Confirm Save
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/04/22   hsbang         Initial Release 
 * 2024/10/01   KHJ            NERP_SSP
 * 2025/08/18   chkim.68       to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
 */

CREATE PROCEDURE [dbo].[SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM]
	 @p_change_request_no	NVARCHAR(MAX)
	,@p_change_status		NVARCHAR(MAX)
	,@p_reject_reason		NVARCHAR(MAX)
	,@p_confirm_id			NVARCHAR(MAX)	
	,@p_new_confirm_id		NVARCHAR(MAX)
	,@p_last_updated_by		NVARCHAR(MAX)
	,@p_status_detail	    NVARCHAR(MAX) --상세내역 승인상태코드
	/*********************************************************/	
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE @v_division_id			NVARCHAR(MAX)
	DECLARE @v_confirm_id			NVARCHAR(MAX)
	DECLARE @v_new_confirm_id		NVARCHAR(MAX)
	DECLARE @v_last_update_date     datetime;
	/**** 20240416   hsbang   항목추가   ******************************************/
	DECLARE @v_status_detail	    NVARCHAR(MAX) --상세내역 승인상태코드
	DECLARE @v_infseqno	nvarchar(14);	
	DECLARE @v_last_confirm_date nvarchar(8);	
	DECLARE @v_model_user_chk			INT

	SET @v_confirm_id = null
	SET @v_new_confirm_id = null
	SET @v_last_update_date    = SYSDATETIME();
	/**** 20240416   hsbang   항목추가   ******************************************/
	SET @v_status_detail	        = null; --상세내역 승인상태코드	

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- 트렌젝션 시작

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = @v_last_update_date;--[dbo].[FN_MULTY_TIME](@p_time_zone);
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		IF @p_change_status in ('A','P','R','S','O') --Approved, Partial Approved, Reject, Self Reject, D/O Reject
			BEGIN
				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_confirm_id, @v_delimiter);    
				
				--	WHILE LEN(@p_active_flag) > 0
				WHILE LEN(@p_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt = @mst_loop_cnt + 1;

					BEGIN
						--SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;  
						SET @v_confirm_id = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_id, @v_delimiter , @mst_loop_cnt) ;  
						SET @v_new_confirm_id = [dbo].[SCM_ARR_SPL_VAL](@p_new_confirm_id, @v_delimiter , @mst_loop_cnt) ;  
						IF @p_change_status in ('P')
						BEGIN
							SET @v_status_detail = [dbo].[SCM_ARR_SPL_VAL](@p_status_detail, @v_delimiter , @mst_loop_cnt) ; 
						END
						ELSE
						BEGIN
							SET @v_status_detail = @p_change_status; 
						END
					END
			
					IF @mst_loop_cnt > 0 
						BEGIN
							UPDATE A							
							SET A.VALID_YN   = (CASE WHEN @v_status_detail = 'R' THEN 'N' ELSE A.VALID_YN END)
							,	A.ATTRIBUTE1 = (CASE WHEN @v_status_detail = 'R' THEN 'Y' ELSE A.ATTRIBUTE1 END)
							,	A.ATTRIBUTE2 = (CASE WHEN ISNULL(A.ATTRIBUTE2, '') = 'Q' THEN @v_status_detail ELSE A.ATTRIBUTE2 END)
							,	A.ATTRIBUTE3 = (CASE WHEN @v_status_detail IN ('R','S','O') THEN @p_reject_reason ELSE NULL END)
							,	A.LAST_UPDATED_BY = @p_last_updated_by
							,	A.LAST_UPDATE_DATE = @v_last_update_date		
							FROM [dbo].[SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE] A
							WHERE A.CHANGE_REQ_NO = @p_change_request_no
							AND   A.CONFIRM_ID    = @v_new_confirm_id
							;
							
							IF (@p_change_status = 'P' AND @v_status_detail = 'R') --Partial Approved AND Status Detail Reject
							BEGIN
								SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_ERP_IFSEQNO) ,6);
								-- 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10)
								SET @v_last_confirm_date =  CONVERT ( VARCHAR(8), GETDATE() + 9 , 112) ;

								--EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW 'D', @p_change_request_no, @v_new_confirm_id;	
								INSERT INTO XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
								( 
								 IFSEQNO
								,CONFIRM_ID
								,SHIPMENT_STATUS
								,LAST_CONFIRM_DATE
								,VERSION_TYPE
								,SALES_COMPANY_ID
								,DIVISION_ID
								,ITEM_ID
								,FROM_SITE
								,TO_SITE
								,YYYYMMDD
								,QTY
								,BOD_ID
								,ROUTE_ID
								,OPERATION_GROUP
								,BIZ_TYPE
								,PROJECT_CODE
								,FCST_TYPE
								,FCST_ETD_DATE
								,FCST_ETA_DATE
								,ETD_DATE
								,ETA_DATE
								,INCOTERMS
								,INCOTERMS2
								,TRANSPORT_MODE
								,D_COUNTRY
								,D_PORT_CODE
								,A_COUNTRY
								,A_PORT_CODE
								,CUSTOMER_LT
								,TO_COUNTRY
								,TO_CITY
								,FROM_SITE_TYPE
								,FROM_SITE_PLANT_ID
								,FROM_SITE_VENDOR_ID
								,FROM_SITE_SOLDTO_CODE
								,FROM_SITE_SHIPTO_CODE
								,FROM_SITE_COMPANY_ID
								,TO_SITE_TYPE
								,TO_SITE_PLANT_ID
								,TO_SITE_VENDOR_ID
								,TO_SITE_SOLDTO_CODE
								,TO_SITE_SHIPTO_CODE
								,TO_SITE_COMPANY_ID
								-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
								,BUILDING
								,REMARK
								,CUSTOMER_REQ
								,CHANGE_CODE
								,CHANGE_CODE_NAME
								,REQUESTOR
								,TRANSFER_FLAG
								,TRANSFER_DATE
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE
								,ATTRIBUTE1
								/*----------------------------------------------------------------------------------------
									2020.06.30 : KBK
									I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
								------------------------------------------------------------------------------------------*/
								,PACKAGE_TYPE
								,FACTORY_ID
								,PACKAGE_QTY
								,DOM_EXP
								,ERP_ATTR1
								,ERP_ATTR2
								,ERP_ATTR3
								,ERP_ATTR4
								,ERP_ATTR5
								)
								SELECT 
									 @v_infseqno     AS IFSEQNO
									,CONFIRM_ID
									,'D'  AS SHIPMENT_STATUS 
									,@v_last_confirm_date AS LAST_CONFIRM_DATE
									,VERSION_TYPE
									,ISNULL(X1.NEW_VALUE1, A.SALES_COMPANY_ID)		AS SALES_COMPANY_ID
									,DIVISION_ID
									,ITEM_ID
									,ISNULL(X2.NEW_VALUE1, A.FROM_SITE)				AS FROM_SITE
									,ISNULL(X3.NEW_VALUE1, A.TO_SITE)				AS TO_SITE
									,YYYYMMDD
									,QTY
									,BOD_ID
									,ROUTE_ID
									,OPERATION_GROUP
									,BIZ_TYPE
									,PROJECT_CODE
									,FCST_TYPE 
									,FCST_ETD_DATE
									,FCST_ETA_DATE
									,ETD_DATE
									,ETA_DATE
									,INCOTERMS
									,INCOTERMS2
									,TRANSPORT_MODE
									,D_COUNTRY
									,D_PORT_CODE
									,A_COUNTRY
									,A_PORT_CODE
									,CUSTOMER_LT
									,TO_COUNTRY
									,TO_CITY
									,FROM_SITE_TYPE  
									,ISNULL(X4.NEW_VALUE1, A.FROM_SITE_PLANT_ID)		AS FROM_SITE_PLANT_ID
									,ISNULL(X5.NEW_VALUE1, A.FROM_SITE_VENDOR_ID)		AS FROM_SITE_VENDOR_ID
									,ISNULL(X6.NEW_VALUE1, A.FROM_SITE_SOLDTO_CODE)		AS FROM_SITE_SOLDTO_CODE
									,ISNULL(X7.NEW_VALUE1, A.FROM_SITE_SHIPTO_CODE)		AS FROM_SITE_SHIPTO_CODE
									,ISNULL(X8.NEW_VALUE1, A.FROM_SITE_COMPANY_ID)		AS FROM_SITE_COMPANY_ID
									,A.TO_SITE_TYPE
									,ISNULL(X9.NEW_VALUE1, A.TO_SITE_PLANT_ID)			AS TO_SITE_PLANT_ID
									,ISNULL(X10.NEW_VALUE1, A.TO_SITE_VENDOR_ID)		AS TO_SITE_VENDOR_ID
									,ISNULL(X11.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)		AS TO_SITE_SOLDTO_CODE
									,ISNULL(X12.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)		AS TO_SITE_SHIPTO_CODE
									,ISNULL(X13.NEW_VALUE1, A.TO_SITE_COMPANY_ID)		AS TO_SITE_COMPANY_ID
									,BUILDING
									,REMARK
									,CUSTOMER_REQ
									,CHANGE_CODE
									,CHANGE_CODE_NAME
									,REQUESTOR
									,'P'                AS TRANSFER_FLAG
									,NULL		          AS TRANSFER_DATE
									,CREATED_BY    
									,GETDATE()      AS CREATION_DATE
									,LAST_UPDATED_BY 
									,GETDATE()			  AS LAST_UPDATE_DATE
									,@p_change_request_no
									/*----------------------------------------------------------------------------------------
										2020.06.30 : KBK
										I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
									------------------------------------------------------------------------------------------*/
									,PACKAGE_TYPE
									,FACTORY_ID
									,PACKAGE_QTY
									,DOM_EXP
									,ERP_ATTR1
									,ERP_ATTR2
									,ERP_ATTR3
									,A.TO_SITE_PLANT_ID AS ERP_ATTR4-- ERP_ATTR4-- NERP에서 원본 정보 참고용 (2025-04-23)
									,ERP_ATTR5
								FROM 
								(
									SELECT 
											 CONFIRM_ID
											,VERSION_TYPE
											,SALES_COMPANY_ID
											--,X.DIVISION_ID
											,D.ATTRIBUTE3 AS DIVISION_ID
											,ITEM_ID
											,FROM_SITE
											,TO_SITE
											,YYYYMMDD
											,QTY
											,BOD_ID
											,ROUTE_ID
											,BIZ_TYPE  AS OPERATION_GROUP
											,BIZ_TYPE
											,CASE WHEN PROJECT_CODE IS NULL OR PROJECT_CODE ='' OR PROJECT_CODE ='-' THEN 'TBD' ELSE PROJECT_CODE END   AS PROJECT_CODE
											,FCST_TYPE 
											,FCST_ETD_DATE
											,FCST_ETA_DATE
											,ETD_DATE
											,ETA_DATE
											,INCOTERMS
											,INCOTERMS2
											,TRANSPORT_MODE
											,D_COUNTRY
											,D_PORT_CODE
											,A_COUNTRY
											,A_PORT_CODE
											,CUSTOMER_LT
											,TO_COUNTRY
											,TO_CITY
											-- 현재 시점의 FROM/TO SITE 정보 전송(2018.11.26)
											,DBO.[FN_GET_SSP_SITE_INFO](X.DIVISION_ID, FROM_SITE, 'SITE_TYPE')   AS FROM_SITE_TYPE  
											,DBO.[FN_GET_SSP_SITE_INFO](X.DIVISION_ID, FROM_SITE, 'PLANT_ID')    AS FROM_SITE_PLANT_ID   
											-- 2020-08-24 11:19:51
											-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
											-- 2020-08-24  kimbl1
											,CASE WHEN ISNULL(FS.HQ_VENDOR_CODE, '') <> '' THEN FS.HQ_VENDOR_CODE
											 ELSE DBO.[FN_GET_SSP_SITE_INFO](X.DIVISION_ID, FROM_SITE, 'VENDOR_ID') END  AS FROM_SITE_VENDOR_ID  
											,DBO.[FN_GET_SSP_SITE_INFO](X.DIVISION_ID, FROM_SITE, 'SOLDTO_CODE') AS FROM_SITE_SOLDTO_CODE
											,DBO.[FN_GET_SSP_SITE_INFO](X.DIVISION_ID, FROM_SITE, 'SHIPTO_CODE') AS FROM_SITE_SHIPTO_CODE
											,DBO.[FN_GET_SSP_SITE_INFO](X.DIVISION_ID, FROM_SITE, 'COMPANY_ID')  AS FROM_SITE_COMPANY_ID 
											,DBO.[FN_GET_SSP_SITE_INFO_EXCEPTION](ORIGIN_TO_DIVISION_ID,FROM_SITE, TO_SITE, 'SITE_TYPE')     AS TO_SITE_TYPE  
											,DBO.[FN_GET_SSP_SITE_INFO](ORIGIN_TO_DIVISION_ID, TO_SITE, 'PLANT_ID')      AS TO_SITE_PLANT_ID   
											-- 2020-08-24 11:19:51
											-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
											-- 2020-08-24  kimbl1
											,CASE WHEN ISNULL(TS.HQ_VENDOR_CODE, '') <> '' THEN TS.HQ_VENDOR_CODE
											 ELSE DBO.[FN_GET_SSP_SITE_INFO](ORIGIN_TO_DIVISION_ID, TO_SITE, 'VENDOR_ID') END    AS TO_SITE_VENDOR_ID  
											,DBO.[FN_GET_SSP_SITE_INFO](ORIGIN_TO_DIVISION_ID, TO_SITE, 'SOLDTO_CODE')   AS TO_SITE_SOLDTO_CODE
											,DBO.[FN_GET_SSP_SITE_INFO](ORIGIN_TO_DIVISION_ID, TO_SITE, 'SHIPTO_CODE')   AS TO_SITE_SHIPTO_CODE
											,DBO.[FN_GET_SSP_SITE_INFO_EXCEPTION](ORIGIN_TO_DIVISION_ID,FROM_SITE, TO_SITE, 'COMPANY_ID')    AS TO_SITE_COMPANY_ID 
											-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
											,BUILDING
											,REMARK
											,CUSTOMER_REQ
											,CHANGE_CODE
											,CASE WHEN CHANGE_CODE = 'C00' THEN 'Shipment Plan Adjustment' ELSE   CHANGE_CODE_NAME END  AS CHANGE_CODE_NAME
											,REQUESTOR
											--,GETDATE()          AS TRANSFER_DATE
											,NULL		          AS TRANSFER_DATE
											,X.CREATED_BY         AS CREATED_BY    
											--,X.CREATION_DATE      AS CREATION_DATE
											,X.LAST_UPDATED_BY    AS LAST_UPDATED_BY 
											--,X.LAST_UPDATE_DATE   AS LAST_UPDATE_DATE
											/*----------------------------------------------------------------------------------------
												2020.06.30 : KBK
												I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
											------------------------------------------------------------------------------------------*/
											,PACKAGE_TYPE
											,FACTORY_ID
											,PACKAGE_QTY
											,DOM_EXP
											,ERP_ATTR1
											,ERP_ATTR2
											,ERP_ATTR3
											,ERP_ATTR4
											,ERP_ATTR5
									FROM (
											SELECT  -- OLD
													 D.CONFIRM_ID
													,'B'     AS VERSION_TYPE
													,ISNULL(L.ATTRIBUTE2, B.ATTRIBUTE2)    AS SALES_COMPANY_ID
													--,D.DIVISION_ID
													,CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END  AS DIVISION_ID
													,D.ITEM_ID
					/*                              -- 대표모델로 사용하기로 하여 임시 주석처리 이후 협의사항에 따라 변경 가능 -- 2018.10.18
													-- 40(소형) FROM_SITE가 PACKER인 경우 PACKER에 해당하는 모델로 변환 
													,[dbo].[FN_GET_SSP_PACKER_MODEL]( CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END,
																					  D.FROM_SITE,
																					  D.ITEM_ID     )  AS  ITEM_ID
					*/
													,D.FROM_SITE
													,D.TO_SITE
													,D.YYYYMMDD
													--,(SELECT MAX(X.NEW_YYYYMMDD) 
													--  FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE X WITH(NOLOCK) 
													--  WHERE X.CHANGE_REQ_NO = @p_change_req_no
													--  AND   ISNULL(X.VALID_YN , 'N')= 'Y' 
													--    )                AS YYYYMMDD_LAST
													,ISNULL(D.QTY,0) AS QTY
													,D.BOD_ID
													,D.ROUTE_ID
													,NULL     AS OPERATION_GROUP
													,D.BIZ_TYPE
													,D.PROJECT_CODE
													,D.FCST_TYPE
													,D.FCST_ETD_DATE
													,D.FCST_ETA_DATE
													,D.ETD_DATE
													,D.ETA_DATE
													--,CASE WHEN  [dbo].[FN_GET_SSP_VMI_YN] (D.DIVISION_ID ,D.TO_SITE) = 'Y' THEN 
													--          ISNULL([dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS](D.DIVISION_ID, D.FROM_SITE, D.TO_SITE, D.ITEM_ID, D.PROJECT_CODE, D.FCST_TYPE, D.YYYYMMDD), D.INCOTERMS )
													-- ELSE D.INCOTERMS
													-- END           AS INCOTERMS
													,CASE WHEN  [dbo].[FN_GET_SSP_VMI_YN] (CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END ,D.TO_SITE) = 'Y' THEN 
															  ISNULL([dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS](CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END, D.FROM_SITE, D.TO_SITE, D.ITEM_ID, D.PROJECT_CODE, D.FCST_TYPE, D.YYYYMMDD), D.INCOTERMS )
													 ELSE D.INCOTERMS
													 END           AS INCOTERMS
													,NULL          AS INCOTERMS2
													,D.TRANSPORT_MODE
													,D.D_COUNTRY
													,D.D_PORT_CODE
													,D.A_COUNTRY
													,D.A_PORT_CODE
													,D.CUSTOMER_LT
													,D.TO_COUNTRY
													,D.TO_CITY
													,D.FROM_SITE_TYPE
													,D.FROM_SITE_PLANT_ID
													,D.FROM_SITE_VENDOR_ID
													,D.FROM_SITE_SOLDTO_CODE
													,D.FROM_SITE_SHIPTO_CODE
													,D.FROM_SITE_COMPANY_ID
													,D.TO_SITE_TYPE
													,D.TO_SITE_PLANT_ID
													,D.TO_SITE_VENDOR_ID
													,D.TO_SITE_SOLDTO_CODE
													,D.TO_SITE_SHIPTO_CODE
													,D.TO_SITE_COMPANY_ID
													-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
													,D.REMARKS2  AS BUILDING
													,D.REMARKS   AS REMARK
													,D.REMARKS3  AS CUSTOMER_REQ
													,CASE WHEN R.CHANGE_REASON_CODE = 'Select' THEN NULL ELSE R.CHANGE_REASON_CODE END AS  CHANGE_CODE
													,C.SEGMENT3  AS CHANGE_CODE_NAME
													,ISNULL(D.REQUESTOR,R.REQUEST_USER ) AS REQUESTOR
													,D.CREATED_BY
													,D.CREATION_DATE
													,D.LAST_UPDATED_BY
													,D.LAST_UPDATE_DATE
													,D.ORIGIN_TO_DIVISION_ID
													/*----------------------------------------------------------------------------------------
														2020.06.30 : KBK
														I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
													------------------------------------------------------------------------------------------*/
													,D.PACKAGE_TYPE
													,D.FACTORY_ID
													,D.PACKAGE_QTY
													,D.DOM_EXP
													,D.ERP_ATTR1
													,D.ERP_ATTR2
													,D.ERP_ATTR3
													,D.ERP_ATTR4
													,D.ERP_ATTR5
											FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ R    WITH(NOLOCK) 
												  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
															   ON C.LOOKUP_TYPE = 'CHANGE_REASON_CODE'
															  AND C.SEGMENT1 = R.CHANGE_REASON_CODE
											,     SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
												 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) -- SALES_COMPANY_ID 추출용
														ON L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO' 
														AND L.VALID_YN   = 'Y'
														AND L.SEGMENT2   = D.ORIGIN_FROM_DIVISION_ID 
														AND L.SEGMENT3   = D.FROM_SITE
														AND L.SEGMENT5   = D.ORIGIN_TO_DIVISION_ID 
														AND L.ATTRIBUTE1 = D.TO_SITE 

												 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK) 
												 ON   B.LOOKUP_TYPE = 'CELL_SHIP_FROM_TO' 
												 AND  B.VALID_YN   = 'Y'
												 AND  B.SEGMENT1 = D.FROM_SITE_COMPANY_ID 
												 AND  B.SEGMENT3 = D.FROM_SITE
												 AND  B.SEGMENT4 = D.TO_SITE_COMPANY_ID 
												 AND  B.SEGMENT5 = D.TO_SITE 
											WHERE R.CHANGE_REQ_NO = D.CHANGE_REQ_NO
											AND   R.CHANGE_REQ_NO = @p_change_request_no  
											AND   D.CONFIRM_ID    = @v_new_confirm_id
											AND   D.NEW_YN  = 'N' 
											AND   ISNULL(D.ATTRIBUTE1,'N') = 'Y' 
									) X
					   							JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
											 ON X.DIVISION_ID   = D.DIVISION_ID

									-- 2020-08-24 11:19:51
									-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
									-- 2020-08-24  kimbl1
									LEFT OUTER JOIN SCM_MST_SITE FS  WITH(NOLOCK)
												ON  FS.DIVISION_ID = X.DIVISION_ID 
												AND FS.SCM_SITE_ID = X.FROM_SITE 
												AND FS.VALID_YN    = 'Y' 
									LEFT OUTER JOIN SCM_MST_SITE TS  WITH(NOLOCK)
												ON  TS.DIVISION_ID = X.DIVISION_ID 
												AND TS.SCM_SITE_ID = X.TO_SITE 
												AND TS.VALID_YN    = 'Y' 
									WHERE 1 = 1
								) A
								LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'COMPANY_ID'	AND A.SALES_COMPANY_ID = X1.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X2 WITH(NOLOCK) ON X2.CODETYPE = 'SCP_SITE_ID' AND A.FROM_SITE = X2.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X3 WITH(NOLOCK) ON X3.CODETYPE = 'SCP_SITE_ID' AND A.TO_SITE = X3.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X4 WITH(NOLOCK) ON X4.CODETYPE = 'PLANT_ID'	AND A.FROM_SITE_PLANT_ID = X4.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X5 WITH(NOLOCK) ON X5.CODETYPE = 'VENDOR_ID'	AND A.FROM_SITE_VENDOR_ID = X5.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X6 WITH(NOLOCK) ON X6.CODETYPE = 'END_CUSTOMER_ID' AND A.FROM_SITE_SOLDTO_CODE = X6.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X7 WITH(NOLOCK) ON X7.CODETYPE = 'END_CUSTOMER_ID' AND A.FROM_SITE_SHIPTO_CODE = X7.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X8 WITH(NOLOCK) ON X8.CODETYPE = 'COMPANY_ID' AND A.FROM_SITE_COMPANY_ID = X8.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X9 WITH(NOLOCK) ON X9.CODETYPE = 'PLANT_ID'	AND A.TO_SITE_PLANT_ID = X9.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X10 WITH(NOLOCK) ON X10.CODETYPE = 'VENDOR_ID'	AND A.TO_SITE_VENDOR_ID = X10.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X11 WITH(NOLOCK) ON X11.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SOLDTO_CODE = X11.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X12 WITH(NOLOCK) ON X12.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SHIPTO_CODE = X12.OLD_VALUE1
								LEFT OUTER JOIN NERP_CONV_MASTER X13 WITH(NOLOCK) ON X13.CODETYPE = 'COMPANY_ID' AND  A.TO_SITE_COMPANY_ID = X13.OLD_VALUE1
								;

							   -- D일경우 ATTRIBUTE1DMF N으로 원복 해줌( 삭제대상 )
							   UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 
							   SET    ATTRIBUTE1 = 'N'
							   WHERE  CHANGE_REQ_NO = @p_change_request_no 
							   AND    CONFIRM_ID    = @v_new_confirm_id
							   AND    ISNULL(ATTRIBUTE1,'N') = 'Y'
							   ;
							END
							
							--SSP_ANL_SHIP_CONFIRM update
							if (@p_change_status in ('A','P')) --Approved, Partial Approved 인 경우 처리(R, S인경우에는 SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM 에서 처리)
							BEGIN
								UPDATE A							
								SET A.SHIPMENT_STATUS = 'C'
								,	A.CHANGE_REQ_NO = (CASE WHEN @v_status_detail = 'R' THEN null  ELSE A.CHANGE_REQ_NO END) 
								,	A.ATTRIBUTE1    = (CASE WHEN @v_status_detail = 'R' THEN null  ELSE A.ATTRIBUTE1 END) 
								,	A.QTY           = (CASE WHEN @v_status_detail = 'R' THEN B.QTY ELSE A.QTY END) 
								,	A.LAST_UPDATED_BY  = (CASE WHEN @v_status_detail = 'R' THEN @P_LAST_UPDATED_BY  ELSE A.LAST_UPDATED_BY END)  
								,	A.LAST_UPDATE_DATE = (CASE WHEN @v_status_detail = 'R' THEN @V_LAST_UPDATE_DATE	ELSE A.LAST_UPDATE_DATE END) 
								FROM [dbo].[SSP_ANL_SHIP_CONFIRM] A
								INNER JOIN [dbo].[SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE] B
								ON (B.CONFIRM_ID = A.CONFIRM_ID
								AND B.CHANGE_REQ_NO = @p_change_request_no
								AND B.CONFIRM_ID    = @v_new_confirm_id)
								;
							END

						END  --end of @mst_loop_cnt > 0 
				END --end of while loop
		END

		-- ERP IF SEQ MERGE 전송
		--EXEC PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE @p_change_request_no, 'D';

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code ;

	 END TRY

	 BEGIN CATCH
		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
END
