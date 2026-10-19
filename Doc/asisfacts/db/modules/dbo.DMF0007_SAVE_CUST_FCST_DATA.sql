
/*
 * Program ID   : DMF0007_SAVE_CUST_FCST_DATA
 * Description  : DM_MST_CUSTOMER_FCST DATA SAVE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 12. 20    DWOK     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 03. 22    SONGKH Modify
 * 20180806 KHSONG INVALID LOG 생성로직 추가
 * 20191210 KHSONG EDI예약어 MEASURE 등록시 '*' 추가
 * 20221026 KDW2819	[C20221024-000507]CUST FCST Upload 오류 수정
 */

CREATE PROCEDURE [dbo].[DMF0007_SAVE_CUST_FCST_DATA]
	@p_active_flag			NVARCHAR(MAX),		
	@p_division_id			NVARCHAR(MAX),
	@p_plan_week			NVARCHAR(MAX),
	@p_customer_code		NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_measure_group		NVARCHAR(MAX),		
	@p_measure				NVARCHAR(MAX),
	@p_valid_yn				NVARCHAR(MAX),
	@p_customer_psi			NVARCHAR(MAX),
	@p_upload_uom			NVARCHAR(MAX),
	@p_upload_bucket_type	NVARCHAR(MAX),
	@p_summary_bucket_type	NVARCHAR(MAX),
	@p_summary_bucket_value	NVARCHAR(MAX),
	@p_summary_bucket_yn	NVARCHAR(MAX),			-- Y: valid_yn값
	@p_edi_fcst_yn			NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
	
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	-- 멀티처리 변수선언
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_plan_week			NVARCHAR(MAX);
	DECLARE @v_customer_code		NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_measure_group		NVARCHAR(MAX);
	DECLARE @v_measure				NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_customer_psi			NVARCHAR(MAX);
	DECLARE @v_upload_uom			NVARCHAR(MAX);
	DECLARE @v_upload_bucket_type	NVARCHAR(MAX);
	DECLARE @v_summary_bucket_type	NVARCHAR(MAX);
	DECLARE @v_summary_bucket_value	NVARCHAR(MAX);
	DECLARE @v_summary_bucket_yn	NVARCHAR(MAX);
	DECLARE @v_edi_fcst_yn			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @v_dup_flag			    INTEGER = 0; 
	DECLARE @n_existence_flag       INTEGER = 0; 
	DECLARE @n_existence_value      NVARCHAR(MAX);

	-- 초기화
	SET @v_active_flag			= NULL;
	SET @v_division_id			= NULL;
	SET @v_plan_week			= NULL;
	SET @v_customer_code		= NULL;
	SET @v_scm_site_id			= NULL;
	SET @v_measure_group		= NULL;
	SET @v_measure				= NULL;
	SET @v_valid_yn				= NULL;
	SET @v_customer_psi			= NULL;
	SET @v_upload_uom			= NULL;
	SET @v_upload_bucket_type	= NULL;
	SET @v_summary_bucket_type	= NULL;
	SET @v_summary_bucket_value	= NULL;
	SET @v_summary_bucket_yn	= NULL;
	SET @v_edi_fcst_yn			= NULL;
	SET @v_created_by			= NULL;
	SET @v_dup_flag  			= 0;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0007_SAVE_CUST_FCST_DATA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	--VALIDATION용 변수 설정
	DECLARE @SUMMARY_FLAG INT = 0;
	
	DECLARE @results TABLE (
			 n_division_id	        NVARCHAR(MAX)
			,n_plan_week		    NVARCHAR(MAX)
			,n_customer_code        NVARCHAR(MAX)
			,n_scm_site_id	        NVARCHAR(MAX)
			,n_summary_bucket_value NVARCHAR(MAX)
			,n_measure_group        NVARCHAR(MAX)
			,n_measure			    NVARCHAR(MAX)
			,n_customer_psi	        NVARCHAR(MAX)
			,n_valid_yn             NVARCHAR(MAX)
			)
	DECLARE @FCST_MEASURE TABLE (
			 n_division_id	        NVARCHAR(MAX)
			
			
			,n_scm_site_id	        NVARCHAR(MAX)
			
			
			
			
			)

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	BEGIN TRANSACTION DMF0007_SAVE_CUST_FCST_DATA;  

		BEGIN TRY

		--------------------------------------------------------------------- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		--------------------------------------------------------------------- WHILE loop START
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		--------------------------------------------------------------------- WHILE loop START

		BEGIN    
			
		--------------------------------------------------------------------- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

		--------------------------------------------------------------------- 각 컬럼들에 대한 split (start)
			BEGIN
				SET @v_active_flag           = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag,         @v_delimiter, @mst_loop_cnt) ;    
				SET @v_division_id           = [dbo].[SCM_ARR_SPL_VAL](@p_division_id,         @v_delimiter, @mst_loop_cnt) ; 
				SET @v_plan_week             = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week,           @v_delimiter, @mst_loop_cnt) ; 
				IF @v_active_flag = 'I'
					BEGIN
						SET @v_plan_week = 
						(	SELECT a.ISO_YYYYWW   
							FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
							WHERE  a.BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)	)
					END
				SET @v_customer_code         = [dbo].[SCM_ARR_SPL_VAL](@p_customer_code,       @v_delimiter, @mst_loop_cnt) ; 
				SET @v_scm_site_id           = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id,         @v_delimiter, @mst_loop_cnt) ;    
				SET @v_measure_group         = [dbo].[SCM_ARR_SPL_VAL](@p_measure_group,       @v_delimiter, @mst_loop_cnt) ;    

				SET @v_measure               = [dbo].[SCM_ARR_SPL_VAL](@p_measure,             @v_delimiter, @mst_loop_cnt) ;    

				-- 20191210 KHSONG EDI예약어 MEASURE 등록시 '*' 추가
				SET @v_measure = CASE  
										WHEN @v_measure = 'Immidiate'				THEN 'Immidiate*' 
										WHEN @v_measure = 'Planning_Forecast'		THEN 'Planning_Forecast*' 
										WHEN @v_measure = 'Commercial_Agreement'	THEN 'Commercial_Agreement*' 
									ELSE @v_measure
								END
				SET @v_valid_yn              = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn,            @v_delimiter, @mst_loop_cnt) ; 
				SET @v_customer_psi          = [dbo].[SCM_ARR_SPL_VAL](@p_customer_psi,        @v_delimiter, @mst_loop_cnt) ; 
				SET @v_upload_uom            = [dbo].[SCM_ARR_SPL_VAL](@p_upload_uom,          @v_delimiter, @mst_loop_cnt) ; 
				SET @v_upload_bucket_type    = [dbo].[SCM_ARR_SPL_VAL](@p_upload_bucket_type,  @v_delimiter, @mst_loop_cnt) ; 
				SET @v_summary_bucket_type   = [dbo].[SCM_ARR_SPL_VAL](@p_summary_bucket_type, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_summary_bucket_value  = [dbo].[SCM_ARR_SPL_VAL](@p_summary_bucket_value,@v_delimiter, @mst_loop_cnt) ; 
				SET @v_edi_fcst_yn           = [dbo].[SCM_ARR_SPL_VAL](@p_edi_fcst_yn,         @v_delimiter, @mst_loop_cnt) ; 
				SET @v_summary_bucket_yn     = [dbo].[SCM_ARR_SPL_VAL](@p_summary_bucket_yn,   @v_delimiter, @mst_loop_cnt) ; 
				SET @v_created_by            = [dbo].[SCM_ARR_SPL_VAL](@p_created_by,          @v_delimiter, @mst_loop_cnt) ; 
			END
		--------------------------------------------------------------------- 각 컬럼들에 대한 split (end)

		---------------------------------------------------------------------- input data를 temp table 에 저장하여 비교값으로 사용  songkh modify (start)
			INSERT INTO @results
				( n_division_id, n_plan_week, n_customer_code, n_scm_site_id, n_summary_bucket_value
				, n_measure_group, n_measure, n_customer_psi, n_valid_yn	)
				VALUES
				( @v_division_id, @v_plan_week, @v_customer_code, @v_scm_site_id, @v_summary_bucket_value
				, @v_measure_group, @v_measure, @v_customer_psi, @v_summary_bucket_yn	)

			SET  @v_dup_flag = 0

			IF @v_summary_bucket_yn = 'N' --@v_valid_yn = 'N' / @v_summary_bucket_yn
			  BEGIN
				set @v_dup_flag = (SELECT count(*)
				 FROM [dbo].DM_MST_CUSTOMER_FCST WITH(NOLOCK) where 1=1
				  and DIVISION_ID = @v_division_id
				  and PLAN_WEEK = @v_plan_week
				  and SCM_SITE_ID = @v_scm_site_id
				  and SUMMARY_BUCKET_VALUE = @v_summary_bucket_value
				  and MEASURE_GROUP = @v_measure_group
				  and valid_yn    = 'Y'
				  AND customer_psi = @v_customer_psi
				  and measure <> @v_measure )

				set @v_dup_flag = @v_dup_flag + (SELECT count(*)
				 FROM @results where 1=1
				  and n_DIVISION_ID = @v_division_id
				  and n_PLAN_WEEK = @v_plan_week
				  and n_SCM_SITE_ID = @v_scm_site_id
				  and n_SUMMARY_BUCKET_VALUE = @v_summary_bucket_value
				  and n_valid_yn    = 'Y'
				  and n_MEASURE_GROUP = @v_measure_group
				  AND n_customer_psi = @v_customer_psi
				  and n_measure <> @v_measure )
			  END

			  --------------------------------------------------------------하나의 SCM_SITE_ID 당 하나의 SUMMARY BUCKET TYPE 존재 여부 체크

			  
			  SET @SUMMARY_FLAG = 0;


			  SELECT @SUMMARY_FLAG = COUNT(*)
			  FROM (
						  SELECT DIVISION_ID,SCM_SITE_ID, COUNT(SUMMARY_BUCKET_TYPE) AS COUNT_BUCKET
						  FROM (
								  SELECT DIVISION_ID, SCM_SITE_ID, SUMMARY_BUCKET_TYPE
								  FROM (
												SELECT 
																	division_id				,
																	plan_week				,
																	customer_code			,
																	scm_site_id				,
																	measure_group			,
																	measure					,
																	valid_yn				,
																	customer_psi			,
																	upload_uom				,
																	upload_bucket_type		,
																	summary_bucket_type		,
																	summary_bucket_value	,
																	edi_fcst_yn				,
																	upload_user_id			,
																	created_by				,
																	creation_date			,
																	last_updated_by			,
																	last_update_date
												FROM DM_MST_CUSTOMER_FCST
												union all
											   SELECT 
															@v_division_id					,
															@v_plan_week					,
															@v_customer_code				,
															@v_scm_site_id					,
															@v_measure_group				,
															@v_measure						,
															@v_summary_bucket_yn			,
															@v_customer_psi					,
															@v_upload_uom					,
															@v_upload_bucket_type			,
															@v_summary_bucket_type 			,
															@v_summary_bucket_value			,
															@v_edi_fcst_yn					,
															@v_created_by					,
															@v_created_by					,
															sysdatetime()					,
															@v_created_by					,
															sysdatetime()
										) T1
									WHERE VALID_YN = 'Y'
									AND SCM_SITE_ID = @v_scm_site_id
									AND DIVISION_ID = @v_division_id
									AND MEASURE_GROUP = @v_measure_group
									GROUP BY DIVISION_ID, SCM_SITE_ID, SUMMARY_BUCKET_TYPE
						
							)T1
							GROUP BY DIVISION_ID, SCM_SITE_ID
							HAVING	COUNT(SUMMARY_BUCKET_TYPE)>1
				) T1

				--SELECT @SUMMARY_FLAG AS '@SUMMARY_FLAG'

				IF @SUMMARY_FLAG >0 
				BEGIN
				SELECT 'MSG00166'
--N'하나의 SITE에는 두가지 이상의 SUMMARY BUCKET TYPE(DAILY, WEEKLY, MONTHLY)이 설정 될 수 없습니다.
--기존에 입력된 SUMMARY BUCKET TYPE에 대해 각 날짜별 N으로 저장하여 주십시오.'
				SET @v_log_type = 'INVALID';
				GOTO ERR_RTN
				END
				

		--------------------------------------------------------------------- input data를 temp table 에 저장하여 비교값으로 사용 songkh modify (end)

		--------------------------------------------------------------------- 데이터 기준값 DAY:20000101 , WEEK : 20000102, MONTH: 20000103 설정하여 MASTER 값으로 사용함
		        SET @n_existence_flag = 0
				SET @n_existence_value = ''

			    SET @n_existence_value =
				  CASE
					 WHEN (@v_summary_bucket_type = 'DAILY')   THEN '20000101'
					 WHEN (@v_summary_bucket_type = 'WEEKLY')  THEN '20000102'
					 WHEN (@v_summary_bucket_type = 'MONTHLY') THEN '20000103'
				  END

				---------------------------------------------------- summary_bucket_type 기준으로 이미 존재하는 데이터를 확인함
				SET @n_existence_flag = ISNULL((
				SELECT COUNT(1) FROM dbo.DM_MST_CUSTOMER_FCST
					WHERE 1=1
					AND division_id           = @v_division_id
					AND plan_week             = @v_plan_week
					AND customer_code         = @v_customer_code
					AND scm_site_id           = @v_scm_site_id
					AND summary_bucket_value  = @n_existence_value
					AND measure_group         = @v_measure_group
					AND customer_psi          = @v_customer_psi
					--AND summary_bucket_value  = @v_summary_bucket_value
					and summary_bucket_type   = @v_summary_bucket_type
					AND MEASURE					 = @v_measure
					),0)
				--select @n_existence_flag as '@n_existence_flag2'
				--select @n_existence_value as '@n_existence_value2'
								 
				---------------------------------------------------- MASTER 값 INSERT
				IF  @n_existence_flag = 0
				  BEGIN
					INSERT INTO  dbo.DM_MST_CUSTOMER_FCST
					(  division_id, plan_week, customer_code, scm_site_id, measure_group, measure
					, valid_yn, customer_psi, upload_uom, upload_bucket_type, summary_bucket_type
					, summary_bucket_value, edi_fcst_yn, upload_user_id, created_by, creation_date, last_updated_by, last_update_date	)
					VALUES	
					(	@v_division_id, @v_plan_week, @v_customer_code, @v_scm_site_id, @v_measure_group, @v_measure
					, 'N', @v_customer_psi, @v_upload_uom, @v_upload_bucket_type, @v_summary_bucket_type, @n_existence_value
					, @v_edi_fcst_yn, @v_created_by, @v_created_by, sysdatetime(), @v_created_by, sysdatetime()	);
				  END

				  --select * from DM_MST_CUSTOMER_FCST where PLAN_WEEK = '201814' and scm_site_id = 'Ford_US_RDF' order by LAST_UPDATE_DATE
				
		IF @v_dup_flag = 0
		  BEGIN
				-- INPUT 데이터 INSERT전 DELETE처리
				DELETE  FROM  dbo.DM_MST_CUSTOMER_FCST
					WHERE 1=1
					AND division_id           = @v_division_id
					AND plan_week             = @v_plan_week
					AND customer_code         = @v_customer_code
					AND scm_site_id           = @v_scm_site_id
					AND summary_bucket_value  = @v_summary_bucket_value
					AND measure_group         = @v_measure_group
					AND customer_psi          = @v_customer_psi

		--------------------------------------------------------------------- INPUT 데이터 INSERT
				INSERT INTO  dbo.DM_MST_CUSTOMER_FCST
				(  division_id, plan_week, customer_code, scm_site_id, measure_group, measure
				, valid_yn, customer_psi, upload_uom, upload_bucket_type, summary_bucket_type
				, summary_bucket_value, edi_fcst_yn, upload_user_id, created_by, creation_date, last_updated_by, last_update_date	)
				VALUES	
				(	@v_division_id, @v_plan_week, @v_customer_code, @v_scm_site_id, @v_measure_group, @v_measure
				, @v_summary_bucket_yn, @v_customer_psi, @v_upload_uom, @v_upload_bucket_type, @v_summary_bucket_type, @v_summary_bucket_value
				, @v_edi_fcst_yn, @v_created_by, @v_created_by, sysdatetime(), @v_created_by, sysdatetime()	);

		--------------------------------------------------------------------- history insert
				EXEC	[dbo].[PR_DM_MST_CUSTOMER_FCST_HIST]	
						@v_division_id				,
						@v_plan_week				,
						@v_customer_code			,
						@v_scm_site_id				,		
						@v_summary_bucket_value		,
						@v_measure_group			,
						@v_measure					,
						@v_summary_bucket_yn		,  -- valid_yn
						@v_customer_psi				,
						@v_upload_uom				,
						@v_upload_bucket_type		,
						@v_summary_bucket_type		,
						@v_edi_fcst_yn				,
						@v_created_by				,
						@v_created_by				,
						@v_created_by	

		  END
		  END

		---------------------------------------------------------------------	WHILE loop END

		--@results
		select *
		  into  #tmp_site_customer_map
		  from (
						select a.DIVISION_ID,a.SCM_SITE_ID,a.MEASURE,
   							   a.SUMMARY_BUCKET_VALUE as start_day
							  ,case when summary_bucket_type = 'WEEKLY' THEN CONVERT(CHAR(8), DATEADD(DD, 0, dbo.FN_NEXT_DAY( cast( SUMMARY_BUCKET_VALUE as datetime) , 'SUN')), 112) 
								   else a.SUMMARY_BUCKET_VALUE
								END  end_day
						FROM dbo.DM_MST_CUSTOMER_FCST a
						  inner join 
						  (select distinct n_division_id,n_scm_site_id
						  from @results ) rslt
					  on(
							a.DIVISION_ID   = rslt.n_division_id
						and a.SCM_SITE_ID   = rslt.n_scm_site_id
					   )
						where 1=1
						and VALID_YN = 'Y'
						and a.MEASURE_GROUP = 'CUST_FCST'
						and a.PLAN_WEEK = 
								(SELECT MAX(PLAN_WEEK)  
									FROM DM_MST_CUSTOMER_FCST 
									)
						and a.SUMMARY_BUCKET_VALUE >=  CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 이후데이터만 
						and summary_bucket_type in ('DAILY','WEEKLY')

						UNION

						select a.DIVISION_ID,a.SCM_SITE_ID,a.MEASURE
   							  , case when  SUMMARY_BUCKET_VALUE = convert(varchar(8),  DATEADD(DAY,1,DATEADD(DAY,-DATEPART(DD,getdate()),getdate())) ,112) THEN  CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
									else  SUMMARY_BUCKET_VALUE  end as start_day
							  , CONVERT(CHAR(8),  dateadd(day,-DATEPART(DD, dateadd(month,1,cast( SUMMARY_BUCKET_VALUE as datetime) )), dateadd(month,1,cast( SUMMARY_BUCKET_VALUE as datetime) ))   , 112)   end_day
						FROM dbo.DM_MST_CUSTOMER_FCST a
						  inner join 
						  (select distinct n_division_id,n_scm_site_id
						  from @results ) rslt
					  on(
							a.DIVISION_ID   = rslt.n_division_id
						and a.SCM_SITE_ID   = rslt.n_scm_site_id
					   )
						where 1=1
						and VALID_YN = 'Y'
						and a.MEASURE_GROUP = 'CUST_FCST'
						and a.PLAN_WEEK = 
								(SELECT MAX(PLAN_WEEK)  
									FROM DM_MST_CUSTOMER_FCST 
									)
						and a.SUMMARY_BUCKET_VALUE >=  convert(varchar(8),  DATEADD(DAY,1,DATEADD(DAY,-DATEPART(DD,getdate()),getdate())) ,112)
						and summary_bucket_type in ('MONTHLY')
		) z


			/*현재 고치는 CUSTOMER FCST MASTER의 MEASURE로 입력 MARKETING FCST 값이 있는지 VALIDATION */
						SELECT		T1.DIVISION_ID,
									T1.SCM_SITE_ID,
									T1.PROJECT_CODE,
									T1.ITEM_ID,
									T1.DOM_EXP,
									T1.FCST_TYPE,
									T1.INCOTERMS,
									T1.PLANT_SITE_ID

									INTO #DELETE_TARGET
						FROM (
									SELECT	T1.DIVISION_ID,
											T1.SCM_SITE_ID,
											T1.PROJECT_CODE,
											T1.ITEM_ID,
											T1.DOM_EXP,
											T1.FCST_TYPE,
											T1.INCOTERMS,
											T1.MEASURE,
											T1.PLANT_SITE_ID
									FROM DM_PLN_MKT_FCST T1
									INNER JOIN DM_MST_CUSTOMER_FCST T2
									ON T1.DIVISION_ID = T2.DIVISION_ID
									AND T1.SCM_SITE_ID = T2.SCM_SITE_ID
									AND (T1.MEASURE = T2.MEASURE OR T1.MEASURE = 'CUST_FCST')
									GROUP BY 
											T1.DIVISION_ID,
											T1.SCM_SITE_ID,
											T1.PROJECT_CODE,
											T1.ITEM_ID,
											T1.DOM_EXP,
											T1.FCST_TYPE,
											T1.INCOTERMS,
											T1.MEASURE,
											T1.PLANT_SITE_ID
						)T1
						INNER JOIN (SELECT  DISTINCT N_DIVISION_ID, N_SCM_SITE_ID FROM @RESULTS) T2
						ON			T1.DIVISION_ID = T2.N_DIVISION_ID
						AND			T1.SCM_SITE_ID = T2.N_SCM_SITE_ID
						GROUP BY	T1.DIVISION_ID,
									T1.SCM_SITE_ID,
									T1.PROJECT_CODE,
									T1.ITEM_ID,
									T1.DOM_EXP,
									T1.FCST_TYPE,
									T1.INCOTERMS,
									T1.PLANT_SITE_ID

						HAVING COUNT (MEASURE)>1

					DELETE		T1 
					FROM		DM_PLN_MKT_FCST T1
					INNER JOIN	#DELETE_TARGET T2
					ON			T1.DIVISION_ID		= T2.DIVISION_ID
					AND			T1.SCM_SITE_ID		= T2.SCM_SITE_ID
					AND			T1.PROJECT_CODE		= T2.PROJECT_CODE
					AND			T1.ITEM_ID			= T2.ITEM_ID
					AND			T1.DOM_EXP			= T2.DOM_EXP
					AND			T1.FCST_TYPE		= T2.FCST_TYPE
					AND			T1.INCOTERMS		= T2.INCOTERMS
					AND			T1.PLANT_SITE_ID	= T2.PLANT_SITE_ID
					WHERE		T1.MEASURE = 'CUST_FCST'   


					insert into DM_PLN_MKT_FCST
					select   a.DIVISION_ID
							 ,a.PROJECT_CODE
							 ,a.SCM_SITE_ID
							 ,a.ITEM_ID
							 ,a.DOM_EXP
							 ,a.FCST_TYPE
							 ,a.INCOTERMS
							 ,'CUST_FCST'
							 ,a.PLANT_SITE_ID
							 ,a.YYYYMMDD
							 ,a.QTY
							 ,a.CREATED_BY
							 ,a.CREATION_DATE
							 ,a.LAST_UPDATED_BY
							 ,a.LAST_UPDATE_DATE
							 ,a.ATTRIBUTE1
							 ,a.ATTRIBUTE2
							 ,a.ATTRIBUTE3
							 ,a.ATTRIBUTE4
							 ,a.ATTRIBUTE5
							 ,a.ATTRIBUTE6
							 ,a.ATTRIBUTE7
							 ,a.ATTRIBUTE8
							 ,a.ATTRIBUTE9
							 ,a.ATTRIBUTE10
					  from dbo.DM_PLN_MKT_FCST a WITH(NOLOCK)
						  inner join 
						  (select distinct n_division_id,n_scm_site_id
							  from @results ) rslt
					  on(
							a.DIVISION_ID   = rslt.n_division_id
						and a.SCM_SITE_ID   = rslt.n_scm_site_id
					   )
						  inner join 
						  (select DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day  
						  from #tmp_site_customer_map group by DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day) map

					  on(
							a.DIVISION_ID   = map.DIVISION_ID 
						and a.SCM_SITE_ID   = map.SCM_SITE_ID
						and a.MEASURE       = map.MEASURE
					   )

						where 1=1
						and a.YYYYMMDD between map.start_day and map.end_day
						and a.YYYYMMDD >=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
						;
			
	
		COMMIT WORK;

		END TRY
			
	BEGIN CATCH

      ROLLBACK TRANSACTION DMF0007_SAVE_CUST_FCST_DATA;  

      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	  
    END CATCH;
	
	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;						


  ERR_RTN:
  IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION DMF0007_SAVE_CUST_FCST_DATA; 
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'END', @n_log_count, @v_log_message, @v_description, @d_event_date; 
		end

