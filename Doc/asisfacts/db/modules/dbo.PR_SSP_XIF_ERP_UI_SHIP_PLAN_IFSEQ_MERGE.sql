
/*
 * Program ID   : PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE
 * Description  : IFSEQ Number Merge후 UI SHIP PLAN 전송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/04/29   jilee	      IFSEQ Number Merge후 UI SHIP PLAN 전송 
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE] 
	 @p_change_request_no			NVARCHAR(MAX) = ''
	,@p_status                      NVARCHAR(MAX) = ''
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE  @IFSEQNO				nvarchar(14 );
	DECLARE  @LAST_CONFIRM_DATE      nvarchar(8 );
	DECLARE  @SHIPMENT_STATUS        nvarchar(1 );

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_change_request_no, @v_delimiter);
	--WHILE LEN(@p_change_request_no) > 0 AND @mst_loop_cnt < @max_loop_cnt
	BEGIN
		--SET @mst_loop_cnt = @mst_loop_cnt + 1;			

		-- 각 컬럼들에 대한 스플릿처리로직 스타트
		--BEGIN
				
			--SET @p_request_no						= dbo.SCM_ARR_SPL_VAL( @p_request_no,					@v_delimiter, @mst_loop_cnt );
		--END;
		
			BEGIN
				-- 전송대상 IFSEQNO, LAST_CONFIRM_DATE, SHIPMENT_STATUS 조회
				 SELECT TOP 1 @IFSEQNO=IFSEQNO,   @LAST_CONFIRM_DATE=LAST_CONFIRM_DATE  ,@SHIPMENT_STATUS=SHIPMENT_STATUS                                
				   FROM dbo.XIF_ERP_SHIP_PLAN_CONFIRM_S_SN A with(nolock)
				   WHERE A.TRANSFER_FLAG	IN ('P','N')
					--AND A.SHIPMENT_STATUS != 'A'
					AND A.ATTRIBUTE1 = @p_change_request_no
				 GROUP BY IFSEQNO, LAST_CONFIRM_DATE, SHIPMENT_STATUS
				 ORDER BY IFSEQNO DESC, LAST_CONFIRM_DATE, SHIPMENT_STATUS
			 END

			--print @IFSEQNO
			--return;
			IF @p_status = 'C'
				BEGIN
					UPDATE dbo.XIF_ERP_SHIP_PLAN_CONFIRM_S_SN SET IFSEQNO = @IFSEQNO 
					WHERE 1 = 1
					AND ATTRIBUTE1 = @p_change_request_no
					AND SHIPMENT_STATUS = 'C'
					AND TRANSFER_FLAG	IN ('P','N')
					;
				END
			ELSE
				BEGIN
					UPDATE dbo.XIF_ERP_SHIP_PLAN_CONFIRM_S_SN SET IFSEQNO = @IFSEQNO 
					WHERE 1 = 1
					AND ATTRIBUTE1 = @p_change_request_no					
					AND TRANSFER_FLAG	IN ('P','N')
					;
				END
	END;
		
END

