

CREATE PROCEDURE [dbo].[PR_SCP_PLN_ASSEMBLY_YIELD_AVG]
( 
	 @p_division_id         NVARCHAR(30) = 'EE'
) 
 AS
/*
 * Program ID   : PR_SCP_PLN_ASSEMBLY_YIELD_AVG
 * Description  : SCP_MST_TACT_TIME_EXCEPT 조립 전,후공정 수율 입력
 * OutTable     :
 * Execute      :   EXEC PR_SCP_PLN_ASSEMBLY_YIELD_AVG @p_division_id ='ALL'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.03.17   LWY           Initial Release  PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : SCP_MST_TACT_TIME_EXCEPT 조립 전,전극 후공정 수율 입력 신규.
 * 2022.04.25   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division 추가
 * 2023.03.30	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2025.08.01   HRK			   PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 */
 
 /* Process-------------------------------------------------------------------------------
1. PR_SCP_MST_TACT_TIME_EXCEPT_COPY_FROM_FP 
  - 정상 OPERATION_ID 정보를 월별로 생성

2. PR_SCP_PLN_ASSEMBLY_YIELD_AVG  // 조립 전, 전극 후공정
  - OPERATION_ID IN ('Z_A00T', 'Z_E00T'), LINE_ID <> '-'  인 정보 생성
   
3. PR_SCP_PLN_ELEC_YIELD_AVG      // 전극
  - OPERATION_ID IN ('Z_A00T', 'Z_E00T'), LINE_ID = '-' 인 정보는 PLAN 수행 시 자동 생성
 -----------------------------------------------------------------------------------------*/
 
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP_BATCH'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_ASSEMBLY_YIELD_AVG';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_MST_TACT_TIME_EXCEPT'; 
    DECLARE @d_event_date   DATETIME;

	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] Cell 완성 공정 하드 코딩 변경
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell 완성 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_CELL_FINAL_OPERATION') IS NOT NULL DROP TABLE #SCP_CELL_FINAL_OPERATION;
	SELECT SEGMENT1 AS OPERATION_ID
	  INTO #SCP_CELL_FINAL_OPERATION
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'	 -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- Final Operation
	------------------------------------------------------------------------------------------------------------------

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_MST_TACT_TIME_EXCEPT INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    
    BEGIN TRY
      BEGIN

		--SCP 52주 계획
		DECLARE @v_scp_start_date   nvarchar(8);
		DECLARE @v_scp_end_date   nvarchar(8);

		set @v_scp_start_date = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);

	    -- Plan End Date까지 생성
	    SELECT @v_scp_end_date = ISNULL(MAX(p.horizon_end_date)
                                      , CONVERT(varchar, convert(varchar, DATEADD( DD, 51*7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112), 112)
                                       )
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  1=1
        AND    p.plan_cycle  = 'WEEKLY'
        AND    p.plan_name   = @v_scp_start_date;

		--(
		--SELECT TOP 1 MAX(PLAN_START_YYYYMMDD) AS PLAN_START_YYYYMMDD
		--FROM SCP_PLAN_VERSION_V WITH(NOLOCK) 
		--WHERE DIVISION_ID='40'
		--GROUP BY PLAN_START_YYYYMMDD
		--ORDER BY PLAN_START_YYYYMMDD DESC
		--)

		--set @v_scp_end_date = CONVERT(varchar, convert(varchar, DATEADD( WEEK, 52, GETDATE()), 112), 112); --SCP 52주 계획
		

		--select @v_scp_start_date,  @v_scp_end_date;

		-- 2023.03.30 HM JV 가상 사업부 추가 대응
        IF OBJECT_ID('tempdb..#tmp_NON_ELEC_DIVISION') IS NOT NULL
        DROP TABLE #tmp_NON_ELEC_DIVISION;	

		SELECT DM.DIVISION_ID
		  INTO #tmp_NON_ELEC_DIVISION
		  FROM SCM_MST_DIVISION DM WITH(NOLOCK)
		 WHERE DM.ATTRIBUTE3 != 'EE'
		   AND DM.VALID_YN	  = 'Y'
		
		/*------------------------------------------------------------------------------------------------------------- 
		 **** 기존데이타 삭제 *****************************************************************************************
		--------------------------------------------------------------------------------------------------------------*/

		DELETE FROM SCP_MST_TACT_TIME_EXCEPT
		WHERE OPERATION_ID IN ('Z_A00T','Z_E00T')
		-- 2023.03.30 HM JV AND DIVISION_ID    IN ('40', '81', '82', '81_UC') -- @p_division_id  -- 전체 Division 동시 생성-- 20220425 PJ20216891 : GM JV 가상 Division 추가
		AND DIVISION_ID IN (SELECT DIVISION_ID FROM #tmp_NON_ELEC_DIVISION) -- 2023.03.30 HM JV 가상 사업부 추가 대응
		AND TACT_TIME_END_DATE >= @v_scp_start_date  --plan_start_yyyymmdd
		AND LINE_ID             <> '-'
		;
        
		
		/*------------------------------------------------------------------------------------------------------------- 
		 **** 조립 전/후공 데이타 생성 Logic Start ********************************************************************
		--------------------------------------------------------------------------------------------------------------*/
		IF OBJECT_ID('tempdb..#TMP_VER') IS NOT NULL
			DROP TABLE #TMP_VER
		;
		IF OBJECT_ID('tempdb..#TMP_TACT_TIME_EXCEPT') IS NOT NULL
			DROP TABLE #TMP_TACT_TIME_EXCEPT
		;
		IF OBJECT_ID('tempdb..#TMP_BOD') IS NOT NULL
			DROP TABLE #TMP_BOD
		;
		-- 전공정
		IF OBJECT_ID('tempdb..#TMP_FORWARD_YIELD') IS NOT NULL
			DROP TABLE #TMP_FORWARD_YIELD
		;
		-- 후공정
		IF OBJECT_ID('tempdb..#TMP_BACKWARD_YIELD') IS NOT NULL
			DROP TABLE #TMP_BACKWARD_YIELD
		;
		-- 전공정 + 후공정
		IF OBJECT_ID('tempdb..#TMP_TOTAL_YIELD') IS NOT NULL
			DROP TABLE #TMP_TOTAL_YIELD
		;
		IF OBJECT_ID('tempdb..#TMP_CARENDER') IS NOT NULL
			DROP TABLE #TMP_CARENDER
		;
		IF OBJECT_ID('tempdb..#TMP_ACCUMULATE_YIELD') IS NOT NULL
			DROP TABLE #TMP_ACCUMULATE_YIELD
		;		
		
		
		CREATE TABLE #TMP_ACCUMULATE_YIELD
		(
			  DIVISION_ID				NVARCHAR(10)
			, PLANT_SITE_ID				NVARCHAR(30)
			, ITEM_ID					NVARCHAR(30)
			, OPERATION_ID				NVARCHAR(200)
			, LINE_ID   				NVARCHAR(30)
			, MONTH 					NVARCHAR(6)
			, YIELD 					NUMERIC(18, 6)
		)
		
		
		
		
		--------------------------------------------
		-- DIVISION  별 최신 VERSION 찾기
		--------------------------------------------
		SELECT A.DIVISION_ID, A.version_id
		INTO #TMP_VER
		FROM SCP_PLAN_VERSION_V A with(nolock)
		WHERE A.PLAN_ID = (
							SELECT MAX(PLAN_ID) 
							  FROM SCP_PLAN_VERSION_V with(nolock)
							 WHERE PLAN_TYPE = 'PR'
							 AND CONFIRM_FLAG = 'Y'
							 AND UI_DISPLAY_YN = 'Y'
							 AND ACTIVE_FLAG = 'Y'
						)
		AND PLAN_TYPE = 'PR'
		AND CONFIRM_FLAG = 'Y'
		AND UI_DISPLAY_YN = 'Y'
		AND ACTIVE_FLAG = 'Y'
		AND DIVISION_ID IN (SELECT DIVISION_ID FROM #tmp_NON_ELEC_DIVISION) -- 2023.03.30 HM JV 가상 사업부 추가 대응
	    -- 2023.03.30 HM JVAND DIVISION_ID IN ('40','81','82', '81_UC') -- 20220425 PJ20216891 : GM JV 가상 Division 추가
		ORDER BY DIVISION_ID
		;
		
		
		------------------------------------------------------------------------------
		-- * 조립 전공정 수율 *
		------------------------------------------------------------------------------
		
		--1. scp_mst_tact_time_except 대상 조회
		----------------------------------------
		SELECT DISTINCT 
			   A.DIVISION_ID
			  ,A.ITEM_ID
			  ,A.PLANT_SITE_ID
			  ,B.PLANT_ID
			  ,A.OPERATION_ID
			  ,A.LINE_ID
		INTO #TMP_TACT_TIME_EXCEPT
		FROM SCP_MST_TACT_TIME_EXCEPT A WITH(NOLOCK)
		JOIN SCM_MST_SITE B WITH(NOLOCK)
		ON   A.DIVISION_ID   = B.DIVISION_ID
		AND  A.PLANT_SITE_ID = B.SCM_SITE_ID
		AND  B.OPERATION_GROUP IN ('A','E')

		WHERE 1 = 1
		AND A.OPERATION_ID NOT IN ('Z_A00T', 'Z_E00T')
		--AND A.OPERATION_ID <> 'E2000' -- 전극
		-- [PJ20257329] 변경전 AND A.OPERATION_ID IN ('A3000', 'A9000')
		AND A.OPERATION_ID IN (SELECT OPERATION_ID  FROM #SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경

		AND A.USE_YN = 'Y'
		AND A.TACT_TIME_START_DATE BETWEEN @V_SCP_START_DATE AND @V_SCP_END_DATE   --LIKE '202202%'
		AND A.DIVISION_ID IN (SELECT DIVISION_ID FROM #tmp_NON_ELEC_DIVISION) -- 2023.03.30 HM JV 가상 사업부 추가 대응
		-- 2023.03.30 HM JV AND A.DIVISION_ID IN ('40','81','82','81_UC') -- 20220425 PJ20216891 : GM JV 가상 Division 추가
		;

		--SELECT * FROM #TMP_TACT_TIME_EXCEPT;


		--2. BOD
		----------------------------------------
		select --*
			 A.DIVISION_ID	 
			,B.PLANT_SITE_ID
			,B.OPERATION_ID
			,A.PLANT_ID
			,B.ITEM_ID      --A.MODEL_ID
			,A.CHILD_ITEM_ID
			,C.FLOW_ID
			,B.LINE_ID
			----,MAX(C.FLOW_ID) AS FLOW_ID
		INTO #TMP_BOD
		from SCM_MST_MODEL_ONE_LEVEL_BOM_V A WITH(NOLOCK)
		JOIN #TMP_TACT_TIME_EXCEPT B
		ON 1 = 1
		AND A.DIVISION_ID = B.DIVISION_ID
		AND A.model_id = B.ITEM_ID
		AND A.OPERATION_GROUP IN ('A') --('A','E')
		AND A.PLANT_ID = B.PLANT_ID
			JOIN (
					SELECT DIVISION_ID, ITEM_ID, MAX(ISNULL(SCP_FLOW_ID, FLOW_ID)) FLOW_ID
					FROM SCM_MST_ITEM_SN B WITH(NOLOCK)
					GROUP BY DIVISION_ID, ITEM_ID
				  )  C
		ON 1 = 1
		AND A.PLANT_ID = B.PLANT_ID
		AND A.DIVISION_ID   = C.DIVISION_ID
		AND A.CHILD_ITEM_ID = C.ITEM_ID
		;

		--SELECT * FROM #TMP_BOD
		--ORDER BY DIVISION_ID, LINE_ID, PLANT_ID, FLOW_ID DESC;


		--3. 공정별 YIELD
		----------------------------------------
		SELECT 
			 B.VERSION_ID
			,A.DIVISION_ID
			,A.PLANT_SITE_ID	
			,A.ITEM_ID	
			--,A.OPERATION_ID
			,'Z_A00T' AS OPERATION_ID
			,B.LINE_ID
			,A.FLOW_ID
			,B.MONTH
			,CASE WHEN B.YIELD = 0 THEN 1 ELSE (B.YIELD) END YIELD

		INTO #TMP_FORWARD_YIELD
		FROM #TMP_BOD A WITH(NOLOCK)
		  JOIN (
					SELECT A.*
					FROM SCM_YIELD_VER_H_SN A WITH(NOLOCK)
					JOIN #TMP_VER B
					ON A.DIVISION_ID = B.DIVISION_ID
					WHERE 1 = 1
					AND A.DIVISION_ID IN (SELECT DIVISION_ID FROM #tmp_NON_ELEC_DIVISION) -- 2023.03.30 HM JV 가상 사업부 추가 대응
					-- 2023.03.30 HM JV AND A.DIVISION_ID IN ('40','81','82','81_UC') -- 20220425 PJ20216891 : GM JV 가상 Division 추가
					AND A.VERSION_ID = B.VERSION_ID
					--AND A.MONTH LIKE '202202%'
					AND A.MONTH BETWEEN SUBSTRING(@V_SCP_START_DATE,1,6) AND SUBSTRING(@V_SCP_END_DATE,1,6)
				  ) B
		ON 1 = 1
		AND A.DIVISION_ID   = B.DIVISION_ID
		AND A.PLANT_ID      = B.PLANT_ID
		AND A.CHILD_ITEM_ID = B.ITEM_ID
		AND A.LINE_ID       = B.LINE_ID
		;

		--SELECT * FROM #TMP_FORWARD_YIELD
		--ORDER BY DIVISION_ID, PLANT_SITE_ID, LINE_ID, ITEM_ID, FLOW_ID DESC;




		--4. #TMP_ACCUMULATE_YIELD  전공정 Insert
		----------------------------------------
		INSERT INTO #TMP_ACCUMULATE_YIELD
		SELECT 
				T.DIVISION_ID
			   ,T.PLANT_SITE_ID
			   ,T.ITEM_ID
			   ,T.OPERATION_ID
			   ,T.LINE_ID
			   ,T.MONTH
			   ,CONVERT(NUMERIC(18, 6), ROUND(EXP(SUM(LOG(T.AVG_YIELD))), 3)) AS YIELD
		 FROM (
				SELECT 
					   T.DIVISION_ID
					  ,T.PLANT_SITE_ID
					  ,T.ITEM_ID
					  ,T.OPERATION_ID
					  --,T.FLOW_ID
					  ,T.LINE_ID
					  ,T.MONTH
					  ,AVG(T.YIELD) AS AVG_YIELD
				  FROM #TMP_FORWARD_YIELD T
				 WHERE 1 = 1
				 GROUP BY T.DIVISION_ID, T.PLANT_SITE_ID, T.ITEM_ID, T.OPERATION_ID, T.FLOW_ID, T.LINE_ID, T.MONTH
				 having AVG(T.YIELD) > 0 -- 20260610 긴급반영
			  ) T
		WHERE 1 = 1
		GROUP BY T.DIVISION_ID, T.PLANT_SITE_ID, T.ITEM_ID, T.OPERATION_ID, T.LINE_ID, T.MONTH
		ORDER BY T.DIVISION_ID, T.PLANT_SITE_ID, T.ITEM_ID, T.OPERATION_ID, T.LINE_ID, T.MONTH
		;
		
		
		------------------------------------------------------------------------------
		-- * 조립 후공정 수율 *
		------------------------------------------------------------------------------
		
		--1. 대상조회
		----------------------------------------

		SELECT   A.VERSION_ID
				,A.DIVISION_ID
				,M.SCM_SITE_ID AS PLANT_SITE_ID	    
				,A.ITEM_ID
				,A.OPERATION_ID
				--,'Z_E00T' AS OPERATION_ID
				,A.LINE_ID
				,A.MONTH
				,case when A.YIELD = 0 then 1 else (A.YIELD) end YIELD
		INTO #TMP_BACKWARD_YIELD
		FROM SCM_YIELD_VER_H_SN A with(nolock)
			JOIN #TMP_VER B
			ON A.DIVISION_ID = B.DIVISION_ID
			
			JOIN SCM_MST_SITE M WITH(NOLOCK)
			ON  A.DIVISION_ID  = M.DIVISION_ID
			AND A.PLANT_ID = M.PLANT_ID
			AND M.OPERATION_GROUP IN ('E')

		WHERE 1 = 1
		-- 2023.03.30 HM JV AND A.DIVISION_ID IN ('40','81','82','81_UC') -- 20220425 PJ20216891 : GM JV 가상 Division 추가
		AND A.DIVISION_ID IN (SELECT DIVISION_ID FROM #tmp_NON_ELEC_DIVISION) -- 2023.03.30 HM JV 가상 사업부 추가 대응
		AND A.VERSION_ID = B.VERSION_ID
		AND A.OPERATION_ID > 'E2000'
		AND A.OPERATION_ID <= 'E5000'
		AND A.MONTH BETWEEN SUBSTRING(@v_scp_start_date,1,6) AND SUBSTRING(@v_scp_end_date,1,6)
		;


		--2. #TMP_ACCUMULATE_YIELD  후공정 Insert
		----------------------------------------
		INSERT INTO #TMP_ACCUMULATE_YIELD
		SELECT 
				T.DIVISION_ID
			   ,T.PLANT_SITE_ID
			   ,T.ITEM_ID			   
			   ,'Z_E00T' AS OPERATION_ID
			   ,T.LINE_ID
			   ,T.MONTH
			   ,convert(numeric(18, 6), ROUND(EXP(SUM(LOG(T.AVG_YIELD))), 3)) AS YIELD

		 FROM (
				SELECT 
					   T.DIVISION_ID
					  ,T.PLANT_SITE_ID
					  ,T.ITEM_ID
					  ,T.OPERATION_ID
					  --,T.flow_id
					  ,T.LINE_ID
					  ,T.MONTH			  
					  ,AVG(T.YIELD) as AVG_YIELD
				  FROM #TMP_BACKWARD_YIELD T
				 WHERE 1 = 1
				 group by T.DIVISION_ID, T.PLANT_SITE_ID, T.ITEM_ID, T.OPERATION_ID, T.LINE_ID, T.MONTH
			  ) T
		WHERE 1 = 1
		GROUP BY T.DIVISION_ID, T.PLANT_SITE_ID, T.ITEM_ID, T.LINE_ID, T.MONTH
		
		;

		--SELECT * FROM #TMP_ACCUMULATE_YIELD T
		--ORDER BY T.DIVISION_ID, T.PLANT_SITE_ID, T.ITEM_ID, T.LINE_ID, T.MONTH;
		
		
		------------------------------------------------------------------------------
		-- * SCP_MST_TACT_TIME_EXCEPT INSERT (전 + 후공정) *
		------------------------------------------------------------------------------

		--1. 52 Weekly
		----------------------------------------
		SELECT TOP 52 BASIS_YYYYMM, BASIS_YYYYMMDD 
		INTO #TMP_CARENDER
		  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		WHERE BASIS_YYYYMMDD >= GETDATE()-7 --'20220101'
		  AND DAYOFWEEK = 'MON'
		ORDER BY BASIS_YYYYMMDD
		;


		--2. 52 Weekly
		----------------------------------------
		INSERT INTO SCP_MST_TACT_TIME_EXCEPT
		(
			 DIVISION_ID
			,PLANT_SITE_ID
			,ITEM_ID
			,OPERATION_ID
			,LINE_ID
			,TACT_TIME_START_DATE
			,TACT_TIME_END_DATE
			,TACT_TIME
			,YIELD
			,EXCEPT_COMMENT
			,USE_YN
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
		)
		SELECT A.DIVISION_ID
			  ,A.PLANT_SITE_ID
			  ,A.ITEM_ID
			  ,A.OPERATION_ID
			  --,'Z_A00T' AS OPERATION_ID
			  ,A.LINE_ID
			  ,B.BASIS_YYYYMMDD AS TACT_TIME_START_DATE	  
			  ,CONVERT(CHAR(8),DATEADD(DD,6,B.BASIS_YYYYMMDD),112) AS TACT_TIME_END_DATE
			  ,0.0000000001 AS TACT_TIME
			  ,A.YIELD
			  ,'' AS EXCEPT_COMMENT
			  ,'Y' AS USE_YN
			  ,'Elec_SCP' AS CREATED_BY
			  ,GETDATE() AS CREATEION_DATE
			  ,'Elec_SCP' AS LAST_UPDATED_BY
			  ,GETDATE() AS LAST_UPDATE_DATE

		FROM #TMP_ACCUMULATE_YIELD A
		JOIN #TMP_CARENDER B
		ON 1 = 1
		AND A.MONTH = B.BASIS_YYYYMM
		order by
			   A.DIVISION_ID      
			  ,A.PLANT_SITE_ID
			  ,A.ITEM_ID 
			  ,A.OPERATION_ID   
			  ,A.LINE_ID
			  ,B.BASIS_YYYYMMDD
		;
		
		



		IF OBJECT_ID('tempdb..#TMP_VER') IS NOT NULL
			DROP TABLE #TMP_VER
		;
		IF OBJECT_ID('tempdb..#TMP_TACT_TIME_EXCEPT') IS NOT NULL
			DROP TABLE #TMP_TACT_TIME_EXCEPT
		;
		IF OBJECT_ID('tempdb..#TMP_BOD') IS NOT NULL
			DROP TABLE #TMP_BOD
		;
		-- 전공정
		IF OBJECT_ID('tempdb..#TMP_FORWARD_YIELD') IS NOT NULL
			DROP TABLE #TMP_FORWARD_YIELD
		;
		-- 후공정
		IF OBJECT_ID('tempdb..#TMP_BACKWARD_YIELD') IS NOT NULL
			DROP TABLE #TMP_BACKWARD_YIELD
		;
		-- 전공정 + 후공정
		IF OBJECT_ID('tempdb..#TMP_TOTAL_YIELD') IS NOT NULL
			DROP TABLE #TMP_TOTAL_YIELD
		;
		IF OBJECT_ID('tempdb..#TMP_CARENDER') IS NOT NULL
			DROP TABLE #TMP_CARENDER
		;
		IF OBJECT_ID('tempdb..#TMP_ACCUMULATE_YIELD') IS NOT NULL
			DROP TABLE #TMP_ACCUMULATE_YIELD
		;
		
		
		/*------------------------------------------------------------------------------------------------------------- 
		 **** 조립 전/후공 데이타 생성 Logic  End *********************************************************************
		--------------------------------------------------------------------------------------------------------------*/
		
		

        SET @n_log_count = @@ROWCOUNT;
    
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1 


  END;


