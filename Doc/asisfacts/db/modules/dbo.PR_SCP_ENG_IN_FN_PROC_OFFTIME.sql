
/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_OFFTIME
 * Description  : 
                  -------------------------------------------------
                  --1-1. OUTSOURCING 공장 OFF 출하 정보를 INSERT (DAY기준 (PST ~ PET DATE까지))
                  -------------------------------------------------
                    -1) 후대기 L/T가 존재하는 OSP 생산공정을 위한 OFF Calendar Set Id 데이터 생성
                    
                    -2) 컬럼값 설정 
                        -컬럼1) offset_id
                              - 공정별 set id 생성  : route_id + '::' site_id 
                        -컬럼2) offtime_id         
                              - 공정별 set별 일별 off id 생성 : route_id + '::' site_id + '::' + off_date                         
                    
                    - 참조 테이블 : scp_mst_shipment_working_day_osp (OUTSOURCING 공장출하일 정보)
                                    shipment_yn = 'N' 출하 OFF DAY 값 기준    

                  -------------------------------------------------
                  --1-2. 해당 OSP 생산공정에 OFF_SET_ID 매핑

 * OutTable     : TH_ENG_OFFTIME / TH_ENG_ITEM_ROUTE_SITE                
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.11.21   KKC         Initial Release [PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2]
 *                          OSP 생산공정의 후대기 L/T 고려시 OFF DAY 고려 
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_OFFTIME]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_OFFTIME';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_OFFTIME';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);

    DECLARE @d_pet_date          DATETIME ; -- Plan End Date
    DECLARE @d_add_dm_pet        DATETIME ; -- Add Demand Cutoff Date, 2023.10.24 추가

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
        /* DM ADD 구간까지 확정한 유한CAPA 생성, 소형만 적용, 2023.10.24 */
        SELECT @d_pet_date      = CONVERT(DATETIME, p.horizon_end_date)
	        ,  @d_add_dm_pet    = CASE WHEN @p_division_id = '40' THEN  
                                            DATEADD(DAY, ISNULL(b.add_dm_day, 0), CONVERT(DATETIME, p.horizon_end_date))
                                       ELSE
                                            CONVERT(DATETIME, p.horizon_end_date)
                                   END 
         FROM dbo.scm_mst_plan p WITH (NOLOCK)
         LEFT OUTER JOIN 
		      (
		      SELECT a.segment1 AS division_id , a.segment2 AS add_dm_week , a.segment2*7 AS add_dm_day 
		          FROM scm_adm_lookup_master_detail a WITH (NOLOCK)
		          WHERE a.lookup_type = 'ADD_DEMAND_PERIOD'
		          AND a.valid_yn    = 'Y' 
                  AND a.segment1    = @p_division_id
		      ) b
           ON 1=1
        WHERE p.division_id = @p_division_id 
          AND p.plan_id     = @p_plan_id 
        ;

		DELETE 
		FROM   th_eng_offtime_sn
        WHERE  plan_id   = @p_engine_plan_id
        AND    master_id = @p_master_id
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-0 START';
        SET @v_description = N'1-0. 변수설정/데이터 초기화' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-- 1-1. OSP 출하 OFF Calendar 생성
        -----------------------------------------------------------
        WITH vw_scp_plant_off_day AS
                                (
                                SELECT b.company_id
                                     , a.division_id
                                     , CONVERT(DATETIME, a.yyyymmdd) AS off_date 
                                     , b.eng_scm_site_id
                                     , b.scm_site_id  AS  plant_id  
                                     , b.osp_yn       AS  osp_yn 
                                     , a.shipment_yn
	                                 , ROW_NUMBER() OVER(PARTITION BY a.division_id
                                                                    , b.eng_scm_site_id
                                                                    , a.yyyymmdd 
							                                 ORDER BY a.yyyymmdd
						                                ) AS SEQ
                                  FROM scp_mst_shipment_working_day_osp  a WITH(NOLOCK) 
                                 INNER JOIN  scm_mst_site_eng            b WITH(NOLOCK) 
                                    ON b.division_id  =  @p_division_id
                                   AND b.plan_id      =  @p_plan_id
                                   AND b.plan_type    =  @p_plan_type
                                   AND b.plan_seq     =  @p_seq
                                   AND b.osp_yn       =  'Y'       --외주 plant만 
                                   AND b.site_type    =  'PLANT'   
                                   AND b.division_id  =  a.division_id
                                   AND b.scm_site_id  =  a.plant_site_id                                            
                                WHERE  1 = 1
                                  AND  a.yyyymmdd     >=  @p_plan_name
                                  AND  a.yyyymmdd     <=  CONVERT(NVARCHAR(8), @d_add_dm_pet , 112)
                                  AND  a.measure       =  'SHIPMENT WORKING DAY' 
                                  AND  a.shipment_yn   =  'N' --영업일일때
                                )
        INSERT INTO th_eng_offtime_sn
                (
                  master_id
                , plan_id
                , offtime_set_id
                , offtime_id
                , start_dttm
                , end_dttm
                , offtime_term
                , offtime_term_uom
                )
        SELECT DISTINCT 
               a.master_id
             , a.plan_id
	         , a.route_id + '::' + a.site_id AS  offtime_set_id
	         , a.route_id + '::' + a.site_id + '::'+ CONVERT(VARCHAR, a.off_date, 112) AS offtime_id
	         , a.off_date                  AS start_dttm
	         , DATEADD(DAY, 1, a.off_date) AS end_dttm
	         , 1                           AS offtiem_term
	         , 'DAY'                       AS offtime_term_uom 
          FROM                        
            (
            SELECT a.master_id
                 , a.plan_id
                 , a.site_id
                 , a.route_id
                 , a.operation_id
                 , a.item_id
                 , a.out_move_time
                 , a.descr
                 , a.attr06
                 , b.division_id
                 , b.off_date
                 , b.shipment_yn
              FROM th_eng_item_route_site_sn a WITH(NOLOCK)
              JOIN (SELECT b.* FROM vw_scp_plant_off_day b WHERE b.seq = 1) b 
                ON a.site_id   = b.eng_scm_site_id
             WHERE a.master_id = @p_master_id
               AND a.plan_id   = @p_engine_plan_id 
               AND a.descr IN ('OSP', 'OSP_L')
               AND a.out_move_time > 0
             ) a
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-0 START';
        SET @v_description = N'2-0. OFF CALENDAR 생성(OSP)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
 
        -----------------------------------------------------------
		-- 1-2. OSP 출하 OFF Calendar 매핑
        -----------------------------------------------------------
        UPDATE a
           SET a.attr06        = b.offtime_set_id
          FROM th_eng_item_route_site_sn a
          JOIN (  
	              SELECT a.offtime_set_id
			        FROM th_eng_offtime_sn A WITH(NOLOCK) 
		           WHERE a.master_id = @p_master_id
			         AND a.plan_id   = @p_engine_plan_id
		        ) b
           ON b.offtime_set_id = a.route_id + '::' + a.site_id
        WHERE a.master_id = @p_master_id
          AND a.plan_id   = @p_engine_plan_id 
          AND a.out_move_time > 0
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-0 START';
        SET @v_description = N'3-0. OFF CALENDAR ID 매핑 (TH_ENG_ITEM_ROUTE_SITE)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        --SET @n_log_count = @@ROWCOUNT + @n_log_count;
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
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

