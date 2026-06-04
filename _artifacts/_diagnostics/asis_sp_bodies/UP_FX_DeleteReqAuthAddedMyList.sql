
/* =============================================================================
프로그램ID	: [UP_FX_DeleteReqAuthAddedMyList]
업  무  명	: 사용자별 확장메뉴권한 관리
프로그램명	: 사용자별 확장메뉴권한 관리 - 등록된 요청 삭제
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_DeleteReqAuthAddedMyList]
(
	  @p_active_flag		NVARCHAR(MAX)
	, @p_User_ID			NVARCHAR(MAX)
	, @p_Group_ID			NVARCHAR(MAX)
	, @p_Division_ID		NVARCHAR(MAX)
	, @p_Plant_ID			NVARCHAR(MAX)
	, @p_Customer_Code		NVARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_User_ID				NVARCHAR(MAX) = null ;
	DECLARE @v_Group_ID				NVARCHAR(MAX) = null ;
	DECLARE @v_Division_ID			NVARCHAR(MAX) = null ;
	DECLARE @v_Plant_ID				NVARCHAR(MAX) = null ;
	--DECLARE @v_Customer_Code		NVARCHAR(MAX) = null ;

	DECLARE @v_delimiter	NVARCHAR(1) = '^' 
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	INTEGER = 0;

	-- 프로시저 LOOP 길이를 판단
	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
	SELECT    @max_loop_cnt;

	WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
	BEGIN
		-- @mst_loop_cnt 1증가
		SET @mst_loop_cnt = @mst_loop_cnt + 1;
		SELECT @mst_loop_cnt,'@mst_loop_cnt'		

		-- 각 컬럼들에 대한 스플릿처리로직 스타트
		BEGIN			 
			SET @V_User_ID = [dbo].[SCM_ARR_SPL_VAL](@p_User_ID, @v_delimiter , @mst_loop_cnt) ;    
			SET @V_Group_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Group_ID, @v_delimiter , @mst_loop_cnt) ;    
			SET @V_Division_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Division_ID, @v_delimiter , @mst_loop_cnt) ; 
			SET @V_Plant_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Plant_ID, @v_delimiter , @mst_loop_cnt) ;
			--SET @V_Customer_Code = [dbo].[SCM_ARR_SPL_VAL](@p_Customer_Code, @v_delimiter , @mst_loop_cnt) ;

			IF @mst_loop_cnt > 0 
			BEGIN
				DELETE FROM dbo.SCM_MST_AUTH_REQUEST
				WHERE 1=1
					AND USER_ID			= @v_User_ID		
					AND GROUP_ID		= @v_Group_ID
					AND DIVISION_ID		= @v_Division_ID	
					AND PLANT_ID		= @v_Plant_ID		
					--AND CUSTOMER_CODE	= @v_Customer_Code
			END
		END
	END
END


