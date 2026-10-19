SELECT DISTINCT A.COL_NM, A.YEAR, A.HALF, A.QUARTER, A.MONTH, A.WEEK, A.TYPE, A.VALUE, A.LABLE, A.DAY 
						FROM  
						   ( 
						      SELECT  
						         'D' + ISNULL(CAL.YYYYMMDD, '')  AS COL_NM,  
						         CAL.ISO_YEAR  AS YEAR,  
						         CAL.HALF  AS HALF,  
						         CAL.QUARTER  AS QUARTER,  
						         CAL.YYYYMM  AS MONTH,  
						         CAL.ISO_YYYYWW  AS WEEK,  
						         'D' AS TYPE,  
						         CAL.YYYYMMDD  AS VALUE,  
						         'D' + ISNULL(CAL.DAY, '')  AS LABLE, 
						         DAY_SEQ  as day 
						      FROM TH_UIS_CAL AS CAL(NOLOCK) 
						      WHERE ISO_YYYYWW >= (SELECT MAX(ISO_YYYYWW) FROM TH_UIS_CAL WHERE YYYYMMDD=@BASIS_DATE)
						        AND ISO_YYYYWW < (SELECT MAX(ISO_YYYYWW) FROM TH_UIS_CAL WHERE DT=(CONVERT(DATETIME,@BASIS_DATE,112)+56))
						   )  AS A