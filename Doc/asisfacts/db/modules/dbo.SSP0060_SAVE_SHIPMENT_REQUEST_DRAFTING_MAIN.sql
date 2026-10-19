



/*
 * Program ID   : SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN
 * Description  : Shipment Plan Change 작성중 저장
 * 호출			: SSP0060
 * 관련 Table	: SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
 * 관련 프로시저 : PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN - ERP 관련 Table)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/10   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019/04/03	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS, REMARKS 컬럼 추가
 * 2019/04/30	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REQUESTOR 컬럼 변경
 * 2019/05/07	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS3 컬럼 추가
 * 2019/05/15	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  CHAGE_REASON_CODE, CHAGE_REASON_DETAIL PARAM추가
 * 2019/05/28	mcTheJ			[PJ20189106] 전지.GSCM 고도화 이행  CHANGE_TITLE 수정
 * 2019/05/29	mcTheJ			[PJ20189106] 전지.GSCM 고도화 이행  CHANGE_REASON 추가로 인한 CS코드에서 반복 호출(단. SONo의 경우 통으로 Parameter 넘김)
 * 2019/09/04	AYJ				etd:shipdate, eta:etd+lt_day로 셋팅
 * 2019/10/29	ayj				FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
 * 2020-02-26   KIMYONGHO           [C20200224-000318]출하변경사유 코드 변경   R01 - > T07
 * 2021/09/02   KIMYONGHO      SCP_MST_BOD_v -> SCP_MST_BOD_N_V 변경
 * 2021/10/18   KIMYONGHO	   [C20211001-000241][SCM PI팀] Shipment Plan (Auto ESS) 기능 개선 의건 
 * 2024/05/08   jilee          PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH  'C' 변경요청
 * 2024/05/22	hsbang			SSP_ANL_SHIP_CONFIRM_CHG_REQ_de A.ATTRIBUTE2(status_detail) 입력
 */

CREATE PROCEDURE [dbo].[SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN]
     @p_active_flag					NVARCHAR(MAX)
	,@p_division_id					NVARCHAR(MAX)
	,@p_change_req_no				NVARCHAR(MAX)
	,@p_confirm_id					NVARCHAR(MAX)
	,@p_shipment_qty				NVARCHAR(MAX)
	,@p_shipment_date				NVARCHAR(MAX)
	,@p_new_yyyymmdd				NVARCHAR(MAX)
	,@p_new_qty						NVARCHAR(MAX)
	,@p_user_id						NVARCHAR(MAX)
	,@p_change_reason_code	        NVARCHAR(MAX)
	,@p_change_reason_detail	    NVARCHAR(MAX)
	,@p_title						NVARCHAR(MAX)
	,@p_program_id					NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @recv_active_flag			NVARCHAR(MAX);
	DECLARE @v_max_req_no				NVARCHAR(40);
	DECLARE @v_active_flag				NVARCHAR(MAX);
	DECLARE @v_division_id				NVARCHAR(MAX)
	DECLARE @v_change_req_no			NVARCHAR(MAX)
	DECLARE @v_confirm_id				NVARCHAR(MAX)
	DECLARE @v_shipment_qty				NVARCHAR(MAX)
	DECLARE @v_shipment_date			NVARCHAR(MAX)
	DECLARE @v_new_yyyymmdd				NVARCHAR(MAX)
	DECLARE @v_new_qty					NVARCHAR(MAX)
	DECLARE @v_change_reason_code	    NVARCHAR(MAX);
	DECLARE @v_change_reason_detail	    NVARCHAR(MAX);

	SET @recv_active_flag			= NULL;		
	SET @recv_active_flag			= @p_active_flag;
	SET @v_active_flag				= NULL;
	SET @v_division_id				= NULL;
	SET @v_change_req_no			= NULL;
	SET @v_confirm_id				= NULL;
	SET @v_shipment_qty				= NULL;
	SET @v_shipment_date			= NULL;
	SET @v_new_yyyymmdd				= NULL;
	SET @v_new_qty					= NULL;
	SET @v_change_reason_code		= null;
	SET @v_change_reason_detail		= null;

	--SET @v_company_id               = NULL;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = @p_program_id + '-' + @p_title;
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag					= dbo.SCM_ARR_SPL_VAL( @p_active_flag,				@v_delimiter, @mst_loop_cnt );
				SET @v_division_id					= dbo.SCM_ARR_SPL_VAL( @p_division_id,				@v_delimiter, @mst_loop_cnt );
				--SET @v_change_req_no				= dbo.SCM_ARR_SPL_VAL( @p_change_req_no,			@v_delimiter, @mst_loop_cnt );
				SET @v_confirm_id					= dbo.SCM_ARR_SPL_VAL( @p_confirm_id,				@v_delimiter, @mst_loop_cnt );
				SET @v_shipment_qty					= dbo.SCM_ARR_SPL_VAL( @p_shipment_qty,				@v_delimiter, @mst_loop_cnt );
				SET @v_shipment_date				= dbo.SCM_ARR_SPL_VAL( @p_shipment_date,			@v_delimiter, @mst_loop_cnt );
				SET @v_shipment_qty					= dbo.SCM_ARR_SPL_VAL( @p_shipment_qty,				@v_delimiter, @mst_loop_cnt );
				SET @v_new_qty						= dbo.SCM_ARR_SPL_VAL( @p_new_qty,					@v_delimiter, @mst_loop_cnt );
				SET @v_new_yyyymmdd					= dbo.SCM_ARR_SPL_VAL( @p_new_yyyymmdd,				@v_delimiter, @mst_loop_cnt );
				SET @v_change_reason_code			= dbo.SCM_ARR_SPL_VAL( @p_change_reason_code,		@v_delimiter, @mst_loop_cnt );
				SET @v_change_reason_detail			= dbo.SCM_ARR_SPL_VAL( @p_change_reason_detail,		@v_delimiter, @mst_loop_cnt );
				
				SET @v_new_yyyymmdd = CONVERT(CHAR(8), @v_new_yyyymmdd, 112)

				IF @v_change_reason_code = '' OR @v_change_reason_code IS NULL
				BEGIN
					SET @v_change_reason_code	= NULL;
				END;

				IF @v_change_reason_detail	= '' OR @v_change_reason_detail IS NULL
				BEGIN
					SET @v_change_reason_detail	= NULL;	
				END;

			END;

			
		
			IF ISNULL(@v_shipment_qty, '') = '' OR @v_shipment_qty IS NULL
				BEGIN
					SET @v_shipment_qty = NULL
				END

				IF ISNULL(@v_shipment_date, '') = '' OR @v_shipment_date IS NULL
				BEGIN
					SET @v_shipment_date = ''
				END			

				UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
				SET 				
				    CHANGE_REASON_CODE   = @v_change_reason_code
				,   CHANGE_REASON_DETAIL = @v_change_reason_detail				
				WHERE CHANGE_REQ_NO = @p_change_req_no				

				UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
				SET NEW_YYYYMMDD = @v_new_yyyymmdd
				,	NEW_QTY      =  @v_new_qty
				,   VALID_YN     = 'Y'
				,   ATTRIBUTE4   =  @v_change_reason_code
				,   ATTRIBUTE5   =  @v_change_reason_detail
				,   LAST_UPDATED_BY = @p_user_id
				,   LAST_UPDATE_DATE = GETDATE()
				WHERE CHANGE_REQ_NO = @p_change_req_no
				AND   CONFIRM_ID    = @v_confirm_id
				AND   (YYYYMMDD != @v_new_yyyymmdd OR ISNULL(QTY, 0) != ISNULL(@v_new_qty, 0))
				;
		END;		--While					End
			
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code, @v_max_req_no Request_no ;
	END TRY

	 BEGIN CATCH
		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
END
