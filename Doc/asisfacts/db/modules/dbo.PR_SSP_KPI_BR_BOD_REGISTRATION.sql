/*
 * Program ID   : PR_SSP_KPI_BR_BOD_REGISTRATION  
 * Description  : MKT Forecast 기준 물류 BOD 미등록 건수 
 *                매일 07:00 수행( BATCH JOB : JOB.PR_SSP_KPI_BR_BOD_REGISTRATION ) 
 * Execute      : EXEC PR_SSP_KPI_BR_BOD_REGISTRATION 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.05.09   AYJ            Initial Release [CSR ID:3969613] [지표정의] GSCM Portal 관련 HI 지표 산출
 * 2020.09.21	KIM BOK KI     INCOTERMS COLUMN 변경(INCOTERMS -> SSP_INCOTERMS)
 * 2021.04.30   SSP Pjt.       SSP_KPI_BR_BOD_REGISTRATION.attribute1에 ISOYYYYWW 값 적용
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 */
CREATE PROCEDURE [dbo].[PR_SSP_KPI_BR_BOD_REGISTRATION]
--( 
--	--  @p_division_id        NVARCHAR(30)
--) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_KPI_BR_BOD_REGISTRATION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_KPI_BR_BOD_REGISTRATION'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_KPI_BR_BOD_REGISTRATION INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

    BEGIN TRY
    BEGIN
        BEGIN TRAN TX_SH

          ------------------------------------------------------------------------------------------------------------- 
          -- 0. temp 테이블 생성 : 생성후 마지막에 한번에 입력하기 위해서
          ------------------------------------------------------------------------------------------------------------- 
			IF OBJECT_ID('tempdb..#tmp_SSP_KPI_BR_BOD_REGISTRATION') IS NOT NULL
				DROP TABLE #tmp_SSP_KPI_BR_BOD_REGISTRATION

			CREATE TABLE #tmp_SSP_KPI_BR_BOD_REGISTRATION(
				 YYYYMMDD             nvarchar(008)	
				,DIVISION_ID          nvarchar(030)   
				,FROM_SITE            nvarchar(030) 
				,FROM_CITY            nvarchar(005)				 
				,TO_SITE              nvarchar(030)				 
				,TO_CITY              nvarchar(005)				 
				,VMI_YN	              nvarchar(001)				 
				,INCOTERMS            nvarchar(050)				 
				,TRANSPORT_MODE       nvarchar(050)				 
				,ROUTE_CNT            BIGINT
				,CUSTOMER             nvarchar(050)				 
            );

			IF OBJECT_ID('tempdb..#TblDynamicPivot_KPI_BOD_from') IS NOT NULL      
			DROP TABLE #TblDynamicPivot_KPI_BOD_from; 

			IF OBJECT_ID('tempdb..#TblDynamicPivot_KPI_BOD_to') IS NOT NULL      
			DROP TABLE #TblDynamicPivot_KPI_BOD_to; 

			IF OBJECT_ID('tempdb..#TblDynamicPivot_KPI_BOD_incoterms') IS NOT NULL      
			DROP TABLE #TblDynamicPivot_KPI_BOD_incoterms; 


			SELECT A.SCM_SITE_ID
			  INTO #TblDynamicPivot_KPI_BOD_from
			  FROM SCM_MST_SITE		AS A WITH(NOLOCK)	
			       JOIN SCM_MST_DIVISION	AS D WITH(NOLOCK)
                ON A.DIVISION_ID	= D.DIVISION_ID
			 WHERE A.SITE_TYPE		= 'PLANT' 
			   AND A.VALID_YN		= 'Y' 
			   AND D.ATTRIBUTE3		IN ('40','81','82')


			SELECT A.SCM_SITE_ID
			  INTO #TblDynamicPivot_KPI_BOD_to
		 	  FROM (
				   SELECT A.SCM_SITE_ID
				     FROM [dbo].[SCM_MST_SITE]	AS A WITH(NOLOCK)  
					      JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
                       ON A.DIVISION_ID			= D.DIVISION_ID
				    WHERE A.VALID_YN			= 'Y'  
				      AND D.ATTRIBUTE3			IN ('40','81','82')
				    UNION  
				   SELECT A.SCM_SITE_ID
				     FROM [SCM_MST_SITE]		AS A WITH(NOLOCK)   
				    WHERE A.VALID_YN			= 'Y'  
				      AND A.SCM_SITE_ID			LIKE '%' + '-A'  
			       ) A

			SELECT A.SEGMENT1 AS CODE
			  INTO #TblDynamicPivot_KPI_BOD_incoterms
			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL A with(nolock)
			 WHERE A.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'
			   AND A.VALID_YN='Y'

     	------------------------------------------------------------------------------------------------------------- 
		-- 1. SSP_KPI_BR_BOD_REGISTRATION :  #tmp_SSP_KPI_BR_BOD_REGISTRATION
		------------------------------------------------------------------------------------------------------------- 
		
		INSERT INTO #tmp_SSP_KPI_BR_BOD_REGISTRATION (
			   DIVISION_ID
			  ,FROM_SITE            
			  ,FROM_CITY            
			  ,TO_SITE              
			  ,TO_CITY
			  ,INCOTERMS              
			  ,TRANSPORT_MODE       
			  ,CUSTOMER
			  ,ROUTE_CNT
			  ,VMI_YN	              
			  ,YYYYMMDD                     
		      )
		SELECT DISTINCT 
	  	       t.division_id
	  	      ,t.from_site
	 	      ,t.from_city
	  	      ,t.to_site																																			 
	 	      ,t.to_city		
		      --,t.incoterms
	  	      ,ISNULL(S.SSP_INCOTERMS, t.incoterms)  AS incoterms
	 	      ,t.transport_mode																																						 
	  	      ,t.customer
		      ,(SELECT COUNT(*) AS route_cnt FROM scp_mst_distribution_route WITH(NOLOCK) WHERE transport_mode = t.transport_mode AND from_city =t.from_city  AND to_city =t.to_city ) AS route_cnt  
		      ,CASE WHEN RIGHT(t.from_site,1) = 'E' THEN (SELECT top 1 ISNULL(VMI_YN,'N') FROM scm_mst_site with(nolock) WHERE scm_site_id = t.to_site )									 
		       ELSE (SELECT ISNULL(VMI_YN,'N') FROM scm_mst_site WITH(NOLOCK) WHERE division_id =t.division_id AND scm_site_id = t.to_site ) END vmi_yn
		      ,CONVERT(CHAR(8), DATEADD(DD, 0, GETDATE()), 112) AS yyyymmdd
		  FROM (																																										 
			   SELECT																																								 
	  			      ma.division_id																																						 
	  			     ,ma.customer																																						 
	  			     ,ma.incoterms																																						 
	  			     ,ma.from_site																																		 
	  			     ,ma.to_site																																			 
	 			     ,ma.from_city																																						 
	 			     ,ma.to_city																																							 
	 			     ,ma.transport_mode
					/* [ma] table - division_id ~ transport_mode_code -> 4 Steps */																										 
	  			 FROM (																																								 
				      /* 1-1. # Div = 81, BOD Requied - From Site : Project route , To Site : Mkt FCST project_code, sales_site_id Join */											 
	  				  SELECT t.division_id, t.to_site, t.customer, t.incoterms, t.from_site, t.from_country, t.from_city, t.to_country, t.to_city,u.transport_mode				 
	 			    		,null created_by, null creation_date, null last_updated_by, null last_update_date																		 
	 			    	FROM (																																							 
	 			    	     SELECT DISTINCT de.division_id, de.scm_site_id as to_site,  de.customer, de.Incoterms, si.scm_site_id AS from_site 										 
	 			    			   ,f_ci.country	AS from_country																														 
	 			    			   ,f_ci.city		AS from_city																															 
	 			    			   ,t_ci.country	AS to_country																														 
	 			    			   ,t_ci.city		AS to_city																															 
	 			    		   FROM (																																					 
	  			    			    SELECT f.division_id, f.scm_site_id, m.end_customer AS customer, f.incoterms, f.project_code, f.item_id											 
	  			    			      FROM dm_pln_mkt_fcst f WITH(NOLOCK)																															 
									       JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
									    ON F.DIVISION_ID = D.DIVISION_ID

	  			    				       JOIN scm_mst_site m WITH(NOLOCK) 
				    					ON f.division_id = m.division_id 
									   AND f.scm_site_id = m.scm_site_id
	  			    				       LEFT JOIN scm_mst_site s WITH(NOLOCK) 
				    					ON s.DIVISION_ID = F.DIVISION_ID 
									   AND s.SCM_SITE_ID = F.SCM_SITE_ID 
									   AND s.VMI_YN='Y'										 
	  			    				 WHERE 1=1																																		 
	     		    				   AND D.ATTRIBUTE3  = '81'																												
	  			    				   AND F.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')															 
	  			    			    ) DE																																				 
	  			    			    LEFT OUTER JOIN (SELECT a.division_id, a.scm_site_id, b.item_id, b.project_code, c.priority ,c.sales_site_id, right(plant_site_id,1) plant_type		 
	  			    						           FROM scm_mst_site a WITH(NOLOCK)																												 
	  			    								      , scm_mst_site_item b WITH(NOLOCK)																										 
	  			    								      , scm_mst_site_item_priority c WITH(NOLOCK)	
														  , SCM_MST_DIVISION D WITH(NOLOCK)
	  			    							      WHERE a.division_id  = b.division_id																							 
	  			    								    AND a.scm_site_id  = b.scm_site_id																							 
	  			    								    AND b.division_id  = c.division_id																							 
	  			    								    AND b.scm_site_id  = c.plant_site_id																							 
	  			    								    AND b.project_code = c.project_code																							 
	  			    								    AND b.item_id      = c.item_id	
														AND A.DIVISION_ID  = D.DIVISION_ID
	  			    								    AND a.valid_yn     = 'Y'																									 
	  			    								    AND b.valid_yn     = 'Y'																									 
	  			    								    AND c.valid_yn     = 'Y'																									 
	  			    								    AND a.site_type    = 'PLANT'																								 
	  			    								    AND D.ATTRIBUTE3   = '81'																							 
	  			    						        ) SI 
				    		     ON de.division_id  = si.division_id																							 
	  			    			AND ((si.plant_type != 'E' AND de.project_code = si.project_code  AND de.SCM_SITE_ID  = si.sales_site_id)	OR (si.plant_type = 'E'))																										 
	  			    			AND DE.ITEM_ID      = SI.ITEM_ID																								 
	  			    			    LEFT OUTER JOIN (
				    			                    SELECT	division_id, scm_site_id, country, city																						 
	  			    							      FROM scm_mst_site A WITH(NOLOCK) 
				    								 WHERE a.valid_yn = 'Y'
													) f_ci 
				    			 ON de.division_id = f_ci.division_id AND si.scm_site_id = f_ci.scm_site_id		 	    
	  			    			    LEFT OUTER JOIN (
				    			                    SELECT division_id, scm_site_id,country,city																						 
	  			    							      FROM scm_mst_site A WITH(NOLOCK) 
				    								 WHERE a.valid_yn = 'Y'
													) t_ci 
				    			 ON de.division_id = t_ci.division_id AND de.scm_site_id = t_ci.scm_site_id		 
	 			    	     ) t 
				    		   LEFT JOIN ( 
				    		             SELECT DISTINCT from_country, from_city, to_country, to_city, transport_mode																 
	 			    					   FROM scp_mst_distribution_route WITH(NOLOCK)																											 
	 			    					  WHERE VALID_YN ='Y'																														 
	 			    				     ) u 
				    	    ON t.from_country = u.from_country																										 
	 			    	   AND t.from_city    = u.from_city																											 
	 			    	   AND t.to_country   = u.to_country																											 
	 			    	   AND t.to_city      = u.to_city																												 
				    	 UNION ALL																																					
						/* 1-2. # Div = 40,82,  BOD Requied - From Site : Project route , To Site : Mkt FCST project_code, sales_site_id NOT Join */									 
	  					SELECT t.division_id, t.to_site, t.customer, t.incoterms, t.from_site, t.from_country, t.from_city, t.to_country, t.to_city,u.transport_mode				 
	 						  ,null created_by, null creation_date, null last_updated_by, null last_update_date																		 
	 					  FROM (																																							 
	 						   SELECT DISTINCT de.division_id, de.scm_site_id as to_site,  de.customer, de.Incoterms, si.scm_site_id AS from_site 										 
	 							    , f_ci.country AS from_country																														 
	 							    , f_ci.city	   AS from_city																															 
	 							    , t_ci.country AS to_country																														 
	 							    , t_ci.city	   AS to_city																															 
	 						     FROM ( 
								      SELECT f.division_id, f.scm_site_id, m.end_customer AS customer, f.incoterms, f.project_code, f.item_id											 
	  								    FROM dm_pln_mkt_fcst f WITH(NOLOCK)																															 
										     JOIN SCM_MST_DIVISION D WITH(NOLOCK)
										  ON F.DIVISION_ID	= D.DIVISION_ID

	  								         JOIN scm_mst_site m WITH(NOLOCK) 
										  ON f.division_id	= m.division_id 
										 AND f.scm_site_id	= m.scm_site_id	
	  								         LEFT JOIN scm_mst_site s WITH(NOLOCK) 
										  ON s.DIVISION_ID	= F.DIVISION_ID 
										 AND s.SCM_SITE_ID	= F.SCM_SITE_ID 
										 AND s.VMI_YN		= 'Y'										 
	  								   WHERE 1 = 1																																		 
	     							     AND D.ATTRIBUTE3 IN ('40','82')																											
	  								     AND F.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')															 
	  							      ) DE																																				 
	  							      LEFT OUTER JOIN (
									                  SELECT a.division_id, a.scm_site_id, b.item_id, b.project_code, c.priority ,c.sales_site_id, right(plant_site_id,1) plant_type		 
	  											        FROM scm_mst_site a WITH(NOLOCK)																												 
	  												       , scm_mst_site_item b WITH(NOLOCK)																										 
	  												       , scm_mst_site_item_priority c WITH(NOLOCK)	
														   , SCM_MST_DIVISION D WITH(NOLOCK)
	  											       WHERE a.division_id  = b.division_id																							 
	  												     AND a.scm_site_id  = b.scm_site_id																							 
	  												     AND b.division_id  = c.division_id																							 
	  												     AND b.scm_site_id  = c.plant_site_id																							 
	  												     AND b.project_code = c.project_code																							 
	  												     AND b.item_id      = c.item_id	
														 AND A.DIVISION_ID  = D.DIVISION_ID
	  												     AND a.valid_yn     = 'Y'																									 
	  												     AND b.valid_yn     = 'Y'																									 
	  												     AND c.valid_yn     = 'Y'																									 
	  												     AND a.site_type    = 'PLANT'																								 
	  												     AND D.ATTRIBUTE3  IN ('40','82')																						 
	  										          ) si 
								   ON de.division_id  = si.division_id																							 
	  							  AND de.item_id      = si.item_id																								 
	  							      LEFT OUTER JOIN (
									                  SELECT division_id, scm_site_id, country, city																						 
	  											        FROM scm_mst_site A WITH(NOLOCK) 
													   where a.valid_yn = 'Y'
													  ) f_ci 
								  ON de.division_id = f_ci.division_id AND si.scm_site_id = f_ci.scm_site_id		 	    
	  							      LEFT OUTER JOIN (
									                  SELECT division_id, scm_site_id,country,city																						 
	  											        FROM scm_mst_site A WITH(NOLOCK) 
													   WHERE a.valid_yn = 'Y'
													  ) t_ci 
								  ON de.division_id = t_ci.division_id AND de.scm_site_id = t_ci.scm_site_id		 
	 			    	     ) t 
	 					       LEFT JOIN ( 
							             SELECT DISTINCT from_country, from_city, to_country, to_city, transport_mode																 
	 									   FROM scp_mst_distribution_route WITH(NOLOCK)																											 
	 									  WHERE VALID_YN ='Y'																														 
	 								     ) u 
							ON t.from_country = u.from_country																										 
	 					   AND t.from_city    = u.from_city																											 
	 					   AND t.to_country   = u.to_country																											 
	 					   AND t.to_city      = u.to_city																												 
						 UNION ALL																																					
							/* 2-1. # Div = 81, BOD Requied - VMI = Y and scp_mst_bod not exists DAP raw insert.project_code, sales_site_id Join */										 
						SELECT a.division_id, a.to_site, a.customer, 'DAP' incoterms, a.from_site, a.from_country, a.from_city, a.to_country, a.to_city,a.transport_mode			 
 							  ,created_by, creation_date, last_updated_by, last_update_date																							 
						  FROM (																																						 
	  						   SELECT t.division_id, t.to_site, t.customer, t.incoterms, t.from_site, t.from_country, t.from_city, t.to_country, t.to_city,u.transport_mode			 
	 							     ,null created_by, null creation_date, null last_updated_by, null last_update_date																	 
	 						     FROM (																																					 
	 							      SELECT DISTINCT de.division_id, de.scm_site_id as to_site,  de.customer, de.Incoterms, si.scm_site_id AS from_site 									 
	 								       , f_ci.country   AS from_country																													 
	 								       , f_ci.city		AS from_city																													 
	 								       , t_ci.country	AS to_country																													 
	 								       , t_ci.city		AS to_city																														 
	 							        FROM ( 
										     SELECT f.division_id, f.scm_site_id, m.end_customer AS customer, f.incoterms, f.project_code, f.item_id											 
	  								           FROM dm_pln_mkt_fcst f WITH(NOLOCK)																															 
												    JOIN SCM_MST_DIVISION D WITH(NOLOCK)
												 ON F.DIVISION_ID = D.DIVISION_ID
	  								                JOIN scm_mst_site m WITH(NOLOCK) 
												 ON f.division_id = m.division_id 
												AND f.scm_site_id = m.scm_site_id 
												AND m.vmi_yn = 'Y'	
	  								                LEFT JOIN scm_mst_site s WITH(NOLOCK) 
												 ON s.DIVISION_ID=F.DIVISION_ID AND s.SCM_SITE_ID=F.SCM_SITE_ID AND s.VMI_YN='Y'										 
	  								          WHERE 1 = 1																																		 
	     							            AND D.ATTRIBUTE3 = '81'																											
	  								            AND F.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')															 
	  							             ) DE																																				 
	  							             LEFT OUTER JOIN (
										                     SELECT a.division_id, a.scm_site_id, b.item_id, b.project_code, c.priority ,c.sales_site_id, right(plant_site_id,1) plant_type		 
	  											               FROM scm_mst_site a WITH(NOLOCK)																											 
	  													          , scm_mst_site_item b WITH(NOLOCK)																										 
	  													          , scm_mst_site_item_priority c WITH(NOLOCK)	
																  , SCM_MST_DIVISION D WITH(NOLOCK)
	  											              WHERE a.division_id  = b.division_id																							 
	  												            AND a.scm_site_id  = b.scm_site_id																							 
	  												            AND b.division_id  = c.division_id																							 
	  												            AND b.scm_site_id  = c.PLANT_SITE_ID																							 
	  												            AND b.project_code = c.project_code																							 
	  												            AND b.item_id      = c.item_id	
																AND A.DIVISION_ID  = D.DIVISION_ID
	  												            AND a.valid_yn     = 'Y'																									 
	  												            AND b.valid_yn     = 'Y'																									 
	  												            AND c.valid_yn     = 'Y'																									 
	  												            AND a.site_type    = 'PLANT'																								 
	  												            AND D.ATTRIBUTE3   = '81'																								 
	  											             ) si 
								          ON de.division_id  = si.division_id																							 
	  							         AND ((si.plant_type  != 'E' AND de.project_code = si.project_code  AND de.scm_site_id  = si.sales_site_id) OR (si.plant_type = 'E'))																								 
	  							         AND de.item_id      = si.item_id																								 
	  							             LEFT OUTER JOIN (
									                         SELECT division_id, scm_site_id,country,city																						 
	  											               FROM scm_mst_site A WITH(NOLOCK) 
													          WHERE a.valid_yn = 'Y'
															 ) f_ci 
								          ON de.division_id = f_ci.division_id AND si.scm_site_id = f_ci.scm_site_id		 	    
	  							             LEFT OUTER JOIN (
									                         SELECT division_id, scm_site_id,country,city																						 
	  											               FROM scm_mst_site A WITH(NOLOCK) 
													          WHERE a.valid_yn = 'Y'
															 ) t_ci 
								          ON de.division_id = t_ci.division_id AND de.scm_site_id = t_ci.scm_site_id		 
	 			    	              ) t 
	 					              LEFT JOIN ( 
							                    SELECT DISTINCT from_country, from_city, to_country, to_city, transport_mode																	 
	 		 						              FROM scp_mst_distribution_route WITH(NOLOCK)																												 
	 								             WHERE valid_yn ='Y'																															 
	 							                ) u 
							       ON t.from_country = u.from_country																											 
	 					          AND t.from_city    = u.from_city																												 
	 					          AND t.to_country   = u.to_country																												 
	 					          AND t.to_city      = u.to_city																													 
					           ) a																																							 
	 			         WHERE NOT EXISTS ( 
				                          SELECT 1																																 
								            FROM (
								                 SELECT DISTINCT a.division_id, a.from_site, a.to_site, b.transport_mode 															 
	                  					           FROM scp_mst_bod a WITH(NOLOCK)																												 
	                  					         	    INNER JOIN scp_mst_bod_v b WITH(NOLOCK)  
										             ON a.division_id	= b.division_id																		
	 									            AND a.bod_id		= b.bod_id																				
	 									            AND a.from_site		= b.from_site																			
	 									            AND a.to_site		= b.to_site																				
	 									            AND a.incoterms		= b.incoterms																			 
	                  					          WHERE a.incoterms		= 'DAP'																										 
	                  				            ) b																																 
	 							          WHERE a.division_id		= b.division_id																									 
	 							            AND a.from_site			= b.from_site																									 
	 							            AND a.to_site			= b.to_site																										 
	 							            AND a.transport_mode	= b.transport_mode																								 
								         )																																		 
						 UNION ALL																																					
							/* 2-2. # Div = 40,82, BOD Requied - VMI = Y and scp_mst_bod not exists DAP raw insert. project_code, sales_site_id NOT Join */								 
						SELECT a.division_id, a.to_site, a.customer, 'DAP' incoterms, a.from_site, a.from_country, a.from_city, a.to_country, a.to_city,a.transport_mode			 
 							  ,created_by, creation_date, last_updated_by, last_update_date																							 
						  FROM (																																						 
	  						   SELECT t.division_id, t.to_site, t.customer, t.incoterms, t.from_site, t.from_country, t.from_city, t.to_country, t.to_city,u.transport_mode			 
	 							     ,null created_by, null creation_date, null last_updated_by, null last_update_date																	 
	 						     FROM (																																					 
	 							      SELECT DISTINCT de.division_id, de.scm_site_id as to_site,  de.customer, de.Incoterms, si.scm_site_id AS from_site 									 
	 								       , f_ci.country   AS from_country																													 
	 								       , f_ci.city		AS from_city																													 
	 								       , t_ci.country	AS to_country																													 
	 								       , t_ci.city		AS to_city																														 
	 							        FROM ( 
										     SELECT  f.division_id, f.scm_site_id, m.end_customer AS customer, f.incoterms, f.project_code, f.item_id											 
	  								           FROM dm_pln_mkt_fcst f WITH(NOLOCK)	
											        JOIN SCM_MST_DIVISION D WITH(NOLOCK)
												 ON F.DIVISION_ID = D.DIVISION_ID
	  								                JOIN scm_mst_site m WITH(NOLOCK) 
												 ON f.division_id = m.division_id 
												AND f.scm_site_id = m.scm_site_id 
												AND m.vmi_yn = 'Y'										 
	  								                LEFT JOIN scm_mst_site s WITH(NOLOCK) 
												 ON s.DIVISION_ID=F.DIVISION_ID 
												AND s.SCM_SITE_ID=F.SCM_SITE_ID 
												AND s.VMI_YN='Y'										 
	  								          WHERE 1 = 1																																		 
	     							            AND D.ATTRIBUTE3 IN ('40','82')																										
	  								            AND F.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')															 
	  							             ) DE																																				 
	  							             LEFT OUTER JOIN (
											                 SELECT a.division_id, a.scm_site_id, b.item_id, b.project_code, c.priority ,c.sales_site_id, right(plant_site_id,1) plant_type		 
	  											               FROM scm_mst_site a WITH(NOLOCK)																											 
	  													          , scm_mst_site_item b WITH(NOLOCK)																										 
	  													          , scm_mst_site_item_priority c WITH(NOLOCK)	
																  , SCM_MST_DIVISION D WITH(NOLOCK)
	  											              WHERE a.division_id  = b.division_id																							 
	  												            AND a.scm_site_id  = b.scm_site_id																							 
	  												            AND b.division_id  = c.division_id																							 
	  												            AND b.scm_site_id  = c.PLANT_SITE_ID																							 
	  												            AND b.project_code = c.project_code																							 
	  												            AND b.item_id      = c.item_id	
																AND A.DIVISION_ID  = D.DIVISION_ID
	  												            AND a.valid_yn     = 'Y'																									 
	  												            AND b.valid_yn     = 'Y'																									 
	  												            AND c.valid_yn     = 'Y'																									 
	  												            AND a.site_type    = 'PLANT'																								 
	  												            AND D.ATTRIBUTE3  IN ('40','82')																						 
	  											             ) si 
										  ON de.division_id  = si.division_id																							 
	  									 AND de.item_id      = si.item_id																								 
	  							             LEFT OUTER JOIN (
											                 SELECT division_id, scm_site_id,country,city																						 
	  											               FROM scm_mst_site A WITH(NOLOCK) 
															  WHERE a.valid_yn = 'Y'
															 ) f_ci 
										  ON de.division_id = f_ci.division_id AND si.scm_site_id = f_ci.scm_site_id		 	    
	  							             LEFT OUTER JOIN (
											                 SELECT division_id, scm_site_id,country,city																						 
	  											               FROM scm_mst_site A WITH(NOLOCK) 
															  WHERE a.valid_yn = 'Y'
															 ) t_ci 
										  ON de.division_id = t_ci.division_id AND de.scm_site_id = t_ci.scm_site_id		 
	 			    	              ) t 
	 					              LEFT JOIN ( 
							                    SELECT DISTINCT from_country, from_city, to_country, to_city, transport_mode																	 
	 		 						              FROM scp_mst_distribution_route WITH(NOLOCK)																												 
	 								             WHERE valid_yn ='Y'																															 
	 							                ) u 
						           ON t.from_country = u.from_country																											 
	 					          AND t.from_city    = u.from_city																												 
	 					          AND t.to_country   = u.to_country																												 
	 					          AND t.to_city      = u.to_city																													 
					           ) a																																							 
	 					 WHERE NOT EXISTS ( 
						                  SELECT 1																																 
										    FROM (
											     SELECT DISTINCT a.division_id, a.from_site, a.to_site, b.transport_mode 															 
	                  							   FROM scp_mst_bod a WITH(NOLOCK)																												 
	                  							        INNER JOIN scp_mst_bod_v b WITH(NOLOCK)  
													 ON a.division_id = b.division_id																		
	 											    AND a.bod_id = b.bod_id																				
	 											    AND a.from_site = b.from_site																			
	 											    AND a.to_site = b.to_site																				
	 											    AND a.incoterms = b.incoterms																			 
	                  							  WHERE a.incoterms = 'DAP'																										 
	                  							 ) b																																 
	 									   WHERE a.division_id    =  b.division_id																									 
	 									     AND a.from_site      =  b.from_site																									 
	 									     AND a.to_site        =  b.to_site																										 
	 									     AND a.transport_mode =  b.transport_mode																								 
									      )																																		 
						 UNION ALL																																					
						/*  3. BOD Completed - BOD Master */																															 
						SELECT a.division_id, a.to_site																																 
							  ,(SELECT end_customer FROM scm_mst_site WITH(NOLOCK) WHERE division_id = a.division_id AND scm_site_id = a.to_site) AS customer										 
							  ,a.incoterms, a.from_site																																 
							  ,f_ci.country AS from_country																															 
							  ,f_ci.city	   AS from_city																																 
							  ,t_ci.country AS to_country																															 
							  ,t_ci.city	   AS to_city																																 
							  ,ro.transport_mode																																		 
							  ,a.created_by,a.creation_date, a.last_updated_by,a.last_update_date																					 
						  FROM scp_mst_bod a WITH(NOLOCK)																																			 
							   INNER JOIN scp_mst_distribution_route ro WITH(NOLOCK)  
							ON a.route_id = ro.route_id																						 
	 					       LEFT OUTER JOIN scm_mst_site f_ci WITH(NOLOCK) 
							ON f_ci.division_id = a.division_id AND f_ci.scm_site_id = a.from_site AND f_ci.valid_yn = 'Y'							 
	 					       LEFT OUTER JOIN scm_mst_site t_ci WITH(NOLOCK) 
							ON t_ci.scm_site_id = a.to_site	   AND t_ci.valid_yn = 'Y'		
						 where a.attribute2 <= CONVERT(CHAR(8), GETDATE(), 112)
                           AND a.attribute3 >= CONVERT(CHAR(8), GETDATE(), 112)
						 UNION ALL																																					
						/* 4. BOD Required - VMI = N -> Y Change and scp_mst_bod not exists DAP raw insert. */																		 
						 SELECT a.division_id, a.to_site																															
							   ,(SELECT end_customer FROM scm_mst_site WITH(NOLOCK) WHERE division_id = a.division_id AND scm_site_id = a.to_site) AS customer									
							   ,'DAP' incoterms, a.from_site																														
							   ,from_country																																		
							   ,from_city																																			
							   ,to_country																																			
							   ,to_city																																				
							   ,transport_mode																																		
							   ,null created_by,null creation_date, null last_updated_by,null last_update_date																		
						   FROM (																																					
							    SELECT a.division_id, a.to_site																													 
							    	  ,(SELECT end_customer FROM scm_mst_site WITH(NOLOCK) WHERE division_id = a.division_id AND scm_site_id = a.to_site) AS customer							 
							    	  ,a.incoterms, a.from_site																													 
							    	  ,f_ci.country AS from_country																												 
							    	  ,f_ci.city	AS from_city																													 
							    	  ,t_ci.country AS to_country																													 
							    	  ,t_ci.city    AS to_city																														 
							    	  ,ro.transport_mode																															 
							    	  ,a.created_by,a.creation_date, a.last_updated_by,a.last_update_date																			 
							      FROM scp_mst_bod a WITH(NOLOCK)																																	 
							           INNER JOIN scp_mst_distribution_route ro WITH(NOLOCK)  
									ON a.route_id = ro.route_id																				 
	 							       LEFT OUTER JOIN scm_mst_site f_ci WITH(NOLOCK) 
									ON f_ci.division_id = a.division_id AND f_ci.scm_site_id = a.from_site AND f_ci.valid_yn = 'Y'					 
	 							       LEFT OUTER JOIN scm_mst_site t_ci WITH(NOLOCK) 
									ON t_ci.scm_site_id = a.to_site	  AND t_ci.VALID_YN = 'Y'	
								 where a.attribute2 <= CONVERT(CHAR(8), GETDATE(), 112)
                                   AND a.attribute3 >= CONVERT(CHAR(8), GETDATE(), 112)	
								) a																																					
							    INNER JOIN SCM_MST_SITE c WITH(NOLOCK) 
							 ON a.DIVISION_ID = c.DIVISION_ID AND a.to_site = c.SCM_SITE_ID																	
						  WHERE c.VMI_YN = 'Y'																																	
						    AND INCOTERMS != 'DAP'																																	
						    AND NOT EXISTS (
							               SELECT 1																																	
											 FROM (
											      SELECT distinct a.division_id, a.from_site, a.to_site, b.transport_mode															
    				  								FROM scp_mst_bod a WITH(NOLOCK)																												
    				  								     INNER JOIN scp_mst_bod_v b WITH(NOLOCK) 
													  ON a.division_id = b.division_id																		
													 AND a.bod_id = b.bod_id																				
													 AND a.from_site = b.from_site																			
													 AND a.to_site = b.to_site																				
													 AND a.incoterms = b.incoterms																			
    				  							   WHERE a.incoterms = 'DAP'																										
												  ) b																																
												  INNER JOIN scm_mst_site c WITH(NOLOCK) 
											   ON a.division_id = c.division_id AND b.to_site = c.scm_site_id												
											WHERE c.vmi_yn       =  'Y'																											
											  AND a.from_site      =  b.from_site																										
											  AND a.to_site        =  b.to_site																										
											  AND a.transport_mode =  b.transport_mode																								
										   )																																			
		              ) ma																																										 
			          /* bo table - Trasport Mode Add  */																																			 
		              LEFT OUTER JOIN ( 
					                  SELECT a.*, b.transport_mode																																 
								        FROM scp_mst_bod a WITH(NOLOCK)																																		 
								             INNER JOIN scp_mst_distribution_route b WITH(NOLOCK) 
										  ON a.ROUTE_ID = b.ROUTE_ID																						 
							          ) bo 
				   ON bo.division_id	= ma.division_id																													 
	 			  AND bo.to_site		= ma.to_site																														 
	 			  AND bo.incoterms		= ma.incoterms																													 
	 			  AND bo.from_site		= ma.from_site																													 
	 			  AND bo.transport_mode	= ma.transport_mode																												 
			     /* ro table - Distribution Route Add */																																		 
		              LEFT OUTER JOIN scp_mst_distribution_route ro WITH(NOLOCK)  
				   ON bo.route_id		= ro.route_id																									 
		              INNER JOIN #TblDynamicPivot_KPI_BOD_from fr WITH(NOLOCK)  
				   ON fr.scm_site_id	= ma.from_site																								 
		              INNER JOIN #TblDynamicPivot_KPI_BOD_to tr WITH(NOLOCK)  
				   ON tr.scm_site_id	= ma.to_site																									 
		              INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL up WITH(NOLOCK)  
				   ON up.LOOKUP_TYPE	= 'INCOTERMS' 
				  AND up.VALID_YN		= 'Y' 
				  AND up.SEGMENT1		= ma.incoterms	
				      JOIN SCM_MST_DIVISION D WITH(NOLOCK)
				   ON MA.DIVISION_ID	= D.DIVISION_ID

		        WHERE 1 = 1																																									 
		        -- R : Required
	 	          AND bo.route_id IS NULL				
		        -- 조회조건 
	 	          AND D.ATTRIBUTE3 IN ('40','81','82')	
		       ) T	

		 -- 법인간 거래 - 실제 매출 Incoterms 적용   
		       LEFT OUTER JOIN SCP_MST_BOD_V  S WITH(NOLOCK)
		    ON S.DIVISION_ID	= T.DIVISION_ID
		   AND S.FROM_SITE		= T.from_site
		   AND S.TO_SITE		= T.TO_SITE
		   AND (S.INCOTERMS		= T.INCOTERMS OR S.SSP_INCOTERMS  = T.INCOTERMS)

		 -- From Site가 외주 이고 오른쪽 끝이 'A'(Cell) 인건은 Required에서 보여주지 않음.  Completed 에서는 공장간 이동 등록된것 보여야 함
		 WHERE NOT EXISTS (
		                  SELECT 1 
						    FROM scm_mst_site s with(nolock)
						   WHERE s.division_id = t.division_id AND s.scm_site_id = t.from_site AND s.valid_yn = 'Y' AND s.osp_yn = 'Y' AND s.operation_group = 'A'
						  )	
		 ; 
		------------------------------------------------------------------------------------------------------------- 
		-- 2. SSP_KPI_ASA_AUTO_SO_APPLY
		-------------------------------------------------------------------------------------------------------------
		 
		INSERT INTO SSP_KPI_BR_BOD_REGISTRATION (
				 YYYYMMDD               
				,YYYYMM                 
				,WEEK_NAME              
				,DIVISION_ID            
				,FROM_SITE
				,FROM_CITY              
				,TO_SITE
				,TO_CITY
				,VMI_YN
				,INCOTERMS
				,TRANSPORT_MODE
				,ROUTE_CNT
				,CUSTOMER                
				,CREATED_BY                      
				,CREATION_DATE    
				,LAST_UPDATED_BY  
				,LAST_UPDATE_DATE 
				,ATTRIBUTE1       
				,ATTRIBUTE2       
				,ATTRIBUTE3       
				,ATTRIBUTE4       
				,ATTRIBUTE5       
				,ATTRIBUTE6       
				,ATTRIBUTE7       
				,ATTRIBUTE8       
				,ATTRIBUTE9       
				,ATTRIBUTE10      
		  )
		  SELECT A.YYYYMMDD               
				,C.BASIS_YYYYMM -- YYYYMM                 
				,C.WEEK_NAME              
				,A.DIVISION_ID            
				,A.FROM_SITE
				,A.FROM_CITY              
				,A.TO_SITE
				,A.TO_CITY
				,A.VMI_YN
				,A.INCOTERMS
				,A.TRANSPORT_MODE
				,A.ROUTE_CNT
				,A.CUSTOMER                
				,@v_batch_user  -- CREATED_BY                     
				,GETDATE()      -- CREATION_DATE    
				,@v_batch_user  -- LAST_UPDATED_BY
				,GETDATE()      -- LAST_UPDATE_DATE 
				,C.ISO_YYYYWW   -- ATTRIBUTE1       
				,NULL			-- ATTRIBUTE2       
				,NULL			-- ATTRIBUTE3       
				,NULL			-- ATTRIBUTE4       
				,NULL			-- ATTRIBUTE5       
				,NULL			-- ATTRIBUTE6       
				,NULL			-- ATTRIBUTE7       
				,NULL			-- ATTRIBUTE8       
				,NULL			-- ATTRIBUTE9       
				,NULL			-- ATTRIBUTE10      
		  FROM #tmp_SSP_KPI_BR_BOD_REGISTRATION A WITH (NOLOCK)
		       JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
			ON C.BASIS_YYYYMMDD = A.YYYYMMDD 
		  ;



        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT TRAN TX_SH;
          END;       


        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date =  SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH


        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
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

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['++'][' + @v_exec_time + ']';  
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

  END;  
