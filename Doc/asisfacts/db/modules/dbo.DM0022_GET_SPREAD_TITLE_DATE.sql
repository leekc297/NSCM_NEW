/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/02/05  pjs       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
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


CREATE PROCEDURE [dbo].[DM0022_GET_SPREAD_TITLE_DATE]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50)
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT 'D_' + BASIS_YYYYMMDD AS BASIS_YYYYMMDD, BASIS_START_DATE, 
	ISO_YYYYWW, PARTIAL_WEEK_NAME, WEEK_NAME,
	ISO_YYYYWW + PARTIAL_WEEK_NAME AS COL_WEEK_NAME,
	DAYOFWEEK, BASIS_YYYYMM, DATE_SHORT3_NAME, CALENDAR_DAY
	FROM [dbo].[SCM_SYS_CALENDAR_M]
	WHERE
	BASIS_YYYYMMDD >= @p_start_yyyymmdd AND BASIS_YYYYMMDD <= @p_end_yyyymmdd
	ORDER BY BASIS_YYYYMMDD

END

