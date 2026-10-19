

CREATE FUNCTION [dbo].[FN_XLS_VALUE]
      ( @CATEGORY				NVARCHAR(30) , 
		@DIVISION_ID			NVARCHAR(30) , 
		@PLAN_START_YYYYMMDD	NVARCHAR(10), 
		@PLAN_ID					NVARCHAR(30),
		@PLAN_TYPE				NVARCHAR(10) , 
		@SEQ					BIGINT		 = 1 ,
		@OPERATION_GROUP		NVARCHAR(10) ,
		@CELL_ITEM_ID				NVARCHAR(50),  
		@ITEM_ID				NVARCHAR(50)  
	  )
      RETURNS NVARCHAR(100)
AS
/*
 * Program ID   : [FN_XLS_VALUE]
 * Description  :  ANL 테이블에서 값을 조회함
 * 사용례		    
  SELECT DBO.[FN_XLS_VALUE]( 'CELL_BOH', '81','20230625', '1293::PR::6',  'PR', 6, 'A', 'ACLN1010U-A1-000', 'AALN1010U-A1-000')  ;
 * Program History
 *===================================================================================================
 *   Date			In Charge			Description
 *===================================================================================================
 * 2023.06.27   luckydohan         Initial Release 
 */
BEGIN
  
  DECLARE @RES           NVARCHAR(100) ;

  IF @CATEGORY = 'CELL_BOH'
  BEGIN
		SELECT @RES = SUM(A.QTY)
		FROM TH_ENG_STOCK_PLAN_SN A WITH(NOLOCK)
		WHERE A.MASTER_ID =  @DIVISION_ID + '::WEEKLY'
		AND A.PLAN_ID   =@PLAN_ID
		AND A.ITEM_ID IN ( @CELL_ITEM_ID, @ITEM_ID)  -- CA 물량에 CP 물량을 합산
		AND CONVERT(VARCHAR, A.RECEIVING_DTTM, 112) =@PLAN_START_YYYYMMDD
  END

  RETURN @RES;

END
;
