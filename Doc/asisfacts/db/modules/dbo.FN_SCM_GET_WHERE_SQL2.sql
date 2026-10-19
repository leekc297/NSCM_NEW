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

CREATE FUNCTION [dbo].[FN_SCM_GET_WHERE_SQL2]
(
    @p_column_name           NVARCHAR(MAX)
  , @p_logical_operator_code NVARCHAR(MAX)
  , @p_csv_text_list         NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS    
BEGIN
    DECLARE @v_csv_text_list    NVARCHAR(MAX); --:= REPLACE(REPLACE(p_csv_text_list,CHR(13),''),CHR(10),',');
    DECLARE @v_logical_operator NVARCHAR(100);  --:= NVL(UPPER(p_logical_operator_code),'LK');
    DECLARE @v_condtion_value   NVARCHAR(100);
    DECLARE @v_column_name      NVARCHAR(1000); --:= TRIM(SCM_SPLIT_FUNC(p_column_name,1,':'));
    DECLARE @v_sql_text         NVARCHAR(MAX);
	DECLARE @v_count            INT = 0 ;
	DECLARE @v_list_count       INT = 0 ;
    DECLARE @v_1st_node         NVARCHAR(4000);
    DECLARE @v_2nd_node         NVARCHAR(4000);
	
	
	 --RETURN (@p_csv_text_list);

	SET @v_csv_text_list = REPLACE(REPLACE(@p_csv_text_list, CHAR(13), ''), CHAR(10), ',');
	SET @v_logical_operator = ISNULL(UPPER(@p_logical_operator_code), 'LK');
	SET @v_column_name = LTRIM(RTRIM([dbo].[SCM_ARR_SPL_VAL](@p_column_name, ':', 1)));
	SET @v_sql_text = '';
	SET @v_list_count = 0;
	----------------------------------------------------------------------------
    -- CheckedListFilter : (!)value1,valu2...(:LK) 
    -- MonthRangePicker, DateRangePicker : '20171201:20171231' 형식이므로 제외
    -- ComboColumn : column_name:value
    ----------------------------------------------------------------------------	
	
	IF CHARINDEX(@v_csv_text_list,':') > 0 AND @v_logical_operator NOT IN ('BW','BETWEEN','BD','BETWEN DATE','BM','BETWEEN MONTH')
        BEGIN
			IF LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list, 2 ,':' ))) = 'LK' 
				-- CheckedListFilter : Like 검색
				SET @v_logical_operator = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,2,':')));
				SET @v_csv_text_list    = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,1,':')));

				-- CheckedListFilter : 'end_customer_code:end_customer_name'
				IF CHARINDEX(@p_column_name,':') > 0
					SET @v_column_name = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@p_column_name,2,':')));
            
			ELSE
				-- ComboColumn : column_name:value --2017.12.20
				SET @v_column_name   = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,1,':')));
				SET @v_csv_text_list = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,2,':')));
        END; 
    ----------------------------------------------------------------------------
	BEGIN
		
	IF @v_logical_operator = '-'         		
		BEGIN
		DECLARE @i INT = 0;		
		WHILE(@i <= 1000)
			BEGIN
			
			SET @v_condtion_value = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT]( @v_csv_text_list,@i,',' )));
			IF ( @v_condtion_value IS NULL ) 
				BREAK ;
			ELSE
				CONTINUE;
				SET @v_count = @v_count + 1 ;
                
				IF (@i > 1) 
					SET @v_sql_text = @v_sql_text + ',';
                 
				SET @v_sql_text = @v_sql_text + '''' + @v_condtion_value + '''' ;
                 
			END;
		 RETURN (@v_sql_text);
         END;
     
	 --SET @v_sql_text = '3333';  
	   
	   ----------------------------------------------------------------------------
		IF ISNULL(@v_csv_text_list,'ALL') = 'ALL' 
			SET @v_sql_text = '';
		----------------------------------------------------------------------------
		ELSE IF (@v_csv_text_list = '')         
			SET @v_sql_text = '';
		ELSE IF (@p_column_name IS NULL)         
			SET @v_sql_text = '';
		----------------------------------------------------------------------------
		--ELSE IF CHARINDEX(@p_column_name,'[') < CHARINDEX(@p_column_name,']') 
		--    SET @v_column_name = SUBSTRING(@p_column_name,CHARINDEX(@p_column_name,'[')+1,CHARINDEX(@p_column_name,']')-CHARINDEX(@p_column_name,'[')-1);
		--    SET @v_sql_text    = REPLACE(@p_column_name,'['+@v_column_name+']',SCM_GET_WHERE_SQL_FUNC(@v_column_name,@v_logical_operator,@v_csv_text_list)) ;
		--    SET @v_sql_text    = 'AND ' +  REPLACE(@v_sql_text,'*','%');
		----------------------------------------------------------------------------
		ELSE IF (@v_logical_operator IN ('LK','LIKE') )
		----------------------------------------------------------------------------
			-- 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환    		
			BEGIN			 
			IF @p_csv_text_list = ''
			    RETURN ( '' );
			
			SET @v_sql_text = CHAR(10) + ' AND ( ' ;
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
					SET @v_sql_text = @v_sql_text + @v_column_name ;
					        						
					IF SUBSTRING(@v_condtion_value,1,1) = '!'
						BEGIN							
						SET @v_condtion_value = SUBSTRING(@v_condtion_value,2,DATALENGTH(@v_condtion_value) - 1);							
						SET @v_sql_text = @v_sql_text +  ' NOT LIKE''%' + LTRIM( RTRIM(@v_condtion_value)  ) + '%'' OR ' ;
						END
					ELSE 
						BEGIN
						SET @v_condtion_value = SUBSTRING(@v_condtion_value,1,DATALENGTH(@v_condtion_value));
						SET @v_sql_text = @v_sql_text + ' LIKE ''%' +  + LTRIM(RTRIM(@v_condtion_value)) + '%'' OR ' ;
						END
						
					SET @v_list_count = @v_list_count + 1;
					END
				END;
		    
			         
			SET @v_sql_text = SUBSTRING(CONVERT(TEXT,@v_sql_text),1,LEN(RTRIM(@v_sql_text))-3) + ' ) ' ;
			-- 값목록이 한건밖에 없으면 바로 LIKE로만 처리
			IF @v_count = 1 
			BEGIN 			
				IF SUBSTRING(@v_csv_text_list,1,1) = '!' 
					SET @v_sql_text = CHAR(10) + ' AND ' + @v_column_name + ' NOT LIKE N''%' + LTRIM( RTRIM( SUBSTRING(@v_csv_text_list,1,2) ) ) + '%'' ' ;
				ELSE
				    SET	@v_sql_text = CHAR(10) + ' AND ' + @v_column_name + ' LIKE N''%' + LTRIM(RTRIM(@v_csv_text_list)) + '%'' ' ;
            END;         
			-- 사용자가 * 로 WildCard입력시 %로 변환
			SET @v_sql_text = REPLACE(@v_sql_text,'*','%');
		    END;
		----------------------------------------------------------------------------
		ELSE IF @v_logical_operator IN ('NL','NOT LIKE')  -- NOT LIKE
		----------------------------------------------------------------------------
		-- 값목록이 복수개로 입력되면 AND (  col NOT LIKE v1 OR col NOT LIKE v2 ) 로변환
		    BEGIN
			IF @p_csv_text_list = ''
			    RETURN ( '' );

			SET @v_sql_text = CHAR(10) + ' AND ( ' ;
			SET @v_list_count = 1;
			--SET @i = 0;		
			WHILE(@v_list_count <= 1000)
				BEGIN
				---[dbo].[SCM_ARR_SPL_CNT]
				SET @v_condtion_value = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT]( 'N' + @v_csv_text_list, @v_list_count, ',' ) ) ) ;
				
				IF  @v_condtion_value IS NULL 
					BREAK ;
				ELSE 
					BEGIN
					SET @v_count    = @v_count + 1 ;
					SET @v_sql_text = @v_sql_text + @v_column_name ;
													
					SET @v_condtion_value = SUBSTRING(@v_condtion_value,1,DATALENGTH(@v_condtion_value));
					SET @v_sql_text = @v_sql_text + ' NOT LIKE N' + '''%' + LTRIM(RTRIM(@v_condtion_value)) + '%'' OR ' ;
													
					SET @v_list_count = @v_list_count + 1;
					END
				END;
		            
			SET @v_sql_text = SUBSTRING(CONVERT(TEXT,@v_sql_text),1,LEN(@v_sql_text)-3) + ' ) ' ;

			-- 값목록이 한건밖에 없으면 바로 NOT LIKE로만 처리
			IF @v_count = 1  
				SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' NOT LIKE N''%' + LTRIM(RTRIM(@v_csv_text_list)) + '%'' ' ;
        
			-- 사용자가 * 로 WildCard입력시 %로 변환
			SET @v_sql_text = REPLACE(@v_sql_text,'*','%');
			END;
		----------------------------------------------------------------------------
		ELSE IF @v_logical_operator IN ('EQ','EQUAL','IN') 
		----------------------------------------------------------------------------
			-- 값목록이 복수개로 입력되면 IN ( v1, v2 , v3, v4 ) 로변환
			BEGIN			
			IF SUBSTRING(@v_csv_text_list,1,1) = '!' 
				SET @v_sql_text = CHAR(10) + ' AND ' + @v_column_name + ' NOT IN (';
			ELSE
				SET @v_sql_text = CHAR(10) + ' AND ' + @v_column_name + ' IN (';			

			SET @i = 1;
			WHILE(@i <= 1000)
			    BEGIN
				SET @v_condtion_value = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT]( REPLACE(@v_csv_text_list,'!',''), @i, ',' )));
				IF ( @v_condtion_value IS NULL ) 
					BREAK ;
				ELSE 
				    BEGIN
					SET @v_count    = @v_count + 1 ;
					SET @v_sql_text = @v_sql_text + '''' + @v_condtion_value + ''',' ;

					SET @i = @i + 1;
					END;
				END;			
			--RETURN (@v_sql_text + ' 1');
			--SET @v_sql_text = SUBSTRING(CONVERT(TEXT, @v_sql_text),1,LEN(@v_sql_text)-1) + ') ' ;
			--RETURN (@v_sql_text + ' 1');
			SET @v_sql_text = SUBSTRING(CONVERT(NVARCHAR(MAX), @v_sql_text),1,LEN(@v_sql_text)-1) + ') ' ;
			RETURN (@v_sql_text + ' 1');
			-- 값목록이 한건밖에 없으면 바로 EQUAL 로만 처리
			SET @v_csv_text_list = LTRIM(RTRIM(REPLACE(@v_csv_text_list,'*','%')));
			IF @v_count = 1  
				IF SUBSTRING(@v_csv_text_list,1,1) = '!' 
					IF SUBSTRING(@v_csv_text_list,-1,1) = '%' 
						SET @v_sql_text = CHAR(10) + ' AND ' + @v_column_name + ' NOT LIKE ''' + LTRIM(RTRIM(SUBSTRING(@v_csv_text_list,1,2))) + ''' ' ;
					ELSE
						SET @v_sql_text = CHAR(10) + ' AND ' + @v_column_name + ' != ''' + LTRIM(RTRIM(SUBSTRING(@v_csv_text_list,1,2))) + ''' ' ;
					
				ELSE
					IF SUBSTRING(@v_csv_text_list,-1,1) = '%' 
						SET @v_sql_text = CHAR(10) + ' AND ' + @v_column_name + ' LIKE ''' + LTRIM(RTRIM(@v_csv_text_list)) + ''' ' ;
					ELSE
						SET @v_sql_text = CHAR(10) + ' AND ' + @v_column_name + ' = ''' + LTRIM(RTRIM(@v_csv_text_list)) + ''' ' ;
					
		    --RETURN (@v_sql_text);
			END;
        
		----------------------------------------------------------------------------
		ELSE IF @v_logical_operator IN ('NE','NOT EQUAL','NI','NOT IN' ) 
		----------------------------------------------------------------------------
			-- 값목록이 복수개로 입력되면 NOT IN ( v1, v2 , v3, v4 ) 로변환
			BEGIN	
			SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' NOT IN (';
			SET @i = 1;
			WHILE(@i <= 1000)
			    BEGIN
				SET @v_condtion_value = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT]( @v_csv_text_list, @i, ',' )));
				IF ( @v_condtion_value IS NULL ) 
					BREAK ;
				ELSE 
				    BEGIN
					SET @v_count    = @v_count + 1 ;
					SET @v_sql_text = @v_sql_text + '''' + @v_condtion_value + ''',' ;
					SET @i = @i + 1;
					END
				END;
			-- 값목록이 한건밖에 없으면 바로 NOT EQUAL 로만 처리
			SET @v_sql_text = SUBSTRING(CONVERT(TEXT, @v_sql_text),1,DATALENGTH(@v_sql_text)-1) + ') ' ;
			IF @v_count = 1 
				SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' != ''' + LTRIM(RTRIM(@v_csv_text_list)) + ''' ' ;
            END;
		----------------------------------------------------------------------------
		ELSE IF @v_logical_operator IN ('BW','BETWEEN') 
		----------------------------------------------------------------------------
			-- 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환
			BEGIN
			SET @v_sql_text = CHAR(10) + ' AND ( ' ;
			SET @i = 1;
			WHILE(@i <= 1000)
				BEGIN
				SET @v_condtion_value = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT]( @v_csv_text_list, @i, ',' )));
				IF ( @v_condtion_value IS NULL ) 
					BREAK ;
				ELSE 
				    BEGIN
					SET @v_count    = @v_count + 1 ;
					SET @v_1st_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_condtion_value,1,':')));
					SET @v_2nd_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_condtion_value,2,':')));
					SET @v_sql_text = @v_sql_text + ' ( ' + @p_column_name + ' BETWEEN ''' + @v_1st_node
																	 + ''' AND '''   + ISNULL(@v_2nd_node,@v_1st_node)
																	 + ''' ) OR ';
				    SET @i = @i + 1;
					END;
			    END;
			
			SET @v_sql_text = SUBSTRING(CONVERT(TEXT, @v_sql_text),1,LEN(@v_sql_text)-3) + ' ) ' ;
			-- 값목록이 한건밖에 없으면 바로 LIKE로만 처리
			IF @v_count = 1 
			    BEGIN
				SET @v_1st_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,':',1)));
				SET @v_2nd_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,':',2)));
				SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' BETWEEN ''' + @v_1st_node
																 + ''' AND '''   + ISNULL(@v_2nd_node,@v_1st_node)
																 + ''' ';
                 END;
			END;
		----------------------------------------------------------------------------
		ELSE IF @v_logical_operator IN ('BD','BETWEEN DATE') 
		----------------------------------------------------------------------------
			-- 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환
			BEGIN
			SET @v_sql_text = CHAR(10) + ' AND ( ' ;
			WHILE(@i <= 1000)
			    BEGIN
				SET @v_condtion_value = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT]( @v_csv_text_list, ',', @i )));
				IF ( @v_condtion_value IS NULL ) 
					BREAK ;
				ELSE 
				    BEGIN
					SET @v_count    = @v_count + 1 ;
					SET @v_1st_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_condtion_value,1,':')));
					SET @v_2nd_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_condtion_value,2,':')));
					SET @v_sql_text = @v_sql_text + ' ( ' + @p_column_name + ' BETWEEN CONVERT(CHAR(8)''' + @v_1st_node + ''',112) '
																		   + ' AND     CONVERT(CHAR(8)''' + ISNULL(@v_2nd_node,@v_1st_node) + ''',112) + 86399/86400 '
																		   + ') OR ';
				    END;
			    END;
			SET @v_sql_text = SUBSTRING(CONVERT(TEXT, @v_sql_text),1,DATALENGTH(@v_sql_text)-3) + ' ) ' ;
			-- 값목록이 한건밖에 없으면 바로 LIKE로만 처리
			IF  @v_count = 1 
			    BEGIN
				SET @v_1st_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,1,':')));
				SET @v_2nd_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,2,':')));
				SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' BETWEEN CONVERT(CHAR(8)''' + @v_1st_node + ''',''YYYYMMDD'') '
																	  + ' AND CONVERT(CHAR(8)'''     + ISNULL(@v_2nd_node,@v_1st_node) + ''',''YYYYMMDD'') + 86399/86400';
                END;
			END;
		----------------------------------------------------------------------------
		ELSE IF @v_logical_operator IN ('BM','BETWEEN MONTH') 
		----------------------------------------------------------------------------
			-- 값목록이 복수개로 입력되면 AND (  col LIKE v1 OR col LIKE v2 ) 로변환
			BEGIN
			SET @v_sql_text = CHAR(10) + ' AND ( ' ;
			WHILE(@i <= 1000)
			    BEGIN
				SET @v_condtion_value = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT]( @v_csv_text_list, @i, ',' )));
				IF ( @v_condtion_value IS NULL ) 
					BREAK ;
				ELSE 
				    BEGIN
					SET @v_count    = @v_count + 1 ;
					SET @v_1st_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_condtion_value,1,':')));
					SET @v_2nd_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_condtion_value,2,':')));
					SET @v_sql_text = @v_sql_text + ' ( ' + @p_column_name + ' BETWEEN CONVERT(CHAR(6)''' + @v_1st_node + ''',112) '
																		   + ' AND CONVERT(CHAR(6), DATEADD(MM, 1,''' + ISNULL(@v_2nd_node,@v_1st_node) +''',112),1) - 1/86400 '
																		   + ') OR ';
				    END;
			    END ;

			SET @v_sql_text = SUBSTRING(CONVERT(TEXT, @v_sql_text),1,DATALENGTH(@v_sql_text)-3) + ' ) ' ;
			-- 값목록이 한건밖에 없으면 바로 LIKE로만 처리
			IF  @v_count = 1  
			    BEGIN
				SET @v_1st_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,1,':')));
				SET @v_2nd_node = LTRIM(RTRIM([dbo].[FN_SCM_SPLIT](@v_csv_text_list,2,':')));
				SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' BETWEEN TO_DATE('''        + @v_1st_node + ''',112) '
																 + ' AND ADD_MONTHS(TO_DATE(''' + ISNULL(@v_2nd_node,@v_1st_node) +''',112),1) - 1/86400 ';                                                                  
		        END;
			END;
		----------------------------------------------------------------------------
		ELSE IF ( @v_logical_operator = 'GT' )  
		----------------------------------------------------------------------------
			SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' > ''' + LTRIM(RTRIM(@v_csv_text_list)) + ''' ' ;
		----------------------------------------------------------------------------
		ELSE IF ( @v_logical_operator = 'GE' )  
		----------------------------------------------------------------------------
			SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' >= ''' + LTRIM(RTRIM(@v_csv_text_list)) + ''' ' ;
		----------------------------------------------------------------------------
		ELSE IF ( @v_logical_operator = 'LT' )  
		----------------------------------------------------------------------------
			SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' < ''' + LTRIM(RTRIM(@v_csv_text_list)) + ''' ' ;
		----------------------------------------------------------------------------
		ELSE IF ( @v_logical_operator = 'LE' )  
		----------------------------------------------------------------------------
			SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' <= ''' + LTRIM(RTRIM(@v_csv_text_list)) + ''' ' ;
		----------------------------------------------------------------------------
		ELSE IF ( @v_logical_operator = 'CK' )   -- CheckBox for Y Only
		----------------------------------------------------------------------------
			IF LTRIM(RTRIM(@v_csv_text_list)) = 'Y'
				SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' = ''Y'' ' ;            
		----------------------------------------------------------------------------
		ELSE
		----------------------------------------------------------------------------
			BEGIN
			SET @v_sql_text = CHAR(10) + ' AND ' + @p_column_name + ' LIKE ''%' + LTRIM(RTRIM(@v_csv_text_list)) + '%'' ' ;
				-- 사용자가 * 로 WildCard입력시 %로 변환
			SET @v_sql_text = REPLACE(@v_sql_text,'*','%');  
			END;
    END;
	
    ----------------------------------------------------------------------------
    RETURN (@v_sql_text);
    ----------------------------------------------------------------------------   
	
END;


