
CREATE FUNCTION [dbo].[FN_GET_FOIL]
-- ================================================================================================
-- Program ID          : 
-- Program Name        : FN_GET_FOIL
-- Param               :     FACTORY_ID
--			      	         ITEM_ID
--			                 PROD_VERSION_TYPE  -- WIDE, GENERAL, PREWET
--                           RETURN_TYPE 'FOIL_CODE', 'FOIL'  -- 반환되는 값을 구분
-- Batch Period        : 
-- Description         : 전극 화면에서 Foil 정보 조회용. 수요 유형에 맞는 생산 버전이 없는 경우 사용됨
--
-- Source System       : FP
-- Destination System  : FP
-- Source Table        : SCM_ITEM_FOIL_M, FP_PROD_VERSION_M
-- Destination Table   : 
--
-- Create(Update) Date : 2019.12.05
-- Author              : kimcd
-- Version             : 1.0 동 품목별 최종 FOIL 반환
-- ================================================================================================
(
    @P_FACTORY_ID        NVARCHAR(30) = '-'
   ,@P_ITEM_ID           NVARCHAR(50) = '-'
   ,@P_PROD_VERSION_TYPE NVARCHAR(50) = '-'
   ,@P_RETURN_TYPE       NVARCHAR(50) = '-'
)
RETURNS NVARCHAR(150)
AS

BEGIN
    DECLARE @FACTORY_ID        NVARCHAR(30)
    DECLARE @ITEM_ID           NVARCHAR(50)
    DECLARE @PROD_VERSION_TYPE NVARCHAR(50)
    DECLARE @RETURN_TYPE       NVARCHAR(50)
	DECLARE @FOIL_CODE         NVARCHAR(150)
	DECLARE @FOIL              NVARCHAR(150)
	DECLARE @RETURN_VALUE      NVARCHAR(150)
    
    IF @P_FACTORY_ID = '-' OR @P_FACTORY_ID = ''
    	SELECT @FACTORY_ID = NULL
    ELSE 
    	SELECT @FACTORY_ID = @P_FACTORY_ID
    
    IF @P_ITEM_ID = '-' OR @P_ITEM_ID = ''
    	SELECT @ITEM_ID = NULL
    ELSE 
    	SELECT @ITEM_ID = @P_ITEM_ID

    IF @P_PROD_VERSION_TYPE = '-' OR @P_PROD_VERSION_TYPE = ''
    	SELECT @PROD_VERSION_TYPE = NULL
    ELSE 
    	SELECT @PROD_VERSION_TYPE = @P_PROD_VERSION_TYPE

    IF @P_RETURN_TYPE = '-' OR @P_RETURN_TYPE = ''
    	SELECT @RETURN_TYPE = NULL
    ELSE 
    	SELECT @RETURN_TYPE = @P_RETURN_TYPE

	SELECT TOP 1 @FOIL_CODE = A.FOIL_CODE, @FOIL = A.FOIL
	FROM   (	SELECT 	A.FOIL_ID AS FOIL_CODE, B.ITEM_NAME AS FOIL
						,ROW_NUMBER() OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE
											ORDER BY V.APPLY_DATE DESC )	 AS NUM
				FROM  	SCM_ITEM_FOIL_M        A WITH(NOLOCK)
						,FP_PROD_VERSION_M      V WITH(NOLOCK)
						,SCM_ITEM_M             B WITH(NOLOCK)
				WHERE 1=1
				AND   A.FACTORY_ID    = V.FACTORY_ID
				AND   A.MODEL_ID      = V.MODEL_ID
				AND   A.ITEM_ID       = V.ITEM_ID
				AND   A.PROD_VERSION  = V.PROD_VERSION
				AND   A.PROD_SEQ      = V.PROD_SEQ
				AND   A.COMPANY_ID    = B.COMPANY_ID
				AND   A.DIVISION_ID   = B.DIVISION_ID
				AND   A.SITE_ID       = B.SITE_ID
				AND   A.FOIL_ID       = B.ITEM_ID
				AND   A.FACTORY_ID    = @FACTORY_ID
				AND   A.ITEM_ID       = @ITEM_ID
				AND   A.PROD_VERSION_TYPE = @PROD_VERSION_TYPE
			) A
	WHERE  NUM = 1;

	IF @RETURN_TYPE = 'FOIL_CODE'
		SET @RETURN_VALUE = @FOIL_CODE
	ELSE
		SET @RETURN_VALUE = @FOIL

	RETURN @RETURN_VALUE;

END
