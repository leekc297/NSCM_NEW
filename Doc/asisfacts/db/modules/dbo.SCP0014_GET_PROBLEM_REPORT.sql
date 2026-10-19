
/*
 * Program ID   : SCP0014_GET_PROBLEM_REPORT
 * Description  : Problem Report 조회
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2018/02/21   byunghunjung	          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/31	KYH				          1년조회시 년도가 다른 같은 월 조회시 sum이 표시되는 문제 ex) 2018.0528 ~ 2019.0527 조회시 2019.5월 (마지막 주)에 2018.5월의 sum이 표시된다
 * 2018/07/10   byunghunjung	          sales site description 수정
 * 2018/07/18   YHW				          전극용 조회항목 추가
 * 2024-01-08   chaan                     PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 EXEC SCP0014_GET_PROBLEM_REPORT @p_division_id='81', @p_plant_site_id='100080-P,A040-A,A040-P,A041-E,G382-A,G382-P,G383-E,G451-A,G451-P,G452-E,G481-A,G481-P,KR008933-P', @p_sales_site_id='ATBS_CN_SHA,Audi_BE_BRU,Audi_DE_ING,Audi_DE_NEM,Audi_GB_CRE,Audi_MX_PBC,Audi_SK_BTS,BAE_US_ENC,BMW_DE_DFG,BMW_DE_MUC,BMW_US_SPA,Club Car_US_AGS,CS Enertech_KR_OSN,Daimler_DE_KAZ,ESS_CN_NKG,ESS_KR_HWS,ESS_KR_OCH,FCA_CA_WND,FCA_IT_MEI,FCA_US_SEH,Ford_US_RDF,Forsee_FR_MCR,GCV_CN_HGH,GEELY_CN_NGB,GM_US_BQN,Hengyuan_CN_JHA,HKI_KR_WJU,HKMC_KR_HWS,HLGP_KR_CHU,Hyperstrong_CN_BJS,Irizar_ES_ADU,JLR_GB_GAY,KTC_CN_SZX,Lamborghini_IT_SBN,Landsuccess_CN_SZX,LGCMI_US_HLM,LGCPI_US_TYM,LGE_KR_INC,Lion Bus_CA_SJE,London Taxi_GB_CVT,Magna_AT_GRZ,Mahindra_IN_PNE,Man Truck & Bus_DE_MUC,Piston_US_RDF,Porsche_DE_VBS,Porsche_SK_BTS,PSA_FR_SHX,Raymond_US_EEG,Renault_ES_VLL,Renault_FR_HRB,Renault_KR_PUS,SAIC_CN_SHA,Samsung SDI_AT_GRZ,Samsung SDI_CN_BJS,Shinden Hihhtex_JP_SMZ,Shinden Hihhtex_KR_WJU,Volvo_BE_GNE,Volvo_FR_HRB,Volvo_MY_SHA,Volvo_SE_GOT,Vremt_CN_SUZ,VW_DE_FAB,Yuntong_CN_NGB,Zhongjia_CN_CTU', @p_project_code='', @p_item_id='', @p_problem_type='', @p_from_yyyymmdd='20180416', @p_to_yyyymmdd='20180513', @p_plan_start_yyyymmdd='20180416', @p_plan_type='PR', @p_seq='1'

 */
CREATE PROCEDURE [dbo].[SCP0014_GET_PROBLEM_REPORT]
--CREATE PROCEDURE [dbo].[SCP0014_GET_PROBLEM_REPORT]
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

    --DECLARE @p_division_id				NVARCHAR(50)	= N'81';
    --DECLARE @p_plant_site_id			NVARCHAR(max)	= N'A002-W,A040-A,A040-P,A041-E,F040-P,G382_81-W,G382-A,G382-P,G383-E,G388_81-W,G388-P,G451-A,G451-P,G452-E,G481_81-W,G481-A,G481-P,G482-E,G631-A,G631-P,G632-E,G691_81-W,KR013131_81-P';
    --DECLARE @p_sales_site_id			NVARCHAR(max)	= N'A002-81-AS,Aeonus_KR_GUN,Arpiem_RO_OTP,ATBS_CN_SHA,ATL_DE_RDG,ATL_GB_POO,audi as_BE_BRU,audi as_DE_KAS,audi as_DE_RSE,audi as_KR_HSO,Audi CKD_DE_ING,Audi_DE_ING,Audi_DE_KAS,BMW_DE_GBM,BMW_DE_LEJ,BMW_DE_MUC,BMW_DE_NBH,BMW_DE_NTG,BMW_DE_WEO,BMW_DE_WKD,BMW_GB_BSI,BMW_MX_MEX,BMW_US_SPA,China Effort(A)_HK_KWN,Club Car_US_AGS,COENSYS_KR_HWS,Corvus Norway_NO_BGO,Corvus Norway_US_BLI,CS Enertech_KR_OSN,CS Enertech_KR_OSN_KR_OSN,Cummins EP(OTS)_GB_YTH,Cummins(OTS)_US_CLU,Daimler(AS)_DE_BAU,Daimler(AS)_DE_KAZ,Daimler_DE_BAU,Daimler_DE_KAZ,Daimler_JP_HG9,dianchibao_CN_SHA,dianchibao_HK_MUN,DIS_DE_VBS,DSMT_KR_KMH,EDISON MOTORS_KR_TJN,Edisoninno_KR_TJN,Edisoninno_KR_UIJ,EForce(OTS)_CH_BCR,EK_DE_DTG,equipmake(OTS)_GB_NRW,ESS_CN_NKG,ESS_KR_HWS,ESS_KR_OCH,ESS_KR_TJN,FAW VW_CN_CGQ,FAW VW_CN_DLC,FBPS(OTS)_US_ILD,FCA AS_CA_WND,FCA AS_IT_MEI,FCA AS_IT_TRN,FCA AS_PL_WRO,FCA AS_US_SEH,FCA AS_US_WAM,FCA_CA_WND,FCA_IT_MEI,FCA_IT_MOD,FCA_IT_TRN,FCA_KR_JCH,FCA_MX_TLC,FCA_US_2TT,FCA_US_ABH,FCA_US_CMH,FCA_US_ETA,Ford_GB_ESX,Ford_MX_CTN,Ford_MX_TPZ,Ford_PL_WRO,Ford_RO_CRV,Ford_TR_DOG,Ford_TR_GOK,Ford_TR_KCO,Ford_US_IGX,Ford_US_RDF,Ford_US_URI,Forsee_FR_MCR,G382-81-AS,G388-81-AS,G481-81-AS,G691-81-AS,GCV_CN_HGH,GEELY_CN_NGB,GM AS_US_BQN,GM AS_US_HZP,GM_CA_OSH,GM_CN_SHA,GM_KR_INC,GM_US_ABH,GM_US_BQN,GM_US_LRP,GM_US_MOI,GM_US_OMQ,GM_US_QBU,GM_US_WAM,GM_US_YPS,GM_WA_CA_OSH,Guangdonglihua_CN_DGG,Hanwha Aero_KR_CHW,Hengyuan EU_CN_JHA,Hengyuan_CN_JHA,HKI_KR_WJU,HKMC AS_KR_UWN,HKMC_CZ_NVS,HKMC_KR_ASA,HKMC_KR_HWS,HKMC_KR_USN,HKMC_KR_UWN,HKMC_WA_CZ_NVS,HLGP AS_KR_CHU,HLGP_KR_CHU,Honda Motor_JP_HG9,Honda Motor_KR_OCH,Humanhorizons_CN_YCG,Hyperstrong_CN_BJS,ICPT(OTS)_PL_WAW,IM_US_SPK,Irizar EM_ES_ADU,Irizar_ES_ADU,jemado_GB_LON,JIANGSU_CN_SZH,JJ Solstice_KR_YNG,JLR AS_GB_GAY,JLR(OTS)_GB_CVT,JLR_GB_CVT,JLR_GB_GAY,KAIST_KR_TJN,Karma(OTS)_US_IVN,KIA_KR_HWS,KIA_KR_KWJ,KIA_SK_TEP,kokam_KR_NSN,KTC_CN_SZX,Lamborghini_IT_SBN,Landsuccess_CN_SZX,LGCDJ_KR_TJN,LGCEG_DE_FRA,LGCGC_KR_GCN,LGCNA_CN_NKG,LGCOC_KR_OCH,LGCOC2_KR_OCH,LGCPI_US_TYM,LGCWA_PL_WRO,LGE_KR_INC,LGE_US_HZP,LGE_US_LRP,LGE_US_QGB,LGESMI_CA_WND,LGESMI_US_HLM,LGESMI_US_LLO,LGESOC_KR_OCH,LGESOC_PL_WRO,LGESWA_PL_BYW,LGESWA_PL_WRO,Lion Bus_CA_SJE,London Taxi_GB_CVT,Magna BMW_AT_GRZ,Magna_AT_GRZ,Magna_Renault_AT_GRZ,Magtec_GB_RTH,Mahindra_IN_PNE,Mahindra_IN_PNQ,Mahindra_KR_PYK,Man Truck & Bus_DE_AGB,Man Truck & Bus_DE_EFG,Man Truck & Bus_DE_MUC,Man Truck & Bus_DE_SCR,Man Truck & Bus_DE_STR,Maserati_DE_VBS,Maserati_IT_MOD,Maserati_IT_TRN,Maserati_US_CMH,Maxion_BR_CZI,MITSUBISHI_JP_TBM,Mitsui_FR_HSP,MOBIS_AS_KR_CHU,MOBIS_AS_KR_PTK,MOBIS_CZ_NVS,MOBIS_KR_CHU,MOBIS_SK_GBY,NANO IN TECH_KR_WJU,NANO IN TECH_WA_KR_WJU,Nissan_GB_SUN,Nissan_JP_FUK,Nissan_JP_YOK,Nivalis(OTS)_US_WIX,Nordresa_CA_LAV,Porsche_DE_WSC,Porsche_SK_BTS,Porsche_SK_DNV,Porsche_SK_HST,Porsche_SK_KNM,PSA AS_FR_VEL,PSA_DE_EIS,PSA_DE_RUM,PSA_FR_CSP,PSA_FR_JKI,PSA_FR_MHS,PSA_FR_PAL,PSA_FR_POI,PSA_FR_RNS,PSA_FR_SHX,PSA_FR_SVD,PSA_FR_VEL,PSA_FR_VER,PSA_FR_VSL,PSA_KR_TJN,PSA_PL_WRO,PSA_SK_TNA,QEV_ES_BCN,Raymond_US_EEG,Rempus_KR_HWS,Renault AS HQ_FR_FNS,Renault AS_FR_FNS,Renault AS_FR_HRB,Renault AS_KR_HAN,Renault AS_KR_PUS,Renault_ES_VLL,Renault_FR_BAT,Renault_FR_CLE,Renault_FR_DOI,Renault_FR_HRB,Renault_GB_ABO,Renault_KR_PUS,Renault_SI_NMO,RVA_DE_NDH,SAIC_CN_SHA,Samsung SDI_AT_GRZ,Samsung SDI_CN_BJS,SEMIROAD_KR_HWS,SGM AS_CN_PDG,SGM_CN_PDG,Shinden Hihhtex_JP_SMZ,Shinden Hihhtex_KR_WJU,Siemens_NO_TRD,Sime Darby_MY_KKH,SKODA_CZ_MBV,Skyworth_CN_XUZ,Solaris_PL_OWA,Spear Power Systems_US_GVW,SYMC_KR_INC,SYMC_KR_PYK,SYMC_KR_TAE,Temsa bus & Coach_TR_ABK,TY_JP_7KA,VAL_DE_222,VAL_DE_FFO,VAL_DE_KRD,Valmet_DE_FRA,Valmet_DE_HAM,Valmet_DE_KRD,Vanderhall_US_PVU,VIA(OTS)_US_OEU,Volta PS_US_HLM,Volvo AS_AU_SYD,Volvo AS_CN_SZH,Volvo AS_FR_HRB,Volvo AS_IL_TLV,Volvo AS_IN_MUB,Volvo AS_JP_NGO,Volvo AS_MY_KUL,Volvo AS_SE_GO5,Volvo AS_SE_GOT,Volvo AS_TH_BKK,Volvo AS_US_ONT,Volvo_AU_SYD,Volvo_BE_GBU,Volvo_BE_GNE,Volvo_IL_TLV,Volvo_JP_NGO,Volvo_KR_SEL,Volvo_MY_KUL,Volvo_MY_SHA,Volvo_SE_GOT,Volvo_TH_BKK,Volvo_TW_TYN,Volvo_US_CHS,Volvo_US_HLM,Vremt AS_CN_SZH,Vremt_CN_SUZ,VW AS_DE_BWE,VW AS_DE_KAS,VW AS_DE_RSE,VW_CZ_MBV,VW_DE_74D,VW_DE_BDB,VW_DE_BWE,VW_DE_FAB,VW_DE_KAS,VW_DE_WOB,VW_DE_WVN,WATTPACK_CN_BJS,WRSE_DE_ZCH,XL_US_BOS,Yuntong_CN_NGB,ZeroEV(OTS)_US_TPE,Zhongjia_CN_CTU,Zhongjia_CN_DQG,Zhongjia_CN_SHA,Zhongjia_CN_TIZ,Audi_DE_NEM,Audi_DE_SHM,Audi_DE_WOB,Audi_DE_WVN,Audi_GB_CRE,Audi_HU_GYO,Audi_MX_PBC,Audi_PL_WRO,Audi_SK_BTS,AW_DE_LEJ,BAE_US_ENC,Banglilai_CN_SZX,BEDEO_TR_BTS,BMW_AT_GRZ,BMW_AT_SER,BMW_DE_DFG,BMW_DE_ECH,FCA_US_LFC,FCA_US_PHL,FCA_US_SEH,FCA_US_WAM,FLASH_IT_SIZ,Ford AS_DE_CGN,Ford AS_DE_QKL,Ford AS_MX_TPZ,Ford AS_US_DEO,Ford AS_US_RDF,Ford(MX-VMI)_TR_KCO,Ford_BE_ANR,Ford_BE_LML,Ford_DE_QKL,Ford_ES_VLC,Peopleworks_KR_SEL,Piston_US_NKY,Piston_US_RDF,Porsche AS_DE_KAS,Porsche AS_DE_SSN,Porsche AS_DE_STR,Porsche_CZ_OSR,Porsche_DE_AAH,Porsche_DE_BBI,Porsche_DE_DTN,Porsche_DE_SHM,Porsche_DE_SSN,Porsche_DE_STR,Porsche_DE_VBS,Porsche_DE_WDB';
    --DECLARE @p_project_code			    NVARCHAR(300)	= N'';
    --DECLARE @p_item_id					NVARCHAR(300)	= N'';
    --DECLARE @p_problem_type			    NVARCHAR(20)	= N'';
    --DECLARE @p_from_yyyymmdd			NVARCHAR(8)		= N'20240101';
    --DECLARE @p_to_yyyymmdd				NVARCHAR(8)		= N'20241229';
    --DECLARE @p_plan_start_yyyymmdd		NVARCHAR(max)	= N'20240101';
    --DECLARE @p_plan_type				NVARCHAR(max)	= N'PR';
    --DECLARE @p_seq						NVARCHAR(max)	= N'1';
    --DECLARE @p_electrodeType			NVARCHAR(30)	= N'';


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
	   
	   -- PRINT @mEXEC;
		-- 임시테이블 삭제
		DROP TABLE #TblDynamicPivot_SCP0014 ;						  
END
