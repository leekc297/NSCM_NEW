--[PR_UI_FP00606_FIND_FP00606]
CREATE PROCEDURE [dbo].[PR_UI_FP01470_OrderTracking]
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
/** 프로그램 ID   :PR_UI_FP01470_OrderTracking                                                **/
/** 프로그램 명   : Procedure PR_UI_FP01470_OrderTracking                                   **/
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
/** 2022-06-09     lgda106     Auto Generated With Initial Setting                   **/
/***********************************************************************************************/


BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  DECLARE @p_instance_id   NVARCHAR(max) = ''  
  DECLARE @p_plan_date     NVARCHAR(max) = ''
  DECLARE @p_plan_id       NVARCHAR(max) = ''
  DECLARE @p_material      NVARCHAR(max) = ''
  DECLARE @p_site_id       NVARCHAR(max) = ''
  DECLARE @p_demand_id     NVARCHAR(max) = ''

  --DECLARE BASE PARAMETER START
  DECLARE @runstart          datetime
  DECLARE @runend            datetime
  DECLARE @v_Err             NVARCHAR(max)
  DECLARE @v_Log             NVARCHAR(max) 
  DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP01470_OrderTracking'

  DECLARE @v_instance_id   NVARCHAR(max) = ''  
  DECLARE @v_plan_date     NVARCHAR(max) = ''
  DECLARE @v_plan_id       NVARCHAR(max) = ''
  DECLARE @v_material      NVARCHAR(max) = ''
  DECLARE @v_site_id       NVARCHAR(max) = ''
  DECLARE @v_demand_id     NVARCHAR(max) = ''

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
	ELSE IF @tmp_column = 'MATERIAL_ID' 
    BEGIN
        SET @p_material =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SITE_ID' 
    BEGIN
        SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'DEMAND_ID' 
    BEGIN
        SET @p_demand_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
		SET @p_demand_id =  REPLACE(@p_demand_id , '&#94;', '^')
    END 
END


BEGIN 
    SELECT @v_instance_id    = '''' + @p_instance_id + ''''  , @v_plan_date    = '''' + @p_plan_date + ''''
            , @v_plan_id      = '''' + @p_plan_id + ''''     , @v_material    = '''' + @p_material + ''''

            , @v_user_id      = '''' + @p_user_id + ''''      , @v_site_id    = '''' + @p_site_id + ''''
			, @v_demand_id    = '''' + @p_demand_id + ''''
END

IF @p_sys_flag = 'SELECT_MAIN'
BEGIN --MAIN IF

	SELECT @v_dSql = ''
	SELECT @v_pSql  = ''

	SET @v_dSql += 'SELECT   A.COMPANY_ID '+char(10)
    SET @v_dSql += '        ,A.DIVISION_ID '+char(10)
    SET @v_dSql += '        ,A.SITE_ID '+char(10)
    SET @v_dSql += '        ,A.PLANT_ID '+char(10)
    SET @v_dSql += '        ,A.SHOP_GROUP_ID '+char(10)
    SET @v_dSql += '        ,A.INSTANCE_ID '+char(10)
    SET @v_dSql += '        ,A.DPP_PLAN_ID '+char(10)
    SET @v_dSql += '        ,A.FP_DEMAND_ID '+char(10)
    SET @v_dSql += '        ,A.SCP_PLAN_ID '+char(10)
    SET @v_dSql += '        ,A.SCP_TARGET_ID '+char(10)
    SET @v_dSql += '        ,A.ITEM_ID		 '+char(10)
    SET @v_dSql += '        ,C.ITEM_NAME '+char(10)
    SET @v_dSql += '        ,A.MFG_WEEK '+char(10)
    SET @v_dSql += '        ,A.MFG_QTY '+char(10)
    SET @v_dSql += '        ,CONVERT(VARCHAR,A.DUE_DATE,112) AS DUE_DATE '+char(10)
    SET @v_dSql += '        ,CONVERT(VARCHAR,A.DUE_FENCE_DATE,112) AS DUE_FENCE_DATE '+char(10)
    SET @v_dSql += '        ,CONVERT(VARCHAR, A.COMPLITE_DATE, 120) AS COMPLITE_DATE '+char(10)
    SET @v_dSql += '        ,A.PROBLEM_TYPE ,ISNULL(PD.NICK_NAME, ''-'') AS NICK_NAME '+char(10)
    SET @v_dSql += 'FROM  (   SELECT     A.COMPANY_ID '+char(10)
    SET @v_dSql += '                    ,A.DIVISION_ID '+char(10)
    SET @v_dSql += '                    ,A.SITE_ID '+char(10)
    SET @v_dSql += '                    ,A.PLANT_ID '+char(10)
    SET @v_dSql += '                    ,A.SHOP_GROUP_ID '+char(10)
    SET @v_dSql += '                    ,A.INSTANCE_ID '+char(10)
    SET @v_dSql += '                    ,A.DPP_PLAN_ID '+char(10)
    SET @v_dSql += '                    ,A.FP_DEMAND_ID '+char(10)
    SET @v_dSql += '                    ,A.SCP_PLAN_ID '+char(10)
    SET @v_dSql += '                    ,A.SCP_TARGET_ID '+char(10)
    SET @v_dSql += '                    ,A.ITEM_ID '+char(10)
    SET @v_dSql += '                    ,A.MFG_WEEK '+char(10)
    SET @v_dSql += '                    ,A.MFG_QTY '+char(10)
    SET @v_dSql += '                    ,A.DUE_DATE '+char(10)
    SET @v_dSql += '                    ,A.DUE_FENCE_DATE '+char(10)
    SET @v_dSql += '                    ,C.COMPLITE_DATE '+char(10)
    SET @v_dSql += '                    ,ISNULL(B.PROBLEM_TYPE,''COMPLETE'') AS PROBLEM_TYPE '+char(10)
    SET @v_dSql += '            FROM     FP_DAILY_NET_DEMAND_H A(NOLOCK) '+char(10)
    SET @v_dSql += '            LEFT OUTER JOIN FP_PROBLEM_REPORT_R B(NOLOCK) '+char(10)
    SET @v_dSql += '                                    ON   A.INSTANCE_ID   = B.INSTANCE_ID '+char(10)
    SET @v_dSql += '                                    AND  A.COMPANY_ID    = B.COMPANY_ID '+char(10)
    SET @v_dSql += '                                    AND  A.DIVISION_ID   = B.DIVISION_ID '+char(10)
    SET @v_dSql += '                                    AND  A.SITE_ID       = B.SITE_ID '+char(10)
    SET @v_dSql += '                                    AND  A.DPP_PLAN_ID   = B.FP_PLAN_ID '+char(10)
    SET @v_dSql += '                                    AND  A.FP_DEMAND_ID  = B.DEMAND_ID '+char(10)
    SET @v_dSql += '            LEFT OUTER JOIN ( '+char(10)
    SET @v_dSql += '                                SELECT   C.INSTANCE_ID '+char(10)
    SET @v_dSql += '                                        ,C.COMPANY_ID '+char(10)
    SET @v_dSql += '                                        ,C.DIVISION_ID '+char(10)
    SET @v_dSql += '                                        ,C.SITE_ID '+char(10)
    SET @v_dSql += '                                        ,C.PLANT_ID '+char(10)
    SET @v_dSql += '                                        ,C.FP_PLAN_ID '+char(10)
    SET @v_dSql += '                                        ,C.DPP_PLAN_ID '+char(10)
    SET @v_dSql += '                                        ,C.DEMAND_ID  '+char(10)
    SET @v_dSql += '                                        ,MAX(C.END_TIME) AS COMPLITE_DATE '+char(10)
    SET @v_dSql += '                                FROM     FP_ORDER_TRACKING_R C(NOLOCK) '+char(10)

    SET @v_dSql += '                                WHERE    C.DPP_PLAN_ID	= ' +  @v_plan_id + char(10)

    SET @v_dSql += '                                GROUP BY C.INSTANCE_ID, C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, C.FP_PLAN_ID, C.DPP_PLAN_ID, C.DEMAND_ID--, C.WORK_ORDER_ID, C.END_TIME '+char(10)
    SET @v_dSql += '                                ) C'+char(10)
    SET @v_dSql += '                                        ON       A.INSTANCE_ID    = C.INSTANCE_ID'+char(10)
    SET @v_dSql += '                                        AND      A.COMPANY_ID     = C.COMPANY_ID'+char(10)
    SET @v_dSql += '                                        AND      A.DIVISION_ID    = C.DIVISION_ID'+char(10)
    SET @v_dSql += '                                        AND      A.SITE_ID        = C.SITE_ID'+char(10)
    SET @v_dSql += '                                        AND      A.PLANT_ID       = C.PLANT_ID'+char(10)
    SET @v_dSql += '                                        AND      A.FP_DEMAND_ID   = C.DEMAND_ID'+char(10)
    SET @v_dSql += '                                        AND			 A.DPP_PLAN_ID		= C.DPP_PLAN_ID'+char(10)

    SET @v_dSql += '                                        WHERE    A.DPP_PLAN_ID	= ' + @v_plan_id + char(10)
    
	SET @v_dSql += '    ) A'+char(10)
    SET @v_dSql += '    INNER HASH JOIN ('+char(10)
    SET @v_dSql += '                        SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID,B.SITE_ID,B.PLANT_ID'+char(10)
    SET @v_dSql += '                        FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)

    SET @v_dSql += '                        WHERE  B.USER_ID     = ' + @v_user_id + char(10)
    
	SET @v_dSql += '    ) b'+char(10)
    SET @v_dSql += '                        ON    A.COMPANY_ID   = B.COMPANY_ID'+char(10)
    SET @v_dSql += '                        AND   A.DIVISION_ID  = B.DIVISION_ID'+char(10)
    SET @v_dSql += '                        AND   A.SITE_ID      = B.SITE_ID'+char(10)
    SET @v_dSql += '                        AND   A.PLANT_ID     = B.PLANT_ID'+char(10)
    SET @v_dSql += '        LEFT OUTER JOIN SCM_ITEM_V C(NOLOCK)'+char(10)
    SET @v_dSql += '                        ON    A.COMPANY_ID   = C.COMPANY_ID'+char(10)
    SET @v_dSql += '                        AND   A.DIVISION_ID  = C.DIVISION_ID'+char(10)
    SET @v_dSql += '                        AND   A.SITE_ID      = C.SITE_ID'+char(10)
    SET @v_dSql += '                        AND   A.ITEM_ID      = C.ITEM_ID'+char(10)
    SET @v_dSql += '        LEFT OUTER JOIN SCM_ITEM_M PD(NOLOCK)'+char(10)
    SET @v_dSql += '                        ON  A.COMPANY_ID     = PD.COMPANY_ID'+char(10)
    SET @v_dSql += '                        AND A.DIVISION_ID    = PD.DIVISION_ID'+char(10)
    SET @v_dSql += '                        AND A.SITE_ID        = PD.SITE_ID'+char(10)
    SET @v_dSql += '                        AND A.ITEM_ID        = PD.ITEM_ID'+char(10)

    SET @v_dSql += '                        WHERE  A.INSTANCE_ID 		= ' + @v_instance_id + char(10)
    SET @v_dSql += '                        AND    A.DPP_PLAN_ID 		= ' + @v_plan_id +char(10)
	IF(LEN(@p_material) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_material))                + char(10)
	END


    SET @v_dSql += ' ORDER BY A.DIVISION_ID, A.PLANT_ID, A.ITEM_ID, A.SCP_TARGET_ID, A.FP_DEMAND_ID ;'+char(10)

END --MAIN IF

ELSE IF @p_sys_flag = 'SELECT_SUB'
BEGIN
	SELECT @v_dSql = ''
	SET @v_dSql += ' SELECT   A.INSTANCE_ID ' + char(10)
	SET @v_dSql += ' 		,A.FP_PLAN_ID ' + char(10)
	SET @v_dSql += ' 		,A.DPP_PLAN_ID ' + char(10)
	SET @v_dSql += ' 		,A.COMPANY_ID ' + char(10)
	SET @v_dSql += ' 		,A.DIVISION_ID ' + char(10)
	SET @v_dSql += ' 		,A.SITE_ID ' + char(10)
	SET @v_dSql += ' 		,A.PLANT_ID ' + char(10)
	SET @v_dSql += ' 		,A.DEMAND_ID ' + char(10)
	SET @v_dSql += ' 		,A.ORDERTRACKING_SEQ ' + char(10)
	SET @v_dSql += ' 		,A.WORK_ORDER_ID ' + char(10)
	SET @v_dSql += ' 		,A.ORDER_TYPE ' + char(10)
	SET @v_dSql += ' 		,A.FACTORY_ID ' + char(10)
	SET @v_dSql += ' 		,A.OPERATION_ID ' + char(10)
	SET @v_dSql += ' 		,B.OPERATION_NAME ' + char(10)
	SET @v_dSql += ' 		,A.LINE_ID ' + char(10)
	SET @v_dSql += ' 		,A.IN_ITEM_ID ' + char(10)
	SET @v_dSql += ' 		,A.IN_PLAN_QTY ' + char(10)
	SET @v_dSql += ' 		,A.TO_FACTORY_ID ' + char(10)
	SET @v_dSql += ' 		,A.TO_OPERATION_ID ' + char(10)
	SET @v_dSql += ' 		,A.ITEM_ID ' + char(10)
	SET @v_dSql += ' 		,A.PLAN_QTY ' + char(10)
	SET @v_dSql += ' 		,CONVERT(VARCHAR, A.START_TIME, 120) AS START_TIME ' + char(10)
	SET @v_dSql += ' 		,CONVERT(VARCHAR, A.END_TIME, 120) AS END_TIME ' + char(10)
	SET @v_dSql += ' 		,CONVERT(VARCHAR, A.EPST, 120) AS EPST ' + char(10)
	SET @v_dSql += ' 		,CONVERT(VARCHAR, A.LPST, 120) AS LPST ' + char(10)
	SET @v_dSql += ' 		,CONVERT(VARCHAR, A.AVAILABLE_TIME, 120) AS AVAILABLE_TIME ' + char(10)
	SET @v_dSql += ' 		,A.PLAN_RESULT ,ISNULL(PD.NICK_NAME, ''-'') AS NICK_NAME ,ISNULL(PD2.NICK_NAME, ''-'') AS IN_NICK_NAME ' + char(10) 
	SET @v_dSql += ' 		,RE.LINE_NAME ' + char(10)
	SET @v_dSql += ' FROM    FP_ORDER_TRACKING_R A(NOLOCK) ' + char(10)
	SET @v_dSql += ' INNER JOIN SCM_OPERATION_M B(NOLOCK) ' + char(10)
	SET @v_dSql += ' ON      A.COMPANY_ID    = B.COMPANY_ID ' + char(10)
	SET @v_dSql += ' AND     A.DIVISION_ID   = B.DIVISION_ID ' + char(10)
	SET @v_dSql += ' AND     A.SITE_ID       = B.SITE_ID ' + char(10)
	SET @v_dSql += ' AND     A.OPERATION_ID  = B.OPERATION_ID ' + char(10)
	SET @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M PD(NOLOCK) ' + char(10)
	SET @v_dSql += ' ON      A.COMPANY_ID    = PD.COMPANY_ID ' + char(10)
	SET @v_dSql += ' AND     A.DIVISION_ID   = PD.DIVISION_ID ' + char(10)
	SET @v_dSql += ' AND     A.SITE_ID       = PD.SITE_ID ' + char(10)
	SET @v_dSql += ' AND     A.ITEM_ID       = PD.ITEM_ID ' + char(10)
	SET @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M PD2(NOLOCK) ' + char(10)
	SET @v_dSql += ' ON      A.COMPANY_ID    = PD2.COMPANY_ID ' + char(10)
	SET @v_dSql += ' AND     A.DIVISION_ID   = PD2.DIVISION_ID ' + char(10)
	SET @v_dSql += ' AND     A.SITE_ID       = PD2.SITE_ID ' + char(10)
	SET @v_dSql += ' AND     A.IN_ITEM_ID    = PD2.ITEM_ID ' + char(10)
	SET @v_dSql += ' LEFT OUTER JOIN (	SELECT A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME  ' + char(10)
	SET @v_dSql += ' 			FROM SCM_LINE_M A(NOLOCK) ' + char(10)
	SET @v_dSql += ' 					, ( ' + char(10)
	SET @v_dSql += ' 						SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID,B.SITE_ID,B.PLANT_ID, B.FACTORY_ID ' + char(10)
	SET @v_dSql += ' 						FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10)

	SET @v_dSql += ' 						WHERE  B.USER_ID     = ' + @v_user_id + char(10)

	SET @v_dSql += ' 					) B ' + char(10)
	SET @v_dSql += ' 			WHERE A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
	SET @v_dSql += ' 			AND   A.DIVISION_ID = B.DIVISION_ID ' + char(10)
	SET @v_dSql += ' 			AND   A.SITE_ID     = B.SITE_ID ' + char(10)
	SET @v_dSql += ' 			AND   A.PLANT_ID    = B.PLANT_ID ' + char(10)
	SET @v_dSql += ' 			AND   A.FACTORY_ID  = B.FACTORY_ID ' + char(10)

								--check
	SET @v_dSql += ' 			AND   A.ACTIVE_FLAG = ''Y'' ' + char(10)
	SET @v_dSql += ' 			AND   A.SITE_ID      = ' + @v_site_id + char(10)

	SET @v_dSql += ' 			GROUP BY A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME ' + char(10)
	SET @v_dSql += ' ) RE ' + char(10)
	SET @v_dSql += ' ON     A.COMPANY_ID = RE.COMPANY_ID ' + char(10)
	SET @v_dSql += ' AND    A.DIVISION_ID = RE.DIVISION_ID ' + char(10)
	SET @v_dSql += ' AND    A.SITE_ID = RE.SITE_ID ' + char(10)
	SET @v_dSql += ' AND    A.PLANT_ID = RE.PLANT_ID ' + char(10)
	SET @v_dSql += ' AND    A.FACTORY_ID = RE.FACTORY_ID ' + char(10)
	SET @v_dSql += ' AND    A.OPERATION_ID = RE.OPERATION_ID ' + char(10)
	SET @v_dSql += ' AND    A.LINE_ID = RE.LINE_ID ' + char(10)

	SET @v_dSql += ' WHERE   A.INSTANCE_ID	  = ' + @v_instance_id +char(10)

	SET @v_dSql += ' AND     A.DEMAND_ID 		= ' + @v_demand_id  + char(10)	
    SET @v_dSql += '  AND    A.DPP_PLAN_ID 		= ' + @v_plan_id +char(10)

	SET @v_dSql += ' ORDER BY A.START_TIME,A.ORDERTRACKING_SEQ; ' + char(10)    

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
