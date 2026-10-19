



/****************************************************************************************************/
/* Program ID  : SSP0028_GET_AREA                                                                          */
/* Description : PRINT STRING                                                                       */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/*                                                */
/****************************************************************************************************/


CREATE PROCEDURE [dbo].[SSP0028_GET_AREA]

AS
BEGIN
    SET NOCOUNT ON;
	select distinct attribute1 AS CODE,  attribute1 AS NAME
from [dbo].[SCM_MST_PORT]
where 1 = 1
order by attribute1
	
END
