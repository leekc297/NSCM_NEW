

/*
 * Program ID   : PR_DM_PLN_CUST_PSI_TO_MKT_FCST
 * Description  : MKT FCST - PSI Production Result Mapping
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 02. 08    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2025. 06. 23	   KANG.H.J	   [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 *
 *
*/
--  데이터 확인이 필요할 경우 '--확인' 을 '--확인' 으로 변경하면 DEBUG 모드이고
--  '--확인' 을 '--확인' 으로 변경하면 일반 모드임  
/*
● PR_DM_PLN_CUST_PSI_TO_MKT_FCST 로직 구조
-----------------------------------------------------------
LOOP_1 (@n_PSI_GROUP_CNT : MEASURE별 INPUT된 ROWS만큼 처리)
-----------------------------------------------------------
    ---------------------------------------------------------
    LOOP_1 (CUR_PSI_RESULT : 커서 로딩처리)
    ---------------------------------------------------------
        -----------------------------------------------------------
        LOOP_3 (@n_PSI_GROUP_CNT : MEASURE별 INPUT된 ROWS만큼 처리)
        -----------------------------------------------------------
            - PLAN WEEK 추출
            - MEASURE별 BUCKET_TYPE 추출
            - UPLOAD_UOM 추출
            - CONVERT_QTY_PACK 산출
            - BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT
                --------------------------------------------------------
                LOOP_4 (@@n_bucketcount : BUCKET수량만큼 ROWS 증가 처리)
                --------------------------------------------------------
                    - DM_PLN_MKT_FCST 테이블에 INSERT
                --------------------------------------------------------
                LOOP_4_END (@@n_bucketcount : BUCKET수량만큼 ROWS 증가 처리)
                --------------------------------------------------------
            - DM_PLN_CUSTOMER_PSI 테이블의 처리데이터 작업중임을 마킹 UPDATE
    
        -----------------------------------------------------------
        LOOP_3_END
        -----------------------------------------------------------
    ---------------------------------------------------------
    LOOP_1_END (CLOSE 커서)
    ---------------------------------------------------------
    - Input 데이터중 실제 적용될 시작과 끝 날짜산출
    - DM_PLN_CUSTOMER_PSI 테이블의 SPLIT 처리완료된 데이터 INSERT
    - DM_PLN_MKT_FCST 테이블에 SPLIT 처리완료된 데이터 INSERT
-----------------------------------------------------------
LOOP_1_END
-----------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUST_PSI_TO_MKT_FCST]

	-- Add the parameters for the stored procedure here
	--@p_active_flag            NVARCHAR(MAX)    -- 필요없음

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_PLN_CUST_PSI_TO_MKT_FCST';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;

	-- cursor 별 로딩할 변수설정
    DECLARE @v_DIVISION_ID               nvarchar(MAX)    ;
    DECLARE @v_CUSTOMER_PROJECT_CODE     nvarchar(MAX)    ;
    DECLARE @v_CUSTOMER_MODEL            nvarchar(MAX)    ;
    DECLARE @v_SCM_SITE_ID               nvarchar(MAX)    ;
    DECLARE @v_DOM_EXP                   nvarchar(MAX)    ;
    DECLARE @v_FCST_TYPE                 nvarchar(MAX)    ;
    DECLARE @v_MEASURE_GROUP             nvarchar(MAX)    ;
    DECLARE @v_MEASURE                   nvarchar(MAX)    ;
    DECLARE @v_YYYYMMDD                  nvarchar(MAX)    ;
    DECLARE @v_INCOTERMS                 nvarchar(MAX)    ;
    DECLARE @v_PLANT_SITE_ID             nvarchar(MAX)    ;
    DECLARE @v_PROJECT_CODE              nvarchar(MAX)    ;
    DECLARE @v_ITEM_ID                   nvarchar(MAX)    ;
    DECLARE @v_QTY                       numeric(20, 10)  ;
    DECLARE @v_UPLOAD_UOM                nvarchar(MAX)    ;
    DECLARE @v_CREATED_BY                nvarchar(MAX)    ;
    DECLARE @v_CREATION_DATE             datetime         ;
    DECLARE @v_LAST_UPDATED_BY           nvarchar(MAX)    ;
    DECLARE @v_LAST_UPDATE_DATE          datetime         ;
    DECLARE @v_BATCH_RESULT              nvarchar(MAX)    ;
    DECLARE @v_MST_UPLOAD_UOM            nvarchar(MAX)    ;
    DECLARE @v_MST_UPLOAD_BUCKET_TYPE    nvarchar(MAX)    ;
    DECLARE @v_MST_SUMMARY_BUCKET_TYPE   nvarchar(MAX)    ;
    DECLARE @v_MST_CONVERT_QTY           nvarchar(MAX)    ;
    DECLARE @v_PLAN_WEEK                 nvarchar(MAX)    ;
    DECLARE @v_SPLIT_RESULT              nvarchar(MAX)    ;
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
	 
	-- 변수 설정
    DECLARE @v_day_valid				 AS NVARCHAR(8);  
    DECLARE @v_start_week				 AS NVARCHAR(8);  
    DECLARE @n_BATCH_RESULT				 nvarchar(MAX);
    DECLARE @n_psi_update_count			 INTEGER = 0;
    DECLARE @n_psi_delete_count			 INTEGER = 0;
    DECLARE @n_psi_insert_count			 INTEGER = 0;
    DECLARE @n_fcst_rslt_delete_count    INTEGER = 0;
    DECLARE @n_fcst_rslt_insert_count	 INTEGER = 0;
    DECLARE @n_fcst_delete_count		 INTEGER = 0;
    DECLARE @n_fcst_insert_count		 INTEGER = 0;
    DECLARE @n_bucketcount				 INTEGER = 0;
    DECLARE @n_bucketinsert				 INTEGER = 1;
	DECLARE @n_PSI_GROUP_INSERT			 INTEGER = 1;
	DECLARE @n_PSI_GROUP_CNT			 INTEGER = 0;
	DECLARE @n_PLAN_WEEK                 nvarchar(MAX)    ;
	DECLARE @n_VALID_BUCKET_TYPE         nvarchar(MAX)    ;
	DECLARE @n_UPLOAD_BUCKET_TYPE        nvarchar(MAX)    ;
	DECLARE @n_SUMMARY_BUCKET_TYPE       nvarchar(MAX)    ;
	DECLARE @n_CUSTOMER_PSI_VALUE        nvarchar(MAX)    ;
	DECLARE @n_UPLOAD_UOM                nvarchar(MAX)    ;
	DECLARE @n_UPLOAD_UOM_KEY            nvarchar(MAX)    ;
	DECLARE @n_ITEM_CLASS_NAME           nvarchar(MAX)    ;
	DECLARE @n_PROJECT_CODE              nvarchar(MAX)    ;
	DECLARE @n_ITEM_ID                   nvarchar(MAX)    ;
	DECLARE @n_CONVERT_QTY_PACK          numeric(20, 10)  ;
	DECLARE @n_CONVERT_QTY_MODULE        numeric(20, 10)  ;
	DECLARE @n_CONVERT_QTY_CELL          numeric(20, 10)  ;
	DECLARE @n_CONVERT_QTY               numeric(20, 10)  ;
	DECLARE @n_CALC_QTY                  numeric(20, 1)  ;
	DECLARE @n_ADD_QTY                   numeric(20, 1)  ;
	DECLARE @n_RESULT_START_DATE         nvarchar(MAX)    ;  -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자
	DECLARE @n_RESULT_END_DATE           nvarchar(MAX)    ;  -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자
	DECLARE @n_FCST_START_DATE           nvarchar(MAX)    ;  -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 시작일자
	DECLARE @n_FCST_END_DATE             nvarchar(MAX)    ;  -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 종료일자

            -------------------------------------------------------------------------------------------- 20180301 추가 (END)
	DECLARE @results TABLE ( YYYYMMDD  nvarchar(8) , DAYOFWEEK nvarchar(3))
            -------------------------------------------------------------------------------------------- 20180301 추가 (END)

END	

BEGIN
		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

	  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_PSI_RESULT')
		BEGIN
			CLOSE CUR_PSI_RESULT
			DEALLOCATE CUR_PSI_RESULT
		END;

END


	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			-- 트랜잭션 (START)
		--BEGIN TRANSACTION PR_DM_PLN_CUST_PSI_TO_MKT_FCST;  -- ssss

		BEGIN
			 IF OBJECT_ID(N'tempdb..#TEMP_DM_PLN_CUSTOMER_PSI$', N'U') IS NOT NULL  DROP TABLE dbo.#TEMP_DM_PLN_CUSTOMER_PSI$ 
		END    

		 BEGIN
			 SELECT 
				 DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE,MEASURE_GROUP
				,MEASURE,YYYYMMDD,INCOTERMS,PLANT_SITE_ID,PROJECT_CODE,ITEM_ID,QTY,UPLOAD_UOM
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,BATCH_RESULT,MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE
				,MST_SUMMARY_BUCKET_TYPE,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
			  INTO dbo.#TEMP_DM_PLN_CUSTOMER_PSI$
			 FROM dbo.DM_PLN_CUSTOMER_PSI WITH(NOLOCK)
			   WHERE BATCH_RESULT = 'UI'       -- 'UI'로 마킹된 데이터만 처리
				AND MEASURE_GROUP = 'PSI'      -- PSI 데이터만 처리
				--AND QTY > 0                  -- QTY값이 0인것도 기존데이터 초기화를 위해서 필요함
			   ORDER BY DIVISION_ID,SCM_SITE_ID,YYYYMMDD
         END
        ------------------------------------------------------------------------------------------------------------ 대상자료 저장 END

	-- DM_PLN_CUSTOMER_PSI 대상 데이터의 GROUP별 COUNT ------------------------------------------------------------------------------- START
  	BEGIN
		IF  OBJECT_ID(N'tempdb..#TEMP_PSI_GROUP_COUNT$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE dbo.#TEMP_PSI_GROUP_COUNT$ 
			END;

		BEGIN
			SELECT DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE,MEASURE_GROUP,MEASURE,INCOTERMS,PLANT_SITE_ID
				    ,row_number() OVER (ORDER BY DIVISION_ID) AS PSI_ROWNUM
				INTO dbo.#TEMP_PSI_GROUP_COUNT$  
 					FROM dbo.#TEMP_DM_PLN_CUSTOMER_PSI$
				GROUP BY DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE,MEASURE_GROUP,MEASURE,INCOTERMS,PLANT_SITE_ID
		END

		--select '#TEMP_DM_PLN_CUSTOMER_PSI$'-- 20180411
		--select * from #TEMP_DM_PLN_CUSTOMER_PSI$ -- 20180411
		--select '#TEMP_PSI_GROUP_COUNT$'-- 20180411
		--select * from #TEMP_PSI_GROUP_COUNT$ -- 20180411

		BEGIN 
			SELECT @n_PSI_GROUP_CNT = MAX(PSI_ROWNUM) FROM #TEMP_PSI_GROUP_COUNT$ 
		END
	END
	-- DM_PLN_CUSTOMER_PSI 대상 데이터의 GROUP별 COUNT ------------------------------------------------------------------------------- END

 	--------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP START
    --#############################################################################################################
 	--------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP START
   WHILE   @n_PSI_GROUP_INSERT <= @n_PSI_GROUP_CNT
   BEGIN
		-- (임시테이블 존재여부 확인후 생성) START ----------------------------
		-- (0)

		BEGIN    
			-------------------------------
			IF OBJECT_ID('tempdb..#TEMP4_DM_PLN_MKT_FCST$', N'U') IS NOT NULL 
				BEGIN
					DROP  TABLE dbo.#TEMP4_DM_PLN_MKT_FCST$ 
				END
			BEGIN
			  	SELECT * INTO dbo.#TEMP4_DM_PLN_MKT_FCST$
					FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) where division_id = 'x';
					TRUNCATE  TABLE  dbo.#TEMP4_DM_PLN_MKT_FCST$ 
			END;
			-------------------------------
			IF OBJECT_ID('tempdb..#TEMP3_DM_PLN_CUSTOMER_PSI$', N'U') IS NOT NULL 
				BEGIN
					DROP  TABLE dbo.#TEMP3_DM_PLN_CUSTOMER_PSI$ 
				END
			BEGIN
			  	SELECT * INTO dbo.#TEMP3_DM_PLN_CUSTOMER_PSI$
					FROM dbo.#TEMP_DM_PLN_CUSTOMER_PSI$  where division_id = 'x';
					TRUNCATE  TABLE  dbo.#TEMP3_DM_PLN_CUSTOMER_PSI$ 
			END;
			-------------------------------
			IF OBJECT_ID('tempdb..#TEMP2_DM_PLN_CUSTOMER_PSI$', N'U') IS NOT NULL
				BEGIN
					DROP  TABLE dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$ 
				END
			BEGIN
			  	SELECT * INTO dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$
					FROM dbo.#TEMP_DM_PLN_CUSTOMER_PSI$  where division_id = 'x';
					TRUNCATE  TABLE  dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$ 
			END;

		END

		-- (임시테이블 존재여부 확인후 생성) END ----------------------------
		-- Cursor 데이터 로딩 ----------------------------------------------------------------------------------------------- START
		 BEGIN
		 -- Cursor 로 처리
		  DECLARE CUR_PSI_RESULT CURSOR FAST_FORWARD FOR 
		  --DECLARE CUR_PSI_RESULT CURSOR FOR
			SELECT 
				 DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE
				,MEASURE_GROUP,MEASURE,YYYYMMDD,INCOTERMS,PLANT_SITE_ID,PROJECT_CODE,ITEM_ID
				,QTY,UPPER(RTRIM(LTRIM(UPLOAD_UOM))),CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,BATCH_RESULT
				,MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT
				,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
			  FROM  [dbo].#TEMP_DM_PLN_CUSTOMER_PSI$  A   
				  WHERE 1=1
					 AND EXISTS (SELECT 1
							FROM   [dbo].#TEMP_PSI_GROUP_COUNT$ B
							WHERE  B.PSI_ROWNUM = @n_PSI_GROUP_INSERT
							  AND  A.DIVISION_ID    = B.DIVISION_ID
							  AND  A.CUSTOMER_PROJECT_CODE    = B.CUSTOMER_PROJECT_CODE
							  AND  A.CUSTOMER_MODEL           = B.CUSTOMER_MODEL       
							  AND  A.SCM_SITE_ID              = B.SCM_SITE_ID          
							  AND  A.DOM_EXP                  = B.DOM_EXP              
							  AND  A.FCST_TYPE                = B.FCST_TYPE            
							  AND  A.MEASURE_GROUP            = B.MEASURE_GROUP        
							  AND  A.MEASURE                  = B.MEASURE              
							  AND  A.INCOTERMS                = B.INCOTERMS            
							  AND  A.PLANT_SITE_ID            = B.PLANT_SITE_ID        
							  )
		 END;
		  -- 
		 BEGIN
			 OPEN CUR_PSI_RESULT;
			 FETCH NEXT FROM CUR_PSI_RESULT 
			 INTO   
			  @v_DIVISION_ID
             ,@v_CUSTOMER_PROJECT_CODE
             ,@v_CUSTOMER_MODEL
             ,@v_SCM_SITE_ID
             ,@v_DOM_EXP
             ,@v_FCST_TYPE
             ,@v_MEASURE_GROUP
             ,@v_MEASURE
             ,@v_YYYYMMDD
             ,@v_INCOTERMS
             ,@v_PLANT_SITE_ID
			,@v_PROJECT_CODE
			,@v_ITEM_ID
			,@v_QTY
			,@v_UPLOAD_UOM
			,@v_CREATED_BY
			,@v_CREATION_DATE
			,@v_LAST_UPDATED_BY
			,@v_LAST_UPDATE_DATE
			,@v_BATCH_RESULT
			,@v_MST_UPLOAD_UOM
			,@v_MST_UPLOAD_BUCKET_TYPE
			,@v_MST_SUMMARY_BUCKET_TYPE
			,@v_MST_CONVERT_QTY
			,@v_PLAN_WEEK
			,@v_SPLIT_RESULT
			,@v_ATTRIBUTE1
			,@v_ATTRIBUTE2
			,@v_ATTRIBUTE3
			,@v_ATTRIBUTE4
			,@v_ATTRIBUTE5
			,@v_ATTRIBUTE6
			,@v_ATTRIBUTE7
			,@v_ATTRIBUTE8
			,@v_ATTRIBUTE9
			,@v_ATTRIBUTE10
				 ;
		 END

	---------------------------------------------------------------------------------------------------------------------------------
	-- (WHILE START) ----------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------
         WHILE @@FETCH_STATUS = 0   
	BEGIN

		 -- MEASURE별 LOOP수행시 사용된 변수 초기화 START
		 BEGIN
                  SET @v_start_week           = NULL;  
                  SET @n_UPLOAD_BUCKET_TYPE   = NULL;
                  SET @n_SUMMARY_BUCKET_TYPE  = NULL;
				  SET @n_CUSTOMER_PSI_VALUE   = NULL;
                  SET @n_PLAN_WEEK            = NULL;
                  SET @n_UPLOAD_UOM           = NULL;
                  SET @n_ITEM_CLASS_NAME      = NULL;
                  SET @n_PROJECT_CODE         = NULL;
                  SET @n_ITEM_ID              = NULL;
                  SET @n_CONVERT_QTY_PACK     = 0  ;
                  SET @n_CONVERT_QTY_MODULE   = 0  ;
                  SET @n_CONVERT_QTY_CELL     = 0  ;
                  SET @n_CONVERT_QTY          = 0  ;
		 END
		 -- MEASURE별 LOOP수행시 사용된 변수 초기화 END

		 --(3)

	     --마스터에 설정된 MEASURE별 BUCKET_TYPE 추출
	     --(F03)  
	     IF @n_UPLOAD_BUCKET_TYPE IS NULL
			 BEGIN
	
				 SELECT  @n_UPLOAD_BUCKET_TYPE = UPLOAD_BUCKET_TYPE
						--,@n_SUMMARY_BUCKET_TYPE = SUMMARY_BUCKET_TYPE
						,@n_CUSTOMER_PSI_VALUE  = CUSTOMER_PSI
						,@n_PLAN_WEEK = MAX(PLAN_WEEK)               -- PLAN_WEEK MAX 구하기
				 FROM   [dbo].DM_MST_CUSTOMER_FCST WITH(NOLOCK)
				   WHERE  1 = 1
						  AND DIVISION_ID = @v_DIVISION_ID
						  AND SCM_SITE_ID = @v_SCM_SITE_ID
						  AND MEASURE_GROUP = @v_MEASURE_GROUP
						  AND MEASURE = @v_MEASURE
						  AND VALID_YN  = 'Y'
						  AND PLAN_WEEK = 
						    (SELECT MAX(PLAN_WEEK)  
							  FROM DM_MST_CUSTOMER_FCST 
							   WHERE DIVISION_ID = @v_DIVISION_ID
								  AND SCM_SITE_ID = @v_SCM_SITE_ID
								  AND MEASURE_GROUP = @v_MEASURE_GROUP
								  AND MEASURE = @v_MEASURE
								  AND VALID_YN  = 'Y'
							   )
				   GROUP BY UPLOAD_BUCKET_TYPE, CUSTOMER_PSI, PLAN_WEEK
		    END
	     ;
		IF  @n_UPLOAD_BUCKET_TYPE = 'MONTHLY'
			BEGIN
				set @v_start_week = @v_YYYYMMDD
		    END
		ELSE
			BEGIN
				SET @v_start_week = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@v_YYYYMMDD, 'MON')), 112) 
			END
			;
		 /*---- PROJECT_CODE 정보 추출하여 저장 ----*/
		 BEGIN
		 SET @n_PROJECT_CODE =  ( SELECT PROJECT_CODE FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)
									 WHERE 1=1
									   AND DIVISION_ID = @v_DIVISION_ID
									   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
									   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
									   AND SCM_SITE_ID = @v_SCM_SITE_ID 
									   GROUP BY PROJECT_CODE)
		 END

		 -- 20180228 추가 (S)
		 IF @n_PROJECT_CODE IS NULL
			 BEGIN
				SET @n_PROJECT_CODE =  ( SELECT PROJECT_CODE FROM [dbo].SCM_MST_SITE_ITEM WITH(NOLOCK)
									 WHERE 1=1
									   AND DIVISION_ID = @v_DIVISION_ID
									   AND PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
									   AND ITEM_ID = @v_CUSTOMER_MODEL
									   AND SCM_SITE_ID = @v_SCM_SITE_ID 
									   GROUP BY PROJECT_CODE)
			 END
		 -- 20180228 추가 (E)

		 /*---- ITEM_ID 정보 추출하여 저장 ----*/
		 BEGIN
		 SET @n_ITEM_ID =  ( SELECT ITEM_ID FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)
						     WHERE 1=1
							   AND DIVISION_ID = @v_DIVISION_ID
							   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
							   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
							   AND SCM_SITE_ID = @v_SCM_SITE_ID 
							   GROUP BY ITEM_ID)
		 END
		 
		 -- 20180228 추가 (S)
		 IF @n_ITEM_ID IS NULL
			 BEGIN
				SET @n_ITEM_ID =  ( SELECT ITEM_ID FROM [dbo].SCM_MST_SITE_ITEM WITH(NOLOCK)
									 WHERE 1=1
									   AND DIVISION_ID = @v_DIVISION_ID
									   AND PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
									   AND ITEM_ID = @v_CUSTOMER_MODEL
									   AND SCM_SITE_ID = @v_SCM_SITE_ID 
									   GROUP BY ITEM_ID)
			 END

		 -- CODE값이 존재하지 않는경우 처리불가
		 IF @n_PROJECT_CODE IS NULL OR @n_PROJECT_CODE = '' OR @n_ITEM_ID IS NULL OR @n_ITEM_ID = ''
			BEGIN
				SET @v_log_type = 'INVALID';
	            SET @v_log_message = N'Project_code OR Item_ID 가 존재하지 않습니다.'
				SELECT @v_log_message
				GOTO ERR_RTN
			END
		 -- 20180228 추가 (E)

		 -- 추출된 PROJECT_CODE, ITEM ID 값으로 대체
		 BEGIN
		   SET @v_ITEM_ID      = @n_ITEM_ID
		   SET @v_PROJECT_CODE = @n_PROJECT_CODE
		 END

		 /*---- 마스터의 ITEM_CLASS_NAME 추출 ----*/
		 BEGIN
   			 SELECT  @n_ITEM_CLASS_NAME  = UPPER(RTRIM(LTRIM(ITEM_CLASS_NAME)))
			 FROM   [dbo].SCM_MST_ITEM_SN WITH(NOLOCK)
			   WHERE  1 = 1
				 AND ITEM_ID = @n_ITEM_ID
				 group by ITEM_CLASS_NAME
		 END;

		 /*---- UOM 추출 ----*/
		SET @n_UPLOAD_UOM =
			 CASE
			   WHEN (@n_ITEM_CLASS_NAME LIKE '%CAR%')    THEN  'CAR'
			   WHEN (@n_ITEM_CLASS_NAME LIKE '%PACK%')   THEN  'PACK'
			   WHEN (@n_ITEM_CLASS_NAME LIKE '%MODULE%') THEN  'MODULE'
			   WHEN (@n_ITEM_CLASS_NAME LIKE '%CELL%')   THEN  'CELL'
		 END ;

		 /*---- CONVERT_QTY_PACK 정보 추출하여 저장 ----*/
		 BEGIN
		 SET @n_CONVERT_QTY_PACK =  isnull(( SELECT CONVERT_QTY_PACK FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK) --20180301 수정
										 WHERE 1=1
										   AND DIVISION_ID = @v_DIVISION_ID
										   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
										   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
										   AND SCM_SITE_ID = @v_SCM_SITE_ID	) ,1)
		 END
		 /*---- CONVERT_QTY_MODULE 정보 추출하여 저장 ----*/
		 BEGIN
		 SET @n_CONVERT_QTY_MODULE =   isnull(( SELECT CONVERT_QTY_MODULE FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK) --20180301 수정
						     WHERE 1=1
							   AND DIVISION_ID = @v_DIVISION_ID
							   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
							   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
							   AND SCM_SITE_ID = @v_SCM_SITE_ID	) ,1)
		 END
		 /*---- CONVERT_QTY_CELL 정보 추출하여 저장 ----*/
		 BEGIN
		 SET @n_CONVERT_QTY_CELL =  isnull((
						   SELECT CONVERT_QTY_CELL FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK) --20180301 수정
						     WHERE 1=1
							   AND DIVISION_ID = @v_DIVISION_ID
							   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
							   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
							   AND SCM_SITE_ID = @v_SCM_SITE_ID
							 GROUP BY CONVERT_QTY_CELL,DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID ) ,1)
		 END

		 SET @v_UPLOAD_UOM = UPPER(@v_UPLOAD_UOM)  -- 소문자 변환후 사용

		 /*---- Convert Qty 구하기 START ----*/
		 BEGIN
		   SET @n_CONVERT_QTY =
			 CASE
				 WHEN (@v_UPLOAD_UOM = 'CAR') THEN 
					   CASE 
							WHEN @n_UPLOAD_UOM = 'CAR '   THEN @v_QTY * @n_CONVERT_QTY_PACK
							WHEN @n_UPLOAD_UOM = 'PACK'   THEN @v_QTY * @n_CONVERT_QTY_PACK
							WHEN @n_UPLOAD_UOM = 'MODULE' THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE
							WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL
					   END
				 WHEN (@v_UPLOAD_UOM = 'PACK') THEN 
					   CASE 
							WHEN @n_UPLOAD_UOM = 'PACK'   THEN @v_QTY
							WHEN @n_UPLOAD_UOM = 'MODULE' THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE
							WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL
					   END
				 WHEN (@v_UPLOAD_UOM = 'MODULE') THEN 
					   CASE 
							WHEN @n_UPLOAD_UOM = 'MODULE' THEN @v_QTY * @n_CONVERT_QTY_MODULE
							WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL
					   END
				 WHEN (@v_UPLOAD_UOM = 'CELL') THEN 
					   CASE 
							WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_CELL
					   END
				 END 
		 END ;

		 -- DM_MST_CUSTOMER_MODEL에 설정안된 measure 는 초기화해줌 20180301추가
		 IF @n_CONVERT_QTY IS NULL OR @n_CONVERT_QTY = 0
		   SET @n_CONVERT_QTY = @v_QTY * 1;

		 /*---- Convert Qty 구하기 END ----*/
		 
		 -- bucketcount 산출
		 BEGIN
		    SET @n_bucketinsert = 1;  -- 초기화
			SET @n_bucketcount = 0;   -- 초기화
			SET @n_CALC_QTY = 0;      -- 초기화
			SET @n_ADD_QTY = 0;       -- 초기화
		 END

            -- 캘린더 임시테이블 생성
  		    IF OBJECT_ID('tempdb..#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$') IS NOT NULL 
			  BEGIN
			    DROP TABLE dbo.#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ 
			  END

			BEGIN
				SELECT BASIS_YYYYMMDD,WEEK_NO AS ROWNUM INTO dbo.#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$  FROM dbo.SCM_SYS_CALENDAR_M with(nolock) where END_FLAG = 'x';
				TRUNCATE TABLE [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$;
			END
			-------------------------------
			IF  @n_CUSTOMER_PSI_VALUE = 'I'  -- DM_MST_CUSTOMER_FCST.CUSTOMER_PSI 값이 'I' 인경우는 SPLIT하지않는다.
				BEGIN

					INSERT INTO [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ (basis_yyyymmdd,ROWNUM) VALUES (@v_yyyymmdd,1)
					SET @n_bucketcount = 1
				END

            -- BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT (START)   jjjj
		    BEGIN
			----------------------------------------------------------------------------------------------------
			IF @n_UPLOAD_BUCKET_TYPE = 'MONTHLY' AND @n_CUSTOMER_PSI_VALUE = 'S'
  			    ----------------------------------------------------------------------------------------------------
				BEGIN
					--확인 select @v_start_week as '@v_start_week'

					INSERT INTO [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
					SELECT b.basis_yyyymmdd,row_number() OVER (ORDER BY b.basis_yyyymmdd) AS rownum
					FROM   dbo.DM_MST_BUCKET_CONVERSION a WITH(NOLOCK)
						  ,dbo.SCM_SYS_CALENDAR_M b WITH(NOLOCK)
 						  ,dbo.SCM_SYS_CALENDAR_M c WITH(NOLOCK)
					where a.division_id = @v_DIVISION_ID
						and a.scm_site_id = @v_SCM_SITE_ID
						and a.INCOTERMS = @v_INCOTERMS
						and a.yyyymmdd = b.dayofweek
						and b.calendar_yyyy = c.calendar_yyyy
						and b.calendar_month = c.calendar_month
						and c.basis_yyyymmdd = @v_start_week -- 해당 주차 
					-- bucketcount 산출
					select @n_bucketcount = MAX(rownum)  FROM [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$

						---------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (START)
						IF @n_bucketcount IS NULL OR  @n_bucketcount = 0 
						  BEGIN
								DELETE  FROM  @results

								INSERT INTO @results
								SELECT basis_yyyymmdd,dayofweek
								  FROM dbo.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMM = SUBSTRING(@v_start_week,1,6)  -- 매월 1일 날짜로 해당월의 모든 날짜 선택
								  --AND DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') ORDER BY BASIS_YYYYMMDD   -- 20180424 skh modify
								  AND DAYOFWEEK in (SELECT SEGMENT3 
								                      FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
													    where 1=1
								                          and SEGMENT1    = @v_DIVISION_ID 
														  and LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY' 
														  and SEGMENT2    = @n_UPLOAD_BUCKET_TYPE)  -- 20180424 skh 조건변경
								   ORDER BY BASIS_YYYYMMDD  

								INSERT INTO [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
								SELECT b.basis_yyyymmdd,row_number() OVER (ORDER BY b.basis_yyyymmdd) AS rownum
								FROM    @results a
										,dbo.SCM_SYS_CALENDAR_M b WITH(NOLOCK)
								where a.DAYOFWEEK       = b.dayofweek
									and a.YYYYMMDD      = b.basis_yyyymmdd
								select @n_bucketcount = MAX(rownum)  FROM [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$

						  END

						---------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END)
				END
  			    ----------------------------------------------------------------------------------------------------
		     ELSE IF   @n_UPLOAD_BUCKET_TYPE = 'WEEKLY' AND @n_CUSTOMER_PSI_VALUE = 'S'
  			            ----------------------------------------------------------------------------------------------------
						BEGIN
							INSERT INTO [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
							SELECT b.basis_yyyymmdd,row_number() OVER (ORDER BY b.basis_yyyymmdd) AS rownum
							FROM   dbo.DM_MST_BUCKET_CONVERSION a WITH(NOLOCK)
								  ,dbo.SCM_SYS_CALENDAR_M b WITH(NOLOCK)
 								  ,dbo.SCM_SYS_CALENDAR_M c WITH(NOLOCK)
							where a.division_id = @v_DIVISION_ID
								and a.scm_site_id = @v_SCM_SITE_ID
								and a.INCOTERMS = @v_INCOTERMS
								and a.yyyymmdd = b.dayofweek
								and b.iso_yyyyww = c.iso_yyyyww
						        and c.basis_yyyymmdd = @v_start_week -- 해당 주차
							-- bucketcount 산출
							select @n_bucketcount = MAX(rownum)  FROM [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
						--확인	SELECT @n_bucketcount AS bucketcount_WEEKLY_LOGIC

						---------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (START)
						IF @n_bucketcount IS NULL OR  @n_bucketcount = 0 
						  BEGIN
								DELETE  FROM  @results

								--  날짜선택오류로 ISO_WEEK 조건추가 20180402 (SONGKH)
								INSERT INTO @results
									SELECT BASIS_YYYYMMDD,DAYOFWEEK
									  FROM SCM_SYS_CALENDAR_M Z WITH(NOLOCK)
										  ,(SELECT DISTINCT ISO_WEEK, ISO_YYYYWW FROM SCM_SYS_CALENDAR_M W  WITH(NOLOCK)
												WHERE  BASIS_START_DATE = @V_START_WEEK) K  -- 매주 월요일 날짜로 해당주의 날짜 선택
									 WHERE Z.ISO_WEEK = K.ISO_WEEK
									   AND Z.ISO_YYYYWW = K.ISO_YYYYWW
								  --AND DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') ORDER BY BASIS_YYYYMMDD   -- 20180424 skh modify
								  AND DAYOFWEEK in (SELECT SEGMENT3 
								                      FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
													    where 1=1
								                          and SEGMENT1    = @v_DIVISION_ID 
														  and LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY' 
														  and SEGMENT2    = @n_UPLOAD_BUCKET_TYPE)  -- 20180424 skh 조건변경
								   ORDER BY BASIS_YYYYMMDD  

								--  날짜선택오류로 ISO_WEEK 조건추가 20180402 (SONGKH)

								INSERT INTO [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
								SELECT b.basis_yyyymmdd,row_number() OVER (ORDER BY b.basis_yyyymmdd) AS rownum
								FROM    @results a
										,dbo.SCM_SYS_CALENDAR_M b WITH(NOLOCK)
								where a.DAYOFWEEK       = b.dayofweek
									and a.YYYYMMDD      = b.basis_yyyymmdd
								select @n_bucketcount = MAX(rownum)  FROM [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
						  END


						  --확인 SELECT @n_bucketcount AS '@n_bucketcount'
						---------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END)
						END
  			            ----------------------------------------------------------------------------------------------------
					  
					 ELSE
  			            ----------------------------------------------------------------------------------------------------
						BEGIN
						IF @n_UPLOAD_BUCKET_TYPE = 'DAILY' AND @n_CUSTOMER_PSI_VALUE = 'S'
							BEGIN
							--확인	SELECT @n_bucketcount AS bucketcount_DAILY_LOGIC

								INSERT INTO [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ (basis_yyyymmdd,ROWNUM) VALUES (@v_yyyymmdd,1)
								SET @n_bucketcount = 1
						   END
				       END
  			            ----------------------------------------------------------------------------------------------------
		    END

            -- BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT (END)

			--확인 SELECT @n_bucketinsert AS 'SSS @n_bucketinsert', @n_bucketcount AS 'SSS @n_bucketcount'
 			--------------------------------------------------------------------------------------------------------------- bucket loop START
			WHILE   @n_bucketinsert <= @n_bucketcount
			BEGIN   
					 -- 변수 초기화
					 BEGIN
							  SET @n_BATCH_RESULT = NULL;
					 END

					 --확인   select @n_bucketinsert as '@n_bucketinsert', @n_bucketcount as '@n_bucketcount'
					 -- Convert QTY값 산출
					IF @n_UPLOAD_BUCKET_TYPE = 'DAILY'
						  BEGIN
							SET @n_CALC_QTY = @n_CONVERT_QTY  - @n_ADD_QTY    -- DAILY 인경우는 SPLIT 은 필요없지만 변환된 QTY값을 그대로 사용함
						  END
					ELSE
						IF @n_bucketinsert < @n_bucketcount  -- 마지막데이터가 아닌경우 SPLIT된값을 넣어줌
						   BEGIN
							   SET @n_CALC_QTY = CONVERT(DECIMAL(20,1), ROUND(@n_CONVERT_QTY/@n_bucketcount, 0,1))
							   SET @n_ADD_QTY = @n_ADD_QTY + @n_CALC_QTY
						   END
						ELSE
						   BEGIN
							   -- 마지막 데이터인경우 나머지값을 몰아주기
							   SET @n_CALC_QTY = @n_CONVERT_QTY  - @n_ADD_QTY   /*   - CONVERT(DECIMAL(20,1), ROUND(@n_CONVERT_QTY/@n_bucketcount , 0))   */
						   END
					;
				    
						BEGIN
							--insert into  [dbo].DM_PLN_CUSTOMER_PSI
							insert into  [dbo].[#TEMP3_DM_PLN_CUSTOMER_PSI$]      -- 
							(
							DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE,MEASURE_GROUP
							,MEASURE,YYYYMMDD,INCOTERMS,PLANT_SITE_ID,PROJECT_CODE,ITEM_ID,QTY,UPLOAD_UOM,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE,BATCH_RESULT,MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT
							,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
							values
							(
							 @v_DIVISION_ID
							,@v_CUSTOMER_PROJECT_CODE
							,@v_CUSTOMER_MODEL
							,@v_SCM_SITE_ID
							,@v_DOM_EXP
							,@v_FCST_TYPE
							,@v_MEASURE_GROUP
							--,RTRIM(LTRIM(STR(Convert(NVARCHAR(20), @v_MEASURE) + '_new_temp')))
							,@v_MEASURE + '_new_temp'
							,(select BASIS_YYYYMMDD from [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ where rownum = @n_bucketinsert)
							,@v_INCOTERMS
							,@v_PLANT_SITE_ID
							,@v_PROJECT_CODE
							,@v_ITEM_ID
							,@n_CALC_QTY    -- ROW별로 나눠진 값을 넣음
							,@v_UPLOAD_UOM
							,@v_CREATED_BY
							,@v_CREATION_DATE
							,@v_LAST_UPDATED_BY
							,sysdatetime()
							,'SPLIT_COMPLETED'             -- 7777
							,@n_UPLOAD_UOM
							,@n_UPLOAD_BUCKET_TYPE
							,@n_SUMMARY_BUCKET_TYPE
							,@v_MST_CONVERT_QTY
							,@v_PLAN_WEEK
							,@v_SPLIT_RESULT
							,@v_ATTRIBUTE1
							,@v_ATTRIBUTE2
							,@v_ATTRIBUTE3
							,@v_ATTRIBUTE4
							,@v_ATTRIBUTE5
							,@v_ATTRIBUTE6
							,@v_ATTRIBUTE7
							,@v_ATTRIBUTE8
							,@v_ATTRIBUTE9
							,@v_ATTRIBUTE10
							)
							SET @n_BATCH_RESULT = 'SPLIT_COMPLETED'
						END

			-- 재고(I) 인경우 2개의 MEASURE 추가생성 --------------------------------------------------------------------------------------------------- start  
			IF  @n_CUSTOMER_PSI_VALUE = 'I'
				  BEGIN
					INSERT  INTO  [dbo].[#TEMP3_DM_PLN_CUSTOMER_PSI$]
							(
							DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE,MEASURE_GROUP
							,MEASURE,YYYYMMDD,INCOTERMS,PLANT_SITE_ID,PROJECT_CODE,ITEM_ID,QTY,UPLOAD_UOM,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE,BATCH_RESULT,MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT
							,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
							values
							(
							 @v_DIVISION_ID
							,@v_CUSTOMER_PROJECT_CODE
							,@v_CUSTOMER_MODEL
							,@v_SCM_SITE_ID
							,@v_DOM_EXP
							,@v_FCST_TYPE
							,@v_MEASURE_GROUP
							--,RTRIM(LTRIM(STR(Convert(NVARCHAR(20), @v_MEASURE) + '_new_temp')))
							,'CUST_INV_I' --@v_MEASURE + '_new_temp'
							,(select BASIS_YYYYMMDD from [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ where rownum = @n_bucketinsert)
							,@v_INCOTERMS
							,@v_PLANT_SITE_ID
							,@v_PROJECT_CODE
							,@v_ITEM_ID
							,@n_CALC_QTY    -- ROW별로 나눠진 값을 넣음
							,@v_UPLOAD_UOM
							,@v_CREATED_BY
							,@v_CREATION_DATE
							,@v_LAST_UPDATED_BY
							,sysdatetime()
							,'UPLOAD_COMPLETED'             -- 7777
							,@n_UPLOAD_UOM
							,@n_UPLOAD_BUCKET_TYPE
							,@n_SUMMARY_BUCKET_TYPE
							,@v_MST_CONVERT_QTY
							,@v_PLAN_WEEK
							,@v_SPLIT_RESULT
							,@v_ATTRIBUTE1
							,@v_ATTRIBUTE2
							,@v_ATTRIBUTE3
							,@v_ATTRIBUTE4
							,@v_ATTRIBUTE5
							,@v_ATTRIBUTE6
							,@v_ATTRIBUTE7
							,@v_ATTRIBUTE8
							,@v_ATTRIBUTE9
							,@v_ATTRIBUTE10
							)

					INSERT  INTO  [dbo].[#TEMP3_DM_PLN_CUSTOMER_PSI$]
							(
							DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE,MEASURE_GROUP
							,MEASURE,YYYYMMDD,INCOTERMS,PLANT_SITE_ID,PROJECT_CODE,ITEM_ID,QTY,UPLOAD_UOM,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE,BATCH_RESULT,MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT
							,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
							values
							(
							 @v_DIVISION_ID
							,@v_CUSTOMER_PROJECT_CODE
							,@v_CUSTOMER_MODEL
							,@v_SCM_SITE_ID
							,@v_DOM_EXP
							,@v_FCST_TYPE
							,@v_MEASURE_GROUP
							--,RTRIM(LTRIM(STR(Convert(NVARCHAR(20), @v_MEASURE) + '_new_temp')))
							,'MKT_INV_I' --@v_MEASURE + '_new_temp'
							,(select BASIS_YYYYMMDD from [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ where rownum = @n_bucketinsert)
							,@v_INCOTERMS
							,@v_PLANT_SITE_ID
							,@v_PROJECT_CODE
							,@v_ITEM_ID
							,@n_CALC_QTY    -- ROW별로 나눠진 값을 넣음
							,@v_UPLOAD_UOM
							,@v_CREATED_BY
							,@v_CREATION_DATE
							,@v_LAST_UPDATED_BY
							,sysdatetime()
							,'UPLOAD_COMPLETED'             -- 7777
							,@n_UPLOAD_UOM
							,@n_UPLOAD_BUCKET_TYPE
							,@n_SUMMARY_BUCKET_TYPE
							,@v_MST_CONVERT_QTY
							,@v_PLAN_WEEK
							,@v_SPLIT_RESULT
							,@v_ATTRIBUTE1
							,@v_ATTRIBUTE2
							,@v_ATTRIBUTE3
							,@v_ATTRIBUTE4
							,@v_ATTRIBUTE5
							,@v_ATTRIBUTE6
							,@v_ATTRIBUTE7
							,@v_ATTRIBUTE8
							,@v_ATTRIBUTE9
							,@v_ATTRIBUTE10
							)

				 END
			-- 재고(I) 인경우 2개의 MEASURE 추가생성 --------------------------------------------------------------------------------------------------- end

			-- Customer Product (S) 인경우 2개의 MEASURE 추가생성 --------------------------------------------------------------------------------------------------- start  
			IF  @n_CUSTOMER_PSI_VALUE = 'S'
				  BEGIN
					INSERT  INTO  [dbo].[#TEMP3_DM_PLN_CUSTOMER_PSI$]
							(
							DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE,MEASURE_GROUP
							,MEASURE,YYYYMMDD,INCOTERMS,PLANT_SITE_ID,PROJECT_CODE,ITEM_ID,QTY,UPLOAD_UOM,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE,BATCH_RESULT,MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT
							,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
							values
							(
							 @v_DIVISION_ID
							,@v_CUSTOMER_PROJECT_CODE
							,@v_CUSTOMER_MODEL
							,@v_SCM_SITE_ID
							,@v_DOM_EXP
							,@v_FCST_TYPE
							,@v_MEASURE_GROUP
							--,RTRIM(LTRIM(STR(Convert(NVARCHAR(20), @v_MEASURE) + '_new_temp')))
							,'CUST_Product_S' --@v_MEASURE + '_new_temp'
							,(select BASIS_YYYYMMDD from [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ where rownum = @n_bucketinsert)
							,@v_INCOTERMS
							,@v_PLANT_SITE_ID
							,@v_PROJECT_CODE
							,@v_ITEM_ID
							,@n_CALC_QTY    -- ROW별로 나눠진 값을 넣음
							,@v_UPLOAD_UOM
							,@v_CREATED_BY
							,@v_CREATION_DATE
							,@v_LAST_UPDATED_BY
							,sysdatetime()
							,'UPLOAD_COMPLETED'             -- 7777
							,@n_UPLOAD_UOM
							,@n_UPLOAD_BUCKET_TYPE
							,@n_SUMMARY_BUCKET_TYPE
							,@v_MST_CONVERT_QTY
							,@v_PLAN_WEEK
							,@v_SPLIT_RESULT
							,@v_ATTRIBUTE1
							,@v_ATTRIBUTE2
							,@v_ATTRIBUTE3
							,@v_ATTRIBUTE4
							,@v_ATTRIBUTE5
							,@v_ATTRIBUTE6
							,@v_ATTRIBUTE7
							,@v_ATTRIBUTE8
							,@v_ATTRIBUTE9
							,@v_ATTRIBUTE10
							)

					INSERT  INTO  [dbo].[#TEMP3_DM_PLN_CUSTOMER_PSI$]
							(
							DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE,MEASURE_GROUP
							,MEASURE,YYYYMMDD,INCOTERMS,PLANT_SITE_ID,PROJECT_CODE,ITEM_ID,QTY,UPLOAD_UOM,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE,BATCH_RESULT,MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT
							,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
							values
							(
							 @v_DIVISION_ID
							,@v_CUSTOMER_PROJECT_CODE
							,@v_CUSTOMER_MODEL
							,@v_SCM_SITE_ID
							,@v_DOM_EXP
							,@v_FCST_TYPE
							,@v_MEASURE_GROUP
							--,RTRIM(LTRIM(STR(Convert(NVARCHAR(20), @v_MEASURE) + '_new_temp')))
							,'MKT_Product_S' --@v_MEASURE + '_new_temp'
							,(select BASIS_YYYYMMDD from [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ where rownum = @n_bucketinsert)
							,@v_INCOTERMS
							,@v_PLANT_SITE_ID
							,@v_PROJECT_CODE
							,@v_ITEM_ID
							,@n_CALC_QTY    -- ROW별로 나눠진 값을 넣음
							,@v_UPLOAD_UOM
							,@v_CREATED_BY
							,@v_CREATION_DATE
							,@v_LAST_UPDATED_BY
							,sysdatetime()
							,'UPLOAD_COMPLETED'             -- 7777
							,@n_UPLOAD_UOM
							,@n_UPLOAD_BUCKET_TYPE
							,@n_SUMMARY_BUCKET_TYPE
							,@v_MST_CONVERT_QTY
							,@v_PLAN_WEEK
							,@v_SPLIT_RESULT
							,@v_ATTRIBUTE1
							,@v_ATTRIBUTE2
							,@v_ATTRIBUTE3
							,@v_ATTRIBUTE4
							,@v_ATTRIBUTE5
							,@v_ATTRIBUTE6
							,@v_ATTRIBUTE7
							,@v_ATTRIBUTE8
							,@v_ATTRIBUTE9
							,@v_ATTRIBUTE10
							)

				 END

			-- Customer Product (S) 인경우 2개의 MEASURE 추가생성 --------------------------------------------------------------------------------------------------- end
					BEGIN
						SET @n_CALC_QTY = 0   -- 사용후 초기화
					END

					BEGIN
						SET @n_bucketinsert = @n_bucketinsert + 1  -- 최대 ROWS 까지 증가시킴
					END

		 /*----------------------------------------------------------------------------------------------------------------*/

			END
 			--------------------------------------------------------------------------------------------------------------- bucket loop END

		 --(10)
		 /*-------------------- DM_PLN_CUSTOMER_PSI 테이블 update --------------------*/
		 BEGIN
			 UPDATE [dbo].[DM_PLN_CUSTOMER_PSI]

			 SET
						CUSTOMER_PROJECT_CODE    =   @v_CUSTOMER_PROJECT_CODE
					   ,CUSTOMER_MODEL           =   @v_CUSTOMER_MODEL       
					   ,SCM_SITE_ID              =   @v_SCM_SITE_ID          
					   ,DOM_EXP                  =   @v_DOM_EXP              
					   ,FCST_TYPE                =   @v_FCST_TYPE            
					   ,MEASURE_GROUP            =   @v_MEASURE_GROUP        
					   ,MEASURE                  =   @v_MEASURE              
					   ,YYYYMMDD                 =   @v_YYYYMMDD             
					   ,INCOTERMS                =   @v_INCOTERMS            
					   ,PLANT_SITE_ID            =   @v_PLANT_SITE_ID
					   ,PROJECT_CODE             =   @n_PROJECT_CODE         -- 추출된값으로 셋팅
					   ,ITEM_ID                  =   @n_ITEM_ID              -- 추출된값으로 셋팅
					   ,QTY                      =   @v_QTY        -- CONVERT(INT,  CAST(@v_qty AS NVARCHAR(10))) 
					   ,UPLOAD_UOM               =   @v_UPLOAD_UOM           -- INPUT값 UPLOAD_UOM  
					   ,CREATED_BY               =   @v_CREATED_BY           
					   ,CREATION_DATE            =   @v_CREATION_DATE        
					   ,LAST_UPDATED_BY          =   @v_LAST_UPDATED_BY      
					   ,LAST_UPDATE_DATE         =   sysdatetime()     
					   ,BATCH_RESULT             =   @n_BATCH_RESULT         -- 1.'UI':업로드데이터 2.'UPLOAD_COMPLETED':업데이트작업 3.'UPLOAD_UOM_NOT_FOUND':에러건 
					                                                         -- 4.'BATCH':DM_PLN_MKT_FCST로 INSERT완료건  1111
					   ,MST_UPLOAD_UOM           =   @n_UPLOAD_UOM           -- SCM_MST_ITEM_SN.UPLOAD_UOM 추출값
					   ,MST_UPLOAD_BUCKET_TYPE   =   @n_UPLOAD_BUCKET_TYPE   -- DM_MST_CUSTOMER_FCST.UPLOAD_BUCKET_TYPE 셋팅
					   ,MST_SUMMARY_BUCKET_TYPE  =   @n_SUMMARY_BUCKET_TYPE  -- DM_MST_CUSTOMER_FCST.SUMMARY_BUCKET_TYPE 셋팅
					   ,MST_CONVERT_QTY          =   @n_CONVERT_QTY          -- DM_MST_CUSTOMER_FCST.CONVERT_QTY 셋팅
					   ,PLAN_WEEK                =   @n_PLAN_WEEK            -- DM_MST_CUSTOMER_FCST.PLAN_WEEK 셋팅
					   ,SPLIT_RESULT             =   @v_SPLIT_RESULT           
					   ,ATTRIBUTE1               =   @v_ATTRIBUTE1           
					   ,ATTRIBUTE2               =   @v_ATTRIBUTE2           
					   ,ATTRIBUTE3               =   @v_ATTRIBUTE3           
					   ,ATTRIBUTE4               =   @v_ATTRIBUTE4           
					   ,ATTRIBUTE5               =   @v_ATTRIBUTE5           
					   ,ATTRIBUTE6               =   @v_ATTRIBUTE6           
					   ,ATTRIBUTE7               =   @v_ATTRIBUTE7           
					   ,ATTRIBUTE8               =   @v_ATTRIBUTE8           
					   ,ATTRIBUTE9               =   @v_ATTRIBUTE9           
					   ,ATTRIBUTE10              =   @v_ATTRIBUTE10          
			 WHERE
							DIVISION_ID            = @v_DIVISION_ID
						AND CUSTOMER_PROJECT_CODE  = @v_CUSTOMER_PROJECT_CODE
						AND CUSTOMER_MODEL         = @v_CUSTOMER_MODEL
						AND SCM_SITE_ID            = @v_SCM_SITE_ID
						AND DOM_EXP                = @v_DOM_EXP
						AND FCST_TYPE              = @v_FCST_TYPE
						AND MEASURE_GROUP          = @v_MEASURE_GROUP
						AND MEASURE                = @v_MEASURE
						AND YYYYMMDD               = @v_YYYYMMDD
						AND INCOTERMS              = @v_INCOTERMS
						AND PLANT_SITE_ID          = @v_PLANT_SITE_ID
						;
			 SET @n_psi_update_count= @n_psi_update_count + 1				
		 END
		 --(10)

		BEGIN
			FETCH NEXT FROM CUR_PSI_RESULT INTO   
						@v_DIVISION_ID
					   ,@v_CUSTOMER_PROJECT_CODE
					   ,@v_CUSTOMER_MODEL
					   ,@v_SCM_SITE_ID
					   ,@v_DOM_EXP
					   ,@v_FCST_TYPE
					   ,@v_MEASURE_GROUP
					   ,@v_MEASURE
					   ,@v_YYYYMMDD
					   ,@v_INCOTERMS
					   ,@v_PLANT_SITE_ID
					   ,@v_PROJECT_CODE
					   ,@v_ITEM_ID
					   ,@v_QTY
					   ,@v_UPLOAD_UOM
					   ,@v_CREATED_BY
					   ,@v_CREATION_DATE
					   ,@v_LAST_UPDATED_BY
					   ,@v_LAST_UPDATE_DATE
					   ,@v_BATCH_RESULT
					   ,@v_MST_UPLOAD_UOM
					   ,@v_MST_UPLOAD_BUCKET_TYPE
					   ,@v_MST_SUMMARY_BUCKET_TYPE
					   ,@v_MST_CONVERT_QTY
					   ,@v_PLAN_WEEK
					   ,@v_SPLIT_RESULT
					   ,@v_ATTRIBUTE1
					   ,@v_ATTRIBUTE2
					   ,@v_ATTRIBUTE3
					   ,@v_ATTRIBUTE4
					   ,@v_ATTRIBUTE5
					   ,@v_ATTRIBUTE6
					   ,@v_ATTRIBUTE7
					   ,@v_ATTRIBUTE8
					   ,@v_ATTRIBUTE9
					   ,@v_ATTRIBUTE10
					   ;
		END
		-- (1)
	
	END
	--------------------------------------------------------------------------------------------------------------------------------
	-- (WHILE END ) ----------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------

	  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_PSI_RESULT')
		BEGIN
			CLOSE CUR_PSI_RESULT
			DEALLOCATE CUR_PSI_RESULT
		END;

		
			---input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (start) EEEE
			IF OBJECT_ID('tempdb..#TEMP_MIN_MAX_PSI$', N'U') IS NOT NULL
				BEGIN
					DROP  TABLE dbo.#TEMP_MIN_MAX_PSI$ 
				END
			BEGIN
			  	SELECT YYYYMMDD,row_number() OVER (ORDER BY YYYYMMDD) AS ROWNUM INTO dbo.#TEMP_MIN_MAX_PSI$
					FROM [dbo].[#TEMP3_DM_PLN_CUSTOMER_PSI$] 
					GROUP BY YYYYMMDD  ORDER BY YYYYMMDD 

			END;

			-----------------------------------------------------------------------------------------------
			BEGIN
			    SELECT @n_FCST_START_DATE = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 시작일자
			    SELECT @n_FCST_END_DATE = YYYYMMDD FROM dbo.#TEMP_MIN_MAX_PSI$  WHERE ROWNUM = (SELECT MAX(ROWNUM) FROM dbo.#TEMP_MIN_MAX_PSI$)  -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 종료일자

				if @n_FCST_START_DATE > @n_FCST_END_DATE 
				  BEGIN
				  set @n_FCST_START_DATE = @n_FCST_END_DATE
				  END

			    SELECT @n_RESULT_START_DATE = YYYYMMDD FROM dbo.#TEMP_MIN_MAX_PSI$  WHERE ROWNUM = 1  -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자

				
			END
			-----------------------------------------------------------------------------------------------

			---input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (end)

		 -- (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (start)

				BEGIN
					IF @n_UPLOAD_BUCKET_TYPE = 'DAILY'
						BEGIN
							SELECT @n_FCST_END_DATE = BASIS_YYYYMMDD
								FROM   [dbo].[SCM_SYS_CALENDAR_M] T WITH(NOLOCK) 
								WHERE  T.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, 0, @n_FCST_END_DATE), 112)  -- MAX_YYYYMMDD 셋팅
						END
					ELSE IF @n_UPLOAD_BUCKET_TYPE = 'WEEKLY'
						BEGIN
							set @n_FCST_START_DATE = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@n_FCST_START_DATE, 'MON')), 112) -- MIN_YYYYMMDD 셋팅
							SELECT @n_FCST_END_DATE = BASIS_YYYYMMDD
								FROM   [dbo].[SCM_SYS_CALENDAR_M] T WITH(NOLOCK) 
								WHERE  T.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, +6, @n_FCST_END_DATE), 112)  -- MAX_YYYYMMDD 셋팅
						END
					ELSE IF @n_UPLOAD_BUCKET_TYPE = 'MONTHLY'
						BEGIN
							SELECT @n_FCST_END_DATE = BASIS_YYYYMMDD
								FROM   [dbo].[SCM_SYS_CALENDAR_M] T WITH(NOLOCK) 
								WHERE  T.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(CHAR(8), DATEADD(MM, +1, @n_FCST_END_DATE), 112) ), 112)   -- MAX_YYYYMMDD 셋팅
						END

			    SELECT @n_RESULT_END_DATE = CONVERT(CHAR(8), DATEADD(DD, -1, @n_FCST_START_DATE), 112) -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 마지막 일자

				if @n_RESULT_END_DATE < @n_RESULT_START_DATE    -- 20180315 SKH MODIFY 
				  set @n_RESULT_START_DATE =  @n_RESULT_END_DATE  ;

				END;

		 -- (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (end)


			-- DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT ---------------------------------------------------------------------------------------

			-- DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT 전 임시테이블에 모두 저장 
		  BEGIN

		    -- CUSTOMER PSI = 'I' 인경우의 INSERT 값 ---------------------------------------------------------------------------- START
			INSERT  INTO  [dbo].[#TEMP2_DM_PLN_CUSTOMER_PSI$]
			SELECT 
  				 DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID,DOM_EXP,FCST_TYPE,MEASURE_GROUP
				,MEASURE
				,YYYYMMDD,INCOTERMS,PLANT_SITE_ID,PROJECT_CODE,ITEM_ID,QTY,UPLOAD_UOM,CREATED_BY,CREATION_DATE
				,LAST_UPDATED_BY,LAST_UPDATE_DATE,'UPLOAD_COMPLETED',MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE
				,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
			FROM [dbo].[#TEMP3_DM_PLN_CUSTOMER_PSI$]  
 		      WHERE 1=1
		 	  AND BATCH_RESULT = 'UPLOAD_COMPLETED'        -- SPLIT 완료된 데이터만 처리
			  AND YYYYMMDD >= @n_RESULT_START_DATE  -- 과거의 시작데이터
			  AND YYYYMMDD <= @n_FCST_END_DATE      -- 미래의 마지막데이터
		    -- CUSTOMER PSI = 'I' 인경우의 INSERT 값 ---------------------------------------------------------------------------- END

		  END

			----------------------------------------------------------------------------------------------------------------------------

		 /*-------------------- 기존 데이터를 TEMP TABLE에 INSERT 하여 계산할수 있도록함 --------------------*/
 	     BEGIN
			INSERT INTO [dbo].#TEMP4_DM_PLN_MKT_FCST$ 
			--SELECT *		/* [PJ2025-50188] [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (개발서버에 소스가 없어서 운영에서 받아와서 변경후 COMPILE 처리) */
			SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				 ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
			FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK)
				WHERE 1=1
				and division_id    = @v_division_id
				and project_code   = @v_project_code
				and scm_site_id    = @v_scm_site_id
				and item_id        = @v_item_id
				and dom_exp        = @v_dom_exp
				and fcst_type      = @v_fcst_type
				and incoterms      = @v_incoterms
				and plant_site_id  = @v_plant_site_id
      			and YYYYMMDD      >= @n_FCST_START_DATE  -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자
       			--and  YYYYMMDD <= @n_FCST_END_DATE    -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자  -- 20180315 skh modify
       			and YYYYMMDD      <= CONVERT(CHAR(8), DATEADD(DD, +7 * 27, dbo.FN_NEXT_DAY(@n_FCST_START_DATE, 'SUN')), 112)		-- 미래 6개월치로 설정해놓았음    -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자  -- 20180315 skh add
			UNION
			--SELECT *		/* [PJ2025-50188] [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (개발서버에 소스가 없어서 운영에서 받아와서 변경후 COMPILE 처리) */
			SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD
				 ,SUM(QTY) AS QTY,MAX(CREATED_BY) AS CREATED_BY,MAX(CREATION_DATE) AS CREATION_DATE, MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY, MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
				 ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
			FROM dbo.DM_PLN_MKT_FCST_RESULT WITH(NOLOCK)
				WHERE 1=1
				and division_id    = @v_division_id
				and project_code   = @v_project_code
				and scm_site_id    = @v_scm_site_id
				and item_id        = @v_item_id
				and dom_exp        = @v_dom_exp
				and fcst_type      = @v_fcst_type
				and incoterms      = @v_incoterms
				and plant_site_id  = @v_plant_site_id
       			and YYYYMMDD      >= @n_RESULT_START_DATE  -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자
       			and YYYYMMDD      <= @n_RESULT_END_DATE    -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자
			GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD
				 ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
 	     END


		 /*-------------------- 데이터 INSERT 전 TEMP TABLE 중복데이터 삭제  --------------------*/
           BEGIN 

		   DELETE 
           FROM dbo.#TEMP4_DM_PLN_MKT_FCST$ 
           WHERE (
                    SELECT count(1) 
					  FROM dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$ B 
 					  WHERE 1=1
					   and  #TEMP4_DM_PLN_MKT_FCST$.DIVISION_ID        =  B.DIVISION_ID
					   and  #TEMP4_DM_PLN_MKT_FCST$.SCM_SITE_ID        =  B.SCM_SITE_ID                         
					   and  #TEMP4_DM_PLN_MKT_FCST$.PROJECT_CODE       =  B.PROJECT_CODE                         
					   and  #TEMP4_DM_PLN_MKT_FCST$.ITEM_ID            =  B.ITEM_ID                         
					   and  #TEMP4_DM_PLN_MKT_FCST$.DOM_EXP            =  B.DOM_EXP                         
					   and  #TEMP4_DM_PLN_MKT_FCST$.FCST_TYPE          =  B.FCST_TYPE                         
					   and  #TEMP4_DM_PLN_MKT_FCST$.INCOTERMS          =  B.INCOTERMS                         
					   and  #TEMP4_DM_PLN_MKT_FCST$.PLANT_SITE_ID      =  B.PLANT_SITE_ID                         
					   and  #TEMP4_DM_PLN_MKT_FCST$.MEASURE            =  B.MEASURE                         
		 				AND BATCH_RESULT = 'UPLOAD_COMPLETED' 
				  ) > 0
           END

		 --(11)
		 /*-------------------- 과거구간부터 미래의 끝 데이터까지 WOS작업을 진행하기 위하여 TEMP TABLE에 INSERT  --------------------*/
		    BEGIN
				INSERT  INTO  dbo.#TEMP4_DM_PLN_MKT_FCST$
				SELECT 
  					     DIVISION_ID
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE     -- 20180227
						,PLANT_SITE_ID
						,YYYYMMDD
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,sysdatetime()
						,'UPLOAD_COMPLETED',MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE
					    ,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM [dbo].#TEMP2_DM_PLN_CUSTOMER_PSI$  
 				  WHERE 1=1
		 		    AND BATCH_RESULT = 'UPLOAD_COMPLETED' 
			END

			-- 20180315 
			DELETE FROM dbo.#TEMP4_DM_PLN_MKT_FCST$ WHERE QTY = 0

			--  WOS 프로시져 호출  pppp
			--IF  @n_CUSTOMER_PSI_VALUE = 'S'  -- 20180315 skh modify 

					EXEC PR_DM_PLN_CUST_PSI_TO_MKT_FCST_WOS   @p_division_id   = @v_division_id
															 ,@p_project_code  = @v_project_code
															 ,@p_incoterms     = @v_incoterms
															 ,@p_scm_site_id   = @v_scm_site_id
															 ,@p_plant_site_id = @v_plant_site_id
															 ,@p_dom_exp       = @v_dom_exp
															 ,@p_fcst_type     = @v_fcst_type
															 ,@p_item_id       = @v_item_id
															 ,@p_mon_day       = @n_result_start_date


		 /*-------------------- DM_PLN_MKT_FCST_RESULT 테이블 delete count 확인 --------------------*/
		    BEGIN
				SET @n_fcst_rslt_delete_count = @n_fcst_rslt_delete_count + 
			   (SELECT 
						 COUNT(*) as count
						FROM dbo.DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
			   WHERE (
						SELECT count(1) 
						  FROM dbo.#TEMP4_DM_PLN_MKT_FCST$ B 
						 where 1=1
							  AND  A.DIVISION_ID     = B.DIVISION_ID   
							  AND  A.SCM_SITE_ID     = B.SCM_SITE_ID    
							  AND  A.PROJECT_CODE    = B.PROJECT_CODE       
							  AND  A.ITEM_ID         = B.ITEM_ID           
							  AND  A.DOM_EXP         = B.DOM_EXP         
							  AND  A.FCST_TYPE       = B.FCST_TYPE     
							  AND  A.INCOTERMS       = B.INCOTERMS           
							  AND  A.PLANT_SITE_ID   = B.PLANT_SITE_ID         
							  AND  A.MEASURE         = B.MEASURE       
								--AND YYYYMMDD >= @n_RESULT_START_DATE  -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 시작일자 -- 20180315 skh modify
								--AND YYYYMMDD <= @n_RESULT_END_DATE    -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 종료일자 -- 20180315 skh modify
										
					  ) > 0
					  )
			END

		 /*-------------------- DM_PLN_MKT_FCST 테이블 delete count 확인 --------------------*/
		    BEGIN
				SET @n_fcst_delete_count = @n_fcst_delete_count + 
			   (SELECT 
						 COUNT(*) as count
						FROM dbo.DM_PLN_MKT_FCST A WITH(NOLOCK)
			   WHERE (
						SELECT count(1) 
						  FROM dbo.#TEMP4_DM_PLN_MKT_FCST$ B 
						 where 1=1
							  AND  A.DIVISION_ID     = B.DIVISION_ID   
							  AND  A.SCM_SITE_ID     = B.SCM_SITE_ID    
							  AND  A.PROJECT_CODE    = B.PROJECT_CODE       
							  AND  A.ITEM_ID         = B.ITEM_ID           
							  AND  A.DOM_EXP         = B.DOM_EXP         
							  AND  A.FCST_TYPE       = B.FCST_TYPE     
							  AND  A.INCOTERMS       = B.INCOTERMS           
							  AND  A.PLANT_SITE_ID   = B.PLANT_SITE_ID         
							  AND  A.MEASURE         = B.MEASURE       
								--AND YYYYMMDD >= @n_FCST_START_DATE  -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 시작일자 -- 20180315 skh modify
								AND YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +7 * 27, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112)	 -- @n_FCST_END_DATE    -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 종료일자
										
					  ) > 0
					  )
			END

		 /*-------------------- DM_PLN_MKT_FCST_RESULT 테이블 insert전 데이터 중복제거 --------------------*/
           BEGIN 
			DELETE
				FROM  [dbo].DM_PLN_MKT_FCST_RESULT 
                  WHERE (
                    SELECT count(1) 
					  FROM dbo.#TEMP4_DM_PLN_MKT_FCST$ B 
				     where  1=1
					   and  DM_PLN_MKT_FCST_RESULT.DIVISION_ID        =  B.DIVISION_ID
					   and  DM_PLN_MKT_FCST_RESULT.SCM_SITE_ID        =  B.SCM_SITE_ID                         
					   and  DM_PLN_MKT_FCST_RESULT.PROJECT_CODE       =  B.PROJECT_CODE                         
					   and  DM_PLN_MKT_FCST_RESULT.ITEM_ID            =  B.ITEM_ID                         
					   and  DM_PLN_MKT_FCST_RESULT.DOM_EXP            =  B.DOM_EXP                         
					   and  DM_PLN_MKT_FCST_RESULT.FCST_TYPE          =  B.FCST_TYPE                         
					   and  DM_PLN_MKT_FCST_RESULT.INCOTERMS          =  B.INCOTERMS                         
					   and  DM_PLN_MKT_FCST_RESULT.PLANT_SITE_ID      =  B.PLANT_SITE_ID                         
					   and  DM_PLN_MKT_FCST_RESULT.MEASURE            =  B.MEASURE                       
					   and  DM_PLN_MKT_FCST_RESULT.YYYYMMDD           =  B.YYYYMMDD
       				   --and  YYYYMMDD >= @n_RESULT_START_DATE  -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자
       				   --and  YYYYMMDD <= @n_RESULT_END_DATE    -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자  -- 20180315 skh modify
				  ) > 0
           END
		 /*-------------------- DM_PLN_MKT_FCST 테이블 insert전 데이터 중복제거 --------------------*/
           BEGIN 
			DELETE
				FROM  [dbo].DM_PLN_MKT_FCST 
           WHERE (
                    SELECT count(1) 
					  FROM dbo.#TEMP4_DM_PLN_MKT_FCST$ B 
				     where  1=1
			   and  DM_PLN_MKT_FCST.DIVISION_ID        =  B.DIVISION_ID
               and  DM_PLN_MKT_FCST.SCM_SITE_ID        =  B.SCM_SITE_ID                         
               and  DM_PLN_MKT_FCST.PROJECT_CODE       =  B.PROJECT_CODE                         
               and  DM_PLN_MKT_FCST.ITEM_ID            =  B.ITEM_ID                         
               and  DM_PLN_MKT_FCST.DOM_EXP            =  B.DOM_EXP                         
               and  DM_PLN_MKT_FCST.FCST_TYPE          =  B.FCST_TYPE                         
               and  DM_PLN_MKT_FCST.INCOTERMS          =  B.INCOTERMS                         
               and  DM_PLN_MKT_FCST.PLANT_SITE_ID      =  B.PLANT_SITE_ID                         
               and  DM_PLN_MKT_FCST.MEASURE            =  B.MEASURE                         
               and  DM_PLN_MKT_FCST.YYYYMMDD           =  B.YYYYMMDD                         
               --and  YYYYMMDD >= @n_FCST_START_DATE  -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 시작일자
               --and  YYYYMMDD <= @n_FCST_END_DATE    -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 종료일자 -- 20180315 skh modify

				  ) > 0
           END

		 /*-------------------- DM_PLN_MKT_FCST_RESULT 테이블 insert count 확인 --------------------*/
		    BEGIN
				INSERT  INTO  dbo.DM_PLN_MKT_FCST_RESULT
				SELECT distinct
  					     DIVISION_ID
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID
						,YYYYMMDD
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,sysdatetime()
						,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3
					    ,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						,NULL AS SO_RANK ,NULL AS SO_NO, NULL AS SO_QTY		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (칼럼 추가로 인해 NULL로 세팅)		
						, '-'	AS CELL_PROD_SITE_ID						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (81사업부 전용 소스이므로 '-'로 고정)		
				FROM [dbo].#TEMP4_DM_PLN_MKT_FCST$  
 				  WHERE 1=1
					--AND YYYYMMDD >= @n_RESULT_START_DATE  -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자-- 20180315 skh modify
					--AND YYYYMMDD <= @n_RESULT_END_DATE    -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자-- 20180315 skh modify
					--and @n_RESULT_START_DATE <> @n_RESULT_END_DATE -- 20180315 skh modify
			END

		 /*-------------------- DM_PLN_MKT_FCST_RESULT 테이블 insert count 확인 --------------------*/ -- LLLL
		    BEGIN
				SET @n_fcst_rslt_insert_count = @n_fcst_rslt_insert_count + 
				 (SELECT 
				     COUNT(*) as count
				FROM [dbo].#TEMP4_DM_PLN_MKT_FCST$  
 				  WHERE 1=1
					AND YYYYMMDD >= @n_RESULT_START_DATE  -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자
					AND YYYYMMDD <= @n_RESULT_END_DATE    -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자
					)
		    END

		 /*-------------------- DM_PLN_MKT_FCST 테이블 insert count 확인 --------------------*/ -- LLLL
		    BEGIN
				SET @n_fcst_insert_count = @n_fcst_insert_count + 
				 (SELECT 
				     COUNT(*) as count
				FROM [dbo].#TEMP4_DM_PLN_MKT_FCST$  
 				  WHERE 1=1
					AND YYYYMMDD >= @n_FCST_START_DATE  -- DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자
				   --and  YYYYMMDD <= @n_FCST_END_DATE    -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 종료일자 -- 20180315 skh modify
       				AND  YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, +7 * 27, dbo.FN_NEXT_DAY(@n_FCST_START_DATE, 'SUN')), 112)  -- 미래 6개월치로 설정해놓았음  -- 20180315 skh add


					)
		    END
		 /*-------------------- DM_PLN_MKT_FCST 테이블 insert 확인 --------------------*/
		    BEGIN
				INSERT  INTO  dbo.DM_PLN_MKT_FCST
				SELECT distinct
  					     DIVISION_ID
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID
						,YYYYMMDD
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,sysdatetime()
						,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3
					    ,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM [dbo].#TEMP4_DM_PLN_MKT_FCST$  
 				  WHERE 1=1
					--AND YYYYMMDD >= @n_FCST_START_DATE  -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 시작일자
					--AND YYYYMMDD <=  CONVERT(CHAR(8), DATEADD(DD, +7 * 27, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112)	 -- @n_FCST_END_DATE    -- DM_PLN_MKT_FCST 테이블에 적용할 데이터의 종료일자  -- 20180315 skh modify 종료일자 적용하지 않음

			END


		    BEGIN
				SET @n_fcst_insert_count = @n_fcst_insert_count + 
				 (SELECT 
				     COUNT(*) as count
					 --row_number() OVER (ORDER BY DIVISION_ID DESC) AS rownum 
				  FROM [dbo].#TEMP2_DM_PLN_CUSTOMER_PSI$  
 				  WHERE 1=1
		 		    AND BATCH_RESULT = 'UPLOAD_COMPLETED' 
				  )
			END
		 --  GROUP 로딩 COUNT 증가
		 BEGIN
		   SET @n_PSI_GROUP_INSERT = @n_PSI_GROUP_INSERT + 1
		 END

		 
		 IF @n_PSI_GROUP_INSERT <= @n_PSI_GROUP_CNT
			 BEGIN

			   -- GROUP별로 작업종료후 Temp Table TRUNCATE
			   TRUNCATE TABLE dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$
			   TRUNCATE TABLE dbo.#TEMP3_DM_PLN_CUSTOMER_PSI$
			   TRUNCATE TABLE dbo.#TEMP4_DM_PLN_MKT_FCST$

			 END

   END
 	--------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP END
    --#############################################################################################################
 	--------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP END
    --    IF @@TRANCOUNT > 0
          --COMMIT WORK;
		  --END
		
		END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
		--ROLLBACK TRANSACTION PR_DM_PLN_CUST_PSI_TO_MKT_FCST;    -- ssss

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

	  SET @v_log_message = '########## ERROR of procedure ##########';
	  SET @v_description = '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE()
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	888

	-- 수행결과 성공여부 DISPLAY
   --  IF @v_log_message IS NULL
	  --SELECT 'success'	;

		BEGIN
		--임시테이블 삭제 ------------------------------------------------------------- (start)
  		IF OBJECT_ID('tempdb..#TEMP_DM_PLN_CUSTOMER_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP_DM_PLN_CUSTOMER_PSI$ ;
  		IF OBJECT_ID('tempdb..#TEMP_PSI_GROUP_COUNT$') IS NOT NULL DROP TABLE dbo.#TEMP_PSI_GROUP_COUNT$ ;
  		IF OBJECT_ID('tempdb..#TEMP3_DM_PLN_CUSTOMER_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP3_DM_PLN_CUSTOMER_PSI$ ;
  		IF OBJECT_ID('tempdb..#TEMP2_DM_PLN_CUSTOMER_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$ ;
  		IF OBJECT_ID('tempdb..#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ ;
  		IF OBJECT_ID('tempdb..#TEMP_MIN_MAX_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP_MIN_MAX_PSI$ ;
  		IF OBJECT_ID('tempdb..#TEMP4_DM_PLN_MKT_FCST$') IS NOT NULL DROP TABLE dbo.#TEMP4_DM_PLN_MKT_FCST$ ;
		--임시테이블 삭제 ------------------------------------------------------------- (END)
		END

    -- 종료 LOG

    if @v_log_type = 'ERROR'
	  BEGIN
		SET @v_log_message = '########## ERROR of procedure ##########';
		SET @v_description = '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE()
	  END
	else
	  BEGIN
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = 'psi_update_count= ' + Convert(NVARCHAR(10), @n_psi_update_count) +  ' / psi_delete_count= ' + Convert(NVARCHAR(10), @n_psi_delete_count)
							  +  ' / psi_insert_count= ' + Convert(NVARCHAR(10), @n_psi_insert_count) 
							  +  ' / rslt_delete_count= ' + Convert(NVARCHAR(10), @n_fcst_rslt_delete_count) 
							  +  ' / rslt_insert_count= ' + Convert(NVARCHAR(10), @n_fcst_rslt_insert_count) 
							  +  ' / fcst_delete_count= ' + Convert(NVARCHAR(10), @n_fcst_delete_count) 
							  +  ' / fcst_insert_count= ' + Convert(NVARCHAR(10), @n_fcst_insert_count)
							  --+ '
		;-- @n_fcst_rslt_delete_count
	  END

    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	ERR_RTN:
	IF @v_log_type = 'INVALID'
	  BEGIN
		 --ROLLBACK TRANSACTION PR_DM_PLN_CUST_PSI_TO_MKT_FCST
         EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  END

  --END;
