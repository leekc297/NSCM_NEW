
CREATE FUNCTION [dbo].[FN_GET_SCP_MST_CAPA_OEE]
(
	@DIVISION_ID	nvarchar(MAX)
  , @PLANT_ID		nvarchar(MAX)
  , @FACTORY_ID		nvarchar(MAX)
  , @OPERATION_ID	nvarchar(MAX)
  , @LINE_ID		nvarchar(MAX)
  , @ITEM_ID		nvarchar(MAX)
  , @YYYYMM			nvarchar(MAX)
)
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_SCP_MST_CAPA_OEE
  * DESCRIPTION   : OEE를 반환한다. 
  *
  * INPUT         : DIVISION_ID
					PLANT_ID
					FACTORY_ID
					OPERATION_ID
					LINE_ID
					ITEM_ID
					YYYYMM
  * OUTPUT        : OEE
  * USAGE         : SELECT DBO.FN_GET_SCP_MST_CAPA_OEE('40','A010','M1' ,'A3000' ,'M1C02' ,'MACM350415A1' ,'202308') 
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-17   kth        INITIAL
  ****************************************************************************/
BEGIN
DECLARE @retVal nvarchar(max) = '0';

	 SELECT @YYYYMM = REPLACE(@YYYYMM,'M_','')

	 select @retVal  = VALUE
	   from SCP_MST_CAPA 
	  where DIVISION_ID		= @DIVISION_ID	
		and PLANT_ID		= @PLANT_ID		
		and FACTORY_ID		= @FACTORY_ID		
		and OPERATION_ID	= @OPERATION_ID	
		and LINE_ID			= @LINE_ID		
		and ITEM_ID			= @ITEM_ID		
		and YYYYMM			= @YYYYMM	
				
	RETURN @retVal;
END
