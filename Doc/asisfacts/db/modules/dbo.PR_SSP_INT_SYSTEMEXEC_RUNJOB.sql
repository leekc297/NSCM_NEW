

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
CREATE PROCEDURE [dbo].[PR_SSP_INT_SYSTEMEXEC_RUNJOB]
    @P_JOBID    NVARCHAR(100) = ''
WITH RECOMPILE
AS
BEGIN

    SET NOCOUNT ON;

    --###########################################
    --선언
    --###########################################
    DECLARE @V_EXECRSLTCODE     VARCHAR(50);
    DECLARE @V_EXECDTTM         DATETIME;
    DECLARE @V_EXECDTTM2        DATETIME;
    DECLARE @V_NEXTEXECDTTM     DATETIME;
    DECLARE @V_INQUIRYSTARTDTTM DATETIME;
    DECLARE @V_INQUIRYENDDTTM   DATETIME;
    DECLARE @V_ERRMSG           NVARCHAR(3000);

    DECLARE @C_JOBID            VARCHAR(50);
    DECLARE @C_SPNAME           VARCHAR(50);
    DECLARE @C_EXECCLCVAL       VARCHAR(50);
    DECLARE @C_EXECCLCTYPE      VARCHAR(50);
    DECLARE @C_EXECSTAT         VARCHAR(50);
    DECLARE @C_FIRSTEXECDTTM    DATETIME;
    DECLARE @C_LTSEXECDTTM      DATETIME;
    DECLARE @C_NEXTEXECDTTM     DATETIME;
    DECLARE @C_INQUIRYSTARTDTTM DATETIME;
    DECLARE @C_INQUIRYENDDTTM   DATETIME;

    DECLARE @O_ERRFLAG          VARCHAR(50);
    DECLARE @O_ERRDESC          NVARCHAR(3000);


    /*****************************************************************************************************************
    *-- 배치 조회
    *--    시스템 예약 실행 테이블에서 실행 중에 있지 않고 다음 실행 일시가 현재 시각보다 이전인 목록을 조회
    *--    SSP_INT_SYSTEMEXE.EXECSTAT의 값이 'Y'이면 실행 중, 'N'이면 대기 중임.
    *--    실행 중(EXECSTAT = 'Y')이어도 NEXTEXECDTTM(다음 실행 일시)의 값이 현 시점을 30분 초과하였으면
    *--    비정상 종료(실행 중일 때 윈도우 서비스 중단, 타임 아웃 등)되었던 것으로 판단하여 실행 대상에 포함함.
    *--    정상 실행 중인 경우라면 BizActor의 Timeout 설정, DB의 Timeout 설정 등에 의해
    *--    다음 실행 일시를 30분 초과하여 실행 중일 수 없다고 전제함 (Timeout 시간은 설정에 따라 다를 수 있음).
    ******************************************************************************************************************/
    --###########################################
    --선처리
    --###########################################
    IF (SELECT CURSOR_STATUS('GLOBAL','CUR_SYSTEMEXEC_RUN')) >= -1
    BEGIN
        IF (SELECT CURSOR_STATUS('GLOBAL','CUR_SYSTEMEXEC_RUN')) > -1
        BEGIN
            CLOSE CUR_SYSTEMEXEC_RUN
        END
        DEALLOCATE CUR_SYSTEMEXEC_RUN
    END


    --###########################################
    --본처리
    --###########################################
    DECLARE CUR_SYSTEMEXEC_RUN CURSOR
    FOR
    SELECT JOBID
          ,SPNAME
          ,EXECCLCVAL
          ,EXECCLCTYPE
          ,EXECSTAT
          ,FIRSTEXECDTTM
          ,LTSEXECDTTM
          ,ISNULL(NEXTEXECDTTM, GETDATE()) AS NEXTEXECDTTM
          ,INQUIRYSTARTDTTM
          ,INQUIRYENDDTTM
      FROM dbo.SSP_INT_SYSTEMEXE (NOLOCK)
     WHERE USEYN = 'Y'
       AND CASE WHEN EXECSTAT = 'N'                                                    THEN 'Y'
                WHEN EXECSTAT = 'Y' AND DATEDIFF(MINUTE, NEXTEXECDTTM, GETDATE()) > 30 THEN 'Y'
                END = 'Y'
       AND CASE WHEN NEXTEXECDTTM <= GETDATE() THEN 'Y'
                WHEN NEXTEXECDTTM IS NULL      THEN 'Y'
                END = 'Y'
       AND JOBID  LIKE @P_JOBID + '%'
       AND SP_GROUP = 'SSP'
     ORDER BY
           ORDER_NUM


    OPEN CUR_SYSTEMEXEC_RUN

    SET @C_JOBID            = NULL;
    SET @C_SPNAME           = NULL;
    SET @C_EXECCLCVAL       = NULL;
    SET @C_EXECCLCTYPE      = NULL;
    SET @C_EXECSTAT         = NULL;
    SET @C_INQUIRYSTARTDTTM = NULL;
    SET @C_INQUIRYENDDTTM   = NULL;
    SET @O_ERRFLAG          = NULL;
    SET @O_ERRDESC          = NULL;

    FETCH NEXT FROM CUR_SYSTEMEXEC_RUN
     INTO @C_JOBID
         ,@C_SPNAME
         ,@C_EXECCLCVAL
         ,@C_EXECCLCTYPE
         ,@C_EXECSTAT
         ,@C_FIRSTEXECDTTM
         ,@C_LTSEXECDTTM
         ,@C_NEXTEXECDTTM
         ,@C_INQUIRYSTARTDTTM
         ,@C_INQUIRYENDDTTM

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        SET @V_EXECRSLTCODE     = 'F';
        SET @V_EXECDTTM         = GETDATE() ;
        SET @V_NEXTEXECDTTM     = NULL;
        SET @V_INQUIRYSTARTDTTM = NULL;
        SET @V_INQUIRYENDDTTM   = NULL;
        SET @V_ERRMSG           = N'';

        --1) 다음 실행 일시
        SELECT @V_NEXTEXECDTTM = dbo.FN_GET_SSP_INT_JOBNEXTTIME(@C_EXECCLCVAL, @C_EXECCLCTYPE, @V_EXECDTTM,@C_FIRSTEXECDTTM)

        --2) 현재 실행 일시 변경
        UPDATE dbo.SSP_INT_SYSTEMEXE
           SET EXECSTAT		= 'Y'
              ,CUREXECDTTM	= @V_EXECDTTM
         WHERE JOBID		= @C_JOBID

        --3) 프로시저 실행
        EXEC @C_SPNAME @C_JOBID, @O_ERRFLAG OUTPUT, @O_ERRDESC OUTPUT

        SET @V_EXECRSLTCODE = CASE WHEN @O_ERRFLAG = 'N' THEN 'S'
                                   WHEN @O_ERRFLAG = ''  THEN 'S'
                                   ELSE 'F'
                              END
        SET @V_ERRMSG = @O_ERRDESC;
        SET @V_EXECDTTM2 = GETDATE();

        --4) 실행결과 변경
        IF @V_EXECRSLTCODE = 'S'
        BEGIN
            SELECT @V_INQUIRYSTARTDTTM	= INQUIRYSTARTDTTM
                  ,@V_INQUIRYENDDTTM	= INQUIRYENDDTTM
              FROM dbo.SSP_INT_SYSTEMEXE (NOLOCK)
             WHERE JOBID = @C_JOBID

			UPDATE dbo.SSP_INT_SYSTEMEXE
			   SET EXECSTAT			= 'N'
				  ,FIRSTEXECDTTM	= ISNULL(FIRSTEXECDTTM, @V_EXECDTTM2)
				  ,LTSEXECDTTM		= @V_EXECDTTM
				  ,CUREXECDTTM		= NULL
				  ,NEXTEXECDTTM		= @V_NEXTEXECDTTM
				  ,UPDUSERID		= 'ssp_batch'
				  ,UPDDTTM			= @V_EXECDTTM2
			WHERE JOBID				= @C_JOBID

        END
        ELSE
        BEGIN
            SET @V_INQUIRYSTARTDTTM = @C_INQUIRYENDDTTM
            SET @V_INQUIRYENDDTTM   = NULL ;
        END
        ;

        --5) 실행로그 기록
        EXEC PR_SSP_INT_SYSTEMEXECLOG @C_JOBID
                                     ,@V_EXECDTTM
                                     ,@V_EXECDTTM2
                                     ,@V_EXECRSLTCODE
                                     ,@V_ERRMSG
                                     ,@V_INQUIRYSTARTDTTM
                                     ,@V_INQUIRYENDDTTM

        FETCH NEXT FROM CUR_SYSTEMEXEC_RUN
         INTO @C_JOBID
             ,@C_SPNAME
             ,@C_EXECCLCVAL
             ,@C_EXECCLCTYPE
             ,@C_EXECSTAT
             ,@C_FIRSTEXECDTTM
             ,@C_LTSEXECDTTM
             ,@C_NEXTEXECDTTM
             ,@C_INQUIRYSTARTDTTM
             ,@C_INQUIRYENDDTTM
    END


    --###########################################
    --후처리
    --###########################################
    IF (SELECT CURSOR_STATUS('GLOBAL','CUR_SYSTEMEXEC_RUN')) >= -1
    BEGIN
        IF (SELECT CURSOR_STATUS('GLOBAL','CUR_SYSTEMEXEC_RUN')) > -1
        BEGIN
            CLOSE CUR_SYSTEMEXEC_RUN
        END
        DEALLOCATE CUR_SYSTEMEXEC_RUN
    END

    RETURN
END


