---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0092_GET_WEEK_TERM
 * Description  : Week 에 해당하는 주시작일자, 종료일자 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
* 2022.05.20	chaan		Inititialize
 **************************************************************************************************
 */
 
CREATE PROCEDURE [dbo].[SCP0092_GET_WEEK_TERM]
--ALTER PROCEDURE [dbo].[SCP0092_GET_WEEK_TERM]
	@p_week_name                NVARCHAR(50)
AS  
BEGIN
    SET NOCOUNT ON;
    SET ANSI_NULLS ON
    SET ANSI_WARNINGS ON; 

    DECLARE @V_NOW_YYYYMMDD	NCHAR(8);

    SET @V_NOW_YYYYMMDD = CONVERT(CHAR(8), GETDATE(), 112);


    --파라미터가 널이면 오늘 기준 최근 날짜로 검색
    IF (@p_week_name IS NULL OR @p_week_name ='')
    BEGIN
        SELECT TOP(1)
                  C.BASIS_START_DATE
                , C.BASIS_END_DATE
        FROM    SCM_SYS_CALENDAR_M C
                INNER JOIN 
                    (
                        SELECT  MAX(ISO_YYYYWW) ISO_YYYYWW
                        FROM    SCM_SYS_CALENDAR_M
                        WHERE   1=1
                                AND BASIS_YYYYMMDD <= @V_NOW_YYYYMMDD
                    ) X ON C.ISO_YYYYWW = X.ISO_YYYYWW
    END
    ELSE
    BEGIN
        SELECT    C.BASIS_START_DATE
                , C.BASIS_END_DATE
        FROM    SCM_SYS_CALENDAR_M C
        WHERE   1=1
                AND C.BASIS_YYYYMMDD + '-' + C.WEEK_NAME = @p_week_name;
    END
END

