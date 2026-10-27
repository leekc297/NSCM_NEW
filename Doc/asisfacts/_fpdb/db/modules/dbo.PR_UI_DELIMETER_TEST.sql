CREATE PROCEDURE [dbo].[PR_UI_DELIMETER_TEST]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @in_columns nvarchar(MAX),
  @in_row nvarchar(MAX),
  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : [PR_UI_DELIMETER_TEST]                                                            **/
/** 프로그램 명   : Procedure [PR_UI_DELIMETER_TEST]                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/***********************************************************************************************/
/*
  EXEC [PR_UI_DELIMETER_TEST]
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  --DECLARE BASE PARAMETER START
  DECLARE @STRLEN nvarchar(max)
  DECLARE @runstart datetime
  DECLARE @runend datetime
  DECLARE @v_dSql nvarchar(max)
  DECLARE @v_Err nvarchar(max)
  DECLARE @v_Log nvarchar(max) 
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00602_FIND_FP00602'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0

  DECLARE @p_master_id nvarchar(max) = ''
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_week_info nvarchar(max) = ''
  DECLARE @p_month_info nvarchar(max) = ''
  DECLARE @p_cate_info nvarchar(max) = ''
  DECLARE @p_wink nvarchar(max) = ''



  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
   
    END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
      SET @p_master_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET' BEGIN
      SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
      SET @p_week_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
      SET @p_month_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CATE_INFO' BEGIN
      SET @p_cate_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
        END ELSE IF @tmp_column = 'WINK' BEGIN
      SET @p_wink =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);    
	END
  END
  
  DECLARE @loop_src NVARCHAR(MAX) = ''
  DECLARE @_max_length integer = 0
  DECLARE @sub_tmp_column NVARCHAR(MAX) = ''

  DECLARE @sub_param_0 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_1 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_2 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_3 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_4 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_5 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_6 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_7 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_8 NVARCHAR(MAX) = '' 


  SET @v_dSql = ''   

     IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
		SET @v_dSql = 'Test Bucket Size : ' + TRY_CONVERT(NVARCHAR, @max_loop_cnt)  + char(10)   
		IF @max_loop_cnt > 0 BEGIN	    
		    
			IF 1=0 BEGIN
			SET @v_dSql += '------ MONTH_INFO ---- START' + char(10)			
			-- monthinfo
			SET @loop_src = @p_MONTH_INFO
			SET @v_dSql += @loop_src + char(10)
			SET @mst_loop_cnt = 0
			-- ! 문자가 ROWS 내의 개별 ROW를 구분하는 문자임
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				-- @tmp_column에 개별ROW값이 기록되어 있음
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				
				-- OPTION (BY INDEX)
				-- # 문자가 ROW 내의 컬럼값을 구분하는 문자임 컬럼:값 형식의 튜플로 기록되어 있음
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				IF @_max_length > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 1)   END -- MONTH
				IF @_max_length > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 2)   END -- MONTH_NAME
				IF @_max_length > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 3)   END -- MONTH_COUNT
				IF @_max_length > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 4)   END -- M_VALUE
				
				SET @v_dSql += ' index : '+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +char(10)
				SET @v_dSql += ' source : '+@tmp_column +char(10)
				SET @v_dSql += ' 1 : '+@sub_param_0 +char(10)
				SET @v_dSql += ' 2 : '+@sub_param_1 +char(10)
				SET @v_dSql += ' 3 : '+@sub_param_2 +char(10)
				SET @v_dSql += ' 4 : '+@sub_param_3 +char(10)
				
				-- OPTION (BY KEY) : 키값을 알고 있는 경우 아래와 같이 사용할 수 있다
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				SET @v_dSql += ' MONTH : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','MONTH')   +char(10)
				SET @v_dSql += ' MONTH_NAME : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','MONTH_NAME')   +char(10)
				SET @v_dSql += ' MONTH_COUNT : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','MONTH_COUNT')   +char(10)
				SET @v_dSql += ' M_VALUE : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','M_VALUE')   +char(10)

			END-- end of @mst_loop_cnt < @max_loop_cnt
			SET @v_dSql += '------ MONTH_INFO ---- END' + char(10)
			END

			IF 1=1 BEGIN
			SET @v_dSql += '------ WEEK_INFO ---- START' + char(10)
			-- weekinfo
			SET @loop_src = @p_WEEK_INFO
			SET @v_dSql += @loop_src + char(10)
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				-- @tmp_column에 개별ROW값이 기록되어 있음
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				
				-- OPTION (BY INDEX)
				-- # 문자가 ROW 내의 컬럼값을 구분하는 문자임 컬럼:값 형식의 튜플로 기록되어 있음
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				IF @_max_length > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 1)   END -- WEEK
				IF @_max_length > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 2)   END -- WEEK_NAME
				IF @_max_length > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 3)   END -- WEEK_COUNT
				IF @_max_length > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 4)   END -- W_VALUE
				
				SET @v_dSql += ' index : '+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +char(10)
				SET @v_dSql += ' source : '+@tmp_column +char(10)
				SET @v_dSql += ' 1 : '+@sub_param_0 +char(10)
				SET @v_dSql += ' 2 : '+@sub_param_1 +char(10)
				SET @v_dSql += ' 3 : '+@sub_param_2 +char(10)
				SET @v_dSql += ' 4 : '+@sub_param_3 +char(10)
				
				-- OPTION (BY KEY) : 키값을 알고 있는 경우 아래와 같이 사용할 수 있다
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				SET @v_dSql += ' WEEK : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','WEEK')   +char(10)
				SET @v_dSql += ' WEEK_NAME : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','WEEK_NAME')   +char(10)
				SET @v_dSql += ' WEEK_COUNT : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','WEEK_COUNT')   +char(10)
				SET @v_dSql += ' W_VALUE : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','W_VALUE')   +char(10)
			END-- end of @mst_loop_cnt < @max_loop_cnt
			SET @v_dSql += '------ WEEK_INFO ---- END' + char(10)

			SET @v_dSql += '------ BUCKET_INFO ---- START' + char(10)
			END

			-- bucket
			IF 1=0 BEGIN
			
			SET @loop_src = @p_bucket
			SET @v_dSql += @loop_src + char(10)
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				-- @tmp_column에 개별ROW값이 기록되어 있음
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				
				-- OPTION (BY INDEX)
				-- # 문자가 ROW 내의 컬럼값을 구분하는 문자임 컬럼:값 형식의 튜플로 기록되어 있음
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				IF @_max_length > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 1)   END -- _DATE
				IF @_max_length > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 2)   END -- _NAME
				IF @_max_length > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 3)   END -- _COUNT
				IF @_max_length > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 4)   END -- _VALUE
				IF @_max_length > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 5)   END -- _DATE_SEQ
				IF @_max_length > 5 BEGIN   SET @sub_param_5 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 6)   END -- WEEK_SEQ
				IF @_max_length > 6 BEGIN   SET @sub_param_6 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 7)   END -- _TYPE
				IF @_max_length > 7 BEGIN   SET @sub_param_7 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 8)   END -- POST_ORDER

				
				SET @v_dSql += ' index : '+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +char(10)
				SET @v_dSql += ' source : '+@tmp_column +char(10)
				SET @v_dSql += ' 1 : '+@sub_param_0 +char(10)
				SET @v_dSql += ' 2 : '+@sub_param_1 +char(10)
				SET @v_dSql += ' 3 : '+@sub_param_2 +char(10)
				SET @v_dSql += ' 4 : '+@sub_param_3 +char(10)
				SET @v_dSql += ' 5 : '+@sub_param_4 +char(10)
				SET @v_dSql += ' 6 : '+@sub_param_5 +char(10)
				SET @v_dSql += ' 7 : '+@sub_param_6 +char(10)
				SET @v_dSql += ' 8 : '+@sub_param_7 +char(10)

				
				-- OPTION (BY KEY) : 키값을 알고 있는 경우 아래와 같이 사용할 수 있다
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				SET @v_dSql += ' _DATE : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE')   +char(10)
				SET @v_dSql += ' _NAME : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_NAME')   +char(10)
				SET @v_dSql += ' _COUNT : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_COUNT')   +char(10)
				SET @v_dSql += ' WEEK_COUNT : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_VALUE')   +char(10)
				SET @v_dSql += ' _DATE_SEQ : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE_SEQ')   +char(10)
				SET @v_dSql += ' WEEK_SEQ : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','WEEK_SEQ')   +char(10)
				SET @v_dSql += ' _TYPE : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_TYPE')   +char(10)
				SET @v_dSql += ' POST_ORDER : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','POST_ORDER')   +char(10)
			END-- end of @mst_loop_cnt < @max_loop_cnt
			SET @v_dSql += '------ BUCKET_INFO ---- END' + char(10)

			END
			IF 1= 0 BEGIN
			SET @v_dSql += '------ CATE_INFO ---- START' + char(10)
			-- cate info
			SET @loop_src = @p_cate_info
			SET @v_dSql += @loop_src + char(10)
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt+1 < @max_loop_cnt 
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				-- @tmp_column에 개별ROW값이 기록되어 있음
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				
				-- OPTION (BY INDEX)
				-- # 문자가 ROW 내의 컬럼값을 구분하는 문자임 컬럼:값 형식의 튜플로 기록되어 있음
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				IF @_max_length > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 1)   END -- MEA_ID
				IF @_max_length > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 2)   END -- MEA_VALUE
				IF @_max_length > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 3)   END -- MEA_NAME
				IF @_max_length > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 4)   END -- TYPE
				IF @_max_length > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 5)   END -- FLAG
				IF @_max_length > 5 BEGIN   SET @sub_param_5 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 6)   END -- USER_ID
				IF @_max_length > 6 BEGIN   SET @sub_param_6 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 7)   END -- MENU_ID
				
				SET @v_dSql += ' index : '+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +char(10)
				SET @v_dSql += ' source : '+@tmp_column +char(10)
				SET @v_dSql += ' 1 : '+@sub_param_0 +char(10)
				SET @v_dSql += ' 2 : '+@sub_param_1 +char(10)
				SET @v_dSql += ' 3 : '+@sub_param_2 +char(10)
				SET @v_dSql += ' 4 : '+@sub_param_3 +char(10)
				SET @v_dSql += ' 5 : '+@sub_param_4 +char(10)
				SET @v_dSql += ' 6 : '+@sub_param_5 +char(10)
				SET @v_dSql += ' 7 : '+@sub_param_6 +char(10)

				-- OPTION (BY KEY) : 키값을 알고 있는 경우 아래와 같이 사용할 수 있다
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				SET @v_dSql += ' MEA_ID : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','MEA_ID')   +char(10)
				SET @v_dSql += ' MEA_VALUE : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','MEA_VALUE')   +char(10)
				SET @v_dSql += ' MEA_NAME : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','MEA_NAME')   +char(10)
				SET @v_dSql += ' TYPE : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','TYPE')   +char(10)
				SET @v_dSql += ' FLAG : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','FLAG')   +char(10)
				SET @v_dSql += ' USER_ID : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','USER_ID')   +char(10)
				SET @v_dSql += ' MENU_ID : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','MENU_ID')   +char(10)

			END-- end of @mst_loop_cnt < @max_loop_cnt
			SET @v_dSql += '------ CATE_INFO ---- END' + char(10)
			END

			IF 1=1 BEGIN
			SET @v_dSql += '------ WINK ---- START' + char(10)
			-- wink info
			SET @loop_src = @p_wink
			SET @v_dSql += @loop_src + char(10)
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				IF @_max_length > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 1)   END -- AAA
				IF @_max_length > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 2)   END -- BBB
				IF @_max_length > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 3)   END -- CCC
				IF @_max_length > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 4)   END -- M_VALUE
				IF @_max_length > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,'#', 5)   END -- M_VALUE

				SET @v_dSql += ' index : '+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +char(10)
				SET @v_dSql += ' source : '+@tmp_column +char(10)
				SET @v_dSql += ' 1 : '+@sub_param_0 +char(10)
				SET @v_dSql += ' 2 : '+@sub_param_1 +char(10)
				SET @v_dSql += ' 3 : '+@sub_param_2 +char(10)
				SET @v_dSql += ' 4 : '+@sub_param_3 +char(10)
				SET @v_dSql += ' 5 : '+@sub_param_4 +char(10)
				SET @v_dSql += ' 6 : '+@sub_param_5 +char(10)
				SET @v_dSql += ' 7 : '+@sub_param_6 +char(10)

				-- OPTION : 키값을 알고 싶다
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				IF @_max_length > 0 BEGIN  SET @v_dSql += ' ? : '+ [dbo].[SCM_ARR_SPL_KEY_ENTITY]( @tmp_column,'#', 1)   +char(10) END
				IF @_max_length > 1 BEGIN  SET @v_dSql += ' ? : '+ [dbo].[SCM_ARR_SPL_KEY_ENTITY]( @tmp_column,'#', 2)   +char(10) END
				IF @_max_length > 2 BEGIN  SET @v_dSql += ' ? : '+ [dbo].[SCM_ARR_SPL_KEY_ENTITY]( @tmp_column,'#', 3)   +char(10) END
				IF @_max_length > 3 BEGIN  SET @v_dSql += ' ? : '+ [dbo].[SCM_ARR_SPL_KEY_ENTITY]( @tmp_column,'#', 4)   +char(10) END

				

				-- OPTION (BY KEY) : 키값을 알고 있는 경우 아래와 같이 사용할 수 있다
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
				SET @v_dSql += ' AAA : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','AAA')   +char(10)
				SET @v_dSql += ' BBB : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','BBB')   +char(10)
				SET @v_dSql += ' CCC : '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','CCC')   +char(10)
				
			END-- end of @mst_loop_cnt < @max_loop_cnt
			SET @v_dSql += '------ WINK ---- END' + char(10)
			END
	    END-- end of p_bucket count > 0
	END-- end of isnull(@p_bucket,'') <> ''


	DECLARE @bMppIn integer = 1

      IF isnull(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, '!') -- 프로시저 LOOP 길이를 판단
  			  WHILE @mst_loop_cnt < @max_loop_cnt
				  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
					SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info			    ,'!', @mst_loop_cnt);
					IF @tmp_column = 'chk_mpp_inqty' BEGIN
						SET @bMppIn = 1
					END 
			END-- END OF WHILE
	  END-- END OF @p_cate_info

	  DECLARE @print_raw_data integer = 0

	  if @print_raw_data =1 BEGIN
		SEt @v_dSql = ''
	 	SEt @v_dSql += '--------CATE INFO' + char(10)
	 	SET @v_dSql += @p_cate_info + char(10)
	 	SEt @v_dSql += '--------BUCKET INFO' + char(10)
	 	SET @v_dSql += @p_bucket + char(10)
	 	SEt @v_dSql += '--------MONTH INFO' + char(10)
	 	SET @v_dSql += @p_month_info + char(10)
	 	SEt @v_dSql += '--------WEEK INFO' + char(10)
	 	SET @v_dSql += @p_week_info + char(10)
			 	SEt @v_dSql += '--------WINK INFO' + char(10)
	 	SET @v_dSql += @p_wink + char(10)
	  END
    

    -- return SQL Query Source
    select @v_dSql as [QUERY_VALUE]
END
