/*
 * Program ID   : PR_SCM_DNM_STOCK_SALES
 * Description  : 판매법인 재고 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 31    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.27     Kim Jaejung	   소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 * 2018.07.20	  Kim Jaejung      소형 대표 ITEM_ID 변경 시 update 로직 적용 (소형)
 * 2020.12.17	hwi1993		[C20201217-000126] ESS 판매법인 VMI inventory 수신 프로세스 수정
 *                          site, division_id 매핑 룰 수정
 */

CREATE PROCEDURE [dbo].[PR_SCM_DNM_STOCK_SALES]
AS
  BEGIN
  /*
  ERP 에서 주는 재고는 RESULT_DATE 의 오전 7시에 집계한 재고임. 따라서 RESULT_DATE 의 전날 재고라고 봐야 함.
  */
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_STOCK_SALES';
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
			UPDATE [dbo].[xif_erp_sales_stock_r_sn]
			SET transfer_flag = 'P'
			WHERE ISNULL(transfer_flag,'N') = 'N';
	  
	  -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	  DECLARE CUR_STOCK_SALES CURSOR FOR
	  SELECT ifseqno 
	  FROM  [dbo].[xif_erp_sales_stock_r_sn] WITH(NOLOCK)
	  WHERE transfer_flag = 'P'
	  GROUP BY ifseqno
	  ORDER BY ifseqno ASC;


	  
	  -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
	  IF OBJECT_ID('dbo.scm_dnm_stock_sales_temp$') IS NOT NULL DROP TABLE scm_dnm_stock_sales_temp$;
	  
	  -- 데이터가 누적 되기 때문에, history 비교 시 변경 대상이 되는 row 로만 temp table 생성
	  SELECT * INTO dbo.scm_dnm_stock_sales_temp$
	  FROM dbo.scm_dnm_stock_sales WITH(NOLOCK)
	  WHERE result_date+company_id+plant_id+storage_id+origin_item_id+item_id IN
	  (SELECT result_date+company_id+plant_id+storage_id+item_id+dbo.FN_GET_PACKER_PLAN_ITEM_ID(division_id, item_id) FROM [xif_erp_sales_stock_r_sn] WITH(NOLOCK) WHERE transfer_flag = 'P'); --2018.06.27

		 OPEN CUR_STOCK_SALES;
		 FETCH NEXT FROM CUR_STOCK_SALES INTO @v_ifseqno ; 

		 
		 WHILE (@@FETCH_STATUS = 0)
		 BEGIN
			
				  MERGE INTO [dbo].[scm_dnm_stock_sales] A
				  USING ( 
					SELECT /* PR_SCM_DNM_STOCK_SALES */ 
							-- [C20201217-000126]
						   -- CONVERT(CHAR(8),DATEADD(dd,-1,result_date),112) AS result_date
						  result_date -- 나중에 활용할 때 일자를 조정해준다.
						  ,company_id
						  --,ISNULL((SELECT top 1 division_id
							 --      FROM   scm_mst_site WITH(NOLOCK)
							 --      WHERE  plant_id   = A.plant_id),'') AS division_id -- 수정 필요
						, ISNULL(B.DIVISION_ID, '') AS DIVISION_ID
						  ,plant_id
						  ,storage_id
						  ,A.item_id origin_item_id --2018.07.20
						  ,item_name
						  ,storage_description
						  ,ISNULL(qty,0) qty
						  ,ISNULL(hold_qty,0) hold_qty
						  ,uom
						  --, ISNULL(B.SCM_SITE_ID, '') AS SCM_SITE_ID
						  , '' AS SCM_SITE_ID	-- 정확한정보를 찾을 수 없고, 현재 활용도 하지 않으므로 매핑하지 않는다.
						 -- ,(SELECT MAX(scm_site_id) 
							--FROM   scm_mst_location WITH(NOLOCK)
							--WHERE  division_id =  A.division_id
							--AND    storage_id  =  A.storage_id
							--AND    valid_yn = 'Y' ) AS scm_site_id
						  ,dbo.FN_GET_PACKER_PLAN_ITEM_ID( A.division_id, A.item_id) item_id --2018.06.27 , 2018.07.20
					  FROM [dbo].[xif_erp_sales_stock_r_sn] A WITH(NOLOCK)
					  JOIN ( 	SELECT ITEM_ID, MAX(DIVISION_ID) AS DIVISION_ID
								FROM DM_PLN_MKT_FCST_RESULT
								WHERE YYYYMMDD >= '20191001'
									AND DIVISION_ID = '82'
								GROUP BY ITEM_ID ) B ON dbo.FN_GET_PACKER_PLAN_ITEM_ID(A.division_id, A.item_id) = B.ITEM_ID
					  WHERE ifseqno = @v_ifseqno
					  AND transfer_flag = 'P'

					) B
			ON (	   A.result_date    =  B.result_date
				   AND A.company_id     =  B.company_id
				   AND A.division_id	=  B.division_id
				   AND A.plant_id		=  B.plant_id
				   AND A.storage_id     =  B.storage_id
				   AND A.origin_item_id =  B.origin_item_id  --2018.06.27 , 2018.07.20

			   )
			WHEN MATCHED THEN
				 UPDATE SET 			
							 A.item_name			=  B.item_name
							,A.item_id			    =  B.item_id --2018.06.27 , 2018.07.20
							,A.storage_description	=  B.storage_description
							,A.qty					=  B.qty
							,A.hold_qty				=  B.hold_qty
							,A.uom					=  B.uom
							,A.valid_yn			=  'Y'
							,A.last_updated_by	=  @v_batch_user
							,A.last_update_date	=  GETDATE()

					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				               result_date
							  ,company_id
							  ,division_id
							  ,plant_id
							  ,storage_id
							  ,item_id
							  ,origin_item_id --2018.06.27
							  ,item_name
							  ,storage_description
							  ,qty
							  ,hold_qty
							  ,uom
							  ,scm_site_id
							  --,site_item_mapping_yn
							  ,valid_yn
					          ,created_by
						      ,creation_date
						      ,last_updated_by
						      ,last_update_date						  								
						)
				 VALUES (   
							   B.result_date
							  ,B.company_id
							  ,B.division_id
							  ,B.plant_id
							  ,B.storage_id
							  ,B.item_id --2018.06.27 , 2018.07.20
							  ,B.origin_item_id --2018.06.27 , 2018.07.20
							  ,B.item_name
							  ,B.storage_description
							  ,B.qty
							  ,B.hold_qty
							  ,B.uom
							  ,B.scm_site_id
							  --,'N'
							  ,'Y'
						      ,@v_batch_user
						      ,GETDATE()
						      ,@v_batch_user
						      ,GETDATE() 
						)
			;
			 -----------------------------------------------------------
              -- INSERT LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'INSERT INTO scm_dnm_stock_sales';
              SET @v_description = 'ifseqno = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

			FETCH NEXT FROM CUR_STOCK_SALES INTO  @v_ifseqno
			END
		
		CLOSE CUR_STOCK_SALES;
		DEALLOCATE CUR_STOCK_SALES; 
		
		-- SCM_MST_SITE_ITEM 테이블과 데이터 비교 후 site_item_yn 에 마킹
		/* 20180315 사용 안하기로함..
		UPDATE [dbo].[scm_dnm_stock_sales]
		SET    site_item_mapping_yn	 =  'Y'
		FROM   [dbo].[scm_dnm_stock_sales] A INNER JOIN [dbo].[scm_mst_site_item] B
		ON     A.division_id			=  B.division_id
		AND    A.scm_site_id 		=  B.scm_site_id
		AND    A.item_id				=  B.item_id
		WHERE  A.valid_yn = 'Y'
		AND    A.result_date+A.company_id+A.plant_id+A.storage_id+A.item_id IN
		(SELECT result_date+company_id+plant_id+storage_id+item_id FROM [xif_erp_sales_stock_r_sn] WHERE transfer_flag = 'P');
		*/

		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		 SET @n_history_seq = NEXT VALUE FOR seq1_scm_dnm_stock_sales_h
		 INSERT INTO [dbo].[scm_dnm_stock_sales_h] (
						       history_seq
						      ,result_date
							  ,company_id
							  ,division_id
							  ,plant_id
							  ,storage_id
							  ,item_id
							  ,origin_item_id --2018.06.27
							  ,item_name
							  ,storage_description
							  ,qty
							  ,hold_qty
							  ,uom
							  ,scm_site_id
							  ,site_item_mapping_yn
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
					SELECT A.*,B.creation_date,B.last_update_date FROM (SELECT /* scm_dnm_stock_sales_h */
						       result_date
							  ,company_id
							  ,division_id
							  ,plant_id
							  ,storage_id
							  ,item_id
							  ,origin_item_id --2018.06.27
							  ,item_name
							  ,storage_description
							  ,qty
							  ,hold_qty
							  ,uom
							  ,scm_site_id
							  ,site_item_mapping_yn
							  ,valid_yn
					FROM [dbo].[scm_dnm_stock_sales_temp$] WITH(NOLOCK)
					EXCEPT
					SELECT /* scm_dnm_stock_sales_h */
						       result_date
							  ,company_id
							  ,division_id
							  ,plant_id
							  ,storage_id
							  ,item_id
							  ,origin_item_id --2018.06.27
							  ,item_name
							  ,storage_description
							  ,qty
							  ,hold_qty
							  ,uom
							  ,scm_site_id
							  ,site_item_mapping_yn
							  ,valid_yn
				    FROM [dbo].[scm_dnm_stock_sales] WITH(NOLOCK)
					 WHERE result_date+company_id+plant_id+storage_id+origin_item_id IN
					(SELECT result_date+company_id+plant_id+storage_id+item_id FROM [xif_erp_sales_stock_r_sn] WITH(NOLOCK) WHERE transfer_flag = 'P')) A 
					INNER JOIN [dbo].[scm_dnm_stock_sales_temp$] B WITH(NOLOCK)
					ON	A.result_date		=  B.result_date
				    AND A.company_id		=  B.company_id
				    AND A.division_id		=  B.division_id
				    AND A.plant_id			=  B.plant_id
				    AND A.storage_id		=  B.storage_id
				    AND A.item_id			=  B.item_id
				    AND A.origin_item_id	=  B.origin_item_id ) A
		
		DROP TABLE dbo.scm_dnm_stock_sales_temp$;

        -- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_dnm_stock_sales_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 처리된 row 마킹
		UPDATE [dbo].[xif_erp_sales_stock_r_sn] 
		SET transfer_flag = 'Y' 
		WHERE transfer_flag = 'P';

		EXEC PR_DM_PLN_ESS_CHANNEL_PSI_CREATE;

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


