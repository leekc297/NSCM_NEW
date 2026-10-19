
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_PLAN_BOM
 * Description  : FP DB와 SCM SDB의 BOM 정보를 ODB에 적재되도록 한다.

                  1. LGCE Plant Site 엔진용 BOM 데이터 생성

                  2. 외주 Plant Site 엔진용 BOM 데이터 생성

                  * PROC ITEM 에서 BOM 정보 정리 작업 수행함

 * OutTable     : TH_ENG_PLAN_BOM
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.16   KSW            전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.30   KSG            외주 Packer BOM 처리 수정
 * 2018.06.18   KSG            BOM Eff Start/End 처리 수정
 * 2018.09.11   KSG            OSP BOM : Plant 구분 제거 : 어느 한 Plant라도 존재하면 전체 BOM으로 구성
 * 2018.10.01   KSW            OSP BOM : 외주전극 부분 수정
 * 2018.10.24   KSW            동일 parent_item,  child_item 인데 소요량 차이로 인한 PK중복 오류방지위해서 GROUP BY 처리로 변경(FP의 SCM_BOM_M 테이블에 소요량 업데이트처리 중에 해당 PR_SCP_ENG_IN_FN_PROC_PLAN_BOM프로시저가 실행되어 오류발생함, FP업데이트 완료후에는 소요량이 동일하게 적용되어 오류발생하지 않음) (참고)주석1
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2025.09.03   ymh             속도지연 관련 hash 추가
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_PLAN_BOM]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_PLAN_BOM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_PLAN_BOM';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME    = CONVERT(DATETIME, @p_plan_name);

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
         , @v_division_comp    =  di.ATTRIBUTE4   -- 회사코드 
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id     ; 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
		
		DELETE /* PR_SCP_ENG_EE_FN_PROC_PLAN_BOM */
		FROM   th_eng_plan_bom_sn 
		WHERE  master_id = @p_master_id 
		AND    plan_id   = @p_engine_plan_id 
		;
        -----------------------------------------------------------
       
        -----------------------------------------------------------
        -- 1. LGCE Plant Site 
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_PLAN_BOM */ th_eng_plan_bom_sn 
        ( master_id
        , plan_id
        , parent_item_id
        , child_item_id
        , site_id
        , route_id
        , operation_id
        , binning_id
        , production_flag
        , bom_version_id
        , parent_item_rate
        , child_item_rate
        , alt_id
        , alt_priority
        , alt_rate
        , in_move_time
        , out_move_time
        , move_time_uom
        , descr
        )        
        SELECT @p_master_id      AS master_id
			 , @p_engine_plan_id AS plan_id

			 , a.parent_item_id  AS parent_item_id
			 , a.child_item_id   AS child_item_id
			 , c.eng_scm_site_id AS site_id
			 , a.flow_id         AS route_id
			 , a.flow_id         AS operation_id
			 , '-'               AS BINNING_ID
			 , 'Y'               AS PRODUCTION_FLAG
			 , a.bom_version_id  AS BOM_VERSION_ID
			 
             , 1                 AS PARENT_ITEM_RATE  -- 확인필요
             -- R인 경우 CHILD_ITEM_RATE = 1 로 설정 : PROC ITEM 에서 BOM 정보 정리 작업시 수행함
             -- Material PSI/Capa 사용하지 않으므로 가능함
			 , CASE WHEN ISNULL(MAX(a.parent_qty), 0) = 0 THEN 1
                    WHEN MAX(a.child_qty) < 0 THEN 0
                    WHEN ROUND(MAX(a.child_qty) / MAX(a.parent_qty), 3, 0) = 0 THEN 1
                    ELSE ROUND(IIF(MAX(a.child_qty) < 0, 0, MAX(a.child_qty)) / MAX(a.parent_qty), 3, 0)  
               END               AS CHILD_ITEM_RATE   -- 0인 정보는 엔진에서 Loading 하지 않음
             
             , NULL              AS ALT_ID
			 , MAX(a.alt_priority)    AS ALT_PRIORITY
			 , 1                 AS ALT_RATE
			 , '0'               AS IN_MOVE_TIME
			 , '0'               AS OUT_MOVE_TIME
			 , 'MINUTE'          AS MOVE_TIME_UOM
			 , NULL              AS DESCR

        /* 20181024 변경전                   
	    SELECT DISTINCT 
			   @p_master_id      AS master_id
			 , @p_engine_plan_id AS plan_id
			 , a.parent_item_id  AS parent_item_id
			 , a.child_item_id   AS child_item_id
			 , c.eng_scm_site_id AS site_id
			 , a.flow_id         AS route_id
			 , a.flow_id         AS operation_id
			 , '-'               AS BINNING_ID
			 , 'Y'               AS PRODUCTION_FLAG
			 , a.bom_version_id  AS BOM_VERSION_ID
			 
             , 1                 AS PARENT_ITEM_RATE  -- 확인필요
             -- R인 경우 CHILD_ITEM_RATE = 1 로 설정 : PROC ITEM 에서 BOM 정보 정리 작업시 수행함
             -- Material PSI/Capa 사용하지 않으므로 가능함
			 , CASE WHEN ISNULL(a.parent_qty, 0) = 0 THEN 1
                    WHEN a.child_qty < 0 THEN 0
                    WHEN ROUND(a.child_qty / a.parent_qty, 3, 0) = 0 THEN 1
                    ELSE ROUND(IIF(a.child_qty < 0, 0, a.child_qty) / a.parent_qty, 3, 0)  
               END               AS CHILD_ITEM_RATE   -- 0인 정보는 엔진에서 Loading 하지 않음
             
             , NULL              AS ALT_ID
			 , a.alt_priority    AS ALT_PRIORITY
			 , 1                 AS ALT_RATE
			 , '0'               AS IN_MOVE_TIME
			 , '0'               AS OUT_MOVE_TIME
			 , 'MINUTE'          AS MOVE_TIME_UOM
			 , NULL              AS DESCR
        */
		FROM   dbo.scp_eng_bomcomponents_i_sn a WITH(NOLOCK) 
            INNER HASH JOIN  ( SELECT plan_id
                      , plan_type    --20180321 plan_type 추가
                      , modeling_id
                      , seq
                      , enterprise
                      , parent_item_id
                      , company_id
                      , division_id
                      , site_id
                      , plant_id
                      , child_item_id
                      , model_id
                      , bom_version_id
                      , flow_id
                      , MAX(KEY_DATE) max_key_date                         
                 FROM  scp_eng_bomcomponents_i_sn WITH (NOLOCK)  
                 WHERE plan_id     = @p_plan_id  
                 AND   modeling_id = @p_modeling_id  
                 AND   seq         = @p_seq  
                 AND   enterprise  = @p_master_id  
                 AND   division_id = @p_division_id  
                 AND   plan_type   = @p_plan_type --20180406 추가
                 GROUP BY plan_id
                        , plan_type     --20180321 plan_type 추가
                        , modeling_id
                        , seq
                        , enterprise
                        , parent_item_id
                        , company_id
                        , division_id
                        , site_id
                        , plant_id
                        , child_item_id
                        , model_id
                        , bom_version_id
                        , flow_id
               ) d 
			ON    a.plan_id            = d.plan_id
			AND    a.plan_type          = d.plan_type     --20180321 plan_type 추가
			AND    a.modeling_id        = d.modeling_id
			AND    a.seq                = d.seq 
			AND    a.enterprise         = d.enterprise 
			AND    a.parent_item_id     = d.parent_item_id
			AND    a.company_id         = d.company_id
			AND    a.division_id        = d.division_id 
			AND    a.site_id            = d.site_id 
			AND    a.plant_id           = d.plant_id 
			AND    a.child_item_id      = d.child_item_id 
			AND    a.model_id           = d.model_id 
			AND    a.bom_version_id     = d.bom_version_id
			AND    a.flow_id            = d.flow_id 
			AND    a.key_date           = d.max_key_date -- 2025.09.02 YMH 속도지연문제로 HASH JOIN 으로 변경

	         --	FROM   dbo.scm_mst_item_route_sn a WITH(NOLOCK) --[LGCE_FPDEV_TR].[DBO].[SCM_MMD_ITEM_ROUTE_TEMP]
			 ,( -- 2022.04.04 jv건으로 수정
               SELECT t.*
               FROM   dbo.scm_mst_operation_flow_v t WITH(NOLOCK) --20180306 view로 변경 (변경전 : FROM   dbo.scm_mst_operation_flow_sn t WITH(NOLOCK) --[LGCE_FPDEV_TR].[DBO].[SCM_OPERATION_FLOW_M] )
                    , scm_mst_division            di WITH(NOLOCK)  -- 2022.04.04 추가 
               WHERE  t.valid_yn    = 'Y'  --20180306 수정 ( 변경전 : AND    SUBSTRING(operation_id, 1, 1) NOT IN ( 'S', 'F' ) -- SRS/활성화 공정 제외 )
               AND    SUBSTRING(t.flow_id, 1, 1) IN ('E', 'A')  -- 전극/Cell 공정
               AND    SUBSTRING(t.flow_id, 1, 2) NOT IN ('E0', 'E1')  -- E2000 이전 공정은 제외
               AND    t.division_id = di.division_id
               AND    di.valid_yn       = 'Y'
               AND    di.ATTRIBUTE4     = @v_division_comp -- 같은 회사 데이터만 가져오기
               /* 20220404 변경전  
               SELECT t.*
               FROM   dbo.scm_mst_operation_flow_v t WITH(NOLOCK) --20180306 view로 변경 (변경전 : FROM   dbo.scm_mst_operation_flow_sn t WITH(NOLOCK) --[LGCE_FPDEV_TR].[DBO].[SCM_OPERATION_FLOW_M] )
               WHERE  t.valid_yn    = 'Y'  --20180306 수정 ( 변경전 : AND    SUBSTRING(operation_id, 1, 1) NOT IN ( 'S', 'F' ) -- SRS/활성화 공정 제외 )
               AND    SUBSTRING(t.flow_id, 1, 1) IN ('E', 'A')  -- 전극/Cell 공정
               AND    SUBSTRING(t.flow_id, 1, 2) NOT IN ('E0', 'E1')  -- E2000 이전 공정은 제외
               --AND    t.division_id = @p_division_id -- 20180702 주석처리
               */ 
              ) b
			 , dbo.scm_mst_site_eng c WITH(NOLOCK)
		WHERE  a.division_id        = @p_division_id
		AND    a.plan_id            = @p_plan_id
        AND    a.plan_type          = @p_plan_type   --20180321 plan_type 컬럼 추가로 인한 조회조건 추가
		AND    a.modeling_id        = @p_modeling_id
		AND    a.seq                = @p_seq
		AND    a.enterprise         = @p_master_id
		AND    a.flow_id            IS NOT NULL
		AND    a.flow_id           <> ''  
		AND    a.flow_id           <> '-'  
		AND    a.child_qty         >  0  
		--AND    ISNULL(a.alt_priority, 1) = 1  -- 대치 BOM 제외 BOMCOMPONENT 생성 시 처리



		AND    a.company_id         = b.company_id
		--AND    a.division_id        = b.division_id  -- 20180706 주석처리
		AND    a.site_id            = b.site_id
		AND    a.flow_id            = b.flow_id
		AND    c.modeling_id        = @p_modeling_id
		AND    c.plan_id            = @p_plan_id
		AND    c.plan_type          = @p_plan_type
		AND    c.plan_seq           = @p_seq
		AND    a.division_id        = c.division_id
        AND    a.plan_type          = c.plan_type          --20180321 plan_type 추가
		AND    a.plant_id           = c.plant_id
		AND    b.operation_group    = c.operation_group
        AND    c.eng_scm_site_id    LIKE '%~***' --
		
		-- 2018.06.18 Plan Name 일자에 유효한 BOM
        --AND    a.eff_start_date    <= @d_plan_name
        AND    a.eff_end_date      >  @d_plan_name

        --20181024 추가
        GROUP BY a.parent_item_id, a.child_item_id, c.eng_scm_site_id
			   , a.flow_id, a.bom_version_id
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete... : PLANT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -----------------------------------------------------------
        -- 2. 외주 Plant Site : 
        --   Pack Site이면 해당 Item을 Parent로 하는 Cell Item을 Child로 추가 필요
        --   Cell Site이면 해당 Item을 Parent로 하는 전극 Item을 Child로 추가 필요
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_SP_PROC_PLAN_BOM */ th_eng_plan_bom_sn 
        ( master_id
        , plan_id
        , parent_item_id
        , child_item_id
        , site_id
        , route_id
        , operation_id
        , binning_id
        , production_flag
        , bom_version_id
        , parent_item_rate
        , child_item_rate
        , alt_id
        , alt_priority
        , alt_rate
        , in_move_time
        , out_move_time
        , move_time_uom
        , descr
        )
         SELECT DISTINCT 
			   @p_master_id      AS master_id
			 , @p_engine_plan_id AS plan_id
			 , a.parent_item_id  AS parent_item_id
			 , a.child_item_id   AS child_item_id
			 , b.eng_scm_site_id AS site_id
			 , b.plant_id        AS route_id
			 , b.plant_id        AS operation_id
			 , '-'               AS BINNING_ID
			 , 'Y'               AS PRODUCTION_FLAG
			 , '1'               AS BOM_VERSION_ID
			 
             , 1                 AS PARENT_ITEM_RATE  -- 확인필요
             -- R인 경우 CHILD_ITEM_RATE = 1 로 설정 : PROC ITEM 에서 BOM 정보 정리 작업시 수행함
             -- Material PSI/Capa 사용하지 않으므로 가능함
			 , 1                 AS CHILD_ITEM_RATE   -- 0인 정보는 엔진에서 Loading 하지 않음
             
             , NULL              AS ALT_ID
			 , NULL              AS ALT_PRIORITY
			 , 1                 AS ALT_RATE
			 , '0'               AS IN_MOVE_TIME
			 , '0'               AS OUT_MOVE_TIME
			 , 'MINUTE'          AS MOVE_TIME_UOM
			 , NULL              AS DESCR
		FROM   dbo.th_eng_plan_bom_sn a WITH(NOLOCK)
			 , dbo.scm_mst_site_eng  b WITH(NOLOCK)
             , (  -- 2022.04.04 jv건 수정
                select a.* 
                from   scm_mst_site_item    A WITH(NOLOCK)
                     , scm_mst_division    di WITH(NOLOCK)
                where a.division_id  =  di.division_id
                and   di.valid_yn    =  'Y' 
                and   di.attribute4  = @v_division_comp -- 같은 회사의 데이터만 가져오기.
                ) e
             /* 20220404 변경전
             , dbo.scm_mst_site_item e WITH(NOLOCK)  */ 
		WHERE  a.master_id = @p_master_id      
		AND    a.plan_id   = @p_engine_plan_id  

		AND    b.modeling_id        = @p_modeling_id
		AND    b.plan_id            = @p_plan_id
		AND    b.plan_type          = @p_plan_type
		AND    b.plan_seq           = @p_seq
        AND    b.osp_yn             = 'Y' -- 외주 
        AND    b.operation_group    = 'E' -- Elec Plant
				
		--AND    b.division_id        = e.division_id  -- 20180702 주석처리
		AND    b.scm_site_id        = e.scm_site_id
		AND    a.parent_item_id     = e.item_id
		    
        --AND    a.division_id        = @p_division_id  -- 20180702 주석처리
		;

        /* 20181001 수정전
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_PLAN_BOM */ th_eng_plan_bom_sn 
        ( master_id
        , plan_id
        , parent_item_id
        , child_item_id
        , site_id
        , route_id
        , operation_id
        , binning_id
        , production_flag
        , bom_version_id
        , parent_item_rate
        , child_item_rate
        , alt_id
        , alt_priority
        , alt_rate
        , in_move_time
        , out_move_time
        , move_time_uom
        , descr
        )              
  	    SELECT DISTINCT 
			   @p_master_id      AS master_id
			 , @p_engine_plan_id AS plan_id
			 , a.model_id        AS parent_item_id
			 , a.child_item_id   AS child_item_id
			 , b.eng_scm_site_id AS site_id
			 , b.plant_id        AS route_id
			 , b.plant_id        AS operation_id
			 , '-'               AS BINNING_ID
			 , 'Y'               AS PRODUCTION_FLAG
			 , '1'               AS BOM_VERSION_ID
			 
             , 1                 AS PARENT_ITEM_RATE  -- 확인필요
             -- R인 경우 CHILD_ITEM_RATE = 1 로 설정 : PROC ITEM 에서 BOM 정보 정리 작업시 수행함
             -- Material PSI/Capa 사용하지 않으므로 가능함
			 , ROUND(a.accumulated_child_qty, 3, 0) AS CHILD_ITEM_RATE   -- 0인 정보는 엔진에서 Loading 하지 않음
             
             , NULL              AS ALT_ID
			 , NULL              AS ALT_PRIORITY
			 , 1                 AS ALT_RATE
			 , '0'               AS IN_MOVE_TIME
			 , '0'               AS OUT_MOVE_TIME
			 , 'MINUTE'          AS MOVE_TIME_UOM
			 , NULL              AS DESCR
		FROM   dbo.scm_mst_model_final_item_bom_v a WITH(NOLOCK)
		--FROM   dbo.scm_mst_model_one_level_bom_v a WITH(NOLOCK)		
			 , dbo.scm_mst_site_eng  b WITH(NOLOCK)
			 , dbo.scm_mst_site_item e WITH(NOLOCK)
		WHERE  a.operation_group_id = 'E'   -- 전극 공정 : 외주는 Cell에 바로 Elec 만 처리함
		AND    a.accumulated_child_qty >  0  

		--AND    a.division_id        = b.division_id  -- 20180702 주석처리   
		-- 2018.09.11 Plant 구분 제거 : 어느 한 Plant라도 존재하면 전체 BOM으로 구성
		--AND    a.plant_id           = b.logistic_plant_id

		AND    b.modeling_id        = @p_modeling_id
		AND    b.plan_id            = @p_plan_id
		AND    b.plan_type          = @p_plan_type
		AND    b.plan_seq           = @p_seq
        AND    b.osp_yn             = 'Y' -- 외주 
        AND    b.operation_group    = 'A' -- Cell Plant
				
		--AND    b.division_id        = e.division_id  -- 20180702 주석처리
		AND    b.scm_site_id        = e.scm_site_id
		AND    a.model_id           = e.item_id
		
		-- 2018.06.18 Plan Name 일자에 유효한 BOM
        --AND    a.eff_start_date    <= @d_plan_name
        AND    a.eff_end_date      >  @d_plan_name
    
        --AND    a.division_id        = @p_division_id  -- 20180702 주석처리
		;
        */
        -----------------------------------------------------------
        -- * PROC ITEM 에서 BOM 정보 정리 작업 수행함
        -----------------------------------------------------------
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete... : OSP' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
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


