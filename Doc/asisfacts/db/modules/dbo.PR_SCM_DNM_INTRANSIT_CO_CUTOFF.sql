

/*
 * Program ID   : PR_SCM_DNM_INTRANSIT_CO_CUTOFF
 * Description  : 법인간 운송중 재고 정보 I/F 
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.09.18   Kim Jihye      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020.01.20   KAG            C20200110-000350 법인간 재고 산출 로직 개선 요청
 * 2020.03.04   KSG            C20200227-000175  CNA법인-고객사(HLGP) 간 운송중 재고 반영건
 * 2020.09.10   KSG            C20200910-000102 법인간 운송중 재고에 Shipment 정보 추가 요청
 * 2020.10.07   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                Cutoff 테이블에 신규 컬럼 추가 : final_soldto_code / final_soldto_name / final_incoterms
 * 2021.01.22   KSG            C20210121-000295 법인간 운송중 재고 내 ETA 정보 개선(GTS Tracking 정보 동기화)
 * 2021.01.29   KSG            C20210128-000556 [SCM PI팀] SCP시스템의 운송중 재고 정합성을 위한 GTS Tracking정보 UPdate로직 변경의 건
 * 2021.03.09   KSG            C20210308-000089 [SCM PI팀] 판매법인 법인간거래 ETA 정보 Update 로직 수정 요청 건 
                                  법인간 해상재고는 To Site가 SALES 이더라도 GTS의 ETA 사용
 * 2021.07.01   KSG            C20210629-000587 [SCM PI팀] GSCM 시스템의 운송중 반제품(노치드팬케익) 재고를 적용 시기키기 위한 기능변경 건
 * 2021.09.15   sclee.lee      PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : 해상재고 GTS 정보 고도화
 * 2022.04.01   hrkim          PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선  
 *                             GTS delivery tracking 기준 -> ERP 정보 기준으로 변경
 * 2022.07.28   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - @P_ISSUE_DATE 기준 plant_issue_date가 2년 경과시 scm_dnm_intransit_c에 생성대상서 제외
 * 2022.08.10   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 법인간 재고 DO_NO / DO_ITEM_SEQ 에 대한 차감로직 추가
 * 2022.09.01   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 법인간 재고 ZFCY2가 있을 경우, ZFCY2ETA / ZFCY2ATA 값 적용
 * 2024.07.11   KSG            E20240711-001240 법인간 운송중재고 중복집계오류 수정 요청건
 * 2024.12.15   vadabi3        NERP - 특정 Company 별도 처리 개선
 ----------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[PR_SCM_DNM_INTRANSIT_CO_CUTOFF]
(
    @p_result_date NVARCHAR(8)=NULL
)
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET NOCOUNT ON; 


  -- LOG 용 변수 설정
  DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_INTRANSIT_CO_CUTOFF';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  DECLARE @v_ifseqno      NVARCHAR(30); 
  DECLARE @n_history_seq  BIGINT;

  -- 년월일 표시형태 변수 설정
  DECLARE @v_date_format  VARCHAR(10) = 'yyyyMMdd';

  	-- NERP 매핑코드
	DECLARE @v_B100 NVARCHAR(8);
	DECLARE @v_C100 NVARCHAR(8);
	SELECT @v_B100 = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_INTRANSIT_CO_CUTOFF','COMPANY_SALES');
	SELECT @v_C100 = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_INTRANSIT_CO_CUTOFF','ESOC');
	--SELECT @v_B100, @v_C100

  -- 시작 LOG
  SET @v_log_type    = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @d_event_date  = SYSDATETIME();

  BEGIN TRY
    BEGIN
	  IF @p_result_date IS NULL OR ISDATE(@p_result_date) != 1
	    SET @p_result_date = CONVERT(CHAR(8), DATEADD(day,-1,GETDATE()), 112)
	  ELSE
	    SET @p_result_date = CONVERT(CHAR(8), DATEADD(day,-1,@p_result_date), 112)
  
      -- PJ20216994
      DECLARE @v_min_plant_issue_date VARCHAR(8) = FORMAT(DATEADD(YEAR, -2, @p_result_date), @v_date_format);
		
      -- PJ20216994
      -- @p_result_date 확인을 위해 @v_description 위치 변경
      SET @v_description = CONCAT('@p_result_date : ', @p_result_date);
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

/* 
	  DELETE 
	  FROM  scm_dnm_intransit_c 
	  WHERE result_type = 'C' 
	  AND   result_date = @p_result_date;
 */	  
 
      -- PJ20216994
      -- MS권고안에 따른 삭제로직 변경
      BEGIN TRAN
      -- 기존내역부터 지우고 시작
      WHILE(1 = 1)
      BEGIN
          DELETE TOP (1000) A
          FROM dbo.scm_dnm_intransit_c A
          WHERE A.RESULT_DATE = @p_result_date
          AND A.RESULT_TYPE = 'C'
  		  --and a.company_id not in (select segment1 
  				--		       from scm_adm_lookup_master_detail with(nolock) 
  				--		       where lookup_type = 'exfactory_intransit_target' 
  				--		       and valid_yn = 'y');

          IF(@@ROWCOUNT = 0)
          BEGIN
              BREAK;
          END
      END

      COMMIT
      ------------------------------------------------------------
      --임시테이블
      ------------------------------------------------------------
      IF OBJECT_ID('tempdb..#SCM_DNM_INT_GI_TEMP') IS NOT NULL
        BEGIN 
          DROP TABLE  #SCM_DNM_INT_GI_TEMP
        END 
	  
      IF OBJECT_ID('tempdb..#SCM_DNM_INT_GR_SHIP_TEMP') IS NOT NULL
        BEGIN 
          DROP TABLE  #SCM_DNM_INT_GR_SHIP_TEMP
        END 

      ------------------------------------------------------------
      -- 1.1 GI Temp
      ------------------------------------------------------------
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

                  -- PJ20216994 (2022.09.01)
				  --,MAX(t.f_dest_eta_date) f_dest_eta_date
				  --,MAX(t.f_dest_ata_date) f_dest_ata_date
                  ,IIF(ISNULL(ZFCY2, '') != '', MAX(t.zfcy2eta), MAX(t.f_dest_eta_date)) f_dest_eta_date
                  ,IIF(ISNULL(ZFCY2, '') != '', MAX(t.zfcy2ata), MAX(t.f_dest_ata_date)) f_dest_ata_date
				  ,RANK() OVER (PARTITION BY company_id
										    ,shipment_no
									ORDER BY incoterms DESC
									       , IIF(ISNULL(ZFCY2, '') != '', 1, 99)  -- 20240711 E20240711-001240 Order By 요건 추가
							   ) AS incoterms_priority
			  FROM scm_dnm_delivery_tracking t WITH(NOLOCK)
		  GROUP BY t.company_id
				  ,t.shipment_no
				  ,t.incoterms
                  ,ISNULL(t.zfcy2, '')
		)
      SELECT cd.division_id, cd.company_id_purch, cd.company_id_sales, cd.po_no, cd.po_item_seq, cd.origin_item_id
	       , [dbo].[FN_SCM_SYS_NVL](cd.shipment_no, '-') AS shipment_no -- NVL 처리
           , ISNULL(cd.do_no, '') do_no, ISNULL(cd.do_item_seq, '') do_item_seq
           , MAX(cd.incoterms)        AS incoterms
           , SUM(cd.qty)              AS qty
           , SUM(cd.qty)              AS org_qty
           , MAX(cd.uom)              AS uom
           , MAX(cd.transport_mode)   AS transport_mode
           , MAX(CAST(cd.plant_issue_date AS nvarchar)) AS plant_issue_date
           , MAX(cd.on_board_date)    AS on_board_date	 
		   -- 20210122 C20210121-000295 eta_date 변경
           --, MAX(cd.eta_date)         AS eta_date 
           , MAX([dbo].[FN_SCM_SYS_NVL](dt.f_dest_eta_date, cd.eta_date)) AS eta_date 
		   -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선 (f_dest_eta_date_sales 참조 변경) - 변경전 소스 주석처리
           -- , MAX([dbo].[FN_SCM_SYS_NVL](dt.f_dest_eta_date_sales, cd.eta_date)) AS eta_date_sales
		   -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선 (cd_eta_datetime, shipping_date 추가)
		   , IIF(ISNULL(MAX(cd.eta_date),'')='', NULL,	CAST(MAX(cd.eta_date) as datetime))	  AS cd_eta_datetime 	      
		   , MAX(dt.shipping_date)    AS shipping_date
          
           /* 20210915 PJ20214907 */
           , MAX(dt.pol_atd_date)     AS pol_atd_date
           , MAX(dt.pod_eta_date)     AS pod_eta_date
           , MAX(dt.pod_ata_date)     AS pod_ata_date
           , MAX(dt.pod_etd_date)     AS pod_etd_date
           , MAX(dt.pod_atd_date)     AS pod_atd_date
           , MAX([dbo].[FN_SCM_SYS_NVL](dt.f_dest_eta_date, cd.eta_date)) AS f_dest_eta_date
           , MAX(dt.f_dest_eta_date)  AS dt_f_dest_eta_date
		   , MAX(dt.f_dest_ata_date)  AS f_dest_ata_date
           , CAST('A' AS varchar(10)) AS flag
      INTO   #SCM_DNM_INT_GI_TEMP
      FROM   scm_dnm_intransit_co_detail cd WITH(NOLOCK)
	  
			-- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선
			 LEFT OUTER JOIN gts_delivery_tracking  dt 
						  ON cd.company_id_sales	= dt.company_id
					     AND cd.shipment_no			= dt.shipment_no
					     AND dt.incoterms_priority	= 1

	  WHERE  1=1 -- division_id = '81'
      AND    cd.doc_type    = 'GI'
      AND    cd.valid_yn    = 'Y'
	  
      -- PJ20216994
      AND    cd.plant_issue_date >= @v_min_plant_issue_date
      GROUP BY cd.division_id, cd.company_id_purch, cd.company_id_sales, cd.po_no, cd.po_item_seq, cd.origin_item_id
	         , [dbo].[FN_SCM_SYS_NVL](cd.shipment_no, '-')  -- NVL 처리
             , ISNULL(cd.do_no, ''), ISNULL(cd.do_item_seq, '')
      ;
	  
      ------------------------------------------------------------
	  -- 1.2 Gr Shipment Temp
      ------------------------------------------------------------
      SELECT division_id, company_id_purch
           , CASE WHEN company_id_sales = @V_B100 THEN  @V_C100
		          ELSE company_id_sales
		     END company_id_sales
           , po_no, po_item_seq, origin_item_id
	       , [dbo].[FN_SCM_SYS_NVL](shipment_no, '-') AS shipment_no -- NVL 처리           
		   , ISNULL(do_no, '') do_no, ISNULL(do_item_seq, '') do_item_seq		   
           , SUM(qty)              AS qty
           , 'N'                   AS process_flag
      INTO   #SCM_DNM_INT_GR_SHIP_TEMP
      FROM   scm_dnm_intransit_co_detail WITH(NOLOCK)
	  WHERE  1=1 -- division_id = '81'
      AND    doc_type    = 'GR'
      AND    valid_yn    = 'Y'
      GROUP BY division_id, company_id_purch, company_id_sales, po_no, po_item_seq, origin_item_id
	         , [dbo].[FN_SCM_SYS_NVL](shipment_no, '-') -- NVL 처리
             , ISNULL(do_no, ''), ISNULL(do_item_seq, '')
      ;
	  	  
      ------------------------------------------------------------
	  -- 2.1 do_no 기준 1차 처리
	  --     gi와 gr_ship이 shipment_no 까지 동일하고, GR qty <= GI Qty 인 경우
	  --     => (GR - GI) 로 gi qty Update, gr_ship의 process_flag = 'Y' 처리
      ------------------------------------------------------------ 
      DECLARE @v_division_id          NVARCHAR(150) = '';
      DECLARE @v_company_id_purch     NVARCHAR(150) = '';
      DECLARE @v_company_id_sales     NVARCHAR(150) = '';
      DECLARE @v_po_no                NVARCHAR(150) = '';
      DECLARE @v_po_item_seq          NVARCHAR(150) = '';
      DECLARE @v_origin_item_id       NVARCHAR(150) = '';
      DECLARE @v_shipment_no          NVARCHAR(150) = '';
      DECLARE @n_gi_qty               NUMERIC(20,10);
      DECLARE @n_gr_qty               NUMERIC(20,10);
      DECLARE @v_process_flag         NVARCHAR(150) = '';	  
      DECLARE @v_do_no                NVARCHAR(150) = '';
      DECLARE @v_do_item_seq          NVARCHAR(150) = '';
	  
      DECLARE GR_DO_TEMP CURSOR FOR
	    SELECT division_id, company_id_purch, company_id_sales, po_no, po_item_seq, origin_item_id, shipment_no, do_no, do_item_seq
             , qty, process_flag
	    FROM   #SCM_DNM_INT_GR_SHIP_TEMP WITH(NOLOCK)
        ORDER BY 1, 2, 3, 4, 5, 6, 7, 8, 9
		;
	  
        OPEN GR_DO_TEMP;
        FETCH NEXT FROM GR_DO_TEMP INTO @v_division_id, @v_company_id_purch, @v_company_id_sales, @v_po_no, @v_po_item_seq
		                                , @v_origin_item_id, @v_shipment_no, @v_do_no, @v_do_item_seq, @n_gr_qty, @v_process_flag                                        
		 
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
		  -- gi qty 확인
		  SELECT @n_gi_qty = qty
          FROM   #SCM_DNM_INT_GI_TEMP
          WHERE  1=1 
          AND    division_id      = @v_division_id
          AND    company_id_purch = @v_company_id_purch
          AND    company_id_sales = @v_company_id_sales
          AND    po_no            = @v_po_no
          AND    po_item_seq      = @v_po_item_seq
          AND    origin_item_id   = @v_origin_item_id
          AND    shipment_no      = @v_shipment_no
          AND    do_no            = @v_do_no
          AND    do_item_seq      = @v_do_item_seq
		  ;

          -- GI qty >= Gr Qty 인 경우 처리
		  IF @n_gi_qty >= @n_gr_qty
		  BEGIN
		    -- (GR - GI) 로 gi 정보 Update
            UPDATE #SCM_DNM_INT_GI_TEMP
            SET    qty = @n_gi_qty - @n_gr_qty
                  ,flag = CONCAT(flag, 'B')
            WHERE  1=1 
            AND    division_id      = @v_division_id
            AND    company_id_purch = @v_company_id_purch
            AND    company_id_sales = @v_company_id_sales
            AND    po_no            = @v_po_no
            AND    po_item_seq      = @v_po_item_seq
            AND    origin_item_id   = @v_origin_item_id
            AND    shipment_no      = @v_shipment_no
            AND    do_no            = @v_do_no
            AND    do_item_seq      = @v_do_item_seq
            ;
			
		    -- gr_ship의 process_flag = 'Y' 처리
            UPDATE #SCM_DNM_INT_GR_SHIP_TEMP
            SET    process_flag = 'Y'
            WHERE  1=1 
            AND    division_id      = @v_division_id
            AND    company_id_purch = @v_company_id_purch
            AND    company_id_sales = @v_company_id_sales
            AND    po_no            = @v_po_no
            AND    po_item_seq      = @v_po_item_seq
            AND    origin_item_id   = @v_origin_item_id
            AND    shipment_no      = @v_shipment_no
            AND    do_no            = @v_do_no
            AND    do_item_seq      = @v_do_item_seq
		    ;

          END -- IF @n_gi_qty >= @n_gr_qty

          FETCH NEXT FROM GR_DO_TEMP INTO @v_division_id, @v_company_id_purch, @v_company_id_sales, @v_po_no, @v_po_item_seq
		                                  , @v_origin_item_id, @v_shipment_no, @v_do_no, @v_do_item_seq, @n_gr_qty, @v_process_flag                                          
        END
		
      CLOSE GR_DO_TEMP;
      DEALLOCATE GR_DO_TEMP;
	  
      -----------------------------------------------------------
      -- Insert LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'UPDATE';
      SET @v_log_message = '1. Item : GI Update (DO_NO)';
      SET @v_description = 'result_date = ' + @p_result_date;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      -----------------------------------------------------------

      ------------------------------------------------------------
	  -- 2.2. Shipment No 기준 2차 처리
	  --      gi와 gr_ship이 shipment_no 까지 동일하고, GR qty <= GI Qty 인 경우
	  --      => (GR - GI) 로 gi qty Update, gr_ship의 process_flag = 'Y' 처리
      ------------------------------------------------------------ 
      DECLARE GR_SHIP_TEMP CURSOR FOR
	    SELECT division_id, company_id_purch, company_id_sales, po_no, po_item_seq, origin_item_id, shipment_no
             , sum(qty), process_flag
	    FROM   #SCM_DNM_INT_GR_SHIP_TEMP WITH(NOLOCK)
        WHERE  1=1 -- division_id = '81'
        AND    process_flag = 'N'
        GROUP BY division_id, company_id_purch, company_id_sales, po_no, po_item_seq, origin_item_id, shipment_no, process_flag
        ORDER BY 1, 2, 3, 4, 5, 6, 7
		;
	  
        OPEN GR_SHIP_TEMP;
        FETCH NEXT FROM GR_SHIP_TEMP INTO @v_division_id, @v_company_id_purch, @v_company_id_sales, @v_po_no, @v_po_item_seq
		                                , @v_origin_item_id, @v_shipment_no, @n_gr_qty, @v_process_flag
		 
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
		  -- gi qty 확인
		  SELECT @n_gi_qty = qty
          FROM   #SCM_DNM_INT_GI_TEMP
          WHERE  1=1 
          AND    division_id      = @v_division_id
          AND    company_id_purch = @v_company_id_purch
          AND    company_id_sales = @v_company_id_sales
          AND    po_no            = @v_po_no
          AND    po_item_seq      = @v_po_item_seq
          AND    origin_item_id   = @v_origin_item_id
          AND    shipment_no      = @v_shipment_no
		  ;

          -- GI qty >= Gr Qty 인 경우 처리
		  IF @n_gi_qty >= @n_gr_qty
		  BEGIN
		    -- (GR - GI) 로 gi 정보 Update
            UPDATE #SCM_DNM_INT_GI_TEMP
            SET    qty = @n_gi_qty - @n_gr_qty
                  ,flag = CONCAT(flag, 'C')
            WHERE  1=1 
            AND    division_id      = @v_division_id
            AND    company_id_purch = @v_company_id_purch
            AND    company_id_sales = @v_company_id_sales
            AND    po_no            = @v_po_no
            AND    po_item_seq      = @v_po_item_seq
            AND    origin_item_id   = @v_origin_item_id
            AND    shipment_no      = @v_shipment_no
            ;
			
		    -- gr_ship의 process_flag = 'Y' 처리
            UPDATE #SCM_DNM_INT_GR_SHIP_TEMP
            SET    process_flag = 'Y'
            WHERE  1=1 
            AND    division_id      = @v_division_id
            AND    company_id_purch = @v_company_id_purch
            AND    company_id_sales = @v_company_id_sales
            AND    po_no            = @v_po_no
            AND    po_item_seq      = @v_po_item_seq
            AND    origin_item_id   = @v_origin_item_id
            AND    shipment_no      = @v_shipment_no
		    ;

          END -- IF @n_gi_qty >= @n_gr_qty

          FETCH NEXT FROM GR_SHIP_TEMP INTO @v_division_id, @v_company_id_purch, @v_company_id_sales, @v_po_no, @v_po_item_seq
		                                  , @v_origin_item_id, @v_shipment_no, @n_gr_qty, @v_process_flag
        END
		
      CLOSE GR_SHIP_TEMP;
      DEALLOCATE GR_SHIP_TEMP;
	  
      -----------------------------------------------------------
      -- Insert LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'UPDATE';
      SET @v_log_message = '2. Shipment : GI Update';
      SET @v_description = 'result_date = ' + @p_result_date;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      -----------------------------------------------------------

      ------------------------------------------------------------
	  -- 2.3. Gr Item 기준 차감 처리
	  --      gr의 process_flag = 'N' 인 정보 중에서 gi와 gr_item이 origin_item_id 까지 동일한 정보를 Plant Issute Date/Shipment_no 기준으로 Sort
	  --      순서대로 (GI - GR)를 gi의 qty에 update : 0 이상인 경우만
      ------------------------------------------------------------ 
      DECLARE @v_gi_division_id          NVARCHAR(150) = '';
      DECLARE @v_gi_company_id_purch     NVARCHAR(150) = '';
      DECLARE @v_gi_company_id_sales     NVARCHAR(150) = '';
      DECLARE @v_gi_po_no                NVARCHAR(150) = '';
      DECLARE @v_gi_po_item_seq          NVARCHAR(150) = '';
      DECLARE @v_gi_do_no                NVARCHAR(150) = '';
      DECLARE @v_gi_do_item_seq          NVARCHAR(150) = '';
      DECLARE @v_gi_origin_item_id       NVARCHAR(150) = '';
      DECLARE @v_gi_shipment_no          NVARCHAR(150) = '';
      DECLARE @n_remain_qty              NUMERIC(20,10);

      DECLARE GR_ITEM_TEMP CURSOR FOR
        SELECT division_id, company_id_purch, company_id_sales, po_no, po_item_seq, origin_item_id
             , SUM(qty) AS qty
        FROM   #SCM_DNM_INT_GR_SHIP_TEMP WITH(NOLOCK)
        WHERE  1=1 -- division_id = '81'
        AND    process_flag = 'N'
        GROUP BY division_id, company_id_purch, company_id_sales, po_no, po_item_seq, origin_item_id
        ORDER BY 1, 2, 3, 4, 5, 6
		;
	  
        OPEN GR_ITEM_TEMP;
        FETCH NEXT FROM GR_ITEM_TEMP INTO @v_division_id, @v_company_id_purch, @v_company_id_sales, @v_po_no, @v_po_item_seq
		                                , @v_origin_item_id, @n_gr_qty
		 
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
		
		  ---------------------
          -- Gi Cursor : Start
		  ---------------------
		  SET @n_remain_qty = @n_gr_qty;

          DECLARE GI_TEMP CURSOR FOR
		    SELECT division_id, company_id_purch, company_id_sales, po_no, po_item_seq, do_no, do_item_seq, origin_item_id, shipment_no, qty
            FROM   #SCM_DNM_INT_GI_TEMP
            WHERE  1=1 
            AND    division_id      = @v_division_id
            AND    company_id_purch = @v_company_id_purch
            AND    company_id_sales = @v_company_id_sales
            AND    po_no            = @v_po_no
            AND    po_item_seq      = @v_po_item_seq
            AND    origin_item_id   = @v_origin_item_id
            AND    qty              > 0 -- gi qty가 존재하는 경우
            ORDER BY 1, 2, 3, 4, 5, 6, 7
		    ;
	  
            OPEN GI_TEMP;
            FETCH NEXT FROM GI_TEMP INTO @v_gi_division_id, @v_gi_company_id_purch, @v_gi_company_id_sales, @v_gi_po_no, @v_gi_po_item_seq, @v_gi_do_no, @v_gi_do_item_seq
		                               , @v_gi_origin_item_id, @v_gi_shipment_no, @n_gi_qty
		 
            WHILE (@@FETCH_STATUS = 0)
            BEGIN
			  
			  -- 남은 GR Qty가 GI 보다 많은 경우
			  IF @n_remain_qty > @n_gi_qty
			  BEGIN			  
		        -- 0으로 gi 정보 Update
                UPDATE #SCM_DNM_INT_GI_TEMP
                SET    qty = 0
                WHERE  1=1 
                AND    division_id      = @v_gi_division_id
                AND    company_id_purch = @v_gi_company_id_purch
                AND    company_id_sales = @v_gi_company_id_sales
                AND    po_no            = @v_gi_po_no
                AND    po_item_seq      = @v_gi_po_item_seq
                AND    do_no            = @v_gi_do_no
                AND    do_item_seq      = @v_gi_do_item_seq
                AND    origin_item_id   = @v_gi_origin_item_id
                AND    shipment_no      = @v_gi_shipment_no
                ;

				-- 추가 처리를 위하여 남은 gr qty 설정
			    SET @n_remain_qty = @n_remain_qty - @n_gi_qty;
			  END -- IF @n_remain_qty >= @n_gi_qty		  			  
			  
			  ELSE -- 남은 GR Qty가 GI 보다 작거나 같은 경우
			  BEGIN
		        -- (GI - 남은 GR) 로 gi 정보 Update
                UPDATE #SCM_DNM_INT_GI_TEMP
                SET    qty = @n_gi_qty - @n_remain_qty
                      ,flag = CONCAT(flag, 'D')
                WHERE  1=1 
                AND    division_id      = @v_gi_division_id
                AND    company_id_purch = @v_gi_company_id_purch
                AND    company_id_sales = @v_gi_company_id_sales
                AND    po_no            = @v_gi_po_no
                AND    po_item_seq      = @v_gi_po_item_seq
                AND    do_no            = @v_gi_do_no
                AND    do_item_seq      = @v_gi_do_item_seq
                AND    origin_item_id   = @v_gi_origin_item_id
                AND    shipment_no      = @v_gi_shipment_no
                ;

			    SET @n_remain_qty = 0;		  
                BREAK; -- 남은 수량이 없으므로 GI_TEMP 탈출 후 다음 GR_ITEM_TEMP Fetch

			  END -- ELSE

              FETCH NEXT FROM GI_TEMP INTO @v_gi_division_id, @v_gi_company_id_purch, @v_gi_company_id_sales, @v_gi_po_no, @v_gi_po_item_seq, @v_gi_do_no, @v_gi_do_item_seq
		                                 , @v_gi_origin_item_id, @v_gi_shipment_no, @n_gi_qty
            END
		
          CLOSE GI_TEMP;
          DEALLOCATE GI_TEMP; 	 
		  ---------------------
          -- Gi Cursor : End
		  ---------------------

          FETCH NEXT FROM GR_ITEM_TEMP INTO @v_division_id, @v_company_id_purch, @v_company_id_sales, @v_po_no, @v_po_item_seq
		                                  , @v_origin_item_id, @n_gr_qty
        END
		
      CLOSE GR_ITEM_TEMP;
      DEALLOCATE GR_ITEM_TEMP; 	  	  
	  
      -----------------------------------------------------------
      -- Insert LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'UPDATE';
      SET @v_log_message = '3. Item : GI Update (PO_NO)';
      SET @v_description = 'result_date = ' + @p_result_date;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      -----------------------------------------------------------

      ------------------------------------------------------------
	  -- 4 최종 Qty Cutoff 생성
      ------------------------------------------------------------
      ;WITH sub AS
      (
       SELECT @p_result_date      AS result_date
             ,'C'                 AS result_type
             ,cd.company_id_sales AS company_id
             ,cd.division_id
             ,ISNULL(cs.plant_id_sales, '*')   AS plant_id
             -- 20200910 C20200910-000102 법인간 운송중 재고에 Shipment 정보 추가 요청 : ROW_NUMBER 에서 (shipment_no + ROW_NUMBER)로 변경 
             --,[dbo].[FN_ZERO_LPAD](ROW_NUMBER() OVER (PARTITION BY cs.item_id ORDER BY ISNULL(cd.shipment_no, '-') + '_'+ cs.po_no), 10) AS shipment_no
		 	 ,ISNULL(cd.shipment_no, '-') + '_' + CONVERT(VARCHAR, ROW_NUMBER() OVER (PARTITION BY ISNULL(cd.shipment_no, '-'), cs.item_id ORDER BY cs.plant_id_sales)) AS shipment_no -- shipment_no 적용
             ,cd.po_item_seq                   AS project_code
             ,cs.item_id
             ,cs.incoterms  -- C20200227-000175 Summary의 Incoterms 사용
             --,cd.incoterms  -- C20200227-000175
             ,'-' dom_exp
	   
		 	-- C20200227-000175 처리 정보 변경
             ,CASE WHEN (cs.attribute1 IS NULL OR cs.attribute1 = '') THEN cd.company_id_purch
                   ELSE cs.attribute1
              END AS customer_code
             ,CASE WHEN ISNULL(cs.attribute3, '') = '' THEN cd.company_id_purch
                   ELSE cs.attribute3
              END AS shipto_code
	   
             --,cd.company_id_purch AS customer_code
             --,cd.company_id_purch AS shipto_code
	   
             ,cs.from_scm_site_id
             ,cs.to_scm_site_id
             ,cd.qty              AS delivery_qty
             ,cd.uom
             ,cd.transport_mode			 
             ,cd.plant_issue_date cd_plant_issue_date
             ,cs.exfactory_date			 
	   
             /* 20210915 PJ20214907 */
             /* plant_issue_date */
             /*
             1순위 : cd.plant_issue_date
             2순위 : cs.exfactory_date
             */
             ,ISNULL(IIF(ISNULL(cd.plant_issue_date, '') = '', NULL, cd.plant_issue_date)
                   , IIF(ISNULL(cs.exfactory_date, '') = '', NULL, cs.exfactory_date)) AS plant_issue_date

             ,'-'              AS fcst_type
		 	
             ,IIF(ISNULL(cd.on_board_date, '') = '', NULL, cd.on_board_date) shipping_date

		 	-- 20210129  C20210128-000556 f_dest_eta_date 로 사용할 컬럼 변경  eta_date_sales
		 	-- 20210309  C20210308-000089 법인간 해상재고는 To Site가 SALES 이더라도 GTS의 ETA 사용
		 	--           IN/EE FN Set Intransit 에도 동일 로직 존재함
             --,cd.eta_date      AS f_dest_eta_date

             ,'Y'              AS valid_yn
             ,@v_batch_user created_by
             ,GETDATE() creation_date
             ,@v_batch_user last_updated_by
             ,GETDATE() last_update_date
             -- 20201007 PJ20202001  신규 컬럼 추가
             ,CASE WHEN ISNULL(cs.final_soldto_code, '') <> ''  THEN cs.final_soldto_code
                   WHEN (cs.attribute1 IS NULL OR cs.attribute1 = '') THEN cd.company_id_purch
                   ELSE cs.attribute1
              END AS final_soldto_code
	   
             ,CASE WHEN ISNULL(cs.final_soldto_name, '') <> ''  THEN cs.final_soldto_name
                   ELSE '-'
              END AS final_soldto_name
	   
             ,[dbo].[FN_SCM_SYS_NVL](cs.final_incoterms, cs.incoterms) AS final_incoterms
		 	
             /* 20210915 PJ20214907 */
             /* pol_atd_date */
             /*
			 pol_atd_date 가 없으면
             1순위 : cd.on_board_date
             2순위 : plant_issue_date + ship_lt_total (밑에서 계산함)
             */
             ,ISNULL(IIF(ISNULL(cd.pol_atd_date, '') = '', NULL, cd.pol_atd_date)
			       , IIF(ISNULL(cd.on_board_date, '') = '', NULL, cd.on_board_date)) pol_atd_date
		 	
             ,cd.pod_eta_date
		 	 ,cd.pod_ata_date
		 	 ,cd.pod_etd_date			 
		 	 ,cd.pod_atd_date

             /* 20210915 PJ20214907 */
             /* attribute3 / f_dest_eta_date */
             /*
             cd.pod_atd_date 없으면 cd.pod_etd_date
             cd.pod_etd_date 없으면 cd.pod_ata_date
             cd.pod_ata_date 없으면 cd.pod_eta_date
             cd.pod_eta_date 없으면 cd.pol_atd_date
             cd.pol_atd_date 없으면 cd.on_board_date
             cd.on_board_date 없으면 cd.plant_issue_date
             cd.plant_issue_date 없으면 cs.exfactory_date
             */ 
             
             -- ,CASE WHEN ISNULL(s.site_type, 'SALES') = 'SALES' THEN cd.eta_date_sales
                  -- ELSE cd.eta_date
             -- END  f_dest_eta_date  
			 ,cd.dt_f_dest_eta_date dt_f_dest_eta_date
			 /*
              -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선 (기존소스 주석 처리)
			 ,IIF(ISNULL(s.site_type, 'SALES') = 'SALES', IIF(ISNULL(cd.eta_date_sales, '') = '', NULL, CAST(cd.eta_date_sales AS datetime)), IIF(ISNULL(cd.eta_date, '') = '', NULL, CAST(cd.eta_date AS datetime))) f_dest_eta_date
			 */		
 			  -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선
			 ,CASE WHEN ISNULL(s.site_type, 'SALES') = 'SALES'
				   THEN 
							CASE WHEN ic.segment3 = 'A' THEN cd.cd_eta_datetime
							     WHEN ic.segment3 = 'B' THEN IIF(ISNULL(cd.shipping_date, '')='', cd.cd_eta_datetime, CAST(cd.shipping_date AS datetime))
								 WHEN ic.segment3 = 'C' THEN CASE WHEN ISNULL(cd.pol_atd_date, '') = '' 
																  THEN IIF(ISNULL(cd.shipping_date, '')='', cd.cd_eta_datetime, CAST(cd.shipping_date AS datetime))   
																  ELSE IIF(ISNULL(cd.pol_atd_date, '')='' , cd.cd_eta_datetime, CAST(cd.pol_atd_date  AS datetime))        
																  END
								 -- 그외 D,E,F or ic.segment3 is null or ic.segment3 = ''
								 ELSE						 CASE WHEN ISNULL(cd.f_dest_ata_date, '') ='' 
																  THEN IIF(ISNULL(cd.dt_f_dest_eta_date, '')='' , cd.cd_eta_datetime, CAST(cd.dt_f_dest_eta_date  AS datetime))   
																  ELSE IIF(ISNULL(cd.f_dest_ata_date, '')=''    , cd.cd_eta_datetime, CAST(cd.f_dest_ata_date  AS datetime))   
															  END 
						    END 
				   ELSE 
							IIF(ISNULL(cd.eta_date, '') = '', NULL, CAST(cd.eta_date AS datetime)) 
			  END  AS  f_dest_eta_date


            ,ISNULL(IIF(ISNULL(cd.pod_atd_date, '') = '', NULL, CAST(cd.pod_atd_date AS datetime))
                   , IIF(ISNULL(cd.pod_etd_date, '') = '', NULL, CAST(cd.pod_etd_date AS datetime))) pod_atd_etd_attribute3
             ,ISNULL(IIF(ISNULL(cd.pod_atd_date, '') = '', NULL, CAST(cd.pod_atd_date AS datetime))
                   , IIF(ISNULL(cd.pod_etd_date, '') = '', NULL, CAST(cd.pod_etd_date AS datetime))) pod_atd_etd_f_dest_eta_date
	   
             ,ISNULL(IIF(ISNULL(cd.pod_ata_date, '') = '', NULL, CAST(cd.pod_ata_date AS datetime))
                   , IIF(ISNULL(cd.pod_eta_date, '') = '', NULL, CAST(cd.pod_eta_date AS datetime))) pod_ata_eta_attribute3
             ,ISNULL(IIF(ISNULL(cd.pod_ata_date, '') = '', NULL, CAST(cd.pod_ata_date AS datetime))
                   , IIF(ISNULL(cd.pod_eta_date, '') = '', NULL, CAST(cd.pod_eta_date AS datetime))) pod_ata_eta_f_dest_eta_date
	   
             ,ISNULL(IIF(ISNULL(cd.pol_atd_date, '') = '', NULL, CAST(cd.pol_atd_date AS datetime))
                   , IIF(ISNULL(cd.on_board_date, '') = '', NULL, CAST(cd.on_board_date AS datetime))) pol_atd_attribute3
             ,ISNULL(IIF(ISNULL(cd.plant_issue_date, '') = '', NULL, CAST(cd.plant_issue_date AS datetime))
                   , IIF(ISNULL(cs.exfactory_date, '') = '', NULL, CAST(cs.exfactory_date AS datetime))) plant_issue_attribute3
             ,ISNULL(IIF(ISNULL(cd.pol_atd_date, '') = '', NULL, CAST(cd.pol_atd_date AS datetime))
                   , IIF(ISNULL(cd.on_board_date, '') = '', NULL, CAST(cd.on_board_date AS datetime))) pol_atd_f_dest_eta_date
             ,ISNULL(IIF(ISNULL(cd.plant_issue_date, '') = '', NULL, CAST(cd.plant_issue_date AS datetime))
                   , IIF(ISNULL(cs.exfactory_date, '') = '', NULL, CAST(cs.exfactory_date AS datetime))) plant_issue_f_dest_eta_date
             ,IIF(ISNULL(s.site_type, '') = '', 'SALES', s.site_type)  to_site_type
		 	 ,cd.f_dest_ata_date
,cd.flag
       FROM  scm_dnm_intransit_co_summary cs WITH(NOLOCK)
		 		
		     -- 20210129  C20210128-000556
		     LEFT OUTER JOIN scm_mst_site s WITH(NOLOCK)
					ON  cs.division_id    = s.division_id
					AND cs.to_scm_site_id = s.scm_site_id
	   
			 INNER JOIN #SCM_DNM_INT_GI_TEMP cd	   
					 ON  cs.division_id      = cd.division_id
					AND cs.company_id_purch = cd.company_id_purch
					AND cs.company_id_sales = cd.company_id_sales
					AND cs.po_no            = cd.po_no
					AND cs.po_item_seq      = cd.po_item_seq
					AND cs.origin_item_id   = cd.origin_item_id

			 -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 운송중 재고 Incoterms 로직 개선  
			 LEFT OUTER JOIN scm_adm_lookup_master_detail ic with(nolock) 
					 ON ic.lookup_type = 'INCOTERMS'
				    AND ic.valid_yn    = 'Y'
					AND ic.segment1    = [dbo].[FN_SCM_SYS_NVL](cs.final_incoterms, cs.incoterms)
	   
       WHERE  1=1 -- cs.division_id      = '81'
       AND    cs.intransit_qty    > 0
       AND    cd.qty              > 0
       AND    cs.valid_yn         = 'Y'
       -- PJ20216994
       AND    cd.plant_issue_date >= @v_min_plant_issue_date
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
			 -- 데이터 중복문제 관련 해당 컬럼 제외
             --,A.from_yyyymmdd
             --,A.to_yyyymmdd
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
	   -- 데이터 중복문제 관련 해당 조건 제외
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
			 pol_atd_date 가 없으면
             1순위 : cd.on_board_date
             2순위 : plant_issue_date + ship_lt_total
             */
             ,ISNULL(IIF(ISNULL(pol_atd_date, '') = '', NULL, pol_atd_date)
                   , FORMAT(DATEADD(dd, ISNULL(ship_lt_total, 0), CAST(plant_issue_date AS datetime)), @v_date_format)) pol_atd_date1				   			 
				
             ,CASE WHEN ISNULL(dt_f_dest_eta_date, '') <> '' THEN FORMAT(CAST(dt_f_dest_eta_date AS datetime), @v_date_format)
                   WHEN segment3 IN ('D', 'E', 'F') THEN-- POD >> POL 순
                        IIF(ISNULL(pod_atd_etd_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_atd_etd_attribute3), @v_date_format))
                   ELSE NULL -- POD 제외 : 아래서 POL로 처리
			  END attribute3_0		   			 
				
             ,CASE WHEN ISNULL(f_dest_eta_date, '') <> '' THEN FORMAT(CAST(f_dest_eta_date AS datetime), @v_date_format)
                   WHEN segment3 IN ('D', 'E', 'F') THEN-- POD >> POL 순
                        IIF(ISNULL(pod_atd_etd_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_atd_etd_f_dest_eta_date), @v_date_format))
                   ELSE NULL -- POD 제외 : 아래서 POL로 처리
			  END f_dest_eta_date_0

             --,ISNULL(IIF(ISNULL(dt_f_dest_eta_date, '') = '', NULL, FORMAT(CAST(dt_f_dest_eta_date AS datetime), @v_date_format))
             --      , IIF(ISNULL(pod_atd_etd_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_atd_etd_attribute3), @v_date_format))) attribute3_0
	   
             --,ISNULL(IIF(ISNULL(f_dest_eta_date, '') = '', NULL, FORMAT(f_dest_eta_date, @v_date_format))
             --      , IIF(ISNULL(pod_atd_etd_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_atd_etd_f_dest_eta_date), @v_date_format))) f_dest_eta_date_0

       FROM sub4
      ),
      sub6 AS
      (
       SELECT *		
             ,CASE WHEN ISNULL(attribute3_0, '') <> '' THEN attribute3_0
                   WHEN segment3 IN ('D', 'E', 'F') THEN-- POD >> POL 순
                        IIF(ISNULL(pod_ata_eta_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_ata_eta_attribute3), @v_date_format))
                   ELSE NULL -- POD 제외 : 아래서 POL로 처리
			  END attribute3_1		   			 
				
             ,CASE WHEN ISNULL(f_dest_eta_date_0, '') <> '' THEN f_dest_eta_date_0
                   WHEN segment3 IN ('D', 'E', 'F') THEN-- POD >> POL 순
                        IIF(ISNULL(pod_ata_eta_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_ata_eta_f_dest_eta_date), @v_date_format))
                   ELSE NULL -- POD 제외 : 아래서 POL로 처리
			  END f_dest_eta_date_1
			  
             --,ISNULL(IIF(ISNULL(attribute3_0, '') = '', NULL, attribute3_0)
             --      , IIF(ISNULL(pod_ata_eta_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3, pod_ata_eta_attribute3), @v_date_format))) attribute3_1
	   
             --,ISNULL(IIF(ISNULL(f_dest_eta_date_0, '') = '', NULL, f_dest_eta_date_0)
             --      , IIF(ISNULL(pod_ata_eta_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date, pod_ata_eta_f_dest_eta_date), @v_date_format))) f_dest_eta_date_1
       FROM sub5
      ),
      sub7 AS
      (
       SELECT *				   
             ,ISNULL(IIF(ISNULL(attribute3_1, '') = '', NULL, attribute3_1)
                   , IIF(ISNULL(pol_atd_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3_1, pol_atd_attribute3), @v_date_format))) attribute3_2
             ,ISNULL(IIF(ISNULL(f_dest_eta_date_1, '') = '', NULL, f_dest_eta_date_1)
                   , IIF(ISNULL(pol_atd_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date1, pol_atd_f_dest_eta_date), @v_date_format))) f_dest_eta_date_2
       FROM sub6
      ),
      sub8 AS
      (
       SELECT *				   
             ,ISNULL(IIF(ISNULL(attribute3_2, '') = '', NULL, attribute3_2)
                   , IIF(ISNULL(plant_issue_attribute3, '') = '', NULL, FORMAT(DATEADD(dd, lt_attribute3_2, plant_issue_attribute3), @v_date_format))) attribute3_3
             ,ISNULL(IIF(ISNULL(f_dest_eta_date_2, '') = '', NULL, f_dest_eta_date_2)
                   , IIF(ISNULL(plant_issue_f_dest_eta_date, '') = '', NULL, FORMAT(DATEADD(dd, lt_f_dest_eta_date2, plant_issue_f_dest_eta_date), @v_date_format))) f_dest_eta_date_3
       FROM sub7
      )
	  INSERT INTO scm_dnm_intransit_c with (tablock)
		    ( result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id
            , incoterms, dom_exp, customer_code, shipto_code, from_scm_site_id, to_scm_site_id, delivery_qty, uom
            , transport_mode, plant_issue_date, fcst_type, shipping_date, f_dest_eta_date
			, attribute3
			, valid_yn
            , created_by, creation_date, last_updated_by, last_update_date
            -- 20201007 PJ20202001  신규 컬럼 추가
            , final_soldto_code, final_soldto_name, final_incoterms
			/* 20210915 PJ20214907 신규 컬럼 추가 */
            , pol_atd_date, pod_eta_date, pod_ata_date, pod_atd_date, f_dest_ata_date, pod_etd_date
			, attribute10
	  )
      SELECT result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id
            , incoterms, dom_exp, customer_code, shipto_code, from_scm_site_id, to_scm_site_id, delivery_qty, uom
            , transport_mode, plant_issue_date, fcst_type, shipping_date, f_dest_eta_date_3
			, attribute3_3
			, valid_yn
            , created_by, creation_date, last_updated_by, last_update_date
            -- 20201007 PJ20202001  신규 컬럼 추가
            , final_soldto_code, final_soldto_name, final_incoterms
			/* 20210915 PJ20214907 신규 컬럼 추가 */
            , pol_atd_date1, pod_eta_date, pod_ata_date, pod_atd_date, f_dest_ata_date, pod_etd_date
            , flag
      FROM sub8

      -- Start 2020.01.20 C20200110-000350 법인간 재고 산출 로직 개선 요청 : 삭제된 로직
	  -- GI 중에서 GR 있는 경우는 GR Qty 만큼 제외
	  
      -----------------------------------------------------------
      -- Insert LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'APPEND';
      SET @v_log_message = 'INSERT INTO scm_dnm_intransit_c';
      SET @v_description = 'result_date = ' + @p_result_date;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      -----------------------------------------------------------

      ------------------------------------------------------------
	  -- 5 Noched Pancake 정보 전극으로 전환 : 20210701 C20210629-000587 
      ------------------------------------------------------------  
	  INSERT INTO scm_dnm_intransit_c with (tablock)
		    ( result_date, result_type, company_id, division_id, plant_id, shipment_no, project_code, item_id
            , incoterms, dom_exp, customer_code, shipto_code, from_scm_site_id, to_scm_site_id, delivery_qty, uom
            , transport_mode, plant_issue_date, fcst_type, shipping_date, f_dest_eta_date
			, attribute3
			, valid_yn
            , created_by, creation_date, last_updated_by, last_update_date
            -- 20201007 PJ20202001  신규 컬럼 추가
            , final_soldto_code, final_soldto_name, final_incoterms
			/* 20210915 PJ20214907 신규 컬럼 추가 */
            , pol_atd_date, pod_eta_date, pod_ata_date, pod_atd_date, f_dest_ata_date, pod_etd_date
			, attribute10
	  )
	  SELECT di.result_date, di.result_type, di.company_id, di.division_id, di.plant_id, di.shipment_no, di.project_code
           , bom.child_item_id  AS item_id
           , di.incoterms, di.dom_exp, di.customer_code, di.shipto_code
           , fr_elec_site.scm_site_id AS from_scm_site_id
           , to_cell_site.scm_site_id AS to_scm_site_id
           ,(di.delivery_qty * ISNULL(bom.child_qty, 1) ) AS delivery_qty
           , di.uom  -- UOM 무시
           , di.transport_mode, di.plant_issue_date, di.fcst_type, di.shipping_date, di.f_dest_eta_date
		   , di.attribute3
		   , di.valid_yn
           , di.created_by, di.creation_date, 'NLF Elec Transfer' AS last_updated_by, di.last_update_date
           -- 20201007 PJ20202001  신규 컬럼 추가
           , di.final_soldto_code, di.final_soldto_name, di.final_incoterms
			/* 20210915 PJ20214907 신규 컬럼 추가 */
		   , di.pol_atd_date, di.pod_eta_date, di.pod_ata_date, di.pod_atd_date, di.f_dest_ata_date, di.pod_etd_date
, di.attribute10
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
      ON  fr_site.division_id = CASE WHEN fr_site.company_id = @V_C100 THEN fr_elec_site.division_id ELSE fr_site.division_id END
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

      WHERE di.result_type = 'C' 
      AND   di.result_date = @p_result_date
      AND   bom.child_item_id IS NOT NULL;
	  
      -----------------------------------------------------------
      -- Insert LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'APPEND';
      SET @v_log_message = 'NLF -> Elec Transfer';
      SET @v_description = 'result_date = ' + @p_result_date;
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

      WHERE di.result_type = 'C' 
      AND   di.result_date = @p_result_date
      AND   di.to_scm_site_id IS NOT NULL;
	  
      -----------------------------------------------------------
      -- Insert LOG
      -----------------------------------------------------------
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_type = 'UPDATE';
      SET @v_log_message = 'NLF Scm Site Id Update';
      SET @v_description = 'result_date = ' + @p_result_date;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      -----------------------------------------------------------
	 
      IF @@TRANCOUNT > 0
        BEGIN
          COMMIT WORK;
        END;
	  
      ------------------------------------------------------------
      --임시테이블 삭제
      ------------------------------------------------------------
      IF OBJECT_ID('tempdb..#SCM_DNM_INT_GI_TEMP') IS NOT NULL
        BEGIN 
          DROP TABLE  #SCM_DNM_INT_GI_TEMP
        END 
	  
      IF OBJECT_ID('tempdb..#SCM_DNM_INT_GR_SHIP_TEMP') IS NOT NULL
        BEGIN 
          DROP TABLE  #SCM_DNM_INT_GR_SHIP_TEMP
        END

    END

  END TRY

  BEGIN CATCH
    IF @@TRANCOUNT > 0
      BEGIN
        ROLLBACK;
      END;
    -- ERROR LOG
    SET @v_log_type    = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END CATCH;

  -- 종료 LOG
  SET @v_log_type    = 'END';
  SET @v_log_message = '########## END of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
