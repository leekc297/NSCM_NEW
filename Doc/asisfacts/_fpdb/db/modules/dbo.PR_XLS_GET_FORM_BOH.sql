
/*
 * Program ID   : PR_XLS_GET_FORM_BOH
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
 exec [dbo].[PR_XLS_GET_FORM_BOH] 'UC1', '20240807' , '20240801'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_FORM_BOH]
    @p_apl_code                 NVARCHAR(MAX)  = 'UC1' 
,	@p_cutoff_date			    NVARCHAR(MAX)
,	@p_yyyymmdd_from			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_cutoff_date			nvarchar(max)
	DECLARE @v_yyyymmdd_from		nvarchar(max)

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	set @v_apl_code			= @p_apl_code
	set @v_cutoff_date			= format( convert(datetime, @p_cutoff_date), 'yyyy-MM-dd')
	set @v_yyyymmdd_from		= format( convert(datetime, @p_yyyymmdd_from), 'yyyy-MM-dd')


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
		       CONCAT(DATEDIFF(DAY, '1900-01-01', CASE WHEN FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') < @v_yyyymmdd_from THEN @v_yyyymmdd_from ELSE FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') END) + 2, LINE_ID)   AS 'OutDate_Line'	
		     , LINE_ID                               AS 'Line'	
		     , CASE WHEN FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') < @v_yyyymmdd_from THEN @v_yyyymmdd_from ELSE FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') END AS 'Out Date'	
		     , SUM(QTY)                              AS QTY 	
		  FROM SCM_AGING_STOCK_H  WITH(NOLOCK)	
		WHERE COMPANY_ID  = @v_company_id
		  AND DIVISION_ID = @v_division_id
		  AND SITE_ID     = @v_site_id
		  AND PLANT_ID    = @v_plant_id
		 -- AND FACTORY_ID  = 'AB'	
		  AND CUTOFF_DATE = @v_cutoff_date
		GROUP BY	
		      CONCAT(DATEDIFF(DAY, '1900-01-01', CASE WHEN FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') < @v_yyyymmdd_from THEN @v_yyyymmdd_from ELSE FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') END) + 2, LINE_ID)	
		    , LINE_ID	
		    , CASE WHEN FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') < @v_yyyymmdd_from THEN @v_yyyymmdd_from ELSE FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') END	
		ORDER BY	
		      LINE_ID	
		    , CONCAT(DATEDIFF(DAY, '1900-01-01', CASE WHEN FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') < @v_yyyymmdd_from THEN @v_yyyymmdd_from ELSE FORMAT(AVAILABLE_DATE, 'yyyy-MM-dd') END) + 2, LINE_ID)	
			;


	END TRY

	BEGIN CATCH
	    PRINT ERROR_MESSAGE()


	END CATCH

END

