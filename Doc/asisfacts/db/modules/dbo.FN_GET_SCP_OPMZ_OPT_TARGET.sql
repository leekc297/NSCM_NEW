

-- ▼ FN_GET_SCP_OPMZ_OPT_TARGET
/*
 * Program ID   : FN_GET_SCP_OPMZ_OPT_TARGET
 * Description  : 시나리오 카드(SCP_OPT_ID) → 반영대상 판정 (룩업 SCP_OPMZ_SNRO_OPT)
 * Program History
 *===================================================================================================
 *   Date       In Charge        Description
 *===================================================================================================
 * 2026/07/02   park.choyi        [E20260618-001356] 시나리오 플래닝 SCP 기준정보 업데이트 - Initial Release
 *
 */
CREATE   FUNCTION dbo.FN_GET_SCP_OPMZ_OPT_TARGET(@opt_id NVARCHAR(60), @target NVARCHAR(30))
RETURNS BIT
AS
BEGIN
    /* 카드→항목 판정: SCP_OPMZ_SNRO_OPT lookup 단일 소스 (2026-07-06 단순화).
       - 4항목(NO_WORK/RAMP_UP/DDLY_CAPA/SOP_EOP) 모두 lookup(SEG1=항목, SEG2=카드, VALID_YN)으로 일괄 관리
       - 각 프로시저가 patch의 $.table을 자체 필터(NO_WORK=EVERY_CALENDAR, 그외=ROUTING_RESOURCE)하고
         실제 패치 데이터만 반영하므로, 엔진테이블 확인(OPT_CTX_M)은 중복 → 제거 */
    IF EXISTS (SELECT 1 FROM dbo.SCP_OPMZ_LOOKUP_MASTER_DETAIL
               WHERE LOOKUP_TYPE = N'SCP_OPMZ_SNRO_OPT'
                 AND SEGMENT1 = @target
                 AND SEGMENT2 = @opt_id
                 AND VALID_YN = 'Y')
        RETURN 1;
    RETURN 0;
END
