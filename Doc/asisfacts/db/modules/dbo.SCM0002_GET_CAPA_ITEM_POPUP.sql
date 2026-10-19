/* ==========================================================================================================================================================
프로그램ID : SCM0002_GET_CAPA_ITEM_POPUP
업  무  명 : 공통 코드성 조회
프로그램명 : 공통 코드성 조회
최초작성일 : 2024.02.27
최종작성일 : 2024.02.27
개  발  자 : chaan
입  력  값 :
출  력  값 :
==========================================================================================================================================================
 Date         In Charge     Description
==========================================================================================================================================================
 2024/02/27   chaan         V1.1.1  Initial Release
 2024/04/02   chaan         V1.1.2  함수화
 ========================================================================================================================================================== */
--CREATE PROCEDURE [dbo].[SCM0002_GET_CAPA_ITEM_POPUP]
CREATE PROCEDURE [dbo].[SCM0002_GET_CAPA_ITEM_POPUP]
	  @p_division_id				NVARCHAR(30)
	, @p_item_id   					NVARCHAR(MAX)
AS
BEGIN
	--DECLARE @p_division_id				NVARCHAR(30)	= N'';
	--DECLARE @p_item_id					NVARCHAR(50)	= N'';



	SET NOCOUNT ON;

    SELECT    DIVISION_ID
            , OPERATION_GROUP
            , OPERATION_ID
            , ITEM_ID
            , ITEM_NAME
            , NICK_NAME
    FROM    FN_SCM0002_GET_CAPA_ITEM_POPUP(@p_division_id, @p_item_id);
END

