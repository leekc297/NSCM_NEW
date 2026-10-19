/****************************************************************************************************/  
/*    
 * Program ID   : PR_DM_DNM_SALES_PRICE_EXIST_MAIL_SEND    
 * Description   : 판가 미등록 데이터 메일 발송 - 매주 금요일 08시00분 발송  
 * PARAMETER  : N/A  
 * Program History    
 *===================================================================================================    
 *   Date       In Charge		Description    
 *===================================================================================================  
 * 2024.05.24	kcw3408			[SCM DM 고객수요관리 고도화 및 개선] 판가 미등록 데이터 메일 발송 요청 건  
 * 2024.07.15	JSSBAE			[E20240709-000783]_Sales Price 미입력 자동메일 수정요청
 *  
 * EXEC PR_DM_DNM_SALES_PRICE_EXIST_MAIL_SEND @p_division_id=N'82'
 */   
 /****************************************************************************************************/  
     
CREATE PROC [dbo].[PR_DM_DNM_SALES_PRICE_EXIST_MAIL_SEND]
	@p_division_id				NVARCHAR(30)  -- DIVISION_ID
AS  
SET NOCOUNT ON  
  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
    SET NOCOUNT ON;  
  
 -----------------------------------------------------------------------------------------------------------------------------------------  
 -- STEP 01. LOG 저장 (변수 생성 및 실행)   
 -----------------------------------------------------------------------------------------------------------------------------------------  
  
 -- LOG 용 변수 설정  
DECLARE @v_program_name		NVARCHAR(150) = 'PR_DM_DNM_SALES_PRICE_EXIST_MAIL_SEND';  
DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...  
DECLARE @n_log_count			INTEGER = 0;  
DECLARE @v_log_message		NVARCHAR(1000);  
DECLARE @v_description			NVARCHAR(500);  
DECLARE @d_event_date			DATETIME;  
  
 -- 시작 LOG  
SET @v_log_type = 'START';  
SET @v_log_message = '##### Start of procedure #####';  
SET @v_description = N'판가 미등록 데이터 메일 발송';  
SET @d_event_date = SYSDATETIME();  

EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
  
BEGIN TRY  
   
	-----------------------------------------------------------------------------------------------------------------------------------------  
	-- STEP 02. 임시테이블 / 변수 생성   
	-----------------------------------------------------------------------------------------------------------------------------------------  
	IF OBJECT_ID (N'tempdb..#TEMP_SALES_PRICE_EXIST', N'U')			IS NOT NULL  DROP TABLE #TEMP_SALES_PRICE_EXIST
	IF OBJECT_ID (N'tempdb..#T_MAIL_ADDR', N'U')					IS NOT NULL	DROP TABLE #T_MAIL_ADDR
  	 
	 
   PRINT ( 'A1--00--00 : ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

	-----------------------------------------------------------------------------------------------------------------------------------------  
	-- STEP 03. 판가 미등록 데이터 조회 (주차 단위 RTF 합산값이 있으나 Price가 0이거나 존재하지 않는 경우,52주 구간) 
	-----------------------------------------------------------------------------------------------------------------------------------------
	BEGIN
		DECLARE @v_from_yyyymmdd     AS NVARCHAR(10);
		DECLARE @v_to_yyyymmdd       AS NVARCHAR(10); 

		SET @v_from_yyyymmdd  = ''; -- From 주차 월요일
		SET @v_to_yyyymmdd    = ''; -- To 주차 월요일(52주차) 
   
		  -- @v_from_yyyymmdd :  당주 월요일
		  SELECT @v_from_yyyymmdd = BASIS_START_DATE
		  FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)  
		 WHERE  1 = 1
		   AND  BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)  
		  
		  -- @v_to_yyyymmdd: 52주차 월요일
		  SELECT @v_to_yyyymmdd = BASIS_START_DATE
		  FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)  
		 WHERE  1 = 1
	  	   AND   BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(WW, 52, CURRENT_TIMESTAMP), 112) 

		   
		SELECT T.DIVISION_ID
			 , T.PROJECT_CODE  
			 , CASE WHEN T.DIVISION_ID = '40' THEN T.PROJECT_CODE ELSE ISNULL(T1.END_CUSTOMER,'') END AS END_CUSTOMER  
	         , ISNULL(T2.PROJECT_STATUS,'') AS PROJECT_STATUS		  
	         , ISNULL(T2.BIZ_TYPE,'')       AS BIZ_TYPE_NAME
			 , CASE WHEN T.DIVISION_ID = '40' THEN T3.DEPT_ID ELSE T1.DEPT_ID END DEPT_ID
	         , ISNULL(T4.DEPT_NAME_KO,'') AS TEAM		  
	         , ISNULL(T3.OWNER,'') AS OWNER
			 , T.SCM_SITE_ID 
			 , T.PLANT_SITE_ID
			 , T.ITEM_ID  
			 , T.INCOTERMS 
			 , T.CURRENCY 
			 , T.FCST_TYPE 
			 , T.DOM_EXP 
			 , T.PRICE_EXIST
			 , LEFT(T.YYYYMMDD,6) AS YYYYMM 
		INTO #TEMP_SALES_PRICE_EXIST
		FROM ( 
				   SELECT T1.DIVISION_ID 
						, T1.PROJECT_CODE 		 
						, T1.SCM_SITE_ID 
						, T1.PLANT_SITE_ID
						, T1.ITEM_ID  
						, T1.INCOTERMS 
						, T1.CURRENCY 
						, T1.FCST_TYPE 
						, T1.DOM_EXP 
						, T1.YYYYMMDD  
		                , CASE WHEN ISNULL(SUM(CASE WHEN T1.MEASURE  = 'RTF_SYS_RP'  
						                            THEN T1.PRICE END),0) > 0 
				                AND ISNULL(SUM(CASE WHEN T1.MEASURE  = 'LOC'  
						                            THEN T1.PRICE END),0) = 0 
						 THEN 'N'
						 ELSE 'Y'
					END AS PRICE_EXIST  
					FROM (
						  SELECT A.DIVISION_ID   
								,A.PROJECT_CODE   
								,A.SCM_SITE_ID   
								,A.PLANT_SITE_ID   
								,A.ITEM_ID   
								,A.INCOTERMS   
								,A.DOM_EXP   
								,A.FCST_TYPE   
								,A.CURRENCY   
								,A.MEASURE  
								,D.BASIS_START_DATE AS YYYYMMDD   
								,SUM(A.QTY) AS PRICE     
							FROM [DM_PLN_SALES_PLAN] AS A WITH(NOLOCK)   
							JOIN SCM_MST_SITE C WITH(NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'  
							JOIN SCM_SYS_CALENDAR_M D WITH(NOLOCK) ON A.YYYYMMDD = D.BASIS_YYYYMMDD
							WHERE A.DIVISION_ID = @p_division_id
		                        AND A.YYYYMMDD >= @v_from_yyyymmdd 
		                        AND A.YYYYMMDD <  @v_to_yyyymmdd
								AND A.MEASURE = 'RTF_SYS_RP' 
								AND A.QTY <> 0
								AND A.DIVISION_ID NOT IN ('40')
							GROUP BY  A.DIVISION_ID   
								,A.PROJECT_CODE   
								,A.SCM_SITE_ID   
								,A.PLANT_SITE_ID   
								,A.ITEM_ID   
								,A.INCOTERMS   
								,A.DOM_EXP   
								,A.FCST_TYPE   
								,A.CURRENCY   
								,A.MEASURE  
								,D.BASIS_START_DATE   
					      UNION ALL
					       SELECT A.DIVISION_ID   
								,A.PROJECT_CODE   
								,A.SCM_SITE_ID   
								,A.PLANT_SITE_ID   
								,A.ITEM_ID   
								,A.INCOTERMS   
								,A.DOM_EXP   
								,A.FCST_TYPE   
								,A.CURRENCY   
								,A.MEASURE  
								,A.YYYYMMDD   
								,A.PRICE   
							FROM [SCM_MST_FUTURE_PRICE] AS A WITH(NOLOCK)   
							JOIN SCM_MST_SITE C WITH(NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'  
     					      WHERE A.DIVISION_ID = @p_division_id
		                        AND A.YYYYMMDD >= @v_from_yyyymmdd  
								AND A.YYYYMMDD <  @v_to_yyyymmdd
								AND A.MEASURE IN ('LOC') 
								AND A.DIVISION_ID NOT IN ('40')
						) T1
				GROUP BY T1.DIVISION_ID 
						, T1.PROJECT_CODE 		 
						, T1.SCM_SITE_ID 
						, T1.PLANT_SITE_ID
						, T1.ITEM_ID  
						, T1.INCOTERMS 
						, T1.CURRENCY 
						, T1.FCST_TYPE 
						, T1.DOM_EXP 
						, T1.YYYYMMDD   
		     ) T
			 LEFT OUTER JOIN
		        SCM_MST_SITE AS T1  WITH(NOLOCK)
				ON	T.DIVISION_ID = T1.DIVISION_ID
				AND T.SCM_SITE_ID = T1.SCM_SITE_ID
				AND T1.SITE_TYPE = 'SALES'
				AND T1.VALID_YN = 'Y'
			 LEFT OUTER JOIN
		         SCM_MST_PROJECT T2  WITH(NOLOCK)
				ON	T.DIVISION_ID = T2.DIVISION_ID
				AND T.PROJECT_CODE = T2.PROJECT_CODE  
			 LEFT OUTER JOIN
		         (SELECT SI.DIVISION_ID
				       , SI.PROJECT_CODE    
				       , SI.SCM_SITE_ID 
				       , SI.ITEM_ID
				       , SU.DEPT_ID 
				       , SI.OWNER 
			     	FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
					LEFT JOIN [SCM_MST_SSO_USER_INFO] SU WITH(NOLOCK)
						ON SU.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](SI.OWNER, ',')) 
			       --WHERE SI.DIVISION_ID = '40'
				   ) T3   
				ON	T.DIVISION_ID = T3.DIVISION_ID
				AND T.PROJECT_CODE = T3.PROJECT_CODE  
				AND T.SCM_SITE_ID = T3.SCM_SITE_ID  
				AND T.ITEM_ID = T3.ITEM_ID  
				--AND T.DIVISION_ID = '40'	
			 LEFT OUTER JOIN
		         SCM_MST_SSO_DEPT_INFO T4  WITH(NOLOCK)
				ON	T4.DEPT_ID  = CASE WHEN T.DIVISION_ID = '40' THEN T3.DEPT_ID ELSE T1.DEPT_ID END
		WHERE T.PRICE_EXIST = 'N' 
		--[E20240709-000783]_Sales Price 미입력 자동메일 수정요청
		AND T.FCST_TYPE NOT IN ('ASF', 'SDF', 'SMF', 'SPF', 'TST', 'WSF')
		GROUP BY T.DIVISION_ID
			 , T.PROJECT_CODE 		 
			 , T.SCM_SITE_ID 
			 , T.PLANT_SITE_ID
			 , T.ITEM_ID  
			 , T.INCOTERMS 
			 , T.CURRENCY 
			 , T.FCST_TYPE 
			 , T.DOM_EXP 
			 , T.PRICE_EXIST
	         , CASE WHEN T.DIVISION_ID = '40' THEN T.PROJECT_CODE ELSE ISNULL(T1.END_CUSTOMER,'') END 	  
	         , ISNULL(T2.PROJECT_STATUS,'')  		  
	         , ISNULL(T2.BIZ_TYPE,'') 
			 , CASE WHEN T.DIVISION_ID = '40' THEN T3.DEPT_ID ELSE T1.DEPT_ID END  
			 , ISNULL(T4.DEPT_NAME_KO,'')
	         , ISNULL(T3.OWNER,'')  
			 , LEFT(T.YYYYMMDD,6)  			    
	END
	
   PRINT ( 'A2--00--00 : ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

	-----------------------------------------------------------------------------------------------------------------------------------------  
	-- STEP 04. 메일발송 대상    
	-----------------------------------------------------------------------------------------------------------------------------------------
	BEGIN
	
		DECLARE @T_MAIL_ADDR TABLE (
		  ADDR			NVARCHAR(150)
		, OWNER_TYPE	CHAR(3)
		, SEQ			INT				IDENTITY(0,1)
		)

		INSERT INTO @T_MAIL_ADDR ( ADDR, OWNER_TYPE )
		SELECT DISTINCT B.TOKEN+'@LGENSOL.COM', 'GEN'
		FROM #TEMP_SALES_PRICE_EXIST A
		CROSS APPLY DBO.STRING_SPLIT(A.OWNER, ',') B 
		WHERE B.TOKEN IS NOT NULL

		
   PRINT ( 'A3--00--00 : ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

	-- 영업관리팀 주소 추가 ( 영업관리는 모든 데이터를 보낸다 )
	INSERT INTO @T_MAIL_ADDR ( ADDR, OWNER_TYPE )
	SELECT	  CASE WHEN [1] IS NOT NULL THEN [1]+';' ELSE '' END
		+ CASE WHEN [2] IS NOT NULL THEN [2]+';' ELSE '' END
		+ CASE WHEN [3] IS NOT NULL THEN [3]+';' ELSE '' END
		+ CASE WHEN [4] IS NOT NULL THEN [4]+';' ELSE '' END
		+ CASE WHEN [5] IS NOT NULL THEN [5]+';' ELSE '' END
		+ CASE WHEN [6] IS NOT NULL THEN [6]+';' ELSE '' END
		+ CASE WHEN [7] IS NOT NULL THEN [7]+';' ELSE '' END 
		, 'MNG'
	FROM (
		SELECT A.SEGMENT1, ROW_NUMBER() OVER ( ORDER BY DISPLAY_SEQ ) AS ROW_NUM
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
		WHERE A.LOOKUP_TYPE = 'DM_SALES_PRICE_EXIST_MAIL_ADDR'
			AND A.VALID_YN = 'Y' 
		) A
	PIVOT ( 
		MAX(SEGMENT1) FOR ROW_NUM IN ([1],[2],[3],[4],[5],[6],[7])
		) AS PVT

	END

	-----------------------------------------------------------------------------------------------------------------------------------------  
	-- STEP 05. 메일발송 - 전송대상만큼 반복 (헤더, 본문)   
	----------------------------------------------------------------------------------------------------------------------------------------- 
	BEGIN

		DECLARE   @TABLE_BODY					NVARCHAR(MAX)  
				, @v_body_contents				NVARCHAR(MAX)  
				, @v_head_cont					NVARCHAR(MAX)  
				, @v_body_cont					NVARCHAR(MAX)  
				, @v_mail_title					NVARCHAR(150)  
				, @V_OWNER						NVARCHAR(100)  
				, @V_OWNER_TYPE		            CHAR(3)
				, @V_LIKE_STRING	            NVARCHAR(100)
				, @v_cnt int
				, @v_i int
  
		DECLARE   @C_DIVISION_ID	NVARCHAR(30)  
				, @C_DEPT_NAME_KO	NVARCHAR(150)
				, @C_END_CUSTOMER	NVARCHAR(100)
				, @C_PROJECT_CODE	NVARCHAR(50) 
				, @C_PROJECT_STATUS	NVARCHAR(100)
				, @C_BIZ_TYPE_NAME	NVARCHAR(100)
				, @C_TEAM        	NVARCHAR(100) 
				, @C_INCOTERMS		NVARCHAR(10)  
				, @C_OWNER			NVARCHAR(100) 
				, @C_SCM_SITE_ID 	NVARCHAR(30)  
				, @C_PLANT_SITE_ID 	NVARCHAR(30)  
				, @C_ITEM_ID       	NVARCHAR(50)  
				, @C_DOM_EXP    	NVARCHAR(3)  
				, @C_CURRENCY     	NVARCHAR(10)  
				, @C_FCST_TYPE    	NVARCHAR(20)  
				, @C_PRICE_EXIST  	NVARCHAR(10) 
				, @C_YYYYMM  	    NVARCHAR(06)  
				
   PRINT ( 'A4--00--00 : ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

		------------------------------------------------------------------------------------------------------  
		-- STEP 05-1. 테이블 HEADER   
		------------------------------------------------------------------------------------------------------  
		SET @v_mail_title = N'주차별 판가 - Sales Price 미입력 건'  
		/* 운영용 
		SET @v_body_contents = N'안녕하십니까, SCM.DM 시스템입니다. </br> ' 
										+ N'금주 RTF 산출된 모델 중 판가가 입력되지 않은 건들에 대하여 안내드립니다. </br> ' -- CONVERT(NVARCHAR(40), GETDATE(), 120) 
										+ N'Master → Demand Master → Sales Price 화면에서 금주 버전 조회하시어, </br> '
										+ N'Sales Price가 누락된 건들에 대하여 재입력해주시기 바랍니다. </br></br>'
		*/
		/* 개발용 */
		SET @v_body_contents = N'개발시스템 TEST 진행중입니다. </br> ' 
										+ N'안녕하십니까, SCM.DM 시스템입니다.  </br> ' 
										+ N'금주 RTF 산출된 모델 중 판가가 입력되지 않은 건들에 대하여 안내드립니다. </br> ' -- CONVERT(NVARCHAR(40), GETDATE(), 120) 
										+ N'Master → Demand Master → Sales Price 화면에서 금주 버전 조회하시어, </br> '
										+ N'Sales Price가 누락된 건들에 대하여 재입력해주시기 바랍니다. </br></br>' 
	 
		SET @v_head_cont = 
		   N'<TR>  
			 <TH align = center>Div*</TH>
			 <TH align = center>Team</TH>
			 <TH>End Customer</TH>
			 <TH>Sales Site*</TH>
			 <TH>Project Code*</TH> 
			 <TH align = center>Model*</TH> 	
			 <TH>Incoterms*</TH> 	
			 <TH>FCST Type*</TH> 	
			 <TH>Customs Handbook*</TH> 	
			 <TH>Currency*</TH> 	
			 <TH>Plant Site*</TH> 		
			 <TH>Price Exist</TH> 			
			 <TH>YYYYMM</TH> 										
			</TR>'  
			 
		------------------------------------------------------------------------------------------------------  
		-- STEP 05-2. 테이블 반복 내용  
		------------------------------------------------------------------------------------------------------  
		
		SELECT @V_CNT = COUNT(*), @V_I = 0, @V_OWNER = ''
		FROM @T_MAIL_ADDR

		
   PRINT ( 'A5--00--00 : ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

		WHILE ( @V_I < @V_CNT )
		BEGIN
	
			SELECT @V_OWNER = ADDR
				 , @V_OWNER_TYPE = OWNER_TYPE
			FROM @T_MAIL_ADDR
			WHERE SEQ = @V_I

			SET @V_LIKE_STRING = CASE WHEN CHARINDEX('@', @V_OWNER) > 0 
			                          THEN LEFT(@V_OWNER, CHARINDEX('@', @V_OWNER)-1)
									  ELSE @V_OWNER					

		 END

		 
   PRINT ( 'A6--00--00 : ' + CONVERT(NVARCHAR(30), GETDATE(), 121))
			SET @v_body_cont = ''; 
			       
				-- 본문내용 생성  				
				DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
				SELECT 
					  DIVISION_ID	
					, TEAM	
					, END_CUSTOMER
					, SCM_SITE_ID		
					, PROJECT_CODE				
					, PROJECT_STATUS 
					, BIZ_TYPE_NAME 
					, ITEM_ID	
					, INCOTERMS		
					, FCST_TYPE	
					, DOM_EXP		
					, CURRENCY		
					, PLANT_SITE_ID
					, PRICE_EXIST
					, OWNER	 
					, YYYYMM
				FROM #TEMP_SALES_PRICE_EXIST
				WHERE OWNER LIKE '%' + CASE WHEN @V_OWNER_TYPE = 'GEN' THEN @V_LIKE_STRING  ELSE '' END + '%'

				
				OPEN CUR_SEND;
				
				FETCH NEXT FROM CUR_SEND 
				 INTO @C_DIVISION_ID, @C_DEPT_NAME_KO, @C_END_CUSTOMER, @C_SCM_SITE_ID, @C_PROJECT_CODE, @C_PROJECT_STATUS
					, @C_BIZ_TYPE_NAME, @C_ITEM_ID, @C_INCOTERMS, @C_FCST_TYPE, @C_DOM_EXP, @C_CURRENCY, @C_PLANT_SITE_ID
					, @C_PRICE_EXIST, @C_OWNER, @C_YYYYMM
					    

				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ N'<TR>'
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_DIVISION_ID, '') + N'</TD>'
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_DEPT_NAME_KO, '') + N'</TD>'
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_END_CUSTOMER, '') + N'</TD>'
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_SCM_SITE_ID, '') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_PROJECT_CODE, '') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_ITEM_ID, '') + N'</TD>'  
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_INCOTERMS, '') + N'</TD>'
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_FCST_TYPE, '') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_DOM_EXP, '') + N'</TD>'
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_CURRENCY, '') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_PLANT_SITE_ID, '') + N'</TD>'
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_PRICE_EXIST, '') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_YYYYMM, '') + N'</TD>'  	 	
					SET @v_body_cont = @v_body_cont+ N'</TR>'
		
				FETCH NEXT FROM CUR_SEND 
				 INTO @C_DIVISION_ID, @C_DEPT_NAME_KO, @C_END_CUSTOMER, @C_SCM_SITE_ID, @C_PROJECT_CODE, @C_PROJECT_STATUS
					, @C_BIZ_TYPE_NAME, @C_ITEM_ID, @C_INCOTERMS, @C_FCST_TYPE, @C_DOM_EXP, @C_CURRENCY, @C_PLANT_SITE_ID
					, @C_PRICE_EXIST, @C_OWNER , @C_YYYYMM

				END
	
				CLOSE CUR_SEND;
				DEALLOCATE CUR_SEND;
				   

				SET @TABLE_BODY = N' <html>  
														<head>  
															<title>Untitled Document</title>  
															<style>  
																* {margin:0;padding:0;}  
																body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}  
																table {border-collapse:collapse;width:100%;}  
																table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}  
																table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}  
																table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}  
																table tbody td {padding:6px 8px;font-size:12px}  
																table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}  
																.hori-table table thead td {text-align:center;padding:3px;}    
																.hori-table table tbody td {text-align:center;padding:3px;}  
																.vertical-table, .hori-table {margin-bottom:20px;}  
															</style>  
														</head>  
														<body></br><b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), N'<br>') + N'</b>'  
															+ N'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'  
															+ N'<table style=''border-top:2px solid #c8294b; width:1450px;''>  
															<thead>' + ISNULL(@v_head_cont,'') + N'</thead>  
															<tbody>' + ISNULL(@v_body_cont, '') + N'</tbody>  
															</div>  
														</body>  
												   </html>';  

				------------------------------------------------------------------------------------------------------  
				-- STEP 05-3. Mail 전송  
				------------------------------------------------------------------------------------------------------  
				 
   PRINT ( 'A7--00--00 : ' + CONVERT(NVARCHAR(30), GETDATE(), 121))
			--[E20240709-000783]_Sales Price 미입력 자동메일 수정요청
   			IF (SELECT COUNT(*) FROM #TEMP_SALES_PRICE_EXIST) > 0
			BEGIN
				IF @V_OWNER_TYPE = 'MNG'	-- 영업관리팀
				BEGIN  
						EXEC SCM_ADM_MAIL_SEND @V_OWNER, @v_mail_title, @TABLE_BODY, 'Y'  	
						PRINT 2;
				END
				ELSE
				BEGIN
					-- 현업한테 가는 메일은 운영일 경우에만 발송함.
					IF DB_NAME() <> 'LGCE_SCMDEV'
					BEGIN 
						--EXEC SCM_ADM_MAIL_SEND @V_OWNER, @v_mail_title, @TABLE_BODY, 'Y' 
						PRINT 3;
					END
				END 
					--MAIL 발송 LOG 저장
				EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
					'MAIL'
					, '-'
					, @v_program_name
					, @V_OWNER
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, '' --p_send_pgm
					,  ''
				;
			END


			/*
			IF ( @V_I % 5 IN ( 0, 5 ))
				BEGIN  
					WAITFOR DELAY '00:00:30'  
				END
			*/

			SET @V_I = @V_I + 1
		END			 
	END			 

END TRY  
   
BEGIN CATCH   

  SET @v_log_type = 'ERROR';  
  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());  
  SET @d_event_date = SYSDATETIME();  
    
  SELECT @v_log_message   
  
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
  
END CATCH  
  
   
 -- 종료 LOG  
 SET @v_log_type = 'END';  
 SET @v_log_message = '##### END of procedure #####';  
 SET @v_description = N'EDI ERP정비 데이터 메일 발송';  
 SET @d_event_date = SYSDATETIME();  
 EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
  
  
  
