

/*      
 * Program ID   : [SCP0075_GET_ALLO_TARGET_SMALL]  
 * Description  : Allo Target UI리포트용
 * Program History      
 *===================================================================================================      
 *   Date	    	In Charge	    Description      
 *===================================================================================================      
 * 2021/10/18   hongju.lee		Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) 
 * 2021/11/08   hongju.lee		Cutoff기준 현재월의 PLAN, RESULT의 RATE(%) 는 제외함.
 * 2022/02/11   LWY    		    추가개선 사항 반영 : deptname SCM_MST_SSO_DEPT_INFO 기준 변경
  * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장

DECLARE	@return_value int
		EXEC	@return_value = [dbo].[SCP0075_GET_ALLO_TARGET_SMALL]
		@P_DIVISION_ID = N'40',
		@P_CUTOFF_YYYYMMDD    = N'20211129',
		@P_ITEM_ID = NULL,
		@P_NICK_NAME = 'MH1',
		@P_TEAM_ID = NULL
SELECT	'Return Value' = @return_value
GO

DECLARE
 @P_DIVISION_ID		NVARCHAR(2) = '40'
,@P_CUTOFF_YYYYMMDD	NVARCHAR(8) = '20211220'
,@P_ITEM_ID         NVARCHAR(200) = '' --MODEL
,@P_NICK_NAME       NVARCHAR(200) = 'C4'
,@P_TEAM_ID         NVARCHAR(200) = ''
,@P_FROM_YYYYMM		NVARCHAR(6) = '202110'
,@P_TO_YYYYMM		NVARCHAR(6) = '202210'

 */ 
 
CREATE PROCEDURE [dbo].[SCP0075_GET_ALLO_TARGET_SMALL]
--chaan  , @P_DIVISION_ID            NVARCHAR(2)
     @P_DIVISION_ID                 NVARCHAR(30)--chaan
	,@P_CUTOFF_YYYYMMDD			    NVARCHAR(8)
	,@P_ITEM_ID                     NVARCHAR(200)
	--,@P_FROM_SITE                 NVARCHAR(100)
	,@P_NICK_NAME                   NVARCHAR(100)
	,@P_TEAM_ID                     NVARCHAR(100)
	,@P_FROM_YYYYMM					NVARCHAR(6)
	,@P_TO_YYYYMM					NVARCHAR(6)

AS      
BEGIN      
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	PRINT 'All Start. '+CONVERT(CHAR(23), GETDATE(), 21)
		
	DECLARE @V_THIS_YYYYMM     AS NVARCHAR(8)='';  -- CUTOFF기준 올해 YYYYMM
	DECLARE @V_NEXT_YEAR   		  AS NVARCHAR(8)='';

	DECLARE @MEXEC NVARCHAR(MAX);
	DECLARE @POS INT =1;
	DECLARE @LEN INT =LEN(@mEXEC);													
	DECLARE @debug_mode NVARCHAR(1)= 'T';

	DECLARE @mQry_sub NVARCHAR(MAX); 
	DECLARE @mQry_bp_sub NVARCHAR(MAX); 

	DECLARE @mQry_sum NVARCHAR(MAX);
    
	DECLARE @V_BP_YYYYMM AS NVARCHAR(6); -- 현재일 기준 18개월 뒤
	DECLARE @V_CUR_YYYYMM AS NVARCHAR(6); -- 현재월
	DECLARE @V_LAST_YYYYMM AS NVARCHAR(6); -- 지난주 월
	DECLARE @LAST_CUTOFF_YYYYMMDD  AS NVARCHAR(8); -- 지난주 CUTOFF일자
	DECLARE @CUTOFF_YYYYMMDD  AS NVARCHAR(8); --현재 CUTOFF일자

	SET @MEXEC = '';

    -- @P_TO_YYYYMMDD 기준 최근 월요일 구하기    -- TYPE = 'PLAN'의  CUTOFF_YYYYMMDD로 사용
     
	SELECT @CUTOFF_YYYYMMDD = MAX(C.BASIS_YYYYMMDD)       
         	 -- , MAX(DATEPART(WEEKDAY, BASIS_YYYYMMDD)) AS DAYIDX
	FROM SCM_SYS_CALENDAR_M C WITH(NOLOCK)
	 WHERE 1=1 
	     AND C.BASIS_YYYYMMDD <= @P_CUTOFF_YYYYMMDD
	     AND C.BASIS_YYYYMMDD <= CONVERT(VARCHAR, GETDATE(), 112)
	     AND DATEPART(WEEKDAY, C.BASIS_YYYYMMDD) = 2 --1:SUN, 2:MON	
		 

     -- 최근(지난주) Cutoff일자 구하기
     SELECT @LAST_CUTOFF_YYYYMMDD = ISNULL(MAX(CUTOFF_YYYYMMDD), @CUTOFF_YYYYMMDD)
	    FROM SCP_ANL_ALLO_TARGET WITH(NOLOCK)
	  WHERE DIVISION_ID = @P_DIVISION_ID
	      AND CUTOFF_YYYYMMDD < @CUTOFF_YYYYMMDD
	      AND TYPE = 'RESULT'


    -- CUTOFF 일자는 월요일 기준임으로 하루전인 일요일 기준으로 월을 계사함.
	SELECT @V_BP_YYYYMM     = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 18, DATEADD(DAY,0,convert(datetime,@CUTOFF_YYYYMMDD))), 112),1,6), -- 현재월 18개월뒤
	            @V_CUR_YYYYMM   = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, DATEADD(DAY,0,convert(datetime,@CUTOFF_YYYYMMDD))), 112),1,6), --Cutoff기준(월) 현재월
				@V_LAST_YYYYMM  = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, DATEADD(DAY,0,convert(datetime,@LAST_CUTOFF_YYYYMMDD))), 112),1,6), --Last_Cutoff기준 현재월
				@V_THIS_YYYYMM = SUBSTRING(@CUTOFF_YYYYMMDD,1,4) + '01',
				@V_NEXT_YEAR =  SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 12, DATEADD(DAY,0,convert(datetime,@CUTOFF_YYYYMMDD))), 112),1,4);
				--SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, convert(datetime,'20210425')), 112),1,6)
			
	PRINT '-------------RESULT SEARCH'
	print CONVERT(CHAR(23), getdate(), 21)
	
	SET @mQry_sub = '';

	SELECT @mQry_sub = @mQry_sub+','+  A.COLUMN1
		FROM
		(     /*  SORTORDER   RESULT, PLAN  TOTAL   
										MONTH  QUARTER
			*/
			-- 과거 RESULT
			SELECT   
							SORT_ORDER_NO,
							CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyymm = RIGHT('''+yyyymmdd+''',6) AND  TYPE = ''RESULT'' THEN CONVERT(NUMERIC(20,4), ISNULL(QTY, 0)) END ) AS ' + yyyymmdd  +'_RESULT'    
							END +''+CHAR(10) 
							AS COLUMN1
			FROM (  
						SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
							,MIN(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '00')   AS SORT_ORDER_NO      
						FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						WHERE -- A.BASIS_YYYYMM  BETWEEN '202101' AND '202103'
									A.BASIS_YYYYMM >= @V_THIS_YYYYMM   
							AND A.BASIS_YYYYMM < @V_CUR_YYYYMM					
							--AND A.BASIS_YYYYMM NOT IN ( @V_LAST_YYYYMM)
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
					) AS A      
					UNION 
					-- 현재월 해당하는 월의 PLAN
					SELECT  
									SORT_ORDER_NO,
									CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyymm = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''PLAN'' THEN CONVERT(NUMERIC(20,4), ISNULL(QTY, 0)) END ) AS ' + yyyymmdd  +'_PLAN'    
           									--WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyyqq = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''PLAN'' THEN QTY END ) AS ' + yyyymmdd    +'_PLAN'    
								END +''+CHAR(10) 
								AS COLUMN1
					FROM (  
						SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
									,MIN(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '10')   AS SORT_ORDER_NO      
						FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						WHERE A.BASIS_YYYYMM IN ( @V_CUR_YYYYMM )
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
					) AS B1
					UNION 
					-- 현재월 해당하는 월의 RESULT
					SELECT  
									SORT_ORDER_NO,
									CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyymm = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''RESULT'' THEN CONVERT(NUMERIC(20,4), ISNULL(QTY, 0)) END ) AS ' + yyyymmdd  +'_RESULT'    
           									--WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyyqq = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''RESULT'' THEN QTY END ) AS ' + yyyymmdd    +'_RESULT'    
								END +''+CHAR(10) 
								AS COLUMN1
					FROM (  							
						SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
									,MIN(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '00')   AS SORT_ORDER_NO      
						FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						WHERE A.BASIS_YYYYMM IN (  @V_CUR_YYYYMM )
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
					
					) AS B2       
						UNION 
					-- 현재월 해당하는 월의 TOTAL
					SELECT  
									SORT_ORDER_NO,
									CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyymm = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''NULL'' THEN CONVERT(NUMERIC(20,4), ISNULL(QTY, 0)) END ) AS ' + yyyymmdd  +'_TOTAL'    
           									--WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyyqq = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''NULL'' THEN QTY END ) AS ' + yyyymmdd    +'_TOTAL'    
								END +''+CHAR(10) 
								AS COLUMN1
					FROM (   
						SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
									,MIN(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '30')   AS SORT_ORDER_NO      
						FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						WHERE A.BASIS_YYYYMM IN (  @V_CUR_YYYYMM )
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
					) AS B3       
					UNION 
					-- 미래 PLAN
					SELECT 
									SORT_ORDER_NO,
									CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyymm = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''PLAN'' THEN CONVERT(NUMERIC(20,4), ISNULL(QTY, 0)) END ) AS ' + yyyymmdd  +'_PLAN'    
           									--WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyyqq = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''PLAN'' THEN QTY END ) AS ' + yyyymmdd    +'_PLAN'    
								END +''+CHAR(10) 
								AS COLUMN1
					FROM (  
						SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
									,MIN(A.BASIS_YYYYMM)  + CONVERT(CHAR(2), '10') AS SORT_ORDER_NO      
						FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						WHERE -- A.BASIS_YYYYMM  BETWEEN '202106' AND '202212' @V_NEXT_YEAR
										A.BASIS_YYYYMM > @V_CUR_YYYYMM 
								AND A.BASIS_YYYYMM <= @V_NEXT_YEAR + '12'
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME 
					) AS C
					UNION 
					-- PLAN 분기 추가
					SELECT  
									SORT_ORDER_NO,
									CASE WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyyqq = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''PLAN'' THEN CONVERT(NUMERIC(20,4), ISNULL(QTY, 0)) END ) AS ' + yyyymmdd    +'_PLAN'    
								END +''+CHAR(10) 
								AS COLUMN1
						FROM (
									SELECT TOP 10 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD  -- PLAN
												--,MAX(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '51')   AS SORT_ORDER_NO      
											   ,(SELECT MAX(B.BASIS_YYYYMM)+ CONVERT(CHAR(2), '51') AS SORT
													FROM [DBO].[SCM_SYS_CALENDAR_M] B       
												 WHERE B.CALENDAR_YYYYQQ = A.CALENDAR_YYYYQQ
											    ) AS SORT_ORDER_NO
										FROM [DBO].[SCM_SYS_CALENDAR_M] A       
									WHERE A.BASIS_YYYYMM > @V_CUR_YYYYMM 
										AND A.BASIS_YYYYMM <= @V_NEXT_YEAR + '12'
									GROUP BY A.CALENDAR_YYYYQQ 
						) AS D
						UNION 
					-- RESULT 분기 추가
					SELECT  
									SORT_ORDER_NO,
									CASE WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  SUM(CASE WHEN  yyyyqq = RIGHT('''+yyyymmdd+''',6)  AND  TYPE = ''RESULT'' THEN CONVERT(NUMERIC(20,4), ISNULL(QTY, 0)) END ) AS ' + yyyymmdd    +'_RESULT'
								END +''+CHAR(10) 
								AS COLUMN1
						FROM (
						  			SELECT TOP 10 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD  -- RESULT
												--,MAX(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '41')   AS SORT_ORDER_NO      
											   ,(SELECT MAX(B.BASIS_YYYYMM)+ CONVERT(CHAR(2), '41') AS SORT
													FROM [DBO].[SCM_SYS_CALENDAR_M] B       
												 WHERE B.CALENDAR_YYYYQQ = A.CALENDAR_YYYYQQ
											    ) AS SORT_ORDER_NO
									FROM [DBO].[SCM_SYS_CALENDAR_M] A       
									WHERE A.BASIS_YYYYMM >= @V_THIS_YYYYMM   
										AND A.BASIS_YYYYMM <= @V_CUR_YYYYMM	
									GROUP BY A.CALENDAR_YYYYQQ 
						) AS E
		) A
		ORDER BY A.SORT_ORDER_NO  ;  
		
		BEGIN
			SELECT @mQry_bp_sub  =  REPLACE(REPLACE(@mQry_sub, 'TYPE = ''RESULT''', 'TYPE = ''BP'''),'TYPE = ''PLAN''','TYPE = ''BP''' )
		END;

		SET @mQry_sum = '';

		IF OBJECT_ID('tempdb..#SUM') IS NOT NULL	
		DROP TABLE #SUM;
		
		SELECT A.* 
	       INTO #SUM
	     FROM
		 (
			    -- 과거 RESULT
				SELECT  
				             SORT_ORDER_NO,
							 CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_RESULT) ,0) AS ' + YYYYMMDD  +'_RESULT'
           							  WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_RESULT) ,0) AS ' + YYYYMMDD  +'_RESULT'
					         END +''+CHAR(10) 
							 AS COLUMN1, YYYYMMDD  +'_RESULT' AS COLUMN2
				FROM (  
							SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
								,MIN(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '01')   AS SORT_ORDER_NO      
							FROM [DBO].[SCM_SYS_CALENDAR_M] A       
							WHERE A.BASIS_YYYYMM >= @V_THIS_YYYYMM   
								AND A.BASIS_YYYYMM < @V_CUR_YYYYMM			
								--AND A.BASIS_YYYYMM NOT IN ( @V_LAST_YYYYMM)
							GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
						) AS A      
					   UNION 
						-- 현재월의 PLAN
						SELECT  
									 SORT_ORDER_NO,
									 CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_PLAN) ,0) AS '  + YYYYMMDD  +'_PLAN'
           								      WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_PLAN) ,0) AS ' + YYYYMMDD  +'_PLAN'
									END +''+CHAR(10) 
									AS COLUMN1, YYYYMMDD  +'_PLAN' AS COLUMN2
						FROM (  
							SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
								      ,MIN(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '10')   AS SORT_ORDER_NO      
							FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						  WHERE A.BASIS_YYYYMM IN ( @V_CUR_YYYYMM )
							GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
						) AS B1
						UNION ALL
						-- 현재월의 RESULT
						SELECT  
									 SORT_ORDER_NO,
									 CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_RESULT) ,0) AS ' + YYYYMMDD  +'_RESULT'
           							          WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_RESULT) ,0) AS ' + YYYYMMDD  +'_RESULT'
									END +''+CHAR(10) 
									AS COLUMN1, YYYYMMDD  +'_RESULT' AS COLUMN2
						FROM (  
					  	  SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
								      ,MIN(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '00')   AS SORT_ORDER_NO      
									    -- ,(SELECT MIN(B.BASIS_YYYYMM)+ CONVERT(CHAR(2), '00') AS SORT
													--FROM [DBO].[SCM_SYS_CALENDAR_M] B       
												 --WHERE B.CALENDAR_YYYYQQ = A.CALENDAR_YYYYQQ
										   -- ) AS SORT_ORDER_NO
							FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						  WHERE A.BASIS_YYYYMM IN ( @V_CUR_YYYYMM )
							GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
						) AS B2       
							UNION 
						-- 현재월하는 월의 RESULT
						SELECT  
									 SORT_ORDER_NO,
									 CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_TOTAL) ,0) AS ' + YYYYMMDD  +'_TOTAL'
           							          WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_TOTAL) ,0) AS ' + YYYYMMDD  +'_TOTAL'
									END +''+CHAR(10) 
									AS COLUMN1, YYYYMMDD  +'_TOTAL' AS COLUMN2
						FROM (  
				  		  SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
								      ,MIN(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '20')   AS SORT_ORDER_NO      
							FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						  WHERE A.BASIS_YYYYMM IN ( @V_CUR_YYYYMM )
							GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
						) AS B3
						UNION 
						-- 미래 PLAN
						SELECT  --@mQry_sub = @mQry_sub+','+ 
									 SORT_ORDER_NO,
									 CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_PLAN) ,0) AS ' + YYYYMMDD  +'_PLAN'
									END +''+CHAR(10) 
									AS COLUMN1, YYYYMMDD  +'_PLAN' AS COLUMN2
						FROM (  
							SELECT TOP 30 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
									 ,MIN(A.BASIS_YYYYMM)  + CONVERT(CHAR(2), '10') AS SORT_ORDER_NO      
							FROM [DBO].[SCM_SYS_CALENDAR_M] A       
							WHERE  A.BASIS_YYYYMM > @V_CUR_YYYYMM 
							     AND A.BASIS_YYYYMM <= @V_NEXT_YEAR + '12'
							GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME        
						) AS C
						UNION 
						-- PLAN 분기 추가
						SELECT  SORT_ORDER_NO,
									 CASE WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_PLAN) ,0)  AS ' + YYYYMMDD  +'_PLAN'
									END +''+CHAR(10) 
									AS COLUMN1, YYYYMMDD  +'_PLAN' AS COLUMN2
						  FROM (
									  SELECT TOP 10 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD  -- PLAN
												  --,MAX(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '51')   AS SORT_ORDER_NO      
												  ,(SELECT MAX(B.BASIS_YYYYMM)+ CONVERT(CHAR(2), '51') AS SORT
													FROM [DBO].[SCM_SYS_CALENDAR_M] B       
												  WHERE B.CALENDAR_YYYYQQ = A.CALENDAR_YYYYQQ
										          ) AS SORT_ORDER_NO
										 FROM [DBO].[SCM_SYS_CALENDAR_M] A       
									   WHERE A.BASIS_YYYYMM > @V_CUR_YYYYMM 
										   AND A.BASIS_YYYYMM <= @V_NEXT_YEAR + '12'
										GROUP BY A.CALENDAR_YYYYQQ 
						  ) AS D
						  UNION 
						-- RESULT 분기 추가
						SELECT  SORT_ORDER_NO,
									 CASE WHEN CHARINDEX('Q_', YYYYMMDD) =1 THEN '  ISNULL(SUM('+YYYYMMDD+'_RESULT) ,0)  AS ' + YYYYMMDD  +'_RESULT'
									END +''+CHAR(10) 
									AS COLUMN1, YYYYMMDD  +'_RESULT'
						  FROM (
						  			  SELECT TOP 10 'Q_'+A.CALENDAR_YYYYQQ  AS YYYYMMDD  -- RESULT
													--,MAX(A.BASIS_YYYYMM) + CONVERT(CHAR(2), '41')   AS SORT_ORDER_NO      
												,(SELECT MAX(B.BASIS_YYYYMM)+ CONVERT(CHAR(2), '41') AS SORT
													 FROM [DBO].[SCM_SYS_CALENDAR_M] B       
												  WHERE B.CALENDAR_YYYYQQ = A.CALENDAR_YYYYQQ
										          ) AS SORT_ORDER_NO
										FROM [DBO].[SCM_SYS_CALENDAR_M] A       
								  	  WHERE A.BASIS_YYYYMM >= @V_THIS_YYYYMM   
										  AND A.BASIS_YYYYMM <= @V_CUR_YYYYMM	
									  GROUP BY A.CALENDAR_YYYYQQ 
						  ) AS E
		) A
		ORDER BY A.SORT_ORDER_NO; 
		
		
		--	현재월의 PLAN, RESULT의 RATE(%) 는 제외함.
		SELECT @mQry_sum = @mQry_sum+','+  A.COLUMN1
		   FROM 
		   (
			 SELECT  A.SORT_ORDER_NO, 
						  CASE WHEN TYPE = 'PER' THEN SUBSTRING(A.COLUMN1 , 1, LEN(A.COLUMN1)-1)+'_RATE' 
								   ELSE COLUMN1
						   END AS COLUMN1
			  FROM (
						 SELECT 'PER' AS TYPE 
									 , A.SORT_ORDER_NO + '2' AS SORT_ORDER_NO 
									 --, '0 ' + SUBSTRING(A.COLUMN1, CHARINDEX('AS', A.COLUMN1) , LEN(A.COLUMN1))   AS  COLUMN1 
									 , 'CONVERT(NUMERIC(20,4),  0) ' + SUBSTRING(A.COLUMN1, CHARINDEX('AS', A.COLUMN1) , LEN(A.COLUMN1))   AS  COLUMN1 
						   FROM  #SUM A
                          WHERE COLUMN2 NOT IN ( 'M_' + @V_CUR_YYYYMM  +  '_PLAN', 'M_' + @V_CUR_YYYYMM + '_RESULT')
						  UNION
						 SELECT 'NOR' AS TYPE, A.SORT_ORDER_NO + '1' AS SORT_ORDER_NO,  COLUMN1     
						   FROM  #SUM A
				  ) A

			 WHERE 1 = 1
			   AND SUBSTRING(A.SORT_ORDER_NO,1,6) BETWEEN @P_FROM_YYYYMM AND @P_TO_YYYYMM

		 ) A
		   ORDER BY  A.SORT_ORDER_NO  ;  
     
	 --SELECT  'M_' + @V_CUR_YYYYMM  +  '_PLAN', 'M_' + @V_CUR_YYYYMM + '_RESULT'

	--BEGIN				
	--	SET @POS =1;
	--	SET @LEN =LEN(@mQry_sum);
	--	WHILE @POS <= @LEN
	--		BEGIN
	--			PRINT SUBSTRING(@mQry_sum,@POS,4000);
	--			SET @POS = @POS+4000;
	--		END;
	--END;
	

	SET @MEXEC = @MEXEC+'  SELECT      A.DIVISION_ID,										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.EXTRA_SPEC,										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			   A.DEPT_ID,												' + CHAR(10);
	
	--SET @MEXEC = @MEXEC+'		   	   A.DEPT_NAME,										' + CHAR(10);
	SET @MEXEC = @MEXEC+'		   	   (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID) AS DEPT_NAME,		' + CHAR(10);

	SET @MEXEC = @MEXEC+'			   A.MODEL,												' + CHAR(10);
	SET @MEXEC = @MEXEC+'            A.CUTOFF_YYYYMMDD,							' + CHAR(10);	
	SET @MEXEC = @MEXEC+'			   A.ITEM_ID,												' + CHAR(10);	
	SET @MEXEC = @MEXEC+'			   A.SORT_ORDER										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			  ' +@mQry_sum+ '									'+ CHAR(10);
	SET @MEXEC = @MEXEC+'	FROM (                                                             ' + CHAR(10);
	SET @MEXEC = @MEXEC+'             SELECT DIVISION_ID,				    	    ' + CHAR(10);
    SET @MEXEC = @MEXEC+'                         CASE WHEN TYPE = ''BP'' THEN ''BP''  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           			             ELSE CUTOFF_YYYYMMDD       ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           					 END AS CUTOFF_YYYYMMDD,      ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           					 MAX(CASE WHEN TYPE = ''BP'' THEN ISNULL(EXTRA_SPEC,''ZZZ'') + ITEM_ID   + NICK_NAME + ISNULL(DEPT_ID,''ZZZ'') + ''00''+ CUTOFF_YYYYMMDD + ''1''  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           					                  ELSE                              ISNULL(EXTRA_SPEC,''ZZZ'') + ITEM_ID   + NICK_NAME + ISNULL(DEPT_ID,''ZZZ'') + CUTOFF_YYYYMMDD + ''2''            ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           					 END) AS SORT_ORDER,         ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							YYYY,								           ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							YYYYMM,	    				           ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							ITEM_ID,								   ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							DEPT_ID,                                 ' + CHAR(10);
	--SET @MEXEC = @MEXEC+'							DEPT_NAME,                            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							(SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID) AS DEPT_NAME,                            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							NICK_NAME AS MODEL,            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							EXTRA_SPEC 					          ' + CHAR(10);
	SET @mEXEC = @mEXEC + ' 				' + @mQry_sub +'									                                                                    ' + CHAR(10);	
	SET @MEXEC = @MEXEC+'					FROM SCP_ANL_ALLO_TARGET  A   WITH(NOLOCK)                                                                              ' + CHAR(10);
	SET @MEXEC = @MEXEC+'					WHERE DIVISION_ID = ''' + @p_division_id + '''                                                          ' +  CHAR(10);
	SET @MEXEC = @MEXEC+'					  AND ( ( TYPE = ''BP'' AND CUTOFF_YYYYMMDD !=''EMPTY'') OR CUTOFF_YYYYMMDD IN ( ''' + @LAST_CUTOFF_YYYYMMDD + ''',''' +  @CUTOFF_YYYYMMDD + '''    )) '+  CHAR(10);
	IF @P_ITEM_ID IS NOT NULL SET @mEXEC = @mEXEC+' 	                  AND (( ''' + @P_ITEM_ID + '''   IS NULL OR ''' + @P_ITEM_ID + ''' ='''')   OR ITEM_ID  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@P_ITEM_ID+''' , '',''))) ' + char(10);	
	--IF @P_FROM_SITE IS NOT NULL SET @mEXEC = @mEXEC+' 	                  AND (( ''' + @P_FROM_SITE + '''   IS NULL OR ''' + @P_FROM_SITE + ''' ='''')   OR SCM_SITE_ID  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@P_FROM_SITE+''' , '',''))) ' + char(10);	
    IF @P_NICK_NAME IS NOT NULL SET @mEXEC = @mEXEC+' 	                  AND (( ''' + @P_NICK_NAME + '''   IS NULL OR ''' + @P_NICK_NAME + ''' ='''')   OR NICK_NAME  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@P_NICK_NAME+''' , '',''))) ' + char(10);	
	IF @P_TEAM_ID IS NOT NULL SET @mEXEC = @mEXEC+' 	                  AND (( ''' + @P_TEAM_ID + '''   IS NULL OR ''' + @P_TEAM_ID + ''' ='''')   OR DEPT_ID  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@P_TEAM_ID+''' , '',''))) ' + char(10);	
	SET @MEXEC = @MEXEC+'					GROUP BY DIVISION_ID, CUTOFF_YYYYMMDD,																						' +  CHAR(10);
	SET @MEXEC = @MEXEC+'							 CASE WHEN TYPE = ''BP'' THEN ''BP'' ELSE CUTOFF_YYYYMMDD END,					' +  CHAR(10);
	SET @MEXEC = @MEXEC+'							        CUTOFF_YYYYMMDD, YYYY, YYYYMM,  ITEM_ID, DEPT_ID ,DEPT_NAME, NICK_NAME, EXTRA_SPEC	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			    UNION										        	' + CHAR(10);
	--BP 추가
	SET @MEXEC = @MEXEC+'             SELECT DIVISION_ID,				    	    ' + CHAR(10);
    SET @MEXEC = @MEXEC+'                         CASE WHEN TYPE = ''BP'' THEN ''BP''  ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           			             ELSE CUTOFF_YYYYMMDD       ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           					 END AS CUTOFF_YYYYMMDD,      ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           					 MAX(CASE WHEN TYPE = ''BP'' THEN ISNULL(EXTRA_SPEC,''ZZZ'') + ITEM_ID   + NICK_NAME + ISNULL(DEPT_ID,''ZZZ'') + ''00''+ CUTOFF_YYYYMMDD + ''1''   ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           					                  ELSE                              ISNULL(EXTRA_SPEC,''ZZZ'') + ITEM_ID   + NICK_NAME + ISNULL(DEPT_ID,''ZZZ'') + CUTOFF_YYYYMMDD + ''2''             ' + CHAR(10);
    SET @MEXEC = @MEXEC+'           					 END) AS SORT_ORDER,         ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							YYYY,								           ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							YYYYMM,	    				           ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							ITEM_ID,								   ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							DEPT_ID,                                 ' + CHAR(10);
	--SET @MEXEC = @MEXEC+'							DEPT_NAME,                            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							(SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID) AS DEPT_NAME,                            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							NICK_NAME AS MODEL,            ' + CHAR(10);
	SET @MEXEC = @MEXEC+'							EXTRA_SPEC 					          ' + CHAR(10);
	SET @mEXEC = @mEXEC + ' 				' + @mQry_bp_sub +'									                                                                    ' + CHAR(10);	
	SET @MEXEC = @MEXEC+'					FROM SCP_ANL_ALLO_TARGET  A    WITH(NOLOCK)                                                                             ' + CHAR(10);
	SET @MEXEC = @MEXEC+'					WHERE DIVISION_ID = ''' + @p_division_id + '''                                                          ' +  CHAR(10);
	SET @MEXEC = @MEXEC+'					  AND ( ( TYPE = ''BP'' AND CUTOFF_YYYYMMDD !=''EMPTY'') OR CUTOFF_YYYYMMDD IN ( ''' + @LAST_CUTOFF_YYYYMMDD + ''',''' +  @CUTOFF_YYYYMMDD + '''    )) '+  CHAR(10);
	IF @P_ITEM_ID IS NOT NULL SET @mEXEC = @mEXEC+' 	                  AND (( ''' + @P_ITEM_ID + '''   IS NULL OR ''' + @P_ITEM_ID + ''' ='''')   OR ITEM_ID  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@P_ITEM_ID+''' , '',''))) ' + char(10);	
    --IF @P_FROM_SITE IS NOT NULL SET @mEXEC = @mEXEC+' 	                  AND (( ''' + @P_FROM_SITE + '''   IS NULL OR ''' + @P_FROM_SITE + ''' ='''')   OR SCM_SITE_ID  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@P_FROM_SITE+''' , '',''))) ' + char(10);
	IF @P_NICK_NAME IS NOT NULL SET @mEXEC = @mEXEC+' 	                  AND (( ''' + @P_NICK_NAME + '''   IS NULL OR ''' + @P_NICK_NAME + ''' ='''')   OR NICK_NAME  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@P_NICK_NAME+''' , '',''))) ' + char(10);	
	IF @P_TEAM_ID IS NOT NULL SET @mEXEC = @mEXEC+' 	                  AND (( ''' + @P_TEAM_ID + '''   IS NULL OR ''' + @P_TEAM_ID + ''' ='''')   OR DEPT_ID  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@P_TEAM_ID+''' , '',''))) ' + char(10);	
	SET @MEXEC = @MEXEC+'					GROUP BY DIVISION_ID, CUTOFF_YYYYMMDD,																						' +  CHAR(10);
	SET @MEXEC = @MEXEC+'							 CASE WHEN TYPE = ''BP'' THEN ''BP'' ELSE CUTOFF_YYYYMMDD END,					' +  CHAR(10);
	SET @MEXEC = @MEXEC+'							        CUTOFF_YYYYMMDD, YYYY, YYYYMM,  ITEM_ID, DEPT_ID ,DEPT_NAME, NICK_NAME, EXTRA_SPEC	' + CHAR(10);



	SET @MEXEC = @MEXEC+'	        )  A   																																								' + CHAR(10);
	SET @MEXEC = @MEXEC+'		GROUP BY DIVISION_ID, CUTOFF_YYYYMMDD, SORT_ORDER, ITEM_ID, DEPT_ID ,DEPT_NAME, MODEL, EXTRA_SPEC	' + CHAR(10);
	SET @MEXEC = @MEXEC+'  	ORDER BY SORT_ORDER                                ' + CHAR(10);
	
	
	--IF( @debug_mode ='T')
	--BEGIN				
	--	SET @POS =1;
	--	SET @LEN =LEN(@MEXEC);
	--	WHILE @POS <= @LEN
	--		BEGIN
	--			PRINT SUBSTRING(@MEXEC,@POS,4000);
	--			SET @POS = @POS+4000;
	--		END;
	--END;

	-- xml 로 print
	--SELECT CAST('<root><![CDATA[' + @MEXEC + ']]></root>' AS XML);
	
	EXEC (@MEXEC);
	
	
END 


