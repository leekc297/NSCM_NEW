
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM
 * Description  : RTF 준수율 Weekly 조회 I/F 제공뷰에서 호출
 * Program History
 *===================================================================================================
 *  Date        In Charge       Description
*===================================================================================================
* 2022.07.12	chaan       V1.0.0  Inititialize
* 2022/08/09    chaan		V1.0.1  DM기준 biz_type => operation_group 으로 변경
* 2022/08/24    chaan		V1.1.1  INSERT, EXEC 중첩에러 회피를 위해 SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY 수정
* 2022/12/01    chaan		V1.1.2  I/F 테이블 전환을 위해 전/당주 구분 파라미터 추가
* 2022/12/08    chaan		V1.1.3  집계누락 수정
**************************************************************************************************
*/
--CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM]
CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM]
(
      @p_division   NVARCHAR(30)    = N''
    , @p_yyyy       NVARCHAR(4)     = N''
    , @p_ww         NVARCHAR(2)     = N''
)
AS
BEGIN
    SET NOCOUNT ON
    SET ANSI_NULLS ON
    SET ANSI_WARNINGS ON

    --DECLARE     @p_division     NVARCHAR(30)    = N'82';
    --DECLARE     @p_yyyy         NVARCHAR(6)     = N'2022';
    --DECLARE     @p_ww           NVARCHAR(6)     = N'02';
    
    DECLARE     @v_thisyear     NVARCHAR(4)     = SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 1, 4);
    
    DECLARE     @v_if_yn        NVARCHAR(12)    = N'Y';
    DECLARE     @v_week         NVARCHAR(12)    = N'';
    DECLARE     @v_isoyyyymmww  NVARCHAR(8)     = N'';

    IF @p_yyyy = '' OR @p_yyyy IS NULL OR @p_ww = '' OR @p_ww IS NULL
    BEGIN
        SELECT    @v_week           = MAX(A.YYYYMMDD + '-' + B.WEEK_NAME)
        --SELECT  MAX(A.YYYYMMDD + '-' + B.WEEK_NAME)
        FROM    DM_MST_VERSION A
                JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON  
                    A.YYYYMMDD = B.BASIS_YYYYMMDD
        WHERE   1=1
                AND A.VERSION_TYPE = 'MF_W'
                AND SUBSTRING(A.YYYYMMDD, 1, 4) = @v_thisyear
                AND A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'SUN')), 112) --당해년도 조회시 현재 기준 전주까지만 조회되도록 수정
    END
    ELSE
    BEGIN
        SELECT    @v_week           = MAX(A.YYYYMMDD + '-' + B.WEEK_NAME)
        --SELECT  MAX(A.YYYYMMDD + '-' + B.WEEK_NAME)
        FROM    DM_MST_VERSION A
                JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON  
                    A.YYYYMMDD = B.BASIS_YYYYMMDD
        WHERE   1=1
                AND A.VERSION_TYPE = 'MF_W'
                AND SUBSTRING(A.YYYYMMDD, 1, 4) = @p_yyyy
                AND B.WEEK_NAME = N'W' + @p_ww
                AND A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'SUN')), 112) --당해년도 조회시 현재 기준 전주까지만 조회되도록 수정
        GROUP BY B.WEEK_NAME
    END;

    SELECT TOP 1
            @v_isoyyyymmww           = A.ISO_YYYYMM + SUBSTRING(A.ISO_YYYYWW, 5, 2)
    --SELECT  MAX(A.YYYYMMDD + '-' + B.WEEK_NAME)
    FROM    SCM_SYS_CALENDAR_M A WITH(NOLOCK)
    WHERE   1=1
            AND SUBSTRING(A.ISO_YYYYMM, 1, 4) = @p_yyyy
            AND SUBSTRING(A.ISO_YYYYWW, 5, 2) = @p_ww;

--print '@v_isoyyyymmww : ' + @v_isoyyyymmww;return;

    EXEC SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_FOR_SUM
          @p_division        -- @p_division_id          NVARCHAR(30)
        , @v_week            -- @p_week                 NVARCHAR(50)
        , N'iamarock'        -- @p_created_by           NVARCHAR(4000)
        , N'T'               -- @p_is_pre_week          NVARCHAR(50)
    
    EXEC SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_FOR_SUM
          @p_division        -- @p_division_id          NVARCHAR(30)
        , @v_week            -- @p_week                 NVARCHAR(50)
        , N'iamarock'        -- @p_created_by           NVARCHAR(4000)
        , N'F'               -- @p_is_pre_week          NVARCHAR(50)


--TESTING : NOK
--select * from SCP_RPT_RTF_ARC where DIVISION_ID = '82' and ISO_YYYYMMWW    <= '20220301';

END
