

/*
 * Program ID   : FN_GET_SCP_PLAN_MIN_DATE
 * Description  : _anl_ table 과 hist Table 분리를 위한 MIN(PLAN_START_YYYYMMDD)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.07.22   lwy			    PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
                                 - scp_anl_production_plan / hist_scp_anl_production_plan 분리작업
 * 2022.07.20   vadabi3			PROGRAMID = 'SCP0079' 추가
 */

CREATE FUNCTION [dbo].[FN_GET_SCP_PLAN_MIN_DATE] ( @P_PROGRAMID NVARCHAR(100), @P_DIVISION_ID NVARCHAR(10), @P_PLAN_TYPE NVARCHAR(100), @P_OPERATION_GROUP NVARCHAR(60), @P_SEQ BIGINT ) 
RETURNS @TBL TABLE
(
 MIN_YYYYMMDD					NVARCHAR(8)
)AS
BEGIN
	-- Shipment Plan FG
	-- 20220720 SCP0079 추가
	IF @P_PROGRAMID = 'SCP0009' OR @P_PROGRAMID = 'SCP0079'
	BEGIN
		INSERT INTO @TBL(MIN_YYYYMMDD)
		SELECT CONVERT(nvarchar(8), MIN(PLAN_START_YYYYMMDD),112)
		 FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)
		WHERE DIVISION_ID = @P_DIVISION_ID
	END
	-- Shipment Plan SEMI
	ELSE IF @P_PROGRAMID = 'SCP0010'
	BEGIN
		INSERT INTO @TBL(MIN_YYYYMMDD)
		SELECT CONVERT(nvarchar(8), MIN(PLAN_START_YYYYMMDD),112)
		 FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
		WHERE DIVISION_ID = @P_DIVISION_ID
	END
	-- Production Plan / Production Plan Line
	ELSE IF (@P_PROGRAMID = 'SCP0011' OR @P_PROGRAMID = 'SCP0013')
	BEGIN
		
		-- lwy : 현업 조회안되는 문제로 임시 +30 설정
		--INSERT INTO @TBL(MIN_YYYYMMDD)
		--SELECT CONVERT(nvarchar(8), MIN(PLAN_START_YYYYMMDD),112)
		-- FROM scp_anl_production_plan WITH(NOLOCK)
		--WHERE DIVISION_ID = @P_DIVISION_ID

		INSERT INTO @TBL(MIN_YYYYMMDD)
		select CONVERT(nvarchar(8), DATEADD(DAY, 30, a.yyyymmdd),112)
		  from (
				SELECT MIN(PLAN_START_YYYYMMDD) as yyyymmdd
				FROM scp_anl_production_plan WITH(NOLOCK)
				WHERE DIVISION_ID = @P_DIVISION_ID
			   ) a



	END

	RETURN;
END
