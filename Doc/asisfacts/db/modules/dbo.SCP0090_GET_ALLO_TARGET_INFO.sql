/*
 * Program ID   : [SCP0090_GET_ALLO_TARGET_INFO]
 * Description  : ALLO_TARGET INFO 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/09/28   LWY   Initial Release PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Allo_Target_Request 설계변경으로 개발
 * 2022/10/24   LWY   Initial Release PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 추가 수정
 */

CREATE PROCEDURE [dbo].[SCP0090_GET_ALLO_TARGET_INFO]
	
	 @p_division_id     NVARCHAR(8)
	,@p_cutoff_yyyymmdd NVARCHAR(8)
    ,@p_from_dept_id	NVARCHAR(100)
	,@p_from_item_id	NVARCHAR(100)
	,@p_from_yyyymm		NVARCHAR(6)
	
AS
BEGIN

	DECLARE @v_cutoff_yyyymmdd NVARCHAR(8);
	DECLARE @v_row_cnt int;
		
	--SELECT ISNULL(A.QTY, 0) AS QTY
	--FROM   SCP_ANL_ALLO_TARGET A WITH(NOLOCK)
	----JOIN   SCP_ANL_ALLO_TARGET_REQUEST M with(nolock)
	----ON  A.cutoff_yyyymmdd = M.cutoff_yyyymmdd
	----AND A.dept_id         = M.from_dept_id
	----AND A.item_id         = M.from_item_id
	----AND A.yyyymm          = M.from_yyyymm
	----AND m.confirm         = 'Y'	  
	--WHERE 1 = 1 
	--AND A.division_id     = @p_division_id
	--AND A.cutoff_yyyymmdd = @p_cutoff_yyyymmdd
	--AND A.dept_id		  = @p_from_dept_id
	--AND A.item_id		  = @p_from_item_id
	--AND A.yyyymm          = @p_from_yyyymm
	--AND A.type            = 'PLAN'	
	--;

	SELECT @v_row_cnt = count(1)
	FROM   SCP_ANL_ALLO_TARGET A WITH(NOLOCK)	
	WHERE 1 = 1 
	AND A.division_id     = @p_division_id
	AND A.cutoff_yyyymmdd = @p_cutoff_yyyymmdd
	AND A.dept_id		  = @p_from_dept_id
	AND A.item_id		  = @p_from_item_id
	AND A.yyyymm          = @p_from_yyyymm
	AND A.type            = 'PLAN'	
	;

	IF @v_row_cnt = 0
	    
		 -- privious monday
		SET @v_cutoff_yyyymmdd = replace(convert(char(10),dateadd(d,datepart(dw,@p_cutoff_yyyymmdd) * -1 - 5,@p_cutoff_yyyymmdd),120),'-','')
	
	ELSE 
		SET @v_cutoff_yyyymmdd = @p_cutoff_yyyymmdd

	--print @v_cutoff_yyyymmdd;

	SELECT ISNULL(A.QTY, 0) AS QTY
	      ,DBO.FN_GET_ITEM_NICKNAME(@p_division_id, @p_from_item_id) AS NICK_NAME
	FROM   SCP_ANL_ALLO_TARGET A WITH(NOLOCK)
	WHERE 1 = 1 
	AND A.division_id     = @p_division_id
	AND A.cutoff_yyyymmdd = @v_cutoff_yyyymmdd
	AND A.dept_id		  = @p_from_dept_id
	AND A.item_id		  = @p_from_item_id
	AND A.yyyymm          = @p_from_yyyymm
	AND A.type            = 'PLAN'	
	;


END





