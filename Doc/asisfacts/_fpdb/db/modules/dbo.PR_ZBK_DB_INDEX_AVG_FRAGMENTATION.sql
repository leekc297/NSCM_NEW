

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_ZBK_DB_INDEX_AVG_FRAGMENTATION
-- Param               :
-- Batch Period        : 
-- Description         : 테이블 인덱스의 avg_fragmentation_in_percent를 구합니다.
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2016.12.06
-- Author              : kimtwins
-- Version             : 1.0
-- ================================================================================================
-------------------- 실행 예시 -----------------------------------
-- 테이블 인덱스의 avg_fragmentation_in_percent를 구합니다.
-- exec PR_ZBK_DB_INDEX_AVG_FRAGMENTATION
-- ================================================================================================
CREATE PROCEDURE [dbo].[PR_ZBK_DB_INDEX_AVG_FRAGMENTATION]
AS
BEGIN
	DECLARE @TABLE_INDEX TABLE (
									  DATABASE_ID					smallint
									, TABLE_ID						int
									, INDEX_ID						int
									, DATABASE_NM					NVARCHAR(MAX)
									, TABLE_NM						NVARCHAR(MAX)
									, INDEX_NM						NVARCHAR(MAX)
									, TABLE_ROWS					BIGINT
	)

	INSERT @TABLE_INDEX
	SELECT DB_ID('LGCE_FP') AS DATABASE_ID, ST.OBJECT_ID AS TABLE_ID, S_I.INDEX_ID, 'LGCE_FP' AS DATABASE_NM, SO.NAME AS TABLE_NM, S_I.NAME AS INDEX_NM, 0 AS TABLE_ROWS
	FROM [LGCE_FP].dbo.SYSOBJECTS SO with(nolock), [LGCE_FP].SYS.INDEXES S_I with(nolock), [LGCE_FP].SYS.tables ST with(nolock)
	WHERE 1=1
	AND SO.NAME = ST.NAME
	AND SO.ID = S_I.object_id
	AND SO.XTYPE = 'U'
	AND S_I.TYPE IN (1,2)
	AND SO.NAME !='sysdiagrams'

	INSERT @TABLE_INDEX
	SELECT DB_ID('LGCE_FP_TR') AS DATABASE_ID, ST.OBJECT_ID AS TABLE_ID, S_I.INDEX_ID, 'LGCE_FP_TR' AS DATABASE_NM, SO.NAME AS TABLE_NM, S_I.NAME AS INDEX_NM, 0 AS TABLE_ROWS
	FROM [LGCE_FP_TR].dbo.SYSOBJECTS SO with(nolock), [LGCE_FP_TR].SYS.INDEXES S_I with(nolock), [LGCE_FP_TR].SYS.tables ST with(nolock)
	WHERE 1=1
	AND SO.NAME = ST.NAME
	AND SO.ID = S_I.object_id
	AND SO.XTYPE = 'U'
	AND S_I.TYPE IN (1,2)
	AND SO.NAME !='sysdiagrams'

	INSERT @TABLE_INDEX
	SELECT DB_ID('LGCE_INF') AS DATABASE_ID, ST.OBJECT_ID AS TABLE_ID, S_I.INDEX_ID, 'LGCE_INF' AS DATABASE_NM, SO.NAME AS TABLE_NM, S_I.NAME AS INDEX_NM, 0 AS TABLE_ROWS
	FROM [LGCE_INF].dbo.SYSOBJECTS SO with(nolock), [LGCE_INF].SYS.INDEXES S_I with(nolock), [LGCE_INF].SYS.tables ST with(nolock)
	WHERE 1=1
	AND SO.NAME = ST.NAME
	AND SO.ID = S_I.object_id
	AND SO.XTYPE = 'U'
	AND S_I.TYPE IN (1,2)
	AND SO.NAME !='sysdiagrams'

	UPDATE @TABLE_INDEX SET
	TABLE_ROWS = R.ROWS
	FROM @TABLE_INDEX TI2, (
			SELECT 'LGCE_FP' AS DATABASE_NM, SO.NAME AS TABLE_NM, SI.ROWS
			FROM [LGCE_FP].dbo.SYSOBJECTS SO with(nolock) LEFT OUTER JOIN [LGCE_FP].dbo.SYSINDEXES SI with(nolock)
										ON SO.ID = SI.ID
			WHERE 1=1
			AND SO.XTYPE = 'U'
			GROUP BY SO.NAME, SI.ROWS
			HAVING SI.ROWS <>0

			UNION

			SELECT 'LGCE_FP_TR' AS DATABASE_NM, SO.NAME AS TABLE_NM, SI.ROWS
			FROM [LGCE_FP_TR].dbo.SYSOBJECTS SO with(nolock) LEFT OUTER JOIN [LGCE_FP_TR].dbo.SYSINDEXES SI with(nolock)
										ON SO.ID = SI.ID
			WHERE 1=1
			AND SO.XTYPE = 'U'
			GROUP BY SO.NAME, SI.ROWS
			HAVING SI.ROWS <>0

			UNION

			SELECT 'LGCE_INF' AS DATABASE_NM, SO.NAME AS TABLE_NM, SI.ROWS
			FROM [LGCE_INF].dbo.SYSOBJECTS SO with(nolock) LEFT OUTER JOIN [LGCE_INF].dbo.SYSINDEXES SI with(nolock)
										ON SO.ID = SI.ID
			WHERE 1=1
			AND SO.XTYPE = 'U'
			GROUP BY SO.NAME, SI.ROWS
			HAVING SI.ROWS <>0
	) R
	WHERE 1=1
	AND TI2.DATABASE_NM = R.DATABASE_NM
	AND TI2.TABLE_NM = R.TABLE_NM

	DECLARE @TABLE_INDEX_FRG TABLE (
									  DATABASE_ID					smallint
									, TABLE_ID						int
									, INDEX_ID						int
									, DATABASE_NM					NVARCHAR(MAX)
									, TABLE_NM						NVARCHAR(MAX)
									, INDEX_NM						NVARCHAR(MAX)
									, TABLE_ROWS					BIGINT
									, avg_fragmentation_in_percent	FLOAT
	)

	DECLARE 
									  @DATABASE_ID					smallint
									, @TABLE_ID						int
									, @INDEX_ID						int
									, @DATABASE_NM					NVARCHAR(MAX)
									, @TABLE_NM						NVARCHAR(MAX)
									, @INDEX_NM						NVARCHAR(MAX)
									, @TABLE_ROWS					BIGINT

	DECLARE target_table_cursor CURSOR FOR
		SELECT DATABASE_ID, TABLE_ID, INDEX_ID, DATABASE_NM, TABLE_NM, INDEX_NM, TABLE_ROWS
		FROM @TABLE_INDEX

	OPEN target_table_cursor

	FETCH NEXT FROM target_table_cursor INTO @DATABASE_ID, @TABLE_ID, @INDEX_ID, @DATABASE_NM, @TABLE_NM, @INDEX_NM, @TABLE_ROWS
	WHILE (@@FETCH_STATUS=0)
		BEGIN
			INSERT @TABLE_INDEX_FRG
			SELECT @DATABASE_ID, @TABLE_ID, @INDEX_ID, @DATABASE_NM, @TABLE_NM, @INDEX_NM, @TABLE_ROWS, F.avg_fragmentation_in_percent
			FROM MASTER.SYS.dm_db_index_physical_stats(@DATABASE_ID, @TABLE_ID, @INDEX_ID, NULL, 'LIMITED') F

			FETCH NEXT FROM target_table_cursor INTO @DATABASE_ID, @TABLE_ID, @INDEX_ID, @DATABASE_NM, @TABLE_NM, @INDEX_NM, @TABLE_ROWS
		END
	CLOSE target_table_cursor
	DEALLOCATE target_table_cursor

	SELECT *
	FROM @TABLE_INDEX_FRG
	WHERE 1=1
	AND DATABASE_NM = 'LGCE_FP'
	ORDER BY avg_fragmentation_in_percent DESC, TABLE_ROWS DESC

	SELECT *
	FROM @TABLE_INDEX_FRG
	WHERE 1=1
	AND DATABASE_NM = 'LGCE_FP_TR'
	ORDER BY avg_fragmentation_in_percent DESC, TABLE_ROWS DESC

	SELECT *
	FROM @TABLE_INDEX_FRG
	WHERE 1=1
	AND DATABASE_NM = 'LGCE_INF'
	ORDER BY avg_fragmentation_in_percent DESC, TABLE_ROWS DESC

END



