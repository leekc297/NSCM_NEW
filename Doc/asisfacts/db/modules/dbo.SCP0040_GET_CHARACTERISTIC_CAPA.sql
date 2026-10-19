
/*
 * Program ID   : SCP0040_GET_CHARACTERISTIC_CAPA
 * Description  : Characteristic Capa 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/12/19   hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/02/14	hwyoon			[CSR:] Total제외, FP Capa 조회쿼리 수정
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 
 */

CREATE PROCEDURE [dbo].[SCP0040_GET_CHARACTERISTIC_CAPA]
--chaan	@p_division_id          NVARCHAR(2)
   @p_division_id        NVARCHAR(30)--chaan
  ,@p_plant_site_id		 NVARCHAR(MAX)
  ,@p_item_id            NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0040_FP') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0040_FP 

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0040_PLANT') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0040_PLANT 
	
	/*
	SELECT t.division_id, t.plant_id, s.scm_site_id, t.item_id, t.month, SUM(t.daily_capa) as daily_capa
	INTO #TblDynamicPivot_SCP0040_FP
	FROM   scm_mst_tact_time_sn t with(nolock)
		,(
			SELECT *
			FROM   scm_mst_site with(nolock)
			WHERE  site_type       = 'PLANT'
			AND    operation_group = 'A'
			AND    osp_yn          = 'N'
			AND    valid_yn        = 'Y'
		) s
		, SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
	WHERE  1=1
	AND    t.division_id  = s.division_id
	AND    t.plant_id     = s.plant_id
	--AND    t.operation_id IN ('F6000','F5300','F5500', 'F5600')
	AND    t.month        = SUBSTRING(CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112), 1, 6)
	AND	   L.LOOKUP_TYPE='OPERATION_CHAR' 
	AND	   L.VALID_YN='Y' 
	AND    L.SEGMENT3='Y' 
	AND    L.SEGMENT1=t.operation_id
	GROUP BY t.division_id, t.plant_id, s.scm_site_id, t.item_id, t.month
	*/


	SELECT tt.division_id
        ,  tt.plant_site_id as scm_site_id
        ,  tt.item_id
        ,  SUM(ROUND((1440*60) / tt.tact_time, 0)) AS daily_capa
	INTO #TblDynamicPivot_SCP0040_FP
    FROM   scp_mst_tact_time tt WITH (NOLOCK)
    WHERE  tt.valid_yn = 'Y'
    --AND    tt.division_id = @p_division_id
    AND    tt.operation_id IN ( SELECT  b.segment2 AS operation_id
                                FROM    scm_adm_lookup_master_detail a WITH(NOLOCK)
                                        INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                                        ON  a.segment1    = b.segment1
                                        AND a.lookup_type = 'LOCATION_GROUP'
                                        AND a.segment4    = 'Y' -- Capa 공정 여부 
                                        AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                                        AND a.valid_yn    = 'Y'
                                        AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                        AND b.valid_yn    = 'Y'
                                        AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
                                        AND a.segment3    = 'A' -- 셀 Capa  공정(A3000, A9000)
                            ) -- LINE CAPA 대상인 셀 공정 
    GROUP BY tt.division_id, tt.plant_site_id, tt.item_id


	SELECT a.scm_site_id
	INTO #TblDynamicPivot_SCP0040_PLANT
	FROM scm_mst_site a
	JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
	WHERE a.osp_yn ='N'
	AND a.SITE_TYPE='PLANT'
	AND a.valid_yn ='Y'
	AND c.valid_yn ='Y'
	AND C.item_ID       IN ( SELECT token FROM dbo.String_Split(@p_item_id	 ,','))
	GROUP BY a.scm_site_id


	SELECT  
		  t.division_id
		, t.scm_site_id
		, t.SITE_DESCRIPTION as scm_site_name
		, ( CASE WHEN t.item_id = '-' THEN 'Total' ELSE t.item_id END ) AS item_id
		, t.daily_capa_qty
		, B.daily_capa AS daily_capa_qty_fp
		, (CASE WHEN t.daily_capa_qty IS NULL THEN '1' ELSE '2' END) AS capa_order
		, t.valid_yn
		, t.created_by
		, t.creation_date
		, t.last_updated_by
		, t.last_update_date
	FROM(
		-- Caracteristic 모델 조회
		SELECT DISTINCT a.division_id, a.scm_site_id, a.SITE_DESCRIPTION ,c.item_id, d.daily_capa_qty, d.valid_yn, d.created_by, d.creation_date, d.last_updated_by, d.last_update_date
		FROM scm_mst_site a
		JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
		JOIN SCP_MST_CHAR_CAPA d ON a.division_id = d.division_id and a.scm_site_id = d.plant_site_id and c.item_id = d.item_id
		WHERE a.osp_yn ='N'
		AND a.SITE_TYPE='PLANT'
		AND a.valid_yn ='Y'
		AND c.valid_yn ='Y'
		UNION
		-- 업체 Total 표시를 위해 '-' 로 추가 
		/*
		SELECT  DISTINCT a.division_id, a.scm_site_id, a.SITE_DESCRIPTION, d.item_id, d.daily_capa_qty, d.valid_yn, d.created_by, d.creation_date, d.last_updated_by, d.last_update_date
		FROM scm_mst_site a
		JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
		JOIN SCP_MST_CHAR_CAPA d ON a.division_id = d.division_id and a.scm_site_id = d.plant_site_id
		WHERE a.osp_yn ='N'
		AND a.SITE_TYPE='PLANT'
		AND a.valid_yn ='Y'
		AND c.valid_yn ='Y'
		AND d.item_id = '-'
		UNION
		*/
		-- SCP_MST_CHAR_CAPA 에 없는 등록이 필요한 모델 조회(Total)
		/*
		SELECT  DISTINCT a.division_id, a.scm_site_id, a.SITE_DESCRIPTION, '-',null,'Y',null,null,null,null
		FROM scm_mst_site a
		JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
		WHERE a.osp_yn ='N'
		AND a.SITE_TYPE='PLANT'
		AND a.valid_yn ='Y'
		AND c.valid_yn ='Y'
		AND NOT EXISTS (SELECT 'X' FROM SCP_MST_CHAR_CAPA D WHERE a.division_id = d.division_id and a.scm_site_id = d.plant_site_id AND d.item_id ='-')
		UNION
		*/
		-- SCP_MST_CHAR_CAPA 에 없는 등록이 필요한 모델 조회(ITEM)
		SELECT  DISTINCT a.division_id, a.scm_site_id, a.SITE_DESCRIPTION, c.item_id,null,'Y',null,null,null,null
		FROM scm_mst_site a
		JOIN SCM_MST_SITE_ITEM_PRIORITY c ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
		WHERE a.osp_yn ='N'
		AND a.SITE_TYPE='PLANT'
		AND a.valid_yn ='Y'
		AND c.valid_yn ='Y'
		AND NOT EXISTS (SELECT 'X' FROM SCP_MST_CHAR_CAPA D WHERE a.division_id = d.division_id and a.scm_site_id = d.plant_site_id AND d.item_id =c.item_id)
	) t 
	LEFT JOIN #TblDynamicPivot_SCP0040_FP B ON T.DIVISION_ID = B.DIVISION_ID AND T.SCM_SITE_ID=B.SCM_SITE_ID AND T.ITEM_ID = B.ITEM_ID
	WHERE 1=1
	AND t.division_id				   =    @p_division_id
	AND (isnull(@p_plant_site_id, '' ) = '' OR t.scm_site_id   IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id	 ,',')) )
	AND (	isnull(@p_item_id,       '' ) = '' 
			OR t.item_ID       IN ( SELECT token FROM dbo.String_Split(@p_item_id	 ,',')) 
			OR (t.scm_site_id in (select scm_site_id from #TblDynamicPivot_SCP0040_PLANT) and t.item_id='-')
		)
	ORDER BY capa_order, t.division_id		,t.scm_site_id		,t.item_id
	;


	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0040_FP') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0040_FP 

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0040_PLANT') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0040_PLANT 

END
