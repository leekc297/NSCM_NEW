




-- =============================================
-- Program:      FN_GET_NERP_DECODE_BY_INDEXES
-- Author:       김준규
-- Create date:  2025-06-29
-- Description:  NERP) 컨버전시 개발/운영디비 이름을 사용해야 되는데, 알려진 이름으로 할 경우 오해 소지 있음.(변형작업)
-- How to Execute: SELECT dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDDCMXDFFECVYB','2,5,6,8,11,13') 에스시엠디이브이
-- ==========================================================================================
-- 2025-06-29       김준규       NERP) 앞의 문자를 뒤의 숫자위치에 있는 문자를 골라서 리턴한다.
---------------------------------------------------------------------------------------------

CREATE   FUNCTION [dbo].[FN_GET_NERP_DECODE_BY_INDEXES]
(
       @P_INPUTVALUES NVARCHAR(MAX)  -- 난독화된 원본 문자열
      ,@P_INDEXES_LIST NVARCHAR(MAX) -- 유효한 문자의 인덱스 (쉼표로 구분, 예: '1,4,5,7,8,10')
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @DecodedString NVARCHAR(MAX) = '';
    DECLARE @StartIndex INT = 1;
    DECLARE @EndIndex INT;
    DECLARE @CurrentIndex INT;

    -- 유효 인덱스 리스트가 비어있으면 빈 문자열 반환
    IF @P_INDEXES_LIST IS NULL OR LTRIM(RTRIM(@P_INDEXES_LIST)) = ''
        RETURN '';

    -- 유효 인덱스를 순회하며 문자열 조합
    WHILE @StartIndex <= LEN(@P_INDEXES_LIST)
    BEGIN
        SET @EndIndex = CHARINDEX(',', @P_INDEXES_LIST, @StartIndex);

        IF @EndIndex = 0
            SET @EndIndex = LEN(@P_INDEXES_LIST) + 1;

        -- 현재 인덱스 추출 (문자열 -> 정수 변환)
        SET @CurrentIndex = CAST(SUBSTRING(@P_INDEXES_LIST, @StartIndex, @EndIndex - @StartIndex) AS INT);

        -- 유효 인덱스가 원본 문자열 길이를 벗어나지 않는지 확인 (방어적 코드)
        IF @CurrentIndex > 0 AND @CurrentIndex <= LEN(@P_INPUTVALUES)
        BEGIN
            SET @DecodedString = @DecodedString + SUBSTRING(@P_INPUTVALUES, @CurrentIndex, 1);
        END

        SET @StartIndex = @EndIndex + 1;
    END

    RETURN @DecodedString;
END;


