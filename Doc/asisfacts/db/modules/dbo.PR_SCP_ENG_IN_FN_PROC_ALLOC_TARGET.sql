
/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_ALLOC_TARGET
 * Description  : MAIN 버전 시 소형사업부 Allocation Traget 수량에 대응되는 Demand수량은 우선순위를 높인 RULE 유지 
                  FINAL 버전 시에는 Allocation 수량 대응하기 전 DEMAND 우선순위 기준으로 적용. 
				  - MAIN버전일때는 TH_BUF_NET_DEMAND 에 PRE PLAN ID를 MAIN PLAN ID로 생성하고
				  - FINAL버전일때는 FN버전의 TH_ENG_NET_DEMAND를 삭제하고 TH_BUF_NET_DEMAND에서 MAIN버전의 DATA를 가져와 반영해준다. 
 * OutTable     : th_eng_net_demand
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.01.12   LHS		    Initial Release
 * 2022.06.17   KKC			HP 로직 추가
 * 2023.02.14   SHS         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: 자동차 MA/SE 계획도 추가 / 8주 FP확정계획 변경
 * 2025.04.10   KJJ         E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_ALLOC_TARGET]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_ALLOC_TARGET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_NET_DEMAND'; 
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

    DECLARE @n_split_count       NUMERIC(20,10) = 1.0; -- demand split count

    /* 2022.06.17 Project code 유지여부 설정 변수 정의 */ 
    DECLARE @v_hp_pjt_code_yn        NVARCHAR(30) = 'N'   ;   

	/* SE 추가, 2023.02.14 */
	SELECT @v_hp_pjt_code_yn =            
           CASE WHEN  @p_plan_type = 'PR'  THEN (CASE WHEN ISNULL(SEGMENT2 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'MA'  THEN (CASE WHEN ISNULL(SEGMENT3 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'SE'  THEN (CASE WHEN ISNULL(SEGMENT4 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'FN'  THEN (CASE WHEN ISNULL(SEGMENT5 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'TE'  THEN (CASE WHEN ISNULL(ATTRIBUTE1 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )   
           END  
	FROM   scm_adm_lookup_master_detail a WITH(NOLOCK) 
	WHERE  a.lookup_type = 'HP_PJT_CODE_YN'
    AND    a.segment1    =  @p_division_id
    AND    a.valid_yn    = 'Y' 
    ; 

	/* ERROR 방지 코드 추가, 2023.02.14 */
	IF @v_hp_pjt_code_yn  IS NULL
		BEGIN
			SET @v_hp_pjt_code_yn = 'N';
		END

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
		
		/** 1. MAIN/SEMI 버전일때는 TH_BUF_NET_DEMAND에서 PRE PLAN 데이터를 MAIN PLAN 데이터로 생성	 
		 **/
		--IF   @p_plan_type = 'MA' 
		IF   @p_plan_type IN ('MA', 'SE') --소형 SE 추가시 고려, 2023.02.14
		BEGIN

			-- 현재 버전의 데이터가 있으면 삭제 (중복방지)
			DELETE /* PR_SCP_ENG_IN_FN_PROC_ALLOC_TARGET */
			FROM   th_buf_net_demand_sn 
			WHERE  master_id = @p_master_id 
			AND    plan_id   = @p_engine_plan_id 
			;

			-----------------------------------------------------------
			-- th_buf_net_demand_sn
			-----------------------------------------------------------
			INSERT INTO TH_BUF_NET_DEMAND_SN
			( 
					 MASTER_ID
					,PLAN_ID
					,DEMAND_ID
					,SALES_MODEL_ID
					,SHIPPING_DATE
					,DUE_DATE
					,DUE_FENCE_DATE
					,EARLY_PRODUCING_TERM
					,EARLY_PRODUCING_TERM_UOM
					,QTY
					,SPLIT_QTY
					,ORDER_TYPE
					,DEMAND_TYPE
					,PRODUCING_TYPE
					,PRIORITY_GROUP_CODE
					,PRIORITY
					,ATTRIBUTE_CHECKER_ID
					,DEMAND_GROUP_ID
					,LATE_TYPE
					,DESCR
					,MOVE_TIME_RATE
					,BUFFER_TIME_RATE
					,IS_EXCEPTION
					,IS_CONSUME
					,ITEM
					,SITE
					,SCM_SITE
					,DEMAND_PRIORITY
					,COMPLETED_SHIPPING_ID
					,PROJECT_CODE
					,ORG_PRIORITY
					,BUSINESS_TYPE
					,PLANT_TYPE --2025.04.10 추가
			) 
			SELECT A.MASTER_ID
				  , @p_engine_plan_id     AS plan_id
				  ,A.DEMAND_ID
				  ,A.SALES_MODEL_ID
				  ,A.SHIPPING_DATE
				  ,A.DUE_DATE
				  ,A.DUE_FENCE_DATE
				  ,A.EARLY_PRODUCING_TERM
				  ,A.EARLY_PRODUCING_TERM_UOM
				  ,A.QTY
				  ,A.SPLIT_QTY
				  ,A.ORDER_TYPE
				  ,A.DEMAND_TYPE
				  ,A.PRODUCING_TYPE
				  ,A.PRIORITY_GROUP_CODE
				  ,A.PRIORITY
				  ,A.ATTRIBUTE_CHECKER_ID
				  ,A.DEMAND_GROUP_ID
				  ,A.LATE_TYPE
				  ,A.DESCR
				  ,A.MOVE_TIME_RATE
				  ,A.BUFFER_TIME_RATE
				  ,A.IS_EXCEPTION
				  ,A.IS_CONSUME
				  ,A.ITEM
				  ,A.SITE
				  ,A.SCM_SITE
				  ,A.DEMAND_PRIORITY
				  ,A.COMPLETED_SHIPPING_ID
				  ,A.PROJECT_CODE
				  ,A.ORG_PRIORITY
				  ,A.BUSINESS_TYPE
				  ,A.PLANT_TYPE --2025.04.10 추가
			FROM   TH_BUF_NET_DEMAND_SN A WITH(NOLOCK) 
			WHERE  A.MASTER_ID = @p_master_id
			AND    plan_id     = @p_pre_engine_plan_id   
			; 
		
			-- TXN LOG
			SET @v_log_type    = 'TXN';
			SET @v_log_message = 'PART 1 END';
			SET @v_description = N'1. th_buf_net_demand_sn에 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count   = @@ROWCOUNT;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END ;    
		

		/** 2. FINAL버전일때는 (1) FN버전의 TH_ENG_NET_DEMAND를 삭제하고 (2)TH_BUF_NET_DEMAND에서 MA버전의 DATA를 가져와 FN버전으로 반영  
		 **/
		IF @p_plan_type = 'FN' 
		BEGIN 

			-- (1) th_eng_net_demand_sn 에서 FN버전 삭제 
			DELETE /* PR_SCP_ENG_IN_FN_PROC_ALLOC_TARGET */
			FROM   th_eng_net_demand_sn 
			WHERE  master_id = @p_master_id 
			AND    plan_id   = @p_engine_plan_id 
			;

			-- TXN LOG
			SET @v_log_type    = 'TXN';
			SET @v_log_message = 'PART 2.1 END';
			SET @v_description = N'2.1 th_eng_net_demand_sn DELETE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count   = @@ROWCOUNT;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-----------------------------------------------------------
			-- th_eng_net_demand_sn
			-----------------------------------------------------------

			INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_ALLOC_TARGET */ th_eng_net_demand_sn 
			(   master_id
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
			  , demand_priority        
			  , completed_shipping_id  
			  , project_code          
			  , business_type  
			  , PLANT_TYPE --2025.04.10 추가
			)
		   SELECT @p_master_id          AS master_id
				, @p_engine_plan_id     AS plan_id
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
				, demand_priority        
				, completed_shipping_id 
				, project_code          
				, business_type   
				, PLANT_TYPE --2025.04.10 추가
			FROM  th_buf_net_demand_sn WITH (NOLOCK)
			WHERE  master_id = @p_master_id
			AND    plan_id   = @p_pre_engine_plan_id
			;

			/* 2022.06.17, HP 로직 추가 */         
			UPDATE a 
			   SET a.business_type = CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND a.project_code != '-'  THEN a.project_code  ELSE 'ALL' END 
			  FROM th_eng_net_demand_sn A WITH(NOLOCK) 
			 WHERE a.master_id = @p_master_id
			   AND a.plan_id   = @p_engine_plan_id 
			; 

			-- TXN LOG
			SET @v_log_type    = 'TXN';
			SET @v_log_message = 'PART 2.2 END';
			SET @v_description = N'2.2 th_eng_net_demand_sn INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count   = @@ROWCOUNT;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END ; 



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

