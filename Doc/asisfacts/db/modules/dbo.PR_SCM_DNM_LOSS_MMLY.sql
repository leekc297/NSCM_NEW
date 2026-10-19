



/*  
 * Program ID   : PR_SCM_DNM_LOSS_MMLY
 * Description  : 라인별월별손실 실적 정보를 적재한다.
 *
 *				 - Source : XIF_DW_RECEIVE_LOSS_TIME_R_SN	(DW LOSS실적) 		
 *							SCM_DNM_INPT_PRDN_DDLY			(DW 투입/생산 실적)
 *							SCP_MST_MDL_EQP_SPED			(MMD기준 설비속도)
 *							SCM_MST_EQUIPMENT_SN			(설비Master)
 *							SCP_MST_ITEM_BSI_IFO			(Basic Model NickName 참조) 
 *							SCP_MST_ITEM_CELL_CF			(Cell 환산계수 참조)
 *							SCM_ADM_LOOKUP_MASTER_DETAIL
 *							SCM_MST_FACTORY_SN
 *							SCM_MST_DIVISION
 *							SCP_MST_MMD_KPI_EXCT			(MMD 지표 예외 정보) 
 *
 *				 - Target : SCM_DNM_LOSS_EQP_MMLY (설비별)
 *				            SCM_DNM_LOSS_LN_MMLY  (라인별)
 *				            SCM_DNM_LOSS_MDL_MMLY (모델별)
 *
 *				 - 조립 Cell 모델에 대한 실적만 대상으로 함 (pack과 전극은 대상 아님- 팩은 실적이 없음?)
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.02.27	hrkim		Initial Release PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  
 * 2024.04.05	hrkim		투입실적 참조 테이블 변경 XIF_DW_PRD_INPUT_DAILY_YLD_R_SN -> SCM_DNM_INPT_PRDN_DDLY
 * 2024.04.09	hrkim		조업율이 0%인경우(비조업100%) 부하/가동 100%로 맞춤.
 *							변상현 책임 : 비부하/비가동이 실적에서 Loss 시간의 % 를 1-XX% 로 부하율/시간가동율로 만드는 로직이니 일단 100% 로 맞춰주세요~!
 * 2024.04.19	hrkim		라인별 양품가동률 추가 
 * 2024.04.24	hrkim		DW Loss Time 실적 IF 수신 데이터 중복데이터 필터링
 * 2024.04.29	hrkim		생산가동률/TEEP 추가
 * 2024.04.29	hrkim		전극라인유형코드값 로직 수정 (FP설비 Master Product_Leve3_Code참조) 
 * 2024.05.13	hrkim		전극라인유형코드 매핑시 lookup  추가 참조 (OPERATION_ELECTRODE_TYPE)  
 * 2024.05.14	hrkim		기간참조구분에 따른 참조 범위 변경적용
 *							1 : loss_ym  해당월 1개월 참조
 *							3 : loss_ym 기준 M-2부터 M(loss_ym) 까지 참조
 * 2024.05.27	hrkim		소수 자릿수 처리 로직 보완 (연산:FLOAT, 저장:NUMERIC(20,10))
 * 2024.06.05	hrkim		성능가동률 계산시 적용되는 MMD설계속도 모델별데이터 라인별 집계시 투입수량 가중치 적용
 * 2024.08.14	hrkim		양품가동률 적재 기준 변경 - cell 환산 적용 안함.
 *							- 변경전 : CELL_GOOD_QTY / CELL_INPUT_QTY
 *							- 변경후 : OUT_GOOD_QTY / (OUT_DEFECT_QTY + OUT_GOOD_QTY)
 * 2024.08.26	hrkim		INPUT_QTY 0인 건도 포함 - 투입수량이 0인데 생산수량이 0이 아닌 데이터 존재. 
 *							DW 투입실적 적용 수정
 * 2024.10.25	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : MMD 지표 예외 정보 적용
 * 2024.10.30	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 설비별 loss 최대조업일수 정보 추가 (조업률.attribute1) 
 * 2024.11.04	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 성능가동률 100%으로 적재 (PI 변상현 책임)
 * 2024.12.15   vadabi3     NERP - 특정 Company 별도 처리 개선
 * 2025.03.21	hrkim		(NERP)DW 데이터 plant 조인 컬럼 변경 (plant_id -> mes_plant_id) 
 * 2025.03.24	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 *							- A3000/A9000 완성 공정만 대상으로 함
 * 2025.08.01   hrkim		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경 
 */  


CREATE PROCEDURE [dbo].[PR_SCM_DNM_LOSS_MMLY] 
	 @p_loss_ym		        varchar(6)	= NULL
	,@p_perd_divs_cd		tinyint		= 1			-- 기간구분코드 (1:1개월, 3:3개월) 
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON
	
    DECLARE @v_ESHM NVARCHAR(8); -- G740
	SELECT @v_ESHM = DBO.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_LOSS_MMLY','ESHM') 

	-- loss ym 
	declare @v_loss_ym			varchar(6)	= @p_loss_ym;
	if @v_loss_ym is null or ltrim(rtrim(@v_loss_ym)) = '' 
	begin
		set @v_loss_ym = convert(varchar(6), dateadd(mm, -1, getdate()), 112)  -- default M-1월 기준 적재
	end 

	-- 기간 구분코드
	declare @v_perd_divs_cd		tinyint		= @p_perd_divs_cd;
	if @v_perd_divs_cd is null or @v_perd_divs_cd < 1 
	begin
		set @v_perd_divs_cd = 1
	end 

	declare @v_loss_from_ymd varchar(8) = convert(varchar(8), dateadd(mm, -(@v_perd_divs_cd-1), convert(date, @v_loss_ym+'01', 112)), 112)
	declare @v_loss_to_ymd	 varchar(8) = convert(varchar(8), dateadd(dd, -1, dateadd(mm, 1, convert(date, @v_loss_ym+'01', 112))), 112)

	declare @v_dd_ssn float  = 86400;																						-- 1일 초수
	-- 2024.10.15 주석처리  declare @v_mm_ddn float  = datediff(dd, convert(date,@v_loss_from_ymd,112) , convert(date, @v_loss_to_ymd,112)) + 1 ;	-- 월(기간) 일수
	-- 2024.10.15 주석처리  declare @v_mm_ssn float  = null;	-- 월(기간) 초수
	-- 2024.10.15 주석처리  select  @v_mm_ssn = @v_mm_ddn * @v_dd_ssn ; -- 월(기간) 초수 (일수 * 1일초수)

	print '----------------------------------------------------------------'
	print ' @p_loss_ym			: '	+ @p_loss_ym
	print ' @v_loss_ym			: '	+ @v_loss_ym
	print ' @p_perd_divs_cd		: '	+ converT(nvarchar(10), @p_perd_divs_cd)
	print ' @v_perd_divs_cd		: '	+ converT(nvarchar(10), @v_perd_divs_cd)
	print ' @v_loss_from_ymd	: '	+ @v_loss_from_ymd
	print ' @v_loss_to_ymd		: '	+ @v_loss_to_ymd
	print ' @v_loss_to_ymd		: '	+ @v_loss_to_ymd
	print ' @v_dd_ssn			: '	+ convert(nvarchar(20), @v_dd_ssn)
	-- 2024.10.15 주석처리  print ' @v_mm_ddn			: '	+ convert(nvarchar(20), @v_mm_ddn)
	-- 2024.10.15 주석처리  print ' @v_mm_ssn			: '	+ convert(nvarchar(20), @v_mm_ssn)
	print '----------------------------------------------------------------'

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_LOSS_MMLY'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] Cell 완성 공정 하드 코딩 변경 (임시테이블 변수 셋팅)
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_FINAL_OPERATION TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_FINAL_OPERATION
	SELECT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'  -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- Final Operation
	------------------------------------------------------------------------------------------------------------------


	BEGIN TRY
	  BEGIN

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = '[81,82,JV][loss_ym='+ @v_loss_ym + '][p_perd_divs_cd='+converT(nvarchar(10), @p_perd_divs_cd)+']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### Loss Code 정보 - #LOSS_CODE' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#LOSS_CODE') is not null drop table #LOSS_CODE

		SELECT SEGMENT1		AS LOSS_CD
			  ,ATTRIBUTE1	AS LOSS_UNIT
			  ,ATTRIBUTE2	AS DW_LOSS_CD 
			  ,ATTRIBUTE3   AS LOSS_GR_CD 
			  ,ATTRIBUTE4	AS LOSS_NM
			  ,DISPLAY_SEQ	AS SEQ 
			  ,ATTRIBUTE4	AS LOSS_NM_KO
			  ,ATTRIBUTE5	AS LOSS_NM_EN
		 INTO #LOSS_CODE
		 FROM  SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE 1=1
		  AND LOOKUP_TYPE	= 'SCP_CAPA_LOSS_MEASURE'
		  AND VALID_YN		= 'Y'

		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 설비 Product Level3코드에 대한 전극라인유형코드 정보 - #OPERATION_ELECTRODE_TYPE_MAPPING' -- 5/13  추가 
		-----------------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#OPERATION_ELECTRODE_TYPE_MAPPING') is not null drop table #OPERATION_ELECTRODE_TYPE_MAPPING;

		 SELECT SEGMENT1		AS DIVISION_ID
			   ,SEGMENT2		AS OPERATION_ID
			   ,SEGMENT3		AS EQP_ID_4_3
			   ,MAX(ATTRIBUTE1)	AS ELTR_LN_TP_CD 
		  INTO #OPERATION_ELECTRODE_TYPE_MAPPING
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE = 'OPERATION_ELECTRODE_TYPE_MAPPING' 
		   AND VALID_YN = 'Y'
		GROUP BY SEGMENT1
				,SEGMENT2
				,SEGMENT3

		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 설비 Product Level3코드에 대한 전극라인유형코드 정보 - #EQUIPMENT_PRODUCT_LEVEL3_CODE' 
		-----------------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#EQUIPMENT_PRODUCT_LEVEL3_CODE') is not null drop table #EQUIPMENT_PRODUCT_LEVEL3_CODE;

		 SELECT SEGMENT1		AS OPERATION_ID
			   ,SEGMENT2		AS EQP_PRODUCT_LEVEL3_CODE
			   ,MAX(ATTRIBUTE1)	AS ELTR_LN_TP_CD 
		  INTO #EQUIPMENT_PRODUCT_LEVEL3_CODE
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE = 'EQUIPMENT_PRODUCT_LEVEL3_CODE'
		   AND VALID_YN = 'Y'
		GROUP BY SEGMENT1
				,SEGMENT2
   
		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### FP 설비 Master - #SCM_MST_EQUIPMENT_SN' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_MST_EQUIPMENT_SN') is not null drop table #SCM_MST_EQUIPMENT_SN

		SELECT EM.COMPANY_ID
			  ,EM.DIVISION_ID
			  ,EM.SITE_ID
			  ,EM.PLANT_ID
			  ,EM.FACTORY_ID
			  ,EM.EQUIPMENT_ID
			  ,EM.OPERATION_ID
			  ,EM.ELECTRODE_TYPE 
			  ,CASE  WHEN PL.ELTR_LN_TP_CD IS NOT NULL									THEN PL.ELTR_LN_TP_CD	-- lookup EQUIPMENT_PRODUCT_LEVEL3_CODE : FP설비Product Level3 코드 값에 따른 전극/라인유형
					 WHEN ET.ELTR_LN_TP_CD IS NOT NULL									THEN ET.ELTR_LN_TP_CD   -- lookup OPERATION_ELECTRODE_TYPE_MAPPING : A8000/A8400 설비ID 4번째 3자리에 대한 전극/라인유형 매핑 
					 WHEN EM.OPERATION_ID = 'A7400'	AND EM.ELECTRODE_TYPE = 'A'			THEN 'Anode'			-- CPM 기준 PPM계산시 전극수량 참조를 위함(UI참조 Lookup과 매핑을 위해서도).
					 WHEN EM.OPERATION_ID = 'A7400'	AND EM.ELECTRODE_TYPE = 'C'			THEN 'Cathode'			-- CPM 기준 PPM계산시 전극수량 참조를 위함(UI참조 Lookup과 매핑을 위해서도).
					 WHEN EM.OPERATION_ID like 'P%' OR  CO.OPERATION_ID IS NOT NULL 	THEN '-'				-- [PJ20257329] Cell 완성 공정 하드 코딩 변경
					 -- [PJ20257329] 변경전 WHEN EM.OPERATION_ID like 'P%' OR  EM.OPERATION_ID = 'A9000' 		THEN '-'				
					 ELSE EM.ELECTRODE_TYPE
				END  AS ELTR_LN_TP_CD 
			  ,EM.LINE_ID
			  ,FM.MES_PLANT_ID	-- 2025.03.21 추가
		 INTO #SCM_MST_EQUIPMENT_SN 
		 FROM SCM_MST_EQUIPMENT_SN   EM   WITH(NOLOCK)
			  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
					  ON DM.DIVISION_ID	= EM.DIVISION_ID
					 AND DM.VALID_YN		= 'Y'
					 AND DM.ATTRIBUTE3		IN ('81', '82')  -- JV포함 
			  INNER JOIN SCM_MST_FACTORY_SN FM WITH(NOLOCK) -- 2025.03.21 추가 참조
					  ON FM.COMPANY_ID	= EM.COMPANY_ID
					 AND FM.FACTORY_ID	= EM.FACTORY_ID
			  LEFT  JOIN #EQUIPMENT_PRODUCT_LEVEL3_CODE PL	 -- 20240429 추가
					  ON PL.OPERATION_ID			= EM.OPERATION_ID
					 AND PL.EQP_PRODUCT_LEVEL3_CODE = EM.PRODUCT_LEVEL3_CODE 
			  LEFT  JOIN #OPERATION_ELECTRODE_TYPE_MAPPING ET -- A8000/A8400 공정에 대한 전극/라인 유형 매핑 
					  ON ET.DIVISION_ID		= EM.DIVISION_ID
					 AND ET.OPERATION_ID	= EM.OPERATION_ID
					 AND ET.EQP_ID_4_3		= SUBSTRING(EM.EQUIPMENT_ID, 4, 3) 
			  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경 -- Start 
			  LEFT  JOIN @SCP_CELL_FINAL_OPERATION CO 
					  ON CO.OPERATION_ID = EM.OPERATION_ID
			  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경 -- End 
		WHERE 1=1
		  AND EM.EQUIPMENT_TYPE  = 'M'		-- Main 설비
		  AND EM.ACTIVE_FLAG	 = 'Y' 
		  AND EM.OPERATION_ID   LIKE 'A%'	-- 셀만 

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### FP 설비 Master - #SCM_MST_EQUIPMENT_SN - 소형' 
		-- 2025.03.24 PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
		-- 완성 공정만 대상으로 함 : 셀 : A3000, A9000 
		---------------------------------------------------------------------------------------------------
		INSERT INTO #SCM_MST_EQUIPMENT_SN 
		SELECT EM.COMPANY_ID
			  ,EM.DIVISION_ID
			  ,EM.SITE_ID
			  ,EM.PLANT_ID
			  ,EM.FACTORY_ID
			  ,EM.EQUIPMENT_ID
			  ,EM.OPERATION_ID
			  ,EM.ELECTRODE_TYPE 
			  ,'-'	  AS ELTR_LN_TP_CD 
			  ,EM.LINE_ID
			  ,FM.MES_PLANT_ID	-- 2025.03.21 추가
		 FROM SCM_MST_EQUIPMENT_SN   EM  WITH(NOLOCK)
			  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
					  ON DM.DIVISION_ID	= EM.DIVISION_ID
					 AND DM.VALID_YN		= 'Y'
					 AND DM.ATTRIBUTE3		= '40' -- 소형  
			  INNER JOIN SCM_MST_FACTORY_SN FM WITH(NOLOCK) -- 2025.03.21 추가 참조
					  ON FM.COMPANY_ID	= EM.COMPANY_ID
					 AND FM.FACTORY_ID	= EM.FACTORY_ID
			  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경 -- Start 
			  INNER JOIN @SCP_CELL_FINAL_OPERATION CO
					  ON CO.OPERATION_ID	= EM.OPERATION_ID
			  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경 -- End 
		WHERE 1=1
		  AND EM.EQUIPMENT_TYPE  = 'M'		-- Main 설비
		  AND EM.ACTIVE_FLAG	 = 'Y' 
		  -- [PJ20257329] 변경전 AND EM.OPERATION_ID    IN ('A3000', 'A9000') --- LIKE 'A%'	-- 셀만

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### MMD 지표 예외 정보 ' 
		-----------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_MMD_KPI_EXCT') IS NOT NULL DROP TABLE #SCP_MST_MMD_KPI_EXCT

		SELECT FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,EQUIPMENT_ID		AS EQP_ID
			  ,FROM_DATE
			  ,TO_DATE
		 INTO #SCP_MST_MMD_KPI_EXCT
		 FROM SCP_MST_MMD_KPI_EXCT KE with(nolock)
		WHERE 1=1
		  AND KE.VALID_YN = 'Y'
		  AND KE.KPI_TYPE = 'OEE'

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### dw loss time 실적 rawdata - #LOSS_TIME_RAW_DATA' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#LOSS_TIME_RAW_DATA') is not null drop table #LOSS_TIME_RAW_DATA

		SELECT R.SITE_ID
			  ,R.PLANT_ID
			  ,R.AREA_ID		AS FACTORY_ID
			  ,R.LINE_ID
			  ,R.PROCESS_ID		AS OPERATION_ID
			  ,R.EQPT_ID		AS EQP_ID
			  ,M.LOSS_CD
			  ,R.WORK_DATE		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용 
			  ,CONVERT(FLOAT, REPLACE(R.LOSS_TIME,'null', 0))	   AS LOSS_TIME
			  ,CONVERT(FLOAT, REPLACE(R.LOSS_CNT, 'null', 0))	   AS LOSS_CNT 
			  ,M.LOSS_GR_CD 
			  ,ROW_NUMBER() OVER (PARTITION BY R.SITE_ID, R.PLANT_ID, R.AREA_ID, R.LINE_ID, R.PROCESS_ID, R.EQPT_ID, M.LOSS_CD, R.WORK_DATE
									  ORDER BY R.SORT_ORDER, R.CREATE_DATE DESC ) AS RN  -- 20240424 FP 프로시저 PR_XIF_DW_LOSS_TIME_R 참조 (중복 수신데이터를 거르기 위함) 
		 INTO #LOSS_TIME_RAW_DATA   
		 FROM XIF_DW_RECEIVE_LOSS_TIME_R_SN R with(nolock)  
			 INNER JOIN #LOSS_CODE M 
					 ON M.DW_LOSS_CD = R.MEASURE_CODE
		WHERE 1=1
		  AND R.WORK_DATE BETWEEN @v_loss_from_ymd AND @v_loss_to_ymd
		  AND R.PROCESS_ID like 'A%' -- Cell

		----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### dw loss time 실적 rawdata - #LOSS_TIME_RAW_DATA - 중복 데이터 삭제' 
		----------------------------------------------------------------------------------------------------------------------------
		DELETE R
		 FROM #LOSS_TIME_RAW_DATA R 
		WHERE R.RN != 1 -- 20240424 중복 수신데이터가 존재할시 최종?데이터로 필터링(우선순위 FP 프로시저 참조) 

		----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### dw loss time 실적 rawdata - #LOSS_TIME_RAW_DATA - MMD 지표 예외데이터 삭제' 
		----------------------------------------------------------------------------------------------------------------------------
		DELETE R
		 FROM #LOSS_TIME_RAW_DATA R 
		WHERE 1=1
		  AND EXISTS (SELECT TOP 1 * -- 2024.10.17 MMD 지표예외 대상 제외 
						FROM #SCP_MST_MMD_KPI_EXCT KE
					   WHERE 1=1
						 AND (KE.EQP_ID = R.EQP_ID OR KE.EQP_ID = 'ALL')
						 AND KE.FACTORY_ID		= R.FACTORY_ID
						 AND KE.LINE_ID			= R.LINE_ID
						 AND KE.OPERATION_ID	= R.OPERATION_ID
						 AND R.WORK_DATE BETWEEN KE.FROM_DATE 
											 AND KE.TO_DATE
						 )

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### Loss Time 설비별 집계 - #LOSS_TIME_R_EQP_MMLY' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#LOSS_TIME_R_EQP_MMLY') is not null drop table #LOSS_TIME_R_EQP_MMLY

		 select e.company_id
			   ,e.division_id
			   ,r.site_id
			   ,e.plant_id		-- 2025.03.21 r.plant_id -> e.plant_id
			   ,r.factory_id
			   ,r.line_id
			   ,r.operation_id
			   ,r.eqp_id
			   ,e.eltr_ln_tp_cd
			   ,convert(nvarchar(30), r.loss_cd)			as loss_cd 
			   ,r.loss_gr_cd
			   ,convert(float, count(distinct r.work_date))					as mm_days  -- 2024.10.15 추가 for MMD 지표 예외 정보 적용 
			   ,convert(float, count(distinct r.work_date)*@v_dd_ssn)		as mm_ssn	-- 2024.10.15 추가 for MMD 지표 예외 정보 적용 
			   ,convert(float, sum(loss_cnt))				as loss_cnt
			   ,convert(float, sum(loss_time))				as loss_tm_ssn 
			   ,convert(float, sum(case when r.loss_gr_cd = 'NAV' then convert(float, sum(loss_time)) else 0 end) 
						over (partition by e.company_id, e.division_id, r.site_id, r.factory_id, r.line_id, r.operation_id, r.eqp_id, e.eltr_ln_tp_cd)) as nav_tot_loss_tm  -- 비조업
			   ,convert(float, sum(case when r.loss_gr_cd = 'NLD' then convert(float, sum(loss_time)) else 0 end) 
						over (partition by e.company_id, e.division_id, r.site_id, r.factory_id, r.line_id, r.operation_id, r.eqp_id, e.eltr_ln_tp_cd)) as nld_tot_loss_tm	 -- 비부하
			   ,convert(float, sum(case when r.loss_gr_cd = 'NOP' then convert(float, sum(loss_time)) else 0 end) 
						over (partition by e.company_id, e.division_id, r.site_id, r.factory_id, r.line_id, r.operation_id, r.eqp_id, e.eltr_ln_tp_cd)) as nop_tot_loss_tm  -- 비가동
		 INTO #LOSS_TIME_R_EQP_MMLY 
		 FROM #LOSS_TIME_RAW_DATA R 
			  INNER JOIN #scm_mst_equipment_sn e with(nolock) 
					  ON E.site_id		= R.site_id
					 AND E.mes_plant_id	= R.plant_id	--  2025.03.21 plant_id -> mes_plant_id
					 AND E.factory_id	= R.factory_id
					 AND E.equipment_id	= R.eqp_id
					 AND E.operation_id	= R.operation_id
		WHERE R.RN = 1 -- 20240424 중복 수신데이터가 존재할시 최종?데이터로 필터링(우선순위 FP 프로시저 참조) 
		group by e.company_id
			    ,e.division_id
			    ,r.site_id
			    ,e.plant_id		-- 2025.03.21 r.plant_id -> e.plant_id
			    ,r.factory_id
			    ,r.line_id
			    ,r.operation_id
			    ,r.eqp_id
			    ,e.eltr_ln_tp_cd 
			    ,r.loss_cd
			    ,r.loss_gr_cd

		------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 설비별 집계 Loss율 계산 - #LOSS_TIME_RT_EQP_MMLY' 
		-- 비조업 분모 : 해당월total시간(s) 
		-- 비부하 분모 : 해당월total시간(s) - 비조업합계(s)
		-- 비가동 분모 : 해당월total시간(s) - 비조업합계(s) - 비부하합계(s)
		-- 2024.10.15 MMD 지표 예외 정보 적용 (@v_mm_ssn -> mm_ssn 으로 변경) 
		------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#LOSS_TIME_RT_EQP_MMLY') is not null drop table #LOSS_TIME_RT_EQP_MMLY 

		select *
			  ,convert(numeric(20,10),
			   case when loss_gr_cd = 'NAV'	/* 비조업 */										then loss_tm_ssn /  mm_ssn 
					when loss_gr_cd = 'NLD' and mm_ssn  = nav_tot_loss_tm						then 0
					when loss_gr_cd = 'NLD'	/* 비부하 */										then loss_tm_ssn / convert(float, (mm_ssn - nav_tot_loss_tm)) 
					when loss_gr_cd = 'NOP' and mm_ssn  = nav_tot_loss_tm + nld_tot_loss_tm		then 0 
					when loss_gr_cd = 'NOP'	/* 비가동 */										then loss_tm_ssn / convert(float, (mm_ssn - nav_tot_loss_tm - nld_tot_loss_tm))
			   end	)	as loss_rt 
		into #LOSS_TIME_RT_EQP_MMLY 
		from #LOSS_TIME_R_EQP_MMLY
		where 1=1

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_r_ln_mmly (라인별집계)' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#loss_time_r_ln_mmly') is not null drop table #loss_time_r_ln_mmly

		 select r.company_id
			   ,r.division_id
			   ,r.site_id
			   ,r.plant_id
			   ,r.factory_id
			   ,r.line_id
			   ,r.operation_id
			   ,r.eltr_ln_tp_cd
			   ,r.loss_cd
			   ,r.loss_gr_cd
			   ,sum(r.mm_days)								as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용   (설비대수 반영된 정보로 max가 아닌 sum)
			   ,sum(r.mm_ssn)								as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용   (설비대수 반영된 정보로 max가 아닌 sum)
			   ,convert(float, count(distinct r.eqp_id))	as eqp_nbu
			   ,convert(float, sum(loss_cnt))				as loss_cnt
			   ,convert(float, sum(loss_tm_ssn))			as loss_tm_ssn 
			   ,convert(float, sum(case when r.loss_gr_cd = 'NAV' then convert(float, sum(loss_tm_ssn)) else 0 end) 
						over (partition by r.company_id, r.division_id, r.site_id, r.factory_id, r.line_id, r.operation_id, r.eltr_ln_tp_cd)) as nav_tot_loss_tm	-- 비조업
			   ,convert(float, sum(case when r.loss_gr_cd = 'NLD' then convert(float, sum(loss_tm_ssn)) else 0 end) 
						over (partition by r.company_id, r.division_id, r.site_id, r.factory_id, r.line_id, r.operation_id, r.eltr_ln_tp_cd)) as nld_tot_loss_tm	-- 비부하
			   ,convert(float, sum(case when r.loss_gr_cd = 'NOP' then convert(float, sum(loss_tm_ssn)) else 0 end) 
						over (partition by r.company_id, r.division_id, r.site_id, r.factory_id, r.line_id, r.operation_id, r.eltr_ln_tp_cd)) as nop_tot_loss_tm	-- 비가동
		 into #loss_time_r_ln_mmly  --- select * 
		 from #loss_time_r_eqp_mmly r 
		group by r.company_id
			   ,r.division_id
			   ,r.site_id
			   ,r.plant_id
			   ,r.factory_id
			   ,r.line_id
			   ,r.operation_id
			   ,r.eltr_ln_tp_cd
			   ,r.loss_cd
			   ,r.loss_gr_cd

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_rt_ln_mmly (라인별집계-loss율계산)' 
		-- 비조업 분모 : 해당월total시간(s) * 장비수 
		-- 비부하 분모 : 해당월total시간(s) * 장비수 - 비조업합계(s)
		-- 비가동 분모 : 해당월total시간(s) * 장비수 - 비조업합계(s) - 비부하합계(s)
		-- 2024.10.15 MMD 지표 예외 정보 적용 (@v_mm_ssn * eqp_nbu -> mm_ssn(설비대수 반영된 값)으로 변경) 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#loss_time_rt_ln_mmly') is not null drop table #loss_time_rt_ln_mmly

		select *
			  ,convert(numeric(20,10),
			   case when loss_gr_cd = 'NAV'	/* 비조업 */									then loss_tm_ssn / mm_ssn 
					when loss_gr_cd = 'NLD' and mm_ssn = nav_tot_loss_tm					then 0
					when loss_gr_cd = 'NLD'	/* 비부하 */									then loss_tm_ssn / (mm_ssn - nav_tot_loss_tm) 
					when loss_gr_cd = 'NOP' and mm_ssn = nav_tot_loss_tm + nld_tot_loss_tm	then 0 
					when loss_gr_cd = 'NOP'	/* 비가동 */									then loss_tm_ssn / (mm_ssn - nav_tot_loss_tm - nld_tot_loss_tm) 
			   end	)	as loss_rt 
		into #loss_time_rt_ln_mmly
		from #loss_time_r_ln_mmly
		where 1=1

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_rt_eqp_mmly - 조업율/부하율/시간가동률 추가 (설비별)' 
		-- 2024.10.15 MMD 지표 예외 정보 적용 (@v_mm_ssn -> max(r.mm_ssn)으로 변경) 
		-----------------------------------------------------------------------------------------------------------------------
		---조업율/부하율/시간가동률 추가  
		insert into #loss_time_rt_eqp_mmly
		select r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eqp_id
			  ,r.eltr_ln_tp_cd
			  ,case when loss_gr_cd = 'NAV' then 'AV_RT'
					when loss_gr_cd = 'NLD' then 'LD_RT'
					when loss_gr_cd = 'NOP' then 'OP_RT'
				end						as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,max(r.mm_days)			as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.mm_ssn)			as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,0						as loss_cnt
			  ,case when loss_gr_cd = 'NAV' then convert(float, max(r.mm_ssn)) - max(nav_tot_loss_tm)													-- 조업시간(초)
					when loss_gr_cd = 'NLD' then convert(float, max(r.mm_ssn)) - max(nav_tot_loss_tm) - max(nld_tot_loss_tm)							-- 부하시간(초)
					when loss_gr_cd = 'NOP' then convert(float, max(r.mm_ssn)) - max(nav_tot_loss_tm) - max(nld_tot_loss_tm) - max(nop_tot_loss_tm)		-- 가동시간(초)
					else 0
				end																	as loss_tm_ssn 
			  ,	max(nav_tot_loss_tm)												as nav_tot_loss_tm
			  ,	max(nld_tot_loss_tm)												as nld_tot_loss_tm
			  , max(nop_tot_loss_tm)												as nop_tot_loss_tm
			  , convert(float, 1)  - convert(float, sum(convert(float,loss_rt)))	as loss_rt 
		from #loss_time_rt_eqp_mmly r
		where 1=1
		  and r.loss_gr_cd in ('NAV', 'NLD', 'NOP') 
		group by r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,r.loss_gr_cd
			  ,r.eqp_id
			  
		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_rt_ln_mmly - 조업율/부하율/시간가동률 추가 (라인별)' 
		-- 2024.10.15 MMD 지표 예외 정보 적용
		-- 변경전 : @v_mm_ssn * eqp_nbu
		-- 변경후 : max(r.mm_ssn)  -> 설비대수 적용된 값 
		-----------------------------------------------------------------------------------------------------------------------
		---조업율/부하율/시간가동률 추가  
		insert into #loss_time_rt_ln_mmly
		select r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,case when loss_gr_cd = 'NAV' then 'AV_RT'
					when loss_gr_cd = 'NLD' then 'LD_RT'
					when loss_gr_cd = 'NOP' then 'OP_RT'
				end						as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,max(r.mm_days)			as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.mm_ssn)			as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.eqp_nbu
			  ,0						as loss_cnt
			  -- 2024.10.15 변경 : 이미 설비 대수 반영된 값 - 조업:비조업 = 1 : N이라 max로 반영 
			  ,case when loss_gr_cd = 'NAV' then convert(float, max(r.mm_ssn) ) - max(nav_tot_loss_tm)													-- 조업시간(초)
					when loss_gr_cd = 'NLD' then convert(float, max(r.mm_ssn) ) - max(nav_tot_loss_tm) - max(nld_tot_loss_tm)							-- 부하시간(초)
					when loss_gr_cd = 'NOP' then convert(float, max(r.mm_ssn) ) - max(nav_tot_loss_tm) - max(nld_tot_loss_tm) - max(nop_tot_loss_tm)	-- 가동시간(초)
					else 0
				end																	as loss_tm_ssn 
			  ,	max(nav_tot_loss_tm)												as nav_tot_loss_tm
			  ,	max(nld_tot_loss_tm)												as nld_tot_loss_tm
			  , max(nop_tot_loss_tm)												as nop_tot_loss_tm
			  , convert(float, 1)  - convert(float, sum(convert(float, loss_rt)))	as loss_rt 
		from #loss_time_rt_ln_mmly r
		where 1=1
		  and r.loss_gr_cd in ('NAV', 'NLD', 'NOP') 
		group by r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,r.loss_gr_cd
			  ,r.eqp_nbu

		-------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 품목ID Basic NickName 정보 #SCP_MST_ITEM_BSI_IFO' 
		-------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCP_MST_ITEM_BSI_IFO') is not null drop table #SCP_MST_ITEM_BSI_IFO;

		SELECT ITEM_ID
			  ,SCP_OPERATION_GROUP
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,BASIC_NICK_NAME 
			  ,ITEM_CLASS
		 INTO #SCP_MST_ITEM_BSI_IFO
		 FROM SCP_MST_ITEM_BSI_IFO WITH(NOLOCK) 
		WHERE 1=1

		-------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 셀 환산계수 정보 #SCP_MST_ITEM_CELL_CF' 
		-------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCP_MST_ITEM_CELL_CF') is not null drop table #SCP_MST_ITEM_CELL_CF;

		SELECT ITEM_ID
			  ,TARGET_CELL
			  ,CONVERT(FLOAT, ISNULL(CELL_CF, '1'))	AS CELL_CF
		 INTO #SCP_MST_ITEM_CELL_CF
		 FROM SCP_MST_ITEM_CELL_CF WITH(NOLOCK)
		WHERE 1=1

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 생산 투입 실적 - #PRD_INPUT_EQP_R ' 
		----------------------------------------------------------------------------------------------------------------
		----### Stacking & Folding
		-- ES0701	[AFCFC]Folded Cell
		-- ES0801	[ASCSC]Stacked Cell
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PRD_INPUT_EQP_R') is not null drop table #PRD_INPUT_EQP_R

		SELECT R.SITE_ID
			  ,F.PLANT_ID		-- 2025.03.21 r.plant_id -> f.plant_id
			  ,R.AREA_ID					AS FACTORY_ID
			  ,R.LINE_ID
			  ,CASE WHEN R.PROCESS_ID = 'A4000DW' THEN 'A3000'
					WHEN R.PROCESS_ID = 'A7400DW' THEN IIF(F.COMPANY_ID = @v_ESHM, 'A7400', 'A7000')
					WHEN R.PROCESS_ID = 'A8400DW' THEN IIF(F.COMPANY_ID = @v_ESHM, 'A8400', 'A8000')
					ELSE R.PROCESS_ID
			    END							AS OPERATION_ID
			  ,R.EQPT_ID					AS EQP_ID
			  ,R.PRODUCT_ID					AS ITEM_ID
			  ,R.MATERIAL_ID
			  ,I.ITEM_CLASS	
			  ,CASE WHEN I.ITEM_CLASS IN ('ES0701', 'ES0801')  -- Stacking & Folding인 경우 투입 Material의 품목 분류정보 추가 
					THEN MI.ITEM_CLASS
					ELSE '-'
				END AS MATERIAL_ITEM_CLASS
			  ,I.BASIC_NICK_NAME			AS NICK_NAME
			  ,I.ELTR_LN_TP_CD
			  ,CONVERT(FLOAT, ISNULL(CM.CELL_CF, '1'))			AS MATERIAL_CELL_CONV_RATE
			  ,CONVERT(FLOAT, ISNULL(CP.CELL_CF, '1'))			AS PRODUCT_CELL_CONV_RATE
			  ,CONVERT(FLOAT, SUM(R.INPUT_QTY		))			AS INPUT_QTY
			  ,CONVERT(FLOAT, SUM(R.OUT_INPUT_QTY	))			AS OUT_INPUT_QTY  -- 6/5 추가
			  ,CONVERT(FLOAT, SUM(R.GOOD_QTY		))			AS GOOD_QTY 
			  ,CONVERT(FLOAT, SUM(R.OUT_GOOD_QTY	))			AS OUT_GOOD_QTY 
			  ,CONVERT(FLOAT, SUM(R.OUT_DEFECT_QTY	))			AS OUT_DEFECT_QTY -- 2024.08.14 추가  
		 INTO #PRD_INPUT_EQP_R 
		 FROM SCM_DNM_INPT_PRDN_DDLY R with(nolock) 
			  INNER JOIN SCM_MST_FACTORY_SN F with(nolock) 
					  ON F.FACTORY_ID	= R.AREA_ID
					 AND F.MES_PLANT_ID	= R.PLANT_ID	-- 2025.03.21 plant_id -> mes_plant_id 
			  INNER JOIN #SCP_MST_ITEM_BSI_IFO I WITH(NOLOCK)
					  ON I.ITEM_ID = R.PRODUCT_ID 
			  LEFT  JOIN #SCP_MST_ITEM_BSI_IFO MI WITH(NOLOCK)
					  ON MI.ITEM_ID = R.MATERIAL_ID 
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CM WITH(NOLOCK)
					  ON CM.ITEM_ID = R.MATERIAL_ID 
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CP WITH(NOLOCK)
					  ON CP.ITEM_ID = R.PRODUCT_ID 
		WHERE 1=1
		  AND R.CAL_YMD_ID BETWEEN @v_loss_from_ymd
							   AND @v_loss_to_ymd
		  AND R.LOT_TYPE_ID IN ('P', 'R', 'H', 'S', 'Y', 'B')	-- FP YLD 대상 조건에 'B' 추가
		  AND R.PROCESS_ID  LIKE 'A%'							-- Cell
		  AND R.EQPT_ID		!= '@'								-- 설비정보가 없는 경우 투입수량이 0임?
		  AND R.MATERIAL_ID != '@'								-- 투입자재가 없는 경우 투입수량이 0임?
		  -- 2024.08.23 투입수량0인 데이터도 포함    AND R.INPUT_QTY   != 0 
		GROUP BY R.SITE_ID
			  ,F.PLANT_ID		-- 2025.03.21 R.plant_id -> F.plant_id 
			  ,R.AREA_ID
			  ,R.LINE_ID
			  ,CASE WHEN R.PROCESS_ID = 'A4000DW' THEN 'A3000'
					WHEN R.PROCESS_ID = 'A7400DW' THEN IIF(F.COMPANY_ID = @v_ESHM, 'A7400', 'A7000')
					WHEN R.PROCESS_ID = 'A8400DW' THEN IIF(F.COMPANY_ID = @v_ESHM, 'A8400', 'A8000')
					ELSE R.PROCESS_ID
			    END			
			  ,R.EQPT_ID	
			  ,R.PRODUCT_ID	
			  ,R.MATERIAL_ID
			  ,I.ITEM_CLASS				
			  ,MI.ITEM_CLASS
			  ,I.BASIC_NICK_NAME
			  ,I.ELTR_LN_TP_CD
			  ,CONVERT(FLOAT, ISNULL(CM.CELL_CF, '1'))
			  ,CONVERT(FLOAT, ISNULL(CP.CELL_CF, '1'))
			  ,CASE WHEN I.ITEM_CLASS IN ('ES0701', 'ES0801') 
					THEN MI.ITEM_CLASS
					ELSE '-'
				END

		------------------------------------
		-- 제외대상 삭제 
		------------------------------------
		 DELETE 
		 FROM #PRD_INPUT_EQP_R 
		WHERE 1=1
		  AND ITEM_CLASS = 'ES0701' 
		  AND ISNULL(MATERIAL_ITEM_CLASS,'Z') NOT IN ('ES0601', 'ES0602') -- Folding 투입 반제품이 A/C Type Bi Cell이 아닌 경우 

		---------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 생산 투입 실적  #PRD_INPUT_EQP_R : 대상 LOSS 실적이 없는 데이터 삭제' 
		-- 2025.03.26 지표 예외로 대상에서 제외된 LOSS 실적등 불필요한 투입실적 참조 삭제 
		---------------------------------------------------------------------------------------------------------------------------
		CREATE INDEX LOSS_IDX_1 on  #LOSS_TIME_RAW_DATA (LINE_ID, OPERATION_ID, FACTORY_ID) ; 

		DELETE I 
		  FROM #PRD_INPUT_EQP_R I
		WHERE 1=1
		  AND NOT EXISTS (SELECT 'X'
							FROM #LOSS_TIME_RAW_DATA L
						   WHERE 1=1
						     AND L.LINE_ID		= I.LINE_ID
							 AND L.OPERATION_ID = I.OPERATION_ID
							 AND L.FACTORY_ID	= I.FACTORY_ID
							 ) 

		---------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 생산 투입 실적  #PRD_INPUT_CELL_CONVERT_R : Cell기준 환산수량 계산' 
		---------------------------------------------------------------------------------------------------------------------------
		-----### Nothcing
		---	ES0501	[ANPAN]Anode Notched Pancake
		---	ES0502	[ANPCA]Cathode Notched Pancake
		-----### Lamination
		---	ES0601	[ABCAT]A-Type Bi-Cell
		---	ES0602	[ABCCT]C-Type Bi-Cell
		---	ES1007	[AMCMC]Mono-Type Cell
		---	ES1101	[AHCHC]HALF-Type Cell
		-----### Stacking & Folding
		---	ES0701	[AFCFC]Folded Cell
		---	ES0801	[ASCSC]Stacked Cell
		-----### PKG 
		---	ES1901	[ACACA]Cell Assembly
		---------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PRD_INPUT_CELL_CONVERT_R') is not null drop table #PRD_INPUT_CELL_CONVERT_R

		SELECT E.COMPANY_ID
			  ,E.DIVISION_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID
			  ,R.OPERATION_ID
			  ,R.NICK_NAME 
			  ,E.ELTR_LN_TP_CD  --- 5/13 
			  ,R.MATERIAL_ITEM_CLASS
			  ,R.EQP_ID  -- 20240826
			  --- 20240826 ,CONVERT(FLOAT, COUNT(DISTINCT R.EQP_ID))	AS EQP_NBU
			  ,CONVERT(FLOAT, SUM(R.INPUT_QTY))			AS INPUT_QTY		-- 반제품기준 투입수량
			  ,CONVERT(FLOAT, SUM(R.OUT_INPUT_QTY	))	AS OUT_INPUT_QTY	-- 6/5 추가 OUT기준 투입수량
			  ,CONVERT(FLOAT,
			   SUM(CASE	WHEN R.MATERIAL_CELL_CONV_RATE = 0												THEN CONVERT(FLOAT, 0)
						WHEN R.ITEM_CLASS = 'ES0801' AND ISNULL(R.MATERIAL_ITEM_CLASS,'Z') != 'ES1007'	THEN CONVERT(FLOAT, 0)											-- Stacking Mono 투입이 아닌 경우 0  
						WHEN R.ITEM_CLASS IN ('ES0501', 'ES0502', 'ES0701', 'ES0801')	THEN CONVERT(FLOAT, R.INPUT_QTY * R.MATERIAL_CELL_CONV_RATE)					-- 노칭(Anode/Cathode), 폴딩, SKG
						WHEN R.PRODUCT_CELL_CONV_RATE = 0								THEN CONVERT(FLOAT, 0)
						WHEN R.ITEM_CLASS IN ('ES0601', 'ES0602')						THEN CONVERT(FLOAT, R.INPUT_QTY * R.PRODUCT_CELL_CONV_RATE) / CONVERT(FLOAT, 3)	-- 라미 (A,C) 
						WHEN R.ITEM_CLASS = 'ES1007'									THEN CONVERT(FLOAT, R.INPUT_QTY * R.PRODUCT_CELL_CONV_RATE) / CONVERT(FLOAT, 2)	-- 라미 (Mono) 
						WHEN R.ITEM_CLASS IN ('ES1901', 'ES1101')						THEN R.INPUT_QTY 																-- PKG, 라미(Half)
						END))		AS CELL_INPUT_QTY	-- Cell기준 투입수량
			  ,CONVERT(FLOAT, SUM(R.OUT_GOOD_QTY))		AS OUT_GOOD_QTY		-- 반제품기준 양품생산수량 
			  ,CONVERT(FLOAT, SUM(R.OUT_DEFECT_QTY	))	AS OUT_DEFECT_QTY	-- 2024.08.14 추가  
			  ,CONVERT(FLOAT,
			   SUM(CASE	WHEN R.MATERIAL_CELL_CONV_RATE = 0												THEN CONVERT(FLOAT, 0)
						WHEN R.ITEM_CLASS = 'ES0801' AND ISNULL(R.MATERIAL_ITEM_CLASS,'Z') != 'ES1007'	THEN CONVERT(FLOAT, 0)											-- Stacking Mono 투입이 아닌 경우 0  
						WHEN R.ITEM_CLASS IN ('ES0501', 'ES0502', 'ES0701', 'ES0801')	THEN CONVERT(FLOAT, R.GOOD_QTY * R.MATERIAL_CELL_CONV_RATE)						-- 노칭(Anode/Cathode), 폴딩, SKG
						WHEN R.PRODUCT_CELL_CONV_RATE = 0								THEN CONVERT(FLOAT, 0)
						WHEN R.ITEM_CLASS IN ('ES0601', 'ES0602')						THEN CONVERT(FLOAT, R.GOOD_QTY * R.PRODUCT_CELL_CONV_RATE) / CONVERT(FLOAT, 3)	-- 라미 (A,C) 
						WHEN R.ITEM_CLASS = 'ES1007'									THEN CONVERT(FLOAT, R.GOOD_QTY * R.PRODUCT_CELL_CONV_RATE) / CONVERT(FLOAT, 2)	-- 라미 (Mono) 
						WHEN R.ITEM_CLASS IN ('ES1901', 'ES1101')						THEN R.GOOD_QTY 																-- PKG, 라미(Half)
						END))		AS CELL_GOOD_QTY	-- Cell기준 양품 생산수량 
		 INTO #PRD_INPUT_CELL_CONVERT_R
		 FROM #PRD_INPUT_EQP_R R 
			  INNER JOIN #SCM_MST_EQUIPMENT_SN E  WITH(NOLOCK)    
					  ON E.SITE_ID		= R.SITE_ID
					 AND E.PLANT_ID		= R.PLANT_ID
					 AND E.FACTORY_ID	= R.FACTORY_ID
					 AND E.EQUIPMENT_ID	= R.EQP_ID
					 AND E.OPERATION_ID	= R.OPERATION_ID
					 AND E.ELTR_LN_TP_CD = R.ELTR_LN_TP_CD -- 2024.08.26 
		WHERE 1=1
		GROUP BY  E.COMPANY_ID
			  ,E.DIVISION_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID
			  ,R.OPERATION_ID
			  ,R.NICK_NAME
			  ,E.ELTR_LN_TP_CD  -- 5/13 
			  ,R.MATERIAL_ITEM_CLASS
			  ,R.EQP_ID  -- 20240826

		--------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 생산 투입 실적 - #PROD_INPUT_RESULT (모델별:Basic Model NickName)' 
		--------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PROD_INPUT_RESULT') is not null drop table #PROD_INPUT_RESULT
			  
		SELECT R.COMPANY_ID
			  ,R.DIVISION_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID
			  ,R.OPERATION_ID
			  ,R.NICK_NAME								AS MDL_NM 
			  ,R.ELTR_LN_TP_CD
			  ,CONVERT(FLOAT, COUNT(DISTINCT R.EQP_ID))	AS EQP_NBU
			  ,CONVERT(FLOAT, SUM(INPUT_QTY		))		AS INPUT_QTY
			  ,CONVERT(FLOAT, SUM(OUT_INPUT_QTY	))		AS OUT_INPUT_QTY	-- 6/5 추가 OUT기준 투입수량
			  ,CONVERT(FLOAT, 
			   CASE WHEN R.ELTR_LN_TP_CD = 'Folding' 
					THEN AVG(CELL_INPUT_QTY)
					ELSE SUM(CELL_INPUT_QTY)
			   END)	AS CELL_INPUT_QTY
			  ,CONVERT(FLOAT, ISNULL(SUM(OUT_GOOD_QTY)  ,0))	AS OUT_GOOD_QTY
			  ,CONVERT(FLOAT, ISNULL(SUM(OUT_DEFECT_QTY),0))	AS OUT_DEFECT_QTY	-- 2024.08.14 추가
			  ,CONVERT(FLOAT,
			   CASE WHEN R.ELTR_LN_TP_CD = 'Folding' 
					THEN AVG(CELL_GOOD_QTY)
					ELSE SUM(CELL_GOOD_QTY)
			   END)	AS CELL_GOOD_QTY
		 INTO #PROD_INPUT_RESULT
	      FROM #PRD_INPUT_CELL_CONVERT_R R   -- 2024.08.26 변경  
		 WHERE 1=1
		 GROUP BY R.COMPANY_ID
			  ,R.DIVISION_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID
			  ,R.OPERATION_ID
			  ,R.NICK_NAME 
			  ,R.ELTR_LN_TP_CD

		------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 생산 투입 실적  #PRD_INPUT_CELL_CONVERT_R_LN : Cell기준 환산수량 라인별/material class별 집계' 
		------------------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PRD_INPUT_CELL_CONVERT_R_LN') is not null drop table #PRD_INPUT_CELL_CONVERT_R_LN

		select r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,r.material_item_class  -- for Folding 
			  ,CONVERT(FLOAT, COUNT(DISTINCT R.EQP_ID))	AS EQP_NBU
			  ,sum(r.input_qty)							as input_qty
			  ,sum(r.cell_input_qty)					as cell_input_qty
			  ,sum(r.out_good_qty)						as out_good_qty
			  ,sum(r.cell_good_qty)						as cell_good_qty 
			  ,sum(r.out_input_qty)						as out_input_qty 
			  ,sum(r.out_defect_qty)					as out_defect_qty 
		into #PRD_INPUT_CELL_CONVERT_R_LN 
		from #PRD_INPUT_CELL_CONVERT_R r 
		where 1=1
		group by r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,r.material_item_class		
			  
		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 생산 투입 실적 - #PROD_INPUT_RESULT_LN (라인별)' 
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PROD_INPUT_RESULT_LN') is not null drop table #PROD_INPUT_RESULT_LN
			  
		SELECT R.COMPANY_ID
			  ,R.DIVISION_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID
			  ,R.OPERATION_ID
			  ,R.ELTR_LN_TP_CD
			  ,CONVERT(FLOAT, MAX(EQP_NBU  ))			AS EQP_NBU
			  ,CONVERT(FLOAT, SUM(INPUT_QTY))			AS INPUT_QTY
			  ,CONVERT(FLOAT, 
			   CASE WHEN R.ELTR_LN_TP_CD = 'Folding' 
					THEN AVG(CELL_INPUT_QTY)
					ELSE SUM(CELL_INPUT_QTY)
			   END)										AS CELL_INPUT_QTY
			  ,CONVERT(FLOAT, SUM(OUT_GOOD_QTY))		AS OUT_GOOD_QTY
			  ,CONVERT(FLOAT, SUM(OUT_DEFECT_QTY))		AS OUT_DEFECT_QTY
			  ,CONVERT(FLOAT,
			   CASE WHEN R.ELTR_LN_TP_CD = 'Folding' 
					THEN AVG(CELL_GOOD_QTY)
					ELSE SUM(CELL_GOOD_QTY)
			   END)										AS CELL_GOOD_QTY
		  INTO #PROD_INPUT_RESULT_LN
	      FROM #PRD_INPUT_CELL_CONVERT_R_LN R 
		 WHERE 1=1
		 GROUP BY R.COMPANY_ID
			  ,R.DIVISION_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID
			  ,R.OPERATION_ID
			  ,R.ELTR_LN_TP_CD

		-------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### MMD 라인별 설계속도 - #SCP_MST_MDL_EQP_SPED (라인별)' 
		-- MMD설계속도: 한 라인에 여러 Basic Nickname이 존재하는 경우 투입수량 가중치 적용
		-- 단위가 Tact Time인 경우 : 60 / 설계속도
		-------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCP_MST_MDL_EQP_SPED') is not null drop table #SCP_MST_MDL_EQP_SPED

		SELECT S.COMPANY_ID
			  ,S.DIVISION_ID
			  ,S.SITE_ID
			  ,S.PLANT_ID
			  ,S.FACTORY_ID
			  ,S.LINE_ID
			  ,S.OPERATION_ID
			  ,S.ELTR_LN_TP_CD
			  ,CONVERT(FLOAT,
			   CASE WHEN SUM(R.OUT_INPUT_QTY) = 0		THEN 0
					WHEN MAX(EQP_SPED_UNIT_CD) = 'TTT'
					THEN CONVERT(FLOAT, 60) / (	CONVERT(FLOAT, SUM(CONVERT(FLOAT, S.EQP_SPED) * R.OUT_INPUT_QTY))	-- 2024.06.05 output기준 투입수량 가중치 적용 
											  / CONVERT(FLOAT, SUM(R.OUT_INPUT_QTY))
											  )
					ELSE   CONVERT(FLOAT, SUM(CONVERT(FLOAT, S.EQP_SPED) * R.OUT_INPUT_QTY) ) -- 2024.06.05 output기준 투입수량 가중치 적용 
						 / CONVERT(FLOAT, SUM(R.OUT_INPUT_QTY) )
				END)						AS EQP_SPED				-- MMD설계속도
			  ,MAX(EQP_SPED_UNIT_CD)	AS EQP_SPED_UNIT_CD
		 INTO #SCP_MST_MDL_EQP_SPED
		 FROM SCP_MST_MDL_EQP_SPED S WITH(NOLOCK)
			  INNER JOIN #PROD_INPUT_RESULT R   -- 모델별 투입수량  
					  ON R.MDL_NM		= S.MDL_NM
					 AND R.COMPANY_ID	= S.COMPANY_ID
					 AND R.DIVISION_ID	= S.DIVISION_ID
					 AND R.SITE_ID		= S.SITE_ID
					 AND R.PLANT_ID		= S.PLANT_ID
					 AND R.FACTORY_ID	= S.FACTORY_ID
					 AND R.LINE_ID		= S.LINE_ID
					 AND R.OPERATION_ID	= S.OPERATION_ID
					 AND R.ELTR_LN_TP_CD= S.ELTR_LN_TP_CD 
		WHERE 1=1
		GROUP BY S.COMPANY_ID
				,S.DIVISION_ID
				,S.SITE_ID
				,S.PLANT_ID
				,S.FACTORY_ID
				,S.LINE_ID
				,S.OPERATION_ID
				,S.ELTR_LN_TP_CD

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_rt_ln_mmly - 생산평균속도 (라인별)' 
		-----------------------------------------------------------------------------------------------------------------------
		----	생산평균속도
		----	 1) 설계속도 단위가 mm/s (Notching공정) = 투입 수량 (개) - 반제품 기준/가동시간(분)*1000/60
		----	 2) 나머지 = 투입 수량 (개) - Cell 기준/가동시간(분) * 생산 수량 (개) - 반제품 (양품량)/생산 수량 (개) - Cell 기준 (양품량)
		-----------------------------------------------------------------------------------------------------------------------
	    insert into #loss_time_rt_ln_mmly
		select r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,'PROD_AVG_SPED'			as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,r.mm_days				as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.mm_ssn					as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.eqp_nbu
			  ,0						as loss_cnt
			  ,0						as loss_tm_ssn 
			  ,0						as nav_tot_loss_tm
			  ,0						as nld_tot_loss_tm
			  ,0						as nop_tot_loss_tm	
			  ,case when r.loss_tm_ssn  = 0					-- 가동시간이 0 이면 0		
					then 0																						 
					when r.operation_id = 'A5000'			-- Notching (mm/s)	
					then isnull(pr.input_qty, convert(float, 0)) 
							/ (convert(float, r.loss_tm_ssn) / convert(float, 60))  
							* convert(float, 1000) 
							/ convert(float, 60)	
					when isnull(pr.cell_good_qty, 0) = 0	-- 생산 수량 (개) - Cell (양품량)
					then 0																						
					else isnull(pr.cell_input_qty, convert(float, 0)) 
							  / (convert(float, r.loss_tm_ssn) / convert(float, 60)) 
							  * isnull(pr.out_good_qty, convert(float, 0)) 
							  / pr.cell_good_qty
			   end  as loss_rt
		from #loss_time_rt_ln_mmly r
			 inner join #PROD_INPUT_RESULT_LN pr
					on pr.company_id	= r.company_id
				   and pr.division_id	= r.division_id 
				   and pr.site_id		= r.site_id
				   and pr.plant_id		= r.plant_id
				   and pr.factory_id	= r.factory_id
				   and pr.line_id		= r.line_id
				   and pr.operation_id	= r.operation_id
				   and pr.eltr_ln_tp_cd = r.eltr_ln_tp_cd 
		where 1=1
		  and loss_cd = 'OP_RT'

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_rt_mdl_mmly - 양품가동률 (라인별)' 
		-----------------------------------------------------------------------------------------------------------------------
		-- 양품가동률 = 양품수량(Cell기준) / 투입수량 (Cell기준)		-> 2024.08.14 변경전 
		-- 양품가동률 = OUT_GOOD_QTY / (OUT_DEFECT_QTY + OUT_GOOD_QTY)	-> 2024.08.14 변경후 
		-----------------------------------------------------------------------------------------------------------------------
	    insert into #loss_time_rt_ln_mmly  
		select r.company_id  
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,'QL_RT_LN'	as loss_cd	-- 라인별 양품가동률 
			  ,'-'			as loss_gr_cd 
			  ,op.mm_days				-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,op.mm_ssn				-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.eqp_nbu
			  ,0			as loss_cnt
			  ,0			as loss_m_ssn
			  ,0			as nav_tot_loss_tm
			  ,0			as nld_tot_loss_tm
			  ,0			as nop_tot_loss_tm
			  ,case when (OUT_DEFECT_QTY + OUT_GOOD_QTY) = 0 
					then 0.
					else convert(float, OUT_GOOD_QTY) / convert(float, OUT_DEFECT_QTY + OUT_GOOD_QTY) -- 2024.08.14 변경
			   end  as loss_rt
		from #PROD_INPUT_RESULT_LN R
			 left join #loss_time_rt_ln_mmly op  -- 2024.10.15 join 추가 for MMD 지표 예외 정보 적용  
					on op.company_id	= r.company_id
				   and op.division_id	= r.division_id 
				   and op.site_id		= r.site_id
				   and op.plant_id		= r.plant_id
				   and op.factory_id	= r.factory_id
				   and op.line_id		= r.line_id
				   and op.operation_id	= r.operation_id
				   and op.eltr_ln_tp_cd = r.eltr_ln_tp_cd 
				   and op.loss_cd		= 'OP_RT'
		where 1=1

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_rt_mdl_mmly - 양품가동률 (모델별)' 
		-----------------------------------------------------------------------------------------------------------------------
		-- 양품가동률 = 양품수량(Cell기준) / 투입수량 (Cell기준)		-> 2024.08.14 변경전 
		-- 양품가동률 = OUT_GOOD_QTY / (OUT_DEFECT_QTY + OUT_GOOD_QTY)	-> 2024.08.14 변경후 
		-----------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#loss_rt_mdl_mmly') is not null drop table #loss_rt_mdl_mmly

		select r.mdl_nm --- 3/19 
			  ,r.company_id  
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,'QL_RT'	as loss_cd
			  --- for 검증
			  ,0 as input_qty
			  ,0 as cell_input_qty
			  ,0 as loss_tm_mins	
			  ,0 as cell_good_qty
			  ,0 as out_good_qty
			  --------------------------------
			  ,case when (OUT_DEFECT_QTY + OUT_GOOD_QTY) = 0 
					then 0.
					else convert(float, OUT_GOOD_QTY) / convert(float, OUT_DEFECT_QTY + OUT_GOOD_QTY) -- 2024.08.14 변경
			   end  as loss_rt
			-- 2024.08.14 변경전    ,case when isnull(sum(cell_input_qty), 0) = 0 
			-- 2024.08.14 변경전  		then 0
			-- 2024.08.14 변경전  		else convert(float, isnull(sum(cell_good_qty), 0)) / converT(float, sum(cell_input_qty)) 
			-- 2024.08.14 변경전     end  as loss_rt  
		into #loss_rt_mdl_mmly
		from #PROD_INPUT_RESULT R
		where 1=1

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_rt_mdl_mmly - MMD 설계속도 추가 (라인별)' 
		-----------------------------------------------------------------------------------------------------------------------
	    insert into #loss_time_rt_ln_mmly
		select r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,'MMD_SPED'				as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,r.mm_days				as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.mm_ssn					as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.eqp_nbu
			  ,0						as loss_cnt
			  ,0						as loss_tm_ssn 
			  ,0						as nav_tot_loss_tm
			  ,0						as nld_tot_loss_tm
			  ,0						as nop_tot_loss_tm	
			  ,s.eqp_sped				as loss_rt -- MMD 설계속도
		 FROM #loss_time_rt_ln_mmly r
			   inner join #SCP_MST_MDL_EQP_SPED s with(nolock)
					   on s.company_id		= r.company_id
					  and s.division_id		= r.division_id
					  and s.site_id			= r.site_id
					  and s.plant_id		= r.plant_id
					  and s.factory_id		= r.factory_id
					  and s.line_id			= r.line_id
					  and s.operation_id	= r.operation_id
					  and s.eltr_ln_tp_cd	= r.eltr_ln_tp_cd 
		WHERE 1=1
		  AND loss_cd = 'PROD_AVG_SPED' -- 생산평균속도


		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_rt_mdl_mmly - 성능가동률 추가 (라인별)' 
		-----------------------------------------------------------------------------------------------------------------------
		/*
		--	설계속도(MMD기준)  - SCP_MST_MDL_EQP_SPED (MDL_NM, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELTR_LN_TP_CD) 
		--	 1) 설계속도 단위가 Tact Time일 경우 = 60/설계속도
		--	 2) 나머지 = 설계속도
		--	생산평균속도
		--	 1) 설계속도 단위가 mm/s (Notching공정) = 투입 수량 (개) - 반제품 기준/가동시간(분)*1000/60
		--	 2) 나머지 = 투입 수량 (개) - Cell 기준/가동시간(분) * 생산 수량 (개) - 반제품 (양품량)/생산 수량 (개) - Cell (양품량)
		----------------------
		-- 2024.11.04 성능가동률 100%으로 적재 
		*/
		-----------------------------------------------------------------------------------------------------------------------
	    insert into #loss_time_rt_ln_mmly
		select r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,'PF_RT'					as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,r.mm_days				as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.mm_ssn					as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.eqp_nbu
			  ,0						as loss_cnt
			  ,loss_tm_ssn				as loss_tm_ssn	-- 2024.11.04 성능가동률 100% (성능가동시간 = 시간가동시간)
			  ,0						as nav_tot_loss_tm
			  ,0						as nld_tot_loss_tm
			  ,0						as nop_tot_loss_tm	
			  --------------------------------
			  ,1.0						as loss_rt		-- 2024.11.04 성능가동률 100%으로 적재 
		 FROM #loss_time_rt_ln_mmly r
		WHERE 1=1
		  AND loss_cd = 'OP_RT' -- 시간가동률 

		/* 2024.11.04 성능가동률 100%으로 변경전 소스 
		select r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,'PF_RT'					as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,r.mm_days				as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.mm_ssn					as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,r.eqp_nbu
			  ,0						as loss_cnt
			  ,0						as loss_tm_ssn 
			  ,0						as nav_tot_loss_tm
			  ,0						as nld_tot_loss_tm
			  ,0						as nop_tot_loss_tm	
			  --------------------------------
			  ,case when s.eqp_sped = 0 or r.loss_rt = 0 
					then 0
					else convert(float, r.loss_rt) / convert(float, s.eqp_sped) 				--  생산평균속도 / MMD설계속도
				end			as loss_rt 
		 FROM #loss_time_rt_ln_mmly r
			   inner join #SCP_MST_MDL_EQP_SPED s with(nolock)
					   on s.company_id		= r.company_id
					  and s.division_id		= r.division_id
					  and s.site_id			= r.site_id
					  and s.plant_id		= r.plant_id
					  and s.factory_id		= r.factory_id
					  and s.line_id			= r.line_id
					  and s.operation_id	= r.operation_id
					  and s.eltr_ln_tp_cd	= r.eltr_ln_tp_cd 
		WHERE 1=1
		  AND loss_cd = 'PROD_AVG_SPED' -- 생산평균속도
		*/

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_rt_mdl_mmly - - 생산가동률 (라인별) '   -- 20240429 추가
		-------------------------------------------------------------------------------------------------------------------
		--  PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률(라인별)
		--  LD_RT      : 부하율
		--  OP_RT      : 시간가동률
		--  PF_RT      : 성능가동률
		--  QL_RT      : 양품가동률
		-------------------------------------------------------------------------------------------------------------------
		INSERT #loss_time_rt_ln_mmly
		select r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,'PROD_OP_RT'				as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,max(r.mm_days)			as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.mm_ssn)			as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.eqp_nbu)			as eqp_nbu
			  ,0						as loss_cnt
			  ,0						as loss_tm_ssn 
			  ,0						as nav_tot_loss_tm
			  ,0						as nld_tot_loss_tm
			  ,0						as nop_tot_loss_tm	
			  --------------------------------
			  ,  convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'LD_RT'		THEN loss_rt ELSE 0.0 END))) 
			   * convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'OP_RT'		THEN loss_rt ELSE 0.0 END))) 
			   * convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'PF_RT'		THEN loss_rt ELSE 0.0 END))) 
			   * convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'QL_RT_LN'	THEN loss_rt ELSE 0.0 END))) AS loss_rt
		 FROM #loss_time_rt_ln_mmly r
		WHERE 1=1
		  AND loss_cd IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT_LN')
		GROUP BY r.company_id
			    ,r.division_id
			    ,r.site_id
			    ,r.plant_id
			    ,r.factory_id
			    ,r.line_id
			    ,r.operation_id
			    ,r.eltr_ln_tp_cd

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_rt_mdl_mmly - - TEEP (라인별) '   -- 20240429 추가
		-------------------------------------------------------------------------------------------------------------------
		--  TEEP : 생산가동률 * 조업률 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #loss_time_rt_ln_mmly
		select r.company_id
			  ,r.division_id
			  ,r.site_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eltr_ln_tp_cd
			  ,'TEEP'					as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,max(r.mm_days)			as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.mm_ssn)			as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.eqp_nbu)			as eqp_nbu
			  ,0						as loss_cnt
			  ,0						as loss_tm_ssn 
			  ,0						as nav_tot_loss_tm
			  ,0						as nld_tot_loss_tm
			  ,0						as nop_tot_loss_tm	
			  --------------------------------
			  ,  convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'PROD_OP_RT'	THEN loss_rt ELSE 0.0 END))) 
			   * convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'AV_RT'			THEN loss_rt ELSE 0.0 END)))	AS	loss_rt
		 FROM #loss_time_rt_ln_mmly r
		WHERE 1=1
		  AND loss_cd IN ('PROD_OP_RT', 'AV_RT')
		GROUP BY r.company_id
			    ,r.division_id
			    ,r.site_id
			    ,r.plant_id
			    ,r.factory_id
			    ,r.line_id
			    ,r.operation_id
			    ,r.eltr_ln_tp_cd

	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적설비별월별집계 DELETE SCM_DNM_LOSS_EQP_MMLY ' 
		----------------------------------------------------------------------------------------------------------
		DELETE TGT
		  FROM SCM_DNM_LOSS_EQP_MMLY TGT WITH(NOLOCK)
		 WHERE LOSS_YM		= @v_loss_ym 
		   AND PERD_DIVS_CD = @v_perd_divs_cd  --- 5/14 추가

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적설비별월별집계 INSERT SCM_DNM_LOSS_EQP_MMLY ' 
		-- 2024.10.15 MMD 지표 예외 정보 적용 (@v_mm_ssn -> mm_ssn 으로 변경) 
		----------------------------------------------------------------------------------------------------------
		 INSERT INTO SCM_DNM_LOSS_EQP_MMLY
			(  LOSS_YM
			  ,PERD_DIVS_CD -- 5/14
			  ,COMPANY_ID
			  ,DIVISION_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,EQP_ID
			  ,ELTR_LN_TP_CD
			  ,LOSS_CD
			  ,LOSS_GR_CD
			  ,LOSS_CNT
			  ,LOSS_TM_SSN  
			  ,LOSS_RT	
			  ,CREATED_BY
			  ,CREATION_DATE
			  ,LAST_UPDATED_BY
			  ,LAST_UPDATE_DATE
			  ,ATTRIBUTE1
			  ,ATTRIBUTE2
			  ,ATTRIBUTE3
			  ,ATTRIBUTE4
			  ) 
		SELECT @V_LOSS_YM
			  ,@V_PERD_DIVS_CD  --- 5/14 
			  ,COMPANY_ID
			  ,DIVISION_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,EQP_ID
			  ,ELTR_LN_TP_CD
			  ,LOSS_CD
			  ,LOSS_GR_CD
			  ,LOSS_CNT
			  ,LOSS_TM_SSN
			  ,LOSS_RT
			  ,@v_program_name
			  ,getdate()
			  ,@v_program_name
			  ,getdate()
			  ,CASE WHEN LOSS_CD = 'AV_RT' OR LOSS_GR_CD = 'NAV'	
					THEN CONVERT(NUMERIC(20,10), mm_days)	-- 2024.10.30 최대가동일수 
					WHEN LOSS_CD = 'OP_RT' 
					THEN CONVERT(NUMERIC(20,10), mm_ssn	)	-- 해당월 초수
					ELSE NULL
				END AS ATTRIBUTE1	
			  ,CASE WHEN LOSS_CD = 'OP_RT' THEN CONVERT(NUMERIC(20,10), NAV_TOT_LOSS_TM	)	ELSE NULL END ATTRIBUTE2	-- 비조업시간
			  ,CASE WHEN LOSS_CD = 'OP_RT' THEN CONVERT(NUMERIC(20,10), NLD_TOT_LOSS_TM	)	ELSE NULL END ATTRIBUTE3	-- 비부하시간
			  ,CASE WHEN LOSS_CD = 'OP_RT' THEN CONVERT(NUMERIC(20,10), NOP_TOT_LOSS_TM	)	ELSE NULL END ATTRIBUTE4	-- 비가동시간
		 FROM #loss_time_rt_eqp_mmly 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적라인별월별집계 DELETE SCM_DNM_LOSS_LN_MMLY ' 
		----------------------------------------------------------------------------------------------------------
		DELETE TGT
		  FROM SCM_DNM_LOSS_LN_MMLY TGT WITH(NOLOCK)
		 WHERE LOSS_YM = @v_loss_ym 
		   AND PERD_DIVS_CD = @v_perd_divs_cd  --- 20240514 추가 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적라인별월별집계 INSERT SCM_DNM_LOSS_LN_MMLY' 
		-- 2024.10.15 MMD 지표 예외 정보 적용 
		-- @v_mm_ssn * EQP_NBU -> mm_ssn 으로 변경
		-- @v_mm_ddn -> mm_days
		----------------------------------------------------------------------------------------------------------
		INSERT INTO SCM_DNM_LOSS_LN_MMLY  
			(  LOSS_YM
			  ,PERD_DIVS_CD -- 5/14 
			  ,COMPANY_ID
			  ,DIVISION_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,LOSS_GR_CD
			  ,LOSS_CD
			  ,EQP_NBU
			  ,LOSS_CNT
			  ,LOSS_TM_SSN
			  ,LOSS_RT	
			  ,CREATED_BY
			  ,CREATION_DATE
			  ,LAST_UPDATED_BY
			  ,LAST_UPDATE_DATE
			  ,ATTRIBUTE1
			  ,ATTRIBUTE2
			  ,ATTRIBUTE3
			  ,ATTRIBUTE4
			  )
		SELECT @V_LOSS_YM
			  ,@V_PERD_DIVS_CD  -- 5/14 추가 
			  ,COMPANY_ID
			  ,DIVISION_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,LOSS_GR_CD
			  ,LOSS_CD
			  ,EQP_NBU
			  ,LOSS_CNT
			  ,LOSS_TM_SSN
			  ,LOSS_RT	
			  ,@v_program_name
			  ,GETDATE()
			  ,@v_program_name
			  ,GETDATE()
			  ,CASE WHEN LOSS_CD = 'OP_RT'							THEN CONVERT(NUMERIC(20,10), mm_ssn		)	-- 장비수량반영 해당월 초수
					WHEN LOSS_CD = 'AV_RT' OR LOSS_GR_CD = 'NAV'	THEN CONVERT(NUMERIC(20,10), convert(float,mm_days) 
																								/ convert(float, case when EQP_NBU = 0 
																													  then null 
																													  else EQP_NBU 
																													  end)	)	-- 최대조업일수 (설비 1대당)  
					ELSE NULL
				END AS ATTRIBUTE1	
			  ,CASE WHEN LOSS_CD = 'OP_RT' THEN CONVERT(NUMERIC(20,10), NAV_TOT_LOSS_TM)		ELSE NULL END ATTRIBUTE2	-- 비조업시간
			  ,CASE WHEN LOSS_CD = 'OP_RT' THEN CONVERT(NUMERIC(20,10), NLD_TOT_LOSS_TM)		ELSE NULL END ATTRIBUTE3	-- 비부하시간
			  ,CASE WHEN LOSS_CD = 'OP_RT' THEN CONVERT(NUMERIC(20,10), NOP_TOT_LOSS_TM)		ELSE NULL END ATTRIBUTE4	-- 비가동시간
		  FROM #loss_time_rt_ln_mmly

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적모델별월별집계 DELETE SCM_DNM_LOSS_MDL_MMLY ' 
		----------------------------------------------------------------------------------------------------------
		DELETE TGT
		  FROM SCM_DNM_LOSS_MDL_MMLY TGT WITH(NOLOCK)
		 WHERE LOSS_YM		= @v_loss_ym 
		   AND PERD_DIVS_CD = @v_perd_divs_cd  --- 20240514 추가 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적모델별월별집계 INSERT SCM_DNM_LOSS_MDL_MMLY' 
		----------------------------------------------------------------------------------------------------------
		INSERT INTO SCM_DNM_LOSS_MDL_MMLY
			(  LOSS_YM
			  ,PERD_DIVS_CD  -- 5/14 
			  ,MDL_NM
			  ,COMPANY_ID
			  ,DIVISION_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,LOSS_CD
			  ,LOSS_RT	
			  ,CREATED_BY
			  ,CREATION_DATE
			  ,LAST_UPDATED_BY
			  ,LAST_UPDATE_DATE
			  )
		SELECT @V_LOSS_YM
			  ,@V_PERD_DIVS_CD  -- 5/14 
			  ,MDL_NM
			  ,COMPANY_ID
			  ,DIVISION_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,LOSS_CD
			  ,LOSS_RT	
			  ,@v_program_name
			  ,GETDATE()
			  ,@v_program_name
			  ,GETDATE()
		  FROM #loss_rt_mdl_mmly

		
	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

		---------------------------------------
		---- 임시테이블 정리
		-----------------------------------------
		if object_id('tempdb..#LOSS_CODE') is not null drop table #LOSS_CODE
		if object_id('tempdb..#OPERATION_ELECTRODE_TYPE_MAPPING') is not null drop table #OPERATION_ELECTRODE_TYPE_MAPPING;
		if object_id('tempdb..#EQUIPMENT_PRODUCT_LEVEL3_CODE') is not null drop table #EQUIPMENT_PRODUCT_LEVEL3_CODE;
		if object_id('tempdb..#SCM_MST_EQUIPMENT_SN') is not null drop table #SCM_MST_EQUIPMENT_SN
		if object_id('tempdb..#LOSS_TIME_RAW_DATA') is not null drop table #LOSS_TIME_RAW_DATA
		if object_id('tempdb..#LOSS_TIME_R_EQP_MMLY') is not null drop table #LOSS_TIME_R_EQP_MMLY
		if object_id('tempdb..#LOSS_TIME_RT_EQP_MMLY') is not null drop table #LOSS_TIME_RT_EQP_MMLY 
		if object_id('tempdb..#loss_time_r_ln_mmly') is not null drop table #loss_time_r_ln_mmly
		if object_id('tempdb..#loss_time_rt_ln_mmly') is not null drop table #loss_time_rt_ln_mmly
		if object_id('tempdb..#SCP_MST_ITEM_BSI_IFO') is not null drop table #SCP_MST_ITEM_BSI_IFO;
		if object_id('tempdb..#SCP_MST_ITEM_CELL_CF') is not null drop table #SCP_MST_ITEM_CELL_CF;
		if object_id('tempdb..#PRD_INPUT_EQP_R') is not null drop table #PRD_INPUT_EQP_R
		if object_id('tempdb..#PRD_INPUT_CELL_CONVERT_R') is not null drop table #PRD_INPUT_CELL_CONVERT_R
		if object_id('tempdb..#PROD_INPUT_RESULT') is not null drop table #PROD_INPUT_RESULT
		if object_id('tempdb..#PROD_INPUT_RESULT_LN') is not null drop table #PROD_INPUT_RESULT_LN
		if object_id('tempdb..#SCP_MST_MDL_EQP_SPED') is not null drop table #SCP_MST_MDL_EQP_SPED
		if object_id('tempdb..#loss_rt_mdl_mmly') is not null drop table #loss_rt_mdl_mmly

	  END			    
	END TRY

	BEGIN CATCH                  
		if (xact_state() <> 0) ROLLBACK TRAN; 

		-- ERROR LOG                  
		SET @v_log_type = N'ERROR';                  
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		SET @d_event_date = SYSDATETIME();                  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                  
		                          ,@p_log_type      = @v_log_type                  
		                          ,@p_log_count     = @n_log_count                   
		                          ,@p_log_message   = @v_log_message                   
		                          ,@p_description   = @v_description                   
		                          ,@p_event_date    = @d_event_date                   
		                          ,@p_user_id       = @v_batch_user                  
		                          ;                  
		 PRINT @v_log_message      + ' : ' + @v_description ;  
		 RETURN -1;    
		
    END CATCH;   

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'##### END of procedure #####';                  
    SET @v_description = N'[81,82,JV][loss_ym='+ @v_loss_ym +'][p_perd_divs_cd='+converT(nvarchar(10), @p_perd_divs_cd)+']['  + @v_exec_time + ']';  ;            
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
	PRINT @v_log_message      + ' : ' + @v_description ;          
	RETURN 1;    

END
