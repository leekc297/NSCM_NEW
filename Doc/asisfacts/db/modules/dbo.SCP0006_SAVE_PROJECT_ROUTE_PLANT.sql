/*
 * Program ID   : SCP0006_SAVE_PROJECT_ROUTE_PLANT
 * Description  : Project Route Plant Site 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge       Description
 *===================================================================================================
 * 2018/01/10   byunghunjung	        Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/09   PJS				        프로지져 주석 현행화
 * 2018/08/23	YHW				        이력 저장 호출 변경(PARAM : PLANT_SITE)
 * 2023/06/07   chaan			V1.1.1  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화 코드 분리
 * 2023/10/13   chaan			V1.1.2  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Plant 수정시 하위 CP1 수정 오류 수정
 * 2023/11/02   chaan			V1.1.3  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Plant 수정시 하위 CA1 수정 오류 수정
 * 2023/11/06   chaan			V1.1.4  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Plant 수정시 하위 CA1 수정 오류 수정
 * 2023/11/14   chaan			V1.1.5  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Plant 수정시 하위 CA 수정 로직 변경(사업부81,82/40 에 따라 키값 상이)
 * 2023/11/21   chaan			V1.1.6  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Pack 변경시 ca 변경되는 오류 수정 (cp 수정시만 수정되도록)
 * 2023/11/28   chaan			V1.1.7  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - ca 변경 오류 수정 (ca값이 CP 가 아닌 Pack을 따라감)
 * 2024/01/03   chaan			V1.1.8  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - ca 변경 오류 수정 (ca 수정시 검색조건의 division_id 오류 수정, @p_division_id -> @v_division_id 으로 변경)
 * 2024/01/04   chaan			V1.1.9  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - ca 변경 오류 수정 (SCM_MST_SITE_ITEM 저장 오류 패치)
 * 2025/08/26   YMH				V1.1.10 CSR : E20250820-000940 CP 수정에 따른 CA변경 오류 수정
 * 2025/10/24   kimcd           V1.1.11 [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                                      JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9에 할당 관리
 *
*/
CREATE PROCEDURE [dbo].[SCP0006_SAVE_PROJECT_ROUTE_PLANT]
	  @p_active_flag        NVARCHAR(MAX)
	, @p_priority_seq       NVARCHAR(MAX)
	, @p_division_id        NVARCHAR(MAX)
	, @p_project_code       NVARCHAR(MAX)
	, @p_scm_site_id        NVARCHAR(MAX)
	, @p_plant_site_id      NVARCHAR(MAX)
	, @p_item_id            NVARCHAR(MAX)
	, @p_priority           NVARCHAR(MAX)
	, @p_from_yyyymmdd      NVARCHAR(MAX)
	, @p_to_yyyymmdd        NVARCHAR(MAX)
	, @p_valid_yn           NVARCHAR(MAX)
	, @p_created_by         NVARCHAR(MAX)
	, @p_creation_date      NVARCHAR(MAX)
	, @p_last_updated_by    NVARCHAR(MAX)
	, @debug_mode           NVARCHAR(20)		= 'F'
AS
BEGIN
    SET NOCOUNT ON;
    SET ANSI_NULLS ON;
    SET ANSI_WARNINGS ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	--DECLARE @p_active_flag        NVARCHAR(MAX)		= N'M';
	--DECLARE @p_priority_seq       NVARCHAR(MAX)		= N'15506';
	--DECLARE @p_division_id        NVARCHAR(MAX)		= N'40';
	--DECLARE @p_project_code       NVARCHAR(MAX)		= N'-';
	--DECLARE @p_scm_site_id        NVARCHAR(MAX)		= N'-';
	--DECLARE @p_plant_site_id      NVARCHAR(MAX)		= N'A010-A';
	--DECLARE @p_item_id            NVARCHAR(MAX)		= N'MCCM350415B1';
	--DECLARE @p_priority           NVARCHAR(MAX)		= N'1';
	--DECLARE @p_from_yyyymmdd      NVARCHAR(MAX)		= N'20240101';
	--DECLARE @p_to_yyyymmdd        NVARCHAR(MAX)		= N'21990131';
	--DECLARE @p_valid_yn           NVARCHAR(MAX)		= N'Y';
	--DECLARE @p_created_by         NVARCHAR(MAX)		= N'beomcheol';
	--DECLARE @p_creation_date      NVARCHAR(MAX)		= N'2024-01-02 ';
	--DECLARE @p_last_updated_by    NVARCHAR(MAX)		= N'iamarock';
	--DECLARE @debug_mode           NVARCHAR(20)		= N'F';


	DECLARE @test_mode                          NVARCHAR(20)		= N'F';
	--DECLARE @test_mode                          NVARCHAR(20)	= N'T';


	DECLARE @recv_active_flag		            NVARCHAR(MAX)   = @p_active_flag;


	DECLARE @v_active_flag			            NVARCHAR(MAX);
	DECLARE @v_cp_priority_seq	                NVARCHAR(MAX);
	DECLARE @v_division_id			            NVARCHAR(MAX);
	DECLARE @v_project_code 		            NVARCHAR(MAX);
	DECLARE @v_scm_site_id 			            NVARCHAR(MAX);
	DECLARE @v_plant_site_id		            NVARCHAR(MAX);

	DECLARE @v_item_id				            NVARCHAR(MAX);
	DECLARE @v_s_valid_yn			            NVARCHAR(MAX);
	DECLARE @v_created_by			            NVARCHAR(MAX);
	DECLARE @v_creation_date		            DATETIME;
	DECLARE @v_last_updated_by		            NVARCHAR(MAX);

	DECLARE @v_priority				            NVARCHAR(MAX);
	DECLARE @v_from_yyyymmdd		            NVARCHAR(MAX);
	DECLARE @v_to_yyyymmdd			            NVARCHAR(MAX);
	DECLARE @v_valid_yn				            NVARCHAR(MAX);

	DECLARE @p_currency				            NVARCHAR(MAX);
	DECLARE @p_liability_period		            NVARCHAR(MAX);
	DECLARE @p_sales_plan_adjust_yn	            NVARCHAR(MAX);
	DECLARE @p_item_hrcy_id			            NVARCHAR(MAX);
	DECLARE @p_bpms_exist			            NVARCHAR(MAX);
	DECLARE @v_link_plant_site_id               NVARCHAR(MAX); -- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9 값 설정
	DECLARE @v_link_division_id                 NVARCHAR(MAX); -- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9 값 설정
	DECLARE @v_link_cp_priority_seq             [bigint];      -- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9 값 설정



	SET @v_active_flag						= NULL;
	SET @v_cp_priority_seq					= NULL;
	SET @v_division_id						= NULL;
	SET @v_project_code						= NULL;
	SET @v_scm_site_id						= NULL;
	SET @v_item_id							= NULL;
	SET @v_priority							= NULL;
	SET @v_s_valid_yn						= NULL;
	SET @v_created_by						= NULL;
	SET @v_creation_date					= NULL;
	SET @v_last_updated_by					= NULL;

	SET @p_currency							= NULL;
	SET @p_liability_period					= NULL;
	SET @p_sales_plan_adjust_yn				= NULL;
	SET @p_item_hrcy_id						= NULL;
	SET @p_bpms_exist						= 'Y';

	SET @v_priority							= NULL;
	SET @v_from_yyyymmdd					= NULL;
	SET @v_to_yyyymmdd						= NULL;
	SET @v_valid_yn							= NULL;
	SET @v_link_plant_site_id               = NULL; -- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9 값 설정
	SET @v_link_division_id                 = NULL; -- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9 값 설정
	SET @v_link_cp_priority_seq             = NULL; -- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9 값 설정

	DECLARE @v_delimiter            NVARCHAR(1) = '^'
	DECLARE @v_loop_cnt		        INTEGER		= 0;
	DECLARE @v_curr_loop_cnt		INTEGER		= 0;

	-- E20250820-000940 CA 업데이트 대상 존재유무 체크
	DECLARE @V_CA_UPDATE_EXISTS	INTEGER = 0
	DECLARE @V_CA_ITEM_CD_LIST		NVARCHAR(500) = ''

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0006_SAVE_PROJECT_ROUTE_PLANT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER			= 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		PRINT '1';

		-- 시작 LOG
		SET @v_log_type						= 'START';
		SET @v_log_message					= '########## Start of procedure ##########';
		SET @v_description					= '';
		SET @d_event_date					= SYSDATETIME();
        
        IF @test_mode <> 'T'
        BEGIN
		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END


        --커서는 루프 전에 한번만 생성하도록 한다(CP는 DIVISION_ID, PLANT_ID, ITEM_ID_PROD 동일하므로)
	    DECLARE @v_cp_division_id			NVARCHAR(MAX);
	    DECLARE @v_ca_plant_site_id		    NVARCHAR(MAX);
	    DECLARE @v_cp_item_id				NVARCHAR(MAX);
	    DECLARE @v_ca_item_id				NVARCHAR(MAX);
	    
        --파싱한 리스트가 모두 동일하므로 첫행 값만 가져온다 begin
        SELECT  TOP 1
                @v_cp_division_id = TOKEN
        FROM    dbo.String_Split(@p_division_id, '^')

        SELECT  TOP 1
                @v_cp_item_id = TOKEN
        FROM    dbo.String_Split(@p_item_id, '^')
        --파싱한 리스트가 모두 동일하므로 첫행 값만 가져온다 end

    PRINT CONCAT('@v_cp_division_id : ', @v_cp_division_id);
    PRINT CONCAT('@v_cp_item_id : ', @v_cp_item_id);

		-- 프로시저 LOOP 길이를 판단
		SET @v_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);

        PRINT CONCAT('@v_loop_cnt : ', @v_loop_cnt);


        IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_ALL') IS NOT NULL
            DROP TABLE #TblSCP0006_SAVE_CA_ALL;


		WHILE LEN(@recv_active_flag) > 0 AND @v_curr_loop_cnt < @v_loop_cnt
		BEGIN
			-- @v_curr_loop_cnt 1증가
			SET @v_curr_loop_cnt = @v_curr_loop_cnt + 1;

            PRINT CONCAT('@v_curr_loop_cnt : ', @v_curr_loop_cnt);

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_cp_priority_seq		= [dbo].[SCM_ARR_SPL_VAL](@p_priority_seq, @v_delimiter, @v_curr_loop_cnt);

                --PRINT CONCAT('@v_cp_priority_seq(1) : ', @v_cp_priority_seq);

				IF(ISNULL(@v_cp_priority_seq,'') ='')
					SET @v_cp_priority_seq = (NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_PRIORITY);

                --PRINT CONCAT('@v_cp_priority_seq(2) : ', @v_cp_priority_seq);

--TESTING : NOK
--SELECT MAX(PRIORITY_SEQ)
--FROM    [dbo].[SCM_MST_SITE_ITEM_PRIORITY] WITH(NOLOCK);rollback tran; return;

				SET @v_active_flag		= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag	, @v_delimiter , @v_curr_loop_cnt);
				SET @v_division_id		= [dbo].[SCM_ARR_SPL_VAL](@p_division_id	, @v_delimiter , @v_curr_loop_cnt);
				SET @v_project_code		= [dbo].[SCM_ARR_SPL_VAL](@p_project_code	, @v_delimiter , @v_curr_loop_cnt);
				SET @v_scm_site_id		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id	, @v_delimiter , @v_curr_loop_cnt);
				SET @v_plant_site_id	= [dbo].[SCM_ARR_SPL_VAL](@p_plant_site_id	, @v_delimiter , @v_curr_loop_cnt);
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id		, @v_delimiter , @v_curr_loop_cnt);
				SET @v_s_valid_yn		= (select t.VALID_YN from scm_mst_site_item t where t.division_id = @v_division_id AND t.SCM_SITE_ID =@v_scm_site_id AND t.ITEM_ID = @v_item_id AND t.project_code =@v_project_code)
				SET @v_created_by		= [dbo].[SCM_ARR_SPL_VAL](@p_created_by		, @v_delimiter, @v_curr_loop_cnt);
				--SET @v_creation_date	= CONVERT(DATETIME, [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter, @v_curr_loop_cnt) , 112);
				SET @v_creation_date	=  [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter, @v_curr_loop_cnt);
				SET @v_last_updated_by	= [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter, @v_curr_loop_cnt);

				SET @v_priority			= [dbo].[SCM_ARR_SPL_VAL](@p_priority		, @v_delimiter, @v_curr_loop_cnt);
				SET @v_from_yyyymmdd	= [dbo].[SCM_ARR_SPL_VAL](@p_from_yyyymmdd	, @v_delimiter, @v_curr_loop_cnt);
				SET @v_to_yyyymmdd		= [dbo].[SCM_ARR_SPL_VAL](@p_to_yyyymmdd	, @v_delimiter, @v_curr_loop_cnt);
				SET @v_valid_yn			= [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn		, @v_delimiter, @v_curr_loop_cnt);
				-- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값 설정 시작
            	SET @v_link_plant_site_id   = NULL;
	            SET @v_link_division_id     = NULL;
				SET @v_link_cp_priority_seq = NULL;

				SELECT TOP 1 @v_link_division_id   = L.DIVISION_ID,
				             @v_link_plant_site_id = L.SCM_SITE_ID
				FROM   SCM_MST_SITE  P WITH(NOLOCK)
				       INNER JOIN SCM_MST_SITE L WITH(NOLOCK)
					       ON L.SCM_SITE_ID = P.ATTRIBUTE9
			    WHERE P.SCM_SITE_ID = @v_plant_site_id
				AND   P.DIVISION_ID = @v_division_id  
				-- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값 설정 끝
	            

			END

			PRINT CONCAT('@v_active_flag     : ', @v_active_flag);
			PRINT CONCAT('@v_cp_priority_seq : ', @v_cp_priority_seq);
			PRINT CONCAT('@v_division_id     : ', @v_division_id);
			PRINT CONCAT('@v_project_code    : ', @v_project_code);
			PRINT CONCAT('@v_scm_site_id     : ', @v_scm_site_id);
			PRINT CONCAT('@v_plant_site_id   : ', @v_plant_site_id);
			PRINT CONCAT('@v_item_id         : ', @v_item_id);
			PRINT CONCAT('@v_s_valid_yn      : ', @v_s_valid_yn);
			PRINT CONCAT('@v_priority        : ', @v_priority);
			PRINT CONCAT('@v_from_yyyymmdd   : ', @v_from_yyyymmdd);
			PRINT CONCAT('@v_to_yyyymmdd     : ', @v_to_yyyymmdd);
			PRINT CONCAT('@v_valid_yn        : ', @v_valid_yn);
			PRINT CONCAT('@v_last_updated_by : ', @v_last_updated_by);
			PRINT CONCAT('@v_curr_loop_cnt      : ', @v_curr_loop_cnt);

--select * from SCM_MST_SITE_ITEM_PRIORITY where PRIORITY_SEQ = @v_cp_priority_seq;rollback tran; return;

			--데이터 저장
			IF @v_curr_loop_cnt > 0
			BEGIN
                --CP 수정 begin ------------------------------------------------------------------------------------------------------------------
                PRINT 'SCM_MST_SITE_ITEM - CP - BEGIN';
  				MERGE INTO SCM_MST_SITE_ITEM A
				USING
				(
					SELECT	  @v_division_id	AS DIVISION_ID
							, @v_project_code	AS PROJECT_CODE
							, @v_plant_site_id	AS SCM_SITE_ID
							, @v_item_id		AS ITEM_ID
				) B ON
				(
						A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND	A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND	A.ITEM_ID		= B.ITEM_ID
				)
				WHEN MATCHED THEN
				UPDATE
				SET
					-- VALID_YN			  = @v_valid_yn
					    LAST_UPDATED_BY	  = @v_last_updated_by
					, LAST_UPDATE_DATE	  = SYSDATETIME()
				WHEN NOT MATCHED THEN
				INSERT
				(
					  DIVISION_ID
					, PROJECT_CODE
					, SCM_SITE_ID
					, ITEM_ID
					, CURRENCY
					, LIABILITY_PERIOD
					, SALES_PLAN_ADJUST_YN
					, ITEM_HRCY_ID
					, VALID_YN
					, BPMS_EXIST
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
				)
				VALUES
				(
					  @v_division_id
					, @v_project_code
					, @v_plant_site_id
					, @v_item_id
					, NULL
					, NULL
					, NULL
					, NULL
					, 'Y'
					, 'Y'
					, @v_created_by
					, SYSDATETIME()
					, @v_created_by
					, SYSDATETIME()
				);
                PRINT 'SCM_MST_SITE_ITEM - CP - END';

				-- SCM_MST_SITE_ITEM_PRIORITY입력/수정
				IF( @v_active_flag ='M')
				BEGIN
                    PRINT 'SCM_MST_SITE_ITEM_PRIORITY - CP - UPDATE - BEGIN';

					UPDATE SCM_MST_SITE_ITEM_PRIORITY
					SET
						  SALES_SITE_ID	    = @v_scm_site_id
						, PLANT_SITE_ID		= @v_plant_site_id
						, PRIORITY			= @v_priority
						, FROM_YYYYMMDD		= @v_from_yyyymmdd
						, TO_YYYYMMDD		= @v_to_yyyymmdd
						, VALID_YN			= @v_valid_yn
						, LAST_UPDATED_BY	= @v_last_updated_by
						, LAST_UPDATE_DATE	= sysdatetime()
					WHERE PRIORITY_SEQ = @v_cp_priority_seq

                    PRINT 'SCM_MST_SITE_ITEM_PRIORITY - CP - UPDATE - DONE';
				END
				ELSE IF(@v_active_flag ='I')
				BEGIN
                    PRINT 'SCM_MST_SITE_ITEM_PRIORITY - CP - INSERT - BEGIN';

					INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
					(
						  PRIORITY_SEQ
						, DIVISION_ID
						, PROJECT_CODE
						, SALES_SITE_ID
						, PLANT_SITE_ID
						, ITEM_ID
						, PRIORITY
						, FROM_YYYYMMDD
						, TO_YYYYMMDD
						, VALID_YN
						, CREATED_BY
						, CREATION_DATE
						, LAST_UPDATED_BY
						, LAST_UPDATE_DATE
					)
					VALUES
					(
				          @v_cp_priority_seq
						, @v_division_id
						, @v_project_code
						, @v_scm_site_id
						, @v_plant_site_id
						, @v_item_id
						, @v_priority
						, @v_from_yyyymmdd
						, @v_to_yyyymmdd
						, @v_valid_yn
						, @v_created_by
						, SYSDATETIME()
						, @v_created_by
						, SYSDATETIME()
					);

                    PRINT 'SCM_MST_SITE_ITEM_PRIORITY - CP - INSERT - DONE';
				END
                --CP 수정 end ------------------------------------------------------------------------------------------------------------------


                    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CP') IS NOT NULL
                        DROP TABLE #TblSCP0006_SAVE_CP;

					SELECT  *
                    INTO    #TblSCP0006_SAVE_CP
                    FROM    SCM_MST_SITE_ITEM_PRIORITY
                    WHERE   1=1
                        AND PRIORITY_SEQ = @v_cp_priority_seq;


--TESTING : OK
--select * from SCM_MST_SITE_ITEM_PRIORITY where PRIORITY_SEQ = @v_cp_priority_seq;--rollback tran; return;
--select * from #TblSCP0006_SAVE_CP where PRIORITY_SEQ = @v_cp_priority_seq;rollback tran; return;


                PRINT N'CP에 해당하는 HISTORY UPDATE BEGIN';

			    EXEC [PR_SCM_MST_SITE_ITEM_HIST]
					@v_division_id,
					@v_project_code,
					@v_plant_site_id,
					@v_item_id,
					@p_currency,
					@p_liability_period,
					@p_sales_plan_adjust_yn,
					@p_item_hrcy_id,
					@v_s_valid_yn,
					@p_bpms_exist,
					@v_created_by,
					@v_creation_date,
					@v_last_updated_by;

			    EXEC [PR_SCM_MST_SITE_ITEM_PRIORITY_HIST]
					@v_cp_priority_seq,
					@v_division_id,
					@v_project_code,
					@v_scm_site_id ,
					@v_plant_site_id,
					@v_item_id ,
					@v_priority,
					@v_from_yyyymmdd,
					@v_to_yyyymmdd,
					@v_valid_yn,
					@v_created_by,
					@v_creation_date,
					@v_last_updated_by;

                PRINT N'CP에 해당하는 HISTORY UPDATE END';

                -- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값. JV 동기화 설정 시작
				IF @v_link_division_id IS NOT NULL AND @v_link_plant_site_id IS NOT NULL
				BEGIN
  					MERGE INTO SCM_MST_SITE_ITEM A
					USING
					(
						SELECT	  @v_link_division_id	AS DIVISION_ID
								, @v_project_code	    AS PROJECT_CODE
								, @v_link_plant_site_id	AS SCM_SITE_ID
								, @v_item_id		    AS ITEM_ID
					) B ON
					(
							A.DIVISION_ID	= B.DIVISION_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
						AND	A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND	A.ITEM_ID		= B.ITEM_ID
					)
					WHEN MATCHED THEN
					UPDATE
					SET
						-- VALID_YN			  = @v_valid_yn
						  LAST_UPDATED_BY	  = @v_last_updated_by
						, LAST_UPDATE_DATE	  = SYSDATETIME()
					WHEN NOT MATCHED THEN
					INSERT
					(
						  DIVISION_ID
						, PROJECT_CODE
						, SCM_SITE_ID
						, ITEM_ID
						, CURRENCY
						, LIABILITY_PERIOD
						, SALES_PLAN_ADJUST_YN
						, ITEM_HRCY_ID
						, VALID_YN
						, BPMS_EXIST
						, CREATED_BY
						, CREATION_DATE
						, LAST_UPDATED_BY
						, LAST_UPDATE_DATE
					)
					VALUES
					(
						  @v_link_division_id
						, @v_project_code
						, @v_link_plant_site_id
						, @v_item_id
						, NULL
						, NULL
						, NULL
						, NULL
						, 'Y'
						, 'Y'
						, @v_created_by
						, SYSDATETIME()
						, @v_created_by
						, SYSDATETIME()
					);

					-- SCM_MST_SITE_ITEM_PRIORITY입력/수정
					SELECT TOP 1 @v_link_cp_priority_seq = PRIORITY_SEQ
				    FROM   SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
                    WHERE  DIVISION_ID    = @v_link_division_id
					AND    PROJECT_CODE   = @v_project_code 
					AND    SALES_SITE_ID  = @v_scm_site_id
					AND    PLANT_SITE_ID  = @v_link_plant_site_id
					AND    ITEM_ID        = @v_item_id
					AND    FROM_YYYYMMDD <= @v_to_yyyymmdd
					AND    TO_YYYYMMDD   >= @v_from_yyyymmdd
					
					IF @v_link_cp_priority_seq IS NOT NULL
					    BEGIN
							UPDATE SCM_MST_SITE_ITEM_PRIORITY
							SET
								  SALES_SITE_ID	    = @v_scm_site_id
								, PRIORITY			= @v_priority
								, FROM_YYYYMMDD		= @v_from_yyyymmdd
								, TO_YYYYMMDD		= @v_to_yyyymmdd
								, VALID_YN			= @v_valid_yn
								, LAST_UPDATED_BY	= @v_last_updated_by
								, LAST_UPDATE_DATE	= sysdatetime()
							WHERE PRIORITY_SEQ = @v_link_cp_priority_seq;
						END;
					ELSE
					    BEGIN
							SET @v_link_cp_priority_seq = (NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_PRIORITY);

							INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
							(
								  PRIORITY_SEQ
								, DIVISION_ID
								, PROJECT_CODE
								, SALES_SITE_ID
								, PLANT_SITE_ID
								, ITEM_ID
								, PRIORITY
								, FROM_YYYYMMDD
								, TO_YYYYMMDD
								, VALID_YN
								, CREATED_BY
								, CREATION_DATE
								, LAST_UPDATED_BY
								, LAST_UPDATE_DATE
							)
							VALUES
							(
								  @v_link_cp_priority_seq
								, @v_link_division_id
								, @v_project_code
								, @v_scm_site_id
								, @v_link_plant_site_id
								, @v_item_id
								, @v_priority
								, @v_from_yyyymmdd
								, @v_to_yyyymmdd
								, @v_valid_yn
								, @v_created_by
								, SYSDATETIME()
								, @v_created_by
								, SYSDATETIME()
							);
						END;

					--CP 수정 end ------------------------------------------------------------------------------------------------------------------
					EXEC [PR_SCM_MST_SITE_ITEM_HIST]
						@v_link_division_id,
						@v_project_code,
						@v_link_plant_site_id,
						@v_item_id,
						@p_currency,
						@p_liability_period,
						@p_sales_plan_adjust_yn,
						@p_item_hrcy_id,
						@v_s_valid_yn,
						@p_bpms_exist,
						@v_created_by,
						@v_creation_date,
						@v_last_updated_by;

					EXEC [PR_SCM_MST_SITE_ITEM_PRIORITY_HIST]
						@v_link_cp_priority_seq,
						@v_link_division_id,
						@v_project_code,
						@v_scm_site_id ,
						@v_link_plant_site_id,
						@v_item_id ,
						@v_priority,
						@v_from_yyyymmdd,
						@v_to_yyyymmdd,
						@v_valid_yn,
						@v_created_by,
						@v_creation_date,
						@v_last_updated_by;

				END;
				-- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값. JV 동기화 설정 끝


                --CA 수정 begin ------------------------------------------------------------------------------------------------------------------'
                DECLARE @v_cp_operation_group        NVARCHAR(10)    =	NULL;

                SELECT  @v_cp_operation_group = OPERATION_GROUP
                FROM    SCP_MST_FINAL_ITEM WITH(NOLOCK)
                WHERE   1=1
                    AND ITEM_ID = @v_item_id;

                PRINT   CONCAT('@v_cp_operation_group : ', @v_cp_operation_group);
                --rollback tran; return;

                IF @v_cp_operation_group <> 'P' --현재 수정하는 내용이 Pack 이 아니면(Cell 이면서 CP 입력/수정때만 CA 수정)
                BEGIN
                    PRINT N'BOM에 해당하는 CA ITEMS - BEGIN';

                    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_BOM_ITEMS') IS NOT NULL
                        DROP TABLE #TblSCP0006_SAVE_CA_BOM_ITEMS;

                    SELECT    T.CHILD_ITEM_ID AS ITEM_ID
                            , S.PROJECT_CODE
                            , S.SCM_SITE_ID
                    INTO    #TblSCP0006_SAVE_CA_BOM_ITEMS
                    FROM	SCM_MST_BOM_SN_V T (NOLOCK)
		                    INNER JOIN SCM_MST_SITE_ITEM S ON 
				                    T.DIVISION_ID	= S.DIVISION_ID 
			                    AND T.MODEL_ID		= S.ITEM_ID
		                    INNER MERGE JOIN SCM_MST_FINAL_ITEM_V V ON 
				                    T.DIVISION_ID	= V.DIVISION_ID  
			                    AND T.CHILD_ITEM_ID = V.ITEM_ID
                    WHERE	1=1
	                    AND T.DIVISION_ID	                    = @v_division_id
	                    AND T.MODEL_ID		                    = @v_item_id
						-- CSR : E20250820-000940 주석처리 시작
                        --AND SUBSTRING(T.CHILD_ITEM_ID, 2, 1)    = 'A'
						-- CSR : E20250820-000940 주석처리 끝
						AND V.CELL_TYPE LIKE 'CA%' -- CSR : E20250820-000940  복수개의 CA를 모두 찾기위해 로직 변경.
	                    AND V.OPERATION_GROUP_ID                <> 'E'
	                    AND EXISTS	(
					                    SELECT	*
					                    FROM	[dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
					                    WHERE	DIVISION_ID = @v_division_id
						                    AND PARENT_ITEM_ID= t.child_item_id
						                    AND EFF_END_DATE >= GETDATE()
						                    AND KEY_DATE =  ( 
											                    SELECT	MAX(KEY_DATE)
											                    FROM	[dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)
											                    WHERE	PARENT_ITEM_ID	= T.CHILD_ITEM_ID
												                    AND DIVISION_ID		= @v_division_id 
										                    )
				                    )
                    GROUP BY  T.CHILD_ITEM_ID
                            , S.PROJECT_CODE
                            , S.SCM_SITE_ID;

--TESTING : OK
--select * from #TblSCP0006_SAVE_CA_BOM_ITEMS;rollback tran; return;


                    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL') IS NOT NULL
                        DROP TABLE #TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL;

                    --빈 테이블 만들기
                    SELECT  CONVERT(NVARCHAR(100), NULL)    AS ITEM_ID
                    INTO    #TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL
                    WHERE   1<>1;


                    IF @v_division_id = '40' OR @v_division_id = '82' --40, 82 사업부는 PROJECT_CODE, SCM_SITE_ID 모두 '-'
                    BEGIN
                        INSERT INTO #TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL
                        SELECT  ITEM_ID
                        FROM	#TblSCP0006_SAVE_CA_BOM_ITEMS
                        GROUP BY ITEM_ID;
                    END
                    ELSE --81 사업부는 PROJECT_CODE, SCM_SITE_ID 지정
                    BEGIN
                        INSERT INTO #TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL
                        SELECT  ITEM_ID
                        FROM	#TblSCP0006_SAVE_CA_BOM_ITEMS
                        WHERE   1=1
	                        AND PROJECT_CODE    = @v_project_code
	                        AND SCM_SITE_ID	    = @v_plant_site_id
                        GROUP BY ITEM_ID;
                    END
                    PRINT N'BOM에 해당하는 CA ITEMS - END';
--TESTING : OK
--select * from #TblSCP0006_SAVE_CA_BOM_ITEMS;
--select * from #TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL;rollback tran; return;

                    PRINT N'CP에 해당하는 CA 목록 BEGIN';

                    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_CURR') IS NOT NULL
                        DROP TABLE #TblSCP0006_SAVE_CA_CURR;

                        SELECT    (NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_PRIORITY)   AS PRIORITY_SEQ
                                , P.DIVISION_ID
                                , P.PLANT_SITE_ID
                                , P.SALES_SITE_ID
                                , P.PROJECT_CODE
                                , A.ITEM_ID
                                , P.PRIORITY
                                , P.FROM_YYYYMMDD
                                , P.TO_YYYYMMDD
                                , P.VALID_YN
                                , P.CREATED_BY
                                , P.CREATION_DATE
                                , P.LAST_UPDATED_BY
                                , P.LAST_UPDATE_DATE
                                , P.ATTRIBUTE1
                                , P.ATTRIBUTE2
                                , P.ATTRIBUTE3
                                , P.ATTRIBUTE4
                                , P.ATTRIBUTE5
                                , P.ATTRIBUTE6
                                , P.ATTRIBUTE7
                                , P.ATTRIBUTE8
                                , P.ATTRIBUTE9
                                , P.ATTRIBUTE10
                    INTO    #TblSCP0006_SAVE_CA_CURR
                    FROM      #TblSCP0006_SAVE_CP P
                            , #TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL A

                    IF @v_curr_loop_cnt = 1
                    BEGIN
                        -- 빈테이블
                        SELECT  *
                        INTO    #TblSCP0006_SAVE_CA_ALL
                        FROM    #TblSCP0006_SAVE_CA_CURR
                        WHERE   1<>1

						-- E20250820-000940 CA 업데이트 대상 존재유무 체크
						IF EXISTS (SELECT * FROM #TblSCP0006_SAVE_CA_CURR)
						BEGIN
							SET @V_CA_UPDATE_EXISTS = 1
							SELECT TOP 1 @V_CA_ITEM_CD_LIST =  STRING_AGG(ITEM_ID,@v_delimiter) FROM #TBLSCP0006_SAVE_CA_CURR
						END

                    END

	                -- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값. JV 동기화 설정 시작
					IF @v_link_division_id IS NOT NULL AND @v_link_plant_site_id IS NOT NULL
					BEGIN
						INSERT INTO #TblSCP0006_SAVE_CA_CURR
						SELECT    (NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_PRIORITY)   AS PRIORITY_SEQ
									, @v_link_division_id AS DIVISION_ID
									, @v_link_plant_site_id AS PLANT_SITE_ID
									, P.SALES_SITE_ID
									, P.PROJECT_CODE
									, A.ITEM_ID
									, P.PRIORITY
									, P.FROM_YYYYMMDD
									, P.TO_YYYYMMDD
									, P.VALID_YN
									, P.CREATED_BY
									, P.CREATION_DATE
									, P.LAST_UPDATED_BY
									, P.LAST_UPDATE_DATE
									, P.ATTRIBUTE1
									, P.ATTRIBUTE2
									, P.ATTRIBUTE3
									, P.ATTRIBUTE4
									, P.ATTRIBUTE5
									, P.ATTRIBUTE6
									, P.ATTRIBUTE7
									, P.ATTRIBUTE8
									, P.ATTRIBUTE9
									, P.ATTRIBUTE10
						FROM      #TblSCP0006_SAVE_CP P
								, #TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL A
					END;
					-- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값. JV 동기화 설정 끝

                    INSERT INTO #TblSCP0006_SAVE_CA_ALL
                    SELECT  *
                    FROM    #TblSCP0006_SAVE_CA_CURR;

                    PRINT N'CP에 해당하는 CA 목록 END';
--TESTING : OK
--select * from #TblSCP0006_SAVE_CA_CURR;rollback tran; return;




                    PRINT N'#TblSCP0006_SAVE_CA_OLD_ITEM - BEGIN';
                    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_OLD_ITEM') IS NOT NULL
                        DROP TABLE #TblSCP0006_SAVE_CA_OLD_ITEM;

                    SELECT  A.*
                    INTO    #TblSCP0006_SAVE_CA_OLD_ITEM
                    FROM    SCM_MST_SITE_ITEM A
                            JOIN #TblSCP0006_SAVE_CA_CURR B ON
					                A.DIVISION_ID	= B.DIVISION_ID
				                AND A.PROJECT_CODE	= B.PROJECT_CODE
				                -- SCM_MST_SITE_ITEM 는 PLANT_SITE_ID 와 비교 AND	A.SCM_SITE_ID	= B.SALES_SITE_ID
				                AND	A.SCM_SITE_ID	= B.PLANT_SITE_ID-- SCM_MST_SITE_ITEM 는 PLANT_SITE_ID 와 비교
				                AND	A.ITEM_ID		= B.ITEM_ID
                    PRINT N'#TblSCP0006_SAVE_CA_OLD_ITEM - END';


                    PRINT N'CA OLD FOR HITORY TABLE -SCM_MST_SITE_ITEM_PRIORITY - BEGIN';
                    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_OLD_SCM_MST_SITE_ITEM_PRIORITY') IS NOT NULL
                        DROP TABLE #TblSCP0006_SAVE_CA_OLD_SCM_MST_SITE_ITEM_PRIORITY;

                    SELECT  A.*
                    INTO    #TblSCP0006_SAVE_CA_OLD_SCM_MST_SITE_ITEM_PRIORITY
                    FROM    SCM_MST_SITE_ITEM_PRIORITY A
                            JOIN #TblSCP0006_SAVE_CA_CURR B ON
        					        A.PRIORITY_SEQ  = B.PRIORITY_SEQ
                    PRINT N'CA OLD FOR HITORY TABLE - SCM_MST_SITE_ITEM_PRIORITY - END';
                    PRINT N'CA OLD FOR HITORY TABLE -ITEM - END';


                    PRINT N'CA에 해당하는 ITEM UPATE - BEGIN';
  			        MERGE INTO SCM_MST_SITE_ITEM A
			        USING
			        (
				        SELECT DISTINCT
				                  DIVISION_ID
				                , PROJECT_CODE
				                -- SCM_MST_SITE_ITEM 는 PLANT_SITE_ID 와 비교, SALES_SITE_ID
                                , PLANT_SITE_ID
				                , ITEM_ID
                        FROM    #TblSCP0006_SAVE_CA_CURR
			        ) B ON
			        (
					        A.DIVISION_ID	= B.DIVISION_ID
				        AND A.PROJECT_CODE	= B.PROJECT_CODE
				        -- SCM_MST_SITE_ITEM 는 PLANT_SITE_ID 와 비교 AND	A.SCM_SITE_ID	= B.SALES_SITE_ID
				        AND	A.SCM_SITE_ID	= B.PLANT_SITE_ID-- SCM_MST_SITE_ITEM 는 PLANT_SITE_ID 와 비교
				        AND	A.ITEM_ID		= B.ITEM_ID
			        )
			        WHEN MATCHED THEN
			        UPDATE
			        SET
				        -- VALID_YN			  = @v_valid_yn
					        --LAST_UPDATED_BY	  = B.LAST_UPDATED_BY
				         LAST_UPDATE_DATE	  = SYSDATETIME()
			        WHEN NOT MATCHED THEN
			        INSERT
			        (
				          DIVISION_ID
				        , PROJECT_CODE
				        , SCM_SITE_ID
				        , ITEM_ID
				        , CURRENCY
				        , LIABILITY_PERIOD
				        , SALES_PLAN_ADJUST_YN
				        , ITEM_HRCY_ID
				        , VALID_YN
				        , BPMS_EXIST
				        , CREATED_BY
				        , CREATION_DATE
				        , LAST_UPDATED_BY
				        , LAST_UPDATE_DATE
			        )
			        VALUES
			        (
				          B.DIVISION_ID
				        , B.PROJECT_CODE
				        --SCM_MST_SITE_ITEM 는 PLANT_SITE_ID , B.SALES_SITE_ID
				        , B.PLANT_SITE_ID--SCM_MST_SITE_ITEM 는 PLANT_SITE_ID
				        , B.ITEM_ID
				        , NULL
				        , NULL
				        , NULL
				        , NULL
				        , 'Y'
				        , 'Y'
				        , @v_created_by
				        , SYSDATETIME()
				        , @v_created_by
				        , SYSDATETIME()
			        );
                    PRINT N'CA에 해당하는 ITEM UPATE - END';

--TESTING : OK
--SELECT  A.*
--FROM    SCM_MST_SITE_ITEM_PRIORITY A WITH (NOLOCK)
--        JOIN #TblSCP0006_SAVE_CA_CURR B ON
--				A.DIVISION_ID	= B.DIVISION_ID
--			AND A.PROJECT_CODE	= B.PROJECT_CODE
--			AND	A.PLANT_SITE_ID	= B.PLANT_SITE_ID
--			AND	A.SALES_SITE_ID	= B.SALES_SITE_ID
--			AND	A.ITEM_ID		= B.ITEM_ID;

					-- E20250820-000940 주석처리 시작
					/*
                    PRINT N'CA에 해당하는 SCM_MST_SITE_ITEM_PRIORITY UPATE - BEGIN';
  			        MERGE INTO SCM_MST_SITE_ITEM_PRIORITY A
			        USING
			        (
				        SELECT	*
                        FROM    #TblSCP0006_SAVE_CA_CURR
			        ) B ON
			        (
					        A.DIVISION_ID	= B.DIVISION_ID
				        AND A.PROJECT_CODE	= B.PROJECT_CODE
				        AND	A.PLANT_SITE_ID	= B.PLANT_SITE_ID
				        AND	A.SALES_SITE_ID	= B.SALES_SITE_ID
				        AND	A.ITEM_ID		= B.ITEM_ID
					    --A.PRIORITY_SEQ  = B.PRIORITY_SEQ
			        )
			        WHEN MATCHED THEN
			        UPDATE
			        SET
				          A.PRIORITY			= B.PRIORITY
				        , A.FROM_YYYYMMDD		= B.FROM_YYYYMMDD
				        , A.TO_YYYYMMDD		    = B.TO_YYYYMMDD
				        , A.VALID_YN			= B.VALID_YN
				        , A.LAST_UPDATED_BY	    = B.LAST_UPDATED_BY
				        , A.LAST_UPDATE_DATE	= sysdatetime()
                    WHEN NOT MATCHED THEN                      
                    INSERT
                    (
                          PRIORITY_SEQ
                        , DIVISION_ID
                        , PLANT_SITE_ID
                        , SALES_SITE_ID
                        , PROJECT_CODE
                        , ITEM_ID
                        , PRIORITY
                        , FROM_YYYYMMDD
                        , TO_YYYYMMDD
                        , VALID_YN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE
                        , ATTRIBUTE1
                        , ATTRIBUTE2
                        , ATTRIBUTE3
                        , ATTRIBUTE4
                        , ATTRIBUTE5
                        , ATTRIBUTE6
                        , ATTRIBUTE7
                        , ATTRIBUTE8
                        , ATTRIBUTE9
                        , ATTRIBUTE10
                    )
                    VALUES
                    (
                          B.PRIORITY_SEQ
                        , B.DIVISION_ID
                        , B.PLANT_SITE_ID
                        , B.SALES_SITE_ID
                        , B.PROJECT_CODE
                        , B.ITEM_ID
                        , B.PRIORITY
                        , B.FROM_YYYYMMDD
                        , B.TO_YYYYMMDD
                        , B.VALID_YN
                        , B.CREATED_BY
                        , B.CREATION_DATE
                        , B.LAST_UPDATED_BY
                        , B.LAST_UPDATE_DATE
                        , B.ATTRIBUTE1
                        , B.ATTRIBUTE2
                        , B.ATTRIBUTE3
                        , B.ATTRIBUTE4
                        , B.ATTRIBUTE5
                        , B.ATTRIBUTE6
                        , B.ATTRIBUTE7
                        , B.ATTRIBUTE8
                        , B.ATTRIBUTE9
                        , B.ATTRIBUTE10
                    );
                    PRINT N'CA에 해당하는 SCM_MST_SITE_ITEM_PRIORITY UPATE - END';
					*/
					-- E20250820-000940 주석처리 끝

--TESTING : OK
                    
                    PRINT N'CA에 해당하는 HISTORY UPDATE - ITEM - BEGIN';
                    INSERT INTO SCM_MST_SITE_ITEM_H
                    (
	                      DIVISION_ID
	                    , HISTORY_SEQ
	                    , PROJECT_CODE
	                    , SCM_SITE_ID
	                    , ITEM_ID
	                    , CURRENCY
	                    , LIABILITY_PERIOD
	                    , SALES_PLAN_ADJUST_YN
	                    , ITEM_HRCY_ID
	                    , VALID_YN
	                    , BPMS_EXIST
	                    , CREATED_BY
	                    , CREATION_DATE
	                    , LAST_UPDATED_BY
	                    , LAST_UPDATE_DATE
	                    , HISTORY_CREATION_DATE
                    )
                    SELECT	  DIVISION_ID
		                    , (NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_H)
		                    , PROJECT_CODE
		                    , SCM_SITE_ID
		                    , ITEM_ID
		                    , CURRENCY
		                    , LIABILITY_PERIOD
		                    , SALES_PLAN_ADJUST_YN
		                    , ITEM_HRCY_ID
		                    , VALID_YN
		                    , BPMS_EXIST
		                    , CREATED_BY
	                        , CREATION_DATE
	                        , LAST_UPDATED_BY
	                        , LAST_UPDATE_DATE
		                    , SYSDATETIME()
                    FROM	#TblSCP0006_SAVE_CA_OLD_ITEM
                    PRINT N'CA에 해당하는 HISTORY UPDATE - ITEM - END';

					-- E20250820-000940 주석처리 시작
					/*
                    PRINT N'CA에 해당하는 HISTORY UPDATE - SCM_MST_SITE_ITEM_PRIORITY - BEGIN';
                    INSERT INTO SCM_MST_SITE_ITEM_PRIORITY_H
                    (
	                      HISTORY_SEQ
	                    , PRIORITY_SEQ
	                    , DIVISION_ID
	                    , PROJECT_CODE
	                    , SALES_SITE_ID
	                    , PLANT_SITE_ID
	                    , ITEM_ID
	                    , PRIORITY
	                    , FROM_YYYYMMDD
	                    , TO_YYYYMMDD
	                    , VALID_YN
	                    , CREATED_BY
	                    , CREATION_DATE
	                    , LAST_UPDATED_BY
	                    , LAST_UPDATE_DATE
	                    , HISTORY_CREATION_DATE
                    )
                    SELECT    (NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_PRIORITY_H) --#TblSCP0006_SAVE_CA_CURR 가 여러개 일 수 있음!!!
                            , PRIORITY_SEQ
                            , DIVISION_ID
                            , PROJECT_CODE
                            , SALES_SITE_ID
                            , PLANT_SITE_ID
                            , ITEM_ID
                            , PRIORITY
                            , FROM_YYYYMMDD
                            , TO_YYYYMMDD
                            , VALID_YN
                            , CREATED_BY
                            , CREATION_DATE
                            , LAST_UPDATED_BY
                            , LAST_UPDATE_DATE
                            , SYSDATETIME()
                    FROM	#TblSCP0006_SAVE_CA_CURR
                    PRINT N'CA에 해당하는 HISTORY UPDATE END';
					*/
                END
                --CA 수정 end ------------------------------------------------------------------------------------------------------------------'


--TESTING : OK
--select * from #TblSCP0006_SAVE_CA_CURR;
--select * from SCM_MST_SITE_ITEM_PRIORITY where PRIORITY_SEQ = @v_cp_priority_seq;--rollback tran; return;
------select * from SCM_MST_SITE_ITEM_PRIORITY_H where PRIORITY_SEQ = @v_cp_priority_seq;--rollback tran; return;
--select  a.* 
--from      SCM_MST_SITE_ITEM_PRIORITY a 
--        , #TblSCP0006_SAVE_CA_CURR b
--where   a.PRIORITY_SEQ = b.PRIORITY_SEQ;rollback tran; return;

			END  -- END OF STMT. IF( @v_curr_loop_cnt > 0 )
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @v_curr_loop_cnt < @v_loop_cnt

		-- E20250820-000940 CA 업데이트 대상존재시 ca업데이트
		IF @V_CA_UPDATE_EXISTS = 1 AND ISNULL(@V_CA_ITEM_CD_LIST,'') != ''
		BEGIN
			
			SET @v_division_id		= [dbo].[SCM_ARR_SPL_VAL](@p_division_id	, @v_delimiter , 1);
			SET @v_project_code		= [dbo].[SCM_ARR_SPL_VAL](@p_project_code	, @v_delimiter , 1);
			SET @v_scm_site_id		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id	, @v_delimiter , 1);
			SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id		, @v_delimiter , 1);

			declare @ca_cnt int = 0
			declare @v_curr_ca_cnt int = 0
			declare @v_ca_item_id_new nvarchar(50) = ''
			
			SET @ca_cnt = [dbo].[SCM_ARR_SPL_CNT](@V_CA_ITEM_CD_LIST, @v_delimiter);

			WHILE @v_curr_ca_cnt < @ca_cnt
			BEGIN
				set @v_ca_item_id_new = ''
				SET @v_curr_ca_cnt		= @v_curr_ca_cnt + 1;
				SET @v_ca_item_id_new		= [dbo].[SCM_ARR_SPL_VAL](@V_CA_ITEM_CD_LIST		, @v_delimiter , @v_curr_ca_cnt);

				if @v_item_id != '' and @v_ca_item_id_new != ''
				begin
					-- step 1 ca 찾기.
					-- step 1-1 ca delete					
					DELETE SCM_MST_SITE_ITEM_PRIORITY 
					WHERE DIVISION_ID = @v_division_id
					AND PROJECT_CODE = @v_project_code
					AND SALES_SITE_ID = @v_scm_site_id
					AND ITEM_ID = @v_ca_item_id_new

					-- STEP 2 CA INSERT.
					INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
					([PRIORITY_SEQ], [DIVISION_ID], [PLANT_SITE_ID], [SALES_SITE_ID], [PROJECT_CODE], [ITEM_ID], [PRIORITY], [FROM_YYYYMMDD], [TO_YYYYMMDD], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10])
					SELECT 
						(NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_PRIORITY)  , [DIVISION_ID], [PLANT_SITE_ID], [SALES_SITE_ID], [PROJECT_CODE], @v_ca_item_id_new, [PRIORITY], [FROM_YYYYMMDD], [TO_YYYYMMDD], [VALID_YN], [CREATED_BY]
						, [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE]
						, [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
					FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
					WHERE DIVISION_ID = @v_division_id
					AND PROJECT_CODE = @v_project_code
					AND SALES_SITE_ID = @v_scm_site_id
					AND ITEM_ID = @v_item_id

					-- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값. JV 동기화 설정 시작
					DELETE SMSIP
					FROM   SCM_MST_SITE_ITEM_PRIORITY SMSIP
					       INNER JOIN ( SELECT SCA.DIVISION_ID
											 , SCA.PLANT_SITE_ID
											 , SCA.PROJECT_CODE
											 , SCA.SALES_SITE_ID
											 , SCA.ITEM_ID
										FROM   #TblSCP0006_SAVE_CA_ALL SCA
										WHERE  DIVISION_ID  != @v_division_id
										AND    PROJECT_CODE  = @v_project_code
										AND    SALES_SITE_ID = @v_scm_site_id
										AND    ITEM_ID       = @v_ca_item_id_new ) SCA
							   ON  SMSIP.DIVISION_ID   = SCA.DIVISION_ID
							   AND SMSIP.PLANT_SITE_ID = SCA.PLANT_SITE_ID
							   AND SMSIP.PROJECT_CODE  = SCA.PROJECT_CODE
							   AND SMSIP.SALES_SITE_ID = SCA.SALES_SITE_ID
							   AND SMSIP.ITEM_ID       = SCA.ITEM_ID;

					-- STEP 2 CA INSERT.
					INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
					([PRIORITY_SEQ], [DIVISION_ID], [PLANT_SITE_ID], [SALES_SITE_ID], [PROJECT_CODE], [ITEM_ID], [PRIORITY], [FROM_YYYYMMDD], [TO_YYYYMMDD], [VALID_YN], [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10])
					SELECT [PRIORITY_SEQ] , [DIVISION_ID], [PLANT_SITE_ID], [SALES_SITE_ID], [PROJECT_CODE], [ITEM_ID], [PRIORITY], [FROM_YYYYMMDD], [TO_YYYYMMDD], [VALID_YN], [CREATED_BY]
						, [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE]
						, [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5], [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
					FROM #TblSCP0006_SAVE_CA_ALL WITH(NOLOCK)
					WHERE DIVISION_ID != @v_division_id
					AND PROJECT_CODE   = @v_project_code
					AND SALES_SITE_ID  = @v_scm_site_id
					AND ITEM_ID        = @v_ca_item_id_new
					-- 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 실제 Link scm site id 값. JV 동기화 설정 끝
				end
			END
		END


--TESTING : OK
--select * from #TblSCP0006_SAVE_CA_ALL;

		SET @v_log_type			= 'END';
		SET @v_log_message		 = '########## END of procedure ##########';
		SET @v_description		= '';
		SET @d_event_date		= SYSDATETIME();

        IF @test_mode = 'T'
        BEGIN
            PRINT N'CA 수정 리스트 - BEGIN'
            SELECT  A.*
            FROM    SCM_MST_SITE_ITEM A
                    JOIN #TblSCP0006_SAVE_CA_ALL B ON
					        A.DIVISION_ID	= B.DIVISION_ID
				        AND A.PROJECT_CODE	= B.PROJECT_CODE
				        AND	A.SCM_SITE_ID	= B.PLANT_SITE_ID
				        AND	A.ITEM_ID		= B.ITEM_ID

            SELECT  A.*
            FROM    SCM_MST_SITE_ITEM_PRIORITY A
                    JOIN #TblSCP0006_SAVE_CA_ALL B ON
					        A.DIVISION_ID	= B.DIVISION_ID
				        AND A.PROJECT_CODE	= B.PROJECT_CODE
				        AND	A.PLANT_SITE_ID	= B.PLANT_SITE_ID
				        AND	A.SALES_SITE_ID	= B.SALES_SITE_ID
				        AND	A.ITEM_ID		= B.ITEM_ID
            PRINT N'CA 수정 리스트 - END'

            ROLLBACK TRAN;RETURN;
        END

      
        IF @test_mode <> 'T'
        BEGIN
    		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

		COMMIT TRAN;


		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @v_loop_cnt AS result_cnt;
	END TRY
	BEGIN CATCH
		  IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
		  BEGIN
			INSERT INTO SCM_SYS_LOG_BATCH
			(
				  PROGRAM_NAME
				, LOG_TYPE
				, LOG_COUNT
				, LOG_MESSAGE
				, DESCRIPTION
				, EVENT_DATE
				, CREATION_DATE
				, CREATED_BY
				, LAST_UPDATE_DATE
				, LAST_UPDATED_BY
			)
			VALUES
			(
				  ISNULL(ERROR_PROCEDURE(), 'SCP0006_SAVE_PROJECT_ROUTE_PLANT')
	 			, 'ERROR'
	 			, NULL
	 			, ERROR_MESSAGE()
	 			, NULL
	 			, SYSDATETIME()
	 			, SYSDATETIME()
	 			, ERROR_PROCEDURE()
	 			, SYSDATETIME()
				, ERROR_PROCEDURE()
			)

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;


		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;


    BEGIN -- 커서 해제 & 임시테이블 삭제------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0103_BALANCE') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0103_BALANCE;
	    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_CURR') IS NOT NULL
			DROP TABLE #TblSCP0006_SAVE_CA_CURR;
	    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_BOM_ITEMS') IS NOT NULL
			DROP TABLE #TblSCP0006_SAVE_CA_BOM_ITEMS;
	    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL') IS NOT NULL
			DROP TABLE #TblSCP0006_SAVE_CA_BOM_ITEMS_FINAL;
	    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_OLD_ITEM') IS NOT NULL
			DROP TABLE #TblSCP0006_SAVE_CA_OLD_ITEM;
	    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CA_OLD_SCM_MST_SITE_ITEM_PRIORITY') IS NOT NULL
			DROP TABLE #TblSCP0006_SAVE_CA_OLD_SCM_MST_SITE_ITEM_PRIORITY;
	    IF OBJECT_ID('tempdb..#TblSCP0006_SAVE_CP') IS NOT NULL
			DROP TABLE #TblSCP0006_SAVE_CP;
    END
END
