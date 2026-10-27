CREATE PROCEDURE [dbo].[PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP]
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
/** 프로그램 ID   : PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP                                                                          **/
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
/** 2021-05-11     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_plan_date nvarchar(max) = ''
  DECLARE @p_factory_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_plan_date nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

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
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
      SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_LT' BEGIN
      SET @p_factory_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_plan_date ='''' + @p_plan_date + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''



  -- FP01624 findReleaseValidation_planGroup  
  SET @v_dSql = ''
  SET @v_dSql += '      WITH TARGET_PLAN AS'+char(10)
  SET @v_dSql += '      ('+char(10)
  SET @v_dSql += '           SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID , RELEASE_PLAN_ID PLAN_ID, AMEND_PLAN_ID BASIS_PLAN_ID, SLV.ATTRIBUTE1 AS UI_TYPE'+char(10)
  SET @v_dSql += '                , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID  ORDER BY INSERT_TIME DESC ) NUMS'+char(10)
  SET @v_dSql += '           FROM   FP_RELEASE_PLAN_INFO_H H WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                , SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)'+char(10)
  SET @v_dSql += '           WHERE  INSTANCE_ID   ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '           AND    INSTANCE_DATE ='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PLAN_GROUP_ID' , 'EQ', @p_factory_lt)) + char(10)
  --SET @v_dSql += '
  --{
  --              var sql="";
  --              var sFac = $data.FACTORY_LT;
  --
  --              if(sFac!="" && sFac!=null) {
  --                sql="AND    PLAN_GROUP_ID IN (" + sFac + ")\r\n";
  --              }
  --
  --              sql;
  --           }

  --'
  SET @v_dSql += '      	   AND    SLV.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI'''+char(10)
  SET @v_dSql += '      	   AND    SLV.SEGMENT1 = H.INSTANCE_ID'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID'+char(10)
  SET @v_dSql += '           , SUM(case when groups = ''ERP'' then make_qty else 0 end) ''ERP'''+char(10)
  SET @v_dSql += '           , SUM(case when groups = ''MES'' then make_qty else 0 end)  ''MES'''+char(10)
  SET @v_dSql += '           , SUM(case when groups = ''RELEASE'' then make_qty else 0 end ) ''RELEASE'''+char(10)
  SET @v_dSql += '           , SUM(case when groups = ''AMEND'' then make_qty else 0 end ) ''AMEND'''+char(10)
  SET @v_dSql += '           , SUM(case when groups = ''PLAN_EQUIPMENT_R'' then make_qty else 0 end ) ''PLAN_EQUIPMENT_R'''+char(10)
  SET @v_dSql += '           , CASE WHEN  SUM(case when groups = ''AMEND'' then make_qty else 0 end ) <> SUM(case when groups = ''RELEASE'' then make_qty else 0 end ) THEN ''NG_RELEASE'' ELSE '''' END CHK1_RELEASE'+char(10)
  SET @v_dSql += '           , CASE WHEN  SUM(case when groups = ''RELEASE'' then make_qty else 0 end ) <> SUM(case when groups = ''MES'' then make_qty else 0 end) THEN ''NG_MES'' ELSE '''' END CHK2_MES'+char(10)
  SET @v_dSql += '           , CASE WHEN  SUM(case when groups = ''MES'' then make_qty else 0 end) <> SUM(case when groups = ''ERP'' then make_qty else 0 end) THEN ''NG_ERP'' ELSE '''' END CHK3_ERP'+char(10)
  SET @v_dSql += '      from ('+char(10)
  SET @v_dSql += '              select max(groups) as groups, plant_id, factory_id, operation_id, item_id, make_date, sum(make_qty) as make_qty, plan_id'+char(10)
  SET @v_dSql += '              from  ( select ''ERP'' groups , plant_id, a.factory_id, OPERATION_ID, item_id,SUBSTRING(a.plan_date,1,8) make_date'+char(10)
  SET @v_dSql += '                          /*'+char(10)
  SET @v_dSql += '                          , A.PLAN_QTY-(SELECT  ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))'+char(10)
  SET @v_dSql += '                                                         /* + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0))'+char(10)
  SET @v_dSql += '                                                         + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0))'+char(10)
  SET @v_dSql += '                                                         + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))'+char(10)
  SET @v_dSql += '                                                         + SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0)) */'+char(10)
  SET @v_dSql += '                                                         ,0)'+char(10)
  SET @v_dSql += '                                           FROM    DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                                           WHERE   W.WOID   = A.WORK_ORDER_ID'+char(10)
  SET @v_dSql += '                                           AND     W.PROCID = A.OPERATION_ID'+char(10)
  SET @v_dSql += '                                           AND     W.WIP_TYPE_CODE in ( ''OUT'',''INOUT'',''PACKED'', ''PROD'') ) AS  MAKE_QTY'+char(10)
  SET @v_dSql += '                          */'+char(10)
  SET @v_dSql += '                          , FP_PLAN_QTY AS MAKE_QTY'+char(10)
  SET @v_dSql += '                          , A.FP_PLAN_ID AS PLAN_ID'+char(10)
  SET @v_dSql += '                     FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A  WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                           ,TARGET_PLAN  PLANS  WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                     WHERE  FP_PLAN_ID = PLANS.PLAN_ID'+char(10)
  SET @v_dSql += '                     AND    PLANS.NUMS = 1'+char(10)
  SET @v_dSql += '                		 AND   (A.TOP_BACK_IND = ''B'' OR A.TOP_BACK_IND IS NULL)'+char(10)
  SET @v_dSql += '                		 AND    A.FIX_TYPE = ''Y'''+char(10)
  SET @v_dSql += '                  UNION ALL'+char(10)
  SET @v_dSql += '          			    SELECT ''ERP'' AS GROUPS, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, CONVERT( VARCHAR, A.PLAN_DATE, 112) , A.PLAN_QTY'+char(10)
  SET @v_dSql += '                              , A.FP_PLAN_ID AS PLAN_ID'+char(10)
  SET @v_dSql += '          		      FROM   [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          				        ,TARGET_PLAN  PLANS  WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          			    WHERE A.FP_PLAN_ID = PLANS.PLAN_ID'+char(10)
  SET @v_dSql += '            		    AND   FIX_TYPE   IN (''F'',''N'')'+char(10)
  SET @v_dSql += '            		    AND   ORDER_TYPE IN (''W'')'+char(10)
  SET @v_dSql += '          			    AND   PLANS.NUMS = 1'+char(10)
  SET @v_dSql += '          			    AND   NOT EXISTS ( SELECT 1'+char(10)
  SET @v_dSql += '                    								   FROM   [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] XEP WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                    								   WHERE  XEP.FP_PLAN_ID = A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '                    								   AND    XEP.WORK_ORDER_ID = A.WORK_ORDER_ID )'+char(10)
  SET @v_dSql += '      		    ) PLANSS'+char(10)
  SET @v_dSql += '              group by plant_id, factory_id, OPERATION_ID, item_id,make_date, plan_id'+char(10)
  SET @v_dSql += '            UNION ALL'+char(10)
  SET @v_dSql += '              select max(groups) as groups, plant_id, factory_id, OPERATION_ID, item_id, make_date, sum(make_qty) as make_qty, plan_id'+char(10)
  SET @v_dSql += '              from  ( select ''MES'' as groups, plant_id, builno factory_id, OPERATION_ID, item_id, replace( SUBSTRING(a.plan_date,1,10) ,''-'','''') make_date'+char(10)
  SET @v_dSql += '                           /*'+char(10)
  SET @v_dSql += '                           ,OUT_QTY-( SELECT  ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))'+char(10)
  SET @v_dSql += '                                                   /* + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0))'+char(10)
  SET @v_dSql += '                                                   + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0))'+char(10)
  SET @v_dSql += '                                                   + SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))'+char(10)
  SET @v_dSql += '                                                   + SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0)) */'+char(10)
  SET @v_dSql += '                                                   ,0)'+char(10)
  SET @v_dSql += '                                     FROM    DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                                     WHERE   W.WOID   = A.WO'+char(10)
  SET @v_dSql += '                                     AND     W.PROCID = A.OPERATION_ID'+char(10)
  SET @v_dSql += '                                     AND     W.WIP_TYPE_CODE in ( ''OUT'',''INOUT'',''PACKED'', ''PROD'')'+char(10)
  SET @v_dSql += '                                     AND     W.WO_DETL_ID = A.WO_DETAIL ) AS MAKE_QTY'+char(10)
  SET @v_dSql += '                           */'+char(10)
  SET @v_dSql += '                           ,CAST(ATTR_08 AS NUMERIC) AS MAKE_QTY'+char(10)
  SET @v_dSql += '                           ,a.PLAN_ID'+char(10)
  SET @v_dSql += '                     from   SY_XIF_MES_WO_S a  with(nolock)'+char(10)
  SET @v_dSql += '                           ,target_plan  plans  with(nolock)'+char(10)
  SET @v_dSql += '                     where a.plan_id  = plans.plan_id'+char(10)
  SET @v_dSql += '                     and   plans.nums = 1'+char(10)
  SET @v_dSql += '                		 and   (a.attr_05 = ''B'' or a.attr_05 is null)'+char(10)
  SET @v_dSql += '                		 AND   A.IS_RELEASE = ''Y'''+char(10)
  SET @v_dSql += '                     and   if_id <> ''OFP0_OPLM_FP_WO'''+char(10)
  SET @v_dSql += '                  UNION ALL'+char(10)
  SET @v_dSql += '          			    SELECT ''MES'' AS GROUPS, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, CONVERT( VARCHAR, A.PLAN_DATE, 112) , A.PLAN_QTY'+char(10)
  SET @v_dSql += '                              , A.FP_PLAN_ID AS PLAN_ID'+char(10)
  SET @v_dSql += '          		      FROM   [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          				        ,TARGET_PLAN  PLANS  WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          			    WHERE A.FP_PLAN_ID = PLANS.PLAN_ID'+char(10)
  SET @v_dSql += '          		      AND   FIX_TYPE   IN (''F'',''N'')'+char(10)
  SET @v_dSql += '          			    AND   PLANS.NUMS = 1'+char(10)
  SET @v_dSql += '          			    /* 2018-07-24 kimcd... AND  EXISTS (SELECT 1'+char(10)
  SET @v_dSql += '                  							 FROM   [dbo].[SY_XIF_MES_WO_S] XMW WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  							 WHERE  XMW.PLAN_ID   = A.FP_PLAN_ID ) */'+char(10)
  SET @v_dSql += '          			    AND   NOT EXISTS ( SELECT 1'+char(10)
  SET @v_dSql += '                      								 FROM   [dbo].[SY_XIF_MES_WO_S] XMW WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                      								 WHERE  XMW.PLAN_ID   = A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '                      								 AND    XMW.WO        = A.WORK_ORDER_ID'+char(10)
  SET @v_dSql += '                      								 AND    XMW.WO_DETAIL = A.WORK_ORDER_SPL_ID )'+char(10)
  SET @v_dSql += '      		    ) planss'+char(10)
  SET @v_dSql += '              group by plant_id, factory_id, OPERATION_ID, item_id, make_date, plan_id'+char(10)
  SET @v_dSql += '            UNION ALL'+char(10)
  SET @v_dSql += '              select ''AMEND'' as groups, ( select f.plant_id from dbo.scm_factory_m f where f.factory_id = w.after_site_id ) as PLANT_ID'+char(10)
  SET @v_dSql += '                    ,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty'+char(10)
  SET @v_dSql += '      		          ,plans.plan_id'+char(10)
  SET @v_dSql += '              FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)'+char(10)
  SET @v_dSql += '      	           ,target_plan plans'+char(10)
  SET @v_dSql += '                   ,( select DEMAND_ID, MIN(AFTER_PLAN_DATE) AS PLAN_DATE'+char(10)
  SET @v_dSql += '                      FROM   [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)'+char(10)
  SET @v_dSql += '                            ,target_plan plans'+char(10)
  SET @v_dSql += '                      where master_id = plans.instance_id'+char(10)
  SET @v_dSql += '                      and  w.plan_id = plans.basis_plan_id'+char(10)
  SET @v_dSql += '      		            AND  w.after_in_qty > 0'+char(10)
  SET @v_dSql += '                      and  plans.nums = 1'+char(10)
  SET @v_dSql += '                		  AND  PLANS.UI_TYPE = ''AMEND UI'''+char(10)
  SET @v_dSql += '                		  AND  EXISTS (SELECT 1'+char(10)
  SET @v_dSql += '                						FROM   SCM_LINE_M   SLM WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                						WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID'+char(10)
  SET @v_dSql += '                						AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID'+char(10)
  SET @v_dSql += '                						AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID'+char(10)
  SET @v_dSql += '                						AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ))'+char(10)
  SET @v_dSql += '                            group by DEMAND_ID ) x'+char(10)
  SET @v_dSql += '              where master_id = plans.instance_id'+char(10)
  SET @v_dSql += '              and  w.plan_id = plans.basis_plan_id'+char(10)
  SET @v_dSql += '              AND  PLANS.UI_TYPE = ''AMEND UI'''+char(10)
  SET @v_dSql += '              and  w.demand_id = x.demand_id'+char(10)
  SET @v_dSql += '              AND  EXISTS ( SELECT 1'+char(10)
  SET @v_dSql += '                    				FROM   SCM_LINE_M   SLM WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                    				WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID'+char(10)
  SET @v_dSql += '                    				AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID'+char(10)
  SET @v_dSql += '                    				AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID'+char(10)
  SET @v_dSql += '                    				AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ))'+char(10)
  SET @v_dSql += '              and  PLAN_DATE <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)'+char(10)
  SET @v_dSql += '      								 FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                       WHERE  SLV.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'''+char(10)
  SET @v_dSql += '                       AND    SLV.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                       AND    SLV.SEGMENT1 = plans.INSTANCE_ID'+char(10)
  SET @v_dSql += '                       AND    SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )'+char(10)
  SET @v_dSql += '              and  plans.nums = 1'+char(10)
  SET @v_dSql += '              and  exists ('+char(10)
  SET @v_dSql += '                              select 1'+char(10)
  SET @v_dSql += '                              from   FP_INSTANCE_CONFIG_M k'+char(10)
  SET @v_dSql += '                              where  k.instance_id = w.master_id'+char(10)
  SET @v_dSql += '                              AND    k.CATEGORY_ID  = ''PLAN_CATEGORY'''+char(10)
  SET @v_dSql += '                              AND    k.KEY_ID       = ''CELL_HARD_PEGGING'''+char(10)
  SET @v_dSql += '                              AND    k.KEY_VALUE    = ''Y'''+char(10)
  SET @v_dSql += '                          )'+char(10)
  SET @v_dSql += '              group by after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id'+char(10)
  SET @v_dSql += '            UNION ALL'+char(10)
  SET @v_dSql += '              select ''AMEND'' as groups, ( select f.plant_id from dbo.scm_factory_m f WITH(NOLOCK) where f.factory_id = w.after_site_id ) as PLANT_ID'+char(10)
  SET @v_dSql += '                      ,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty'+char(10)
  SET @v_dSql += '      		            ,plans.plan_id'+char(10)
  SET @v_dSql += '              FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)'+char(10)
  SET @v_dSql += '      		         ,target_plan  plans  with(nolock)'+char(10)
  SET @v_dSql += '              where master_id = plans.instance_id'+char(10)
  SET @v_dSql += '              and   w.plan_id = plans.basis_plan_id'+char(10)
  SET @v_dSql += '              AND   PLANS.UI_TYPE = ''AMEND UI'''+char(10)
  SET @v_dSql += '              AND   EXISTS (SELECT 1'+char(10)
  SET @v_dSql += '      				FROM   SCM_LINE_M   SLM WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      				WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID'+char(10)
  SET @v_dSql += '      				AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID'+char(10)
  SET @v_dSql += '      				AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID'+char(10)
  SET @v_dSql += '      				AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ))'+char(10)
  SET @v_dSql += '              and  plans.nums = 1'+char(10)
  SET @v_dSql += '              and  w.after_in_qty > 0'+char(10)
  SET @v_dSql += '              and  after_plan_date <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)'+char(10)
  SET @v_dSql += '      									FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                        WHERE  SLV.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'''+char(10)
  SET @v_dSql += '                        AND    SLV.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                        AND    SLV.SEGMENT1 = plans.INSTANCE_ID'+char(10)
  SET @v_dSql += '                        AND    SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )'+char(10)
  SET @v_dSql += '                        and  not exists ('+char(10)
  SET @v_dSql += '                                        select 1'+char(10)
  SET @v_dSql += '                                        from   FP_INSTANCE_CONFIG_M k'+char(10)
  SET @v_dSql += '                                        where  k.instance_id = w.master_id'+char(10)
  SET @v_dSql += '                                        AND    k.CATEGORY_ID  = ''PLAN_CATEGORY'''+char(10)
  SET @v_dSql += '                                        AND    k.KEY_ID       = ''CELL_HARD_PEGGING'''+char(10)
  SET @v_dSql += '                                        AND    k.KEY_VALUE    = ''Y'''+char(10)
  SET @v_dSql += '                                    )'+char(10)
  SET @v_dSql += '              group by after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id'+char(10)
  SET @v_dSql += '            UNION ALL'+char(10)
  SET @v_dSql += '              select ''AMEND'' as groups, MAX(W.PLANT_ID) AS PLANT_ID'+char(10)
  SET @v_dSql += '                      ,W.FACTORY_ID as FACTORY_ID, W.operation_id, W.ITEM_ID, PLAN_DATE make_date , CEILING(sum(OUT_QTY)) make_qty'+char(10)
  SET @v_dSql += '      		            ,plans.plan_id'+char(10)
  SET @v_dSql += '              FROM  [dbo].[FP_AMEND_PLAN_R] w with(nolock)'+char(10)
  SET @v_dSql += '      		          ,target_plan  plans  with(nolock)'+char(10)
  SET @v_dSql += '              where w.instance_id = plans.instance_id'+char(10)
  SET @v_dSql += '              and   w.fp_plan_id  = plans.basis_plan_id'+char(10)
  SET @v_dSql += '              AND   PLANS.UI_TYPE = ''PSI AMEND UI'''+char(10)
  SET @v_dSql += '              AND   EXISTS (SELECT 1'+char(10)
  SET @v_dSql += '      				FROM   SCM_LINE_M   SLM WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      				WHERE  SLM.FACTORY_ID   = W.FACTORY_ID'+char(10)
  SET @v_dSql += '      				AND    SLM.LINE_ID      = W.LINE_ID'+char(10)
  SET @v_dSql += '      				AND    SLM.OPERATION_ID = W.OPERATION_ID'+char(10)
  SET @v_dSql += '      				AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ))'+char(10)
  SET @v_dSql += '              and  plans.nums = 1'+char(10)
  SET @v_dSql += '              and  in_qty > 0'+char(10)
  SET @v_dSql += '              and  plan_date <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)'+char(10)
  SET @v_dSql += '                            								FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                                            WHERE  SLV.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'''+char(10)
  SET @v_dSql += '                                            AND    SLV.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                                            AND    SLV.SEGMENT1 = plans.INSTANCE_ID'+char(10)
  SET @v_dSql += '                                            AND    SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )'+char(10)
  SET @v_dSql += '              group by W.FACTORY_ID, operation_id, ITEM_ID, plan_date, plans.plan_id'+char(10)
  SET @v_dSql += '            UNION ALL'+char(10)
  SET @v_dSql += '              SELECT ''RELEASE'', ( select f.plant_id from scm_factory_m f  with(nolock) where f.factory_id = w.FACTORY_ID ) as PLANT_ID'+char(10)
  SET @v_dSql += '                    , W.FACTORY_ID , W.OPERATION_ID , W.ITEM_ID , CONVERT(VARCHAR, W.PLAN_DATE,112) AS PLAN_DATE , CEILING(sum(PLAN_QTY)) make_qty'+char(10)
  SET @v_dSql += '                    ,plans.plan_id'+char(10)
  SET @v_dSql += '              FROM   FP_RELEASE_FIX_PLAN_H  W  with(nolock)'+char(10)
  SET @v_dSql += '                    ,target_plan  plans  with(nolock)'+char(10)
  SET @v_dSql += '              where W.INSTANCE_ID     = plans.instance_id'+char(10)
  SET @v_dSql += '              and   w.AMEND_PLAN_ID   = plans.basis_plan_id'+char(10)
  SET @v_dSql += '              and   w.RELEASE_PLAN_ID = plans.PLAN_ID'+char(10)
  SET @v_dSql += '              and   plans.nums        = 1'+char(10)
  SET @v_dSql += '              group by W.FACTORY_ID, W.operation_id, W.ITEM_ID, W.plan_date, plans.plan_id'+char(10)
  SET @v_dSql += '            UNION ALL'+char(10)
  SET @v_dSql += '              select ''PLAN_EQUIPMENT_R'', a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112), sum( a.plan_qty)'+char(10)
  SET @v_dSql += '                    ,plans.plan_id'+char(10)
  SET @v_dSql += '              from   dbo.FP_PRODUCTION_PLAN_EQUIPMENT_R a  with(nolock)'+char(10)
  SET @v_dSql += '                    ,target_plan plans with(nolock)'+char(10)
  SET @v_dSql += '              where a.FP_PLAN_ID = plans.plan_id'+char(10)
  SET @v_dSql += '              and   FIX_TYPE   IN (''F'',''N'')'+char(10)
  SET @v_dSql += '              and   ORDER_TYPE IN (''W'',''M'')'+char(10)
  SET @v_dSql += '              group by a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112),plans.plan_id'+char(10)
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      WHERE  OPERATION_ID != ''A6000'''+char(10)
  SET @v_dSql += '      GROUP BY PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID'+char(10)
  SET @v_dSql += '      HAVING ( ABS(SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = ''RELEASE'' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015'+char(10)
  SET @v_dSql += '          OR ABS(SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = ''MES'' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015 )'+char(10)
  SET @v_dSql += '      AND ( ABS(SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = ''RELEASE'' THEN MAKE_QTY ELSE 0 END )) > 1'+char(10)
  SET @v_dSql += '          OR ABS(SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = ''MES'' THEN MAKE_QTY ELSE 0 END ))> 1 )'+char(10)
  SET @v_dSql += '      UNION'+char(10)
  SET @v_dSql += '      SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID'+char(10)
  SET @v_dSql += '                   , 0 ''ERP'''+char(10)
  SET @v_dSql += '                   , 0  ''MES'''+char(10)
  SET @v_dSql += '                   , 0 ''RELEASE'''+char(10)
  SET @v_dSql += '                   , 0 ''AMEND'''+char(10)
  SET @v_dSql += '                   , count(distinct batch_id) ''PLAN_EQUIPMENT_R'''+char(10)
  SET @v_dSql += '                   , z.batch_order_id CHK1_RELEASE'+char(10)
  SET @v_dSql += '                   , ''NG_BATCH_ORDER_ID'' CHK2_MES'+char(10)
  SET @v_dSql += '                   , ''NG_BATCH_ORDER_ID'' CHK3_ERP'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '              SELECT ISNULL((SELECT  B.BATCH_ID'+char(10)
  SET @v_dSql += '                             FROM    SCM_BATCH_M B'+char(10)
  SET @v_dSql += '                             WHERE   B.PLANT_ID = A.PLANT_ID'+char(10)
  SET @v_dSql += '                             AND     B.ITEM_ID = A.ITEM_ID), ITEM_ID) AS BATCH_ID , A.*'+char(10)
  SET @v_dSql += '              FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                   , TARGET_PLAN PLANS WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              WHERE A.FP_PLAN_ID = PLANS.PLAN_ID'+char(10)
  SET @v_dSql += '              AND   BATCH_ORDER_ID <> ''-'''+char(10)
  SET @v_dSql += '           ) z'+char(10)
  SET @v_dSql += '      GROUP BY Z.PLANT_ID, Z.FACTORY_ID, Z.OPERATION_ID, Z.ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID, BATCH_ORDER_ID'+char(10)
  SET @v_dSql += '      HAVING COUNT(DISTINCT z.BATCH_ID) > 1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP01624","findReleaseValidation_planGroup",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP01624_FINDRELEASEVALIDATION_PLANGROUP',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
