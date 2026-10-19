/****************************************************************************
  * PROJECT       : LG CHEM SCM REPORT.
  * FUNCTION NAME : FN_GET_VOC_SPLIT
  * DESCRIPTION   : SPLIT
  *
  * INPUT         : @strValue : 입력값
					@splitChar :구분자
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2022-02-21   vadabi3		INITIAL
  ****************************************************************************/

CREATE FUNCTION [dbo].[FN_GET_VOC_SPLIT] 
(
  @strValue VARCHAR(MAX) 
 ,@splitChar VARCHAR(10) 
) RETURNS @TB TABLE
  ( POS int IDENTITY PRIMARY KEY
  , VAL varchar(200) 
  )
  AS 
  /* - '' 값도 반환한다 
  - 마지막은 분리자로 끝낸다 
  SELECT * FROM dbo.[FN_GET_VOC_SPLIT]('2021-02-10\r\n2021-02-11\r\n2021-02-12','\r\n') A 
  */ 
  BEGIN 
  DECLARE @start SMALLINT 
         ,@last SMALLINT 
		 ,@count SMALLINT 
		 ,@splitCharSize SMALLINT 

		------------------------------------------------------------------
		-- 진행중인 경우만 체크 대상
		------------------------------------------------------------------
		IF @strValue IS NULL
		BEGIN
			RETURN;
		END
		 
		 SELECT @splitCharSize = LEN(@splitChar) 
		 
		 IF RIGHT(@strValue,@splitCharSize)!=@splitChar 
			 BEGIN 
			 SET @strValue=@strValue+@splitChar 
			 END 
		 
		 SET @strValue=@splitChar+@strValue 
		 SET @start = 1 
		 SELECT @last = CHARINDEX (@splitChar,@strValue ,@start+@splitCharSize) 
		 SET @count = 0 
		 
		 WHILE (1=1) 
			 BEGIN 
			 SET @start = CHARINDEX (@splitChar,@strValue ) 
			 SELECT @last = CHARINDEX (@splitChar,@strValue ,@start+@splitCharSize) 
			 IF @last <= 0 BREAK 
		 
			 INSERT INTO @TB(VAL) VALUES (SUBSTRING(@strValue,@start+@splitCharSize,@last-@start-@splitCharSize)) 
			 SELECT @strValue = STUFF(@strValue,@start,@splitCharSize,'') 
			 SET @count = @count + 1 
			 END 

		 RETURN 
		 END

