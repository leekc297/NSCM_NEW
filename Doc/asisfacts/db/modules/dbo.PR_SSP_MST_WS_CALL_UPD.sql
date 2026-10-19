/*
 * Program ID   : PR_SSP_MST_WS_CALL_UPD
 * Description  : ERP Return Value Update
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/24	MCTheJ        [PJ20189106] 전지.GSCM 고도화 이행- WS후 ERP Return Value Update
 *
 */
CREATE PROCEDURE [dbo].[PR_SSP_MST_WS_CALL_UPD]
	@p_call_flag                NVARCHAR(2),
	@p_call_date				DateTime,
	@p_call_msg					NVARCHAR(2000),
	@p_barch_id					NVARCHAR(24),
	@p_if_seq_no				NVARCHAR(28),
	@p_chnage_req_no			NVARCHAR(40)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE SSP_MST_WS_CALL
	SET
		WS_CALL_FLAG = @p_call_flag,
		WS_CALL_DATE = @p_call_date,
		WS_ERROR_DESC = @p_call_msg
	WHERE 1 = 1
	AND BATCH_ID = @p_barch_id
	AND IFSEQNO = @p_if_seq_no
	AND CHANGE_REQ_NO = @p_chnage_req_no;
	--WS호출 이후 결과 처리 (에러일 경우 상태 원복)
	--EXEC PR_SSP_MST_WS_CALL_BATCH 'OUT', @p_barch_id;
END
