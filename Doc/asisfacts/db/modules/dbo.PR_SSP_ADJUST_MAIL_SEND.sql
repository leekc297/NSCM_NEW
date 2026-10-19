
/*
 * Program ID   : PR_SSP_ADJUST_MAIL_SEND
 * Description  : SSP MAIL 발송 (Adjust 메뉴 confirm)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/11/12	hwyoon			Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019/04/09   juhlee          [PJ20189106] 전지.GSCM 고도화 이행
                                LOOKUP SEGMENT3(FROM_SITE) 추가 및 법인간 거래 대상 메일링 추가 
								SEGMENT3(FROM_SITE) 이 ALL로 설정시 전체 대상,특정 FROM SITE 설정시 특정 FROM_SITE 대상
								요청자가 있을 경우 요청자에게도 메일전송
 * 2019/06/11	mcTheJ			[CSR ID:3994058] [요청]생산관리 출하변경 시 사유 code화 관리
 */
CREATE PROCEDURE [dbo].[PR_SSP_ADJUST_MAIL_SEND]
	 @p_grp_chg_req nvarchar(max)=NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;


	DECLARE @v_mail_title		NVARCHAR(100);
	DECLARE @v_head_cont		NVARCHAR(MAX);
	DECLARE @v_body_cont		NVARCHAR(MAX);
	DECLARE @v_body_text		NVARCHAR(MAX);
	DECLARE @v_to_mail			NVARCHAR(MAX);
	DECLARE @v_to_mail_back		NVARCHAR(MAX);
	DECLARE @TABLE_BODY			NVARCHAR(MAX);

	DECLARE @v_mail_receiver	NVARCHAR(600);
	DECLARE @v_division_id		NVARCHAR(30);
	DECLARE @v_item_id			NVARCHAR(50);
	DECLARE @v_nick_name		NVARCHAR(50);
	DECLARE @v_from_site		NVARCHAR(30);
	DECLARE @v_from_site_description	NVARCHAR(MAX);
	DECLARE @v_to_site			NVARCHAR(30);
	DECLARE @v_to_site_description		NVARCHAR(MAX);
	DECLARE @v_mtk_owner		NVARCHAR(MAX);
	DECLARE @v_incoterms		NVARCHAR(10);
	DECLARE @v_yyyymmdd			NVARCHAR(10);
	DECLARE @v_qty				NVARCHAR(MAX);
	DECLARE @v_transport_mode	NVARCHAR(50);
	DECLARE @v_new_yyyymmdd		NVARCHAR(10);
	DECLARE @v_new_qty			NVARCHAR(MAX);
	DECLARE @v_new_transport_mode	NVARCHAR(50);
	DECLARE @v_last_update_date	NVARCHAR(50);
	DECLARE @v_last_update_by	NVARCHAR(MAX);


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_ADJUST_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	--계산용 변수
	DECLARE @chk INT=0; -- 쿼리결과 총 건수
	--DECLARE @i INT=1;	-- LOOP용
	DECLARE @mailChkCnt INT = 0;
	DECLARE @mailSendCnt INT = 0;

	IF OBJECT_ID('tempdb..#TblSSPAdjustMailSend') IS NOT NULL
		   DROP TABLE #TblSSPAdjustMailSend 

	/*
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblSSPAdjustMailSend%')
	   DROP TABLE #TblSSPAdjustMailSend
	*/

	/*
	CREATE TABLE #TblSSPAdjustMailSend (
		MAIL_RECEIVER			NVARCHAR(600)
		, DIVISION_ID			NVARCHAR(30) 
		, ITEM_ID				NVARCHAR(50)
		, NICK_NAME				NVARCHAR(50)
		, FROM_SITE				NVARCHAR(30)
		, FROM_SITE_DESCRIPTION	NVARCHAR(MAX)
		, TO_SITE				NVARCHAR(30)
		, TO_SITE_DESCRIPTION	NVARCHAR(MAX)
		, MTK_OWNER				NVARCHAR(MAX)
		, INCOTERMS				NVARCHAR(10)
		, YYYYMMDD				NVARCHAR(8)
		, QTY					NVARCHAR(MAX)
		, TRANSPORT_MODE		NVARCHAR(50)
		, NEW_YYYYMMDD			NVARCHAR(8)
		, NEW_QTY				NVARCHAR(MAX)
		, NEW_TRANSPORT_MODE	NVARCHAR(50)
		--, PROJECT_CODE			NVARCHAR(50)
		--, APPROVAL_DEPT			NVARCHAR(50)
		, LAST_UPDATE_DATE		NVARCHAR(50)
		, LAST_UPDATED_BY		NVARCHAR(MAX)
	);
	*/
	SELECT T0.MAIL_RECEIVER
	,      T0.DIVISION_ID
	,      T0.ITEM_ID
	,      T0.NICK_NAME
	,	   T0.FROM_SITE
	,      T0.FROM_SITE_DESCRIPTION
	,	   T0.TO_SITE
	,      T0.TO_SITE_DESCRIPTION
	,      T0.MTK_OWNER
	,      T0.INCOTERMS
	,	   T0.YYYYMMDD
	,	   T0.QTY
	,      T0.TRANSPORT_MODE
	,	   T0.NEW_YYYYMMDD
	,	   T0.NEW_QTY
	,      T0.NEW_TRANSPORT_MODE
	,      T0.LAST_UPDATE_DATE
	,      T0.LAST_UPDATED_BY
	,	   ROW_NUMBER() OVER (ORDER BY T0.MAIL_RECEIVER , T0.DIVISION_ID, T0.ITEM_ID , T0.FROM_SITE, T0.TO_SITE, T0.YYYYMMDD, T0.TRANSPORT_MODE) AS ROWNUM     
	INTO #TblSSPAdjustMailSend
	FROM
	(
		SELECT M.MAIL_RECEIVER
		,      M.DIVISION_ID
		,      M.ITEM_ID
		,      M.NICK_NAME
		,	   M.FROM_SITE
		,      M.FROM_SITE_DESCRIPTION
		,	   M.TO_SITE
		,      M.TO_SITE_DESCRIPTION
		,      M.MTK_OWNER
		,      M.INCOTERMS
		,	   SUBSTRING(M.YYYYMMDD,1,4)+'-'+SUBSTRING(M.YYYYMMDD,5,2)+'-'+SUBSTRING(M.YYYYMMDD,7,2) AS YYYYMMDD
		,	   REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(M.QTY AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') AS QTY
		,      M.TRANSPORT_MODE
		,	   SUBSTRING(M.NEW_YYYYMMDD,1,4)+'-'+SUBSTRING(M.NEW_YYYYMMDD,5,2)+'-'+SUBSTRING(M.NEW_YYYYMMDD,7,2) AS NEW_YYYYMMDD
		,	   REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(M.NEW_QTY AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') AS NEW_QTY
		,      M.NEW_TRANSPORT_MODE
		,      CONVERT(CHAR(23), M.LAST_UPDATE_DATE, 21) AS LAST_UPDATE_DATE
		,      M.LAST_UPDATED_BY
		FROM ( 

	/* -- 마케팅 담당자는 적용 시점 확인 후 적용 필요 
		 -- 마케팅 담당자 
		 SELECT U.MKT_USER                                                         AS MAIL_RECEIVER
		 ,      D.DIVISION_ID 
		 ,      D.ITEM_ID 
		 ,      [DBO].[FN_GET_ITEM_NICKNAME](D.DIVISION_ID,D.ITEM_ID)              AS NICK_NAME 
		 ,      D.FROM_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.FROM_SITE ) AS FROM_SITE_DESCRIPTION
		 ,      D.TO_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.TO_SITE )   AS TO_SITE_DESCRIPTION
		 ,      DBO.FN_GET_SSP_MKT_OWNER_NAME (S.OWNER, ',', 'KO')                 AS MTK_OWNER
		 ,      D.INCOTERMS 
		 ,      D.YYYYMMDD 
		 ,      D.QTY 
		 ,      D.TRANSPORT_MODE 
		 ,      D.NEW_YYYYMMDD 
		 ,      D.NEW_QTY 
		 ,      D.NEW_TRANSPORT_MODE
		 ,      D.PROJECT_CODE  
		 ,      H.APPROVAL_DEPT 
		 ,      H.APPROVAL_TIME      AS LAST_UPDATE_DATE 
		 ,      [dbo].[FN_GET_USER_NAME](H.APPROVAL_USER) + '(' +  H.APPROVAL_USER + ')'  AS LAST_UPDATED_BY
		 FROM   SSP_ANL_SHIP_CONFIRM_CHG_REQ H WITH(NOLOCK) 
		  JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
			ON H.CHANGE_REQ_NO = D.CHANGE_REQ_NO 
		   AND D.VALID_YN = 'Y'
		  JOIN SSP_MKT_USER_V U
			ON U.DIVISION_ID   = CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END 
		   AND U.TO_SITE       = D.TO_SITE 
		   AND U.ITEM_ID       = D.ITEM_ID 
		   AND U.PROJECT_CODE  = D.PROJECT_CODE 
		  LEFT OUTER JOIN  SCM_MST_SITE_ITEM S WITH(NOLOCK) 
			ON  S.DIVISION_ID  = CASE WHEN D.DIVISION_ID ='EE' THEN D.ORIGIN_TO_DIVISION_ID ELSE D.DIVISION_ID END 
		   AND  S.SCM_SITE_ID  = D.TO_SITE 
		   AND  S.ITEM_ID      = D.ITEM_ID 
		   AND  S.PROJECT_CODE = D.PROJECT_CODE 
		  INNER JOIN SSP_MST_SEND_MAIL_REQ R
			ON H.CHANGE_REQ_NO = R.CHANGE_REQ_NO 
		 WHERE  1=1  
		 AND    H.CHANGE_TYPE  = 'A'
		 AND    H.CHANGE_REQ_STATUS = 'A'
		 AND    H.VALID_YN = 'Y'
		 --AND    H.CHANGE_REQ_NO = @p_chg_req_no 
		 AND    R.GRP_CHANGE_REQ = @p_grp_chg_req
		 UNION ALL 
	*/
		 -- SHIPMENT ADJUSTMENT/SHIPMENT PLAN (IT & Mobile)화면에서 변경시  (40번만)  SHIPMENT REQUEST 요청자 정보가 있는 경우 메일 발송 (40번만) 
		 SELECT D.REQUESTOR                                                      AS MAIL_RECEIVER
		 ,      D.DIVISION_ID 
		 ,      D.ITEM_ID 
		 ,      [DBO].[FN_GET_ITEM_NICKNAME](D.DIVISION_ID,D.ITEM_ID)              AS NICK_NAME 
		 ,      D.FROM_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.FROM_SITE ) AS FROM_SITE_DESCRIPTION
		 ,      D.TO_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.TO_SITE )   AS TO_SITE_DESCRIPTION
		 ,      DBO.FN_GET_SSP_MKT_OWNER_NAME (S.OWNER, ',', 'KO' )                AS MTK_OWNER
		 ,      D.INCOTERMS 
		 ,      D.YYYYMMDD 
		 ,      D.QTY 
		 ,      D.TRANSPORT_MODE 
		 ,      D.NEW_YYYYMMDD 
		 ,      D.NEW_QTY 
		 ,      D.NEW_TRANSPORT_MODE
		 ,      D.PROJECT_CODE  
		 ,      H.APPROVAL_DEPT 
		 ,      H.APPROVAL_TIME      AS LAST_UPDATE_DATE 
		 ,      [dbo].[FN_GET_USER_NAME](H.APPROVAL_USER) + '(' +  H.APPROVAL_USER + ')'  AS LAST_UPDATED_BY
		 FROM   SSP_ANL_SHIP_CONFIRM_CHG_REQ H WITH(NOLOCK) 
		  JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
			ON H.CHANGE_REQ_NO = D.CHANGE_REQ_NO 
		   AND D.VALID_YN = 'Y'
		  LEFT OUTER JOIN  SCM_MST_SITE_ITEM S WITH(NOLOCK) 
			ON  S.DIVISION_ID  = CASE WHEN D.DIVISION_ID ='EE' THEN D.ORIGIN_TO_DIVISION_ID ELSE D.DIVISION_ID END 
		   AND  S.SCM_SITE_ID  = D.TO_SITE 
		   AND  S.ITEM_ID      = D.ITEM_ID 
		   AND  S.PROJECT_CODE = D.PROJECT_CODE
		  INNER JOIN SSP_MST_SEND_MAIL_REQ R WITH(NOLOCK)
			ON H.CHANGE_REQ_NO = R.CHANGE_REQ_NO 
		 WHERE  1=1  
		 AND    H.CHANGE_TYPE  = 'A'  -- SHIPMENT ADJUSTMENT/SHIPMENT PLAN (IT & Mobile)화면에서 변경
		 AND    H.CHANGE_REQ_STATUS = 'A'
		 AND    H.VALID_YN = 'Y'
		 --AND    H.CHANGE_REQ_NO =  @p_chg_req_no 
		 AND    R.GRP_CHANGE_REQ = @p_grp_chg_req
		 AND    D.REQUESTOR IS NOT NULL -- SHIPMENT REQUEST 요청자 있는 경우 요청자에게 메일 발송 
		 AND    H.DIVISION_ID = '40'

		 UNION ALL 
 
		  -- SHIPMENT ADJUSTMENT/SHIPMENT PLAN (IT & Mobile)화면에서 변경시 변경자에게 메일 발송  (40번만) 
		 SELECT H.REQUEST_USER                                                     AS MAIL_RECEIVER
		 ,      D.DIVISION_ID 
		 ,      D.ITEM_ID 
		 ,      [DBO].[FN_GET_ITEM_NICKNAME](D.DIVISION_ID,D.ITEM_ID)              AS NICK_NAME 
		 ,      D.FROM_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.FROM_SITE ) AS FROM_SITE_DESCRIPTION
		 ,      D.TO_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.TO_SITE )   AS TO_SITE_DESCRIPTION
		 ,      DBO.FN_GET_SSP_MKT_OWNER_NAME (S.OWNER, ',', 'KO' )                AS MTK_OWNER
		 ,      D.INCOTERMS 
		 ,      D.YYYYMMDD 
		 ,      D.QTY 
		 ,      D.TRANSPORT_MODE 
		 ,      D.NEW_YYYYMMDD 
		 ,      D.NEW_QTY 
		 ,      D.NEW_TRANSPORT_MODE
		 ,      D.PROJECT_CODE  
		 ,      H.APPROVAL_DEPT 
		 ,      H.APPROVAL_TIME      AS LAST_UPDATE_DATE 
		 ,      [dbo].[FN_GET_USER_NAME](H.APPROVAL_USER) + '(' +  H.APPROVAL_USER + ')'  AS LAST_UPDATED_BY
		 FROM   SSP_ANL_SHIP_CONFIRM_CHG_REQ H WITH(NOLOCK) 
		  JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
			ON H.CHANGE_REQ_NO = D.CHANGE_REQ_NO 
		   AND D.VALID_YN = 'Y'
		  LEFT OUTER JOIN  SCM_MST_SITE_ITEM S WITH(NOLOCK) 
			ON  S.DIVISION_ID  = CASE WHEN D.DIVISION_ID ='EE' THEN D.ORIGIN_TO_DIVISION_ID ELSE D.DIVISION_ID END 
		   AND  S.SCM_SITE_ID  = D.TO_SITE 
		   AND  S.ITEM_ID      = D.ITEM_ID 
		   AND  S.PROJECT_CODE = D.PROJECT_CODE 
		  INNER JOIN SSP_MST_SEND_MAIL_REQ R WITH(NOLOCK)
			ON H.CHANGE_REQ_NO = R.CHANGE_REQ_NO 
		 WHERE  1=1  
		 AND    H.CHANGE_TYPE  = 'A'  -- SHIPMENT ADJUSTMENT/SHIPMENT PLAN (IT & Mobile)화면에서 변경
		 AND    H.CHANGE_REQ_STATUS = 'A'
		 AND    H.VALID_YN = 'Y'
		 --AND    H.CHANGE_REQ_NO =  @p_chg_req_no 
		 AND    R.GRP_CHANGE_REQ = @p_grp_chg_req
		 AND    H.DIVISION_ID = '40'

		 UNION ALL 
    

		 -- LOOKUP(LOOKUP TYPE : ADJUST_MAIL_SEND)에 등록된 물류/PI/SM 담당자(법인간 거래 담당자 제외)   
		 SELECT M.SEGMENT2                                                         AS MAIL_RECEIVER
		 ,      D.DIVISION_ID 
		 ,      D.ITEM_ID 
		 ,      [DBO].[FN_GET_ITEM_NICKNAME](D.DIVISION_ID,D.ITEM_ID)              AS NICK_NAME 
		 ,      D.FROM_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.FROM_SITE ) AS FROM_SITE_DESCRIPTION
		 ,      D.TO_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.TO_SITE )   AS TO_SITE_DESCRIPTION
		 ,      DBO.FN_GET_SSP_MKT_OWNER_NAME (S.OWNER, ',', 'KO' )                AS MTK_OWNER
		 ,      D.INCOTERMS 
		 ,      D.YYYYMMDD 
		 ,      D.QTY 
		 ,      D.TRANSPORT_MODE 
		 ,      D.NEW_YYYYMMDD 
		 ,      D.NEW_QTY 
		 ,      D.NEW_TRANSPORT_MODE
		 ,      D.PROJECT_CODE  
		 ,      H.APPROVAL_DEPT 
		 ,      H.APPROVAL_TIME      AS LAST_UPDATE_DATE 
		 ,      [dbo].[FN_GET_USER_NAME](H.APPROVAL_USER) + '(' +  H.APPROVAL_USER + ')'  AS LAST_UPDATED_BY
		 FROM   SSP_ANL_SHIP_CONFIRM_CHG_REQ H WITH(NOLOCK) 
		  JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
			ON H.CHANGE_REQ_NO = D.CHANGE_REQ_NO 
		   AND D.VALID_YN = 'Y'
		  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)  
			ON  M.LOOKUP_TYPE ='ADJUST_MAIL_SEND'
		   AND  M.VALID_YN    ='Y'
		   AND  M.SEGMENT3    =  CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE D.FROM_SITE END 
		   AND  M.SEGMENT1   <> 'INTER_COMPANY' -- 법인간 거래 수신자 제외 
		  LEFT OUTER JOIN  SCM_MST_SITE_ITEM S WITH(NOLOCK) 
			ON  S.DIVISION_ID  = CASE WHEN D.DIVISION_ID ='EE' THEN D.ORIGIN_TO_DIVISION_ID ELSE D.DIVISION_ID END 
		   AND  S.SCM_SITE_ID  = D.TO_SITE 
		   AND  S.ITEM_ID      = D.ITEM_ID 
		   AND  S.PROJECT_CODE = D.PROJECT_CODE 
		  INNER JOIN SSP_MST_SEND_MAIL_REQ R WITH(NOLOCK)
			ON H.CHANGE_REQ_NO = R.CHANGE_REQ_NO
		 WHERE  1=1  
		 AND    H.CHANGE_TYPE  = 'A'
		 AND    H.CHANGE_REQ_STATUS = 'A'
		 AND    H.VALID_YN = 'Y'
		 --AND    H.CHANGE_REQ_NO =  @p_chg_req_no 
		 AND    R.GRP_CHANGE_REQ = @p_grp_chg_req

		 UNION ALL 
		 -- LOOKUP(LOOKUP TYPE : ADJUST_MAIL_SEND)에 등록된 법인간 거래 담당자(INTER_COMPANY TYPE으로 등록)      
		 SELECT M.SEGMENT2                                                         AS MAIL_RECEIVER
		 ,      D.DIVISION_ID 
		 ,      D.ITEM_ID 
		 ,      [DBO].[FN_GET_ITEM_NICKNAME](D.DIVISION_ID,D.ITEM_ID)              AS NICK_NAME 
		 ,      D.FROM_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.FROM_SITE ) AS FROM_SITE_DESCRIPTION
		 ,      D.TO_SITE 
		 ,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.TO_SITE )   AS TO_SITE_DESCRIPTION
		 ,      DBO.FN_GET_SSP_MKT_OWNER_NAME (S.OWNER, ',', 'KO' )                AS MTK_OWNER
		 ,      D.INCOTERMS 
		 ,      D.YYYYMMDD 
		 ,      D.QTY 
		 ,      D.TRANSPORT_MODE 
		 ,      D.NEW_YYYYMMDD 
		 ,      D.NEW_QTY 
		 ,      D.NEW_TRANSPORT_MODE
		 ,      D.PROJECT_CODE  
		 ,      H.APPROVAL_DEPT 
		 ,      H.APPROVAL_TIME      AS LAST_UPDATE_DATE 
		 ,      [dbo].[FN_GET_USER_NAME](H.APPROVAL_USER) + '(' +  H.APPROVAL_USER + ')'  AS LAST_UPDATED_BY
		 FROM   SSP_ANL_SHIP_CONFIRM_CHG_REQ H WITH(NOLOCK) 
		  JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
			ON H.CHANGE_REQ_NO = D.CHANGE_REQ_NO 
		   AND D.VALID_YN = 'Y'
		  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)  
			ON  M.LOOKUP_TYPE ='ADJUST_MAIL_SEND'
		   AND  M.VALID_YN    ='Y'
		   AND  M.SEGMENT3    =  CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE D.FROM_SITE END  
		   AND  M.SEGMENT1    = 'INTER_COMPANY' -- 법인간 거래 대상만 
		  JOIN SCM_MST_SITE T WITH(NOLOCK)  -- 법인간 거래는 TO_SITE가 PLANT_SITE 인것만 
			ON  T.DIVISION_ID  = CASE WHEN D.DIVISION_ID ='EE' THEN D.ORIGIN_TO_DIVISION_ID ELSE D.DIVISION_ID END 
		   AND  T.SCM_SITE_ID  = D.TO_SITE
		   AND  T.SITE_TYPE    = 'PLANT'
		   AND  T.OSP_YN       = 'N'
		  LEFT OUTER JOIN  SCM_MST_SITE_ITEM S WITH(NOLOCK) 
			ON  S.DIVISION_ID  = CASE WHEN D.DIVISION_ID ='EE' THEN D.ORIGIN_TO_DIVISION_ID ELSE D.DIVISION_ID END 
		   AND  S.SCM_SITE_ID  = D.TO_SITE 
		   AND  S.ITEM_ID      = D.ITEM_ID 
		   AND  S.PROJECT_CODE = D.PROJECT_CODE 
		  INNER JOIN SSP_MST_SEND_MAIL_REQ R WITH(NOLOCK)
			ON H.CHANGE_REQ_NO = R.CHANGE_REQ_NO
		 WHERE  1=1  
		 AND    H.CHANGE_TYPE  = 'A'
		 AND    H.CHANGE_REQ_STATUS = 'A'
		 AND    H.VALID_YN = 'Y'
		 --AND    H.CHANGE_REQ_NO = @p_chg_req_no 
		 AND    R.GRP_CHANGE_REQ = @p_grp_chg_req

		) M 
		WHERE  ( M.YYYYMMDD <> M.NEW_YYYYMMDD  OR M.QTY <> M.NEW_QTY  OR M.TRANSPORT_MODE <> M.NEW_TRANSPORT_MODE ) --날짜,수량,운송모드 변경없는것은 메일 대상 제외
	) AS T0
	GROUP BY T0.MAIL_RECEIVER, T0.DIVISION_ID, T0.ITEM_ID, T0.NICK_NAME, T0.FROM_SITE, T0.FROM_SITE_DESCRIPTION, T0.TO_SITE, T0.TO_SITE_DESCRIPTION, T0.MTK_OWNER,
	         T0.INCOTERMS, T0.YYYYMMDD, T0.QTY, T0.TRANSPORT_MODE, T0.NEW_YYYYMMDD, T0.NEW_QTY, T0.NEW_TRANSPORT_MODE, T0.LAST_UPDATE_DATE, T0.LAST_UPDATED_BY
			 
	ORDER BY T0.MAIL_RECEIVER , T0.DIVISION_ID, T0.ITEM_ID , T0.FROM_SITE, T0.TO_SITE, T0.YYYYMMDD, T0.TRANSPORT_MODE


	SELECT @chk = COUNT(*)
	FROM #TblSSPAdjustMailSend

	IF @chk = 0
		BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			RETURN;
		END


	--DECLARE CUR_SEND_ADJUST CURSOR FOR
	--SELECT *
	--FROM #TblSSPAdjustMailSend
	--ORDER BY MAIL_RECEIVER , DIVISION_ID, ITEM_ID , FROM_SITE, TO_SITE, YYYYMMDD, TRANSPORT_MODE


	/********************************************************************************
	* HEAD CONT 
	********************************************************************************/		
	SET @v_head_cont = '';
	SET @v_head_cont = @v_head_cont+ '<tr>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Div' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Model' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Nick Name' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'From Site' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'To Site' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'MKT Owner' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Incoterms' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th colspan=''3''>' + 'Old' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th colspan=''3''>' + 'New' + '</th>'
	SET @v_head_cont = @v_head_cont+ '</tr>'
	SET @v_head_cont = @v_head_cont+ '<tr>'
	SET @v_head_cont = @v_head_cont+ '<th width=''90px''>' + 'Shipment Date' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''90px''>' + 'Shipment Qty' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''80px''>' + 'Trans Mode' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''90px''>' + 'Shipment Date' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''90px''>' + 'Shipment Qty' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''80px''>' + 'Trans Mode' + '</th>'
	SET @v_head_cont = @v_head_cont+ '</tr>'

	SET @v_mail_title	 = '[Notice]Your Shipment plan has been changed';
	SET @v_body_text	 = 'Dear all,
							Please refer to below table and check your changed shipment plan.
							Thanks in adavance.
							
							';



	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		SET @v_body_cont = ''			
		SET @v_to_mail_back = ''

		--OPEN CUR_SEND_ADJUST;
		--FETCH NEXT FROM CUR_SEND_ADJUST INTO @v_mail_receiver, @v_division_id, @v_item_id, @v_nick_name, @v_from_site, @v_from_site_description, @v_to_site, @v_to_site_description
		--	                , @v_mtk_owner, @v_incoterms, @v_yyyymmdd, @v_qty, @v_transport_mode, @v_new_yyyymmdd, @v_new_qty, @v_new_transport_mode, @v_last_update_date, @v_last_update_by

		SET @mailChkCnt = @mailChkCnt + 1; -- 한 행 FETCH시 마다 +1

		SELECT @v_mail_receiver		= MAIL_RECEIVER
			   , @v_division_id		= DIVISION_ID
			   , @v_item_id			= ITEM_ID
			   , @v_nick_name		= NICK_NAME
			   , @v_from_site		= FROM_SITE
			   , @v_from_site_description	= FROM_SITE_DESCRIPTION
			   , @v_to_site			= TO_SITE
			   , @v_to_site_description		= TO_SITE_DESCRIPTION
			   , @v_mtk_owner		= MTK_OWNER
			   , @v_incoterms		= INCOTERMS
			   , @v_yyyymmdd		= YYYYMMDD
			   , @v_qty				= QTY
			   , @v_transport_mode	= TRANSPORT_MODE
			   , @v_new_yyyymmdd	= NEW_YYYYMMDD
			   , @v_new_qty			= NEW_QTY
			   , @v_new_transport_mode		= NEW_TRANSPORT_MODE
			   , @v_last_update_date		= LAST_UPDATE_DATE
			   , @v_last_update_by	= LAST_UPDATED_BY
		FROM #TblSSPAdjustMailSend
		WHERE ROWNUM=@mailChkCnt


		--WHILE @@FETCH_STATUS = 0
		WHILE @mailChkCnt <= @chk+1
			BEGIN
				SET @v_to_mail = @v_mail_receiver+'@lgensol.com';

				IF @v_to_mail_back = '' 
					BEGIN
						SET @v_to_mail_back = @v_to_mail
					END

				IF @mailChkCnt=1
					BEGIN
						SET @v_body_text = @v_body_text+ 'Last updated by : '+@v_last_update_by+'    Last update Date : '+@v_last_update_date+'</br>'
					END

				IF @mailSendCnt=10
					BEGIN
						WAITFOR DELAY '00:00:05' -- FIVE seconds
						SET @mailSendCnt = 0;	-- 10건 전송시마다 5초의 딜레이를 준 후 건수 초기화
					END

				IF (@v_to_mail_back != @v_to_mail OR @mailChkCnt=@chk+1)
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
															'<b>' + REPLACE(ISNULL(@v_body_text, ''), CHAR(10), '<br>') + '</b>' +
															'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
														'<table style=''border-top:2px solid #c8294b; width:1200px;''>
														<thead>' + ISNULL(@v_head_cont,'') +'</thead>
														<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
														</div>
													</body>
											</html>'
						
						--메일 발송
						EXEC SCM_ADM_MAIL_SEND
									--@v_to_mail_back
									'jooyong026@@lgespartner.com'-- 개발 테스트용
									,@v_mail_title
									,@TABLE_BODY
									,'Y'
									;

						SET @mailSendCnt = @mailSendCnt + 1;
						SET @v_body_cont = ''

						--MAIL 발송 LOG 저장
						EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL'
										,'-'
										,@v_division_id
										,@v_from_site_description
										,@v_item_id
										,@v_nick_name
										,''
										,''
										,''
										,''
										,''
										,''
										,'' --p_send_pgm
										,@v_to_mail_back;
						SET @v_to_mail_back = @v_to_mail
					END;


				SET @v_body_cont = @v_body_cont+ '<tr>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_to_site_description,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_mtk_owner,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_incoterms,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_yyyymmdd,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(@v_qty,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_transport_mode,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_new_yyyymmdd,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(@v_new_qty,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_new_transport_mode,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '</tr>'
				
				--FETCH NEXT FROM CUR_SEND_ADJUST INTO @v_mail_receiver, @v_division_id, @v_item_id, @v_nick_name, @v_from_site, @v_from_site_description, @v_to_site, @v_to_site_description
			                --, @v_mtk_owner, @v_incoterms, @v_yyyymmdd, @v_qty, @v_transport_mode, @v_new_yyyymmdd, @v_new_qty, @v_new_transport_mode, @v_last_update_date, @v_last_update_by

				SET @mailChkCnt = @mailChkCnt + 1;

				SELECT @v_mail_receiver		= MAIL_RECEIVER
					   , @v_division_id		= DIVISION_ID
					   , @v_item_id			= ITEM_ID
					   , @v_nick_name		= NICK_NAME
					   , @v_from_site		= FROM_SITE
					   , @v_from_site_description	= FROM_SITE_DESCRIPTION
					   , @v_to_site			= TO_SITE
					   , @v_to_site_description		= TO_SITE_DESCRIPTION
					   , @v_mtk_owner		= MTK_OWNER
					   , @v_incoterms		= INCOTERMS
					   , @v_yyyymmdd		= YYYYMMDD
					   , @v_qty				= QTY
					   , @v_transport_mode	= TRANSPORT_MODE
					   , @v_new_yyyymmdd	= NEW_YYYYMMDD
					   , @v_new_qty			= NEW_QTY
					   , @v_new_transport_mode		= NEW_TRANSPORT_MODE
					   , @v_last_update_date		= LAST_UPDATE_DATE
					   , @v_last_update_by	= LAST_UPDATED_BY
				FROM #TblSSPAdjustMailSend
				WHERE ROWNUM=@mailChkCnt

			END;
		--CLOSE CUR_SEND_ADJUST;
		--DEALLOCATE CUR_SEND_ADJUST;

		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		--CLOSE CUR_SEND_ADJUST;
		--DEALLOCATE CUR_SEND_ADJUST;
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
				              ,null
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

	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblSSPAdjustMailSend') IS NOT NULL
		DROP TABLE #TblSSPAdjustMailSend

END




