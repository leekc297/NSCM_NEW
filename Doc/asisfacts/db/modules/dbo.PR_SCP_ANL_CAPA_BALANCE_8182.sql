      
/*      
 * Program ID  : [PR_SCP_ANL_CAPA_BALANCE_8182]      
 * Description  : 자동차/ESS CAPA BALANCE
 * Execute      : 
					EXEC [dbo].[PR_SCP_ANL_CAPA_BALANCE_8182]
						@p_division_id = N'81',
						@p_plan_start_yyyymmdd = N'20221024',
						@p_plan_type = N'PR',						
						@p_seq = N'1',
						@debug_mode = N'T'

 * Program History      
 *===================================================================================================      
 *   Date		In Charge	Description      
 *===================================================================================================      
 * 2021.07.30	HJ.LEE		Initial Release  [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) 
 * 2021.08.19	HJ.LEE		WEEK_CAPA 계산시 int형으로 계산되어 잘못 계산 되는경우가 있어 numeric으로 형변환함.
 * 2021.10.12	HJ.LEE		MC 형교환 일수 데이터 수정
 * 2021.10.13	HJ.LEE		MC 형교환 일수 데이터를 분단위에서 일단위로 변경.  ROUND(분/1440,1)
 * 2022.01.05   khj79		LINE_RATE 컬럼 유형 수정(INT => NUMERIC) , 형교환 조인 테이블 GROUPING 조건 수정(CD.CALENDAR_MONTH 제거)
 * 2022.04.18   sclee.lee   PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - division_id 데이터타입 변경 NVARCHAR(2) -> NVARCHAR(10)
 */      
CREATE PROCEDURE [dbo].[PR_SCP_ANL_CAPA_BALANCE_8182]    

    -- PJ20216891
    @p_division_id				    NVARCHAR(10),
    -- @p_division_id				    NVARCHAR(2),
	@p_plan_start_yyyymmdd	NVARCHAR(8),
	@p_plan_type				    NVARCHAR(50),
	@p_seq						        NVARCHAR(50),
	@debug_mode					NVARCHAR(1)='F'
AS      
BEGIN      
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	PRINT 'All Start. '+CONVERT(CHAR(23), GETDATE(), 21)

	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_CAPA_BALANCE_8182'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N''; 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '#[PR_SCP_ANL_CAPA_BALANCE_8182]#### Start of procedure #';     
    SET @v_description = @p_division_id + ' : ' + @p_plan_start_yyyymmdd + ' : ' + @p_plan_type + ' : ' + @p_seq ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
	
	
	-- 시작 LOG  (END)
	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT 'v_from_yyyymmdd =' +@v_from_yyyymmdd;
		PRINT 'v_to_yyyymmdd =' +@v_to_yyyymmdd;
	
		PRINT '----------------------------------';
	END;
	


	SET @v_from_yyyymmdd = @p_plan_start_yyyymmdd
	SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(WW, 150,  convert(datetime,@p_plan_start_yyyymmdd)), 112); -- 3년 구간 필요
		
	
	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT 'v_from_yyyymmdd =' +@v_from_yyyymmdd;
		PRINT 'v_to_yyyymmdd =' +@v_to_yyyymmdd;
		
		PRINT '----------------------------------';
	END;

	BEGIN TRY
		BEGIN
			/********************************************************************************      
			 * 임시테이블만들기 - 조회조건 테이블      
			 ********************************************************************************/      
			--임시테이블 삭제      

			IF OBJECT_ID('tempdb..##SCM_MST_SITE') IS NOT NULL      
			DROP TABLE #SCM_MST_SITE;

			IF OBJECT_ID('tempdb..##SCM_MST_LINE') IS NOT NULL      
			DROP TABLE #SCM_MST_LINE;

		   /*SCM_SITE (FROM SITE)*/
			SELECT DIVISION_ID, SCM_SITE_ID, SITE_DESCRIPTION
			   INTO #SCM_MST_SITE
			   FROM SCM_MST_SITE S
			 WHERE S.DIVISION_ID = @p_division_id 
				 AND S.OSP_YN = 'N' 
				 --AND  S.OPERATION_GROUP = 'A'	

			SELECT DIVISION_ID, OPERATION_ID, LINE_ID, MAX(LINE_NAME) AS LINE_NAME
				INTO #SCM_MST_LINE
			  FROM SCM_MST_LINE_V
			WHERE DIVISION_ID = @p_division_id 
    			--AND ELECTRODE_TYPE = 'E' 'A'
				--AND operation_id in ('A3000', 'A9000') -- Cell 공정           --, 'P5500', 'P9500' -- Pack 공정
				AND VALID_YN = 'Y'
				 --AND LINE_ID = 'A1A02'   -- 2호 
			 GROUP BY DIVISION_ID, OPERATION_ID, LINE_ID -- LINE_NAME 이 다른 LINE 이 존재하여 수정 함

			/* 유저 MEASURE 세팅값 추출 */ --로드율은 PRODUCTION과 동일한 SORT 값을 강제 셋팅
			SELECT M.COLUMN_NAME
				 , M.COLUMN_LABEL_NAME	AS MEASURE_LABEL
				 , M.ATTRIBUTE3			AS MEASURE_COLOR	--MEASURE 별 COLOR RGB코드
				 , M.SORT_ORDER_NO		AS SORT_ORDER_NO	-- KHJ79 : 정열을 위한 값
			INTO #TblDynamicPivot_SCP0072_MEASURE
			FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
		 WHERE M.PROGRAM_ID='SCP0072'
			 AND M.VALID_YN='Y'
	
			PRINT 'Search SITE & LINE set End. '+CONVERT(CHAR(23), GETDATE(), 21)

			/********************************************************************************      
			 * 임시테이블만들기 - 본 테이블      
			 ********************************************************************************/      
			IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0072') IS NOT NULL      
			DROP TABLE #TblDynamicPivot_SCP0072;      

			/********************************************************************************      
			* 데이타조회, 임시테이블에 저장      
			********************************************************************************/
			DECLARE @mEXEC NVARCHAR(MAX);

			CREATE TABLE #TblDynamicPivot_SCP0072 (
				  DIVISION_ID	               	NVARCHAR(60)	
				, PLAN_START_YYYYMMDD  NVARCHAR(8)
				, PLAN_TYPE                      NVARCHAR(8)
				, SEQ                                NVARCHAR(8)
				, OPERATION_GROUP         NVARCHAR(8)
				, SCM_SITE_ID                  NVARCHAR(30)
				, SCM_SITE_NAME             NVARCHAR(100)
				, LINE_ID                          NVARCHAR(30)   
				, LINE_NAME                     NVARCHAR(100)   
				, OPERATION_ID                NVARCHAR(30)
				, BASIS_YYYY                    NVARCHAR(4)
				, BASIS_YYYYQQ                NVARCHAR(6)
				, BASIS_YYYYMM				NVARCHAR(6)
				, ISO_YYYYWW					NVARCHAR(6)
				, PLAN_WEEK_QTY				NUMERIC(30,10)
				, WEEK_CAPA					NUMERIC(30,10) 
				, MC_QTY							NUMERIC(20)
			);

				INSERT INTO #TblDynamicPivot_SCP0072
				SELECT A.DIVISION_ID	        
						, A.PLAN_START_YYYYMMDD 
						, A.PLAN_TYPE           
						, A.SEQ                 
						, A.OPERATION_GROUP     
						, A.SCM_SITE_ID         
						, S.SITE_DESCRIPTION      
						, A.LINE_ID              
						, L.LINE_NAME           
						, A.OPERATION_ID   
						, A.BASIS_YYYY
						, A.BASIS_YYYYQQ        
						, A.BASIS_YYYYMM				
						, A.ISO_YYYYWW					
						, A.PLAN_WEEK_QTY		
						, A.WEEK_CAPA				
						, A.MC_QTY		  
				   FROM
							(         
									SELECT PL.DIVISION_ID, PL.PLAN_START_YYYYMMDD, PL.PLAN_TYPE, PL.SEQ, PL.OPERATION_GROUP, PL.SCM_SITE_ID
										 , PL.LINE_ID, PL.OPERATION_ID, PL.CALENDAR_YYYY AS BASIS_YYYY, PL.CALENDAR_YYYYQQ AS BASIS_YYYYQQ, PL.BASIS_YYYYMM, PL.ISO_YYYYWW
										 , ROUND(SUM(PL.QTY),0) AS PLAN_WEEK_QTY
										 , ROUND(SUM(PL.WEEK_CNT * CAST( PL.DAILY_CAPA AS numeric)* CAST(PL.LINE_RATE AS numeric ) * (CAST(PL.WORKING_TIME AS numeric) / ( CAST(PL.WEEK_CNT AS numeric) * 1440))),0) AS WEEK_CAPA
										 , ROUND(SUM(ISNULL(MC.time_term,0))/1440,1) AS MC_QTY --형교환일수
									FROM   (
											SELECT PL.DIVISION_ID, PL.PLAN_START_YYYYMMDD, PL.PLAN_TYPE, PL.SEQ, PL.OPERATION_GROUP, PL.SCM_SITE_ID
												 , PL.ITEM_ID, PL.LINE_ID, PL.OPERATION_ID, PL.CALENDAR_YYYY, PL.CALENDAR_YYYYQQ, PL.BASIS_YYYYMM, PL.ISO_YYYYWW, PL.QTY
												 , SUM(PL.QTY) OVER (PARTITION BY PL.CALENDAR_YYYY, PL.CALENDAR_YYYYQQ, PL.BASIS_YYYYMM, PL.ISO_YYYYWW, PL.DIVISION_ID, PL.OPERATION_GROUP, PL.SCM_SITE_ID, PL.LINE_ID) AS LINE_QTY
												 , PL.QTY / SUM(PL.QTY) OVER (PARTITION BY PL.CALENDAR_YYYY, PL.CALENDAR_YYYYQQ, PL.BASIS_YYYYMM, PL.ISO_YYYYWW, PL.DIVISION_ID, PL.OPERATION_GROUP, PL.SCM_SITE_ID, PL.LINE_ID) AS LINE_RATE
												 , ISNULL(TT.DAILY_CAPA,0) AS DAILY_CAPA, WT.WORKING_TIME, WT.WEEK_CNT
											FROM   (
													SELECT PL.DIVISION_ID, PL.PLAN_START_YYYYMMDD, PL.PLAN_TYPE, PL.SEQ, PL.OPERATION_GROUP, PL.SCM_SITE_ID
														 , PL.ITEM_ID, PL.LINE_ID, PL.OPERATION_ID, CD.CALENDAR_YYYY, CD.CALENDAR_YYYYQQ, CD.BASIS_YYYYMM, CD.ISO_YYYYWW, SUM(PL.QTY) AS QTY 
													FROM   SCP_ANL_PRODUCTION_PLAN PL WITH(NOLOCK)
														 , SCM_SYS_CALENDAR_M CD
													WHERE  PL.DIVISION_ID = @p_division_id
													AND    PL.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
													AND    PL.PLAN_TYPE = @p_plan_type
													AND    PL.MEASURE = 'PROD_PLAN_AMEND'
													AND    PL.SEQ = @p_seq
													AND    PL.QTY  > 0 
													AND    PL.YYYYMMDD = CD.BASIS_YYYYMMDD
													AND    EXISTS (
																SELECT *
																FROM   SCM_MST_SITE ST WITH(NOLOCK)
																WHERE  PL.DIVISION_ID = ST.DIVISION_ID
													AND    PL.SCM_SITE_ID = ST.SCM_SITE_ID
													AND    ST.OSP_YN      = 'N'
														   )
													GROUP  BY PL.DIVISION_ID, PL.PLAN_START_YYYYMMDD, PL.PLAN_TYPE, PL.SEQ, PL.OPERATION_GROUP, PL.SCM_SITE_ID
															, PL.ITEM_ID, PL.LINE_ID, PL.OPERATION_ID, CD.CALENDAR_YYYY, CD.CALENDAR_YYYYQQ, CD.BASIS_YYYYMM,  CD.ISO_YYYYWW
												   ) PL
												   LEFT OUTER JOIN
														DBO.SCM_MST_TACT_TIME_VER_H_V TT WITH(NOLOCK)
														ON  PL.DIVISION_ID  = TT.DIVISION_ID
														AND PL.SCM_SITE_ID  = TT.PLANT_SITE_ID
														AND PL.LINE_ID      = TT.LINE_ID
														AND PL.ITEM_ID      = TT.ITEM_ID
														AND PL.BASIS_YYYYMM = TT.MONTH
														AND PL.OPERATION_ID = TT.OPERATION_ID
												   LEFT OUTER JOIN
														(
														SELECT CD.CALENDAR_YYYY, CD.CALENDAR_YYYYQQ, CD.BASIS_YYYYMM,  CD.ISO_YYYYWW, WT.DIVISION_ID, WT.PLANT_SITE_ID, WT.OPERATION_ID, WT.LINE_ID, SUM(WT.WORKING_TIME) AS WORKING_TIME, COUNT(*) AS WEEK_CNT
														FROM   SCP_MST_WORKING_TIME WT
															 , SCM_SYS_CALENDAR_M CD
														WHERE  WT.YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND DATEADD(WW, 82, CONVERT(DATETIME, @p_plan_start_yyyymmdd))
														AND    WT.YYYYMMDD = CD.BASIS_YYYYMMDD
														GROUP  BY CD.CALENDAR_YYYY, CD.CALENDAR_YYYYQQ, CD.BASIS_YYYYMM,  CD.ISO_YYYYWW, WT.DIVISION_ID, WT.PLANT_SITE_ID, WT.OPERATION_ID, WT.LINE_ID
														) WT
														ON  PL.DIVISION_ID      = WT.DIVISION_ID
														AND PL.SCM_SITE_ID    = WT.PLANT_SITE_ID
														AND PL.LINE_ID            = WT.LINE_ID
														AND PL.OPERATION_ID = WT.OPERATION_ID
														AND PL.BASIS_YYYYMM = WT.BASIS_YYYYMM
														AND PL.ISO_YYYYWW   = WT.ISO_YYYYWW
											WHERE  1 = 1
										   ) PL
										   LEFT JOIN( SELECT W.DIVISION_ID, W.FACTORY_ID, W.OPERATION_ID, W.LINE_ID
																	   , SUM(W.TIME_TERM)  AS TIME_TERM
																	   --, CD.CALENDAR_YYYY, CD.CALENDAR_YYYYQQ, CD.CALENDAR_MONTH, CD.ISO_YYYYWW
																	   , CD.CALENDAR_YYYY, CD.CALENDAR_YYYYQQ, CD.ISO_YYYYWW , CD.BASIS_YYYYMM
															   FROM SCM_WORK_CALENDAR_M_sn w WITH(NOLOCK)
																	  , SCM_SYS_CALENDAR_M CD
															WHERE  1=1
															     AND   W.LOSS_CODE = 'XC031'
															     AND CD.BASIS_YYYYMMDD =  CONVERT(CHAR(8), W.WORK_DATE, 112)
															GROUP BY W.DIVISION_ID, W.FACTORY_ID, W.OPERATION_ID, W.LINE_ID
															           --,CD.CALENDAR_YYYY, CD.CALENDAR_YYYYQQ, CD.CALENDAR_MONTH, CD.ISO_YYYYWW
																	 ,CD.CALENDAR_YYYY, CD.CALENDAR_YYYYQQ, CD.ISO_YYYYWW, CD.BASIS_YYYYMM
															) MC ON 
															       PL.DIVISION_ID = MC.DIVISION_ID 
																   AND PL.OPERATION_ID = MC.OPERATION_ID
															       AND PL.LINE_ID = MC.LINE_ID  
																   AND PL.ISO_YYYYWW = MC.ISO_YYYYWW
																   AND PL.BASIS_YYYYMM= MC.BASIS_YYYYMM
									WHERE  1 = 1
									GROUP  BY PL.DIVISION_ID, PL.PLAN_START_YYYYMMDD, PL.PLAN_TYPE, PL.SEQ, PL.OPERATION_GROUP, PL.SCM_SITE_ID
										 , PL.LINE_ID, PL.OPERATION_ID, PL.CALENDAR_YYYY, PL.CALENDAR_YYYYQQ, PL.BASIS_YYYYMM, PL.ISO_YYYYWW 
								) A 
								LEFT JOIN #SCM_MST_SITE S ON A.DIVISION_ID = S.DIVISION_ID AND A.SCM_SITE_ID = S.SCM_SITE_ID 
								LEFT JOIN #SCM_MST_LINE L ON A.DIVISION_ID = L.DIVISION_ID AND A.LINE_ID = L.LINE_ID AND A.OPERATION_ID = L.OPERATION_ID
								ORDER BY  A.DIVISION_ID	        
												, A.PLAN_START_YYYYMMDD 
												, A.PLAN_TYPE           
												, A.SEQ                 
												, A.OPERATION_GROUP     
												, A.SCM_SITE_ID         
												, S.SITE_DESCRIPTION      
												, A.LINE_ID              
												, L.LINE_NAME           
												, A.OPERATION_ID  
												, A.BASIS_YYYY
												, A.BASIS_YYYYQQ        
												, A.BASIS_YYYYMM				
												, A.ISO_YYYYWW							
		  	
			-- LOG                  
			SET @v_log_type = N'TXN';                  
			SET @v_log_message = N'INSERT Temp Table';                    
			SET @d_event_date = SYSDATETIME()  ;                 
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
									  ,@p_log_type      =@v_log_type                  
									  ,@p_log_count     =@n_log_count                   
									  ,@p_log_message   =@v_log_message                   
									  ,@p_description   =@v_description                   
									  ,@p_event_date    =@d_event_date                   
									  ,@p_user_id       =@v_batch_user                  
									  ;    	   

			/********************************************************************************      
			* PIVOIT처리      
			********************************************************************************/   
			BEGIN   
				DECLARE @mQRY_sum1 NVARCHAR(MAX);      --조립계획 
				DECLARE @mQRY_sum2 NVARCHAR(MAX);      --Capa
				DECLARE @mQRY_sum3 NVARCHAR(MAX);      --형교환

				DECLARE @mQRY_sub NVARCHAR(MAX);      --
      
				PRINT 'PIVOIT  START '+CONVERT(CHAR(23), GETDATE(), 21)

				DELETE SCP_ANL_CAPA_BALANCE_REPORT_ESS
				 WHERE DIVISION_ID = @p_division_id
					 AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					 AND PLAN_TYPE = @p_plan_type
					 AND SEQ = @p_seq

				--1. PROD_PLAN (PLAN_WEEK_QTY)   
				SET @mQRY_sum1 = '';		


				SELECT TOP 130 @mQRY_sum1 = @mQRY_sum1+','+ 
					CASE WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN   '  ISNULL(SUM(CASE WHEN BASIS_YYYY = RIGHT('''+YYYYMMDD+''', 4) THEN PLAN_WEEK_QTY END ),0) AS ' + YYYYMMDD    
							 WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYMM = RIGHT('''+YYYYMMDD+''', 6) THEN PLAN_WEEK_QTY END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYQQ = RIGHT('''+YYYYMMDD+''', 6) THEN PLAN_WEEK_QTY END ),0) AS ' + YYYYMMDD    
							 --WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 6) THEN PLAN_WEEK_QTY END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  BASIS_YYYYMM + ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 12) THEN PLAN_WEEK_QTY END ),0) AS ' + YYYYMMDD   

					END +''+CHAR(10) 
				FROM (  
					SELECT TOP 100    'W_'+ BASIS_YYYYMM + A.ISO_YYYYWW AS YYYYMMDD  
						, '03'+A.BASIS_START_DATE + CONVERT(CHAR(2), '03') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)        
					GROUP BY A.ISO_YYYYWW, A.BASIS_START_DATE , BASIS_YYYYMM
					order by 2
					UNION ALL      
					SELECT TOP 20 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
					  ,'02'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)        
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
					order by 2
					UNION ALL
				  SELECT TOP 7 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD
					  ,'01'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd      
					GROUP BY A.CALENDAR_YYYYQQ
					order by 2
					UNION ALL
				  SELECT TOP 3 'Y_'+A.CALENDAR_YYYY  AS YYYYMMDD
					  ,'00'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '00') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd        
					GROUP BY A.CALENDAR_YYYY
					order by 2
				)  A      
				ORDER BY SORT_ORDER_NO ;      
				
				SET @mEXEC = '';

				--SET @mEXEC = @mEXEC + ' INSERT INTO SCP_ANL_CAPA_BALANCE_REPORT_ESS'+CHAR(10);
				SET @mEXEC = @mEXEC + ' INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_ESS]                                                                                                                                        '+CHAR(10);
				SET @mEXEC = @mEXEC + '            ([DIVISION_ID] ,[PLAN_START_YYYYMMDD]    ,[PLAN_TYPE]   ,[SEQ]  ,[LINE_ID] ,[LINE_NAME] ,[SCM_SITE_ID],[SCM_SITE_NAME] ,[MEASURE]    '+CHAR(10); 
				SET @mEXEC = @mEXEC + '            ,[MEASURE_LABEL] ,[SORT_ORDER_NO] ,[Y0],[Y1],[Y2],[Q0],[Q1],[Q2],[Q3],[Q4],[Q5],[Q6],[M0],[M1],[M2]                                                        '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[M3],[M4],[M5],[M6],[M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[W0],[W1]                                               '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W2],[W3],[W4],[W5],[W6],[W7],[W8],[W9],[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19]                                                '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52],[W53],[W54],[W55],[W56],[W57],[W58],[W59],[W60],[W61]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W62],[W63],[W64],[W65],[W66],[W67],[W68],[W69],[W70],[W71],[W72],[W73],[W74],[W75],[W76],[W77],[W78],[W79],[W80],[W81],[W82]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W83],[W84],[W85],[W86],[W87],[W88],[W89],[W90],[W91],[W92],[W93],[W94],[W95],[W96],[W97],[W98],[W99] )                                             '+CHAR(10);  
				SET @mEXEC = @mEXEC + ' (SELECT  ''' + @p_division_id +'''		  						   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_start_yyyymmdd+'''     		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_type+'''                       		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_seq+'''                                		       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_ID								     			   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_NAME											   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              , A.SCM_SITE_ID										   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.SCM_SITE_NAME									   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''PROD_PLAN''  AS  MEASURE	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''Prod Plan''      AS  MEASURE_LABEL	           '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''0''  AS  SORT_ORDER_NO    	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				' + @mQRY_sum1 +'									   '+CHAR(10);	
				SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0072 A WITH(NOLOCK) '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		GROUP BY A.LINE_ID									       	   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.LINE_NAME								       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_ID             					   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_NAME						       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' )                                                     					       '+CHAR(10);
		
				IF( @debug_mode ='T')
					BEGIN				
					DECLARE @POS INT =1;
					DECLARE @LEN INT =LEN(@mEXEC);
						SET @POS =1;
						SET @LEN =LEN(@mEXEC);
						WHILE @POS <= @LEN
							BEGIN
								PRINT SUBSTRING(@mEXEC,@POS,4000);
								SET @POS = @POS+4000;
							END;
					END;
				EXEC (@mEXEC);
		  	
				-- LOG                  
				SET @v_log_type = N'TXN';                  
				SET @v_log_message = N'1. PROD_PLAN (PLAN_WEEK_QTY)';                    
				SET @d_event_date = SYSDATETIME()  ;                 
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
											,@p_log_type      =@v_log_type                  
											,@p_log_count     =@n_log_count                   
											,@p_log_message   =@v_log_message                   
											,@p_description   =@v_description                   
											,@p_event_date    =@d_event_date                   
											,@p_user_id       =@v_batch_user 											

				--2. PROD_PLAN (WEEK_CAPA)   
				SET @mQRY_sum2 = '';
		
				SELECT TOP 130 @mQRY_sum2= @mQRY_sum2+','+ 
					CASE WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN   '  ISNULL(SUM(CASE WHEN BASIS_YYYY = RIGHT('''+YYYYMMDD+''', 4) THEN WEEK_CAPA END ),0) AS ' + YYYYMMDD    
							 WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYMM = RIGHT('''+YYYYMMDD+''', 6) THEN WEEK_CAPA END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYQQ = RIGHT('''+YYYYMMDD+''', 6) THEN WEEK_CAPA END ),0) AS ' + YYYYMMDD    
							 --WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 6) THEN WEEK_CAPA END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  BASIS_YYYYMM + ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 12) THEN WEEK_CAPA END ),0) AS ' + YYYYMMDD   
					END +''+CHAR(10) 
				FROM (    
					SELECT TOP 100    'W_'+ BASIS_YYYYMM + A.ISO_YYYYWW AS YYYYMMDD  
						, '03'+A.BASIS_START_DATE + CONVERT(CHAR(2), '03') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)        
					GROUP BY A.ISO_YYYYWW, A.BASIS_START_DATE    , BASIS_YYYYMM  
					UNION ALL      
					SELECT TOP 20 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
					  ,'02'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)  
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
					UNION ALL
				  SELECT TOP 7 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD
					  ,'01'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd      
					GROUP BY A.CALENDAR_YYYYQQ 
					UNION ALL
				  SELECT TOP 3 'Y_'+A.CALENDAR_YYYY  AS YYYYMMDD
					  ,'00'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '00') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd        
					GROUP BY A.CALENDAR_YYYY   
				) AS A      
				ORDER BY SORT_ORDER_NO ;      
				
				SET @mEXEC = '';

		--		SET @mEXEC = @mEXEC + ' INSERT INTO SCP_ANL_CAPA_BALANCE_REPORT_ESS'+CHAR(10);
				SET @mEXEC = @mEXEC + ' INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_ESS]                                                                                                                                        '+CHAR(10);
				SET @mEXEC = @mEXEC + '            ([DIVISION_ID] ,[PLAN_START_YYYYMMDD]    ,[PLAN_TYPE]   ,[SEQ]  ,[LINE_ID] ,[LINE_NAME] ,[SCM_SITE_ID],[SCM_SITE_NAME] ,[MEASURE]    '+CHAR(10); 
				SET @mEXEC = @mEXEC + '            ,[MEASURE_LABEL] ,[SORT_ORDER_NO] ,[Y0],[Y1],[Y2],[Q0],[Q1],[Q2],[Q3],[Q4],[Q5],[Q6],[M0],[M1],[M2]                                                        '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[M3],[M4],[M5],[M6],[M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[W0],[W1]                                               '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W2],[W3],[W4],[W5],[W6],[W7],[W8],[W9],[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19]                                                '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52],[W53],[W54],[W55],[W56],[W57],[W58],[W59],[W60],[W61]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W62],[W63],[W64],[W65],[W66],[W67],[W68],[W69],[W70],[W71],[W72],[W73],[W74],[W75],[W76],[W77],[W78],[W79],[W80],[W81],[W82]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W83],[W84],[W85],[W86],[W87],[W88],[W89],[W90],[W91],[W92],[W93],[W94],[W95],[W96],[W97],[W98],[W99] )                                             '+CHAR(10);  
				SET @mEXEC = @mEXEC + '( SELECT   ''' + @p_division_id +'''		  						   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_start_yyyymmdd+'''     		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_type+'''                       		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_seq+'''                                		       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_ID								     			   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_NAME											   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              , A.SCM_SITE_ID										   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.SCM_SITE_NAME									   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''CAPA''  AS  MEASURE	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''Capa''      AS  MEASURE_LABEL	           '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''2''  AS  SORT_ORDER_NO    	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				' + @mQRY_sum2 +'									   '+CHAR(10);	
				SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0072 A WITH(NOLOCK)	'+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		GROUP BY A.LINE_ID									       	   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.LINE_NAME									       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_ID             					   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_NAME							       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' )                                                     					       '+CHAR(10);

				IF( @debug_mode ='T')
					BEGIN				
					--DECLARE @POS INT =1;
					--DECLARE @LEN INT =LEN(@mEXEC);
						SET @POS =1;
						SET @LEN =LEN(@mEXEC);
						WHILE @POS <= @LEN
							BEGIN
								PRINT SUBSTRING(@mEXEC,@POS,4000);
								SET @POS = @POS+4000;
							END;
					END;
				EXEC (@mEXEC);
		  	
				-- LOG                  
				SET @v_log_type = N'TXN';                  
				SET @v_log_message = N'2. PROD_PLAN (WEEK_CAPA)';                    
				SET @d_event_date = SYSDATETIME()  ;                 
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
											,@p_log_type      =@v_log_type                  
											,@p_log_count     =@n_log_count                   
											,@p_log_message   =@v_log_message                   
											,@p_description   =@v_description                   
											,@p_event_date    =@d_event_date                   
											,@p_user_id       =@v_batch_user 
		
				--3. BALANCE (과부족  CAPA-생산계획)   
				SET @mQRY_sum2 = '';
		
				SELECT TOP 130 @mQRY_sum2= @mQRY_sum2+','+ 
					CASE WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN   '  ISNULL(SUM(CASE WHEN BASIS_YYYY = RIGHT('''+YYYYMMDD+''', 4) THEN 0 END ),0) AS ' + YYYYMMDD    
							 WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYMM = RIGHT('''+YYYYMMDD+''', 6) THEN 0 END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYQQ = RIGHT('''+YYYYMMDD+''', 6) THEN 0 END ),0) AS ' + YYYYMMDD    
							 --WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 6) THEN 0 END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  BASIS_YYYYMM + ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 12) THEN 0 END ),0) AS ' + YYYYMMDD   
					END +''+CHAR(10) 
				FROM (    
					SELECT TOP 100    'W_'+ BASIS_YYYYMM + A.ISO_YYYYWW AS YYYYMMDD  
						, '03'+A.BASIS_START_DATE + CONVERT(CHAR(2), '03') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)  
					GROUP BY A.ISO_YYYYWW, A.BASIS_START_DATE      , BASIS_YYYYMM
					UNION ALL      
					SELECT TOP 20 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
					  ,'02'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)  
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
					UNION ALL
				  SELECT TOP 7 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD
					  ,'01'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd      
					GROUP BY A.CALENDAR_YYYYQQ 
					UNION ALL
				  SELECT TOP 3 'Y_'+A.CALENDAR_YYYY  AS YYYYMMDD
					  ,'00'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '00') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd        
					GROUP BY A.CALENDAR_YYYY   
				) AS A      
				ORDER BY SORT_ORDER_NO ;      
				
				SET @mEXEC = '';

				--SET @mEXEC = @mEXEC + ' INSERT INTO SCP_ANL_CAPA_BALANCE_REPORT_ESS'+CHAR(10);
    			SET @mEXEC = @mEXEC + ' INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_ESS]                                                                                                                                        '+CHAR(10);
				SET @mEXEC = @mEXEC + '            ([DIVISION_ID] ,[PLAN_START_YYYYMMDD]    ,[PLAN_TYPE]   ,[SEQ]  ,[LINE_ID] ,[LINE_NAME] ,[SCM_SITE_ID],[SCM_SITE_NAME] ,[MEASURE]    '+CHAR(10); 
				SET @mEXEC = @mEXEC + '            ,[MEASURE_LABEL] ,[SORT_ORDER_NO] ,[Y0],[Y1],[Y2],[Q0],[Q1],[Q2],[Q3],[Q4],[Q5],[Q6],[M0],[M1],[M2]                                                        '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[M3],[M4],[M5],[M6],[M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[W0],[W1]                                               '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W2],[W3],[W4],[W5],[W6],[W7],[W8],[W9],[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19]                                                '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52],[W53],[W54],[W55],[W56],[W57],[W58],[W59],[W60],[W61]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W62],[W63],[W64],[W65],[W66],[W67],[W68],[W69],[W70],[W71],[W72],[W73],[W74],[W75],[W76],[W77],[W78],[W79],[W80],[W81],[W82]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W83],[W84],[W85],[W86],[W87],[W88],[W89],[W90],[W91],[W92],[W93],[W94],[W95],[W96],[W97],[W98],[W99] )                                             '+CHAR(10);  
				SET @mEXEC = @mEXEC + '(SELECT   ''' + @p_division_id +'''		  						   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_start_yyyymmdd+'''     		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_type+'''                       		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_seq+'''                                		       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_ID								     			   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_NAME											   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              , A.SCM_SITE_ID										   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.SCM_SITE_NAME									   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''BALANCE''  AS  MEASURE	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''Balance''      AS  MEASURE_LABEL	           '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''3''  AS  SORT_ORDER_NO    	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				' + @mQRY_sum2 +'									   '+CHAR(10);	
				SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0072 A WITH(NOLOCK)	'+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		GROUP BY A.LINE_ID									       	   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.LINE_NAME									       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_ID             					   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_NAME							       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' )                                                     					       '+CHAR(10);

				IF( @debug_mode ='T')
					BEGIN				
					--DECLARE @POS INT =1;
					--DECLARE @LEN INT =LEN(@mEXEC);
						SET @POS =1;
						SET @LEN =LEN(@mEXEC);
						WHILE @POS <= @LEN
							BEGIN
								PRINT SUBSTRING(@mEXEC,@POS,4000);
								SET @POS = @POS+4000;
							END;
					END;
				EXEC (@mEXEC);
		  	
				-- LOG                  
				SET @v_log_type = N'TXN';                  
				SET @v_log_message = N'3. BALANCE (과부족  CAPA-생산계획)';                    
				SET @d_event_date = SYSDATETIME()  ;                 
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
											,@p_log_type      =@v_log_type                  
											,@p_log_count     =@n_log_count                   
											,@p_log_message   =@v_log_message                   
											,@p_description   =@v_description                   
											,@p_event_date    =@d_event_date                   
											,@p_user_id       =@v_batch_user 

				--4. MC_QTY (형교환일수)   2021.08.08
				SET @mQRY_sum3 = '';
		
				SELECT TOP 130 @mQRY_sum3= @mQRY_sum3+','+ 
					CASE WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN   '  ISNULL(SUM(CASE WHEN BASIS_YYYY = RIGHT('''+YYYYMMDD+''', 4) THEN MC_QTY END ),0) AS ' + YYYYMMDD    
							 WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYMM = RIGHT('''+YYYYMMDD+''', 6) THEN MC_QTY END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYQQ = RIGHT('''+YYYYMMDD+''', 6) THEN MC_QTY END ),0) AS ' + YYYYMMDD    
							 --WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 6) THEN MC_QTY END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  BASIS_YYYYMM + ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 12) THEN MC_QTY END ),0) AS ' + YYYYMMDD   
					END +''+CHAR(10) 
				FROM (    
					SELECT TOP 100    'W_'+ BASIS_YYYYMM + A.ISO_YYYYWW AS YYYYMMDD
						, '03'+A.BASIS_START_DATE + CONVERT(CHAR(2), '03') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)  
					GROUP BY A.ISO_YYYYWW, A.BASIS_START_DATE      , BASIS_YYYYMM
					UNION ALL      
					SELECT TOP 20 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
					  ,'02'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)  
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
					UNION ALL
				  SELECT TOP 7 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD
					  ,'01'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd      
					GROUP BY A.CALENDAR_YYYYQQ 
					UNION ALL
				  SELECT TOP 3 'Y_'+A.CALENDAR_YYYY  AS YYYYMMDD
					  ,'00'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '00') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd        
					GROUP BY A.CALENDAR_YYYY   
				) AS A      
				ORDER BY SORT_ORDER_NO ;      
				
				SET @mEXEC = '';

				--SET @mEXEC = @mEXEC + ' INSERT INTO SCP_ANL_CAPA_BALANCE_REPORT_ESS'+CHAR(10);
		
				SET @mEXEC = @mEXEC + ' INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_ESS]                                                                                                                                        '+CHAR(10);
				SET @mEXEC = @mEXEC + '            ([DIVISION_ID] ,[PLAN_START_YYYYMMDD]    ,[PLAN_TYPE]   ,[SEQ]  ,[LINE_ID] ,[LINE_NAME] ,[SCM_SITE_ID],[SCM_SITE_NAME] ,[MEASURE]    '+CHAR(10); 
				SET @mEXEC = @mEXEC + '            ,[MEASURE_LABEL] ,[SORT_ORDER_NO] ,[Y0],[Y1],[Y2],[Q0],[Q1],[Q2],[Q3],[Q4],[Q5],[Q6],[M0],[M1],[M2]                                                        '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[M3],[M4],[M5],[M6],[M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[W0],[W1]                                               '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W2],[W3],[W4],[W5],[W6],[W7],[W8],[W9],[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19]                                                '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52],[W53],[W54],[W55],[W56],[W57],[W58],[W59],[W60],[W61]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W62],[W63],[W64],[W65],[W66],[W67],[W68],[W69],[W70],[W71],[W72],[W73],[W74],[W75],[W76],[W77],[W78],[W79],[W80],[W81],[W82]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W83],[W84],[W85],[W86],[W87],[W88],[W89],[W90],[W91],[W92],[W93],[W94],[W95],[W96],[W97],[W98],[W99] )                                             '+CHAR(10);  
				SET @mEXEC = @mEXEC + '(SELECT   ''' + @p_division_id +'''		  						   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_start_yyyymmdd+'''     		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_type+'''                       		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_seq+'''                                		       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_ID								     			   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_NAME											   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              , A.SCM_SITE_ID										   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.SCM_SITE_NAME									   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''MC_QTY''  AS  MEASURE	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''MC Qty''      AS  MEASURE_LABEL	           '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''4''  AS  SORT_ORDER_NO    	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				' + @mQRY_sum3 +'									   '+CHAR(10);	
				SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0072 A WITH(NOLOCK)	'+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		GROUP BY A.LINE_ID									       	   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.LINE_NAME									       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_ID             					   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_NAME							       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' )                                                     					       '+CHAR(10);

				IF( @debug_mode ='T')
					BEGIN				
					--DECLARE @POS INT =1;
					--DECLARE @LEN INT =LEN(@mEXEC);
						SET @POS =1;
						SET @LEN =LEN(@mEXEC);
						WHILE @POS <= @LEN
							BEGIN
								PRINT SUBSTRING(@mEXEC,@POS,4000);
								SET @POS = @POS+4000;
							END;
					END;
				EXEC (@mEXEC);
		  	
				-- LOG                  
				SET @v_log_type = N'TXN';                  
				SET @v_log_message = N'4. MC_QTY (형교환일수)';                    
				SET @d_event_date = SYSDATETIME()  ;                 
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
											,@p_log_type      =@v_log_type                  
											,@p_log_count     =@n_log_count                   
											,@p_log_message   =@v_log_message                   
											,@p_description   =@v_description                   
											,@p_event_date    =@d_event_date                   
											,@p_user_id       =@v_batch_user 

				PRINT 'Input Pivot set End. '+CONVERT(CHAR(23), GETDATE(), 21)

			END;
		  		
				--5. Loading율
				SET @mQRY_sum2 = '';
		
				SELECT TOP 130 @mQRY_sum2= @mQRY_sum2+','+ 
					CASE WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN   '  ISNULL(SUM(CASE WHEN BASIS_YYYY = RIGHT('''+YYYYMMDD+''', 4) THEN 0 END ),0) AS ' + YYYYMMDD    
							 WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYMM = RIGHT('''+YYYYMMDD+''', 6) THEN 0 END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN BASIS_YYYYQQ = RIGHT('''+YYYYMMDD+''', 6) THEN 0 END ),0) AS ' + YYYYMMDD    
							 --WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 6) THEN 0 END ),0) AS ' + YYYYMMDD   
							 WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  '  ISNULL(SUM(CASE WHEN  BASIS_YYYYMM + ISO_YYYYWW = RIGHT('''+YYYYMMDD+''', 12) THEN 0 END ),0) AS ' + YYYYMMDD
					END +''+CHAR(10) 
				FROM (    
					SELECT TOP 100    'W_'+ BASIS_YYYYMM + A.ISO_YYYYWW AS YYYYMMDD
						, '03'+A.BASIS_START_DATE + CONVERT(CHAR(2), '03') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)  
					GROUP BY ISO_YYYYWW, A.BASIS_START_DATE      , BASIS_YYYYMM
					UNION ALL      
					SELECT TOP 20 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
					  ,'02'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND CONVERT(CHAR(8), DATEADD(MM, 1,  convert(datetime,@v_to_yyyymmdd)), 112)  
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
					UNION ALL
				  SELECT TOP 7 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD
					  ,'01'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd      
					GROUP BY A.CALENDAR_YYYYQQ 
					UNION ALL
				  SELECT TOP 3 'Y_'+A.CALENDAR_YYYY  AS YYYYMMDD
					  ,'00'+MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '00') AS SORT_ORDER_NO      
					FROM [DBO].[SCM_SYS_CALENDAR_M] A       
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd        
					GROUP BY A.CALENDAR_YYYY   
				) AS A      
				ORDER BY SORT_ORDER_NO ;      
				
				SET @mEXEC = '';

				--SET @mEXEC = @mEXEC + ' INSERT INTO SCP_ANL_CAPA_BALANCE_REPORT_ESS'+CHAR(10);
     			SET @mEXEC = @mEXEC + ' INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_ESS]                                                                                                                                        '+CHAR(10);
				SET @mEXEC = @mEXEC + '            ([DIVISION_ID] ,[PLAN_START_YYYYMMDD]    ,[PLAN_TYPE]   ,[SEQ]  ,[LINE_ID] ,[LINE_NAME] ,[SCM_SITE_ID],[SCM_SITE_NAME] ,[MEASURE]    '+CHAR(10); 
				SET @mEXEC = @mEXEC + '            ,[MEASURE_LABEL] ,[SORT_ORDER_NO] ,[Y0],[Y1],[Y2],[Q0],[Q1],[Q2],[Q3],[Q4],[Q5],[Q6],[M0],[M1],[M2]                                                        '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[M3],[M4],[M5],[M6],[M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[W0],[W1]                                               '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W2],[W3],[W4],[W5],[W6],[W7],[W8],[W9],[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19]                                                '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52],[W53],[W54],[W55],[W56],[W57],[W58],[W59],[W60],[W61]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W62],[W63],[W64],[W65],[W66],[W67],[W68],[W69],[W70],[W71],[W72],[W73],[W74],[W75],[W76],[W77],[W78],[W79],[W80],[W81],[W82]       '+CHAR(10);   
				SET @mEXEC = @mEXEC + '            ,[W83],[W84],[W85],[W86],[W87],[W88],[W89],[W90],[W91],[W92],[W93],[W94],[W95],[W96],[W97],[W98],[W99] )                                             '+CHAR(10);  
				SET @mEXEC = @mEXEC + '(SELECT   ''' + @p_division_id +'''		  						   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_start_yyyymmdd+'''     		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_plan_type+'''                       		   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              ,''' + @p_seq+'''                                		       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_ID								     			   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.LINE_NAME											   '+CHAR(10);
				SET @mEXEC = @mEXEC + '              , A.SCM_SITE_ID										   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, A.SCM_SITE_NAME									   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''LOADING_RATE'' AS  MEASURE	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''Loading Rate(%)'' AS  MEASURE_LABEL	           '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				, ''5''  AS  SORT_ORDER_NO    	         		   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				' + @mQRY_sum2 +'									   '+CHAR(10);	
				SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0072 A WITH(NOLOCK)	'+CHAR(10);
				SET @mEXEC = @mEXEC + ' 		GROUP BY A.LINE_ID									       	   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.LINE_NAME									       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_ID             					   '+CHAR(10);
				SET @mEXEC = @mEXEC + ' 				      , A.SCM_SITE_NAME							       '+CHAR(10);
				SET @mEXEC = @mEXEC + ' )                                                     					       '+CHAR(10);

				IF( @debug_mode ='T')
					BEGIN				
					--DECLARE @POS INT =1;
					--DECLARE @LEN INT =LEN(@mEXEC);
						SET @POS =1;
						SET @LEN =LEN(@mEXEC);
						WHILE @POS <= @LEN
							BEGIN
								PRINT SUBSTRING(@mEXEC,@POS,4000);
								SET @POS = @POS+4000;
							END;
					END;
				EXEC (@mEXEC);

				-- LOG                  
				SET @v_log_type = N'TXN';                  
				SET @v_log_message = N'5. Loading율';                    
				SET @d_event_date = SYSDATETIME()  ;                 
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
											,@p_log_type      =@v_log_type                  
											,@p_log_count     =@n_log_count                   
											,@p_log_message   =@v_log_message                   
											,@p_description   =@v_description                   
											,@p_event_date    =@d_event_date                   
											,@p_user_id       =@v_batch_user 

			INSERT INTO SCP_ANL_CAPA_BALANCE_REPORT_ESS
			(DIVISION_ID, PLAN_START_YYYYMMDD,PLAN_TYPE, SEQ, LINE_ID, LINE_NAME, SCM_SITE_ID, SCM_SITE_NAME, MEASURE,MEASURE_LABEL, SORT_ORDER_NO )  
				(
					SELECT MAX(DIVISION_ID) AS DIVISION_ID
							   ,MAX(PLAN_START_YYYYMMDD) AS PLAN_START_YYYYMMDD
							   ,MAX(PLAN_TYPE) AS PLAN_TYPE
							   ,MAX(SEQ) AS SEQ, 'Total' AS LINE_ID, 'Total' AS LINE_NAME 
							   ,'Total' AS SCM_SITE_ID
							   ,'Total' AS SCM_SITE_NAME
							   ,MEASURE
							   ,MAX(MEASURE_LABEL) AS MEASURE_LABEL
							   ,MAX(SORT_ORDER_NO) AS SORT_ORDER_NO
					 FROM SCP_ANL_CAPA_BALANCE_REPORT_ESS A
				   WHERE DIVISION_ID =  @p_division_id 
						AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND PLAN_TYPE = @p_plan_type 
						AND SEQ = @p_seq  
					GROUP BY MEASURE,MEASURE_LABEL
				)

			-- LOG                  
			SET @v_log_type = N'TXN';                  
			SET @v_log_message = N'INSERT SCP_ANL_CAPA_BALANCE_REPORT_ESS';                    
			SET @d_event_date = SYSDATETIME()  ;                 
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
										,@p_log_type      =@v_log_type                  
										,@p_log_count     =@n_log_count                   
										,@p_log_message   =@v_log_message                   
										,@p_description   =@v_description                   
										,@p_event_date    =@d_event_date                   
										,@p_user_id       =@v_batch_user 

			--임시테이블 삭제      
			IF OBJECT_ID('tempdb..##SCM_MST_SITE') IS NOT NULL      
			DROP TABLE #SCM_MST_SITE;

			IF OBJECT_ID('tempdb..##SCM_MST_LINE') IS NOT NULL      
			DROP TABLE #SCM_MST_LINE;

			IF OBJECT_ID('tempdb..##TblDynamicPivot_SCP0072') IS NOT NULL      
			DROP TABLE #TblDynamicPivot_SCP0072;

		END
    END TRY

    BEGIN CATCH                  
    --  IF @@TRANCOUNT > 0                  
    --    BEGIN                  
    --      ROLLBACK                   
    --END;                  
                        
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
       --      PRINT @@ERROR                  
      return -1                  
    END CATCH;   

    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'PR_SCP_ANL_CAPA_BALANCE_8182 END of procedure ##########';                  
    SET @v_description = N'['  + @v_exec_time + ']';             
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
    return 1                
                  
    _RETURN_ERR_CODE:                  
        BEGIN                  
             RETURN -1                  
        END;                  
                  
  END;  


