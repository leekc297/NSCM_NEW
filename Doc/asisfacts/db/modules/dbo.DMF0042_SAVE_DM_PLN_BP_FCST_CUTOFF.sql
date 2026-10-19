/*
EXEC DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF_TOBE
*/

/*
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF
 * Description  : Business Plan DM_PLN_BP_FCST_C TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190410 KHSONG Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190617 KHSONG DM_BP_EXCHANGE_RATE => DM_BP_EXCHANGE_RATE_C (6/11 추가)
 * 2020/04/23	P.C.I    [PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/07/26	SJHAN	중장기계획 과제 관련 - SEQ 추가
 * 2022/04/12	rosia27		[과제PJ20216891R]GM_JV
 * 2022/06/10	rosia27		[C20220526-000090]Business Plan Waterfall 개발 요청의 건
 * 2022/06/21	rosia27		[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 */

CREATE PROCEDURE [dbo].[DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF]

    -- Add the parameters for the stored procedure here
      @p_division_id          NVARCHAR(30)    -- division_id 전달받음
    , @p_version_description  NVARCHAR(MAX)  -- description 전달받음
    , @p_ver_type             NVARCHAR(MAX)
    , @p_created_by           NVARCHAR(MAX)
AS

BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

    DECLARE @n_history_seq      INTEGER;
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF';
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

    -- 시작 LOG  (START)
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)
    BEGIN TRANSACTION SAVE_DM_PLN_BP_FCST_CUTOFF;

    --------------------------------------------------------------------------------------------
    BEGIN TRY
    --------------------------------------------------------------------------------------------
        SET @v_ver_description  = @p_version_description;
        SET @v_ver_type         = 'BP_M';
        SET @v_created_by       = @p_created_by;

        SET @v_division_id = @p_division_id;

        EXEC    [dbo].[PR_DM_PLN_VERSION_CREATE]
                @v_division_id,
                @v_ver_description,
                @v_ver_type,
                @v_created_by,
                @v_ver_return_no  OUTPUT,
                @v_OK_description OUTPUT

        -- [DM_PLN_BP_FCST] -> [DM_PLN_BP_FCST_C]
		DECLARE @n_Seq_No    INTEGER = 0;
		SELECT @n_Seq_No = MAX(ISNULL(SEQ_NO,0)) + 1 FROM DM_PLN_BP_FCST_C A WITH (NOLOCK)
        BEGIN

            INSERT INTO [dbo].DM_PLN_BP_FCST_C
                 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                 , PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
                 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
				 , PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
                 , YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY --[PJ20200138] item_use, unit_energy 추가
				 , QTY, CELL_PER_PACK
                 , CELL_PER_MODULE, MODULE_PER_PACK, CREATED_BY, CREATION_DATE
                 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
                 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
                 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, SEQ_NO, CELL_PROD_SITE )
            SELECT A.DIVISION_ID, @v_ver_return_no AS VERSION_NO, @v_ver_type AS CUTOFF_TYPE, @v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
                 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                 , A.PLANT_SITE_ID, A.DEPT_ID, A.END_CUSTOMER, A.BIZ_TYPE
                 , A.YYYYMM, A.CURRENCY, ITEM_USE, UNIT_ENERGY --[PJ20200138] item_use, unit_energy 추가
				 , A.QTY, A.CELL_PER_PACK
                 , A.CELL_PER_MODULE, A.MODULE_PER_PACK, A.CREATED_BY, A.CREATION_DATE
                 , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2
                 , A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
                 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
				 , ROW_NUMBER() OVER(ORDER BY DIVISION_ID)	-- 2021/07/26 SJHAN 중장기계획 과제 관련 - SEQ 추가
				 , CELL_PROD_SITE  -- 2022/06/02 [C20220513-000327]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
              FROM DM_PLN_BP_FCST A WITH (NOLOCK)
             WHERE 1 = 1
               AND A.DIVISION_ID = @v_division_id
            ;
        END

        /* 20190617 CUTOFF DATA INSERT (BEGIN) */
        BEGIN
            -- insert 작업
            INSERT INTO [dbo].DM_BP_EXCHANGE_RATE_C
                 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                 , YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                 , ATTRIBUTE9, ATTRIBUTE10 )
            -- DM_PLN_BP_FCST_C 테이블에 생성된 동일한 version no 를 저장
            SELECT @p_division_id, @v_ver_return_no AS VERSION_NO, @v_ver_type AS CUTOFF_TYPE, @v_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
                 , YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
                 , CREATED_BY, CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE()
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
                 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                 , ATTRIBUTE9, ATTRIBUTE10
              FROM [dbo].DM_BP_EXCHANGE_RATE WITH(NOLOCK)
             WHERE DIVISION_ID = @p_division_id
            ;
        END

        /* CUTOFF DATA INSERT END) */

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
        ROLLBACK TRANSACTION SAVE_DM_PLN_BP_FCST_CUTOFF;

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
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END;
