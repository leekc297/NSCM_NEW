-- ▼ FN_GET_SCP_OPMZ_PLAN_SEQ : 패치의 원본(base) PLAN_ID + 시나리오코드(SNRO) → 'SNRO_' + 채번된 엔진 계획ID(base_S00x)
/*
 * Program ID   : FN_GET_SCP_OPMZ_PLAN_SEQ
 * Description  : 채번 엔진 계획ID 조회 (원본 PLAN_ID + SNRO → SCP_OPMZ_PLAN_M)
 * Program History
 *===================================================================================================
 *   Date       In Charge        Description
 *===================================================================================================
 * 2026/07/02   park.choyi        [E20260618-001356] 시나리오 플래닝 SCP 기준정보 업데이트 - Initial Release
 *
 */
CREATE   FUNCTION dbo.FN_GET_SCP_OPMZ_PLAN_SEQ(@base NVARCHAR(100), @snro NVARCHAR(60))
RETURNS NVARCHAR(120)
AS
BEGIN
    /* 시나리오 채번 계획ID 조회 (2026-07-13 신규, 접두 2026-07-13 추가).
       - 패치 JSON 의 PLAN_ID 는 '원본(base)' 계획ID(예 '20260406_40_18650_OC_001') 이고,
         시나리오(SNRO)가 적용되면 SCP_OPMZ_PLAN_M 에 '채번본'(base + '_S00x', 예 '..._S002')이 생성된다.
       - 매핑(데이터 확인 2026-07-13): 채번행의 ATTRIBUTE9 = 원본 plan_id, CREATED_BY(=LAST_UPDATED_BY) = 그 SNRO 코드.
         (ATTRIBUTE9, CREATED_BY) 유일 → base + SNRO 로 채번본 1건 특정.
       - 채번본이 아직 없으면(동기화 전/합성 테스트) 원본 base 로 폴백.
       - ★DESC/이력 꼬리 표기 규칙(사용자 요청 2026-07-13): 엔진 plan_id 앞에 리터럴 'SNRO_' 접두를 붙인다
         (엔진 plan_id 는 저장상 'SNRO_'가 없고 '20260406_...'로 시작하므로 시나리오 유래 표식으로 부착).
         예: '20260406_40_18650_OC_001_S002' → 'SNRO_20260406_40_18650_OC_001_S002'. 이미 'SNRO_'면 중복 미부착.
       - 파라미터/컬럼 모두 DB 기본 콜레이션(LGCE)이라 별도 COLLATE 불필요. */
    DECLARE @pid NVARCHAR(100) = ISNULL(
        (SELECT TOP 1 pm.OPMZ_PLAN_ID
         FROM dbo.SCP_OPMZ_PLAN_M pm
         WHERE pm.ATTRIBUTE9 = @base
           AND pm.CREATED_BY = @snro
         ORDER BY pm.OPMZ_PLAN_ID DESC),
        @base);
    RETURN CASE WHEN @pid LIKE N'SNRO[_]%' THEN @pid ELSE N'SNRO_' + @pid END;
END
