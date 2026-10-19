
/*
 * Program ID   : SCM0002_GET_CAPACITY_ALLOCATION_POPUP
 * Description  : Capacity Allocation 입력/삭제 대상목록 조회
 * Program History
 
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/08/24   YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/05   YHW				조회조건 수정
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 *
 */
CREATE PROCEDURE [dbo].[SCM0002_GET_CAPACITY_ALLOCATION_POPUP]
--chaan	@p_division_id	NVARCHAR(2),
	@p_division_id	NVARCHAR(30),--chaan
	@p_action_flag	NVARCHAR(1)='',
	@p_item_id		NVARCHAR(200)=''
AS
BEGIN

	IF( @p_action_flag ='I') 
		BEGIN
			SELECT DISTINCT b.DIVISION_ID, b.ITEM_ID, d.NICK_NAME
			FROM SCM_MST_SITE_ITEM b
			JOIN SCM_MST_SITE C ON b.division_id = c.division_id AND b.scm_site_id = c.scm_site_id
			JOIN SCM_MST_ITEM_SN d ON b.division_id = d.division_id AND b.item_id = d.item_id
			WHERE 1=1
			AND B.DIVISION_ID=@p_division_id
			AND ( ( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR b.item_id  like '%'+@p_item_id+'%' OR d.NICK_NAME like @p_item_id+'%')
			AND c.site_type ='SALES'
			AND d.SCP_OPERATION_GROUP ='A'
			and not exists (select 'x' from DM_MST_CAPACITY_ALLOCATION a
							where b.DIVISION_ID = a.DIVISION_ID 
							and b.ITEM_ID = a.ITEM_ID
						   )
			AND B.VALID_YN='Y'
			AND C.VALID_YN='Y'
			ORDER BY item_id
		END ;

	ELSE IF(@p_action_flag ='D')
		BEGIN
			SELECT DISTINCT DIVISION_ID, ITEM_ID
				   , (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-'  WHEN X.NICK_NAME = ''    THEN '-'  ELSE X.NICK_NAME END) 
						FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  
					   WHERE  X.ITEM_ID  = A.item_id) AS NICK_NAME
			FROM DM_MST_CAPACITY_ALLOCATION A WITH(NOLOCK)
		   WHERE A.DIVISION_ID=@p_division_id
			 AND ( ( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR A.item_id  like '%'+@p_item_id+'%' OR
				(SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-'  WHEN X.NICK_NAME = ''    THEN '-'  ELSE X.NICK_NAME END) 
						FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  
					   WHERE  X.ITEM_ID  = A.item_id) like @p_item_id+'%'
			 )

		END ;

END

