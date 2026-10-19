
/*
 * Program ID   : SCP0014_GET_PROBLEM_REPORT
 * Description  : Problem Report 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/21   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/31	KYH				1년조회시 년도가 다른 같은 월 조회시 sum이 표시되는 문제 ex) 2018.0528 ~ 2019.0527 조회시 2019.5월 (마지막 주)에 2018.5월의 sum이 표시된다
 * 2018/07/10   byunghunjung	sales site description 수정
 * 2018/07/18   YHW				전극용 조회항목 추가
 EXEC SCP0014_GET_PROBLEM_REPORT @p_division_id='81', @p_plant_site_id='100080-P,A040-A,A040-P,A041-E,G382-A,G382-P,G383-E,G451-A,G451-P,G452-E,G481-A,G481-P,KR008933-P', @p_sales_site_id='ATBS_CN_SHA,Audi_BE_BRU,Audi_DE_ING,Audi_DE_NEM,Audi_GB_CRE,Audi_MX_PBC,Audi_SK_BTS,BAE_US_ENC,BMW_DE_DFG,BMW_DE_MUC,BMW_US_SPA,Club Car_US_AGS,CS Enertech_KR_OSN,Daimler_DE_KAZ,ESS_CN_NKG,ESS_KR_HWS,ESS_KR_OCH,FCA_CA_WND,FCA_IT_MEI,FCA_US_SEH,Ford_US_RDF,Forsee_FR_MCR,GCV_CN_HGH,GEELY_CN_NGB,GM_US_BQN,Hengyuan_CN_JHA,HKI_KR_WJU,HKMC_KR_HWS,HLGP_KR_CHU,Hyperstrong_CN_BJS,Irizar_ES_ADU,JLR_GB_GAY,KTC_CN_SZX,Lamborghini_IT_SBN,Landsuccess_CN_SZX,LGCMI_US_HLM,LGCPI_US_TYM,LGE_KR_INC,Lion Bus_CA_SJE,London Taxi_GB_CVT,Magna_AT_GRZ,Mahindra_IN_PNE,Man Truck & Bus_DE_MUC,Piston_US_RDF,Porsche_DE_VBS,Porsche_SK_BTS,PSA_FR_SHX,Raymond_US_EEG,Renault_ES_VLL,Renault_FR_HRB,Renault_KR_PUS,SAIC_CN_SHA,Samsung SDI_AT_GRZ,Samsung SDI_CN_BJS,Shinden Hihhtex_JP_SMZ,Shinden Hihhtex_KR_WJU,Volvo_BE_GNE,Volvo_FR_HRB,Volvo_MY_SHA,Volvo_SE_GOT,Vremt_CN_SUZ,VW_DE_FAB,Yuntong_CN_NGB,Zhongjia_CN_CTU', @p_project_code='', @p_item_id='', @p_problem_type='', @p_from_yyyymmdd='20180416', @p_to_yyyymmdd='20180513', @p_plan_start_yyyymmdd='20180416', @p_plan_type='PR', @p_seq='1'

 */
CREATE PROCEDURE [dbo].[SCP0014_GET_PROBLEM_REPORT_NEW]
	 @p_division_id				NVARCHAR(50)
	,@p_plant_site_id			NVARCHAR(max)
	,@p_sales_site_id			NVARCHAR(max)
	,@p_project_code			NVARCHAR(300)
	,@p_item_id					NVARCHAR(300)
	,@p_problem_type			NVARCHAR(20)
	,@p_from_yyyymmdd			NVARCHAR(8)
   ,@p_to_yyyymmdd				NVARCHAR(8)
	,@p_plan_start_yyyymmdd		NVARCHAR(max)
	,@p_plan_type				NVARCHAR(max)
	,@p_seq						NVARCHAR(max)
	,@p_electrodeType			NVARCHAR(30)=NULL

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	--IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblDynamicPivot_SCP0014%')
	--	   DROP TABLE #TblDynamicPivot_SCP0014

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0014') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0014;

	CREATE TABLE #TblDynamicPivot_SCP0014 (
		  division_id			NVARCHAR(50)
		, plan_start_yyyymmdd	NVARCHAR(8)
		, PLAN_TYPE				NVARCHAR(50)
		, SEQ					bigint
		, ENG_DEMAND_ID			NVARCHAR(1000)
		,plant_site_id			NVARCHAR(50)
		,sales_site_id			NVARCHAR(50)
		,project_code			NVARCHAR(50)
		,item_id				NVARCHAR(50)
		,dom_exp				NVARCHAR(50)
		,fcst_type				NVARCHAR(50)
		,yyyymmdd				NVARCHAR(20)
		,qty					INT
		,yyyymm					NVARCHAR(20)
		,iso_week				NVARCHAR(20)
		,problem_type			NVARCHAR(10)
		,origin_from_division_id	NVARCHAR(30)
		,origin_to_division_id		NVARCHAR(30)
		,electrode_type			NVARCHAR(30)
	);

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	INSERT INTO  #TblDynamicPivot_SCP0014 (
			  division_id
			, plan_start_yyyymmdd
			, PLAN_TYPE
			, SEQ
			, ENG_DEMAND_ID
			, plant_site_id
			, sales_site_id
			, project_code
			, item_id
			, dom_exp
			, fcst_type
			, yyyymmdd
			, yyyymm
			, qty
			, iso_week
			--, problem_type
			, origin_from_division_id
			, origin_to_division_id
			, electrode_type
		)
	   SELECT
			  division_id
			, plan_start_yyyymmdd
			, plan_type
			, seq
			, eng_demand_id
			, plant_site_id
			, sales_site_id
			, project_code
			, model_id
			, dom_exp
			, fcst_type
	        , 'D_'+m.yyyymmdd AS yyyymmdd
		    , o.basis_yyyymm AS yyyymm
	        , qty

		    --, o.iso_week
			, right(o.basis_yyyymm, 4) + o.iso_week AS iso_week

		    --, problem_type
			, ISNULL(NULLIF(origin_from_division_id,''),'-') as origin_from_division_id
			, ISNULL(NULLIF(origin_to_division_id,''),'-') as origin_to_division_id
			, ISNULL(NULLIF(electrode_type,''),'-') as electrode_type
	   FROM SCP_ANL_PROBLEM_REPORT_DEMAND m

	   INNER JOIN scm_sys_calendar_m o on m.yyyymmdd = o.basis_yyyymmdd

	   WHERE 1=1
			AND yyyymmdd >= @p_from_yyyymmdd
			AND yyyymmdd <= @p_to_yyyymmdd
			AND division_id		    = @p_division_id
			AND plan_start_yyyymmdd = @p_Plan_Start_yyyymmdd
			AND plan_type		    = @p_PLAN_TYPE
			AND seq				    = @p_SEQ
			AND ( ( @p_plant_site_id IS NULL OR  @p_plant_site_id='' ) OR plant_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site_id,',')) )
			AND ( ( @p_sales_site_id IS NULL OR  @p_sales_site_id='' ) OR sales_site_id IN (SELECT token FROM dbo.String_Split(@p_sales_site_id,',')) )
			AND ( ( @p_project_code  IS NULL OR  @p_project_code=''  ) OR project_code  IN (SELECT token FROM dbo.String_Split(@p_project_code ,',')) )
			AND ( ( @p_item_id       IS NULL OR  @p_item_id=''       ) OR model_id       IN (SELECT token FROM dbo.String_Split(@p_item_id      ,',')) )
			AND ( ( @p_problem_type       IS NULL OR  @p_problem_type=''       ) OR problem_type IN (SELECT token FROM dbo.String_Split(@p_problem_type      ,',')) )
			AND ( ( @p_electrodeType IS NULL OR  @p_electrodeType='' ) OR electrode_type IN (SELECT token FROM dbo.String_Split(@p_electrodeType,',')) )
		;

		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/
		BEGIN
			DECLARE @mQry_sum NVARCHAR(MAX);
			DECLARE @mEXEC NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';
			SET @mQry_sum = '';

		    SELECT  @mQry_sum = @mQry_sum+','+
				CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END ) AS ' + yyyymmdd
					WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''', 6) THEN QTY END ) AS ' + yyyymmdd
					WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY END ) AS ' + yyyymmdd
				END +''+CHAR(10)
			FROM (
				SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
					, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
				UNION ALL
				SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
						,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				GROUP BY a.basis_yyyymm, a.month_name
				UNION ALL
				SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd
						, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
					FROM [dbo].[scm_sys_calendar_m] a
					WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				GROUP BY a.basis_yyyymmdd
			) AS A
			ORDER BY sort_order_no  ;

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+'       SELECT  '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	 division_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_division_name(division_id) AS division_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,plan_start_yyyymmdd	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,plan_type	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,seq	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,plant_site_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,isnull ( dbo.fn_get_scm_site_description(division_id,plant_site_id)  , ''-'') AS plant_site_description    '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,sales_site_id  '+CHAR(10);
			--SET @mEXEC = @mEXEC+'       	,isnull ( dbo.fn_get_scm_site_description(division_id,sales_site_id)  , ''-'') AS sales_site_description	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,sales_site_id AS sales_site_description	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,project_code	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,item_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, dbo.FN_GET_ITEM_NICKNAME( division_id, item_id ) AS nick_name '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dom_exp '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,fcst_type '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,problem_type '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,origin_from_division_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,origin_to_division_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,electrode_type '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	'+@mQry_sum+CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SCP0014 '+CHAR(10);
			SET @mEXEC = @mEXEC+'		GROUP BY  division_id, plan_start_yyyymmdd, plan_type, seq, plant_site_id,sales_site_id,project_code, item_id,dom_exp,fcst_type,problem_type,origin_from_division_id,origin_to_division_id,electrode_type'+CHAR(10);
			SET @mEXEC = @mEXEC+'		ORDER BY  division_id, plant_site_id, sales_site_id, project_code'+CHAR(10);

			-- calendar & qty정보 조회
			EXEC (@mEXEC);

			-- problem_type 에 따라 셀 색상지정을 위해서
			SELECT 	division_id
				, plan_start_yyyymmdd
				, PLAN_TYPE
				, SEQ
				, ENG_DEMAND_ID
				, plant_site_id
				, sales_site_id
				, project_code
				, model_id as 'item_id'
				, dom_exp
				, fcst_type
				, 'D_'+m.yyyymmdd AS yyyymmdd
				, problem_type
				, ISNULL(NULLIF(m.origin_from_division_id,''),'-') as origin_from_division_id
				, ISNULL(NULLIF(m.origin_to_division_id,''),'-') as origin_to_division_id
				, ISNULL(NULLIF(m.electrode_type,''),'-') as electrode_type
			FROM SCP_ANL_PROBLEM_REPORT_DEMAND m
			INNER JOIN scm_sys_calendar_m o on m.yyyymmdd = o.basis_yyyymmdd
			WHERE 1=1
			AND yyyymmdd >= @p_from_yyyymmdd
			AND yyyymmdd <= @p_to_yyyymmdd
			AND ( ( @p_division_id   IS NULL OR  @p_division_id=''   ) OR division_id   IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
			AND ( ( @p_plant_site_id IS NULL OR  @p_plant_site_id='' ) OR plant_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site_id,',')) )
			AND ( ( @p_sales_site_id IS NULL OR  @p_sales_site_id='' ) OR sales_site_id IN (SELECT token FROM dbo.String_Split(@p_sales_site_id,',')) )
			AND ( ( @p_project_code  IS NULL OR  @p_project_code=''  ) OR project_code  IN (SELECT token FROM dbo.String_Split(@p_project_code ,',')) )
			AND ( ( @p_item_id       IS NULL OR  @p_item_id=''       ) OR model_id       IN (SELECT token FROM dbo.String_Split(@p_item_id      ,',')) )
			--and m.problem_type != ''
			AND ( ( @p_plan_start_yyyymmdd       IS NULL OR  @p_plan_start_yyyymmdd=''       ) OR plan_start_yyyymmdd       IN (SELECT token FROM dbo.String_Split(@p_plan_start_yyyymmdd      ,',')) )
			AND ( ( @p_plan_type       IS NULL OR  @p_plan_type=''       ) OR PLAN_TYPE       IN (SELECT token FROM dbo.String_Split(@p_plan_type      ,',')) )
			AND ( ( @p_seq       IS NULL OR  @p_seq=''       ) OR SEQ       IN (SELECT token FROM dbo.String_Split(@p_seq      ,',')) )
			AND ( ( @p_electrodeType IS NULL OR  @p_electrodeType='' ) OR electrode_type IN (SELECT token FROM dbo.String_Split(@p_electrodeType,',')) )
			ORDER BY  division_id, plant_site_id, sales_site_id, project_code
			;

		END;



	    --PRINT @mEXEC;
		-- 임시테이블 삭제
		DROP TABLE #TblDynamicPivot_SCP0014 ;
END
