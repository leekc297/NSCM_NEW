
/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_RESOURCE
 * Description  : ODB의 BOM정보에서 ODB의RESOURCE 정보를 적재되도록 한다.
                  
                  -----------------------------------------------------------
                  -- 1.1 Capa 비대상 + OSP(Outspurcing Capa)
                  -----------------------------------------------------------  
                     -1) Capa 비대상 공정 ( route_id가  Capa 대상 공정'이 아닐때)
                     - 참고 컬럼1) resource_id(=resource_group_id)  : route_id + '::' + site_id  + '::' + '-'
                  
                  -----------------------------------------------------------
                  -- 1.2 OSP(Line Capa)
                  -----------------------------------------------------------  
                     -1) OSP(Line Capa) 공정
                     - 참고 컬럼1) resource_id(=resource_group_id) :  operation_id + '::' + site_id + '::' + line_id   

                  -----------------------------------------------------------
                  -- 2. Capa 대상 + Line Modeling 비대상 공정
                  -----------------------------------------------------------
                     -1) 라인 MODELING 비대상 공정 ( route_id가 Capa대상이면서 Line Capa 대상 공정'이 아닐때)
                     - 참고 컬럼1) resource_id(=resource_group_id)  : route_id + '::' + site_id  + '::' + '-'

                  -----------------------------------------------------------
                  -- 3. Capa 대상 + Line Modeling 대상 공정
                  -----------------------------------------------------------
                     -1) 라인 MODELING 대상 공정(route_id가 Line Capa 대상 공정' 일때)
                     - 참고 컬럼1) resource_id(=resource_group_id) :  operation_id + '::' + site_id + '::' + line_id
                                                            
                  -----------------------------------------------------------
                  -- 4. JIG 대상
                  -----------------------------------------------------------                      
                      - 참고 컬럼1) resource_id(=resource_group_id) : scp_mst_jig.operation_id + '::' + scp_mst_jig.scm_site_id + '~***' +  '::' + scp_mst_jig.jig_seq
                      - 참고 컬럼2) resource_type : 'SUB'
                      - 참고 컬럼3) fixed_term    : 0
                      - 참고 컬럼4) descr         : 'JIG

                      - 참고 테이블1) SCP_MST_JIG	     (JIG 기준정보)				
	                  - 참고 테이블2) SCP_MST_JIG_ITEM	 (JIG item 기준정보)
                  
                  참고1)   - Line Capa 대상 공정 조회
                            SELECT b.segment2 AS route_id -- Line Capa 대상 route_id(=flow_id)
                            FROM   scm_adm_lookup_master_detail a
                            INNER JOIN scm_adm_lookup_master_detail b
                            ON  a.segment1= b.segment1
                            AND a.lookup_type = 'LOCATION_GROUP'
                            AND a.segment4    = 'Y' -- Capa 공정 여부 
                            AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                            AND a.valid_yn    = 'Y'
                            AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                            AND b.valid_yn    = 'Y'
                            AND b.segment3    = 'Y' -- Capa 세부 공정 여부                  

 * OutTable     : TH_ENG_RESOURCE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.15   KSW            전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.31   KSG            Product Mix 사용에 따른 OSP 정보 수정
 * 2018.07.18   KSW            CAPA비대상 is_finite = 'Y'로  변경(티라요청)
 * 2018.10.31   KSW            JIG 추가 관련수정 (참고)주석4
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
 * 2020.11.02   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2022.06.24   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 소형(40) P5000 공정 isuzu 모델링 추가
 * 2023.07.07   SHS			   PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 Dummy 설비 추가
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_RESOURCE]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_RESOURCE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_RESOURCE';
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
	 
		DELETE /* PR_SCP_ENG_IN_FN_PROC_RESOURCE */ 
		FROM  dbo.th_eng_resource_sn 
		WHERE master_id = @p_master_id 
        AND   plan_id   = @p_engine_plan_id 
		;		
        
        -----------------------------------------------------------
        -- 1.1 Capa 비대상 + OSP(Outspurcing Capa)
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_RESOURCE */ th_eng_resource_sn
		(      master_id, plan_id, resource_id, resource_type, site_id, route_id, location_id
			 , multi_port_count, utilization, batch_type, is_exception, is_finite, is_dummy
			 , offtime_set_id, attribute_set_id, attribute_checker_id, inline_group_id
			 , resource_group_id, resource_setup_group_id, batch_res_group_id
			 , max_setup_count, rampup_rate, rampup_term, rampup_uom --rampup_term_uom
			 , fixed_term, fixed_term_uom, ncp_term, ncp_term_uom, descr
		)
		SELECT DISTINCT 
			   @p_master_id                              AS master_id
			 , @p_engine_plan_id                         AS plan_id
			 , a.route_id + '::' + a.site_id + '::-'     AS resource_id -- resource_group_id / Op Res Group Map 의resource_group_id 와 동일
		     , 'MAIN'                                    AS resource_type
			 , a.site_id                                 AS site_id
			 , a.route_id                                AS route_id
			 , NULL                                      AS location_id
			 , 1                                         AS multi_port_count
			 , 1                                         AS utilization
			 , NULL                                      AS batch_type
			 , 'N'                                       AS is_exception
			 
			 , 'Y'                                       AS is_finite -- 20180718 티라요청으로 수정
             --, CASE WHEN b.osp_yn = 'Y' THEN 'Y'  -- OSP : 20180531 Product Mix 적용시 Y 처리
             --       ELSE 'N'                      -- Capa 비대상 
             --  END                                       AS is_finite

			 , 'N'                                       AS is_dummy
			 , NULL                                      AS offtime_set_id
			 , NULL                                      AS attribute_set_id
			 , NULL                                      AS attribute_checker_id
			 , NULL                                      AS inline_group_id
			 , a.route_id + '::' + a.site_id + '::-'     AS resource_group_id   -- resource_id / Op Res Group Map 의resource_group_id 와 동일
			 , NULL                                      AS resource_setup_group_id
			 , NULL                                      AS batch_res_group_id
			 , -1                                        AS max_setup_count
			 , NULL                                      AS rampup_rate
			 , NULL                                      AS rampup_term
			 , 'HOUR'                                    AS rampup_uom --rampup_term_uom
             -- Capa 비대상 공정은 0 처리
             , CASE WHEN b.osp_yn = 'Y' THEN b.prod_frozen -- OSP
                    ELSE 0                                 -- Capa 비대상 
               END                                       AS fixed_term
			 , 'DAY'                                     AS fixed_term_uom
			 , 0                                         AS ncp_term
			 , 'DAY'                                     AS ncp_term_uom
			 --, 'NO_CAPA'                                 AS descr  -- Capa 비대상 
             , CASE WHEN b.osp_yn = 'Y' THEN 'OSP' -- OSP
                    ELSE 'NO_CAPA'                 -- Capa 비대상 
               END AS descr
        FROM   dbo.th_eng_plan_bom_sn a WITH(NOLOCK)
             -- 2020.02.03 [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 는 제외
             ,(SELECT *
               FROM   dbo.scm_mst_site_eng  WITH(NOLOCK)
               WHERE  osp_yn = 'N' 
               OR    (osp_yn = 'Y' AND DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N' )
              )  b 
             --, dbo.scm_mst_site_eng   b WITH(NOLOCK)
        WHERE  a.master_id   = @p_master_id 
        AND    a.plan_id     = @p_engine_plan_id
        AND    b.modeling_id = @p_modeling_id
        AND    b.plan_id     = @p_plan_id
        AND    b.plan_seq    = @p_seq
        AND    b.plan_type   = @p_plan_type
        AND    a.site_id     = b.eng_scm_site_id
        
        -- Capa 비대상
        AND    a.route_id NOT IN ( 
                                   SELECT b.segment2
                                   FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
                                   INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                                   ON  a.segment1= b.segment1
                                   AND a.lookup_type = 'LOCATION_GROUP'
                                   AND a.segment4    = 'Y' -- Capa 공정 여부 
                                 --  AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                                   AND a.valid_yn    = 'Y'
                                   AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                   AND b.valid_yn    = 'Y'
                                   AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
                                 )
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '1.1 NO_CAPA/OSP';
        SET @v_description = 'Insert NO_CAPA/OSP.' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 1.2 OSP(Line Capa) : 2020.02.03 [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_RESOURCE */ th_eng_resource_sn
		(      master_id, plan_id, resource_id, resource_type, site_id, route_id, location_id
			 , multi_port_count, utilization, batch_type, is_exception, is_finite, is_dummy
			 , offtime_set_id, attribute_set_id, attribute_checker_id, inline_group_id
			 , resource_group_id, resource_setup_group_id, batch_res_group_id
			 , max_setup_count, rampup_rate, rampup_term, rampup_uom --rampup_term_uom
			 , fixed_term, fixed_term_uom, ncp_term, ncp_term_uom, descr
		)
		SELECT DISTINCT 
			   @p_master_id                              AS master_id
			 , @p_engine_plan_id                         AS plan_id
			 , c.operation_id + '::' + a.site_id + '::' + c.line_id AS resource_id -- resource_group_id / Op Res Group Map 의resource_group_id 와 동일
		     , 'MAIN'                                    AS resource_type
			 , a.site_id                                 AS site_id
			 , c.operation_id                            AS route_id
			 , NULL                                      AS location_id
			 , 1                                         AS multi_port_count
			 , 1                                         AS utilization
			 , NULL                                      AS batch_type
             , 'N'                                       AS is_exception
             
			 , 'Y'                                       AS is_finite 
             , 'N'                                       AS is_dummy
			 , NULL                                      AS offtime_set_id
			 , NULL                                      AS attribute_set_id
			 , NULL                                      AS attribute_checker_id
			 , NULL                                      AS inline_group_id
			 , c.operation_id + '::' + a.site_id + '::' + c.line_id AS resource_group_id   -- resource_id / Op Res Group Map 의resource_group_id 와 동일
			 , NULL                                      AS resource_setup_group_id
			 , NULL                                      AS batch_res_group_id
			 , -1                                        AS max_setup_count
			 , NULL                                      AS rampup_rate
			 , NULL                                      AS rampup_term
			 , 'HOUR'                                    AS rampup_uom --rampup_term_uom

             , b.prod_frozen                             AS fixed_term -- Capa 비대상 공정은 0
			 , 'DAY'                                     AS fixed_term_uom
			 , 0                                         AS ncp_term    -- Capa 비대상 공정은 0
			 , 'DAY'                                     AS ncp_term_uom

			 , 'OSP_L'                                   AS descr  -- Capa 대상 + Line Modeling 대상 공정
        FROM   dbo.th_eng_plan_bom_sn a WITH(NOLOCK)
             ,(SELECT *
               FROM   dbo.scm_mst_site_eng  WITH(NOLOCK)
               WHERE  osp_yn                              = 'Y' 
               AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'Y'  --  OSP이면서 Line별 Capa 적용 Site
              )   b
             ,(SELECT scm_site_id + '~***' AS eng_scm_site_id
                    , ln.*
               FROM   dbo.scm_mst_line_osp           ln WITH(NOLOCK)
               WHERE  ln.division_id = @p_division_id
               AND    ln.valid_yn    = 'Y' 
              )  c 
        WHERE  a.master_id   = @p_master_id 
        AND    a.plan_id     = @p_engine_plan_id
        AND    b.modeling_id = @p_modeling_id
        AND    b.plan_id     = @p_plan_id
        AND    b.plan_seq    = @p_seq
        AND    b.plan_type   = @p_plan_type
        AND    a.site_id     = b.eng_scm_site_id
        AND    a.site_id     = c.eng_scm_sitE_id
        AND    a.route_id    = c.operation_id  -- 20201102 PJ20202001
        --AND    a.route_id    LIKE c.operation_id + '%'
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '1.2 OSP_L';
        SET @v_description = 'Insert OSP_L.' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 2.  Capa 대상 + Line Modeling 비대상 공정
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_RESOURCE */ th_eng_resource_sn
		(      master_id, plan_id, resource_id, resource_type, site_id, route_id, location_id
			 , multi_port_count, utilization, batch_type, is_exception, is_finite, is_dummy
			 , offtime_set_id, attribute_set_id, attribute_checker_id, inline_group_id
			 , resource_group_id, resource_setup_group_id, batch_res_group_id
			 , max_setup_count, rampup_rate, rampup_term, rampup_uom --rampup_term_uom
			 , fixed_term, fixed_term_uom, ncp_term, ncp_term_uom, descr
		)
		SELECT DISTINCT 
			   @p_master_id                              AS master_id
			 , @p_engine_plan_id                         AS plan_id
			 , a.route_id + '::' + a.site_id + '::-'     AS resource_id -- resource_group_id / Op Res Group Map 의resource_group_id 와 동일
		     , 'MAIN'                                    AS resource_type
			 , a.site_id                                 AS site_id
			 , a.route_id                                AS route_id
			 , NULL                                      AS location_id
			 , 1                                         AS multi_port_count
			 , 1                                         AS utilization
			 , NULL                                      AS batch_type
			 , 'N'                                       AS is_exception
             
			 , 'Y'                                       AS is_finite 
			 , 'N'                                       AS is_dummy
			 , NULL                                      AS offtime_set_id
			 , NULL                                      AS attribute_set_id
			 , NULL                                      AS attribute_checker_id
			 , NULL                                      AS inline_group_id
			 , a.route_id + '::' + a.site_id + '::-'     AS resource_group_id   -- resource_id / Op Res Group Map 의resource_group_id 와 동일
			 , NULL                                      AS resource_setup_group_id
			 , NULL                                      AS batch_res_group_id
			 , -1                                        AS max_setup_count
			 , NULL                                      AS rampup_rate
			 , NULL                                      AS rampup_term
			 , 'HOUR'                                    AS rampup_uom --rampup_term_uom

             , b.prod_frozen                             AS fixed_term -- Capa 비대상 공정은 0
			 , 'DAY'                                     AS fixed_term_uom
			 , 0                                         AS ncp_term    -- Capa 비대상 공정은 0
			 , 'DAY'                                     AS ncp_term_uom

             --, 0                                         AS fixed_term -- Capa 비대상 공정은 0
			 --, 'DAY'                                     AS fixed_term_uom
			 --, b.prod_frozen                             AS ncp_term    -- Capa 비대상 공정은 0
			 --, 'DAY'                                     AS ncp_term_uom

			 , 'CAPA'                                    AS descr -- Capa 대상 + Line Modeling 비대상 공정
        FROM   dbo.th_eng_plan_bom_sn a WITH(NOLOCK)
             , dbo.scm_mst_site_eng   b WITH(NOLOCK)
        WHERE  a.master_id   = @p_master_id 
        AND    a.plan_id     = @p_engine_plan_id
        AND    b.modeling_id = @p_modeling_id
        AND    b.plan_id     = @p_plan_id
        AND    b.plan_seq    = @p_seq
        AND    b.plan_type   = @p_plan_type
        AND    a.site_id     = b.eng_scm_site_id
        
        -- Capa 대상 + Line Modeling 비대상 공정
        AND    a.route_id IN ( 
                              SELECT b.segment2
                              FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
                              INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                              ON  a.segment1= b.segment1
                              AND a.lookup_type = 'LOCATION_GROUP'
                              AND a.segment4    = 'Y' -- Capa 공정 여부 
                              AND a.segment5    = 'N' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                              AND a.valid_yn    = 'Y'
                              AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                              AND b.valid_yn    = 'Y'
                              AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
                             )
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '2 CAPA';
        SET @v_description = 'Insert CAPA.' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -----------------------------------------------------------
        -- 3. Capa 대상 + Line Modeling 대상 공정
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_RESOURCE */ th_eng_resource_sn
		(      master_id, plan_id, resource_id, resource_type, site_id, route_id, location_id
			 , multi_port_count, utilization, batch_type, is_exception, is_finite, is_dummy
			 , offtime_set_id, attribute_set_id, attribute_checker_id, inline_group_id
			 , resource_group_id, resource_setup_group_id, batch_res_group_id
			 , max_setup_count, rampup_rate, rampup_term, rampup_uom --rampup_term_uom
			 , fixed_term, fixed_term_uom, ncp_term, ncp_term_uom, descr
		)
		SELECT DISTINCT 
			   @p_master_id                              AS master_id
			 , @p_engine_plan_id                         AS plan_id
			-- , a.route_id + '::' + a.site_id + '::' + c.line_id AS resource_id -- resource_group_id / Op Res Group Map 의resource_group_id 와 동일
			 , c.operation_id + '::' + a.site_id + '::' + c.line_id AS resource_id -- resource_group_id / Op Res Group Map 의resource_group_id 와 동일
		     , 'MAIN'                                    AS resource_type
			 , a.site_id                                 AS site_id
			-- , a.route_id                                AS route_id
			 , c.operation_id                            AS route_id
			 , NULL                                      AS location_id
			 , 1                                         AS multi_port_count
			 , 1                                         AS utilization
			 , NULL                                      AS batch_type
             , 'N'                                       AS is_exception
             
			 , 'Y'                                       AS is_finite 
             , 'N'                                       AS is_dummy
			 , NULL                                      AS offtime_set_id
			 , NULL                                      AS attribute_set_id
			 , NULL                                      AS attribute_checker_id
			 , NULL                                      AS inline_group_id
			-- , a.route_id + '::' + a.site_id + '::' + c.line_id AS resource_group_id   -- resource_id / Op Res Group Map 의resource_group_id 와 동일
			 , c.operation_id + '::' + a.site_id + '::' + c.line_id AS resource_group_id   -- resource_id / Op Res Group Map 의resource_group_id 와 동일
			 , NULL                                      AS resource_setup_group_id
			 , NULL                                      AS batch_res_group_id
			 , -1                                        AS max_setup_count
			 , NULL                                      AS rampup_rate
			 , NULL                                      AS rampup_term
			 , 'HOUR'                                    AS rampup_uom --rampup_term_uom

             , b.prod_frozen                             AS fixed_term -- Capa 비대상 공정은 0
			 , 'DAY'                                     AS fixed_term_uom
			 , 0                                         AS ncp_term    -- Capa 비대상 공정은 0
			 , 'DAY'                                     AS ncp_term_uom

             --, 0                                         AS fixed_term -- Capa 비대상 공정은 0
			 --, 'DAY'                                     AS fixed_term_uom
			 --, b.prod_frozen                             AS ncp_term    -- Capa 비대상 공정은 0
			 --, 'DAY'                                     AS ncp_term_uom

			 , 'LINE_CAPA'                               AS descr  -- Capa 대상 + Line Modeling 대상 공정
        FROM   dbo.th_eng_plan_bom_sn a WITH(NOLOCK)
             , dbo.scm_mst_site_eng   b WITH(NOLOCK)
             ,(SELECT CASE WHEN SUBSTRING(ln.operation_id, 1, 1) = 'E' THEN ln.plant_id + '-E~***'
                           WHEN SUBSTRING(ln.operation_id, 1, 1) = 'S' THEN ln.plant_id + '-E~***' -- SRS => 전극
                           WHEN SUBSTRING(ln.operation_id, 1, 1) = 'A' THEN ln.plant_id + '-A~***'
                           WHEN SUBSTRING(ln.operation_id, 1, 1) = 'F' THEN ln.plant_id + '-A~***' -- 활성화 => CELL
                           WHEN SUBSTRING(ln.operation_id, 1, 1) = 'P' THEN ln.plant_id + '-P~***'
                      END  AS eng_scm_site_id
                  --  , op.flow_id
                    , ln.*
               FROM   dbo.scm_mst_line_sn           ln WITH(NOLOCK)
                  --  , dbo.scm_mst_operation_flow_v  op WITH(NOLOCK) --20180306 view로 변경 (변경전 : , dbo.scm_mst_operation_flow_sn op WITH(NOLOCK) )
               WHERE  ln.division_id  = @p_division_id
               --AND    ln.division_id  = op.division_id
               --AND    ln.company_id   = op.company_id
               --AND    ln.site_id      = op.site_id
               --AND    ln.operation_id = op.operation_id
               --AND    op.valid_yn     = 'Y' --20180306 추가

               -- Capa 대상 + Line Modeling 대상 공정
              -- AND    op.flow_id IN ( 
               AND    ln.active_flag = 'Y' 
               AND    ln.operation_id IN ( 
                                     SELECT DISTINCT b.segment4
                                     FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
                                     INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                                     ON  a.segment1    = b.segment1
                                     AND a.lookup_type = 'LOCATION_GROUP'
                                     AND a.segment4    = 'Y' -- Capa 공정 여부 
                                     AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                                     AND a.valid_yn    = 'Y'
                                     AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                     AND b.valid_yn    = 'Y'
                                     AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
                                    )

              )  c 
        WHERE  a.master_id   = @p_master_id 
        AND    a.plan_id     = @p_engine_plan_id
        AND    b.modeling_id = @p_modeling_id
        AND    b.plan_id     = @p_plan_id
        AND    b.plan_seq    = @p_seq
        AND    b.plan_type   = @p_plan_type
        AND    a.site_id     = b.eng_scm_site_id
        AND    a.site_id     = c.eng_scm_sitE_id
       -- AND    a.route_id    = c.flow_id
        AND    a.route_id    LIKE c.operation_id + '%'
        -- Capa 대상 + Line Modeling 대상 공정
        AND    a.route_id  IN ( 
                                SELECT b.segment2
                                FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
                                INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                                ON  a.segment1    = b.segment1
                                AND a.lookup_type = 'LOCATION_GROUP'
                                AND a.segment4    = 'Y' -- Capa 공정 여부 
                                AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                                AND a.valid_yn    = 'Y'
                                AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                AND b.valid_yn    = 'Y'
                                AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
                               )
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '3.1 LINE_CAPA';
        SET @v_description = 'Insert LINE_CAPA.' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        ---------------------------------------------------------------------------------------------------------------------
        -- 3.2 ISUZU(P5000) + Capa 대상 + Line Modeling 대상 공정  (2022.06.24) 
        -- lookup에 등록한 (DIVISION, SITE, PLANT, ROUTE) 동일 조건의 설비는 line_capa 로, 그 외는 기존처럼 no_capa 라인으로 설정
        -- 3.2-1: 추가할 공정의 기등록 설비 데이터 삭제
        -- 3.2-2: 추가할 공정의 line_capa 설비 등록 
        ---------------------------------------------------------------------------------------------------------------------
        
        /* 3.2-1 특정 추가공정 기등록 데이터 삭제 (중복방지) : (DIVISION, SITE, PLANT, ROUTE) 동일 조건 확인  */
        DELETE a
        FROM   dbo.th_eng_resource_sn  a WITH(NOLOCK)       
        INNER JOIN (   
                    SELECT 
                          a.division_id
                        , a.site_id
                        , a.plant_id
                        , a.op_id
                        , b.eng_scm_site_id 
                    FROM  ( --~ ISUZU CAPA공정 추가정의 
                            SELECT b.segment1 AS division_id 
                                , b.segment2  AS site_id 
                                , b.segment3  AS plant_id
                                , b.segment4  AS op_id 
                            FROM  scm_adm_lookup_master        A WITH(NOLOCK) 
                                , scm_adm_lookup_master_detail B WITH(NOLOCK) 
                            WHERE a.lookup_type = b.lookup_type 
                            AND   a.lookup_type = 'ADD_LINE_CAPA_ROUTE'  
                            AND   a.valid_yn    = 'Y' 
                            AND   b.valid_yn    = 'Y' 
                            AND   b.segment1    = @p_division_id
                            ) a 
                        , ( SELECT * 
                            FROM  scm_mst_site_eng   b WITH(NOLOCK)
                            WHERE 1=1
                            AND   b.modeling_id = @p_modeling_id  
                            AND   b.plan_id     = @p_plan_id
                            AND   b.plan_type   = @p_plan_type
                            AND   b.plan_seq    = @p_seq
                            AND   b.division_id = @p_division_id
                            ) B
                    WHERE 1=1
                    AND   a.plant_id    = b.plant_id  
                    AND   a.division_id = b.division_id 
                    AND   a.site_id     = b.site_id 
                    ) d
                ON ( 1=1
                AND  a.site_id   = d.eng_scm_site_id
                AND  a.route_id  = d.op_id ) 
        WHERE  a.master_id   = @p_master_id 
        AND    a.plan_id     = @p_engine_plan_id      
        AND    a.route_id  NOT IN ( 
                                    SELECT DISTINCT b.segment4
                                    FROM   scm_adm_lookup_master_detail     a WITH(NOLOCK)
                                    INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                                    ON  a.segment1    = b.segment1
                                    AND a.lookup_type = 'LOCATION_GROUP'
                                    AND a.segment4    = 'Y' -- Capa 공정 여부 
                                    AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                                    AND a.valid_yn    = 'Y'
                                    AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                    AND b.valid_yn    = 'Y'
                                    AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
                                )  
         ; 

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '3.2-1 LINE_CAPA';
        SET @v_description = 'Delete Add-Route Resource ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    

        /*~ 3.2-2 특정 추가공정의 설비정보 등록 (DIVISION, SITE, PLANT, ROUTE) 동일 조건 확인  ~*/
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_RESOURCE */ th_eng_resource_sn
		(      master_id, plan_id, resource_id, resource_type, site_id, route_id, location_id
			 , multi_port_count, utilization, batch_type, is_exception, is_finite, is_dummy
			 , offtime_set_id, attribute_set_id, attribute_checker_id, inline_group_id
			 , resource_group_id, resource_setup_group_id, batch_res_group_id
			 , max_setup_count, rampup_rate, rampup_term, rampup_uom --rampup_term_uom
			 , fixed_term, fixed_term_uom, ncp_term, ncp_term_uom, descr
		)
        SELECT DISTINCT 
			   @p_master_id                              AS master_id
			 , @p_engine_plan_id                         AS plan_id
			 , c.operation_id + '::' + a.site_id + '::' + c.line_id AS resource_id -- resource_group_id / Op Res Group Map 의resource_group_id 와 동일
		     , 'MAIN'                                    AS resource_type
			 , a.site_id                                 AS site_id
			 , c.operation_id                            AS route_id
			 , NULL                                      AS location_id
			 , 1                                         AS multi_port_count
			 , 1                                         AS utilization
			 , NULL                                      AS batch_type
             , 'N'                                       AS is_exception
             
			 , 'Y'                                       AS is_finite 
             , 'N'                                       AS is_dummy
			 , NULL                                      AS offtime_set_id
			 , NULL                                      AS attribute_set_id
			 , NULL                                      AS attribute_checker_id
			 , NULL                                      AS inline_group_id
			 , c.operation_id + '::' + a.site_id + '::' + c.line_id AS resource_group_id   -- resource_id / Op Res Group Map 의resource_group_id 와 동일
			 , NULL                                      AS resource_setup_group_id
			 , NULL                                      AS batch_res_group_id
			 , -1                                        AS max_setup_count
			 , NULL                                      AS rampup_rate
			 , NULL                                      AS rampup_term
			 , 'HOUR'                                    AS rampup_uom --rampup_term_uom

             , b.prod_frozen                             AS fixed_term -- Capa 비대상 공정은 0
			 , 'DAY'                                     AS fixed_term_uom
			 , 0                                         AS ncp_term    -- Capa 비대상 공정은 0
			 , 'DAY'                                     AS ncp_term_uom
			 , 'LINE_CAPA'                               AS descr  -- Capa 대상 + Line Modeling 대상 공정
        FROM   dbo.th_eng_plan_bom_sn a WITH(NOLOCK)
             , dbo.scm_mst_site_eng   b WITH(NOLOCK)
             ,(SELECT CASE WHEN SUBSTRING(ln.operation_id, 1, 1) = 'E' THEN ln.plant_id + '-E~***'
                           WHEN SUBSTRING(ln.operation_id, 1, 1) = 'S' THEN ln.plant_id + '-E~***' -- SRS => 전극
                           WHEN SUBSTRING(ln.operation_id, 1, 1) = 'A' THEN ln.plant_id + '-A~***'
                           WHEN SUBSTRING(ln.operation_id, 1, 1) = 'F' THEN ln.plant_id + '-A~***' -- 활성화 => CELL
                           WHEN SUBSTRING(ln.operation_id, 1, 1) = 'P' THEN ln.plant_id + '-P~***'
                      END  AS eng_scm_site_id
                    , ln.*
               FROM   dbo.scm_mst_line_sn           ln WITH(NOLOCK)
               WHERE  ln.division_id  = @p_division_id
               AND    ln.active_flag  = 'Y' 
                /*~ 위에서 등록한 [Capa 대상 + Line Modeling 대상]이 아닌 것 중에서 특정 조건에 해당하는 추가공정을 line capa 대상으로 정의함. ~*/ 
               AND    ln.operation_id NOT IN (  --~ [Capa 대상 + Line Modeling 대상]이 아닌 것 검색 
                                     SELECT DISTINCT b.segment4
                                     FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
                                     INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                                     ON  a.segment1    = b.segment1
                                     AND a.lookup_type = 'LOCATION_GROUP'
                                     AND a.segment4    = 'Y' -- Capa 공정 여부 
                                     AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                                     AND a.valid_yn    = 'Y'
                                     AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                     AND b.valid_yn    = 'Y'
                                     AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
                                    )                               
                AND    EXISTS ( SELECT 1    --~ 예외 LINE_CAPA 추가 대상 검색
                                FROM  ( SELECT b.segment1 AS division_id 
                                            , b.segment2  AS site_id 
                                            , b.segment3  AS plant_id
                                            , b.segment4  AS op_id 
                                        FROM  scm_adm_lookup_master A WITH(NOLOCK) 
                                            , scm_adm_lookup_master_detail B WITH(NOLOCK) 
                                        WHERE a.lookup_type = b.lookup_type 
                                        AND   a.lookup_type = 'ADD_LINE_CAPA_ROUTE'
                                        AND   a.valid_yn    = 'Y' 
                                        AND   b.valid_yn    = 'Y' 
                                        AND   b.segment1    = @p_division_id
                                        ) x 
                                WHERE x.division_id  =  ln.division_id 
                                AND   x.site_id  =  ln.site_id
                                AND   x.plant_id =  ln.plant_id
                                AND   x.op_id    =  ln.operation_id
                              ) 
              )  c 
        WHERE  a.master_id   = @p_master_id 
        AND    a.plan_id     = @p_engine_plan_id
        AND    b.modeling_id = @p_modeling_id
        AND    b.plan_id     = @p_plan_id
        AND    b.plan_seq    = @p_seq
        AND    b.plan_type   = @p_plan_type
        AND    a.site_id     = b.eng_scm_site_id
        AND    a.site_id     = c.eng_scm_sitE_id
        AND    a.route_id    LIKE c.operation_id + '%'
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '3.2-2 LINE_CAPA';
        SET @v_description = 'Insert LINE_CAPA.Add' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        ---------------------------------------------------------------------------------------------------------------------
        -- 2023.07.07 SHS 활성화 코드 분리 A~002 Dummy RESOURCE 설정.    
        -- resourcre table 의 key 에 site_id, route_id 가 포함되지 않아 그냥 무조건 생성
        ---------------------------------------------------------------------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_RESOURCE */ th_eng_resource_sn
		(      master_id, plan_id, resource_id, resource_type, site_id, route_id, location_id
			 , multi_port_count, utilization, batch_type, is_exception, is_finite, is_dummy
			 , offtime_set_id, attribute_set_id, attribute_checker_id, inline_group_id
			 , resource_group_id, resource_setup_group_id, batch_res_group_id
			 , max_setup_count, rampup_rate, rampup_term, rampup_uom 
			 , fixed_term, fixed_term_uom, ncp_term, ncp_term_uom, descr
		)
		SELECT	
			   @p_master_id                              AS master_id
			 , @p_engine_plan_id						 AS plan_id
			 , a.operation_id + '::' + a.site_id + '::' + '-'	
                                                         AS resource_id
			 , 'MAIN'                                    AS resource_type
			 , SITE_ID									 AS site_id
			 , ROUTE_ID									 AS route_id -- eng_resource key 가 설비까지 
			 , NULL                                      AS location_id
			 , 1                                         AS multi_port_count
			 , 1                                         AS utilization
			 , NULL                                      AS batch_type
			 , 'N'                                       AS is_exception
			 , 'Y'                                       AS is_finite 
			 , 'Y'                                       AS is_dummy
			 , NULL                                      AS offtime_set_id
			 , NULL                                      AS attribute_set_id
			 , NULL                                      AS attribute_checker_id
			 , NULL                                      AS inline_group_id
			 , a.operation_id + '::' + a.site_id + '::' + '-'	
                                                         AS resource_group_id  
			 , NULL                                      AS resource_setup_group_id
			 , NULL                                      AS batch_res_group_id
			 , -1                                        AS max_setup_count
			 , NULL                                      AS rampup_rate
			 , NULL                                      AS rampup_term
			 , 'HOUR'                                    AS rampup_uom 
			 , 0										 AS fixed_term 
			 , 'DAY'                                     AS fixed_term_uom
			 , 0                                         AS ncp_term    
			 , 'DAY'                                     AS ncp_term_uom
			 , 'NO_CAPA'							     AS descr  
	    FROM (	SELECT site_id, route_id , operation_id 
				  FROM th_eng_item_route_site_sn a WITH(NOLOCK)
				 WHERE master_id = @p_master_id
				   AND plan_id   = @p_engine_plan_id	
				   AND descr     = N'DUMMY'
				 GROUP 
                    BY site_id
                     , route_id 
                     , operation_id 
			    )A
	    WHERE NOT EXISTS (SELECT 1
						    FROM th_eng_resource_sn x WITH(NOLOCK)
						   WHERE x.master_id = @p_master_id
						     AND x.plan_id   = @p_engine_plan_id	
						     AND a.operation_id + '::' + a.site_id + '::' + '-' = x.resource_id
						 )
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = '5. DUMMY Resource';
        SET @v_description = 'Insert DUMMY.Add' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


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

