CREATE PROCEDURE [dbo].[PR_UI_XPCOMMON_AMEND_UPDATE_WPPCOPY_BYCELL]
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
/** 프로그램 ID   : PR_UI_XPCOMMON_AMEND_UPDATE_WPPCOPY_BYCELL                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMON_AMEND_UPDATE_WPPCOPY_BYCELL                                                                          **/
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
/** 2021-04-22     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_XPCOMMON_AMEND_UPDATE_WPPCOPY_BYCELL
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_XPCOMMON_AMEND_UPDATE_WPPCOPY_BYCELL'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_fp_site_id nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_fp_site_id nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

    DECLARE @p_IN_QTY nvarchar(max) = ''
  DECLARE @p_OUT_QTY nvarchar(max) = ''
  DECLARE @p_CELL_IN_QTY nvarchar(max) = ''
  DECLARE @p_CELL_OUT_QTY nvarchar(max) = ''
  DECLARE @p_SQL_LIST nvarchar(max) = ''
  DECLARE @p_xxx nvarchar(max) = ''

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START

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
    END ELSE IF @tmp_column = 'FP_SITE_ID' BEGIN
      SET @p_fp_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);

		    END ELSE IF @tmp_column = 'IN_QTY' BEGIN
      SET @p_IN_QTY =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OUT_QTY' BEGIN
      SET @p_OUT_QTY =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CELL_IN_QTY' BEGIN
      SET @p_CELL_IN_QTY =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CELL_OUT_QTY' BEGIN
      SET @p_CELL_OUT_QTY =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SQL_LIST' BEGIN
      SET @p_SQL_LIST =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_fp_site_id ='''' + @p_fp_site_id + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''



  -- xpcommon_Amend update_WPPCopy_byCell  
  SET @v_dSql = ''
  SET @v_dSql += '      BEGIN'+char(10)
  SET @v_dSql += '    		UPDATE FP_AMEND_PLAN_CELL_H SET'+char(10)
  SET @v_dSql += '    		       FP_AMEND_PLAN_CELL_H.' + @p_IN_QTY +' = IN_QTY'+char(10)
  SET @v_dSql += '    		     , FP_AMEND_PLAN_CELL_H.' + @p_OUT_QTY +' = OUT_QTY'+char(10)
  SET @v_dSql += '    		     , FP_AMEND_PLAN_CELL_H.' + @p_CELL_IN_QTY +' = CELL_IN_QTY'+char(10)
  SET @v_dSql += '    		     , FP_AMEND_PLAN_CELL_H.' + @p_CELL_OUT_QTY +' = CELL_OUT_QTY'+char(10)
  SET @v_dSql += '    		     , FP_AMEND_PLAN_CELL_H.UPDATE_ID ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '    		     , FP_AMEND_PLAN_CELL_H.UPDATE_TIME = dbo.FN_SITE_TIME('+char(10)
  SET @v_dSql += '' + @v_fp_site_id+''+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += '        FROM   FP_AMEND_PLAN_CELL_H A'+char(10)
  SET @v_dSql += '        INNER JOIN ('+char(10)
  SET @v_dSql += '          ' + @p_SQL_LIST +''+char(10)
  SET @v_dSql += '    		) B'+char(10)
  SET @v_dSql += '        ON  A.INSTANCE_ID     = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '    		AND A.FP_PLAN_ID      = B.FP_PLAN_ID'+char(10)
  SET @v_dSql += '    		AND A.COMPANY_ID      = B.COMPANY_ID'+char(10)
  SET @v_dSql += '    		AND A.DIVISION_ID     = B.DIVISION_ID'+char(10)
  SET @v_dSql += '    		AND A.SITE_ID         = B.SITE_ID'+char(10)
  SET @v_dSql += '    		AND A.PLANT_ID        = B.PLANT_ID'+char(10)
  SET @v_dSql += '    		AND A.FACTORY_ID      = B.FACTORY_ID'+char(10)
  SET @v_dSql += '    		AND A.OPERATION_ID    = B.OPERATION_ID'+char(10)
  SET @v_dSql += '    		AND A.LINE_ID         = B.LINE_ID'+char(10)
  SET @v_dSql += '    		AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '    		AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '    		AND A.MARKET          = B.MARKET'+char(10)
  SET @v_dSql += '    		AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '    		AND A.ITEM_ID         = B.ITEM_ID'+char(10)
  SET @v_dSql += '    		AND A.PLM_EC_NO       = B.PLM_EC_NO'+char(10) -- version 컬럼 추가... 20230920
SET @v_dSql += '    		AND A.VERSION         = B.VERSION'+char(10)
  SET @v_dSql += '    		WHERE CONVERT(VARCHAR,PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '        ;'+char(10)
  SET @v_dSql += '        INSERT INTO HIS_AMEND_PLAN_CELL_R ('+char(10)
  SET @v_dSql += '               INSTANCE_ID, FP_PLAN_ID'+char(10)
  SET @v_dSql += '              ,COMPANY_ID'+char(10)
  SET @v_dSql += '              ,DIVISION_ID'+char(10)
  SET @v_dSql += '              ,CATEGORY_ID'+char(10)
  SET @v_dSql += '              ,SITE_ID, PLANT_ID'+char(10)
  SET @v_dSql += '              ,ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION'+char(10)
  SET @v_dSql += '              ,PRODUCTION_TYPE, MARKET'+char(10)
  SET @v_dSql += '              ,LINE_ID, ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '              ,PLAN_DATE'+char(10)
  SET @v_dSql += '              ,TOP_ITEM_ID, ITEM_TYPE'+char(10)
  SET @v_dSql += '              ,IN_QTY, OUT_QTY'+char(10)
  SET @v_dSql += '              ,WPP_OUT_QTY, MPP_OUT_QTY'+char(10)
  SET @v_dSql += '              ,INSERT_ID, INSERT_TIME'+char(10)
  SET @v_dSql += '              ,UPDATE_ID, UPDATE_TIME'+char(10)
  SET @v_dSql += '              ,JOB_USER_ID, JOB_TIME, JOB_TYPE'+char(10)
  SET @v_dSql += '              ,PLM_EC_NO'+char(10) -- version 컬럼 추가... 20230920
  SET @v_dSql += '              ,VERSION'+char(10)
  SET @v_dSql += '        )'+char(10)
  SET @v_dSql += '        SELECT A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '              ,A.COMPANY_ID'+char(10)
  SET @v_dSql += '              ,A.DIVISION_ID'+char(10)
  SET @v_dSql += '              ,A.CATEGORY_ID'+char(10)
  SET @v_dSql += '              ,A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '              ,A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '              ,UPPER(A.PRODUCTION_TYPE) AS PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '              ,A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '              ,A.PLAN_DATE'+char(10)
  SET @v_dSql += '              ,A.TOP_ITEM_ID, A.ITEM_TYPE'+char(10)
  SET @v_dSql += '              ,A.IN_QTY, A.OUT_QTY'+char(10)
  SET @v_dSql += '              ,A.WPP_OUT_QTY, A.MPP_OUT_QTY'+char(10)
  SET @v_dSql += '              ,A.INSERT_ID, A.INSERT_TIME'+char(10)
  SET @v_dSql += '              ,A.UPDATE_ID, A.UPDATE_TIME'+char(10)
  SET @v_dSql += '              ,'+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += ' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''WPP_COPY'' AS JOB_TYPE'+char(10)
  SET @v_dSql += '              ,A.PLM_EC_NO'+char(10) -- version 컬럼 추가... 20230920
  SET @v_dSql += '              ,A.VERSION'+char(10)
  SET @v_dSql += '        FROM   FP_AMEND_PLAN_CELL_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        INNER JOIN ('+char(10)
  SET @v_dSql += '          ' + @p_SQL_LIST +''+char(10)
  SET @v_dSql += '    		) B'+char(10)
  SET @v_dSql += '        ON  A.INSTANCE_ID     = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '    		AND A.FP_PLAN_ID      = B.FP_PLAN_ID'+char(10)
  SET @v_dSql += '    		AND A.COMPANY_ID      = B.COMPANY_ID'+char(10)
  SET @v_dSql += '    		AND A.DIVISION_ID     = B.DIVISION_ID'+char(10)
  SET @v_dSql += '    		AND A.SITE_ID         = B.SITE_ID'+char(10)
  SET @v_dSql += '    		AND A.PLANT_ID        = B.PLANT_ID'+char(10)
  SET @v_dSql += '    		AND A.FACTORY_ID      = B.FACTORY_ID'+char(10)
  SET @v_dSql += '    		AND A.OPERATION_ID    = B.OPERATION_ID'+char(10)
  SET @v_dSql += '    		AND A.LINE_ID         = B.LINE_ID'+char(10)
  SET @v_dSql += '    		AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '    		AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '    		AND A.MARKET          = B.MARKET'+char(10)
  SET @v_dSql += '    		AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '    		AND A.ITEM_ID         = B.ITEM_ID'+char(10)
  SET @v_dSql += '    		AND A.PLM_EC_NO       = B.PLM_EC_NO'+char(10) -- version 컬럼 추가... 20230920
  SET @v_dSql += '    		AND A.VERSION         = B.VERSION'+char(10)
  SET @v_dSql += '    		WHERE CONVERT(VARCHAR,PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '        ;'+char(10)
  SET @v_dSql += '      END;'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --          $data.querySet1 = $jdbc.queryList("xpcommon_Amend","update_WPPCopy_byCell",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_XPCOMMON_AMEND_UPDATE_WPPCOPY_BYCELL',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_XPCOMMON_AMEND_UPDATE_WPPCOPY_BYCELL',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
