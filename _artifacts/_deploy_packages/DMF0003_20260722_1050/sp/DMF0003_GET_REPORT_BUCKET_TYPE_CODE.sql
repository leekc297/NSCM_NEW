CREATE OR REPLACE PROCEDURE           "DMF0003_GET_REPORT_BUCKET_TYPE_CODE"
(
    O_RC1 OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DMF0003_GET_REPORT_BUCKET_TYPE_CODE                                                       */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2022.07.26	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
*  2022.10.24	ROSIA27		[C20221024-000510]DM UI 소스 정리 요청
*/
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
/* 2026.06.08  ZIONEX       [PJ202650304] NextSCM Migration : 결과셋 반환 복원 — SELECT INTO(ORA-01422)를 OUT SYS_REFCURSOR + OPEN FOR 로 수정 */
    p_end_week VARCHAR2(6 CHAR);
BEGIN

  OPEN O_RC1 FOR
  SELECT L.SEGMENT1  AS CODE
       , L.SEGMENT2  AS NAME
  FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
  WHERE  L.LOOKUP_TYPE = 'REPORT_BUCKET_TYPE_CODE'
  AND    L.VALID_YN    = 'Y'
  ORDER BY DISPLAY_SEQ;

END;
/
