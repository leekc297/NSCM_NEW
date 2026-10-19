
CREATE PROCEDURE [dbo].[PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF]
(
	@P_ISSUE_DATE         NVARCHAR(8)=NULL
)
AS
/*
 * Program ID   : PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF
 * Description  : 출하실적으로 Intransit 생성용
 *              : 추후 물류 인터페이스 구축 후 폐기 예정(2018 이내)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.25   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.19   Kim Jaejung    shipment_no 관련 로직 수정
 * 2018.11.19   KSG            7000대 재고 대신 출하실적의 특정 Status 정보를 사용 - 'D20' : '공장출고' / 'D30' : '운송중'
 * 2018.12.05   KSG            Status 정보 추가 - 'D40' : '매출'
 * 2019.11.20   KSG            order_type_code 제약 : lookup_type = 'ERP_ORDER_TYPE'
 * 2020.02.18   KSG            Storage ID 추가
 * 2020.10.07   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                Cutoff 테이블에 신규 컬럼 추가 : final_soldto_code / final_soldto_name / final_incoterms
 * 2021/05/10   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 1단계 개발(lt_total => add_after_lt_total 변경)
 * 2021/07/13   sclee.lee      [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 기존 뷰(scp_mst_bod_v)를 scp_mst_bod_n_v로 변경
                               및 from_yyyymmdd, to_yyyymmdd 추가 (조인시 중복방지)
 * 2022.03.30   KSG            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
                                 lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 에 값이 없어 실제로 result_type = 'S' 는 생성되지 않음
 * 2022/07/28   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - @P_ISSUE_DATE 기준 plant_issue_date가 2년 경과시 scm_dnm_intransit_c에 생성대상서 제외
 * 2023/03/23	hrkim		   [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - HM JV 가상 사업부 추가 반영
 * 
 */

	BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_history_seq	BIGINT;
	DECLARE @v_ifseqno  NVARCHAR(50);

	-- 프로시져용 변수 설정
	DECLARE @v_c1_company_id			 NVARCHAR(50); 
	DECLARE @v_c1_division_id			 NVARCHAR(50); 
	DECLARE @v_c1_plant_id				 NVARCHAR(50); 
	DECLARE @v_c1_item_id				 NVARCHAR(50); 
	DECLARE @v_c1_scm_qty				 NUMERIC(30,10); 
	DECLARE @v_c2_result_yyyymmdd		 NVARCHAR(50); 
	DECLARE @v_c2_company_id			 NVARCHAR(50); 
	DECLARE @v_c2_division_id			 NVARCHAR(50); 
	DECLARE @v_c2_plant_id				 NVARCHAR(50); 
	DECLARE @v_c2_order_no				 NVARCHAR(50); 
	DECLARE @v_c2_project_code			 NVARCHAR(50); 
	DECLARE @v_c2_item_id				 NVARCHAR(50); 
	DECLARE @v_c2_from_scm_site_id		 NVARCHAR(50); 
	DECLARE @v_c2_to_scm_site_id	     NVARCHAR(50); 
	DECLARE @v_c2_plant_issue_date       NVARCHAR(8); 
	DECLARE @v_c2_exfactory_qty			 NUMERIC(30,10);
	DECLARE @v_c2_exfactory_qty_sum		 NUMERIC(30,10);
	DECLARE @v_c2_soldto_code			 NVARCHAR(50);
	DECLARE @v_c2_shipto_code			 NVARCHAR(50); 
	DECLARE @v_c2_uom					 NVARCHAR(50); 
	DECLARE @v_c2_on_board_date		     NVARCHAR(8);
	DECLARE @v_c2_f_dest_eta_date		 NVARCHAR(8);
	DECLARE @v_c2_transport_mode		 NVARCHAR(50);
	DECLARE @v_c2_incoterms				 NVARCHAR(50);
	DECLARE @v_c2_lt_total				 NUMERIC(30,10);
	DECLARE @v_c2_site_type				 NVARCHAR(50); -- 20181119 추가
	DECLARE @v_c2_exfactory_status       NVARCHAR(50); 
	DECLARE @v_c2_storage_id             NVARCHAR(50); -- 20200218  Storage ID 추가
	
	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @d_event_date = SYSDATETIME();

	BEGIN TRY
	  BEGIN
		
		IF @P_ISSUE_DATE IS NULL OR ISDATE(@P_ISSUE_DATE) != 1
		SET @P_ISSUE_DATE = CONVERT(CHAR(8), DATEADD(day,-1,GETDATE()), 112)
		ELSE
		SET @P_ISSUE_DATE = CONVERT(CHAR(8), DATEADD(day,-1,@P_ISSUE_DATE), 112)

        -- PJ20216994
	    DECLARE @v_min_plant_issue_date      VARCHAR(8) = FORMAT(DATEADD(YEAR, -2, @P_ISSUE_DATE), 'yyyyMMdd');	

        -- PJ20216994
        -- @P_ISSUE_DATE 확인을 위해 @v_description 위치 변경
        SET @v_description = CONCAT('@P_ISSUE_DATE : ', @P_ISSUE_DATE);
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	    /*****************  임시 테이블 생성  ********************/
		IF OBJECT_ID('dbo.scm_dnm_exfactory_result_c_temp$') IS NOT NULL 
			DROP TABLE scm_dnm_exfactory_result_c_temp$

		CREATE TABLE [dbo].[scm_dnm_exfactory_result_c_temp$](
																[RESULT_DATE] [nvarchar](8) NULL,
																[RESULT_TYPE] [nvarchar](1) NULL,
																[COMPANY_ID] [nvarchar](30) NULL,
																[DIVISION_ID] [nvarchar](30) NULL,
																[PLANT_ID] [nvarchar](30) NULL,
																[SHIPMENT_NO] [nvarchar](10) NULL,
																[PROJECT_CODE] [nvarchar](50) NULL,
																[ITEM_ID] [nvarchar](50) NULL,
																[PLANT_ISSUE_DATE] [nvarchar](8) NULL,
																[TRANSPORT_MODE] [nvarchar](50) NULL,
																[INCOTERMS] [nvarchar](10) NULL,
																[FCST_TYPE] [nvarchar](20) NULL,
																[DOM_EXP] [nvarchar](3) NULL,
																[CUSTOMER_CODE] [nvarchar](50) NULL,
																[SHIPTO_CODE] [nvarchar](10) NULL,
																[FROM_SCM_SITE_ID] [nvarchar](30) NULL,
																[TO_SCM_SITE_ID] [nvarchar](30) NULL,
																[DELIVERY_QTY] [numeric](20, 10) NULL,
																[UOM] [nvarchar](10) NULL,
																[SHIPPING_DATE] [nvarchar](8) NULL,
																[F_DEST_ETA_DATE] [nvarchar](8) NULL,
																[EXFACTORY_STATUS] [nvarchar](50) NULL,
																[STORAGE_ID] [nvarchar](50) NULL -- 20200218  Storage ID 추가	
															);


		/*****************  대상 데이터 외부 커서 생성 ********************/
		-- 2018.11.19 Division 커서 변경
		DECLARE CUR_EXFACTORY_C1 CURSOR FOR 
		SELECT  division_id
		FROM    scm_mst_division v WITH(NOLOCK)
		WHERE	ATTRIBUTE3 != 'EE'	-- 2023023 [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
		  AND	VALID_YN	= 'Y'
		--WHERE   division_id NOT IN ('EE', 'EE_UC')   -- 20220330 PJ20216891 GM JV 가상 Division 추가
		--WHERE   division_id <> 'EE'
		;
	/*	DECLARE CUR_EXFACTORY_C1 CURSOR FOR 
		SELECT company_id, division_id, plant_id, item_id, sum(scm_qty) scm_qty
		FROM   scm_dnm_stock_v v WITH(NOLOCK)
		WHERE  v.cutoff_date = @P_ISSUE_DATE
		AND    v.stock_type = 'INVENTORY'
		AND    left(v.storage_id, 1) = '7'
		AND  v.company_id IN(SELECT segment1 
							 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
							 WHERE lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 
							 AND valid_yn = 'Y')
		AND  v.scm_qty > 0
		group by company_id, division_id, plant_id, item_id
		;*/

/* 	
	    DELETE FROM scm_dnm_intransit_c 
		WHERE result_type = 'S'
		AND result_date = @P_ISSUE_DATE
		AND company_id IN(SELECT segment1 
						  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
						  WHERE lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 
						  AND valid_yn = 'Y');
 */
 
        -- PJ20216994
        -- MS권고안에 따른 삭제로직 변경
        BEGIN TRAN
        -- 기존내역부터 지우고 시작
        WHILE(1 = 1)
        BEGIN
            DELETE TOP (100) A
            FROM dbo.scm_dnm_intransit_c A
            WHERE A.RESULT_DATE = @P_ISSUE_DATE
            AND A.RESULT_TYPE = 'S'
    		AND A.company_id IN (SELECT segment1 
    						     FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
    						     WHERE lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 
    						     AND valid_yn = 'Y');
  
            IF(@@ROWCOUNT = 0)
            BEGIN
                BREAK;
            END
        END

        COMMIT
 
		/*****************  외부 커서 시작 ********************/
		-- 2018.11.19   커서 변경
		OPEN CUR_EXFACTORY_C1;
		FETCH NEXT FROM CUR_EXFACTORY_C1 INTO  @v_c1_division_id
		--FETCH NEXT FROM CUR_EXFACTORY_C1 INTO  @v_c1_company_id
		--									  ,@v_c1_division_id
		--									  ,@v_c1_plant_id
		--									  ,@v_c1_item_id
		--									  ,@v_c1_scm_qty

		WHILE (@@FETCH_STATUS = 0)
			BEGIN -- CUR_EXFACTORY_C1
				/*****************  내부 커서 선언 ********************/
				DECLARE CUR_EXFACTORY_C2 CURSOR FOR

				SELECT c.*
				FROM (
						SELECT	 @P_ISSUE_DATE result_yyyymmdd
								,company_id
								,a.division_id
								,plant_id
								,order_no AS order_no
								,project_code
								,item_id
								,from_scm_site_id
								,to_scm_site_id
								,soldto_code
								,shipto_code
						        ,a.transport_mode -- 20181119 추가 : SALES 는 BOD 기준
							    ,a.incoterms      -- 20181119 추가 : SALES 는 BOD 기준
								,exfactory_qty
								,on_board_date
								,plant_issue_date
								-- From/To/Tr Mode/Incoterms 기준 => exfactory_date
								,CASE WHEN ISDATE(exfactory_date)  = 1 
								           THEN CONVERT(CHAR(8)
										              , DATEADD(day, ISNULL(b.lt_total, 0), exfactory_date)
										              , 112) 
								      ELSE exfactory_date
								 END f_dest_eta_date	
								,uom
								,lt_total
								,'SALES' site_type
								,a.exfactory_status
								,a.storage_id       -- 20200218  Storage ID 추가	
						FROM scm_dnm_exfactory_result A WITH(NOLOCK)

						 -- 20181119 변경 :Sales 는 From/To/Tr Mode/Incoterms 기준
						 -- PJ20209642 : BOD LT 1단계 개발( lt_total => add_after_lt_total 변경)
                         -- 20210713 변경
                         -- PJ20209643 : 기존 뷰(scp_mst_bod_v)를 scp_mst_bod_n_v로 변경 및 from_yyyymmdd, to_yyyymmdd 추가 (조인시 중복방지)
						LEFT JOIN ( SELECT A.division_id, A.from_site, A.to_site, A.transport_mode, A.incoterms, A.from_yyyymmdd, A.to_yyyymmdd, MAX(add_after_lt_total) lt_total
									FROM   scp_mst_bod_n_v A
									INNER JOIN(
												SELECT division_id, from_site, to_site, transport_mode, incoterms, from_yyyymmdd, to_yyyymmdd, MIN(priority) priority 
												FROM   scp_mst_bod_n_v  WITH(NOLOCK)
												WHERE  bod_valid_yn = 'Y'
												AND    route_valid_yn = 'Y'
												GROUP BY division_id, from_site, to_site, transport_mode, incoterms, from_yyyymmdd, to_yyyymmdd) B
									ON    A.division_id      = B.division_id
									AND   A.from_site        = B.from_site
									AND   A.to_site          = B.to_site
						            AND   A.transport_mode   = B.transport_mode
						            AND   A.incoterms        = B.incoterms
									AND   A.priority         = B.priority
									AND   A.from_yyyymmdd    = B.from_yyyymmdd
									AND   A.to_yyyymmdd      = B.to_yyyymmdd
									AND   A.bod_valid_yn     = 'Y'
									AND   A.route_valid_yn   = 'Y'
									GROUP BY A.division_id, A.from_site,A.to_site, A.transport_mode, A.incoterms, A.from_yyyymmdd, A.to_yyyymmdd
									) B
						ON    A.division_id      = B.division_id
						AND   A.from_scm_site_id = B.from_site
						AND   A.to_scm_site_id   = B.to_site
						AND   A.transport_mode   = B.transport_mode
						AND   A.incoterms        = B.incoterms
						AND   A.exfactory_date  >= B.from_yyyymmdd -- 20210707 PJ20209643 추가
						AND   A.exfactory_date  <= B.to_yyyymmdd   -- 20210707 PJ20209643 추가

						WHERE 1=1
						-- 2018.11.19 조건 변경
						AND   a.division_id = @v_c1_division_id
						AND   company_id IN (SELECT segment1 
												FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
												WHERE  lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 
												AND    valid_yn    = 'Y'
											) 
						AND   to_scm_site_id IN (SELECT scm_site_id 
											     FROM   scm_mst_site WITH(NOLOCK) 
											     WHERE  site_type = 'SALES' 
											     AND    valid_yn  = 'Y'
											    )
						AND   exfactory_date >= CONVERT(CHAR(8), DATEADD(DAY, -90, CONVERT(DATE, @P_ISSUE_DATE)), 112) --- 2018.11.19 조건 추가 최근 90일 이내
						AND   exfactory_date <= @P_ISSUE_DATE
						AND   a.exfactory_qty > 0
						AND   a.exfactory_status IN ('D20', 'D30', 'D40') -- 'D20' : '공장출고' / 'D30' : '운송중' / 'D40' : '매출' -- 20181205 'D40' 추가
                        -- 20191120 order_type_code 제약 : lookup_type = 'ERP_ORDER_TYPE'
                        AND   a.order_type_code IN (
                                                    SELECT segment1
                                                    FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
	                                                WHERE  lookup_type = 'ERP_ORDER_TYPE'
	                                                AND    valid_yn    = 'Y'
	                                               )
												   
                        -- PJ20216994
						AND   PLANT_ISSUE_DATE >= @v_min_plant_issue_date

						UNION ALL -- 20181119 추가 : Plant는 기존 로직으로 transport_mode / incoterms 찾기
						SELECT	 @P_ISSUE_DATE result_yyyymmdd
								,company_id
								,a.division_id
								,plant_id
								,order_no AS order_no
								,project_code
								,item_id
								,from_scm_site_id
								,to_scm_site_id
								,soldto_code
								,shipto_code
						        ,a.transport_mode    -- 20181119 추가 : BOD 기준
							    ,NULL incoterms      -- 20181119 추가
								,exfactory_qty
								,on_board_date
								,plant_issue_date
								-- From/To/Tr Mode 기준 => exfactory_date
								,CASE WHEN ISDATE(exfactory_date)  = 1 
								           THEN CONVERT(CHAR(8)
										              , DATEADD(day, ISNULL(b.lt_total, 0), exfactory_date)
										              , 112) 
									  ELSE exfactory_date
								 END f_dest_eta_date	
								,uom
								,lt_total
								,'PLANT' site_type
								,a.exfactory_status
								,a.storage_id       -- 20200218  Storage ID 추가	
						FROM scm_dnm_exfactory_result A WITH(NOLOCK)
						 -- 20181119 변경 : Plant 는 From/To/Tr Mode 기준
						 -- PJ20209642 : BOD LT 1단계 개발( lt_total => add_after_lt_total 변경)
                         -- 20210713 변경
                         -- PJ20209643 : 기존 뷰(scp_mst_bod_v)를 scp_mst_bod_n_v로 변경 및 from_yyyymmdd, to_yyyymmdd 추가 (조인시 중복방지)
						LEFT JOIN ( SELECT A.division_id, A.from_site, A.to_site, A.transport_mode, A.from_yyyymmdd, A.to_yyyymmdd, MAX(add_after_lt_total) lt_total
									FROM   scp_mst_bod_n_v A
									INNER JOIN(
												SELECT division_id, from_site, to_site, transport_mode, from_yyyymmdd, to_yyyymmdd, MIN(priority) priority 
												FROM   scp_mst_bod_n_v  WITH(NOLOCK)
												WHERE  bod_valid_yn = 'Y'
												AND    route_valid_yn = 'Y'
												GROUP BY division_id, from_site, to_site, transport_mode, from_yyyymmdd, to_yyyymmdd) B
									ON    A.division_id      = B.division_id
									AND   A.from_site        = B.from_site
									AND   A.to_site          = B.to_site
						            AND   A.transport_mode   = B.transport_mode
									AND   A.priority         = B.priority
									AND   A.from_yyyymmdd    = B.from_yyyymmdd
									AND   A.to_yyyymmdd      = B.to_yyyymmdd
									AND   A.bod_valid_yn     = 'Y'
									AND   A.route_valid_yn   = 'Y'
									GROUP BY A.division_id, A.from_site,A.to_site, A.transport_mode, A.from_yyyymmdd, A.to_yyyymmdd
									) B
						ON    A.division_id      = B.division_id
						AND   A.from_scm_site_id = B.from_site
						AND   A.to_scm_site_id   = B.to_site
						AND   A.transport_mode   = B.transport_mode
						AND   A.exfactory_date  >= B.from_yyyymmdd -- 20210707 PJ20209643 추가
						AND   A.exfactory_date  <= B.to_yyyymmdd   -- 20210707 PJ20209643 추가

						WHERE 1=1
						-- 2018.11.19 조건 변경
						AND   a.division_id = @v_c1_division_id						
						AND   company_id IN (SELECT segment1 
												FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
												WHERE  lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 
												AND    valid_yn    = 'Y'
											)
						AND   to_scm_site_id IN (SELECT scm_site_id 
											     FROM   scm_mst_site WITH(NOLOCK) 
											     WHERE  site_type = 'PLANT' 
											     AND    valid_yn  = 'Y'
											    )
						AND   exfactory_date >= CONVERT(CHAR(8), DATEADD(DAY, -90, CONVERT(DATE, @P_ISSUE_DATE)), 112) --- 2018.11.19 조건 추가 최근 90일 이내
						AND   exfactory_date <= @P_ISSUE_DATE
						AND   a.exfactory_qty > 0
						AND   a.exfactory_status IN ('D20', 'D30', 'D40') -- 'D20' : '공장출고' / 'D30' : '운송중' / 'D40' : '매출' -- 20181205 'D40' 추가
                        -- 20191120 order_type_code 제약 : lookup_type = 'ERP_ORDER_TYPE'
                        AND   a.order_type_code IN (
                                                    SELECT segment1
                                                    FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
	                                                WHERE  lookup_type = 'ERP_ORDER_TYPE'
	                                                AND    valid_yn    = 'Y'
	                                               )
                        -- PJ20216994
						AND   PLANT_ISSUE_DATE >= @v_min_plant_issue_date

				    ) c
				WHERE  c.f_dest_eta_date >= @P_ISSUE_DATE
				ORDER BY f_dest_eta_date desc

				/*****************  내부 커서 시작 ********************/
				OPEN CUR_EXFACTORY_C2;
				FETCH NEXT FROM CUR_EXFACTORY_C2 INTO    @v_c2_result_yyyymmdd
														,@v_c2_company_id
														,@v_c2_division_id
														,@v_c2_plant_id
														,@v_c2_order_no
														,@v_c2_project_code
														,@v_c2_item_id
														,@v_c2_from_scm_site_id
														,@v_c2_to_scm_site_id
														,@v_c2_soldto_code
														,@v_c2_shipto_code
														,@v_c2_transport_mode -- 20181119 추가
														,@v_c2_incoterms       -- 20181119 추가
														,@v_c2_exfactory_qty
														,@v_c2_on_board_date
														,@v_c2_plant_issue_date
														,@v_c2_f_dest_eta_date
														,@v_c2_uom
														,@v_c2_lt_total
														,@v_c2_site_type -- 20181119 추가
														,@v_c2_exfactory_status
										                ,@v_c2_storage_id  -- 20200218  Storage ID 추가
														;

				SET @v_c2_exfactory_qty_sum = 0;
				WHILE (@@FETCH_STATUS = 0)
				   	BEGIN -- CUR_EXFACTORY_C2	    
					    BEGIN -- SELECT TOP 1
						-- 20181119 IF 조건 추가 : PLANT 인 경우
						  IF @v_c2_site_type = 'PLANT'
						    BEGIN 
                            -- 20210713 변경
                            -- PJ20209643 : 기존 뷰(scp_mst_bod_v)를 scp_mst_bod_n_v로 변경 및 from_yyyymmdd, to_yyyymmdd 추가 (조인시 중복방지)
								--SELECT TOP 1 @v_c2_transport_mode = A.transport_mode
								--		   , @v_c2_incoterms      = A.incoterms
								SELECT TOP 1 @v_c2_incoterms      = A.incoterms
								FROM   scp_mst_bod_n_v A
								INNER JOIN(
											SELECT division_id, from_site, to_site, transport_mode, from_yyyymmdd, to_yyyymmdd, MIN(priority) priority 
											FROM   scp_mst_bod_n_v  WITH(NOLOCK)
											WHERE  bod_valid_yn   = 'Y'
											AND    route_valid_yn = 'Y'
											GROUP BY division_id, from_site, to_site, transport_mode, from_yyyymmdd, to_yyyymmdd) B
								ON    A.division_id    = B.division_id
								AND   A.from_site      = B.from_site
								AND   A.to_site        = B.to_site
								AND   A.transport_mode = B.transport_mode
								AND   A.priority       = B.priority
								AND   A.from_yyyymmdd  = B.from_yyyymmdd
								AND   A.to_yyyymmdd    = B.to_yyyymmdd
								AND   A.bod_valid_yn   = 'Y'
								AND   A.route_valid_yn = 'Y'
								WHERE A.division_id    = @v_c2_division_id
								AND   A.from_site      = @v_c2_from_scm_site_id
								AND   A.to_site        = @v_c2_to_scm_site_id
								AND   A.transport_mode = @v_c2_transport_mode
								-- PJ20209642 : BOD LT 1단계 개발( lt_total => add_after_lt_total 변경)
								--AND   A.lt_total       = @v_c2_lt_total
								AND   A.add_after_lt_total = @v_c2_lt_total
								ORDER BY incoterms DESC
							END

							INSERT INTO scm_dnm_exfactory_result_c_temp$(
											 result_date
											,result_type
											,company_id
											,division_id
											,plant_id
											,shipment_no
											,incoterms
											,fcst_type
											,transport_mode
											,dom_exp
											,project_code
											,item_id
											,from_scm_site_id
											,to_scm_site_id
											,customer_code
											,shipto_code
											,delivery_qty
											,shipping_date
											,f_dest_eta_date
											,plant_issue_date
											,uom
											,exfactory_status
										    ,storage_id  -- 20200218  Storage ID 추가
										)
								VALUES
									(
											 @v_c2_result_yyyymmdd
											,'S'
											,@v_c2_company_id
											,@v_c2_division_id
											,@v_c2_plant_id
											,@v_c2_order_no
											,ISNULL(@v_c2_incoterms,'-')
											,'MPS'
											,ISNULL(@v_c2_transport_mode,'-')
											,'E'
											,ISNULL(@v_c2_project_code,'')
											,@v_c2_item_id
											,@v_c2_from_scm_site_id
											,@v_c2_to_scm_site_id
											,@v_c2_soldto_code
											,@v_c2_shipto_code
											,@v_c2_exfactory_qty
											,@v_c2_on_board_date
											,@v_c2_f_dest_eta_date
											,@v_c2_plant_issue_date
											,@v_c2_uom
											,@v_c2_exfactory_status
										    ,@v_c2_storage_id  -- 20200218  Storage ID 추가
									);
						END -- SELECT TOP 1
								
				FETCH NEXT FROM CUR_EXFACTORY_C2 INTO    @v_c2_result_yyyymmdd
														,@v_c2_company_id
														,@v_c2_division_id
														,@v_c2_plant_id
														,@v_c2_order_no
														,@v_c2_project_code
														,@v_c2_item_id
														,@v_c2_from_scm_site_id
														,@v_c2_to_scm_site_id
														,@v_c2_soldto_code
														,@v_c2_shipto_code
														,@v_c2_transport_mode -- 20181119 추가
														,@v_c2_incoterms       -- 20181119 추가
														,@v_c2_exfactory_qty
														,@v_c2_on_board_date
														,@v_c2_plant_issue_date
														,@v_c2_f_dest_eta_date
														,@v_c2_uom
														,@v_c2_lt_total
														,@v_c2_site_type -- 20181119 추가
														,@v_c2_exfactory_status
										                ,@v_c2_storage_id  -- 20200218  Storage ID 추가
															;
					
			        END -- CUR_EXFACTORY_C2

			    CLOSE CUR_EXFACTORY_C2;
			    DEALLOCATE CUR_EXFACTORY_C2; 
			
		    -- 2018.11.19   커서 변경
		FETCH NEXT FROM CUR_EXFACTORY_C1 INTO  @v_c1_division_id
		--FETCH NEXT FROM CUR_EXFACTORY_C1 INTO  @v_c1_company_id
		--									  ,@v_c1_division_id
		--									  ,@v_c1_plant_id
		--									  ,@v_c1_item_id
		--									  ,@v_c1_scm_qty
											  ;
		END  -- CUR_EXFACTORY_C1
		
		CLOSE CUR_EXFACTORY_C1;
		DEALLOCATE CUR_EXFACTORY_C1; 

		INSERT INTO scm_dnm_intransit_c WITH (TABLOCK)
                                       ( result_date, result_type, company_id, division_id, plant_id, shipment_no, incoterms, fcst_type
                                       , transport_mode, dom_exp, project_code, item_id, from_scm_site_id, to_scm_site_id, customer_code
                                       , shipto_code, delivery_qty, shipping_date, f_dest_eta_date, plant_issue_date, uom, valid_yn
									   , attribute1 -- exfactory_status
									   , attribute2 -- 20200218  Storage ID 추가
                                       , created_by, creation_date, last_updated_by, last_update_date
                                       -- 20201007 PJ20202001  신규 컬럼 추가
                                       , final_soldto_code, final_soldto_name, final_incoterms
                                       )
							 SELECT		 result_date
										,result_type
										,company_id
										,division_id
										,plant_id
										,shipment_no+'_'+CAST(ROW_NUMBER() OVER(PARTITION BY shipment_no ORDER BY shipment_no) AS nvarchar(10))
										,incoterms
										,fcst_type
										,transport_mode
										,dom_exp
										,project_code
										,item_id
										,from_scm_site_id
										,to_scm_site_id
										,customer_code
										,shipto_code
										,SUM(delivery_qty)
										,shipping_date
										,f_dest_eta_date
										,plant_issue_date
										,uom
										,'Y'
										,exfactory_status
										,storage_id  -- 20200218  Storage ID 추가
										,@v_batch_user
										,GETDATE()
										,@v_batch_user
										,GETDATE()
                                        -- 20201007 PJ20202001  신규 컬럼 추가
                                        ,customer_code         AS final_soldto_code
                                        ,'-'                   AS final_soldto_name
                                        ,incoterms             AS final_incoterms
							 FROM scm_dnm_exfactory_result_c_temp$
							 GROUP BY	result_date
										,result_type
										,company_id
										,division_id
										,plant_id
										,shipment_no
										,incoterms
										,fcst_type
										,transport_mode
										,dom_exp
										,project_code
										,item_id
										,from_scm_site_id
										,to_scm_site_id
										,customer_code
										,shipto_code
										,shipping_date
										,f_dest_eta_date
										,plant_issue_date
										,uom
										,exfactory_status
										,storage_id  -- 20200218  Storage ID 추가

        SET @n_log_count = @@ROWCOUNT;
		
		DROP TABLE scm_dnm_exfactory_result_c_temp$;

	  END

    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
