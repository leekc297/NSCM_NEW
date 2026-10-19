DECLARE @runstart datetime
        DECLARE @runend datetime
        SET @runstart = GetDate()
        SET @runend = GetDate()

        exec PR_UI_SQL_LOG @LOGTYPE,  @USER_ID,'','',@NOTE,'',@runstart, @runend