CREATE FUNCTION [dbo].[FN_GET_PACKER_SUFFIX]
      (
       @P_DIVISION_ID        NVARCHAR(30),
       @P_PACKER_SITE_ID     NVARCHAR(30)                      
       )
       RETURNS NVARCHAR(1)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_PACKER_SUFFIX
  * DESCRIPTION   : RETURN1 PACKER ITEM ID SUFFIX
  * INPUT         : P_DIVISION_ID,P_PACKER_PLANT_SITE
  * OUTPUT        : PACKER SUFFIX CODE
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-07-02   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_PACKER_SUFFIX NVARCHAR(100)='';
   
   IF @P_DIVISION_ID <> '40' OR @P_PACKER_SITE_ID NOT LIKE '%-P'
      BEGIN
         RETURN ''
      END

   
   SELECT  @X_PACKER_SUFFIX  = ISNULL(MAX(ISNULL(PACKER_ITEM_ID_SUFFIX,'')),'')
     FROM SCM_MST_SITE WITH(NOLOCK)
    WHERE DIVISION_ID = '40'
      AND SITE_TYPE   = 'PLANT'
      AND OSP_YN      = 'Y'
      AND SCM_SITE_ID = @P_PACKER_SITE_ID
        
   RETURN  ISNULL(@X_PACKER_SUFFIX,'');

END
;
