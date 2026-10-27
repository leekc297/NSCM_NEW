
/*
 * Program ID   : PR_XLS_GET_LINE
 * Description  : 공정별 라인(서편, 동편 순서로 각각 1개 라인씩 리스팅)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.12.16   shineuiho67.         Create. : APL, 공정을 파라메터로 넘겨받아서, 공정별로, WEST 1, EAST 1 , WEST 2, EAST 2 순 라인아이디만을 추출 (Planning UI 시트에서 사용)
 * 2025.01.02   shineuiho67.         RowNum, Line_Group_id 컬럼 추가 : UC2는 Line_Group_id : 모든 공정. WEST 로 설정되어 있음(편의상, 사실은 서편동편으로 나누지 않는데, 엑셀표상 WEST가 윗줄에 있어서)
 *
 * 
 ex) 
 exec [dbo].[PR_XLS_GET_LINE] 'UC1', 'F6000' --EOL  --데이터존재(DEV)
 exec [dbo].[PR_XLS_GET_LINE] 'UC1', 'A9000' --PKG
 exec [dbo].[PR_XLS_GET_LINE] 'UC1', 'A8000' --LNS
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_LINE]
    @p_apl_code             nvarchar(max)  = 'UC1'
,	@p_operation_id         NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_operation_id		    nvarchar(max)
	
	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	set @v_apl_code			= @p_apl_code
	set @v_operation_id	    = @p_operation_id
	
	BEGIN TRY	
			
		select @v_company_id		= attribute1
			 , @v_division_id		= attribute2
			 , @v_site_id			= attribute3
			 , @v_plant_id			= attribute4
			 , @v_elec_plant_id		= attribute5
		  from dbo.SCM_SYS_LOOKUP_VALUE with(nolock)
		 where lookup_type_code = 'XLS_PLAN_APL_PLANT'
		   and segment1 = @v_apl_code
		   and active_flag = 'Y'
		
        select AA.line
                , row_number() over (order by (select null)) as RowNum
                , AA.line_group_id                           as line_group_id
          from (
                SELECT  top 100 REPLACE(CONCAT('#', SUBSTRING( A.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', A.LINE_ID), 0), 0) AS INT), 2)),'#0','#') AS LINE
                        ,A.LINE_GROUP_ID 
                FROM    dbo.SCM_LINE_M A WITH(NOLOCK)
                WHERE   1=1
                AND     A.COMPANY_ID   = @v_company_id	
                AND     A.DIVISION_ID  = @v_division_id
                AND     A.SITE_ID	   = @v_site_id		
                AND     A.PLANT_ID     IN (@v_plant_id, @v_elec_plant_id)
                AND     A.OPERATION_ID = @v_operation_id
                AND     A.ACTIVE_FLAG = 'Y'
                ORDER   BY ROW_NUMBER() OVER (PARTITION BY A.LINE_GROUP_ID ORDER BY A.LINE_ID) 
                       ,A.LINE_GROUP_ID DESC
                ) AA
        

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()
	
	END CATCH
    
END

