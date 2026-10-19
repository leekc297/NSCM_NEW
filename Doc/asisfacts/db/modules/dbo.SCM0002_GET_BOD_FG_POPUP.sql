
/*
 * Program ID   : SCM0002_GET_BOD_POPUP
 * Description  : BOD Popup 조회
  * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/15   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/24	KYH				ITEM_ID , OPERATION GROUP 추가
 * 2018/05/29	KYH				중복되는 값 없애기위해 distinct 추가
 * 2018/09/05   ygkim			@p_origion_division_id 추가
 * 2021/07/07   khj79			PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022.05.13   LSC             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 */

CREATE PROCEDURE [dbo].[SCM0002_GET_BOD_FG_POPUP]
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
	
	-- first : to site
	-- second : from site

	SET NOCOUNT ON;
  
	declare @plan_start_date NVARCHAR(8) = convert(nvarchar(8), @p_plan_start_yyyymmdd, 112);

	DECLARE @mDQry NVARCHAR(MAX)='';

	SET @mDQry = @mDQry + ' SELECT distinct																									' + char(10) ;
	SET @mDQry = @mDQry + ' 	'''' as chk																									' + char(10) ;
	SET @mDQry = @mDQry + ' 	, '''' as is_lock																							' + char(10) ;
	--SET @mDQry = @mDQry + ' 	, (m.DIVISION_ID + m.FROM_SITE + m.TO_SITE + m.transport_mode) as key_idx									' + char(10) ;
	IF @p_division_id = 'EE_UC'
		BEGIN SET @mDQry = @mDQry + ' 	, (''EE_UC'' + m.FROM_SITE + m.TO_SITE + m.transport_mode + m.bod_id) as key_idx						' + char(10) ; END
	ELSE IF @p_division_id = 'EE'
		BEGIN SET @mDQry = @mDQry + ' 	, (''EE'' + m.FROM_SITE + m.TO_SITE + m.transport_mode + m.bod_id) as key_idx						' + char(10) ; END
	ELSE
		BEGIN SET @mDQry = @mDQry + ' 	, (m.DIVISION_ID + m.FROM_SITE + m.TO_SITE + m.transport_mode + m.bod_id) as key_idx				' + char(10) ; END

	SET @mDQry = @mDQry + ' 	, m.bod_id																									' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.to_site as first_site																					' + char(10) ;
	SET @mDQry = @mDQry + ' 	, dbo.FN_GET_SCM_SITE_DESCRIPTION(m.division_id, m.to_site) as first_site_name								' + char(10) ;
	SET @mDQry = @mDQry + ' 	, m.from_site as second_site																				' + char(10) ;
	SET @mDQry = @mDQry + ' 	, dbo.FN_GET_SCM_SITE_DESCRIPTION(m.division_id, m.from_site) as second_site_name							' + char(10) ;
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
	SET @mDQry = @mDQry + ' 	, dateadd(day, (select isnull(ship_frozen , 0) as ship_frozen 												' + char(10) ;
	SET @mDQry = @mDQry + ' 		from scm_mst_site 																						' + char(10) ;
	SET @mDQry = @mDQry + ' 		where division_id= m.division_id and scm_site_id= from_site)							' + char(10) ;
	--IF @p_division_id != 'EE'
	--	BEGIN SET @mDQry = @mDQry + ' 		where division_id='''+@p_division_id+''' and scm_site_id= from_site)							' + char(10) ; END
	--ELSE
	--	BEGIN SET @mDQry = @mDQry + ' 		where division_id='''+@p_origion_division_id+''' and scm_site_id= from_site)					' + char(10) ; END

	SET @mDQry = @mDQry + ' 	, convert(date , '''+@plan_start_date+''' , 112)) as SHIP_FROZEN											' + char(10) ;
	-- BOD 2단계 개발 : 시작
	SET @mDQry = @mDQry + ' 	, CONVERT(date,m.from_yyyymmdd,112)		as FROM_YYYYMMDD													' + char(10) ;
	SET @mDQry = @mDQry + ' 	, CONVERT(date,m.to_yyyymmdd,112)		as TO_YYYYMMDD														' + char(10) ;
	--SET @mDQry = @mDQry + ' FROM scp_mst_bod_v m  WITH(NOLOCK)																			' + char(10) ;
	SET @mDQry = @mDQry + ' FROM scp_mst_bod_n_v m  WITH(NOLOCK)																			' + char(10) ;
	-- BOD 2단계 개발 : 끝
	SET @mDQry = @mDQry + ' inner join SCM_MST_SITE s (nolock) on m.division_id=s.division_id and m.from_site = s.SCM_SITE_ID				' + char(10) ;
	SET @mDQry = @mDQry + ' inner join SCM_MST_SITE_ITEM_PRIORITY (nolock) p on m.division_id=p.division_id and p.item_id = '''+@p_item_id+'''		' + char(10) ;
	SET @mDQry = @mDQry + ' WHERE 1=1																										' + char(10) ;

	IF (@p_division_id = 'EE')			
		BEGIN SET @mDQry = @mDQry + ' 	AND m.division_id   IN (''40'',''81'',''82'')														' + char(10) ; END
	ELSE IF (@p_division_id = 'EE_UC')	
		BEGIN SET @mDQry = @mDQry + ' 	AND m.division_id   = ''81_UC''														' + char(10) ; END
	ELSE
		BEGIN SET @mDQry = @mDQry + ' 	AND m.division_id   = '''+@p_division_id+'''														' + char(10) ; END

	SET @mDQry = @mDQry + ' 	AND m.to_site		= '''+@p_to_site+''' 																	' + char(10) ;
	SET @mDQry = @mDQry + ' 	--and m.bod_id = @p_bod_id																					' + char(10) ;
	SET @mDQry = @mDQry + ' 	AND s.OPERATION_GROUP= '''+@p_oper_grp+'''																	' + char(10) ;
	SET @mDQry = @mDQry + ' order by to_site asc ,  from_site asc																			' + char(10) ;
	
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
