
CREATE PROCEDURE [dbo].[PR_SCM_DNM_MAT_PO]
AS
/*
 * Program ID   : PR_SCM_DNM_MAT_PO
 * Description  : 자재 PO I/F
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 22    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.26     Kim Jaejung	   소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 * 2018.07.20	  Kim Jaejung      소형 대표 ITEM_ID 변경 시 update 로직 적용 (소형)
 * 2022.03.30     KSG              PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
 * 2023.03.23	  hrkim		       [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 *
 */

  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_MAT_PO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	  -- 인터페이스 테이블 처리 ROW UPDATE
		UPDATE [dbo].[xif_erp_mat_po_r_sn]
		SET    transfer_flag = 'P'
		WHERE  ISNULL(transfer_flag,'N') = 'N';

      -------------------------------------------------------------------------
	  -- 20220330 PJ20216891 : GM JV 가상 Division 추가
	  -- 처리대상 Temp Table 생성
	  -------------------------------------------------------------------------
      IF OBJECT_ID('dbo.xif_erp_mat_po_r_sn_temp$') IS NOT NULL DROP TABLE xif_erp_mat_po_r_sn_temp$

      SELECT * 
      INTO   xif_erp_mat_po_r_sn_temp$
      FROM   xif_erp_mat_po_r_sn WITH(NOLOCK)
	  WHERE  transfer_flag = 'P'
	 
	  -- GM JV : division Size 변경
      ALTER TABLE xif_erp_mat_po_r_sn_temp$ ALTER COLUMN division_id NVARCHAR(10) NULL;

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
	    FROM xif_erp_mat_po_r_sn_temp$ TGT
			INNER JOIN JV_PLANT JP WITH(NOLOCK)
				    ON JP.DIVISION_ID = TGT.DIVISION_ID
				   AND JP.COMPANY_ID  = TGT.COMPANY_ID
	   WHERE 1=1

	  /*
	  -- GM JV division 처리
	  UPDATE xif_erp_mat_po_r_sn_temp$
	  SET    division_id = CASE WHEN company_id = 'G670' THEN '81_UC'
                                ELSE division_id
						   END */
      -------------------------------------------------------------------------
	  -------------------------------------------------------------------------
	  
	  -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	  DECLARE CUR_MAT_PO CURSOR FOR
	    SELECT ifseqno 
	    FROM   xif_erp_mat_po_r_sn_temp$ WITH(NOLOCK) -- 20220330 PJ20216891 : GM JV 가상 Division 추가  xif_erp_mat_po_r_sn
	    WHERE  transfer_flag = 'P'
	    GROUP BY ifseqno
	    ORDER BY ifseqno ASC;

	  -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
	  IF OBJECT_ID('dbo.scm_dnm_mat_po_temp$') IS NOT NULL DROP TABLE scm_dnm_mat_po_temp$
	  	  
	  SELECT * 
	  INTO   dbo.scm_dnm_mat_po_temp$
	  FROM   dbo.scm_dnm_mat_po WITH(NOLOCK)
	  WHERE  company_id+po_no+po_item_seq IN (SELECT company_id+po_no+po_item_seq 
	                                          FROM   xif_erp_mat_po_r_sn_temp$ WITH(NOLOCK)  -- 20220330 PJ20216891 : GM JV 가상 Division 추가  xif_erp_mat_po_r_sn
											  WHERE  transfer_flag = 'P');

	  OPEN CUR_MAT_PO;
	  FETCH NEXT FROM CUR_MAT_PO INTO @v_ifseqno ;
		 
	    WHILE (@@FETCH_STATUS = 0)
		  BEGIN
		   
			MERGE INTO [dbo].[scm_dnm_mat_po] A
			USING ( 
					SELECT /* PR_SCM_DNM_MAT_PO */ 
						   company_id
						  ,po_no
						  ,po_item_seq
						  ,division_id
						  ,vendor_code
						  ,vendor_name
						  ,etd_date
						  ,eta_date
						  ,plant_id
						  ,storage_id
						  ,item_id origin_item_id --2018.07.20
						  ,item_name
						  ,ISNULL(order_qty,0) order_qty
						  ,ISNULL(receipt_qty,0) receipt_qty
						  ,ISNULL(remain_qty,0) remain_qty
						  ,valid_yn
						  ,uom
						  ,dbo.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id) item_id --2018.06.26 , 2018.07.20
					  FROM  xif_erp_mat_po_r_sn_temp$ A WITH(NOLOCK) -- 20220330 PJ20216891 : GM JV 가상 Division 추가  xif_erp_mat_po_r_sn
					  WHERE ifseqno = @v_ifseqno
					  AND   transfer_flag = 'P'

					) B
			ON (       A.company_id     =  B.company_id
				   AND A.po_no			=  B.po_no
				   AND A.po_item_seq    =  B.po_item_seq

			   )
			WHEN MATCHED THEN
				 UPDATE SET 
							 
							 A.division_id		=  B.division_id
							,A.vendor_code		=  B.vendor_code
							,A.vendor_name		=  B.vendor_name
							,A.etd_date			=  B.etd_date
							,A.eta_date			=  B.eta_date
							,A.plant_id			=  B.plant_id
							,A.storage_id		=  B.storage_id
							,A.item_id			=  B.item_id --2018.06.26 , 2018.07.20
							,A.origin_item_id	=  B.origin_item_id --2018.06.26 , 2018.07.20
							,A.item_name		=  B.item_name
							,A.order_qty		=  B.order_qty
							,A.receipt_qty		=  B.receipt_qty
							,A.remain_qty		=  B.remain_qty
							,A.valid_yn			=  B.valid_yn
							,A.uom				=  B.uom
							,A.last_updated_by	=  @v_batch_user
							,A.last_update_date	=  GETDATE()
					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				               company_id
							  ,po_no
							  ,po_item_seq
							  ,division_id
							  ,vendor_code
							  ,vendor_name
							  ,etd_date
							  ,eta_date
							  ,plant_id
							  ,storage_id
							  ,item_id
							  ,origin_item_id --2018.06.26
							  ,item_name
							  ,order_qty
							  ,receipt_qty
							  ,remain_qty
							  ,uom
							  ,valid_yn
					          ,created_by
						      ,creation_date
						      ,last_updated_by
						      ,last_update_date						  								
						)
				 VALUES (   
							 B.company_id
							,B.po_no
							,B.po_item_seq
							,B.division_id
							,B.vendor_code
							,B.vendor_name
							,B.etd_date
							,B.eta_date
							,B.plant_id
							,B.storage_id
							,B.item_id --2018.06.26 , 2018.07.20
							,B.origin_item_id --2018.06.26 , 2018.07.20
							,B.item_name
							,B.order_qty
							,B.receipt_qty
							,B.remain_qty
							,B.uom
							,B.valid_yn
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
              SET @v_log_message = 'MERGE INTO scm_dnm_mat_po';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

			FETCH NEXT FROM CUR_MAT_PO INTO  @v_ifseqno
			END
		
		CLOSE CUR_MAT_PO;
		DEALLOCATE CUR_MAT_PO; 
		
		
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		 SET @n_history_seq = NEXT VALUE FOR seq1_scm_dnm_mat_po_h
		 INSERT INTO [dbo].[scm_dnm_mat_po_h] (
						       history_seq
						      ,company_id
							  ,po_no
							  ,po_item_seq
							  ,division_id
							  ,vendor_code
							  ,vendor_name
							  ,etd_date
							  ,eta_date
							  ,plant_id
							  ,storage_id
							  ,item_id
							  ,origin_item_id --2018.06.26
							  ,item_name
							  ,order_qty
							  ,receipt_qty
							  ,remain_qty
							  ,uom
							  ,valid_yn
						      ,creation_date
						      ,last_update_date
						      ,created_by					
						      ,last_updated_by	
						      ,history_creation_date
					  )
				 SELECT @n_history_seq
			       ,A.*
				   ,@v_batch_user
				   ,@v_batch_user
				   ,GETDATE()
	        FROM (
					SELECT A.*,B.creation_date,B.last_update_date FROM (SELECT /* scm_dnm_mat_po_h */
						     company_id
							  ,po_no
							  ,po_item_seq
							  ,division_id
							  ,vendor_code
							  ,vendor_name
							  ,etd_date
							  ,eta_date
							  ,plant_id
							  ,storage_id
							  ,item_id
							  ,origin_item_id --2018.06.26
							  ,item_name
							  ,order_qty
							  ,receipt_qty
							  ,remain_qty
							  ,uom
							  ,valid_yn
					FROM [dbo].[scm_dnm_mat_po_temp$] WITH(NOLOCK)
					EXCEPT
					SELECT /* scm_dnm_mat_po_h */
						       company_id
							  ,po_no
							  ,po_item_seq
							  ,division_id
							  ,vendor_code
							  ,vendor_name
							  ,etd_date
							  ,eta_date
							  ,plant_id
							  ,storage_id
							  ,item_id
							  ,origin_item_id --2018.06.26
							  ,item_name
							  ,order_qty
							  ,receipt_qty
							  ,remain_qty
							  ,uom
							  ,valid_yn
				    FROM [dbo].[scm_dnm_mat_po] WITH(NOLOCK)
					WHERE company_id+po_no+po_item_seq IN 
				    (SELECT company_id+po_no+po_item_seq FROM xif_erp_mat_po_r_sn_temp$ WITH(NOLOCK) WHERE transfer_flag = 'P')) A -- 20220330 PJ20216891 : GM JV 가상 Division 추가  xif_erp_mat_po_r_sn
					INNER JOIN [dbo].[scm_dnm_mat_po_temp$] B WITH(NOLOCK)
				    ON  A.company_id     =  B.company_id
				    AND A.po_no			 =  B.po_no
				    AND A.po_item_seq    =  B.po_item_seq ) A
		
		-- 처리 한 row 마킹
		UPDATE [dbo].[xif_erp_mat_po_r_sn]
		SET    transfer_flag = 'Y' 
		WHERE  transfer_flag = 'P'
		
        -- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_dnm_mat_po_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 순차적 호출을 위함
		EXEC PR_SCM_DNM_INTRANSIT;
	
        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;
		 DROP TABLE dbo.scm_dnm_mat_po_temp$;
         DROP TABLE xif_erp_mat_po_r_sn_temp$;
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
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
