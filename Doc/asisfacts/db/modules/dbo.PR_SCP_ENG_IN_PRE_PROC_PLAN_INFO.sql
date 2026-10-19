
/* 
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_PLAN_INFO
 * Description  : SDB의 Plan Master 정보를 처리하여 SCP 엔진용 ODB에 적재한다.
 * OutTable     : th_eng_plan_info_sn
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.05   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.05   KSG            LATE TYPE 변경 / 13주 추가기간 설정
 * 2021.06.09   KKC            [ESS] PLAN_HORIZON 임시 기간 늘림(+50일) : 엔진개선시 삭제 예정
 * 2021.07.21   KKC            [ESS] PLAN_HORIZON 임시 기간 늘림(+50일) : 주석 처리(엔진 개선)
 * 2022.01.17   LHS			   PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 계획수립기간을 lookup으로 설정하여 Engine Plan 기간으로 반영
 * 2022.03.02   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 Demand기간을 lookup으로 설정하여 반영
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_PLAN_INFO]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_PLAN_INFO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'th_eng_plan_info_sn';
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
        DELETE /* PR_SCP_ENG_IN_PRE_PROC_PLAN_INFO */
        FROM  th_eng_plan_info_sn
        WHERE 1=1
        AND   plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
        AND   plan_type = @p_plan_type
        ;

        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_PLAN_INFO */ th_eng_plan_info_sn
            (master_id
            ,plan_id
            ,plan_type
            ,plan_start_dttm
            ,plan_horizon
            ,plan_horizon_uom
            ,demand_horizon
            ,demand_horizon_uom
            ,config_set_id
            ,descr
            ,plan_week
        )
        SELECT  @p_master_id      AS master_id
              , @p_engine_plan_id AS plan_id
              , @p_plan_type      AS plan_type
              , p.plan_name       AS plan_start_dttm
			  , DATEDIFF(d, p.plan_name, p.horizon_end_date) + ISNULL(L.ADD_DAY,(13*7)) + 1 AS plan_horizon   -- 2022.01.17 사업부별 추가기간 LOOKUP 반영, NULL이면 default 13w 설정.
              --, DATEDIFF(d, p.plan_name, p.horizon_end_date) + 7*13 + 1 AS plan_horizon -- 2018.07.05 13주 구간 추가 (20220117 주석처리)
              --, DATEDIFF(d, p.plan_name, p.horizon_end_date) + 1 AS plan_horizon 
              , 'DAY'             AS plan_horizon_uom
              , DATEDIFF(d, p.plan_name, p.horizon_end_date) + ISNULL(L2.dm_add_day,0) + 1  as demand_horizon   /** (2022.03.02) Lookup의 사업부별 Demand 추가구간을 반영
              --, DATEDIFF(d, p.plan_name, p.horizon_end_date) + 1 AS demand_horizon                           이전 소스는 주석처리 함.  **/
              , 'DAY'             AS demand_horizon_uom
			  -- 2018.07.05 Config 설정 변경
              , p.division_id + '_CONFIG' AS config_set_id
              --, 'DEFAULT'         AS config_set_id
              , 'GSCM'            AS descr
              , b.yyyyww          AS plan_week
        FROM    scm_mst_plan     p WITH (NOLOCK)
		LEFT OUTER JOIN 
			  (  /** (2022.01.17) 사업부별 추가기간을 LOOKUP에서 가져온다. UOM: WEEK   **/
				SELECT a.SEGMENT1 as DIVISION_ID , a.segment2 as ADD_WEEK , A.segment2*7 AS ADD_DAY 
				FROM   scm_adm_lookup_master_detail a(nolock)
				WHERE  a.lookup_type = 'ADD_PLAN_PERIOD'
				and    a.valid_yn    = 'Y' 
			  ) L
				ON ( 1=1
				AND  P.DIVISION_ID  =  L.DIVISION_ID )
        LEFT OUTER JOIN 
               (  /** (2022.03.02) 사업부별 추가 Demand 반영구간을 Lookup에서 가져온다. UOM: WEEK  **/
				SELECT a.segment1 as division_id , a.segment2 as dm_add_week , a.segment2*7 as dm_add_day 
				FROM   scm_adm_lookup_master_detail a(nolock)
				WHERE  a.lookup_type = 'ADD_DEMAND_PERIOD'
				and    a.valid_yn    = 'Y' 
               ) AS L2
                ON ( 1=1
                AND  p.division_id = L2.division_id ) 
             ,  scm_mst_modeling m WITH (NOLOCK)
             ,  scm_mst_bucket   b WITH (NOLOCK)
        WHERE p.plan_id     = @p_plan_id
        AND   p.division_id = m.division_id
        AND   m.modeling_id = @p_modeling_id
        AND   p.plan_name   = b.yyyymmdd
        ;

		/* 주석처리, 20210721, By KKC
		   엔진 개선(EM048218P5B2 UNPLAN문제)시 삭제.
		 */
		/*
		IF @p_division_id = '82'
		   BEGIN
				UPDATE A 
				   SET a.plan_horizon = a.plan_horizon + 50
				  FROM th_eng_plan_info_sn a(NOLOCK)
				 WHERE a.master_id = @p_master_id
				   AND a.plan_id   = @p_engine_plan_id
				;
		   END
        */
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
