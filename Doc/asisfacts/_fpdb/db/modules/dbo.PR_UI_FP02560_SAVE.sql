

/*
 * Program ID   : PR_UI_FP02560_SAVE
 * Description  : Site(BOD)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/22   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02560_SAVE]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_company_id        	  NVARCHAR(MAX),
  @p_division_id          NVARCHAR(MAX),
  @p_site_id              NVARCHAR(MAX),
  @p_plant_id             NVARCHAR(MAX),
  @p_to_site_id           NVARCHAR(MAX),
  @p_to_plant_id          NVARCHAR(MAX),
  @p_transport_mode       NVARCHAR(MAX),
  @p_transport_priority   NVARCHAR(MAX),
  @p_out_buffer_day       NVARCHAR(MAX),
  @p_outbound_day         NVARCHAR(MAX),
  @p_ship_port_day        NVARCHAR(MAX),
  @p_mon                  NVARCHAR(MAX),
  @p_tue                  NVARCHAR(MAX),
  @p_wed                  NVARCHAR(MAX),
  @p_thu                  NVARCHAR(MAX),
  @p_fri                  NVARCHAR(MAX),
  @p_sat                  NVARCHAR(MAX),
  @p_sun                  NVARCHAR(MAX),
  @p_voyage_day           NVARCHAR(MAX),
  @p_inbound_day          NVARCHAR(MAX),
  @p_in_buffer_day        NVARCHAR(MAX),
  @p_active_flag          NVARCHAR(MAX),
  @p_description          NVARCHAR(MAX)
  
AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                                                                                                                                                                                                                                               
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02560_SAVE';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	DECLARE @v_log_message	NVARCHAR(MAX) = '';
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	        INTEGER = 0;
	DECLARE @recv_active_flag       NVARCHAR(MAX);		
	DECLARE @v_delimiter            NVARCHAR(1);

	DECLARE @v_sys_type			    NVARCHAR(MAX);  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag			    NVARCHAR(MAX);  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun			NVARCHAR(MAX); 
	DECLARE @v_user_id			    NVARCHAR(MAX);
	
	DECLARE @v_company_id        	NVARCHAR(MAX);
	DECLARE @v_division_id          NVARCHAR(MAX);
	DECLARE @v_site_id              NVARCHAR(MAX);
	DECLARE @v_plant_id             NVARCHAR(MAX);
	DECLARE @v_to_site_id           NVARCHAR(MAX);
	DECLARE @v_to_plant_id          NVARCHAR(MAX);
	DECLARE @v_transport_mode       NVARCHAR(MAX);
	DECLARE @v_transport_priority   NVARCHAR(MAX);
	DECLARE @v_out_buffer_day       NVARCHAR(MAX);
	DECLARE @v_outbound_day         NVARCHAR(MAX);
	DECLARE @v_ship_port_day        NVARCHAR(MAX);
	DECLARE @v_mon                  NVARCHAR(MAX);
	DECLARE @v_tue                  NVARCHAR(MAX);
	DECLARE @v_wed                  NVARCHAR(MAX);
	DECLARE @v_thu                  NVARCHAR(MAX);
	DECLARE @v_fri                  NVARCHAR(MAX);
	DECLARE @v_sat                  NVARCHAR(MAX);
	DECLARE @v_sun                  NVARCHAR(MAX);
	DECLARE @v_voyage_day           NVARCHAR(MAX);
	DECLARE @v_inbound_day          NVARCHAR(MAX);
	DECLARE @v_in_buffer_day        NVARCHAR(MAX);
	DECLARE @v_active_flag          NVARCHAR(MAX);
	DECLARE @v_description          NVARCHAR(MAX);


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

							SET @v_sys_type			    = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_type			    ,@v_delimiter, @mst_loop_cnt);
							SET @v_sys_flag			    = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_flag			    ,@v_delimiter, @mst_loop_cnt);
							SET @v_sys_gubun			= [dbo].[SCM_ARR_SPL_VAL]( @p_sys_gubun			    ,@v_delimiter, @mst_loop_cnt);
							SET @v_user_id			    = [dbo].[SCM_ARR_SPL_VAL]( @p_user_id			    ,@v_delimiter, @mst_loop_cnt);
							
							SET @v_company_id         = [dbo].[SCM_ARR_SPL_VAL]( @p_company_id        	, @v_delimiter      	 , @mst_loop_cnt);
							SET @v_division_id        = [dbo].[SCM_ARR_SPL_VAL]( @p_division_id         , @v_delimiter         , @mst_loop_cnt);
							SET @v_site_id            = [dbo].[SCM_ARR_SPL_VAL]( @p_site_id             , @v_delimiter             , @mst_loop_cnt);
							SET @v_plant_id           = [dbo].[SCM_ARR_SPL_VAL]( @p_plant_id            , @v_delimiter            , @mst_loop_cnt);
							SET @v_to_site_id         = [dbo].[SCM_ARR_SPL_VAL]( @p_to_site_id          , @v_delimiter          , @mst_loop_cnt);
							SET @v_to_plant_id        = [dbo].[SCM_ARR_SPL_VAL]( @p_to_plant_id         , @v_delimiter         , @mst_loop_cnt);
							SET @v_transport_mode     = [dbo].[SCM_ARR_SPL_VAL]( @p_transport_mode      , @v_delimiter      , @mst_loop_cnt);
							SET @v_transport_priority = [dbo].[SCM_ARR_SPL_VAL]( @p_transport_priority  , @v_delimiter  , @mst_loop_cnt);
							SET @v_out_buffer_day     = [dbo].[SCM_ARR_SPL_VAL]( @p_out_buffer_day      , @v_delimiter      , @mst_loop_cnt);
							SET @v_outbound_day       = [dbo].[SCM_ARR_SPL_VAL]( @p_outbound_day        , @v_delimiter        , @mst_loop_cnt);
							SET @v_ship_port_day      = [dbo].[SCM_ARR_SPL_VAL]( @p_ship_port_day       , @v_delimiter       , @mst_loop_cnt);
							SET @v_mon                = [dbo].[SCM_ARR_SPL_VAL]( @p_mon                 , @v_delimiter                 , @mst_loop_cnt);
							SET @v_tue                = [dbo].[SCM_ARR_SPL_VAL]( @p_tue                 , @v_delimiter                 , @mst_loop_cnt);
							SET @v_wed                = [dbo].[SCM_ARR_SPL_VAL]( @p_wed                 , @v_delimiter                 , @mst_loop_cnt);
							SET @v_thu                = [dbo].[SCM_ARR_SPL_VAL]( @p_thu                 , @v_delimiter                 , @mst_loop_cnt);
							SET @v_fri                = [dbo].[SCM_ARR_SPL_VAL]( @p_fri                 , @v_delimiter                 , @mst_loop_cnt);
							SET @v_sat                = [dbo].[SCM_ARR_SPL_VAL]( @p_sat                 , @v_delimiter                 , @mst_loop_cnt);
							SET @v_sun                = [dbo].[SCM_ARR_SPL_VAL]( @p_sun                 , @v_delimiter                 , @mst_loop_cnt);
							SET @v_voyage_day         = [dbo].[SCM_ARR_SPL_VAL]( @p_voyage_day          , @v_delimiter          , @mst_loop_cnt);
							SET @v_inbound_day        = [dbo].[SCM_ARR_SPL_VAL]( @p_inbound_day         , @v_delimiter         , @mst_loop_cnt);
							SET @v_in_buffer_day      = [dbo].[SCM_ARR_SPL_VAL]( @p_in_buffer_day       , @v_delimiter       , @mst_loop_cnt);
							SET @v_active_flag        = [dbo].[SCM_ARR_SPL_VAL]( @p_active_flag         , @v_delimiter         , @mst_loop_cnt);
							SET @v_description        = [dbo].[SCM_ARR_SPL_VAL]( @p_description         , @v_delimiter         , @mst_loop_cnt);
							
							--IF LEN(@v_voyage_day) = 0 BEGIN SET @v_voyage_day = null END
							--IF LEN(@v_inbound_day) = 0 BEGIN SET @v_inbound_day = null END
							--IF LEN(@v_in_buffer_day) = 0 BEGIN SET @v_in_buffer_day = null END

						END
						
						-- numeric 에 null 값을 넣기 위해서 변수 선언
						-- 다른 방법이 있으면 변경하는 방향으로...

						DECLARE @v_transport_priority2 NVARCHAR(10) = 'X';
						DECLARE @v_out_buffer_day2 NVARCHAR(10) = 'X';
						DECLARE @v_outbound_day2 NVARCHAR(10) = 'X';
						DECLARE @v_ship_port_day2 NVARCHAR(10) = 'X';
						DECLARE @v_voyage_day2 NVARCHAR(10) = 'X';
						DECLARE @v_inbound_day2 NVARCHAR(10) = 'X';
						DECLARE @v_in_buffer_day2 NVARCHAR(10) = 'X';


						IF LEN(@v_transport_priority) = 0 BEGIN SET @v_transport_priority = 0; SET @v_transport_priority2 = 'NULL'; END
						IF LEN(@v_out_buffer_day) = 0 BEGIN SET @v_out_buffer_day = 0; SET @v_out_buffer_day2 = 'NULL'; END
						IF LEN(@v_outbound_day) = 0 BEGIN SET @v_outbound_day = 0; SET @v_outbound_day2 = 'NULL'; END
						IF LEN(@v_ship_port_day) = 0 BEGIN SET @v_ship_port_day = 0;SET @v_ship_port_day2 = 'NULL'; END
						IF LEN(@v_voyage_day) = 0 BEGIN SET @v_voyage_day = 0; SET @v_voyage_day2 = 'NULL';END
						IF LEN(@v_inbound_day) = 0 BEGIN SET @v_inbound_day = 0; SET @v_inbound_day2 = 'NULL'; END
						IF LEN(@v_in_buffer_day) = 0 BEGIN SET @v_in_buffer_day = 0; SET @v_in_buffer_day2 = 'NULL'; END

						BEGIN
							
							IF (@v_sys_flag = 'U')
							BEGIN
								
								SET @v_dSql = ''
								SET @v_dSql += '	BEGIN																		' + char(10) 
								SET @v_dSql += '																				' + char(10) 
								SET @v_dSql += '		UPDATE SCM_SHIPMENT_M													' + char(10) 
								SET @v_dSql += '		SET							' + char(10) 
								SET @v_dSql += '		   TRANSPORT_PRIORITY = (case when '''+@v_transport_priority2+''' = ''NULL'' then null else '+@v_transport_priority+' end)          ' + char(10) 
								SET @v_dSql += '		  , OUT_BUFFER_DAY = (case when '''+@v_out_buffer_day2+''' = ''NULL'' then null else '+@v_out_buffer_day+' end)          ' + char(10) 
								SET @v_dSql += '		  , OUTBOUND_DAY = (case when '''+@v_outbound_day2+''' = ''NULL'' then null else '+@v_outbound_day+' end)          ' + char(10) 
								SET @v_dSql += '		  , SHIP_PORT_DAY = (case when '''+@v_ship_port_day2+''' = ''NULL'' then null else '+@v_ship_port_day+' end)          ' + char(10) 
								--SET @v_dSql += '			TRANSPORT_PRIORITY = '+ @v_transport_priority +'				' + char(10) 
								--SET @v_dSql += '		  , OUT_BUFFER_DAY = '+ @v_OUT_BUFFER_DAY +'                        ' + char(10) 
								--SET @v_dSql += '		  , OUTBOUND_DAY = '+ @v_OUTBOUND_DAY +'                            ' + char(10) 
								--SET @v_dSql += '		  , SHIP_PORT_DAY = '+ @v_SHIP_PORT_DAY +'                          ' + char(10) 
								SET @v_dSql += '		  , MON = '''+ @v_MON +'''                                              ' + char(10) 
								SET @v_dSql += '		  , TUE = '''+ @v_TUE +'''                                              ' + char(10) 
								SET @v_dSql += '		  , WED = '''+ @v_WED +'''                                              ' + char(10) 
								SET @v_dSql += '		  , THU = '''+ @v_THU +'''                                              ' + char(10) 
								SET @v_dSql += '		  , FRI = '''+ @v_FRI +'''                                              ' + char(10) 
								SET @v_dSql += '		  , SAT = '''+ @v_SAT +'''                                              ' + char(10) 
								SET @v_dSql += '		  , SUN = '''+ @v_SUN +'''                                              ' + char(10) 
									
								SET @v_dSql += '		  , VOYAGE_DAY = (case when '''+@v_voyage_day2+''' = ''NULL'' then null else '+@v_voyage_day+' end)          ' + char(10) 
								SET @v_dSql += '		  , INBOUND_DAY = (case when '''+@v_INBOUND_DAY2+''' = ''NULL'' then null else '+@v_INBOUND_DAY+' end)          ' + char(10) 
								SET @v_dSql += '		  , IN_BUFFER_DAY = (case when '''+@v_IN_BUFFER_DAY2+''' = ''NULL'' then null else '+@v_IN_BUFFER_DAY+' end)          ' + char(10) 
								----SET @v_dSql += '		  , VOYAGE_DAY = '''+@v_INBOUND_DAY+'''                             ' + char(10) 
								----SET @v_dSql += '		  , INBOUND_DAY = '+ @v_INBOUND_DAY +'                              ' + char(10) 
								----SET @v_dSql += '		  , IN_BUFFER_DAY = '+ @v_IN_BUFFER_DAY +'                          ' + char(10) 
								SET @v_dSql += '		  , ACTIVE_FLAG = '''+ @v_ACTIVE_FLAG +'''                              ' + char(10) 
								SET @v_dSql += '		  , DESCRIPTION = N'''+ @v_DESCRIPTION +'''                              ' + char(10) 
								SET @v_dSql += '		  , UPDATE_ID = '''+ @v_USER_ID +'''                                    ' + char(10) 
								SET @v_dSql += '		  , UPDATE_TIME = dbo.SYSDATE1()                                        ' + char(10) 
								SET @v_dSql += '		WHERE COMPANY_ID = '''+ @v_COMPANY_ID +'''                              ' + char(10) 
								SET @v_dSql += '		AND   DIVISION_ID = '''+ @v_DIVISION_ID +'''                            ' + char(10) 
								SET @v_dSql += '		AND   SITE_ID = '''+ @v_SITE_ID +'''                                    ' + char(10) 
								SET @v_dSql += '		AND   PLANT_ID = '''+ @v_PLANT_ID +'''                                  ' + char(10) 
								SET @v_dSql += '		AND   TO_SITE_ID = '''+ @v_TO_SITE_ID +'''                              ' + char(10) 
								SET @v_dSql += '		AND   TO_PLANT_ID = '''+ @v_TO_PLANT_ID +'''                            ' + char(10) 
								SET @v_dSql += '		AND   TRANSPORT_MODE = '''+ @v_TRANSPORT_MODE +'''                      ' + char(10) 
								SET @v_dSql += '		;                                                                       ' + char(10) 
								
							
								SET @v_dSql += '		                                                                        ' + char(10)
								SET @v_dSql += '		INSERT INTO HIS_SHIPMENT_M                                              ' + char(10)
								SET @v_dSql += '		(COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,                            ' + char(10)
								SET @v_dSql += '		TO_SITE_ID, TO_PLANT_ID, TRANSPORT_MODE, TRANSPORT_PRIORITY,            ' + char(10)
								SET @v_dSql += '		OUT_BUFFER_DAY, OUTBOUND_DAY, SHIP_PORT_DAY,                            ' + char(10)
								SET @v_dSql += '		MON, TUE, WED, THU, FRI, SAT, SUN,                                      ' + char(10)
								SET @v_dSql += '		VOYAGE_DAY, INBOUND_DAY, IN_BUFFER_DAY, ACTIVE_FLAG,                    ' + char(10)
								SET @v_dSql += '		DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,            ' + char(10)
								SET @v_dSql += '		JOB_USER_ID, JOB_TIME, JOB_TYPE)                                        ' + char(10)
								SET @v_dSql += '		SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,                      ' + char(10)
								SET @v_dSql += '		    TO_SITE_ID, TO_PLANT_ID, TRANSPORT_MODE, TRANSPORT_PRIORITY,        ' + char(10)
								SET @v_dSql += '		    OUT_BUFFER_DAY, OUTBOUND_DAY, SHIP_PORT_DAY,                        ' + char(10)
								SET @v_dSql += '		    MON, TUE, WED, THU, FRI, SAT, SUN,                                  ' + char(10)
								SET @v_dSql += '		    VOYAGE_DAY, INBOUND_DAY, IN_BUFFER_DAY, ACTIVE_FLAG,                ' + char(10)
								SET @v_dSql += '		    DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,        ' + char(10)
								SET @v_dSql += '		    '''+ @v_USER_ID +''' , dbo.SYSDATE1(), ''UPDATE''                        ' + char(10)
								SET @v_dSql += '		FROM SCM_SHIPMENT_M(NOLOCK)                                             ' + char(10)
								SET @v_dSql += '		WHERE COMPANY_ID = '''+ @v_COMPANY_ID +'''                                 ' + char(10)
								SET @v_dSql += '		AND   DIVISION_ID = '''+ @v_DIVISION_ID +'''                               ' + char(10)
								SET @v_dSql += '		AND   SITE_ID = '''+ @v_SITE_ID +'''                                       ' + char(10)
								SET @v_dSql += '		AND   PLANT_ID = '''+ @v_PLANT_ID +'''                                     ' + char(10)
								SET @v_dSql += '		AND   TO_SITE_ID = '''+ @v_TO_SITE_ID +'''                                 ' + char(10)
								SET @v_dSql += '		AND   TO_PLANT_ID = '''+ @v_TO_PLANT_ID +'''                               ' + char(10)
								SET @v_dSql += '		AND   TRANSPORT_MODE = '''+ @v_TRANSPORT_MODE +'''                         ' + char(10)
								SET @v_dSql += '		;                                                                       ' + char(10)
								SET @v_dSql += '	END;                                                                        ' + char(10)
								print @v_dSql;
							END
							
							IF (@v_sys_flag = 'I')
							BEGIN
								
								SET @v_dSql = '';
								SET @v_dSql += '	BEGIN       																															' + char(10)
								SET @v_dSql += '	                                                                                                                                        ' + char(10)
								SET @v_dSql += '		INSERT INTO SCM_SHIPMENT_M                                                                                                          ' + char(10)
								SET @v_dSql += '		(COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,                                                                                        ' + char(10)
								SET @v_dSql += '		 TO_SITE_ID, TO_PLANT_ID, TRANSPORT_MODE, TRANSPORT_PRIORITY,                                                                       ' + char(10)
								SET @v_dSql += '		 OUT_BUFFER_DAY, OUTBOUND_DAY, SHIP_PORT_DAY,                                                                                       ' + char(10)
								SET @v_dSql += '		 MON, TUE, WED, THU, FRI, SAT, SUN,                                                                                                 ' + char(10)
								SET @v_dSql += '		 VOYAGE_DAY, INBOUND_DAY, IN_BUFFER_DAY, ACTIVE_FLAG,                                                                               ' + char(10)
								SET @v_dSql += '		 DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME)                                                                       ' + char(10)
								SET @v_dSql += '		VALUES (                                                                                                                            ' + char(10)
								SET @v_dSql += '		 '''+ @v_COMPANY_ID +''', '''+ @v_DIVISION_ID +''', '''+ @v_SITE_ID +''', '''+ @v_PLANT_ID +''',                                    ' + char(10)
								--SET @v_dSql += '		 '''+ @v_TO_SITE_ID +''', '''+ @v_TO_PLANT_ID +''', '''+ @v_TRANSPORT_MODE +''', '+ @v_TRANSPORT_PRIORITY +',                   ' + char(10)
								--SET @v_dSql += '		 '+ @v_OUT_BUFFER_DAY +', '+ @v_OUTBOUND_DAY +', '+ @v_SHIP_PORT_DAY +',                                                ' + char(10)
								SET @v_dSql += '		 '''+ @v_TO_SITE_ID +''', '''+ @v_TO_PLANT_ID +''', '''+ @v_TRANSPORT_MODE +'''                   ' + char(10)
								
								SET @v_dSql += '		  , (case when '''+@v_transport_priority2+''' = ''NULL'' then null else '+@v_transport_priority+' end)          ' + char(10) 
								SET @v_dSql += '		  , (case when '''+@v_out_buffer_day2+''' = ''NULL'' then null else '+@v_out_buffer_day+' end)          ' + char(10) 
								SET @v_dSql += '		  , (case when '''+@v_outbound_day2+''' = ''NULL'' then null else '+@v_outbound_day+' end)          ' + char(10) 
								SET @v_dSql += '		  , (case when '''+@v_ship_port_day2+''' = ''NULL'' then null else '+@v_ship_port_day+' end)          ' + char(10) 

								SET @v_dSql += '		 , '''+ @v_MON +''', '''+ @v_TUE +''', '''+ @v_WED +''', '''+ @v_THU +''', '''+ @v_FRI +''', '''+ @v_SAT +''', '''+ @v_SUN +'''      ' + char(10)
								
								--SET @v_dSql += '		 '+ @v_VOYAGE_DAY +', '+ @v_INBOUND_DAY +', '+ @v_IN_BUFFER_DAY +', '''+ @v_ACTIVE_FLAG +''',                           ' + char(10)
								SET @v_dSql += '		  , (case when '''+@v_voyage_day2+''' = ''NULL'' then null else '+@v_voyage_day+' end)          ' + char(10) 
								SET @v_dSql += '		  , (case when '''+@v_INBOUND_DAY2+''' = ''NULL'' then null else '+@v_INBOUND_DAY+' end)          ' + char(10) 
								SET @v_dSql += '		  , (case when '''+@v_IN_BUFFER_DAY2+''' = ''NULL'' then null else '+@v_IN_BUFFER_DAY+' end)          ' + char(10) 
								SET @v_dSql += '		 , '''+ @v_ACTIVE_FLAG +''',                           ' + char(10)
								SET @v_dSql += '		 '''+ @v_DESCRIPTION +''', '''+ @v_USER_ID +''', dbo.SYSDATE1(), '''+ @v_USER_ID +''', dbo.SYSDATE1()                               ' + char(10)
								SET @v_dSql += '		)                                                                                                                                   ' + char(10)
								SET @v_dSql += '		                                                                                                                                    ' + char(10)
								SET @v_dSql += '		INSERT INTO HIS_SHIPMENT_M                                                                                                          ' + char(10)
								SET @v_dSql += '		(COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,                                                                                        ' + char(10)
								SET @v_dSql += '		TO_SITE_ID, TO_PLANT_ID, TRANSPORT_MODE, TRANSPORT_PRIORITY,                                                                        ' + char(10)
								SET @v_dSql += '		OUT_BUFFER_DAY, OUTBOUND_DAY, SHIP_PORT_DAY,                                                                                        ' + char(10)
								SET @v_dSql += '		MON, TUE, WED, THU, FRI, SAT, SUN,                                                                                                  ' + char(10)
								SET @v_dSql += '		VOYAGE_DAY, INBOUND_DAY, IN_BUFFER_DAY, ACTIVE_FLAG,                                                                                ' + char(10)
								SET @v_dSql += '		DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,                                                                        ' + char(10)
								SET @v_dSql += '		JOB_USER_ID, JOB_TIME, JOB_TYPE)                                                                                                    ' + char(10)
								SET @v_dSql += '		SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,                                                                                  ' + char(10)
								SET @v_dSql += '		    TO_SITE_ID, TO_PLANT_ID, TRANSPORT_MODE, TRANSPORT_PRIORITY,                                                                    ' + char(10)
								SET @v_dSql += '		    OUT_BUFFER_DAY, OUTBOUND_DAY, SHIP_PORT_DAY,                                                                                    ' + char(10)
								SET @v_dSql += '		    MON, TUE, WED, THU, FRI, SAT, SUN,                                                                                              ' + char(10)
								SET @v_dSql += '		    VOYAGE_DAY, INBOUND_DAY, IN_BUFFER_DAY, ACTIVE_FLAG,                                                                            ' + char(10)
								SET @v_dSql += '		    DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,                                                                    ' + char(10)
								SET @v_dSql += '		    '''+ @v_USER_ID +''', dbo.SYSDATE1(), ''INSERT''                                                                                ' + char(10)
								SET @v_dSql += '		FROM SCM_SHIPMENT_M(NOLOCK)                                                                                                         ' + char(10)
								SET @v_dSql += '		WHERE COMPANY_ID = '''+ @v_COMPANY_ID +'''                                                                                          ' + char(10)
								SET @v_dSql += '		AND   DIVISION_ID = '''+ @v_DIVISION_ID +'''                                                                                        ' + char(10)
								SET @v_dSql += '		AND   SITE_ID = '''+ @v_SITE_ID +'''                                                                                                ' + char(10)
								SET @v_dSql += '		AND   PLANT_ID = '''+ @v_PLANT_ID +'''                                                                                              ' + char(10)
								SET @v_dSql += '		AND   TO_SITE_ID = '''+ @v_TO_SITE_ID +'''                                                                                          ' + char(10)
								SET @v_dSql += '		AND   TO_PLANT_ID = '''+ @v_TO_PLANT_ID +'''                                                                                        ' + char(10)
								SET @v_dSql += '		AND   TRANSPORT_MODE = '''+ @v_TRANSPORT_MODE +'''                                                                                  ' + char(10)
								SET @v_dSql += '		;                                                                                                                                   ' + char(10)
								SET @v_dSql += '	                                                                                                                                        ' + char(10)
								SET @v_dSql += '	END;                                                                                                                                    ' + char(10)
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

