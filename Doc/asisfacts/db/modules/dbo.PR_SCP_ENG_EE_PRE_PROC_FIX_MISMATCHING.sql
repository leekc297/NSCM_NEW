
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_FIX_MISMATCHING
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
                  -- 3. Production Lot Size 설정
                  -------------------------------------------------

                    3-1. TH_ENG_ITEM_ROUTE_SITE [UPDATE]
                           
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.25   KSW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.09.20   KSG         TH_ENG_ITEM_ROUTE_SITE - Lot Size UPDATE 추가 수정
 * 2018.11.07   KSW         ITEM 변경 대상 및 변경값을 하드코딩에서 LOOKUP테이블로 변경함(참고)주석1-1
 * 2019.02.18   KSW         Production Lot Size 설정부분의 조회조건 변경(th_eng_product_mix_sn.descr='OSP'조회조건추가) (참고)주석3
 * 2019.08.01   KSG         OSP Production Lot Size 적용 제거
 * 2019.09.20   KKC         ①전체 W/O의 WORK_ORDER_SEQ 채번 Update 변경
 * 2019.11.11   KKC         1. Pack Site 중 Cell→Pack BOD확정계획과 Pack 생산확정계획의 WORK_ORDER_GROUP 변경
                            2. 속도 문제로 일괄쿼리를 분리해서 Update하는 로직으로 변경
 * 2020.03.11   KKC         W/O SEQ Update Query 중복제거 및 계획 순서 조정
 * 2021.07.21   KKC         Business Type = ALL Update (엔진신규패치 기능으로 Default값 설정)
                             -> 추후 해당 테이블블 프로시져 Business Type 값 활용시 주석 처리 필요 
 * 2022.04.29   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 무한CAPA일 경우 TIME_UOM = 'DAY'로 설정 (엔진 패치)
 * 2023.05.31   KKC         PJ20230691   LGES SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 개발 임시(n-ERP 1차 데이터 변경, 7월한시적)
 * 2023.07.07	SHS			PJ20230691   LGES SCM 역량 강화 위한 SCP 개선과제 이행: 7월 오픈 기준 임시 모델링 정리
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_FIX_MISMATCHING]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_FIX_MISMATCHING';
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

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
        SELECT @v_pet_date = p.horizon_end_date
        FROM   dbo.scm_mst_plan p WITH (NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;


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
        -- STEP13-2. WORK_ORDER_SEQ 설정		--BOD공정의 순서 Rule
	    --1. BOD공정
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

		--4-2. ROUTE 공정에 대한 TO SITE 기준 WO SEQ Update
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
													 , A.WORK_ORDER_ID --수정/보완 2020/03/11, By KKC
											)  AS NEW_WORK_GRP_SEQ
				 FROM TH_ENG_FIXED_PLAN_SN A (NOLOCK)
                 LEFT OUTER JOIN 
				      WH_WO_GROUP_SEQ      B  --//누락없도록 Join, 2020/03/12, By KKC
				   ON A.SITE_ID   = B.SITE_ID
				WHERE A.MASTER_ID = @p_master_id
				  AND A.PLAN_ID   = @p_engine_plan_id
                  --//BOD공정 제외
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
    		
        -----------------------------------------------------------	
        -------------------------------------------------
        -- 3. Production Lot Size 설정 : 2018.09.20
        -------------------------------------------------
		-- 3-1. TH_ENG_ITEM_ROUTE_SITE [UPDATE] : MIN_LOT_SIZE / INCREMENT_LOT_SIZE 설정
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
        SET @v_description = N'3-1. Production Lot Size 설정' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      */  

    -----------------------------------------------------------

        -- TXN LOG        

 		-----------------------------------------------------------------
		-- 4. Business Type Default 값 Update (Project별 출하확정계획 유지 엔진 패치), 2021.07.21, By KKC
		-----------------------------------------------------------------
		/* 4.1. 기존  PRIORITY 및 PROJECT코드 Update */ 
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
          2023.07.07  SHS PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리 임시 모델링 로직 정리 
		 ************************************************************************************************************/
		
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
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END;

