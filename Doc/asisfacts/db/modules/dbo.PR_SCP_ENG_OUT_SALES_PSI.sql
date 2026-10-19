
/*
 * Program ID   : PR_SCP_ENG_OUT_SALES_PSI
 * Description  : SCP 엔진에서 수행된 sales psi 정보를 처리하여 SDB에 적재한다.
 * OutTable     : scp_eng_sales_psi_o
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.07.13   YMH            E20260622-000079 소형엔진 오류건 후속 조치 - 오류발생 상태값 체크위한 프로그램 수정 
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_OUT_SALES_PSI]
    ( @p_plan_cycle1     NVARCHAR(150)
    , @p_plan_name1      NVARCHAR(4000)
    , @p_plan_id1        NVARCHAR(4000)
    , @p_modeling_id1    NVARCHAR(4000)
    , @p_seq1            NVARCHAR(4000)
    , @p_plan_type1      NVARCHAR(4000)
    , @p_master_id1      NVARCHAR(4000)
    , @p_division_id1    NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)
    -- , @p_debug       INT OUTPUT
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_OUT_SALES_PSI';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_SALES_PSI_O';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_OUT_SALES_PSI_OUT */
        FROM  scp_eng_sales_psi_o_sn
        WHERE 1=1
        AND   division_id = @p_division_id  
        AND   plan_id     = @p_plan_id  
        AND   plan_type   = @p_plan_type  
        AND   seq         = @p_seq  
        AND   modeling_id = @p_modeling_id  
        ;   

        INSERT INTO /*  PR_SCP_ENG_OUT_SALES_PSI_OUT  */ scp_eng_sales_psi_o_sn
            ( plan_id
            , modeling_id
            , seq
            , plan_name
            , master_id
            , out_version_id
            , division_id
            , plan_type
            , site_id
            , item_id
            , category
            , start_date
            , qty
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
        )
        SELECT  @p_plan_id                                  as plan_id
              , @p_modeling_id                              as modeling_id
              , @p_seq                                      as seq
              , @p_plan_name                                as plan_name
              , substring(a.master_id,1,150)                as master_id
              , substring(a.out_version_id,1,150)           as out_version_id
              , @p_division_id                              as division_id
              , @p_plan_type                                as plan_type
              , a.site_id
              , a.item_id
              , a.category
              , a.start_date
              , a.qty
              , GETDATE()
              , 'scp_batch'
              , GETDATE()
              , 'scp_batch'
        FROM   th_exp_sales_psi_sn a WITH (NOLOCK)  
        WHERE  1=1
        AND    a.plan_id        = @p_engine_plan_id  
        AND    a.master_id      = @p_master_id  
        AND    a.out_version_id = @p_engine_plan_id
        ;
		
        --FROM (SELECT  tesp.master_id
        --            , tesp.out_version_id
        --            , tesp.site_id
        --            , tesp.item_id
        --            , tesp.category
        --            , tesp.start_date
        --            , tesp.qty
        --      FROM    th_exp_sales_psi_sn tesp WITH (NOLOCK)  
        --      WHERE   1=1
        --       AND    tesp.plan_id        = @p_engine_plan_id  
        --       AND    tesp.master_id      = @p_master_id  
        --       AND    tesp.out_version_id = @p_engine_plan_id
        --      ) a
        --GROUP BY a.master_id, a.out_version_id, a.site_id, a.item_id, a.category, a.start_date
        -----------------------------------------------------------

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;

		-- Output Data 가 0건이면 Error 처리
        IF @n_log_count <= 0
          BEGIN
            -- E20260622-000079 추가로 수요없을때 엔진 오류 안나게 수정.
            -- OUT DATA 가 0건이고 수요정보가 있을때 ERROR 처리.
            IF EXISTS (
                SELECT * FROM dm_pln_net_demand WITH(NOLOCK)
                WHERE 1 = 1
                AND DIVISION_ID IN
                (
                    -- 1.전극이 아닌 DIV 가져오기.
                    -- 2. 40,81,82 인경우 해당건 한개.
                    SELECT  DIVISION_ID 
                    FROM    SCM_MST_DIVISION WITH(NOLOCK)
                    WHERE   1 = 1 
                    AND ATTRIBUTE4 IN
                    (
	                    SELECT ATTRIBUTE4
	                    FROM SCM_MST_DIVISION WITH(NOLOCK)
	                    WHERE 1 = 1 
	                    AND VALID_YN	    = 'Y'
	                    AND DIVISION_ID		= @p_division_id
                    )
                    AND ATTRIBUTE3 != 'EE'
                    AND (
                    (	
	                    @p_division_id IN ('40','81','82')
	                    AND @p_division_id = DIVISION_ID
                    )
                    OR 
	                    @p_division_id NOT IN ('40','81','82')	
                    )
                )
                AND CUTOFF_YYYYMMDD >= @v_cur_monday
            )
            BEGIN
                -- ERROR LOG
                SET @v_log_type = 'ERROR';
                SET @v_log_message = 'Output Data';
                SET @v_description = N'Output Data 0건' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                return -1
            END
          END;

      END;

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      return -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1
  END;
