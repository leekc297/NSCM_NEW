
CREATE PROCEDURE [dbo].[PR_SCM_DNM_SO_STOCK_CUTOFF]
(
	@P_ISSUE_DATE         NVARCHAR(8)=NULL
)
AS
/*
 * Program ID   : PR_SCM_DNM_SO_STOCK_CUTOFF
 * Description  : SO Reserved Stock 으로 Intransit 생성용
 *                PR_SCM_DNM_STOCK_CUSTOMER_CONSIGN 에서 Call함
 *                IF 정보 중 SO Stock(Attribute1 = 'B') 정보를 해상 재고로 생성
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.11.21   KSG            Initial Release 전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2020.05.19   KSG            C20200519-000150 VMI-in Request CIP조건 입력 시 출하 계획이 D조건으로 생성되는 시스템 수정 요청드립니다 : ESS인 경우 VMI 라도 'DAP' 처리 안 함
 * 2020.10.07   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ERP
 *                                Cutoff 테이블에 신규 컬럼 추가 : final_soldto_code / final_soldto_name / final_incoterms
 * 2020.10.28   KSG            ESS인 VMI : 'DAP' 처리
 * 2020.12.09   KSW            C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경
 * 2022.03.30   KSG            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
 * 2023.03.23	hrkim		   [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 * 2025.03.20	kimcd		   [PJ20249548R] SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 */

BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET NOCOUNT ON; 
SET XACT_ABORT ON;

-- LOG 용 변수 설정
DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_SO_STOCK_CUTOFF';
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
DECLARE @v_c2_actual_exfactory_date  NVARCHAR(8); 
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

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	BEGIN TRY
	  BEGIN
		IF @P_ISSUE_DATE IS NULL OR ISDATE(@P_ISSUE_DATE) != 1
		SET @P_ISSUE_DATE = CONVERT(CHAR(8), DATEADD(day,-1,GETDATE()), 112)
		ELSE
		SET @P_ISSUE_DATE = CONVERT(CHAR(8), DATEADD(day,-1,@P_ISSUE_DATE), 112)
	    
		/******************************************************
		* 1. IF 정보를 1차 가공
		******************************************************/

		-- 인터페이스 테이블 처리 ROW UPDATE
	    UPDATE [dbo].[xif_erp_customer_consign_stock_r_sn]
	    SET    transfer_flag = 'P'
	    WHERE  ISNULL(transfer_flag,'N') = 'N'
        AND    attribute1                = 'B' -- SO Stock 조건

      -------------------------------------------------------------------------
	  -- 20220330 PJ20216891 : GM JV 가상 Division 추가 
	  -- 처리대상 Temp Table 생성
	  -------------------------------------------------------------------------
      IF OBJECT_ID('dbo.xif_erp_customer_consign_stock_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_customer_consign_stock_r_sn_temp$

      SELECT * 
      INTO   xif_erp_customer_consign_stock_r_sn_temp$
      FROM   xif_erp_customer_consign_stock_r_sn WITH(NOLOCK)
	  WHERE  transfer_flag = 'P'
      AND    attribute1    = 'B' -- SO Stock 조건
	 
	  -- GM JV : division Size 변경
      ALTER TABLE xif_erp_customer_consign_stock_r_sn_temp$ ALTER COLUMN division_id NVARCHAR(10) NULL;

	  /*
	--  -- GM JV division 처리
	--  UPDATE xif_erp_customer_consign_stock_r_sn_temp$
	--  SET    division_id = CASE WHEN company_id = 'G670' THEN '81_UC'
    --                            ELSE division_id
	--					   END
	  */
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
	     SET TGT.DIVISION_ID	= JP.DIVISION_ID_JV
	    FROM xif_erp_customer_consign_stock_r_sn_temp$ TGT
			INNER JOIN JV_PLANT JP WITH(NOLOCK)
				    ON JP.DIVISION_ID = TGT.DIVISION_ID
				   AND JP.COMPANY_ID  = TGT.COMPANY_ID
	  -------------------------------------------------------------------------
	  -------------------------------------------------------------------------
	    ;
	  
	    -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	    DECLARE CUR_IF_SOSTOCK_PO CURSOR FOR
	    SELECT ifseqno 
	    FROM   xif_erp_customer_consign_stock_r_sn_temp$ WITH(NOLOCK) -- 20220330 PJ20216891 : GM JV 가상 Division 추가 xif_erp_customer_consign_stock_r_sn
	    WHERE  transfer_flag = 'P'
        AND    attribute1    = 'B' -- SO Stock 조건
	    GROUP BY ifseqno
	    ORDER BY ifseqno ASC;

		OPEN CUR_IF_SOSTOCK_PO;
		FETCH NEXT FROM CUR_IF_SOSTOCK_PO INTO @v_ifseqno ;
		 
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
		   
		  MERGE INTO scm_dnm_so_stock A
		  USING ( 
				SELECT /* PR_SCM_DNM_SO_STOCK_CUTOFF */ 
				       A.company_id AS company_id
				      ,CONVERT(char(8),DATEADD(day,-1,result_date),112) AS result_date -- 2018. 05 .25
					  ,A.division_id AS division_id
				      ,'' AS from_scm_site_id  -- 추후 수정 예정
					  ,'' AS to_scm_site_id    -- 추후 수정 예정
					  ,'' AS incoterms         -- 추후 수정 예정
					  ,C.site_id AS site_id
					  ,A.plant_id AS plant_id
					  ,item_id origin_item_id  --2018.07.20
					  ,item_name
					  ,customer_code
					  ,customer_name
					  ,ISNULL(qty,0) qty
					  ,uom
				      ,dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, item_id) item_id --2018.06.27 , 2018.07.20

					  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
					  ,(CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END) AS attribute2	-- Final Soldto Code :: scm_dnm_so_stock.FINAL_SOLDTO_CODE
					  ,attribute3	                                                                                -- 판매처 이름       :: scm_dnm_so_stock.FINAL_SOLDTO_NAME
					  ,(CASE WHEN attribute4 = NULL OR attribute4 = '' THEN '-' ELSE attribute4 END) AS attribute4	-- Final Shipto Code :: scm_dnm_so_stock.FINAL_SHIPTO_CODE
					  ,attribute5	                                                                                -- 최종 인도처 이름  :: scm_dnm_so_stock.FINAL_SHIPTO_NAME
					  ,(CASE WHEN attribute6 = NULL OR attribute6 = '' THEN '-' ELSE attribute6 END) AS attribute6	-- 판매오더번호      :: scm_dnm_so_stock.SALES_ORDER_NO
					  ,(CASE WHEN attribute7 = NULL OR attribute7 = '' THEN '-' ELSE attribute7 END) AS attribute7  -- 품목번호          :: scm_dnm_so_stock.SALES_ORDER_SEQ
					  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end

				FROM   xif_erp_customer_consign_stock_r_sn_temp$ A WITH(NOLOCK) -- 20220330 PJ20216891 : GM JV 가상 Division 추가 xif_erp_customer_consign_stock_r_sn
			           INNER JOIN scm_mst_plant_sn C
					   ON   A.company_id  = C.company_id
					   AND	A.division_id = C.division_id
					   AND	A.plant_id    = C.plant_id
				WHERE  ifseqno = @v_ifseqno
				AND    transfer_flag = 'P'
                AND    attribute1    = 'B' -- SO Stock 조건

					) B
		  ON (    A.company_id     =  B.company_id
		      AND A.division_id	   =  B.division_id
			  AND A.site_id		   =  B.site_id
			  AND A.plant_id	   =  B.plant_id
			  AND A.origin_item_id =  B.origin_item_id 
			  AND A.result_date	   =  B.result_date
			  AND A.customer_code  =  B.customer_code

			  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
			  AND A.FINAL_SOLDTO_CODE  =  B.attribute2
			  AND A.FINAL_SHIPTO_CODE  =  B.attribute4
			  AND A.SALES_ORDER_NO     =  B.attribute6
			  AND A.SALES_ORDER_SEQ    =  B.attribute7
			  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end
             )
		  WHEN MATCHED THEN
				 UPDATE SET 							 
						 A.from_scm_site_id	=  B.from_scm_site_id
						,A.to_scm_site_id	=  B.to_scm_site_id
						,A.item_id			=  B.item_id --2018.06.27
						,A.item_name		=  B.item_name
						,A.customer_name	=  B.customer_name
						,A.qty				=  B.qty
						,A.uom				=  B.uom
						,A.valid_yn			=  'Y'
						,A.last_updated_by	=  @v_batch_user
						,A.last_update_date	=  GETDATE()

						-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
						,A.FINAL_SOLDTO_CODE  =  B.attribute2
						,A.FINAL_SOLDTO_NAME  =  B.attribute3
						,A.FINAL_SHIPTO_CODE  =  B.attribute4
						,A.FINAL_SHIPTO_NAME  =  B.attribute5
						,A.SALES_ORDER_NO     =  B.attribute6
						,A.SALES_ORDER_SEQ    =  B.attribute7
						-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end
					                
		  WHEN NOT MATCHED THEN
				 INSERT (  
				         company_id
						,division_id
						,from_scm_site_id
						,to_scm_site_id
						,site_id	
						,plant_id
						,item_id
						,origin_item_id --2018.06.27
						,result_date
						,item_name
						,customer_code
						,customer_name
						,qty
						,uom
						,valid_yn

						-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
						,FINAL_SOLDTO_CODE
						,FINAL_SOLDTO_NAME
						,FINAL_SHIPTO_CODE
						,FINAL_SHIPTO_NAME
						,SALES_ORDER_NO
						,SALES_ORDER_SEQ
						-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end

					    ,created_by
						,creation_date
						,last_updated_by
						,last_update_date						  								
						)
				 VALUES (   
						 B.company_id
						,B.division_id
						,B.from_scm_site_id
						,B.to_scm_site_id
						,B.site_id
						,B.plant_id
						,B.item_id
						,B.origin_item_id
						,B.result_date
						,B.item_name
						,B.customer_code
						,B.customer_name
						,B.qty
						,B.uom
						,'Y'

						-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
						,B.attribute2
						,B.attribute3
						,B.attribute4
						,B.attribute5
						,B.attribute6
						,B.attribute7
						-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end

						,@v_batch_user
						,GETDATE()
						,@v_batch_user
						,GETDATE() 
						)
		  ;			

		  ----------------------------------------------------------
          -- Merge LOG
          -----------------------------------------------------------
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'TXN';
          SET @v_log_message = 'MERGE INTO scm_dnm_so_stock';
          SET @v_description = 'ifseqno = ' + @v_ifseqno;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------

		  FETCH NEXT FROM CUR_IF_SOSTOCK_PO INTO  @v_ifseqno
		END
		
		CLOSE CUR_IF_SOSTOCK_PO;
		DEALLOCATE CUR_IF_SOSTOCK_PO; 		
		
		-- 처리 한 row 마킹
		UPDATE [dbo].[xif_erp_customer_consign_stock_r_sn]
		SET transfer_flag = 'Y' 
		WHERE transfer_flag = 'P'
        AND   attribute1    = 'B' -- SO Stock 조건

        /*===== From Site Mapping Start =======================================================================*/
		-- 2025.03.20	kimcd		   [PJ20249548R] SCP역량 강화를 위한 기준정보PSI엔진 기능개선 시작
		UPDATE a
        SET    a.from_scm_site_id   = ( CASE WHEN A.DIVISION_ID = '81' THEN
			                                ( SELECT TOP 1 MSI.PLANT_SITE_ID
		                                      FROM   SCM_MST_SITE_ITEM_PRIORITY   MSI WITH(NOLOCK)
		                                             INNER JOIN DBO.SCM_MST_SITE  I   WITH(NOLOCK)
			                                             ON  MSI.DIVISION_ID   = I.DIVISION_ID
														 AND MSI.PLANT_SITE_ID = I.SCM_SITE_ID
		                                      WHERE  1=1
		                                      AND    MSI.ITEM_ID       = A.ITEM_ID
		                                      AND    MSI.DIVISION_ID   = A.DIVISION_ID
		                                      AND    MSI.PRIORITY      = 1
		                                      AND    I.SITE_ID         = 'A002'
                                              AND    I.OPERATION_GROUP = 'A'
                                              AND    I.SITE_TYPE       = 'PLANT'
                                              AND    I.VALID_YN        = 'Y'
		                                      AND    MSI.VALID_YN      = 'Y'
		                                      ORDER  BY MSI.PRIORITY_SEQ DESC )
			                            ELSE
										    ( SELECT TOP 1 ISNULL(I.SCM_SITE_ID,'')
                                              FROM   DBO.SCM_MST_SITE       I WITH(NOLOCK)
                                              WHERE  1=1
                                              AND    I.SITE_ID         = 'A002'
                                              AND    I.OPERATION_GROUP = 'A'
                                              AND    I.SITE_TYPE       = 'PLANT'
                                              AND    I.VALID_YN        = 'Y'
                                              AND    I.DIVISION_ID     = A.DIVISION_ID
                                              ORDER  BY 1 DESC )
										END )
              ,a.last_update_date   = getdate()
        FROM   scm_dnm_so_stock a WITH(NOLOCK) 
        WHERE  ISNULL(a.from_scm_site_id, '') = ''
		AND    dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id,A.item_id) = 'A';
    	-- 2025.03.20	kimcd		   [PJ20249548R] SCP역량 강화를 위한 기준정보PSI엔진 기능개선 종료


        -- 1. from_scm_site_id Mapping 
        UPDATE scm_dnm_so_stock
        SET    from_scm_site_id   =  dbo.FN_GET_SCM_SITE_ID_PLANT(A.plant_id,dbo.FN_GET_ITEM_OPERATION_GROUP(A.division_id,A.item_id))
              ,last_update_date   = getdate()
        FROM   scm_dnm_so_stock A WITH(NOLOCK) 
        WHERE  ISNULL(from_scm_site_id, '') = '';
    
        -- 2. from_scm_site_id Mapping : 전극이 A040 창고에서 출하되는 경우
        UPDATE scm_dnm_so_stock
        SET    from_scm_site_id = B.segment2 
              ,last_update_date = GETDATE()
        FROM   scm_dnm_so_stock A WITH(NOLOCK) 
        JOIN  (SELECT segment1, segment2
               FROM   scm_adm_lookup_master_detail A WITH(NOLOCK) 
               WHERE  lookup_type = 'ELECTRODE_SHIP_SITE' 
               AND    valid_yn    = 'Y' 
               AND    segment3    = '*'
              ) B
         ON    A.plant_id = B.segment1
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
               AND    O.operation_group_id   IN ('S','E')
              ) C
        ON     A.division_id = C.division_id
        AND    A.item_id     = C.item_id
        WHERE  ISNULL(from_scm_site_id, '') = '';
     
        -- 3. from_scm_site_id Mapping : Pack 이 A050 에서 출하되는 경우 (외주 Packer)
        UPDATE scm_dnm_so_stock
        SET    from_scm_site_id = B.scm_site_id 
              ,last_update_date = GETDATE()
        FROM   scm_dnm_so_stock A WITH(NOLOCK) 
        JOIN  (SELECT  distinct 
                       si.division_id
                      ,si.scm_site_id
                      ,si.item_id
               FROM   scm_mst_site_item si WITH(NOLOCK) 
               JOIN   scm_mst_site ms WITH(NOLOCK) 
               ON     si.division_id = ms.division_id
               AND    si.scm_site_id = ms.scm_site_id
               JOIN   scm_mst_site_item_priority_v pv
               ON     si.division_id = pv.division_id
               AND    si.item_id     = pv.item_id
               WHERE  si.valid_yn    = 'Y'
               AND    ms.valid_yn    = 'Y'
               AND    ms.site_type   = 'PLANT'
               AND    ms.osp_yn      = 'Y'
               AND    CONVERT(char(8), GETDATE(), 112) BETWEEN from_yyyymmdd AND to_yyyymmdd
              ) B
        ON    A.division_id	= B.division_id
        AND   A.item_id     = B.item_id
        WHERE  ISNULL(from_scm_site_id, '') = '';
    
        /*===== From Site Mapping End ==========================================================================*/


		-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
		UPDATE scm_dnm_so_stock
        SET    to_scm_site_id = cus.scm_site_id
              ,last_update_date = getdate()
			  ,last_updated_by  = '3. Sales Site Mapping'
        FROM   scm_dnm_so_stock sr  WITH(NOLOCK)
        JOIN  (SELECT  cus.division_id
					  ,cus.soldto_code
                      ,cus.shipto_code
                      ,max(cus.scm_site_id) scm_site_id
               FROM   scm_mst_site_customer cus  WITH(NOLOCK)
			   JOIN   scm_mst_site ms WITH(NOLOCK)
			   ON     cus.division_id = ms.division_id
			   AND    cus.scm_site_id = ms.scm_site_id
               WHERE  cus.valid_yn = 'Y'
			   AND    ms.valid_yn  = 'Y'
			   AND    ms.site_type = 'PLANT'
               GROUP BY cus.division_id, cus.soldto_code, cus.shipto_code) cus
        ON     sr.division_id       = cus.division_id
		AND    sr.final_soldto_code = cus.soldto_code
        AND    (CASE WHEN sr.final_shipto_code = '-' THEN sr.customer_code ELSE sr.final_shipto_code END) = cus.shipto_code
        WHERE  ISNULL(sr.to_scm_site_id, '') = '';

		UPDATE scm_dnm_so_stock
        SET    to_scm_site_id   =  B.scm_site_id
              ,last_update_date = GETDATE()
		   	  ,last_updated_by  = '4. Sales Site Mapping'
        FROM   scm_dnm_so_stock A WITH(NOLOCK)
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
               HAVING count(distinct sc.scm_site_id) = 1
              ) B
        ON     B.division_id =  A.division_id
        AND    B.soldto_code =  A.final_soldto_code 
        AND    B.shipto_code =  (CASE WHEN A.final_shipto_code = '-' THEN A.customer_code ELSE A.final_shipto_code END)
        WHERE  ISNULL(A.to_scm_site_id, '') = '';
		-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end


		
        /*===== To Site Mapping Start ==========================================================================*/

        -- 1. To Site Mapping : shipto code 기준으로 sales site id가 한건만 있으면 그 site로 mapping - Plant Site
        UPDATE scm_dnm_so_stock
        SET    to_scm_site_id = cus.scm_site_id
              ,last_update_date = getdate()
			  ,last_updated_by  = '1. To Site Mapping'
        FROM   scm_dnm_so_stock sr  WITH(NOLOCK)
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
               GROUP BY cus.division_id, cus.shipto_code) cus
        ON     sr.division_id       = cus.division_id

		-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
		-- 변경전
		-- AND    sr.customer_code = cus.shipto_code
		--
        AND    (CASE WHEN sr.final_shipto_code = '-' THEN sr.customer_code ELSE sr.final_shipto_code END) = cus.shipto_code
		-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end

        WHERE  ISNULL(sr.to_scm_site_id, '') = '';

        -- 2. To Site Mapping : shipto code 기준으로 sales site id가 여러건 있으면 MAX site로 mapping - Sales Site
        UPDATE scm_dnm_so_stock
        SET    to_scm_site_id = cus.scm_site_id
              ,last_update_date = getdate()
			  ,last_updated_by  = '2. To Site Mapping'
        FROM   scm_dnm_so_stock sr  WITH(NOLOCK)
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
               GROUP BY cus.division_id, cus.shipto_code) cus
        ON     sr.division_id       = cus.division_id

		-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
		-- 변경전
		-- AND    sr.customer_code = cus.shipto_code
		--
        AND    (CASE WHEN sr.final_shipto_code = '-' THEN sr.customer_code ELSE sr.final_shipto_code END) = cus.shipto_code
		-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end

        WHERE  ISNULL(sr.to_scm_site_id, '') = '';


        /*===== To Site Mapping End ============================================================================*/		
		
        /*===== incoterms Mapping Start ==========================================================================*/

		-- MKT FCST 기준으로 Incoterms 설정
		UPDATE scm_dnm_so_stock
        SET    incoterms = b.max_incoterms
        FROM   scm_dnm_so_stock a
        INNER JOIN ( SELECT aa.division_id, aa.scm_site_id
				            --  VMI 는 'DAP'로 처리
	                        --  20200519 [PI 합의] ESS인 경우 VMI 라도 'DAP' 처리 안 함
							--  20201028 ESS 'DAP' 처리
		                  , MAX(CASE WHEN cc.vmi_yn = 'Y' THEN 'DAP' 
		                  --, MAX(CASE WHEN aa.division_id <> '82' AND cc.vmi_yn = 'Y' THEN 'DAP' 
                                     ELSE aa.incoterms
                                END 
							   ) max_incoterms
                     FROM   dbo.dm_pln_mkt_fcst aa WITH(NOLOCK) 

                            LEFT JOIN ( SELECT division_id, scm_site_id, vmi_yn 
                                        FROM   scm_mst_site WITH (NOLOCK)
                                        WHERE  vmi_yn = 'Y') cc
                            ON  aa.division_id = cc.division_id 
                            AND aa.scm_site_id = cc.scm_site_id 

					 WHERE yyyymmdd >= @P_ISSUE_DATE
                     GROUP BY aa.division_id, aa.scm_site_id       

                   ) b
        ON     a.division_id    = b.division_id 
        AND    a.to_scm_site_id = b.scm_site_id 
		WHERE  a.result_date = @P_ISSUE_DATE;
		;
		
        /*===== incoterms Mapping End== ==========================================================================*/


		/******************************************************
		* 2. Intransit Cutoff 정보 생성
		******************************************************/
	
	    DELETE FROM scm_dnm_intransit_c 
		WHERE result_type = 'B'
		AND   result_date = @P_ISSUE_DATE
		;

		INSERT INTO scm_dnm_intransit_c
		    ( result_date, result_type, company_id, division_id, plant_id, shipment_no, incoterms, fcst_type
            , transport_mode, dom_exp, project_code, item_id, from_scm_site_id, to_scm_site_id, customer_code
            , shipto_code, delivery_qty, shipping_date, f_dest_eta_date, plant_issue_date, uom, valid_yn
            , created_by, creation_date, last_updated_by, last_update_date
            -- 20201007 PJ20202001  신규 컬럼 추가
            , final_soldto_code, final_soldto_name, final_incoterms
           )

        SELECT 
               result_date
              ,'B' AS result_type -- 엔진 Input 용 Type 지정
              ,company_id
              ,division_id
              ,plant_id
              ,CAST(ROW_NUMBER() OVER(PARTITION BY item_id ORDER BY item_id) AS nvarchar(10)) AS shipment_no
              ,ISNULL(incoterms,'-') AS incoterms
              ,'MPS'                 AS fcst_type
              ,'-'                   AS transport_mode
              ,'E'                   AS dom_exp
              ,'-'                   AS project_code
              ,item_id
              ,from_scm_site_id
              ,to_scm_site_id
              ,customer_code
              ,CASE WHEN final_shipto_code = '-' THEN customer_code ELSE final_shipto_code END AS shipto_code		-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 :: OLD --> ,customer_code         AS shipto_code
              ,qty
              ,result_date           AS shipping_date
              ,result_date           AS f_dest_eta_date
              ,result_date           AS plant_issue_date
              ,uom
              ,valid_yn
              ,created_by
              ,creation_date
              ,last_updated_by
              ,last_update_date
              -- 20201007 PJ20202001  신규 컬럼 추가
              , final_soldto_code                                	-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 :: OLD --> , customer_code         AS final_soldto_code
              , ISNULL(final_soldto_name,'-') AS final_soldto_name	-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 :: OLD --> , '-'                   AS final_soldto_name
              , ISNULL(incoterms,'-') AS final_incoterms
        FROM   scm_dnm_so_stock WITH(NOLOCK)
        WHERE  1=1
        AND    result_date                 = @P_ISSUE_DATE
        AND    ISNULL(to_scm_site_id, '') <> ''
        --AND    division_id                <> '82' -- 20210407 원복 -- 20210119 PI 요청으로 ESS(82) 사업부는 SO Reserved Stock 생성 안 함
		;

        -- HISTORY LOG		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO scm_dnm_intransit_c : B';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF OBJECT_ID('dbo.xif_erp_customer_consign_stock_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_customer_consign_stock_r_sn_temp$

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
