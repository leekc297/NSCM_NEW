-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- EXEC [dbo].[DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD] '', ''	   -- 최초 컨트롤 초기화
-- EXEC [dbo].[DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD] 'PHEV', '' -- Type가 선택 되었을 때
-- EXEC [dbo].[DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD] 'PHEV', 'BMW' -- Type 와 제조사가 둘다 선택 되었을 때
/* 2024-12-10  dsiol    [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 */  
-- =============================================
CREATE PROCEDURE [dbo].[DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD]
	@p_EV_TP_CD	  NVARCHAR(50),
	@p_CUST_CO_CD NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	-- 최초 컨트롤 초기화
	IF(LEN(RTRIM(LTRIM(@p_EV_TP_CD))) = 0)
	BEGIN
		BEGIN -- TYPE
			SELECT DISTINCT EV_TP_CD AS CODE
			              , EV_TP_CD AS NAME 
			FROM [dbo].[DM_YEARLY_MKT_DMD_ANALYSIS] 
			ORDER BY EV_TP_CD
		END
	
		BEGIN -- BIZ TYPE
		   SELECT 'CELL' AS CODE, 'CELL' AS NAME
		   UNION
		   SELECT 'MODULE' AS CODE, 'MODULE' AS NAME
		   UNION
		   SELECT 'PACK' AS CODE, 'PACK' AS NAME
		END
	END

	-- Type가 선택 되었을 때
	ELSE IF(LEN(RTRIM(LTRIM(@p_EV_TP_CD))) > 0 AND LEN(RTRIM(LTRIM(@p_CUST_CO_CD))) = 0)
	BEGIN
		BEGIN -- 제조사
			SELECT DISTINCT CUST_CO_CD AS CODE
			              , CUST_CO_CD AS NAME 
			FROM [dbo].[DM_YEARLY_MKT_DMD_ANALYSIS] 
			WHERE EV_TP_CD = @p_EV_TP_CD
			ORDER BY CUST_CO_CD
		END
		
		BEGIN -- 모델명
			SELECT DISTINCT CAR_MDL_ID AS CODE, 
			                CAR_MDL_ID AS NAME 
			FROM [dbo].[DM_YEARLY_MKT_DMD_ANALYSIS]
			WHERE EV_TP_CD = @p_EV_TP_CD AND CUST_CO_CD = (SELECT TOP 1 CUST_CO_CD AS CODE
															FROM [dbo].[DM_YEARLY_MKT_DMD_ANALYSIS] 
															WHERE EV_TP_CD = @p_EV_TP_CD
															ORDER BY CUST_CO_CD)	 --제조사의 제일 위 데이터를 자동으로 선택한다.
			ORDER BY CAR_MDL_ID
		END
	END

	-- Type 와 제조사가 둘다 선택 되었을 때
	ELSE IF(LEN(RTRIM(LTRIM(@p_EV_TP_CD))) > 0 AND LEN(RTRIM(LTRIM(@p_CUST_CO_CD))) > 0)
	BEGIN
		BEGIN -- 모델명
			SELECT DISTINCT CAR_MDL_ID AS CODE, 
			                CAR_MDL_ID AS NAME 
			FROM [dbo].[DM_YEARLY_MKT_DMD_ANALYSIS]
			WHERE EV_TP_CD = @p_EV_TP_CD AND CUST_CO_CD = @p_CUST_CO_CD
			ORDER BY CAR_MDL_ID
		END
	END
END

