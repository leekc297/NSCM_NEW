
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_DPP_DEMAND
 * Description  : demand 정보를 적재                  
                  
                  -----------------------------------------------------------
                  --1. 대상 demand 정보를 임시테이블에 INSERT
                  ----------------------------------------------------------- 
                    
                  -----------------------------------------------------------
                  --2-1. split 비대상 demand 정보를 INSERT
                  ----------------------------------------------------------- 
                    - 전극 아닐때 split 비대상                    

                  -----------------------------------------------------------
                  --2-2. split 대상 demand 정보를 INSERT
                  -----------------------------------------------------------
                    - 전극 일때 split 대상
                      ==> th_eng_demand_sn.max_daily_capa 수량으로 split (값이 없을경우 default : 10000개 수량으로 split)

 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.26   KSW         Initial Release 전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.21   KSW         demand_priority 컬럼추가
 * 2018.07.17   KSW         split 속도걔선관련 수정
 * 2018.09.07   KSW         전극(셀은 하위 전극으로) split 관련 수정
 * 2021.05.26   KKC         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : DEMAND SPLIT 옵션화
 * 2021.07.21   KKC         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : DEMAND QTY < 1 데이터 소숫점 처리(계획수립시 무한루프 방지) 및 BUSINESS_TYPE 추가
 * 2023.03.07   SHS         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: DEMAND SPLIT 옵션 추가
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_DPP_DEMAND]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_DPP_DEMAND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_NET_DEMAND'; --'TH_ENG_NET_DEMAND/TH_DPP_NET_DEMAND';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

    DECLARE @n_split_count       NUMERIC(20,10) = 1.0; -- demand split count
    DECLARE @default_daily_capa  NUMERIC(5) = 10000;   -- 20180717 추가 daily_capa 값이 없을경우 기본값

    DECLARE @v_split_yn          NVARCHAR(1);  --2021/05/26 추가, By KKC

	/* DEMAND SPLIT 변수 추가,. 2023.03.07 */
	DECLARE @v_pack_capa_apply_yn NVARCHAR(30) = 'N';
	DECLARE @v_default_split_qty NUMERIC(5);
	DECLARE @v_to_daily_capa_apply DATETIME;
	DECLARE @v_weekly_capa_working_day NUMERIC(5);

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
      
        DELETE /* PR_SCP_ENG_EE_PRE_PROC_DPP_DEMAND */
        FROM   th_eng_net_demand_sn 
        WHERE  master_id = @p_master_id 
        AND    plan_id   = @p_engine_plan_id 
        ;

		-----------------------------------------------------------
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		-- Split 여부 옵션화, 2021/05/26, By KKC
        -----------------------------------------------------------
		/*
		SELECT @v_split_yn = ISNULL(a.segment2, 'N')   
		  FROM scm_adm_lookup_master_detail a(nolock)
		 WHERE a.lookup_type = 'DEMAND_DAILY_CAPA_SPLIT_YN'
		   AND a.SEGMENT1 = @p_division_id
		;
		*/

		-- 2023.03.07 DEMAND SPLIT APPLY ( DEMAND SPLIT OPTION ) 
		SELECT	@v_split_yn                = a.split_yn 							   -- DEMAND SPLIT 여부
			  , @v_default_split_qty       = ISNULL(a.default_split_qty,10000)	       -- DEFAULT SPLIT 수량
			  , @v_pack_capa_apply_yn      = ISNULL(a.pack_capa_apply_yn, 'N')		   -- PACK CAPA 적용 여부
			  , @v_to_daily_capa_apply     = DATEADD(WEEK,  ISNULL(a.daily_capa_apply_week,0), CONVERT(DATE, @p_plan_name))  
																					   -- 일 CAPA 적용구간(~To Period)
  			  , @v_weekly_capa_working_day =ISNULL(a.weekly_capa_working_day,0)	       -- 주간 WORKING DAY
		FROM	
				(
				 SELECT	b.segment1                 AS division_id 
					  , CONVERT(INT, b.segment2)   AS default_split_qty
					  , b.segment3                 AS pack_capa_apply_yn
					  , CONVERT(INT, b.segment4)   AS daily_capa_apply_week
					  , CONVERT(INT, b.segment5)   AS weekly_capa_working_day
					  , b.valid_yn                 AS split_yn	
				  FROM	scm_adm_lookup_master a WITH(NOLOCK) 	
				  JOIN	scm_adm_lookup_master_detail b WITH(NOLOCK)	
					ON	a.lookup_type = b.lookup_type	
				 WHERE	a.lookup_type = 'SCP_ENG_DEMAND_SPLIT'
				   AND	b.valid_yn = 'Y'
				) a
		WHERE a.division_id = @p_division_id
		;

		--Split여부 변수 Validation Check
		IF @v_split_yn IS NULL OR @v_split_yn != 'Y'
		   BEGIN
		       SET @v_split_yn = 'N';
		   END;
        
        -----------------------------------------------------------
        --1. 대상 demand 데이터 임시테이블로 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_demand') IS NOT NULL 
         BEGIN
            DROP TABLE #th_eng_demand
         END

        SELECT master_id
	     , plan_id 
	     , demand_id 
	     , sales_model_id
	     , shipping_date
	     , due_date
	     , due_fence_date
	     , early_producing_term
	     , early_producing_term_uom
	     , qty
	     , split_qty
	     , order_type
	     , demand_type
	     , producing_type
	     , priority_group_code
	     , priority
	     , attribute_checker_id
	     , demand_group_id
	     , late_type
	     , descr
	     , move_time_rate
	     , buffer_time_rate
	     , is_exception
	     , is_consume
	     , item
	     , site
	     , scm_site
         , project_code                 
         , plant_site_id
         , org_cell_site_id
         , org_elec_site_id         
         , avg_setup_time
         , cell_site_setup_group_id
         , cell_site_id
         , cell_item_id         
		 , ISNULL(max_daily_capa, @default_daily_capa)              AS max_daily_capa -- 변경되는게 없다         
         , demand_priority  -- 20180621 추가(DM의 우선순위)     
         , division_id         
         , ceiling(qty/ISNULL(max_daily_capa, @default_daily_capa)) AS max_div_count  -- split 개수           
        INTO  #th_eng_demand
        FROM  th_eng_demand_sn WITH (NOLOCK)
        WHERE master_id = @p_master_id --'81::WEEKLY'
        AND   plan_id   = @p_engine_plan_id --'1034::PR::6'
        ;

        -----------------------------------------------------------
        --2-1. split 비대상 demand 정보 INSERT
        -----------------------------------------------------------
       INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_DPP_DEMAND */ th_eng_net_demand_sn 
        ( master_id
        , plan_id
        , demand_id
        , sales_model_id
        , shipping_date
        , due_date
        , due_fence_date
        , early_producing_term
        , early_producing_term_uom
        , qty
        , split_qty
        , order_type
        , demand_type
        , producing_type
        , priority_group_code
        , priority
        , attribute_checker_id
        , demand_group_id
        , late_type
        , descr
        , move_time_rate
        , buffer_time_rate
        , is_exception
        , is_consume
        , item
        , site
        , scm_site
        , demand_priority -- 20180621 추가     
        , project_code    -- 20210122 추가
		, business_type   -- 20210721 추가
		, attr05          -- 2023.03.07 추가 (eng split qty)
        )
        SELECT master_id
             , plan_id
             , demand_id
             , sales_model_id
             --20180514 수정 yyyymmdd => yyyymmdd 23::59::59 변경
             --, shipping_date
             --, due_date
             --, due_fence_date
             , DATEADD(ss,86399, CONVERT(DATETIME, shipping_date))  AS shipping_date
             , DATEADD(ss,86399, CONVERT(DATETIME, due_date))       AS due_date
             , DATEADD(ss,86399, CONVERT(DATETIME, due_fence_date)) AS due_fence_date             
             , early_producing_term
             , early_producing_term_uom
             , qty
			 , qty
			 , order_type
             , demand_type
             , producing_type
             , priority_group_code
             , priority
             , attribute_checker_id
             , demand_group_id
             , late_type
             , descr
             , move_time_rate
             , buffer_time_rate
             , is_exception
             , is_consume
             , item
             , site
             , scm_site           
             , demand_priority -- 20180621 추가   
             , project_code    -- 20210122 추가  
			 , 'ALL'           -- 20210721 추가
               -- 2023.03.07	DEMAND SPLIT APPLY
			 , CASE	WHEN @v_split_yn = 'N'      THEN  qty
			        WHEN max_daily_capa IS NULL THEN  qty
			        WHEN max_daily_capa = 0     THEN  qty					
					ELSE 
						CASE WHEN due_date < @v_to_daily_capa_apply THEN max_daily_capa
							 ELSE max_daily_capa * @v_weekly_capa_working_day
						END
				END AS split_qty	             
         FROM  #th_eng_demand a
		/* 2023.03.07 Engine Custom Split으로 주석처리
		/* Split 여부 옵션화, 2021/05/26, By KKC */
		/(
        WHERE  1 = CASE WHEN @v_split_yn = 'N' THEN 1
						ELSE 
						     CASE WHEN ISNULL(dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-'), 'N') <> 'E' THEN 1
		                          ELSE 0
							   END
					END
        ;
		*/
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'split 비대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
		/***********************************************************
		   --2023.03.07 
		   DEMAND SPLIT DATA 생성 로직 주석 처리 Start ~
		 : Engine Custom에서 SPLIT_QTY 기준으로 SPLIT하는 로직 구현 
		-----------------------------------------------------------
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		-- Split 여부 옵션화, 2021/05/26, By KKC
        -----------------------------------------------------------
        IF @v_split_yn = 'N'
		BEGIN
		      GOTO SKIP1;
		END

        -----------------------------------------------------------
        --2-2. split 대상(셀('A')만 대상임) demand 정보를 split INSERT        
        -----------------------------------------------------------

        -----------------------------------------------------------
        --2-2-1. copy_t 임시 테이블 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#copy_t') IS NOT NULL 
         BEGIN
            DROP TABLE #copy_t
         END         

        DECLARE @max_div_count NUMERIC(5)
        SELECT @max_div_count = MAX(ceiling(qty/ISNULL(max_daily_capa, @default_daily_capa)))
        FROM   #th_eng_demand
        WHERE  dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-') = 'E' --전극일때 
        ;

        -- 1 ~ @max_div_count 값이 들어간 임시테이블 생성
        ;WITH copy_t AS (
           SELECT 1 no 
           UNION ALL
           SELECT no + 1
           FROM   copy_t 
           WHERE  no < @max_div_count --1000 이면  1000번까지 생성됨
        )
        SELECT * 
        INTO  #copy_t
        FROM copy_t OPTION (MAXRECURSION 32767)
        ;
        
        -----------------------------------------------------------
        --2-2-2) split 대상 demand 정보를 임시테이블로 생성
             -- split 대상 : 팩(BOM 상의 선호 셀로 처리)/셀 
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_DPP_DEMAND */ th_eng_net_demand_sn
        ( master_id
        , plan_id
        , demand_id
        , sales_model_id
        , shipping_date
        , due_date
        , due_fence_date
        , early_producing_term
        , early_producing_term_uom
        , qty
        , split_qty
        , order_type
        , demand_type
        , producing_type
        , priority_group_code
        , priority
        , attribute_checker_id
        , demand_group_id
        , late_type
        , descr
        , move_time_rate
        , buffer_time_rate
        , is_exception
        , is_consume
        , item
        , site
        , scm_site  
        , demand_priority -- 20180621 추가        
        , project_code    -- 20210122 추가
		, business_type   -- 20210721 추가
        )
        SELECT a.master_id
            ,  a.plan_id
            ,  CASE WHEN a.max_div_count <> 1 THEN a.demand_id + '^S_' + CONVERT(NVARCHAR(10), b.no)
                    ELSE a.demand_id 
               END  AS demand_id
                        
            ,  a.sales_model_id

            --20180514 수정 yyyymmdd => yyyymmdd 23::59::59 변경
            --, a.shipping_date
            --, a.due_date
            --, a.due_fence_date

            , DATEADD(ss,86399, CONVERT(DATETIME, a.shipping_date))  AS shipping_date
            , DATEADD(ss,86399, CONVERT(DATETIME, a.due_date))       AS due_date
            , DATEADD(ss,86399, CONVERT(DATETIME, a.due_fence_date)) AS due_fence_date

            , a.early_producing_term
            , a.early_producing_term_uom
            
            , CASE WHEN a.max_div_count <> b.no  THEN a.max_daily_capa --a.qty  --AND a.qty <= a.max_daily_capa 
                   WHEN a.max_div_count = b.no   THEN IIF(a.qty % a.max_daily_capa = 0, a.max_daily_capa, a.qty % a.max_daily_capa)
              END  AS qty
            
            , CASE WHEN a.max_div_count <> b.no  THEN a.max_daily_capa --a.qty  --AND a.qty <= a.max_daily_capa 
                   WHEN a.max_div_count = b.no   THEN IIF(a.qty % a.max_daily_capa = 0, a.max_daily_capa, a.qty % a.max_daily_capa)
              END  AS split_qty

            , a.order_type
            , a.demand_type
            , a.producing_type
            , a.priority_group_code
            , a.priority + dbo.FN_ZERO_LPAD( b.no, 5) AS priority

            , a.attribute_checker_id
            , a.demand_group_id
            , a.late_type
            , a.descr
            , a.move_time_rate
            , a.buffer_time_rate
            , a.is_exception
            , a.is_consume
            , a.item
            , a.site
            , a.scm_site
            , a.demand_priority -- 20180621 추가     
            , a.project_code    -- 20210122 추가 
			, 'ALL'             -- 20210721 추가 (business type default = ALL)        
        FROM  (SELECT master_id
	                , plan_id 
	                , demand_id 
	                , sales_model_id
	                , shipping_date
	                , due_date
	                , due_fence_date
	                , early_producing_term
	                , early_producing_term_uom
	                , qty
	                , split_qty
	                , order_type
	                , demand_type
	                , producing_type
	                , priority_group_code
	                , priority
	                , attribute_checker_id
	                , demand_group_id
	                , late_type
	                , descr
	                , move_time_rate
	                , buffer_time_rate
	                , is_exception
	                , is_consume
	                , item
	                , site
	                , scm_site

                    , project_code
                 
                    , plant_site_id
                    , org_cell_site_id
                    , org_elec_site_id
         
                    , avg_setup_time
                    , cell_site_setup_group_id

                    , cell_site_id
                    , cell_item_id
         
                    , max_daily_capa
         
                    , demand_priority  -- 20180621 추가(DM의 우선순위)     
                    , division_id
         
                    , max_div_count  -- split 개수

                FROM   #th_eng_demand
                WHERE  dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-') = 'E' --전극일때
              ) a
           ,  #copy_t b
        WHERE  b.no <= a.max_div_count 
        ;        
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'split 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-----------------------------------------------------------
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		-- Split 여부 옵션화, 2021/05/26, By KKC
        -----------------------------------------------------------
		SKIP1:

		   DEMAND SPLIT DATA 생성 로직 주석 처리 ~ End
		 : Engine Custom에서 SPLIT_QTY 기준으로 SPLIT하는 로직 구현 
		2023.03.07 -----------------------------------------------------------*/

		/* 1이하 소숫점 처리, 2021.07.21 추가 */
        DELETE a
          FROM th_eng_net_demand_sn a 
         WHERE a.master_id = @p_master_id 
           AND a.plan_id   = @p_engine_plan_id 
		   AND CONVERT(NUMERIC, a.qty) = 0
        ;

		UPDATE a
		   SET a.qty = 1
		  FROM th_eng_net_demand_sn a 
		 WHERE a.master_id = @p_master_id 
		   AND a.plan_id   = @p_engine_plan_id 
		   AND a.qty < 1
		   AND CONVERT(NUMERIC, a.qty) = 1
	   ;

       ------------------------------------------------------------
        --임시테이블 삭제
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_demand') IS NOT NULL 
         BEGIN
            DROP TABLE #th_eng_demand;
         END
         
        IF OBJECT_ID('tempdb..#copy_t') IS NOT NULL 
         BEGIN
            DROP TABLE #copy_t;
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

