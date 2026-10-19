/* =============================================================================
프로그램ID	: SCP0078_GET_GSCM_VOC_DATA
업  무  명	: 시스템관리 - 프로그램관리 목록
프로그램명	: GSCM system VOC
최초작성일	: 2022.02.09
최종작성일	: 2022.02.09
개  발  자	: vadabi3
입  력  값	: 
출  력  값	: 
*===================================================================================================      
*   Date       In Charge	Description      
*===================================================================================================      
* 2022.02.09   vadabi3		Create   
* 2022,05,23   VADABI3      종결, 기대효과, 공수 항목 추가
============================================================================= */

 --CREATE PROCEDURE dbo.SCP0078_GET_GSCM_VOC_DATA
CREATE PROCEDURE [dbo].[SCP0078_GET_GSCM_VOC_DATA]
   
 @p_voc_no			 NVARCHAR(MAX) 
 	
AS
BEGIN


		  
/********************************************************************************      
* 데이타조회, 임시테이블에 저장      
********************************************************************************/
SET NOCOUNT ON;	
DECLARE @mEXEC NVARCHAR(MAX);

			SELECT VOC_NO
				  ,VOC_TYPE
				  ,VOC_NAME
				  ,VOC_DETAIL
				  ,CONVERT(CHAR(19), REQUEST_DATE, 20) AS  REQUEST_DATE
				  --,REQUEST_USER_ID
				  ,D.USER_NAME AS REQUEST_USER_ID
				  ,CLASSIFY_STATUS
				  ,CLASSIFY_DATE
				  ,CLASSIFY_USER_ID
				  ,RECEIPT_STATUS
				  ,RECEIPT_DATE
				  ,RECEIPT_USER_ID
				  ,REVIEW_STATUS
				  ,REVIEW_DATE
				  ,REVIEW_USER_ID
				  ,PRIORITY_STATUS
				  ,PRIORITY_DATE
				  ,PRIORITY_USER_ID
				  ,DEV_STATUS
				  ,DEV_DATE
				  ,DEV_USER_ID
				  ,TEST_STATUS
				  ,TEST_DATE
				  ,TEST_USER_ID
				  ,FINISH_STATUS
				  ,FINISH_DATE
				  ,E.USER_NAME AS SCM_PI_USER_ID
				  ,F.USER_NAME AS SCM_SOLUTION_USER_ID
				  ,CSR_NO
				  ,REMARK
				  ,A.ATTRIBUTE1 AS DIVISION_ID
				  ,A.ATTRIBUTE2 AS FILE_UPLOAD
				  ,A.ATTRIBUTE3 AS FILE_LOG
				  ,A.ATTRIBUTE4 AS FILE_MAPPING
				  ,A.ATTRIBUTE5
				  ,A.ATTRIBUTE6
				  ,A.ATTRIBUTE7
				  ,A.ATTRIBUTE8
				  ,A.ATTRIBUTE9
				  ,A.ATTRIBUTE10
				  ,USE_YN
				  ,A.BENEFIT_QUANTITATIVE 	
 				  ,A.BENEFIT_QUALITATIVE 	
 				  ,A.CONFIRM_STATUS 			
 				  ,A.CONFIRM_DATE 			
				  ,A.CONFIRM_USER_ID			
 				  ,A.CONFIRM_OPINION 		
 				  ,A.MAN_MONTH_PLAN  		
 				  ,A.MAN_MONTH_REAL  		
			  FROM dbo.SCM_ADM_SYS_VOC A WITH(NOLOCK) 
   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO D WITH(NOLOCK) ON A.REQUEST_USER_ID = D.USER_ID
   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO E WITH(NOLOCK) ON A.SCM_PI_USER_ID = E.USER_ID
   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO F WITH(NOLOCK) ON A.SCM_SOLUTION_USER_ID = F.USER_ID
			 WHERE VOC_NO   =  @p_voc_no
END

