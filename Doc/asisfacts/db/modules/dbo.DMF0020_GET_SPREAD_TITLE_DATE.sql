
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************/
/* Program ID  : DMF0020_GET_SPREAD_TITLE_DATE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2020/03/06  P.C.I        [PJ20200138]DM->DMF 명칭 변경                                                       */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule 
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/


CREATE PROCEDURE [dbo].[DMF0020_GET_SPREAD_TITLE_DATE]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50)
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT  MIN(BASIS_START_DATE) AS BASIS_START_DATE, BASIS_YYYYMM, WEEK_NAME, SUBSTRING(BASIS_START_DATE,5,4) AS DATE_SHORT1_NAME
	FROM [dbo].[SCM_SYS_CALENDAR_M]
	WHERE
	BASIS_YYYYMMDD >= @p_start_yyyymmdd AND BASIS_YYYYMMDD <= @p_end_yyyymmdd
	GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTRING(BASIS_START_DATE,5,4)
	ORDER BY BASIS_START_DATE

END


