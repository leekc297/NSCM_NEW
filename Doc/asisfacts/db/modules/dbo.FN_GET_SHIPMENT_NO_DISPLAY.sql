CREATE FUNCTION [dbo].[FN_GET_SHIPMENT_NO_DISPLAY]
(
  @p_shipment_no      NVARCHAR(100),
  @p_result_type     NVARCHAR(20)
)

RETURNS NVARCHAR(100)
AS
/*
 * Program ID   : FN_GET_SHIPMENT_NO_DISPLAY
 * Description  : SHIPMENT NO DISPLAY
*        
*        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.08.07  vadabi3    Initial Release 
 *
 */
BEGIN
  
  DECLARE @v_shipment_no NVARCHAR(100)
  
  IF @p_result_type = 'S'
    BEGIN
	SET @v_shipment_no = '-'
	END
  ELSE
    BEGIN
	 SET @v_shipment_no = @p_shipment_no;
	 SET @v_shipment_no = REPLACE(@v_shipment_no, '_1','');
	 SET @v_shipment_no = REPLACE(@v_shipment_no, '_2','');
	 SET @v_shipment_no = REPLACE(@v_shipment_no, '_3','');
	 SET @v_shipment_no = REPLACE(@v_shipment_no, '_4','');
	END

  RETURN @v_shipment_no;

END
;
