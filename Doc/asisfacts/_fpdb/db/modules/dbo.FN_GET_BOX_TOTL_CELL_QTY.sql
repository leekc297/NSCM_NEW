
CREATE FUNCTION [dbo].[FN_GET_BOX_TOTL_CELL_QTY] (@DIVISION_ID NVARCHAR(30),@LINE_ID NVARCHAR(50), @ITEM_ID NVARCHAR(50), @SHIPTO_ID NVARCHAR(50) )
-- ================================================================================================                                                              
-- Program ID          :                                                                                                                                         
-- Program Name        : FN_GET_BOX_TOTL_CELL_QTY                                                                                                              
-- Param               :                                                                                                                                         
-- Batch Period        :                                                                                                                                 
-- Description         :                                                                                                                                         
--                                                                                                                                                               
-- Source System       : SCP                                                                                                                                    
-- Destination System  : FP SDB                                                                                                                                  
-- Source Table        : SCM_SHIPTO_PACK_COND_M                                                                                                                  
-- Destination Table   : 
--                                                                                                                                                               
-- Create Date         : 2018.10.16
-- Update Date		   : 2022.03.30 1.2 kimcd

--
-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 2018-10-18 kimcd 0보다 작은 경우 제거
--						 1.2 2022-03-30 kimcd JV 가상 Division 사용에 따른 로직 수정
-- ================================================================================================  
RETURNS NUMERIC(22,0)
 -- @DIVISION_ID   : 사업부 구분. 필수 매개변수
 -- @LINE_ID       : 조립(활성화라인코드). 자동차, ESS에서만 사용
 -- @ITEM_ID       : Cell Model ID. 필수 매개변수
 -- @CUSTOMER_ID   : SHIIP TO CODE - 선적지가 법인인 경우 COMPANY_ID
 BEGIN
	DECLARE @BOX_TOTL_CELL_QTY NUMERIC(22,0)

	IF @DIVISION_ID NOT IN  ('81','82','40') -- 2022-03-30 kimcd JV 가상 Division 사용에 따른 로직 수정
		BEGIN
			SELECT TOP 1 @DIVISION_ID = PD.ORIGINAL_DIVISION_ID
			FROM   SCM_PSEUDO_DIVISION_M PD (NOLOCK)
			WHERE  PSEUDO_DIVISION_ID = @DIVISION_ID
		END;

	IF @DIVISION_ID IN  ('81','82')
		BEGIN
			SELECT TOP 1 @BOX_TOTL_CELL_QTY = S.BOX_TOTL_CELL_QTY
			FROM   [SCM_SHIPTO_PACK_COND_M] S WITH(NOLOCK)
			WHERE S.DIVISION_ID = @DIVISION_ID
			AND   S.ITEM_ID     = @ITEM_ID
			AND   S.USE_FLAG    = 'Y'
			AND   S.BOX_TOTL_CELL_QTY > 0 -- 2018-10-18 kimcd 0보다 작은 경우 제거
			ORDER BY CASE WHEN S.LINE_ID = @LINE_ID THEN 1 
						  WHEN S.LINE_ID LIKE SUBSTRING(@LINE_ID, 1,5) + '%' THEN 2
						  WHEN S.LINE_ID LIKE SUBSTRING(@LINE_ID, 1,2) + '%' THEN 3
						  ELSE 4 END
					,CASE WHEN S.SHIPTO_ID = @SHIPTO_ID THEN 1 
					      WHEN S.SHIPTO_ID = 'ALL' THEN 2
						  ELSE 3 END
					,S.BOX_TOTL_CELL_QTY DESC -- 2018-10-18 kimcd 수량 정렬 추가
		END;
	ELSE IF @DIVISION_ID = '40'
		BEGIN
			SELECT TOP 1 @BOX_TOTL_CELL_QTY = S.BOX_TOTL_CELL_QTY
			FROM   [SCM_SHIPTO_PACK_COND_M] S WITH(NOLOCK)
			WHERE S.DIVISION_ID = @DIVISION_ID
			AND   S.ITEM_ID     = @ITEM_ID
			AND   S.USE_FLAG    = 'Y'
			AND   S.BOX_TOTL_CELL_QTY > 0 -- 2018-10-18 kimcd 0보다 작은 경우 제거
			ORDER BY CASE WHEN S.SHIPTO_ID = @SHIPTO_ID THEN 1 
					      WHEN S.SHIPTO_ID = 'ALL' THEN 2
						  ELSE 3 END
					,S.PACK_TYPE -- N 신규 형식, O 과거 형식
					,S.PACK_VER DESC -- 0,1
					,S.BOX_TOTL_CELL_QTY DESC -- 2018-10-18 kimcd 수량 정렬 추가
		END;

RETURN @BOX_TOTL_CELL_QTY;

END;


