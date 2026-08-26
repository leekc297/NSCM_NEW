                                                                                                                                                                             

                                                                                               

                                                                                                        

                                                                           

                                                                                            

                                                                                                    

                                                                                                                                                       

                                                                                               

                                                                                                                                                       

                          

                                                                                                                                                      



CREATE PROCEDURE [dbo].[DMF0082_GET_EXCEL_UPLOAD_DATA]

	@p_created_by  NVARCHAR(150)		

AS  



BEGIN



    SET NOCOUNT ON;



    DECLARE @v_program_id     AS NVARCHAR(40) = 'DMF0082';

    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'FcstNPrice';	

	DECLARE @v_creation_date  AS NVARCHAR(40);

	DECLARE @v_start_yyyymm	  AS NVARCHAR(6) = FORMAT(DATEADD(MONTH, 4, GETDATE()), 'yyyyMM');

	DECLARE @v_end_yyyymm	  AS NVARCHAR(6) = FORMAT(DATEADD(MONTH, 16, GETDATE()), 'yyyyMM');

	DECLARE @v_division		  AS NVARCHAR(10)

	DECLARE @v_sql_text       AS NVARCHAR(MAX);

	DECLARE @v_defaultLocBucketDay AS NVARCHAR(10);



	SELECT @v_creation_date = CONVERT(NVARCHAR(40), MAX(T.CREATION_DATE), 121)

	FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T

	WHERE  T.PROGRAM_ID = @v_program_id

	AND    T.SHEET_NAME = @v_sheet_name

	AND    T.CREATED_BY = @p_created_by;

		 

	IF @v_creation_date IS NULL 

		PRINT 'NO EXCEL DATA'



	



	IF OBJECT_ID (N'tempdb..#FCST_PRICE_EXCEL', N'U')     IS NOT NULL DROP TABLE #FCST_PRICE_EXCEL



	             

	SELECT A.ATTRIBUTE301 AS DIVISION_ID

		 , A.ATTRIBUTE302 AS END_CUSTOMER

		 , A.ATTRIBUTE303 AS SCM_SITE_ID

		 , A.ATTRIBUTE304 AS ITEM_ID

		 , A.ATTRIBUTE305 AS INCOTERMS

		 , A.ATTRIBUTE306 AS FCST_TYPE

		 , A.ATTRIBUTE307 AS DOM_EXP

		 , A.ATTRIBUTE308 AS CELL_PROD_SITE

		 , A.ATTRIBUTE309 AS CURRENCY

		 , A.ATTRIBUTE310 AS MEASURE

		 , A.ATTRIBUTE2	  AS END_CUSTOMER_NAME

		 , A.ATTRIBUTE3   AS SCM_SITE_ID_NAME

		 , A.ATTRIBUTE6   AS FCST_TYPE_NAME

		 , A.ATTRIBUTE8   AS CELL_PROD_SITE_NAME

		 , A.ATTRIBUTE10  AS MEASURE_NAME

		 , A.ATTRIBUTE11 AS M4

		 , A.ATTRIBUTE12 AS M5

		 , A.ATTRIBUTE13 AS M6

		 , A.ATTRIBUTE14 AS M7

		 , A.ATTRIBUTE15 AS M8

		 , A.ATTRIBUTE16 AS M9

		 , A.ATTRIBUTE17 AS M10

		 , A.ATTRIBUTE18 AS M11

		 , A.ATTRIBUTE19 AS M12

		 , A.ATTRIBUTE20 AS M13

		 , A.ATTRIBUTE21 AS M14

		 , A.ATTRIBUTE22 AS M15

		 , A.ATTRIBUTE23 AS M16

	  INTO #FCST_PRICE_EXCEL

	  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A

	 WHERE 1=1

	   AND A.PROGRAM_ID = @v_program_id

	   AND A.SHEET_NAME = @v_sheet_name

	   AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date

	   AND A.UPLOAD_STATUS_CODE = 'SUCCESS'

	   

	SELECT TOP 1  @v_division = DIVISION_ID 

	  FROM #FCST_PRICE_EXCEL

	   

	                

	SET @v_defaultLocBucketDay =  'MON'

	



	IF OBJECT_ID (N'tempdb..#FCST_PRICE_UNPIVOT', N'U')     IS NOT NULL DROP TABLE #FCST_PRICE_UNPIVOT



	         

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.END_CUSTOMER_NAME

		 , A.SCM_SITE_ID_NAME

		 , A.FCST_TYPE_NAME

		 , A.CELL_PROD_SITE_NAME

		 , A.MEASURE_NAME

		 , A.KEY_VALUE

		 , CM.BASIS_YYYYMM AS YYYYMM

		 , A.QTY

	  INTO #FCST_PRICE_UNPIVOT

	  FROM (SELECT A.DIVISION_ID

				 , A.END_CUSTOMER

				 , A.SCM_SITE_ID

				 , A.ITEM_ID

				 , A.INCOTERMS

				 , A.FCST_TYPE

				 , A.DOM_EXP

				 , A.CELL_PROD_SITE

				 , A.CURRENCY

				 , A.MEASURE

				 , A.END_CUSTOMER_NAME

				 , A.SCM_SITE_ID_NAME

				 , A.FCST_TYPE_NAME

				 , A.CELL_PROD_SITE_NAME

				 , A.MEASURE_NAME

				 , CONCAT(A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.CELL_PROD_SITE, A.CURRENCY, A.MEASURE) AS KEY_VALUE

				 , A.YYYYMM

				                                                                                                                                                                                                                                                                    

				 , CONVERT(NUMERIC(23,2), IIF(ISNULL(A.QTY,'')='', '0', A.QTY)) AS QTY

			  FROM DBO.#FCST_PRICE_EXCEL A

			 UNPIVOT (QTY FOR YYYYMM IN (M4,M5,M6,M7,M8,M9,M10,M11,M12,M13,M14,M15,M16)) A

		   ) A

	  JOIN (SELECT DISTINCT A.BASIS_YYYYMM

				 , 'M' + CONVERT(NVARCHAR, DENSE_RANK() OVER (ORDER BY A.BASIS_YYYYMM) + 3) AS RN

			FROM [dbo].[SCM_SYS_CALENDAR_M] A

			WHERE 1=1

			AND A.BASIS_YYYYMM BETWEEN @v_start_yyyymm AND @v_end_yyyymm) CM

		 ON (CM.RN = A.YYYYMM)





		 

	IF OBJECT_ID (N'tempdb..#FCST_PRICE_BUCKET', N'U')     IS NOT NULL DROP TABLE #FCST_PRICE_BUCKET

	

	            

	                                     

	                                                 

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , CM.BASIS_YYYYMM

		 , CM.BASIS_YYYYMMDD

		 , CM.ISO_YYYYWW

	  INTO #FCST_PRICE_BUCKET

	  FROM #FCST_PRICE_UNPIVOT A

	  JOIN (SELECT A.BASIS_YYYYMM

				 , A.BASIS_YYYYMMDD

				 , A.ISO_YYYYWW

				 , A.DAYOFWEEK

			  FROM [dbo].[SCM_SYS_CALENDAR_M] A

			 WHERE 1=1

			   AND A.BASIS_YYYYMM BETWEEN  @v_start_yyyymm AND @v_end_yyyymm

			) CM

		 ON (A.YYYYMM = CM.BASIS_YYYYMM)

		JOIN (SELECT BC.DIVISION_ID

						, BC.SCM_SITE_ID

						, BC.INCOTERMS

						, BC.BUCKET_PER

						, BC.YYYYMMDD

						, COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT

					   FROM DM_MST_BUCKET_CONVERSION BC

					  WHERE 1=1

						AND BC.DIVISION_ID = @v_division) BC

		 ON (BC.DIVISION_ID = A.DIVISION_ID

		AND BC.SCM_SITE_ID  = A.SCM_SITE_ID

		AND BC.INCOTERMS	= A.INCOTERMS

		AND BC.YYYYMMDD		= CM.DAYOFWEEK

		AND BC.BUCKET_PER	= 'Y')

	  WHERE 1=1

		AND A.MEASURE = 'MKT_FCST'	

		

	 UNION ALL	 

	 

	                                                                  

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , CM.BASIS_YYYYMM

		 , CM.BASIS_YYYYMMDD

		 , CM.ISO_YYYYWW

	  FROM #FCST_PRICE_UNPIVOT A

	  JOIN (SELECT A.BASIS_YYYYMM

				 , A.BASIS_YYYYMMDD

				 , A.ISO_YYYYWW

				 , A.DAYOFWEEK

			  FROM [dbo].[SCM_SYS_CALENDAR_M] A

			 WHERE 1=1

			   AND A.BASIS_YYYYMM BETWEEN  @v_start_yyyymm AND @v_end_yyyymm

			) CM

		 ON (A.YYYYMM = CM.BASIS_YYYYMM)

		JOIN (SELECT L.SEGMENT3 AS DAYOFWEEK 

				FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'

				AND    L.VALID_YN    = 'Y'

				AND    L.SEGMENT1    = @v_division

				AND    L.SEGMENT2    = 'MONTHLY') BC

		 ON (BC.DAYOFWEEK		= CM.DAYOFWEEK)

	  WHERE 1=1

		AND A.MEASURE = 'MKT_FCST'

		AND NOT EXISTS (SELECT 1

						  FROM DBO.DM_MST_BUCKET_CONVERSION X WITH(NOLOCK)

						 WHERE 1=1

						   AND X.DIVISION_ID  = A.DIVISION_ID

						   AND X.SCM_SITE_ID  = A.SCM_SITE_ID

						   AND X.INCOTERMS	  = A.INCOTERMS

						   AND X.BUCKET_PER   = 'Y')

						  

	IF OBJECT_ID (N'tempdb.#FCST_PRICE_WEEKLY', N'U')     IS NOT NULL DROP TABLE #FCST_PRICE_WEEKLY;

	

	            

	               

	WITH W_WEEKLY AS (

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , A.YYYYMM

		 , CM.ISO_YYYYWW

		 , CM.WEEK_DAY_CNT

		 , A.QTY AS MONTHLY_QTY

		 , FLOOR(A.QTY/CM.EOM*CM.WEEK_DAY_CNT) AS TEMP_WEEKLY_QTY

		 , SUM(FLOOR(A.QTY/CM.EOM*CM.WEEK_DAY_CNT)) OVER (PARTITION BY A.KEY_VALUE,YYYYMM ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS CUM_SUM

		 , CASE WHEN LEAD(A.YYYYMM, 1) OVER (PARTITION BY A.KEY_VALUE,YYYYMM ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW ) IS NULL THEN 'Y' ELSE 'N' END AS LAST_WEEK_YN

	   FROM #FCST_PRICE_UNPIVOT A

	   JOIN (SELECT A.BASIS_YYYYMM

				  , A.ISO_YYYYWW

		  		  , COUNT(1) AS WEEK_DAY_CNT

				  , CONVERT(INT, FORMAT(EOMONTH(MAX(A.BASIS_DATE)),'dd')) AS EOM

			   FROM [dbo].[SCM_SYS_CALENDAR_M] A

			  WHERE 1=1

				AND A.BASIS_YYYYMM BETWEEN @v_start_yyyymm AND @v_end_yyyymm

			  GROUP BY A.BASIS_YYYYMM

					 , A.ISO_YYYYWW

			) CM

		 ON (A.YYYYMM = CM.BASIS_YYYYMM)

	   JOIN (SELECT DISTINCT PB.KEY_VALUE

				  , PB.BASIS_YYYYMM

				  , PB.ISO_YYYYWW

				FROM #FCST_PRICE_BUCKET PB) PB                        

		 ON (A.KEY_VALUE = PB.KEY_VALUE

		 AND A.YYYYMM = PB.BASIS_YYYYMM

		 AND CM.ISO_YYYYWW = PB.ISO_YYYYWW)

	  WHERE 1=1

		AND A.MEASURE = 'MKT_FCST'

	 )

	 SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , A.YYYYMM

		 , A.ISO_YYYYWW

		 , A.WEEK_DAY_CNT

		 , A.MONTHLY_QTY

		                      

		              

		 , CASE WHEN A.LAST_WEEK_YN = 'Y' THEN A.MONTHLY_QTY - A.CUM_SUM

				ELSE A.TEMP_WEEKLY_QTY END AS WEEKLY_QTY

	   INTO #FCST_PRICE_WEEKLY

	   FROM W_WEEKLY A

	  WHERE 1=1

		AND A.MEASURE = 'MKT_FCST'

	 ORDER BY A.KEY_VALUE, A.YYYYMM

	 ;

	 





	IF OBJECT_ID (N'tempdb..#FCST_PRICE_DAILY', N'U')     IS NOT NULL DROP TABLE #FCST_PRICE_DAILY;

	

	            

	                

	WITH W_DAILY AS (

	                     

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , A.YYYYMM

		 , CM.BASIS_YYYYMMDD

		 , CM.ISO_YYYYWW

		                  

		 , BC.BUCKET_CNT

		 , A.MONTHLY_QTY

		 , A.WEEKLY_QTY

		 , FLOOR(A.WEEKLY_QTY/BC.BUCKET_CNT) AS TEMP_DAILY_QTY

		 , SUM(FLOOR(A.WEEKLY_QTY/BC.BUCKET_CNT)) OVER (PARTITION BY A.KEY_VALUE,A.YYYYMM,A.ISO_YYYYWW ORDER BY A.KEY_VALUE, YYYYMM, CM.BASIS_YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS CUM_SUM

		 , CASE WHEN LEAD(A.ISO_YYYYWW, 1) OVER (PARTITION BY A.KEY_VALUE,YYYYMM,A.ISO_YYYYWW ORDER BY A.KEY_VALUE, YYYYMM, CM.BASIS_YYYYMMDD ) IS NULL THEN 'Y' ELSE 'N' END AS LAST_DAY_YN

	   FROM #FCST_PRICE_WEEKLY A

	   JOIN (SELECT A.BASIS_YYYYMM

				  , A.BASIS_YYYYMMDD

				  , A.ISO_YYYYWW

				  , A.DAYOFWEEK

			   FROM [dbo].[SCM_SYS_CALENDAR_M] A

			  WHERE 1=1

				AND A.BASIS_YYYYMM BETWEEN @v_start_yyyymm AND @v_end_yyyymm

			) CM

		 ON (A.YYYYMM = CM.BASIS_YYYYMM

		 AND A.ISO_YYYYWW = CM.ISO_YYYYWW)

		JOIN (SELECT BC.DIVISION_ID

						, BC.SCM_SITE_ID

						, BC.INCOTERMS

						, BC.BUCKET_PER

						, BC.YYYYMMDD

						, COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT

					   FROM DM_MST_BUCKET_CONVERSION BC

					  WHERE 1=1

						AND BC.DIVISION_ID = '40') BC

		 ON (BC.DIVISION_ID = A.DIVISION_ID

		AND BC.SCM_SITE_ID = A.SCM_SITE_ID

		AND BC.INCOTERMS = A.INCOTERMS

		AND BC.YYYYMMDD = CM.DAYOFWEEK

		AND BC.BUCKET_PER = 'Y')

	  UNION ALL

	                 

	 SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , A.YYYYMM

		 , CM.BASIS_YYYYMMDD

		 , CM.ISO_YYYYWW

		                      

		 , 1 AS BUCKET_CNT

		 , A.MONTHLY_QTY

		 , A.WEEKLY_QTY

		 , FLOOR(A.WEEKLY_QTY) AS TEMP_DAILY_QTY

		 , SUM(FLOOR(A.WEEKLY_QTY)) OVER (PARTITION BY A.KEY_VALUE,A.YYYYMM,A.ISO_YYYYWW ORDER BY A.KEY_VALUE, YYYYMM, CM.BASIS_YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS CUM_SUM

		 , CASE WHEN LEAD(A.ISO_YYYYWW, 1) OVER (PARTITION BY A.KEY_VALUE,YYYYMM,A.ISO_YYYYWW ORDER BY A.KEY_VALUE, YYYYMM, CM.BASIS_YYYYMMDD ) IS NULL THEN 'Y' ELSE 'N' END AS LAST_DAY_YN

	   FROM #FCST_PRICE_WEEKLY A

	   JOIN (SELECT A.BASIS_YYYYMM

				  , A.BASIS_YYYYMMDD

				  , A.ISO_YYYYWW

				  , A.DAYOFWEEK

			   FROM [dbo].[SCM_SYS_CALENDAR_M] A

			  WHERE 1=1

				AND A.BASIS_YYYYMM BETWEEN @v_start_yyyymm AND @v_end_yyyymm

			) CM

		 ON (A.YYYYMM = CM.BASIS_YYYYMM

		 AND A.ISO_YYYYWW = CM.ISO_YYYYWW)

		JOIN (SELECT L.SEGMENT3 AS DAYOFWEEK 

				FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'

				AND    L.VALID_YN    = 'Y'

				AND    L.SEGMENT1    = @v_division

				AND    L.SEGMENT2    = 'MONTHLY') BC

		 ON (BC.DAYOFWEEK		= CM.DAYOFWEEK)

	  WHERE 1=1

		AND A.MEASURE = 'MKT_FCST'

		AND NOT EXISTS (SELECT 1

						  FROM DBO.DM_MST_BUCKET_CONVERSION X WITH(NOLOCK)

						 WHERE 1=1

						   AND X.DIVISION_ID  = A.DIVISION_ID

						   AND X.SCM_SITE_ID  = A.SCM_SITE_ID

						   AND X.INCOTERMS	  = A.INCOTERMS

						   AND X.BUCKET_PER   = 'Y')

	)

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , A.YYYYMM

		 , A.BASIS_YYYYMMDD

		 , A.ISO_YYYYWW

		 , A.BUCKET_CNT

		 , A.MONTHLY_QTY

		 , A.WEEKLY_QTY

		                     

		              

		 ,A.LAST_DAY_YN

		 , CASE WHEN A.LAST_DAY_YN = 'Y' THEN A.WEEKLY_QTY - ISNULL(A.CUM_SUM,0)

				ELSE A.TEMP_DAILY_QTY END AS DAILY_QTY

	   INTO #FCST_PRICE_DAILY

	   FROM W_DAILY A

	  WHERE 1=1

	  ORDER BY A.KEY_VALUE, A.YYYYMM

	  

	       

	                 

	INSERT INTO #FCST_PRICE_DAILY

	( DIVISION_ID

	, END_CUSTOMER

	, SCM_SITE_ID

	, ITEM_ID

	, INCOTERMS

	, FCST_TYPE

	, DOM_EXP

	, CELL_PROD_SITE

	, CURRENCY

	, MEASURE

	, KEY_VALUE

	, YYYYMM

	, BASIS_YYYYMMDD

	, ISO_YYYYWW

	, BUCKET_CNT

	, MONTHLY_QTY

	, WEEKLY_QTY

	, LAST_DAY_YN

	, DAILY_QTY

	)

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , CM.BASIS_YYYYMM AS YYYYMM

		 , CM.BASIS_YYYYMMDD

		 , CM.ISO_YYYYWW

		 , NULL AS BUCKET_CNT

		 , NULL AS MONTHLY_QTY

		 , NULL AS WEEKLY_QTY

		 , '' AS LAST_DAY_YN

		 , CONVERT(NUMERIC(23,2), A.QTY) AS DAILY_QTY

	   FROM #FCST_PRICE_UNPIVOT A

	   JOIN (SELECT A.BASIS_YYYYMM

				  , A.BASIS_YYYYMMDD

				  , A.ISO_YYYYWW

				  , A.DAYOFWEEK

			   FROM [dbo].[SCM_SYS_CALENDAR_M] A

			  WHERE 1=1

				AND A.BASIS_YYYYMM BETWEEN @v_start_yyyymm AND @v_end_yyyymm

				AND (A.DAYOFWEEK = @v_defaultLocBucketDay OR A.CALENDAR_DAY = '01')

			) CM

		 ON (A.YYYYMM = CM.BASIS_YYYYMM)

	  WHERE 1=1

	    AND A.MEASURE = 'LOC'



	                                                         

	          

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , A.BASIS_YYYYMMDD

		                 

		                 

		                  

		                 

		                  

		 , CONVERT(NUMERIC(23,2), A.DAILY_QTY) AS DAILY_QTY

	  FROM #FCST_PRICE_DAILY A

	 UNION ALL

	     

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , A.CURRENCY

		 , A.MEASURE

		 , A.KEY_VALUE

		 , CM.BASIS_YYYYMMDD

		 , CONVERT(NUMERIC(23,2), A.QTY) AS DAILY_QTY

	   FROM #FCST_PRICE_UNPIVOT A

	   JOIN (SELECT A.BASIS_YYYYMM

				  , A.BASIS_YYYYMMDD

				  , A.ISO_YYYYWW

				  , A.DAYOFWEEK

			   FROM [dbo].[SCM_SYS_CALENDAR_M] A

			  WHERE 1=1

				AND A.BASIS_YYYYMM BETWEEN @v_start_yyyymm AND @v_end_yyyymm

				AND (A.DAYOFWEEK = @v_defaultLocBucketDay OR A.CALENDAR_DAY = '01')

			) CM

		 ON (A.YYYYMM = CM.BASIS_YYYYMM)

	  WHERE 1=1

	    AND A.MEASURE = 'LOC'

	  ORDER BY KEY_VALUE, BASIS_YYYYMMDD

	 

	                                                           

	

	                                                             

	DECLARE @V_CONCAT_PIVOT NVARCHAR(MAX)

	DECLARE @V_SQL			NVARCHAR(MAX)



	SELECT @V_CONCAT_PIVOT = COALESCE(@V_CONCAT_PIVOT + ',[D' + A.BASIS_YYYYMMDD + ']', '[D' + A.BASIS_YYYYMMDD + ']')

	FROM [dbo].[SCM_SYS_CALENDAR_M] A

	WHERE 1=1

	AND A.BASIS_YYYYMM BETWEEN @v_start_yyyymm AND @v_end_yyyymm





	                                

	       

	                                                   

	                                                                                                 

	      



	SET @V_SQL = N'

	SELECT A.*

	  FROM (

	SELECT A.DIVISION_ID

		 , A.END_CUSTOMER

		 , B.END_CUSTOMER_NAME

		 , A.SCM_SITE_ID

		 , A.ITEM_ID

		 , A.INCOTERMS

		 , A.FCST_TYPE

		 , B.FCST_TYPE_NAME

		 , A.DOM_EXP

		 , A.CELL_PROD_SITE

		 , B.CELL_PROD_SITE_NAME

		 , A.CURRENCY

		 , A.MEASURE

		 , B.MEASURE_NAME

		 , ''D'' + A.BASIS_YYYYMMDD AS BASIS_YYYYMMDD

		 , A.DAILY_QTY

	  FROM #FCST_PRICE_DAILY A

	  JOIN #FCST_PRICE_UNPIVOT B

	    ON (A.KEY_VALUE = B.KEY_VALUE)) A

	  PIVOT (MAX(A.DAILY_QTY) FOR A.BASIS_YYYYMMDD IN (' + @V_CONCAT_PIVOT + '

	)) A'

	

	EXEC SP_EXECUTESQL @V_SQL



	WHILE LEN(@V_SQL) > 0

	BEGIN

		PRINT LEFT(@V_SQL, 4000);              

		SET @V_SQL = SUBSTRING(@V_SQL, 4001, LEN(@V_SQL));                 

	END;





	                                                          

END
