-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
-- =============================================
CREATE PROCEDURE [dbo].[PR_YYDOK_TEST]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @X_ITEM_ID NVARCHAR(MAX);
DECLARE @X_FLOW_ID NVARCHAR(MAX);

DECLARE @EXP_DIVISION_ID NVARCHAR(100) = ''
DECLARE @EXP_COMPANY_ID NVARCHAR(100) = ''
DECLARE @EXP_SITE_ID NVARCHAR(100) = ''

SELECT @EXP_division_ID = SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_YYDOK_TEST' AND SEGMENT1  = 'EXP_DIVISION_ID' AND ACTIVE_FLAG='Y'
SELECT @EXP_COMPANY_ID = SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_YYDOK_TEST' AND SEGMENT1  = 'EXP_COMPANY_ID' AND ACTIVE_FLAG='Y'
SELECT @EXP_SITE_ID = SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_YYDOK_TEST' AND SEGMENT1  = 'EXP_SITE_ID' AND ACTIVE_FLAG='Y'

       DECLARE FLOW_ID_C CURSOR FOR
          SELECT ITEM_ID,FLOW_ID
            FROM DBO.SCM_ITEM_M_1014 WITH(NOLOCK)
           where DIVISION_ID=@EXP_division_ID
             AND FLOW_ID IS NOT NULL
             AND COMPANY_ID=@EXP_company_ID
             AND SITE_ID =@EXP_site_ID
            ;

      OPEN FLOW_ID_C;
      
      FETCH NEXT FROM FLOW_ID_C
            INTO @X_ITEM_ID,
                 @X_FLOW_ID
                 ;
            
              WHILE @@FETCH_STATUS = 0
              BEGIN
              
             
                   UPDATE DBO.SCM_ITEM_M
                      SET FLOW_ID   =  @X_FLOW_ID
                    WHERE DIVISION_ID=@EXP_division_ID
                      AND COMPANY_ID=@EXP_COMPANY_ID 
                      AND SITE_ID =@EXP_SITE_ID
                      AND ITEM_ID =@X_ITEM_ID
                      ;
                      
              FETCH NEXT FROM FLOW_ID_C
              INTO @X_ITEM_ID,
                   @X_FLOW_ID
                   ;

              END              
                               


      CLOSE FLOW_ID_C;
      DEALLOCATE FLOW_ID_C;
END
