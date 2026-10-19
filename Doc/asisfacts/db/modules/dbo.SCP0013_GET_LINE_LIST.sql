
/*
 * Program ID   : SCP0013_GET_LINE_LIST
 * Description  : Combo) Line List
 * Program History
 *===========================================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================================
 * 2023/12/07   vadabi3			Initial Release		Cell Type 선택 시 Line 필터 적용
                                                    UP_FX_GetCommonDataList_SCP) LineProdPlanLine, LineByOperationAddOSP 참조
 ----------------------------------------------------------------------------------------------------------------------------
   EXEC SCP0013_GET_LINE_LIST '40', 'A', 'A010-A,CN003256_40-A,F030-A,G182-A,KR004004_40-A', 'C', '20231218'


 */

CREATE PROCEDURE [dbo].[SCP0013_GET_LINE_LIST] 
	 @p_division_id			NVARCHAR(30)
	,@p_operation_group		NVARCHAR(MAX) 
	,@p_plant_site			NVARCHAR(MAX) 
	,@p_cell_type_gr		NVARCHAR(MAX) 
	,@p_plan_start_yyyymmdd	NVARCHAR(MAX) 
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

		-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0013_GET_LINE_LIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @d_event_end_date   DATETIME;

	-- 변수
    DECLARE @v_start_week      NVARCHAR(8);
    DECLARE @v_delete_yyyymm   NVARCHAR(6);
	DECLARE @v_plan_delete_yyyymm NVARCHAR(6);

	-- 계획 시작, 종료 구간
    DECLARE @v_period_start_date NVARCHAR(8);


			IF OBJECT_ID (N'tempdb..#TMP_LINE', N'U') IS NOT NULL
			DROP TABLE #TMP_LINE

			    SELECT a.LINE_ID
				  INTO #TMP_LINE
			      FROM scp_anl_production_plan a WITH(NOLOCK)
			INNER JOIN SCP_MST_FINAL_ITEM b  WITH(NOLOCK)
							 ON a.division_id = b.division_id 
							and a.item_id = b.item_id 
							and a.operation_group = b.operation_group
			WHERE 1 = 1
			and a.division_id				= @p_division_id
			and a.PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
			and A.SCM_SITE_ID IN			( SELECT token FROM dbo.String_Split(@p_plant_site,','))
			and b.CELL_TYPE_GROUP_CODE IN	( SELECT token FROM dbo.String_Split(@p_cell_type_gr,','))  
			and a.line_id != '*'
			and a.line_id != '-'
			group by  a.LINE_ID   
			OPTION (MERGE JOIN) 


			SELECT *
			FROM 
			(
			SELECT  '-'  AS CODE, '-'  AS NAME
			UNION
			   SELECT a.LINE_ID AS CODE
				    , a.LINE_ID + '   ' + L.LINE_NAME  AS NAME 
			     FROM #TMP_LINE a
			LEFT JOIN SCM_MST_LINE_SN L  WITH(NOLOCK) 
				   ON a.LINE_ID  = L.SCP_LINE_ID
				  and L.division_id =  @p_division_id
			) DATA
			ORDER BY CODE


		IF OBJECT_ID (N'tempdb..#TMP_LINE', N'U') IS NOT NULL
			DROP TABLE #TMP_LINE

END
