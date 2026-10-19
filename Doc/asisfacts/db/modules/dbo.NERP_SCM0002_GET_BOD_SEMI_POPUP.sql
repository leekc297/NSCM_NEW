
/*
 * Program ID   : SCM0002_GET_BOD_POPUP
 * Description  : BOD Popup 조회
  * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/15   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05		KYH				ITEM_ID , OPERATION GROUP 추가
 * 2018/05/29	KYH				중복되는 값 없애기위해 distinct 추가
 * 2018/09/05   ygkim			@p_origion_division_id 추가, from_site 조건 제거, @p_oper_grp 조건 추가
 * 2021/07/07   khj79			PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022.05.13   LSC             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2024-04-01   vadabi5         NERP) SCM Site ID 로 Plant ID 찾는 로직 정의	
 ----------------------------------------------------------------------------------------------------
 EXEC NERP_SCM0002_GET_BOD_SEMI_POPUP  @p_division_id = '81',@p_bod_id='', @p_from_site='HQ05-W', @p_to_site='WA00-P'    , @p_plan_start_yyyymmdd='20230101', @p_oper_grp='W', @p_item_id='APAAGIHEV-A1', @p_origion_division_id='81'
 EXEC      SCM0002_GET_BOD_SEMI_POPUP  @p_division_id = '81',@p_bod_id='', @p_from_site='HQ05-W', @p_to_site='WA00-P'    , @p_plan_start_yyyymmdd='20230101', @p_oper_grp='W', @p_item_id='APAAGIHEV-A1', @p_origion_division_id='81'
 EXEC     SCM0002_GET_BOD_SEMI_POPUP_TEST  @p_division_id = '81',@p_bod_id='', @p_from_site='HQ05-W', @p_to_site='WA00-P', @p_plan_start_yyyymmdd='20230101', @p_oper_grp='W', @p_item_id='APAAGIHEV-A1', @p_origion_division_id='81'



 	   select m.*
	   from scp_mst_bod_n_v m
inner join SCM_MST_SITE_ITEM_PRIORITY (nolock) p on m.division_id=p.division_id and p.item_id= 'APAAGIHEV-A1'			
inner join SCM_MST_SITE s with(nolock) on s.DIVISION_ID = m.division_id and s.SCM_SITE_ID = m.from_site and s.VALID_YN = 'Y'
	   where 1 =1 
	   and m.bod_type = 'PLANT'
	   and m.division_id = '81'
	   and m.from_site = 'HQ05-W'
	   and m.to_site = 'WA00-P'
	   and s.OPERATION_GROUP = 'W'


 */

CREATE PROCEDURE [dbo].[NERP_SCM0002_GET_BOD_SEMI_POPUP]
    @p_division_id   NVARCHAR(30),
	@p_bod_id		 NVARCHAR(30),
	@p_from_site	 NVARCHAR(30),
	@p_to_site		 NVARCHAR(30) ,
	@p_plan_start_yyyymmdd  Date ,

	@p_oper_grp		NVARCHAR(50) ,
	@p_item_id		NVARCHAR(50) ,
	@p_origion_division_id NVARCHAR(30) = '',
	@debug_mode			NVARCHAR(1)='F'
AS
BEGIN
	
	-- first : from site
	-- second : to site

	SET NOCOUNT ON;
  
	declare @plan_start_date NVARCHAR(8) = convert(nvarchar(8), @p_plan_start_yyyymmdd, 112);
  
	DECLARE @mDQry NVARCHAR(MAX)='';

	SET @mDQry = @mDQry + ' SELECT distinct																									' + char(10) ;
	SET @mDQry = @mDQry + ' 	'''' as chk																									' + char(10) ;
	SET @mDQry = @mDQry + ' 	, '''' as is_lock																							' + char(10) ;
	--SET @mDQry = @mDQry + ' 	, (m.DIVISION_ID + m.FROM_SITE + m.TO_SITE + m.transport_mode) as key_idx									' + char(10) ;
	IF @p_division_id IN ('EE','EE_UC')
		BEGIN SET @mDQry = @mDQry + ' 	, ('''+@p_division_id+''' + m.FROM_SITE + m.TO_SITE + m.transport_mode + m.bod_id) as key_idx		' + char(10) ; END -- BOD 2단계 개발 : BOD_ID 추가
	ELSE
		BEGIN SET @mDQry = @mDQry + ' 	, (m.DIVISION_ID + m.FROM_SITE + m.TO_SITE + m.transport_mode + m.bod_id) as key_idx				' + char(10) ; END -- BOD 2단계 개발 : BOD_ID 추가

	SET @mDQry = @mDQry + ' 	, m.bod_id																									' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.from_site as first_site																					' + char(10) ;
	SET @mDQry = @mDQry + ' 	, dbo.FN_GET_SCM_SITE_DESCRIPTION(m.division_id, m.from_site) as first_site_name							' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.to_site as second_site																					' + char(10) ;
	SET @mDQry = @mDQry + ' 	, dbo.FN_GET_SCM_SITE_DESCRIPTION(m.division_id, m.to_site) as second_site_name								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.priority																								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.incoterms																								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.transport_mode																							' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.days_mon																								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.days_tue																								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.days_wed																								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.days_thu																								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.days_fri																								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.days_sat																								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.days_sun																								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.lt_total																								' + char(10) ;
  --SET @mDQry = @mDQry + ' 	, case  when substring(m.FROM_SITE,1,4) = substring(m.TO_SITE,1,4)											' + char(10) ;
	SET @mDQry = @mDQry + ' 	, CASE  																									' + char(10) ;
	SET @mDQry = @mDQry + ' 	  WHEN CHARINDEX(''-'', m.from_site) > 0 																				' + char(10) ;
	SET @mDQry = @mDQry + ' 	   AND CHARINDEX(''-'', m.to_site) > 0    																				' + char(10) ;
	SET @mDQry = @mDQry + ' 	   AND SUBSTRING(m.from_site, 0,CHARINDEX(''-'', m.from_site)) = SUBSTRING(m.to_site, 0,CHARINDEX(''-'', m.to_site))	' + char(10) ;
    SET @mDQry = @mDQry + ' 			then dateadd(day, isnull( (select isnull(ship_frozen , 0) as ship_frozen 										' + char(10) ;

	IF @p_division_id NOT IN ('EE','EE_UC')
		BEGIN SET @mDQry = @mDQry + ' 				from scm_mst_site where division_id='''+@p_division_id+''' and scm_site_id= from_site ) , 0)			' + char(10) ; END
	ELSE
		BEGIN SET @mDQry = @mDQry + ' 				from scm_mst_site where division_id='''+@p_origion_division_id+''' and scm_site_id= from_site ) , 0)	' + char(10) ; END

	SET @mDQry = @mDQry + ' 	,  convert(date , '''+@plan_start_date+''' , 112))															' + char(10) ;
	SET @mDQry = @mDQry + ' 		 else (select convert(date , DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()) , 112))	' + char(10) ;
	SET @mDQry = @mDQry + ' 	   end as SHIP_FROZEN																						' + char(10) ;
	-- BOD 2단계 개발 : 시작
	SET @mDQry = @mDQry + ' 	, CONVERT(date,m.from_yyyymmdd,112)		as FROM_YYYYMMDD													' + char(10) ;
	SET @mDQry = @mDQry + ' 	, CONVERT(date,m.to_yyyymmdd,112)		as TO_YYYYMMDD														' + char(10) ;
	--SET @mDQry = @mDQry + ' FROM scp_mst_bod_v m  WITH(NOLOCK)																			' + char(10) ;
	SET @mDQry = @mDQry + ' FROM scp_mst_bod_n_v m  WITH(NOLOCK)																			' + char(10) ;
	-- BOD 2단계 개발 : 끝
	SET @mDQry = @mDQry + ' inner join SCM_MST_SITE_ITEM_PRIORITY (nolock) p on m.division_id=p.division_id and p.item_id= '''+@p_item_id+'''				' + char(10) ;
	SET @mDQry = @mDQry + ' inner join SCM_MST_SITE s with(nolock) on s.DIVISION_ID = m.division_id and s.SCM_SITE_ID = m.from_site and s.VALID_YN = ''Y'' ' + char(10) ; 
	SET @mDQry = @mDQry + ' WHERE 1=1																										' + char(10) ;
	IF @p_division_id NOT IN ('EE','EE_UC')
		BEGIN SET @mDQry = @mDQry + ' AND m.division_id   = ''' + @p_division_id + '''														' + char(10) ; END
	ELSE
		BEGIN SET @mDQry = @mDQry + ' AND m.division_id   = ''' + @p_origion_division_id + '''												' + char(10) ; END

	--SET @mDQry = @mDQry + ' AND m.from_site		= @p_from_site 																			' + char(10) ;
	SET @mDQry = @mDQry + ' AND m.bod_type = ''PLANT''																						' + char(10) ;
	SET @mDQry = @mDQry + ' AND s.OPERATION_GROUP = ''' + @p_oper_grp + '''																	' + char(10) ;
	SET @mDQry = @mDQry + ' AND m.to_site = ''' + @p_to_site + '''																			' + char(10) ;
	SET @mDQry = @mDQry + ' order by from_site asc , to_site asc																			' + char(10) ;
	

	EXEC (@mDQry);

	IF( @debug_mode ='T')
	BEGIN				
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@mDQry);
		WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@mDQry,@POS,4000);
				SET @POS = @POS+4000;
			END;
	END;
END
