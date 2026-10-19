
/*
 * Program ID   : PR_SCM_DNM_INTRANSIT_CUTOFF
 * Description  :In Transit 실적 정보 I/F 일자별 CUTOFF
 * Program History
 * 
 *===================================================================================================
 *   Date        In Charge     Description
 *===================================================================================================
 * 2018.01.25    Kim Jaejung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.25    Kim Jaejung   하루 전 데이터 삭제 시 출하실적으로 부터 생성된 데이터는 삭제 안함.
 * 2018.05.31    Kim Jaejung   history 용 temp 테이블 생성 로직 수정 , 이전 데이터 from , to site mapping 로직 주석처
 * 2018.09.20    Kim Jihye     무상사급 운송중 재고 산출 로직 추가 
 *                             1. F.Dest.Date 이 과거인 재고는 반영 안함
 *                             2. F.Dest.Date 가 없는 경우 Plant Issue Date 기준 90일 이전 재고 반영 안함 
 * 2018.12.04    KSG           scm_dnm_delivery_tracking : company_id 추가
 * 2020.02.18    KSG           Storage ID 추가
 * 2020.10.07    KSG           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                 Cutoff 테이블에 신규 컬럼 추가 : final_soldto_code / final_soldto_name / final_incoterms
 * 2021.01.22    KSG            C20210121-000295 법인간 운송중 재고 내 ETA 정보 개선(GTS Tracking 정보 동기화)
 * 2021.01.29    KSG            C20210128-000556 [SCM PI팀] SCP시스템의 운송중 재고 정합성을 위한 GTS Tracking정보 UPdate로직 변경의 건
 * 2021.07.01    KSG            C20210629-000587 [SCM PI팀] GSCM 시스템의 운송중 반제품(노치드팬케익) 재고를 적용 시기키기 위한 기능변경 건
 * 2021.09.15    sclee.lee      PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : 해상재고 GTS 정보 고도화
 * 2022.04.01    hrkim          PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선  
 * 2022.07.28    sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - @P_ISSUE_DATE 기준 plant_issue_date가 2년 경과시 scm_dnm_intransit_c에 생성대상서 제외
 * 2023.01.20    sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 3국간 Direct GTS Tracking 오류 대응
 * 2024.06.09    vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.10.28    vadabi3        NERP - 개발 DB 적용
 * 2025.04.02	 kimcd     	    PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 매출 이력 차감에 사용될 attribute4 수량 설정
 ----------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_SCM_DNM_INTRANSIT_CUTOFF]
(
	@P_ISSUE_DATE         NVARCHAR(8)=NULL
)
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_INTRANSIT_CUTOFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;

    -- 년월일 표시형태 변수 설정
    DECLARE @v_date_format  VARCHAR(10) = 'yyyyMMdd';

	-- NERP 매핑코드
    DECLARE @v_ESOC NVARCHAR(8);
	SELECT @v_ESOC = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_INTRANSIT_CUTOFF','ESOC');

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @d_event_date = SYSDATETIME();

    BEGIN TRY
	--BEGIN TRANSACTION
	 IF OBJECT_ID('dbo.scm_dnm_intransit_c_temp$') IS NOT NULL 
	    DROP TABLE scm_dnm_intransit_c_temp$

	IF @P_ISSUE_DATE IS NULL OR ISDATE(@P_ISSUE_DATE) != 1
	    SET @P_ISSUE_DATE = CONVERT(CHAR(8), DATEADD(day,-1,GETDATE()), 112)
	ELSE
	    SET @P_ISSUE_DATE = CONVERT(CHAR(8), DATEADD(day,-1,@P_ISSUE_DATE), 112)
	
    -- PJ20216994
    DECLARE @v_min_plant_issue_date VARCHAR(8) = FORMAT(DATEADD(YEAR, -2, @P_ISSUE_DATE), @v_date_format);

    -- PJ20216994
    -- @P_ISSUE_DATE 확인을 위해 @v_description 위치 변경
    SET @v_description = CONCAT('@P_ISSUE_DATE : ', @P_ISSUE_DATE);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	

/* 	
	DELETE FROM scm_dnm_intransit_c 
	WHERE  result_type = 'I' 
	AND    result_date = @P_ISSUE_DATE
	AND    company_id NOT IN (SELECT segment1 
						      FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
						      WHERE  lookup_type = 'EXFACTORY_INTRANSIT_TARGET'
						      AND    valid_yn = 'Y'); -- 2018. 4. 25

	DELETE FROM scm_dnm_intransit_c WHERE result_type = 'P' AND result_date = @P_ISSUE_DATE;
 */

    -- PJ20216994
    -- MS권고안에 따른 삭제로직 변경
    BEGIN TRAN
    -- 기존내역부터 지우고 시작
    WHILE(1 = 1)
    BEGIN
        DELETE TOP (1000) A
        FROM dbo.scm_dnm_intransit_c A
        WHERE A.RESULT_DATE = @P_ISSUE_DATE
        AND A.RESULT_TYPE = 'I'
        AND A.company_id NOT IN (SELECT segment1 
        		                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
        		                 WHERE lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 
        		                 AND valid_yn = 'Y');
	
        IF(@@ROWCOUNT = 0)
        BEGIN
            BREAK;
        END
    END
	
    WHILE(1 = 1)
    BEGIN
        DELETE TOP (1000) A
        FROM dbo.scm_dnm_intransit_c A
        WHERE A.RESULT_DATE = @P_ISSUE_DATE
        AND A.RESULT_TYPE = 'P';
	
        IF(@@ROWCOUNT = 0)
        BEGIN
            BREAK;
        END
    END
	
    COMMIT


	 -- 20240920 vadabi5 : History Table 에 입력 위해 생성 But big Table 로 처리에 시간 소요 커 개선 필요
	SELECT * INTO dbo.scm_dnm_intransit_c_temp$  -- 2018. 5. 31
	  FROM dbo.scm_dnm_intransit_c WITH(NOLOCK)
	  where RESULT_DATE < @P_ISSUE_DATE 
	  and RESULT_DATE >  convert(nvarchar(10), getdate() - 372, 112);
	  ;

      BEGIN	 	
        -------------------------------------------------
	    -- RESULT 유형 I:Intransit insert
        -------------------------------------------------
		;WITH gts_delivery_tracking as (   
			-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선
			SELECT t.company_id
				  ,t.shipment_no
				  ,t.incoterms
				  ,MAX(t.shipping_date) shipping_date
				  ,MAX(t.pol) pol
				  ,MAX(t.pol_atd_date) pol_atd_date
				  ,MAX(t.pod) pod
				  ,MAX(t.pod_eta_date) pod_eta_date
				  ,MAX(t.pod_ata_date) pod_ata_date
				  ,MAX(t.pod_etd_date) pod_etd_date
				  ,MAX(t.pod_atd_date) pod_atd_date
				  ,MAX(t.f_dest_port_code) f_dest_port_code
				  ,MAX(t.f_dest_eta_date) f_dest_eta_date
				  ,MAX(t.f_dest_ata_date) f_dest_ata_date
				  ,RANK() OVER (PARTITION BY company_id
										    ,shipment_no
									ORDER BY incoterms DESC) AS incoterms_priority 
			  FROM scm_dnm_delivery_tracking t WITH(NOLOCK)
		  GROUP BY t.company_id
				  ,t.shipment_no
				  ,t.incoterms
		),
		sub AS
        (
         SELECT  @P_ISSUE_DATE AS result_date
                 ,CONVERT(CHAR(8),getdate()-1-90, 112) AS cal_date -- 2018.09.20
                 ,'I' AS result_type    
                 ,di.company_id    
                 ,di.division_id 
                 ,di.plant_id    
                 ,di.shipment_no   
                 ,di.project_code	
                 ,di.item_id   
                 ,di.incoterms   
                 ,di.distribution_channel
                 ,di.customer_code
                 ,di.shipto_code   
                 ,di.from_scm_site_id   
                 ,di.from_site_item_mapping_yn   
                 ,di.to_scm_site_id
                 ,di.to_site_item_mapping_yn   
                 ,di.delivery_qty   
                 ,di.uom   
                 ,di.transport_mode     	 					
     	 					
                 ,fcst_type   
                 ,dt.shipping_date   
                 ,dt.pol    	 					
                 ,dt.pod
                 ,dt.f_dest_port_code   
                 ,dt.f_dest_ata_date        
                 ,di.order_type_code -- 2018.09.20
                 ,di.storage_id  -- 20200218  Storage ID 추가
                 -- 20201007 PJ20202001  신규 컬럼 추가
                 ,[dbo].[FN_SCM_SYS_NVL](di.final_soldto_code, di.customer_code) AS final_soldto_code
                 ,[dbo].[FN_SCM_SYS_NVL](di.final_soldto_name, '-')              AS final_soldto_name
                 ,[dbo].[FN_SCM_SYS_NVL](di.final_incoterms, di.incoterms)       AS final_incoterms
				 
                 /* Ex-Factory Date (plant_issue_date) */
                 ,di.plant_issue_date
				 
                 /* 20210915 PJ20214907 */
                 /* pol_atd_date  */
                 /*
                 0. (GTS)POL ATD - scm_dnm_gts_eta_v.pol_atd_date
                 1. (GTS)Shipping Date - scm_dnm_gts_eta_v.shipping_date
                 2. (ERP)di.plant_issue_date + scp_mst_bod_n_v.ship_lt_total
                 */
                 --,dt.pol_atd_date
                 ,ISNULL(IIF(ISNULL(dt.pol_atd_date, '') = '', NULL, CAST(dt.pol_atd_date AS datetime))
                       , IIF(ISNULL(dt.shipping_date, '') = '', NULL, CAST(dt.shipping_date AS datetime))) pol_atd_date

                 ,dt.pod_eta_date
                 ,dt.pod_ata_date
                 ,dt.pod_etd_date
                 ,dt.pod_atd_date
        
                 -- 20210129  C20210128-000556
                 --,dt.f_dest_eta_date dt_f_dest_eta_date

                 /* 2023.01.20 */
                 ,IIF(ISNULL(dt.f_dest_eta_date, '') = '' AND di.ATTRIBUTE7 = 'Y20', dt1.f_dest_eta_date, dt.f_dest_eta_date) dt_f_dest_eta_date
				 
                 /* 20210915 PJ20214907 */
                 /* attribute3 / f_dest_eta_date */
                 /*
				 dt.pod_atd_date 없으면 dt.pod_etd_date
				 dt.pod_etd_date 없으면 dt.pod_ata_date
				 dt.pod_ata_date 없으면 dt.pod_eta_date
				 dt.pod_eta_date 없으면 dt.pol_atd_date
				 dt.pol_atd_date 없으면 dt.shipping_date
				 dt.shipping_date 없으면 di.plant_issue_date
                 */
				 /* -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선으로 변경전소스 주석처리 
                 ,IIF(ISNULL(s.site_type, 'SALES') = 'SALES'
						, IIF(ISNULL(dt.f_dest_eta_date_sales, '') = '', NULL, CAST(dt.f_dest_eta_date_sales AS datetime))
						, IIF(ISNULL(dt.f_dest_eta_date, '') = '', NULL, CAST(dt.f_dest_eta_date AS datetime))) f_dest_eta_date_org
				 */

				 -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선
                 /* 2023.01.20 */
				 ,CASE WHEN ISNULL(s.site_type, 'SALES') = 'SALES'
					   THEN 
							CASE WHEN ic.segment3 = 'A' THEN NULL
							     WHEN ic.segment3 = 'B' THEN IIF(ISNULL(dt.shipping_date, '')='', NULL, CAST(dt.shipping_date AS datetime))
								 WHEN ic.segment3 = 'C' THEN CASE WHEN ISNULL(dt.pol_atd_date, '') = '' 
																  THEN IIF(ISNULL(dt.shipping_date, '')='', NULL, CAST(dt.shipping_date AS datetime))   
																  ELSE IIF(ISNULL(dt.pol_atd_date, '')='' , NULL, CAST(dt.pol_atd_date  AS datetime))        
																  END
								 -- 그외 D,E,F or ic.segment3 is null or ic.segment3 is empty string
								 ELSE						 CASE WHEN ISNULL(dt.f_dest_ata_date, '') = '' 
																  THEN CASE WHEN ISNULL(dt.f_dest_eta_date, '') = '' AND di.ATTRIBUTE7 = 'Y20' THEN  CAST(dt1.f_dest_eta_date  AS datetime)
                                                                            ELSE IIF(ISNULL(dt.f_dest_eta_date, '')='' , NULL, CAST(dt.f_dest_eta_date  AS datetime))
																       END 
																  ELSE IIF(ISNULL(dt.f_dest_ata_date, '')='' , NULL, CAST(dt.f_dest_ata_date  AS datetime))   
															  END 
						    END 
					   ELSE 
							CASE WHEN ISNULL(dt.f_dest_eta_date, '') = '' AND di.ATTRIBUTE7 = 'Y20' THEN  CAST(dt1.f_dest_eta_date  AS datetime)
								 ELSE IIF(ISNULL(dt.f_dest_eta_date, '') = '', NULL, CAST(dt.f_dest_eta_date AS datetime)) 
						    END 
				  END  AS  f_dest_eta_date_org
				 --,CASE WHEN ISNULL(s.site_type, 'SALES') = 'SALES'
					--   THEN 
					--		CASE WHEN ic.segment3 = 'A' THEN NULL
					--		     WHEN ic.segment3 = 'B' THEN IIF(ISNULL(dt.shipping_date, '')='', NULL, CAST(dt.shipping_date AS datetime))
					--			 WHEN ic.segment3 = 'C' THEN CASE WHEN ISNULL(dt.pol_atd_date, '') = '' 
					--											  THEN IIF(ISNULL(dt.shipping_date, '')='', NULL, CAST(dt.shipping_date AS datetime))   
					--											  ELSE IIF(ISNULL(dt.pol_atd_date, '')='' , NULL, CAST(dt.pol_atd_date  AS datetime))        
					--											  END
					--			 -- 그외 D,E,F or ic.segment3 is null or ic.segment3 is empty string
					--			 ELSE						 CASE WHEN ISNULL(dt.f_dest_ata_date, '') = '' 
					--											  THEN IIF(ISNULL(dt.f_dest_eta_date, '')='' , NULL, CAST(dt.f_dest_eta_date  AS datetime))   
					--											  ELSE IIF(ISNULL(dt.f_dest_ata_date, '')='' , NULL, CAST(dt.f_dest_ata_date  AS datetime))   
					--										  END 
					--	    END 
					--   ELSE 
					--		IIF(ISNULL(dt.f_dest_eta_date, '') = '', NULL, CAST(dt.f_dest_eta_date AS datetime)) 
				 -- END  AS  f_dest_eta_date_org
					   
                 ,ISNULL(IIF(ISNULL(dt.pod_atd_date, '') = '', NULL, CAST(dt.pod_atd_date AS datetime))
                       , IIF(ISNULL(dt.pod_etd_date, '') = '', NULL, CAST(dt.pod_etd_date AS datetime))) pod_atd_etd_attribute3
                 ,ISNULL(IIF(ISNULL(dt.pod_atd_date, '') = '', NULL, CAST(dt.pod_atd_date AS datetime))
                       , IIF(ISNULL(dt.pod_etd_date, '') = '', NULL, CAST(dt.pod_etd_date AS datetime))) pod_atd_etd_f_dest_eta_date
					   
                 ,ISNULL(IIF(ISNULL(dt.pod_ata_date, '') = '', NULL, CAST(dt.pod_ata_date AS datetime))
                       , IIF(ISNULL(dt.pod_eta_date, '') = '', NULL, CAST(dt.pod_eta_date AS datetime))) pod_ata_eta_attribute3
                 ,ISNULL(IIF(ISNULL(dt.pod_ata_date, '') = '', NULL, CAST(dt.pod_ata_date AS datetime))
                       , IIF(ISNULL(dt.pod_eta_date, '') = '', NULL, CAST(dt.pod_eta_date AS datetime))) pod_ata_eta_f_dest_eta_date
					   
                 ,ISNULL(IIF(ISNULL(dt.pol_atd_date, '') = '', NULL, CAST(dt.pol_atd_date AS datetime))
                       , IIF(ISNULL(dt.shipping_date, '') = '', NULL, CAST(dt.shipping_date AS datetime))) pol_atd_attribute3
                 ,IIF(ISNULL(di.plant_issue_date, '') = '', NULL, CAST(di.plant_issue_date AS datetime)) plant_issue_attribute3
                 ,ISNULL(IIF(ISNULL(dt.pol_atd_date, '') = '', NULL, CAST(dt.pol_atd_date AS datetime))
                       , IIF(ISNULL(dt.shipping_date, '') = '', NULL, CAST(dt.shipping_date AS datetime))) pol_atd_f_dest_eta_date
                 ,IIF(ISNULL(di.plant_issue_date, '') = '', NULL, CAST(di.plant_issue_date AS datetime)) plant_issue_f_dest_eta_date

                 --,CASE WHEN ISNULL(s.site_type, 'SALES') = 'SALES' THEN dt.f_dest_eta_date_sales
                 --      ELSE dt.f_dest_eta_date 
                 -- END  f_dest_eta_date
                 ,IIF(ISNULL(s.site_type, '') = '', 'SALES', s.site_type)  to_site_type
         FROM    scm_dnm_intransit di WITH(NOLOCK)
		 		
				-- 20210129  C20210128-000556
				 LEFT OUTER JOIN scm_mst_site s WITH(NOLOCK)
						 ON di.division_id    = s.division_id
						AND di.to_scm_site_id = s.scm_site_id
			
				/* -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선으로 변경전소스 주석처리
				 ---- 20210129  C20210128-000556 f_dest_eta_date 로 사용할 컬럼 변경
				 LEFT OUTER JOIN scm_dnm_gts_eta_v dt  WITH(NOLOCK)
						 ON     di.company_id  = dt.company_id -- 20181204 company_id 추가
						 AND    di.shipment_no = dt.shipment_no
				*/
		 
				-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선  
				LEFT OUTER JOIN gts_delivery_tracking  dt 
						ON di.company_id		 = dt.company_id
					   AND di.shipment_no		 = dt.shipment_no
					   AND dt.incoterms_priority = 1
			    LEFT OUTER JOIN scm_adm_lookup_master_detail ic with(nolock) 
						ON ic.lookup_type = 'INCOTERMS'
					   AND ic.valid_yn    = 'Y'
					   AND ic.segment1    = [dbo].[FN_SCM_SYS_NVL](di.final_incoterms, di.incoterms)

                /* 2023.01.20 */
				LEFT OUTER JOIN gts_delivery_tracking  dt1
						ON di.ATTRIBUTE6		 = dt1.shipment_no
					   AND dt1.incoterms_priority = 1
         
         WHERE  isnull(di.sales_posting_date, '') IN ( '', '00000000')
         AND    di.shipment_no > char(0)
		 
         -- PJ20216994
         AND    di.plant_issue_date >= @v_min_plant_issue_date
        ),
        sub_bod AS
        (
          SELECT division_id
                ,from_site
                ,to_site
                ,incoterms
                ,transport_mode
                ,bod_valid_yn
                ,from_yyyymmdd
                ,to_yyyymmdd
				,ISNULL(segment3, 'F') AS segment3

				,ISNULL(ship_lt_total, 0) ship_lt_total

				,CASE WHEN ISNULL(segment3, '') = '' THEN ISNULL(lt_voyage, 0)
				      WHEN segment3  = 'A'           THEN 0
				      WHEN segment3  = 'B'           THEN 0
				      WHEN segment3  = 'C'           THEN 0
				      WHEN segment3  = 'D'           THEN ISNULL(lt_voyage, 0)
				      WHEN segment3  = 'E'           THEN ISNULL(lt_voyage, 0)
				      WHEN segment3  = 'F'           THEN ISNULL(lt_voyage, 0)
				      ELSE                                ISNULL(lt_voyage, 0)
				 END AS lt_voyage

				,CASE WHEN ISNULL(segment3, '') = '' THEN ISNULL(after_lt, 0) + ISNULL(lt_lay_off_clearance, 0)
				      WHEN segment3  = 'A'           THEN 0
				      WHEN segment3  = 'B'           THEN 0
				      WHEN segment3  = 'C'           THEN 0
				      WHEN segment3  = 'D'           THEN ISNULL(after_lt, 0)
				      WHEN segment3  = 'E'           THEN ISNULL(after_lt, 0) + ISNULL(lt_lay_off_clearance, 0)
				      WHEN segment3  = 'F'           THEN ISNULL(after_lt, 0) + ISNULL(lt_lay_off_clearance, 0)
				      ELSE                                ISNULL(after_lt, 0) + ISNULL(lt_lay_off_clearance, 0)
				 END AS lt_lay_off_clearance

				,CASE WHEN ISNULL(segment3, '') = '' THEN ISNULL(lt_arrival_inland, 0)
				      WHEN segment3  = 'A'           THEN 0
				      WHEN segment3  = 'B'           THEN 0
				      WHEN segment3  = 'C'           THEN 0
				      WHEN segment3  = 'D'           THEN 0
				      WHEN segment3  = 'E'           THEN 0
				      WHEN segment3  = 'F'           THEN ISNULL(lt_arrival_inland, 0)
				      ELSE                                ISNULL(lt_arrival_inland, 0)
				 END AS lt_arrival_inland
				 
                ,ISNULL(lt_total, 0) lt_sum
          FROM dbo.scp_mst_bod_n_v
          WHERE bod_valid_yn = 'Y'
        ),
        sub1 AS
        (
          SELECT division_id
                ,from_site
                ,to_site
                ,transport_mode
                ,bod_valid_yn
				-- 데이터 중복문제 관련 해당 컬럼 제외
                --,from_yyyymmdd
                --,to_yyyymmdd
                ,MAX(ISNULL(lt_departure_inland, 0) + ISNULL(lt_wait_shipping, 0) + ISNULL(lt_voyage, 0) + ISNULL(lt_lay_off_clearance, 0) + ISNULL(lt_arrival_inland, 0) + ISNULL(before_lt, 0) + ISNULL(after_lt, 0)) lt_sum
          FROM dbo.scp_mst_bod_v
          WHERE bod_valid_yn = 'Y'
          GROUP BY division_id
                  ,from_site
                  ,to_site
                  ,transport_mode
                  ,bod_valid_yn
                  --,from_yyyymmdd
                  --,to_yyyymmdd
        ),
        sub2 AS
        (
         SELECT MIN(B.bod_id) bod_id
         FROM sub1 A
	     INNER JOIN dbo.scp_mst_bod_n_v B
	     ON A.division_id = B.division_id
         AND A.from_site = B.from_site
         AND A.to_site = B.to_site
         AND A.transport_mode = B.transport_mode
         AND A.bod_valid_yn = B.bod_valid_yn
		 -- 데이터 중복문제 관련 해당 컬럼 제외
         --AND A.from_yyyymmdd = B.from_yyyymmdd
         --AND A.to_yyyymmdd = B.to_yyyymmdd
         AND A.lt_sum = ISNULL(B.lt_departure_inland, 0) + ISNULL(B.lt_wait_shipping, 0) + ISNULL(B.lt_voyage, 0) + ISNULL(B.lt_lay_off_clearance, 0) + ISNULL(B.lt_arrival_inland, 0) + ISNULL(B.before_lt, 0) + ISNULL(B.after_lt, 0)
         GROUP BY A.division_id
                 ,A.from_site
                 ,A.to_site
                 ,A.transport_mode
                 ,A.bod_valid_yn
                 --,A.from_yyyymmdd
                 --,A.to_yyyymmdd
                 ,A.lt_sum
        ),
        sub3 AS
        (
         SELECT A.bod_id
               ,A.division_id
               ,A.from_site
               ,A.to_site
               ,A.transport_mode
               ,A.from_yyyymmdd
               ,A.to_yyyymmdd
               ,A.lt_lay_off_clearance
               ,A.lt_arrival_inland
               ,A.lt_voyage
               ,A.ship_lt_total
               ,A.after_lt
			   ,ISNULL(segment3, 'F') AS segment3
         FROM dbo.scp_mst_bod_n_v A
         INNER JOIN sub2 B
         ON A.bod_id = B.bod_id
        ),
        sub4 AS
        (
		 SELECT A.*
               ,C.ship_lt_total
			   ,ISNULL(ISNULL(C.segment3, B.segment3), 'F') segment3
               ,ISNULL(B.lt_lay_off_clearance, 0) + ISNULL(B.after_lt, 0) + ISNULL(B.lt_arrival_inland, 0) lt_attribute3
               ,ISNULL(B.lt_lay_off_clearance, 0) + ISNULL(B.after_lt, 0) + ISNULL(B.lt_arrival_inland, 0) + ISNULL(B.lt_voyage, 0) lt_attribute3_1
               ,ISNULL(B.lt_lay_off_clearance, 0) + ISNULL(B.after_lt, 0) + ISNULL(B.lt_arrival_inland, 0) + ISNULL(B.lt_voyage, 0) + ISNULL(B.ship_lt_total, 0) lt_attribute3_2
               ,ISNULL(C.lt_lay_off_clearance, 0) +                         ISNULL(C.lt_arrival_inland, 0) lt_f_dest_eta_date  -- after_lt 가 lt_lay_off_clearance 에포함되어 있음
               ,ISNULL(C.lt_lay_off_clearance, 0) +                         ISNULL(C.lt_arrival_inland, 0) + ISNULL(C.lt_voyage, 0) lt_f_dest_eta_date1
               ,ISNULL(C.lt_lay_off_clearance, 0) +                         ISNULL(C.lt_arrival_inland, 0) + ISNULL(C.lt_voyage, 0) + ISNULL(C.ship_lt_total, 0) lt_f_dest_eta_date2
		 FROM sub A
         LEFT JOIN sub3 B
         ON    B.division_id    = A.division_id
         AND   B.from_site      = A.from_scm_site_id
         AND   B.to_site        = A.to_scm_site_id
         AND   B.transport_mode = A.transport_mode
		 -- 데이터 중복문제 관련 해당 컬럼 제외
         --AND   B.from_yyyymmdd <= A.plant_issue_date
         --AND   B.to_yyyymmdd   >= A.plant_issue_date
         LEFT JOIN sub_bod C
         ON    C.division_id    = A.division_id
         AND   C.from_site      = A.from_scm_site_id
         AND   C.to_site        = A.to_scm_site_id
         -- To Site가 PLANT 일 경우 LT 계산용 Incoterms는 'DAP'로 처리함
         --AND   C.incoterms      = [dbo].[FN_SCM_SYS_NVL](A.final_incoterms, A.incoterms)
         AND   C.incoterms      = CASE WHEN to_site_type = 'PLANT' THEN 'DAP'
                                       ELSE [dbo].[FN_SCM_SYS_NVL](A.final_incoterms, A.incoterms)
                                  END
         AND   C.transport_mode = A.transport_mode
         AND   C.from_yyyymmdd <= A.plant_issue_date
         AND   C.to_yyyymmdd   >= A.plant_issue_date
        ),
        sub5 AS
        (
         SELECT *
                /* 20210915 PJ20214907 */
                /* pol_atd_date */
                /*
                0. (GTS)POL ATD - scm_dnm_gts_eta_v.pol_atd_date
                1. (GTS)Shipping Date - scm_dnm_gts_eta_v.shipping_date
                2. (ERP)di.plant_issue_date + scp_mst_bod_n_v.ship_lt_total
                */
               ,ISNULL(IIF(ISNULL(pol_atd_date, '') = '', NULL, FORMAT(pol_atd_date, @v_date_format))
                     , FORMAT(DATEADD(dd, ISNULL(ship_lt_total, 0), CAST(plant_issue_date AS datetime)), @v_date_format)) pol_atd_date1					 
				
               ,CASE WHEN ISNULL(dt_f_dest_eta_date, '') <> '' THEN FORMAT(CAST(dt_f_dest_eta_date AS datetime), @v_date_format)
                     WHEN segment3 IN ('D', 'E', 'F') THEN-- POD >> POL 순
                          ISNULL(IIF(ISNULL(pod_atd_etd_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_atd_etd_attribute3), @v_date_format))
                               , IIF(ISNULL(pod_ata_eta_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_ata_eta_attribute3), @v_date_format)))
                     ELSE NULL -- POD 제외 : 아래서 POL로 처리
			    END attribute3
				
               ,CASE WHEN ISNULL(f_dest_eta_date_org, '') <> '' THEN FORMAT(CAST(f_dest_eta_date_org AS datetime), @v_date_format)
                     WHEN segment3 IN ('D', 'E', 'F') THEN-- POD >> POL 순
                          ISNULL(IIF(ISNULL(pod_atd_etd_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_atd_etd_f_dest_eta_date), @v_date_format))
                               , IIF(ISNULL(pod_ata_eta_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_ata_eta_f_dest_eta_date), @v_date_format)))
                     ELSE NULL -- POD 제외 : 아래서 POL로 처리
			    END f_dest_eta_date
					 
               --,ISNULL(IIF(ISNULL(dt_f_dest_eta_date, '') = '', NULL, FORMAT(CAST(dt_f_dest_eta_date AS datetime), @v_date_format))
               --      , ISNULL(IIF(ISNULL(pod_atd_etd_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_atd_etd_attribute3), @v_date_format))
               --             , IIF(ISNULL(pod_ata_eta_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_ata_eta_attribute3), @v_date_format)))) attribute3               
               
               --,ISNULL(IIF(ISNULL(f_dest_eta_date_org, '') = '', NULL, FORMAT(f_dest_eta_date_org, @v_date_format))
               --      , ISNULL(IIF(ISNULL(pod_atd_etd_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_atd_etd_f_dest_eta_date), @v_date_format))
               --             , IIF(ISNULL(pod_ata_eta_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_ata_eta_f_dest_eta_date), @v_date_format)))) f_dest_eta_date
         FROM sub4
        ),
        sub6 AS
        (
         SELECT *
                /* 20210915 PJ20214907 */
                /* attribute3 / f_dest_eta_date */
                /*
				 dt.pod_atd_date 없으면 dt.pod_etd_date
				 dt.pod_etd_date 없으면 dt.pod_ata_date
				 dt.pod_ata_date 없으면 dt.pod_eta_date
				 dt.pod_eta_date 없으면 dt.pol_atd_date
				 dt.pol_atd_date 없으면 dt.shipping_date
				 dt.shipping_date 없으면 di.plant_issue_date
                */
               ,ISNULL(IIF(ISNULL(attribute3, '') = '', NULL, attribute3)
                     , IIF(ISNULL(pol_atd_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3_1, pol_atd_attribute3), @v_date_format))) attribute3_1
               ,ISNULL(IIF(ISNULL(f_dest_eta_date, '') = '', NULL, f_dest_eta_date)
                     , IIF(ISNULL(pol_atd_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date1, pol_atd_f_dest_eta_date), @v_date_format))) f_dest_eta_date1
         FROM sub5
        ),
        sub7 AS
        (
         SELECT *
                /* 20210915 PJ20214907 */
                /* attribute3 / f_dest_eta_date */
                /*
				 dt.pod_atd_date 없으면 dt.pod_etd_date
				 dt.pod_etd_date 없으면 dt.pod_ata_date
				 dt.pod_ata_date 없으면 dt.pod_eta_date
				 dt.pod_eta_date 없으면 dt.pol_atd_date
				 dt.pol_atd_date 없으면 dt.shipping_date
				 dt.shipping_date 없으면 di.plant_issue_date
                */ 
               ,ISNULL(IIF(ISNULL(attribute3_1, '') = '', NULL, attribute3_1)
                     , IIF(ISNULL(plant_issue_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3_2, plant_issue_attribute3), @v_date_format))) attribute3_2
               ,ISNULL(IIF(ISNULL(f_dest_eta_date1, '') = '', NULL, f_dest_eta_date1)
                     , IIF(ISNULL(plant_issue_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date2, plant_issue_f_dest_eta_date), @v_date_format))) f_dest_eta_date1_2
         FROM sub6
        )
		INSERT INTO scm_dnm_intransit_c with (tablock) (  
				result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id, incoterms, dom_exp
			  , customer_code, shipto_code, from_scm_site_id, from_site_item_mapping_yn, to_scm_site_id, to_site_item_mapping_yn
			  , delivery_qty, uom, transport_mode, plant_issue_date, fcst_type
              , shipping_date, pol, pol_atd_date, pod, pod_eta_date, pod_ata_date, pod_etd_date, pod_atd_date
			  , f_dest_port_code, f_dest_eta_date, attribute3, f_dest_ata_date, valid_yn
			  , attribute2  -- 20200218  Storage ID 추가
			  , created_by, creation_date, last_updated_by, last_update_date		
              -- 20201007 PJ20202001  신규 컬럼 추가
              , final_soldto_code, final_soldto_name, final_incoterms
			  , attribute4 -- 2025.04.02	 kimcd   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 매출 이력 차감에 사용될 attribute4 수량 설정
				)
		SELECT  B.result_date
		       ,B.result_type
			   ,B.company_id
			   ,B.division_id    
			   ,B.plant_id 
			   ,B.shipment_no   
			   ,B.project_code		
			   ,B.item_id    
			   ,B.incoterms  
			   ,MAX([dbo].[FN_SCM_SYS_NVL](dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', B.distribution_channel), 'E')) dom_exp
			   ,MAX(B.customer_code) customer_code
			   ,MAX(B.shipto_code) shipto_code
			   ,MAX(B.from_scm_site_id) from_scm_site_id
			   ,MAX(B.from_site_item_mapping_yn) from_site_item_mapping_yn
			   ,MAX(B.to_scm_site_id) to_scm_site_id
			   ,MAX(B.to_site_item_mapping_yn) to_site_item_mapping_yn
			   ,SUM(B.delivery_qty) delivery_qty 
			   ,MAX(B.uom) uom
			   ,MAX(B.transport_mode) transport_mode
			   ,B.plant_issue_date		
			   ,B.fcst_type
			   ,MAX(B.shipping_date) shipping_date
			   ,MAX(B.pol) pol
			   ,MAX(B.pol_atd_date1) pol_atd_date
			   ,MAX(B.pod) pod
			   ,MAX(B.pod_eta_date) pod_eta_date
			   ,MAX(B.pod_ata_date) pod_ata_date
			   ,MAX(B.pod_etd_date) pod_etd_date
			   ,MAX(B.pod_atd_date) pod_atd_date
			   ,MAX(B.f_dest_port_code) f_dest_port_code
			   ,MAX(B.f_dest_eta_date1_2) f_dest_eta_date
			   ,MAX(B.attribute3_2) attribute3
			   ,MAX(B.f_dest_ata_date) f_dest_ata_date
			   ,'Y' valid_yn
			   ,MAX(B.storage_id) attribute2  -- 20200218  Storage ID 추가 
			   ,@v_batch_user created_by
			   ,getdate() creation_date
			   ,@v_batch_user last_updated_by
			   ,getdate() last_update_date
               -- 20201007 PJ20202001  신규 컬럼 추가
               ,MAX(B.final_soldto_code) final_soldto_code
               ,MAX(B.final_soldto_name) final_soldto_name
               ,MAX(B.final_incoterms) final_incoterms
			   ,SUM(B.delivery_qty)    attribute4 -- 2025.04.02	 kimcd   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 매출 이력 차감에 사용될 attribute4 수량 설정
		FROM   sub7 B
				
		WHERE  (b.order_type_code != 'ZEML'	OR 
		           (ISNULL(b.f_dest_ata_date, '') = '' AND b.plant_issue_date >= cal_date)
			   )
	    AND    b.company_id NOT IN (SELECT segment1 
						            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
						            WHERE  lookup_type = 'EXFACTORY_INTRANSIT_TARGET'
						            AND    valid_yn = 'Y')
		GROUP BY	B.result_date   ,B.result_type    ,B.company_id    ,B.division_id      ,B.plant_id 
				   ,B.shipment_no   ,B.project_code	  ,B.item_id       ,B.plant_issue_date ,B.incoterms, B.fcst_type
		;


		-----------------------------------------------------------
        -- Insert LOG
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'APPEND';
        SET @v_log_message = 'INSERT INTO scm_dnm_intransit_c , result_type = I';
        SET @v_description = N'RESULT 유형 I:Intransit insert';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------

        ------------------------------------------------------------
	    -- Noched Pancake 정보 전극으로 전환 : 20210701 C20210629-000587 
        ------------------------------------------------------------

	    INSERT INTO scm_dnm_intransit_c with (tablock)
		    ( result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id
            , incoterms, dom_exp, customer_code, shipto_code, from_scm_site_id, to_scm_site_id, delivery_qty, uom
            , transport_mode, plant_issue_date, fcst_type, shipping_date, f_dest_eta_date
			-- 20201013 PJ20214907  신규 컬럼 추가
			, attribute3
			, valid_yn
            , created_by, creation_date, last_updated_by, last_update_date
            -- 20201007 PJ20202001  신규 컬럼 추가
            , final_soldto_code, final_soldto_name, final_incoterms
			-- 202109XX sclee.lee 컬럼 추가
			, pol_atd_date, pod_eta_date, pod_ata_date, pod_atd_date, f_dest_ata_date
			, attribute4 -- 2025.04.02	 kimcd   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 매출 이력 차감에 사용될 attribute4 수량 설정
	    )
	    SELECT di.result_date, di.result_type, di.company_id, di.division_id, di.plant_id, di.shipment_no, di.project_code
             , bom.child_item_id  AS item_id
             , di.incoterms, di.dom_exp, di.customer_code, di.shipto_code
             , fr_elec_site.scm_site_id AS from_scm_site_id
             , to_cell_site.scm_site_id AS to_scm_site_id
             ,(di.delivery_qty * ISNULL(bom.child_qty, 1) ) AS delivery_qty
             , di.uom  -- UOM 무시
             , di.transport_mode, di.plant_issue_date, di.fcst_type, di.shipping_date, di.f_dest_eta_date
			 -- 20201013 PJ20214907  신규 컬럼 추가
			 , di.attribute3
			 , di.valid_yn
             , di.created_by, di.creation_date, 'NLF Elec Transfer' AS last_updated_by, di.last_update_date
             -- 20201007 PJ20202001  신규 컬럼 추가
             , di.final_soldto_code, di.final_soldto_name, di.final_incoterms
			-- 202109XX sclee.lee 컬럼 추가
			 , di.pol_atd_date, di.pod_eta_date, di.pod_ata_date, di.pod_atd_date, di.f_dest_ata_date
			 ,(di.delivery_qty * ISNULL(bom.child_qty, 1) ) AS attribute4 -- 2025.04.02	 kimcd   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 매출 이력 차감에 사용될 attribute4 수량 설정
        FROM   scm_dnm_intransit_c di with(nolock)

        INNER JOIN scm_mst_item_sn mi WITH(NOLOCK)
        ON  di.division_id = mi.division_id
        AND di.company_id  = mi.company_id
        AND di.item_id     = mi.item_id
        AND SUBSTRING(ISNULL(mi.scp_flow_id, mi.flow_id), 1, 5) in ('A2000','A5000','A6000','A7000','A8000') -- Child 가 전극이므로 실제는 A2000/A5000 만 해당함

        LEFT JOIN scm_mst_site fr_site with(nolock)
        ON  di.from_scm_site_id = fr_site.scm_site_id
        AND fr_site.site_type   = 'PLANT'

        LEFT JOIN (SELECT division_id, company_id, MAX(scm_site_id) AS scm_site_id
                   FROM   scm_mst_site with(nolock)
                   WHERE  site_type       = 'PLANT'
                   AND    operation_group = 'E'
                   AND    valid_yn        = 'Y'
                   AND    osp_yn          = 'N'
                   GROUP BY division_id, company_id
                  ) fr_elec_site
        ON  fr_site.division_id = CASE WHEN fr_site.company_id = @v_ESOC
		                               THEN fr_elec_site.division_id 
									   ELSE fr_site.division_id 
									   END
        AND fr_site.company_id  = fr_elec_site.company_id

        INNER JOIN scm_mst_site to_site with(nolock)
        ON  di.to_scm_site_id = to_site.scm_site_id
        AND to_site.site_type = 'PLANT'

        LEFT JOIN (SELECT division_id, plant_id, MAX(scm_site_id) AS scm_site_id
                   FROM   scm_mst_site with(nolock)
                   WHERE  site_type       = 'PLANT'
                   AND    operation_group = 'A'
                   AND    valid_yn        = 'Y'
                   AND    osp_yn          = 'N'
                   GROUP BY division_id, plant_id
                  ) to_cell_site 
        ON  to_site.division_id = to_cell_site.division_id
        AND to_site.plant_id    = to_cell_site.plant_id

        LEFT JOIN (SELECT x.division_id, x.plant_id
                        , x.parent_item_id  -- 변환 대상 N/L/F Item
                        , x.child_item_id   -- 전극 item
                        , MAX(CASE WHEN ISNULL(x.child_qty, 0) <= 0 THEN 1
                                   ELSE x.child_qty
                              END)    AS child_qty  
			  				 
                   FROM dbo.scm_mst_bom_sn x WITH(NOLOCK)
                  
                   INNER JOIN dbo.scp_mst_final_item f WITH(NOLOCK) 
                   ON  x.child_division_id = f.division_id
                   AND x.child_item_id     = f.item_id
                   AND f.operation_group   = 'E'
                  
                   WHERE 1=1
                   AND x.alt_priority = 'Y'  -- => FP에서 MODEL별로 전개한 테이블에 적용.
                   GROUP BY x.division_id, x.plant_id, x.parent_item_id, x.child_item_id
                  ) bom
        ON  di.division_id = bom.division_id
        AND di.plant_id    = bom.plant_id
        AND di.item_id     = bom.parent_item_id

        WHERE result_type = 'I' 
        AND   result_date = @P_ISSUE_DATE
        AND   bom.child_item_id IS NOT NULL;

        -----------------------------------------------------------
        -- Insert LOG
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'APPEND';
        SET @v_log_message = 'NLF -> Elec Transfer';
        SET @v_description = 'result_date = ' + @P_ISSUE_DATE;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------

        UPDATE di
        SET    from_scm_site_id = NULL
             , to_scm_site_id   = NULL
             , last_updated_by  = 'NLF Scm Site Id Update'
        FROM   scm_dnm_intransit_c di with(nolock)

        INNER JOIN scm_mst_item_sn mi WITH(NOLOCK)
        ON  di.division_id = mi.division_id
        AND di.company_id  = mi.company_id
        AND di.item_id     = mi.item_id
        AND SUBSTRING(ISNULL(mi.scp_flow_id, mi.flow_id), 1, 5) in ('A2000','A5000','A6000','A7000','A8000') -- Child 가 전극이므로 실제는 A2000/A5000 만 해당함

        WHERE result_type = 'I' 
        AND   result_date = @P_ISSUE_DATE
        AND   di.to_scm_site_id IS NOT NULL;
	  
        -----------------------------------------------------------
        -- Insert LOG
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'APPEND';
        SET @v_log_message = 'NLF Scm Site Id Update';
        SET @v_description = 'result_date = ' + @P_ISSUE_DATE;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------

        -----------------------------------------------------------
		-- RESULT 유형 P: 출하실적 insert;
        -----------------------------------------------------------		
        ;WITH delivery_tracking as (   
			-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선
			SELECT t.company_id
				  ,t.shipment_no
				  ,t.incoterms
				  ,MAX(t.shipping_date) shipping_date
				  ,MAX(t.pol) pol
				  ,MAX(t.pol_atd_date) pol_atd_date
				  ,MAX(t.pod) pod
				  ,MAX(t.pod_eta_date) pod_eta_date
				  ,MAX(t.pod_ata_date) pod_ata_date
				  ,MAX(t.pod_etd_date) pod_etd_date
				  ,MAX(t.pod_atd_date) pod_atd_date
				  ,MAX(t.f_dest_port_code) f_dest_port_code
				  ,MAX(t.f_dest_eta_date) f_dest_eta_date
				  ,MAX(t.f_dest_ata_date) f_dest_ata_date
				  ,RANK() OVER (PARTITION BY company_id
										    ,shipment_no
									ORDER BY incoterms DESC) AS incoterms_rnk 
			  FROM scm_dnm_delivery_tracking t WITH(NOLOCK)
		  GROUP BY t.company_id
				  ,t.shipment_no
				  ,t.incoterms
		),
		sub AS
        (
         SELECT  @P_ISSUE_DATE AS result_date
                 ,CONVERT(CHAR(8),getdate()-1-90, 112) AS cal_date -- 2018.09.20
                 ,'P' AS result_type    
                 ,di.company_id    
                 ,di.division_id 
                 ,di.plant_id    
                 ,di.shipment_no   
                 ,di.project_code	
                 ,di.item_id   
                 ,di.incoterms   
                 ,di.distribution_channel
                 ,di.customer_code
                 ,di.shipto_code   
                 ,di.from_scm_site_id   
                 ,di.from_site_item_mapping_yn   
                 ,di.to_scm_site_id
                 ,di.to_site_item_mapping_yn   
                 ,di.delivery_qty   
                 ,di.uom   
                 ,di.transport_mode     	 					
     	 					
                 ,fcst_type   
                 ,dt.shipping_date   
                 ,dt.pol    	 					
                 ,dt.pod
                 ,dt.f_dest_port_code   
                 ,dt.f_dest_ata_date        
                 ,di.order_type_code -- 2018.09.20
                 ,di.storage_id  -- 20200218  Storage ID 추가
                 -- 20201007 PJ20202001  신규 컬럼 추가
                 ,[dbo].[FN_SCM_SYS_NVL](di.final_soldto_code, di.customer_code) AS final_soldto_code
                 ,[dbo].[FN_SCM_SYS_NVL](di.final_soldto_name, '-')              AS final_soldto_name
                 ,[dbo].[FN_SCM_SYS_NVL](di.final_incoterms, di.incoterms)       AS final_incoterms
				 
                 /* Ex-Factory Date (plant_issue_date) */
                 ,di.plant_issue_date
				 
                 /* 20210915 PJ20214907 */
                 /* pol_atd_date  */
                 /*
                 0. (GTS)POL ATD - scm_dnm_gts_eta_v.pol_atd_date
                 1. (GTS)Shipping Date - scm_dnm_gts_eta_v.shipping_date
                 2. (ERP)di.plant_issue_date + scp_mst_bod_n_v.ship_lt_total
                 */
                 --,dt.pol_atd_date
                 ,ISNULL(IIF(ISNULL(dt.pol_atd_date, '') = '', NULL, CAST(dt.pol_atd_date AS datetime))
                       , IIF(ISNULL(dt.shipping_date, '') = '', NULL, CAST(dt.shipping_date AS datetime))) pol_atd_date

                 ,dt.pod_eta_date
                 ,dt.pod_ata_date
                 ,dt.pod_etd_date
                 ,dt.pod_atd_date
        
                 -- 20210129  C20210128-000556
                 ,dt.f_dest_eta_date dt_f_dest_eta_date
				 
                 /* 20210915 PJ20214907 */
                 /* attribute3 / f_dest_eta_date */
                 /*
				 dt.pod_atd_date 없으면 dt.pod_etd_date
				 dt.pod_etd_date 없으면 dt.pod_ata_date
				 dt.pod_ata_date 없으면 dt.pod_eta_date
				 dt.pod_eta_date 없으면 dt.pol_atd_date
				 dt.pol_atd_date 없으면 dt.shipping_date
				 dt.shipping_date 없으면 di.plant_issue_date
                 */
                 /* -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선으로 변경전소스 주석처리 
                 ,IIF(ISNULL(s.site_type, 'SALES') = 'SALES'
					, IIF(ISNULL(dt.f_dest_eta_date_sales, '') = '', NULL, CAST(dt.f_dest_eta_date_sales AS datetime))
					, IIF(ISNULL(dt.f_dest_eta_date, '') = '', NULL, CAST(dt.f_dest_eta_date AS datetime))) f_dest_eta_date_org
				 */

				 -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선
				 ,CASE WHEN ISNULL(s.site_type, 'SALES') = 'SALES'
					   THEN 
							CASE WHEN ic.segment3 = 'A' THEN NULL
							     WHEN ic.segment3 = 'B' THEN IIF(ISNULL(dt.shipping_date, '')='', NULL, CAST(dt.shipping_date AS datetime))
								 WHEN ic.segment3 = 'C' THEN CASE WHEN ISNULL(dt.pol_atd_date, '') = '' 
																  THEN IIF(ISNULL(dt.shipping_date, '')='', NULL, CAST(dt.shipping_date AS datetime))   
																  ELSE IIF(ISNULL(dt.pol_atd_date, '')='' , NULL, CAST(dt.pol_atd_date  AS datetime))        
																  END
								 -- 그외 D,E,F or ic.segment3 is null or ic.segment3 is empty string
								 ELSE						 CASE WHEN ISNULL(dt.f_dest_ata_date, '') = '' 
																  THEN IIF(ISNULL(dt.f_dest_eta_date, '')='' , NULL, CAST(dt.f_dest_eta_date  AS datetime))   
																  ELSE IIF(ISNULL(dt.f_dest_ata_date, '')='' , NULL, CAST(dt.f_dest_ata_date  AS datetime))   
															  END 
						    END 
					   ELSE 
							IIF(ISNULL(dt.f_dest_eta_date, '') = '', NULL, CAST(dt.f_dest_eta_date AS datetime)) 
				  END  AS  f_dest_eta_date_org
					   
                 ,ISNULL(IIF(ISNULL(dt.pod_atd_date, '') = '', NULL, CAST(dt.pod_atd_date AS datetime))
                       , IIF(ISNULL(dt.pod_etd_date, '') = '', NULL, CAST(dt.pod_etd_date AS datetime))) pod_atd_etd_attribute3
                 ,ISNULL(IIF(ISNULL(dt.pod_atd_date, '') = '', NULL, CAST(dt.pod_atd_date AS datetime))
                       , IIF(ISNULL(dt.pod_etd_date, '') = '', NULL, CAST(dt.pod_etd_date AS datetime))) pod_atd_etd_f_dest_eta_date
					   
                 ,ISNULL(IIF(ISNULL(dt.pod_ata_date, '') = '', NULL, CAST(dt.pod_ata_date AS datetime))
                       , IIF(ISNULL(dt.pod_eta_date, '') = '', NULL, CAST(dt.pod_eta_date AS datetime))) pod_ata_eta_attribute3
                 ,ISNULL(IIF(ISNULL(dt.pod_ata_date, '') = '', NULL, CAST(dt.pod_ata_date AS datetime))
                       , IIF(ISNULL(dt.pod_eta_date, '') = '', NULL, CAST(dt.pod_eta_date AS datetime))) pod_ata_eta_f_dest_eta_date
					   
                 ,ISNULL(IIF(ISNULL(dt.pol_atd_date, '') = '', NULL, CAST(dt.pol_atd_date AS datetime))
                       , IIF(ISNULL(dt.shipping_date, '') = '', NULL, CAST(dt.shipping_date AS datetime))) pol_atd_attribute3
                 ,IIF(ISNULL(di.plant_issue_date, '') = '', NULL, CAST(di.plant_issue_date AS datetime)) plant_issue_attribute3
                 ,ISNULL(IIF(ISNULL(dt.pol_atd_date, '') = '', NULL, CAST(dt.pol_atd_date AS datetime))
                       , IIF(ISNULL(dt.shipping_date, '') = '', NULL, CAST(dt.shipping_date AS datetime))) pol_atd_f_dest_eta_date
                 ,IIF(ISNULL(di.plant_issue_date, '') = '', NULL, CAST(di.plant_issue_date AS datetime)) plant_issue_f_dest_eta_date

                 --,CASE WHEN ISNULL(s.site_type, 'SALES') = 'SALES' THEN dt.f_dest_eta_date_sales
                 --      ELSE dt.f_dest_eta_date 
                 -- END  f_dest_eta_date
                 ,IIF(ISNULL(s.site_type, '') = '', 'SALES', s.site_type)  to_site_type
         FROM    scm_dnm_intransit di WITH(NOLOCK)
		 		
				 -- 20210129  C20210128-000556
				 LEFT OUTER JOIN scm_mst_site s WITH(NOLOCK)
				 ON  di.division_id    = s.division_id
				 AND di.to_scm_site_id = s.scm_site_id

				/* -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선으로 변경전소스 주석처리 
                 -- 20210129  C20210128-000556 f_dest_eta_date 로 사용할 컬럼 변경
				 LEFT OUTER JOIN scm_dnm_gts_eta_v dt  WITH(NOLOCK)
				 ON     di.company_id  = dt.company_id -- 20181204 company_id 추가
				 AND    di.shipment_no = dt.shipment_no
				*/

				-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선  
				LEFT OUTER JOIN delivery_tracking dt 
						ON di.company_id    = dt.company_id
					   AND di.shipment_no   = dt.shipment_no
					   AND dt.incoterms_rnk = 1
			    LEFT OUTER JOIN scm_adm_lookup_master_detail ic with(nolock) 
						ON ic.lookup_type = 'INCOTERMS'
					   AND ic.valid_yn    = 'Y'
					   AND ic.segment1    = [dbo].[FN_SCM_SYS_NVL](di.final_incoterms, di.incoterms)
         
         WHERE  isnull(di.sales_posting_date, '') IN ( '', '00000000')
         AND    di.shipment_no > char(0)
		 
         -- PJ20216994
         AND    di.plant_issue_date >= @v_min_plant_issue_date
        ),
        sub_bod AS
        (
          SELECT division_id
                ,from_site
                ,to_site
                ,incoterms
                ,transport_mode
                ,bod_valid_yn
                ,from_yyyymmdd
                ,to_yyyymmdd
				,ISNULL(segment3, 'F') AS segment3
				,ISNULL(ship_lt_total, 0) ship_lt_total

				,CASE WHEN ISNULL(segment3, '') = '' THEN ISNULL(lt_voyage, 0)
				      WHEN segment3  = 'A'           THEN 0
				      WHEN segment3  = 'B'           THEN 0
				      WHEN segment3  = 'C'           THEN 0
				      WHEN segment3  = 'D'           THEN ISNULL(lt_voyage, 0)
				      WHEN segment3  = 'E'           THEN ISNULL(lt_voyage, 0)
				      WHEN segment3  = 'F'           THEN ISNULL(lt_voyage, 0)
				      ELSE                                ISNULL(lt_voyage, 0)
				 END AS lt_voyage

				,CASE WHEN ISNULL(segment3, '') = '' THEN ISNULL(after_lt, 0) + ISNULL(lt_lay_off_clearance, 0)
				      WHEN segment3  = 'A'           THEN 0
				      WHEN segment3  = 'B'           THEN 0
				      WHEN segment3  = 'C'           THEN 0
				      WHEN segment3  = 'D'           THEN ISNULL(after_lt, 0)
				      WHEN segment3  = 'E'           THEN ISNULL(after_lt, 0) + ISNULL(lt_lay_off_clearance, 0)
				      WHEN segment3  = 'F'           THEN ISNULL(after_lt, 0) + ISNULL(lt_lay_off_clearance, 0)
				      ELSE                                ISNULL(after_lt, 0) + ISNULL(lt_lay_off_clearance, 0)
				 END AS lt_lay_off_clearance

				,CASE WHEN ISNULL(segment3, '') = '' THEN ISNULL(lt_arrival_inland, 0)
				      WHEN segment3  = 'A'           THEN 0
				      WHEN segment3  = 'B'           THEN 0
				      WHEN segment3  = 'C'           THEN 0
				      WHEN segment3  = 'D'           THEN 0
				      WHEN segment3  = 'E'           THEN 0
				      WHEN segment3  = 'F'           THEN ISNULL(lt_arrival_inland, 0)
				      ELSE                                ISNULL(lt_arrival_inland, 0)
				 END AS lt_arrival_inland
				 
                ,ISNULL(lt_total, 0) lt_sum
          FROM dbo.scp_mst_bod_n_v
          WHERE bod_valid_yn = 'Y'
        ),
        sub1 AS
        (
          SELECT division_id
                ,from_site
                ,to_site
                ,transport_mode
                ,bod_valid_yn
				-- 데이터 중복문제 관련 해당 컬럼 제외
                --,from_yyyymmdd
                --,to_yyyymmdd
                ,MAX(ISNULL(lt_departure_inland, 0) + ISNULL(lt_wait_shipping, 0) + ISNULL(lt_voyage, 0) + ISNULL(lt_lay_off_clearance, 0) + ISNULL(lt_arrival_inland, 0) + ISNULL(before_lt, 0) + ISNULL(after_lt, 0)) lt_sum
          FROM dbo.scp_mst_bod_v
          WHERE bod_valid_yn = 'Y'
          GROUP BY division_id
                  ,from_site
                  ,to_site
                  ,transport_mode
                  ,bod_valid_yn
				  -- 데이터 중복문제 관련 해당 컬럼 제외
                  --,from_yyyymmdd
                  --,to_yyyymmdd
        ),
        sub2 AS
        (
         SELECT MIN(B.bod_id) bod_id
         FROM sub1 A
	     INNER JOIN dbo.scp_mst_bod_n_v B
	     ON A.division_id = B.division_id
         AND A.from_site = B.from_site
         AND A.to_site = B.to_site
         AND A.transport_mode = B.transport_mode
         AND A.bod_valid_yn = B.bod_valid_yn
		 -- 데이터 중복문제 관련 해당 컬럼 제외
         --AND A.from_yyyymmdd = B.from_yyyymmdd
         --AND A.to_yyyymmdd = B.to_yyyymmdd
         AND A.lt_sum = ISNULL(B.lt_departure_inland, 0) + ISNULL(B.lt_wait_shipping, 0) + ISNULL(B.lt_voyage, 0) + ISNULL(B.lt_lay_off_clearance, 0) + ISNULL(B.lt_arrival_inland, 0) + ISNULL(B.before_lt, 0) + ISNULL(B.after_lt, 0)
         GROUP BY A.division_id
                 ,A.from_site
                 ,A.to_site
                 ,A.transport_mode
                 ,A.bod_valid_yn
                 --,A.from_yyyymmdd
                 --,A.to_yyyymmdd
                 ,A.lt_sum
        ),
        sub3 AS
        (
         SELECT A.bod_id
               ,A.division_id
               ,A.from_site
               ,A.to_site
               ,A.transport_mode
               ,A.from_yyyymmdd
               ,A.to_yyyymmdd
               ,A.lt_lay_off_clearance
               ,A.lt_arrival_inland
               ,A.lt_voyage
               ,A.ship_lt_total
               ,A.after_lt
			   ,ISNULL(segment3, 'F') AS segment3
         FROM dbo.scp_mst_bod_n_v A
         INNER JOIN sub2 B
         ON A.bod_id = B.bod_id
        ),
        sub4 AS
        (
		 SELECT A.*
               ,C.ship_lt_total
			   ,ISNULL(ISNULL(C.segment3, B.segment3), 'F') segment3
               ,ISNULL(B.lt_lay_off_clearance, 0) + ISNULL(B.after_lt, 0) + ISNULL(B.lt_arrival_inland, 0) lt_attribute3
               ,ISNULL(B.lt_lay_off_clearance, 0) + ISNULL(B.after_lt, 0) + ISNULL(B.lt_arrival_inland, 0) + ISNULL(B.lt_voyage, 0) lt_attribute3_1
               ,ISNULL(B.lt_lay_off_clearance, 0) + ISNULL(B.after_lt, 0) + ISNULL(B.lt_arrival_inland, 0) + ISNULL(B.lt_voyage, 0) + ISNULL(B.ship_lt_total, 0) lt_attribute3_2
			   /* 2022.04.06 변경전 
			      이미 위에서 lt_lay_off_clearance에 after_lt가 포함되어 있는데 또 더하고 있음. 
               ,ISNULL(C.lt_lay_off_clearance, 0) + ISNULL(B.after_lt, 0) + ISNULL(C.lt_arrival_inland, 0) lt_f_dest_eta_date
               ,ISNULL(C.lt_lay_off_clearance, 0) + ISNULL(B.after_lt, 0) + ISNULL(C.lt_arrival_inland, 0) + ISNULL(C.lt_voyage, 0) lt_f_dest_eta_date1
               ,ISNULL(C.lt_lay_off_clearance, 0) + ISNULL(B.after_lt, 0) + ISNULL(C.lt_arrival_inland, 0) + ISNULL(C.lt_voyage, 0) + ISNULL(C.ship_lt_total, 0) lt_f_dest_eta_date2
			   */
			   -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선  (2022.04.06 : after_lt 중복 집계 오류 수정) 
               ,ISNULL(C.lt_lay_off_clearance, 0)                         + ISNULL(C.lt_arrival_inland, 0) lt_f_dest_eta_date
               ,ISNULL(C.lt_lay_off_clearance, 0)                         + ISNULL(C.lt_arrival_inland, 0) + ISNULL(C.lt_voyage, 0) lt_f_dest_eta_date1
               ,ISNULL(C.lt_lay_off_clearance, 0)                         + ISNULL(C.lt_arrival_inland, 0) + ISNULL(C.lt_voyage, 0) + ISNULL(C.ship_lt_total, 0) lt_f_dest_eta_date2
		 FROM sub A
         LEFT JOIN sub3 B
         ON    B.division_id    = A.division_id
         AND   B.from_site      = A.from_scm_site_id
         AND   B.to_site        = A.to_scm_site_id
         AND   B.transport_mode = A.transport_mode
		 -- 데이터 중복문제 관련 해당 컬럼 제외
         --AND   B.from_yyyymmdd <= A.plant_issue_date
         --AND   B.to_yyyymmdd   >= A.plant_issue_date
         LEFT JOIN sub_bod C
         ON    C.division_id    = A.division_id
         AND   C.from_site      = A.from_scm_site_id
         AND   C.to_site        = A.to_scm_site_id
         -- To Site가 PLANT 일 경우 LT 계산용 Incoterms는 'DAP'로 처리함
         --AND   C.incoterms      = [dbo].[FN_SCM_SYS_NVL](A.final_incoterms, A.incoterms)
         AND   C.incoterms      = CASE WHEN to_site_type = 'PLANT' THEN 'DAP'
                                       ELSE [dbo].[FN_SCM_SYS_NVL](A.final_incoterms, A.incoterms)
                                  END
         AND   C.transport_mode = A.transport_mode
         AND   C.from_yyyymmdd <= A.plant_issue_date
         AND   C.to_yyyymmdd   >= A.plant_issue_date
        ),
        sub5 AS
        (
         SELECT *
                /* 20210915 PJ20214907 */
                /* pol_atd_date */
                /*
                0. (GTS)POL ATD - scm_dnm_gts_eta_v.pol_atd_date
                1. (GTS)Shipping Date - scm_dnm_gts_eta_v.shipping_date
                2. (ERP)di.plant_issue_date + scp_mst_bod_n_v.ship_lt_total
                */
               ,ISNULL(IIF(ISNULL(pol_atd_date, '') = '', NULL, FORMAT(pol_atd_date, @v_date_format))
                     , FORMAT(DATEADD(dd, ISNULL(ship_lt_total, 0), CAST(plant_issue_date AS datetime)), @v_date_format)) pol_atd_date1			 
				
               ,CASE WHEN ISNULL(dt_f_dest_eta_date, '') <> '' THEN FORMAT(CAST(dt_f_dest_eta_date AS datetime), @v_date_format)
                     WHEN segment3 IN ('D', 'E', 'F') THEN-- POD >> POL 순
                          ISNULL(IIF(ISNULL(pod_atd_etd_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_atd_etd_attribute3), @v_date_format))
                               , IIF(ISNULL(pod_ata_eta_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_ata_eta_attribute3), @v_date_format)))
                     ELSE NULL -- POD 제외 : 아래서 POL로 처리
			    END attribute3
				
               ,CASE WHEN ISNULL(f_dest_eta_date_org, '') <> '' THEN FORMAT(CAST(f_dest_eta_date_org AS datetime), @v_date_format)
                     WHEN segment3 IN ('D', 'E', 'F') THEN-- POD >> POL 순
                          ISNULL(IIF(ISNULL(pod_atd_etd_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_atd_etd_f_dest_eta_date), @v_date_format))
                               , IIF(ISNULL(pod_ata_eta_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_ata_eta_f_dest_eta_date), @v_date_format)))
                     ELSE NULL -- POD 제외 : 아래서 POL로 처리
			    END f_dest_eta_date
					 
               --,ISNULL(IIF(ISNULL(dt_f_dest_eta_date, '') = '', NULL, FORMAT(CAST(dt_f_dest_eta_date AS datetime), @v_date_format))
               --      , ISNULL(IIF(ISNULL(pod_atd_etd_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_atd_etd_attribute3), @v_date_format))
               --             , IIF(ISNULL(pod_ata_eta_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_ata_eta_attribute3), @v_date_format)))) attribute3               
               
               --,ISNULL(IIF(ISNULL(f_dest_eta_date_org, '') = '', NULL, FORMAT(f_dest_eta_date_org, @v_date_format))
               --      , ISNULL(IIF(ISNULL(pod_atd_etd_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_atd_etd_f_dest_eta_date), @v_date_format))
               --             , IIF(ISNULL(pod_ata_eta_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_ata_eta_f_dest_eta_date), @v_date_format)))) f_dest_eta_date
         FROM sub4
        ),
        sub6 AS
        (
         SELECT *
                /* 20210915 PJ20214907 */
                /* attribute3 / f_dest_eta_date */
                /*
				 dt.pod_atd_date 없으면 dt.pod_etd_date
				 dt.pod_etd_date 없으면 dt.pod_ata_date
				 dt.pod_ata_date 없으면 dt.pod_eta_date
				 dt.pod_eta_date 없으면 dt.pol_atd_date
				 dt.pol_atd_date 없으면 dt.shipping_date
				 dt.shipping_date 없으면 di.plant_issue_date
                */
               ,ISNULL(IIF(ISNULL(attribute3, '') = '', NULL, attribute3)
                     , IIF(ISNULL(pol_atd_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3_1, pol_atd_attribute3), @v_date_format))) attribute3_1
               ,ISNULL(IIF(ISNULL(f_dest_eta_date, '') = '', NULL, f_dest_eta_date)
                     , IIF(ISNULL(pol_atd_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date1, pol_atd_f_dest_eta_date), @v_date_format))) f_dest_eta_date1
         FROM sub5
        ),
        sub7 AS
        (
         SELECT *
                /* 20210915 PJ20214907 */
                /* attribute3 / f_dest_eta_date */
                /*
				 dt.pod_atd_date 없으면 dt.pod_etd_date
				 dt.pod_etd_date 없으면 dt.pod_ata_date
				 dt.pod_ata_date 없으면 dt.pod_eta_date
				 dt.pod_eta_date 없으면 dt.pol_atd_date
				 dt.pol_atd_date 없으면 dt.shipping_date
				 dt.shipping_date 없으면 di.plant_issue_date
                */ 
               ,ISNULL(IIF(ISNULL(attribute3_1, '') = '', NULL, attribute3_1)
                     , IIF(ISNULL(plant_issue_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3_2, plant_issue_attribute3), @v_date_format))) attribute3_2
               ,ISNULL(IIF(ISNULL(f_dest_eta_date1, '') = '', NULL, f_dest_eta_date1)
                     , IIF(ISNULL(plant_issue_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date2, plant_issue_f_dest_eta_date), @v_date_format))) f_dest_eta_date1_2
         FROM sub6
        )
		INSERT INTO scm_dnm_intransit_c with (tablock) (  
				result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id, incoterms, dom_exp
			  , customer_code, shipto_code, from_scm_site_id, from_site_item_mapping_yn, to_scm_site_id, to_site_item_mapping_yn
			  , delivery_qty, uom, transport_mode, plant_issue_date, fcst_type
              , shipping_date, pol, pol_atd_date, pod, pod_eta_date, pod_ata_date, pod_etd_date, pod_atd_date
			  , f_dest_port_code, f_dest_eta_date
			  -- 20201013 PJ20214907  신규 컬럼 추가
			  , attribute3
			  , f_dest_ata_date, valid_yn
			  , attribute2  -- 20200218  Storage ID 추가
			  , created_by, creation_date, last_updated_by, last_update_date		
              -- 20201007 PJ20202001  신규 컬럼 추가
              , final_soldto_code, final_soldto_name, final_incoterms
			   )
		SELECT  B.result_date
		       ,B.result_type
			   ,B.company_id
			   ,B.division_id    
			   ,B.plant_id 
			   ,B.shipment_no   
			   ,B.project_code		
			   ,B.item_id    
			   ,B.incoterms  
			   ,MAX([dbo].[FN_SCM_SYS_NVL](dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', B.distribution_channel), 'E')) dom_exp
			   ,MAX(B.customer_code) customer_code
			   ,MAX(B.shipto_code) shipto_code
			   ,MAX(B.from_scm_site_id) from_scm_site_id
			   ,MAX(B.from_site_item_mapping_yn) from_site_item_mapping_yn
			   ,MAX(B.to_scm_site_id) to_scm_site_id
			   ,MAX(B.to_site_item_mapping_yn) to_site_item_mapping_yn
			   ,SUM(B.delivery_qty) delivery_qty 
			   ,MAX(B.uom) uom
			   ,MAX(B.transport_mode) transport_mode
			   ,B.plant_issue_date		
			   ,B.fcst_type
			   ,MAX(B.shipping_date) shipping_date
			   ,MAX(B.pol) pol
			   ,MAX(B.pol_atd_date1) pol_atd_date
			   ,MAX(B.pod) pod
			   ,MAX(B.pod_eta_date) pod_eta_date
			   ,MAX(B.pod_ata_date) pod_ata_date
			   ,MAX(B.pod_etd_date) pod_etd_date
			   ,MAX(B.pod_atd_date) pod_atd_date
			   ,MAX(B.f_dest_port_code) f_dest_port_code
			   ,MAX(B.f_dest_eta_date1_2) f_dest_eta_date
			   ,MAX(B.attribute3_2) attribute3
			   ,MAX(B.f_dest_ata_date) f_dest_ata_date
			   ,'Y' valid_yn
			   ,MAX(B.storage_id) attribute2  -- 20200218  Storage ID 추가 
			   ,@v_batch_user created_by
			   ,getdate() creation_date
			   ,@v_batch_user last_updated_by
			   ,getdate() last_update_date
               -- 20201007 PJ20202001  신규 컬럼 추가
               ,MAX(B.final_soldto_code) final_soldto_code
               ,MAX(B.final_soldto_name) final_soldto_name
               ,MAX(B.final_incoterms) final_incoterms
		FROM   sub7 B
		GROUP BY	B.result_date   ,B.result_type    ,B.company_id    ,B.division_id      ,B.plant_id 
				   ,B.shipment_no   ,B.project_code	  ,B.item_id       ,B.plant_issue_date ,B.incoterms, B.fcst_type
		;

		-----------------------------------------------------------
        -- Insert LOG
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'APPEND';
        SET @v_log_message = 'INSERT INTO scm_dnm_intransit_c , result_type = P';
        SET @v_description = N'RESULT 유형 P: 출하실적 insert';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------

		SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_DNM_INTRANSIT_C_H		 
		 INSERT INTO [dbo].[scm_dnm_intransit_c_h] with (tablock) (
                      history_seq
                    , result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id, plant_issue_date, incoterms, fcst_type, dom_exp
                    , customer_code, shipto_code, from_scm_site_id, from_site_item_mapping_yn, to_scm_site_id, to_site_item_mapping_yn
                    , delivery_qty, uom, transport_mode
                    , shipping_date, pol, pol_atd_date, pod, pod_eta_date, pod_ata_date, pod_etd_date, pod_atd_date
                    , f_dest_port_code, f_dest_eta_date, f_dest_ata_date, valid_yn
                    -- 20201007 PJ20202001  신규 컬럼 추가
                    , final_soldto_code, final_soldto_name, final_incoterms	  	  
					, attribute4 -- 2025.04.02	 kimcd   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 매출 이력 차감에 사용될 attribute4 수량 설정
                    , creation_date, last_update_date	
                    , created_by, last_updated_by, history_creation_date
                    )
            SELECT  @n_history_seq
			       ,A.*
				   ,@v_batch_user
				   ,@v_batch_user
				   ,GETDATE()
	        FROM (
					SELECT A.*,B.creation_date,B.last_update_date 
					FROM (SELECT /* scm_dnm_intransit_h */
                                 result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id, plant_issue_date, incoterms, fcst_type, dom_exp
                               , customer_code, shipto_code, from_scm_site_id, from_site_item_mapping_yn, to_scm_site_id, to_site_item_mapping_yn
                               , delivery_qty, uom, transport_mode
                               , shipping_date, pol, pol_atd_date, pod, pod_eta_date, pod_ata_date, pod_etd_date, pod_atd_date
                               , f_dest_port_code, f_dest_eta_date, f_dest_ata_date, valid_yn
                               -- 20201007 PJ20202001  신규 컬럼 추가
                               , final_soldto_code, final_soldto_name, final_incoterms
							   , attribute4 -- 2025.04.02	 kimcd   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 매출 이력 차감에 사용될 attribute4 수량 설정

							FROM [dbo].[scm_dnm_intransit_c_temp$] WITH(NOLOCK)

						  EXCEPT
						  SELECT /* scm_dnm_intransit_c_h */
                                 result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id, plant_issue_date, incoterms, fcst_type, dom_exp
                               , customer_code, shipto_code, from_scm_site_id, from_site_item_mapping_yn, to_scm_site_id, to_site_item_mapping_yn
                               , delivery_qty, uom, transport_mode
                               , shipping_date, pol, pol_atd_date, pod, pod_eta_date, pod_ata_date, pod_etd_date, pod_atd_date
                               , f_dest_port_code, f_dest_eta_date, f_dest_ata_date, valid_yn
                               -- 20201007 PJ20202001  신규 컬럼 추가
                               , final_soldto_code, final_soldto_name, final_incoterms  
							   , attribute4 -- 2025.04.02	 kimcd   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 매출 이력 차감에 사용될 attribute4 수량 설정
							FROM [dbo].[scm_dnm_intransit_c] WITH(NOLOCK)
							WHERE valid_yn = 'N'
					) A
					
					INNER JOIN [dbo].[scm_dnm_intransit_c_temp$] B WITH(NOLOCK)
					ON	   A.result_date			=  B.result_date
					   AND A.result_type			=  B.result_type
					   AND A.company_id				=  B.company_id
					   AND A.division_id			=  B.division_id	
					   AND A.plant_id				=  B.plant_id
					   AND A.shipment_no			=  B.shipment_no
					   AND A.project_code			=  B.project_code
					   AND A.item_id				=  B.item_id
					   AND A.plant_issue_date		=  B.plant_issue_date
					   AND A.incoterms				=  B.incoterms	
					   AND A.fcst_type				=  B.fcst_type	
					   AND A.final_soldto_code		=  B.final_soldto_code	-- 20201007 PJ20202001  신규 컬럼 추가
					   AND A.final_incoterms		=  B.final_incoterms	-- 20201007 PJ20202001  신규 컬럼 추가
			) A

		-- HISTORY LOG		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'HISTORY';
        SET @v_log_message = 'INSERT INTO scm_dnm_intransit_c_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END

    -- COMMIT TRANSACTION
	  IF OBJECT_ID('dbo.scm_dnm_intransit_c_temp$') IS NOT NULL 
	     DROP TABLE scm_dnm_intransit_c_temp$

    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
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
