
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_OP_RES_GROUP
 * Description  : ODB의 Op Res Group 정보를 ODB에 적재되도록 한다.
                    
                  1. Op Res Group 정보 생성
                     - 참고 컬럼1) resource_map_id : a.item_id + '::' + a.route_id + '::' + a.site_id
				  
 * OutTable     : TH_ENG_OP_RES_GROUP
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.18   KSW            전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_OP_RES_GROUP]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)

    , @p_pre_plan_type1 NVARCHAR(4000)
    , @p_pre_plan_seq1  NVARCHAR(4000)
    , @p_pre_engine_plan_id1 NVARCHAR(4000)
    
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
    
    DECLARE @p_pre_plan_type NVARCHAR(4000) = @p_pre_plan_type1;
    DECLARE @p_pre_plan_seq  NVARCHAR(4000) = @p_pre_plan_seq1;
    DECLARE @p_pre_engine_plan_id NVARCHAR(4000) = @p_pre_engine_plan_id1; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_OP_RES_GROUP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_OP_RES_GROUP';
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

		DELETE /* PR_SCP_ENG_EE_FN_PROC_OP_RES_GROUP */ 
		FROM   th_eng_op_res_group_sn
		WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id
		;
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_OP_RES_GROUP */ th_eng_op_res_group_sn
		(   master_id
		  , plan_id
          , site_id
		  , route_id
		  , operation_id
          , item_id
		  , resource_map_id
		  , resource_map_level
          , min_tact_time
		  , avg_tact_time
		  , max_tact_time
		  , tact_time_uom
          , yield
		  , resource_selector_id
		  , descr
        )
        SELECT DISTINCT
               a.master_id
		     , a.plan_id
             , a.site_id
			 , a.route_id
			 , a.operation_id
             , a.item_id
			 , a.item_id + '::' + a.route_id + '::' + a.site_id  AS resource_map_id
			 , 1                                                 AS resource_map_level
             , 0                     AS min_tact_time  --20180326 PR_SCP_ENG_EE_FN_PROC_OP_RES_GROUP_MAP_CAL 처리시 th_eng_op_res_group_map.tact_time 와 th_eng_op_res_group_map_cal.tact_time 중 큰값을 입력 
			 , 0                     AS avg_tact_time  --20180326 PR_SCP_ENG_EE_FN_PROC_OP_RES_GROUP_MAP_CAL 처리시 th_eng_op_res_group_map.tact_time 와 th_eng_op_res_group_map_cal.tact_time 중 큰값을 입력 
			 , 0                     AS max_tact_time  --20180326 PR_SCP_ENG_EE_FN_PROC_OP_RES_GROUP_MAP_CAL 처리시 th_eng_op_res_group_map.tact_time 와 th_eng_op_res_group_map_cal.tact_time 중 큰값을 입력 
			 , 'SECOND'              AS tact_time_uom
             , 1                     AS yield
			 , NULL                  AS resource_selector_id
			-- , NULL                  AS descr 
             , CASE WHEN a.descr                 = 'OSP'   THEN 'OSP'
                    WHEN a.descr                 = 'OSP_L' THEN 'OSP_L' -- 2020.02.03  [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
                    WHEN ISNULL(c.segment5, 'X') = 'X'     THEN 'NO_CAPA'
                    WHEN c.segment5              = 'N'     THEN 'CAPA'
                    ELSE 'LINE_CAPA'
               END AS descr
        FROM   th_eng_item_route_site_sn a WITH(NOLOCK)
        LEFT OUTER JOIN (
                         SELECT b.segment2, a.segment5
                         FROM   scm_adm_lookup_master_detail     a WITH(NOLOCK)
                         INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                         ON  a.segment1= b.segment1
                         AND a.lookup_type = 'LOCATION_GROUP'
                         AND a.segment3    = 'E' -- 전극 공정 
                         AND a.segment4    = 'Y' -- Capa 공정 여부 
                       --  AND a.segment5    = 'N' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                         AND a.valid_yn    = 'Y'
                         AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                         AND b.valid_yn    = 'Y'
                         AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
                        ) c
        ON a.route_id = c.segment2
        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
		;
  
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


