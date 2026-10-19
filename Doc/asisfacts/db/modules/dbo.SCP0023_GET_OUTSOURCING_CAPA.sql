/*
 * Program ID   : SCP0023_GET_OUTSOURCING_CAPA
 * Description  : 외주 Packer Capa 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/04/19   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/17   byunghunjung	전극 제외
 * 2018/12/27	hwyoon			아이템 조회 시 해당 Plant Total 조회 포함
 * 2019/01/28	hwyoon			[PS02199094B] [전지 GSCM 대응 및 고도화] Nick Name 조회항목 추가
 * 2020/02/10	hwyoon			ESS 외주 Pakcer Line 생산 Target 적용
 */

CREATE PROCEDURE [dbo].[SCP0023_GET_OUTSOURCING_CAPA]
   @p_division_id		 NVARCHAR(MAX)
  ,@p_plant_site_id		 NVARCHAR(MAX)
  ,@p_item_id            NVARCHAR(MAX)
  ,@p_valid				 NVARCHAR(1)
  ,@debug_mode			 NVARCHAR(20)  ='F'
  ,@p_nick_name			 NVARCHAR(MAX) =''
AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0023_PLANT') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0023_PLANT 

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0023_NICKITEM') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0023_NICKITEM


	/* NICK NAME 조회조건으로 ITEM 추출 */
	SELECT distinct ITEM_ID 
	INTO #TblDynamicPivot_SCP0023_NICKITEM
	FROM SCM_MST_ITEM_SN 
	WHERE 1=1
	AND NICK_NAME IS NOT NULL
	AND ISNULL(@p_nick_name,'')!=''
	AND NICK_NAME LIKE @p_nick_name+'%'


	SELECT  a.scm_site_id
	INTO #TblDynamicPivot_SCP0023_PLANT
	FROM scm_mst_site a
	JOIN SCM_MST_VENDOR b ON a.plant_id = b.vendor_code
	JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
	WHERE a.osp_yn ='Y'
	AND a.valid_yn ='Y'
	AND c.valid_yn ='Y'
	AND (	(C.item_ID IN ( SELECT token FROM dbo.String_Split(@p_item_id, ',')))
			or 
			(C.item_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0023_NICKITEM))    )
	group by a.scm_site_id


	SELECT  
		  t.division_id
		, t.scm_site_id
		, t.vendor_code
		, (select  top 1 b.vendor_name from SCM_MST_VENDOR b where  b.vendor_code = t.vendor_code ) as vendor_name
		
		, ( CASE WHEN t.item_id = '-' THEN 'Total' ELSE t.item_id END ) AS item_id
		--(SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = a.item_id)
		, ( CASE WHEN t.item_id = '-' THEN '' ELSE ((SELECT TOP 1 isnull(NULLIF(NICK_NAME,''),'-') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = t.item_id)) END ) AS nick_name
		, t.daily_capa_qty
		, (CASE WHEN t.daily_capa_qty IS NULL THEN '1' ELSE '2' END) AS capa_order
		, t.valid_yn
		, t.created_by
		, t.creation_date
		, t.last_updated_by
		, t.last_update_date
	FROM(
		
		-- outsourcing 모델 조회
		SELECT DISTINCT a.division_id, a.scm_site_id, b.vendor_code,  c.item_id, d.daily_capa_qty, d.valid_yn, d.created_by, d.creation_date, d.last_updated_by, d.last_update_date
		FROM scm_mst_site a
		JOIN SCM_MST_VENDOR b ON a.plant_id = b.vendor_code
		JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
		LEFT OUTER JOIN SCP_MST_OUTSOURCING_CAPA d ON a.division_id = d.division_id and a.scm_site_id = d.plant_site_id and c.item_id = d.item_id
		WHERE a.osp_yn ='Y'
		AND a.valid_yn ='Y'
		AND c.valid_yn ='Y'
		--ESS 외주 Pakcer Line 생산 Target 적용
		AND ISNULL(A.ATTRIBUTE1,'N') <>'Y'
		UNION
		-- 업체 Total 표시를 위해 '-' 로 추가 
		SELECT  DISTINCT a.division_id, a.scm_site_id, b.vendor_code, d.item_id, d.daily_capa_qty, d.valid_yn, d.created_by, d.creation_date, d.last_updated_by, d.last_update_date
		FROM scm_mst_site a
		JOIN SCM_MST_VENDOR b ON a.plant_id = b.vendor_code
		JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
		LEFT OUTER JOIN SCP_MST_OUTSOURCING_CAPA d ON a.division_id = d.division_id and a.scm_site_id = d.plant_site_id
		WHERE a.osp_yn ='Y'
		AND a.valid_yn ='Y'
		AND c.valid_yn ='Y'
		AND d.item_id = '-'
		--ESS 외주 Pakcer Line 생산 Target 적용
		AND ISNULL(A.ATTRIBUTE1,'N') <>'Y'
		UNION
		-- SCP_MST_OUTSOURCING_CAPA 에 없는 등록이 필요한 모델 조회
		SELECT  DISTINCT a.division_id, a.scm_site_id, b.vendor_code, '-',null,null,null,null,null,null
		FROM scm_mst_site a
		JOIN SCM_MST_VENDOR b ON a.plant_id = b.vendor_code
		JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
		WHERE a.osp_yn ='Y'
		AND a.valid_yn ='Y'
		AND c.valid_yn ='Y'
		AND NOT EXISTS (SELECT 'X' FROM SCP_MST_OUTSOURCING_CAPA D WHERE a.division_id = d.division_id and a.scm_site_id = d.plant_site_id AND d.item_id ='-')
		--ESS 외주 Pakcer Line 생산 Target 적용
		AND ISNULL(A.ATTRIBUTE1,'N') <>'Y'
		
	) t 
	WHERE 1=1
	AND t.division_id				   =    @p_division_id
	AND (isnull(@p_plant_site_id, '' ) = '' OR t.scm_site_id   IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id	 ,',')) )
	AND (isnull(@p_valid,         '' ) = '' OR t.valid_yn       IN ( SELECT token FROM dbo.String_Split(@p_valid	 ,',')) )
	AND (   (isnull(@p_item_id,       '' ) = '' and isnull(@p_nick_name, '' ) = '')
			OR t.item_ID       IN ( SELECT token FROM dbo.String_Split(@p_item_id	 ,',')) 
			OR (t.item_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0023_NICKITEM))
			OR (t.scm_site_id in (select scm_site_id from #TblDynamicPivot_SCP0023_PLANT) and t.item_id='-')
		)
	ORDER BY capa_order, t.division_id		,t.scm_site_id		,t.vendor_code		,t.item_id
	;


	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0023_PLANT') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0023_PLANT 

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0023_NICKITEM') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0023_NICKITEM

END
