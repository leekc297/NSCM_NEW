/*    
 * Program ID   : PR_SCM_SYS_DATA_PURGE_WEEKLY      
 * Description  : Data Purge (주단위)
 * OutTable     :   
 * Program History
 *===================================================================================================    
 *   Date       In Charge      Description    
 *===================================================================================================    
 * 2018.06.08   KimJihye       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.16   Kimjaejung     Purge_group 추가. @p_purge_group 파라미터 값으로 Purge_group 별로 프로시져 실행
 * 2018.07.25   KimJihye       Interface 테이블 추가
 * 2018.09.06   KimJihye       ENG, TH Lookup 에 Setup 된 주차 이전 플랜 삭제하도록 로직 수정
 * 2018.10.15   KimJihye       ENG, TH Delete 로직 변경 (속도 향상)
 * 2024.08.22	JSSBAE		   [E20240821-000727]_SCM DM 테이블 데이터 Purge 시점을 잡을 컬럼이 존재하지 않아 컬럼 추가
 */
     

CREATE PROCEDURE [dbo].[PR_SCM_SYS_DATA_PURGE_WEEKLY]
(
  @p_purge_group NVARCHAR(1)=NULL
 )
AS 
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
  SET NOCOUNT ON;      
  SET XACT_ABORT ON;      
  SET ANSI_WARNINGS OFF;      
      
  -- LOG 용 변수 설정      
  DECLARE @v_batch_user          NVARCHAR(150) = N'scp_batch';        
  DECLARE @v_program_name        NVARCHAR(150) = N'PR_SCM_SYS_DATA_PURGE_WEEKLY' + '_' + @p_purge_group;      
  DECLARE @v_log_type            NVARCHAR(30); -- START/END/ERROR/...      
  DECLARE @n_log_count           INTEGER = 0;    
  DECLARE @v_log_message         NVARCHAR(1000);      
  DECLARE @v_description         NVARCHAR(500);
  DECLARE @d_event_date          DATETIME;

  -- Dynamic Query 용 변수 설정
  DECLARE @v_deleteSql           NVARCHAR(MAX);
  DECLARE @v_whereSql            NVARCHAR(MAX);
  DECLARE @v_sql                 NVARCHAR(MAX);
  DECLARE @v_rowcount            INT;

  -- Purge 대상 Table
  DECLARE @v_purge_temp_idx      INT;
  DECLARE @v_purge_max_idx       INT;
  DECLARE @v_database_name       NVARCHAR(30);
  DECLARE @v_table_name          NVARCHAR(200);
  DECLARE @v_type                NVARCHAR(30);
  DECLARE @v_period              INT;
  
  DECLARE @t_purge_target TABLE (
    idx                          INT IDENTITY(1,1) NOT NULL
   ,database_name                NVARCHAR(30)
   ,table_name                   NVARCHAR(200)
   ,type                         NVARCHAR(30)
   ,period                       INT
  );

  -- SCP_ENG 대상 PLAN_ID -> 삭제 (2018.10.15)
  --DECLARE @v_cal_plan_id_scp_eng NVARCHAR(30); -- 2018.09.06
  DECLARE @v_cal_plan_id_th      NVARCHAR(30); -- 2018.09.06

  -- SCP_ENG 대상 Delete 조건
  DECLARE @v_sql_scp_eng         NVARCHAR(MAX); -- 2018.10.15
  DECLARE @v_sql_th              NVARCHAR(MAX); -- 2018.10.15

  -- SCP_PLN, SCP_ANL 대상
  DECLARE @v_scp_pln_temp_idx    INT
  DECLARE @v_scp_pln_max_idx     INT
  DECLARE @v_division_id         VARCHAR(50)
  DECLARE @v_plan_id             VARCHAR(50)
  DECLARE @v_plan_type           VARCHAR(50)
  DECLARE @v_seq                 VARCHAR(50)
  DECLARE @v_modeling_id         INT
  DECLARE @v_master_id           VARCHAR(50)
  DECLARE @v_out_version_id      VARCHAR(50)
  DECLARE @v_plan_start_yyyymmdd VARCHAR(8)

  DECLARE @t_scp_pln TABLE (
    idx                          INT IDENTITY(1,1) NOT NULL
   ,division_id                  VARCHAR(50)
   ,plan_id                      VARCHAR(50)
   ,plan_type                    VARCHAR(50)
   ,seq                          VARCHAR(50)
   ,modeling_id                  INT
   ,master_id                    VARCHAR(50)
   ,out_version_id               VARCHAR(50)
   ,plan_start_yyyymmdd          VARCHAR(8)
  );


  -- 시작 LOG      
  SET @v_log_type    = N'START';      
  SET @v_log_message = N'########## Start of procedure ##########';      
  SET @v_description = @v_program_name;      
  SET @d_event_date  = SYSDATETIME();      
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  BEGIN TRY
    BEGIN
	  -- Purge 대상 Table
	  INSERT INTO @t_purge_target
	  SELECT md.segment1 AS database_name
			,md.segment2 AS table_name
			,md.segment3 AS type
			,CASE md.segment5 WHEN '-' THEN -99 ELSE md.segment5 END AS period 
	  FROM   scm_adm_lookup_master_detail md WITH(NOLOCK)
	  WHERE  md.lookup_type = 'DATA_PURGE_TARGET'
	  -- AND    md.segment4 = 'W'   -- Weekly, Daily
	  AND    md.attribute1 = ISNULL(@p_purge_group, md.attribute1)
	  AND    md.valid_yn = 'Y'
	  ORDER BY md.display_seq;
	  
	  -- 2018.09.06 ENG, TH Lookup 에 Setup 된 주차 이전 플랜 삭제하도록 로직 수정
	  SELECT @v_period = MAX(period)
	  FROM   @t_purge_target
	  WHERE  type ='SCP_ENG';
	  
	  -- SCP_ENG 대상 PLAN_ID : @v_period 주가 지난 대상 삭제
	  SET @v_sql_scp_eng = 'SELECT 1 ' +
                           'FROM   scm_mst_plan mp WITH(NOLOCK) '+
                           'WHERE  1=1 '+
                           'AND    mp.plan_name <= CONVERT(CHAR(8),DATEADD(DD,-(7*'+CONVERT(VARCHAR(1), @v_period)+')-7,dbo.FN_NEXT_DAY(GETDATE(),''MON'')),112) '+
                           'AND    mp.plan_id   = a.plan_id'
	  ;
	
	  -- TH 대상 PLAN_ID : @v_period 주가 지난 대상 삭제
	  SELECT @v_period = MAX(period)
	  FROM   @t_purge_target
	  WHERE  type = 'TH';
	 
	  -- TH 삭제 대상
	  SET @v_sql_th = 'SELECT 1 '+
                      'FROM   scm_mst_plan mp WITH(NOLOCK) '+
                      'JOIN   eng_scp.dbo.th_eng_plan_info pi WITH(NOLOCK) '+
                      'ON     CONVERT(CHAR(8), mp.plan_id-'+CONVERT(VARCHAR(1), @v_period)+') >= LEFT(pi.plan_id, 4) '+
                      'WHERE 1=1 '+
                      'AND    mp.plan_cycle = ''WEEKLY'' '+
                      'AND    mp.plan_name  = CONVERT(CHAR(8),DATEADD(DD,-7,dbo.FN_NEXT_DAY(GETDATE(),''MON'')),112) '+
                      'AND    pi.master_id  = a.master_id '+
                      'AND    pi.plan_id     =a.plan_id'
      ;	  
	  
	  -- TH2 삭제 대상 PLAN_ID : 2주가 지난 대상 삭제	  
	  SELECT @v_cal_plan_id_th = CONVERT(CHAR(4), plan_id)
	  FROM   (SELECT DISTINCT CONVERT(INT, plan_id) - @v_period AS plan_id
	          FROM   scm_mst_plan with(nolock)
              WHERE  plan_cycle = 'WEEKLY'
              AND    plan_name  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) A;
			  
	  -- SCP_PLN, SCP_ANL 대상 : 전주 이전의 CONFIRM안된 Plan ID, Seq
      INSERT INTO @t_scp_pln
      SELECT  division_id
             ,plan_id
             ,plan_type
             ,seq
             ,modeling_id
             ,master_id
             ,out_version_id
             ,plan_start_yyyymmdd
      FROM   (SELECT  d.division_id
                     ,d.plan_id
                     ,d.plan_type
                     ,d.plan_seq as seq
                     ,d.modeling_id
                     ,d.division_id+'::'+'weekly' as master_id
                     ,d.plan_id+'::'+ d.plan_type+'::'+convert(VARCHAR,d.plan_seq) as out_version_id
                     ,(SELECT plan_name 
                       FROM   scm_mst_plan p WITH(NOLOCK) 
                       WHERE  p.division_id = d.division_id 
                       AND    p.plan_id = d.plan_id ) as plan_start_yyyymmdd
              FROM  scm_mst_plan_detail d WITH(NOLOCK)
              WHERE isnull(confirm_flag,'N') !='Y'
              AND   plan_type <> 'SP' 
              AND   plan_id < (SELECT plan_id
                               FROM   scm_mst_plan p WITH(NOLOCK)
                               WHERE  p.division_id = d.division_id
                               AND    p.plan_name   = dbo.FN_GET_BUCKET_YYYYMMDD(0)
                               AND    p.plan_cycle  = 'WEEKLY')) sub
      
	   -- Purge 대상 Table
      SELECT @v_purge_temp_idx = MIN(idx), @v_purge_max_idx = MAX(idx) FROM @t_purge_target;
	  
	  WHILE @v_purge_temp_idx <= @v_purge_max_idx
	  BEGIN
	    SELECT @v_database_name = database_name
              ,@v_table_name    = table_name
	          ,@v_type          = type
	          ,@v_period        = period 
		FROM   @t_purge_target
		WHERE  idx = @v_purge_temp_idx;

		SET @v_purge_temp_idx = @v_purge_temp_idx + 1;

	    SET @v_deleteSql = 'DELETE /* PR_SCM_SYS_DATA_PURGE_WEEKLY */ TOP(100000) FROM ' + @v_database_name + '.DBO.' + @v_table_name;
		SET @v_whereSql  = '';
		SET @n_log_count = 0;

		-- 유형별 WHERE 절 작성
		-- 1-1. SCP_ENG : 4주 지난 데이타 삭제
	    IF      @v_type     =  'SCP_ENG'
		  -- 2018.10.15
		  SET   @v_whereSql = ' FROM ' + @v_database_name + '.DBO.' + @v_table_name + ' a ' +
		                      ' WHERE 1=1 '+
		                      ' AND EXISTS (' + @v_sql_scp_eng + ')';

		-- 2018.09.06. 2018.10.15
		-- 1-2-1. TH : 2주 지난 데이타 삭제
		ELSE IF @v_type     =  'TH'  
		  SET   @v_whereSql = ' FROM ' + @v_database_name + '.DBO.' + @v_table_name + ' a ' +
		                      ' WHERE 1=1 '+
		                      ' AND EXISTS (' + @v_sql_th + ')';

		-- 1-2-2. TH2 : 2주 지난 데이타 삭제
		ELSE IF @v_type     =  'TH2'  
		  SET   @v_whereSql = ' WHERE  LEFT(PLAN_ID,4) <= ''' + @v_cal_plan_id_th + '''';

		-- 2. SSP_PLN : 15일 이전의 데이타 삭제		
		ELSE IF @v_type     =  'SSP_PLN'
		  SET   @v_whereSql = ' WHERE  plan_start_yyyymmdd <= ''' + CONVERT(CHAR(8), GETDATE()-@v_period, 112) + '''';	  	  

		-- 2.2 ANL_27 : 27주 이전의 데이타 삭제		
		ELSE IF @v_type     =  'ANL_27'
		  SET   @v_whereSql = ' WHERE  yyyymmdd <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';

		-- 2.3 PLN_27 : 27주 이전의 데이타 삭제		
		ELSE IF @v_type     =  'PLN_27'
		  SET   @v_whereSql = ' WHERE  plan_start_yyyymmdd <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';

		-- 3. HISTORY : 12주 지난 데이타 삭제
		ELSE IF @v_type     =  'HISTORY'
	      SET   @v_whereSql = ' WHERE  history_creation_date <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';

		-- 4. LOG : 4주 지난 데이타 삭제
		ELSE IF @v_type     =  'LOG'
	      SET   @v_whereSql = ' WHERE  creation_date <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';

		-- 5. TH2 : 4주 지난 데이타 삭제, 로직 삭제(2018.10.15)
		/*ELSE IF @v_type     =  'TH2'
	      SET   @v_whereSql = ' WHERE  create_date <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';
		*/
		-- 2018.07.25 Interface 테이블 추가
		-- 7-1. INTERFACE_1 (RFC) : 12주 지난 데이타 삭제
		ELSE IF @v_type     =  'INTERFACE_1'
		  SET   @v_whereSql = ' WHERE  transfer_date <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';

		-- 7-2. INTERFACE_2 (MQ RCV) : 12주 지난 데이타 삭제
		ELSE IF @v_type     =  'INTERFACE_2'
		  SET   @v_whereSql = ' WHERE  if_rcv_date <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';

		-- 7-3. INTERFACE_3 (MQ SND) : 12주 지난 데이타 삭제
		ELSE IF @v_type     =  'INTERFACE_3'
		  SET   @v_whereSql = ' WHERE  if_snd_date <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';

		-- 7-4. INTERFACE_4 (MQ SND) : 12주 지난 데이타 삭제
		ELSE IF @v_type     =  'INTERFACE_4'
		  SET   @v_whereSql = ' WHERE  transfer_update_date <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';

		--[E20240821-000727]_SCM DM 테이블 데이터 Purge 시점을 잡을 컬럼이 존재하지 않아 컬럼 추가 START 		
		-- 7-5. INTERFACE_5 : 12주 지난 데이타 삭제
		ELSE IF @v_type     =  'INTERFACE_5'
		  SET   @v_whereSql = ' WHERE  TRANSFER_CREATE_DATE <= ''' + CONVERT(CHAR(8), GETDATE()-7*@v_period, 112) + '''';
		--[E20240821-000727]_SCM DM 테이블 데이터 Purge 시점을 잡을 컬럼이 존재하지 않아 컬럼 추가 END 	
		
		-- SQL 실행 : 5,000 건 씩 나눠서 대상이 없을 때까지 실행 
		IF @v_whereSql != ''
		BEGIN
		  SET    @v_sql = @v_deleteSql + @v_whereSql;
		  SET    @v_rowcount = 1;
		  WHILE  @v_rowcount > 0
		  BEGIN
		    EXEC (@v_sql);
		    SET  @v_rowcount  = @@ROWCOUNT;
			SET  @n_log_count = @n_log_count + @v_rowcount;
		  END
		END		

		-- 6. SCP_PLN OR SCP_ANL : 전주 이전의 CONFIRM 안 된 PLAN SEQ
		IF @v_type = 'SCP_PLN' OR @v_type = 'SCP_ANL'
		  BEGIN
		    SELECT @v_scp_pln_temp_idx = MIN(idx), @v_scp_pln_max_idx = MAX(idx) FROM @t_scp_pln;
			
			WHILE @v_scp_pln_temp_idx <= @v_scp_pln_max_idx
			BEGIN
			  
		      SELECT  @v_division_id         = division_id
                     ,@v_plan_id             = plan_id
                     ,@v_plan_type           = plan_type
                     ,@v_seq                 = seq
                     ,@v_modeling_id         = modeling_id
                     ,@v_master_id           = master_id
                     ,@v_out_version_id      = out_version_id
                     ,@v_plan_start_yyyymmdd = plan_start_yyyymmdd
			  FROM    @t_scp_pln
			  WHERE   idx = @v_scp_pln_temp_idx;

			  SET    @v_scp_pln_temp_idx = @v_scp_pln_temp_idx + 1;

			  SET    @v_whereSql = ' WHERE division_id         = ''' + @v_division_id + '''' +
                                   ' AND   plan_start_yyyymmdd = ''' + @v_plan_start_yyyymmdd + '''' +
						   	  	   ' AND   plan_type           = ''' + @v_plan_type + '''' +
								   ' AND   seq                 = ''' + @v_seq + '''';
			  IF @v_type = 'SCP_PLN'
			    SET    @v_whereSql = @v_whereSql +
								   ' AND   plan_id             = ''' + @v_plan_id + '''' +
                                   ' AND   master_id           = ''' + @v_master_id + '''' +
								   ' AND   out_version_id      = ''' + @v_out_version_id + '''';
			  

			  SET    @v_sql = @v_deleteSql + @v_whereSql;
		      SET    @v_rowcount = 1;
			  
			  -- SQL 실행 : 5,000 건 씩 나눠서 대상이 없을 때까지 실행 
		      WHILE  @v_rowcount > 0
		      BEGIN
		        EXEC (@v_sql);
		        SET  @v_rowcount  = @@ROWCOUNT;
				SET  @n_log_count = @n_log_count + @v_rowcount;
		      END
			END
		  END		  

        -- TXN LOG
		SET @v_log_type    = 'TXN LOG';
		SET @v_log_message = CAST(@v_sql AS NVARCHAR(1000));
        SET @v_description = 'Data Purge : ' + @v_table_name;
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
	  END
	  
	  --DBCC shrinkdatabase(ENG_SCP, truncateonly);
	  --DBCC shrinkdatabase(LGCE_SCMDEV, truncateonly);

	END
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
      ROLLBACK;
    END;
    -- ERROR LOG
    SET @v_log_type    = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = @v_deleteSql + @v_whereSql; --'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END CATCH;

  -- 종료 LOG
  SET @v_log_type    = 'END';
  SET @v_log_message = '########## END of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END