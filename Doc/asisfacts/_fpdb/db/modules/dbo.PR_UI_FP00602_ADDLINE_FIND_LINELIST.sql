

CREATE PROCEDURE [dbo].[PR_UI_FP00602_ADDLINE_FIND_LINELIST]
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
/** 프로그램 ID   : PR_UI_FP00602_ADDLINE_FIND_LINELIST                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00602_ADDLINE_FIND_LINELIST                                                                          **/
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
/** 2021-04-05     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/** 2024-11-18     leejsthira2          PDS 2차 고도화 : version 로직 제거                    **/
/** 2025-02-04     leejsthira2          half line 의 경우, line assign 에 등록된 line 기준으로 별도로 출력 **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00602_ADDLINE_FIND_LINELIST
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00602_ADDLINE_FIND_LINELIST'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_date nvarchar(max) = ''
  DECLARE @p_confirm_area nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''
  DECLARE @p_production_type nvarchar(max) = ''
  DECLARE @p_market nvarchar(max) = ''
  DECLARE @p_4mcc_flag nvarchar(max) = '' -- 4MCC 용 생산구분 인지여부

  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_date nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_confirm_area nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0line_id nvarchar(max)
  DECLARE @opt_1line_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DATE' BEGIN
      SET @p_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CONFIRM_AREA' BEGIN
      SET @p_confirm_area =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'PRODUCTION_TYPE' BEGIN
		SET @p_production_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'MARKET' BEGIN
		SET @p_market =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END


  END
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  --SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_division_id = @p_division_id
  SET @v_site_id ='''' + @p_site_id + ''''
  --SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v_plant_id = @p_plant_id
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_date ='''' + @p_date + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_confirm_area ='''' + @p_confirm_area + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0line_id = ''
  END ELSE BEGIN
    SET @opt_0line_id = 'AND    A.LINE_ID LIKE ''%'' +  ' + @v_line_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1line_id = ''
  END ELSE BEGIN
    SET @opt_1line_id = 'AND    A.LINE_ID LIKE ''%'' +  ' + @v_line_id+' + ''%'''
  END

  -- 4MCC 구분 처리
  SET @p_4mcc_flag = ''

  /*
  SELECT @p_4mcc_flag = CASE WHEN (ISNULL(MAX(A.ATTRIBUTE6), 'N') = 'Y' AND ISNULL(MAX(A.ATTRIBUTE5), 'N') = 'Y') THEN 'Y' ELSE 'N' END
  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
  WHERE  A.LOOKUP_TYPE_CODE ='DIVISION_DEMAND_TYPE'
  AND    A.ACTIVE_FLAG = 'Y'
  AND    A.SEGMENT1    = @p_division_id
  AND    A.ATTRIBUTE2  = @p_production_type
  AND    A.ATTRIBUTE6  = 'Y'
  
  
	SELECT	@p_4mcc_flag = CASE WHEN ISNULL(MAX(SS.PRODUCTION_TYPE),'N') = @p_production_type THEN 'Y' ELSE 'N' END
	FROM	FP_INSTANCE_INFO_V IV WITH(NOLOCK)
			, SCM_SYS_LOOKUP_VALUE SV WITH(NOLOCK)
			, (
				SELECT DISTINCT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS PRODUCTION_TYPE
				FROM   SCM_SYS_LOOKUP_VALUE SS WITH(NOLOCK)
				WHERE 1=1
				AND SS.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
				AND SS.ACTIVE_FLAG = 'Y'
				--AND SS.ATTRIBUTE3 = 'N' -- SCP TARGET FLAG
				AND SS.ATTRIBUTE5 = 'Y' -- PDA TARGET FLAG
				--AND SS.ATTRIBUTE6 = 'Y' -- VERSION ONLY
				AND    SS.SEGMENT1    = @p_division_id
  				AND    SS.SEGMENT2  = @p_production_type
			) SS
	WHERE	1=1
	AND		SV.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
	AND		SV.ACTIVE_FLAG	= 'Y'
	AND		SV.SEGMENT1		= IV.INSTANCE_ID
	AND		IV.INSTANCE_ID	= @p_instance_id
	AND		IV.DIVISION_ID	=  SS.DIVISION_ID
	*/
  
  -- PDS 2차 고도화 : line 팝업에서 version 로직 제거
  set @p_4mcc_flag = 'N'

  -- FP00602_addLine find_LineList  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT DISTINCT'+char(10)
  SET @v_dSql += '             A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '           , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '           , ISNULL(B.LINE_NAME,''-'') AS LINE_NAME'+char(10)
  SET @v_dSql += '           , B.LOCATION'+char(10)
  SET @v_dSql += '           , ''' + @p_production_type + ''' AS PRODUCTION_TYPE ' + char(10) -- 4MCC 버전 추가... 20230911
  -- 4MCC 버전 추가... 20230911
  IF @p_4mcc_flag = 'Y' BEGIN
	SET @v_dSql += '           , ISNULL(E.VERSION,''-'') AS VERSION ' + char(10)
  END ELSE BEGIN
	SET @v_dSql += '           , ''-'' AS VERSION ' + char(10)
  END

  SET @v_dSql += '      FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      INNER JOIN SCM_LINE_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.PLANT_ID       = B.PLANT_ID'+char(10)
  SET @v_dSql += '      AND    A.FACTORY_ID     = B.FACTORY_ID'+char(10)
  SET @v_dSql += '      AND    A.OPERATION_ID   = B.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND    A.LINE_ID        = B.LINE_ID'+char(10)
  SET @v_dSql += '      AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE'+char(10)

  IF @p_CONFIRM_AREA = 'PLAN GROUP' BEGIN
    SET @v_dSql += 'INNER JOIN '+char(10)
  END ELSE BEGIN
    SET @v_dSql += 'LEFT OUTER JOIN '+char(10)
  END
  
  SET @v_dSql += '      ('+char(10)
  SET @v_dSql += '          SELECT A.SEGMENT2 AS PLAN_GROUP_ID'+char(10)
  SET @v_dSql += '          FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'''+char(10)
  SET @v_dSql += '          AND    A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '          and    A.SEGMENT1    ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '      ) C'+char(10)
  SET @v_dSql += '      ON     B.MODEL_TYPE     = C.PLAN_GROUP_ID'+char(10)
  SET @v_dSql += '      INNER JOIN ('+char(10)
  SET @v_dSql += '          SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID'+char(10)
  SET @v_dSql += '          FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          WHERE  A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '          AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '          AND    A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  --SET @v_dSql += '          AND 	 B.DIVISION_ID  ='+char(10)
  --SET @v_dSql += '' + @v_division_id+''+char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.DIVISION_ID' , 'EQ', @v_division_id)) + char(10)
  SET @v_dSql += '          AND    B.SITE_ID      ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '          AND    A.AMEND_FLAG   = ''Y'''+char(10)
  SET @v_dSql += '          AND    B.ACTIVE_FLAG  = ''Y'''+char(10)
  SET @v_dSql += '      ) D'+char(10)
  SET @v_dSql += '      ON     A.COMPANY_ID     = D.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID    = D.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID        = D.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.OPERATION_ID   = D.OPERATION_ID'+char(10)
  
  -- 4MCC 버전 추가... 20230911
  -- 4MCC 타입일 경우 필수 조건으로 inner join 처리
  IF @p_4mcc_flag = 'Y' BEGIN
	  SET @v_dSql += '      INNER JOIN ( '+char(10)
	  SET @v_dSql += '      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID '+char(10)
	  SET @v_dSql += '      		 , B.OPERATION_ID '+char(10)
	  SET @v_dSql += '      		 , A.VERSION '+char(10)
	  SET @v_dSql += '      	FROM ( '+char(10)-- 완성 공정 라인
	  SET @v_dSql += '      		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID '+char(10)
	  SET @v_dSql += '      			 , A.OPERATION_ID, A.LINE_ID '+char(10)
	  SET @v_dSql += '      			 , A.PLM_EC_NO, A.VERSION '+char(10)
	  SET @v_dSql += '      		FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK) '+char(10)
	  SET @v_dSql += '      		, ( '+char(10)
	  SET @v_dSql += '      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID '+char(10)
	  SET @v_dSql += '      			FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) '+char(10)
	  SET @v_dSql += '      			WHERE  A.INSTANCE_ID  = ''' + @p_instance_id + '''  '+char(10) 
	  SET @v_dSql += '      			AND    A.OPERATION_ID IN (''A3000'',''A9000'') '+char(10)
	  SET @v_dSql += '      			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID '+char(10)
	  SET @v_dSql += '      		) B '+char(10)
	  SET @v_dSql += '      		WHERE  1=1 '+char(10)
	  SET @v_dSql += '      		AND	   A.ACTIVE_FLAG	= ''Y'''      +char(10) --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
	  SET @v_dSql += '      		AND    A.COMPANY_ID   = B.COMPANY_ID '+char(10)
	  SET @v_dSql += '      		AND    A.DIVISION_ID  = B.DIVISION_ID '+char(10)
	  SET @v_dSql += '      		AND    A.SITE_ID      = B.SITE_ID '+char(10)
	  SET @v_dSql += '      		AND    A.PLANT_ID     = B.PLANT_ID '+char(10)
	  SET @v_dSql += '      		AND    A.FACTORY_ID   = B.FACTORY_ID '+char(10)
	  SET @v_dSql += '      		AND    A.OPERATION_ID = B.OPERATION_ID '+char(10)
	  SET @v_dSql += '      		AND    A.LINE_ID      = B.LINE_ID '+char(10) -- line 까지는 비교하지 않는다
	  --SET @v_dSql += '      		AND    A.DUE_DATE >= CONVERT(DATETIME,''' + @p_date + ''') '+char(10) 
	  SET @v_dSql += '      		AND    A.MFG_WEEK >= (SELECT (ISO_YYYYWW) FROM TH_UIS_CAL B WITH(NOLOCK) WHERE YYYYMMDD = ''' + @p_date + ''') '+char(10)
	  SET @v_dSql += '      		AND    A.OPERATION_ID IN (''A3000'',''A9000'') '+char(10)
	  SET @v_dSql += '      		AND    A.PRODUCTION_TYPE  = ''' + @p_production_type + ''' '+char(10)
	  SET @v_dSql += '      		AND    A.MARKET           = ''' + @p_market + ''' '+char(10)
	  SELECT @v_dSql += '      		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @v_division_id)) + char(10)
	  SET @v_dSql += '      		AND    A.SITE_ID           = ' + @v_site_id + ' '+char(10)
	  SET @v_dSql += '      		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID '+char(10)
	  SET @v_dSql += '      				, A.OPERATION_ID, A.LINE_ID '+char(10)
	  SET @v_dSql += '      				, A.PLM_EC_NO, A.VERSION '+char(10)
	  SET @v_dSql += '      	) A '+char(10)
	  SET @v_dSql += '      	LEFT OUTER JOIN ( '+char(10) -- 하위 공정 목록
	  SET @v_dSql += '      		SELECT A.OPERATION_ID '+char(10)
	  SET @v_dSql += '      		FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK) '+char(10)
	  SET @v_dSql += '      		WHERE  A.INSTANCE_ID  = ''' + @p_instance_id + ''' '+char(10)
	  SET @v_dSql += '      		AND    A.AMEND_FLAG   = ''Y'' '+char(10)
	  SET @v_dSql += '      		GROUP BY A.OPERATION_ID '+char(10)
	  SET @v_dSql += '      	) B '+char(10)
	  SET @v_dSql += '      	ON  1=1 '+char(10)
	  SET @v_dSql += '      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID '+char(10)
	  SET @v_dSql += '      		   , B.OPERATION_ID '+char(10)
	  SET @v_dSql += '      		   , A.VERSION '+char(10)
	  -- half line 의 경우, line assign 에 등록된 line 기준으로 별도로 출력... 20250204
	  SET @v_dSql += '      	UNION '+char(10)
	  SET @v_dSql += '      	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID , A.OPERATION_ID '+char(10)
	  SET @v_dSql += '      	     , c.version '+char(10)
	  SET @v_dSql += '      	FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) '+char(10)
	  SET @v_dSql += '      	INNER JOIN SCM_LINE_M B WITH(NOLOCK) '+char(10)
	  SET @v_dSql += '      	ON     A.COMPANY_ID     = B.COMPANY_ID '+char(10)
	  SET @v_dSql += '      	AND    A.DIVISION_ID    = B.DIVISION_ID '+char(10)
	  SET @v_dSql += '      	AND    A.SITE_ID        = B.SITE_ID '+char(10)
	  SET @v_dSql += '      	AND    A.PLANT_ID       = B.PLANT_ID '+char(10)
	  SET @v_dSql += '      	AND    A.FACTORY_ID     = B.FACTORY_ID '+char(10)
	  SET @v_dSql += '      	AND    A.OPERATION_ID   = B.OPERATION_ID '+char(10)
	  SET @v_dSql += '      	AND    A.LINE_ID        = B.LINE_ID '+char(10)
	  SET @v_dSql += '      	AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE '+char(10)
	  SET @v_dSql += '      	INNER JOIN ( '+char(10)
	  SET @v_dSql += '      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  '+char(10)
	  SET @v_dSql += '      	  			 , ''A7000'' AS OPERATION_ID, A.LINE_ID '+char(10)
	  SET @v_dSql += '      	  			 , A.PLM_EC_NO, A.VERSION '+char(10)
	  SET @v_dSql += '      			FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK) '+char(10)
	  SET @v_dSql += '      			, ( '+char(10)
	  SET @v_dSql += '      	  			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID '+char(10)
	  SET @v_dSql += '      	  			FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) '+char(10)
	  SET @v_dSql += '      	  			WHERE  A.INSTANCE_ID  = ''' + @p_instance_id + '''  '+char(10)
	  SET @v_dSql += '      	  			AND    A.OPERATION_ID IN (''A9000'') '+char(10)
	  SET @v_dSql += '      	  			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID '+char(10)
	  SET @v_dSql += '      			) B '+char(10)
	  SET @v_dSql += '      			WHERE  1=1 '+char(10)
      SET @v_dSql += '                	AND	   A.ACTIVE_FLAG	= ''Y'''         +char(10) --E20260316-000249 FP 계획 수립시 PDS Target 계획 반영 유무 기능 추가 건
	  SET @v_dSql += '      			AND    A.COMPANY_ID   = B.COMPANY_ID '+char(10)
	  SET @v_dSql += '      			AND    A.DIVISION_ID  = B.DIVISION_ID '+char(10)
	  SET @v_dSql += '      			AND    A.SITE_ID      = B.SITE_ID '+char(10)
	  SET @v_dSql += '      			AND    A.PLANT_ID     = B.PLANT_ID '+char(10)
	  SET @v_dSql += '      			AND    A.FACTORY_ID   = B.FACTORY_ID '+char(10)
	  SET @v_dSql += '      			AND    A.OPERATION_ID = B.OPERATION_ID '+char(10)
	  SET @v_dSql += '      			AND    A.LINE_ID      = B.LINE_ID '+char(10)
	  SET @v_dSql += '      			AND    A.MFG_WEEK >= (SELECT (ISO_YYYYWW) FROM TH_UIS_CAL B WITH(NOLOCK) WHERE YYYYMMDD = ''' + @p_date + ''') '+char(10)
	  SET @v_dSql += '      			AND    A.OPERATION_ID IN (''A9000'') '+char(10)
	  SET @v_dSql += '      			AND    A.PRODUCTION_TYPE  = ''' + @p_production_type + ''' '+char(10)
	  SET @v_dSql += '      			AND    A.MARKET           = ''' + @p_market + ''' '+char(10)
	  --SET @v_dSql += '      			AND    A.DIVISION_ID      = N'81_UC' '+char(10)
	  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('      			A.DIVISION_ID' , 'EQ', @v_division_id)) + char(10)
	  SET @v_dSql += '      			AND    A.SITE_ID          = ' + @v_site_id + ' '+char(10)
	  SET @v_dSql += '      			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID '+char(10)
	  SET @v_dSql += '      	  			   , A.LINE_ID, A.PLM_EC_NO, A.VERSION '+char(10)
	  SET @v_dSql += '      	) c '+char(10)
	  SET @v_dSql += '      	ON     A.COMPANY_ID     = C.COMPANY_ID '+char(10)
	  SET @v_dSql += '      	AND    A.DIVISION_ID    = C.DIVISION_ID '+char(10)
	  SET @v_dSql += '      	AND    A.SITE_ID        = C.SITE_ID '+char(10)
	  SET @v_dSql += '      	AND    A.PLANT_ID       = C.PLANT_ID '+char(10)
	  SET @v_dSql += '      	AND    A.FACTORY_ID     = C.FACTORY_ID '+char(10)
	  SET @v_dSql += '      	AND    A.OPERATION_ID   = C.OPERATION_ID '+char(10)
	  --SET @v_dSql += '      	AND    A.LINE_ID        = C.LINE_ID '+char(10)
	  SET @v_dSql += '      	WHERE  1=1 '+char(10)
	  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('      	A.DIVISION_ID' , 'EQ', @v_division_id)) + char(10)
	  SET @v_dSql += '      	AND    A.SITE_ID     = ' + @v_site_id + ' '+char(10)
	  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('      	A.PLANT_ID' , 'EQ', @v_plant_id)) + char(10)
	  SET @v_dSql += '      	AND    A.ACTIVE_FLAG = ''Y'' '+char(10)
	  SET @v_dSql += '      	AND    B.ACTIVE_FLAG = ''Y'' '+char(10)
	  SET @v_dSql += '      	AND    A.MONTH       = SUBSTRING(' + @v_date + ',1,6) '+char(10)
	  SET @v_dSql += '      	AND	   A.PRIORITY NOT IN (''0'',''9'') '+char(10)
	  SET @v_dSql += '      	AND    A.ITEM_ID     = ' + @v_item_id +char(10)
	  SET @v_dSql += '      	AND    A.OPERATION_ID = ''A7000'' '+char(10)
	  SET @v_dSql += '      	AND    A.ELECTRODE_TYPE = ''Half'' '+char(10)

	  SET @v_dSql += '      ) E '+char(10)
	  SET @v_dSql += '      ON  1=1 '+char(10)
	  SET @v_dSql += '      AND A.COMPANY_ID   = E.COMPANY_ID '+char(10)
	  SET @v_dSql += '      AND A.DIVISION_ID  = E.DIVISION_ID '+char(10)
	  SET @v_dSql += '      AND A.SITE_ID      = E.SITE_ID '+char(10)
	  SET @v_dSql += '      AND A.PLANT_ID     = E.PLANT_ID '+char(10)
	  SET @v_dSql += '      AND A.FACTORY_ID   = E.FACTORY_ID '+char(10)
	  SET @v_dSql += '      AND A.OPERATION_ID = E.OPERATION_ID '+char(10)
	  SET @v_dSql += '      AND A.LINE_ID      = E.LINE_ID '+char(10)

  END

  SET @v_dSql += '      WHERE  1=1'+char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @v_division_id)) + char(10)
  SET @v_dSql += '      AND    A.SITE_ID        ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  --SET @v_dSql += '      AND    A.PLANT_ID       ='+char(10)
  --SET @v_dSql += '' + @v_plant_id+''+char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @v_plant_id)) + char(10)
  SET @v_dSql += '      AND    A.ITEM_ID        ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += ' ' +@opt_0line_id +' '+''+char(10)--AND    A.LINE_ID LIKE '%' +  #LINE_ID# + '%'
  SET @v_dSql += '      AND    A.ACTIVE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '      AND    B.ACTIVE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '      AND    A.MONTH          = SUBSTRING('+char(10)
  SET @v_dSql += '' + @v_date+''+char(10)
  SET @v_dSql += ',1,6)'+char(10)
  SET @v_dSql += '      AND		 A.PRIORITY NOT IN (''0'',''9'')'+char(10)
  SET @v_dSql += '      AND    EXISTS ('+char(10)
  SET @v_dSql += '			        	SELECT 1'+char(10)
  SET @v_dSql += '			        	FROM   FP_USER_ROLE_INFO_V BB WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			        	WHERE  A.COMPANY_ID     = BB.COMPANY_ID'+char(10)
  SET @v_dSql += '			        	AND    A.DIVISION_ID    = BB.DIVISION_ID'+char(10)
  SET @v_dSql += '			        	AND    A.SITE_ID        = BB.SITE_ID'+char(10)
  SET @v_dSql += '			        	AND    A.PLANT_ID       = BB.PLANT_ID'+char(10)
  SET @v_dSql += '					    AND    A.FACTORY_ID     = BB.FACTORY_ID'+char(10)
  SET @v_dSql += '					    AND    A.OPERATION_ID   = BB.OPERATION_ID'+char(10)
  SET @v_dSql += '					    AND    A.LINE_ID        = BB.LINE_ID'+char(10)
  SET @v_dSql += '			        	AND    BB.USER_ID       ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '			        	AND	   BB.SAVE_FLAG	  = ''Y'''+char(10)
  SET @v_dSql += '				    )'+char(10)
  SET @v_dSql += '      ORDER BY A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, LINE_NAME, LOCATION, VERSION '+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        var param2 = $jdbc.queryList("FP00602_addLine","find_instanceType",param);
  --
  --        param.CONFIRM_AREA = param2[0].confirm_area;
  --
  --        $data.querySet1 = $jdbc.queryList("FP00602_addLine","find_LineList",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00602_ADDLINE_FIND_LINELIST',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00602_ADDLINE_FIND_LINELIST',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END

