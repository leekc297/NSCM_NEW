 
/*
 * Program ID  : [DMF0081_GET_CUST_DEMAND_ANL_DETAIL]
 * Author:		<Author,,Name>
 * Create date: <Create Date,,>
 * Description  : 고객수요증감 팝업 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2024.11.05		dsiol		  팝업에서 입력한 데이터를 1 ROW씩 INSERT 한다. (ROW 만큼 실행되는 프로시저)
 /* 2024-12-10  dsiol    [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 */  
 */
CREATE PROCEDURE [dbo].[DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP]
	@p_division_id	   NVARCHAR(30),
	@p_end_customer    NVARCHAR(50),
    @p_project_code    NVARCHAR(50),
	@p_measure		   NVARCHAR(50),
	@p_yyyymm          NVARCHAR(6),
	@p_req_rsn_cd	   NVARCHAR(50)   = NULL,
	@p_dif_anls_tp_cd  NVARCHAR(50)   = NULL,
	@p_anls_dif_rsn_cd NVARCHAR(50)   = NULL,
	@p_req_rsn_dtl_ctn NVARCHAR(4000) = NULL,
	@p_qty			   NUMERIC(20,8)  = 0,
	@p_created_by	   NVARCHAR(MAX)  = NULL,
	@p_procedure_type  NVARCHAR(10)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRANSACTION DMF0081_SAVE_POPUP;  

	IF @p_procedure_type = 'DELETE'
	BEGIN TRY
		--BEGIN TRAN
		DELETE FROM DM_CUST_DEMAND_ANL_DETAIL
		WHERE DIVISION_ID  = @p_division_id
		  AND END_CUSTOMER = @p_end_customer
		  AND PROJECT_CODE = @p_project_code
		  AND MEASURE      = @p_measure
		  AND PLAN_YYYYMM  = @p_yyyymm
		--COMMIT;
	END TRY
	BEGIN CATCH
      ROLLBACK TRANSACTION DMF0081_SAVE_POPUP;  
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'DELETE ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END CATCH

	IF @p_procedure_type = 'INSERT'
	BEGIN TRY
		--BEGIN TRAN
		INSERT INTO DM_CUST_DEMAND_ANL_DETAIL 
		(DIVISION_ID    ,END_CUSTOMER      ,PROJECT_CODE       ,MEASURE           ,PLAN_YYYYMM
		,REQ_RSN_CD     ,DIF_ANLS_TP_CD    ,ANLS_DIF_RSN_CD    ,REQ_RSN_DTL_CTN	  ,QTY
		,CREATED_BY     ,CREATION_DATE     ,LAST_UPDATED_BY    ,LAST_UPDATE_DATE) 
		VALUES
		(@p_division_id ,@p_end_customer   ,@p_project_code    ,@p_measure         ,@p_yyyymm
		,@p_req_rsn_cd  ,@p_dif_anls_tp_cd ,@p_anls_dif_rsn_cd ,@p_req_rsn_dtl_ctn ,@p_qty
		,@p_created_by  ,GETDATE()         ,@p_created_by      ,GETDATE()
		)
		--COMMIT;
	END TRY
	BEGIN CATCH
      ROLLBACK TRANSACTION DMF0081_SAVE_POPUP;  
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'INSERT ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END CATCH

	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	COMMIT;
END
