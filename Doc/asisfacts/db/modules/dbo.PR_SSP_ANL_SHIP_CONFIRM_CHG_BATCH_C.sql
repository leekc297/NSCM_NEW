/*
 * Program ID   : [PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_C]  
 * Description  : 출하확정변경시 ERP 전송 이터 테이블 저장 
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_C @p_change_type @p_change_req_no
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.24   LJH            Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018.07.09   LJH            계획구간 확정시  A: 신규확정 I/F 전송 
 * 2018.07.11   LJH            ERP I/F시 Sale Site가 VMI 일 경우 MKT FCST이 INCOTERMS를 전송  
 * 2018.09.10   LJH            전극 사업부 로직 추가 
 * 2018.09.17   LJH            ERP전송 시 40(소형) FROM_SITE가 PACKER인 경우 PACKER에 해당하는 모델로 변환 
 * 2018.10.18   LJH            대표모델로 사용하기로 하여 PACKER에 해당하는 모델 변환 내용 주석 처리 (이후 협의사항에 따라 변경 가능) 
 * 2018.11.26   LJH            ERP전송 시 FROM/TO SITE 정보를 현재 기준 정보를 전송 
 * 2019.04.09   LJH            [PJ20189106] 전지.GSCM 고도화 이행 : 소형출하계획 적용 및 ERP I/F 컬럼 추가 적용 
 * 2019.10.29   LJH            [PJ20189106] 전지.GSCM 고도화 이행 : FCST_ETA_DATE 추가적용 
 * 2020.06.16   LJH            [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 , 전극 3자거래 구분을 위한 SALES_COMPANY_ID  
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2024.10.01   KHJ            NERP_SSP
 * 2025/08/18   chkim.68       to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
 * 2026.08.24	강주용			[E20260825-000493] Shipment Plan (Auto & ESS)_WA UC화면상 수정시, 중복 인터페이스 발생
								PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH 프로시저 복사하여 생성. 
								파라미터 @p_confirm_id 추가로 받아 개별 처리하도록 변경
 */
CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_C]
( 
      @p_change_type           NVARCHAR(1),  -- B: 변경확정,C: 변경요청, D: 변경 Reject 
      @p_change_req_no         NVARCHAR(30)
	  -- START [E20260825-000493] Shipment Plan (Auto & ESS)_WA UC화면상 수정시, 중복 인터페이스 발생
	  --원본 --@P_confirm_id			   NVARCHAR(30)
	  , @p_confirm_id			   NVARCHAR(30)
	  -- END [E20260825-000493] Shipment Plan (Auto & ESS)_WA UC화면상 수정시, 중복 인터페이스 발생
    ---- , @p_debug       INT OUTPUT
) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_C';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_C'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_CONFIRM INSERT LOGIC';
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

    DECLARE @v_plan_start_yyyymmdd    NVARCHAR(8) = '';
	DECLARE @v_seq    INTEGER = 0;
	DECLARE @v_infseqno	nvarchar(14);	
	DECLARE @v_last_confirm_date nvarchar(8);	

	DECLARE @mDQry  NVARCHAR(MAX)='';

    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

		------------------------------------------------------------------------------------------------------------- 
		-- 3. ERP 전송을 위한 I/F 데이터 생성 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN 
		  -- A: 신규확정    : SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.VALID_YN = 'Y' 인것만 전송 
		  -- B: 변경확정    : SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.VALID_YN = 'Y' 인것만 전송 
		  -- C: 변경요청    : SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.VALID_YN = 'Y' 인것만 전송
		  -- D: 변경 Reject : SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.ATTRIBUTE1 'Y' 인것만 전송 
		  --                  D인경우는 전송 후 ATTRIBUTE1 을 N으로 UPDATE 수행
		------------------------------------------------------------------------------------------------------------- 

		--SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '00000'+ CONVERT(VARCHAR,ISNULL(MAX(RIGHT(IFSEQNO,6)),0)+1 ) ,6)
		--FROM XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
		--WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

		SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_ERP_IFSEQNO) ,6);

		-- 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10)
		SET @v_last_confirm_date =  CONVERT ( VARCHAR(8), GETDATE() + 9 , 112) ;


		-- A: 신규확정
		IF @p_change_type = 'A' --  VALID_YN = 'Y' 

			BEGIN
			  
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
				,ATTRIBUTE1 -- CHANGE_REQ_NO
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
					,@p_change_type  AS SHIPMENT_STATUS 
					,A.LAST_CONFIRM_DATE
					,VERSION_TYPE
					,ISNULL(X1.NEW_VALUE1, A.SALES_COMPANY_ID) AS SALES_COMPANY_ID
					,A.DIVISION_ID
					,ITEM_ID
					,ISNULL(X2.NEW_VALUE1, A.FROM_SITE)		AS FROM_SITE
					,ISNULL(X3.NEW_VALUE1, A.TO_SITE)		AS TO_SITE
					,YYYYMMDD
					,QTY
					,BOD_ID
					,ROUTE_ID
					,BIZ_TYPE  AS OPERATION_GROUP
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
					,'P'                AS TRANSFER_FLAG
					--, GETDATE()          AS TRANSFER_DATE
					, NULL				  AS TRANSFER_DATE
					,A.CREATED_BY         AS CREATED_BY    
					--,X.CREATION_DATE      AS CREATION_DATE
					,GETDATE()      AS CREATION_DATE
					,A.LAST_UPDATED_BY    AS LAST_UPDATED_BY 
					--,X.LAST_UPDATE_DATE   AS LAST_UPDATE_DATE
					,GETDATE()			  AS LAST_UPDATE_DATE
					,@p_change_req_no
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
							,CASE WHEN YYYYMMDD_LAST > @v_last_confirm_date THEN YYYYMMDD_LAST ELSE @v_last_confirm_date END   AS LAST_CONFIRM_DATE
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
							 ELSE DBO.[FN_GET_SSP_SITE_INFO](X.ORIGIN_TO_DIVISION_ID, TO_SITE, 'VENDOR_ID') END  AS TO_SITE_VENDOR_ID  
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
							,'P'                AS TRANSFER_FLAG
							--, GETDATE()          AS TRANSFER_DATE
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

							SELECT   -- NEW
									 D.CONFIRM_ID
									,'B'                AS VERSION_TYPE   -- B:NEW/A:OLD 
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
									,D.NEW_YYYYMMDD      AS YYYYMMDD
									,(SELECT MAX(X.NEW_YYYYMMDD) 
									  FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE X WITH(NOLOCK) 
									  WHERE X.CHANGE_REQ_NO = @p_change_req_no
									  AND   ISNULL(X.VALID_YN , 'N')= 'Y' 
										)                AS YYYYMMDD_LAST
									,ISNULL(D.NEW_QTY,0) AS QTY
									,D.NEW_BOD_ID        AS BOD_ID 
									,D.NEW_ROUTE_ID      AS ROUTE_ID  
									,NULL                AS OPERATION_GROUP
									,D.BIZ_TYPE
									,D.PROJECT_CODE
									,D.FCST_TYPE
									,D.NEW_ETD_DATE      AS FCST_ETD_DATE
									,D.NEW_ETA_DATE      AS FCST_ETA_DATE
									,D.NEW_ETD_DATE      AS ETD_DATE
									,D.NEW_ETA_DATE      AS ETA_DATE
									--,CASE WHEN  [dbo].[FN_GET_SSP_VMI_YN] (D.DIVISION_ID ,D.TO_SITE) = 'Y' THEN 
									--          ISNULL([dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS](D.DIVISION_ID, D.FROM_SITE, D.TO_SITE, D.ITEM_ID, D.PROJECT_CODE, D.FCST_TYPE, D.NEW_YYYYMMDD), D.NEW_INCOTERMS )
									-- ELSE D.NEW_INCOTERMS
									-- END						  AS INCOTERMS
									,CASE WHEN  [dbo].[FN_GET_SSP_VMI_YN] (CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END ,D.TO_SITE) = 'Y' THEN 
											  ISNULL([dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS](CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END, D.FROM_SITE, D.TO_SITE, D.ITEM_ID, D.PROJECT_CODE, D.FCST_TYPE, D.NEW_YYYYMMDD), D.NEW_INCOTERMS )
									 ELSE D.NEW_INCOTERMS
									 END						  AS INCOTERMS
									,NULL                         AS INCOTERMS2
									,D.NEW_TRANSPORT_MODE         AS TRANSPORT_MODE   
									,D.NEW_D_COUNTRY              AS D_COUNTRY                  
									,D.NEW_D_PORT_CODE            AS D_PORT_CODE                  
									,D.NEW_A_COUNTRY              AS A_COUNTRY                  
									,D.NEW_A_PORT_CODE            AS A_PORT_CODE                  
									,D.NEW_CUSTOMER_LT            AS CUSTOMER_LT                  
									,D.NEW_TO_COUNTRY             AS TO_COUNTRY                  
									,D.NEW_TO_CITY                AS TO_CITY
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
							AND   R.CHANGE_REQ_NO = @p_change_req_no  
							AND   ISNULL(D.VALID_YN , 'N')= 'Y' 
							AND   ISNULL(D.NEW_QTY,0) <> 0  -- 신규생성경우 0은 제외 
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
		    END	

		-- B: 변경확정  ->  A로 변경
		ELSE IF @p_change_type IN ('B')  --  VALID_YN = 'Y'
	
			BEGIN
			  
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
				,ATTRIBUTE1 -- CHANGE_REQ_NO
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
					, CONFIRM_ID	 AS CONFIRM_ID 
					,  'A'		     AS SHIPMENT_STATUS 
					,@v_last_confirm_date  AS LAST_CONFIRM_DATE
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
					,'P'                AS TRANSFER_FLAG
					--,GETDATE()          AS TRANSFER_DATE
					,NULL		          AS TRANSFER_DATE
					,A.CREATED_BY         AS CREATED_BY    
					--,X.CREATION_DATE      AS CREATION_DATE
					,GETDATE()      AS CREATION_DATE
					,A.LAST_UPDATED_BY    AS LAST_UPDATED_BY 
					--,X.LAST_UPDATE_DATE   AS LAST_UPDATE_DATE
					,GETDATE()			  AS LAST_UPDATE_DATE
					,@p_change_req_no
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
							 CONFIRM_ID	 AS CONFIRM_ID 
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
							,X.CREATED_BY         AS CREATED_BY    
							,X.LAST_UPDATED_BY    AS LAST_UPDATED_BY 
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

							SELECT   -- NEW
									 D.CONFIRM_ID
									,'B'      AS VERSION_TYPE   -- B:NEW/A:OLD 
									,ISNULL(L.ATTRIBUTE2, B.ATTRIBUTE2)    AS SALES_COMPANY_ID
									--,D.DIVISION_ID
									,CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END  AS DIVISION_ID
									,D.ITEM_ID
									,D.FROM_SITE
									,D.TO_SITE
									,D.NEW_YYYYMMDD	AS YYYYMMDD
									,ISNULL(D.NEW_QTY,0) AS QTY
									,D.NEW_BOD_ID AS BOD_ID
									,D.NEW_ROUTE_ID AS ROUTE_ID
									,NULL   AS OPERATION_GROUP
									,D.BIZ_TYPE
									,D.PROJECT_CODE
									,D.FCST_TYPE
									,D.NEW_ETD_DATE     AS FCST_ETD_DATE
									,D.NEW_ETA_DATE     AS FCST_ETA_DATE
									,D.NEW_ETD_DATE		AS ETD_DATE
									,D.NEW_ETA_DATE		AS ETA_DATE
									--,CASE WHEN  [dbo].[FN_GET_SSP_VMI_YN] (D.DIVISION_ID ,D.TO_SITE) = 'Y' THEN 
									--          ISNULL([dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS](D.DIVISION_ID, D.FROM_SITE, D.TO_SITE, D.ITEM_ID, D.PROJECT_CODE, D.FCST_TYPE, D.NEW_YYYYMMDD), D.NEW_INCOTERMS )
									-- ELSE D.NEW_INCOTERMS
									-- END                  AS INCOTERMS
									,CASE WHEN  [dbo].[FN_GET_SSP_VMI_YN] (CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END  ,D.TO_SITE) = 'Y' THEN 
											  ISNULL([dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS](CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END , D.FROM_SITE, D.TO_SITE, D.ITEM_ID, D.PROJECT_CODE, D.FCST_TYPE, D.NEW_YYYYMMDD), D.NEW_INCOTERMS )
									 ELSE D.NEW_INCOTERMS
									 END                  AS INCOTERMS
									,NULL                 AS INCOTERMS2
									,D.NEW_TRANSPORT_MODE AS TRANSPORT_MODE
									,D.NEW_D_COUNTRY	  AS D_COUNTRY
									,D.NEW_D_PORT_CODE	  AS D_PORT_CODE
									,D.NEW_A_COUNTRY	  AS A_COUNTRY
									,D.NEW_A_PORT_CODE	  AS A_PORT_CODE
									,D.NEW_CUSTOMER_LT	  AS CUSTOMER_LT
									,D.NEW_TO_COUNTRY	  AS TO_COUNTRY
									,D.NEW_TO_CITY		  AS TO_CITY
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
									,D.NEW_YN
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
							AND   R.CHANGE_REQ_NO = @p_change_req_no  
							-- START [E20260825-000493] Shipment Plan (Auto & ESS)_WA UC화면상 수정시, 중복 인터페이스 발생
							--원본--AND   D.CONFIRM_ID    = @P_confirm_id
							AND   D.CONFIRM_ID    = @p_confirm_id
							-- START [E20260825-000493] Shipment Plan (Auto & ESS)_WA UC화면상 수정시, 중복 인터페이스 발생
							AND   ISNULL(D.VALID_YN , 'N')= 'Y' 
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
		    END

        -- C: 변경요청
		ELSE IF @p_change_type IN ('C')  --  VALID_YN = 'Y'
	
			BEGIN
			  
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
				,ATTRIBUTE1 -- CHANGE_REQ_NO
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
					, CONFIRM_ID
					, @p_change_type AS SHIPMENT_STATUS 
					,@v_last_confirm_date  AS LAST_CONFIRM_DATE
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
					,BIZ_TYPE  AS OPERATION_GROUP
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
					,FROM_SITE_TYPE
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
					-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
					,BUILDING
					,REMARK
					,CUSTOMER_REQ
					,CHANGE_CODE
					,A.CHANGE_CODE_NAME
					,REQUESTOR
					,'P'                AS TRANSFER_FLAG
					--,GETDATE()          AS TRANSFER_DATE
					,NULL		          AS TRANSFER_DATE
					,A.CREATED_BY         AS CREATED_BY    
					--,X.CREATION_DATE      AS CREATION_DATE
					,GETDATE()      AS CREATION_DATE
					,A.LAST_UPDATED_BY    AS LAST_UPDATED_BY 
					--,X.LAST_UPDATE_DATE   AS LAST_UPDATE_DATE
					,GETDATE()			  AS LAST_UPDATE_DATE
					,@p_change_req_no
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
							,DBO.[FN_GET_SSP_SITE_INFO_EXCEPTION](ORIGIN_TO_DIVISION_ID, FROM_SITE,TO_SITE, 'COMPANY_ID')    AS TO_SITE_COMPANY_ID 
							-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
							,BUILDING
							,REMARK
							,CUSTOMER_REQ
							,CHANGE_CODE
							,CASE WHEN CHANGE_CODE = 'C00' THEN 'Shipment Plan Adjustment' ELSE   CHANGE_CODE_NAME END  AS CHANGE_CODE_NAME
							,REQUESTOR
							,X.CREATED_BY         AS CREATED_BY    
							,X.LAST_UPDATED_BY    AS LAST_UPDATED_BY 
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
									,'B'       AS VERSION_TYPE 
									,ISNULL(L.ATTRIBUTE2, B.ATTRIBUTE2)    AS SALES_COMPANY_ID
									,D.DIVISION_ID
									--,CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END  AS DIVISION_ID
									,D.ITEM_ID
	/*                              -- 대표모델로 사용하기로 하여 임시 주석처리 이후 협의사항에 따라 변경 가능 -- 2018.10.18
									 40(소형) FROM_SITE가 PACKER인 경우 PACKER에 해당하는 모델로 변환 
									,[dbo].[FN_GET_SSP_PACKER_MODEL]( CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END,
																	  D.FROM_SITE,
																	  D.ITEM_ID     )  AS  ITEM_ID
	*/
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
									 --ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
									,D.REMARKS2  AS BUILDING
									,D.REMARKS   AS REMARK
									,D.REMARKS3  AS CUSTOMER_REQ
									,CASE WHEN R.CHANGE_REASON_CODE = 'Select' THEN NULL ELSE R.CHANGE_REASON_CODE END AS  CHANGE_CODE
									,C.SEGMENT3  AS CHANGE_CODE_NAME
									,ISNULL(D.REQUESTOR,R.REQUEST_USER )  AS REQUESTOR

									,D.CREATED_BY
									,D.CREATION_DATE
									,D.LAST_UPDATED_BY
									,D.LAST_UPDATE_DATE
									,D.ORIGIN_TO_DIVISION_ID
									/*----------------------------------------------------------------------------------------
										2020.06.30 : KBK
										I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
									----------------------------------------------------------------------------------------*/
									,D.PACKAGE_TYPE
									,D.FACTORY_ID
									,D.PACKAGE_QTY
									,D.DOM_EXP
									,D.ERP_ATTR1
									,D.ERP_ATTR2
									,D.ERP_ATTR3
									,D.ERP_ATTR4
									,D.ERP_ATTR5
									,D.NEW_YN
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
							AND   R.CHANGE_REQ_NO = @p_change_req_no 
							-- START [E20260825-000493] Shipment Plan (Auto & ESS)_WA UC화면상 수정시, 중복 인터페이스 발생
							--원본 --AND   D.CONFIRM_ID    = @P_confirm_id
							AND   D.CONFIRM_ID    = @p_confirm_id
							-- END [E20260825-000493] Shipment Plan (Auto & ESS)_WA UC화면상 수정시, 중복 인터페이스 발생
							AND   D.NEW_YN  = 'N' 
							AND   ISNULL(D.VALID_YN , 'N')= 'Y' 

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
		    END
        -- D: 변경 Reject
		ELSE IF @p_change_type = 'D'   -- ATTRIBUTE1 = 'Y'인

		   BEGIN
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
					,@p_change_type  AS SHIPMENT_STATUS 
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
					-- 현재 시점의 FROM/TO SITE 정보 전송(2018.11.26)
					,FROM_SITE_TYPE
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
					-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
					,BUILDING
					,REMARK
					,CUSTOMER_REQ
					,CHANGE_CODE
					,CASE WHEN CHANGE_CODE = 'C00' THEN 'Shipment Plan Adjustment' ELSE   CHANGE_CODE_NAME END  AS CHANGE_CODE_NAME
					,REQUESTOR
					,'P'                AS TRANSFER_FLAG
					--,GETDATE()          AS TRANSFER_DATE
					,NULL		          AS TRANSFER_DATE
					,A.CREATED_BY         AS CREATED_BY    
					--,X.CREATION_DATE      AS CREATION_DATE
					,GETDATE()      AS CREATION_DATE
					,A.LAST_UPDATED_BY    AS LAST_UPDATED_BY 
					--,X.LAST_UPDATE_DATE   AS LAST_UPDATE_DATE
					,GETDATE()			  AS LAST_UPDATE_DATE
					,@p_change_req_no
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
							,X.CREATED_BY         AS CREATED_BY    
							,X.LAST_UPDATED_BY    AS LAST_UPDATED_BY 
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
									,'B'     AS VERSION_TYPE   -- B:NEW/A:OLD 
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
							AND   R.CHANGE_REQ_NO = @p_change_req_no  
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
			   WHERE  CHANGE_REQ_NO = @p_change_req_no 
			   AND    ISNULL(ATTRIBUTE1,'N') = 'Y'
			   ;

		   END 
		 

        ---------------------------------------------------------
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
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112)  + ' : ' + @p_change_req_no + ':' +@p_change_type;
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
        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N' ERROR_LINE : ' + STR(ERROR_LINE());
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
    SET @v_description = N'['++'][' + @v_exec_time + ']';  
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
