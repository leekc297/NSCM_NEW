/*
 * Program ID   : SCP0028_GET_SHIPMENT_LOT_SIZE
 * Description  : Shipment Lot Size 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/07/25   ygkim			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/11	hwyoon			lot size 입력 기준에 sales site 추가
 * 2018/09/19	hwyoon			조회조건 to_site 추가
 * 2018/10/08	hwyoon			조회조건 VALID_YN 조건문 수정
 * 2018/12/17	hwyoon			Split Yn 항목 추가
 * ex)
	EXEC SCP0028_GET_SHIPMENT_LOT_SIZE @p_division_id='81', @p_operation_group='P,A,E', @p_from_site='', @p_trans_mode='', @p_item_id='', @p_valid=NULL
 */
CREATE PROCEDURE [dbo].[SCP0028_GET_SHIPMENT_LOT_SIZE]
  @p_division_id			NVARCHAR(max),
  @p_operation_group		NVARCHAR(max),
  @p_from_site				NVARCHAR(max),
  @p_to_site				NVARCHAR(max)='',
  @p_trans_mode				NVARCHAR(max),
  @p_item_id				NVARCHAR(max),
  @p_valid					NVARCHAR(max)

AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	select DIVISION_ID
	      ,OPERATION_GROUP_ID
		  ,from_site
		  ,from_site_description
		  ,to_site
		  ,to_site_description
		  ,ITEM_ID
		  ,NICK_NAME
		  ,trans_mode_name
		  ,trans_mode_code
		  ,LOT_SIZE
		  ,INCREMENT
		  ,VALID_YN
		  ,SPLIT_YN
		  --,BOD_VALID_YN
		  ,CREATED_BY
		  ,CREATION_DATE
		  ,LAST_UPDATED_BY
		  ,LAST_UPDATE_DATE
	from(
			select distinct a.DIVISION_ID
				,a.OPERATION_GROUP OPERATION_GROUP_ID
				,a.FROM_SITE
				,ISNULL(dbo.fn_get_scm_site_description (a.division_id, a.FROM_SITE) , '-') AS from_site_description
				,a.TO_SITE
				,ISNULL(dbo.fn_get_scm_site_description (a.division_id, a.TO_SITE) , '-') AS to_site_description
				,a.ITEM_ID	  	  
				,b.NICK_NAME
				,c.trans_mode_name
				,C.trans_mode_code
				,f.LOT_SIZE
				,f.INCREMENT
				,isnull(f.VALID_YN,'Y') VALID_YN
				,isnull(f.SPLIT_YN,'N') SPLIT_YN
				--,isnull(BOD_VALID_YN,'N') BOD_VALID_YN
				,f.CREATED_BY
				,f.CREATION_DATE
				,f.LAST_UPDATED_BY
				,f.LAST_UPDATE_DATE
			from scp_mst_shipment_lot_size a with(nolock)
			inner join scm_mst_final_item_v b on a.DIVISION_ID = b.DIVISION_ID and a.ITEM_ID = b.ITEM_ID
			cross join (select segment2 trans_mode_name, SEGMENT1 trans_mode_code from SCM_ADM_LOOKUP_MASTER_DETAIL where LOOKUP_TYPE = 'TRANSPORT_MODE_CODE' and VALID_YN = 'Y') c
			left join scp_mst_shipment_lot_size f on a.DIVISION_ID = f.DIVISION_ID 
											and a.OPERATION_GROUP = f.OPERATION_GROUP 
											and a.FROM_SITE = f.FROM_SITE 
											and a.TO_SITE=f.TO_SITE 
											and C.trans_mode_code=f.TRANSPORT_MODE
											and a.ITEM_ID=f.ITEM_ID
			--left outer join (select distinct bod.DIVISION_ID, bod.FROM_SITE, bod.TO_SITE, bod.VALID_YN BOD_VALID_YN, ro.transport_mode 
								  --from SCP_MST_BOD bod
								  --join scp_mst_distribution_route ro on bod.ROUTE_ID=ro.ROUTE_ID) e 
								  --on e.DIVISION_ID = f.DIVISION_ID and e.FROM_SITE = f.FROM_SITE and e.TO_SITE = f.TO_SITE and e.TRANSPORT_MODE = f.TRANSPORT_MODE
			where 1=1
				and a.DIVISION_ID = @p_division_id
				--and a.VALID_YN = 'Y'
				and ( ( @p_operation_group	IS NULL OR  @p_operation_group	='' ) OR a.OPERATION_GROUP	IN (SELECT token FROM dbo.String_Split(@p_operation_group		,',')) )
				and ( ( @p_from_site		IS NULL OR  @p_from_site		='' ) OR a.FROM_SITE		IN (SELECT token FROM dbo.String_Split(@p_from_site		,',')) )
				and ( ( @p_to_site			IS NULL OR  @p_to_site			='' ) OR a.TO_SITE			IN (SELECT token FROM dbo.String_Split(@p_to_site		,',')) )
				and ( ( @p_trans_mode		IS NULL OR  @p_trans_mode		='' ) OR c.trans_mode_code	IN (SELECT token FROM dbo.String_Split(@p_trans_mode		,',')) )
				and ( ( @p_item_id			IS NULL OR  @p_item_id			='' ) OR a.item_id			IN (SELECT token FROM dbo.String_Split(@p_item_id		,',')) )
				and ( ( @p_valid			IS NULL OR  @p_valid			='' ) OR isnull(f.VALID_YN,'Y')       IN (SELECT token FROM dbo.String_Split(@p_valid		,',')) )
	) a
	order by a.DIVISION_ID, OPERATION_GROUP_ID, a.from_site, a.to_site, a.ITEM_ID, a.trans_mode_code
								  
END

