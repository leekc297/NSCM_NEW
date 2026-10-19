
/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
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


CREATE procedure [dbo].[DM0000_GET_AUTHORITY_YN]
    @p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8),
	@p_created_by	   NVARCHAR(50),
	@p_program_id	   NVARCHAR(MAX),
	@p_sheet_name	   NVARCHAR(MAX)
AS
BEGIN
	
    SET NOCOUNT ON;

    DECLARE @v_dept_id nvarchar(max)='';
	-- 사용자의 팀정보 & 권한
	--SELECT @v_dept_id = U.DEPT_ID
	--FROM   [dbo].[TB_FX_User] U
	--WHERE  U.UserID = @p_created_by
	SELECT @v_dept_id = isnull( (	 select  SEGMENT3
				from  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL]
				where LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
				and SEGMENT1         =   U.DEPT_ID ) , U.DEPT_ID )
	FROM   [dbo].[TB_FX_User] U
	WHERE  U.UserID = @p_created_by

	SELECT @v_dept_id
END



