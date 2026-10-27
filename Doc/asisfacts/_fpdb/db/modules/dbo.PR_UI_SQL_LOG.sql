

/*
 * Program ID   : PR_UI_SQL_LOG
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/22   chkim.68		SQL 로그 생성
 */

CREATE PROCEDURE [dbo].[PR_UI_SQL_LOG]
   @p_prog_id nvarchar(100),
   @p_user_id nvarchar(100),
   @p_query_id nvarchar(100),
   @p_query_seq int,
   @p_query_value nvarchar(max),
   @p_job_type nvarchar(10),
   @p_start datetime,
   @p_end datetime
AS 
BEGIN
	
	-- SEQ_UI_SQL
	DECLARE @v_inst_seq int
	DECLARE @v_inst_id nvarchar(20)
	DECLARE @v_sql  nvarchar(max) 

	DECLARE @each_linesize int
	DECLARE @line int
	DECLARE @roop int
	DECLARE @start int
	DECLARE @end int
	DECLARE @length int

	DECLARE @line_text nvarchar(4000)

	SET @v_sql  = @p_query_value
	--SET @v_inst_id = convert(decimal(12,4),getdate())
	--SET @v_inst_id = REPLACE(@v_inst_id,'.','_');
	--SET @v_inst_id = @v_inst_id + LEFT(@p_user_id,10)
	SET @v_inst_seq = NEXT VALUE FOR SEQ_UI_SQL
	SET @v_inst_id = convert(nvarchar(20), @v_inst_seq)

	SET @each_linesize = 4000
	SET @length = LEN(@v_sql)

	SET @line = @length / @each_linesize
	SET @line = @line + 1
	SET @roop = 0

	WHILE @line > 0
	BEGIN
		SET @start = @each_linesize * @roop +1
		SET @line_text = SUBSTRING(@v_sql, @start, @each_linesize)
		--print @line_text

		INSERT INTO [dbo].[TH_UIS_SQL_LOG]
					([PROG_ID]
					,[QUERY_ID]
					,[QUERY_SEQ]
					,[INST_SEQ]
					,[QUERY_VALUE]
					,[JOB_TYPE]
					,[START_TIME]
					,[END_TIME]
					,[INSERT_ID]
					,[INSERT_TIME])
					VALUES (
						@p_prog_id, 
						@p_query_id, 
						--@p_query_seq,
						@roop,
						@v_inst_id, 
						@line_text, 
						@p_job_type, 
						@p_start, 
						@p_end, 
						@p_user_id, 
						getdate())

		SET @line = @line -1
		SET @roop = @roop +1
	END  
	RETURN @v_inst_id

END

