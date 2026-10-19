/*
 * Program ID   : PR_SSP_MAIL_SEND_PR_REQUEST
 * Description  : PR발행 내용 요청자에게 MAIL 발송 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-06-24	KIMYONGHO	   신규추가
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SEND_PR_REQUEST]
	@p_plan_start_yyyymmdd		NVARCHAR(MAX),
	@p_company_id				NVARCHAR(MAX),
	@p_dm_request_no			NVARCHAR(MAX),
	@p_language					NVARCHAR(MAX),
	@p_category_id				NVARCHAR(MAX)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_result		NVARCHAR(MAX);
	DECLARE @v_result2		NVARCHAR(MAX);
	DECLARE @v_result3		NVARCHAR(MAX);
	DECLARE @v_result4		NVARCHAR(MAX);
	DECLARE @v_result5		NVARCHAR(MAX);
	DECLARE @v_to_mail		NVARCHAR(max);
	DECLARE @v_head_cont	NVARCHAR(max);
	DECLARE @v_body_cont	NVARCHAR(max);
	DECLARE @v_body_cont_temp	NVARCHAR(max);
	DECLARE @TABLE_BODY            NVARCHAR(MAX)
	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)

	DECLARE @v_use_type_code        NVARCHAR(10);
	DECLARE @v_segment1             NVARCHAR(100);
	DECLARE @v_segment2             NVARCHAR(100);
	DECLARE @v_segment3             NVARCHAR(100);
	DECLARE @v_segment4             NVARCHAR(100);
	DECLARE @v_segment5             NVARCHAR(100);
	DECLARE @v_segment6             NVARCHAR(100);
	DECLARE @v_segment7             NVARCHAR(100);
	DECLARE @v_segment8             NVARCHAR(100);
	DECLARE @v_segment9             NVARCHAR(100);
	DECLARE @v_segment10            NVARCHAR(100);
	DECLARE @v_segment11            NVARCHAR(100);
	DECLARE @v_segment12            NVARCHAR(100);
	DECLARE @v_segment13            NVARCHAR(100);
	DECLARE @v_segment14            NVARCHAR(100);
	DECLARE @v_segment15            NVARCHAR(100);
	DECLARE @v_segment16            NVARCHAR(100);
	DECLARE @v_segment17            NVARCHAR(100);
	DECLARE @v_segment18            NVARCHAR(100);
	DECLARE @v_segment19            NVARCHAR(100);
	
	DECLARE @v_column1              NVARCHAR(100);
	DECLARE @v_column2              NVARCHAR(100);
	DECLARE @v_column3              NVARCHAR(100);
	DECLARE @v_column4              NVARCHAR(100);
	DECLARE @v_column5              NVARCHAR(100);
	DECLARE @v_column6              NVARCHAR(100);
	DECLARE @v_column7              NVARCHAR(100);
	DECLARE @v_column8              NVARCHAR(100);
	DECLARE @v_column9              NVARCHAR(100);
	DECLARE @v_column10             NVARCHAR(100);
	DECLARE @v_column11             NVARCHAR(100);
	DECLARE @v_column12             NVARCHAR(100);
	DECLARE @v_column13             NVARCHAR(100);
	DECLARE @v_column14             NVARCHAR(100);
	DECLARE @v_column15             NVARCHAR(100);
	DECLARE @v_column16             NVARCHAR(100);
	DECLARE @v_column17             NVARCHAR(100);
	DECLARE @v_column18             NVARCHAR(100);
	DECLARE @v_column19             NVARCHAR(100);

	DECLARE @v_user_id              NVARCHAR(40);
	DECLARE @v_user_name            NVARCHAR(40);
	DECLARE @v_mobile_phone         NVARCHAR(50);
	DECLARE @v_language_code        NVARCHAR(50);
	DECLARE @v_email_addr           NVARCHAR(100);
	DECLARE @v_from_mail            NVARCHAR(100);
	DECLARE @v_from_phone           NVARCHAR(100);
	DECLARE @v_phone_addr           NVARCHAR(100);
	DECLARE @v_mail_title           NVARCHAR(100);
	DECLARE @v_user_cnt             INT;
	DECLARE @v_rank                 NVARCHAR(MAX);
	DECLARE @v_body_contents        NVARCHAR(MAX);
	DECLARE @v_message              NVARCHAR(MAX);
	DECLARE @v_detail_flag          NVARCHAR(1);
	DECLARE @v_sql_long_text        NVARCHAR(MAX);
	DECLARE @v_check				INT;
	DECLARE @v_sql_yn				NVARCHAR(1);
	DECLARE @v_receiver_temp	    NVARCHAR(150);


	

	--계산용 변수
	DECLARE @v_receiver_cnt						INT = 0;	--총 수신자 명
	DECLARE @v_receiver_tmpcnt					INT = 0;
	DECLARE @v_mail_data_cnt					INT = 0;	--메일 Data 총 건수
	DECLARE @v_receiver_loop_cnt				INT = 0;	--수신자 비교 변수
	DECLARE @v_mail_data_loop_cnt				INT = 0;	--메일 Data 비교 변수
	DECLARE @v_datechk							INT = 0;	--조정기간 Data 체크 건수
	DECLARE @v_mail_cnt_chk						INT = 0;	--메일 View에 Data 있는지 체크 건수
	DECLARE @mailSendCnt						INT = 0;
	DECLARE @v_tmp_receiver						NVARCHAR(MAX) = '' --수신자 임시 변수




	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_MAIL_SEND_PR_REQUEST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblMailSendBatch%')
		   DROP TABLE #TblMailSendBatch
 
	CREATE TABLE #TblMailSendBatch (
			 use_type_code		NVARCHAR(10)
			,user_id			NVARCHAR(150) 		  
		   , language_code		NVARCHAR(200)
		   , segment1			NVARCHAR(100)
		   , segment2			NVARCHAR(100)
		   , segment3			NVARCHAR(100)
		   , segment4			NVARCHAR(100)
		   , segment5			NVARCHAR(100)
		   , segment6			NVARCHAR(100)
		   , segment7			NVARCHAR(100)
		   , segment8			NVARCHAR(100)
		   , segment9			NVARCHAR(100)
		   , segment10			NVARCHAR(100)
		   , segment11			NVARCHAR(100)
		   , segment12			NVARCHAR(100)
		   , segment13			NVARCHAR(100)
		   , segment14			NVARCHAR(100)
		   , segment15			NVARCHAR(100)
		   , segment16			NVARCHAR(100)
		   , segment17			NVARCHAR(100)
		   , segment18			NVARCHAR(100)
		   , segment19			NVARCHAR(100)
		   , column1			NVARCHAR(100)
		   , column2			NVARCHAR(100)
		   , column3			NVARCHAR(100)
		   , column4			NVARCHAR(100)
		   , column5			NVARCHAR(100)
		   , column6			NVARCHAR(100)
		   , column7			NVARCHAR(100)
		   , column8			NVARCHAR(100)
		   , column9			NVARCHAR(100)
		   , column10			NVARCHAR(100)
		   , column11			NVARCHAR(100)
		   , column12			NVARCHAR(100)
		   , column13			NVARCHAR(100)
		   , column14			NVARCHAR(100)
		   , column15			NVARCHAR(100)
		   , column16			NVARCHAR(100)
		   , column17			NVARCHAR(100)
		   , column18			NVARCHAR(100)
		   , column19			NVARCHAR(100)
		   , mail_title			NVARCHAR(100)
		   , body_contents		NVARCHAR(max)
		   , sql_long_text   	NVARCHAR(max)
		   , user_cnt			int
		   , rank				NVARCHAR(max)
	);


	SET @v_result = '';
	SET @v_result = @v_result+'	SELECT																																		'+ CHAR(10);
	SET @v_result = @v_result+'	A.DM_REQ_NO		AS SEGMENT1																													'+ CHAR(10);
	SET @v_result = @v_result+'	, ISNULL(C.ERP_PO_STATUS,''-'') AS SEGMENT2																									'+ CHAR(10);
	SET @v_result = @v_result+'	, A.DIVISION_ID AS SEGMENT3																													'+ CHAR(10);
	SET @v_result = @v_result+'	, A.PROJECT_CODE AS SEGMENT4																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ISNULL(DBO.FN_GET_PROJECT_NAME(A.DIVISION_ID,A.PROJECT_CODE),''-'') AS SEGMENT5															'+ CHAR(10);
	SET @v_result = @v_result+'	, A.ITEM_SEQ AS SEGMENT6																													'+ CHAR(10);
	SET @v_result = @v_result+'	, A.ITEM_ID	AS SEGMENT7																														'+ CHAR(10);
	SET @v_result = @v_result+'	, ISNULL(T.ITEM_NAME,''-'') AS SEGMENT8																										'+ CHAR(10);
	SET @v_result = @v_result+'	, A.UOM	AS SEGMENT9																															'+ CHAR(10);
	SET @v_result = @v_result+'	, A.SCM_SITE_ID	SEGMENT10																													'+ CHAR(10);
	SET @v_result = @v_result+'	, CONVERT(VARCHAR(10), CONVERT(DATETIME, A.YYYYMMDD), 23) AS SEGMENT11																		'+ CHAR(10);
	SET @v_result = @v_result+'	, FLOOR(A.PLAN_QTY) SEGMENT12																														'+ CHAR(10);
	SET @v_result = @v_result+'	, DPD.PR_ITEM_DETAIL AS SEGMENT13																											'+ CHAR(10);
	SET @v_result = @v_result+'	, FLOOR(A.INV_ALLO_QTY)	AS SEGMENT14																											'+ CHAR(10);
	SET @v_result = @v_result+'	, FLOOR(E.INV_ALLO_QTY)	AS SEGMENT15																											'+ CHAR(10);
	SET @v_result = @v_result+'	, FLOOR(B.PR_REQ_QTY)	AS SEGMENT16																											'+ CHAR(10);
	SET @v_result = @v_result+'	, B.PR_NO			AS SEGMENT17																											'+ CHAR(10);
	SET @v_result = @v_result+'	, CASE WHEN '''+@p_language+''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + A.ATTRIBUTE1 + '')'' AS  SEGMENT18    		'+ CHAR(10);
	--SET @v_result = @v_result+'	, ISNULL(G.DEPT_NAME_KO,''-'') AS SEGMENT19    																								'+ CHAR(10);


	SET @v_result = @v_result+' , (SELECT ISNULL(DEPT_NAME_KO,''-'')																										   '+ CHAR(10);
	SET @v_result = @v_result+' 	FROM   SCM_MST_SSO_DEPT_INFO  AA WITH(NOLOCK)																						   '+ CHAR(10);
	SET @v_result = @v_result+' 	LEFT OUTER JOIN TB_FX_User BB WITH(NOLOCK)																							   '+ CHAR(10);
	SET @v_result = @v_result+' 	ON AA.DEPT_ID = BB.DEPT_ID																											   '+ CHAR(10);
	SET @v_result = @v_result+' 	WHERE BB.UserID = A.ATTRIBUTE1																									   '+ CHAR(10);
	SET @v_result = @v_result+' 	) AS SEGMENT19																															   '+ CHAR(10);


	SET @v_result = @v_result+'	, ''Request No''	AS COLUMN1																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''PO Status''		AS COLUMN2																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Div''			AS COLUMN3																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Project Code''	AS COLUMN4																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Project Name''	AS COLUMN5																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Seq''			AS COLUMN6																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Model''			AS COLUMN7																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Model Name''	AS COLUMN8																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''UOM''			AS COLUMN9																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''TO Stie''		AS COLUMN10																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Request Date''	AS COLUMN11																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Request Qty''	AS COLUMN12																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Item Detail''	AS COLUMN13																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Allo Qty''		AS COLUMN14																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Net Qty''		AS COLUMN15																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''PR Qty''		AS COLUMN16																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''PR No''			AS COLUMN17																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Requestor''		AS COLUMN18																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Team''			AS COLUMN19																												'+ CHAR(10);

	SET @v_result = @v_result+'	, '''+@p_language+''' AS language_code    																									'+ CHAR(10);
	SET @v_result = @v_result+'	, A.ATTRIBUTE1 AS USER_ID    																								'+ CHAR(10);
	SET @v_result = @v_result+'	FROM SSP_ANL_ESS_REQ A WITH(NOLOCK)																											'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)																										'+ CHAR(10);
	SET @v_result = @v_result+'		ON A.ITEM_ID		= T.ITEM_ID																											'+ CHAR(10);
	SET @v_result = @v_result+'	    AND A.DIVISION_ID	= T.DIVISION_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'	    AND T.COMPANY_ID	= '''+ @p_company_id +'''																							'+ CHAR(10);
	SET @v_result = @v_result+'		AND T.ITEM_TYPE		IN (''Q'',''R'')																												'+ CHAR(10);
	SET @v_result = @v_result+'	   																																			'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN SSP_ANL_ESS_PR B WITH(NOLOCK)																								'+ CHAR(10);
	SET @v_result = @v_result+'		ON A.DM_REQ_NO		= B.DM_REQ_NO																										'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.ITEM_SEQ		= B.PR_ITEM_SEQ																										'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.ITEM_ID		= B.PR_ITEM_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN SSP_ANL_ESS_PO C WITH(NOLOCK)																								'+ CHAR(10);
	SET @v_result = @v_result+'		ON B.PR_NO			= C.PR_NO																											'+ CHAR(10);
	SET @v_result = @v_result+'		AND B.PR_ITEM_ID	= C.PO_ITEM_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN (																															'+ CHAR(10);
	SET @v_result = @v_result+'		SELECT PR_NO, PO_NO, PO_ITEM_SEQ, PO_ITEM_ID, SUM(PO_ITEM_IN_QTY) AS PO_ITEM_IN_QTY														'+ CHAR(10);
	SET @v_result = @v_result+'		FROM SSP_ANL_ESS_PO_IN WITH(NOLOCK) 																									'+ CHAR(10);
	SET @v_result = @v_result+'		GROUP BY PR_NO, PO_NO, PO_ITEM_SEQ, PO_ITEM_ID																							'+ CHAR(10);
	SET @v_result = @v_result+'	) D																																			'+ CHAR(10);
	SET @v_result = @v_result+'		ON C.PO_NO			= D.PO_NO																											'+ CHAR(10);
	SET @v_result = @v_result+'		and c.PR_NO			= D.PR_NO																											'+ CHAR(10);
	SET @v_result = @v_result+'		AND C.PO_ITEM_ID	= D.PO_ITEM_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN SSP_ANL_ESS_REQ_NET E WITH(NOLOCK)																							'+ CHAR(10);
	SET @v_result = @v_result+'		ON E.DM_REQ_NO				= A.DM_REQ_NO																								'+ CHAR(10);
	SET @v_result = @v_result+'		AND E.ITEM_ID				= A.ITEM_ID																									'+ CHAR(10);
	SET @v_result = @v_result+'		AND E.PLAN_START_YYYYMMDD	= '''+@p_plan_start_yyyymmdd+'''																			'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN DM_PLN_PR_DETAIL DPD WITH(NOLOCK)																							'+ CHAR(10);
	SET @v_result = @v_result+'		ON A.DM_REQ_NO		= DPD.REQUEST_NO																									'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.ITEM_ID		= DPD.ITEM_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.SCM_SITE_ID	= DPD.SCM_SITE_ID																									'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.PROJECT_CODE	= DPD.PROJECT_CODE																									'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.YYYYMMDD		= DPD.YYYYMMDD																										'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON A.ATTRIBUTE1 = U.UserID AND U.UseYN = ''Y''    												'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_NAME_KO, OWNER												'+ CHAR(10);	 
	SET @v_result = @v_result+'	 	  	FROM(																						                         				'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		SELECT aa.DIVISION_ID, aa.PROJECT_CODE, aa.SCM_SITE_ID, aa.ITEM_ID,ac.DEPT_NAME_KO, OWNER										'+ CHAR(10);	
	SET @v_result = @v_result+'	 	  				,ROW_NUMBER() over(partition by aa.DIVISION_ID, aa.SCM_SITE_ID, aa.ITEM_ID order by aa.PROJECT_CODE) num				'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		FROM scm_mst_site_item aa WITH(NOLOCK)																				         	'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		LEFT OUTER JOIN SCM_MST_SITE  BB WITH(NOLOCK) 																					'+ CHAR(10);
	SET @v_result = @v_result+'	 	  			ON BB.SCM_SITE_ID = aa.SCM_SITE_ID																							'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		LEFT OUTER JOIN SCM_MST_SSO_USER_INFO  ab WITH(NOLOCK) 																			'+ CHAR(10);
	SET @v_result = @v_result+'	 	  			ON  ab.USER_ID = aa.OWNER																				     				'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  ac WITH(NOLOCK) 																			'+ CHAR(10);
	SET @v_result = @v_result+'	 	  			ON  bb.DEPT_ID = ac.DEPT_ID																				     				'+ CHAR(10);
	SET @v_result = @v_result+'	 	  	) a WHERE num = 1) g on g.DIVISION_ID =  a.DIVISION_ID and g.SCM_SITE_ID = a.SCM_SITE_ID and g.ITEM_ID = a.ITEM_ID	 				'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	WHERE A.DM_REQ_NO = '''+ @P_DM_REQUEST_NO+'''																								'+ CHAR(10);

	
	
	SET @v_result = @v_result+'	UNION ALL 																																	'+ CHAR(10);


	SET @v_result = @v_result+'	SELECT DISTINCT																																'+ CHAR(10);
	SET @v_result = @v_result+'	A.DM_REQ_NO		AS SEGMENT1																													'+ CHAR(10);
	SET @v_result = @v_result+'	, ISNULL(C.ERP_PO_STATUS,''-'') AS SEGMENT2																									'+ CHAR(10);
	SET @v_result = @v_result+'	, A.DIVISION_ID AS SEGMENT3																													'+ CHAR(10);
	SET @v_result = @v_result+'	, A.PROJECT_CODE AS SEGMENT4																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ISNULL(DBO.FN_GET_PROJECT_NAME(A.DIVISION_ID,A.PROJECT_CODE),''-'') AS SEGMENT5															'+ CHAR(10);
	SET @v_result = @v_result+'	, A.ITEM_SEQ AS SEGMENT6																													'+ CHAR(10);
	SET @v_result = @v_result+'	, A.ITEM_ID	AS SEGMENT7																														'+ CHAR(10);
	SET @v_result = @v_result+'	, ISNULL(T.ITEM_NAME,''-'') AS SEGMENT8																										'+ CHAR(10);
	SET @v_result = @v_result+'	, A.UOM	AS SEGMENT9																															'+ CHAR(10);
	SET @v_result = @v_result+'	, A.SCM_SITE_ID	SEGMENT10																													'+ CHAR(10);
	SET @v_result = @v_result+'	, CONVERT(VARCHAR(10), CONVERT(DATETIME, A.YYYYMMDD), 23) AS SEGMENT11																		'+ CHAR(10);
	SET @v_result = @v_result+'	, FLOOR(A.PLAN_QTY) SEGMENT12																												'+ CHAR(10);
	SET @v_result = @v_result+'	, DPD.PR_ITEM_DETAIL AS SEGMENT13																											'+ CHAR(10);
	SET @v_result = @v_result+'	, FLOOR(A.INV_ALLO_QTY)	AS SEGMENT14																										'+ CHAR(10);
	SET @v_result = @v_result+'	, FLOOR(E.INV_ALLO_QTY)	AS SEGMENT15																										'+ CHAR(10);
	SET @v_result = @v_result+'	, FLOOR(B.PR_REQ_QTY)	AS SEGMENT16																										'+ CHAR(10);
	SET @v_result = @v_result+'	, B.PR_NO			AS SEGMENT17																											'+ CHAR(10);
	SET @v_result = @v_result+'	, CASE WHEN '''+@p_language+''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + A.ATTRIBUTE1 + '')'' AS  SEGMENT18    		'+ CHAR(10);
	--SET @v_result = @v_result+'	, ISNULL(G.DEPT_NAME_KO,''-'') AS SEGMENT19    																								'+ CHAR(10);


	SET @v_result = @v_result+' , (SELECT ISNULL(DEPT_NAME_KO,''-'')																								       '+ CHAR(10);
	SET @v_result = @v_result+' 	FROM   SCM_MST_SSO_DEPT_INFO  AA WITH(NOLOCK)																						   '+ CHAR(10);
	SET @v_result = @v_result+' 	LEFT OUTER JOIN TB_FX_User BB WITH(NOLOCK)																							   '+ CHAR(10);
	SET @v_result = @v_result+' 	ON AA.DEPT_ID = BB.DEPT_ID																											   '+ CHAR(10);
	SET @v_result = @v_result+' 	WHERE BB.UserID = A.ATTRIBUTE1																									   '+ CHAR(10);
	SET @v_result = @v_result+' 	) AS SEGMENT19																														   '+ CHAR(10);


	SET @v_result = @v_result+'	, ''Request No''	AS COLUMN1																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''PO Status''		AS COLUMN2																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Div''			AS COLUMN3																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Project Code''	AS COLUMN4																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Project Name''	AS COLUMN5																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Seq''			AS COLUMN6																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Model''			AS COLUMN7																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Model Name''	AS COLUMN8																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''UOM''			AS COLUMN9																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''TO Stie''		AS COLUMN10																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Request Date''	AS COLUMN11																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Request Qty''	AS COLUMN12																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Item Detail''	AS COLUMN13																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Allo Qty''		AS COLUMN14																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Net Qty''		AS COLUMN15																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''PR Qty''		AS COLUMN16																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''PR No''			AS COLUMN17																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Requestor''		AS COLUMN18																												'+ CHAR(10);
	SET @v_result = @v_result+'	, ''Team''			AS COLUMN19																												'+ CHAR(10);

	SET @v_result = @v_result+'	, '''+@p_language+''' AS language_code    																									'+ CHAR(10);
	SET @v_result = @v_result+'	, M.USER_ID AS USER_ID    																											'+ CHAR(10);
	SET @v_result = @v_result+'	FROM SSP_ANL_ESS_REQ A WITH(NOLOCK)																											'+ CHAR(10);
	
	SET @v_result = @v_result+' INNER JOIN SCM_ADM_RECIPIENT_ASSIGN M WITH(NOLOCK) ON  M.CATEGORY_ID    =''76''				'+ CHAR(10);



	SET @v_result = @v_result+'	JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)																										'+ CHAR(10);
	SET @v_result = @v_result+'		ON A.ITEM_ID		= T.ITEM_ID																											'+ CHAR(10);
	SET @v_result = @v_result+'	    AND A.DIVISION_ID	= T.DIVISION_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'	    AND T.COMPANY_ID	= '''+ @p_company_id +'''																							'+ CHAR(10);
	SET @v_result = @v_result+'		AND T.ITEM_TYPE		IN (''Q'',''R'')																									'+ CHAR(10);
	SET @v_result = @v_result+'	   																																			'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN SSP_ANL_ESS_PR B WITH(NOLOCK)																								'+ CHAR(10);
	SET @v_result = @v_result+'		ON A.DM_REQ_NO		= B.DM_REQ_NO																										'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.ITEM_SEQ		= B.PR_ITEM_SEQ																										'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.ITEM_ID		= B.PR_ITEM_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN SSP_ANL_ESS_PO C WITH(NOLOCK)																								'+ CHAR(10);
	SET @v_result = @v_result+'		ON B.PR_NO			= C.PR_NO																											'+ CHAR(10);
	SET @v_result = @v_result+'		AND B.PR_ITEM_ID	= C.PO_ITEM_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN (																															'+ CHAR(10);
	SET @v_result = @v_result+'		SELECT PR_NO, PO_NO, PO_ITEM_SEQ, PO_ITEM_ID, SUM(PO_ITEM_IN_QTY) AS PO_ITEM_IN_QTY														'+ CHAR(10);
	SET @v_result = @v_result+'		FROM SSP_ANL_ESS_PO_IN WITH(NOLOCK) 																									'+ CHAR(10);
	SET @v_result = @v_result+'		GROUP BY PR_NO, PO_NO, PO_ITEM_SEQ, PO_ITEM_ID																							'+ CHAR(10);
	SET @v_result = @v_result+'	) D																																			'+ CHAR(10);
	SET @v_result = @v_result+'		ON C.PO_NO			= D.PO_NO																											'+ CHAR(10);
	SET @v_result = @v_result+'		and c.PR_NO			= D.PR_NO																											'+ CHAR(10);
	SET @v_result = @v_result+'		AND C.PO_ITEM_ID	= D.PO_ITEM_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN SSP_ANL_ESS_REQ_NET E WITH(NOLOCK)																							'+ CHAR(10);
	SET @v_result = @v_result+'		ON E.DM_REQ_NO				= A.DM_REQ_NO																								'+ CHAR(10);
	SET @v_result = @v_result+'		AND E.ITEM_ID				= A.ITEM_ID																									'+ CHAR(10);
	SET @v_result = @v_result+'		AND E.PLAN_START_YYYYMMDD	= '''+@p_plan_start_yyyymmdd+'''																			'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN DM_PLN_PR_DETAIL DPD WITH(NOLOCK)																							'+ CHAR(10);
	SET @v_result = @v_result+'		ON A.DM_REQ_NO		= DPD.REQUEST_NO																									'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.ITEM_ID		= DPD.ITEM_ID																										'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.SCM_SITE_ID	= DPD.SCM_SITE_ID																									'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.PROJECT_CODE	= DPD.PROJECT_CODE																									'+ CHAR(10);
	SET @v_result = @v_result+'		AND A.YYYYMMDD		= DPD.YYYYMMDD																										'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON A.ATTRIBUTE1 = U.UserID AND U.UseYN = ''Y''    												'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_NAME_KO, OWNER												'+ CHAR(10);	 
	SET @v_result = @v_result+'	 	  	FROM(																						                         				'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		SELECT aa.DIVISION_ID, aa.PROJECT_CODE, aa.SCM_SITE_ID, aa.ITEM_ID,ac.DEPT_NAME_KO, OWNER										'+ CHAR(10);	
	SET @v_result = @v_result+'	 	  				,ROW_NUMBER() over(partition by aa.DIVISION_ID, aa.SCM_SITE_ID, aa.ITEM_ID order by aa.PROJECT_CODE) num				'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		FROM scm_mst_site_item aa WITH(NOLOCK)																				         	'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		LEFT OUTER JOIN SCM_MST_SITE  BB WITH(NOLOCK) 																					'+ CHAR(10);
	SET @v_result = @v_result+'	 	  			ON BB.SCM_SITE_ID = aa.SCM_SITE_ID																							'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		LEFT OUTER JOIN SCM_MST_SSO_USER_INFO  ab WITH(NOLOCK) 																			'+ CHAR(10);
	SET @v_result = @v_result+'	 	  			ON  ab.USER_ID = aa.OWNER																				     				'+ CHAR(10);
	SET @v_result = @v_result+'	 	  		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  ac WITH(NOLOCK) 																			'+ CHAR(10);
	SET @v_result = @v_result+'	 	  			ON  bb.DEPT_ID = ac.DEPT_ID																				     				'+ CHAR(10);
	SET @v_result = @v_result+'	 	  	) a WHERE num = 1) g on g.DIVISION_ID =  a.DIVISION_ID and g.SCM_SITE_ID = a.SCM_SITE_ID and g.ITEM_ID = a.ITEM_ID	 				'+ CHAR(10);
	SET @v_result = @v_result+'																																				'+ CHAR(10);
	SET @v_result = @v_result+'	WHERE A.DM_REQ_NO = '''+ @P_DM_REQUEST_NO+'''																								'+ CHAR(10);


	;

	--EXEC (@v_result);

	--return;



	SET @v_result4 = ''
	SET @v_result4 = @v_result4+'  SELECT DISTINCT z.* '+CHAR(10)
	SET @v_result4 = @v_result4+'     ,COUNT(user_id) over ( PARTITION BY  user_id ) user_cnt '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,dense_rank() over(  ORDER BY user_id) rank '+CHAR(10)
	SET @v_result4 = @v_result4+'  FROM ( '+CHAR(10)
	SET @v_result4 = @v_result4+'  SELECT x.use_type_code '+CHAR(10)
	--SET @v_result4 = @v_result4+'      ,case when isnull(x.user_id,'''') != '''' then '+CHAR(10)
	--SET @v_result4 = @v_result4+'                  Y.user_id '+CHAR(10)
	--SET @v_result4 = @v_result4+'              when isnull(y.user_id,'''') != '''' then '+CHAR(10)
	--SET @v_result4 = @v_result4+'                  y.user_id '+CHAR(10)
	--SET @v_result4 = @v_result4+'              else y.user_id '+CHAR(10)
	--SET @v_result4 = @v_result4+'              end user_id '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.user_id '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.language_code '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment1 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment2 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment3 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment4 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment5 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment6 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment7 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment8 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment9 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment10 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment11 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment12 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment13 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment14 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment15 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment16 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment17 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment18 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment19 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column1 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column2 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column3 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column4 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column5 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column6 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column7 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column8 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column9 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column10 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column11 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column12 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column13 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column14 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column15 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column16 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column17 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column18 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column19 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.mail_title + ''_'' + y.segment1 +''_[''+ y.segment4 + '']''   AS mail_title  '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.body_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.sql_long_text '+CHAR(10)
	SET @v_result4 = @v_result4+'  FROM ('+@v_result+') y, '+CHAR(10)
	SET @v_result4 = @v_result4+'      ( SELECT a.use_type_code '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,c.user_id '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,b.language_code '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,b.mail_title '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,d.SEGMENT3       header_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'  			,CASE A.USE_TYPE_CODE WHEN ''MAIL'' THEN replace(b.message_content,char(10),''<br><br>'') '+CHAR(10)
	SET @v_result4 = @v_result4+'  			                      WHEN ''SMS'' THEN b.message_content END body_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,d.SEGMENT3      foot_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,a.SQL_LONG_TEXT '+CHAR(10)
	SET @v_result4 = @v_result4+'          FROM SCM_ADM_RECIPIENT_LIST  a WITH(NOLOCK) '+CHAR(10)
	SET @v_result4 = @v_result4+'              INNER JOIN SCM_ADM_RECIPIENT_MESSAGE b WITH(NOLOCK) ON a.CATEGORY_ID = B.CATEGORY_ID '+CHAR(10)
	SET @v_result4 = @v_result4+'              LEFT OUTER JOIN SCM_ADM_RECIPIENT_ASSIGN  c WITH(NOLOCK) ON B.CATEGORY_ID = C.CATEGORY_ID  '+CHAR(10)
	SET @v_result4 = @v_result4+'              INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  d WITH(NOLOCK) ON D.SEGMENT1 = B.LANGUAGE_CODE AND D.LOOKUP_TYPE = ''MAIL_HEADER_FOOT'' AND D.VALID_YN = ''Y''  '+CHAR(10)
	SET @v_result4 = @v_result4+'              LEFT OUTER JOIN TB_FX_User e WITH(NOLOCK) ON B.LANGUAGE_CODE = E.Language AND C.USER_ID = E.UserID '+CHAR(10)
	SET @v_result4 = @v_result4+'          WHERE a.category_id   = ' +convert(nvarchar,@p_category_id)+CHAR(10)
	SET @v_result4 = @v_result4+'              AND a.VALID_YN = ''Y'' '+CHAR(10)
	SET @v_result4 = @v_result4+'          ) x '+CHAR(10)
	SET @v_result4 = @v_result4+'      WHERE x.language_code = y.language_code   '+CHAR(10)
	SET @v_result4 = @v_result4+'      ) z order by user_id, segment6 '+CHAR(10)

	
	--BEGIN				
		--DECLARE @POS INT =1;
		--DECLARE @LEN INT =LEN(@v_result4);
		--WHILE @POS <= @LEN
		--	BEGIN
		--		PRINT SUBSTRING(@v_result4,@POS,4000);
		--		SET @POS = @POS+4000;
		--	END;
	--END;

	INSERT INTO #TblMailSendBatch
	exec (@v_result4)

	--SELECT * FROM #TblMailSendBatch;

	--return;


	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
	SET @v_check = 0
	SET @v_body_cont = ''
	SET @v_body_cont_temp = ''
	SET @v_receiver_temp = ''

	DECLARE CUR_SEND CURSOR FOR
	SELECT * FROM #TblMailSendBatch
	WHERE rank = 1

	BEGIN TRY
		

		OPEN CUR_SEND;
		FETCH NEXT FROM CUR_SEND INTO @v_use_type_code, @v_user_id, @v_language_code
			                , @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5
							, @v_segment6, @v_segment7, @v_segment8, @v_segment9, @v_segment10
							, @v_segment11, @v_segment12, @v_segment13, @v_segment14, @v_segment15
							, @v_segment16, @v_segment17, @v_segment18, @v_segment19
							, @v_column1, @v_column2, @v_column3, @v_column4, @v_column5
							, @v_column6, @v_column7, @v_column8, @v_column9, @v_column10
							, @v_column11, @v_column12, @v_column13, @v_column14, @v_column15
							, @v_column16, @v_column17, @v_column18, @v_column19
							, @v_mail_title
							, @v_body_contents, @v_sql_long_text, @v_user_cnt, @v_rank;

		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @v_use_type_code = 'MAIL'
					BEGIN
						IF @v_check = 0
							BEGIN
								SET @v_head_cont = ''
								SET @v_head_cont = @v_head_cont+ '<tr>'

								IF ISNULL(@v_column1, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column1 + '</th>'
									END
								IF ISNULL(@v_column2, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column2 + '</th>'
									END
								IF ISNULL(@v_column3, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column3 + '</th>'
									END
								IF ISNULL(@v_column4, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column4 + '</th>'
									END
								IF ISNULL(@v_column5, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column5 + '</th>'
									END
								IF ISNULL(@v_column6, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column6 + '</th>'
									END
								IF ISNULL(@v_column7, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column7 + '</th>'
									END
								IF ISNULL(@v_column8, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column8 + '</th>'
									END
								IF ISNULL(@v_column9, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column9 + '</th>'
									END
								IF ISNULL(@v_column10, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column10 + '</th>'
									END
								IF ISNULL(@v_column11, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column11 + '</th>'
									END
								IF ISNULL(@v_column12, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column12 + '</th>'
									END
								IF ISNULL(@v_column13, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column13 + '</th>'
									END
								IF ISNULL(@v_column14, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column14 + '</th>'
									END
								IF ISNULL(@v_column15, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column15 + '</th>'
									END
								IF ISNULL(@v_column16, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column16 + '</th>'
									END
								IF ISNULL(@v_column17, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column17 + '</th>'
									END
								IF ISNULL(@v_column18, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column18 + '</th>'
									END
								IF ISNULL(@v_column19, '') != ''
									BEGIN
										SET @v_head_cont = @v_head_cont+ '<th>' + @v_column19 + '</th>'
									END
								SET @v_head_cont = @v_head_cont+ '</tr>'
								SET @v_check = @v_check + 1
							END
								
						SET @v_body_cont = @v_body_cont+ '<tr>'

						IF ISNULL(@v_column1, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment1,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column2, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment2,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column3, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment3,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column4, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment4,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column5, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment5,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column6, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment6,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column7, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment7,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column8, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment8,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column9, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment9,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column10, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment10,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column11, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment11,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column12, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment12,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column13, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment13,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column14, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment14,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column15, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment15,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column16, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment16,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column17, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment17,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column18, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment18,''), CHAR(10),' ') + '</td>'
							END
						IF ISNULL(@v_column19, '') != ''
							BEGIN
								SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment19,''), CHAR(10),' ') + '</td>'
							END


						SET @v_body_cont = @v_body_cont+ '</tr>'
								
					--END
				END 

				FETCH NEXT FROM CUR_SEND INTO @v_use_type_code, @v_user_id, @v_language_code
								, @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5
								, @v_segment6, @v_segment7, @v_segment8, @v_segment9, @v_segment10
								, @v_segment11, @v_segment12, @v_segment13, @v_segment14, @v_segment15
								, @v_segment16, @v_segment17, @v_segment18, @v_segment19
								, @v_column1, @v_column2, @v_column3, @v_column4, @v_column5
								, @v_column6, @v_column7, @v_column8, @v_column9, @v_column10
								, @v_column11, @v_column12, @v_column13, @v_column14, @v_column15
								, @v_column16, @v_column17, @v_column18, @v_column19
								, @v_mail_title
								, @v_body_contents, @v_sql_long_text, @v_user_cnt, @v_rank
				
			END
		CLOSE CUR_SEND;
		DEALLOCATE CUR_SEND;

		IF LEN(@v_head_cont) > 0
		BEGIN

		

			SET @TABLE_BODY = ''
			SET @TABLE_BODY = ' <html>
						<head>
								<title>Untitled Document</title>
								<style>
									* {margin:0;padding:0;}
									body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
									table {border-collapse:collapse;width:100%;}
									table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
									table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
									table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
									table tbody td {padding:6px 8px;font-size:12px}
									table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
									.hori-table table thead td {text-align:center;padding:3px;}  
									.hori-table table tbody td {text-align:center;padding:3px;}
									.vertical-table, .hori-table {margin-bottom:20px;}
								</style>
								</head>
								<body>' +'</br>'+
										'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
										'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
									'<table style=''border-top:2px solid #c8294b; width:1450px;''>
									<thead>' + ISNULL(@v_head_cont,'') +'</thead>
									<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
									</div>
								</body>
						</html>';



				SET @v_receiver_tmpcnt = 0;

				SELECT @v_receiver_cnt = COUNT(*)
				FROM (
					SELECT DISTINCT USER_ID
					FROM #TblMailSendBatch
				) A


				WHILE @v_receiver_tmpcnt < @v_receiver_cnt
				BEGIN

					SET @v_receiver_tmpcnt = @v_receiver_tmpcnt + 1;

					SELECT @v_to_mail = USER_ID
					FROM (
						SELECT DISTINCT USER_ID
						FROM #TblMailSendBatch
						WHERE rank = @v_receiver_tmpcnt
					) A


					SELECT @v_to_mail  = @v_to_mail + CASE WHEN ISNUMERIC(DEPT_ID) = 0 THEN '@lgespartner.com' ELSE '@lgensol.com' END
					FROM SCM_MST_SSO_USER_INFO WITH(NOLOCK)
					WHERE USER_ID = @v_to_mail
					;

		
					-- 메일 발송
					EXEC SCM_ADM_MAIL_SEND
							--@v_to_mail
							'jooyong026@lgespartner.com'--개발용
							,@v_mail_title
							,@TABLE_BODY
							,'Y'
							;

					--MAIL 발송 LOG 저장
					EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG @v_use_type_code
									,@p_category_id
									,@v_segment1
									,@v_segment2
									,@v_segment3
									,@v_segment4
									,@v_segment5
									,@v_segment6
									,@v_segment7
									,@v_segment8
									,@v_segment9
									,@v_segment10
									,'' --p_send_pgm
									,@v_to_mail;


					SET @v_to_mail = '';

				END

		END


		DROP TABLE #TblMailSendBatch;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		CLOSE CUR_SEND;
		DEALLOCATE CUR_SEND;
		BEGIN

		INSERT INTO scm_sys_log_batch (program_name
										,log_type
										,log_count
										,log_message
										,description
										,event_date
										,creation_date
										,created_by
										,last_update_date
										,last_updated_by)
		VALUES (ERROR_PROCEDURE()
				,'ERROR'
				,NULL
				,ERROR_MESSAGE()
				,NULL
				,SYSDATETIME()
				,SYSDATETIME()
				,ERROR_PROCEDURE()
				,SYSDATETIME()
				,ERROR_PROCEDURE());

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;

		BEGIN
			DECLARE @v_error_message NVARCHAR(1000);
			SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);

			--MAIL 발송 LOG 저장
				EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'ERROR'
				              ,@p_category_id
							  ,'MAIN ERROR' 
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,@v_error_message --p_send_pgm
							  ,'';
		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END
		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END






