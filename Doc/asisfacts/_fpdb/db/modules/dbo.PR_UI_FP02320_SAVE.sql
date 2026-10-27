

/*
 * Program ID   : PR_UI_FP02320_SAVE
 * Description  : Site(BOD)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/22   CYS				Initial Release UI통합
 * 2022/04/11   KSI				pan&roll cake data save
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02320_SAVE]
  @p_sys_type			    NVARCHAR(MAX),  
  @p_sys_flag			    NVARCHAR(MAX),
  @p_sys_gubun			    NVARCHAR(MAX),  
  @p_user_id			    NVARCHAR(MAX),

  @p_company_id        	    NVARCHAR(MAX),
  @p_division_id            NVARCHAR(MAX),
  @p_site_id                NVARCHAR(MAX),
  @p_plant_id               NVARCHAR(MAX),
  @p_factory_id             NVARCHAR(MAX),
  @p_item_id			    NVARCHAR(MAX),
  @p_lane_qty		        NVARCHAR(MAX),
  @p_main_lane_qty		    NVARCHAR(MAX),
  @p_sub_lane_qty           NVARCHAR(MAX),
  @p_pattern_qty            NVARCHAR(MAX),
  @p_half_slit_flag         NVARCHAR(MAX),
  @p_slit_width             NVARCHAR(MAX),
  @p_pc_roll_length         NVARCHAR(MAX),
  @p_pc_roll_length_uom     NVARCHAR(MAX),
  @p_prod_version_type      NVARCHAR(MAX),
  @p_prod_version_type_org	NVARCHAR(MAX),
  @p_jumbo_roll_length	    NVARCHAR(MAX),
  @p_description            NVARCHAR(MAX),
  @p_active_flag            NVARCHAR(MAX)
  
AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                    
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02320_SAVE';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	DECLARE @v_dSql2			nvarchar(MAX)='';
	DECLARE @v_log_message	NVARCHAR(MAX) = '';
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	        INTEGER = 0;
	DECLARE @recv_active_flag       NVARCHAR(MAX);		
	DECLARE @v_delimiter            NVARCHAR(1);

	DECLARE @v_sys_type			    NVARCHAR(MAX);  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag			    NVARCHAR(MAX);  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun				NVARCHAR(MAX); 
	DECLARE @v_user_id			    NVARCHAR(MAX);
	
	DECLARE @v_company_id        	NVARCHAR(MAX);		
	DECLARE @v_division_id          NVARCHAR(MAX);
	DECLARE @v_site_id              NVARCHAR(MAX);
	DECLARE @v_plant_id             NVARCHAR(MAX);
	DECLARE @v_factory_id           NVARCHAR(MAX);
	DECLARE @v_item_id			    NVARCHAR(MAX);
	DECLARE @v_lane_qty		        NVARCHAR(MAX);
	DECLARE @v_main_lane_qty			NVARCHAR(MAX);
	DECLARE @v_sub_lane_qty         NVARCHAR(MAX);
	DECLARE @v_pattern_qty          NVARCHAR(MAX);
	DECLARE @v_half_slit_flag       NVARCHAR(MAX);
	DECLARE @v_slit_width           NVARCHAR(MAX);
	DECLARE @v_pc_roll_length       NVARCHAR(MAX);
	DECLARE @v_pc_roll_length_uom   NVARCHAR(MAX);
	DECLARE @v_jumbo_roll_length   NVARCHAR(MAX);
	
	DECLARE @v_prod_version_type    NVARCHAR(MAX);
	DECLARE @v_prod_version_type_org	NVARCHAR(MAX);
	DECLARE @v_description          NVARCHAR(MAX);
	DECLARE @v_active_flag          NVARCHAR(MAX);


	SET @recv_active_flag       = @p_sys_flag;
	SET @v_delimiter            = '^';  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter); -- 프로시저 LOOP 길이를 판단 
	
	
	BEGIN TRY
		BEGIN TRAN		

			BEGIN 
				--max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
				WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
					BEGIN --WHILE 내(START)

					
					 
						BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
							SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

							SET @v_sys_type			    = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_type			    ,@v_delimiter, @mst_loop_cnt );
							SET @v_sys_flag			    = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_flag			    ,@v_delimiter, @mst_loop_cnt );
							SET @v_sys_gubun				= [dbo].[SCM_ARR_SPL_VAL]( @p_sys_gubun			    ,@v_delimiter, @mst_loop_cnt );
							SET @v_user_id			    = [dbo].[SCM_ARR_SPL_VAL]( @p_user_id			    ,@v_delimiter, @mst_loop_cnt );
							
							SET @v_company_id        	= [dbo].[SCM_ARR_SPL_VAL]( @p_company_id    			, @v_delimiter, @mst_loop_cnt );    	
							SET @v_division_id          = [dbo].[SCM_ARR_SPL_VAL]( @p_division_id           , @v_delimiter, @mst_loop_cnt );
							SET @v_site_id              = [dbo].[SCM_ARR_SPL_VAL]( @p_site_id               , @v_delimiter, @mst_loop_cnt );
							SET @v_plant_id             = [dbo].[SCM_ARR_SPL_VAL]( @p_plant_id              , @v_delimiter, @mst_loop_cnt );
							SET @v_factory_id           = [dbo].[SCM_ARR_SPL_VAL]( @p_factory_id            , @v_delimiter, @mst_loop_cnt );
							SET @v_item_id			    = [dbo].[SCM_ARR_SPL_VAL]( @p_item_id			    , @v_delimiter, @mst_loop_cnt );
							SET @v_lane_qty		        = [dbo].[SCM_ARR_SPL_VAL]( @p_lane_qty		        , @v_delimiter, @mst_loop_cnt );
							SET @v_main_lane_qty			= [dbo].[SCM_ARR_SPL_VAL]( @p_main_lane_qty		    , @v_delimiter, @mst_loop_cnt );
							SET @v_sub_lane_qty         = [dbo].[SCM_ARR_SPL_VAL]( @p_sub_lane_qty          , @v_delimiter, @mst_loop_cnt );
							SET @v_pattern_qty          = [dbo].[SCM_ARR_SPL_VAL]( @p_pattern_qty           , @v_delimiter, @mst_loop_cnt );
							SET @v_half_slit_flag       = [dbo].[SCM_ARR_SPL_VAL]( @p_half_slit_flag        , @v_delimiter, @mst_loop_cnt );
							SET @v_slit_width           = [dbo].[SCM_ARR_SPL_VAL]( @p_slit_width            , @v_delimiter, @mst_loop_cnt );
							SET @v_pc_roll_length       = [dbo].[SCM_ARR_SPL_VAL]( @p_pc_roll_length        , @v_delimiter, @mst_loop_cnt );
							SET @v_pc_roll_length_uom   = [dbo].[SCM_ARR_SPL_VAL]( @p_pc_roll_length_uom    , @v_delimiter, @mst_loop_cnt );
							SET @v_jumbo_roll_length   = [dbo].[SCM_ARR_SPL_VAL]( @p_jumbo_roll_length    , @v_delimiter, @mst_loop_cnt );

							SET @v_prod_version_type    = [dbo].[SCM_ARR_SPL_VAL]( @p_prod_version_type     , @v_delimiter, @mst_loop_cnt );
							SET @v_prod_version_type_org = [dbo].[SCM_ARR_SPL_VAL]( @p_prod_version_type_org , @v_delimiter, @mst_loop_cnt );
							SET @v_description          = [dbo].[SCM_ARR_SPL_VAL]( @p_description           , @v_delimiter, @mst_loop_cnt );
							SET @v_active_flag          = [dbo].[SCM_ARR_SPL_VAL]( @p_active_flag           , @v_delimiter, @mst_loop_cnt );
							
							--IF LEN(@v_voyage_day) = 0 BEGIN SET @v_voyage_day = null END
							--IF LEN(@v_inbound_day) = 0 BEGIN SET @v_inbound_day = null END
							--IF LEN(@v_in_buffer_day) = 0 BEGIN SET @v_in_buffer_day = null END

						END
						
						-- numeric 에 null 값을 넣기 위해서 변수 선언
						-- 다른 방법이 있으면 변경하는 방향으로...

						DECLARE @v_lane_qty2 NVARCHAR(10) = 'X';
						DECLARE @v_main_lane_qty2 NVARCHAR(10) = 'X';
						DECLARE @v_sub_lane_qty2 NVARCHAR(10) = 'X';
						DECLARE @v_pattern_qty2 NVARCHAR(10) = 'X';
						DECLARE @v_pc_roll_length2 NVARCHAR(10) = 'X';
						DECLARE @v_jumbo_roll_length2 NVARCHAR(10) = 'X';
						DECLARE @v_slit_width2 NVARCHAR(10) = 'X';


						IF LEN(@v_lane_qty) = 0 BEGIN SET @v_lane_qty = 0; SET @v_lane_qty2 = 'NULL'; END
						IF LEN(@v_main_lane_qty) = 0 BEGIN SET @v_main_lane_qty = 0; SET @v_main_lane_qty2 = 'NULL'; END
						IF LEN(@v_sub_lane_qty) = 0 BEGIN SET @v_sub_lane_qty = 0; SET @v_sub_lane_qty2 = 'NULL'; END
						IF LEN(@v_pattern_qty) = 0 BEGIN SET @v_pattern_qty = 0;SET @v_pattern_qty2 = 'NULL'; END
						IF LEN(@v_pc_roll_length) = 0 BEGIN SET @v_pc_roll_length = 0; SET @v_pc_roll_length2 = 'NULL';END
						IF LEN(@v_jumbo_roll_length) = 0 BEGIN SET @v_jumbo_roll_length = 0; SET @v_jumbo_roll_length2 = 'NULL';END
						IF LEN(@v_slit_width) = 0 BEGIN SET @v_slit_width = 0; SET @v_slit_width2 = 'NULL'; END
						

						BEGIN
							
						IF (@v_sys_flag = 'I' OR @v_sys_flag = 'U')
							BEGIN
								
								SELECT @v_dSql =  N''
								SELECT @v_dSql += N'   BEGIN         ' + char(10)
								SELECT @v_dSql += N'		BEGIN  TRAN       ' + char(10)
								
								SELECT @v_dSql +=  N'if exists ( '
								SELECT @v_dSql +=  N'				SELECT  * from SCM_ITEM_LANE_M '
								SELECT @v_dSql +=  N'				where '
								SELECT @v_dSql += N'		    COMPANY_ID  = '''+ @v_company_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND DIVISION_ID = '''+ @v_division_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND SITE_ID     = '''+ @v_site_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND PLANT_ID    = '''+ @v_plant_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND FACTORY_ID  = '''+ @v_factory_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND ITEM_ID     = '''+ @v_item_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND LANE_QTY    = CONVERT(NUMERIC,'''+ @v_lane_qty +''' ) ' + char(10)
								SELECT @v_dSql += N'		    AND PROD_VERSION_TYPE    = '''+ @v_prod_version_type_org +'''' + char(10)
								SELECT @v_dSql +=  N' ) '
								SELECT @v_dSql +=  N'BEGIN '
								
								SELECT @v_dSql += N'		  UPDATE  SCM_ITEM_LANE_M SET                                      ' + char(10)
								
						        SELECT @v_dSql += N'		          LANE_QTY       = (case when '''+@v_lane_qty2+''' = ''NULL'' then null else '+@v_lane_qty+' end) ,   ' + char(10)
						        SELECT @v_dSql += N'		          MAIN_LANE_QTY       = (case when '''+@v_main_lane_qty2+''' = ''NULL'' then null else '+@v_main_lane_qty+' end) ,   ' + char(10)
								SELECT @v_dSql += N'		          SUB_LANE_QTY        = (case when '''+@v_sub_lane_qty2+''' = ''NULL'' then null else '+@v_sub_lane_qty+' end) ,    ' + char(10)
								SELECT @v_dSql += N'		          PATTERN_QTY         = (case when '''+@v_pattern_qty2+''' = ''NULL'' then null else '+@v_pattern_qty+' end) ,     ' + char(10)
								SELECT @v_dSql += N'		          HALF_SLIT_FLAG      = '''+ @v_half_slit_flag +''' ,  ' + char(10)
								SELECT @v_dSql += N'		          ACTIVE_FLAG         = '''+ @v_active_flag +''' ,          ' + char(10)
								SELECT @v_dSql += N'		          DESCRIPTION         = '''+ @v_description +''' ,     ' + char(10)
								SELECT @v_dSql += N'		          SLIT_WIDTH          = (case when '''+@v_slit_width2+''' = ''NULL'' then null else '+@v_slit_width+' end) ,      ' + char(10)
								SELECT @v_dSql += N'		          PC_ROLL_LENGTH      = (case when '''+@v_pc_roll_length2+''' = ''NULL'' then null else '+@v_pc_roll_length+' end) ,  ' + char(10)
								SELECT @v_dSql += N'		          JUMBO_ROLL_LENGTH      = (case when '''+@v_jumbo_roll_length2+''' = ''NULL'' then null else '+@v_jumbo_roll_length+' end) ,  ' + char(10)
								SELECT @v_dSql += N'		          PC_ROLL_LENGTH_UOM  = '''+ @v_pc_roll_length_uom +''' ,                                                           ' + char(10)
								SELECT @v_dSql += N'		          PROD_VERSION_TYPE   = '''+ @v_prod_version_type +''' ,                                                            ' + char(10)
								SELECT @v_dSql += N'		          UPDATE_ID           = '''+ @v_user_id +''' ,         ' + char(10)
								SELECT @v_dSql += N'		          UPDATE_TIME         = dbo.SYSDATE1()  ' + char(10)
								SELECT @v_dSql += N'		   WHERE ' + char(10)
								SELECT @v_dSql += N'		    COMPANY_ID  = '''+ @v_company_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND DIVISION_ID = '''+ @v_division_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND SITE_ID     = '''+ @v_site_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND PLANT_ID    = '''+ @v_plant_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND FACTORY_ID  = '''+ @v_factory_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND ITEM_ID     = '''+ @v_item_id +'''' + char(10)
								SELECT @v_dSql += N'		    AND LANE_QTY    = CONVERT(NUMERIC,'''+ @v_lane_qty +''' ) ' + char(10)
								SELECT @v_dSql += N'		    AND PROD_VERSION_TYPE    = '''+ @v_prod_version_type_org +'''' + char(10)
				
								SELECT @v_dSql +=  N'END '
								SELECT @v_dSql +=  N'ELSE '
								SELECT @v_dSql +=  N'BEGIN '
								
								
								SELECT @v_dSql += N'		MERGE INTO SCM_ITEM_LANE_M A                                  ' + char(10)
								SELECT @v_dSql += N'		USING (SELECT '''+ @v_company_id +'''  AS COMPANY_ID, '''+ @v_division_id +'''  AS DIVISION_ID,            ' + char(10)
								SELECT @v_dSql += N'		              '''+ @v_site_id +'''  AS SITE_ID, '''+ @v_plant_id +'''  AS PLANT_ID, '''+ @v_factory_id +'''  AS FACTORY_ID,         ' + char(10)
								SELECT @v_dSql += N'		              '''+ @v_item_id +'''  AS ITEM_ID, CONVERT(NUMERIC,'''+ @v_lane_qty +''' )  AS LANE_QTY, '''+ @v_prod_version_type +'''  AS PROD_VERSION_TYPE, '''+ @v_prod_version_type_org +'''  AS PROD_VERSION_TYPE_ORG) B       ' + char(10)
								SELECT @v_dSql += N'		ON (    A.COMPANY_ID  = B.COMPANY_ID              ' + char(10)
								SELECT @v_dSql += N'		    AND A.DIVISION_ID = B.DIVISION_ID             ' + char(10)
								SELECT @v_dSql += N'		    AND A.SITE_ID     = B.SITE_ID                 ' + char(10)
								SELECT @v_dSql += N'		    AND A.PLANT_ID    = B.PLANT_ID                ' + char(10)
								SELECT @v_dSql += N'		    AND A.FACTORY_ID  = B.FACTORY_ID              ' + char(10)
								SELECT @v_dSql += N'		    AND A.ITEM_ID     = B.ITEM_ID                 ' + char(10)
								SELECT @v_dSql += N'		    AND A.LANE_QTY    = B.LANE_QTY                ' + char(10)
								SELECT @v_dSql += N'		    AND A.PROD_VERSION_TYPE    = B.PROD_VERSION_TYPE      ' + char(10)
								SELECT @v_dSql += N'		)                                                 ' + char(10)
								SELECT @v_dSql += N'		WHEN MATCHED THEN                                 ' + char(10)
								SELECT @v_dSql += N'		  UPDATE SET                                      ' + char(10)
						        SELECT @v_dSql += N'		          A.LANE_QTY       = (case when '''+@v_lane_qty2+''' = ''NULL'' then null else '+@v_lane_qty+' end) ,   ' + char(10)
								SELECT @v_dSql += N'		          A.MAIN_LANE_QTY       = (case when '''+@v_main_lane_qty2+''' = ''NULL'' then null else '+@v_main_lane_qty+' end) ,   ' + char(10)
								SELECT @v_dSql += N'		          A.SUB_LANE_QTY        = (case when '''+@v_sub_lane_qty2+''' = ''NULL'' then null else '+@v_sub_lane_qty+' end) ,    ' + char(10)
								SELECT @v_dSql += N'		          A.PATTERN_QTY         = (case when '''+@v_pattern_qty2+''' = ''NULL'' then null else '+@v_pattern_qty+' end) ,     ' + char(10)
								SELECT @v_dSql += N'		          A.HALF_SLIT_FLAG      = '''+ @v_half_slit_flag +''' ,  ' + char(10)
								SELECT @v_dSql += N'		          A.ACTIVE_FLAG         = '''+ @v_active_flag +''' ,          ' + char(10)
								SELECT @v_dSql += N'		          A.DESCRIPTION         = '''+ @v_description +''' ,     ' + char(10)
								SELECT @v_dSql += N'		          A.SLIT_WIDTH          = (case when '''+@v_slit_width2+''' = ''NULL'' then null else '+@v_slit_width+' end) ,      ' + char(10)
								SELECT @v_dSql += N'		          A.PC_ROLL_LENGTH      = (case when '''+@v_pc_roll_length2+''' = ''NULL'' then null else '+@v_pc_roll_length+' end) ,  ' + char(10)
								SELECT @v_dSql += N'		          A.JUMBO_ROLL_LENGTH      = (case when '''+@v_jumbo_roll_length2+''' = ''NULL'' then null else '+@v_jumbo_roll_length+' end) ,  ' + char(10)
								SELECT @v_dSql += N'		          A.PC_ROLL_LENGTH_UOM  = '''+ @v_pc_roll_length_uom +''' ,                                                           ' + char(10)
								SELECT @v_dSql += N'		          A.PROD_VERSION_TYPE   = '''+ @v_prod_version_type +''' ,                                                            ' + char(10)
								SELECT @v_dSql += N'		          A.UPDATE_ID           = '''+ @v_user_id +''' ,         ' + char(10)
								SELECT @v_dSql += N'		          A.UPDATE_TIME         = dbo.SYSDATE1()  ' + char(10)
								SELECT @v_dSql += N'		WHEN NOT MATCHED THEN                             ' + char(10)
								SELECT @v_dSql += N'		  INSERT (                                        ' + char(10)
								SELECT @v_dSql += N'		      COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY,                                           ' + char(10)
								SELECT @v_dSql += N'		      MAIN_LANE_QTY, SUB_LANE_QTY, PATTERN_QTY, HALF_SLIT_FLAG, DESCRIPTION, ACTIVE_FLAG, SLIT_WIDTH,                      ' + char(10)
								SELECT @v_dSql += N'		      PC_ROLL_LENGTH, JUMBO_ROLL_LENGTH, PC_ROLL_LENGTH_UOM,PROD_VERSION_TYPE,   ' + char(10)
								SELECT @v_dSql += N'		      INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME          ' + char(10)
								SELECT @v_dSql += N'		  )                                               ' + char(10)
								SELECT @v_dSql += N'		  VALUES (                                        ' + char(10)
								SELECT @v_dSql += N'		      '''+ @v_company_id +''' , '''+ @v_division_id +''' , '''+ @v_site_id +''' , '''+ @v_plant_id +''' , '''+ @v_factory_id +''' , '''+ @v_item_id +''' ,         ' + char(10)
								SELECT @v_dSql += N'		      CONVERT(NUMERIC,'''+ @v_lane_qty +''' ) ,                                       ' + char(10)
								SELECT @v_dSql += N'		      (case when '''+@v_main_lane_qty2+''' = ''NULL'' then null else '+@v_main_lane_qty+' end) ,			' + char(10)
								SELECT @v_dSql += N'		      (case when '''+@v_sub_lane_qty2+''' = ''NULL'' then null else '+@v_sub_lane_qty+' end) ,			' + char(10)
								SELECT @v_dSql += N'		      (case when '''+@v_pattern_qty2+''' = ''NULL'' then null else '+@v_pattern_qty+' end) ,			' + char(10)
								SELECT @v_dSql += N'		      '''+ @v_half_slit_flag +''' , '''+ @v_description +''' , '''+ @v_active_flag +''' , 		' + char(10)
								SELECT @v_dSql += N'		      (case when '''+@v_slit_width2+''' = ''NULL'' then null else '+@v_slit_width+' end) ,			' + char(10)
								SELECT @v_dSql += N'		      (case when '''+@v_pc_roll_length2+''' = ''NULL'' then null else '+@v_pc_roll_length+' end) ,  		' + char(10)
								SELECT @v_dSql += N'		      (case when '''+@v_jumbo_roll_length2+''' = ''NULL'' then null else '+@v_jumbo_roll_length+' end) ,  		' + char(10)
								SELECT @v_dSql += N'		      '''+ @v_pc_roll_length_uom +''' ,'''+ @v_prod_version_type +''' ,                               ' + char(10)
								SELECT @v_dSql += N'		      '''+ @v_user_id +''' , dbo.SYSDATE1(), '''+ @v_user_id +''' , dbo.SYSDATE1()                                               ' + char(10)
								SELECT @v_dSql += N'		  )                                               ' + char(10)
								SELECT @v_dSql += N'		;                                                 ' + char(10)
								SELECT @v_dSql += N'	  ' + char(10)								
								
								SELECT @v_dSql +=  N'END '
								

								SELECT @v_dSql += N'		INSERT INTO HIS_ITEM_LANE_M (                     ' + char(10)
								SELECT @v_dSql += N'		        COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY,                                         ' + char(10)
								SELECT @v_dSql += N'		        MAIN_LANE_QTY, SUB_LANE_QTY, PATTERN_QTY, HALF_SLIT_FLAG, DESCRIPTION, ACTIVE_FLAG, SLIT_WIDTH,                    ' + char(10)
								SELECT @v_dSql += N'		        PC_ROLL_LENGTH, PC_ROLL_LENGTH_UOM, PROD_VERSION_TYPE,' + char(10)
								SELECT @v_dSql += N'		        INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,       ' + char(10)
								SELECT @v_dSql += N'		        JOB_USER_ID, JOB_TIME, JOB_TYPE           ' + char(10)
								SELECT @v_dSql += N'		)                                                 ' + char(10)
								SELECT @v_dSql += N'		SELECT  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY,                                         ' + char(10)
								SELECT @v_dSql += N'		        MAIN_LANE_QTY, SUB_LANE_QTY, PATTERN_QTY, HALF_SLIT_FLAG, DESCRIPTION, ACTIVE_FLAG, SLIT_WIDTH,                    ' + char(10)
								SELECT @v_dSql += N'		        PC_ROLL_LENGTH, PC_ROLL_LENGTH_UOM, PROD_VERSION_TYPE,' + char(10)
								SELECT @v_dSql += N'		        INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,       ' + char(10)
								SELECT @v_dSql += N'		        '''+ @v_user_id +''' , dbo.SYSDATE1(), ''INSERT''        ' + char(10)
								SELECT @v_dSql += N'		FROM    SCM_ITEM_LANE_M A WITH(NOLOCK)            ' + char(10)
								SELECT @v_dSql += N'		WHERE   A.COMPANY_ID  = '''+ @v_company_id +'''      ' + char(10)
								SELECT @v_dSql += N'		AND     A.DIVISION_ID = '''+ @v_division_id +'''     ' + char(10)
								SELECT @v_dSql += N'		AND     A.SITE_ID     = '''+ @v_site_id +'''         ' + char(10)
								SELECT @v_dSql += N'		AND     A.PLANT_ID    = '''+ @v_plant_id +'''        ' + char(10)
								SELECT @v_dSql += N'		AND     A.FACTORY_ID  = '''+ @v_factory_id +'''      ' + char(10)
								SELECT @v_dSql += N'		AND     A.ITEM_ID     = '''+ @v_item_id +'''         ' + char(10)
								SELECT @v_dSql += N'		AND     A.LANE_QTY    = CONVERT(NUMERIC,'''+ @v_lane_qty +''' )  ' + char(10)
								SELECT @v_dSql += N'		;                                                 ' + char(10)
								SELECT @v_dSql += N'		COMMIT;                                                  ' + char(10)

							

								SELECT @v_dSql += N' END;                                                  ' + char(10)

								--print '@v_dSql :: ' + @v_dSql 


							END

							IF (@v_sys_flag = 'D')
							BEGIN
								
								SET @v_dSql = ''
								SET @v_dSql += '	BEGIN    																										' + char(10)
								SET @v_dSql += '	                                       ' + char(10)
								SET @v_dSql += '		INSERT INTO HIS_ITEM_LANE_M (      ' + char(10)
								SET @v_dSql += '		        COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY,                          ' + char(10)
								SET @v_dSql += '		        MAIN_LANE_QTY, SUB_LANE_QTY, PATTERN_QTY, HALF_SLIT_FLAG, DESCRIPTION, ACTIVE_FLAG, SLIT_WIDTH,     ' + char(10)
								SET @v_dSql += '		        PC_ROLL_LENGTH, PC_ROLL_LENGTH_UOM,PROD_VERSION_TYPE,                                               ' + char(10)
								SET @v_dSql += '		        INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,                                                     ' + char(10)
								SET @v_dSql += '		        JOB_USER_ID, JOB_TIME, JOB_TYPE        ' + char(10)
								SET @v_dSql += '		)                                  ' + char(10)
								SET @v_dSql += '		SELECT  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY,                          ' + char(10)
								SET @v_dSql += '		        MAIN_LANE_QTY, SUB_LANE_QTY, PATTERN_QTY, HALF_SLIT_FLAG, DESCRIPTION, ACTIVE_FLAG, SLIT_WIDTH,     ' + char(10)
								SET @v_dSql += '		        PC_ROLL_LENGTH, PC_ROLL_LENGTH_UOM,PROD_VERSION_TYPE,                                               ' + char(10)
								SET @v_dSql += '		        INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,                                                     ' + char(10)
								SET @v_dSql += '		        '''+ @v_user_id +''', dbo.SYSDATE1(), ''DELETE''                                                       ' + char(10)
								SET @v_dSql += '		FROM    SCM_ITEM_LANE_M A WITH(NOLOCK)         ' + char(10)
								SET @v_dSql += '		WHERE   A.COMPANY_ID  = '''+ @v_company_id +'''   ' + char(10)
								SET @v_dSql += '		AND     A.DIVISION_ID = '''+ @v_division_id +'''  ' + char(10)
								SET @v_dSql += '		AND     A.SITE_ID     = '''+ @v_site_id +'''      ' + char(10)
								SET @v_dSql += '		AND     A.PLANT_ID    = '''+ @v_plant_id +'''     ' + char(10)
								SET @v_dSql += '		AND     A.FACTORY_ID  = '''+ @v_factory_id +'''   ' + char(10)
								SET @v_dSql += '		AND     A.ITEM_ID     = '''+ @v_item_id +'''      ' + char(10)
								SET @v_dSql += '		AND     A.LANE_QTY    = CONVERT(NUMERIC,'''+ @v_lane_qty +''')                                                 ' + char(10)
								SET @v_dSql += '		AND		A.PROD_VERSION_TYPE = '''+ @v_prod_version_type +'''                                                   ' + char(10)
								SET @v_dSql += '		;                                  ' + char(10)
								SET @v_dSql += '		                                   ' + char(10)
								SET @v_dSql += '		DELETE SCM_ITEM_LANE_M             ' + char(10)
								SET @v_dSql += '		FROM SCM_ITEM_LANE_M A             ' + char(10)
								SET @v_dSql += '		WHERE  A.COMPANY_ID   = '''+ @v_company_id +'''   ' + char(10)
								SET @v_dSql += '		AND    A.DIVISION_ID  = '''+ @v_division_id +'''  ' + char(10)
								SET @v_dSql += '		AND    A.SITE_ID      = '''+ @v_site_id +'''      ' + char(10)
								SET @v_dSql += '		AND    A.PLANT_ID     = '''+ @v_plant_id +'''     ' + char(10)
								SET @v_dSql += '		AND    A.FACTORY_ID   = '''+ @v_factory_id +'''   ' + char(10)
								SET @v_dSql += '		AND    A.ITEM_ID      = '''+ @v_item_id +'''      ' + char(10)
								SET @v_dSql += '		AND    A.LANE_QTY     = '''+ @v_lane_qty +'''     ' + char(10)
								SET @v_dSql += '		AND	   A.PROD_VERSION_TYPE = '''+ @v_prod_version_type +'''                                                    ' + char(10)
								SET @v_dSql += '		;                                  ' + char(10)
								SET @v_dSql += '	                                       ' + char(10)
								SET @v_dSql += '	END;                                   ' + char(10)

							END

						END
						
						
						IF @p_sys_type = 'SQL'
						BEGIN
							select @v_dSql as [QUERY_VALUE]
						END ELSE BEGIN
							SET @runstart = GetDate()
							BEGIN TRY
									BEGIN TRAN
										exec sp_executesql @v_dSql
									COMMIT TRAN
							END TRY
							BEGIN CATCH
									ROLLBACK
							END CATCH
							SET @runend = GetDate()
							exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql, @p_sys_type,@runstart, @runend
						END

					END --WHILE 내(END)
			END
 		
		-- 트랜잭션 (COMMIT)
		COMMIT TRAN
		
		-- 수행결과 성공여부 RETURN
		IF @p_sys_type <> 'SQL'
			SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

	END TRY

	BEGIN CATCH                           
                                          
		ROLLBACK TRAN                      
		-- 에러나도 로그는 인서트                   
		SET @v_log_message = ERROR_MESSAGE()
		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_log_message,'excute',@runstart, @runend
        
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		
	END CATCH   
END

