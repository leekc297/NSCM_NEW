
/*
 * Program ID   : PR_SSP_MST_WS_CALL_BATCH  
 * Description  : 출하요청 draft 상태인 대상 삭제를 위함 (daily batch)
                  해당 대상은 ERP로 전송이 되어야 함 
 * Execute      : EXEC PR_SSP_SHIP_CONFIRM_BATCH 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.07.02   LJH         [PJ20189106] 전지.GSCM 고도화 이행 
 * 2024.10.01   KHJ         NERP_SSP

  삭제 대상 
    CHANGE_REQ_STATUS = 'D' (Draft) 
	CHANGE_TYPE  <> 'P'<== P는 DAILY PLAN 수행시 자동 삭제 처리됨 정리됨, 소형(DIv=40)은 P type이 없음 ) 
	LAST_UPDATE_DATE 
  처리 순서     
	1) PR_SSP_MST_WS_CALL_BATCH 수행(@p_type = 'IN') : 삭제대상에 대한 상태 변경 및 I/F대상 정보 생성 
    2) UI Batch에서 WS호출(SAP PI)및 I/F 전송 및 후처리 호출 
	   - WS_CALL_FLAG= 'N' 대상 CHANGE_REQ_NO,IFSEQNO 별 ERP 전송 
	   - 전송처리결과 UPDATE (SSP_MST_WS_CALL) 
	     성공 : WS_CALL_FLAG = 'Y' ,WS_CALL_DATE= GETDATE()
		 실패 : WS_CALL_FLAG = 'E' ,WS_CALL_DATE= GETDATE() , WS_ERROR_DESC = '에러내용'
       - PR_SSP_MST_WS_CALL_BATCH 호출(@p_type = 'OUT', @p_batch_id )
    3) PR_SSP_MST_WS_CALL_BATCH 실행
	   - ERROR인 경우 상태 원  
 * 2020.06.16   LJH         [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 , 전극 3자거래 구분을 위한 SALES_COMPANY_ID  
 * 2025/08/18   chkim.68       to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
 */

CREATE PROCEDURE [dbo].[PR_SSP_MST_WS_CALL_BATCH]
( 
	  @p_type               NVARCHAR(5),      -- IN: 대상생성, OUT : ERP전송 후 후처리  
	  @p_batch_id           NVARCHAR(30) = '' -- p_type = 'IN' --> '' . p_type = 'OUT' --> IN일때 생성된 batch_id 

) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user       NVARCHAR(150) = N'ssp_batch';  

    DECLARE @v_program_name		NVARCHAR(150) = N'PR_SSP_MST_WS_CALL_BATCH';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id			NVARCHAR(150) = N'SSP_MST_WS_CALL'; -- ▶ 테이블 필수
    DECLARE @d_event_date		DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_MST_WS_CALL INSERT LOGIC';
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
    DECLARE @v_start_time        DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time         NVARCHAR(10) = ''


    DECLARE @v_infseqno		     NVARCHAR(14);	
	DECLARE @v_sms_desc          NVARCHAR(4000);
    DECLARE @v_batch_id          NVARCHAR(12); 	
	SET     @v_batch_id = @p_batch_id ;
	DECLARE @v_last_update_date  DATETIME;
	SET     @v_last_update_date  = SYSDATETIME();
	DECLARE @v_last_updated_by   NVARCHAR(30) = N'ssp_batch' ;
	DECLARE @v_last_confirm_date NVARCHAR(8);	
	DECLARE @v_chk				 INT;



    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

		-----------------------------------------------------------
		-- SMS 전송 : Daily Confirm  START (44)
		-----------------------------------------------------------
	    -- 수행시간이 짧아 시작 문자는 제외 
		--SET @v_sms_desc = @p_division_id + '::SSP';
		--EXEC SCM_ADM_SMS_SEND_BATCH 44, @v_sms_desc;


		-----------------------------------------------------------------------------------------
		--[1] DRAFT 대상 전 처리 (  @p_type = 'IN' )
		-- SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 상태UPDATE
		-- ERP 전송 I/F데이터생성(XIF_ERP_SHIP_PLAN_CONFIRM_S) 
		-----------------------------------------------------------------------------------------
		IF @p_type ='IN' 

			BEGIN 
				------------------------------------------------------------------------------------------------------------- 
				-- 0. temp 테이블 생성 : 
				------------------------------------------------------------------------------------------------------------- 
				IF OBJECT_ID('tempdb..#tmp_SSP_MST_WS_CALL') IS NOT NULL
				DROP TABLE #tmp_SSP_MST_WS_CALL

				CREATE TABLE #tmp_SSP_MST_WS_CALL(
							 BATCH_ID       NVARCHAR(020)   
							,CHANGE_REQ_NO  NVARCHAR(020)  
							,CHANGE_TYPE    NVARCHAR(020)
							,CONFIRM_ID     NVARCHAR(020)  
							,ERP_STATUS     NVARCHAR(010)   
								);

				-- batch_id 채번 
				SET @v_batch_id = 'B'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_WS_CALL_BATCH_ID),3) ;

				-- 대상 추출 및 TEMP_INSERT 
				INSERT INTO #tmp_SSP_MST_WS_CALL(
						 BATCH_ID         
						,CHANGE_REQ_NO  
						,CHANGE_TYPE   
						,CONFIRM_ID 
						,ERP_STATUS      
				)
 				SELECT  @v_batch_id 
				,       R.CHANGE_REQ_NO
				,       R.CHANGE_TYPE 
				,       C.CONFIRM_ID 
				,       ISNULL(C.ERP_STATUS,'X')
				FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ R WITH(NOLOCK) 
						JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
						ON D.CHANGE_REQ_NO = R.CHANGE_REQ_NO
						JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
						ON  D.CONFIRM_ID = C.CONFIRM_ID		 
				WHERE R.CHANGE_REQ_STATUS  = 'D' -- Draft 상태 
				AND   R.VALID_YN = 'Y'     -- 유효한 요청서(기 삭제된 요청서 제외) 
				AND   R.CHANGE_TYPE <> 'P' -- CHANGE_TYPE : P는 DAILY PLAN 수행시 자동 삭제 처리됨 정리됨 
				AND   CONVERT(CHAR(8), R.CREATION_DATE, 112) <= CONVERT(CHAR(8), GETDATE()-2, 112) -- 삭제 대상 기간 
				GROUP BY R.CHANGE_REQ_NO, R.CHANGE_TYPE, C.CONFIRM_ID ,C.ERP_STATUS
				ORDER BY R.CHANGE_REQ_NO 
				;

				-----------------------------------------------------------------------------------------
				-- CUR_STATUS_UPDATE  처리를 위한 CURSOR 생성 및 처리
				-- CONFIRM_ID 단위 처리   
				-----------------------------------------------------------------------------------------
				DECLARE @change_req_no VARCHAR(30) ;
				DECLARE @change_type   VARCHAR(30) ;
				DECLARE @confirm_id    VARCHAR(30) 

				DECLARE @idx INT     SET     @idx = 0 
			
				DECLARE CUR_STATUS_UPDATE CURSOR FOR  
				SELECT T.CHANGE_REQ_NO 
				,      T.CHANGE_TYPE
				,      T.CONFIRM_ID
				FROM #tmp_SSP_MST_WS_CALL T WITH(NOLOCK) 
				;

				OPEN CUR_STATUS_UPDATE; 
				FETCH NEXT FROM CUR_STATUS_UPDATE INTO @change_req_no, @change_type, @confirm_id;
																																																																																																																																																																																																																																																																																																																																																																																														WHILE(@@FETCH_STATUS = 0) 
					BEGIN; 
						--Idx 1씩 증가 
						SET @idx = @idx + 1 
						--------------------------------------------
						-- SSP_ANL_SHIP_CONFIRM  UPDATE OR DELETE
						--------------------------------------------
						IF @change_type = 'C'
							BEGIN
								UPDATE SSP_ANL_SHIP_CONFIRM
								SET SHIPMENT_STATUS  = 'C'
								,   CHANGE_REQ_NO    = NULL
								,   ATTRIBUTE1       = NULL
								,   LAST_UPDATED_BY  = @v_last_updated_by
								,   LAST_UPDATE_DATE = @v_last_update_date
								WHERE CONFIRM_ID = @confirm_id;
							END
						ELSE IF @change_type = 'N'
							BEGIN
								DELETE SSP_ANL_SHIP_CONFIRM
								WHERE CONFIRM_ID = @confirm_id;
							END

						--------------------------------------------
						-- SSP_ANL_SHIP_CONFIRM_CHG_REQ    UPDATE
						-- SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE UPDATE  
						--------------------------------------------
						UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
						SET VALID_YN         = 'N'
						,   ATTRIBUTE1       = 'Y'   -- 삭제대상 표시 
						,   LAST_UPDATED_BY  = @v_last_updated_by
						,   LAST_UPDATE_DATE = @v_last_update_date
						WHERE CONFIRM_ID = @confirm_id
						AND   CHANGE_REQ_NO = @change_req_no
						;

						SELECT @v_chk = COUNT(*) 
						FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)
						WHERE CHANGE_REQ_NO = @change_req_no
						AND VALID_YN = 'Y'
						;

						--IF @v_chk = 0
						--	BEGIN
								UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
								SET VALID_YN      = 'N'
								,LAST_UPDATED_BY  = @v_last_updated_by
								,LAST_UPDATE_DATE = @v_last_update_date
								,ATTRIBUTE1       = 'Batch_Deleted'
								WHERE CHANGE_REQ_NO = @change_req_no
							--END

						FETCH NEXT FROM CUR_STATUS_UPDATE INTO @change_req_no, @change_type, @confirm_id ; 
					END; 

				CLOSE CUR_STATUS_UPDATE; 
				DEALLOCATE CUR_STATUS_UPDATE;
				-- CUR_STATUS_UPDATE 처리 END 



				-----------------------------------------------------------------------------------------
				-- IF_DATA 처리를 위한 CURSOR 생성 및 처리
				-- CHANGE_REQ 단위 처리 CHANGE_TYPE = 'C'인경우만 생성 
				-- DO생성건은 I/F 보내지 않음(ERP_STATUS ='C') 
				-- N(NEW)인경우 기존에 ERP에 보낸정보가 없기때문에 생성필요 없음   
				-----------------------------------------------------------------------------------------
				DECLARE @change_req_no2 VARCHAR(30) ;
				DECLARE @idx2 INT     SET     @idx2 = 0 
			
				DECLARE CUR_IF_DATA CURSOR FOR  
				SELECT T.CHANGE_REQ_NO 
				FROM  #tmp_SSP_MST_WS_CALL T WITH(NOLOCK) 
				WHERE T.CHANGE_TYPE = 'C'
				AND   T.ERP_STATUS <> 'C' -- DO생성건은 i/f 보내지 않음 
				GROUP BY T.CHANGE_REQ_NO 
				;

				OPEN CUR_IF_DATA; 
				FETCH NEXT FROM CUR_IF_DATA INTO @change_req_no2 ;
																																																																																																																																																																																																																																																																																																																																																																																														WHILE(@@FETCH_STATUS = 0) 
					BEGIN; 
						--Idx 1씩 증가 
						SET @idx2 = @idx2 + 1 

						--------------------------------------------
						-- XIF_ERP_SHIP_PLAN_CONFIRM_S_SN INSERT
						--------------------------------------------
									
						--SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '00000'+ CONVERT(VARCHAR,ISNULL(MAX(RIGHT(IFSEQNO,6)),0)+1 ) ,6)
						--FROM XIF_ERP_SHIP_PLAN_CONFIRM_S_SN WITH(NOLOCK)
						--WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

						SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_ERP_IFSEQNO) ,6);

						-- 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10)
						SET @v_last_confirm_date =  CONVERT ( VARCHAR(8), GETDATE() + 9 , 112) ;

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
						,'D'             AS SHIPMENT_STATUS 
						,@v_last_confirm_date AS LAST_CONFIRM_DATE
						,VERSION_TYPE
						,ISNULL(X1.NEW_VALUE1, A.SALES_COMPANY_ID) AS SALES_COMPANY_ID
						--,X.DIVISION_ID
						,A.DIVISION_ID
						,ITEM_ID
						,ISNULL(X2.NEW_VALUE1, A.FROM_SITE)		AS FROM_SITE
						,ISNULL(X3.NEW_VALUE1, A.TO_SITE)		AS TO_SITE
						,YYYYMMDD
						,QTY
						,BOD_ID
						,ROUTE_ID
						,A.OPERATION_GROUP
						,BIZ_TYPE
						,A.PROJECT_CODE
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
						,A.FROM_SITE_TYPE  
						,ISNULL(X4.NEW_VALUE1, A.FROM_SITE_PLANT_ID)		AS FROM_SITE_PLANT_ID
						,ISNULL(X5.NEW_VALUE1, A.FROM_SITE_VENDOR_ID)		AS FROM_SITE_VENDOR_ID
						,ISNULL(X6.NEW_VALUE1, A.FROM_SITE_SOLDTO_CODE)		AS FROM_SITE_SOLDTO_CODE
						,ISNULL(X7.NEW_VALUE1, A.FROM_SITE_SHIPTO_CODE)		AS FROM_SITE_SHIPTO_CODE
						,ISNULL(X8.NEW_VALUE1, A.FROM_SITE_COMPANY_ID)		AS FROM_SITE_COMPANY_ID
						,TO_SITE_TYPE
						,ISNULL(X9.NEW_VALUE1, A.TO_SITE_PLANT_ID)			AS TO_SITE_PLANT_ID
						,ISNULL(X10.NEW_VALUE1, A.TO_SITE_VENDOR_ID)		AS TO_SITE_VENDOR_ID
						,ISNULL(X11.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)		AS TO_SITE_SOLDTO_CODE
						,ISNULL(X12.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)		AS TO_SITE_SHIPTO_CODE
						,ISNULL(X13.NEW_VALUE1, A.TO_SITE_COMPANY_ID)		AS TO_SITE_COMPANY_ID

						,BUILDING
						,REMARK
						,CUSTOMER_REQ
						,CHANGE_CODE
						,A.CHANGE_CODE_NAME
						,REQUESTOR
						,'N'                    AS TRANSFER_FLAG
						,@v_last_update_date    AS TRANSFER_DATE
						,@v_batch_user       --CREATED_BY
						,@v_last_update_date --CREATION_DATE
						,@v_batch_user		 --LAST_UPDATED_BY
						,@v_last_update_date --LAST_UPDATE_DATE	
						,@change_req_no
						/*----------------------------------------------------------------------------------------
							2020.06.30 : KBK
							I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
						----------------------------------------------------------------------------------------*/
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
									,DBO.[FN_GET_SSP_SITE_INFO_EXCEPTION](ORIGIN_TO_DIVISION_ID, FROM_SITE,TO_SITE, 'SITE_TYPE')     AS TO_SITE_TYPE  
									,DBO.[FN_GET_SSP_SITE_INFO](ORIGIN_TO_DIVISION_ID, TO_SITE, 'PLANT_ID')      AS TO_SITE_PLANT_ID   
									-- 2020-08-24 11:19:51
									-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
									-- 2020-08-24  kimbl1
									,CASE WHEN ISNULL(TS.HQ_VENDOR_CODE, '') <> '' THEN TS.HQ_VENDOR_CODE
									 ELSE DBO.[FN_GET_SSP_SITE_INFO](ORIGIN_TO_DIVISION_ID, TO_SITE, 'VENDOR_ID') END    AS TO_SITE_VENDOR_ID  
									,DBO.[FN_GET_SSP_SITE_INFO](ORIGIN_TO_DIVISION_ID, TO_SITE, 'SOLDTO_CODE')   AS TO_SITE_SOLDTO_CODE
									,DBO.[FN_GET_SSP_SITE_INFO](ORIGIN_TO_DIVISION_ID, TO_SITE, 'SHIPTO_CODE')   AS TO_SITE_SHIPTO_CODE
									,DBO.[FN_GET_SSP_SITE_INFO_EXCEPTION](ORIGIN_TO_DIVISION_ID,FROM_SITE, TO_SITE, 'COMPANY_ID')    AS TO_SITE_COMPANY_ID 
									,BUILDING
									,REMARK
									,CUSTOMER_REQ
									,CHANGE_CODE
									,CASE WHEN CHANGE_CODE = 'C00' THEN 'Shipment Plan Adjustment' ELSE   CHANGE_CODE_NAME END  AS CHANGE_CODE_NAME
									,REQUESTOR
									/*----------------------------------------------------------------------------------------
									  2020.06.30 : KBK
									  I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
									----------------------------------------------------------------------------------------*/
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
											,'B'     AS VERSION_TYPE   -- B:NEW/A:OLD 
											,ISNULL(L.ATTRIBUTE2, B.ATTRIBUTE2)    AS SALES_COMPANY_ID
											,CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END  AS DIVISION_ID
											,D.ITEM_ID
											,D.FROM_SITE
											,D.TO_SITE
											,D.YYYYMMDD
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
									AND   R.CHANGE_REQ_NO = @change_req_no2  
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

					   -- D일경우 ATTRIBUTE1 N으로 원복 해줌( 삭제대상 )
					   UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 
					   SET    ATTRIBUTE1 = 'N'
					   WHERE  CHANGE_REQ_NO = @change_req_no2 
					   AND    ISNULL(ATTRIBUTE1,'N') = 'Y'
					   ;

						--------------------------------------------
						-- WS호출을 대상 생성 SSP_MST_WS_CALL INSERT
						--------------------------------------------		
						INSERT INTO SSP_MST_WS_CALL(
								 BATCH_ID
								,IFSEQNO
								,ERP_IF_TYPE
								,CHANGE_REQ_NO
								,WS_CALL_FLAG
								,WS_CALL_DATE
								,WS_ERROR_DESC
								,BACK_PROCESS_FLAG
								,BACK_PROCESS_DATE
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE
								)
						VALUES(  @v_batch_id         --BATCH_ID
								,@v_infseqno         --IFSEQNO
								,'D'                 --ERP_IF_TYPE (Cancel) 
								,@change_req_no2      --CHANGE_REQ_NO
								,'N'                 --WS_CALL_FLAG
								,NULL                --WS_CALL_DATE
								,NULL                --WS_ERROR_DESC
								,'N'                 --BACK_PROCESS_FLAG
								,NULL                --BACK_PROCESS_DATE
								,@v_batch_user       --CREATED_BY
								,@v_last_update_date --CREATION_DATE
								,@v_batch_user		 --LAST_UPDATED_BY
								,@v_last_update_date --LAST_UPDATE_DATE	
								)
						;


						FETCH NEXT FROM CUR_IF_DATA INTO @change_req_no2 ;
					END; 

				CLOSE CUR_IF_DATA; 
				DEALLOCATE CUR_IF_DATA;
				-- CUR_IF_DATA 처리 END 



			END -- IF @p_type ='IN' BEGIN의 END



		-----------------------------------------------------------------------------------------
		--[2] WS호출 이후 결과 처리 (에러일 경우 상태 원복)   (  @p_type = 'OUT' )
		-- SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 상태UPDATE
		-----------------------------------------------------------------------------------------
	    ELSE -- IF @p_type ='OUT' 

			BEGIN
				-----------------------------------------------------------------------------------------
				-- BATCH 단위 처리를 위한 CURSOR 생성 및 처리  
				-----------------------------------------------------------------------------------------
				DECLARE @change_req_no3 VARCHAR(30)
				DECLARE @confirm_id3    VARCHAR(30)
				DECLARE @ws_call_flag   VARCHAR(30)
				DECLARE @idx3 INT     SET     @idx3 = 0 
			

				DECLARE CUR_BATCH CURSOR FOR  
				SELECT R.CHANGE_REQ_NO
				,      D.CONFIRM_ID 
				,      W.WS_CALL_FLAG 
				FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ R WITH(NOLOCK) 
						JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
							ON D.CHANGE_REQ_NO = R.CHANGE_REQ_NO 
						JOIN SSP_MST_WS_CALL W WITH(NOLOCK) 
							ON  W.BATCH_ID = @p_batch_id
                            AND W.CHANGE_REQ_NO = R.CHANGE_REQ_NO
							AND W.BACK_PROCESS_FLAG = 'N'
							AND W.WS_CALL_FLAG     <> 'N' 
				;

				-- CONFIRM_ID단위 처리 시작 
				OPEN CUR_BATCH; 
				FETCH NEXT FROM CUR_BATCH INTO @change_req_no3, @confirm_id3, @ws_call_flag
				WHILE(@@FETCH_STATUS = 0) 
					BEGIN; 
						--Idx3 1씩 증가 
						SET @idx3 = @idx3 + 1  



						-----------------------------------------------------------------------------------------
						-- WS호출후 SAP PI ERROR 발생 시 상태 원복 
						-----------------------------------------------------------------------------------------
                        IF @ws_call_flag = 'E' 
							BEGIN
								UPDATE SSP_ANL_SHIP_CONFIRM
								SET SHIPMENT_STATUS  = 'D'
								,   CHANGE_REQ_NO    = @change_req_no3
								,   LAST_UPDATED_BY  = @v_last_updated_by
								,   LAST_UPDATE_DATE = @v_last_update_date
								WHERE CONFIRM_ID = @confirm_id3;

								UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
								SET VALID_YN         = 'Y'
								,   LAST_UPDATED_BY  = @v_last_updated_by
								,   LAST_UPDATE_DATE = @v_last_update_date
								WHERE CONFIRM_ID  = @confirm_id3
								AND CHANGE_REQ_NO = @change_req_no3;

								SELECT @v_chk = COUNT(*) 
								FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de WITH(NOLOCK)
								WHERE CHANGE_REQ_NO = @change_req_no3
								AND VALID_YN = 'N';

								--IF @v_chk = 0
								--	BEGIN
										UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
										SET VALID_YN         = 'Y'
										,   LAST_UPDATED_BY  = @v_last_updated_by
										,   LAST_UPDATE_DATE = @v_last_update_date
										,   ATTRIBUTE1       = 'Batch_Deleted-ERROR'
										WHERE CHANGE_REQ_NO  = @change_req_no3
									--END
	

                            UPDATE SSP_MST_WS_CALL 
							SET    BACK_PROCESS_FLAG = 'N'
							WHERE  BATCH_ID = @p_batch_id
							AND    CHANGE_REQ_NO = @change_req_no3
							;
						END;							

						FETCH NEXT FROM CUR_BATCH INTO @change_req_no3, @confirm_id3, @ws_call_flag; 
					END; 

				CLOSE CUR_BATCH; 
				DEALLOCATE CUR_BATCH;			
				-- BATCH_ID단위 처리 END 


				-- SSP_MST_WS_CALL 처리 후 상태 UPDATE 
                UPDATE SSP_MST_WS_CALL
				SET    BACK_PROCESS_FLAG = 'Y'
				,      BACK_PROCESS_DATE = @v_last_update_date
				,      LAST_UPDATED_BY   = @v_last_updated_by
				,      LAST_UPDATE_DATE  = @v_last_update_date
				WHERE BATCH_ID = @p_batch_id
                ;  

				-- IF Table 상태 UPDATE
				UPDATE XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
				SET TRANSFER_FLAG = 'Y'
				FROM XIF_ERP_SHIP_PLAN_CONFIRM_S_SN A WITH(NOLOCK) 
				   JOIN SSP_MST_WS_CALL B WITH(NOLOCK)
					 ON A.IFSEQNO = B.IFSEQNO 
					AND B.BATCH_ID  = @p_batch_id
                ;



			END 

        -- 끝 
      

		-----------------------------------------------------------
		-- SMS 전송 : Daily Confirm END (46)
		-----------------------------------------------------------
		--SET @v_sms_desc = @p_division_id + '::SSP';
		--EXEC SCM_ADM_SMS_SEND_BATCH 46, @v_sms_desc;
		-----------------------------------------------------------

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
        SET @v_description = N'Process Complete...batch_id:'+@v_batch_id + '-' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date =  SYSDATETIME();

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

		    
			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_STATUS_UPDATE')
				BEGIN
				   CLOSE CUR_STATUS_UPDATE ;
				   DEALLOCATE CUR_STATUS_UPDATE ;
				END

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_IF_DATA')
				BEGIN
				   CLOSE CUR_IF_DATA ;
				   DEALLOCATE CUR_IF_DATA ;
				END

        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name +'- batch_id :'+ @v_batch_id+'-' + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
		-----------------------------------------------------------
		-- SMS 전송 : Daily Confirm ERROR (45)
		-----------------------------------------------------------
	--	SET @v_sms_desc = @p_division_id + '::SSP';
	--	EXEC SCM_ADM_SMS_SEND_BATCH 45, @v_sms_desc;
		-----------------------------------------------------------

      return -1

    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['++'][batch_id :' + @v_batch_id + '][' + @v_exec_time + ']'   ; 
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
