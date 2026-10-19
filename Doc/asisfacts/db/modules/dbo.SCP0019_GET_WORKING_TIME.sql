
/*
 * Program ID   : SCP0019_GET_WORKING_TIME
 * Description  : WORKING TIME 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/12   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/04/17   PJS				임시테이블 삭제 OBJECT_ID형식으로 변경
 * 2018/05/29   byunghunjung	Working Time Default 컬럼 추가
 * 2018/08/07	YHW				LINE_NAME 조회추가
 * 2018/08/07	byunghunjung	Line Active Flag = Y 추가
 * 2018/08/08   ygkim			operation 조회조건 수정
 * 2019/03/25	KSG             [재료본부 전지재료 GSCM 구축 프로젝트] 재료는 SHOP_GROUP_ID 정보 없음 (190415 전지재료 삭제)
 * 2020/02/06   khj79		    [C20200116-000114] ESS 외주 Packer Line 계획 수립 - 외주사 workingtime 정보 수정하도록 개발
 * 2020/10/26   khj79           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2021/09/14   khj79           [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 외주만 조회/수정 가능하도록 변경
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * EX)
 * EXEC [SCP0019_GET_WORKING_TIME] @p_from_yyyymmdd='20180301', @p_to_yyyymmdd='20180331', @p_division_id='81', @p_plant_site_id='A040-A', @p_factory_id='',@p_operation_id='', @p_line_id='',@debug_mode='T'
 */
CREATE PROCEDURE [dbo].[SCP0019_GET_WORKING_TIME]
   @p_from_yyyymmdd NVARCHAR(8)
  ,@p_to_yyyymmdd   NVARCHAR(8)
--chaan  ,@p_division_id	NVARCHAR(2)
  ,@p_division_id	NVARCHAR(30)--chaan
  ,@p_plant_site_id	NVARCHAR(MAX)
  ,@p_factory_id	NVARCHAR(MAX)
  ,@p_operation_id	NVARCHAR(MAX)
  ,@p_line_id		NVARCHAR(MAX)
  ,@debug_mode		NVARCHAR(20)  ='F'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	--if OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0019') is not null 
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0019') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0019;

	SELECT a.division_id
		  --,a.division_name	
		  ,a.plant_site_id
		  --,a.plant_site_name
		  ,a.factory_id
		  ,a.factory_name
		  ,a.operation_id
		  ,a.operation_name
		  ,a.line_id
		  ,a.LINE_NAME
		  ,c.working_time_default
		  --,a.line_name
		  , ( SELECT MAX(yyyymmdd) 
				FROM scp_mst_working_time t 
			   WHERE t.division_id = a.division_id 
				AND t.plant_site_id = a.plant_site_id 
				AND t.factory_id = a.factory_id 
				AND t.operation_id = a.operation_id 
				AND t.line_id = a.line_id 
				AND t.working_time is not null) as last_input_date 
		  ,a.measure
		  ,'D_'+a.yyyymmdd as yyyymmdd
		  ,a.yyyymm as yyyymm
		  ,a.iso_week
		  ,b.working_time as qty
		  ,a.OSP_YN
		  into #TblDynamicPivot_SCP0019
	  FROM(
			-- 2021-09-14 : 외주만 조회/수정 가능하도록 주석처리, khj79
			/*
			SELECT  DISTINCT
					 l.division_id
					,s.scm_site_id  as plant_site_id
					,l.factory_id
					,l.operation_id
					,l.line_id
					,l.LINE_NAME
					--,dbo.fn_get_division_name ( l.division_id ) as division_name
					--,(select TOP 1 d.DIVISION_NAME from SCM_MST_DIVISION d where d.DIVISION_ID = l.division_id) as division_name
					--,dbo.fn_get_scm_site_description ( l.division_id, s.scm_site_id ) as plant_site_name
					--, (select max(d.SITE_DESCRIPTION) from SCM_MST_SITE d where 1=1 and d.SCM_SITE_ID = s.scm_site_id group by d.SCM_SITE_ID) as plant_site_name
					,f.factory_name
					,o.operation_name
					--,l.line_name
					,'Working Time(Min)' as measure
					,p.BASIS_YYYYMMDD as yyyymmdd
				    ,p.basis_yyyymm as yyyymm
				    ,RIGHT(p.basis_yyyymm,2)+p.iso_week as iso_week
					,l.operation_id as operation
					,S.OSP_YN
				FROM SCM_MST_LINE_SN L 
				JOIN SCM_MST_SITE S          on l.company_id   = s.company_id 
											AND l.division_id  = s.division_id 
											AND l.site_id      = s.site_id 
											AND l.plant_id     = s.plant_id 
				JOIN SCM_MST_FACTORY_SN f    on l.company_id   = f.company_id 
											AND l.division_id  = f.division_id 
											AND l.site_id      = f.site_id 
											AND l.plant_id     = f.plant_id 
											AND l.factory_id   = f.factory_id 
											AND s.operation_group = f.shop_group_id
											-- 20190325 재료는 SHOP_GROUP_ID 정보 없음 (190415 전지재료 삭제)
											--AND S.OPERATION_GROUP = CASE WHEN f.DIVISION_ID IN ('42', '44') THEN SUBSTRING(l.OPERATION_ID, 1, 2)
											--                             ELSE f.SHOP_GROUP_ID
											--					    END
				JOIN SCM_MST_OPERATION_SN o  on l.company_id   = o.company_id 
											AND l.division_id  = o.division_id 
											AND l.site_id      = o.site_id 
											AND l.operation_id = o.operation_id
											
				CROSS JOIN scm_sys_calendar_m p 	
			    WHERE 1=1
				  -- Active Flag = Y 추가
				  AND l.active_flag ='Y'
 				  AND l.operation_id IN (
											SELECT DISTINCT b.SEGMENT4
											FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
											WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
											AND    b.valid_yn = 'Y'
											AND    b.segment3 = 'Y')
			      AND p.BASIS_YYYYMMDD >=@p_from_yyyymmdd
				  AND p.BASIS_YYYYMMDD <=@p_to_yyyymmdd
				  AND s.site_type    = 'PLANT'
				  AND s.valid_yn	 = 'Y'
				  AND s.division_id  = @p_division_id
				  AND ( ( @p_plant_site_id IS NULL OR  @p_plant_site_id = '' ) OR s.scm_site_id   IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )
				  AND ( ( @p_operation_id  IS NULL OR  @p_operation_id  = '' ) OR l.operation_id  IN (SELECT token FROM dbo.String_Split(@p_operation_id  ,',')) )
				  AND ( ( @p_line_id       IS NULL OR  @p_line_id       = '' ) OR l.line_id       IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
				  AND ( ( @p_factory_id    IS NULL OR  @p_factory_id    = '' ) OR l.factory_id       IN (SELECT token FROM dbo.String_Split(@p_factory_id  ,',')) )
				
				UNION
				*/
				--2021-09-14 : 외주만 조회/수정 가능하도록 주석처리 끝, khj79 
				-- 외주 packer 추가 (2018.04.19)
				SELECT  DISTINCT
					 s.division_id
					,s.scm_site_id  as plant_site_id
					,'-' as factory_id
					,s.plant_id as operation_id
					,'-' as line_id
					,'-' as line_name
					--,dbo.fn_get_division_name ( s.division_id ) as division_name
					--,(select TOP 1 d.DIVISION_NAME from SCM_MST_DIVISION d where d.DIVISION_ID = s.division_id) as division_name
					--,dbo.fn_get_scm_site_description ( s.division_id, s.scm_site_id ) as plant_site_name
					--, (select max(d.SITE_DESCRIPTION) from SCM_MST_SITE d where 1=1 and d.SCM_SITE_ID = s.scm_site_id group by d.SCM_SITE_ID) as plant_site_name
					,'-' as factory_name
					,s.plant_id as operation_name
					--,'-' as line_name
					,'Working Time(Min)' as measure
					,p.BASIS_YYYYMMDD as yyyymmdd
				    ,p.basis_yyyymm as yyyymm
				    ,RIGHT(p.basis_yyyymm,2)+p.iso_week as iso_week
					,'VENDOR' as operation
					,S.OSP_YN
				FROM SCM_MST_SITE S
				CROSS JOIN scm_sys_calendar_m p 	
			    WHERE 1=1
			      AND p.BASIS_YYYYMMDD >=@p_from_yyyymmdd
				  AND p.BASIS_YYYYMMDD <=@p_to_yyyymmdd
				  AND s.site_type    = 'PLANT'
				  AND s.valid_yn	 = 'Y'
				  AND s.osp_yn	     ='Y'
				  AND s.division_id  = @p_division_id
				  AND ISNULL(s.attribute1,'N') <> 'Y'   -- line 등록 외주사 제외
				  AND ( ( @p_plant_site_id IS NULL OR  @p_plant_site_id = '' ) OR s.scm_site_id   IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )
				  UNION
				  -- line 등록 외주 추가 (2020.02.06)
				SELECT s.division_id
					 , s.scm_site_id as plant_site_id
					 , '-'           as factory_id
					 , o.operation_id	as operation_id -- PJ20202001 : RACK 구분
					 --, s.plant_id		as operation_id -- 수정 전
					 , o.line_id
					 , o.line_name
					 , '-'           as factory_name
					 , o.operation_id	as operation_name -- PJ20202001 : RACK 구분
					 --, s.plant_id    as operation_name -- 수정 전
					 , 'Working Time(Min)' as measure
					 , p.BASIS_YYYYMMDD    as yyyymmdd
					 , p.basis_yyyymm      as yyyymm
					 , RIGHT(p.basis_yyyymm,2)+p.iso_week as iso_week
					 , o.OPERATION_ID as operation
					 ,S.OSP_YN
				  FROM SCM_MST_SITE S 
				  JOIN SCM_MST_LINE_OSP O ON S.DIVISION_ID = O.DIVISION_ID AND S.SCM_SITE_ID = O.SCM_SITE_ID
				 CROSS JOIN scm_sys_calendar_m p
				 WHERE 1=1
				   AND p.BASIS_YYYYMMDD >= @p_from_yyyymmdd
				   AND p.BASIS_YYYYMMDD <= @p_to_yyyymmdd
				   AND s.site_type   = 'PLANT'
				   AND s.valid_yn	 = 'Y'
				   AND s.osp_yn	     = 'Y'
				   AND s.division_id = @p_division_id
				   AND ISNULL(s.attribute1,'N') = 'Y'
				   AND ( ( @p_plant_site_id IS NULL OR  @p_plant_site_id = '' ) OR s.scm_site_id   IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )
				   AND ( ( @p_line_id       IS NULL OR  @p_line_id       = '' ) OR o.line_id       IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
			) a
			LEFT OUTER JOIN SCP_MST_WORKING_TIME b  ON a.division_id   = b.division_id 
												   AND a.plant_site_id = b.plant_site_id
												   AND a.factory_id    = b.factory_id 
												   AND a.operation_id  = b.operation_id 
												   AND a.line_id       = b.line_id
												   AND a.yyyymmdd      = b.yyyymmdd

			LEFT OUTER JOIN SCP_MST_WORKING_TIME_DEFAULT c  ON a.division_id   = c.division_id 
												   AND a.plant_site_id = c.plant_site_id
												   AND a.factory_id    = c.factory_id 
												   AND a.operation_id  = c.operation_id 
												   AND a.line_id       = c.line_id

			LEFT OUTER JOIN scm_sys_calendar_m o ON b.yyyymmdd = o.basis_yyyymmdd 
	WHERE 1=1
	  AND ( ( @p_operation_id  IS NULL OR  @p_operation_id  = '' ) OR operation  IN (SELECT token FROM dbo.String_Split(@p_operation_id  ,',')) )

	;

	/********************************************************************************
		* PIVOIT처리
	********************************************************************************/
	begin
		DECLARE @mQry_sum NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성
		SET @mQry_sum = '';
		SET @mQry_sum = '';

		--SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END ) AS ' + yyyymmdd
		--										WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',4) THEN QTY END ) AS ' + yyyymmdd
		--									    WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY END ) AS ' + yyyymmdd
		--							        END +''+CHAR(10)
		
		SELECT  @mQry_sum = @mQry_sum+','+  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY END ) AS ' + yyyymmdd  +CHAR(10)
		FROM ( 
			--SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd        
			--		, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
			--FROM [dbo].[scm_sys_calendar_m] a 
			--WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			--GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
			--UNION ALL
			--SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
			--		,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
			--FROM [dbo].[scm_sys_calendar_m] a 
			--WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			--GROUP BY a.basis_yyyymm, a.month_name		
			--UNION ALL
			SELECT TOP 10000 'D_'+a.basis_yyyymmdd   AS yyyymmdd      
					, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a 
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd	
		) AS A
		ORDER BY sort_order_no  ;

		PRINT @mQry_sum

		SET @mEXEC = '';
		SET @mEXEC = @mEXEC+'	SELECT A.* FROM (  '+CHAR(10);

		SET @mEXEC = @mEXEC+'	SELECT  '+CHAR(10);
		SET @mEXEC = @mEXEC+'		   division_id , plant_site_id , factory_id, factory_name , operation_id , operation_name, line_id, line_name, measure, OSP_YN    '+CHAR(10);
		SET @mEXEC = @mEXEC+'		   ,(select TOP 1 d.DIVISION_NAME from SCM_MST_DIVISION d where d.DIVISION_ID = division_id) as division_name    '+CHAR(10);
		SET @mEXEC = @mEXEC+'		   ,(select max(d.SITE_DESCRIPTION) from SCM_MST_SITE d where 1=1 and d.SCM_SITE_ID = plant_site_id group by d.SCM_SITE_ID) as plant_site_name    '+CHAR(10);

		--SET @mEXEC = @mEXEC+'		   division_id , division_name , plant_site_id , plant_site_name , factory_id, factory_name , operation_id , operation_name, line_id, line_name, measure    '+CHAR(10);
		--SET @mEXEC = @mEXEC+'	         ,convert(varchar(10),dbo.FN_CHAR_TO_DATE(right(max(case when qty is not null then YYYYMMDD end),8)),120) as last_input_date '
		--SET @mEXEC = @mEXEC+'          ,(select MAX(yyyymmdd) from scp_mst_working_time t where t.division_id = division_id and t.plant_site_id = plant_site_id and t.factory_id = factory_id and t.operation_id = operation_id and t.line_id =line_id and t.working_time is not null) as last_input_date ' +char(10)
		SET @mEXEC = @mEXEC+'       	, working_time_default '+CHAR(10);
		SET @mEXEC = @mEXEC+'       	, last_input_date '+CHAR(10);
		
		SET @mEXEC = @mEXEC+'       	' +@mQry_sum + CHAR(10);
		SET @mEXEC = @mEXEC+'   FROM #TblDynamicPivot_SCP0019 '+CHAR(10);
		--SET @mEXEC = @mEXEC+'	GROUP BY  division_id , division_name , plant_site_id , plant_site_name , factory_id, factory_name , operation_id , operation_name, working_time_default,line_id, line_name, last_input_date, measure '+CHAR(10);
		SET @mEXEC = @mEXEC+'	GROUP BY  division_id , plant_site_id , factory_id, factory_name , operation_id , operation_name, working_time_default,line_id, line_name, last_input_date, measure, OSP_YN '+CHAR(10);
		--SET @mEXEC = @mEXEC+'	ORDER BY convert(varchar(10),dbo.FN_CHAR_TO_DATE(right(max(case when qty is not null then YYYYMMDD end),8)),120), division_name , plant_site_name ,  factory_name ,  operation_name,  line_name, measure '+CHAR(10);
		--SET @mEXEC = @mEXEC+'	ORDER BY last_input_date, factory_name ,  operation_name,  line_id , measure '+CHAR(10);
		SET @mEXEC = @mEXEC+'	) A '+CHAR(10);
		SET @mEXEC = @mEXEC+'	ORDER BY last_input_date, division_name , plant_site_name ,  factory_name ,  operation_name desc,  line_id , measure, OSP_YN '+CHAR(10); -- PJ20202001 : operation_name asc => desc 수정
		;
		

		IF ( @debug_mode ='T')
			PRINT @mEXEC;
		
		EXEC (@mEXEC);

	END -- PIVOT BEGIN
	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0019') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0019

END
