

/*
 * Program ID   : SCP0013_SAVE_PRODUCTION_PLAN_LINE_POPUP
 * Description  : PRODUCTION PLAN LINE 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/08/22	ygkim   		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/08/31	hwyoon			validation 체크 추가(동일plan, tact time)
 * 2018/08/31	hwyoon			ORIGIN_DIVISION_ID 수정(EE일때만 SCP_MST_FINAL_ITEM 적용)
 * 2018/09/04   hwyoon			EE 일 경우 SCM_ADM_LOOKUP_MASTER_DETAIL에 Plant Site, Line 정보 넣는 로직 추가
 * 2018/12/06	hwyoon			plant site id 입력 시 파라미터 값 그대로 입력 (top1 제거)
 * 2018/12/13	hwyoon			외주 packer 입력 시 T/T 체크 제거. 공정ID 변경
 * 2020/02/07	hwyoon			ESS 외주 Pakcer Line 생산 Target 적용
 * 2020/10/28   khj79           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
   2022/05/10   chaan           [] V1.1 DIvision 필터링 추가(lookup->ATTRIBUTE2)
                                        EE_PRODUCTION_PLAN
 * 2023/04/10   LWY				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 */
--ALTER PROCEDURE [dbo].[SCP0013_SAVE_PRODUCTION_PLAN_LINE_POPUP]
CREATE PROCEDURE [dbo].[SCP0013_SAVE_PRODUCTION_PLAN_LINE_POPUP_20251111_org]
	 @p_division_id       NVARCHAR(MAX)
	,@p_plan_date	      NVARCHAR(MAX)
	,@p_plan_type         NVARCHAR(MAX)
	,@p_seq		          NVARCHAR(MAX)
	,@p_item_id           NVARCHAR(MAX)
	,@p_line_id           NVARCHAR(MAX)
	,@p_operation_group   NVARCHAR(MAX)=''
	,@p_scm_site_id       NVARCHAR(MAX)=''
	,@p_user_id           NVARCHAR(MAX)
	,@p_origin_division_id NVARCHAR(MAX)
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0013_SAVE_PRODUCTION_PLAN_LINE_POPUP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;
	DECLARE @v_data_dup_priority_cnt  INT=0;
	
	-- validation 변수 설정
	DECLARE @v_val_code  INT=0;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	-- plan 일짜 까지 만듬
	DECLARE @v_pet_date	NVARCHAR(8) = '';

	SELECT @v_pet_date = p.horizon_end_date
	  FROM dbo.scm_mst_plan p WITH(NOLOCK)
	 WHERE p.division_id = @p_division_id
	   AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
			;
	
	-- 트렌젝션 시작
	--BEGIN TRAN;

	BEGIN TRY

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
		BEGIN
			
			INSERT INTO scp_anl_production_plan			
					( division_id			
					 ,plan_start_yyyymmdd			
					 ,plan_type			
					 ,seq			
					 ,operation_group			
					 ,scm_site_id			
					 ,item_id			
					 ,line_id			
					 ,operation_id			
					 ,measure			
					 ,yyyymmdd			
					 ,qty			
					 ,origin_division_id			
					 ,electrode_type			
					 ,created_by			
					 ,creation_date			
					 ,last_updated_by			
					 ,last_update_date			
					 )			
			  SELECT  sub.division_id			
					 ,sub.plan_start_yyyymmdd			
					 ,sub.plan_type			
					 ,sub.seq			
					 ,sub.operation_group			
					 ,sub.scm_site_id			
					 ,sub.item_id			
					 ,sub.line_id			
					 ,sub.operation_id			
					 ,ms.measure			
					 ,sub.yyyymmdd			
					 ,0 AS qty			
					 , sub.origin_division_id			
					 , sub.electrode_type			
					 ,@p_user_id   as created_by			
					 ,GETDATE() as creation_date			
					 ,@p_user_id  as last_updated_by			
					 ,GETDATE() as last_update_date			
				FROM 			
					(			
						 SELECT 			
								division_id			
							   ,origin_division_id			
							   ,plan_start_yyyymmdd			
							   ,plan_type			
							   ,seq			
							   ,operation_group			
							   ,scm_site_id			
							   ,item_id			
							   ,line_id			
							   ,operation_id			
							   ,basis_yyyymmdd AS yyyymmdd			
							   ,electrode_type			
						 FROM			
							   (			
								SELECT basis_yyyymmdd			
								  FROM scm_sys_calendar_m WITH(NOLOCK)			
								 WHERE basis_yyyymmdd  >= @p_plan_date			
								   --AND basis_yyyymmdd  <  DATEADD( YEAR, 1, CONVERT(DATETIME, @p_plan_date,112))			
								   AND basis_yyyymmdd  <=  @v_pet_date	
								) A,			
							   (			
								SELECT top 1			
									   @p_division_id         AS DIVISION_ID,	
									   @p_origin_division_id AS origin_division_id,			
									   --division_id            AS origin_division_id,			
									   @p_plan_date AS PLAN_START_YYYYMMDD,			
									   @p_plan_type           AS PLAN_TYPE,			
									   @p_seq                 AS SEQ,			
									   F.OPERATION_GROUP,			
									   /*
									   ( SELECT TOP 1 SCM_SITE_ID			
										 FROM SCM_MST_SITE S WITH(NOLOCK)			
										WHERE 1=1			
										  AND S.SCM_SITE_ID LIKE 			
															 ( SELECT TOP 1 PLANT_ID+'%-'+F.OPERATION_GROUP			
																 FROM SCM_MST_LINE_SN L WITH(NOLOCK)			
																WHERE LINE_ID = @p_line_id			
																  AND OPERATION_ID = SUBSTRING(F.FLOW_ID,1,5)			
															  ) 			
										) AS SCM_SITE_ID,			
									   */
									   @p_scm_site_id	AS SCM_SITE_ID,
									   F.ITEM_ID,			
									  @p_line_id AS LINE_ID,			
									  --SUBSTRING(F.FLOW_ID,1,5) AS OPERATION_ID,	
									  --ESS 외주 Pakcer Line 생산 Target 적용. '-' 또는 외주패커라인 생산 시 Operation 분기
									  --PJ20202001 :  Rack item '_R1' 추가
									  (CASE WHEN ISNULL(F.ATTRIBUTE3,'N') = 'Y' THEN (SELECT TOP 1 X.PLANT_ID + '_R1'
									                                                    FROM SCM_MST_SITE X WITH(NOLOCK) 
																					   WHERE X.SCM_SITE_ID = @p_scm_site_id 
																					     AND X.OSP_YN='Y'
																					  )
											WHEN (@p_line_id='-' OR ISNULL(S.ATTRIBUTE1,'N')='Y') THEN (SELECT TOP 1 X.PLANT_ID FROM SCM_MST_SITE X WITH(NOLOCK) WHERE X.SCM_SITE_ID=@p_scm_site_id AND X.OSP_YN='Y')
										   ELSE SUBSTRING(F.FLOW_ID,1,5)
									   END) AS OPERATION_ID,			
									  F.ELECTRODE_TYPE			
								  FROM SCP_MST_FINAL_ITEM F WITH(NOLOCK)		
								  JOIN SCM_MST_SITE S WITH(NOLOCK) ON S.SCM_SITE_ID=@p_scm_site_id
								 WHERE 1= 1 --F.DIVISION_ID = @P_ORIGIN_DIVISION_ID			
								   AND F.ITEM_ID     = @p_item_id			
								) B			
					) SUB,			
					( SELECT 'PROD_PLAN_ENGINE' AS measure			
					  UNION ALL			
					  SELECT 'PROD_PLAN_AMEND'  AS measure			
					 ) AS MS			
					WHERE 1=1			
					  AND NOT EXISTS (			
									   SELECT 'X'			
										 FROM scp_anl_production_plan Z WITH(NOLOCK)			
										WHERE 1=1			
										  AND z.division_id           = sub.division_id         			
										  AND z.plan_start_yyyymmdd   = sub.plan_start_yyyymmdd 			
										  AND z.plan_type             = sub.plan_type           			
										  AND z.seq                   = sub.seq                 			
										  AND z.operation_group       = sub.operation_group     			
										  AND z.scm_site_id           = sub.scm_site_id         			
										  AND z.item_id               = sub.item_id             			
										  AND z.line_id               = sub.line_id             			
										  AND z.operation_id          = sub.operation_id        			
										  AND z.measure               = ms.measure             			
										  AND z.yyyymmdd              = sub.yyyymmdd            			
									 );     
		
			INSERT INTO SCP_ANL_PRODUCTION_PLAN_H			
					( history_seq
					 ,division_id			
					 ,plan_start_yyyymmdd			
					 ,plan_type			
					 ,seq			
					 ,operation_group			
					 ,scm_site_id			
					 ,item_id			
					 ,line_id			
					 ,operation_id			
					 ,measure			
					 ,yyyymmdd			
					 ,qty			
					 ,origin_division_id			
					 ,electrode_type			
					 ,created_by			
					 ,creation_date			
					 ,last_updated_by			
					 ,last_update_date	
					 ,history_creation_date		
					 )			
			  SELECT  NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H history_seq
					 ,sub.division_id			
					 ,sub.plan_start_yyyymmdd			
					 ,sub.plan_type			
					 ,sub.seq			
					 ,sub.operation_group			
					 ,sub.scm_site_id			
					 ,sub.item_id			
					 ,sub.line_id			
					 ,sub.operation_id			
					 ,ms.measure			
					 ,sub.yyyymmdd			
					 ,0 AS qty			
					 , sub.origin_division_id			
					 , sub.electrode_type			
					 ,@p_user_id   as created_by			
					 ,GETDATE() as creation_date			
					 ,@p_user_id  as last_updated_by			
					 ,GETDATE() as last_update_date			
					 ,GETDATE() as history_creation_date			
				FROM 			
					(			
						 SELECT 			
								division_id			
							   ,origin_division_id			
							   ,plan_start_yyyymmdd			
							   ,plan_type			
							   ,seq			
							   ,operation_group			
							   ,scm_site_id			
							   ,item_id			
							   ,line_id			
							   ,operation_id			
							   ,basis_yyyymmdd AS yyyymmdd			
							   ,electrode_type			
						 FROM			
							   (			
								SELECT basis_yyyymmdd			
								  FROM scm_sys_calendar_m WITH(NOLOCK)			
								 WHERE basis_yyyymmdd  >= @p_plan_date			
								   --AND basis_yyyymmdd  <  DATEADD( YEAR, 1, CONVERT(DATETIME, @p_plan_date,112))			
								   AND basis_yyyymmdd  <=  @v_pet_date	
								) A,			
							   (			
								SELECT top 1			
									   @p_division_id         AS DIVISION_ID,			
									   @p_origin_division_id AS origin_division_id,
									   --division_id            AS origin_division_id,			
									   @p_plan_date AS PLAN_START_YYYYMMDD,			
									   @p_plan_type           AS PLAN_TYPE,			
									   @p_seq                 AS SEQ,			
									   F.OPERATION_GROUP,		
									   /*
									   ( SELECT TOP 1 SCM_SITE_ID			
										 FROM SCM_MST_SITE S WITH(NOLOCK)			
										WHERE 1=1			
										  AND S.SCM_SITE_ID LIKE 			
															 ( SELECT TOP 1 PLANT_ID+'%-'+F.OPERATION_GROUP			
																 FROM SCM_MST_LINE_SN L WITH(NOLOCK)			
																WHERE LINE_ID = @p_line_id			
																  AND OPERATION_ID = SUBSTRING(F.FLOW_ID,1,5)			
															  ) 			
										) AS SCM_SITE_ID,			
									   */
									   @p_scm_site_id	AS SCM_SITE_ID,
									   F.ITEM_ID,			
									  @p_line_id AS LINE_ID,
									  --SUBSTRING(F.FLOW_ID,1,5) AS OPERATION_ID,			
									  (CASE WHEN @p_line_id='-' THEN (SELECT TOP 1 X.PLANT_ID FROM SCM_MST_SITE X WITH(NOLOCK) WHERE X.SCM_SITE_ID=@p_scm_site_id AND X.OSP_YN='Y')
										   ELSE SUBSTRING(F.FLOW_ID,1,5)
									   END) AS OPERATION_ID,			
									  F.ELECTRODE_TYPE			
								  FROM SCP_MST_FINAL_ITEM F WITH(NOLOCK)			
								 WHERE 1= 1 --F.DIVISION_ID = @P_ORIGIN_DIVISION_ID			
								   AND F.ITEM_ID     = @p_item_id			
								) B			
					) SUB,			
					( SELECT 'PROD_PLAN_ENGINE' AS measure			
					  UNION ALL			
					  SELECT 'PROD_PLAN_AMEND'  AS measure			
					 ) AS MS			
					WHERE 1=1			
					  --AND NOT EXISTS (			
							--		   SELECT 'X'			
							--			 FROM scp_anl_production_plan Z WITH(NOLOCK)			
							--			WHERE 1=1			
							--			  AND z.division_id           = sub.division_id         			
							--			  AND z.plan_start_yyyymmdd   = sub.plan_start_yyyymmdd 			
							--			  AND z.plan_type             = sub.plan_type           			
							--			  AND z.seq                   = sub.seq                 			
							--			  AND z.operation_group       = sub.operation_group     			
							--			  AND z.scm_site_id           = sub.scm_site_id         			
							--			  AND z.item_id               = sub.item_id             			
							--			  AND z.line_id               = sub.line_id             			
							--			  AND z.operation_id          = sub.operation_id        			
							--			  AND z.measure               = ms.measure             			
							--			  AND z.yyyymmdd              = sub.yyyymmdd            			
							--		 );     
	
		END;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환


		BEGIN
			--EE일 경우 Lookup 테이블에 Plant Site, Line 조회조건 정보 추가해준다.
			--IF @p_division_id IN ('EE','EE_UC')
			IF @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				BEGIN
					IF OBJECT_ID('tempdb..#Tbl_ADM_LOOKUP_MASTER_DETAIL') IS NOT NULL
					  DROP TABLE #Tbl_ADM_LOOKUP_MASTER_DETAIL

					CREATE TABLE #Tbl_ADM_LOOKUP_MASTER_DETAIL (
					   LOOKUP_TYPE    nvarchar(100)
					  ,SEGMENT1			  nvarchar(100) 
					  ,SEGMENT2       nvarchar(100) --OPERATION_GROUP or BIZ_TYPE
					  ,SEGMENT3       nvarchar(100) --FROM_SITE or TO_SITE
					  ,SEGMENT4       nvarchar(100) 
					  ,SEGMENT5			  nvarchar(100)
					  ,DISPLAY_SEQ		INT
					  ,ATTRIBUTE1		  nvarchar(150)
					  ,ATTRIBUTE2		  nvarchar(150)
					);

					INSERT INTO #Tbl_ADM_LOOKUP_MASTER_DETAIL
							(LOOKUP_TYPE
							,SEGMENT1
							,SEGMENT2
							,SEGMENT3
							,SEGMENT4
							,SEGMENT5
							,DISPLAY_SEQ
							,ATTRIBUTE1
							)
					SELECT 'EE_PRODUCTION_PLAN' LOOKUP_TYPE
							,'SCP' SEGMENT1
							,OPERATION_GROUP SEGMENT2
							,SCM_SITE_ID SEGMENT3
							,LINE_ID SEGMENT4
							,OPERATION_ID SEGMENT5
							,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ		
							,ORIGIN_DIVISION_ID	ATTRIBUTE1 
					FROM(
							SELECT DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID, OPERATION_ID
							FROM(
									SELECT DISTINCT DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID, OPERATION_ID
									FROM scp_anl_production_plan with(nolock)
									WHERE division_id		= @p_division_id
										AND plan_start_yyyymmdd	= @p_plan_date
										AND plan_type			= @p_plan_type
										AND seq					= @p_seq
										AND operation_group		= @p_operation_group
										AND scm_site_id			= @p_scm_site_id
										AND item_id				= @p_item_id
										AND line_id				= @p_line_id 
								) A WHERE NOT EXISTS(SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
													WHERE LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
													AND SEGMENT1 = 'SCP'
													AND SEGMENT2 = A.OPERATION_GROUP
													AND SEGMENT3 = A.SCM_SITE_ID
													AND SEGMENT4 = A.LINE_ID
													AND SEGMENT5 = A.OPERATION_ID
													AND ATTRIBUTE2 = A.DIVISION_ID--chaan
													)
					) A 
					ORDER BY DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID,OPERATION_ID	  
						;

					INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
							(LOOKUP_TYPE
							,SEGMENT1
							,SEGMENT2
							,SEGMENT3
							,SEGMENT4
							,SEGMENT5
							,DISPLAY_SEQ
							,ATTRIBUTE1
							,VALID_YN
							,DESCRIPTION
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							)
					SELECT LOOKUP_TYPE
						  ,SEGMENT1
						  ,SEGMENT2
						  ,SEGMENT3
						  ,SEGMENT4
						  ,SEGMENT5
						  ,DISPLAY_SEQ
						  ,ATTRIBUTE1
						  ,'Y' VALID_YN
						  ,LOOKUP_TYPE DESCRIPTION
						  ,@p_user_id CREATED_BY
						  ,SYSDATETIME() CREATION_DATE
						  ,@p_user_id LAST_UPDATED_BY
						  ,SYSDATETIME() LAST_UPDATE_DATE
					FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK) 	  
					  ;

					INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
							(HISTORY_SEQ
							,LOOKUP_TYPE
							,SEGMENT1
							,SEGMENT2
							,SEGMENT3
							,SEGMENT4
							,SEGMENT5
							,DISPLAY_SEQ
							,ATTRIBUTE1
							,VALID_YN
							,DESCRIPTION
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,HISTORY_CREATION_DATE
							)
					SELECT NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
							,LOOKUP_TYPE
							,SEGMENT1
							,SEGMENT2
							,SEGMENT3
							,SEGMENT4
							,SEGMENT5
							,DISPLAY_SEQ
							,ATTRIBUTE1
							,'Y' VALID_YN
							,LOOKUP_TYPE DESCRIPTION
							,@p_user_id CREATED_BY
							,SYSDATETIME() CREATION_DATE
							,@p_user_id LAST_UPDATED_BY
							,SYSDATETIME() LAST_UPDATE_DATE
							,SYSDATETIME() HISTORY_CREATION_DATE
					FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK);

				END
			SELECT  'S' AS result_code,  1 AS result_cnt ;
		END


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
		
		END;
	END CATCH;
END

  
