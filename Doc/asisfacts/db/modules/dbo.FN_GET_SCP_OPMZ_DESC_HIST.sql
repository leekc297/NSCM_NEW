

-- ▼ FN_GET_SCP_OPMZ_DESC_HIST
/*
 * Program ID   : FN_GET_SCP_OPMZ_DESC_HIST
 * Description  : 변경이력(DESC) 전환문구 생성 (원본 -> 사유 (PLAN_ID))
 * Program History
 *===================================================================================================
 *   Date       In Charge        Description
 *===================================================================================================
 * 2026/07/02   park.choyi        [E20260618-001356] 시나리오 플래닝 SCP 기준정보 업데이트 - Initial Release
 *
 */
CREATE   FUNCTION dbo.FN_GET_SCP_OPMZ_DESC_HIST(@old NVARCHAR(200), @reason NVARCHAR(200), @tail NVARCHAR(100))
RETURNS NVARCHAR(200)
AS
BEGIN
    /* DESC/이력 전환문구 생성: '원본->사유 (<PLAN_ID>)' (예: '조교대->조교대 단축(조립) (20260406_40_18650_OC_001_S002)').
       - @tail = 그 행을 만든 패치의 채번 PLAN_ID(base_S00x). (2026-07-13: 이전엔 SNRO_CD였음 → 사용자 요청으로 PLAN_ID로 교체.)
       - 멱등 가드(2026-07-13 재설계): PLAN_ID 접두사에 의존하지 않음(실 plan_id는 'SNRO_'가 아니라 날짜 '20260406_...'로 시작할 수 있음).
         규칙: @old 가 ')'로 끝나고 '마지막 ( 이후 괄호내용'이 코드형([0-9A-Za-z_-], 공백·한글 없음)이면 = 우리가 붙인 꼬리로 보고,
               그 ' (' 앞 + 마지막 '->' 앞의 원본만 남긴 뒤 재구성. → 같은 값 재실행 멱등, 다른 PLAN_ID면 교체(원본 보존, 무한증식 방지).
         · 자연 DESC의 괄호는 한글/공백 포함(예 '(인원충원)','(27일)','(2170 탭리스 설비 입고)')이라 코드형이 아니라 보존됨.
         · 옛 '(SNRO)'·'(SNRO-...)' 꼬리도 코드형이라 자동 마이그레이션.
         → ATTRIBUTE9(=SNRO_CD/카드 출처태그)와는 별개(그건 유지). 사유(@reason)에는 '->'가 없다고 가정(룩업 DESCRIPTION/폴백 문구). */
    DECLARE @base NVARCHAR(200) = ISNULL(@old, N'');
    IF RIGHT(@base, 1) = N')'
    BEGIN
        DECLARE @openPos INT = LEN(@base) - CHARINDEX(N'(', REVERSE(@base)) + 1;   -- 마지막 '(' 위치
        IF @openPos >= 1
        BEGIN
            DECLARE @inner NVARCHAR(200) = SUBSTRING(@base, @openPos + 1, LEN(@base) - @openPos - 1);  -- 괄호 내용
            IF LEN(@inner) > 0 AND @inner NOT LIKE N'%[^0-9A-Za-z_-]%'             -- 코드형(공백·한글 없음) = 우리 꼬리
            BEGIN
                SET @base = RTRIM(LEFT(@base, @openPos - 1));                       -- ' (' 앞까지(+우측공백 제거)
                DECLARE @p INT = CHARINDEX(N'>-', REVERSE(@base));                  -- 마지막 '->' 위치(역순)
                IF @p > 0 SET @base = LEFT(@base, LEN(@base) - @p - 1);             -- '->' 앞 = 원본만 남김
                ELSE      SET @base = N'';                                          -- '->' 없음 → 첫 append였음(원본 없음)
            END
        END
    END
    RETURN LEFT(CASE WHEN @base = N'' THEN CONCAT(@reason, N' (', @tail, N')')
                     ELSE CONCAT(@base, N'->', @reason, N' (', @tail, N')') END, 200);
END
