
/* 
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_TE
 * Description  :
                  -----------------------------------------------------------
                  --1. (FIX) SSP, SCP 출하계획(동일 공장 외) 확정정보 Insert 
				  -----------------------------------------------------------
				     - ship frozon 구간 구분없이, fix data 모두 적용
                     - 참고 테이블1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
                  
				  -----------------------------------------------------------
                  --2. 동일 공장 내 Cell -> Pack 확정선적계획 : Fixed Plan(A~002 -> P~***)으로 반영
                  -----------------------------------------------------------
                      - In-Moving도 별도의 요구사항이 없음으로 반영하지 않는다. 

 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.19   KKC            Initial Release [PJ20216891] LGES Digital SCM 3 Level 가속화를 위한 개선
                               - 소형 TE 계획에 대해서만, 출하확정계획 생성
							   - SSP 확정계획 구분없이, SCP FIX 전 구간 반영
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_TE]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_TE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_FIXED_PLAN';
    DECLARE @d_event_date   DATETIME;

    DECLARE @v_cur_monday   NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name    DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date     NVARCHAR(8) ; -- Plan End Date

    -- 확정계획 대상 plan 정보
    DECLARE @v_pre_plan_start_yyyymmdd NVARCHAR(8);  --plan_name
    DECLARE @v_pre_plan_type           NVARCHAR(50); --plan_type
    DECLARE @n_pre_plan_seq            INTEGER;      --plan_seq
    DECLARE @v_pre_plan_id             NVARCHAR(8); --plan_id

    DECLARE @v_division_group   NVARCHAR(30);   ---(2022.04.04) 추가.
    DECLARE @v_division_comp    NVARCHAR(30); 

    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC  >>  division_comp: LG , UC
    ----------------------------------------------------------------------*/                        
    SELECT @v_division_group   =  di.attribute3
          , @v_division_comp   =  di.ATTRIBUTE4  -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id 
	; 

    /*~(2022.04.29) Project code 유지여부 설정 변수 정의. * division_id, plan_type별 가부(Y/N)을 lookup에서 등록한다. ~*/ 
    DECLARE @v_hp_pjt_code_yn        NVARCHAR(30) = 'N'   ;   

	SELECT @v_hp_pjt_code_yn =            
           CASE WHEN  @p_plan_type = 'PR'  THEN (CASE WHEN ISNULL(SEGMENT2 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'MA'  THEN (CASE WHEN ISNULL(SEGMENT3 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'FN'  THEN (CASE WHEN ISNULL(SEGMENT4 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'TE'  THEN (CASE WHEN ISNULL(SEGMENT5 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )   
           END  
	FROM   scm_adm_lookup_master_detail a WITH(NOLOCK) 
	WHERE  a.lookup_type = 'HP_PJT_CODE_YN'
    AND    a.segment1    =  @p_division_id    
    AND    a.valid_yn    = 'Y' ;   

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

        SELECT @v_pet_date = p.horizon_end_date
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
 
        -----------------------------------------------------------
	    -- PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD 에서는 Delete 하지 않음      
        -----------------------------------------------------------         
        DELETE /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_TE */ 
        FROM   th_eng_fixed_plan_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
	    
		-----------------------------------------------------------
        --1) 지난 주 Plan 정보 조회 
        --20181219 수정 ( 전주에 배치 미실행했을경우 때문에 @v_pre_plan_start_yyyymmdd 전주 -> 데이터가존재하는 최근이전주로 변경 )
        SELECT @v_pre_plan_start_yyyymmdd = pre_plan_start_yyyymmdd
             , @v_pre_plan_id             = pre_plan_id
        FROM ( 
                SELECT a.plan_name AS pre_plan_start_yyyymmdd
                     , a.plan_id   AS pre_plan_id
                     , ROW_NUMBER() OVER (ORDER BY a.plan_id DESC) row_num                  
                
                FROM   scm_mst_plan a WITH (NOLOCK)
                       INNER JOIN scm_mst_plan_detail b WITH (NOLOCK)
                       ON  a.division_id  = b.division_id
                       AND a.plan_id      = b.plan_id 
                       AND b.confirm_flag = 'Y'

                WHERE  a.division_id =  @p_division_id 
                AND    a.plan_cycle  =  @p_plan_cycle
                AND    a.plan_name   >= CONVERT(CHAR(8), DATEADD(DD, -7 * 4, @d_plan_name), 112)
                AND    a.plan_name   <  @d_plan_name
            ) x
        WHERE x.row_num = 1
		;
        
		--2) 지난 주 Confirm된 Plan 정보 조회 
		SELECT @v_pre_plan_type = a.plan_type
             , @n_pre_plan_seq  = a.plan_seq
        FROM   (
                SELECT plan_type, plan_seq
                     , ROW_NUMBER() OVER (ORDER BY CASE WHEN plan_type = 'FN' THEN 1
                                                        WHEN plan_type = 'SE' THEN 2
                                                        WHEN plan_type = 'MA' THEN 3
                                                        WHEN plan_type = 'PR' THEN 4
                                                        ELSE 9   -- 20181115 추가 'TE', 'TM' 때문에 추가함 (주의 ELSE 처리안하면 TE, TM 가장최근에 실행되었으면  TE, TM이 NULL로 처리되어서 첫번째로 조회될수 있음)  ('TE' : 시뮬레이션용 'PR'과 동일하게 처리됨, 'TM': 시뮬레이션용 'MA'동일하게 처리됨) 
                                                   END
                                         ) AS rownumber
                FROM   scm_mst_plan_detail WITH (NOLOCK)
                WHERE  division_id  = @p_division_id
                AND    plan_id      = @v_pre_plan_id
                AND    confirm_flag = 'Y'
               ) a
        WHERE  rownumber = 1
        ;
        -----------------------------------------------------------
        
        DECLARE @v_pre_plan_start_yyyymmdd_daily NVARCHAR(8);  --plan_name
        DECLARE @v_pre_plan_type_daily           NVARCHAR(50); --plan_type
        DECLARE @n_pre_plan_seq_daily            INTEGER;      --plan_seq
        DECLARE @v_pre_plan_id_daily             NVARCHAR(8); --plan_id
               	
        -- 1) Daily는 SP Type만 존재함
        SET @v_pre_plan_type_daily = 'SP';
        
        -- 2) 최종 plan_id, plan_seq              
        SELECT @v_pre_plan_id_daily = MAX(plan_id)
        FROM   scm_mst_plan_detail WITH (NOLOCK)
        WHERE  division_id = @p_division_id 
        AND    plan_type   = @v_pre_plan_type_daily
        AND    plan_status = 1
        ;

        SELECT @n_pre_plan_seq_daily = MAX(plan_seq)
        FROM   scm_mst_plan_detail WITH (NOLOCK)
        WHERE  division_id = @p_division_id 
        AND    plan_id     = @v_pre_plan_id_daily
        AND    plan_type   = @v_pre_plan_type_daily
        AND    plan_status = 1
        ;

        -- 3) plan_name
        SELECT @v_pre_plan_start_yyyymmdd_daily = plan_name
        FROM   scm_mst_plan WITH (NOLOCK)
        WHERE  division_id = @p_division_id 
        AND    plan_id     = @v_pre_plan_id_daily
        ;        
           		
        -----------------------------------------------------------
        --1. (FIX) 전구간 SCP 출하 확정정보 Insert 
		/*
	        - 참고 테이블1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
        */
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_TE */ th_eng_fixed_plan_sn
        ( master_id
        , plan_id
        , work_order_id
        , work_order_seq
        , site_id
        , route_id
        , operation_id
        , item_id
        , resource_id
        , sub_resource_id
        , start_dttm
        , end_dttm
        , operation_qty
        , complete_qty
        , lot_id
        , is_fixed
        , is_prev_schedule
        , keep_work_time_type
        , keep_qty_type
        , sales_model_id
        , attribute_set_id
        , demand_id
        , descr
        , is_noh_consume
        , project_code    --~(2022.04.29) 참고용으로 추가.
        , business_type   --~(2022.04.29) 추가.
        )
        SELECT DISTINCT --20181220 distinct 추가 (ssp_anl_ship_confirm 아래조인시 중복건 존재 -> division_id= '81', confirm_id : C20181217342707, C20181217342708, C20181217342709)
               @p_master_id AS master_id
             , @p_engine_plan_id AS plan_id              
             , a.id AS work_order_id             
             , 1 AS work_order_seq
             , be.eng_to_site   AS site_id --(변경전 : , a.to_site_id  AS site_id)
             , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
             , a.item_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
             , NULL AS sub_resource_id             
             , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
             , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm             
             , a.qty AS operation_qty
             , a.qty AS complete_qty             
             , a.id AS lot_id
             , 'N' AS is_fixed
             , 'Y' AS is_prev_schedule
             , 'START_FIX' AS keep_work_time_type
             , 'ALL_QTY_FIX' AS keep_qty_type
             , NULL AS sales_model_id
             , NULL AS attribute_set_id
             , NULL AS demand_id
             , 'DO::CFM' AS descr
             , 'Y' AS is_noh_consume

             , project_code  AS project_code   --~(2022.04.29) 추가. 
               /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
             , CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND  a.project_code2 != '-'  THEN  a.project_code2
                    ELSE 'ALL' 
               END  AS  business_type   

		-- (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
        FROM   (          
		       SELECT scp.fix_id     AS id 
					, scp.item_id    AS item_id
					, scp.bod_id     AS bod_id
					, scp.yyyymmdd   AS yyyymmdd
					, scp.from_site  AS from_site
					, scp.qty        AS qty    
                    , scp.project_code  AS  project_code  --~(2022.04.29) 추가. 
                    , scp.project_code2 AS  project_code2 --~(2022.04.29) 추가. 
				FROM 
					( SELECT  f.division_id, f.yyyymmdd, f.biz_type, f.item_id 
							, f.from_site, f.to_site
							, CASE WHEN mse.site_type = 'PLANT' THEN '-'
								   ELSE f.project_code
							   END project_code
							, CASE WHEN mse.site_type = 'PLANT' THEN '-'
								   ELSE f.incoterms
							   END incoterms
							, f.bod_id, f.fix_id, f.qty
                              /*~(2022.04.29) project_code2추가: to_site가 'SALES'일 때만 project code를 가져온다  ~*/ 
				            , CASE WHEN ISNULL(mse.site_type, '-') != 'SALES'  THEN '-'
                                ELSE ISNULL(f.project_code, '-') 
					          END  AS  project_code2

					   FROM  scp_anl_shipment_plan_fix f WITH (NOLOCK)
					 INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
									 FROM scm_mst_site_eng WITH (NOLOCK)
								    WHERE modeling_id = @p_modeling_id 
									  AND plan_id     = @p_plan_id     
									  AND plan_type   = @p_plan_type  
									  AND plan_seq    = @p_seq        
									  AND division_id = @p_division_id
								)  mse
					 ON f.division_id = mse.division_id
					AND f.to_site     = mse.scm_site_id
				  WHERE f.division_id = @p_division_id
					AND f.qty         >  0
					AND f.yyyymmdd    >= @p_plan_name 
					) scp 
               ) a  				 
              INNER JOIN (  SELECT ship_frozen, scm_site_id 
                            FROM   scm_mst_site_eng WITH (NOLOCK)
                            WHERE  modeling_id = @p_modeling_id
                            AND    plan_id     = @p_plan_id
                            AND    plan_type   = @p_plan_type
                            AND    plan_seq    = @p_seq
                            AND    division_id = @p_division_id
                            AND    eng_scm_site_id = scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                         )  mse
               ON a.from_site = mse.scm_site_id
               --20190122 수정 (속도개선)INNER JOIN을 LEFT JOIN으로 수정
               LEFT JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id  --20190122 수정(변경전 : INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id )                                                                                                         
                                 , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                 , eng_to_site
                            FROM   scm_mst_bod_eng WITH (NOLOCK)
                            WHERE  plan_id     = @p_plan_id
                            AND    plan_type   = @p_plan_type
                            AND    plan_seq    = @p_seq
                            AND    division_id = @p_division_id        
                            AND    attribute1  = 'OUTER_SITE'  -- 공장외부 일때  
                          ) be
               ON   a.bod_id = be.bod_id
			   -- 20210303 PJ20209642 BOD Item 추가
               LEFT OUTER JOIN 
                          ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                                 , item_id                            AS item_id
                                 , frozen_period                      AS frozen_period -- ESS 동기화 구간 : BOD Fixed Term으로 적용됨
                                 , CONVERT(INT, attribute3)           AS ship_frozen   -- Plant Site의 Ship Frozen 설정값 : SSP Confirm 값을 확정계획으로 반영
                            FROM   scm_mst_bod_item_eng WITH (NOLOCK)
                            WHERE  plan_id     = @p_plan_id
                            AND    plan_type   = @p_plan_type
                            AND    plan_seq    = @p_seq
                            AND    division_id = @p_division_id          
                          ) bie
               ON   a.bod_id  = bie.bod_id
               AND  a.item_id = bie.item_id
        /* 소형 TE는 예외적으로 SSP 구간 구분없이 전 구간 FIX 반영 */ 
		--WHERE  a.yyyymmdd >= CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0)), @d_plan_name), 112)
        WHERE a.yyyymmdd >= @p_plan_name
		  AND a.yyyymmdd <= @v_pet_date
          AND be.bod_id IS NOT NULL --20190122 추가 (속도개선)INNER JOIN을 LEFT JOIN으로 수정하면서 INNER JOIN과 같은결과를 얻기위해서 추가함
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'1. (FIX) 확정 출하계획(공장외부) 정보 Insert : 전체구간' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --2. 동일 공장 내 Cell -> Pack 확정선적계획(In House Moving 계획 : Fixed Plan(A~002 -> P~***)으로 반영
        -----------------------------------------------------------		 
        /*
		INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_TE */ th_eng_fixed_plan_sn
        ( master_id
        , plan_id
        , work_order_id
        , work_order_seq
        , site_id
        , route_id
        , operation_id
        , item_id
        , resource_id
        , sub_resource_id
        , start_dttm
        , end_dttm
        , operation_qty
        , complete_qty
        , lot_id
        , is_fixed
        , is_prev_schedule
        , keep_work_time_type
        , keep_qty_type
        , sales_model_id
        , attribute_set_id
        , demand_id
        , descr
        , is_noh_consume
        )
		SELECT DISTINCT 
               @p_master_id AS master_id
             , @p_engine_plan_id AS plan_id              
             , a.id AS work_order_id             
             , 1 AS work_order_seq
             , be.eng_to_site   AS site_id --(변경전 : , a.to_site_id  AS site_id)
             , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
             , a.item_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
             , NULL AS sub_resource_id             
             , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
             , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm             
             , a.qty AS operation_qty
             , a.qty AS complete_qty             
             , a.id AS lot_id
             , 'N' AS is_fixed
             , 'Y' AS is_prev_schedule
             , 'START_FIX' AS keep_work_time_type
             , 'ALL_QTY_FIX' AS keep_qty_type
             , NULL AS sales_model_id
             , NULL AS attribute_set_id
             , NULL AS demand_id
             , 'DO::INH' AS descr
             , 'Y' AS is_noh_consume                      
        FROM   ( SELECT 
                         -- 1. MOV 존재하면 MOV, 존재하지 않으면 SCP 데이터를 입력한다.      
                          CASE WHEN mov.qty IS NULL THEN scp.fix_id
                               ELSE 'DO::INH::' + CONVERT(NVARCHAR(10), 400000 + ROW_NUMBER() OVER (ORDER BY mov.item_id))
                          END AS id 
                        , ISNULL(mov.item_id, scp.item_id) AS item_id
                        , ISNULL(mov.bod_id, scp.bod_id)   AS bod_id
                        , ISNULL(mov.yyyymmdd, scp.yyyymmdd) AS yyyymmdd
                        , ISNULL(mov.from_site, scp.from_site) AS from_site
                        , ISNULL(mov.to_site, scp.to_site) AS to_site     
                        , ISNULL(mov.qty, scp.qty) AS qty                    
                 FROM 
                      ( SELECT f.division_id, f.yyyymmdd, f.biz_type, f.item_id 
							   , f.from_site, f.to_site
						       , '-' AS project_code
						       , '-' AS incoterms
                               , f.bod_id, f.fix_id, f.qty
                        FROM   scp_anl_shipment_plan_fix f WITH (NOLOCK)
                               INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
                                             FROM   scm_mst_site_eng WITH (NOLOCK)
                                             WHERE  modeling_id = @p_modeling_id 
                                             AND    plan_id     = @p_plan_id    
                                             AND    plan_type   = @p_plan_type  
                                             AND    plan_seq    = @p_seq        
                                             AND    division_id = @p_division_id 
											 AND    site_type   = 'PLANT' -- 20180114 (FIX) SSP는 To Site가 PLANT인 경우만 FIX 적용
                                          )  mse
                               ON  f.division_id = mse.division_id
			                   AND f.to_site     = mse.scm_site_id
                        WHERE  f.division_id   = @p_division_id 
                        AND    f.qty           >  0
                        AND    f.yyyymmdd      >= @p_plan_name   
                        ) scp              
                        FULL OUTER JOIN 
                                ( SELECT a.division_id, a.yyyymmdd, a.biz_type, a.item_id
                                        , a.from_site
                                        , a.to_site
                                        , '-' AS project_code
                                        , '-' AS incoterms
                                        , b.bod_id, a.qty
                                  FROM  (
                                         SELECT p.division_id, CONVERT(VARCHAR(8), p.plan_date, 112) AS yyyymmdd
										      , fs.operation_group AS biz_type, p.item_id
                                              , fs.scm_site_id AS from_site
                                              , ts.scm_site_id AS to_site
                                              , p.qty
                                         FROM   scm_dnm_cell_inhouse_plan_sn p WITH(NOLOCK)
                                              , scm_mst_site fs WITH(NOLOCK)
                                              , scm_mst_site ts WITH(NOLOCK)
                                         WHERE  1=1
                                         AND    p.division_id      = @p_division_id
                                         AND    p.division_id      = fs.division_id
                                         AND    p.plant_id         = fs.plant_id
                                         AND    p.category         = 'MOVING'
                                         AND    p.plan_date       >= @p_plan_name
                                         AND    p.qty             >  0
                                         AND    fs.operation_group = 'A'
                                         AND    fs.site_type       = 'PLANT'  
                                         AND    fs.osp_yn          = 'N'
                                         AND    fs.valid_yn        = 'Y'
                                         AND    p.division_id      = ts.division_id
                                         AND    p.plant_id         = ts.plant_id
                                         AND    ts.operation_group = 'P'
                                         AND    ts.site_type       = 'PLANT'  
                                         AND    ts.osp_yn          = 'N'
                                         AND    ts.valid_yn        = 'Y'
                                        ) a
                                        INNER JOIN (
                                                    SELECT dbo.FN_SCM_SPLIT(b.bod_id, 1, '::')  AS bod_id  --20190122 수정(변경전 : INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id )
                                                         , b.from_site, b.to_site
                                                    FROM scm_mst_bod_eng b WITH (NOLOCK)
                                        				 INNER JOIN (SELECT eng_from_site, eng_to_site, MIN(priority) AS priority
                                                                     FROM   scm_mst_bod_eng WITH (NOLOCK)
                                                                     WHERE  plan_id     = @p_plan_id
                                                                     AND    plan_type   = @p_plan_type
                                                                     AND    plan_seq    = @p_seq
                                                                     AND    division_id = @p_division_id        
                                                                     AND    attribute1  = 'INNER_SITE'  -- 공장내부 일때  
                                                                     GROUP BY eng_from_site, eng_to_site
                                         				            ) bm
                                                         ON  b.eng_from_site = bm.eng_from_site
                                                         AND b.eng_to_site   = bm.eng_to_site
                                                         AND b.priority      = bm.priority
                                                    WHERE  b.plan_id     = @p_plan_id
                                                    AND    b.plan_type   = @p_plan_type
                                                    AND    b.plan_seq    = @p_seq
                                                    AND    b.division_id = @p_division_id        
                                                    AND    b.attribute1  = 'INNER_SITE'  -- 공장내부 일때  
                                        ) b
                                        ON  a.from_site = b.from_site
                                        AND a.to_site   = b.to_site						                               
                                ) mov
                        ON   scp.division_id  = mov.division_id 
                        AND  scp.yyyymmdd     = mov.yyyymmdd
                        AND  scp.biz_type     = mov.biz_type 
                        AND  scp.item_id      = mov.item_id
                        AND  scp.project_code = mov.project_code
                        AND  scp.to_site      = mov.to_site
                        AND  scp.incoterms    = mov.incoterms 
                        AND  scp.from_site    = mov.from_site
                        AND  scp.bod_id       = mov.bod_id                   
              ) a
               --20190122 수정 (속도개선)INNER JOIN을 LEFT JOIN으로 수정
               LEFT JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id  --20190122 수정(변경전 : INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id )
                                 , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                 , eng_from_site, eng_to_site
                            FROM   scm_mst_bod_eng WITH (NOLOCK)
                            WHERE  plan_id     = @p_plan_id
                            AND    plan_type   = @p_plan_type
                            AND    plan_seq    = @p_seq
                            AND    division_id = @p_division_id        
                            AND    attribute1  = 'INNER_SITE'  -- 공장내부 일때  
                          ) be
               ON   a.bod_id = be.bod_id               
               LEFT JOIN (
                  SELECT fixed_term AS ship_frozen
                        , SUBSTRING(from_site_id, 1, CHARINDEX('~', from_site_id)-1) AS from_site 
                        , SUBSTRING(to_site_id, 1, CHARINDEX('~', from_site_id)-1) AS to_site 
                        , SUBSTRING(bod_id, 1, CHARINDEX('::', bod_id)-1) AS item_id 
                        , bod_id AS eng_bod_id 
						--,*
                   FROM   th_eng_bod_sn WITH (NOLOCK)
                   WHERE  master_id       = @p_master_id
                   AND    plan_id         = @p_engine_plan_id
                   AND    from_site_id LIKE '%~002'  --내부 출하 BOD
                   AND    to_site_id   LIKE '%~***'  --내부 출하 BOD
                  )  b
               ON  a.from_site   = b.from_site
               AND a.to_site     = b.to_site
               AND a.item_id     = b.item_id
               AND b.eng_bod_id  LIKE '%' + a.bod_id + '%'
        /* SSP 확정구간 고려없이, 전구간 SCP FIX로 적용 */
		--WHERE  a.yyyymmdd >=  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(b.ship_frozen, 0), @d_plan_name), 112) --확정구간 이후
        WHERE a.yyyymmdd >= @p_plan_name
		  AND a.yyyymmdd <=  @v_pet_date
          AND be.bod_id IS NOT NULL --20190122 추가 (속도개선)INNER JOIN을 LEFT JOIN으로 수정하면서 INNER JOIN과 같은결과를 얻기위해서 추가함
          AND b.eng_bod_id IS NOT NULL  --(속도개선을 위해서INNER조인을 LEFT조인으로 변경시 INNER조인과 같은 조회값을 위해서 조건추가함)
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'2. 동일 공장 내 Cell -> Pack 확정선적계획' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
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

