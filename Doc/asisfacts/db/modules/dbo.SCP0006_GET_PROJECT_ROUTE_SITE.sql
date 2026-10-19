

/*
 * Program ID   : SCP0006_GET_PROJECT_ROUTE_SITE
 * Description  : Project Route Site 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/28   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/01/16   PJS		       피봇쿼리방식으로 변경	
 * 2018/03/26   PJS			   Sales Site(SCM_SITE_ID) 추가
 * 2018/04/10   PJS            등록수량 카운트 조회조건(날짜) 수정
 * 2018/04/17   PJS            임시테이블 삭제 OBJECT_ID형식으로 변경
 * 2018/05/03   byunghunjung   Alternate Part 제외로직 추가
 * 2018/05/17   byunghunjung   전극 제외
 * 2018/05/23   byunghunjung   전극 제외 로직 추가
 * 2018/05/28   byunghunjung   팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
 * 2018/05/28   byunghunjung   dm_pln_mkt_fcst 테이블 조회시 중복제거
 * 2018/06/11   PJS            시작일자 현재일자의 월요일로 고정
 * 2018/06/21   byunghunjung   BOM을 제거모델 조회안되도록 수정
 * 2018/09/14	hwyoon		   Item Type = R 도 보이도록 수정
 * 2018/11/07	hwyoon		   vmi에 따라 MKT measure 조절
 * 2021/04/07	PJG	    	   수량 카운트용 쿼리 데이터 별도 임시테이블 저장
 * 2021/10/05	khj79	       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - W/S AS UI 변경
 * 2022/11/07   jahn1501		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 2025/06/23   KANG.H.J	   [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (강현준)
 *
 ** 비정상적으로 느릴때 db plan cache삭제 필요 : DBCC FREESYSTEMCACHE ('ALL','default') ( cache 삭제는 되도록 하지 않는것이 좋음)
 * ex )
 EXEC SCP0006_GET_PROJECT_ROUTE_SITE @p_division_id='81',@p_scm_site_id='', @p_project_code='', @p_item_id='', @p_from_yyyymm='201802', @p_to_yyyymm='201901', @p_status=NULL,@debug_mode='T' 
 */
CREATE PROCEDURE [dbo].[SCP0006_GET_PROJECT_ROUTE_SITE]
   @p_division_id    NVARCHAR(MAX)
  ,@p_scm_site_id    NVARCHAR(MAX)
  ,@p_project_code   NVARCHAR(MAX)
  ,@p_item_id		 NVARCHAR(MAX)
  ,@p_from_yyyymm	 NVARCHAR(6)
  ,@p_to_yyyymm		 NVARCHAR(6)
  ,@p_status		 NVARCHAR(6)
  ,@debug_mode       NVARCHAR(20) ='F'
AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	
	DECLARE @v_data_cnt nvarchar(8);

    DECLARE @p_from_yyyymmdd     AS NVARCHAR(8)='';
    DECLARE @p_to_yyyymmdd       AS NVARCHAR(8)='';

    DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
    DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
    DECLARE @v_from_result       AS NVARCHAR(8)='';
    DECLARE @v_to_result         AS NVARCHAR(8)='';
	DECLARE @v_unit_date         AS NVARCHAR(8)='';  --현재일 기준의 주(week)의 시작일자

	SET @v_data_cnt =0;

	-- 월의 시작일자 설정
	IF( ISNULL(@p_from_yyyymm ,'') ='') 
		SET @p_from_yyyymmdd =  '';
	ELSE
		SET @p_from_yyyymmdd =  @p_from_yyyymm +'01';
 
   -- from_yyyymmdd는 현재일자의 월요일로 강제설정
   set @p_from_yyyymmdd= (SELECT convert(VARCHAR(8), dateadd(dd, -(dayofweek_no-1),basis_yyyymmDD),112) as basis_start_date
							FROM (
								SELECT (CASE WHEN DAYOFWEEK_NO -1 =0 THEN 7 ELSE dayofweek_no -1 END ) dayofweek_no 
									   ,CONVERT(DATETIME, basis_yyyymmDD) as basis_yyyymmDD
									   ,DAYOFWEEK
								FROM scm_sys_calendar_m 
								WHERE basis_yyyymmdd =convert(VARCHAR(8), GETDATE(),112)
  								) f 
						  ) ;

   print '@p_from_yyyymmdd = ' +@p_from_yyyymmdd;

    -- 월의 마지막일자 설정
	IF( ISNULL(@p_to_yyyymm ,'') ='') 
		SET @p_to_yyyymmdd =  '';
	ELSE
		SET @p_to_yyyymmdd =  convert(varchar, dateadd(day,-1, dateadd(month, 1, convert(datetime,@p_to_yyyymm+'01'))) ,112) ;



	SELECT @v_unit_date = C.BASIS_START_DATE
	  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
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
		END;	

	IF ( @debug_mode ='T')
		BEGIN
			PRINT '';
			PRINT '@p_division_id   = ' + @p_division_id ;
			PRINT '@p_scm_site_id   = ' + @p_scm_site_id ;
			PRINT '@p_project_code  = ' + @p_project_code;
			PRINT '@p_item_id		= ' + @p_item_id	 ;
			PRINT '@p_from_yyyymm	= ' + @p_from_yyyymm ;
			PRINT '@p_to_yyyymm		= ' + @p_to_yyyymm	 ;
			PRINT '@p_status		= ' + @p_status		 ;
			PRINT '@v_from_result	='+ @v_from_result   ;
			PRINT '@v_to_result     ='+ @v_to_result     ;
			PRINT '@v_from_yyyymmdd ='+ @v_from_yyyymmdd ;
			PRINT '@v_to_yyyymmdd   ='+ @v_to_yyyymmdd   ;
			PRINT '';
		END;




	/********************************************************************************

	* 임시테이블만들기

	********************************************************************************/
			
	--IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblDynamicPivot_SCP0006_01%')
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_01') IS NOT NULL
		   DROP TABLE #TblDynamicPivot_SCP0006_01

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_02') IS NOT NULL
		   DROP TABLE #TblDynamicPivot_SCP0006_02

		   
 -- 수량 카운트용 쿼리 데이터 임시테이블 저장
 SELECT division_id
								 ,SCM_SITE_ID
		                         ,project_code								 
								 ,model_id
								 ,CONVERT(VARCHAR, SUM(plant_cnt) ) +'/'+ CONVERT(VARCHAR, tot_cnt) AS plant_per_item
								 ,CASE WHEN SUM(plant_cnt) = tot_cnt THEN 'Y' ELSE 'N' END cmpltd_status
						    INTO #TblDynamicPivot_SCP0006_02
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
												  --WHEN d.operation_group_id = 'E' THEN 'Electrode'
												  WHEN d.operation_group_id = 'A' THEN 'Cell'
												  WHEN d.operation_group_id = 'P' THEN 'Pack'
												  END ) AS operation_group_id
											   ,d.electrode_type
											   ,b.child_item_id AS item_id
											  ,(SELECT rownumber 
												 FROM (		
														SELECT ROW_NUMBER() OVER (ORDER BY from_yyyymmdd) AS rownumber
												 		 FROM scm_mst_site_item_priority s 
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
										FROM dm_pln_mkt_fcst a 
										    -- 2021.03.25 대체 BOM 모델링
											INNER JOIN SCM_MST_BOM_SN_V b    ON a.division_id   = b.division_id
											--JOIN scm_mst_bom_sn b    ON a.division_id   = b.division_id
																	and a.item_id       = b.model_id 	
											INNER JOIN scm_mst_item_sn c   ON b.company_id    = c.company_id 
																	and b.division_id   = c.division_id	
																	and b.site_id       = c.site_id 
																	and b.child_item_id = c.item_id
											INNER JOIN scm_mst_final_item_v d  ON b.division_id = d.division_id  and b.child_item_id = d.item_id
											--2021/10/05 : W/S AS
											--LEFT JOIN scm_mst_site s ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
											LEFT JOIN SCM_MST_SITE S ON S.DIVISION_ID=A.DIVISION_ID 
																	AND S.SCM_SITE_ID=A.SCM_SITE_ID 
																	AND (S.VMI_YN='Y' OR ( SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W'))
										WHERE 1=1
										--AND c.item_type		<> 'r'
										--  실적(등록된 카운트)수량은 분기되기 이전 날짜 전체를 사용해야 카운트가 맞음
										--Alternate Part 제외로직 추가
										AND	b.alt_priority ='Y'
										AND a.yyyymmdd >= @p_from_yyyymmdd
										AND a.yyyymmdd <= @p_to_yyyymmdd
									 	--AND a.measure ='MKT_FCST'
										--2021/10/05 : W/S AS
										--AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
										--2022/11/07
										--AND A.MEASURE = IIF(ISNULL(S.OPERATION_GROUP, '') = 'W', 'AS_In_Req', IIF(S.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST'))
										AND A.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '') = 'W' THEN 'AS_In_Req' WHEN S.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
			  							AND a.qty>0	
										AND a.division_id  = @p_division_id
										AND (( @p_project_code IS NULL OR  @p_project_code ='' ) OR a.project_code IN (SELECT token FROM dbo.String_Split(@p_project_code	,',')) )
										AND (( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR b.model_id     IN (SELECT token FROM dbo.String_Split(@p_item_id		,',')) )
										AND d.OPERATION_GROUP_ID <> 'E'
										--팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
										AND EXISTS (SELECT *
													FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
												   WHERE DIVISION_ID = @p_division_id
													 AND PARENT_ITEM_ID= b.child_item_id
													--BOM을 제거모델 조회안되도록 수정
													AND EFF_END_DATE >= GETDATE()
													AND KEY_DATE = ( SELECT MAX(KEY_DATE)
																	 FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
																    WHERE PARENT_ITEM_ID= b.child_item_id --'ECE0315N1-01'
																 	  AND DIVISION_ID = @p_division_id )
												   )
									) m
								) n
							GROUP BY division_id, SCM_SITE_ID,project_code, model_id, tot_cnt
 
	SELECT 
		 t.division_id
        ,dbo.fn_get_division_name(t.division_id) AS division_name
		,t.scm_site_id 
		,t.project_code
		,t.item_id 
		,CASE WHEN  u.plant_per_item is null  THEN 'BOM Not Exists' ELSE  u.plant_per_item END AS plant_per_item 
		,isnull(u.cmpltd_status,'N') AS cmpltd_status
		,substring(yyyymmdd,1,6) AS month 
		,t.qty
	INTO #TblDynamicPivot_SCP0006_01
	FROM ( select distinct a.division_id,project_code,a.scm_site_id,a.item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id,yyyymmdd,qty 
	         from dm_pln_mkt_fcst a 
			 INNER JOIN scm_mst_item_sn b ON a.division_id = b.division_id and a.item_id= b.item_id
			 --2021/10/05 : W/S AS
			 --LEFT JOIN scm_mst_site s ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
			 LEFT JOIN SCM_MST_SITE S ON S.DIVISION_ID=A.DIVISION_ID 
									AND S.SCM_SITE_ID=A.SCM_SITE_ID 
									AND (S.VMI_YN='Y' OR ( SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W'))
	        WHERE 1=1 
			  --AND a.measure ='MKT_FCST'
			  --2021/10/05 : W/S AS
			  --AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
	          --2022/11/07
			  --AND A.MEASURE = IIF(ISNULL(S.OPERATION_GROUP, '') = 'W', 'AS_In_Req', IIF(S.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST'))
	          AND A.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '') = 'W' THEN 'AS_In_Req' WHEN S.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
			  AND b.scp_operation_group_id <> 'E'
			  AND a.yyyymmdd >= @v_from_yyyymmdd
			  AND a.yyyymmdd <= @v_to_yyyymmdd
			  and a.yyyymmdd != '' and a.yyyymmdd is not null
			  
		      AND a.division_id  = @p_division_id
	          AND a.qty>0	
		      AND ( ( @p_scm_site_id  IS NULL OR  @p_scm_site_id  ='' ) OR a.scm_site_id   IN (SELECT token FROM dbo.String_Split(@p_scm_site_id	,',')) ) /* 20180326 sale site 추가부분 */
		      AND ( ( @p_project_code IS NULL OR  @p_project_code ='' ) OR a.project_code  IN (SELECT token FROM dbo.String_Split(@p_project_code	,',')) )
		      AND ( ( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR a.item_id       IN (SELECT token FROM dbo.String_Split(@p_item_id		,',')) )

			union all

		   select -- distinct	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가(DISTINCT 제거)
		   		a.division_id,project_code,a.scm_site_id,a.item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id,yyyymmdd
				--, qty
				,SUM(qty) AS QTY			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID 추가됨에 따라 GROUP BY에 의해 SUM(QTY) 처리)
	         from dbo.DM_PLN_MKT_FCST_RESULT a WITH(NOLOCK)
	         INNER JOIN scm_mst_item_sn b WITH(NOLOCK) ON a.division_id = b.division_id and a.item_id= b.item_id
			 --2021/10/05 : W/S AS
			 --LEFT JOIN scm_mst_site s ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
			 LEFT JOIN SCM_MST_SITE S WITH(NOLOCK) 
									ON S.DIVISION_ID=A.DIVISION_ID 
									AND S.SCM_SITE_ID=A.SCM_SITE_ID 
									AND (S.VMI_YN='Y' OR ( SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W'))
	        WHERE 1=1 
			  --AND a.measure ='MKT_FCST'
			  --2021/10/05 : W/S AS
			  --AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
	          --2022/11/07
			  --AND A.MEASURE = IIF(ISNULL(S.OPERATION_GROUP, '') = 'W', 'AS_In_Req', IIF(S.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST'))
	          AND A.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '') = 'W' THEN 'AS_In_Req' WHEN S.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
			  AND b.scp_operation_group_id <> 'E'
			  AND a.yyyymmdd >= @v_from_result
			  AND a.yyyymmdd <= @v_to_result
			  and a.yyyymmdd != '' and a.yyyymmdd is not null	
			  
		      AND a.division_id  = @p_division_id
	          AND a.qty>0	
		      AND ( ( @p_scm_site_id  IS NULL OR  @p_scm_site_id  ='' ) OR a.scm_site_id   IN (SELECT token FROM dbo.String_Split(@p_scm_site_id	,',')) ) /* 20180326 sale site 추가부분 */
		      AND ( ( @p_project_code IS NULL OR  @p_project_code ='' ) OR a.project_code  IN (SELECT token FROM dbo.String_Split(@p_project_code	,',')) )
		      AND ( ( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR a.item_id       IN (SELECT token FROM dbo.String_Split(@p_item_id		,',')) )	
			GROUP BY a.division_id,project_code,a.scm_site_id,a.item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id,yyyymmdd		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID 추가됨에 따라 GROUP BY에 의해 SUM(QTY) 처리)
	     ) t  

		 LEFT OUTER JOIN #TblDynamicPivot_SCP0006_02 u  ON t.division_id  = u.division_id
			                                           AND t.SCM_SITE_ID  = u.SCM_SITE_ID
						                               AND t.project_code = u.project_code
						                               AND t.item_id      = u.model_id

		 /*******************start of 수량 카운트 부분 ********************************************************************************/
		 --LEFT OUTER JOIN  (SELECT division_id
			--					 ,SCM_SITE_ID
		 --                        ,project_code								 
			--					 ,model_id
			--					 ,CONVERT(VARCHAR, SUM(plant_cnt) ) +'/'+ CONVERT(VARCHAR, tot_cnt) AS plant_per_item
			--					 ,CASE WHEN SUM(plant_cnt) = tot_cnt THEN 'Y' ELSE 'N' END cmpltd_status
			--				FROM (
			--					SELECT division_id,SCM_SITE_ID, project_code, model_id, COUNT(*) OVER(PARTITION BY division_id,SCM_SITE_ID,project_code,model_id) AS tot_cnt, CASE WHEN primary_plant IS NOT NULL THEN 1 ELSE 0 END AS plant_cnt
			--					FROM (
			--							SELECT DISTINCT	
			--							         (CASE 
			--									  WHEN dbo.FN_GET_ITEM_OPERATION_GROUP(a.division_id, a.item_id) = 'E' THEN C.ITEM_ID
			--									  ELSE b.model_id	
			--									  END ) AS model_id	
			--								   , (CASE 
			--									  -- 전극 제외 20180517
			--									  --WHEN d.operation_group_id = 'E' THEN 'Electrode'
			--									  WHEN d.operation_group_id = 'A' THEN 'Cell'
			--									  WHEN d.operation_group_id = 'P' THEN 'Pack'
			--									  END ) AS operation_group_id
			--								   ,d.electrode_type
			--								   ,b.child_item_id AS item_id
			--								  ,(SELECT rownumber 
			--									 FROM (		
			--											SELECT ROW_NUMBER() OVER (ORDER BY from_yyyymmdd) AS rownumber
			--									 		 FROM scm_mst_site_item_priority s 
			--											WHERE s.division_id   = b.division_id
			--											  AND s.item_id       = b.child_item_id 
			--											  AND s.project_code  = a.project_code
			--											  AND s.SALES_SITE_ID = a.SCM_SITE_ID /* 20180326 sales site 추가부분 */
			--											  AND s.to_yyyymmdd  >= convert(varchar, getdate(),112) 
			--											  AND s.valid_yn = 'Y'
			--											  AND s.priority = '1'
	 	--												) a 
			--									 WHERE rownumber =1
			--									) AS primary_plant
			--								 ,b.division_id
			--								 ,a.SCM_SITE_ID
			--								 ,a.project_code			
			--							FROM dm_pln_mkt_fcst a 
			--								JOIN scm_mst_bom_sn b    ON a.division_id   = b.division_id
			--														and a.item_id       = b.model_id 	
			--								JOIN scm_mst_item_sn c   ON b.company_id    = c.company_id 
			--														and b.division_id   = c.division_id	
			--														and b.site_id       = c.site_id 
			--														and b.child_item_id = c.item_id
			--								JOIN scm_mst_final_item_v d  ON b.division_id = d.division_id  and b.child_item_id = d.item_id
			--								LEFT JOIN scm_mst_site s ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
			--							WHERE 1=1
			--							--AND c.item_type		<> 'r'
			--							--  실적(등록된 카운트)수량은 분기되기 이전 날짜 전체를 사용해야 카운트가 맞음
			--							--Alternate Part 제외로직 추가
			--							AND	b.alt_priority ='Y'
			--							AND a.yyyymmdd >= @p_from_yyyymmdd
			--							AND a.yyyymmdd <= @p_to_yyyymmdd
			--						 	--AND a.measure ='MKT_FCST'
			--							AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
			--  							AND a.qty>0	
			--							AND a.division_id  = @p_division_id
			--							AND (( @p_project_code IS NULL OR  @p_project_code ='' ) OR a.project_code IN (SELECT token FROM dbo.String_Split(@p_project_code	,',')) )
			--							AND (( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR b.model_id     IN (SELECT token FROM dbo.String_Split(@p_item_id		,',')) )
			--							AND d.OPERATION_GROUP_ID <> 'E'
			--							--팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
			--							AND EXISTS (SELECT *
			--										FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
			--									   WHERE DIVISION_ID = @p_division_id
			--										 AND PARENT_ITEM_ID= b.child_item_id
			--										--BOM을 제거모델 조회안되도록 수정
			--										AND EFF_END_DATE >= GETDATE()
			--										AND KEY_DATE = ( SELECT MAX(KEY_DATE)
			--														 FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
			--													    WHERE PARENT_ITEM_ID= b.child_item_id --'ECE0315N1-01'
			--													 	  AND DIVISION_ID = @p_division_id )
			--									   )
			--						) m
			--					) n
			--				GROUP BY division_id, SCM_SITE_ID,project_code, model_id, tot_cnt
			--			) u  ON t.division_id  = u.division_id
			--			    AND t.SCM_SITE_ID  = u.SCM_SITE_ID
			--			    AND t.project_code = u.project_code
			--			    AND t.item_id      = u.model_id
		/******************end of 수량카운트********************************************************************************************/

		 INNER MERGE JOIN  scm_mst_site_item v  ON t.division_id  = v.division_id 
										and t.item_id      = v.item_id
										and t.scm_site_id  = v.scm_site_id 
										and t.project_code = v.project_code
         INNER JOIN  (SELECT division_id
		   				    ,item_id
		   				    ,nick_name
		   					,item_type
		   					,ROW_NUMBER() OVER ( PARTITION BY division_id, item_id ORDER BY  CASE item_type WHEN 'P' THEN 999 WHEN 'H' THEN 888 WHEN 'R' THEN 777  WHEN 'Q' THEN 666 ELSE 0 END  DESC ) nums
					   FROM SCM_MST_ITEM_SN 
					   ) i   ON t.division_id  = i.division_id
						    AND t.item_id      = i.item_id
							AND i.nums =1
	WHERE 1=1
	  AND i.item_type NOT IN ('Q','R')	
	  --AND t.measure ='MKT_FCST'
	  --2021/10/05 : W/S AS
	  --AND t.measure in ('VMI_In_Req',  'MKT_FCST')
	  AND t.measure in ('AS_In_Req','VMI_In_Req',  'MKT_FCST')
	  --AND t.qty>0	
		--AND t.division_id  = @p_division_id
		--AND ( ( @p_scm_site_id  IS NULL OR  @p_scm_site_id  ='' ) OR t.scm_site_id   IN (SELECT token FROM dbo.String_Split(@p_scm_site_id	,',')) ) /* 20180326 sale site 추가부분 */
		--AND ( ( @p_project_code IS NULL OR  @p_project_code ='' ) OR t.project_code  IN (SELECT token FROM dbo.String_Split(@p_project_code	,',')) )
		--AND ( ( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR t.item_id       IN (SELECT token FROM dbo.String_Split(@p_item_id		,',')) )
		AND ( ( @p_status       IS NULL OR  @p_status       ='' ) OR u.cmpltd_status IN (SELECT token FROM dbo.String_Split(@p_status		,',')) )
    --OPTION(RECOMPILE)
   ;
   
	BEGIN
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

		SET @mQuery = '';

		--  날짜 커럼 생성
		SELECT @mQuery = @mQuery + '[' + month + '], '
		FROM ( 	SELECT a.basis_yyyymm  AS month
						,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a
				WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				GROUP BY a.basis_yyyymm, a.month_name	
                ) AS A
		ORDER BY month  ;


		-- PIVOT 쿼리 실행
		SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);

		SET @mEXEC = '';
		SET @mEXEC = @mEXEC+'      SELECT  division_id, division_name,scm_site_id, dbo.FN_GET_SCM_SITE_DESCRIPTION(division_id,scm_site_id) AS scm_site_name '+CHAR(10);		
		SET @mEXEC = @mEXEC+'            , project_code, item_id, plant_per_item, cmpltd_status '+CHAR(10);
		SET @mEXEC = @mEXEC+' 			,  dbo.fn_get_item_nickname (division_id, item_id ) AS nick_name '+CHAR(10);
		SET @mEXEC = @mEXEC+' 			,'+@mQuery	+CHAR(10);
		SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SCP0006_01 '+CHAR(10);
		SET @mEXEC = @mEXEC+'       PIVOT ( ' +CHAR(10);
		SET @mEXEC = @mEXEC+'               SUM(qty) FOR  month IN ('+ @mQuery +') '+CHAR(10);
		SET @mEXEC = @mEXEC+'             ) AS A'  +CHAR(10);
		SET @mEXEC = @mEXEC+'	   ORDER BY division_id, cmpltd_status, plant_per_item '+CHAR(10);;

		IF( @debug_mode ='T') PRINT @mEXEC;
			
		EXEC (@mEXEC);
			

	END;
	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_01') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0006_01

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0006_01') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0006_01
								  
END
