--[PR_UI_FP00610_PlanResultValidation]
CREATE PROCEDURE [dbo].[PR_UI_FP00610_PlanResultValidation]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @in_columns           NVARCHAR(MAX),
  @in_row               NVARCHAR(MAX),
  @opt_none             NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   :PR_UI_FP00610_PlanResultValidation                                                **/
/** 프로그램 명   : Procedure PR_UI_FP00610_PlanResultValidation                                   **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                               **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2022-06-20     lgda106     Auto Generated With Initial Setting                   **/
/***********************************************************************************************/


BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  DECLARE @p_instance_id   NVARCHAR(max) = ''  
  DECLARE @p_plan_date     NVARCHAR(max) = ''
  DECLARE @p_plan_id       NVARCHAR(max) = ''
  DECLARE @p_division_id   NVARCHAR(max) = ''
  DECLARE @p_material      NVARCHAR(max) = ''
  DECLARE @p_problemType   NVARCHAR(max) = ''
  DECLARE @p_latePeriod    NVARCHAR(max) = ''

  --DECLARE BASE PARAMETER START
  DECLARE @runstart          datetime
  DECLARE @runend            datetime
  DECLARE @v_Err             NVARCHAR(max)
  DECLARE @v_Log             NVARCHAR(max) 
  DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP00610_PlanResultValidation'

  DECLARE @v_instance_id   NVARCHAR(max) = ''  
  DECLARE @v_plan_date     NVARCHAR(max) = ''
  DECLARE @v_plan_id       NVARCHAR(max) = ''
  DECLARE @v_material      NVARCHAR(max) = ''
  DECLARE @v_division_id   NVARCHAR(max) = ''
  DECLARE @v_problemType     NVARCHAR(max) = ''
  DECLARE @v_latePeriod    NVARCHAR(max) = ''

--DECLARE BASE PARAMETER START END

--Optional Parameter Part START
DECLARE @v_dSql                 NVARCHAR(MAX)=''
DECLARE @v_user_id              NVARCHAR(MAX)=''


DECLARE @v_SqlsubTotal          NVARCHAR(MAX)=''
DECLARE @v_SqlTotal             NVARCHAR(MAX)=''

DECLARE @v_Tmp1                 NVARCHAR(MAX)=''
DECLARE @v_Tmp2                 NVARCHAR(MAX)=''
DECLARE @v_Tmp3                 NVARCHAR(MAX)=''
DECLARE @v_Tmp4                 NVARCHAR(MAX)=''
DECLARE @v_Tmp5                 NVARCHAR(MAX)=''

DECLARE @v_pSql                 NVARCHAR(MAX)=''
DECLARE @v_sSql                 NVARCHAR(MAX)=''

DECLARE @bGapIn				  NVARCHAR(2)= ''
DECLARE @bGapOut                NVARCHAR(2)= ''
DECLARE @bGapInTot              NVARCHAR(2)= ''
DECLARE @bGapOutTot             NVARCHAR(2)= ''
DECLARE @bInqty                 NVARCHAR(2)= ''
DECLARE @bOutqty                NVARCHAR(2)= ''
DECLARE @bMppInqty              NVARCHAR(2)= ''
DECLARE @bMppOutqty             NVARCHAR(2)= ''
DECLARE @bWppInqty              NVARCHAR(2)= ''
DECLARE @bWppOutqty             NVARCHAR(2)= ''
DECLARE @bResultIn              NVARCHAR(2)= ''
DECLARE @bResultOut             NVARCHAR(2)= ''
DECLARE @bSeq                   NVARCHAR(2)= ''
DECLARE @bMemo                  NVARCHAR(2)= ''
DECLARE @bOffTime               NVARCHAR(2)= ''
DECLARE @bKg                    NVARCHAR(2)= ''
DECLARE @bPc                    NVARCHAR(2)= ''
DECLARE @bJr                    NVARCHAR(2)= ''
DECLARE @bCell                    NVARCHAR(2)= ''
DECLARE @bBatch                 NVARCHAR(2)= ''
DECLARE @bTotal                 NVARCHAR(2)= ''
DECLARE @bSubTotal              NVARCHAR(2)= ''
DECLARE @bAccInqty              NVARCHAR(2)= ''
DECLARE @bAccOutqty              NVARCHAR(2)= ''

DECLARE @bMppWpp                NVARCHAR(2)= ''

DECLARE @tmp_column             NVARCHAR(MAX) = ''
DECLARE @dbg_txt                NVARCHAR(MAX) = ''

DECLARE @v_delimiter            NVARCHAR(1)
DECLARE @v_sub_delimiter        NVARCHAR(1)
DECLARE @sub_v_delimiter        NVARCHAR(1)

DECLARE @max_loop_cnt	          INTEGER = 0
DECLARE @mst_loop_cnt	          INTEGER = 0

DECLARE @sub_mst_loop_cnt       INTEGER = 0
DECLARE @sub_max_loop_cnt       INTEGER = 0
DECLARE @sub_tmp_column         NVARCHAR(MAX) = ''
                                
DECLARE @sub_param_0            NVARCHAR(200) = '' 
DECLARE @sub_param_1            NVARCHAR(200) = '' 
DECLARE @sub_param_2            NVARCHAR(200) = '' 
DECLARE @sub_param_3            NVARCHAR(200) = '' 
DECLARE @sub_param_4            NVARCHAR(200) = '' 

  
SET	@v_pSql               = ''
SET   @v_sSql               = ''
--Optional Parameter Part END

SET @v_delimiter            = '^'  -- ������ ������
SET @v_sub_delimiter        = '|'  -- ������ ������
SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- ���ν��� LOOP ���̸� �Ǵ�


WHILE @mst_loop_cnt < @max_loop_cnt
BEGIN --START WHILE
    SET @mst_loop_cnt = @mst_loop_cnt + 1;    
    
    SET @tmp_column   = [dbo].[SCM_ARR_SPL_VAL]( @in_columns, @v_delimiter, @mst_loop_cnt);

	IF @tmp_column = 'INSTANCE_ID' 
    BEGIN
        SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'PLAN_DATE' 
    BEGIN
        SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'PLAN_ID' 
    BEGIN
        SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'DIVISION_ID' 
    BEGIN
        SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'MATERIAL_ID' 
    BEGIN
        SET @p_material =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'PROBLEM_TYPE' 
    BEGIN
        SET @p_problemType =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'LatePeriod' 
    BEGIN
        SET @p_latePeriod =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
END


BEGIN 
    SELECT @v_instance_id    = '''' + @p_instance_id + ''''  , @v_plan_date    = '''' + @p_plan_date + ''''
            , @v_plan_id      = '''' + @p_plan_id + ''''     , @v_material    = '''' + @p_material + ''''

            , @v_user_id      = '''' + @p_user_id + ''''      , @v_division_id    = '''' + @p_division_id + ''''
			, @v_problemType    = '''' + @p_problemType + ''''	  , @v_latePeriod    = '''' + @p_latePeriod + ''''
END

IF @p_sys_flag = 'SELECT_MAIN'
BEGIN --MAIN IF

	SELECT @v_dSql = ''
	SET @v_dSql += 'WITH NDATA AS ('+char(10);
	SET @v_dSql += '  SELECT     A.COMPANY_ID'+char(10);
	SET @v_dSql += '  	        ,A.DIVISION_ID'+char(10);
	SET @v_dSql += '  	        ,A.SITE_ID'+char(10);
	SET @v_dSql += '  	        ,A.PLANT_ID'+char(10);
	SET @v_dSql += '  	        ,A.SHOP_GROUP_ID'+char(10);
	SET @v_dSql += '  	        ,A.INSTANCE_ID'+char(10);
	SET @v_dSql += '  	        ,A.DPP_PLAN_ID AS FP_PLAN_ID'+char(10);
	SET @v_dSql += '  	        ,A.FP_DEMAND_ID AS DEMAND_ID'+char(10);
	SET @v_dSql += '  	        ,A.SCP_PLAN_ID'+char(10);
	SET @v_dSql += '  	        ,A.SCP_TARGET_ID'+char(10);
	SET @v_dSql += '  	        ,A.ITEM_ID'+char(10);
	SET @v_dSql += '  	        ,c.item_name'+char(10);
	SET @v_dSql += '  	        ,A.MFG_WEEK'+char(10);
	SET @v_dSql += '  	        ,A.MFG_QTY'+char(10);
	SET @v_dSql += '  	        ,CONVERT(VARCHAR,A.DUE_DATE,112) AS DUE_DATE'+char(10);
	SET @v_dSql += '  	        ,CONVERT(VARCHAR,A.DUE_FENCE_DATE,112) AS DUE_FENCE_DATE'+char(10);
	SET @v_dSql += '  	        ,CONVERT(VARCHAR, A.COMPLITE_DATE, 120) AS COMPLITE_DATE'+char(10);
	SET @v_dSql += '  	        ,A.PROBLEM_TYPE   '+char(10);
	SET @v_dSql += '            ,A.PROBLEM_QTY'+char(10);
	SET @v_dSql += '  FROM  ( SELECT     A.COMPANY_ID'+char(10);
	SET @v_dSql += '  					        ,A.DIVISION_ID'+char(10);
	SET @v_dSql += '  					        ,A.SITE_ID'+char(10);
	SET @v_dSql += '  					        ,A.PLANT_ID'+char(10);
	SET @v_dSql += '  					        ,A.SHOP_GROUP_ID'+char(10);
	SET @v_dSql += '  					        ,A.INSTANCE_ID'+char(10);
	SET @v_dSql += '  					        ,A.DPP_PLAN_ID'+char(10);
	SET @v_dSql += '  					        ,A.FP_DEMAND_ID'+char(10);
	SET @v_dSql += '  					        ,A.SCP_PLAN_ID'+char(10);
	SET @v_dSql += '  					        ,A.SCP_TARGET_ID'+char(10);
	SET @v_dSql += '  					        ,A.ITEM_ID'+char(10);
	SET @v_dSql += '  					        ,A.MFG_WEEK'+char(10);
	SET @v_dSql += '  					        ,A.MFG_QTY'+char(10);
	SET @v_dSql += '  					        ,A.DUE_DATE'+char(10);
	SET @v_dSql += '  					        ,A.DUE_FENCE_DATE'+char(10);
	SET @v_dSql += '  					        ,C.COMPLITE_DATE'+char(10);
	SET @v_dSql += '  					        ,ISNULL(B.PROBLEM_TYPE,''NORMAL'') AS PROBLEM_TYPE'+char(10);
	SET @v_dSql += '                    ,B.PROBLEM_QTY'+char(10);
	SET @v_dSql += '  					FROM     FP_DAILY_NET_DEMAND_H A(NOLOCK)'+char(10);
	SET @v_dSql += '  					         LEFT OUTER JOIN FP_PROBLEM_REPORT_R B(NOLOCK)'+char(10);
	SET @v_dSql += '  					         ON   A.INSTANCE_ID   = B.INSTANCE_ID'+char(10);
	SET @v_dSql += '  					         AND  A.COMPANY_ID    = B.COMPANY_ID'+char(10);
	SET @v_dSql += '  					         AND  A.DIVISION_ID   = B.DIVISION_ID'+char(10);
	SET @v_dSql += '  					         AND  A.SITE_ID       = B.SITE_ID'+char(10);
	SET @v_dSql += '  					         AND  A.DPP_PLAN_ID   = B.FP_PLAN_ID'+char(10);
	SET @v_dSql += '  					         AND  A.FP_DEMAND_ID  = B.DEMAND_ID'+char(10);
	SET @v_dSql += '  					         LEFT JOIN ('+char(10);
	SET @v_dSql += '  					          SELECT   C.INSTANCE_ID'+char(10);
	SET @v_dSql += '  					                  ,C.COMPANY_ID'+char(10);
	SET @v_dSql += '  					                  ,C.DIVISION_ID'+char(10);
	SET @v_dSql += '  					                  ,C.SITE_ID'+char(10);
	SET @v_dSql += '  					                  ,C.PLANT_ID'+char(10);
	SET @v_dSql += '  					                  ,C.FP_PLAN_ID'+char(10);
	SET @v_dSql += '  					                  ,C.DPP_PLAN_ID'+char(10);
	SET @v_dSql += '  					                  ,C.DEMAND_ID'+char(10);
	SET @v_dSql += '  					                  --,C.WORK_ORDER_ID'+char(10);
	SET @v_dSql += '  					                  --,MAX(C.ORDERTRACKING_SEQ) AS ORDERTRACKING_SEQ'+char(10);
	SET @v_dSql += '  					                  ,MAX(C.END_TIME) AS COMPLITE_DATE'+char(10);
	SET @v_dSql += '  					          FROM     FP_ORDER_TRACKING_R C(NOLOCK)'+char(10);
	--------------------------------------------------------------------
	SET @v_dSql += '  							      WHERE 1=1 '+char(10);
	SET @v_dSql += '									AND  C.FP_PLAN_ID = ' + @v_plan_id + char(10);
	SET @v_dSql += '									AND  C.DPP_PLAN_ID = ' + @v_plan_id + char(10);
	
	SET @v_dSql += '  					          GROUP BY C.INSTANCE_ID, C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FP_PLAN_ID, C.DPP_PLAN_ID, C.DEMAND_ID--, C.WORK_ORDER_ID, C.END_TIME'+char(10);
	SET @v_dSql += '  					          ) C'+char(10);
	SET @v_dSql += '  										ON       A.INSTANCE_ID    = C.INSTANCE_ID'+char(10);
	SET @v_dSql += '  										AND      A.COMPANY_ID     = C.COMPANY_ID'+char(10);
	SET @v_dSql += '  										AND      A.DIVISION_ID    = C.DIVISION_ID'+char(10);
	SET @v_dSql += '  										AND      A.SITE_ID        = C.SITE_ID'+char(10);
	SET @v_dSql += '  										AND      A.PLANT_ID       = C.PLANT_ID'+char(10);
	SET @v_dSql += '  										AND      A.FP_DEMAND_ID   = C.DEMAND_ID'+char(10);
	SET @v_dSql += '  										AND      A.DPP_PLAN_ID		= C.DPP_PLAN_ID'+char(10);
	----------------------------
	
	SET @v_dSql += '						WHERE  A.DPP_PLAN_ID = ' + @v_plan_id + char(10);

	SET @v_dSql += '  ) A'+char(10);
	SET @v_dSql += '  INNER HASH JOIN ('+char(10);
	SET @v_dSql += '  		SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID,B.SITE_ID,B.PLANT_ID'+char(10);
	SET @v_dSql += '  		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10);
	-----------------------
	SET @v_dSql += '  		WHERE  B.USER_ID     = ' + @v_user_id +char(10);
	SET @v_dSql += '  ) b'+char(10);
	SET @v_dSql += '  on    a.company_id = b.company_id'+char(10);
	SET @v_dSql += '  and   a.division_id = b.division_id'+char(10);
	SET @v_dSql += '  and   a.site_id = b.site_id'+char(10);
	SET @v_dSql += '  and   a.plant_id = b.plant_id'+char(10);
	SET @v_dSql += '  LEFT JOIN SCM_ITEM_V C(NOLOCK)'+char(10);
	SET @v_dSql += '  on    a.company_id = c.company_id'+char(10);
	SET @v_dSql += '  and   a.division_id = c.division_id'+char(10);
	SET @v_dSql += '  and   a.site_id = c.site_id'+char(10);
	------------------------------------------------
	SET @v_dSql += '  and   a.item_id = c.item_id'+char(10);
	-------------------------
	SET @v_dSql += '  where A.INSTANCE_ID 		= ' + @v_instance_id + char(10);
	---------------------------
	SET @v_dSql += '  AND   A.DPP_PLAN_ID 		= ' + @v_plan_id + char(10);
	SET @v_dSql += ')'+char(10);
	SET @v_dSql += 'SELECT SUM(CASE WHEN A.PROBLEM_TYPE=''NORMAL'' OR A.PROBLEM_TYPE=''PRECEDING'' THEN 1 ELSE 0 END) COMPLETE_CNT,'+char(10);
	SET @v_dSql += '       ROUND(SUM(CASE WHEN A.PROBLEM_TYPE=''NORMAL'' OR A.PROBLEM_TYPE=''PRECEDING'' THEN MFG_QTY ELSE 0 END),0) COMPLETE_QTY,'+char(10);
	SET @v_dSql += '	   ISNULL(ROUND(SUM(CASE WHEN A.PROBLEM_TYPE=''NORMAL'' OR A.PROBLEM_TYPE=''PRECEDING'' THEN MFG_QTY ELSE 0 END)*1.0/SUM(MFG_QTY)*100,2),0) COMPLETE_RATIO,'+char(10);
	SET @v_dSql += '       SUM(CASE A.PROBLEM_TYPE WHEN ''UNPLAN'' THEN 1 ELSE 0 END) UNPLAN_CNT,'+char(10);
	SET @v_dSql += '       ROUND(SUM(CASE A.PROBLEM_TYPE WHEN ''UNPLAN'' THEN PROBLEM_QTY ELSE 0 END),0) UNPLAN_QTY,'+char(10);
	SET @v_dSql += '	   ROUND(SUM(CASE A.PROBLEM_TYPE WHEN ''UNPLAN'' THEN PROBLEM_QTY ELSE 0 END)*1.0/SUM(MFG_QTY)*100,2) UNPLAN_RATIO,'+char(10);
	SET @v_dSql += '       SUM(CASE A.PROBLEM_TYPE WHEN ''LATE'' THEN 1 ELSE 0 END) LATE_CNT,'+char(10);
	SET @v_dSql += '       ROUND(SUM(CASE A.PROBLEM_TYPE WHEN ''LATE'' THEN PROBLEM_QTY ELSE 0 END),0) LATE_QTY,'+char(10);
	SET @v_dSql += '	   ROUND(SUM(CASE A.PROBLEM_TYPE WHEN ''LATE'' THEN PROBLEM_QTY ELSE 0 END)*1.0/SUM(MFG_QTY)*100,2) LATE_RATIO,'+char(10);
	SET @v_dSql += '       SUM(CASE A.PROBLEM_TYPE WHEN ''WEEKLATE'' THEN 1 ELSE 0 END) WEEK_LATE_CNT,'+char(10);
	SET @v_dSql += '       ROUND(SUM(CASE A.PROBLEM_TYPE WHEN ''WEEKLATE'' THEN PROBLEM_QTY ELSE 0 END),0) WEEK_LATE_QTY,'+char(10);
	SET @v_dSql += '	   ROUND(SUM(CASE A.PROBLEM_TYPE WHEN ''WEEKLATE'' THEN PROBLEM_QTY ELSE 0 END)*1.0/SUM(MFG_QTY)*100,2) WEEK_LATE_RATIO,'+char(10);
	SET @v_dSql += '       COUNT(DEMAND_ID) CNT, ROUND(SUM(MFG_QTY),0) QTY'+char(10);
	SET @v_dSql += 'FROM NDATA A'+char(10);
	SET @v_dSql += 'WHERE 1 = 1'+char(10);
	--------------------
	SET @v_dSql += 'AND  A.FP_PLAN_ID = ' + @v_plan_id +char(10);
	---------------------
	--SET @v_dSql += 'AND A.DIVISION_ID IN (' + @v_division_id  + ')'+char(10);
	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'LK', @p_division_id))        + char(10)

	SET @v_dSql += ';'+char(10);

END --MAIN IF

ELSE IF @p_sys_flag = 'SELECT_SUB'
BEGIN
	SELECT @v_dSql = ''
	
	SET @v_dSql += 'SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, '+ char(10);
	SET @v_dSql += '       A.DEMAND_ID, A.PROBLEM_SEQ, '+ char(10);
	SET @v_dSql += '       A.SCP_TARGET_ID, A.ITEM_ID, '+ char(10);
	SET @v_dSql += '       CONVERT(VARCHAR, A.DUE_DATE, 120) AS DUE_DATE, CONVERT(VARCHAR, A.DUE_FENCE_DATE, 120) AS DUE_FENCE_DATE,'+ char(10);
	SET @v_dSql += '       CONVERT(VARCHAR, A.RESPONSE_TIME, 120) AS RESPONSE_TIME, A.PROBLEM_TYPE, A.PROBLEM_REASON, '+ char(10);
	SET @v_dSql += '       A.PROBLEM_QTY, A.PROBLEM_ITEM, A.PROBLEM_PLANT, '+ char(10);
	SET @v_dSql += '       A.PROBLEM_FACTORY, A.PROBLEM_OPERATION, A.PROBLEM_LINE, '+ char(10);
	SET @v_dSql += '       A.PROBLEM_DESCRIPTION, '+ char(10);
	SET @v_dSql += '       CONVERT(VARCHAR, A.EPST, 120) AS EPST, CONVERT(VARCHAR, A.LPST, 120) AS LPST,'+ char(10);
	SET @v_dSql += '       B.WORK_ORDER_ID, B.SHOP_GROUP_ID, C.DEMAND_TYPE,'+ char(10);
	SET @v_dSql += '       ISNULL(PD.NICK_NAME, ''-'') AS NICK_NAME,'+ char(10);
	SET @v_dSql += '	   RE.LINE_NAME'+ char(10);
	SET @v_dSql += 'FROM FP_PROBLEM_REPORT_R A(NOLOCK)'+ char(10);
	SET @v_dSql += 'LEFT MERGE JOIN FP_DAILY_NET_DEMAND_H B(NOLOCK)'+ char(10);
	SET @v_dSql += 'ON A.COMPANY_ID = B.COMPANY_ID'+ char(10);
	SET @v_dSql += 'AND   A.DIVISION_ID = B.DIVISION_ID'+ char(10);
	SET @v_dSql += 'AND   A.SITE_ID = B.SITE_ID'+ char(10);
	SET @v_dSql += 'AND   A.FP_PLAN_ID = B.DPP_PLAN_ID'+ char(10);
	SET @v_dSql += 'AND   A.DEMAND_ID = B.FP_DEMAND_ID'+ char(10);
	SET @v_dSql += 'AND   A.SCP_TARGET_ID = B.SCP_TARGET_ID'+ char(10);
	SET @v_dSql += 'LEFT MERGE JOIN FP_WEEKLY_DEMAND_PRODUCT_H C(NOLOCK)'+ char(10);
	SET @v_dSql += 'ON   B.COMPANY_ID = C.COMPANY_ID'+ char(10);
	SET @v_dSql += 'AND   B.DIVISION_ID = C.DIVISION_ID'+ char(10);
	SET @v_dSql += 'AND   B.SITE_ID = C.SITE_ID'+ char(10);
	SET @v_dSql += 'AND   B.PLANT_ID = C.PLANT_ID'+ char(10);
	SET @v_dSql += 'AND   B.SHOP_GROUP_ID = C.SHOP_GROUP_ID'+ char(10);
	SET @v_dSql += 'AND   B.SCP_PLAN_ID = C.SCP_PLAN_ID'+ char(10);
	SET @v_dSql += 'AND   B.SCP_TARGET_ID = C.SCP_TARGET_ID'+ char(10);
	SET @v_dSql += 'LEFT OUTER JOIN SCM_ITEM_M PD(NOLOCK)'+ char(10);
	SET @v_dSql += 'ON  A.COMPANY_ID=PD.COMPANY_ID'+ char(10);
	SET @v_dSql += 'AND A.DIVISION_ID=PD.DIVISION_ID'+ char(10);
	SET @v_dSql += 'AND A.SITE_ID=PD.SITE_ID'+ char(10);
	SET @v_dSql += 'AND A.ITEM_ID=PD.ITEM_ID'+ char(10);
	SET @v_dSql += 'LEFT OUTER JOIN (	SELECT A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME '+ char(10);
	SET @v_dSql += '					FROM SCM_LINE_M A(NOLOCK), ( '+char(10);
	SET @v_dSql += '					  					SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID,B.SITE_ID,B.PLANT_ID, B.FACTORY_ID'+char(10);
	SET @v_dSql += '								      	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10);
	SET @v_dSql += '  										WHERE  B.USER_ID     = ' + @v_user_id +char(10);
	SET @v_dSql += '					) B'+char(10);
	SET @v_dSql += '				  WHERE A.COMPANY_ID  = B.COMPANY_ID'+char(10);
	SET @v_dSql += '				  AND   A.DIVISION_ID = B.DIVISION_ID'+char(10);
	SET @v_dSql += '				  AND   A.SITE_ID     = B.SITE_ID'+char(10);
	SET @v_dSql += '				  AND   A.PLANT_ID    = B.PLANT_ID'+char(10);
	SET @v_dSql += '				  AND   A.FACTORY_ID  = B.FACTORY_ID'+char(10);

	SET @v_dSql += '				  AND   A.ACTIVE_FLAG = ''Y'''+char(10);

	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'LK', @p_division_id))        + char(10)
	SET @v_dSql += '				  GROUP BY A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME '+char(10);
	SET @v_dSql += ') RE '+ char(10);
	SET @v_dSql += 'ON     A.COMPANY_ID = RE.COMPANY_ID '+ char(10);
	SET @v_dSql += 'AND    A.DIVISION_ID = RE.DIVISION_ID '+ char(10);
	SET @v_dSql += 'AND    A.SITE_ID = RE.SITE_ID '+ char(10);
	SET @v_dSql += 'AND    A.PROBLEM_PLANT = RE.PLANT_ID '+ char(10);
	SET @v_dSql += 'AND    A.PROBLEM_FACTORY = RE.FACTORY_ID '+ char(10);
	SET @v_dSql += 'AND    A.PROBLEM_OPERATION = RE.OPERATION_ID '+ char(10);
	SET @v_dSql += 'AND    A.PROBLEM_LINE = RE.LINE_ID '+ char(10);
	SET @v_dSql += 'WHERE 1 = 1 '+ char(10);
	SET @v_dSql += ' AND  A.FP_PLAN_ID = ' + @v_plan_id + char(10);
	SET @v_dSql += ' AND  A.PROBLEM_TYPE <> ''NORMAL'' ' + char(10);
	IF LEN(@p_problemType) > 0
	BEGIN
		SET @v_dSql += ' AND  A.PROBLEM_TYPE = ' + @v_problemType + char(10);
	END
	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'LK', @p_division_id))        + char(10)

	IF LEN(@p_material) > 0
	BEGIN
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.ITEM_ID' , 'LK', @p_material))        + char(10)

	END
	IF LEN(@p_latePeriod) > 0
	BEGIN
		SET @v_dSql += ' AND DATEDIFF(DAY, A.RESPONSE_TIME, A.DUE_DATE) >= ' + @v_latePeriod + char(10);		
	END


	SET @v_dSql += 'ORDER BY A.DIVISION_ID, A.SITE_ID, b.SHOP_GROUP_ID, A.SCP_TARGET_ID, A.DEMAND_ID, C.DEMAND_TYPE, B.WORK_ORDER_ID, A.ITEM_ID  '+ char(10);
	SET @v_dSql += ';  '+ char(10);

END
--------------------------------------------------------------------------------------------------------------------------------------------------------------



IF @p_sys_type = 'SQL'
BEGIN
-- return SQL Query Source
select @v_dSql as [QUERY_VALUE]
END 
ELSE 
BEGIN
	SET @runstart = GetDate()

	BEGIN TRY
		BEGIN TRAN
		-- run dynamic sql
			exec sp_executesql @v_dSql
			COMMIT TRAN
		END 
		
		TRY
			BEGIN CATCH
			ROLLBACK
			SET @runend = GetDate()
			exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
		END CATCH

		SET @runend = GetDate()
		-- Record sql query
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
	END


END
