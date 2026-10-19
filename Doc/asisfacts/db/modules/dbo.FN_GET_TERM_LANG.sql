CREATE FUNCTION [dbo].[FN_GET_TERM_LANG]
      (
       @P_TERM_ID          NVARCHAR(100),
       @P_LANG_CODE        NVARCHAR(150)='EN'
       )
       RETURNS NVARCHAR(250)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_TERM_LANG
  * DESCRIPTION   : 다국어용어 리턴 
  * INPUT         : P_TERM_ID,P_LANG_CODE(KO,EN,CN)
  * OUTPUT        : TERM
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-17   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_TERM_LANG NVARCHAR(100)='';

   
     SELECT @X_TERM_LANG           = ( CASE @P_LANG_CODE WHEN 'KO' THEN C.KO
                                                         WHEN 'EN' THEN C.EN
                                                         WHEN 'CN' THEN C.CH
                                                         ELSE C.EN
                                       END )
		   FROM DBO.TB_FX_TERMINFO C WITH(NOLOCK)
		  WHERE 1=1
		    AND C.TERMID               = @P_TERM_ID
		    AND C.USEYN                = 'Y';
		    
	
   RETURN  @X_TERM_LANG;

END
;
