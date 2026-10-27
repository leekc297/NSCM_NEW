CREATE PROCEDURE [dbo].[PR_UI_FP00180_SAVEALL_FP00180]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @p_demand_lot_size nvarchar(max) = '',
  @p_item_attribute nvarchar(max) = '',
  @p_setup_attribute nvarchar(max) = '',
  @p_form_attribute nvarchar(max) = '',
  @p_company_id nvarchar(max) = '',
  @p_division_id nvarchar(max) = '',
  @p_site_id nvarchar(max) = '',
  @p_item_id nvarchar(max) = '',

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00180_SAVEALL_FP00180                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00180_SAVEALL_FP00180                                                                          **/
/** 설 명         :                                                                           **/
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
/** 2021-02-08     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00180_SAVEALL_FP00180
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00180_SAVEALL_FP00180'
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_demand_lot_size nvarchar(max)
  DECLARE @v_item_attribute nvarchar(max)
  DECLARE @v_setup_attribute nvarchar(max)
  DECLARE @v_form_attribute nvarchar(max)
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)

    DECLARE @v_sys_flag nvarchar(max)
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @recv_active_flag       NVARCHAR(MAX)		

	SET @recv_active_flag       = @p_sys_flag;
	SET @v_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  


  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START

  --Optional Parameter Part END

  
  SET @v_user_id ='''' + @p_user_id + ''''

  			BEGIN TRY

  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN

  	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
		SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

		--SET @v_user_id			    = [dbo].[SCM_ARR_SPL_VAL]( @p_user_id			    ,@v_delimiter, @mst_loop_cnt);
		SET @v_sys_flag			    = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_flag			    ,@v_delimiter, @mst_loop_cnt);
		SET @v_demand_lot_size			    = [dbo].[SCM_ARR_SPL_VAL]( @p_demand_lot_size			    ,@v_delimiter, @mst_loop_cnt);
		SET @v_item_attribute			= [dbo].[SCM_ARR_SPL_VAL]( @p_item_attribute			    ,@v_delimiter, @mst_loop_cnt);
		SET @v_setup_attribute			    = [dbo].[SCM_ARR_SPL_VAL]( @p_setup_attribute			    ,@v_delimiter, @mst_loop_cnt);
		SET @v_form_attribute           = [dbo].[SCM_ARR_SPL_VAL]( @p_form_attribute            ,@v_delimiter, @mst_loop_cnt);
		SET @v_company_id          = [dbo].[SCM_ARR_SPL_VAL]( @p_company_id           ,@v_delimiter, @mst_loop_cnt);
		SET @v_division_id              = [dbo].[SCM_ARR_SPL_VAL]( @p_division_id               ,@v_delimiter, @mst_loop_cnt);
		SET @v_site_id             = [dbo].[SCM_ARR_SPL_VAL]( @p_site_id              ,@v_delimiter, @mst_loop_cnt);  
		SET @v_item_id           = [dbo].[SCM_ARR_SPL_VAL]( @p_item_id            ,@v_delimiter, @mst_loop_cnt);


		--SET @v_user_id ='''' + @p_user_id + ''''
		SET @v_demand_lot_size ='''' + @p_demand_lot_size + ''''
		SET @v_item_attribute ='''' + @p_item_attribute + ''''
		SET @v_setup_attribute ='''' + @p_setup_attribute + ''''
		SET @v_form_attribute ='''' + @p_form_attribute + ''''
		SET @v_company_id ='''' + @p_company_id + ''''
		SET @v_division_id ='''' + @p_division_id + ''''
		SET @v_site_id ='''' + @p_site_id + ''''
		SET @v_item_id ='''' + @p_item_id + ''''
	END

	  IF @v_sys_flag = 'M' BEGIN
		  -- FP00180 update_FP00180 updates list
		  SET @v_dSql = ''
		  SET @v_dSql += '  		BEGIN'+char(10)
		  SET @v_dSql += '  		  BEGIN TRAN'+char(10)
		  SET @v_dSql += '          UPDATE SCM_ITEM_M SET'+char(10)
		  SET @v_dSql += '                 UPDATE_ID 		    ='+char(10)
		  SET @v_dSql += '' + @v_user_id+''+char(10)
		  SET @v_dSql += '                ,UPDATE_TIME 	    = DBO.SYSDATE1()'+char(10)
		  SET @v_dSql += '                ,DEMAND_LOT_SIZE  ='+char(10)
		  SET @v_dSql += '' + @v_demand_lot_size+''+char(10)
		  SET @v_dSql += '                ,ITEM_ATTRIBUTE   ='+char(10)
		  SET @v_dSql += '' + @v_item_attribute+''+char(10)
		  SET @v_dSql += '                ,SETUP_ATTRIBUTE  ='+char(10)
		  SET @v_dSql += '' + @v_setup_attribute+''+char(10)
		  SET @v_dSql += '                ,FORM_ATTRIBUTE   ='+char(10)
		  SET @v_dSql += '' + @v_form_attribute+''+char(10)
		  SET @v_dSql += '          WHERE  COMPANY_ID	      ='+char(10)
		  SET @v_dSql += '' + @v_company_id+''+char(10)
		  SET @v_dSql += '          AND    DIVISION_ID	    ='+char(10)
		  SET @v_dSql += '' + @v_division_id+''+char(10)
		  SET @v_dSql += '          AND    SITE_ID			    ='+char(10)
		  SET @v_dSql += '' + @v_site_id+''+char(10)
		  SET @v_dSql += '          AND    ITEM_ID			    ='+char(10)
		  SET @v_dSql += '' + @v_item_id+''+char(10)
		  SET @v_dSql += '    			;'+char(10)
		  SET @v_dSql += '  			COMMIT;'+char(10)
		  SET @v_dSql += '        BEGIN TRAN'+char(10)
		  SET @v_dSql += '          INSERT INTO HIS_ITEM_M ('+char(10)
		  SET @v_dSql += '                 COMPANY_ID, DIVISION_ID, SITE_ID'+char(10)
		  SET @v_dSql += '                ,ITEM_ID, ITEM_NAME, NICK_NAME'+char(10)
		  SET @v_dSql += '                ,ITEM_TYPE'+char(10)
		  SET @v_dSql += '                ,ITEM_CLASS, ITEM_CLASS_NAME'+char(10)
		  SET @v_dSql += '                ,MATERIAL_CLASS, MATERIAL_CLASS_NAME'+char(10)
		  SET @v_dSql += '                ,ELECTRODE_TYPE, SIDE_TYPE, ITEM_GROUP_ID'+char(10)
		  SET @v_dSql += '                ,SETUP_GROUP_ID_1, SETUP_GROUP_ID_2, SETUP_GROUP_ID_3'+char(10)
		  SET @v_dSql += '                ,FLOW_ID'+char(10)
		  SET @v_dSql += '                ,ERP_EOL, SCP_EOL'+char(10)
		  SET @v_dSql += '                ,ITEM_UOM, SPEC, DEMAND_LOT_SIZE'+char(10)
		  SET @v_dSql += '                ,ITEM_ATTRIBUTE, SETUP_ATTRIBUTE'+char(10)
		  SET @v_dSql += '                ,OUTSOURCING_FACTORY'+char(10)
		  SET @v_dSql += '                ,FINITE_TERM, FINITE_TERM_UOM'+char(10)
		  SET @v_dSql += '                ,DESCRIPTION, ACTIVE_FLAG'+char(10)
		  SET @v_dSql += '                ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME'+char(10)
		  SET @v_dSql += '                ,JOB_USER_ID,JOB_TIME,JOB_TYPE'+char(10)
		  SET @v_dSql += '				        ,BATCH_RATIO_ID'+char(10)
		  SET @v_dSql += '				        ,FORM_ATTRIBUTE'+char(10)
		  SET @v_dSql += '          )'+char(10)
		  SET @v_dSql += '          SELECT COMPANY_ID, DIVISION_ID, SITE_ID'+char(10)
		  SET @v_dSql += '                ,ITEM_ID, ITEM_NAME, NICK_NAME'+char(10)
		  SET @v_dSql += '                ,ITEM_TYPE'+char(10)
		  SET @v_dSql += '                ,ITEM_CLASS, ITEM_CLASS_NAME'+char(10)
		  SET @v_dSql += '                ,MATERIAL_CLASS, MATERIAL_CLASS_NAME'+char(10)
		  SET @v_dSql += '                ,ELECTRODE_TYPE, SIDE_TYPE, ITEM_GROUP_ID'+char(10)
		  SET @v_dSql += '                ,SETUP_GROUP_ID_1, SETUP_GROUP_ID_2, SETUP_GROUP_ID_3'+char(10)
		  SET @v_dSql += '                ,FLOW_ID'+char(10)
		  SET @v_dSql += '                ,ERP_EOL, SCP_EOL'+char(10)
		  SET @v_dSql += '                ,ITEM_UOM, SPEC, DEMAND_LOT_SIZE'+char(10)
		  SET @v_dSql += '                ,ITEM_ATTRIBUTE, SETUP_ATTRIBUTE'+char(10)
		  SET @v_dSql += '                ,OUTSOURCING_FACTORY'+char(10)
		  SET @v_dSql += '                ,FINITE_TERM, FINITE_TERM_UOM'+char(10)
		  SET @v_dSql += '                ,DESCRIPTION, ACTIVE_FLAG'+char(10)
		  SET @v_dSql += '                ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME'+char(10)
		  SET @v_dSql += '                ,'+char(10)
		  SET @v_dSql += '' + @v_user_id+''+char(10)
		  SET @v_dSql += ' as JOB_USER_ID,dbo.sysdate1() as JOB_TIME,''UPDATE'' as JOB_TYPE'+char(10)
		  SET @v_dSql += '				        ,BATCH_RATIO_ID'+char(10)
		  SET @v_dSql += '				        ,FORM_ATTRIBUTE'+char(10)
		  SET @v_dSql += '          FROM   SCM_ITEM_M A WITH(NOLOCK)'+char(10)
		  SET @v_dSql += '          WHERE  A.COMPANY_ID  ='+char(10)
		  SET @v_dSql += '' + @v_company_id+''+char(10)
		  SET @v_dSql += '          AND    A.DIVISION_ID ='+char(10)
		  SET @v_dSql += '' + @v_division_id+''+char(10)
		  SET @v_dSql += '          AND    A.SITE_ID     ='+char(10)
		  SET @v_dSql += '' + @v_site_id+''+char(10)
		  SET @v_dSql += '          AND    A.ITEM_ID     ='+char(10)
		  SET @v_dSql += '' + @v_item_id+''+char(10)
		  SET @v_dSql += '          ;'+char(10)
		  SET @v_dSql += '        COMMIT;'+char(10)
		  SET @v_dSql += '  		END;'+char(10)
		  --print @v_dSql

		  IF @p_sys_type = 'SQL'
		  BEGIN
			-- return SQL Query Source
			select @v_dSql as [QUERY_VALUE]
		  END ELSE BEGIN
			SET @runstart = GetDate()


			 -- BEGIN TRAN
				-- run dynamic sql
				exec sp_executesql @v_dSql
			  --COMMIT TRAN
			


			SET @runend = GetDate()
			-- Record sql query
			exec PR_UI_SQL_LOG 'PR_UI_FP00180_SAVEALL_FP00180',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
		  END -- SYS TYPE NOT SQL END


	END -- SYS FLAG M END
  END -- WHILE END

	IF @p_sys_type <> 'SQL'
	BEGIN
		SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt
	END
	ELSE BEGIN
		SELECT @v_dSql as [QUERY_VALUE]
	END
	END TRY
				BEGIN CATCH
			  ROLLBACK
			  SET @runend = GetDate()
			  exec PR_UI_SQL_LOG 'PR_UI_FP00180_SAVEALL_FP00180',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
			END CATCH -- TRY END

END -- PROCEDURE  END

