


--commit
--begin tran 
CREATE PROCEDURE [dbo].[CustomTableTest]
	   @PARAMC0C0			AS DBO.DMF0008       READONLY  
AS
BEGIN
		SET NOCOUNT ON;
			SET ANSI_WARNINGS OFF
	SET ARITHIGNORE ON
	SET ARITHABORT OFF
	SELECT * from @paramC0C0
	--insert into debug_profile_log (seq,name,reg_date) values (0,'kkk',getdate())



END
