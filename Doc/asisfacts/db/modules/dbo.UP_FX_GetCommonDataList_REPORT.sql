
/* ==========================================================================================================================================================
프로그램ID : UP_FX_GetCommonDataList_REPORT
업  무  명 : REPORT 코드성 조회
프로그램명 : REPORT 코드성 조회
최초작성일 : 2023.12.11
최종작성일 : 2023.12.11
개  발  자 : vadabi3
입  력  값 :
출  력  값 :
==========================================================================================================================================================
   Date       In Charge      Description
==========================================================================================================================================================
2023/12/11	  vadabi3		 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - PLAN_START_DATE, PLAN_END_DATE
----------------------------------------------------------------------------------------------------------------------------------------------------------
EXEC UP_FX_GetCommonDataList_REPORT 
	 @Code 	= 'PLAN_START_DATE'
	,@Param1	= '40'
	,@Param2	= '20231204'
	,@Param3	= 'WEEKLY'
	,@Param4	= null
	,@Param5	= null
	,@Param6	= null
========================================================================================================================================================== */
CREATE PROCEDURE [dbo].[UP_FX_GetCommonDataList_REPORT]
   @Code NVARCHAR(100)
 , @Param1 NVARCHAR(100)
 , @Param2 NVARCHAR(100)
 , @Param3 NVARCHAR(MAX) = null --split 사용 변수
 , @Param4 NVARCHAR(MAX) = null --split 사용 변수
 , @Param5 NVARCHAR(MAX) = null --split 사용 변수
 , @Param6 NVARCHAR(MAX) = null --split 사용 변수
 , @TimeZone NVARCHAR(MAX) = 'AS054'
AS

BEGIN
 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

 /*===============================================
 용   도:  PLAN_START_DATE  조회
 사 용 화 면:  Plan start date  - 조회조건
 변       수:  Param1 = div, Param2 = plan name
 최 초 작 성:  2023. 12. 11
 개  발  자 :  vadabi3
 최 종 작 성:  2023. 12. 11
 수  정  자 :  vadabi3
 수 정 사 항:
 ===============================================*/

 IF (@Code = 'PLAN_START_DATE' )
	 BEGIN
		 SELECT TOP 1 HORIZON_START_DATE
		   FROM SCM_MST_PLAN 
		  WHERE 1 =1 
		   AND DIVISION_ID  = @param1
		   AND PLAN_NAME    = @param2
		   AND PLAN_CYCLE   = @param3
	 END

 /*===============================================
 용   도:  PLAN_END_DATE  조회
 사 용 화 면:  Plan end date  - 조회조건
 변       수:  Param1 = div, Param2 = plan name
 최 초 작 성:  2023. 12. 11
 개  발  자 :  vadabi3
 최 종 작 성:  2023. 12. 11
 수  정  자 :  vadabi3
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'PLAN_END_DATE' )
	 BEGIN
		 SELECT TOP 1 HORIZON_END_DATE
		   FROM SCM_MST_PLAN 
		  WHERE 1 =1 
		   AND DIVISION_ID  = @param1
		   AND PLAN_NAME    = @param2
		   AND PLAN_CYCLE   = @param3
	 END


ELSE

RETURN;

 --------------
END
