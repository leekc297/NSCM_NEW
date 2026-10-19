
/*
 * Program ID   : PR_SCP_RPT_ELEC_PSI
 * Description  : MCS Task_전극Visibiltiy_Global PSI (Elec)
 * Program History
 * 
 *===================================================================================================
 * Date        In Charge       Description
 *===================================================================================================
 * 2022.12.23   sclee.lee      V1.1.1   - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2      - Initial Release
 * 2023.03.16   chaan          V1.1.2   - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2      - @v_is_dev_mode(개발모드/운영모드) 구분자로 소스 통합
 * 2023.03.22   chaan          V1.1.3   - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2      - 전체 사업부 배치작업 편의성과 파라미터 지정가능하도록 PR_SCP_RPT_ELEC_PSI, PR_SCP_RPT_ELEC_PSI_FOR_IF 로 분리
 * 2023.07.24   chaan          V1.1.4   - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2      - Plant Type 기존 'FN' 기준에 MA/SE/PR 추가
 * 2023/08/11   chaan          V1.1.5  - PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2     - 요일 산출 오류 수정
 */

--CREATE PROCEDURE [dbo].[PR_SCP_RPT_ELEC_PSI]
CREATE PROCEDURE [dbo].[PR_SCP_RPT_ELEC_PSI]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @v_test_mode			        VARCHAR(1)          = '';          -- 코딩 테스트용(T : 테스트모드)
    --DECLARE @v_test_mode			        VARCHAR(1)          = 'T';          -- 코딩 테스트용(T : 테스트모드)


    DECLARE @v_batch_user           NVARCHAR(150)   = 'scp_batch';
	DECLARE @v_program_name         NVARCHAR(150)   = 'PR_SCP_RPT_ELEC_PSI';
    DECLARE @v_log_type             NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count            INT             = 0;
    DECLARE @v_log_message          NVARCHAR(1000);
    DECLARE @v_description          NVARCHAR(500);
    DECLARE @d_event_date           DATETIME;

    SET @v_log_type			= 'START';
    SET @v_log_message		= '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date		= SYSDATETIME();

    IF @v_test_mode <> 'T'
    BEGIN
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END

    DECLARE @V_ELAPSED_TIME_BEG         DATETIME            = CURRENT_TIMESTAMP;

    DECLARE @v_plan_type			    NVARCHAR(50)        = N'FN'; -- 'MA' : 수요일 09시 기준 생성, 'FN' : 금요일 09시 기준 생성, 금요일은 'FN' 기준, 수요일은 사업부, 계획/재고에 따라 다름

    DECLARE		@v_curr_date	        DATETIME	= GETDATE();
    DECLARE		@v_today    	        VARCHAR(14)	= FORMAT(@v_curr_date,'yyyyMMddHHmmss');
    DECLARE		@v_this_monday	        VARCHAR(8)	= '';
    DECLARE		@v_this_wednesday	    VARCHAR(14)	= '';
    DECLARE		@v_this_friday	        VARCHAR(14)	= '';


    SELECT @v_this_monday    = FORMAT(DATEADD(DD, 2 - DATEPART(DW, DATEADD(DD, -1, @v_curr_date)), DATEADD(DD, -1, @v_curr_date)), 'yyyyMMdd')
    SELECT @v_this_wednesday = FORMAT(DATEADD(DD, 4 - DATEPART(dw, @v_curr_date), @v_curr_date),'yyyyMMdd090000')
    SELECT @v_this_friday    = FORMAT(DATEADD(DD, 6 - DATEPART(dw, @v_curr_date), @v_curr_date),'yyyyMMdd090000')

    --SELECT @v_this_monday    = FORMAT(DATEADD(DD, 3 - DATEPART(DW, DATEADD(DD, -1, @v_curr_date)), DATEADD(DD, -1, @v_curr_date)), 'yyyyMMdd090000')
    --SELECT @v_this_wednesday = FORMAT(DATEADD(DD, 5 - DATEPART(DW, DATEADD(DD, -1, @v_curr_date)), DATEADD(DD, -1, @v_curr_date)), 'yyyyMMdd090000')
    --SELECT @v_this_friday    = FORMAT(DATEADD(DD, 7 - DATEPART(DW, DATEADD(DD, -1, @v_curr_date)), DATEADD(DD, -1, @v_curr_date)), 'yyyyMMdd090000')

    PRINT CONCAT('@v_curr_date : ',      @v_curr_date);
    PRINT CONCAT('@v_today : ',          @v_today);
    PRINT CONCAT('@v_this_monday : ',    @v_this_monday);
    PRINT CONCAT('@v_this_wednesday : ', @v_this_wednesday);
    PRINT CONCAT('@v_this_friday : ',    @v_this_friday);

    --IF @v_today < @v_this_friday -- 현재 날짜 기준으로 금주 금요일 09시이전까지 'MA'
    IF @v_today >= @v_this_wednesday AND @v_today < @v_this_friday -- 현재 날짜 기준으로 금주 수요일 09시 이후~ 금주 금요일 09시이전까지 'MA'
    BEGIN
        SET @v_plan_type            = 'MA';
    END
    ELSE
    BEGIN
        SET @v_plan_type            = 'FN';
    END


    PRINT CONCAT('@v_plan_type : ', @v_plan_type);
    --return;


    EXEC dbo.PR_SCP_RPT_ELEC_PSI_FOR_IF '81', 'EE', @v_this_monday, @v_plan_type;
    EXEC dbo.PR_SCP_RPT_ELEC_PSI_FOR_IF '82', 'EE', @v_this_monday, @v_plan_type;
    EXEC dbo.PR_SCP_RPT_ELEC_PSI_FOR_IF '40', 'EE', @v_this_monday, @v_plan_type;

    --EXEC dbo.PR_SCP_RPT_ELEC_PSI_FOR_IF '81', 'EE', '20230807', 'MA';
    --EXEC dbo.PR_SCP_RPT_ELEC_PSI_FOR_IF '82', 'EE', '20230807', 'MA';
    --EXEC dbo.PR_SCP_RPT_ELEC_PSI_FOR_IF '40', 'EE', '20230807', 'MA';

    --PRINT CONCAT('TOTAL ELAPSED_TIME - PR_SCP_RPT_ELEC_PSI : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
    PRINT CONCAT('TOTAL ELAPSED_TIME - PR_SCP_RPT_ELEC_PSI : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 108));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    IF @v_test_mode <> 'T'
    BEGIN
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END
END
