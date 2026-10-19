CREATE FUNCTION [dbo].[FN_GET_SCP_LAST_PLAN_VERSION_ID]
      (
       @P_DIVISION_ID      NVARCHAR(30)                      
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/*
 * PROJECT       : LG CHEM SCP PRJ.
 * FUNCTION NAME : FN_GET_SCP_LAST_PLAN_VERSION_ID
 * DESCRIPTION   : SCP LAST PLAN VERSION ID RETURN
 * INPUT         : P_DIVISION_ID
 * OUTPUT        : UOM
 * PROGRAM HISTORY
 *--------------------------------------------------------------
   DATE      IN CHARGE           DESCRIPTION
 *--------------------------------------------------------------
 * 2018-02-09   YYDOK        INITIAL
 * 2018-05-28   PJS          정렬순서 plan_seq desc 추가        
 */
 
BEGIN
  
   DECLARE @X_LAST_PLAN_VERSION_ID             NVARCHAR(100)='';

   
  select  top 1 @X_LAST_PLAN_VERSION_ID = plan_version_id
    from SCP_PLAN_VERSION_V
   where division_id  = @P_DIVISION_ID
   order by plan_start_yyyymmdd desc,plan_type_order desc,plan_seq desc -- 
		    
 
		    
   RETURN  ISNULL(@X_LAST_PLAN_VERSION_ID,'');

END
;
