/*
 * Program ID   : DMF0051_1_BIZPLAN_CUTOFF
 * Description  : BIZPLAN 데이터 생성
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.08.19	chano0612		Initial Release 
 * 2023.09.23	chano0612		사업계획3차 수정[VERSION_NO, VERSION_DESCRIPTION 변경]
 * 2023.09.23	chano0612		사업계획3차 수정[ATTRIBUTE 컬럼 추가]
 * 2024.03.18	kjj				화면에서 BP 컷오프 수행
 **************************************************************************************************
 */
 
-- EXEC DMF0051_1_BIZPLAN_CUTOFF '81', '2024'
-- EXEC DMF0051_1_BIZPLAN_CUTOFF '81_UC', '2024'
-- EXEC DMF0051_1_BIZPLAN_CUTOFF '81_HM', '2024'
-- EXEC DMF0051_1_BIZPLAN_CUTOFF '82', '2024'
-- EXEC DMF0051_1_BIZPLAN_CUTOFF '40', '2024'

CREATE PROCEDURE [dbo].[DMF0051_1_BIZPLAN_CUTOFF]
     @p_division_id     NVARCHAR(30)
	 ,@P_BPYEAR			NVARCHAR(4)--2024.03.18	kjj  
	 --,@P_CUTOFF_YEAR	NVARCHAR(4)--2024.03.18	kjj  
	 ,@P_DESC			NVARCHAR(MAX)--2024.03.18	kjj
	 ,@P_USER_ID		NVARCHAR(30) --2024.03.18	kjj
	 ,@P_FCST_VER		NVARCHAR(50)  
	 ,@P_RTF_VER		NVARCHAR(50) 

AS

BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @p_version_description NVARCHAR(100)
	DECLARE @p_created_by NVARCHAR(100)

	--DECLARE @n_YYYY NVARCHAR(5)
	--DECLARE @n_WEEK NVARCHAR(5)
	
	--SET @n_YYYY = SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 1, 4)
	--SET @n_YYYY = @p_yyyy
	--SELECT @n_WEEK = WEEK_NAME FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112)


	-----사업계획3차 수정[VERSION_NO, VERSION_DESCRIPTION 변경] [START]
	--SET @p_version_description = N'24년BP_SCM(DM)_' + @n_YYYY + '_' + @n_WEEK --N'24년BP_SCM(DM)'
	SET @p_version_description = @P_DESC --2024.03.18	kjj
	-----사업계획3차 수정[VERSION_NO, VERSION_DESCRIPTION 변경] [END]
	--SET @p_created_by = 'SYSTEM'
	SET @p_created_by = @P_USER_ID --2024.03.18	kjj

    DECLARE @n_history_seq      INTEGER;
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0051_1_BIZPLAN_CUTOFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    --
    DECLARE @v_division_id          NVARCHAR(MAX);
    DECLARE @v_ver_description      NVARCHAR(MAX);
    DECLARE @v_ver_type             NVARCHAR(MAX);
    DECLARE @v_created_by           NVARCHAR(MAX);

    DECLARE @v_ver_return_no        NVARCHAR(100);  -- cut off Generated Number
    DECLARE @v_cutoff_yyyymmdd      NVARCHAR(MAX);
    DECLARE @v_OK_description       NVARCHAR(1200); -- cut off Generated Number

    SET @v_division_id       = NULL;
    SET @v_ver_description   = NULL;
    SET @v_ver_type          = NULL;
    SET @v_created_by        = NULL;
    SET @v_cutoff_yyyymmdd   = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112);

    SET @v_ver_description  = @p_version_description;
    SET @v_ver_type         = 'BP_DM';
    SET @v_created_by       = @P_USER_ID;

    SET @v_division_id = @p_division_id;

				
    EXEC    [dbo].[DMF0051_1_GET_DM_VERSION]
            @v_division_id,
            @v_ver_description,
            @v_ver_type,
            @v_created_by,
			@P_BPYEAR,
			--@P_CUTOFF_YEAR,
			@P_FCST_VER,
			@P_RTF_VER,
            @v_ver_return_no  OUTPUT,
            @v_OK_description OUTPUT
		
    -- 시작 LOG  (START)
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @v_division_id + ':' + @v_ver_return_no;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)
    BEGIN TRANSACTION SAVE_DM_PLN_BIZPLAN_CUTOFF;

    --------------------------------------------------------------------------------------------
    BEGIN TRY
    --------------------------------------------------------------------------------------------
--PRINT 'STEP1==============================================================================================================================================================='
        -- [DM_PLN_BIZPLAN] -> [DM_PLN_BIZPLAN_C]
		DECLARE @n_Seq_No    INTEGER = 0;
		SELECT @n_Seq_No = MAX(ISNULL(SEQ_NO,0)) + 1 FROM DM_PLN_BP_FCST_C A WITH (NOLOCK)
        BEGIN
--PRINT 'STEP2==============================================================================================================================================================='


            INSERT INTO [dbo].DM_PLN_BIZPLAN_C
                 ( DIVISION_ID,VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				  ,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
				  ,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK,CELL_PROD_SITE, PRODUCT_GROUP
				  , EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE, METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
				  --사업계획3차 수정[ATTRIBUTE 컬럼 추가] [START]
				  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				  --사업계획3차 수정[ATTRIBUTE 컬럼 추가] [END]
				  ,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				  ,SEQ)
            SELECT A.DIVISION_ID, @v_ver_return_no AS VERSION_NO, @v_ver_type AS CUTOFF_TYPE, @v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                  ,A.DEPT_ID,A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
				  ,A.ITEM_USE,UNIT_ENERGY,A.CURRENCY,A.MEASURE,A.YYYYMM,A.QTY,A.CELL_CODE, A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,A.CELL_PROD_SITE, A.PRODUCT_GROUP
				  , A.EE_CORP_ID, A.CELL_CORP_ID, A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM, A.SCENARIO_TYPE, A.BASE_PRICE, A.METAL_LINK_PRICE, A.OTHER_PRICE, A.TOTAL_PRICE, A.METAL_LINK_YN, A.WORK_YYYYMMDD, A.OSP_YN, A.EXT_INT
				  --사업계획3차 수정[ATTRIBUTE 컬럼 추가] [START]
				  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				  --사업계획3차 수정[ATTRIBUTE 컬럼 추가] [END]
				  ,A.CREATED_BY, GETDATE(), LAST_UPDATED_BY, GETDATE()
				 , SEQ
              FROM DM_PLN_BIZPLAN A WITH (NOLOCK)
             WHERE 1 = 1
               AND A.DIVISION_ID = @v_division_id

            SET @n_log_count = @@ROWCOUNT;
        END

--PRINT 'STEP3==============================================================================================================================================================='

		IF OBJECT_ID (N'tempdb..#TMP_RTF', N'U') IS NOT NULL 		DROP TABLE #TMP_RTF
		IF OBJECT_ID (N'tempdb..#SCP_TEMP', N'U') IS NOT NULL 		DROP TABLE #SCP_TEMP

	BEGIN

--PRINT 'STEP4==============================================================================================================================================================='

            INSERT INTO [dbo].DM_PLN_BIZPLAN_C
                 ( DIVISION_ID,VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				  ,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
				  ,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK,CELL_PROD_SITE, PRODUCT_GROUP
				  , EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE,  BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE, METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
				  --사업계획3차 수정[ATTRIBUTE 컬럼 추가] [START]
				  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				  --사업계획3차 수정[ATTRIBUTE 컬럼 추가] [END]
				  ,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				  ,SEQ)
            SELECT A.DIVISION_ID, @v_ver_return_no AS VERSION_NO, @v_ver_type AS CUTOFF_TYPE, @v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                  ,A.DEPT_ID,A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
				  ,A.ITEM_USE,UNIT_ENERGY,A.CURRENCY,'Business_Plan_Conf' MEASURE,A.YYYYMM,A.QTY,A.CELL_CODE, A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,A.CELL_PROD_SITE, A.PRODUCT_GROUP
				  , A.EE_CORP_ID, A.CELL_CORP_ID, A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM, A.SCENARIO_TYPE,  A.BASE_PRICE, A.METAL_LINK_PRICE, A.OTHER_PRICE, A.TOTAL_PRICE, A.METAL_LINK_YN, A.WORK_YYYYMMDD, A.OSP_YN, A.EXT_INT
				  --사업계획3차 수정[ATTRIBUTE 컬럼 추가] [START]
				  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				  --사업계획3차 수정[ATTRIBUTE 컬럼 추가] [END]
				  ,A.CREATED_BY, GETDATE(), LAST_UPDATED_BY, GETDATE()
				 , SEQ --ROW_NUMBER() OVER(ORDER BY DIVISION_ID) AS SEQ_NO
              FROM DM_PLN_BIZPLAN A WITH (NOLOCK)
             WHERE 1 = 1
               AND A.DIVISION_ID = @v_division_id
			   AND A.MEASURE = 'Business_Plan'

            SET @n_log_count = @n_log_count + @@ROWCOUNT;
		END


PRINT N'ATTRIBUTE 업데이트 ==================================================================================================================================================='
/*
		BEGIN
			UPDATE DM_PLN_BIZPLAN_C SET ATTRIBUTE5 = A.ATTRIBUTE5, ATTRIBUTE6 = A.ATTRIBUTE6, ATTRIBUTE7 = A.ATTRIBUTE7, ATTRIBUTE8 = A.ATTRIBUTE8
			FROM DM_PLN_BIZPLAN A
			WHERE DM_PLN_BIZPLAN_C.DIVISION_ID = A.DIVISION_ID
			AND DM_PLN_BIZPLAN_C.PROJECT_CODE = A.PROJECT_CODE
			AND DM_PLN_BIZPLAN_C.SCM_SITE_ID = A.SCM_SITE_ID
			AND DM_PLN_BIZPLAN_C.ITEM_ID = A.ITEM_ID
			AND DM_PLN_BIZPLAN_C.FCST_TYPE = A.FCST_TYPE
			AND DM_PLN_BIZPLAN_C.DOM_EXP = A.DOM_EXP
			AND DM_PLN_BIZPLAN_C.INCOTERMS = A.INCOTERMS
			AND DM_PLN_BIZPLAN_C.CURRENCY = A.CURRENCY
			AND DM_PLN_BIZPLAN_C.CELL_PROD_SITE = A.CELL_PROD_SITE
			AND DM_PLN_BIZPLAN_C.YYYYMM = A.YYYYMM
			AND DM_PLN_BIZPLAN_C.DIVISION_ID = @v_division_id
			AND DM_PLN_BIZPLAN_C.MEASURE = 'Business_Plan_Conf'
			AND A.MEASURE = 'Business_Plan'
			AND DM_PLN_BIZPLAN_C.VERSION_NO = @v_ver_return_no--'24BP_DM_2023_W40_V002'
		END
*/
SELECT @v_ver_return_no


        -- 트랜잭션 (COMMIT)
        COMMIT WORK;

    --------------------------------------------------------------------------------------------
    END TRY
    --------------------------------------------------------------------------------------------

    --------------------------------------------------------------
    BEGIN CATCH
    --------------------------------------------------------------
        -- ROLLBACK
        -- 트랜잭션 (END)
        ROLLBACK TRANSACTION SAVE_DM_PLN_BIZPLAN_CUTOFF;

        -- ERROR LOG VALUE SAVE
        SET @v_log_type = 'ERROR';
        SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
        SET @d_event_date = SYSDATETIME();

		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

 SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/


    --------------------------------------------------------------
    END CATCH;
    --------------------------------------------------------------

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @v_division_id + ':' + @v_ver_return_no;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END;
