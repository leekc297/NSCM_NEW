
CREATE PROCEDURE [dbo].[PR_SCM_DNM_STOCK_CUSTOMER_CONSIGN]
AS
/*
 * Program ID   : PR_SCM_DNM_STOCK_CUSTOMER_CONSIGN
 * Description  : 고객 위탁 재고 I/F
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 24    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 참조: 인터페이스 대상에 해당하는 데이터만 비교 후 History 저장(INSERT 된 데이터는 남기지 않음)
 * 2018. 05 .25   Kim Jaejung      resulte_date 로직 수정
 * 2018.06.27     Kim Jaejung	   소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 * 2018.07.20	  Kim Jaejung      소형 대표 ITEM_ID 변경 시 update 로직 적용 (소형)
 * 2018.11.21	  KSG              Data Type 지정 처리 : 고객 위탁 재고 -> Attribute1 = NULL Or 'A'
 *                                                       SO Stock : Attribute1 = 'B'
 *                                                       7990/7000 재고 : Attribute1 = 'C'
 *                                 SO Stock 처리 프로그램 Call
 * 2020.12.09     KSW              C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경
 * 2021.01.06     KSW              C20210105-000744 Consignment 재고의 Ship-To와 Sold-To 적용을 위한 재고 반영 로직 변경
 *                                 - Sales Site를 Lookup Mapping 하지 않고 Ship-To와 Sold-To 기준으로 연동 함.
 * 2022.03.30     KSG              PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
 * 2022.10.06     KSG              PJ20216894 Digital SCM 3 Level 가속화를 위한 개선 Phase2 : Qty 기준 후처리 개선
 *                                    Sum(위탁보충 수량, 위탁출고 수량) <= 0일 경우 : Qty 0 처리
 *                                    Sum(위탁보충 수량, 위탁출고 수량) > 0일 경우 : 대용량 Qty 순으로 Qty 할당
 * 2023.03.23	  hrkim			   [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 * 2025.04.02	  kimcd     	   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - 매출 이력 차감에 사용될 attribute2 수량 설정
 */
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_STOCK_CUSTOMER_CONSIGN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;
    DECLARE @v_soldto       NVARCHAR(1000); 
    DECLARE @n_sum_qty      INTEGER = 0;
    DECLARE @v_shipto       NVARCHAR(1000); 
    DECLARE @n_qty          INTEGER = 0;
	
	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	  -- 인터페이스 테이블 처리 ROW UPDATE
	  UPDATE [dbo].[xif_erp_customer_consign_stock_r_sn]
	  SET    transfer_flag = 'P'
	  WHERE  ISNULL(transfer_flag,'N') = 'N'
      AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가

      -------------------------------------------------------------------------
	  -- 20220330 PJ20216891 : GM JV 가상 Division 추가
	  -- 처리대상 Temp Table 생성
	  -------------------------------------------------------------------------
      IF OBJECT_ID('dbo.xif_erp_customer_consign_stock_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_customer_consign_stock_r_sn_temp$

      SELECT *
           , ISNULL(qty,0) AS origin_qty -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : origin_qty 추가
           , 'Y'           AS alloc_flag -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : 할당 로직 적용 대상 여부
      INTO   xif_erp_customer_consign_stock_r_sn_temp$
      FROM   xif_erp_customer_consign_stock_r_sn WITH(NOLOCK)
	  WHERE  transfer_flag = 'P'
      AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
	 
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
      -- 20221006 PJ20216894 Digital SCM 3 Level 가속화를 위한 개선 Phase2 : Qty 기준 후처리 개선
      -- 1. Sum(위탁보충 수량, 위탁출고 수량) <= 0일 경우 : Qty 0 처리
	  --    ifseqno / result_date / division_id / plant_id / item_id / attribute2(Final Soldto Code) 기준 SUM
	  -------------------------------------------------------------------------
      UPDATE xif_erp_customer_consign_stock_r_sn_temp$
      SET    qty        = 0
           , alloc_flag = 'N' -- 할당 로직 적용 대상 아님
	  WHERE  transfer_flag = 'P'
      AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
	  AND    CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)
	     IN (
			  SELECT CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)
			  FROM   xif_erp_customer_consign_stock_r_sn WITH(NOLOCK)
			  WHERE  transfer_flag = 'P'
			  AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
			  GROUP BY CONVERT(NVARCHAR, ifseqno), result_date, division_id, plant_id, item_id, (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)
			  HAVING SUM(ISNULL(qty,0)) <= 0
		    );

      -------------------------------------------------------------------------
      -- 2. 할당 로직 적용 비대상 처리
	  -------------------------------------------------------------------------
	  -- 2.1) 한 건만 존재하는 경우
      UPDATE xif_erp_customer_consign_stock_r_sn_temp$
      SET    alloc_flag = 'N' -- 할당 로직 적용 대상 아님
	  WHERE  transfer_flag = 'P'
      AND    alloc_flag    = 'Y'
      AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
	  AND    CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)
	     IN (
			  SELECT CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)
			  FROM   xif_erp_customer_consign_stock_r_sn_temp$ WITH(NOLOCK)
			  WHERE  transfer_flag = 'P'
              AND    alloc_flag    = 'Y'
			  AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
			  GROUP BY CONVERT(NVARCHAR, ifseqno), result_date, division_id, plant_id, item_id, (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)
			  HAVING COUNT(*) = 1
		    );

	  -- 2.2) 음수가 한 건도 없는 경우
      UPDATE xif_erp_customer_consign_stock_r_sn_temp$
      SET    alloc_flag = 'N' -- 할당 로직 적용 대상 아님
	  WHERE  transfer_flag = 'P'
      AND    alloc_flag    = 'Y'
      AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
	  AND    CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)
	     NOT IN ( -- 음수값이 없는 Soldto
			  SELECT CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)
			  FROM   xif_erp_customer_consign_stock_r_sn WITH(NOLOCK)
			  WHERE  transfer_flag = 'P'
              AND    alloc_flag    = 'Y'
			  AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
			  AND    ISNULL(qty,0) < 0
		    );

	  -------------------------------------------------------------------------
      -- 3. Sum(위탁보충 수량, 위탁출고 수량) > 0일 경우 : 대용량 Qty 순으로 Qty 할당
      --  - 할당 대상 선정 후 대상인 정보의 Qty는 0 처리
      --   3-1) origin qty 가 가장 큰 항목의 Origin Qty 가 SUM(수량) 보다 큰 경우 qty를 SUM(수량) 으로 처리하고 종료
      --   3-2) origin qty 가 가장 큰 항목의 Origin Qty 가 SUM(수량) 보다 작은 경우 qty를 자신의 origin qty로 처리하고 다음 항목으로 넘어감
      --        SUM(수량) 이 소진 될 때까지 처리 후 종료
	  -------------------------------------------------------------------------
	  --  할당 대상 선정 후 대상인 정보의 Qty는 0 처리		  
      UPDATE xif_erp_customer_consign_stock_r_sn_temp$
      SET    qty = 0
	  WHERE  transfer_flag = 'P'
      AND    alloc_flag    = 'Y'
      AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가

	  -- 할당 대상 정보 Cursor
	  DECLARE CUR_ALLOC CURSOR FOR
	  SELECT CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END) AS soldto
           , SUM(origin_qty) AS sum_qty
	  FROM   xif_erp_customer_consign_stock_r_sn_temp$ WITH(NOLOCK)
	  WHERE  transfer_flag = 'P'
      AND    alloc_flag    = 'Y'
	  AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
	  GROUP BY CONVERT(NVARCHAR, ifseqno), result_date, division_id, plant_id, item_id, (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)

	  OPEN CUR_ALLOC;
	  FETCH NEXT FROM CUR_ALLOC INTO @v_soldto, @n_sum_qty ;
		 
	  WHILE (@@FETCH_STATUS = 0)
	  BEGIN
	      ----------------------------------------
          -- Soldto 별 할당 처리 : START
	      ----------------------------------------
	      DECLARE CUR_ALLOC_ITEM CURSOR FOR
	      SELECT CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END) 
                + (CASE WHEN attribute4 = NULL OR attribute4 = '' THEN customer_code ELSE attribute4 END)  AS shipto
               , ISNULL(origin_qty, 0) AS qty
	      FROM   xif_erp_customer_consign_stock_r_sn_temp$ WITH(NOLOCK)
	      WHERE  transfer_flag = 'P'
          AND    alloc_flag    = 'Y'
	      AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
		  AND    ISNULL(origin_qty, 0) > 0
	      AND    CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END)
                = @v_soldto
          ORDER BY qty DESC
		  
	      OPEN CUR_ALLOC_ITEM;
	      FETCH NEXT FROM CUR_ALLOC_ITEM INTO @v_shipto, @n_qty ;
		 
	      WHILE (@@FETCH_STATUS = 0)
	      BEGIN

		    -------------------------------------------------------------
            --  3-1) origin qty 가 가장 큰 항목의 Origin Qty 가 SUM(수량) 보다 큰 경우 qty를 SUM(수량) 으로 처리하고 종료
		    -------------------------------------------------------------
            IF @n_sum_qty <= @n_qty
			  BEGIN

                UPDATE xif_erp_customer_consign_stock_r_sn_temp$
                SET    qty = @n_sum_qty
	            WHERE  transfer_flag = 'P'
                AND    alloc_flag    = 'Y'
                AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
	            AND    CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END) 
                     + (CASE WHEN attribute4 = NULL OR attribute4 = '' THEN customer_code ELSE attribute4 END) 
	                 = @v_shipto;
			    
				BREAK;
              END
		    -------------------------------------------------------------
            --  3-2) origin qty 가 가장 큰 항목의 Origin Qty 가 SUM(수량) 보다 작은 경우 qty를 자신의 origin qty로 처리하고 다음 항목으로 넘어감
            --        SUM(수량) 이 소진 될 때까지 처리 후 종료
		    -------------------------------------------------------------
			ELSE
			  BEGIN

                UPDATE xif_erp_customer_consign_stock_r_sn_temp$
                SET    qty = @n_qty
	            WHERE  transfer_flag = 'P'
                AND    alloc_flag    = 'Y'
                AND    ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
	            AND    CONVERT(NVARCHAR, ifseqno) + result_date + division_id + plant_id + item_id + (CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END) 
                     + (CASE WHEN attribute4 = NULL OR attribute4 = '' THEN customer_code ELSE attribute4 END) 
	                 = @v_shipto;
			    
				SET @n_sum_qty = @n_sum_qty - @n_qty; -- 할당 후 잔여 qty 차감
					 
              END	  

	 	     FETCH NEXT FROM CUR_ALLOC_ITEM INTO  @v_shipto, @n_qty
	      END -- OPEN CUR_ALLOC_ITEM;
		
	      CLOSE CUR_ALLOC_ITEM;
	      DEALLOCATE CUR_ALLOC_ITEM;
	      ----------------------------------------
          -- Soldto 별 할당 처리 : END
	      ----------------------------------------

	 	 FETCH NEXT FROM CUR_ALLOC INTO  @v_soldto, @n_sum_qty
	  END -- OPEN CUR_ALLOC;
		
	  CLOSE CUR_ALLOC;
	  DEALLOCATE CUR_ALLOC;
	  -------------------------------------------------------------------------
      -- 3. Sum(위탁보충 수량, 위탁출고 수량) > 0일 경우 : 대용량 Qty 순으로 Qty 할당 : END
	  -------------------------------------------------------------------------

	  -------------------------------------------------------------------------
	  
	  -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	  DECLARE CUR_MAT_PO CURSOR FOR
	  SELECT ifseqno 
	  FROM  xif_erp_customer_consign_stock_r_sn_temp$ WITH(NOLOCK) -- 20220330 PJ20216891 : GM JV 가상 Division 추가 xif_erp_customer_consign_stock_r_sn
	  WHERE transfer_flag = 'P'
      AND   ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
	  GROUP BY ifseqno
	  ORDER BY ifseqno ASC;

	  -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
	  IF OBJECT_ID('dbo.scm_dnm_stock_customer_consign_temp$') IS NOT NULL DROP TABLE scm_dnm_stock_customer_consign_temp$
	  
	  SELECT * INTO dbo.scm_dnm_stock_customer_consign_temp$
	  FROM dbo.scm_dnm_stock_customer_consign WITH(NOLOCK)
	  WHERE company_id+division_id+origin_item_id+item_id+result_date+customer_code 
	      IN
	       (SELECT company_id+division_id+item_id+dbo.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id)+result_date+customer_code 
	        FROM xif_erp_customer_consign_stock_r_sn_temp$ WITH(NOLOCK) -- 20220330 PJ20216891 : GM JV 가상 Division 추가 xif_erp_customer_consign_stock_r_sn
	        WHERE transfer_flag = 'P'
            AND   ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
	       ); --2018.06.27

		 OPEN CUR_MAT_PO;
		 FETCH NEXT FROM CUR_MAT_PO INTO @v_ifseqno ;
		 
		 WHILE (@@FETCH_STATUS = 0)
		 BEGIN
		   
			 MERGE INTO [dbo].[scm_dnm_stock_customer_consign] A
			 USING ( 
					SELECT /* PR_SCM_DNM_STOCK_CUSTOMER_CONSIGN */ 
						   A.company_id AS company_id
						  ,CONVERT(char(8),DATEADD(day,-1,result_date),112) AS result_date -- 2018. 05 .25
						  ,A.division_id AS division_id
						  ,'' AS scm_site_id  -- 추후 수정 예정
						  ,C.site_id AS site_id
						  ,A.plant_id AS plant_id
						  ,item_id origin_item_id  --2018.07.20
						  ,item_name
						  ,customer_code
						  ,customer_name
						  ,ISNULL(qty,0) qty
						  ,ISNULL(origin_qty,0) origin_qty  -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : origin_qty 추가
						  ,uom
						  ,dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, item_id) item_id --2018.06.27 , 2018.07.20

						  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
						  ,(CASE WHEN attribute2 = NULL OR attribute2 = '' THEN '-' ELSE attribute2 END) AS attribute2	-- Final Soldto Code :: scm_dnm_stock_customer_consign.FINAL_SOLDTO_CODE
						  ,attribute3	                                                                                -- 판매처 이름       :: scm_dnm_stock_customer_consign.FINAL_SOLDTO_NAME
						  ,(CASE WHEN attribute4 = NULL OR attribute4 = '' THEN '-' ELSE attribute4 END) AS attribute4	-- Final Shipto Code :: scm_dnm_stock_customer_consign.FINAL_SHIPTO_CODE
						  ,attribute5	                                                                                -- 최종 인도처 이름  :: scm_dnm_stock_customer_consign.FINAL_SHIPTO_NAME
						  ,(CASE WHEN attribute6 = NULL OR attribute6 = '' THEN '-' ELSE attribute6 END) AS attribute6	-- 판매오더번호      :: scm_dnm_stock_customer_consign.SALES_ORDER_NO
						  ,(CASE WHEN attribute7 = NULL OR attribute7 = '' THEN '-' ELSE attribute7 END) AS attribute7	-- 품목번호          :: scm_dnm_stock_customer_consign.SALES_ORDER_SEQ
						  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end

					FROM  xif_erp_customer_consign_stock_r_sn_temp$ A WITH(NOLOCK) -- 20220330 PJ20216891 : GM JV 가상 Division 추가 xif_erp_customer_consign_stock_r_sn
					/*  INNER JOIN scm_mst_site_customer B
					  ON	A.division_id   =  B.division_id
					  AND   A.customer_code =  B.soldto_code
					  AND   A.customer_code =  B.shipto_code*/
						  INNER JOIN scm_mst_plant_sn C
						  ON    A.company_id	=  C.company_id
						  AND	A.division_id	=  C.division_id
						  AND	A.plant_id		=  C.plant_id
				    WHERE ifseqno = @v_ifseqno
					AND   transfer_flag = 'P'
                    AND   ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가

					) B
			ON (       A.company_id     =  B.company_id
				   AND A.division_id	=  B.division_id
				   AND A.site_id		=  B.site_id
				   AND A.plant_id	    =  B.plant_id
				   AND A.origin_item_id =  B.origin_item_id  --2018.06.27 , 2018.07.20
				   AND A.result_date	=  B.result_date
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
							 A.scm_site_id		=  B.scm_site_id
							,A.item_id			=  B.item_id --2018.06.27
							,A.item_name		=  B.item_name
							,A.customer_name	=  B.customer_name
							,A.qty				=  B.qty
							,A.attribute1		=  B.origin_qty  -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : origin_qty 추가
							,A.attribute2       =  B.qty         -- 2025.04.02	kimcd PJ20249548R 매출 이력 차감에 사용될 attribute2 수량 설정
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
						,scm_site_id

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

						,attribute1  -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : origin_qty 추가
						,attribute2  -- 2025.04.02	kimcd PJ20249548R 매출 이력 차감에 사용될 attribute2 수량 설정
						)
				 VALUES (   
						 B.company_id
						,B.division_id
						,B.site_id
						,B.plant_id
						,B.item_id --2018.06.27 , 2018.07.20
						,B.origin_item_id --2018.06.27 , 2018.07.20
						,B.result_date
						,B.item_name
						,B.customer_code
						,B.customer_name
						,B.qty
						,B.uom
						,'Y'
						,B.scm_site_id

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

						,B.origin_qty  -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : origin_qty 추가	
						,B.qty         -- 2025.04.02	kimcd PJ20249548R 매출 이력 차감에 사용될 attribute2 수량 설정
						)
			;			

			 -----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @n_log_count = @@ROWCOUNT;
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO scm_dnm_stock_customer_consign';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

			FETCH NEXT FROM CUR_MAT_PO INTO  @v_ifseqno
			END
		
		CLOSE CUR_MAT_PO;
		DEALLOCATE CUR_MAT_PO; 		

		-- * 2021.01.06   KSW            C20210105-000744 Consignment 재고의 Ship-To와 Sold-To 적용을 위한 재고 반영 로직 변경 - start
		-- PR_SCM_DNM_SO_STOCK_CUTOFF 에서 차용한 매핑로직 추가    
		-- Sales Site Mapping
		UPDATE scm_dnm_stock_customer_consign
        SET    scm_site_id = cus.scm_site_id
              ,last_update_date = getdate()
			  ,last_updated_by  = '3. Sales Site Mapping'
        FROM   scm_dnm_stock_customer_consign sr  WITH(NOLOCK)
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
        WHERE  ISNULL(sr.scm_site_id, '') = '';

		UPDATE scm_dnm_stock_customer_consign
        SET    scm_site_id   =  B.scm_site_id
              ,last_update_date = GETDATE()
		   	  ,last_updated_by  = '4. Sales Site Mapping'
        FROM   scm_dnm_stock_customer_consign A WITH(NOLOCK)
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
        WHERE  ISNULL(A.scm_site_id, '') = '';

        -- shipto code 기준으로 sales site id가 한건만 있으면 그 site로 mapping - Plant Site
        UPDATE scm_dnm_stock_customer_consign
        SET    scm_site_id = cus.scm_site_id
              ,last_update_date = getdate()
			  ,last_updated_by  = '1. To Site Mapping'
        FROM   scm_dnm_stock_customer_consign sr  WITH(NOLOCK)
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
        AND    (CASE WHEN sr.final_shipto_code = '-' THEN sr.customer_code ELSE sr.final_shipto_code END) = cus.shipto_code
        WHERE  ISNULL(sr.scm_site_id, '') = '';

        -- shipto code 기준으로 sales site id가 여러건 있으면 MAX site로 mapping - Sales Site
        UPDATE scm_dnm_stock_customer_consign
        SET    scm_site_id = cus.scm_site_id
              ,last_update_date = getdate()
			  ,last_updated_by  = '2. To Site Mapping'
        FROM   scm_dnm_stock_customer_consign sr  WITH(NOLOCK)
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
        AND    (CASE WHEN sr.final_shipto_code = '-' THEN sr.customer_code ELSE sr.final_shipto_code END) = cus.shipto_code
        WHERE  ISNULL(sr.scm_site_id, '') = '';
		-- * 2021.01.06   KSW            C20210105-000744 Consignment 재고의 Ship-To와 Sold-To 적용을 위한 재고 반영 로직 변경 - end

		
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		 SET @n_history_seq = NEXT VALUE FOR seq1_scm_dnm_stock_customer_consign_h
		 INSERT INTO [dbo].[scm_dnm_stock_customer_consign_h] (
						       history_seq
						      ,company_id
							  ,division_id
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
							  ,scm_site_id
							  ,valid_yn

							  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
							  ,FINAL_SOLDTO_CODE
							  ,FINAL_SOLDTO_NAME
							  ,FINAL_SHIPTO_CODE
							  ,FINAL_SHIPTO_NAME
							  ,SALES_ORDER_NO
							  ,SALES_ORDER_SEQ
							  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end
							  ,attribute1 -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : origin_qty 추가
							  ,attribute2 -- 2025.04.02	kimcd PJ20249548R 매출 이력 차감에 사용될 attribute2 수량 설정
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
	        FROM (
					SELECT A.*,B.creation_date,B.last_update_date 
					FROM (SELECT /* scm_dnm_stock_customer_consign_h */
							   company_id
							  ,division_id
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
							  ,scm_site_id
							  ,valid_yn

							  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
							  ,FINAL_SOLDTO_CODE
							  ,FINAL_SOLDTO_NAME
							  ,FINAL_SHIPTO_CODE
							  ,FINAL_SHIPTO_NAME
							  ,SALES_ORDER_NO
							  ,SALES_ORDER_SEQ
							  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end
							  ,attribute1 -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : origin_qty 추가
							  ,attribute2 -- 2025.04.02	kimcd PJ20249548R 매출 이력 차감에 사용될 attribute2 수량 설정

					FROM [dbo].[scm_dnm_stock_customer_consign_temp$] WITH(NOLOCK)
					EXCEPT
					SELECT /* scm_dnm_stock_customer_consign_h */
						       company_id
							  ,division_id
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
							  ,scm_site_id
							  ,valid_yn

							  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
							  ,FINAL_SOLDTO_CODE
							  ,FINAL_SOLDTO_NAME
							  ,FINAL_SHIPTO_CODE
							  ,FINAL_SHIPTO_NAME
							  ,SALES_ORDER_NO
							  ,SALES_ORDER_SEQ
							  -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end
							  ,attribute1 -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : origin_qty 추가
							  ,attribute2 -- 2025.04.02	kimcd PJ20249548R 매출 이력 차감에 사용될 attribute2 수량 설정

				    FROM [dbo].[scm_dnm_stock_customer_consign] WITH(NOLOCK)
					WHERE company_id+division_id+origin_item_id+result_date+customer_code 
					   IN
						(SELECT company_id+division_id+item_id+result_date+customer_code 
						 FROM xif_erp_customer_consign_stock_r_sn_temp$ WITH(NOLOCK) -- 20220330 PJ20216891 : GM JV 가상 Division 추가 xif_erp_customer_consign_stock_r_sn
						 WHERE transfer_flag = 'P'
						 AND   ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
						)
				) A 
				INNER JOIN [dbo].[scm_dnm_stock_customer_consign_temp$] B WITH(NOLOCK)
				ON  A.company_id     =  B.company_id
				AND A.division_id	=  B.division_id
				AND A.site_id		=  B.site_id
				AND A.plant_id	    =  B.plant_id
				AND A.item_id		=  B.item_id
				AND A.result_date	=  B.result_date
				AND A.customer_code  =  B.customer_code

				-- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - start
				-- 변경전
				-- AND A.origin_item_id	=  B.origin_item_id ) A
				-- 변경후
				--
				AND A.origin_item_id	 =  B.origin_item_id
			    AND A.FINAL_SOLDTO_CODE  =  B.FINAL_SOLDTO_CODE
			    AND A.FINAL_SHIPTO_CODE  =  B.FINAL_SHIPTO_CODE
			    AND A.SALES_ORDER_NO     =  B.SALES_ORDER_NO
				AND A.SALES_ORDER_SEQ    =  B.SALES_ORDER_SEQ
			    -- 2020.12.09 KSW C20201209-000181 'Salse Order Reserved Stock' IF 컬럼 추가 및 SCM Site ID Mapping 변경 - end
				AND A.attribute1         =  B.attribute1 -- 20221006 PJ20216894 : Qty 기준 후처리 개선 : origin_qty 추가
			 ) A


		
		-- 처리 한 row 마킹
		UPDATE [dbo].[xif_erp_customer_consign_stock_r_sn]
		SET transfer_flag = 'Y' 
		WHERE transfer_flag = 'P'
        AND   ISNULL(attribute1, '') IN ('A', '') -- 20181121 고객 위탁 재고 조건 추가
		
		DROP TABLE dbo.scm_dnm_stock_customer_consign_temp$;
		DROP TABLE dbo.xif_erp_customer_consign_stock_r_sn_temp$;
		
        -- HISTORY LOG
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'HISTORY';
        SET @v_log_message = 'INSERT INTO scm_dnm_stock_customer_consign_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

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
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  
	  /*************************************
	  -- 20181121 SO Stock 처리 프로그램 Call
	  *************************************/
	  EXEC PR_SCM_DNM_SO_STOCK_CUTOFF;

    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	/*************************************
	-- 20181121 SO Stock 처리 프로그램 Call
	*************************************/
	EXEC PR_SCM_DNM_SO_STOCK_CUTOFF;

  END;
