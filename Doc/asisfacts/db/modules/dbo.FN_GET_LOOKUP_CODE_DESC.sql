CREATE FUNCTION [dbo].[FN_GET_LOOKUP_CODE_DESC]
      (
       @P_LOOKUP_TYPE      NVARCHAR(100),
       @P_LOOKUP_CODE      NVARCHAR(100)
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_LOOKUP_CODE_DESC
  * DESCRIPTION   : 룩업코드명 리턴 
  * INPUT         : LOOKUP_TYPE_CODE,SEGMENT1,SEGMENT2,SEGMENT3,LOOKUP_CODE
  * OUTPUT        : LOOKUP코드명
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-17   YYDOK        INITIAL
  * 2018-02-12   YYDOK        UI LOOKUP 관리테이블 변경(LOOKUP CODE칼럼없어짐, 
  *                           SCM_ADM_LOOKUP_VALUES-> SCM_ADM_LOOKUP_MASTER_DETAIL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_LOOKUP_CODE_DESC NVARCHAR(100)='';

/*   
     SELECT @X_LOOKUP_CODE_DESC = C.DESCRIPTION
		   FROM DBO.SCM_ADM_LOOKUP_VALUES C WITH(NOLOCK)
		  WHERE 1=1
		    AND C.LOOKUP_TYPE          = @P_LOOKUP_TYPE
		    AND ISNULL(C.SEGMENT1,'') = ISNULL(@P_SEGMENT1,'')
		    AND ISNULL(C.SEGMENT2,'') = ISNULL(@P_SEGMENT2,'')
		    AND ISNULL(C.SEGMENT3,'') = ISNULL(@P_SEGMENT3,'')
		    AND ISNULL(DIVISION_ID,'0')= ( SELECT TOP 1 
		                                          CASE LOOKUP_GROUP WHEN 'G' THEN '0'
		                                                            WHEN 'D' THEN @P_DIVISION_ID
		                                                            ELSE @P_DIVISION_ID
		                                          END 
		                                     FROM DBO.SCM_ADM_LOOKUP_TYPE T WITH(NOLOCK)
		                                    WHERE LOOKUP_TYPE = @P_LOOKUP_TYPE )
		                                     
		    AND C.LOOKUP_CODE          = @P_LOOKUP_CODE;
*/

     SELECT TOP 1 @X_LOOKUP_CODE_DESC = C.SEGMENT2
		   FROM DBO.SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
		  WHERE 1=1
		    AND C.LOOKUP_TYPE         = @P_LOOKUP_TYPE
		    AND ISNULL(C.SEGMENT1,'') = ISNULL(@P_LOOKUP_CODE,'');		    
	
   RETURN  @X_LOOKUP_CODE_DESC;

END
;
