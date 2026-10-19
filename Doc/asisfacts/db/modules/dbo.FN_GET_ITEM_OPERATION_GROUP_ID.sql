CREATE FUNCTION [dbo].[FN_GET_ITEM_OPERATION_GROUP_ID]
      (
       @P_DIVISION_ID      NVARCHAR(30),
       @P_ITEM_ID          NVARCHAR(150)                      
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/*
 * PROJECT       : LG CHEM SCP PRJ.
 * FUNCTION NAME : FN_GET_ITEM_OPERATION_GROUP_ID
 * DESCRIPTION   : OPERATION_GROUP_ID  RETURN
 *
 *  FP OPERATION GROUP ID 
 *  
 *   A  Cell              
 *   B  BMA      -> P9500        
 *   B  CMA      -> P5500             
 *   E  Electrode         
 *   M  CMA      -> P5000
 *   S  SRS
 *
 *   
 * INPUT         : P_DIVISION_ID,P_ITEM_ID
 * OUTPUT        : UOM
 * PROGRAM HISTORY
 *--------------------------------------------------------------
   DATE      IN CHARGE           DESCRIPTION
 *--------------------------------------------------------------
 * 2018-02-07   YYDOK        INITIAL
 * 2018-05-15   YYDOK        CLASS LEVEL -> ITEM MASTER의 값을 가져오는 것으로 변경
 */
 
BEGIN
  
   DECLARE @X_OP_GROUP_ID NVARCHAR(100)='';

     SELECT TOP 1 @X_OP_GROUP_ID      = ISNULL(I.SCP_OPERATION_GROUP_ID,'')
       FROM DBO.SCM_MST_ITEM_SN      I WITH(NOLOCK)
      WHERE 1=1
        AND I.DIVISION_ID          = @P_DIVISION_ID
        AND I.ITEM_ID              = @P_ITEM_ID
        ;      
/*
  IF @X_OP_GROUP_ID = '' (
     SELECT TOP 1 @X_OP_GROUP_ID      = ISNULL(O.OPERATION_GROUP_ID,'')
       FROM DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK),
            DBO.SCM_MST_ITEM_CLASS_LEVEL_SN  O WITH(NOLOCK)
      WHERE 1=1
        AND I.DIVISION_ID          = @P_DIVISION_ID
        AND I.ITEM_ID              = @P_ITEM_ID
        AND I.ITEM_CLASS           LIKE O.LEVEL_ID+'%'
      AND O.OPERATION_GROUP_ID     IS NOT NULL
      AND O.USE_FLAG             = 'Y'
  )      
  */
        
   RETURN  ISNULL(@X_OP_GROUP_ID,'');

END
;
