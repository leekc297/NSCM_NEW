

/*
 * Program ID   : SCM0001_GET_SCP_MONTH_PERIOD
 * Description  : PERIOD 기간조회 SCM_MST_PLAN 테이블에서 가져옴(공용)
 * Program History

 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/01   ygkim		   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2021/05/27   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - 중장기
 * 

 ex)
 EXEC SCM0001_GET_SCP_MONTH_PERIOD @p_division_id='81', @p_plan_cycle = 'WEEKLY', @p_from_date = '20180604', @p_offset_month='12',@p_timezone='AM073'
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_SCP_MONTH_PERIOD]
	 @p_division_id    NVARCHAR(max) 
	,@p_plan_cycle	   NVARCHAR(max) 
	,@p_from_date    NVARCHAR(30) 
	,@p_offset_month NVARCHAR(2) 	
	,@p_timezone       NVARCHAR(200) 
AS

BEGIN
	
	DECLARE @n_chk INT
	SET @n_chk = 0;

	SELECT @n_chk = count(*)
	FROM SCM_MST_PLAN WITH(NOLOCK)
	WHERE DIVISION_ID = @p_division_id
	  AND PLAN_CYCLE = 'WEEKLY'
	  AND PLAN_NAME = @p_from_date;

	IF @n_chk > 0
		BEGIN
			-- 2021-05-27 : 중장기
			--SELECT PLAN_NAME +':'+HORIZON_END_DATE
			--FROM SCM_MST_PLAN
			--WHERE DIVISION_ID = @p_division_id
			--  AND PLAN_CYCLE = 'WEEKLY'
			--  AND PLAN_NAME = @p_from_date;
			SELECT PLAN_NAME +':'+ CONVERT(VARCHAR(8), DATEADD(D, 363, CONVERT(DATE, PLAN_NAME)), 112)
			  FROM SCM_MST_PLAN
			 WHERE DIVISION_ID = @p_division_id
			   AND PLAN_CYCLE = 'WEEKLY'
			   AND PLAN_NAME = @p_from_date;
		END
	ELSE
		BEGIN
			IF ISNULL(@p_from_date,'')='' 
				SET @p_from_date = convert(varchar(8), [dbo].[FN_MULTY_TIME](@p_timezone),112);
		
			IF ISNULL(@p_offset_month,'')='' 
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
							  FROM SCM_SYS_CALENDAR_M A  WITH(NOLOCK)
							 WHERE A.BASIS_YYYYMMDD >= @p_from_date
							   AND A.BASIS_YYYYMMDD <= CONVERT(varchar(8) , DATEADD(MM, convert(int,@p_offset_month), @p_from_date), 112)
						  ) T
				  ) U
			END
END
