/*
 * Program ID   : PR_SCM_MST_PROJECT_MODEL_QUANTITY
 * Description  : GPLM 시스템 프로젝트 모델 소요량 정보 I/F
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 18    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 5. 08    Kim Jaejung	   ITEM_TYPE 컬럼 I/F 대상에서 제외.
 * 2018. 5. 23    Kim Jaejung	   Append log 로직 삭제
 * 2018. 5. 24    Kim Jaejung      프로젝트 모델 소요량 정보 기준으로 MKT Fcst 생성 로직
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_PROJECT_MODEL_QUANTITY]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_PROJECT_MODEL_QUANTITY';
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
		UPDATE [dbo].[xif_plm_pjt_model_quantity_r_sn]
		SET    proc_flag = 'P'
		WHERE  ISNULL(proc_flag,'N') = 'N';
	  
	    -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	    DECLARE CUR_MAT CURSOR FOR
	      SELECT if_seq 
	      FROM   [dbo].[xif_plm_pjt_model_quantity_r_sn] WITH(NOLOCK)
	      WHERE  proc_flag = 'P'
	      GROUP BY if_seq
	      ORDER BY if_seq ASC;

	    -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
	    IF OBJECT_ID('dbo.scm_mst_project_model_demand_qty_temp$') IS NOT NULL DROP TABLE scm_mst_project_model_demand_qty_temp$
	  
	    SELECT * 
		INTO   dbo.scm_mst_project_model_demand_qty_temp$
	    FROM   dbo.scm_mst_project_model_demand_qty WITH(NOLOCK);

		OPEN CUR_MAT;
		FETCH NEXT FROM CUR_MAT INTO @v_ifseqno ;
		 
		WHILE (@@FETCH_STATUS = 0)
		  BEGIN
		   
		    MERGE INTO [dbo].[scm_mst_project_model_demand_qty] A
			USING (SELECT /* PR_SCM_MST_PROJECT_MODEL_QUANTITY */ 
						  report_id
						 ,ISNULL(B.project_code,'-') project_code
						 ,ISNULL(B.project_ver_seq,'-') project_ver_seq
						 ,model_name
						 ,MAX(nick_name) nick_name
						 ,MAX(quantity) quantity
						 ,MAX(comments) comments
				   FROM  [dbo].[xif_plm_pjt_model_quantity_r_sn]A WITH(NOLOCK)
				   LEFT JOIN  scm_mst_project_mapping B WITH(NOLOCK)
				   ON    A.report_id	=  B.gplm_system_project_code
				   WHERE if_seq = @v_ifseqno
				   AND   proc_flag = 'P'
				   GROUP BY  report_id
							,model_name
							,project_code
							,project_ver_seq
				) B
			ON (          A.system_project_code	=  B.report_id
				      AND A.model_id			=  B.model_name

			   )
			WHEN MATCHED THEN
				 UPDATE SET					 
							 A.project_code         =  B.project_code
							,A.project_ver_seq      =  B.project_ver_seq
							,A.demand_qty			=  B.quantity
							,A.description			=  B.comments					
							,A.last_updated_by		=  @v_batch_user
							,A.last_update_date		=  GETDATE()
					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				             system_project_code
							,model_id
							,project_code
							,project_ver_seq
							,demand_qty
							,description
						    ,valid_yn
					        ,created_by
						    ,creation_date
						    ,last_updated_by
						    ,last_update_date						  								
						)
				 VALUES (   
							 B.report_id
							,B.model_name
							,B.project_code
							,B.project_ver_seq
							,B.quantity
						    ,B.comments
						    ,'Y'
						    ,@v_batch_user
						    ,GETDATE()
						    ,@v_batch_user
						    ,GETDATE() 
						)
			 /*WHEN NOT MATCHED BY SOURCE THEN
				  UPDATE SET A.valid_yn   =  'N'*/
			;
			
			-- 처리 row 마킹
			UPDATE [dbo].[xif_plm_pjt_model_quantity_r_sn]
			SET    proc_flag = 'Y'
			FROM   [dbo].[xif_plm_pjt_model_quantity_r_sn] A WITH(NOLOCK) 
			JOIN   [dbo].[scm_mst_project_model_demand_qty] B WITH(NOLOCK) 
			ON	   B.system_project_code	=  A.report_id
			AND    B.model_id				=  A.model_name
			WHERE  A.if_seq				=  @v_ifseqno
			AND    A.proc_flag			= 'P';

			FETCH NEXT FROM CUR_MAT INTO  @v_ifseqno
		  END
		
		CLOSE CUR_MAT;
		DEALLOCATE CUR_MAT;		
		
		-- Item_type update
		UPDATE scm_mst_project_model_demand_qty
		SET    item_type = b.item_type
		FROM   scm_mst_project_model_demand_qty A WITH(NOLOCK) 
		JOIN   DM_MST_ITEM_SINGLE_V B WITH(NOLOCK) 
		ON     A.model_id = B.item_id;


		-- 추후 project_ver_seq 데이터가 제대로 넘어오면 삭제 필요. 
	    UPDATE scm_mst_project_model_demand_qty
		SET    project_ver_seq =  b.project_ver_seq
	    FROM   scm_mst_project_model_demand_qty A WITH(NOLOCK) 
		JOIN   (SELECT project_code,MAX(project_ver_seq) project_ver_seq FROM scm_mst_project WITH(NOLOCK) GROUP BY project_code) B 
		ON     a.project_code = B.project_code;

		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		SET @n_history_seq = NEXT VALUE FOR seq1_scm_mst_project_model_demand_qty_h
		INSERT INTO [dbo].[scm_mst_project_model_demand_qty_h] (
						     history_seq
						    ,system_project_code
							,model_id
							,project_code
							,project_ver_seq
							,item_type
							,demand_qty
							,description
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
					SELECT A.*,B.creation_date,B.last_update_date FROM (SELECT /* scm_mst_project_model_demand_qty_h */
						     system_project_code
							,model_id
							,project_code
							,project_ver_seq
							,item_type
							,demand_qty
							,description
							,valid_yn
					FROM [dbo].[scm_mst_project_model_demand_qty_temp$] WITH(NOLOCK)
					EXCEPT
					SELECT /* scm_mst_project_model_demand_qty_h */
						     system_project_code
							,model_id
							,project_code
							,project_ver_seq
							,item_type
							,demand_qty
							,description
							,valid_yn
				    FROM [dbo].[scm_mst_project_model_demand_qty] WITH(NOLOCK)) A 
					INNER JOIN [dbo].[scm_mst_project_model_demand_qty_temp$] B WITH(NOLOCK)
					ON	A.system_project_code	=	  B.system_project_code
				    AND A.model_id				=	  B.model_id ) A
		
		-- 처리가 안된 row : attr_15=X
		UPDATE [dbo].[xif_plm_pjt_model_quantity_r_sn] 
		SET proc_flag	= 'X' 
		WHERE proc_flag = 'P';
		
		DROP TABLE dbo.scm_mst_project_model_demand_qty_temp$;
		
        -- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_mst_project_model_demand_qty_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 2018. 5. 24  프로젝트 모델 소요량 정보 기준으로 MKT Fcst 생성 로직
		/* -- del 181011 GPLM 정보 미수신으로 수신후 로직 확인 코드 변경 필요
		 INSERT INTO dm_pln_mkt_fcst
		 (
			 division_id
			,project_code
			,scm_site_id
			,item_id
			,dom_exp
			,fcst_type
			,incoterms
			,measure
			,plant_site_id
			,yyyymmdd
			,qty
			,created_by
			,creation_date
			,last_updated_by
			,last_update_date
		 )
		SELECT b.division_id
			  ,b.project_code 
			  ,c.scm_site_id
			  ,a.model_id
			  ,'E'
			  ,'MPS' fcst_type
			  ,CASE WHEN b.incoterms = 'LOCAL' THEN 'Z01' ELSE b.incoterms END incoterms
			  ,'MKT_FCST' measure
			  ,'' plant_site_id
			  ,b.shipment_date
			  ,SUM(a.demand_qty) qty 
			  ,'GPLM_Partlist'
			  ,getdate()
			  ,'GPLM_Partlist'
			  ,getdate()
		FROM   scm_mst_project_model_demand_qty a WITH(NOLOCK)
			  ,scm_mst_project b WITH(NOLOCK)
			  ,scm_mst_site_item c WITH(NOLOCK)
			  ,scm_mst_site d WITH(NOLOCK)
		WHERE  a.project_code  = b.project_code 
		AND    b.division_id   = c.division_id 
		AND    b.project_code  = c.project_code
		AND    c.division_id   = d.division_id
		AND    c.scm_site_id   = d.scm_site_id
		AND    d.site_type     = 'SALES'
		AND    b.incoterms is not null
		AND    b.incoterms <> ''
		AND    b.shipment_date is not null
		AND    b.shipment_date <> ''
		AND    a.demand_qty is not null
		AND    a.demand_qty > 0
		AND    c.valid_yn = 'Y'
		AND    d.valid_yn = 'Y'
		-- MKT FCST에 해당 project code 로 정보가 존재하지 않는 경우처리
		AND   (SELECT count(1)
			   FROM   dm_pln_mkt_fcst  x
			   WHERE  x.project_code  = b.project_code
			   AND    x.division_id   = b.division_id 
			   ) = 0
		GROUP BY b.division_id
				,b.project_code 
				,c.scm_site_id
				,a.model_id
				,b.incoterms
				,b.shipment_date
       */

		-- 순차적 호출을 위함
		EXEC PR_SCM_MST_PROJECT_SCHEDULE;
		
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
