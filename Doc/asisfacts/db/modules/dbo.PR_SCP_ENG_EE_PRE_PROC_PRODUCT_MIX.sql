
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_PRODUCT_MIX
 * Description  : 
                  -------------------------------------------------
                  --1. OUTSOURCING CAPA 정보 INSERT (DAY, BUCKET 기간(PET DATE까지))
                  -------------------------------------------------
                    -1) scp_mst_outsourcing_capa.plant_site_id가 외주 SITE만 적용됨( scp_mst_outsourcing_capa테이블에 기본적으로 외주SITE 만 입력되어있음)
                    
                    -2) 컬럼값 설정 
                        -컬럼1) product_mix_id
                            - TOTAL 일때 (scp_mst_outsourcing_capa.item_id 가 '-' 일때) : scp_mst_outsourcing_capa.plant_site_id + '_' + 'TOTAL' 
                            - TOTAL 아닐때(scp_mst_outsourcing_capa.item_id 가 '-' 아닐때) : scp_mst_outsourcing_capa.plant_site_id + '_' + scp_mst_outsourcing_capa.item_id                        
                        -컬럼2) descr            : 'OSP' 셋팅  
                        -컬럼3) bucket           : 'DAY' 셋팅 
                    
                    - 참조 테이블 : scp_mst_outsourcing_capa (OUTSOURCING CAPA 정보)
                 
                  -------------------------------------------------
                  --2. OSPINSERT (WEEK, BUCKET 13주 추가기간(PET DATE이후+13주) )
                  ------------------------------------------------- 
                   -1) 위1-1) OSP, 1-2) 특성CAPA 에서 생성된 데이터에서 
                       master_id, plan_id, site_id, route_id, operation_id, product_mix_id, descr 별로 GROUP BY한 데이터 INSERT
                                          
                   -2) 컬럼값 설정  
                       -컬럼1) start_dttm : th_eng_bucket_info_sn.descr = 'ADD' 데이터중 제일작은일자
                       -컬럼2) end_dttm   : th_eng_bucket_info_sn.descr = 'ADD' 데이터중 제일큰일자 
                       -컬럼3) qty        : 9999999 셋팅
                       -컬럼4) bucket     : 'WEEK' 셋팅

 * OutTable     : TH_ENG_PRODUCT_MIX                 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.05.21   KSW         Initial Release 전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.08.07   KSG         PET 이후 13주 구간 Bucket = WEEK 로 처리
 * 2018.09.13   KSG         product_mix_id 변경 : OSP 중 동일 route_id를 가지는 다른 사이트 존재하여 Site_id로 변경
 * 2018.10.01   KSW         operation_group 조회조건 변경 ( operation_group = 'A' => 'E')
 * 2019.02.18   KSW         descr 컬럼값 변경( PROC_FIX_MISMATCHING의 "4. Production Lot Size 설정" 처리부분에서 사용하기위해서 descr값셋팅함) (참고)주석1, 주석2
 * 2019.03.05   KSW         [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2020.02.06   KSG         [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 제외
 * 2020.02.28   KSG         C20200224-000257  시스템 엔진 Logic 구현 수정 요청 : 전극 무한 Capa 반영
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

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_PRODUCT_MIX]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_PRODUCT_MIX';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_PRODUCT_MIX';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @d_pet_date          DATETIME ; -- Plan End Date

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
        
        SELECT @d_pet_date = CONVERT(DATETIME, p.horizon_end_date)
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
        ;
        
		DELETE 
		FROM   th_eng_product_mix_sn
        WHERE  plan_id   = @p_engine_plan_id
        AND    master_id = @p_master_id
		;

        -----------------------------------------------------------
		-- 1. 특정 주차 이내 DAY 기간 Bucket (OSP)
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_PRODUCT_MIX */ th_eng_product_mix_sn 
        ( master_id
        , plan_id
        , site_id
        , route_id
        , operation_id
        , product_mix_id
        , start_dttm
        , end_dttm
        , qty
        , bucket
        , descr 
        )
        SELECT @p_master_id        AS master_id
            ,  @p_engine_plan_id   AS plan_id 
            ,  b.eng_scm_site_id   AS site_id
            ,  c.route_id          AS route_id
            ,  c.route_id          AS operation_id
            -- 2018.09.13 product_mix_id 변경 : OSP 중 동일 route_id를 가지는 다른 사이트 존재하여 Site_id로 변경
            ,  b.scm_site_id + '_' + ( CASE WHEN a.item_id = '-' THEN 'TOTAL' ELSE a.item_id END ) AS product_mix_id 
            ,  @d_plan_name         AS start_dttm
            ,  DATEADD(D, 1, @d_pet_date) AS end_dttm -- 20180709 수정( 변경전 : , @d_pet_date AS end_dttm ) 
			-- C20200224-000257 전극 무한 Capa 반영
            ,  9999999999           AS qty
            --,  a.daily_capa_qty     AS qty 
            ,  'DAY'                AS bucket
            ,  'OSP'                AS descr  --20190218 수정 (변경전 : , NULL AS descr)
        FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT a.*  , di.attribute3 AS division_group , di.attribute4 AS division_comp
                FROM   scp_mst_outsourcing_capa a WITH (NOLOCK)
                     , scm_mst_division         di WITH(NOLOCK)
                WHERE  di.division_id   =  a.division_id
                AND    di.valid_yn      = 'Y'
                AND    di.attribute4    = @v_division_comp   -- 회사코드
              ) a 
        /* 20220404 변경전 
        FROM   scp_mst_outsourcing_capa a WITH (NOLOCK) */
               INNER JOIN  (SELECT scm_site_id, eng_scm_site_id 
                            FROM   scm_mst_site_eng WITH (NOLOCK) 
                            WHERE  division_id = @p_division_id 
                            AND    plan_id     = @p_plan_id 
                            AND    plan_type   = @p_plan_type 
                            AND    plan_seq    = @p_seq                           
                            AND    osp_yn      = 'Y'    --외주
                            AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'  --외주   2020.02.03 [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 제외
                            AND    operation_group = 'E' -- 전극 Plant --20181001 수정 ( 변경전 : AND    operation_group = 'A' -- cell Plant)
                        ) b
               ON   a.valid_yn     = 'Y' 
               AND  a.plant_site_id = b.scm_site_id 
               --AND  a.division_id  = @p_division_id -- 20180702 주석처리               
               
              , (SELECT DISTINCT master_id, plan_id, site_id, route_id 
                 FROM   th_eng_resource_sn WITH (NOLOCK) 
                 WHERE  master_id = @p_master_id       
                 AND    plan_id   = @p_engine_plan_id  
                ) c
        WHERE b.eng_scm_site_id = c.site_id
        AND   a.division_group  IN ( '40', '81', '82') -- 2020.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
        /* 20220404 변경전 
        AND   a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */ 
       ;

        SET @n_log_count = @@ROWCOUNT;

       -----------------------------------------------------------
		--2. 2018.07.06 13주 추가 기간 Bucket 추가
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_PRODUCT_MIX */ th_eng_product_mix_sn 
        ( master_id
        , plan_id
        , site_id
        , route_id
        , operation_id
        , product_mix_id
        , start_dttm
        , end_dttm
        , qty
        , bucket
        , descr 
        )
        SELECT a.master_id, a.plan_id, a.site_id, a.route_id, a.operation_id, a.product_mix_id
             , bi.min_bucket_info_start_dttm AS start_dttm
             , bi.max_bucket_info_end_dttm   AS end_dttm
             , 9999999999                    AS qty
             , 'WEEK'                        AS bucket
             , a.descr                       AS descr  --20190218 수정 (변경전 : , NULL AS descr)  
        FROM (
              SELECT DISTINCT master_id, plan_id, site_id, route_id, operation_id, product_mix_id
                            , descr  --20190218 추가
              FROM   TH_ENG_PRODUCT_MIX_sn
              WHERE  1=1
              AND    MASTER_ID = @p_master_id
              AND    PLAN_ID   = @p_engine_plan_id
             ) a
             LEFT JOIN ( SELECT  @p_master_id                    AS master_id 
                               , @p_engine_plan_id               AS plan_id 
                               , MIN(start_dttm)                 AS min_bucket_info_start_dttm
                               , MAX(end_dttm)                   AS max_bucket_info_end_dttm
                         FROM   th_eng_bucket_info_sn   WITH(NOLOCK)
                         WHERE  master_id = @p_master_id --'81::WEEKLY'
                         AND    plan_id   = @p_engine_plan_id --'1016::PR::23'
                         AND    descr     = 'ADD'  -- 2018.07.06 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
                       ) bi
             ON   a.master_id = bi.master_id
             AND  a.plan_id   = bi.plan_id
        ;

        -----------------------------------------------------------		

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        --SET @n_log_count = @@ROWCOUNT + @n_log_count;
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


