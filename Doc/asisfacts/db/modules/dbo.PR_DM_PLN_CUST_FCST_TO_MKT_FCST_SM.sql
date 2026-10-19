
/*
 * Program ID   : PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM
 * Description  : MKT FCST - Car Production Result Mapping 
 * Program History  
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 01. 11    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022. 10. 26	   KDW2819	   [C20221024-000507]CUST FCST Upload 오류 수정
 * 2024. 04. 30    kcw3408     N:N Model Mapping_적재 추가(집계 시점에 Cust Item/Unloading Point/Plant 고려,Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음)
 *
 *
*/
--  데이터 확인이 필요할 경우 '--확인' 을 '--확인' 으로 변경하면 DEBUG 모드이고
--  '--확인' 을 '--확인' 으로 변경하면 일반 모드임  
/*
● PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM 로직 구조
-----------------------------------------------------------
LOOP_1 (@n_PSI_GROUP_CNT : MEASURE별 INPUT된 ROWS만큼 처리)
-----------------------------------------------------------
    ---------------------------------------------------------
    LOOP_1 (CUR_CAR_RESULT : 커서 로딩처리)
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

create PROCEDURE [dbo].[PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM]

	-- Add the parameters for the stored procedure here
	--@p_active_flag            NVARCHAR(MAX)    -- 필요없음

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM';
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
    DECLARE @n_fcst_delete_count		 INTEGER = 0;
    DECLARE @n_fcst_insert_count		 INTEGER = 0;
    DECLARE @n_bucketcount				 INTEGER = 0;
    DECLARE @n_bucketinsert				 INTEGER = 1;
	DECLARE @n_PSI_GROUP_INSERT			 INTEGER = 1;
	DECLARE @n_PSI_GROUP_CNT			 INTEGER = 0;
	DECLARE @n_MIN_YYYYMMDD              nvarchar(MAX)    ;
	DECLARE @n_MAX_YYYYMMDD              nvarchar(MAX)    ;
	DECLARE @n_PLAN_WEEK                 nvarchar(MAX)    ;
	DECLARE @n_VALID_BUCKET_TYPE         nvarchar(MAX)    ;
	DECLARE @n_UPLOAD_BUCKET_TYPE        nvarchar(MAX)    ;
	DECLARE @n_SUMMARY_BUCKET_TYPE       nvarchar(MAX)    ;
	DECLARE @n_UPLOAD_UOM                nvarchar(MAX)    ;
	DECLARE @n_UPLOAD_UOM_KEY            nvarchar(MAX)    ;
	DECLARE @n_AUTO_SPLIT_DATA           nvarchar(MAX)    ;
	DECLARE @n_ITEM_CLASS_NAME           nvarchar(MAX)    ;
	DECLARE @n_PROJECT_CODE              nvarchar(MAX)    ;
	DECLARE @n_ITEM_ID                   nvarchar(MAX)    ;
	DECLARE @n_CONVERT_QTY_PACK          numeric(20, 10)  ;
	DECLARE @n_CONVERT_QTY_MODULE        numeric(20, 10)  ;
	DECLARE @n_CONVERT_QTY_CELL          numeric(20, 10)  ;
	DECLARE @n_CONVERT_QTY               numeric(20, 10)  ;
	DECLARE @n_CALC_QTY                  numeric(20, 1)  ;
	DECLARE @n_ADD_QTY                   numeric(20, 1)  ;
    DECLARE @n_TEST_VAL                   nvarchar(MAX)    ;

            -------------------------------------------------------------------------------------------- 20180301 추가 (START)
	DECLARE @results TABLE ( YYYYMMDD  nvarchar(8) , DAYOFWEEK nvarchar(3))
            -------------------------------------------------------------------------------------------- 20180301 추가 (END)

    -------------------------------------------------------------------------------------------- 20180409 추가 (START)
	-- @@tmp_site_customer_map TEMP TABLE
	DECLARE @tmp_site_customer_map TABLE (
              DIVISION_ID      NVARCHAR(MAX)
             ,SCM_SITE_ID      NVARCHAR(MAX)
             ,MEASURE          NVARCHAR(MAX)
             ,start_day        NVARCHAR(MAX)
             ,end_day          NVARCHAR(MAX)
			 )
    -------------------------------------------------------------------------------------------- 20180409 추가 (END)

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
	  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_CAR_RESULT')
		BEGIN
			CLOSE CUR_CAR_RESULT
			DEALLOCATE CUR_CAR_RESULT
		END;

END

		-- 트랜잭션 (START)
		BEGIN TRANSACTION CUST_FCST_TO_MKT_FCST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

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
				AND MEASURE_GROUP = 'CUST_FCST'   -- FCST 데이터만 처리
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

		BEGIN 
			SELECT @n_PSI_GROUP_CNT = MAX(PSI_ROWNUM) FROM #TEMP_PSI_GROUP_COUNT$ 
		END

	END
	-- DM_PLN_CUSTOMER_PSI 대상 데이터의 GROUP별 COUNT ------------------------------------------------------------------------------- END

 	--------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP START
    --#############################################################################################################
 	--------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP START
--20240605
print '20240605-1';
print @n_PSI_GROUP_INSERT;
print @n_PSI_GROUP_CNT;


   WHILE   @n_PSI_GROUP_INSERT <= @n_PSI_GROUP_CNT
   BEGIN
		-- (임시테이블 존재여부 확인후 생성) START ----------------------------
		-- (0)

		BEGIN    
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
print '20240605-2';
		-- Cursor 데이터 로딩 ----------------------------------------------------------------------------------------------- START
		 BEGIN
		 -- Cursor 로 처리
		  DECLARE CUR_CAR_RESULT CURSOR FAST_FORWARD FOR 
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
							WHERE  B.PSI_ROWNUM               = @n_PSI_GROUP_INSERT
							  AND  A.DIVISION_ID              = B.DIVISION_ID
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
			 OPEN CUR_CAR_RESULT;
			 FETCH NEXT FROM CUR_CAR_RESULT 
			 INTO       @v_DIVISION_ID
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

	-- (WHILE START) ----------------------------------------------------------------------------------------------------------------
         WHILE @@FETCH_STATUS = 0   
	BEGIN

		 -- 변수 초기화
		 BEGIN
                  SET @v_start_week           = NULL;  
                  SET @n_UPLOAD_BUCKET_TYPE   = NULL;
                  SET @n_SUMMARY_BUCKET_TYPE  = NULL;
                  SET @n_PLAN_WEEK            = NULL;
                  SET @n_UPLOAD_UOM           = NULL;
                  SET @n_ITEM_CLASS_NAME      = NULL;
                  SET @n_PROJECT_CODE         = NULL;
                  SET @n_ITEM_ID              = NULL;
                  SET @n_UPLOAD_UOM_KEY       = NULL;
                  SET @n_AUTO_SPLIT_DATA      = NULL;
                  SET @n_CONVERT_QTY_PACK     = 0  ;
                  SET @n_CONVERT_QTY_MODULE   = 0  ;
                  SET @n_CONVERT_QTY_CELL     = 0  ;
                  SET @n_CONVERT_QTY          = 0  ;
		 END

	     --마스터에 설정된 MEASURE별 BUCKET_TYPE 추출
	     --(F03)  
	     IF @n_UPLOAD_BUCKET_TYPE IS NULL
			 BEGIN
	
				 SELECT @n_UPLOAD_BUCKET_TYPE = UPLOAD_BUCKET_TYPE,
						@n_SUMMARY_BUCKET_TYPE = SUMMARY_BUCKET_TYPE,
						@n_PLAN_WEEK = MAX(PLAN_WEEK)               -- PLAN_WEEK MAX 구하기
				 FROM   [dbo].DM_MST_CUSTOMER_FCST WITH(NOLOCK)
				   WHERE  1 = 1
						  AND DIVISION_ID = @v_DIVISION_ID
						  AND SCM_SITE_ID = @v_SCM_SITE_ID
						  AND MEASURE_GROUP = @v_MEASURE_GROUP
						  AND MEASURE = @v_MEASURE
						  and VALID_YN = 'Y'  -- 20180409 SongKH Add
						  AND PLAN_WEEK = 
						    (SELECT MAX(PLAN_WEEK)  
							  FROM DM_MST_CUSTOMER_FCST 
							   WHERE DIVISION_ID = @v_DIVISION_ID
								  AND SCM_SITE_ID = @v_SCM_SITE_ID
								  AND MEASURE_GROUP = @v_MEASURE_GROUP
								  AND MEASURE = @v_MEASURE
								  and VALID_YN = 'Y'  -- 20180409 SongKH Add
							   )
				   GROUP BY UPLOAD_BUCKET_TYPE, SUMMARY_BUCKET_TYPE, PLAN_WEEK
		    END
	     ;
            PRINT @n_UPLOAD_BUCKET_TYPE;
            PRINT @n_SUMMARY_BUCKET_TYPE;
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
									   AND SCM_SITE_ID = @v_SCM_SITE_ID )
		 END

PRINT 'CUSTOMER_PROJECT_CODE ' + @v_CUSTOMER_PROJECT_CODE
PRINT 'CUSTOMER_MODEL ' + @v_CUSTOMER_MODEL

--20240605
PRINT 'n_UPLOAD_BUCKET_TYPE ' + @n_UPLOAD_BUCKET_TYPE
PRINT 'n_SUMMARY_BUCKET_TYPE ' + @n_SUMMARY_BUCKET_TYPE
print @v_YYYYMMDD;
print @v_start_week;




--20240605
--PRINT '@n_PROJECT_CODE_T1 : ' + ISNULL(@n_PROJECT_CODE,'T1');
--PRINT '@@v_DIVISION_ID : ' + ISNULL(@v_DIVISION_ID,'Z1');
--PRINT '@@v_PROJECT_CODE : ' + ISNULL(@v_PROJECT_CODE,'Z2');
--PRINT '@@v_ITEM_ID : ' + ISNULL(@v_ITEM_ID,'Z3');
--PRINT '@@v_SCM_SITE_ID : ' + ISNULL(@v_SCM_SITE_ID,'Z4');


		 -- 20180228 추가 (S)
		 IF @n_PROJECT_CODE IS NULL
			 BEGIN
				SET @n_PROJECT_CODE =  ( SELECT PROJECT_CODE FROM [dbo].SCM_MST_SITE_ITEM WITH(NOLOCK)
									 WHERE 1=1
									   AND DIVISION_ID = @v_DIVISION_ID
									   AND PROJECT_CODE = @v_PROJECT_CODE
									   AND ITEM_ID = @v_ITEM_ID
									   AND SCM_SITE_ID = @v_SCM_SITE_ID )
				
				PRINT '@n_PROJECT_CODE_T2 : ' + ISNULL(@n_PROJECT_CODE,'T2');

			 END
		 -- 20180228 추가 (E)

		 /*---- ITEM_ID 정보 추출하여 저장 ----*/
		 BEGIN
		 SET @n_ITEM_ID =  ( SELECT ITEM_ID FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)
						     WHERE 1=1
							   AND DIVISION_ID = @v_DIVISION_ID
							   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
							   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
							   AND SCM_SITE_ID = @v_SCM_SITE_ID )

			PRINT '@n_ITEM_ID_T3 : ' + ISNULL(@n_ITEM_ID,'T3');
		 END
		 
		 -- 20180228 추가 (S)
		 IF @n_ITEM_ID IS NULL
			 BEGIN
				SET @n_ITEM_ID =  ( SELECT ITEM_ID FROM [dbo].SCM_MST_SITE_ITEM WITH(NOLOCK)
									 WHERE 1=1
									   AND DIVISION_ID = @v_DIVISION_ID
									   AND PROJECT_CODE = @v_PROJECT_CODE
									   AND ITEM_ID = @v_ITEM_ID
									   AND SCM_SITE_ID = @v_SCM_SITE_ID )
				PRINT '@n_ITEM_ID_T4 : ' + ISNULL(@n_ITEM_ID,'T4');
			 END

		 -- CODE값이 존재하지 않는경우 처리불가  20180319 SKH MODIFY
--PRINT 'PROJECT_CODE(1) ' + @n_PROJECT_CODE;
--PRINT 'ITEM_ID(1)  ' + @n_ITEM_ID;
print '20240605-3';

		 IF @n_PROJECT_CODE IS NULL OR @n_PROJECT_CODE = '' OR @n_ITEM_ID IS NULL OR @n_ITEM_ID = ''
			BEGIN
print '20240605-z1';
				SET @v_log_type = 'INVALID';
	            SET @v_log_message = N'Project_code OR Item_ID 가 존재하지 않습니다.'
				SELECT @v_log_message
				GOTO ERR_RTN
			END
		 -- 20180228 추가 (E)

		 -- 추출된 PROJECT_CODE, ITEM ID 값으로 대체
		 BEGIN
print '20240605-z2';
		   SET @v_ITEM_ID      = @n_ITEM_ID
		   SET @v_PROJECT_CODE = @n_PROJECT_CODE
		 END

print '20240605-4';
print '@v_ITEM_ID-4: ' + @v_ITEM_ID ;
print '@v_PROJECT_CODE-4: ' + @v_PROJECT_CODE;


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

		 -- 20180320 제품이 아닌 상품인 경우에는 기본단위로 사용함 SKH ADDED
		 if @n_UPLOAD_UOM is null
		   BEGIN
		     SET @n_UPLOAD_UOM = 'CELL'
		   END


		 /*---- CONVERT_QTY_PACK 정보 추출하여 저장 ----*/
		 BEGIN
		 SET @n_CONVERT_QTY_PACK =  isnull( ( SELECT CONVERT_QTY_PACK FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)  --20180301 수정
										 WHERE 1=1
										   AND DIVISION_ID = @v_DIVISION_ID
										   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
										   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
										   AND SCM_SITE_ID = @v_SCM_SITE_ID	) ,1)
		 END
		 /*---- CONVERT_QTY_MODULE 정보 추출하여 저장 ----*/
		 BEGIN
		 SET @n_CONVERT_QTY_MODULE = isnull( ( SELECT CONVERT_QTY_MODULE FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)  --20180301 수정
						     WHERE 1=1
							   AND DIVISION_ID = @v_DIVISION_ID
							   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
							   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
							   AND SCM_SITE_ID = @v_SCM_SITE_ID	),1)
		 END
		 /*---- CONVERT_QTY_CELL 정보 추출하여 저장 ----*/
		 BEGIN
		 SET @n_CONVERT_QTY_CELL =  isnull( (
						   SELECT CONVERT_QTY_CELL FROM [dbo].DM_MST_CUSTOMER_MODEL WITH(NOLOCK)  --20180301 수정
						     WHERE 1=1
							   AND DIVISION_ID = @v_DIVISION_ID
							   AND CUSTOMER_PROJECT_CODE = @v_CUSTOMER_PROJECT_CODE
							   AND CUSTOMER_MODEL = @v_CUSTOMER_MODEL
							   AND SCM_SITE_ID = @v_SCM_SITE_ID
							 GROUP BY CONVERT_QTY_CELL,DIVISION_ID,CUSTOMER_PROJECT_CODE,CUSTOMER_MODEL,SCM_SITE_ID ),1)
		 END

		 /*---- Convert Qty 구하기 START ----*/
		 BEGIN
		   SET @n_CONVERT_QTY =
			 CASE
				 WHEN (@v_UPLOAD_UOM = 'CAR') THEN 
					   CASE 
							WHEN @n_UPLOAD_UOM = 'CAR '   THEN @v_QTY --@n_CONVERT_QTY_PACK
							WHEN @n_UPLOAD_UOM = 'PACK'   THEN @v_QTY * @n_CONVERT_QTY_PACK
							WHEN @n_UPLOAD_UOM = 'MODULE' THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE
							WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL
					   END
				 WHEN (@v_UPLOAD_UOM = 'PACK') THEN 
					   CASE 
							WHEN @n_UPLOAD_UOM = 'PACK'   THEN @v_QTY
							WHEN @n_UPLOAD_UOM = 'MODULE' THEN @v_QTY * @n_CONVERT_QTY_MODULE -- * @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE
							WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL --* @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL
					   END
				 WHEN (@v_UPLOAD_UOM = 'MODULE') THEN 
					   CASE 
							WHEN @n_UPLOAD_UOM = 'MODULE' THEN @v_QTY --* @n_CONVERT_QTY_MODULE
							WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY * @n_CONVERT_QTY_CELL --* @n_CONVERT_QTY_PACK * @n_CONVERT_QTY_MODULE * @n_CONVERT_QTY_CELL
					   END
				 WHEN (@v_UPLOAD_UOM = 'CELL') THEN 
					   CASE 
							WHEN @n_UPLOAD_UOM = 'CELL'   THEN @v_QTY --* @n_CONVERT_QTY_CELL
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

            -- BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT (START)
		    BEGIN
			----------------------------------------------------------------------------------------------------
			IF @n_UPLOAD_BUCKET_TYPE = 'MONTHLY'
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
						and a.BUCKET_PER = 'Y' and a.VALID_YN = 'Y'
						and b.calendar_yyyy = c.calendar_yyyy
						and b.calendar_month = c.calendar_month
						and c.basis_yyyymmdd = @v_start_week -- 해당 주차
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

								SET @n_AUTO_SPLIT_DATA = 'Y'

						  END

						---------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END)
						-- bucketcount 산출

				END
  			    ----------------------------------------------------------------------------------------------------
		     ELSE IF   @n_UPLOAD_BUCKET_TYPE = 'WEEKLY'
  						----------------------------------------------------------------------------------------------------
						BEGIN

print '20240605-weekly';


							INSERT INTO [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
							SELECT b.basis_yyyymmdd,row_number() OVER (ORDER BY b.basis_yyyymmdd) AS rownum
							FROM   dbo.DM_MST_BUCKET_CONVERSION a WITH(NOLOCK)
								  ,dbo.SCM_SYS_CALENDAR_M b WITH(NOLOCK)
 								  ,dbo.SCM_SYS_CALENDAR_M c WITH(NOLOCK)
							where a.division_id = @v_DIVISION_ID
								and a.scm_site_id = @v_SCM_SITE_ID
								and a.INCOTERMS = @v_INCOTERMS
								and a.yyyymmdd = b.dayofweek
						        and a.BUCKET_PER = 'Y' and a.VALID_YN = 'Y'
								and b.iso_yyyyww = c.iso_yyyyww
						        and c.basis_yyyymmdd = @v_start_week -- 해당 주차
							-- bucketcount 산출
							select @n_bucketcount = MAX(rownum)  FROM [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
print '@n_bucketcount : ' + convert(char, @n_bucketcount);

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
PRINT @n_bucketcount
--PRINT @v_DIVISION_ID
--PRINT @n_UPLOAD_BUCKET_TYPE
								--  날짜선택오류로 ISO_WEEK 조건추가 20180402 (SONGKH)

								INSERT INTO [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
								SELECT b.basis_yyyymmdd,row_number() OVER (ORDER BY b.basis_yyyymmdd) AS rownum
								FROM    @results a
										,dbo.SCM_SYS_CALENDAR_M b WITH(NOLOCK)
								where a.DAYOFWEEK       = b.dayofweek
									and a.YYYYMMDD      = b.basis_yyyymmdd
								select @n_bucketcount = MAX(rownum)  FROM [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$
								--확인 SELECT @n_bucketcount AS '@n_bucketcount IMSI'

								SET @n_AUTO_SPLIT_DATA = 'Y'

						  END

						---------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END)

						END
					  
					 ELSE
						BEGIN
  			            ----------------------------------------------------------------------------------------------------
						IF @n_UPLOAD_BUCKET_TYPE = 'DAILY'
							BEGIN

								INSERT INTO [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ (basis_yyyymmdd,ROWNUM) VALUES (@v_yyyymmdd,1)
								SET @n_bucketcount = 1
						   END
  			            ----------------------------------------------------------------------------------------------------
				       END
		    END

print N'20240605_■■■■■■■■';
print '@n_bucketinsert : '+ convert(char, @n_bucketinsert);
print '@n_bucketcount : '+ convert(char,@n_bucketcount);


            -- BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT (END)

 			--------------------------------------------------------------------------------------------------------------- bucket loop START
			WHILE   @n_bucketinsert <= @n_bucketcount
			BEGIN   
					 -- 변수 초기화
					 BEGIN
							  SET @n_BATCH_RESULT = NULL;
					 END

					-- 대상날짜가 해당 MEASURE 의 BUCKET TYPE 과 동일한지 확인하여 같지않으면 INSERT 처리하지 않으려고함 (START) ----------------------------------------------
					BEGIN
					    SET @v_day_valid = NULL           -- 변수초기화
					    SET @n_VALID_BUCKET_TYPE = NULL   -- 변수초기화

  				        select @v_day_valid = BASIS_YYYYMMDD from [dbo].#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ where rownum = @n_bucketinsert
					END

print '@v_day_valid : ' + convert(char, @v_day_valid);
print '@n_UPLOAD_BUCKET_TYPE : ' + convert(char, @n_UPLOAD_BUCKET_TYPE);

					 -- Convert QTY값 산출
					IF @n_UPLOAD_BUCKET_TYPE = 'DAILY'
						  BEGIN
							SET @n_CALC_QTY = @V_QTY    -- DAILY 인경우는 계산필요없이 INPUT값을 그대로 사용함

							SELECT @n_VALID_BUCKET_TYPE = UPLOAD_BUCKET_TYPE   --  해당주차의 bucket 추출
								FROM   [dbo].DM_MST_CUSTOMER_FCST WITH(NOLOCK)
								WHERE  1 = 1
										AND DIVISION_ID = @v_DIVISION_ID
										AND SCM_SITE_ID = @v_SCM_SITE_ID
										AND MEASURE_GROUP = @v_MEASURE_GROUP
										AND MEASURE = @v_MEASURE
										--AND SUMMARY_BUCKET_VALUE = @v_day_valid -- daily인경우 INPUT된 날짜
                                        AND SUMMARY_BUCKET_VALUE = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@v_day_valid, 'MON')), 112) -- 2024.01.12 Philsu Park 수정.
										AND PLAN_WEEK = @n_PLAN_WEEK
										and VALID_YN = 'Y'  -- 20180409 SongKH Add 

						  END
					ELSE
						SELECT @n_VALID_BUCKET_TYPE = UPLOAD_BUCKET_TYPE   --  해당주차의 bucket 추출
							FROM   [dbo].DM_MST_CUSTOMER_FCST WITH(NOLOCK)
							WHERE  1 = 1
									AND DIVISION_ID = @v_DIVISION_ID
									AND SCM_SITE_ID = @v_SCM_SITE_ID
									AND MEASURE_GROUP = @v_MEASURE_GROUP
									AND MEASURE = @v_MEASURE
									AND SUMMARY_BUCKET_VALUE = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@v_day_valid, 'MON')), 112) -- INPUT된 날짜의 당주 월요일
									AND PLAN_WEEK = @n_PLAN_WEEK
									and VALID_YN = 'Y'  -- 20180409 SongKH Add

print '@n_VALID_BUCKET_TYPE : ' + convert(char,@n_VALID_BUCKET_TYPE);
print '@n_bucketinsert111 : ' + convert(char,@n_bucketinsert);
print '@n_bucketcount111 : ' + convert(char,@n_bucketcount);


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
				    
print '20240605-9991';

					-- 최신 UPLOAD_UOM 값을 변수에 셋팅
					 BEGIN
					   SET @n_UPLOAD_UOM_KEY = @n_UPLOAD_UOM
					 END

					-- BUCKET_TYPE이 다른경우도 input 받은 measure 로 insert 생성하도록 변경 (20180305)
					BEGIN
						IF     @n_UPLOAD_BUCKET_TYPE <> @n_VALID_BUCKET_TYPE
						    SET @n_UPLOAD_UOM_KEY = @n_UPLOAD_UOM  -- 주차별 BUCKET_TYPE 이 달라도 그대로 사용함
					END
					
					-- BUCKET_TYPE이 다른경우도 input 받은 measure 로 insert 생성하도록 변경 (20180305)
					BEGIN
						IF  @n_VALID_BUCKET_TYPE IS NULL
						    SET @n_UPLOAD_UOM_KEY = NULL
					END

					-- MERGE대상 : SPLIT_COMPLETED / SPLIT만 하여 확인하는 MEASURE : UPLOAD_COMPLETED
					BEGIN
						IF  @n_UPLOAD_UOM_KEY IS NULL
						    BEGIN
						      SET @n_BATCH_RESULT = 'UPLOAD_COMPLETED'
							END
					    ELSE
						    BEGIN
						      SET @n_BATCH_RESULT = 'SPLIT_COMPLETED'
							END
					END

print '20240605-9992';
print @n_BATCH_RESULT;

					-- MASTER에 BUCKET 설정이 없는 데이터인경우
					BEGIN
						IF  @n_AUTO_SPLIT_DATA = 'Y'
						    BEGIN
						      SET @n_BATCH_RESULT = 'SPLIT_COMPLETED'
							END
					END

print '@n_BATCH_RESULT : ' + @n_BATCH_RESULT;

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
						,@n_BATCH_RESULT
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

print '20240605-9997';

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
					   ,PROJECT_CODE             =   @n_PROJECT_CODE   -- @n_PROJECT_CODE         -- 추출된값으로 셋팅
					   ,ITEM_ID                  =   @n_ITEM_ID        -- @n_ITEM_ID              -- 추출된값으로 셋팅
					   ,QTY                      =   @v_QTY            -- CONVERT(INT,  CAST(@v_qty AS NVARCHAR(10))) 
					   ,UPLOAD_UOM               =   @v_UPLOAD_UOM     -- INPUT값 UPLOAD_UOM  
					   ,CREATED_BY               =   @v_CREATED_BY           
					   ,CREATION_DATE            =   @v_CREATION_DATE        
					   ,LAST_UPDATED_BY          =   @v_LAST_UPDATED_BY      
					   ,LAST_UPDATE_DATE         =   sysdatetime()     
					   ,BATCH_RESULT             =   @n_BATCH_RESULT   -- 1.'UI':업로드데이터 2.'UPLOAD_COMPLETED':업데이트작업 3.'UPLOAD_UOM_NOT_FOUND':DM_MST_CUSTOMER_FCST 설정날짜에 안맞는 에러건 
					                                                   -- 4.'UPLOAD_COMPLETED':DM_PLN_MKT_FCST로 INSERT완료건  5. 'MERGE_COMPLETED':합산완료건
					   ,MST_UPLOAD_UOM           =   @n_UPLOAD_UOM     -- SCM_MST_ITEM_SN.UPLOAD_UOM 추출값
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

print '20240605-9993';	

		BEGIN
			FETCH NEXT FROM CUR_CAR_RESULT INTO   
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
	-- (WHILE END ) ----------------------------------------------------------------------------------------------------------------




	  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_CAR_RESULT')
		BEGIN
			CLOSE CUR_CAR_RESULT
			DEALLOCATE CUR_CAR_RESULT
		END;

		
			-----input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (start) EEEE
			IF OBJECT_ID('tempdb..#TEMP_MIN_MAX_PSI$', N'U') IS NOT NULL
				BEGIN
					DROP  TABLE dbo.#TEMP_MIN_MAX_PSI$ 
				END
			BEGIN
			  	SELECT YYYYMMDD,row_number() OVER (ORDER BY YYYYMMDD) AS ROWNUM INTO dbo.#TEMP_MIN_MAX_PSI$
					FROM [dbo].[#TEMP3_DM_PLN_CUSTOMER_PSI$] 
					GROUP BY YYYYMMDD  ORDER BY YYYYMMDD 

SELECT 2;

			END;
			BEGIN
			    SELECT @n_MIN_YYYYMMDD = YYYYMMDD FROM dbo.#TEMP_MIN_MAX_PSI$  WHERE ROWNUM = 1

			    SELECT @n_MAX_YYYYMMDD = YYYYMMDD FROM dbo.#TEMP_MIN_MAX_PSI$  WHERE ROWNUM = (SELECT MAX(ROWNUM) FROM dbo.#TEMP_MIN_MAX_PSI$)
			END
		    
			---input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (end)

			---insert 할 실제 데이터의 시작과 끝 구간 산출 ----------------------------------------------- (start) 20180409
			delete from @tmp_site_customer_map -- MEASURE별 cursor 작업이므로 초기화

			insert into  @tmp_site_customer_map
			select a.DIVISION_ID,a.SCM_SITE_ID,a.MEASURE,
   				   a.SUMMARY_BUCKET_VALUE as start_day
				  ,case when summary_bucket_type = 'WEEKLY' THEN CONVERT(CHAR(8), DATEADD(DD, 0, dbo.FN_NEXT_DAY( cast( SUMMARY_BUCKET_VALUE as datetime) , 'SUN')), 112) 
					   else a.SUMMARY_BUCKET_VALUE
					END  end_day
			FROM dbo.DM_MST_CUSTOMER_FCST a
			  inner join 
			  (select DISTINCT DIVISION_ID,SCM_SITE_ID,MEASURE_GROUP  
			  from #TEMP3_DM_PLN_CUSTOMER_PSI$   ) rslt
		  on(
				a.DIVISION_ID   = rslt.DIVISION_ID
			and a.SCM_SITE_ID   = rslt.SCM_SITE_ID
			and a.MEASURE_GROUP = rslt.MEASURE_GROUP 
		   )
			where 1=1
			and VALID_YN = 'Y'
			/* 20240507 KCW3408 수정 */
			and a.PLAN_WEEK = 
					(SELECT MAX(PLAN_WEEK)  
						FROM DM_MST_CUSTOMER_FCST X
			         WHERE X.DIVISION_ID   = A.DIVISION_ID
			           AND X.SCM_SITE_ID   = A.SCM_SITE_ID
			           AND X.MEASURE_GROUP = A.MEASURE_GROUP  
						)
			and a.SUMMARY_BUCKET_VALUE >=  CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 이후데이터만 
			and summary_bucket_type in ('DAILY','WEEKLY')

			UNION

			select a.DIVISION_ID,a.SCM_SITE_ID,a.MEASURE
   				  , case when  SUMMARY_BUCKET_VALUE = convert(varchar(8),  DATEADD(DAY,1,DATEADD(DAY,-DATEPART(DD,getdate()),getdate())) ,112) THEN  CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
						else  SUMMARY_BUCKET_VALUE  end as start_day
				  , CONVERT(CHAR(8),  dateadd(day,-DATEPART(DD, dateadd(month,1,cast( SUMMARY_BUCKET_VALUE as datetime) )), dateadd(month,1,cast( SUMMARY_BUCKET_VALUE as datetime) ))   , 112)   end_day
			FROM dbo.DM_MST_CUSTOMER_FCST a
			  inner join 
			  (select DISTINCT DIVISION_ID,SCM_SITE_ID,MEASURE_GROUP  
			  from #TEMP3_DM_PLN_CUSTOMER_PSI$   ) rslt
		  on(
				a.DIVISION_ID   = rslt.DIVISION_ID
			and a.SCM_SITE_ID   = rslt.SCM_SITE_ID
			and a.MEASURE_GROUP = rslt.MEASURE_GROUP 
		   ) 
			where 1=1
			and VALID_YN = 'Y'
			and a.PLAN_WEEK = 
					(SELECT MAX(PLAN_WEEK)  
						FROM DM_MST_CUSTOMER_FCST X
			         WHERE X.DIVISION_ID   = A.DIVISION_ID
			           AND X.SCM_SITE_ID   = A.SCM_SITE_ID
			           AND X.MEASURE_GROUP = A.MEASURE_GROUP  
						)
			and a.SUMMARY_BUCKET_VALUE >=  convert(varchar(8),  DATEADD(DAY,1,DATEADD(DAY,-DATEPART(DD,getdate()),getdate())) ,112)
			and summary_bucket_type in ('MONTHLY')
--SM
			select '#TEMP3_DM_PLN_CUSTOMER_PSI$ '
			select * from #TEMP3_DM_PLN_CUSTOMER_PSI$ 
			select '@tmp_site_customer_map'
			select * from @tmp_site_customer_map;
			--RETURN;


print '20240605-zzzzzzzzzzzzzzzzzzzzzzzzzz';
			---insert 할 실제 데이터의 시작과 끝 구간 산출 ----------------------------------------------- (end) 20180409

		 -- (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (start)

				BEGIN
					IF @n_UPLOAD_BUCKET_TYPE = 'DAILY'
						BEGIN
							SELECT @n_MAX_YYYYMMDD = BASIS_YYYYMMDD
								FROM   [dbo].[SCM_SYS_CALENDAR_M] T WITH(NOLOCK) 
								WHERE  T.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, 0, @n_MAX_YYYYMMDD), 112)  -- MAX_YYYYMMDD 셋팅
						END
					ELSE IF @n_UPLOAD_BUCKET_TYPE = 'WEEKLY'
						BEGIN
							set @n_MIN_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@n_MIN_YYYYMMDD, 'MON')), 112) -- MIN_YYYYMMDD 셋팅
							SELECT @n_MAX_YYYYMMDD = BASIS_YYYYMMDD
								FROM   [dbo].[SCM_SYS_CALENDAR_M] T WITH(NOLOCK) 
								WHERE  T.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, +6, @n_MAX_YYYYMMDD), 112)  -- MAX_YYYYMMDD 셋팅
						END
					ELSE IF @n_UPLOAD_BUCKET_TYPE = 'MONTHLY'
						BEGIN
							SELECT @n_MAX_YYYYMMDD = BASIS_YYYYMMDD
								FROM   [dbo].[SCM_SYS_CALENDAR_M] T WITH(NOLOCK) 
								WHERE  T.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(CHAR(8), DATEADD(MM, +1, @n_MAX_YYYYMMDD), 112) ), 112)   -- MAX_YYYYMMDD 셋팅
						END
				END;

		 -- (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (end)
print '20240605-zzzzzzzzzzzzzzzzzzzzzzzzzz' + @n_UPLOAD_BUCKET_TYPE ;
print '@n_MIN_YYYYMMDD : ' + @n_MIN_YYYYMMDD;



print '20240605-eeee';

			-- DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT ---------------------------------------------------------------------------------------
			
			/* 2024.05.02    kcw3408       고객수요 N:N Mapping  */ 
			/* 매핑테이블 데이블  INSERT */ 
			BEGIN
				EXEC [dbo].[PR_DM_CUST_ITEM_MAPPING] 'RPA';		
	        END 
			
			/* 대상 추출 */
			BEGIN 
				IF OBJECT_ID (N'tempdb..#TEMP_DM_CUST_ITEM_MAPPING_DTL_N', N'U') IS NOT NULL 
					DROP TABLE #TEMP_DM_CUST_ITEM_MAPPING_DTL_N 
				IF OBJECT_ID(N'dbo.#TEMP_DM_CUST_ITEM_MAPPING_DTL_N', N'U') IS NOT NULL 
					DROP TABLE #TEMP_DM_CUST_ITEM_MAPPING_DTL_N  

					SELECT B.DIVISION_ID
						, B.DATA_TYPE_CODE
						, B.END_CUSTOMER
						, B.SCM_SITE_ID
						, B.PROJECT_CODE
						, B.FCST_TYPE
						, B.INCOTERMS
						, B.DOM_EXP
						, B.ITEM_ID 
						, B.UNLOADING_POINT 
						, B.CUSTOMER_PLANT	
						, B.CUSTOMER_ITEM_ID 
						, B.VALID_START_DATE
						, B.VALID_END_DATE
						, B.MAPPING_ITEM_ID
					INTO #TEMP_DM_CUST_ITEM_MAPPING_DTL_N
					FROM DM_CUST_ITEM_MAPPING_M A WITH(NOLOCK) 
					JOIN DM_CUST_ITEM_MAPPING_DTL_N B WITH(NOLOCK)
						ON A.DIVISION_ID = B.DIVISION_ID 
						AND A.DATA_TYPE_CODE = B.DATA_TYPE_CODE 
						AND A.END_CUSTOMER = B.END_CUSTOMER 
						AND A.SCM_SITE_ID = B.SCM_SITE_ID 
						AND A.PROJECT_CODE = B.PROJECT_CODE 
						AND A.FCST_TYPE = B.FCST_TYPE 
						AND A.INCOTERMS = B.INCOTERMS 
						AND A.DOM_EXP = B.DOM_EXP 
						AND A.ITEM_ID = B.ITEM_ID 
						AND A.UNLOADING_POINT = B.UNLOADING_POINT 
						AND RTRIM(LTRIM(A.CUSTOMER_PLANT)) = RTRIM(LTRIM(B.CUSTOMER_PLANT)) 
						AND RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)) = RTRIM(LTRIM(B.CUSTOMER_ITEM_ID))  
					WHERE A.ACTIVE_YN = 'Y'  
					AND A.DATA_TYPE_CODE IN ('RPA','EXCEL') 
			END 


			-- DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT 전 임시테이블에 모두 저장 
		  BEGIN
		    INSERT  INTO  [dbo].[#TEMP2_DM_PLN_CUSTOMER_PSI$]
			SELECT DISTINCT
  				 A.DIVISION_ID,A.CUSTOMER_PROJECT_CODE,A.CUSTOMER_MODEL,A.SCM_SITE_ID,A.DOM_EXP,A.FCST_TYPE,A.MEASURE_GROUP
			    ,@v_MEASURE    -- 20180227변경사항 measure를 기존값으로 그대로 사용함
				,A.YYYYMMDD,A.INCOTERMS,A.PLANT_SITE_ID,A.PROJECT_CODE,B.MAPPING_ITEM_ID AS ITEM_ID,QTY,A.UPLOAD_UOM,A.CREATED_BY,A.CREATION_DATE
				,A.LAST_UPDATED_BY,A.LAST_UPDATE_DATE,A.BATCH_RESULT,A.MST_UPLOAD_UOM,A.MST_UPLOAD_BUCKET_TYPE,A.MST_SUMMARY_BUCKET_TYPE
				,A.MST_CONVERT_QTY,A.PLAN_WEEK,SPLIT_RESULT,A.ATTRIBUTE1,A.ATTRIBUTE2,A.ATTRIBUTE3,A.ATTRIBUTE4,A.ATTRIBUTE5,A.ATTRIBUTE6
				,A.ATTRIBUTE7,A.ATTRIBUTE8,A.ATTRIBUTE9,A.ATTRIBUTE10
			FROM [dbo].[#TEMP3_DM_PLN_CUSTOMER_PSI$]  A
			/* 
				2024.05.02    kcw3408       고객수요 N:N Mapping 
				전체 대생 추출후 N:N Model Mapping 작업
				.집계 시점에 Cust Item/Unloading Point/Plant 반영
				.Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음  
			*/			
			JOIN #TEMP_DM_CUST_ITEM_MAPPING_DTL_N B WITH (NOLOCK)
				 ON A.DIVISION_ID = B.DIVISION_ID  
				AND A.SCM_SITE_ID = B.SCM_SITE_ID 
				AND A.PROJECT_CODE = B.PROJECT_CODE 
				AND A.FCST_TYPE = B.FCST_TYPE 
				AND A.INCOTERMS = B.INCOTERMS 
				AND A.DOM_EXP = B.DOM_EXP 
				AND A.ITEM_ID = B.ITEM_ID  
				AND A.YYYYMMDD >= B.VALID_START_DATE
				AND A.YYYYMMDD <= B.VALID_END_DATE
				AND ISNULL(B.MAPPING_ITEM_ID,'') > ''
				AND CASE WHEN A.CREATED_BY LIKE '%robot' 
				        THEN 'RPA'
					    ELSE 'EXCEL' 
				   END = B.DATA_TYPE_CODE
			  where @n_MIN_YYYYMMDD <= YYYYMMDD 
			  AND @n_MAX_YYYYMMDD >= YYYYMMDD
			  ;
			  --select '@tmp_site_customer_map'
			  --select * from @tmp_site_customer_map
			  --select '#TEMP3_DM_PLN_CUSTOMER_PSI$'
			  --select * from #TEMP3_DM_PLN_CUSTOMER_PSI$
			  --select '[#TEMP2_DM_PLN_CUSTOMER_PSI$]'
			  --select * from [#TEMP2_DM_PLN_CUSTOMER_PSI$]

		  END
		  ;
			-- DM_PLN_CUSTOMER_PSI delete count 확인 ------------------------------------------------------------------------------------


			-- DM_PLN_CUSTOMER_PSI insert count 확인 ----------------------------------------------------------------------------------------
		    BEGIN
				SET @n_psi_insert_count = @n_psi_insert_count + 
				 (SELECT 
				     COUNT(*) as count
					 --row_number() OVER (ORDER BY DIVISION_ID DESC) AS rownum 
				  FROM [dbo].[#TEMP2_DM_PLN_CUSTOMER_PSI$]  
				  )
			END

            -- DM_PLN_CUSTOMER_PSI test222222 ----------------------------------------------------------------------------------------
		    BEGIN
				SET @n_TEST_VAL = -- @n_psi_insert_count + 
				 (SELECT 
				     COUNT(*)
					 --row_number() OVER (ORDER BY DIVISION_ID DESC) AS rownum 
				  FROM 
                        (select  DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, YYYYMMDD
                        FROM [dbo].[#TEMP2_DM_PLN_CUSTOMER_PSI$]  
                        where 1=1
                        --AND YYYYMMDD = '20240205'
                        GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, YYYYMMDD
                        ) MM
				  )
			END

		 --(11)
		 /*-------------------- DM_PLN_MKT_FCST 테이블 delete count 확인 --------------------*/
		    BEGIN
				SET @n_fcst_delete_count = --@n_fcst_delete_count + 
				 (SELECT 
				     COUNT(*) as count
					FROM  [dbo].DM_PLN_MKT_FCST A WITH(NOLOCK)
				WHERE 1=1
					AND EXISTS (SELECT 1
					    FROM   [dbo].[#TEMP2_DM_PLN_CUSTOMER_PSI$] B 
						 where  A.DIVISION_ID               =   B.DIVISION_ID
						   AND  A.SCM_SITE_ID               =   B.SCM_SITE_ID
						   AND  A.PROJECT_CODE              =   B.PROJECT_CODE
						   AND  A.ITEM_ID			    	=   B.ITEM_ID
						   AND  A.DOM_EXP					=   B.DOM_EXP
						   AND  A.FCST_TYPE					=   B.FCST_TYPE
						   AND  A.INCOTERMS				    =   B.INCOTERMS
						   AND  A.PLANT_SITE_ID				=   B.PLANT_SITE_ID
						   AND  A.MEASURE                   =   B.MEASURE
						   -- AND  B.BATCH_RESULT = 'UPLOAD_COMPLETED'
							AND A.YYYYMMDD >= @n_MIN_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간  --20180409 modify
							AND A.YYYYMMDD <= @n_MAX_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간  --20180409 modify
				  )
				  )

			END


		 /*-------------------- DM_PLN_MKT_FCST 테이블 insert전 데이터 중복제거 --------------------*/
           BEGIN 
          
		   DELETE 
           FROM dbo.DM_PLN_MKT_FCST 
           WHERE exists (
                    SELECT 1
					  FROM dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$ B 
 					  WHERE 1=1
					   and  DM_PLN_MKT_FCST.DIVISION_ID        =  B.DIVISION_ID
					   and  DM_PLN_MKT_FCST.SCM_SITE_ID        =  B.SCM_SITE_ID                         
					   and  DM_PLN_MKT_FCST.PROJECT_CODE       =  B.PROJECT_CODE                         
					   and  DM_PLN_MKT_FCST.ITEM_ID            =  B.ITEM_ID                         
					   and  DM_PLN_MKT_FCST.DOM_EXP            =  B.DOM_EXP                         
					   and  DM_PLN_MKT_FCST.FCST_TYPE          =  B.FCST_TYPE                         
					   and  DM_PLN_MKT_FCST.INCOTERMS          =  B.INCOTERMS                         
					   and  DM_PLN_MKT_FCST.PLANT_SITE_ID      =  B.PLANT_SITE_ID                         
					   and  DM_PLN_MKT_FCST.MEASURE            =  B.MEASURE                         
						AND DM_PLN_MKT_FCST.YYYYMMDD >= @n_MIN_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간
						AND DM_PLN_MKT_FCST.YYYYMMDD <= @n_MAX_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간
				  ) 
           END

--select * from [#TEMP3_DM_PLN_CUSTOMER_PSI$];
           
PRINT 'Test99 cnt: '
PRINT @@TRANCOUNT
PRINT @n_TEST_VAL
PRINT @n_fcst_delete_count
PRINT 'Test99 ' + @n_MAX_YYYYMMDD

		 /*-------------------------------------------------------------------------------------*/
		    BEGIN
				INSERT  INTO  dbo.DM_PLN_MKT_FCST
                (DIVISION_ID
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
						,'UPLOAD_COMPLETED',MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE
					    ,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM [dbo].#TEMP2_DM_PLN_CUSTOMER_PSI$  
 				  WHERE 1=1
		 		--    AND BATCH_RESULT = 'UPLOAD_COMPLETED'  -- modified by ytchoi 180305
				-- added by ytchoi 180305
				AND YYYYMMDD >= @n_MIN_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간
				AND YYYYMMDD <= @n_MAX_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간
			END

PRINT 'Test100 '
		 /*-------------------- DM_PLN_MKT_FCST 테이블 MERGE  --------------------*/


		 delete from dbo.DM_PLN_MKT_FCST 
		 where (
		            select count(1)
					  from dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$ b
                     where  DM_PLN_MKT_FCST.DIVISION_ID        =  B.DIVISION_ID
					   and  DM_PLN_MKT_FCST.SCM_SITE_ID        =  B.SCM_SITE_ID                         
					   and  DM_PLN_MKT_FCST.PROJECT_CODE       =  B.PROJECT_CODE                         
					   and  DM_PLN_MKT_FCST.ITEM_ID            =  B.ITEM_ID                         
					   and  DM_PLN_MKT_FCST.DOM_EXP            =  B.DOM_EXP                         
					   and  DM_PLN_MKT_FCST.FCST_TYPE          =  B.FCST_TYPE                         
					   and  DM_PLN_MKT_FCST.INCOTERMS          =  B.INCOTERMS                         
					   and  DM_PLN_MKT_FCST.PLANT_SITE_ID      =  B.PLANT_SITE_ID                         
		 			--	AND B.BATCH_RESULT = 'SPLIT_COMPLETED' -- modified by ytchoi 180305
						AND DM_PLN_MKT_FCST.MEASURE = 'CUST_FCST'
						-- (20230912 : CUST_FCST MEASURE 삭제시 당주(월) 이전 데이터는 삭제 안되도록 수정)
					   AND DM_PLN_MKT_FCST.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		       ) > 0
          ;


		  	insert into DM_PLN_MKT_FCST
			select   a.DIVISION_ID
					 ,a.PROJECT_CODE
					 ,a.SCM_SITE_ID
					 ,a.ITEM_ID
					 ,a.DOM_EXP
					 ,a.FCST_TYPE
					 ,a.INCOTERMS
					 ,'CUST_FCST'
					 ,a.PLANT_SITE_ID
					 ,a.YYYYMMDD
					 ,a.QTY
					 ,a.CREATED_BY
					 ,a.CREATION_DATE
					 ,a.LAST_UPDATED_BY
					 ,a.LAST_UPDATE_DATE
					 ,a.ATTRIBUTE1
					 ,a.ATTRIBUTE2
					 ,a.ATTRIBUTE3
					 ,a.ATTRIBUTE4
					 ,a.ATTRIBUTE5
					 ,a.ATTRIBUTE6
					 ,a.ATTRIBUTE7
					 ,a.ATTRIBUTE8
					 ,a.ATTRIBUTE9
					 ,a.ATTRIBUTE10
			  from dbo.DM_PLN_MKT_FCST a WITH(NOLOCK)
				  inner join 
				  (select distinct DIVISION_ID,SCM_SITE_ID,ITEM_ID,incoterms, PLANT_SITE_ID, PROJECT_CODE,DOM_EXP,FCST_TYPE
				  from dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$ v  ) rslt
			  on(
					a.DIVISION_ID   = rslt.DIVISION_ID
				and a.SCM_SITE_ID   = rslt.SCM_SITE_ID
			--	and a.MEASURE       = rslt.MEASURE
				and a.ITEM_ID       = rslt.ITEM_ID
				and a.incoterms     = rslt.incoterms
				and a.PLANT_SITE_ID  = rslt.PLANT_SITE_ID
				and a.PROJECT_CODE   = rslt.PROJECT_CODE
				and a.DOM_EXP        = rslt.DOM_EXP
				and a.FCST_TYPE      = rslt.FCST_TYPE
			--	and a.yyyymmdd      = rslt.v_yyyymmdd
			   )
				  inner join 
				  (select DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day  
				  from @tmp_site_customer_map group by DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day) map

			  on(
					a.DIVISION_ID   = map.DIVISION_ID 
				and a.SCM_SITE_ID   = map.SCM_SITE_ID
				and a.MEASURE       = map.MEASURE
			   )
				where 1=1
				and a.YYYYMMDD between map.start_day and map.end_day
				and a.YYYYMMDD >=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
PRINT 'Test0001 '

		 /*
           BEGIN 
          
		   DELETE 
           FROM dbo.DM_PLN_MKT_FCST 
           WHERE (
                    SELECT count(1) 
					  FROM dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$ B 
					       -- added by ytchoi 180305 measure 별 start와 end 일자 구하기
					      ,(
							select a.scm_site_id, a.measure,    min(summary_bucket_value)  MIN_DATE
								 , CASE WHEN SUMMARY_BUCKET_TYPE = 'WEEKLY' THEN   convert( varchar, dateadd( DD, 6 ,cast( max(summary_bucket_value) as datetime ) ), 112)
										WHEN SUMMARY_BUCKET_TYPE = 'MONTHLY' THEN convert( varchar, DATEADD(day, -1,DATEADD(MONTH, 1,DATENAME(YEAR,cast( max(summary_bucket_value) as datetime )) + DATENAME(month,cast( max(summary_bucket_value) as datetime ))+'01')) , 112)
										ELSE max(summary_bucket_value) END MAX_DATE
							  from DM_MST_CUSTOMER_FCST a
								  ,(
								   select max(plan_week) pw
									 from DM_MST_CUSTOMER_FCST
								   ) b
							 where a.plan_week = b.pw
							   and a.measure_group = 'CUST_FCST'
							group by a.scm_site_id, a.measure, SUMMARY_BUCKET_TYPE
						   ) PERIOD
                --------------------------------------------------------------------- 20180409 add
					inner join 
					(select DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day  
					from @tmp_site_customer_map group by DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day) map

				on(
					b.DIVISION_ID   = map.DIVISION_ID 
				and b.SCM_SITE_ID   = map.SCM_SITE_ID
				and b.MEASURE       = map.MEASURE
				)
				where 1=1
				and b.YYYYMMDD between map.start_day and map.end_day
				and b.YYYYMMDD >=  CONVERT(CHAR(8), DATEADD(DD, 0, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
                --------------------------------------------------------------------- 20180409 add
					   and  DM_PLN_MKT_FCST.DIVISION_ID        =  B.DIVISION_ID
					   and  DM_PLN_MKT_FCST.SCM_SITE_ID        =  B.SCM_SITE_ID                         
					   and  DM_PLN_MKT_FCST.PROJECT_CODE       =  B.PROJECT_CODE                         
					   and  DM_PLN_MKT_FCST.ITEM_ID            =  B.ITEM_ID                         
					   and  DM_PLN_MKT_FCST.DOM_EXP            =  B.DOM_EXP                         
					   and  DM_PLN_MKT_FCST.FCST_TYPE          =  B.FCST_TYPE                         
					   and  DM_PLN_MKT_FCST.INCOTERMS          =  B.INCOTERMS                         
					   and  DM_PLN_MKT_FCST.PLANT_SITE_ID      =  B.PLANT_SITE_ID                         
		 			--	AND B.BATCH_RESULT = 'SPLIT_COMPLETED' -- modified by ytchoi 180305
						AND DM_PLN_MKT_FCST.MEASURE = 'CUST_FCST'
						--AND DM_PLN_MKT_FCST.YYYYMMDD >= @n_MIN_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간
						--AND DM_PLN_MKT_FCST.YYYYMMDD <= @n_MAX_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간

						-- added by ytchoi 180305 upload 한 기간에도 속하고 
						AND B.SCM_SITE_ID             = PERIOD.SCM_SITE_ID
						AND B.measure                 = PERIOD.MEASURE
						and DM_PLN_MKT_FCST.YYYYMMDD between PERIOD.MIN_DATE and PERIOD.MAX_DATE
				  ) > 0
           END


		    BEGIN
				INSERT  INTO  dbo.DM_PLN_MKT_FCST
				SELECT distinct
  					     DIVISION_ID
						,PROJECT_CODE
						,a.SCM_SITE_ID
						,ITEM_ID
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,'CUST_FCST' AS MEASURE
						,PLANT_SITE_ID
						,YYYYMMDD
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,sysdatetime()
						,'MERGE_COMPLETED',MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE
					    ,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM [dbo].#TEMP2_DM_PLN_CUSTOMER_PSI$  a  
				     -- added by ytchoi 180305 measure 별 start와 end 일자 구하기
				    ,(
							select a.scm_site_id, a.measure,    min(summary_bucket_value)  MIN_DATE
								 , CASE WHEN SUMMARY_BUCKET_TYPE = 'WEEKLY' THEN   convert( varchar, dateadd( DD, 6 ,cast( max(summary_bucket_value) as datetime ) ), 112)
										WHEN SUMMARY_BUCKET_TYPE = 'MONTHLY' THEN convert( varchar, DATEADD(day, -1,DATEADD(MONTH, 1,DATENAME(YEAR,cast( max(summary_bucket_value) as datetime )) + DATENAME(month,cast( max(summary_bucket_value) as datetime ))+'01')) , 112)
										ELSE max(summary_bucket_value) END MAX_DATE
							  from DM_MST_CUSTOMER_FCST a
								  ,(
								   select max(plan_week) pw
									 from DM_MST_CUSTOMER_FCST
								   ) b
							 where a.plan_week = b.pw
							   and a.measure_group = 'CUST_FCST'
							group by a.scm_site_id, a.measure, SUMMARY_BUCKET_TYPE
						   ) PERIOD
                --------------------------------------------------------------------- 20180409 add
					inner join 
					(select DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day  
					from @tmp_site_customer_map group by DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day) map

				on(
					a.DIVISION_ID   = map.DIVISION_ID 
				and a.SCM_SITE_ID   = map.SCM_SITE_ID
				and a.MEASURE       = map.MEASURE
				)
				where 1=1
				and a.YYYYMMDD between map.start_day and map.end_day
				and a.YYYYMMDD >=  CONVERT(CHAR(8), DATEADD(DD, 0, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
                --------------------------------------------------------------------- 20180409 add
		 		 AND BATCH_RESULT = 'SPLIT_COMPLETED' 
						-- added by ytchoi 180305 upload 한 기간에도 속하고 
						AND A.SCM_SITE_ID             = PERIOD.SCM_SITE_ID
						AND A.measure                 = PERIOD.MEASURE
						--and a.YYYYMMDD between PERIOD.MIN_DATE and PERIOD.MAX_DATE


			END
*/
		    BEGIN
				SET @n_fcst_insert_count = @n_fcst_insert_count + 
				 (SELECT 
				     COUNT(*) as count
					 --row_number() OVER (ORDER BY DIVISION_ID DESC) AS rownum 
				  FROM [dbo].#TEMP2_DM_PLN_CUSTOMER_PSI$  
 				  WHERE 1=1
		 		    AND BATCH_RESULT = 'SPLIT_COMPLETED' 
				  )
			END

		 --  GROUP 로딩 COUNT 증가
		 BEGIN
		   SET @n_PSI_GROUP_INSERT = @n_PSI_GROUP_INSERT + 1
		 END

		  -- GROUP별로 작업종료후 Temp Table TRUNCATE
		 IF @n_PSI_GROUP_INSERT <= @n_PSI_GROUP_CNT
			 BEGIN

			   -- GROUP별로 작업종료후 Temp Table TRUNCATE
			   TRUNCATE TABLE dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$
			   TRUNCATE TABLE dbo.#TEMP3_DM_PLN_CUSTOMER_PSI$
			 END

   END

 	--------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP END
    --#############################################################################################################
 	--------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP END
    --    IF @@TRANCOUNT > 0
          COMMIT WORK;
		  --END
		
		END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	  -- 트랜잭션 (END)
	  ROLLBACK TRANSACTION CUST_FCST_TO_MKT_FCST;
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  set @v_description = '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러로그 --*/
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------

		BEGIN
		--임시테이블 삭제 ------------------------------------------------------------- (start)
  		IF OBJECT_ID('tempdb..#TEMP_DM_PLN_CUSTOMER_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP_DM_PLN_CUSTOMER_PSI$ ;
  		IF OBJECT_ID('tempdb..#TEMP_PSI_GROUP_COUNT$') IS NOT NULL DROP TABLE dbo.#TEMP_PSI_GROUP_COUNT$ ;
  		IF OBJECT_ID('tempdb..#TEMP3_DM_PLN_CUSTOMER_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP3_DM_PLN_CUSTOMER_PSI$ ;
  		IF OBJECT_ID('tempdb..#TEMP2_DM_PLN_CUSTOMER_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP2_DM_PLN_CUSTOMER_PSI$ ;
  		IF OBJECT_ID('tempdb..#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP_CALENDAR_DM_PLN_CUSTOMER_PSI$ ;
  		IF OBJECT_ID('tempdb..#TEMP_MIN_MAX_PSI$') IS NOT NULL DROP TABLE dbo.#TEMP_MIN_MAX_PSI$ ;
		--임시테이블 삭제 ------------------------------------------------------------- (END)
		END

	-- 수행결과 성공여부 DISPLAY
   --  IF @v_log_message IS NULL
	  --SELECT 'success'	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'psi_update_count= ' + Convert(NVARCHAR(10), @n_psi_update_count) +  ' / psi_delete_count= ' + Convert(NVARCHAR(10), @n_psi_delete_count)
	                      +  ' / psi_insert_count= ' + Convert(NVARCHAR(10), @n_psi_insert_count) +  ' / fcst_delete_count= ' + Convert(NVARCHAR(10), @n_fcst_delete_count) 
						  +  ' / fcst_insert_count= ' + Convert(NVARCHAR(10), @n_fcst_insert_count)
						  --+ '
	;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	ERR_RTN:
	IF @v_log_type = 'INVALID'
	  BEGIN
	     ROLLBACK TRANSACTION CUST_FCST_TO_MKT_FCST
         EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  END

  --END;
