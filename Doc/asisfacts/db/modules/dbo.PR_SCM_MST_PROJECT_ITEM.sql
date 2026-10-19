---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : PR_SCM_MST_PROJECT_ITEM
 * Description  : GPLM Project Model I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 11    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 4. 23    kim Jaejung      scm_mst_site_item 에 없는 project , item mapping 정보 insert 로직 위치 마지막으로 변경
 * 2018.06.26     Kim Jaejung      소형 제외 로직 추가
 * 2018.07.02     Kim Jaejung      history 데이터 수집 시 조인 조건 추가(item_id)
 * 2019.01.09     KSG              Owner 정보 자동 추가
 * 2021.03.17	P.C.I		   [C20210312-000195] 'BPMS -> DMS -> GSCM' I/F를 'BPMS -> GSCM'으로 변경
 * 2021.10.14	HWI1993		[PJ20209643] 성능개선
 * 2022.12.18   CHANO0612  [C20221219-000136] Sales Site Project Model에 div. 81_UC도 수용하도록 수정 요청 건
 * 2024.11.11	P.C.I			[PJ20228272] NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S)
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_PROJECT_ITEM]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_PROJECT_ITEM';
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
		IF OBJECT_ID (N'tempdb..#T_IF_SEQ', N'U') IS NOT NULL 
			DROP TABLE #T_IF_SEQ
		IF OBJECT_ID (N'tempdb..#T_PJT_ITEM', N'U') IS NOT NULL 
			DROP TABLE #T_PJT_ITEM
		IF OBJECT_ID (N'tempdb..#T', N'U') IS NOT NULL 
			DROP TABLE #T
		
		CREATE TABLE #T_IF_SEQ
		(
		IF_SEQ NVARCHAR(100)
		)


		-- 인터페이스 테이블 처리 ROW UPDATE
		UPDATE [dbo].[xif_plm_pjt_model_master_r_sn]
		SET attr_10 = 'P'
		WHERE ISNULL(attr_10,'N') = 'N';

		-- IF_SEQ 를 모아놓는다.
		INSERT INTO #T_IF_SEQ ( IF_SEQ )
		SELECT DISTINCT IF_SEQ
		FROM XIF_PLM_PJT_MODEL_MASTER_R_SN (NOLOCK)
		WHERE ATTR_10 = 'P'	
	
		SELECT * INTO dbo.#T_PJT_ITEM
		FROM DBO.SCM_MST_PROJECT_ITEM;

		SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, A.MODEL_NAME
			,CASE WHEN A.IF_TYPE = 'D' THEN 'N' ELSE 'Y' END VALID_YN
			, A.IF_SEQ
		INTO #T
		FROM XIF_PLM_PJT_MODEL_MASTER_R_SN A (NOLOCK)
		JOIN  SCM_MST_PROJECT_MAPPING B (NOLOCK) ON A.PROJECT_ID = B.GPLM_PROJECT_CODE
		JOIN #T_IF_SEQ C ON A.IF_SEQ = C.IF_SEQ
		WHERE A.ATTR_10 = 'P'

		-- 마지막 SEQ 만 남긴다.
		DELETE A
		FROM #T A
		LEFT OUTER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, MODEL_NAME, MAX(IF_SEQ) AS MAX_SEQ
				FROM #T A 
				GROUP BY DIVISION_ID, PROJECT_CODE, MODEL_NAME
			) B ON A.DIVISION_ID = B.DIVISION_ID 
				AND A.PROJECT_CODE = B.PROJECT_CODE 
				AND A.MODEL_NAME = B.MODEL_NAME
				AND A.IF_SEQ = B.MAX_SEQ
		WHERE B.DIVISION_ID IS NULL


		MERGE INTO SCM_MST_PROJECT_ITEM A
		USING #T B
		ON ( A.DIVISION_ID	=  B.DIVISION_ID
		AND A.PROJECT_CODE	=  B.PROJECT_CODE
		AND A.ITEM_ID		=  B.MODEL_NAME
		)
		WHEN MATCHED THEN
		UPDATE SET A.VALID_YN			=  B.VALID_YN
					,A.LAST_UPDATED_BY	=  @V_BATCH_USER
					,A.LAST_UPDATE_DATE	=  GETDATE()
					                
		WHEN NOT MATCHED THEN
		INSERT (  
			DIVISION_ID
			, PROJECT_CODE
			, PROJECT_VER_SEQ
			, ITEM_ID
			, VALID_YN
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE						  								
		)
		VALUES (   
			B.DIVISION_ID
			, B.PROJECT_CODE
			, '' -- 수정필요
			, B.MODEL_NAME
			, B.VALID_YN
			, @V_BATCH_USER
			, GETDATE()
			, @V_BATCH_USER
			, GETDATE() 
		)
		;
			
		-----------------------------------------------------------
		-- Merge LOG
		-----------------------------------------------------------
		SET @v_log_type = 'APPEND';
		SET @v_log_message = 'MERGE INTO scm_mst_project_item';
		SET @v_description = 'if_seq = '
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		-----------------------------------------------------------

		-- 처리 ROW 마킹, 처리가 안된 ROW : ATTR_1=X ( MAX IFSEQ 가 아닌 것들도 처리된걸로 봄 )
		UPDATE XIF_PLM_PJT_MODEL_MASTER_R_SN
		SET    ATTR_10	 =  'Y'
		FROM   XIF_PLM_PJT_MODEL_MASTER_R_SN A (NOLOCK) 
		JOIN   SCM_MST_PROJECT_MAPPING B (NOLOCK) ON A.PROJECT_ID = B.GPLM_PROJECT_CODE			
		JOIN   [DBO].[SCM_MST_PROJECT_ITEM] C (NOLOCK) ON B.DIVISION_ID	= C.DIVISION_ID AND B.PROJECT_CODE = C.PROJECT_CODE AND C.ITEM_ID = A.MODEL_NAME
		WHERE  A.IF_SEQ	IN ( SELECT IF_SEQ FROM #T_IF_SEQ )
		
		UPDATE SCM_MST_PROJECT_ITEM
		SET    ITEM_TYPE = B.ITEM_TYPE
		FROM   SCM_MST_PROJECT_ITEM A WITH(NOLOCK) 
		JOIN   (SELECT A.DIVISION_ID, A.ITEM_ID
					, CASE  MIN( CASE WHEN A.ITEM_TYPE = 'P' THEN 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
											WHEN A.ITEM_TYPE = 'H' THEN 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
											WHEN A.ITEM_TYPE = 'Q' THEN 3
											ELSE 4 END )  
															WHEN 1 THEN 'P' 
															WHEN 2 THEN 'H'
															WHEN 3 THEN 'Q'
															ELSE 'R' END	AS ITEM_TYPE
				FROM SCM_MST_ITEM_SN A WITH(NOLOCK) 
				JOIN ( SELECT DISTINCT DIVISION_ID, MODEL_NAME AS ITEM_ID
						FROM #T B (NOLOCK) 
					) B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
				GROUP BY A.DIVISION_ID, A.ITEM_ID
				) B 
		ON     A.DIVISION_ID = B.DIVISION_ID
		AND    A.ITEM_ID = B.ITEM_ID;


		-- 추후 project_ver_seq 데이터가 제대로 넘어오면 삭제 필요. 
	    UPDATE SCM_MST_PROJECT_ITEM
	    SET    PROJECT_VER_SEQ =  B.PROJECT_VER_SEQ
	    FROM   SCM_MST_PROJECT_ITEM A (NOLOCK) 
		JOIN   SCM_MST_PROJECT B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
		WHERE  A.PROJECT_VER_SEQ = '';

		
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		 SET @n_history_seq = NEXT VALUE FOR seq1_scm_mst_project_item_h
		 INSERT INTO [dbo].[scm_mst_project_item_h] (
						     history_seq
						    ,division_id
							,project_code
							,project_ver_seq
							,item_id
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
					SELECT A.*,B.creation_date,B.last_update_date FROM (SELECT /* scm_mst_project_item_h */
						     division_id
							,project_code
							,project_ver_seq
							,item_id
							,valid_yn
					FROM [dbo].[#T_PJT_ITEM] WITH(NOLOCK)
					EXCEPT
					SELECT /* scm_mst_project_item_h */
						     division_id
							,project_code
							,project_ver_seq
							,item_id
							,valid_yn
				    FROM [dbo].[scm_mst_project_item] WITH(NOLOCK)) A 
					INNER JOIN [dbo].[#T_PJT_ITEM] B WITH(NOLOCK)
				   ON  A.division_id       =  B.division_id
				   AND A.project_code	   =  B.project_code
				   AND A.project_ver_seq   =  B.project_ver_seq
				   AND A.item_id		   =  B.item_id ) A  --2018.07.02
		

		-- 처리 row 마킹
		UPDATE [dbo].[xif_plm_pjt_model_master_r_sn]
		SET attr_10	=  'X'
		WHERE attr_10 = 'P';
		
		DROP TABLE dbo.#T_PJT_ITEM;


        -- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_mst_project_item_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 순차적 호출을 위함
		EXEC PR_SCM_MST_PROJECT_SCHEDULE;

		--[C20210312-000195] 'BPMS -> DMS -> GSCM' I/F를 'BPMS -> GSCM'으로 변경
		--EXEC PR_DM_DMS_PROJECT_ITEM;
		EXEC PR_SCM_MST_PROJECTBOM;

		-- [PJ20228272]  #INSERT_SITE_ITEM 에 신규 데이터 생성START
		
		BEGIN
			IF OBJECT_ID (N'tempdb..#INSERT_SITE_ITEM', N'U') IS NOT NULL 
				DROP TABLE #INSERT_SITE_ITEM


			SELECT     a.division_id
						,a.project_code
						,a.scm_site_id
						,b.item_id
						,(SELECT MAX(currency) 
						FROM   scm_mst_project WITH(NOLOCK) 
						WHERE  project_code = a.project_code 
						AND    division_id = a.division_id) currency
						,'Y'					AS SALES_PLAN_ADJUST_YN
						,'Y'					AS BPMS_EXIST
						,a.owner  -- 20190109 Owner 정보 자동 추가
						,'Y'					AS VALID_YN
						,@v_batch_user			AS CREATED_BY
						,GETDATE()				AS CREATION_DATE
						,@v_batch_user			AS LAST_UPDATED_BY
						,GETDATE()				AS LAST_UPDATE_DATE
			INTO    #INSERT_SITE_ITEM
			FROM  (SELECT si.division_id
							,si.project_code
							,si.scm_site_id
							,max(si.owner) owner  -- 20190109 Owner 정보 자동 추가
					FROM   scm_mst_site ms WITH(NOLOCK)
					JOIN   scm_mst_site_item si WITH(NOLOCK)
					ON     ms.division_id = si.division_id
					AND    ms.scm_site_id = si.scm_site_id
					WHERE  ms.valid_yn = 'Y'
					AND    si.valid_yn = 'Y'
					AND    ms.site_type = 'SALES'
					GROUP BY si.division_id, si.project_code, si.scm_site_id) a
			JOIN  (SELECT pi.division_id
							,pi.project_code
							,pi.item_id
					FROM   scm_mst_project_item pi WITH(NOLOCK)
					WHERE  valid_yn = 'Y'
					GROUP BY pi.division_id, pi.project_code, pi.item_id) b
			ON     a.division_id = b.division_id
			AND    a.project_code = b.project_code
			LEFT OUTER JOIN  
			scm_mst_site_item si WITH(NOLOCK)
				ON b.division_id = si.division_id
			AND b.project_code = si.project_code
			AND a.scm_site_id  = si.scm_site_id
			AND b.item_id      = si.item_id
			WHERE si.division_id IS NULL 
			--AND    b.division_id IN('81','82') -- 2018.06.26 소형 제외 로직 추가 ;
			AND    ( b.division_id LIKE '81%'
					OR B.DIVISION_ID = '82' ) --2022-12-18 내용수정 [C20221219-000136] Sales Site Project Model에 div. 81_UC도 수용하도록 수정 요청 건 ;
					
			-- [PJ20228272]  #INSERT_SITE_ITEM 에 신규 데이터 생성 END



			-- scm_mst_site_item 에 없는 project , item mapping 정보 insert 	
			INSERT INTO scm_mst_site_item(  
								 division_id
								,project_code
								,scm_site_id
								,item_id
								,currency
								,sales_plan_adjust_yn
								,bpms_exist
								,owner  -- 20190109 Owner 정보 자동 추가
								,valid_yn
								,created_by
								,creation_date
								,last_updated_by
								,last_update_date						  								
					)
			-- [PJ20228272] SCM_MST_SITE_ITEM 에 #INSERT_SITE_ITEM 데이터 Insert 하도록 변경 START
			SELECT DIVISION_ID
				 , PROJECT_CODE
				 , SCM_SITE_ID
				 , ITEM_ID
				 , CURRENCY
				 , SALES_PLAN_ADJUST_YN
				 , BPMS_EXIST
				 , OWNER
				 , VALID_YN
				 , CREATED_BY
				 , CREATION_DATE
				 , LAST_UPDATED_BY
				 , LAST_UPDATE_DATE
			FROM   #INSERT_SITE_ITEM WITH(NOLOCK)

				/*
			    SELECT     a.division_id
						  ,a.project_code
						  ,a.scm_site_id
						  ,b.item_id
						  ,(SELECT MAX(currency) 
						    FROM   scm_mst_project WITH(NOLOCK) 
							WHERE  project_code = a.project_code 
							AND    division_id = a.division_id) currency
						  ,'Y'
						  ,'Y'
                          ,a.owner  -- 20190109 Owner 정보 자동 추가
						  ,'Y'
						  ,@v_batch_user
						  ,GETDATE()
						  ,@v_batch_user
						  ,GETDATE() 
					FROM  (SELECT si.division_id
								 ,si.project_code
								 ,si.scm_site_id
								 ,max(si.owner) owner  -- 20190109 Owner 정보 자동 추가
						   FROM   scm_mst_site ms WITH(NOLOCK)
						   JOIN   scm_mst_site_item si WITH(NOLOCK)
						   ON     ms.division_id = si.division_id
						   AND    ms.scm_site_id = si.scm_site_id
						   WHERE  ms.valid_yn = 'Y'
						   AND    si.valid_yn = 'Y'
						   AND    ms.site_type = 'SALES'
						   GROUP BY si.division_id, si.project_code, si.scm_site_id) a
					JOIN  (SELECT pi.division_id
								 ,pi.project_code
								 ,pi.item_id
						   FROM   scm_mst_project_item pi WITH(NOLOCK)
						   WHERE  valid_yn = 'Y'
						   GROUP BY pi.division_id, pi.project_code, pi.item_id) b
					ON     a.division_id = b.division_id
					AND    a.project_code = b.project_code
					LEFT OUTER JOIN  
					scm_mst_site_item si WITH(NOLOCK)
					 ON b.division_id = si.division_id
					AND b.project_code = si.project_code
					AND a.scm_site_id  = si.scm_site_id
					AND b.item_id      = si.item_id
					WHERE si.division_id IS NULL 
					--AND    b.division_id IN('81','82') -- 2018.06.26 소형 제외 로직 추가 ;
					AND    ( b.division_id LIKE '81%'
							OR B.DIVISION_ID = '82' ) --2022-12-18 내용수정 [C20221219-000136] Sales Site Project Model에 div. 81_UC도 수용하도록 수정 요청 건 ;
					*/
			-- [PJ20228272] SCM_MST_SITE_ITEM 에 #INSERT_SITE_ITEM 데이터 Insert 하도록 변경 END

			
			-- [PJ20228272] SCM_MST_SITE_ITEM_H 에 #INSERT_SITE_ITEM 데이터 Insert 추가 START

			INSERT INTO SCM_MST_SITE_ITEM_H
					  ( DIVISION_ID
					  , HISTORY_SEQ
					  , PROJECT_CODE
					  , SCM_SITE_ID
					  , ITEM_ID
					  , CURRENCY
					  , SALES_PLAN_ADJUST_YN
					  , BPMS_EXIST
					  , OWNER
					  , VALID_YN
					  , CREATED_BY
					  , CREATION_DATE
					  , LAST_UPDATED_BY
					  , LAST_UPDATE_DATE
					  )
			SELECT DIVISION_ID
				 , NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_H  -- History Seqno
				 , PROJECT_CODE
				 , SCM_SITE_ID
				 , ITEM_ID
				 , CURRENCY
				 , SALES_PLAN_ADJUST_YN
				 , BPMS_EXIST
				 , OWNER
				 , VALID_YN
				 , CREATED_BY
				 , CREATION_DATE
				 , LAST_UPDATED_BY
				 , LAST_UPDATE_DATE
			FROM   #INSERT_SITE_ITEM WITH(NOLOCK)
			
			-- [PJ20228272] SCM_MST_SITE_ITEM_H 에 #INSERT_SITE_ITEM 데이터 Insert 추가 END

			-- [PJ20228272] NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) START
			IF (SELECT COUNT(1) FROM #INSERT_SITE_ITEM WHERE DIVISION_ID LIKE '81%') > 0

			BEGIN 

				IF OBJECT_ID (N'tempdb..#XIF_ERP_SITE_ITEM', N'U') IS NOT NULL 
					DROP TABLE #XIF_ERP_SITE_ITEM
			
                SELECT DIVISION_ID
					 , SCM_SITE_ID
					 , PROJECT_CODE
					 , ITEM_ID
					 , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
				INTO   #XIF_ERP_SITE_ITEM 
				FROM   #INSERT_SITE_ITEM
				;

				EXEC PR_DM_XIF_ERP_SITE_ITEM_S;

			END
			-- [PJ20228272] NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) END
			
		END
		

		IF OBJECT_ID (N'tempdb..#T_IF_SEQ', N'U') IS NOT NULL 
			DROP TABLE #T_IF_SEQ
		IF OBJECT_ID (N'tempdb..#T_PJT_ITEM', N'U') IS NOT NULL 
			DROP TABLE #T_PJT_ITEM
		IF OBJECT_ID (N'tempdb..#T', N'U') IS NOT NULL 
			DROP TABLE #T
	  

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
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



