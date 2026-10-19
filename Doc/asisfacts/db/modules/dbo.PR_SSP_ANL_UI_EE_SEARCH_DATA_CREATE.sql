
 /*
 * Program ID   : PR_SSP_ANL_UI_EE_SEARCH_DATA_CREATE
 * Description  : SSP Divison 'EE' 일 경우 조회조건 Lookup 테이블에 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/08/30   ygkim	       Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/09/04   ygkim		   @p_plan_start_yyyymmdd, @p_seq, @p_plan_type 파라미터 추가
                               Delete -> Insert에서 값이 없으면 Insert 하도록 수정
 * 2018/09/18   ygkim		   EE_SHIPMENT_PLAN 추가
 * ex) exec PR_SSP_ANL_UI_EE_SEARCH_DATA_CREATE '20180806', '2', 'MA'
    
 */
    
CREATE PROCEDURE [dbo].[PR_SSP_ANL_UI_EE_SEARCH_DATA_CREATE]   
     @p_plan_start_yyyymmdd	NVARCHAR(30)
	 ,@p_seq					NVARCHAR(10)
	 ,@p_plan_type				NVARCHAR(10)
AS    
  BEGIN    
    SET NOCOUNT ON;
	  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- LOG 용 변수 설정        
    DECLARE @v_batch_user     NVARCHAR(150) = N'scp_batch';              
    DECLARE @v_program_name   NVARCHAR(150) = N'PR_SSP_ANL_UI_EE_SEARCH_DATA_CREATE';        
    DECLARE @v_log_type       NVARCHAR(30); -- START/END/ERROR/...        
    DECLARE @n_log_count      INTEGER = 0;        
    DECLARE @v_log_message    NVARCHAR(1000);        
    DECLARE @v_description    NVARCHAR(500);      
    DECLARE @v_table_id       NVARCHAR(150) = N'SCM_SYS_LOG_BATC';     
    DECLARE @d_event_date     DATETIME;        
	DECLARE @v_chk			      INT;
    DECLARE @v_lookup_type    NVARCHAR(200)
	DECLARE @v_segment1		    NVARCHAR(200)
	DECLARE @v_segment2		    NVARCHAR(200)
	DECLARE @v_segment3		    NVARCHAR(200)
	DECLARE @v_segment4		    NVARCHAR(200)
	DECLARE @v_segment5		    NVARCHAR(200)
	DECLARE @v_display_seq    INT
	DECLARE @v_last_update_by NVARCHAR(300) = N'scp_batch';

  -- 시작 LOG        
    SET @v_log_type = N'START';        
    SET @v_log_message = N'########## Start of procedure ##########';        
    SET @v_description = @v_program_name + ':' + N' PR_SSP_ANL_UI_EE_SEARCH_DATA_CREATE INSERT LOGIC';        
    SET @d_event_date = SYSDATETIME();        
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name        
                              ,@p_log_type      =@v_log_type        
                              ,@p_log_count     =@n_log_count         
                              ,@p_log_message   =@v_log_message         
                              ,@p_description   =@v_description         
                              ,@p_event_date    =@d_event_date         
                              ,@p_user_id       =@v_batch_user        
                              ;        

	BEGIN TRY
		BEGIN
			IF OBJECT_ID('tempdb..#Tbl_ADM_LOOKUP_MASTER_DETAIL') IS NOT NULL
			  DROP TABLE #Tbl_ADM_LOOKUP_MASTER_DETAIL

			CREATE TABLE #Tbl_ADM_LOOKUP_MASTER_DETAIL (
			   LOOKUP_TYPE     nvarchar(100)
			  ,SEGMENT1			   nvarchar(100) 
			  ,SEGMENT2        nvarchar(100) --OPERATION_GROUP or BIZ_TYPE
			  ,SEGMENT3        nvarchar(100) --FROM_SITE or TO_SITE
			  ,SEGMENT4        nvarchar(100) 
			  ,SEGMENT5			   nvarchar(100)
			  ,DISPLAY_SEQ		 INT
			  ,ATTRIBUTE1		   nvarchar(150)
			  ,ATTRIBUTE2		   nvarchar(150)
			);

			-------------------------------------------------------------------------------------------------------------     
			-- 1. SSP_ANL_PSI_PRODUCTION Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
			--  AND SEGMENT1 = 'SSP';

			INSERT INTO #Tbl_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					)
			SELECT 'EE_PSI_PRODUCTION' LOOKUP_TYPE
				  ,'SSP' SEGMENT1
				  ,OPERATION_GROUP SEGMENT2
				  ,FROM_SITE SEGMENT3
				  ,'-' SEGMENT4
				  ,'-' SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ				  
			FROM(
				SELECT DIVISION_ID, OPERATION_GROUP, FROM_SITE
				FROM(
					SELECT distinct DIVISION_ID, OPERATION_GROUP, FROM_SITE--, TO_SITE
					FROM SSP_ANL_PSI_PRODUCTION A WITH (NOLOCK)
					WHERE DIVISION_ID = 'EE'
						AND OPERATION_GROUP IN ('A','E')
						AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND SEQ = @p_seq
						AND PLAN_TYPE = @p_plan_type
				) A WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B  WITH(NOLOCK)
										WHERE LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
										AND SEGMENT1 = 'SSP' 
										AND B.SEGMENT2 = A.OPERATION_GROUP
										AND B.SEGMENT3 = A.FROM_SITE
									)
			) A 
			ORDER BY DIVISION_ID, OPERATION_GROUP, FROM_SITE		  
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				    )
			SELECT LOOKUP_TYPE
				  ,SEGMENT1
				  ,SEGMENT2
				  ,SEGMENT3
				  ,SEGMENT4
				  ,SEGMENT5
				  ,DISPLAY_SEQ
				  ,'Y' VALID_YN
				  ,LOOKUP_TYPE DESCRIPTION
				  ,@v_last_update_by CREATED_BY
				  ,SYSDATETIME() CREATION_DATE
				  ,@v_last_update_by LAST_UPDATED_BY
				  ,SYSDATETIME() LAST_UPDATE_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK)
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
					(HISTORY_SEQ
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,HISTORY_CREATION_DATE
				    )
			SELECT NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,'Y' VALID_YN
					,LOOKUP_TYPE DESCRIPTION
					,@v_last_update_by CREATED_BY
					,SYSDATETIME() CREATION_DATE
					,@v_last_update_by LAST_UPDATED_BY
					,SYSDATETIME() LAST_UPDATE_DATE
					,SYSDATETIME() HISTORY_CREATION_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK);

			DELETE FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL;
			----------------------------------------------------------------------------------------------------------------------- 
			
			-------------------------------------------------------------------------------------------------------------     
			-- 2. SSP_ANL_PROBLEM_REPORT_DEMAND Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
			--  AND SEGMENT1 = 'SSP';

			INSERT INTO #Tbl_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					)
			SELECT 'EE_PROBLEM_REPORT_DEMAND' LOOKUP_TYPE
				  ,'SSP' SEGMENT1
				  ,PLANT_SITE_ID SEGMENT2
				  ,SALES_SITE_ID SEGMENT3
				  ,'-' SEGMENT4
				  ,'-' SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ				  
			FROM(
				SELECT DIVISION_ID, PLANT_SITE_ID, SALES_SITE_ID
				FROM
				(
					SELECT DISTINCT DIVISION_ID, PLANT_SITE_ID, SALES_SITE_ID
					FROM SSP_ANL_PROBLEM_REPORT_DEMAND A WITH(NOLOCK)
					WHERE DIVISION_ID = 'EE'
					  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					  AND SEQ = @p_seq
					  AND PLAN_TYPE = @p_plan_type
				) A WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									  WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
										AND SEGMENT1 = 'SSP'	
										AND SEGMENT2 = A.PLANT_SITE_ID
										AND SEGMENT3 = A.SALES_SITE_ID
									 )
			) A 
			ORDER BY DIVISION_ID, PLANT_SITE_ID, SALES_SITE_ID		  
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				    )
			SELECT LOOKUP_TYPE
				  ,SEGMENT1
				  ,SEGMENT2
				  ,SEGMENT3
				  ,SEGMENT4
				  ,SEGMENT5
				  ,DISPLAY_SEQ
				  ,'Y' VALID_YN
				  ,LOOKUP_TYPE DESCRIPTION
				  ,@v_last_update_by CREATED_BY
				  ,SYSDATETIME() CREATION_DATE
				  ,@v_last_update_by LAST_UPDATED_BY
				  ,SYSDATETIME() LAST_UPDATE_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A   WITH (NOLOCK)	  
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
					(HISTORY_SEQ
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,HISTORY_CREATION_DATE
				    )
			SELECT NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,'Y' VALID_YN
					,LOOKUP_TYPE DESCRIPTION
					,@v_last_update_by CREATED_BY
					,SYSDATETIME() CREATION_DATE
					,@v_last_update_by LAST_UPDATED_BY
					,SYSDATETIME() LAST_UPDATE_DATE
					,SYSDATETIME() HISTORY_CREATION_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK);

			DELETE FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL ;
			----------------------------------------------------------------------------------------------------------------------- 

			-------------------------------------------------------------------------------------------------------------     
			-- 3. SSP_ANL_PRODUCTION_PLAN Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
			--  AND SEGMENT1 = 'SSP';

			INSERT INTO #Tbl_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,ATTRIBUTE1
					)
			SELECT 'EE_PRODUCTION_PLAN' LOOKUP_TYPE
				  ,'SSP' SEGMENT1
				  ,OPERATION_GROUP SEGMENT2
				  ,SCM_SITE_ID SEGMENT3
				  ,LINE_ID SEGMENT4
				  ,OPERATION_ID SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ		
				  ,ORIGIN_DIVISION_ID	ATTRIBUTE1 
			FROM(
					SELECT DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID, OPERATION_ID
					FROM(
							SELECT DISTINCT DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID, OPERATION_ID
							FROM SSP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							WHERE DIVISION_ID = 'EE'
								AND OPERATION_GROUP IN ('A','E')
								AND LINE_ID NOT IN ('*')
								AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
								AND SEQ = @p_seq
								AND PLAN_TYPE = @p_plan_type
						) A WHERE NOT EXISTS(SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
											WHERE LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
											AND SEGMENT1 = 'SSP'
											AND SEGMENT2 = A.OPERATION_GROUP
											AND SEGMENT3 = A.SCM_SITE_ID
											AND SEGMENT4 = A.LINE_ID
											AND SEGMENT5 = A.OPERATION_ID
											)
			) A 
			ORDER BY DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID,OPERATION_ID	  
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,ATTRIBUTE1
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				    )
			SELECT LOOKUP_TYPE
				  ,SEGMENT1
				  ,SEGMENT2
				  ,SEGMENT3
				  ,SEGMENT4
				  ,SEGMENT5
				  ,DISPLAY_SEQ
				  ,ATTRIBUTE1
				  ,'Y' VALID_YN
				  ,LOOKUP_TYPE DESCRIPTION
				  ,@v_last_update_by CREATED_BY
				  ,SYSDATETIME() CREATION_DATE
				  ,@v_last_update_by LAST_UPDATED_BY
				  ,SYSDATETIME() LAST_UPDATE_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A   WITH (NOLOCK)	  
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
					(HISTORY_SEQ
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,ATTRIBUTE1
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,HISTORY_CREATION_DATE
				    )
			SELECT NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,ATTRIBUTE1
					,'Y' VALID_YN
					,LOOKUP_TYPE DESCRIPTION
					,@v_last_update_by CREATED_BY
					,SYSDATETIME() CREATION_DATE
					,@v_last_update_by LAST_UPDATED_BY
					,SYSDATETIME() LAST_UPDATE_DATE
					,SYSDATETIME() HISTORY_CREATION_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK);

			DELETE FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL;
			----------------------------------------------------------------------------------------------------------------------- 

			-------------------------------------------------------------------------------------------------------------     
			-- 4. SSP_ANL_SHIPMENT_PLAN_FG Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
			--  AND SEGMENT1 = 'SSP';

			INSERT INTO #Tbl_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					)
			SELECT 'EE_SHIPMENT_PLAN_FG' LOOKUP_TYPE
				  ,'SSP' SEGMENT1
				  ,BIZ_TYPE SEGMENT2
				  ,TO_SITE SEGMENT3
				  ,'-' SEGMENT4
				  ,'-' SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ	
			FROM(
				SELECT DIVISION_ID, BIZ_TYPE, TO_SITE
				FROM(
					SELECT DISTINCT DIVISION_ID, BIZ_TYPE, TO_SITE
					FROM SSP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
					WHERE DIVISION_ID = 'EE'
					  AND BIZ_TYPE IN ('A','E')
					  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					  AND SEQ = @p_seq
					  AND PLAN_TYPE = @p_plan_type
				) A WHERE NOT EXISTS(SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									 WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
									   AND SEGMENT1 = 'SSP'
									   AND SEGMENT2 = A.BIZ_TYPE
									   AND SEGMENT3 = A.TO_SITE
									 )
			) A 
			ORDER BY DIVISION_ID, BIZ_TYPE, TO_SITE
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				    )
			SELECT LOOKUP_TYPE
				  ,SEGMENT1
				  ,SEGMENT2
				  ,SEGMENT3
				  ,SEGMENT4
				  ,SEGMENT5
				  ,DISPLAY_SEQ
				  ,'Y' VALID_YN
				  ,LOOKUP_TYPE DESCRIPTION
				  ,@v_last_update_by CREATED_BY
				  ,SYSDATETIME() CREATION_DATE
				  ,@v_last_update_by LAST_UPDATED_BY
				  ,SYSDATETIME() LAST_UPDATE_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK) 	  
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
					(HISTORY_SEQ
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,HISTORY_CREATION_DATE
				    )
			SELECT NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,'Y' VALID_YN
					,LOOKUP_TYPE DESCRIPTION
					,@v_last_update_by CREATED_BY
					,SYSDATETIME() CREATION_DATE
					,@v_last_update_by LAST_UPDATED_BY
					,SYSDATETIME() LAST_UPDATE_DATE
					,SYSDATETIME() HISTORY_CREATION_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK);

			DELETE FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL;
			----------------------------------------------------------------------------------------------------------------------- 

			-------------------------------------------------------------------------------------------------------------     
			-- 5. SSP_ANL_SHIPMENT_PLAN_SEMI Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_SEMI'
			--  AND SEGMENT1 = 'SSP';

			INSERT INTO #Tbl_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					)
			SELECT 'EE_SHIPMENT_PLAN_SEMI' LOOKUP_TYPE
				  ,'SSP' SEGMENT1
				  ,OPERATION_GROUP SEGMENT2
				  ,TO_SITE SEGMENT3
				  ,'-' SEGMENT4
				  ,'-' SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ	
			FROM(
				SELECT DIVISION_ID, OPERATION_GROUP, TO_SITE
				FROM(
					SELECT DISTINCT DIVISION_ID, OPERATION_GROUP, TO_SITE
					FROM SSP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)
					WHERE DIVISION_ID = 'EE'
					  AND OPERATION_GROUP IN ('A','E')
					  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					  AND SEQ = @p_seq
					  AND PLAN_TYPE = @p_plan_type
				) A WHERE NOT EXISTS(SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									 WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_SEMI'
									   AND SEGMENT1 = 'SSP'
									   AND B.SEGMENT2 = A.OPERATION_GROUP
									   AND B.SEGMENT3 = A.TO_SITE)
			) A 
			ORDER BY DIVISION_ID, OPERATION_GROUP, TO_SITE
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				    )
			SELECT LOOKUP_TYPE
				  ,SEGMENT1
				  ,SEGMENT2
				  ,SEGMENT3
				  ,SEGMENT4
				  ,SEGMENT5
				  ,DISPLAY_SEQ
				  ,'Y' VALID_YN
				  ,LOOKUP_TYPE DESCRIPTION
				  ,@v_last_update_by CREATED_BY
				  ,SYSDATETIME() CREATION_DATE
				  ,@v_last_update_by LAST_UPDATED_BY
				  ,SYSDATETIME() LAST_UPDATE_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A   WITH (NOLOCK)	  
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
					(HISTORY_SEQ
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,HISTORY_CREATION_DATE
				    )
			SELECT NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,'Y' VALID_YN
					,LOOKUP_TYPE DESCRIPTION
					,@v_last_update_by CREATED_BY
					,SYSDATETIME() CREATION_DATE
					,@v_last_update_by LAST_UPDATED_BY
					,SYSDATETIME() LAST_UPDATE_DATE
					,SYSDATETIME() HISTORY_CREATION_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK);

			DELETE FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL;
			----------------------------------------------------------------------------------------------------------------------- 
			
			-------------------------------------------------------------------------------------------------------------     
			-- 6. SSP_ANL_SHIP_PLAN Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
			--  AND SEGMENT1 = 'SSP';

			INSERT INTO #Tbl_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					)
			SELECT 'EE_SHIPMENT_PLAN' LOOKUP_TYPE
				  ,FROM_SITE SEGMENT1
				  ,TO_SITE SEGMENT2
				  ,'-' SEGMENT3
				  ,'-' SEGMENT4
				  ,'-' SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ				  
			FROM(
				SELECT DIVISION_ID, FROM_SITE, TO_SITE
				FROM(
					SELECT distinct DIVISION_ID, FROM_SITE, TO_SITE
					FROM SSP_ANL_SHIP_PLAN A WITH (NOLOCK)
					WHERE DIVISION_ID = 'EE'
						AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND SEQ = @p_seq
						AND MEASURE = 'SHIP_PLAN'
				) A WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B  WITH(NOLOCK)
										WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN'
										AND B.SEGMENT1 = A.FROM_SITE
										AND B.SEGMENT2 = A.TO_SITE
									)
			) A 
			ORDER BY DIVISION_ID, FROM_SITE, TO_SITE		  
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				    )
			SELECT LOOKUP_TYPE
				  ,SEGMENT1
				  ,SEGMENT2
				  ,SEGMENT3
				  ,SEGMENT4
				  ,SEGMENT5
				  ,DISPLAY_SEQ
				  ,'Y' VALID_YN
				  ,LOOKUP_TYPE DESCRIPTION
				  ,@v_last_update_by CREATED_BY
				  ,SYSDATETIME() CREATION_DATE
				  ,@v_last_update_by LAST_UPDATED_BY
				  ,SYSDATETIME() LAST_UPDATE_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK)
			  ;

			INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
					(HISTORY_SEQ
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,HISTORY_CREATION_DATE
				    )
			SELECT NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
					,LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,'Y' VALID_YN
					,LOOKUP_TYPE DESCRIPTION
					,@v_last_update_by CREATED_BY
					,SYSDATETIME() CREATION_DATE
					,@v_last_update_by LAST_UPDATED_BY
					,SYSDATETIME() LAST_UPDATE_DATE
					,SYSDATETIME() HISTORY_CREATION_DATE
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK);

			-- 종료 LOG    
			SET @v_log_type = N'END';    
			SET @v_log_message = N'########## END of procedure ##########';    
			SET @v_description = @v_program_name + ':' + N' PR_SSP_ANL_UI_EE_SEARCH_DATA_CREATE INSERT LOGIC END';         
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
		END
	END TRY

	BEGIN CATCH
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
	  
 END;     
    
    

