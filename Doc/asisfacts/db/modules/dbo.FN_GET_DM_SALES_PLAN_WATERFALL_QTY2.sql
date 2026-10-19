---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[FN_GET_DM_SALES_PLAN_WATERFALL_QTY2]  
      (@p_measure             nvarchar(200),  
	   @p_item_class_name     nvarchar(200),  
       @p_qty                 NUMERIC(30,10),
       @p_cell_per_car        NUMERIC(30,10),
	   @p_cell_per_module     NUMERIC(30,10)
	   ,@p_cell_yn				NVARCHAR(1)
	   ,@p_cell_pack_count     NUMERIC(30,10)
	   ,@p_division_id					nvarchar(30)  -- 20190507 KHSONG [CSR ID:3985608] Biz Type이 없는건은 수량만 zero로 변환요청
	   ,@p_forecast_info_biz_type		nvarchar(200)  -- 20190507 KHSONG [CSR ID:3985608] Biz Type이 없는건은 수량만 zero로 변환요청
       )  
      RETURNS NUMERIC(30,10)
	  -- SELECT DBO.[FN_GET_DM_SALES_PLAN_WATERFALL_QTY2] ('KRW', '', 10, 0, 0, 'Y', 2)
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
 * 2018.11.14   JYE				Cell Qty 환산 추가         
 * 20190507 KHSONG [CSR ID:3985608] Biz Type이 없는건은 수량만 zero로 변환요청
 * 20191115 KHSONG MEASURE 2개 추가
 * 2021/03/15     P.C.I		[C20210304-000196] 소형 부자재 및 전극 매출 수량 표기(biz_type is null 제외)
   2022.04.25	HWI1993		GM JV 작업
 * 2022.11.16	kdw2819		[C20221107-000343]BP Waterfall 오류 수정 요청의 건
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
    
IF CHARINDEX('MKT_FCST_RP_CAR', @p_measure) > 0 OR CHARINDEX('RTF_RP_CAR', @p_measure) > 0 OR CHARINDEX('RTF_SYS_RP_CAR', @p_measure) > 0
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
ELSE IF CHARINDEX('MKT_FCST_RP_CELL', @p_measure) > 0 OR CHARINDEX('RTF_RP_CELL', @p_measure) > 0 OR CHARINDEX('RTF_SYS_RP_CELL', @p_measure) > 0
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

      
-- 20181114 추가
IF ((@p_measure IN ('MKT_FCST','MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL',
						'RTF','RTF_RP_CAR','RTF_RP_CELL'
						,'CUST_FCST'
						,'RTF_SCP'
						,'RTF_SYS_RP','RTF_SYS_RP_CAR','RTF_SYS_RP_CELL'		-- 20191115 KHSONG MEASURE 2개 추가
						,'Business_Plan'))										-- [C20221107-000343]BP Waterfall 오류 수정 요청의 건
	AND (@p_cell_yn = 'Y'))
BEGIN
	SET @x_sales_qty = @x_sales_qty * @p_cell_pack_count
END
-- 20181114 추가

--[C20210304-000196] 소형 부자재 및 전극 매출 수량 표기(biz_type is null 제외)
-- 20190507 KHSONG [CSR ID:3985608] Biz Type이 없는건은 수량만 zero로 변환요청 (START)
/*
if			@p_division_id = '40' 
		and @p_forecast_info_biz_type is null 
		and @p_measure NOT IN ('SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
	BEGIN
		SET @x_sales_qty = 0
	END*/
-- 20190507 KHSONG [CSR ID:3985608] Biz Type이 없는건은 수량만 zero로 변환요청 (END)


RETURN @x_sales_qty  
  
END  
;


