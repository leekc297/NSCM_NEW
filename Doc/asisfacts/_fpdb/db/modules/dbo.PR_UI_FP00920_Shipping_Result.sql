CREATE PROCEDURE [dbo].[PR_UI_FP00920_Shipping_Result]
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
/** 프로그램 ID   :PR_UI_FP00920_Shipping_Result                                                **/
/** 프로그램 명   : Procedure PR_UI_FP00920_Shipping_Result                             **/
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
/** 2022-05-02     lgda106     Auto Generated With Initial Setting                   **/
/***********************************************************************************************/


BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
	
  DECLARE @p_division_id		NVARCHAR(MAX)=''
  DECLARE @p_site_id			NVARCHAR(MAX)=''
  DECLARE @p_plant_id			NVARCHAR(MAX)=''  
  DECLARE @p_to_site_id			NVARCHAR(MAX)=''
  DECLARE @p_item_id			NVARCHAR(MAX)=''
  DECLARE @p_bucket_from		NVARCHAR(100)=''
  DECLARE @p_bucket_to			NVARCHAR(100)=''

  DECLARE @v_division_id		NVARCHAR(MAX)=''
  DECLARE @v_site_id			NVARCHAR(MAX)=''
  DECLARE @v_plant_id			NVARCHAR(MAX)=''  
  DECLARE @v_to_site_id			NVARCHAR(MAX)=''
  DECLARE @v_item_id			NVARCHAR(MAX)=''
  DECLARE @v_bucket_from		NVARCHAR(100)=''
  DECLARE @v_bucket_to			NVARCHAR(100)=''

  DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00920_Shipping_Result';
  DECLARE @runstart		datetime;
  DECLARE @runend			datetime;
  DECLARE @v_dSql			nvarchar(MAX)='';

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

  SET @v_delimiter            = '^'  -- ������ ������
  SET @v_sub_delimiter        = '|'  -- ������ ������
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- ���ν��� LOOP ���̸� �Ǵ�


WHILE @mst_loop_cnt < @max_loop_cnt
BEGIN --START WHILE
    SET @mst_loop_cnt = @mst_loop_cnt + 1;    
    
    SET @tmp_column   = [dbo].[SCM_ARR_SPL_VAL]( @in_columns, @v_delimiter, @mst_loop_cnt);

    IF @tmp_column = 'DIVISION_ID' 
    BEGIN
        SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'SITE_ID' 
    BEGIN
        SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'PLANT_ID' 
    BEGIN
        SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row       ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'TO_SITE_ID' 
    BEGIN
        SET @p_to_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'ITEM_ID' 
    BEGIN
        SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
    END    
    ELSE IF @tmp_column = 'BUCKET_FROM' 
    BEGIN
        SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END  
    ELSE IF @tmp_column = 'BUCKET_TO' 
    BEGIN
        SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END
   
END



BEGIN 
    SELECT  @v_division_id  = '''' + @p_division_id + ''''
            , @v_site_id      = '''' + @p_site_id + ''''      , @v_plant_id     = '''' + @p_plant_id + ''''
            , @v_to_site_id      = '''' + @p_to_site_id + ''''   
            , @v_item_id      = '''' + @p_item_id + ''''      
            , @v_bucket_from  = '''' + @p_bucket_from + ''''  , @v_bucket_to    = '''' + @p_bucket_to + ''''
           
END

IF @p_sys_flag = 'SELECT_MAIN'
BEGIN
	
	SET	@v_dSql = ''



	--SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,'+char(10);
	--SELECT @v_dSql += N'CONVERT(VARCHAR, A.CUTOFF_DATE, 112) AS CUTOFF_DATE, A.SEQ, A.SHOP_GROUP_ID, A.ITEM_ID, A.QTY, ISNULL(B.NICK_NAME, '-') AS NICK_NAME, '+char(10);
	--SELECT @v_dSql += N'CONVERT(VARCHAR, A.SHIP_DATE, 120) AS SHIP_DATE, A.TO_SITE_ID, A.TO_PLANT_ID, A.CUSTOMER_ID,  '+char(10);
	--SELECT @v_dSql += N'A.UPDATE_ID, CONVERT(VARCHAR, A.UPDATE_TIME, 120) AS UPDATE_TIME '+char(10);
	--SELECT @v_dSql += N'FROM   SCM_SHIPPING_RESULT_H A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK) '+char(10);
	--SELECT @v_dSql += N'WHERE  EXISTS ( '+char(10);
	--SELECT @v_dSql += N'SELECT 1 '+char(10);
	--SELECT @v_dSql += N'FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) '+char(10);
	--SELECT @v_dSql += N'WHERE  A.COMPANY_ID  = B.COMPANY_ID '+char(10);
	--SELECT @v_dSql += N'AND    A.DIVISION_ID = B.DIVISION_ID '+char(10);
	--SELECT @v_dSql += N'AND    A.SITE_ID     = B.SITE_ID '+char(10);
	--SELECT @v_dSql += N'AND    A.PLANT_ID    = B.PLANT_ID '+char(10);
	--SELECT @v_dSql += N'AND    B.USER_ID     = @v_user_id '+char(10);
	--SELECT @v_dSql += N') '+char(10);
	--SELECT @v_dSql += N'AND    B.ACTIVE_FLAG = 'Y' '+char(10);
	--SELECT @v_dSql += N'AND    A.COMPANY_ID  = B.COMPANY_ID '+char(10);
	--SELECT @v_dSql += N'AND    A.DIVISION_ID = B.DIVISION_ID '+char(10);
	--SELECT @v_dSql += N'AND    A.SITE_ID     = B.SITE_ID '+char(10);
	--SELECT @v_dSql += N'AND    A.ITEM_ID     = B.ITEM_ID '+char(10);
	--SELECT @v_dSql += N'AND    CONVERT(VARCHAR, A.SHIP_DATE, 112) BETWEEN #DUE_FROM_DATE# AND #DUE_TO_DATE# '+char(10);
	--SELECT @v_dSql += N'[AND    A.SITE_ID = #SITE_ID#] '+char(10);
	--SELECT @v_dSql += N'[AND    A.TO_SITE_ID = #TO_SITE_ID#] '+char(10);
	--SELECT @v_dSql += N'[AND    UPPER(A.ITEM_ID) LIKE '%' + UPPER(#ITEM_ID#) + '%'] '+char(10);
	--SELECT @v_dSql += N'[AND    A.SHOP_GROUP_ID = #SHOP_GROUP_ID#] '+char(10);
	--SELECT @v_dSql += N'{ '+char(10);
	--SELECT @v_dSql += N'var sql = ""; '+char(10);
	--SELECT @v_dSql += N'if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){ '+char(10);
	--SELECT @v_dSql += N' sql+= "AND    A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n"; '+char(10);
	--SELECT @v_dSql += N'} '+char(10);
	--SELECT @v_dSql += N'sql; '+char(10);
	--SELECT @v_dSql += N'} '+char(10);
	--SELECT @v_dSql += N'{ '+char(10);
	--SELECT @v_dSql += N'var sql = ""; '+char(10);
	--SELECT @v_dSql += N'if($data.PLANT_LT != null && $data.PLANT_LT != ""){ '+char(10);
	--SELECT @v_dSql += N' sql+= "AND    A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n"; '+char(10);
	--SELECT @v_dSql += N'} '+char(10);
	--SELECT @v_dSql += N'sql; '+char(10);
	--SELECT @v_dSql += N'} '+char(10);
	--SELECT @v_dSql += N'AND    A.DOC_TYPE NOT IN ('D10', 'D90' )  '+char(10);
	--SELECT @v_dSql += N'ORDER BY A.DIVISION_ID, A.SITE_ID, a.plant_id, a.item_id, A.CUTOFF_DATE, A.SEQ, A.SHOP_GROUP_ID, A.TO_SITE_ID '+char(10);


	SET @v_dSql += '    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,   ' + char(10)
	SET @v_dSql += '		CONVERT(VARCHAR, A.CUTOFF_DATE, 112) AS CUTOFF_DATE, A.SEQ, A.SHOP_GROUP_ID, A.ITEM_ID, A.QTY, ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME, 																			 ' + char(10)
	SET @v_dSql += '		CONVERT(VARCHAR, A.SHIP_DATE, 120) AS SHIP_DATE, A.TO_SITE_ID, A.TO_PLANT_ID, A.CUSTOMER_ID, 		 ' + char(10)
	SET @v_dSql += '		A.UPDATE_ID, CONVERT(VARCHAR, A.UPDATE_TIME, 120) AS UPDATE_TIME                                                                                  ' + char(10)                             
	SET @v_dSql += '		 FROM   SCM_SHIPPING_RESULT_H A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK)  																							 ' + char(10)
	SET @v_dSql += '		 WHERE  EXISTS (  		 ' + char(10)
	SET @v_dSql += '		SELECT 1                                       ' + char(10)                                             
	SET @v_dSql += '		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)																	 ' + char(10)
	SET @v_dSql += '		WHERE  A.COMPANY_ID  = B.COMPANY_ID  								 ' + char(10)
	SET @v_dSql += '		AND    A.DIVISION_ID = B.DIVISION_ID                                                                                          ' + char(10)                     
	SET @v_dSql += '		AND    A.SITE_ID     = B.SITE_ID																	 ' + char(10)
	SET @v_dSql += '		AND    A.PLANT_ID    = B.PLANT_ID																										 ' + char(10)
	SET @v_dSql += '		 AND    B.USER_ID     = ''' + @p_user_id +  '''' + char(10)  
	SET @v_dSql += '		)				   ' + char(10)
	SET @v_dSql += '		 AND    B.ACTIVE_FLAG = ''Y'' 	   ' + char(10)
	SET @v_dSql += '		AND    A.COMPANY_ID  = B.COMPANY_ID														   ' + char(10)
	SET @v_dSql += '		AND    A.DIVISION_ID = B.DIVISION_ID 															   ' + char(10)
	SET @v_dSql += '		AND    A.SITE_ID     = B.SITE_ID	   ' + char(10)
	SET @v_dSql += '	    AND    A.ITEM_ID     = B.ITEM_ID  ' + char(10)
	
	SET @v_dSql += '		AND    CONVERT(VARCHAR, A.SHIP_DATE, 112) BETWEEN ' + @v_bucket_from + ' AND ' +  @v_bucket_to  +  char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
	IF(LEN(@p_item_id) > 0 )
	BEGIN
		SELECT @v_dSql += ' AND   A.ITEM_ID LIKE ''%'+ @p_item_id + '%''    ' + char(10)
	END
	SET @v_dSql += '	AND A.DOC_TYPE NOT IN (''D10'', ''D90'' ) -- D10 DO 생성, D90 DO 삭제 by kimcd 2018-09-10   ' + char(10)
	SET @v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, a.plant_id, a.item_id, A.CUTOFF_DATE, A.SEQ, A.SHOP_GROUP_ID, A.TO_SITE_ID ' + char(10)
	
END


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
