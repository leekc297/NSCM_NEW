
/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_ITEM
 * Description  : SDB의 Item 정보를 ODB에 적재되도록 한다.

                 ----------------------------------------------------------- 
                 -- 1. 제품 정보 : item_type = 'H'
                 ----------------------------------------------------------- 
                  - scp_eng_itemsitemstr_i 에서 item_type <> R 아닌 모든item
                  - item_type 값은 'H'로 정보생성 
                 
                 ----------------------------------------------------------- 
                 -- 2. 중간 조립 부품 정보 : item_type = 'H'
                 ----------------------------------------------------------- 
                  - th_eng_plan_bom 에서 parent_item_id가 위1에서 생성한 item_id가 아닌 모든 item
                  - item_type 값은 'H'로 정보생성 
                 
                 ----------------------------------------------------------- 
                 -- 3. 최하위 부품 정보 : item_type = 'R' 
                 -----------------------------------------------------------
                  - th_eng_plan_bom 에서 child_item_id가 위1,2에서 생성한 item_id가 아닌 모든 item
                  - item_type 값은 'R'로 정보생성 
                 
                 ----------------------------------------------------------- 
                 -- 4. Planning BOM 정리 작업 : item_type = 'R' 
                 -----------------------------------------------------------
                  - Child 중 H Type 이 존재하는 Parent의 R Type Child 삭제
				  - Child 가 전부 R Type 인 Parent의 R Type Child 중 하나만 남기고 삭제
                  - R인 경우 CHILD_ITEM_RATE = 1 로 설정
                    Material PSI/Capa 사용하지 않으므로 가능함

 * OutTable     : TH_ENG_ITEM
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.11   KSW            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.05.09   KSG            [전지고도화] Cell Package 하위 공정 삭제
 * 2023.02.16   KKC            PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: DUMMY 자재 생성(Trust Biz 모델링)
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_ITEM]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_ITEM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_ITEM';
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

	    DELETE /* PR_SCP_ENG_IN_FN_PROC_ITEM */ 
		FROM  dbo.th_eng_item_sn
        WHERE 1=1
        AND   plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
        ;
        ----------------------------------------------------------- 
       
        -- LOG
        SELECT @n_log_count = @@ROWCOUNT ;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1 START';
        SET @v_description = '1. item_type = H' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------- 
        -- 1. 제품 정보 : item_type = 'H'
        ----------------------------------------------------------- 
	    INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM */ th_eng_item_sn
			( master_id
			, plan_id
			, item_id
			, item_type
			, item_uom
			, flow_id
			, item_group_id
			, setup_group_id
			, is_finite
			, finite_term
			, finite_term_uom
			, safety_stock_qty
			, max_stock_qty
			, min_safety_term
			, min_safety_term_uom
			, buffer_time
			, buffer_time_uom
			, min_lot_size
			, max_lot_size
			, increment_lot_size
			, attribute_set_id
			, descr
			, item_uom_rate
			)
        SELECT DISTINCT  
               @p_master_id       AS master_id
             , @p_engine_plan_id  AS plan_id
             , a.item             AS item_id
             , 'H'                AS item_type
             , ISNULL(b.item_uom, 'EA')         AS item_uom
             , NULL               AS flow_id
             , a.item             AS item_group_id
             , ISNULL(c.setup_attribute, a.item) AS setup_group_id -- Net Demand에 동일 로직 적용
             , 'N'                AS is_finite -- 20180227 티라요청으로 수정( 변경전 : , 'Y'   AS is_finite)
             , 0                  AS finite_term
             , 'DAY'              AS finite_term_uom
             , 0                  AS safety_stock_qty
             , 0                  AS max_stock_qty
             , 0                  AS min_safety_term
             , 'DAY'              AS min_safety_term_uom
             , 0                  AS buffer_time
             , 'MINUTE'           AS buffer_time_uom
             , 0                  AS min_lot_size
             , 0                  AS max_lot_size
             , 0                  AS increment_lot_size
             , NULL               AS attribute_set_id
             , NULL               AS descr
             , NULL               AS item_uom_rate
        FROM (SELECT DISTINCT enterprise, t.item, t.item_type
              FROM   dbo.scp_eng_itemsitemstr_i_sn t WITH(NOLOCK)
              WHERE  t.plan_id     = @p_plan_id 
              AND    t.plan_type   = @p_plan_type   --20180321 plan_type 추가           
              AND    t.modeling_id = @p_modeling_id  
              AND    t.seq         = @p_seq 
              AND    t.enterprise  = @p_master_id 
              AND    t.item_type  <> 'R'
             ) a
             LEFT OUTER JOIN (
			                  SELECT i.item_id, MAX(i.item_uom) AS item_uom
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.division_id = @p_division_id
                              AND    i.active_flag = 'Y'
                              AND    i.item_uom IS NOT NULL
                              GROUP BY i.item_id
                             ) b
             ON  a.item = b.item_id
             LEFT OUTER JOIN (
			                  SELECT i.item_id, MAX(i.setup_attribute) AS setup_attribute
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.division_id = @p_division_id
                              AND    i.active_flag = 'Y'
                              AND    i.setup_attribute IS NOT NULL
                              GROUP BY i.item_id
                             ) c
             ON  a.item = c.item_id
        ;

        -- LOG
        SELECT @n_log_count = @@ROWCOUNT ;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2 START';
        SET @v_description = '2. item_type = H' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        ----------------------------------------------------------- 
        -- 2. 중간 조립 부품 정보 : item_type = 'H'
        ----------------------------------------------------------- 
	    INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM */ th_eng_item_sn
			( master_id
			, plan_id
			, item_id
			, item_type
			, item_uom
			, flow_id
			, item_group_id
			, setup_group_id
			, is_finite
			, finite_term
			, finite_term_uom
			, safety_stock_qty
			, max_stock_qty
			, min_safety_term
			, min_safety_term_uom
			, buffer_time
			, buffer_time_uom
			, min_lot_size
			, max_lot_size
			, increment_lot_size
			, attribute_set_id
			, descr
			, item_uom_rate
			)
        SELECT DISTINCT 
               @p_master_id       AS master_id
             , @p_engine_plan_id  AS plan_id
             , a.parent_item_id   AS item_id
             , 'H'                AS item_type
             , ISNULL(b.item_uom, 'EA')         AS item_uom
             , NULL               AS flow_id
             , a.parent_item_id   AS item_group_id
             , ISNULL(c.setup_attribute, a.parent_item_id) AS setup_group_id
             , 'N'                AS is_finite -- 20180227 티라요청으로 수정( 변경전 : , 'Y' AS is_finite -- Dummy Part 이면 N 으로 처리 필요)
             , 0                  AS finite_term 
             , 'DAY'              AS finite_term_uom
             , 0                  AS safety_stock_qty
             , 0                  AS max_stock_qty
             , 0                  AS min_safety_term
             , 'DAY'              AS min_safety_term_uom
             , 0                  AS buffer_time
             , 'MINUTE'           AS buffer_time_uom
             , 0                  AS min_lot_size
             , 0                  AS max_lot_size
             , 0                  AS increment_lot_size
             , NULL               AS attribute_set_id
             , NULL               AS descr
             , NULL               AS item_uom_rate
        FROM   th_eng_plan_bom_sn a WITH(NOLOCK)
             LEFT OUTER JOIN (
			                  SELECT i.item_id, MAX(i.item_uom) AS item_uom
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.division_id = @p_division_id
                              AND    i.active_flag = 'Y'
                              AND    i.item_uom IS NOT NULL
                              GROUP BY i.item_id
                             ) b
             ON  a.parent_item_id = b.item_id
             LEFT OUTER JOIN (
			                  SELECT i.item_id, MAX(i.setup_attribute) AS setup_attribute
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.division_id = @p_division_id
                              AND    i.active_flag = 'Y'
                              AND    i.setup_attribute IS NOT NULL
                              GROUP BY i.item_id
                             ) c
             ON  a.parent_item_id = c.item_id
        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.parent_item_id NOT IN (SELECT item_id 
                                        FROM   th_eng_item_sn WITH(NOLOCK)
                                        WHERE  master_id = @p_master_id
                                        AND    plan_id   = @p_engine_plan_id
                                       )
        ;

        -- LOG
        SELECT @n_log_count = @@ROWCOUNT ;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 START';
        SET @v_description = '3. item_type = R' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------- 
        -- 3. 최하위 부품 정보 : item_type = 'R' 
        ----------------------------------------------------------- 
	    INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM */ th_eng_item_sn
			( master_id
			, plan_id
			, item_id
			, item_type
			, item_uom
			, flow_id
			, item_group_id
			, setup_group_id
			, is_finite
			, finite_term
			, finite_term_uom
			, safety_stock_qty
			, max_stock_qty
			, min_safety_term
			, min_safety_term_uom
			, buffer_time
			, buffer_time_uom
			, min_lot_size
			, max_lot_size
			, increment_lot_size
			, attribute_set_id
			, descr
			, item_uom_rate
			)
        SELECT DISTINCT 
               @p_master_id       AS master_id
             , @p_engine_plan_id  AS plan_id
             , a.child_item_id    AS item_id
             , 'R'                AS item_type
             , ISNULL(b.item_uom, 'EA')         AS item_uom
             , NULL               AS flow_id
             , a.child_item_id    AS item_group_id
             , ISNULL(c.setup_attribute, a.child_item_id) AS setup_group_id
             , 'N'                AS is_finite -- 20180227 티라요청으로 수정( 변경전 : , 'Y' AS is_finite -- Dummy Part 이면 N 으로 처리 필요)
             , 0                  AS finite_term 
             , 'DAY'              AS finite_term_uom
             , 0                  AS safety_stock_qty
             , 0                  AS max_stock_qty
             , 0                  AS min_safety_term
             , 'DAY'              AS min_safety_term_uom
             , 0                  AS buffer_time
             , 'MINUTE'           AS buffer_time_uom
             , 0                  AS min_lot_size
             , 0                  AS max_lot_size
             , 0                  AS increment_lot_size
             , NULL               AS attribute_set_id
             , NULL               AS descr
             , NULL               AS item_uom_rate
        FROM   th_eng_plan_bom_sn a WITH(NOLOCK)
             LEFT OUTER JOIN (
			                  SELECT i.item_id, MAX(i.item_uom) AS item_uom
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.division_id = @p_division_id
                              AND    i.active_flag = 'Y'
                              AND    i.item_uom IS NOT NULL
                              GROUP BY i.item_id
                             ) b
             ON  a.child_item_id = b.item_id
             LEFT OUTER JOIN (
			                  SELECT i.item_id, MAX(i.setup_attribute) AS setup_attribute
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.division_id = @p_division_id
                              AND    i.active_flag = 'Y'
                              AND    i.setup_attribute IS NOT NULL
                              GROUP BY i.item_id
                             ) c
             ON  a.child_item_id = c.item_id
        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.child_item_id NOT IN (SELECT item_id 
                                       FROM   th_eng_item_sn WITH(NOLOCK)
                                       WHERE  master_id = @p_master_id
                                       AND    plan_id   = @p_engine_plan_id
                                      )
        ;
				
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-1 START';
        SET @v_description = N'3-1. Dummy 자재  INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------- 
        -- 3-1 최하위 부품 정보 : DUMMY 자재 생성, 2023.02.16 추가
        ----------------------------------------------------------- 	
	    INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_ITEM */ th_eng_item_sn
			( master_id
			, plan_id
			, item_id
			, item_type
			, item_uom
			, flow_id
			, item_group_id
			, setup_group_id
			, is_finite
			, finite_term
			, finite_term_uom
			, safety_stock_qty
			, max_stock_qty
			, min_safety_term
			, min_safety_term_uom
			, buffer_time
			, buffer_time_uom
			, min_lot_size
			, max_lot_size
			, increment_lot_size
			, attribute_set_id
			, descr
			, item_uom_rate
			)
        SELECT TOP 1 
			  @p_master_id       AS master_id
			, @p_engine_plan_id  AS plan_id
			, 'DUMMY'            AS item_id
			, a.item_type        AS item_type
			, a.item_uom         AS item_uom
			, a.flow_id          AS flow_id
			, 'DUMMY'            AS item_group_id
			, NULL               AS setup_group_id
			, 'N'                AS is_finite -- 20180227 티라요청으로 수정( 변경전 : , 'Y'   AS is_finite)
			, 0                  AS finite_term
			, 'DAY'              AS finite_term_uom
			, 0                  AS safety_stock_qty
			, 0                  AS max_stock_qty
			, 0                  AS min_safety_term
			, 'DAY'              AS min_safety_term_uom
			, 0                  AS buffer_time
			, 'MINUTE'           AS buffer_time_uom
			, 0                  AS min_lot_size
			, 0                  AS max_lot_size
			, 0                  AS increment_lot_size
			, NULL               AS attribute_set_id
			, NULL               AS descr
			, NULL               AS item_uom_rate
		  FROM th_eng_item_sn a WITH(NOLOCK)
		 WHERE 1=1
		   AND a.master_id   = @p_engine_plan_id  
		   AND a.plan_id     = @p_master_id
		   AND a.item_type   = 'R'
		;

        ----------------------------------------------------------- 
        -- 4. Planning BOM 정리 작업 : item_type = 'R' 
		--    20190509 [전지고도화] Cell Package 하위 공정 삭제 : A3000/A9000 외 A*** 공정은 제외되므로 해당 공정에는 R 만 하위에 달림
        ----------------------------------------------------------- 
		
        ----------------------------------------------------------- 
        -- 4-1 item Type 정보 Update
        ----------------------------------------------------------- 
        -- LOG
        SELECT @n_log_count = @@ROWCOUNT ;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-1 START';
        SET @v_description = '4-1. item_type  UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
 
      -- 전극 모델은 제외 : ksg 20180517   
        ----------------------------------------------------------- 
        -- 'NOTCHING' 공정 외는 R인 경우 CHILD_ITEM_RATE = 1 로 설정
        --    전극 소요량 산출을 위하여 'NOTCHING' 공정은 정상 Rate 처리함
        ----------------------------------------------------------- 
        
		-- 'NOTCHING' 공정 외 : CHILD_ITEM_RATE = 1 로 설정
        UPDATE th_eng_plan_bom_sn
        SET    descr           = 'R'
             , child_item_rate = 1
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id
        AND    child_item_id IN (
                                 SELECT item_id
                                 FROM   th_eng_item_sn i with(nolock)
                                 WHERE  i.master_id = @p_master_id
                                 AND    i.plan_id   = @p_engine_plan_id
                                 AND    i.item_type = 'R'
                                )
        AND    route_id NOT IN (
                               SELECT DISTINCT o.flow_id
                               FROM   scm_mst_location         l with(nolock)
                                    , scm_mst_site             s with(nolock)
                                    , scm_mst_operation_flow_v o with(nolock)
                               WHERE  l.division_id   = @p_division_id
                               AND    l.location_code = 'NOTCHING'
                               AND    l.valid_yn      = 'Y'

                               AND    l.division_id   = s.division_id
                               AND    l.scm_site_id   = s.scm_site_id
                               AND    s.valid_yn      = 'Y'

                               AND    s.division_id   = o.division_id
                               AND    s.site_id       = o.site_id
                               AND    l.operation_id  = o.operation_id
                               AND    o.active_flag   = 'Y'
                              );
          
        -- 'NOTCHING' 공정 : CHILD_ITEM_RATE = 정상 Rate로 설정되어 있음
        UPDATE th_eng_plan_bom_sn
        SET    descr           = 'R'
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id
        AND    child_item_id IN (
                                 SELECT item_id
                                 FROM   th_eng_item_sn i with(nolock)
                                 WHERE  i.master_id = @p_master_id
                                 AND    i.plan_id   = @p_engine_plan_id
                                 AND    i.item_type = 'R'
                                )
        AND    route_id  IN (
                             SELECT DISTINCT o.flow_id
                             FROM   scm_mst_location         l with(nolock)
                                  , scm_mst_site             s with(nolock)
                                  , scm_mst_operation_flow_v o with(nolock)
                             WHERE  l.division_id   = @p_division_id
                             AND    l.location_code = 'NOTCHING'
                             AND    l.valid_yn      = 'Y'

                             AND    l.division_id   = s.division_id
                             AND    l.scm_site_id   = s.scm_site_id
                             AND    s.valid_yn      = 'Y'

                             AND    s.division_id   = o.division_id
                             AND    s.site_id       = o.site_id
                             AND    l.operation_id  = o.operation_id
                             AND    o.active_flag   = 'Y'
                            );

      -- 전극 모델은 제외 : ksg 20180517  : 아래 주석 처리 Start
	/*	
        -- 1. ESS사업부 외 : R인 경우 CHILD_ITEM_RATE = 1 로 설정
        --    Material PSI/Capa 사용하지 않으므로 가능함
        IF @p_division_id <> '82' 
        BEGIN 
          UPDATE th_eng_plan_bom_sn
          SET    descr           = 'R'
               , child_item_rate = 1
          WHERE  master_id = @p_master_id
          AND    plan_id   = @p_engine_plan_id
          AND    child_item_id IN (
                                   SELECT item_id
                                   FROM   th_eng_item_sn i with(nolock)
                                   WHERE  i.master_id = @p_master_id
                                   AND    i.plan_id   = @p_engine_plan_id
                                   AND    i.item_type = 'R'
                                  );
        END
        -- 2. ESS사업부 : 'NOTCHING' 공정 외는 R인 경우 CHILD_ITEM_RATE = 1 로 설정
        --    ESS용 전극 소요량 산출을 위하여 'NOTCHING' 공정은 정상 Rate 처리함
        --   대상 사업부 변경 시 아래쪽 Update 문의 Route_id NOT IN 조건 수정 필요함
        ELSE
        BEGIN
          -- 'NOTCHING' 공정 외 : CHILD_ITEM_RATE = 1 로 설정
          UPDATE th_eng_plan_bom_sn
          SET    descr           = 'R'
               , child_item_rate = 1
          WHERE  master_id = @p_master_id
          AND    plan_id   = @p_engine_plan_id
          AND    child_item_id IN (
                                   SELECT item_id
                                   FROM   th_eng_item_sn i with(nolock)
                                   WHERE  i.master_id = @p_master_id
                                   AND    i.plan_id   = @p_engine_plan_id
                                   AND    i.item_type = 'R'
                                  )
          AND    route_id NOT IN (
                               SELECT DISTINCT o.flow_id
                               FROM   scm_mst_location         l with(nolock)
                                    , scm_mst_site             s with(nolock)
                                    , scm_mst_operation_flow_v o with(nolock)
                               WHERE  l.division_id   = '82'
                               AND    l.location_code = 'NOTCHING'
                               AND    l.valid_yn      = 'Y'

                               AND    l.division_id   = s.division_id
                               AND    l.scm_site_id   = s.scm_site_id
                               AND    s.valid_yn      = 'Y'

                               AND    s.division_id   = o.division_id
                               AND    s.site_id       = o.site_id
                               AND    l.operation_id  = o.operation_id
                               AND    o.active_flag   = 'Y'
                              );
          
          -- 'NOTCHING' 공정 : CHILD_ITEM_RATE = 정상 Rate로 설정되어 있음
          UPDATE th_eng_plan_bom_sn
          SET    descr           = 'R'
          WHERE  master_id = @p_master_id
          AND    plan_id   = @p_engine_plan_id
          AND    child_item_id IN (
                                   SELECT item_id
                                   FROM   th_eng_item_sn i with(nolock)
                                   WHERE  i.master_id = @p_master_id
                                   AND    i.plan_id   = @p_engine_plan_id
                                   AND    i.item_type = 'R'
                                  )
          AND    route_id  IN (
                               SELECT DISTINCT o.flow_id
                               FROM   scm_mst_location         l with(nolock)
                                    , scm_mst_site             s with(nolock)
                                    , scm_mst_operation_flow_v o with(nolock)
                               WHERE  l.division_id   = '82'
                               AND    l.location_code = 'NOTCHING'
                               AND    l.valid_yn      = 'Y'

                               AND    l.division_id   = s.division_id
                               AND    l.scm_site_id   = s.scm_site_id
                               AND    s.valid_yn      = 'Y'

                               AND    s.division_id   = o.division_id
                               AND    s.site_id       = o.site_id
                               AND    l.operation_id  = o.operation_id
                               AND    o.active_flag   = 'Y'
                              );
        END -- IF @p_division_id <> '82'
*/ -- 전극 모델은 제외 : ksg 20180517  : 아래 주석 처리 End

        UPDATE th_eng_plan_bom_sn
        SET    descr = 'H'
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id
        AND   (descr <> 'R' OR descr IS NULL);	
		
        ----------------------------------------------------------- 
        -- 4-2 R이 아닌 Child가 존재하는 경우 R 인 Child 삭제대상 처리 : DESCR = 'X'
        ----------------------------------------------------------- 
        -- LOG
        SELECT @n_log_count = @@ROWCOUNT ;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-2 START';
        SET @v_description = '4-2. descr = X  UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        UPDATE th_eng_plan_bom_sn
        SET    descr = 'X'
        FROM   th_eng_plan_bom_sn bom with(nolock)
             ,(
               SELECT parent_item_id, site_id, route_id, operation_id, count(*) AS cnt
               FROM  (
                      SELECT parent_item_id, site_id, route_id, operation_id, descr, count(*) AS cnt
                      FROM   th_eng_plan_bom_sn b with(nolock)
                      WHERE  master_id = @p_master_id
                      AND    plan_id   = @p_engine_plan_id
                      GROUP BY parent_item_id, site_id, route_id, operation_id, descr
                     ) a
               GROUP BY parent_item_id, site_id, route_id, operation_id
               HAVING count(*) > 1
               ) b
        WHERE  bom.master_id      = @p_master_id
        AND    bom.plan_id        = @p_engine_plan_id
        AND    bom.descr          = 'R'
        AND    bom.site_id        = b.site_id
        AND    bom.route_id       = b.route_id
        AND    bom.operation_id   = b.operation_id
        AND    bom.parent_item_id = b.parent_item_id
        AND    bom.route_id NOT IN (
                               SELECT DISTINCT o.flow_id
                               FROM   scm_mst_location         l with(nolock)
                                    , scm_mst_site             s with(nolock)
                                    , scm_mst_operation_flow_v o with(nolock)
                               WHERE  l.division_id   = @p_division_id -- NOTCHING 공정의 R처리 제외 -- 전극 모델은 제외 : ksg 20180517
                               --WHERE  l.division_id   = '82'  -- ESS 만 NOTCHING 공정의 R처리 제외
                               AND    l.location_code = 'NOTCHING'
                               AND    l.valid_yn      = 'Y'

                               AND    l.division_id   = s.division_id
                               AND    l.scm_site_id   = s.scm_site_id
                               AND    s.valid_yn      = 'Y'

                               AND    s.division_id   = o.division_id
                               AND    s.site_id       = o.site_id
                               AND    l.operation_id  = o.operation_id
                               AND    o.active_flag   = 'Y'
                              );	
		
        ----------------------------------------------------------- 
        -- 4-3 Child가 전부 R인 경우 하나만 제외하고 삭제대상 처리 : DESCR = 'X'
        ----------------------------------------------------------- 
        -- LOG
        SELECT @n_log_count = @@ROWCOUNT ;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-3 START';
        SET @v_description = '4-3. descr = X  UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        UPDATE th_eng_plan_bom_sn
        SET    descr = 'X'
        FROM   th_eng_plan_bom_sn bom with(nolock)
             ,(
               SELECT c.parent_item_id, c.site_id, c.route_id, c.operation_id, c.child_item_id
                    , ROW_NUMBER() OVER (PARTITION BY c.site_id, c.route_id, c.operation_id, c.parent_item_id ORDER BY c.site_id, c.route_id, c.operation_id, c.parent_item_id, c.child_item_id) AS rownum
               FROM   th_eng_plan_bom_sn c with(nolock)
                    ,(
                      SELECT parent_item_id, site_id, route_id, operation_id, descr, count(*) AS cnt
                      FROM   th_eng_plan_bom_sn b with(nolock)
                      WHERE  master_id = @p_master_id
                      AND    plan_id   = @p_engine_plan_id
                      AND    descr     = 'R'
                      GROUP BY parent_item_id, site_id, route_id, operation_id, descr
                      HAVING count(*) > 1
                     ) b
               WHERE  c.master_id      = @p_master_id
               AND    c.plan_id        = @p_engine_plan_id
               AND    c.descr          = 'R'
               AND    c.site_id        = b.site_id
               AND    c.route_id       = b.route_id
               AND    c.operation_id   = b.operation_id
               AND    c.parent_item_id = b.parent_item_id
              ) d
        WHERE  bom.master_id      = @p_master_id
        AND    bom.plan_id        = @p_engine_plan_id
        AND    bom.descr          = 'R'
        AND    bom.site_id        = d.site_id
        AND    bom.route_id       = d.route_id
        AND    bom.operation_id   = d.operation_id
        AND    bom.parent_item_id = d.parent_item_id
        AND    bom.child_item_id  = d.child_item_id
        AND    d.rownum           > 1
        AND    bom.route_id NOT IN (
                               SELECT DISTINCT o.flow_id
                               FROM   scm_mst_location         l with(nolock)
                                    , scm_mst_site             s with(nolock)
                                    , scm_mst_operation_flow_v o with(nolock)
                               WHERE  l.division_id   = @p_division_id -- NOTCHING 공정의 R처리 제외 -- 전극 모델은 제외 : ksg 20180517
                               --WHERE  l.division_id   = '82'  -- ESS 만 NOTCHING 공정의 R처리 제외
                               AND    l.location_code = 'NOTCHING'
                               AND    l.valid_yn      = 'Y'

                               AND    l.division_id   = s.division_id
                               AND    l.scm_site_id   = s.scm_site_id
                               AND    s.valid_yn      = 'Y'

                               AND    s.division_id   = o.division_id
                               AND    s.site_id       = o.site_id
                               AND    l.operation_id  = o.operation_id
                               AND    o.active_flag   = 'Y'
                              );
		
        ----------------------------------------------------------- 
        -- 4-4 Planning BOM DELETE : DESCR = 'X'
        ----------------------------------------------------------- 
        -- LOG
        SELECT @n_log_count = @@ROWCOUNT ;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-4 START';
        SET @v_description = '4-4. descr = X  DELETE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
        DELETE th_eng_plan_bom_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id
        AND    descr     = 'X'

  
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
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

