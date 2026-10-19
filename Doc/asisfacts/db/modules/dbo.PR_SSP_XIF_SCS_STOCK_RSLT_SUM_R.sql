

/*
 * Program ID   : PR_SSP_XIF_SCS_STOCK_RSLT_SUM_R
 * Description  : Packer 재고 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.07.31   KSG            Initial Release [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선]
 * 2024.10.01   KHJ            NERP_SSP
 *
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_SCS_STOCK_RSLT_SUM_R]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_XIF_SCS_STOCK_RSLT_SUM_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_if_seq     NVARCHAR(30); 
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
        UPDATE xif_scs_stock_rslt_sum_r_sn
	    SET    proc_flag = 'P'
	    WHERE  ISNULL(proc_flag,'N') = 'N';
	  
	    -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	    DECLARE CUR_SCS_STOCK CURSOR FOR
	    SELECT if_seq 
	    FROM   xif_scs_stock_rslt_sum_r_sn WITH(NOLOCK)
	    WHERE  proc_flag = 'P'
	    GROUP BY if_seq
	    ORDER BY if_seq ASC;
	  
		OPEN CUR_SCS_STOCK;
		FETCH NEXT FROM CUR_SCS_STOCK INTO @v_if_seq ; 
		 
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			
/*INF-R 적용 이전		
            MERGE INTO scm_dnm_scs_stock a
			USING (
                   SELECT /* PR_SSP_XIF_SCS_STOCK_RSLT_SUM_R */ 
                          v.division_id
                        , v.cutoff_date
                        , v.scm_site_id
                        , dbo.FN_GET_PACKER_PLAN_ITEM_ID(v.division_id, v.model_code) AS item_id
                        , v.packer_code
                        , v.stock_date
                        , v.cell_pack
                        , v.model_code
                        , v.stock_qty       
						, v.bad_qty
                   FROM  (
                          SELECT --spart AS division_id
                                 ISNULL(division_id, '')             AS division_id
                               , ISNULL(stock_date, CONVERT(CHAR(8), GETDATE()-1, 112))  AS cutoff_date -- stock_date 가 EOH 기준일자임
                               , ISNULL(packer_code, '')             AS scm_site_id
                               , ISNULL(packer_code, '')             AS packer_code
                               , ISNULL(stock_date, '')              AS stock_date
                               , ISNULL(cell_pack, '')               AS cell_pack
                               , ISNULL(model_code, '')              AS model_code
                               , ISNULL(stock_qty, '0')              AS stock_qty
							   , ISNULL(attr_05, '0')                AS bad_qty    --비가용 수량
                          FROM   xif_scs_stock_rslt_sum_r_sn  WITH(NOLOCK)
                          WHERE  if_seq    = @v_if_seq
                          AND    proc_flag = 'P'
                         ) v              
                   WHERE  division_id             <> ''
                   AND    ISNULL(scm_site_id, '') <> ''
                   AND    ISNULL(model_code, '')  <> ''
		          ) b
			ON (	   a.division_id     =  b.division_id
				   AND a.cutoff_date	 =  b.cutoff_date
				   AND a.scm_site_id	 =  b.scm_site_id
				   AND a.model_code      =  b.model_code -- Origin Item Id
				   AND a.cell_pack	     =  b.cell_pack
			   )
			WHEN MATCHED THEN
				 UPDATE SET 			
							 a.stock_qty		=  b.stock_qty
							,a.item_id          =  b.item_id
							,a.packer_code      =  b.packer_code
				            ,a.stock_date       =  b.stock_date
							,a.last_updated_by	=  @v_batch_user
							,a.last_update_date	=  GETDATE()
							,a.attribute5       =  b.bad_qty
					                
			WHEN NOT MATCHED THEN
			INSERT (  
                    division_id
                  , cutoff_date
                  , scm_site_id
                  , item_id
                  , packer_code
                  , stock_date
                  , cell_pack
                  , model_code
                  , stock_qty  
                  , created_by
                  , creation_date
                  , last_updated_by
                  , last_update_date
				  , attribute5
                   )
			VALUES (   
                    b.division_id
                  , b.cutoff_date
                  , b.scm_site_id
                  , b.item_id
                  , b.packer_code
                  , b.stock_date
                  , b.cell_pack
                  , b.model_code
                  , b.stock_qty
				  , @v_batch_user
				  , GETDATE()
				  , @v_batch_user
				  , GETDATE() 
				  , b.bad_qty
			       )
			;
*/			
/*INF-R 적용 이후*/ 			
            MERGE INTO scm_dnm_scs_stock a
			USING (
                   SELECT /* PR_SSP_XIF_SCS_STOCK_RSLT_SUM_R */ 
                          v.division_id
                        , v.cutoff_date
                        , v.scm_site_id
                        , dbo.FN_GET_PACKER_PLAN_ITEM_ID(v.division_id, v.model_code) AS item_id
                        , v.packer_code
                        , v.stock_date
                        , v.cell_pack
                        , v.model_code
                        , v.stock_qty       
						, v.bad_qty
                   FROM  (
                          SELECT --spart AS division_id
                                 ISNULL(division_id, '')             AS division_id
                               , ISNULL(stock_date, CONVERT(CHAR(8), GETDATE()-1, 112))  AS cutoff_date -- stock_date 가 EOH 기준일자임
                               , ISNULL(ISNULL (X1.NEW_VALUE1 , packer_code), '')	AS scm_site_id
                               , ISNULL(ISNULL (X1.NEW_VALUE1, packer_code), '')	AS packer_code
                               , ISNULL(stock_date, '')              AS stock_date
                               , ISNULL(cell_pack, '')               AS cell_pack
                               , ISNULL(model_code, '')              AS model_code
                               , ISNULL(stock_qty, '0')              AS stock_qty
							   , ISNULL(attr_05, '0')                AS bad_qty    --비가용 수량
                          FROM   xif_scs_stock_rslt_sum_r_sn  A WITH(NOLOCK)
							LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
							ON  X1.CODETYPE = 'SCP_SITE_ID'
							AND A.PACKER_CODE = X1.OLD_VALUE1
							AND X1.ATTRIBUTE5 = '1ST'
                          WHERE  if_seq    = @v_if_seq
                          AND    proc_flag = 'P'
                         ) v              
                   WHERE  division_id             <> ''
                   AND    ISNULL(scm_site_id, '') <> ''
                   AND    ISNULL(model_code, '')  <> ''
		          ) b
			ON (	   a.division_id     =  b.division_id
				   AND a.cutoff_date	 =  b.cutoff_date
				   AND a.scm_site_id	 =  b.scm_site_id
				   AND a.model_code      =  b.model_code -- Origin Item Id
				   AND a.cell_pack	     =  b.cell_pack
			   )
			WHEN MATCHED THEN
				 UPDATE SET 			
							 a.stock_qty		=  b.stock_qty
							,a.item_id          =  b.item_id
							,a.packer_code      =  b.packer_code
				            ,a.stock_date       =  b.stock_date
							,a.last_updated_by	=  @v_batch_user
							,a.last_update_date	=  GETDATE()
							,a.attribute5       =  b.bad_qty
					                
			WHEN NOT MATCHED THEN
			INSERT (  
                    division_id
                  , cutoff_date
                  , scm_site_id
                  , item_id
                  , packer_code
                  , stock_date
                  , cell_pack
                  , model_code
                  , stock_qty  
                  , created_by
                  , creation_date
                  , last_updated_by
                  , last_update_date
				  , attribute5
                   )
			VALUES (   
                    b.division_id
                  , b.cutoff_date
                  , b.scm_site_id
                  , b.item_id
                  , b.packer_code
                  , b.stock_date
                  , b.cell_pack
                  , b.model_code
                  , b.stock_qty
				  , @v_batch_user
				  , GETDATE()
				  , @v_batch_user
				  , GETDATE() 
				  , b.bad_qty
			       )
			;


			SET @n_log_count = @n_log_count + @@ROWCOUNT;

			FETCH NEXT FROM CUR_SCS_STOCK INTO  @v_if_seq
		
		END
		
		CLOSE CUR_SCS_STOCK;
		DEALLOCATE CUR_SCS_STOCK; 

		-----------------------------------------------------------
        -- INSERT LOG
        -----------------------------------------------------------
        --SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'APPEND';
        SET @v_log_message = 'INSERT INTO scm_dnm_scs_stock';
        SET @v_description = 'if_seq = ' + @v_if_seq;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------
		
		-- 처리된 row 마킹
		UPDATE xif_scs_stock_rslt_sum_r_sn 
		SET    proc_flag = 'Y' 
		WHERE  proc_flag = 'P';

		-- IF data  삭제 (90일 이전 데이터 삭제) 
		DELETE 
		  FROM XIF_SCS_STOCK_RSLT_SUM_R_SN 
		 WHERE IF_RCV_DATE < GETDATE() - 90
		
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
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
