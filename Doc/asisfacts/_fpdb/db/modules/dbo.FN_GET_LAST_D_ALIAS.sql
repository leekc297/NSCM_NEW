 

CREATE FUNCTION [dbo].[FN_GET_LAST_D_ALIAS]
-- ================================================================================================
-- Program Name        : FN_GET_LAST_D_ALIAS
-- Description         : 아래와 같이 , Xn + Xn.., Xn + Xn.. AS Yn 패턴의 문자열을 마지막 Xn 값을 찾아 , Xn AS Yn, Xn AS Yn 으로 리턴함
--              입력예    , D0+D1+D2+D3+D4+D5+D6+D7+D8+D9+D10+D11+D12+D13+D14 AS M0, D15+D16+D17+D18+D19+D20+D21+D22+D23+D24 AS M1
--              출력예    , D14 AS M0, D24 AS M1
-- Create(Update) Date : 2026.05.19
-- ================================================================================================
(
    @param NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @xml XML;
    DECLARE @result NVARCHAR(MAX);

    -- NULL 또는 빈 문자열 방어
    IF @param IS NULL OR LTRIM(RTRIM(@param)) = ''
        RETURN @param;

    -- 맨 앞 콤마가 있으면 제거
    IF LEFT(LTRIM(@param), 1) = ','
        SET @param = STUFF(LTRIM(@param), 1, 1, '');

    -- 콤마 기준으로 분리하기 위해 XML 형태로 변환
    SET @xml = CAST(
        '<x>' +
        REPLACE(@param, ',', '</x><x>') +
        '</x>' AS XML
    );

    ;WITH S AS
    (
        -- 콤마 기준으로 분리된 각 항목을 행으로 변환
        SELECT
            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn,
            LTRIM(RTRIM(T.C.value('.', 'NVARCHAR(MAX)'))) AS txt
        FROM @xml.nodes('/x') AS T(C)
    ),
    P AS
    (
        -- 계산식 부분과 Alias 부분 분리
        -- 예: D0+D1+D2 AS M0
        -- Expr = D0+D1+D2
        -- AliasName = M0
        SELECT
            rn,
            Expr = LTRIM(RTRIM(LEFT(txt, CHARINDEX(' AS ', txt) - 1))),
            AliasName = LTRIM(RTRIM(SUBSTRING(txt, CHARINDEX(' AS ', txt) + 4, LEN(txt))))
        FROM S
        WHERE CHARINDEX(' AS ', txt) > 0
    )
    SELECT
        @result =
        STUFF((
            SELECT
                ', ' +

                -- Expr에서 마지막 + 뒤의 값만 추출
                -- 예: D0+D1+D2+D14 → D14
                RIGHT(Expr, CHARINDEX('+', REVERSE(Expr) + '+') - 1) +

                ' AS ' +
                AliasName
            FROM P
            ORDER BY rn
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 0, '');

    RETURN @result;
END;
