

/*
 * Program ID   : SSP0002_SAVE_SHIPMENT_CONFIRM_NEW
 * Description  : Shipment Change Request NEW Confrim 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/15   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/10/26   ygkim		   Division 40 일 경우 Project Code 가져오는 로직 수정
 * 2019/02/21	AYJ			   [CSR ID:3929456] Shipment Confirm Request 신규아이템 입력 시 모델 유효성 체크
 * 2019/03/13	hwyoon		   [PJ20189106] 전지.GSCM 고도화 이행 PROJECT 유효ITEM 체크부분 오류수정
 * 2019/04/04	ayj			   [PJ20189106] 전지.GSCM 고도화 이행- 소형 컬럼추가
 * 2019/04/30	ayj			   [PJ20189106] 전지.GSCM 고도화 이행 REQUESTOR 컬럼 제거
 * 2019/05/07	ayj			   mkt owner select 분기처리
 * 2019/08/19	ayj			   EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN - 수정(@v_description)
 * 2019/11/07	ayj			   FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
 * 2021/02/03	KIMYONGHO	   DM 판가정보 Check Validation 적용
 */

CREATE PROCEDURE [dbo].[SSP0002_SAVE_SHIPMENT_CONFIRM_NEW]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_project_code		NVARCHAR(MAX)
	,@p_fcst_type			NVARCHAR(MAX)
	,@p_operation_group		NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_nick_name			NVARCHAR(MAX)
	,@p_shipment_date		NVARCHAR(MAX)
	,@p_shipment_qty		NVARCHAR(MAX)	
	,@p_incoterms			NVARCHAR(MAX)
	,@p_transport_mode		NVARCHAR(MAX)
	,@p_lt					NVARCHAR(MAX)
	,@p_etd					NVARCHAR(MAX)
	,@p_eta					NVARCHAR(MAX)
	,@p_route_id			NVARCHAR(MAX)
	,@p_bod_id				NVARCHAR(MAX)
	,@p_d_country			NVARCHAR(MAX)
	,@p_d_port_code			NVARCHAR(MAX)
	,@p_a_conuntry			NVARCHAR(MAX)
	,@p_a_port_code			NVARCHAR(MAX)
	,@p_to_country			NVARCHAR(MAX)
	,@p_to_city				NVARCHAR(MAX)
	,@p_electrode_yn		NVARCHAR(MAX)
	,@p_origin_from_division_id		NVARCHAR(MAX)
	,@p_origin_to_division_id		NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_time_zone			NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_new_confirm_id		NVARCHAR(max);
	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(MAX);
	DECLARE @v_seq					NVARCHAR(MAX);
	DECLARE @v_from_site_type       NVARCHAR(MAX);
	DECLARE @v_from_site_plant_id       NVARCHAR(MAX);
	DECLARE @v_from_site_vendor_id      NVARCHAR(MAX);
	DECLARE @v_from_site_company_id		NVARCHAR(MAX);
	DECLARE @v_from_site_soldto_code	NVARCHAR(MAX);
	DECLARE @v_from_site_shipto_code	NVARCHAR(MAX);

	DECLARE @v_to_site_type				NVARCHAR(MAX);
	DECLARE @v_to_site_plant_id			NVARCHAR(MAX);
	DECLARE @v_to_site_vendor_id		NVARCHAR(MAX);
	DECLARE @v_to_site_company_id		NVARCHAR(MAX);
	DECLARE @v_to_site_soldto_code		NVARCHAR(MAX);
	DECLARE @v_to_site_shipto_code		NVARCHAR(MAX);
	DECLARE @v_eta						NVARCHAR(MAX);

	DECLARE @v_last_update_date			datetime;

	DECLARE @v_sales_price_check_cnt    INTEGER = 0;
	DECLARE @v_mkt_fcst_check_cnt		INTEGER = 0;

	
	SET @v_from_site_type			= NULL
	SET @v_from_site_plant_id		= NULL
	SET @v_from_site_vendor_id		= NULL
	SET @v_from_site_company_id		= NULL
	SET @v_from_site_soldto_code	= NULL
	SET @v_from_site_shipto_code	= NULL

	SET @v_to_site_type				= NULL
	SET @v_to_site_plant_id			= NULL
	SET @v_to_site_vendor_id		= NULL
	SET @v_to_site_company_id		= NULL
	SET @v_to_site_soldto_code		= NULL
	SET @v_to_site_shipto_code		= NULL
	SET @v_eta						= NULL

	SET @v_sales_price_check_cnt	= 0
	SET @v_mkt_fcst_check_cnt	= 0

	--SET @v_last_update_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0002_SAVE_SHIPMENT_CONFIRM_NEW';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;	

	-- validation 변수 설정
	DECLARE @v_val_code  INT=0;
	
	-- 트렌젝션 시작
	--BEGIN TRAN;

	BEGIN TRY




-- 임시 방편 
     SELECT  @p_origin_from_division_id =  DIVISION_ID  
	 FROM SCM_MST_SITE WITH(NOLOCK) 
	 WHERE SCM_SITE_ID  = @p_from_site 
	 AND   DIVISION_ID =  @p_division_id
	 AND   VALID_YN  = 'Y'
	 ;
	IF @p_project_code = '-'
		BEGIN
			SET @p_project_code = '';
		END		

	IF @p_operation_group <> 'E'
		BEGIN
		     SET @p_origin_to_division_id = @p_origin_from_division_id ;
		END   
    ELSE
	    BEGIN 

			 SELECT  @p_origin_to_division_id =  DIVISION_ID  
			 FROM SCM_MST_SITE WITH(NOLOCK) 
			 WHERE SCM_SITE_ID  = @p_to_site 
			 AND   VALID_YN  = 'Y'
			 AND   SITE_TYPE  = 'PLANT'
			 ;
		
		END   
----------------------------------------------------------------


			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';

		DECLARE @v_cnt_item_id	INT =0;
		SET @v_cnt_item_id = ISNULL((
								select COUNT(DIVISION_ID) from (
										SELECT distinct
											D.DIVISION_ID
										FROM [SCM_MST_SITE_ITEM]			I WITH(NOLOCK)	     
										JOIN [SCM_MST_DIVISION]			D WITH(NOLOCK) ON I.DIVISION_ID  = D.DIVISION_ID
										JOIN [SCM_MST_SITE]				S WITH(NOLOCK) ON I.DIVISION_ID  = S.DIVISION_ID AND I.SCM_SITE_ID  = S.SCM_SITE_ID	
										JOIN [SCM_MST_ITEM_SN]			T WITH(NOLOCK) ON I.DIVISION_ID  = T.DIVISION_ID AND I.ITEM_ID      = T.ITEM_ID  
										LEFT OUTER JOIN [SCM_MST_PROJECT] P WITH(NOLOCK) ON I.DIVISION_ID  = P.DIVISION_ID AND I.PROJECT_CODE = P.PROJECT_CODE
										WHERE 1=1
										AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END IN (SELECT token FROM dbo.String_Split(@p_division_id  ,','))
										--AND CASE WHEN p_to_site = 'ALL' THEN 'ALL' ELSE I.SCM_SITE_ID END IN (SELECT token FROM dbo.String_Split(p_to_site  ,','))
										AND I.PROJECT_CODE LIKE '%' + @p_project_code + '%' 
										AND (      I.ITEM_ID   LIKE '%' + @p_item_id + '%' 
												OR T.ITEM_NAME LIKE '%' + @p_item_id + '%'
												OR T.NICK_NAME LIKE '%' + @p_item_id + '%')
								
															)a
							  ),0);

		-- VALIDATION 체크
		-- 1:해당 MODEL 있음
		-- 0:해당 MODEL 없음
		--SET @v_cnt_item_id = 1;

		IF @v_cnt_item_id > 0
			SET @v_val_code = 1;
		ELSE 
			SET @v_val_code = 0;

		IF( @v_val_code = 1)
		BEGIN

			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();--[dbo].[FN_MULTY_TIME](@p_time_zone);
			--EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			--//2019-08-19 : NEW CONFIRM 생성 CHECK 확인==========================================================================================
			--//ORG
				--SET @v_new_confirm_id = 'C'+CONVERT(VARCHAR(8), [dbo].[FN_MULTY_TIME](@p_time_zone), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID),6)
			--//REVERSION
				DECLARE @v_tmp_fn_time_zone NVARCHAR(8);
				DECLARE @v_tmp_seq_confirm	NVARCHAR(20);
				SET @v_tmp_fn_time_zone = CONVERT(VARCHAR(8), [dbo].[FN_MULTY_TIME](@p_time_zone), 112);
				SET @v_tmp_seq_confirm = CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID);
				SET @v_new_confirm_id = 'C'+@v_tmp_fn_time_zone + RIGHT('000000' + @V_TMP_SEQ_CONFIRM,6)
			--//====================================================================================================================================
			SELECT @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
					,@v_seq                 = MAX(PLAN_SEQ)
			FROM   SSP_PLAN_VERSION_V WITH(NOLOCK)
			WHERE  PLAN_TYPE    = 'SP'
			AND    DIVISION_ID  = @p_division_id 
			AND    CONFIRM_FLAG = 'Y'
			AND    PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
								FROM SSP_PLAN_VERSION_V T WITH(NOLOCK)
								WHERE T.DIVISION_ID = @p_division_id 
								AND   T.plan_type  = 'SP'
								AND   T.CONFIRM_FLAG = 'Y');
		
			DECLARE @tmp_division_id NVARCHAR(100) = ''
			
			SELECT @tmp_division_id = @p_origin_from_division_id 
			SELECT @v_from_site_type 		= dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_from_site, 'SITE_TYPE')
			SELECT @v_from_site_plant_id  = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_from_site, 'PLANT_ID')
			SELECT @v_from_site_vendor_id = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_from_site, 'VENDOR_ID')
			SELECT @v_from_site_company_id = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_from_site, 'COMPANY_ID')
			SELECT @v_from_site_soldto_code = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_from_site, 'SOLDTO_CODE')
			SELECT @v_from_site_shipto_code = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_from_site, 'SHIPTO_CODE')
		
			SELECT @tmp_division_id = CASE WHEN @p_division_id = 'EE' THEN @p_origin_from_division_id ELSE @p_origin_to_division_id END
			SELECT @v_to_site_type 		= dbo.FN_GET_SSP_SITE_INFO_EXCEPTION(@tmp_division_id,@p_from_site, @p_to_site, 'SITE_TYPE')
			SELECT @v_to_site_plant_id  = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_to_site, 'PLANT_ID')
			SELECT @v_to_site_vendor_id = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_to_site, 'VENDOR_ID')
			SELECT @v_to_site_company_id = dbo.FN_GET_SSP_SITE_INFO_EXCEPTION(@tmp_division_id,@p_from_site, @p_to_site, 'COMPANY_ID')
			SELECT @v_to_site_soldto_code = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_to_site, 'SOLDTO_CODE')
			SELECT @v_to_site_shipto_code = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @p_to_site, 'SHIPTO_CODE')


			--SELECT @v_from_site_type = (CASE WHEN FS.SITE_TYPE = 'SALES' THEN 'A' WHEN FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'N' THEN 'B' 
			--								 WHEN FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'Y' THEN 'C'  END) 
			--	, @v_from_site_plant_id = FS.LOGISTIC_PLANT_ID 
			--	, @v_from_site_vendor_id = (CASE WHEN FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'Y' THEN FS.PLANT_ID  END)  
			--	, @v_from_site_company_id = FS.COMPANY_ID
			--FROM SCM_MST_SITE FS  WITH(NOLOCK)
			--WHERE  FS.DIVISION_ID = CASE WHEN @p_division_id = 'EE' THEN @p_origin_from_division_id ELSE @p_origin_from_division_id END
			--  AND FS.SCM_SITE_ID = @p_from_site 
			--  AND FS.VALID_YN    = 'Y' 
		
			--SELECT @v_from_site_soldto_code = FC.SOLDTO_CODE   
			--	, @v_from_site_shipto_code = FC.SHIPTO_CODE   
			--FROM SCM_MST_SITE_CUSTOMER FC  WITH(NOLOCK)
			--WHERE FC.DIVISION_ID = CASE WHEN @p_division_id = 'EE' THEN @p_origin_from_division_id ELSE @p_origin_from_division_id END
			--  AND FC.SCM_SITE_ID = @p_from_site
			--  AND FC.VALID_YN    = 'Y'
			--  AND FC.REP_YN      = 'Y'
		
			--SELECT @v_to_site_type = CASE WHEN TS.SITE_TYPE = 'SALES' THEN 'A' -- Sales Site' -- FROM_SITE_TYPE
			--			WHEN TS.SITE_TYPE = 'PLANT' AND TS.OSP_YN = 'N' THEN 'B' -- Factory Site
			--			WHEN TS.SITE_TYPE = 'PLANT' AND TS.OSP_YN = 'Y' THEN 'C' -- Packer
			--		END                                                                            
			--	, @v_to_site_plant_id = TS.LOGISTIC_PLANT_ID
			--	, @v_to_site_vendor_id = CASE WHEN TS.SITE_TYPE = 'PLANT' AND TS.OSP_YN = 'Y' THEN TS.PLANT_ID END
			--	, @v_to_site_company_id = TS.COMPANY_ID             
			--FROM SCM_MST_SITE TS  WITH(NOLOCK)
			--WHERE TS.DIVISION_ID = CASE WHEN @p_division_id = 'EE' THEN @p_origin_from_division_id ELSE @p_origin_to_division_id END
			--  AND TS.SCM_SITE_ID = @p_to_site
			--  AND TS.VALID_YN    = 'Y' 

			--SELECT @v_to_site_soldto_code = TC.SOLDTO_CODE
			--	, @v_to_site_shipto_code = TC.SHIPTO_CODE
			--FROM SCM_MST_SITE_CUSTOMER TC  WITH(NOLOCK)
			--WHERE TC.DIVISION_ID = CASE WHEN @p_division_id = 'EE' THEN @p_origin_from_division_id ELSE @p_origin_to_division_id END
			--  AND TC.SCM_SITE_ID = @p_to_site
			--  AND TC.VALID_YN    = 'Y' 
			--  AND TC.REP_YN      = 'Y'
		
			--mkt owner select
			IF @p_division_id = '40'
				BEGIN
					DECLARE @prj_cnt int = 0;

					SET @prj_cnt = (SELECT COUNT(PROJECT_CODE) CNT
									FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
									WHERE DIVISION_ID = @p_division_id
										AND SCM_SITE_ID = @p_to_site
										AND ITEM_ID = @p_item_id
										AND PROJECT_CODE = @p_project_code
								)
					;

					IF (@prj_cnt=0)
					BEGIN
						SELECT top 1 @p_project_code = project_code
						FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
						WHERE DIVISION_ID = @p_division_id
						  AND SCM_SITE_ID = @p_to_site
						  AND ITEM_ID = @p_item_id
						;	
					END

				END

			
			/*
			판가 입력 정보 조회 
			52주 구간 전부에 입력이 안되어있으면 신규 생성 불가 
			현재 SSP는 내/외수를 구분하지 않기 때문에 DOM_EXP 타입을 'DOM'로 강제로 설정 후 처리하였음(한개로 처리하기 위해서)
			*/
			SELECT  @v_sales_price_check_cnt = COUNT(*)  FROM 
			(
				SELECT DISTINCT division_id, project_code, scm_site_id, plant_site_id, item_id,  measure, 'DOM' AS DOM_EXP, fcst_type,incoterms,  count(*)  AS CNT
				FROM SCM_MST_FUTURE_PRICE A WITH(NOLOCK)
				INNER JOIN SCM_SYS_CALENDAR_M B
				ON A.YYYYMMDD = B.BASIS_YYYYMMDD
				AND B.DAYOFWEEK = 'MON'
				LEFT JOIN (
							SELECT MIN(BASIS_START_DATE) BASIS_START_DATE,    MAX(BASIS_END_DATE) AS BASIS_END_DATE
								FROM [DBO].[SCM_SYS_CALENDAR_M] M WITH(NOLOCK) 
									WHERE M.BASIS_YYYYMMDD BETWEEN CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
															   AND CONVERT(CHAR(8), DATEADD(WW, 12, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 12주후 월요일까지			
							) M
				ON 1=1
				WHERE 1=1
				AND A.DIVISION_ID	= @p_division_id
				AND A.PROJECT_CODE	= @p_project_code
				AND A.SCM_SITE_ID   = @p_to_site
				--AND A.PLANT_SITE_ID = CASE WHEN @p_division_id = '81' THEN @p_from_site ELSE '' END
				AND A.ITEM_ID		= @p_item_id
				AND A.FCST_TYPE		= @p_fcst_type
				AND A.INCOTERMS		= @p_incoterms
				AND A.MEASURE		= 'KRW'				
				--AND A.DOM_EXP		= @p_dom_exp
				AND A.FCST_TYPE NOT IN (  SELECT SEGMENT2
											FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
											WHERE 1=1
											AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
											AND MST.SEGMENT1     = 'FCST_TYPE'
											AND VALID_YN        = 'Y' 
											) 

				AND A.yyyymmdd BETWEEN m.BASIS_START_DATE AND m.BASIS_END_DATE
				--and a.yyyymmdd >= ''
				GROUP BY division_id, project_code, scm_site_id, plant_site_id, item_id,  measure, dom_exp,fcst_type,incoterms
				HAVING COUNT(*) = 13
			) XX
			;

			IF @v_sales_price_check_cnt > 1
				SET @v_sales_price_check_cnt = 1;

			-- 해당 LOOKUP 등록 정보는 판가입력 정보를 Check 하지 않음.
			SELECT @v_mkt_fcst_check_cnt = COUNT(*) 
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
			WHERE 1=1
			AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
			AND MST.SEGMENT1    = 'FCST_TYPE'
			AND VALID_YN        = 'Y' 
			AND SEGMENT2		= @p_fcst_type
			;

			-- 법인간 거래이면 판가입력 정보를 Check 하지 않음.
			IF (@v_from_site_type = 'B' AND @v_to_site_type = 'B' ) OR (@v_from_site_type = 'B' AND @v_to_site_type = 'C' ) OR (@v_from_site_type = 'C' AND @v_to_site_type = 'C' ) OR (@v_from_site_type = 'C' AND @v_to_site_type = 'B' )
				SET @v_sales_price_check_cnt  =  1;


			-- 판가 정보없고, 법인간 거래가 아니거나, LOOKUP에 등록된 FCST_TYPE이 아니면 RETURN
			IF @v_sales_price_check_cnt = 1
				SET @v_sales_price_check_cnt  =  1;
			ELSE
				IF @v_mkt_fcst_check_cnt = 1 
					BEGIN
						SET @v_sales_price_check_cnt  =  1;
					END 
				ELSE
					BEGIN
						SELECT  'F' AS result_code;
						RETURN;
					END 

			SET @p_shipment_date = REPLACE(SUBSTRING(@p_shipment_date,1,10),'-','')
			SET @p_etd = REPLACE(SUBSTRING(@p_etd,1,10),'-','')
			--SET @p_eta = REPLACE(SUBSTRING(@p_eta,1,10),'-','')
			SET @v_eta = [dbo].[FN_GET_SSP_ETA_DATE](@p_division_id, @p_bod_id, @p_shipment_date) 

			SET @v_last_update_date    = SYSDATETIME();

			IF @p_project_code = '' OR @p_project_code IS NULL
			BEGIN
				SET @p_project_code = '-';
			END		


			INSERT INTO SSP_ANL_SHIP_CONFIRM(
							CONFIRM_ID ,SHIPMENT_STATUS ,DIVISION_ID ,PLAN_START_YYYYMMDD ,PLAN_TYPE ,SEQ ,ITEM_ID ,FROM_SITE ,TO_SITE
								,YYYYMMDD ,PLANNED_QTY ,QTY ,BOD_ID ,ROUTE_ID ,BIZ_TYPE ,PROJECT_CODE ,FCST_TYPE ,FCST_ETD_DATE
								,FCST_ETA_DATE ,ETD_DATE ,ETA_DATE ,INCOTERMS ,TRANSPORT_MODE ,D_COUNTRY ,D_PORT_CODE ,A_COUNTRY
								,A_PORT_CODE ,CUSTOMER_LT ,TO_COUNTRY ,TO_CITY ,FROM_SITE_TYPE ,FROM_SITE_PLANT_ID ,FROM_SITE_VENDOR_ID
								,FROM_SITE_SOLDTO_CODE ,FROM_SITE_SHIPTO_CODE ,FROM_SITE_COMPANY_ID ,TO_SITE_TYPE ,TO_SITE_PLANT_ID
								,TO_SITE_VENDOR_ID ,TO_SITE_SOLDTO_CODE ,TO_SITE_SHIPTO_CODE ,TO_SITE_COMPANY_ID  ,CHANGE_TYPE
								,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE
								,ELECTRODE_YN ,ORIGIN_FROM_DIVISION_ID ,ORIGIN_TO_DIVISION_ID ,BEFORE_QTY ,CHECK_NEED_YN	
				) VALUES
				(
							@v_new_confirm_id, 'C', @p_division_id, @v_plan_start_yyyymmdd, 'SP', @v_seq, @p_item_id, @p_from_site, @p_to_site
							,@p_shipment_date, 0, @p_shipment_qty, @p_bod_id, @p_route_id, @p_operation_group, @p_project_code, @p_fcst_type, @p_etd
							,@v_eta, @p_etd, @v_eta, @p_incoterms, @p_transport_mode, @p_d_country, @p_d_port_code, @p_a_conuntry
							,@p_a_port_code, @p_lt, @p_to_country, @p_to_city, @v_from_site_type, @v_from_site_plant_id, @v_from_site_vendor_id
							,@v_from_site_soldto_code, @v_from_site_shipto_code, @v_from_site_company_id, @v_to_site_type, @v_to_site_plant_id
							,@v_to_site_vendor_id, @v_to_site_soldto_code, @v_to_site_shipto_code, @v_to_site_company_id, 'N'
							,@p_user_id, @v_last_update_date, @p_user_id, @v_last_update_date
							,@p_electrode_yn, @p_origin_from_division_id, @p_origin_to_division_id, 0, 'Y'
				);	

			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code, @v_new_confirm_id as ConfrimID ;
		
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			--SET @v_description = '';
			SET @v_description = 'Confrim_ID : ' + @v_new_confirm_id + ' / Time Zone : ' + @v_tmp_fn_time_zone + ' / Seq : ' + @v_tmp_seq_confirm;
			SET @d_event_date = @v_last_update_date;--[dbo].[FN_MULTY_TIME](@p_time_zone);
			--EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
			--COMMIT TRAN;	
			
		END
		ELSE IF	( @v_val_code = 0)
			SELECT  'N' AS result_code;		

	 END TRY

	 BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;
		END;
	END CATCH;
END

