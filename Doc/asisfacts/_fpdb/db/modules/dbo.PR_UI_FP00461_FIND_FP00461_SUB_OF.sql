CREATE PROCEDURE [dbo].[PR_UI_FP00461_FIND_FP00461_SUB_OF]
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
/** 프로그램 ID   : PR_UI_FP00461_FIND_FP00461_SUB_OF                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00461_FIND_FP00461_SUB_OF                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-05-26     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00461_FIND_FP00461_SUB_OF
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00461_FIND_FP00461_SUB_OF'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''

  DECLARE @p_bucketlist nvarchar(max) = ''
  DECLARE @p_daylist nvarchar(max) = ''

  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_bucket nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0user_id nvarchar(max)
  DECLARE @opt_1user_id nvarchar(max)
  DECLARE @opt_2site_id nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4site_id nvarchar(max)
  DECLARE @opt_5site_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET' BEGIN
      SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKETLIST' BEGIN
      SET @p_bucketlist =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DAYLIST' BEGIN
      SET @p_daylist =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_bucket ='''' + @p_bucket + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_plant_lt ='''' + @p_plant_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_user_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0user_id = ''
  END ELSE BEGIN
    SET @opt_0user_id = 'i'
  END
  SET @STRLEN = LEN(@p_user_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1user_id = ''
  END ELSE BEGIN
    SET @opt_1user_id = 'i'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2site_id = ''
  END ELSE BEGIN
    SET @opt_2site_id = '0'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = '55'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4site_id = ''
  END ELSE BEGIN
    SET @opt_4site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5site_id = ''
  END ELSE BEGIN
    SET @opt_5site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END


  -- FP00461 find_FP00461_sub  
  SET @v_dSql = ''
  SET @v_dSql += '					SELECT A.COMPANY_ID'+char(10)
  SET @v_dSql += '					      ,A.DIVISION_ID'+char(10)
  SET @v_dSql += '					      ,A.SITE_ID'+char(10)
  SET @v_dSql += '					      ,A.PLANT_ID'+char(10)
  SET @v_dSql += '					      ,''DATA'' AS CATEGORY_ID'+char(10)
  SET @v_dSql += @p_daylist
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  					--  var SQL="";
  					--  var SQL2="";
  					--  var bucketlist = $data.bucket;
  
  					--	if(bucketlist.size() > 0){
  					--		for(var i = 0; i < bucketlist.size(); i++){
  					--		  SQL+=",MAX(CASE WHEN CONVERT(NVARCHAR(8),WORK_DATE,112)=''''" + bucketlist[i].VALUE + "'''' THEN WORKER_QTY ELSE 0 END) AS V"+(i+1)+"\r\n";
  					--		  SQL2+=",''''" + bucketlist[i].VALUE + "'''' AS D"+(i+1)+"\r\n";
  					--		}
  
  					--		SQL+=SQL2;
  
  					--		SQL;
  					--	}
  					--}

  --'
  SET @v_dSql += '					      ,(CASE WHEN R.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN'+char(10)
  SET @v_dSql += '					FROM SCM_PACK_WORKER_LIMIT_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '               SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID'+char(10)
  SET @v_dSql += '               FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '               WHERE  R.USER_ID   ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '               AND    R.SAVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '          ) R'+char(10)
  SET @v_dSql += '          ON   A.COMPANY_ID  = R.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND  A.DIVISION_ID = R.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND  A.SITE_ID     = R.SITE_ID'+char(10)
  SET @v_dSql += '          AND  A.PLANT_ID    = R.PLANT_ID'+char(10)
  SET @v_dSql += '					WHERE 1=1'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += @p_bucketlist
  --SET @v_dSql += '
  --{
  --					  var SQL="";
  --					  var bucketlist = $data.bucket;
  --
  --						if(bucketlist.size() > 0){
  --						  SQL+="AND A.WORK_DATE BETWEEN ''''" + bucketlist[0].VALUE + "'''' AND ''''" + bucketlist[55].VALUE + "''''\r\n";
  --
  --							SQL;
  --						}
  --					}

  --'
  SET @v_dSql += ' ' +@opt_4site_id +' '+''+char(10)--AND    A.SITE_ID = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --						var sql = "";
  --						if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --							sql+= "AND A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --						}
  --						sql;
  --					}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --						var sql = "";
  --						if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --							sql+= "AND A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --						}
  --						sql;
  --					}

  --'
  SET @v_dSql += '					GROUP BY A.COMPANY_ID'+char(10)
  SET @v_dSql += '					      ,A.DIVISION_ID'+char(10)
  SET @v_dSql += '					      ,A.SITE_ID'+char(10)
  SET @v_dSql += '					      ,A.PLANT_ID'+char(10)
  SET @v_dSql += '					      ,R.PLANT_ID'+char(10)
  SET @v_dSql += '					ORDER BY COMPANY_ID'+char(10)
  SET @v_dSql += '					      ,DIVISION_ID'+char(10)
  SET @v_dSql += '					      ,SITE_ID'+char(10)
  SET @v_dSql += '					      ,PLANT_ID'+char(10)
  SET @v_dSql += '					      ,CATEGORY_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --         $data.querySet1 = $jdbc.queryList("FP00461","find_FP00461_sub",param);
  --
  --}

  --'


  IF @p_sys_type = 'SQL'
  BEGIN
    -- return SQL Query Source
    select @v_dSql as [QUERY_VALUE]
  END ELSE BEGIN
    SET @runstart = GetDate()

    BEGIN TRY
      BEGIN TRAN
        -- run dynamic sql
        exec sp_executesql @v_dSql
      COMMIT TRAN
    END TRY
    BEGIN CATCH
      ROLLBACK
      SET @runend = GetDate()
      exec PR_UI_SQL_LOG 'PR_UI_FP00461_FIND_FP00461_SUB_OF',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00461_FIND_FP00461_SUB_OF',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
