/* =============================================================================
프로그램ID	: SCP0078_GET_GSCM_VOC
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
* 2022-08-24   vadabi3      시작일 추가 (CLASSIFY, PRIORITY, DEV)
* 2022-08-25   vadabi3      RECIPT, REVIEW 단계사용 안함 = 조회조건에 적용 필요
* 2022-11-29   vadabi3      Query 개선/정리
* 2023-01-02   vadabi3      당일 조회 이슈 개선
*===================================================================================================  
 EXEC SCP0078_GET_GSCM_VOC
   @p_from_yyyymmdd='20210310'
 , @p_to_yyyymmdd='20220829'
 , @p_voc_name='ESS'
 , @p_csr=''
 , @p_req_user_id=N'김구민'
 , @p_voc_type='QW'
 , @p_voc_step=''
 , @p_voc_status=''
 , @p_use_yn='Y'
 , @p_division_id=''
 , @p_voc_confirm = ''
============================================================================= */

-- CREATE PROCEDURE dbo.SCP0078_GET_GSCM_VOC
CREATE PROCEDURE [dbo].[SCP0078_GET_GSCM_VOC]
 @p_from_yyyymmdd		 NVARCHAR(MAX) ,      
 @p_to_yyyymmdd			 NVARCHAR(MAX) ,   
 @p_voc_name			 NVARCHAR(MAX) , 
 @p_csr					 NVARCHAR(MAX) , 
 @p_req_user_id			 NVARCHAR(MAX) ,
 @p_voc_type			 NVARCHAR(MAX) ,
 @p_voc_step			 NVARCHAR(MAX) ,
 @p_voc_status			 NVARCHAR(MAX) ,
 @p_use_yn			     NVARCHAR(max) = 'Y',
 @p_division_id			 NVARCHAR(MAX) ,
 @p_voc_confirm			 NVARCHAR(MAX)
AS
BEGIN


		  
/********************************************************************************      
* 데이타조회, 임시테이블에 저장      
********************************************************************************/
SET NOCOUNT ON;	
			WITH VOC_LIST AS 
			(
 		            SELECT A.VOC_NO	
 						  ,A.VOC_TYPE	
 						  ,A.VOC_NAME	
 						  ,A.VOC_DETAIL
						  ,'VIEW' AS VOC_DETAIL_BUTTON	
 						  ,CONVERT(CHAR(19), REQUEST_DATE, 20) AS  REQUEST_DATE	
 						--,REQUEST_USER_ID	
						  ,A.REQUEST_USER_ID
 						  ,D.USER_NAME AS REQUEST_USER_NAME
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
						  ,A.SCM_PI_USER_ID
						  ,A.SCM_SOLUTION_USER_ID
 						  ,E.USER_NAME AS SCM_PI_USER_NAME	
 						  ,F.USER_NAME AS SCM_SOLUTION_USER_NAME	
 						  ,CSR_NO	
 						  ,REMARK	
 						  ,A.ATTRIBUTE1	AS DIVISION_ID
 						  ,A.ATTRIBUTE2 AS FILE_LIST	
 						  ,CASE 
						   WHEN LEN(A.ATTRIBUTE2) > 0 THEN 'Y'
						   ELSE null
						   END AS FILE_UPLOAD
 						  ,A.ATTRIBUTE3	AS FILE_LOG
						  ,A.ATTRIBUTE4 AS FILE_MAPPING
 						  ,A.ATTRIBUTE5	
 						  ,A.ATTRIBUTE6	
 						  ,A.ATTRIBUTE7	
 						  ,A.ATTRIBUTE8	
 						  ,A.ATTRIBUTE9	
 						  ,A.ATTRIBUTE10	
 						  ,USE_YN	

						  ,dbo.FN_GET_VOC_DELAY_YN(CLASSIFY_STATUS, CLASSIFY_DATE)	AS DELAY_YN_CLASSIFY
						  ,dbo.FN_GET_VOC_DELAY_YN(RECEIPT_STATUS, RECEIPT_DATE)	AS DELAY_YN_RECEIPT
						  ,dbo.FN_GET_VOC_DELAY_YN(REVIEW_STATUS, REVIEW_DATE)		AS DELAY_YN_REVIEW
						  ,dbo.FN_GET_VOC_DELAY_YN(PRIORITY_STATUS, PRIORITY_DATE)  AS DELAY_YN_PRIORITY
						  ,dbo.FN_GET_VOC_DELAY_YN(DEV_STATUS, DEV_DATE)			AS DELAY_YN_DEV
						  ,dbo.FN_GET_VOC_DELAY_YN(TEST_STATUS, TEST_DATE)			AS DELAY_YN_TEST
						  ,dbo.FN_GET_VOC_DELAY_YN(FINISH_STATUS, FINISH_DATE)		AS DELAY_YN_FINISH

						  ,dbo.FN_GET_VOC_RUN_YN(CLASSIFY_STATUS)	AS RUN_YN_CLASSIFY
						  ,dbo.FN_GET_VOC_RUN_YN(RECEIPT_STATUS)	AS RUN_YN_RECEIPT
						  ,dbo.FN_GET_VOC_RUN_YN(REVIEW_STATUS)		AS RUN_YN_REVIEW
						  ,dbo.FN_GET_VOC_RUN_YN(PRIORITY_STATUS)   AS RUN_YN_PRIORITY
						  ,dbo.FN_GET_VOC_RUN_YN(DEV_STATUS)		AS RUN_YN_DEV
						  ,dbo.FN_GET_VOC_RUN_YN(TEST_STATUS)		AS RUN_YN_TEST
						  ,dbo.FN_GET_VOC_RUN_YN(FINISH_STATUS)		AS RUN_YN_FINISH

						  ,dbo.FN_GET_VOC_SOON_YN(CLASSIFY_STATUS, CLASSIFY_DATE)	AS SOON_YN_CLASSIFY
						  ,dbo.FN_GET_VOC_SOON_YN(RECEIPT_STATUS, RECEIPT_DATE)		AS SOON_YN_RECEIPT
						  ,dbo.FN_GET_VOC_SOON_YN(REVIEW_STATUS, REVIEW_DATE)		AS SOON_YN_REVIEW
						  ,dbo.FN_GET_VOC_SOON_YN(PRIORITY_STATUS, PRIORITY_DATE)	AS SOON_YN_PRIORITY
						  ,dbo.FN_GET_VOC_SOON_YN(DEV_STATUS, DEV_DATE)				AS SOON_YN_DEV
						  ,dbo.FN_GET_VOC_SOON_YN(TEST_STATUS, TEST_DATE)			AS SOON_YN_TEST
						  ,dbo.FN_GET_VOC_SOON_YN(FINISH_STATUS, FINISH_DATE)		AS SOON_YN_FINISH

						  ,DEPT.DEPT_NAME_KO AS REQUEST_DEPT_NAME
						  ,A.BENEFIT_QUANTITATIVE 	
 						  ,A.BENEFIT_QUALITATIVE 	
 						  ,A.CONFIRM_STATUS 			
 						  --,A.CONFIRM_DATE 	
						  ,CONVERT(varchar(10), CONVERT(date, CONVERT(varchar(8), A.CONFIRM_DATE))) AS CONFIRM_DATE
						  ,A.CONFIRM_USER_ID	
						  ,X.USER_NAME AS CONFIRM_USER_NAME		

 						  ,A.CONFIRM_OPINION 		
 						  ,A.MAN_MONTH_PLAN  		
 						  ,A.MAN_MONTH_REAL  
						  ,A.CLASSIFY_START_DATE
						  ,A.PRIORITY_START_DATE
						  ,A.DEV_START_DATE

 					  FROM dbo.SCM_ADM_SYS_VOC A WITH(NOLOCK) 	
 		   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO D WITH(NOLOCK) ON A.REQUEST_USER_ID      = D.USER_ID	
 		   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO E WITH(NOLOCK) ON A.SCM_PI_USER_ID       = E.USER_ID	
 		   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO F WITH(NOLOCK) ON A.SCM_SOLUTION_USER_ID = F.USER_ID	
 		   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO X WITH(NOLOCK) ON A.CONFIRM_USER_ID      = X.USER_ID	
 		   LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO DEPT WITH(NOLOCK) ON D.DEPT_ID = DEPT.DEPT_ID	

		   )
		   SELECT *
		   FROM VOC_LIST A
		   -----------------------------------------------------------------------------------------------------------------------------------------------------------------
		   -- WHERE
		   -----------------------------------------------------------------------------------------------------------------------------------------------------------------
 				  WHERE  1=1 
		
                    AND A.REQUEST_DATE BETWEEN @p_from_yyyymmdd AND DATEADD(day, 1, @p_to_yyyymmdd) 
					AND (ISNULL(@p_voc_name   ,	'') = '' OR VOC_NAME		LIKE '%' + @p_voc_name		+ '%' )
					AND (ISNULL(@p_csr		  , '') = '' OR CSR_NO			LIKE '%' + @p_csr			+ '%' )
					AND (ISNULL(@p_voc_type	  , '') = '' OR VOC_TYPE		LIKE '%' + @p_voc_type		+ '%' )
					AND (ISNULL(@p_use_yn	  , '') = '' OR USE_YN			LIKE '%' + @p_use_yn		+ '%' )
					AND (ISNULL(@p_division_id, '') = '' OR DIVISION_ID		=  @p_division_id )
				    AND (ISNULL(@p_req_user_id, '') = '' OR REQUEST_USER_ID =  @p_req_user_id  OR REQUEST_USER_NAME	LIKE N'%' + @p_req_user_id	+ '%' )
					AND (ISNULL(@p_voc_confirm, '') = '' OR ISNULL(CONFIRM_STATUS,'RU')  = @p_voc_confirm )
				    -----------------------------------------------------------------------------------------------------------------------------------------------------------------
		            AND (ISNULL(@p_voc_status   ,	'') = '' OR 
					   CASE 
						   -----------------------------------------------------------------------------------------------------------------------------------------------------------------
						   -- DELAY
						   -----------------------------------------------------------------------------------------------------------------------------------------------------------------
					        WHEN @p_voc_status = 'DL' AND @p_voc_step = 'CLASSIFY'		THEN DELAY_YN_CLASSIFY
							WHEN @p_voc_status = 'DL' AND @p_voc_step = 'RECEIPT'		THEN DELAY_YN_RECEIPT		
							WHEN @p_voc_status = 'DL' AND @p_voc_step = 'REVIEW'		THEN DELAY_YN_REVIEW	
							WHEN @p_voc_status = 'DL' AND @p_voc_step = 'PRIORITY'		THEN DELAY_YN_PRIORITY	
							WHEN @p_voc_status = 'DL' AND @p_voc_step = 'DEV'			THEN DELAY_YN_DEV			
							WHEN @p_voc_status = 'DL' AND @p_voc_step = 'TEST'			THEN DELAY_YN_TEST		
							WHEN @p_voc_status = 'DL' AND @p_voc_step = 'FINISH'		THEN DELAY_YN_FINISH	
							WHEN @p_voc_status = 'DL' AND isnull(@p_voc_step, '') = ''  THEN 																		   
																						CASE WHEN CHARINDEX('Y', CONCAT(
																														 DELAY_YN_CLASSIFY
																													  --,DELAY_YN_RECEIPT	
																													  --,DELAY_YN_REVIEW	
																														,DELAY_YN_PRIORITY	
																														,DELAY_YN_DEV		
																														,DELAY_YN_TEST		
																														,DELAY_YN_FINISH	
																														)
																								) > 0 
																							THEN 'Y'
																							ELSE ''
																							END
						   -----------------------------------------------------------------------------------------------------------------------------------------------------------------
						   -- RUN
						   -----------------------------------------------------------------------------------------------------------------------------------------------------------------
							WHEN @p_voc_status = 'RN' AND @p_voc_step = 'CLASSIFY'		THEN RUN_YN_CLASSIFY
							WHEN @p_voc_status = 'RN' AND @p_voc_step = 'RECEIPT'		THEN RUN_YN_RECEIPT		
							WHEN @p_voc_status = 'RN' AND @p_voc_step = 'REVIEW'		THEN RUN_YN_REVIEW	
							WHEN @p_voc_status = 'RN' AND @p_voc_step = 'PRIORITY'		THEN RUN_YN_PRIORITY	
							WHEN @p_voc_status = 'RN' AND @p_voc_step = 'DEV'			THEN RUN_YN_DEV			
							WHEN @p_voc_status = 'RN' AND @p_voc_step = 'TEST'			THEN RUN_YN_TEST		
							WHEN @p_voc_status = 'RN' AND @p_voc_step = 'FINISH'		THEN RUN_YN_FINISH	
							WHEN @p_voc_status = 'RN' AND isnull(@p_voc_step, '') = ''	THEN 
																						CASE WHEN CHARINDEX('Y', CONCAT(
																																 RUN_YN_CLASSIFY
																															  --,RUN_YN_RECEIPT
																															  --,RUN_YN_REVIEW
																																,RUN_YN_PRIORITY
																																,RUN_YN_DEV
																																,RUN_YN_TEST
																																,RUN_YN_FINISH
																																)
																								) > 0 
																							THEN 'Y'
																							ELSE ''
																							END
						   -----------------------------------------------------------------------------------------------------------------------------------------------------------------
						   -- SOON
						   -----------------------------------------------------------------------------------------------------------------------------------------------------------------
							WHEN @p_voc_status = 'FS' AND @p_voc_step = 'CLASSIFY'		THEN SOON_YN_CLASSIFY
							WHEN @p_voc_status = 'FS' AND @p_voc_step = 'RECEIPT'		THEN SOON_YN_RECEIPT		
							WHEN @p_voc_status = 'FS' AND @p_voc_step = 'REVIEW'		THEN SOON_YN_REVIEW	
							WHEN @p_voc_status = 'FS' AND @p_voc_step = 'PRIORITY'		THEN SOON_YN_PRIORITY	
							WHEN @p_voc_status = 'FS' AND @p_voc_step = 'DEV'			THEN SOON_YN_DEV			
							WHEN @p_voc_status = 'FS' AND @p_voc_step = 'TEST'			THEN SOON_YN_TEST		
							WHEN @p_voc_status = 'FS' AND @p_voc_step = 'FINISH'		THEN SOON_YN_FINISH	
							WHEN @p_voc_status = 'FS' AND isnull(@p_voc_step, '') = ''	THEN
																						CASE WHEN CHARINDEX('Y', CONCAT(
																														 SOON_YN_CLASSIFY
																													  --,SOON_YN_RECEIPT
																													  --,SOON_YN_REVIEW
																														,SOON_YN_PRIORITY
																														,SOON_YN_DEV
																														,SOON_YN_TEST
																														,SOON_YN_FINISH
																														)
																								) > 0 
																							THEN 'Y'
																							ELSE ''
																							END

						    ELSE  'Y'
							END = 'Y'
							)
					-----------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- HOLD ,DROP, COMPLETE
					-----------------------------------------------------------------------------------------------------------------------------------------------------------------						
		            AND (ISNULL(@p_voc_status   ,	'') = '' OR 
                                CASE 
								WHEN  @p_voc_status IN ('HD', 'DR', 'FH') AND @p_voc_step = 'CLASSIFY'		THEN CLASSIFY_STATUS
								WHEN  @p_voc_status IN ('HD', 'DR', 'FH') AND @p_voc_step = 'RECEIPT'		THEN RECEIPT_STATUS		
								WHEN  @p_voc_status IN ('HD', 'DR', 'FH') AND @p_voc_step = 'REVIEW'		THEN REVIEW_STATUS	
								WHEN  @p_voc_status IN ('HD', 'DR', 'FH') AND @p_voc_step = 'PRIORITY'		THEN PRIORITY_STATUS	
								WHEN  @p_voc_status IN ('HD', 'DR', 'FH') AND @p_voc_step = 'DEV'			THEN DEV_STATUS			
								WHEN  @p_voc_status IN ('HD', 'DR', 'FH') AND @p_voc_step = 'TEST'			THEN TEST_STATUS		
								WHEN  @p_voc_status IN ('HD', 'DR', 'FH') AND @p_voc_step = 'FINISH'		THEN FINISH_STATUS	
								WHEN  @p_voc_status IN ('HD', 'DR', 'FH') AND isnull(@p_voc_step, '') = ''  THEN
																									   CASE WHEN CHARINDEX(@p_voc_status, CONCAT(
																																				 CLASSIFY_STATUS
																																			  --,RECEIPT_STATUS		
																																			  --,REVIEW_STATUS	
																																				,'-'+PRIORITY_STATUS	
																																				,'-'+DEV_STATUS			
																																				,'-'+TEST_STATUS		
																																				,'-'+FINISH_STATUS	
																																				)
																														) > 0 
																													THEN @p_voc_status
																													ELSE ''
																													END
	                         else @p_voc_status
							 end = @p_voc_status
							 )																									   	          
		   		 ORDER BY VOC_NO DESC
	
/********************************************************************************      
* LOG    
********************************************************************************/
		-- LOG 용 변수 설정
		DECLARE @v_program_name NVARCHAR(150) = 'SCP0078_GET_GSCM_VOC';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(max);
		DECLARE @d_event_date   DATETIME;
		SET @v_log_type = 'SEARCH';
		SET @v_log_message = '########## @v_to_mail ##########';

		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END
