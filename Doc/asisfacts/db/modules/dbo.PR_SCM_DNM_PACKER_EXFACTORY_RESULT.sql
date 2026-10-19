

CREATE PROCEDURE [dbo].[PR_SCM_DNM_PACKER_EXFACTORY_RESULT]
AS
/*
 * Program ID   : PR_SCM_DNM_PACKER_EXFACTORY_RESULT
 * Description  : Packer PO 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 09    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 참조: 인터페이스 대상에 해당하는 데이터만 비교 후 History 저장(INSERT 된 데이터는 남기지 않음)
 * 2018.06.27     Kim Jaejung	   소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 * 2018.07.20	  Kim Jaejung      소형 대표 ITEM_ID 변경 시 update 로직 적용 (소형)
 * 2022.03.30     KSG              PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division : 실제로는 수행 안 되고 있음
 * 2023.03.23	  hrkim		       [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 *
 */
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_PACKER_EXFACTORY_RESULT';
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
	  /*
	--		UPDATE [dbo].[xif_erp_packer_cell_release_r_sn]
	--		SET    attribute15 = 'P'
	--               -- 20220330 PJ20216891 GM JV 가상 Division 추가
    --             , division = CASE WHEN company = 'G670' THEN '81_UC'
	--	                           ELSE division
	--	                      END
	--		WHERE ISNULL(attribute15,'N') = 'N';
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
	     SET TGT.DIVISION		= JP.DIVISION_ID_JV
			,TGT.attribute15	= 'P'
	    FROM [dbo].[xif_erp_packer_cell_release_r_sn] TGT
			INNER JOIN JV_PLANT JP WITH(NOLOCK)
				    ON JP.DIVISION_ID = TGT.DIVISION
				   AND JP.COMPANY_ID  = TGT.COMPANY
	   WHERE ISNULL(TGT.attribute15,'N') = 'N';	  
	  
	  -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	  DECLARE CUR_PACKER_CELL CURSOR FOR
	  SELECT ifseqno 
	  FROM  [dbo].[xif_erp_packer_cell_release_r_sn] WITH(NOLOCK)
	  WHERE attribute15 = 'P'
	  GROUP BY ifseqno
	  ORDER BY ifseqno ASC;

	  -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
	  IF OBJECT_ID('dbo.scm_dnm_packer_purchase_order_temp$') IS NOT NULL DROP TABLE scm_dnm_packer_purchase_order_temp$
	  
	  SELECT * INTO dbo.scm_dnm_packer_purchase_order_temp$
	  FROM dbo.scm_dnm_packer_purchase_order WITH(NOLOCK)
	  WHERE company_id+division_id+plant_id+po_no+po_item_seq+vendor_code+item_id+origin_item_id IN 
	  (SELECT company+division+plant+po_no+po_seq+vendor_code+dbo.FN_GET_PACKER_PLAN_ITEM_ID(division, item_id)+item_id FROM xif_erp_packer_purchase_order_r_sn WITH(NOLOCK) WHERE attribute15 = 'P'); --2018.06.27
	  
		 OPEN CUR_PACKER_CELL;
		 FETCH NEXT FROM CUR_PACKER_CELL INTO @v_ifseqno ;
		 
		 WHILE (@@FETCH_STATUS = 0)
		 BEGIN
		   
			 MERGE INTO [dbo].[scm_dnm_packer_purchase_order] A
			 USING ( 
					SELECT /* PR_SCM_DNM_PACKER_EXFACTORY_RESULT */ 
						   company
						  ,division
						  ,work_date
						  ,po_no
						  ,po_seq
						  ,plant
						  ,site_id
						  ,(SELECT MAX(scm_site_id)
						   FROM dbo.scm_mst_site WITH(NOLOCK)
						   WHERE division_id  = a .division					   
						   AND   plant_id     = a.vendor_code
						   AND   valid_yn     = 'Y') AS scm_site_id
						  ,vendor_code
						  ,vendor_name
						  ,rsd
						  ,eta
						  ,item_id origin_item_id --2018.07.20
						  ,item_name
						  ,ISNULL(issue_qty,0) issue_qty
						  ,valid_yn
						  ,dbo.FN_GET_PACKER_PLAN_ITEM_ID(division, item_id) item_id --2018.06.27 , 2018.07.20
					  FROM [dbo].[xif_erp_packer_cell_release_r_sn]A WITH(NOLOCK)
					  WHERE ifseqno = @v_ifseqno
					  AND attribute15 = 'P'

					) B
			ON (          A.company_id				=  B.company
				      AND A.division_id				=  B.division
					  AND A.plant_id				=  B.plant
					  AND A.po_no					=  B.po_no
					  AND A.po_item_seq				=  B.po_seq
					  AND A.vendor_code				=  B.vendor_code
					  AND A.origin_item_id			=  B.origin_item_id  --2018.06.27 , 2018.07.20

			   )
			WHEN MATCHED THEN
				 UPDATE SET 
							 
							 A.scm_site_id					=  B.scm_site_id
							,A.item_id						=  B.item_id --2018.06.27 , 2018.07.20
							,A.vendor_name					=  B.vendor_name
							,A.item_name					=  B.item_name
							,A.rsd_date						=  B.rsd
							,A.eta_date						=  B.eta
							,A.site_id						=  B.site_id
							,A.exfactory_qty				=  B.issue_qty
							,A.valid_yn						=  B.valid_yn
							,A.last_updated_by				=  @v_batch_user
							,A.last_update_date				=  GETDATE()

					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				             company_id
							,division_id
							,site_id
							,plant_id
							,scm_site_id
							--,scm_site_mapping_yn
							,po_no
							,po_item_seq
							,vendor_code
							,vendor_name
							,item_id
							,origin_item_id --2018.06.27
							,item_name
							,rsd_date
							,eta_date
							,exfactory_qty
							,valid_yn
					        ,created_by
						    ,creation_date
						    ,last_updated_by
						    ,last_update_date						  								
						)
				 VALUES (   
						   B.company
						  ,B.division
						  ,B.site_id
						  ,B.plant
						  ,B.scm_site_id				  
						  --,'N'
						  ,B.po_no
						  ,B.po_seq
						  ,B.vendor_code
						  ,B.vendor_name
						  ,B.item_id --2018.06.27 , 2018.07.20
						  ,B.origin_item_id --2018.06.27 , 2018.07.20
						  ,B.item_name
						  ,B.rsd
						  ,B.eta
						  ,B.issue_qty
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
              SET @v_log_message = 'MERGE INTO scm_dnm_packer_purchase_order';
              SET @v_description = 'ifseqno = ' +  @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

			FETCH NEXT FROM CUR_PACKER_CELL INTO  @v_ifseqno
			END
		
		CLOSE CUR_PACKER_CELL;
		DEALLOCATE CUR_PACKER_CELL; 
		/*
		-- SCM_MST_SITE_ITEM 테이블과 데이터 비교 후 to_scm_site_id 가 null 인 데이터 업데이트
		UPDATE [dbo].[scm_dnm_packer_purchase_order]
			SET scm_site_id	 =  B.scm_site_id
			FROM [dbo].[scm_dnm_packer_purchase_order] A WITH(NOLOCK) 
			INNER JOIN [dbo].[scm_mst_site_item] B WITH(NOLOCK)
			ON			  A.division_id			=  B.division_id
				      AND A.project_code		=  B.project_code
					  AND A.item_id				=  B.item_id
		WHERE A.valid_yn = 'Y'
		AND company_id+A.division_id+A.plant_id+po_no+po_item_seq+vendor_code+A.item_id IN
		(SELECT company+division+plant+po_no+po_seq+vendor_code+item_id FROM xif_erp_packer_purchase_order_r_sn WITH(NOLOCK) WHERE attribute15 = 'P')
		
		-- SCM_MST_SITE_ITEM 과 매핑 가능한지 확인
		UPDATE [dbo].[scm_dnm_packer_purchase_order]
		SET scm_site_mapping_yn	 =  'Y'
		FROM [dbo].[scm_dnm_packer_purchase_order] A WITH(NOLOCK) 
		INNER JOIN [dbo].[scm_mst_site_item] B WITH(NOLOCK)
		ON	A.division_id			=  B.division_id
		AND A.scm_site_id			=  B.scm_site_id
		AND A.item_id				=  B.item_id
		WHERE A.valid_yn = 'Y'
		AND company_id+A.division_id+A.plant_id+po_no+po_item_seq+vendor_code+A.item_id IN
		(SELECT company+division+plant+po_no+po_seq+vendor_code+item_id FROM xif_erp_packer_purchase_order_r_sn WITH(NOLOCK) WHERE attribute15 = 'P')
		*/
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		 SET @n_history_seq = NEXT VALUE FOR seq1_scm_dnm_packer_purchase_order_h
		 INSERT INTO [dbo].[scm_dnm_packer_purchase_order_h] (
						     history_seq
						    ,company_id
							,division_id
							,site_id
							,plant_id
							,scm_site_id
							,scm_site_mapping_yn
							,po_no
							,po_item_seq
							,vendor_code
							,vendor_name
							,item_id
							,origin_item_id --2018.06.27
							,item_name
							,rsd_date
							,eta_date
							,exfactory_qty
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
					SELECT A.*,B.creation_date,B.last_update_date FROM (SELECT /* scm_dnm_packer_purchase_order_h */
						     company_id
							,division_id
							,site_id
							,plant_id
							,scm_site_id
							,scm_site_mapping_yn
							,po_no
							,po_item_seq
							,vendor_code
							,vendor_name
							,item_id
							,origin_item_id --2018.06.27
							,item_name
							,rsd_date
							,eta_date
							,exfactory_qty
							,valid_yn
					FROM [dbo].[scm_dnm_packer_purchase_order_temp$] WITH(NOLOCK)
					EXCEPT
					SELECT /* scm_dnm_packer_purchase_order_h */
						     company_id
							,division_id
							,site_id
							,plant_id
							,scm_site_id
							,scm_site_mapping_yn
							,po_no
							,po_item_seq
							,vendor_code
							,vendor_name
							,item_id
							,origin_item_id --2018.06.27
							,item_name
							,rsd_date
							,eta_date
							,exfactory_qty
							,valid_yn
				    FROM [dbo].[scm_dnm_packer_purchase_order] WITH(NOLOCK)
					WHERE company_id+division_id+plant_id+po_no+po_item_seq+vendor_code+origin_item_id IN
					(SELECT company+division+plant+po_no+po_seq+vendor_code+item_id FROM xif_erp_packer_purchase_order_r_sn WITH(NOLOCK) WHERE attribute15 = 'P')) A 
					INNER JOIN [dbo].[scm_dnm_packer_purchase_order_temp$] B WITH(NOLOCK)
					ON	  A.company_id				=  B.company_id
				      AND A.division_id				=  B.division_id
					  AND A.plant_id				=  B.plant_id
					  AND A.po_no					=  B.po_no
					  AND A.po_item_seq				=  B.po_item_seq
					  AND A.vendor_code				=  B.vendor_code
					  AND A.item_id					=  B.item_id
					  AND A.origin_item_id	=  B.origin_item_id ) A
		
		-- 처리 한 row 마킹
		UPDATE [dbo].[xif_erp_packer_cell_release_r_sn]
		SET attribute15 = 'Y' 
		WHERE attribute15 = 'P'
		
		DROP TABLE dbo.scm_dnm_packer_purchase_order_temp$;
		
        -- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_dnm_packer_purchase_order_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(1000));
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
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(1000));;
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
