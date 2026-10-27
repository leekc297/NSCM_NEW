-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_ZBK_DB_PARTITION_TABLE
-- Param               :
-- Batch Period        : 
-- Description         : 테이블 파티션 작업수행(신규/월별)을 수행합니다.
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2016.11.01
-- Author              : kimtwins
-- Version             : 1.0
-- ================================================================================================
-------------------- 실행 예시 -----------------------------------
-- basic_work
-------------
-- partition 대상 모든 테이블의 partition 스크립트를 생성합니다.
-- exec PR_ZBK_DB_PARTITION_TABLE 'basic_work', 'script', 'all'
-- partition 대상 모든 테이블의 partition 작업을 수행합니다.
-- exec PR_ZBK_DB_PARTITION_TABLE 'basic_work', 'exec', 'all'
-- 표기한 테이블의 partition 스크립트를 생성합니다.
-- exec PR_ZBK_DB_PARTITION_TABLE 'basic_work', 'script', 'TH_MST_BATCH_INFO'
-- 표기한 테이블의 partition 작업을 수행합니다.
-- exec PR_ZBK_DB_PARTITION_TABLE 'basic_work', 'exec', 'DBA_TEST___TH_MST_OFF_CALENDAR___20161104_08'

-------------
-- monthly_work
-------------
-- partition 대상의 모든 테이블의 월별 partition 작업의 스크립트를 생성합니다.
-- exec PR_ZBK_DB_PARTITION_TABLE 'monthly_work', 'script', 'all'
-- partition 대상의 모든 테이블의 월별 partition 작업을 수행합니다.
-- exec PR_ZBK_DB_PARTITION_TABLE 'monthly_work', 'exec', 'all'
-- partition 대상의 특정 테이블의 월별 partition 작업의 스크립트를 생성합니다.
-- exec PR_ZBK_DB_PARTITION_TABLE 'monthly_work', 'script', 'TH_MST_BATCH_INFO'
-- partition 대상의 특정 테이블의 월별 partition 작업을 수행합니다.
-- exec PR_ZBK_DB_PARTITION_TABLE 'monthly_work', 'exec', 'DBA_TEST___TH_MST_OFF_CALENDAR___20161104_08'

---------- 실행 예시 (에러) -----------------------------------
-- partition 대상 모든 테이블의 @result_type을 script/exec이 아닌 다른 문자 입력시 에러
-- exec PR_ZBK_DB_PARTITION_TABLE 'basic_work', 'xxx', 'all'
-- partition 대상 특정 테이블의 @result_type을 script/exec이 아닌 다른 문자 입력시 에러
-- exec PR_ZBK_DB_PARTITION_TABLE 'basic_work', 'xxx', 'AAA'
-- 입력 파라미터는 3개의 VARCHAR(30) 형식을 입력해야 합니다.
-- exec PR_ZBK_DB_PARTITION_TABLE 'basic_work', 'xxx'
-- exec PR_ZBK_DB_PARTITION_TABLE 'bbb', 'xxx'
-- exec PR_ZBK_DB_PARTITION_TABLE
-- exec PR_ZBK_DB_PARTITION_TABLE 'xxx', 'xxx', 'AAA'
-- exec PR_ZBK_DB_PARTITION_TABLE 'xxx', 'script', 'AAA'
-- exec PR_ZBK_DB_PARTITION_TABLE 'xxx', 'script', 'TH_MST_PREFER_SHIPMENT_DAY'
-- exec PR_ZBK_DB_PARTITION_TABLE 'xxx', 'script', 'ALL'
-- ================================================================================================

CREATE PROCEDURE [dbo].[PR_ZBK_DB_PARTITION_TABLE]
  @work_type	VARCHAR(30)
, @result_type	VARCHAR(30)
, @table_name	NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
			IF(@result_type != 'script' AND @result_type != 'exec')
				BEGIN

					PRINT '입력-에러 : @result_type 은 script 또는 exec 입니다.'
					RETURN
				END

			-- @partition_target_table 에 대상 테이블을 넣습니다.
			Declare @partition_target_table table
					( table_name VARCHAR(500) )

			IF (@table_name != 'all') AND NOT EXISTS
				(SELECT name FROM   sysobjects
				WHERE  name = @table_name
				AND   type = 'U')
			BEGIN
				PRINT '입력-에러 : 테이블이 데이터베이스에 없습니다.'
				RETURN
			END

			IF (@table_name = 'all')
				BEGIN
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_DPP_DEMAND_ATTRIBUTE')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_DPP_NET_DEMAND')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_BATCH_INFO')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_BATCH_INFO_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_BOD')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_BOD_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_BOD_PATTERN')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_FIXED_PLAN')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_INSTANCE_FLOW')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_ITEM')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_ITEM_BOD')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_ITEM_BOD_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_ITEM_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_ITEM_LANE')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_ITEM_LANE_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_ITEM_ROUTE_SITE')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OFF_CALENDAR')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OFF_CALENDAR_EQUIP')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OFF_CALENDAR_LINE')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OFFTYPE_INFO')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OP_RESOURCE')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OP_RESOURCE_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OP_RESOURCE_EQUIP_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OP_RESOURCE_LINE_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OPERATION')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_OPERATION_FLOW')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_PLAN')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_PLAN_BOM')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_PLAN_BOM_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_PRODUCT_MIX')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_RESOURCE')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_RESOURCE_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_ROUTE')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_SALES_PRODUCT_MAP')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_SALES_PRODUCT_MAP_CAL')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_SETUP_CATEGORY')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_SETUP_TIME')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_SITE')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_STOCK_PLAN')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_WIP')
					INSERT INTO @partition_target_table (table_name) VALUES ('TH_MST_WORK_CALENDAR')
				END
			ELSE
				INSERT INTO @partition_target_table (table_name) VALUES (@table_name)


			DECLARE   @target_table										VARCHAR(500)		---------- 대상 테이블
					, @name_filegroup									VARCHAR(500)		---------- FILEGROUP명
					, @name_file_db 									VARCHAR(500)				-- FILE명(db)
					, @name_file_real 									VARCHAR(500)				-- FILE명(실제 파일)
					, @name_before										VARCHAR(500)		---------- 현재월 기준 이전 2개월
					, @name_p1											VARCHAR(500)				-- 현재월 기준 이전 1개월
					, @name_p2											VARCHAR(500)				-- 현재월
					, @name_p3											VARCHAR(500)				-- 현재월 기준 이후 1개월
					, @name_p4											VARCHAR(500)				-- 현재월 기준 이후 2개월
					, @name_filegroup_before							VARCHAR(500)		---------- FILEGROUP명 before
					, @name_filegroup_p1								VARCHAR(500)				-- FILEGROUP명 p1
					, @name_filegroup_p2								VARCHAR(500)				-- FILEGROUP명 p2
					, @name_filegroup_p3								VARCHAR(500)				-- FILEGROUP명 p3
					, @name_filegroup_p4								VARCHAR(500)				-- FILEGROUP명 p4
					, @name_file_db_before								VARCHAR(500)		---------- FILE명(db) before
					, @name_file_db_p1									VARCHAR(500)				-- FILE명(db) p1
					, @name_file_db_p2									VARCHAR(500)				-- FILE명(db) p2
					, @name_file_db_p3									VARCHAR(500)				-- FILE명(db) p3
					, @name_file_db_p4									VARCHAR(500)				-- FILE명(db) p4
					, @name_file_real_before 							VARCHAR(500)		---------- FILE명(실제 파일) before
					, @name_file_real_p1 								VARCHAR(500)				-- FILE명(실제 파일) p1
					, @name_file_real_p2 								VARCHAR(500)				-- FILE명(실제 파일) p2
					, @name_file_real_p3 								VARCHAR(500)				-- FILE명(실제 파일) p3
					, @name_file_real_p4 								VARCHAR(500)				-- FILE명(실제 파일) p4
					, @name_pf_p1										VARCHAR(500)		---------- 현재월 기준 이전 1개월
					, @name_pf_p2										VARCHAR(500)				-- 현재월
					, @name_pf_p3										VARCHAR(500)				-- 현재월 기준 이후 1개월
					, @name_pf_p4										VARCHAR(500)				-- 현재월 기준 이후 2개월
					, @name_partition_function							VARCHAR(500)		---------- PARTITION FUNCTION명
					, @name_partition_scheme							VARCHAR(500)				-- PARTITION SCHEME명
					, @prefix_filegroup 								VARCHAR(500)		---------- 접두어 - FILEGROUP명
					, @prefix_file_db									VARCHAR(500)				-- 접두어 - FILE명(db)
					, @prefix_file_real									VARCHAR(500)				-- 접두어 - FILE명(실제 파일)
					, @prefix_partition_function						VARCHAR(500)				-- 접두어 - partition_function
					, @prefix_partition_scheme							VARCHAR(500)				-- 접두어 - partition_scheme
					, @file_real_path 									VARCHAR(MAX)		---------- FILE경로(실제 파일)
					, @frefix_of_full_file_path 						VARCHAR(MAX)				-- FILE경로(실제 파일)
					, @basic_folder_path								NVARCHAR(MAX)				-- FILE경로(실제 파일) 공통경로
					, @below_folder_path								NVARCHAR(MAX)				-- FILE경로(실제 파일) 공통경로 하위 경로
					, @name_now_database								VARCHAR(500)		---------- 현재 사용중인 데이터베이스 이름
					, @name_first_character								VARCHAR(500)		---------- 테이블명의 첫글자(TH_MST를 제외한 첫글자)
					, @sql_statement_f_add_p							NVARCHAR(MAX)		---------- 파일_생성_sql문_ADD
					, @sql_statement_fg_add_before						NVARCHAR(MAX)				-- 파일그룹_생성_sql문_ADD_before
					, @sql_statement_fg_add_p1							NVARCHAR(MAX)				-- 파일그룹_생성_sql문_ADD_p1
					, @sql_statement_fg_add_p2							NVARCHAR(MAX)				-- 파일그룹_생성_sql문_ADD_p2
					, @sql_statement_fg_add_p3							NVARCHAR(MAX)				-- 파일그룹_생성_sql문_ADD_p3
					, @sql_statement_fg_add_p4							NVARCHAR(MAX)				-- 파일그룹_생성_sql문_ADD_p4
					, @sql_statement_f_add_before						NVARCHAR(MAX)		---------- 파일_생성_sql문_ADD_before
					, @sql_statement_f_add_p1							NVARCHAR(MAX)				-- 파일_생성_sql문_파일_ADD_p1
					, @sql_statement_f_add_p2							NVARCHAR(MAX)				-- 파일_생성_sql문_파일_ADD_p2
					, @sql_statement_f_add_p3							NVARCHAR(MAX)				-- 파일_생성_sql문_파일_ADD_p3
					, @sql_statement_f_add_p4							NVARCHAR(MAX)				-- 파일_생성_sql문_파일_ADD_p4
					, @sql_statement_pf_add								NVARCHAR(MAX)		---------- partition_function_생성_sql문
					, @sql_statement_ps_add								NVARCHAR(MAX)				-- partition_scheme_생성_sql문
					, @sql_statement_ci_add								NVARCHAR(MAX)		---------- clustered_Index_생성_sql문
					, @sql_statement_ci_drop							NVARCHAR(MAX)				-- clustered_Index_삭제_sql문
					, @object_name										NVARCHAR(MAX)		---------- create table문 생성시 object_name					
					, @object_name_ready								NVARCHAR(MAX)				-- create table문 생성시 object_name
					, @object_id										INT							-- create table문 생성시 @object_id
					, @sql_statement_index_drop							NVARCHAR(MAX)				-- 대상 테이블의 index drop문
					, @sql_statement_table_drop							NVARCHAR(MAX)				-- 대상 테이블 drop문
					, @sql_statement_table_create						NVARCHAR(MAX)				-- 대상 테이블 생성 쿼리
					, @sql_statement_ready_table_create					NVARCHAR(MAX)				-- ready 테이블 생성 쿼리
					, @sql_statement_index_create						NVARCHAR(MAX)				-- index 생성 쿼리
					, @sql_statement_columns							NVARCHAR(MAX)				-- 수직으로 나열된 컬럼들
					, @sql_statement_table_insert						NVARCHAR(MAX)				-- table insert문
					, @target_table_ready								VARCHAR(500)				-- 준비테이블(대상테이블의 데이터를 복사:대상테이블이 존재하므로)
					, @sql_statement_ready_table_drop					NVARCHAR(MAX)				-- ready_table drop문
					, @sql_statement_monthly_new_fg						NVARCHAR(MAX)		---------- 월작업_파일그룹 추가
					, @sql_statement_monthly_new_f						NVARCHAR(MAX)				-- 월작업_파일 추가
					, @sql_statement_monthly_new_pf						NVARCHAR(MAX)				-- 월작업_partition function split alter
					, @sql_statement_monthly_new_ps						NVARCHAR(MAX)				-- 월작업_partition scheme
					, @sql_statement_monthly_old_DEL_table_create		NVARCHAR(MAX)				-- 월작업_임시삭제테이블 추가
					, @sql_statement_monthly_old_index_create			NVARCHAR(MAX)				-- 월작업_임시삭제테이블 인덱스 추가
					, @sql_statement_monthly_old_switch					NVARCHAR(MAX)				-- 월작업_스위치 추가
					, @sql_statement_monthly_old_pf						NVARCHAR(MAX)				-- 월작업_partition function merge alter
					, @sql_statement_monthly_old_DEL_table_drop			NVARCHAR(MAX)				-- 월작업_임시삭제테이블 drop
					, @sql_statement_monthly_old_f						NVARCHAR(MAX)				-- 월작업_파일 remove
					, @sql_statement_monthly_old_fg						NVARCHAR(MAX)				-- 월작업_파일그룹 remove
					, @name_file_db_monthly_new							NVARCHAR(MAX)		---------- 월작업_신규_FILE명(db)
					, @name_file_real_monthly_new						NVARCHAR(MAX)				-- 월작업_신규_FILE명(실제 파일)
					, @name_filegroup_monthly_new						NVARCHAR(MAX)				-- 월작업_신규_FILEGROUP명
					, @name_scheme_monthly_new							NVARCHAR(MAX)				-- 월작업_신규_scheme명
					, @name_monthly_new									NVARCHAR(50)				-- 월작업_신규 추가월
					, @name_pf_monthly_new_split_part					NVARCHAR(50)				-- 월작업_신규 partition function의 partition
					, @name_monthly_old_DEL_table						VARCHAR(500)				-- 월작업_삭제_임시삭제테이블 이름
					, @name_pf_monthly_old_merge_part					NVARCHAR(50)				-- 월작업_삭제_partition function의 old partition
					, @name_monthly_old									VARCHAR(50)			---------- 월작업_삭제_삭제월
					, @name_file_db_monthly_old							VARCHAR(500)				-- 월작업_삭제_FILE명(db)
					, @name_filegroup_monthly_old						VARCHAR(500)				-- 월작업_삭제_FILEGROUP명
					, @PRI_POSITION_1									INT					---------- CAREATE TABLE문중에 PK위치
					, @PK_STRING_1										NVARCHAR(MAX)				-- 첫번째 추출된 PK문
					, @IT_POSITION_2									INT							-- 첫번째 KEY_DATE 위치
					, @PK_STRING_2										NVARCHAR(MAX)				-- 두번째 추출된 PK문
					, @IT_POSITION_3									INT							-- 두번째 KEY_DATE 위치

			SET @name_now_database = DB_NAME()
			SET @prefix_filegroup = 'FG_'
			SET @prefix_file_db = 'F_'
			SET @prefix_file_real = 'RF_'
			SET @prefix_partition_function = 'PF_'
			SET @prefix_partition_scheme = 'PS_'

			IF(@result_type = 'script')
				BEGIN
					PRINT '---------------------------------------------------------------------------------------------'
					PRINT '-- @work_type = ' + @work_type + ' / @result_type = script / @table_name = ' + @table_name
					PRINT '---------------------------------------------------------------------------------------------'
					PRINT CHAR(13)
				END

			DECLARE target_table_cursor CURSOR FOR
				SELECT table_name
				FROM @partition_target_table

			OPEN target_table_cursor

			FETCH NEXT FROM target_table_cursor INTO @target_table
			WHILE (@@FETCH_STATUS=0)
				BEGIN
					SET @target_table_ready = @target_table + '_READY'
					SET @name_filegroup = @prefix_filegroup + @target_table
					SET @name_file_db = @prefix_file_db + @target_table
					SET @name_file_real = @prefix_file_real + @target_table
					--SET @basic_folder_path = 'D:\MSSQL_FP\MSSQL12.MSSQLSERVER\MSSQL\DATA\DBA_PARTITION_TEST\'	-- 개발서버
					--SET @below_folder_path = 'DBA_partition_'												-- 개발서버

					SET @basic_folder_path = 'G:\DATA\PART\'												-- 운영서버
					SET @below_folder_path = 'PART_'														-- 운영서버

					-- 파티션폴더에 들어가는 파일이 많아(220여개 파일).
					-- 폴더를 3개로 나누어 분할하여 들어 가게 함.
					SET @name_first_character = SUBSTRING(@target_table, CHARINDEX('TH_MST_',@target_table)+7, 1)

					IF @name_first_character<'J' 
						SET @frefix_of_full_file_path = @basic_folder_path + @name_now_database + '\' + @below_folder_path + '01\'
					ELSE IF @name_first_character<'R' 
						SET @frefix_of_full_file_path = @basic_folder_path + @name_now_database + '\' + @below_folder_path + '02\'
					ELSE 
						SET @frefix_of_full_file_path = @basic_folder_path + @name_now_database + '\' + @below_folder_path + '03\'

					-- @object_name, @object_name_ready, @object_id 지정
					SELECT
							  @object_name = '[' + s.name + '].[' + o.name + ']'
							, @object_name_ready = '[' + s.name + '].[' + o.name + '_READY]'
							, @object_id = o.[object_id]
					FROM sys.objects o WITH (NOWAIT)
					JOIN sys.schemas s WITH (NOWAIT) ON o.[schema_id] = s.[schema_id]
					WHERE s.name + '.' + o.name = 'dbo.' + @target_table
						AND o.[type] = 'U'
						AND o.is_ms_shipped = 0

					-- 대상 테이블의 컬럼열을 만듦.
					SELECT @sql_statement_columns = CHAR(9) + STUFF((
						SELECT CHAR(13) + CHAR(9) + ', [' + c.name + '] '
						FROM sys.columns c WITH (NOWAIT)
						WHERE c.[object_id] = @object_id
						ORDER BY c.column_id
						FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 4, CHAR(13) + CHAR(9) + '  ')

					-- 대상 테이블 스크립트 파티션 로그 테이블에 저장
					-- (CREATE TABLE문, CREATE INDEX문)
					;WITH index_column AS 
					(
						SELECT 
							  ic.[object_id]
							, ic.index_id
							, ic.is_descending_key
							, ic.is_included_column
							, c.name
						FROM sys.index_columns ic WITH (NOWAIT)
						JOIN sys.columns c WITH (NOWAIT) ON ic.[object_id] = c.[object_id] 
														AND ic.column_id = c.column_id
						WHERE ic.[object_id] = @object_id
					),
					fk_columns AS 
					(
							SELECT 
								k.constraint_object_id
							, cname = c.name
							, rcname = rc.name
						FROM sys.foreign_key_columns k WITH (NOWAIT)
						JOIN sys.columns rc WITH (NOWAIT) ON rc.[object_id] = k.referenced_object_id AND rc.column_id = k.referenced_column_id 
						JOIN sys.columns c WITH (NOWAIT) ON c.[object_id] = k.parent_object_id AND c.column_id = k.parent_column_id
						WHERE k.parent_object_id = @object_id
					)
					SELECT @sql_statement_table_create = 'CREATE TABLE {TABLE_NAME}' + CHAR(13) + '(' + CHAR(13) + STUFF((
						SELECT CHAR(9) + ', [' + c.name + '] ' + 
							CASE WHEN c.is_computed = 1
								THEN 'AS ' + cc.[definition] 
								ELSE UPPER(tp.name) + 
									CASE WHEN tp.name IN ('varchar', 'char', 'varbinary', 'binary', 'text')
											THEN '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length AS VARCHAR(5)) END + ')'
											WHEN tp.name IN ('nvarchar', 'nchar', 'ntext')
											THEN '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length / 2 AS VARCHAR(5)) END + ')'
											WHEN tp.name IN ('datetime2', 'time2', 'datetimeoffset') 
											THEN '(' + CAST(c.scale AS VARCHAR(5)) + ')'
											--WHEN tp.name = 'decimal' 
											WHEN tp.name IN ('decimal', 'numeric')
											THEN '(' + CAST(c.[precision] AS VARCHAR(5)) + ',' + CAST(c.scale AS VARCHAR(5)) + ')'
										ELSE ''
									END +
									--CASE WHEN c.collation_name IS NOT NULL THEN ' COLLATE ' + c.collation_name ELSE '' END + -- 여기
									CASE WHEN c.is_nullable = 1 THEN ' NULL' ELSE ' NOT NULL' END +
									CASE WHEN dc.[definition] IS NOT NULL THEN ' DEFAULT' + dc.[definition] ELSE '' END + 
									CASE WHEN ic.is_identity = 1 THEN ' IDENTITY(' + CAST(ISNULL(ic.seed_value, '0') AS CHAR(1)) + ',' + CAST(ISNULL(ic.increment_value, '1') AS CHAR(1)) + ')' ELSE '' END 
							END + CHAR(13)
						FROM sys.columns c WITH (NOWAIT)
						JOIN sys.types tp WITH (NOWAIT) ON c.user_type_id = tp.user_type_id
						LEFT JOIN sys.computed_columns cc WITH (NOWAIT) ON c.[object_id] = cc.[object_id] AND c.column_id = cc.column_id
						LEFT JOIN sys.default_constraints dc WITH (NOWAIT) ON c.default_object_id != 0 AND c.[object_id] = dc.parent_object_id AND c.column_id = dc.parent_column_id
						LEFT JOIN sys.identity_columns ic WITH (NOWAIT) ON c.is_identity = 1 AND c.[object_id] = ic.[object_id] AND c.column_id = ic.column_id
						WHERE c.[object_id] = @object_id
						ORDER BY c.column_id
						FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, CHAR(9) + ' ')
						+ ISNULL((SELECT CHAR(9) + ', CONSTRAINT [' + k.name + '{PK_DEL}' + '] PRIMARY KEY (' + CHAR(13) + -- 여기
										(SELECT CHAR(9) + CHAR(9) + STUFF(( -- 여기
												SELECT CHAR(9) + CHAR(9) + ', [' + c.name + '] ' + CASE WHEN ic.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END + CHAR(13)  -- 여기
												FROM sys.index_columns ic WITH (NOWAIT)
												JOIN sys.columns c WITH (NOWAIT) ON c.[object_id] = ic.[object_id] AND c.column_id = ic.column_id
												WHERE ic.is_included_column = 0
													AND ic.[object_id] = k.parent_object_id 
													AND ic.index_id = k.unique_index_id     
												FOR XML PATH(N''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, ' ')) -- 여기
								+ CHAR(9) + CHAR(9) + '{KEY_DATE}' + CHAR(13) + ') ON {PK_PRIMARY}' + CHAR(13)
								FROM sys.key_constraints k WITH (NOWAIT)
								WHERE k.parent_object_id = @object_id 
									AND k.[type] = 'PK'), '') + ') ON {TABLE_PRIMARY}'  + CHAR(13)

					-- index 생성문을 만듭니다.
					;WITH index_column AS 
					(
						SELECT 
								ic.[object_id]
							, ic.index_id
							, ic.is_descending_key
							, ic.is_included_column
							, c.name
						FROM sys.index_columns ic WITH (NOWAIT)
						JOIN sys.columns c WITH (NOWAIT) ON ic.[object_id] = c.[object_id] AND ic.column_id = c.column_id
						WHERE ic.[object_id] = @object_id
					),
					fk_columns AS 
					(
							SELECT 
								k.constraint_object_id
							, cname = c.name
							, rcname = rc.name
						FROM sys.foreign_key_columns k WITH (NOWAIT)
						JOIN sys.columns rc WITH (NOWAIT) ON rc.[object_id] = k.referenced_object_id AND rc.column_id = k.referenced_column_id 
						JOIN sys.columns c WITH (NOWAIT) ON c.[object_id] = k.parent_object_id AND c.column_id = k.parent_column_id
						WHERE k.parent_object_id = @object_id
					)SELECT @sql_statement_index_create = ISNULL(((SELECT
								CHAR(13) + 'GO' + CHAR(13) + 'CREATE' + CASE WHEN i.is_unique = 1 THEN ' UNIQUE' ELSE '' END 
									+ ' NONCLUSTERED INDEX [' + i.name + '{_DEL}' + '] ON {TABLE_NAME} (' + CHAR(13) + -- 여기
									CHAR(9) + STUFF((
									SELECT CHAR(13) + CHAR(9) + CHAR(9) + ', [' + c.name + ']' + CASE WHEN c.is_descending_key = 1 THEN ' DESC' ELSE ' ASC' END
									FROM index_column c
									WHERE c.is_included_column = 0
										AND c.index_id = i.index_id
									FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 4, CHAR(9) + ' ') + CHAR(13)  + ')' -- 여기
									+ ISNULL(CHAR(13) + 'INCLUDE (' + 
										STUFF((
										SELECT ', [' + c.name + ']'
										FROM index_column c
										WHERE c.is_included_column = 1
											AND c.index_id = i.index_id
										FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 8, ' ') + ')', '')
							FROM sys.indexes i WITH (NOWAIT)
							WHERE i.[object_id] = @object_id
								AND i.is_primary_key = 0
								AND i.[type] = 2
								AND i.name IS NOT NULL
							FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')
						), '')

					SET @name_partition_function = @prefix_partition_function + @target_table
					SET @name_partition_scheme = @prefix_partition_scheme + @target_table

					SET @sql_statement_f_add_p =  
					CHAR(13) + 'ALTER DATABASE ' + @name_now_database + 
					CHAR(13) + 'ADD FILE ' + 
					CHAR(13) + '( '  + 
					CHAR(13) + '	NAME = {name_file_db},  ' + 
					CHAR(13) + '	FILENAME = ' + '''' + @frefix_of_full_file_path  + '{name_file_real}.ndf'', ' +  
					CHAR(13) + '	SIZE = 300MB, ' +
					CHAR(13) + '	MAXSIZE = UNLIMITED, ' +
					CHAR(13) + '	FILEGROWTH = 200MB ' +
					CHAR(13) + ')  ' + 
					CHAR(13) + 'TO FILEGROUP {name_filegroup}'

					IF(@work_type = 'basic_work')
						BEGIN

							-- 대상 테이블의 데이터를 _READY로 인서트
							SET @sql_statement_ready_table_create = 'SELECT ' + 
																@sql_statement_columns + CHAR(13) +
																'INTO [' + @target_table_ready +']' + CHAR(13) +
																'FROM [' + @target_table + ']'

							-- 대상 테이블의 INDEX삭제
							select @sql_statement_index_drop = 'DROP INDEX' + STUFF((
							SELECT CHAR(13) + 'DROP INDEX [' + CAST(si.name AS VARCHAR) + '] ON [' + @target_table + ']' + CHAR(13) + 'GO' + CHAR(13)
							FROM sys.objects so, sys.indexes si
							WHERE 1=1
							AND so.object_id = si.object_id
							AND so.type = 'U'
							AND so.NAME = @target_table
							AND si.is_primary_key != 1
							AND si.name IS NOT NULL
							FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 12, ' ')

							-- 대상 테이블을 DROP
							SET @sql_statement_table_drop = 'DROP TABLE [' + @target_table +']'

							-- 대상 테이블을 CREATE
							SET @sql_statement_table_create = REPLACE(@sql_statement_table_create, '{TABLE_NAME}', '[' + @target_table + ']')

							-- 대상 테이블의 PK에 KEY_DATE가 없으면 포함시킴.
							SELECT @PRI_POSITION_1 = PATINDEX('%PRIMARY KEY (%',@sql_statement_table_create)
							SELECT @PK_STRING_1 = SUBSTRING(@sql_statement_table_create, @PRI_POSITION_1 , LEN(@sql_statement_table_create)-@PRI_POSITION_1)
							SELECT @IT_POSITION_2 = PATINDEX('%KEY_DATE%',@PK_STRING_1)
							SELECT @PK_STRING_2 = SUBSTRING(@PK_STRING_1, @IT_POSITION_2 + 12 , LEN(@PK_STRING_1)-@IT_POSITION_2-12)
							SELECT @IT_POSITION_3 = PATINDEX('%KEY_DATE%',@PK_STRING_2)

							IF @IT_POSITION_3 = 0
								SET @sql_statement_table_create = REPLACE(@sql_statement_table_create, '{KEY_DATE}', ', [KEY_DATE] ASC' )
							ELSE
								SET @sql_statement_table_create = REPLACE(@sql_statement_table_create, '{KEY_DATE}', '' )

							SET @sql_statement_table_create = REPLACE(@sql_statement_table_create, '{PK_PRIMARY}', @name_partition_scheme + ' ( KEY_DATE )' )
							SET @sql_statement_table_create = REPLACE(@sql_statement_table_create, '{TABLE_PRIMARY}', @name_partition_scheme + ' ( KEY_DATE )' )

							-- PK명 설정.
							SET @sql_statement_table_create = REPLACE(@sql_statement_table_create, '{PK_DEL}', '' )

							-- 대상 테이블의 INDEX 생성

							-- 이전 2개월 삭제 : _DEL 테이블의 PK가 아닌 인덱스를 생성합니다.
							SET @sql_statement_index_create = REPLACE(@sql_statement_index_create, '{TABLE_NAME}', '[' + @target_table + ']')
							-- @sql_statement_table_create 를 한번만 만들어서 basic_work, monthly_work에서 같이 사용하여 _DEL을 삭제한다.
							SET @sql_statement_index_create = REPLACE(@sql_statement_index_create, '{_DEL}', '')

							-- 대상 테이블에 _READY의 데이터를 인서트
							SET @sql_statement_table_insert = 'INSERT INTO [' + @target_table + '] (' +
																@sql_statement_columns + CHAR(13) +
																')' + CHAR(13) + 'SELECT' +
																@sql_statement_columns + CHAR(13) +
																'FROM [' + @target_table_ready + ']'
							-- ready 테이블을 drop 시킴.
							SET @sql_statement_ready_table_drop = 'DROP TABLE [' + @target_table_ready + ']'
							SET @name_before = LEFT(CONVERT(VARCHAR, DATEADD(M,-2,GETDATE()), 112), 6)
							SET @name_p1 = LEFT(CONVERT(VARCHAR, DATEADD(M,-1,GETDATE()), 112), 6)
							SET @name_p2 = LEFT(CONVERT(VARCHAR, GETDATE(), 112), 6)
							SET @name_p3 = LEFT(CONVERT(VARCHAR, DATEADD(M,1,GETDATE()), 112), 6)
							SET @name_p4 = LEFT(CONVERT(VARCHAR, DATEADD(M,2,GETDATE()), 112), 6)
							SET @name_filegroup_before = @name_filegroup + '_' + @name_before
							SET @name_filegroup_p1 = @name_filegroup + '_' + @name_p1
							SET @name_filegroup_p2 = @name_filegroup + '_' + @name_p2
							SET @name_filegroup_p3 = @name_filegroup + '_' + @name_p3
							SET @name_filegroup_p4 = @name_filegroup + '_' + @name_p4
							SET @name_file_db_before = @name_file_db + '_' + @name_before
							SET @name_file_db_p1 = @name_file_db + '_' + @name_p1
							SET @name_file_db_p2 = @name_file_db + '_' + @name_p2
							SET @name_file_db_p3 = @name_file_db + '_' + @name_p3
							SET @name_file_db_p4 = @name_file_db + '_' + @name_p4
							SET @name_file_real_before = @name_file_real + '_' + @name_before
							SET @name_file_real_p1 = @name_file_real + '_' + @name_p1
							SET @name_file_real_p2 = @name_file_real + '_' + @name_p2
							SET @name_file_real_p3 = @name_file_real + '_' + @name_p3
							SET @name_file_real_p4 = @name_file_real + '_' + @name_p4
							SET @name_file_db	= @prefix_file_db	+ @target_table
							SET @name_file_real = @prefix_file_real + @target_table
							--SET @name_pf_p1 = LEFT(CONVERT(VARCHAR, DATEADD(M,-1,GETDATE()), 23),8) + '01T00:00:00'
							--SET @name_pf_p2 = LEFT(CONVERT(VARCHAR, GETDATE(), 23),8) + '01T00:00:00'
							--SET @name_pf_p3 = LEFT(CONVERT(VARCHAR, DATEADD(M,1,GETDATE()), 23),8) + '01T00:00:00'
							--SET @name_pf_p4 = LEFT(CONVERT(VARCHAR, DATEADD(M,2,GETDATE()), 23),8) + '01T00:00:00'

--SELECT LEFT(CONVERT(VARCHAR, GETDATE(), 23),8)
--SELECT CONVERT(VARCHAR, GETDATE(), 112)
--ms sql CONVERT 23


							SET @name_pf_p1 = LEFT(CONVERT(VARCHAR, DATEADD(M,-1,GETDATE()), 112),6) + '01'
							SET @name_pf_p2 = LEFT(CONVERT(VARCHAR, GETDATE(), 112),6) + '01'
							SET @name_pf_p3 = LEFT(CONVERT(VARCHAR, DATEADD(M,1,GETDATE()), 112),6) + '01'
							SET @name_pf_p4 = LEFT(CONVERT(VARCHAR, DATEADD(M,2,GETDATE()), 112),6) + '01'

							-- FILEGROUP 생성합니다.
							SET @sql_statement_fg_add_before = 'ALTER DATABASE ' + @name_now_database + ' ADD FILEGROUP ' + @name_filegroup_before + ' '
							SET @sql_statement_fg_add_p1 = 'ALTER DATABASE ' + @name_now_database + ' ADD FILEGROUP ' + @name_filegroup_p1 + ' '
							SET @sql_statement_fg_add_p2 = 'ALTER DATABASE ' + @name_now_database + ' ADD FILEGROUP ' + @name_filegroup_p2 + ' '
							SET @sql_statement_fg_add_p3 = 'ALTER DATABASE ' + @name_now_database + ' ADD FILEGROUP ' + @name_filegroup_p3 + ' '
							SET @sql_statement_fg_add_p4 = 'ALTER DATABASE ' + @name_now_database + ' ADD FILEGROUP ' + @name_filegroup_p4 + ' '

							-- FILE을 생성합니다.
							SET @sql_statement_f_add_before = REPLACE(@sql_statement_f_add_p, '{name_file_db}',@name_file_db_before)
							SET @sql_statement_f_add_before = REPLACE(@sql_statement_f_add_before, '{name_file_real}',@name_file_real_before)
							SET @sql_statement_f_add_before = REPLACE(@sql_statement_f_add_before, '{name_filegroup}',@name_filegroup_before)
							SET @sql_statement_f_add_p1 = REPLACE(@sql_statement_f_add_p, '{name_file_db}',@name_file_db_p1)
							SET @sql_statement_f_add_p1 = REPLACE(@sql_statement_f_add_p1, '{name_file_real}',@name_file_real_p1)
							SET @sql_statement_f_add_p1 = REPLACE(@sql_statement_f_add_p1, '{name_filegroup}',@name_filegroup_p1)
							SET @sql_statement_f_add_p2 = REPLACE(@sql_statement_f_add_p, '{name_file_db}',@name_file_db_p2)
							SET @sql_statement_f_add_p2 = REPLACE(@sql_statement_f_add_p2, '{name_file_real}',@name_file_real_p2)
							SET @sql_statement_f_add_p2 = REPLACE(@sql_statement_f_add_p2, '{name_filegroup}',@name_filegroup_p2)
							SET @sql_statement_f_add_p3 = REPLACE(@sql_statement_f_add_p, '{name_file_db}',@name_file_db_p3)
							SET @sql_statement_f_add_p3 = REPLACE(@sql_statement_f_add_p3, '{name_file_real}',@name_file_real_p3)
							SET @sql_statement_f_add_p3 = REPLACE(@sql_statement_f_add_p3, '{name_filegroup}',@name_filegroup_p3)
							SET @sql_statement_f_add_p4 = REPLACE(@sql_statement_f_add_p, '{name_file_db}',@name_file_db_p4)
							SET @sql_statement_f_add_p4 = REPLACE(@sql_statement_f_add_p4, '{name_file_real}',@name_file_real_p4)
							SET @sql_statement_f_add_p4 = REPLACE(@sql_statement_f_add_p4, '{name_filegroup}',@name_filegroup_p4)

							-- PARTITION FUNCTION을 만든다.
							SET @sql_statement_pf_add = N'CREATE PARTITION FUNCTION ' + 
							@name_partition_function + 
							N'(NVARCHAR(8)) AS RANGE RIGHT FOR VALUES (
							N' + N'''' + @name_pf_p1 + N'''' + ', 
							N' + N'''' + @name_pf_p2 + N'''' + ', 
							N' + N'''' + @name_pf_p3 + N'''' + ', 
							N' + N'''' + @name_pf_p4 + N'''' + ') '

							-- PARTITION SCHEME을 만든다.
							SET @sql_statement_ps_add = N'CREATE PARTITION SCHEME ' + @name_partition_scheme + 
							N' AS PARTITION ' + @name_partition_function + N' TO 
							(' + @name_filegroup_before + N', 
							' + @name_filegroup_p1 + N', 
							' + @name_filegroup_p2 + N', 
							' + @name_filegroup_p3 + N', 
							' + @name_filegroup_p4 + N') '

							SET @sql_statement_ready_table_create = @sql_statement_ready_table_create + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_index_drop =  @sql_statement_index_drop + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_table_drop =  @sql_statement_table_drop + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_fg_add_before =  @sql_statement_fg_add_before + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_fg_add_p1 =  @sql_statement_fg_add_p1 + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_fg_add_p2 =  @sql_statement_fg_add_p2 + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_fg_add_p3 =  @sql_statement_fg_add_p3 + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_fg_add_p4 =  @sql_statement_fg_add_p4 + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_f_add_before =  @sql_statement_f_add_before + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_f_add_p1 =  @sql_statement_f_add_p1 + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_f_add_p2 =  @sql_statement_f_add_p2 + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_f_add_p3 =  @sql_statement_f_add_p3 + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_f_add_p4 =  @sql_statement_f_add_p4 + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_pf_add =  @sql_statement_pf_add + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_ps_add =  @sql_statement_ps_add + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_table_create =  @sql_statement_table_create + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_index_create =  @sql_statement_index_create + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_table_insert =  @sql_statement_table_insert + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_ready_table_drop =  @sql_statement_ready_table_drop + CHAR(13) + CHAR(13) + ' '

							IF(@result_type = 'script')
								BEGIN
									PRINT @sql_statement_ready_table_create
									PRINT @sql_statement_index_drop
									PRINT @sql_statement_table_drop
									PRINT @sql_statement_fg_add_before
									PRINT @sql_statement_fg_add_p1
									PRINT @sql_statement_fg_add_p2
									PRINT @sql_statement_fg_add_p3
									PRINT @sql_statement_fg_add_p4
									PRINT @sql_statement_f_add_before
									PRINT @sql_statement_f_add_p1
									PRINT @sql_statement_f_add_p2
									PRINT @sql_statement_f_add_p3
									PRINT @sql_statement_f_add_p4
									PRINT @sql_statement_pf_add
									PRINT @sql_statement_ps_add
									PRINT @sql_statement_table_create
									PRINT @sql_statement_index_create
									PRINT @sql_statement_table_insert
									PRINT @sql_statement_ready_table_drop
									PRINT '-------------------------------------------------------------------------------'
								END
							ELSE IF(@result_type = 'exec')
								BEGIN								
									EXECUTE (@sql_statement_ready_table_create)
									EXECUTE (@sql_statement_index_drop)
									EXECUTE (@sql_statement_table_drop)
									EXECUTE (@sql_statement_fg_add_before)
									EXECUTE (@sql_statement_fg_add_p1)
									EXECUTE (@sql_statement_fg_add_p2)
									EXECUTE (@sql_statement_fg_add_p3)
									EXECUTE (@sql_statement_fg_add_p4)
									EXECUTE (@sql_statement_f_add_before)
									EXECUTE (@sql_statement_f_add_p1)
									EXECUTE (@sql_statement_f_add_p2)
									EXECUTE (@sql_statement_f_add_p3)
									EXECUTE (@sql_statement_f_add_p4)
									EXECUTE (@sql_statement_pf_add)
									EXECUTE (@sql_statement_ps_add)
									EXECUTE (@sql_statement_table_create)
									EXECUTE (@sql_statement_index_create)
									EXECUTE (@sql_statement_table_insert)
									EXECUTE (@sql_statement_ready_table_drop)
								END
						END
					ELSE IF(@work_type = 'monthly_work')
						BEGIN
							IF(@result_type != 'script' AND @result_type != 'exec')
								BEGIN
									PRINT '입력-에러 : @result_type 은 script 또는 exec 입니다.'
									RETURN
								END

							-- 현재 일자 기준 이후 3월
							SET @name_monthly_new = LEFT(CONVERT(VARCHAR, DATEADD(M,3,GETDATE()), 112), 6)
							SET @name_file_db_monthly_new = @name_file_db + '_' + @name_monthly_new
							SET @name_file_real_monthly_new = @name_file_real  + '_' + @name_monthly_new
							SET @name_filegroup_monthly_new = @name_filegroup + '_' + @name_monthly_new

							-- 신규달 추가 : fg 추가
							SET @sql_statement_monthly_new_fg = N'ALTER DATABASE ' + @name_now_database + N' ADD FILEGROUP ' + @name_filegroup_monthly_new + N' '
							SET @sql_statement_monthly_new_f = REPLACE(@sql_statement_f_add_p, '{name_file_db}',@name_file_db_monthly_new)
							SET @sql_statement_monthly_new_f = REPLACE(@sql_statement_monthly_new_f, '{name_file_real}',@name_file_real_monthly_new)
							SET @sql_statement_monthly_new_f = REPLACE(@sql_statement_monthly_new_f, '{name_filegroup}',@name_filegroup_monthly_new)

							-- 신규달 추가 : ps 추가
							SET @name_scheme_monthly_new = @name_partition_scheme
							SET @sql_statement_monthly_new_ps = N'ALTER PARTITION SCHEME ' + @name_scheme_monthly_new +
																+ N' NEXT USED ' + @name_filegroup_monthly_new + ' '

							-- 신규달 추가 : pf 를 split
							--SET @name_pf_monthly_new_split_part = LEFT(CONVERT(VARCHAR, DATEADD(M,3,GETDATE()), 23),8) + '01T00:00:00'
							SET @name_pf_monthly_new_split_part = LEFT(CONVERT(VARCHAR, DATEADD(M,3,GETDATE()), 112),6) + '01'
							SET @sql_statement_monthly_new_pf = N'ALTER PARTITION FUNCTION ' + 
							@name_partition_function + 
							N'()  SPLIT RANGE (' + N'N''' + @name_pf_monthly_new_split_part  + N'''' + ') '

							-- 현재 일자 기준 이전 1월
							SET @name_monthly_old = LEFT(CONVERT(VARCHAR, DATEADD(M,-1,GETDATE()), 112), 6)
							SET @name_file_db_monthly_old = @name_file_db + '_' + @name_monthly_old
							SET @name_filegroup_monthly_old = @name_filegroup + '_' + @name_monthly_old

							-- 이전 2개월 삭제 : _DEL 테이블을 만듭니다. (이전 2개월 파일그룹에 연결하여 만듦.)
							SET @name_monthly_old_DEL_table = @target_table + '_DEL'
							SET @sql_statement_monthly_old_DEL_table_create = REPLACE(@sql_statement_table_create, '{TABLE_NAME}', '[' + @name_monthly_old_DEL_table + ']')
							SET @sql_statement_monthly_old_DEL_table_create = REPLACE(@sql_statement_monthly_old_DEL_table_create, 'ON {PK_PRIMARY}', '' )
							SET @sql_statement_monthly_old_DEL_table_create = REPLACE(@sql_statement_monthly_old_DEL_table_create, '{TABLE_PRIMARY}', @name_filegroup_monthly_old)

							-- _DEL 테이블의 PK에 KEY_DATE가 없으면 포함시킴.
							SELECT @PRI_POSITION_1 = PATINDEX('%PRIMARY KEY (%',@sql_statement_monthly_old_DEL_table_create)
							SELECT @PK_STRING_1 = SUBSTRING(@sql_statement_monthly_old_DEL_table_create, @PRI_POSITION_1 , LEN(@sql_statement_monthly_old_DEL_table_create)-@PRI_POSITION_1)
							SELECT @IT_POSITION_2 = PATINDEX('%KEY_DATE%',@PK_STRING_1)
							SELECT @PK_STRING_2 = SUBSTRING(@PK_STRING_1, @IT_POSITION_2 + 12 , LEN(@PK_STRING_1)-@IT_POSITION_2-12)
							SELECT @IT_POSITION_3 = PATINDEX('%KEY_DATE%',@PK_STRING_2)

							IF @IT_POSITION_3 = 0
								SET @sql_statement_monthly_old_DEL_table_create = REPLACE(@sql_statement_monthly_old_DEL_table_create, '{KEY_DATE}', ', [KEY_DATE] ASC' )
							ELSE
								SET @sql_statement_monthly_old_DEL_table_create = REPLACE(@sql_statement_monthly_old_DEL_table_create, '{KEY_DATE}', '' )

							-- PK명 설정.
							SET @sql_statement_monthly_old_DEL_table_create = REPLACE(@sql_statement_monthly_old_DEL_table_create, '{PK_DEL}', '_DEL' )

							-- 이전 2개월 삭제 : _DEL 테이블의 PK가 아닌 인덱스를 생성합니다.
							SET @sql_statement_monthly_old_index_create = REPLACE(@sql_statement_index_create, '{TABLE_NAME}', '[' + @name_monthly_old_DEL_table + ']')
							-- @sql_statement_table_create 를 한번만 만들어서 basic_work, monthly_work에서 같이 사용하여 _DEL을 추가합니다.
							SET @sql_statement_monthly_old_index_create = REPLACE(@sql_statement_monthly_old_index_create, '{_DEL}', '_DEL')

							-- 이전 2개월 삭제 : 스위치 합니다.
							SET @sql_statement_monthly_old_switch = 'ALTER TABLE [' + @target_table + '] SWITCH PARTITION 2 TO [' + @name_monthly_old_DEL_table + ']'

							-- pf : merge
							--SET @name_pf_monthly_old_merge_part = LEFT(CONVERT(VARCHAR, DATEADD(M,-1,GETDATE()), 23),8) + '01T00:00:00'
							SET @name_pf_monthly_old_merge_part = LEFT(CONVERT(VARCHAR, DATEADD(M,-1,GETDATE()), 112),6) + '01'
							SET @sql_statement_monthly_old_pf = N'ALTER PARTITION FUNCTION ' + 
							@name_partition_function + 
							N'() MERGE RANGE (' + N'N''' + @name_pf_monthly_old_merge_part  + N'''' + ') '

							-- 이전 2개월 삭제 : _DEL 테이블을 DROP 시킵니다. (이전 2개월 파일그룹에 연결하여 만듦.)
							SET @sql_statement_monthly_old_DEL_table_drop = 'DROP TABLE [' + @name_monthly_old_DEL_table + ']'

							---- 파일 그룹을 remove 합니다.
							--SET @sql_statement_monthly_old_f = 'ALTER DATABASE ' + @name_now_database + ' REMOVE FILE ' + @name_file_db_monthly_old

							---- 파일 그룹을 remove 합니다.
							--SET @sql_statement_monthly_old_fg = 'ALTER DATABASE ' + @name_now_database + ' REMOVE FILEGROUP ' + @name_filegroup_monthly_old

							SET @sql_statement_monthly_new_fg = @sql_statement_monthly_new_fg + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_new_f = @sql_statement_monthly_new_f + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_new_ps = @sql_statement_monthly_new_ps + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_new_pf = @sql_statement_monthly_new_pf + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_old_DEL_table_create = @sql_statement_monthly_old_DEL_table_create + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_old_index_create = @sql_statement_monthly_old_index_create + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_old_switch = @sql_statement_monthly_old_switch + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_old_pf = @sql_statement_monthly_old_pf + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_old_DEL_table_drop = @sql_statement_monthly_old_DEL_table_drop + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_old_f = @sql_statement_monthly_old_f + CHAR(13) + CHAR(13) + ' '
							SET @sql_statement_monthly_old_fg = @sql_statement_monthly_old_fg + CHAR(13) + CHAR(13) + ' '

							IF(@result_type = 'script')
								BEGIN
									PRINT '-------- 신규월 추가' + CHAR(13) + CHAR(13)
									PRINT @sql_statement_monthly_new_fg
									PRINT @sql_statement_monthly_new_f
									PRINT @sql_statement_monthly_new_ps
									PRINT @sql_statement_monthly_new_pf
									PRINT '--------   이전 2개월째 달 삭제' + CHAR(13) + CHAR(13)
									PRINT @sql_statement_monthly_old_DEL_table_create
									PRINT @sql_statement_monthly_old_index_create
									PRINT @sql_statement_monthly_old_switch
									PRINT @sql_statement_monthly_old_pf
									PRINT @sql_statement_monthly_old_DEL_table_drop
									--PRINT @sql_statement_monthly_old_f
									--PRINT @sql_statement_monthly_old_fg
									PRINT '-------------------------------------------------------------------------------'
								END
							ELSE IF(@result_type = 'exec')
								BEGIN
									EXECUTE (@sql_statement_monthly_new_fg)
									EXECUTE (@sql_statement_monthly_new_f)
									EXECUTE (@sql_statement_monthly_new_ps)
									EXECUTE (@sql_statement_monthly_new_pf)
									EXECUTE (@sql_statement_monthly_old_DEL_table_create)
									EXECUTE (@sql_statement_monthly_old_index_create)
									EXECUTE (@sql_statement_monthly_old_switch)
									EXECUTE (@sql_statement_monthly_old_pf)
									EXECUTE (@sql_statement_monthly_old_DEL_table_drop)
									--EXECUTE (@sql_statement_monthly_old_f)
									--EXECUTE (@sql_statement_monthly_old_fg)
								END
						END
					ELSE
						BEGIN

							PRINT '입력-에러 : @work_type 은 basic_work 또는 monthly_work 입니다.'
							RETURN
						END
					FETCH NEXT FROM target_table_cursor INTO @target_table
				END
			CLOSE target_table_cursor
			DEALLOCATE target_table_cursor
			PRINT '--------------------------------------'
			PRINT '-- Stored Procedure 실행이 끝났습니다.'
			PRINT '--------------------------------------'
END
