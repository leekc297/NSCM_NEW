

/*  
 * Program ID   : FN_SplitString                                                               
 * Description  : 기존 fn_scm_split 함수 속도 문제 때문에 TABLE 변수 FN_SplitString 생성함.
 * 실행 예제    : SELECT * FROM dbo.FN_SplitString('AJRJR0101A::acer::acer_TW_BAL~A01::E::MPS::NF::20180824::NOPLANT','::')
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.08.22  KTH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트   
 * 2020.03.12  KTH       @Stringing 타입 변경 NVARCHAR(4000) --> NVARCHAR(MAX)
 * 2024.08.02  KSK       MAXRECUSION 횟수제한(최대 100건)을 해제하기 위하여 로직 변경                                                                                                
*/  
CREATE FUNCTION [dbo].[FN_SplitString]
(
     @String    NVARCHAR(MAX)
    ,@Delimiter NVARCHAR(10)
)
RETURNS @RtnValue TABLE ( ID INT IDENTITY(1, 1) , VALUE NVARCHAR(100) ) 
AS 
BEGIN
  DECLARE @Idx INT
  DECLARE @FoundIdx INT 
  SET @Idx = 1
  SET @FoundIdx = CHARINDEX(@Delimiter, @String)
  WHILE (@FoundIdx > 0)
  BEGIN 
    INSERT INTO @RtnValue (VALUE)
    SELECT LTRIM(RTRIM(SUBSTRING(@String, 1, @FoundIdx - 1))) 
    SET @String = SUBSTRING(@String, @FoundIdx + 1, len(@String) - @FoundIdx)
    SET @Idx = @Idx + 1 
    SET @FoundIdx = CHARINDEX(@Delimiter, @String)
  END
  INSERT INTO @RtnValue (VALUE)
  SELECT LTRIM(RTRIM(@String)) 

  RETURN 
END 
