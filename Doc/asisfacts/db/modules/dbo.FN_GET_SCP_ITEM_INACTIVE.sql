
/* ==========================================================================================================================================================
프로그램ID : FN_GET_SCP_ITEM_INACTIVE
업  무  명 : 공통 코드성 조회
프로그램명 : 공통 코드성 조회
최초작성일 : 2024.01.15
최종작성일 : 2024.01.15
개  발  자 : chaan
입  력  값 :
출  력  값 :
==========================================================================================================================================================
 Date         In Charge     Description
==========================================================================================================================================================
 2024/01/15   chaan         V1.1.1  Initial Release - 기존 함수(FN_GET_SCP_ITEM_ACTIVE) 오류로 추가함
========================================================================================================================================================== */

--CREATE FUNCTION [dbo].[FN_GET_SCP_ITEM_INACTIVE]
CREATE FUNCTION [dbo].[FN_GET_SCP_ITEM_INACTIVE]
(
      @p_division_id  NVARCHAR(MAX)
    , @p_item_id      NVARCHAR(MAX)
)
RETURNS @TBL_RES TABLE
--DECLARE @TBL_RES TABLE
(
	  DIVISION_ID       NVARCHAR(1000)
    , ITEM_ID           NVARCHAR(1000)
	, ACTIVE_FLAG       NVARCHAR(1000)
)
--AS
BEGIN
    --DECLARE @p_division_id   NVARCHAR(MAX) = N'82';
    --DECLARE @p_item_id       NVARCHAR(MAX) = N'EM048290P5B5'; 


    DECLARE @TBL_ITEM_ALL TABLE
    (
	      DIVISION_ID       NVARCHAR(1000)
        , ITEM_ID           NVARCHAR(1000)
	    , ACTIVE_FLAG       NVARCHAR(1000)
    )
    
    DECLARE @TBL_ITEM_INACTIVE TABLE
    (
	      DIVISION_ID       NVARCHAR(1000)
        , ITEM_ID           NVARCHAR(1000)
	    , ACTIVE_FLAG       NVARCHAR(1000)
    )
    
    DECLARE @TBL_ITEM_ACTIVE TABLE
    (
	      DIVISION_ID       NVARCHAR(1000)
        , ITEM_ID           NVARCHAR(1000)
	    , ACTIVE_FLAG       NVARCHAR(1000)
    )

    INSERT INTO @TBL_ITEM_ALL
	SELECT    A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG
	FROM	SCM_MST_ITEM_SN A WITH(NOLOCK)
			INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B(NOLOCK) ON
					A.ITEM_CLASS = B.CLASS_ID
	WHERE	1=1
		AND B.USE_FLAG		= 'Y'
		AND DIVISION_ID IN (SELECT TOKEN FROM dbo.String_Split(@p_division_id, ','))
    GROUP BY  A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG;


--TESTING : NOK
--select * from @TBL_ITEM_ALL;return;

    INSERT INTO @TBL_ITEM_INACTIVE
    SELECT    A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG 
	FROM	@TBL_ITEM_ALL A
	WHERE	1=1
		AND A.ACTIVE_FLAG	= 'N'
    GROUP BY  A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG;

--TESTING : NOK
--select * from @TBL_ITEM_INACTIVE;return;

    --20240115 DIVISION, ITEMID 그륩별 전체가 N 인 경우에만 N 간주, 즉 하나라도 Y 가 있으면 조회가능 by chaan (신재욱책임 요청)
    INSERT INTO @TBL_ITEM_ACTIVE
	SELECT    A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG 
	FROM	@TBL_ITEM_ALL A
	WHERE	1=1
		AND A.ACTIVE_FLAG	= 'Y'
    GROUP BY  A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG;

--TESTING : NOK
--select * from @TBL_ITEM_ACTIVE;return;

    INSERT  @TBL_RES
	SELECT    A.DIVISION_ID
            , A.ITEM_ID
            , A.ACTIVE_FLAG 
    FROM    @TBL_ITEM_INACTIVE A 
            LEFT HASH JOIN @TBL_ITEM_ACTIVE B ON
                    A.DIVISION_ID   = B.DIVISION_ID
                AND A.ITEM_ID       = B.ITEM_ID
    WHERE   B.DIVISION_ID IS NULL
        AND B.ITEM_ID     IS NULL;

--TESTING : NOK
--select * from @TBL_RES;return;

	RETURN;
END;
