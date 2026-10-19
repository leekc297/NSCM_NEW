CREATE   PROCEDURE [dbo].[PR_ETL_SYNC_DELETE_ALL_IN_ONE]
    @TableName      VARCHAR(128),       		-- [필수] 삭제 대상 테이블명
--    @DateColumnName VARCHAR(128),				-- [필수] 날짜/주차 컬럼명 ('YYYYMMDD', 'PLAN_WEEK', 'SALES_POSTING_DATE') --DM_PLN_MKT_FCST_RESULT_C 하나 때문에 날짜를 필수로 할수가 없네???
--    @DateMode       VARCHAR(10),				-- [필수] 날짜 조건 모드 ('EQ', 'GE', 'RANGE')
--    @Ymd            VARCHAR(20),				-- [필수] 기준 날짜/주차 값 1
    @DivMode        VARCHAR(10),     			-- [필수] DIVISION 조건 모드 ('EQ', 'IN', 'LIKE')
    @DivValue       NVARCHAR(1000),     		-- [필수] DIVISION 조건 값
	@DateColumnName VARCHAR(128)	= NULL,		-- [선택] 날짜/주차 컬럼명 ('YYYYMMDD', 'PLAN_WEEK', 'SALES_POSTING_DATE')
    @DateMode       VARCHAR(10)		= NULL,		-- [선택] 날짜 조건 모드 ('EQ', 'GE', 'RANGE')
    @Ymd            VARCHAR(20)		= NULL,		-- [선택] 기준 날짜/주차 값 1
    @Ymd2           VARCHAR(20)  	= NULL,		-- [선택] 기준 날짜/주차 값 2
    @MeasMode       VARCHAR(10)		= NULL,     -- [선택] MEASURE 조건 모드 ('EQ', 'IN', 'LIKE')
    @MeasValue      NVARCHAR(1000)	= NULL,     -- [선택] MEASURE 조건 값
    @VersionNo      VARCHAR(50)  	= NULL 		-- [선택] VERSION_NO 값
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- 런타임 에러 발생 시 자동 롤백 활성화

  
    -- 1. 안전 장치 및 쿼리 변수 선언
    DECLARE @SafeTableName NVARCHAR(256) = QUOTENAME(@TableName);
    --DECLARE @SafeDateCol   NVARCHAR(256) = CASE WHEN @DateColumnName IS NOT NULL THEN QUOTENAME(@DateColumnName) ELSE NULL END;
    DECLARE @SafeDateCol   NVARCHAR(256);
    IF @DateColumnName IS NOT NULL
		SET @SafeDateCol = QUOTENAME(@DateColumnName);
    ELSE
    	SET @SafeDateCol = NULL;

    DECLARE @Sql NVARCHAR(MAX);
    
    -- 로그 기록용 변수
    DECLARE @LogSeq BIGINT;
    DECLARE @DeletedRows INT = 0;

    -- 2. 실행 로그 시작 기록
	DECLARE @CombinedData NVARCHAR(MAX);
    
    IF @DateColumnName IS NOT NULL
    BEGIN
    	IF @DateColumnName = 'YYYYMMDD'
    		IF @DateMode = 'EQ'
    			SET @Ymd = CONVERT(CHAR(8), DATEADD(DD,-7, dbo.FN_NEXT_DAY(GETDATE(),'MON')), 112);
    		ELSE IF @DateMode = 'GE'
    			SET @Ymd = CONVERT(CHAR(8), DATEADD(DD,-7, dbo.FN_NEXT_DAY(GETDATE(),'MON')), 112);
			ELSE IF @DateMode = 'RANGE'
				SET @Ymd = CONVERT(CHAR(8), DATEADD(DD,-7*2, dbo.FN_NEXT_DAY(GETDATE(),'MON')), 112);
				SET @Ymd2 = CONVERT(CHAR(8), DATEADD(DD,-7, dbo.FN_NEXT_DAY(GETDATE(),'MON')), 112);
    END
    
    SET @CombinedData = CONCAT(
		'DivMode:', 	@DivMode, ' | ',
		'DivValue:', 	@DivValue, ' | ',
        'DateColumnName:', @DateColumnName, ' | ',
        'DateMode:', 	@DateMode, ' | ',
		'Ymd:', 	 	@Ymd, ' | ',
		'Ymd2:', 	 	@Ymd2, ' | ',
		'MeasMode:', 	@MeasMode, ' | ',
		'MeasValue:', 	@MeasValue, ' | ',
        'VersionNo:', 	@VersionNo
    );

    INSERT INTO [dbo].[TB_SYNC_DELETE_EXEC_LOG] ([TABLE_NAME], [START_TIME], [STATUS], [IN_PARAM])
    VALUES (@TableName, GETDATE(), 'RUNNING', @CombinedData);
    
    SET @LogSeq = SCOPE_IDENTITY(); -- 방금 생성된 로그 PK 값 보관

    -- 3. 동적 쿼리 문장 조립
    SET @Sql = N'DELETE FROM ' + @SafeTableName + N' WHERE 1=1 ' + CHAR(13);

    -- DIVISION_ID 조건 조립
    IF @DivMode = 'EQ'
        SET @Sql = @Sql + N'  AND DIVISION_ID = @pDivValue ' + CHAR(13);
    ELSE IF @DivMode = 'IN'
        SET @Sql = @Sql + N'  AND DIVISION_ID IN (SELECT TRIM(token) FROM STRING_SPLIT(@pDivValue, '','')) ' + CHAR(13);
    ELSE IF @DivMode = 'LIKE'
        SET @Sql = @Sql + N'  AND DIVISION_ID LIKE @pDivValue ' + CHAR(13);

    -- 날짜/주차 조건 조립
    IF @DateColumnName IS NOT NULL
    BEGIN
        IF @DateMode = 'EQ'
			SET @Sql = @Sql + N'  AND ' + @SafeDateCol + N' = @pYmd ' + CHAR(13);
		ELSE IF @DateMode = 'GE'
            SET @Sql = @Sql + N'  AND ' + @SafeDateCol + N' >= @pYmd ' + CHAR(13);
        ELSE IF @DateMode = 'RANGE'
            SET @Sql = @Sql + N'  AND ' + @SafeDateCol + N' >= @pYmd AND ' + @SafeDateCol + N' < @pYmd2 ' + CHAR(13);
    END

    -- MEASURE 조건 조립
    IF @MeasMode = 'EQ'
        SET @Sql = @Sql + N'  AND MEASURE = @pMeasValue ' + CHAR(13);
    ELSE IF @MeasMode = 'IN'
        BEGIN
    	SET @Sql = @Sql + N'  AND MEASURE IN (SELECT LTRIM(RTRIM(token)) FROM STRING_SPLIT(@pMeasValue, '','')) ' + CHAR(13);
		END
    ELSE IF @MeasMode = 'LIKE'
        SET @Sql = @Sql + N'  AND MEASURE LIKE @pMeasValue ' + CHAR(13);


    IF @VersionNo IS NOT NULL
        SET @Sql = @Sql + N'  AND VERSION_NO = @pVersionNo ' + CHAR(13);


    -- 4. 트랜잭션 시작 및 쿼리 실행
    BEGIN TRY
        --Master Procedure 에서 호출시 주석처리
		BEGIN TRAN;


/*    
    	-- 동적 쿼리 실행
        EXEC sp_executesql @Sql,
            N'@pDivValue NVARCHAR(500), @pYmd VARCHAR(500), @pYmd2 VARCHAR(500), @pMeasValue NVARCHAR(500), @pVersionNo VARCHAR(500)',
            @pDivValue = @DivValue,
            @pYmd      = @Ymd,
            @pYmd2     = @Ymd2,
			@pMeasValue = @MeasValue,
            @pVersionNo = @VersionNo;

        -- 현재 세션에서 삭제된 총 건수 확보
        SET @DeletedRows = @@ROWCOUNT;
*/
------------------------------------------------------

------------------------------------------------------  
-- [1] 실제 쿼리 위쪽에 탑재할 매개변수 선언 및 대입문 조립
DECLARE @DebugHeader NVARCHAR(MAX);
SET @DebugHeader = N'
DECLARE @pDivValue NVARCHAR(1000) = ' + ISNULL(N'''' + @DivValue + N'''', N'NULL') + N';
DECLARE @pYmd VARCHAR(20)         = ' + ISNULL(N'''' + @Ymd + N'''', N'NULL') + N';
DECLARE @pYmd2 VARCHAR(20)        = ' + ISNULL(N'''' + @Ymd2 + N'''', N'NULL') + N';
DECLARE @pMeasure VARCHAR(50)     = ' + ISNULL(N'''' + @MeasValue + N'''', N'NULL') + N';
DECLARE @pVersionNo VARCHAR(50)   = ' + ISNULL(N'''' + @VersionNo + N'''', N'NULL') + N';
' + CHAR(13) + CHAR(10);

-- [2] 최종 쿼리 문자열 출력 (PRINT의 4000자 제한을 피하기 위해 SELECT 사용 권장)
SELECT @DebugHeader + @Sql AS [Debug_SQL_Statement];


------------------------------------------------------  


    	--Master Procedure 에서 호출시 주석처리
		COMMIT TRAN;

        -- 5. 성공 로그 업데이트
        UPDATE [dbo].[TB_SYNC_DELETE_EXEC_LOG]
        SET [END_TIME]      = GETDATE(),
            [STATUS]        = 'SUCCESS',
            [DEL_ROW_COUNT] = @DeletedRows
        WHERE [LOG_SEQ] = @LogSeq;

    END TRY
    BEGIN CATCH
        
		--Master Procedure 에서 호출시 주석처리
		-- 에러 발생 시 즉시 롤백
        IF @@TRANCOUNT > 0 
            ROLLBACK TRAN;

        -- 6. 실패 로그 업데이트 (오류 메시지 기록)
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        
        UPDATE [dbo].[TB_SYNC_DELETE_EXEC_LOG]
        SET [END_TIME]  = GETDATE(),
            [STATUS]    = 'FAIL',
            [ERROR_MSG] = @ErrorMessage
        WHERE [LOG_SEQ] = @LogSeq;

        -- 상위 시스템(ETL 또는 스케줄러)이 실패를 감지할 수 있도록 에러를 다시 던짐
        --DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        --DECLARE @ErrorState INT = ERROR_STATE();
        --RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;