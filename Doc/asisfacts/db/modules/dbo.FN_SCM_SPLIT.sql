/*
 * Program ID   : FN_SCM_GET_WHERE_SQL                                                             
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/20  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 *                                                                                                  
*/

--ALTER FUNCTION [dbo].[SCM_ARR_SPL_VAL]
--(
-- @sText		NVARCHAR(max),			-- 대상 문자열
-- @str		NVARCHAR(1) = '|',		-- 구분기호(Default '|')
-- @idx		INT                     -- 배열 인덱스
--)
--RETURNS NVARCHAR(100)
--AS

--BEGIN
-- DECLARE @word    NVARCHAR(1000);		-- 반환할 문자
-- DECLARE @sTextData  NVARCHAR(max); 
-- DECLARE @num    INT;

-- ~~~~~~~~

-- RETURN(@word);
--END
--;

CREATE FUNCTION [dbo].[FN_SCM_SPLIT]
(     
    @p_input_data NVARCHAR(MAX)
  , @p_node_no    INT
  , @p_delimiter  NVARCHAR(MAX) 
) RETURNS NVARCHAR(MAX)
AS    
BEGIN
    DECLARE @v_input_length  INT  = 0;
    DECLARE @v_split_length  INT  = 0;
    DECLARE @v_start_length  INT  = 0;
    DECLARE @v_last_length   INT  = 1;
	DECLARE @v_return        NVARCHAR(MAX);

	IF (@p_delimiter IS NULL OR @p_delimiter = '')
	    SET @p_delimiter = ',';

	SET @v_input_length = DATALENGTH(@p_input_data);
    SET @v_split_length = LEN(@p_delimiter);

	--SET @v_return = CONVERT(CHAR, @v_input_length) + CONVERT(CHAR, @v_split_length);

    IF ( @v_input_length  = 0 ) 
        RETURN(NULL);
    

    IF ( @p_node_no = 1 ) 
        SET @v_start_length = 1;
    ELSE
	    BEGIN
        IF CHARINDEX(@p_delimiter, @p_input_data,  @p_node_no ) = 0 
             RETURN(NULL);
        
		DECLARE @i INT = 1;		
		
		WHILE(@i < @p_node_no)
			BEGIN
				IF CHARINDEX( @p_delimiter, @p_input_data, @v_start_length) = 0
				    RETURN(NULL);
				
				SET @v_start_length = CHARINDEX( @p_delimiter, @p_input_data, @v_start_length) + @v_split_length;	
				SET @i = @i + 1;				
			END;	
		END;
    	
	SET @v_last_length = CHARINDEX( @p_delimiter, @p_input_data, @v_start_length);

	IF ( @v_last_length = 0 ) 
		SET @v_last_length = @v_input_length + 1 ;
    
	SET @v_return = SUBSTRING( @p_input_data, @v_start_length, @v_last_length - @v_start_length) ;
	
	RETURN( @v_return ); -- @v_return



END;
