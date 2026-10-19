
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : FN_SCP0104_GET_CAPA_VERSION
 * Description  : CAPA 해당 월의 버전 리턴
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2023/10/12   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 */

--CREATE FUNCTION [dbo].[FN_SCP0104_GET_CAPA_VERSION]
CREATE FUNCTION [dbo].[FN_SCP0104_GET_CAPA_VERSION]
(
	  @p_division_id		NVARCHAR(30)
	, @p_yyyymm				NVARCHAR(10)
)
RETURNS @TBL_RES TABLE
--DECLARE @TBL_RES TABLE
(
	  DIVISION_ID				NVARCHAR(30)
	, VER_ID					NVARCHAR(10)
	, VER_SEQ					TINYINT
	, PROG_STAT					NVARCHAR(2)
)
AS
BEGIN
	--DECLARE @p_division_id			NVARCHAR(30)		= '81';
	--DECLARE @p_yyyymm				NVARCHAR(10)		= '202402';

    DECLARE @TBL_1 TABLE
    (
		  DIVISION_ID				NVARCHAR(30)
		, VER_ID					NVARCHAR(10)
		, VER_SEQ					TINYINT
		, PROG_STAT					NVARCHAR(2)
    )
    
	INSERT INTO @TBL_1
	SELECT	  DIVISION_ID
			, VER_ID
			, MAX(VER_SEQ)		AS VER_SEQ
			, MAX(PROG_STAT)	AS PROG_STAT
	FROM	SCP_MST_CAPA_VERSION
	WHERE	1=1
		AND DIVISION_ID = @p_division_id
		AND VER_ID = @p_yyyymm
	GROUP BY  DIVISION_ID
			, VER_ID;

--TESTING : NOK
--select * from @TBL_1;--return;

	INSERT INTO @TBL_RES
	SELECT	*
	FROM	@TBL_1

--TESTING : NOK
--select * from @TBL_RES order by VER_SEQ;

    RETURN;
END
