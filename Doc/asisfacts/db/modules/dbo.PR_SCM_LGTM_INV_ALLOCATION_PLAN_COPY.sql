
/*
 * Program ID   : PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY
 * Description  : 장기재고 관련 Long Term Stock MGMT 화면 데이터 생성
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025.03.31                   최초 생성
 * 2025.11.11   park.choyi		[E20250310-000014] 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기')
 ----------------------------------------------------------------------------------------------------
 */

--exec [PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY] 'RMTL','40', '20250203', '202502'
--exec [PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY] 'POLICY','40', '20250203', '202502'


--exec [PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY] 'SPRD','81_ST', '20250331', '202504'
--exec [PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY] 'SPRD','81',	'20250331', '202504'
--exec [PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY] 'SPRD','81_HD', '20250331', '202504'
--exec [PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY] 'SPRD','40',	'20250331', '202504'
--exec [PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY] 'SPRD','81_UC', '20250331', '202504'
--exec [PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY] 'SPRD','81_HM', '20250331', '202504'


CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY]
     @p_plan_tp_cd              NVARCHAR(20)
    ,@p_division_id             NVARCHAR(30)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_basis_yyyymm            NVARCHAR(6)
AS

BEGIN

	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description =  concat(@p_plan_tp_cd, ' : ' , @p_division_id, ' : ' , @p_plan_start_yyyymmdd, ' : ' , @p_basis_yyyymm); 
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  

    ------------------------------------------------------------------------
	-- Parameter 대신 변수 할당
	------------------------------------------------------------------------
    DECLARE @v_plan_tp_cd           NVARCHAR(20)    = @p_plan_tp_cd;            -- 'FERT';
    DECLARE @v_division_id          NVARCHAR(20)    = @p_division_id            -- '82';
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = @p_plan_start_yyyymmdd    -- '20240701';
    DECLARE @v_basis_yyyymm         NVARCHAR(6)     = @p_basis_yyyymm           -- '202407';
	DECLARE @v_chk_plan_start_yyyymmdd  NVARCHAR(8)
    ------------------------------------------------------------------------  

	BEGIN TRANSACTION PSI_ALLOCATION_COPY;
	------------------------------------------------------------------------  
    BEGIN TRY

        ------------------------------------------------------------------------
		-- Step 1. Initialize Data
		------------------------------------------------------------------------
        
		------------------------------------------------------------------------
		-- Step 1-1. Delete PLAN DATA
		------------------------------------------------------------------------   
        BEGIN
            DELETE 
            FROM    SCP_ANL_LGTM_INV_MGMT_PLAN
            WHERE   1=1
            AND     PLAN_TP_CD          = @v_plan_tp_cd
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
            AND     DIVISION_ID         = @v_division_id

			-- 20250714 정책재고 관련 삭제부분 제거
			/*
			DELETE 
            FROM   SCP_ANL_LGTM_PCY_INV_MGMT_PLAN
			WHERE   1=1
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			*/

        END
		------------------------------------------------------------------------   
           
		------------------------------------------------------------------------
		
		SELECT @v_chk_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD) FROM SCP_ANL_LGTM_INV_MGMT_PLAN WHERE  PLAN_START_YYYYMMDD < @v_plan_start_yyyymmdd

        BEGIN
        
        --LONG TERM
		IF @v_plan_tp_cd = 'FERT'
			BEGIN
				INSERT INTO SCP_ANL_LGTM_INV_MGMT_PLAN
				SELECT 
				@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
				, SU.PLAN_TP_CD
				, DATA_TP_CD
				, SRCE_TP_CD
				, SU.DIVISION_ID
				, PLANT_ID
				, SU.ITEM_ID
				, SU.PLAN_YYYYMM
				, QTY
				, OCCR_RSN_CD
				, OCCR_RSN_CTN
				, EXHT_TP_CD
				, EXHT_TP_CTN
				, GETDATE() AS CREATE_DATE
				, 'SYSTEM' AS CREATED_BY
				, GETDATE() AS LAST_UPDATE_DATE
				, 'SYSTEM' AS LAST_UPDATED_BY
				, IMPU_DEPT_NM
				, SU.COMPANY_ID
				FROM SCP_ANL_LGTM_INV_MGMT_PLAN SU
				LEFT JOIN (SELECT DISTINCT PLAN_TP_CD, PLAN_START_YYYYMMDD, DIVISION_ID, ITEM_ID, PLAN_YYYYMM FROM SCM_LGTM_INV_PSI_SUMMARY
							WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							AND DATA_TP_CD      = 'EOH'         
							-- [E20250310-000014] LONG_TERM_TYPE 대신 LONG_TERM_TYPE_CODE로 조건 변경('부실' -> '장기')
							AND LONG_TERM_TYPE_CODE  IN (N'CODE_5',N'CODE_6') --AND LONG_TERM_TYPE  IN (N'부실',N'부실 징후')   
							AND PLAN_TP_CD      = 'FERT_INIT'
							AND DIVISION_ID     = @v_division_id
							AND      EXISTS ( SELECT 'X'
												FROM   SCM_LGTM_INV_PSI_SUMMARY_IGR IGR WITH(NOLOCK)
												WHERE  IGR.PLAN_START_YYYYMMDD  = CASE WHEN DIVISION_ID = '81' THEN PLAN_START_YYYYMMDD ELSE IGR.PLAN_START_YYYYMMDD END
												AND    IGR.PLAN_TP_CD           = 'FERT_INIT_GC'
												AND    IGR.PLAN_YYYYMM          = CASE WHEN DIVISION_ID = '81' THEN PLAN_YYYYMM ELSE IGR.PLAN_YYYYMM END
												-- [E20250310-000014] LONG_TERM_TYPE 대신 LONG_TERM_TYPE_CODE로 조건 변경('부실' -> '장기')
												AND    IGR.LONG_TERM_TYPE_CODE  IN (N'CODE_5',N'CODE_6') --AND    IGR.LONG_TERM_TYPE       IN (N'부실',N'부실 징후')
												AND    IGR.PLAN_START_YYYYMMDD  = CASE WHEN DIVISION_ID = '81' THEN PLAN_START_YYYYMMDD ELSE IGR.PLAN_START_YYYYMMDD END
												AND    IGR.DIVISION_ID          = CASE WHEN DIVISION_ID = '81' THEN DIVISION_ID ELSE IGR.DIVISION_ID END
												AND    IGR.GROUP_CODE1          = CASE WHEN DIVISION_ID = '81' THEN GROUP_CODE1 ELSE IGR.GROUP_CODE1 END
						)       
					) FI
					ON  FI.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
					AND SU.PLAN_TP_CD = FI.PLAN_TP_CD
					AND SU.PLAN_YYYYMM = FI.PLAN_YYYYMM
					AND SU.ITEM_ID = FI.ITEM_ID
					AND SU.DIVISION_ID = FI.DIVISION_ID
				WHERE SU.PLAN_START_YYYYMMDD = @v_chk_plan_start_yyyymmdd
				AND SU.PLAN_YYYYMM >= @v_basis_yyyymm
				--AND ISNULL(QTY, 0) > 0
				AND SU.PLAN_TP_CD = @v_plan_tp_cd
				AND SU.DIVISION_ID = @v_division_id
			END

		IF @v_plan_tp_cd = 'SPRD'
			BEGIN
				INSERT INTO SCP_ANL_LGTM_INV_MGMT_PLAN
				SELECT 
				@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
				, SU.PLAN_TP_CD
				, DATA_TP_CD
				, SRCE_TP_CD
				, SU.DIVISION_ID
				, PLANT_ID
				, SU.ITEM_ID
				, SU.PLAN_YYYYMM
				, QTY
				, OCCR_RSN_CD
				, OCCR_RSN_CTN
				, EXHT_TP_CD
				, EXHT_TP_CTN
				, GETDATE() AS CREATE_DATE
				, 'SYSTEM' AS CREATED_BY
				, GETDATE() AS LAST_UPDATE_DATE
				, 'SYSTEM' AS LAST_UPDATED_BY
				, IMPU_DEPT_NM
				, SU.COMPANY_ID
				FROM SCP_ANL_LGTM_INV_MGMT_PLAN SU
				LEFT JOIN (SELECT DISTINCT PLAN_TP_CD, PLAN_START_YYYYMMDD, DIVISION_ID, ITEM_ID, PLAN_YYYYMM FROM SCM_LGTM_INV_PSI_SUMMARY_SPRD
							WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							AND DATA_TP_CD      = 'EOH'         
							-- [E20250310-000014] LONG_TERM_TYPE 대신 LONG_TERM_TYPE_CODE로 조건 변경('부실' -> '장기')
							AND LONG_TERM_TYPE_CODE  IN (N'CODE_5',N'CODE_6') --AND LONG_TERM_TYPE  IN (N'부실',N'부실 징후')   
							AND PLAN_TP_CD      = 'SPRD_INIT'
							AND DIVISION_ID     = @v_division_id
							AND      EXISTS ( SELECT 'X'
												FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR IGR WITH(NOLOCK)
												WHERE  IGR.PLAN_START_YYYYMMDD  = CASE WHEN DIVISION_ID = '81' THEN PLAN_START_YYYYMMDD ELSE IGR.PLAN_START_YYYYMMDD END
												AND    IGR.PLAN_TP_CD           = 'SPRD_INIT_GC'
												AND    IGR.PLAN_YYYYMM          = CASE WHEN DIVISION_ID = '81' THEN PLAN_YYYYMM ELSE IGR.PLAN_YYYYMM END
												-- [E20250310-000014] LONG_TERM_TYPE 대신 LONG_TERM_TYPE_CODE로 조건 변경('부실' -> '장기')
												AND    IGR.LONG_TERM_TYPE_CODE  IN (N'CODE_5',N'CODE_6') --AND    IGR.LONG_TERM_TYPE       IN (N'부실',N'부실 징후')
												AND    IGR.PLAN_START_YYYYMMDD  = CASE WHEN DIVISION_ID = '81' THEN PLAN_START_YYYYMMDD ELSE IGR.PLAN_START_YYYYMMDD END
												AND    IGR.DIVISION_ID          = CASE WHEN DIVISION_ID = '81' THEN DIVISION_ID ELSE IGR.DIVISION_ID END
												AND    IGR.GROUP_CODE1          = CASE WHEN DIVISION_ID = '81' THEN GROUP_CODE1 ELSE IGR.GROUP_CODE1 END
											)     
					) FI
					ON  FI.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
					AND SU.PLAN_TP_CD = FI.PLAN_TP_CD
					AND SU.PLAN_YYYYMM = FI.PLAN_YYYYMM
					AND SU.ITEM_ID = FI.ITEM_ID
					AND SU.DIVISION_ID = FI.DIVISION_ID
				WHERE SU.PLAN_START_YYYYMMDD = @v_chk_plan_start_yyyymmdd
				AND SU.PLAN_YYYYMM >= @v_basis_yyyymm
				--AND ISNULL(QTY, 0) > 0
				AND SU.PLAN_TP_CD = @v_plan_tp_cd
				AND SU.DIVISION_ID = @v_division_id
			END

		IF @v_plan_tp_cd = 'RMTL'
			BEGIN

				INSERT INTO SCP_ANL_LGTM_INV_MGMT_PLAN
				SELECT 
				@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
				, SU.PLAN_TP_CD
				, DATA_TP_CD
				, SRCE_TP_CD
				, SU.DIVISION_ID
				, PLANT_ID
				, SU.ITEM_ID
				, SU.PLAN_YYYYMM
				, QTY
				, OCCR_RSN_CD
				, OCCR_RSN_CTN
				, EXHT_TP_CD
				, EXHT_TP_CTN
				, GETDATE() AS CREATE_DATE
				, 'SYSTEM' AS CREATED_BY
				, GETDATE() AS LAST_UPDATE_DATE
				, 'SYSTEM' AS LAST_UPDATED_BY
				, IMPU_DEPT_NM
				, SU.COMPANY_ID
				FROM SCP_ANL_LGTM_INV_MGMT_PLAN SU
				LEFT JOIN (SELECT DISTINCT PLAN_TP_CD, PLAN_START_YYYYMMDD, DIVISION_ID, ITEM_ID, PLAN_YYYYMM FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL
							WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							AND DATA_TP_CD      = 'EOH'         
							-- [E20250310-000014] LONG_TERM_TYPE 대신 LONG_TERM_TYPE_CODE로 조건 변경('부실' -> '장기')
							AND LONG_TERM_TYPE_CODE  IN (N'CODE_5',N'CODE_6') --AND LONG_TERM_TYPE  IN (N'부실',N'부실 징후')   
							AND PLAN_TP_CD      = 'RMTL_INIT'
							AND DIVISION_ID     = @v_division_id
					) FI
					ON  FI.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
					AND SU.PLAN_TP_CD = FI.PLAN_TP_CD
					AND SU.PLAN_YYYYMM = FI.PLAN_YYYYMM
					AND SU.ITEM_ID = FI.ITEM_ID
					AND SU.DIVISION_ID = FI.DIVISION_ID
				WHERE SU.PLAN_START_YYYYMMDD = @v_chk_plan_start_yyyymmdd
				AND SU.PLAN_YYYYMM >= @v_basis_yyyymm
				--AND ISNULL(QTY, 0) > 0
				AND SU.PLAN_TP_CD = @v_plan_tp_cd
				AND SU.DIVISION_ID = @v_division_id
			END

		IF @v_plan_tp_cd = 'GODS'
			BEGIN

				INSERT INTO SCP_ANL_LGTM_INV_MGMT_PLAN
				SELECT 
				@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
				, SU.PLAN_TP_CD
				, DATA_TP_CD
				, SRCE_TP_CD
				, SU.DIVISION_ID
				, PLANT_ID
				, SU.ITEM_ID
				, SU.PLAN_YYYYMM
				, QTY
				, OCCR_RSN_CD
				, OCCR_RSN_CTN
				, EXHT_TP_CD
				, EXHT_TP_CTN
				, GETDATE() AS CREATE_DATE
				, 'SYSTEM' AS CREATED_BY
				, GETDATE() AS LAST_UPDATE_DATE
				, 'SYSTEM' AS LAST_UPDATED_BY
				, IMPU_DEPT_NM
				, SU.COMPANY_ID
				FROM SCP_ANL_LGTM_INV_MGMT_PLAN SU
				LEFT JOIN (SELECT DISTINCT PLAN_TP_CD, PLAN_START_YYYYMMDD, DIVISION_ID, ITEM_ID, PLAN_YYYYMM FROM SCM_LGTM_INV_PSI_SUMMARY_GODS
							WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							AND DATA_TP_CD      = 'EOH'         
							-- [E20250310-000014] LONG_TERM_TYPE 대신 LONG_TERM_TYPE_CODE로 조건 변경('부실' -> '장기')
							AND LONG_TERM_TYPE_CODE  IN (N'CODE_5',N'CODE_6') --AND LONG_TERM_TYPE  IN (N'부실',N'부실 징후')   
							AND PLAN_TP_CD      = 'GODS_INIT'
							AND DIVISION_ID     = @v_division_id
					) FI
					ON  FI.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
					AND SU.PLAN_TP_CD = FI.PLAN_TP_CD
					AND SU.PLAN_YYYYMM = FI.PLAN_YYYYMM
					AND SU.ITEM_ID = FI.ITEM_ID
					AND SU.DIVISION_ID = FI.DIVISION_ID
				WHERE SU.PLAN_START_YYYYMMDD = @v_chk_plan_start_yyyymmdd
				AND SU.PLAN_YYYYMM >= @v_basis_yyyymm
				--AND ISNULL(QTY, 0) > 0
				AND SU.PLAN_TP_CD = @v_plan_tp_cd
				AND SU.DIVISION_ID = @v_division_id
			END

        END


		-- 20250714 YMH 정책재고 관련 데이터 생성부분 제거
		-- 별도의 잡으로 로직 빼냄. ()
		/*
		IF @v_plan_tp_cd = 'POLICY'
		BEGIN

		SELECT @v_chk_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD) FROM SCP_ANL_LGTM_PCY_INV_MGMT_PLAN WHERE  PLAN_START_YYYYMMDD < @v_plan_start_yyyymmdd
		--정책재고
		INSERT INTO SCP_ANL_LGTM_PCY_INV_MGMT_PLAN
		SELECT 
		@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
		, PLAN_TP_CD
		, DIVISION_ID
		, PLANT_ID
		, ITEM_ID
		, PLAN_YYYYMMDD
		, OCCR_RSN_CD
		, OCCR_RSN_CTN
		, EXHT_TP_CD
		, EXHT_TP_CTN
		, QTY
		, SUPPLIER_CODE
		, GETDATE() AS CREATE_DATE
		, 'SYSTEM' AS CREATED_BY
		, GETDATE() AS LAST_UPDATE_DATE
		, 'SYSTEM' AS LAST_UPDATED_BY
		, @v_plan_start_yyyymmdd + '-'+ CAST( NEXT VALUE FOR SEQ1_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN AS NVARCHAR) AS REQUEST_NO
		, COMPANY_ID
		FROM SCP_ANL_LGTM_PCY_INV_MGMT_PLAN
		WHERE PLAN_START_YYYYMMDD = @v_chk_plan_start_yyyymmdd
		AND PLAN_YYYYMMDD >= @v_basis_yyyymm + '01'
		--AND DIVISION_ID = @v_division_id

		END
		*/

        COMMIT TRANSACTION;
    END TRY
    
    ------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	ROLLBACK TRANSACTION PSI_ALLOCATION_COPY;
	------------------------------------------------------------------------
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	------------------------------------------------------------------------  
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
	------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------
  END;
