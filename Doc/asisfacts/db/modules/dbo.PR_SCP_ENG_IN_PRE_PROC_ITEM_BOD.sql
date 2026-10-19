
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD
 * Description  : SDB의 Item BOD 정보를 ODB에 적재되도록 한다.
                  
                  1.alt_priority 
                    :      순위1) scm_mst_site_item_priority.priority 그룹별로( plant_site_id, sales_site_id, item_id GROUP BY )  가장작은값만 사용   
                           순위2) scm_mst_bod_eng.priority            그룹별로(from_site, item_id, IIF(division_id='81', scm_mst_site_item_priority.sales_site_id, scm_mst_bod_eng.to_site) GROUP BY ) 가장작은값만 사용 
                           ==> 위 결과에서 1개의 bod id에 대해서  그룹별로(item_id, eng_from_site, eng_to_site GROUP BY(transport_mode가 여러개존재할수있음)) 가장작은값만 사용

                           순위3) MIN(BOD Lead Time)값을 그룹별로(순위1), 순위2)결과에서 item_id, to_site GROUP BY) 가장작은순으로 Numbering
                                  (참고 : MIN(BOD Lead Time) => 위의 순위1), 순위2)결과에서 from_site, to_site, item_id GROUP BY) 
                           
                                  순위3 ex) item_id	        bod_id	    alt_priority	eng_from_site	eng_to_site	      MIN(BOD Lead Time)    transport_time(=attribute10(BOD Lead Time))   최종alt_priority
                                            ACEN4069I-A1	407::x::x	9920000	        A040-A~003	    Ford_US_RDF~DDP	  5                     5                                             9920001 (scm_mst_site_item_priority.priority 없어서 9900, scm_mst_bod_eng.priority *10 = 2 * 10, BOD Lead Time numerbing = 001 ==> (9900 + 20) * 1000 + 001 : 9910001 )
                                            ACEN4069I-A1	408::x::x	9910000	        A040-A~003	    Ford_US_RDF~DDP	  5                     26                                            9910001
                                            ACEN4069I-A1	414::x::x	1020000	        G481-A~003	    Ford_US_RDF~DDP	  7                     7                                             1020002 (scm_mst_site_item_priority.priority = 1 * 1000, scm_mst_bod_eng.priority *10 = 2 * 10, BOD Lead Time numerbing = 002 ==> (1000 + 20) * 1000 + 002 : 1020002 )
                                            ACEN4069I-A1	415::x::x	1010000	        G481-A~003	    Ford_US_RDF~DDP	  7                     36                                            1010002
											
                    - (1차) alt_priority :
                                        ( [scm_mst_site_item_priority 테이블의 plant_site_id, sales_site_id, item_id 별 MIN(priority)*1000]  -- *1000 은 위의 순위1), 순위2) 결합하기 위해서 사용
                                          + (scm_mst_bod_eng.priority*10)
                                        ) * 1000  -- *1000은 위의 순위3)의 numbering개수가 최대999개 까지 존재할것을 대비해서 사용함 
                                        
                    - (최종) alt_priority : [ (1차) alt_priority ] +  ( item_id, to site 별 alt_priority 의 transport_time 작은순으로 numbering ) 
                  
                  2. min_lot_size, increment_lot_size
                     - 출하 Lot 적용 테이블 : SCP_MST_SHIPMENT_LOT_SIZE
                     - To Site 가 Sales 이거나 다른 국가인 경우 또는 외주일때 (scm_mst_site_eng.osp_yn = 'Y') )  값적용
                     - Item BOD : 1) min_lot_size       = SCP_MST_SHIPMENT_LOT_SIZE.LOT_SIZE
                                  2) increment_lot_size = SCP_MST_SHIPMENT_LOT_SIZE.INCREMENT
                     - 없는 경우 Default NULL 처리

 * OutTable     : TH_ENG_ITEM_BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.22   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.24   KSW            alt_priority 값 변경( '기존 alt_priority' + '동일 item, to site 일때  alt_priority의 일순위의 transport_time으로 numbering')
 * 2018.06.08   KSW            early_producing_term  값변경( scm_mst_site_eng.build_ahead 값으로 설정)
 * 2018.07.26   KSW            min_lot_size, increment_lot_size 컬럼 값적용
 * 2018.09.10   KSW            scp_mst_shipment_lot_size.to_site 조인조건 추가( to_site 컬럼 신규추가로 인한 조인조건 추가)  (참고)주석1)
 * 2018.09.10   KSW            BOD ITEM 자동생성 관련 수정 (참고)주석1)
 * 2018.11.23   KSW            safety_stock_term, safety_stock_uom 컬럼값 셋팅 (참고)주석1, 주석2
 * 2019.02.18   KSW            특성 CAPA 반영 관련수정 (참고)주석1, 주석2 (이부분 수정시 1)PROC_BOD, 2)PROC_ITEM_BOD, 3)PROC_FIXED_PLAN, 4)PROC_PRODUCT_MIX, 5)PROC_PRODUCT_MIX_MAP 수정검토필요함) 
 * 2019.03.25   KSW            early_producing_term 컬럼값 수정 ( to site 가 외주셀site일때 0 처리함) 참고)주석1
 * 2020.03.23   KSG            [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
 * 2021.05.25   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ESS Partial = 'N'일때, ITEM BOD LOT SIZE 미적용
 * 2021.06.07   SEO			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ITEM BOD의 유효일자를 BOD의 유효일자로 대체
 * 2021.07.06   KKC			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 기간별 BOD 적용(임시테이블 정리 및 1순위 BOD로만 ITEM BOD 만드는 로직 개선)
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_ITEM_BOD';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

    DECLARE @v_division_group    NVARCHAR(30);  ---(2022.04.04) 추가.
    DECLARE @v_division_comp     NVARCHAR(30); 
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
    AND    di.division_id      =  @p_division_id  ; 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
        DELETE /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD */ 
        FROM  th_eng_item_bod_sn
        WHERE 1=1
        AND   plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
        ;

        -----------------------------------------------------------
		-----------------------------------------------------------
        -- 1. item bod 대상 데이터 임시테이블에 INSERT
        -----------------------------------------------------------       
		--//2021.07.06, 추가
        IF OBJECT_ID('tempdb..#th_eng_item_bod_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_item_bod_temp; 
        END  

        SELECT DISTINCT 
               bie.item_id 
             , be.bod_id 
             , (ISNULL(sip.min_priority, 9900) + (be.priority*10)) * 1000  AS alt_priority
             , be.eng_from_site 
             , be.eng_to_site
             , CONVERT(NUMERIC(3), be.attribute10) AS transport_time
             --, be.safety_stock --20181123주석처리함 (아래 safety_stock_term 컬럼으로 대체함)             
             -- 20180608추가  정상 BOD 일경우에만 from site 의 build_ahead 값을 early_producing_term에 셋팅함( 기존에는 item_route_site 처리부분에서 설정하였음)
             , CASE WHEN mst.osp_yn = 'Y' AND mst.operation_group = 'A'       THEN 0 --to site 외주셀 site 일때 0  처리함
                    WHEN be.attribute1 IN ('OUTER_SITE', 'INNER_SITE') AND NOT(ISNULL(mst.osp_yn, 'N') = 'Y'  AND mst.operation_group = 'A') THEN ISNULL(mse.build_ahead, 0)
                    ELSE 0
               END  AS early_producing_term  
             , CASE WHEN be.attribute1 = 'OUTER_SITE' THEN lot.lot_size  
                    ELSE NULL
               END  AS min_lot_size -- 20180726 추가
		     , CASE WHEN be.attribute1 = 'OUTER_SITE' THEN lot.increment
                    ELSE NULL
               END  AS increment_lot_size -- 20180726 추가  
             , ss.safety_stock AS safety_stock_term --20181123 추가
             , be.attribute1 --20190218 추가 (특성CAPA반영관련)
             , bie.attribute2  AS post_buffer_time -- 20200323 추가 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : 도착 후 대기시간  
			 , ISNULL(be.attribute4, @p_plan_name) AS from_yyyymmdd	--2021.07.06 수정/보완
			 , ISNULL(be.attribute5, '20991231')   AS to_yyyymmdd   --2021.07.06 수정/보완
        INTO   #th_eng_item_bod_temp       
        --20180910 수정 (시작~종료일이 다른 동일한 item BOD 존재하므로 distinct 처리함) (변경전 :   FROM   scm_mst_bod_item_eng bie WITH(NOLOCK) )
        FROM   ( SELECT DISTINCT 
                        modeling_id, plan_id, plan_seq, plan_type
                      , bod_id, item_id
                      , attribute2  -- 20200323 추가 [전지 공급 대응력 향상을 위한 RTF 적확도 개선]
                   FROM scm_mst_bod_item_eng WITH (NOLOCK)                         
                  WHERE modeling_id   = @p_modeling_id	
		            AND plan_id       = @p_plan_id		
		            AND plan_type     = @p_plan_type
		            AND plan_seq      = @p_seq
               ) bie
               INNER JOIN  scm_mst_bod_eng              be  WITH(NOLOCK) 
               ON   bie.modeling_id = @p_modeling_id	
		       AND  bie.plan_id     = @p_plan_id	
		       AND  bie.plan_type   = @p_plan_type	
		       AND  bie.plan_seq    = @p_seq			
		       AND  bie.modeling_id = be.modeling_id
		       AND  bie.plan_id     = be.plan_id
		       AND  bie.plan_type   = be.plan_type
		       AND  bie.plan_seq    = be.plan_seq
               AND  bie.bod_id      = be.bod_id
               -- 20180608 추가 ( build_ahead 컬럼 사용하기 위해서 조인 추가함)
               INNER JOIN scm_mst_site_eng mse WITH (NOLOCK)
               ON   be.eng_from_site = mse.eng_scm_site_id 
               AND  mse.modeling_id = @p_modeling_id 
               AND  mse.division_id = @p_division_id 
               AND  mse.plan_id     = @p_plan_id 
               AND  mse.plan_type   = @p_plan_type 
               AND  mse.plan_seq    = @p_seq
               AND  mse.site_type   = 'PLANT' 		  	   
                --20190325 추가 to site 가 외주(TCO)셀 site일경우 early_producing_term =0 처리 위해서 추가
               INNER JOIN scm_mst_site_eng mst WITH (NOLOCK)
               ON   be.eng_to_site = mst.eng_scm_site_id 
               AND  mst.modeling_id = @p_modeling_id 
               AND  mst.division_id = @p_division_id 
               AND  mst.plan_id     = @p_plan_id 
               AND  mst.plan_type   = @p_plan_type 
               AND  mst.plan_seq    = @p_seq               
               INNER JOIN  scp_eng_itemsitemstr_i_sn    eis WITH(NOLOCK)
		       ON   bie.modeling_id = eis.modeling_id
		       AND  bie.plan_id     = eis.plan_id
               AND  bie.plan_type   = eis.plan_type   --20180321 plan_type 추가
		       AND  bie.plan_seq    = eis.seq
		       AND  bie.item_id     = eis.item             
               LEFT HASH JOIN ( 
							  SELECT plant_site_id, item_id, ISNULL(sales_site_id, '-') sales_site_id, MIN(PRIORITY) * 1000 min_priority
							   FROM   scm_mst_site_item_priority WITH (NOLOCK)
							   WHERE  division_id = @p_division_id 
							   AND    to_yyyymmdd >= @p_plan_name
							   AND    valid_yn = 'Y'
							   GROUP BY plant_site_id, item_id, sales_site_id
							 ) sip
               ON   be.from_site    = sip.plant_site_id
               ---2022.04.04 JV사업부 추가 변수변경: @p_division_id -> @v_division_group
               AND  be.to_site      = IIF(@v_division_group = '81', sip.sales_site_id, be.to_site) --자동차(81)일때만 scm_mst_site_item_priority.sales_site_id값 존재함 

               /* 20220404 변경전 
               AND  be.to_site      = IIF(@p_division_id = '81', sip.sales_site_id, be.to_site) --자동차(81)일때만 scm_mst_site_item_priority.sales_site_id값 존재함  */

               AND  bie.item_id     = sip.item_id 
               --20180726 추가 (min_lot_size, increment_lot_size 적용때문에)
			   LEFT JOIN ( SELECT a.division_id
			                    , a.operation_group
								, a.from_site
								, a.item_id
								, a.transport_mode
                                , a.lot_size
								, a.increment                 
                                , a.to_site --20180910 추가                
                             FROM scp_mst_shipment_lot_size a WITH (NOLOCK)
                            WHERE division_id = @p_division_id 
                              AND valid_yn    = 'Y'
                              /* ESS 사업부는 Patial = 'N'일때, Demand를 출하LOT SIZE로 SPLIT하기 때문에 제외 
								 20210524, By KKC */
							  AND NOT EXISTS ( 
                                              SELECT 'X'
                                                FROM scm_mst_site_item x WITH (NOLOCK)
                                               WHERE @v_division_group  = '82'            --ESS 사업부만 대상으로 한다, 2022.04.04 JV사업부 추가: division_grop으로 사업부 구분
                                                 AND x.division_id      = @p_division_id  -- 2022.04.04 조건추가
                                                 AND x.partial_plan_yn  = 'N'
												 AND x.scm_site_id      = a.to_site
												 AND x.item_id          = a.item_id 
                                           /* 20220404 변경전 
											  SELECT 'X'
											    FROM scm_mst_site_item x WITH (NOLOCK)
											   WHERE x.division_id = '82' --ESS 사업부만 대상으로 한다.
												 AND x.partial_plan_yn = 'N'
												 AND x.scm_site_id = a.to_site
												 AND x.item_id     = a.item_id   */
											  )
                         )  lot
               ON   be.from_site      = lot.from_site 
               AND  be.to_site        = lot.to_site   --20180910 추가
               AND  be.transport_mode = lot.transport_mode 
               AND  bie.item_id       = lot.item_id
               --20181123 추가( bod_id, item_id 별로 eff_start_date, eff_end_date 가 N개존재하므로 플랜시작일(@p_plan_name)보다크고 제일작은 eff_end_date값의 safety_stock값을 사용하기 위해서 사용함)
               LEFT HASH JOIN (
                            SELECT bod_id, item_id, safety_stock 
                                 , ROW_NUMBER() OVER (PARTITION BY bod_id, item_id ORDER BY ISNULL(eff_end_date, '29991231')) row_num
                            FROM   scm_mst_bod_item_eng WITH (NOLOCK)
                            WHERE  modeling_id   = @p_modeling_id	
		                    AND    plan_id       = @p_plan_id		
		                    AND    plan_type     = @p_plan_type
		                    AND    plan_seq      = @p_seq
                            AND    eff_end_date   >= @p_plan_name  --eff_end_date 일까지 포함( ex) eff_end_date : 20191231 => 20191231일까지 포함됨)
                         ) ss                        
               ON   bie.bod_id = ss.bod_id
               AND  bie.item_id = ss.item_id
               AND  ss.row_num = 1  --플랜시작일(@p_plan_name)보다크고 제일작은 eff_end_date값의 safety_stock값을 사용하기 위해서 사용함
        --WHERE 1 = 1        
         ;
           
        -----------------------------------------------------------
        -- 2. INSERT
        -----------------------------------------------------------               
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD */  th_eng_item_bod_sn
		( master_id
		, plan_id
		, bod_id
		, item_id
		, alt_priority
		, alt_rate
		, transfer_lot_size
		, is_prev_lot_size
		, is_pull
		, pre_buffer_time
		, post_buffer_time
		, buffer_time_uom
		, route_selector_id
		, attribute_set_id
		, min_lot_size
		, max_lot_size
		, increment_lot_size
		, safety_stock_term
		, safety_stock_term_uom
		, safety_stock_qty
		, descr
		, from_offtime_set_id
		, to_offtime_set_id
		, early_producing_term
		, early_producing_term_uom
		, prod_priority
		)
        SELECT DISTINCT 
		      @p_master_id      AS master_id
		    , @p_engine_plan_id AS plan_id		
		    --특성CAPA관련수정시 1)PROC_BOD, 2)PROC_ITEM_BOD, 3)PROC_FIXED_PLAN, 4)PROC_PRODUCT_MIX, 5)PROC_PRODUCT_MIX_MAP 검토필요
            --20190218 수정 특성CAPA반영관련수정( 특성BOD일때(A~001 -> A~002)일때 'CHAR' + '::' + be.bod_id 로 변경) 
            , CASE WHEN x.attribute1 = 'INNER_SITE_A_002' THEN 'CHAR::' + x.bod_id --특성BOD일때
                   ELSE x.item_id + '::' + x.bod_id 
              END  AS bod_id  --20190218 수정(변경전 : , x.item_id + '::' + x.bod_id AS bod_id )		                
            , x.item_id
		    --  ksg 실제 적용 시 우선순위 어떻게할 지 정의 후 처리 필요
		    --  (20180524 수정변경전 : , ISNULL(sip.min_priority, 9900) + (be.priority*10)  AS alt_priority --20180503 수정 (변경전 : , (be.priority*10) AS alt_priority )
            --, x.alt_priority + y.min_alt_priority_transprot_time AS alt_priority --(방법1 제일작은 transport_time 그대로 붙이기)
            , x.alt_priority + (DENSE_RANK() OVER (PARTITION BY x.item_id, x.eng_to_site ORDER BY y.min_alt_priority_transprot_time )) AS alt_priority ----(방법2  transport_time numbering값 붙이기)                    
		    , 1                           AS alt_rate
		    , NULL                        AS transfer_lot_size -- -1 : 적용 안 함
		    , 'N'                         AS is_prev_lot_size
		    , 'Y'                         AS is_pull
		    , NULL                        AS pre_buffer_time
            -- 20200323 추가 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 : 도착 후 대기시간
             , x.post_buffer_time         AS post_buffer_time
            --, 0                           AS post_buffer_time		    
            , 'DAY'                       AS buffer_time_uom
		    , NULL                        AS route_selector_id
		    , NULL                        AS attribute_set_id
		    , x.min_lot_size              AS min_lot_size           -- 20180726 수정 ( 변경전 : , NULL  AS min_lot_size )
		    , NULL                        AS max_lot_size          
		    , x.increment_lot_size        AS increment_lot_size     -- 20180726  수정 ( 변경전 : , NULL  AS increment_lot_size )		    
            , x.safety_stock_term         AS safety_stock_term      --20181123 수정(변경전 : NULL   AS safety_stock_term)
		    , 'DAY'                       AS safety_stock_term_uom  --20181123 수정(변경전 : NULL AS safety_stock_term_uom)		     
            , NULL                        AS safety_stock_qty
		    , NULL                        AS descr
		    , NULL                        AS from_offtime_set_id
		    , NULL                        AS to_offtime_set_id
		    , x.early_producing_term      AS early_producing_term   -- 20180608 수정 ( 변경전 : , NULL)
		    , 'DAY'                       AS early_producing_term_uom
		    , NULL                        AS prod_priority                
        FROM #th_eng_item_bod_temp x
   --         INNER JOIN ( SELECT item_id, bod_id, transport_time AS min_alt_priority_transprot_time, eng_from_site, eng_to_site
   --                        FROM   (
   --                                 SELECT item_id, bod_id, alt_priority, eng_from_site, eng_to_site, transport_time 
   --                                     , ROW_NUMBER() OVER (PARTITION BY item_id, eng_from_site, eng_to_site ORDER BY alt_priority ) row_num
   --                                 from #th_eng_item_bod_temp                                        
   --                             ) a
   --                         WHERE  a.row_num = 1                                 
   --                     ) y  -- item_id, eng_from_site, eng_to_site 별(transport_mode N 개존재) 1순위의 transport_time 조회
   --         ON   x.eng_from_site = y.eng_from_site
   --         AND  x.eng_to_site   = y.eng_to_site 
   --         AND  x.item_id = y.item_id
			--2021.07.06 수정/보완
            INNER JOIN ( SELECT item_id
							  , bod_id
							  , transport_time AS min_alt_priority_transprot_time
							  , eng_from_site
							  , eng_to_site
							  , from_yyyymmdd
							  , to_yyyymmdd
                           FROM (
                                 SELECT item_id
									  , eng_from_site
									  , eng_to_site
									  , from_yyyymmdd
									  , to_yyyymmdd
								      , bod_id
									  , alt_priority
									  , transport_time
								      , ROW_NUMBER() OVER (PARTITION BY item_id, eng_from_site, eng_to_site, from_yyyymmdd, to_yyyymmdd ORDER BY alt_priority) row_num
                                  FROM #th_eng_item_bod_temp                                        
                                ) a
                          WHERE a.row_num = 1                                 
                        ) y
            ON   x.eng_from_site = y.eng_from_site
            AND  x.eng_to_site   = y.eng_to_site 
            AND  x.item_id       = y.item_id
			AND  x.from_yyyymmdd = y.from_yyyymmdd
			AND  x.to_yyyymmdd   = y.to_yyyymmdd			 
        ;
        -----------------------------------------------------------

		--//2021.07.06, 추가
        IF OBJECT_ID('tempdb..#th_eng_item_bod_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_item_bod_temp; 
        END  

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

