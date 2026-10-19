



/*
 * Program ID   : SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY
 * Description  : ANL SHIPMENT PLAN SEMI save
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/09/07	jahn1501		PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 주차별 수량 입력
 * 2022/12/05   jahn1501        PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Parial Weekly 수량 입력 가능하도록 변경
 * 
 */
CREATE PROCEDURE [dbo].[SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY_20251114_org]
	@SCP0010			AS DBO.SCP0010       READONLY
AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @max_loop_cnt		NVARCHAR(50);


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	-- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';   

	DECLARE @v_time_zone  NVARCHAR(100);
	DECLARE @v_creation_date		datetime;		-- timezone에 따른 저장위해서

    DECLARE @v_bucket		NVARCHAR(50) = ''
	DECLARE @mEXEC NVARCHAR(MAX);

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0010') IS NOT NULL
		DROP TABLE #TblDynamic_SCP0010
	IF OBJECT_ID('tempdb..#LAST_INFO_TABLE') IS NOT NULL
		DROP TABLE #LAST_INFO_TABLE		

	CREATE TABLE #TblDynamic_SCP0010 (
		A							NVARCHAR(1),
		p_active_flag				NVARCHAR(1),
		p_division_id				NVARCHAR(30),
		p_plan_start_yyyymmdd		NVARCHAR(8),
		p_plan_type					NVARCHAR(2),
		p_seq						NVARCHAR(10),
		p_operation_group			NVARCHAR(1),
		p_item_id					NVARCHAR(100),
		p_from_site					NVARCHAR(50),
		p_bod_id					NVARCHAR(50),
		p_measure					NVARCHAR(100),
		p_yyyymmdd					NVARCHAR(8),
		p_to_site					NVARCHAR(100),
		p_qty						NVARCHAR(200),
		p_origin_from_division_id	NVARCHAR(30),
		p_origin_to_division_id		NVARCHAR(30),
		p_electrode_type			NVARCHAR(50),
		p_created_by				NVARCHAR(150),
		p_last_updated_by			NVARCHAR(150),
		p_time_zone					NVARCHAR(100),
		p_cplt_flag					NVARCHAR(1)
	);

	CREATE TABLE #LAST_INFO_TABLE (
		LT_WEEK					NVARCHAR(10),
		EXIST_YN				NVARCHAR(1),
		BASIS_YYYYMMDD			NVARCHAR(8),
		QTY						NUMERIC(20,10),--INT,
		DIVISION_ID				NVARCHAR(50),
		BOD_ID					NVARCHAR(50),
		ITEM_ID					NVARCHAR(200),
		PLAN_TYPE				NVARCHAR(100),
		PLAN_START_YYYYMMDD		NVARCHAR(20),
	);

	-- 트렌젝션 시작
	BEGIN TRAN;
	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
		SET @v_bucket = (SELECT TOP 1 p_bucket_type FROM @SCP0010)

		IF @v_bucket = 'DAILY'
		BEGIN    
			--TimeZone set
			SET @v_time_zone = (SELECT TOP 1 p_time_zone
								FROM @SCP0010  
								)
			;
			IF (@v_time_zone=NULL OR @v_time_zone='')
				SET @v_time_zone = 'AS054'
			;

			SET @v_creation_date    = [dbo].[FN_MULTY_TIME](@v_time_zone); 


			-- 임시테이블 데이타 생성
			INSERT INTO #TblDynamic_SCP0010
			SELECT A,
					p_active_flag,
					p_division_id,
					p_plan_start_yyyymmdd,
					p_plan_type,
					p_seq,
					p_operation_group,
					p_item_id,
					p_from_site,
					p_bod_id,
					p_measure,
					p_yyyymmdd,
					p_to_site,
					p_qty,
					p_origin_from_division_id,
					p_origin_to_division_id,
					p_electrode_type,
					p_created_by,
					p_last_updated_by,
					p_time_zone,
					''
			FROM @SCP0010

			--수정 Row
			SET @max_loop_cnt = convert(nvarchar(50), ISNULL((
									SELECT COUNT(*) 
									FROM #TblDynamic_SCP0010  
								  ),0))
			;

			-- 1. 수정수량 UPDATE
			UPDATE A
			SET A.TO_SITE			= B.p_to_site
				--, A.QTY				= cast(B.p_qty as int)
				, A.QTY				= cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int)
				, A.LAST_UPDATED_BY	= B.p_last_updated_by 
				, A.LAST_UPDATE_DATE	= @v_creation_date
			FROM SCP_ANL_SHIPMENT_PLAN_SEMI A, #TblDynamic_SCP0010 B
			WHERE A.DIVISION_ID				= B.p_division_id
			AND A.PLAN_START_YYYYMMDD		= B.p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					= B.p_plan_type
			AND A.SEQ						= B.p_seq
			AND A.operation_group			= B.p_operation_group
			AND A.ITEM_ID					= B.p_item_id
			AND A.FROM_SITE					= B.p_from_site
			AND A.BOD_ID					= B.p_bod_id
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND A.ELECTRODE_TYPE			= B.p_electrode_type
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND B.p_active_flag IN ('M', 'I')
			;

			UPDATE B
			SET B.p_cplt_flag = 'Y'
			FROM SCP_ANL_SHIPMENT_PLAN_SEMI A, #TblDynamic_SCP0010 B
			WHERE A.DIVISION_ID				= B.p_division_id
			AND A.PLAN_START_YYYYMMDD		= B.p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					= B.p_plan_type
			AND A.SEQ						= B.p_seq
			AND A.operation_group			= B.p_operation_group
			AND A.ITEM_ID					= B.p_item_id
			AND A.FROM_SITE					= B.p_from_site
			AND A.BOD_ID					= B.p_bod_id
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND A.ELECTRODE_TYPE			= B.p_electrode_type
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND B.p_active_flag IN ('M', 'I')
			;

			-- 2. 신규수량 INSERT]
			INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_SEMI
				(DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,OPERATION_GROUP
				,ITEM_ID
				,FROM_SITE
				,BOD_ID
				,MEASURE
				,YYYYMMDD
				,TO_SITE
				,QTY
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID
				,ELECTRODE_TYPE
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
			SELECT p_division_id  
					,p_plan_start_yyyymmdd
					,p_plan_type
					,p_seq
					,p_operation_group
					,p_item_id		
					,p_from_site
					,p_bod_id		
					,p_measure		
					,p_yyyymmdd		
					,p_to_site
					--,cast(p_qty as int)
					,cast(round (cast(p_qty as numeric(20,10)), 0 ,1) as int)
					,p_origin_from_division_id
					,p_origin_to_division_id
					,p_electrode_type
					,p_created_by
					,@v_creation_date
					,p_last_updated_by
					,@v_creation_date
			FROM #TblDynamic_SCP0010
			WHERE p_active_flag IN ('M', 'I')
			  AND ISNULL(p_cplt_flag,'')=''
			;

			-- 3. 삭제수량 DELETE
			DELETE A
			FROM SCP_ANL_SHIPMENT_PLAN_SEMI A, #TblDynamic_SCP0010 B
			WHERE A.DIVISION_ID				= B.p_division_id
			AND A.PLAN_START_YYYYMMDD		= B.p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					= B.p_plan_type
			AND A.SEQ						= B.p_seq
			AND A.operation_group			= B.p_operation_group
			AND A.ITEM_ID					= B.p_item_id
			AND A.FROM_SITE					= B.p_from_site
			AND A.BOD_ID					= B.p_bod_id
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND A.ELECTRODE_TYPE			= B.p_electrode_type
			AND B.p_active_flag				= 'D'

			-- 4. FIX수량 UPDATE
			UPDATE A
			SET --A.qty				= cast(B.p_qty as int)
				A.qty				= B.p_qty --cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int)
				,A.last_updated_by	= B.p_last_updated_by
				,A.last_update_date	= @v_creation_date
			FROM SCP_ANL_SHIPMENT_PLAN_FIX A, #TblDynamic_SCP0010 B
			WHERE A.division_id				= B.p_division_id
			and A.BIZ_TYPE					= B.p_operation_group
			and A.ITEM_ID					= B.p_item_id
			and A.TO_SITE					= B.p_to_site
			and A.FROM_SITE					= B.p_from_site
			and A.BOD_ID					= B.p_bod_id
			and A.yyyymmdd					= B.p_yyyymmdd
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(B.p_electrode_type,''),'-')

			-- 5. FIX이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET] @SCP0010

			-- 6. 이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET] @SCP0010

			commit;

		END
		ELSE --WEEKLY
		BEGIN
			--TimeZone set
			SET @v_time_zone = (SELECT TOP 1 p_time_zone
								FROM @SCP0010  
								)
			;
			IF (@v_time_zone=NULL OR @v_time_zone='')
				SET @v_time_zone = 'AS054'
			;

			SET @v_creation_date    = [dbo].[FN_MULTY_TIME](@v_time_zone); 		
		
			--수정 Row
			SET @max_loop_cnt = convert(nvarchar(50), ISNULL((
									SELECT COUNT(*) 
									FROM @SCP0010
								  ),0))
			;		
		
			DECLARE @p_division_id			NVARCHAR(30) = '';
			DECLARE @p_item_id 				NVARCHAR(30) = '';
			DECLARE @p_from_site			NVARCHAR(30) = '';
			DECLARE @p_to_site 				NVARCHAR(30) = '';
			DECLARE @p_qty 					NVARCHAR(30) = '';
			DECLARE @p_plan_type			NVARCHAR(30) = '';
			DECLARE @p_bod_id				NVARCHAR(30) = '';
			DECLARE @p_plan_start_yyyymmdd	NVARCHAR(30) = '';
			DECLARE @p_seq 					NVARCHAR(10) = '';
			DECLARE @p_yyyymmdd 			NVARCHAR(10) = '';
			DECLARE @v_mm					NVARCHAR(10) = '';
			DECLARE @p_trans_mode			NVARCHAR(100) = '';
			DECLARE @p_last_updated_by		NVARCHAR(100) = '';
		
			DECLARE CUR CURSOR FOR
			SELECT p_division_id, p_item_id, p_from_site, p_to_site, p_qty, p_plan_type, p_bod_id
				 , p_plan_start_yyyymmdd, p_seq, p_yyyymmdd, p_trans_mode, p_last_updated_by FROM @SCP0010 OPEN CUR

			FETCH NEXT FROM CUR INTO @p_division_id, @p_item_id, @p_from_site, @p_to_site, @p_qty, @p_plan_type, @p_bod_id
									, @p_plan_start_yyyymmdd, @p_seq, @p_yyyymmdd, @p_trans_mode, @p_last_updated_by
			WHILE @@FETCH_STATUS = 0
			BEGIN
			
				IF OBJECT_ID('tempdb..#SHIPMENT_EXIST_DATA') IS NOT NULL	
					DROP TABLE #SHIPMENT_EXIST_DATA 
				IF OBJECT_ID('tempdb..#SHIPMENT_EXIST_INFO') IS NOT NULL	
					DROP TABLE #SHIPMENT_EXIST_INFO 
					
				SET @v_mm = SUBSTRING(@p_yyyymmdd,5,2);
				DECLARE @v_yyyyWW				NVARCHAR(10) = '';				
				SELECT @v_yyyyWW = (SELECT SUBSTRING(@p_yyyymmdd,1,4)+ SUBSTRING(@p_yyyymmdd,7,2))

				-- 항차별 LOT SIZE 분배를 위한 처리를 위한 추가
				DECLARE @v_lotsize		NVARCHAR(10) = '';
				DECLARE @ship_days		INT = 0;
				DECLARE @ship_count     INT = 0;			
				DECLARE @v_a INT = 1; --나머지
				DECLARE @v_c INT = 1; --몫
				DECLARE @v_sum NVARCHAR(20) = '0';
				DECLARE @v_na NVARCHAR(20) = '0'; --나머지
				DECLARE @v_mo NVARCHAR(20) = '0'; --몫
				DECLARE @count INT = 0;
			
			    -- 주차 정보 조회
				SELECT DIVISION_ID 
						,BOD_ID
						,FROM_SITE
						,TO_SITE 
						,SHIP_LT_TOTAL
						,DAYOFWEEK AS DAYOFWEEK_NM
						,CASE WHEN DAYOFWEEK = 'days_mon' THEN '2'  --'MON'
							  WHEN DAYOFWEEK = 'days_tue' THEN '3'  --'TUE'
							  WHEN DAYOFWEEK = 'days_wed' THEN '4'  --'WED'
							  WHEN DAYOFWEEK = 'days_thu' THEN '5'  --'THU'
							  WHEN DAYOFWEEK = 'days_fri' THEN '6'  --'FRI'
							  WHEN DAYOFWEEK = 'days_sat' THEN '7'  --'SAT'
							  WHEN DAYOFWEEK = 'days_sun' THEN '1'  --'SUN'
						ELSE ''END AS DAYOFWEEK_CD
						,EXIST_YN
						,TRANSPORT_MODE
						,'' AS REMARK --lotsize가 입력 수량보다 클때 분배요일 재지정
				  INTO #SHIPMENT_EXIST_DATA
				  FROM [DBO].[SCP_MST_BOD_N_V] WITH(NOLOCK)
						UNPIVOT (EXIST_YN FOR DAYOFWEEK 
										IN (DAYS_MON,DAYS_TUE,DAYS_WED,DAYS_THU,DAYS_FRI,DAYS_SAT,DAYS_SUN)
								) AS UNPVT
				 WHERE DIVISION_ID = @p_division_id
				   AND   BOD_ID      = @p_bod_id				
				
				SELECT A.*
				     , B. CALENDAR_MONTH
				  INTO #SHIPMENT_EXIST_INFO
				  FROM #SHIPMENT_EXIST_DATA A
				 INNER JOIN (SELECT * 
				               FROM [dbo].[scm_sys_calendar_m]
							  WHERE ISO_YYYYWW = @v_yyyyWW) B ON A.DAYOFWEEK_CD = B.DAYOFWEEK_NO 				   
				
				-- 분배횟수
				SELECT @ship_count = COUNT(*)--CASE WHEN COUNT(Y.EXIST_YN) = 0 THEN 1 ELSE COUNT(Y.EXIST_YN) END--@shipp_days = COUNT(Y.EXIST_YN)
				  FROM (SELECT X.EXIST_YN
							  ,X.DAYOFWEEK_CD
							  ,X.SHIP_LT_TOTAL
							  ,CASE WHEN CONVERT(INT, X.DAYOFWEEK_CD) <= (X.SHIP_LT_TOTAL % 7) THEN (7 + CONVERT(INT, X.DAYOFWEEK_CD)) - (X.SHIP_LT_TOTAL % 7)
							        ELSE CONVERT(INT, X.DAYOFWEEK_CD) - (X.SHIP_LT_TOTAL % 7) END LT_WEEK
							  ,K.BASIS_YYYYMMDD
							  ,K.CALENDAR_MONTH							
						  FROM #SHIPMENT_EXIST_INFO X
						 INNER JOIN (SELECT * FROM [dbo].[scm_sys_calendar_m]
							             WHERE ISO_YYYYWW = @v_yyyyWW) K 
							          ON X.DAYOFWEEK_CD = K.DAYOFWEEK_NO
					    ) Y
				  WHERE Y.EXIST_YN = 'Y' AND Y.CALENDAR_MONTH = @v_mm               
	               
			  -- 출하 Lot Size
				SELECT @v_lotsize = LOT_SIZE 
				  FROM SCP_MST_SHIPMENT_LOT_SIZE WITH (NOLOCK)
				 WHERE DIVISION_ID = @p_division_id
				   AND ITEM_ID     = @p_item_id
				   AND FROM_SITE   = @p_from_site
				   AND TO_SITE     = @p_to_site
				   AND TRANSPORT_MODE = @p_trans_mode
				   AND VALID_YN    = 'Y'
				    
				IF @v_lotsize = 0
				BEGIN
					SET @v_lotsize = 1;
				END		

				SET @ship_days = CASE WHEN @ship_count = 0 THEN 1 ELSE @ship_count END

				-- 항차분배 계산
				SET @v_a = CASE WHEN @p_qty % (@v_lotsize*@ship_days) = 0 THEN 0 ELSE @p_qty % (@v_lotsize*@ship_days) END --나머지
				
				--입력수량보다 @v_a 같은 경우 (몫이 lotsize보다 작을수없다.)
				IF @v_a = @p_qty
					BEGIN
						SET @v_a = CASE WHEN @p_qty < CAST(@v_lotsize AS INT) THEN 0 ELSE (@p_qty % CAST(@v_lotsize AS INT)) END
						SET @v_c = CASE WHEN @p_qty < CAST(@v_lotsize AS INT) OR @ship_days = 1  THEN @p_qty ELSE (@p_qty - @v_a) / (@p_qty / CAST(@v_lotsize AS INT)) END
						SET @ship_days = CASE WHEN @p_qty < CAST(@v_lotsize AS INT) THEN 1 ELSE @p_qty / CAST(@v_lotsize AS INT) END
						DECLARE @ROW_CNT INT; 
						DECLARE @ALL_CNT INT;
						SET @ROW_CNT = 2;
						SET @ALL_CNT = 0;
						
						WHILE 7 > @count
						BEGIN
							
							SET @count = @count + 1;
		
							UPDATE #SHIPMENT_EXIST_INFO 
							   SET REMARK = 'Y'
							 WHERE DAYOFWEEK_CD = @ROW_CNT
							   AND EXIST_YN = 'Y'							
							   AND CALENDAR_MONTH = @v_mm
							   
						    SET @ROW_CNT = @ROW_CNT + 1;
						    
						    IF @ROW_CNT = 7
						    BEGIN
							   SET @ROW_CNT  = 1
							END
							
							SELECT @ALL_CNT = COUNT(*) FROM #SHIPMENT_EXIST_INFO WHERE REMARK = 'Y';
							
							IF @ALL_CNT = @ship_days
							BEGIN								
								UPDATE #SHIPMENT_EXIST_INFO 
								   SET REMARK = 'N'
								 WHERE REMARK = ''	
								
								BREAK;
							END								
						END
					END
				ELSE
					BEGIN
						SET @v_c = CASE WHEN @v_a = 0 THEN @p_qty / @ship_days ELSE (@p_qty-@v_a)/ @ship_days END
					END				
				
				SET @v_sum = @v_a + @v_c;
				SET @v_na  = @v_a;
				SET @v_mo  = @v_c;

				BEGIN
					SET @mEXEC = '';
					SET @mEXEC = @mEXEC+'INSERT INTO #LAST_INFO_TABLE '+CHAR(10);
					SET @mEXEC = @mEXEC+'SELECT (CASE WHEN Y.TRANSPORT_MODE = ''TRK'' THEN Y.DAYOFWEEK_CD ELSE Y.LT_WEEK END) AS LT_WEEK '+CHAR(10);
					SET @mEXEC = @mEXEC+'	   ,Y.EXIST_YN '+CHAR(10);
					SET @mEXEC = @mEXEC+'	   ,BASIS_YYYYMMDD '+CHAR(10);
					IF @ship_count = 1
						BEGIN
							SET @mEXEC = @mEXEC+'	   ,CASE WHEN DAYOFWEEK_CD = 2 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
						    SET @mEXEC = @mEXEC+'	   	 WHEN DAYOFWEEK_CD = 3 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
						    SET @mEXEC = @mEXEC+'     		 WHEN DAYOFWEEK_CD = 4 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
						    SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 5 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
						    SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 6 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
						    SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 7 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
						    SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 1 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
						    SET @mEXEC = @mEXEC+'	    ELSE 0 END QTY '+CHAR(10);
						END
					ELSE IF @ship_count = 0
						BEGIN
							SET @mEXEC = @mEXEC+'	   ,CASE WHEN DAYOFWEEK_CD = 2 THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
							SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 3 THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
							SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 4 THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
							SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 5 THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
							SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 6 THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
							SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 7 THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
							SET @mEXEC = @mEXEC+'	   	     WHEN DAYOFWEEK_CD = 1 THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE 0 END ELSE 0 END '+CHAR(10);
							SET @mEXEC = @mEXEC+'	   	ELSE 0 END QTY '+CHAR(10);
						END
					ELSE
						BEGIN
							--lotsize 가 입력 수량보다 큰 경우 Remark = 'Y' 로 분배
							IF @ship_count <> @ship_days
								BEGIN
									SET @mEXEC = @mEXEC+'	   ,CASE WHEN DAYOFWEEK_CD = 2 THEN CASE WHEN REMARK = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE '+@v_sum+' END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 3 THEN CASE WHEN REMARK = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 4 THEN CASE WHEN REMARK = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 5 THEN CASE WHEN REMARK = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 6 THEN CASE WHEN REMARK = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 7 THEN CASE WHEN REMARK = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 1 THEN CASE WHEN REMARK = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);					
									SET @mEXEC = @mEXEC+'	    ELSE 0 END QTY '+CHAR(10);
								END
							ELSE
								BEGIN
									SET @mEXEC = @mEXEC+'	   ,CASE WHEN DAYOFWEEK_CD = 2 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE '+@v_sum+' END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 3 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 4 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 5 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 6 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 7 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);
									SET @mEXEC = @mEXEC+'	  		 WHEN DAYOFWEEK_CD = 1 THEN CASE WHEN EXIST_YN = ''Y'' THEN CASE WHEN Y.CALENDAR_MONTH = '+@v_mm+' THEN CASE WHEN SEQ = 1 THEN '+@v_sum+' ELSE '+@v_mo+' END ELSE 0 END ELSE 0 END '+CHAR(10);					
									SET @mEXEC = @mEXEC+'	    ELSE 0 END QTY '+CHAR(10);
								END							
						END			  
					SET @mEXEC = @mEXEC+'	   ,DIVISION_ID '+CHAR(10);
					SET @mEXEC = @mEXEC+'	   ,BOD_ID '+CHAR(10);
					SET @mEXEC = @mEXEC+'	   ,ITEM_ID '+CHAR(10);
					SET @mEXEC = @mEXEC+'	   ,PLAN_TYPE '+CHAR(10);
					SET @mEXEC = @mEXEC+'	   ,PLAN_START_YYYYMMDD '+CHAR(10);
				    SET @mEXEC = @mEXEC+'  FROM (SELECT X.EXIST_YN '+CHAR(10);
			  		SET @mEXEC = @mEXEC+'             ,X.REMARK '+CHAR(10);
				    SET @mEXEC = @mEXEC+'             ,X.DAYOFWEEK_CD '+CHAR(10);
			  		SET @mEXEC = @mEXEC+'             ,X.SHIP_LT_TOTAL '+CHAR(10);
			  		SET @mEXEC = @mEXEC+'             ,CASE WHEN CONVERT(INT, X.DAYOFWEEK_CD) <= (X.SHIP_LT_TOTAL % 7) THEN (7 + CONVERT(INT, X.DAYOFWEEK_CD)) - (X.SHIP_LT_TOTAL % 7) '+CHAR(10);
			   		SET @mEXEC = @mEXEC+'                     ELSE CONVERT(INT, X.DAYOFWEEK_CD) - (X.SHIP_LT_TOTAL % 7) END LT_WEEK '+CHAR(10);
					SET @mEXEC = @mEXEC+'             ,X.TRANSPORT_MODE '+CHAR(10);
					SET @mEXEC = @mEXEC+'             ,X.DIVISION_ID '+CHAR(10);
					SET @mEXEC = @mEXEC+'             ,X.BOD_ID '+CHAR(10);
					SET @mEXEC = @mEXEC+'             ,X.FROM_SITE '+CHAR(10);
					SET @mEXEC = @mEXEC+'             ,X.TO_SITE '+CHAR(10);			  
			  		SET @mEXEC = @mEXEC+'             ,K.BASIS_YYYYMMDD '+CHAR(10);
			  		SET @mEXEC = @mEXEC+'             ,K.CALENDAR_MONTH '+CHAR(10);
					SET @mEXEC = @mEXEC+'             ,'''+@p_item_id+''' ITEM_ID '+CHAR(10);
					SET @mEXEC = @mEXEC+'             ,'''+@p_plan_type+''' PLAN_TYPE '+CHAR(10);
					SET @mEXEC = @mEXEC+'             ,'''+@p_plan_start_yyyymmdd+''' PLAN_START_YYYYMMDD '+CHAR(10);
			  		SET @mEXEC = @mEXEC+'             ,ROW_NUMBER() OVER(PARTITION BY X.CALENDAR_MONTH ORDER BY  (SELECT 1)) SEQ '+CHAR(10);
					SET @mEXEC = @mEXEC+'		   FROM #SHIPMENT_EXIST_INFO X '+CHAR(10);
					SET @mEXEC = @mEXEC+'         INNER JOIN (SELECT * FROM [dbo].[scm_sys_calendar_m] '+CHAR(10);
					SET @mEXEC = @mEXEC+'                           WHERE ISO_YYYYWW = '''+@v_yyyyWW+''' ) K  ON X.DAYOFWEEK_CD = K.DAYOFWEEK_NO '+CHAR(10);
					SET @mEXEC = @mEXEC+'         WHERE X.CALENDAR_MONTH = '''+@v_mm+''' '+CHAR(10);
					SET @mEXEC = @mEXEC+'  ) Y '+CHAR(10);
				--ORDER BY Y.LT_WEEK ;    

				EXEC (@mEXEC);
				END
				
			    UPDATE A
				   SET A.QTY = B.QTY
				   	 , A.LAST_UPDATE_DATE = CASE WHEN @v_creation_date IS NULL THEN GETDATE() ELSE @v_creation_date END
				     , A.LAST_UPDATED_BY = @p_last_updated_by			   
				  FROM SCP_ANL_SHIPMENT_PLAN_SEMI A, #LAST_INFO_TABLE B
				 WHERE 1=1
				   AND A.YYYYMMDD  = B.BASIS_YYYYMMDD 
				   AND A.DIVISION_ID = B.DIVISION_ID 
				   AND A.BOD_ID = B.BOD_ID 
				   AND A.PLAN_TYPE = B.PLAN_TYPE
				   AND A.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD
				   AND A.ITEM_ID = B.ITEM_ID 
				   AND A.MEASURE = 'SHIP_PLAN_AMEND'

				--  FIX수량 UPDATE				
				UPDATE A
				SET A.qty				= B.QTY
					,A.last_updated_by	= @p_last_updated_by
					,A.last_update_date	= CASE WHEN @v_creation_date IS NULL THEN GETDATE() ELSE @v_creation_date END
				FROM SCP_ANL_SHIPMENT_PLAN_FIX A, #LAST_INFO_TABLE B
				WHERE A.division_id				= B.DIVISION_ID
				and A.ITEM_ID					= B.ITEM_ID
				and A.BOD_ID					= B.BOD_ID
				and A.yyyymmdd					= B.BASIS_YYYYMMDD

			-- 5. FIX이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET] @SCP0010

			-- 6. 이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET] @SCP0010


			 	FETCH NEXT FROM CUR INTO @p_division_id, @p_item_id, @p_from_site, @p_to_site, @p_qty, @p_plan_type, @p_bod_id
									, @p_plan_start_yyyymmdd, @p_seq, @p_yyyymmdd, @p_trans_mode, @p_last_updated_by
			END
			CLOSE CUR
			DEALLOCATE CUR		
			
		COMMIT;	
			
		END	

		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';   
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS err_message ;

		END;
	END CATCH;

	IF OBJECT_ID('tempdb..#TblDynamic_SCP0010') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0010
	IF OBJECT_ID('tempdb..#LAST_INFO_TABLE') IS NOT NULL	
		DROP TABLE #LAST_INFO_TABLE 
END;
