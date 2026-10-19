
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_FIX_MISMATCHING
 * Description  : INPUT 데이터 처리후 후처리작업(엔진요청작업) 모음

                  -------------------------------------------------
                  -- 1  엔진요청 임시실행모음 및 기타
                  -------------------------------------------------
                     1-1 ITEM 임시변경

                  -------------------------------------------------
                  -- 2. Cell Biz Demand 의 Late 계획수립 결과와 관련한 모델링 변경 처리에 필요한 후처리( 티라에서 생성한 쿼리 그대로 사용함)
                  -------------------------------------------------
                    
                    13-2. TH_ENG_FIXED_PLAN [UPDATE]
                        1) WORK_ORDER_SEQ 재설정
                          - 전극(E) 생산공정 : '10000'
                          - 전극(E) → CELL(A) 물류공정 : '20000'
                          - CELL(A) 생산공정 : '30000'
                          - CELL(A) → PACK(P) 물류공정 : '40000'
                          - CELL(A) → Sales Site 물류공정 : '40000'
                          - PACK(P) 생산공정 : '50000'
                          - CELL(A) 가상공정 : '50000'
                          - PACK(P) → Sales Site 물류공정 : '60000'"
                   
                 -------------------------------------------------
                 -- 3. fixed_plan split
                 -------------------------------------------------
                    -- 1) split 대상
                          - 1)  셀, 전극 ITEM
                          - 2)  split 개수
                                - 셀   : 20000
                                - 전극 : 20000
                                 
                          - 3)  work_order_id :   work_order_id + '_' + numbering
                          - 4)  start_dttm : plan종료일 (@v_pet_date) 
                           
                  -------------------------------------------------
                  -- 4. Production Lot Size 설정
                  -------------------------------------------------

                    4-1. TH_ENG_ITEM_ROUTE_SITE [UPDATE]
 
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.25   KSW         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.07.11   KSW         th_eng_fixed_plan SPLIT작업추가
 * 2018.07.12   KSW         a.start_dttm >= CONVERT(DATETIME, @v_pet_date)  (변경전 : .start_dttm = CONVERT(DATETIME, @v_pet_date) )
 * 2018.09.20   KSG         TH_ENG_ITEM_ROUTE_SITE - Lot Size UPDATE 추가 수정
 * 2018.11.07   KSW         ITEM 변경 대상 및 변경값을 하드코딩에서 LOOKUP테이블로 변경함(참고)주석1-1
 * 2019.02.18   KSW         Production Lot Size 설정부분의 조회조건 변경(th_eng_product_mix_sn.descr='OSP'조회조건추가) (참고)주석4
 * 2019.08.01   KSG         OSP Production Lot Size 적용 제거
 * 2019.09.20   KKC         ①전체 W/O의 WORK_ORDER_SEQ 채번 Update 변경
 * 2019.11.11   KKC         1. Pack Site 중 Cell→Pack BOD확정계획과 Pack 생산확정계획의 WORK_ORDER_GROUP 변경
                            2. 속도 문제로 일괄쿼리를 분리해서 Update하는 로직으로 변경
 * 2020.03.11   KKC         W/O SEQ Update Query 중복제거 및 계획 순서 조정
 * 2021.07.21   KKC         Business Type = ALL Update (엔진신규패치 기능으로 Default값 설정)
                             -> 추후 해당 테이블블 프로시져 Business Type 값 활용시 주석 처리 필요 
 * 2022.04.29   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 무한CAPA일 경우 TIME_UOM = 'DAY'로 설정 (엔진 패치)
 * 2023.05.31   KKC         PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 개발 임시(n-ERP 1차 데이터 변경, 7월한시적)
 * 2023.07.07	SHS			PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행: 7월 오픈 임시 모델링 로직 정리
 * 2024.11.07   KKC         PJ20249346   LGES SCP 개선과제 이행 : PET(엔진계획구간의 종료일)이후 FIXED PLAN SPLIT 로직 제거 및 보완
                            - 전극은 불필요한 로직(fixed plan split) 및 END DTTM이 Add PET를 넘는 이상 CASE 제거
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_FIX_MISMATCHING]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_FIX_MISMATCHING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = '';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_cur_wednesday     NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'WED')), 112); -- 당주 수요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date

	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- Add Plan End Date, 2024.11.07 추가
    DECLARE @v_plan_group        NVARCHAR(100) = '-'; -- Plan Group : PJ20230691 도전과제 계획 포함. 2024.11.07 추가	

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
        ---------------------------------------------
        -- PJ20230691 도전과제 계획 추가용 기간 설정
		---------------------------------------------
		SELECT @v_plan_group = ISNULL(segment5, '-')
		FROM   scm_adm_lookup_master_detail a(nolock)
		WHERE  a.lookup_type = 'PLAN_TYPE'
		AND    a.segment1    = @p_plan_type
		AND    a.valid_yn    = 'Y'
        ;

        /* eng 전체 peg 계획로직(add period가 설정된 것을 포함), 2024.11.07 */
        SELECT @v_pet_date      = CASE WHEN @v_plan_group = 'BIZ' THEN p.attribute1
                                       ELSE p.horizon_end_date 
                                  END
			,  @v_add_pet_date  = CASE WHEN @v_plan_group = 'BIZ' 
                                       THEN CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(b.add_day, (13*7)), CONVERT(DATETIME, p.attribute1)), 112)
                                       ELSE CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(b.add_day, (13*7)), CONVERT(DATETIME, p.horizon_end_date)), 112) -- 추가기간이 NULL이면 디폴트 13주 설정
                                  END	
	      FROM dbo.scm_mst_plan p WITH(NOLOCK)
		/** (2022.01.26) 사업부별 추가계획기간 lookup으로 반영  **/ 
		LEFT OUTER JOIN 
			  (
				SELECT a.segment1 as DIVISION_ID 
                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 13 THEN 13
                            ELSE a.segment2 
                       END AS ADD_WEEK
                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 13 THEN (13*7)
                            ELSE (a.segment2 * 7)
                       END AS ADD_DAY
				 FROM scm_adm_lookup_master_detail a(nolock)
			    WHERE a.lookup_type = 'ADD_PLAN_PERIOD'
				  AND a.valid_yn    = 'Y' 
			  ) b
		    ON ( 1=1
		   AND  p.DIVISION_ID =  b.DIVISION_ID )  
         WHERE  p.division_id = @p_division_id 
          AND   p.plan_id     = @p_plan_id 
		; 
        /* org ~ 2024.11.07 이전
        SELECT @v_pet_date = p.horizon_end_date
        FROM   dbo.scm_mst_plan p WITH (NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
        */

        ------------------------------------------------------------------------------------------
        -- 1. 엔진요청 임시실행모음 및 기타
        ------------------------------------------------------------------------------------------
       
        ----------------------------------------------------------
        -- 1-1  ITEM 임시변경
        
        --      20181107 추가 (변경item LOOKUP 테이블처리로변경)
                /*
                (참고)  segment1 : UPDATE 대상 item, segment2 : UPDATE 변경 item
		                select * from SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		                where lookup_type = 'MODEL_CHANGE'
		                and valid_yn = 'Y'
                */
        ----------------------------------------------------------
        
        UPDATE th_eng_stock_plan_sn
        SET    item_id = b.segment2
        FROM   th_eng_stock_plan_sn a WITH (NOLOCK)
               INNER JOIN (  SELECT segment1  -- UPDATE 대상 item
                                  , segment2  -- UPDATE 변경 item
                             FROM   scm_adm_lookup_master_detail WITH (NOLOCK)
                             WHERE  lookup_type = 'MODEL_CHANGE'
		                     AND    valid_yn = 'Y'
                          ) b
               ON a.item_id = b.segment1
        WHERE  1 = 1
        AND    a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id 
        ;
        
        
        ------------------------------------------------------------------------------------------
        -- 2. Cell Biz Demand 의 Late 계획수립 결과와 관련한 모델링 변경 처리에 필요한 후처리( 티라에서 생성한 쿼리 그대로 사용함)
        ------------------------------------------------------------------------------------------
        -- STEP13-2. WORK_ORDER_SEQ 설정									
		/* 로직보완 : 20191111, By KKC
		1. Pack Site 중 Cell→Pack BOD확정계획과 Pack 생산확정계획의 WORK_ORDER_GROUP 변경
		2. 속도 문제로 일괄쿼리를 분리해서 Update하는 로직으로 변경
		*/
	   
	    --BOD공정의 순서 Rule
	    WITH WH_WO_GROUP_SEQ AS (SELECT A.SITE_GROUP
									 , A.SITE_ID
									 , SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) AS SCM_SITE
									 , DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) AS IDX
									 , CASE WHEN A.SITE_GROUP = 'SALES' THEN 80
											ELSE
												CASE WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = 'E' THEN 20+
														  CASE WHEN DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) = 1 THEN 0 
															   ELSE DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) 
														  END
													 WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = 'A' THEN 40+
														  CASE WHEN DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) = 1 THEN 0 
															   ELSE DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) 
														  END
													 WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = 'P' THEN 60+
														  CASE WHEN DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) = 1 THEN 0 
															   ELSE DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) 
														  END
													 ELSE 90000
												 END
										END*1000 AS WO_SEQ_GROUP
								 FROM TH_ENG_SITE_SN A (NOLOCK)
								WHERE A.MASTER_ID = @p_master_id
									AND A.PLAN_ID   = @p_engine_plan_id
								)
        UPDATE A
	        SET A.WORK_ORDER_SEQ = B.NEW_WORK_GRP_SEQ
	      FROM TH_ENG_FIXED_PLAN_SN A
		    , (	   
			   SELECT A.WORK_ORDER_ID
				   ,  A.SITE_ID
				   ,  A.START_DTTM
				   ,  A.WORK_ORDER_SEQ
				   ,  B.WO_SEQ_GROUP*10000
					  + DENSE_RANK() OVER(PARTITION BY B.WO_SEQ_GROUP
								   			  ORDER BY A.START_DTTM
													 , A.RESOURCE_ID
													 , A.WORK_ORDER_ID
										  )  AS NEW_WORK_GRP_SEQ
				 FROM TH_ENG_FIXED_PLAN_SN A (NOLOCK)
	   				, WH_WO_GROUP_SEQ      B 
				WHERE A.MASTER_ID = @p_master_id
				  AND A.PLAN_ID   = @p_engine_plan_id
				  AND A.SITE_ID   = B.SITE_ID
				  AND EXISTS (SELECT 'X' 
								FROM TH_ENG_BOD_SN X (NOLOCK)
							   WHERE X.MASTER_ID = A.MASTER_ID
								 AND X.PLAN_ID   = A.PLAN_ID
								 AND X.BOD_ID    = A.RESOURCE_ID)
			 ) B
		WHERE A.MASTER_ID     = @p_master_id
		  AND A.PLAN_ID       = @p_engine_plan_id
		  AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
		;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'Update TH_ENG_FIXED_PLAN_SN'; 
        SET @v_description = N'BOD공정 확정계획 순서 Update(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	    --ROUTE공정(BOD공정外)의 순서 Rule
	    WITH WH_WO_GROUP_SEQ AS (SELECT A.SITE_GROUP
									 , A.SITE_ID
									 , SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) AS SCM_SITE
									 , DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) AS IDX
									 --, SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) AS WO_TYPE
									 , CASE WHEN A.SITE_GROUP = 'SALES' THEN 80
											ELSE
												CASE WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = 'E' THEN 21
													 WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = 'A' THEN 41
													 WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = 'P' THEN 61
													 ELSE 91000
												 END
										END*1000 AS WO_SEQ_GROUP
								 FROM TH_ENG_SITE_SN A (NOLOCK)
								WHERE A.MASTER_ID = @p_master_id
								  AND A.PLAN_ID   = @p_engine_plan_id
								  AND A.SITE_GROUP  = 'PLANT'
								  AND EXISTS (SELECT 'X'
								                FROM TH_ENG_ITEM_ROUTE_SITE_SN X (NOLOCK)
											   WHERE X.MASTER_ID   = A.MASTER_ID
											     AND X.PLAN_ID     = A.PLAN_ID
												 AND X.SITE_ID     = A.SITE_ID
											  )

								)
		UPDATE A   
		   SET A.WORK_ORDER_SEQ = B.NEW_WORK_GRP_SEQ
          FROM TH_ENG_FIXED_PLAN_SN A
		    , (
			   SELECT A.WORK_ORDER_ID
				   ,  A.SITE_ID
				   ,  A.START_DTTM
				   ,  A.WORK_ORDER_SEQ
				   , (CASE WHEN A.ROUTE_ID = 'DUMMY' THEN 61*1000
						   ELSE ISNULL(B.WO_SEQ_GROUP, 91*1000)
					  END) * 10000
					  + DENSE_RANK() OVER(PARTITION BY CASE WHEN A.ROUTE_ID = 'DUMMY' THEN 61*1000
															ELSE ISNULL(B.WO_SEQ_GROUP, 91*1000)
														END
								   			  ORDER BY A.START_DTTM
													 , A.WORK_ORDER_ID --//계획순서 조정 2020/03/11, By KKC
											)  AS NEW_WORK_GRP_SEQ
				 FROM TH_ENG_FIXED_PLAN_SN A (NOLOCK)
				 LEFT OUTER JOIN 
				      WH_WO_GROUP_SEQ      B  --//누락없도록 Join, 2020/03/12, By KKC
				   ON A.SITE_ID   = B.SITE_ID
				WHERE A.MASTER_ID = @p_master_id
				  AND A.PLAN_ID   = @p_engine_plan_id
				  AND NOT EXISTS (SELECT 'X' 
									FROM TH_ENG_BOD_SN X (NOLOCK)
								   WHERE X.MASTER_ID = A.MASTER_ID
									 AND X.PLAN_ID   = A.PLAN_ID
									 AND X.BOD_ID    = A.RESOURCE_ID)
				) B
		WHERE A.MASTER_ID     = @p_master_id
		  AND A.PLAN_ID       = @p_engine_plan_id
		  AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
		;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'Update TH_ENG_FIXED_PLAN_SN'; 
        SET @v_description = N'ROUTE공정 확정계획 순서 Update(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/* -- 20190920 수정 전  
		WITH W_ROUTE_TYPE AS (
					SELECT 'WO' AS WO_TYPE, 'E' AS ROUTE_TYPE, 10000 AS ROUTE_SEQ
					UNION ALL
					SELECT 'DO' AS WO_TYPE, 'E' AS ROUTE_TYPE, 20000 AS ROUTE_SEQ
					UNION ALL
					SELECT 'WO' AS WO_TYPE, 'A' AS ROUTE_TYPE, 30000 AS ROUTE_SEQ
					UNION ALL
					SELECT 'DO' AS WO_TYPE, 'A' AS ROUTE_TYPE, 40000 AS ROUTE_SEQ
					UNION ALL
					SELECT 'WO' AS WO_TYPE, 'P' AS ROUTE_TYPE, 50000 AS ROUTE_SEQ
					UNION ALL
					SELECT 'DO' AS WO_TYPE, 'P' AS ROUTE_TYPE, 60000 AS ROUTE_SEQ
				)
		   , W_WO_SEQ AS ( 
						SELECT B.ROUTE_TYPE
 							 , B.WO_TYPE
							 , B.ROUTE_SEQ
							 , SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) AS SCM_SITE
							 , A.SITE_ID                                           AS SITE_ID
							 , NULL                                                AS ROUTE_ID
							 , DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) AS IDX
							 , CONVERT(VARCHAR,B.ROUTE_SEQ + DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID)) AS WO_SEQ
						FROM TH_ENG_SITE_SN A(NOLOCK)
				          ,  W_ROUTE_TYPE B
					   WHERE A.MASTER_ID = @p_master_id
						 AND A.PLAN_ID   = @p_engine_plan_id
						 AND B.WO_TYPE   = 'DO'
						 AND 1 = CASE WHEN A.SITE_GROUP = 'SALES' THEN CASE WHEN B.ROUTE_TYPE = 'P' THEN 1
						                                                    ELSE 0
																		END
									  ELSE CASE WHEN SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = B.ROUTE_TYPE THEN 1
									            ELSE 0
										    END
								  END
						UNION
						SELECT B.ROUTE_TYPE
 							 , B.WO_TYPE
							 , B.ROUTE_SEQ
							 , SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) AS SCM_SITE
							 , A.SITE_ID
							 , A.ROUTE_ID
							 , 1 AS IDX
							 , CONVERT(VARCHAR,B.ROUTE_SEQ + 1) AS WO_SEQ
						FROM TH_ENG_ITEM_ROUTE_SITE_SN A(NOLOCK)
				          ,  W_ROUTE_TYPE B
						WHERE A.MASTER_ID = @p_master_id
						  AND A.PLAN_ID   = @p_engine_plan_id
						  AND B.WO_TYPE = 'WO'
						  AND SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = B.ROUTE_TYPE
						)
		UPDATE A   
		   SET A.WORK_ORDER_SEQ = B.NEW_WORK_ORDER_GRP_SEQ
		  FROM TH_ENG_FIXED_PLAN_SN A
			 , (
				SELECT B.WORK_ORDER_ID
					 , B.RESOURCE_ID
					 , B.START_DTTM
					 , B.NEW_WORK_ORDER_GROUP
					 , (CASE WHEN B.RESOURCE_ID LIKE '%DUMMY%' THEN 50001
							 ELSE NEW_WORK_ORDER_GROUP 
						 END *10000)
						+ DENSE_RANK() OVER(PARTITION BY CASE WHEN B.RESOURCE_ID LIKE '%DUMMY%' THEN 50001
															  ELSE NEW_WORK_ORDER_GROUP 
														  END
												 ORDER BY B.START_DTTM
														, B.RESOURCE_ID
														, B.WORK_ORDER_ID
												)  AS NEW_WORK_ORDER_GRP_SEQ
				  FROM (
    					   SELECT X.WORK_ORDER_ID
								, MIN(X.RESOURCE_ID) AS RESOURCE_ID
								, MIN(X.START_DTTM)  AS START_DTTM
								, MIN(CASE WHEN B.WO_SEQ IS NOT NULL THEN B.WO_SEQ
	  									   WHEN E.WO_SEQ IS NOT NULL THEN E.WO_SEQ
										   WHEN X.ROUTE_ID = 'DUMMY' THEN X.WORK_ORDER_SEQ
										   ELSE 90001
									END) AS NEW_WORK_ORDER_GROUP
							FROM TH_ENG_FIXED_PLAN_SN X (NOLOCK)
							LEFT OUTER JOIN W_WO_SEQ B --ROUTE
							ON (X.ROUTE_ID = B.ROUTE_ID
							AND X.SITE_ID  = B.SITE_ID)
							LEFT OUTER JOIN TH_ENG_BOD_SN C (NOLOCK)--BOD
							ON (X.MASTER_ID = C.MASTER_ID
							AND X.PLAN_ID   = C.PLAN_ID
							AND X.RESOURCE_ID = C.BOD_ID)
							LEFT OUTER JOIN W_WO_SEQ E (NOLOCK)--BOD
							ON (C.TO_SITE_ID = E.SITE_ID)
						 WHERE X.MASTER_ID = @p_master_id
						   AND X.PLAN_ID   = @p_engine_plan_id
						 GROUP 
							BY X.WORK_ORDER_ID
						) B	 
			   ) B
		WHERE A.MASTER_ID     = @p_master_id
		  AND A.PLAN_ID       = @p_engine_plan_id
		  AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
		;
		*/

	    /* -- 20190920 수정 전  
		①전체 W/O의 WORK_ORDER_SEQ 채번 Update 변경 : 기본적인 공정그룹 > 확정계획 시작일자 > 설비 > W/O ID 순으로, By KKC																		
        WITH W_ROUTE_TYPE AS (
	        SELECT 'WO' AS WO_TYPE, 'E' AS ROUTE_TYPE, 10000 AS ROUTE_SEQ
	        UNION ALL
	        SELECT 'DO' AS WO_TYPE, 'E' AS ROUTE_TYPE, 20000 AS ROUTE_SEQ
	        UNION ALL
	        SELECT 'WO' AS WO_TYPE, 'A' AS ROUTE_TYPE, 30000 AS ROUTE_SEQ
	        UNION ALL
	        SELECT 'DO' AS WO_TYPE, 'A' AS ROUTE_TYPE, 40000 AS ROUTE_SEQ
	        UNION ALL
	        SELECT 'WO' AS WO_TYPE, 'P' AS ROUTE_TYPE, 50000 AS ROUTE_SEQ
	        UNION ALL
	        SELECT 'DO' AS WO_TYPE, 'P' AS ROUTE_TYPE, 60000 AS ROUTE_SEQ
        )
        , W_WO_SEQ AS (
	        SELECT B.ROUTE_TYPE, B.WO_TYPE, B.ROUTE_SEQ, SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) AS SCM_SITE, A.SITE_ID, NULL AS ROUTE_ID
		         , DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID) AS IDX
		         , CONVERT(VARCHAR,B.ROUTE_SEQ + DENSE_RANK() OVER(PARTITION BY SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) ORDER BY A.SITE_ID)) AS WO_SEQ
	          FROM TH_ENG_SITE_SN A(NOLOCK)
			        INNER JOIN W_ROUTE_TYPE B
				        ON SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = B.ROUTE_TYPE AND B.WO_TYPE = 'DO'
	         WHERE 1=1
	           AND A.MASTER_ID = @p_master_id
	           AND A.PLAN_ID = @p_engine_plan_id
	           AND A.PLANT_FLAG = 'Y'
	        UNION
	        SELECT B.ROUTE_TYPE, B.WO_TYPE, B.ROUTE_SEQ, SUBSTRING(A.SITE_ID,1,CHARINDEX('~',A.SITE_ID,1)-1) AS SCM_SITE, A.SITE_ID, A.ROUTE_ID
		         , 1 AS IDX
		         , CONVERT(VARCHAR,B.ROUTE_SEQ + 1) AS WO_SEQ
	          FROM TH_ENG_ITEM_ROUTE_SITE_SN A(NOLOCK)
			        INNER JOIN W_ROUTE_TYPE B
				        ON SUBSTRING(A.SITE_ID,CHARINDEX('~',A.SITE_ID,1)-1,1) = B.ROUTE_TYPE AND B.WO_TYPE = 'WO'
			        --INNER JOIN (
				       -- SELECT DISTINCT X.ROUTE_ID
				       --   FROM TH_ENG_OP_RES_GROUP_MAP_SN X(NOLOCK)
				       --  WHERE 1=1
				       --    AND X.MASTER_ID = @p_master_id
				       --    AND X.PLAN_ID = @p_engine_plan_id
				       --    AND X.DESCR = 'LINE_CAPA'
				       -- ) C
				       -- ON A.ROUTE_ID = C.ROUTE_ID
	         WHERE 1=1
	           AND A.MASTER_ID = @p_master_id
	           AND A.PLAN_ID = @p_engine_plan_id
        )
        UPDATE X
           SET X.WORK_ORDER_SEQ = Y.WO_SEQ
          FROM TH_ENG_FIXED_PLAN_SN X
		        INNER JOIN (
			        SELECT B.WO_SEQ, B.WO_TYPE, A.*
			          FROM TH_ENG_FIXED_PLAN_SN A(NOLOCK)
					        INNER JOIN W_WO_SEQ B
						        ON B.WO_TYPE = 'WO' AND A.ROUTE_ID = B.ROUTE_ID AND A.SITE_ID = B.SITE_ID
			         WHERE 1=1
			           AND A.MASTER_ID = @p_master_id
			           AND A.PLAN_ID = @p_engine_plan_id
			           AND A.DESCR LIKE 'WO%'
			        UNION ALL
			        SELECT C.WO_SEQ, C.WO_TYPE, A.*
			          FROM TH_ENG_FIXED_PLAN_SN A(NOLOCK)
					        INNER JOIN TH_ENG_BOD_SN B
						        ON A.MASTER_ID = B.MASTER_ID AND A.PLAN_ID = B.PLAN_ID AND A.RESOURCE_ID = B.BOD_ID
					        INNER JOIN W_WO_SEQ C
						        ON C.WO_TYPE = 'DO' AND B.FROM_SITE_ID = C.SITE_ID
			         WHERE 1=1
			           AND A.MASTER_ID = @p_master_id
			           AND A.PLAN_ID = @p_engine_plan_id
			           AND A.DESCR LIKE 'DO%'
			        ) Y
			        ON X.WORK_ORDER_ID = Y.WORK_ORDER_ID
         WHERE 1=1
           AND X.MASTER_ID = @p_master_id
           AND X.PLAN_ID = @p_engine_plan_id
        ;
        */

	    		
        -------------------------------------------------
        -- 3. fixed_plan split
        -------------------------------------------------
        /* 불필요한 로직 정리, 
           2024.11.07 start ~

        DECLARE @p_default_cell_split_count NUMERIC(5) = 20000;   -- 셀 item split 개수 기본값
        DECLARE @p_default_elec_split_count NUMERIC(5) = 20000;  -- 전극 item split 개수 기본값

        -------------------------------------------------
        -- 3-1. split 대상 데이터 생성
        -------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_FIXED_PLAN') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_FIXED_PLAN
        END
       
        SELECT    a.master_id
                , a.plan_id
                , a.work_order_id
                , a.work_order_seq
                , a.site_id
                , a.route_id
                , a.operation_id
                , a.item_id
                , a.resource_id
                , a.sub_resource_id
                , a.start_dttm
                , a.end_dttm
                , a.operation_qty
                , a.complete_qty
                , a.lot_id
                , a.is_fixed
                , a.is_prev_schedule
                , a.keep_work_time_type
                , a.keep_qty_type
                , a.sales_model_id
                , a.attribute_set_id
                , a.demand_id
                , a.descr
                , a.is_noh_consume
                , LEFT(a.operation_id, 1) AS operation_group

                , b.max_qty 
                , CASE WHEN LEFT(a.operation_id, 1) = 'A' THEN  @p_default_cell_split_count --20000 --20180711 임시로 20000셋팅함 차후확인필요 --ISNULL(b.max_qty, 10000) 
                       WHEN LEFT(a.operation_id, 1) = 'E' THEN  @p_default_elec_split_count --20000
                  END  split_qty 

                , ceiling(complete_qty/ CASE WHEN LEFT(a.operation_id, 1) = 'A' THEN  @p_default_cell_split_count --20000 --ISNULL(b.max_qty, 10000) 
                                             WHEN LEFT(a.operation_id, 1) = 'E' THEN  @p_default_elec_split_count --20000
                                        END) 
                  AS split_count
                , work_order_id  AS org_work_order_id 
        INTO    #th_eng_fixed_plan        
        FROM    th_eng_fixed_plan_sn a WITH (NOLOCK)
                LEFT JOIN ( SELECT master_id, plan_id, item, max(qty) max_qty
                            FROM   th_eng_net_demand_sn  WITH (NOLOCK)
                            WHERE  master_id = @p_master_id --'81::WEEKLY' 
                            AND    plan_id   = @p_engine_plan_id   --'1034::MA::3'
                            GROUP BY master_id, plan_id,item 
                          ) b 
                ON   a.master_id = b.master_id
                AND  a.plan_id   = b.plan_id
                AND  a.item_id   = b.item 
        WHERE   a.master_id = @p_master_id   -- @p_master_id
        AND     a.plan_id   = @p_engine_plan_id  -- @p_plan_id
        AND     a.start_dttm >= CONVERT(DATETIME, @v_pet_date) -- @v_pet_date  --select * from scm_mst_plan WITH (NOLOCK) where plan_name = '20180702'
        AND     LEFT(a.operation_id, 1) IN ('A', 'E') -- dummy는 어떻게???

        AND     a.complete_qty > (CASE WHEN LEFT(a.operation_id, 1) = 'A' THEN  @p_default_cell_split_count --20000 --ISNULL(b.max_qty, 5000) 
                                       WHEN LEFT(a.operation_id, 1) = 'E' THEN  @p_default_elec_split_count --20000
                                   END )
        ;
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 END';
        SET @v_description = N'3-1. split 대상 데이터 생성 ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        --3-2. copy_t 임시 테이블 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#copy_t') IS NOT NULL 
         BEGIN
            DROP TABLE #copy_t
         END

        DECLARE @max_div_count NUMERIC(5)
        SELECT @max_div_count = MAX(ceiling(complete_qty/ split_qty)) 
        FROM   #th_eng_fixed_plan 
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
       
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 END';
        SET @v_description = N'3-2. copy_t 임시 테이블 생성 ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -------------------------------------------------
        -- 3-3. SPLIT 데이터 INSERT
        -------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
        SELECT  a.master_id
              , a.plan_id
              , a.work_order_id + '_' + CONVERT(NVARCHAR(10), ROW_NUMBER() OVER (PARTITION BY org_work_order_id ORDER BY b.no))
              , a.work_order_seq
              , a.site_id
              , a.route_id
              , a.operation_id
              , a.item_id
              , a.resource_id
              , a.sub_resource_id
              , a.start_dttm
              , a.end_dttm
              
              --, a.operation_qty
              , CASE WHEN a.split_count <> b.no  THEN a.split_qty 
                     WHEN a.split_count = b.no   THEN IIF(a.complete_qty % a.split_qty = 0, a.split_qty, a.complete_qty % a.split_qty)
                END  AS operation_qty

              -- , a.complete_qty
              , CASE WHEN a.split_count <> b.no  THEN a.split_qty 
                     WHEN a.split_count = b.no   THEN IIF(a.complete_qty % a.split_qty = 0, a.split_qty, a.complete_qty % a.split_qty)
                END  AS complete_qty

              , a.lot_id
              , a.is_fixed
              , a.is_prev_schedule
              , a.keep_work_time_type
              , a.keep_qty_type
              , a.sales_model_id
              , a.attribute_set_id
              , a.demand_id
              , a.descr
              , a.is_noh_consume
             
             --, ROW_NUMBER() OVER (PARTITION BY org_work_order_id ORDER BY b.no) row_num
             --, a.operation_qty AS org_operation_qty
             --, a.complete_qty  AS org_complete_qty
             --, a.split_count
             --, b.no  
        
        FROM  #th_eng_fixed_plan a
           ,  #copy_t b
        WHERE  b.no <= a.split_count 
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 END';
        SET @v_description = N'3-3. SPLIT 데이터 INSERT ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -------------------------------------------------
        -- 3-4. split 대상 데이터 삭제
        -------------------------------------------------
        DELETE FROM th_eng_fixed_plan_sn
        FROM   th_eng_fixed_plan_sn a WITH (NOLOCK)
               INNER JOIN #th_eng_fixed_plan b 
               ON a.work_order_id = b.work_order_id               
        WHERE  a.master_id = @p_master_id       --'81::WEEKLY'
        AND    a.plan_id   = @p_engine_plan_id  --'1034::MA::3'
        ;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 END';
        SET @v_description = N'3-4. split 대상 데이터 삭제' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ~ end  2024.11.07 */
        
        -----------------------------------------------------------	
        --fixed plan의 end dttm이 정상적인 계획 BUCKET를 넘어가는 확정계획 발생 방지, 필요시 추가 2024.11.07
        --bod lt가 너무 크거나 또는 다른 예외case로 만들어지는 fixed plan 생성방지.
        /*
        DELETE A
          FROM TH_ENG_FIXED_PLAN_SN A
            JOIN (
                   SELECT A.MASTER_ID
                        , A.PLAN_ID
                        , A.WORK_ORDER_ID
                    FROM
                        (
                       SELECT A.MASTER_ID
                            , A.PLAN_ID
                            , A.WORK_ORDER_ID
                            , A.SITE_ID
                            , A.RESOURCE_ID
                            , A.START_DTTM
                            , B.TRANSPORT_TIME
                            , B.TRANSPORT_TIME_UOM
                            , A.KEEP_WORK_TIME_TYPE
                            , CASE WHEN B.TRANSPORT_TIME_UOM = 'DAY'    THEN DATEADD(DAY, B.TRANSPORT_TIME, A.START_DTTM)
                                   WHEN B.TRANSPORT_TIME_UOM = 'WEEK'   THEN DATEADD(DAY, B.TRANSPORT_TIME*7, A.START_DTTM) 
                                    /* 정의되지 TIME UOM이 기준 변경시는 재검토 필요 */
                                   ELSE 
                                        DATEADD(DAY, 0, A.START_DTTM)
                               END AS END_DTTM                   
                        FROM TH_ENG_FIXED_PLAN_SN A WITH(NOLOCK)
                        JOIN TH_ENG_BOD_SN B WITH(NOLOCK)
                          ON A.MASTER_ID   = B.MASTER_ID
                         AND A.PLAN_ID     = B.PLAN_ID
                         AND A.RESOURCE_ID = B.BOD_ID
                       WHERE A.MASTER_ID = @p_master_id
                         AND A.PLAN_ID   = @p_engine_plan_id 
                         AND A.DESCR NOT LIKE 'DM::DUMMY%'   --DEMAND로 수립되는 건 정상Bucket내에서 엔진계획수립하기 때문에 제외
                         AND A.KEEP_WORK_TIME_TYPE = 'START_FIX'
                        ) A
                     WHERE A.END_DTTM >= DATEADD(DAY, 1, CONVERT(DATETIME, @v_add_pet_date))
                ) B
           ON A.MASTER_ID = B.MASTER_ID
          AND A.PLAN_ID   = B.PLAN_ID
          AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
        WHERE A.MASTER_ID = @p_master_id 
          AND A.PLAN_ID   = @p_engine_plan_id 
        ;

		-- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'Delete TH_ENG_FIXED_PLAN_SN'; 
        SET @v_description = N'END DTTM이 계획Bucket을 넘어가는 확정계획 Delete(TH_ENG_FIXED_PLAN_SN) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        */

        -------------------------------------------------
        -- 4. Production Lot Size 설정 : 2018.09.20
        -------------------------------------------------
		-- 4-1. TH_ENG_ITEM_ROUTE_SITE [UPDATE] : MIN_LOT_SIZE / INCREMENT_LOT_SIZE 설정
        -------------------------------------------------
        /*   -- 20190801 OSP Production Lot Size 적용 제거		
        UPDATE B
        SET    B.MIN_LOT_SIZE       = A.QTY
		     , B.INCREMENT_LOT_SIZE = A.QTY
        FROM   TH_ENG_ITEM_ROUTE_SITE_SN B
	        INNER JOIN
			(
			 SELECT DISTINCT MASTER_ID, PLAN_ID, SITE_ID, ROUTE_ID, RIGHT(PRODUCT_MIX_ID, CHARINDEX('_', REVERSE(PRODUCT_MIX_ID),1)-1 ) AS ITEM_ID, QTY
			 FROM   TH_ENG_PRODUCT_MIX_SN
			 WHERE  1=1
			 AND    MASTER_ID      = @p_master_id
			 AND    PLAN_ID        = @p_engine_plan_id
			 AND    BUCKET         ='DAY'
			 AND    PRODUCT_MIX_ID NOT LIKE '%TOTAL%'
             AND    DESCR          = 'OSP' --20190218 추가
			) A
            ON  A.MASTER_ID = B.MASTER_ID 
			AND A.PLAN_ID   = B.PLAN_ID 
			AND A.SITE_ID   = B.SITE_ID 
			AND A.ROUTE_ID  = B.ROUTE_ID 
			AND A.ITEM_ID   = B.ITEM_ID;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4 END';
        SET @v_description = N'4-1. Production Lot Size 설정' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        */  

 		-----------------------------------------------------------------
		-- 5. Business Type Default 값 Update (Project별 출하확정계획 유지 엔진 패치), 2021.07.21, By KKC
		-----------------------------------------------------------------
		/* 5.1. 기존  PRIORITY 및 PROJECT코드 Update */ 
		UPDATE A
		   SET A.ORG_PRIORITY  = PRIORITY
		     , A.BUSINESS_TYPE = CASE WHEN A.BUSINESS_TYPE IS NULL THEN 'ALL' --//2021.07.21 추가
			                          ELSE A.BUSINESS_TYPE
								  END									
		  --  ,  A.PROJECT_CODE = SUBSTRING(A.DEMAND_ID, CHARINDEX('::', A.DEMAND_ID,1)+2, 8)
		  FROM TH_ENG_NET_DEMAND_SN A
		 WHERE A.MASTER_ID = @p_master_id 
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

		/* 5.2. BUSINESS TYPE Update, 2021.07.21 추가 */ 
		UPDATE A
		   SET A.BUSINESS_TYPE = CASE WHEN A.BUSINESS_TYPE IS NULL THEN 'ALL' --//2021.07.21 추가
			                          ELSE A.BUSINESS_TYPE
								  END									
		  FROM TH_ENG_FIXED_PLAN_SN A
		 WHERE A.MASTER_ID = @p_master_id 
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

		UPDATE A
		   SET A.BUSINESS_TYPE = CASE WHEN A.BUSINESS_TYPE IS NULL THEN 'ALL' --//2021.07.21 추가
			                          ELSE A.BUSINESS_TYPE
								  END									
		  FROM TH_ENG_STOCK_PLAN_SN A
		 WHERE A.MASTER_ID = @p_master_id 
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

		/* ===========================================================
		  (2022.04.29) Engine기능 패치작업과 연관.
	      - work_time이 무한capa로 설정될 경우 단위는 'DAY'로 세팅한다. 
		  - 무한CAPA' 정의: 1일 86,400초 작업시간을 넘어가는 경우
		==============================================================*/ 

		UPDATE  A   
		SET     A.WORK_TIME_UOM = 'DAY' 
        FROM  (
                SELECT A.* 
                    ,  CASE WHEN A.BUCKET_TYPE = 'DAY' AND A.WORK_TIME_UOM = 'DAY'     THEN WORK_TIME * (24*60*60)      --> day to second 로 환산
			                WHEN A.BUCKET_TYPE = 'DAY' AND A.WORK_TIME_UOM = 'HOUR'    THEN WORK_TIME * (60*60)         --> hour to second 로 환산
			                WHEN A.BUCKET_TYPE = 'DAY' AND A.WORK_TIME_UOM = 'MINUTE'  THEN WORK_TIME * (60)            --> minute to second 로 환산
			                WHEN A.BUCKET_TYPE = 'DAY' AND A.WORK_TIME_UOM = 'SECOND'  THEN WORK_TIME                   --> 환산기준

			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'WEEK'    THEN (WORK_TIME/7) * (7*24*60*60)   --> 일 평균기준 week to second 로 환산
			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'DAY'     THEN (WORK_TIME/7) * (24*60*60)     --> 일 평균기준 day to second 로 환산
			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'HOUR'    THEN (WORK_TIME/7) * (60*60)        --> 일 평균기준 hour to second 로 환산
			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'MINUTE'  THEN (WORK_TIME/7) * (60)           --> 일 평균기준 minute to second 로 환산
			                WHEN A.BUCKET_TYPE = 'WEEK' AND A.WORK_TIME_UOM = 'SECOND'  THEN (WORK_TIME/7)                  --> 일 평균기준 second값 기준.
		                END  CONVERT_SECOND
                FROM   TH_ENG_BUCKET_RES_CAPA_SN  A WITH(NOLOCK) 
                WHERE  MASTER_ID =  @p_master_id      
                AND    PLAN_ID   =  @p_engine_plan_id  
              ) A
        WHERE  A.CONVERT_SECOND > 86400   --> 1일 86,400초 초과대상
        ; 

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type  = 'TXN';
        SET @v_log_message = 'update TH_ENG_BUCKET_RES_CAPA_SN'; 
        SET @v_description = N'무한CAPA 시간단위 DAY설정...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        /************************************************************************************************************ 
	      2023.05.31  KKC PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 개발 임시(n-ERP 1차 데이터 변경, 7월한시적)
          2023.07.07  SHS PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 임시 모델링 이하 제거 
		 ************************************************************************************************************/

        ------------------------------------------------------------
        --임시테이블 삭제
        ------------------------------------------------------------
        /* 2024.11.07 주석처리
        IF OBJECT_ID('tempdb..#TH_ENG_FIXED_PLAN') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_FIXED_PLAN;
        END
        
        IF OBJECT_ID('tempdb..#copy_t') IS NOT NULL 
         BEGIN
            DROP TABLE #copy_t;
         END        
        */

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
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END;

