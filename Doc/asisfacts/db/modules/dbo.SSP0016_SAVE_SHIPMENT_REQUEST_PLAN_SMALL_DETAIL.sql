/*
 * Program ID   : SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL
 * Description  : SSP Request(Small) 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/03/14	hwyoon			[PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
 * 2019/04/11   MCTheJ			Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT - HISTORY 내역 저장
 * 2019/05/24   MCTheJ			SSP_ANL_SHIP_REQ Data삭제시 History 저장 / Hold Qty 적용
 * 2019/05/24   MCTheJ			@v_data_end_yyyymmdd 오류 수
 * 2019/07/12   MCTheJ			Hold 수량 기준일적용(Ex. 20190701일 기준으로 재고수량 적용), 마이너스 Balance 날짜 오류 수정
 * 2019/11/07	ayj				FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
 * 2020/01/10	KIMYONHHO			WH_STOCK, BALANCE 재고 계산 로직 변경
 								[I]WH_STOC(Warehouse Stock)      : WH_STOC = OWMS 가용수량 ,  WH_STOC =  WH_STOC + WH_IN - SHIP_CONFIRM  - SHIP_REQ- POSTP_PLAN -  MES_FCS_HOLD수량 +  MES_FCS_RELEASE수량      
								[I]BALANCE(Balance)              : Balance :   WH_STOC -  SHIP_CONFIRM  - SHIP_REQ - POSTP_PLAN
 * 2020/06/25  KIMYONGHO		     HISTOORY TABLE ATRRIBUTE2 컬럼에 v_active_flag VALUE UPDATE
 */
CREATE PROCEDURE [dbo].[SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL]
	 @p_active_flag 		NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd NVARCHAR(MAX)
	,@p_plan_type			NVARCHAR(MAX)
	,@p_seq					NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_measure				NVARCHAR(MAX)
	,@p_yyyymmdd			NVARCHAR(MAX)
	,@p_bod_id				NVARCHAR(MAX)
	,@p_qty					NVARCHAR(MAX)
	,@p_route_id			NVARCHAR(MAX)
	,@p_incoterms			NVARCHAR(MAX)
	,@p_transport_mode		NVARCHAR(MAX)
	,@p_biz_type			NVARCHAR(MAX)
	,@p_project_code		NVARCHAR(MAX)
	,@p_fcst_type			NVARCHAR(MAX)
	,@p_confirm_id			NVARCHAR(MAX)
	,@p_req_mst_id			NVARCHAR(MAX)
	,@p_lt					NVARCHAR(MAX)
	,@p_grp_id				NVARCHAR(MAX)
	,@p_remark_grp_id		NVARCHAR(MAX)
	,@p_text				NVARCHAR(MAX)
	,@p_remark_text			NVARCHAR(MAX)
	,@p_now_date			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@debug_mode			NVARCHAR(MAX)='F'
AS

BEGIN
	
	--waitfor delay '0:0:10';

	--LOG 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0016_SAVE_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	--LOOP 변수
	DECLARE @v_delimiter NVARCHAR(1)					
	SET @v_delimiter = '^'								--//구분자('^')//--
	DECLARE @max_loop_cnt		 INTEGER = 0;			--//PARAM값의 구분자 갯수로 LOOP 시작
	DECLARE @mst_loop_cnt		 INTEGER = 0;
	DECLARE @mst_loop_remark_cnt INTEGER = 0;
	DECLARE @chk INT=0;
	DECLARE @grpChkCnt INT = 0;
	DECLARE @v_grp_id_temp		 NVARCHAR(MAX);  

	--PARAM 변수
	DECLARE @v_active_flag			NVARCHAR(MAX);  
	DECLARE @v_division_id			NVARCHAR(MAX);  
	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(MAX);
	DECLARE @v_data_start_yyyymmdd	NVARCHAR(8) = ''; -- BOH계산을 위한 기준 일자  
	DECLARE @v_min_start_yyyymmdd	NVARCHAR(8) = ''; -- BALANCE Min Where 조건  
	
	-- DATA 생성 마지막 일자    
	DECLARE @v_data_end_yyyymmdd   NVARCHAR(8) = '';
	
	DECLARE @v_plan_type			NVARCHAR(MAX);  
	DECLARE @v_seq					NVARCHAR(MAX);  
	DECLARE @v_item_id				NVARCHAR(MAX);  
	DECLARE @v_from_site			NVARCHAR(MAX);  
	DECLARE @v_to_site				NVARCHAR(MAX);  
	DECLARE @v_measure				NVARCHAR(MAX);  
	DECLARE @v_yyyymmdd				NVARCHAR(MAX);  
	DECLARE @v_bod_id				NVARCHAR(MAX);  
	DECLARE @v_qty					NVARCHAR(MAX);  
	DECLARE @v_route_id				NVARCHAR(MAX);  
	DECLARE @v_incoterms			NVARCHAR(MAX);  
	DECLARE @v_transport_mode       NVARCHAR(MAX);  
	DECLARE @v_biz_type				NVARCHAR(MAX);  
	DECLARE @v_project_code			NVARCHAR(MAX);  
	DECLARE @v_fcst_type			NVARCHAR(MAX);  
	DECLARE @v_confirm_id			NVARCHAR(MAX);  
	DECLARE @v_req_mst_id			NVARCHAR(MAX);  
	DECLARE @v_lt					NVARCHAR(MAX);  
	DECLARE @v_grp_id				NVARCHAR(MAX);  
	DECLARE @v_remark_grp_id		NVARCHAR(MAX);  
	DECLARE @v_text					NVARCHAR(MAX);  
	DECLARE @v_remark_text			NVARCHAR(MAX);  
	DECLARE @v_now_date				NVARCHAR(MAX);  
	DECLARE @v_user_id				NVARCHAR(MAX); 
	DECLARE @v_etd_date				NVARCHAR(MAX); 
	DECLARE @v_eta_date				NVARCHAR(MAX); 
	DECLARE @v_req_det_id			NVARCHAR(MAX); 
	DECLARE @v_delete_flag			NVARCHAR(1) = 'N';
	DECLARE @v_modify_flag			NVARCHAR(1) = 'N';

	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @v_org_created_by		NVARCHAR(MAX);
	DECLARE @v_creation_date		datetime	;
	DECLARE @v_org_creation_date	datetime	;
	DECLARE @v_last_updated_by		NVARCHAR(MAX);
	DECLARE @v_last_update_date		datetime	; 
	DECLARE @v_tmpqty NUMERIC(20, 10);

	DECLARE @v_working_time       datetime =sysdatetime();     

	SET @v_created_by       = @p_user_id;
	SET @v_creation_date    = @v_working_time;
	SET @v_last_updated_by  = @p_user_id;
	SET @v_last_update_date = @v_working_time;

	--상태변경 PARAM
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = @p_active_flag;
	DECLARE @recv_remark_flag		NVARCHAR(MAX);
	SET @recv_remark_flag = @p_remark_grp_id;
	SET @v_min_start_yyyymmdd = '';

	--마이너스 BALANCE COUNT
	DECLARE @v_minus_YYYYMMDD		NVARCHAR(MAX);  
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	BEGIN TRAN;
	BEGIN TRY
		--//LOG START///////////////////////////////////////////////--
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--//////////////////////////////////////////////////////////--

		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);		--//LOOP COUNT

		IF(@max_loop_cnt > 0)
		BEGIN
			--//공통 변수
			SET @v_division_id			= @p_division_id;
			SET @v_plan_start_yyyymmdd	= @p_plan_start_yyyymmdd;
			SET @v_plan_type			= @p_plan_type;
			SET @v_seq					= @p_seq;
			SET @v_item_id				= @p_item_id;
			SET @v_from_site			= @p_from_site;
			SET @v_measure				= @p_measure;
			SET @v_biz_type				= @p_biz_type;
			SET @v_confirm_id			= @p_confirm_id;
			SET @v_req_mst_id			= @p_req_mst_id;
			SET @v_now_date				= @p_now_date;
		END;

		--////////////////////////////////////////////////////////////////////////////////////////--
		--//						     REQUEST 수량 변경                                      //--
		--////////////////////////////////////////////////////////////////////////////////////////--
		IF(LEN(@recv_active_flag) > 0)
		BEGIN
			--//REQUEST 값에 따른 BALANCE값 체크
			--//1. TEMP TABLE 생성
			IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_REQ_UPDATE_BOH') IS NOT NULL
				DROP TABLE #tmp_SSP_ANL_SHIP_REQ_UPDATE_BOH

			IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_REQ_01') IS NOT NULL
				DROP TABLE #tmp_SSP_ANL_SHIP_REQ_01

			CREATE TABLE #tmp_SSP_ANL_SHIP_REQ_UPDATE_BOH 
			(
				DIVISION_ID        nvarchar(030)
				,PLAN_START_YYYYMMDD nvarchar(008)
				,PLAN_TYPE          nvarchar(050)
				,SEQ              INT 
				,ITEM_ID          nvarchar(050)
				,FROM_SITE          nvarchar(030)
				,TO_SITE          nvarchar(030)
				,MEASURE          nvarchar(050)
				,YYYYMMDD          nvarchar(008)
				,BOD_ID              nvarchar(150)
				,ss              numeric(20,10)
				,QTY              numeric(20,10)
				,INCOTERMS           nvarchar(010)   
				,TRANSPORT_MODE      nvarchar(050)    
				,PROJECT_CODE      nvarchar(050)
				,FCST_TYPE          nvarchar(020)
				,CONFIRM_ID          nvarchar(020)
			);

			CREATE TABLE #tmp_SSP_ANL_SHIP_REQ_01
			(
				DIVISION_ID             nvarchar(030),		PLAN_START_YYYYMMDD     nvarchar(008),				PLAN_TYPE               nvarchar(050),
				SEQ                     bigint,				ITEM_ID                 nvarchar(050),				FROM_SITE               nvarchar(030),
				TO_SITE                 nvarchar(030),		MEASURE                 nvarchar(050),				YYYYMMDD                nvarchar(008),
				BOD_ID                  nvarchar(150),		QTY                     numeric(20, 10),			ROUTE_ID                bigint,
				INCOTERMS               nvarchar(010),		TRANSPORT_MODE          nvarchar(050),				BIZ_TYPE                nvarchar(030),
				PROJECT_CODE            nvarchar(050),		FCST_TYPE               nvarchar(020),				FCST_ETD_DATE           nvarchar(008),
				FCST_ETA_DATE           nvarchar(008),		ETD_DATE                nvarchar(008),				ETA_DATE                nvarchar(008),
				CONFIRM_ID              nvarchar(020),		REQ_DET_ID              nvarchar(030),				REQ_MST_ID              nvarchar(030),
				REQ_GRP_ID              nvarchar(030),		REMARKS3                nvarchar(255),				CREATED_BY              nvarchar(150),
				CREATION_DATE           datetime,			LAST_UPDATED_BY         nvarchar(150),				LAST_UPDATE_DATE        datetime,
				ATTRIBUTE1              nvarchar(150),		ATTRIBUTE2              nvarchar(150),				ATTRIBUTE3              nvarchar(150),
				ATTRIBUTE4              nvarchar(150),		ATTRIBUTE5              nvarchar(150),				ATTRIBUTE6              nvarchar(150),
				ATTRIBUTE7              nvarchar(150),		ATTRIBUTE8              nvarchar(150),				ATTRIBUTE9              nvarchar(150),
				ATTRIBUTE10             nvarchar(150)
			);

			INSERT INTO #tmp_SSP_ANL_SHIP_REQ_01
			SELECT 
				DIVISION_ID,             		PLAN_START_YYYYMMDD,     				PLAN_TYPE,					SEQ,
				ITEM_ID,                 		FROM_SITE,TO_SITE,                 		MEASURE,					YYYYMMDD,
				BOD_ID,                  		QTY,	                     			ROUTE_ID,					INCOTERMS,
				TRANSPORT_MODE,          		BIZ_TYPE,								PROJECT_CODE,            	FCST_TYPE,
				FCST_ETD_DATE,					FCST_ETA_DATE,           				ETD_DATE,                	ETA_DATE,
				CONFIRM_ID,              		REQ_DET_ID,              				REQ_MST_ID,					REQ_GRP_ID,
				REMARKS3,          				CREATED_BY,								CREATION_DATE,           	LAST_UPDATED_BY,
				LAST_UPDATE_DATE,				ATTRIBUTE1,			              		ATTRIBUTE2,    				ATTRIBUTE3,
				ATTRIBUTE4,			       		ATTRIBUTE5,              				ATTRIBUTE6,					ATTRIBUTE7,
				ATTRIBUTE8,        				ATTRIBUTE9,								ATTRIBUTE10
			FROM SSP_ANL_SHIP_REQ WITH(NOLOCK)
			WHERE 1 = 1
			AND DIVISION_ID = @v_division_id
			AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND PLAN_TYPE = @v_plan_type
			AND SEQ = @v_seq
			AND ITEM_ID = @v_item_id
			AND FROM_SITE = @v_from_site
			AND REQ_MST_ID = @v_req_mst_id;

			--//2. LOOP 처리
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt = @mst_loop_cnt + 1;
				
				-- 각 컬럼들에 대한 스플릿처리로직 스타트
				BEGIN
					SET @v_active_flag		= dbo.SCM_ARR_SPL_VAL( @p_active_flag       , @v_delimiter, @mst_loop_cnt );
					SET @v_to_site			= dbo.SCM_ARR_SPL_VAL( @p_to_site           , @v_delimiter, @mst_loop_cnt );
					SET @v_yyyymmdd			= dbo.SCM_ARR_SPL_VAL( @p_yyyymmdd			, @v_delimiter, @mst_loop_cnt );
					SET @v_bod_id			= dbo.SCM_ARR_SPL_VAL( @p_bod_id			, @v_delimiter, @mst_loop_cnt );
					SET @v_qty				= dbo.SCM_ARR_SPL_VAL( @p_qty				, @v_delimiter, @mst_loop_cnt );
					SET @v_route_id			= dbo.SCM_ARR_SPL_VAL( @p_route_id			, @v_delimiter, @mst_loop_cnt );
					SET @v_incoterms		= dbo.SCM_ARR_SPL_VAL( @p_incoterms			, @v_delimiter, @mst_loop_cnt );
					SET @v_transport_mode	= dbo.SCM_ARR_SPL_VAL( @p_transport_mode	, @v_delimiter, @mst_loop_cnt );
					SET @v_project_code		= dbo.SCM_ARR_SPL_VAL( @p_project_code      , @v_delimiter, @mst_loop_cnt );
					SET @v_fcst_type		= dbo.SCM_ARR_SPL_VAL( @p_fcst_type			, @v_delimiter, @mst_loop_cnt );
					SET @v_lt				= dbo.SCM_ARR_SPL_VAL( @p_lt				, @v_delimiter, @mst_loop_cnt );
					SET @v_grp_id			= dbo.SCM_ARR_SPL_VAL( @p_grp_id			, @v_delimiter, @mst_loop_cnt );
					SET @v_text				= dbo.SCM_ARR_SPL_VAL( @p_text				, @v_delimiter, @mst_loop_cnt );
				END;

				IF @mst_loop_cnt > 0
				BEGIN
					--//2-1. 신규
					IF( @v_active_flag ='I') 
					BEGIN
						SET @v_modify_flag = 'Y';
						
						IF(@v_min_start_yyyymmdd = '' OR CONVERT(int, @v_min_start_yyyymmdd) > CONVERT(int, @v_yyyymmdd))
						BEGIN 
							SET @v_min_start_yyyymmdd = @v_yyyymmdd;
						END

						SET @v_etd_date = @v_yyyymmdd;
						SET @v_req_det_id = 'SRD'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('00000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_REQ_DET_ID),5);
						--SET @v_eta_date = convert(VARCHAR(8), dateadd(dd, convert(int, @v_lt), convert(datetime,@v_yyyymmdd)),112);
						
						/* 2019.11.07 출발일 기준 항차를 고려한 ETA_DATE 계산*/
						SET @v_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@p_division_id, @v_bod_id, @v_yyyymmdd) 


						INSERT INTO #tmp_SSP_ANL_SHIP_REQ_01
						(
							DIVISION_ID,			PLAN_START_YYYYMMDD,	PLAN_TYPE,		SEQ,			ITEM_ID,			FROM_SITE,
							TO_SITE,				MEASURE,				YYYYMMDD,		BOD_ID,			QTY,				ROUTE_ID,
							INCOTERMS,				TRANSPORT_MODE,			BIZ_TYPE,		PROJECT_CODE,	FCST_TYPE,			FCST_ETD_DATE,
							FCST_ETA_DATE,			ETD_DATE,				ETA_DATE,		CONFIRM_ID,		REQ_DET_ID,			REQ_MST_ID,
							REQ_GRP_ID,				REMARKS3,				CREATED_BY,		CREATION_DATE,	LAST_UPDATED_BY,	LAST_UPDATE_DATE
						)
						VALUES
						(
							@v_division_id,		@v_plan_start_yyyymmdd,	@v_plan_type,	@v_seq,				@v_item_id,			@v_from_site,
							@v_to_site,			@v_measure,				@v_yyyymmdd,	@v_bod_id,			@v_qty,				@v_route_id,
							@v_incoterms,		@v_transport_mode,		@v_biz_type,	@v_project_code,	@v_fcst_type,		@v_etd_date,
							@v_eta_date,		@v_etd_date,			@v_eta_date,	@v_confirm_id,		@v_req_det_id,		@v_req_mst_id,
							@v_grp_id,			@v_text,				@v_created_by,	@v_creation_date,	@v_last_updated_by,	@v_last_update_date
						);

					END	--// 신규 END
					--//2-2. 수정
					ELSE IF(@v_active_flag ='M')
					BEGIN
						SET @v_modify_flag = 'Y';
						SET @v_etd_date = @v_yyyymmdd;

						IF(@v_etd_date = '-')
						BEGIN
							-- To site / Project Code / Fcst Type / Incoterms / Bod 수정 건
							UPDATE #tmp_SSP_ANL_SHIP_REQ_01
								SET	TO_SITE				= @v_to_site
									, BOD_ID			= @v_bod_id
									, ROUTE_ID			= @v_route_id
									, INCOTERMS			= @v_incoterms
									, TRANSPORT_MODE	= @v_transport_mode
									, PROJECT_CODE		= @v_project_code
									, FCST_TYPE			= @v_fcst_type
									, LAST_UPDATED_BY	= @v_last_updated_by
									, LAST_UPDATE_DATE	= @v_last_update_date
							WHERE DIVISION_ID			= @v_division_id
								AND PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
								AND PLAN_TYPE			= @v_plan_type
								AND SEQ					= @v_seq
								AND ITEM_ID				= @v_item_id
								AND FROM_SITE			= @v_from_site
								AND MEASURE				= @v_measure
								AND BIZ_TYPE			= @v_biz_type
								AND REQ_MST_ID			= @v_req_mst_id
								AND REQ_GRP_ID			= @v_grp_id
						END
						ELSE
						BEGIN
							--Qty 신규입력 또는 수정 건
							--SET @v_eta_date = convert(VARCHAR(8), dateadd(dd, convert(int, @v_lt), convert(datetime,@v_yyyymmdd)),112);
							--SET @v_eta_date = convert(VARCHAR(8), convert(datetime,@v_yyyymmdd),112);

							/* 2019.11.07 출발일 기준 항차를 고려한 ETA_DATE 계산*/
							SET @v_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@p_division_id, @v_bod_id, @v_yyyymmdd) 
							
							
							IF(@v_min_start_yyyymmdd = '' OR CONVERT(int, @v_min_start_yyyymmdd) > CONVERT(int, @v_yyyymmdd))
							BEGIN 
								SET @v_min_start_yyyymmdd = @v_yyyymmdd;
							END
										
							SELECT 
								@chk = COUNT(*)
							FROM #tmp_SSP_ANL_SHIP_REQ_01 WITH(NOLOCK)
							WHERE DIVISION_ID			= @v_division_id
								AND PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
								AND PLAN_TYPE			= @v_plan_type
								AND SEQ					= @v_seq
								AND ITEM_ID				= @v_item_id
								AND FROM_SITE			= @v_from_site
								AND MEASURE				= @v_measure
								AND YYYYMMDD			= @v_yyyymmdd
								AND BIZ_TYPE			= @v_biz_type
								AND REQ_MST_ID			= @v_req_mst_id
								AND REQ_GRP_ID			= @v_grp_id;

							IF(@chk > 0)
							BEGIN
								UPDATE #tmp_SSP_ANL_SHIP_REQ_01
									SET  TO_SITE				= @v_to_site
										, BOD_ID			= @v_bod_id
										, QTY				= @v_qty
										, ROUTE_ID			= @v_route_id
										, INCOTERMS			= @v_incoterms
										, TRANSPORT_MODE	= @v_transport_mode
										, PROJECT_CODE		= @v_project_code
										, FCST_TYPE			= @v_fcst_type
										, FCST_ETD_DATE		= @v_etd_date
										, FCST_ETA_DATE		= @v_eta_date
										, ETD_DATE			= @v_etd_date
										, ETA_DATE			= @v_eta_date
										, LAST_UPDATED_BY	= @v_last_updated_by
										, LAST_UPDATE_DATE	= @v_last_update_date
								WHERE DIVISION_ID		= @v_division_id
								AND PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
								AND PLAN_TYPE			= @v_plan_type
								AND SEQ					= @v_seq
								AND ITEM_ID				= @v_item_id
								AND FROM_SITE			= @v_from_site
								AND MEASURE				= @v_measure
								AND YYYYMMDD			= @v_yyyymmdd
								AND BIZ_TYPE			= @v_biz_type
								AND REQ_MST_ID			= @v_req_mst_id
								AND REQ_GRP_ID			= @v_grp_id
							END
							ELSE
							BEGIN
								---//최초 생성자 찾기

								SELECT TOP 1
									@v_org_created_by = CREATED_BY, @v_org_creation_date = MIN(CREATION_DATE)
								FROM #tmp_SSP_ANL_SHIP_REQ_01 WITH(NOLOCK)
								WHERE DIVISION_ID			= @v_division_id
								AND PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
								AND PLAN_TYPE			= @v_plan_type
								AND SEQ					= @v_seq
								AND ITEM_ID				= @v_item_id
								AND FROM_SITE			= @v_from_site
								AND MEASURE				= @v_measure
								AND BIZ_TYPE			= @v_biz_type
								AND REQ_MST_ID			= @v_req_mst_id
								AND REQ_GRP_ID			= @v_grp_id
								GROUP BY CREATED_BY
								

								INSERT INTO #tmp_SSP_ANL_SHIP_REQ_01
								(
									DIVISION_ID,		PLAN_START_YYYYMMDD,	PLAN_TYPE,		SEQ,			ITEM_ID,			FROM_SITE,
									TO_SITE,			MEASURE,				YYYYMMDD,		BOD_ID,			QTY,				ROUTE_ID,
									INCOTERMS,			TRANSPORT_MODE,			BIZ_TYPE,		PROJECT_CODE,	FCST_TYPE,			FCST_ETD_DATE,
									FCST_ETA_DATE,		ETD_DATE,				ETA_DATE,		CONFIRM_ID,		REQ_DET_ID,			REQ_MST_ID,
									REQ_GRP_ID,			REMARKS3,				CREATED_BY,		CREATION_DATE,	LAST_UPDATED_BY,	LAST_UPDATE_DATE
								)
								VALUES
								(
									@v_division_id,		@v_plan_start_yyyymmdd,	@v_plan_type,	@v_seq,			@v_item_id,			@v_from_site,
									@v_to_site,			@v_measure,				@v_yyyymmdd,	@v_bod_id,		@v_qty,				@v_route_id,
									@v_incoterms,		@v_transport_mode,		@v_biz_type,	@v_project_code,@v_fcst_type,		@v_etd_date,
									@v_eta_date,		@v_etd_date,			@v_eta_date,	@v_confirm_id,
									('SRD'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('00000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_REQ_DET_ID),5)),
									@v_req_mst_id,
									@v_grp_id,			@v_text,				@v_org_created_by,	@v_org_creation_date, @v_last_updated_by,@v_last_update_date
								);
							END
						END
					END --// 수정 END
					--//2-3. 삭재
					ELSE IF(@v_active_flag ='D')
					BEGIN
						DELETE FROM #tmp_SSP_ANL_SHIP_REQ_01
						WHERE DIVISION_ID = @v_division_id
							AND REQ_MST_ID = @v_req_mst_id
							AND REQ_GRP_ID = @v_grp_id
							AND FROM_SITE = @v_from_site

						SET @v_delete_flag = 'Y';
						
					END --// 삭재 END

					--History 내역저장
					IF(@v_qty = '' OR @v_qty IS NULL)
					BEGIN
						SET @v_tmpqty = 0.0;
					END
					ELSE
					BEGIN 
						SET @v_tmpqty = CONVERT(INT, @v_qty);
					END
					INSERT INTO SSP_ANL_SHIP_REQ_H
					(
						HISTORY_SEQ,		
						DIVISION_ID,		PLAN_START_YYYYMMDD,		PLAN_TYPE,				SEQ,					ITEM_ID,
						FROM_SITE,			TO_SITE,					MEASURE,				YYYYMMDD,				BOD_ID,
						QTY,				ROUTE_ID,					INCOTERMS,				TRANSPORT_MODE,			BIZ_TYPE,
						PROJECT_CODE,		FCST_TYPE,					FCST_ETD_DATE,			FCST_ETA_DATE,			ETD_DATE,
						ETA_DATE,			CONFIRM_ID,					REQ_DET_ID,				
						REQ_MST_ID,			REQ_GRP_ID,
						CREATED_BY,			CREATION_DATE,				LAST_UPDATED_BY,		LAST_UPDATE_DATE,
						ATTRIBUTE1,		ATTRIBUTE2,		HISTORY_CREATION_DATE
					)
					VALUES
					(
						NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_REQ_H,
						@v_division_id,		@v_plan_start_yyyymmdd,		@v_plan_type,			@v_seq,					@v_item_id,
						@v_from_site,		@v_to_site,					@v_measure,				@v_yyyymmdd,			@v_bod_id,
						@v_tmpqty,			ISNULL(@v_route_id, 0),		@v_incoterms,			@v_transport_mode,		@v_biz_type,
						@v_project_code,	@v_fcst_type,				@v_etd_date,			@v_eta_date,			@v_etd_date,
						@v_eta_date,		@v_confirm_id,				('SRD'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('00000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_REQ_DET_ID),5)),
						@v_req_mst_id,		@v_grp_id,
						@v_created_by,		@v_creation_date,			@v_last_updated_by,		@v_last_update_date,
						@v_active_flag,	@v_active_flag,	GETDATE()
					);	
					
				END		--// @mst_loop_cnt IF END
			END;	--//WHILE END

			--// 3. 최근 REQ 정보 확인 /////////////////////////////////////////////////////////////////--
			SELECT 
				@v_plan_start_yyyymmdd  = MAX(PLAN_START_YYYYMMDD),
				@v_plan_type            = MAX(PLAN_TYPE),
				@v_seq                  = MAX(SEQ),
				@v_data_start_yyyymmdd =  MAX(REQ_IN_START_DATE)  -- 해당 REQ에 입력시작일자부터 계산 
			FROM SSP_MST_SHIP_REQ WITH(NOLOCK)
			WHERE PLAN_TYPE    = @v_plan_type
				AND DIVISION_ID  = @v_division_id 
				--AND CONFIRM_FLAG = 'Y'
				AND PLAN_START_YYYYMMDD = (
											SELECT MAX(PLAN_START_YYYYMMDD)
											FROM SSP_MST_SHIP_REQ T WITH(NOLOCK)
											WHERE T.DIVISION_ID = @v_division_id 
												AND T.PLAN_TYPE   = @v_plan_type
												AND T.CUTOFF_FLAG = 'Y'
										);
			SET     @v_data_end_yyyymmdd = CONVERT(VARCHAR, DATEADD(D, 84, CONVERT(DATETIME, @v_data_start_yyyymmdd ,112)) ,112) ; --12주(84일)    
			--// 3. END /////////////////////////////////////////////////////////////////////////////////--

			
			---------------------------------------------------------------
			--Daily HOLD Stock  생성 (이전 Plan 기준으로 현재 정보 생성) 
			---------------------------------------------------------------

			IF OBJECT_ID('tempdb..#tmp_SSP_ANL_HOLD_STOCK') IS NOT NULL
			DROP TABLE #tmp_SSP_ANL_HOLD_STOCK

			CREATE TABLE #tmp_SSP_ANL_HOLD_STOCK(
			 HOLD_ID                        nvarchar(050)   
			,PLAN_START_YYYYMMDD            nvarchar(008)    
			,PLAN_TYPE                      nvarchar(050)   
			,SEQ                            INT         
			,DIVISION_ID                    nvarchar(030)   
			,FROM_SITE                      nvarchar(030)   
			,ITEM_ID                        nvarchar(050)   
			,HOLD_YYYYMMDD                  nvarchar(008)    
			,RELEASE_YYYYMMDD               nvarchar(008)    
			,HOLD_QTY                       numeric(20, 10)
			,REMARKS                        nvarchar(255)  
			,ORIGIN_FROM_DIVISION_ID        nvarchar(030)   
			,CREATED_BY                     nvarchar(150)  
			,CREATION_DATE                  datetime       
			,LAST_UPDATED_BY                nvarchar(150)  
			,LAST_UPDATE_DATE               datetime       
			);

			INSERT INTO #tmp_SSP_ANL_HOLD_STOCK (
					 HOLD_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,DIVISION_ID
					,FROM_SITE
					,ITEM_ID
					,HOLD_YYYYMMDD
					,RELEASE_YYYYMMDD
					,HOLD_QTY
					,REMARKS
					,ORIGIN_FROM_DIVISION_ID
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
     			)
					SELECT 
					 HOLD_ID
					,@v_plan_start_yyyymmdd -- PLAN_START_YYYYMMDD
					,@v_plan_type--PLAN_TYPE
					,@v_seq--SEQ
					,DIVISION_ID
					,FROM_SITE
					,ITEM_ID
					,HOLD_YYYYMMDD
					,RELEASE_YYYYMMDD
					,HOLD_QTY
					,REMARKS
					,ORIGIN_FROM_DIVISION_ID
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					FROM SSP_ANL_HOLD_STOCK WITH(NOLOCK) 
					WHERE DIVISION_ID         = @v_division_id
					AND   PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
					AND   PLAN_TYPE           = @v_plan_type
					AND   SEQ                 = @v_seq
					AND	  ITEM_ID 			  = @v_item_id
					;
					
			--// 4. 변경날짜 이후 WH_STOCK 산출//////////////////////////////////////////////////////////--
			--1) BOH계산을 위한 기준 일자의 Warehouse Stock QTY는 WH in Plan - (Shipment Confirm + HOLD QTY) 
			-- => BOH계산을 위한 기준 일자 기준으로 HOLD QTY를 구한 QTY만큼 Warehouse Stock QTY 를 플러스 시킨 수량을 기준 수량으로 잡는다.
			WITH BOH AS 
			(   -- 해당날짜에 대한 WH_STOCK정보 
				SELECT DISTINCT  
					DIVISION_ID,      PLAN_START_YYYYMMDD,      PLAN_TYPE,      SEQ,      ITEM_ID,      FROM_SITE,
					(SELECT ISNULL(SUM(H.HOLD_QTY), 0) FROM #tmp_SSP_ANL_HOLD_STOCK H WHERE @v_data_start_yyyymmdd BETWEEN HOLD_YYYYMMDD AND RELEASE_YYYYMMDD)
					+ ROUND(SUM(QTY),0)	AS  QTY 
				FROM  #tmp_SSP_ANL_SHIP_REQ_01  WITH(NOLOCK) 
				WHERE 1=1 
					AND DIVISION_ID         = @v_division_id         
					AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
					AND PLAN_TYPE           = @v_plan_type           
					AND SEQ                 = @v_seq                 
					AND MEASURE             = 'WH_STOCK'
					AND YYYYMMDD            = @v_data_start_yyyymmdd
					AND ITEM_ID             = @v_item_id 
					AND FROM_SITE           = @v_from_site
				GROUP BY 
					DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE 
			) , 
			Z AS 
			(
				SELECT DISTINCT  
					DIVISION_ID,      PLAN_START_YYYYMMDD,      PLAN_TYPE,      SEQ,      ITEM_ID,      FROM_SITE,      YYYYMMDD     
				FROM  #tmp_SSP_ANL_SHIP_REQ_01  WITH(NOLOCK) 
				WHERE 1=1 
					AND DIVISION_ID         = @v_division_id 
					AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
					AND PLAN_TYPE           = @v_plan_type          
				    AND SEQ                 = @v_seq                
					AND MEASURE				IN ('SHIP_REQ', 'SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN')
					AND YYYYMMDD            >= @v_data_start_yyyymmdd
					AND ITEM_ID             = @v_item_id 
					AND FROM_SITE           = @v_from_site
				GROUP BY 
					DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, YYYYMMDD 
			)  
			INSERT INTO #tmp_SSP_ANL_SHIP_REQ_UPDATE_BOH
			(
				DIVISION_ID,			PLAN_START_YYYYMMDD,				PLAN_TYPE,				SEQ,
				ITEM_ID,				FROM_SITE,							TO_SITE,				MEASURE,
				YYYYMMDD,				BOD_ID,								
				QTY,					
				INCOTERMS,
				TRANSPORT_MODE,			PROJECT_CODE,						FCST_TYPE,				CONFIRM_ID           
			)
			SELECT   
				Z.DIVISION_ID,			Z.PLAN_START_YYYYMMDD,				Z.PLAN_TYPE,			Z.SEQ,
				Z.ITEM_ID,				Z.FROM_SITE,						'-' AS TO_SITE,			'WH_STOCK' AS MEASURE,
				Z.YYYYMMDD,				'-'   AS BOD_ID,					
				(
					SELECT ISNULL( SUM(CASE X.MEASURE	WHEN 'SHIP_REQ'			THEN -1 * ISNULL(X.QTY,0)  
														WHEN 'SHIP_CONFIRM'		THEN -1 * ISNULL(X.QTY,0)  
														WHEN 'POSTP_PLAN'		THEN -1 * ISNULL(X.QTY,0)  
														WHEN 'MES_FCS_HOLD'		THEN -1 * ISNULL(X.QTY,0)  
														WHEN 'WH_IN'			THEN ISNULL(X.QTY,0)  
														WHEN 'MES_FCS_RELEASE'	THEN  ISNULL(X.QTY,0)  
										ELSE 0.0 END), 0) -- 전일 WH_IN , 전일 SHIP_CONFIRM
					FROM #tmp_SSP_ANL_SHIP_REQ_01 X WITH(NOLOCK)   
					WHERE 1=1  
						AND X.DIVISION_ID          = Z.DIVISION_ID  
						AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
						AND X.PLAN_TYPE            = Z.PLAN_TYPE  
						AND X.SEQ                  = Z.SEQ  
						AND X.ITEM_ID              = Z.ITEM_ID  
						AND X.FROM_SITE            = Z.FROM_SITE  
						AND X.MEASURE              IN ('SHIP_REQ','WH_IN', 'SHIP_CONFIRM', 'POSTP_PLAN', 'MES_FCS_RELEASE','MES_FCS_HOLD'	 )  
						AND X.YYYYMMDD             >= @v_data_start_yyyymmdd
						AND X.YYYYMMDD             <  Z.YYYYMMDD  
				) + ISNULL(BOH.QTY,0) 
				-- HOLD 재고 
				-   ISNULL((SELECT SUM(H.HOLD_QTY )  -- HOLD재고 제외
							FROM  #tmp_SSP_ANL_HOLD_STOCK H WITH(NOLOCK) 
							,     SCM_SYS_CALENDAR_M    C WITH(NOLOCK)
							WHERE H.DIVISION_ID         = @v_division_id 
							AND   H.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							AND   H.PLAN_TYPE           = @v_plan_type
							AND   H.SEQ                 = @v_seq
							AND   C.BASIS_YYYYMMDD     >= H.HOLD_YYYYMMDD
							AND   C.BASIS_YYYYMMDD     <= H.RELEASE_YYYYMMDD
							AND   C.BASIS_YYYYMMDD     >= @v_data_start_yyyymmdd
							AND   C.BASIS_YYYYMMDD     <  @v_data_end_yyyymmdd
							AND   H.DIVISION_ID         = Z.DIVISION_ID 
							AND   H.FROM_SITE           = Z.FROM_SITE
							AND   H.ITEM_ID             = Z.ITEM_ID 
							AND   C.BASIS_YYYYMMDD      = Z.YYYYMMDD	
   							GROUP BY H.DIVISION_ID 
						,        H.FROM_SITE
						,        H.ITEM_ID 
						,        C.BASIS_YYYYMMDD ) ,0)	
				
				AS QTY,
				'-' AS INCOTERMS,
				'-' AS TRANSPORT_MODE,	'-' AS PROJECT_CODE ,				'-'   AS FCST_TYPE,			'-'   AS CONFIRM_ID 
			FROM Z WITH(NOLOCK)   
			LEFT OUTER JOIN BOH WITH(NOLOCK) 
				ON Z.DIVISION_ID	= BOH.DIVISION_ID		AND		Z.PLAN_START_YYYYMMDD	= BOH.PLAN_START_YYYYMMDD  
				AND Z.PLAN_TYPE		= BOH.PLAN_TYPE		    AND		Z.SEQ					= BOH.SEQ  
				AND Z.ITEM_ID		= BOH.ITEM_ID			AND		Z.FROM_SITE				= BOH.FROM_SITE  
			WHERE 1=1;
			--// 4. END /////////////////////////////////////////////////////////////////////////////////--
			
			--// 5. WH_STOCK UPDATE//////////////////////////////////////////////////////////////////////--
			UPDATE #tmp_SSP_ANL_SHIP_REQ_01
				SET	QTY					= C.QTY,
					LAST_UPDATED_BY		= @v_last_updated_by,      
					LAST_UPDATE_DATE    = @v_working_time
				FROM  #tmp_SSP_ANL_SHIP_REQ_01 P WITH(NOLOCK) 
				JOIN #tmp_SSP_ANL_SHIP_REQ_UPDATE_BOH C WITH(NOLOCK)
					ON P.DIVISION_ID		= C.DIVISION_ID         AND			P.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD 
					AND P.PLAN_TYPE         = C.PLAN_TYPE           AND			P.SEQ                  = C.SEQ                 
					AND P.ITEM_ID           = C.ITEM_ID             AND			P.FROM_SITE            = C.FROM_SITE           
					AND P.TO_SITE           = C.TO_SITE				AND			P.YYYYMMDD             = C.YYYYMMDD            
					AND P.BOD_ID            = C.BOD_ID              AND			P.INCOTERMS            = C.INCOTERMS           
					AND P.TRANSPORT_MODE    = C.TRANSPORT_MODE      AND			P.PROJECT_CODE         = C.PROJECT_CODE        
					AND P.FCST_TYPE         = C.FCST_TYPE           AND			P.MEASURE              = C.MEASURE
					AND ISNULL(P.CONFIRM_ID,'-')    =   ISNULL(C.CONFIRM_ID,'-')  
				WHERE 1=1 
					AND   P.MEASURE              = 'WH_STOCK'
					AND   P.PLAN_TYPE            = @v_plan_type
					AND   P.PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd 
					AND   P.SEQ                  = @v_seq
					AND   P.DIVISION_ID          = @p_division_id
					AND   P.ITEM_ID              = @v_item_id 
					AND   P.FROM_SITE            = @v_from_site 
					AND   P.YYYYMMDD            >= @v_data_start_yyyymmdd;
			
			--// 5. END /////////////////////////////////////////////////////////////////////////////////--
			
			--// 6. BALANCE UPDATE//////////////////////////////////////////////////////////////////////--
			WITH BAL AS 
			(
				SELECT  
					P.DIVISION_ID,			P.PLAN_START_YYYYMMDD,			P.PLAN_TYPE,		P.SEQ,				P.ITEM_ID,				P.FROM_SITE,
					'-' AS TO_SITE,			'BALANCE' AS MEASURE,			P.YYYYMMDD,			'-' AS BOD_ID,      
					SUM(CASE WHEN P.MEASURE ='WH_STOCK' THEN P.QTY ELSE 0 END ) - SUM(CASE WHEN P.MEASURE ='SHIP_CONFIRM' THEN P.QTY ELSE 0 END ) - SUM(CASE WHEN P.MEASURE ='SHIP_REQ' THEN P.QTY ELSE 0 END )- SUM(CASE WHEN P.MEASURE ='POSTP_PLAN' THEN P.QTY ELSE 0 END )  AS QTY,
					'-' AS INCOTERMS,
					'-' AS TRANSPORT_MODE,	'-' AS PROJECT_CODE,			'-' AS FCST_TYPE,   '-' AS CONFIRM_ID    
				FROM  #tmp_SSP_ANL_SHIP_REQ_01 P WITH(NOLOCK) 
				WHERE 1=1 
					AND P.MEASURE              IN ('SHIP_CONFIRM','WH_STOCK', 'SHIP_REQ', 'POSTP_PLAN')
					AND P.DIVISION_ID         = @v_division_id 
					AND P.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd        
					AND P.PLAN_TYPE           = @v_plan_type                  
					AND P.SEQ                 = @v_seq                           
					AND P.ITEM_ID             = @v_item_id               
					AND P.FROM_SITE           = @v_from_site             
					AND P.YYYYMMDD           >= @v_data_start_yyyymmdd       
				GROUP BY 
					P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.ITEM_ID, P.FROM_SITE, P.YYYYMMDD            
			)
			UPDATE #tmp_SSP_ANL_SHIP_REQ_01
				SET QTY                  = BAL.QTY,
					LAST_UPDATED_BY      = @v_last_updated_by,
					LAST_UPDATE_DATE     = @v_working_time
				FROM #tmp_SSP_ANL_SHIP_REQ_01 B WITH(NOLOCK)   
				JOIN BAL WITH(NOLOCK) 
					ON BAL.DIVISION_ID         = B.DIVISION_ID          AND			BAL.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD  
					AND BAL.PLAN_TYPE           = B.PLAN_TYPE           AND			BAL.SEQ                 = B.SEQ                  
					AND BAL.ITEM_ID             = B.ITEM_ID             AND			BAL.FROM_SITE           = B.FROM_SITE            
					AND BAL.TO_SITE             = B.TO_SITE             AND			BAL.YYYYMMDD            = B.YYYYMMDD             
					AND BAL.BOD_ID              = B.BOD_ID              AND			BAL.INCOTERMS           = B.INCOTERMS            
					AND BAL.TRANSPORT_MODE      = B.TRANSPORT_MODE      AND			BAL.PROJECT_CODE        = B.PROJECT_CODE         
					AND BAL.FCST_TYPE           = B.FCST_TYPE
				WHERE 1=1 
					AND B.DIVISION_ID         = @v_division_id                     
					AND B.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd        
					AND B.PLAN_TYPE           = @v_plan_type                
					AND B.MEASURE             = 'BALANCE'   
					AND B.SEQ                 = @v_seq                          
					AND B.ITEM_ID             = @v_item_id              
					AND B.FROM_SITE           = @v_from_site           
					AND B.YYYYMMDD           >= @v_data_start_yyyymmdd;

			IF(@v_modify_flag = 'Y')
			BEGIN
				SET @v_minus_YYYYMMDD = '';
				SET @v_minus_YYYYMMDD = (
											SELECT TOP 1 ISNULL(YYYYMMDD, '')
											FROM #tmp_SSP_ANL_SHIP_REQ_01
											WHERE MEASURE = 'BALANCE'
											AND YYYYMMDD >= @v_data_start_yyyymmdd
											AND YYYYMMDD >= @v_min_start_yyyymmdd
											AND QTY < 0
											ORDER BY YYYYMMDD ASC
										);
			
			END
			ELSE IF(@v_delete_flag = 'Y')
			BEGIN
				SET @v_minus_YYYYMMDD = NULL;
			END

			--//BALANCE 값이 음수일 경우
			IF(@v_minus_YYYYMMDD IS NOT NULL)
			BEGIN
				SELECT 'M' AS result_code, substring(@v_minus_YYYYMMDD, 1, 4) + '-' + substring(@v_minus_YYYYMMDD, 5, 2) + '-' + substring(@v_minus_YYYYMMDD, 7, 2) AS result_Date;
			END
			--//BALANCE 값이 양수일 경우
			ELSE
			BEGIN
				--SSP_ANL_SHIP_REQ Data 삭제전 히스토리 저장 'SRD'
				INSERT INTO SSP_ANL_SHIP_REQ_H
				(
					HISTORY_SEQ,		
					DIVISION_ID,		PLAN_START_YYYYMMDD,		PLAN_TYPE,				SEQ,					ITEM_ID,
					FROM_SITE,			TO_SITE,					MEASURE,				YYYYMMDD,				BOD_ID,
					QTY,				ROUTE_ID,					INCOTERMS,				TRANSPORT_MODE,			BIZ_TYPE,
					PROJECT_CODE,		FCST_TYPE,					FCST_ETD_DATE,			FCST_ETA_DATE,			ETD_DATE,
					ETA_DATE,			CONFIRM_ID,					REQ_DET_ID,				
					REQ_MST_ID,			REQ_GRP_ID,
					CREATED_BY,			CREATION_DATE,				LAST_UPDATED_BY,		LAST_UPDATE_DATE,
					ATTRIBUTE1,			ATTRIBUTE2,				HISTORY_CREATION_DATE
				)
				SELECT
					NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_REQ_H AS HISTORY_SEQ,
					DIVISION_ID,		PLAN_START_YYYYMMDD,		PLAN_TYPE,				SEQ,					ITEM_ID,
					FROM_SITE,			TO_SITE,					MEASURE,				YYYYMMDD,				BOD_ID,
					QTY,				ROUTE_ID,					INCOTERMS,				TRANSPORT_MODE,			BIZ_TYPE,
					PROJECT_CODE,		FCST_TYPE,					FCST_ETD_DATE,			FCST_ETA_DATE,			ETD_DATE,
					ETA_DATE,			CONFIRM_ID,					REQ_DET_ID,				
					REQ_MST_ID,			REQ_GRP_ID,
					CREATED_BY,			CREATION_DATE,				@v_last_updated_by AS LAST_UPDATED_BY,		LAST_UPDATE_DATE,
					'SRD' AS ATTRIBUTE1,	@v_active_flag,			GETDATE() AS HISTORY_CREATION_DATE
				FROM SSP_ANL_SHIP_REQ WITH(NOLOCK) 
				WHERE 1 = 1
				  AND DIVISION_ID = @v_division_id
				  AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				  AND PLAN_TYPE = @v_plan_type
				  AND SEQ = @v_seq
				  AND ITEM_ID = @v_item_id
				  AND FROM_SITE = @v_from_site
				  AND REQ_MST_ID = @v_req_mst_id;
				
				--SSP_ANL_SHIP_REQ Data 삭제
				DELETE FROM SSP_ANL_SHIP_REQ
				WHERE 1 = 1
				  AND DIVISION_ID = @v_division_id
				  AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				  AND PLAN_TYPE = @v_plan_type
				  AND SEQ = @v_seq
				  AND ITEM_ID = @v_item_id
				  AND FROM_SITE = @v_from_site
				  AND REQ_MST_ID = @v_req_mst_id;

				--수정 Data SSP_ANL_SHIP_REQ 저장
				INSERT INTO SSP_ANL_SHIP_REQ
				(
					DIVISION_ID,		PLAN_START_YYYYMMDD,	PLAN_TYPE,		SEQ,			ITEM_ID,			FROM_SITE,
					TO_SITE,			MEASURE,				YYYYMMDD,		BOD_ID,			QTY,				ROUTE_ID,
					INCOTERMS,			TRANSPORT_MODE,			BIZ_TYPE,		PROJECT_CODE,	FCST_TYPE,			FCST_ETD_DATE,
					FCST_ETA_DATE,		ETD_DATE,				ETA_DATE,		CONFIRM_ID,		REQ_DET_ID,			REQ_MST_ID,
					REQ_GRP_ID,			REMARKS3,				CREATED_BY,		CREATION_DATE,	LAST_UPDATED_BY,	LAST_UPDATE_DATE
				)
				SELECT 
					DIVISION_ID,		PLAN_START_YYYYMMDD,	PLAN_TYPE,		SEQ,			ITEM_ID,			FROM_SITE,
					TO_SITE,			MEASURE,				YYYYMMDD,		BOD_ID,			QTY,				ROUTE_ID,
					INCOTERMS,			TRANSPORT_MODE,			BIZ_TYPE,		PROJECT_CODE,	FCST_TYPE,			FCST_ETD_DATE,
					FCST_ETA_DATE,		ETD_DATE,				ETA_DATE,		CONFIRM_ID,		REQ_DET_ID,			REQ_MST_ID,
					REQ_GRP_ID,			REMARKS3,				CREATED_BY,		CREATION_DATE,	LAST_UPDATED_BY,	LAST_UPDATE_DATE
				FROM #tmp_SSP_ANL_SHIP_REQ_01;
			
			END
		END; --//REQUEST 수량 변경 END

		--////////////////////////////////////////////////////////////////////////////////////////--
		--//						     REMARK 변경                                            //--
		--////////////////////////////////////////////////////////////////////////////////////////--
		IF(LEN(@recv_remark_flag) > 0)
		BEGIN
			WHILE @mst_loop_remark_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_remark_cnt = @mst_loop_remark_cnt + 1;

				-- 각 컬럼들에 대한 스플릿처리로직 스타트
				BEGIN
					SET @v_remark_grp_id	= dbo.SCM_ARR_SPL_VAL( @p_remark_grp_id,	@v_delimiter, @mst_loop_remark_cnt );
					SET @v_remark_text		= dbo.SCM_ARR_SPL_VAL( @p_remark_text,		@v_delimiter, @mst_loop_remark_cnt );
				END;

				UPDATE SSP_ANL_SHIP_REQ
				   SET REMARKS3				= @v_remark_text
					   , LAST_UPDATED_BY	= @v_last_updated_by
					   , LAST_UPDATE_DATE	= @v_last_update_date
				 WHERE REQ_MST_ID	= @v_req_mst_id
				   AND REQ_GRP_ID	= @v_remark_grp_id
				
				INSERT INTO SSP_ANL_SHIP_REQ_H
				(
					HISTORY_SEQ,		
					DIVISION_ID,		PLAN_START_YYYYMMDD,		PLAN_TYPE,				SEQ,					ITEM_ID,
					FROM_SITE,			TO_SITE,					MEASURE,				YYYYMMDD,				BOD_ID,
					QTY,				ROUTE_ID,					INCOTERMS,				TRANSPORT_MODE,			BIZ_TYPE,
					PROJECT_CODE,		FCST_TYPE,					FCST_ETD_DATE,			FCST_ETA_DATE,			ETD_DATE,
					ETA_DATE,			CONFIRM_ID,					REQ_DET_ID,				
					REQ_MST_ID,			REQ_GRP_ID,
					CREATED_BY,			CREATION_DATE,				LAST_UPDATED_BY,		LAST_UPDATE_DATE,
					ATTRIBUTE1,		ATTRIBUTE2,			HISTORY_CREATION_DATE,		REMARKS3
				)
				SELECT 
					NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_REQ_H AS HISTORY_SEQ,	
					DIVISION_ID,		PLAN_START_YYYYMMDD,		PLAN_TYPE,				SEQ,					ITEM_ID,
					FROM_SITE,			TO_SITE,					MEASURE,				YYYYMMDD,				BOD_ID,
					QTY,				ROUTE_ID,					INCOTERMS,				TRANSPORT_MODE,			BIZ_TYPE,
					PROJECT_CODE,		FCST_TYPE,					FCST_ETD_DATE,			FCST_ETA_DATE,			ETD_DATE,
					ETA_DATE,			CONFIRM_ID,					REQ_DET_ID,				
					REQ_MST_ID,			REQ_GRP_ID,
					CREATED_BY,			CREATION_DATE,				LAST_UPDATED_BY,		LAST_UPDATE_DATE,
					'R' AS ATTRIBUTE1,	@v_active_flag,			GETDATE() AS HISTORY_CREATION_DATE,					@v_remark_text AS REMARKS3
				FROM SSP_ANL_SHIP_REQ WITH(NOLOCK)
				WHERE REQ_MST_ID	= @v_req_mst_id
				  AND REQ_GRP_ID	= @v_remark_grp_id
			END
		END

		-- 결과코드 리턴
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;
		--//LOG END///////////////////////////////////////////////--
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
		--/////////////////////////////////////////////////////////--
	COMMIT TRAN;

	END TRY
	BEGIN CATCH
		BEGIN
			ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
			   						
			-- error코드, errror 메시지 반환
			SELECT  @v_err_code			AS err_code
					,@v_err_message		AS err_message
			; 
		END;
	END CATCH;

	
	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_REQ_UPDATE_BOH') IS NOT NULL
		DROP TABLE #tmp_SSP_ANL_SHIP_REQ_UPDATE_BOH

	IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_REQ_01') IS NOT NULL
		DROP TABLE #tmp_SSP_ANL_SHIP_REQ_01
	
END
