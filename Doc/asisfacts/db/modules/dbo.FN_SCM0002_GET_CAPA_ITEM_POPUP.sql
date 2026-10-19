
/*
 * Program ID   : SCP0104_GET_CAPA_LINE_ASSIGN_ELTR
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/04/02   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2025/04/03   mrchois      V1.1.2                PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선     - CPS 소형 확산
 */


CREATE FUNCTION [dbo].[FN_SCM0002_GET_CAPA_ITEM_POPUP]
--ALTER FUNCTION [dbo].[FN_GET_SCM0002_GET_CAPA_ITEM_POPUP]
(    
	  @p_division_id				NVARCHAR(30)
	, @p_item_id   					NVARCHAR(MAX)
)
RETURNS @TBL_RES TABLE
--DECLARE @TBL_RES TABLE
(
      DIVISION_ID           NVARCHAR(30)
    , OPERATION_GROUP       NVARCHAR(30)
    , OPERATION_ID          NVARCHAR(30)
    , ITEM_ID               NVARCHAR(30)
    , ITEM_NAME             NVARCHAR(100)
    , NICK_NAME             NVARCHAR(100)
)
--AS
BEGIN
	--DECLARE @p_division_id				NVARCHAR(30)	= N'81';
	--DECLARE @p_item_id					NVARCHAR(50)	= N'APCAN2393A';


    INSERT INTO @TBL_RES
    SELECT    A.DIVISION_ID
            , A.OPERATION_GROUP
            , A.OPERATION_ID
            , A.ITEM_ID
            --, A.ITEM_NAME
            --, A.NICK_NAME
            , MAX(A.ITEM_NAME) AS ITEM_NAME
            , MAX(A.NICK_NAME) AS NICK_NAME
    FROM    (
                SELECT    A.DIVISION_ID
                        , A.OPERATION_GROUP
                        , A.FLOW_ID         AS OPERATION_ID
                        , A.ITEM_ID
                        , B.ITEM_NAME
                        ------, CASE
                        ------    WHEN A.FLOW_ID = 'A9000'    THEN -- Cell
                        ------        CASE
                        ------            WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL))
                        ------            ELSE (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL))
                        ------        END
                        ------    ELSE                             -- Pack
                        ------        CASE
                        ------            WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL))
                        ------            ELSE ''
                        ------        END
                        ------  END AS NICK_NAME
                        , CASE
                            WHEN B.NICK_NAME IS NULL THEN A.NICK_NAME
                            ELSE B.NICK_NAME
                          END AS NICK_NAME
                FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
                        JOIN [dbo].[SCM_MST_ITEM_SN] B WITH(NOLOCK) ON
                                A.DIVISION_ID  = B.DIVISION_ID
                            AND A.ITEM_ID      = B.ITEM_ID
            ) A
    WHERE   1=1
        AND ((@p_division_id	IS NULL OR @p_division_id	='') OR A.DIVISION_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id	, ',')))
        AND (
                CASE
                    WHEN @p_item_id LIKE '%,%' THEN
                    CASE
                        WHEN 
                            A.ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id	, ',')) THEN 1
                        ELSE 0
                    END 
                    WHEN
                        ((A.ITEM_ID     LIKE '%' + @p_item_id + '%') OR 
                         (A.NICK_NAME   LIKE '%' + @p_item_id + '%')) THEN 1
                    ELSE 0
                END = 1
            )
        --AND A.NICK_NAME IS NOT NULL
    GROUP BY  A.DIVISION_ID
            , A.OPERATION_GROUP
            , A.OPERATION_ID
            , A.ITEM_ID
            --, A.ITEM_NAME
            --, A.NICK_NAME;
--TESTING : NOK
--select * from @TBL_RES;return;

    RETURN;
END

