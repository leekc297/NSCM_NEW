
/*
 * Program ID   : SCM0001_GET_SCP_PERIOD
 * Description  : PERIOD 기간조회 (공용)
 * Program History
 * ex)
  EXEC SCM0001_GET_SCP_PERIOD @p_from_date='', @p_offset_month='6', @p_timezone='AS055'
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/17   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/31   PJS	           OFFSET 12개월로 강제 수정
 * 2018/05/31   byunghunjung   OFFSET 12개월 -7일로 수정

 ex)
 EXEC SCM0001_GET_SCP_PERIOD @p_from_date='20180417', @p_offset_month='12',@p_timezone='AM073'
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_SCP_PERIOD]
	 @p_from_date    NVARCHAR(30) 
	,@p_offset_month NVARCHAR(2) 
	,@p_timezone     NVARCHAR(200) 
AS

BEGIN
	IF ISNULL(@p_from_date,'')='' 
		SET @p_from_date = convert(varchar(8), [dbo].[FN_MULTY_TIME](@p_timezone),112);
		--SET @p_from_date = convert(varchar(8), getdate(),112);
		
	--IF ISNULL(@p_offset_month,'')='' 
		SET @p_offset_month = '12'

    -- MAX일자는 해당주의 뒷 일요일 구함
	SELECT MIN_BASIS_YYYYMMDD +':'+MAX_BASIS_YYYYMMDD
	FROM (
			SELECT MIN_BASIS_YYYYMMDD
				  ,DATEPART(DW,MIN_BASIS_YYYYMMDD ) AS MIN_PART
				  --,CONVERT(VARCHAR, CONVERT(DATETIME, MAX_BASIS_YYYYMMDD )+ 7-DATEPART(DW,MAX_BASIS_YYYYMMDD )+1,112)  AS MAX_BASIS_YYYYMMDD
				  ,CONVERT(VARCHAR, CONVERT(DATETIME, MAX_BASIS_YYYYMMDD )-DATEPART(DW,MAX_BASIS_YYYYMMDD )+1,112)  AS MAX_BASIS_YYYYMMDD
				  ,DATEPART(DW,MAX_BASIS_YYYYMMDD ) AS MAX_PART
			 FROM (	SELECT MIN(A.BASIS_YYYYMMDD) AS MIN_BASIS_YYYYMMDD , MAX(BASIS_YYYYMMDD) AS MAX_BASIS_YYYYMMDD
					  FROM SCM_SYS_CALENDAR_M A
					 WHERE A.BASIS_YYYYMMDD >= @p_from_date
					   AND A.BASIS_YYYYMMDD <= CONVERT(varchar(8) , DATEADD(MM, convert(int,@p_offset_month), @p_from_date), 112)
				  ) T
		  ) U

END
