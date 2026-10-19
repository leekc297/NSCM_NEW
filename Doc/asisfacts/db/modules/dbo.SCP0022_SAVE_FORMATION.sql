


/*
 * Program ID   : SCP0022_SAVE_FORMATION
 * Description  : Formation 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/14   kyh				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/18	kyh				신규 컬럼 추가. @p_Add_LT_Formation
 * 2109/04/08	yhw				[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2019/04/11	AYJ				SSP_MODIFY_YIELD 컬럼 추가
 * 2025/10/29   hrkim		    [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
 */
CREATE PROCEDURE [dbo].[SCP0022_SAVE_FORMATION]
	  @p_active_flag 			NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_Lf_Formation			NVARCHAR(MAX)
	, @p_Add_LT_Formation		NVARCHAR(MAX)
	, @p_formation_yield		NVARCHAR(MAX)	
	, @p_char_yield				NVARCHAR(MAX)	
	, @p_formation_total_yield	NVARCHAR(MAX)	
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_user_modify_yield		NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag 				NVARCHAR(MAX) = null;
	DECLARE @v_division_id				NVARCHAR(MAX) = null;
	DECLARE @v_plant_site_id			NVARCHAR(MAX) = null;
	DECLARE @v_item_id					NVARCHAR(MAX) = null;
	DECLARE @v_Lf_Formation				NVARCHAR(MAX) = null;
	DECLARE @v_Add_LT_Formation			NVARCHAR(MAX) = null;
	DECLARE @v_formation_yield			NVARCHAR(MAX) = null;
	DECLARE @v_char_yield				NVARCHAR(MAX) = null;
	DECLARE @v_formation_total_yield	NVARCHAR(MAX) = null;
	DECLARE @v_created_by				NVARCHAR(MAX) = @p_created_by;		  -- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 변수 초기값 (파라미터 값)
	DECLARE @v_last_updated_by			NVARCHAR(MAX) = @p_last_updated_by;	  -- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 변수 초기값 (파라미터 값)
	DECLARE @v_user_modify_yield		NVARCHAR(MAX) = null;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0022_SAVE_Formation';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		--PRINT '1';
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag				= dbo.SCM_ARR_SPL_VAL( @p_active_flag	    , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id				= dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_plant_site_id			= dbo.SCM_ARR_SPL_VAL( @p_plant_site_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id					= dbo.SCM_ARR_SPL_VAL( @p_item_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_Lf_Formation				= dbo.SCM_ARR_SPL_VAL( @p_Lf_Formation     , @v_delimiter, @mst_loop_cnt );
				SET @v_Add_LT_Formation			= dbo.SCM_ARR_SPL_VAL( @p_Add_LT_Formation     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_yield			= dbo.SCM_ARR_SPL_VAL( @p_formation_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_char_yield				= dbo.SCM_ARR_SPL_VAL( @p_char_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_total_yield    = dbo.SCM_ARR_SPL_VAL( @p_formation_total_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_user_modify_yield		= dbo.SCM_ARR_SPL_VAL( @p_user_modify_yield     , @v_delimiter, @mst_loop_cnt );

				--PRINT '6';
				--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

			------------------------------------------------------------------------------------------------------------------------------ 
			--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
			-- JV real plant site -> ESS virtaul plant site 단방향 저장 (virtual plant이면 skip) 
			------------------------------------------------------------------------------------------------------------------------------
			IF EXISTS (SELECT TOP 1 'X'
						 FROM SCM_MST_SITE RS WITH(NOLOCK)
							  INNER JOIN SCM_MST_PLANT_SN RP WITH(NOLOCK)	-- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
									  ON RS.COMPANY_ID	= RP.COMPANY_ID
									 AND RS.DIVISION_ID	= RP.DIVISION_ID
									 AND RS.SITE_ID		= RP.SITE_ID
									 AND RS.PLANT_ID	= RP.PLANT_ID
						WHERE 1=1
						  AND RS.DIVISION_ID	= @v_division_id
						  AND RS.SCM_SITE_ID	= @v_plant_site_id
						  AND RP.PLANT_TYPE		= 'VIRTUAL'	
						)  CONTINUE ;  -- virtual plant site 이면 skip  
			------------------------------------------------------------------------------------------------------------------------------ 
			--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
			------------------------------------------------------------------------------------------------------------------------------

			declare @p_creation_date datetime =  SYSDATETIME();

		   --이력저장
			EXEC [dbo].[PR_SCP_MST_FORMATION_HIST] 
				@v_division_id, @v_plant_site_id, @v_item_id , @v_Lf_Formation , @v_Add_LT_Formation, @v_formation_yield ,@v_char_yield , @v_formation_total_yield , 
				@p_created_by, @p_last_updated_by , @p_creation_date, @v_user_modify_yield
			;
			
			--데이터 저장
			IF @mst_loop_cnt > 0
			BEGIN
				MERGE INTO SCP_MST_FORMATION A
				USING (
					SELECT 
						  @v_division_id as division_id
						, @v_plant_site_id as plant_site_id
						, @v_item_id as item_id
				) B
				ON(
						A.division_id = B.division_id
					AND A.plant_site_id = B.plant_site_id
					AND A.item_id = B.item_id
				)
				WHEN MATCHED THEN
					UPDATE SET 
						  lt_formation			= @v_Lf_Formation
						, ATTRIBUTE1			= @v_Add_LT_Formation
						, formation_yield		= CASE WHEN ISNULL(@v_formation_yield,'')='' THEN null ELSE (convert(float , @v_formation_yield) / 100) end
						, CHAR_YIELD			= CASE WHEN ISNULL(@v_char_yield,'')='' THEN null ELSE (convert(float , @v_char_yield) / 100)  end
						, FORMATION_TOTAL_YIELD	= CASE WHEN ISNULL(@v_formation_total_yield,'')='' THEN null ELSE (convert(float , @v_formation_total_yield) / 100) end
						, last_updated_by		= @p_last_updated_by
						, last_update_date		= sysdatetime()
						, SSP_MODIFY_YIELD		= CASE WHEN ISNULL(@v_user_modify_yield,'')='' THEN null ELSE (convert(float , @v_user_modify_yield) / 100) end
				WHEN NOT MATCHED THEN							                                             
					INSERT 	   (
						  division_id                    
						, plant_site_id                  
						, ITEM_ID
						, LT_FORMATION
						, FORMATION_YIELD
						, CHAR_YIELD
						, FORMATION_TOTAL_YIELD
						, created_by
						, creation_date                  
						, last_updated_by                
						, last_update_date
						, ATTRIBUTE1
						, SSP_MODIFY_YIELD
					)                   
					VALUES (
						  @v_division_id     
						, @v_plant_site_id   
						, @v_item_id
						, @v_Lf_Formation
						, CASE WHEN ISNULL(@v_formation_yield,'')='' THEN null ELSE (convert(float , @v_formation_yield) / 100) end
						, CASE WHEN ISNULL(@v_char_yield,'')='' THEN null ELSE (convert(float , @v_char_yield) / 100)  end
						, CASE WHEN ISNULL(@v_formation_total_yield,'')='' THEN null ELSE (convert(float , @v_formation_total_yield) / 100) end
						, @p_created_by
						, sysdatetime()
						, @p_last_updated_by 
						, sysdatetime()
						, @v_Add_LT_Formation
						, CASE WHEN ISNULL(@v_user_modify_yield,'')='' THEN null ELSE (convert(float , @v_user_modify_yield) / 100) end
					);

				------------------------------------------------------------------------------------------------------------------------------ 
				--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
				------------------------------------------------------------------------------------------------------------------------------
				----------------------------------------------------- 
				-- #.1 가상 Plant 사이트 대상 데이터 추출 
				----------------------------------------------------- 
				IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION_VIRTUAL_SITE') IS NOT NULL DROP TABLE #SCP_MST_FORMATION_VIRTUAL_SITE

				SELECT VS.DIVISION_ID	AS VS_DIVISION_ID
					  ,VS.SCM_SITE_ID	AS VS_PLANT_SITE_ID
					  ,VS.PLANT_ID		AS VS_PLANT_ID
					  ,RS.DIVISION_ID	AS RS_DIVISION_ID
					  ,RS.SCM_SITE_ID	AS RS_PLANT_SITE_ID
					  ,RS.PLANT_ID		AS RS_PLANT_ID
					  ,RF.ITEM_ID
					  ,CAST(RF.LT_FORMATION				AS NUMERIC(20,10))	AS LT_FORMATION			
					  ,CAST(RF.FORMATION_YIELD			AS NUMERIC(20,10))	AS FORMATION_YIELD		
					  ,CAST(RF.CHAR_YIELD				AS NUMERIC(20,10))	AS CHAR_YIELD			
					  ,CAST(RF.FORMATION_TOTAL_YIELD	AS NUMERIC(20,10))	AS FORMATION_TOTAL_YIELD
					  ,CAST(RF.SSP_MODIFY_YIELD			AS NUMERIC(20,10))	AS SSP_MODIFY_YIELD		
					  ,RF.ATTRIBUTE1	
					  ,ROW_NUMBER() OVER (PARTITION BY VS.DIVISION_ID
													  ,VS.SCM_SITE_ID
													  ,RF.ITEM_ID
											  ORDER BY RF.LAST_UPDATE_DATE DESC) AS RN 
				 INTO #SCP_MST_FORMATION_VIRTUAL_SITE
				 FROM SCM_MST_PLANT_SN VP WITH(NOLOCK)
					  INNER JOIN SCM_MST_SITE VS WITH(NOLOCK)
							  ON VS.COMPANY_ID	= VP.COMPANY_ID
							 AND VS.DIVISION_ID = VP.DIVISION_ID
							 AND VS.PLANT_ID	= VP.PLANT_ID
							 AND VS.SITE_ID		= VP.SITE_ID
							 AND VS.SITE_TYPE	= 'PLANT'
							 AND VS.VALID_YN	= 'Y'
					  INNER JOIN SCM_MST_SITE RS WITH(NOLOCK)
							  ON RS.SCM_SITE_ID	= VS.ATTRIBUTE9 
							 AND RS.PLANT_ID	= VP.LINK_PLANT_ID
							 AND RS.SITE_TYPE	= 'PLANT'
							 AND RS.VALID_YN	= 'Y'
					  INNER JOIN SCP_MST_FORMATION RF WITH(NOLOCK)  -- DIVISION_ID, PLANT_SITE_ID, ITEM_ID 
							  ON RF.DIVISION_ID		= RS.DIVISION_ID
							 AND RF.PLANT_SITE_ID	= RS.SCM_SITE_ID
				WHERE 1=1
				  AND RS.DIVISION_ID	= @v_division_id	-- Real plant 기준
				  AND RS.SCM_SITE_ID	= @v_plant_site_id
				  AND RF.ITEM_ID		= @v_item_id		
				  AND VP.PLANT_TYPE		= 'VIRTUAL'

				----------------------------------------------------- 
				-- #.2 가상 Plant 사이트 대상 이력 생성 
				----------------------------------------------------- 
				INSERT INTO SCP_MST_FORMATION_H
					  (HISTORY_SEQ
					  ,DIVISION_ID
					  ,PLANT_SITE_ID
					  ,ITEM_ID
					  ,LT_FORMATION
					  ,FORMATION_YIELD
					  ,CHAR_YIELD
					  ,FORMATION_TOTAL_YIELD
					  ,SSP_MODIFY_YIELD
					  ,CREATED_BY
					  ,CREATION_DATE
					  ,LAST_UPDATED_BY
					  ,LAST_UPDATE_DATE
					  ,ATTRIBUTE1
					  ,HISTORY_CREATION_DATE)
				SELECT NEXT VALUE FOR SEQ1_SCP_MST_FORMATION_H	AS HISTORY_SEQ
					  ,TG.DIVISION_ID
					  ,TG.PLANT_SITE_ID
					  ,TG.ITEM_ID
					  ,TG.LT_FORMATION
					  ,TG.FORMATION_YIELD
					  ,TG.CHAR_YIELD
					  ,TG.FORMATION_TOTAL_YIELD
					  ,TG.SSP_MODIFY_YIELD
					  ,TG.CREATED_BY
					  ,TG.CREATION_DATE
					  ,TG.LAST_UPDATED_BY
					  ,TG.LAST_UPDATE_DATE
					  ,TG.ATTRIBUTE1
					  ,GETDATE()								AS HISTORY_CREATION_DATE
				 FROM SCP_MST_FORMATION TG WITH(NOLOCK)
					  INNER JOIN #SCP_MST_FORMATION_VIRTUAL_SITE VF
							  ON VF.VS_DIVISION_ID	= TG.DIVISION_ID
							 AND VF.VS_PLANT_SITE_ID= TG.PLANT_SITE_ID
							 AND VF.ITEM_ID			= TG.ITEM_ID 
							 AND VF.RN				= 1 
				WHERE ISNULL(VF.LT_FORMATION, 0)			!= ISNULL(TG.LT_FORMATION, 0)
				   OR ISNULL(VF.FORMATION_YIELD, 0)			!= ISNULL(TG.FORMATION_YIELD, 0)
				   OR ISNULL(VF.CHAR_YIELD, 0)				!= ISNULL(TG.CHAR_YIELD, 0)
				   OR ISNULL(VF.FORMATION_TOTAL_YIELD, 0)	!= ISNULL(TG.FORMATION_TOTAL_YIELD, 0)
				   OR ISNULL(VF.SSP_MODIFY_YIELD, 0)		!= ISNULL(TG.SSP_MODIFY_YIELD, 0)
				   OR ISNULL(VF.ATTRIBUTE1, '')				!= ISNULL(TG.ATTRIBUTE1, '')

				----------------------------------------------------- 
				-- #.3 가상 Plant 사이트 대상 데이터 Update 
				----------------------------------------------------- 
				UPDATE TG
				   SET TG.LT_FORMATION			= VF.LT_FORMATION
					 , TG.FORMATION_YIELD		= VF.FORMATION_YIELD
					 , TG.CHAR_YIELD			= VF.CHAR_YIELD
					 , TG.FORMATION_TOTAL_YIELD	= VF.FORMATION_TOTAL_YIELD
					 , TG.SSP_MODIFY_YIELD		= VF.SSP_MODIFY_YIELD
					 , TG.ATTRIBUTE1			= VF.ATTRIBUTE1
					 , TG.LAST_UPDATE_DATE		= GETDATE()
					 , TG.LAST_UPDATED_BY		= @v_last_updated_by
				 FROM SCP_MST_FORMATION TG WITH(NOLOCK)
					  INNER JOIN #SCP_MST_FORMATION_VIRTUAL_SITE VF
							  ON VF.VS_DIVISION_ID	= TG.DIVISION_ID
							 AND VF.VS_PLANT_SITE_ID= TG.PLANT_SITE_ID
							 AND VF.ITEM_ID			= TG.ITEM_ID 
							 AND VF.RN				= 1 
				WHERE ISNULL(VF.LT_FORMATION, 0)			!= ISNULL(TG.LT_FORMATION, 0)
				   OR ISNULL(VF.FORMATION_YIELD, 0)			!= ISNULL(TG.FORMATION_YIELD, 0)
				   OR ISNULL(VF.CHAR_YIELD, 0)				!= ISNULL(TG.CHAR_YIELD, 0)
				   OR ISNULL(VF.FORMATION_TOTAL_YIELD, 0)	!= ISNULL(TG.FORMATION_TOTAL_YIELD, 0)
				   OR ISNULL(VF.SSP_MODIFY_YIELD, 0)		!= ISNULL(TG.SSP_MODIFY_YIELD, 0)
				   OR ISNULL(VF.ATTRIBUTE1, '')				!= ISNULL(TG.ATTRIBUTE1, '')

				----------------------------------------------------- 
				-- #.4 가상 Plant 사이트 대상 데이터 insert 
				----------------------------------------------------- 
				INSERT INTO SCP_MST_FORMATION
					  (  DIVISION_ID
						,PLANT_SITE_ID
						,ITEM_ID
						,LT_FORMATION
						,FORMATION_YIELD
						,CHAR_YIELD
						,FORMATION_TOTAL_YIELD
						,SSP_MODIFY_YIELD
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,ATTRIBUTE1)
				SELECT VF.VS_DIVISION_ID
					  ,VF.VS_PLANT_SITE_ID
					  ,VF.ITEM_ID
					  ,VF.LT_FORMATION
					  ,VF.FORMATION_YIELD
					  ,VF.CHAR_YIELD
					  ,VF.FORMATION_TOTAL_YIELD
					  ,VF.SSP_MODIFY_YIELD
					  ,@v_created_by		AS CREATED_BY
					  ,GETDATE()			AS CREATION_DATE
					  ,@v_last_updated_by	AS LAST_UPDATED_BY
					  ,GETDATE()			AS LAST_UPDATE_DATE
					  ,VF.ATTRIBUTE1
				 FROM #SCP_MST_FORMATION_VIRTUAL_SITE VF
				WHERE 1=1
				  AND VF.RN		=	1
				  AND NOT EXISTS (SELECT 'X'
									FROM SCP_MST_FORMATION TG WITH(NOLOCK)
								   WHERE TG.DIVISION_ID		= VF.VS_DIVISION_ID
									 AND TG.PLANT_SITE_ID	= VF.VS_PLANT_SITE_ID
									 AND TG.ITEM_ID			= VF.ITEM_ID) 

				------------------------------------------------------------------------------------------------------------------------------ 
				--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
				------------------------------------------------------------------------------------------------------------------------------

			END
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION_VIRTUAL_SITE') IS NOT NULL DROP TABLE #SCP_MST_FORMATION_VIRTUAL_SITE	-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리

		---- 결과코드, 결과 카운트 반환
		--SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END


