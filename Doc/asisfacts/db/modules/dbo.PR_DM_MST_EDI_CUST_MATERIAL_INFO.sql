
/*
 * Program ID   : PR_DM_MST_EDI_CUST_MATERIAL_INFO
 * Description  : BMW EDI 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 06. 1    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_EDI_CUST_MATERIAL_INFO]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_EDI_CUST_MATERIAL_INFO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_history_seq		BIGINT;
	DECLARE @v_ifseqno     NVARCHAR(30); -- 누락된 전체 데이터 insert

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY	
      BEGIN
	    --BEGIN TRANSACTION
		-- 인터페이스 테이블 처리 ROW UPDATE
	    UPDATE xif_erp_edi_cust_material_info_r_sn 
		SET    transfer_flag = 'P'
		WHERE  ISNULL(transfer_flag,'N') = 'N'

		-- 지나간 배치까지 적용하기 위해 Cursor 로 처리
		DECLARE CUR_EDI_CUST_MATERIAL_INFO CURSOR FOR
		  
		SELECT ifseqno
		FROM   xif_erp_edi_cust_material_info_r_sn WITH(NOLOCK)
		WHERE  transfer_flag = 'P'
		GROUP BY ifseqno
		ORDER BY ifseqno ASC;

		/*
		-- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
		IF OBJECT_ID('dbo.dm_mst_edi_cust_material_info_temp$') IS NOT NULL 
		  DROP TABLE dm_mst_edi_cust_material_info_temp$

		SELECT * 
		INTO [dbo].dm_mst_edi_cust_material_info_temp$
		FROM [dbo].dm_mst_edi_cust_material_info WITH(NOLOCK);
		*/
		OPEN CUR_EDI_CUST_MATERIAL_INFO;
		FETCH NEXT FROM CUR_EDI_CUST_MATERIAL_INFO INTO @v_ifseqno ;

		WHILE (@@FETCH_STATUS = 0)
		  BEGIN
		 
		  MERGE INTO [dbo].[dm_mst_edi_cust_material_info] A		
		  USING (
		         SELECT  company_id
						,sales_org
						,distribution_channel
						,customer_code
						,item_id
						,customer_item_id
						,customer_item_name
				 FROM   xif_erp_edi_cust_material_info_r_sn WITH(NOLOCK)
				 WHERE  ifseqno			   = @v_ifseqno	
				 AND    transfer_flag		   = 'P'

				) B
		  ON(     
					  A.company_id			=  B.company_id
			      AND A.sales_org			=  B.sales_org
				  AND A.distribution_channel=  B.distribution_channel	
				  AND A.customer_code		=  B.customer_code
				  AND A.item_id				=  B.item_id		  
		    )
		  WHEN MATCHED THEN
		     UPDATE SET 
						A.customer_item_id    =  B.customer_item_id 
					   ,A.customer_item_name  =  B.customer_item_name 
					   ,A.valid_yn			  =  'Y'
					   ,A.last_updated_by	  =  @v_batch_user
                       ,A.last_update_date	  =  GETDATE()
					                
		  WHEN NOT MATCHED THEN
			 INSERT (  
			             company_id
						,sales_org
						,distribution_channel
						,customer_code
						,item_id
						,customer_item_id
						,customer_item_name
					    ,valid_yn
						,created_by
						,creation_date
						,last_updated_by
						,last_update_date
					)
			 VALUES (   
						 B.company_id
						,B.sales_org
						,B.distribution_channel
						,B.customer_code
						,B.item_id
						,B.customer_item_id
						,B.customer_item_name
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
              SET @v_log_message = 'MERGE INTO dm_mst_edi_cust_material_info';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		FETCH NEXT FROM CUR_EDI_CUST_MATERIAL_INFO INTO  @v_ifseqno
		END

		CLOSE CUR_EDI_CUST_MATERIAL_INFO;
		DEALLOCATE CUR_EDI_CUST_MATERIAL_INFO; 

		/*
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리

		SET @n_history_seq = NEXT VALUE FOR SEQ1_dm_mst_edi_cust_material_info_H
			
			INSERT INTO [dbo].[dm_mst_edi_cust_material_info_h] (
			   history_seq
			  ,division_id
			  ,soldto_code
			  ,shipto_code
			  ,soldto_description
			  ,soldto_address
			  ,city -- 2018. 05. 23
			  ,soldto_country
			  ,soldto_region
			  ,soldto_region_name
			  ,soldto_city_name
			  ,shipto_description
			  ,shipto_address
			  ,shipto_country
			  ,shipto_region
			  ,shipto_region_name
			  ,shipto_city_name
			  ,valid_yn
			  ,creation_date
			  ,last_update_date
			  ,last_updated_by
			  ,created_by
			  ,history_creation_date		
		   )
			SELECT    @n_history_seq
					  ,A.*
					  ,@v_batch_user
					  ,@v_batch_user
					  ,GETDATE()
			FROM 
				  (
				 SELECT A.*,B.last_update_date FROM (
				 SELECT
					   division_id
					  ,soldto_code
					  ,shipto_code
					  ,soldto_description
					  ,soldto_address
					  ,city -- 2018. 05. 23
					  ,soldto_country
					  ,soldto_region
					  ,soldto_region_name
					  ,soldto_city_name
					  ,shipto_description
					  ,shipto_address
					  ,shipto_country
					  ,shipto_region
					  ,shipto_region_name
					  ,shipto_city_name
					  ,valid_yn
					  ,creation_date
				  FROM [dbo].[dm_mst_edi_cust_material_info_temp$]
				  EXCEPT
				  SELECT
					   division_id
					  ,soldto_code
					  ,shipto_code
					  ,soldto_description
					  ,soldto_address
					  ,city -- 2018. 05. 23
					  ,soldto_country
					  ,soldto_region
					  ,soldto_region_name
					  ,soldto_city_name
					  ,shipto_description
					  ,shipto_address
					  ,shipto_country
					  ,shipto_region
					  ,shipto_region_name
					  ,shipto_city_name
					  ,valid_yn
					  ,creation_date
				  FROM [dbo].[dm_mst_edi_cust_material_info]
				  ) A INNER JOIN [dbo].[dm_mst_edi_cust_material_info_temp$] B
				  ON  A.division_id = B.division_id
				  AND A.soldto_code = B.soldto_code
				  AND A.shipto_code = B.shipto_code

				  ) A

		DROP TABLE dm_mst_edi_cust_material_info_temp$;
				-- HISTORY LOG
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO dm_mst_edi_cust_material_info_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_batch_user, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		*/
		-- 처리 한 row 마킹
		UPDATE xif_erp_edi_cust_material_info_r_sn 
		SET transfer_flag = 'Y' 
		WHERE transfer_flag = 'P';
		
        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END;
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
