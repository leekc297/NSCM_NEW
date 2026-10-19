/*
 * Program ID   : PR_SSP_DNM_TABLE_COMPRESS
 * Description  : Compressed Table에 백업 후 삭제
 * OutTable     :
 * Execute      : EXEC PR_SSP_DNM_TABLE_COMPRESS
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.11.01   SSP Pjt.       Create.
 * 2024.06.10   jilee          5번 추가 SSP_ANL_SHIP_PLAN_P -> SSP_ANL_SHIP_PLAN_P_COM 
 */

CREATE PROCEDURE [dbo].[PR_SSP_DNM_TABLE_COMPRESS]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_DNM_TABLE_COMPRESS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_TABLE_COMPRESS'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_plan_start_yyyymmdd			NVARCHAR(8)		= '';
	DECLARE @v_data_start_yyyymmdd			NVARCHAR(8)		= '';
	DECLARE @v_data_end_yyyymmdd			NVARCHAR(8)		= '';
	DECLARE @v_plan_cutoff_yyyymmdd			NVARCHAR(8)     = '';   

	SET @v_plan_start_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, -91, GETDATE()), 112) 

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;

	DECLARE @v_SSP_DNM_TABLE_COMPRESS TABLE  (
		PLAN_START_YYYYMMDD		nvarchar(008),
		ROW_NUM                 INT
	);

  -- 시작 LOG
    SET @v_log_type		= N'START';
    SET @v_log_message	= N'########## Start of procedure ##########';
    SET @v_description	= @v_program_name + ':' + N' DATA MIGRATION LOGIC';
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''


    BEGIN TRY
    BEGIN

		------------------------------------------------------------------------------------------------------------- 
		-- 1. SSP_ANL_SHIP_PLAN_40 -> SSP_ANL_SHIP_PLAN_40_COM
		------------------------------------------------------------------------------------------------------------- 
		SET @v_data_start_yyyymmdd		= '';
		SET @v_data_end_yyyymmdd		= '';
		SET @v_plan_cutoff_yyyymmdd		= '';

		DELETE FROM @v_SSP_DNM_TABLE_COMPRESS;

		SELECT @v_data_start_yyyymmdd = MIN(plan_start_yyyymmdd) 
			FROM SSP_ANL_SHIP_PLAN_40 WITH(NOLOCK)

		SET @v_data_end_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, 9, CONVERT(DATETIME, @v_data_start_yyyymmdd, 112)) ,112)

		IF @v_data_start_yyyymmdd	<= @v_plan_start_yyyymmdd
		BEGIN
			IF @v_data_end_yyyymmdd >= @v_plan_start_yyyymmdd
				SET @v_data_end_yyyymmdd = @v_plan_start_yyyymmdd

			--
			INSERT INTO @v_SSP_DNM_TABLE_COMPRESS (PLAN_START_YYYYMMDD, ROW_NUM)
			SELECT BASIS_YYYYMMDD
			     , row_number() over(order by BASIS_YYYYMMDD) as ROW_NUM 
			  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		     WHERE basis_yyyymmdd BETWEEN @v_data_start_yyyymmdd AND @v_data_end_yyyymmdd
		     ORDER BY BASIS_YYYYMMDD
				;

			SELECT @INX			= 1
			      ,@MAX_NUM		= COUNT(*)
			  FROM @v_SSP_DNM_TABLE_COMPRESS

			WHILE @INX <= @MAX_NUM
			BEGIN

				SELECT @v_plan_cutoff_yyyymmdd = PLAN_START_YYYYMMDD
				  FROM @v_SSP_DNM_TABLE_COMPRESS 
				 WHERE ROW_NUM					= @INX

				 BEGIN TRAN TX_SH

				INSERT INTO SSP_ANL_SHIP_PLAN_40_COM
				SELECT *
				  FROM SSP_ANL_SHIP_PLAN_40 WITH(NOLOCK)
                 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
				   AND DIVISION_ID = '40'

				DELETE FROM SSP_ANL_SHIP_PLAN_40
				 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
				   AND DIVISION_ID = '40'

				COMMIT TRAN TX_SH;

				SET @INX = @INX + 1
			END
		END

		------------------------------------------------------------------------------------------------------------- 
		-- 2. SSP_ANL_SHIP_PLAN_EE -> SSP_ANL_SHIP_PLAN_EE_COM
		------------------------------------------------------------------------------------------------------------- 
		SET @v_data_start_yyyymmdd		= '';
		SET @v_data_end_yyyymmdd		= '';
		SET @v_plan_cutoff_yyyymmdd		= '';

		DELETE FROM @v_SSP_DNM_TABLE_COMPRESS;

		SELECT @v_data_start_yyyymmdd = MIN(plan_start_yyyymmdd) 
			FROM SSP_ANL_SHIP_PLAN_EE WITH(NOLOCK)

		SET @v_data_end_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, 9, CONVERT(DATETIME, @v_data_start_yyyymmdd, 112)) ,112)

		IF @v_data_start_yyyymmdd <= @v_plan_start_yyyymmdd
		BEGIN

			if @v_data_end_yyyymmdd >= @v_plan_start_yyyymmdd
				SET @v_data_end_yyyymmdd = @v_plan_start_yyyymmdd

		    --
			INSERT INTO @v_SSP_DNM_TABLE_COMPRESS (PLAN_START_YYYYMMDD, ROW_NUM)
			SELECT BASIS_YYYYMMDD
			     , row_number() over(order by BASIS_YYYYMMDD) as ROW_NUM 
			  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		     WHERE basis_yyyymmdd BETWEEN @v_data_start_yyyymmdd AND @v_data_end_yyyymmdd
		     ORDER BY BASIS_YYYYMMDD
				;

			SELECT @INX			= 1
				  ,@MAX_NUM		= COUNT(*)
			  FROM @v_SSP_DNM_TABLE_COMPRESS

			WHILE @INX <= @MAX_NUM
			BEGIN

				SELECT @v_plan_cutoff_yyyymmdd = PLAN_START_YYYYMMDD
				  FROM @v_SSP_DNM_TABLE_COMPRESS 
				 WHERE ROW_NUM					= @INX

				 BEGIN TRAN TX_SH

				INSERT INTO SSP_ANL_SHIP_PLAN_EE_COM
				SELECT *
			      FROM SSP_ANL_SHIP_PLAN_EE WITH(NOLOCK)
                 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
			       AND DIVISION_ID IN ('81', '82', '40','81_UC','81_HM','81_ST','81_HD','81_HG')

				DELETE FROM SSP_ANL_SHIP_PLAN_EE
				 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
				   AND DIVISION_ID IN ('81', '82', '40','81_UC','81_HM','81_ST','81_HD','81_HG')

				COMMIT TRAN TX_SH;

				SET @INX = @INX + 1
			END
		END

		------------------------------------------------------------------------------------------------------------- 
		-- 3. SSP_ANL_SHIP_PLAN_C -> SSP_ANL_SHIP_PLAN_C_COM
		------------------------------------------------------------------------------------------------------------- 
		SET @v_data_start_yyyymmdd		= '';
		SET @v_data_end_yyyymmdd		= '';
		SET @v_plan_cutoff_yyyymmdd		= '';

		DELETE FROM @v_SSP_DNM_TABLE_COMPRESS;

		SELECT @v_data_start_yyyymmdd = MIN(plan_start_yyyymmdd) 
			FROM SSP_ANL_SHIP_PLAN_C WITH(NOLOCK)

		SET @v_data_end_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, 9, CONVERT(DATETIME, @v_data_start_yyyymmdd, 112)) ,112)

		IF @v_data_start_yyyymmdd <= @v_plan_start_yyyymmdd
		BEGIN

			if @v_data_end_yyyymmdd >= @v_plan_start_yyyymmdd
				SET @v_data_end_yyyymmdd = @v_plan_start_yyyymmdd

			--
			INSERT INTO @v_SSP_DNM_TABLE_COMPRESS (PLAN_START_YYYYMMDD, ROW_NUM)
			SELECT BASIS_YYYYMMDD
			     , row_number() over(order by BASIS_YYYYMMDD) as ROW_NUM 
			  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		     WHERE basis_yyyymmdd BETWEEN @v_data_start_yyyymmdd AND @v_data_end_yyyymmdd
		     ORDER BY BASIS_YYYYMMDD
				;

			SELECT @INX			= 1
				  ,@MAX_NUM		= COUNT(*)
			  FROM @v_SSP_DNM_TABLE_COMPRESS

			WHILE @INX <= @MAX_NUM
			BEGIN

				SELECT @v_plan_cutoff_yyyymmdd = PLAN_START_YYYYMMDD
				  FROM @v_SSP_DNM_TABLE_COMPRESS 
				 WHERE ROW_NUM					= @INX

				 BEGIN TRAN TX_SH

				INSERT INTO SSP_ANL_SHIP_PLAN_C_COM
				SELECT *
				  FROM SSP_ANL_SHIP_PLAN_C WITH(NOLOCK)
                 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
				   AND DIVISION_ID IN ('81', '82','81_UC','81_HM','81_ST','81_HD','81_HG')

				DELETE FROM SSP_ANL_SHIP_PLAN_C
				 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
				   AND DIVISION_ID IN ('81', '82','81_UC','81_HM','81_ST','81_HD','81_HG')

				COMMIT TRAN TX_SH;

				SET @INX = @INX + 1
			END
		END

		------------------------------------------------------------------------------------------------------------- 
		-- 4. SSP_ANL_STOCK_EE_C -> SSP_ANL_STOCK_EE_C_COM
		------------------------------------------------------------------------------------------------------------- 
		SET @v_data_start_yyyymmdd		= '';
		SET @v_data_end_yyyymmdd		= '';
		SET @v_plan_cutoff_yyyymmdd		= '';

		DELETE FROM @v_SSP_DNM_TABLE_COMPRESS;

		SELECT @v_data_start_yyyymmdd = MIN(plan_start_yyyymmdd) 
			FROM SSP_ANL_STOCK_EE_C WITH(NOLOCK)

		SET @v_data_end_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, 9, CONVERT(DATETIME, @v_data_start_yyyymmdd, 112)) ,112)

		IF @v_data_start_yyyymmdd <= @v_plan_start_yyyymmdd
		BEGIN

			if @v_data_end_yyyymmdd >= @v_plan_start_yyyymmdd
				SET @v_data_end_yyyymmdd = @v_plan_start_yyyymmdd

			--
			INSERT INTO @v_SSP_DNM_TABLE_COMPRESS (PLAN_START_YYYYMMDD, ROW_NUM)
			SELECT BASIS_YYYYMMDD
			     , row_number() over(order by BASIS_YYYYMMDD) as ROW_NUM 
			  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		     WHERE basis_yyyymmdd BETWEEN @v_data_start_yyyymmdd AND @v_data_end_yyyymmdd
		     ORDER BY BASIS_YYYYMMDD
				;

			SELECT @INX			= 1
				  ,@MAX_NUM		= COUNT(*)
			  FROM @v_SSP_DNM_TABLE_COMPRESS

			WHILE @INX <= @MAX_NUM
			BEGIN

				SELECT @v_plan_cutoff_yyyymmdd = PLAN_START_YYYYMMDD
				  FROM @v_SSP_DNM_TABLE_COMPRESS 
				 WHERE ROW_NUM					= @INX

				 BEGIN TRAN TX_SH

				INSERT INTO SSP_ANL_STOCK_EE_C_COM
				SELECT *
				  FROM SSP_ANL_STOCK_EE_C WITH(NOLOCK)
                 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
				   AND DIVISION_ID IN ('81', '82', '40','81_UC','81_HM','81_ST','81_HD','81_HG')

				DELETE FROM SSP_ANL_STOCK_EE_C
				 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
				   AND DIVISION_ID IN ('81', '82', '40','81_UC','81_HM','81_ST','81_HD','81_HG')

				 COMMIT TRAN TX_SH;

				SET @INX = @INX + 1
			END
		END			

		------------------------------------------------------------------------------------------------------------- 
		-- 5. SSP_ANL_SHIP_PLAN_P -> SSP_ANL_SHIP_PLAN_P_COM
		------------------------------------------------------------------------------------------------------------- 
		SET @v_data_start_yyyymmdd		= '';
		SET @v_data_end_yyyymmdd		= '';
		SET @v_plan_cutoff_yyyymmdd		= '';

		DELETE FROM @v_SSP_DNM_TABLE_COMPRESS;

		SELECT @v_data_start_yyyymmdd = MIN(plan_start_yyyymmdd) 
			FROM SSP_ANL_SHIP_PLAN_P WITH(NOLOCK)

		SET @v_data_end_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, 9, CONVERT(DATETIME, @v_data_start_yyyymmdd, 112)) ,112)

		IF @v_data_start_yyyymmdd <= @v_plan_start_yyyymmdd
		BEGIN

			if @v_data_end_yyyymmdd >= @v_plan_start_yyyymmdd
				SET @v_data_end_yyyymmdd = @v_plan_start_yyyymmdd

			--
			INSERT INTO @v_SSP_DNM_TABLE_COMPRESS (PLAN_START_YYYYMMDD, ROW_NUM)
			SELECT BASIS_YYYYMMDD
			     , row_number() over(order by BASIS_YYYYMMDD) as ROW_NUM 
			  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		     WHERE basis_yyyymmdd BETWEEN @v_data_start_yyyymmdd AND @v_data_end_yyyymmdd
		     ORDER BY BASIS_YYYYMMDD
				;

			SELECT @INX			= 1
				  ,@MAX_NUM		= COUNT(*)
			  FROM @v_SSP_DNM_TABLE_COMPRESS

			WHILE @INX <= @MAX_NUM
			BEGIN

				SELECT @v_plan_cutoff_yyyymmdd = PLAN_START_YYYYMMDD
				  FROM @v_SSP_DNM_TABLE_COMPRESS 
				 WHERE ROW_NUM					= @INX
				 				 
				BEGIN TRAN TX_SH

				INSERT INTO SSP_ANL_SHIP_PLAN_P_COM
				SELECT *
				  FROM SSP_ANL_SHIP_PLAN_P WITH(NOLOCK)
                 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
				  --AND DIVISION_ID IN ('81', '82','81_UC','81_HM','81_ST','81_HD')

				DELETE FROM SSP_ANL_SHIP_PLAN_P
				 WHERE PLAN_START_YYYYMMDD = @v_plan_cutoff_yyyymmdd
				   --AND DIVISION_ID IN ('81', '82','81_UC','81_HM','81_ST','81_HD')

				COMMIT TRAN TX_SH;

				SET @INX = @INX + 1
			END
		END

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        --IF @@TRANCOUNT > 0
        --BEGIN
        --    COMMIT TRAN TX_SH;
        --END;       

        -- TXN LOG
        SET @v_log_type		= N'TXN';    -- ▶ 로그타입
        SET @n_log_count	= @@ROWCOUNT;
        SET @v_log_message	= N'INSERT INTO '+@v_table_id;
        SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date	= SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH
        END;
      
		-- ERROR LOG
		SET @v_log_type		= N'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
								  ,@p_log_type      =@v_log_type
								  ,@p_log_count     =@n_log_count 
								  ,@p_log_message   =@v_log_message 
								  ,@p_description   =@v_description 
								  ,@p_event_date    =@d_event_date 
								  ,@p_user_id       =@v_batch_user
                                ;

		return -1

    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type		= N'END';
    SET @v_log_message	= N'########## END of procedure ##########';
    SET @v_description	= N'['+@v_program_name+'][' + @v_exec_time + ']';  
    SET @d_event_date	= SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;

  
    return 1  

  END; 
