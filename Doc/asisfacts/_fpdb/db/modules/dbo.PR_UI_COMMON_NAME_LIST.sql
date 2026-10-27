CREATE PROCEDURE [dbo].[PR_UI_COMMON_NAME_LIST]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),

  @p__non_auth nvarchar(max) = '',
  @p__save_auth nvarchar(max) = '',
  @p_name_type nvarchar(max) = '',
  @p_col_count nvarchar(max) = '',
  @p_head_list nvarchar(max) = '',
  @p_body_line0 nvarchar(max) = '',
  @p_body_line1 nvarchar(max) = '',
  @p_body_line2 nvarchar(max) = '',
  @p_body_line3 nvarchar(max) = '',
  @p_body_line4 nvarchar(max) = '',
  @p_body_line5 nvarchar(max) = '',
  @p_body_line6 nvarchar(max) = '',
  @p_body_line7 nvarchar(max) = '',
  @p_body_line8 nvarchar(max) = '',
  @p_body_line9 nvarchar(max) = '',

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_COMMON_NAME_LIST                                                            **/
/** 프로그램 명   : Procedure PR_UI_COMMON_NAME_LIST                                                                          **/
/** 설 명         : NAME LIST POPUP의 데이터를 가져온다                                                                          **/
/** Version       : 1.0.0(Auto)                                                                     **/
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
/** 2021-02-03     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  p_col_count는 제공된 검색 조건의 갯수
  p_head_list는 검색 조건의 각 컬럼명값이다. 각 컬럼 혹은 검색조건은 ^ 문자로 구분한다.
  p_body_line ~ p_body_line4는 10개의 컬럼 데이터 값이다. 각각의 컬럼데이터는 5000자로 구성하며, 10개 즉 최대 50000자를 지원한다. (클라이언트에서 ^로 구분된 50000자를 제공한다)
  ^ escape 문자로 %EA를 사용하므로 쪼갠 후에 %EA를 에 ^^를 ^로 변경해야 한다.
  EXEC PR_UI_COMMON_NAME_LIST
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_COMMON_NAME_LIST'
  DECLARE @v__non_auth nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v__save_auth nvarchar(max)
  DECLARE @v_vody_line nvarchar(max)
  DECLARE @v_col_count INTEGER = 0


  SET @v__non_auth ='''' + @p__non_auth + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v__save_auth ='''' + @p__save_auth + ''''

  SET @v_vody_line = @p_body_line0
  SET @v_vody_line += @p_body_line1
  SET @v_vody_line += @p_body_line2
  SET @v_vody_line += @p_body_line3
  SET @v_vody_line += @p_body_line4
  SET @v_vody_line += @p_body_line5
  SET @v_vody_line += @p_body_line6
  SET @v_vody_line += @p_body_line7
  SET @v_vody_line += @p_body_line8
  SET @v_vody_line += @p_body_line9

  	DECLARE @col_name            NVARCHAR(max)
	DECLARE @col_value            NVARCHAR(max)

	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @max_loop_cnt_validate INTEGER = 0
	SET @v_delimiter            = '^'  -- 데이터 구분자

	--- 검증
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_head_list, @v_delimiter) -- 프로시저 LOOP 길이를 판단  
	SET @max_loop_cnt_validate = [dbo].[SCM_ARR_SPL_CNT](@v_vody_line, @v_delimiter) -- 실제 들어온 값의 길이를 판단
	
	SET @v_col_count = TRY_CONVERT(int, @p_col_count)
	IF @v_col_count= NULL BEGIN
		SET @v_col_count = 0
	END

	IF @max_loop_cnt <> @max_loop_cnt_validate BEGIN
		SET @v_col_count = 0
	END ELSE BEGIN
		IF @v_col_count <> @max_loop_cnt BEGIN
			SET @v_col_count = 0
		END
	END

	DECLARE @t_instance_lt          NVARCHAR(max)=''
	DECLARE @t_division_lt          NVARCHAR(max)=''
	DECLARE @t_company_lt           NVARCHAR(max)=''
	DECLARE @t_site_lt				NVARCHAR(max)=''
	DECLARE @t_name_like			NVARCHAR(max)=''


	--if @v_col_count = 0 BEGIN
	--
	--	print('errr')
    --
	--END ELSE
	BEGIN
		SET @v_dSql = ''
		IF @p_name_type= 'NICKNAME' BEGIN

		--print @max_loop_cnt
		--print @mst_loop_cnt
			
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt +=1

				SET @col_name = [dbo].[SCM_ARR_SPL_VAL]( @p_head_list,@v_delimiter, @mst_loop_cnt)
				SET @col_value =  [dbo].[SCM_ARR_SPL_VAL]( @v_vody_line,@v_delimiter, @mst_loop_cnt)

				IF RTRIM(LTRIM(UPPER(@col_name))) = 'DIVISION_LT' BEGIN
					SET @t_division_lt = REPLACE(@col_value,'%EA','^')
				END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'SITE_LT' BEGIN
					SET @t_site_lt = REPLACE(@col_value,'%EA','^')
				END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'COMPANY_LT' BEGIN
					SET @t_company_lt = REPLACE(@col_value,'%EA','^')
				END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'NICK_NAME_LIKE' BEGIN
					SET @t_name_like = REPLACE(@col_value,'%EA','^')
				END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'INSTANCE_LT' 
							OR RTRIM(LTRIM(UPPER(@col_name))) = 'MASTER_LT' 
							OR RTRIM(LTRIM(UPPER(@col_name))) = 'MASTER_ID' 
							OR RTRIM(LTRIM(UPPER(@col_name))) = 'INSTANCE_ID' BEGIN
					SET @t_instance_lt = REPLACE(@col_value,'%EA','^')
				END 
				
			END

			SET @v_dSql += '        select distinct'+char(10)
			SET @v_dSql += '             '''' as CHK,'+char(10)
			SET @v_dSql += '             A.COMPANY_ID as COMPANY,'+char(10)
			SET @v_dSql += '			 A.DIVISION_ID as DIVISION,'+char(10)
			SET @v_dSql += '			 A.SITE_ID as SITE,'+char(10)
			--SET @v_dSql += '			 A.ITEM_ID as ITEM,'+char(10) -- item 조건 제거.. 20230126
			SET @v_dSql += '			 A.NICK_NAME as NICK_NAME,'+char(10)       
			SET @v_dSql += '			 A.NICK_NAME as NAME'+char(10)       
			SET @v_dSql += '      from   SCM_ITEM_M as A(NOLOCK)'+char(10)
			SET @v_dSql += '	  where isnull(A.nick_name,'''') <> '''''+char(10)
			SET @v_dSql += '		AND EXISTS (											' + char(10)
			SET @v_dSql += '			SELECT	DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID	' + char(10)
			SET @v_dSql += '			FROM	FP_INSTANCE_OPERATION_V V					' + char(10)
			SET @v_dSql += '			WHERE	1=1											' + char(10)
			SET @v_dSql += '			AND		A.COMPANY_ID	= V.COMPANY_ID				' + char(10)
			SET @v_dSql += '			AND		A.DIVISION_ID	= V.DIVISION_ID				' + char(10)
			SET @v_dSql += '			AND		A.SITE_ID		= V.SITE_ID					' + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('V.INSTANCE_ID' , 'EQ', @t_instance_lt)) + char(10); 
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('V.COMPANY_ID' , 'EQ', @t_company_lt)) + char(10); 
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('V.DIVISION_ID' , 'EQ', @t_division_lt)) + char(10); 
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('V.SITE_ID' , 'EQ', @t_site_lt)) + char(10);
			SET @v_dSql += '		)														' + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @t_company_lt)) + char(10); 
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @t_division_lt)) + char(10); 
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @t_site_lt)) + char(10);
			IF ISNULL(@t_name_like,'') <> '' BEGIN
				SET @v_dSql += ' AND A.NICK_NAME LIKE '''+ @t_name_like + '%''' + char(10);
			END

			SET @v_dSql += '      ORDER BY COMPANY, DIVISION_ID, SITE_ID--, ITEM_ID '+char(10)
		
		END 
		ELSE IF @p_name_type= 'PARAM_TEST' 
			BEGIN



	DECLARE @AMEND_INSTANCE          NVARCHAR(max)='' --END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'AMEND_INSTANCE' BEGIN		SET @AMEND_INSTANCE = REPLACE(@col_value,'%EA','^')
   DECLARE @PLAN_DATE          NVARCHAR(max)='' --END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PLAN_DATE' BEGIN		SET @PLAN_DATE = REPLACE(@col_value,'%EA','^')
	DECLARE @AMEND_FLAG           NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'AMEND_FLAG' BEGIN		SET @AMEND_FLAG = REPLACE(@col_value,'%EA','^')
	DECLARE @ALL_LINE           NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'ALL_LINE' BEGIN		SET @ALL_LINE = REPLACE(@col_value,'%EA','^')
	DECLARE @AMEND_MAIN_FLAG           NVARCHAR(max)='' --END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'AMEND_MAIN_FLAG' BEGIN		SET @AMEND_MAIN_FLAG = REPLACE(@col_value,'%EA','^')
	DECLARE @USER_ID           NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'USER_ID' BEGIN		SET @USER_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @INSTANCE_ID           NVARCHAR(max)='' --END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'INSTANCE_ID' BEGIN		SET @INSTANCE_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @USE_WOW_STATUS           NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'USE_WOW_STATUS' BEGIN		SET @USE_WOW_STATUS = REPLACE(@col_value,'%EA','^')
	DECLARE @CONFIRM_AREA           NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'CONFIRM_AREA' BEGIN		SET @CONFIRM_AREA = REPLACE(@col_value,'%EA','^')
	DECLARE @IS_SAME_PLAN           NVARCHAR(max)='' --END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'IS_SAME_PLAN' BEGIN		SET @IS_SAME_PLAN = REPLACE(@col_value,'%EA','^')
	DECLARE @MASTER_ID           NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'MASTER_ID' BEGIN		SET @MASTER_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @BUCKET_FROM				NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'BUCKET_FROM' BEGIN		SET @BUCKET_FROM = REPLACE(@col_value,'%EA','^')
	DECLARE @BUCKET_TO				NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'BUCKET_TO' BEGIN		SET @BUCKET_TO = REPLACE(@col_value,'%EA','^')
	DECLARE @PLAN_ID				NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PLAN_ID' BEGIN		SET @PLAN_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @PLAN_TYPE				NVARCHAR(max)='' --END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PLAN_TYPE' BEGIN		SET @PLAN_TYPE = REPLACE(@col_value,'%EA','^')
	DECLARE @BASIS_START_TIME				NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'BASIS_START_TIME' BEGIN		SET @BASIS_START_TIME = REPLACE(@col_value,'%EA','^')
	DECLARE @DIVISION_ID				NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'DIVISION_ID' BEGIN		SET @DIVISION_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @LINE_ID				NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'LINE_ID' BEGIN		SET @LINE_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @PLANT_ID				NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PLANT_ID' BEGIN		SET @PLANT_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @FACTORY_ID			NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'FACTORY_ID' BEGIN		SET @FACTORY_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @OPERATION_ID			NVARCHAR(max)='' --END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'OPERATION_ID' BEGIN		SET @OPERATION_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @SITE_ID			NVARCHAR(max)=''--END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'SITE_ID' BEGIN		SET @SITE_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @PRODTYPE_ID			NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PRODTYPE_ID' BEGIN		SET @PRODTYPE_ID = REPLACE(@col_value,'%EA','^')
	DECLARE @NICK_NAME			NVARCHAR(max)='' --END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'NICK_NAME' BEGIN		SET @NICK_NAME = REPLACE(@col_value,'%EA','^')
	DECLARE @NICK_NAME_LIKE			NVARCHAR(max)=''--END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'NICK_NAME_LIKE' BEGIN		SET @NICK_NAME_LIKE = REPLACE(@col_value,'%EA','^')
	DECLARE @NICK_NAME_LT			NVARCHAR(max)=''-- END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'NICK_NAME_LT' BEGIN		SET @NICK_NAME_LT = REPLACE(@col_value,'%EA','^')
			--print @max_loop_cnt
			--print @mst_loop_cnt
			
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt +=1

					SET @col_name = [dbo].[SCM_ARR_SPL_VAL]( @p_head_list,@v_delimiter, @mst_loop_cnt)
					SET @col_value =  [dbo].[SCM_ARR_SPL_VAL]( @v_vody_line,@v_delimiter, @mst_loop_cnt)

					IF RTRIM(LTRIM(UPPER(@col_name))) = 'DIVISION_LT' BEGIN
						SET @t_division_lt = REPLACE(@col_value,'%EA','^')
END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'AMEND_INSTANCE' BEGIN		SET @AMEND_INSTANCE = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PLAN_DATE' BEGIN		SET @PLAN_DATE = REPLACE(@col_value,'%EA','^')
END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'AMEND_FLAG' BEGIN		SET @AMEND_FLAG = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'ALL_LINE' BEGIN		SET @ALL_LINE = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'AMEND_MAIN_FLAG' BEGIN		SET @AMEND_MAIN_FLAG = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'USER_ID' BEGIN		SET @USER_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'INSTANCE_ID' BEGIN		SET @INSTANCE_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'USE_WOW_STATUS' BEGIN		SET @USE_WOW_STATUS = REPLACE(@col_value,'%EA','^')
END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'CONFIRM_AREA' BEGIN		SET @CONFIRM_AREA = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'IS_SAME_PLAN' BEGIN		SET @IS_SAME_PLAN = REPLACE(@col_value,'%EA','^')
END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'MASTER_ID' BEGIN		SET @MASTER_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'BUCKET_FROM' BEGIN		SET @BUCKET_FROM = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'BUCKET_TO' BEGIN		SET @BUCKET_TO = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PLAN_ID' BEGIN		SET @PLAN_ID = REPLACE(@col_value,'%EA','^')
END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PLAN_TYPE' BEGIN		SET @PLAN_TYPE = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'BASIS_START_TIME' BEGIN		SET @BASIS_START_TIME = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'DIVISION_ID' BEGIN		SET @DIVISION_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'LINE_ID' BEGIN		SET @LINE_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PLANT_ID' BEGIN		SET @PLANT_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'FACTORY_ID' BEGIN		SET @FACTORY_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'OPERATION_ID' BEGIN		SET @OPERATION_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'SITE_ID' BEGIN		SET @SITE_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'PRODTYPE_ID' BEGIN		SET @PRODTYPE_ID = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'NICK_NAME' BEGIN		SET @NICK_NAME = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'NICK_NAME_LIKE' BEGIN		SET @NICK_NAME_LIKE = REPLACE(@col_value,'%EA','^')
 END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'NICK_NAME_LT' BEGIN		SET @NICK_NAME_LT = REPLACE(@col_value,'%EA','^')
					--END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'SITE_LT' BEGIN
					--	SET @t_site_lt = REPLACE(@col_value,'%EA','^')
					--END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'COMPANY_LT' BEGIN
					--	SET @t_company_lt = REPLACE(@col_value,'%EA','^')
					--END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'ITEM_NAME_LIKE' BEGIN
					--	SET @t_name_like = REPLACE(@col_value,'%EA','^')
					END 
				
				END

				SET @v_dSql += 'AMEND_INSTANCE' + ' : ' + isnull(@AMEND_INSTANCE,'NONONONO') + CHAR(10)
				SET @v_dSql += 'PLAN_DATE' + ' : ' + isnull(@PLAN_DATE,'NONONONO') + CHAR(10)
				SET @v_dSql += 'AMEND_FLAG' + ' : ' + isnull(@AMEND_FLAG,'NONONONO') + CHAR(10)
				SET @v_dSql += 'ALL_LINE' + ' : ' + isnull(@ALL_LINE,'NONONONO') + CHAR(10)
				SET @v_dSql += 'AMEND_MAIN_FLAG' + ' : ' + isnull(@AMEND_MAIN_FLAG,'NONONONO') + CHAR(10)
				SET @v_dSql += 'USER_ID' + ' : ' + isnull(@USER_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'INSTANCE_ID' + ' : ' + isnull(@INSTANCE_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'USE_WOW_STATUS' + ' : ' + isnull(@USE_WOW_STATUS,'NONONONO') + CHAR(10)
				SET @v_dSql += 'CONFIRM_AREA' + ' : ' + isnull(@CONFIRM_AREA,'NONONONO') + CHAR(10)
				SET @v_dSql += 'IS_SAME_PLAN' + ' : ' + isnull(@IS_SAME_PLAN,'NONONONO') + CHAR(10)
				SET @v_dSql += 'MASTER_ID' + ' : ' + isnull(@MASTER_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'BUCKET_FROM' + ' : ' + isnull(@BUCKET_FROM,'NONONONO') + CHAR(10)
				SET @v_dSql += 'BUCKET_TO' + ' : ' + isnull(@BUCKET_TO,'NONONONO') + CHAR(10)
				SET @v_dSql += 'PLAN_ID' + ' : ' + isnull(@PLAN_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'PLAN_TYPE' + ' : ' + isnull(@PLAN_TYPE,'NONONONO') + CHAR(10)
				SET @v_dSql += 'BASIS_START_TIME' + ' : ' + isnull(@BASIS_START_TIME,'NONONONO') + CHAR(10)
				SET @v_dSql += 'DIVISION_ID' + ' : ' + isnull(@DIVISION_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'LINE_ID' + ' : ' + isnull(@LINE_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'PLANT_ID' + ' : ' + isnull(@PLANT_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'FACTORY_ID' + ' : ' + isnull(@FACTORY_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'OPERATION_ID' + ' : ' + isnull(@OPERATION_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'SITE_ID' + ' : ' + isnull(@SITE_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'PRODTYPE_ID' + ' : ' + isnull(@PRODTYPE_ID,'NONONONO') + CHAR(10)
				SET @v_dSql += 'NICK_NAME' + ' : ' + isnull(@NICK_NAME,'NONONONO') + CHAR(10)
				SET @v_dSql += 'NICK_NAME_LIKE' + ' : ' + isnull(@NICK_NAME_LIKE,'NONONONO') + CHAR(10)
				SET @v_dSql += 'NICK_NAME_LT' + ' : ' + isnull(@NICK_NAME_LT,'NONONONO') + CHAR(10)

				SET @v_dSql += '     '+char(10)
		SELECT @v_dSql as SQLSTR
		RETURN 1
			END

		
		ELSE IF @p_name_type= 'ITEM' 
			BEGIN

			--print @max_loop_cnt
			--print @mst_loop_cnt
			
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt +=1

					SET @col_name = [dbo].[SCM_ARR_SPL_VAL]( @p_head_list,@v_delimiter, @mst_loop_cnt)
					SET @col_value =  [dbo].[SCM_ARR_SPL_VAL]( @v_vody_line,@v_delimiter, @mst_loop_cnt)

					IF RTRIM(LTRIM(UPPER(@col_name))) = 'DIVISION_LT' BEGIN
						SET @t_division_lt = REPLACE(@col_value,'%EA','^')
					END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'SITE_LT' BEGIN
						SET @t_site_lt = REPLACE(@col_value,'%EA','^')
					END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'COMPANY_LT' BEGIN
						SET @t_company_lt = REPLACE(@col_value,'%EA','^')
					END ELSE IF RTRIM(LTRIM(UPPER(@col_name))) = 'ITEM_NAME_LIKE' BEGIN
						SET @t_name_like = REPLACE(@col_value,'%EA','^')
					END 
				
				END

				SET @v_dSql += '        select distinct'+char(10)
				SET @v_dSql += '             '''' as CHK,'+char(10)
				SET @v_dSql += '             A.COMPANY_ID as COMPANY,'+char(10)
				SET @v_dSql += '			 A.DIVISION_ID as DIVISION,'+char(10)
				SET @v_dSql += '			 A.SITE_ID as SITE,'+char(10)
				SET @v_dSql += '			 A.ITEM_ID as ITEM,'+char(10)
				SET @v_dSql += '			 A.ITEM_ID as NAME,'+char(10)
				SET @v_dSql += '			 A.NICK_NAME as NICK_NAME'+char(10)       
				SET @v_dSql += '      from   SCM_ITEM_M as A(NOLOCK)'+char(10)
				SET @v_dSql += '	  where isnull(A.nick_name,'''') <> '''''+char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @t_company_lt)) + char(10); 
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @t_division_lt)) + char(10); 
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @t_site_lt)) + char(10);
				IF ISNULL(@t_name_like,'') <> '' BEGIN
					SET @v_dSql += ' AND A.ITEM_ID LIKE '''+ @t_name_like + '%''' + char(10);
				END

				SET @v_dSql += '      ORDER BY COMPANY, DIVISION_ID, SITE_ID, ITEM_ID '+char(10)
		
			END

		ELSE IF @p_name_type = 'MODEL' BEGIN
			SET @v_dSql += ''+char(10)
		END

  	END

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
      exec PR_UI_SQL_LOG 'PR_UI_COMMON_NAME_LIST',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_COMMON_NAME_LIST',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
