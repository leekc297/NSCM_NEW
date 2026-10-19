/****************************************************************************************************/
/* Program ID  : DMF0001_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
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


CREATE procedure [dbo].[DMF0001_GET_SPREAD_TITLE]
  @p_plan_week          NVARCHAR(6)
AS
BEGIN
	
  SET NOCOUNT ON;

  DECLARE @p_end_week       AS NVARCHAR(6);

  SET @p_end_week = CONVERT(CHAR(4), SUBSTRING(@p_plan_week, 1, 4) + 1) + CONVERT(CHAR(2), SUBSTRING(@p_plan_week, 5, 2) -1);

  SELECT 'W_' + a.basis_start_date + '_' + a.basis_end_date AS column_name
       , a.week_name                                    AS column_label
       , a.month_name                                   AS small_label_name 
       , a.basis_start_date
       , a.basis_end_date
  FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
  WHERE  a.iso_yyyyww > @p_plan_week --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
  AND    a.iso_yyyyww <= @p_end_week --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
  GROUP BY a.basis_start_date
         , a.basis_end_date
         , a.week_name
         , a.month_name                                 
         
	;

END


