
CREATE PROCEDURE [dbo].[PR_SCM_DNM_INTRANSIT]
AS
/*
 * Program ID   : PR_SCM_DNM_INTRANSIT
 * Description  :In Transit 실적 정보 I/F 
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.18   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.10   Kim Jaejung    전극의 경우 전극 Plant 가 아닌(A041) A040 창고에서 출하가 되고 있음. 해당 케이스 일때 From_scm_site_id 매핑 기능추가
 *                             외주 Packer from_site_id Mapping 로직 추가
 * 2018.04.11   Kim Jihye      법인간 이동 to_scm_site_id Mapping 로직 추가
 * 2018.04.18   Kim Jaejung    project_code가 'N' 인 데이터 추가적으로 mapping 후 업데이트 DM 요청
 * 2018.04.26   Kim Jaejung    project_code update 로직 위치 수정 
 * 2018.05.04   Kim Jaejung    project_code가 'N' 인 데이터 추가적으로 sale_site mapping 후 업데이트
 * 2018.05.14   Kim Jihye      soldto-shipto : sales_site_id 1:다 케이스 발생 대응 로직 수정 
 * 2018.05.15   Kim Jaejung    Fcst_type mapping 로직 변경
 * 2018.06.01   Kim Jihye      주석 정리
 * 2018.06.11   Kim Jaejung    Transport_mode function 변경
 * 2018.06.21	Kim Jaejung    From, To scm_site_id 관련 로직 수정(customer code 변경 시 대응)
 * 2018.06.25   Kim Jaejung    to_site 가 vmi 인 경우 incoterms 는 DAP 로 변경(소형) 현재는 주석. 추후 일괄 적용
 * 2018.06.26   Kim Jihye      fcst_type mapping 로직 수정
 * 2018.06.26   Kim Jaejung    origin_incoterms 컬럼 추가. 변경 전 incoterms 저장용  (vmi) 추후 주석제거
 * 2018.07.02   Kim Jaejung	   소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 * 2018.07.20	Kim Jaejung    소형 대표 ITEM_ID 변경 시 update 로직 적용 (소형)
 * 2018.09.17   Kim Jihye      Packer Site Mapping 로직 추가
 * 2018.11.12   KSG            To Site ID : PO 사용하는 조건에 Shipto Code 네자리 추가
 * 2020.05.19   KSG            C20200519-000150 VMI-in Request CIP조건 입력 시 출하 계획이 D조건으로 생성되는 시스템 수정 요청드립니다 : ESS인 경우 VMI 라도 'DAP' 처리 안 함
 * 2020.10.07   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                신규 컬럼 추가 : final_soldto_code / final_soldto_name / final_incoterms
 *                                Site Mapping 수정
 * 2020.10.28   KSG            ESS인 VMI : 'DAP' 처리
 * 2021.06.11   KSG            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
 * 2022.01.21   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : SSP 정보를 사용한 Site Mapping
 * 2022.04.25   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division 추가
 * 2022.09.21   KSG            C20220920-000279 [SCM PI팀] Intransit 재고 to_site mapping 로직 개선 : Intansit재고의 To Site Mapping처리 시 '법인간 이동' 부분 로직 개선
 *                                -> sold to code 처리 시 'B100'인 경우 'C100' 으로 변경하여 To Site Mapping 될 수 있도록 처리
 * 2023.01.20   sclee.lee      3국간 Direct GTS Tracking 오류 대응
 * 2023/03/23	hrkim		   [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 * 2024/03/26	vadabi5		   NERP)  특정 Soldto(Company) 별도 처리, NERP/해외 ERP 전송 정보 변환
                               -- 1, B100 -> C100
							   -- 2, G260(=DE0000400)
 * 2024/05/27	vadabi5	       NERP) QA, 개발 DB 적용
 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 EXEC NERP_PR_SCM_DNM_INTRANSIT
 EXEC      PR_SCM_DNM_INTRANSIT


 */
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- LOG 용 변수 설정
  DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_INTRANSIT';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  DECLARE @v_ifseqno      NVARCHAR(30); 
  DECLARE @n_history_seq  BIGINT;

  DECLARE @np_company_value  nvarchar(30)	-- 'B100'
  DECLARE @np_company_change nvarchar(30)	-- 'C100'
  DECLARE @np_shipto_value   nvarchar(30)	-- 'G260'
  SELECT @np_company_value = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_INTRANSIT','COMPANY_SALES')		--HQ00
  SELECT @np_company_change = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_INTRANSIT','ESOC')				--HQ00
  SELECT @np_shipto_value = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_INTRANSIT','FINAL_SOLDTO_CODE')     --DE00000400
  -- SELECT @np_company_value, @np_company_change, @np_shipto_value

  -- 시작 LOG
  SET @v_log_type    = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();

  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  BEGIN TRY
  --BEGIN TRANSACTION
    BEGIN
    
      -- 인터페이스 테이블 처리 ROW UPDATE
      UPDATE xif_erp_intransit_r_sn 
      SET    transfer_flag             = 'P'
      WHERE  ISNULL(transfer_flag,'N') = 'N';  

      -------------------------------------------------------------------------
	  -- 20220425 PJ20216891 : GM JV 가상 Division 추가
	  -- 처리대상 Temp Table 생성
	  -------------------------------------------------------------------------
      IF OBJECT_ID('dbo.xif_erp_intransit_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_intransit_r_sn_temp$

      SELECT * 
      INTO   xif_erp_intransit_r_sn_temp$
      FROM   xif_erp_intransit_r_sn WITH(NOLOCK)
	  WHERE  transfer_flag = 'P'
	 
	  -- GM JV : division Size 변경
      ALTER TABLE xif_erp_intransit_r_sn_temp$ ALTER COLUMN division_id NVARCHAR(10) NULL;

	  -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - HM JV 가상 사업부 추가 반영
	  ;WITH JV_PLANT AS (
	    SELECT JP.SEGMENT1		AS DIVISION_ID
			  ,JP.SEGMENT3		AS COMPANY_ID
			  ,MAX(JP.SEGMENT4)	AS DIVISION_ID_JV
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL JP WITH(NOLOCK)
		WHERE 1=1
		  AND JP.LOOKUP_TYPE = 'JV_PLANT'
		  AND JP.VALID_YN = 'Y'
		GROUP BY JP.SEGMENT1
				,JP.SEGMENT3
		)
	  UPDATE TGT 
	     SET TGT.DIVISION_ID = JP.DIVISION_ID_JV
	    FROM xif_erp_intransit_r_sn_temp$ TGT
			INNER JOIN JV_PLANT JP WITH(NOLOCK)
				    ON JP.DIVISION_ID = TGT.DIVISION_ID
				   AND JP.COMPANY_ID  = TGT.COMPANY_ID

	  /*
	  -- GM JV division 처리
	  UPDATE xif_erp_intransit_r_sn_temp$
	  SET    division_id = CASE WHEN company_id = 'G670' THEN '81_UC'
                                ELSE division_id
						   END
	  */
      -------------------------------------------------------------------------
	  -------------------------------------------------------------------------

      -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
      IF OBJECT_ID('dbo.scm_dnm_intransit_temp$') IS NOT NULL 
        DROP TABLE scm_dnm_intransit_temp$
    
      /*  추가로 인터페이스 된 데이터만 처리하기 위해 valid_yn 컬럼 값을 N 으로 변경
          기존에 있는 데이터는 update 로 처리하고 신규로 삽입하는 데이터는 valid_yn N 으로 놓고 로직 처리후 업데이트
      */
      UPDATE scm_dnm_intransit
      SET    valid_yn = 'N'
      FROM   scm_dnm_intransit A WITH(NOLOCK)
      INNER JOIN (SELECT company_id
                        ,plant_id
                        ,customer_code
                        ,sales_org
                        ,division_id
                        ,distribution_channel
                        ,order_no
                        ,delivery_no
                        ,shipment_no
                        ,item_id origin_item_id --2018.07.20
                        ,order_item_seq
                        ,delivery_item_seq 
                  --FROM  xif_erp_intransit_r_sn WITH(NOLOCK) 
                  FROM  xif_erp_intransit_r_sn_temp$ WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
                  WHERE transfer_flag = 'P'
                  GROUP BY company_id
                          ,plant_id
                          ,customer_code
                          ,sales_org
                          ,division_id
                          ,distribution_channel
                          ,order_no
                          ,delivery_no
                          ,shipment_no
                          ,item_id
                          ,order_item_seq
                          ,delivery_item_seq) B
      ON    A.company_id           =  B.company_id
      AND   A.plant_id             =  B.plant_id
      AND   A.customer_code        =  B.customer_code
      AND   A.sales_org            =  B.sales_org  
      AND   A.division_id          =  B.division_id
      AND   A.distribution_channel =  B.distribution_channel
      AND   A.order_no             =  B.order_no
      AND   A.delivery_no          =  B.delivery_no
      AND   A.shipment_no          =  B.shipment_no
      AND   A.origin_item_id	   =  B.origin_item_id --2018.07.02 , 2018.07.20
      AND   A.order_item_seq       =  B.order_item_seq
      AND   A.delivery_item_seq    =  B.delivery_item_seq

      SELECT * INTO dbo.scm_dnm_intransit_temp$
      FROM   dbo.scm_dnm_intransit WITH(NOLOCK);

      /*== Plant Issue ===========================================================*/    
     
      -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
      DECLARE CUR_INTRANSIT_P CURSOR FOR
        SELECT ifseqno
        --FROM   xif_erp_intransit_r_sn WITH(NOLOCK)
        FROM   xif_erp_intransit_r_sn_temp$ WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
        WHERE  transfer_flag = 'P'
        AND    result_type = 'P'
        GROUP BY ifseqno
      ORDER BY ifseqno ASC;

      OPEN CUR_INTRANSIT_P;
      FETCH NEXT FROM CUR_INTRANSIT_P INTO @v_ifseqno ;
     
      WHILE (@@FETCH_STATUS = 0)
        
        BEGIN
      
          MERGE INTO scm_dnm_intransit A
          USING (SELECT  /* PR_SCM_DNM_INTRANSIT - P */ 
                         result_date
                        ,result_type
                        ,result_seq
                        ,company_id
                        ,plant_id
                        ,customer_code
                        ,customer_name
                        ,project_code
                        ,sales_org
                        ,division_id
                        ,distribution_channel
                        ,order_no
                        ,delivery_no
                        ,shipment_no
                        ,order_item_seq
                        ,delivery_item_seq
                        ,ISNULL(delivery_qty,0) delivery_qty
                        ,uom
                        ,incoterms
                        ,item_id origin_item_id --2018.07.20
                        ,plant_issue_date
                        ,sales_posting_date
                        ,delivery_posting_date
                        ,on_board_date
                        ,eta_date
                        ,pod_date
                        ,f_dest_date
                        ,transport_mode AS transport_mode_erp
                        --,dbo.fn_scm_sys_nvl(dbo.fn_get_lookup_code_desc('TRANSPORT_MODE_ERP',transport_mode),'-') transport_mode
						--,dbo.fn_get_transport_mode_erp(transport_mode) transport_mode --2018.06.11
						-- 20250103 ksg : NERP 정보 처리를 위한 수정
						, CASE WHEN ISNULL(trmod, '') <> '' THEN trmod
						       WHEN ISNULL(trmod, '') = '' AND ISNULL(CARTYPE_TXT, '') <> '' THEN dbo.fn_get_transport_mode_erp(CARTYPE_TXT)
						       ELSE dbo.fn_get_transport_mode_erp(transport_mode)
						  END transport_mode

                        ,order_type_code
                        ,order_type_name
                        ,order_category_code
                        ,order_category_name
                        ,transport_route_code
                        ,transport_route_name
                        ,dest_country_code
                        ,dest_port_code
                        ,dest_port_desc
                        ,etd_date
                        ,shipto_code
                        ,shipto_description
                        ,storage_id
                        ,cross_trade_flag
                        ,corp_po_no
                        ,corp_po_item_seq
                        ,corp_gr_no
                        ,corp_gr_date
                        ,dbo.fn_get_fcst_type(a.sales_type_2) sales_type_2
						,dbo.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id) item_id --2018.07.02 , 2018.07.20
                        -- 20201007 PJ20202001  신규 컬럼 추가
                        ,final_soldto_code, final_soldto_name, final_incoterms
                 --FROM   xif_erp_intransit_r_sn A WITH(NOLOCK)

                        /*2023.01.20*/
                        ,attribute6, attribute7
                 FROM   xif_erp_intransit_r_sn_temp$ A WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
                 WHERE  ifseqno       = @v_ifseqno
                 AND    transfer_flag = 'P'
                 AND    result_type   = 'P'
                  -- AND project_code > char(0)
                 ) B
          ON    A.company_id           =  B.company_id
          AND   A.plant_id             =  B.plant_id
          AND   A.customer_code        =  B.customer_code
          AND   A.sales_org            =  B.sales_org  
          AND   A.division_id          =  B.division_id
          AND   A.distribution_channel =  B.distribution_channel
          AND   A.order_no             =  B.order_no
          AND   A.delivery_no          =  B.delivery_no
          AND   A.shipment_no          =  B.shipment_no
          AND   A.origin_item_id       =  B.origin_item_id --2018.07.02 , 2018.07.20
          AND   A.order_item_seq       =  B.order_item_seq
          AND   A.delivery_item_seq    =  B.delivery_item_seq          
         
          WHEN MATCHED THEN
          
          UPDATE 
          SET    A.customer_name         =  B.customer_name
                ,A.project_code          =  B.project_code
                ,A.order_category_code   =  B.order_category_code
                ,A.transport_route_code  =  B.transport_route_code                  
                ,A.delivery_qty          =  B.delivery_qty
				,A.from_scm_site_id		 =  NULL -- 2018.06.21
				,A.to_scm_site_id		 =  NULL -- 2018.06.21
				,A.item_id				 =  B.item_id --2018.07.02 , 2018.07.20
                ,A.uom                   =  B.uom
                ,A.incoterms             =  B.incoterms
				,A.origin_incoterms      =  B.incoterms -- 2018.06.26
                ,A.sales_posting_date    =  B.sales_posting_date
                ,A.delivery_posting_date =  B.delivery_posting_date
                ,A.on_board_date         =  B.on_board_date
                ,A.eta_date              =  B.eta_date
                ,A.pod_date              =  B.pod_date
                ,A.f_dest_date           =  B.f_dest_date
                ,A.plant_issue_date      =  B.plant_issue_date
                ,A.transport_mode_erp    =  B.transport_mode_erp
                ,A.transport_mode        =  B.transport_mode
                ,A.order_type_code       =  B.order_type_code
                ,A.order_type_name       =  B.order_type_name
                ,A.order_category_name   =  B.order_category_name
                ,A.transport_route_name  =  B.transport_route_name
                ,A.pod                   =  B.dest_country_code+B.dest_port_code
                ,A.pod_desc              =  B.dest_port_desc
                ,A.etd_date              =  B.etd_date
                ,A.shipto_code           =  B.shipto_code
                ,A.shipto_description    =  B.shipto_description
                ,A.storage_id            =  B.storage_id
                ,A.cross_trade_flag      =  B.cross_trade_flag
                ,A.corp_po_no            =  B.corp_po_no
                ,A.corp_po_item_seq      =  B.corp_po_item_seq
                ,A.corp_gr_no            =  B.corp_gr_no
                ,A.corp_gr_date          =  B.corp_gr_date
                ,A.fcst_type             =  B.sales_type_2
                ,A.last_updated_by       =   @v_batch_user
                ,A.last_update_date      =   GETDATE()
                -- 20201007 PJ20202001  신규 컬럼 추가
                ,A.final_soldto_code     =  B.final_soldto_code
                ,A.final_soldto_name     =  B.final_soldto_name
                ,A.final_incoterms       =  B.final_incoterms

                /*2023.01.20*/
                ,A.attribute6 = B.attribute6
                ,A.attribute7 = B.attribute7
                          
          WHEN NOT MATCHED THEN
          INSERT (company_id
                 ,plant_id
                 ,customer_code
                 ,customer_name
                 --,from_site_item_mapping_yn
                 --,to_site_item_mapping_yn
                 ,project_code
                 ,sales_org
                 ,division_id
                 ,distribution_channel
                 ,order_no
                 ,delivery_no
                 ,shipment_no
                 ,order_item_seq
                 ,delivery_item_seq
                 ,delivery_qty
                 ,uom
                 ,incoterms
				 ,origin_incoterms -- 2018.06.26
                 ,item_id
				 ,origin_item_id --2018.07.02
                 ,plant_issue_date
                 ,sales_posting_date
                 ,delivery_posting_date
                 ,on_board_date
                 ,eta_date
                 ,pod_date
                 ,f_dest_date
                 ,transport_mode_erp
                 ,transport_mode
                 ,order_type_code
                 ,order_type_name
                 ,order_category_code
                 ,order_category_name
                 ,transport_route_code
                 ,transport_route_name
                 ,pod
                 ,pod_desc
                 ,etd_date
                 ,shipto_code
                 ,shipto_description
                 ,storage_id
                 ,cross_trade_flag
                 ,corp_po_no
                 ,corp_po_item_seq
                 ,corp_gr_no
                 ,corp_gr_date
                 ,fcst_type
                 ,valid_yn
                 ,created_by
                 ,creation_date
                 ,last_updated_by
                 ,last_update_date
                 -- 20201007 PJ20202001  신규 컬럼 추가
                 ,final_soldto_code, final_soldto_name, final_incoterms

                 /*2023.01.20*/
                 ,attribute6, attribute7
                 )
          VALUES (B.company_id
                 ,B.plant_id
                 ,B.customer_code
                 ,B.customer_name
                 --,'N'
                 --,'N'
                 ,B.project_code
                 ,B.sales_org
                 ,B.division_id
                 ,B.distribution_channel
                 ,B.order_no
                 ,B.delivery_no
                 ,B.shipment_no
                 ,B.order_item_seq
                 ,B.delivery_item_seq
                 ,B.delivery_qty
                 ,B.uom
                 ,B.incoterms
				 ,B.incoterms -- 2018.06.26
                 ,B.item_id --2018.07.02 , 2018.07.20
				 ,B.origin_item_id --2018.07.02 , 2018.07.20
                 ,B.plant_issue_date
                 ,B.sales_posting_date
                 ,B.delivery_posting_date
                 ,B.on_board_date
                 ,B.eta_date
                 ,B.pod_date
                 ,B.f_dest_date
                 ,B.transport_mode_erp
                 ,B.transport_mode
                 ,B.order_type_code
                 ,B.order_type_name
                 ,B.order_category_code
                 ,B.order_category_name
                 ,B.transport_route_code
                 ,B.transport_route_name
                 ,B.dest_country_code+B.dest_port_code
                 ,B.dest_port_desc
                 ,B.etd_date
                 ,B.shipto_code
                 ,B.shipto_description
                 ,B.storage_id
                 ,B.cross_trade_flag
                 ,B.corp_po_no
                 ,B.corp_po_item_seq
                 ,B.corp_gr_no
                 ,B.corp_gr_date
                 ,B.sales_type_2
                 ,'N'
                 ,@v_batch_user
                 ,GETDATE()
                 ,@v_batch_user
                 ,GETDATE() 
                 -- 20201007 PJ20202001  신규 컬럼 추가
                 ,B.final_soldto_code, B.final_soldto_name, B.final_incoterms

                 /*2023.01.20*/
                 ,B.attribute6, B.attribute7
                 )
          ;

          -----------------------------------------------------------
          -- Merge LOG
          -----------------------------------------------------------
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'APPEND';
          SET @v_log_message = 'MERGE INTO scm_dnm_intransit , result_type = P';
          SET @v_description = 'ifseqno = ' + @v_ifseqno;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------
    
          FETCH NEXT FROM CUR_INTRANSIT_P INTO  @v_ifseqno
        END
    
      CLOSE CUR_INTRANSIT_P;
      DEALLOCATE CUR_INTRANSIT_P; 

      /*== Intransit ===========================================================*/
      
      DECLARE CUR_INTRANSIT_I CURSOR FOR
        SELECT ifseqno 
        --FROM   xif_erp_intransit_r_sn WITH(NOLOCK)
        FROM   xif_erp_intransit_r_sn_temp$ WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
        WHERE  transfer_flag = 'P'
        AND    result_type   = 'I'
        GROUP BY ifseqno
        ORDER BY ifseqno asc;

      OPEN CUR_INTRANSIT_I;
      FETCH NEXT FROM CUR_INTRANSIT_I INTO @v_ifseqno ;
     
      WHILE (@@FETCH_STATUS = 0)
        BEGIN

          MERGE INTO scm_dnm_intransit A
          USING (SELECT  /* PR_SCM_DNM_INTRANSIT - P */ 
                         result_date
                        ,result_type
                        ,result_seq
                        ,company_id
                        ,plant_id
                        ,customer_code
                        ,customer_name
                        ,project_code
                        ,sales_org
                        ,division_id
                        ,distribution_channel
                        ,order_no
                        ,delivery_no
                        ,shipment_no
                        ,order_item_seq
                        ,delivery_item_seq
                        ,ISNULL(delivery_qty,0) delivery_qty
                        ,uom
                        ,incoterms
                        ,item_id origin_item_id --2018.07.20
                        ,plant_issue_date
                        ,sales_posting_date
                        ,delivery_posting_date
                        ,on_board_date
                        ,eta_date
                        ,pod_date
                        ,f_dest_date
                        ,transport_mode AS transport_mode_erp
                        --,dbo.fn_scm_sys_nvl(dbo.fn_get_lookup_code_desc('TRANSPORT_MODE_ERP',transport_mode),'-') transport_mode
						--,dbo.fn_get_transport_mode_erp(transport_mode) transport_mode --2018.06.11
						-- 20250103 ksg : NERP 정보 처리를 위한 수정
						, CASE WHEN ISNULL(trmod, '') <> '' THEN trmod
						       WHEN ISNULL(trmod, '') = '' AND ISNULL(CARTYPE_TXT, '') <> '' THEN dbo.fn_get_transport_mode_erp(CARTYPE_TXT)
						       ELSE dbo.fn_get_transport_mode_erp(transport_mode)
						  END transport_mode
                        ,order_type_code
                        ,order_type_name
                        ,order_category_code
                        ,order_category_name
                        ,transport_route_code
                        ,transport_route_name
                        ,dest_country_code
                        ,dest_port_code
                        ,dest_port_desc
                        ,etd_date
                        ,shipto_code
                        ,shipto_description
                        ,storage_id
                        ,cross_trade_flag
                        ,corp_po_no
                        ,corp_po_item_seq
                        ,corp_gr_no
                        ,corp_gr_date
                        ,dbo.fn_get_fcst_type(a.sales_type_2) sales_type_2
						,dbo.FN_GET_PACKER_PLAN_ITEM_ID(division_id , item_id) item_id --2018.07.02 , 2018.07.20
                        -- 20201007 PJ20202001  신규 컬럼 추가
                        ,final_soldto_code, final_soldto_name, final_incoterms

                        /*2023.01.20*/
                        ,attribute6, attribute7
                 --FROM   xif_erp_intransit_r_sn A WITH(NOLOCK)
                 FROM   xif_erp_intransit_r_sn_temp$ A WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
                 WHERE  ifseqno       = @v_ifseqno
                 AND    transfer_flag = 'P'
                 AND   result_type    = 'I'
                 --AND   project_code > char(0)
                ) B
          ON    A.company_id           =  B.company_id
          AND   A.plant_id             =  B.plant_id
          AND   A.customer_code        =  B.customer_code
          AND   A.sales_org            =  B.sales_org  
          AND   A.division_id          =  B.division_id
          AND   A.distribution_channel =  B.distribution_channel
          AND   A.order_no             =  B.order_no
          AND   A.delivery_no          =  B.delivery_no
          AND   A.shipment_no          =  B.shipment_no
          AND   A.origin_item_id       =  B.origin_item_id --2018.07.02 , 2018.07.20
          AND   A.order_item_seq       =  B.order_item_seq
          AND   A.delivery_item_seq    =  B.delivery_item_seq          
          
          WHEN MATCHED THEN          
          UPDATE 
          SET    A.customer_name         =  B.customer_name
                ,A.project_code          =  B.project_code
                ,A.order_category_code   =  B.order_category_code
                ,A.transport_route_code  =  B.transport_route_code                    
                ,A.delivery_qty          =  B.delivery_qty
				,A.from_scm_site_id		 =  NULL -- 2018.06.21
				,A.to_scm_site_id		 =  NULL -- 2018.06.21
				,A.item_id				 =  B.item_id --2018.07.02 , 2018.07.20
                ,A.uom                   =  B.uom
                ,A.incoterms             =  B.incoterms
				,A.origin_incoterms      =  B.incoterms -- 2018.06.26
                ,A.sales_posting_date    =  B.sales_posting_date
                ,A.delivery_posting_date =  B.delivery_posting_date
                ,A.on_board_date         =  B.on_board_date
                ,A.eta_date              =  B.eta_date
                ,A.pod_date              =  B.pod_date
                ,A.f_dest_date           =  B.f_dest_date
                ,A.plant_issue_date      =  B.plant_issue_date
                ,A.transport_mode_erp    =  B.transport_mode_erp
                ,A.transport_mode        =  B.transport_mode
                ,A.order_type_code       =  B.order_type_code
                ,A.order_type_name       =  B.order_type_name
                ,A.order_category_name   =  B.order_category_name
                ,A.transport_route_name  =  B.transport_route_name
                ,A.pod                   =  B.dest_country_code+B.dest_port_code
                ,A.pod_desc              =  B.dest_port_desc
                ,A.etd_date              =  B.etd_date
                ,A.shipto_code           =  B.shipto_code
                ,A.shipto_description    =  B.shipto_description
                ,A.storage_id            =  B.storage_id
                ,A.cross_trade_flag      =  B.cross_trade_flag
                ,A.corp_po_no            =  B.corp_po_no
                ,A.corp_po_item_seq      =  B.corp_po_item_seq
                ,A.corp_gr_no            =  B.corp_gr_no
                ,A.corp_gr_date          =  B.corp_gr_date
                ,A.fcst_type             =  B.sales_type_2
                ,A.last_updated_by       =  @v_batch_user
                ,A.last_update_date      =  GETDATE()
                -- 20201007 PJ20202001  신규 컬럼 추가
                ,A.final_soldto_code     =  B.final_soldto_code
                ,A.final_soldto_name     =  B.final_soldto_name
                ,A.final_incoterms       =  B.final_incoterms

                 /*2023.01.20*/
                 ,A.attribute6           =  B.attribute6
                 ,A.attribute7           =  B.attribute7
          WHEN NOT MATCHED THEN
          INSERT  (company_id
                  ,plant_id
                  ,customer_code
                  ,customer_name
                  --,from_site_item_mapping_yn
                  --,to_site_item_mapping_yn
                  ,project_code
                  ,sales_org
                  ,division_id
                  ,distribution_channel
                  ,order_no
                  ,delivery_no
                  ,shipment_no
                  ,order_item_seq
                  ,delivery_item_seq
                  ,delivery_qty
                  ,uom
                  ,incoterms
				  ,origin_incoterms -- 2018.06.26
                  ,item_id
				  ,origin_item_id --2018.07.02
                  ,plant_issue_date
                  ,sales_posting_date
                  ,delivery_posting_date
                  ,on_board_date
                  ,eta_date
                  ,pod_date
                  ,f_dest_date
                  ,transport_mode_erp
                  ,transport_mode
                  ,order_type_code
                  ,order_type_name
                  ,order_category_code
                  ,order_category_name
                  ,transport_route_code
                  ,transport_route_name
                  ,pod
                  ,pod_desc
                  ,etd_date
                  ,shipto_code
                  ,shipto_description
                  ,storage_id
                  ,cross_trade_flag
                  ,corp_po_no
                  ,corp_po_item_seq
                  ,corp_gr_no
                  ,corp_gr_date
                  ,fcst_type
                  ,valid_yn
                  ,created_by
                  ,creation_date
                  ,last_updated_by
                  ,last_update_date    
                  -- 20201007 PJ20202001  신규 컬럼 추가
                  ,final_soldto_code, final_soldto_name, final_incoterms                          

                  /*2023.01.20*/
                  ,attribute6
                  ,attribute7
                  )
          VALUES (B.company_id
                 ,B.plant_id
                 ,B.customer_code
                 ,B.customer_name
                 --,'N'
                 --,'N'
                 ,B.project_code
                 ,B.sales_org
                 ,B.division_id
                 ,B.distribution_channel
                 ,B.order_no
                 ,B.delivery_no
                 ,B.shipment_no
                 ,B.order_item_seq
                 ,B.delivery_item_seq
                 ,B.delivery_qty
                 ,B.uom
                 ,B.incoterms
				 ,B.incoterms -- 2018.06.26
                 ,B.item_id --2018.07.02 , 2018.07.20
				 ,B.origin_item_id --2018.07.02 , 2018.07.20
                 ,B.plant_issue_date
                 ,B.sales_posting_date
                 ,B.delivery_posting_date
                 ,B.on_board_date
                 ,B.eta_date
                 ,B.pod_date
                 ,B.f_dest_date
                 ,B.transport_mode_erp
                 ,B.transport_mode
                 ,B.order_type_code
                 ,B.order_type_name
                 ,B.order_category_code
                 ,B.order_category_name
                 ,B.transport_route_code
                 ,B.transport_route_name
                 ,B.dest_country_code+B.dest_port_code
                 ,B.dest_port_desc
                 ,B.etd_date
                 ,B.shipto_code
                 ,B.shipto_description
                 ,B.storage_id
                 ,B.cross_trade_flag
                 ,B.corp_po_no
                 ,B.corp_po_item_seq
                 ,B.corp_gr_no
                 ,B.corp_gr_date
                 ,B.sales_type_2
                 ,'N'
                 ,@v_batch_user
                 ,GETDATE()
                 ,@v_batch_user
                 ,GETDATE() 
                 -- 20201007 PJ20202001  신규 컬럼 추가
                 ,B.final_soldto_code, B.final_soldto_name, B.final_incoterms

                 /*2023.01.20*/
                 ,B.attribute6
                 ,B.attribute7
                 )
          ;

          SET @n_log_count = @@ROWCOUNT;
       
          -- Intransit 으로 안들어온 건들에 대해서는 이미 입고처리 된 건으로 간주하고 Sales Posting Date Update
          UPDATE scm_dnm_intransit
          SET    sales_posting_date = convert(char(8), getdate()-1, 112)
                ,last_update_date   = getdate()
          FROM   scm_dnm_intransit a
          JOIN  (SELECT  company_id
                        ,plant_id
                        ,customer_code
                        ,sales_org
                        ,division_id
                        ,distribution_channel
                        ,order_no
                        ,delivery_no
                        ,shipment_no
                        ,origin_item_id  --2018.07.20
                        ,order_item_seq
                        ,delivery_item_seq
                 FROM   scm_dnm_intransit di
                 WHERE  isnull(di.sales_posting_date, '') IN ( '', '00000000')
                 EXCEPT
                 SELECT  company_id
                        ,plant_id
                        ,customer_code
                        ,sales_org
                        ,division_id
                        ,distribution_channel
                        ,order_no
                        ,delivery_no
                        ,shipment_no
                        ,item_id  origin_item_id  --2018.07.20
                        ,order_item_seq
                        ,delivery_item_seq
                 --FROM   xif_erp_intransit_r_sn ir
                 FROM   xif_erp_intransit_r_sn_temp$ WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
                 WHERE  ifseqno       = @v_ifseqno
                 AND    transfer_flag = 'P'
                 AND    result_type   = 'I') b
          ON     A.company_id           =  B.company_id
          AND    A.plant_id             =  B.plant_id
          AND    A.customer_code        =  B.customer_code
          AND    A.sales_org            =  B.sales_org  
          AND    A.division_id          =  B.division_id
          AND    A.distribution_channel =  B.distribution_channel
          AND    A.order_no             =  B.order_no
          AND    A.delivery_no          =  B.delivery_no
          AND    A.shipment_no          =  B.shipment_no
          AND    A.origin_item_id		=  B.origin_item_id  --2018.07.20
          AND    A.order_item_seq       =  B.order_item_seq
          AND    A.delivery_item_seq    =  B.delivery_item_seq;
          
          -----------------------------------------------------------
          -- Merge LOG
          -----------------------------------------------------------
          SET @v_log_type    = 'APPEND';
          SET @v_log_message = 'MERGE INTO scm_dnm_intransit , result = I';
          SET @v_description = 'ifseqno = ' + @v_ifseqno;
          SET @d_event_date  = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------
    
          FETCH NEXT FROM CUR_INTRANSIT_I INTO  @v_ifseqno
        END
    
      CLOSE CUR_INTRANSIT_I;
      DEALLOCATE CUR_INTRANSIT_I; 
    
      -- project_code가 'N' 인 데이터 추가적으로 mapping 후 업데이트 2018.04.18
      UPDATE scm_dnm_intransit
      SET    project_code     = B.new_project_code 
            ,last_update_date = GETDATE()
      FROM   scm_dnm_intransit A
      INNER JOIN (SELECT  CASE WHEN ( -- MKT FCST를 입력한 Project가 하나인 경우
                                     SELECT COUNT(DISTINCT x.project_code)
                                     FROM   dm_pln_mkt_fcst x WITH(NOLOCK)
                                     WHERE  x.division_id = a.division_id
                                     AND    x.scm_site_id = a.to_scm_site_id
                                     AND    x.item_id     = a.item_id
                                     AND    x.measure     = 'MKT_FCST'
                                     ) = 1  THEN (SELECT DISTINCT x.project_code
                                                  FROM   dm_pln_mkt_fcst x WITH(NOLOCK)
                                                  WHERE  x.division_id = a.division_id
                                                  AND    x.scm_site_id = a.to_scm_site_id
                                                  AND    x.item_id     = a.item_id
                                                  AND    x.measure     = 'MKT_FCST'
                                                  ) 
                               WHEN (  -- SITE_ITEM에 동일 SITE로 하나의 Project만 연결된 경우
                                     SELECT COUNT(DISTINCT w.project_code)
                                     FROM   scm_mst_site_item w WITH(NOLOCK)
                                     WHERE  w.division_id		= a.division_id
                                     AND    w.scm_site_id		= a.to_scm_site_id
                                     AND    a.item_id		    = w.item_id
                                     AND    w.valid_yn			= 'Y'
                                     ) = 1  THEN (SELECT DISTINCT w.project_code
                                                  FROM   scm_mst_site_item w WITH(NOLOCK)
                                                  WHERE  w.division_id		 = a.division_id
                                                  AND    w.scm_site_id		 = a.to_scm_site_id
                                                  AND    a.item_id		     = w.item_id
                                                  AND    w.valid_yn			 = 'Y'
                                                  )
                               WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우
                                     SELECT COUNT(DISTINCT w.project_code)
                                     FROM   scm_mst_site_item w WITH(NOLOCK)
                                     WHERE  w.division_id		 = a.division_id
                                     AND    a.item_id		     = w.item_id
                                     AND    w.valid_yn			 = 'Y'
                                     ) = 1  THEN (SELECT DISTINCT w.project_code
                                                  FROM   scm_mst_site_item w WITH(NOLOCK)
                                                  WHERE  w.division_id		= a.division_id
                                                  AND    a.item_id		    = w.item_id
                                                  AND    w.valid_yn			= 'Y'
                                                  )
                               ELSE project_code
                               END  new_project_code
                         ,company_id
                         ,plant_id
                         ,sales_org
                         ,division_id
                         ,project_code
                         ,distribution_channel
                         ,order_no
                         ,delivery_no
                         ,shipment_no
                         ,order_item_seq
                         ,item_id
                  FROM   scm_dnm_intransit a WITH(NOLOCK)
                  WHERE project_code = ''
                  OR    project_code = 'TBD'
                  ) B
      ON     A.company_id            = B.company_id
      AND    A.plant_id              = B.plant_id
      AND    A.sales_org             = B.sales_org
      AND    A.division_id           = B.division_id
      AND    A.project_code          = B.project_code
      AND    A.distribution_channel  = B.distribution_channel
      AND    A.order_no              = B.order_no
      AND    A.delivery_no           = B.delivery_no
      AND    A.shipment_no           = B.shipment_no
      AND    A.order_item_seq        = B.order_item_seq
      AND    A.item_id		         = B.item_id
      WHERE  B.new_project_code      != 'N'     

      /*===== From Site Mapping Start =======================================================================*/ 
      	  
      /*======20220121 PJ20216891 SSP 정보를 사용한 From/To Site Mapping : START===========================*/
	  -- 0. confirm_id 를사용한 From Site Mapping
      UPDATE scm_dnm_intransit
      SET    from_scm_site_id = c.from_site 
           , attribute1       = c.confirm_id 
      FROM   scm_dnm_intransit A WITH(NOLOCK)

      INNER JOIN (SELECT  DISTINCT division_id, order_no, order_item_seq, origin_item_id, plant_id
                                 , confirm_id, FROM_SCM_SITE_ID, TO_SCM_SITE_ID
                  FROM   scm_dnm_exfactory_result a WITH(NOLOCK)
                  WHERE isnull(confirm_id, '') <> ''
                 ) B
      ON     A.division_id    = B.division_id
	  AND    A.order_no       LIKE '%' + B.order_no
	  AND    A.order_item_seq LIKE '%' + B.order_item_seq
      AND    A.origin_item_id =          B.origin_item_id

      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.confirm_id, MAX(sc.from_site) from_site, MAX(ISNULL(md.segment1, sc.to_site)) to_site
            FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)

                   LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                   ON   sc.division_id = md.segment3
                   AND  sc.to_site     = md.segment2
                   AND  md.lookup_type = 'AS_SITE_PLANT'
                   AND  md.valid_yn    = 'Y'

            WHERE  1=1
            --AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
            GROUP BY sc.division_id, sc.confirm_id
           ) c
      ON     b.division_id = c.division_id
      AND    b.confirm_id  = c.confirm_id	  
      WHERE  ISNULL(a.from_scm_site_id, '') = '';

	  -- 1. corp_po_no 를사용한 From Site Mapping
      UPDATE scm_dnm_intransit
      SET    from_scm_site_id = B.from_site 
      FROM   scm_dnm_intransit A WITH(NOLOCK) 
      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.erp_so_no, MAX(sc.from_site) from_site
            FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)
            WHERE  1=1
            AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
            GROUP BY sc.division_id, sc.erp_so_no
           ) b 
      ON     A.division_id = b.division_id
      AND    A.corp_po_no  = b.erp_so_no
      WHERE  ISNULL(a.from_scm_site_id, '') = '';
	  
	  -- 2. order_no 를사용한 From Site Mapping
      UPDATE scm_dnm_intransit
      SET    from_scm_site_id = C.from_site 
      FROM   scm_dnm_intransit A WITH(NOLOCK) 
      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.erp_so_no, MAX(sc.from_site) from_site
            FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)
            WHERE  1=1
            AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
            GROUP BY sc.division_id, sc.erp_so_no
           ) C
      ON     A.division_id = c.division_id
      AND    A.order_no    = c.erp_so_no
      WHERE  ISNULL(a.from_scm_site_id, '') = '';

      /*======20220121 SSP 정보를 사용한 From Site Mapping : END===========================*/

      -- 1. from_scm_site_id Mapping 2018.04.10   Kim Jaejung 
      UPDATE scm_dnm_intransit
      SET    from_scm_site_id = dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id))
            ,last_update_date = getdate()
      FROM   scm_dnm_intransit A WITH(NOLOCK) 
      WHERE  ISNULL(a.from_scm_site_id, '') = '';
    
      -- 2. from_scm_site_id Mapping : 전극이 A040 창고에서 출하되는 경우 2018.04.10   Kim Jaejung 
      UPDATE scm_dnm_intransit
      SET    from_scm_site_id = B.segment2 
            ,last_update_date = GETDATE()
      FROM   scm_dnm_intransit A WITH(NOLOCK) 
      JOIN  (SELECT segment1
                   ,segment2
             FROM   scm_adm_lookup_master_detail A WITH(NOLOCK) 
             WHERE  lookup_type = 'ELECTRODE_SHIP_SITE' 
             AND    valid_yn    = 'Y' 
             AND    segment3    = '*'
            ) B
      ON    A.plant_id   = B.segment1
      JOIN (SELECT  DISTINCT 
                    division_id
                   ,item_id
                   ,CASE ISNULL(O.operation_group_id,'') WHEN 'S' THEN 'E' ELSE O.operation_group_id END operation_group_id
            FROM   scm_mst_item_sn              I WITH(NOLOCK)
                  ,scm_mst_item_class_level_sn  O WITH(NOLOCK)
            WHERE  1=1
            AND    I.item_class           LIKE O.level_id+'%'
            AND    O.operation_group_id   IS NOT NULL
            AND    O.use_flag             = 'Y'
            AND    O.operation_group_id   IN('S','E')
           ) C
      ON     A.division_id		= C.division_id
      AND    A.item_id		    = C.item_id
      WHERE  ISNULL(a.from_scm_site_id, '') = '';

      -- 3. from_scm_site_id Mapping : Pack 이 A050 에서 출하되는 경우 (외주 Packer) 2018.04.10   Kim Jaejung 
      UPDATE scm_dnm_intransit
      SET    from_scm_site_id = B.scm_site_id 
            ,last_update_date = GETDATE()
      FROM   scm_dnm_intransit A WITH(NOLOCK) 
      JOIN  (SELECT  distinct 
                     si.division_id
                    ,si.plant_site_id scm_site_id
                    ,si.item_id
             FROM   scm_mst_site_item_priority_v si WITH(NOLOCK) 
             JOIN   scm_mst_site ms WITH(NOLOCK) 
             ON     si.division_id   = ms.division_id
             AND    si.plant_site_id = ms.scm_site_id
             WHERE  ms.valid_yn    = 'Y'
             AND    ms.site_type   = 'PLANT'
             AND    ms.osp_yn      = 'Y'
             AND    CONVERT(char(8), GETDATE(), 112) BETWEEN from_yyyymmdd AND to_yyyymmdd
            ) B
      ON    A.division_id		= B.division_id
      AND   A.item_id		    = B.item_id
      WHERE ISNULL(a.from_scm_site_id, '') = '';
    
      /*===== From Site Mapping End ==========================================================================*/
    
      /*===== Sales Site Mapping Start =======================================================================*/
      	  
      /*======20220425 PI 요청 자동차 VMI 우선 To Site Mapping : START===========================*/
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   = b.scm_site_id 
           , last_updated_by  = '0. 81 VMI To Site'
      FROM   scm_dnm_intransit A WITH(NOLOCK)
	  
      JOIN  (SELECT  sc.division_id
                    ,sc.soldto_code
                    ,sc.shipto_code
                    ,MAX(sc.scm_site_id) scm_site_id 
             FROM   scm_mst_site_customer sc WITH(NOLOCK)
			 JOIN   scm_mst_site ms
			 ON     sc.division_id = ms.division_id
			 AND    sc.scm_site_id = ms.scm_site_id
             WHERE  sc.valid_yn  = 'Y'
			 AND    ms.vmi_yn    = 'Y'  -- VMI
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY sc.division_id
                     ,sc.soldto_code
                     ,sc.shipto_code
             HAVING count(distinct sc.scm_site_id) = 1 -- 2018.06.01   Kim Jihye
            ) B
      ON     B.division_id =  A.division_id
      AND    B.soldto_code =  [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) 
      AND    B.shipto_code =  A.shipto_code
	  
	  --WHERE  a.division_id IN ('81', '81_UC')  -- 자동차 사업부 VMI만 처리-- 20220425 PJ20216891 : GM JV 가상 Division 추가
	  WHERE  a.division_id IN ( -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - HM JV 가상 사업부 추가 반영
								SELECT DIVISION_ID 
								  FROM SCM_MST_DIVISION DM WITH(NOLOCK)
								 WHERE DM.ATTRIBUTE3 = '81'  -- 자동차 사업부 VMI만 처리
								   AND DM.VALID_YN	 = 'Y'
							 ) 
	  AND    ISNULL(a.to_scm_site_id, '')   = '';
      	  
      /*======20220425 PI 요청 자동차 VMI 우선 To Site Mapping : END===========================*/
      	  
      /*======20220121 PJ20216891 SSP 정보를 사용한 To Site Mapping : START===========================*/

	  -- 1. corp_po_no 를사용한 To Site Mapping
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   = c.to_site 
           , attribute1       = c.confirm_id 
            ,last_updated_by  = '0. SSP confirm_id'
      FROM   scm_dnm_intransit A WITH(NOLOCK)

      INNER JOIN (SELECT  DISTINCT division_id, order_no, order_item_seq, origin_item_id, plant_id
                                 , confirm_id, FROM_SCM_SITE_ID, TO_SCM_SITE_ID
                  FROM   scm_dnm_exfactory_result a WITH(NOLOCK)
                  WHERE isnull(confirm_id, '') <> ''
                 ) B
      ON     A.division_id    = B.division_id
	  AND    A.order_no       LIKE '%' + B.order_no
	  AND    A.order_item_seq LIKE '%' + B.order_item_seq
      AND    A.origin_item_id =          B.origin_item_id

      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.confirm_id, MAX(sc.from_site) from_site, MAX(ISNULL(md.segment1, sc.to_site)) to_site
            FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)

                   LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                   ON   sc.division_id = md.segment3
                   AND  sc.to_site     = md.segment2
                   AND  md.lookup_type = 'AS_SITE_PLANT'
                   AND  md.valid_yn    = 'Y'

            WHERE  1=1
            --AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
            GROUP BY sc.division_id, sc.confirm_id
           ) c
      ON     b.division_id = c.division_id
      AND    b.confirm_id  = c.confirm_id	  
      WHERE  ISNULL(a.to_scm_site_id, '')   = '';

	  -- 1. corp_po_no 를사용한 To Site Mapping
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id = B.to_site 
            ,last_updated_by  = '0. SSP corp_po_no'
      FROM   scm_dnm_intransit A WITH(NOLOCK) 
      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.erp_so_no, MAX(ISNULL(md.segment1, sc.to_site)) AS to_site
                 FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)

                      LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                      ON   sc.division_id = md.segment3
                      AND  sc.to_site     = md.segment2
                      AND  md.lookup_type = 'AS_SITE_PLANT'
                      AND  md.valid_yn    = 'Y'

                 WHERE  1=1
                 AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
				 GROUP BY sc.division_id, sc.erp_so_no
           ) b 
      ON    a.division_id = b.division_id
      AND   a.corp_po_no  = b.erp_so_no
      WHERE ISNULL(a.to_scm_site_id, '') = '';
	  
	  -- 2. order_no 를사용한 To Site Mapping
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id = C.to_site 
            ,last_updated_by  = '0. SSP Order No'
      FROM   scm_dnm_intransit A WITH(NOLOCK) 
      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.erp_so_no, MAX(ISNULL(md.segment1, sc.to_site)) AS to_site
                 FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)

                      LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                      ON   sc.division_id = md.segment3
                      AND  sc.to_site     = md.segment2
                      AND  md.lookup_type = 'AS_SITE_PLANT'
                      AND  md.valid_yn    = 'Y'

                 WHERE  1=1
                 AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
				 GROUP BY sc.division_id, sc.erp_so_no
           ) C
      ON    a.division_id = c.division_id
      AND   a.order_no    = c.erp_so_no
      WHERE ISNULL(a.to_scm_site_id, '') = '';

      /*======20220121 SSP 정보를 사용한 To Site Mapping : END===========================*/

      /*===== 법인간 이동 ====================================================================================*/
	  
	  -- 20210611 PJ20209642 : 특정 법인향 Item To Site 지정
      -- 0. Sales Site Mapping : 법인간 이동 - 특정 법인향 Item To Site 지정	  
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   = md.segment3
            ,last_update_date = getdate()
            ,last_updated_by  = '0. Sales Site Mapping'
      FROM   scm_dnm_intransit a WITH(NOLOCK)
      INNER JOIN (
                  SELECT *
                  FROM   scm_adm_lookup_master_detail md WITH(NOLOCK) -- 2018. 04.10  Kim Jihye
                  WHERE  md.lookup_type = 'INTRANSIT_TO_SITE'
                  AND    md.valid_yn    = 'Y'  
                 ) md 
      ON  md.segment1    = [dbo].[FN_SCM_SYS_NVL](a.final_soldto_code, a.customer_code)
      AND md.segment2    = a.item_id
      WHERE len([dbo].[FN_SCM_SYS_NVL](a.final_soldto_code, a.customer_code)) = 4
      AND   len(a.shipto_code)           = 4 
      AND   isnull(a.to_scm_site_id, '') = '';

      -- 1. Sales Site Mapping : 법인간 이동 - 법인 PO 참조하여 도착 Plant 에 site 가 1개 인 경우
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id     = c.scm_site_id
            ,last_update_date   = getdate()
			,last_updated_by  = '1. Sales Site Mapping'
      FROM   scm_dnm_intransit A WITH(NOLOCK)
      JOIN   scm_dnm_mat_po B WITH(NOLOCK)
      ON     A.company_id       = B.vendor_code
      AND    A.corp_po_no       = B.po_no
      AND    A.corp_po_item_seq = B.po_item_seq
      -- 20220921 C20220920-000279 Intansit재고의 To Site Mapping처리 시 '법인간 이동' 부분 로직 개선
      --                           -> sold to code 처리 시 'B100'인 경우 'C100' 으로 변경하여 To Site Mapping 될 수 있도록 처리
      AND    CASE WHEN [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) = @np_company_value THEN @np_company_change
	              ELSE [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) 
	         END = B.company_id 
      --AND    [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) = B.company_id --  20201007 PJ20202001
      AND    A.item_id			= B.item_id
      JOIN  (SELECT plant_id
                   ,max(scm_site_id) scm_site_id
             FROM   scm_mst_site
             WHERE  site_type = 'PLANT'
             AND    valid_yn = 'Y'
             GROUP BY plant_id
             HAVING count(distinct scm_site_id) = 1) C
      ON     B.plant_id = C.plant_id
      WHERE  len([dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code)) = 4 --  20201007 PJ20202001
      --WHERE  len(A.customer_code)         = 4
      AND    len(A.shipto_code)           = 4 -- 20181112 조건 추가
      AND    len(A.corp_po_no)            > 0
      AND    isnull(A.to_scm_site_id, '') = '';
     
      -- 2. Sales Site Mapping : 법인간 이동 - 법인 PO 참조하여 전극인 경우 Cell 사이트로, 그 외는 Pack 사이트로 
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id     = c.scm_site_id
            ,last_update_date   = getdate()
			,last_updated_by  = '2. Sales Site Mapping'
      FROM   scm_dnm_intransit A WITH(NOLOCK)
      JOIN   scm_dnm_mat_po B WITH(NOLOCK)
      ON     A.company_id       = B.vendor_code
      AND    A.corp_po_no       = B.po_no
      AND    A.corp_po_item_seq = B.po_item_seq
      -- 20220921 C20220920-000279 Intansit재고의 To Site Mapping처리 시 '법인간 이동' 부분 로직 개선
      --                           -> sold to code 처리 시 'B100'인 경우 'C100' 으로 변경하여 To Site Mapping 될 수 있도록 처리
      AND    CASE WHEN [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) = @np_company_value THEN @np_company_change
	              ELSE [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) 
	         END = B.company_id 
      --AND    [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) = B.company_id --  20201007 PJ20202001
      AND    A.item_id		    = B.item_id 
      JOIN  (SELECT  plant_id
                    ,scm_site_id
                    ,operation_group
             FROM   scm_mst_site
             WHERE  site_type = 'PLANT'
             AND    valid_yn  = 'Y') C
      ON     B.plant_id = C.plant_id
      AND    CASE dbo.FN_GET_ITEM_OPERATION_GROUP (a.division_id, a.item_id) WHEN 'E' THEN 'A'
                                                                             WHEN 'A'  THEN 'P'
                                                                             END = C.operation_group
      WHERE  len([dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code)) = 4 --  20201007 PJ20202001
      --WHERE  LEN(A.customer_code)         = 4
      AND    len(A.shipto_code)           = 4 -- 20181112 조건 추가
      AND    LEN(A.corp_po_no)            > 0
      AND    ISNULL(A.to_scm_site_id, '') = '';
      
      -- 3. Sales Site Mapping : 법인간 이동 - Compay, Division, Operation 기준으로 Site 가 1개인 경우 - C2018.04.11 추가
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   = b.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '3. Sales Site Mapping'
      FROM   scm_dnm_intransit A WITH(NOLOCK)    
      JOIN  (SELECT  company_id
                    ,division_id
                    ,operation_group
                    ,max(scm_site_id) scm_site_id
             FROM   scm_mst_site
             WHERE  site_type = 'PLANT'
             AND    osp_yn    = 'N'
             AND    valid_yn  = 'Y'
             GROUP BY company_id, division_id, operation_group
             HAVING count(distinct scm_site_id) = 1) B
      -- 20220921 C20220920-000279 Intansit재고의 To Site Mapping처리 시 '법인간 이동' 부분 로직 개선
      --                           -> sold to code 처리 시 'B100'인 경우 'C100' 으로 변경하여 To Site Mapping 될 수 있도록 처리
      ON     CASE WHEN [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) = @np_company_value THEN @np_company_change
	              ELSE [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) 
	         END = B.company_id 
      --ON     [dbo].[FN_SCM_SYS_NVL](a.final_soldto_code, a.customer_code) = b.company_id --  20201007 PJ20202001
      AND    a.division_id   = b.division_id
      AND    CASE dbo.FN_GET_ITEM_OPERATION_GROUP (a.division_id, a.item_id) WHEN 'E' THEN 'A'
                                                                             WHEN 'A'  THEN 'P'
                                                                             END = b.operation_group
      WHERE  len([dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code)) = 4 --  20201007 PJ20202001
      --WHERE  LEN(A.customer_code)         = 4
      AND    len(A.shipto_code)           = 4 -- 20181112 조건 추가
      AND    ISNULL(A.to_scm_site_id, '') = '';
      
      /*===== 판매 사이트 ====================================================================================*/
      -- 4-1. Sales Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping - Packer Site, 2018.09.17
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   =  B.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '4-1. Sales Site Mapping'
      FROM   scm_dnm_intransit A WITH(NOLOCK)
      JOIN  (SELECT  sc.division_id
                    ,sc.soldto_code
                    ,sc.shipto_code
                    ,MAX(sc.scm_site_id) scm_site_id 
             FROM   scm_mst_site_customer sc WITH(NOLOCK) 
			 JOIN   scm_mst_site ms
			 ON     sc.division_id = ms.division_id
			 AND    sc.scm_site_id = ms.scm_site_id
             WHERE  sc.valid_yn  = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'PLANT'
			 AND    ms.osp_yn    = 'Y'
             GROUP BY sc.division_id
                     ,sc.soldto_code
                     ,sc.shipto_code
             HAVING count(distinct sc.scm_site_id) = 1 -- 2018.06.01   Kim Jihye
            ) B
      ON     B.division_id =  A.division_id
      AND    B.soldto_code =  [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) --  20201007 PJ20202001
      --AND    B.soldto_code =  A.customer_code
      AND    B.shipto_code =  A.shipto_code
      WHERE  A.to_scm_site_id is null;

	  -- 4-2. Sales Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping - Sales Site
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   =  B.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '4-2. Sales Site Mapping'
      FROM   scm_dnm_intransit A WITH(NOLOCK)
      JOIN  (SELECT  sc.division_id
                    ,sc.soldto_code
                    ,sc.shipto_code
                    ,MAX(sc.scm_site_id) scm_site_id 
             FROM   scm_mst_site_customer sc WITH(NOLOCK)
			 JOIN   scm_mst_site ms
			 ON     sc.division_id = ms.division_id
			 AND    sc.scm_site_id = ms.scm_site_id
             WHERE  sc.valid_yn  = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY sc.division_id
                     ,sc.soldto_code
                     ,sc.shipto_code
             HAVING count(distinct sc.scm_site_id) = 1 -- 2018.06.01   Kim Jihye
            ) B
      ON     B.division_id =  A.division_id
      AND    B.soldto_code =  [dbo].[FN_SCM_SYS_NVL](A.final_soldto_code, A.customer_code) --  20201007 PJ20202001
      --AND    B.soldto_code =  A.customer_code
      AND    B.shipto_code =  A.shipto_code
      WHERE  A.to_scm_site_id is null;

      -- 5.Sales Site Mapping : project-item-customer 기준으로 하나의 site 만 등록된 경우 Mapping - 2018.05.14   Kim Jihye 
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id = b.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '5. Sales Site Mapping'
      FROM   scm_dnm_intransit sr WITH(NOLOCK) 
      JOIN   (SELECT  item.division_id
                     ,item.project_code
                     ,item_id
                     ,cus.soldto_code
                     ,cus.shipto_code
                     ,max(item.scm_site_id) scm_site_id
              FROM   scm_mst_site site WITH(NOLOCK) 
              JOIN   scm_mst_site_item item WITH(NOLOCK) 
              ON     site.division_id = item.division_id
              AND    site.scm_site_id = item.scm_site_id
              JOIN   scm_mst_site_customer cus WITH(NOLOCK)
              ON     site.division_id = cus.division_id
              AND    site.scm_site_id = cus.scm_site_id
              WHERE  site.valid_yn    = 'Y'
              AND    item.valid_yn    = 'Y'
              AND    site.site_type   = 'SALES'
              GROUP BY item.division_id, item.project_code, item.item_id, cus.soldto_code, cus.shipto_code
              HAVING count(distinct item.scm_site_id) = 1
             ) b
      ON     sr.division_id        = b.division_id
      AND    sr.project_code       = b.project_code
      AND    sr.item_id		       = b.item_id 
      AND    [dbo].[FN_SCM_SYS_NVL](sr.final_soldto_code, sr.customer_code) = b.soldto_code --  20201007 PJ20202001
      --AND    sr.customer_code      = b.soldto_code
      AND    sr.shipto_code        = b.shipto_code
      WHERE  sr.to_scm_site_id IS NULL
      AND    LEN([dbo].[FN_SCM_SYS_NVL](sr.final_soldto_code, sr.customer_code)) != 4 --  20201007 PJ20202001
      --AND    LEN(sr.customer_code) != 4 
      AND    LEN(sr.shipto_code)   != 4
	  AND    sr.division_id        != '40'; -- 2018.09.07 소형 제외

	  -- 6. Sales Site Mapping : project code-Item 기준으로 하나의 site 만 등록된 경우 Mapping - 2018.05.14   Kim Jihye 
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id = b.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '6. Sales Site Mapping'
      FROM   scm_dnm_intransit sr WITH(NOLOCK) 
      JOIN   (SELECT  item.division_id
                     ,item.project_code
                     ,item_id
                     ,MAX(item.scm_site_id) scm_site_id
              FROM   scm_mst_site site WITH(NOLOCK) 
              JOIN   scm_mst_site_item item WITH(NOLOCK) 
              ON     site.division_id = item.division_id
              AND    site.scm_site_id = item.scm_site_id
              WHERE  site.valid_yn    = 'Y'
              AND    item.valid_yn    = 'Y'
              AND    site.site_type   = 'SALES'
              GROUP BY item.division_id, item.project_code, item.item_id
              HAVING count(distinct item.scm_site_id) = 1
             ) b
      ON     sr.division_id        = b.division_id
      AND    sr.project_code       = b.project_code
      AND    sr.item_id		       = b.item_id
      WHERE  sr.to_scm_site_id IS NULL
      AND    LEN([dbo].[FN_SCM_SYS_NVL](sr.final_soldto_code, sr.customer_code)) != 4 --  20201007 PJ20202001
      --AND    LEN(sr.customer_code) != 4 
      AND    LEN(sr.shipto_code)   != 4
	  AND    sr.division_id        != '40'; -- 2018.09.07 소형 제외

      -- 7. Sales Site Mapping : project code 기준으로 하나의 site 만 등록된 경우 Mapping
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   = b.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '7. Sales Site Mapping'
      FROM   scm_dnm_intransit sr  WITH(NOLOCK)
      JOIN  (SELECT  item.division_id
                    ,item.project_code
                    ,MAX(item.scm_site_id) scm_site_id
             FROM   scm_mst_site site  WITH(NOLOCK)
             JOIN   scm_mst_site_item item  WITH(NOLOCK)
             ON     site.division_id = item.division_id
             AND    site.scm_site_id = item.scm_site_id
             WHERE  site.valid_yn    = 'Y'
             AND    item.valid_yn    = 'Y'
             AND    site.site_type   = 'SALES'
			 AND    item.project_code != ''
             GROUP BY item.division_id, item.project_code
             HAVING count(distinct item.scm_site_id) = 1
            ) b
      ON     sr.division_id = b.division_id
      AND    sr.project_code = b.project_code
      WHERE  sr.to_scm_site_id is null
	  AND    sr.division_id    != '40'; -- 2018.09.07 소형 제외

      -- 8-1. Sales Site Mapping : shipto code 기준으로  sales site id가 한건만 있으면 그 site로 mapping - Packer Site, 2018.09.17
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '8-1. Sales Site Mapping'
      FROM   scm_dnm_intransit sr  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.shipto_code
                    ,MAX(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
			 JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'PLANT'
			 AND    ms.osp_yn    = 'Y'
             GROUP BY cus.division_id, cus.shipto_code
             HAVING count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id = cus.division_id
      AND    sr.shipto_code = cus.shipto_code
      WHERE  sr.to_scm_site_id is null;

      -- 8-2. Sales Site Mapping : shipto code 기준으로  sales site id가 한건만 있으면 그 site로 mapping - Sales Site
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '8-2. Sales Site Mapping'
      FROM   scm_dnm_intransit sr  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.shipto_code
                    ,MAX(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
             JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY cus.division_id, cus.shipto_code
             HAVING count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id = cus.division_id
      AND    sr.shipto_code = cus.shipto_code
      WHERE  sr.to_scm_site_id is null;

      -- 9-1. Sales Site Mapping : soldto code 기준으로 sales site id가 한건만 있으면 그 site로 mapping - Packer Site, 2018.09.17
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '9-1. Sales Site Mapping'
      FROM   scm_dnm_intransit sr  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.soldto_code
                    ,MAX(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
             JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'PLANT'
			 AND    ms.osp_yn    = 'Y'
             GROUP BY cus.division_id, cus.soldto_code
             HAVING count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id   = cus.division_id
      AND    [dbo].[FN_SCM_SYS_NVL](sr.final_soldto_code, sr.customer_code) = cus.soldto_code  --  20201007 PJ20202001
      --AND    sr.customer_code = cus.soldto_code
      WHERE  sr.to_scm_site_id is null;

	  -- 9-2. Sales Site Mapping : soldto code 기준으로 sales site id가 한건만 있으면 그 site로 mapping - Sales Site
      UPDATE scm_dnm_intransit
      SET    to_scm_site_id   = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '9-2. Sales Site Mapping'
      FROM   scm_dnm_intransit sr  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.soldto_code
                    ,MAX(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
             JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY cus.division_id, cus.soldto_code
             HAVING count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id   = cus.division_id
      AND    [dbo].[FN_SCM_SYS_NVL](sr.final_soldto_code, sr.customer_code) = cus.soldto_code  --  20201007 PJ20202001
      --AND    sr.customer_code = cus.soldto_code
      WHERE  sr.to_scm_site_id is null;

      /*===== Sales Site Mapping End =======================================================================*/ 

	  -- to_site 가 vmi 인 경우 incoterms 는 DAP 로 변경. 2018.06.25
	  UPDATE scm_dnm_intransit
      SET    incoterms        = 'DAP'
            ,final_incoterms  = 'DAP'  -- 20201007 PJ20202001  신규 컬럼 추가
            ,last_update_date = getdate()
	  FROM    scm_dnm_intransit di with(nolock)
	  JOIN    scm_mst_site ms with(nolock)
	  ON      di.to_scm_site_id = ms.scm_site_id
	  WHERE   ms.vmi_yn       = 'Y'
	  AND     ms.valid_yn     = 'Y'   
	  --AND     ms.division_id <> '82'  -- 20201028 ESS 'DAP' 처리 --  20200519 [PI 합의] ESS인 경우 VMI 라도 'DAP' 처리 안 함
	  
      -- 20220121 PJ20216891 to_site 가 AS 인 경우 incoterms 는 DAP 로 변경
	  UPDATE scm_dnm_intransit
      SET    incoterms        = 'DAP'
            ,final_incoterms  = 'DAP'  -- 20201007 PJ20202001  신규 컬럼 추가
            ,last_update_date = getdate()
	  FROM    scm_dnm_intransit di with(nolock)
	  JOIN    scm_mst_site ms with(nolock)
	  ON      di.to_scm_site_id = ms.scm_site_id
	  WHERE   ms.operation_group = 'W'
	  AND     ms.valid_yn        = 'Y' 

      -- project_code가 'N' 인 데이터 추가적으로 mapping 후 업데이트 2018.04.18
      UPDATE scm_dnm_intransit
      SET    project_code     = B.new_project_code 
            ,last_update_date = GETDATE()
      FROM   scm_dnm_intransit A
      INNER JOIN (SELECT  CASE WHEN ( -- MKT FCST를 입력한 Project가 하나인 경우
                                     SELECT COUNT(DISTINCT x.project_code)
                                     FROM   dm_pln_mkt_fcst x WITH(NOLOCK)
                                     WHERE  x.division_id = a.division_id
                                     AND    x.scm_site_id = a.to_scm_site_id
                                     AND    x.item_id     = a.item_id 
                                     AND    x.measure     = 'MKT_FCST'
                                     ) = 1  THEN (SELECT DISTINCT x.project_code
                                                  FROM   dm_pln_mkt_fcst x WITH(NOLOCK)
                                                  WHERE  x.division_id = a.division_id
                                                  AND    x.scm_site_id = a.to_scm_site_id
                                                  AND    x.item_id     = a.item_id
                                                  AND    x.measure     = 'MKT_FCST'
                                                  ) 
                               WHEN (  -- SITE_ITEM에 동일 SITE로 하나의 Project만 연결된 경우
                                     SELECT COUNT(DISTINCT w.project_code)
                                     FROM   scm_mst_site_item w WITH(NOLOCK)
                                     WHERE  w.division_id		= a.division_id
                                     AND    w.scm_site_id		= a.to_scm_site_id
                                     AND    a.item_id		    = w.item_id 
                                     AND    w.valid_yn			= 'Y'
                                     ) = 1  THEN (SELECT DISTINCT w.project_code
                                                  FROM   scm_mst_site_item w WITH(NOLOCK)
                                                  WHERE  w.division_id		 = a.division_id
                                                  AND    w.scm_site_id		 = a.to_scm_site_id
                                                  AND    a.item_id		     = w.item_id 
                                                  AND    w.valid_yn			 = 'Y'
                                                  )
                               WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우
                                     SELECT COUNT(DISTINCT w.project_code)
                                     FROM   scm_mst_site_item w WITH(NOLOCK)
                                     WHERE  w.division_id		 = a.division_id
                                     AND    a.item_id		     = w.item_id 
                                     AND    w.valid_yn			 = 'Y'
                                     ) = 1  THEN (SELECT DISTINCT w.project_code
                                                  FROM   scm_mst_site_item w WITH(NOLOCK)
                                                  WHERE  w.division_id		= a.division_id
                                                  AND    a.item_id		    = w.item_id 
                                                  AND    w.valid_yn			= 'Y'
                                                  )
                               ELSE project_code
                               END  new_project_code
                         ,company_id
                         ,plant_id
                         ,sales_org
                         ,division_id
                         ,project_code
                         ,distribution_channel
                         ,order_no
                         ,delivery_no
                         ,shipment_no
                         ,order_item_seq
                         ,item_id
                  FROM   scm_dnm_intransit a WITH(NOLOCK)
                  WHERE project_code = ''
                  OR    project_code = 'TBD'
                  ) B
      ON     A.company_id            = B.company_id
      AND    A.plant_id              = B.plant_id
      AND    A.sales_org             = B.sales_org
      AND    A.division_id           = B.division_id
      AND    A.project_code          = B.project_code
      AND    A.distribution_channel  = B.distribution_channel
      AND    A.order_no              = B.order_no
      AND    A.delivery_no           = B.delivery_no
      AND    A.shipment_no           = B.shipment_no
      AND    A.order_item_seq        = B.order_item_seq
      AND    A.item_id		         = B.item_id
      WHERE  B.new_project_code      != 'N'

      -- 2018.05.15   Fcst_type mapping 로직 변경
      UPDATE scm_dnm_intransit
      SET    fcst_type = B.fcst_type
      FROM   scm_dnm_intransit A WITH(NOLOCK)
      JOIN  (SELECT  mf.division_id
                    ,mf.project_code
                    ,sr.to_scm_site_id
                    ,mf.item_id
                    ,MAX(mf.fcst_type) fcst_type
             FROM  dm_pln_mkt_fcst mf WITH(NOLOCK)
             INNER JOIN scm_dnm_intransit sr WITH(NOLOCK)
             ON    mf.division_id        = sr.division_id
             AND   mf.project_code       = sr.project_code
             AND   mf.scm_site_id        = sr.to_scm_site_id
             AND   mf.item_id            = sr.item_id
             WHERE mf.fcst_type          = '-'
             AND   sr.sales_posting_date >= CONVERT(CHAR(8), DATEADD(mm, DATEDIFF(mm,0,getdate()) - 1, 0), 112)
			 AND   mf.measure      = 'MKT_FCST'  -- 2018.06.26   Kim Jihye
             AND   mf.qty > 0                    -- 2018.06.26   Kim Jihye
             GROUP BY mf.division_id,mf.project_code,sr.to_scm_site_id,mf.item_id
             HAVING count(distinct mf.fcst_type) = 1) B
      ON    A.division_id    = B.division_id
      AND   A.project_code   = B.project_code
      AND   A.to_scm_site_id = B.to_scm_site_id
      AND   A.item_id		 = B.item_id 
      WHERE A.fcst_type      = '-'
    
      -- 2018.05.15   Fcst_type mapping 로직 변경
      UPDATE scm_dnm_intransit
      SET    fcst_type   = 'SMC'
      WHERE  fcst_type   = '-'
 	    AND  division_id IN ( -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - HM JV 가상 사업부 추가 반영
								SELECT DIVISION_ID 
								  FROM SCM_MST_DIVISION DM WITH(NOLOCK)
								 WHERE DM.ATTRIBUTE3 = '81'  -- 자동차 사업부
								   AND DM.VALID_YN	 = 'Y'
							 ) 
      -- AND    division_id IN ('81', '81_UC');-- 20220425 PJ20216891 : GM JV 가상 Division 추가
   
      UPDATE scm_dnm_intransit
      SET    fcst_type = 'MPS'
      WHERE  fcst_type = '-'; 

	  ----------------------------------------------------------------
	  -- PI 요청으로 ESS : Sold-To : G260, Ship-To : G260건인것 제외 
	  ----------------------------------------------------------------
	  UPDATE scm_dnm_intransit
      SET    from_scm_site_id = NULL
           , to_scm_site_id   = NULL
      WHERE  division_id = '82' 
      AND    shipto_code = @np_shipto_value
      AND   (final_soldto_code = @np_shipto_value OR customer_code = @np_shipto_value)
	  ;

	  ----------------------------------------------------------------
	  -- PI 요청으로 Plant Issue Date Update : 2022.06.13 
	  ----------------------------------------------------------------
      UPDATE scm_dnm_intransit
      SET    plant_issue_date = b.plant_issue_date
      FROM   scm_dnm_intransit sr  WITH(NOLOCK)
      JOIN  (SELECT  delivery_no
                    ,item_id
                    ,MAX(plant_issue_date) plant_issue_date
             FROM   SSP_DNM_SHIP_RESULT_OWMS WITH(NOLOCK)
			 WHERE  lot_qty > 0
             GROUP BY delivery_no, item_id
            ) b
      ON     sr.delivery_no    LIKE '%' + b.delivery_no + '%'
      AND    sr.origin_item_id = b.item_id
	  WHERE  sr.plant_issue_date <> b.plant_issue_date
	  ;

      -- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
      SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_DNM_INTRANSIT_H     
      INSERT INTO scm_dnm_intransit_h (
               history_seq
              ,company_id
              ,plant_id
              ,customer_code
              ,customer_name
              ,from_scm_site_id
              ,from_site_item_mapping_yn
              ,to_scm_site_id
              ,to_site_item_mapping_yn
              ,project_code
              ,sales_org
              ,division_id
              ,distribution_channel
              ,order_no
              ,delivery_no
              ,shipment_no
              ,order_item_seq
              ,delivery_item_seq
              ,delivery_qty
              ,uom
              ,incoterms
			  ,origin_incoterms -- 2018.06.26
              ,item_id
			  ,origin_item_id --2018.07.02
              ,plant_issue_date
              ,sales_posting_date
              ,delivery_posting_date
              ,on_board_date
              ,eta_date
              ,pod_date
              ,f_dest_date
              ,transport_mode_erp
              ,transport_mode
              ,order_type_code
              ,order_type_name
              ,order_category_code
              ,order_category_name
              ,transport_route_code
              ,transport_route_name
              ,pod
              ,pod_desc
              ,etd_date
              ,shipto_code
              ,shipto_description
              ,storage_id
              ,cross_trade_flag
              ,corp_po_no
              ,corp_po_item_seq
              ,corp_gr_no
              ,corp_gr_date
              ,fcst_type
              ,valid_yn      
              -- 20201007 PJ20202001  신규 컬럼 추가
              ,final_soldto_code, final_soldto_name, final_incoterms        

              /*2023.01.20*/
              ,attribute6
              ,attribute7
              ,creation_date
              ,last_update_date
              ,created_by          
              ,last_updated_by  
              ,history_creation_date
             )
      SELECT  @n_history_seq
             ,A.*
             ,@v_batch_user
             ,@v_batch_user
             ,GETDATE()
      FROM   (SELECT  A.*
                     ,B.creation_date
                     ,B.last_update_date 
              FROM   (SELECT  /* scm_dnm_intransit_h */
                              company_id
                             ,plant_id
                             ,customer_code
                             ,customer_name
                             ,from_scm_site_id
                             ,from_site_item_mapping_yn
                             ,to_scm_site_id
                             ,to_site_item_mapping_yn
                             ,project_code
                             ,sales_org
                             ,division_id
                             ,distribution_channel
                             ,order_no
                             ,delivery_no
                             ,shipment_no
                             ,order_item_seq
                             ,delivery_item_seq
                             ,delivery_qty
                             ,uom
                             ,incoterms
							 ,origin_incoterms -- 2018.06.26
                             ,item_id
							 ,origin_item_id --2018.07.02
                             ,plant_issue_date
                             ,sales_posting_date
                             ,delivery_posting_date
                             ,on_board_date
                             ,eta_date
                             ,pod_date
                             ,f_dest_date
                             ,transport_mode_erp
                             ,transport_mode
                             ,order_type_code
                             ,order_type_name
                             ,order_category_code
                             ,order_category_name
                             ,transport_route_code
                             ,transport_route_name
                             ,pod
                             ,pod_desc
                             ,etd_date
                             ,shipto_code
                             ,shipto_description
                             ,storage_id
                             ,cross_trade_flag
                             ,corp_po_no
                             ,corp_po_item_seq
                             ,corp_gr_no
                             ,corp_gr_date
                             ,fcst_type
                             ,valid_yn
                             -- 20201007 PJ20202001  신규 컬럼 추가
                             ,final_soldto_code, final_soldto_name, final_incoterms
							 
                             /*2023.01.20*/
                             ,attribute6
                             ,attribute7
                      FROM   scm_dnm_intransit_temp$ WITH(NOLOCK)
                      EXCEPT
                      SELECT  /* scm_dnm_intransit_h */
                              company_id
                             ,plant_id
                             ,customer_code
                             ,customer_name
                             ,from_scm_site_id
                             ,from_site_item_mapping_yn
                             ,to_scm_site_id
                             ,to_site_item_mapping_yn
                             ,project_code
                             ,sales_org
                             ,division_id
                             ,distribution_channel
                             ,order_no
                             ,delivery_no
                             ,shipment_no
                             ,order_item_seq
                             ,delivery_item_seq
                             ,delivery_qty
                             ,uom
                             ,incoterms
							 ,origin_incoterms -- 2018.06.26
                             ,item_id
							 ,origin_item_id --2018.07.02
                             ,plant_issue_date
                             ,sales_posting_date
                             ,delivery_posting_date
                             ,on_board_date
                             ,eta_date
                             ,pod_date
                             ,f_dest_date
                             ,transport_mode_erp
                             ,transport_mode
                             ,order_type_code
                             ,order_type_name
                             ,order_category_code
                             ,order_category_name
                             ,transport_route_code
                             ,transport_route_name
                             ,pod
                             ,pod_desc
                             ,etd_date
                             ,shipto_code
                             ,shipto_description
                             ,storage_id
                             ,cross_trade_flag
                             ,corp_po_no
                             ,corp_po_item_seq
                             ,corp_gr_no
                             ,corp_gr_date
                             ,fcst_type
                             ,valid_yn
                             -- 20201007 PJ20202001  신규 컬럼 추가
                             ,final_soldto_code, final_soldto_name, final_incoterms   

                             /*2023.01.20*/
                             ,attribute6
                             ,attribute7
                      FROM   scm_dnm_intransit WITH(NOLOCK)
					 ) A 

                      INNER JOIN scm_dnm_intransit_temp$ B WITH(NOLOCK)
                      ON     A.company_id           =  B.company_id
                      AND    A.plant_id             =  B.plant_id
                      AND    A.customer_code        =  B.customer_code
                      AND    A.sales_org            =  B.sales_org  
                      AND    A.division_id          =  B.division_id
                      AND    A.distribution_channel =  B.distribution_channel
                      AND    A.order_no             =  B.order_no
                      AND    A.delivery_no          =  B.delivery_no
                      AND    A.shipment_no          =  B.shipment_no
                      AND    A.origin_item_id       =  B.origin_item_id  
                      AND    A.order_item_seq       =  B.order_item_seq
                      AND    A.delivery_item_seq    =  B.delivery_item_seq  
      ) A      
      
      -- HISTORY LOG    
      SET @n_log_count   = @@ROWCOUNT;
      SET @v_log_type    = 'HISTORY';
      SET @v_log_message = 'INSERT INTO scm_dnm_intransit_h';
      SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
      SET @d_event_date  = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      -- 처리 한 row 마킹
      UPDATE xif_erp_intransit_r_sn 
      SET    transfer_flag = 'Y' 
      WHERE  transfer_flag = 'P'

      SET @n_log_count   = @@ROWCOUNT;

      UPDATE scm_dnm_intransit
      SET    valid_yn  = 'Y'
      WHERE  valid_yn  = 'N'

      DROP TABLE dbo.scm_dnm_intransit_temp$;
      DROP TABLE dbo.xif_erp_intransit_r_sn_temp$;

      -- 순차적 호출을 위함
      EXEC PR_SCM_DNM_DELIVERY_TRACKING

      IF @@TRANCOUNT > 0
        BEGIN
          COMMIT WORK;
        END;

    END
    --COMMIT TRANSACTION
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
