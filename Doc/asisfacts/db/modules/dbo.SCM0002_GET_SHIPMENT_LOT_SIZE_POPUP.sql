

/*
 * Program ID   : SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP
 * Description  : Shipment Lot Size 입력/삭제 대상목록 조회
 * Program History
 
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/09/06   YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/12   ygkim			p_to_site 조건 추가
 *
 */
CREATE PROCEDURE [dbo].[SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP]
	@p_division_id		NVARCHAR(max),
	@p_operation_group	NVARCHAR(max),
	@p_from_site		NVARCHAR(max),
	@p_to_site			NVARCHAR(max),
	@p_item_id			NVARCHAR(max),
	@p_action_flag		NVARCHAR(1)=''
AS
BEGIN

	IF( @p_action_flag ='I') 
		BEGIN
			select DIVISION_ID
					,OPERATION_GROUP_ID
					,operation_group_name
					,from_site
					,from_site_description
					,TO_SITE
					,to_site_description
					,ITEM_ID
					,NICK_NAME
			from(
					select distinct a.DIVISION_ID
							,b.OPERATION_GROUP_ID
							,dbo.fn_get_lookup_code_desc('OPERATION_GROUP',b.OPERATION_GROUP_ID) operation_group_name
							,a.PLANT_SITE_ID from_site
							,e.TO_SITE
							,ISNULL(dbo.fn_get_scm_site_description (a.division_id, a.PLANT_SITE_ID) , '-') AS from_site_description
							,ISNULL(dbo.fn_get_scm_site_description (a.division_id, e.TO_SITE) , '-') AS to_site_description
							,a.ITEM_ID	  	  
							,b.NICK_NAME
					from scm_mst_site_item_priority a
					inner join scm_mst_final_item_v b on a.DIVISION_ID = b.DIVISION_ID and a.ITEM_ID = b.ITEM_ID
					inner join (select distinct DIVISION_ID, FROM_SITE, TO_SITE
								from SCP_MST_BOD
								where VALID_YN = 'Y') e on e.DIVISION_ID = a.DIVISION_ID and e.FROM_SITE = a.PLANT_SITE_ID
					where 1=1
						and a.DIVISION_ID = @p_division_id
						and a.VALID_YN = 'Y'
						and ( ( @p_operation_group      IS NULL OR  @p_operation_group      ='' ) OR b.OPERATION_GROUP_ID       IN (SELECT token FROM dbo.String_Split(@p_operation_group		,',')) )
						and ( ( @p_from_site      IS NULL OR  @p_from_site      ='' ) OR a.PLANT_SITE_ID       IN (SELECT token FROM dbo.String_Split(@p_from_site		,',')) )
						and ( ( @p_to_site      IS NULL OR  @p_to_site      ='' ) OR e.TO_SITE       IN (SELECT token FROM dbo.String_Split(@p_to_site		,',')) )
						and ( ( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR a.item_id like @p_item_id + '%' )
						and not exists(select 1 from scp_mst_shipment_lot_size b where b.DIVISION_ID = a.DIVISION_ID and b.OPERATION_GROUP = b.OPERATION_GROUP and b.FROM_SITE = a.PLANT_SITE_ID
																				 and b.ITEM_ID = a.ITEM_ID and b.TO_SITE=e.TO_SITE) 
			) a
			order by a.DIVISION_ID, OPERATION_GROUP_ID, a.from_site, TO_SITE, a.ITEM_ID
		END ;

	ELSE IF(@p_action_flag ='D')
		BEGIN
			select distinct DIVISION_ID
					,OPERATION_GROUP_ID
					,operation_group_name
					,from_site
					,from_site_description
					,TO_SITE
					,to_site_description
					,ITEM_ID
					,NICK_NAME
			from(
					select a.division_id
							, a.OPERATION_GROUP OPERATION_GROUP_ID
							, dbo.fn_get_lookup_code_desc('OPERATION_GROUP',a.OPERATION_GROUP) operation_group_name
							, a.FROM_SITE
							, ISNULL(dbo.fn_get_scm_site_description (a.division_id, a.FROM_SITE) , '-') AS from_site_description
							, a.TO_SITE
							, ISNULL(dbo.fn_get_scm_site_description (a.division_id, a.TO_SITE) , '-') AS to_site_description
							, a.ITEM_ID
							--, '' NICK_NAME
							,(SELECT TOP 1 ISNULL(b.NICK_NAME,'')
								   FROM DBO.SCM_MST_ITEM_SN b WITH(NOLOCK) 
								  WHERE 1=1
									AND b.ITEM_ID              = a.ITEM_ID) NICK_NAME
					from scp_mst_shipment_lot_size a
					where a.DIVISION_ID = @p_division_id
						  and a.VALID_YN = 'Y'
						  and ( ( @p_operation_group      IS NULL OR  @p_operation_group      ='' ) OR a.OPERATION_GROUP IN (SELECT token FROM dbo.String_Split(@p_operation_group		,',')) )
						  and ( ( @p_from_site      IS NULL OR  @p_from_site      ='' ) OR a.FROM_SITE       IN (SELECT token FROM dbo.String_Split(@p_from_site		,',')) )
						  and ( ( @p_to_site      IS NULL OR  @p_to_site      ='' ) OR a.TO_SITE       IN (SELECT token FROM dbo.String_Split(@p_to_site		,',')) )
						  and ( ( @p_item_id      IS NULL OR  @p_item_id      ='' ) OR a.item_id like @p_item_id + '%' )
			) a
			order by a.DIVISION_ID, OPERATION_GROUP_ID, a.from_site, TO_SITE, a.ITEM_ID
		END ;

END


