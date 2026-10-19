CREATE FUNCTION [dbo].[FN_GET_DM_SALES_PLAN_WATERFALL_QTY]  
      (@p_measure             nvarchar(200),  
	   @p_item_class_name     nvarchar(200),  
       @p_qty                 NUMERIC(30,10),
       @p_cell_per_car        NUMERIC(30,10),
	   @p_cell_per_module     NUMERIC(30,10)
       )  
      RETURNS NUMERIC(30,10)
	  -- SELECT DBO.[FN_GET_DM_SALES_PLAN_WATERFALL_QTY]
AS  
/*  
 * Program ID   : [FN_GET_DM_SALES_PLAN_WATERFALL_QTY]    
 * Description  : 
 /*
 ※★ 2018-04-17 추가 MEASURE
MKT_FCST_RP_CAR
MKT_FCST_RP_CELL
RTF_RP_CAR
RTF_RP_CELL
[AP]Pack
[AM]Module
[AC]Cell
CELL_PER_CAR
CELL_PER_MODULE
1.MKT FCST[R+P] Car 
  - ITEM_CLASS_NAME(Model Type)
	  CELL        : MKT FCST 수량 / (Cell/Car)
	  Module/Pack : MKT FCST 수량 / ((Cell/Car) / (Cell/Module))
	  이외의 Type에 대해서는 값을 0 으로 함. 만들지 않으면 됨.
2.MKT FCST[R+P] Cell
  - ITEM_CLASS_NAME(Model Type)	
	  CELL        : MKT FCST 수량
	  Module/Pack : MKT FCST 수량 * (Cell/Module)
	  이외의 Type에 대해서는 값을 0 으로 함. 만들지 않으면 됨.
3.RTF[R+P] Car 
  - ITEM_CLASS_NAME(Model Type)
	  CELL        : MKT FCST 수량 / (Cell/Car)
	  Module/Pack : MKT FCST 수량 / ((Cell/Car) / (Cell/Module))
	  이외의 Type에 대해서는 값을 0 으로 함. 만들지 않으면 됨.
4.RTF[R+P] Cell
  - ITEM_CLASS_NAME(Model Type)	
	  CELL        : MKT FCST 수량
	  Module/Pack : MKT FCST 수량 * (Cell/Module)
	  이외의 Type에 대해서는 값을 0 으로 함. 만들지 않으면 됨.
*/
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.04.17   sj.Hwang         Initial Release   
 
 */  
BEGIN  

DECLARE @x_sales_qty NUMERIC(30,10)= 0;

SET @p_item_class_name = isnull(@p_item_class_name,'');
SET @p_qty = ISNULL( @p_qty, 0);            
SET @p_cell_per_car  = ISNULL( @p_cell_per_car, 0);
SET @p_cell_per_module  = ISNULL( @p_cell_per_module, 0);  
SET @x_sales_qty = @p_qty;

--RETURN @x_sales_qty;
--,CASE WHEN isnull(ITEM.ITEM_CLASS_NAME,'') = '[AC]Cell' THEN ISNULL( A.QTY / isnull(SITE_ITEM.CELL_PER_CAR,1), 0)
--	  WHEN isnull(ITEM.ITEM_CLASS_NAME,'') = '[AM]Module' OR isnull(ITEM.ITEM_CLASS_NAME,'') = '[AP]Pack' THEN ISNULL( ISNULL(A.QTY,1) / isnull(SITE_ITEM.CELL_PER_CAR,1) / isnull(SITE_ITEM.CELL_PER_MODULE,1), 0)
--	  ELSE 0 END 
--	  AS QTY

--,CASE WHEN isnull(ITEM.ITEM_CLASS_NAME,'') = '[AC]Cell' THEN A.QTY
--	  WHEN isnull(ITEM.ITEM_CLASS_NAME,'') = '[AM]Module' OR isnull(ITEM.ITEM_CLASS_NAME,'') = '[AP]Pack' THEN A.QTY / isnull(SITE_ITEM.CELL_PER_MODULE,1)
--	  ELSE 0 END 
--	  AS QTY
    
IF CHARINDEX('MKT_FCST_RP_CAR', @p_measure) > 0 OR CHARINDEX('RTF_RP_CAR', @p_measure) > 0
BEGIN
	IF CHARINDEX('Cell', @p_item_class_name) > 0 --@p_item_class_name = '[AC]Cell'
	BEGIN
		IF @p_cell_per_car = 0
		BEGIN
			SET @x_sales_qty = 0
		END
		ELSE
		BEGIN
			SET @x_sales_qty = @p_qty / @p_cell_per_car
		END		
	END
	ELSE IF CHARINDEX('Module', @p_item_class_name) > 0 OR CHARINDEX('Pack', @p_item_class_name) > 0 --@p_item_class_name = '[AM]Module' OR @p_item_class_name = '[AP]Pack'
	BEGIN
		IF @p_cell_per_car = 0 OR @p_cell_per_module = 0
		BEGIN
			SET @x_sales_qty = 0
		END
		ELSE
		BEGIN
			SET @x_sales_qty = @p_qty/ ( @p_cell_per_car/ @p_cell_per_module )
		END				
	END
	ELSE
	BEGIN
		SET @x_sales_qty = 0
	END
END
ELSE IF CHARINDEX('MKT_FCST_RP_CELL', @p_measure) > 0 OR CHARINDEX('RTF_RP_CELL', @p_measure) > 0
BEGIN
	IF CHARINDEX('Cell', @p_item_class_name) > 0 --@p_item_class_name = '[AC]Cell'
	BEGIN
		IF @p_cell_per_car = 0
		BEGIN
			SET @x_sales_qty = 0
		END
		ELSE
		BEGIN
			SET @x_sales_qty = @p_qty
		END				
	END
	ELSE IF CHARINDEX('Module', @p_item_class_name) > 0 OR CHARINDEX('Pack', @p_item_class_name) > 0 
	BEGIN
		IF @p_cell_per_module = 0
		BEGIN
			SET @x_sales_qty = 0
		END
		ELSE
		BEGIN
			SET @x_sales_qty = @p_qty * @p_cell_per_module
		END
	END
	ELSE
	BEGIN
		SET @x_sales_qty = 0
	END
END    
      
RETURN @x_sales_qty  
  
END  
;
