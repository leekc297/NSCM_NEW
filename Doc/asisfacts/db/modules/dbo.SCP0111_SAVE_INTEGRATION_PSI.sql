
/*
 * Program ID   : [SCP0111_SAVE_INTEGRATION_PSI]
 * Description  : 통합 PSI의 월별 수량 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/06/12   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - 통합PSI 사용자 수정/저장
 * 2024/06/24   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - ESS 사용자 수정/저장
 * 2024/07/03   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - 인코텀즈 컬럼 추가에 따른 저장키 추가
 * 2024/07/08   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - [자동차] 반제품 in housing moving 생성할때 to product 추가
 * 2024/07/09   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - 특정 권한에 따른 BOH_QTY의 수정 추가
 * 2024/07/24   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경
 * 2024/08/01   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - ESS A050의 투입 전극은 A041이 아니라 G183으로 생성, 전 measure 값 생성시 소수점 반올림후 정수로 바꿔주기
 * 2024/08/23   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - 일반 유저 edit모드에서 Electrod의 PROD_PLAN Measure만 Insert 가능하도록 수정
 * 2024/10/08   mrchois    PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화 - [자동차] Cell반제품 수정시 전극투입량 오류 수정
 * 2024/10/25   mrchois    PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화 - 통합PSI 소형 추가
 * 2024/11/06   mrchois    PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화 - EV2020 예외 반영, Prod Plan insert기능 전극 only -> Cell/Pack도 확산 적용, 셀 제품 투입량 수율 적용, 음수 생산 및 투입 방지
 * 2024/11/25   mrchois    PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화 - 모듈반제품(250) 계산식 변경
 * 2024/11/26   jahn1502   PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화 - 모듈반제품(250) measure - IN_HOUSE_MOVING 이 없으면 생성 추가
 * 2024.12.15   vadabi3     NERP - 특정 Company 별도 처리 개선
 * 2025.02.18   mrchois    PJ20249346 LGES SCP 개선과제 이행 - NERP 전환 plant 찾는 로직 추가(요청번호 E20250217-000217)
 * 2025/03/14	mrchois	   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - PLAN_TYPE컬럼 추가
 * 2025/03/24	mrchois	   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - ESS 팩 Prod Plan도 수정 가능하도록
 */

 CREATE PROCEDURE [dbo].[SCP0111_SAVE_INTEGRATION_PSI]
 
	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX)
	,@p_plan_type			NVARCHAR(MAX)	--PLAN_TYPE컬럼 추가 2025-03-14
	,@p_division_id			NVARCHAR(MAX)
	,@p_company_id			NVARCHAR(MAX)
	,@p_plant_id			NVARCHAR(MAX)
	,@p_operation_group		NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_seq_flag			NVARCHAR(MAX)
	,@p_cellitem_id			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_measure				NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_line_id				NVARCHAR(MAX)
	,@p_valuation_type		NVARCHAR(MAX)
	,@p_to_product			NVARCHAR(MAX)
	,@p_incoterms			NVARCHAR(MAX)	--컬럼추가 20240703
	,@p_yyyymm				NVARCHAR(MAX)
	,@p_modiQty				NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)

AS
BEGIN

	SET NOCOUNT ON; 

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_plan_type			NVARCHAR(MAX);	--PLAN_TYPE컬럼 추가 2025-03-14
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_company_id			NVARCHAR(MAX);
	DECLARE @v_plant_id				NVARCHAR(MAX);
	DECLARE @v_operation_group		NVARCHAR(MAX);
	DECLARE @v_seq_flag				NVARCHAR(MAX);
	DECLARE @v_cellitem_id			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_measure				NVARCHAR(MAX);
	DECLARE @v_to_site				NVARCHAR(MAX);
	DECLARE @v_line_id				NVARCHAR(MAX);
	DECLARE @v_valuation_type		NVARCHAR(MAX);
	DECLARE @v_to_product			NVARCHAR(MAX);
	DECLARE @v_incoterms			NVARCHAR(MAX);	--컬럼추가 20240703
	DECLARE @v_yyyymm				NVARCHAR(MAX);
	DECLARE @v_modiQty				NVARCHAR(MAX);

	DECLARE @v_last_updated_by		NVARCHAR(MAX);

	-- NERP
    DECLARE @v_ESOC NVARCHAR(20);		-- C100 -> HQ00
	DECLARE @v_ESNJ NVARCHAR(20);		-- G180 -> NJ00
	DECLARE @v_ESNJ_PLANT NVARCHAR(20); -- G183 -> G183
	SELECT @v_ESOC = DBO.FN_GET_LOOKUP_VALUE('SCP0111_SAVE_INTEGRATION_PSI','ESOC')
	SELECT @v_ESNJ = DBO.FN_GET_LOOKUP_VALUE('SCP0111_SAVE_INTEGRATION_PSI','ESNJ')
	SELECT @v_ESNJ_PLANT = DBO.FN_GET_LOOKUP_VALUE('SCP0111_SAVE_INTEGRATION_PSI','ESNJ_PLANT')

	SET @v_active_flag		= NULL;
	SET @v_plan_type		= NULL;		--PLAN_TYPE컬럼 추가 2025-03-14
	SET @v_division_id		= NULL;
	SET @v_company_id		= NULL;
	SET @v_plant_id			= NULL;
	SET @v_operation_group	= NULL;
	SET @v_seq_flag			= NULL;
	SET @v_cellitem_id		= NULL;
	SET @v_item_id			= NULL;
	SET @v_measure			= NULL;
	SET @v_to_site			= NULL;
	SET @v_line_id			= NULL;
	SET @v_valuation_type	= NULL;
	SET @v_to_product		= NULL;
	SET @v_incoterms		= NULL;		--컬럼추가 20240703
	SET @v_yyyymm			= NULL;
	SET @v_modiQty			= NULL;
	SET @v_last_updated_by	= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0111_SAVE_INTEGRATION_PSI';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	SET @v_last_updated_by  = @p_user_id

	DECLARE @cnt	decimal;
	SET @cnt = 0;

	-- MEASURE 확인용
	DECLARE @v_measure_count NVARCHAR(1)='';

	-- NERP 전환 plant 찾는 로직 추가 (2025-02-18 mrchois) START
	if object_id('tempdb..#elec_plant') is not null drop table #elec_plant;

	select es.company_id
			, es.division_id
			, isnull(es.city	,'Z')	as city
			, isnull(es.country,'Z')	as country
			, es.plant_id
			, es.site_description
			, es.scm_site_id
			, es.site_id
			, row_number() over (partition by	  es.company_id
											, es.division_id
											, es.plant_id
									order by	 es.plant_id)	as elec_plant_priority_1st
			, row_number() over (partition by	  es.company_id
											, es.division_id
											, isnull(es.city	,'Z')
											, isnull(es.country,'Z')
									order by	 es.plant_id)	as elec_plant_priority_2nd
			, row_number() over (partition by	  es.company_id
											, es.division_id
									order by	 es.plant_id)	as elec_plant_priority_3RD
 			, row_number() over (partition by	  es.company_id
									order by	 es.plant_id)	as elec_plant_priority_4TH
	into #elec_plant
	from scm_mst_site es with(nolock)
	where 1=1
		and es.valid_yn			= 'Y'
		and es.operation_group	= 'E'	-- 전극 Plant 
		and es.site_type			= 'PLANT'

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Cell/전극 plant 매핑 - #cell_elec_plant_mapping' 
	-- 2025.02.12 cell/전극 plant 매핑 로직 수정 
	-- 1순위 : division, company, plant 정보로 매핑
	-- 2순위 : division, company, city, country 정보로 매핑 
	-- 3순위 : division, company 정보로 매핑 
	-- 4순위 : company 정보로 매핑 
	------------------------------------------------------------------------------------------------------------------
	if object_id('tempdb..#cell_elec_plant_mapping') is not null drop table #cell_elec_plant_mapping;
  
	select cs.division_id		as division_id_cs
			,cs.company_id		as company_id_cs
			,cs.plant_id			as plant_id_cs
			,row_number() over	(partition by cs.division_id
												,cs.company_id
												,cs.plant_id
										order by cs.scm_site_id) as cell_plant_priority 
			,cs.site_description	as site_description_cs 
			,cs.scm_site_id		as scm_site_id_cs
			,isnull(e1.plant_id,			isnull(e2.plant_id,			isnull(e3.plant_id,			e4.plant_id)))			as plant_id_es 
			,isnull(e1.site_description,	isnull(e2.site_description, isnull(e3.site_description, e4.site_description)))	as site_description_es
			,e1.plant_id			as plant_e1
			,e2.plant_id			as plant_e2 
			,e3.plant_id			as plant_e3 
			,e4.plant_id			as plant_e4 
			,e1.site_description	as site_desc_e1
			,e2.site_description	as site_desc_e2 
			,e3.site_description	as site_desc_e3
			,e4.site_description	as site_desc_e4
	into #cell_elec_plant_mapping
	from scm_mst_site cs with(nolock)
	left join #elec_plant e1
		on e1.elec_plant_priority_1st = 1
		and e1.division_id	= cs.division_id
		and e1.company_id	= cs.company_id
		and e1.plant_id		= cs.plant_id
	left join #elec_plant e2
		on e2.elec_plant_priority_2nd = 1
		and e2.division_id	= cs.division_id
		and e2.company_id	= cs.company_id
		and e2.city			= isnull(cs.city,'Z')
		and e2.country		= isnull(cs.country,'Z')
	left join #elec_plant e3
		on e3.elec_plant_priority_3RD = 1
		and e3.division_id	= cs.division_id
		and e3.company_id	= cs.company_id
	left join #elec_plant e4
		on e4.elec_plant_priority_4TH = 1
		and e4.company_id	= cs.company_id
	where 1=1
		and cs.valid_yn			= 'Y'
		and cs.operation_group	= 'A'	-- Cell Plant
		and cs.site_type			= 'PLANT'
		and cs.osp_yn				= 'N'
	-- NERP 전환 plant 찾는 로직 추가 (2025-02-18 mrchois) END

		-- 트렌젝션 시작
		BEGIN TRAN;

		BEGIN TRY

			-- 시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-- 프로시저 LOOP 길이를 판단
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);   

			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			BEGIN
		
				SET @mst_loop_cnt = @mst_loop_cnt + 1;

				-- 각 컬럼들에 대한 스플릿처리로직 스타트
				BEGIN

					SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
					SET @v_plan_type = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type, @v_delimiter , @mst_loop_cnt) ;		--PLAN_TYPE컬럼 추가 2025-03-14
					SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
					SET @v_company_id = [dbo].[SCM_ARR_SPL_VAL](@p_company_id, @v_delimiter , @mst_loop_cnt) ;
					SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;   
					SET @v_operation_group = [dbo].[SCM_ARR_SPL_VAL](@p_operation_group, @v_delimiter , @mst_loop_cnt) ;
					SET @v_seq_flag = [dbo].[SCM_ARR_SPL_VAL](@p_seq_flag, @v_delimiter , @mst_loop_cnt) ;    
					SET @v_cellitem_id = [dbo].[SCM_ARR_SPL_VAL](@p_cellitem_id, @v_delimiter , @mst_loop_cnt) ;
					SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ; 
					SET @v_measure = [dbo].[SCM_ARR_SPL_VAL](@p_measure, @v_delimiter , @mst_loop_cnt) ;
					SET @v_to_site = [dbo].[SCM_ARR_SPL_VAL](@p_to_site, @v_delimiter , @mst_loop_cnt) ;
					SET @v_line_id = [dbo].[SCM_ARR_SPL_VAL](@p_line_id, @v_delimiter , @mst_loop_cnt) ;
					SET @v_valuation_type = [dbo].[SCM_ARR_SPL_VAL](@p_valuation_type, @v_delimiter , @mst_loop_cnt) ;
					SET @v_to_product = [dbo].[SCM_ARR_SPL_VAL](@p_to_product, @v_delimiter , @mst_loop_cnt) ;
					SET @v_incoterms = [dbo].[SCM_ARR_SPL_VAL](@p_incoterms, @v_delimiter , @mst_loop_cnt) ;	--컬럼추가 20240703
					SET @v_yyyymm = [dbo].[SCM_ARR_SPL_VAL](@p_yyyymm, @v_delimiter , @mst_loop_cnt) ;
					SET @v_modiQty = [dbo].[SCM_ARR_SPL_VAL](@p_modiQty, @v_delimiter , @mst_loop_cnt) ;

				END

				--데이터 저장
				IF @mst_loop_cnt > 0
				BEGIN
					
					--일반 유저 edit모드에서 Electrod의 PROD_PLAN Measure만 Insert 가능하도록 수정 2023/08/23 START
					IF(@v_active_flag = 'I')
					BEGIN

						--통합 PSI 신규데이터 입력
						INSERT INTO SCP_ANL_PSI_INTEGRATION
						(
							DIVISION_ID
							, COMPANY_ID
							, PLANT_ID
							, PLAN_START_YYYYMMDD
							, SEQ
							, OPERATION_GROUP
							, FROM_SITE
							, CELL_ITEM_ID
							, ITEM_ID
							, MEASURE   --10
							, value_type
							, TO_PRODUCT
							, LINE_ID
							, BOH_QTY
							, TO_SITE
							, INCOTERMS
							, SEQ_FLAG
							, YYYYMM
							, QTY
							, ATTRIBUTE2		--PLAN_TYPE컬럼 추가 2025-03-14
							, CREATED_BY
							, CREATION_DATE
							, LAST_UPDATED_BY     --10
							, LAST_UPDATE_DATE
						)
						VALUES
						(
							@v_division_id
							, @v_company_id
							, @v_plant_id
							, @p_plan_start_yyyymmdd
							, 1
							--, 'E'			--operation_group
							, (CASE WHEN @v_operation_group = 'Pack' THEN 'P'
								   WHEN @v_operation_group = 'Cell' THEN 'A'
								   ELSE 'E' END)								--operation_group  (Prod Plan insert기능 전극 only -> Cell/Pack도 확산 적용 2024/11/11)
							, '-'
							, @v_cellitem_id
							, @v_item_id
							, @v_measure
							, @v_valuation_type
							, @v_to_product
							, @v_line_id
							, 0				--boh_qty
							, @v_to_site
							, @v_incoterms
							, @v_seq_flag
							, @v_yyyymm
							, 0				--Qty
							, @v_plan_type			--PLAN_TYPE컬럼 추가 2025-03-14
							, @v_last_updated_by
							, SYSDATETIME()
							, @v_last_updated_by
							, SYSDATETIME()
						);

						CONTINUE;	-- 일반 유저 edit모드에서 Electrod의 PROD_PLAN Measure만 Insert인 경우는 아래 처리 스킵 

					END
					--일반 유저 edit모드에서 Electrod의 PROD_PLAN Measure만 Insert 가능하도록 수정 2023/08/23 END

					-- 특정 권한에 따른 BOH_QTY의 수정
					IF(@v_measure = 'INV')
					BEGIN
						
						--BOH_QTY의 변경된 수량만큼 BOH_QTY, QTY를 가감
						UPDATE SCP_ANL_PSI_INTEGRATION
						   SET BOH_QTY				= ROUND(BOH_QTY + @v_modiQty, 0)
							 , QTY					= QTY + @v_modiQty	
							 , LAST_UPDATED_BY		= @v_last_updated_by 
							 , LAST_UPDATE_DATE		= SYSDATETIME()
						 WHERE DIVISION_ID			= @v_division_id     
						   AND PLANT_ID				= @v_plant_id
						   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
						   AND ITEM_ID				= @v_item_id 
						   AND MEASURE				= 'INV' 
						   AND VALUE_TYPE			= @v_valuation_type	-- 해당 Valuation Type에 해당하는 값만 변경
						;
						CONTINUE;	-- BOH_QTY의 변경인 경우는 아래 처리 스킵 

					END

					-- 소형, ESS가 아닌 경우
					IF(@v_division_id != '82' AND @v_division_id != '40')
					BEGIN
					
						-- SHIP_PLAN_SEMI 수정인 경우			
						IF(@v_measure ='SHIP_PLAN_SEMI') 
						BEGIN
						
							--1. 실제 수정한 값 수정
							UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 가감
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND CELL_ITEM_ID			= @v_cellitem_id 
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= @v_measure 
								   AND LINE_ID				= @v_line_id
								   AND VALUE_TYPE			= @v_valuation_type
								   AND TO_PRODUCT			= @v_to_product
								   AND TO_SITE				= @v_to_site
								   AND INCOTERMS			= @v_incoterms	--인커텀즈에 대항하는 값만 변경하도록.. 컬럼추가 20240703
								   AND YYYYMM				= @v_yyyymm 
							;

							--2. 수정한 Ship plan(SEMI)에 해당하는 Semi WH In 항목을 찾아서 변경
							UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 가감
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   -- csr : vp to site 수정할때 plant 반영처리 주석처리
								   -- AND PLANT_ID				= @v_to_site			-- TO_SITE = Plant_ID 항목 대상 
								   -- csr : vp to site 수정할때 plant 반영처리 수정로직
								   AND PLANT_ID				= REPLACE(@v_to_site,'VP_','')			-- TO_SITE = Plant_ID 항목 대상 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= 'SEMI_WH_IN'
								   AND YYYYMM				= @v_yyyymm 
							;

							

							--3. 변경월이후 월의 재고 재계산 
							--3-1. 수정한 Ship plan(SEMI)의 변경월이후 월의 재고 재계산
							UPDATE SCP_ANL_PSI_INTEGRATION
								SET QTY						= ROUND(QTY - @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 재고 감소 : Ship plan(SEMI) --> (-)
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								WHERE DIVISION_ID			= @v_division_id     
								AND PLANT_ID				= @v_plant_id
								AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
								AND CELL_ITEM_ID			= @v_cellitem_id 
								AND ITEM_ID					= @v_item_id 
								AND MEASURE					= 'INV' 
								AND YYYYMM					>= @v_yyyymm 
							;

							--3-2. 수정한 Ship plan(SEMI)에 해당하는 Semi WH In의 변경월이후 월의 재고 재계산
							UPDATE SCP_ANL_PSI_INTEGRATION
								SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 재고 증가 : Semi WH In --> (+)
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								WHERE DIVISION_ID			= @v_division_id     
								-- csr : vp to site 수정할때 plant 반영처리 주석처리
								-- AND PLANT_ID				= @v_to_site			-- TO_SITE = Plant_ID 항목 대상 
								-- csr : vp to site 수정할때 plant 반영처리 수정로직
								AND PLANT_ID				= REPLACE(@v_to_site,'VP_','')			-- TO_SITE = Plant_ID 항목 대상 
								AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
								AND ITEM_ID					= @v_item_id 
								AND MEASURE					= 'INV'
								AND YYYYMM					>= @v_yyyymm 
							;

						END
						--PROD_PLAN 수정인 경우
						ELSE IF(@v_measure ='PROD_PLAN')
						BEGIN
						
							--Prod Plan(전극) : 수정한 Prod Plan만 저장
							IF(@v_seq_flag ='550')
							BEGIN

								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= @v_measure 
								   AND LINE_ID				= @v_line_id
								   AND VALUE_TYPE			= @v_valuation_type
								   AND TO_PRODUCT			= @v_to_product
								   AND YYYYMM				= @v_yyyymm 
								;

								-- 변경월이후 월의 재고 재계산 
								UPDATE SCP_ANL_PSI_INTEGRATION
									SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 증가 : Prod Plan --> (+)
										,LAST_UPDATED_BY		= @v_last_updated_by 
										,LAST_UPDATE_DATE		= SYSDATETIME()
									WHERE DIVISION_ID			= @v_division_id     
									AND PLANT_ID				= @v_plant_id
									AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
									AND ITEM_ID					= @v_item_id 
									AND MEASURE					= 'INV' 
									AND YYYYMM					>= @v_yyyymm 
								;

							END
							--Prod Plan(셀 반제품)		: 해당하는 전극을 찾아서 가감
							ELSE IF(@v_seq_flag ='450')
							BEGIN
							
								--1. 수정한 Prod Plan(셀 반제품)의 변경수량만큼 가감
								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= @v_measure 
								   AND LINE_ID				= @v_line_id
								   AND VALUE_TYPE			= @v_valuation_type
								   AND TO_PRODUCT			= @v_to_product
								   AND YYYYMM				= @v_yyyymm 
								;

								--2. 수정한 Prod Plan(셀 반제품)의 전극을 찾아서 가감 : (변경수량 X Cell당 전극 소요량 ÷ 수율)
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID
										, a.PLANT_ID
										, a.PLAN_START_YYYYMMDD
										, a.YYYYMM
										, a.MEASURE
										, b.child_item_id
									-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 START
										--, isnull(@v_modiQty * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1),0) as REAL_MODI_QTY	-- 변경수량 X Cell당 전극 소요량 ÷ 수율
										, isnull(@v_modiQty * isnull(b.USAGE,1) / isnull(y.yield,1),0) as REAL_MODI_QTY	-- 변경수량 X Cell당 전극 소요량 ÷ 수율
									FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
									--INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK) 
									--	on  b.division_id = @v_division_id 
									--	AND b.plant_id = a.PLANT_ID
									--	AND b.operation_group_id = 'E'  --전극이라 아래에서 CP, CA와 무관하게 가져오므로 여기서 전극을 지정함.
									--	AND b.model_id = a.ITEM_ID
									--	AND a.PLAN_START_YYYYMMDD BETWEEN b.eff_start_date AND b.eff_end_date 
									INNER JOIN SCP_MST_BOM_ELEC b WITH(NOLOCK)
										ON b.DIVISION_ID = @v_division_id
										AND b.PARENT_ITEM_ID = a.ITEM_ID
										ANd b.SCP_YN = 'Y'
									-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 END
									-- pack/cell 수율 반영 start 
									LEFT JOIN (select y.operation_group,  a.*
												from SCM_MST_YIELD_VER_H_V a with(nolock)
												INNER JOIN (
															SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
															  from scm_adm_lookup_master_detail b WITH(NOLOCK)
															 where b.lookup_type = 'LOCATION_GROUP_ROUTE'
															   AND b.valid_yn = 'Y'
															   AND b.segment3 = 'Y'
															   AND b.segment5 = 'A'  --'P':Pack, 'A':Cell
															) y
													on a.operation_id = y.operation_id
												where 1=1
												  AND a.division_id = @v_division_id ) y 
										on y.division_id		= a.DIVISION_ID
										AND y.operation_group	= a.OPERATION_GROUP
										AND y.company_id		= a.COMPANY_ID
										AND y.line_id			= a.LINE_ID
										AND y.month				= a.YYYYMM
										AND y.item_id			= a.ITEM_ID  
									-- pack/cell 수율 반영 end 

									WHERE a.division_id			= @v_division_id
									  AND a.plant_id			= @v_plant_id
									  AND a.ITEM_ID				= @v_item_id
									  AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									  AND a.LINE_ID				= @v_line_id		-- 2024-10-08 [자동차] Cell반제품 수정시 전극투입량 오류 수정
									  AND a.YYYYMM				= @v_yyyymm
									  --AND a.MEASURE				= 'IN_HOUSE_MOVING'
									  AND a.MEASURE				= 'PROD_PLAN'
									) A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								  --AND X.PLANT_ID			= substring(A.PLANT_ID,1, len(A.PLANT_ID)-1) + convert(nvarchar(1),convert(int, right(A.PLANT_ID,1)) + 1)
								  AND X.PLANT_ID			= (SELECT plant_id_es FROM #cell_elec_plant_mapping WHERE division_id_cs = X.DIVISION_ID AND company_id_cs = X.COMPANY_ID AND plant_id_cs = @v_plant_id and cell_plant_priority = 1  ) -- NERP 전환 plant 찾는 로직 추가 (2025-02-18 mrchois)
								  AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								  AND X.ITEM_ID				= A.child_item_id	-- 해당하는 전극을 찾아서
								  AND X.YYYYMM				= A.YYYYMM
								  AND X.MEASURE				= 'IN_HOUSE_MOVING'
								  ;

								--3. 변경월이후 월의 재고 재계산 
								--3-1. 수정한 Prod Plan(셀 반제품)의 변경월이후 월의 재고 재계산
								UPDATE SCP_ANL_PSI_INTEGRATION
									SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 변경수량만큼 재고 증가 : Prod Plan --> (+)
										,LAST_UPDATED_BY		= @v_last_updated_by 
										,LAST_UPDATE_DATE		= SYSDATETIME()
									WHERE DIVISION_ID			= @v_division_id     
									AND PLANT_ID				= @v_plant_id
									AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
									AND CELL_ITEM_ID			= @v_cellitem_id 
									AND ITEM_ID					= @v_item_id 
									AND MEASURE					= 'INV' 
									AND YYYYMM					>= @v_yyyymm 
								;


								--3-2. 수정한 Prod Plan(셀 반제품)의 전극을 찾아서 변경월이후 월의 재고 재계산 : (변경수량 X Cell당 전극 소요량 ÷ 수율) 
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY - A.REAL_MODI_QTY, 0)   -- 원래값에 (변경수량 X Cell당 전극 소요량 ÷ 수율) 만큼 감소 : IN_HOUSE_MOVING --> (-)
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID
										, a.PLANT_ID
										, a.PLAN_START_YYYYMMDD
										, a.YYYYMM
										, a.MEASURE
										, b.child_item_id
									-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 START
										, isnull(@v_modiQty * isnull(b.USAGE,1) / isnull(y.yield,1),0) as REAL_MODI_QTY	-- 변경수량 X Cell당 전극 소요량 ÷ 수율
									FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
									INNER JOIN SCP_MST_BOM_ELEC b WITH(NOLOCK)
										ON b.DIVISION_ID = @v_division_id 
										AND b.PARENT_ITEM_ID = a.ITEM_ID
										ANd b.SCP_YN = 'Y'
									-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 END
									-- pack/cell 수율 반영 start 
									LEFT JOIN (select y.operation_group,  a.*
												from SCM_MST_YIELD_VER_H_V a with(nolock)
												INNER JOIN (
															SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
															  from scm_adm_lookup_master_detail b WITH(NOLOCK)
															 where b.lookup_type = 'LOCATION_GROUP_ROUTE'
															   AND b.valid_yn = 'Y'
															   AND b.segment3 = 'Y'
															   AND b.segment5 = 'A'  --'P':Pack, 'A':Cell
															) y
													on a.operation_id = y.operation_id
												where 1=1
												  AND a.division_id = @v_division_id ) y 
										on y.division_id		= a.DIVISION_ID
										AND y.operation_group	= a.OPERATION_GROUP
										AND y.company_id		= a.COMPANY_ID
										AND y.line_id			= a.LINE_ID
										AND y.month				= a.YYYYMM
										AND y.item_id			= a.ITEM_ID  
									-- pack/cell 수율 반영 end 

									WHERE a.division_id			= @v_division_id
									  AND a.plant_id			= @v_plant_id
									  AND a.ITEM_ID				= @v_item_id
									  AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									  AND a.LINE_ID				= @v_line_id		-- 2024-10-08 [자동차] Cell반제품 수정시 전극투입량 오류 수정
									  AND a.YYYYMM				= @v_yyyymm
									  --AND a.MEASURE				= 'INV'
									  AND a.MEASURE				= 'PROD_PLAN'	-- 셀 수정시 전극 재고 재계산시 수율 참조못하는 에러 대응 2024-07-31
									) A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								  --AND X.PLANT_ID			= substring(A.PLANT_ID,1, len(A.PLANT_ID)-1) + convert(nvarchar(1),convert(int, right(A.PLANT_ID,1)) + 1)
								  AND X.PLANT_ID			= (SELECT plant_id_es FROM #cell_elec_plant_mapping WHERE division_id_cs = X.DIVISION_ID AND company_id_cs = X.COMPANY_ID AND plant_id_cs = @v_plant_id and cell_plant_priority = 1  ) -- NERP 전환 plant 찾는 로직 추가 (2025-02-18 mrchois)
								  AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								  AND X.ITEM_ID				= A.child_item_id	-- 해당하는 전극을 찾아서
								  AND X.YYYYMM				>= A.YYYYMM
								  AND X.MEASURE				= 'INV'
								  ;
							
							END
							--Prod Plan(셀 제품)			: 해당하는 셀 반제품을 찾아서  가감
							ELSE IF(@v_seq_flag ='350')
							BEGIN

								--1. 수정한 Prod Plan(셀 제품)의 변경수량만큼 가감
								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= @v_measure 
								   AND LINE_ID				= @v_line_id
								   AND VALUE_TYPE			= @v_valuation_type
								   AND TO_PRODUCT			= @v_to_product
								   AND YYYYMM				= @v_yyyymm 
								;

								--2. 수정한 Prod Plan(셀 제품)의 셀 반제품을 찾아서 가감 : (변경수량 X Cell당 전극 소요량 ÷ 수율)
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID,
										a.PLANT_ID,  
										a.PLAN_START_YYYYMMDD,
										a.YYYYMM ,
										x.ITEM_ID_ASSY,
										isnull(@v_modiQty / isnull(y.scp_fromation_yield,1),0) as REAL_MODI_QTY		--변경수량 ÷ 수율
									FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
									INNER JOIN (SELECT c.division_id, c.item_id_assy, MIN(c.item_id_prod) AS item_id_prod
												FROM   SCP_MST_CELL_PROD_ASSY_MAP c WITH(NOLOCK)
													INNER JOIN scp_mst_final_item f WITH(NOLOCK)
													ON  c.division_id  = f.division_id
													AND c.item_id_prod = f.item_id
													AND f.ATTRIBUTE8   = 'CP'
												WHERE  c.cell_type = 'CA1' -- Cell 생산 계획
												AND    c.valid_yn  = 'Y'   
												GROUP BY c.division_id, c.item_id_assy) x
										on x.DIVISION_ID = a.DIVISION_ID
										AND x.ITEM_ID_ASSY = a.ITEM_ID	
										AND x.item_id_prod = @v_item_id -- 셀 제품으로 셀 반제품 찾기
									-- 활성화 수율 반영 start 
									left join ( SELECT a.DIVISION_ID, ITEM_ID, x.PLANT_ID 
													, CASE  WHEN ISNULL(a.ssp_modify_yield, -99) = -99 THEN
																	CASE WHEN formation_total_yield = 0 THEN 1
																		WHEN formation_total_yield > 1 THEN 1
																		ELSE ISNULL(formation_total_yield, 1)
																	END  
															ELSE 
																	CASE WHEN ssp_modify_yield = 0 THEN 1
																		WHEN ssp_modify_yield > 1 THEN 1
																		ELSE ISNULL(ssp_modify_yield, 1)
																	END
														END AS scp_fromation_yield  
												FROM   scp_mst_formation a WITH (NOLOCK)
												left join scm_mst_site x WITH(NOLOCK)
														on  x.DIVISION_ID = a.DIVISION_ID
														and x.SCM_SITE_ID = a.PLANT_SITE_ID
												where 1=1
												and a.division_id = @v_division_id 
												) y
										on y.division_id = a.DIVISION_ID
										and y.plant_id = a.PLANT_ID
										and y.item_id = x.ITEM_ID_ASSY  
									-- 활성화 수율 반영 end
									WHERE a.division_id			= @v_division_id  
									AND a.plant_id				= @v_plant_id
									AND a.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									AND a.YYYYMM				= @v_yyyymm
									AND a.TO_PRODUCT			= @v_item_id	--[자동차] 반제품 in housing moving 생성할때 to product 추가 2024/07/08
									AND a.MEASURE				= 'IN_HOUSE_MOVING'
								 ) A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								  AND X.PLANT_ID			= A.PLANT_ID
								  AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								  AND X.ITEM_ID				= A.ITEM_ID_ASSY	-- 해당하는 셀 반제품을 찾아서
								  AND X.YYYYMM				= A.YYYYMM
								  AND X.MEASURE				= 'IN_HOUSE_MOVING'
								  ;

								--3. 변경월이후 월의 재고 재계산 
								--3-1. 수정한 Prod Plan(셀 제품)의 변경수량만큼 재고 증가
								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= 'INV' 
								   AND YYYYMM				>= @v_yyyymm 
								;

								--3-2. 수정한 Prod Plan(셀 제품)의 셀 반제품을 찾아서 변경월이후 월의 재고 재계산 : (변경수량 ÷ 수율)
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY - A.REAL_MODI_QTY, 0)   -- 원래값에 (변경수량 ÷ 수율) 만큼 감소 : IN_HOUSE_MOVING --> (-)
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID,
										a.PLANT_ID,  
										a.PLAN_START_YYYYMMDD,
										a.YYYYMM ,
										x.ITEM_ID_ASSY,
										isnull(@v_modiQty / isnull(y.scp_fromation_yield,1),0) as REAL_MODI_QTY		--변경수량 ÷ 수율
									FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
									INNER JOIN (SELECT c.division_id, c.item_id_assy, MIN(c.item_id_prod) AS item_id_prod
												FROM   SCP_MST_CELL_PROD_ASSY_MAP c WITH(NOLOCK)
													INNER JOIN scp_mst_final_item f WITH(NOLOCK)
													ON  c.division_id  = f.division_id
													AND c.item_id_prod = f.item_id
													AND f.ATTRIBUTE8   = 'CP'
												WHERE  c.cell_type = 'CA1' -- Cell 생산 계획
												AND    c.valid_yn  = 'Y'   
												GROUP BY c.division_id, c.item_id_assy) x
										on x.DIVISION_ID = a.DIVISION_ID
										AND x.ITEM_ID_ASSY = a.ITEM_ID	
										AND x.item_id_prod = @v_item_id -- 셀 제품으로 셀 반제품 찾기
									-- 활성화 수율 반영 start 
									left join ( SELECT a.DIVISION_ID, ITEM_ID, x.PLANT_ID 
													, CASE  WHEN ISNULL(a.ssp_modify_yield, -99) = -99 THEN
																	CASE WHEN formation_total_yield = 0 THEN 1
																		WHEN formation_total_yield > 1 THEN 1
																		ELSE ISNULL(formation_total_yield, 1)
																	END  
															ELSE 
																	CASE WHEN ssp_modify_yield = 0 THEN 1
																		WHEN ssp_modify_yield > 1 THEN 1
																		ELSE ISNULL(ssp_modify_yield, 1)
																	END
														END AS scp_fromation_yield  
												FROM   scp_mst_formation a WITH (NOLOCK)
												left join scm_mst_site x WITH(NOLOCK)
														on  x.DIVISION_ID = a.DIVISION_ID
														and x.SCM_SITE_ID = a.PLANT_SITE_ID
												where 1=1
												and a.division_id = @v_division_id 
												) y
										on y.division_id = a.DIVISION_ID
										and y.plant_id = a.PLANT_ID
										and y.item_id = x.ITEM_ID_ASSY  
									-- 활성화 수율 반영 end
									WHERE a.division_id			= @v_division_id  
									AND a.plant_id				= @v_plant_id
									AND a.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									AND a.YYYYMM				= @v_yyyymm
									AND a.MEASURE				= 'INV'
								 ) A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								  AND X.PLANT_ID			= A.PLANT_ID
								  AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								  AND X.ITEM_ID				= A.ITEM_ID_ASSY	-- 해당하는 셀 반제품을 찾아서
								  AND X.MEASURE				= 'INV'
								  AND X.YYYYMM				>= A.YYYYMM
								  ;

							END
							--Prod Plan(모듈 반제품)			: MULTI_CHILD_ITEM 예외Case 반영 2024/11/06 START
							ELSE IF(@v_seq_flag ='250')
							BEGIN

								DECLARE @v_multi_to_product				NVARCHAR(MAX);
								DECLARE @v_multi_cell_item_id			NVARCHAR(MAX);
								DECLARE @v_accumulated_child_qty		numeric(20,10);
								DECLARE @v_yield						numeric(20,10);
								SET @v_multi_to_product			= '';
								SET @v_multi_cell_item_id		= '';
								set @v_accumulated_child_qty	= 0;
								set @v_yield = 0;

								/******************************************************
								1. 수정한 Prod Plan(모듈 반제품)의 변경수량만큼 가감
								*******************************************************/
								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= @v_measure 
								   AND LINE_ID				= @v_line_id
								   AND VALUE_TYPE			= @v_valuation_type
								   AND TO_PRODUCT			= @v_to_product
								   AND YYYYMM				= @v_yyyymm 
								;

								--1.2 수정한 item의 IN_HOUSE_MOVING 차감
								UPDATE X
								SET X.QTY					= ROUND(X.QTY + @v_modiQty, 0)     
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK)
								WHERE X.DIVISION_ID			= @v_division_id    
								AND X.PLANT_ID				 =@v_plant_id
								AND X.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								AND X.ITEM_ID				= @v_item_id
								AND X.MEASURE				= 'IN_HOUSE_MOVING' 
								AND X.YYYYMM				= @v_yyyymm

								IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_230') IS NOT NULL                        
									DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_230  

								--LOOKUP의 to_product, cell_item_id를 저장
								SELECT @v_multi_to_product = B.SEGMENT1
									 , @v_multi_cell_item_id = B.SEGMENT3	
								FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
								INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
								WHERE A.LOOKUP_TYPE = 'MULTI_CHILD_ITEM'
								AND A.VALID_YN = 'Y'
								AND B.SEGMENT2 = @v_item_id
								ORDER BY B.DISPLAY_SEQ

								--SELECT @v_multi_to_product , @v_multi_cell_item_id;

								/******************************************************
								2. 동일 To Product item_id 찾기
								*******************************************************/
								SELECT  *
								INTO #tmp_SCP_ANL_PSI_INTEGRATION_230
								FROM SCP_ANL_PSI_INTEGRATION i with(nolock)
								WHERE i.DIVISION_ID			= @v_division_id
								AND i.PLANT_ID				= @v_plant_id
								AND i.ITEM_ID				!= @v_item_id
								AND i.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								AND i.MEASURE				= 'IN_HOUSE_MOVING'
								AND i.YYYYMM				= @v_yyyymm
								AND i.TO_PRODUCT			= @v_multi_to_product

								--2.1 동일 To Product item의 IN_HOUSE_MOVING 차감
								UPDATE X
								SET X.QTY					= ROUND(X.QTY - @v_modiQty, 0)     
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK)
								, #tmp_SCP_ANL_PSI_INTEGRATION_230 A
								WHERE X.DIVISION_ID			= A.DIVISION_ID    
								AND X.PLANT_ID				= A.PLANT_ID
								AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								AND X.ITEM_ID				= A.ITEM_ID
								AND X.MEASURE				= 'IN_HOUSE_MOVING' 
								AND X.YYYYMM				= A.YYYYMM 
								AND X.TO_PRODUCT			= @v_multi_to_product

								--2.2 동일 To Product item의 PROD_PLAN 차감
								UPDATE X
								SET X.QTY					= ROUND(X.QTY - @v_modiQty, 0)     
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK)
								, #tmp_SCP_ANL_PSI_INTEGRATION_230 A
								WHERE X.DIVISION_ID			= A.DIVISION_ID    
								AND X.PLANT_ID				= A.PLANT_ID
								AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								AND X.ITEM_ID				= A.ITEM_ID
								AND X.MEASURE				= 'PROD_PLAN' 
								AND X.YYYYMM				= A.YYYYMM 
								AND X.LINE_ID				= @v_line_id


								/******************************************************
								3. 수율
								*******************************************************/
								IF OBJECT_ID('tempdb..#tmp_psi_integration_YIELD_VER_H_V_230') IS NOT NULL                        
									DROP TABLE #tmp_psi_integration_YIELD_VER_H_V_230

								SELECT y.operation_group,  a.*
								INTO #tmp_psi_integration_YIELD_VER_H_V_230
								FROM SCM_MST_YIELD_VER_H_V a with(nolock)
								INNER JOIN (
											SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
											FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
											WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
											AND b.valid_yn = 'Y'
											AND b.segment3 = 'Y'
											AND b.segment5 = 'P'   --'P':Pack, 'A':Cell
											) y
									ON a.operation_id = y.operation_id
								WHERE a.division_id = @v_division_id 
								AND a.item_id = @v_multi_to_product

								/******************************************************
								4. 셀제품 조회
								*******************************************************/
								IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_CELL') IS NOT NULL                        
									DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_CELL    

								SELECT a.DIVISION_ID
									, a.PLANT_ID
									, a.PLAN_START_YYYYMMDD
									, a.YYYYMM
									, a.MEASURE
									, b.child_item_id
									, isnull(b.accumulated_child_qty,1) AS accumulated_child_qty
									, isnull(y.yield,1) AS yield
									, isnull(@v_modiQty * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1),0) as REAL_MODI_QTY  -- 변경수량 X 팩당 Cell 소요량 ÷ 수율
								INTO #tmp_SCP_ANL_PSI_INTEGRATION_CELL
								FROM SCP_ANL_PSI_INTEGRATION a
								INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
									ON  b.division_id = a.DIVISION_ID
									AND b.plant_id = a.plant_id
									AND b.model_id = @v_multi_to_product
									AND a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
								INNER JOIN scp_mst_final_item c WITH(NOLOCK)
									ON c.item_id = B.child_item_id
									AND c.DIVISION_ID = a.DIVISION_ID
									AND c.OPERATION_GROUP_ID = 'A'  
									AND c.attribute8 = 'CP'
								-- pack, cell 수율반영 가져 오기
								LEFT JOIN #tmp_psi_integration_YIELD_VER_H_V_230 y 
									ON y.division_id = a.DIVISION_ID
									--and y.operation_group =a.OPERATION_GROUP	--팩 item의 수율조회를 위해수정
									AND y.company_id = a.COMPANY_ID
									AND y.plant_id = a.PLANT_ID
									AND y.line_id = @v_line_id					--팩 item의 수율조회를 위해수정
									AND y.month = a.yyyymm
									AND y.item_id = @v_multi_to_product			--팩 item의 수율조회를 위해수정
								WHERE a.division_id = @v_division_id  
								AND a.plant_id = @v_plant_id
								AND a.ITEM_ID = b.child_item_id
								AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
								AND a.YYYYMM = @v_yyyymm
								AND a.MEASURE = 'IN_HOUSE_MOVING'


								--4.1 팩제품에 대한 셀 제품 투입량 계산
								UPDATE X
								SET X.QTY					= ROUND(X.QTY - A.REAL_MODI_QTY, 0)     --증가(+)에서 차감(-)으로 변경
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								 FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
									, #tmp_SCP_ANL_PSI_INTEGRATION_CELL A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								AND X.PLANT_ID				= A.PLANT_ID
								AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								AND X.ITEM_ID				= A.child_item_id
								AND X.YYYYMM				= A.YYYYMM
								AND X.MEASURE				= 'IN_HOUSE_MOVING'

								/******************************************************
								5. LOOKUP의 MULTI_CHILD_ITEM에 등록된 셀 제품에 적용할 소요율과 수율
								*******************************************************/
								SELECT @v_accumulated_child_qty = accumulated_child_qty
									 , @v_yield = yield
								FROM #tmp_SCP_ANL_PSI_INTEGRATION_CELL

								--5.0 IN_HOUSE_MOVING 있는지 확인 없으면 insert.
								SELECT @v_measure_count = COUNT(*)
								  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								 WHERE X.DIVISION_ID			= @v_division_id
								   AND X.PLANT_ID				= @v_plant_id
								   AND X.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND X.ITEM_ID				= @v_multi_cell_item_id
								   AND X.YYYYMM				= @v_yyyymm
								   AND X.MEASURE				= 'IN_HOUSE_MOVING'

								IF @v_measure_count = 0
								BEGIN
									INSERT INTO SCP_ANL_PSI_INTEGRATION (
														DIVISION_ID, 
														COMPANY_ID, 
														PLANT_ID, 
														PLAN_START_YYYYMMDD, 
														SEQ,
														OPERATION_GROUP,
														FROM_SITE, CELL_ITEM_ID,
														ITEM_ID, 
														MEASURE, 
														VALUE_TYPE, 
														TO_PRODUCT, 
														LINE_ID, 
														BOH_QTY, 
														TO_SITE, 
														INCOTERMS, 
														SEQ_FLAG, 
														YYYYMM,
														QTY, 
														CREATED_BY, 
														CREATION_DATE, 
														LAST_UPDATED_BY, 
														LAST_UPDATE_DATE)
												VALUES (@v_division_id,
														@v_company_id,
														@v_plant_id,
														@p_plan_start_yyyymmdd,
														'1',
														'A',--(CASE WHEN @v_operation_group = 'Pack' THEN 'P' WHEN @v_operation_group = 'Cell' THEN 'A' ELSE 'E' END)
														'-', 
														@v_cellitem_id,
														@v_multi_cell_item_id,
														'IN_HOUSE_MOVING',
														'-',
														'-',
														'-',
														0,
														'-',
														'-',
														@v_seq_flag,
														@v_yyyymm,
														'0',
														'SYSTEM',
														GETDATE(),
														'SYSTEM',
														GETDATE());
								END

								--5.1 LOOKUP의 MULTI_CHILD_ITEM에 등록된 셀 제품 투입량 계산
								UPDATE X
								SET X.QTY					= ROUND(X.QTY + isnull(@v_modiQty * @v_accumulated_child_qty / @v_yield, 0), 0)     
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								WHERE X.DIVISION_ID			= @v_division_id
								AND X.PLANT_ID				= @v_plant_id
								AND X.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								AND X.ITEM_ID				= @v_multi_cell_item_id
								AND X.YYYYMM				= @v_yyyymm
								AND X.MEASURE				= 'IN_HOUSE_MOVING'

								/******************************************************
								6.재고 계산
								*******************************************************/
								--수정한 Prod Plan(모듈 반제품)의 재고 변동없음으로 주석처리
								----6.1 수정한 Prod Plan(모듈 반제품)의 변경수량만큼 재고 증가
								--UPDATE SCP_ANL_PSI_INTEGRATION
								--   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
								--	  ,LAST_UPDATED_BY		= @v_last_updated_by 
								--	  ,LAST_UPDATE_DATE		= SYSDATETIME()
								-- WHERE DIVISION_ID			= @v_division_id     
								--   AND PLANT_ID				= @v_plant_id 
								--   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								--   AND ITEM_ID				= @v_item_id 
								--   AND MEASURE				= 'INV' 
								--   AND YYYYMM				>= @v_yyyymm 
								--;

								--6.2 팩제품에 대한 셀 제품의 투입수량만큼 재고 증가
								UPDATE X
								SET X.QTY					= ROUND(X.QTY + A.REAL_MODI_QTY, 0)     
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								 FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
									, #tmp_SCP_ANL_PSI_INTEGRATION_CELL A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								AND X.PLANT_ID				= A.PLANT_ID
								AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								AND X.ITEM_ID				= A.child_item_id
								AND X.YYYYMM				>= A.YYYYMM
								AND X.MEASURE				= 'INV'

								--6.3 LOOKUP의 MULTI_CHILD_ITEM에 등록된 셀 제품 투입량만큼 재고 증가
								UPDATE X
								SET X.QTY					= ROUND(X.QTY - isnull(@v_modiQty * @v_accumulated_child_qty / @v_yield, 0), 0)    --증가(+)에서 차감(-)으로 변경 
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								WHERE X.DIVISION_ID			= @v_division_id
								AND X.PLANT_ID				= @v_plant_id
								AND X.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								AND X.ITEM_ID				= @v_multi_cell_item_id
								AND X.YYYYMM				>= @v_yyyymm
								AND X.MEASURE				= 'INV'

								DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_230;
								DROP TABLE #tmp_psi_integration_YIELD_VER_H_V_230;
								DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_CELL;

							END
							--MULTI_CHILD_ITEM 예외Case 반영 2024/11/06 END
							--Prod Plan(팩/모듈 제품)		: 해당하는 팩/모듈 반제품, 셀 제품을 찾아서  가감
							--								  해당하는 팩/모듈 반제품 동일 Plant의 In-house Moving, Prod Plan를 +- 해줌
							--								  해당하는 팩/모듈 제품의 셀 제품을 찾아서 변경수량 X 팩당 Cell 소요량 ÷ 수율 을 +- 해줌
							ELSE IF(@v_seq_flag ='150')
							BEGIN

								--1. 수정한 Prod Plan(팩/모듈)의 변경수량만큼 가감
								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= @v_measure 
								   AND LINE_ID				= @v_line_id
								   AND VALUE_TYPE			= @v_valuation_type
								   AND TO_PRODUCT			= @v_to_product
								   AND YYYYMM				= @v_yyyymm 
								;

								--DECLARE @v_child_item_id	NVARCHAR(MAX);		--팩/모듈 반제품
								--DECLARE @ACCUMULATED_CHILD_QTY	numeric(20,10);	--소요량
								--SET @v_child_item_id = NULL;
								--SET @ACCUMULATED_CHILD_QTY = 0.0;

								----2. 팩/모듈 제품의 팩/모듈 반제품 찾기
								--SELECT @v_child_item_id = ISNULL(a.CHILD_ITEM_ID, '')
								--	, @ACCUMULATED_CHILD_QTY = ISNULL(a.ACCUMULATED_CHILD_QTY, 1.0)
								--FROM SCP_ANL_PSI_INTEGRATION i with(nolock)
								--left join SCM_MST_BOM_EFFECTIVE_SN_V a with(nolock)
								--	on a.model_id = i.ITEM_ID
								--	and a.parent_item_id = i.ITEM_ID
								--	and a.division_id = i.division_id
								--	and a.COMPANY_ID = i.company_id 
								--	AND i.PLAN_START_YYYYMMDD BETWEEN a.eff_start_date and a.eff_end_date  
								--	AND (a.alt_id IS NULL 
								--		OR (a.alt_id IS NOT NULL AND a.scp_plan_yn IS NULL AND ISNULL(a.alt_priority, '1') = 'Y') 
								--		OR (a.alt_id IS NOT NULL AND a.scp_plan_yn IS NOT NULL AND a.scp_plan_yn = 'Y'))
								--inner join scm_mst_item_sn b with(nolock)
								----inner join LGCE_FPDEV_TR.dbo.SCM_ITEM_M b with(nolock)
								--	on a.division_id = b.division_id
								--	and a.company_id = b.company_id
								--	and a.child_item_id = b.item_id
								--	and ISNULL(b.scp_flow_id, b.flow_id) = 'P5000'
								--WHERE 1=1
								--AND i.DIVISION_ID			= @v_division_id
								--AND i.PLANT_ID				= @v_plant_id
								--AND i.ITEM_ID				= @v_item_id
								--AND i.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								--AND i.MEASURE				= @v_measure
								--AND i.YYYYMM				= @v_yyyymm
								--AND i.LINE_ID				= @v_line_id
								--;

								--2.1 수정한 Prod Plan(팩/모듈)의  In-house Moving(팩/모듈 반제품)의 변경수량만큼 가감
								UPDATE X
								   SET X.QTY					= ROUND(X.QTY + (@v_modiQty * A.ACCUMULATED_CHILD_QTY), 0)
									  ,X.LAST_UPDATED_BY		= @v_last_updated_by 
									  ,X.LAST_UPDATE_DATE		= SYSDATETIME()
								  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK)
								 , (
									SELECT   i.DIVISION_ID
											, i.PLANT_ID
											, i.PLAN_START_YYYYMMDD
											, i.YYYYMM
											, i.MEASURE
									, a.CHILD_ITEM_ID,  a.ACCUMULATED_CHILD_QTY
									FROM SCP_ANL_PSI_INTEGRATION i with(nolock)
									left join SCM_MST_BOM_EFFECTIVE_SN_V a with(nolock)
										on a.model_id = i.ITEM_ID
										and a.parent_item_id = i.ITEM_ID
										and a.division_id = i.division_id
										and a.COMPANY_ID = i.company_id 
										and a.PLANT_ID = i.plant_id 
										AND i.PLAN_START_YYYYMMDD BETWEEN a.eff_start_date and a.eff_end_date  
										AND (a.alt_id IS NULL 
											OR (a.alt_id IS NOT NULL AND a.scp_plan_yn IS NULL AND ISNULL(a.alt_priority, '1') = 'Y') 
											OR (a.alt_id IS NOT NULL AND a.scp_plan_yn IS NOT NULL AND a.scp_plan_yn = 'Y'))
									inner join scm_mst_item_sn b with(nolock)
										on a.division_id = b.division_id
										and a.company_id = b.company_id
										and a.child_item_id = b.item_id
										and ISNULL(b.scp_flow_id, b.flow_id) = 'P5000'
									WHERE i.DIVISION_ID			= @v_division_id
									AND i.PLANT_ID				= @v_plant_id
									AND i.ITEM_ID				= @v_item_id
									AND i.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									AND i.MEASURE				= @v_measure
									AND i.YYYYMM				= @v_yyyymm
									AND i.LINE_ID				= @v_line_id
								) A
								 WHERE X.DIVISION_ID			= A.DIVISION_ID   
								   AND X.PLANT_ID				= A.PLANT_ID 
								   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								   AND X.ITEM_ID				= A.child_item_id 
								   AND X.MEASURE				= 'IN_HOUSE_MOVING' 
								   AND X.YYYYMM					= A.YYYYMM 
								   AND X.TO_PRODUCT				= @v_item_id	--[자동차] 반제품 in housing moving 생성할때 to product 추가 2024/07/08
								;

								--2.2 수정한 Prod Plan(팩/모듈)의  Prod Plan(팩/모듈 반제품)의 변경수량만큼 가감
								UPDATE SCP_ANL_PSI_INTEGRATION
								   --SET QTY					= ROUND(QTY + (@v_modiQty * A.ACCUMULATED_CHILD_QTY), 0)  
								   SET QTY					= (CASE WHEN ROUND(QTY + (@v_modiQty * A.ACCUMULATED_CHILD_QTY), 0) >= 0 THEN ROUND(QTY + (@v_modiQty * A.ACCUMULATED_CHILD_QTY), 0) ELSE 0 END )	-- 팩/모듈 제품의 Prod Plan 변경된 수량만큼 팩/모듈 반제품의 Prod Plan을 조정할때 음수로 떨어지지는 않도록(2024/11/05)
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK)
								 , (
									SELECT   i.DIVISION_ID
											, i.PLANT_ID
											, i.PLAN_START_YYYYMMDD
											, i.YYYYMM
											, i.MEASURE
											, i.LINE_ID
									, a.CHILD_ITEM_ID,  a.ACCUMULATED_CHILD_QTY
									FROM SCP_ANL_PSI_INTEGRATION i with(nolock)
									left join SCM_MST_BOM_EFFECTIVE_SN_V a with(nolock)
										on a.model_id = i.ITEM_ID
										and a.parent_item_id = i.ITEM_ID
										and a.division_id = i.division_id
										and a.COMPANY_ID = i.company_id 
										and a.PLANT_ID = i.plant_id 
										AND i.PLAN_START_YYYYMMDD BETWEEN a.eff_start_date and a.eff_end_date  
										AND (a.alt_id IS NULL 
											OR (a.alt_id IS NOT NULL AND a.scp_plan_yn IS NULL AND ISNULL(a.alt_priority, '1') = 'Y') 
											OR (a.alt_id IS NOT NULL AND a.scp_plan_yn IS NOT NULL AND a.scp_plan_yn = 'Y'))
									inner join scm_mst_item_sn b with(nolock)
										on a.division_id = b.division_id
										and a.company_id = b.company_id
										and a.child_item_id = b.item_id
										and ISNULL(b.scp_flow_id, b.flow_id) = 'P5000'
									WHERE i.DIVISION_ID			= @v_division_id
									AND i.PLANT_ID				= @v_plant_id
									AND i.ITEM_ID				= @v_item_id
									AND i.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									AND i.MEASURE				= @v_measure
									AND i.YYYYMM				= @v_yyyymm
									AND i.LINE_ID				= @v_line_id
								) A
								 WHERE X.DIVISION_ID			= A.DIVISION_ID   
								   AND X.PLANT_ID				= A.PLANT_ID 
								   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								   AND X.ITEM_ID				= A.child_item_id 
								   AND X.MEASURE				= 'PROD_PLAN' 
								   AND X.YYYYMM					= A.YYYYMM
								   AND X.LINE_ID				= A.LINE_ID
								;


								IF OBJECT_ID('tempdb..#tmp_psi_integration_YIELD_VER_H_V') IS NOT NULL                        
								DROP TABLE #tmp_psi_integration_YIELD_VER_H_V     
	
								-- pack, cell 수율반영 가져 오기
								select y.operation_group,  a.*
								into #tmp_psi_integration_YIELD_VER_H_V
								from SCM_MST_YIELD_VER_H_V a with(nolock)
								inner join (
											SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
											from scm_adm_lookup_master_detail b WITH(NOLOCK)
											where b.lookup_type = 'LOCATION_GROUP_ROUTE'
											and b.valid_yn = 'Y'
											and b.segment3 = 'Y'
											and b.segment5 = 'P'   --'P':Pack, 'A':Cell
											) y
								on a.operation_id = y.operation_id
								where 1=1
								and a.division_id = @v_division_id 


								--3. 해당하는 팩/모듈 제품의 셀 제품을 찾아서 변경수량 X 팩당 Cell 소요량 ÷ 수율 을 +- 해줌
								UPDATE  X
								   SET X.QTY				= (CASE WHEN ROUND(X.QTY + A.REAL_MODI_QTY, 0) >= 0 THEN ROUND(X.QTY + A.REAL_MODI_QTY, 0) ELSE 0 END)	-- 팩/모듈 제품의 Prod Plan 변경된 수량만큼 팩/모듈 반제품의 Prod Plan을 조정할때 음수로 떨어지지는 않도록(2024/11/01)	
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID
											, a.PLANT_ID
											, a.PLAN_START_YYYYMMDD
											, a.YYYYMM
											, a.MEASURE
											--, a.ITEM_ID
											, b.child_item_id
											, isnull(@v_modiQty * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1),0) as REAL_MODI_QTY  -- 변경수량 X 팩당 Cell 소요량 ÷ 수율
									FROM SCP_ANL_PSI_INTEGRATION a
										inner join SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
												on  b.division_id = a.DIVISION_ID
												and b.plant_id = a.plant_id
												and b.model_id = @v_item_id
												and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
										inner join scp_mst_final_item c WITH(NOLOCK)
												on c.item_id = B.child_item_id
												and c.DIVISION_ID = a.DIVISION_ID
												and c.OPERATION_GROUP_ID = 'A'  
												and c.attribute8 = 'CP'
										-- pack, cell 수율반영 가져 오기
										--left join (select y.operation_group,  a.*
										--			from SCM_MST_YIELD_VER_H_V a with(nolock)
										--			inner join (
										--						SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
										--						from scm_adm_lookup_master_detail b WITH(NOLOCK)
										--						where b.lookup_type = 'LOCATION_GROUP_ROUTE'
										--						and b.valid_yn = 'Y'
										--						and b.segment3 = 'Y'
										--						and b.segment5 = 'P'   --'P':Pack, 'A':Cell
										--					   ) y
										--			on a.operation_id = y.operation_id
										--			where 1=1
										--			and a.division_id = @v_division_id ) y 
										left join #tmp_psi_integration_YIELD_VER_H_V y
											on y.division_id	= a.DIVISION_ID
											--and y.operation_group =a.OPERATION_GROUP		--팩 item의 수율조회를 위해수정(2024/11/05)
											and y.company_id	= a.COMPANY_ID
											and y.plant_id		= a.PLANT_ID
											and y.line_id		= @v_line_id	--a.LINE_ID	--팩 item의 수율조회를 위해수정(2024/10/31)
											and y.month			= a.yyyymm
											and y.item_id		= @v_item_id	--a.ITEM_ID	--팩 item의 수율조회를 위해수정(2024/10/31) 
									WHERE a.division_id			= @v_division_id  
									AND a.plant_id				= @v_plant_id
									AND a.ITEM_ID				= b.child_item_id
									AND a.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									AND a.YYYYMM				= @v_yyyymm
									AND a.MEASURE				= 'IN_HOUSE_MOVING'
									) A
								WHERE X.DIVISION_ID				= A.DIVISION_ID
									AND X.PLANT_ID				= A.PLANT_ID
									AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
									AND X.ITEM_ID				= A.child_item_id
									AND X.YYYYMM				= A.YYYYMM
									AND X.MEASURE				= 'IN_HOUSE_MOVING'

								--4. 변경월이후 월의 재고 재계산 
								--4.1 수정한 Prod Plan(팩/모듈)의 변경수량만큼 재고 증가
								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= 'INV' 
								   AND YYYYMM				>= @v_yyyymm 
								;

								--4.2. 해당하는 팩/모듈 제품의 셀 제품을 찾아서 변경월이후 월의 재고 재계산 : (변경수량 X 팩당 Cell 소요량 ÷ 수율) 
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY - A.REAL_MODI_QTY, 0)   -- 원래값에 (변경수량 X 팩당 Cell 소요량 ÷ 수율) 만큼 감소 : IN_HOUSE_MOVING --> (-)
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID
											, a.PLANT_ID
											, a.PLAN_START_YYYYMMDD
											, a.YYYYMM
											, a.MEASURE
											--, a.ITEM_ID
											, b.child_item_id
											, isnull(@v_modiQty * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1),0) as REAL_MODI_QTY  -- 변경수량 X 팩당 Cell 소요량 ÷ 수율
									FROM SCP_ANL_PSI_INTEGRATION a
											inner join SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
													on  b.division_id = a.DIVISION_ID
													and b.plant_id = a.plant_id
													and b.model_id = @v_item_id
													and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
											inner join scp_mst_final_item c WITH(NOLOCK)
													on c.item_id = B.child_item_id
													and c.DIVISION_ID = a.DIVISION_ID
													and c.OPERATION_GROUP_ID = 'A'  
													and c.attribute8 = 'CP'
											-- pack, cell 수율반영 가져 오기
											--left join (select y.operation_group,  a.*
											--			from SCM_MST_YIELD_VER_H_V a with(nolock)
											--			inner join (
											--						SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
											--						from scm_adm_lookup_master_detail b WITH(NOLOCK)
											--						where b.lookup_type = 'LOCATION_GROUP_ROUTE'
											--						and b.valid_yn = 'Y'
											--						and b.segment3 = 'Y'
											--						and b.segment5 = 'P'   --'P':Pack, 'A':Cell
											--					   ) y
											--			on a.operation_id = y.operation_id
											--			where 1=1
											--			and a.division_id = @v_division_id ) y 
											left join #tmp_psi_integration_YIELD_VER_H_V y
												on y.division_id = a.DIVISION_ID
												--and y.operation_group =a.OPERATION_GROUP	--팩 item의 수율조회를 위해수정(2024/12/05)
												and y.company_id = a.COMPANY_ID
												and y.plant_id = a.PLANT_ID
												and y.line_id = @v_line_id--a.LINE_ID		--팩 item의 수율조회를 위해수정(2024/12/05)
												and y.month = a.yyyymm
												and y.item_id = @v_item_id--a.ITEM_ID		--팩 item의 수율조회를 위해수정(2024/12/05)
									WHERE a.division_id			= @v_division_id  
									AND a.plant_id				= @v_plant_id
									AND a.ITEM_ID				= b.child_item_id
									AND a.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									AND a.YYYYMM				= @v_yyyymm
									AND a.MEASURE				= 'INV'
									) A
								WHERE X.DIVISION_ID				= A.DIVISION_ID
									AND X.PLANT_ID				= A.PLANT_ID
									AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
									AND X.ITEM_ID				= A.child_item_id
									AND X.MEASURE				= 'INV'
									AND X.YYYYMM				>= A.YYYYMM


								drop table #tmp_psi_integration_YIELD_VER_H_V;

							END;	--4. Prod Plan(팩/모듈 제품)
						
						END;	--PROD_PLAN 수정인 경우

					END -- @v_division_id != '82'
					
					-- ESS인 경우
					ELSE IF(@v_division_id = '82')
					BEGIN

						--1. 실제 수정한 값 수정
						UPDATE SCP_ANL_PSI_INTEGRATION
							SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 가감
								,LAST_UPDATED_BY		= @v_last_updated_by 
								,LAST_UPDATE_DATE		= SYSDATETIME()
							WHERE DIVISION_ID			= @v_division_id     
							AND PLANT_ID				= @v_plant_id
							AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
							AND CELL_ITEM_ID			= @v_cellitem_id 
							AND ITEM_ID					= @v_item_id 
							AND MEASURE					= @v_measure 
							AND LINE_ID					= @v_line_id
							AND VALUE_TYPE				= @v_valuation_type
							AND TO_PRODUCT				= @v_to_product
							AND TO_SITE					= @v_to_site
							AND YYYYMM					= @v_yyyymm 
						;

						-- SHIP_PLAN_SEMI 수정인 경우			
						IF(@v_measure ='SHIP_PLAN_SEMI') 
						BEGIN
						
							
							DECLARE @tmp_valuation_type  NVARCHAR(MAX);
							SET @tmp_valuation_type = '-';

							IF (@v_valuation_type != '-')
								SET @tmp_valuation_type = 'PUR';

							--2. 수정한 Ship plan(SEMI)에 해당하는 Semi WH In 항목을 찾아서 변경
							UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 가감
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   -- csr ymh
								   -- AND PLANT_ID				= @v_to_site			-- TO_SITE = Plant_ID 항목 대상 
								   -- csr ymh
								   AND PLANT_ID				= REPLACE(@v_to_site,'VP_','')			-- TO_SITE = Plant_ID 항목 대상 
								   
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND VALUE_TYPE			= @tmp_valuation_type 
								   AND MEASURE				= 'SEMI_WH_IN'
								   AND YYYYMM				= @v_yyyymm 
							;


							--3. 변경월이후 월의 재고 재계산 
							IF (@v_valuation_type != '-')
							BEGIN

								--3-1. 수정한 Ship plan(SEMI)의 변경월이후 월의 재고 재계산(PRD)
								UPDATE SCP_ANL_PSI_INTEGRATION
									SET QTY						= ROUND(QTY - @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 재고 감소 : Ship plan(SEMI) --> (-)
										,LAST_UPDATED_BY		= @v_last_updated_by 
										,LAST_UPDATE_DATE		= SYSDATETIME()
									WHERE DIVISION_ID			= @v_division_id     
									AND PLANT_ID				= @v_plant_id
									AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
									AND CELL_ITEM_ID			= @v_cellitem_id 
									AND ITEM_ID					= @v_item_id 
									AND VALUE_TYPE				= @v_valuation_type 
									AND MEASURE					= 'INV' 
									AND YYYYMM					>= @v_yyyymm 
								;

								--3-2. 수정한 Ship plan(SEMI)에 해당하는 Semi WH In의 변경월이후 월의 재고 재계산(PUR)
								UPDATE SCP_ANL_PSI_INTEGRATION
									SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 재고 증가 : Semi WH In --> (+)
										,LAST_UPDATED_BY		= @v_last_updated_by 
										,LAST_UPDATE_DATE		= SYSDATETIME()
									WHERE DIVISION_ID			= @v_division_id     
									--AND PLANT_ID				= @v_to_site			-- TO_SITE = Plant_ID 항목 대상 
									AND PLANT_ID				= replace(@v_to_site,'VP_','')			-- TO_SITE = Plant_ID 항목 대상 
									AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
									AND ITEM_ID					= @v_item_id 
									AND VALUE_TYPE				= @tmp_valuation_type
									AND MEASURE					= 'INV'
									AND YYYYMM					>= @v_yyyymm 
								;

							END


							--3-3. 수정한 Ship plan(SEMI)의 변경월이후 월의 재고 재계산
							UPDATE SCP_ANL_PSI_INTEGRATION
								SET QTY						= ROUND(QTY - @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 재고 감소 : Ship plan(SEMI) --> (-)
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								WHERE DIVISION_ID			= @v_division_id     
								AND PLANT_ID				= @v_plant_id
								AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
								AND CELL_ITEM_ID			= @v_cellitem_id 
								AND ITEM_ID					= @v_item_id 
								AND VALUE_TYPE				= '-'
								AND MEASURE					= 'INV' 
								AND YYYYMM					>= @v_yyyymm 
							;

							--3-4. 수정한 Ship plan(SEMI)에 해당하는 Semi WH In의 변경월이후 월의 재고 재계산
							UPDATE SCP_ANL_PSI_INTEGRATION
								SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 재고 증가 : Semi WH In --> (+)
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								WHERE DIVISION_ID			= @v_division_id     
								--AND PLANT_ID				= @v_to_site			-- TO_SITE = Plant_ID 항목 대상 
								AND PLANT_ID				= replace(@v_to_site,'VP_','')
								AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
								AND ITEM_ID					= @v_item_id 
								AND VALUE_TYPE				= '-'
								AND MEASURE					= 'INV'
								AND YYYYMM					>= @v_yyyymm 
							;

						END
						--PROD_PLAN 수정인 경우
						ELSE IF(@v_measure ='PROD_PLAN')
						BEGIN

							--Prod Plan(전극)	: 수정한 Prod Plan만 저장
							IF(@v_seq_flag ='550')
							BEGIN
								
								-- 변경월이후 월의 재고 재계산 
								UPDATE SCP_ANL_PSI_INTEGRATION
									SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 증가 : Prod Plan --> (+)
										,LAST_UPDATED_BY		= @v_last_updated_by 
										,LAST_UPDATE_DATE		= SYSDATETIME()
									WHERE DIVISION_ID			= @v_division_id     
									AND PLANT_ID				= @v_plant_id
									AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
									AND ITEM_ID					= @v_item_id 
									AND MEASURE					= 'INV' 
									AND YYYYMM					>= @v_yyyymm 
								;

							END
							--Prod Plan(셀)		: 해당하는 전극을 찾아서  가감
							ELSE IF(@v_seq_flag ='350')
							BEGIN

								--2. 수정한 Prod Plan(셀)의 전극을 찾아서 가감 : (변경수량 X Cell당 전극 소요량 ÷ 수율)
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID
										--, a.COMPANY_ID
										--, a.PLANT_ID
										--, case when a.COMPANY_ID = 'C100' then 'A041' else m.PLANT_ID end as plant_id
										, CASE WHEN a.COMPANY_ID = @v_ESOC THEN @v_ESNJ			ELSE a.COMPANY_ID END AS COMPANY_ID	--전극의 COMPANY_ID, ESS A050의 투입 전극은 A041이 아니라 G183으로 생성에 따른 변경 2024-08-01
										, CASE WHEN a.COMPANY_ID = @v_ESOC THEN @v_ESNJ_PLANT	ELSE m.PLANT_ID END AS plant_id		--전극의 plant_id, ESS A050의 투입 전극은 A041이 아니라 G183으로 생성에 따른 변경 2024-08-01
										, a.PLAN_START_YYYYMMDD
										, a.YYYYMM
										, b.child_item_id
										-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 START 
										--, isnull(@v_modiQty * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1),0) as REAL_MODI_QTY	-- 변경수량 X Cell당 전극 소요량 ÷ 수율
										, isnull(@v_modiQty * isnull(b.USAGE,1) / isnull(y.yield,1),0) as REAL_MODI_QTY	-- 변경수량 X Cell당 전극 소요량 ÷ 수율
										-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 END
									FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
									inner join (select distinct COMPANY_ID, PLANT_ID
												  from SCM_MST_SITE
												  where 1=1
												  and SITE_TYPE = 'plant'
												  and OPERATION_GROUP = 'E'
												  and VALID_YN = 'Y') M 
									--ON m.COMPANY_ID = a.COMPANY_ID
									ON m.COMPANY_ID = CASE WHEN a.COMPANY_ID = @v_ESOC THEN @v_ESNJ	 ELSE a.COMPANY_ID END	--ESS A050의 투입 전극은 A041이 아니라 G183으로 생성에 따른 변경 2024-08-01
									-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 START
									INNER JOIN SCP_MST_BOM_ELEC b WITH(NOLOCK)
										ON b.DIVISION_ID = @v_division_id
										AND b.PARENT_ITEM_ID = a.ITEM_ID
										ANd b.SCP_YN = 'Y'
									-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 END
									-- pack/cell 수율 반영 start 
									LEFT JOIN (select y.operation_group,  a.*
												from SCM_MST_YIELD_VER_H_V a with(nolock)
												INNER JOIN (
															SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
															  from scm_adm_lookup_master_detail b WITH(NOLOCK)
															 where b.lookup_type = 'LOCATION_GROUP_ROUTE'
															   AND b.valid_yn = 'Y'
															   AND b.segment3 = 'Y'
															   AND b.segment5 = 'A'  --'P':Pack, 'A':Cell
															) y
													on a.operation_id = y.operation_id
												where 1=1
												  AND a.division_id = @v_division_id ) y 
										on y.division_id		= a.DIVISION_ID
										AND y.operation_group	= a.OPERATION_GROUP
										AND y.company_id		= a.COMPANY_ID
										AND y.line_id			= a.LINE_ID
										AND y.month				= a.YYYYMM
										AND y.item_id			= a.ITEM_ID  
									-- pack/cell 수율 반영 end 

									WHERE a.division_id			= @v_division_id
									  AND a.plant_id			= @v_plant_id
									  AND a.ITEM_ID				= @v_item_id
									  AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									  AND a.YYYYMM				= @v_yyyymm
									  and a.LINE_ID				= @v_line_id
									  AND a.MEASURE				= 'PROD_PLAN'
									) A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								  AND X.PLANT_ID			= A.PLANT_ID
								  AND X.TO_SITE				= @v_plant_id	--셀의 platn_id를 전극의 to_site로 구분해서 찾음, ESS A050의 투입 전극은 A041이 아니라 G183으로 생성에 따른 변경 2024-08-01
								  AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								  AND X.ITEM_ID				= A.child_item_id	-- 해당하는 전극을 찾아서
								  AND X.YYYYMM				= A.YYYYMM
								  AND X.MEASURE				= 'IN_HOUSE_MOVING'
								  ;
								

								--3. 변경월이후 월의 재고 재계산 
								--3-1. 수정한 Prod Plan(셀)의 변경월이후 월의 재고 재계산(PRD, - 둘다 재계산)
								UPDATE SCP_ANL_PSI_INTEGRATION
									SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 변경수량만큼 재고 증가 : Prod Plan --> (+)
										,LAST_UPDATED_BY		= @v_last_updated_by 
										,LAST_UPDATE_DATE		= SYSDATETIME()
									WHERE DIVISION_ID			= @v_division_id     
									AND PLANT_ID				= @v_plant_id
									AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
									AND CELL_ITEM_ID			= @v_cellitem_id 
									AND ITEM_ID					= @v_item_id 
									AND (VALUE_TYPE	= @v_valuation_type OR VALUE_TYPE = '-')
									AND MEASURE					= 'INV' 
									AND YYYYMM					>= @v_yyyymm 
								;


								--3-2. 수정한 Prod Plan(셀 반제품)의 전극을 찾아서 변경월이후 월의 재고 재계산 : (변경수량 X Cell당 전극 소요량 ÷ 수율) 
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY - A.REAL_MODI_QTY, 0)   -- 원래값에 (변경수량 X Cell당 전극 소요량 ÷ 수율) 만큼 감소 : IN_HOUSE_MOVING --> (-)
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID
										--, a.COMPANY_ID
										--, a.PLANT_ID
										--, case when a.COMPANY_ID = 'C100' then 'A041' else m.PLANT_ID end as plant_id
										, CASE WHEN a.COMPANY_ID = @v_ESOC THEN @v_ESNJ			ELSE a.COMPANY_ID END AS COMPANY_ID	--전극의 COMPANY_ID, ESS A050의 투입 전극은 A041이 아니라 G183으로 생성에 따른 변경 2024-08-01
										, CASE WHEN a.COMPANY_ID = @v_ESOC THEN @v_ESNJ_PLANT	ELSE m.PLANT_ID END AS plant_id		--전극의 plant_id, ESS A050의 투입 전극은 A041이 아니라 G183으로 생성에 따른 변경 2024-08-01
										, a.PLAN_START_YYYYMMDD
										, a.YYYYMM
										, b.child_item_id
										-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 START 
										, isnull(@v_modiQty * isnull(b.USAGE,1) / isnull(y.yield,1),0) as REAL_MODI_QTY	-- 변경수량 X Cell당 전극 소요량 ÷ 수율
										-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 END
									FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
									inner join (select distinct COMPANY_ID, PLANT_ID
												  from SCM_MST_SITE
												  where 1=1
												  and SITE_TYPE = 'plant'
												  and OPERATION_GROUP = 'E'
												  and VALID_YN = 'Y') M 
									--ON m.COMPANY_ID = a.COMPANY_ID
									ON m.COMPANY_ID = CASE WHEN a.COMPANY_ID = @v_ESOC THEN @v_ESNJ ELSE a.COMPANY_ID END	--ESS A050의 투입 전극은 A041이 아니라 G183으로 생성에 따른 변경 2024-08-01
									-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 START 
									INNER JOIN SCP_MST_BOM_ELEC b WITH(NOLOCK)
										ON b.DIVISION_ID = @v_division_id
										AND b.PARENT_ITEM_ID = a.ITEM_ID
										ANd b.SCP_YN = 'Y'
									-- 셀에 투입되는 전극 SCP BOM의 SCP_YN을 참고하도록 변경 2024-07-24 END
									-- pack/cell 수율 반영 start 
									LEFT JOIN (select y.operation_group,  a.*
												from SCM_MST_YIELD_VER_H_V a with(nolock)
												INNER JOIN (
															SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
															  from scm_adm_lookup_master_detail b WITH(NOLOCK)
															 where b.lookup_type = 'LOCATION_GROUP_ROUTE'
															   AND b.valid_yn = 'Y'
															   AND b.segment3 = 'Y'
															   AND b.segment5 = 'A'  --'P':Pack, 'A':Cell
															) y
													on a.operation_id = y.operation_id
												where 1=1
												  AND a.division_id = @v_division_id ) y 
										on y.division_id		= a.DIVISION_ID
										AND y.operation_group	= a.OPERATION_GROUP
										AND y.company_id		= a.COMPANY_ID
										AND y.line_id			= a.LINE_ID
										AND y.month				= a.YYYYMM
										AND y.item_id			= a.ITEM_ID  
									-- pack/cell 수율 반영 end 

									WHERE a.division_id			= @v_division_id
									  AND a.plant_id			= @v_plant_id
									  AND a.ITEM_ID				= @v_item_id
									  AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									  AND a.YYYYMM				= @v_yyyymm
									  and a.LINE_ID				= @v_line_id
									  AND a.MEASURE				= 'PROD_PLAN'
									) A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								  AND X.PLANT_ID			= A.PLANT_ID
								  AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								  AND X.ITEM_ID				= A.child_item_id	-- 해당하는 전극을 찾아서
								  AND X.MEASURE				= 'INV'
								  AND X.YYYYMM				>= A.YYYYMM
								  ;

							END
							--ESS 팩 Prod Plan도 수정 가능하도록 2025-03-24 mrchois START
							ELSE IF(@v_seq_flag ='250')
							BEGIN

								--수정한 Prod Plan(팩)의 변경월이후 월의 재고 재계산
								UPDATE SCP_ANL_PSI_INTEGRATION
								SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 증가 : Prod Plan --> (+)
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								WHERE DIVISION_ID			= @v_division_id     
								AND PLANT_ID				= @v_plant_id
								AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
								AND CELL_ITEM_ID			= @v_cellitem_id 
								AND ITEM_ID					= @v_item_id 
								AND MEASURE					= 'INV' 
								AND YYYYMM					>= @v_yyyymm 
								;

							END
							--ESS 팩 Prod Plan도 수정 가능하도록 2025-03-24 mrchois END
							--링크/렉			: 해당하는 Pack을 찾아서  가감
							ELSE IF(@v_seq_flag ='150')	
							BEGIN

								--2. 수정한 링크/렉의 Pack을 찾아서 가감 : (pack 수율반영)
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID
										, a.COMPANY_ID
										, a.PLANT_ID
										, a.PLAN_START_YYYYMMDD
										, a.YYYYMM
										, a.CELL_ITEM_ID
										, b.child_item_id
										, isnull(@v_modiQty * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1),0) as REAL_MODI_QTY	-- pack, cell 수율반영
									FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
									INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK) 
										ON  b.division_id = a.DIVISION_ID
										AND b.plant_id = a.plant_id
										AND b.model_id = a.item_id
										AND b.model_id <> b.child_item_id
										AND b.OPERATION_GROUP_ID = 'P'  
										AND a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
									-- pack/cell 수율 반영 start 
									LEFT JOIN scp_mst_tact_time_osp y WITH (NOLOCK)
										ON  y.division_id = @v_division_id
										AND y.valid_yn    = 'Y'   
										AND	y.plant_site_id = a.plant_id  
										AND y.item_id = a.item_id    
										AND y.LINE_ID = a.line_id
									-- pack/cell 수율 반영 end 

									WHERE a.division_id			= @v_division_id
									  AND a.plant_id			= @v_plant_id
									  AND a.CELL_ITEM_ID		= @v_cellitem_id
									  AND a.ITEM_ID				= @v_item_id
									  AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									  AND a.YYYYMM				= @v_yyyymm
									  AND a.MEASURE				= 'PROD_PLAN'
									) A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								  AND X.COMPANY_ID			= A.COMPANY_ID
								  AND X.PLANT_ID			= A.PLANT_ID
								  AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								  AND X.CELL_ITEM_ID		= A.CELL_ITEM_ID
								  AND X.ITEM_ID				= A.child_item_id	-- 해당하는 Pack을 찾아서
								  AND X.YYYYMM				= A.YYYYMM
								  AND X.MEASURE				= 'IN_HOUSE_MOVING'
								  ;

								--3. 변경월이후 월의 재고 재계산 
								--3-1. 수정한 링크/렉의 변경월이후 월의 재고 재계산
								UPDATE SCP_ANL_PSI_INTEGRATION
									SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 변경수량만큼 재고 증가 : Prod Plan --> (+)
										,LAST_UPDATED_BY		= @v_last_updated_by 
										,LAST_UPDATE_DATE		= SYSDATETIME()
									WHERE DIVISION_ID			= @v_division_id     
									AND PLANT_ID				= @v_plant_id
									AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
									AND CELL_ITEM_ID			= @v_cellitem_id 
									AND ITEM_ID					= @v_item_id 
									AND VALUE_TYPE				= @v_valuation_type
									AND MEASURE					= 'INV' 
									AND YYYYMM					>= @v_yyyymm 
								;


								--3-2. 수정한 링크/렉의 Pack을 찾아서 변경월이후 월의 재고 재계산 : (pack 수율반영) 
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY - A.REAL_MODI_QTY, 0)   -- 원래값에 (pack 수율반영) 만큼 감소 : IN_HOUSE_MOVING --> (-)
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
								, (
									SELECT a.DIVISION_ID
										, a.COMPANY_ID
										, a.PLANT_ID
										, a.PLAN_START_YYYYMMDD
										, a.YYYYMM
										, a.CELL_ITEM_ID
										, b.child_item_id
										, isnull(@v_modiQty * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1),0) as REAL_MODI_QTY	-- pack, cell 수율반영
									FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
									INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK) 
										ON  b.division_id = a.DIVISION_ID
										AND b.plant_id = a.plant_id
										AND b.model_id = a.item_id
										AND b.model_id <> b.child_item_id
										AND b.OPERATION_GROUP_ID = 'P'  
										AND a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
									-- pack/cell 수율 반영 start 
									LEFT JOIN scp_mst_tact_time_osp y WITH (NOLOCK)
										ON  y.division_id = @v_division_id
										AND y.valid_yn    = 'Y'   
										AND	y.plant_site_id = a.plant_id  
										AND y.item_id = a.item_id    
										AND y.LINE_ID = a.line_id
									-- pack/cell 수율 반영 end 

									WHERE a.division_id			= @v_division_id
									  AND a.plant_id			= @v_plant_id
									  AND a.CELL_ITEM_ID		= @v_cellitem_id
									  AND a.ITEM_ID				= @v_item_id
									  AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									  AND a.YYYYMM				= @v_yyyymm
									  AND a.MEASURE				= 'PROD_PLAN'
									) A
								WHERE X.DIVISION_ID			= A.DIVISION_ID
								  AND X.COMPANY_ID			= A.COMPANY_ID
								  AND X.PLANT_ID			= A.PLANT_ID
								  AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								  AND X.CELL_ITEM_ID		= A.CELL_ITEM_ID
								  AND X.ITEM_ID				= A.child_item_id	-- 해당하는 Pack을 찾아서
								  AND X.MEASURE				= 'INV'
								  AND X.YYYYMM				>= A.YYYYMM
								  ;

							END

						END
						--ESS 팩 Prod Plan도 수정 가능하도록 2025-03-24 mrchois START
						-- ESS 팩 수정시 페어가 되는 IN_HOUSE_MOVING 을 수정한 경우
						ELSE IF(@v_measure ='IN_HOUSE_MOVING')
						BEGIN
							
							-- 1.1 수정한 IN_HOUSE_MOVING의 VALUE_TYPE이 '-'인 변경월의 재계산 
							UPDATE SCP_ANL_PSI_INTEGRATION
							SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 증감
								,LAST_UPDATED_BY		= @v_last_updated_by 
								,LAST_UPDATE_DATE		= SYSDATETIME()
							WHERE DIVISION_ID			= @v_division_id     
							AND PLANT_ID				= @v_plant_id
							AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
							AND CELL_ITEM_ID			= @v_cellitem_id 
							AND ITEM_ID					= @v_item_id 
							AND TO_PRODUCT				= @v_to_product
							AND VALUE_TYPE				= '-'
							AND MEASURE					= 'IN_HOUSE_MOVING' 
							AND YYYYMM					= @v_yyyymm 
							;

							-- 1.2 수정한 IN_HOUSE_MOVING의 변경월이후 월의 재고(해당 Value Type, '-') 재계산
							UPDATE SCP_ANL_PSI_INTEGRATION
							SET QTY						= ROUND(QTY - @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 감소
								,LAST_UPDATED_BY		= @v_last_updated_by 
								,LAST_UPDATE_DATE		= SYSDATETIME()
							WHERE DIVISION_ID			= @v_division_id     
							AND PLANT_ID				= @v_plant_id
							AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
							AND CELL_ITEM_ID			= @v_cellitem_id 
							AND ITEM_ID					= @v_item_id 
							AND (VALUE_TYPE	= @v_valuation_type OR VALUE_TYPE = '-')
							AND MEASURE					= 'INV' 
							AND YYYYMM					>= @v_yyyymm 
							;

						END
						--ESS 팩 Prod Plan도 수정 가능하도록 2025-03-24 mrchois END

					END
					-- 소형인 경우 20241025 START
					ELSE IF(@v_division_id = '40')
					BEGIN
						
						--1. 실제 수정한 값 수정
						UPDATE SCP_ANL_PSI_INTEGRATION
						   SET QTY					= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 가감
							  ,LAST_UPDATED_BY		= @v_last_updated_by 
							  ,LAST_UPDATE_DATE		= SYSDATETIME()
						 WHERE DIVISION_ID			= @v_division_id     
						   AND PLANT_ID				= @v_plant_id
						   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
						   AND CELL_ITEM_ID			= @v_cellitem_id 
						   AND ITEM_ID				= @v_item_id 
						   AND MEASURE				= @v_measure 
						   AND LINE_ID				= @v_line_id
						   AND VALUE_TYPE			= @v_valuation_type
						   AND TO_PRODUCT			= @v_to_product
						   AND TO_SITE				= @v_to_site
						   AND INCOTERMS			= @v_incoterms	
						   AND YYYYMM				= @v_yyyymm 
						;

						-- SHIP_PLAN_SEMI 수정인 경우			
						IF(@v_measure ='SHIP_PLAN_SEMI') 
						BEGIN
						
							--2. 수정한 Ship plan(SEMI)에 해당하는 Semi WH In 항목을 찾아서 변경
							UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 가감
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_to_site						-- TO_SITE = Plant_ID 항목 대상 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= 'SEMI_WH_IN'
								   AND YYYYMM				= @v_yyyymm 
							;


							--3. 변경월이후 월의 재고 재계산 
							--3-1. 수정한 Ship plan(SEMI)의 변경월이후 월의 재고 재계산
							UPDATE SCP_ANL_PSI_INTEGRATION
								SET QTY						= ROUND(QTY - @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 재고 감소 : Ship plan(SEMI) --> (-)
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								WHERE DIVISION_ID			= @v_division_id     
								AND PLANT_ID				= @v_plant_id
								AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
								AND CELL_ITEM_ID			= @v_cellitem_id 
								AND ITEM_ID					= @v_item_id 
								AND MEASURE					= 'INV' 
								AND YYYYMM					>= @v_yyyymm 
							;

							--3-2. 수정한 Ship plan(SEMI)에 해당하는 Semi WH In의 변경월이후 월의 재고 재계산
							UPDATE SCP_ANL_PSI_INTEGRATION
								SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 재고 증가 : Semi WH In --> (+)
									,LAST_UPDATED_BY		= @v_last_updated_by 
									,LAST_UPDATE_DATE		= SYSDATETIME()
								WHERE DIVISION_ID			= @v_division_id     
								AND PLANT_ID				= @v_to_site			-- TO_SITE = Plant_ID 항목 대상 
								AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
								AND ITEM_ID					= @v_item_id 
								AND MEASURE					= 'INV'
								AND YYYYMM					>= @v_yyyymm 
							;

						END
						--PROD_PLAN 수정인 경우
						ELSE IF(@v_measure ='PROD_PLAN')
						BEGIN
						
							--Prod Plan(전극) : 수정한 Prod Plan만 저장(완성)
							IF(@v_seq_flag ='550')
							BEGIN

								--2. 변경월이후 월의 재고 재계산 
								UPDATE SCP_ANL_PSI_INTEGRATION
									SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 증가 : Prod Plan --> (+)
										,LAST_UPDATED_BY		= @v_last_updated_by 
										,LAST_UPDATE_DATE		= SYSDATETIME()
									WHERE DIVISION_ID			= @v_division_id     
									AND PLANT_ID				= @v_plant_id
									AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
									AND ITEM_ID					= @v_item_id 
									AND MEASURE					= 'INV' 
									AND YYYYMM					>= @v_yyyymm 
								;

							END
							--Prod Plan(셀 반제품)		: 해당하는 전극을 찾아서 가감(완성)
							ELSE IF(@v_seq_flag ='450')
							BEGIN
								
								IF OBJECT_ID('tempdb..#tmp_YIELD_VER_H_V_A') IS NOT NULL                        
									DROP TABLE #tmp_YIELD_VER_H_V_A

								--전극 수율 반영용 임시테이블 저장
								select y.operation_group,  a.version_id, a.division_id, a.company_id, a.site_id, a.plant_id, a.factory_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.month, a.yield
								into #tmp_YIELD_VER_H_V_A
								from SCM_MST_YIELD_VER_H_V a with(nolock)
								inner join (    SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
												from scm_adm_lookup_master_detail b WITH(NOLOCK)
												where b.lookup_type = 'LOCATION_GROUP_ROUTE'
												and b.valid_yn = 'Y'
												and b.segment3 = 'Y'
												and b.segment5 = 'A' ) y
									on a.operation_id = y.operation_id
								where 1=1
								and a.division_id = @V_DIVISION_ID 

								create index i_tmp_YIELD_VER_H_V_A_small_01 on #tmp_YIELD_VER_H_V_A(item_id)


								IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_530') IS NOT NULL                        
									DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_530

								/********************************************************
								--1.전극 IN_HOUSE_MOVING 구하기
								********************************************************/
								--1.1 임시테이블에 전극item 저장
								SELECT a.DIVISION_ID
									, a.OPERATION_GROUP
									, a.PLANT_ID
									, a.PLAN_START_YYYYMMDD
									, a.YYYYMM
									, a.MEASURE
									, a.ITEM_ID
									, b.child_item_id
									, b.USAGE
									, y.yield
									, isnull(@v_modiQty * isnull(b.USAGE,1) / isnull(y.yield,1),0) as REAL_MODI_QTY	-- 변경수량 X Cell당 전극 소요량 ÷ 수율
								INTO #tmp_SCP_ANL_PSI_INTEGRATION_530
								FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
								INNER JOIN SCP_MST_BOM_ELEC b WITH(NOLOCK)
									ON b.DIVISION_ID = a.DIVISION_ID 
									AND b.PARENT_ITEM_ID = a.ITEM_ID
									AND b.SCP_YN = 'Y'
								LEFT JOIN #tmp_YIELD_VER_H_V_A y -- 전극 수율
									on y.division_id = a.DIVISION_ID
									AND y.operation_group =a.OPERATION_GROUP
									AND y.company_id = a.COMPANY_ID
									AND y.line_id = a.LINE_ID
									AND y.month = a.YYYYMM
									AND y.item_id =a.ITEM_ID  
								WHERE a.division_id = @v_division_id  
									AND a.plant_id = @v_plant_id
									AND a.ITEM_ID = @v_item_id
									AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									AND a.YYYYMM = @v_yyyymm
									AND a.MEASURE = 'PROD_PLAN'
									AND a.LINE_ID = @v_line_id

								--1.2 전극 IN_HOUSE_MOVING 의 QTY 갱신
								UPDATE X
								   SET X.QTY					= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
									 , X.LAST_UPDATED_BY		= @v_last_updated_by 
									 , X.LAST_UPDATE_DATE		= SYSDATETIME()
								  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
									 , #tmp_SCP_ANL_PSI_INTEGRATION_530 A
								 WHERE X.DIVISION_ID			= A.DIVISION_ID
								   --AND X.PLANT_ID				= substring(A.PLANT_ID,1, len(A.PLANT_ID)-1) + convert(nvarchar(1),convert(int, right(A.PLANT_ID,1)) + 1)
								   AND X.PLANT_ID				= (SELECT plant_id_es FROM #cell_elec_plant_mapping WHERE division_id_cs = X.DIVISION_ID AND company_id_cs = X.COMPANY_ID AND plant_id_cs = @v_plant_id and cell_plant_priority = 1  ) -- NERP 전환 plant 찾는 로직 추가 (2025-02-18 mrchois)
								   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								   AND X.ITEM_ID				= A.child_item_id
								   AND X.YYYYMM					= A.YYYYMM
								   AND X.MEASURE				= 'IN_HOUSE_MOVING'

								--1.3 전극 재고 갱신
								UPDATE X
								   SET X.QTY					= ROUND(X.QTY - A.REAL_MODI_QTY, 0)   
									 , X.LAST_UPDATED_BY		= @v_last_updated_by 
									 , X.LAST_UPDATE_DATE		= SYSDATETIME()
								  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
									 , #tmp_SCP_ANL_PSI_INTEGRATION_530 A
								 WHERE X.DIVISION_ID			= A.DIVISION_ID
								   --AND X.PLANT_ID				= substring(A.PLANT_ID,1, len(A.PLANT_ID)-1) + convert(nvarchar(1),convert(int, right(A.PLANT_ID,1)) + 1)
								   AND X.PLANT_ID				= (SELECT plant_id_es FROM #cell_elec_plant_mapping WHERE division_id_cs = X.DIVISION_ID AND company_id_cs = X.COMPANY_ID AND plant_id_cs = @v_plant_id and cell_plant_priority = 1  ) -- NERP 전환 plant 찾는 로직 추가 (2025-02-18 mrchois)
								   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								   AND X.ITEM_ID				= A.child_item_id
								   AND X.YYYYMM					>= A.YYYYMM
								   AND X.MEASURE				= 'INV'


								/********************************************************
								--2.예외케이스 처리
								*********************************************************/
								SELECT @cnt = COUNT(*) 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
								WHERE LOOKUP_TYPE = 'TCO_NO_CA2_ITEM_PROD'
								AND VALID_YN = 'Y'
								AND SEGMENT3 = @v_item_id

								--2.1 예외케이스1이 존재할 경우 
								IF(@cnt > 0)
								BEGIN

									--셀제품의 Prod plan, INV만 수정한다 (2024/10/31)

									IF OBJECT_ID('tempdb..#tmp_tco_no_ca2_item_prod') IS NOT NULL                        
										DROP TABLE #tmp_tco_no_ca2_item_prod	

									SELECT SEGMENT1 AS TCO_ITEM_PROD, SEGMENT2 AS CELL_ITEM_PROD
									INTO #tmp_tco_no_ca2_item_prod
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
									WHERE LOOKUP_TYPE = 'TCO_NO_CA2_ITEM_PROD'
									AND VALID_YN = 'Y'
									AND SEGMENT3 = @v_item_id

									-- 셀 제품의 Prod plan(350)
									UPDATE X
									SET X.QTY					= ROUND(X.QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 가감
									  , X.LAST_UPDATED_BY		= @v_last_updated_by 
									  , X.LAST_UPDATE_DATE		= SYSDATETIME()
									FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK)
									   , #tmp_tco_no_ca2_item_prod tco 
									WHERE X.division_id			= @v_division_id  
									AND X.plant_id				= @v_plant_id
									AND X.ITEM_ID				= tco.CELL_ITEM_PROD
									AND X.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									AND X.YYYYMM				= @v_yyyymm
									AND X.MEASURE				= 'PROD_PLAN'

									---- 셀 제품의 INV 갱신
									UPDATE X
									SET X.QTY					= ROUND(X.QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 가감
									  , X.LAST_UPDATED_BY		= @v_last_updated_by 
									  , X.LAST_UPDATE_DATE		= SYSDATETIME()
									FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK)
									   , #tmp_tco_no_ca2_item_prod tco 
									WHERE X.division_id			= @v_division_id  
									AND X.plant_id				= @v_plant_id
									AND X.ITEM_ID				= tco.CELL_ITEM_PROD
									AND X.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									AND X.YYYYMM				>= @v_yyyymm
									AND X.MEASURE				= 'INV'

									--변경월이후 월의 재고 재계산, 수정한 Prod Plan(셀 반제품)의 변경수량만큼 재고 증가
									UPDATE SCP_ANL_PSI_INTEGRATION
									   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
										  ,LAST_UPDATED_BY		= @v_last_updated_by 
										  ,LAST_UPDATE_DATE		= SYSDATETIME()
									 WHERE DIVISION_ID			= @v_division_id     
									   AND PLANT_ID				= @v_plant_id 
									   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									   AND ITEM_ID				= @v_item_id 
									   AND YYYYMM				>= @v_yyyymm 
									   AND MEASURE				= 'INV' 
									;

									DROP TABLE #tmp_tco_no_ca2_item_prod;

									CONTINUE;
								END 

								--2.2 예외케이스2(초소형)인 경우
								IF(@v_item_id = 'MASS20253-A2')
								BEGIN
									
									--초소형은 자동차[81]처럼 전극의 IN_HOUSE_MOVING만 갱신 한다.(2024/10/31)

									--변경월이후 월의 재고 재계산, 수정한 Prod Plan(셀 반제품)의 변경수량만큼 재고 증가
									UPDATE SCP_ANL_PSI_INTEGRATION
									   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
										  ,LAST_UPDATED_BY		= @v_last_updated_by 
										  ,LAST_UPDATE_DATE		= SYSDATETIME()
									 WHERE DIVISION_ID			= @v_division_id     
									   AND PLANT_ID				= @v_plant_id 
									   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									   AND ITEM_ID				= @v_item_id 
									   AND YYYYMM				>= @v_yyyymm 
									   AND MEASURE				= 'INV' 
									;

									CONTINUE;
								END	
								
								/********************************************************
								--3. 셀 반제품 IN_HOUSE_MOVING 구하기
								********************************************************/
								--3.1 수정한 Prod Plan(셀 반제품)의 In-house Moving(셀 반제품)의 변경수량만큼 가감
								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY						= ROUND(QTY + @v_modiQty, 0)		-- 원래값에 변경된 수량만큼 가감
									 , LAST_UPDATED_BY			= @v_last_updated_by 
									 , LAST_UPDATE_DATE			= SYSDATETIME()
								 WHERE DIVISION_ID				= @v_division_id
								   AND PLANT_ID					= @v_plant_id
								   AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
								   AND ITEM_ID					= @v_item_id		
								   AND YYYYMM					= @v_yyyymm
								   AND MEASURE					= 'IN_HOUSE_MOVING'
								  ;

								/********************************************************
								--4. 셀제품 또는 셀 후공정 반제품 PROD_PLAN 구하기
								--(셀 후공정 반제품 or 셀 제품 중 1개만 존재함)
								********************************************************/

								IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_750_small') IS NOT NULL                        
									DROP TABLE #tmp_PSI_INTEGRATION_750_small

								--4.1 임시테이블에 셀 후공정반제품 item 저장
								SELECT fc2.ITEM_ID_ASSY
									, isnull(fm.FORMATION_TOTAL_YIELD, 1) AS YIELD
									, isnull(@v_modiQty * isnull(fm.FORMATION_TOTAL_YIELD, 1),0) as REAL_MODI_QTY	-- 변경수량 X 활성화 수율
									, a.*
								INTO #tmp_PSI_INTEGRATION_750_small
								FROM SCP_ANL_PSI_INTEGRATION a  
								INNER JOIN SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
									ON FC.DIVISION_ID = @v_division_id  
									AND FC.ITEM_ID_ASSY = A.ITEM_ID
									and fc.CELL_TYPE = 'CA1'
									AND FC.PLANT_ID = A.PLANT_ID
									and fc.VALID_YN = 'Y'
									AND FC.ITEM_ID_ASSY NOT IN (select DISTINCT SEGMENT1
																from SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
																where LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
																AND VALID_YN = 'Y')
								INNER JOIN SCP_MST_CELL_PROD_ASSY_MAP FC2 WITH (NOLOCK)
									ON FC2.DIVISION_ID = @v_division_id 
									AND FC2.ITEM_ID_PROD =FC.ITEM_ID_PROD
									AND FC2.CELL_TYPE= 'CA2'
									AND FC2.PLANT_ID = FC.PLANT_ID
									and fc2.VALID_YN = 'Y'
								INNER JOIN SCP_MST_FINAL_ITEM fi WITH (NOLOCK)  
									on fi.division_id = fc2.DIVISION_ID
									and fi.operation_group = 'A'
									and fi.item_id = FC2.ITEM_ID_ASSY   
									AND fi.ATTRIBUTE8 = 'CA2'
									and isnull(fi.TCO_CELL_YN,'N') = 'Y'
								LEFT JOIN SCP_MST_FORMATION_V fm WITH (NOLOCK)
									on fm.division_id = a.DIVISION_ID
									and fm.PLANT_SITE_ID Like '%'+ A.PLANT_ID + '%'
									and fm.item_id = A.ITEM_ID
								WHERE a.division_id = @v_division_id  
									AND a.plant_id = @v_plant_id
									AND a.ITEM_ID = @v_item_id
									AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									AND a.YYYYMM = @v_yyyymm
									AND a.MEASURE = 'PROD_PLAN'
									AND a.LINE_ID = @v_line_id

	
								SET @cnt = 0;
								SELECT @cnt = COUNT(ITEM_ID) FROM #tmp_PSI_INTEGRATION_750_small

								--셀 후공정반제품이 존재하는 경우 
								IF (@cnt > 0)
								BEGIN

									--4.2 셀 후공정반제품의 PROD_PLAN 의 QTY 갱신
									UPDATE X
									   SET X.QTY					= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
										 , X.LAST_UPDATED_BY		= @v_last_updated_by 
										 , X.LAST_UPDATE_DATE		= SYSDATETIME()
									  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
										, #tmp_PSI_INTEGRATION_750_small A
									 WHERE X.DIVISION_ID			= A.DIVISION_ID
									   AND X.PLANT_ID				= A.PLANT_ID
									   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
									   AND X.ITEM_ID				= A.ITEM_ID_ASSY
									   AND X.YYYYMM					= A.YYYYMM
									   AND X.MEASURE				= 'PROD_PLAN'
									;

									--4.3 셀 후공정반제품의 재고 QTY 갱신
									UPDATE X
									   SET X.QTY					= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
										 , X.LAST_UPDATED_BY		= @v_last_updated_by 
										 , X.LAST_UPDATE_DATE		= SYSDATETIME()
									  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
										 , #tmp_PSI_INTEGRATION_750_small A
									 WHERE X.DIVISION_ID				= A.DIVISION_ID
									   AND X.PLANT_ID				= A.PLANT_ID
									   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
									   AND X.ITEM_ID				= A.ITEM_ID_ASSY
									   AND X.YYYYMM					>= A.YYYYMM
									   AND X.MEASURE				= 'INV'
									;

									drop table #tmp_PSI_INTEGRATION_750_small;

								END
								ELSE	--셀 제품이 존재하는 경우
								BEGIN

									IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_350_small') IS NOT NULL                        
										DROP TABLE #tmp_PSI_INTEGRATION_350_small

									--4.2 셀 제품 PROD_PLAN 구하기
									SELECT FC.ITEM_ID_prod AS ITEM_ID_350
										, isnull(fm.FORMATION_TOTAL_YIELD, 1) AS YIELD
										, isnull(@v_modiQty * isnull(fm.FORMATION_TOTAL_YIELD, 1),0) as REAL_MODI_QTY	-- 변경수량 X 활성화 수율
										, a.*
									INTO #tmp_PSI_INTEGRATION_350_small
									from SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
									INNER JOIN SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
										ON FC.DIVISION_ID = @v_division_id
										AND FC.ITEM_ID_ASSY = A.ITEM_ID
										AND fc.CELL_TYPE = 'CA1'
										AND FC.PLANT_ID = A.PLANT_ID
										AND fc.VALID_YN = 'Y'
									INNER JOIN SCP_MST_FINAL_ITEM fi WITH (NOLOCK)
										on fi.division_id = a.DIVISION_ID
										AND fi.operation_group = 'A'
										AND fi.item_id = fc.ITEM_ID_PROD
										AND LEFT(fi.ATTRIBUTE8,2) = 'CP'
										AND isnull(fi.TCO_CELL_YN,'N') <> 'Y'
									LEFT JOIN SCP_MST_FORMATION_V fm WITH (NOLOCK)
										on fm.division_id = a.DIVISION_ID
										AND fm.PLANT_SITE_ID Like '%'+ A.PLANT_ID + '%'
										AND fm.item_id = A.ITEM_ID
									WHERE a.division_id = @v_division_id  
										AND a.plant_id = @v_plant_id
										AND a.ITEM_ID = @v_item_id
										AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
										AND a.YYYYMM = @v_yyyymm
										AND a.MEASURE = 'PROD_PLAN'
										AND a.LINE_ID = @v_line_id

									--4.3 셀 제품의 PROD_PLAN 의 QTY 갱신
									UPDATE X 
									   SET X.QTY = ROUND(X.QTY + A.REAL_MODI_QTY, 0) 
									  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK)
									     , #tmp_PSI_INTEGRATION_350_small A
									WHERE X.DIVISION_ID				= A.DIVISION_ID
										AND X.PLANT_ID				= A.PLANT_ID
										AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
										AND X.ITEM_ID				= A.ITEM_ID_350
										AND X.YYYYMM				= A.YYYYMM
										AND X.MEASURE				= 'PROD_PLAN'

									--4.4 셀 제품의 재고 갱신
									UPDATE X
									   SET X.QTY					= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
										 , X.LAST_UPDATED_BY		= @v_last_updated_by 
										 , X.LAST_UPDATE_DATE		= SYSDATETIME()
									  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
										 , #tmp_PSI_INTEGRATION_350_small A
									 WHERE X.DIVISION_ID			= A.DIVISION_ID
									   AND X.PLANT_ID				= A.PLANT_ID
									   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
									   AND X.ITEM_ID				= A.ITEM_ID_350
									   AND X.YYYYMM					>= A.YYYYMM
									   AND X.MEASURE				= 'INV'
									   ;

									drop table #tmp_PSI_INTEGRATION_350_small;

								END

							END
							--Prod Plan(모듈 반제품)		: 해당하는 셀 제품을 찾아서  가감(완성)
							ELSE IF(@v_seq_flag ='250')
							BEGIN

								IF OBJECT_ID('tempdb..#tem_SCP_ANL_PSI_INTEGRATION_350') IS NOT NULL                        
									DROP TABLE #tem_SCP_ANL_PSI_INTEGRATION_350

								SELECT a.DIVISION_ID
									, a.OPERATION_GROUP
									, a.PLANT_ID
									, a.PLAN_START_YYYYMMDD
									, a.YYYYMM
									, a.MEASURE
									, a.ITEM_ID
									, b.child_item_id
									, b.accumulated_child_qty
									, isnull(yh.yield,1) AS yield
									, isnull(@v_modiQty * isnull(b.accumulated_child_qty,1) / isnull(yh.yield,1), 0) as REAL_MODI_QTY	-- 변경수량 X Cell 소요량 / 수율
								INTO #tem_SCP_ANL_PSI_INTEGRATION_350
								FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
								left join scm_mst_site x WITH(NOLOCK)
									on  x.DIVISION_ID = a.DIVISION_ID
									and x.plant_id = a.PLANT_ID
									and x.OPERATION_GROUP = 'P'
								inner join SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
									on  b.division_id = a.DIVISION_ID
									and b.plant_id = (case when x.osp_yn = 'Y' then x.logistic_plant_id
															else a.plant_id
															end )
									and b.model_id = a.item_id
									and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date 
								inner join scp_mst_final_item c WITH(NOLOCK)
									on c.item_id = b.child_item_id
									and c.DIVISION_ID = a.DIVISION_ID
									and c.OPERATION_GROUP_ID = 'A'  
									and c.attribute8 = 'CP'
									and isnull(c.TCO_CELL_YN,'N') <> 'Y'			
								inner join  SCM_MST_YIELD_VER_H_V yh WITH(NOLOCK)
									on yh.division_id = a.DIVISION_ID  
									and yh.company_id = a.company_id  
									and yh.PLANT_id = a.PLANT_id  
									and yh.ITEM_ID = a.ITEM_ID  
									and yh.line_id = a.line_id  
									and yh.month = a.YYYYMM  
								WHERE a.DIVISION_ID				= @v_division_id
									AND a.PLANT_ID				= @v_plant_id
									AND a.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
									AND a.ITEM_ID				= @v_item_id
									AND a.YYYYMM				= @v_yyyymm
									AND a.MEASURE				= 'PROD_PLAN'
									AND a.LINE_ID				= @v_line_id


								--2. 해당하는 모듈 반제품의 셀 제품을 찾아서 변경수량 X 팩당 Cell 소요량 ÷ 수율 을 +- 해줌
								UPDATE  X
								   SET X.QTY				= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
									, #tem_SCP_ANL_PSI_INTEGRATION_350 A
								WHERE X.DIVISION_ID				= A.DIVISION_ID
									AND X.PLANT_ID				= A.PLANT_ID
									AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
									AND X.ITEM_ID				= A.child_item_id
									AND X.YYYYMM				= A.YYYYMM
									AND X.TO_PRODUCT			= @v_item_id
									AND X.TO_SITE				= @v_plant_id
									AND X.MEASURE				= 'IN_HOUSE_MOVING'

								--3. 변경월이후 월의 재고 재계산 
								--3-1. 수정한 Prod Plan(모듈 반제품)의 변경수량만큼 재고 증가
								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= 'INV' 
								   AND YYYYMM				>= @v_yyyymm 
								;

								--3.2. 해당하는 모듈 반제품의 셀 제품을 찾아서 변경월이후 월의 재고 재계산 : (변경수량 X 팩당 Cell 소요량 ÷ 수율) 
								UPDATE  X
								   SET X.QTY					= ROUND(X.QTY - A.REAL_MODI_QTY, 0)   -- 원래값에 (변경수량 X 팩당 Cell 소요량 ÷ 수율) 만큼 감소 : IN_HOUSE_MOVING --> (-)
									 , X.LAST_UPDATED_BY		= @v_last_updated_by 
									 , X.LAST_UPDATE_DATE		= SYSDATETIME()
								  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
									 , #tem_SCP_ANL_PSI_INTEGRATION_350 A
								 WHERE X.DIVISION_ID			= A.DIVISION_ID
								   AND X.PLANT_ID				= A.PLANT_ID
								   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
								   AND X.ITEM_ID				= A.child_item_id
								   AND X.MEASURE				= 'INV'
								   AND X.YYYYMM				>= A.YYYYMM
								;


								drop table #tem_SCP_ANL_PSI_INTEGRATION_350;

							END
							--Prod Plan(팩(외주))		: 해당하는 모듈 반제품 또는 셀제품을 찾아서  가감
							ELSE IF(@v_seq_flag ='150')
							BEGIN

								--팩 수정 시 
								-- 1)모듈 반제품이 있는 모델은 모듈 반제품 in-house moving가 수정됨
								-- 2)모듈 반제품이 없는 모델은 셀 제품 in-house moving이 수정됨


								IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_230_ITEM_small') IS NOT NULL                        
									DROP TABLE #tmp_PSI_INTEGRATION_230_ITEM_small

								CREATE TABLE #tmp_PSI_INTEGRATION_230_ITEM_small(                        
									ITEM_ID                 NVARCHAR(40)    NULL
								); 

								INSERT INTO #tmp_PSI_INTEGRATION_230_ITEM_small
								SELECT DISTINCT a.ITEM_ID
								FROM SCP_ANL_PSI_INTEGRATION a
								LEFT JOIN scm_mst_site x WITH(NOLOCK)
									on  x.DIVISION_ID = a.DIVISION_ID
									and x.plant_id = a.PLANT_ID
									and x.OPERATION_GROUP = 'P'
								INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
									ON  b.division_id = a.DIVISION_ID
									AND b.plant_id = (case when x.osp_yn = 'Y' then x.logistic_plant_id
															else a.plant_id
															end )
									AND b.model_id = a.item_id
									AND a.PLAN_START_YYYYMMDD BETWEEN b.eff_start_date AND b.eff_end_date  
								INNER JOIN scp_mst_final_item c WITH(NOLOCK)
									ON c.item_id = B.child_item_id
									AND c.DIVISION_ID = a.DIVISION_ID
									AND c.FLOW_ID = 'P5000'		
								WHERE a.ITEM_ID = @v_item_id


								SET @cnt = 0;
								SELECT @cnt = COUNT(ITEM_ID) FROM #tmp_PSI_INTEGRATION_230_ITEM_small;

								-- 1)모듈 반제품이 있는 모델
								IF(@cnt > 0)
								BEGIN

									IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_small_230') IS NOT NULL                        
										DROP TABLE #tmp_PSI_INTEGRATION_small_230

									--모듈 반제품 임시테이블에 등록
									SELECT a.DIVISION_ID
										, a.PLANT_ID
										, a.PLAN_START_YYYYMMDD
										, a.YYYYMM
										, b.child_item_id
										, @v_modiQty * isnull(b.accumulated_child_qty,1) AS REAL_MODI_QTY
									INTO #tmp_PSI_INTEGRATION_small_230
									FROM SCP_ANL_PSI_INTEGRATION a
									LEFT JOIN scm_mst_site x WITH(NOLOCK)
										on  x.DIVISION_ID = a.DIVISION_ID
										and x.plant_id = a.PLANT_ID
										and x.OPERATION_GROUP = 'P'
									INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
										ON  b.division_id = a.DIVISION_ID
										AND b.plant_id = (case when x.osp_yn = 'Y' then x.logistic_plant_id
																else a.plant_id
																end )
										AND b.model_id = a.item_id
										AND a.PLAN_START_YYYYMMDD BETWEEN b.eff_start_date AND b.eff_end_date  
									INNER JOIN scp_mst_final_item c WITH(NOLOCK)
										on c.item_id = B.child_item_id
										AND c.DIVISION_ID = a.DIVISION_ID
										AND c.OPERATION_GROUP = 'P' -- OPERATION_GROUP_ID에는 'P' 가 아닌 'B' 가 들어 있어서 OPERATION_GROUP 필드를 사용함.
										AND c.flow_id = 'P5000'
									WHERE a.DIVISION_ID				= @v_division_id
										AND a.PLANT_ID				= @v_plant_id
										AND a.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
										AND a.ITEM_ID				= @v_item_id
										AND a.YYYYMM				= @v_yyyymm
										AND a.MEASURE				= 'PROD_PLAN'


									--수정한 Prod Plan(팩(외주))의  In-house Moving(모듈 반제품)의 변경수량만큼 가감
									UPDATE X
									   SET X.QTY					= ROUND(X.QTY + A.REAL_MODI_QTY, 0)
										  ,X.LAST_UPDATED_BY		= @v_last_updated_by 
										  ,X.LAST_UPDATE_DATE		= SYSDATETIME()
									  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
										, #tmp_PSI_INTEGRATION_small_230 A
										WHERE X.DIVISION_ID				= A.DIVISION_ID
											AND X.PLANT_ID				= A.PLANT_ID
											AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
											AND X.ITEM_ID				= A.child_item_id
											AND X.YYYYMM				= A.YYYYMM
											AND X.MEASURE				= 'IN_HOUSE_MOVING'
											AND X.TO_PRODUCT			= @v_item_id
									;

									--수정한 Prod Plan(팩(외주))의 INV(모듈 반제품)을 찾아서 변경월이후 월의 재고 재계산
									UPDATE X
									   SET X.QTY					= ROUND(X.QTY - A.REAL_MODI_QTY, 0)
										  ,X.LAST_UPDATED_BY		= @v_last_updated_by 
										  ,X.LAST_UPDATE_DATE		= SYSDATETIME()
									  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
										, #tmp_PSI_INTEGRATION_small_230 A
									 WHERE X.DIVISION_ID				= A.DIVISION_ID
									   AND X.PLANT_ID				= A.PLANT_ID
									   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
									   AND X.ITEM_ID				= A.child_item_id
									   AND X.YYYYMM					>= A.YYYYMM
									   AND X.MEASURE				= 'INV'
									;

									DROP TABLE #tmp_PSI_INTEGRATION_small_230;

								END
								-- 2)모듈 반제품이 없는 모델
								ELSE
								BEGIN

									IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_small_330') IS NOT NULL                        
										DROP TABLE #tmp_PSI_INTEGRATION_small_330

									-- 셀 제품 임시테이블에 등록
									SELECT a.DIVISION_ID
										, a.OPERATION_GROUP
										, a.PLANT_ID
										, a.PLAN_START_YYYYMMDD
										, a.YYYYMM
										, a.MEASURE
										, a.ITEM_ID
										, b.child_item_id
										--, a.QTY
										, isnull(@v_modiQty * isnull(b.accumulated_child_qty,1), 0) as REAL_MODI_QTY	-- 변경수량 X Cell 소요량
									INTO #tmp_PSI_INTEGRATION_small_330
									FROM SCP_ANL_PSI_INTEGRATION a
									left join scm_mst_site x WITH(NOLOCK)
										on  x.DIVISION_ID = a.DIVISION_ID
										and x.plant_id = a.PLANT_ID
										and x.OPERATION_GROUP = 'P'
									INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
										ON  b.division_id = a.DIVISION_ID
										AND b.plant_id = (case when x.osp_yn = 'Y' then x.logistic_plant_id
																	else a.plant_id
																	end )
										AND b.model_id = a.item_id
										AND a.PLAN_START_YYYYMMDD BETWEEN b.eff_start_date AND b.eff_end_date  
									INNER JOIN scp_mst_final_item c WITH(NOLOCK)
										on c.item_id = B.child_item_id
										AND c.DIVISION_ID = a.DIVISION_ID
										AND c.OPERATION_GROUP_ID = 'A'  
										AND c.attribute8 = 'CP'
										AND isnull(c.TCO_CELL_YN,'N') <> 'Y'
									WHERE a.DIVISION_ID				= @v_division_id
										AND a.PLANT_ID				= @v_plant_id
										AND a.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
										AND a.ITEM_ID				= @v_item_id
										AND a.YYYYMM				= @v_yyyymm
										AND a.MEASURE				= 'PROD_PLAN'


									--해당하는 팩(외주) 제품의 셀 제품을 찾아서 변경수량 X Cell 소요량 을 +- 해줌
									UPDATE  X
									   SET X.QTY				= ROUND(X.QTY + A.REAL_MODI_QTY, 0)   
										  ,LAST_UPDATED_BY		= @v_last_updated_by 
										  ,LAST_UPDATE_DATE		= SYSDATETIME()
									  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
										, #tmp_PSI_INTEGRATION_small_330 A
										WHERE X.DIVISION_ID				= A.DIVISION_ID
											AND X.PLANT_ID				= A.PLANT_ID
											AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
											AND X.ITEM_ID				= A.child_item_id
											AND X.YYYYMM				= A.YYYYMM
											AND X.MEASURE				= 'IN_HOUSE_MOVING'
											AND X.TO_PRODUCT			= @v_item_id
									;

									--해당하는 팩(외주) 제품의 셀 제품을 찾아서 변경월이후 월의 재고 재계산 : (변경수량 X 팩당 Cell 소요량) 
									UPDATE  X
									   SET X.QTY				= ROUND(X.QTY - A.REAL_MODI_QTY, 0)   -- 원래값에 (변경수량 X 팩당 Cell 소요량) 만큼 감소 : IN_HOUSE_MOVING --> (-)
										  ,LAST_UPDATED_BY		= @v_last_updated_by 
										  ,LAST_UPDATE_DATE		= SYSDATETIME()
									  FROM SCP_ANL_PSI_INTEGRATION X WITH(NOLOCK) 
										, #tmp_PSI_INTEGRATION_small_330 A
									 WHERE X.DIVISION_ID			= A.DIVISION_ID
									   AND X.PLANT_ID				= A.PLANT_ID
									   AND X.PLAN_START_YYYYMMDD	= A.PLAN_START_YYYYMMDD
									   AND X.ITEM_ID				= A.child_item_id
									   AND X.YYYYMM					>= A.YYYYMM
									   AND X.MEASURE				= 'INV'
										;

									DROP TABLE #tmp_PSI_INTEGRATION_small_330;

								END

								--변경월이후 월의 재고 재계산, 수정한 Prod Plan(팩(외주))의 변경수량만큼 재고 증가
								UPDATE SCP_ANL_PSI_INTEGRATION
								   SET QTY					= ROUND(QTY + @v_modiQty, 0)     
									  ,LAST_UPDATED_BY		= @v_last_updated_by 
									  ,LAST_UPDATE_DATE		= SYSDATETIME()
								 WHERE DIVISION_ID			= @v_division_id     
								   AND PLANT_ID				= @v_plant_id 
								   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
								   AND ITEM_ID				= @v_item_id 
								   AND MEASURE				= 'INV' 
								   AND YYYYMM				>= @v_yyyymm 
								;

							END;	--4. Prod Plan(팩(외주) 제품)
						
						END;	--PROD_PLAN 수정인 경우

					END -- @v_division_id = '40'
					-- 소형인 경우 20241025 END

				END;-- END OF STMT. IF(@mst_loop_cnt > 0)

			END;-- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			COMMIT TRAN;

			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

		END TRY

		BEGIN CATCH
			IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
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

				--IF @@TRANCOUNT > 0
				--	COMMIT WORK;
			END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
END
