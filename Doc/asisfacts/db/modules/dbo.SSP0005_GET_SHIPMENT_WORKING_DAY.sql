/*
 * Program ID   : SSP0005_GET_SHIPMENT_WORKING_DAY
 * Description  : SHIPMENT_WORKING_DAY 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/25   ygkim		   Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * EX)
 * EXEC SSP0005_GET_SHIPMENT_WORKING_DAY @p_from_yyyymmdd='20180425', @p_to_yyyymmdd='20181028', @p_division_id='40', @p_company_id='ALL,C100,G180,G380,G450,G480', @debug_mode='T'
 */
CREATE PROCEDURE [dbo].[SSP0005_GET_SHIPMENT_WORKING_DAY]
   @p_from_yyyymmdd NVARCHAR(MAX)
  ,@p_to_yyyymmdd   NVARCHAR(MAX)
  ,@p_division_id	NVARCHAR(MAX)
  ,@p_company_id	NVARCHAR(MAX)
  ,@debug_mode		NVARCHAR(20)  ='F'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	--if OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SSP0005') is not null 
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0005') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SSP0005;

	SELECT a.division_id
		  ,a.company_id
		  ,a.WORKDAY_YN
		  ,'D_'+a.yyyymmdd as yyyymmdd
		  --,a.yyyymm as yyyymm
		  --,a.iso_week
		  into #TblDynamicPivot_SSP0005
	  FROM(
			SELECT  DISTINCT
					 l.division_id
					,l.company_id
					,l.WORKDAY_YN
					,l.YYYYMMDD as yyyymmdd
					--,p.BASIS_YYYYMMDD as yyyymmdd
				   -- ,p.basis_yyyymm as yyyymm
				   -- ,RIGHT(p.basis_yyyymm,2)+p.iso_week as iso_week
				FROM SSP_MST_SHIP_CALENDAR L WITH(NOLOCK)				
				--CROSS JOIN scm_sys_calendar_m p 	
			    WHERE 1=1
			   --   AND p.BASIS_YYYYMMDD >=@p_from_yyyymmdd
				  --AND p.BASIS_YYYYMMDD <=@p_to_yyyymmdd
				  AND l.YYYYMMDD >= @p_from_yyyymmdd
				  ANd l.YYYYMMDD <= @p_to_yyyymmdd
				  AND ( ( @p_division_id   IS NULL OR  @p_division_id   = '' ) OR l.division_id   IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
				  AND ( ( @p_company_id IS NULL OR  @p_company_id = '' ) OR l.COMPANY_ID   IN (SELECT token FROM dbo.String_Split(@p_company_id  ,',')) )
			) a
	WHERE 1=1
	;

	/********************************************************************************
		* PIVOIT처리
	********************************************************************************/
	begin
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mQuery = ''
		SELECT  @mQuery = @mQuery+','+  'MAX(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN WORKDAY_YN END ) AS ' + yyyymmdd  +CHAR(10)
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
				FROM [dbo].[scm_sys_calendar_m] a WITH(NOLOCK)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd	
		) AS A
		ORDER BY sort_order_no  ;
		
		SET @mEXEC = '';
		SET @mEXEC = @mEXEC+'	SELECT  '+CHAR(10);
		SET @mEXEC = @mEXEC+'		   division_id , company_id    '+CHAR(10);
		--SET @mEXEC = @mEXEC+'	         ,convert(varchar(10),dbo.FN_CHAR_TO_DATE(right(max(case when qty is not null then YYYYMMDD end),8)),120) as last_input_date '
		--SET @mEXEC = @mEXEC+'          ,(select MAX(yyyymmdd) from scp_mst_working_time t where t.division_id = division_id and t.plant_site_id = plant_site_id and t.factory_id = factory_id and t.operation_id = operation_id and t.line_id =line_id and t.working_time is not null) as last_input_date ' +char(10)
		SET @mEXEC = @mEXEC+'       	' +@mQuery + CHAR(10);
		SET @mEXEC = @mEXEC+'   FROM #TblDynamicPivot_SSP0005 '+CHAR(10);
		SET @mEXEC = @mEXEC+'	GROUP BY  division_id , company_id '+CHAR(10);
		--SET @mEXEC = @mEXEC+'	ORDER BY convert(varchar(10),dbo.FN_CHAR_TO_DATE(right(max(case when qty is not null then YYYYMMDD end),8)),120), division_name , plant_site_name ,  factory_name ,  operation_name,  line_name, measure '+CHAR(10);
		SET @mEXEC = @mEXEC+'	ORDER BY division_id , company_id '+CHAR(10);
		;
		PRINT @mEXEC;
		IF ( @debug_mode ='T')
			PRINT @mEXEC;
		
		EXEC (@mEXEC);

	END -- PIVOT BEGIN
	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0005') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SSP0005

END
