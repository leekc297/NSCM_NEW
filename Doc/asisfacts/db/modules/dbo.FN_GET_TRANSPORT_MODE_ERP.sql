CREATE FUNCTION [dbo].[FN_GET_TRANSPORT_MODE_ERP]
      (
       @P_LOOKUP_CODE      NVARCHAR(100)
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_TRANSPORT_MODE_ERP
  * DESCRIPTION   : TRANSPORT MODE 룩업코드명 리턴 
  * INPUT         : ERP LOOKUP CODE
  * OUTPUT        : SCM LOOKUP CODE
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-06-11   KJJ        INITIAL
  * 2018-06-18   KJJ        기본값 기존 '-' 에서 'TRK' 로 변경
  ****************************************************************************/
BEGIN
  
   DECLARE @X_LOOKUP_CODE_DESC NVARCHAR(100)= NULL;

     IF (@P_LOOKUP_CODE IS NULL OR @P_LOOKUP_CODE = '')
		SET @X_LOOKUP_CODE_DESC = 'TRK' --2018-06-18
	 ELSE
		BEGIN
			SELECT @X_LOOKUP_CODE_DESC = C.SEGMENT2
			FROM DBO.SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
			WHERE 1=1
			AND C.LOOKUP_TYPE    = 'TRANSPORT_MODE_ERP'
			AND C.SEGMENT1		 = @P_LOOKUP_CODE
			AND C.VALID_YN		 = 'Y';	
				    
			SET @X_LOOKUP_CODE_DESC = ISNULL(@X_LOOKUP_CODE_DESC,'TRK') ;
		 END

	 RETURN  @X_LOOKUP_CODE_DESC;

END
;
