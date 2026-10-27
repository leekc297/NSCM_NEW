CREATE FUNCTION [dbo].[FN_GET_TRAY_QTY]
-- ================================================================================================
-- Program ID          : 
-- Program Name        : FN_GET_TRAY_QTY
-- Param               : 	CELL_QTY
--                          LOAD_RATE
--                          TRAY_CNT
--                          FLAG
-- Batch Period        : 
-- Description         : CELL 수량을 적재율/TRAY 적재수 기준으로 TRAY 수량 산출
--
-- Source System       : FP
-- Destination System  : FP
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2020.04.24
-- Author              : CHOI YOUNG SUN
-- Version             : 1.0 CELL 수량을 적재율/TRAY 적재수 기준으로 TRAY 수량 산출
-- ================================================================================================
(
    @P_CELL_QTY      NUMERIC(20,10) = '0'
   ,@P_LOAD_RATE     NUMERIC(20,10) = '1'
   ,@P_TRAY_CNT		 NUMERIC(20,10) = '1'
   ,@P_FLAG			 NVARCHAR(10)	= '-'
)
RETURNS NUMERIC(20,10)
AS

BEGIN
    DECLARE @CELL_QTY       NUMERIC(20,10)
    DECLARE @LOAD_RATE      NUMERIC(20,10)
    DECLARE @TRAY_CNT		NUMERIC(20,10)
    DECLARE @FLAG			NVARCHAR(10)
	DECLARE @TRAY_QTY       NUMERIC(20,10)
	DECLARE @ADD_QTY		NUMERIC(20,10)
    DECLARE @NUM_TYPE		INTEGER
	
	SET @CELL_QTY	= @P_CELL_QTY
	SET @LOAD_RATE	= @P_LOAD_RATE
	SET @TRAY_CNT	= @P_TRAY_CNT
	SET @FLAG		= @P_FLAG

	-- CELL 수량이 -들어온 경우 
	IF @CELL_QTY < 0
		SET @NUM_TYPE = -1
	ELSE 
		SET @NUM_TYPE = 1

	-- 나머지가 있는 경우 더해준다.
	SET @ADD_QTY = 0
	IF ABS(@CELL_QTY * @LOAD_RATE % @TRAY_CNT) > 0
		SET @ADD_QTY = 1

	IF ABS(@CELL_QTY * @LOAD_RATE) < @TRAY_CNT AND ABS(@CELL_QTY * @LOAD_RATE) > 0
		SET @TRAY_QTY = 1
	ELSE 
		--SET @TRAY_QTY = CEILING(ABS(@CELL_QTY * @LOAD_RATE / @TRAY_CNT))
		SET @TRAY_QTY = FLOOR(ABS(@CELL_QTY * @LOAD_RATE / @TRAY_CNT)) + @ADD_QTY
	
	RETURN @TRAY_QTY * @NUM_TYPE

END
