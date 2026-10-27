

/*  
 * Program ID   : FN_SplitString                                                               
 * Description  : 기존 fn_scm_split 함수 속도 문제 때문에 TABLE 변수 FN_SplitString 생성함.
 * 실행 예제    : SELECT * FROM dbo.FN_SplitString('AJRJR0101A::acer::acer_TW_BAL~A01::E::MPS::NF::20180824::NOPLANT','::')
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.08.22  KTH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트   
 * 2020.03.12  KTH       @String 타입 변경 NVARCHAR(4000) --> NVARCHAR(MAX)
 *                                                                                                    
*/  
--DROP FUNCTION [dbo].[SplitString]
CREATE FUNCTION [dbo].[FN_SplitString]
(
     @String    NVARCHAR(MAX)
    ,@Delimiter NVARCHAR(10)
)
RETURNS TABLE
AS


RETURN
(
  

    WITH Split(stpos,endpos)
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT CONVERT(INT, endpos+LEN(@Delimiter)), CHARINDEX(@Delimiter,@String,endpos+LEN(@Delimiter))
          FROM Split
         WHERE endpos > 0
    )
    SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        'Value' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+LEN(@Delimiter))-stpos)
    FROM Split
)
