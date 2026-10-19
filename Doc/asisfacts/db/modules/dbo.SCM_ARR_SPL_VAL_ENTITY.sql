CREATE FUNCTION [dbo].[SCM_ARR_SPL_VAL_ENTITY]
(
 @sText		NVARCHAR(max),			-- 대상 문자열
 @str		NVARCHAR(max) = '|',		-- 구분기호(Default '|')
 @idx		INT                     -- 배열 인덱스
)
RETURNS NVARCHAR(MAX)
AS

BEGIN
 -- SCM_ARR_SPL_VAL과 차이점은 ESCAPE 문자의 처리에 관한 것이다
 -- SCM_ARR_SPL_VAL은 aaa&hat;aaa^bbb&hat;bbb에 대해 INDEX 0, 1을 aaa&hat;aaa과 bbb&hat;bbb 값으로 리턴하나
 -- [SCM_ARR_SPL_VAL_ENTITY]는 aaa^aaa와 bbb^bbb로 리턴한다. 그 효과로서 SCM_ARR_SPL_VAL_ENTITY은 구분기호(^)를 처리할 수 있다
 -- 따라서 SCM_ARR_SPL_VAL_ENTITY 함수는 다중 루프가 진행될 경우(예를들어 a#a^a#b를 {{a}{a}},{{a},{b}}로 파싱할때 사용하면 엔티티 # (&sharp)을 치환하여
 -- 2단계 파싱에 실패할 것이다. 항상 더이상 하위 파싱을 하지 않을 때(하위에서 SCM_ARR_SPL_VAL 또는 SCM_ARR_SPL_VAL_ENTITY를 사용하지 않을 때)
 -- SCM_ARR_SPL_VAL_ENTITY를 사용한다
 -- 다음 ENTITY(루프에 사용하는 탈출문자에 해당)를 지원하고, 현재 FP에서 동적파라미터(^)의 bucket 튜플(:) 구조체(#) 목록(!) 정보를 처리할 때 사용된다

 -- 지원 ENTITY 목록
 -- ^ -> &hat;( &#94;은 지원하지 않는다)  동적 파라미터
--! -> &excl;( &#33;은 지원하지 않는다) 파라미터내 리스트
--# -> &sharp; (&#9839;은 지원하지 않는다) 리스트 항목 내 리스트(구조체)
--: -> &colon; (&#58;은 지원하지 않는다) 리스트 항목 내 키:값
 DECLARE @word    NVARCHAR(max);		-- 반환할 문자
 DECLARE @sTextData  NVARCHAR(max); 
 DECLARE @num    INT;
      
 SET @num = 1;
 SET @str = LTRIM(RTRIM(@str));
 SET @sTextData = LTRIM(RTRIM(@sText)) + @str; 
  
 WHILE @idx >= @num
 BEGIN
  IF CHARINDEX(@str, @sTextData) > 0
  BEGIN
   -- 문자열의 인덱스 위치의 요소를 반환
   SET @word = SUBSTRING(@sTextData, 1, CHARINDEX(@str, @sTextData) - 1);
   SET @word = LTRIM(RTRIM(@word));
 
   -- 반환된 문자는 버린후 좌우공백 제거   
   SET @sTextData = LTRIM(RTRIM(RIGHT(@sTextData, LEN(@sTextData) - (LEN(@word) + 1))))
  END ELSE BEGIN
   SET @word = '';
  END
  SET @num = @num + 1
 END

 SET @word =  [dbo].[SCM_ARR_SPL_VAL]( @word,':', 2)   
 SET @word = ISNULL(@word,'')
 SET @word = REPLACE(@word,N'&hat;','^')
 SET @word = REPLACE(@word,N'&excl;','!')
 SET @word = REPLACE(@word,N'&sharp;','#')
 SET @word = REPLACE(@word,N'&colon;',':')

 RETURN(@word);
END
