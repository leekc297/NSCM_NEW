

CREATE FUNCTION [dbo].[FN_GET_SCM_SITE_ID_PLANT]
      (
       @P_PLANT_ID      NVARCHAR(30),
       @P_OPERATION_GROUP_ID          NVARCHAR(150)                      
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/*
 * PROJECT       : LG CHEM SCP PRJ.
 * FUNCTION NAME : FN_GET_SCM_SITE_ID_PLANT
 * DESCRIPTION   : SCM_SITE_ID  RETURN
 * INPUT         : P_PLANT_ID,P_OPERATION_GROUP_ID
 * OUTPUT        : UOM
 * PROGRAM HISTORY
 *--------------------------------------------------------------
   DATE      IN CHARGE           DESCRIPTION
 *--------------------------------------------------------------
 * 2018-03-13   JJKIM        INITIAL
 *
 */
 
BEGIN
  
   DECLARE @X_OP_GROUP             NVARCHAR(100)= NULL;
     
   SELECT TOP 1 @X_OP_GROUP      = ISNULL(I.SCM_SITE_ID,'')
   FROM   DBO.SCM_MST_SITE             I WITH(NOLOCK)
   WHERE  1=1
   AND    I.PLANT_ID             = @P_PLANT_ID
   AND    I.OPERATION_GROUP      = @P_OPERATION_GROUP_ID
   AND    I.SITE_TYPE            = 'PLANT'
   AND    I.VALID_YN             = 'Y';		    
   
   RETURN  @X_OP_GROUP; --ISNULL(@X_OP_GROUP,'');

END
;
