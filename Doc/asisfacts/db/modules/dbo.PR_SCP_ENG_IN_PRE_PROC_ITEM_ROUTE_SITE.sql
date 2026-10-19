
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_ITEM_ROUTE_SITE
 * Description  :
                  ITEM ROUTE SITE 정보를 INSERT

                  - 컬럼1) item_id       : th_eng_plan_bom_sn.parent_item_id
                  - 컬럼2) route_id      : th_eng_plan_bom_sn.route_id (다중공정포함(ex)'A5000A6000')
                  - 컬럼3) route_level   : 1 셋팅
                  - 컬럼4) operation_id  : th_eng_plan_bom_sn.operation_id(=위 컬럼2)route_id와 동일값)
                  - 컬럼5) operation_seq : 1 셋팅
                  - 컬럼6) min_tat       : eng_scm_site_id, operation_group, flow_id별로 SUM(scm_mst_operation_move_m_sn.tat) 값을 사용함
                                           => division_id, company_id, site_id, plant_id, operation_id 별 MAX(operation_lead_time) 값사용 => 최종사용시 eng_scm_site_id, operation_group, flow_id별로 SUM값을 사용함
                                           => division_id, company_id, site_id, plant_id, operation_id 별 MAX(tat) 값사용 => 최종사용시 eng_scm_site_id, operation_group, flow_id별로 SUM값을 사용함
                  - 컬럼7) avg_tat       : 위 컬럼6) min_tat와 동일값 사용
                  - 컬럼8) max_tat       : 위 컬럼6) min_tat와 동일값 사용
                  - 컬럼9) tat_uom       : 'MINUTE' 셋팅
                  - 컬럼10) yield        : 1 셋팅
                  - 컬럼11) min_lot_site : 0 셋팅 =>최종은 PROC_FIX_MISMATCHING에서 UPDATE(TH_ENG_PRODUCT_MIX_SN.qty값으로 UPDATE)
                  - 컬럼12) max_lot_size : 0 셋팅
                  - 컬럼13) increment_lot_size   : -1 셋팅 =>최종은 PROC_FIX_MISMATCHING에서 컬럼값 UPDATE(TH_ENG_PRODUCT_MIX_SN.qty값으로 UPDATE)
                  - 컬럼14) in_moving_lot_size   : -1 셋팅
                  - 컬럼15) out_moving_lot_size  : -1 셋팅
                  - 컬럼16) out_move_time : 외주 site일때만 설정된 정보(단위:분), 나머지는 NULL로  셋팅
                  - 컬럼17) move_time_uom : 'MINUTE' 셋팅
                  - 컬럼18) early_producing_term : 0 셋팅 => scm_mst_site.build_ahead값을 셋팅했지만 여기는 0 입력하고 th_eng_item_bod_sn.early_producing_term 에 정상BOD일때만 scm_mst_site.build_ahead값을 셋팅함
                  - 컬럼19) descr  : 외주site일때 'OSP'셋팅 나머지는 NULL로 셋팅

                  - 참고 테이블1) th_eng_plan_bom_sn          (엔진용 BOM정보)
                  - 참고 테이블2) scm_mst_operation_move_m_sn (FP용 operation별 tat 및 lead_time 정보) (참고) scm_mst_operation_move_m_sn.operation_id를 가지고 flow_id(다중공정포함)를 조회할려면 scm_mst_operation_flow_v.operation_id조인해서 scm_mst_operation_flow_v.flow_id값을 사용하면 됨
                  - 참고 테이블3) scm_mst_operation_flow_v    (FP용 flow, operation 정보)

 * OutTable     : TH_ENG_ITEM_ROUTE_SITE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.16   KSW            전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.08   KSW            early_producing_term 값변경 (0 으로 셋팅) 
 * 2018.09.20   KSG            외주 공정 TAT 적용: 2일
 * 2019.11.19   KSG            C20191107-000099  외주 Packer 후공정 L/T 적용 요청 - out_move_time : 외주 site일때만 설정된 정보(단위:분), 나머지는 NULL로  셋팅
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
 * 2020.03.17   KSG            C20200316-000060 FP operation L/T 인터페이서 Column 변경
 *                                tat 변경 : opeation_lead_time에서 tat로 변경
 * 2023.07.07   SHS			   PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 Cell Product Code 분리 Dummy 공정 Marking
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_ITEM_ROUTE_SITE]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_ITEM_ROUTE_SITE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_ITEM_ROUTE_SITE';
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

		DELETE /* PR_SCP_ENG_IN_PRE_PROC_ITEM_ROUTE_SITE */
		FROM   th_eng_item_route_site_sn
		WHERE  master_id = @p_master_id
		AND    plan_id   = @p_engine_plan_id 
		;
		
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM_ROUTE_SITE */ th_eng_item_route_site_sn
		( master_id
		, plan_id
		, item_id
		, site_id
		, route_id
		, route_level
		, operation_id
		, operation_seq
		, flow_id
		, min_tat
		, avg_tat
		, max_tat
		, tat_uom
		, yield
		, min_lot_size
		, max_lot_size
		, increment_lot_size
		, in_moving_lot_size
		, out_moving_lot_size
		, in_move_time
		, out_move_time
		, move_time_uom
		, early_producing_term
		, early_producing_term_uom
		, operation_type
		, buffer_time
		, buffer_time_uom
		, descr
		, transfer_batch_size
		)
		SELECT DISTINCT 
				@p_master_id              AS master_id
				, @p_engine_plan_id         AS plan_id
				, b.parent_item_id          AS item_id
				, b.site_id                 AS site_id
				, b.route_id                AS route_id
				, 1                         AS route_level
				, b.operation_id            AS operation_id
				, 1                         AS operation_seq
				, NULL                      AS flow_id
		
                -- 20200317 C20200316-000060 opeation_lead_time에서 tat로 변경	(sum_operation_lead_time => sum_tat)
                , ISNULL(m.sum_tat, 0) AS min_tat--  FP Operation 의 정보 
				, ISNULL(m.sum_tat, 0) AS avg_tat--  FP Operation 의 정보
				, ISNULL(m.sum_tat, 0) AS max_tat--  FP Operation 의 정보
                , 'MINUTE'                  AS tat_uom

				, 1                         AS yield
				-- Fix Mismatching 에서 Lot Size 정보 Update함
				, 0                         AS min_lot_size
				, 0                         AS max_lot_size
				, -1                        AS increment_lot_size
				, -1                        AS in_moving_lot_size
				, -1                        AS out_moving_lot_size
				, NULL                      AS in_move_time
				 
				-- 2018.09.20  외주 공정 적용: 2일 : TAT는 Product Mix와 동시 적용이 안 되므로 Out Move Time으로 적용
                -- 20191119  C20191107-000099 추가 : OSP Site 도 내부 공정 분리할 경우 특정 공정 지정해야 함
                , CASE WHEN c.osp_yn = 'Y' AND c.operation_group <> 'A' THEN (ol.lt_day * 1440)  -- TCO(A) 제외
                    ELSE NULL
                END                       AS out_move_time
				, 'MINUTE'                  AS move_time_uom
                
                /*
                -- 생산 Target 공정/ 외주 패커에만 넣을 것
                , CASE WHEN d.flow_id IS NOT NULL THEN ISNULL(c.build_ahead, 0)
                    WHEN c.osp_yn = 'Y'        THEN ISNULL(c.build_ahead, 0)
                    ELSE 0
                END                       AS early_producing_term
            */
                , 0 AS early_producing_term -- 20180607 티라요청 (차후에는 SCP_ENG_IN_PRE_PROC_ITEM_BOD 에서 early_producing_term 값을 셋팅함)
                   
				, 'DAY'                     AS early_producing_term_uom
				, NULL                      AS operation_type 
				, NULL                      AS buffer_time
				, NULL                      AS buffer_time_uom
				 
                -- 2020.02.03 [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
                , CASE WHEN c.osp_yn = 'Y' AND c.attribute1 = 'Y' THEN 'OSP_L'
                    WHEN c.osp_yn = 'Y'                        THEN 'OSP'
                    ELSE NULL
                END                       AS descr

				--, CASE WHEN c.osp_yn = 'Y'  THEN 'OSP'
                --     ELSE NULL
                --END                       AS descr

				, NULL                      AS transfer_batch_size
        FROM   th_eng_plan_bom_sn b WITH(NOLOCK)

                INNER JOIN scm_mst_site_eng c WITH (NOLOCK)
                ON   b.site_id     = c.eng_scm_site_id 
                AND  c.modeling_id = @p_modeling_id 
                AND  c.division_id = @p_division_id 
                AND  c.plan_id     = @p_plan_id 
                AND  c.plan_type   = @p_plan_type 
                AND  c.plan_seq    = @p_seq 
                   
                -- 20191119  C20191107-000099 추가 : OSP Site 도 내부 공정 분리할 경우 특정 공정 지정해야 함
                LEFT JOIN scp_mst_operation_lt ol WITH (NOLOCK)
                ON   ol.scm_site_id  = c.scm_site_id 
                AND  ol.lt_operation = 'OSP_LT'
                AND  ol.item_id      = b.parent_item_id

                LEFT JOIN (  SELECT b.segment2 AS flow_id
                            FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
                            INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                            ON  a.segment1    = b.segment1
                            AND a.lookup_type = 'LOCATION_GROUP'
                            AND a.segment4    = 'Y' -- Capa 공정 여부 
                            --AND a.segment5    = 'N' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                            AND a.valid_yn    = 'Y'
                            AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                            AND b.valid_yn    = 'Y'
                            AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
                            ) d
                ON b.route_id = d.flow_id 

                LEFT OUTER JOIN
                (SELECT  s.eng_scm_site_id
                        , s.operation_group AS operation_group
                        , op.flow_id        AS route_id
                        
                        --ksg : operation lead time >> tat 
                        --20180308 수정 ( 변경전 : , MAX(ISNULL(om.tat, 0))  AS tat  )
                        , SUM(ISNULL(om.tat, 0))                  AS sum_tat
                        , SUM(ISNULL(om.operation_lead_time, 0))  AS sum_operation_lead_time    

                FROM  (SELECT division_id, company_id, site_id, plant_id, operation_id
                            , MAX( CASE WHEN  tat_uom = 'HOUR' THEN  ISNULL(tat * 60, 0)
								        WHEN  tat_uom = 'DAY'  THEN  ISNULL(tat * 24 * 60, 0)
                                        ELSE  ISNULL(tat, 0)
                                    END
                                    )  AS tat
                            , MAX( CASE WHEN  operation_lead_time_uom = 'HOUR' THEN  ISNULL(operation_lead_time * 60, 0)
								        WHEN  operation_lead_time_uom = 'DAY'  THEN  ISNULL(operation_lead_time * 24 * 60, 0)
                                        ELSE  ISNULL(operation_lead_time, 0)
                                    END
                                    )  AS operation_lead_time  -- Factory 별로 Data 존재 시 MAX 값 사용
                        FROM   dbo.scm_mst_operation_move_m_sn  WITH(NOLOCK)
                        WHERE  division_id     = @p_division_id
                        GROUP BY division_id, company_id, site_id, plant_id, operation_id
                        ) om
                        ,(SELECT DISTINCT
                                t.division_id
                            , t.company_id
                            , t.site_id
                            , t.flow_id
                            , t.operation_id
                            --, CASE WHEN SUBSTRING(flow_id, 1, 5) = 'E2000' THEN 'E2000' -- 전극 후공정 LT는 BOD 로 반영
                            --       ELSE t.operation_id
                            --  END operation_id
                            , t.operation_group  --20180306 변경  (변경전 : , CASE WHEN SUBSTRING(operation_id, 1, 1) = 'F' THEN 'A' /* 활성화 => CELL*/   WHEN SUBSTRING(operation_id, 1, 1) = 'S' THEN 'E' /* SRS => 전극*/ ELSE SUBSTRING(operation_id, 1, 1) END operation_group )                              

                        FROM   dbo.scm_mst_operation_flow_v t WITH(NOLOCK) -- 20180306 view 변경 ( 변경전 : FROM   dbo.scm_mst_operation_flow_sn t WITH(NOLOCK) --[LGCE_FPDEV_TR].[DBO].[SCM_OPERATION_FLOW_M] )
                        WHERE  t.division_id = @p_division_id                         
                        AND    t.valid_yn = 'Y'   -- 20180306 변경 (변경전 : AND    SUBSTRING(operation_id, 1, 1) NOT IN ( 'S', 'F' ) -- SRS/활성화 공정 제외)                      
                        ) op 
                        ,(SELECT *
                        FROM   dbo.scm_mst_site_eng WITH(NOLOCK)
                        WHERE  division_id = @p_division_id
                        AND    plan_id     = @p_plan_id
                        AND    plan_type   = @p_plan_type
                        AND    plan_seq    = @p_seq
                        ) s  
                WHERE  om.division_id     = @p_division_id
                AND    om.division_id     = op.division_id
                AND    om.company_id      = op.company_id
                AND    om.site_id         = op.site_id
                AND    om.operation_id    = op.operation_id
                AND    om.division_id     = s.division_id
                AND    om.plant_id        = s.plant_id
                AND    op.operation_group = s.operation_group

                GROUP BY s.eng_scm_site_id, s.operation_group, op.flow_id
                ) m
		        ON  b.site_id   = m.eng_scm_site_id
		        AND b.route_id  = m.route_id
		WHERE   b.master_id = @p_master_id
		AND     b.plan_id   = @p_engine_plan_id
		;

		 -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT '+@v_table_id; 
        SET @v_description = N'1. Item_Route_Site 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		-----------------------------------------------------------
        -- 2023.07.07 SHS Cell Product Code 분리 Dummy 공정 Marking
		-- NO_CAPA 공정 및 엔진Outbound / UI 집계시 계획 제외로직 요청으로 Marking
        -----------------------------------------------------------
        --CASE1. Normal BIZ (TCO外)
        UPDATE a
		   SET a.descr = 'DUMMY'
		  FROM th_eng_item_route_site_sn a
         WHERE a.master_id =   @p_master_id
		   AND a.plan_id   =   @p_engine_plan_id
           AND EXISTS (SELECT 'X' 
                         FROM scm_mst_final_item_v x WITH(NOLOCK)
                        WHERE x.division_id = @p_division_id
                          AND x.item_id     = a.item_id
                          AND x.tco_cell_yn = 'N'
                          AND x.cell_type   =  'CP'
                       )
        ;
    
        --CASE2. TCO BIZ (CP2와 매핑된 TCO)
        UPDATE a
		   SET a.descr = 'DUMMY'
		  FROM th_eng_item_route_site_sn a
         WHERE a.master_id =   @p_master_id
		   AND a.plan_id   =   @p_engine_plan_id
           AND EXISTS (SELECT 'X' 
                         FROM scp_mst_cell_prod_assy_map x WITH(NOLOCK)
		                WHERE x.item_id_prod = a.item_id
                          AND x.cell_type    = 'CA2'
		                  AND CHARINDEX(x.plant_id, a.site_id ) > 0
                          AND x.valid_yn = 'Y'
                       )
        ;

		 -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'UPDATE '+@v_table_id; 
        SET @v_description = N'2. CP:Descr=Dummy' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
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
