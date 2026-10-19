/*
 * Program ID   : SCP0035_GET_JIG_MASTER
 * Description  : Jig Master 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/08/13   LWY           PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 전극 PLANT
 * 2022/05/26   jahn1501	  Plan Date Combo 조회 변경	
 * 
 */


CREATE PROCEDURE [dbo].[SCP0069_GET_PLANT_EE]  
AS
BEGIN
	
  SET NOCOUNT ON;

  -----------------------------------------------------
  -- 전극 Site Combo
  -----------------------------------------------------
  SELECT SCM_SITE_ID AS CODE       
	   , SCM_SITE_ID + '   ' + SITE_DESCRIPTION AS NAME 
    FROM SCM_MST_SITE WITH (NOLOCK)	
   WHERE OPERATION_GROUP ='E'
   ORDER BY 2
  ;

  -----------------------------------------------------
  -- Plan Date Combo
  -----------------------------------------------------
  SELECT PLAN_START_YYYYMMDD AS code
        ,CONVERT(varchar(10), CONVERT(date, CONVERT(varchar(8), PLAN_START_YYYYMMDD))) + ' (' + B.WEEK_NAME + ')' AS name
  FROM (
		SELECT TOP 1 PLAN_START_YYYYMMDD        
		FROM SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)	
	   ) A LEFT JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
  ;

  -----------------------------------------------------
  -- Plan Type Combo
  -----------------------------------------------------
  SELECT PLAN_TYPE AS code
        ,PLAN_TYPE AS name
  FROM (
		SELECT TOP 1 PLAN_TYPE        
		FROM SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)	
	   ) A
  ;


  RETURN;

END
