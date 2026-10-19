/*
 * Program ID   : FN_GET_IN_STR                                                             
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/20  ygkim       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 *                                                                                                  
*/


CREATE FUNCTION [dbo].[FN_GET_IN_STR]
(
 @p_csv_text_list         NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS    
BEGIN
    DECLARE @v_csv_text_list    NVARCHAR(MAX); --:= REPLACE(REPLACE(p_csv_text_list,CHR(13),''),CHR(10),',');
    DECLARE @v_condtion_value   NVARCHAR(100);
    DECLARE @v_sql_text         NVARCHAR(MAX);
	DECLARE @v_count            INT = 0 ;
	DECLARE @v_list_count       INT = 0 ;
    DECLARE @v_1st_node         NVARCHAR(4000);
    DECLARE @v_2nd_node         NVARCHAR(4000);
		
	SET @v_csv_text_list = REPLACE(REPLACE(@p_csv_text_list, CHAR(13), ''), CHAR(10), ',');
	SET @v_sql_text = '';
	SET @v_list_count = 0;
	----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
	
		
	----------------------------------------------------------------------------
	IF ISNULL(@v_csv_text_list,'ALL') = 'ALL' 
		SET @v_sql_text = '';
	----------------------------------------------------------------------------
	ELSE IF (@v_csv_text_list = '')         
		SET @v_sql_text = '';
		
	
	BEGIN			 
		IF @p_csv_text_list = ''
			RETURN ( '' );
			
		SET @v_sql_text =  '' ;
		SET @v_list_count = 1;
		--SET @i = 0;		
		WHILE(@v_list_count <= 1000)
			BEGIN
				---[dbo].[SCM_ARR_SPL_CNT]
				SET @v_condtion_value = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT]( @v_csv_text_list, @v_list_count, ',' ) ) ) ;
				
				IF  @v_condtion_value IS NULL 
					BREAK ;
				ELSE 
					BEGIN
					SET @v_count    = @v_count + 1 ;
					IF( @v_count>1)
						SET @v_sql_text = @v_sql_text + ','''+ @v_condtion_value+'''' ;
					ELSE 
						SET @v_sql_text = @v_sql_text + ''''+ @v_condtion_value+'''' ;
					        												
					SET @v_list_count = @v_list_count + 1;
					END
			END;
	END;
	
    ----------------------------------------------------------------------------
    RETURN (@v_sql_text);
    ----------------------------------------------------------------------------   
	
END;
