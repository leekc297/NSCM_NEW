/*
 * Program ID   : PR_SCM_LGTM_INV_ALLOCATION_START
 * Description  : 장기재고 관련 정보 형성 전체 관리
 * OutTable     : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.06.10   KIMCD          PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                             INIT 작업에서 기존 재고 소진 계획 복사 작업 호출(주석 제거)
 * 2026/02/26   YMH			   [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경.

 */
CREATE PROCEDURE [dbo].[PR_SCM_LGTM_INV_ALLOCATION_START]
     @p_plan_tp_cd              NVARCHAR(100)
    ,@p_division_id             NVARCHAR(100)
    ,@p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_base_yyyymm            NVARCHAR(6)
	,@p_plant_id				NVARCHAR(100)
	,@p_chg_plan_start_yyyymmdd     NVARCHAR(8)
	,@p_mrp_version_id			NVARCHAR(100)
	,@p_type					NVARCHAR(8)
AS 
BEGIN

	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION_START';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	DECLARE @RC INT;
	DECLARE @v_division_id				VARCHAR(100);
	DECLARE @v_plan_tp_cd				VARCHAR(100);
	DECLARE @v_plan_start_yyyymmdd		NVARCHAR(8)    = @p_plan_start_yyyymmdd;
	DECLARE @v_base_yyyymm				NVARCHAR(6)    = @p_base_yyyymm;
	DECLARE @v_chg_plan_start_yyyymmdd	NVARCHAR(8)    = @p_chg_plan_start_yyyymmdd;
	DECLARE @v_mrp_version_id			NVARCHAR(30)    = @p_mrp_version_id;

	DECLARE @v_plan_tp_cd_result				VARCHAR(50);
	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########'; 
	SET @v_description = concat(@p_plan_tp_cd, ' : ' , @p_division_id, ' : ' , @p_plan_start_yyyymmdd, ' : ' , @p_base_yyyymm, ' : ' , @p_plant_id, ' : ' , @p_chg_plan_start_yyyymmdd, ' : ' , @p_mrp_version_id, ' : ' , @p_type); 
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  
	
--	BEGIN TRANSACTION PSI_ALLOCATION_COPY;
-- 데이터 업데이트 진행(nerp로부터 전달되는 값의 차이)
	UPDATE XIF_MRP_TB_RS_ITEM_CONSUM_R_SN
	SET ATTRBT_4_VAL = 'P'
	WHERE 1=1
	-- E20260211-001073 [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경관련 기존로직 주석처리.
	-- AND VRSN_ID = @p_mrp_version_id
	-- E20260211-001073 [E20260211-001073] MRP 수신정보 버전체계 변경으로 날짜정보만 추출하여 사용하게 변경
	AND VRSN_ID	LIKE @v_mrp_version_id + '%'
	AND ATTRBT_4_VAL = '*'

	------------------------------------------------------------------------  
    BEGIN TRY
		BEGIN
		DECLARE PLAN_TP_CURSOR CURSOR LOCAL
		FOR SELECT TOKEN FROM dbo.String_Split(@p_plan_tp_cd, ',')

			OPEN PLAN_TP_CURSOR
			FETCH NEXT FROM PLAN_TP_CURSOR INTO @v_plan_tp_cd

			WHILE @@FETCH_STATUS = 0
			BEGIN

			DECLARE DIV_CURSOR CURSOR LOCAL
			FOR SELECT TOKEN FROM dbo.String_Split(@p_division_id, ',')

				OPEN DIV_CURSOR
				FETCH NEXT FROM DIV_CURSOR INTO @v_division_id

				WHILE @@FETCH_STATUS = 0
					BEGIN

					IF @p_type = 'INIT'
						BEGIN
							SET @v_plan_tp_cd_result = @v_plan_tp_cd+'_INIT'
						END

					IF @p_type = 'FINAL'
						BEGIN
							SET @v_plan_tp_cd_result = @v_plan_tp_cd
						END

					IF @v_plan_tp_cd_result LIKE 'FERT%'
						BEGIN
							PRINT 'FERT Run: ' + @v_division_id;
							EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION @v_plan_tp_cd_result, @v_division_id, @v_plan_start_yyyymmdd, @v_base_yyyymm, @v_chg_plan_start_yyyymmdd;
 
							EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION_CAL @v_plan_tp_cd_result, @v_division_id, @v_plan_start_yyyymmdd, @v_base_yyyymm;
						END
					ELSE IF @v_plan_tp_cd_result LIKE 'SPRD%'
						BEGIN
							PRINT 'SPRD Run: ' + @v_division_id;
							EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION_SPRD @v_plan_tp_cd_result, @v_division_id, @v_plan_start_yyyymmdd, @v_base_yyyymm, @v_chg_plan_start_yyyymmdd, @v_mrp_version_id;
 
							EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION_SPRD_CAL @v_plan_tp_cd_result, @v_division_id, @v_plan_start_yyyymmdd, @v_base_yyyymm;
						END
					ELSE IF @v_plan_tp_cd_result LIKE 'GODS%'
						BEGIN
							PRINT 'GODS Run: ' + @v_division_id;
							EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION_GODS @v_plan_tp_cd_result, @v_division_id, @v_plan_start_yyyymmdd, @v_base_yyyymm, @v_chg_plan_start_yyyymmdd, @v_mrp_version_id;
 
							EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION_GODS_CAL @v_plan_tp_cd_result, @v_division_id, @v_plan_start_yyyymmdd, @v_base_yyyymm, @v_mrp_version_id;
						END
					ELSE
						BEGIN
 
							PRINT 'RMTL Run: ' + @v_division_id;
 
							EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION_RMTL @v_plan_tp_cd_result, @v_division_id, @v_plan_start_yyyymmdd, @v_base_yyyymm, @v_chg_plan_start_yyyymmdd, @v_mrp_version_id;
 
							EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL @v_plan_tp_cd_result, @v_division_id, @v_plan_start_yyyymmdd, @v_base_yyyymm, @v_mrp_version_id;
 
						END

					--EXECUTE @RC = dbo.PR_SCM_LGTM_STANDARD_COST_UPDATE @p_plan_start_yyyymmdd, @v_base_yyyymm, @p_plan_tp_cd;

					IF @p_type = 'INIT' --LONG TERM 호출  2025.06.10 KIMCD PJ2024A332 INIT 작업에서 기존 재고 소진 계획 복사 작업 호출(주석 제거)
						BEGIN
							EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY @v_plan_tp_cd, @v_division_id, @v_plan_start_yyyymmdd, @v_base_yyyymm;
						END

						FETCH NEXT FROM DIV_CURSOR INTO @v_division_id
					END
   
				CLOSE DIV_CURSOR
				DEALLOCATE DIV_CURSOR
		
				FETCH NEXT FROM PLAN_TP_CURSOR INTO @v_plan_tp_cd
				END
	
				
			END
			CLOSE PLAN_TP_CURSOR
			DEALLOCATE PLAN_TP_CURSOR

			SELECT @RC;

			--정책재고 복사 호출
			--IF @p_type = 'INIT'
			--BEGIN
			--EXECUTE @RC = dbo.PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY 'POLICY', '-', @v_plan_start_yyyymmdd, @v_base_yyyymm;
			--END
	--COMMIT TRANSACTION;

	END TRY
    
    ------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	SELECT ERROR_LINE() AS ERRORLINE;
	--ROLLBACK TRANSACTION PSI_ALLOCATION_COPY;

    SET @v_log_type = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
    SET @d_event_date = SYSDATETIME();
	SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------
	------------------------------------------------------------------------

	END CATCH
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------
	END