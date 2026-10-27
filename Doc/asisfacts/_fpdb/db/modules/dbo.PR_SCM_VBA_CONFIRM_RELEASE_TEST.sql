/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_VBA_CONFIRM_RELEASE_TEST                                           **/
/** 프로그램 명   : GM FP시뮬레이터 릴리즈버튼     test                                         **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2024.07.25    shineuiho67   최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC [PR_SCM_VBA_CONFIRM_RELEASE_TEST] 'UC1-20240703-01', 'shineuiho67'
*/
CREATE PROCEDURE [dbo].[PR_SCM_VBA_CONFIRM_RELEASE_TEST]
	@p_instance_id nvarchar(MAX) = '-', @p_intg_plan_id nvarchar(MAX) = '-', @p_unit_id nvarchar(MAX) = '-', @p_release_id nvarchar(MAX) = '-',
    @O_result NVARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @v_ret      nvarchar(MAX)
	SET NOCOUNT ON;

    SET @v_ret = (SELECT TOP 1 RELEASE_FLAG FROM SCM_FP_PLAN_H WITH(NOLOCK) WHERE INSTANCE_ID = @p_instance_id AND INTG_PLAN_ID = @p_intg_plan_id)

    -- 결과값 반환 
    SET @o_result = 'Test!!!!! Done. Change to real procedure .... ' +  char(13) + 
                    'p_instance_id : ' + @p_instance_id + char(10) + char(13) + 
                    'p_intg_plan_id : ' + @p_intg_plan_id + char(10) + char(13) + 
                    'p_unit_id : '     + @p_unit_id     + char(10) + char(13) + 
                    'p_release_id : '  + @p_release_id  + char(10) + char(13) + 
                    N'Status : '       + @v_ret;

END


select top 10 * from SCM_FP_PLAN_H 