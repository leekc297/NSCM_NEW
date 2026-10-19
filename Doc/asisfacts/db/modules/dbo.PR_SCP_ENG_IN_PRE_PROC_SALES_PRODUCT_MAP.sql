
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_SALES_PRODUCT_MAP
 * Description  : SDB의 Sales Model과 Product Model Mapping 정보를 ODB에 적재되도록 한다.
 * OutTable     : TH_ENG_SALES_PRODUCT_MAP
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.22   정원식      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024.05.20   KKC         PJ20244573  LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성
 * 2024.06.26   KKC         PJ20244573  LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 자동차 판매/완제품 대치 모델링 추가 (JV도 포함)
 * 2025.12.04   YMH			E20251027-000120 DEMAND GROUP MASTER ESS 사업부 추가
*/

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_SALES_PRODUCT_MAP]
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

    DECLARE @v_division_group   NVARCHAR(30);  ---2024.05.20 변수추가 
    DECLARE @v_division_comp    NVARCHAR(30); 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_SALES_PRODUCT_MAP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_SALES_PRODUCT_MAP';
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

        /*------------------------------------------------------------------
            * Division Group 추가. 2024.05.20
        ----------------------------------------------------------------------*/ 
        SELECT @v_division_group   =  di.attribute3  
             , @v_division_comp    =  di.attribute4   -- 회사코드
        FROM   scm_mst_division di WITH(NOLOCK)
        WHERE  di.valid_yn         =  'Y' 
        AND    di.division_id      =  @p_division_id   
        ; 

		DELETE 
		FROM   th_eng_sales_product_map_sn
        WHERE 1=1
        AND   plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
		;
		
        -----------------------------------------------------------
		INSERT INTO th_eng_sales_product_map_sn
		    ( master_id
		    , plan_id
		    , sales_model_id
		    , product_item_id
		    , site_id
		    , alt_priority   --2024.05.20, 1순위 product Item id를 엔진Pegging결과의 Demand Item Id로 표현
		    , alt_rate
		    , descr
		    )
		SELECT DISTINCT 
		       @p_master_id                   AS master_id
		     , @p_engine_plan_id              AS plan_id
              /* 자동차 판매모델ID 변경 : 2024.05.20 
                  자동차   : PROJECT CODE + GROUP_CD + DM MODEL + SALES SITE
                  자동차외 : DM MODEL + SALES SITE
               */
			   -- E20251027-000120 DEMAND GROUP MASTER 기존 81만에서 81 OR 82 로 82 추가.
		     , CASE WHEN @v_division_group = '81' THEN 'NONE'+'::' + 'NONE'+'^'+ t.item + '^' + t.siteid + '^S'
					WHEN @v_division_group = '82' THEN 'NONE'+'::' + 'NONE'+'^'+ t.item + '^' + t.siteid + '^S'
                    ELSE t.item + '^' + t.siteid + '^S'
                END                           AS sales_model_id
--		     , t.item + '^' + t.siteid + '^S' AS sales_model_id
		     , t.item                         AS product_item_id
		     , t.siteid                       AS site_id
		     , 1                              AS alt_priority
		     , 1                              AS alt_rate
		     , NULL                           AS descr
		FROM   scp_eng_itemsitemstr_i_sn t WITH(NOLOCK)
		WHERE  t.modeling_id = @p_modeling_id -- '1'   
		AND    t.plan_id     = @p_plan_id     -- '1004'
        AND    t.plan_type   = @p_plan_type   --20180321 plan_type 추가
		AND    t.seq         = @p_seq    	  -- '1'   
		AND    t.enterprise  = @p_master_id   -- '1'   
		AND    t.item_type  <> 'R'
		AND    t.stage       = 'S_PSI'
        -- Demand에 있는데 sales model에 없는 모델 등록
        UNION -- 중복은 삭제됨
        SELECT DISTINCT 
		       @p_master_id                   AS master_id
		     , @p_engine_plan_id              AS plan_id
		     , sales_model_id                 AS sales_model_id
		     , t.item                         AS product_item_id
		     , t.site                         AS site_id
		     , 1                              AS alt_priority
		     , 1                              AS alt_rate
		     , NULL                           AS descr
        FROM   th_eng_demand_sn t WITH (NOLOCK)
		WHERE  t.master_id = @p_master_id
        AND    t.plan_id   = @p_engine_plan_id
		;	


        -- ALT PRODUCT ITEM 추가 2024.05.20 추가 
        -- 자동차 JV 포함으로 변경, 2024.06.26
		-- E20251027-000120 DEMAND GROUP MASTER 기존 81만에서 81 OR 82 로 82 추가.
        IF @v_division_group = '81' OR @v_division_group = '82'
        BEGIN
        ;WITH vw_alt_groupping_item AS (
                                  /* 완제품 대치 모델링 대상 조회 */
                                 SELECT a.*
                                  FROM
                                     (
                                     SELECT a.project_code
                                          , a.group_id
                                          , a.item_id
                                          , COUNT(a.item_id) OVER(PARTITION BY a.project_code
                                                                             , a.group_id
                                                                 ) project_item_cnt      
                                       FROM scp_mst_item_group_detail a WITH (NOLOCK)
                                      WHERE a.division_id = @p_division_id
                                        AND a.valid_yn    = 'Y'
                                        AND EXISTS (SELECT 'x'
                                                      FROM scp_mst_item_group x WITH (NOLOCK)
                                                     WHERE x.division_id = a.division_id
                                                       AND x.valid_yn    = 'Y'
                                                       AND x.group_id    = a.group_id
                                                     )
                                     ) a
                                 WHERE a.project_item_cnt > 1
                              )        
		INSERT INTO th_eng_sales_product_map_sn
		    ( master_id
		    , plan_id
		    , sales_model_id
		    , product_item_id
		    , site_id
		    , alt_priority
		    , alt_rate
		    , descr
		    )
        SELECT DISTINCT 
		       @p_master_id                   AS master_id
		     , @p_engine_plan_id              AS plan_id
		     , a.sales_model_id               AS sales_model_id
		     , c.item_id                      AS product_item_id
		     , a.site                         AS site_id
		     , 9                              AS alt_priority
		     , 1                              AS alt_rate
		     , NULL                           AS descr
         FROM  th_eng_demand_sn a WITH (NOLOCK)
        INNER JOIN vw_alt_groupping_item b --DM ITEM의 PROJECT별 GROUP CODE 
           ON a.project_code = b.project_code
          AND a.item         = b.item_id
        INNER JOIN vw_alt_groupping_item c --ALT PRODUCT ITEM
           ON a.project_code = c.project_code
          AND b.group_id     = c.group_id
          AND a.item        <> c.item_id
        WHERE a.master_id = @p_master_id
          AND a.plan_id   = @p_engine_plan_id
          AND NOT EXISTS (SELECT 'X'
                           FROM th_eng_sales_product_map_sn x WITH(NOLOCK)
		                  WHERE x.master_id = @p_master_id
                            AND x.plan_id   = @p_engine_plan_id
                            AND x.sales_model_id = a.sales_model_id
                            AND x.product_item_id = c.item_id
                        )
		;	

        END
        -----------------------------------------------------------

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

