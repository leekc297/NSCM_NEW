


/*
 * Program ID   : PR_SCM_KPI_PROJECTROUTE_BOM
 * Description  : Project Route, BOM 준수율 데이타 생성 : 매주 화요일 새벽 당주 정보 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019.04.17	hwyoon			Initial Release [CSR ID:3977249] [지표정의] GSCM Portal - SCP HI 지표 산출 
 * 2021.03.30   PJG             대체 BOM 모델링 적용
 * 2021.10.06   sclee.lee       PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : RTF개선
 * 2022.03.25   sclee           PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.11.15   KSG             PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 2023.03.23	hrkim			[PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 *									(다수 참조 테이블 NOLOCK 옵션 추가)
 */
 
CREATE PROCEDURE [dbo].[PR_SCM_KPI_PROJECTROUTE_BOM]
(
   @p_basis_yyyymmdd  NVARCHAR(8)=NULL
 )
 AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch_PRJBOM';
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_KPI_PROJECTROUTE_BOM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_PROJECTROUTE_BOM'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCM_KPI_PROJECTROUTE_BOM INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    

	-- 업무용 변수
	DECLARE @v_basis_yyyymmdd  NVARCHAR(8);  -- 기준 일자  
	DECLARE @v_plan_id         NVARCHAR(8);  -- 
	DECLARE @rows INT;         

    -- PJ20216891
	-- DECLARE @p_division_id nvarchar(max) = '40,81,82';
	DECLARE @p_division_id nvarchar(max) = ''; -- '40,81,82,81_UC';
	DECLARE @v_division_id nvarchar(max) = '';

	-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
	SELECT @p_division_id = -- 40,81,82,81_HM,81_UC
							STUFF(( SELECT ',' +  division_id
									 FROM SCM_MST_DIVISION WITH(NOLOCK) 
									WHERE 1=1
									  AND ATTRIBUTE3 != 'EE'
									  AND VALID_YN	  = 'Y'
									ORDER BY SUBSTRING(DIVISION_ID, 1,1)
											,LEN(DIVISION_ID)
											,DIVISION_ID 
								  FOR XML PATH('')), 1, 1,'')

	DECLARE @max_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt		INTEGER = 0; 
	DECLARE @v_delimiter        NVARCHAR(1) = ',';

	DECLARE @p_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @p_to_yyyymmdd       AS NVARCHAR(8)='';
	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
	DECLARE @v_from_result       AS NVARCHAR(8)='';
	DECLARE @v_to_result         AS NVARCHAR(8)='';
	DECLARE @v_unit_date         AS NVARCHAR(8)='';  --현재일 기준의 주(week)의 시작일자

	DECLARE @p_status			 NVARCHAR(6)=NULL


	BEGIN TRY
		BEGIN
			------------------------------------------------------------------------------------
			-- 매주 일요일에 월요일 일자로 적재한다. 
			------------------------------------------------------------------------------------
			-- 기준일자 설정
			IF @p_basis_yyyymmdd IS NOT NULL
				BEGIN
					SET @v_basis_yyyymmdd = @p_basis_yyyymmdd;
				END
			ELSE
				BEGIN
					SET @v_basis_yyyymmdd = convert(VARCHAR(8), GETDATE(),112) --현재일자
				END
			;

			-- from_yyyymmdd는 현재일자의 월요일로 강제설정
			set @p_from_yyyymmdd= (SELECT convert(VARCHAR(8), dateadd(dd, -(dayofweek_no-1),basis_yyyymmDD),112) as basis_start_date
									FROM (
										SELECT (CASE WHEN DAYOFWEEK_NO -1 =0 THEN 7 ELSE dayofweek_no -1 END ) dayofweek_no 
												,CONVERT(DATETIME, basis_yyyymmDD) as basis_yyyymmDD
												,DAYOFWEEK
										FROM scm_sys_calendar_m 
										WHERE basis_yyyymmdd =@v_basis_yyyymmdd
  										) f 
									) ;
			-- 52주 설정
			SET @p_to_yyyymmdd =  convert(varchar, dateadd(day,-1, dateadd(day, 364, convert(datetime,@p_from_yyyymmdd))) ,112);

			SELECT @v_unit_date = C.BASIS_START_DATE
				FROM   [dbo].[SCM_SYS_CALENDAR_M]      C WITH(NOLOCK)
				WHERE  1 = 1
				AND    C.BASIS_YYYYMMDD = CONVERT(NVARCHAR(8), CURRENT_TIMESTAMP, 112);

			IF( @v_unit_date >= @p_from_yyyymmdd  AND  @v_unit_date <= @p_to_yyyymmdd )
				BEGIN
					SET @v_from_result   = @p_from_yyyymmdd ;
					SET @v_to_result     = @v_unit_date;	
					SET @v_from_yyyymmdd = @v_unit_date;
					SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
					IF(@p_from_yyyymmdd  = @v_unit_date  )
						BEGIN
							SET @v_from_result   = '';
							SET @v_to_result     = '';			
						END
				END;
			ELSE IF(@v_unit_date < @p_from_yyyymmdd  AND  @v_unit_date < @p_to_yyyymmdd )
				BEGIN
					SET @v_from_yyyymmdd = @p_from_yyyymmdd;
					SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
					SET @v_from_result   = '';
					SET @v_to_result     = '';	
				END;	
			ELSE IF(@v_unit_date > @p_from_yyyymmdd  AND  @v_unit_date > @p_to_yyyymmdd )
				BEGIN
					SET @v_from_yyyymmdd = '';
					SET @v_to_yyyymmdd   = '';
					SET @v_from_result   = @p_from_yyyymmdd;
					SET @v_to_result     = @p_to_yyyymmdd;	
				END
			;

			-- 주차 데이터 삭제
			DELETE FROM SCM_KPI_PROJECTROUTE_BOM
			WHERE PLAN_START_YYYYMMDD=@v_from_yyyymmdd

		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = '';
		SET @v_log_message = 'SCM_KPI_PROJECTROUTE_BOM';
		SET @v_description = 'DELETE';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			/********************************************************************************      
			* 임시테이블만들기 - 본 테이블      
			********************************************************************************/      
			IF OBJECT_ID('tempdb..#TblDynamicPivot_ProjectRoute') IS NOT NULL      
			DROP TABLE #TblDynamicPivot_ProjectRoute; 

			CREATE TABLE #TblDynamicPivot_ProjectRoute (
					PLAN_START_YYYYMMDD	NVARCHAR(8)	
					,DIVISION_ID		NVARCHAR(60)	
					,SCM_SITE_ID		NVARCHAR(30)	
					,PROJECT_CODE		NVARCHAR(50)
					,ITEM_ID			NVARCHAR(50)
					,PLANT_PER_ITEM		NVARCHAR(100)
					,CMPLTD_STATUS		NVARCHAR(1)
				)
			;

			-- 프로시저 LOOP 길이를 판단
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_division_id, @v_delimiter);    

			WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN    
					-- @mst_loop_cnt 1증가
					SET @mst_loop_cnt = @mst_loop_cnt + 1;

					-- 각 컬럼들에 대한 스플릿처리로직 스타트
					BEGIN
						SET @v_division_id   = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
					END;

					-- LOOP 파라미터 출력 DEBUG용			
					BEGIN		
						PRINT '@v_division_id    = ' + @v_division_id   ;
					END;

					/********************************************************************************
					* 임시테이블만들기
					********************************************************************************/
					IF OBJECT_ID('tempdb..#TblDynamicPivot_ProjectRoute_tmp1') IS NOT NULL
						DROP TABLE #TblDynamicPivot_ProjectRoute_tmp1

					IF OBJECT_ID('tempdb..#TblDynamicPivot_ProjectRoute_tmp2') IS NOT NULL
						DROP TABLE #TblDynamicPivot_ProjectRoute_tmp2

                    -- PJ20216891
					-- IF( @v_division_id = '81' )
					-- IF( @v_division_id IN ('81', '81_UC') )
					-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영 
					IF EXISTS (SELECT TOP 1 *
								 FROM SCM_MST_DIVISION WITH(NOLOCK)
								WHERE 1=1
								  AND DIVISION_ID = @v_division_id  
								  AND ATTRIBUTE3 = '81' 
								  AND VALID_YN	 = 'Y' )
						BEGIN
							-- 81 자동차 사업부
							SELECT 
								 t.division_id
								,dbo.fn_get_division_name(t.division_id) AS division_name
								,t.scm_site_id 
								,t.project_code
								,t.item_id 
								,CASE WHEN  u.plant_per_item is null  THEN 'BOM' ELSE  u.plant_per_item END AS plant_per_item 
								,isnull(u.cmpltd_status,'N') AS cmpltd_status
								,''  AS month  --substring(yyyymmdd,1,6) AS month 
								,1   AS qty    --t.qty
							INTO #TblDynamicPivot_ProjectRoute_tmp1
							FROM ( select distinct a.division_id,project_code,a.scm_site_id,a.item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id--,yyyymmdd,qty 
									 from dm_pln_mkt_fcst a  WITH(NOLOCK)
									 JOIN scm_mst_item_sn b  WITH(NOLOCK) ON a.division_id = b.division_id and a.item_id= b.item_id
									 LEFT JOIN scm_mst_site s  WITH(NOLOCK) ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
									WHERE 1=1 
									  AND a.division_id = @v_division_id
									  --AND a.measure ='MKT_FCST'

									  /* PJ20214907 */
									  -- 20221115 PJ20216994 MKT FCST 조건 변경
									  --AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
									  --AND a.MEASURE = IIF(ISNULL(s.operation_group, '') = 'W', 'AS_In_Req', IIF(ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST'))
                                      AND a.measure = CASE WHEN ISNULL(s.operation_group, '') = 'W' THEN 'AS_In_Req' WHEN s.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
									  AND b.scp_operation_group_id <> 'E'
									  AND a.yyyymmdd >= @v_from_yyyymmdd
									  AND a.yyyymmdd <= @v_to_yyyymmdd
									  and a.yyyymmdd != '' and a.yyyymmdd is not null
									  AND a.qty      >  0

									union all

								   select distinct a.division_id,project_code,a.scm_site_id,a.item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id--,yyyymmdd,qty 
									 from dbo.DM_PLN_MKT_FCST_RESULT a  WITH(NOLOCK)
									 JOIN scm_mst_item_sn b  WITH(NOLOCK) ON a.division_id = b.division_id and a.item_id= b.item_id
									 LEFT JOIN scm_mst_site s  WITH(NOLOCK) ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
									WHERE 1=1 
									  AND a.division_id = @v_division_id
									  --AND a.measure ='MKT_FCST'

									  /* PJ20214907 */
									  -- 20221115 PJ20216994 MKT FCST 조건 변경
									  --AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
									  --AND a.MEASURE = IIF(ISNULL(s.operation_group, '') = 'W', 'AS_In_Req', IIF(ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST'))
                                      AND a.measure = CASE WHEN ISNULL(s.operation_group, '') = 'W' THEN 'AS_In_Req' WHEN s.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
									  AND b.scp_operation_group_id <> 'E'
									  AND a.yyyymmdd >= @v_from_result
									  AND a.yyyymmdd <= @v_to_result
									  and a.yyyymmdd != '' and a.yyyymmdd is not null		
									  AND a.qty      >  0	  	
								 ) t  

								 /*******************start of 수량 카운트 부분 ********************************************************************************/
								 LEFT OUTER JOIN  (SELECT division_id
														 ,SCM_SITE_ID
														 ,project_code								 
														 ,model_id
														 ,CONVERT(VARCHAR, SUM(plant_cnt) ) +'/'+ CONVERT(VARCHAR, tot_cnt) AS plant_per_item
														 ,CASE WHEN SUM(plant_cnt) = tot_cnt THEN 'Y' ELSE 'N' END cmpltd_status
													FROM (
														SELECT division_id,SCM_SITE_ID, project_code, model_id, COUNT(*) OVER(PARTITION BY division_id,SCM_SITE_ID,project_code,model_id) AS tot_cnt, CASE WHEN primary_plant IS NOT NULL THEN 1 ELSE 0 END AS plant_cnt
														FROM (
																SELECT DISTINCT	
																		 (CASE 
																		  WHEN dbo.FN_GET_ITEM_OPERATION_GROUP(a.division_id, a.item_id) = 'E' THEN C.ITEM_ID
																		  ELSE b.model_id	
																		  END ) AS model_id	
																	   , (CASE 
																		  -- 전극 제외 20180517
																		  WHEN d.operation_group_id = 'A' THEN 'Cell'
																		  WHEN d.operation_group_id = 'P' THEN 'Pack'
																		  END ) AS operation_group_id
																	   ,d.electrode_type
																	   ,b.child_item_id AS item_id
																	  ,(SELECT rownumber 
																		 FROM (		
																				SELECT ROW_NUMBER() OVER (ORDER BY from_yyyymmdd) AS rownumber
												 								 FROM scm_mst_site_item_priority s  WITH(NOLOCK)
																				WHERE s.division_id   = b.division_id
																				  AND s.item_id       = b.child_item_id 
																				  AND s.project_code  = a.project_code
																				  AND s.SALES_SITE_ID = a.SCM_SITE_ID /* 20180326 sales site 추가부분 */
																				  AND s.to_yyyymmdd  >= convert(varchar, getdate(),112) 
																				  AND s.valid_yn = 'Y'
																				  AND s.priority = '1'
	 																			) a 
																		 WHERE rownumber =1
																		) AS primary_plant
																	 ,b.division_id
																	 ,a.SCM_SITE_ID
																	 ,a.project_code			
																FROM dm_pln_mkt_fcst a  WITH(NOLOCK)
																    -- 2021.03.30 대체 BOM 모델링
																	--JOIN scm_mst_bom_sn b    ON a.division_id   = b.division_id
																	JOIN scm_mst_bom_sn_V b  WITH(NOLOCK)   ON a.division_id   = b.division_id
																							and a.item_id       = b.model_id 	
																	JOIN scm_mst_item_sn c   WITH(NOLOCK) ON b.company_id    = c.company_id 
																							and b.division_id   = c.division_id	
																							and b.site_id       = c.site_id 
																							and b.child_item_id = c.item_id
																	JOIN scm_mst_final_item_v d WITH(NOLOCK) ON b.division_id = d.division_id  and b.child_item_id = d.item_id
																	LEFT JOIN scm_mst_site s  WITH(NOLOCK) ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
																WHERE 1=1
																--AND c.item_type		<> 'r'
																--  실적(등록된 카운트)수량은 분기되기 이전 날짜 전체를 사용해야 카운트가 맞음
																--Alternate Part 제외로직 추가
																AND	b.alt_priority ='Y'
																AND a.yyyymmdd >= @p_from_yyyymmdd
																AND a.yyyymmdd <= @p_to_yyyymmdd
									 							--AND a.measure ='MKT_FCST'

																/* PJ20214907 */ -- 20221115 PJ20216994 MKT FCST 조건 변경
																--AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
																--AND a.MEASURE = IIF(ISNULL(s.operation_group, '') = 'W', 'AS_In_Req', IIF(ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST'))
                                                                AND a.measure = CASE WHEN ISNULL(s.operation_group, '') = 'W' THEN 'AS_In_Req' WHEN s.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
			  													AND a.qty>0	
																AND a.division_id  = @v_division_id
																--AND (( @p_project_code IS NULL OR  @p_project_code ='' ) OR a.project_code IN (SELECT token FROM dbo.String_Split(@p_project_code	,',')) )
																--AND (( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR b.model_id     IN (SELECT token FROM dbo.String_Split(@p_item_id		,',')) )
																AND d.OPERATION_GROUP_ID <> 'E'
																--팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
																AND EXISTS (SELECT *
																			FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
																		   WHERE DIVISION_ID = @v_division_id
																			 AND PARENT_ITEM_ID= b.child_item_id
																			--BOM을 제거모델 조회안되도록 수정
																			AND EFF_END_DATE >= GETDATE()
																			AND KEY_DATE = ( SELECT MAX(KEY_DATE)
																							 FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
																							WHERE PARENT_ITEM_ID= b.child_item_id --'ECE0315N1-01'
																 							  AND DIVISION_ID = @v_division_id )
																		   )
															) m
														) n
													GROUP BY division_id, SCM_SITE_ID,project_code, model_id, tot_cnt
												) u  ON t.division_id  = u.division_id
													AND t.SCM_SITE_ID  = u.SCM_SITE_ID
													AND t.project_code = u.project_code
													AND t.item_id      = u.model_id
								/******************end of 수량카운트********************************************************************************************/

								 INNER JOIN  scm_mst_site_item v  ON t.division_id  = v.division_id 
																and t.item_id      = v.item_id
																and t.scm_site_id  = v.scm_site_id 
																and t.project_code = v.project_code
								 INNER JOIN  (SELECT division_id
		   											,item_id
		   											,nick_name
		   											,item_type
		   											,ROW_NUMBER() OVER ( PARTITION BY division_id, item_id ORDER BY  CASE item_type WHEN 'P' THEN 999 WHEN 'H' THEN 888 WHEN 'R' THEN 777  WHEN 'Q' THEN 666 ELSE 0 END  DESC ) nums
											   FROM SCM_MST_ITEM_SN  WITH(NOLOCK)
											   ) i   ON t.division_id  = i.division_id
													AND t.item_id      = i.item_id
													AND i.nums =1
							WHERE 1=1
							  AND i.item_type NOT IN ('Q','R')	
							  --AND t.measure ='MKT_FCST'

							  /* PJ20214907 */
							  --AND t.measure in ('VMI_In_Req',  'MKT_FCST')
							  AND t.measure in ('VMI_In_Req',  'MKT_FCST', 'AS_In_Req')
							  --AND t.qty>0	
								AND t.division_id  = @v_division_id
								--AND ( ( @p_scm_site_id  IS NULL OR  @p_scm_site_id  ='' ) OR t.scm_site_id   IN (SELECT token FROM dbo.String_Split(@p_scm_site_id	,',')) ) /* 20180326 sale site 추가부분 */
								--AND ( ( @p_project_code IS NULL OR  @p_project_code ='' ) OR t.project_code  IN (SELECT token FROM dbo.String_Split(@p_project_code	,',')) )
								--AND ( ( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR t.item_id       IN (SELECT token FROM dbo.String_Split(@p_item_id		,',')) )
								AND ( ( @p_status       IS NULL OR  @p_status       ='' ) OR u.cmpltd_status IN (SELECT token FROM dbo.String_Split(@p_status		,',')) )
						   ;
						END
					ELSE IF( @v_division_id = '82' or  @v_division_id = '40')
						BEGIN
							-- 40 소형, 82 ESS
							SELECT 
								 t.division_id
								,dbo.fn_get_division_name(t.division_id) AS division_name
								,t.scm_site_id 
								,t.project_code
								,t.item_id 
								,CASE WHEN  u.plant_per_item is null  THEN 'BOM' ELSE  u.plant_per_item END AS plant_per_item 
								,isnull(u.cmpltd_status,'N') AS cmpltd_status
								,''  AS month  --substring(yyyymmdd,1,6) AS month 
								,1   AS qty    --t.qty
							INTO #TblDynamicPivot_ProjectRoute_tmp2
							FROM ( SELECT distinct a.division_id
										 ,'-' AS project_code
										 ,'-' AS scm_site_id
										 ,a.item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id--,yyyymmdd,qty 
									 FROM dm_pln_mkt_fcst a  WITH(NOLOCK)
									 JOIN scm_mst_item_sn b  WITH(NOLOCK) ON a.division_id = b.division_id and a.item_id= b.item_id
									 LEFT JOIN scm_mst_site s  WITH(NOLOCK) ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
									WHERE 1=1 
									  AND a.division_id = @v_division_id

									  /* PJ20214907 */-- 20221115 PJ20216994 MKT FCST 조건 변경
									  --AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
									  --AND a.MEASURE = IIF(ISNULL(s.operation_group, '') = 'W', 'AS_In_Req', IIF(ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST'))
                                      AND a.measure = CASE WHEN ISNULL(s.operation_group, '') = 'W' THEN 'AS_In_Req' WHEN s.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
									  AND b.scp_operation_group_id <> 'E'
									  AND a.yyyymmdd >= @v_from_yyyymmdd
									  AND a.yyyymmdd <= @v_to_yyyymmdd
									  AND a.yyyymmdd != '' and a.yyyymmdd is not null
									  AND a.qty      >  0
									UNION ALL
								   SELECT distinct a.division_id
										 ,'-' AS project_code
										 ,'-' AS scm_site_id
										 ,a.item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id--,yyyymmdd,qty 
									 FROM dm_pln_mkt_fcst_result a  WITH(NOLOCK)
									 JOIN scm_mst_item_sn b  WITH(NOLOCK) ON a.division_id = b.division_id and a.item_id= b.item_id
									 LEFT JOIN scm_mst_site s  WITH(NOLOCK) ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
									WHERE 1=1 
									  AND a.division_id = @v_division_id

									  /* PJ20214907 */-- 20221115 PJ20216994 MKT FCST 조건 변경
									  --AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
									  --AND a.MEASURE = IIF(ISNULL(s.operation_group, '') = 'W', 'AS_In_Req', IIF(ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST'))
                                      AND a.measure = CASE WHEN ISNULL(s.operation_group, '') = 'W' THEN 'AS_In_Req' WHEN s.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
									  AND b.scp_operation_group_id <> 'E'
									  AND a.yyyymmdd >= @v_from_result
									  AND a.yyyymmdd <= @v_to_result
									  AND a.yyyymmdd != '' and a.yyyymmdd is not null	
									  AND a.qty      >  0
								 ) t  
								 /*******************start of 수량 카운트 부분 ********************************************************************************/
								 LEFT OUTER JOIN  (SELECT division_id
														 ,scm_site_id
														 ,project_code								 
														 ,model_id
														 ,CONVERT(VARCHAR, SUM(plant_cnt) ) +'/'+ CONVERT(VARCHAR, tot_cnt) AS plant_per_item
														 ,CASE WHEN SUM(plant_cnt) = tot_cnt THEN 'Y' ELSE 'N' END cmpltd_status
													FROM (
														SELECT division_id,'-' AS scm_site_id, '-' AS project_code, model_id, COUNT(*) OVER(PARTITION BY division_id,model_id) AS tot_cnt, CASE WHEN primary_plant IS NOT NULL THEN 1 ELSE 0 END AS plant_cnt
														FROM (
																SELECT DISTINCT	
																		 (CASE WHEN dbo.FN_GET_ITEM_OPERATION_GROUP(a.division_id, a.item_id) = 'E' THEN C.ITEM_ID
																				ELSE b.model_id	
																		  END ) AS model_id	
																	   , (CASE
																			  -- 전극 제외 20180517
																			   WHEN d.operation_group_id = 'A' THEN 'Cell'
																			   WHEN d.operation_group_id = 'P' THEN 'Pack'
																		  END ) AS operation_group_id
																	   ,d.electrode_type
																	   ,b.child_item_id AS item_id
																	  ,(SELECT rownumber 
																		 FROM (		
																				SELECT ROW_NUMBER() OVER (ORDER BY from_yyyymmdd) AS rownumber
												 								 FROM scm_mst_site_item_priority s  WITH(NOLOCK)
																				WHERE s.division_id   = b.division_id
																				  AND s.item_id       = b.child_item_id 
																				  AND s.to_yyyymmdd  >= convert(varchar, getdate(),112) 
																				  AND s.valid_yn = 'Y'
																				  AND s.priority = '1'
	 																			) a 
																		 WHERE rownumber =1
																		) AS primary_plant
																	 ,b.division_id
																FROM dm_pln_mkt_fcst     a  WITH(NOLOCK)
																	--JOIN scm_mst_bom_sn  b   ON a.division_id   = b.division_id
																	JOIN scm_mst_bom_sn_V b   WITH(NOLOCK)  ON a.division_id   = b.division_id
																							AND a.item_id       = b.model_id 	
																	JOIN scm_mst_item_sn c   WITH(NOLOCK)  ON b.company_id    = c.company_id 
																							AND b.division_id   = c.division_id	
																							AND b.site_id       = c.site_id 
																							AND b.child_item_id = c.item_id
																	JOIN scm_mst_final_item_v d  WITH(NOLOCK)  ON b.division_id = d.division_id  and b.child_item_id = d.item_id
																	LEFT JOIN scm_mst_site s  WITH(NOLOCK) ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
																WHERE 1=1
																--Alternate Part 제외로직 추가
																AND	b.alt_priority  = 'Y'
																--AND c.item_type		<> 'r'
																--  실적(등록된 카운트)수량은 분기되기 이전 날짜 전체를 사용해야 카운트가 맞음
																AND a.yyyymmdd >= @p_from_yyyymmdd
																AND a.yyyymmdd <= @p_to_yyyymmdd
									 							--AND a.measure ='MKT_FCST'

																/* PJ20214907 */-- 20221115 PJ20216994 MKT FCST 조건 변경
																--AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
																--AND a.MEASURE = IIF(ISNULL(s.operation_group, '') = 'W', 'AS_In_Req', IIF(ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST'))
                                                                AND a.measure = CASE WHEN ISNULL(s.operation_group, '') = 'W' THEN 'AS_In_Req' WHEN s.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
			  													AND a.qty>0	
																AND a.division_id = @v_division_id
																--AND (( @p_item_id IS NULL OR  @p_item_id = '' ) OR b.model_id     IN (SELECT token FROM dbo.String_Split(@p_item_id		,',')) )
																AND d.OPERATION_GROUP_ID <> 'E'
																--ESS 팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
																AND EXISTS (SELECT *
																			FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
																		   WHERE DIVISION_ID = @v_division_id
																			 AND PARENT_ITEM_ID= b.child_item_id
																			 --BOM을 제거모델 조회안되도록 수정
																			 AND EFF_END_DATE >= GETDATE()
																			 AND KEY_DATE = ( SELECT MAX(KEY_DATE)
																							 FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
																							WHERE PARENT_ITEM_ID= b.child_item_id --'ECE0315N1-01'
																 							  AND DIVISION_ID = @v_division_id )
																		   )
																) m
															) n
													GROUP BY division_id , scm_site_id,project_code
															,model_id, tot_cnt
												) u  ON t.division_id  = u.division_id
													AND t.SCM_SITE_ID  = u.SCM_SITE_ID
													AND t.project_code = u.project_code
													AND t.item_id      = u.model_id
								/******************end of 수량카운트********************************************************************************************/

								 INNER JOIN  (SELECT division_id
		   											,item_id
		   											,nick_name
		   											,item_type
		   											,ROW_NUMBER() OVER ( PARTITION BY division_id, item_id ORDER BY  CASE item_type WHEN 'P' THEN 999 WHEN 'H' THEN 888 WHEN 'R' THEN 777  WHEN 'Q' THEN 666 ELSE 0 END  DESC ) nums
											   FROM SCM_MST_ITEM_SN  WITH(NOLOCK)
											   ) i   ON t.division_id  = i.division_id
													AND t.item_id      = i.item_id
													AND i.nums =1
							WHERE 1=1
							 AND i.item_type NOT IN ('Q','R')	

							 /* PJ20214907 */
							 --AND t.measure in ('VMI_In_Req',  'MKT_FCST')
							 AND t.measure in ('VMI_In_Req',  'MKT_FCST', 'AS_In_Req')
							 --AND t.qty>0	
							 AND t.division_id=@v_division_id
							 AND ( ( @p_status       IS NULL OR  @p_status       ='' ) OR u.cmpltd_status IN (SELECT token FROM dbo.String_Split(@p_status		,',')) )
						   ;
						END

					BEGIN
						DECLARE @mQuery NVARCHAR(MAX);
						DECLARE @mEXEC NVARCHAR(MAX);

						SET @mQuery = '';

						--  날짜 컬럼 생성
						SELECT @mQuery = @mQuery + '[' + month + '], '
						FROM ( 	SELECT a.basis_yyyymm  AS month
										,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
								FROM [dbo].[scm_sys_calendar_m] a  WITH(NOLOCK)
								WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
								GROUP BY a.basis_yyyymm, a.month_name	
								) AS A
						ORDER BY month  ;

						-- PIVOT 쿼리 실행
						SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);

						SET @mEXEC = '';
						SET @mEXEC = @mEXEC + ' INSERT #TblDynamicPivot_ProjectRoute	 '+CHAR(10);
						SET @mEXEC = @mEXEC+'      SELECT DISTINCT '+@v_from_yyyymmdd+' AS PLAN_START_YYYYMMDD'+CHAR(10);
						SET @mEXEC = @mEXEC+'				, division_id, scm_site_id '+CHAR(10);
						SET @mEXEC = @mEXEC+'            , project_code, item_id, plant_per_item, cmpltd_status '+CHAR(10);
						
                        -- PJ20216891
						-- IF( @v_division_id = '81' )
						-- IF( @v_division_id IN ('81', '81_UC') )
						-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영 
						IF EXISTS (SELECT TOP 1 *
									 FROM SCM_MST_DIVISION WITH(NOLOCK)
									WHERE 1=1
									  AND DIVISION_ID = @v_division_id  
									  AND ATTRIBUTE3 = '81' 
									  AND VALID_YN	 = 'Y' )
							BEGIN SET @mEXEC = @mEXEC+'      FROM #TblDynamicPivot_ProjectRoute_tmp1 '+CHAR(10);	END
						ELSE 
							BEGIN SET @mEXEC = @mEXEC+'      FROM #TblDynamicPivot_ProjectRoute_tmp2 '+CHAR(10); END
						--SET @mEXEC = @mEXEC+'       PIVOT ( ' +CHAR(10);
						--SET @mEXEC = @mEXEC+'               SUM(qty) FOR  month IN ('+ @mQuery +') '+CHAR(10);
						--SET @mEXEC = @mEXEC+'             ) AS A'  +CHAR(10);
						SET @mEXEC = @mEXEC+'	   ORDER BY division_id, cmpltd_status, plant_per_item '+CHAR(10);;

						EXEC (@mEXEC);

					END;
	
					IF OBJECT_ID('tempdb..#TblDynamicPivot_ProjectRoute_tmp1') IS NOT NULL
						DROP TABLE #TblDynamicPivot_ProjectRoute_tmp1

					IF OBJECT_ID('tempdb..#TblDynamicPivot_ProjectRoute_tmp2') IS NOT NULL
						DROP TABLE #TblDynamicPivot_ProjectRoute_tmp2

				END; -- END OF WHILE

		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = '';
		SET @v_log_message = '#TblDynamicPivot_ProjectRoute_tmp';
		SET @v_description = 'CREATE';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			--EE 전극 아이템 추가
			INSERT INTO #TblDynamicPivot_ProjectRoute
			SELECT DISTINCT 
				  @v_from_yyyymmdd AS PLAN_START_YYYYMMDD 
				  
                  -- PJ20216891
				  -- ,'EE' AS DIVISION_ID
				  -- ,CASE WHEN A.DIVISION_ID = '81_UC' THEN 'EE_UC' ELSE 'EE' END AS DIVISION_ID
				  ,DM.ELEC_DIVISION_ID AS DIVISION_ID -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
				  ,'-' AS SCM_SITE_ID
				  ,'-' AS PROJECT_CODE
				  , B.CHILD_ITEM_ID as ITEM_ID
				  ,'' AS plant_per_item
				  ,'N' AS cmpltd_status
			FROM 
			(SELECT DISTINCT P.DIVISION_ID,P.ITEM_ID
							,D.ATTRIBUTE4 AS COMPANY_DV
			  FROM SCP_ANL_PRODUCTION_PLAN P WITH(NOLOCK)
				   -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
				   INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  
						   ON D.DIVISION_ID  = P.DIVISION_ID
						  AND D.ATTRIBUTE3  != 'EE'
						  AND D.VALID_YN	 = 'Y'
						  AND P.DIVISION_ID != '82' -- 82사업부 제외
			  
            -- PJ20216891
			-- WHERE DIVISION_ID IN ('81','40') -- 82사업부 제외
			WHERE 1=1 -- P.DIVISION_ID IN ('81','40','81_UC') -- 82사업부 제외
			   AND PLAN_START_YYYYMMDD >=[dbo].[FN_GET_BUCKET_YYYYMMDD](-1)
			   AND OPERATION_GROUP='A'
			   AND MEASURE ='PROD_PLAN_AMEND'
			) A
			INNER JOIN ( -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영 
						SELECT ATTRIBUTE4		AS COMPANY_DV
							  ,MAX(DIVISION_ID) AS ELEC_DIVISION_ID
						  FROM SCM_MST_DIVISION WITH(NOLOCK)
						WHERE 1=1
						  AND ATTRIBUTE3 = 'EE'
						  AND VALID_YN	 = 'Y'
						GROUP BY ATTRIBUTE4 
					 ) DM
				  ON DM.COMPANY_DV = A.COMPANY_DV
			, SCM_MST_MODEL_FINAL_ITEM_BOM_V B  WITH(NOLOCK)
				JOIN SCM_ADM_LOOKUP_MASTER C  WITH(NOLOCK) ON C.LOOKUP_TYPE='OPERATION_GROUP' AND C.VALID_YN='Y'
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D  WITH(NOLOCK)
				  ON D.LOOKUP_TYPE=C.LOOKUP_TYPE 
				 AND D.VALID_YN='Y' 
				 AND D.SEGMENT1='E' -- B.OPERATION_GROUP_ID
			WHERE 1=1
			  AND A.DIVISION_ID = B.DIVISION_ID
			  AND A.ITEM_ID = B.MODEL_ID
			  AND B.OPERATION_GROUP_ID ='E'
			  AND B.OPERATION_GROUP_ID = 'E'
			  AND NOT EXISTS ( SELECT '*'
								 FROM SCM_MST_SITE_ITEM_PRIORITY T WITH(NOLOCK)
								WHERE T.DIVISION_ID = B.DIVISION_ID
								  AND T.ITEM_ID     = B.CHILD_ITEM_ID
								  AND T.VALID_YN ='Y' )					  
			UNION ALL
			SELECT DISTINCT 
				  @v_from_yyyymmdd AS PLAN_START_YYYYMMDD
				  
                  -- PJ20216891
				  -- ,'EE' AS DIVISION_ID
				  -- ,CASE WHEN A.division_id = '81_UC' THEN 'EE_UC' ELSE 'EE' END AS DIVISION_ID
				  ,A.ELEC_DIVISION_ID	AS DIVISION_ID	-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영 
				  ,'-' AS SCM_SITE_ID
				  ,A.project_code
				  ,A.item_id
				  ,'' AS plant_per_item
				  ,'Y' AS cmpltd_status
			FROM (
			SELECT 
					CONVERT(NVARCHAR(MAX), t.priority_seq) AS priority_seq
					,t.division_id
					,dm.elec_division_id	-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영 
					,ISNULL(NULLIF(t.project_code,''),'-') project_code
					,t.item_id
					,ISNULL(NULLIF(t.SALES_SITE_ID,''),'-') AS scm_site_id
					,T.PLANT_SITE_ID 
					,t.priority
					,t.valid_yn
					,t.valid_yn as org_valid_yn
					,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.from_yyyymmdd),121) AS from_yyyymmdd 
					,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.to_yyyymmdd)  ,121) AS to_yyyymmdd 
					,t.created_by
					,t.creation_date
					,t.last_updated_by
					,t.last_update_date
					,s.OPERATION_GROUP
					,t.from_yyyymmdd AS org_from_yyyymmdd
					,t.to_yyyymmdd AS org_to_yyyymmdd
					,t.from_yyyymmdd + t.to_yyyymmdd AS merge_date
					,'' as is_pass_n1
					,'' as is_pass_n2
					,'' as is_pass_n3
					,'' as is_pass_n4
					,'' as is_pass_n5
					,'' as is_pass_n6
					,'' as is_pass_n7
					, dbo.FN_GET_ITEM_NICKNAME (t.division_id, t.item_id ) AS nick_name
					, B.SEGMENT2 OPERATION_GROUP_NAME
					, '-' ACTION_FLAG_DIV
					, 0 ROW_COLOR_INDEX
					, 1 SORT_ORDER
					, ISNULL((
						SELECT COUNT(c.PLANT_SITE_ID) FROM SCP_MST_TACT_TIME c  WITH(NOLOCK)
													JOIN SCM_MST_LINE_SN LS  WITH(NOLOCK)  ON LS.COMPANY_ID=S.COMPANY_ID AND LS.DIVISION_ID=C.DIVISION_ID AND LS.SITE_ID=S.SITE_ID AND LS.PLANT_ID=S.PLANT_ID
																				AND LS.OPERATION_ID=C.OPERATION_ID AND LS.LINE_ID=C.LINE_ID AND LS.ACTIVE_FLAG='Y'
								 WHERE 1=1
								   AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR c.division_id      IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
								  -- AND c.DIVISION_ID = @p_division_id
								   AND c.ITEM_ID = t.item_id
								   AND c.VALID_YN='Y' 		
								   AND c.PLANT_SITE_ID = s.scm_site_id
								 GROUP BY c.ITEM_ID , c.PLANT_SITE_ID
					 ),0) TACT_CNT
					 ,ISNULL((
						SELECT COUNT(c.PLANT_SITE_ID) FROM SCP_MST_OUTSOURCING_CAPA  c WITH(NOLOCK)
								 WHERE 1=1
								   AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR c.division_id      IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
								   AND c.ITEM_ID = t.item_id
								   AND c.VALID_YN ='Y'
								   AND c.PLANT_SITE_ID = s.scm_site_id
								 GROUP BY c.PLANT_SITE_ID, c.item_id
					 ),0) OUT_CAPA_CNT
					 , s.SITE_DESCRIPTION
				FROM scm_mst_site_item_priority t WITH(NOLOCK)
				    -- begin [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영 
					JOIN scm_mst_division d  WITH(NOLOCK)
				      ON d.division_id = t.division_id
					 AND d.valid_yn	   = 'Y'
					JOIN (	SELECT ATTRIBUTE4		AS COMPANY_DV
								  ,MAX(DIVISION_ID) AS ELEC_DIVISION_ID
							  FROM SCM_MST_DIVISION WITH(NOLOCK)
							WHERE 1=1
							  AND ATTRIBUTE3 = 'EE'
							  AND VALID_YN	 = 'Y'
							GROUP BY ATTRIBUTE4 
						) DM
				      ON DM.COMPANY_DV = D.ATTRIBUTE4
				    -- end [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영 
					JOIN scm_mst_site s WITH(NOLOCK) 
					  ON ( (t.division_id = s.division_id and s.OPERATION_GROUP!='E') OR (s.OPERATION_GROUP='E') )
					 and t.PLANT_SITE_ID = s.scm_site_id
					JOIN SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK) 
					  ON A.LOOKUP_TYPE='OPERATION_GROUP' 
					 AND A.VALID_YN='Y'
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
					  ON B.LOOKUP_TYPE=A.LOOKUP_TYPE 
					 AND B.VALID_YN='Y' 
					 AND B.SEGMENT1=s.OPERATION_GROUP
				WHERE s.site_type     = 'PLANT'
					AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR T.division_id      IN (SELECT value FROM dbo.FN_SplitString(@p_division_id  ,',')) )
					AND s.OPERATION_GROUP = 'E'
			) A
			;

		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = '';
		SET @v_log_message = '#TblDynamicPivot_ProjectRoute';
		SET @v_description = 'INSERT';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO SCM_KPI_PROJECTROUTE_BOM
			(DIVISION_ID, PLAN_START_YYYYMMDD, PROJECT_CODE, SALES_SITE_ID, ITEM_ID, VALID_TYPE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT DIVISION_ID
					, PLAN_START_YYYYMMDD
					, PROJECT_CODE
					, SCM_SITE_ID
					, ITEM_ID
					, CASE WHEN CMPLTD_STATUS='Y' THEN 'OK'
						   WHEN CMPLTD_STATUS='N' AND PLANT_PER_ITEM='BOM' THEN 'NOT_BOM'
						   WHEN CMPLTD_STATUS='N' AND PLANT_PER_ITEM<>'BOM' THEN 'NG'
					  END AS VALID_TYPE
					, @v_batch_user
					, GETDATE()
					, @v_batch_user
					, GETDATE()
			FROM #TblDynamicPivot_ProjectRoute
			;

		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = '';
		SET @v_log_message = 'SCM_KPI_PROJECTROUTE_BOM';
		SET @v_description = 'INSERT';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SET @n_log_count = (SELECT COUNT(*) FROM #TblDynamicPivot_ProjectRoute);

			IF OBJECT_ID('tempdb..#TblDynamicPivot_ProjectRoute') IS NOT NULL
				DROP TABLE #TblDynamicPivot_ProjectRoute;

		END

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
	EXEC PR_SCP_SYS_LOG_BATCH @p_program_name  =@v_program_name
                             ,@p_log_type      =@v_log_type
                             ,@p_log_count     =@n_log_count 
                             ,@p_log_message   =@v_log_message 
                             ,@p_description   =@v_description 
                             ,@p_event_date    =@d_event_date 
                             ,@p_user_id       =@v_batch_user
                             ;
	return 1 

	_RETURN_ERR_CODE:          
		BEGIN          
			RETURN -1          
		END;  
END;

