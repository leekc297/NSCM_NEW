
/*
 * Program ID   : SCM0006_GET_SQL_LONG_TEXT
 * Description  : 등록된 Query를 새창에 보여준다.
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/30   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[SCM0006_GET_SQL_LONG_TEXT]
  @p_use_type		NVARCHAR(MAX),
  @p_module			NVARCHAR(MAX),
  @p_submodule		NVARCHAR(MAX),    
  @p_category_id	NVARCHAR(MAX)
AS
BEGIN
	
		SELECT
               [dbo].[FN_GET_SOURCE_CODE](@p_use_type, @p_module, @p_submodule, @p_category_id, 1) as text1
			  ,[dbo].[FN_GET_SOURCE_CODE](@p_use_type, @p_module, @p_submodule, @p_category_id, 2) as text2
			  ,[dbo].[FN_GET_SOURCE_CODE](@p_use_type, @p_module, @p_submodule, @p_category_id, 3) as text3
			  ,[dbo].[FN_GET_SOURCE_CODE](@p_use_type, @p_module, @p_submodule, @p_category_id, 4) as text4
			  ,[dbo].[FN_GET_SOURCE_CODE](@p_use_type, @p_module, @p_submodule, @p_category_id, 5) as text5
			  ,[dbo].[FN_GET_SOURCE_CODE](@p_use_type, @p_module, @p_submodule, @p_category_id, 6) as text6
			  ,[dbo].[FN_GET_SOURCE_CODE](@p_use_type, @p_module, @p_submodule, @p_category_id, 7) as text7
			  ,[dbo].[FN_GET_SOURCE_CODE](@p_use_type, @p_module, @p_submodule, @p_category_id, 8) as text8
   ;
END


