CREATE FUNCTION [dbo].[FN_GET_MOBILE_PACKER_ITEM_ID]
      (
       @P_DIVISION_ID        NVARCHAR(30),
       @P_PACKER_SITE_ID     NVARCHAR(30),
       @P_PACK_ITEM_ID       NVARCHAR(30)                      
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_MOBILE_PACKER_ITEM_ID
  * DESCRIPTION   : RETURN PACKER ITEM ID
  * INPUT         : P_DIVISION_ID,P_PACK_ITEM_ID
  * OUTPUT        : PACKER ITEM ID (12번재자리를 업체의 SUFFIX로 변환)
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-07-02   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_PACKER_ITEM_ID NVARCHAR(100)='';
   
   IF @P_DIVISION_ID <> '40' OR @P_PACKER_SITE_ID NOT LIKE '%-P'
      BEGIN
         RETURN @P_PACK_ITEM_ID
      END

   SELECT @X_PACKER_ITEM_ID =  LEFT(@P_PACK_ITEM_ID,11)
                             +[dbo].[FN_GET_PACKER_SUFFIX](@P_DIVISION_ID,@P_PACKER_SITE_ID)
                             + SUBSTRING(@P_PACK_ITEM_ID,13,LEN(@P_PACK_ITEM_ID));
        
   RETURN  ISNULL(@X_PACKER_ITEM_ID,'');

END
;
