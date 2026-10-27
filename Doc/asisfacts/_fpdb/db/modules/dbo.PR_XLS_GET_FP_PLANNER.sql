
/*
 * Program ID   : [PR_XLS_GET_FP_PLANNER]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 
 * 
 * 
 ex)  PR_XLS_GET_FP_PLANNER 'UC1', 'crjung'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_FP_PLANNER]
	@p_apl_code         NVARCHAR(MAX)  = 'UC1'
,   @p_userid			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
    DECLARE @v_userid				NVARCHAR(MAX)='';

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	set @v_apl_code			= @p_apl_code
    set @v_userid			= @p_userid

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

	    SELECT 
                /*
                UIR.USER_ID AS USERID
                , IIF(UIR.SAVE_FLAG = 'Y', 'FP PLANNER', 'FP VIEWER') AS GROUPID
                , RIR.DIVISION_ID AS CODE
                , MAX(ISNULL(UIR.UPDATE_DTTM, UIR.INSERT_DTTM)) AS UPDATEDATETIME
                */
                count(UIR.USER_ID) as cnt
        FROM    [DBO].[TH_UIS_USER_INSTANCE_RELATE] AS UIR WITH(NOLOCK)
        JOIN    [DBO].[TH_UIS_ROLE_INSTANCE]           AS RI WITH(NOLOCK)      ON UIR.ROLE_ID		= RI.ROLE_ID  
        JOIN    [DBO].[TH_UIS_ROLE_INSTANCE_RELATE]    AS RIR WITH(NOLOCK)     ON RIR.ROLE_ID		= RI.ROLE_ID 
        WHERE   1 = 1
        AND     UIR.USE_AT_FLAG = 'Y'
        AND     RIR.USE_AT_FLAG = 'Y'
        AND     UIR.SAVE_FLAG	= 'Y' --FP PLANNER
        AND     UIR.USER_ID     = @v_userid 
        AND     RIR.DIVISION_ID = @v_division_id
        GROUP BY 
                UIR.USER_ID,
                UIR.SAVE_FLAG,
                    RIR.DIVISION_ID;

    END TRY

	BEGIN CATCH
	    PRINT ERROR_MESSAGE()


	END CATCH

END



