/*
 * Program ID   : PR_SCM_DNM_EXFACTORY_RESULT
 * Description  : 출하실적 I/F 
 * Program History
 *===================================================================================================
 *   Date        In Charge     Description
 *===================================================================================================
 * 2017.12.21    Kim Jaejung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.26    Kim Jaejung   PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF 호출 로직 추가
 * 2018.05.14    Kim Jihye     soldto-shipto : sales_site_id 1:다 케이스 발생 대응 로직 수정 
 * 2018.05.24    Kim Jaejung   plant_issue_date 컬럼 추가 밎 로직 반영
 * 2018.06.01    Kim Jihye     주석 정리
 * 2018.06.01    Kim Jaejung   Transport_mode 로직 변경
 * 2018.06.11    Kim Jaejung   Transport_mode function 변경
 * 2018.06.21	 Kim Jaejung   From , To scm_site_id 관련 로직 수정(customer code 변경 시 대응)
 * 2018.06.25    Kim Jaejung   to_site 가 vmi 인 경우 incoterms 는 DAP 로 변경 (소형)
 * 2018.06.26    Kim Jaejung   origin_incoterms 컬럼 추가. 변경 전 incoterms 저장용 (vmi) 추후 주석제거
 * 2018.07.02    Kim Jaejung   소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 * 2018.07.20	 Kim Jaejung   소형 대표 ITEM_ID 변경 시 update 로직 적용 (소형)
 * 2018.09.07    Kim Jihye     Key 변경(SO_NO, SO_ITEM_SEQ, DELIVERY_NO, DELIVERY_PARTNO ) 및 EXFACTORY_STATUS 컬럼 추가
 *                             ※ DOC_TYPE : D10 생성, D20 공장출고, D30 운송중 재고, D40 매출, D90 삭제
 * 2018.09.17    Kim Jihye     Packer Site Mapping 로직 추가
 * 2018.11.12    KSG           To Site ID : PO 사용하는 조건에 Shipto Code 네자리 추가
 * 2019.08.05    juhlee        컬럼추가(6개) 반영  
                               ssp_type, confirm_id, plan_exfactory_date(출하예정일),
							   actual_delivery_date(납품일),intransit_date(운송중재고 이전 일자), factory_out_date(공장출하일자)
 * 2020.05.19   KSG            C20200519-000150 VMI-in Request CIP조건 입력 시 출하 계획이 D조건으로 생성되는 시스템 수정 요청드립니다 : ESS인 경우 VMI 라도 'DAP' 처리 안 함
 * 2020.08.26   KSG            C20200825-000168 ERP 출하 실적에 판가 정보 추가를 위한 IF 및 수집 프로그램 변경 요청의 건
 * 2020.10.28   KSG            ESS인 VMI : 'DAP' 처리
 * 2021.12.22   KSG            PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : 출하실적 비대상 Type의 QTY = 0 처리
 * 2022.01.21   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : SSP 정보를 사용한 Site Mapping
 * 2022.04.25   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division 추가
 * 2022.07.05   SSP Pjt.       attribute3에 SHIPMENT ID 적용
 * 2022.09.30	hwi1993		   [C20221004-000309] [SCM PI팀] ERP 피킹실적 VMI In plan(R+P) 실적 반영 요청 건, xif attr1, 2 에 들어오는데, scm 테이블에는 4, 5 로 넣음
   2022.12.07	hwi1993			[C20221207-000280] 피킹실적 필요없어서 원복함[기존 CSR : C20221004-000309]
 * 2023.01.04   SSP Pjt.       Plant 이전전기 실적의 경우(SO_NO = 'PLANT_MB1B') scm_dnm_exfactory_result.SSP_TYPE = 'MB1B' 세팅 
 * 2023/03/23	hrkim		   [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 * 2024.01.25   vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.10.28	vadabi5		   NERP) QA, 개발 DB 적용
 * 2025.03.04	hrkim		   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 
 *								1. NERP미전환 법인 법인간 이동 출하실적 To Site 매핑 로직 수정
 *								- NERP미전환 법인은 신/구코드 데이터 모두 발생 가능함 
 *								- 신 법인코드 기준으로도 company, division, operation_group 정보로 매핑 가능하도록 수정
 *								2. 전극 법인간 이동 from/to division이 다른 케이스 To Site 매핑 로직 추가
 ----------------------------------------------------------------------------------------------------
 */
CREATE PROCEDURE [dbo].[PR_SCM_DNM_EXFACTORY_RESULT]
AS


BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- LOG 용 변수 설정
  DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_EXFACTORY_RESULT';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  DECLARE @n_history_seq  BIGINT;
  DECLARE @v_ifseqno      NVARCHAR(50);

  DECLARE @v_WarrantyPlant NVARCHAR(8);
  SELECT @v_WarrantyPlant = dbo.FN_GET_LOOKUP_VALUE('PR_SCM_DNM_EXFACTORY_RESULT','WarrantyPlant')		--HQ05


  -- 시작 LOG
  SET @v_log_type = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  BEGIN TRY
  --BEGIN TRANSACTION
    BEGIN
       -- 인터페이스 테이블 처리 ROW UPDATE
      UPDATE xif_erp_exfactory_result_r_sn  
      SET    attribute15 = 'P'
      WHERE  ISNULL(attribute15,'N') = 'N'

      -------------------------------------------------------------------------
	  -- 20220425 PJ20216891 : GM JV 가상 Division 추가
	  -- 처리대상 Temp Table 생성
	  -------------------------------------------------------------------------
      IF OBJECT_ID('dbo.xif_erp_exfactory_result_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_exfactory_result_r_sn_temp$

		SELECT [IFSEQNO]
			  ,[SO_NO]
			  ,[SO_ITEM_SEQ]
			  ,[ORDER_TYPE]
			  ,[ORDER_TYPE_NAME]
			  ,[COMPANY]
			  ,[DIVISION]
			  ,[PLANT_ID]
			  ,[SLOC]
			  ,[ORDER_CREATE_DATE]
			  ,[PO_NO]
			  ,[BILLTO_CODE]
			  ,[BILTO_NAME]
			  ,[SHIPTO_CODE]
			  ,[SHIPTO_NAME]
			  ,[DELIVERY_DATE]
			  ,[DELIVERY_NO]
			  ,[DELIVERY_PARTNO]
			  ,[ITEM_ID]
			  ,[ITEM_NAME]
			  ,[ORDER_QTY]
			  ,[UOM]
			  ,[EXFACTORY_QTY]
			  ,[ON_BOARD_DATE]
			  ,[ETD]
			  ,[ETA]
			  ,[ACTUAL_EXFACTORY_DATE]
			  ,[SYSTEM_EXFACTORY_DATE]
			  ,[DOC_TYPE]
			  ,[DOC_SEQ]
			  ,[TRNF_DATE]
			  ,[TRNF_TIME]
			  ,[TRANSFER_FLAG]
			  ,[TRANSFER_DATE]
			  ,[CREATE_USER_ID]
			  ,[CREATE_DATE]
			  ,[MODIFY_USER_ID]
			  ,[MODIFY_DATE]
			  ,[ATTRIBUTE1]
			  ,[ATTRIBUTE2]
			  ,[ATTRIBUTE3]
			  ,[ATTRIBUTE4]
			  ,[ATTRIBUTE5]
			  ,[ATTRIBUTE6]
			  ,[ATTRIBUTE7]
			  ,[ATTRIBUTE8]
			  ,[ATTRIBUTE9]
			  ,[ATTRIBUTE10]
			  ,[ATTRIBUTE11]
			  ,[ATTRIBUTE12]
			  ,[ATTRIBUTE13]
			  ,[ATTRIBUTE14]
			  ,[ATTRIBUTE15]
			  ,[PROJECT_CD]
			  ,[TRANSPORT_MODE]
			  ,[INCOTERMS]
			  ,[PLANT_ISSUE_DATE]
			  ,IIF(SO_NO = 'PLANT_MB1B', 'MB1B', SSP_TYPE) AS SSP_TYPE
			  ,[CONFIRM_ID]
			  ,[PLAN_EXFACTORY_DATE]
			  ,[ACTUAL_DELIVERY_DATE]
			  ,[INTRANSIT_DATE]
			  ,[FACTORY_OUT_DATE]
			  ,[CURRENCY_CODE]
			  ,[NET_PRICE]
			  ,[SALES_AMOUNT]
			  ,[KRW_XRATE]
			  ,[SALES_KRW_AMOUNT]
      INTO   xif_erp_exfactory_result_r_sn_temp$
      FROM   xif_erp_exfactory_result_r_sn WITH(NOLOCK)
	  WHERE  attribute15 = 'P'
	 
	  -- GM JV : division Size 변경
      ALTER TABLE xif_erp_exfactory_result_r_sn_temp$ ALTER COLUMN division NVARCHAR(10) NULL;

	  -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
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
	     SET TGT.DIVISION = JP.DIVISION_ID_JV
	    FROM xif_erp_exfactory_result_r_sn_temp$ TGT
			INNER JOIN JV_PLANT JP WITH(NOLOCK)
				    ON JP.DIVISION_ID = TGT.DIVISION
				   AND JP.COMPANY_ID  = TGT.COMPANY

	  /*
	  -- GM JV division 처리
	  UPDATE xif_erp_exfactory_result_r_sn_temp$
	  SET    division = CASE WHEN company = 'G670' THEN '81_UC'
                             ELSE division
						END
	  */
      -------------------------------------------------------------------------
	  -------------------------------------------------------------------------
      
      -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
      DECLARE CUR_EXFACTORY CURSOR FOR
        SELECT ifseqno
        FROM   xif_erp_exfactory_result_r_sn_temp$   WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
        --FROM   xif_erp_exfactory_result_r_sn   WITH(NOLOCK)
        WHERE  attribute15 = 'P'
        GROUP BY ifseqno
        ORDER BY ifseqno ASC;

      -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
      IF OBJECT_ID('dbo.scm_dnm_exfactory_result_temp$') IS NOT NULL DROP TABLE scm_dnm_exfactory_result_temp$


      -- 데이터가 누적 되기 때문에, history 비교 시 변경 대상이 되는 row 로만 temp table 생성          
      SELECT * 
      INTO   scm_dnm_exfactory_result_temp$
      FROM   scm_dnm_exfactory_result WITH(NOLOCK)
      WHERE  company_id
            +division_id
            +order_item_seq
            +plant_id
            +item_id
			+origin_item_id --2018.07.02
            +delivery_no
            +order_no
            +doc_type
            +doc_seq IN (SELECT  company
                                +division
                                +ISNULL(so_item_seq, '-')
                                +plant_id
								+dbo.FN_GET_PACKER_PLAN_ITEM_ID(division, item_id)--2018.07.02
                                +item_id
                                +delivery_no
                                +ISNULL(so_no, '-')
                                +doc_type
                                +ISNULL(doc_seq, '-') 
                         --FROM   xif_erp_exfactory_result_r_sn   WITH(NOLOCK)
                         FROM   xif_erp_exfactory_result_r_sn_temp$   WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
                         WHERE  attribute15 = 'P');
 
      OPEN CUR_EXFACTORY;
      FETCH NEXT FROM CUR_EXFACTORY INTO @v_ifseqno ;
     
      WHILE (@@FETCH_STATUS = 0)
        BEGIN
          MERGE INTO scm_dnm_exfactory_result A
          USING (SELECT  /* PR_SCM_DNM_EXFACTORY_RESULT */
                         company company_id
                        ,division division_id
                        ,(SELECT ISNULL(MAX(site_id), '*') FROM dbo.scm_mst_plant_sn WITH(NOLOCK) WHERE plant_id = a.plant_id) AS site_id
                        ,plant_id
                        ,ISNULL(so_no, '-') order_no
                        ,po_no
                        ,project_cd project_code
                        ,item_id origin_item_id --2018.07.20
                        ,order_qty
                        ,billto_code soldto_code
                        ,bilto_name soldto_name
                        ,shipto_name
                        ,shipto_code 
                        ,ISNULL(so_item_seq, '-') order_item_seq
                        ,order_type order_type_code
                        ,order_type_name
                        ,sloc storage_id
                        ,CASE WHEN ISDATE(order_create_date) = 1 THEN order_create_date 
                              ELSE '' 
                              END  order_create_date
                        ,delivery_no
                        ,CASE WHEN ISDATE(delivery_date) = 1 THEN delivery_date 
                              ELSE '' 
                              END  delivery_posting_date 
                        ,delivery_partno delivery_item_seq
                        ,item_name
                        ,uom
                        ,ISNULL(CAST(exfactory_qty AS NUMERIC(20,10)),0) AS exfactory_qty  -- 뒤에서 일부 0 처리
                        ,CASE WHEN ISDATE(on_board_date) = 1 THEN on_board_date 
                              ELSE '' 
                              END  on_board_date
                         ,CASE WHEN ISDATE(etd)  = 1 THEN etd 
                              ELSE '' 
                              END  etd_date
                        ,CASE WHEN ISDATE(eta)  = 1 THEN eta 
                              ELSE '' 
                              END  eta_date
                        ,CASE WHEN ISDATE(actual_exfactory_date)  = 1 THEN actual_exfactory_date 
                              ELSE '' 
                              END  actual_exfactory_date 
                        ,CASE WHEN ISDATE(system_exfactory_date)  = 1 THEN system_exfactory_date 
                              ELSE '' 
                              END  system_exfactory_date
                        ,CASE WHEN ISDATE(plant_issue_date)  = 1 THEN plant_issue_date -- 2018. 5.  24
                              ELSE '' 
                              END  plant_issue_date 
                        ,CASE WHEN ISDATE(plant_issue_date) = 1 THEN plant_issue_date  -- 2018. 5.  24
                              ELSE CASE WHEN ISDATE(actual_exfactory_date) = 1 THEN actual_exfactory_date
                                        ELSE CASE WHEN ISDATE(system_exfactory_date) = 1 THEN system_exfactory_date
                                                  ELSE '' 
                                                  END
                                        END
                              END  exfactory_date
                        ,'-' doc_type              -- 2018.09.07
                        ,'-' doc_seq               -- 2018.09.07
						,doc_type exfactory_status -- 2018.09.07
                        --,dbo.fn_scm_sys_nvl(dbo.fn_get_lookup_code_desc('TRANSPORT_MODE_ERP',transport_mode),'-') transport_mode -- 2018. 6. 7
						,dbo.fn_get_transport_mode_erp(transport_mode) transport_mode --2018.06.11
						,transport_mode transport_mode_erp -- 2018. 6. 7
                        ,incoterms  
						,dbo.FN_GET_PACKER_PLAN_ITEM_ID(division, item_id) item_id --2018.07.02 , 2018.07.20
						,ssp_type               --2019.08.05
						,confirm_id             --2019.08.05
						,plan_exfactory_date    --2019.08.05
						,actual_delivery_date   --2019.08.05
						,intransit_date         --2019.08.05
						,factory_out_date       --2019.08.05 
						,currency_code          --2020.08.26 C20200825-000168 추가
						,net_price              --2020.08.26 C20200825-000168 추가
						,sales_amount           --2020.08.26 C20200825-000168 추가
						,krw_xrate              --2020.08.26 C20200825-000168 추가
						,sales_krw_amount       --2020.08.26 C20200825-000168 추가
						,ISNULL(CAST(exfactory_qty AS NUMERIC(20,10)),0)  AS attribute1 -- Original exfactory_qty -- 20211222  PJ20214907
						,(SELECT TOP 1  ISNULL(I.SCP_OPERATION_GROUP,'')
                          FROM   DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
                          WHERE  1=1
                          AND    I.DIVISION_ID          = a.division
                          AND    I.ITEM_ID              = a.ITEM_ID
                         ) AS attribute2 -- OPERATION_GROUP
						 ,attribute3
                 --FROM   xif_erp_exfactory_result_r_sn   A WITH(NOLOCK)
                 FROM   xif_erp_exfactory_result_r_sn_temp$ A WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
                 WHERE 1=1
                 AND   A.ifseqno     = @v_ifseqno
				 AND   A.attribute15 = 'P'
                 ) B
          ON    A.company_id        =  B.company_id
          AND   A.division_id       =  B.division_id
          AND   A.site_id           =  B.site_id
          AND   A.plant_id          =  B.plant_id
          --AND   A.doc_type          =  B.doc_type 2018.09.07
          --AND   A.doc_seq           =  B.doc_seq 2018.09.07
          AND   A.order_no          =  B.order_no
          AND   A.order_item_seq    =  B.order_item_seq
          AND   A.delivery_no       =  B.delivery_no
          AND   A.delivery_item_seq =  B.delivery_item_seq
          AND   A.origin_item_id    =  B.origin_item_id --2018.07.02 , 2018.07.20
          
          
          WHEN MATCHED THEN
          UPDATE 
          SET    A.po_no                  =  B.po_no
                ,A.project_code           =  B.project_code
                ,A.order_qty              =  B.order_qty
                ,A.soldto_code            =  B.soldto_code
                ,A.soldto_name            =  B.soldto_name
                ,A.shipto_name            =  B.shipto_name
                ,A.shipto_code            =  B.shipto_code
                ,A.order_type_code        =  B.order_type_code
				,A.from_scm_site_id		  =  NULL -- 2018.06.21
				,A.to_scm_site_id		  =  NULL -- 2018.06.21
                ,A.order_type_name        =  B.order_type_name
                ,A.storage_id             =  B.storage_id
                ,A.order_create_date      =  B.order_create_date
                ,A.delivery_posting_date  =  B.delivery_posting_date
				,A.item_id				  =  B.item_id -- 2018.07.20
                ,A.item_name              =  B.item_name
				,A.exfactory_status       =  B.exfactory_status -- 2018.09.07
                ,A.uom                    =  B.uom
                ,A.exfactory_qty          =  B.exfactory_qty
                ,A.on_board_date          =  B.on_board_date
                ,A.etd_date               =  B.etd_date
                ,A.eta_date               =  B.eta_date
                ,A.actual_exfactory_date  =  B.actual_exfactory_date
                ,A.system_exfactory_date  =  B.system_exfactory_date
                ,A.plant_issue_date       =  B.plant_issue_date -- 2018. 5.  24
                ,A.exfactory_date         =  B.exfactory_date
                ,A.transport_mode         =  B.transport_mode  -- 2018. 5.  24
				,A.transport_mode_erp	  =  B.transport_mode_erp  -- 2018. 6. 7
                ,A.incoterms              =  B.incoterms -- 2018. 5.  24
				,A.origin_incoterms       =  B.incoterms -- 2018.06.26
				,A.ssp_type               =  B.ssp_type             --2019.08.05
				,A.confirm_id             =  B.confirm_id           --2019.08.05
				,A.plan_exfactory_date    =  B.plan_exfactory_date  --2019.08.05
				,A.actual_delivery_date   =  B.actual_delivery_date --2019.08.05
				,A.intransit_date         =  B.intransit_date       --2019.08.05
				,A.factory_out_date       =  B.factory_out_date     --2019.08.05 
                ,A.valid_yn               =  'Y'
                ,A.last_update_date       =  GETDATE()
				,A.currency_code          = B.currency_code     --2020.08.26 C20200825-000168 추가
				,A.net_price              = B.net_price         --2020.08.26 C20200825-000168 추가
				,A.sales_amount           = B.sales_amount      --2020.08.26 C20200825-000168 추가
				,A.krw_xrate              = B.krw_xrate         --2020.08.26 C20200825-000168 추가
				,A.sales_krw_amount       = B.sales_krw_amount  --2020.08.26 C20200825-000168 추가
                ,A.attribute1             = B.attribute1 -- Original exfactory_qty -- 20211222  PJ20214907
                ,A.attribute2             = B.attribute2 -- OPERATION_GROUP
				,A.attribute3             = B.attribute3 -- SHIPMENT ID
                      
          WHEN NOT MATCHED THEN
          INSERT (company_id
                 ,division_id
                 ,site_id
                 ,plant_id
                 ,order_no
                 ,po_no
                 ,project_code
                 ,item_id
				 ,origin_item_id --2018.07.02
				 ,exfactory_status -- 2018.09.07
                 ,order_qty
                 ,soldto_code
                 ,soldto_name
                 ,shipto_name
                 ,shipto_code
                 ,order_item_seq
                 ,order_type_code
                 ,order_type_name
                 ,storage_id
                 ,order_create_date
                 ,delivery_no
                 ,delivery_posting_date
                 ,delivery_item_seq
                 ,item_name
                 ,uom
                 ,exfactory_qty
                 ,on_board_date
                 ,etd_date
                 ,eta_date
                 ,actual_exfactory_date
                 ,system_exfactory_date
                 ,plant_issue_date -- 2018. 5.  24
                 ,exfactory_date
                 ,transport_mode -- 2018. 5.  24
				 ,transport_mode_erp -- 2018. 6. 7
                 ,incoterms -- 2018. 5.  24
				 ,origin_incoterms -- 2018.06.26
				 ,ssp_type               --2019.08.05 -- SSP Type
				 ,confirm_id             --2019.08.05 -- Confirm ID in SSP
				 ,plan_exfactory_date    --2019.08.05 -- 출하예정일
				 ,actual_delivery_date   --2019.08.05 -- 납품일
				 ,intransit_date         --2019.08.05 -- 운송중재고 이전 일자
				 ,factory_out_date       --2019.08.05 -- 공장출하일자
                 ,doc_type
                 ,doc_seq
                 ,valid_yn  
                 ,created_by      
                 ,creation_date    
                 ,last_updated_by    
                 ,last_update_date    
				 ,currency_code          --2020.08.26 C20200825-000168 추가
				 ,net_price              --2020.08.26 C20200825-000168 추가
				 ,sales_amount           --2020.08.26 C20200825-000168 추가
				 ,krw_xrate              --2020.08.26 C20200825-000168 추가
				 ,sales_krw_amount       --2020.08.26 C20200825-000168 추가
				 ,attribute1             -- 20211222  PJ20214907
				 ,attribute2             -- OPERATION_GROUP
				 ,attribute3             -- SHIPMENT ID
                 )
          VALUES (B.company_id
                 ,B.division_id
                 ,B.site_id
                 ,B.plant_id
                 ,B.order_no
                 ,B.po_no
                 ,B.project_code
                 ,B.item_id --2018.07.02 , 2018.07.20
				 ,B.origin_item_id --2018.07.02 , 2018.07.20
				 ,B.exfactory_status -- 2018.09.07
                 ,B.order_qty
                 ,B.soldto_code
                 ,B.soldto_name
                 ,B.shipto_name
                 ,B.shipto_code
                 ,B.order_item_seq
                 ,B.order_type_code
                 ,B.order_type_name
                 ,B.storage_id
                 ,B.order_create_date
                 ,B.delivery_no
                 ,B.delivery_posting_date
                 ,B.delivery_item_seq
                 ,B.item_name
                 ,B.uom
                 ,B.exfactory_qty
                 ,B.on_board_date
                 ,B.etd_date
                 ,B.eta_date
                 ,B.actual_exfactory_date
                 ,B.system_exfactory_date
                 ,B.plant_issue_date -- 2018. 5.  24
                 ,B.exfactory_date
                 ,B.transport_mode -- 2018. 5.  24
				 ,B.transport_mode_erp -- 2018. 6. 7
                 ,B.incoterms -- 2018. 5.  24 
				 ,B.incoterms -- 2018.06.26
				 ,B.ssp_type               --2019.08.05
				 ,B.confirm_id             --2019.08.05
				 ,B.plan_exfactory_date    --2019.08.05
				 ,B.actual_delivery_date   --2019.08.05
				 ,B.intransit_date         --2019.08.05
				 ,B.factory_out_date       --2019.08.05 
                 ,B.doc_type
                 ,B.doc_seq
                 ,'Y'
                 ,@v_batch_user 
                 ,GETDATE()      
                 ,@v_batch_user
                 ,GETDATE()
				 ,B.currency_code          --2020.08.26 C20200825-000168 추가
				 ,B.net_price              --2020.08.26 C20200825-000168 추가
				 ,B.sales_amount           --2020.08.26 C20200825-000168 추가
				 ,B.krw_xrate              --2020.08.26 C20200825-000168 추가
				 ,B.sales_krw_amount       --2020.08.26 C20200825-000168 추가
				 ,B.attribute1             -- 20211222  PJ20214907
				 ,B.attribute2             -- OPERATION_GROUP
				 ,B.attribute3             --SHIPMENT ID
                 )  
          ;
          -----------------------------------------------------------
          -- Merge LOG
          -----------------------------------------------------------
          SET @v_log_type = 'APPEND';
          SET @v_log_message = 'MERGE INTO SCM_DNM_EXFACTORY_RESULT';
          SET @v_description = 'ifseqno = ' + @v_ifseqno;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------  
 
          FETCH NEXT FROM CUR_EXFACTORY INTO  @v_ifseqno

        END
    
      CLOSE CUR_EXFACTORY;
      DEALLOCATE CUR_EXFACTORY; 


      -- project_code가 'N' 인 데이터 추가적으로 mapping 후 업데이트
      UPDATE scm_dnm_exfactory_result
      SET    project_code     = B.new_project_code 
            ,last_update_date = GETDATE()
      FROM   scm_dnm_exfactory_result A
      INNER JOIN (SELECT CASE WHEN ( -- MKT FCST를 입력한 Project가 하나인 경우
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
                                                 WHERE  w.division_id		= a.division_id
                                                 AND    w.scm_site_id		= a.to_scm_site_id
                                                 AND    a.item_id		    = w.item_id
                                                 AND    w.valid_yn			= 'Y'
                                                 )
                              WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우
                                    SELECT COUNT(DISTINCT w.project_code)
                                    FROM   scm_mst_site_item w WITH(NOLOCK)
                                    WHERE  w.division_id		= a.division_id
                                    AND    a.item_id		    = w.item_id
                                    AND    w.valid_yn			= 'Y'
                                    ) = 1  THEN (SELECT DISTINCT w.project_code
                                                 FROM   scm_mst_site_item w WITH(NOLOCK)
                                                 WHERE  w.division_id		= a.division_id
                                                 AND    a.item_id		    = w.item_id
                                                 AND    w.valid_yn			= 'Y'
                                                 )
                              ELSE project_code
                              END  new_project_code
                         ,creation_date
                         ,company_id
                         ,division_id
                         ,site_id
                         ,plant_id
                         ,doc_type
                         ,doc_seq
                         ,order_no
                         ,order_item_seq
                         ,delivery_no
                         ,delivery_item_seq
                         ,item_id
                         ,project_code
                  FROM   scm_dnm_exfactory_result a WITH(NOLOCK)
                  WHERE  project_code IS NULL
                  ) B
      ON  A.creation_date      = B.creation_date
      AND A.company_id         = B.company_id
      AND A.division_id        = B.division_id
      AND A.site_id            = B.site_id
      AND A.plant_id           = B.plant_id
      AND A.doc_type           = B.doc_type
      AND A.doc_seq            = B.doc_seq
      AND A.order_no           = B.order_no
      AND A.delivery_no        = B.delivery_no
      AND A.delivery_item_seq  = B.delivery_item_seq
      AND A.item_id		       = B.item_id
      WHERE B.new_project_code!= 'N'


      /*===== From Site Mapping Start =======================================================================*/
      	  
      /*======20220121 PJ20216891 SSP 정보를 사용한 From/To Site Mapping : START===========================*/

	  -- 1. confirm_id 를사용한 From Site Mapping
      UPDATE scm_dnm_exfactory_result
      SET    from_scm_site_id = B.from_site 
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK) 
      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.confirm_id, MAX(sc.from_site) from_site
            FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)
            WHERE  1=1
            --AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
            GROUP BY sc.division_id, sc.confirm_id
           ) b 
      ON     A.division_id = b.division_id
      AND    A.confirm_id  = b.confirm_id
      WHERE  ISNULL(a.from_scm_site_id, '') = '';

      /*======20220121 SSP 정보를 사용한 From/To Site Mapping : END===========================*/
	  
      -- 1 from_scm_site_id Mapping : 
      UPDATE scm_dnm_exfactory_result
      SET    from_scm_site_id   =  C.scm_site_id
            ,last_update_date   = GETDATE()
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK) 
	  JOIN  (SELECT division_id, plant_id, operation_group
                   ,max(scm_site_id) scm_site_id
             FROM   scm_mst_site
             WHERE  site_type = 'PLANT'
             AND    valid_yn  = 'Y'
             GROUP BY division_id, plant_id, operation_group
             HAVING count(distinct scm_site_id) = 1) C
      ON     A.division_id = C.division_id
      AND    A.plant_id    = C.plant_id
      AND    CASE WHEN A.plant_id = @v_WarrantyPlant THEN 'W'
	              ELSE A.attribute2
             END           = C.operation_group
      WHERE  ISNULL(A.from_scm_site_id, '') = ''

      -- 1. from_scm_site_id Mapping 2018.04.10   Kim Jaejung 
      UPDATE scm_dnm_exfactory_result
      --SET    from_scm_site_id   =  dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id,dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id,A.item_id))
      SET    from_scm_site_id   =  dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, A.attribute2)
            ,last_update_date   = GETDATE()
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK) 
      WHERE  ISNULL(A.from_scm_site_id, '') = ''

      -- 2. from_scm_site_id Mapping : 전극이 A040 창고에서 출하되는 경우 2018.04.10   Kim Jaejung 
      UPDATE scm_dnm_exfactory_result
      SET    from_scm_site_id = B.segment2 
            ,last_update_date = GETDATE()
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK) 
      JOIN  (SELECT segment1
                   ,segment2
             FROM   scm_adm_lookup_master_detail A WITH(NOLOCK) 
             WHERE  lookup_type = 'ELECTRODE_SHIP_SITE' 
             AND valid_yn       = 'Y' 
             AND segment3       = '*'
             ) B
       ON    A.plant_id   = B.segment1
       JOIN (SELECT  DISTINCT 
                     division_id
                    ,item_id
                    ,CASE ISNULL(O.operation_group_id,'') WHEN 'S' THEN 'E' ELSE O.operation_group_id END operation_group_id
             FROM   scm_mst_item_sn              I WITH(NOLOCK),
                    scm_mst_item_class_level_sn  O WITH(NOLOCK)
             WHERE  1=1
             AND    I.item_class           LIKE O.level_id+'%'
             AND    O.operation_group_id   IS NOT NULL
             AND    O.use_flag             = 'Y'
             AND    O.operation_group_id   IN('S','E')
             ) C
      ON     A.division_id = C.division_id
      AND    A.item_id     = C.item_id
      WHERE  ISNULL(A.from_scm_site_id, '') = ''
     
      -- 3. from_scm_site_id Mapping : Pack 이 A050 에서 출하되는 경우 (외주 Packer) 2018.04.10   Kim Jaejung 
      UPDATE scm_dnm_exfactory_result
      SET    from_scm_site_id = B.scm_site_id 
            ,last_update_date = GETDATE()
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK) 
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
      ON    A.division_id	= B.division_id
      AND   A.item_id       = B.item_id
      WHERE ISNULL(A.from_scm_site_id, '') = ''
    
      /*===== From Site Mapping End ==========================================================================*/
    
    
      /*===== Sales Site Mapping Start =======================================================================*/
      	  
      /*======20220121 PJ20216891 SSP 정보를 사용한 To Site Mapping : START===========================*/

	  -- 1. confirm_id 를사용한 To Site Mapping
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id = B.to_site 
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK) 
      INNER JOIN 
	       ( 
	        SELECT sc.division_id, sc.confirm_id, MAX(ISNULL(md.segment1, sc.to_site)) AS to_site
                 FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)

                      LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                      ON   sc.division_id = md.segment3
                      AND  sc.to_site     = md.segment2
                      AND  md.lookup_type = 'AS_SITE_PLANT'
                      AND  md.valid_yn    = 'Y'

                 WHERE  1=1
                 --AND    fcst_type IN ('WS', 'WSF', 'AS', 'ASF')
				 GROUP BY sc.division_id, sc.confirm_id
           ) b 
      ON    a.division_id = b.division_id
      AND   a.confirm_id  = b.confirm_id
      WHERE ISNULL(a.to_scm_site_id, '') = '';
	  
      /*======20220121 SSP 정보를 사용한 To Site Mapping : END===========================*/

      /*===== 법인간 이동 ====================================================================================*/
      -- 1. Sales Site Mapping : 법인간 이동 - 법인 PO 참조하여 도착 Plant 에 site 가 1개 인 경우
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id   = c.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '1. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK)
      JOIN   scm_dnm_mat_po B WITH(NOLOCK)
      ON     A.company_id		= B.vendor_code
      AND    A.order_no			= B.po_no
      AND    A.order_item_seq	= B.po_item_seq
      AND    A.soldto_code		= B.company_id
      AND    A.item_id		    = B.item_id
      JOIN  (SELECT  plant_id
                    ,max(scm_site_id) scm_site_id
             FROM   scm_mst_site
             WHERE  site_type = 'PLANT'
             AND    valid_yn  = 'Y'
             GROUP BY plant_id
             HAVING count(distinct scm_site_id) = 1) C
      ON     B.plant_id = C.plant_id
      WHERE  len(A.soldto_code)           = 4
      AND    len(A.shipto_code)           = 4 -- 20181112 조건 추가
      AND    len(A.order_no)              > 0
      AND    isnull(A.to_scm_site_id, '') = '';

      -- 2. Sales Site Mapping : 법인간 이동 - 법인 PO 참조하여 전극인 경우 Cell 사이트로, 그 외는 Pack 사이트로 
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id   = c.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '2. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK)
      JOIN   scm_dnm_mat_po B WITH(NOLOCK)
      ON     A.company_id     = B.vendor_code
      AND    A.order_no       = B.po_no
      AND    A.order_item_seq = B.po_item_seq
      AND    A.soldto_code    = B.company_id
      AND    A.item_id		  = B.item_id
      JOIN  (SELECT  plant_id
                    ,scm_site_id
                    ,operation_group
             FROM   scm_mst_site
             WHERE  site_type = 'PLANT'
             AND    valid_yn  = 'Y') C
      ON     B.plant_id = C.plant_id
      --AND    CASE dbo.FN_GET_ITEM_OPERATION_GROUP (a.division_id, a.item_id) WHEN 'E' THEN 'A'
      --                                                                       WHEN 'A'  THEN 'P'
      --                                                                       END = C.operation_group
      AND    CASE A.attribute2 WHEN 'E' THEN 'A'
                               WHEN 'A' THEN 'P'
             END = C.operation_group
      WHERE  LEN(A.soldto_code) = 4
      AND    len(A.shipto_code) = 4 -- 20181112 조건 추가
      AND    LEN(A.order_no)    > 0
      AND    ISNULL(A.to_scm_site_id, '') = '';
  
	/*-------------------- 2025.03.04 법인간 이동 company, division, operation 기준 사이트 매핑 로직 보완 Start							--------------*/ 
	/*-------------------- 2025.03.04 현재 NERP 전환 안된 NJ법인등의 출하실적이 NERP에서 신코드 기준으로 들어오는 데이터 존재			--------------*/ 
	/*-------------------- 2025.03.04 현재 NERP 전환 안된 NJ법인등의 출하실적 신 법인코드 기준으로 SCM site 정보 매핑 가능하도록 수정	--------------*/ 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 법인간 이동  매핑 case 3 - #scp_mst_site_for_case3' 
	------------------------------------------------------------------------------------------------------------------
	if object_id('tempdb..#scp_mst_site_for_case3') is not null drop table #scp_mst_site_for_case3
	;with scm_site as ( 
		SELECT  company_id
				,division_id
				,operation_group
				,max(scm_site_id) scm_site_id
		 FROM   scm_mst_site
		 WHERE  site_type = 'PLANT'
		 AND    osp_yn    = 'N'
		 AND    valid_yn  = 'Y'
		 GROUP BY company_id, division_id, operation_group
		 HAVING  count(distinct scm_site_id) = 1
	)
	select *
	  into #scp_mst_site_for_case3
	from (  -- 현재 NERP 전환 기준 (구코드+신코드) 
			select *
			 from scm_site c
			union -- 중복이 있으면 안됨.
			-- NERP 전환이 안된 구코드의 신코드 기준 데이터 추가 
			select distinct n.new_value1 as compnay_id  
				  ,c.division_id
				  ,c.operation_group
				  ,c.scm_site_id 
			from scm_site c  
				 inner join NERP_CONV_MASTER  n with (nolock)
						 on n.codetype = 'company_id'
						and n.old_value1 = c.company_id
		) a 

      -- 3. Sales Site Mapping : 법인간 이동 - Compay, Division, Operation 기준으로 Site 가 1개인 경우 - C2018.04.11 추가
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id   = b.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '3. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK)    
      JOIN  #scp_mst_site_for_case3 B		-- 2025.03.04 현재 NERP 전환 안된 NJ법인등의 출하실적 신 법인코드 기준으로 SCM site 정보 매핑 가능하도록 수정
      ON     a.soldto_code = b.company_id
      AND    a.division_id = b.division_id
      AND    CASE A.attribute2 WHEN 'E' THEN 'A'
                               WHEN 'A' THEN 'P'
             END = b.operation_group
      WHERE  len(A.soldto_code) = 4
      AND    len(A.shipto_code) = 4 -- 20181112 조건 추가
      AND    isnull(A.to_scm_site_id, '') = '';

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전극 법인간 이동 - from/to division이 다른 품목 정보 추출' 
	-- 2025.03.05 전극 법인간 이동 from/to division이 다른 경우 매핑 추가 
	------------------------------------------------------------------------------------------------------------------
	if object_id('tempdb..#elec_from_to_division') is not null drop table #elec_from_to_division
	select b.child_division_id	as from_division_id
		 , b.child_item_id		as from_item_id 
		 , max(b.division_id)	as to_division_id
	into  #elec_from_to_division
	from scm_mst_bom_sn  b with(nolock)
		 inner join scp_mst_final_item p with(nolock)
				  on p.division_id  = b.division_id
				 and p.item_id		= b.model_id
				 and p.operation_group = 'A'
		 inner join scp_mst_final_item c with(nolock)
				  on c.division_id  = b.child_division_id
				 and c.item_id		= b.child_item_id
				 and c.operation_group = 'E'
	where 1=1
	  and b.division_id != b.child_division_id 
	group by b.child_division_id, b.child_item_id
	having count(distinct b.division_id) = 1 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 3.1 sales site mapping - 전극 division 이동' 
	-- 2025.03.05 전극 법인간 이동 from/to division이 다른 경우 매핑 추가 
	------------------------------------------------------------------------------------------------------------------
	 UPDATE	 A
      SET    A.to_scm_site_id   = b.scm_site_id
            ,A.last_update_date = getdate()
			,A.last_updated_by  = N'3.1 sales site mapping - 전극'
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK)
			 INNER JOIN #elec_from_to_division e
					 ON e.from_division_id	= a.division_id
					AND e.from_item_id		= a.item_id
			 INNER JOIN #scp_mst_site_for_case3 b
					ON  b.company_id		= a.soldto_code
				   AND	b.division_id		= e.to_division_id
				   AND	b.operation_group	= 'A' -- Cell 
      WHERE  len(A.soldto_code) = 4
      AND    len(A.shipto_code) = 4 -- 20181112 조건 추가
	  AND    A.attribute2		= 'E' -- 전극 
      AND    isnull(A.to_scm_site_id, '') = ''

	print  convert(varchar(30), getdate(), 121) + N' 3.1 sales site mapping - 전극 division 이동 - End' 

	/*-------------------- 2025.03.04 법인간 이동 company, division, operation 기준 사이트 매핑 로직 보완 End							--------------*/ 
	/*-------------------- 2025.03.04 법인간 이동 company, division, operation 기준 사이트 매핑 로직 보완 End							--------------*/ 

	/* 2025.03.04 변경전 소스 -- start 
      -- 3. Sales Site Mapping : 법인간 이동 - Compay, Division, Operation 기준으로 Site 가 1개인 경우 - C2018.04.11 추가
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id   = b.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '3. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK)    
      JOIN  (SELECT  company_id
                    ,division_id
                    ,operation_group
                    ,max(scm_site_id) scm_site_id
             FROM   scm_mst_site
             WHERE  site_type = 'PLANT'
             AND    osp_yn    = 'N'
             AND    valid_yn  = 'Y'
             GROUP BY company_id, division_id, operation_group
             HAVING  count(distinct scm_site_id) = 1) B
      ON     a.soldto_code = b.company_id
      AND    a.division_id = b.division_id
      --AND    CASE dbo.FN_GET_ITEM_OPERATION_GROUP (a.division_id, a.item_id) WHEN 'E' THEN 'A'
      --                                                                       WHEN 'A'  THEN 'P'
      --                                                                       END = b.operation_group
      AND    CASE A.attribute2 WHEN 'E' THEN 'A'
                               WHEN 'A' THEN 'P'
             END = b.operation_group
      WHERE  len(A.soldto_code) = 4
      AND    len(A.shipto_code) = 4 -- 20181112 조건 추가
      AND    isnull(A.to_scm_site_id, '') = '';
	2025.03.04 변경전 소스 End */
      
      /*===== 판매 사이트 ====================================================================================*/
      -- 4-1. Sales Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping - Packer Site, 2018.09.17
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id   =  B.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '4-1. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK)
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
      AND    B.soldto_code =  A.soldto_code
      AND    B.shipto_code =  A.shipto_code
      WHERE  ISNULL(A.to_scm_site_id, '') = '';

      -- 4-2. Sales Site Mapping : Soldto, Shipto 가 동일한 경우 Mapping - Sales Site
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id   =  B.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '4-2. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result A WITH(NOLOCK)
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
      AND    B.soldto_code =  A.soldto_code
      AND    B.shipto_code =  A.shipto_code
      WHERE  ISNULL(A.to_scm_site_id, '') = '';

      -- 5.Sales Site Mapping : project-item-customer 기준으로 하나의 site 만 등록된 경우 Mapping - 2018.05.14   Kim Jihye 
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id = b.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '5. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result sr WITH(NOLOCK) 
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
              WHERE  site.valid_yn = 'Y'
              AND    item.valid_yn = 'Y'
              AND    site.site_type = 'SALES'
              GROUP BY item.division_id, item.project_code, item.item_id, cus.soldto_code, cus.shipto_code
              HAVING   count(distinct item.scm_site_id) = 1
              ) b
      ON     sr.division_id		= b.division_id
      AND    sr.project_code	= b.project_code
      AND    sr.item_id			= b.item_id
      AND    sr.soldto_code		= b.soldto_code
      AND    sr.shipto_code		= b.shipto_code
      WHERE  ISNULL(sr.to_scm_site_id, '') = ''
      AND    LEN(sr.soldto_code) != 4 
      AND    LEN(sr.shipto_code) != 4
	  AND    sr.division_id      != '40'; -- 2018.09.07 소형 제외

	  -- 6. Sales Site Mapping : project code-Item 기준으로 하나의 site 만 등록된 경우 Mapping - 2018.05.14   Kim Jihye 
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id = b.scm_site_id
            ,last_update_date = GETDATE()
			,last_updated_by  = '6. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result sr WITH(NOLOCK) 
      JOIN   (SELECT  item.division_id
                     ,item.project_code
                     ,item_id
                     ,max(item.scm_site_id) scm_site_id
              FROM   scm_mst_site site WITH(NOLOCK) 
              JOIN   scm_mst_site_item item WITH(NOLOCK) 
              ON     site.division_id = item.division_id
              AND    site.scm_site_id = item.scm_site_id
              WHERE  site.valid_yn = 'Y'
              AND    item.valid_yn = 'Y'
              AND    site.site_type = 'SALES'
              GROUP BY item.division_id, item.project_code, item.item_id
              HAVING   count(distinct item.scm_site_id) = 1
              ) b
      ON     sr.division_id			= b.division_id
      AND    sr.project_code		= b.project_code
      AND    sr.item_id		        = b.item_id
      WHERE  ISNULL(sr.to_scm_site_id, '') = ''
      AND    LEN(sr.soldto_code) != 4 
      AND    LEN(sr.shipto_code) != 4
	  AND    sr.division_id      != '40'; -- 2018.09.07 소형 제외

      -- 7. Sales Site Mapping : project code 기준으로 하나의 site 만 등록된 경우 Mapping
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id   = b.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '7. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result sr  WITH(NOLOCK)
      JOIN  (SELECT  item.division_id
                    ,item.project_code
                    ,max(item.scm_site_id) scm_site_id
             FROM   scm_mst_site site  WITH(NOLOCK)
             JOIN   scm_mst_site_item item  WITH(NOLOCK)
             ON     site.division_id = item.division_id
             AND    site.scm_site_id = item.scm_site_id
             WHERE  site.valid_yn    = 'Y'
             AND    item.valid_yn    = 'Y'
             AND    site.site_type   = 'SALES'
			 AND    item.project_code != ''
             GROUP BY item.division_id, item.project_code
             HAVING   count(distinct item.scm_site_id) = 1
          ) b
      ON     sr.division_id  = b.division_id
      AND    sr.project_code = b.project_code
      WHERE  ISNULL(sr.to_scm_site_id, '') = ''
	  AND    sr.division_id    != '40'; -- 2018.09.07 소형 제외


      -- 8-1. Sales Site Mapping : shipto code 기준으로  sales site id가 한건만 있으면 그 site로 mapping - Packer Site, 2018.09.17
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '8-1. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result sr  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.shipto_code
                    ,max(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
			 JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'PLANT'
			 AND    ms.osp_yn    = 'Y'
             GROUP BY cus.division_id, cus.shipto_code
             HAVING   count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id = cus.division_id
      AND    sr.shipto_code = cus.shipto_code
      WHERE  ISNULL(sr.to_scm_site_id, '') = '';

      -- 8-2. Sales Site Mapping : shipto code 기준으로  sales site id가 한건만 있으면 그 site로 mapping - Sales Site
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '8-2. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result sr  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.shipto_code
                    ,max(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
			 JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY cus.division_id, cus.shipto_code
             HAVING   count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id = cus.division_id
      AND    sr.shipto_code = cus.shipto_code
      WHERE  ISNULL(sr.to_scm_site_id, '') = '';

      -- 9-1. Sales Site Mapping : soldto code 기준으로 sales site id가 한건만 있으면 그 site로 mapping - Packer Site, 2018.09.17
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '9-1. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result sr  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.soldto_code
                    ,max(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
			 JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'PLANT'
			 AND    ms.osp_yn    = 'Y'
             GROUP BY cus.division_id, cus.soldto_code
             HAVING  count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id = cus.division_id
      AND    sr.soldto_code = cus.soldto_code
      WHERE  ISNULL(sr.to_scm_site_id, '') = '';

	  -- 9-2. Sales Site Mapping : soldto code 기준으로 sales site id가 한건만 있으면 그 site로 mapping - Sales Site
      UPDATE scm_dnm_exfactory_result
      SET    to_scm_site_id = cus.scm_site_id
            ,last_update_date = getdate()
			,last_updated_by  = '9-2. Sales Site Mapping'
      FROM   scm_dnm_exfactory_result sr  WITH(NOLOCK)
      JOIN  (SELECT  cus.division_id
                    ,cus.soldto_code
                    ,max(cus.scm_site_id) scm_site_id
             FROM   scm_mst_site_customer cus  WITH(NOLOCK)
			 JOIN   scm_mst_site ms WITH(NOLOCK)
			 ON     cus.division_id = ms.division_id
			 AND    cus.scm_site_id = ms.scm_site_id
             WHERE  cus.valid_yn = 'Y'
			 AND    ms.valid_yn  = 'Y'
			 AND    ms.site_type = 'SALES'
             GROUP BY cus.division_id, cus.soldto_code
             HAVING  count(distinct cus.scm_site_id) = 1) cus
      ON     sr.division_id = cus.division_id
      AND    sr.soldto_code = cus.soldto_code
      WHERE  ISNULL(sr.to_scm_site_id, '') = '';

      /*===== Sales Site Mapping End =======================================================================*/
	  
	  -- to_site 가 vmi 인 경우 incoterms 는 DAP 로 변경. 2018.06.25
	  UPDATE scm_dnm_exfactory_result
      SET    incoterms = 'DAP'
            ,last_update_date = getdate()
	  FROM    scm_dnm_exfactory_result ex with(nolock)
	  JOIN    scm_mst_site ms with(nolock)
	  ON      ex.to_scm_site_id = ms.scm_site_id
	  WHERE   ms.vmi_yn       = 'Y'
	  AND     ms.valid_yn     = 'Y'      
	  --AND     ms.division_id <> '82'  -- 20201028 ESS 'DAP' 처리  INCOTERMS = 'DAP' 20200519 [PI 합의] ESS인 경우 VMI 라도 'DAP' 처리 안 함 

      -- 20220121 PJ20216891 to_site 가 AS 인 경우 incoterms 는 DAP 로 변경
	  UPDATE scm_dnm_exfactory_result
      SET    incoterms = 'DAP'
            ,last_update_date = getdate()
	  FROM    scm_dnm_exfactory_result ex with(nolock)
	  JOIN    scm_mst_site ms with(nolock)
	  ON      ex.to_scm_site_id = ms.scm_site_id
	  WHERE   ms.operation_group = 'W'
	  AND     ms.valid_yn        = 'Y' 
        
     -- project_code가 'N' 인 데이터 추가적으로 mapping 후 업데이트
      UPDATE scm_dnm_exfactory_result
      SET    project_code     = B.new_project_code 
            ,last_update_date = GETDATE()
      FROM   scm_dnm_exfactory_result A
      INNER JOIN (SELECT CASE WHEN ( -- MKT FCST를 입력한 Project가 하나인 경우
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
                                                 WHERE  w.division_id		= a.division_id
                                                 AND    w.scm_site_id		= a.to_scm_site_id
                                                 AND    a.item_id		    = w.item_id
                                                 AND    w.valid_yn			= 'Y'
                                                 )
                              WHEN (  -- SITE_ITEM에 ITEM이 하나만 연결된 경우
                                    SELECT COUNT(DISTINCT w.project_code)
                                    FROM   scm_mst_site_item w WITH(NOLOCK)
                                    WHERE  w.division_id		= a.division_id
                                    AND    a.item_id		    = w.item_id 
                                    AND    w.valid_yn			= 'Y'
                                    ) = 1  THEN (SELECT DISTINCT w.project_code
                                                 FROM   scm_mst_site_item w WITH(NOLOCK)
                                                 WHERE  w.division_id		= a.division_id
                                                 AND    a.item_id		    = w.item_id 
                                                 AND    w.valid_yn			= 'Y'
                                                 )
                              ELSE project_code
                              END  new_project_code
                         ,creation_date
                         ,company_id
                         ,division_id
                         ,site_id
                         ,plant_id
                         ,doc_type
                         ,doc_seq
                         ,order_no
                         ,order_item_seq
                         ,delivery_no
                         ,delivery_item_seq
                         ,item_id
                         ,project_code
                  FROM   scm_dnm_exfactory_result a WITH(NOLOCK)
                  WHERE  project_code IS NULL
                  ) B
      ON  A.creation_date      = B.creation_date
      AND A.company_id         = B.company_id
      AND A.division_id        = B.division_id
      AND A.site_id            = B.site_id
      AND A.plant_id           = B.plant_id
      AND A.doc_type           = B.doc_type
      AND A.doc_seq            = B.doc_seq
      AND A.order_no           = B.order_no
      AND A.delivery_no        = B.delivery_no
      AND A.delivery_item_seq  = B.delivery_item_seq
      AND A.item_id		       = B.item_id 
      WHERE B.new_project_code!= 'N'
	  
      /*===== 20211222  PJ20214907  출하실적 비대상 Type의 QTY = 0 처리 =======================================================================*/	  
	  UPDATE scm_dnm_exfactory_result
      SET    exfactory_qty = 0
	  FROM   scm_dnm_exfactory_result ex with(nolock)
	  WHERE  order_type_code NOT IN (
                                     SELECT SEGMENT1 
                                     FROM   SCM_ADM_LOOKUP_MASTER_DETAIL 
                                     WHERE  LOOKUP_TYPE = 'ERP_ORDER_TYPE'
                                     AND    VALID_YN = 'Y'
                                    )
		AND DIVISION_ID IN ( -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
							SELECT DM.DIVISION_ID
							  FROM SCM_MST_DIVISION DM WITH(NOLOCK)
							 WHERE 1=1
							   AND DM.ATTRIBUTE3  != 'EE'
							   AND DM.DIVISION_ID != '40' -- 소형은 반품 실적 그대로 사용 중임
							   AND DM.VALID_YN	   = 'Y'
							)
	  --AND    division_id IN ('81', '82', '81_UC') -- 소형은 반품 실적 그대로 사용 중임-- 20220425 PJ20216891 : GM JV 가상 Division 추가

	;	

	  ----------------------------------------------------------------
	  -- PI 요청으로 Plant Issue Date Update : 2022.06.14
	  ----------------------------------------------------------------
      UPDATE scm_dnm_exfactory_result
      SET    exfactory_date   = b.plant_issue_date
           , plant_issue_date = b.plant_issue_date
      FROM   scm_dnm_exfactory_result a  WITH(NOLOCK)
      JOIN  (SELECT  delivery_no
                    ,item_id
                    ,MAX(plant_issue_date) plant_issue_date
             FROM   SSP_DNM_SHIP_RESULT_OWMS WITH(NOLOCK)
			 WHERE  lot_qty > 0
             GROUP BY delivery_no, item_id
            ) b
      ON     a.delivery_no    LIKE '%' + b.delivery_no + '%'
      AND    a.origin_item_id = b.item_id
	  WHERE (a.exfactory_date <> b.plant_issue_date 
	      OR a.plant_issue_date <> b.plant_issue_date
		   )
	  ;

      -- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
      SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_DNM_EXFACTORY_RESULT_H
    
      INSERT INTO SCM_DNM_EXFACTORY_RESULT_H(
               history_seq
              ,company_id
              ,division_id
              ,site_id
              ,plant_id
              ,from_scm_site_id
              ,to_scm_site_id
              ,order_no
              ,po_no
              ,project_code
              ,item_id
			  ,origin_item_id --2018.07.02
			  ,exfactory_status -- 2018.09.07
              ,order_qty
              ,soldto_code
              ,soldto_name
              ,shipto_name
              ,shipto_code
              ,order_item_seq
              ,order_type_code
              ,order_type_name
              ,storage_id
              ,order_create_date
              ,delivery_no
              ,delivery_posting_date
              ,delivery_item_seq
              ,item_name
              ,uom
              ,exfactory_qty
              ,on_board_date
              ,etd_date
              ,eta_date
              ,actual_exfactory_date
              ,system_exfactory_date
              ,plant_issue_date -- 2018. 5.  24
              ,exfactory_date
              ,transport_mode -- 2018. 5.  24
			  ,transport_mode_erp -- 2018. 6. 7
              ,incoterms -- 2018. 5.  24
			  ,origin_incoterms -- 2018.06.26
			  ,ssp_type               --2019.08.05
			  ,confirm_id             --2019.08.05
			  ,plan_exfactory_date    --2019.08.05
			  ,actual_delivery_date   --2019.08.05
			  ,intransit_date         --2019.08.05
			  ,factory_out_date       --2019.08.05 
              ,doc_type
              ,doc_seq
              ,valid_yn	
			  ,currency_code          --2020.08.26 C20200825-000168 추가
			  ,net_price              --2020.08.26 C20200825-000168 추가
			  ,sales_amount           --2020.08.26 C20200825-000168 추가
			  ,krw_xrate              --2020.08.26 C20200825-000168 추가
			  ,sales_krw_amount       --2020.08.26 C20200825-000168 추가
              ,created_by          
              ,creation_date
              ,last_updated_by  
              ,last_update_date
              ,history_creation_date      
			  ,attribute1          -- 20211222  PJ20214907
              )
      SELECT  @n_history_seq
             ,company_id
            ,division_id
            ,site_id
            ,plant_id
            ,from_scm_site_id
            ,to_scm_site_id
            ,order_no
            ,po_no
            ,project_code
            ,item_id
			,origin_item_id --2018.07.02
			,exfactory_status -- 2018.09.07
            ,order_qty
            ,soldto_code
            ,soldto_name
            ,shipto_name
            ,shipto_code
            ,order_item_seq
            ,order_type_code
            ,order_type_name
            ,storage_id
            ,order_create_date
            ,delivery_no
            ,delivery_posting_date
            ,delivery_item_seq
            ,item_name
            ,uom
            ,exfactory_qty
            ,on_board_date
            ,etd_date
            ,eta_date
            ,actual_exfactory_date
            ,system_exfactory_date
            ,plant_issue_date -- 2018. 5.  24
            ,exfactory_date
            ,transport_mode -- 2018. 5.  24
			,transport_mode_erp -- 2018. 6. 7
            ,incoterms -- 2018. 5.  24
			,origin_incoterms -- 2018.06.26
			,ssp_type               --2019.08.05
			,confirm_id             --2019.08.05
			,plan_exfactory_date    --2019.08.05
			,actual_delivery_date   --2019.08.05
			,intransit_date         --2019.08.05
			,factory_out_date       --2019.08.05
            ,doc_type
            ,doc_seq
            ,valid_yn 
		    ,currency_code          --2020.08.26 C20200825-000168 추가
			,net_price              --2020.08.26 C20200825-000168 추가
			,sales_amount           --2020.08.26 C20200825-000168 추가
			,krw_xrate              --2020.08.26 C20200825-000168 추가
			,sales_krw_amount       --2020.08.26 C20200825-000168 추가
            ,@v_batch_user
            ,GETDATE()     
            ,@v_batch_user  
            ,GETDATE()     
            ,GETDATE()     
			,attribute1       -- 20211222  PJ20214907 
      FROM   (SELECT  A.*
                     ,B.creation_date
                     ,B.last_update_date 
              FROM   (SELECT  company_id
                             ,division_id
                             ,site_id
                             ,plant_id
                             ,from_scm_site_id
                             ,to_scm_site_id
                             ,order_no
                             ,po_no
                             ,project_code
                             ,item_id
							 ,origin_item_id --2018.07.02
							 ,exfactory_status -- 2018.09.07
                             ,order_qty
                             ,soldto_code
                             ,soldto_name
                             ,shipto_name
                             ,shipto_code
                             ,order_item_seq
                             ,order_type_code
                             ,order_type_name
                             ,storage_id
                             ,order_create_date
                             ,delivery_no
                             ,delivery_posting_date
                             ,delivery_item_seq
                             ,item_name
                             ,uom
                             ,exfactory_qty
                             ,on_board_date
                             ,etd_date
                             ,eta_date
                             ,actual_exfactory_date
                             ,system_exfactory_date
                             ,plant_issue_date -- 2018. 5.  24
                             ,exfactory_date
                             ,transport_mode -- 2018. 5.  24
							 ,transport_mode_erp -- 2018. 6. 7
                             ,incoterms -- 2018. 5.  24
							 ,origin_incoterms -- 2018.06.26
							 ,ssp_type               --2019.08.05
							 ,confirm_id             --2019.08.05
							 ,plan_exfactory_date    --2019.08.05
							 ,actual_delivery_date   --2019.08.05
							 ,intransit_date         --2019.08.05
							 ,factory_out_date       --2019.08.05
                             ,doc_type
                             ,doc_seq
                             ,valid_yn
		                     ,currency_code          --2020.08.26 C20200825-000168 추가
			                 ,net_price              --2020.08.26 C20200825-000168 추가
			                 ,sales_amount           --2020.08.26 C20200825-000168 추가
			                 ,krw_xrate              --2020.08.26 C20200825-000168 추가
			                 ,sales_krw_amount       --2020.08.26 C20200825-000168 추가
							 ,attribute1             -- 20211222  PJ20214907
                      FROM   scm_dnm_exfactory_result_temp$ WITH(NOLOCK)
                      EXCEPT
                      SELECT  company_id
                             ,division_id
                             ,site_id
                             ,plant_id
                             ,from_scm_site_id
                             ,to_scm_site_id
                             ,order_no
                             ,po_no
                             ,project_code
                             ,item_id
							 ,origin_item_id --2018.07.02
							 ,exfactory_status -- 2018.09.07
                             ,order_qty
                             ,soldto_code
                             ,soldto_name
                             ,shipto_name
                             ,shipto_code
                             ,order_item_seq
                             ,order_type_code
                             ,order_type_name
                             ,storage_id
                             ,order_create_date
                             ,delivery_no
                             ,delivery_posting_date
                             ,delivery_item_seq
                             ,item_name
                             ,uom
                             ,exfactory_qty
                             ,on_board_date
                             ,etd_date
                             ,eta_date
                             ,actual_exfactory_date
                             ,system_exfactory_date
                             ,plant_issue_date -- 2018. 5.  24
                             ,exfactory_date
                             ,transport_mode -- 2018. 5.  24
							 ,transport_mode_erp -- 2018. 6. 7
                             ,incoterms -- 2018. 5.  24
							 ,origin_incoterms -- 2018.06.26
							 ,ssp_type               --2019.08.05
							 ,confirm_id             --2019.08.05
							 ,plan_exfactory_date    --2019.08.05
							 ,actual_delivery_date   --2019.08.05
							 ,intransit_date         --2019.08.05
							 ,factory_out_date       --2019.08.05
                             ,doc_type
                             ,doc_seq
                             ,valid_yn
		                     ,currency_code          --2020.08.26 C20200825-000168 추가
			                 ,net_price              --2020.08.26 C20200825-000168 추가
			                 ,sales_amount           --2020.08.26 C20200825-000168 추가
			                 ,krw_xrate              --2020.08.26 C20200825-000168 추가
			                 ,sales_krw_amount       --2020.08.26 C20200825-000168 추가
							 ,attribute1             -- 20211222  PJ20214907
                      FROM   scm_dnm_exfactory_result WITH(NOLOCK) 
                      WHERE  company_id+division_id+order_item_seq+plant_id+origin_item_id+delivery_no+order_no+doc_type+doc_seq
                      IN    (SELECT  company+division+so_item_seq+plant_id+item_id+delivery_no+so_no+doc_type+doc_seq 
                             --FROM    xif_erp_exfactory_result_r_sn   WITH(NOLOCK) 
                             FROM    xif_erp_exfactory_result_r_sn_temp$   WITH(NOLOCK) -- 20220425 PJ20216891 : GM JV 가상 Division 추가
                             WHERE   attribute15 = 'P')) A
              INNER JOIN scm_dnm_exfactory_result_temp$ B WITH(NOLOCK)
              ON    A.company_id     =  B.company_id
              AND   A.division_id    =  B.division_id
              AND   A.order_item_seq =  B.order_item_seq
              AND   A.plant_id       =  B.plant_id
              AND   A.origin_item_id =  B.origin_item_id --2018.07.02
              AND   A.delivery_no    =  B.delivery_no
              AND   A.order_no       =  B.order_no
              AND   A.doc_type       =  B.doc_type
              AND   A.doc_seq        =  B.doc_seq   ) A
        
      DROP TABLE scm_dnm_exfactory_result_temp$;
      DROP TABLE xif_erp_exfactory_result_r_sn_temp$; -- 20220425 PJ20216891 : GM JV 가상 Division 추가
    
      -- 처리된 ROW 마킹
      UPDATE  xif_erp_exfactory_result_r_sn  
      SET     attribute15 = 'Y'
      WHERE   attribute15 = 'P';

	  -- 20220425 PJ20216891 : GM JV 대음
	  -- lookup_type = 'EXFACTORY_INTRANSIT_TARGET' 전체 사용 중지로 수행 필요 없음
      --EXEC PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF  --2018. 4.  26
    
      -- HISTORY LOG
    
      SET @v_log_type = 'HISTORY';
      SET @n_log_count = @@ROWCOUNT;
      SET @v_log_message = 'INSERT INTO SCM_DNM_EXFACTORY_RESULT_H';
      SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      IF @@TRANCOUNT > 0
        BEGIN
          COMMIT WORK;
        END;

    END;
    --COMMIT TRANSACTION
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
