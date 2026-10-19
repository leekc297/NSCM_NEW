
/*
 * Program ID   : SCP0115_GET_COMBOBOX_DATA
 * Description  : Get data for  발생사유 유형, 소진방안 유형ComboBox
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 *2024/10/11 	Quoc Tan (tanvq1)	Add new procedure to get Master Data for comboBox
 */

CREATE PROCEDURE [dbo].[SCP0115_GET_COMBOBOX_DATA]
	@p_lookup_type			NVARCHAR(100),
	@p_valid_yn			NVARCHAR(1) = 'Y'
	
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	IF @p_lookup_type = 'SCM_LGTM_PCY_INV_PLAN_TYPE' 
			BEGIN
					select segment1 AS CODE, TRIM(attribute1) AS [NAME]
					from   SCM_ADM_LOOKUP_MASTER_DETAIL
					where  lookup_type = @p_lookup_type
					AND    VALID_YN = @p_valid_yn;
			END
	ELSE 
			BEGIN
					select Distinct segment2 AS CODE, TRIM(attribute1) AS [NAME]
					from   SCM_ADM_LOOKUP_MASTER_DETAIL
					where  lookup_type = @p_lookup_type
					AND    VALID_YN = @p_valid_yn
			END
	
END