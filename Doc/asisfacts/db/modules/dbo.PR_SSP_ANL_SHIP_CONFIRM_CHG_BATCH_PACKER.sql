/*
 * Program ID   : [PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER]  
 * Description  : 출하확정변경시 ERP 전송 이터 테이블 저장 
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH @p_change_type @p_change_req_no
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.09.23   KIMYONGHO      최초작성
 * 2024.10.01   KHJ            NERP_SSP
 */
CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER]
( 
      @p_change_type           NVARCHAR(1),  -- B: 변경확정,C: 변경요청, D: 변경 Reject 
      @p_change_req_no         NVARCHAR(30)
	 -- @P_confirm_id			   NVARCHAR(30)

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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;
	
	DECLARE @IF_GROUP_NO				 [NVARCHAR](50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');

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
	DECLARE @ifseqno	nvarchar(20);	
	DECLARE @v_last_confirm_date nvarchar(8);	

	DECLARE @mDQry  NVARCHAR(MAX)='';

    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

		------------------------------------------------------------------------------------------------------------- 
		-- 3. ERP 전송을 위한 I/F 데이터 생성 
		  -- A: 신규확정    : SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.VALID_YN = 'Y' 인것만 전송 
		  -- B: 변경확정    : SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.VALID_YN = 'Y' 인것만 전송 
		  -- C: 변경요청    : SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.VALID_YN = 'Y' 인것만 전송
		  -- D: 변경 Reject : SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.ATTRIBUTE1 'Y' 인것만 전송 
		  --                  D인경우는 전송 후 ATTRIBUTE1 을 N으로 UPDATE 수행
		------------------------------------------------------------------------------------------------------------- 


		SET @ifseqno = CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10)


		--SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '00000'+ CONVERT(VARCHAR,ISNULL(MAX(RIGHT(IFSEQNO,6)),0)+1 ) ,6)
		--FROM XIF_ERP_PACK_SHIP_PLAN_S_SN
		--WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

		-- 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10)
		SET @v_last_confirm_date =  CONVERT ( VARCHAR(8), GETDATE() + 9 , 112) ;


		-- A: 신규확정
		IF @p_change_type = 'A' --  VALID_YN = 'Y' 

			BEGIN

				INSERT INTO XIF_ERP_PACK_SHIP_PLAN_S_SN
				( 
				  IF_SEQ
				,IF_TYPE
				,IF_ID
				,IF_INS_DATE
				,IF_FLAG
				,IF_SND_DATE
				,IFSEQNO
				,PACKER_CODE
				,DIVISION_ID
				--,PLAN_VERSION
				,PACK_MODEL_CODE
				,NICK_NAME
				--,TARGET_ORDER
				,SSP_CNFM
				,SOLD_TO
				--,SOLD_TO_NAME
				,SALES_SITE
				,SHIP_TO
				--,SHIP_TO_NAME
				,TRANSPORT_MODE
				,INCOTERMS
				,SHIP_PLAN_DATE
				,SHIP_PLAN_QTY
				,COMMENT
				,ORDER_TYPE_DETAIL
				--  20211125
			    ,ATTRIBUTE1
			    ,ATTRIBUTE2
			    ,ATTRIBUTE3
			    ,ATTRIBUTE4
			    ,ATTRIBUTE5
			    ,ATTRIBUTE6
			    ,ATTRIBUTE7
			    ,ATTRIBUTE8
			    ,ATTRIBUTE9
			    ,ATTRIBUTE10
				--
				)
				SELECT 
					'OERP' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10)   AS IF_SEQ
					,'I'
					,'OSCM_OERP_PACK_SHIP_PLAN'
					,getdate()
					,'N'
					,NULL
					,@ifseqno
					,ISNULL(X1.NEW_VALUE1, A.FROM_SITE)						AS FROM_SITE
					,A.DIVISION_ID
					,A.ITEM_ID
					,A.NICK_NAME
					,A.CONFIRM_ID
					,ISNULL(X2.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)			AS TO_SITE_SOLDTO_CODE
					,ISNULL(X3.NEW_VALUE1, A.TO_SITE)						AS TO_SITE 
					,ISNULL(X4.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)			AS TO_SITE_SHIPTO_CODE 
					,A.TRANSPORT_MODE
					,A.INCOTERMS
					,A.YYYYMMDD
					,A.QTY
					,A.REMARK
				-- 20211125			
					,A.ORDER_TYPE_DETAIL 	
					,NULL   --ATTRIBUTE1
					,NULL	  --ATTRIBUTE2
					, ATTR_03    --Model PIC   
					, ATTR_04    --MTK_OWNER       
					,NULL	  --ATTRIBUTE5
					,NULL	  --ATTRIBUTE6
					,NULL	  --ATTRIBUTE7
					,NULL	  --ATTRIBUTE8
					,NULL	  --ATTRIBUTE9
					,NULL	  --ATTRIBUTE10
				FROM 
				(
					SELECT 
						  X.FROM_SITE
						  ,X.DIVISION_ID
						  --,CONVERT(char(8), getdate(), 112)
						  ,ITEM_ID
						  ,[dbo].[FN_GET_ITEM_NICKNAME]( X.DIVISION_ID, X.ITEM_ID)  AS NICK_NAME
						  --,'O'
						  ,X.CONFIRM_ID
						  ,X.TO_SITE_SOLDTO_CODE
						  --,[dbo].[FN_GET_SITE_CUSTOMER_INFO](X.DIVISION_ID,X.TO_SITE,'SOLDTO_DESCRIPTION')	AS SOLD_TO_NAME
						  ,X.TO_SITE
						  ,X.TO_SITE_SHIPTO_CODE
						  --,[dbo].[FN_GET_SITE_CUSTOMER_INFO](X.DIVISION_ID,X.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
						  ,X.TRANSPORT_MODE
						  ,X.INCOTERMS
						  ,X.YYYYMMDD
						  ,X.QTY
						  ,X.REMARK
						-- 20211125			
						  --,X.CUSTOMER_REQ
						  ,X.ORDER_TYPE_DETAIL 	
						 , ATTR_03    --Model PIC   
						 , ATTR_04    --MTK_OWNER  
					FROM (

							SELECT   -- NEW
									 D.CONFIRM_ID
									,'B'                AS VERSION_TYPE   -- B:NEW/A:OLD 
									--,ISNULL(L.ATTRIBUTE2, B.ATTRIBUTE2)    AS SALES_COMPANY_ID
									,D.DIVISION_ID							
									,D.ITEM_ID
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

									--,D.FCST_TYPE	20211125
									,ISNULL(LK.SEGMENT2, D.FCST_TYPE) AS ORDER_TYPE_DETAIL
									------

									,D.NEW_ETD_DATE      AS FCST_ETD_DATE
									,D.NEW_ETA_DATE      AS FCST_ETA_DATE
									,D.NEW_ETD_DATE      AS ETD_DATE
									,D.NEW_ETA_DATE      AS ETA_DATE
									,D.NEW_INCOTERMS              AS INCOTERMS
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

									-- 20211125 
									, U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03    --Model PIC   
									, DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04    --MTK_OWNER       
									--
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
								-- 20211125 
								 LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
								 ON D.DIVISION_ID					= SI.DIVISION_ID
								 AND D.TO_SITE						= SI.SCM_SITE_ID
								 AND D.ITEM_ID						= SI.ITEM_ID
								 AND D.PROJECT_CODE					= SI.PROJECT_CODE

								 LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
								 ON D.DIVISION_ID = MU.DIVISION_ID
								 AND D.FROM_SITE = MU.FROM_SITE
								 AND D.ITEM_ID = MU.ITEM_ID
								 AND MU.VALID_YN = 'Y'

								 LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
								 ON mu.user_id = u2.UserID 
								 AND U2.UseYN = 'Y'

								 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
								 ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
								 AND LK.VALID_YN	= 'Y'
								 AND D.FCST_TYPE	= LK.SEGMENT1
								--
							WHERE R.CHANGE_REQ_NO = D.CHANGE_REQ_NO
							AND   R.CHANGE_REQ_NO = @p_change_req_no  
							AND   ISNULL(D.VALID_YN , 'N')= 'Y' 
							AND   ISNULL(D.NEW_QTY,0) <> 0  -- 신규생성경우 0은 제외 
					) X
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
				LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.FROM_SITE = X1.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X2 WITH(NOLOCK) ON X2.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SOLDTO_CODE = X2.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X3 WITH(NOLOCK) ON X3.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE = X3.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X4 WITH(NOLOCK) ON X4.CODETYPE = 'END_CUSTOMER_ID'	AND A.TO_SITE_SHIPTO_CODE = X4.OLD_VALUE1

				;

							  
				--INSERT INTO XIF_ERP_PACK_SHIP_PLAN_S_SN
				--( 
				--  IF_SEQ
				--,IF_TYPE
				--,IF_ID
				--,IF_INS_DATE
				--,IF_FLAG
				--,IF_SND_DATE
				--,IFSEQNO
				--,PACKER_CODE
				--,DIVISION_ID
				----,PLAN_VERSION
				--,PACK_MODEL_CODE
				--,NICK_NAME
				----,TARGET_ORDER
				--,SSP_CNFM
				--,SOLD_TO
				----,SOLD_TO_NAME
				--,SALES_SITE
				--,SHIP_TO
				----,SHIP_TO_NAME
				--,TRANSPORT_MODE
				--,INCOTERMS
				--,SHIP_PLAN_DATE
				--,SHIP_PLAN_QTY
				--,COMMENT
				--,ORDER_TYPE_DETAIL
				--)
				--SELECT 
				--	  'OERP' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10)   AS IF_SEQ
				--	  ,'I'
				--	  ,'OSCM_OERP_PACK_SHIP_PLAN'
				--	  ,getdate()
				--	  ,'N'
				--	  ,NULL
				--	  ,@ifseqno
				--	  ,X.FROM_SITE
				--	  ,X.DIVISION_ID
				--	  --,CONVERT(char(8), getdate(), 112)
				--	  ,ITEM_ID
				--	  ,[dbo].[FN_GET_ITEM_NICKNAME]( X.DIVISION_ID, X.ITEM_ID)  AS NICK_NAME
				--	  --,'O'
				--	  ,X.CONFIRM_ID
				--	  ,X.TO_SITE_SOLDTO_CODE
				--	  --,[dbo].[FN_GET_SITE_CUSTOMER_INFO](X.DIVISION_ID,X.TO_SITE,'SOLDTO_DESCRIPTION')	AS SOLD_TO_NAME
				--	  ,X.TO_SITE
				--	  ,X.TO_SITE_SHIPTO_CODE
				--	  --,[dbo].[FN_GET_SITE_CUSTOMER_INFO](X.DIVISION_ID,X.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
				--	  ,X.TRANSPORT_MODE
				--	  ,X.INCOTERMS
				--	  ,X.YYYYMMDD
				--	  ,X.QTY
				--	  ,X.REMARK
				--	  ,X.CUSTOMER_REQ
				--FROM (

				--		SELECT   -- NEW
				--				 D.CONFIRM_ID
				--				,'B'                AS VERSION_TYPE   -- B:NEW/A:OLD 
				--				--,ISNULL(L.ATTRIBUTE2, B.ATTRIBUTE2)    AS SALES_COMPANY_ID
				--				,D.DIVISION_ID							
				--				,D.ITEM_ID
				--				,D.FROM_SITE
				--				,D.TO_SITE
				--				,D.NEW_YYYYMMDD      AS YYYYMMDD
				--				,(SELECT MAX(X.NEW_YYYYMMDD) 
				--				  FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE X WITH(NOLOCK) 
				--				  WHERE X.CHANGE_REQ_NO = @p_change_req_no
				--				  AND   ISNULL(X.VALID_YN , 'N')= 'Y' 
				--				    )                AS YYYYMMDD_LAST
				--				,ISNULL(D.NEW_QTY,0) AS QTY
				--				,D.NEW_BOD_ID        AS BOD_ID 
				--				,D.NEW_ROUTE_ID      AS ROUTE_ID  
				--				,NULL                AS OPERATION_GROUP
				--				,D.BIZ_TYPE
				--				,D.PROJECT_CODE
				--				,D.FCST_TYPE
				--				,D.NEW_ETD_DATE      AS FCST_ETD_DATE
				--				,D.NEW_ETA_DATE      AS FCST_ETA_DATE
				--				,D.NEW_ETD_DATE      AS ETD_DATE
				--				,D.NEW_ETA_DATE      AS ETA_DATE
				--				,D.NEW_INCOTERMS              AS INCOTERMS
				--				,D.NEW_TRANSPORT_MODE         AS TRANSPORT_MODE   
				--				,D.NEW_D_COUNTRY              AS D_COUNTRY                  
				--				,D.NEW_D_PORT_CODE            AS D_PORT_CODE                  
				--				,D.NEW_A_COUNTRY              AS A_COUNTRY                  
				--				,D.NEW_A_PORT_CODE            AS A_PORT_CODE                  
				--				,D.NEW_CUSTOMER_LT            AS CUSTOMER_LT                  
				--				,D.NEW_TO_COUNTRY             AS TO_COUNTRY                  
				--				,D.NEW_TO_CITY                AS TO_CITY
				--				,D.FROM_SITE_TYPE
				--				,D.FROM_SITE_PLANT_ID
				--				,D.FROM_SITE_VENDOR_ID
				--				,D.FROM_SITE_SOLDTO_CODE
				--				,D.FROM_SITE_SHIPTO_CODE
				--				,D.FROM_SITE_COMPANY_ID
				--				,D.TO_SITE_TYPE
				--				,D.TO_SITE_PLANT_ID
				--				,D.TO_SITE_VENDOR_ID
				--				,D.TO_SITE_SOLDTO_CODE
				--				,D.TO_SITE_SHIPTO_CODE
				--				,D.TO_SITE_COMPANY_ID
				--				-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
				--				,D.REMARKS2  AS BUILDING
				--				,D.REMARKS   AS REMARK
				--				,D.REMARKS3  AS CUSTOMER_REQ
				--				,CASE WHEN R.CHANGE_REASON_CODE = 'Select' THEN NULL ELSE R.CHANGE_REASON_CODE END AS  CHANGE_CODE
				--				,C.SEGMENT3  AS CHANGE_CODE_NAME
				--				,ISNULL(D.REQUESTOR,R.REQUEST_USER ) AS REQUESTOR
				--				,D.CREATED_BY
				--				,D.CREATION_DATE
				--				,D.LAST_UPDATED_BY
				--				,D.LAST_UPDATE_DATE
				--				,D.ORIGIN_TO_DIVISION_ID
				--				/*----------------------------------------------------------------------------------------
				--					2020.06.30 : KBK
				--					I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
				--				------------------------------------------------------------------------------------------*/
				--				,D.PACKAGE_TYPE
				--				,D.FACTORY_ID
				--				,D.PACKAGE_QTY
				--				,D.DOM_EXP
				--				,D.ERP_ATTR1
				--				,D.ERP_ATTR2
				--				,D.ERP_ATTR3
				--				,D.ERP_ATTR4
				--				,D.ERP_ATTR5
				--		FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ R    WITH(NOLOCK) 
				--			  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
				--		            ON C.LOOKUP_TYPE = 'CHANGE_REASON_CODE'
				--		            AND C.SEGMENT1 = R.CHANGE_REASON_CODE
				--		,     SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 

				--			 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) -- SALES_COMPANY_ID 추출용
				--					ON L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO' 
				--					AND L.VALID_YN   = 'Y'
				--					AND L.SEGMENT2   = D.ORIGIN_FROM_DIVISION_ID 
				--					AND L.SEGMENT3   = D.FROM_SITE
				--					AND L.SEGMENT5   = D.ORIGIN_TO_DIVISION_ID 
				--					AND L.ATTRIBUTE1 = D.TO_SITE 

				--			 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK) 
				--			 ON   B.LOOKUP_TYPE = 'CELL_SHIP_FROM_TO' 
				--			 AND  B.VALID_YN   = 'Y'
				--			 AND  B.SEGMENT1 = D.FROM_SITE_COMPANY_ID 
				--			 AND  B.SEGMENT3 = D.FROM_SITE
				--			 AND  B.SEGMENT4 = D.TO_SITE_COMPANY_ID 
				--			 AND  B.SEGMENT5 = D.TO_SITE 
				--		WHERE R.CHANGE_REQ_NO = D.CHANGE_REQ_NO
				--		AND   R.CHANGE_REQ_NO = @p_change_req_no  
				--		AND   ISNULL(D.VALID_YN , 'N')= 'Y' 
				--		AND   ISNULL(D.NEW_QTY,0) <> 0  -- 신규생성경우 0은 제외 
				--) X
				---- 2020-08-24 11:19:51
				---- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
				---- 2020-08-24  kimbl1
				--LEFT OUTER JOIN SCM_MST_SITE FS  WITH(NOLOCK)
				--			ON  FS.DIVISION_ID = X.DIVISION_ID 
				--			AND FS.SCM_SITE_ID = X.FROM_SITE 
				--			AND FS.VALID_YN    = 'Y' 
				--LEFT OUTER JOIN SCM_MST_SITE TS  WITH(NOLOCK)
				--			ON  TS.DIVISION_ID = X.DIVISION_ID 
				--			AND TS.SCM_SITE_ID = X.TO_SITE 
				--			AND TS.VALID_YN    = 'Y' 
				--WHERE 1 = 1
				--;

					INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
					   IF_SEQ           
					 , IF_TYPE          
					 , IF_ID            
					 , IF_INS_DATE      
					 , IF_FLAG          
					 , PACKER_CODE      
					 , DIVISION_ID      
					 , PLAN_VERSION   
					 , PACK_MODEL_CODE  
					 , NICK_NAME 
					 , TARGET_ORDER
					 , SSP_CNFM
					 , SALES_SITE
					 , SHIP_TO
					 , SHIP_TO_NAME
					 , TRANSPORT_MODE
					 , INCOTERMS
					 , SHIP_PLAN_DATE 
					 , SHIP_PLAN_QTY 
					 , COMMENT
					 , ATTR_01           
					 , ATTR_02           
					 , ATTR_03           
					 , ATTR_04           
					 , ATTR_05           
					 , ATTR_06           
					 , ATTR_07           
					 , ATTR_08           
					 , ATTR_09           
					 , ATTR_10 
					 , ORDER_TYPE_DETAIL
					 )
				SELECT
						 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
						, N'I'         AS IF_TYPE          
						, N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
						, GETDATE()    AS IF_INS_DATE      
						, 'N'          AS IF_FLAG          
						, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE) AS PACKER_CODE      
						, A.DIVISION_ID      
						, A.PLAN_VERSION   
						, A.PACK_MODEL_CODE  
						, A.NICK_NAME 
						,  N'O'					AS  TARGET_ORDER
						, A.SSP_CNFM
						, A.SALES_SITE
						, A.SHIP_TO
					-- , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
						, A.SHIP_TO_NAME
						, A.TRANSPORT_MODE
						, A.INCOTERMS
						, A.SHIP_PLAN_DATE 
						, A.SHIP_PLAN_QTY 
						/* 20211102  SMS  수정  ****************************************************/
--					 , NULL								AS COMMENT
						, A.COMMENT
						/****************************************************************************************************/					        
						, A.ATTR_01           
						, NULL								AS ATTR_02           
						/* 20211102  SMS  수정  ****************************************************/
--					 , NULL								AS ATTR_03    
						, A.ATTR_03      --Model PIC   				
--					 , NULL								AS ATTR_04           
						, A.ATTR_04		--MTK_OWNER       
					/****************************************************************************************************/					        
						, NULL								AS ATTR_05           
						, NULL								AS ATTR_06           
						, NULL								AS ATTR_07           
						, NULL								AS ATTR_08           
						, NULL								AS ATTR_09           
						, A.ATTR_10
					/* 20211102  SMS  수정 *******************************************************************************/
--					 , '-'				AS ORDER_TYPE_DETAIL
						, A.FCST_TYPE       --ORDER_TYPE_DETAIL
					/****************************************************************************************************/
				FROM
				(
					SELECT 
						   A.FROM_SITE  AS PACKER_CODE      
						 , A.DIVISION_ID AS DIVISION_ID      
						 , CONVERT(VARCHAR(8), CONVERT(DATETIME, getdate()), 112)    AS PLAN_VERSION   
						 , A.ITEM_ID    AS PACK_MODEL_CODE  
						 , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID)  AS NICK_NAME 
						 , A.CONFIRM_ID			 AS SSP_CNFM
						 , A.TO_SITE     AS SALES_SITE
						 , A.TO_SITE_SHIPTO_CODE AS SHIP_TO
						 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
						 , A.NEW_TRANSPORT_MODE	AS TRANSPORT_MODE
						 , A.NEW_INCOTERMS		AS	INCOTERMS
						 , A.NEW_YYYYMMDD    AS SHIP_PLAN_DATE 
						 , A.NEW_QTY         AS SHIP_PLAN_QTY 
						 /* 20211102  SMS  수정  ****************************************************/
	--					 , NULL								AS COMMENT
						 , A.REMARKS						AS COMMENT
						 /****************************************************************************************************/					        
						 , A.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
						 /* 20211102  SMS  수정  ****************************************************/
	--					 , NULL								AS ATTR_03    
						 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   				
	--					 , NULL								AS ATTR_04           
						 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER       
						/****************************************************************************************************/					        
						 , A.CONFIRM_ID						AS ATTR_10
						/* 20211102  SMS  수정 *******************************************************************************/
	--					 , '-'				AS ORDER_TYPE_DETAIL
						 , ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS FCST_TYPE       --ORDER_TYPE_DETAIL
						/****************************************************************************************************/
					FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE A WITH(NOLOCK)
					/* 20211102  SMS  추가 *****************/
						 LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 							FROM(																						
 								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									
 								  ,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num	
 							FROM scm_mst_site_item																				
 						 ) a WHERE num = 1) g on g.DIVISION_ID =  (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID	
						 LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
					  ON A.DIVISION_ID					= SI.DIVISION_ID
					 AND A.TO_SITE						= SI.SCM_SITE_ID
					 AND A.ITEM_ID						= SI.ITEM_ID
					 AND G.PROJECT_CODE					= SI.PROJECT_CODE
						 LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
					  ON A.DIVISION_ID = MU.DIVISION_ID
					 AND A.FROM_SITE = MU.FROM_SITE
					 AND A.ITEM_ID = MU.ITEM_ID
					 AND MU.VALID_YN = 'Y'
						 LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
					  ON mu.user_id = u2.UserID 
	   				 AND U2.UseYN = 'Y'
						 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
					  ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
					 AND LK.VALID_YN	= 'Y'
					 AND A.FCST_TYPE	= LK.SEGMENT1
					/****************************************************************************************************/
					WHERE  1 = 1
					 AND A.CHANGE_REQ_NO = @p_change_req_no  --'R20211001051809'
				) A 
				LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1


				 ;

				--	INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
				--	   IF_SEQ           
				--	 , IF_TYPE          
				--	 , IF_ID            
				--	 , IF_INS_DATE      
				--	 , IF_FLAG          
				--	 , PACKER_CODE      
				--	 , DIVISION_ID      
				--	 , PLAN_VERSION   
				--	 , PACK_MODEL_CODE  
				--	 , NICK_NAME 
				--	 , TARGET_ORDER
				--	 , SSP_CNFM
				--	 , SALES_SITE
				--	 , SHIP_TO
				--	 , SHIP_TO_NAME
				--	 , TRANSPORT_MODE
				--	 , INCOTERMS
				--	 , SHIP_PLAN_DATE 
				--	 , SHIP_PLAN_QTY 
				--	 , COMMENT
				--	 , ATTR_01           
				--	 , ATTR_02           
				--	 , ATTR_03           
				--	 , ATTR_04           
				--	 , ATTR_05           
				--	 , ATTR_06           
				--	 , ATTR_07           
				--	 , ATTR_08           
				--	 , ATTR_09           
				--	 , ATTR_10 
				--	 , ORDER_TYPE_DETAIL
				--	 )
				--SELECT 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
				--	 , N'I'         AS IF_TYPE          
				--	 , N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
				--	 , GETDATE()    AS IF_INS_DATE      
				--	 , 'N'          AS IF_FLAG          
				--	 , A.FROM_SITE  AS PACKER_CODE      
				--	 , A.DIVISION_ID AS DIVISION_ID      
				--	 , CONVERT(VARCHAR(8), CONVERT(DATETIME, getdate()), 112)    AS PLAN_VERSION   
				--	 , A.ITEM_ID    AS PACK_MODEL_CODE  
				--	 , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID)  AS NICK_NAME 
				--	 , N'O'          AS TARGET_ORDER
				--	 , A.CONFIRM_ID			 AS SSP_CNFM
				--	 , A.TO_SITE     AS SALES_SITE
				--	 , A.TO_SITE_SHIPTO_CODE AS SHIP_TO
				--	-- , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
				--	 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
				--	 , A.TRANSPORT_MODE
				--	 , A.INCOTERMS
				--	 , A.YYYYMMDD    AS SHIP_PLAN_DATE 
				--	 , A.QTY         AS SHIP_PLAN_QTY 
				--	 , NULL								AS COMMENT
				--	 , A.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
				--	 , NULL								AS ATTR_02           
				--	 , NULL								AS ATTR_03           
				--	 , NULL								AS ATTR_04           
				--	 , NULL								AS ATTR_05           
				--	 , NULL								AS ATTR_06           
				--	 , NULL								AS ATTR_07           
				--	 , NULL								AS ATTR_08           
				--	 , NULL								AS ATTR_09           
				--	 , A.CONFIRM_ID						AS ATTR_10
				--	 , '-'				AS ORDER_TYPE_DETAIL
				--FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
				--WHERE  1 = 1
				-- AND CONFIRM_ID IN (SELECT CONFIRM_ID  FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WHERE CHANGE_REQ_NO = @p_change_req_no)  --'R20211001051809'
				-- ;



		    END	

        -- B: 변경확정 C: 변경요청
		ELSE IF @p_change_type IN ('B','C')  --  VALID_YN = 'Y'
	
			BEGIN

				INSERT INTO XIF_ERP_PACK_SHIP_PLAN_S_SN
				( 
				 IF_SEQ
				,IF_TYPE
				,IF_ID
				,IF_INS_DATE
				,IF_FLAG
				,IF_SND_DATE
				,IFSEQNO
				,PACKER_CODE
				,DIVISION_ID
				--,PLAN_VERSION
				,PACK_MODEL_CODE
				,NICK_NAME
				--,TARGET_ORDER
				,SSP_CNFM
				,SOLD_TO
				--,SOLD_TO_NAME
				,SALES_SITE
				,SHIP_TO
				--,SHIP_TO_NAME
				,TRANSPORT_MODE
				,INCOTERMS
				,SHIP_PLAN_DATE
				,SHIP_PLAN_QTY
				,COMMENT
				,ORDER_TYPE_DETAIL
				--  20211125
			    ,ATTRIBUTE1
			    ,ATTRIBUTE2
			    ,ATTRIBUTE3
			    ,ATTRIBUTE4
			    ,ATTRIBUTE5
			    ,ATTRIBUTE6
			    ,ATTRIBUTE7
			    ,ATTRIBUTE8
			    ,ATTRIBUTE9
			    ,ATTRIBUTE10
				--
				)
				SELECT 
					'OERP' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10)   AS IF_SEQ
					,'I'
					,'OSCM_OERP_PACK_SHIP_PLAN'
					,getdate()
					,'N'
					,NULL
					,@ifseqno
					,ISNULL(X1.NEW_VALUE1, A.FROM_SITE)						AS FROM_SITE
					,A.DIVISION_ID
					--,CONVERT(char(8), getdate(), 112)
					,ITEM_ID
					,A.NICK_NAME
					--,'O'
					,A.CONFIRM_ID			  
					,ISNULL(X2.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)			AS TO_SITE_SOLDTO_CODE
					,ISNULL(X3.NEW_VALUE1, A.TO_SITE)						AS TO_SITE 
					,ISNULL(X4.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)			AS TO_SITE_SHIPTO_CODE 
					,A.TRANSPORT_MODE
					,A.INCOTERMS
					,A.YYYYMMDD
					,A.QTY
					,A.REMARK
					--	20211125
					--,X.CUSTOMER_REQ
					,A.ORDER_TYPE_DETAIL 	
					,NULL   --ATTRIBUTE1
					,NULL	  --ATTRIBUTE2
					, ATTR_03    --Model PIC   
					, ATTR_04    --MTK_OWNER       
					,NULL	  --ATTRIBUTE5
					,NULL	  --ATTRIBUTE6
					,NULL	  --ATTRIBUTE7
					,NULL	  --ATTRIBUTE8
					,NULL	  --ATTRIBUTE9
					,NULL	  --ATTRIBUTE10
				FROM
				(
					SELECT 
						   X.FROM_SITE
						  ,X.DIVISION_ID
						  --,CONVERT(char(8), getdate(), 112)
						  ,ITEM_ID
						  ,[dbo].[FN_GET_ITEM_NICKNAME]( X.DIVISION_ID, X.ITEM_ID)  AS NICK_NAME
						  --,'O'
						  ,X.CONFIRM_ID			  
						  ,X.TO_SITE_SOLDTO_CODE
						  --,[dbo].[FN_GET_SITE_CUSTOMER_INFO](X.DIVISION_ID,X.TO_SITE,'SOLDTO_DESCRIPTION')	AS SOLD_TO_NAME
						  ,X.TO_SITE
						  ,X.TO_SITE_SHIPTO_CODE
						  --,[dbo].[FN_GET_SITE_CUSTOMER_INFO](X.DIVISION_ID,X.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
						  ,X.TRANSPORT_MODE
						  ,X.INCOTERMS
						  ,X.YYYYMMDD
						  ,X.QTY
						  ,X.REMARK
						  --	20211125
						  --,X.CUSTOMER_REQ
						  ,X.ORDER_TYPE_DETAIL 	
						 , ATTR_03    --Model PIC   
						 , ATTR_04    --MTK_OWNER  
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
									,D.NEW_YYYYMMDD AS YYYYMMDD
									,ISNULL(D.NEW_QTY,0) AS QTY
									,D.NEW_BOD_ID
									,D.NEW_ROUTE_ID
									,NULL   AS OPERATION_GROUP
									,D.BIZ_TYPE
									,D.PROJECT_CODE

									--,D.FCST_TYPE   20211125
									,ISNULL(LK.SEGMENT2, D.FCST_TYPE) AS ORDER_TYPE_DETAIL
									------

									,D.NEW_ETD_DATE     AS FCST_ETD_DATE
									,D.NEW_ETA_DATE     AS FCST_ETA_DATE
									,D.NEW_ETD_DATE
									,D.NEW_ETA_DATE

									,D.NEW_INCOTERMS      AS INCOTERMS
									,D.NEW_TRANSPORT_MODE AS TRANSPORT_MODE
									,D.NEW_D_COUNTRY
									,D.NEW_D_PORT_CODE
									,D.NEW_A_COUNTRY
									,D.NEW_A_PORT_CODE
									,D.NEW_CUSTOMER_LT
									,D.NEW_TO_COUNTRY
									,D.NEW_TO_CITY
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

									-- 20211125
									, U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03    --Model PIC   
									, DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04    --MTK_OWNER       
									--
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
								-- 20211125
								 LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
								 ON D.DIVISION_ID					= SI.DIVISION_ID
								 AND D.TO_SITE						= SI.SCM_SITE_ID
								 AND D.ITEM_ID						= SI.ITEM_ID
								 AND D.PROJECT_CODE					= SI.PROJECT_CODE

								 LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
								 ON D.DIVISION_ID = MU.DIVISION_ID
								 AND D.FROM_SITE = MU.FROM_SITE
								 AND D.ITEM_ID = MU.ITEM_ID
								 AND MU.VALID_YN = 'Y'

								 LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
								 ON mu.user_id = u2.UserID 
								 AND U2.UseYN = 'Y'

								 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
								 ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
								 AND LK.VALID_YN	= 'Y'
								 AND D.FCST_TYPE	= LK.SEGMENT1
								--
							WHERE R.CHANGE_REQ_NO = D.CHANGE_REQ_NO
							AND   R.CHANGE_REQ_NO = @p_change_req_no  
							--AND   D.CONFIRM_ID    = @P_confirm_id
							AND   ISNULL(D.VALID_YN , 'N')= 'Y' 
					) X
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
				LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.FROM_SITE = X1.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X2 WITH(NOLOCK) ON X2.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SOLDTO_CODE = X2.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X3 WITH(NOLOCK) ON X3.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE = X3.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X4 WITH(NOLOCK) ON X4.CODETYPE = 'END_CUSTOMER_ID'	AND A.TO_SITE_SHIPTO_CODE = X4.OLD_VALUE1
				;
							  
				--INSERT INTO XIF_ERP_PACK_SHIP_PLAN_S_SN
				--( 
				-- IF_SEQ
				--,IF_TYPE
				--,IF_ID
				--,IF_INS_DATE
				--,IF_FLAG
				--,IF_SND_DATE
				--,IFSEQNO
				--,PACKER_CODE
				--,DIVISION_ID
				----,PLAN_VERSION
				--,PACK_MODEL_CODE
				--,NICK_NAME
				----,TARGET_ORDER
				--,SSP_CNFM
				--,SOLD_TO
				----,SOLD_TO_NAME
				--,SALES_SITE
				--,SHIP_TO
				----,SHIP_TO_NAME
				--,TRANSPORT_MODE
				--,INCOTERMS
				--,SHIP_PLAN_DATE
				--,SHIP_PLAN_QTY
				--,COMMENT
				--,ORDER_TYPE_DETAIL
				--)
				--SELECT 
				--	  'OERP' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10)   AS IF_SEQ
				--	  ,'I'
				--	  ,'OSCM_OERP_PACK_SHIP_PLAN'
				--	  ,getdate()
				--	  ,'N'
				--	  ,NULL
				--	  ,@ifseqno
				--	  ,X.FROM_SITE
				--	  ,X.DIVISION_ID
				--	  --,CONVERT(char(8), getdate(), 112)
				--	  ,ITEM_ID
				--	  ,[dbo].[FN_GET_ITEM_NICKNAME]( X.DIVISION_ID, X.ITEM_ID)  AS NICK_NAME
				--	  --,'O'
				--	  ,X.CONFIRM_ID			  
				--	  ,X.TO_SITE_SOLDTO_CODE
				--	  --,[dbo].[FN_GET_SITE_CUSTOMER_INFO](X.DIVISION_ID,X.TO_SITE,'SOLDTO_DESCRIPTION')	AS SOLD_TO_NAME
				--	  ,X.TO_SITE
				--	  ,X.TO_SITE_SHIPTO_CODE
				--	  --,[dbo].[FN_GET_SITE_CUSTOMER_INFO](X.DIVISION_ID,X.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
				--	  ,X.TRANSPORT_MODE
				--	  ,X.INCOTERMS
				--	  ,X.YYYYMMDD
				--	  ,X.QTY
				--	  ,X.REMARK
				--	  ,X.CUSTOMER_REQ
				--FROM ( 
				--		SELECT   -- NEW
				--				 D.CONFIRM_ID
				--				,'B'      AS VERSION_TYPE   -- B:NEW/A:OLD 
				--				,ISNULL(L.ATTRIBUTE2, B.ATTRIBUTE2)    AS SALES_COMPANY_ID
				--				--,D.DIVISION_ID
				--				,CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END  AS DIVISION_ID
				--				,D.ITEM_ID
				--				,D.FROM_SITE
				--				,D.TO_SITE
				--				,D.NEW_YYYYMMDD AS YYYYMMDD
				--				,ISNULL(D.NEW_QTY,0) AS QTY
				--				,D.NEW_BOD_ID
				--				,D.NEW_ROUTE_ID
				--				,NULL   AS OPERATION_GROUP
				--				,D.BIZ_TYPE
				--				,D.PROJECT_CODE
				--				,D.FCST_TYPE
				--				,D.NEW_ETD_DATE     AS FCST_ETD_DATE
				--				,D.NEW_ETA_DATE     AS FCST_ETA_DATE
				--				,D.NEW_ETD_DATE
				--				,D.NEW_ETA_DATE

				--				,D.NEW_INCOTERMS      AS INCOTERMS
				--				,D.NEW_TRANSPORT_MODE AS TRANSPORT_MODE
				--				,D.NEW_D_COUNTRY
				--				,D.NEW_D_PORT_CODE
				--				,D.NEW_A_COUNTRY
				--				,D.NEW_A_PORT_CODE
				--				,D.NEW_CUSTOMER_LT
				--				,D.NEW_TO_COUNTRY
				--				,D.NEW_TO_CITY
				--				,D.FROM_SITE_TYPE
				--				,D.FROM_SITE_PLANT_ID
				--				,D.FROM_SITE_VENDOR_ID
				--				,D.FROM_SITE_SOLDTO_CODE
				--				,D.FROM_SITE_SHIPTO_CODE
				--				,D.FROM_SITE_COMPANY_ID
				--				,D.TO_SITE_TYPE
				--				,D.TO_SITE_PLANT_ID
				--				,D.TO_SITE_VENDOR_ID
				--				,D.TO_SITE_SOLDTO_CODE
				--				,D.TO_SITE_SHIPTO_CODE
				--				,D.TO_SITE_COMPANY_ID
				--				-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
				--				,D.REMARKS2  AS BUILDING
				--				,D.REMARKS   AS REMARK
				--				,D.REMARKS3  AS CUSTOMER_REQ
				--				,CASE WHEN R.CHANGE_REASON_CODE = 'Select' THEN NULL ELSE R.CHANGE_REASON_CODE END AS  CHANGE_CODE
				--				,C.SEGMENT3  AS CHANGE_CODE_NAME
				--				,ISNULL(D.REQUESTOR,R.REQUEST_USER ) AS REQUESTOR
				--				,D.CREATED_BY
				--				,D.CREATION_DATE
				--				,D.LAST_UPDATED_BY
				--				,D.LAST_UPDATE_DATE
				--				,D.ORIGIN_TO_DIVISION_ID
				--				/*----------------------------------------------------------------------------------------
				--					2020.06.30 : KBK
				--					I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
				--				------------------------------------------------------------------------------------------*/
				--				,D.PACKAGE_TYPE
				--				,D.FACTORY_ID
				--				,D.PACKAGE_QTY
				--				,D.DOM_EXP
				--				,D.ERP_ATTR1
				--				,D.ERP_ATTR2
				--				,D.ERP_ATTR3
				--				,D.ERP_ATTR4
				--				,D.ERP_ATTR5
				--				,D.NEW_YN
				--		FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ R    WITH(NOLOCK) 
				--			  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
				--		                   ON C.LOOKUP_TYPE = 'CHANGE_REASON_CODE'
				--		                  AND C.SEGMENT1 = R.CHANGE_REASON_CODE
				--		,     SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
				--			 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) -- SALES_COMPANY_ID 추출용
				--					ON L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO' 
				--					AND L.VALID_YN   = 'Y'
				--					AND L.SEGMENT2   = D.ORIGIN_FROM_DIVISION_ID 
				--					AND L.SEGMENT3   = D.FROM_SITE
				--					AND L.SEGMENT5   = D.ORIGIN_TO_DIVISION_ID 
				--					AND L.ATTRIBUTE1 = D.TO_SITE 
				--			 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK) 
				--			 ON   B.LOOKUP_TYPE = 'CELL_SHIP_FROM_TO' 
				--			 AND  B.VALID_YN   = 'Y'
				--			 AND  B.SEGMENT1 = D.FROM_SITE_COMPANY_ID 
				--			 AND  B.SEGMENT3 = D.FROM_SITE
				--			 AND  B.SEGMENT4 = D.TO_SITE_COMPANY_ID 
				--			 AND  B.SEGMENT5 = D.TO_SITE 
				--		WHERE R.CHANGE_REQ_NO = D.CHANGE_REQ_NO
				--		AND   R.CHANGE_REQ_NO = @p_change_req_no  
				--		--AND   D.CONFIRM_ID    = @P_confirm_id
				--		AND   ISNULL(D.VALID_YN , 'N')= 'Y' 
				--) X
				---- 2020-08-24 11:19:51
				---- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
				---- 2020-08-24  kimbl1
				--LEFT OUTER JOIN SCM_MST_SITE FS  WITH(NOLOCK)
				--			ON  FS.DIVISION_ID = X.DIVISION_ID 
				--			AND FS.SCM_SITE_ID = X.FROM_SITE 
				--			AND FS.VALID_YN    = 'Y' 
				--LEFT OUTER JOIN SCM_MST_SITE TS  WITH(NOLOCK)
				--			ON  TS.DIVISION_ID = X.DIVISION_ID 
				--			AND TS.SCM_SITE_ID = X.TO_SITE 
				--			AND TS.VALID_YN    = 'Y' 
				--WHERE 1 = 1
				--;

					INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
					   IF_SEQ           
					 , IF_TYPE          
					 , IF_ID            
					 , IF_INS_DATE      
					 , IF_FLAG          
					 , PACKER_CODE      
					 , DIVISION_ID      
					 , PLAN_VERSION   
					 , PACK_MODEL_CODE  
					 , NICK_NAME 
					 , TARGET_ORDER
					 , SSP_CNFM
					 , SALES_SITE
					 , SHIP_TO
					 , SHIP_TO_NAME
					 , TRANSPORT_MODE
					 , INCOTERMS
					 , SHIP_PLAN_DATE 
					 , SHIP_PLAN_QTY 
					 , COMMENT
					 , ATTR_01           
					 , ATTR_02           
					 , ATTR_03           
					 , ATTR_04           
					 , ATTR_05           
					 , ATTR_06           
					 , ATTR_07           
					 , ATTR_08           
					 , ATTR_09           
					 , ATTR_10 
					 , ORDER_TYPE_DETAIL
					 )
				SELECT
					 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
					, N'I'         AS IF_TYPE          
					, N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
					, GETDATE()    AS IF_INS_DATE      
					, 'N'          AS IF_FLAG          
					, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE) AS PACKER_CODE        
					, A.DIVISION_ID      
					, A.PLAN_VERSION   
					, A.PACK_MODEL_CODE  
					, A.NICK_NAME 
					, N'O'          AS TARGET_ORDER
					, A.SSP_CNFM
					, A.SALES_SITE
					, A.SHIP_TO
					, A.SHIP_TO_NAME
					, A.TRANSPORT_MODE
					, A.INCOTERMS
					, A.SHIP_PLAN_DATE 
				/***  20211102  SMS  수정 *********************************/
					--, A.QTY         AS SHIP_PLAN_QTY 
					, A.SHIP_PLAN_QTY 
					--, NULL								AS COMMENT
					, A.COMMENT
				/*************************************************************/
					, A.ATTR_01           
					, NULL								AS ATTR_02    
					/* 20211102  SMS  수정  ****************************************************/      
					--, NULL								AS ATTR_03    
					,A.ATTR_03      --Model PIC   				
					--, NULL								AS ATTR_04           
					, A.ATTR_04		--MTK_OWNER       
				/****************************************************************************************************/					        
					, NULL								AS ATTR_05           
					, NULL								AS ATTR_06           
					, NULL								AS ATTR_07           
					, NULL								AS ATTR_08           
					, NULL								AS ATTR_09           
					, A.ATTR_10
				/*** 20211102  SMS  수정   ***************************************************/
--					 , '-'				AS ORDER_TYPE_DETAIL
					, A.FCST_TYPE       --ORDER_TYPE_DETAIL
				/*****************************************************************************/
				FROM
				(
					SELECT
						   A.FROM_SITE  AS PACKER_CODE      
						 , A.DIVISION_ID AS DIVISION_ID      
						 , CONVERT(VARCHAR(8), CONVERT(DATETIME, getdate()), 112)    AS PLAN_VERSION   
						 , A.ITEM_ID    AS PACK_MODEL_CODE  
						 , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID)  AS NICK_NAME 
						 , A.CONFIRM_ID			 AS SSP_CNFM
						 , A.TO_SITE     AS SALES_SITE
						 , A.TO_SITE_SHIPTO_CODE AS SHIP_TO
						-- , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
						 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
						 , A.NEW_TRANSPORT_MODE	AS TRANSPORT_MODE
						 , A.NEW_INCOTERMS		AS	INCOTERMS
						 , A.NEW_YYYYMMDD    AS SHIP_PLAN_DATE 
						/***  20211102  SMS  수정 *********************************/
						 --, A.QTY         AS SHIP_PLAN_QTY 
						 , ISNULL(A.NEW_QTY,0)         AS SHIP_PLAN_QTY 
						 --, NULL								AS COMMENT
						 , ISNULL(A.REMARKS, NULL)			AS COMMENT
						/*************************************************************/
						 , A.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
						 , NULL								AS ATTR_02    
						 /* 20211102  SMS  수정  ****************************************************/      
						 --, NULL								AS ATTR_03    
						 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   				
						 --, NULL								AS ATTR_04           
						 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER       
						/****************************************************************************************************/	
						 , A.CONFIRM_ID						AS ATTR_10
						/*** 20211102  SMS  수정   ***************************************************/
	--					 , '-'				AS ORDER_TYPE_DETAIL
						 , ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS FCST_TYPE       --ORDER_TYPE_DETAIL
						/*****************************************************************************/
					FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE A WITH(NOLOCK)
					/***20211102  SMS  추가   *******************************/
						 LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 							FROM(																						
 								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									
 								  ,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num	
 							FROM scm_mst_site_item																				
 						 ) a WHERE num = 1) g on g.DIVISION_ID =  (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID	
						 LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
					  ON A.DIVISION_ID					= SI.DIVISION_ID
					 AND A.TO_SITE						= SI.SCM_SITE_ID
					 AND A.ITEM_ID						= SI.ITEM_ID
					 AND G.PROJECT_CODE					= SI.PROJECT_CODE
						 LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
					  ON A.DIVISION_ID = MU.DIVISION_ID
					 AND A.FROM_SITE = MU.FROM_SITE
					 AND A.ITEM_ID = MU.ITEM_ID
					 AND MU.VALID_YN = 'Y'
						 LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
					  ON mu.user_id = u2.UserID 
	   				 AND U2.UseYN = 'Y'
						 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
					  ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
					 AND LK.VALID_YN	= 'Y'
					 AND A.FCST_TYPE	= LK.SEGMENT1
						 --LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE AS P WITH(NOLOCK)
				   --   ON P.CHANGE_REQ_NO = @p_change_req_no
					/***************************************************************/
					WHERE  1 = 1
					 AND A.CHANGE_REQ_NO = @p_change_req_no  --'R20211001051809'
				) A 
				LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
				 ;	
	
				--	INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
				--	   IF_SEQ           
				--	 , IF_TYPE          
				--	 , IF_ID            
				--	 , IF_INS_DATE      
				--	 , IF_FLAG          
				--	 , PACKER_CODE      
				--	 , DIVISION_ID      
				--	 , PLAN_VERSION   
				--	 , PACK_MODEL_CODE  
				--	 , NICK_NAME 
				--	 , TARGET_ORDER
				--	 , SSP_CNFM
				--	 , SALES_SITE
				--	 , SHIP_TO
				--	 , SHIP_TO_NAME
				--	 , TRANSPORT_MODE
				--	 , INCOTERMS
				--	 , SHIP_PLAN_DATE 
				--	 , SHIP_PLAN_QTY 
				--	 , COMMENT
				--	 , ATTR_01           
				--	 , ATTR_02           
				--	 , ATTR_03           
				--	 , ATTR_04           
				--	 , ATTR_05           
				--	 , ATTR_06           
				--	 , ATTR_07           
				--	 , ATTR_08           
				--	 , ATTR_09           
				--	 , ATTR_10 
				--	 , ORDER_TYPE_DETAIL
				--	 )
				--SELECT 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
				--	 , N'I'         AS IF_TYPE          
				--	 , N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
				--	 , GETDATE()    AS IF_INS_DATE      
				--	 , 'N'          AS IF_FLAG          
				--	 , A.FROM_SITE  AS PACKER_CODE      
				--	 , A.DIVISION_ID AS DIVISION_ID      
				--	 , CONVERT(VARCHAR(8), CONVERT(DATETIME, getdate()), 112)    AS PLAN_VERSION   
				--	 , A.ITEM_ID    AS PACK_MODEL_CODE  
				--	 , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID)  AS NICK_NAME 
				--	 , N'O'          AS TARGET_ORDER
				--	 , A.CONFIRM_ID			 AS SSP_CNFM
				--	 , A.TO_SITE     AS SALES_SITE
				--	 , A.TO_SITE_SHIPTO_CODE AS SHIP_TO
				--	-- , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
				--	 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
				--	 , A.TRANSPORT_MODE
				--	 , A.INCOTERMS
				--	 , A.YYYYMMDD    AS SHIP_PLAN_DATE 
				--	 , A.QTY         AS SHIP_PLAN_QTY 
				--	 , NULL								AS COMMENT
				--	 , A.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
				--	 , NULL								AS ATTR_02           
				--	 , NULL								AS ATTR_03           
				--	 , NULL								AS ATTR_04           
				--	 , NULL								AS ATTR_05           
				--	 , NULL								AS ATTR_06           
				--	 , NULL								AS ATTR_07           
				--	 , NULL								AS ATTR_08           
				--	 , NULL								AS ATTR_09           
				--	 , A.CONFIRM_ID						AS ATTR_10
				--	 , '-'				AS ORDER_TYPE_DETAIL
				--FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
				--WHERE  1 = 1
				-- AND CONFIRM_ID IN (SELECT CONFIRM_ID  FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WHERE CHANGE_REQ_NO = @p_change_req_no)  --'R20211001051809'
				-- ;


		    END
        -- D: 변경 Reject
		ELSE IF @p_change_type = 'D'   -- ATTRIBUTE1 = 'Y'인

		   BEGIN
				
               -- D일경우 ATTRIBUTE1DMF N으로 원복 해줌( 삭제대상 )
			   UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 
			   SET    ATTRIBUTE1 = 'N'
			   WHERE  CHANGE_REQ_NO = @p_change_req_no 
			   AND    ISNULL(ATTRIBUTE1,'N') = 'Y'
			   ;

		   END 


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
