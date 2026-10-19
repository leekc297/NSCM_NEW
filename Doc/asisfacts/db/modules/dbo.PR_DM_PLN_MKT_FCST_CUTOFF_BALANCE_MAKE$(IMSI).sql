
/*
 * Program ID   : PR_DM_PLN_MKT_FCST_CUTOFF_BALANCE_MAKE
 * Description  : 
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
 * 2018.05.14   JunHee Jeen / KHSONG   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * -----------------------------------------------------------------------------------------------------------
 * PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW 생성을 제외한 로직만 별도로 추출한 procedure 
 * 
 * 
 * 
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_CUTOFF_BALANCE_MAKE$(IMSI)]

	-- Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(MAX)
   ,@p_plan_id                  NVARCHAR(MAX)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_CUTOFF_BALANCE_MAKE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @max_plan_id                  NVARCHAR(MAX);
    DECLARE @plan_start_yyyymmdd          NVARCHAR(MAX);
    DECLARE @c_division_id                NVARCHAR(MAX);
    DECLARE @c_plan_id                    NVARCHAR(MAX);
    DECLARE @c_plan_start_yyyymmdd        NVARCHAR(MAX);
    DECLARE @c_VERSION_NO				  NVARCHAR(MAX);

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- input division save table
	DECLARE @division TABLE (division_id			NVARCHAR(MAX)
	                       , plan_id				NVARCHAR(MAX)
						   , plan_start_yyyymmdd	NVARCHAR(MAX)
						   )  

	-- input cufoff table
	DECLARE @cutoff	 TABLE (VERSION_NO				NVARCHAR(MAX)  )  

		-- 트랜잭션 (START)
		BEGIN TRANSACTION MKT_FCST_CUTOFF_BALANCE_MAKE;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		

		BEGIN

		IF  @p_division_id IS NOT NULL   -- division_id parameter 값이 존재하는경우
		-------
		  BEGIN
		-------
		    INSERT INTO @division (division_id,plan_id,plan_start_yyyymmdd) VALUES (@p_division_id,'','') 

			IF @p_plan_id IS NULL  -- @p_plan_id 값이 없는경우
			   BEGIN

				  SET @max_plan_id = (SELECT MAX(plan_id) FROM [DBO].[SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)  -- plan_id 추출
				                       WHERE division_id = @p_division_id)
				  
				  SET @plan_start_yyyymmdd = (SELECT MAX(plan_start_yyyymmdd) FROM [DBO].[SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)  -- plan_start_yyyymmdd 추출
				                               WHERE division_id = @p_division_id AND plan_id = @max_plan_id)

                  -- added by ytchoi 180611 한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함.
                  SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 20180618 임시 -14로 설정함

				  UPDATE @division SET plan_id = @max_plan_id,plan_start_yyyymmdd = @plan_start_yyyymmdd  WHERE division_id = @p_division_id  -- plan_id,plan_start_yyyymmdd 업데이트

			   END
			ELSE     -- @p_plan_id 값이 있는경우
			   BEGIN
				  SET @plan_start_yyyymmdd = (SELECT MAX(plan_start_yyyymmdd) FROM [DBO].[SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)  -- plan_start_yyyymmdd 추출
				                               WHERE division_id = @p_division_id AND plan_id = @p_plan_id)
                  -- added by ytchoi 180611 한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함.
                  SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 20180618 임시 -14로 설정함

				  UPDATE @division SET plan_id = @p_plan_id,plan_start_yyyymmdd = @plan_start_yyyymmdd  WHERE division_id = @p_division_id  -- plan_id,plan_start_yyyymmdd 업데이트
			   END

		-------
		  END
		-------
		ELSE
		-------
		  BEGIN   -- division_id parameter 값이 없는경우
		-------
			IF @p_plan_id IS NULL  -- @p_plan_id 값이 없는경우
			   BEGIN
				INSERT @division (DIVISION_ID,plan_id,PLAN_START_YYYYMMDD) 
					SELECT A.DIVISION_ID, A.PLAN_ID, MAX(PLAN_START_YYYYMMDD)
					  FROM [DBO].[SCP_PLN_RTF_ALLOCATION_V] A WITH(NOLOCK)
						  ,(
							SELECT DIVISION_ID,MAX(plan_id) MAX_PLAN_ID
								FROM [DBO].[SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)  
							GROUP BY DIVISION_ID
							) B
					WHERE A.DIVISION_ID = B.DIVISION_ID
					  AND A.PLAN_ID     = B.MAX_PLAN_ID
					GROUP BY A.DIVISION_ID, A.PLAN_ID

			   END
			ELSE     -- @p_plan_id 값이 있는경우
			   BEGIN

				INSERT @division (DIVISION_ID,plan_id,PLAN_START_YYYYMMDD) 
					SELECT A.DIVISION_ID, MAX(A.PLAN_ID), MAX(PLAN_START_YYYYMMDD)
					  FROM [DBO].[SCP_PLN_RTF_ALLOCATION_V] A WITH(NOLOCK)
					WHERE A.PLAN_ID     = @p_plan_id
					GROUP BY A.DIVISION_ID

			   END

		-------
		  END
		-------
			--
			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR1_PLAN')
				BEGIN
					CLOSE CURSOR1_PLAN
					DEALLOCATE CURSOR1_PLAN
				END;

			DECLARE CURSOR1_PLAN CURSOR FAST_FORWARD FOR
			SELECT 	  division_id    
			         ,plan_id
					 ,plan_start_yyyymmdd 
				FROM  @division	ORDER BY division_id

		BEGIN
			OPEN CURSOR1_PLAN;
			FETCH NEXT FROM CURSOR1_PLAN INTO 
									  @c_division_id    
									 ,@c_plan_id  
									 ,@c_plan_start_yyyymmdd  
		END

		----------------------------------------------------------------------------------------
		--①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①① CURSOR1_PLAN DIVISION별 LOOP START
		WHILE @@FETCH_STATUS = 0
		----------------------------------------------------------------------------------------
		BEGIN
		----------------------------------------------------------------------------------------

		---------------------------------------------------------------------------------------- 20180618 KHSONG CUTOFF TABLE BALANCE 값 재계산 로직 추가 START
			delete from @cutoff  -- insert 전 초기화

			INSERT INTO @cutoff  -- 작업대상 cutoff version insert
			SELECT 	  VERSION_NO
				FROM  DM_PLN_MKT_FCST_C WITH(NOLOCK)	
					WHERE 1=1
						and division_id = @c_division_id
						and cutoff_yyyymmdd >= @plan_start_yyyymmdd  -- 당주월요일부터
						and cutoff_type = 'MF_W'
			GROUP BY VERSION_NO
			ORDER BY VERSION_NO

			-- 확인용
			select '@cutoff'
			select * from @cutoff

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR2_CUTOFF')
				BEGIN
					CLOSE CURSOR2_CUTOFF
					DEALLOCATE CURSOR2_CUTOFF
				END;

			DECLARE CURSOR2_CUTOFF CURSOR FAST_FORWARD FOR
			SELECT 	  VERSION_NO	FROM  @cutoff	

		BEGIN
			OPEN CURSOR2_CUTOFF;
			FETCH NEXT FROM CURSOR2_CUTOFF  INTO  @c_VERSION_NO
		END

		----------------------------------------------------------------------------------------
		--③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③ CURSOR2_CUTOFF VERSION_NO별 LOOP START
		WHILE @@FETCH_STATUS = 0
		----------------------------------------------------------------------------------------
		BEGIN
		----------------------------------------------------------------------------------------
		
		IF OBJECT_ID (N'tempdb..#CUTOFF_RAW_TABLE', N'U') IS NOT NULL 
			DROP TABLE #CUTOFF_RAW_TABLE
		IF OBJECT_ID (N'tempdb..#CUTOFF_TEMP', N'U') IS NOT NULL 
			DROP TABLE #CUTOFF_TEMP
		IF OBJECT_ID (N'tempdb..#CUTOFF_MST', N'U') IS NOT NULL 
			DROP TABLE #CUTOFF_MST

		----------------------------------------------------------------- (1)
			SELECT				DISTINCT 
								DIVISION_ID 			,
								VERSION_NO,
								CUTOFF_TYPE,
								CUTOFF_YYYYMMDD,
								PROJECT_CODE 			,
								SCM_SITE_ID 			,
								ITEM_ID 				,
								DOM_EXP 				,
								FCST_TYPE 				,
								INCOTERMS 				,
								PLANT_SITE_ID 			,
								b.BASIS_YYYYMMDD   YYYYMMDD
			INTO  #CUTOFF_MST
			FROM DM_PLN_MKT_FCST_C	 a WITH(NOLOCK)
				, SCM_SYS_CALENDAR_M  b WITH(NOLOCK)
				WHERE		a.DIVISION_ID	= @c_division_id
					AND		b.BASIS_YYYYMMDD BETWEEN @c_plan_start_yyyymmdd  AND CONVERT(CHAR(8), DATEADD(WW, 52, @c_plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
					AND		a.MEASURE		IN ('MKT_FCST','RTF')
					AND		a.VERSION_NO	= @c_VERSION_NO

	
		SELECT		#CUTOFF_MST.*, 
					ISNULL(T1.QTY,0) AS MKT_FCST,
					ISNULL(T2.QTY,0) AS RTF
		INTO #CUTOFF_RAW_TABLE
		FROM		#CUTOFF_MST
		LEFT JOIN 
					( 
					SELECT *
						FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
							WHERE MEASURE		= 'MKT_FCST'
							AND YYYYMMDD		>= @c_plan_start_yyyymmdd
							AND DIVISION_ID		=  @c_division_id
							AND	VERSION_NO		=  @c_VERSION_NO
					) T1
		ON			T1.DIVISION_ID 		 =  #CUTOFF_MST.DIVISION_ID 		
		AND			T1.PROJECT_CODE 	 =  #CUTOFF_MST.PROJECT_CODE 	
		AND			T1.SCM_SITE_ID 		 =  #CUTOFF_MST.SCM_SITE_ID 		
		AND 		T1.ITEM_ID 			 =  #CUTOFF_MST.ITEM_ID 			
		AND 		T1.DOM_EXP 			 =  #CUTOFF_MST.DOM_EXP 			
		AND 		T1.FCST_TYPE 		 =  #CUTOFF_MST.FCST_TYPE 		
		AND 		T1.INCOTERMS 		 =  #CUTOFF_MST.INCOTERMS 		
		AND 		T1.PLANT_SITE_ID 	 =  #CUTOFF_MST.PLANT_SITE_ID 	
		AND 		T1.YYYYMMDD 		 =  #CUTOFF_MST.YYYYMMDD

		LEFT JOIN	(

					SELECT *
						FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
							WHERE MEASURE		= 'RTF'
							AND YYYYMMDD		>= @c_plan_start_yyyymmdd
							AND DIVISION_ID		=  @c_division_id
							AND	VERSION_NO		=  @c_VERSION_NO
					) T2
		ON			#CUTOFF_MST.DIVISION_ID 		=   T2.DIVISION_ID 		
		AND			#CUTOFF_MST.PROJECT_CODE 		=   T2.PROJECT_CODE 	
		AND			#CUTOFF_MST.SCM_SITE_ID 		=   T2.SCM_SITE_ID 		
		AND 		#CUTOFF_MST.ITEM_ID 			=   T2.ITEM_ID 			
		AND 		#CUTOFF_MST.DOM_EXP 			=   T2.DOM_EXP 			
		AND 		#CUTOFF_MST.FCST_TYPE 			=   T2.FCST_TYPE 		
		AND 		#CUTOFF_MST.INCOTERMS 			=   T2.INCOTERMS 		
		AND 		#CUTOFF_MST.PLANT_SITE_ID 		=   T2.PLANT_SITE_ID 	
		AND			#CUTOFF_MST.YYYYMMDD			=   T2.YYYYMMDD			
	--	WHERE ISNULL(T1.QTY,0)				<> ISNULL(T2.QTY,0)  -- 20180524 modify
		;
		
		----------------------------------------------------------------- (1)
		SELECT		DISTINCT
					DIVISION_ID,
					VERSION_NO,
					CUTOFF_TYPE,
					CUTOFF_YYYYMMDD,
					PROJECT_CODE,
					SCM_SITE_ID,
					ITEM_ID,
					DOM_EXP,
					FCST_TYPE,
					INCOTERMS,
					PLANT_SITE_ID,
				-- modified by ytchoi 180611  
				--	@c_plan_start_yyyymmdd AS YYYYMMDD,
					CONVERT(CHAR(8), DATEADD(DD,-1,@c_plan_start_yyyymmdd), 112) AS YYYYMMDD,
					0 AS GAP
		INTO #CUTOFF_TEMP
			FROM #CUTOFF_RAW_TABLE

			DECLARE @CUTOFF_YYYYMMDD AS NVARCHAR(8)
			DECLARE CUTOFF_CUR_TEMP CURSOR FOR
		
			SELECT BASIS_YYYYMMDD
				FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
					WHERE BASIS_YYYYMMDD BETWEEN @c_plan_start_yyyymmdd  
					AND CONVERT(CHAR(8), DATEADD(WW, 52, @c_plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주

			OPEN CUTOFF_CUR_TEMP;

			FETCH NEXT FROM CUTOFF_CUR_TEMP
				INTO @CUTOFF_YYYYMMDD

		--------------------------------------------- 
		--④④④④④④④④④④④④④  CUTOFF_CUR_TEMP START
		--------------------------------------------- 

			---------------------------------- 
			WHILE (@@FETCH_STATUS = 0)
			---------------------------------- 

			BEGIN

				INSERT INTO  #CUTOFF_TEMP
					SELECT
						T1.DIVISION_ID,
						T1.VERSION_NO,
						T1.CUTOFF_TYPE,
						T1.CUTOFF_YYYYMMDD,
						T1.PROJECT_CODE,
						T1.SCM_SITE_ID,
						T1.ITEM_ID,
						T1.DOM_EXP,
						T1.FCST_TYPE,
						T1.INCOTERMS,
						T1.PLANT_SITE_ID,
						@CUTOFF_YYYYMMDD		AS YYYYMMDD,
						ISNULL(GAP,0) + (ISNULL(RTF,0) - ISNULL(MKT_FCST,0)) AS GAP
			
						FROM #CUTOFF_TEMP T1
							LEFT JOIN #CUTOFF_RAW_TABLE T2
							ON			T1.DIVISION_ID 		 =   T2.DIVISION_ID 		
							AND			T1.PROJECT_CODE 	 =   T2.PROJECT_CODE 	
							AND			T1.SCM_SITE_ID 		 =   T2.SCM_SITE_ID 		
							AND 		T1.ITEM_ID 			 =   T2.ITEM_ID 			
							AND 		T1.DOM_EXP 			 =   T2.DOM_EXP 			
							AND 		T1.FCST_TYPE 		 =   T2.FCST_TYPE 		
							AND 		T1.INCOTERMS 		 =   T2.INCOTERMS 		
							AND 		T1.PLANT_SITE_ID 	 =   T2.PLANT_SITE_ID 	
							AND		T2.YYYYMMDD = @CUTOFF_YYYYMMDD
						WHERE	T1.YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD,-1,@CUTOFF_YYYYMMDD), 112)
							AND T1.DIVISION_ID = @c_division_id
							AND T2.DIVISION_ID = @c_division_id

			FETCH NEXT FROM CUTOFF_CUR_TEMP
					INTO @CUTOFF_YYYYMMDD
		
			END;

			CLOSE CUTOFF_CUR_TEMP;
			DEALLOCATE CUTOFF_CUR_TEMP;
		--------------------------------------------- 
		--④④④④④④④④④④④④④  CUR_TEMP CLOSE
		--------------------------------------------- 

		---------------------------------- 초기화 (START)
		DELETE FROM DM_PLN_MKT_FCST_C
			WHERE MEASURE IN  ('BALANCE') 
				AND DIVISION_ID		= @c_division_id
				AND	VERSION_NO		= @c_VERSION_NO
		---------------------------------- 초기화 (END)
					
		---------------------------------- 계산된 BALANCE값 INSERT (START)
		insert into DM_PLN_MKT_FCST_C
					( DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select division_id , VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD, project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms,'BALANCE' measure ,plant_site_id, yyyymmdd, GAP alloc_qty
			,'BALANCE_MAKE',getdate(),'BALANCE_MAKE',getdate(), null,null,null,null,null,null,null,null,null,null
		from  #CUTOFF_TEMP
		WHERE DIVISION_ID = @c_division_id
		---------------------------------- 계산된 BALANCE값 INSERT (END)
;
			FETCH NEXT FROM CURSOR2_CUTOFF INTO  @c_VERSION_NO    

		END

		CLOSE CURSOR2_CUTOFF;  
		DEALLOCATE CURSOR2_CUTOFF;
		----------------------------------------------------------------------------------------
		--③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③ CURSOR2_CUTOFF VERSION_NO별 LOOP END
		----------------------------------------------------------------------------------------

		---------------------------------------------------------------------------------------- 20180618 KHSONG CUTOFF TABLE BALANCE 값 재계산 로직 추가 END
		END
		
			FETCH NEXT FROM CURSOR1_PLAN INTO 
									  @c_division_id    
									 ,@c_plan_id  
									 ,@c_plan_start_yyyymmdd  

		---------------------------------------------------------------------------------------- 
		END
		--①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①① CURSOR1_PLAN DIVISION별 LOOP END
		CLOSE CURSOR1_PLAN;  
        DEALLOCATE CURSOR1_PLAN;


  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION MKT_FCST_CUTOFF_BALANCE_MAKE;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
