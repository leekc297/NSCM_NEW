

/***************************************************************************************************
 * Program ID   : PR_SSP_INT_SYSTEMEXEC_RUNJOB 
 * Description  : 
 * OutTable     : 
 * Execute      : EXEC PR_SSP_INT_SYSTEMEXEC_RUNJOB
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.10.01   SSP Pjt.       Create.
****************************************************************************************************/
CREATE FUNCTION [dbo].[FN_GET_SSP_INT_JOBNEXTTIME]
(
	@I_EXECCLCVAL                                  INTEGER,
	@I_EXECCLCTYPE                                 VARCHAR(40),
	@I_CURTIME                                     DATETIME,
	@I_FIRSTTIME                                   DATETIME
)
RETURNS DATETIME
AS
BEGIN
		
    DECLARE @V_NEXTTIME								DATETIME
    
    IF  @I_EXECCLCTYPE = 'MONTH'
    BEGIN 
      SET @V_NEXTTIME = DATEADD(MONTH, @I_EXECCLCVAL, @I_CURTIME)
    END
    ELSE IF @I_EXECCLCTYPE = 'DAY'
    BEGIN
	  SET @V_NEXTTIME = CONVERT(VARCHAR(10),DATEADD(DAY, @I_EXECCLCVAL, @I_CURTIME),120) + ' '+ CONVERT(VARCHAR,@I_FIRSTTIME,114)
      --SET @V_NEXTTIME = DATEADD(DAY, @I_EXECCLCVAL, @I_CURTIME)
    END
    ELSE IF @I_EXECCLCTYPE = 'HOUR'
    BEGIN
       SET @V_NEXTTIME = DATEADD(HOUR, @I_EXECCLCVAL, @I_CURTIME)
    END
   ELSE IF @I_EXECCLCTYPE = 'MINUTE'
    BEGIN
       SET @V_NEXTTIME = DATEADD(MINUTE, @I_EXECCLCVAL, @I_CURTIME)
    END    
    ELSE
    BEGIN
      SET @V_NEXTTIME = @I_CURTIME
    END
    
    -- 초를 00초로 바꿔서 지속적인 처리시간 유지를 위함.
	-- SELECT @V_NEXTTIME = CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(20), @V_NEXTTIME,20),1,17)+'00',20)
    -- 분:초를 00:00초로 바꿔서 지속적인 처리시간 유지를 위함. 2014.11.21 재수정
    SELECT @V_NEXTTIME = CONVERT(DATETIME, SUBSTRING(CONVERT(VARCHAR(20), @V_NEXTTIME ,20),1,16)+':00',20) 
    
	RETURN @V_NEXTTIME
END

