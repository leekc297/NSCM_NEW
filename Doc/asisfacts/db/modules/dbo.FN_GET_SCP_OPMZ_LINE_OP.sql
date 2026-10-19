

-- ▼ FN_GET_SCP_OPMZ_LINE_OP
/*
 * Program ID   : FN_GET_SCP_OPMZ_LINE_OP
 * Description  : LINE → OPERATION_ID 해석 (룩업 SCP_OPMZ_LINE_OPERATION)
 * Program History
 *===================================================================================================
 *   Date       In Charge        Description
 *===================================================================================================
 * 2026/07/02   park.choyi        [E20260618-001356] 시나리오 플래닝 SCP 기준정보 업데이트 - Initial Release
 *
 */
CREATE   FUNCTION dbo.FN_GET_SCP_OPMZ_LINE_OP(@div NVARCHAR(60), @plant NVARCHAR(60), @line NVARCHAR(60))
RETURNS NVARCHAR(60)
AS
BEGIN
    RETURN (SELECT TOP 1 SEGMENT4
            FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL
            WHERE LOOKUP_TYPE = N'SCP_OPMZ_LINE_OPERATION' AND VALID_YN = 'Y'
              AND SEGMENT1 = @div AND SEGMENT2 = @plant AND SEGMENT3 = @line);
END
