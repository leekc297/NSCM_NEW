

/*
 * Program ID   : PR_SCP_ENG_IN_PRE_SET_INVENTORY
 * Description  : SDB의 재고정보(scm_dnm_stock_v)를 ODB의 plan을수행용 재고중간정보(scp_eng_inventory_i)에 적재되도록 한다.
                    
                  1. (SALES site) site타입이 SALES인 재고정보 생성
                  
                  2. (SALES site) 위 1에서 생성된 재고정보에서 'scm_site_id', 'operation_id' 변경
                     - 동일scm_site_id 값중 
                       max version_no인 dm_pln_net_demand(DM Demand정보) 테이블에서 'scm_site_id' 가 일치하는 값중에서 
                       MAX incoterms 값을 구한뒤 ['scm_site_id' + '~' + 'incoterms'] 형태로 변경하면됨
                       (참고 : operation_id = ['scm_site_id' + '~' + 'incoterms'] 형태로 'scm_site_id'값과 동일하게 변경함)
                  
                  3. (PLANT site) site타입이 PLANT인 재고정보 생성
                  
                  4. (PLANT site) 위3에서 생성된 재고정보에서 'scm_site_id' 변경(외주셀/팩 변경제외)
                                       
                  5. 활성화-Cell site의 재고정보 생성(외주셀/팩 생성제외)                     
                     -  scm_dnm_stock_aging_v 에서 site타입이 Plant인 재고정보에서 ['scm_site_id'] => ['scm_site_id' + '~001'] 형태로 변경 후 데이터 생성함                       

 * OutTable     : SCP_ENG_INVENTORY_I
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.18   KSW            전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018.07.17   KSW            VMI 대상 INCOTERS를 'DAP'로 처리 
 * 2018.07.17   KSW            팩분리(~***, ~003) 적용관련 수정
 * 2018.08.22   KSW            외주 셀/팩 ***만 생성( 외주셀 : 001, 002, 003 생성제외, 외주팩 : 003 생성제외)
 * 2018.12.05   KSG            SO Reserve Stock : result_type = 'B' : 해상재고 대신 To Site의 재고로 처리
 * 2020.05.19   KSG            C20200519-000150 VMI-in Request CIP조건 입력 시 출하 계획이 D조건으로 생성되는 시스템 수정 요청드립니다 : ESS인 경우 VMI 라도 'DAP' 처리 안 함
 * 2020.10.28   KSG            ESS인 VMI : 'DAP' 처리
 * 2021.06.18   KSG            C20210617-000105  [SCM PI팀] GSCM의 소형 MES→OWMS, 위탁재고 정합성 향상을 위한 기능변경건 : location_code 정보 추가
 * 2022.01.21   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : Stock_v -> Stock 테이블로 변경
 * 2023.07.07   LHS            PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리: cell_product(CP)의 plant eng_site_id를 '~***' -> '~002' 로 변경.
 * 2024.04.04   KSG            E20240401-000322 SO reserved stock 로직 변경 요청 : SO Reserved Stock  다른 재고와 동일하게 일요일 기준 재고만 반영 되도록 수정
 * 2025.04.10   KJJ            E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발 
 * 2025.09.17   YMH			   20250918-001297 SALES SITE 재고정상 반영을 위해 컷오프시간 하드코딩에서 최종CUTOFFTIME 으로 로직 개선.
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_IN_PRE_SET_INVENTORY]
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
    --SET ANSI_WARNINGS OFF;
    SET ANSI_WARNINGS ON;
    SET ANSI_NULLS ON;

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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_SET_INVENTORY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_INVENTORY_I';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8)  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
	DECLARE @v_cutoff_day        NVARCHAR(10) = CONVERT(CHAR(10), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
    DECLARE @d_cutoff_day        DATETIME     = CONVERT(DATETIME, @v_cutoff_day)
	DECLARE @v_demand_cutoff_day NVARCHAR(8)  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'TUE')), 112); -- 당주 화요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

	
  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	    -- 20250918-001297 SALES SITE 재고정상 반영을 위해 컷오프시간 하드코딩에서 최종CUTOFFTIME 으로 로직 개선.
	    -- 2025-09-16 김춘동. 최종 cutoff 일자 조회 방식 수정
	    -- 최근 3일 이내 최신 버전
	    SELECT @v_demand_cutoff_day = ISNULL(MAX(p.cutoff_yyyymmdd)
                                           , CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 화요일 YYYYMMDD
                                            )
        FROM   dbo.dm_pln_net_demand p WITH(NOLOCK)
        WHERE  p.division_id      = @p_division_id 
        AND    p.cutoff_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -3, getdate()), 112) -- 최근 3일 이내
        ;
		
		DELETE /* PR_SCP_ENG_IN_PRE_SET_INVENTORY */ 
		FROM   scp_eng_inventory_i_sn
		WHERE  modeling_id = @p_modeling_id  
	    AND    plan_id = @p_plan_id      
	    AND    plan_type = @p_plan_type    
		AND    plan_seq = @p_seq          
		AND    division_id = @p_division_id  
		;

        -----------------------------------------------------------
        -- 1. Sales 
        -----------------------------------------------------------
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 1 START', N'1. Sales  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;

        INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_INVENTORY */ scp_eng_inventory_i_sn 
         (modeling_id, plan_id, plan_type, plan_seq
        , division_id, scm_site_id, org_scm_site_id, company_id, site_id, plant_id
        , factory_id, storage_id, cutoff_date, seq, stock_type, item_id, lane
        , production_type, available_date, remain_lead_time, holding_date
        , qty, qty_uom, stock_status, operation_id, line_id
        , outsourcing_flag, outsourcing_factory, description
        , fp_apply_operation_id, fp_apply_item_id, fp_apply_wipqty, wiphold_yn, wip_type_code
        , qty2, modify_fp_apply_wipqty, modify_description, cal_qty, formation_rework_type
        , created_by, creation_date, last_updated_by, last_update_date
        , location, site_item_yn, site_type
		, from_scm_site_id -- 2025.04.10 추가
         )
		SELECT --DISTINCT 
               @p_modeling_id  AS modeling_id
			 , @p_plan_id      AS plan_id
			 , @p_plan_type    AS plan_type
			 , @p_seq          AS plan_seq
			 , @p_division_id  AS division_id
			 , a.scm_site_id   AS scm_site_id --  뒤에서 Update
			 , a.scm_site_id   AS org_scm_site_id
			 , a.company_id
			 , a.site_id       AS site_id 
			 , a.plant_id
			 , a.factory_id
			 , a.storage_id
			 , a.cutoff_date
			 , a.seq
			 , a.stock_type
			 , a.item_id
			 , a.lane
			 , a.production_type
             , CASE WHEN ISNULL(a.wiphold_yn, '') = ''                        THEN CONVERT(DATETIME, @p_plan_name)
                    WHEN a.wiphold_yn             = 'N'                       THEN CONVERT(DATETIME, @p_plan_name)
                    WHEN CONVERT(CHAR(8), available_date, 112) < @p_plan_name THEN CONVERT(DATETIME, @p_plan_name)
                    ELSE                                                           CONVERT(DATE, CONVERT(CHAR(8), available_date, 112))  
               END AS available_date

			 , a.remain_lead_time
			 , a.holding_date
			 , a.scm_qty AS qty -- scp 사용 qty
			 , a.qty_uom
			 , a.stock_status
			 , a.operation_id
			 , a.line_id
			 , a.outsourcing_flag
			 , a.outsourcing_factory
			 , a.description
			 , a.fp_apply_operation_id
			 , a.fp_apply_item_id
			 , a.fp_apply_wipqty
             , CASE WHEN ISNULL(a.wiphold_yn, '') = '' THEN 'N'
                    ELSE a.wiphold_yn
               END AS wiphold_yn
			 , a.wip_type_code
			 , a.qty2
			 , a.modify_fp_apply_wipqty
			 , a.modify_description
			 , a.cal_qty
			 , a.formation_rework_type
			 , 'scp_batch' AS created_by
			 , GETDATE()   AS creation_date
			 , 'scp_batch' AS last_updated_by
			 , GETDATE()   AS last_update_date
			 , a.location_code AS location  -- 20210618 C20210617-000105 : location_code 정보 추가
			 , 'Y'         AS site_item_yn  --20180323 ksg 수정 : DNM에서 해당 정보 생성 안 함 
			 , b.site_type
			 , CASE WHEN stock_type = 'VMI' THEN dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id,dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id,A.item_id)) END as from_scm_site_id -- 2025.04.10 추가
        -- 20220121  PJ20216891 scm_dnm_stock_v -> scm_dnm_stock 테이블로 변경		
		FROM   scm_dnm_stock      a WITH (NOLOCK)  

			   -- site eng 에는 Sales Site가 Incoterms 단위로 들어가 있어 Distinct 없이 scm_site_id 로 조인하면 뻥튀기 될 수 있음
			 , (SELECT DISTINCT  division_id, scm_site_id, site_type
                FROM   dbo.scm_mst_site_eng  WITH(NOLOCK)
				WHERE  1=1
                AND    modeling_id      = @p_modeling_id
                AND    plan_id          = @p_plan_id
                AND    plan_seq         = @p_seq
                AND    plan_type        = @p_plan_type
                AND    site_type        = 'SALES'
               ) b
		WHERE  1 = 1		
        AND    a.cutoff_date      = @v_cutoff_day
        AND    a.division_id      = @p_division_id
		AND    a.division_id      = b.division_id
        AND    a.scm_site_id      = b.scm_site_id
	--	AND    ISNULL(a.wiphold_yn, 'N') = 'N'  -- 보류 재고는 View 자체에서 제외됨
		;

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 1 END ', N'1. Sales  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;
		


        -----------------------------------------------------------
        -- 1-2. Sales : 20181205  SO Reserve Stock : result_type = 'B' : 해상재고 대신 To Site의 재고로 처리
        -----------------------------------------------------------
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 1 START', N'1-2. SO Stock  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;

        INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_INVENTORY */ scp_eng_inventory_i_sn 
         (modeling_id, plan_id, plan_type, plan_seq
        , division_id, scm_site_id, org_scm_site_id, company_id, site_id, plant_id
        , factory_id, storage_id, cutoff_date, seq, stock_type, item_id, lane
        , production_type, available_date, remain_lead_time, holding_date
        , qty, qty_uom, stock_status, operation_id, line_id
        , outsourcing_flag, outsourcing_factory, description
        , fp_apply_operation_id, fp_apply_item_id, fp_apply_wipqty, wiphold_yn, wip_type_code
        , qty2, modify_fp_apply_wipqty, modify_description, cal_qty, formation_rework_type
        , created_by, creation_date, last_updated_by, last_update_date
        , location, site_item_yn, site_type
		, from_scm_site_id -- 2025.04.10 추가
         )
		SELECT --DISTINCT 
               @p_modeling_id  AS modeling_id
			 , @p_plan_id      AS plan_id
			 , @p_plan_type    AS plan_type
			 , @p_seq          AS plan_seq
			 , @p_division_id  AS division_id
			 , a.to_scm_site_id   AS scm_site_id --  뒤에서 Update
			 , a.to_scm_site_id   AS org_scm_site_id
			 , a.company_id
			 , '-'       AS site_id 
			 , a.plant_id
			 , '-'       AS factory_id
			 , '-'       AS storage_id
			 , a.result_date AS cutoff_date
			 , 1         AS seq
			 , 'SO'      AS stock_type
			 , a.item_id
			 , 1         AS lane
			 , '-'       AS production_type
             , CONVERT(DATETIME, @p_plan_name) AS available_date

			 , 0         AS remain_lead_time
			 , NULL      AS holding_date
			 , a.delivery_qty AS qty -- scp 사용 qty
			 , a.uom     AS qty_uom
			 , '-'       AS stock_status
			 , '-'       AS operation_id
			 , '-'       AS line_id
			 , '-'       AS outsourcing_flag
			 , '-'       AS outsourcing_factory
			 , '-'       AS description
			 , '-'       AS fp_apply_operation_id
			 , '-'       AS fp_apply_item_id
			 , 1         AS fp_apply_wipqty
			 , 'N'       AS wiphold_yn
			 , '-'       AS wip_type_code
			 , 0         AS qty2
			 , 0         AS modify_fp_apply_wipqty
			 , '-'       AS wmodify_description
			 , 0         AS cal_qty
			 , '-'       AS wformation_rework_type
			 , 'scp_batch' AS created_by
			 , GETDATE()   AS creation_date
			 , 'scp_batch' AS last_updated_by
			 , GETDATE()   AS last_update_date
			 , '-'         AS location
			 , 'Y'         AS site_item_yn  --20180323 ksg 수정 : DNM에서 해당 정보 생성 안 함 
			 , b.site_type
			 , a.from_scm_site_id as from_scm_site_id --2025.04.10 추가
		FROM   dbo.scm_dnm_intransit_c  a WITH (NOLOCK)

             , (SELECT division_id, company_id, plant_id, result_type, MAX(result_date) max_result_date  
                FROM   dbo.scm_dnm_intransit_c WITH (NOLOCK)
                WHERE  division_id          = @p_division_id
                -- 20240404 E20240401-000322 : SO Reserved Stock  다른 재고와 동일하게 일요일 기준 재고만 반영 되도록 수정
                AND    result_date          = @v_cutoff_day                         
                --AND    result_date         >  CONVERT(NVARCHAR(8), DATEADD(DD, -7, @d_cutoff_day), 112) -- 전전주 일요일
                --AND    result_date         <= @v_cutoff_day                         
				                            
				--20181121 SO Reserve Stock : result_type = 'B' 는 재고로 처리               
                AND    result_type          = 'B'                  
                AND    valid_yn             = 'Y'   -- 해상재고

                GROUP BY division_id, company_id, plant_id, result_type
               ) c --20180305 추가 division_id / company_id / plant_id 별로 최근 일주일이내의 MAX(result_date)  

			   -- site eng 에는 Sales Site가 Incoterms 단위로 들어가 있어 Distinct 없이 scm_site_id 로 조인하면 뻥튀기 될 수 있음
			 , (SELECT DISTINCT  division_id, scm_site_id, site_type
                FROM   dbo.scm_mst_site_eng  WITH(NOLOCK)
				WHERE  1=1
                AND    modeling_id      = @p_modeling_id
                AND    plan_id          = @p_plan_id
                AND    plan_seq         = @p_seq
                AND    plan_type        = @p_plan_type
                AND    site_type        = 'SALES'
               ) b
		WHERE  1 = 1
		
        AND    a.division_id      = c.division_id
        AND    a.company_id       = c.company_id 
        AND    a.plant_id         = c.plant_id  
        AND    a.result_type      = c.result_type 
        AND    a.result_date      = c.max_result_date 
        AND    a.division_id      = @p_division_id
		AND    a.valid_yn         = 'Y'   -- 해상재고      

		AND    a.division_id      = b.division_id
        AND    a.to_scm_site_id   = b.scm_site_id
	--	AND    ISNULL(a.wiphold_yn, 'N') = 'N'  -- 보류 재고는 View 자체에서 제외됨
	   ;   

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 1 END ', N'1-2. SO Stock  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;
		


        -----------------------------------------------------------
        -- 2. Sales : scm_site_id update  
        -----------------------------------------------------------
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 2 START', N'2. Sales  UPDATE scp_eng_inventory_i_sn',@d_event_date;

        UPDATE /* PR_SCP_ENG_IN_PRE_SET_INVENTORY */ scp_eng_inventory_i_sn
        SET    scm_site_id  = a.org_scm_site_id + '~' + ISNULL(ISNULL(b.max_incoterms, c.max_incoterms), 'DAP')
             , operation_id = a.org_scm_site_id + '~' + ISNULL(ISNULL(b.max_incoterms, c.max_incoterms), 'DAP')

        FROM   scp_eng_inventory_i_sn a
        
        LEFT JOIN ( SELECT aa.scm_site_id, aa.item_id
				            -- 2018.07.17   VMI 는 'DAP'로 처리 ( 참고) DAP 처리시  demand_attribute  'DAP'처리부분도 함께 수정해야 함) 
                            -- 2020.05.19   C20200519-000150  [PI 합의] ESS인 경우 VMI 라도 'DAP' 처리 안 함
							-- 20201028     ESS 'DAP' 처리
		                  , MAX(CASE WHEN cc.vmi_yn = 'Y' THEN 'DAP' 
		                  --, MAX(CASE WHEN aa.division_id <> '82' AND cc.vmi_yn = 'Y' THEN 'DAP' 
                                ELSE aa.incoterms
                                END ) max_incoterms
                     FROM   dbo.dm_pln_net_demand aa WITH(NOLOCK)
                            INNER JOIN (SELECT scm_site_id, max(version_no) max_version_no
                                        FROM   dbo.dm_pln_net_demand WITH(NOLOCK)
                                        WHERE  division_id     = @p_division_id 
                                        AND    cutoff_yyyymmdd = @v_demand_cutoff_day -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD) ---- 20250918-001297 최신 -3일내 MAX일자
                                        GROUP BY  scm_site_id
                                        ) bb
                            ON  aa.scm_site_id     = bb.scm_site_id
                            AND aa.version_no      = bb.max_version_no
                            AND aa.division_id     = @p_division_id 
                            AND aa.cutoff_yyyymmdd = @v_demand_cutoff_day   

                            LEFT JOIN ( SELECT division_id, scm_site_id, vmi_yn 
                                        FROM   scm_mst_site_eng WITH (NOLOCK)
                                        WHERE  division_id = @p_division_id
                                        AND    plan_id     = @p_plan_id
                                        AND    plan_seq    = @p_seq
                                        AND    plan_type   = @p_plan_type
                                        AND    vmi_yn      = 'Y') cc
                            ON     aa.division_id = cc.division_id 
                            AND    aa.scm_site_id = cc.scm_site_id 
                     GROUP BY aa.scm_site_id, aa.item_id
                   ) b
        
        ON     a.org_scm_site_id = b.scm_site_id 
        AND    a.item_id         = b.item_id 
        
        LEFT JOIN ( SELECT aa.scm_site_id
				            -- 2018.07.17   VMI 는 'DAP'로 처리 ( 참고) DAP 처리시  demand_attribute  'DAP'처리부분도 함께 수정해야 함) 
                            -- 2020.05.19   C20200519-000150  [PI 합의] ESS인 경우 VMI 라도 'DAP' 처리 안 함
							-- 20201028     ESS 'DAP' 처리
		                  , MAX(CASE WHEN cc.vmi_yn = 'Y' THEN 'DAP' 
                                ELSE aa.incoterms
                                END ) max_incoterms
                     FROM   dbo.dm_pln_net_demand aa WITH(NOLOCK)
                            INNER JOIN (SELECT scm_site_id, max(version_no) max_version_no
                                        FROM   dbo.dm_pln_net_demand WITH(NOLOCK)
                                        WHERE  division_id     = @p_division_id   
                                        AND    cutoff_yyyymmdd = @v_demand_cutoff_day -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
                                        GROUP BY  scm_site_id
                                        ) bb
                            ON  aa.scm_site_id     = bb.scm_site_id
                            AND aa.version_no      = bb.max_version_no
                            AND aa.division_id     = @p_division_id 
                            AND aa.cutoff_yyyymmdd = @v_demand_cutoff_day   

                            LEFT JOIN ( SELECT division_id, scm_site_id, vmi_yn 
                                        FROM   scm_mst_site_eng WITH (NOLOCK)
                                        WHERE  division_id = @p_division_id
                                        AND    plan_id     = @p_plan_id
                                        AND    plan_seq    = @p_seq
                                        AND    plan_type   = @p_plan_type
                                        AND    vmi_yn      = 'Y') cc
                            ON     aa.division_id = cc.division_id 
                            AND    aa.scm_site_id = cc.scm_site_id 
                     GROUP BY aa.scm_site_id
                   ) c
        ON     a.org_scm_site_id = c.scm_site_id 

		WHERE  a.modeling_id     = @p_modeling_id
		AND    a.plan_id         = @p_plan_id
		AND    a.plan_type       = @p_plan_type
		AND    a.plan_seq        = @p_seq
		AND    a.division_id     = @p_division_id
		AND    a.site_type       = 'SALES'
		;

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 2 END ', N'2. Sales  UPDATE scp_eng_inventory_i_sn',@d_event_date;



        -----------------------------------------------------------
        -- 3. Plant 
        -----------------------------------------------------------
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 3 START', N'3. Plant  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;

        INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_INVENTORY */ scp_eng_inventory_i_sn 
         (modeling_id, plan_id, plan_type, plan_seq
        , division_id, scm_site_id, org_scm_site_id, company_id, site_id, plant_id
        , factory_id, storage_id, cutoff_date, seq, stock_type, item_id, lane
        , production_type, available_date, remain_lead_time, holding_date
        , qty, qty_uom, stock_status, operation_id, line_id
        , outsourcing_flag, outsourcing_factory, description
        , fp_apply_operation_id, fp_apply_item_id, fp_apply_wipqty, wiphold_yn, wip_type_code
        , qty2, modify_fp_apply_wipqty, modify_description, cal_qty, formation_rework_type
        , created_by, creation_date, last_updated_by, last_update_date
        , location, site_item_yn, site_type
		, from_scm_site_id -- 2025.04.10 추가
         )
		SELECT 
               @p_modeling_id  AS modeling_id
			 , @p_plan_id      AS plan_id
			 , @p_plan_type    AS plan_type
			 , @p_seq          AS plan_seq
			 , @p_division_id  AS division_id
			 --20210618 C20210617-000105 : location_code 정보 추가
			 , CASE  
                   -- Cell 적용                                    
                   WHEN b.operation_group = 'A' AND a.location_code = 'CELL_OWMS'                  THEN a.scm_site_id + '~003'
                   WHEN b.operation_group = 'A' AND a.location_code = 'FORMATION_CHECK_PACKAGING'  THEN a.scm_site_id + '~002'
                   --  팩 적용
                   WHEN b.operation_group = 'P' AND a.location_code = 'PACK_OWMS'                  THEN a.scm_site_id + '~003'
                                  
                   /* 2023.07.07 n-ERP 활성화 코드 분리: cell_product(CP)생산 eng_site_id 구분 함. */ 
                   ELSE ISNULL(c.eng_scm_site_id , b.eng_scm_site_id) 
                   --ELSE b.eng_scm_site_id  --> 230601 수정전 코드 주석처리
               END scm_site_id  --~eng site id로 변환

			 , a.scm_site_id   AS org_scm_site_id
			 , a.company_id
			 , a.site_id       AS site_id 
			 , a.plant_id
			 , a.factory_id
			 , a.storage_id
			 , a.cutoff_date
			 , a.seq
			 , a.stock_type
			 , a.item_id
			 , a.lane
			 , a.production_type
             , CASE WHEN ISNULL(a.wiphold_yn, '') = ''                        THEN CONVERT(DATETIME, @p_plan_name)
                    WHEN a.wiphold_yn             = 'N'                       THEN CONVERT(DATETIME, @p_plan_name)
                    WHEN CONVERT(CHAR(8), available_date, 112) < @p_plan_name THEN CONVERT(DATETIME, @p_plan_name)
                    ELSE                                                           CONVERT(DATE, CONVERT(CHAR(8), available_date, 112))  
               END AS available_date

			 , a.remain_lead_time
			 , a.holding_date
			 , a.scm_qty AS qty -- scp 사용 qty
			 , a.qty_uom
			 , a.stock_status
             -- Stock Type인 MES인 경우 FLOW ID를 찾아서 넣어야 하고,(scm_mst_operation_flow_v)
             -- 아닌 경우 Storage ID와 FLOW ID Mapping 정보를 이용하여 FLOW ID 를 넣어야 함 ==> 현재는 정보 없음
			 , a.operation_id
			 , a.line_id
			 , a.outsourcing_flag
			 , a.outsourcing_factory
			 , a.description
			 , a.fp_apply_operation_id
			 , a.fp_apply_item_id
			 , a.fp_apply_wipqty
             , CASE WHEN ISNULL(a.wiphold_yn, '') = '' THEN 'N'
                    ELSE a.wiphold_yn
               END AS wiphold_yn
			 , a.wip_type_code
			 , a.qty2
			 , a.modify_fp_apply_wipqty
			 , a.modify_description
			 , a.cal_qty
			 , a.formation_rework_type
			 , 'scp_batch' AS created_by
			 , GETDATE()   AS creation_date
			 , 'scp_batch' AS last_updated_by
			 , GETDATE()   AS last_update_date
			 , a.location_code AS location  -- 20210618 C20210617-000105 : location_code 정보 추가
			 , 'Y'         AS site_item_yn  --20180323 ksg 수정 : DNM에서 해당 정보 생성 안 함
             , ISNULL(c.site_type, b.site_type)  AS site_type   --2023.07.07 수정, 수정전: b.site_type
             , CASE WHEN a.stock_type = 'VMI' THEN dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id,dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id,A.item_id))  
			        ELSE a.scm_site_id END as from_scm_site_id -- 2025.04.10 추가
        FROM    ( --a: dynmaic stock 
                SELECT  fi.cell_type , a.*
                FROM    scm_dnm_stock  a WITH (NOLOCK) 
                        LEFT JOIN  scm_mst_final_item_v  fi  with(nolock) 
                        ON      fi.division_id         =  @p_division_id 
                        AND     fi.operation_group_id  = 'A' 
                        AND     fi.item_id = a.item_id 
		        WHERE  1 = 1
                AND    a.cutoff_date      = @v_cutoff_day   
                AND    a.division_id      = @p_division_id 
                AND    a.scm_site_id IS NOT NULL  
                ) a
                LEFT JOIN   /* 생산 eng_site_id (~***) 검색용 */    
                        dbo.scm_mst_site_eng  b WITH(NOLOCK)
                on      1=1
		        AND    b.modeling_id      = @p_modeling_id
		        AND    b.plan_type        = @p_plan_type
		        AND    b.plan_id          = @p_plan_id
		        AND    b.plan_seq         = @p_seq
                AND    b.site_type        = 'PLANT'
                AND    b.operation_group IN ( 'A', 'P' ) --  Cell / Pack
		        AND    a.division_id      = b.division_id
                AND    a.scm_site_id      = REPLACE(b.eng_scm_site_id, '~***', '')        
                LEFT JOIN   /* CP 생산 SITE (~002) 검색용 */  
                        dbo.scm_mst_site_eng  c WITH(NOLOCK)
                ON      1=1
		        AND    c.modeling_id      = @p_modeling_id
		        AND    c.plan_type        = @p_plan_type
		        AND    c.plan_id          = @p_plan_id
		        AND    c.plan_seq         = @p_seq
                AND    c.site_type        = 'PLANT'
                AND    c.operation_group  = 'A'      --  Cell site만
		        AND    a.division_id      = c.division_id
                AND    a.cell_type        IN ('CP', 'CA2')   -- Cell_Product , tco_assy 
                AND    a.scm_site_id      =  REPLACE(c.eng_scm_site_id, '~002', '')        

        WHERE   1=1
        AND     ISNULL(c.eng_scm_site_id , b.eng_scm_site_id)  IS NOT NULL   -- inner join을 대체하기 위해.
        ; 

        /* 2023.07.07 수정전 코드 
        -- 20220121  PJ20216891 scm_dnm_stock_v -> scm_dnm_stock 테이블로 변경
		FROM   scm_dnm_stock               a WITH (NOLOCK) 
			 , dbo.scm_mst_site_eng        b WITH(NOLOCK)
		WHERE  1 = 1
        AND    a.cutoff_date      = @v_cutoff_day    
        AND    a.division_id      = @p_division_id 
		AND    b.modeling_id      = @p_modeling_id
		AND    b.plan_id          = @p_plan_id
		AND    b.plan_seq         = @p_seq
		AND    b.plan_type        = @p_plan_type
		AND    a.division_id      = b.division_id

        --20180314 속도개선을 위해서 수정
	    -- site eng 에는 Plant Site가 Incoterms 단위로 들어가 있어 Replace 없이 scm_site_id 로 조인하면 뻥튀기 될 수 있음
        AND    a.scm_site_id  =  REPLACE(b.eng_scm_site_id, '~***', '')  --20180314 속도개선을 위해서 수정(변경전: AND    a.scm_site_id + '~***' = b.eng_scm_site_id)
		
        AND    b.site_type        = 'PLANT'
        AND    b.operation_group IN ( 'A', 'P' ) --  Cell / Pack
		--AND    ISNULL(a.wiphold_yn, 'N') = 'N'  -- 보류 재고는 View 자체에서 제외됨
		;
        */ 

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 3 END ', N'3. Plant  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;



        -----------------------------------------------------------
        --4. scm_site_id 변경
        -----------------------------------------------------------
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 4 START', N'4. Plant  UPDATE scp_eng_inventory_i_sn',@d_event_date;

         -- 20180417 수정
        /* 'Update 대상 storage_id' 쿼리문참조  
           전극:  1) location_code = 'SLITTING'      => org_scm_site_id + '~002'
                  2) location_code = 'ELECTRODE_SHIP'=> org_scm_site_id + '~003'
            
            셀  : 1) location_code = 'CELL_OWMS'                  => org_scm_site_id + '~003' 
                  2) location_code = 'FORMATION_CHECK_PACKAGING'  => org_scm_site_id + '~002'

            팩  : 1) location_code = 'PACK_OWMS'                  => org_scm_site_id + '~003'
        */
        -----------------------------------------------------------
        UPDATE scp_eng_inventory_i_sn
        SET    scm_site_id =  CASE  
                                    -- Cell 적용                                    
                                    WHEN b.operation_group = 'A' AND c.location_code = 'CELL_OWMS'                  THEN a.org_scm_site_id + '~003' --AND a.storage_id IN ( '5000', '5100', '5310', '5311', '5320') THEN a.org_scm_site_id + '~003'
                                    WHEN b.operation_group = 'A' AND c.location_code = 'FORMATION_CHECK_PACKAGING'  THEN a.org_scm_site_id + '~002' --AND a.storage_id IN ( '310T', '311T', '320T') THEN a.org_scm_site_id + '~002'
                                    
                                    --  팩 적용
                                    WHEN b.operation_group = 'P' AND c.location_code = 'PACK_OWMS'  THEN a.org_scm_site_id + '~003'  -- 20180717 추가 --AND a.storage_id IN ( 5410, 5411, 5420) THEN a.org_scm_site_id + '~003'
                                    
                                    ELSE a.scm_site_id
                               END
                                                 
        FROM   scp_eng_inventory_i_sn a WITH (NOLOCK)
               INNER JOIN ( SELECT division_id, scm_site_id, operation_group, site_type
                            FROM   scm_mst_site WITH (NOLOCK)
                            WHERE  division_id     = @p_division_id
                            AND    site_type       = 'PLANT' 
                            AND    operation_group IN ('A', 'P') 
                            AND    valid_yn        = 'Y'
                            AND    ISNULL(osp_yn, 'N')  = 'N' --20180822 추가
                          ) b 
               ON   a.division_id     = b.division_id 
               AND  a.org_scm_site_id = b.scm_site_id
               AND  a.site_type       = b.site_type    
               
               LEFT JOIN (  SELECT DISTINCT
                                    a.storage_id
                                 ,  a.location_code
                                 ,  a.scm_site_id  -- 20180717 추가 데이터중복발생때문에 조인조건추가하기 위해서 추가함
                            FROM   scm_mst_location a WITH (NOLOCK)
                                    INNER JOIN (SELECT scm_site_id  
                                                FROM   scm_mst_site
                                                WHERE  division_id     = @p_division_id  
                                                AND    valid_yn        = 'Y'
                                                AND    operation_group IN ( 'A', 'P' )  
                                               ) b
                                    ON a.scm_site_id = b.scm_site_id 
                            WHERE  a.division_id = @p_division_id  
                            AND    a.valid_yn    = 'Y'
                            AND    location_code IN ('FORMATION_CHECK_PACKAGING','CELL_OWMS', 'PACK_OWMS') -- 20180717 'PACK_OWMS' 추가
                            AND    (storage_id IS NOT NULL AND storage_id <> '')
                        )  c -- 셀/전극의 storage_id 별 사용대상 조회
               ON   a.storage_id       = c.storage_id 
               AND  a.org_scm_site_id  = c.scm_site_id   -- 20180717 추가 데이터중복발생때문에 조인조건추가하기 위해서 추가함
                                            
        WHERE  a.modeling_id  = @p_modeling_id
        AND    a.plan_id      = @p_plan_id 
        AND    a.plan_type    = @p_plan_type 
        AND    a.plan_seq     = @p_seq 
        AND    a.division_id  = @p_division_id
        AND    a.site_type    = 'PLANT'
        AND    (c.storage_id IS NOT NULL AND c.storage_id <> '')
        AND    a.scm_site_id  LIKE '%~***'  -- 20210618 C20210617-000105 : location_code 정보 추가
        ;

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 4 ', N'4-1. Plant storage_id UPDATE scp_eng_inventory_i_sn',@d_event_date;

        UPDATE scp_eng_inventory_i_sn
        SET    scm_site_id =  CASE  
                                    -- Cell 적용                                    
                                    WHEN b.operation_group = 'A' AND c.location_code = 'CELL_OWMS'                  THEN a.org_scm_site_id + '~003' --AND a.storage_id IN ( '5000', '5100', '5310', '5311', '5320') THEN a.org_scm_site_id + '~003'
                                    WHEN b.operation_group = 'A' AND c.location_code = 'FORMATION_CHECK_PACKAGING'  THEN a.org_scm_site_id + '~002' --AND a.storage_id IN ( '310T', '311T', '320T') THEN a.org_scm_site_id + '~002'
                                    
                                    --  팩 적용
                                    WHEN b.operation_group = 'P' AND c.location_code = 'PACK_OWMS'  THEN a.org_scm_site_id + '~003'  -- 20180717 추가 --AND a.storage_id IN ( 5410, 5411, 5420) THEN a.org_scm_site_id + '~003'
                                    
                                    ELSE a.scm_site_id
                               END
                                                 
        FROM   scp_eng_inventory_i_sn a WITH (NOLOCK)
               INNER JOIN ( SELECT division_id, scm_site_id, operation_group, site_type
                            FROM   scm_mst_site WITH (NOLOCK)
                            WHERE  division_id     = @p_division_id
                            AND    site_type       = 'PLANT' 
                            AND    operation_group IN ('A', 'P')   
                            AND    valid_yn        = 'Y'
                            AND    ISNULL(osp_yn, 'N')  = 'N' --20180822 추가
                          ) b 
               ON   a.division_id     = b.division_id 
               AND  a.org_scm_site_id = b.scm_site_id
               AND  a.site_type       = b.site_type    
               
               LEFT JOIN (  SELECT DISTINCT
                                    a.operation_id
                                 ,  a.location_code
                                 ,  a.scm_site_id  -- 20180717 추가 데이터중복발생때문에 조인조건추가하기 위해서 추가함
                            FROM   scm_mst_location a WITH (NOLOCK)
                                    INNER JOIN (SELECT scm_site_id  
                                                FROM   scm_mst_site
                                                WHERE  division_id     = @p_division_id  
                                                AND    valid_yn        = 'Y'
                                                AND    operation_group IN ( 'A', 'P' ) 
                                               ) b
                                    ON a.scm_site_id = b.scm_site_id 
                            WHERE  a.division_id = @p_division_id --'81'
                            AND    a.valid_yn    = 'Y'
                            AND    location_code IN ('FORMATION_CHECK_PACKAGING','CELL_OWMS', 'PACK_OWMS') -- 20180717 'PACK_OWMS' 추가
                            AND    (operation_id IS NOT NULL AND operation_id <> '')
                        )  c -- 셀/전극의 storage_id 별 사용대상 조회
               ON   a.operation_id     = c.operation_id 
               AND  a.org_scm_site_id  = c.scm_site_id   -- 20180717 추가 데이터중복발생때문에 조인조건추가하기 위해서 추가함
                                            
        WHERE  a.modeling_id  = @p_modeling_id
        AND    a.plan_id      = @p_plan_id 
        AND    a.plan_type    = @p_plan_type 
        AND    a.plan_seq     = @p_seq 
        AND    a.division_id  = @p_division_id
        AND    a.site_type    = 'PLANT'
        AND    (c.operation_id IS NOT NULL AND c.operation_id <> '')
        AND    a.scm_site_id  LIKE '%~***'  -- 20210618 C20210617-000105 : location_code 정보 추가
        ;

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 4 END ', N'4. Plant operation_id UPDATE scp_eng_inventory_i_sn',@d_event_date;
        


        -----------------------------------------------------------
        --5.  Plant : 활성화 -Cell 사이트의 scm_site_id 값을 [plant_id + '~001'] 변경후 Insert         
        -----------------------------------------------------------
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 5 START', N'5. Plant : 활성화  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;

        INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_INVENTORY */ scp_eng_inventory_i_sn 
         (modeling_id, plan_id, plan_type, plan_seq, division_id
         , scm_site_id, org_scm_site_id, company_id, site_id, plant_id
        , factory_id, storage_id, cutoff_date, seq, stock_type, item_id, lane
        , production_type, available_date, remain_lead_time, holding_date
        , qty, qty_uom, stock_status, operation_id, line_id
        , outsourcing_flag, outsourcing_factory, description
        , fp_apply_operation_id, fp_apply_item_id, fp_apply_wipqty, wiphold_yn, wip_type_code
        , qty2, modify_fp_apply_wipqty, modify_description, cal_qty, formation_rework_type
        , created_by, creation_date, last_updated_by, last_update_date
        , location, site_item_yn, site_type
		, from_scm_site_id -- 2025.04.10 추가
         )
        SELECT --DISTINCT
               @p_modeling_id  AS modeling_id
			 , @p_plan_id      AS plan_id
			 , @p_plan_type    AS plan_type
			 , @p_seq          AS plan_seq
			 , @p_division_id  AS division_id
             , b.scm_site_id + '~001' AS scm_site_id
			 , a.scm_site_id   AS org_scm_site_id
			 , a.company_id
			 , a.site_id       AS site_id 
			 , a.plant_id
			 , a.factory_id
			 , 'FOR' AS storage_id 
			 , a.cutoff_date
			 , a.seq
			 , 'FOR' AS stock_type 
			 , a.item_id
			 , NULL AS lane       
			 , a.production_type
             , CASE WHEN CONVERT(CHAR(8), a.available_date, 112) < @p_plan_name THEN CONVERT(DATE, @p_plan_name)
                    ELSE a.available_date
               END  AS available_date
			 , a.remain_lead_time
			 , a.holding_date
			 , a.qty
			 , a.qty_uom
			 , a.stock_status
			 , a.operation_id
			 , a.line_id
			 , 'N' AS outsourcing_flag 
			 , NULL AS outsourcing_factory
			 , NULL AS description          
			 , NULL AS fp_apply_operation_id
			 , NULL AS fp_apply_item_id
			 , NULL AS fp_apply_wipqty
             , CASE WHEN ISNULL(a.wiphold_yn, '') = '' THEN 'N'
                    ELSE a.wiphold_yn
               END AS wiphold_yn
			 , NULL AS wip_type_code
             , NULL AS qty2
			 , NULL AS modify_fp_apply_wipqty
			 , NULL AS modify_description
             , NULL AS cal_qty
             , NULL AS formation_rework_type
			 , 'scp_batch' AS created_by
			 , GETDATE()   AS creation_date
			 , 'scp_batch' AS last_updated_by
			 , GETDATE()   AS last_update_date
			 , NULL AS location 
			 , 'Y' AS site_item_yn   --20180323 ksg 수정 : DNM에서 해당 정보 생성 안 함
			 , 'PLANT' AS site_type
             , a.scm_site_id   as from_scm_site_id -- 2025.04.10 추가
        FROM   (SELECT a.*
                FROM   scm_dnm_stock_aging_v a WITH (NOLOCK)
               
               --20180511 속도개선을 위해서 inner join => left join으로 변경
               LEFT JOIN  (SELECT division_id, site_id, max(cutoff_date) max_cutoff_date 
                            FROM   scm_dnm_stock_aging_v a
                            WHERE  a.division_id   = @p_division_id
                            AND    a.cutoff_date   >  DATEADD(DD, -7, @d_cutoff_day) 
                            AND    a.cutoff_date   <= @d_cutoff_day                  
                            GROUP BY division_id, site_id   
                           )  c --20180305 추가 division_id / Site_id / Factory_id 별로 최근 3일이내의 MAX(cutoff_date)   
        	   --20180305 수정 division_id / Site_id / Factory_id 별로 최근 일주일이내의 MAX(cutoff_date) 값으로 cutoff_date 수정 (변경전 : AND    a.cutoff_date      = @v_cutoff_day ) )
               ON   a.division_id     = c.division_id
               AND  a.site_id         = c.site_id 
               AND  a.cutoff_date     = c.max_cutoff_date 

               WHERE a.division_id = @p_division_id 
               AND   c.division_id IS NOT NULL --20180511 속도개선을 위해서 inner join => left join으로 변경때문에 조건추가함
               ) a
               --20180511 속도개선을 위해서 inner join => left join으로 변경
               LEFT JOIN ( SELECT division_id, scm_site_id, eng_scm_site_id 
                            FROM   dbo.scm_mst_site_eng  WITH(NOLOCK) 
                            WHERE  modeling_id   = @p_modeling_id
		                    AND    plan_id       = @p_plan_id
		                    AND    plan_type     = @p_plan_type
                            AND    plan_seq      = @p_seq
		                    AND    division_id   = @p_division_id
                            AND    site_type     = 'PLANT'
                            AND    scm_site_id + '~***' = eng_scm_site_id 		
                            AND    ISNULL(osp_yn, 'N')  = 'N' --20180822 추가
                          ) b
               ON     a.scm_site_id   = b.scm_site_id 
        WHERE  b.division_id IS NOT NULL --20180511 속도개선을 위해서 inner join => left join으로 변경때문에 조건추가함        
        ;

        -----------------------------------------------------------

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 5 END ', N'5. Plant : 활성화  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;
       
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
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
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
