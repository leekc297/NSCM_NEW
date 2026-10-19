
-- 저장 프로시저 생성: 오류를 로그 테이블에 기록
CREATE PROCEDURE LogError
AS
BEGIN
    INSERT INTO ErrorLog
    (
        ErrorNumber, 
        ErrorMessage, 
        ErrorSeverity, 
        ErrorState, 
        ErrorProcedure, 
        ErrorLine
    )
    VALUES
    (
        ERROR_NUMBER(), 
        ERROR_MESSAGE(), 
        ERROR_SEVERITY(), 
        ERROR_STATE(), 
        ERROR_PROCEDURE(), 
        ERROR_LINE()
    );
END;
