


/*
 * Program ID   : FN_GET_ITEM_LIKE_CONDITION
 * Description  : MODEL, NICK_NAME 컬럼으로 LIKE 검색(멀티 키워드) 
 * 실행 예제    : SELECT * FROM dbo.FN_GET_ITEM_LIKE_CONDITION('', 'CB02,ED760')
 * Program History
 *===================================================================================================
 *Date			In Charge       Description
 *===================================================================================================
 *2023.06.22    chaan           V1.1.1      PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Initial Release
 *
*/
--DROP FUNCTION [dbo].[FN_GET_ITEM_LIKE_CONDITION]
--CREATE FUNCTION [dbo].[FN_GET_ITEM_LIKE_CONDITION]
CREATE FUNCTION [dbo].[FN_GET_ITEM_LIKE_CONDITION]
(
	  @p_model_id				NVARCHAR(MAX)   = N''
	, @p_nickname				NVARCHAR(MAX)   = N''
)
RETURNS @TBL TABLE(ITEM_ID NVARCHAR(150))
AS
BEGIN
	--DECLARE @p_model_id				NVARCHAR(MAX)   = N'AAEF1120I-A1,AAEF1120I-A2';
	----DECLARE @p_model_id				NVARCHAR(MAX)   = N'';
	----DECLARE @p_nickname				NVARCHAR(MAX)   = N'CB02,ED760';
	--DECLARE @p_nickname				NVARCHAR(MAX)   = N'';


    DECLARE @TBL_GET_ITEM_LIKE_ITEM       TABLE(ITEM_ID NVARCHAR(150))
    DECLARE @TBL_GET_ITEM_LIKE_NICKNAME   TABLE(ITEM_ID NVARCHAR(150))

	DECLARE @v_item_id                    NVARCHAR(MAX)   = N'';
	DECLARE @v_nickname                   NVARCHAR(MAX)   = N'';


    --ITEM_ID begin------------------------------------------------------------------------------------
    IF @p_model_id IS NULL OR @p_model_id = ''
    BEGIN
        INSERT INTO @TBL_GET_ITEM_LIKE_ITEM
        SELECT  ITEM_ID
        FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
    END
    BEGIN
        IF CURSOR_STATUS('global','CUR_GET_ITEM_LIKE_ITEM') >= -1
        BEGIN
            IF CURSOR_STATUS('global','CUR_GET_ITEM_LIKE_ITEM') > -1
            BEGIN
                CLOSE CUR_GET_ITEM_LIKE_ITEM
            END

            DEALLOCATE CUR_GET_ITEM_LIKE_ITEM
        END

        DECLARE CUR_GET_ITEM_LIKE_ITEM CURSOR FOR
        SELECT  TOKEN 
        FROM    dbo.STRING_SPLIT(@p_model_id	, ',')

        OPEN CUR_GET_ITEM_LIKE_ITEM;

        FETCH NEXT FROM CUR_GET_ITEM_LIKE_ITEM INTO @v_item_id

        WHILE @@FETCH_STATUS = 0
        BEGIN
            --PRINT CONCAT('@v_item_id : ', @v_item_id)

            INSERT INTO @TBL_GET_ITEM_LIKE_ITEM
            SELECT  ITEM_ID
            FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
            WHERE   1=1
                AND ITEM_ID LIKE CONCAT('%', @v_item_id, '%')

	        FETCH NEXT FROM CUR_GET_ITEM_LIKE_ITEM INTO @v_item_id
        END

        CLOSE CUR_GET_ITEM_LIKE_ITEM
        DEALLOCATE CUR_GET_ITEM_LIKE_ITEM
    END
    --ITEM_ID end------------------------------------------------------------------------------------


    --NICK_NAME begin------------------------------------------------------------------------------------
    IF @p_nickname IS NULL OR @p_nickname = ''
    BEGIN
        INSERT INTO @TBL_GET_ITEM_LIKE_NICKNAME
        SELECT  ITEM_ID
        FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
    END
    BEGIN
        IF CURSOR_STATUS('global','CUR_GET_ITEM_LIKE_NICKNAME') >= -1
        BEGIN
            IF CURSOR_STATUS('global','CUR_GET_ITEM_LIKE_NICKNAME') > -1
            BEGIN
                CLOSE CUR_GET_ITEM_LIKE_NICKNAME
            END

            DEALLOCATE CUR_GET_ITEM_LIKE_NICKNAME
        END

        DECLARE CUR_GET_ITEM_LIKE_NICKNAME CURSOR FOR
        SELECT  TOKEN 
        FROM    dbo.STRING_SPLIT(@p_nickname	, ',')

        OPEN CUR_GET_ITEM_LIKE_NICKNAME;

        FETCH NEXT FROM CUR_GET_ITEM_LIKE_NICKNAME INTO @v_nickname

        WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO @TBL_GET_ITEM_LIKE_NICKNAME
            SELECT  ITEM_ID
            FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
            WHERE   1=1
                AND NICK_NAME LIKE CONCAT('%', @v_nickname, '%')

	        FETCH NEXT FROM CUR_GET_ITEM_LIKE_NICKNAME INTO @v_nickname
        END

        CLOSE CUR_GET_ITEM_LIKE_NICKNAME
        DEALLOCATE CUR_GET_ITEM_LIKE_NICKNAME
    END
    --NICK_NAME end------------------------------------------------------------------------------------

    --SELECT  * FROM @TBL_GET_ITEM_LIKE_ITEM;
    --SELECT  * FROM @TBL_GET_ITEM_LIKE_NICKNAME;

    INSERT INTO @TBL
    SELECT DISTINCT
            I.ITEM_ID
    FROM    @TBL_GET_ITEM_LIKE_ITEM I
            JOIN @TBL_GET_ITEM_LIKE_NICKNAME N ON
                    I.ITEM_ID = N.ITEM_ID

    RETURN
END

