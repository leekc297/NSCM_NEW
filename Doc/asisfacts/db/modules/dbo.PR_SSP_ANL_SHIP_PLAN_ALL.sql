
/***************************************************************************************************
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_ALL
 * Description  : PLAN ALL
 * OutTable     : SSP_ANL_SHIP_PLAN_ALL
 * Execute      : EXEC PR_SSP_ANL_SHIP_PLAN_ALL
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.03.17   SSP Pjt.       Create
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
****************************************************************************************************/

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_PLAN_ALL]
(
	@p_plan_start_yyyymmdd         NVARCHAR(8)
)
AS
BEGIN


    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;
	SET ANSI_NULLS ON;
	SET ANSI_WARNINGS ON;

	-- LOG 용 변수 설정
    DECLARE @v_batch_user			NVARCHAR(150) = N'SCS_BATCH';
    DECLARE @v_program_name			NVARCHAR(150) = N'PR_SSP_ANL_SHIP_PLAN_ALL';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);      --상세설명
    DECLARE @v_table_id				NVARCHAR(150) = N'SSP_ANL_SHIP_PLAN_ALL'; --테이블 필수
    DECLARE @d_event_date			DATETIME;
    DECLARE @v_insert_cnt			INTEGER = 0;
	DECLARE @v_insert_sum			INTEGER = 0;

	DECLARE @p_language				nvarchar(10) = 'KO';
	DECLARE @v_msp_check            nvarchar(3) = '-';
	DECLARE @v_wsp_check            nvarchar(3) = '-';
	DECLARE @v_from_yyyymmdd        nvarchar(8);
	DECLARE @v_to_yyyymmdd          nvarchar(8);
	DECLARE @v_plan_start_yyyymmdd  nvarchar(8);

	DECLARE @INX					INT					= 0;
    DECLARE @MAX_NUM				INT					= 0;

	DECLARE @TAB   TABLE
	(
	    TID							INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	    EE_YN						NVARCHAR(1),
		DIVISION_ID                 NVARCHAR(10),
		COMPANY_ID                  NVARCHAR(10)
	)

	DECLARE @EE_YN					NVARCHAR(1);
	DECLARE @DIVISION_ID            NVARCHAR(10);
	DECLARE @ORG_DIVISION_ID        NVARCHAR(10);
	DECLARE @COMPANY_ID             NVARCHAR(10);
	DECLARE @COUNT_CHECK            INT;

	IF @p_plan_start_yyyymmdd IS NULL OR @p_plan_start_yyyymmdd = ''
	BEGIN
		SET @v_plan_start_yyyymmdd = convert(nvarchar, getdate() - 1, 112);
	END
	ELSE
	BEGIN
		SET @v_plan_start_yyyymmdd = @p_plan_start_yyyymmdd;
	END

	SELECT @v_msp_check = CASE WHEN COUNT(*) > 0 THEN MIN(BASIS_YYYYMM) ELSE '-' END
      FROM SCM_SYS_CALENDAR_M C WITH(NOLOCK) 
     WHERE C.ISO_YYYYWW = (SELECT MIN(ISO_YYYYWW)  AS ISO_YYYYWW
						     FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK) 
						    WHERE BASIS_YYYYMMDD >=  @v_plan_start_yyyymmdd
							  AND BASIS_YYYYMMDD < CONVERT(VARCHAR, DATEADD(D, 7, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) 
					      )
       AND DATE_SHORT2_NAME = '1'

	SELECT @v_wsp_check = CASE WHEN C.BASIS_YYYYMMDD = @v_plan_start_yyyymmdd THEN ISO_YYYYWW ELSE '-' END
      FROM SCM_SYS_CALENDAR_M C WITH(NOLOCK) 
     WHERE C.ISO_YYYYWW = (SELECT MIN(ISO_YYYYWW)  AS ISO_YYYYWW
						     FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK) 
						    WHERE BASIS_YYYYMMDD >=  @v_plan_start_yyyymmdd
							  AND BASIS_YYYYMMDD < CONVERT(VARCHAR, DATEADD(D, 7, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) 
						  )
       AND C.DAYOFWEEK = 'MON' 


    INSERT INTO @TAB
	           (EE_YN		
			   ,DIVISION_ID 
			   ,COMPANY_ID  
			   )
         select x.segment1
               ,x.segment2
               ,x.segment3
           from SCM_ADM_LOOKUP_MASTER_DETAIL as X with(nolock) 
                left outer join SCM_ADM_LOOKUP_MASTER_DETAIL as Y with(nolock) 
             on x.lookup_type = y.lookup_type
            and x.segment1 = y.segment1
            and x.segment2 = y.segment2
            and x.segment3 = y.segment3
            and y.VALID_YN = 'Y'
          where 1=1
            and x.lookup_type = 'SSP_ANL_SHIP_PLAN_ALL'
			and x.VALID_YN = 'Y'
            and y.attribute1 != @v_plan_start_yyyymmdd
	   order by x.display_seq
	   ;

    SELECT @INX			= 1
          ,@MAX_NUM		= COUNT(*)
      FROM @TAB
	  
	IF @MAX_NUM = 0
	BEGIN
		RETURN 0;
	END
	-----------------------------------------------------------
	-- START LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'START';
    SET @v_log_message	= N'########## Start of procedure ##########';
    SET @v_description	= @v_program_name + ':' + N' PR_SSP_ANL_SHIP_PLAN_ALL INSERT LOGIC';
    SET @d_event_date	= SYSDATETIME();

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count
                              ,@p_log_message   = @v_log_message
                              ,@p_description   = @v_description
                              ,@p_event_date    = @d_event_date
                              ,@p_user_id       = @v_batch_user
    ;

    WHILE @INX <= @MAX_NUM
    BEGIN
		BEGIN TRY


            SELECT @EE_YN			= T.EE_YN		
		          ,@DIVISION_ID     = T.DIVISION_ID
				  ,@COMPANY_ID 		= T.COMPANY_ID 
				  ,@ORG_DIVISION_ID = D.attribute3
              FROM @TAB AS T 
			       JOIN scm_mst_division AS D with(nolock)
				ON T.division_id    = D.division_id
             WHERE TID				= @INX


			IF @ORG_DIVISION_ID = '40' AND @EE_YN = N'N'
			BEGIN

				SELECT @COUNT_CHECK = COUNT(A.PLAN_START_YYYYMMDD)
				  FROM DBO.SSP_ANL_SHIP_PLAN_40  A WITH(NOLOCK)
					   INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
					ON A.DIVISION_ID = MS.DIVISION_ID
				   AND A.FROM_SITE = MS.SCM_SITE_ID
				   AND MS.SITE_TYPE = 'PLANT'
				   --AND A.DIVISION_ID = @DIVISION_ID
				   AND MS.OPERATION_GROUP IN ('A', 'P')
				 WHERE A.DIVISION_ID = @DIVISION_ID
				   AND A.PLAN_START_YYYYMMDD = CONVERT(VARCHAR, DATEADD(D, 1, CONVERT(DATETIME, @v_plan_start_yyyymmdd, 112)) ,112)
				   AND A.PLAN_TYPE ='SP'
				   AND A.SEQ = 1
				   AND A.MEASURE = 'SHIP_CONFIRM'
				   AND MS.COMPANY_ID = @COMPANY_ID

				IF @COUNT_CHECK > 0 
				BEGIN

					SET @v_from_yyyymmdd = @v_plan_start_yyyymmdd ; 
					SET @v_to_yyyymmdd = CONVERT(VARCHAR, DATEADD(D, 83, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ;

					INSERT INTO SSP_ANL_SHIP_PLAN_ALL (
								DIVISION_ID,			PLAN_START_YYYYMMDD,		PLAN_TYPE,				SEQ,					COMPANY_ID,				OPERATION_GROUP,
								ERP_SO_NO,				SHIPMENT_STATUS,			ITEM_ID,
								NICK_NAME,				FROM_SITE_DESCRIPTION,		TO_SITE_DESCRIPTION,	PROJECT_CODE,			PROJECT_NAME,
								END_CUSTOMER,			MTK_OWNER,
								REQUESTOR,				SHIPMENT_CONFIRM_QTY,		YYYYMMDD,
								TRANSPORT_MODE,			REMARKS2,					REMARKS,				CHANGE_REASON_CODE,		CHANGE_REASON_DETAIL,
								REMARKS3,				TO_SITE_SOLDTO_CODE,		SOLDTO_DESCRIPTION,		TO_SITE_SHIPTO_CODE,	SHIPTO_DESCRIPTION,
								INCOTERMS,				LT_DAY,						ETD,					ETA,					Expected_Shipping_Date,
								FCST_TYPE,				UPDATED_BY,					UPDATED_DATE,			CHANGE_REQ_NO,			CHECK_NEED_YN,
								MODEL_USER,				CONFIRM_ID,					FROM_SITE,				TO_SITE,ERP_STATUS,		BOD_ID,
								CHANGE_TYPE,			EDIT_REMARKS,				EDIT_MAIN,				ELECTRODE_YN,			ELECTRODE_TYPE,
								ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,      
								MSP,					    WSP
						 )
						 SELECT
								DIVISION_ID,			@v_plan_start_yyyymmdd,		'SP',					1,						COMPANY_ID,				OPERATION_GROUP,
								ERP_SO_NO,				SHIPMENT_STATUS,			ITEM_ID,
								NICK_NAME,				FROM_SITE_DESCRIPTION,		TO_SITE_DESCRIPTION,	PROJECT_CODE,			PROJECT_NAME,
								END_CUSTOMER,			MTK_OWNER,
								REQUESTOR,				SHIPMENT_CONFIRM_QTY,		SHIPMENT_DATE AS YYYYMMDD,
								TRANSPORT_MODE,			REMARKS2,					REMARKS,				CHANGE_REASON_CODE,		CHANGE_REASON_DETAIL,
								REMARKS3,				TO_SITE_SOLDTO_CODE,		SOLDTO_DESCRIPTION,		TO_SITE_SHIPTO_CODE,	SHIPTO_DESCRIPTION,
								INCOTERMS,				LT_DAY,						ETD,					ETA,					Expected_Shipping_Date,
								FCST_TYPE,				UPDATED_BY,					UPDATED_DATE,			CHANGE_REQ_NO,			CHECK_NEED_YN,
								MODEL_USER,				CONFIRM_ID,					FROM_SITE,				TO_SITE,ERP_STATUS,		BOD_ID,
								CHANGE_TYPE,			EDIT_REMARKS,				EDIT_MAIN,				ELECTRODE_YN,			ELECTRODE_TYPE,
								ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,		
								@v_msp_check,           @v_wsp_check
						   FROM (
								SELECT
					       			   a.division_id
					       			  ,a.from_site_company_id as company_id
									  ,ms.operation_group
					       			  ,a.erp_so_no
					       			  ,a.shipment_status
					       			  ,a.project_code
					       			  ,[dbo].[FN_GET_PROJECT_NAME]((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end) ,a.project_code) project_name
					       			  ,a.fcst_type
					       			  ,a.item_id
					       			  ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
									  ,a.yyyymmdd AS shipment_date
					       			  ,a.before_qty AS before_qty
					       			  ,convert(int, a.qty) AS shipment_confirm_qty
					       			  ,a.remarks
					       			  ,a.remarks2
					       			  ,a.remarks3
					       			  ,a.from_site
					       			  ,isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') AS from_site_description
					       			  ,a.to_site
					       			  ,isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),'-') as to_site_description
					       			  ,a.TO_SITE_SOLDTO_CODE
					       			  ,a.TO_SITE_SHIPTO_CODE
					       			  ,dbo.fn_get_site_customer_info((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
					       			  ,dbo.fn_get_site_customer_info((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
					       			  ,a.bod_id
					       			  ,b.ssp_incoterms  AS INCOTERMS
					       			  ,b.transport_mode
					       			  ,b.lt_total AS lt_day
					       			  ,a.ETD_DATE AS etd
					       			  ,a.ETA_DATE AS eta
					       			  ,CASE WHEN b.transport_mode = 'TRK' then '-' else [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, a.BOD_ID, a.YYYYMMDD) end as Expected_Shipping_Date
					       			  ,a.confirm_id
					       			  ,CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' updated_by
					       			  ,case when u.UserName is not null then a.LAST_UPDATE_DATE else null end updated_date
					       			  ,a.erp_status
					       			  ,a.change_type
					       			  ,a.route_id NEW_ROUTE_ID, a.bod_id NEW_BOD_ID, b.ssp_incoterms NEW_INCOTERMS, a.d_country NEW_D_COUNTRY, a.d_port_code NEW_D_PORT_CODE, a.a_country NEW_A_COUNTRY, a.a_port_code NEW_A_PORT_CODE
					       			  ,a.customer_lt NEW_CUSTOMER_LT, a.to_country NEW_TO_COUNTRY, a.to_city NEW_TO_CITY, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) NEW_ETA, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) NEW_ETD, b.lt_total NEW_LT_DAY, b.transport_mode NEW_TRANSPORT_MODE , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) NEW_SHIPMENT_DATE
					       			  ,'N' EDIT_REMARKS, 'N' EDIT_MAIN, isnull(a.CHECK_NEED_YN,'N') CHECK_NEED_YN
					       			  ,isnull(case when a.DIVISION_ID = '40' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != '-' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = 'EE' and a.ORIGIN_TO_DIVISION_ID = '40' then g.project_code else f.END_CUSTOMER end,'-') end_customer
					       			  ,a.ELECTRODE_YN, a.ELECTRODE_TYPE, a.ORIGIN_FROM_DIVISION_ID, a.ORIGIN_TO_DIVISION_ID, null AS CHANGE_REQ_NO--h.CHANGE_REQ_NO
					       			  ,CASE WHEN @p_language  = 'KO' THEN U2.UserName ELSE U2.UserName_E END + '(' + mu.user_id + ')' model_user
					       			  ,DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, ',', ''+@p_language+'') AS MTK_OWNER
					       			  ,CASE WHEN @p_language = 'KO' THEN U3.UserName ELSE U3.UserName_E END + '(' + a.requestor + ')' requestor
					       			  ,'-' AS CHANGE_REASON_CODE
					       			  ,'' AS CHANGE_REASON_DETAIL
								  FROM SSP_ANL_SHIP_CONFIRM  a WITH(NOLOCK)
									   INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
									ON A.DIVISION_ID = MS.DIVISION_ID
								   AND A.FROM_SITE = MS.SCM_SITE_ID
								   AND MS.SITE_TYPE = 'PLANT'
								   --AND A.DIVISION_ID = @DIVISION_ID
								   AND MS.OPERATION_GROUP IN ('A', 'P')
									   INNER JOIN  scp_mst_bod_n_v b ON (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id
									   LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'
									   LEFT OUTER JOIN SCM_MST_SITE f WITH(NOLOCK) ON f.division_id = a.ORIGIN_TO_DIVISION_ID and f.SCM_SITE_ID = a.to_site
									   LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
														  FROM (
															   SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num
																 FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
															   ) A
					       						   WHERE NUM = 1) G
									ON G.DIVISION_ID = (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID
									--   LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO
									--                   FROM (
									--                           SELECT CONFIRM_ID, CHANGE_REQ_NO,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM
									--                             FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)
									--                            WHERE VALID_YN = 'Y'
									--                           ) A
					       			--			   WHERE NUM = 1) H
									--ON H.CONFIRM_ID = A.CONFIRM_ID
									   LEFT OUTER JOIN SSP_MST_MODEL_USER mu WITH(NOLOCK) on mu.division_id = a.origin_from_division_id and mu.from_site = a.from_site and mu.item_id = a.item_id and mu.valid_yn = 'Y'
									   LEFT OUTER JOIN TB_FX_User U2 WITH(NOLOCK) ON mu.user_id = u2.UserID AND U2.UseYN = 'Y'
									   LEFT OUTER JOIN TB_FX_User U3 WITH(NOLOCK) ON a.requestor = u3.UserID AND U3.UseYN = 'Y'
									   LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK)
									ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID ='EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)
								   AND SI.SCM_SITE_ID  = A.TO_SITE
								   AND SI.ITEM_ID  = A.ITEM_ID
								   AND SI.PROJECT_CODE  = A.PROJECT_CODE
									--   LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 WITH(NOLOCK)
									--ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO
								 WHERE 1=1
								   AND yyyymmdd >= @v_from_yyyymmdd AND yyyymmdd <= @v_to_yyyymmdd
								   AND a.division_id  = @DIVISION_ID
								   AND a.from_site_company_id IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@COMPANY_ID,',') ) 
								   AND (a.SHIPMENT_STATUS IS NOT NULL AND ISNULL(a.SHIPMENT_STATUS,'') != '')
								   AND a.qty > 0
								   AND a.change_type <> 'N'
								   AND a.biz_type <> 'E'

							 UNION ALL

							SELECT
								   DIVISION_ID
								  ,COMPANY_ID
								  ,OPERATION_GROUP
								  ,ERP_SO_NO
								  ,SHIPMENT_STATUS
								  ,PROJECT_CODE
								  ,PROJECT_NAME
								  ,FCST_TYPE
								  ,ITEM_ID
								  ,NICK_NAME
								  ,shipment_date
								  ,0 AS BEFORE_qty
								  ,QTY
								  ,REMARKS
								  ,REMARKS2
								  ,REMARKS3
								  ,FROM_SITE
								  ,FROM_SITE_DESCRIPTION
								  ,TO_SITE
								  ,TO_SITE_DESCRIPTION
								  ,TO_SITE_SOLDTO_CODE
								  ,TO_SITE_SHIPTO_CODE
								  ,SOLDTO_DESCRIPTION
								  ,SHIPTO_DESCRIPTION
								  ,BOD_ID
								  ,INCOTERMS
								  ,TRANSPORT_MODE
								  ,LT_TOTAL
								  ,ETD
								  ,ETA
								  ,EXPECTED_SHIPPING_DATE
								  ,CONFIRM_ID
								  ,LAST_UPDATED_BY
								  ,LAST_UPDATE_DATE
								  ,'-' AS ERP_STATUS
								  ,'-' AS change_type
								  ,'-' AS NEW_ROUTE_ID
								  ,'-' AS NEW_BOD_ID
								  ,'-' AS NEW_INCOTERMS
								  ,'-' AS NEW_D_COUNTRY
								  ,'-' AS NEW_D_PORT_CODE
								  ,'-' AS NEW_A_COUNTRY
								  ,'-' AS NEW_A_PORT_CODE
								  ,'-' AS NEW_CUSTOMER_LT
								  ,'-' AS NEW_TO_COUNTRY
								  ,'-' AS NEW_TO_CITY
								  ,'-' AS NEW_ETA
								  ,'-' AS NEW_ETD
								  ,'-' AS NEW_LT_DAY
								  ,'-' AS NEW_TRANSPORT_MODE
								  ,'-' AS NEW_SHIPMENT_DATE
								  ,'-' AS EDIT_REMARKS
								  ,'-' AS EDIT_MAIN
								  ,'-' AS CHECK_NEED_YN
								  ,'-' AS END_CUSTOMER
								  ,'-' AS ELECTRODE_YN
								  ,'-' AS ELECTRODE_TYPE
								  ,'-' AS ORIGIN_FROM_DIVISION_ID
								  ,'-' AS ORIGIN_TO_DIVISION_ID
								  ,'-' AS CHANGE_REQ_NO
								  ,'-' AS MODEL_USER
								  ,'-' AS MTK_OWNER
								  ,'-' AS REQUESTOR
								  ,'-' AS CHANGE_REASON_CODE
								  ,'-' AS CHANGE_REASON_DETAIL
							 FROM (
								  SELECT
										 tt0.DIVISION_ID
										,tt2.company_id
										,tt2.operation_group
										,NULL AS ERP_SO_NO
										,'P' AS SHIPMENT_STATUS
										,tt0. ITEM_ID
										,dbo.fn_get_item_nickname(tt0.division_id , tt0.item_id ) AS NICK_NAME
										,tt0.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
										,tt0.DIVISION_ID AS ORIGIN_TO_DIVISION_ID
										,tt0.PLANT_SITE_ID AS FROM_SITE
										,isnull(dbo.fn_get_scm_site_description(tt0.division_id, tt0.PLANT_SITE_ID ),'-') AS from_site_description
										,tt0.SCM_SITE_ID AS TO_SITE
										,isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (tt0.division_id , tt0.SCM_SITE_ID ),'-') as to_site_description
										,tt0.PROJECT_CODE
										,[dbo].[FN_GET_PROJECT_NAME]( tt0.division_id ,tt0.project_code) AS  PROJECT_NAME
										,'-' AS REQUESTOR
										,tt0.QTY
										,tt0.YYYYMMDD   as shipment_date
										,tt0.BOD_ID
										,tt0.INCOTERMS
										,tt0.TRANSPORT_MODE
										,dbo.fn_get_site_customer_info(tt0.division_id, tt0.SCM_SITE_ID, 'SOLDTO_CODE' ) AS TO_SITE_SOLDTO_CODE
										,dbo.fn_get_site_customer_info(tt0.division_id, tt0.SCM_SITE_ID, 'SHIPTO_CODE' ) AS TO_SITE_SHIPTO_CODE
										,dbo.fn_get_site_customer_info(tt0.division_id, tt0.SCM_SITE_ID, 'SOLDTO_DESCRIPTION' ) AS soldto_description
										,dbo.fn_get_site_customer_info(tt0.division_id, tt0.SCM_SITE_ID, 'SHIPTO_DESCRIPTION' ) AS shipto_description
										,'-' AS REMARKS2
										,'-' AS REMARKS
										,'-' AS CHANGE_REQ_NO
										,'-' AS REMARKS3
										,tt0.YYYYMMDD  AS etd
										,[dbo].[FN_GET_SSP_ETA_DATE](tt0.DIVISION_ID, tt0.BOD_ID, tt0.YYYYMMDD) AS eta
										,CASE WHEN tt0.transport_mode = 'TRK' then '-' else [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](tt0.DIVISION_ID, tt0.BOD_ID, tt0.YYYYMMDD) end as Expected_Shipping_Date
										,tt1.lt_total
										,tt0.LAST_UPDATED_BY
										,tt0.LAST_UPDATE_DATE
										,'-' AS CONFIRM_ID
										,tt0.FCST_TYPE
										,CASE WHEN isnull(tt2.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(tt2.ship_frozen,0), CONVERT(VARCHAR, @v_plan_start_yyyymmdd, 121)), 112) ELSE  @v_plan_start_yyyymmdd  END AS frozen_yyyymmdd
								   FROM DM_PLN_SHIPMENT_REQ tt0 WITH(NOLOCK)
										INNER JOIN  scp_mst_bod_n_v tt1 WITH(NOLOCK) ON tt0.DIVISION_ID = tt1.division_id  AND tt0.bod_id = tt1.bod_id
										INNER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)
									 ON tt0.DIVISION_ID = tt2.DIVISION_ID
									AND tt0.PLANT_SITE_ID = tt2.SCM_SITE_ID
									AND tt2.site_type		= 'PLANT'
									AND tt2.valid_yn		= 'Y'
										LEFT OUTER JOIN SSP_MST_MODEL_USER MU WITH(NOLOCK) ON MU.DIVISION_ID = tt0.DIVISION_ID AND MU.FROM_SITE = TT0.PLANT_SITE_ID AND MU.ITEM_ID = TT0.ITEM_ID AND MU.VALID_YN = 'Y'
										LEFT OUTER JOIN TB_FX_User U2 WITH(NOLOCK) ON mu.user_id = u2.UserID AND U2.UseYN = 'Y'
								  WHERE 1 = 1
									AND tt0.DIVISION_ID = @DIVISION_ID
									AND tt2.company_id IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@COMPANY_ID,',') ) 
								  ) t
							WHERE 1 = 1
							  AND t.shipment_date >= t.frozen_yyyymmdd
							  AND t.shipment_date <= @v_to_yyyymmdd
								) AS  AA
					ORDER BY AA.division_id, AA.shipment_status, AA.shipment_date,  AA.item_id, AA.ERP_SO_NO DESC , AA.from_site, AA.to_site, AA.project_code, AA.fcst_type

				END
			END
			ELSE IF @ORG_DIVISION_ID IN ('81', '82') and @EE_YN = N'N'
			BEGIN

				SELECT @COUNT_CHECK = COUNT(PLAN_START_YYYYMMDD)
				  FROM SSP_MST_SHIP_PLAN_SCHEDULE WITH(NOLOCK)
				WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				  AND PLAN_CUTOFF_CREATE_YN = 'Y'
				  AND COMPANY_ID = @COMPANY_ID

				IF @COUNT_CHECK > 0
				BEGIN

					SET @v_from_yyyymmdd = @v_plan_start_yyyymmdd;
					SET @v_to_yyyymmdd = CONVERT(VARCHAR, DATEADD(D, 55, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ;


					INSERT INTO SSP_ANL_SHIP_PLAN_ALL (
								DIVISION_ID,		PLAN_START_YYYYMMDD,	PLAN_TYPE,			SEQ,					COMPANY_ID,			OPERATION_GROUP,
								ERP_SO_NO,			SHIPMENT_STATUS,		ITEM_ID,NICK_NAME,
								FROM_SITE_DESCRIPTION,						TO_SITE_DESCRIPTION,
								PROJECT_CODE,		PROJECT_NAME,			END_CUSTOMER,		MTK_OWNER,				TEAM,	
								REQUESTOR,			SHIPMENT_CONFIRM_QTY,	YYYYMMDD,			TRANSPORT_MODE,
								REMARKS2,			REMARKS,				CHANGE_REASON_CODE,	CHANGE_REASON_DETAIL,	REMARKS3,
								SOLDTO_DESCRIPTION,							SHIPTO_DESCRIPTION,	INCOTERMS,
								LT_DAY,ETD,ETA,		Expected_Shipping_Date,	FCST_TYPE,
								UPDATED_BY,			UPDATED_DATE,			CHANGE_REQ_NO,		CHECK_NEED_YN,			MODEL_USER,
								CONFIRM_ID,			FROM_SITE,				TO_SITE,			ERP_STATUS,				BOD_ID,
								CHANGE_TYPE,		EDIT_REMARKS,			EDIT_MAIN,			ELECTRODE_YN,			ELECTRODE_TYPE,
								MSP,				WSP
						)
						SELECT 
								DIVISION_ID,		@v_plan_start_yyyymmdd,	'SP',				1,						COMPANY_ID,			OPERATION_GROUP,
								ERP_SO_NO,			SHIPMENT_STATUS,		ITEM_ID,NICK_NAME,
								FROM_SITE_DESCRIPTION,						TO_SITE_DESCRIPTION,
								PROJECT_CODE,		PROJECT_NAME,			END_CUSTOMER,		MTK_OWNER,				TEAM,	
								REQUESTOR,			SHIPMENT_CONFIRM_QTY,	YYYYMMDD,			TRANSPORT_MODE,
								REMARKS2,			REMARKS,				CHANGE_REASON_CODE,	CHANGE_REASON_DETAIL,	REMARKS3,
								SOLDTO_DESCRIPTION,							SHIPTO_DESCRIPTION,	INCOTERMS,
								LT_DAY,ETD,ETA,		Expected_Shipping_Date,	FCST_TYPE,
								UPDATED_BY,			UPDATED_DATE,			CHANGE_REQ_NO,		CHECK_NEED_YN,			MODEL_USER,
								CONFIRM_ID,			FROM_SITE,				TO_SITE,			ERP_STATUS,				BOD_ID,
								CHANGE_TYPE,		EDIT_REMARKS,			EDIT_MAIN,			ELECTRODE_YN,			ELECTRODE_TYPE,
								@v_msp_check,		@v_wsp_check
						   FROM (
								SELECT a.division_id  
									  ,a.company_id
									  ,a.biz_type as operation_group
 									  ,isnull(con.erp_so_no, '-') AS erp_so_no                                                                                                          
 									  ,case WHEN (a.CONFIRM_ID is null OR a.CONFIRM_ID = '-') THEN 'P' else 'C' END as shipment_status                                                                                                    
 									  ,a.item_id                                                                                                            
 									  ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name                                                    
 									  ,a.from_site                                                                                                          
 									  ,a.to_site                                                                                                            
 									  ,isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') AS from_site_description                    
 									  ,isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),'-') as to_site_description                      
 									  ,isnull(a.PROJECT_CODE,'-') as PROJECT_CODE                      
 									  ,isnull(dbo.FN_GET_PROJECT_NAME(a.division_id,a.PROJECT_CODE),'-') as PROJECT_NAME                      
 									  ,isnull(case when a.DIVISION_ID = '40' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != '-' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = 'EE' and a.ORIGIN_TO_DIVISION_ID = '40' then g.project_code else f.END_CUSTOMER end,'-') end_customer            
 									  ,DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, ',', @p_language) AS MTK_OWNER                                                                                         
 									  ,CASE WHEN @p_language  = 'KO' THEN U3.UserName ELSE U3.UserName_E END + '(' + a.requestor + ')' requestor    
 									  ,convert(int, a.qty) AS shipment_confirm_qty                                                                                        
 									  ,a.yyyymmdd AS yyyymmdd                                       
 									  ,b.transport_mode                                                                                                     
 									  ,isnull(con.remarks2, '-') AS remarks2																											
 									  ,isnull(con.remarks, '-') AS remarks				                                                                                        
									  ,'-' AS CHANGE_REASON_CODE 
									  ,'' AS CHANGE_REASON_DETAIL 
 									  ,isnull(con.remarks3, '-') AS remarks3																											
 									  ,dbo.fn_get_site_customer_info((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description                
 									  ,dbo.fn_get_site_customer_info((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description                
 									  ,b.ssp_incoterms  AS INCOTERMS                                                                                                        
 									  ,b.lt_total AS lt_day                                                                                                 
 									  ,a.ETD_DATE AS etd                                                 
 									  ,a.ETA_DATE AS eta   
									  ,a.bod_id
 									  ,CASE WHEN b.transport_mode = 'TRK' then '-' else [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, a.BOD_ID, a.YYYYMMDD) end as Expected_Shipping_Date
 									  ,a.fcst_type                                                                                                          
 									  ,CASE WHEN '' +@p_language  = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' updated_by    
 									  ,case when u.UserName is not null then a.LAST_UPDATE_DATE else null end as updated_date                                                                                          
									  ,h.CHANGE_REQ_NO                   
 									  ,CASE WHEN '' +@p_language  = 'KO' THEN U2.UserName ELSE U2.UserName_E END + '(' + mu.user_id + ')' model_user    
 									  ,a.confirm_id                                                                                                         
 									  ,b.lt_total AS NEW_LT_DAY                                                                                                 
 									  ,b.transport_mode AS NEW_TRANSPORT_MODE                                                                                             
 									  ,con.ERP_STATUS 
 									  ,con.change_type 
 									  ,con.route_id AS NEW_ROUTE_ID 
 									  ,con.bod_id AS NEW_BOD_ID 
 									  ,con.incoterms AS NEW_INCOTERMS 
 									  ,con.d_country AS NEW_D_COUNTRY 
 									  ,con.d_port_code AS NEW_D_PORT_CODE 
 									  ,con.a_country AS NEW_A_COUNTRY 
 									  ,con.a_port_code AS NEW_A_PORT_CODE 
 									  ,con.customer_lt AS NEW_CUSTOMER_LT 
 									  ,con.to_country AS NEW_TO_COUNTRY 
 									  ,con.to_city AS NEW_TO_CITY 
 									  ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, a.ETA_DATE,112), 23)		AS NEW_ETA 
 									  ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, a.ETD_DATE,112), 23)		AS NEW_ETD 
 									  ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, a.yyyymmdd,112), 23)		AS NEW_SHIPMENT_DATE 
 									  ,'N' AS EDIT_REMARKS 
 									  ,'N' AS EDIT_MAIN 
 									  ,isnull(con.CHECK_NEED_YN,'N') AS CHECK_NEED_YN 
 									  ,a.ELECTRODE_YN 
 									  ,a.ELECTRODE_TYPE 
 									  ,isnull(g.DEPT_NAME_KO,'-') as TEAM                      
								  FROM SSP_ANL_SHIP_PLAN_C A WITH(NOLOCK)                                                                                                                                                                                                                                                                                      
									   LEFT OUTER JOIN  SSP_ANL_SHIP_CONFIRM con WITH(NOLOCK) ON a.DIVISION_ID = con.DIVISION_ID and a.CONFIRM_ID = con.CONFIRM_ID
									   INNER JOIN  scp_mst_bod_n_v b                                                                                                                                                                                                                                                                     
 									ON (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                                                                                                                                          
									   LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'                                                                                                                                                                                                                  
									   INNER JOIN SCM_MST_SITE f WITH(NOLOCK) ON f.division_id = a.DIVISION_ID and f.SCM_SITE_ID = a.to_site                                                                                                                                                                                       
									   LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_NAME_KO										                                                                                                                                                                                    
  	  													  FROM (																						                                                                                                                                                                                            
  	  														   SELECT aa.DIVISION_ID, aa.PROJECT_CODE, aa.SCM_SITE_ID, aa.ITEM_ID,ac.DEPT_NAME_KO									                                                                                                                                                                                            
  	  																 ,ROW_NUMBER() over(partition by aa.DIVISION_ID, aa.SCM_SITE_ID, aa.ITEM_ID order by aa.PROJECT_CODE) num		                                                                                                                                                                            
  	  															 FROM scm_mst_site_item aa WITH(NOLOCK)																				                                                                                                                                                                                
  	  																  LEFT OUTER JOIN SCM_MST_SITE  BB WITH(NOLOCK) 																				                                                                                                                                                                                
  	  															   ON BB.SCM_SITE_ID = aa.SCM_SITE_ID																				                                                                                                                                                                                
  	  																  LEFT OUTER JOIN SCM_MST_SSO_USER_INFO  ab WITH(NOLOCK) 																				                                                                                                                                                                                
  	  															   ON ab.USER_ID = aa.OWNER																				                                                                                                                                                                                
  	  																  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  ac WITH(NOLOCK) 																			                                                                                                                                                                                
  	  															   ON  bb.DEPT_ID = ac.DEPT_ID																				                                                                                                                                                                                
  	  														   ) a 
														 WHERE num = 1) g 
									ON G.DIVISION_ID =  (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID	                                                                                                
									   LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO 
														  FROM (								                                                                                                                                                                                                            
															   SELECT CONFIRM_ID ,CHANGE_REQ_NO								                                                                                                                                                                                                                                
																	 ,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM								                                                                                                                                                                                        
																 FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)								                                                                                                                                                                                                                            
																WHERE VALID_YN = 'Y'								                                                                                                                                                                                                                                            
															   ) A 
														 WHERE NUM = 1) h 
									ON H.confirm_id = a.confirm_id								                                                                                                                                                                                                                
									   LEFT OUTER JOIN SSP_MST_MODEL_USER mu WITH(NOLOCK) on mu.division_id = a.origin_from_division_id and mu.from_site = a.from_site and mu.item_id = a.item_id and mu.valid_yn = 'Y'                                                                                                                             
									   LEFT OUTER JOIN TB_FX_User U2 WITH(NOLOCK) ON mu.user_id = u2.UserID AND U2.UseYN = 'Y'                                                                                                                                                                                                                      
									   LEFT OUTER JOIN TB_FX_User U3 WITH(NOLOCK) ON a.requestor = u3.UserID AND U3.UseYN = 'Y'                                                                                                                                                                                                                     
									   LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
									ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID ='EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)                                                                                                                                      
  								   AND SI.SCM_SITE_ID  = A.TO_SITE                                                                                                                                                                                                                         
  								   AND SI.ITEM_ID  = A.ITEM_ID                                                                                                                                                                                                                             
  								   AND SI.PROJECT_CODE  = A.PROJECT_CODE                                                                                                                                                                                                                   
									   LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 WITH(NOLOCK)                                                                                                                                                                                                                                                
									ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO                                                                                                                                                                                                                                                           
 								 WHERE 1=1 
								   and MEASURE = 'SHIP_PLAN'                                                                                                              
 								   AND a.division_id =  @DIVISION_ID  
 								   AND a.PLAN_START_YYYYMMDD =  @v_plan_start_yyyymmdd  
 								   AND a.company_id IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@COMPANY_ID,',') ) 
 								   AND a.yyyymmdd >=  @v_from_yyyymmdd 		
								   AND a.yyyymmdd <=  @v_to_yyyymmdd                                                     
 								   AND a.qty > 0 
 								   AND a.BIZ_TYPE <> 'E' 
								) AA

				END
			END
			ELSE IF @ORG_DIVISION_ID IN ('81', '82') and @EE_YN = N'X'
			BEGIN

				SELECT @COUNT_CHECK = COUNT(PLAN_START_YYYYMMDD)
				  FROM SSP_MST_SHIP_PLAN_SCHEDULE WITH(NOLOCK)
				WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				  AND PLAN_CUTOFF_CREATE_YN = 'Y'
				  AND COMPANY_ID = @COMPANY_ID

				IF @COUNT_CHECK > 0
				BEGIN

					SET @v_from_yyyymmdd = @v_plan_start_yyyymmdd;
					SET @v_to_yyyymmdd = CONVERT(VARCHAR, DATEADD(D, 55, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ;

					INSERT INTO SSP_ANL_SHIP_PLAN_ALL (
								DIVISION_ID,		PLAN_START_YYYYMMDD,	PLAN_TYPE,			SEQ,					COMPANY_ID,			OPERATION_GROUP,
								ERP_SO_NO,			SHIPMENT_STATUS,		ITEM_ID,NICK_NAME,
								FROM_SITE_DESCRIPTION,						TO_SITE_DESCRIPTION,
								PROJECT_CODE,		PROJECT_NAME,			END_CUSTOMER,		MTK_OWNER,				TEAM,	
								REQUESTOR,			SHIPMENT_CONFIRM_QTY,	YYYYMMDD,			TRANSPORT_MODE,
								REMARKS2,			REMARKS,				CHANGE_REASON_CODE,	CHANGE_REASON_DETAIL,	REMARKS3,
								SOLDTO_DESCRIPTION,							SHIPTO_DESCRIPTION,	INCOTERMS,
								LT_DAY,ETD,ETA,		Expected_Shipping_Date,	FCST_TYPE,
								UPDATED_BY,			UPDATED_DATE,			CHANGE_REQ_NO,		CHECK_NEED_YN,			MODEL_USER,
								CONFIRM_ID,			FROM_SITE,				TO_SITE,			ERP_STATUS,				BOD_ID,
								CHANGE_TYPE,		EDIT_REMARKS,			EDIT_MAIN,			ELECTRODE_YN,			ELECTRODE_TYPE,
								MSP,				WSP
						)
						SELECT 
								DIVISION_ID,		@v_plan_start_yyyymmdd,	'SP',				1,						COMPANY_ID,			OPERATION_GROUP,
								ERP_SO_NO,			SHIPMENT_STATUS,		ITEM_ID,NICK_NAME,
								FROM_SITE_DESCRIPTION,						TO_SITE_DESCRIPTION,
								PROJECT_CODE,		PROJECT_NAME,			END_CUSTOMER,		MTK_OWNER,				TEAM,	
								REQUESTOR,			SHIPMENT_CONFIRM_QTY,	YYYYMMDD,			TRANSPORT_MODE,
								REMARKS2,			REMARKS,				CHANGE_REASON_CODE,	CHANGE_REASON_DETAIL,	REMARKS3,
								SOLDTO_DESCRIPTION,							SHIPTO_DESCRIPTION,	INCOTERMS,
								LT_DAY,ETD,ETA,		Expected_Shipping_Date,	FCST_TYPE,
								UPDATED_BY,			UPDATED_DATE,			CHANGE_REQ_NO,		CHECK_NEED_YN,			MODEL_USER,
								CONFIRM_ID,			FROM_SITE,				TO_SITE,			ERP_STATUS,				BOD_ID,
								CHANGE_TYPE,		EDIT_REMARKS,			EDIT_MAIN,			ELECTRODE_YN,			ELECTRODE_TYPE,
								@v_msp_check,		@v_wsp_check
						   FROM (
								SELECT   
									   a.division_id
									  ,a.company_id
									  ,a.operation_group
									  ,a.erp_so_no
									  ,a.shipment_status
									  ,a.item_id
									  ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
									  ,a.from_site
									  ,a.to_site
									  ,isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') AS from_site_description
									  ,isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),'-') as to_site_description
									  ,isnull(a.PROJECT_CODE,'-') as PROJECT_CODE
									  ,isnull(dbo.FN_GET_PROJECT_NAME(a.division_id,a.PROJECT_CODE),'-') as PROJECT_NAME
									  ,isnull(case when a.DIVISION_ID = '40' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != '-' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = 'EE' and a.ORIGIN_TO_DIVISION_ID = '40' then g.project_code else f.END_CUSTOMER end,'-') end_customer
									  ,DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, ',', @p_language) AS MTK_OWNER
									  ,CASE WHEN '' +@p_language + '' = 'KO' THEN U3.UserName ELSE U3.UserName_E END + '(' + a.requestor + ')' requestor
									  ,convert(int, a.qty) AS shipment_confirm_qty
									  ,a.yyyymmdd AS yyyymmdd
									  ,b.transport_mode
									  ,a.remarks2
									  ,a.remarks
									  ,'-' AS CHANGE_REASON_CODE
									  ,'' AS CHANGE_REASON_DETAIL
									  ,a.remarks3
									  ,dbo.fn_get_site_customer_info((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
									  ,dbo.fn_get_site_customer_info((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
									  ,b.ssp_incoterms AS INCOTERMS
									  ,b.lt_total AS lt_day
									  ,a.ETD_DATE AS etd
									  ,a.ETA_DATE AS eta
									  ,CASE WHEN b.transport_mode = 'TRK' then '-' else [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, a.BOD_ID, a.YYYYMMDD) end as Expected_Shipping_Date
									  ,a.fcst_type
									  ,CASE WHEN @p_language  = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' AS updated_by
									  ,case when u.UserName is not null then a.LAST_UPDATE_DATE else null end updated_date
									  ,h.CHANGE_REQ_NO
									  ,CASE WHEN @p_language  = 'KO' THEN U2.UserName ELSE U2.UserName_E END + '(' + mu.user_id + ')' AS model_user
									  ,a.confirm_id
									  ,b.lt_total AS NEW_LT_DAY
									  ,b.transport_mode AS NEW_TRANSPORT_MODE
									  ,a.ERP_STATUS
									  ,a.change_type
									  ,a.NEW_ROUTE_ID
									  ,a.NEW_BOD_ID AS BOD_ID
									  ,a.NEW_INCOTERMS
									  ,a.NEW_D_COUNTRY
									  ,a.NEW_D_PORT_CODE
									  ,a.NEW_A_COUNTRY
									  ,a.NEW_A_PORT_CODE
									  ,a.NEW_CUSTOMER_LT
									  ,a.NEW_TO_COUNTRY
									  ,a.NEW_TO_CITY
									  ,a.NEW_ETA
									  ,a.NEW_ETD
									  ,a.NEW_SHIPMENT_DATE
									  ,a.EDIT_REMARKS
									  ,a.EDIT_MAIN
									  ,a.CHECK_NEED_YN
									  ,a.ELECTRODE_YN
									  ,a.ELECTRODE_TYPE
									  ,isnull(g.DEPT_NAME_KO,'-') as TEAM
								  FROM (
									   SELECT
											  A.DIVISION_ID
											 ,A.from_site_company_id as company_id
											 ,MS.OPERATION_GROUP
											 ,A.ERP_SO_NO
											 ,A.SHIPMENT_STATUS AS SHIPMENT_STATUS
											 ,A.ITEM_ID
											 ,A.ORIGIN_FROM_DIVISION_ID
											 ,A.ORIGIN_TO_DIVISION_ID
											 ,A.FROM_SITE
											 ,A.TO_SITE
											 ,A.PROJECT_CODE
											 ,A.REQUESTOR
											 ,A.QTY
											 ,A.YYYYMMDD
											 ,A.BOD_ID
											 ,A.REMARKS2
											 ,A.REMARKS
											 ,A.CHANGE_REQ_NO
											 ,A.REMARKS3
											 ,A.ETD_DATE
											 ,A.ETA_DATE
											 ,A.LAST_UPDATED_BY
											 ,A.LAST_UPDATE_DATE
											 ,A.CONFIRM_ID
											 ,A.FCST_TYPE
											 ,A.ERP_STATUS
											 ,A.change_type
											 ,A.route_id AS NEW_ROUTE_ID
											 ,A.bod_id AS NEW_BOD_ID
											 ,A.incoterms AS NEW_INCOTERMS
											 ,A.d_country AS NEW_D_COUNTRY
											 ,A.d_port_code AS NEW_D_PORT_CODE
											 ,A.a_country AS NEW_A_COUNTRY
											 ,A.a_port_code AS NEW_A_PORT_CODE
											 ,A.customer_lt AS NEW_CUSTOMER_LT
											 ,A.to_country AS NEW_TO_COUNTRY
											 ,A.to_city AS NEW_TO_CITY
											 ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, ETA_DATE,112), 23)		AS NEW_ETA
											 ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, ETD_DATE,112), 23)		AS NEW_ETD
											 ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, yyyymmdd,112), 23)		AS NEW_SHIPMENT_DATE
											 ,'N' AS EDIT_REMARKS
											 ,'N' AS EDIT_MAIN
											 ,isnull(CHECK_NEED_YN,'N') AS CHECK_NEED_YN
											 ,A.ELECTRODE_YN
											 ,A.ELECTRODE_TYPE
										 FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
											  INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
										   ON A.DIVISION_ID = MS.DIVISION_ID
										  AND A.FROM_SITE = MS.SCM_SITE_ID
										  AND MS.SITE_TYPE = 'PLANT'
										  --AND A.DIVISION_ID = @DIVISION_ID
										  and MS.VALID_YN = 'Y'
										WHERE 1 = 1    
										  AND A.change_type  = 'C'
										  AND A.DIVISION_ID =  @DIVISION_ID
										  AND A.FROM_SITE_COMPANY_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@COMPANY_ID,',') ) 
										  AND A.BIZ_TYPE <> 'E'
										  AND A.yyyymmdd >=  @v_from_yyyymmdd 		AND A.yyyymmdd <=  @v_to_yyyymmdd
										UNION ALL
									   SELECT
											  DIVISION_ID
											 ,COMPANY_ID
											 ,OPERATION_GROUP
											 ,ERP_SO_NO
											 ,SHIPMENT_STATUS
											 ,ITEM_ID
											 ,ORIGIN_FROM_DIVISION_ID
											 ,ORIGIN_TO_DIVISION_ID
											 ,FROM_SITE
											 ,TO_SITE
											 ,PROJECT_CODE
											 ,REQUESTOR
											 ,QTY
											 ,YYYYMMDD
											 ,BOD_ID
											 ,REMARKS2
											 ,REMARKS
											 ,CHANGE_REQ_NO
											 ,REMARKS3
											 ,ETD_DATE
											 ,ETA_DATE
											 ,LAST_UPDATED_BY
											 ,LAST_UPDATE_DATE
											 ,CONFIRM_ID
											 ,FCST_TYPE
											 ,'-' AS ERP_STATUS
											 ,'-' AS change_type
											 ,'-' AS NEW_ROUTE_ID
											 ,'-' AS NEW_BOD_ID
											 ,'-' AS NEW_INCOTERMS
											 ,'-' AS NEW_D_COUNTRY
											 ,'-' AS NEW_D_PORT_CODE
											 ,'-' AS NEW_A_COUNTRY
											 ,'-' AS NEW_A_PORT_CODE
											 ,'-' AS NEW_CUSTOMER_LT
											 ,'-' AS NEW_TO_COUNTRY
											 ,'-' AS NEW_TO_CITY
											 ,'-' AS NEW_ETA
											 ,'-' AS NEW_ETD
											 ,'-' AS NEW_SHIPMENT_DATE
											 ,'-' AS EDIT_REMARKS
											 ,'-' AS EDIT_MAIN
											 ,'-' AS CHECK_NEED_YN
											 ,'-' AS ELECTRODE_YN
											 ,'-' AS ELECTRODE_TYPE
										 FROM (
											  SELECT
													 tt0.DIVISION_ID
													,tt2.COMPANY_ID
													,tt2.operation_group
													,'-' AS ERP_SO_NO
													,'P' AS SHIPMENT_STATUS
													,tt0. ITEM_ID
													,tt0.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
													,tt0.DIVISION_ID AS ORIGIN_TO_DIVISION_ID
													,tt0.PLANT_SITE_ID AS FROM_SITE
													,tt0.SCM_SITE_ID AS TO_SITE
													,tt0.PROJECT_CODE
													,'-' AS REQUESTOR
													,tt0.QTY
													,tt0.YYYYMMDD
													,tt0.BOD_ID
													,'-' AS REMARKS2
													,'-' AS REMARKS
													,'-' AS CHANGE_REQ_NO
													,'-' AS REMARKS3
													,tt0.YYYYMMDD AS ETD_DATE
													,CONVERT(VARCHAR(8),CONVERT(DATETIME,[dbo].[FN_GET_SSP_ETA_DATE](tt0.DIVISION_ID, tt0.BOD_ID, tt0.YYYYMMDD) ,112), 112) AS ETA_DATE
													,tt0.LAST_UPDATED_BY
													,tt0.LAST_UPDATE_DATE
													,'-' AS CONFIRM_ID
													,tt0.FCST_TYPE
													,CASE WHEN isnull(tt2.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(tt2.ship_frozen,0), CONVERT(VARCHAR, '' + @v_plan_start_yyyymmdd + '', 121)), 112) ELSE '' + @v_plan_start_yyyymmdd + '' END AS frozen_yyyymmdd
												FROM DM_PLN_SHIPMENT_REQ tt0 WITH(NOLOCK)
													 INNER JOIN scp_mst_bod_n_v tt1 WITH(NOLOCK) ON tt0.DIVISION_ID = tt1.division_id  AND tt0.bod_id = tt1.bod_id
													 INNER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)
												  ON tt0.DIVISION_ID = tt2.DIVISION_ID
												 AND tt0.PLANT_SITE_ID = tt2.SCM_SITE_ID
												 AND tt2.site_type		= 'PLANT'
												 AND tt2.valid_yn		= 'Y'
											   WHERE 1 = 1
												 AND  tt0.DIVISION_ID       =  @DIVISION_ID
												 AND tt2.COMPANY_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@COMPANY_ID,',') ) 
												 AND tt0.yyyymmdd >=  @v_from_yyyymmdd 		AND tt0.yyyymmdd <=  @v_to_yyyymmdd
											  ) T
										WHERE 1 = 1
										  AND t.YYYYMMDD >= t.frozen_yyyymmdd
									   ) A
									   INNER JOIN  scp_mst_bod_n_v b
									ON (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id
									   LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'
									   INNER JOIN SCM_MST_SITE f WITH(NOLOCK) ON f.division_id = a.DIVISION_ID and f.SCM_SITE_ID = a.TO_SITE
									   LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_NAME_KO
														  FROM (
															   SELECT aa.DIVISION_ID, aa.PROJECT_CODE, aa.SCM_SITE_ID, aa.ITEM_ID,ac.DEPT_NAME_KO
																	 ,ROW_NUMBER() over(partition by aa.DIVISION_ID, aa.SCM_SITE_ID, aa.ITEM_ID order by aa.PROJECT_CODE) num
																 FROM scm_mst_site_item aa WITH(NOLOCK)
																	  LEFT OUTER JOIN SCM_MST_SITE  BB WITH(NOLOCK)
																   ON BB.SCM_SITE_ID = aa.SCM_SITE_ID
																	  LEFT OUTER JOIN SCM_MST_SSO_USER_INFO  ab WITH(NOLOCK)
																   ON ab.USER_ID = aa.OWNER
																	  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  ac WITH(NOLOCK)
																   ON bb.DEPT_ID = ac.DEPT_ID
															   ) a 
														 WHERE num = 1) g 
									ON g.DIVISION_ID =  (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID
									   LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO 
														  FROM (
															   SELECT CONFIRM_ID ,CHANGE_REQ_NO, ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM
																 FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)
																WHERE VALID_YN = 'Y'
															   ) A 
														 WHERE NUM = 1) h 
									ON h.confirm_id = a.confirm_id
									   LEFT OUTER JOIN SSP_MST_MODEL_USER mu WITH(NOLOCK) on mu.division_id = a.origin_from_division_id and mu.from_site = a.from_site and mu.item_id = a.item_id and mu.valid_yn = 'Y'
									   LEFT OUTER JOIN TB_FX_User U2 WITH(NOLOCK) ON mu.user_id = u2.UserID AND U2.UseYN = 'Y'
									   LEFT OUTER JOIN TB_FX_User U3 WITH(NOLOCK) ON a.requestor = u3.UserID AND U3.UseYN = 'Y'
									   LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID ='EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)
								   AND SI.SCM_SITE_ID  = A.TO_SITE
								   AND SI.ITEM_ID  = A.ITEM_ID
								   AND SI.PROJECT_CODE  = A.PROJECT_CODE
									   LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 WITH(NOLOCK)
									ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO
								 WHERE 1=1
								   AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'') != '')
								   AND a.qty > 0
					--ORDER BY a.division_id, a.shipment_status, a.yyyymmdd,  a.item_id, a.ERP_SO_NO DESC, a.from_site, a.to_site, a.project_code, a.fcst_type
					) AS AA

				END
			END
			ELSE IF @ORG_DIVISION_ID IN ('40', '81', '82') AND @EE_YN = N'Y'
			BEGIN

				SELECT @COUNT_CHECK = COUNT(PLAN_START_YYYYMMDD)
				  FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WITH(NOLOCK)
				WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				  AND PLAN_CUTOFF_CREATE_YN = 'Y'
				  AND COMPANY_ID = @COMPANY_ID

				IF @COUNT_CHECK > 0
				BEGIN

					SET @v_from_yyyymmdd = @v_plan_start_yyyymmdd ;
					SET @v_to_yyyymmdd = CONVERT(VARCHAR, DATEADD(D, 55, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ;

					INSERT INTO SSP_ANL_SHIP_PLAN_ALL (
								DIVISION_ID,		PLAN_START_YYYYMMDD,	PLAN_TYPE,			SEQ,					COMPANY_ID,			OPERATION_GROUP,
								ERP_SO_NO,			SHIPMENT_STATUS,		MODEL_ID,			MODEL_ID_NICK_NAME,		ITEM_ID,
								FROM_SITE_DESCRIPTION,						TO_SITE_DESCRIPTION,						DOM_EXP,DAYOFWEEK_NAME,
								REQUESTOR,			SHIPMENT_CONFIRM_QTY,	YYYYMMDD,			SHIPPING_PLAN_QTY,		GAP,
								TRANSPORT_MODE,		REMARKS2,				REMARKS,			CHANGE_REASON_CODE,		CHANGE_REASON_DETAIL,
								REMARKS3,			SOLDTO_DESCRIPTION,		SHIPTO_DESCRIPTION,	INCOTERMS,			LT_DAY,
								ETD,				ETA,					Expected_Shipping_Date,						UPDATED_BY,
								UPDATED_DATE,		CHANGE_REQ_NO,			MODEL_USER,			CONFIRM_ID,				FROM_SITE,
								TO_SITE,			ERP_STATUS,				CHANGE_TYPE,		EDIT_REMARKS,			EDIT_MAIN,
								ELECTRODE_YN,		ELECTRODE_TYPE,			CONFIRM_QTY_ROLL_LENGTH,					PACKAGE_TYPE,
								PACKAGE_QTY,		FACTORY_ID,				ELECTRODE_POST_OPER,						CONFIRM_QTY_PANCAKE,
								CONFIRM_QTY_JR,		CONFIRM_QTY_CELL,		CELL_TYPE,
								MSP,				WSP
								)
						 SELECT
								DIVISION_ID,		@v_plan_start_yyyymmdd,	'SP',				1,						COMPANY_ID,			OPERATION_GROUP,
								ERP_SO_NO,			SHIPMENT_STATUS,		MODEL_ID,			MODEL_ID_NICK_NAME,		ITEM_ID,
								FROM_SITE_DESCRIPTION,						TO_SITE_DESCRIPTION,						DOM_EXP,DAYOFWEEK_NAME,
								REQUESTOR,			SHIPMENT_CONFIRM_QTY,	YYYYMMDD,			SHIPPING_PLAN_QTY,		GAP,
								TRANSPORT_MODE,		REMARKS2,				REMARKS,			CHANGE_REASON_CODE,		CHANGE_REASON_DETAIL,
								REMARKS3,			SOLDTO_DESCRIPTION,		SHIPTO_DESCRIPTION,	INCOTERMS,			LT_DAY,
								ETD,				ETA,					Expected_Shipping_Date,						UPDATED_BY,
								UPDATED_DATE,		CHANGE_REQ_NO,			MODEL_USER,			CONFIRM_ID,				FROM_SITE,
								TO_SITE,			ERP_STATUS,				CHANGE_TYPE,		EDIT_REMARKS,			EDIT_MAIN,
								ELECTRODE_YN,		ELECTRODE_TYPE,			CONFIRM_QTY_ROLL_LENGTH,					PACKAGE_TYPE,
								PACKAGE_QTY,		FACTORY_ID,				ELECTRODE_POST_OPER,						CONFIRM_QTY_PANCAKE,
								CONFIRM_QTY_JR,		CONFIRM_QTY_CELL,		CELL_TYPE,
								@v_msp_check,		@v_wsp_check
						   FROM (
								SELECT   
									   a.DIVISION_ID
									  ,a.COMPANY_ID
									  ,a.operation_group
									  ,a.ERP_SO_NO
									  ,a.SHIPMENT_STATUS
									  ,a.ITEM_ID
									  ,a.ITEM_ID_NICK_NAME
									  ,a.MODEL_ID
									  ,a.MODEL_ID_NICK_NAME
									  ,(SELECT DAYOFWEEK_NAME FROM  SCM_SYS_CALENDAR_M X1 WHERE X1.BASIS_YYYYMMDD = A.yyyymmdd ) as DAYOFWEEK_NAME
									  ,convert(int, SHIPPING_PLAN_QTY)												as SHIPPING_PLAN_QTY
									  ,convert(int, isnull(a.QTY , 0))												as SHIPMENT_CONFIRM_QTY
									  ,convert(int, (SHIPPING_PLAN_QTY - isnull(a.QTY,0) ))							as GAP
									  ,a.YYYYMMDD		as YYYYMMDD
									  ,ROW_NUMBER() OVER(PARTITION BY a.DIVISION_ID , a.ERP_SO_NO , a.SHIPMENT_STATUS,CELL_TYPE,a.YYYYMMDD,a.ITEM_ID,a.MODEL_ID,a.FROM_SITE,a.TO_SITE
									   ORDER BY a.division_id, a.shipment_status, a.ERP_SO_NO DESC, A.CELL_TYPE, a.yyyymmdd,  a.item_id, a.from_site, a.to_site) AS MERGE_NUM
									  ,a.DOM_EXP_TYPE																as DOM_EXP
									  ,a.FACTORY_ID																	as FACTORY_ID
									  ,a.FACTORY_ID																	as FACTORY_NAME
									  ,a.CONFIRM_QTY_PANCAKE
									  ,a.CONFIRM_QTY_JR
									  ,a.CONFIRM_QTY_CELL
									  ,a.CONFIRM_QTY_ROLL_LENGTH
									  ,a.PACKAGE_TYPE_CODE															as PACKAGE_TYPE
									  ,CEILING(CASE WHEN a.PACKAGE_TYPE_CODE = 'BX' THEN CONFIRM_QTY_ROLL_LENGTH * isnull(a.BOX_PER_CUT ,1)
													WHEN a.PACKAGE_TYPE_CODE = 'SC' THEN CONFIRM_QTY_ROLL_LENGTH * isnull(a.STEELCRATE_PER_CUT ,1)
													WHEN a.PACKAGE_TYPE_CODE = 'SR' THEN CONFIRM_QTY_ROLL_LENGTH * isnull(a.STEELRACK_PER_CUT ,1)
													ELSE ISNULL(a.QTY,0)  END)										as PACKAGE_QTY
									  ,a.ELECTRODE_POST_OPER														as ELECTRODE_POST_OPER
									  ,a.FROM_SITE																	as FROM_SITE
									  ,a.TO_SITE																	as TO_SITE
									  ,isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION(a.DIVISION_ID, a.FROM_SITE),'-')	as FROM_SITE_DESCRIPTION
									  ,isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION(a.DIVISION_ID, a.TO_SITE  ),'-')	as TO_SITE_DESCRIPTION
									  ,CASE WHEN @p_language  = 'KO' THEN U3.UserName ELSE U3.UserName_E END + '(' + a.requestor + ')' REQUESTOR
									  ,b.TRANSPORT_MODE
									  ,a.REMARKS2
									  ,a.REMARKS
									  ,'-'																		as CHANGE_REASON_CODE
									  ,''																			as CHANGE_REASON_DETAIL
									  ,a.REMARKS3
									  ,dbo.FN_GET_SITE_CUSTOMER_INFO((case when a.DIVISION_ID = 'EE' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end), a.TO_SITE, 'SOLDTO_DESCRIPTION' ) AS SOLDTO_DESCRIPTION
									  ,dbo.FN_GET_SITE_CUSTOMER_INFO((case when a.DIVISION_ID = 'EE' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end), a.TO_SITE, 'SHIPTO_DESCRIPTION' ) AS SHIPTO_DESCRIPTION
									  ,b.SSP_INCOTERMS	AS INCOTERMS
									  ,b.LT_TOTAL																	as LT_DAY
									  ,a.ETD_DATE				as ETD
									  ,a.ETA_DATE				as ETA
									  ,CASE WHEN b.TRANSPORT_MODE = 'TRK' then '-' else [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, a.BOD_ID, a.YYYYMMDD) end as EXPECTED_SHIPPING_DATE
									  ,CASE WHEN @p_language  = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' AS UPDATED_BY
									  ,case when u.UserName is not null then a.LAST_UPDATE_DATE else null end UPDATED_DATE
									  ,h.CHANGE_REQ_NO
									  ,CASE WHEN @p_language  = 'KO' THEN U2.UserName ELSE U2.UserName_E END + '(' + mu.user_id + ')' AS MODEL_USER
									  ,a.CONFIRM_ID
									  ,b.LT_TOTAL		AS NEW_LT_DAY
									  ,b.TRANSPORT_MODE AS NEW_TRANSPORT_MODE
									  ,a.ERP_STATUS
									  ,a.CHANGE_TYPE
									  ,a.NEW_ROUTE_ID
									  ,a.NEW_BOD_ID
									  ,a.NEW_INCOTERMS
									  ,a.NEW_D_COUNTRY
									  ,a.NEW_D_PORT_CODE
									  ,a.NEW_A_COUNTRY
									  ,a.NEW_A_PORT_CODE
									  ,a.NEW_CUSTOMER_LT
									  ,a.NEW_TO_COUNTRY
									  ,a.NEW_TO_CITY
									  ,a.NEW_ETA
									  ,a.NEW_ETD
									  ,a.NEW_SHIPMENT_DATE
									  ,a.EDIT_REMARKS
									  ,a.EDIT_MAIN
									  ,a.CHECK_NEED_YN
									  ,a.ELECTRODE_YN
									  ,a.ELECTRODE_TYPE
									  ,a.CELL_TYPE
									  ,a.ATTRIBUTE10
								  FROM (
									   SELECT
											  C.DIVISION_ID
											 ,C.FROM_SITE_COMPANY_ID AS COMPANY_ID
											 ,MS.OPERATION_GROUP
											 ,C.ERP_SO_NO
											 ,C.SHIPMENT_STATUS
											 ,C.ITEM_ID
											 ,C.ORIGIN_FROM_DIVISION_ID
											 ,C.ORIGIN_TO_DIVISION_ID
											 ,C.FROM_SITE
											 ,C.TO_SITE
											 ,C.REQUESTOR
											 ,C.QTY
											 ,ie.ITEM_ID_NICK_NAME
											 ,ie.MODEL_ID
											 ,ie.MODEL_ID_NICK_NAME
											 ,isnull(c.ELECTRODE_TYPE,ie.ELECTRODE_TYPE)						as ELECTRODE_TYPE
											 ,isnull(C.DOM_EXP, ie.DOM_EXP_TYPE) 													as DOM_EXP_TYPE
											 ,CONVERT(int, c.QTY * isnull(ie.CONVERT_TO_PCM ,1) )				as CONFIRM_QTY_PANCAKE
											 ,CONVERT(int, c.QTY * isnull(ie.CONVERT_TO_JRM ,1) )				as CONFIRM_QTY_JR
											 ,CONVERT(int, c.QTY * isnull(ie.CONVERT_TO_CELL ,1) )				as CONFIRM_QTY_CELL
											 ,CEILING(c.QTY * isnull(ie.CONVERT_TO_PC_ROLL_LENGTH ,1) )			as CONFIRM_QTY_ROLL_LENGTH
											 ,isnull(C.PACKAGE_TYPE_CODE, ie.PACKAGE_TYPE_CODE)					as PACKAGE_TYPE_CODE
											 ,ie.BOX_PER_CUT
											 ,ie.STEELCRATE_PER_CUT
											 ,ie.STEELRACK_PER_CUT
											 ,ie.ELECTRODE_POST_OPER
											 ,ie.CELL_TYPE
											 ,c.YYYYMMDD
											 ,c.BOD_ID
											 ,c.REMARKS2
											 ,c.REMARKS
											 ,c.CHANGE_REQ_NO
											 ,c.REMARKS3
											 ,c.ETD_DATE
											 ,c.ETA_DATE
											 ,c.LAST_UPDATED_BY
											 ,c.LAST_UPDATE_DATE
											 ,c.CONFIRM_ID
											 ,c.ERP_STATUS
											 ,c.CHANGE_TYPE
											 ,c.ROUTE_ID 													AS NEW_ROUTE_ID
											 ,c.BOD_ID 														AS NEW_BOD_ID
											 ,c.INCOTERMS 													AS NEW_INCOTERMS
											 ,c.D_COUNTRY 													AS NEW_D_COUNTRY
											 ,c.D_PORT_CODE 												AS NEW_D_PORT_CODE
											 ,c.A_COUNTRY 													AS NEW_A_COUNTRY
											 ,c.A_PORT_CODE 												AS NEW_A_PORT_CODE
											 ,c.CUSTOMER_LT 												AS NEW_CUSTOMER_LT
											 ,c.TO_COUNTRY													AS NEW_TO_COUNTRY
											 ,c.TO_CITY														AS NEW_TO_CITY
											 ,CONVERT(VARCHAR(10),	CONVERT(DATETIME, c.ETA_DATE,112), 23)	AS NEW_ETA
											 ,CONVERT(VARCHAR(10),	CONVERT(DATETIME, c.ETD_DATE,112), 23)	AS NEW_ETD
											 ,CONVERT(VARCHAR(10),	CONVERT(DATETIME, c.yyyymmdd,112), 23)	AS NEW_SHIPMENT_DATE
											 ,'N'															AS EDIT_REMARKS
											 ,'N'															AS EDIT_MAIN
											 ,isnull(C.CHECK_NEED_YN,'N')									AS CHECK_NEED_YN
											 ,c.ELECTRODE_YN
											 ,isnull(c.FACTORY_ID,ie.FACTORY_ID) 							AS FACTORY_ID
											 ,ISNULL(pe.QTY,0) 												AS 	SHIPPING_PLAN_QTY
											 ,C.ATTRIBUTE10	 												AS 	ATTRIBUTE10
										 FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
											  INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
										   ON C.DIVISION_ID = MS.DIVISION_ID
										  AND C.FROM_SITE = MS.SCM_SITE_ID
										  AND MS.SITE_TYPE = 'PLANT'
										  --AND A.DIVISION_ID = @DIVISION_ID
										  and MS.VALID_YN = 'Y'
											  INNER JOIN SSP_MST_SITE_ITEM_EE_V IE ON ie.division_id = c.DIVISION_ID and ie.SCM_SITE_ID = c.FROM_SITE and ie.ITEM_ID  = c.ITEM_ID
											  LEFT OUTER JOIN SSP_ANL_SHIP_PLAN_EE PE WITH(NOLOCK)
										   ON PE.MEASURE = 'P_SHIP_PLAN_SIMU_ETD'
										  AND pe.PLAN_START_YYYYMMDD =  @v_plan_start_yyyymmdd
										  AND pe.division_id = ie.DIVISION_ID and pe.SCM_SITE_ID = ie.SCM_SITE_ID and pe.ITEM_ID  = ie.ITEM_ID and pe.YYYYMMDD = c.yyyymmdd
										WHERE 1 = 1
										  AND c.CHANGE_TYPE  = 'C'
										  AND c.DIVISION_ID  =  @DIVISION_ID
										  AND c.FROM_SITE_COMPANY_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@COMPANY_ID,',') ) 
										  AND c.YYYYMMDD >=  @v_from_yyyymmdd 	AND c.YYYYMMDD <=  @v_to_yyyymmdd

										UNION ALL

									   SELECT
											  DIVISION_ID
											 ,COMPANY_ID
											 ,operation_group
											 ,ERP_SO_NO
											 ,SHIPMENT_STATUS
											 ,ITEM_ID
											 ,ORIGIN_FROM_DIVISION_ID
											 ,ORIGIN_TO_DIVISION_ID
											 ,FROM_SITE
											 ,TO_SITE
											 ,REQUESTOR
											 ,QTY
											 ,ITEM_ID_NICK_NAME
											 ,MODEL_ID
											 ,MODEL_ID_NICK_NAME
											 ,ELECTRODE_TYPE
											 ,DOM_EXP_TYPE
											 ,CONFIRM_QTY_PANCAKE
											 ,CONFIRM_QTY_JR
											 ,CONFIRM_QTY_CELL
											 ,CONFIRM_QTY_ROLL_LENGTH
											 ,PACKAGE_TYPE_CODE
											 ,BOX_PER_CUT
											 ,STEELCRATE_PER_CUT
											 ,STEELRACK_PER_CUT
											 ,ELECTRODE_POST_OPER
											 ,CELL_TYPE
											 ,YYYYMMDD
											 ,BOD_ID
											 ,REMARKS2
											 ,REMARKS
											 ,CHANGE_REQ_NO
											 ,REMARKS3
											 ,ETD_DATE
											 ,ETA_DATE
											 ,LAST_UPDATED_BY
											 ,LAST_UPDATE_DATE
											 ,CONFIRM_ID
											 ,'-' AS ERP_STATUS
											 ,'-' AS change_type
											 ,'-' AS NEW_ROUTE_ID
											 ,'-' AS NEW_BOD_ID
											 ,'-' AS NEW_INCOTERMS
											 ,'-' AS NEW_D_COUNTRY
											 ,'-' AS NEW_D_PORT_CODE
											 ,'-' AS NEW_A_COUNTRY
											 ,'-' AS NEW_A_PORT_CODE
											 ,'-' AS NEW_CUSTOMER_LT
											 ,'-' AS NEW_TO_COUNTRY
											 ,'-' AS NEW_TO_CITY
											 ,'-' AS NEW_ETA
											 ,'-' AS NEW_ETD
											 ,'-' AS NEW_SHIPMENT_DATE
											 ,'-' AS EDIT_REMARKS
											 ,'-' AS EDIT_MAIN
											 ,'-' AS CHECK_NEED_YN
											 ,'-' AS ELECTRODE_YN
											 ,FACTORY_ID
											 ,SHIPPING_PLAN_QTY
											 ,'' AS ATTRIBUTE10
										 FROM (
											  SELECT 
													 t0.FROM_DIVISION_ID		AS DIVISION_ID
													 ,tt2.company_id
													 ,tt2.operation_group
													 ,'-'					AS ERP_SO_NO
													 ,'P'					AS SHIPMENT_STATUS
													 ,t0.ITEM_ID
													 ,t0.FROM_DIVISION_ID	AS ORIGIN_FROM_DIVISION_ID
													 ,t0.TO_DIVISION_ID		AS ORIGIN_TO_DIVISION_ID
													 ,t0.FROM_SITE			AS FROM_SITE
													 ,t0.TO_SITE			AS TO_SITE
													 ,t0.LAST_UPDATED_BY	AS REQUESTOR
													 ,t0.QTY
													 ,t0.ETD_DATE			AS YYYYMMDD
													 ,t0.BOD_ID
													 ,'-' AS REMARKS2
													 ,'-' AS REMARKS
													 ,'-' AS CHANGE_REQ_NO
													 ,'-' AS REMARKS3
													 ,t0.ETD_DATE AS ETD_DATE
													 ,t0.ETA_DATE AS ETA_DATE
													 ,t0.LAST_UPDATED_BY
													 ,t0.LAST_UPDATE_DATE
													 ,'-' AS CONFIRM_ID
													 ,CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](T0.FROM_DIVISION_ID ,T0.FROM_SITE) , CONVERT(DATETIME,  @v_plan_start_yyyymmdd  ,112)) ,112) AS frozen_yyyymmdd
													 ,ie.FACTORY_ID
													 ,ie.ITEM_ID_NICK_NAME
													 ,ie.MODEL_ID
													 ,ie.MODEL_ID_NICK_NAME
													 ,ie.ELECTRODE_TYPE
													 ,ie.DOM_EXP_TYPE
													 ,convert(int, t0.QTY * isnull(ie.CONVERT_TO_PCM ,1) )				as CONFIRM_QTY_PANCAKE
													 ,convert(int, t0.QTY * isnull(ie.CONVERT_TO_JRM ,1) )				as CONFIRM_QTY_JR
													 ,convert(int, t0.QTY * isnull(ie.CONVERT_TO_CELL ,1) )				as CONFIRM_QTY_CELL
													 ,CEILING(t0.QTY * isnull(ie.CONVERT_TO_PC_ROLL_LENGTH ,1) )		as CONFIRM_QTY_ROLL_LENGTH
													 ,ie.PACKAGE_TYPE_CODE												as PACKAGE_TYPE_CODE
													 ,ie.BOX_PER_CUT
													 ,ie.STEELCRATE_PER_CUT
													 ,ie.STEELRACK_PER_CUT
													 ,ie.ELECTRODE_POST_OPER
													 ,ie.CELL_TYPE
													 ,ISNULL(pe.QTY,0) 													as 	SHIPPING_PLAN_QTY
												 FROM SSP_ANL_SHIP_REQ_EE T0 WITH(NOLOCK)
													  INNER JOIN [DBO].[SCP_MST_BOD_N_V] tt1 ON t0.FROM_DIVISION_ID = tt1.division_id  AND t0.bod_id = tt1.bod_id
													  INNER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)
												   ON t0.from_DIVISION_ID = tt2.DIVISION_ID
												  AND t0.FROM_SITE = tt2.SCM_SITE_ID
												  AND tt2.site_type		= 'PLANT'
												  AND tt2.valid_yn		= 'Y'
													  INNER JOIN SSP_MST_SITE_ITEM_EE_V IE ON ie.division_id = t0.FROM_DIVISION_ID and ie.SCM_SITE_ID = t0.FROM_SITE and ie.ITEM_ID  = t0.ITEM_ID
													  LEFT OUTER JOIN SSP_ANL_SHIP_PLAN_EE PE WITH(NOLOCK)
												   ON pe.MEASURE = 'P_SHIP_PLAN_SIMU_ETD'
												  AND pe.PLAN_START_YYYYMMDD =  @v_plan_start_yyyymmdd
												  AND pe.division_id = ie.DIVISION_ID and pe.SCM_SITE_ID = ie.SCM_SITE_ID and pe.ITEM_ID  = ie.ITEM_ID and pe.YYYYMMDD = T0.ETD_DATE
												WHERE 1 = 1
												  AND t0.FROM_DIVISION_ID =  @DIVISION_ID
												  AND t0.FROM_COMPANY_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@COMPANY_ID,',') ) 
												  AND t0.ETD_DATE >=  @v_from_yyyymmdd 		AND t0.ETD_DATE <=  @v_to_yyyymmdd
											  ) t
										WHERE 1 = 1
										  AND t.YYYYMMDD >= t.FROZEN_YYYYMMDD
									   ) A
										 INNER JOIN   [DBO].[SCP_MST_BOD_N_V] b
									  ON (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id
										 LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'
										 LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO 
															FROM (
																 SELECT CONFIRM_ID ,CHANGE_REQ_NO
																	   ,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM
																   FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)
																  WHERE VALID_YN = 'Y'
																 ) A 
														  WHERE NUM = 1) H 
									  ON H.CONFIRM_ID = A.CONFIRM_ID
										 LEFT OUTER JOIN SSP_MST_MODEL_USER mu WITH(NOLOCK) on mu.division_id = a.origin_from_division_id and mu.from_site = a.from_site and mu.item_id = a.item_id and mu.valid_yn = 'Y'
										 LEFT OUTER JOIN TB_FX_User U2 WITH(NOLOCK) ON mu.user_id = u2.UserID AND U2.UseYN = 'Y'
										 LEFT OUTER JOIN TB_FX_User U3 WITH(NOLOCK) ON a.requestor = u3.UserID AND U3.UseYN = 'Y'
										 LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 WITH(NOLOCK)
									  ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO
								   WHERE 1=1
									 AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'') != '')
									 AND a.qty > 0
									 --ORDER BY a.division_id,   a.yyyymmdd,  a.item_id, a.from_site, a.to_site , a.ERP_SO_NO DESC
							   ) AA

				END
			END

			SET @v_insert_cnt = @@ROWCOUNT;
			SET @v_insert_sum = @v_insert_sum + @v_insert_cnt;


 			-----------------------------------------------------------
			-- TXN LOG
			-----------------------------------------------------------
			SET @v_log_type		= N'TXN';    --로그타입
			SET @n_log_count	= @v_insert_cnt; -- @@ROWCOUNT;
			SET @v_log_message	= N'INSERT INTO '+ @v_table_id;
			SET @d_event_date	= SYSDATETIME();
			SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121) + ' [DIVISION]: ' + @DIVISION_ID ;

			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
									  ,@p_log_type      =@v_log_type
									  ,@p_log_count     =@n_log_count
									  ,@p_log_message   =@v_log_message
									  ,@p_description   =@v_description
									  ,@p_event_date    =@d_event_date
									  ,@p_user_id       =@v_batch_user
									  ;


		END TRY

		BEGIN CATCH
 			-----------------------------------------------------------
			-- ERROR LOG
			-----------------------------------------------------------
			SET @v_log_type		= N'ERROR';
			SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description	= N'ERROR_LINE : ' + STR(ERROR_LINE());
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
									  ,@p_log_type      =@v_log_type
									  ,@p_log_count     =@n_log_count
									  ,@p_log_message   =@v_log_message
									  ,@p_description   =@v_description
									  ,@p_event_date    =@d_event_date
									  ,@p_user_id       =@v_batch_user
									  ;

			RETURN -1
		END CATCH;

		IF @COUNT_CHECK > 0
		BEGIN
			UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
			   SET ATTRIBUTE1 = @V_PLAN_START_YYYYMMDD
			 WHERE LOOKUP_TYPE = 'SSP_ANL_SHIP_PLAN_ALL'
			   AND SEGMENT1 = @EE_YN
			   AND SEGMENT2 = @DIVISION_ID
			   AND SEGMENT3 = @COMPANY_ID
		END

		SET @INX = @INX + 1


	END
 	-----------------------------------------------------------
	-- END LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'END';
    SET @v_log_message	= N'########## END of procedure ##########';
    SET @v_description	= N'';
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
							  ,@p_log_type      =@v_log_type
							  ,@p_log_count     =@v_insert_sum
							  ,@p_log_message   =@v_log_message
							  ,@p_description   =@v_description
							  ,@p_event_date    =@d_event_date
							  ,@p_user_id       =@v_batch_user
							  ;
    RETURN 1
END;
