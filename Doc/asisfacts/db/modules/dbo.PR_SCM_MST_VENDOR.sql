
/*
 * Program ID   : PR_SCM_MST_VENDOR
 * Description  : VENDOR 정보 수집 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 12. 08    Kim Jaejung      Initial Release 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_VENDOR]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_VENDOR';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_history_seq	BIGINT;
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
	  UPDATE XIF_ERP_VENDOR_R_SN
			SET transfer_flag = 'P'
	  WHERE ISNULL(transfer_flag,'N') = 'N'
	  
	  DECLARE CUR_ERP_VENDOR CURSOR FOR
		  SELECT ifseqno
		  FROM  XIF_ERP_VENDOR_R_SN WITH(NOLOCK)
		  WHERE transfer_flag = 'P'
		  GROUP BY ifseqno
		  ORDER BY ifseqno ASC;

		IF OBJECT_ID('dbo.scm_mst_vendor_temp$') IS NOT NULL DROP TABLE scm_mst_vendor_temp$

		 SELECT * INTO [dbo].scm_mst_vendor_temp$
		 FROM [dbo].scm_mst_vendor WITH(NOLOCK);

		 OPEN CUR_ERP_VENDOR;
		 FETCH NEXT FROM CUR_ERP_VENDOR INTO @v_ifseqno ;
		 
		 WHILE (@@FETCH_STATUS = 0)
		 BEGIN

         MERGE INTO [dbo].[scm_mst_vendor] A
		 USING ( 
				 SELECT  /* PR_SCM_MST_VENDOR */
					   company_id  -- 20180115 컬럼 추가함
					  ,rtrim(vendor_code) AS vendor_code
					  ,MIN(vendor_name) vendor_name
					  ,MIN(country) country
					  ,MIN(representative) representative
					  ,MIN(vendor_address) vendor_address
					  ,MIN(account_group_code) account_group_code
					  ,MIN(account_group_name) account_group_name
					  ,MIN(affiliate_code) affiliate_code
					  ,CASE WHEN MIN(delete_flag) = 'Y' THEN 'N' ELSE 'Y' END AS valid_yn
					  ,MIN(packer_yn) packer_yn
				  FROM XIF_ERP_VENDOR_R_SN WITH(NOLOCK)
				  WHERE ifseqno = @v_ifseqno
				  AND TRANSFER_FLAG = 'P'
				  GROUP BY 
					   company_id
					  ,vendor_code


				) B
		ON(
					  A.vendor_code  =  B.vendor_code
				  AND A.company_id	 =  B.company_id
		   )

		WHEN MATCHED THEN
			 UPDATE SET  
					     A.vendor_name        = B.vendor_name
					    ,A.country			  = B.country
					    ,A.representative     = B.representative
						,A.vendor_address     = B.vendor_address
					    ,A.account_group_code = B.account_group_code
					    ,A.account_group_name = B.account_group_name
					    ,A.affiliate_code     = B.affiliate_code
                        ,A.valid_yn			  = B.valid_yn
						,A.packer_yn		  = B.packer_yn                  
					    ,A.last_updated_by	  = @v_batch_user
                        ,A.last_update_date	  = GETDATE()

										                
		WHEN NOT MATCHED THEN
			 INSERT (    
						  company_id
						 ,vendor_code
						 ,vendor_name       
						 ,country
						 ,vendor_address		 
						 ,representative    
						 ,account_group_code
						 ,account_group_name
						 ,affiliate_code      
						 ,valid_yn
						 ,packer_yn			 
						 ,created_by		 
						 ,creation_date	 
						 ,last_updated_by	 
						 ,last_update_date	 
					)
			 VALUES (    
						  B.company_id 
			             ,B.vendor_code
						 ,B.vendor_name       
						 ,B.country
						 ,B.vendor_address		 
						 ,B.representative    
						 ,B.account_group_code
						 ,B.account_group_name
						 ,B.affiliate_code    
						 ,B.valid_yn   
						 ,B.packer_yn   
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
              SET @v_log_message = 'MERGE INTO scm_mst_vendor';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		FETCH NEXT FROM CUR_ERP_VENDOR INTO  @v_ifseqno
		END
		
		CLOSE CUR_ERP_VENDOR;
		DEALLOCATE CUR_ERP_VENDOR; 
		-- History insert 

	  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_VENDOR_H
	  INSERT INTO [dbo].[scm_mst_vendor_h] (
					history_seq
				   ,company_id
				   ,vendor_code
				   ,vendor_name
				   ,country
				   ,representative
				   ,vendor_address
				   ,account_group_code
				   ,account_group_name
				   ,affiliate_code
				   ,valid_yn
				   ,packer_yn
				   ,creation_date
				   ,last_update_date
				   ,created_by
				   ,last_updated_by
				   ,history_creation_date		
			)
			SELECT    @n_history_seq
					  ,A.*
					  ,GETDATE()
					  ,@v_batch_user
					  ,@v_batch_user
					  ,GETDATE()
			FROM 
			(
			 SELECT A.*,B.last_update_date FROM (
			       SELECT  company_id
						  ,vendor_code
						  ,vendor_name
						  ,country
						  ,representative
						  ,vendor_address
						  ,account_group_code
						  ,account_group_name
						  ,affiliate_code
						  ,valid_yn
						  ,packer_yn
					FROM [dbo].[scm_mst_vendor_temp$] WITH(NOLOCK)
					EXCEPT
					SELECT company_id
						  ,vendor_code
						  ,vendor_name
						  ,country
						  ,representative
						  ,vendor_address
						  ,account_group_code
						  ,account_group_name
						  ,affiliate_code
						  ,valid_yn
						  ,packer_yn
					FROM [dbo].[scm_mst_vendor] WITH(NOLOCK)) A
				INNER JOIN [dbo].[scm_mst_vendor_temp$] B WITH(NOLOCK)
				ON  A.COMPANY_ID  = B.company_id
				AND A.vendor_code = B.vendor_code
			) A

		 DROP TABLE scm_mst_vendor_temp$;
		 
		 UPDATE XIF_ERP_VENDOR_R_SN 
			SET transfer_flag = 'Y'
		 WHERE transfer_flag = 'P'

		 
		-- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_mst_vendor_h';
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
