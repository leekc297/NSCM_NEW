

/*  
 * Program ID   : PR_SCM_DNM_ELTR_EQP_SPED_MMLY
 * Description  : 전극 월별 설비속도실적 정보를 적재한다.
 *				 - Source : SCM_DNM_INPT_PRDN_DDLY	(DW 투입/생산 실적)  
 *							SCM_DNM_LOSS_LN_MMLY	(라인/월별 LOSS실적 : loss_cd = 'OP_RT' 가동시간 참조)
 *							SCM_MST_EQUIPMENT_SN	(FP 설비 Master)
 *							SCP_MST_ITEM_CELL_CF	(Cell환산수량 참조)
 *							SCP_MST_ITEM_BSI_IFO	(BasicModel NickName참조) 
 *							SCM_MST_FACTORY_SN
 *							SCM_MST_DIVISION
 *				 - Target : SCM_DNM_ELTR_EQP_SPED_MMLY
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.06.05	hrkim		Initial Release PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  
 * 2024.07.08	hrkim		폭환산자 적용 로직 정리 (수량에 적용)  
 * 2024.07.10	hrkim		전극 테이블 PK 변경 : ELTR_LN_TP_CD 컬럼 PK컬럼에서 제외
 * 2025.03.21	hrkim		(NERP)DW 데이터 plant 조인 컬럼 변경 (plant_id -> mes_plant_id) 
 * 2025.03.24	hrkim		PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : CPS 소형 확산
 *
 */  


CREATE PROCEDURE [dbo].[PR_SCM_DNM_ELTR_EQP_SPED_MMLY]
	 @p_rslt_ym		        VARCHAR(6)	= NULL 
	,@p_perd_divs_cd		tinyint		= 1	-- 기간구분코드 (1:1개월, 3:3개월) 
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_ELTR_EQP_SPED_MMLY'; --Proc별 이름 설정
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
			  ,FM.MES_PLANT_ID	-- 2025.03.21 추가
		 INTO #SCM_MST_EQUIPMENT_SN 
		 FROM SCM_MST_EQUIPMENT_SN   EM   WITH(NOLOCK)
			  INNER JOIN SCM_MST_FACTORY_SN FM WITH(NOLOCK) -- 2025.03.21 추가 참조
					  ON FM.COMPANY_ID	= EM.COMPANY_ID
					 AND FM.FACTORY_ID	= EM.FACTORY_ID
		WHERE 1=1
		  -- 2025.03.24 소형 확산 AND EM.DIVISION_ID	!= '40'		-- 소형제외
		  AND EM.EQUIPMENT_TYPE  = 'M'		-- Main 설비
		  AND EM.ACTIVE_FLAG	 = 'Y' 
		  AND EM.OPERATION_ID   LIKE 'E2000%'	-- 전극 Coating

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 설비별 생산 투입 실적 - #PRD_INPUT_EQP_R ' 
		--	 2024.07.08 수정 폭환산자 반영 : Wide 의 경우 * 1/2 를 해준다 
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PRD_INPUT_EQP_R') is not null drop table #PRD_INPUT_EQP_R

		SELECT E.DIVISION_ID
			  ,E.COMPANY_ID
			  ,R.SITE_ID
			  ,E.PLANT_ID					-- 2025.03.21 plant 참조 변경 (r.plant_id -> e.plant_id) 
			  ,R.AREA_ID					AS FACTORY_ID
			  ,E.LINE_ID
			  ,R.PROCESS_ID					AS OPERATION_ID
			  ,R.EQPT_ID					AS EQP_ID
			  ,R.PRODUCT_ID					AS ITEM_ID 
			  ,MAX(E.ELTR_LN_TP_CD)			AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외 
			  ,CONVERT(FLOAT, CONVERT(FLOAT, SUM(R.OUT_INPUT_QTY)) / CONVERT(FLOAT,CASE WHEN MAX(E.ELTR_LN_TP_CD) = 'W' THEN 2 ELSE 1 END) )  	AS OUT_INPUT_QTY	-- 투입수량 (m)	 7/8 폭환산자 적용
			  ,CONVERT(FLOAT, CONVERT(FLOAT, SUM(R.OUT_GOOD_QTY )) / CONVERT(FLOAT,CASE WHEN MAX(E.ELTR_LN_TP_CD) = 'W' THEN 2 ELSE 1 END) ) 	AS OUT_GOOD_QTY		-- 생산수량 (m)	 7/8 폭환산자 적용
		 INTO #PRD_INPUT_EQP_R 
		 FROM SCM_DNM_INPT_PRDN_DDLY R with(nolock) 
			  INNER JOIN #SCM_MST_EQUIPMENT_SN E
					  ON E.SITE_ID		= R.SITE_ID
					 AND E.MES_PLANT_ID	= R.PLANT_ID	-- 2025.03.21 join 컬럼 변경 (PLANT_ID -> MES_PLANT_ID) 
					 AND E.FACTORY_ID	= R.AREA_ID
					 AND E.EQUIPMENT_ID = R.EQPT_ID
					 AND E.OPERATION_ID = R.PROCESS_ID
		WHERE 1=1
		  AND R.CAL_YMD_ID BETWEEN @v_rslt_from_ymd
							   AND @v_rslt_to_ymd
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

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DW 라인별 생산 투입 실적 - #PRD_INPUT_LN_R ' 
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#PRD_INPUT_LN_R') is not null drop table #PRD_INPUT_LN_R

		SELECT R.DIVISION_ID
			  ,R.COMPANY_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID 
			  ,R.OPERATION_ID
			  ,MAX(R.ELTR_LN_TP_CD)					AS ELTR_LN_TP_CD	-- 7/10 PK컬럼에서 제외
			  ,'-'									AS ITEM_ID			-- 6/5 라인별 집계 -- R.ITEM_ID
			  ,COUNT(DISTINCT R.EQP_ID)				AS EQP_NBU
			  ,CONVERT(FLOAT, SUM(R.OUT_INPUT_QTY)) AS OUT_INPUT_QTY
			  ,CONVERT(FLOAT, SUM(R.OUT_GOOD_QTY ))	AS OUT_GOOD_QTY
		 INTO #PRD_INPUT_LN_R
		 FROM #PRD_INPUT_EQP_R R WITH(NOLOCK) 
		GROUP BY R.DIVISION_ID
			  ,R.COMPANY_ID
			  ,R.SITE_ID
			  ,R.PLANT_ID
			  ,R.FACTORY_ID
			  ,R.LINE_ID 
			  ,R.OPERATION_ID

		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 라인별 가동시간 - #OPERATION_TIME ' 
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
		 FROM SCM_DNM_ELTR_LOSS_LN_MMLY LR with(nolock)   
		WHERE 1=1
		  AND LR.LOSS_YM		= @v_rslt_ym		-- LOSS 실적 년월
		  AND LR.PERD_DIVS_CD	= @p_perd_divs_cd	-- 기간 구분 코드 1/3
		  AND LR.LOSS_CD = 'OP_RT'


		----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 월별 전극 속도 실적 최종 등록 대상 - #SCM_DNM_EQ_SPED_MMLY ' 
		/*
			 → 투입수량 (m) / 성능가동시간 (분)
			 -  Lot Type ID : H, P, R, Y, S, B
		*/
		----------------------------------------------------------------------------------------------------------------
		if object_id('tempdb..#SCM_DNM_ELTR_EQP_SPED_MMLY') is not null drop table #SCM_DNM_ELTR_EQP_SPED_MMLY

		SELECT PR.DIVISION_ID
			  ,PR.COMPANY_ID
			  ,PR.SITE_ID
			  ,PR.PLANT_ID
			  ,PR.FACTORY_ID
			  ,PR.LINE_ID
			  ,PR.OPERATION_ID
			  ,PR.ELTR_LN_TP_CD
			  ,PR.ITEM_ID
			  ,PR.EQP_NBU
			  ,CONVERT(NUMERIC(20,10), CONVERT(FLOAT, 
				CASE WHEN OT.OP_TM_SSN = 0 
					 THEN 0
					 ELSE PR.OUT_INPUT_QTY														-- 투입수량 (m) 
					        / (OT.OP_TM_SSN / CONVERT(FLOAT, 60))								-- 가동시간(분) 
				END  
			   ))										AS EQP_SPED				-- 설비속도
			  ,'m/min'									AS EQP_SPED_UNIT_CD		-- 설비속도 단위 5/13 변경 
			  , OT.OP_TM_SSN
		INTO #SCM_DNM_ELTR_EQP_SPED_MMLY
		FROM #PRD_INPUT_LN_R  PR
			 LEFT JOIN #OPERATION_TIME  OT
					ON OT.COMPANY_ID	= PR.COMPANY_ID
				   AND OT.DIVISION_ID	= PR.DIVISION_ID
				   AND OT.SITE_ID		= PR.SITE_ID
				   AND OT.PLANT_ID		= PR.PLANT_ID
				   AND OT.FACTORY_ID	= PR.FACTORY_ID
				   AND OT.LINE_ID		= PR.LINE_ID
				   AND OT.OPERATION_ID	= PR.OPERATION_ID
				   -- PK컬럼에서 제외 AND OT.ELTR_LN_TP_CD	= PR.ELTR_LN_TP_CD
		WHERE 1=1



	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### DELETE SCM_DNM_ELTR_EQP_SPED_MMLY ' 
		----------------------------------------------------------------------------------------------------------
		DELETE TGT 
		  FROM SCM_DNM_ELTR_EQP_SPED_MMLY TGT WITH(NOLOCK) 
		 WHERE PFRSLT_YM	= @v_rslt_ym  
		   AND PERD_DIVS_CD = @v_perd_divs_cd  --- 20240514 추가 

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### INSERT SCM_DNM_ELTR_EQP_SPED_MMLY ' 
		----------------------------------------------------------------------------------------------------------
		INSERT INTO SCM_DNM_ELTR_EQP_SPED_MMLY 
			( PFRSLT_YM
		     ,PERD_DIVS_CD
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
			 ) 
		SELECT @v_rslt_ym		AS PFRSLT_YM
			  ,@V_PERD_DIVS_CD  
			  ,ITEM_ID
			  ,DIVISION_ID
			  ,COMPANY_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,FACTORY_ID
			  ,LINE_ID
			  ,OPERATION_ID
			  ,ELTR_LN_TP_CD
			  ,EQP_NBU
			  ,ISNULL(EQP_SPED, 0)	AS EQP_SPED
			  ,EQP_SPED_UNIT_CD
			  ,@v_program_name	AS CREATED_BY
			  ,GETDATE()		AS CREATION_DATE
			  ,@v_program_name	AS LAST_UPDATED_BY
			  ,GETDATE()		AS LAST_UPDATE_DATE
		FROM #SCM_DNM_ELTR_EQP_SPED_MMLY

	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

		---------------------------------------
		---- 임시테이블 정리
		---------------------------------------
		if object_id('tempdb..#SCM_MST_EQUIPMENT_SN') is not null drop table #SCM_MST_EQUIPMENT_SN
		if object_id('tempdb..#PRD_INPUT_EQP_R') is not null drop table #PRD_INPUT_EQP_R
		if object_id('tempdb..#PRD_INPUT_LN_R') is not null drop table #PRD_INPUT_LN_R
		if object_id('tempdb..#OPERATION_TIME') is not null drop table #OPERATION_TIME
		if object_id('tempdb..#SCM_DNM_ELTR_EQP_SPED_MMLY') is not null drop table #SCM_DNM_ELTR_EQP_SPED_MMLY

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
