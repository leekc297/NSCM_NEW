
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_SET_INVENTORY
 * Description  : SDB의 재고정보(scm_dnm_stock_v)를 ODB의 plan을수행용 재고중간정보(scp_eng_inventory_i)에 적재되도록 한다.
                    
                  1. site타입이 SALES인 재고정보 생성
                  
                  2. 위 1에서 생성된 재고정보에서 'scm_site_id', 'operation_id' 변경
                     - 동일scm_site_id 값중 
                       max version_no인 dm_pln_net_demand(DM Demand정보) 테이블에서 'scm_site_id' 가 일치하는 값중에서 
                       MAX incoterms 값을 구한뒤 ['scm_site_id' + '~' + 'incoterms'] 형태로 변경하면됨
                       (참고 : operation_id = ['scm_site_id' + '~' + 'incoterms'] 형태로 'scm_site_id'값과 동일하게 변경함)
                  
                  3. site타입이 PLANT인 재고정보 생성
                  
                  4. 위3에서 생성된 재고정보에서 'scm_site_id' 변경
                    
                     --  전극:  1) location_code = 'SLITTING'      => org_scm_site_id + '~002'
                                2) location_code = 'ELECTRODE_SHIP'=> org_scm_site_id + '~003'

 * OutTable     : SCP_ENG_INVENTORY_I
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.29   KSW            전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.17   KSW            VMI 대상일때 INCOTERMS를 'DAP'로 처리
 * 2018.10.01   KSW            외주 전극 ***만 생성( 외주전극 : 002, 003 생성제외)
 * 2018.10.04   KSG            WIP 재고 Query 수정  (참고)주석3
 * 2018.10.11   KSW            1) stock_type	= 'WIP', stock_status = 'MOVING' 인 재고 추가 참고)주석3
                               2) 위1번의 경우  scm_site_id를 '~002' 로 변경 참고)주석4
 * 2018.12.05   KSG            SO Reserve Stock : result_type = 'B' : 해상재고 대신 To Site의 재고로 처리
 * 2019.03.05   KSW            [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2021.06.18   KSG            C20210617-000105  [SCM PI팀] GSCM의 소형 MES→OWMS, 위탁재고 정합성 향상을 위한 기능변경건 : location_code 정보 추가
 * 2022.01.21   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : Stock_v -> Stock 테이블로 변경
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2025.09.17	YMH				20250918-001297 SALES SITE 재고정상 반영을 위해  컷오프시간 하드코딩에서 최종CUTOFFTIME 으로 로직 개선.
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_EE_PRE_SET_INVENTORY]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_SET_INVENTORY';
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
    --DECLARE @v_cutoff_day       NVARCHAR(8)  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
	DECLARE @v_cutoff_day        NVARCHAR(10) = CONVERT(CHAR(10), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
    DECLARE @d_cutoff_day        DATETIME     = CONVERT(DATETIME, @v_cutoff_day)
	DECLARE @v_demand_cutoff_day NVARCHAR(8)  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'TUE')), 112); -- 당주 화요일 YYYYMMDD
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
         , @v_division_comp    =  di.ATTRIBUTE4  -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id
    ; 
	
  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	    -- 2025-09-16 김춘동. 최종 cutoff 일자 조회 방식 수정
		-- #DEMAND_CUTOFF_YYYYMMDD; 임시 정보 형성
        IF OBJECT_ID('tempdb..#DEMAND_CUTOFF_YYYYMMDD') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_CUTOFF_YYYYMMDD;          
        END 
        
        -- 최근 3일 이내 최신 버전
        SELECT p.division_id
             , ISNULL(MAX(p.cutoff_yyyymmdd)
                      , CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 화요일 YYYYMMDD
                     ) AS demand_cutoff_yyyymmdd
             , di.attribute4    AS  division_comp  -- 2022.04.04 회사코드 추가 
        INTO   #DEMAND_CUTOFF_YYYYMMDD
        FROM   dbo.dm_pln_net_demand p WITH(NOLOCK)
             , scm_mst_division     di WITH(NOLOCK)
        WHERE  p.cutoff_yyyymmdd >=  CONVERT(CHAR(8), DATEADD(DD, -3, GETDATE()), 112) -- 최근 3일 이내
        AND    di.valid_yn        =  'Y'
        AND    p.division_id      =  di.division_id
        GROUP BY P.division_id, di.attribute4  ; 


		DELETE /* PR_SCP_ENG_EE_PRE_SET_INVENTORY */ 
		FROM   scp_eng_inventory_i_sn
		WHERE  modeling_id = @p_modeling_id  
	    AND    plan_id     = @p_plan_id      
	    AND    plan_type   = @p_plan_type    
		AND    plan_seq    = @p_seq          
		AND    division_id = @p_division_id  
		;
		
        -----------------------------------------------------------
        -- 1. Sales 
        -----------------------------------------------------------
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 1 START', N'1. Sales  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;

        INSERT INTO /* PR_SCP_ENG_EE_PRE_SET_INVENTORY */ scp_eng_inventory_i_sn 
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
			 --, CONVERT(DATETIME, @p_plan_name) AS available_date
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
			 --, [dbo].[FN_SCM_SYS_NVL](a.wiphold_yn, 'N') AS wiphold_yn
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
        -- 20220121  PJ20216891 Stock_v -> Stock 테이블로 변경
		-- FROM   scm_dnm_stock_v      a WITH (NOLOCK)  
        FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT a.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
		        FROM   scm_dnm_stock      a WITH (NOLOCK)  
                     , scm_mst_division  di WITH(NOLOCK)
                WHERE di.division_id  =  a.division_id
                AND   di.valid_yn     = 'Y'
                AND   di.attribute4   =  @v_division_comp    -- 회사코드
              ) a

        /* 20220404 변경전 
		FROM   scm_dnm_stock      a WITH (NOLOCK)  */
             --, (SELECT division_id, site_id, max(cutoff_date) max_cutoff_date 
             --   FROM   scm_dnm_stock_v a
             --   WHERE  a.cutoff_date >  DATEADD(DD, -7, @d_cutoff_day) -- 전전주 일요일
             --   AND    a.cutoff_date <= @d_cutoff_day                  -- 지난주 일요일
                
             --   --AND    a.division_id  = @p_division_id --20180629 주석처리
             --   AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)

             --   GROUP BY division_id, site_id   
             --  ) c --20180305 추가 division_id / Site_id / Factory_id 별로 최근 일주일이내의 MAX(cutoff_date)      
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
		--AND    a.division_id      = @p_division_id -- 20180629 주석처리
        AND    a.division_group  IN ( '40', '81', '82')   -- 2022.04.04 수정.--20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)

        /* 20220404 변경전 
        AND    a.division_id      IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */

        --20180305 수정 division_id / Site_id / Factory_id 별로 최근 일주일이내의 MAX(cutoff_date) 값으로 cutoff_date 수정 (변경전 : AND    a.cutoff_date      = @v_cutoff_day ) )
        --AND    a.division_id        = c.division_id
        --AND    a.site_id            = c.site_id 
        --AND    a.cutoff_date        = c.max_cutoff_date 
        AND    a.cutoff_date        = @v_cutoff_day -- @d_cutoff_day  PJ20216891

		--AND    a.division_id      = b.division_id --20180629 주석처리 
        AND    a.scm_site_id      = b.scm_site_id 

	--	AND    ISNULL(a.wiphold_yn, 'N') = 'N'  -- 보류 재고는 View 자체에서 제외됨
		;       

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 1 END ', N'1. Sales  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;		
		
        -----------------------------------------------------------
        -- 1-2. Sales : 20181205  SO Reserve Stock : result_type = 'B' : 해상재고 대신 To Site의 재고로 처리
        -----------------------------------------------------------
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 1 START', N'1-2. SO Stock  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;

        INSERT INTO /* PR_SCP_ENG_EE_PRE_SET_INVENTORY */ scp_eng_inventory_i_sn 
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
		FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT a.* 
                     , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                FROM   dbo.scm_dnm_intransit_c   a WITH (NOLOCK)
                        , scm_mst_division       di WITH(NOLOCK)
                WHERE di.division_id  =  a.division_id
                AND   di.valid_yn     = 'Y'
                AND   di.attribute4   =  @v_division_comp   --회사코드
              ) a 
         /* 20220404 변경전 
		FROM   dbo.scm_dnm_intransit_c  a WITH (NOLOCK)  */
             , (
                SELECT aa.division_id, aa.company_id, aa.plant_id, aa.result_type, MAX(aa.result_date) max_result_date  
                FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                        SELECT a.* 
                             , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                        FROM   dbo.scm_dnm_intransit_c a WITH (NOLOCK)
                             , scm_mst_division       di WITH(NOLOCK)
                        WHERE di.division_id  =  a.division_id
                        AND   di.valid_yn     = 'Y'
                        AND   di.attribute4   =  @v_division_comp   --회사코드
                      ) aa
                /* 20220404 변경전 
                FROM   dbo.scm_dnm_intransit_c WITH (NOLOCK)  */ 

                WHERE  aa.result_date         >  CONVERT(NVARCHAR(8), DATEADD(DD, -7, @d_cutoff_day), 112) -- 전전주 일요일
                AND    aa.result_date         <= @v_cutoff_day                         
				                            
				--20181121 SO Reserve Stock : result_type = 'B' 는 재고로 처리               
                AND    aa.result_type          = 'B'                  
                AND    aa.valid_yn             = 'Y'   -- 해상재고

                --AND    division_id          = @p_division_id

                AND    aa.division_group  IN ( '40', '81', '82')  --2022.04.04컬럼수정. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)

                /* 20220404 변경전
                AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */

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
        --AND    a.division_id      = @p_division_id

        AND    a.division_group  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가), 2022.04.04 수정
        
        /* 20220404 변경전
        AND    a.division_id      IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */
		AND    a.valid_yn         = 'Y'   -- 해상재고      

		--AND    a.division_id      = b.division_id
        AND    a.to_scm_site_id   = b.scm_site_id

	--	AND    ISNULL(a.wiphold_yn, 'N') = 'N'  -- 보류 재고는 View 자체에서 제외됨
	   ;   

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 1 END ', N'1-2. SO Stock  INSERT INTO scp_eng_inventory_i_sn',@d_event_date;

        -----------------------------------------------------------
        -- 2. Sales : scm_site_id update  
        -----------------------------------------------------------
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 2 START', N'2. Sales  UPDATE scp_eng_inventory_i_sn',@d_event_date;

        UPDATE /* PR_SCP_ENG_EE_PRE_SET_INVENTORY */ scp_eng_inventory_i_sn
        --SET    scm_site_id  = b.scm_site_id + '~' + b.max_incoterms
        --     , operation_id = b.scm_site_id + '~' + b.max_incoterms
        SET    scm_site_id  = a.org_scm_site_id + '~' + ISNULL(ISNULL(b.max_incoterms, c.max_incoterms), 'DAP')
             , operation_id = a.org_scm_site_id + '~' + ISNULL(ISNULL(b.max_incoterms, c.max_incoterms), 'DAP')

        FROM   scp_eng_inventory_i_sn a
        
        LEFT JOIN (  SELECT aa.scm_site_id, aa.item_id
				            -- 2018.07.17   VMI 는 'DAP'로 처리 ( 참고) DAP 처리시  demand_attribute  'DAP'처리부분도 함께 수정해야 함) 
		                  , MAX(CASE WHEN cc.vmi_yn = 'Y' THEN 'DAP' 
                                ELSE aa.incoterms
                                END ) max_incoterms                          
                     FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                            SELECT a.* 
                                 , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                            FROM   dbo.dm_pln_net_demand a WITH(NOLOCK)
                                 , scm_mst_division     di WITH(NOLOCK)
								 , #DEMAND_CUTOFF_YYYYMMDD b   -- [20250918-001297]  2025-09-16 김춘동. 최종 cutoff 일자 조회 방식 수정
                            WHERE  di.division_id  =  a.division_id
                            AND    di.valid_yn     = 'Y'
							-- [20250918-001297] 수요CUTOFF 최종일자 적용 로직 추가 시작
							AND    a.division_id     = b.division_id
                            AND    a.cutoff_yyyymmdd = b.demand_cutoff_yyyymmdd
							AND    di.attribute4     = b.division_comp
							-- [20250918-001297]  수요CUTOFF 최종일자 적용 로직 추가 끝
                            AND    di.attribute4   = @v_division_comp  -- 회사코드
                           ) aa 

                     /* 20220404 변경전
                     FROM   dbo.dm_pln_net_demand aa WITH(NOLOCK)   */ 

                            INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                        SELECT a.division_id, a.scm_site_id, max(a.version_no) max_version_no
                                        FROM   dbo.dm_pln_net_demand a WITH(NOLOCK)
                                             , scm_mst_division     di WITH(NOLOCK)
											 , #DEMAND_CUTOFF_YYYYMMDD b   -- [20250918-001297] 컷오프 최신일자 적용 2025-09-16 김춘동. 최종 cutoff 일자 조회 방식 수정
                                        WHERE  di.division_id  =  a.division_id
                                        AND    di.valid_yn     = 'Y'
										-- AND    a.cutoff_yyyymmdd = @v_demand_cutoff_day -- [20250918-001297] 컷오프일자 최신일자 적용으로 주석처리.
										-- [20250918-001297] 컷오프 최신일자 적용 로직 시작
										AND    a.division_id     = b.division_id
										AND    a.cutoff_yyyymmdd = b.demand_cutoff_yyyymmdd
										AND    di.attribute4     = b.division_comp
										-- [20250918-001297] 컷오프 최신일자 적용 로직 끝
										
                                        

                                        AND    di.attribute3  IN ( '40', '81', '82')  --2022.04.04컬럼변경.--20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)     
                                        AND    di.attribute4   = @v_division_comp
                                        GROUP BY  a.division_id, a.scm_site_id

                                        /* 20220404 변경전
                                        SELECT division_id, scm_site_id, max(version_no) max_version_no
                                        FROM   dbo.dm_pln_net_demand WITH(NOLOCK)
                                        WHERE  cutoff_yyyymmdd = @v_demand_cutoff_day -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
                                        --AND    division_id     = @p_division_id   -- 20180717 주석처리
                                        AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                        GROUP BY  division_id, scm_site_id  
                                        */
                                        ) bb
                            ON   aa.scm_site_id     = bb.scm_site_id
                            AND  aa.version_no      = bb.max_version_no
                            AND  aa.division_id     = bb.division_id 
                            AND  aa.division_group  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가), 2022.04.04 수정

                            --AND aa.division_id     = @p_division_id  -- 20180717 주석처리   
                            /* 20220404 변경전
                            AND  aa.division_id     IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                            */
                            -- AND  aa.cutoff_yyyymmdd = @v_demand_cutoff_day    -- [20250918-001297] 컷오프일자 최신일자 적용으로 주석처리.
                            LEFT JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                        SELECT a.division_id, a.scm_site_id, a.vmi_yn 
                                        FROM   scm_mst_site       a WITH(NOLOCK)
                                             , scm_mst_division  di WITH(NOLOCK)
                                        WHERE  di.division_id  =  a.division_id
                                        AND    di.valid_yn     = 'Y'    
                                        AND    a.valid_yn      = 'Y'
                                        AND    a.vmi_yn        = 'Y' 
                                        AND    di.attribute3  IN ( '40', '81', '82')  --2022.04.04컬럼변경.--20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                                        AND    di.attribute4   = @v_division_comp                       
                            
                                     /* 20220404 변경전
                                        SELECT division_id, scm_site_id, vmi_yn 
                                        FROM   scm_mst_site WITH (NOLOCK)
                                        WHERE  valid_yn    = 'Y'
                                        AND    vmi_yn      = 'Y' 
                                        AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                        */                                                                     
                                      ) cc
                            ON     aa.division_id = cc.division_id 
                            AND    aa.scm_site_id = cc.scm_site_id 

                     GROUP BY aa.scm_site_id, aa.item_id
                   ) b
        
        ON     a.org_scm_site_id = b.scm_site_id 
        AND    a.item_id         = b.item_id 
        
        LEFT JOIN ( SELECT aa.scm_site_id --, MAX(aa.incoterms) max_incoterms
				            -- 2018.07.17   VMI 는 'DAP'로 처리 ( 참고) DAP 처리시  demand_attribute  'DAP'처리부분도 함께 수정해야 함) 
		                  , MAX(CASE WHEN cc.vmi_yn = 'Y' THEN 'DAP' 
                                ELSE aa.incoterms
                                END ) max_incoterms
                     FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                            SELECT a.* 
                                 , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                            FROM   dbo.dm_pln_net_demand a WITH(NOLOCK)
                                 , scm_mst_division     di WITH(NOLOCK)
								 , #DEMAND_CUTOFF_YYYYMMDD b   -- [20250918-001297] 2025-09-16 김춘동. 최종 cutoff 일자 조회 방식 수정
                            WHERE  di.division_id  =  a.division_id
                            AND    di.valid_yn     = 'Y'
							-- [20250918-001297] 최종 cutoff 일자 적용 로직 추가 시작
							AND    a.division_id     = b.division_id
                            AND    a.cutoff_yyyymmdd = b.demand_cutoff_yyyymmdd
							AND    di.attribute4     = b.division_comp
							-- [20250918-001297] 최종 cutoff 일자 적용 로직 추가 끝
							AND    di.attribute4   = @v_division_comp    --회사코드
                           ) aa                           

                    /* 20220404 변경전
                     FROM   dbo.dm_pln_net_demand aa WITH(NOLOCK)  */

                            INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                        SELECT a.division_id, a.scm_site_id, max(a.version_no) max_version_no
                                        FROM   dbo.dm_pln_net_demand a WITH(NOLOCK)
                                             , scm_mst_division     di WITH(NOLOCK)
											 , #DEMAND_CUTOFF_YYYYMMDD b   -- [20250918-001297] 2025-09-16 김춘동. 최종 cutoff 일자 조회 방식 수정
                                        WHERE  di.division_id  =  a.division_id
                                        AND    di.valid_yn     = 'Y'
                                        --AND    a.cutoff_yyyymmdd = @v_demand_cutoff_day  -- [20250918-001297] 주석 처리
										-- [20250918-001297] 로직 시작
										AND    a.division_id     = b.division_id
                                        AND    a.cutoff_yyyymmdd = b.demand_cutoff_yyyymmdd
										AND    di.attribute4     = b.division_comp
										-- [20250918-001297] 로직 끝
                                        AND    di.attribute3  IN ( '40', '81', '82') --2022.04.04컬럼변경.--20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)     
                                        AND    di.attribute4   = @v_division_comp
                                        GROUP BY  a.division_id, a.scm_site_id 
                                        
                                      /* 20220404 변경전
                                        SELECT division_id, scm_site_id, max(version_no) max_version_no
                                        FROM   dbo.dm_pln_net_demand WITH(NOLOCK)
                                        WHERE  cutoff_yyyymmdd = @v_demand_cutoff_day -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
                                        --AND    division_id     = @p_division_id   -- 20180717 주석처리
                                        AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)    
                                        GROUP BY  division_id, scm_site_id   */
                                        ) bb
                            ON   aa.scm_site_id     = bb.scm_site_id
                            AND  aa.version_no      = bb.max_version_no
                            AND  aa.division_id     = bb.division_id 
                            AND  aa.division_group  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가), 2022.04.04 수정

                            /* 20220404 변경전
                            --AND aa.division_id     = @p_division_id  -- 20180717 주석처리
                            AND  aa.division_id     IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */
                            --AND  aa.cutoff_yyyymmdd = @v_demand_cutoff_day  -- 2025-09-17 [20250918-001297] 주석 처리

                            LEFT JOIN (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                        SELECT a.division_id, a.scm_site_id, a.vmi_yn 
                                        FROM   scm_mst_site       a WITH(NOLOCK)
                                             , scm_mst_division  di WITH(NOLOCK)
                                        WHERE  di.division_id  =  a.division_id
                                        AND    di.valid_yn     = 'Y'                                          
                                        AND    a.valid_yn      = 'Y'
                                        AND    a.vmi_yn        = 'Y' 
                                        AND    di.attribute3  IN ( '40', '81', '82') --2022.04.04 컬럼변경.20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                                        AND    di.attribute4   =  @v_division_comp

                                     /* 20220404 변경전
                                        SELECT division_id, scm_site_id, vmi_yn 
                                        FROM   scm_mst_site WITH (NOLOCK)
                                        WHERE  valid_yn    = 'Y'
                                        AND    vmi_yn      = 'Y' 
                                        AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */
                                        
                                      ) cc
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

        INSERT INTO /* PR_SCP_ENG_EE_PRE_SET_INVENTORY */ scp_eng_inventory_i_sn 
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
         )
		SELECT --DISTINCT 
               @p_modeling_id  AS modeling_id
			 , @p_plan_id      AS plan_id
			 , @p_plan_type    AS plan_type
			 , @p_seq          AS plan_seq
			 , @p_division_id  AS division_id
			 -- 20210618 C20210617-000105 : location_code 정보 추가
			 --, b.eng_scm_site_id AS scm_site_id
			 , CASE  
                   -- 전극 적용
                   WHEN b.operation_group = 'E' AND a.location_code = 'SLITTING' THEN a.scm_site_id + '~002'
                   ELSE b.eng_scm_site_id
               END scm_site_id

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
			 --, CONVERT(DATETIME, @p_plan_name) AS available_date
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
			 --, [dbo].[FN_SCM_SYS_NVL](a.wiphold_yn, 'N') AS wiphold_yn
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
			 , 'Y'         AS site_item_yn   --20180323 ksg 수정 : DNM에서 해당 정보 생성 안 함
			 , b.site_type
        -- 20220121  PJ20216891 Stock_v -> Stock 테이블로 변경
		-- FROM   scm_dnm_stock_v               a WITH (NOLOCK)  
		FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT a.* 
                     , di.attribute3 AS division_group 
                     , di.attribute4 AS division_comp 
		        FROM   scm_dnm_stock      a WITH (NOLOCK)  
                     , scm_mst_division  di WITH(NOLOCK)
                WHERE di.division_id  =  a.division_id
                AND   di.valid_yn     = 'Y' 
                AND   di.attribute4   = @v_division_comp    --회사코드
              ) a
        /* 20220404 변경전
        FROM   scm_dnm_stock               a WITH (NOLOCK)  */
               --INNER JOIN 
               --            (SELECT division_id, site_id, MAX(cutoff_date) max_cutoff_date 
               --             FROM   scm_dnm_stock_v a
               --             WHERE  a.cutoff_date >  DATEADD(DD, -7, @d_cutoff_day) -- 전전주 일요일
               --             AND    a.cutoff_date <= @d_cutoff_day                  -- 지난주 일요일
               --             -- AND    a.division_id  = @p_division_id -- 20180629 주석처리
               --             AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
               --             GROUP BY division_id, site_id   
               --            ) c --20180305 추가 division_id / Site_id / Factory_id 별로 최근 일주일이내의 MAX(cutoff_date)    
               -- --20180305 수정 division_id / Site_id / Factory_id 별로 최근 일주일이내의 MAX( cutoff_date) 값으로 cutoff_date 수정 (변경전 : AND    a.cutoff_date      = @v_cutoff_day ) )
               --ON   a.division_id  = c.division_id
               --AND  a.site_id      = c.site_id 
               --AND  a.cutoff_date  = c.max_cutoff_date      
               --AND  a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
               
               INNER JOIN dbo.scm_mst_site_eng  b WITH(NOLOCK)
               ON    b.modeling_id      = @p_modeling_id
		       AND   b.plan_id          = @p_plan_id
		       AND   b.plan_seq         = @p_seq
		       AND   b.plan_type        = @p_plan_type		       
               --20180314 속도개선을 위해서 수정
	           -- site eng 에는 Plant Site가 Incoterms 단위로 들어가 있어 Replace 없이 scm_site_id 로 조인하면 뻥튀기 될 수 있음
               AND    a.scm_site_id     =  REPLACE(b.eng_scm_site_id, '~***', '')  --20180314 속도개선을 위해서 수정(변경전: AND    a.scm_site_id + '~***' = b.eng_scm_site_id)
               AND    b.site_type       = 'PLANT'
               AND    b.operation_group IN ( 'E', 'A' ) -- 전극 / Cell

               --AND    a.division_id      = b.division_id -- 20180629 주석처리

               -- 20180704 수정 ( 필요한 전극과 셀 공정의 재고만 가져오기 위해서)  -- opeation_id가 없고 storage_id 만 존재
               LEFT JOIN (  SELECT DISTINCT
                                    a.storage_id
                                 ,  a.location_code
                            FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                    SELECT a.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                    FROM   scm_mst_location   a WITH (NOLOCK)
                                         , scm_mst_division  di WITH(NOLOCK)
                                    WHERE  di.division_id    =  a.division_id
                                    AND    di.valid_yn       = 'Y' 
                                    AND    a.valid_yn        = 'Y'
                                    AND    di.attribute4     = @v_division_comp    --회사코드
                                  ) a
                            /* 20220404 변경전 
                            FROM   scm_mst_location a WITH (NOLOCK)  */

                                    INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                                SELECT a.scm_site_id, a.division_id  
                                                FROM   scm_mst_site       a WITH(NOLOCK)
                                                     , scm_mst_division  di WITH(NOLOCK)
                                                WHERE  di.division_id    =  a.division_id
                                                AND    di.valid_yn       = 'Y' 
                                                AND    a.valid_yn        = 'Y'
                                                AND    a.operation_group IN ( 'E', 'A' ) -- 전극 / Cell
                                                AND    di.attribute3     IN ( '40', '81', '82') --2022.04.04컬럼변경. --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                                                AND    di.attribute4     =  @v_division_comp   -- 회사코드
                                        /* 20220404 변경전
                                                SELECT scm_site_id, division_id  
                                                FROM   scm_mst_site
                                                WHERE  valid_yn        = 'Y'
                                                AND    operation_group IN ( 'E', 'A' ) -- 전극 / Cell
                                                --AND    division_id     = @p_division_id --'81' -- 20180629 주석처리
                                                AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */
                                               ) b
                                    ON  a.scm_site_id = b.scm_site_id 
                                    AND a.division_id = b.division_id 
                            WHERE  a.valid_yn    = 'Y'
                            AND    a.location_code IN ('RAW_MAT_INV', 'MIXING', 'COATING', 'SLITTING'     -- 전극 공정
                                                      ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING' -- 셀공정
                                                      )
                            AND    (a.storage_id IS NOT NULL AND a.storage_id <> '')
                            AND    a.division_group  IN ( '40', '81', '82') -- 2022.04.04컬럼변경.20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)

                             /* 20220404 변경전
                            --AND    a.division_id = @p_division_id --'81' -- 20180629 주석처리
                            AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */

                            UNION -- 전극 출하 SLOC는 별도 Lookup으로 설정
                            SELECT a.segment3       AS storage_id
                                 , 'ELECTRODE_SHIP' AS location_code
                            FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
                            WHERE  a.lookup_type = 'ELECTRODE_SHIP_SITE'
                            AND    a.valid_yn    = 'Y'
                           
                        )  d -- 셀/전극의 storage_id 별 사용대상 조회
               ON a.storage_id = d.storage_id 

               -- 20181004 수정 ( 필요한 전극과 셀 공정의 재고만 가져오기 위해서) : WIP재고용 추가 -- storage_id가 없고 opeation_id 만 존재
               LEFT JOIN (  SELECT DISTINCT
                                    a.operation_id
                                 ,  a.location_code
                            FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                    SELECT a.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                    FROM   scm_mst_location   a WITH (NOLOCK)
                                         , scm_mst_division  di WITH(NOLOCK)
                                    WHERE  di.division_id    =  a.division_id
                                    AND    di.valid_yn       = 'Y' 
                                    AND    a.valid_yn        = 'Y'
                                    AND    di.attribute4   = @v_division_comp    --회사코드
                                    ) a
                            /* 20220404 변경전
                            FROM   scm_mst_location a WITH (NOLOCK) */
                                    INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                                SELECT a.scm_site_id, a.division_id  
                                                FROM   scm_mst_site       a WITH(NOLOCK)
                                                     , scm_mst_division  di WITH(NOLOCK)
                                                WHERE  di.division_id    =  a.division_id
                                                AND    di.valid_yn       = 'Y' 
                                                AND    a.valid_yn        = 'Y'
                                                AND    a.operation_group IN ( 'E', 'A' ) -- 전극 / Cell
                                                AND    di.attribute3     IN ( '40', '81', '82') --2022.04.04컬럼변경.20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                                                AND    di.attribute4     =  @v_division_comp                                    
                                                 /* 20220404 변경전
                                                SELECT scm_site_id, division_id  
                                                FROM   scm_mst_site
                                                WHERE  valid_yn        = 'Y'
                                                AND    operation_group IN ( 'E', 'A' ) -- 전극 / Cell
                                                --AND    division_id     = @p_division_id --'81' -- 20180629 주석처리
                                                AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */
                                               
                                               ) b
                                    ON  a.scm_site_id = b.scm_site_id 
                                    AND a.division_id = b.division_id 
                            WHERE  a.valid_yn    = 'Y'
                            AND    a.location_code IN ('RAW_MAT_INV', 'MIXING', 'COATING', 'SLITTING'     -- 전극 공정
                                                      ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING' -- 셀공정
                                                      )
                            AND    (a.operation_id IS NOT NULL AND a.operation_id <> '')
                            AND    a.division_group  IN ( '40', '81', '82')  -- 2022.04.04 컬럼변경.--20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
                             /* 20220404 변경전
                            --AND    a.division_id = @p_division_id --'81' -- 20180629 주석처리
                            AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */
                           
                        )  e -- 셀/전극의 storage_id 별 사용대상 조회
               ON a.operation_id = e.operation_id 

		WHERE  1 = 1
        AND    a.division_group  IN ( '40', '81', '82') -- 2022.04.04 컬럼변경.20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
        /* 20220404 변경전
        AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */
        AND    a.cutoff_date  = @v_cutoff_day -- @d_cutoff_day  PJ20216891         
        AND   (d.storage_id IS NOT NULL 
		       OR  
               e.operation_id IS NOT NULL
               OR
               (a.stock_type	= 'WIP' AND    stock_status = 'MOVING' )  --20181011 추가
		      )
		;

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
            ----------------------------                     
            -- Update 대상 storage_id
            ----------------------------
            SELECT DISTINCT
                   a.storage_id
                ,  a.location_code
            FROM   scm_mst_location a WITH (NOLOCK)
                    INNER JOIN (SELECT scm_site_id  
                                FROM   scm_mst_site
                                WHERE  division_id     = @p_division_id --'81'
                                AND    valid_yn        = 'Y'
                                AND    operation_group IN ( 'E', 'A' ) -- 전극 / Cell
                                ) b
                    ON a.scm_site_id = b.scm_site_id 
            WHERE  a.division_id = @p_division_id --'81'
            AND    a.valid_yn    = 'Y'
            AND    location_code IN ('COATING','SLITTING', 'FORMATION_CHECK_PACKAGING','CELL_OWMS')
            AND    (storage_id IS NOT NULL AND storage_id <> '')
            UNION -- 전극 출하 SLOC는 별도 Lookup으로 설정
            SELECT a.segment3       AS storage_id
                    , 'ELECTRODE_SHIP' AS location_code
            FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
            WHERE  a.lookup_type = 'ELECTRODE_SHIP_SITE'
            AND    a.valid_yn    = 'Y'
        */
        -----------------------------------------------------------
        UPDATE scp_eng_inventory_i_sn
        SET    scm_site_id =  CASE  
                                    -- 전극 적용
                                    WHEN b.operation_group = 'E' AND c.location_code = 'SLITTING'                   THEN a.org_scm_site_id + '~002'  -- AND a.storage_id IN ( '310B', '311B', '320B', '350B', '351B') THEN a.org_scm_site_id + '~002' 
                                    WHEN b.operation_group = 'E' AND a.stock_type = 'WIP' AND  a.stock_status = 'MOVING'  THEN a.org_scm_site_id + '~002' --20181011 추가
                                    -- 전극 출하 Lookup 적용
                                    WHEN b.operation_group = 'E' AND c.location_code = 'ELECTRODE_SHIP'             THEN a.org_scm_site_id + '~003'  -- AND a.storage_id IN ( '*', '5110') THEN a.org_scm_site_id + '~003
                                    -- Cell 적용 ( 최초  '셀site~***' 들어오는 재고중 *** 재고만                                   
                                    --WHEN b.operation_group = 'A' AND c.location_code = 'CELL_OWMS'                  THEN a.org_scm_site_id + '~003' --AND a.storage_id IN ( '5000', '5100', '5310', '5311', '5320') THEN a.org_scm_site_id + '~003'
                                    --WHEN b.operation_group = 'A' AND c.location_code = 'FORMATION_CHECK_PACKAGING'  THEN a.org_scm_site_id + '~002' --AND a.storage_id IN ( '310T', '311T', '320T') THEN a.org_scm_site_id + '~002'
                                    ELSE a.scm_site_id
                               END
                                                 
        FROM   scp_eng_inventory_i_sn a WITH (NOLOCK)
               INNER JOIN (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                            SELECT a.division_id, a.scm_site_id, a.operation_group, a.site_type
                            FROM   scm_mst_site      a WITH (NOLOCK)
                                 , scm_mst_division  di WITH(NOLOCK)
                            WHERE  di.division_id    =  a.division_id
                            AND    di.valid_yn       = 'Y' 
                            AND    a.valid_yn        = 'Y'
                            AND    a.site_type       = 'PLANT' 
                            AND    a.operation_group = 'E' --20180629 수정 ( 변경전 : AND    operation_group IN ('E', 'A') )
                            AND    a.valid_yn        = 'Y'
                            AND    ISNULL(a.osp_yn, 'N')  = 'N' --20181001 추가
                            AND    di.attribute3     IN ( '40', '81', '82')   -- 2022.04.04 컬럼변경.20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
                            AND    di.attribute4     =  @v_division_comp  -- 회사코드

                             /* 20220404 변경전
                            SELECT division_id, scm_site_id, operation_group, site_type
                            FROM   scm_mst_site WITH (NOLOCK)
                            WHERE  site_type       = 'PLANT' 
                            AND    operation_group = 'E' --20180629 수정 ( 변경전 : AND    operation_group IN ('E', 'A') )
                            AND    valid_yn        = 'Y'
                            -- AND    division_id     = @p_division_id  -- 20180629 주석처리
                            AND    ISNULL(osp_yn, 'N')  = 'N' --20181001 추가
                            AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */

                          ) b 
               ON   a.org_scm_site_id = b.scm_site_id
               AND  a.site_type       = b.site_type    
               --AND  a.division_id     = b.division_id  -- 20180629 주석처리               
               
               LEFT JOIN (  SELECT DISTINCT
                                    a.storage_id
                                 ,  a.location_code
                            FROM  (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                    SELECT a.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                    FROM   scm_mst_location   a WITH (NOLOCK)
                                         , scm_mst_division  di WITH(NOLOCK)
                                    WHERE  di.division_id    =  a.division_id
                                    AND    di.valid_yn       = 'Y' 
                                    AND    a.valid_yn        = 'Y'
                                    AND    di.attribute4     =  @v_division_comp  -- 회사코드
                                  ) a 

                            /* 20220404 변경전
                            FROM   scm_mst_location a WITH (NOLOCK) */ 

                                    INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                                SELECT a.scm_site_id  
                                                FROM   scm_mst_site      a WITH (NOLOCK)
                                                     , scm_mst_division  di WITH(NOLOCK)
                                                WHERE  di.division_id    =  a.division_id
                                                AND    di.valid_yn       = 'Y' 
                                                AND    a.valid_yn        = 'Y'
                                                AND    a.valid_yn        = 'Y'
                                                AND    a.operation_group = 'E' -- 20180629 수정 (변경전 : AND    operation_group IN ( 'E', 'A' ) -- 전극 / Cell)
                                                AND    di.attribute3     IN ( '40', '81', '82')   --2022.04.04컬럼변경. --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                                                AND    di.attribute4     =   @v_division_comp  -- 회사코드                                 
                                                 /* 20220404 변경전
                                                SELECT scm_site_id  
                                                FROM   scm_mst_site
                                                WHERE  valid_yn        = 'Y'
                                                AND    operation_group = 'E' -- 20180629 수정 (변경전 : AND    operation_group IN ( 'E', 'A' ) -- 전극 / Cell)
                                                --AND    division_id     = @p_division_id --'81' -- 20180629 주석처리
                                                AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                                */
                                               ) b
                                    ON a.scm_site_id = b.scm_site_id 
                            WHERE  a.valid_yn    = 'Y'
                            AND    location_code IN ('COATING','SLITTING') -- 20180629 수정 셀의 'FORMATION_CHECK_PACKAGING','CELL_OWMS'은 ~002, ~003에 해당되는 재고 이므로 division_id='EE'(전극) 처리시에는 셀의 ~*** 재고만 필요하므로 수정함 ( 변경전 : AND    location_code IN ('COATING','SLITTING', 'FORMATION_CHECK_PACKAGING','CELL_OWMS'))
                            AND    (storage_id IS NOT NULL AND storage_id <> '')
                            AND    a.division_group  IN ( '40', '81', '82')  --2022.04.04 컬럼변경.--20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                            
                            /* 20220404 변경전
                            --AND    a.division_id = @p_division_id --'81' -- 20180629 주석처리
                            AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */

                            UNION -- 전극 출하 SLOC는 별도 Lookup으로 설정
                            SELECT a.segment3       AS storage_id
                                 , 'ELECTRODE_SHIP' AS location_code
                            FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
                            WHERE  a.lookup_type = 'ELECTRODE_SHIP_SITE'
                            AND    a.valid_yn    = 'Y'
                        )  c -- 셀/전극의 storage_id 별 사용대상 조회
               ON a.storage_id = c.storage_id 
                                            
        WHERE  a.modeling_id  = @p_modeling_id
        AND    a.plan_id      = @p_plan_id 
        AND    a.plan_type    = @p_plan_type 
        AND    a.plan_seq     = @p_seq 
        AND    a.division_id  = @p_division_id
        AND    a.site_type    = 'PLANT'
        AND    ( (c.storage_id IS NOT NULL AND c.storage_id <> '')
                 OR
                 ( b.operation_group = 'E' AND  a.stock_type = 'WIP' AND  a.stock_status = 'MOVING')
               )
        AND    a.scm_site_id  LIKE '%~***'  -- 20210618 C20210617-000105 : location_code 정보 추가
        ;

        SELECT @n_log_count = @@ROWCOUNT , @d_event_date  = SYSDATETIME() ;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'TXN', @n_log_count, N'PART 4 END ', N'4. Plant  UPDATE scp_eng_inventory_i_sn',@d_event_date;
        
        
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

