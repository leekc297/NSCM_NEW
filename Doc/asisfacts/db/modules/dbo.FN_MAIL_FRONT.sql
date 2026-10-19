CREATE FUNCTION [dbo].[FN_MAIL_FRONT]()
      RETURNS NVARCHAR(300)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_MAIL_FRONT
  * DESCRIPTION   : 메일 본문의 첫번째 줄에 들어갈 문자 설정값 
  *
  * INPUT         : N/A
  * OUTPUT        : NVARCHAR
  * USAGE         : SELECT FN_MAIL_FRONT
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-02-21   YGKIM        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @v_contents NVARCHAR(300);

   SET @v_contents = '<font style="font-family:Gulim,Tahoma; font-size:9pt;">' +'<br><br>' ;
	
  RETURN  @v_contents;

END
;
