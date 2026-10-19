
/*
 * Program ID   : FN_GET_SOURCE_CODE                                                             
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/30  ygkim       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 *                                                                                                  
*/

CREATE FUNCTION [dbo].[FN_GET_SOURCE_CODE]
(     
    @p_use_type		NVARCHAR(MAX)
  , @p_module		NVARCHAR(MAX)
  , @p_submodule	NVARCHAR(MAX)
  , @p_category_id	bigint 
  , @p_seq			bigint
) RETURNS NVARCHAR(MAX)
AS    
BEGIN
	DECLARE @v_text			NVARCHAR(MAX);
	DECLARE @v_return       NVARCHAR(MAX);

	SELECT @v_text = sql_long_text
	FROM SCM_ADM_RECIPIENT_LIST A WITH(NOLOCK)
	WHERE 1=1
	  AND A.use_type_code = @p_use_type
	  AND A.module_code = @p_module
	  AND A.sub_module_code = @p_submodule
	  AND A.category_id = @p_category_id;

	  IF @p_seq < 0 
		  BEGIN
				SET @p_seq = 1;
		  END;
	  IF (@p_seq = 1)
		BEGIN
			SET @v_return = SUBSTRING(@v_text, 1, 4000);
		END;
	  ELSE IF (@p_seq = 2)
		BEGIN
			SET @v_return = SUBSTRING(@v_text, 4001, 4000);
		END;
	  ELSE IF (@p_seq = 3)
		BEGIN
			SET @v_return = SUBSTRING(@v_text, 8001, 4000);
		END;
	  ELSE IF (@p_seq = 4)
		BEGIN
			SET @v_return = SUBSTRING(@v_text, 12001, 4000);
		END;
	  ELSE IF (@p_seq = 5)
		BEGIN
			SET @v_return = SUBSTRING(@v_text, 16001, 4000);
		END;
	  ELSE IF (@p_seq = 6)
		BEGIN
			SET @v_return = SUBSTRING(@v_text, 20001, 4000);
		END;
	  ELSE IF (@p_seq = 7)
		BEGIN
			SET @v_return = SUBSTRING(@v_text, 24001, 4000);
		END;
	  ELSE IF (@p_seq = 8)
		BEGIN
			SET @v_return = SUBSTRING(@v_text, 28001, 4000);
		END;

	RETURN( @v_return ); -- @v_return
END;

