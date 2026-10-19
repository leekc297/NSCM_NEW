

/*
 * Program ID   : PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN
 * Description  : CREATE SCP CELL PLAN FOR ELECTRODE SCP PLANNING
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.27   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.01.30   YYDOK         SCP에 대해서, 각사업부의 CELL계획수요를 
 *                            동일 PLAN TYPE 최종SEQ =>  동일주차의 최종PLAN TYPE의 최종 SEQ로 변경함
 * 2019.11.11   KSG           TE/TM 인 경우 전주 FN 기준으로 Demand 생성
 * 2020.02.21   KSG           Daily Plan 수행 종료에 따른 소스 정리
 * 2020.04.24   KSG           C20200403-000046 전극SCP 시뮬레이터 內 조립계획 I/F 기준 변경
 *                              : PR 이 아닌 경우 PR의 정보를 Copy하여 생성함
 *                              : PR 이 아닌 경우 엔진 Input에서 Demand를 Copy하여 사용하더라도 다른 프로그램에서 사용할 수 있으므로 
 *                                ELEC_DEMAND_CELL_PLAN 에서 PR이 아닌 Type 생성 유지할 것
 * 2021.07.12   KSG           PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선(Phase 2) - 중장기 플랜 대응
 * 2021.08.12   KKC           PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선(Phase 2) - DEMAND MERGE 옵션 기능 구현
 * 2022.04.11   sclee         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가 관련 대응
 * 2023.03.30	HRK			  PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN_0725_ORG]
    ( @p_division_id         NVARCHAR(30)-- 'EE'
    , @p_plan_start_yyyymmdd NVARCHAR(8) -- plan_name
    , @p_plan_type           NVARCHAR(30)
) 
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_PLN_ELEC_DEMAND_CELL_PLAN'; 
    DECLARE @d_event_date   DATETIME;

    DECLARE @v_cell_plan_start_yyyymmdd NVARCHAR(8);     -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
    DECLARE @v_end_yyyymmdd             NVARCHAR(8);     -- 20191111  TE/TM 인 경우 51주 까지로 제한
	DECLARE @v_pet_date		NVARCHAR(12) = '';

    DECLARE @v_merge_yn     NVARCHAR(1);                 --2021/08/12 추가, By KKC
    DECLARE @v_merge_days   INTEGER = 0;                 --2021/08/12 추가, By KKC
    DECLARE @v_merge_weekly_start_yyyymmdd NVARCHAR(8);  --2021/08/12 추가, By KKC
	
	
    ----------------------------------------------------------- 
    -- PJ20216891
    -- @p_division_id가 EE 또는 EE_UC인 경우 최종적으로 어느 사업부(division_id2)의 코드를 가져다 써야 할것인지를 정의함
    -- data_seq는 데이터를 불러오는 순서를 의미함.
    -- 전체 3개 사업부라서 data_seq는 3번까지만 정의함
    -----------------------------------------------------------
    -- 2023.03.30 HM JV     DECLARE @v_tb_division_map TABLE
    -- 2023.03.30 HM JV     (
    -- 2023.03.30 HM JV       data_seq     tinyint
    -- 2023.03.30 HM JV      ,division_id1 nvarchar(30)
    -- 2023.03.30 HM JV      ,division_id2 nvarchar(30)
    -- 2023.03.30 HM JV     );
	-- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     WITH sub AS
    -- 2023.03.30 HM JV     (
    -- 2023.03.30 HM JV     SELECT 1 data_seq
    -- 2023.03.30 HM JV     ,'EE_UC' division_id1
    -- 2023.03.30 HM JV     ,'81_UC' division_id2
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     UNION ALL
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     SELECT 2 data_seq
    -- 2023.03.30 HM JV     ,'EE_UC' division_id1
    -- 2023.03.30 HM JV     ,'XX' division_id2
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     UNION ALL
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     SELECT 3 data_seq
    -- 2023.03.30 HM JV     ,'EE_UC' division_id1
    -- 2023.03.30 HM JV     ,'XX' division_id2
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     UNION ALL
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     SELECT 1 data_seq
    -- 2023.03.30 HM JV     ,'EE' division_id1
    -- 2023.03.30 HM JV     ,'81' division_id2
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     UNION ALL
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     SELECT 2 data_seq
    -- 2023.03.30 HM JV     ,'EE' division_id1
    -- 2023.03.30 HM JV     ,'82' division_id2
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     UNION ALL
    -- 2023.03.30 HM JV     
    -- 2023.03.30 HM JV     SELECT 3 data_seq
    -- 2023.03.30 HM JV     ,'EE' division_id1
    -- 2023.03.30 HM JV     ,'40' division_id2
    -- 2023.03.30 HM JV     )	
    -- 2023.03.30 HM JV     INSERT INTO @v_tb_division_map
    -- 2023.03.30 HM JV     SELECT A.*
    -- 2023.03.30 HM JV     FROM   sub A;

	-- 2023.03.30 HM JV 가상 사업부 추가 대응
    IF OBJECT_ID('tempdb..#tmp_DIVISION_LIST') IS NOT NULL
    DROP TABLE #tmp_DIVISION_LIST;	

	SELECT ED.DIVISION_ID AS ELEC_DIVISION_ID
		  ,DM.ATTRIBUTE3  AS TARGET_DIVISION
		  ,DM.DIVISION_ID AS ORG_DIVISION_ID
	  INTO #tmp_DIVISION_LIST
	  FROM SCM_MST_DIVISION ED WITH(NOLOCK)
		   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
				   ON DM.ATTRIBUTE4 = ED.ATTRIBUTE4
	 WHERE 1=1
	   AND ED.ATTRIBUTE3  = 'EE'
	   AND ED.VALID_YN	  = 'Y'
	   AND DM.ATTRIBUTE3 != 'EE'
	   AND DM.VALID_YN	  = 'Y'


  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_PLN_ELEC_DEMAND_CELL_PLAN INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    
    BEGIN TRY
      BEGIN
    
        ----------------------------------------------------------- 
        -- 기존데이타 삭제
        ----------------------------------------------------------- 
        DELETE FROM SCP_PLN_ELEC_DEMAND_CELL_PLAN
        WHERE DIVISION_ID         = @p_division_id  --'EE'
          AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
          AND PLAN_TYPE           = @p_plan_type;

        ---------------------------------------------------------------
        -- 사업부별 최종 셀계획수립 데이타  AMEND QTY로 CELL PLAN 생성
        --------------------------------------------------------------- 
		-- 20191111 Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
		-- 20210510 PJ20209642
        SELECT @v_pet_date = p.horizon_end_date
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id
        AND    p.plan_name   = @p_plan_start_yyyymmdd
		AND    p.plan_cycle  = 'WEEKLY';

		SET @v_cell_plan_start_yyyymmdd = @p_plan_start_yyyymmdd;
		SET @v_end_yyyymmdd = CONVERT(NVARCHAR(8), DATEADD(DD, 7*13, CONVERT(DATETIME, @v_pet_date)), 112); -- TE/TM 이 아닌 경우 추가(13)주 까지로 제한
		--SET @v_end_yyyymmdd = CONVERT(NVARCHAR(8), DATEADD(DD, 7*65, CONVERT(DATETIME, @p_plan_start_yyyymmdd)), 112); -- TE/TM 이 아닌 경우 (52 + 13)주 까지로 제한

		-----------------------------------------------------------
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		-- Merge 여부 옵션화, 2021/08/12, By KKC

        -- PJ20216891		
        -- @p_division_id = 'EE_UC'인 경우를 대비하여 해당 테이블에 관련 설정값 입력 필요함
        -----------------------------------------------------------
		SELECT @v_merge_yn    = ISNULL(a.segment2, 'N') 
			 , @v_merge_days = ISNULL(CONVERT(INTEGER, a.segment3), 0)
		 FROM scm_adm_lookup_master_detail a(nolock)
		WHERE a.lookup_type = 'DEMAND_MERGE_YN'
		  AND a.SEGMENT1 = @p_division_id
		;

		--Daily Merge Period 변수 Validation Check, 2021/08/12, By KKC
		IF @v_merge_days IS NULL
		   BEGIN
		       SET @v_merge_days = 0;
		   END

		IF @v_merge_yn IS NULL OR @v_merge_yn != 'Y'
		   BEGIN
		       SET @v_merge_yn = 'N';
		   END
        
		--merge weekly start yyyymmdd 설정
		IF @v_merge_days = 0
		   BEGIN
		       SET @v_merge_weekly_start_yyyymmdd = @p_plan_start_yyyymmdd;
		   END
        ELSE

		   BEGIN			   
			   SELECT @v_merge_weekly_start_yyyymmdd = CONVERT(VARCHAR, DATEADD(DAY, 1, CONVERT(DATETIME, MAX(B.YYYYMMDD))), 112)
			     FROM SCM_MST_BUCKET A WITH (NOLOCK)
					 , SCM_MST_BUCKET B WITH (NOLOCK)
				 WHERE A.YYYYMMDD = CONVERT(VARCHAR, DATEADD(DAY, @v_merge_days, CONVERT(DATETIME, @p_plan_start_yyyymmdd)), 112)
				   AND B.YYYYPW   = A.YYYYPW
				;
		   END

		IF @P_PLAN_TYPE IN ('TE', 'TM')
		BEGIN
		    SET @v_cell_plan_start_yyyymmdd = CONVERT(NVARCHAR(8), DATEADD(DD, -7, CONVERT(DATETIME, @p_plan_start_yyyymmdd)), 112) ;
			SET @v_end_yyyymmdd = CONVERT(NVARCHAR(8), DATEADD(DD, 7*(-1), CONVERT(DATETIME, @v_pet_date)), 112) ; -- TE/TM 인 경우 51주 까지로 제한
			--SET @v_end_yyyymmdd = CONVERT(NVARCHAR(8), DATEADD(DD, 7*51, CONVERT(DATETIME, @p_plan_start_yyyymmdd)), 112) ; -- TE/TM 인 경우 51주 까지로 제한
		END;

        -- C20200403-000046 PR : 최신 사업부 Plan 값 적용
        IF @P_PLAN_TYPE IN ('PR', 'TE')
        BEGIN
		    
			IF @v_merge_yn = 'N'
			
				BEGIN

					WITH SUB AS
					(
					SELECT A.SCM_SITE_ID,
						   A.ITEM_ID,
						   A.LINE_ID,
						   A.OPERATION_ID,
						   A.YYYYMMDD,
						   A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
						   SUM(A.QTY)     AS QTY,
						   A.DIVISION_ID  AS ORIGIN_DIVISION_ID,
						   A.PLAN_TYPE    AS ORIGIN_PLAN_TYPE,
						   A.SEQ          AS ORIGIN_SEQ,
						   MAX(A.CREATED_BY)       AS CREATED_BY,
						   MAX(A.CREATION_DATE)    AS CREATION_DATE,
						   MAX(A.LAST_UPDATED_BY)  AS LAST_UPDATED_BY,
						   MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
					  FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK),
						   ( select TOP 1
									d.DIVISION_ID,
									p.plan_name,
									  d.plan_type,
									d.plan_seq
							   from scm_mst_plan_detail d with(nolock),
									scm_mst_plan        p with(nolock),
									scm_mst_modeling    m with(nolock)
							  where 1=1
								and m.MODELING_ID   = d.MODELING_ID
								and m.PLAN_CYCLE    = 'WEEKLY'
								and m.DIVISION_ID   = d.DIVISION_ID
								and m.MODELING_ID   = d.MODELING_ID
								and p.DIVISION_ID   = d.DIVISION_ID
								and p.PLAN_CYCLE    = m.PLAN_CYCLE
								and p.PLAN_ID       = d.PLAN_ID
								and d.PLAN_STATUS   = '1'
								and d.UI_DISPLAY_YN = 'Y'
								AND p.plan_name     = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
								
								-- 2023.03.30 HM JV 가상 사업부 추가 대응
								AND d.DIVISION_ID   IN (SELECT ORG_DIVISION_ID 
													      FROM #tmp_DIVISION_LIST    
														  WHERE TARGET_DIVISION = '81'  -- 자동차 
														    AND ELEC_DIVISION_ID = @p_division_id
															)

                                -- PJ20216891
                                -- @p_division_id가 EE_UC인 경우 81_UC 아니면 81
								-- 2023.03.30 HM JV AND d.DIVISION_ID   IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 1 AND division_id1 = @p_division_id)
								-- AND d.DIVISION_ID   = '81'
						   ORDER BY CASE PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 9 END, d.plan_seq DESC
						   ) XX
						   
                     -- PJ20216891
                     -- @p_division_id가 EE_UC인 경우 81_UC 아니면 81
					 -- 2023.03.30 HM JV WHERE A.DIVISION_ID         IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 1 AND division_id1 = @p_division_id)
					 -- WHERE A.DIVISION_ID         = '81'

					 -- 2023.03.30 HM JV 가상 사업부 추가 대응
					 WHERE A.DIVISION_ID         IN (SELECT ORG_DIVISION_ID 
													  FROM #tmp_DIVISION_LIST    
													  WHERE TARGET_DIVISION = '81'  -- 자동차 
													    AND ELEC_DIVISION_ID = @p_division_id
														)

					   AND A.PLAN_START_YYYYMMDD = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
					   AND A.MEASURE             = 'PROD_PLAN_AMEND'
					   AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd  -- 당주 Plan name
					   AND A.YYYYMMDD           <  @v_end_yyyymmdd         -- TE/TM 인 경우 51주 까지로 제한
					   AND A.QTY                >  0
					   AND A.OPERATION_ID       IN ('A3000','A9000')
					   AND A.DIVISION_ID         = XX.DIVISION_ID
					   AND A.PLAN_START_YYYYMMDD = XX.PLAN_NAME
					   AND A.PLAN_TYPE           = XX.PLAN_TYPE
					   AND A.SEQ                 = XX.PLAN_SEQ
					GROUP BY A.SCM_SITE_ID,
							 A.ITEM_ID,
							 A.LINE_ID,
							 A.YYYYMMDD,
							 A.OPERATION_ID,
							 A.DIVISION_ID,
							 A.PLAN_TYPE,
							 A.SEQ
					UNION ALL
					SELECT A.SCM_SITE_ID,
						   A.ITEM_ID,
						   A.LINE_ID,
						   A.OPERATION_ID,
						   A.YYYYMMDD,
						   A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
						   SUM(A.QTY)     AS QTY,
						   A.DIVISION_ID  AS ORIGIN_DIVISION_ID,
						   A.PLAN_TYPE    AS ORIGIN_PLAN_TYPE,
						   A.SEQ          AS ORIGIN_SEQ,
						   MAX(A.CREATED_BY)       AS CREATED_BY,
						   MAX(A.CREATION_DATE)    AS CREATION_DATE,
						   MAX(A.LAST_UPDATED_BY)  AS LAST_UPDATED_BY,
						   MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
					  FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK),
						   ( select TOP 1
									d.DIVISION_ID,
									p.plan_name,
									  d.plan_type,
									d.plan_seq
							   from scm_mst_plan_detail d with(nolock),
									scm_mst_plan        p with(nolock),
									scm_mst_modeling    m with(nolock)
							  where 1=1
								and m.MODELING_ID   = d.MODELING_ID
								and m.PLAN_CYCLE    = 'WEEKLY'
								and m.DIVISION_ID   = d.DIVISION_ID
								and m.MODELING_ID   = d.MODELING_ID
								and p.DIVISION_ID   = d.DIVISION_ID
								and p.PLAN_CYCLE    = m.PLAN_CYCLE
								and p.PLAN_ID       = d.PLAN_ID
								and d.PLAN_STATUS   = '1'
								and d.UI_DISPLAY_YN = 'Y'
								AND p.plan_name     = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
								
	   							-- 2023.03.30 HM JV 가상 사업부 추가 대응
								AND d.DIVISION_ID   IN (SELECT ORG_DIVISION_ID 
													      FROM #tmp_DIVISION_LIST    
														  WHERE TARGET_DIVISION = '82'  -- ESS 
														    AND ELEC_DIVISION_ID = @p_division_id
															)


                                -- PJ20216891
                                -- @p_division_id가 EE_UC인 경우 존재하지 않는 사업부코드(XX) 아니면 82
								-- 2023.03.30 HM JV AND d.DIVISION_ID   IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 2 AND division_id1 = @p_division_id)
								-- AND d.DIVISION_ID   = '82'
						   ORDER BY CASE PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 9 END, d.plan_seq DESC
						   ) XX
						   
                     -- PJ20216891
                     -- @p_division_id가 EE_UC인 경우 존재하지 않는 사업부코드(XX) 아니면 82
					 -- 2023.03.30 HM JV WHERE A.DIVISION_ID         IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 2 AND division_id1 = @p_division_id)
					 -- 2023.03.30 HM JV 가상 사업부 추가 대응
					 WHERE A.DIVISION_ID         IN (SELECT ORG_DIVISION_ID 
													  FROM #tmp_DIVISION_LIST    
													  WHERE TARGET_DIVISION = '82'  -- ESS 
													    AND ELEC_DIVISION_ID = @p_division_id
														)

					 -- WHERE A.DIVISION_ID         = '82'
					   AND A.PLAN_START_YYYYMMDD = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
					   AND A.MEASURE             = 'PROD_PLAN_AMEND'
					   AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd  -- 당주 Plan name
					   AND A.YYYYMMDD           <  @v_end_yyyymmdd         -- TE/TM 인 경우 51주 까지로 제한
					   AND A.QTY                >  0
					   AND A.OPERATION_ID       IN ('A3000','A9000')
					   AND A.DIVISION_ID         = XX.DIVISION_ID
					   AND A.PLAN_START_YYYYMMDD = XX.PLAN_NAME
					   AND A.PLAN_TYPE           = XX.PLAN_TYPE
					   AND A.SEQ                 = XX.PLAN_SEQ
					GROUP BY A.SCM_SITE_ID,
							 A.ITEM_ID,
							 A.LINE_ID,
							 A.YYYYMMDD,
							 A.OPERATION_ID,
							 A.DIVISION_ID,
							 A.PLAN_TYPE,
							 A.SEQ
					UNION ALL
					SELECT A.SCM_SITE_ID,
						   A.ITEM_ID,
						   A.LINE_ID,
						   A.OPERATION_ID,
						   A.YYYYMMDD,
						   A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
						   SUM(A.QTY)     AS QTY,
						   A.DIVISION_ID  AS ORIGIN_DIVISION_ID,
						   A.PLAN_TYPE    AS ORIGIN_PLAN_TYPE,
						   A.SEQ          AS ORIGIN_SEQ,
						   MAX(A.CREATED_BY)       AS CREATED_BY,
						   MAX(A.CREATION_DATE)    AS CREATION_DATE,
						   MAX(A.LAST_UPDATED_BY)  AS LAST_UPDATED_BY,
						   MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
					  FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK),
						   ( select TOP 1
									d.DIVISION_ID,
									p.plan_name,
									  d.plan_type,
									d.plan_seq
							   from scm_mst_plan_detail d with(nolock),
									scm_mst_plan        p with(nolock),
									scm_mst_modeling    m with(nolock)
							  where 1=1
								and m.MODELING_ID   = d.MODELING_ID
								and m.PLAN_CYCLE    = 'WEEKLY'
								and m.DIVISION_ID   = d.DIVISION_ID
								and m.MODELING_ID   = d.MODELING_ID
								and p.DIVISION_ID   = d.DIVISION_ID
								and p.PLAN_CYCLE    = m.PLAN_CYCLE
								and p.PLAN_ID       = d.PLAN_ID
								and d.PLAN_STATUS   = '1'
								and d.UI_DISPLAY_YN = 'Y'
								AND p.plan_name     = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
								
	   							-- 2023.03.30 HM JV 가상 사업부 추가 대응
								AND d.DIVISION_ID   IN (SELECT ORG_DIVISION_ID 
													      FROM #tmp_DIVISION_LIST    
														  WHERE TARGET_DIVISION = '40'  -- 소형 
														    AND ELEC_DIVISION_ID = @p_division_id
															)
															-- PJ20216891
                                -- @p_division_id가 EE_UC인 경우 존재하지 않는 사업부코드(XX) 아니면 40
								-- 2023.03.30 HM JV AND d.DIVISION_ID   IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 3 AND division_id1 = @p_division_id)
								-- AND d.DIVISION_ID   = '40'
						   ORDER BY CASE PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 9 END, d.plan_seq DESC
						   ) XX
						   
                     -- PJ20216891
                     -- @p_division_id가 EE_UC인 경우 존재하지 않는 사업부코드(XX) 아니면 40
					 -- 2023.03.30 HMJV WHERE A.DIVISION_ID         IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 3 AND division_id1 = @p_division_id)
					 -- WHERE A.DIVISION_ID         = '40'

					 -- 2023.03.30 HM JV 가상 사업부 추가 대응
					 WHERE A.DIVISION_ID         IN (SELECT ORG_DIVISION_ID 
													  FROM #tmp_DIVISION_LIST    
													  WHERE TARGET_DIVISION = '40'  -- 소형 
													    AND ELEC_DIVISION_ID = @p_division_id
														)

					   AND A.PLAN_START_YYYYMMDD = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
					   AND A.MEASURE             = 'PROD_PLAN_AMEND'
					   AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd  -- 당주 Plan name
					   AND A.YYYYMMDD           <  @v_end_yyyymmdd         -- TE/TM 인 경우 51주 까지로 제한
					   AND A.QTY                >  0
					   AND A.OPERATION_ID       IN ('A3000','A9000')
					   AND A.DIVISION_ID         = XX.DIVISION_ID
					   AND A.PLAN_START_YYYYMMDD = XX.PLAN_NAME
					   AND A.PLAN_TYPE           = XX.PLAN_TYPE
					   AND A.SEQ                 = XX.PLAN_SEQ
					GROUP BY A.SCM_SITE_ID,
							 A.ITEM_ID,
							 A.LINE_ID,
							 A.YYYYMMDD,
							 A.OPERATION_ID,
							 A.DIVISION_ID,
							 A.PLAN_TYPE,
							 A.SEQ
					)         
					INSERT INTO SCP_PLN_ELEC_DEMAND_CELL_PLAN
						   (DIVISION_ID,
							PLAN_START_YYYYMMDD,
							PLAN_TYPE,
							SCM_SITE_ID,
							ITEM_ID,
							LINE_ID,
							OPERATION_ID,
							YYYYMMDD,
							ENG_DEMAND_ID,
							QTY,
							ORIGIN_DIVISION_ID,
							ATTRIBUTE1,  --ORIGIN_PLAN_TYPE
							ORIGIN_SEQ,
							CREATED_BY,
							CREATION_DATE,
							LAST_UPDATED_BY,
							LAST_UPDATE_DATE)
					 SELECT 
					 
                            -- PJ20216891
							@p_division_id AS DIVISION_ID,
							-- 'EE' AS DIVISION_ID,
							@p_plan_start_yyyymmdd, -- 당주 Plan name
							@p_plan_type,
							SCM_SITE_ID,
							ITEM_ID,
							LINE_ID,
							OPERATION_ID,
							YYYYMMDD,
							ENG_DEMAND_ID,
							ROUND(QTY, 0),
							ORIGIN_DIVISION_ID,
							ORIGIN_PLAN_TYPE,
							ORIGIN_SEQ,
							CREATED_BY,
							CREATION_DATE,
							LAST_UPDATED_BY,
							LAST_UPDATE_DATE
					   FROM SUB;

				END
            
			--//Merge = 'Y' 옵션일 경우
			ELSE

				BEGIN

				    --1. Daily Merge Demand 생성
					WITH VW_PLAN_VERSION AS (
											  SELECT d.DIVISION_ID,
													 p.PLAN_NAME,
													 d.PLAN_TYPE,
													 d.PLAN_SEQ,
													 ROW_NUMBER() OVER(PARTITION BY d.DIVISION_ID
																		   ORDER BY CASE d.PLAN_TYPE WHEN 'FN' THEN 1 
																									 WHEN 'SE' THEN 2 
																									 WHEN 'MA' THEN 3 
																									 WHEN 'PR' THEN 4 
																									 ELSE 9 
																					END,
																					d.PLAN_SEQ DESC
																	 )  SEQ
												FROM scm_mst_plan_detail d WITH(NOLOCK),
													 scm_mst_plan        p WITH(NOLOCK),
													 scm_mst_modeling    m WITH(NOLOCK)
											   WHERE m.MODELING_ID   = d.MODELING_ID
												 AND m.PLAN_CYCLE    = 'WEEKLY'
												 AND m.DIVISION_ID   = d.DIVISION_ID
												 AND m.MODELING_ID   = d.MODELING_ID
												 AND p.DIVISION_ID   = d.DIVISION_ID
												 AND p.PLAN_CYCLE    = m.PLAN_CYCLE
												 AND p.PLAN_ID       = d.PLAN_ID
												 AND d.PLAN_STATUS   = '1'
												 AND d.UI_DISPLAY_YN = 'Y'
												 AND p.PLAN_NAME     = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
										         )						
						              ,SUB AS (
												 SELECT A.SCM_SITE_ID,
														A.ITEM_ID,
														A.LINE_ID,
														A.OPERATION_ID,
														A.YYYYMMDD,
														A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
														SUM(A.QTY)     AS QTY,
														A.DIVISION_ID  AS ORIGIN_DIVISION_ID,
														A.PLAN_TYPE    AS ORIGIN_PLAN_TYPE,
														A.SEQ          AS ORIGIN_SEQ,
														MAX(A.CREATED_BY)       AS CREATED_BY,
														MAX(A.CREATION_DATE)    AS CREATION_DATE,
														MAX(A.LAST_UPDATED_BY)  AS LAST_UPDATED_BY,
														MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
													FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK),
														 VW_PLAN_VERSION XX
														 
                                                   -- PJ20216891
                                                   -- @p_division_id가 EE_UC인 경우 81_UC 아니면 81
												   -- 2023.03.30 HM JV WHERE A.DIVISION_ID         IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 1 AND division_id1 = @p_division_id)
												   -- WHERE A.DIVISION_ID         = '81'
												   -- 2023.03.30 HM JV 가상 사업부 추가 대응
												   WHERE A.DIVISION_ID      IN (SELECT ORG_DIVISION_ID 
																				  FROM #tmp_DIVISION_LIST    
																				  WHERE TARGET_DIVISION = '81'  -- 자동차 
																					AND ELEC_DIVISION_ID = @p_division_id
																					)
													 AND A.PLAN_START_YYYYMMDD = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
													 AND A.MEASURE             = 'PROD_PLAN_AMEND'
													 AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd          -- 당주 Plan name
													 AND A.YYYYMMDD           <  @v_merge_weekly_start_yyyymmdd  -- Daily Merge 구간까지만
													 AND A.QTY                >  0
													 AND A.OPERATION_ID       IN ('A3000','A9000')
													 AND A.DIVISION_ID         = XX.DIVISION_ID
													 AND A.PLAN_START_YYYYMMDD = XX.PLAN_NAME
													 AND A.PLAN_TYPE           = XX.PLAN_TYPE
													 AND A.SEQ                 = XX.PLAN_SEQ
													 AND XX.SEQ                = 1 --최신버전
												  GROUP 
												     BY A.SCM_SITE_ID,
													    A.ITEM_ID,
														A.LINE_ID,
														A.YYYYMMDD,
														A.OPERATION_ID,
														A.DIVISION_ID,
														A.PLAN_TYPE,
														A.SEQ
												UNION ALL
												SELECT A.SCM_SITE_ID,
														A.ITEM_ID,
														A.LINE_ID,
														A.OPERATION_ID,
														A.YYYYMMDD,
														A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
														SUM(A.QTY)     AS QTY,
														A.DIVISION_ID  AS ORIGIN_DIVISION_ID,
														A.PLAN_TYPE    AS ORIGIN_PLAN_TYPE,
														A.SEQ          AS ORIGIN_SEQ,
														MAX(A.CREATED_BY)       AS CREATED_BY,
														MAX(A.CREATION_DATE)    AS CREATION_DATE,
														MAX(A.LAST_UPDATED_BY)  AS LAST_UPDATED_BY,
														MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
													FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK),
														 VW_PLAN_VERSION  XX
														 
                                                    -- PJ20216891
                                                    -- @p_division_id가 EE_UC인 경우 존재하지 않는 사업부코드(XX) 아니면 82
													-- 2023.03.30 HM JV WHERE A.DIVISION_ID         IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 2 AND division_id1 = @p_division_id)
													-- WHERE A.DIVISION_ID         = '82'
												    -- 2023.03.30 HM JV 가상 사업부 추가 대응
												    WHERE A.DIVISION_ID     IN (SELECT ORG_DIVISION_ID 
																				  FROM #tmp_DIVISION_LIST    
																				  WHERE TARGET_DIVISION = '82'  -- ESS 
																					AND ELEC_DIVISION_ID = @p_division_id
																					)
													  AND A.PLAN_START_YYYYMMDD = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
													  AND A.MEASURE             = 'PROD_PLAN_AMEND'
													  AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd  -- 당주 Plan name
													  AND A.YYYYMMDD           <  @v_merge_weekly_start_yyyymmdd  -- Daily Merge 구간까지만
													  AND A.QTY                >  0
													  AND A.OPERATION_ID       IN ('A3000','A9000')
													  AND A.DIVISION_ID         = XX.DIVISION_ID
													  AND A.PLAN_START_YYYYMMDD = XX.PLAN_NAME
													  AND A.PLAN_TYPE           = XX.PLAN_TYPE
													  AND A.SEQ                 = XX.PLAN_SEQ
													  AND XX.SEQ                = 1 --최신버전
												    GROUP 
													   BY A.SCM_SITE_ID,
														  A.ITEM_ID,
														  A.LINE_ID,
														  A.YYYYMMDD,
														  A.OPERATION_ID,
														  A.DIVISION_ID,
														  A.PLAN_TYPE,
														  A.SEQ
												UNION ALL
												SELECT A.SCM_SITE_ID,
														A.ITEM_ID,
														A.LINE_ID,
														A.OPERATION_ID,
														A.YYYYMMDD,
														A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
														SUM(A.QTY)     AS QTY,
														A.DIVISION_ID  AS ORIGIN_DIVISION_ID,
														A.PLAN_TYPE    AS ORIGIN_PLAN_TYPE,
														A.SEQ          AS ORIGIN_SEQ,
														MAX(A.CREATED_BY)       AS CREATED_BY,
														MAX(A.CREATION_DATE)    AS CREATION_DATE,
														MAX(A.LAST_UPDATED_BY)  AS LAST_UPDATED_BY,
														MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
													FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK),
														VW_PLAN_VERSION XX

                                                    -- PJ20216891
                                                    -- @p_division_id가 EE_UC인 경우 존재하지 않는 사업부코드(XX) 아니면 40
													-- 2023.03.30 HM JV WHERE A.DIVISION_ID         IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 3 AND division_id1 = @p_division_id)
													-- WHERE A.DIVISION_ID         = '40'
												    -- 2023.03.30 HM JV 가상 사업부 추가 대응
												    WHERE A.DIVISION_ID     IN (SELECT ORG_DIVISION_ID 
																				  FROM #tmp_DIVISION_LIST    
																				  WHERE TARGET_DIVISION = '40'  -- 소형 
																					AND ELEC_DIVISION_ID = @p_division_id
																					)
													AND A.PLAN_START_YYYYMMDD = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
													AND A.MEASURE             = 'PROD_PLAN_AMEND'
													AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd  -- 당주 Plan name
													AND A.YYYYMMDD           <  @v_merge_weekly_start_yyyymmdd  -- Daily Merge 구간까지만
													AND A.QTY                >  0
													AND A.OPERATION_ID       IN ('A3000','A9000')
													AND A.DIVISION_ID         = XX.DIVISION_ID
													AND A.PLAN_START_YYYYMMDD = XX.PLAN_NAME
													AND A.PLAN_TYPE           = XX.PLAN_TYPE
													AND A.SEQ                 = XX.PLAN_SEQ
													AND XX.SEQ                = 1  --//최신 버전
												  GROUP 
												     BY A.SCM_SITE_ID,
														A.ITEM_ID,
														A.LINE_ID,
														A.YYYYMMDD,
														A.OPERATION_ID,
														A.DIVISION_ID,
														A.PLAN_TYPE,
														A.SEQ
									)
					INSERT INTO SCP_PLN_ELEC_DEMAND_CELL_PLAN
							(DIVISION_ID,
							PLAN_START_YYYYMMDD,
							PLAN_TYPE,
							SCM_SITE_ID,
							ITEM_ID,
							LINE_ID,
							OPERATION_ID,
							YYYYMMDD,
							ENG_DEMAND_ID,
							QTY,
							ORIGIN_DIVISION_ID,
							ATTRIBUTE1,  --ORIGIN_PLAN_TYPE
							ORIGIN_SEQ,
							CREATED_BY,
							CREATION_DATE,
							LAST_UPDATED_BY,
							LAST_UPDATE_DATE)
				    SELECT 
					
                        -- PJ20216891
						@p_division_id AS DIVISION_ID,
						-- 'EE' AS DIVISION_ID,
						@p_plan_start_yyyymmdd, -- 당주 Plan name
						@p_plan_type,
						SCM_SITE_ID,
						ITEM_ID,
						LINE_ID,
						OPERATION_ID,
						YYYYMMDD,
						ENG_DEMAND_ID,
						ROUND(QTY, 0),
						ORIGIN_DIVISION_ID,
						ORIGIN_PLAN_TYPE,
						ORIGIN_SEQ,
						CREATED_BY,
						CREATION_DATE,
						LAST_UPDATED_BY,
						LAST_UPDATE_DATE
					FROM SUB;

				
				    --2. Weekly Merge Demand 생성    
                    WITH VW_PLAN_VERSION AS (
											  SELECT d.DIVISION_ID,
													 p.PLAN_NAME,
													 d.PLAN_TYPE,
													 d.PLAN_SEQ,
													 ROW_NUMBER() OVER(PARTITION BY d.DIVISION_ID
																		   ORDER BY CASE d.PLAN_TYPE WHEN 'FN' THEN 1 
																									 WHEN 'SE' THEN 2 
																									 WHEN 'MA' THEN 3 
																									 WHEN 'PR' THEN 4 
																									 ELSE 9 
																					END,
																					d.PLAN_SEQ DESC
																	 )  SEQ
												FROM scm_mst_plan_detail d WITH(NOLOCK),
													 scm_mst_plan        p WITH(NOLOCK),
													 scm_mst_modeling    m WITH(NOLOCK)
											   WHERE m.MODELING_ID   = d.MODELING_ID
												 AND m.PLAN_CYCLE    = 'WEEKLY'
												 AND m.DIVISION_ID   = d.DIVISION_ID
												 AND m.MODELING_ID   = d.MODELING_ID
												 AND p.DIVISION_ID   = d.DIVISION_ID
												 AND p.PLAN_CYCLE    = m.PLAN_CYCLE
												 AND p.PLAN_ID       = d.PLAN_ID
												 AND d.PLAN_STATUS   = '1'
												 AND d.UI_DISPLAY_YN = 'Y'
												 AND p.PLAN_NAME     = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
										         )
						, VW_BUCKET AS (
									  SELECT A.YYYYMMDD
										   , A.YYYYPW
										   , A.DAYOFWEEK
										   , MIN(A.YYYYMMDD) OVER(PARTITION BY A.YYYYPW) AS MIN_YYYYMMDD
										   , MAX(A.YYYYMMDD) OVER(PARTITION BY A.YYYYPW) AS MAX_YYYYMMDD
										FROM SCM_MST_BUCKET A WITH(NOLOCK)
									  WHERE A.YYYYMMDD >= @v_merge_weekly_start_yyyymmdd 
										AND A.YYYYMMDD <= @v_end_yyyymmdd
									)	
						, SUB AS
								(
									SELECT A.SCM_SITE_ID,
											A.ITEM_ID,
											A.LINE_ID,
											A.OPERATION_ID,
											A.YYYYMMDD,
											A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
											SUM(A.QTY)     AS QTY,
											A.DIVISION_ID  AS ORIGIN_DIVISION_ID,
											A.PLAN_TYPE    AS ORIGIN_PLAN_TYPE,
											A.SEQ          AS ORIGIN_SEQ,
											MAX(A.CREATED_BY)       AS CREATED_BY,
											MAX(A.CREATION_DATE)    AS CREATION_DATE,
											MAX(A.LAST_UPDATED_BY)  AS LAST_UPDATED_BY,
											MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
										FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK),
											 VW_PLAN_VERSION XX
											 
                                        -- PJ20216891
                                        -- @p_division_id가 EE_UC인 경우 81_UC 아니면 81
										-- 2023.03.30 HM JV WHERE A.DIVISION_ID         IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 1 AND division_id1 = @p_division_id)
										-- WHERE A.DIVISION_ID         = '81'
										-- 2023.03.30 HM JV 가상 사업부 추가 대응
										WHERE A.DIVISION_ID IN (SELECT ORG_DIVISION_ID 
																  FROM #tmp_DIVISION_LIST    
																 WHERE TARGET_DIVISION = '81'  -- 자동차 
																   AND ELEC_DIVISION_ID = @p_division_id
																)
										AND A.PLAN_START_YYYYMMDD = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
										AND A.MEASURE             = 'PROD_PLAN_AMEND'
										AND A.YYYYMMDD           >= @v_merge_weekly_start_yyyymmdd  -- Daily Merge 이후는 Weekly
										AND A.YYYYMMDD           <  @v_end_yyyymmdd                 -- TE/TM 인 경우 51주 까지로 제한
										AND A.QTY                >  0
										AND A.OPERATION_ID       IN ('A3000','A9000')
										AND A.DIVISION_ID         = XX.DIVISION_ID
										AND A.PLAN_START_YYYYMMDD = XX.PLAN_NAME
										AND A.PLAN_TYPE           = XX.PLAN_TYPE
										AND A.SEQ                 = XX.PLAN_SEQ
										AND XX.SEQ                = 1 --최신 버전
										--AND A.ITEM_ID = 'ACEH1057I-B1-B01'
										--AND A.YYYYMMDD = '20211101'
									GROUP BY A.SCM_SITE_ID,
												A.ITEM_ID,
												A.LINE_ID,
												A.YYYYMMDD,
												A.OPERATION_ID,
												A.DIVISION_ID,
												A.PLAN_TYPE,
												A.SEQ
									UNION ALL
									SELECT A.SCM_SITE_ID,
											A.ITEM_ID,
											A.LINE_ID,
											A.OPERATION_ID,
											A.YYYYMMDD,
											A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
											SUM(A.QTY)     AS QTY,
											A.DIVISION_ID  AS ORIGIN_DIVISION_ID,
											A.PLAN_TYPE    AS ORIGIN_PLAN_TYPE,
											A.SEQ          AS ORIGIN_SEQ,
											MAX(A.CREATED_BY)       AS CREATED_BY,
											MAX(A.CREATION_DATE)    AS CREATION_DATE,
											MAX(A.LAST_UPDATED_BY)  AS LAST_UPDATED_BY,
											MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
										FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK),
											 VW_PLAN_VERSION XX
											 
                                        -- PJ20216891
                                        -- @p_division_id가 EE_UC인 경우 존재하지 않는 사업부코드(XX) 아니면 82
										-- 2023.03.30 HM JV WHERE A.DIVISION_ID         IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 2 AND division_id1 = @p_division_id)
										-- WHERE A.DIVISION_ID         = '82'
										-- 2023.03.30 HM JV 가상 사업부 추가 대응
										WHERE A.DIVISION_ID IN (SELECT ORG_DIVISION_ID 
																  FROM #tmp_DIVISION_LIST    
																 WHERE TARGET_DIVISION = '82'  -- ESS 
																   AND ELEC_DIVISION_ID = @p_division_id
																)
										AND A.PLAN_START_YYYYMMDD = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
										AND A.MEASURE             = 'PROD_PLAN_AMEND'
										AND A.YYYYMMDD           >= @v_merge_weekly_start_yyyymmdd  -- Daily Merge 이후는 Weekly
										AND A.YYYYMMDD           <  @v_end_yyyymmdd                 -- TE/TM 인 경우 51주 까지로 제한
										AND A.QTY                >  0
										AND A.OPERATION_ID       IN ('A3000','A9000')
										AND A.DIVISION_ID         = XX.DIVISION_ID
										AND A.PLAN_START_YYYYMMDD = XX.PLAN_NAME
										AND A.PLAN_TYPE           = XX.PLAN_TYPE
										AND A.SEQ                 = XX.PLAN_SEQ
										AND XX.SEQ                = 1 --최신 버전
										--AND A.ITEM_ID = 'ACEH1057I-B1-B01'
										--AND A.YYYYMMDD = '20211101'
									GROUP BY A.SCM_SITE_ID,
												A.ITEM_ID,
												A.LINE_ID,
												A.YYYYMMDD,
												A.OPERATION_ID,
												A.DIVISION_ID,
												A.PLAN_TYPE,
												A.SEQ
									UNION ALL
									SELECT A.SCM_SITE_ID,
											A.ITEM_ID,
											A.LINE_ID,
											A.OPERATION_ID,
											A.YYYYMMDD,
											A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
											SUM(A.QTY)     AS QTY,
											A.DIVISION_ID  AS ORIGIN_DIVISION_ID,
											A.PLAN_TYPE    AS ORIGIN_PLAN_TYPE,
											A.SEQ          AS ORIGIN_SEQ,
											MAX(A.CREATED_BY)       AS CREATED_BY,
											MAX(A.CREATION_DATE)    AS CREATION_DATE,
											MAX(A.LAST_UPDATED_BY)  AS LAST_UPDATED_BY,
											MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
										FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK),
											VW_PLAN_VERSION XX
											
                                        -- PJ20216891
                                        -- @p_division_id가 EE_UC인 경우 존재하지 않는 사업부코드(XX) 아니면 40
										-- 2023.03.30 HM JV WHERE A.DIVISION_ID         IN (SELECT division_id2 FROM @v_tb_division_map WHERE data_seq = 3 AND division_id1 = @p_division_id)
										-- WHERE A.DIVISION_ID         = '40'
										-- 2023.03.30 HM JV 가상 사업부 추가 대응
										WHERE A.DIVISION_ID IN (SELECT ORG_DIVISION_ID 
																  FROM #tmp_DIVISION_LIST    
																 WHERE TARGET_DIVISION = '40'  -- 소형 
																   AND ELEC_DIVISION_ID = @p_division_id
																)
										AND A.PLAN_START_YYYYMMDD = @v_cell_plan_start_yyyymmdd -- 20191111  Cell Plan 용 Plan Start yyyymmdd 설정 : TE/TM 인 경우 전주 FN 기준으로 Demand 생성
										AND A.MEASURE             = 'PROD_PLAN_AMEND'
										AND A.YYYYMMDD           >= @v_merge_weekly_start_yyyymmdd  -- Daily Merge 이후는 Weekly
										AND A.YYYYMMDD           <  @v_end_yyyymmdd                 -- TE/TM 인 경우 51주 까지로 제한
										AND A.QTY                >  0
										AND A.OPERATION_ID       IN ('A3000','A9000')
										AND A.DIVISION_ID         = XX.DIVISION_ID
										AND A.PLAN_START_YYYYMMDD = XX.PLAN_NAME
										AND A.PLAN_TYPE           = XX.PLAN_TYPE
										AND A.SEQ                 = XX.PLAN_SEQ
										AND XX.SEQ                = 1 --최신 버전
										--AND A.ITEM_ID = 'ACEH1057I-B1-B01'
										--AND A.YYYYMMDD = '20211101'
									GROUP BY A.SCM_SITE_ID,
												A.ITEM_ID,
												A.LINE_ID,
												A.YYYYMMDD,
												A.OPERATION_ID,
												A.DIVISION_ID,
												A.PLAN_TYPE,
												A.SEQ
									)
						INSERT INTO SCP_PLN_ELEC_DEMAND_CELL_PLAN
								(DIVISION_ID,
								PLAN_START_YYYYMMDD,
								PLAN_TYPE,
								SCM_SITE_ID,
								ITEM_ID,
								LINE_ID,
								OPERATION_ID,
								YYYYMMDD,
								ENG_DEMAND_ID,
								QTY,
								ORIGIN_DIVISION_ID,
								ATTRIBUTE1,  --ORIGIN_PLAN_TYPE
								ORIGIN_SEQ,
								CREATED_BY,
								CREATION_DATE,
								LAST_UPDATED_BY,
								LAST_UPDATE_DATE)
						SELECT  
						
                                -- PJ20216891
						        @p_division_id AS DIVISION_ID,
                                -- 'EE' AS DIVISION_ID,
								@p_plan_start_yyyymmdd, -- 당주 Plan name
								@p_plan_type,
								A.SCM_SITE_ID,
								A.ITEM_ID,
								A.LINE_ID,
								A.OPERATION_ID,
								A.YYYYMMDD,
								A.ITEM_ID+'::'+A.LINE_ID+'::'+A.SCM_SITE_ID+'-S'+'~EXW'+'::'+'D'+'::'+'MPS'+'::'+'CF'+'::'+A.YYYYMMDD+'::'+A.SCM_SITE_ID AS ENG_DEMAND_ID,
								/* 디버깅 점검용 조회 컬럼 
								A.YYYYPW, --참고
								A.ENG_DEMAND_ID  AS ORG_DEMAND_ID,
								A.ELEC_PLANT_SITE_ID,                            --테스트 컬럼 By KKC
								ROW_NUMBER() OVER(PARTITION BY A.SCM_SITE_ID
															 , A.ITEM_ID
															 , A.YYYYMMDD
															 , A.ELEC_PLANT_SITE_ID
														ORDER BY A.LINE_ID) SEQ2 , --테스트 컬럼 By KKC
								A.ORG_QTY,
								*/
								A.WEEK_SUM_QTY,
								A.ORIGIN_DIVISION_ID,
								A.ORIGIN_PLAN_TYPE,
								A.ORIGIN_SEQ,
								A.CREATED_BY,
								A.CREATION_DATE,
								A.LAST_UPDATED_BY,
								A.LAST_UPDATE_DATE
							FROM
								(
								SELECT  A.SCM_SITE_ID,
										A.ITEM_ID,
										A.LINE_ID,
										A.OPERATION_ID,
										--A.YYYYMMDD,
					                    B.MAX_YYYYMMDD  AS YYYYMMDD,  --WEEK의 마지막 요일 기준으로 납기를 부여
										B.YYYYPW,
										A.ENG_DEMAND_ID,
										ROUND(A.QTY, 0) ORG_QTY,
										A.ORIGIN_DIVISION_ID,
										A.ORIGIN_PLAN_TYPE,
										A.ORIGIN_SEQ,
										A.CREATED_BY,
										A.CREATION_DATE,
										A.LAST_UPDATED_BY,
										A.LAST_UPDATE_DATE,
										ROW_NUMBER() OVER(PARTITION BY A.SCM_SITE_ID
																	 , A.ITEM_ID
																	 , A.LINE_ID
																	 , B.YYYYPW
															  ORDER BY A.YYYYMMDD DESC
															) AS SEQ1,
										SUM(ROUND(A.QTY,0)) OVER(PARTITION BY A.SCM_SITE_ID
																			, A.ITEM_ID
																		    , A.LINE_ID
																			, B.YYYYPW
															) AS WEEK_SUM_QTY
									 FROM SUB A
									INNER JOIN VW_BUCKET B WITH(NOLOCK)
									ON (A.YYYYMMDD = B.YYYYMMDD)
								)A
							WHERE A.SEQ1 = 1
							  AND NOT EXISTS (SELECT 'X'
												FROM SCP_PLN_ELEC_DEMAND_CELL_PLAN X WITH(NOLOCK)
												
                                               -- PJ20216891
											   WHERE X.DIVISION_ID          = @p_division_id
											   -- WHERE X.DIVISION_ID          = 'EE'  
												 AND X.PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd
												 AND X.PLAN_TYPE            = @p_plan_type
												 AND X.YYYYMMDD             = A.YYYYMMDD
											 )
							/* 디버기 조회용
							  --AND A.SCM_SITE_ID = 'A010-A'
							  --AND A.ITEM_ID     = 'MCCM346010A1'
							  --AND A.YYYYMMDD    = '20220920'
							ORDER BY A.SCM_SITE_ID
								, A.ITEM_ID
								, A.YYYYMMDD
								, A.LINE_ID
							*/
				   ;

				END

			SET @n_log_count = @@ROWCOUNT;

        END; -- IF @P_PLAN_TYPE IN ('PR', 'TE')		

        -- C20200403-000046 PR 외 : PR 값 적용
        IF @P_PLAN_TYPE NOT IN ('PR', 'TE')
        BEGIN
		
            INSERT INTO SCP_PLN_ELEC_DEMAND_CELL_PLAN
                  (DIVISION_ID,
                   PLAN_START_YYYYMMDD,
                   PLAN_TYPE,
                   SCM_SITE_ID,
                   ITEM_ID,
                   LINE_ID,
                   OPERATION_ID,
                   YYYYMMDD,
                   ENG_DEMAND_ID,
                   QTY,
                   ORIGIN_DIVISION_ID,
                   ATTRIBUTE1,  --ORIGIN_PLAN_TYPE
                   ORIGIN_SEQ,
                   CREATED_BY,
                   CREATION_DATE,
                   LAST_UPDATED_BY,
                   LAST_UPDATE_DATE)
            SELECT 
                   DIVISION_ID,
                   PLAN_START_YYYYMMDD,
                   @P_PLAN_TYPE AS PLAN_TYPE,
                   SCM_SITE_ID,
                   ITEM_ID,
                   LINE_ID,
                   OPERATION_ID,
                   YYYYMMDD,
                   ENG_DEMAND_ID,
                   QTY,
                   ORIGIN_DIVISION_ID,
                   ATTRIBUTE1,  --ORIGIN_PLAN_TYPE
                   ORIGIN_SEQ,
                   CREATED_BY,
                   GETDATE() AS CREATION_DATE,
                   LAST_UPDATED_BY,
                   GETDATE() AS LAST_UPDATE_DATE
            FROM   SCP_PLN_ELEC_DEMAND_CELL_PLAN WITH(NOLOCK)
			
            -- PJ20216891
            WHERE  DIVISION_ID         = @p_division_id
            -- WHERE  DIVISION_ID         = 'EE'
            AND    PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
            AND    PLAN_TYPE           = 'PR'
           ;

            SET @n_log_count = @@ROWCOUNT;

        END; -- IF @P_PLAN_TYPE NOT IN ('PR', 'TE')
    
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
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

