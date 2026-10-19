/*
 * Program ID   : SSP_GET_LAST_PLAN_VERSION
 * Description  : PLAN VERSION 기본값 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/14   ygkim    			Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ex)
 * EXEC [SSP_GET_LAST_PLAN_VERSION] @p_division_id='81'
 */

CREATE PROCEDURE [dbo].[SSP_GET_LAST_PLAN_VERSION] 
@p_division_id NVARCHAR(50)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_plan_version NVARCHAR(100)
	SELECT @v_plan_version = [dbo].[FN_GET_SSP_LAST_PLAN_VERSION_ID] (@p_division_id);
	
	SELECT  [dbo].[FN_SCM_SPLIT](@v_plan_version,1,'-') AS PLAN_START_YYYYMMDD
           ,[dbo].[FN_SCM_SPLIT](@v_plan_version,2,'-') AS PLAN_TYPE
           ,CONVERT(VARCHAR,CONVERT(INT,[dbo].[FN_SCM_SPLIT](@v_plan_version,3,'-'))) AS PLAN_SEQ

END
