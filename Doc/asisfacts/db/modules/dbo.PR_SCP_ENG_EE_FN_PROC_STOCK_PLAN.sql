
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_STOCK_PLAN
 * Description  : 동일 PLAN_ID의 Confirm Flag ='Y'인 이전 PLAN_TYPE의 최종 생성된 데이터를 적재
                     - 재고 : 이전 Plan 정보 Copy 유지(descr <> 'INT')
                     - 해상재고 : 이전 Plan 정보를 Copy 하지 않고, scp_eng_intransitshpmnt_i 정보를 재적재함(descr = 'INT')
 * OutTable     : th_eng_stock_plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.22   KSW            전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2021.02.04   KSG            C20210203-000224 [SCM PI팀] GSCM시스템의 RTF정합성 향상을 위한 ETA 기준 반영 시간 변경 개선 건
 * 2021.09.07   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선, 전진검사 재고상태 구분 추가
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_STOCK_PLAN]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_STOCK_PLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_STOCK_PLAN';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    --DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;
    DECLARE @n_max_stock_seq     INTEGER = 0;

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
        DELETE   /* PR_SCP_ENG_EE_FN_PROC_STOCK_PLAN */
        FROM     th_eng_stock_plan_sn
        WHERE    master_id = @p_master_id 
        AND      plan_id   = @p_engine_plan_id 
        ;

        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_STOCK_PLAN */ th_eng_stock_plan_sn
        (   master_id
          , plan_id
          , stock_seq
          , item_id
          , site_id
          , route_id
          , operation_id
          , receiving_dttm
          , qty
          , lot_id
          , work_order_id
          , demand_id
          , descr
		  , insp_type  -- 전진검사 재고 구분값, 2021.09.07 추가
        )
        SELECT @p_master_id      AS master_id
		     , @p_engine_plan_id AS plan_id
             , stock_seq
             , item_id
             , site_id
             , route_id
             , operation_id
             , receiving_dttm
             , qty
             , lot_id
             , work_order_id
             , demand_id
             , descr
			 , insp_type --2021.09.07 추가
        FROM  th_eng_stock_plan_sn WITH (NOLOCK)
        WHERE  master_id  = @p_master_id
        AND    plan_id    = @p_pre_engine_plan_id
		
   /*-- 20220321 주석 START
        -----------------------------------------------------------
        -- 1. 해상재고 외
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_STOCK_PLAN */ th_eng_stock_plan_sn
        (   master_id
          , plan_id
          , stock_seq
          , item_id
          , site_id
          , route_id
          , operation_id
          , receiving_dttm
          , qty
          , lot_id
          , work_order_id
          , demand_id
          , descr
		  , insp_type  -- 전진검사 재고 구분값, 2021.09.07 추가
        )
        SELECT @p_master_id      AS master_id
		     , @p_engine_plan_id AS plan_id
             , stock_seq
             , item_id
             , site_id
             , route_id
             , operation_id
             , receiving_dttm
             , qty
             , lot_id
             , work_order_id
             , demand_id
             , descr
			 , insp_type --2021.09.07 추가
        FROM  th_eng_stock_plan_sn WITH (NOLOCK)
        WHERE  master_id  = @p_master_id
        AND    plan_id    = @p_pre_engine_plan_id
        AND    descr     <> 'INT'  -- 20210204  C20210203-000224  재고 : 이전 Plan 정보 Copy 유지(descr <> 'INT')
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'1. 해상재고 외...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 2. 해상재고 : 20210204  C20210203-000224  이전 Plan 정보를 Copy 하지 않고, scp_eng_intransitshpmnt_i 정보를 재적재함(descr = 'INT')
        -----------------------------------------------------------        
		-- 중복 방지를 위한 Stock Seq 설정
        SELECT @n_max_stock_seq = max(stock_seq)
        FROM  th_eng_stock_plan_sn WITH (NOLOCK)
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_pre_engine_plan_id;

        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_STOCK_PLAN */ th_eng_stock_plan_sn
        (   master_id
          , plan_id
          , stock_seq
          , item_id
          , site_id
          , route_id
          , operation_id
          , receiving_dttm
          , qty
          , lot_id
          , work_order_id
          , demand_id
          , descr
		  , insp_type --2021.09.07 추가
        )
        SELECT @p_master_id                                   AS master_id
             , @p_engine_plan_id                              AS plan_id
             , @n_max_stock_seq + 10000 + ROW_NUMBER() OVER(ORDER BY a.item_id, a.scm_site_id, a.route_id, a.operation_id, a.effstartdate) AS stock_seq
             --  , decode(b.item_type, 'R', a.item_id, TRIM(a.item_id || '^' || a.scm_site_id)) AS item_id
             , a.item_id                                      AS item_id
             , CASE WHEN b.item_type = 'R' THEN NULL
                    ELSE a.scm_site_id
               END                                            AS site_id
             , CASE WHEN b.item_type = 'R' THEN NULL
                    ELSE a.route_id
               END                                            AS route_id
             , CASE WHEN b.item_type = 'R' THEN NULL
                    ELSE a.operation_id
                    END                                       AS operation_id
             , ISNULL(a.effstartdate, convert(datetime, @p_plan_name)) AS receiving_dttm
             , a.qty                                          AS qty -- Total 재고/해상재고 : 재고/해상재고 + 해상재고/해상재고
             , a.lot_id                                       AS lot_id
             -- TH_ENG_STOCK_PLAN의 WORK_ORDER_ID와 DEMAND_ID는 NULL 처리해야함
             , NULL    AS work_order_id
             , NULL    AS demand_id
             , a.descr AS descr     -- Lot ID 구분자
			 , NULL    AS insp_type --2021.09.07 추가
        FROM   (
                SELECT item_id
                     , to_scm_site_id AS scm_site_id
                     , to_scm_site_id AS route_id
                     , to_scm_site_id AS operation_id
                  --   , DATEADD(S, 10, CONVERT(DATETIME, eta_date)) AS effstartdate -- 동일일자인 경우 WH > INT > REP 우선 적용 : 10 초 추가
                     , CASE WHEN eta_date < @p_plan_name THEN DATEADD(S, 10, CONVERT(DATETIME, @p_plan_name)) 
                            ELSE DATEADD(S, 10, CONVERT(DATETIME, eta_date))
                       END  AS effstartdate
                     , SUM(delivery_qty) AS qty
                     , NULL AS work_order_id
                     , NULL AS demand_id
                     , SUM(delivery_qty) AS wh_in_qty -- 해상 재고/해상재고 정보 추가
                     , 'INT::' + to_scm_site_id + '::' + item_id + '::' + t.eta_date + '::' + ISNULL(t.org_from_scm_site_id, '') AS lot_id -- 2018.06.14  From Site 구분 추가
                     , 'INT' AS descr
                FROM   scp_eng_intransitshpmnt_i_sn t WITH(NOLOCK)
                WHERE  t.modeling_id   = @p_modeling_id
                AND    t.plan_id       = @p_plan_id
                AND    t.plan_type     = @p_plan_type 
                AND    t.plan_seq      = @p_seq
                --AND    t.incoterms    <> 'FOB' -- eng에서 처리한 대로 사용
                AND    t.delivery_qty  > 0 
                AND   (t.eta_date IS NOT NULL OR t.eta_date <> '')
                GROUP BY item_id, to_scm_site_id, eta_date, ISNULL(t.org_from_scm_site_id, '') -- 2018.06.14  From Site 구분 추가
               ) a
             , (SELECT DISTINCT t.item_type, t.item_id
                FROM   th_eng_item_sn t WITH(NOLOCK)
                WHERE  t.master_id = @p_master_id
                AND    t.plan_id   = @p_engine_plan_id
               ) b
        WHERE  a.item_id = b.item_id
        AND    b.item_type <> 'R' -- 20140423 ksg 티아 요청으로 R Type의 재고는 올리지 않음
        ;		

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'2. 해상재고...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		*/ -- 20220321 주석 END

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


