


--commit
--begin tran 
CREATE PROCEDURE [dbo].[MYCONJURE]
@name AS VARCHAR(100) = 1,
	   @PARAM			AS DBO.DMF0008       READONLY  ,
	   @PARAM1			AS DBO.DMF0008       READONLY  ,
	   @PARAM2			AS DBO.DMF0008       READONLY  ,
	   @PARAM3			AS DBO.DMF0008       READONLY  
AS
BEGIN
		SET NOCOUNT ON;
			SET ANSI_WARNINGS OFF
	SET ARITHIGNORE ON
	SET ARITHABORT OFF
	SELECT @name AS 'KKK'
	SELECT * from @PARAM1
	--insert into debug_profile_log (seq,name,reg_date) values (0,'kkk',getdate())



END
