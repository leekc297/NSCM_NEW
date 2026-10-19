CREATE FUNCTION [dbo].[FN_GET_SSP_PACKER_MODEL]
      (
       @P_DIVISION_ID        NVARCHAR(30),
       @P_FROM_SITE     NVARCHAR(30),
	   @P_ITEM_ID            NVARCHAR(50)           
       )
       RETURNS NVARCHAR(50)
       WITH EXEC AS CALLER       
AS

/*************************************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_SSP_PACKER_MODEL
  * DESCRIPTION   : RETURN1 PACKER ITEM ID 
  * INPUT         : P_DIVISION_ID,@P_FROM_SITE, P_ITEM_ID
  * OUTPUT        : PACKER ITEM_ID
  * PROGRAM HISTORY
  *------------------------------------------------------------------------------------------------
    DATE         IN CHARGE     DESCRIPTION
  *------------------------------------------------------------------------------------------------
  * 2018-09-11   LJH           Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
  *************************************************************************************************/
BEGIN
  
	DECLARE @X_PACKER_MODEL     NVARCHAR(100)='';
	DECLARE @X_OPERATION_GROUP  NVARCHAR(001)='';
	DECLARE @X_PACKER_SUFFIX    NVARCHAR(010)='';

	IF @P_DIVISION_ID = '40'  -- 소형일 경우만 
		BEGIN
			SELECT TOP 1 @X_OPERATION_GROUP  = ISNULL(I.SCP_OPERATION_GROUP,'')
			FROM   DBO.SCM_MST_ITEM_SN I WITH(NOLOCK)
			WHERE  1=1
			AND    I.DIVISION_ID  = @P_DIVISION_ID
			AND    I.ITEM_ID      = @P_ITEM_ID

			IF @X_OPERATION_GROUP = 'P' -- PACK인 경우만
				BEGIN
					SELECT @X_PACKER_SUFFIX  = ISNULL(MAX(ISNULL(PACKER_ITEM_ID_SUFFIX,'')),'@')
					FROM   SCM_MST_SITE WITH(NOLOCK)
					WHERE  DIVISION_ID = '40'
					AND    SITE_TYPE   = 'PLANT'
					AND    OSP_YN      = 'Y'
					AND    SCM_SITE_ID = @P_FROM_SITE

					IF @X_PACKER_SUFFIX <> '@'  -- PACKER_SUFFIX가 있는 경우만
						BEGIN
							SET @X_PACKER_MODEL = SUBSTRING ( @P_ITEM_ID ,1,11) + @X_PACKER_SUFFIX
						END 
					ELSE
						BEGIN
							SET @X_PACKER_MODEL =  @P_ITEM_ID
						END				     
				END 
			ELSE
				BEGIN
					SET @X_PACKER_MODEL =  @P_ITEM_ID
				END	    
		END 
	ELSE
		BEGIN
			SET @X_PACKER_MODEL =  @P_ITEM_ID
		END

   RETURN @X_PACKER_MODEL  ;

END
;
