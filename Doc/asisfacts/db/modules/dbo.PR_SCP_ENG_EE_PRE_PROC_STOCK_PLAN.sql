
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_STOCK_PLAN
 * Description  : ODB의 재고/해상재고 정보를 ODB에 적재되도록 한다.

 * EXEC 
                  DECLARE  @p_plan_cycle  NVARCHAR(150)   = 'WEEKLY'
                          , @p_plan_name   nvarchar(4000)  = '20180625'
                          , @p_plan_id     nvarchar(4000)  = '1032'
                          , @p_modeling_id nvarchar(4000)  = '4'
                          , @p_seq         nvarchar(4000)  = '1'
                          , @p_plan_type   nvarchar(4000)  = 'PR'
                          , @p_master_id   nvarchar(4000)  = 'EE::WEEKLY'
                          , @p_division_id nvarchar(30)    = 'EE'
                          , @p_engine_plan_id nvarchar(4000) = '1032::PR::1'
	
                  EXEC PR_SCP_ENG_EE_PRE_PROC_STOCK_PLAN @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id             
                    
                  select * from th_eng_stock_plan_sn WITH (NOLOCK)
                  where  master_id = 'EE::WEEKLY'
                  and    plan_id   = '1032::PR::1'
                  ;

 * OutTable     : th_eng_stock_plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.22   KSW         전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.14   KSG         INT : From Site 구분 추가
 * 2021.09.07   KKC         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선, 전진검사 재고상태 구분 추가
 * 2021.11.30   KKC         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선, LOT_ID에 INSP_TYPE 추가(UNIQUE)
 * 2022.09.15   LHS         PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2: INT재고 가용시간 +10초 설정로직 제거하고, STOCK_SEQ를 후순위로 정의
 * 2023.06.26   KKC         PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 재고 로직 변경 (기존 : 음수재고 제외 -> 변경 : 음수재고까지 SUM 한 후에 0보도 큰 재고(INV 재고만) 반영
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_STOCK_PLAN]  
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_STOCK_PLAN';
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

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
        DELETE   /* PR_SCP_ENG_EE_PRE_PROC_STOCK_PLAN */
        FROM     th_eng_stock_plan_sn
        WHERE    master_id = @p_master_id 
        AND      plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------
        
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_STOCK_PLAN */ th_eng_stock_plan_sn
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
		  , insp_type  --전진검사 재고상태 구분, 2021.09.07 추가
        )
        SELECT @p_master_id                                   AS master_id
             , @p_engine_plan_id                              AS plan_id
               /*~(2022.09.15) Intransit재고를 후순위로 사용하게 하기 위해 seq에 항목 추가.~*/
             , ROW_NUMBER() OVER(ORDER BY a.item_id, a.scm_site_id, a.route_id, a.operation_id, a.effstartdate , case when a.descr = 'INT' then 2 else 1 end  ) AS stock_seq
             /* 220915 수정전 코드
             , ROW_NUMBER() OVER(ORDER BY a.item_id, a.scm_site_id, a.route_id, a.operation_id, a.effstartdate) AS stock_seq
             */ 
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
             , NULL        AS work_order_id
             , NULL        AS demand_id
             , a.descr     AS descr     -- Lot ID 구분자
			 , a.insp_type AS insp_type -- 전진검사 구분값, 2021.09.07 추가
        FROM   (
                SELECT item_id
                     , scm_site_id
                     , scm_site_id   AS route_id
                     , scm_site_id   AS operation_id                  
                     --, CONVERT(DATE, CONVERT(CHAR(8), available_date, 112)) AS effstartdate -- 동일일자인 경우 WH > INT > REP 우선 적용
                     -- BOH 적용을 위하여 Plant Start Date의 재고는 전일자로 Input하기로 함
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N'
                                 THEN DATEADD(DD, -1, CONVERT(DATE, CONVERT(CHAR(8), available_date, 112))) 
                            ELSE      CONVERT(DATE, CONVERT(CHAR(8), available_date, 112))  
                       END            AS effstartdate
                     , SUM(qty)       AS qty
                     , NULL           AS work_order_id
                     , NULL           AS demand_id
                     , 0              AS wh_in_qty -- 해상 재고/해상재고 정보 추가
                     --, 'WH::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112) AS lot_id
                     --, 'WH' AS descr
					 --//2021.11.30 수정/보완, wip_type_code별 lot_id 생성
					 , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'WH::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                            ELSE      'WH_HOLD::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                       END + '::' +  ISNULL(t.wip_type_code, 'NONE')      
					                  AS lot_id					 
                     /*
					 , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'WH::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                            ELSE      'WH_HOLD::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                       END            AS lot_id
					 */
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'WH'
                            ELSE      'WH_HOLD'
                       END             AS descr
                     , t.wip_type_code AS insp_type --2021.09.07 추
                FROM   scp_eng_inventory_i_sn t WITH(NOLOCK)
                WHERE  t.modeling_id = @p_modeling_id
                AND    t.plan_id     = @p_plan_id
                AND    t.plan_type   = @p_plan_type 
                AND    t.plan_seq    = @p_seq
                AND    t.stock_type <> 'FOR' 
                AND    t.qty         > 0 
                --AND    t.qty         > 0    --2023.06.26 변경
                GROUP BY item_id
				       , scm_site_id
					   , CONVERT(CHAR(8), available_date, 112)
					   , ISNULL(t.wiphold_yn, 'N')
					   , t.wip_type_code  --2021.09.07 추가
			    HAVING SUM(t.qty) > 0	      --2023.06.26 변경			      
                UNION ALL
                -- 활성화 재고 : FOR 로 처리
                SELECT item_id
                     , scm_site_id
                     , scm_site_id   AS route_id
                     , scm_site_id   AS operation_id                  
                     --, CONVERT(DATE, CONVERT(CHAR(8), available_date, 112)) AS effstartdate -- 동일일자인 경우 WH > INT > REP 우선 적용
                     , CASE WHEN CONVERT(CHAR(8), available_date, 112) < @p_plan_name 
                                 THEN CONVERT(DATE, CONVERT(CHAR(8), @p_plan_name, 112))   -- available_date 가 과거인 경우 Plan Name으로 처리함
                            ELSE      CONVERT(DATE, CONVERT(CHAR(8), available_date, 112))  
                       END            AS effstartdate
                     , SUM(qty)       AS qty
                     , NULL           AS work_order_id
                     , NULL           AS demand_id
                     , 0              AS wh_in_qty -- 해상 재고/해상재고 정보 추가
                     --, 'FOR::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112) AS lot_id
                     --, 'FOR' AS descr
					 
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'FOR::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                            ELSE      'FOR_HOLD::' + scm_site_id + '::' + item_id + '::' + CONVERT(CHAR(8), available_date, 112)
                       END            AS lot_id
					 
                     , CASE WHEN ISNULL(t.wiphold_yn, 'N') = 'N' 
                                 THEN 'FOR'
                            ELSE      'FOR_HOLD'
                       END            AS descr
					 , NULL           AS insp_type --2021.09.07 추가
                FROM   scp_eng_inventory_i_sn t WITH(NOLOCK)
                WHERE  t.modeling_id = @p_modeling_id
                AND    t.plan_id     = @p_plan_id
                AND    t.plan_type   = @p_plan_type 
                AND    t.plan_seq    = @p_seq
                AND    t.stock_type  = 'FOR' -- 활성화 재고
                AND    t.qty         > 0 
                GROUP BY item_id, scm_site_id, CONVERT(CHAR(8), available_date, 112), ISNULL(t.wiphold_yn, 'N')
                UNION ALL
                -- intransit shipment 재고 
                SELECT item_id
                     , to_scm_site_id AS scm_site_id
                     , to_scm_site_id AS route_id
                     , to_scm_site_id AS operation_id
                     /*~(2022.09.15) 가용시간에 10초 추가한 로직을 제거하고 대신 (위쪽)stock_seq에 다른 타입보다 INT가 후순위가 되도록 한다.~*/ 
                     , CASE WHEN eta_date < @p_plan_name    THEN CONVERT(DATETIME, @p_plan_name)  
                            ELSE CONVERT(DATETIME, eta_date) 
                            END  AS effstartdate
                     /* 220915 수정전 코드 
                  --   , DATEADD(S, 10, CONVERT(DATETIME, eta_date)) AS effstartdate -- 동일일자인 경우 WH > INT > REP 우선 적용 : 10 초 추가
                     , CASE WHEN eta_date < @p_plan_name THEN DATEADD(S, 10, CONVERT(DATETIME, @p_plan_name)) 
                            ELSE DATEADD(S, 10, CONVERT(DATETIME, eta_date))
                       END  AS effstartdate
                     */ 
                     , SUM(delivery_qty) AS qty
                     , NULL              AS work_order_id
                     , NULL              AS demand_id
                     , SUM(delivery_qty) AS wh_in_qty -- 해상 재고/해상재고 정보 추가
                     , 'INT::' + to_scm_site_id + '::' + item_id + '::' + t.eta_date + '::' + ISNULL(t.org_from_scm_site_id, '') AS lot_id -- 2018.06.14  From Site 구분 추가
                     , 'INT'             AS descr
                     , NULL              AS insp_type --2021.09.07 추가
				FROM   scp_eng_intransitshpmnt_i_sn t WITH(NOLOCK)
                WHERE  t.modeling_id   = @p_modeling_id
                AND    t.plan_id       = @p_plan_id
                AND    t.plan_type     = @p_plan_type 
                AND    t.plan_seq      = @p_seq
                --AND    t.incoterms    <> 'FOB' -- eng에서 처리한 대로 사용
                AND    t.delivery_qty  > 0 
                AND   (t.eta_date IS NOT NULL OR t.eta_date <> '')
                GROUP BY item_id, to_scm_site_id, eta_date, ISNULL(t.org_from_scm_site_id, '') -- 2018.06.14  From Site 구분 추가
   --         UNION ALL
   ---- 3. 자재재고/해상재고
   --         SELECT cd.enterprise
   --              , cd.item_id
   --              , cd.sitename AS siteid
   --              , cd.sitename AS route_id
   --              , cd.sitename AS operation_id
   --              , TRUNC(cd.effstartdate) + 20/24/60/60 AS effstartdate -- 동일일자인 경우 WH > INT > REP 우선 적용 : 20 초 추가
   --              , SUM(cba.value) AS qty
   --              , NULL AS work_order_id
   --              , NULL AS demand_id
   --              , 0 AS wh_in_qty -- 해상 재고/해상재고 정보 추가
   --              , 'REP::' + cd.sitename + '::' + cd.item + '::' + TO_CHAR(cd.effstartdate, 'YYYYMMDD') AS lot_id
   --              , 'REP' AS descr
               ) a
             , (SELECT DISTINCT t.item_type, t.item_id
                FROM   th_eng_item_sn t WITH(NOLOCK)
                WHERE  t.master_id = @p_master_id
                AND    t.plan_id   = @p_engine_plan_id
               ) b
        WHERE  a.item_id = b.item_id
        AND    b.item_type <> 'R' -- 20140423 ksg 티라 요청으로 R Type의 재고는 올리지 않음
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
