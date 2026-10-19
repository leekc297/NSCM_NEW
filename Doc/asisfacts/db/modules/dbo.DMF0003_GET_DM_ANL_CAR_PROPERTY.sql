-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DMF0003_GET_DM_ANL_CAR_PROPERTY]
	@p_division_id	NVARCHAR(30),
	@p_maker_name	NVARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;

	IF(@p_maker_name = '')
	BEGIN
		BEGIN
			SELECT DISTINCT MAKER_NAME AS CODE, MAKER_NAME AS NAME FROM [dbo].[DM_ANL_CAR_FCST_REF] ORDER BY MAKER_NAME
		END

		BEGIN
			SELECT DISTINCT CAR_MODEL AS CODE, CAR_MODEL AS NAME FROM [dbo].[DM_ANL_CAR_FCST_REF] ORDER BY CAR_MODEL
		END

		BEGIN
		   SELECT 'CELL' AS CODE, 'CELL' AS NAME
		   UNION
		   SELECT 'MODULE' AS CODE, 'MODULE' AS NAME
		   UNION
		   SELECT 'PACK' AS CODE, 'PACK' AS NAME
		END


	END
	ELSE IF(@p_maker_name != '')
	BEGIN
		SELECT DISTINCT CAR_MODEL AS CODE, CAR_MODEL AS NAME FROM [dbo].[DM_ANL_CAR_FCST_REF] WHERE MAKER_NAME = @p_maker_name
		ORDER BY CAR_MODEL
	END



END

