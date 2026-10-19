

/*
 * Program ID   : SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
 * Description  : Shipment Plan Change 작성중 Confirm별로 삭제(일괄 삭제 -> 개별 Confirm)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/04/05   jilee      최초작성
 * 2025/08/18   chkim.68       to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> FN_GET_SSP_SITE_INFO_EXCEPTION
 */

CREATE PROCEDURE [dbo].[SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM]
	 @p_confirm_id			NVARCHAR(MAX)	
	,@p_change_request_no	NVARCHAR(MAX)
	,@p_del_flag			NVARCHAR(MAX) = 'D'
	,@p_last_updated_by		NVARCHAR(MAX)
	,@p_time_zone			NVARCHAR(MAX)
	,@p_if_send_flag        NVARCHAR(MAX) = 'Y'
	,@p_change_type			NVARCHAR(MAX) = 'C'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_last_update_date     datetime;

	SET @v_last_update_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;	


	DECLARE @V_change_request_no	NVARCHAR(MAX)
	DECLARE @v_confirm_id			NVARCHAR(MAX)
	DECLARE @v_error_flag			NVARCHAR(MAX)

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @v_infseqno	nvarchar(14);
	DECLARE @v_last_confirm_date nvarchar(8);
		
   IF OBJECT_ID('tempdb..#tmp_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106') IS NOT NULL
       DROP TABLE #tmp_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106

	CREATE TABLE #tmp_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 
	(
		 IFSEQNO				nvarchar(100) 
		,CONFIRM_ID             nvarchar(100)
		,SHIPMENT_STATUS        nvarchar(100)
		,LAST_CONFIRM_DATE      nvarchar(100)
		,VERSION_TYPE           nvarchar(100)
		,SALES_COMPANY_ID       nvarchar(30)
		,DIVISION_ID            nvarchar(30)
		,ITEM_ID                nvarchar(50)
		,FROM_SITE              nvarchar(30)
		,TO_SITE                nvarchar(30)
		,YYYYMMDD               nvarchar(8 )
		,QTY                    numeric	(20)  
		,BOD_ID                 nvarchar(150)
		,ROUTE_ID               bigint
		,OPERATION_GROUP        nvarchar(10)
		,BIZ_TYPE               nvarchar(30)
		,PROJECT_CODE           nvarchar(50)
		,FCST_TYPE              nvarchar(20)
		,FCST_ETD_DATE          nvarchar(8 )
		,FCST_ETA_DATE          nvarchar(8 )
		,ETD_DATE               nvarchar(8 )
		,ETA_DATE               nvarchar(8 )
		,INCOTERMS              nvarchar(10)
		,INCOTERMS2             nvarchar(10)
		,TRANSPORT_MODE         nvarchar(50)
		,D_COUNTRY              nvarchar(3 )
		,D_PORT_CODE            nvarchar(10)
		,A_COUNTRY              nvarchar(3 )
		,A_PORT_CODE            nvarchar(10)
		,CUSTOMER_LT            INT
		,TO_COUNTRY             nvarchar(3 )
		,TO_CITY                nvarchar(5 ) --길이확인
		,FROM_SITE_TYPE         nvarchar(1 )
		,FROM_SITE_PLANT_ID     nvarchar(30)
		,FROM_SITE_VENDOR_ID    nvarchar(30)
		,FROM_SITE_SOLDTO_CODE  nvarchar(10)
		,FROM_SITE_SHIPTO_CODE  nvarchar(10)
		,FROM_SITE_COMPANY_ID   nvarchar(30)
		,TO_SITE_TYPE           nvarchar(1 )
		,TO_SITE_PLANT_ID       nvarchar(30)
		,TO_SITE_VENDOR_ID      nvarchar(30)
		,TO_SITE_SOLDTO_CODE    nvarchar(10)
		,TO_SITE_SHIPTO_CODE    nvarchar(10)
		,TO_SITE_COMPANY_ID     nvarchar(30)
		,BUILDING				nvarchar(255)
		,REMARK					nvarchar(255)
		,CUSTOMER_REQ			nvarchar(255)
		,CHANGE_CODE			nvarchar(3)
		,CHANGE_CODE_NAME		nvarchar(100)
		,REQUESTOR				nvarchar(100)
		,TRANSFER_FLAG          nvarchar(1)
		,TRANSFER_DATE          datetime
		,CREATED_BY             nvarchar(150)
		,CREATION_DATE          datetime
		,LAST_UPDATED_BY        nvarchar(150)
		,LAST_UPDATE_DATE       datetime
		,ATTRIBUTE1	            nvarchar(150)
		,PACKAGE_TYPE	        nvarchar(30)
		,FACTORY_ID	            nvarchar(30)
		,PACKAGE_QTY	        numeric(20,10)
		,DOM_EXP	            nvarchar(30)
		,ERP_ATTR1	            nvarchar(150)
		,ERP_ATTR2	            nvarchar(150)
		,ERP_ATTR3	            nvarchar(150)
		,ERP_ATTR4	            nvarchar(150)
		,ERP_ATTR5	            nvarchar(150)
	);

	-- 트렌젝션 시작

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = @v_last_update_date;--[dbo].[FN_MULTY_TIME](@p_time_zone);
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_ERP_IFSEQNO) ,6);
		
		-- 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10)
		SET @v_last_confirm_date =  CONVERT ( VARCHAR(8), GETDATE() + 9 , 112) ;

		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_confirm_id, @v_delimiter);
		WHILE LEN(@p_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
							
				SET @v_confirm_id								= dbo.SCM_ARR_SPL_VAL( @p_confirm_id,							@v_delimiter, @mst_loop_cnt );	
				
			END;
			
			--update SSP_ANL_SHIP_CONFIRM_CHG_REQ
			--   set VALID_YN = 'N'
			--	  ,LAST_UPDATED_BY = @p_last_updated_by
			--	  ,LAST_UPDATE_DATE = @v_last_update_date
			--WHERE CHANGE_REQ_NO = @v_change_request_no;
			
			BEGIN
				update SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
				set VALID_YN = 'N'
				,ATTRIBUTE1 = 'Y'
				,LAST_UPDATED_BY = @p_last_updated_by
				,LAST_UPDATE_DATE = @v_last_update_date					
				WHERE CHANGE_REQ_NO = @p_change_request_no
				AND CONFIRM_ID = @v_confirm_id;

				UPDATE SSP_ANL_SHIP_CONFIRM
				SET SHIPMENT_STATUS = 'C'
				,CHANGE_REQ_NO = NULL
				,ATTRIBUTE1 = NULL
				,LAST_UPDATED_BY = @p_last_updated_by
				,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
				WHERE CONFIRM_ID IN (
					SELECT CONFIRM_ID 
					FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE with(nolock)
					WHERE CHANGE_REQ_NO = @p_change_request_no
					AND CONFIRM_ID = @v_confirm_id
				)
				;
			END
			
			DELETE FROM SSP_ANL_SHIP_CONFIRM
			WHERE CONFIRM_ID  = @v_confirm_id					
			--IN (
			--	SELECT CONFIRM_ID 
			--	FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE with(nolock)
			--	WHERE CHANGE_REQ_NO = @v_change_request_no
			--)
			AND CHANGE_TYPE = 'N'
			;

			-- 삭제 처리
			BEGIN
				IF @p_del_flag = 'D' and @p_if_send_flag = 'Y'
					INSERT INTO #tmp_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106
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
						,'E'  AS SHIPMENT_STATUS 
						,@v_last_confirm_date AS LAST_CONFIRM_DATE
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
						-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
						,BUILDING
						,REMARK
						,CUSTOMER_REQ
						,CHANGE_CODE
						,CASE WHEN CHANGE_CODE = 'C00' THEN 'Shipment Plan Adjustment' ELSE   CHANGE_CODE_NAME END  AS CHANGE_CODE_NAME
						,REQUESTOR
						,'X'                AS TRANSFER_FLAG
						--,GETDATE()          AS TRANSFER_DATE
						,NULL		          AS TRANSFER_DATE
						,X.CREATED_BY         AS CREATED_BY    
						--,X.CREATION_DATE      AS CREATION_DATE
						,GETDATE()      AS CREATION_DATE
						,X.LAST_UPDATED_BY    AS LAST_UPDATED_BY 
						--,X.LAST_UPDATE_DATE   AS LAST_UPDATE_DATE
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
						,ERP_ATTR4
						,ERP_ATTR5
					FROM (
							SELECT 
									 D.CONFIRM_ID
									,'B'     AS VERSION_TYPE
									,ISNULL(L.ATTRIBUTE2, B.ATTRIBUTE2)    AS SALES_COMPANY_ID
									--,D.DIVISION_ID
									,CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END  AS DIVISION_ID
									,D.ITEM_ID	
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
							-- jilee 신규건 일시 배제
							--AND   D.NEW_YN  = 'N' 
							AND   ISNULL(D.ATTRIBUTE1,'N') = 'Y'
							AND   D.CONFIRM_ID = @v_confirm_id
					) X
					JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
					       	    ON X.DIVISION_ID   = D.DIVISION_ID
					LEFT OUTER JOIN SCM_MST_SITE FS  WITH(NOLOCK)
								ON  FS.DIVISION_ID = X.DIVISION_ID 
								AND FS.SCM_SITE_ID = X.FROM_SITE 
								AND FS.VALID_YN    = 'Y' 
					LEFT OUTER JOIN SCM_MST_SITE TS  WITH(NOLOCK)
								ON  TS.DIVISION_ID = X.DIVISION_ID 
								AND TS.SCM_SITE_ID = X.TO_SITE 
								AND TS.VALID_YN    = 'Y' 
					WHERE 1 = 1
					AND X.CONFIRM_ID = @v_confirm_id
					;

				-- D일경우 ATTRIBUTE1DMF N으로 원복 해줌( 삭제대상 )
				UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 
				SET    ATTRIBUTE1 = 'N'
				WHERE  CHANGE_REQ_NO = @p_change_request_no 
				AND    ISNULL(ATTRIBUTE1,'N') = 'Y'
				AND    CONFIRM_ID = @v_confirm_id
				; 
				END		
		END			

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
		SELECT * FROM #tmp_XIF_ERP_SHIP_PLAN_CONFIRM_S_1106 with(nolock)

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		IF (
				SELECT COUNT(*) 
				FROM SSP_ANL_SHIP_CONFIRM (NOLOCK)
				WHERE CONFIRM_ID 				
				IN (
					SELECT CONFIRM_ID 
					FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE (NOLOCK)
					WHERE CHANGE_REQ_NO = @p_change_request_no
				)
			) < 1  -- 데이터가 존재하지 않는경우
			BEGIN
				SELECT  'X' AS result_code ;

				RETURN;

			END
		
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

		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
END

