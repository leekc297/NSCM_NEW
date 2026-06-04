
/* =============================================================================
프로그램ID	: UP_FX_GetReqAuthGroupInfoList
업  무  명	: 권한 요청 - 권한 조회 조건추가
프로그램명	: 권한 요청
최초작성일	: 2018.3
최종작성일	: 2018.3
개  발  자	: KYH
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/10   KIMYONGHO      [C20210310-000519] LOOKUP_TYPE 추가  'AUTH_REQ_MAIL_SEND' 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_GetReqAuthGroupInfo]
AS
BEGIN
	SET NOCOUNT ON;

	select 
		      a.GroupID
			, a.GrpName
			, a.UseYN
			, a.RegtUserID
			, c.SEGMENT2 AS GrpDescription
			, c.SEGMENT3 AS GrpMail
	from TB_FX_GroupInfo (nolock) a
	left join SCM_ADM_LOOKUP_MASTER_detail (nolock) b on b.lookup_type='REQ_NO_DISPLAY' and a.groupid=b.segment1
	left outer join SCM_ADM_LOOKUP_MASTER_detail (nolock) c on c.lookup_type='AUTH_REQ_MAIL_SEND' and a.groupid=c.segment1
	where b.lookup_type is null
		and a.useyn='Y'

	--declare @cond nvarchar(1000) = N''
	--set @cond = '''' + replace(@p_DispNo, '^', ''',''') + '''' ;
	--declare @SQL nvarchar(500) = N'
	--SELECT 
	--	 GroupID
	--	, GrpName
	--	, UseYN
	--	, RegtUserID
	--FROM TB_FX_GroupInfo WITH(NOLOCK)
	--where groupID not in (' + @cond + ')';
	--exec (@SQL)

END


