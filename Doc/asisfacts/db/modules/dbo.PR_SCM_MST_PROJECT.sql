---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : PR_SCM_MST_PROJECT
 * Description  : Project(BPMS) Master 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.10   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.04   Kim Jaejung    Project_ver_seq 의 MAX 데이터만 보관하기 위해 Merge문 On 절에 AND A.project_ver_seq   <=  B.bpms_project_ver_seq
 *							   조건을 추가하고 더 낮은 Project_ver_seq INSERT 시 찾아서 삭제하는 로직 추가
 * 2018.04.06				   Project_owner 관련 로직 변경
 * 2018.04.18   Kim Jaejung	   product_group_code , product_group_name 컬럼 추가 로직 반영
 * 2018.05.15   Kim Jaejung	   Incoterms 컬럼 추가 
 * 2018.05.30   Kim Jaejung    shipment_date 데이터 mass_production_date 데이터로 변경, mass_production_date 컬럼이 출하일자로 인터페이스됨.
 * 20200120     KHSONG         C20200117-000150,C20200123-000132 특정 Project Code에 대하여 1차수만 사용토록 하드코딩 요청
 * 20200120     KHSONG         C20200117-000150,C20200123-000132 특정 Project Code에 대하여 1차수만 사용토록 하드코딩 요청
 * 2021.03.29     P.C.I		   [C20210311-000255] bpms_project_ver_seq 조건 제외하여 Merge 처리 
 * 2022.05.04	HWI1993			GM JV
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_PROJECT]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_PROJECT';
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
		UPDATE [dbo].[xif_plm_pjt_bpms_r_sn]
		SET    proc_flag = 'P'
		WHERE  ISNULL(proc_flag,'N') = 'N';
	  
	    -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	    DECLARE CUR_PROJECT CURSOR FOR
	      SELECT if_seq 
	      FROM   [dbo].[xif_plm_pjt_bpms_r_sn] WITH(NOLOCK)
	      WHERE  proc_flag = 'P'
	      GROUP BY if_seq
	      ORDER BY if_seq ASC;

	  -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
	  IF OBJECT_ID (N'tempdb..#T_scm_mst_project_temp', N'U') IS NOT NULL 
		DROP TABLE #T_scm_mst_project_temp
	  
	  SELECT * 
	  INTO   dbo.#T_scm_mst_project_temp
	  FROM   dbo.scm_mst_project WITH(NOLOCK);

	  OPEN CUR_PROJECT;
	  FETCH NEXT FROM CUR_PROJECT INTO @v_ifseqno ;
		 
	    WHILE (@@FETCH_STATUS = 0)
		  BEGIN
		   

		    MERGE INTO [dbo].[scm_mst_project] A
			USING (
				  SELECT /* PR_SCM_MST_PROJECT */ 
			               B.SEGMENT2 AS biz_unit_code
						  ,bpms_project_code
						  ,MAX(bpms_project_ver_seq) bpms_project_ver_seq
					 	  ,MAX(project_name) project_name
						  ,MAX(biz_type) biz_type
						  ,ISNULL(dbo.[FN_GET_LOOKUP_CODE_DESC]('BIZ_TYPE_BPMS', MAX(A.biz_type)), MAX(biz_type_name)) AS biz_type_name
						  ,MAX(bpms_project_step_code) bpms_project_step_code
						  --,CASE WHEN CHARINDEX(',',MAX(remark),1) > 1 THEN SUBSTRING(MAX(remark),0,CHARINDEX(',',MAX(REMARK),1)) ELSE MAX(REMARK) END AS owner_team  20180405 변경
						  ,MAX(actual_reviewer_id) AS owner_team
						  ,MAX(selling_price_currency_code) selling_price_currency_code
						  ,MAX(drop_is_yn) drop_is_yn
						  ,MAX(unit_capacity) unit_capacity
						  ,CONVERT(CHAR(8), MAX(mass_production_date), 112) AS shipment_date --2018.05.30
						  ,MAX(product_group_code) product_group_code   --  2018.04.18
						  ,dbo.[FN_GET_LOOKUP_CODE_DESC]('PRODUCT_GROUP_GPLM', MAX(A.product_group_code)) AS product_group_name --  2018.04.18
						  ,MAX(incoterms_code) incoterms
						  ,MAX(CAST(A.OPM_RATIO AS NVARCHAR(30))) AS OPM_RATIO
				   FROM   [dbo].[xif_plm_pjt_bpms_r_sn] A WITH(NOLOCK)
				   JOIN		SCM_ADM_LOOKUP_MASTER_DETAIL B (NOLOCK) ON A.BIZ_UNIT_CODE = B.SEGMENT1 AND B.VALID_YN = 'Y'
				   WHERE  if_seq = @v_ifseqno
				   AND    proc_flag = 'P'
				   AND    bpms_project_code+bpms_project_ver_seq IN(
										SELECT bpms_project_code+max(bpms_project_ver_seq) 
										FROM   [xif_plm_pjt_bpms_r_sn]  WITH(NOLOCK) 
										WHERE  if_seq = @v_ifseqno
										AND    proc_flag = 'P'
										GROUP BY bpms_project_code)
				   AND    biz_unit_code IS NOT NULL
				   and bpms_project_ver_seq = (CASE WHEN bpms_project_code in ('A15RT5003','A17CR5001') THEN '0000000001' ELSE bpms_project_ver_seq END)  --20200120 KHSONG C20200117-000150, C20200123-000132
				   GROUP BY biz_unit_code
						   ,bpms_project_code
						   ,B.SEGMENT2


					) B
			ON (       A.division_id       =  B.biz_unit_code
				   AND A.project_code	   =  B.bpms_project_code
				   --[C20210311-000255] bpms_project_ver_seq 조건 제외하여 Merge 처리 
				   --AND A.project_ver_seq   <=  B.bpms_project_ver_seq  -- 2018.04.04

			   )
			WHEN MATCHED THEN
				 UPDATE SET 

							 A.project_ver_seq				=  B.bpms_project_ver_seq
							,A.project_name					=  B.project_name
							,A.biz_type						=  B.biz_type
							,A.biz_type_name				=  B.biz_type_name
							,A.project_status				=  B.bpms_project_step_code
							,A.project_owner				=  B.owner_team
							,A.currency					    =  B.selling_price_currency_code
							,A.drop_yn						=  B.drop_is_yn
							,A.capacity						=  B.unit_capacity
							,A.shipment_date				=  B.shipment_date
							,A.product_group_code			=  B.product_group_code  --  2018.04.18
							,A.product_group_name			=  B.product_group_name  --  2018.04.18
							,A.incoterms					=  B.incoterms			 --  2018.05.15
							,A.last_updated_by				=  @v_batch_user
							,A.last_update_date				=  GETDATE()
							,A.ATTRIBUTE1					= B.OPM_RATIO

					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				             division_id
							,project_code
							,project_ver_seq
							,project_name
							,biz_type
							,biz_type_name
							,project_status
							,project_owner
							,currency
							,drop_yn
							,capacity
							,shipment_date
							,product_group_code  --  2018.04.18
							,product_group_name  --  2018.04.18
							,incoterms			 --  2018.05.15
					        ,created_by
						    ,creation_date
						    ,last_updated_by
						    ,last_update_date
							,ATTRIBUTE1						  								
						)
				 VALUES (   
							 B.biz_unit_code
							,B.bpms_project_code
							,B.bpms_project_ver_seq
							,B.project_name
							,B.biz_type
							,B.biz_type_name
							,B.bpms_project_step_code
							,B.owner_team
							,B.selling_price_currency_code
							,B.drop_is_yn
							,B.unit_capacity
							,B.shipment_date
							,product_group_code  --  2018.04.18
							,product_group_name  --  2018.04.18
							,B.incoterms		 --  2018.05.15
						    ,@v_batch_user
						    ,GETDATE()
						    ,@v_batch_user
						    ,GETDATE()
							,B.OPM_RATIO 
						)
			;


		-- 처리 row 마킹
			UPDATE [dbo].[xif_plm_pjt_bpms_r_sn]
			SET    proc_flag	 =  'Y'
			FROM   [dbo].[xif_plm_pjt_bpms_r_sn] A WITH(NOLOCK)
			JOIN	SCM_ADM_LOOKUP_MASTER_DETAIL B (NOLOCK) ON A.BIZ_UNIT_CODE = B.SEGMENT1 AND B.VALID_YN = 'Y'
			JOIN   scm_mst_project C WITH(NOLOCK) ON B.SEGMENT2 = C.division_id
			AND    A.bpms_project_code	 =  C.project_code
			WHERE  A.if_seq		=  @v_ifseqno
			AND    A.proc_flag	= 'P';

		--[C20210311-000255] bpms_project_ver_seq 조건 제외되므로 아래 쿼리 제외
		-- 2018.04.04 : MAX project_ver_seq 제외한 나머지 지워야할 대상 삭제
		/*
		DELETE FROM SCM_MST_PROJECT 
		WHERE  division_id+project_code IN(SELECT division_id+project_code
		                                   FROM   SCM_MST_PROJECT WITH(NOLOCK) 
		                                   GROUP BY division_id,project_code
		                                   HAVING COUNT(*) > 1)
		AND    division_id+project_code+project_ver_seq NOT IN (SELECT division_id+project_code+MAX(project_ver_seq)
		                                                        FROM   SCM_MST_PROJECT WITH(NOLOCK) 
		                                                        GROUP BY division_id,project_code
		                                                        HAVING COUNT(*) > 1);*/
			 -----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO scm_mst_project';
              SET @v_description = 'if_seq = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

			FETCH NEXT FROM CUR_PROJECT INTO  @v_ifseqno
			END
		
		CLOSE CUR_PROJECT;
		DEALLOCATE CUR_PROJECT; 

		
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		 SET @n_history_seq = NEXT VALUE FOR seq1_scm_mst_project_h
		 INSERT INTO [dbo].[scm_mst_project_h] (
						     history_seq
						    ,division_id
							,project_code
							,project_ver_seq
							,project_name
							,biz_type
							,biz_type_name
							,project_status
							,project_owner
							,currency
							,drop_yn
							,capacity	
							,shipment_date
							,product_group_code  --  2018.04.18
							,product_group_name  --  2018.04.18
							,incoterms			 --  2018.05.15
						    ,ATTRIBUTE1

							,creation_date
						    ,last_update_date							

						    ,created_by					
						    ,last_updated_by	
						    ,history_creation_date
							
					  )
				 SELECT @n_history_seq
			       ,A.*
				   ------
				   ,@v_batch_user
				   ,@v_batch_user
				   ,GETDATE()
	        FROM (
					SELECT A.*,B.creation_date,B.last_update_date 
					FROM (
						SELECT /* scm_mst_project_h */
								 division_id
								,project_code
								,project_ver_seq
								,project_name
								,biz_type
								,biz_type_name
								,project_status
								,project_owner
								,currency
								,drop_yn
								,capacity
								,shipment_date
								,product_group_code  --  2018.04.18
								,product_group_name  --  2018.04.18
								,incoterms			 --  2018.05.15
								,ATTRIBUTE1
						FROM [dbo].[#T_scm_mst_project_temp] WITH(NOLOCK)
						EXCEPT
						SELECT /* scm_mst_project_h */
								 division_id
								,project_code
								,project_ver_seq
								,project_name
								,biz_type
								,biz_type_name
								,project_status
								,project_owner
								,currency
								,drop_yn
								,capacity
								,shipment_date
								,product_group_code  --  2018.04.18
								,product_group_name  --  2018.04.18
								,incoterms			 --  2018.05.15
								,ATTRIBUTE1
						FROM [dbo].[scm_mst_project] WITH(NOLOCK)
						) A 
					INNER JOIN [dbo].[#T_scm_mst_project_temp] B WITH(NOLOCK)
					ON  A.division_id       =  B.division_id
					AND A.project_code	   =  B.project_code
					AND A.project_ver_seq   =  B.project_ver_seq 
					) A
		
	
		-- 처리 row 마킹
		UPDATE [dbo].[xif_plm_pjt_bpms_r_sn]
		SET proc_flag	=  'X'
		WHERE proc_flag = 'P';
	
		
		DROP TABLE dbo.#T_scm_mst_project_temp;
		
        -- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_mst_project_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 순차적 호출을 위함
		EXEC PR_SCM_MST_PROJECT_DV_MASTER;
		
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
