
/* ==========================================================================================================================================================
프로그램ID : FN_GET_REPORT_USER_COLUMNS
업  무  명 : 사용자정의컬럼이 하나도 없을때 에러 방지를 위해 디폴트 컬럼 리턴
프로그램명 : 리포트 사용자정의 컬럼 리턴
최초작성일 : 2024.01.17
최종작성일 : 2024.01.17
개  발  자 : chaan
입  력  값 :
출  력  값 :
==========================================================================================================================================================
 Date         In Charge     Description
==========================================================================================================================================================
 2024/01/17   chaan         V1.1.1  Initial Release
========================================================================================================================================================== */

CREATE FUNCTION [dbo].[FN_GET_REPORT_USER_COLUMNS]
--ALTER FUNCTION [dbo].[FN_GET_REPORT_USER_COLUMNS]
(
      @p_program_id						NVARCHAR(300)
	, @p_sheet_name						NVARCHAR(150)
	, @p_user_id					    NVARCHAR(150)
)
RETURNS @TBL_RES TABLE
--DECLARE @TBL_RES TABLE
(
	  COLUMN_NAME           NVARCHAR(1000)
    , USER_SORT_ORDER_NO    INT
)
AS
BEGIN
 --   DECLARE @p_program_id					NVARCHAR(300)		= N'SCP0103';
	--DECLARE @p_sheet_name					NVARCHAR(150)		= N'ALL';
	--DECLARE @p_user_id					    NVARCHAR(150)		= N'iamarock';



    DECLARE @Tbl_REPORT_USER_COLUMNS_ALL TABLE
    (
	      COLUMN_NAME           NVARCHAR(1000)
        , USER_SORT_ORDER_NO    INT
    )
    
    DECLARE @Tbl_REPORT_USER_COLUMNS_USER TABLE
    (
	      COLUMN_NAME           NVARCHAR(1000)
        , USER_SORT_ORDER_NO    INT
    )
    
    DECLARE @Tbl_REPORT_USER_COLUMNS TABLE
    (
	      COLUMN_NAME           NVARCHAR(1000)
        , USER_SORT_ORDER_NO    INT
    )

	INSERT INTO @Tbl_REPORT_USER_COLUMNS_ALL
	SELECT    A.COLUMN_NAME
            , ROW_NUMBER() OVER(ORDER BY ISNULL(B.SORT_ORDER_NO, A.SORT_ORDER_NO))  AS USER_SORT_ORDER_NO
	FROM    SCM_MST_SHEET_COLUMNS A WITH(NOLOCK)
			LEFT JOIN SCM_MST_TITLESET_USER B WITH(NOLOCK) ON
					B.PROGRAM_ID                    = A.PROGRAM_ID
				AND B.SHEET_NAME                    = A.SHEET_NAME
				AND B.COLUMN_NAME                   = A.COLUMN_NAME
				AND B.USER_ID                       = @p_user_id
				AND B.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
	WHERE   1=1
        AND A.PROGRAM_ID    = @p_program_id
		AND A.SHEET_NAME    = @p_sheet_name
		AND A.VALID_YN      = 'Y'
		AND A.VISIBLE_FLAG  = 'Y';
--TESTING : OK
--select * from @Tbl_REPORT_USER_COLUMNS_ALL;return;

	INSERT INTO @Tbl_REPORT_USER_COLUMNS_USER
    SELECT    A.COLUMN_NAME
            , ROW_NUMBER() OVER(ORDER BY A.SORT_ORDER_NO)  AS USER_SORT_ORDER_NO
    FROM    SCM_MST_TITLESET_USER A WITH(NOLOCK)
    WHERE   1=1
        AND A.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND A.PROGRAM_ID                    = @p_program_id
		AND A.SHEET_NAME                    = @p_sheet_name
        AND USER_ID                         = @p_user_id;

--TESTING : OK
--select * from @Tbl_REPORT_USER_COLUMNS_USER;return;

    DECLARE @v_cnt_usr_column	    INT = 0;

    SELECT  @v_cnt_usr_column = Count(*)
    FROM    @Tbl_REPORT_USER_COLUMNS_USER

    -- 사용자지정컬럼 갯수가 하나도 없으면 디폴트 전체 추가
    IF @v_cnt_usr_column > 0
    BEGIN
        INSERT INTO @TBL_RES
	    SELECT  *
	    FROM    @Tbl_REPORT_USER_COLUMNS_USER
        ORDER BY USER_SORT_ORDER_NO;
    END
    ELSE
    BEGIN
        INSERT INTO @TBL_RES
	    SELECT  *
	    FROM    @Tbl_REPORT_USER_COLUMNS_ALL
        ORDER BY USER_SORT_ORDER_NO;
    END


--TESTING : NOK
--select * from @TBL_RES;return;

	RETURN;
END;
