
/*
 * Program ID   : PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_CALL
 * Description  : Sales Plan AMT Create ( Local/KRW ) 
 * Program History
 *===================================================================================================
 *   Date       In Charge       Description
 *===================================================================================================
 * 20180822     KHSONG          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *                              30분마다 스케줄을 사용하여 MKT_FCST RTF와 SALES PLAN RTF 값이 다른건이 있으면
 *                              PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW 프로시져를 호출하는 작업
 * 2025.04.16   Philsu Park     [PJ2025-50017] 40번 사업부 MKT Fcst 테이블 변경 현행화. 
                                동일 SP 중첩 호출 방지를 위한 수정.
 */

CREATE PROCEDURE [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_CALL]

	-- Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(MAX)		,  -- 현재 '40' 소형만 스케줄러에서 호출되고 있음
	@p_CREATED_BY               NVARCHAR(MAX)

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

    -- Batch 수행을 체크하는 Count 변수
    DECLARE @v_count        INTEGER = 1;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_CALL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	--BEGIN TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW_CALL;

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------	

	-- MKT_FCST RTF와 SALES PLAN RTF 값이 다른건 확인
	IF ISNULL((
                SELECT  COUNT(1) 
                -- FROM DM_PLN_MKT_FCST A WITH(NOLOCK)  -- 2025.04.16 Philsu Park: 테이블 변경 현행화.
                FROM    DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
                INNER JOIN SCM_MST_SITE_ITEM C WITH(NOLOCK)
                ON (    A.DIVISION_ID	= C.DIVISION_ID
                    AND A.PROJECT_CODE	= C.PROJECT_CODE	
                    AND A.SCM_SITE_ID	= C.SCM_SITE_ID	
                    AND A.ITEM_ID		= C.ITEM_ID		
                    )
                LEFT JOIN DM_PLN_SALES_PLAN B WITH(NOLOCK)
                ON (    A.DIVISION_ID	    = B.DIVISION_ID	
                    AND A.PROJECT_CODE	    = B.PROJECT_CODE	
                    AND A.SCM_SITE_ID	    = B.SCM_SITE_ID	
                    AND A.ITEM_ID		    = B.ITEM_ID		
                    AND A.DOM_EXP		    = B.DOM_EXP		
                    AND A.FCST_TYPE		    = B.FCST_TYPE		
                    AND A.INCOTERMS		    = B.INCOTERMS		
                    AND A.MEASURE		    = B.MEASURE		
                    AND A.PLANT_SITE_ID	    = B.PLANT_SITE_ID		
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD          = B.YYYYMMDD
                    )
                WHERE   1=1
                AND A.MEASURE      IN ('RTF','MKT_FCST')
                AND A.QTY          <> ISNULL(B.QTY,9999999)
                AND A.DIVISION_ID   = @p_division_id
                --and b.qty is null
                AND A.QTY          <> 0
                AND A.YYYYMMDD     >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 YYYYMMDD
				),0) > 0  -- 일치하지 않는 대상이 있으면
		BEGIN
            -- 2025.04.16 Philsu Park: 동일 SP의 Start Log가 End Log 시간보다 최근인 경우, 수행중인 것으로 간주하고 배치 호출을 SKIP.
            SELECT  @v_count = IIF(MAX(CASE WHEN LOG_TYPE = 'START' THEN EVENT_DATE ELSE NULL END) >= MAX(CASE WHEN LOG_TYPE = 'END' THEN EVENT_DATE ELSE NULL END), 1, 0)
            FROM    SCM_SYS_LOG_BATCH B WITH(NOLOCK)
            WHERE   B.PROGRAM_NAME  = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
            AND     B.LOG_TYPE     IN ('START', 'END')
            AND     B.EVENT_DATE   <= CURRENT_TIMESTAMP
            AND     B.EVENT_DATE   >= CURRENT_TIMESTAMP - 0.1
            ;

            IF @v_count = 0
                BEGIN
                    SET @v_description = 'We found Unmatched data. ! EXECUTE PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW';
                    
                    EXEC [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW]
                            @p_division_id,
                            @p_CREATED_BY;
                END
            ELSE
                BEGIN 
                    SET @v_description = 'The same SP already running. ! EXECUTE PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW SKIPPED';
                END
		END

	ELSE
		
		BEGIN
			SET @v_description = 'Unmatched data was not found. ! ';
		END
  	-- 트랜잭션 (COMMIT)
        --COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW_CALL;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    IF @v_log_message IS NULL
		BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END

  END;
