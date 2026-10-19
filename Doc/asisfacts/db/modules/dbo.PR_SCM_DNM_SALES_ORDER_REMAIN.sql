
CREATE PROCEDURE [dbo].[PR_SCM_DNM_SALES_ORDER_REMAIN]
AS
/*
 * Program ID   : PR_SCM_DNM_SALES_ORDER_REMAIN
 * Description  : Sales Order 잔량 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.04   Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022.03.30   KSG              PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division : 실제로는 수행 안 되고 있음
 * 2023.03.23	hrkim		     PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 * 
 */
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_SALES_ORDER_REMAIN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_history_seq	BIGINT;
	DECLARE @v_ifseqno  NVARCHAR(50);


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
		  /*
		  --UPDATE [dbo].[xif_erp_sales_order_remain_r_sn] 
          --SET    attribute15 = 'P'
	      --       -- 20220330 PJ20216891 GM JV 가상 Division 추가
          --     , division = CASE WHEN company = 'G670' THEN '81_UC'
		  --                       ELSE division
		  --                  END
		  --WHERE ISNULL(attribute15,'N') = 'N'
		  */
	     -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - HM JV 가상 사업부 추가 반영
	     ;WITH JV_PLANT AS (
			    SELECT JP.SEGMENT1		AS DIVISION_ID
	   				  ,JP.SEGMENT3		AS COMPANY_ID
	   				  ,MAX(JP.SEGMENT4)	AS DIVISION_ID_JV
	   			 FROM SCM_ADM_LOOKUP_MASTER_DETAIL JP WITH(NOLOCK)
	   			WHERE 1=1
	   			  AND JP.LOOKUP_TYPE = 'JV_PLANT'
	   			  AND JP.VALID_YN    = 'Y'
	   			GROUP BY JP.SEGMENT1
	   					,JP.SEGMENT3
	     )
	     UPDATE TGT 
	        SET TGT.DIVISION	= JP.DIVISION_ID_JV
	   		   ,TGT.attribute15	= 'P'
	       FROM [dbo].[xif_erp_sales_order_remain_r_sn]  TGT
	   		INNER JOIN JV_PLANT JP WITH(NOLOCK)
	   			    ON JP.DIVISION_ID = TGT.DIVISION
	   			   AND JP.COMPANY_ID  = TGT.COMPANY
	      WHERE ISNULL(TGT.attribute15,'N') = 'N';	  
	   
		  -- 지나간 배치까지 적용하기 위해 Cursor 로 처리

		  DECLARE CUR_SALES_REMAIN CURSOR FOR
		  SELECT ifseqno
		  FROM  [dbo].[xif_erp_sales_order_remain_r_sn]  WITH(NOLOCK)
		  WHERE attribute15 = 'P'
		  GROUP BY ifseqno
		  ORDER BY ifseqno ASC;

		 -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
		 IF OBJECT_ID('dbo.scm_dnm_sales_order_remain_temp$') IS NOT NULL DROP TABLE scm_dnm_sales_order_remain_temp$
		  

		  -- 데이터가 누적 되기 때문에, history 비교 시 변경 대상이 되는 row 로만 temp table 생성
		 SELECT * INTO [dbo].scm_dnm_sales_order_remain_temp$
		 FROM [dbo].scm_dnm_sales_order_remain WITH(NOLOCK)
		 WHERE order_no+order_item_seq+company_id+division_id+item_id+result_yyyymmdd IN
		 (SELECT so_no+order_item_seq+company+division+item_id+trnf_date FROM xif_erp_sales_order_remain_r_sn WITH(NOLOCK) WHERE attribute15 = 'P');

		 OPEN CUR_SALES_REMAIN;
		 FETCH NEXT FROM CUR_SALES_REMAIN INTO @v_ifseqno ;
	  
		 WHILE (@@FETCH_STATUS = 0)
		 BEGIN
	  
         MERGE INTO [dbo].[scm_dnm_sales_order_remain] A
		 USING ( 
				SELECT /* PR_SCM_DNM_SALES_ORDER_REMAIN */
					   so_no
					  ,so_seq as order_item_seq
					  ,(SELECT MAX(site_id) FROM dbo.scm_mst_plant_sn WHERE plant_id = a.plant_id) AS site_id
					  ,'' AS scm_site_id
					  ,order_type
					  ,order_type_name
					  ,company
					  ,division
					  ,plant_id
					  ,sloc
					  ,order_create_date
					  ,po_no
					  ,billto_code
					  ,bilto_name
					  ,shipto_code
					  ,shipto_name
					  ,delivery_date
					  ,delivery_no
					  ,delivery_partno as delivery_item_seq
					  ,project_cd AS project_code
					  ,item_id
					  ,item_name
					  ,ISNULL(cast(order_qty as numeric(20,10)),0) AS order_qty
					  ,uom
					  ,ISNULL(cast(complete_qty as numeric(20,10)),0) AS complete_qty
					  ,on_board_date
					  ,etd
					  ,eta
					  ,ISNULL(remain_qty,0) remain_qty
					  ,trnf_date as result_yyyymmdd 
				FROM [dbo].[xif_erp_sales_order_remain_r_sn] A WITH(NOLOCK)
			    WHERE A.ifseqno     = @v_ifseqno

				) B
		ON(
		               A.order_no		   =  B.so_no
				   AND A.order_item_seq    =  B.order_item_seq
				   AND A.company_id		   =  B.company
				   AND A.division_id	   =  B.division
				   AND A.item_id           =  B.item_id  
				   AND A.result_yyyymmdd   =  B.result_yyyymmdd 
				   
		   )
		WHEN MATCHED THEN
			 UPDATE SET 
					  A.po_no                       =  B.po_no
					 ,A.site_id						=  B.site_id
					 ,A.plant_id					=  B.plant_id
					 ,A.delivery_item_seq		    =  B.delivery_item_seq
					 ,A.delivery_no					=  B.delivery_no
					 ,A.scm_site_id					=  B.scm_site_id
					 ,A.scm_site_mapping_yn			=  'N'
					 ,A.project_code				=  B.project_code
					 ,A.order_qty                   =  B.order_qty
					 ,A.soldto_code                 =  B.billto_code
					 ,A.soldto_name                 =  B.bilto_name
					 ,A.shipto_name                 =  B.shipto_name			 
					 ,A.order_type_code             =  B.order_type
					 ,A.order_type_name             =  B.order_type_name
					 ,A.storage_id                  =  B.sloc
					 ,A.order_create_date           =  B.order_create_date
				     ,A.shipto_code				    =  B.shipto_code 
					 ,A.delivery_posting_date       =  B.delivery_date			 
					 ,A.item_name                   =  B.item_name
					 ,A.uom                         =  B.UOM
					 ,A.complete_qty                =  B.complete_qty
					 ,A.on_board_date               =  B.on_board_date
					 ,A.etd_date                    =  B.etd
					 ,A.eta_date                    =  B.eta
					 ,A.remain_qty					=  B.remain_qty
					 ,A.last_updated_by				=  @v_batch_user
					 ,A.last_update_date			=  GETDATE()
               
		WHEN NOT MATCHED THEN
			 INSERT (  company_id
					  ,division_id
					  ,site_id
					  ,plant_id
					  ,scm_site_id
					  --,scm_site_mapping_yn
					  ,order_no
					  ,po_no
					  ,project_code
					  ,item_id
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
					  ,complete_qty
					  ,on_board_date
					  ,etd_date
					  ,eta_date
					  ,remain_qty
					  ,result_yyyymmdd
					  ,valid_yn	
					  ,created_by			
					  ,creation_date		
					  ,last_updated_by		
					  ,last_update_date		
					)
			 VALUES (      B.company
						  ,B.division
						  ,B.site_id
						  ,B.plant_id
						  ,B.scm_site_id
						  --,'N'
						  ,B.so_no
						  ,B.po_no
						  ,B.project_code
						  ,B.item_id
						  ,B.order_qty
						  ,B.billto_code
						  ,B.bilto_name
						  ,B.shipto_name
						  ,B.shipto_code
						  ,B.order_item_seq
						  ,B.order_type
						  ,B.order_type_name
						  ,B.sloc
						  ,B.order_create_date
						  ,B.delivery_no
						  ,B.delivery_date
						  ,B.delivery_item_seq
						  ,B.item_name
						  ,B.UOM
						  ,B.complete_qty
						  ,B.on_board_date
						  ,B.etd
						  ,B.eta
						  ,B.remain_qty
						  ,B.result_yyyymmdd
						  ,'Y'
						  ,@v_batch_user 
						  ,GETDATE()      
						  ,@v_batch_user
						  ,GETDATE()

					)
		;
			  -----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO scm_dnm_sales_order_remain';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------
		

		FETCH NEXT FROM CUR_SALES_REMAIN INTO  @v_ifseqno

		END
		
		CLOSE CUR_SALES_REMAIN;
		DEALLOCATE CUR_SALES_REMAIN; 
		
		/* 추후 변경 예정(아마 intransit 과 동일할듯?)
		-- SCM_MST_SITE_ITEM 테이블과 데이터 비교 후 scm_site_id 가 null 인 데이터 업데이트
		UPDATE [dbo].[scm_dnm_sales_order_remain]
		SET scm_site_id	 =  B.scm_site_id
		FROM [dbo].[scm_dnm_sales_order_remain] A WITH(NOLOCK) 
		INNER JOIN [dbo].[scm_mst_site_item] B WITH(NOLOCK)
		ON	A.division_id			=  B.division_id
		AND A.project_code		=  B.project_code
		AND A.item_id				=  B.item_id
		WHERE ISNULL(A.scm_site_id,'') = ''
		AND	B.valid_yn = 'Y';
		
		-- SCM_MST_SITE_ITEM 과 매핑 가능한지 확인
		UPDATE [dbo].[scm_dnm_sales_order_remain]
		SET scm_site_mapping_yn	 =  'Y'
		FROM [dbo].[scm_dnm_sales_order_remain] A WITH(NOLOCK) 
		INNER JOIN [dbo].[scm_mst_site_item] B WITH(NOLOCK)
		ON	A.division_id			=  B.division_id
		AND A.scm_site_id			=  B.scm_site_id
		AND A.item_id				=  B.item_id
		WHERE A.valid_yn = 'Y'
		AND order_no+order_item_seq+company_id+A.division_id+A.item_id+result_yyyymmdd IN
		(SELECT so_no+order_item_seq+company+division+item_id+trnf_date FROM xif_erp_sales_order_remain_r_sn WITH(NOLOCK) WHERE attribute15 = 'P');
		*/
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		SET @n_history_seq = NEXT VALUE FOR seq1_scm_dnm_sales_order_remain_h
		
		INSERT INTO scm_dnm_sales_order_remain_h(
		               history_seq
					  ,company_id
					  ,division_id
					  ,site_id
					  ,plant_id
					  ,scm_site_id
					  ,scm_site_mapping_yn
					  ,order_no
					  ,po_no
					  ,project_code
					  ,item_id
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
					  ,complete_qty
					  ,on_board_date
					  ,etd_date
					  ,eta_date
					  ,remain_qty
					  ,result_yyyymmdd 
					  ,valid_yn	
					  ,creation_date
					  ,last_update_date
					  ,created_by					
					  ,last_updated_by	
					  ,history_creation_date
					)
		    SELECT 
				   @n_history_seq
			       ,A.*
				   ,@v_batch_user
				   ,@v_batch_user
				   ,GETDATE()
		     FROM
			(
			SELECT A.*,B.creation_date,B.last_update_date FROM (SELECT	   company_id
					  ,division_id
					  ,site_id
					  ,plant_id
					  ,scm_site_id
					  ,scm_site_mapping_yn
					  ,order_no
					  ,po_no
					  ,project_code
					  ,item_id
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
					  ,complete_qty
					  ,on_board_date
					  ,etd_date
					  ,eta_date
					  ,remain_qty
					  ,result_yyyymmdd 
					  ,valid_yn
					FROM [dbo].[scm_dnm_sales_order_remain_temp$] WITH(NOLOCK)
					EXCEPT
					SELECT company_id
					  ,division_id
					  ,site_id
					  ,plant_id
					  ,scm_site_id
					  ,scm_site_mapping_yn
					  ,order_no
					  ,po_no
					  ,project_code
					  ,item_id
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
					  ,complete_qty
					  ,on_board_date
					  ,etd_date
					  ,eta_date
					  ,remain_qty
					  ,result_yyyymmdd 
					  ,valid_yn
					FROM [dbo].[scm_dnm_sales_order_remain] WITH(NOLOCK)
					WHERE order_no+order_item_seq+company_id+division_id+item_id+result_yyyymmdd IN
					(SELECT so_no+order_item_seq+company_id+division_id+item_id+trnf_date FROM xif_erp_sales_order_remain_r_sn WITH(NOLOCK) WHERE attribute15 = 'P')) A 
					INNER JOIN [dbo].[scm_dnm_sales_order_remain_temp$] B WITH(NOLOCK)
					ON	A.result_yyyymmdd   =  B.result_yyyymmdd
				    AND A.order_no			=  B.order_no
				    AND A.order_item_seq    =  B.order_item_seq
				    AND A.company_id		=  B.company_id
				    AND A.division_id	    =  B.division_id
				    AND A.item_id           =  B.item_id  ) A

        
	    DROP TABLE scm_dnm_sales_order_remain_temp$;
		
		-- 처리된 ROW 마킹
		UPDATE [dbo].[xif_erp_sales_order_remain_r_sn] 
			SET attribute15 = 'Y'
		  WHERE attribute15 = 'P';
		
		-- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_dnm_sales_order_remain_H';
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
