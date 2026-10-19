
/*
 * Program ID   : PR_DM_PLN_CUSTOMER_PSI_BUCKET_CONVERSION
 * Description  : PR_DM_PLN_CUSTOMER_PSI_BUCKET_CONVERSION
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 15    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUSTOMER_PSI_BUCKET_CONVERSION] 
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_CUSTOMER_PSI_BUCKET_CONVERSION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_update_count    INTEGER = 0;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_insert_count    INTEGER = 0;

	-- 변수설정
    DECLARE @v1_DIVISION_ID               nvarchar(MAX);
    DECLARE @v1_SCM_SITE_ID               nvarchar(MAX);
	DECLARE @v1_MEASURE                   nvarchar(MAX);
	DECLARE @v1_PLANT_SITE_ID             nvarchar(MAX);
	DECLARE @v1_MEASURE_GROUP             nvarchar(MAX);
    DECLARE @v1_UPLOAD_UOM                nvarchar(MAX);
    DECLARE @v1_UPLOAD_BUCKET_TYPE        nvarchar(MAX);
    DECLARE @v1_CUSTOMER_PROJECT_CODE     nvarchar(MAX);
    DECLARE @v1_CUSTOMER_MODEL            nvarchar(MAX);  
    DECLARE @v1_MIN_BCV					  nvarchar(MAX);
    DECLARE @v1_MAX_BCV			          nvarchar(MAX);
	DECLARE @v1_PLAN_WEEK				  nvarchar(MAX);

	DECLARE @v2_DIVISION_ID               nvarchar(MAX);
    DECLARE @v2_CUSTOMER_PROJECT_CODE     nvarchar(MAX);
    DECLARE @v2_CUSTOMER_MODEL            nvarchar(MAX);  
    DECLARE @v2_SCM_SITE_ID               nvarchar(MAX);
    DECLARE @v2_DOM_EXP		              nvarchar(MAX);
    DECLARE @v2_FCST_TYPE	              nvarchar(MAX);
	DECLARE @v2_MEASURE_GROUP             nvarchar(MAX);
	DECLARE @v2_MEASURE                   nvarchar(MAX);
	DECLARE @v2_PLANT_SITE_ID             nvarchar(MAX);
    DECLARE @v2_YYYYMMDD				  nvarchar(MAX);
    DECLARE @v2_INCOTERMS		          nvarchar(MAX);
    DECLARE @v2_PROJECT_CODE	          nvarchar(MAX);
    DECLARE @v2_ITEM_ID		              nvarchar(MAX);
    DECLARE @v2_QTY			              nvarchar(MAX);
    DECLARE @v2_UPLOAD_UOM	              nvarchar(MAX);
    DECLARE @v2_CREATED_BY	              nvarchar(MAX);
    DECLARE @v2_CREATION_DATE             nvarchar(MAX);
    DECLARE @v2_LAST_UPDATED_BY           nvarchar(MAX);
    DECLARE @v2_LAST_UPDATE_DATE          nvarchar(MAX);
    DECLARE @v2_ATTRIBUTE1	              nvarchar(MAX);
    DECLARE @v2_ATTRIBUTE2	              nvarchar(MAX);
    DECLARE @v2_ATTRIBUTE3	              nvarchar(MAX);
    DECLARE @v2_ATTRIBUTE4	              nvarchar(MAX);
    DECLARE @v2_ATTRIBUTE5	              nvarchar(MAX);
    DECLARE @v2_ATTRIBUTE6	              nvarchar(MAX);
    DECLARE @v2_DAYOFWEEK	              nvarchar(MAX);
    DECLARE @v2_MON			              nvarchar(MAX);
    DECLARE @v2_TUE			              nvarchar(MAX);
	DECLARE @v2_WED			              nvarchar(MAX);
    DECLARE @v2_THU			              nvarchar(MAX);
    DECLARE @v2_FRI			              nvarchar(MAX);
    DECLARE @v2_SAT					      nvarchar(MAX);
	DECLARE @v2_SUN						  nvarchar(MAX);

	DECLARE @v_DIVISION_ID               nvarchar(MAX)    ;
    DECLARE @v_SCM_SITE_ID               nvarchar(MAX)    ;
	DECLARE @v_MEASURE                   nvarchar(MAX)    ;
	DECLARE @v_PLANT_SITE_ID             nvarchar(MAX)    ;
	DECLARE @v_MEASURE_GROUP             nvarchar(MAX)    ;
    DECLARE @v_UPLOAD_UOM                nvarchar(MAX)    ;
    DECLARE @v_UPLOAD_BUCKET_TYPE        nvarchar(MAX)    ;
    DECLARE @v_CUSTOMER_PROJECT_CODE     nvarchar(MAX)    ;
    DECLARE @v_CUSTOMER_MODEL            nvarchar(MAX)    ; 
    DECLARE @v_DOM_EXP                   nvarchar(MAX)    ;
    DECLARE @v_FCST_TYPE                 nvarchar(MAX)    ;    
    DECLARE @v_YYYYMMDD                  nvarchar(MAX)    ;
    DECLARE @v_INCOTERMS                 nvarchar(MAX)    ;
    DECLARE @v_ITEM_ID                   nvarchar(MAX)    ;
    DECLARE @v_QTY                       numeric(20, 10)  ;
    DECLARE @v_CREATED_BY                nvarchar(MAX)    ;
    DECLARE @v_CREATION_DATE             datetime         ;
    DECLARE @v_LAST_UPDATED_BY           nvarchar(MAX)    ;
    DECLARE @v_LAST_UPDATE_DATE          datetime         ;
    DECLARE @v_ATTRIBUTE1                nvarchar(MAX)    ;
    DECLARE @v_ATTRIBUTE2                nvarchar(MAX)    ;
    DECLARE @v_ATTRIBUTE3                nvarchar(MAX)    ;
    DECLARE @v_ATTRIBUTE4                nvarchar(MAX)    ;
    DECLARE @v_ATTRIBUTE5                nvarchar(MAX)    ;
    DECLARE @v_ATTRIBUTE6                nvarchar(MAX)    ;
    DECLARE @v_ATTRIBUTE7                nvarchar(MAX)    ;
    DECLARE @v_ATTRIBUTE8                nvarchar(MAX)    ;
    DECLARE @v_ATTRIBUTE9                nvarchar(MAX)    ;
    DECLARE @v_ATTRIBUTE10               nvarchar(MAX)    ;

	DECLARE @n_UPLOAD_UOM                nvarchar(MAX)    ;
	DECLARE @n_PROJECT_CODE              nvarchar(MAX)    ;
	DECLARE @n_ITEM_ID                   nvarchar(MAX)    ;
	DECLARE @n_CONVERT_QTY_PACK          numeric(20, 10)  ;
	DECLARE @n_CONVERT_QTY_MODULE        numeric(20, 10)  ;
	DECLARE @n_CONVERT_QTY_CELL          numeric(20, 10)  ;
	DECLARE @n_CONVERT_QTY               numeric(20, 10)  ;

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION;
	
	BEGIN TRY
	BEGIN    
		 -- Cursor 로 처리
		  DECLARE CUR_SBC_PERIOD CURSOR FOR

			SELECT	 MST.[PLAN_WEEK]
					,MIN([SUMMARY_BUCKET_VALUE]) AS [MIN_BCV]
					,MAX([SUMMARY_BUCKET_VALUE]) AS [MAX_BCV]
					,MST.[DIVISION_ID]
					,MST.[SCM_SITE_ID]
					,MST.[MEASURE]
					,MST.[UPLOAD_UOM]
					,UPPER(RTRIM(LTRIM([UPLOAD_BUCKET_TYPE]))) AS [UPLOAD_BUCKET_TYPE]
			FROM 
				[dbo].[DM_MST_CUSTOMER_FCST] MST WITH(NOLOCK),
				(
					SELECT	 MAX([PLAN_WEEK]) AS [PLAN_WEEK]
							--,MIN([SUMMARY_BUCKET_VALUE]) AS [MIN_BCV]
							--,MAX([SUMMARY_BUCKET_VALUE]) AS [MAX_BCV]
							,[DIVISION_ID]
							,[SCM_SITE_ID]
					FROM [dbo].[DM_MST_CUSTOMER_FCST]  WITH(NOLOCK)
					WHERE 
						[UPLOAD_BUCKET_TYPE] IS NOT NULL AND [UPLOAD_BUCKET_TYPE] != '' AND
						[PLAN_WEEK] IS NOT NULL AND [PLAN_WEEK] != '' AND
						[MEASURE_GROUP] = 'CUST_FCST'	
					GROUP BY
							 [DIVISION_ID]
							,[SCM_SITE_ID]
				) DTL
			WHERE 
				MST.PLAN_WEEK = DTL.PLAN_WEEK AND
				MST.DIVISION_ID = DTL.DIVISION_ID AND
				MST.SCM_SITE_ID = DTL.SCM_SITE_ID AND
				MST.[UPLOAD_BUCKET_TYPE] IS NOT NULL AND MST.[UPLOAD_BUCKET_TYPE] != '' AND
				MST.[PLAN_WEEK] IS NOT NULL AND MST.[PLAN_WEEK] != '' AND
				MST.[MEASURE_GROUP] = 'CUST_FCST'	
			GROUP BY
					 MST.[PLAN_WEEK]
					,MST.[DIVISION_ID]
					,MST.[SCM_SITE_ID]
					,MST.[MEASURE]
					,MST.[UPLOAD_UOM]
					,MST.[UPLOAD_BUCKET_TYPE]
			ORDER BY  MST.[PLAN_WEEK], [MIN_BCV], [MAX_BCV], MST.[DIVISION_ID],MST.[SCM_SITE_ID]
			;

		 IF OBJECT_ID('dbo.TEMP_DM_MST_CUSTOMER_FCST$') IS NOT NULL DROP TABLE [dbo].TEMP_DM_MST_CUSTOMER_FCST$

			SELECT	 MST.[PLAN_WEEK]
					,MIN([SUMMARY_BUCKET_VALUE]) AS [MIN_BCV]
					,MAX([SUMMARY_BUCKET_VALUE]) AS [MAX_BCV]
					,MST.[DIVISION_ID]
					,MST.[SCM_SITE_ID]
					,MST.[MEASURE]
					,MST.[UPLOAD_UOM]
					,UPPER(RTRIM(LTRIM([UPLOAD_BUCKET_TYPE]))) AS [UPLOAD_BUCKET_TYPE]
			INTO [dbo].TEMP_DM_MST_CUSTOMER_FCST$
			FROM 
				[dbo].[DM_MST_CUSTOMER_FCST] MST WITH(NOLOCK),
				(
					SELECT	 MAX([PLAN_WEEK]) AS [PLAN_WEEK]
							--,MIN([SUMMARY_BUCKET_VALUE]) AS [MIN_BCV]
							--,MAX([SUMMARY_BUCKET_VALUE]) AS [MAX_BCV]
							,[DIVISION_ID]
							,[SCM_SITE_ID]
					FROM [dbo].[DM_MST_CUSTOMER_FCST]  WITH(NOLOCK)
					WHERE 
						[UPLOAD_BUCKET_TYPE] IS NOT NULL AND [UPLOAD_BUCKET_TYPE] != '' AND
						[PLAN_WEEK] IS NOT NULL AND [PLAN_WEEK] != '' AND
						[MEASURE_GROUP] = 'CUST_FCST'	
					GROUP BY
							 [DIVISION_ID]
							,[SCM_SITE_ID]
				) DTL
			WHERE 
				MST.PLAN_WEEK = DTL.PLAN_WEEK AND
				MST.DIVISION_ID = DTL.DIVISION_ID AND
				MST.SCM_SITE_ID = DTL.SCM_SITE_ID AND
				MST.[UPLOAD_BUCKET_TYPE] IS NOT NULL AND MST.[UPLOAD_BUCKET_TYPE] != '' AND
				MST.[PLAN_WEEK] IS NOT NULL AND MST.[PLAN_WEEK] != '' AND
				MST.[MEASURE_GROUP] = 'CUST_FCST'	
			GROUP BY
					 MST.[PLAN_WEEK]
					,MST.[DIVISION_ID]
					,MST.[SCM_SITE_ID]
					,MST.[MEASURE]
					,MST.[UPLOAD_UOM]
					,MST.[UPLOAD_BUCKET_TYPE]
			ORDER BY  MST.[PLAN_WEEK], [MIN_BCV], [MAX_BCV], MST.[DIVISION_ID],MST.[SCM_SITE_ID]
			;

		 OPEN CUR_SBC_PERIOD;

		 FETCH NEXT FROM CUR_SBC_PERIOD 
			INTO	@v1_PLAN_WEEK
				,	@v1_MIN_BCV	 
				,	@v1_MAX_BCV	  
				,	@v1_DIVISION_ID    
				,	@v1_SCM_SITE_ID    
				,	@v1_MEASURE	 
				,	@v1_UPLOAD_UOM		
				,	@v1_UPLOAD_BUCKET_TYPE		
			;

         WHILE @@FETCH_STATUS = 0   -- 0:실행, -1:실패, -2:행없음
		 BEGIN

	 			SELECT	@v1_PLAN_WEEK				AS v1_PLAN_WEEK
					,	@v1_DIVISION_ID				AS v1_DIVISION_ID
					,	@v1_SCM_SITE_ID				AS v1_SCM_SITE_ID  
					,	@v1_MEASURE					AS v1_MEASURE    
					,	@v1_UPLOAD_UOM				AS v1_UPLOAD_UOM    
					,	@v1_UPLOAD_BUCKET_TYPE		AS v1_UPLOAD_BUCKET_TYPE 
					,	@v1_MIN_BCV					AS v1_MIN_BCV		
					,	@v1_MAX_BCV					AS v1_MAX_BCV

		IF EXISTS 
		( 
			SELECT 1 FROM [dbo].[DM_PLN_CUSTOMER_PSI]  WITH (NOLOCK) 
			WHERE 
				DIVISION_ID = @v1_DIVISION_ID AND 
				SCM_SITE_ID = @v1_SCM_SITE_ID AND
				MEASURE = @v1_MEASURE AND
				PLANT_SITE_ID = @v1_PLANT_SITE_ID AND
				UPLOAD_UOM = @v1_UPLOAD_UOM AND
				ATTRIBUTE1 = 'ING' AND 
				ATTRIBUTE3 = 'WEEKLY' AND
				ATTRIBUTE6 = @v1_PLAN_WEEK AND 
				QTY > 0 AND
				YYYYMMDD >= @v1_MIN_BCV AND
				YYYYMMDD <= @v1_MAX_BCV 
		 ) 
           BEGIN		-- WEEKLY

				DECLARE c_bucket_type CURSOR FAST_FORWARD FOR   
	
				SELECT		  A.DIVISION_ID
							, B.CUSTOMER_PROJECT_CODE
							, B.CUSTOMER_MODEL
      						, B.SCM_SITE_ID
							, B.DOM_EXP
							, B.FCST_TYPE
							, B.MEASURE_GROUP
							, B.MEASURE
							, B.PLANT_SITE_ID
							, B.YYYYMMDD
							, B.INCOTERMS
							, B.PROJECT_CODE
							, B.ITEM_ID
							, B.QTY
							, B.UPLOAD_UOM
							, B.CREATED_BY
							, B.CREATION_DATE
							, B.LAST_UPDATED_BY
							, B.LAST_UPDATE_DATE
							, B.ATTRIBUTE1
							, B.ATTRIBUTE2
							, B.ATTRIBUTE3
							, B.ATTRIBUTE4
							, B.ATTRIBUTE5
							, B.ATTRIBUTE6
							, C.DAYOFWEEK
							, SUM(DISTINCT CASE WHEN A.YYYYMMDD = 'MON' THEN CONVERT(INT,CONVERT(CHAR(8), C.BASIS_YYYYMMDD, 112)) ELSE '' END) AS MON 
							, SUM(DISTINCT CASE WHEN A.YYYYMMDD = 'TUE' THEN CONVERT(INT,CONVERT(CHAR(8), DATEADD(DAY, 1, C.BASIS_YYYYMMDD), 112)) ELSE '' END) AS TUE
							, SUM(DISTINCT CASE WHEN A.YYYYMMDD = 'WED' THEN CONVERT(INT,CONVERT(CHAR(8), DATEADD(DAY, 2, C.BASIS_YYYYMMDD), 112)) ELSE '' END) AS WED
							, SUM(DISTINCT CASE WHEN A.YYYYMMDD = 'THU' THEN CONVERT(INT,CONVERT(CHAR(8), DATEADD(DAY, 3, C.BASIS_YYYYMMDD), 112)) ELSE '' END) AS THU	
							, SUM(DISTINCT CASE WHEN A.YYYYMMDD = 'FRI' THEN CONVERT(INT,CONVERT(CHAR(8), DATEADD(DAY, 4, C.BASIS_YYYYMMDD), 112)) ELSE '' END) AS FRI
							, SUM(DISTINCT CASE WHEN A.YYYYMMDD = 'SAT' THEN CONVERT(INT,CONVERT(CHAR(8), DATEADD(DAY, 5, C.BASIS_YYYYMMDD), 112)) ELSE '' END) AS SAT
							, SUM(DISTINCT CASE WHEN A.YYYYMMDD = 'SUN' THEN CONVERT(INT,CONVERT(CHAR(8), DATEADD(DAY, 6, C.BASIS_YYYYMMDD), 112)) ELSE '' END) AS SUN
					FROM   [dbo].[DM_MST_BUCKET_CONVERSION] A WITH(NOLOCK)
						 , [dbo].[DM_PLN_CUSTOMER_PSI]      B WITH(NOLOCK)
						 , [dbo].[SCM_SYS_CALENDAR_M]		C WITH(NOLOCK)
					WHERE	A.SCM_SITE_ID = B.SCM_SITE_ID
					AND		A.DIVISION_ID = B.DIVISION_ID
					AND		A.INCOTERMS = B.INCOTERMS
					AND		A.CONVERSION_TYPE = 'WTOD'
					AND		A.DIVISION_ID = @v1_DIVISION_ID	
					AND		A.SCM_SITE_ID = @v1_SCM_SITE_ID
					--AND		A.INCOTERMS = 'DDP'			--@v2_INCOTERMS
					AND		B.YYYYMMDD = C.BASIS_YYYYMMDD
					AND		B.MEASURE_GROUP = 'CUST_FCST'
					AND		B.MEASURE = @v1_MEASURE
					AND		B.UPLOAD_UOM = @v1_UPLOAD_UOM
					AND		B.ATTRIBUTE1 = 'ING'  
					AND		B.ATTRIBUTE3 = 'WEEKLY'
					AND		B.ATTRIBUTE6 = @v1_PLAN_WEEK  
					AND		B.QTY > 0 
					AND		B.YYYYMMDD >= @v1_MIN_BCV 
					AND		B.YYYYMMDD <= @v1_MAX_BCV 
					AND		C.DAYOFWEEK = 'MON'
					GROUP BY  A.DIVISION_ID
							, B.CUSTOMER_PROJECT_CODE
							, B.CUSTOMER_MODEL
      						, B.SCM_SITE_ID
							, B.DOM_EXP
							, B.FCST_TYPE
							, B.MEASURE_GROUP
							, B.MEASURE
							, B.PLANT_SITE_ID
							, B.YYYYMMDD
							, B.INCOTERMS
							, B.PROJECT_CODE
							, B.ITEM_ID
							, B.QTY
							, B.UPLOAD_UOM
							, B.CREATED_BY
							, B.CREATION_DATE
							, B.LAST_UPDATED_BY
							, B.LAST_UPDATE_DATE
							, B.ATTRIBUTE1
							, B.ATTRIBUTE2
							, B.ATTRIBUTE3
							, B.ATTRIBUTE4
							, B.ATTRIBUTE5
							, B.ATTRIBUTE6
							, C.DAYOFWEEK
							--, C.DAYOFWEEK_NO
					;

				OPEN c_bucket_type;
				FETCH NEXT FROM c_bucket_type INTO 
					@v2_DIVISION_ID     ,
					@v2_CUSTOMER_PROJECT_CODE ,
					@v2_CUSTOMER_MODEL  ,  
					@v2_SCM_SITE_ID     ,
					@v2_DOM_EXP		    ,
					@v2_FCST_TYPE	    ,
					@v2_MEASURE_GROUP   ,
					@v2_MEASURE         ,
					@v2_YYYYMMDD		,
					@v2_INCOTERMS		,
					@v2_PROJECT_CODE	,
					@v2_ITEM_ID		    ,
					@v2_QTY			    ,
					@v2_UPLOAD_UOM	    ,
					@v2_CREATED_BY	    ,
					@v2_CREATION_DATE   ,
					@v2_LAST_UPDATED_BY ,
					@v2_LAST_UPDATE_DATE,
					@v2_ATTRIBUTE1	    ,
					@v2_ATTRIBUTE2	    ,
					@v2_ATTRIBUTE3	    ,
					@v2_ATTRIBUTE4	    ,
					@v2_ATTRIBUTE5	    ,
					@v2_ATTRIBUTE6	    ,
					@v2_DAYOFWEEK	    ,
					@v2_MON			    ,
					@v2_TUE			    ,
					@v2_WED			    ,
					@v2_THU			    ,
					@v2_FRI			    ,
					@v2_SAT				,
					@v2_SUN					
					;
        
				WHILE @@FETCH_STATUS = 0   

					BEGIN

						SELECT 	  @v2_DIVISION_ID              AS v2_DIVISION_ID
								, @v2_CUSTOMER_PROJECT_CODE    AS v2_CUSTOMER_PROJECT_CODE 
								, @v2_CUSTOMER_MODEL           AS v2_CUSTOMER_MODEL    
								, @v2_SCM_SITE_ID              AS v2_SCM_SITE_ID     
								, @v2_DOM_EXP		           AS v2_DOM_EXP		    
								, @v2_FCST_TYPE	               AS v2_FCST_TYPE	    
								, @v2_MEASURE_GROUP            AS v2_MEASURE_GROUP   
								, @v2_MEASURE                  AS v2_MEASURE         
								, @v2_YYYYMMDD			       AS v2_YYYYMMDD			
								, @v2_INCOTERMS		           AS v2_INCOTERMS		
								, @v2_PROJECT_CODE	           AS v2_PROJECT_CODE	
								, @v2_ITEM_ID		           AS v2_ITEM_ID		    
								, @v2_QTY			           AS v2_QTY			    
								, @v2_UPLOAD_UOM	           AS v2_UPLOAD_UOM	    
								, @v2_CREATED_BY	           AS v2_CREATED_BY	    
								, @v2_CREATION_DATE            AS v2_CREATION_DATE   
								, @v2_LAST_UPDATED_BY          AS v2_LAST_UPDATED_BY 
								, @v2_LAST_UPDATE_DATE         AS v2_LAST_UPDATE_DATE
								, @v2_ATTRIBUTE1	           AS v2_ATTRIBUTE1	    
								, @v2_ATTRIBUTE2	           AS v2_ATTRIBUTE2	    
								, @v2_ATTRIBUTE3	           AS v2_ATTRIBUTE3	    
								, @v2_ATTRIBUTE4	           AS v2_ATTRIBUTE4	    
								, @v2_ATTRIBUTE5	           AS v2_ATTRIBUTE5	    
								, @v2_ATTRIBUTE6	           AS v2_ATTRIBUTE6	    
								, @v2_DAYOFWEEK	               AS v2_DAYOFWEEK	    
								, @v2_MON			           AS v2_MON			    
								, @v2_TUE			           AS v2_TUE			    
								, @v2_WED			           AS v2_WED			    
								, @v2_THU			           AS v2_THU			    
								, @v2_FRI			           AS v2_FRI			    
								, @v2_SAT					   AS v2_SAT					
								, @v2_SUN					   AS v2_SUN		
						;				

					IF EXISTS 
					( 
						SELECT 1 FROM [dbo].[DM_PLN_CUSTOMER_PSI]  WITH (NOLOCK) 
						WHERE 
							DIVISION_ID = @v1_DIVISION_ID AND 
							SCM_SITE_ID = @v1_SCM_SITE_ID AND
							MEASURE = @v1_MEASURE AND
							PLANT_SITE_ID = @v1_PLANT_SITE_ID AND
							UPLOAD_UOM = @v1_UPLOAD_UOM AND
							ATTRIBUTE1 = 'ING' AND 
							ATTRIBUTE3 = 'WEEKLY' AND
							ATTRIBUTE6 = @v1_PLAN_WEEK AND 
							QTY > 0 AND
							YYYYMMDD >= @v1_MIN_BCV AND
							YYYYMMDD <= @v1_MAX_BCV 
					 ) 
					   BEGIN		-- WEEKLY

						SELECT 	  @v2_DIVISION_ID              AS v2_DIVISION_ID

					   END;
    
						FETCH NEXT FROM c_bucket_type INTO 
							@v2_DIVISION_ID     ,
							@v2_CUSTOMER_PROJECT_CODE ,
							@v2_CUSTOMER_MODEL  ,  
							@v2_SCM_SITE_ID     ,
							@v2_DOM_EXP		    ,
							@v2_FCST_TYPE	    ,
							@v2_MEASURE_GROUP   ,
							@v2_MEASURE         ,
							@v2_YYYYMMDD		,
							@v2_INCOTERMS		,
							@v2_PROJECT_CODE	,
							@v2_ITEM_ID		    ,
							@v2_QTY			    ,
							@v2_UPLOAD_UOM	    ,
							@v2_CREATED_BY	    ,
							@v2_CREATION_DATE   ,
							@v2_LAST_UPDATED_BY ,
							@v2_LAST_UPDATE_DATE,
							@v2_ATTRIBUTE1	    ,
							@v2_ATTRIBUTE2	    ,
							@v2_ATTRIBUTE3	    ,
							@v2_ATTRIBUTE4	    ,
							@v2_ATTRIBUTE5	    ,
							@v2_ATTRIBUTE6	    ,
							@v2_DAYOFWEEK	    ,
							@v2_MON			    ,
							@v2_TUE			    ,
							@v2_WED			    ,
							@v2_THU			    ,
							@v2_FRI			    ,
							@v2_SAT				,
							@v2_SUN					
						;

					END;
				CLOSE c_bucket_type;  
				DEALLOCATE c_bucket_type;

		   END;

		 FETCH NEXT FROM CUR_SBC_PERIOD 
			INTO	@v1_PLAN_WEEK
				,	@v1_MIN_BCV	 
				,	@v1_MAX_BCV	  
				,	@v1_DIVISION_ID    
				,	@v1_SCM_SITE_ID    
				,	@v1_MEASURE	 
				,	@v1_UPLOAD_UOM		
				,	@v1_UPLOAD_BUCKET_TYPE		
			;

		END
		-- (1)
		CLOSE CUR_SBC_PERIOD;
		DEALLOCATE CUR_SBC_PERIOD; 			

		DROP TABLE [dbo].TEMP_DM_MST_CUSTOMER_FCST$;
		END
		-- (0)
    --    IF @@TRANCOUNT > 0
          COMMIT WORK;
		  --END
		
		END TRY

	--------------------------------------------------------------------------------------------	
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

	  --IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR')
		BEGIN
			CLOSE CUR_SBC_PERIOD
			DEALLOCATE CUR_SBC_PERIOD
		END


	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    --SET @v_description = 'update_count= ' + Convert(NVARCHAR(10), @n_update_count) +  ' / delete_count= ' + Convert(NVARCHAR(10), @N_delete_count)
	--                      +  ' / insert_count= ' + Convert(NVARCHAR(10), @N_insert_count) --+ '
	;
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
