



/*  
 * Program ID   : PR_SCM_DNM_ELTR_LOSS_MMLY
 * Description  : SCP Capa 전극 월별 LOSS 실적 적재
 *
 *				 - Source : XIF_DW_RECEIVE_LOSS_TIME_R_SN	(DW LOSS실적) 		
 *							SCM_MST_EQUIPMENT_SN			(설비Master)
 *							SCM_ADM_LOOKUP_MASTER_DETAIL
 *							SCM_MST_FACTORY_SN
 *							SCM_MST_DIVISION
 *							SCP_MST_MMD_KPI_EXCT			(MMD 지표 예외 정보) 
 *
 * 				 - Target : SCM_DNM_ELTR_LOSS_EQP_MMLY (전극 설비별)
 *				            SCM_DNM_ELTR_LOSS_LN_MMLY  (전극 라인별)
 *
 *				 - 전극 모델에 대한 모델에 대한 실적만 대상으로 함
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.05.29	hrkim		Initial Release PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 
 * 2024.06.03	hrkim		FP Line기준 적재 (DW 실적은 MES line 기준 ?) 
 * 2024.07.05	hrkim		양품가동률/성능가동률 폭환산자 적용 로직 변경 (투입수량 및 양품 수량에 반영) 
 * 2024.07.05	hrkim		성능가동률 산식 변경
 *							- 변경전 : 설계속도(MMD속도) / 생산 평균 속도 (m/min)
 *							- 변경후 : 생산 평균 속도 (m/min) / 설계속도(MMD속도) 
 * 2024.07.08	hrkim		폭환산자 적용 로직 정리 (수량에 적용)  
 * 2024.07.10	hrkim		전극 테이블 PK 변경 : ELTR_LN_TP_CD 컬럼 PK컬럼에서 제외
 * 2024.07.15	hrkim		라인별 성능가동시간/양품가동시간 추가 
 * 2024.08.14	hrkim		양품가동률 적재 기준 변경 
 *							- 변경전 : OUT_GOOD_QTY / OUT_INPUT_QTY
 *							- 변경후 : OUT_GOOD_QTY / (OUT_DEFECT_QTY + OUT_GOOD_QTY)
 * 2024.10.25	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : MMD 지표 예외 정보 적용
 * 2024.10.28	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : MMD 지표 예외 정보 참조시 FP 라인 기준 참조
 * 2024.10.30	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 설비별 loss 최대조업일수 정보 추가 (조업률.attribute1) 
 * 2024.11.04	hrkim		PJ20239037 LGES CPS VOE 반영 및 고도화 : 성능가동률 100%으로 적재 (PI 변상현 책임)
 * 2025.03.21	hrkim		(NERP)DW 데이터 plant 조인 컬럼 변경 (plant_id -> mes_plant_id) 
 * 2025.03.24	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 *
*/  


CREATE PROCEDURE [dbo].[PR_SCM_DNM_ELTR_LOSS_MMLY]
	 @p_loss_ym		        varchar(6)	= NULL 
	,@p_perd_divs_cd		tinyint		= 1		-- 기간구분코드 (1:1개월, 3:3개월) 
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_ELTR_LOSS_MMLY'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

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
		  AND LOOKUP_TYPE	= 'SCP_CAPA_ELTR_LOSS_MEASURE'   -- 전극 measure
		  AND VALID_YN		= 'Y'
		order by SEQ

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### FP 설비 Master - #SCM_MST_EQUIPMENT_SN' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_MST_EQUIPMENT_SN') is not null drop table #SCM_MST_EQUIPMENT_SN

		SELECT EM.DIVISION_ID
			  ,EM.COMPANY_ID
			  ,EM.SITE_ID
			  ,EM.PLANT_ID
			  ,EM.FACTORY_ID
			  ,EM.EQUIPMENT_ID
			  ,EM.OPERATION_ID
			  ,EM.ELECTRODE_TYPE 
			  ,EM.MES_LINE_ID
			  ,EM.LINE_ID
			  ,CASE WHEN EM.WIDE_ROLL_ENABLE_FLAG = 'Y' THEN 'W' ELSE 'S' END AS ELTR_LN_TP_CD	-- W:Wide, S:Standard
			  ,FM.MES_PLANT_ID	-- 2025.03.21 
		 INTO #SCM_MST_EQUIPMENT_SN 
		 FROM SCM_MST_EQUIPMENT_SN   EM   WITH(NOLOCK)
			  INNER JOIN SCM_MST_FACTORY_SN FM WITH(NOLOCK) -- 2025.03.21
					  ON FM.COMPANY_ID	= EM.COMPANY_ID
					 AND FM.FACTORY_ID	= EM.FACTORY_ID
		WHERE 1=1
		  -- 2025.03.24 소형 확산 AND EM.DIVISION_ID	!= '40'		-- 소형제외
		  AND EM.EQUIPMENT_TYPE  = 'M'		-- Main 설비
		  AND EM.ACTIVE_FLAG	 = 'Y' 
		  AND EM.OPERATION_ID   LIKE 'E2000%'	-- 전극 Coating

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
			  ,R.WORK_DATE  -- 5/31 
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
		  AND R.PROCESS_ID like 'E2000%' -- 전극 Coating 

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
			  INNER JOIN #scm_mst_equipment_sn e with(nolock) 
					  ON E.site_id		= R.site_id
					 AND E.mes_plant_id	= R.plant_id	-- 2025.03.21 mes_plant_id join 참조 (변경전 e.plant_id)
					 AND E.factory_id	= R.factory_id
					 AND E.equipment_id	= R.eqp_id
					 AND E.operation_id	= R.operation_id
		WHERE 1=1
		  AND EXISTS (SELECT TOP 1 * -- 2024.10.17 MMD 지표예외 대상 제외 
						FROM #SCP_MST_MMD_KPI_EXCT KE
					   WHERE 1=1
						 AND (KE.EQP_ID = R.EQP_ID OR KE.EQP_ID = 'ALL')
						 AND KE.FACTORY_ID		= R.FACTORY_ID
						 AND KE.LINE_ID			= E.LINE_ID		-- 2024.10.28 실적이 아닌 FP 라인 기준 참조 
						 AND KE.OPERATION_ID	= R.OPERATION_ID
						 AND R.WORK_DATE BETWEEN KE.FROM_DATE 
											 AND KE.TO_DATE
						 )

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 설비별 생산 투입 실적 - #PRD_INPUT_ITEM_R - 품목별' 
		--	 2024.07.08 수정 폭환산자 반영 : Wide 의 경우 * 1/2 를 해준다 
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PRD_INPUT_ITEM_R') is not null drop table #PRD_INPUT_ITEM_R

		SELECT E.DIVISION_ID
			  ,E.COMPANY_ID
			  ,R.SITE_ID
			  ,E.PLANT_ID					-- 2025.03.21 plant 참조 변경 (r.plant_id -> e.plant_id) 
			  ,R.AREA_ID					AS FACTORY_ID
			  ,E.LINE_ID					-- FP 라인ID (MES_LINE_ID 다를 수 있음)  
			  ,R.PROCESS_ID					AS OPERATION_ID
			  ,R.EQPT_ID					AS EQP_ID
			  ,MAX(E.ELTR_LN_TP_CD)			AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외 
			  ,R.PRODUCT_ID					AS ITEM_ID 
			  ,CONVERT(FLOAT, CONVERT(FLOAT, SUM(R.OUT_INPUT_QTY))	/ CONVERT(FLOAT,CASE WHEN MAX(E.ELTR_LN_TP_CD) = 'W' THEN 2 ELSE 1 END) )  	AS OUT_INPUT_QTY	-- 투입수량 (m)	 7/8 폭환산자 적용
			  ,CONVERT(FLOAT, CONVERT(FLOAT, SUM(R.OUT_GOOD_QTY ))	/ CONVERT(FLOAT,CASE WHEN MAX(E.ELTR_LN_TP_CD) = 'W' THEN 2 ELSE 1 END) ) 	AS OUT_GOOD_QTY		-- 생산수량 (m)	 7/8 폭환산자 적용
			  ,CONVERT(FLOAT, CONVERT(FLOAT, SUM(R.OUT_DEFECT_QTY)) / CONVERT(FLOAT,CASE WHEN MAX(E.ELTR_LN_TP_CD) = 'W' THEN 2 ELSE 1 END) ) 	AS OUT_DEFECT_QTY	-- 불량수량 (m)	 2024.08.14 추가
		 INTO #PRD_INPUT_ITEM_R		
		 FROM SCM_DNM_INPT_PRDN_DDLY R with(nolock) 
			  INNER JOIN #SCM_MST_EQUIPMENT_SN E
					  ON E.SITE_ID		= R.SITE_ID
					 AND E.MES_PLANT_ID	= R.PLANT_ID	-- 2025.03.21 join 컬럼 변경 (PLANT_ID -> MES_PLANT_ID) 
					 AND E.FACTORY_ID	= R.AREA_ID
					 AND E.EQUIPMENT_ID = R.EQPT_ID
					 AND E.OPERATION_ID = R.PROCESS_ID
		WHERE 1=1
		  AND R.CAL_YMD_ID BETWEEN @v_loss_from_ymd
							   AND @v_loss_to_ymd
		  AND R.LOT_TYPE_ID IN ('P', 'R', 'H', 'S', 'Y', 'B')	-- FP YLD 대상 조건에 'B' 추가
		  AND R.PROCESS_ID  LIKE 'E2000%'						-- 전극 Coating 
		  AND R.OUT_INPUT_QTY != 0 
		GROUP BY E.DIVISION_ID
			    ,E.COMPANY_ID
			    ,R.SITE_ID
			    ,E.PLANT_ID					-- 2025.03.21 plant 참조 변경 (r.plant_id -> e.plant_id) 
				,R.AREA_ID		
				,E.LINE_ID
				,R.PROCESS_ID
				,R.EQPT_ID	
				,R.PRODUCT_ID 

		---------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 생산 투입 실적  #PRD_INPUT_ITEM_R : 대상 LOSS 실적이 없는 데이터 삭제' 
		-- 2025.03.26 지표 예외로 대상에서 제외된 LOSS 실적등 불필요한 투입실적 참조 삭제 
		---------------------------------------------------------------------------------------------------------------------------
		CREATE INDEX LOSS_IDX_1 on  #LOSS_TIME_RAW_DATA (LINE_ID, OPERATION_ID, FACTORY_ID) ;
		
		DELETE I 
		  FROM #PRD_INPUT_ITEM_R I
		WHERE 1=1
		  AND NOT EXISTS (SELECT 'X'
							FROM #LOSS_TIME_RAW_DATA L
						   WHERE 1=1
						     AND L.LINE_ID		= I.LINE_ID
							 AND L.OPERATION_ID = I.OPERATION_ID
							 AND L.FACTORY_ID	= I.FACTORY_ID
							 ) 

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 라인별 생산 투입 실적 - #PRD_INPUT_LN_R - 라인별 ' 
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PRD_INPUT_LN_R') is not null drop table #PRD_INPUT_LN_R

		SELECT R.DIVISION_ID
			  ,R.COMPANY_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID 
			  ,R.OPERATION_ID
			  ,MAX(R.ELTR_LN_TP_CD)								AS ELTR_LN_TP_CD -- 7/10 PK컬럼에서 제외 
			  ,COUNT(DISTINCT R.EQP_ID)							AS EQP_NBU
			  ,CONVERT(FLOAT, ISNULL(SUM(R.OUT_INPUT_QTY),0) )	AS OUT_INPUT_QTY
			  ,CONVERT(FLOAT, ISNULL(SUM(R.OUT_GOOD_QTY ),0) )	AS OUT_GOOD_QTY
			  ,CONVERT(FLOAT, ISNULL(SUM(R.OUT_DEFECT_QTY),0))	AS OUT_DEFECT_QTY
		 INTO #PRD_INPUT_LN_R
		 FROM #PRD_INPUT_ITEM_R R WITH(NOLOCK) 
		GROUP BY R.DIVISION_ID
			  ,R.COMPANY_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID 
			  ,R.OPERATION_ID

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### MMD 설계속도 - #MMD_ITEM_EQP_SPED - 품목ID/설비별' 
		----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#MMD_ITEM_EQP_SPED') IS NOT NULL DROP TABLE #MMD_ITEM_EQP_SPED;

		SELECT EM.DIVISION_ID
			  ,EM.SITE_ID
			  ,EM.COMPANY_ID
			  ,EM.PLANT_ID
			  ,EM.FACTORY_ID
			  ,EM.LINE_ID					-- FP 라인 ID 
			  ,EM.OPERATION_ID
			  ,ES.BOM_ITEM_ID				AS ITEM_ID 
			  ,ES.EQP_ID
			  ,EM.ELTR_LN_TP_CD
			  ,CONVERT(FLOAT, ES.EQP_SPED)	AS EQP_SPED
		 INTO #MMD_ITEM_EQP_SPED
		 FROM #SCM_MST_EQUIPMENT_SN EM WITH(NOLOCK)
			  INNER JOIN SCM_MMD_EQPT_PRDT_SPEED_SN ES WITH(NOLOCK)
					  ON ES.EQP_ID = EM.EQUIPMENT_ID
		WHERE 1=1
		  AND ES.EQP_SPED IS NOT NULL
		;

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### Loss Time 설비별 집계 - #LOSS_TIME_R_EQP_MMLY' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#LOSS_TIME_R_EQP_MMLY') is not null drop table #LOSS_TIME_R_EQP_MMLY

		 select e.division_id
			   ,e.site_id
			   ,e.company_id
			   ,e.plant_id					-- 2025.03.21 plant 참조 변경 (r.plant_id -> e.plant_id) 
			   ,r.factory_id
			   ,e.line_id		-- 6/3 FP 설비 Master 라인 기준 적재 
			   ,r.operation_id
			   ,r.eqp_id
			   ,max(e.ELTR_LN_TP_CD	)										as ELTR_LN_TP_CD -- 7/10 PK 컬럼에서 제외  
			   ,convert(nvarchar(30), r.loss_cd)							as loss_cd 
			   ,r.loss_gr_cd
			   ,convert(float, count(distinct r.work_date))					as mm_days  -- 2024.10.15 추가 for MMD 지표 예외 정보 적용 
			   ,convert(float, count(distinct r.work_date)*@v_dd_ssn)		as mm_ssn	-- 2024.10.15 추가 for MMD 지표 예외 정보 적용 
			   ,convert(float, sum(loss_time))								as loss_tm_ssn 
			   ,convert(float, sum(case when r.loss_gr_cd = 'NAV' then convert(float, sum(loss_time)) else 0 end) 
						over (partition by e.division_id, e.site_id, e.company_id, e.plant_id,  r.factory_id, e.line_id, r.operation_id, r.eqp_id /* 7/10 PK 변경, e.ELTR_LN_TP_CD*/)) as nav_tot_loss_tm  -- 비조업
			   ,convert(float, sum(case when r.loss_gr_cd = 'NLD' then convert(float, sum(loss_time)) else 0 end) 								 				
						over (partition by e.division_id, e.site_id, e.company_id, e.plant_id,  r.factory_id, e.line_id, r.operation_id, r.eqp_id /* 7/10 PK 변경, e.ELTR_LN_TP_CD*/)) as nld_tot_loss_tm   -- 비부하
			   ,convert(float, sum(case when r.loss_gr_cd = 'NOP' then convert(float, sum(loss_time)) else 0 end) 													
						over (partition by e.division_id, e.site_id, e.company_id, e.plant_id,  r.factory_id, e.line_id, r.operation_id, r.eqp_id /* 7/10 PK 변경, e.ELTR_LN_TP_CD*/)) as nop_tot_loss_tm  -- 비가동
		 INTO #LOSS_TIME_R_EQP_MMLY 
		 FROM #LOSS_TIME_RAW_DATA R 
			  INNER JOIN #scm_mst_equipment_sn e with(nolock) 
					  ON E.site_id		= R.site_id
					 AND E.mes_plant_id	= R.plant_id	-- 2025.03.21 컬럼 변경 (plant_id -> mes_plant_id) 
					 AND E.factory_id	= R.factory_id
					 AND E.equipment_id	= R.eqp_id
					 AND E.operation_id	= R.operation_id
		WHERE R.RN = 1
		group by e.division_id
			    ,e.site_id
			    ,e.company_id
			    ,e.plant_id					-- 2025.03.21 plant 참조 변경 (r.plant_id -> e.plant_id) 
			    ,r.factory_id
			    ,e.line_id		-- 6/3 FP 설비 Master 라인 기준 적재 
			    ,r.operation_id
			    ,r.eqp_id
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
			   case when loss_gr_cd = 'NAV'		/* 비조업 */																	then loss_tm_ssn /  mm_ssn 
					when loss_gr_cd = 'NLD' and mm_ssn  = nav_tot_loss_tm														then 0
					when loss_gr_cd = 'NLD'		/* 비부하 */																	then loss_tm_ssn / convert(float, (mm_ssn - nav_tot_loss_tm)) 
					when loss_gr_cd = 'NOP' and mm_ssn  = nav_tot_loss_tm + nld_tot_loss_tm										then 0 
					when loss_gr_cd = 'NOP'		/* 비가동 */																	then loss_tm_ssn / convert(float, (mm_ssn - nav_tot_loss_tm - nld_tot_loss_tm))
			   end	)	as loss_rt 
		into #LOSS_TIME_RT_EQP_MMLY 
		from #LOSS_TIME_R_EQP_MMLY
		where 1=1

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_r_ln_mmly (라인별집계)' 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#loss_time_r_ln_mmly') is not null drop table #loss_time_r_ln_mmly

		 select r.division_id
			   ,r.site_id     
			   ,r.company_id
			   ,r.plant_id
			   ,r.factory_id
			   ,r.line_id
			   ,r.operation_id
			   ,r.loss_cd
			   ,r.loss_gr_cd
			   ,sum(r.mm_days)								as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용   (설비대수 반영된 정보로 max가 아닌 sum)
			   ,sum(r.mm_ssn)								as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용   (설비대수 반영된 정보로 max가 아닌 sum)
			   ,max(r.ELTR_LN_TP_CD	)						as ELTR_LN_TP_CD -- 7/10 PK 컬럼에서 제외  
			   ,convert(float, count(distinct r.eqp_id))	as eqp_nbu 
			   ,convert(float, sum(loss_tm_ssn))			as loss_tm_ssn 
			   ,convert(float, sum(case when r.loss_gr_cd = 'NAV' then convert(float, sum(loss_tm_ssn)) else 0 end) 
						over (partition by  r.division_id, r.site_id, r.company_id, r.plant_id, r.factory_id, r.line_id, r.operation_id  /* 7/10 PK변경 ,r.ELTR_LN_TP_CD*/ ))		as nav_tot_loss_tm	-- 비조업
			   ,convert(float, sum(case when r.loss_gr_cd = 'NLD' then convert(float, sum(loss_tm_ssn)) else 0 end) 					 /* 7/10 PK변경				*/ 
						over (partition by  r.division_id, r.site_id, r.company_id, r.plant_id, r.factory_id, r.line_id, r.operation_id  /* 7/10 PK변경 ,r.ELTR_LN_TP_CD*/ ))		as nld_tot_loss_tm	-- 비부하
			   ,convert(float, sum(case when r.loss_gr_cd = 'NOP' then convert(float, sum(loss_tm_ssn)) else 0 end) 					 /* 7/10 PK변경				*/ 
						over (partition by  r.division_id, r.site_id, r.company_id, r.plant_id, r.factory_id, r.line_id, r.operation_id  /* 7/10 PK변경 ,r.ELTR_LN_TP_CD*/ ))		as nop_tot_loss_tm	-- 비가동
		 into #loss_time_r_ln_mmly 
		 from #loss_time_r_eqp_mmly r 
		group by r.division_id
			   ,r.site_id
			   ,r.company_id
			   ,r.plant_id
			   ,r.factory_id
			   ,r.line_id
			   ,r.operation_id
			   ,r.loss_cd
			   ,r.loss_gr_cd

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_rt_ln_mmly (라인별집계-loss율계산)' 
		-- 비조업 분모   : 해당월total시간(s) * 장비수 
		-- 비부하 분모   : 해당월total시간(s) * 장비수 - 비조업합계(s)
		-- 비가동 분모   : 해당월total시간(s) * 장비수 - 비조업합계(s) - 비부하합계(s)
		-- 2024.10.15 MMD 지표 예외 정보 적용 (@v_mm_ssn * eqp_nbu -> mm_ssn(설비대수 반영된 값)으로 변경) 
		---------------------------------------------------------------------------------------------------
		if object_id('tempdb..#loss_time_rt_ln_mmly') is not null drop table #loss_time_rt_ln_mmly

		select *
			  ,convert(numeric(20,10),
			   case when loss_gr_cd = 'NAV'		/* 비조업 */																	then loss_tm_ssn / (convert(float, mm_ssn)) 
					when loss_gr_cd = 'NLD'		and convert(float, mm_ssn) = nav_tot_loss_tm									then 0
					when loss_gr_cd = 'NLD'		/* 비부하 */																	then loss_tm_ssn / (convert(float, mm_ssn) - nav_tot_loss_tm) 
					when loss_gr_cd = 'NOP'		and convert(float, mm_ssn) = nav_tot_loss_tm + nld_tot_loss_tm					then 0 
					when loss_gr_cd = 'NOP'		/* 비가동 */																	then loss_tm_ssn / (convert(float, mm_ssn) - nav_tot_loss_tm - nld_tot_loss_tm) 
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
		select r.division_id
			  ,r.site_id
			  ,r.company_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.eqp_id
			   ,max(r.ELTR_LN_TP_CD	)												as ELTR_LN_TP_CD -- 7/10 PK 컬럼에서 제외  
			  ,case when loss_gr_cd = 'NAV' then 'AV_RT'
					when loss_gr_cd = 'NLD' then 'LD_RT'
					when loss_gr_cd = 'NOP' then 'OP_RT'
				end						as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,max(r.mm_days)			as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.mm_ssn)			as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
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
		group by r.division_id
			  ,r.site_id
			  ,r.company_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
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
		select r.division_id
			  ,r.site_id
			  ,r.company_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,case when loss_gr_cd = 'NAV' then 'AV_RT'
					when loss_gr_cd = 'NLD' then 'LD_RT'
					when loss_gr_cd = 'NOP' then 'OP_RT'
				end						as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,max(r.mm_days)			as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.mm_ssn)			as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.ELTR_LN_TP_CD	)												as ELTR_LN_TP_CD -- 7/10 PK 컬럼에서 제외  
			  ,r.eqp_nbu
			  -- 2024.10.15 변경 : 이미 설비 대수 반영된 값 - 조업:비조업 = 1 : N이라 max로 반영 
			  ,case when loss_gr_cd = 'NAV' then convert(float, max(r.mm_ssn)) - max(nav_tot_loss_tm)													-- 조업시간(초)
					when loss_gr_cd = 'NLD' then convert(float, max(r.mm_ssn)) - max(nav_tot_loss_tm) - max(nld_tot_loss_tm)							-- 부하시간(초)
					when loss_gr_cd = 'NOP' then convert(float, max(r.mm_ssn)) - max(nav_tot_loss_tm) - max(nld_tot_loss_tm) - max(nop_tot_loss_tm)		-- 가동시간(초)
					else 0
				end																	as loss_tm_ssn 
			  ,	max(nav_tot_loss_tm)												as nav_tot_loss_tm
			  ,	max(nld_tot_loss_tm)												as nld_tot_loss_tm
			  , max(nop_tot_loss_tm)												as nop_tot_loss_tm
			  , convert(float, 1)  - convert(float, sum(convert(float, loss_rt)))	as loss_rt 
		from #loss_time_rt_ln_mmly r
		where 1=1
		  and r.loss_gr_cd in ('NAV', 'NLD', 'NOP') 
		group by r.division_id
			  ,r.site_id
			  ,r.company_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,r.loss_gr_cd
			  ,r.eqp_nbu

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_rt_ln_mmly - 평균 생산속도 (라인별) ' 
		--  생산 평균 속도 : (투입수량 (m) - 폭환산자 적용된 값) / 시간가동시간 (분)
		-----------------------------------------------------------------------------------------------------------------------
		INSERT INTO #loss_time_rt_ln_mmly
		SELECT LS.DIVISION_ID
			  ,LS.SITE_ID
			  ,LS.COMPANY_ID
			  ,LS.PLANT_ID
			  ,LS.FACTORY_ID
			  ,LS.LINE_ID
			  ,LS.OPERATION_ID
			  ,'PROD_AVG_SPED'			AS LOSS_CD
			  ,'-'						AS LOSS_GR_CD
			  ,LS.mm_days				AS mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,LS.mm_ssn				AS mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,LS.ELTR_LN_TP_CD	
			  ,LS.EQP_NBU	
			  ,0						AS LOSS_TM_SSN
			  ,0						AS NAV_TOT_LOSS_TM
			  ,0						AS NLD_TOT_LOSS_TM
			  ,0						AS NOP_TOT_LOSS_TM
			  ,CASE WHEN ISNULL(LS.LOSS_TM_SSN, 0)  = 0 
					THEN 0 
					ELSE  R.OUT_INPUT_QTY
							/ CONVERT(FLOAT, (LS.LOSS_TM_SSN / CONVERT(FLOAT, 60)))
				END						AS LOSS_RT 
		from #loss_time_rt_ln_mmly ls
			 LEFT JOIN #PRD_INPUT_LN_R R
					ON R.DIVISION_ID	= LS.DIVISION_ID
				   AND R.COMPANY_ID		= LS.COMPANY_ID
				   AND R.SITE_ID		= LS.SITE_ID
				   AND R.PLANT_ID		= LS.PLANT_ID
				   AND R.FACTORY_ID		= LS.FACTORY_ID
				   AND R.LINE_ID		= LS.LINE_ID
				   AND R.OPERATION_ID	= LS.OPERATION_ID
				   -- 7/10 PK컬럼에서 제외 AND R.ELTR_LN_TP_CD	= LS.ELTR_LN_TP_CD
		where 1=1
		  and ls.loss_cd = 'OP_RT'		-- 시간가동시간 (loss_tm_ssn(초) / 60 )

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_rt_ln_mmly - MMD 설계속도 (라인별) ' 
		-- MMD 설계속도  : SUM(품목별 MMD 설계속도 * 투입수량 (m)) / SUM(투입수량 (m))
		-----------------------------------------------------------------------------------------------------------------------
		INSERT INTO #loss_time_rt_ln_mmly
		SELECT M.DIVISION_ID
			  ,M.SITE_ID
			  ,M.COMPANY_ID
			  ,M.PLANT_ID
			  ,M.FACTORY_ID
			  ,M.LINE_ID
			  ,M.OPERATION_ID
			  ,'MMD_SPED'							AS LOSS_CD
			  ,'-'									AS LOSS_GR_CD
			  ,NULL									AS MM_DAYS
			  ,NULL									AS MM_DDN
			  ,MAX(M.ELTR_LN_TP_CD)					AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외
			  ,COUNT(DISTINCT M.EQP_ID)				AS EQP_NBU	
			  ,0									AS LOSS_TM_SSN
			  ,0									AS NAV_TOT_LOSS_TM
			  ,0									AS NLD_TOT_LOSS_TM
			  ,0									AS NOP_TOT_LOSS_TM
			  ,CASE WHEN SUM(R.OUT_INPUT_QTY) = 0
					THEN 0
					ELSE CONVERT(FLOAT, SUM(M.EQP_SPED * R.OUT_INPUT_QTY)) / CONVERT(FLOAT, SUM(R.OUT_INPUT_QTY))
				END									AS LOSS_RT -- MMD 속도 (설계속도) 
		 FROM #MMD_ITEM_EQP_SPED M 
			  INNER JOIN #PRD_INPUT_ITEM_R R
					  ON R.DIVISION_ID		= M.DIVISION_ID
					 AND R.SITE_ID			= M.SITE_ID
					 AND R.COMPANY_ID		= M.COMPANY_ID
					 AND R.PLANT_ID			= M.PLANT_ID
					 AND R.FACTORY_ID		= M.FACTORY_ID
					 AND R.LINE_ID			= M.LINE_ID
					 AND R.OPERATION_ID		= M.OPERATION_ID
					 AND R.ITEM_ID			= M.ITEM_ID
					 AND R.EQP_ID			= M.EQP_ID
		WHERE 1=1
		GROUP BY M.DIVISION_ID
			    ,M.SITE_ID
			    ,M.COMPANY_ID
			    ,M.PLANT_ID
			    ,M.FACTORY_ID
			    ,M.LINE_ID
			    ,M.OPERATION_ID

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_rt_ln_mmly - 성능가동률 (라인별) ' 
		-- 성능가동률 = 생산 평균 속도 (m/min) / 설계속도(MMD속도) 
		-- 2024.11.04 성능가동률 100%으로 적재 
		-----------------------------------------------------------------------------------------------------------------------
		INSERT INTO #loss_time_rt_ln_mmly
		SELECT LS.DIVISION_ID
			  ,LS.SITE_ID
			  ,LS.COMPANY_ID
			  ,LS.PLANT_ID
			  ,LS.FACTORY_ID
			  ,LS.LINE_ID
			  ,LS.OPERATION_ID
			  ,'PF_RT'					AS LOSS_CD
			  ,'-'						AS LOSS_GR_CD
			  ,LS.mm_days				AS mm_days			-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,LS.mm_ssn				AS mm_ssn			-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,LS.ELTR_LN_TP_CD			AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외
			  ,LS.EQP_NBU				AS EQP_NBU			-- 20240715 변경 
			  ,LS.LOSS_TM_SSN			AS LOSS_TM_SSN		-- 성능가동률 100% (성능가동시간 = 시간가동시간)  
			  ,0						AS NAV_TOT_LOSS_TM
			  ,0						AS NLD_TOT_LOSS_TM
			  ,0						AS NOP_TOT_LOSS_TM
			  ,1.0						AS LOSS_RT			-- 성능가동률 100% 
		from #loss_time_rt_ln_mmly ls
		where 1=1
		  AND ls.loss_cd = 'OP_RT' -- 시간가동률 
		/* 2024.11.04 성능가동률 100으로 적재 변경전 소스 
		SELECT LS.DIVISION_ID
			  ,LS.SITE_ID
			  ,LS.COMPANY_ID
			  ,LS.PLANT_ID
			  ,LS.FACTORY_ID
			  ,LS.LINE_ID
			  ,LS.OPERATION_ID
			  ,'PF_RT'					AS LOSS_CD
			  ,'-'						AS LOSS_GR_CD
			  ,MAX(LS.mm_days)			AS mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,MAX(LS.mm_ssn)			AS mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,MAX(LS.ELTR_LN_TP_CD)	AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외
			  ,MAX(CASE WHEN LS.LOSS_CD IN  ('MMD_SPED', 'PROD_AVG_SPED')
						THEN LS.EQP_NBU 
						ELSE NULL 
					END)				AS EQP_NBU			-- 20240715 변경 
			  ,CASE WHEN MAX(CASE WHEN LS.LOSS_CD = 'MMD_SPED' THEN LS.LOSS_RT  ELSE NULL END)  = 0
					THEN 0
					ELSE CONVERT(FLOAT, CONVERT(NUMERIC(20,10),
							   CONVERT(FLOAT, MAX(CASE WHEN LS.LOSS_CD = 'PROD_AVG_SPED'	THEN LS.LOSS_RT ELSE NULL END)) 
							 / CONVERT(FLOAT, MAX(CASE WHEN LS.LOSS_CD = 'MMD_SPED'			THEN LS.LOSS_RT ELSE NULL END))
							 ))																									-- 성능가동률 
							 * CONVERT(FLOAT, MAX(CASE WHEN LS.LOSS_CD = 'OP_RT'			THEN LS.LOSS_TM_SSN ELSE NULL END)) -- 시간가동시간(초) 
				END						AS LOSS_TM_SSN		-- 20240715 성능가동일수  
			  ,0						AS NAV_TOT_LOSS_TM
			  ,0						AS NLD_TOT_LOSS_TM
			  ,0						AS NOP_TOT_LOSS_TM
			  ,CASE WHEN MAX(CASE WHEN LS.LOSS_CD = 'MMD_SPED' THEN LS.LOSS_RT  ELSE NULL END)  = 0
					THEN 0
					ELSE   CONVERT(FLOAT, MAX(CASE WHEN LS.LOSS_CD = 'PROD_AVG_SPED'	THEN LS.LOSS_RT ELSE NULL END)) 
						 / CONVERT(FLOAT, MAX(CASE WHEN LS.LOSS_CD = 'MMD_SPED'			THEN LS.LOSS_RT ELSE NULL END))
				END						AS LOSS_RT
		from #loss_time_rt_ln_mmly ls
		where 1=1
		  AND ls.loss_cd IN ('MMD_SPED', 'PROD_AVG_SPED', 'OP_RT')  -- 설계속도(MMD속도) , 생산 평균 속도 , 시간가동률(시간가동시간)
		GROUP BY LS.DIVISION_ID
			    ,LS.SITE_ID
			    ,LS.COMPANY_ID
			    ,LS.PLANT_ID
			    ,LS.FACTORY_ID
			    ,LS.LINE_ID
			    ,LS.OPERATION_ID
		*/ 

		-----------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_time_rt_ln_mmly - 양품가동률 (라인별) ' 
		-----------------------------------------------------------------------------------------------------------------------
		-- 생산수량 (m) - 반제품 (양품량) / 투입수량 (m)【DW : OUT_GOOD_QTY / OUT_INPUT_QTY】
		-- Lot Type ID : H, P, R, Y, S, B
		-- 2024.08.14 변경전 : OUT_GOOD_QTY / OUT_INPUT_QTY
		-- 2024.08.14 변경후 : OUT_GOOD_QTY / (OUT_DEFECT_QTY + OUT_GOOD_QTY)
		-----------------------------------------------------------------------------------------------------------------------
		INSERT INTO #loss_time_rt_ln_mmly
		SELECT R.DIVISION_ID
			  ,R.SITE_ID
			  ,R.COMPANY_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID
			  ,R.OPERATION_ID
			  ,'QL_RT'			AS LOSS_CD
			  ,'-'				AS LOSS_GR_CD
			  ,PF.MM_DAYS		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,PF.MM_SSN		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,R.ELTR_LN_TP_CD
			  ,R.EQP_NBU	
			  ,CASE WHEN OUT_INPUT_QTY = 0
					THEN 0
					ELSE CONVERT(FLOAT, CONVERT(NUMERIC(20,10), R.OUT_GOOD_QTY / (R.OUT_DEFECT_QTY + R.OUT_GOOD_QTY) )) * PF.LOSS_TM_SSN	-- 양품가동일수 : 양품가동률 * 성능가동일수 2024.08.14 변경
				END				AS LOSS_TM_SSN		-- 20240715 양품가동일수 수정 
			  ,0				AS NAV_TOT_LOSS_TM
			  ,0				AS NLD_TOT_LOSS_TM
			  ,0				AS NOP_TOT_LOSS_TM
			  ,CASE WHEN (R.OUT_DEFECT_QTY + R.OUT_GOOD_QTY) = 0
					THEN 0
					ELSE R.OUT_GOOD_QTY / (R.OUT_DEFECT_QTY + R.OUT_GOOD_QTY)  -- 2024.08.14 변경 
				END				AS LOSS_RT 
		 FROM #PRD_INPUT_LN_R R
			  LEFT JOIN #loss_time_rt_ln_mmly PF 
					 ON PF.DIVISION_ID	= R.DIVISION_ID
					AND PF.SITE_ID		= R.SITE_ID
					AND PF.COMPANY_ID	= R.COMPANY_ID
					AND PF.PLANT_ID		= R.PLANT_ID
					AND PF.FACTORY_ID	= R.FACTORY_ID
					AND PF.LINE_ID		= R.LINE_ID
					AND PF.OPERATION_ID	= R.OPERATION_ID
					AND PF.LOSS_CD		= 'PF_RT'
		WHERE 1=1

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_rt_mdl_mmly - 생산가동률 (라인별) '
		-------------------------------------------------------------------------------------------------------------------
		--  PROD_OP_RT : 생산가동률  : 부하율 * 시간가동률 * 성능가동률 * 양품가동률(라인별)
		--  LD_RT      : 부하율
		--  OP_RT      : 시간가동률
		--  PF_RT      : 성능가동률
		--  QL_RT      : 양품가동률
		-------------------------------------------------------------------------------------------------------------------
		INSERT #loss_time_rt_ln_mmly
		select r.division_id
			  ,r.site_id
			  ,r.company_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,'PROD_OP_RT'				as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,max(r.mm_days)			as mm_days			-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.mm_ssn)			as mm_ssn			-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.ELTR_LN_TP_CD)		as ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외
			  ,max(r.eqp_nbu)			as eqp_nbu
			  ,0						as loss_tm_ssn 
			  ,0						as nav_tot_loss_tm
			  ,0						as nld_tot_loss_tm
			  ,0						as nop_tot_loss_tm	
			  --------------------------------
			  ,  convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'LD_RT'		THEN loss_rt ELSE NULL END))) 
			   * convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'OP_RT'		THEN loss_rt ELSE NULL END))) 
			   * convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'PF_RT'		THEN loss_rt ELSE NULL END))) 
			   * convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'QL_RT'		THEN loss_rt ELSE NULL END))) AS loss_rt
		 FROM #loss_time_rt_ln_mmly r
		WHERE 1=1
		  AND loss_cd IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')
		GROUP BY r.division_id
			    ,r.site_id
			    ,r.company_id
			    ,r.plant_id
			    ,r.factory_id
			    ,r.line_id
			    ,r.operation_id

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #loss_rt_mdl_mmly - - TEEP (라인별) '
		-------------------------------------------------------------------------------------------------------------------
		--  TEEP : 생산가동률 * 조업률 
		-------------------------------------------------------------------------------------------------------------------
		INSERT #loss_time_rt_ln_mmly
		select r.division_id
			  ,r.site_id
			  ,r.company_id
			  ,r.plant_id
			  ,r.factory_id
			  ,r.line_id
			  ,r.operation_id
			  ,'TEEP'					as loss_cd 
			  ,'-'						as loss_gr_cd
			  ,max(r.mm_days)			as mm_days		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.mm_ssn)			as mm_ssn		-- 2024.10.15 추가 for MMD 지표 예외 정보 적용
			  ,max(r.ELTR_LN_TP_CD)		as ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외
			  ,max(r.eqp_nbu)			as eqp_nbu
			  ,0						as loss_tm_ssn 
			  ,0						as nav_tot_loss_tm
			  ,0						as nld_tot_loss_tm
			  ,0						as nop_tot_loss_tm	
			  --------------------------------
			  ,  convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'PROD_OP_RT'	THEN loss_rt ELSE NULL END))) 
			   * convert(float, convert(numeric(20,10), MAX(CASE WHEN loss_cd = 'AV_RT'			THEN loss_rt ELSE NULL END)))	AS	loss_rt
		 FROM #loss_time_rt_ln_mmly r
		WHERE 1=1
		  AND loss_cd IN ('PROD_OP_RT', 'AV_RT')
		GROUP BY r.division_id
			    ,r.site_id
			    ,r.company_id
			    ,r.plant_id
			    ,r.factory_id
			    ,r.line_id
			    ,r.operation_id


	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적설비별월별집계 DELETE SCM_DNM_ELTR_LOSS_EQP_MMLY ' 
		----------------------------------------------------------------------------------------------------------
		DELETE TGT
		  FROM SCM_DNM_ELTR_LOSS_EQP_MMLY TGT WITH(NOLOCK)
		 WHERE LOSS_YM		= @v_loss_ym 
		   AND PERD_DIVS_CD = @v_perd_divs_cd  --- 5/14 추가

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적설비별월별집계 INSERT SCM_DNM_ELTR_LOSS_EQP_MMLY ' 
		-- 2024.10.15 MMD 지표 예외 정보 적용 (@v_mm_ssn -> mm_ssn 으로 변경) 
		----------------------------------------------------------------------------------------------------------
		 INSERT INTO SCM_DNM_ELTR_LOSS_EQP_MMLY 
			(  LOSS_YM
			  ,PERD_DIVS_CD 
			  ,DIVISION_ID
			  ,COMPANY_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,EQP_ID
			  ,LOSS_CD
			  ,LOSS_GR_CD
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
			  ,@V_PERD_DIVS_CD
			  ,DIVISION_ID
			  ,COMPANY_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,EQP_ID
			  ,LOSS_CD
			  ,LOSS_GR_CD
			  ,ISNULL(LOSS_TM_SSN, 0)	AS LOSS_TM_SSN 
			  ,ISNULL(LOSS_RT, 0)		AS LOSS_RT 
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
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적라인별월별집계 DELETE SCM_DNM_ELTR_LOSS_LN_MMLY ' 
		----------------------------------------------------------------------------------------------------------
		DELETE TGT
		  FROM SCM_DNM_ELTR_LOSS_LN_MMLY TGT WITH(NOLOCK) 
		 WHERE LOSS_YM		= @v_loss_ym 
		   AND PERD_DIVS_CD = @v_perd_divs_cd  --- 20240514 추가 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 손실실적라인별월별집계 INSERT SCM_DNM_ELTR_LOSS_LN_MMLY' 
		-- 2024.10.15 MMD 지표 예외 정보 적용 
		-- @v_mm_ssn * EQP_NBU -> mm_ssn 으로 변경
		-- @v_mm_ddn -> mm_days
		----------------------------------------------------------------------------------------------------------
		INSERT INTO SCM_DNM_ELTR_LOSS_LN_MMLY   
			(  LOSS_YM
			  ,PERD_DIVS_CD -- 5/14 
			  ,DIVISION_ID
			  ,COMPANY_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,LOSS_GR_CD
			  ,LOSS_CD
			  ,EQP_NBU
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
			  ,DIVISION_ID
			  ,COMPANY_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,LOSS_GR_CD
			  ,LOSS_CD
			  ,ISNULL(EQP_NBU, 0)		AS EQP_NBU 
			  ,ISNULL(LOSS_TM_SSN, 0)	AS LOSS_TM_SSN 
			  ,ISNULL(LOSS_RT, 0)		AS LOSS_RT 
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

		
	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

		---------------------------------------
		---- 임시테이블 정리
		-----------------------------------------
		if object_id('tempdb..#LOSS_CODE') is not null drop table #LOSS_CODE
		if object_id('tempdb..#SCM_MST_EQUIPMENT_SN') is not null drop table #SCM_MST_EQUIPMENT_SN
		if object_id('tempdb..#LOSS_TIME_RAW_DATA') is not null drop table #LOSS_TIME_RAW_DATA
		if object_id('tempdb..#PRD_INPUT_ITEM_R') is not null drop table #PRD_INPUT_ITEM_R
		if object_id('tempdb..#PRD_INPUT_LN_R') is not null drop table #PRD_INPUT_LN_R
		IF OBJECT_ID('TEMPDB..#MMD_ITEM_EQP_SPED') IS NOT NULL DROP TABLE #MMD_ITEM_EQP_SPED;
		if object_id('tempdb..#LOSS_TIME_R_EQP_MMLY') is not null drop table #LOSS_TIME_R_EQP_MMLY
		if object_id('tempdb..#LOSS_TIME_RT_EQP_MMLY') is not null drop table #LOSS_TIME_RT_EQP_MMLY 
		if object_id('tempdb..#loss_time_r_ln_mmly') is not null drop table #loss_time_r_ln_mmly
		if object_id('tempdb..#loss_time_rt_ln_mmly') is not null drop table #loss_time_rt_ln_mmly

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
