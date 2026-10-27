
/*
 * Program ID   : PR_XLS_GET_YIELD_RAW
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_YIELD_RAW] 'UC1', '202408' , '202409'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_YIELD_RAW]
    @p_apl_code                 nvarchar(max)  = 'UC1'
,	@p_yyyymm_from			NVARCHAR(MAX)
,	@p_yyyymm_to			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_yyyymm_from			nvarchar(max)
	DECLARE @v_yyyymm_to			nvarchar(max)

	set @v_apl_code			= @p_apl_code
	set @v_yyyymm_from		= @p_yyyymm_from --format( convert(datetime, @p_yyyymmdd_rom), 'yyyyMMdd')
	set @v_yyyymm_to		= @p_yyyymm_to --format( convert(datetime, @p_cutoff_date_to), 'yyyyMMdd')

    
    BEGIN TRY		
        select             
		      'YD' as GUBUN
            , 'YD' + 
               CASE WHEN XX.OPERATION_ID = 'A5000' THEN 'Notching'
                    WHEN XX.OPERATION_ID = 'A8000' THEN 'L&S'
                    WHEN XX.OPERATION_ID = 'A9000' THEN 'PKG'
                    WHEN XX.OPERATION_ID = 'E2000' THEN 'Coating'
                    WHEN XX.OPERATION_ID = 'E3000' THEN 'R/P'
                    WHEN XX.OPERATION_ID = 'F6000' THEN 'EOL'
                    ELSE XX.OPERATION_ID
            END + 
            CASE WHEN XX.ELECTRODE_TYPE <> '-' THEN ' (' + XX.ELECTRODE_TYPE + ')'
                 ELSE ''
            END +
            REPLACE(CONCAT('#', SUBSTRING( XX.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', XX.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
            + FORMAT(CONVERT(DATE, XX.DATE, 112),'yyyy-MM-dd')
            AS KEYS_DATE
            , 'YD' + 
               CASE WHEN XX.OPERATION_ID = 'A5000' THEN 'Notching'
                    WHEN XX.OPERATION_ID = 'A8000' THEN 'L&S'
                    WHEN XX.OPERATION_ID = 'A9000' THEN 'PKG'
                    WHEN XX.OPERATION_ID = 'E2000' THEN 'Coating'
                    WHEN XX.OPERATION_ID = 'E3000' THEN 'R/P'
                    WHEN XX.OPERATION_ID = 'F6000' THEN 'EOL'
                    ELSE XX.OPERATION_ID
            END + 
            CASE WHEN XX.ELECTRODE_TYPE <> '-' THEN ' (' + XX.ELECTRODE_TYPE + ')'
                 ELSE ''
            END
            AS KEYS
            , FORMAT(CONVERT(DATE, XX.DATE, 112),'yyyy-MM-dd') AS DATE 
            , XX.YIELD
            , XX.COMPANY_ID    
		    , XX.DIVISION_ID 	
		    , XX.SITE_ID     	
		    , XX.PLANT_ID    	
		    , XX.FACTORY_ID  	
		    , XX.OPERATION_ID	
		    , XX.LINE_ID     	
		    , XX.ELECTRODE_TYPE	
		from BUF_SCM_YIELD_M XX WITH(NOLOCK);


		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()
        	
	END CATCH

END



