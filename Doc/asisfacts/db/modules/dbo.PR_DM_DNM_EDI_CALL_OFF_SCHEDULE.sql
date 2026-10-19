/*
 * Program ID   : PR_DM_DNM_EDI_CALL_OFF_SCHEDULE
 * Description  : BMW EDI 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 06. 1    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.12     Kim Jaejung	   PR_DM_BMW_EDI_TO_MKT_FCST 프로시져 호출 로직 추가
 * 20190131 KHSONG 실행되지 않도록 주석처리함/VW EDI방식으로 변경되면서 더이상 사용을 안함
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_DNM_EDI_CALL_OFF_SCHEDULE]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_DNM_EDI_CALL_OFF_SCHEDULE';
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
	    UPDATE xif_erp_edi_call_off_schedule_r_sn 
		SET    transfer_flag = 'P'
		WHERE  ISNULL(transfer_flag,'N') = 'N'

		-- 지나간 배치까지 적용하기 위해 Cursor 로 처리
		DECLARE CUR_EDI_CALL_OFF_SCHEDULE CURSOR FOR
		  
		SELECT ifseqno
		FROM   xif_erp_edi_call_off_schedule_r_sn WITH(NOLOCK)
		WHERE  transfer_flag = 'P'
		GROUP BY ifseqno
		ORDER BY ifseqno ASC;

		/*
		-- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
		IF OBJECT_ID('dbo.dm_dnm_edi_call_off_schedule_r_temp$') IS NOT NULL 
		  DROP TABLE dm_dnm_edi_call_off_schedule_r_temp$

		SELECT * 
		INTO [dbo].dm_dnm_edi_call_off_schedule_r_temp$
		FROM [dbo].dm_dnm_edi_call_off_schedule_r WITH(NOLOCK);
		*/
		OPEN CUR_EDI_CALL_OFF_SCHEDULE;
		FETCH NEXT FROM CUR_EDI_CALL_OFF_SCHEDULE INTO @v_ifseqno ;

		WHILE (@@FETCH_STATUS = 0)
		  BEGIN
		 
		  MERGE INTO dm_dnm_edi_call_off_schedule A		
		  USING (
		         SELECT  client
						,company_id
						,company_name
						,doc_identifiner
						,shipto_item_number
						,line_item_number
						,scheduling_condition
						,scheduling_condition_name
						,scheduling_item_number
						,tobe_delivered_qty
						,uom
						,req_delivery_date
						,req_shipment_date
						,last_delivery_date
						,earliest_delivery_date
						,start_date scheduling_start_date
						,end_date scheduling_end_date
				 FROM   xif_erp_edi_call_off_schedule_r_sn WITH(NOLOCK)
				 WHERE  ifseqno			   = @v_ifseqno	
				 AND    transfer_flag		   = 'P'

				) B
		  ON(     
					  A.company_id           	=  B.company_id
			      AND A.doc_identifiner			=  B.doc_identifiner
			      AND A.shipto_item_number		=  B.shipto_item_number
				  AND A.line_item_number		=  B.line_item_number	
				  AND A.scheduling_condition	=  B.scheduling_condition
				  AND A.scheduling_item_number  =  B.scheduling_item_number
				  		  
		    )
		  WHEN MATCHED THEN
		     UPDATE SET 
						 A.client					 =  B.client
						,A.company_name              =  B.company_name
						,A.scheduling_condition_name =  B.scheduling_condition_name
						,A.tobe_delivered_qty		 =  B.tobe_delivered_qty
						,A.uom						 =  B.uom
						,A.req_delivery_date         =  B.req_delivery_date
						,A.req_shipment_date		 =  B.req_shipment_date
						,A.last_delivery_date		 =  B.last_delivery_date
						,A.earliest_delivery_date    =  B.earliest_delivery_date
						,A.scheduling_start_date     =  B.scheduling_start_date
						,A.scheduling_end_date       =  B.scheduling_end_date
					    ,A.valid_yn					 =  'Y'
					    ,A.last_updated_by			 =  @v_batch_user
                        ,A.last_update_date			 =  GETDATE()
					                
		  WHEN NOT MATCHED THEN
			 INSERT (  
						 client
						,company_id
						,company_name
						,doc_identifiner
						,shipto_item_number
						,line_item_number
						,scheduling_condition
						,scheduling_condition_name
						,scheduling_item_number
						,tobe_delivered_qty
						,uom
						,req_delivery_date
						,req_shipment_date
						,last_delivery_date
						,earliest_delivery_date
						,scheduling_start_date
						,scheduling_end_date
					    ,valid_yn
						,created_by
						,creation_date
						,last_updated_by
						,last_update_date
					)
			 VALUES (   
						 B.client
						,B.company_id
						,B.company_name
						,B.doc_identifiner
						,B.shipto_item_number
						,B.line_item_number
						,B.scheduling_condition
						,B.scheduling_condition_name
						,B.scheduling_item_number
						,B.tobe_delivered_qty
						,B.uom
						,B.req_delivery_date
						,B.req_shipment_date
						,B.last_delivery_date
						,B.earliest_delivery_date
						,B.scheduling_start_date
						,B.scheduling_end_date
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
              SET @v_log_message = 'MERGE INTO dm_dnm_edi_call_off_schedule_r';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		FETCH NEXT FROM CUR_EDI_CALL_OFF_SCHEDULE INTO  @v_ifseqno
		END

		CLOSE CUR_EDI_CALL_OFF_SCHEDULE;
		DEALLOCATE CUR_EDI_CALL_OFF_SCHEDULE; 

		/*
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리

		SET @n_history_seq = NEXT VALUE FOR SEQ1_dm_dnm_edi_call_off_schedule_r_H
			
			INSERT INTO [dbo].[dm_dnm_edi_call_off_schedule_r_h] (
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
				  FROM [dbo].[dm_dnm_edi_call_off_schedule_r_temp$]
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
				  FROM [dbo].[dm_dnm_edi_call_off_schedule_r]
				  ) A INNER JOIN [dbo].[dm_dnm_edi_call_off_schedule_r_temp$] B
				  ON  A.division_id = B.division_id
				  AND A.soldto_code = B.soldto_code
				  AND A.shipto_code = B.shipto_code

				  ) A

		DROP TABLE dm_dnm_edi_call_off_schedule_r_temp$;
				-- HISTORY LOG
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO dm_dnm_edi_call_off_schedule_r_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_batch_user, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		*/
		-- 처리 한 row 마킹
		UPDATE xif_erp_edi_call_off_schedule_r_sn 
		SET transfer_flag = 'Y' 
		WHERE transfer_flag = 'P';

		-- 순차적 호출을 위함. 2018.06.12
		
        --EXEC PR_DM_BMW_EDI_TO_MKT_FCST  -- 20190131 KHSONG 실행되지 않도록 주석처리함/VW EDI방식으로 변경되면서 더이상 사용을 안함
		
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
