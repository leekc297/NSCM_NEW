


/*  
 * Program ID   : PR_SCM_DNM_EQP_SPED_MMLY
 * Description  : 월별 설비속도실적 정보를 적재한다.
 *				 - Source : SCM_DNM_INPT_PRDN_DDLY	(DW 투입/생산 실적)  
 *							SCM_DNM_LOSS_LN_MMLY	(라인/월별 LOSS실적 : loss_cd = 'OP_RT' 가동시간 참조)
 *							SCM_MST_EQUIPMENT_SN	(FP 설비 Master)
 *							SCP_MST_ITEM_CELL_CF	(Cell환산수량 참조)
 *							SCP_MST_ITEM_BSI_IFO	(BasicModel NickName참조) 
 *							SCM_MST_FACTORY_SN
 *							SCM_MST_DIVISION
 *				 - Target : SCM_DNM_EQP_SPED_MMLY
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.02.27	hrkim		Initial Release PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  
 * 2024.04.04	hrkim		가동시간(초) -> 가동시간(분)으로 적용  
 * 2024.04.04	hrkim		Cell 환산 로직 변경, DW 데이터 참조 테이블 변경 (XIF_DW_PRD_INPUT_DAILY_YLD_R_SN -> SCM_DNM_INPT_PRDN_DDLY)
 * 2024.04.05	hrkim		SCP_MST_ITEM_CELL_CF 셀환산 수량 참조 
 * 2024.04.29	hrkim		전극라인유형코드값 로직 수정 (FP설비 Master Product_Leve3_Code참조) 
 * 2024.05.13	hrkim		A7400/A8400(AZS Stacking) 속도 단위 변경
 *							- 전극라인유형코드 매핑시 lookup  추가 참조 (OPERATION_ELECTRODE_TYPE)  
 *							- 공정/전극라인유형별 속도단위 매핑 lookup 추가 (OPERATION_ELECTRODE_TYPE_MAPPING)
 * 2024.05.14	hrkim		기간참조구분에 따른 참조 범위 변경적용
 *							1 : pfrslt_ym  해당월 1개월 참조
 *							3 : pfrslt_ym 기준 M-2부터 M(pfrslt_ym) 까지 참조
 * 2024.05.27	hrkim		소수 자릿수 처리로직 보완 (연산:FLOAT, 저장:NUMERIC(20,10))
 * 2024.06.04	hrkim		라인별집계 (basic nickname별 적재하지 않음 : MDL_NM에 '-' 로 적재) 
 * 2024.08.22	hrkim		PPM 계산시 설비 대수 반영  
 * 2024.08.23	hrkim		INPUT_QTY 0인 건도 포함 - 투입수량이 0인데 생산수량이 0이 아닌 데이터 존재.   
 * 2024.08.26	hrkim		라인별 설비대수 설비 Master 기준 수량 적용  
 * 2024.12.15   vadabi3     NERP - 특정 Company 별도 처리 개선
 * 2025.03.21	hrkim		(NERP)DW 데이터 plant 조인 컬럼 변경 (plant_id -> mes_plant_id) 
 * 2025.03.24	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 *							- A3000/A9000 완성 공정만 대상으로 함
 */  

CREATE PROCEDURE [dbo].[PR_SCM_DNM_EQP_SPED_MMLY_0724_ORG]  
	 @p_rslt_ym		        VARCHAR(6)	= NULL
	,@p_perd_divs_cd		tinyint		= 1			-- 기간구분코드 (1:1개월, 3:3개월) 
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

    DECLARE @v_ESHM NVARCHAR(8); -- G740
	SELECT @v_ESHM = DBO.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_EQP_SPED_MMLY','ESHM')
	SELECT @v_ESHM

	declare @v_rslt_ym		 varchar(6) = @p_rslt_ym;
	if @v_rslt_ym is null or ltrim(rtrim(@v_rslt_ym)) = '' 
	begin
		set @v_rslt_ym = convert(varchar(6), dateadd(mm, -1, getdate()), 112)  -- default M-1월 기준 적재
	end 

	-- 기간 구분코드
	declare @v_perd_divs_cd		tinyint		= @p_perd_divs_cd;
	if @v_perd_divs_cd is null or @v_perd_divs_cd < 1 
	begin
		set @v_perd_divs_cd = 1
	end 

	declare @v_rslt_from_ymd varchar(8) = convert(varchar(8), dateadd(mm, -(@v_perd_divs_cd-1), convert(date, @v_rslt_ym+'01', 112)), 112)
	declare @v_rslt_to_ymd	 varchar(8) = convert(varchar(8), dateadd(dd, -1, dateadd(mm, 1, convert(date, @v_rslt_ym+'01', 112))), 112)

	print '----------------------------------------------------------------'
	print ' @p_rslt_ym			: '	+ @p_rslt_ym
	print ' @v_rslt_ym			: '	+ @v_rslt_ym
	print ' @p_perd_divs_cd		: '	+ converT(nvarchar(10), @p_perd_divs_cd)
	print ' @v_perd_divs_cd		: '	+ converT(nvarchar(10), @v_perd_divs_cd)
	print ' @v_rslt_from_ymd	: '	+ @v_rslt_from_ymd
	print ' @v_rslt_to_ymd		: '	+ @v_rslt_to_ymd
	print '----------------------------------------------------------------'

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_EQP_SPED_MMLY'; --Proc별 이름 설정    --- select * from SCM_DNM_EQP_SPED_MMLY with(nolock) where pfrslt_ym = '202403'
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
		SET @v_description = '[81,82,JV][result_ym='+ @v_rslt_ym + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

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

		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 설비 Product Level3코드에 대한 전극라인유형코드 정보 - #OPERATION_ELECTRODE_TYPE' -- 5/13  추가 
		-- 공정/전극라인유형별 설비속도단위 참조 
		-----------------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#OPERATION_ELECTRODE_TYPE') is not null drop table #OPERATION_ELECTRODE_TYPE;

		 SELECT SEGMENT1		AS DIVISION_ID
			   ,SEGMENT2		AS OPERATION_ID
			   ,SEGMENT3		AS ELTR_LN_TP_CD
			   ,MAX(ATTRIBUTE1)	AS EQP_SPED_UNIT_CD 
		  INTO #OPERATION_ELECTRODE_TYPE
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE = 'OPERATION_ELECTRODE_TYPE'
		   AND VALID_YN = 'Y'
		GROUP BY SEGMENT1
				,SEGMENT2
				,SEGMENT3
   
		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 설비 Product Level3코드에 대한 전극라인유형코드 정보 - #OPERATION_ELECTRODE_TYPE_MAPPING' -- 5/13  추가 
		-- A8000/A8400공정 설비ID 4번째부터 3자리 참조하여 전극라인유형 구분
		-- FOL : Folding
		-- STK : Stacking
		-- AZS : AZS Stacking 
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
		-- A5000/A7000/A7400공정 FP 설비 Master Product Leve3 Code로 전극라인유형구분
		-- A5000 : AN(Anode), CN(Cathode)
		-- A7000 : AT(A), CT(C), HT(Half), MT(Mono)
		-- A7400 : Anode / Cathode 
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
					 WHEN EM.OPERATION_ID like 'P%' OR  EM.OPERATION_ID = 'A9000' 		THEN '-'				
					 ELSE EM.ELECTRODE_TYPE
				END  AS ELTR_LN_TP_CD 
			  ,EM.LINE_ID
		 INTO #SCM_MST_EQUIPMENT_SN 
		 FROM SCM_MST_EQUIPMENT_SN    EM   WITH(NOLOCK)
			  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
					  ON DM.DIVISION_ID	= EM.DIVISION_ID
					 AND DM.VALID_YN		= 'Y'
					 AND DM.ATTRIBUTE3		IN ('81', '82')  -- JV포함 
			  LEFT  JOIN #EQUIPMENT_PRODUCT_LEVEL3_CODE PL	 -- 20240429 추가
					  ON PL.OPERATION_ID			= EM.OPERATION_ID
					 AND PL.EQP_PRODUCT_LEVEL3_CODE = EM.PRODUCT_LEVEL3_CODE 
			  LEFT  JOIN #OPERATION_ELECTRODE_TYPE_MAPPING ET -- A8000/A8400 공정에 대한 전극/라인 유형 매핑 
					  ON ET.DIVISION_ID		= EM.DIVISION_ID
					 AND ET.OPERATION_ID	= EM.OPERATION_ID
					 AND ET.EQP_ID_4_3		= SUBSTRING(EM.EQUIPMENT_ID, 4, 3) 
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
		 FROM SCM_MST_EQUIPMENT_SN   EM  WITH(NOLOCK)
			  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
					  ON DM.DIVISION_ID	= EM.DIVISION_ID
					 AND DM.VALID_YN		= 'Y'
					 AND DM.ATTRIBUTE3		= '40' -- 소형  
		WHERE 1=1
		  AND EM.EQUIPMENT_TYPE  = 'M'		-- Main 설비
		  AND EM.ACTIVE_FLAG	 = 'Y' 
		  AND EM.OPERATION_ID    IN ('A3000', 'A9000') --- LIKE 'A%'	-- 셀만

		--------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### FP 설비 Master - 라인별/공정/라인유형별 설비대수 ' -- 2024.08.26 추가 
		--------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_MST_LINE_EQP_NBU') is not null drop table #SCM_MST_LINE_EQP_NBU
		SELECT COMPANY_ID
			  ,DIVISION_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,LINE_ID
			  ,COUNT(DISTINCT EQUIPMENT_ID) AS EQP_NBU 
		 INTO #SCM_MST_LINE_EQP_NBU
		 FROM #SCM_MST_EQUIPMENT_SN
		 WHERE 1=1
		 GROUP BY COMPANY_ID
			  ,DIVISION_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,LINE_ID

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 생산 투입 실적 - #PRD_INPUT_EQP_R ' 
		----------------------------------------------------------------------------------------------------------------
		----### Stacking & Folding
		-- ES0701	[AFCFC]Folded Cell
		-- ES0801	[ASCSC]Stacked Cell
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PRD_INPUT_EQP_R') is not null drop table #PRD_INPUT_EQP_R

		SELECT R.SITE_ID
			  ,F.PLANT_ID				-- 2025.03.21 plant 참조 변경 (r.plant_id -> f.plant_id)
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
			  ,CONVERT(FLOAT, SUM(R.INPUT_QTY	))				AS INPUT_QTY
			  ,CONVERT(FLOAT, SUM(R.GOOD_QTY	))				AS GOOD_QTY 
			  ,CONVERT(FLOAT, SUM(R.OUT_GOOD_QTY))				AS OUT_GOOD_QTY 
		 INTO #PRD_INPUT_EQP_R 
		 FROM SCM_DNM_INPT_PRDN_DDLY R with(nolock) 
			  INNER JOIN SCM_MST_FACTORY_SN F with(nolock) 
					  ON F.FACTORY_ID	= R.AREA_ID
					 AND F.MES_PLANT_ID	= R.PLANT_ID	-- 2025.03.21 JOIN 컬럼 변경 (plsnt_id -> mes_plant_id 
			  INNER JOIN #SCP_MST_ITEM_BSI_IFO I WITH(NOLOCK)
					  ON I.ITEM_ID = R.PRODUCT_ID 
			  LEFT  JOIN #SCP_MST_ITEM_BSI_IFO MI WITH(NOLOCK)
					  ON MI.ITEM_ID = R.MATERIAL_ID 
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CM WITH(NOLOCK)
					  ON CM.ITEM_ID = R.MATERIAL_ID 
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CP WITH(NOLOCK)
					  ON CP.ITEM_ID = R.PRODUCT_ID 
		WHERE 1=1
		  AND R.CAL_YMD_ID BETWEEN @v_rslt_from_ymd
							   AND @v_rslt_to_ymd
		  AND R.LOT_TYPE_ID IN ('P', 'R', 'H', 'S', 'Y', 'B')	-- FP YLD 대상 조건에 'B' 추가
		  AND R.PROCESS_ID  LIKE 'A%'							-- Cell
		  AND R.EQPT_ID		!= '@'								-- 설비정보가 없는 경우 투입수량이 0임?
		  AND R.MATERIAL_ID != '@'								-- 투입자재가 없는 경우 투입수량이 0임?
		  -- 2024.08.23 투입수량0인 데이터도 포함    AND R.INPUT_QTY   != 0 
		GROUP BY R.SITE_ID
			  ,F.PLANT_ID				-- 2025.03.21 plant 참조 변경 (r.plant_id -> f.pl 
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

		-------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 생산 투입 실적 - 제외대상 삭제전 확인을 위해 임시테이블에 임시 백업 ' 
		-------------------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PRD_INPUT_EQP_R_DELETED') is not null drop table #PRD_INPUT_EQP_R_DELETED

		SELECT *
		 INTO #PRD_INPUT_EQP_R_DELETED
		 FROM #PRD_INPUT_EQP_R 
		WHERE 1=1
		  AND ITEM_CLASS = 'ES0701' 
		  AND ISNULL(MATERIAL_ITEM_CLASS,'Z') NOT IN ('ES0601', 'ES0602') -- Folding 투입 반제품이 A/C Type Bi Cell이 아닌 경우 

		-------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 생산 투입 실적 - 제외대상 삭제 ' 
		-------------------------------------------------------------------------------------------------------------------------------
		 DELETE 
		 FROM #PRD_INPUT_EQP_R 
		WHERE 1=1
		  AND ITEM_CLASS = 'ES0701'	-- [AFCFC]Folded Cell
		  AND ISNULL(MATERIAL_ITEM_CLASS,'Z') NOT IN ('ES0601', 'ES0602') -- Folding 투입 반제품이 A/C Type Bi Cell이 아닌 경우 

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
			  ,CONVERT(FLOAT, SUM(R.INPUT_QTY))			AS INPUT_QTY	-- 반제품기준 투입수량
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

		------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 생산 투입 실적  #PRD_INPUT_CELL_CONVERT_R_LN : Cell기준 환산수량 라인별 집계' 
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
			  ,r.material_item_class
			  ,CONVERT(FLOAT, COUNT(DISTINCT R.EQP_ID))	AS EQP_NBU
			  ,sum(r.input_qty)							as input_qty
			  ,sum(r.cell_input_qty)					as cell_input_qty
			  ,sum(r.out_good_qty)						as out_good_qty
			  ,sum(r.cell_good_qty)						as cell_good_qty 
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

		--------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 생산 투입 실적 - #PROD_INPUT_RESULT - 라인별 ' 
		--------------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PROD_INPUT_RESULT') is not null drop table #PROD_INPUT_RESULT
			  
		SELECT R.COMPANY_ID
			  ,R.DIVISION_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID
			  ,R.OPERATION_ID
			  ,'-'		AS NICK_NAME  --- 20240605 라인별 집계  ---   R.NICK_NAME
			  ,R.ELTR_LN_TP_CD
			  ,CONVERT(FLOAT, MAX(EQP_NBU  ))			AS EQP_NBU
			  ,CONVERT(FLOAT, SUM(INPUT_QTY))			AS INPUT_QTY
			  ,CONVERT(FLOAT, 
			   CASE WHEN R.ELTR_LN_TP_CD = 'Folding' 
					THEN AVG(CELL_INPUT_QTY)
					ELSE SUM(CELL_INPUT_QTY)
			   END)										AS CELL_INPUT_QTY
			  ,CONVERT(FLOAT, SUM(OUT_GOOD_QTY))		AS OUT_GOOD_QTY
			  ,CONVERT(FLOAT,
			   CASE WHEN R.ELTR_LN_TP_CD = 'Folding' 
					THEN AVG(CELL_GOOD_QTY)
					ELSE SUM(CELL_GOOD_QTY)
			   END)										AS CELL_GOOD_QTY
		  INTO #PROD_INPUT_RESULT
	      FROM #PRD_INPUT_CELL_CONVERT_R_LN R 
		 WHERE 1=1
		 GROUP BY R.COMPANY_ID
			  ,R.DIVISION_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID
			  ,R.OPERATION_ID
			  --,R.NICK_NAME 
			  ,R.ELTR_LN_TP_CD

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 가동시간 - #OPERATION_TIME ' 
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#OPERATION_TIME') is not null drop table #OPERATION_TIME

		SELECT LR.DIVISION_ID
			  ,LR.COMPANY_ID
			  ,LR.SITE_ID
			  ,LR.PLANT_ID
			  ,LR.FACTORY_ID
			  ,LR.LINE_ID
			  ,LR.OPERATION_ID
			  ,LR.ELTR_LN_TP_CD
			  ,CONVERT(FLOAT, LR.LOSS_TM_SSN)	AS OP_TM_SSN
			  ,CONVERT(FLOAT, LR.LOSS_RT	)	AS OP_RT 
			  ,CONVERT(FLOAT, LR.EQP_NBU	)	AS EQP_NBU
		 INTO #OPERATION_TIME
		 FROM SCM_DNM_LOSS_LN_MMLY LR with(nolock)   
		WHERE 1=1
		  AND LR.LOSS_YM		= @v_rslt_ym		-- LOSS 실적 년월
		  AND LR.PERD_DIVS_CD	= @p_perd_divs_cd	-- 기간 구분 코드 1/3
		  AND LR.LOSS_CD = 'OP_RT'

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 월별 설비 속도 실적 최종 등록 대상 - #SCM_DNM_EQ_SPED_MMLY ' 
		/*
			PPM = CELL기준 투입수량 / 가동시간(분) * 설비대수  2024.08/22 수정 반영 


			A5000 Notching (mm/s)
				= 반제품기준 투입수량 / 가동시간(분) * 1000 / 60 
			A7000 Lamination (cpm)
				= Cell기준 투입수량 / 가동시간(분) * 반제품기준 양품생산수량 / Cell기준 양품생산수량 
			A8000 Stacking & Folding  (Folding : PPM(평균) , Stacking : Tact Time ) 
				PPM(평균) = 60 / Tact Time 
				Tact Time = 60 / PPM
				PPM(평균) = Cell기준 투입수량 / 가동시간(분) * 반제품기준 양품생산수량 / Cell기준 양품생산수량
				TactTime = 60 / (Cell기준 투입수량 / 가동시간(분) * 반제품기준 양품생산수량 / Cell기준 양품생산수량)
			A9000 Packaging (Tact Time)
				PPM(평균) = Cell기준 투입수량 / 가동시간(분) * 반제품기준 양품생산수량 / Cell기준 양품생산수량
				TactTime = 60 / ( Cell기준 투입수량 / 가동시간(분) * 반제품기준 양품생산수량 / Cell기준 양품생산수량)


		*/
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_DNM_EQP_SPED_MMLY') is not null drop table #SCM_DNM_EQP_SPED_MMLY

		SELECT PR.NICK_NAME	AS MDL_NM
			  ,PR.DIVISION_ID
			  ,PR.COMPANY_ID
			  ,PR.SITE_ID
			  ,PR.PLANT_ID
			  ,PR.FACTORY_ID
			  ,PR.LINE_ID
			  ,PR.OPERATION_ID
			  ,PR.ELTR_LN_TP_CD
			  ,CONVERT(FLOAT, ISNULL(ISNULL(EQ.EQP_NBU,  OT.EQP_NBU), PR.EQP_NBU))		AS EQP_NBU	-- 2024.08.26 
			  ,CONVERT(FLOAT,
			   CASE WHEN ISNULL(OT.OP_TM_SSN, 0)	= 0 									
					THEN 0
					-- MMS
					WHEN ISNULL(SU.EQP_SPED_UNIT_CD, 'TTT') = 'MMS'							
					THEN CONVERT(FLOAT, PR.INPUT_QTY  /  CONVERT(FLOAT, (OT.OP_TM_SSN / CONVERT(FLOAT, 60))))  
							*  CONVERT(FLOAT, 1000) / CONVERT(FLOAT, 60) 
					-- CPM
					WHEN ISNULL(SU.EQP_SPED_UNIT_CD, 'TTT') = 'CPM' AND ISNULL(PR.CELL_GOOD_QTY,0) = 0 		 -- 2025.03.27 속도 단위 조건 누락 수정 							
					THEN 0
					WHEN ISNULL(SU.EQP_SPED_UNIT_CD, 'TTT') = 'CPM'							
					THEN CONVERT(FLOAT, PR.CELL_INPUT_QTY / CONVERT(FLOAT, (OT.OP_TM_SSN / CONVERT(FLOAT, 60)))) 
							* PR.OUT_GOOD_QTY / PR.CELL_GOOD_QTY 
					-- PPM(평균)
					WHEN ISNULL(SU.EQP_SPED_UNIT_CD, 'TTT') = 'PPM_AVG'						
					THEN CONVERT(FLOAT, PR.CELL_INPUT_QTY / CONVERT(FLOAT, (OT.OP_TM_SSN / CONVERT(FLOAT, 60))))  
							* PR.OUT_GOOD_QTY / PR.CELL_GOOD_QTY
					-- TactTime
					WHEN ISNULL(PR.CELL_INPUT_QTY, 0) = 0 
					THEN 0
					WHEN ISNULL(PR.OUT_GOOD_QTY,0) = 0 -- 2025.03.27 투입수량과 가동시간정보가 있는데 양품수량이 없는 경우 보완? ->  PKG는 반제품기준 양품수량과 셀기준 양품수량이 일치? (out_good_qty / cell_godd_qty = 1 ?!) 
					THEN CONVERT(FLOAT, 60)
						/ CONVERT(FLOAT, 
						  (  CONVERT(FLOAT, PR.CELL_INPUT_QTY / CONVERT(FLOAT, (OT.OP_TM_SSN / CONVERT(FLOAT, 60)))) 
							))   -- Tact Time = 60 / PPM
					ELSE CONVERT(FLOAT, 60)
						/ CONVERT(FLOAT, 
						  (  CONVERT(FLOAT, PR.CELL_INPUT_QTY / CONVERT(FLOAT, (OT.OP_TM_SSN / CONVERT(FLOAT, 60)))) 
							* PR.OUT_GOOD_QTY / PR.CELL_GOOD_QTY
						   ))   -- Tact Time 
			   END)										AS  EQP_SPED			-- 설비속도
			  ,ISNULL(SU.EQP_SPED_UNIT_CD, 'TTT')		AS EQP_SPED_UNIT_CD		-- 설비속도 단위 5/13 변경 
			  ,CONVERT(FLOAT,
			    CASE WHEN ISNULL(OT.OP_TM_SSN, 0)	= 0 OR ISNULL(PR.CELL_INPUT_QTY, 0) = 0 
					 THEN 0
					 ELSE PR.CELL_INPUT_QTY / CONVERT(FLOAT, (OT.OP_TM_SSN / CONVERT(FLOAT, 60)))
						  * CONVERT(FLOAT, ISNULL(ISNULL(EQ.EQP_NBU,  OT.EQP_NBU), PR.EQP_NBU))  -- 2024.08.22 설비대수 반영 
				END)									 AS PPM -- PPM : Cell기준 투입수량 / 가동시간(분) * 설비대수 (8/22 설비대수 반영)
		INTO #SCM_DNM_EQP_SPED_MMLY
		FROM #PROD_INPUT_RESULT  PR
			 LEFT JOIN #OPERATION_TIME  OT
					ON OT.COMPANY_ID	= PR.COMPANY_ID
				   AND OT.DIVISION_ID	= PR.DIVISION_ID
				   AND OT.SITE_ID		= PR.SITE_ID
				   AND OT.PLANT_ID		= PR.PLANT_ID
				   AND OT.FACTORY_ID	= PR.FACTORY_ID
				   AND OT.LINE_ID		= PR.LINE_ID
				   AND OT.OPERATION_ID	= PR.OPERATION_ID
				   AND OT.ELTR_LN_TP_CD	= PR.ELTR_LN_TP_CD
			 LEFT JOIN #OPERATION_ELECTRODE_TYPE SU 
					ON SU.DIVISION_ID	= PR.DIVISION_ID
				   AND SU.OPERATION_ID	= PR.OPERATION_ID
				   AND SU.ELTR_LN_TP_CD	= PR.ELTR_LN_TP_CD
			 LEFT JOIN #SCM_MST_LINE_EQP_NBU EQ  -- 2024.08.26 
					ON OT.COMPANY_ID	= PR.COMPANY_ID
				   AND EQ.DIVISION_ID	= PR.DIVISION_ID
				   AND EQ.SITE_ID		= PR.SITE_ID
				   AND EQ.PLANT_ID		= PR.PLANT_ID
				   AND EQ.FACTORY_ID	= PR.FACTORY_ID
				   AND EQ.LINE_ID		= PR.LINE_ID
				   AND EQ.OPERATION_ID	= PR.OPERATION_ID
				   AND EQ.ELTR_LN_TP_CD	= PR.ELTR_LN_TP_CD
		WHERE 1=1


	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DELETE SCM_DNM_EQP_SPED_MMLY ' 
		----------------------------------------------------------------------------------------------------------
		DELETE TGT 
		  FROM SCM_DNM_EQP_SPED_MMLY TGT WITH(NOLOCK) 
		 WHERE PFRSLT_YM	= @v_rslt_ym  
		   AND PERD_DIVS_CD = @v_perd_divs_cd  --- 20240514 추가 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### INSERT SCM_DNM_EQP_SPED_MMLY ' 
		----------------------------------------------------------------------------------------------------------
		INSERT INTO SCM_DNM_EQP_SPED_MMLY 
			( PFRSLT_YM
		     ,PERD_DIVS_CD  -- 5/14 
			 ,MDL_NM
			 ,DIVISION_ID
			 ,COMPANY_ID
			 ,SITE_ID
			 ,PLANT_ID
			 ,FACTORY_ID
			 ,LINE_ID
			 ,OPERATION_ID
			 ,ELTR_LN_TP_CD
			 ,EQP_NBU
			 ,EQP_SPED
			 ,EQP_SPED_UNIT_CD
			 ,CREATED_BY
			 ,CREATION_DATE
			 ,LAST_UPDATED_BY
			 ,LAST_UPDATE_DATE
			 ,ATTRIBUTE1	-- PPM 
			 ) 
		SELECT @v_rslt_ym											AS PFRSLT_YM
			  ,@V_PERD_DIVS_CD  -- 5/14 
			  ,MDL_NM
			  ,DIVISION_ID
			  ,COMPANY_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,EQP_NBU
			  ,EQP_SPED
			  ,EQP_SPED_UNIT_CD
			  ,@v_program_name										AS CREATED_BY
			  ,GETDATE()											AS CREATION_DATE
			  ,@v_program_name										AS LAST_UPDATED_BY
			  ,GETDATE()											AS LAST_UPDATE_DATE
			  ,CONVERT(NVARCHAR(50), CONVERT(NUMERIC(20,10),PPM))	AS ATTRIBUTE1
		FROM #SCM_DNM_EQP_SPED_MMLY

	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

		---------------------------------------
		---- 임시테이블 정리
		-----------------------------------------
		if object_id('tempdb..#SCP_MST_ITEM_BSI_IFO') is not null drop table #SCP_MST_ITEM_BSI_IFO;
		if object_id('tempdb..#SCP_MST_ITEM_CELL_CF') is not null drop table #SCP_MST_ITEM_CELL_CF;
		if object_id('tempdb..#EQUIPMENT_PRODUCT_LEVEL3_CODE') is not null drop table #EQUIPMENT_PRODUCT_LEVEL3_CODE;
		if object_id('tempdb..#SCM_MST_EQUIPMENT_SN') is not null drop table #SCM_MST_EQUIPMENT_SN
		if object_id('tempdb..#PRD_INPUT_EQP_R') is not null drop table #PRD_INPUT_EQP_R
		if object_id('tempdb..#PRD_INPUT_EQP_R_DELETED') is not null drop table #PRD_INPUT_EQP_R_DELETED
		if object_id('tempdb..#PRD_INPUT_CELL_CONVERT_R') is not null drop table #PRD_INPUT_CELL_CONVERT_R
		if object_id('tempdb..#PROD_INPUT_RESULT') is not null drop table #PROD_INPUT_RESULT
		if object_id('tempdb..#OPERATION_TIME') is not null drop table #OPERATION_TIME
		if object_id('tempdb..#SCM_DNM_EQP_SPED_MMLY') is not null drop table #SCM_DNM_EQP_SPED_MMLY

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
    SET @v_description = N'[81,82,JV][result_ym='+ @v_rslt_ym +']['  + @v_exec_time + ']';  ;            
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
