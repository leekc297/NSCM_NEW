/* ===================================================================
    -- 프로시저 영문명        : SP_SCM_BCM_C_DPUMP_EXEC_QUERY
    -- 프로시저 국문설명      : 데이타펌프(DPUMP) 동적조회 SQL 생성
    -- 프로시저 버전          : V1.0
    -- 최초 작성일            : 2020-01-
    -- 최초 작성자            : 강철구
    -- 매개변수               : 없음
    -- 실행예시               : EXEC SP_SCM_BCM_C_DPUMP_EXEC_QUERY <SQL string>
    -- 수정 이력              : Data Pump 시스템 연계 관련 : 20200701 SCM PI 요청                     
   =================================================================== */
CREATE PROCEDURE [dbo].[SP_SCM_BCM_C_DPUMP_EXEC_QUERY]
	@QUERY		VARCHAR(MAX)
WITH EXEC AS CALLER
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	-- 프로시저 상의 모든 SELECT 문에 WITH NOLOCK 옵션을 생성
  
	BEGIN TRY
		BEGIN
			-- SQL 실행
			EXEC (@QUERY);
		END
		
print '> 정상 완료';
		RETURN 0;
	END TRY

	BEGIN CATCH	
		DECLARE @ERR_MSG  NVARCHAR(MAX) = ERROR_MESSAGE();
		PRINT @ERR_MSG;

		SELECT 
			  '-1'					AS ERR_CD
			, '' + @ERR_MSG + ''	AS ERR_MSG
		;

print '> 실패 완료';
		RETURN 1;
	END CATCH
END
