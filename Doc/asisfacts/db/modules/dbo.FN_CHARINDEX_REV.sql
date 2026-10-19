CREATE FUNCTION [dbo].[FN_CHARINDEX_REV]
(
  @P_STR1 VARCHAR(2000)
 ,@P_STR2 VARCHAR(2000)
 ,@P_START_LOC BIGINT = 0
)
/*
 * Program ID   : FN_CHARINDEX_REV
 * Description  : 특정 문자열에서 해당 문자 또는 문자열이 처음 나오는 위치를 반환(뒤에서부터)
 * Parameter    : 문자열 , 찾는 문자 , 검색 시작 위치(뒤에서부터)
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.19   김재정         Initial Release 
 *
 */
RETURNS BIGINT
AS
BEGIN
 
 DECLARE @I BIGINT;
 DECLARE @S1 VARCHAR(2000);
 
 DECLARE @V_STR1_LEN BIGINT;
 DECLARE @V_STR2_LEN BIGINT;
 
 IF @P_STR1 IS NULL OR @P_STR1 = '' BEGIN
  RETURN 0;
 END
 
 IF @P_STR2 IS NULL OR @P_STR2 = '' BEGIN
  RETURN 0;
 END
 
 SET @V_STR1_LEN = LEN(@P_STR1);
 SET @V_STR2_LEN = LEN(@P_STR2);
 
 SET @I = @V_STR1_LEN - @V_STR2_LEN + 1;

 IF @P_START_LOC <> 0 AND @I > @P_START_LOC BEGIN
  SET @I = @P_START_LOC;
 END

 WHILE @I > 0 BEGIN
  SET @S1 = SUBSTRING(@P_STR1, @I, @V_STR2_LEN);

  IF @S1 = @P_STR2 BEGIN
   BREAK;
  END
  
  SET @I = @I - 1;
 END
 
 RETURN @I;
 
END
