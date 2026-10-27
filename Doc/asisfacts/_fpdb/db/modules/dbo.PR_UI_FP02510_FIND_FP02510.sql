CREATE PROCEDURE [dbo].[PR_UI_FP02510_FIND_FP02510]
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
/** 프로그램 ID   : PR_UI_FP02510_FIND_FP02510                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP02510_FIND_FP02510                                                                          **/
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
/** 2021-06-01     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP02510_FIND_FP02510
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP02510_FIND_FP02510'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1site_id nvarchar(max)

  IF @p_sys_gubun = 'ALL' BEGIN
	exec PR_UI_FP02510_FIND_FP02510_ALL @p_sys_type,@p_sys_flag,@p_sys_gubun,@p_user_id,@in_columns,@in_row,@opt_none
	RETURN
  END

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
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1site_id = ''
  END ELSE BEGIN
    SET @opt_1site_id = 'AND    A.SITE_ID=' + @v_site_id+''
  END


  -- FP02510 find_FP02510  
  SET @v_dSql = ''
  SET @v_dSql += '      WITH CTE_NODE(COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,CHILD_SITE_ID/*KIMCD 추가*/,CHILD_ITEM_TYPE,NLEVEL,NPATH,ROOT)'+char(10)
  SET @v_dSql += '      AS ('+char(10)
  SET @v_dSql += '          SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,CHILD_SITE_ID/*KIMCD 추가*/,'''' AS CHILD_ITEM_TYPE,NLEVEL,CONCATENATE_ITEM AS NPATH,MODEL_ID AS ROOT'+char(10)
  SET @v_dSql += '          FROM   SCM_MODEL_COMP_TEMP A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          WHERE  MODEL_ID IN ('+char(10)
  SET @v_dSql += '                SELECT MODEL_ID FROM SCM_MODEL_COMP_TEMP'+char(10)
  SET @v_dSql += '                WHERE CHILD_ITEM_ID='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '                UNION ALL'+char(10)
  SET @v_dSql += '                SELECT MODEL_ID FROM SCM_MODEL_COMP_TEMP'+char(10)
  SET @v_dSql += '                WHERE PARENT_ITEM_ID='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '          )'+char(10)
  SET @v_dSql += '    		  AND    EXISTS ('+char(10)
  SET @v_dSql += '            		SELECT 1'+char(10)
  SET @v_dSql += '            		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            		WHERE  A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '            		AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '            		AND    A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '            		AND    A.PLANT_ID       = B.PLANT_ID'+char(10)
  SET @v_dSql += '            		AND    B.USER_ID        ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '    		  )'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      select COMPANY_ID,DIVISION_ID,SITE_ID,MODEL_ID,MAX(ISNULL(NICK_NAME,''-'')) AS NICK_NAME,RNUM'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E0500'' THEN ITEM_ID END) AS E0500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E1000'' THEN ITEM_ID END) AS E1000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E2000'' THEN ITEM_ID END) AS E2000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E2300'' THEN ITEM_ID END) AS E2300'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E2500'' THEN ITEM_ID END) AS E2500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E3000'' THEN ITEM_ID END) AS E3000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E3500'' THEN ITEM_ID END) AS E3500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E4000'' THEN ITEM_ID END) AS E4000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E4500'' THEN ITEM_ID END) AS E4500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E8000'' THEN ITEM_ID END) AS E8000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''S1000'' THEN ITEM_ID END) AS S1000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''S2000'' THEN ITEM_ID END) AS S2000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''S4000'' THEN ITEM_ID END) AS S4000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A1000'' THEN ITEM_ID END) AS A1000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A2000'' THEN ITEM_ID END) AS A2000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A3000'' THEN ITEM_ID END) AS A3000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A5000'' THEN ITEM_ID END) AS A5000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A6000'' THEN ITEM_ID END) AS A6000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A7000'' THEN ITEM_ID END) AS A7000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A7100'' THEN ITEM_ID END) AS A7100'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A7200'' THEN ITEM_ID END) AS A7200'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A7500'' THEN ITEM_ID END) AS A7500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A8000'' THEN ITEM_ID END) AS A8000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A8100'' THEN ITEM_ID END) AS A8100'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A9000'' THEN ITEM_ID END) AS A9000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''P5000'' THEN ITEM_ID END) AS P5000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''P5200'' THEN ITEM_ID END) AS P5200'+char(10) -- kimsi P5200  22.09.30
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''P5500'' THEN ITEM_ID END) AS P5500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''P9500'' THEN ITEM_ID END) AS P9500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID IS NULL THEN ITEM_ID END) AS ETC'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '            SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.MODEL_ID'+char(10)
  SET @v_dSql += '                  ,A.OPERATION_ID,A.ITEM_ID,B.NICK_NAME'+char(10)
  SET @v_dSql += '                  ,ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.OPERATION_ID,A.MODEL_ID ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.ITEM_ID) AS RNUM'+char(10)
  SET @v_dSql += '            FROM   ('+char(10)
  SET @v_dSql += '                    SELECT DISTINCT'+char(10)
  SET @v_dSql += '                           AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, ROOT AS MODEL_ID, AA.CHILD_ITEM_ID AS ITEM_ID,BB.OPERATION_ID, BB.NICK_NAME'+char(10)
  SET @v_dSql += '                    FROM CTE_NODE AA INNER JOIN ('+char(10)
  SET @v_dSql += '                          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,'+char(10)
  SET @v_dSql += '                                 B.FLOW_ID, B.OPERATION_ID, B.OPERATION_SEQ, A.NICK_NAME'+char(10)
  SET @v_dSql += '                          FROM   SCM_ITEM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '                          INNER HASH JOIN SCM_OPERATION_FLOW_M B(NOLOCK)'+char(10)
  SET @v_dSql += '                          ON     A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += '                          AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '                          AND    A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += '                          AND    A.FLOW_ID = B.FLOW_ID'+char(10)
  SET @v_dSql += '                          AND    B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                          INNER HASH JOIN SCM_ITEM_CLASS_M C(NOLOCK)'+char(10)
  SET @v_dSql += '                          ON     A.ITEM_CLASS = C.CLASS_ID'+char(10)
  SET @v_dSql += '                          AND    C.USE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                          WHERE  A.ACTIVE_FLAG = ''Y'' AND A.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '                    ) BB'+char(10)
  SET @v_dSql += '                    ON    /*AA.COMPANY_ID=BB.COMPANY_ID'+char(10)
  SET @v_dSql += '                    AND   */AA.DIVISION_ID=BB.DIVISION_ID'+char(10)
  SET @v_dSql += '                    /*AND   AA.SITE_ID=BB.SITE_ID*/'+char(10)
  SET @v_dSql += '                    AND   AA.CHILD_ITEM_ID=BB.ITEM_ID'+char(10)
  SET @v_dSql += '					AND   AA.CHILD_SITE_ID=BB.SITE_ID /*KIMCD 추가*/'+char(10)
  SET @v_dSql += '                    /*'+char(10)
  SET @v_dSql += '                    UNION ALL'+char(10)
  SET @v_dSql += '                    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, D.ROOT AS MODEL_ID, A.ITEM_ID, B.OPERATION_ID, A.NICK_NAME'+char(10)
  SET @v_dSql += '                    FROM   SCM_ITEM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '                    INNER HASH JOIN SCM_OPERATION_FLOW_M B(NOLOCK)'+char(10)
  SET @v_dSql += '                    ON     A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += '                    AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '                    AND    A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += '                    AND    A.FLOW_ID = B.FLOW_ID'+char(10)
  SET @v_dSql += '                    AND    B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                    INNER HASH JOIN SCM_ITEM_CLASS_M C(NOLOCK)'+char(10)
  SET @v_dSql += '                    ON     A.ITEM_CLASS = C.CLASS_ID'+char(10)
  SET @v_dSql += '                    AND    C.USE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                    INNER JOIN CTE_NODE D'+char(10)
  SET @v_dSql += '                    ON     A.COMPANY_ID = D.COMPANY_ID'+char(10)
  SET @v_dSql += '                    AND    A.DIVISION_ID = D.DIVISION_ID'+char(10)
  SET @v_dSql += '                    AND    A.SITE_ID = D.SITE_ID'+char(10)
  SET @v_dSql += '                    AND    A.ITEM_ID = D.ROOT'+char(10)
  SET @v_dSql += '                    WHERE  A.ACTIVE_FLAG = ''Y'' AND A.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '                    AND    B.OPERATION_SEQ=1'+char(10)
  SET @v_dSql += '                    */'+char(10)
  SET @v_dSql += '            ) A, SCM_ITEM_M B'+char(10)
  SET @v_dSql += '            WHERE  A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += '            AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '            AND    A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += '            AND    A.MODEL_ID = B.ITEM_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --SET @v_dSql += '
  --{
  --          	  var sql="";
  --          	  var sDiv = $data.DIVISION_LT;
  --
  --          	  if(sDiv!="" && sDiv!=null) {
  --          	    sql+="AND    A.DIVISION_ID IN (" + sDiv + ") \r\n";
  --          	  }
  --
  --          	  sql;
  --          	}

  --'
  SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND    A.SITE_ID=#SITE_ID#
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      GROUP BY COMPANY_ID,DIVISION_ID,SITE_ID,MODEL_ID,RNUM'+char(10)
  SET @v_dSql += '      ORDER BY COMPANY_ID,DIVISION_ID,SITE_ID,MODEL_ID,RNUM'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --		var param = $data.param;
  --
  --			$data.querySet1 = $jdbc.queryList("FP02510","find_FP02510",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP02510_FIND_FP02510',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP02510_FIND_FP02510',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
