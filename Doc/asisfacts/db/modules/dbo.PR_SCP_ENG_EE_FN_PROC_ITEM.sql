
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_ITEM
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
 * 2018.01.11   KSW         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2022.04.04   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_ITEM]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_ITEM';
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

     ---(2022.04.04) 추가.
    DECLARE @v_division_group   NVARCHAR(30);    
    DECLARE @v_division_comp    NVARCHAR(30); 
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/   
    SELECT @v_division_group   =  di.attribute3 
         , @v_division_comp    =  di.ATTRIBUTE4
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id  ; 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	    DELETE /* PR_SCP_ENG_EE_FN_PROC_ITEM */ 
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
	    INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_ITEM */ th_eng_item_sn
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
             LEFT OUTER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 data 가져오기
                              SELECT i.item_id, MAX(i.item_uom) AS item_uom
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                                  ,  scm_mst_division   di WITH(NOLOCK)                              
                              WHERE  i.active_flag    = 'Y'
                              AND    i.item_uom IS NOT NULL                     
                              AND    di.valid_yn      =  'Y' 
                              AND    di.division_id   = i.division_id 
                              AND    di.attribute4    = @v_division_comp
                              GROUP BY i.item_id
                              /* 20220404 변경전
			                  SELECT i.item_id, MAX(i.item_uom) AS item_uom
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.active_flag = 'Y'
                              AND    i.item_uom IS NOT NULL
                              --AND    i.division_id = @p_division_id  -- 20180702 주석처리                              
                              GROUP BY i.item_id */ 
                             ) b
             ON  a.item = b.item_id
             LEFT OUTER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 data 가져오기
                              SELECT i.item_id, MAX(i.setup_attribute) AS setup_attribute
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                                  ,  scm_mst_division   di WITH(NOLOCK)      
                              WHERE  i.active_flag    = 'Y'
                              AND    i.setup_attribute IS NOT NULL
                              AND    di.valid_yn      =  'Y' 
                              AND    di.division_id   = i.division_id 
                              AND    di.attribute4    = @v_division_comp
                              GROUP BY i.item_id
                               /* 20220404 변경전
			                  SELECT i.item_id, MAX(i.setup_attribute) AS setup_attribute
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.active_flag = 'Y'
                              AND    i.setup_attribute IS NOT NULL
                              --AND    i.division_id = @p_division_id  -- 20180702 주석처리
                              GROUP BY i.item_id  */
                             ) c
             ON  a.item = c.item_id
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2 START';
        SET @v_description = '2. item_type = H  INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------- 
        -- 2. 중간 조립 부품 정보 : item_type = 'H'
        ----------------------------------------------------------- 
	    INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_ITEM */ th_eng_item_sn
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
             LEFT OUTER JOIN (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 data 가져오기
                              SELECT i.item_id, MAX(i.item_uom) AS item_uom
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                                  ,  scm_mst_division   di WITH(NOLOCK)                              
                              WHERE  i.active_flag    = 'Y'
                              AND    i.item_uom IS NOT NULL                     
                              AND    di.valid_yn      =  'Y' 
                              AND    di.division_id   = i.division_id 
                              AND    di.attribute4    = @v_division_comp
                              GROUP BY i.item_id
                              /* 20220404 변경전
			                  SELECT i.item_id, MAX(i.item_uom) AS item_uom
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.active_flag = 'Y'
                              AND    i.item_uom IS NOT NULL
                              --AND    i.division_id = @p_division_id  -- 20180702 주석처리
                              GROUP BY i.item_id  */
                             ) b
             ON  a.parent_item_id = b.item_id
             LEFT OUTER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 data 가져오기
                              SELECT i.item_id, MAX(i.setup_attribute) AS setup_attribute
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                                  ,  scm_mst_division   di WITH(NOLOCK)      
                              WHERE  i.active_flag    = 'Y'
                              AND    i.setup_attribute IS NOT NULL
                              AND    di.valid_yn      =  'Y' 
                              AND    di.division_id   = i.division_id 
                              AND    di.attribute4    = @v_division_comp
                              GROUP BY i.item_id
                               /* 20220404 변경전
			                  SELECT i.item_id, MAX(i.setup_attribute) AS setup_attribute
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.active_flag = 'Y'
                              AND    i.setup_attribute IS NOT NULL
                              --AND    i.division_id = @p_division_id  -- 20180702 주석처리
                              GROUP BY i.item_id  */
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
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 START';
        SET @v_description = '3. item_type = R  INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------- 
        -- 3. 최하위 부품 정보 : item_type = 'R' 
        ----------------------------------------------------------- 
	    INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_ITEM */ th_eng_item_sn
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
             LEFT OUTER JOIN (-- 2022.04.04 JV사업부 추가: 같은 회사 내 data 가져오기
                              SELECT i.item_id, MAX(i.item_uom) AS item_uom
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                                  ,  scm_mst_division   di WITH(NOLOCK)                              
                              WHERE  i.active_flag    = 'Y'
                              AND    i.item_uom IS NOT NULL                     
                              AND    di.valid_yn      =  'Y' 
                              AND    di.division_id   = i.division_id 
                              AND    di.attribute4    = @v_division_comp
                              GROUP BY i.item_id
                              /* 20220404 변경전
			                  SELECT i.item_id, MAX(i.item_uom) AS item_uom
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.active_flag = 'Y'
                              AND    i.item_uom IS NOT NULL
                              --AND    i.division_id = @p_division_id  -- 20180702 주석처리
                              GROUP BY i.item_id  */
                             ) b
             ON  a.child_item_id = b.item_id
             LEFT OUTER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 data 가져오기
                              SELECT i.item_id, MAX(i.setup_attribute) AS setup_attribute
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                                  ,  scm_mst_division   di WITH(NOLOCK)      
                              WHERE  i.active_flag    = 'Y'
                              AND    i.setup_attribute IS NOT NULL
                              AND    di.valid_yn      =  'Y' 
                              AND    di.division_id   = i.division_id 
                              AND    di.attribute4    = @v_division_comp
                              GROUP BY i.item_id
                               /* 20220404 변경전
			                  SELECT i.item_id, MAX(i.setup_attribute) AS setup_attribute
                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                              WHERE  i.active_flag = 'Y'
                              AND    i.setup_attribute IS NOT NULL
                              --AND    i.division_id = @p_division_id  -- 20180702 주석처리
                              GROUP BY i.item_id  */
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
				
        ----------------------------------------------------------- 
        -- 4. Planning BOM 정리 작업 : item_type = 'R' 
        ----------------------------------------------------------- 
		
        ----------------------------------------------------------- 
        -- 4-1 item Type 정보 Update
        ----------------------------------------------------------- 	
        SET @n_log_count = @@ROWCOUNT;	
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-1 START';
        SET @v_description = '4-1. item_type  UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
 
        ----------------------------------------------------------- 
        -- R인 경우 CHILD_ITEM_RATE = 1 로 설정
        ----------------------------------------------------------- 
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

        UPDATE th_eng_plan_bom_sn
        SET    descr = 'H'
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id
        AND   (descr <> 'R' OR descr IS NULL);	
		
        ----------------------------------------------------------- 
        -- 4-2 R이 아닌 Child가 존재하는 경우 R 인 Child 삭제대상 처리 : DESCR = 'X'
        ----------------------------------------------------------- 
        SET @n_log_count = @@ROWCOUNT;
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
        AND    bom.parent_item_id = b.parent_item_id;
		
        ----------------------------------------------------------- 
        -- 4-3 Child가 전부 R인 경우 하나만 제외하고 삭제대상 처리 : DESCR = 'X'
        ----------------------------------------------------------- 
        SET @n_log_count = @@ROWCOUNT;
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
        AND    d.rownum           > 1;
		
        ----------------------------------------------------------- 
        -- 4-4 Planning BOM DELETE : DESCR = 'X'
        ----------------------------------------------------------- 
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-4 START';
        SET @v_description = '4-4. descr = X  DELETE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        DELETE th_eng_plan_bom_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id
        AND    descr     = 'X'
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



