/*
 * Program ID   : [SCP0015_GET_PLAN_MST_COMFIRM]
 * Description  : PLAN CONFIRM 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/28   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 실행예제)
 *  EXEC SCP0015_GET_PLAN_MST_COMFIRM @p_modeling_id='2',@p_division_id='81',@p_revision_no='20171211-MA-02'
 */
CREATE PROCEDURE [dbo].[SCP0015_GET_PLAN_MST_COMFIRM]
 (
	 @p_modeling_id  	NVARCHAR(1000)
  	,@p_division_id		NVARCHAR(1000)  
	,@p_revision_no		NVARCHAR(1000)
 )
AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	SET NOCOUNT ON;

	DECLARE @v_plan_name NVARCHAR(8)='';
	DECLARE @v_plan_type NVARCHAR(2)='';
	DECLARE @v_plan_seq  NVARCHAR(2)='';
    DECLARE @v_plan_id   NVARCHAR(30)='';	
	
	SET @v_plan_name = [dbo].[FN_SCM_SPLIT](@p_revision_no,1,'-');
	SET @v_plan_type = [dbo].[FN_SCM_SPLIT](@p_revision_no,2,'-');
	SET @v_plan_seq  = [dbo].[FN_SCM_SPLIT](@p_revision_no,3,'-');

	SET @v_plan_id = (
						SELECT b.plan_id
						  FROM dbo.scm_mst_plan A
							   INNER JOIN scm_mst_plan_detail B ON a.division_id=b.division_id
															   AND a.plan_id    =b.plan_id	   
						 WHERE b.modeling_id = @p_modeling_id
						   AND a.division_id = @p_division_id
						   AND a.plan_name   = @v_plan_name
						   AND b.plan_type   = @v_plan_type
						   AND b.plan_seq    = @v_plan_seq 
						) ;
		 
	-- CONFIRM 정보 확인
	SELECT CONFIRM_FLAG AS CONFIRM_YN
		  ,CONFIRM_USER AS CONFIRM_USER
		  ,CONFIRM_DATE AS CONFIRM_TIME
	 FROM scm_mst_plan_detail	  
	WHERE modeling_id  = @p_modeling_id
	   AND division_id = @p_division_id
	   AND plan_id     = @v_plan_id
	   AND plan_type   = @v_plan_type 
	   AND plan_seq    = @v_plan_seq ;
	
END
