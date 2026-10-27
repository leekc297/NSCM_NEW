
CREATE PROCEDURE [dbo].[PR_SCM_TABLE_COMMENT]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : 
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : RCCP
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2018.01.23
-- Author              : PIYONG
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

		
	DECLARE @TABLE_NAME		NVARCHAR(1000) --테이블 이름
	DECLARE @COLUMN_NAME    NVARCHAR(2000) --컬럼 ID
	DECLARE @TABLE_COMMENT  NVARCHAR(4000) --컬럼 설명

	
	-- ================================================
	-- 로직 추가
	-- ================================================
		DECLARE CUR_COLUMN_LIST CURSOR FOR
		 SELECT COLUMN_ID, COLUMN_NAME
		   FROM LGCE_INFDEV.DBO.COLUMN_NAME

		OPEN CUR_COLUMN_LIST

		FETCH NEXT FROM CUR_COLUMN_LIST INTO @COLUMN_NAME
											 ,@TABLE_COMMENT

		WHILE (@@FETCH_STATUS = 0)
			BEGIN

				DECLARE CUR_LIST CURSOR FOR	
					SELECT A.TABLE_NAME
		--				   ,C.VALUE AS TABLE_COMMENT
		--				   ,A.COLUMN_NAME
		--				   ,B.VALUE AS COLUM_COMMENT
					  FROM INFORMATION_SCHEMA.COLUMNS A 
					  LEFT OUTER JOIN SYS.EXTENDED_PROPERTIES B
								   ON B.major_id = object_id(A.TABLE_NAME) 
								  AND A.ORDINAL_POSITION = B.minor_id
					  LEFT OUTER JOIN (
										SELECT object_id(objname) AS TABLE_ID, VALUE
										FROM ::FN_LISTEXTENDEDPROPERTY(NULL, 'User','dbo','table',NULL, NULL, NULL)
									  ) C ON object_id(A.TABLE_NAME) = C.TABLE_ID
					WHERE A.COLUMN_NAME = @COLUMN_NAME
					  AND B.VALUE IS NULL
					  AND A.TABLE_NAME NOT LIKE '%_V' 
					  AND A.TABLE_NAME NOT LIKE 'V_%'

				OPEN CUR_LIST;
		
				FETCH NEXT FROM CUR_LIST INTO @TABLE_NAME

				WHILE (@@FETCH_STATUS = 0)
					BEGIN
						SET @TABLE_COMMENT = N''+@TABLE_COMMENT

						EXEC sp_addextendedproperty  'MS_Description', @TABLE_COMMENT, 'user', dbo, 'table', @TABLE_NAME, 'column', @COLUMN_NAME

						FETCH NEXT FROM CUR_LIST INTO @TABLE_NAME
						;
					END;
			
				CLOSE CUR_LIST;
				DEALLOCATE CUR_LIST;

			FETCH NEXT FROM CUR_COLUMN_LIST INTO @COLUMN_NAME
											 ,@TABLE_COMMENT
			;

			END;
			
		CLOSE CUR_COLUMN_LIST;
		DEALLOCATE CUR_COLUMN_LIST;

END



