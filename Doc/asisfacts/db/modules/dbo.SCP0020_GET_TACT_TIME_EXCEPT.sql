

/*
 * Program ID   : SCP0020_GET_TACT_TIME_EXCEPT
 * Description  : Loss Time
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/09   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/28   hwyoon		   사용여부(use_yn) 컬럼 조회 추가
 ex) 
  EXEC SCP0020_GET_TACT_TIME_EXCEPT @p_division_id='81', @p_plant_site='A040-P', @p_operation_id='P5000', @p_item_id='AMDAU0030B', @p_line_id='P1QP2', @debug_mode='F'

 */

CREATE PROCEDURE [dbo].[SCP0020_GET_TACT_TIME_EXCEPT]
   @p_division_id		NVARCHAR(MAX) 
  ,@p_plant_site		NVARCHAR(MAX)
  ,@p_operation_id		NVARCHAR(MAX) 
  ,@p_item_id           NVARCHAR(MAX) 
  ,@p_line_id   		NVARCHAR(MAX)  
  ,@debug_mode          NVARCHAR(1) ='F' 
AS

BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

		SELECT 
			 a.division_id
			,a.plant_site_id
			,dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id, a.plant_site_id ) as plant_site_name
			,a.operation_id
			,c.segment1 AS operation_name
			,a.item_id
			,dbo.FN_GET_ITEM_NICKNAME(a.division_id, a.item_id) AS nick_name
			,a.line_id
			,convert(datetime, d.tact_time_start_date) AS tact_time_start_date
			,convert(datetime, d.tact_time_end_date) AS tact_time_end_date
			,d.tact_time
		    ,ROUND(d.yield*100,2) AS yield
			,d.except_comment
			,d.use_yn
		    ,d.created_by
		    ,d.creation_date
		    ,d.last_updated_by
		    ,d.last_update_date
			-- pk 확인용
			,d.division_id          AS org_division_id          
			,d.plant_site_id        AS org_plant_site_id        
			,d.item_id              AS org_item_id              
			,d.operation_id         AS org_operation_id         
			,d.line_id              AS org_line_id              
			,d.tact_time_start_date AS org_tact_time_start_date 
			,d.tact_time_end_date   AS org_tact_time_end_date   

		FROM SCP_MST_TACT_TIME a (NOLOCK) 
		INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
						FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
						WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
						AND    b.valid_yn    = 'Y'
						AND    b.segment3    = 'Y' -- Capa 세부 공정 여부						
					) c ON a.operation_id = c.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
		INNER JOIN SCP_MST_TACT_TIME_EXCEPT d ON a.division_id  = d.division_id 
											AND a.plant_site_id  = d.plant_site_id
											AND a.operation_id = d.operation_id 
											AND a.item_id      = d.item_id
											AND a.line_id      = d.line_id
		WHERE 1=1		
		AND a.division_id   = @p_division_id
		AND a.plant_site_id = @p_plant_site
		AND a.operation_id  = @p_operation_id
		AND a.item_id       = @p_item_id	
	    AND a.line_id       = @p_line_id
	    
	ORDER BY division_id, plant_site_id, operation_id,item_id , line_id, tact_time_start_date, tact_time_end_date

END
