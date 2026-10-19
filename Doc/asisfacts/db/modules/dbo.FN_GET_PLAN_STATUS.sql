CREATE FUNCTION [dbo].[FN_GET_PLAN_STATUS]
(
 @P_DIVISION_ID          NVARCHAR(10),
 @P_PLAN_START_YYYYMMDD  NVARCHAR(8),
 @P_PLAN_TYPE            NVARCHAR(10),
 @P_SEQ                  INT
)
      RETURNS INT
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_PLAN_STATUS
  * DESCRIPTION   : SCP ENGINE PLAN의 PLAN_STATUS를 리턴한다.
  *                 1: 정상종료, -1: 오류발생, -2: 사용자 STOP REQUEST
  *
  * USAGE         : 프로시져수행중 사용자 STOP요청의 경우 오류를 내면서 STOP처리하기위함
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-04-11   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
  DECLARE @X_PLAN_STATUS INT 
   
select TOP 1 @X_PLAN_STATUS=D.PLAN_STATUS 
  from scm_mst_plan_detail d with(nolock),
       scm_mst_plan        p with(nolock)
 where 1=1
   and p.DIVISION_ID   = d.DIVISION_ID
   and p.PLAN_ID       = d.PLAN_ID
   AND D.DIVISION_ID   = @P_DIVISION_ID         --'81'
   AND p.plan_name     = @P_PLAN_START_YYYYMMDD --'20180409'
   AND D.PLAN_TYPE     = @P_PLAN_TYPE           --'PR'
   AND D.PLAN_SEQ      = @P_SEQ                 --9
   ;
	
  RETURN @X_PLAN_STATUS;

END
;
