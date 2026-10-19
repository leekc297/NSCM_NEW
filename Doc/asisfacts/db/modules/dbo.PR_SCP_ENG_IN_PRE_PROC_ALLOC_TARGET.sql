
/*        
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_ALLOC_TARGET
 * Description  : 소형사업부 Allocation Traget 수량에 대응되는 Demand수량은 우선순위를 높게 설정한다.
 *                1) Demand 수량 중 Customer Site에 있는 재고 , Intransit 재고에 대응하는 물량은 우선순위 그룹을 1순위로 한다.
 *                 - Net Demand 수량과 재고수량 비교 시 :  item, customer site 기준 적용.
 *                2) 재고와 매핑하고 남은 DEMAND 수량 중  ALLOC.TARGET 수량과 대응하는 물량은 우선순위 그룹을 2순위로 한다. 
 *                 - Net Demand 수량과 ALLOC.TARGET 수량과 비교 시 :  Item , Dept_id (영업 팀), 년월  기준 적용.
 *                 - Dept_ID는 ITEM, SALES SITE , PROJCET CODE로 담당자를 검색하고 (SCM_MST_SITE_ITEM) , 담당자의 소속을 검색한다. ( SCM_MST_SSO_USER_INFO )
 *                 - 년월 값 : Demand Due_date에서 Plant로의 max(bod.transport_time)을 뺀 날짜의 년월 = alloc.target의 년월 
 *                3) 그 외는 모두 3순위 그룹으로 한다. 
 *                4) 당 프로시저는 상위프로시저인 [PR_SCP_ENG_IN_PRE_ALL] 에서 lookup/'ALLO_TARGET_YN'항목의 'SEGMENT2 = 'Y' 인 경우만 수행한다. 
 * OutTable     : TH_ENG_NET_DEMAND (수정)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.12.06   LHS			Initial Release
 * 2022.01.12   LHS			FN버전 실행시 ALLOC 로직 적용 전 DEMAND PRIORITY 적용요청
 * 2025.04.21   KJJ         E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발 
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_ALLOC_TARGET]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_ALLOC_TARGET';
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

	    -----------------------------------------------------------
		-- 1. ALLOCTATION TARGET 당주꺼 가져오기.
		-- SCP_ANL_ALLO_TARGET 은 UI에서 PLAN값을 계속 변경할 수 있으므로 계획수행시점으로 DATA I/F 한다.
		-----------------------------------------------------------
		---- 동일한 버전 데이터 삭제
		DELETE /* PR_SCP_ENG_IN_PRE_PROC_ALLOC_TARGET */
		FROM   SCP_MST_ALLO_TARGET_SN 
		WHERE  1=1 
		AND    MASTER_ID       =  @p_master_id
		AND    PLAN_ID         =  @p_engine_plan_id
		; 
		
		-- TXN LOG
		SET @v_log_type = 'TXN';
		SET @v_log_message = 'PART 1-1 START';
		SET @v_description = N'1-1. scp_mst_allo_target에 당주 alloc.target정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		---- 당주 ALLOCTATION TARGET 가져오기.	
		INSERT INTO SCP_MST_ALLO_TARGET_SN
		(	   DIVISION_ID 
			 , MASTER_ID 
			 , PLAN_ID    
			 , TYPE 
			 , CUTOFF_YYYYMMDD
			 , YYYY
			 , YYYYQQ
			 , YYYYMM
			 , YYYYMMDD
			 , ITEM_ID
			 , DEPT_ID
			 , DEPT_NAME
			 , QTY
			 , NICK_NAME
			 , EXTRA_SPEC
			 , SCM_SITE_ID
			 , SCM_SITE_NAME
			 , CREATED_BY
			 , CREATION_DATE
			 , ATTRIBUTE1
			 , ATTRIBUTE2
			 , ATTRIBUTE3
			 , ATTRIBUTE4
			 , ATTRIBUTE5
			 , ATTRIBUTE6
			 , ATTRIBUTE7
			 , ATTRIBUTE8
			 , ATTRIBUTE9
			 , ATTRIBUTE10
		) 
		SELECT a.DIVISION_ID 
			 , @p_master_id       as MASTER_ID 
			 , @p_engine_plan_id  as PLAN_ID    
			 , a.TYPE 
			 , a.CUTOFF_YYYYMMDD
			 , a.YYYY
			 , a.YYYYQQ
			 , a.YYYYMM
			 , a.YYYYMMDD
			 , a.ITEM_ID
			 , a.DEPT_ID
			 , a.DEPT_NAME
			 , a.QTY
			 , a.NICK_NAME
			 , a.EXTRA_SPEC
			 , a.SCM_SITE_ID
			 , a.SCM_SITE_NAME
			 , 'PR_SCP_ENG_IN_PRE_PROC_ALLOC_TARGET' as CREATED_BY
			 , GETDATE() as CREATION_DATE
			 , a.ATTRIBUTE1
			 , a.ATTRIBUTE2
			 , a.ATTRIBUTE3
			 , a.ATTRIBUTE4
			 , a.ATTRIBUTE5
			 , a.ATTRIBUTE6
			 , a.ATTRIBUTE7
			 , a.ATTRIBUTE8
			 , a.ATTRIBUTE9
			 , a.ATTRIBUTE10
		FROM   SCP_ANL_ALLO_TARGET A WITH(NOLOCK)  
		WHERE  A.DIVISION_ID     = @p_division_id  --'40' 
		AND    A.CUTOFF_YYYYMMDD = @v_cur_monday   --+ 월요일 기준.
		AND    A.TYPE         = 'PLAN' 
		AND    A.QTY          > 0 
		AND    EXISTS ( SELECT 1                                        --+ DEPT_ID에 TOTAL, SUBTOTAL, NULL값 제거용
						FROM   SCM_MST_SSO_USER_INFO U WITH(NOLOCK)  
						WHERE  ISNULL(U.DEPT_ID,'') <> '' 
						AND    U.DEPT_ID             = A.DEPT_ID 
						) 
		; 

	    -----------------------------------------------------------
		-- 2. ENG_NET_DEMAND 기준 정보생성
		-----------------------------------------------------------    

		-----------------------------------------------------------
		-- (2022.01.12) FN버전 실행시 ALLOC 로직 적용 전 DEMAND PRIORITY 적용요청 - 고원택 책임.
		-- FN 수행 시 ALLO로직 적용하기 전 NET_DEMAND PRIORITY를 사용하기 위해 원본 데이터를 BACKUP 한다. 
		-----------------------------------------------------------
			   
		---- 2.0 th_eng_net_demand 백업

		---- 중복 데이터 삭제 
		DELETE /* PR_SCP_ENG_IN_PRE_PROC_ALLOC_TARGET */
		FROM   TH_BUF_NET_DEMAND_SN
		WHERE  MASTER_ID  = @p_master_id      -- '40::WEEKLY'
		AND    PLAN_ID    = @p_engine_plan_id -- '1211::PR::1'
		; 

		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 2-0 START';
		SET @v_description = N'2-0. th_buf_net_demand에 th_eng_net_demand INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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
				,PLANT_TYPE --2025.04.21 추가
		) 
		SELECT A.MASTER_ID
			  ,A.PLAN_ID
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
			  ,A.PLANT_TYPE --2025.04.21 추가
		FROM   TH_ENG_NET_DEMAND_SN A WITH(NOLOCK) 
		WHERE  A.MASTER_ID = @p_master_id        --'40::WEEKLY'
		AND    A.PLAN_ID   = @p_engine_plan_id   --'1211::PR::1'    
		; 


		---- 2.1 eng_net_demand + Dept_id 정보 생성

		---- 중복 데이터 삭제 
		DELETE /* PR_SCP_ENG_IN_PRE_PROC_ALLOC_TARGET */
		FROM   TH_BUF_NET_DEMAND_ALLOC_SN
		WHERE  MASTER_ID  = @p_master_id      -- '40::WEEKLY'
		AND    PLAN_ID    = @p_engine_plan_id -- '1211::PR::1'
		; 
			       	
		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 2-1 START';
		SET @v_description = N'2-1. th_buf_net_demand_alloc에 net_demand INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		INSERT INTO TH_BUF_NET_DEMAND_ALLOC_SN
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
				,DM_CUM1
				,DEPT_ID
				,PLANT_TYPE --2025.04.21 추가
		) 
		SELECT A.MASTER_ID
			  ,A.PLAN_ID
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
			  ,A.DM_CUM1
			  ,B.DEPT_ID
			  ,A.PLANT_TYPE --2025.04.21 추가
		 FROM  (
				SELECT A.*
					 , SUM(QTY) OVER(PARTITION BY MASTER_ID , PLAN_ID, ITEM, SITE  ORDER BY DUE_DATE , PRIORITY, DEMAND_ID ) as dm_cum1
				FROM   TH_ENG_NET_DEMAND_SN A WITH(NOLOCK) 
				WHERE  A.MASTER_ID = @p_master_id        --'40::WEEKLY'
				AND    A.PLAN_ID   = @p_engine_plan_id   --'1211::PR::1'    
			  ) A
		LEFT OUTER JOIN
				(--// ITEM, SALES SITE , PROJCET CODE로 담당 부서 검색.//--
				SELECT A.DIVISION_ID , A.PROJECT_CODE , A.SCM_SITE_ID , A.ITEM_ID , A.OWNER , U.DEPT_ID 
				FROM   SCM_MST_SITE_ITEM A WITH(NOLOCK) 
					,  SCM_MST_SSO_USER_INFO U WITH(NOLOCK)  
				WHERE 1 = 1
				AND   A.OWNER       =  U.USER_ID
				AND   A.VALID_YN    = 'Y' 
				AND   A.DIVISION_ID = @p_division_id   -- '40' 
				) B
				ON ( 1=1
				AND  A.ITEM  =  B.ITEM_ID 
				AND  A.SCM_SITE = B.SCM_SITE_ID
				AND  A.PROJECT_CODE = B.PROJECT_CODE ) 	
		WHERE  1=1
		; 

		---- 2.2 BOD의 MAX(TRANSPORT TIME) 값 검색.
		/** 고객향 BOD LT 선택: TO_SITE_ID (SALES) 기준 BOD 우선순위가 빠르고 이동시간이 MAX인 값 하나 선택 
		                     : BOD_ALT_PRIORITY ASC + 이동시간 DESC + BOD_ID ASC (중복제거용) 순으로 1순위를 취함 **/

		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 2-2 START';
		SET @v_description = N'2-2. th_buf_net_demand_alloc에 bod MAX(lt) UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A 
		SET    A.TRANSPORT_TIME     =  B.TRANSPORT_TIME 
			 , A.TRANSPORT_TIME_UOM =  B.TRANSPORT_TIME_UOM 
			 , A.BOD_LT_DATE        =  DATEADD( DD, -B.TRANSPORT_TIME , A.DUE_DATE) 
			 , A.DM_LT_YYYYMM       =  CONVERT(CHAR(6), DATEADD( DD, -B.TRANSPORT_TIME , A.DUE_DATE), 112) 
		FROM  TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK)   
		LEFT OUTER JOIN 
			  ( 
				SELECT A.MASTER_ID , A.PLAN_ID  , A.FROM_SITE_ID , A.TO_SITE_ID, A.BOD_ID , A.TRANSPORT_MODE , A.TRANSPORT_TIME , A.TRANSPORT_TIME_UOM  
					 , B.ITEM_ID, B.ALT_PRIORITY 
					 , ROW_NUMBER() OVER(PARTITION BY B.MASTER_ID, B.PLAN_ID, B.ITEM_ID, TO_SITE_ID
										 ORDER BY B.ALT_PRIORITY, A.TRANSPORT_TIME DESC, A.BOD_ID ) AS PRI_RANK  --+ 1순위 LT 검색용
				FROM   (
						SELECT A.MASTER_ID , A.PLAN_ID , A.TO_SITE_ID , A.FROM_SITE_ID , A.BOD_ID , A.TRANSPORT_MODE , A.TRANSPORT_TIME , A.TRANSPORT_TIME_UOM  
						FROM   TH_ENG_BOD_SN A WITH(NOLOCK) 
						WHERE  A.MASTER_ID  = @p_master_id        --'40::WEEKLY' 
						AND    A.PLAN_ID    = @p_engine_plan_id   --'1211::PR::1' 
						AND    EXISTS ( SELECT 1
										FROM   SCM_MST_SITE_ENG X WITH(NOLOCK)   --- FROM_SITE가 외주 아닌 PLANT 인 경우
										WHERE  1=1
										AND    X.MODELING_ID  = @p_modeling_id   -- '1'
										AND    X.DIVISION_ID  = @p_division_id   --'40'
										AND    X.PLAN_ID      = @p_plan_id       --'1211' 
										AND    X.PLAN_TYPE    = @p_plan_type     --'PR' 
										AND    X.PLAN_SEQ     = @p_seq           --'1' 
										AND    X.VALID_YN     = 'Y' 
										AND    X.OSP_YN       = 'N' 
										AND    X.SITE_TYPE    = 'PLANT' 
										AND    X.ENG_SCM_SITE_ID  = A.FROM_SITE_ID ) 
						AND    EXISTS ( SELECT 1
										FROM   SCM_MST_SITE_ENG Y WITH(NOLOCK)     --- TO_SITE가 고객인 경우
										WHERE  1=1
										AND    Y.MODELING_ID  = @p_modeling_id   -- '1'
										AND    Y.DIVISION_ID  = @p_division_id   --'40'
										AND    Y.PLAN_ID      = @p_plan_id       --'1211' 
										AND    Y.PLAN_TYPE    = @p_plan_type     --'PR' 
										AND    Y.PLAN_SEQ     = @p_seq           --'1' 
										AND    Y.VALID_YN     = 'Y' 
										AND    Y.SITE_TYPE    = 'SALES' 
										AND    Y.ENG_SCM_SITE_ID  = A.TO_SITE_ID ) 
					  ) A
				LEFT OUTER JOIN  
					  ( SELECT * 
						FROM   TH_ENG_ITEM_BOD_SN B WITH(NOLOCK) 
						WHERE  B.MASTER_ID  = @p_master_id       --'40::WEEKLY'  
						AND    B.PLAN_ID    = @p_engine_plan_id  --'1211::PR::1'
						) B
						ON ( 1=1
						AND  A.MASTER_ID = B.MASTER_ID
						AND  A.PLAN_ID   = B.PLAN_ID
						AND  A.BOD_ID    = B.BOD_ID 	) 

			  ) B 
				ON ( 1=1
				AND  A.MASTER_ID  = B.MASTER_ID
				AND  A.PLAN_ID    = B.PLAN_ID
				AND  A.ITEM       = B.ITEM_ID
				AND  A.SITE       = B.TO_SITE_ID
				AND  B.PRI_RANK   = '1'   ) 
		WHERE  1=1
		AND    A.MASTER_ID  = @p_master_id       --'40::WEEKLY'  
		AND    A.PLAN_ID    = @p_engine_plan_id  --'1211::PR::1'
		; 

		---- DUE_DATE에서 이동시간을 뺀 날짜(DM_LT_YYYYMM)과 과거일 경우 당월로 변경해준다.
		UPDATE A   
		SET    A.DM_LT_YYYYMM = SUBSTRING(@p_plan_name , 1, 6) 
		FROM   TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK) 
		WHERE  1=1
		AND    A.MASTER_ID  = @p_master_id       --'40::WEEKLY'  
		AND    A.PLAN_ID    = @p_engine_plan_id  --'1211::PR::1'
		AND    A.DM_LT_YYYYMM < SUBSTRING(@p_plan_name , 1, 6)  
		; 


		---- 2.3 STOCK 수량 가져오기.
		/** CUSTOMER_SITE, ITEM별 STOCK 수량 집계(일자 구분없이 합계수량을 취함) -> 동일조건으로 NET_DEMAND와 매핑 **/ 

		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 2-3 START';
		SET @v_description = N'2-3. th_buf_net_demand_alloc에 Stock수량 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		SET    A.STOCK_QTY = ISNULL(B.STOCK_QTY,0)
		FROM   TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK) 
		LEFT OUTER JOIN	
			  ( 
				SELECT A.MASTER_ID , A.PLAN_ID , A.ITEM_ID , A.SITE_ID, A.SCM_SITE_ID ,SUM(A.QTY) AS STOCK_QTY 
				FROM   (
						SELECT A.MASTER_ID , A.PLAN_ID , A.ITEM_ID , A.SITE_ID , X.SCM_SITE_ID , A.RECEIVING_DTTM , A.QTY , CONVERT(CHAR(7) , A.RECEIVING_DTTM, 23) AS YYYYMM , A.DESCR AS GBN   
						FROM   TH_ENG_STOCK_PLAN_SN A WITH(NOLOCK) 
							 , SCM_MST_SITE_ENG X WITH(NOLOCK)	
						WHERE 1=1
						AND   A.MASTER_ID  =  @p_master_id  --'40::WEEKLY'  
						AND   A.PLAN_ID    =  @p_engine_plan_id  --'1211::PR::1' 
						AND  ( SUBSTRING(A.DESCR,1,2) = 'WH' OR SUBSTRING(A.DESCR,1,3) = 'INT' )  --- WH: 창고재고, INT: INTRANSIT 
						AND   X.MODELING_ID  = @p_modeling_id    --'1' 
						AND   X.DIVISION_ID  = @p_division_id  --'40' 
						AND   X.PLAN_ID      = @p_plan_id    --'1211'
						AND   X.PLAN_TYPE    = @p_plan_type  --'PR'
						AND   X.PLAN_SEQ     = @p_seq        --'1' 
						AND   X.SITE_TYPE    = 'SALES'
						AND   X.VALID_YN     = 'Y'
						AND   X.ENG_SCM_SITE_ID = A.SITE_ID
						) A
				WHERE 1=1		
				GROUP BY A.MASTER_ID , A.PLAN_ID , A.ITEM_ID , A.SITE_ID, A.SCM_SITE_ID 
			  ) B
				ON  (1=1
				AND  A.MASTER_ID = B.MASTER_ID
				AND  A.PLAN_ID   = B.PLAN_ID 
				AND  A.ITEM  = B.ITEM_ID 
				AND  A.SITE  = B.SITE_ID ) 
		WHERE A.MASTER_ID =  @p_master_id  --'40::WEEKLY'
		AND   A.PLAN_ID   =  @p_engine_plan_id   --'1211::PR::1'
		; 

		---- 2.4 ALLOCATION TARGET 수량 가져오기.
		/** ITEM, DEPT_ID, YYYYMM 기준의 TARGET수량 집계 -> 동일조건으로 NET_DEMAND와 매핑 **/

		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 2-4 START';
		SET @v_description = N'2-4. th_buf_net_demand_alloc에 Alloc.Target수량 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		SET    A.ALLOC_TARGET_QTY  =  ISNULL(B.ALLOC_TARGET_QTY,0)
		FROM   TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK) 
		LEFT OUTER JOIN (
				SELECT A.YYYYMM , A.ITEM_ID , A.DEPT_ID , CEILING(SUM(QTY)) AS ALLOC_TARGET_QTY    --+ 소수점이 나오면 올림처리.
				FROM   SCP_MST_ALLO_TARGET_SN A WITH(NOLOCK)
				WHERE  A.DIVISION_ID = @p_division_id
				AND    A.MASTER_ID   = @p_master_id
				AND    A.PLAN_ID     = @p_engine_plan_id
				GROUP BY  A.YYYYMM , A.ITEM_ID , A.DEPT_ID
			  ) B 
				ON ( 1=1
				AND  B.ITEM_ID = A.ITEM
				AND  B.DEPT_ID = A.DEPT_ID 
				AND  B.YYYYMM  = A.DM_LT_YYYYMM
				 ) 
		WHERE A.MASTER_ID = @p_master_id       --'40::WEEKLY'
		AND   A.PLAN_ID   = @p_engine_plan_id  --'1211::PR::1'
		; 

	    -----------------------------------------------------------
		-- 3.  NET_DEMAND와 STOCK, ALLOC.TARGET 수량 매핑 후 NET_DEMAND PRIORITY 재 설정
		-----------------------------------------------------------        
		
		-- ## Stock과 매핑된 demand 수량 산출  -> 1순위 그룹으로 지정할 대상수량 (STOCK_ASSIGN)
		/** 재고정보 집계기준(item , sales_site)별 재고수량과 net_demand의 priority 기준으로 정렬한 Demand 수량을 차례로 매핑 
		 ** Net Demand누계와 재고수량의 차이(CAL_DMCUM_STOCK)가 음수면 Demand 전량 매핑된 것이고,
		 ** CAL_DMCUM_STOCK값이 양수고 demand qty보다 작으면 (demand qty -CAL_DMCUM_STOCK)값이 매핑된 수량이고 그 외는 매핑된 수량이 0  이다. 
		 **/

		---- 3.1 재고수량 매핑 
		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 3-1 START';
		SET @v_description = N'3-1. th_buf_net_demand_alloc에 Stock 매핑수량 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		SET    A.STOCK_ASSIGN    = B.STOCK_ASSIGN
			 , A.DM_REMAIN1      = B.DM_REMAIN1 
			 , A.CAL_DMCUM_STOCK = B.CAL_DMCUM_STOCK   
		FROM  TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK) 
		LEFT OUTER JOIN ( 
				SELECT A.MASTER_ID , A.PLAN_ID , A.DEMAND_ID , A.ITEM , A.SITE , A.DUE_DATE , A.PRIORITY  , A.QTY , A.DM_CUM1 , A.STOCK_QTY 
					 , A.DM_CUM1 - A.STOCK_QTY    AS CAL_DMCUM_STOCK    --+  디맨드 누계 - 재고수량 
					 , IIF((A.DM_CUM1 - A.STOCK_QTY ) <0 , A.QTY , IIF( (A.QTY - (A.DM_CUM1 - A.STOCK_QTY))<0,0, (A.QTY - (A.DM_CUM1 - A.STOCK_QTY))  )
						  ) AS STOCK_ASSIGN     --+ 재고 할당된 수량 
					 , A.QTY - (IIF((A.DM_CUM1 - A.STOCK_QTY ) <0 , A.QTY , IIF((A.QTY - (A.DM_CUM1 - A.STOCK_QTY)) <0,0, (A.QTY - (A.DM_CUM1 - A.STOCK_QTY)))))     AS DM_REMAIN1   --+ 재고차감 후 디맨드 잔량
				FROM   TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK)  
				WHERE A.MASTER_ID = @p_master_id       --'40::WEEKLY'
				AND   A.PLAN_ID   = @p_engine_plan_id  --'1211::PR::1'
			  ) B
			  ON ( 1=1 
			  AND  A.MASTER_ID = B.MASTER_ID
			  AND  A.PLAN_ID   = B.PLAN_ID
			  AND  A.DEMAND_ID = B.DEMAND_ID  ) 
		WHERE A.MASTER_ID = @p_master_id       --'40::WEEKLY'
		AND   A.PLAN_ID   = @p_engine_plan_id  --'1211::PR::1'
		; 


		--  ## Allocation Target과 매핑된 demand 수량 산출  -> 2순위 그룹 지정대상
		/** Alloc.Target집계 기준 (item, dept_id, 년월)별 Target수량과 net_demand의 priority 기준으로 정렬한 Demand 수량을 차례로 매핑.  
		 ** Net Demand의 잔량누계(dm_cum2)와 Alloc.Target수량의 차이(CAL_DMCUM2_ALLOC)가 음수면 Demand 준량이 매핑된 것이고,
		 ** CAL_DMCUM2_ALLOC이 양수고 demand 잔량보다 작으면 ( demand_잔량 - CAL_DMCUM2_ALLOC ) 값이 매핑된 수량이고 그 외는 매핑된 수량이 0 이다.
		 **/
		
		---- 3.2 DEMAND 잔량의 누계: alloc target수량과 매핑하기 위한  ( 아이템, 팀, 년월 ) 기준으로 누계 산출
		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 3-2 START';
		SET @v_description = N'3-2. th_buf_net_demand_alloc에 demand잔량 누계값 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		SET    A.DM_CUM2 =  B.dm_cum2
		FROM   TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK)  
		INNER JOIN ( 
				SELECT A.MASTER_ID , A.PLAN_ID , A.DEMAND_ID , A.ITEM , A.DEPT_ID, A.DM_LT_YYYYMM, A.DUE_DATE , A.PRIORITY , A.DM_REMAIN1 
					 , SUM(DM_REMAIN1) OVER(PARTITION BY MASTER_ID , PLAN_ID, ITEM, DEPT_ID, DM_LT_YYYYMM  ORDER BY DUE_DATE , PRIORITY, DEMAND_ID ) as dm_cum2
				FROM   TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK)   
				WHERE A.MASTER_ID = @p_master_id       --'40::WEEKLY'
				AND   A.PLAN_ID   = @p_engine_plan_id  --'1211::PR::1'
			  ) B 
				ON ( 1=1
				AND  B.MASTER_ID = A.MASTER_ID
				AND  B.PLAN_ID   = A.PLAN_ID 
				AND  B.DEMAND_ID = A.DEMAND_ID		) 
		WHERE A.MASTER_ID = @p_master_id       --'40::WEEKLY'
		AND   A.PLAN_ID   = @p_engine_plan_id  --'1211::PR::1'
		; 

		---- 3.3 Allocation Target과 매핑 : STOCK 매핑후 DEMAND잔량과 매핑. 2순위 그룹으로 설정할 대상 수량(ALLOC_ASSIGN)이 산출됨.
		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 3-3 START';
		SET @v_description = N'3-3. th_buf_net_demand_alloc에 alloc.target 매핑수량 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A 
		SET    A.CAL_DMCUM2_ALLOC  =  B.CAL_DMCUM2_ALLOC
			 , A.ALLOC_ASSIGN      =  B.ALLOC_ASSIGN
			 , A.DM_REMAIN2        =  B.DM_REMAIN2 
		FROM  TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK)   
		LEFT OUTER JOIN ( 
				SELECT A.MASTER_ID , A.PLAN_ID , A.DEMAND_ID , A.ITEM , A.DEPT_ID , A.DM_LT_YYYYMM , A.SITE , A.DUE_DATE , A.PRIORITY , DM_REMAIN1 , DM_CUM2 , A.ALLOC_TARGET_QTY
					 , A.DM_CUM2 - A.ALLOC_TARGET_QTY  AS CAL_DMCUM2_ALLOC
					 , IIF((A.DM_CUM2 - A.ALLOC_TARGET_QTY)<0 ,A.DM_REMAIN1,IIF(A.DM_REMAIN1-( A.DM_CUM2 - A.ALLOC_TARGET_QTY )<0 , 0 , A.DM_REMAIN1-( A.DM_CUM2 - A.ALLOC_TARGET_QTY ) )  ) AS ALLOC_ASSIGN  
					 , DM_REMAIN1 - IIF((A.DM_CUM2 - A.ALLOC_TARGET_QTY)<0 ,A.DM_REMAIN1,IIF(A.DM_REMAIN1-( A.DM_CUM2 - A.ALLOC_TARGET_QTY )<0 , 0 , A.DM_REMAIN1-( A.DM_CUM2 - A.ALLOC_TARGET_QTY )))  AS DM_REMAIN2  
				FROM   TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK)  
				WHERE A.MASTER_ID = @p_master_id       --'40::WEEKLY'
				AND   A.PLAN_ID   = @p_engine_plan_id  --'1211::PR::1'
			  ) B 
				ON ( 1=1 
				AND  A.MASTER_ID =  B.MASTER_ID
				AND  A.PLAN_ID   =  B.PLAN_ID
				AND  A.DEMAND_ID =  B.DEMAND_ID )
		WHERE A.MASTER_ID = @p_master_id       --'40::WEEKLY'
		AND   A.PLAN_ID   = @p_engine_plan_id  --'1211::PR::1'
		; 



		-- ## Net_Demand의 Priority 값 재 설정 부분 
		/** Net Demand 전체를 기본값인 3순위로 설정하고 (PRIORYT = '3'+ PRIORITY , PRIORITY_GROUP_CODE = '3'+PRIORITY_GROUP_CODE) ,  
		 ** 1순위 대상 INSERT : demand id = demand id+'^G1', qty(=STOCK_ASSIGN), PRIORYT = '1'+ PRIORITY , PRIORITY_GROUP_CODE = '1'+PRIORITY_GROUP_CODE
		 ** 2순위 대상 INSERT : demand id = demand id+'^G2', qty(=ALLOC_ASSIGN), PRIORYT = '2'+ PRIORITY , PRIORITY_GROUP_CODE = '2'+PRIORITY_GROUP_CODE
		 ** 나머지는 3순위 수량인 DM_REMAIN2 로 QTY UPDATE 후 QTY값이 0 인 데이터를 삭제한다. 
		 **/

		---- 3.4  기본 3순위 값으로 전체 설정.
		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 3-4 START';
		SET @v_description = N'3-4. th_eng_net_demand에 priority를 기본 3순위로 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		SET    A.PRIORITY_GROUP_CODE = '3'+ A.PRIORITY_GROUP_CODE 
			 , A.PRIORITY            = '3'+ A.PRIORITY 
		FROM   TH_ENG_NET_DEMAND_SN A 
		WHERE A.MASTER_ID = @p_master_id    --'40::WEEKLY'
		AND   A.PLAN_ID   = @p_engine_plan_id --'1211::PR::1'
		; 


		---- 3.5  1순위 대상 INSERT : Stock 매핑분 demand 생성
		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 3-5 START';
		SET @v_description = N'3-5. th_eng_net_demand에 1순위 대상 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		INSERT INTO TH_ENG_NET_DEMAND_SN
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
				,PLANT_TYPE --2025.04.21 추가
		) 
		SELECT 
				 A.MASTER_ID
				,A.PLAN_ID
				,A.DEMAND_ID + '^G1'  AS DEMAND_ID 
				,A.SALES_MODEL_ID 
				,A.SHIPPING_DATE
				,A.DUE_DATE
				,A.DUE_FENCE_DATE
				,A.EARLY_PRODUCING_TERM
				,A.EARLY_PRODUCING_TERM_UOM
				,A.STOCK_ASSIGN  AS QTY
				,A.STOCK_ASSIGN  AS SPLIT_QTY
				,A.ORDER_TYPE
				,A.DEMAND_TYPE
				,A.PRODUCING_TYPE
				,'1'+ A.PRIORITY_GROUP_CODE  AS PRIORITY_GROUP_CODE 
				,'1'+ A.PRIORITY AS PRIORITY
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
				,A.PLANT_TYPE --2025.04.21 추가
		FROM  TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK)  
		WHERE A.MASTER_ID    = @p_master_id       --'40::WEEKLY'
		AND   A.PLAN_ID      = @p_engine_plan_id  --'1211::PR::1'
		AND   A.STOCK_ASSIGN > 0  
		; 

		---- 3.6  2순위 대상 INSERT : Allocation Target 매핑분 demand 생성
		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 3-6 START';
		SET @v_description = N'3-6. th_eng_net_demand에 2순위 대상 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		INSERT INTO TH_ENG_NET_DEMAND_SN
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
				,PLANT_TYPE --2025.04.21 추가
		) 
		SELECT 
				 A.MASTER_ID
				,A.PLAN_ID
				,A.DEMAND_ID + '^G2'  AS DEMAND_ID 
				,A.SALES_MODEL_ID 
				,A.SHIPPING_DATE
				,A.DUE_DATE
				,A.DUE_FENCE_DATE
				,A.EARLY_PRODUCING_TERM
				,A.EARLY_PRODUCING_TERM_UOM
				,A.ALLOC_ASSIGN  AS QTY
				,A.ALLOC_ASSIGN  AS SPLIT_QTY
				,A.ORDER_TYPE
				,A.DEMAND_TYPE
				,A.PRODUCING_TYPE
				,'2'+ A.PRIORITY_GROUP_CODE  AS PRIORITY_GROUP_CODE 
				,'2'+ A.PRIORITY AS PRIORITY
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
				,A.PLANT_TYPE --2025.04.21 추가
		FROM   TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK)  
		WHERE A.MASTER_ID    = @p_master_id       --'40::WEEKLY'
		AND   A.PLAN_ID      = @p_engine_plan_id  --'1211::PR::1'
		AND   A.ALLOC_ASSIGN > 0  
		; 


		---- 3.7  Stock, Alloc.Target 물량까지 매핑 후 남은 Demand수량으로 UPDATE 
		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 3-7 START';
		SET @v_description = N'3-7. th_eng_net_demand의 qty를 매핑후 잔량으로 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE  A 
		SET     A.QTY       = B.DM_REMAIN2 
			  , A.SPLIT_QTY = B.DM_REMAIN2 
		FROM    TH_ENG_NET_DEMAND_SN A WITH(NOLOCK) 
		INNER JOIN (
				select * 
				FROM   TH_BUF_NET_DEMAND_ALLOC_SN A WITH(NOLOCK)  
				WHERE A.MASTER_ID    = @p_master_id       --'40::WEEKLY'
				AND   A.PLAN_ID      = @p_engine_plan_id  --'1211::PR::1'
				AND  (A.STOCK_ASSIGN > 0 OR A.ALLOC_ASSIGN > 0 ) 
			  ) B
				ON ( 1=1
				AND  A.MASTER_ID  =  B.MASTER_ID
				AND  A.PLAN_ID    =  B.PLAN_ID 
				AND  A.DEMAND_ID  =  B.DEMAND_ID  ) 
		WHERE A.MASTER_ID    = @p_master_id       --'40::WEEKLY'
		AND   A.PLAN_ID      = @p_engine_plan_id  --'1211::PR::1'
		; 



		---- 3.8  DEMAND 수량이 0 인 데이터 삭제. 
		-- TXN LOG
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'PART 3-8 START';
		SET @v_description = N'3-8. th_eng_net_demand의 qty=0인 경우 DELETE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		DELETE /* PR_SCP_ENG_IN_PRE_PROC_ALLOC_TARGET */ 
		FROM   TH_ENG_NET_DEMAND_SN  
		WHERE  MASTER_ID  = @p_master_id       --'40::WEEKLY'
		AND    PLAN_ID    = @p_engine_plan_id  --'1211::PR::1'
		AND    QTY        = 0 
		; 


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
