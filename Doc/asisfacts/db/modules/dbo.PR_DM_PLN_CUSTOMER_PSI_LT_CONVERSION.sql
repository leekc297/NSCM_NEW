
/*
 * Program ID   : PR_DM_PLN_CUSTOMER_PSI_LT_CONVERSION
 * Description  : PR_DM_PLN_CUSTOMER_PSI_LT_CONVERSION
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 01. 23    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUSTOMER_PSI_LT_CONVERSION] 
	-- Add the parameters for the stored procedure here
	--@p_active_flag            NVARCHAR(MAX),    -- 필요없음
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_CUSTOMER_PSI_LT_CONVERSION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_update_count    INTEGER = 0;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_insert_count    INTEGER = 0;

    --DECLARE @v_uom_flag     NVARCHAR(30);

	-- 변수설정
    DECLARE @v1_DIVISION_ID		          nvarchar(MAX);
    DECLARE @v1_BOD_TYPE	              nvarchar(MAX);
	DECLARE @v1_FROM_SITE                 nvarchar(MAX);
	DECLARE @v1_TO_SITE		              nvarchar(MAX);
    DECLARE @v1_CUSTOMER_LT               INTEGER = 0;

	DECLARE @v2_DIVISION_ID               nvarchar(MAX);
    DECLARE @v2_CUSTOMER_PROJECT_CODE     nvarchar(MAX);
    DECLARE @v2_CUSTOMER_MODEL            nvarchar(MAX);  
    DECLARE @v2_SCM_SITE_ID               nvarchar(MAX);
    DECLARE @v2_DOM_EXP		              nvarchar(MAX);
    DECLARE @v2_FCST_TYPE	              nvarchar(MAX);
	DECLARE @v2_MEASURE_GROUP             nvarchar(MAX);
	DECLARE @v2_MEASURE                   nvarchar(MAX);
    DECLARE @v2_YYYYMMDD				  nvarchar(MAX);
    DECLARE @v2_INCOTERMS		          nvarchar(MAX);
    DECLARE @v2_PLANT_SITE_ID	          nvarchar(MAX);
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
	--DECLARE @n_UPLOAD_BUCKET_TYPE        nvarchar(MAX)    ;
	


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


	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

		-- (0)
		BEGIN    

		--IF OBJECT_ID('CUR_CAR_RESULT') IS NOT NULL 
		--CLOSE CUR_CAR_RESULT
		--DEALLOCATE CUR_CAR_RESULT; 		

		
		 -- Cursor 로 처리
		  DECLARE CUR_CUSTOMER_LT CURSOR FOR

			SELECT	 
					[DIVISION_ID]
					--,[BOD_ID]
					,[BOD_TYPE]
					,[FROM_SITE]
					,[TO_SITE]
					--,[INCOTERMS]
					--,[TRANSPORT_MODE]
					--,[PRIORITY]
					,MAX(lt_total) AS lt_total
			FROM
					[dbo].SCP_MST_BOD_V WITH(NOLOCK)	
			WHERE 
					bod_valid_yn  = 'Y' AND 
					lt_total IS NOT NULL AND
					lt_total <> 0 
					--TO_SITE = 'Audi_DE_Neckarsulm'	AND 
					--FROM_SITE = 'A041-E' --	'자동차 전지 전극 플랜트-Electrode', 'A041-E','Audi_DE_Neckarsulm','DAP' 
			GROUP BY
					 [DIVISION_ID]
					--,[BOD_ID]
					,[BOD_TYPE]
					,[FROM_SITE]
					,[TO_SITE]
			ORDER BY [DIVISION_ID], [BOD_TYPE], [TO_SITE]
			;



--MIN_BCV	MAX_BCV		DIVISION_ID	SCM_SITE_ID	MEASURE			UPLOAD_UOM	UPLOAD_BUCKET_TYPE
----------------------------------------------------------------------------------------------------
--20180122	20180129	81			Volvo_SE_	Customer Order	PACK		DAILY
--20180205	20180305	81			Volvo_SE_	Customer FCST	CAR			WEEKLY
--20180312	20180514	81			Volvo_SE_	Car Production	CAR			MONTHLY
		
	 IF OBJECT_ID('dbo.TEMP_BOD_CUSTOMER_LT$') IS NOT NULL DROP TABLE [dbo].TEMP_BOD_CUSTOMER_LT$
	--select '2';	

			SELECT	 
					[DIVISION_ID]
					--,[BOD_ID]
					,[BOD_TYPE]
					,[FROM_SITE]
					,[TO_SITE]
					--,[INCOTERMS]
					--,[TRANSPORT_MODE]
					--,[PRIORITY]
					,MAX(lt_total) AS lt_total
			INTO [dbo].TEMP_BOD_CUSTOMER_LT$
			FROM
					[dbo].SCP_MST_BOD_V WITH(NOLOCK)	
			WHERE 
					bod_valid_yn  = 'Y' AND 
					lt_total IS NOT NULL AND
					lt_total <> 0 
					--TO_SITE = 'Audi_DE_Neckarsulm'	AND 
					--FROM_SITE = 'A041-E' --	'자동차 전지 전극 플랜트-Electrode', 'A041-E','Audi_DE_Neckarsulm','DAP' 
			GROUP BY
					 [DIVISION_ID]
					--,[BOD_ID]
					,[BOD_TYPE]
					,[FROM_SITE]
					,[TO_SITE]
			ORDER BY [DIVISION_ID], [BOD_TYPE], [TO_SITE]
			;

		
		 OPEN CUR_CUSTOMER_LT;

		 FETCH NEXT FROM CUR_CUSTOMER_LT 
			INTO	@v1_DIVISION_ID
				,	@v1_BOD_TYPE	 
				,	@v1_FROM_SITE	  
				,	@v1_TO_SITE    
				,	@v1_CUSTOMER_LT    
		;
							

--	select '4';		


         WHILE @@FETCH_STATUS = 0   -- 0:실행, -1:실패, -2:행없음
			--select @@FETCH_STATUS;
--select '5';		

		 BEGIN

	 			SELECT	@v1_DIVISION_ID				AS v1_DIVISION_ID
					,	@v1_BOD_TYPE				AS v1_BOD_TYPE    
					,	@v1_FROM_SITE				AS v1_FROM_SITE    
					,	@v1_TO_SITE					AS v1_TO_SITE 
					,	@v1_CUSTOMER_LT				AS v1_CUSTOMER_LT	

		


--v1_PLAN_WEEK	v1_DIVISION_ID	v1_SCM_SITE_ID	v1_MEASURE		v1_UPLOAD_UOM	v1_UPLOAD_BUCKET_TYPE	v1_MIN_BCV	v1_MAX_BCV
-------------------------------------------------------------------------------------------------------------------------------
--201804		81				Volvo_SE_		Customer Order	PACK			DAILY					20180129	20180205
--201804		81				Volvo_SE_		Customer FCST	CAR				WEEKLY					20180212	20180312
--201804		81				Volvo_SE_		Car Production	CAR				MONTHLY					20180319	20180521				;

		 --(3)
		 


--SELECT 
--	* 
--FROM 
--	[dbo].[DM_PLN_CUSTOMER_PSI] 
--WHERE 
--	DIVISION_ID = '81'  AND 
--	SCM_SITE_ID = 'Volvo_SE_' AND
--	MEASURE = 'Customer FCST' AND
--	UPLOAD_UOM = 'CAR' AND
--	ATTRIBUTE1 = 'ING' AND 
--	ATTRIBUTE3 = 'WEEKLY' AND
--	ATTRIBUTE6 = '201804' AND 
--	QTY > 0 AND
--	YYYYMMDD >= '20180212' AND
--	YYYYMMDD <= '20180312' 
--ORDER by YYYYMMDD, UPLOAD_UOM, [MEASURE_GROUP]
--;


--DIVISION_ID	CUSTOMER_PROJECT_CODE	CUSTOMER_MODEL	SCM_SITE_ID	DOM_EXP	FCST_TYPE	MEASURE_GROUP	MEASURE	YYYYMMDD	INCOTERMS	PROJECT_CODE	ITEM_ID	QTY	UPLOAD_UOM	CREATED_BY	CREATION_DATE	LAST_UPDATED_BY	LAST_UPDATE_DATE	ATTRIBUTE1	ATTRIBUTE2	ATTRIBUTE3	ATTRIBUTE4	ATTRIBUTE5	ATTRIBUTE6	ATTRIBUTE7	ATTRIBUTE8	ATTRIBUTE9	ATTRIBUTE10
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--81	Volvo X	X-Car	Volvo_SE_	EXP	AS	FCST	Customer FCST	20180212	DDP	A16VO7002	APVCC517H-A2	102.0000000000	CAR	20140001	2018-01-22 14:37:33.000	20140001	2018-01-22 19:10:48.787	ING	PACK	WEEKLY	WEEKLY	408.0000000000	201804	NULL	NULL	NULL	NULL
--81	Volvo X	X-Car	Volvo_SE_	EXP	AS	FCST	Customer FCST	20180219	DDP	A16VO7002	APVCC517H-A2	103.0000000000	CAR	20140001	2018-01-22 14:37:33.000	20140001	2018-01-22 19:10:48.787	ING	PACK	WEEKLY	WEEKLY	412.0000000000	201804	NULL	NULL	NULL	NULL
--81	Volvo X	X-Car	Volvo_SE_	EXP	AS	FCST	Customer FCST	20180226	DDP	A16VO7002	APVCC517H-A2	104.0000000000	CAR	20140001	2018-01-22 14:37:33.000	20140001	2018-01-22 19:10:48.790	ING	PACK	WEEKLY	WEEKLY	416.0000000000	201804	NULL	NULL	NULL	NULL
--81	Volvo X	X-Car	Volvo_SE_	EXP	AS	FCST	Customer FCST	20180305	DDP	A16VO7002	APVCC517H-A2	105.0000000000	CAR	20140001	2018-01-22 14:37:33.000	20140001	2018-01-22 19:10:48.790	ING	PACK	WEEKLY	WEEKLY	420.0000000000	201804	NULL	NULL	NULL	NULL
--81	Volvo X	X-Car	Volvo_SE_	EXP	AS	FCST	Customer FCST	20180312	DDP	A16VO7002	APVCC517H-A2	106.0000000000	CAR	20140001	2018-01-22 14:37:33.000	20140001	2018-01-22 19:10:48.790	ING	PACK	WEEKLY	WEEKLY	424.0000000000	201804	NULL	NULL	NULL	NULL




           BEGIN		-- WEEKLY

				DECLARE c_psi_loop CURSOR FAST_FORWARD FOR   
				 
				SELECT 
						 [DIVISION_ID]
						,[CUSTOMER_PROJECT_CODE]
						,[CUSTOMER_MODEL]
						,[SCM_SITE_ID]
						,[DOM_EXP]
						,[FCST_TYPE]
						,[MEASURE_GROUP]
						,[MEASURE]
						,[YYYYMMDD]
						,[INCOTERMS]
						,[PLANT_SITE_ID]
						,[LAST_UPDATED_BY]
				FROM	[dbo].[DM_PLN_CUSTOMER_PSI] WITH(NOLOCK) 
				WHERE 
					[DIVISION_ID]	= @v1_DIVISION_ID AND			-- DIVISION_ID
					[PLANT_SITE_ID] = @v1_FROM_SITE AND				-- FROM_SITE
					[SCM_SITE_ID]	= @v1_TO_SITE					-- TO_SITE
				;

				OPEN c_psi_loop;
				FETCH NEXT FROM c_psi_loop INTO 
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
					@v2_PLANT_SITE_ID	,
					@v2_LAST_UPDATED_BY
				;
			
				WHILE @@FETCH_STATUS = 0   

					BEGIN

				SELECT	@v2_DIVISION_ID				AS v2_DIVISION_ID
					,	@v2_CUSTOMER_PROJECT_CODE	AS v2_CUSTOMER_PROJECT_CODE    
					,	@v2_CUSTOMER_MODEL			AS v2_CUSTOMER_MODEL    
					,	@v2_SCM_SITE_ID				AS v2_SCM_SITE_ID 
					--,	@v2_DOM_EXP					AS v2_DOM_EXP	
					--,	@v2_FCST_TYPE				AS v2_FCST_TYPE    
					--,	@v2_MEASURE_GROUP			AS v2_MEASURE_GROUP    
					--,	@v2_MEASURE					AS v2_MEASURE 
					,	@v2_YYYYMMDD				AS v2_YYYYMMDD	
					,	@v2_INCOTERMS				AS v2_INCOTERMS    
					,	@v2_PLANT_SITE_ID			AS v2_PLANT_SITE_ID    
					,	@v2_LAST_UPDATED_BY			AS v2_LAST_UPDATED_BY	 
				
--DECLARE @n_fcst_advance_count    INTEGER = 1;
--select dateadd(day,@n_fcst_advance_count,getdate());
--select dateadd(day,-@n_fcst_advance_count,getdate());

			IF NOT EXISTS 
			( 
				SELECT 1 FROM [dbo].[DM_PLN_CUSTOMER_PSI]  WITH (NOLOCK) 
				WHERE 		DIVISION_ID				= @v2_DIVISION_ID
						AND CUSTOMER_PROJECT_CODE	= @v2_CUSTOMER_PROJECT_CODE
						AND CUSTOMER_MODEL			= @v2_CUSTOMER_MODEL
						AND SCM_SITE_ID				= @v2_SCM_SITE_ID
						AND DOM_EXP					= @v2_DOM_EXP
						AND FCST_TYPE				= @v2_FCST_TYPE
						AND MEASURE_GROUP			= @v2_MEASURE_GROUP
						AND MEASURE					= @v2_MEASURE
						AND YYYYMMDD				= @v2_YYYYMMDD
						AND INCOTERMS				= @v2_INCOTERMS
						AND PLANT_SITE_ID			= @v2_PLANT_SITE_ID
						AND ATTRIBUTE9				= 'LT_COMPLETED'
			) 

			 BEGIN

				UPDATE [dbo].[DM_PLN_CUSTOMER_PSI]
				SET
							 YYYYMMDD					=   CONVERT(CHAR(8), dateadd(day,-@v1_CUSTOMER_LT,@v2_YYYYMMDD), 112)    
							,ATTRIBUTE9					=	'LT_COMPLETED'         
							--,CREATED_BY               =   @v_CREATED_BY           
							--,CREATION_DATE            =   @v_CREATION_DATE        
							,LAST_UPDATED_BY			=   @v2_LAST_UPDATED_BY      
							,LAST_UPDATE_DATE			=   sysdatetime()     
				 WHERE
								DIVISION_ID            = @v2_DIVISION_ID
							AND CUSTOMER_PROJECT_CODE  = @v2_CUSTOMER_PROJECT_CODE
							AND CUSTOMER_MODEL		   = @v2_CUSTOMER_MODEL
							AND SCM_SITE_ID            = @v2_SCM_SITE_ID
							AND DOM_EXP                = @v2_DOM_EXP
							AND FCST_TYPE              = @v2_FCST_TYPE
							AND MEASURE_GROUP          = @v2_MEASURE_GROUP
							AND MEASURE                = @v2_MEASURE
							AND YYYYMMDD               = @v2_YYYYMMDD
							AND INCOTERMS              = @v2_INCOTERMS
							AND PLANT_SITE_ID		   = @v2_PLANT_SITE_ID
							;

				 SELECT @v2_YYYYMMDD	AS v2_YYYYMMDD;
				 --SELECT dateadd(day,-@v1_CUSTOMER_LT,@v2_YYYYMMDD);		
				 SELECT CONVERT(CHAR(8), dateadd(day,-@v1_CUSTOMER_LT,@v2_YYYYMMDD), 112) AS CONVERT_v2_YYYYMMDD;		

			 END;

		 
	
						FETCH NEXT FROM c_psi_loop INTO 
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
							@v2_PLANT_SITE_ID	,
							@v2_LAST_UPDATED_BY
						;
					END;
				CLOSE c_psi_loop;  
				DEALLOCATE c_psi_loop;

		   END;




--20180122	20180129	81			Volvo_SE_	Customer Order	PACK		DAILY
--20180205	20180305	81			Volvo_SE_	Customer FCST	CAR			WEEKLY
--20180312	20180514	81			Volvo_SE_	Car Production	CAR			MONTHLY
		 /*---- 판매단위 UPLOAD_UOM 추출하여 저장 ----*/


		 --(3)
		 --SET @n_UPLOAD_UOM = 
		 --                  (
			--			   SELECT UPLOAD_UOM FROM [dbo].DM_MST_CUSTOMER_FCST WITH(NOLOCK)   
			--			     WHERE 1=1
			--				   AND DIVISION_ID = @v_DIVISION_ID
			--				   AND SCM_SITE_ID = @v_SCM_SITE_ID
			--				   AND MEASURE = @v_MEASURE
			--				 GROUP BY UPLOAD_UOM,DIVISION_ID,SCM_SITE_ID,MEASURE -- 중복 제거용 group by
			--				)

		 --/*---- PROJECT_CODE 정보 추출하여 저장 ----*/
		 --SET @n_PROJECT_CODE = 
		 --                  (
			--			   SELECT PROJECT_CODE FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)
			--			     WHERE 1=1
			--				   AND DIVISION_ID = @v_DIVISION_ID
			--				   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
			--				   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
			--				   AND SCM_SITE_ID = @v_SCM_SITE_ID
			--				)

		 --/*---- ITEM_ID 정보 추출하여 저장 ----*/
		 --SET @n_ITEM_ID = 
		 --                  (
			--			   SELECT ITEM_ID FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)
			--			     WHERE 1=1
			--				   AND DIVISION_ID = @v_DIVISION_ID
			--				   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
			--				   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
			--				   AND SCM_SITE_ID = @v_SCM_SITE_ID
			--				)

		 --/*---- CONVERT_QTY_PACK 정보 추출하여 저장 ----*/
		 --SET @n_CONVERT_QTY_PACK = 
		 --                  (
			--			   SELECT CONVERT_QTY_PACK FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)
			--			     WHERE 1=1
			--				   AND DIVISION_ID = @v_DIVISION_ID
			--				   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
			--				   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
			--				   AND SCM_SITE_ID = @v_SCM_SITE_ID
			--				)

		 --/*---- CONVERT_QTY_MODULE 정보 추출하여 저장 ----*/
		 --SET @n_CONVERT_QTY_MODULE = 
		 --                  (
			--			   SELECT CONVERT_QTY_MODULE FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)
			--			     WHERE 1=1
			--				   AND DIVISION_ID = @v_DIVISION_ID
			--				   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
			--				   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
			--				   AND SCM_SITE_ID = @v_SCM_SITE_ID
			--				)

		 --/*---- CONVERT_QTY_CELL 정보 추출하여 저장 ----*/
		 --SET @n_CONVERT_QTY_CELL = 
		 --                  (
			--			   SELECT CONVERT_QTY_CELL FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)
			--			     WHERE 1=1
			--				   AND DIVISION_ID = @v_DIVISION_ID
			--				   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
			--				   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
			--				   AND SCM_SITE_ID = @v_SCM_SITE_ID
			--				 GROUP BY CONVERT_QTY_CELL,DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID -- 중복 제거용 group by
			--				)
		
		 --/*---- Convert Qty 구하기 ----*/
   --      SET @n_CONVERT_QTY =
        
   --      CASE
        
   --      WHEN (@v_UPLOAD_UOM = 'CAR') THEN 
			--   CASE 
			--        WHEN @n_UPLOAD_UOM = 'PACK'   THEN @v_QTY * @n_CONVERT_QTY_PACK
   --                 WHEN @n_UPLOAD_UOM = 'MODULE' THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE
   --                 WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL
		 --      END
   --      WHEN (@v_UPLOAD_UOM = 'PACK') THEN 
   --            CASE 
			--        WHEN @n_UPLOAD_UOM = 'PACK'   THEN @v_QTY
   --                 WHEN @n_UPLOAD_UOM = 'MODULE' THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE
   --                 WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL
		 --      END
   --      WHEN (@v_UPLOAD_UOM = 'MODULE') THEN 
   --            CASE 
   --                 WHEN @n_UPLOAD_UOM = 'MODULE' THEN @v_QTY * @n_CONVERT_QTY_MODULE
   --                 WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL
		 --      END
   --      WHEN (@v_UPLOAD_UOM = 'CELL') THEN 
   --            CASE 
   --                 WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_CELL
		 --      END
		 --END 
		 --;		 
		



		 --(3)
		 


		 --(10)
		 /*-------------------- DM_PLN_CUSTOMER_PSI 테이블 update --------------------*/
		 --BEGIN
		 --UPDATE [dbo].[DM_PLN_CUSTOMER_PSI]

		 --SET
   --                 CUSTOMER_PROJECT_CODE    =   @v_CUSTOMER_PROJECT_CODE
   --                ,CUSTOMER_MODEL           =   @v_CUSTOMER_MODEL       
   --                ,SCM_SITE_ID              =   @v_SCM_SITE_ID          
   --                ,DOM_EXP                  =   @v_DOM_EXP              
   --                ,FCST_TYPE                =   @v_FCST_TYPE            
   --                ,MEASURE_GROUP            =   @v_MEASURE_GROUP        
   --                ,MEASURE                  =   @v_MEASURE              
   --                ,YYYYMMDD                 =   @v_YYYYMMDD             
   --                ,INCOTERMS                =   @v_INCOTERMS            
   --                ,PROJECT_CODE             =   @n_PROJECT_CODE         -- 추출된값으로 셋팅
   --                ,ITEM_ID                  =   @n_ITEM_ID              -- 추출된값으로 셋팅
   --                ,QTY                      =   @v_QTY        -- CONVERT(INT,  CAST(@v_qty AS NVARCHAR(10))) 
   --                ,UPLOAD_UOM               =   @n_UPLOAD_UOM           -- 추출된값으로 셋팅  
   --                ,CREATED_BY               =   @v_CREATED_BY           
   --                ,CREATION_DATE            =   @v_CREATION_DATE        
   --                ,LAST_UPDATED_BY          =   @v_LAST_UPDATED_BY      
   --                ,LAST_UPDATE_DATE         =   sysdatetime()     
   --                ,ATTRIBUTE1               =   'ING'                   -- 'UI':업로드데이터->'ING':업데이트작업중->'BATCH':DM_PLN_MKT_FCST로 INSERT완료
   --                ,ATTRIBUTE2               =   @v_UPLOAD_UOM           -- INPUT값 UPLOAD_UOM 백업
   --                ,ATTRIBUTE3               =   @v_ATTRIBUTE3           -- UPLOAD_BUCKET_TYPE 셋팅
   --                ,ATTRIBUTE4               =   @v_ATTRIBUTE4           
   --                ,ATTRIBUTE5               =   @v_ATTRIBUTE5           
   --                ,ATTRIBUTE6               =   @v_ATTRIBUTE6           
   --                ,ATTRIBUTE7               =   @v_ATTRIBUTE7           
   --                ,ATTRIBUTE8               =   @v_ATTRIBUTE8           
   --                ,ATTRIBUTE9               =   @v_ATTRIBUTE9           
   --                ,ATTRIBUTE10              =   @v_ATTRIBUTE10          
		 --WHERE
			--	        DIVISION_ID            = @v_DIVISION_ID
			--	    AND CUSTOMER_PROJECT_CODE  = @v_CUSTOMER_PROJECT_CODE
			--	    AND CUSTOMER_MODEL         = @v_CUSTOMER_MODEL
			--	    AND SCM_SITE_ID            = @v_SCM_SITE_ID
			--	    AND DOM_EXP                = @v_DOM_EXP
			--	    AND FCST_TYPE              = @v_FCST_TYPE
			--	    AND MEASURE_GROUP          = @v_MEASURE_GROUP
			--	    AND MEASURE                = @v_MEASURE
			--	    AND YYYYMMDD               = @v_YYYYMMDD
			--	    AND INCOTERMS              = @v_INCOTERMS
			--		;
		 --SET @n_update_count= @n_update_count + 1				
		 --END
		 --(10)


		

		 --(12)
		 /*-------------------- DM_PLN_MKT_FCST 테이블 insert --------------------*/
		 --BEGIN
   --      INSERT INTO  [dbo].DM_PLN_MKT_FCST
   --            (
   --                 DIVISION_ID
   --                ,PROJECT_CODE
   --                ,SCM_SITE_ID
   --                ,ITEM_ID
   --                ,DOM_EXP
   --                ,FCST_TYPE
   --                ,INCOTERMS
   --                ,MEASURE
   --                ,YYYYMMDD
   --                ,QTY
   --                ,CREATED_BY
   --                ,CREATION_DATE
   --                ,LAST_UPDATED_BY
   --                ,LAST_UPDATE_DATE
   --                ,ATTRIBUTE1
   --                ,ATTRIBUTE2
   --                ,ATTRIBUTE3
   --                ,ATTRIBUTE4
   --                ,ATTRIBUTE5
   --                ,ATTRIBUTE6
   --                ,ATTRIBUTE7
   --                ,ATTRIBUTE8
   --                ,ATTRIBUTE9
   --                ,ATTRIBUTE10
   --            )
   --      VALUES
   --            (
   --                 @v_DIVISION_ID
   --                ,@n_PROJECT_CODE         -- 추출된값으로 셋팅
   --                ,@v_SCM_SITE_ID
   --                ,@n_ITEM_ID              -- 추출된값으로 셋팅
   --                ,@v_DOM_EXP
   --                ,@v_FCST_TYPE
   --                ,@v_INCOTERMS
   --                ,@v_MEASURE
   --                ,@v_YYYYMMDD
   --                ,@v_QTY
   --                ,@v_CREATED_BY
   --                ,@v_CREATION_DATE
   --                ,@v_LAST_UPDATED_BY
   --                ,sysdatetime()  
   --                ,'BATCH'
   --                ,@v_UPLOAD_UOM
   --                ,@v_ATTRIBUTE3
   --                ,@v_ATTRIBUTE4
   --                ,@v_ATTRIBUTE5
   --                ,@v_ATTRIBUTE6
   --                ,@v_ATTRIBUTE7
   --                ,@v_ATTRIBUTE8
   --                ,@v_ATTRIBUTE9
   --                ,@v_ATTRIBUTE10
   -- 	         )
		 --  ;
		 --SET @n_insert_count= @n_insert_count + 1				
		 --END
		 --(12)
			
			  -------------------------------------------------------------
     --         -- Merge LOG
     --         -----------------------------------------------------------
     --         SET @v_log_type = 'APPEND';
     --         SET @v_log_message = 'UPDATE PR_DM_PLN_MKT_FCST_CAR_RESULT_MAPPING';
     --         SET @v_description = '' ;
     --         SET @d_event_date = SYSDATETIME();
     --         EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    	--	  SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
     --         -----------------------------------------------------------
		
		
		FETCH NEXT FROM CUR_CUSTOMER_LT 
			INTO	@v1_DIVISION_ID
				,	@v1_BOD_TYPE	 
				,	@v1_FROM_SITE	  
				,	@v1_TO_SITE    
				,	@v1_CUSTOMER_LT    
		;	

		END
	
		-- (1)
		CLOSE CUR_CUSTOMER_LT;
		DEALLOCATE CUR_CUSTOMER_LT; 			

		DROP TABLE [dbo].TEMP_BOD_CUSTOMER_LT$;

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
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION;
      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
	  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_CUSTOMER_LT')
		BEGIN
			CLOSE CUR_CUSTOMER_LT
			DEALLOCATE CUR_CUSTOMER_LT
		END
		
	  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'c_psi_loop')
		BEGIN
			CLOSE c_psi_loop
			DEALLOCATE c_psi_loop
		END
		


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

  











