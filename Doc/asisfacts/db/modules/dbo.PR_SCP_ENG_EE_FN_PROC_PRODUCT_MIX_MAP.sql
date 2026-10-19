
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_PRODUCT_MIX_MAP
 * Description  : 
                  -------------------------------------------------
                  --1. OUTSOURCING CAPA 정보 INSERT
                  -------------------------------------------------
                    -1) scp_mst_outsourcing_capa.plant_site_id가 외주 SITE만 적용됨( scp_mst_outsourcing_capa테이블에 기본적으로 외주SITE 만 입력되어있음)
                    
                    -2) 컬럼값 설정 
                        -컬럼1) product_mix_id
                            - TOTAL 일때 (scp_mst_outsourcing_capa.item_id 가 '-' 일때) : scp_mst_outsourcing_capa.plant_site_id + '_' + 'TOTAL' 
                               ==> plant_site_id 별 전체item 개수만큼 데이터 생성됨( ex) plant_site_id가 'KR013131_81-P'인 item이 10개 존재시 => product_mix_id가 'KR013131_81-P_TOTAL' 인 10개의 데이터가 생성됨)
                            - TOTAL 아닐때(scp_mst_outsourcing_capa.item_id 가 '-' 아닐때) : scp_mst_outsourcing_capa.plant_site_id + '_' + scp_mst_outsourcing_capa.item_id                        
                        -컬럼2) descr : 'OSP' 셋팅  
                        -컬럼3) product_mix_rate : 1 로 셋팅                     
                    
                    - 참조 테이블 : scp_mst_outsourcing_capa (OUTSOURCING CAPA 정보)

 * OutTable     : TH_ENG_PRODUCT_MIX_MAP
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.05.21   KSW         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.09.13   KSG         product_mix_id 변경 : OSP 중 동일 route_id를 가지는 다른 사이트 존재하여 Site_id로 변경
 * 2018.10.01   KSW         operation_group 조회조건 변경 ( operation_group = 'A' => 'E')
 * 2019.02.18   KSW         descr 컬럼값 변경 (참고)주석1
 * 2019.03.05   KSW         [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2020.02.06   KSG         [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 제외
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

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_PRODUCT_MIX_MAP]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_PRODUCT_MIX_MAP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_PRODUCT_MIX_MAP';
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
        
        SELECT @d_pet_date = CONVERT(DATETIME, p.horizon_end_date)
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
        ;
        
		DELETE 
		FROM   th_eng_product_mix_map_sn
        WHERE plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
		;
        
        -----------------------------------------------------------
        --1. OSP
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_PRODUCT_MIX_MAP */ th_eng_product_mix_map_sn 
        ( master_id
        , plan_id
        , site_id
        , route_id
        , operation_id
        , product_mix_id
        , item_id
        , descr
        , product_mix_rate
        )
        SELECT @p_master_id        AS master_id
            ,  @p_engine_plan_id   AS plan_id 
            ,  b.eng_scm_site_id   AS site_id
            ,  c.route_id          AS route_id
            ,  c.route_id          AS operation_id
            -- 2018.09.13 product_mix_id 변경 : OSP 중 동일 route_id를 가지는 다른 사이트 존재하여 Site_id로 변경
            ,  b.scm_site_id + '_' + ( CASE WHEN a.item_id = '-' THEN 'TOTAL' ELSE a.item_id END ) AS product_mix_id 
            --,  c.route_id + '_' + ( CASE WHEN a.item_id = '-' THEN 'TOTAL' ELSE a.item_id END ) AS product_mix_id 
            ,  CASE WHEN a.item_id = '-' THEN  a.item_id2
                    ELSE a.item_id 
               END AS item_id  
            ,  'OSP'                AS descr --20190218 수정 (변경전 : , NULL AS descr)
            ,  1                    AS product_mix_rate
        FROM   (  --union all 1)TOTAL 아닐떄(=item_id 가 '-' 아닐때)
                 SELECT a.division_id, a.plant_site_id, a.item_id, NULL item_id2
                 FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                        SELECT a.*  , di.attribute3 AS division_group , di.attribute4 AS division_comp
                        FROM   scp_mst_outsourcing_capa a WITH (NOLOCK)
                             , scm_mst_division         di WITH(NOLOCK)
                        WHERE  di.division_id   =  a.division_id
                        AND    di.valid_yn      = 'Y'
                        AND    di.attribute4    = @v_division_comp
                       ) a
                 WHERE  a.valid_yn   = 'Y'
                 AND    a.item_id    <> '-'
                 AND    a.division_group  IN ( '40', '81', '82')  --2022.04.04컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
        
                 /* 20220404 변경전 
                 SELECT a.division_id, a.plant_site_id, a.item_id, NULL item_id2
                 FROM   scp_mst_outsourcing_capa a WITH (NOLOCK)
                 WHERE  a.valid_yn   = 'Y'
                 AND    a.item_id    <> '-'
                 --AND    a.division_id  = @p_division_id  -- 20180709 주석처리
                 AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                 */

                 UNION ALL 

                 --union all 1)TOTAL 일때(=item_id 가 '-' 일때) 
                 --            - plant_site_id별 전체item개수 만큼 TOTAL 데이터 생성
                 SELECT a.division_id, a.plant_site_id, a.item_id, b.item_id AS item_id2

                 FROM  (-- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                        SELECT a.*  , di.attribute3 AS division_group , di.attribute4 AS division_comp
                        FROM   scp_mst_outsourcing_capa a WITH (NOLOCK)
                             , scm_mst_division         di WITH(NOLOCK)
                        WHERE  di.division_id   =  a.division_id
                        AND    di.valid_yn      = 'Y'
                        AND    di.attribute4    = @v_division_comp
                       ) a
                      ,(-- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                        SELECT a.*  , di.attribute3 AS division_group , di.attribute4 AS division_comp
                        FROM   scp_mst_outsourcing_capa a WITH (NOLOCK)
                             , scm_mst_division         di WITH(NOLOCK)
                        WHERE  di.division_id   =  a.division_id
                        AND    di.valid_yn      = 'Y'
                        AND    di.attribute4    = @v_division_comp
                       ) b
                 WHERE  a.valid_yn   = 'Y'
                 AND    a.division_id  = b.division_id 
                 AND    a.plant_site_id = b.plant_site_id 
                 AND    a.item_id    = '-'
                 AND    b.item_id    <> '-'
                 AND    b.valid_yn   = 'Y'
                 AND    a.division_group  IN ( '40', '81', '82')  --2022.04.04컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
                 AND    b.division_group  IN ( '40', '81', '82')  --2022.04.04컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                 
                 /* 20220404 변경전 
                 FROM   scp_mst_outsourcing_capa a WITH (NOLOCK)
                      , scp_mst_outsourcing_capa b WITH (NOLOCK)
                 WHERE  a.valid_yn   = 'Y'
                 AND    a.division_id  = b.division_id 
                 AND    a.plant_site_id = b.plant_site_id 
                 AND    a.item_id    = '-'
                 AND    b.item_id    <> '-'
                 AND    b.valid_yn   = 'Y'
                 --AND    a.division_id  = @p_division_id -- 20180709 주석처리
                 AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
                 AND    b.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                 */
               ) a

               INNER JOIN  (SELECT scm_site_id, eng_scm_site_id 
                            FROM   scm_mst_site_eng WITH (NOLOCK) 
                            WHERE  division_id = @p_division_id 
                            AND    plan_id     = @p_plan_id 
                            AND    plan_type   = @p_plan_type 
                            AND    plan_seq    = @p_seq                           
                            AND    osp_yn      = 'Y'    --외주 
                            AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'  --  2020.02.03 [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 제외
                            AND    operation_group = 'E' -- 전극 Plant --20181001 수정 ( 변경전 : AND    operation_group = 'A' -- cell Plant)
                        ) b
               ON   a.plant_site_id = b.scm_site_id                
              
              , (SELECT DISTINCT master_id, plan_id, site_id, route_id                                         
                             FROM   th_eng_resource_sn WITH (NOLOCK) 
                             WHERE  master_id = @p_master_id        
                             AND    plan_id   = @p_engine_plan_id   
                 ) c
        WHERE b.eng_scm_site_id = c.site_id 
        ORDER BY site_id, product_mix_id desc
       ;

        -----------------------------------------------------------

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


