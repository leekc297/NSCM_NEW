


/*
 * Program ID   : SCM0002_GET_BODITEM_FOR_PRJROUTE_POPUP
 * Description  : BOD ITEM(For Project Route) 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/08/27   hwyoon			Initial Release [PJ20189106] 전지GSCM 고도화 - (SCP)Shipment Request 신설
 * 2021/07/07   khj79			PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 *
 */
CREATE PROCEDURE [dbo].[SCM0002_GET_BODITEM_FOR_PRJROUTE_POPUP]
--chaan   @p_division_id				NVARCHAR(2)
   @p_division_id				NVARCHAR(30)--chaan
  ,@p_operation_group			NVARCHAR(2)
  ,@p_item_id					NVARCHAR(MAX)
  ,@p_from_yyyymmdd				NVARCHAR(8)
  ,@p_prgram_id					NVARCHAR(MAX)
AS  
  
BEGIN
		SET NOCOUNT ON; 
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

		declare @p_to_site_type nvarchar(max) = 'PLANT';

		SELECT  distinct
				a.division_id
				,b.from_site
				,SF.division_id AS FROM_DIVISION_ID
				,SF.SITE_TYPE AS FROM_SITE_TYPE
				,SF.SITE_DESCRIPTION AS FROM_SITE_NAME
				,b.to_site
				,ST.division_id AS TO_DIVISION_ID
				,ST.SITE_TYPE AS TO_SITE_TYPE
				,ST.SITE_DESCRIPTION AS TO_SITE_NAME
				,a.item_id
				,a.priority
				,a.bod_id
				,b.incoterms
				,c.transport_mode
				-- BOD 2단계 개발 
				--,(SELECT v.lt_total FROM scp_mst_bod_v v WHERE v.division_id = b.division_id  and v.bod_id = b.bod_id ) AS lead_time
				,(SELECT v.lt_total FROM scp_mst_bod_n_v v WHERE v.division_id = b.division_id  and v.bod_id = b.bod_id ) AS lead_time
				,a.valid_yn AS BOD_ITEM_VALID
				,c.route_id  
 				,c.days_mon  
 				,c.days_tue  
 				,c.days_wed  
 				,c.days_thu  
 				,c.days_fri  
 				,c.days_sat  
 				,c.days_sun  
				,CONVERT(CHAR(8), DATEADD(DD, isnull(fs.ship_frozen,0), CONVERT(VARCHAR, @p_from_yyyymmdd, 121)), 112) frozen_yyyymmdd -- Ship Frozen구간 다음일자
				,CONVERT(date,b.attribute2,112)		AS BOD_FROM_YYYYMMDD	-- BOD 2단계 개발
				,CONVERT(date,b.attribute3,112)		AS BOD_TO_YYYYMMDD		-- BOD 2단계 개발
		FROM scp_mst_bod_item a  
		INNER JOIN scp_mst_bod b  ON a.bod_id = b.bod_id
		INNER JOIN SCM_MST_SITE SF ON SF.SCM_SITE_ID=b.from_site and sf.SITE_TYPE='PLANT' and sf.operation_group=@p_operation_group
		INNER JOIN SCM_MST_SITE ST ON ST.SCM_SITE_ID=b.to_site AND ST.SITE_TYPE = @p_to_site_type
		INNER JOIN scp_mst_distribution_route c  ON b.route_id = c.route_id 
		INNER JOIN scm_mst_site fs	ON  a.division_id      = fs.division_id
									AND b.from_site    = fs.scm_site_id
									AND fs.site_type       = 'PLANT'  
									AND fs.operation_group = @p_operation_group--'A'
									AND fs.osp_yn          = 'N'
									AND fs.valid_yn        = 'Y'	 
		WHERE a.division_id = @p_division_id
			AND a.item_id=@p_item_id
			and b.incoterms='DAP' -- Semi 용 DAP 적용
			and SF.PLANT_ID <> ST.PLANT_ID -- 동일 Plant 제외(A040-A -> A040-P 등)
		ORDER BY a.valid_yn desc, a.division_id, b.from_site, b.to_site, a.priority, c.transport_mode
;
								  
END


