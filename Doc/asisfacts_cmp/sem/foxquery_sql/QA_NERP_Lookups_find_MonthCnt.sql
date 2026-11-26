SELECT YYYYMM AS MONTH
		           , SUBSTRING(YYYYMM,1,4) + '-' +
		             (CASE WHEN MONTH = '01' THEN 'Jan'
		                   WHEN MONTH = '02' THEN 'Feb'
		                   WHEN MONTH = '03' THEN 'Mar'
		                   WHEN MONTH = '04' THEN 'Apr'
		                   WHEN MONTH = '05' THEN 'May'
		                   WHEN MONTH = '06' THEN 'Jun'
		                   WHEN MONTH = '07' THEN 'Jul'
		                   WHEN MONTH = '08' THEN 'Aug'
		                   WHEN MONTH = '09' THEN 'Sep'
		                   WHEN MONTH = '10' THEN 'Oct'
		                   WHEN MONTH = '11' THEN 'Nov'
		                   ELSE 'Dec' END) AS MONTH_NAME
		           , COUNT(*) AS MONTH_COUNT
		           , 'M' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMM))-1) AS M_VALUE
		      FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)
		      WHERE  CAL.DT >= CONVERT(DATETIME, @BUCKET_FROM, 112)
		      AND    CAL.DT <= CONVERT(DATETIME, @BUCKET_TO, 112)
		      GROUP BY YYYYMM, MONTH
		      ORDER BY YYYYMM