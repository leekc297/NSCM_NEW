



/*
 * Program ID   : SCP0020_GET_TACT_TIME_EXCEPT_OSP
 * Description  : Tact Time Except
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/02/04   hwyoon			Initial Release [] 전지 GSCM(SCP) 운영 - [C20200116-000114] ESS 외주 Packer Line 계획 수립
 * 
 */

CREATE PROCEDURE [dbo].[SCP0020_GET_TACT_TIME_EXCEPT_OSP]
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
			,a.operation_id AS operation_name
			,a.item_id
			--,dbo.FN_GET_ITEM_NICKNAME(a.division_id, a.item_id) AS nick_name
			, (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-'  WHEN X.NICK_NAME = ''    THEN '-'  ELSE X.NICK_NAME END) 
				   FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID) AS NICK_NAME
			,a.line_id
			,convert(datetime, d.tact_time_start_date) AS tact_time_start_date
			,convert(datetime, d.tact_time_end_date) AS tact_time_end_date
			,d.tact_time
		    ,ROUND(d.yield*100,2) AS yield
			,d.DAILY_CAPACITY
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
		FROM SCP_MST_TACT_TIME_OSP a (NOLOCK) 
		INNER JOIN SCP_MST_TACT_TIME_EXCEPT_OSP d ON a.division_id  = d.division_id 
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


