/*
 * Program ID   : DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION
 * Description  : Business Plan ('DM_PLN_BP_FCST' TABLE SELECT)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/11/08  chano0612   [C20221025-000029] Business Plan Current버전 특정 컷오프 버전으로 덮어쓰기 기능 구현 요청의 건
 */


CREATE procedure [dbo].[DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION]  
				@p_division_id                NVARCHAR(30),   -- 부서코드
				@p_yyyyMM_from                NVARCHAR(6),    -- 조회(데이터)시작구간
				@p_yyyyMM_to                  NVARCHAR(6),    -- 조회(데이터)끝구간
				@p_version_type               NVARCHAR(10)    -- 버전유형
AS

--EXEC DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION '40', '20220501', '20231101', 'BP_M'

--EXEC DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION '40', '20211101', '20211231', 'BP_M'

BEGIN
SET NOCOUNT ON;

 SELECT 
  	   DIVISION_ID
      ,VERSION_NO
      ,VERSION_DESCRIPTION
      ,VERSION_TYPE
      ,YYYYMMDD
      ,VER_CRE_SEQ
      ,CREATED_BY
      ,CREATION_DATE
      ,LAST_UPDATED_BY
      ,LAST_UPDATE_DATE      
  FROM DM_MST_VERSION WITH(NOLOCK)
  WHERE DIVISION_ID = @p_division_id
		AND VERSION_NO IN (SELECT VERSION_NO FROM DM_PLN_BP_FCST_C 
		WHERE DIVISION_ID = @p_division_id AND CUTOFF_TYPE LIKE @p_version_type + '%' AND YYYYMM BETWEEN @p_yyyyMM_from AND @p_yyyyMM_to GROUP BY VERSION_NO )
		AND ISNULL(ATTRIBUTE1,'') <> 'MOVE'
  ORDER BY DIVISION_ID, VERSION_NO DESC, CREATION_DATE DESC

END

PRINT @p_division_id + ' _ ' + @p_version_type + ' _ ' + @p_yyyyMM_from + ' _ ' +  @p_yyyyMM_to
 
  --SELECT * FROM INFORMATION_SCHEMA.COLUMNS
  --WHERE TABLE_NAME = 'DM_PLN_BP_FCST_C'

  --SELECT * FROM INFORMATION_SCHEMA.COLUMNS
  --WHERE TABLE_NAME = 'DM_MST_VERSION'

  --SELECT * FROM DM_MST_VERSION WHERE CREATED_BY = 'CHANO0612'
