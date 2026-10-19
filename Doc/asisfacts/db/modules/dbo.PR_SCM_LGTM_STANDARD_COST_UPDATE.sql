
CREATE PROCEDURE [dbo].[PR_SCM_LGTM_STANDARD_COST_UPDATE]
     @p_plan_start_yyyymmdd     NVARCHAR(8)
    ,@p_base_yyyymm            NVARCHAR(6)
	,@p_plan_tp_cd				NVARCHAR(20)
AS 
BEGIN
    --2025.01.16 Y.S.H Initial Release
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_MRP_P_RESULT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type    = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date  = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  

    ------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = ISNULL( @p_plan_start_yyyymmdd ,  CONVERT(NVARCHAR(8), GETDATE(), 112) )
    DECLARE @v_basis_yyyymm         NVARCHAR(6)     = ISNULL( @p_base_yyyymm, SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, GETDATE()), 112 ),1,6) )
    DECLARE @v_mrp_p_version_no     NVARCHAR(50);
    DECLARE @v_add_days             NUMERIC         = 9;
    DECLARE @v_result_yyyymmdd      NVARCHAR(8);
    ------------------------------------------------------------------------  
		
	------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	BEGIN TRANSACTION PR_SCM_LGTM_MRP_P_RESULT;
	------------------------------------------------------------------------  
    PRINT 'PST YMD: '+@v_plan_start_yyyymmdd+'//Basis YM: '+@v_basis_yyyymm;
	------------------------------------------------------------------------  
	BEGIN TRY
		
        BEGIN
       
	   SELECT DISTINCT ITEM_ID, ORIGIN_ITEM_ID
		FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL WITH(NOLOCK)
		WHERE  PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND    VERSION_NO = 'Y'
		;

		  SELECT *
		 FROM [LGCE_SCMPROD].[dbo].[SCP_ANL_MONTH_END_STOCK_R] WITH(NOLOCK)
		   WHERE YYYYMM = @p_base_yyyymm
		   AND ITEM_ID IN (	SELECT DISTINCT ITEM_ID FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL
			WHERE 1=1
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND   STANDARD_COST IS NULL);

		-- 434
		WITH COST AS (SELECT MM.DIVISION_ID, MM.PLANT_ID, MM.ITEM_ID, MM.YYYYMM, MM.COST
						FROM (
								SELECT INV.DIVISION_ID, INV.PLANT_ID, INV.ITEM_ID, INV.YYYYMM
										, IIF(SUM(INV.QUANTITY)=0, 0, SUM(INV.AMOUNT_KRW)/SUM(INV.QUANTITY)) AS COST
								FROM   SCP_ANL_MONTH_END_STOCK_R INV WITH(NOLOCK)
								INNER JOIN (    SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
												FROM SCM_MST_ITEM_SN WITH(NOLOCK)
												GROUP BY ITEM_ID
											) C
									ON  C.ITEM_ID = INV.ITEM_ID
								INNER JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
									ON  C.ITEM_CLASS = D.CLASS_ID
								WHERE   1=1
								and     INV.DIVISION_ID      = '82'
								AND     INV.YYYYMM           = @p_base_yyyymm
								AND     CASE WHEN INV.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
											WHEN INV.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
											ELSE D.ITEM_TYPE
											END               = N'원부자재'
								GROUP BY INV.DIVISION_ID, INV.PLANT_ID, INV.ITEM_ID, INV.YYYYMM
								HAVING SUM(INV.QUANTITY) != 0
								) MM
		)        
		SELECT COST.COST, P.*
		FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL P WITH(NOLOCK)
			   LEFT OUTER JOIN COST
			   ON   COST.PLANT_ID = P.PLANT_ID
			   AND  COST.ITEM_ID  = P.ITEM_ID
		WHERE  P.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND    P.DIVISION_ID = '81'
		AND    P.ITEM_ID IN ( 
			SELECT DISTINCT ITEM_ID FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL
			WHERE 1=1
			--AND ITEM_ID = 'MFL01790AA'
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND   STANDARD_COST IS NULL
		)
		AND   STANDARD_COST IS NULL
		AND   PLAN_TP_CD = @p_plan_tp_cd
		AND COST.COST IS NULL
		;
		---------------------------------------------------------------------------------------------------------------------------------
		-- 단가 업데이트
		---------------------------------------------------------------------------------------------------------------------------------
		-- 434
		WITH COST AS (SELECT MM.DIVISION_ID, MM.PLANT_ID, MM.ITEM_ID, MM.YYYYMM, MM.COST
						FROM (
								SELECT INV.DIVISION_ID, INV.PLANT_ID, INV.ITEM_ID, INV.YYYYMM
										, IIF(SUM(INV.QUANTITY)=0, 0, SUM(INV.AMOUNT_KRW)/SUM(INV.QUANTITY)) AS COST
								FROM   SCP_ANL_MONTH_END_STOCK_R INV WITH(NOLOCK)
								INNER JOIN (    SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS
												FROM SCM_MST_ITEM_SN WITH(NOLOCK)
												GROUP BY ITEM_ID
											) C
									ON  C.ITEM_ID = INV.ITEM_ID
								INNER JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
									ON  C.ITEM_CLASS = D.CLASS_ID
								WHERE   1=1
								and     INV.DIVISION_ID      = '82'
								AND     INV.YYYYMM           = @p_base_yyyymm
								AND     CASE WHEN INV.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품'
											WHEN INV.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품'
											ELSE D.ITEM_TYPE
											END               = N'원부자재'
								GROUP BY INV.DIVISION_ID, INV.PLANT_ID, INV.ITEM_ID, INV.YYYYMM
								HAVING SUM(INV.QUANTITY) != 0
								) MM
		)        
		UPDATE SCM_LGTM_INV_PSI_SUMMARY_RMTL
		SET     CURRENCY       = 'KRW'
				,STANDARD_COST  = ( SELECT COST.COST
									FROM   COST
									WHERE  COST.PLANT_ID        = SCM_LGTM_INV_PSI_SUMMARY_RMTL.PLANT_ID
									AND    COST.ITEM_ID         = SCM_LGTM_INV_PSI_SUMMARY_RMTL.ITEM_ID
									)
				,CST_CTN        = CONCAT(CST_CTN, N'||8182_SYSTEM')
		WHERE   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND     DIVISION_ID = '81'
		AND     ITEM_ID IN ( 
			SELECT DISTINCT ITEM_ID FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL
			WHERE 1=1
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND PLAN_TP_CD = @p_plan_tp_cd
			AND   STANDARD_COST IS NULL
		)
		AND   STANDARD_COST IS NULL
		AND   PLAN_TP_CD = @p_plan_tp_cd
		;


		SELECT * FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL
			WHERE 1=1
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND   AMT IS NULL
			AND PLAN_TP_CD = @p_plan_tp_cd
			AND QTY IS NOT NULL AND STANDARD_COST IS NOT NULL
		---------------------------------------------------------------------------------------------------------------------------------
		-- 금액 업데이트
		---------------------------------------------------------------------------------------------------------------------------------
		UPDATE SCM_LGTM_INV_PSI_SUMMARY_RMTL
		SET    AMT = QTY * STANDARD_COST
		WHERE   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND     DIVISION_ID = '81'
		AND     ITEM_ID IN ( 
			SELECT DISTINCT ITEM_ID FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL
			WHERE 1=1
			--AND ITEM_ID = 'MFL01790AA'
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND   STANDARD_COST IS NULL
		)
		AND   PLAN_TP_CD = @p_plan_tp_cd
		AND   CST_CTN LIKE '%8182%'
		;
		---------------------------------------------------------------------------------------------------------------------------------
		-- 확인
		---------------------------------------------------------------------------------------------------------------------------------
		SELECT DISTINCT ITEM_ID
		FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL WITH(NOLOCK)
		WHERE   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND     DIVISION_ID = '81'
		AND     ITEM_ID IN ( 
			SELECT DISTINCT ITEM_ID FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL
			WHERE 1=1
			--AND ITEM_ID = 'MFL01790AA'
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND PLAN_TP_CD = @p_plan_tp_cd
			AND   STANDARD_COST IS NULL
		)
		AND   PLAN_TP_CD = @p_plan_tp_cd
		AND   CST_CTN LIKE '%8182%'

		--SELECT * FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL
		--WHERE 1=1
		--AND ITEM_ID = 'MFL01790AA'
		--AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		----AND   STANDARD_COST IS NULL
		--AND DATA_TP_CD = 'RESULT';


		UPDATE SCM_LGTM_INV_PSI_SUMMARY_RMTL
		SET    AMT = QTY * STANDARD_COST
		WHERE   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND     DIVISION_ID = '81'
		AND   PLAN_TP_CD = @p_plan_tp_cd
		AND   CST_CTN LIKE '%8182%'
		AND ITEM_ID = 'MFL01790AA'
		AND AMT IS NULL

		--단일 ITEM에 대하여 업데이트 진행 : 가끔(?) 값이 없는 경우가 존재함
		--UPDATE SCM_LGTM_INV_PSI_SUMMARY_RMTL
		--SET    STANDARD_COST = 11040.76858100
		--WHERE   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		--AND     DIVISION_ID = '81'
		--AND   PLAN_TP_CD = @p_plan_tp_cd
		--AND   CST_CTN LIKE '%8182%'
		--AND ITEM_ID = 'MFL01790AA'
		--AND AMT IS NULL


		UPDATE SCM_LGTM_INV_PSI_SUMMARY_RMTL
		SET    AMT = QTY * STANDARD_COST
		WHERE   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND     DIVISION_ID = '81'
		AND   PLAN_TP_CD = @p_plan_tp_cd
		AND   CST_CTN LIKE '%8182%'
		AND   STANDARD_COST IS NOT NULL AND QTY IS NOT NULL AND AMT IS NULL

		------------------------------------------------------------------------  
        END
        ------------------------------------------------------------------------

		------------------------------------------------------------------------ 
        PRINT 'Step 6 End';
        ------------------------------------------------------------------------

        IF OBJECT_ID (N'tempdb..#TEMP_INTRANSIT_QTY', N'U') IS NOT NULL DROP TABLE #TEMP_INTRANSIT_QTY;
        IF OBJECT_ID (N'tempdb..#TEMP_MRP_PLAN', N'U') IS NOT NULL      DROP TABLE #TEMP_MRP_PLAN;

		COMMIT TRANSACTION;
	END TRY

	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	ROLLBACK TRANSACTION PR_SCM_LGTM_MRP_P_RESULT;
	------------------------------------------------------------------------
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '' + Convert(NVARCHAR(10), ERROR_NUMBER()) + '' + ERROR_MESSAGE();
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
