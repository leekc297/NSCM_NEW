CREATE FUNCTION [dbo].[FN_GET_MSG_LANG]
      (
       @P_MSG_ID           NVARCHAR(10),
       @P_LANG_CODE        NVARCHAR(150)='EN',
       @P_ARGUMENT0        NVARCHAR(1000)='',
       @P_ARGUMENT1        NVARCHAR(1000)='',
       @P_ARGUMENT2        NVARCHAR(1000)='',
       @P_ARGUMENT3        NVARCHAR(1000)='',
       @P_ARGUMENT4        NVARCHAR(1000)=''                            
       )
       RETURNS NVARCHAR(MAX)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_MSG_LANG
  * DESCRIPTION   : 다국어 MESSAGE 리턴 
  * INPUT         : P_MSG_ID,P_LANG_CODE(KO,EN,CN),문자열 대치문자열0..4
  * OUTPUT        : MESSAGE CONTENT
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-17   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_MSG_LANG NVARCHAR(100)='';

   
     SELECT @X_MSG_LANG           = ( CASE @P_LANG_CODE WHEN 'KO' THEN C.KO
                                                        WHEN 'EN' THEN C.EN
                                                        WHEN 'CN' THEN C.CH
                                                        ELSE C.EN
                                       END )
		   FROM DBO.TB_FX_MESSAGEINFO C WITH(NOLOCK)
		  WHERE 1=1
		    AND C.MESSAGEID            = @P_MSG_ID
		    AND C.USEYN                = 'Y';
		    
	 SET @X_MSG_LANG = REPLACE(@X_MSG_LANG,'{0}',@P_ARGUMENT0);
	 SET @X_MSG_LANG = REPLACE(@X_MSG_LANG,'{1}',@P_ARGUMENT1);
	 SET @X_MSG_LANG = REPLACE(@X_MSG_LANG,'{2}',@P_ARGUMENT2);
	 SET @X_MSG_LANG = REPLACE(@X_MSG_LANG,'{3}',@P_ARGUMENT3);
	 SET @X_MSG_LANG = REPLACE(@X_MSG_LANG,'{4}',@P_ARGUMENT4);	
	
   RETURN  @X_MSG_LANG;

END
;
