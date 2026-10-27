
/*
 * Program ID   : PR_XLS_GET_YIELD
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_YIELD_RAW] 'UC1', '202408' , '202409'
 */

create PROCEDURE [dbo].[PR_XLS_GET_YIELD_RAW_20240802]
    @p_apl_code                 nvarchar(max)  = 'UC1'
,	@p_yyyymm_from			NVARCHAR(MAX)
,	@p_yyyymm_to			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_yyyymm_from   nvarchar(max)
	DECLARE  @v_yyyymm_to     nvarchar(max)

	set @v_yyyymm_from		= @p_yyyymm_from --format( convert(datetime, @p_yyyymmdd_rom), 'yyyyMMdd')
	set @v_yyyymm_to		= @p_yyyymm_to --format( convert(datetime, @p_cutoff_date_to), 'yyyyMMdd')

	if object_id('tempdb..#yield') is not null
		drop table #yield

	create table #yield (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, COMPANY_ID                nvarchar(30)
			, DIVISION_ID 				nvarchar(30)
			, SITE_ID 					nvarchar(30)
			, PLANT_ID 					nvarchar(30)
			, FACTORY_ID 				nvarchar(30)
			, OPERATION_ID 				nvarchar(30)
			, LINE_ID 					nvarchar(30)
			, ITEM_ID 					nvarchar(150)
			, PLAN_DATE 		   		datetime
			, YIELD                     numeric(20, 10)
			)
			;

	BEGIN TRY		

	   insert into #yield
	        (
			  COMPANY_ID        
			, DIVISION_ID 		
			, SITE_ID 			
			, PLANT_ID 			
			, FACTORY_ID 		
			, OPERATION_ID 		
			, LINE_ID 			
			, ITEM_ID 			
			, PLAN_DATE 		
			, YIELD  
			)
	   select 
		      X.COMPANY_ID    
		    , X.DIVISION_ID 	
		    , X.SITE_ID     	
		    , X.PLANT_ID    	
		    , X.FACTORY_ID  	
		    , X.OPERATION_ID	
		    , X.LINE_ID     	
		    , X.ITEM_ID     	
		    , X.PLAN_DATE		
		    , ISNULL( ISNULL( y.YIELD, ( CASE WHEN x.YIELD = 0 THEN 1 ELSE x.YIELD END)) ,1) 
		 from (
		       select YYY.COMPANY_ID  
		       	    , YYY.DIVISION_ID 
		       	    , YYY.SITE_ID     
		       	    , YYY.PLANT_ID    
		       	    , YYY.FACTORY_ID  
		       	    , YYY.OPERATION_ID
		       	    , YYY.LINE_ID     
		       	    , YYY.ITEM_ID     
		       	    , CAL.DT AS PLAN_DATE
		       	    , CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END AS YIELD
		         FROM SCM_YIELD_M YYY WITH(NOLOCK)
				      JOIN TH_UIS_CAL as CAL with(nolock)
				   on yyy.month = cal.yyyymm
				where 1 = 1
				  and yyy.company_id = 'G670'
				  and yyy.division_id = '81_UC'
				  and yyy.site_id = 'A003'
				  and yyy.plant_id IN ('G671', 'G672')
				  and yyy.operation_id in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
		          AND yyy.month  between @v_yyyymm_from and @v_yyyymm_to
		        group by YYY.COMPANY_ID  
		       	    , YYY.DIVISION_ID 
		       	    , YYY.SITE_ID     
		       	    , YYY.PLANT_ID    
		       	    , YYY.FACTORY_ID  
		       	    , YYY.OPERATION_ID
		       	    , YYY.LINE_ID     
		       	    , YYY.ITEM_ID     
		       	    , CAL.DT
		      ) as x
			  left outer join (
			 		           SELECT EE.COMPANY_ID  
					                , EE.DIVISION_ID 
					                , EE.SITE_ID     
					                , EE.PLANT_ID    
					                , EE.FACTORY_ID  
					                , EE.OPERATION_ID
					                , EE.LINE_ID     
					                , EE.ITEM_ID     
					                , CAL.DT AS PLAN_DATE
				                    , (CASE WHEN MAX(EE.YIELD) = 0 THEN 1 ELSE MAX(EE.YIELD) END) AS YIELD
				                 FROM SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
									  JOIN TH_UIS_CAL as CAL with(nolock)
								   on cal.dt between ee.start_time and ee.end_time
								where 1 = 1
								  and company_id = 'G670'
								  and division_id = '81_UC'
				                  and site_id = 'A003'
				                  and plant_id IN ('G671', 'G672')
								  and operation_id in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
								  AND cal.YYYYMM  between @v_yyyymm_from and @v_yyyymm_to
				                group by 
								      EE.COMPANY_ID  
					                , EE.DIVISION_ID 
					                , EE.SITE_ID     
					                , EE.PLANT_ID    
					                , EE.FACTORY_ID  
					                , EE.OPERATION_ID
					                , EE.LINE_ID     
					                , EE.ITEM_ID     
					                , CAL.DT
			  ) y
		   ON X.COMPANY_ID		= Y.COMPANY_ID  
		  AND X.DIVISION_ID 	= Y.DIVISION_ID 
		  AND X.SITE_ID     	= Y.SITE_ID     
		  AND X.PLANT_ID    	= Y.PLANT_ID    
		  AND X.FACTORY_ID  	= Y.FACTORY_ID  
		  AND X.OPERATION_ID	= Y.OPERATION_ID
		  AND X.LINE_ID     	= Y.LINE_ID     
		  AND X.ITEM_ID     	= Y.ITEM_ID     
		  AND X.PLAN_DATE		= Y.PLAN_DATE

	   -- Yield 없는 일자 데이터 생성
	   insert into #yield
	        (
			  COMPANY_ID        
			, DIVISION_ID 		
			, SITE_ID 			
			, PLANT_ID 			
			, FACTORY_ID 		
			, OPERATION_ID 		
			, LINE_ID 			
			, ITEM_ID 			
			, PLAN_DATE 		
			, YIELD  
			)
	   select 
		      X.COMPANY_ID    
			, X.DIVISION_ID 	
			, X.SITE_ID 		
			, X.PLANT_ID 		
			, X.FACTORY_ID 	
			, X.OPERATION_ID 	
			, X.LINE_ID 		
			, X.ITEM_ID 		
			, X.PLAN_DATE 	
			, 1 as yield 
		 from (
				SELECT B.COMPANY_ID      
			         , B.DIVISION_ID 		
			         , B.SITE_ID 			
			         , B.PLANT_ID 			
			         , B.FACTORY_ID 		
			         , B.OPERATION_ID 		
			         , B.LINE_ID 			
			         , B.ITEM_ID 		
					 , A.PLAN_DATE 	
				FROM (
						SELECT C.dt AS plan_date
						FROM TH_UIS_CAL AS C WITH(NOLOCK)
						WHERE 1 = 1
							AND C.yyyymm >= @v_yyyymm_from
							AND C.yyyymm <= @v_yyyymm_to
						) A,
						(
						 SELECT distinct 
						        COMPANY_ID    
							  , DIVISION_ID 	
							  , SITE_ID 		
							  , PLANT_ID 		
							  , FACTORY_ID 	
							  , OPERATION_ID 	
							  , LINE_ID 		
							  , ITEM_ID 		
						   FROM #yield

						) B
		      ) as x
		WHERE 1 = 1
		  AND NOT EXISTS (
						  SELECT 'X'
						    FROM #yield AS Z 
						   WHERE 1 = 1
						     AND Z.COMPANY_ID       = x.COMPANY_ID     
						     AND Z.DIVISION_ID 	    = x.DIVISION_ID 	
						     AND Z.SITE_ID 		    = x.SITE_ID 		
						     AND Z.PLANT_ID 		= x.PLANT_ID 		 	
						     AND Z.FACTORY_ID 	    = x.FACTORY_ID 	
						     AND Z.OPERATION_ID 	= x.OPERATION_ID 	 	
						     and z.LINE_ID 		    = x.LINE_ID 		
						     and z.ITEM_ID 		    = x.ITEM_ID 		
						     and z.PLAN_DATE 	    = x.PLAN_DATE 	
			             )
			;

		select             
		      'YD' as GUBUN
            , 'YD' + 
               CASE WHEN XX.OPERATION_ID = 'A5000' THEN 'Notching'
                    WHEN XX.OPERATION_ID = 'A8000' THEN 'L&S'
                    WHEN XX.OPERATION_ID = 'A9000' THEN 'PKG'
                    WHEN XX.OPERATION_ID = 'E2000' THEN 'Coating'
                    WHEN XX.OPERATION_ID = 'E3000' THEN 'R/P'
                    WHEN XX.OPERATION_ID = 'F6000' THEN 'EOL'
                    ELSE XX.OPERATION_ID
            END + 
            CASE WHEN (XX.OPERATION_ID = 'E2000' OR XX.OPERATION_ID = 'A5000') THEN 
                 CASE WHEN SUBSTRING(XX.ITEM_ID, 4, 2) = 'AN' THEN ' (Anode)' ELSE ' (Cathode)' END
                 ELSE  '' 
            END +
            REPLACE(CONCAT('#', SUBSTRING( XX.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', XX.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
            + FORMAT(PLAN_DATE,'yyyy-MM-dd')
            AS KEYS_DATE
            , 'YD' + 
               CASE WHEN XX.OPERATION_ID = 'A5000' THEN 'Notching'
                    WHEN XX.OPERATION_ID = 'A8000' THEN 'L&S'
                    WHEN XX.OPERATION_ID = 'A9000' THEN 'PKG'
                    WHEN XX.OPERATION_ID = 'E2000' THEN 'Coating'
                    WHEN XX.OPERATION_ID = 'E3000' THEN 'R/P'
                    WHEN XX.OPERATION_ID = 'F6000' THEN 'EOL'
                    ELSE XX.OPERATION_ID
            END + 
            CASE WHEN (XX.OPERATION_ID = 'E2000' OR XX.OPERATION_ID = 'A5000') THEN 
                 CASE WHEN SUBSTRING(XX.ITEM_ID, 4, 2) = 'AN' THEN ' (Anode)' ELSE ' (Cathode)' END
                 ELSE  '' 
            END 
            AS KEYS
            , FORMAT(PLAN_DATE,'yyyy-MM-dd') AS PLAN_DATE
		            , XX.YIELD
            , XX.COMPANY_ID    
		    , XX.DIVISION_ID 	
		    , XX.SITE_ID     	
		    , XX.PLANT_ID    	
		    , XX.FACTORY_ID  	
		    , XX.OPERATION_ID	
		    , XX.LINE_ID     	
		    , XX.ITEM_ID	
		from #yield as XX
		order by tid

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

		if object_id('tempdb..#yield') is not null
			drop table #yield

	END CATCH

	if object_id('tempdb..#yield') is not null
		drop table #yield

END



