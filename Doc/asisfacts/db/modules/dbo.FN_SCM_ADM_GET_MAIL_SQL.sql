/*
 * Program ID   : FN_SCM_ADM_GET_MAIL_SQL
 * Description  : sql_long_text를 가져온다.
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/06   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/03   ygkim	@v_SQL5 추가
 * 2018/07/16   hwyoon	쿼리 분할 삭제
  */
CREATE FUNCTION [dbo].[FN_SCM_ADM_GET_MAIL_SQL]
(
   @p_categoryID		INT
)
RETURNS @SqlTable TABLE
(
	result		NVARCHAR(MAX)--,
	--result2		NVARCHAR(MAX),
	--result3		NVARCHAR(MAX),
	--result4		NVARCHAR(MAX)
)
AS
BEGIN
	DECLARE @v_SQL	NVARCHAR(MAX);
	DECLARE @v_SQL2 NVARCHAR(MAX);
	DECLARE @v_SQL3 NVARCHAR(MAX);
	DECLARE @v_SQL4 NVARCHAR(MAX);
	DECLARE @v_SQL5 NVARCHAR(MAX);

	SELECT @v_SQL = nrm.sql_long_text
	FROM SCM_ADM_RECIPIENT_LIST nrm
	WHERE nrm.category_id = @p_categoryID;

	IF ISNULL(@v_SQL,'') = '' 
		SET @v_SQL = N'SELECT '''' segment1,'''' segment2,'''' segment3,'''' segment4,'''' segment5,'''' segment6,'''' segment7,'''' segment8,'''' segment9,'''' segment10
		              ,'''' user_id,''KO'' language_code,'''' user_name,'''' email_addr,'''' mobile_phone ,'''' column1,'''' column2,''''  column3,'''' column4,'''' column5
					  ,'''' column6,'''' column7,'''' column8,'''' column9,'''' column10,''N''  detail_message_flag'

	--SET @v_SQL2 =SUBSTRING(@v_SQL, 1,256*8);
    --SET @v_SQL3 =SUBSTRING(@v_SQL, 256*8+1,256*8);
    --SET @v_SQL4 =SUBSTRING(@v_SQL, 256*16+1,256*8);
	--SET @v_SQL5 =SUBSTRING(@v_SQL, 256*24+1,256*8);

	INSERT INTO @SqlTable
	--SELECT @v_SQL2, @v_SQL3, @v_SQL4, @v_SQL5
	SELECT @v_SQL

	RETURN;
END





