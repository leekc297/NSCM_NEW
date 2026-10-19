/*
 * Program ID   : PR_SCM_MST_CUSTOMER
 * Description  : ERP Customer 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 12. 15    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 05. 23    Kim Jaejung      city column 추가 로직 반영
 * 2022. 05. 11	   kdw2819			GM JV - SCM_MST_DIVISION 테이블을 참조하여 자동차 사업부 세분화 부서 데이터 추가 생성
 * 2022. 12. 30	   CHANO0612		[C20221212-000561] Ship To의 국가도시 코드 반영
 */ --EXEC PR_SCM_MST_CUSTOMER

CREATE PROCEDURE [dbo].[PR_SCM_MST_CUSTOMER]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_CUSTOMER';
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
	    UPDATE XIF_ERP_CUSTOMER_R_SN 
		SET    transfer_flag = 'P'
		WHERE  ISNULL(transfer_flag,'N') = 'N'

		-- 지나간 배치까지 적용하기 위해 Cursor 로 처리
		DECLARE CUR_ERP_CUSTOMER CURSOR FOR
		  
		SELECT ifseqno
		FROM   XIF_ERP_CUSTOMER_R_SN WITH(NOLOCK)
		WHERE  transfer_flag = 'P'
		GROUP BY ifseqno
		ORDER BY ifseqno ASC;

		-- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
		IF OBJECT_ID('dbo.scm_mst_customer_temp$') IS NOT NULL 
		  DROP TABLE scm_mst_customer_temp$

		SELECT * 
		INTO [dbo].scm_mst_customer_temp$
		FROM [dbo].scm_mst_customer WITH(NOLOCK);

		OPEN CUR_ERP_CUSTOMER;
		FETCH NEXT FROM CUR_ERP_CUSTOMER INTO @v_ifseqno ;

		WHILE (@@FETCH_STATUS = 0)
		  BEGIN
	 
		  MERGE INTO [dbo].[scm_mst_customer] A		
		  USING (
				SELECT C.division_id	
					,A.customer2_code AS soldto_code	
					,B.customer2_code AS shipto_code
					,MIN(A.customer2_description) AS soldto_desc
					,MIN(B.customer2_description) AS shipto_desc
					,MIN(A.customer2_address) AS soldto_address
					,MIN(A.city) AS city -- 2018. 05. 23
					,MIN(A.customer2_country) AS soldto_country
					,MIN(A.customer2_region) AS soldto_region
					,MIN(A.customer2_region_name) AS soldto_region_name
					,MIN(A.customer2_city) AS soldto_city
					,MIN(B.customer2_address) AS shipto_address
					,MIN(B.customer2_country) AS shipto_country
					,MIN(B.customer2_region) AS shipto_region
					,MIN(B.customer2_region_name) AS shipto_region_name
					,MIN(B.customer2_city) AS shipto_city
					,MIN(B.ATTRIBUTE1) AS shipto_city_code -- [C20221212-000561] Ship To의 국가도시 코드 반영
					,CASE MIN(A.customer_delete_flag) WHEN 'Y' THEN 'N' ELSE 'Y' END valid_yn
				FROM   XIF_ERP_CUSTOMER_R_SN AS A WITH(NOLOCK) 	
				INNER JOIN  XIF_ERP_CUSTOMER_R_SN AS B WITH(NOLOCK)
				ON	   A.customer_code	       = B.customer_code 
				AND    A.ifseqno			   = @v_ifseqno 
				AND    B.ifseqno			   = @v_ifseqno		
				AND	   A.sales_org			   = B.sales_org
				AND    A.distribution_channel  = B.distribution_channel	
				AND    A.division_id		   = B.division_id	
				AND    A.partner_type		   = 'SP'	
				AND    B.partner_type		   = 'SH'
				AND    A.transfer_flag		   = 'P'
				AND    B.transfer_flag		   = 'P'
				INNER JOIN SCM_MST_DIVISION AS C WITH(NOLOCK)
				ON C.ATTRIBUTE3 = A.DIVISION_ID 
				GROUP BY C.division_id
						,A.customer2_code
						,B.customer2_code
				) B
		  ON(     A.division_id      =  B.division_id
			      AND A.soldto_code  =  B.soldto_code
				  AND A.shipto_code  =  B.shipto_code			  
		    )
		  WHEN MATCHED THEN
		
		     UPDATE SET A.soldto_description  =  B.soldto_desc 
					   ,A.soldto_address      =  B.soldto_address 
					   ,A.city				  =  B.city   -- 2018. 05. 23
					   ,A.soldto_country	  =  B.soldto_country 
					   ,A.soldto_region		  =  B.soldto_region 
					   ,A.soldto_region_name  =  B.soldto_region_name 
					   ,A.soldto_city_name    =  B.soldto_city
					   ,A.shipto_description  =  B.shipto_desc 
					   ,A.shipto_address      =  B.shipto_address 
					   ,A.shipto_country	  =  B.shipto_country 
					   ,A.shipto_region		  =  B.shipto_region 
					   ,A.shipto_region_name  =  B.shipto_region_name 
					   ,A.shipto_city_name    =  B.shipto_city
					   ,A.SHIPTO_CITY         =  B.shipto_city_code -- [C20221212-000561] Ship To의 국가도시 코드 반영
					   ,A.valid_yn			  =  B.valid_yn
					   ,A.last_updated_by	  =  @v_batch_user
                       ,A.last_update_date	  =  GETDATE()
					                
		  WHEN NOT MATCHED THEN
			 INSERT (  
			             division_id
					    ,soldto_code
					    ,shipto_code
					    ,soldto_description
					    ,soldto_address
						,city  -- 2018. 05. 23
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
						,SHIPTO_CITY -- [C20221212-000561] Ship To의 국가도시 코드 반영
					    ,valid_yn
						,created_by
						,creation_date
						,last_updated_by
						,last_update_date
					)
			 VALUES (   
						 B.division_id
				        ,B.soldto_code
					    ,B.shipto_code
					    ,B.soldto_desc
					    ,B.soldto_address
						,city -- 2018. 05. 23
					    ,B.soldto_country
					    ,B.soldto_region
					    ,B.soldto_region_name
					    ,B.soldto_city
					    ,B.shipto_desc
					    ,B.shipto_address
					    ,B.shipto_country
					    ,B.shipto_region
					    ,B.shipto_region_name
					    ,B.shipto_city
						,B.shipto_city_code -- [C20221212-000561] Ship To의 국가도시 코드 반영
					    ,valid_yn
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
              SET @v_log_message = 'MERGE INTO scm_mst_customer';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		FETCH NEXT FROM CUR_ERP_CUSTOMER INTO  @v_ifseqno
		END

		CLOSE CUR_ERP_CUSTOMER;
		DEALLOCATE CUR_ERP_CUSTOMER; 

		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리

		SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_CUSTOMER_H
			
			INSERT INTO [dbo].[scm_mst_customer_h] (
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
			  ,SHIPTO_CITY  -- [C20221212-000561] Ship To의 국가도시 코드 반영
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
					  ,SHIPTO_CITY -- [C20221212-000561] Ship To의 국가도시 코드 반영
					  ,valid_yn
					  ,creation_date
				  FROM [dbo].[scm_mst_customer_temp$]
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
					  ,SHIPTO_CITY -- [C20221212-000561] Ship To의 국가도시 코드 반영
					  ,valid_yn
					  ,creation_date
				  FROM [dbo].[scm_mst_customer]
				  ) A INNER JOIN [dbo].[scm_mst_customer_temp$] B
				  ON  A.division_id = B.division_id
				  AND A.soldto_code = B.soldto_code
				  AND A.shipto_code = B.shipto_code

				  ) A

		DROP TABLE scm_mst_customer_temp$;
				-- HISTORY LOG
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_mst_customer_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		
		-- 처리 한 row 마킹
		UPDATE XIF_ERP_CUSTOMER_R_SN SET transfer_flag = 'Y' WHERE transfer_flag = 'P';


		
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
