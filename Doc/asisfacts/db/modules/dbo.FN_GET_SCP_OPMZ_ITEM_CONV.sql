-- ▼ FN_GET_SCP_OPMZ_ITEM_CONV : 전극 코팅 EA 품목 LOAD_PER 환산자(정방향 EE_INPUT과 동일 기준)
/*
 * Program ID   : FN_GET_SCP_OPMZ_ITEM_CONV
 * Description  : 전극(E2000/PANCAKE) EA 품목 LOAD_PER 환산자(VAL) 조회 (M_MIN 역산 보정용)
 * Program History
 *===================================================================================================
 *   Date       In Charge        Description
 *===================================================================================================
 * 2026/07/02   park.choyi        [E20260618-001356] 시나리오 플래닝 SCP 기준정보 업데이트 - Initial Release
 *
 */
CREATE   FUNCTION dbo.FN_GET_SCP_OPMZ_ITEM_CONV(@site_id NVARCHAR(60), @item NVARCHAR(60), @plan_id NVARCHAR(120))
RETURNS NUMERIC(20,10)
AS
BEGIN
    /* 전극 코팅(OPERATION='E2000', CATEGORY='PANCAKE (CELL/M)') EA 품목의 LOAD_PER 환산자(VAL) 반환.
       정방향 PR_SCP_OPT_ENG_EE_INPUT_ROUTING_RESOURCE 는 EA 품목에 LOAD_PER = LOAD_PER / CV.VAL 로 나눔
       → 역방향(M_MIN 재계산)은 LOAD_PER 에 이 값을 곱해야 정합(M_MIN = 60/(LOAD_PER × 환산자 × rt/100 × LANE × wide)).
       @site_id = 라우팅 SITE(SCM_SITE_ID, 예 'HQ06-E'). SCM_MST_SITE(SITE_TYPE='PLANT')로 COMPANY_ID/SITE_ID/DIVISION 도출.
       @plan_id = 채번 엔진 계획ID. 정방향 EXISTS와 동일하게 '그 플랜 모델리스트(SCP_OPT_ENG_MODEL_LIST_N_SN, PLAN_ID+ITEM_ID)에 있는 품목'에만 환산 적용 → 없으면 1.
       환산자 값 = MAX_VER_FLAG='Y'·CATEGORY='PANCAKE (CELL/M)'·OPERATION='E2000' 중 VERSION_TYPE 오름차순 첫 버전(예 'MASS')의 MAX(VALUE) (정방향 R_NUM=1과 동일).
       마스터(SCM_MST_ITEM_SN / SCM_MST_ITEM_CONV_CALC_SN) 부재(개발) · UOM<>'EA' · 모델리스트 미포함 · 환산행 없음 → 1(무변경) 반환. */
    DECLARE @company NVARCHAR(60), @site NVARCHAR(60), @div NVARCHAR(60), @uom NVARCHAR(30), @val NUMERIC(20,10);
    SELECT TOP 1 @company=COMPANY_ID, @site=SITE_ID, @div=DIVISION_ID
      FROM dbo.SCM_MST_SITE
      WHERE SCM_SITE_ID = @site_id AND SITE_TYPE = 'PLANT' AND VALID_YN = 'Y';
    IF @company IS NULL RETURN 1;
    IF OBJECT_ID('dbo.SCM_MST_ITEM_SN') IS NULL RETURN 1;
    SELECT TOP 1 @uom = ITEM_UOM
      FROM dbo.SCM_MST_ITEM_SN
      WHERE COMPANY_ID=@company AND DIVISION_ID=@div AND SITE_ID=@site AND ITEM_ID=@item;
    IF ISNULL(@uom, N'') <> N'EA' RETURN 1;
    -- 모델리스트 스코프(정방향 EXISTS와 동일): 해당 플랜(@plan_id) 모델에 없는 품목은 환산 안 함(→1)
    IF @plan_id IS NOT NULL AND LTRIM(RTRIM(@plan_id)) <> N''
       AND OBJECT_ID('dbo.SCP_OPT_ENG_MODEL_LIST_N_SN') IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM dbo.SCP_OPT_ENG_MODEL_LIST_N_SN
                       WHERE PLAN_ID = @plan_id AND ITEM_ID = @item)
        RETURN 1;
    IF OBJECT_ID('dbo.SCM_MST_ITEM_CONV_CALC_SN') IS NULL RETURN 1;
    -- 정방향 EE_INPUT과 동일: VERSION_TYPE 순 첫 버전(R_NUM=1, 예 'MASS')의 MAX(VALUE). (여러 VERSION_TYPE 존재 대비)
    SELECT TOP 1 @val = MAX(VALUE)
      FROM dbo.SCM_MST_ITEM_CONV_CALC_SN
      WHERE COMPANY_ID=@company AND SITE_ID=@site AND ITEM_ID=@item
        AND MAX_VER_FLAG='Y' AND CATEGORY='PANCAKE (CELL/M)' AND OPERATION='E2000'
      GROUP BY VERSION_TYPE
      ORDER BY VERSION_TYPE;
    RETURN ISNULL(NULLIF(@val, 0), 1);
END
