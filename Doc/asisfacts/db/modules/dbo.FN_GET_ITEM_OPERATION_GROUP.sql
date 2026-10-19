CREATE FUNCTION [dbo].[FN_GET_ITEM_OPERATION_GROUP]
      (
       @P_DIVISION_ID      NVARCHAR(30),
       @P_ITEM_ID          NVARCHAR(150)                      
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/*
 * PROJECT       : LG CHEM SCP PRJ.
 * FUNCTION NAME : FN_GET_ITEM_OPERATION_GROUP
 * DESCRIPTION   : UOM  RETURN
 *
 *  FP OPERATION GROUP ID -> SCP OPERATIION GROUP MAPPING
 *  
 *   A  Cell              -> A Cell
 *   B  BMA               -> P Pack
 *   B  CMA               -> P Pack
 *   E  Electrode         -> E Electrode
 *   M  CMA               -> P Pack
 *   S  SRS               -> E Electrode
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
 * 2018-05-17   YYDOK        속도개선을 위해서 CLASS LEVEL TABLE검색 로직제외
 */
 
BEGIN
  
   DECLARE @X_OP_GROUP             NVARCHAR(100)='';

     SELECT TOP 1 @X_OP_GROUP      = ISNULL(I.SCP_OPERATION_GROUP,'')
       FROM DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
      WHERE 1=1
        AND I.DIVISION_ID          = @P_DIVISION_ID
        AND I.ITEM_ID              = @P_ITEM_ID
        ;

-- 2018.05.17 속도개선을 위해서 ''인 경우, OP GROUP 추가로 확인하는 부분은 COMMENT     
/*
  IF @X_OP_GROUP = '' (
     SELECT TOP 1 @X_OP_GROUP      =    ( CASE ISNULL(O.OPERATION_GROUP_ID,'') WHEN 'B' THEN 'P'
                                                                               WHEN 'M' THEN 'P'
                                                                               WHEN 'S' THEN 'E'
                                               ELSE  ISNULL(O.OPERATION_GROUP_ID,'')
                                           END )
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
        
   RETURN  ISNULL(@X_OP_GROUP,'');

END
;
