



/*
 * Program ID   : UP_FX_GetInterfaceSetup
 * Description  : UP_FX_GetInterfaceSetup 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/10/16   yhw				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * ******************  화면 사용 안함 *************************************
 */
CREATE PROCEDURE [dbo].[UP_FX_GetInterfaceSetup]
--chaan  @p_division_id            NVARCHAR(2),
  @p_division_id            NVARCHAR(30),--chaan
  @p_plan_start_yyyymmdd	NVARCHAR(8),
  @p_fp_target_yn			NVARCHAR(50),
  @p_mrp_target_yn			NVARCHAR(50)
AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

  SELECT DIVISION_ID, PLAN_START_YYYYMMDD , FP_TARGET_YN, MRP_TARGET_YN
	FROM SCP_PLN_INTERFACE_YN
   WHERE 1=1
     AND ( ( @p_division_id			IS NULL OR  @p_division_id = '' )			OR DIVISION_ID			= @p_division_id )
	 AND ( ( @p_plan_start_yyyymmdd	IS NULL OR  @p_plan_start_yyyymmdd = '' )	OR PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd )
	 AND ( ( @p_fp_target_yn		IS NULL OR  @p_fp_target_yn = ''   )		OR FP_TARGET_YN  IN (SELECT token FROM dbo.String_Split(@p_fp_target_yn  ,',')) )
	 AND ( ( @p_mrp_target_yn		IS NULL OR  @p_mrp_target_yn = ''   )		OR MRP_TARGET_YN IN (SELECT token FROM dbo.String_Split(@p_mrp_target_yn  ,',')) )
   ORDER BY DIVISION_ID, PLAN_START_YYYYMMDD
	;
								  
END

