





/*
 * Program ID   : SCP0093_GET_DIO_TREND_DATA
 * Description  : SCP0093 DIO TREND Report 화면의 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/11/16   vadabi3/hrkim	최초생성
 ----------------------------------------------------------------------------------------------------

 */
CREATE PROCEDURE [dbo].[SCP0093_GET_DIO_TREND_DATA]
  @p_division_id            NVARCHAR(30)	-- division
, @p_plan_start_yyyymmdd	NVARCHAR(8)		-- Plan Date
, @p_item_id				NVARCHAR(150)	-- 모델 
, @p_from_yyyymm			NVARCHAR(6)		-- Monthly bucket 조회 기간
, @p_to_yyyymm		        NVARCHAR(6)		-- Monthly bucket 조회 기간
, @P_AGGR_DV				NVARCHAR(10)	-- 집계구분 [MD : 모델(Item), CG: 셀그룹(Level4)]
, @P_CATEGORY				NVARCHAR(50)    -- Category 조건  = [Pack, Cell, Cell Convert]
, @P_UNIT_QTY				NUMERIC(20,10)  -- 수량 단위
, @P_UNIT_AMOUNT			NUMERIC(20,10)  -- 금액 단위
, @p_cell_group				NVARCHAR(30)    -- 셀그룹(닉네임.Level4) 
, @p_graph_type				NVARCHAR(30)    -- 수량 /금액 선택
, @p_bucket_type		    NVARCHAR(30)    -- MONTHLY (WEEKLY는 프로시저 분리 필요) 
, @p_user_id				NVARCHAR(30)    -- MEASURE 개인별 선택
, @debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	IF @p_bucket_type = 'MONTHLY'
		BEGIN 
			print N'월별'
			EXEC  dbo.SCP0093_GET_DIO_TREND_DATA_MM 
					  @p_division_id 
					, @p_plan_start_yyyymmdd
					, @p_item_id			
					, @p_from_yyyymm		
					, @p_to_yyyymm		    
					, @P_AGGR_DV			
					, @P_CATEGORY			
					, @P_UNIT_QTY			
					, @P_UNIT_AMOUNT		
					, @p_cell_group			
					, @p_graph_type			
					, @p_bucket_type		
					, @p_user_id			
					, @debug_mode		
		END
	ELSE IF @p_bucket_type = 'WEEKLY'
		BEGIN
			print N'주별'
		END
	ELSE
		BEGIN
			print N'지원되지 않는 bucket입니다.'
		END 


END

