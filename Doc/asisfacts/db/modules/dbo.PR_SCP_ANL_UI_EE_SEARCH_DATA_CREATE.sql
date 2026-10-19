
 /*
 * Program ID   : PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE
 * Description  : SCP Divison 'EE' 일 경우 조회조건 Lookup 테이블에 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/08/30   ygkim	       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/04   ygkim		   @p_plan_start_yyyymmdd, @p_seq, @p_plan_type 파라미터 추가
                               Delete -> Insert에서 값이 없으면 Insert 하도록 수정
 * 2022.03.23	KSW			   GM JV 반영 :: 81_UC, EE_UC  추가
 * 2022.06.30   KSW            @p_division_id 추가
 * 2025.03.14   KIMCD          LOOKUP TYPE 'EE_PRODUCTION_PLAN' ATTRIBUTE2에 DIVISION_ID 중복 오류 보완
 * ex) exec PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE '20180806', '2', 'MA'
    
 */
    
CREATE PROCEDURE [dbo].[PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE]   
      @p_plan_start_yyyymmdd	NVARCHAR(30)
	 ,@p_seq					NVARCHAR(10)
	 ,@p_plan_type				NVARCHAR(10)
    , @p_division_id            NVARCHAR(0030) 
AS    
  BEGIN    
    SET NOCOUNT ON;
	  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- LOG 용 변수 설정        
    DECLARE @v_batch_user     NVARCHAR(150) = N'scp_batch';              
    DECLARE @v_program_name   NVARCHAR(150) = N'PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE';        
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
    SET @v_description = @v_program_name + ':' + N' PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE INSERT LOGIC';        
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
			   LOOKUP_TYPE    nvarchar(100)
			  ,SEGMENT1			  nvarchar(100) 
			  ,SEGMENT2       nvarchar(100) --OPERATION_GROUP or BIZ_TYPE
			  ,SEGMENT3       nvarchar(100) --FROM_SITE or TO_SITE
			  ,SEGMENT4       nvarchar(100) 
			  ,SEGMENT5			  nvarchar(100)
			  ,DISPLAY_SEQ		INT
			  ,ATTRIBUTE1		  nvarchar(150)
			  ,ATTRIBUTE2		  nvarchar(150)
			);

			-------------------------------------------------------------------------------------------------------------     
			-- 1. SCP_ANL_PSI_PRODUCTION Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
			--  AND SEGMENT1 = 'SCP';

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
				  ,'SCP' SEGMENT1
				  ,OPERATION_GROUP SEGMENT2
				  ,FROM_SITE       SEGMENT3
				  ,DIVISION_ID     SEGMENT4 -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
				  ,'-' SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ				  
			FROM(
					SELECT DIVISION_ID, OPERATION_GROUP, FROM_SITE
					FROM(
						SELECT distinct DIVISION_ID, OPERATION_GROUP, FROM_SITE--, TO_SITE
						FROM SCP_ANL_PSI_PRODUCTION A WITH (NOLOCK)
						WHERE DIVISION_ID     = @p_division_id								-- 2022.03.23	KSW	GM JV 반영 :: @p_division_id  추가
						  AND OPERATION_GROUP IN ('A','E')
						  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						  AND SEQ = @p_seq
						  AND PLAN_TYPE = @p_plan_type
					) A WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B  WITH(NOLOCK)
											WHERE LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
											AND SEGMENT1 = 'SCP' 
											AND B.SEGMENT2 = A.OPERATION_GROUP
											AND B.SEGMENT3 = A.FROM_SITE
											AND B.SEGMENT4 = A.DIVISION_ID -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
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
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)
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
			-- 2. SCP_ANL_PROBLEM_REPORT_DEMAND Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
			--  AND SEGMENT1 = 'SCP';

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
				  ,'SCP' SEGMENT1
				  ,PLANT_SITE_ID SEGMENT2
				  ,SALES_SITE_ID SEGMENT3
				  ,DIVISION_ID   SEGMENT4 -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
				  ,'-' SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ				  
			FROM(
				SELECT DIVISION_ID, PLANT_SITE_ID, SALES_SITE_ID
				FROM
				(
					SELECT DISTINCT DIVISION_ID, PLANT_SITE_ID, SALES_SITE_ID
					FROM SCP_ANL_PROBLEM_REPORT_DEMAND A WITH(NOLOCK)
					WHERE DIVISION_ID         = @p_division_id					-- 2022.03.23	KSW	GM JV 반영 :: @p_division_id  추가
					  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					  AND SEQ = @p_seq
					  AND PLAN_TYPE = @p_plan_type
				) A WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									  WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
										AND SEGMENT1 = 'SCP'	
										AND SEGMENT2 = A.PLANT_SITE_ID
										AND SEGMENT3 = A.SALES_SITE_ID
										AND SEGMENT4 = A.DIVISION_ID -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
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
			-- 3. SCP_ANL_PRODUCTION_PLAN Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
			--  AND SEGMENT1 = 'SCP';

			INSERT INTO #Tbl_ADM_LOOKUP_MASTER_DETAIL
					(LOOKUP_TYPE
					,SEGMENT1
					,SEGMENT2
					,SEGMENT3
					,SEGMENT4
					,SEGMENT5
					,DISPLAY_SEQ
					,ATTRIBUTE1
					,ATTRIBUTE2 -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
					)
			SELECT 'EE_PRODUCTION_PLAN' LOOKUP_TYPE
				  ,'SCP' SEGMENT1
				  ,OPERATION_GROUP SEGMENT2
				  ,SCM_SITE_ID     SEGMENT3
				  ,LINE_ID         SEGMENT4
				  ,OPERATION_ID    SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ		
				  ,ORIGIN_DIVISION_ID	ATTRIBUTE1 	
				  ,DIVISION_ID	        ATTRIBUTE2 -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
			FROM(
					SELECT DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID, OPERATION_ID
					FROM(
							SELECT DISTINCT DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID, OPERATION_ID
							FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							WHERE DIVISION_ID     = @p_division_id			-- 2022.03.23	KSW	GM JV 반영 :: @p_division_id  추가
							  AND OPERATION_GROUP IN ('A','E')
							  AND LINE_ID NOT IN ('*')
							  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							  AND SEQ = @p_seq
							  AND PLAN_TYPE = @p_plan_type
					 ) A WHERE NOT EXISTS(SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
										  WHERE LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
										    AND SEGMENT1 = 'SCP'
											AND SEGMENT2 = A.OPERATION_GROUP
											AND SEGMENT3 = A.SCM_SITE_ID
											AND SEGMENT4 = A.LINE_ID
											AND SEGMENT5 = A.OPERATION_ID
											AND ATTRIBUTE2 = A.DIVISION_ID -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
										  )
			) A 
			ORDER BY DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID,OPERATION_ID	  
			  ;

			-- 2025-03-14   KIMCD   LOOKUP TYPE 'EE_PRODUCTION_PLAN' ATTRIBUTE2에 DIVISION_ID 중복 오류 방지위해 MERGE로 변경
			MERGE INTO SCM_ADM_LOOKUP_MASTER_DETAIL   SAD
			USING (	SELECT LOOKUP_TYPE
				          ,SEGMENT1
				          ,SEGMENT2
				          ,SEGMENT3
				          ,SEGMENT4
				          ,SEGMENT5
				          ,DISPLAY_SEQ
				          ,ATTRIBUTE1
				          ,ATTRIBUTE2
				          ,'Y' VALID_YN
				          ,LOOKUP_TYPE DESCRIPTION
				          ,@v_last_update_by CREATED_BY
				          ,SYSDATETIME() CREATION_DATE
				          ,@v_last_update_by LAST_UPDATED_BY
				          ,SYSDATETIME() LAST_UPDATE_DATE
			        FROM  #Tbl_ADM_LOOKUP_MASTER_DETAIL A   WITH (NOLOCK)
                    )   TAD
			ON (    SAD.LOOKUP_TYPE  = TAD.LOOKUP_TYPE
				AND SAD.SEGMENT1     = TAD.SEGMENT1
				AND SAD.SEGMENT2     = TAD.SEGMENT2
				AND SAD.SEGMENT3     = TAD.SEGMENT3
				AND SAD.SEGMENT4     = TAD.SEGMENT4
				AND SAD.SEGMENT5     = TAD.SEGMENT5
			    )
			WHEN MATCHED THEN
			    UPDATE SET SAD.DISPLAY_SEQ       = TAD.DISPLAY_SEQ
				          ,SAD.ATTRIBUTE1        = TAD.ATTRIBUTE1
				          ,SAD.ATTRIBUTE2        = TAD.ATTRIBUTE2
				          ,SAD.VALID_YN          = TAD.VALID_YN
				          ,SAD.DESCRIPTION       = TAD.DESCRIPTION
				          ,SAD.LAST_UPDATED_BY   = TAD.LAST_UPDATED_BY
				          ,SAD.LAST_UPDATE_DATE  = TAD.LAST_UPDATE_DATE
			WHEN NOT MATCHED THEN
				INSERT ( LOOKUP_TYPE
					    ,SEGMENT1
					    ,SEGMENT2
					    ,SEGMENT3
					    ,SEGMENT4
					    ,SEGMENT5
					    ,DISPLAY_SEQ
					    ,ATTRIBUTE1
					    ,ATTRIBUTE2
					    ,VALID_YN
					    ,DESCRIPTION
					    ,CREATED_BY
					    ,CREATION_DATE
					    ,LAST_UPDATED_BY
					    ,LAST_UPDATE_DATE
				        )
				VALUES ( TAD.LOOKUP_TYPE
					    ,TAD.SEGMENT1
					    ,TAD.SEGMENT2
					    ,TAD.SEGMENT3
					    ,TAD.SEGMENT4
					    ,TAD.SEGMENT5
					    ,TAD.DISPLAY_SEQ
					    ,TAD.ATTRIBUTE1
					    ,TAD.ATTRIBUTE2
					    ,TAD.VALID_YN
					    ,TAD.DESCRIPTION
					    ,TAD.CREATED_BY
					    ,TAD.CREATION_DATE
					    ,TAD.LAST_UPDATED_BY
					    ,TAD.LAST_UPDATE_DATE
				        )
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
			FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK);

			DELETE FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL;
			----------------------------------------------------------------------------------------------------------------------- 

			-------------------------------------------------------------------------------------------------------------     
			-- 4. SCP_ANL_SHIPMENT_PLAN_FG Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
			--  AND SEGMENT1 = 'SCP';

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
				  ,'SCP' SEGMENT1
				  ,BIZ_TYPE    SEGMENT2
				  ,TO_SITE     SEGMENT3
				  ,DIVISION_ID SEGMENT4 -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
				  ,'-'         SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ	
			FROM(
				SELECT DIVISION_ID, BIZ_TYPE, TO_SITE
				FROM(
					SELECT DISTINCT DIVISION_ID, BIZ_TYPE, TO_SITE
					FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
					WHERE DIVISION_ID = @p_division_id			-- 2022.03.23	KSW	GM JV 반영 :: @p_division_id  추가
					  AND BIZ_TYPE   IN ('A','E')
					  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					  AND SEQ = @p_seq
					  AND PLAN_TYPE = @p_plan_type
				) A WHERE NOT EXISTS(SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									 WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
									   AND SEGMENT1 = 'SCP'
									   AND SEGMENT2 = A.BIZ_TYPE
									   AND SEGMENT3 = A.TO_SITE
									   AND SEGMENT4 = A.DIVISION_ID -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
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
			-- 5. SCP_ANL_SHIPMENT_PLAN_SEMI Delete, Insert  
			-------------------------------------------------------------------------------------------------------------   			
			--DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			--WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_SEMI'
			--  AND SEGMENT1 = 'SCP';

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
				  ,'SCP' SEGMENT1
				  ,OPERATION_GROUP SEGMENT2
				  ,TO_SITE         SEGMENT3
				  ,DIVISION_ID     SEGMENT4 -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
				  ,'-'             SEGMENT5
				  ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) DISPLAY_SEQ	
			FROM(
				SELECT DIVISION_ID, OPERATION_GROUP, TO_SITE
				FROM(
					SELECT DISTINCT DIVISION_ID, OPERATION_GROUP, TO_SITE
					FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)
					WHERE DIVISION_ID     = @p_division_id				-- 2022.03.23	KSW	GM JV 반영 :: @p_division_id  추가
					  AND OPERATION_GROUP IN ('A','E')
					  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					  AND SEQ = @p_seq
					  AND PLAN_TYPE = @p_plan_type
				) A WHERE NOT EXISTS(SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									 WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_SEMI'
									   AND SEGMENT1 = 'SCP'
									   AND B.SEGMENT2 = A.OPERATION_GROUP
									   AND B.SEGMENT3 = A.TO_SITE
									   AND B.SEGMENT4 = A.DIVISION_ID -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
									 )
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
        
            -----------------------------------------------------------
            -- 임시테이블 삭제
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#Tbl_ADM_LOOKUP_MASTER_DETAIL') IS NOT NULL
                DROP TABLE #Tbl_ADM_LOOKUP_MASTER_DETAIL
		
			-- 종료 LOG    
			SET @v_log_type = N'END';    
			SET @v_log_message = N'########## END of procedure ##########';    
			SET @v_description = @v_program_name + ':' + N' PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE INSERT LOGIC END';         
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
    
    

