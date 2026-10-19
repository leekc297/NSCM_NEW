

/*
 * Program ID   : PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM -- 미사용(2020.07.13 ~ )  
 * Description  : SSP Mail 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/10/01	mcTheJ			Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019/10/01	mcTheJ			html table 좌우 스크롤 수정
 * 2020.07.13   juhlee        [PJ20199555]  공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
                               -PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM 미사용
							    (신규 메일링으로 대체, 신규: PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM_PO<--별도 호출됨)
 ex)
EXEC PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM 'C100', '';
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM]
	@p_company_id1			NVARCHAR(10),
	@p_log_messge			NVARCHAR(1000) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	DECLARE @p_company_id  NVARCHAR(10); --속도개선을 위해 별도 DECLARE , SET설정 
	SET     @p_company_id = @p_company_id1 ;


	DECLARE @v_from_yyyymmdd    NVARCHAR(8);
	DECLARE @v_to_yyyymmdd      NVARCHAR(8);
	DECLARE @v_d_day			INT;
	DECLARE @v_d_minus_day		INT;
	DECLARE @v_head_cont		NVARCHAR(max);
	DECLARE @v_body_cont		NVARCHAR(max);
	DECLARE @v_receiver_temp	NVARCHAR(150);
	DECLARE @v_to_mail			NVARCHAR(max);
	DECLARE @TABLE_BODY			NVARCHAR(MAX);
	DECLARE @v_body_contents    NVARCHAR(MAX);
	DECLARE @v_mail_title           NVARCHAR(100);



	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_mail_receiver			NVARCHAR(100);
	DECLARE @v_division_id				NVARCHAR(100);
	DECLARE @v_company_id				NVARCHAR(100);
	DECLARE @v_from_site_description    NVARCHAR(100);
	DECLARE @v_item_id					NVARCHAR(100);
	DECLARE @v_nick_name				NVARCHAR(100);
	DECLARE @v_to_site_description      NVARCHAR(100);
	DECLARE @v_measure_name				NVARCHAR(100);
	DECLARE @v_user_sort_order			NVARCHAR(100);
	DECLARE @v_segment1					NVARCHAR(100);
	DECLARE @v_segment2					NVARCHAR(100);
	DECLARE @v_segment3					NVARCHAR(100);
	DECLARE @v_segment4					NVARCHAR(100);
	DECLARE @v_segment5					NVARCHAR(100);
	DECLARE @v_segment6					NVARCHAR(100);
	DECLARE @v_segment7					NVARCHAR(100);
	DECLARE @v_segment8					NVARCHAR(100);
	DECLARE @v_segment9					NVARCHAR(100);
	DECLARE @v_segment10				NVARCHAR(100);
	DECLARE @v_segment11				NVARCHAR(100);
	DECLARE @v_segment12				NVARCHAR(100);
	DECLARE @v_segment13				NVARCHAR(100);
	DECLARE @v_segment14				NVARCHAR(100);
	
	DECLARE @v_data_list_cnt			INT;
	DECLARE @v_ship_frozen				INT;
	DECLARE @v_date_cnt					INT;

	SET @v_data_list_cnt = 0;
	SET @v_ship_frozen = 0;
	SET @v_date_cnt = 0;

	IF OBJECT_ID('tempdb..#TMP_MAIL_SEND_LIST') IS NOT NULL
		DROP TABLE #TMP_MAIL_SEND_LIST 
	
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects with(NOLOCK) WHERE name = '#TMP_Tbl_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM')
		DROP TABLE dbo.#TMP_Tbl_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM;
		
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/	
	CREATE TABLE dbo.#TMP_Tbl_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM (
			MAIL_RECEIVER				NVARCHAR(100)
			, division_id				NVARCHAR(100) 
			, from_site_description		NVARCHAR(100)
			, to_site_description		NVARCHAR(100)
			, COMPANY_ID					NVARCHAR(100)
			, item_id					NVARCHAR(100)
			, nick_name					NVARCHAR(100)
			, measure_name				NVARCHAR(100)
			, user_sort_order_no			INT
			, SHIP_FROZEN				INT
			, segment1					NVARCHAR(100) -- 시작일
			, segment2					NVARCHAR(100) -- 시작일 + 1
			, segment3					NVARCHAR(100) -- 시작일 + 2
			, segment4					NVARCHAR(100) -- 시작일 + 3
			, segment5					NVARCHAR(100) -- 시작일 + 4
			, segment6					NVARCHAR(100) -- 시작일 + 5
			, segment7					NVARCHAR(100) -- 시작일 + 6
			, segment8					NVARCHAR(100) -- 시작일 + 7
			, segment9					NVARCHAR(100) -- 시작일 + 8
			, segment10					NVARCHAR(100) -- 시작일 + 9
			, segment11					NVARCHAR(100) -- 시작일 + 10
			, segment12					NVARCHAR(100) -- 시작일 + 11
			, segment13					NVARCHAR(100) -- 시작일 + 12
			, segment14					NVARCHAR(100) -- 시작일 + 13
	);

	--MAIL_RECEIVER별, YYYYMMDD 기준 Data List 생성
	SELECT 
		MAIL_RECEIVER, PLAN_START_YYYYMMDD, FROM_YYYYMMDD, TO_YYYYMMDD, ROW_NUMBER() OVER(ORDER BY MAIL_RECEIVER, PLAN_START_YYYYMMDD, FROM_YYYYMMDD, TO_YYYYMMDD) AS RN
	INTO #TMP_MAIL_SEND_LIST
	FROM SSP_MAIL_SHIP_PLAN_INTER_COM_V WITH(NOLOCK) 
	WHERE COMPANY_ID = @p_company_id
	GROUP BY MAIL_RECEIVER,	PLAN_START_YYYYMMDD, FROM_YYYYMMDD, TO_YYYYMMDD
	;
	
	SELECT @v_data_list_cnt = MAX(RN) FROM #TMP_MAIL_SEND_LIST WITH(NOLOCK);
	
	WHILE @v_data_list_cnt > 0 
	BEGIN
		
		Delete From dbo.#TMP_Tbl_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM;

		SET @v_from_yyyymmdd = '';
		SET @v_to_yyyymmdd   = '';
		
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0021_1') IS NOT NULL
			   DROP TABLE #TblDynamicPivot_SSP0021_1;
    
		IF OBJECT_ID('tempdb..#TMP_MAIL_DATA') IS NOT NULL
			   DROP TABLE #TMP_MAIL_DATA;
		
		

		WITH MAIL_SEND_TARGET AS
		(
			SELECT
				MAIL_RECEIVER, PLAN_START_YYYYMMDD, FROM_YYYYMMDD, TO_YYYYMMDD
			FROM #TMP_MAIL_SEND_LIST WITH(NOLOCK)
			WHERE 1 = 1
			AND RN = @v_data_list_cnt
		)
		SELECT
			T0.MAIL_RECEIVER
			, T0.DIVISION_ID
			, T0.COMPANY_ID
			, T0.PLAN_START_YYYYMMDD
			, T0.FROM_SITE
			, T0.TO_SITE 
			, T0.ITEM_ID
			, T0.FROM_YYYYMMDD
			, T0.TO_YYYYMMDD
			, T0.SHIP_FROZEN
		INTO #TMP_MAIL_DATA
		FROM SSP_MAIL_SHIP_PLAN_INTER_COM_V T0 WITH(NOLOCK)
		INNER JOIN MAIL_SEND_TARGET T1 WITH(NOLOCK)
			ON T0.MAIL_RECEIVER = T1.MAIL_RECEIVER			AND T0.PLAN_START_YYYYMMDD = T1.PLAN_START_YYYYMMDD
			AND T0.FROM_YYYYMMDD = T1.FROM_YYYYMMDD			AND T0.TO_YYYYMMDD = T1.TO_YYYYMMDD
		WHERE 1 = 1
		AND COMPANY_ID = @p_company_id
		;

		SELECT
			@v_from_yyyymmdd = MAX(FROM_YYYYMMDD)
			,@v_to_yyyymmdd = DBO.FN_DATE_TO_CHAR(DBO.FN_CHAR_TO_DATE(MAX(TO_YYYYMMDD)))
			--,@v_to_yyyymmdd = DBO.FN_DATE_TO_CHAR (DBO.FN_CHAR_TO_DATE(MAX(FROM_YYYYMMDD))  + 14)
		FROM #TMP_MAIL_DATA WITH(NOLOCK)
		;

		SET @v_date_cnt = DATEDIFF(DAY, @v_from_yyyymmdd, @v_to_yyyymmdd);


		/********************************************************************************
		* 데이타조회, 임시테이블에 저장
		********************************************************************************/
		SELECT 
			m.division_id	                          
 			, m.plan_start_yyyymmdd  
			, m.COMPANY_ID                             
 			, m.from_site                            
			, m.to_site                            
 			, m.item_id                              
 			, m.nick_name                            
 			, m.measure                              
 			, m.measure_name                         
 			, m.user_sort_order_no                
 			, m.yyyymmdd as yyyymmdd        
 			, SUM(convert(int,isnull(n.qty,0))) qty
			, MAIL_RECEIVER
			, SHIP_FROZEN
		INTO #TblDynamicPivot_SSP0021_1                             
 		FROM 
		(                                        
			SELECT                                    
				c.division_id			              
				, c.plan_start_yyyymmdd                        
				, c.COMPANY_ID
				, c.from_site			              
				, c.TO_SITE
				, c.item_id			                  
				, a.column_name	AS measure	          
				, a.COLUMN_LABEL_NAME AS measure_name 
				, c.yyyymmdd                          
				, c.nick_name	                      
				, a.sort_order_no AS user_sort_order_no	 
				, C.MAIL_RECEIVER   
				, C.SHIP_FROZEN
 			FROM scm_mst_sheet_measure a with(nolock) 
 			, ( 
				SELECT                                                              
					p.DIVISION_ID 			                                    
 					, p.PLAN_START_YYYYMMDD
					, p.COMPANY_ID
 					, p.FROM_SITE
					, A.TO_SITE			                                    
 					, p.ITEM_ID				                                    
 					, p.YYYYMMDD   	                                                
 					, dbo.fn_get_item_nickname( p.division_id, p.item_id ) AS nick_name  
					, A.MAIL_RECEIVER 
					, A.SHIP_FROZEN   
				FROM SSP_ANL_SHIP_PLAN_C P with(nolock)  
				INNER JOIN 
				(
					SELECT distinct 
						division_id
						,plan_start_yyyymmdd
						,COMPANY_ID
						,from_site
						,TO_SITE
						,item_id
						,MAIL_RECEIVER
						,FROM_YYYYMMDD
						,TO_YYYYMMDD 
						,SHIP_FROZEN 
					FROM #TMP_MAIL_DATA A with(nolock)
					WHERE 1 = 1
					AND COMPANY_ID = @p_company_id
				) a  
					ON P.DIVISION_ID = A.DIVISION_ID	AND P.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD 
					AND P.COMPANY_ID = A.COMPANY_ID 	AND P.FROM_SITE = A.FROM_SITE 
					AND P.TO_SITE = A.TO_SITE		AND P.ITEM_ID = A.ITEM_ID 
 				WHERE 1=1 
				  AND p.COMPANY_ID = @p_company_id
				  AND P.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
 				GROUP BY p.DIVISION_ID , p.PLAN_START_YYYYMMDD, p.COMPANY_ID, p.FROM_SITE, A.TO_SITE, p.ITEM_ID, p.YYYYMMDD,A.MAIL_RECEIVER, A.SHIP_FROZEN         
			) c                                                                                                                                      
			WHERE 1=1                                                          
 			AND a.program_id	= 'SSP0021'
 			AND a.sheet_name    = 'Shipment Plan'                        
 			AND a.valid_yn		= 'Y' 
			AND a.DEFAULT_FLAG  = 'Y'
			and a.COLUMN_NAME   = 'SHIP_PLAN'		
			
		) m 
		LEFT OUTER JOIN                                                    
 		(
			SELECT 
				DIVISION_ID                                                 
 				,PLAN_START_YYYYMMDD                                         
 				,COMPANY_ID                                                   
 				,FROM_SITE	                                               
 				,ITEM_ID                                                     
 				,YYYYMMDD                                                    
 				,measure		                                               
 				,sum(qty) as qty
			FROM
			(
				SELECT 
					p.DIVISION_ID                                                 
					,p.PLAN_START_YYYYMMDD                                         
					,p.COMPANY_ID                                                   
					,p.FROM_SITE	                                               
					,A.TO_SITE	                                               
					,p.ITEM_ID                                                     
					,p.YYYYMMDD                                                    
					,p.measure		                                               
					,p.qty                                            
				FROM SSP_ANL_SHIP_PLAN_C P with(nolock)    
				INNER JOIN 
				(
					SELECT distinct 
						division_id
						,plan_start_yyyymmdd
						,COMPANY_ID
						,from_site
						,to_site
						,item_id
						,FROM_YYYYMMDD
						,TO_YYYYMMDD 
						,SHIP_FROZEN 
					FROM #TMP_MAIL_DATA A with(nolock)
				) a  
					ON P.DIVISION_ID = A.DIVISION_ID		AND P.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD 
					AND P.COMPANY_ID = A.COMPANY_ID			AND P.FROM_SITE = A.FROM_SITE
					AND P.TO_SITE = A.TO_SITE			AND P.ITEM_ID = A.ITEM_ID                          
 				WHERE 1=1 
				AND p.COMPANY_ID = @p_company_id
				AND P.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
			) A
 			GROUP BY  A.division_id , A.plan_start_yyyymmdd, A.COMPANY_ID, A.from_site,A.TO_SITE,  A.item_id, A.yyyymmdd, A.measure                         
 		) n 
			ON  m.division_id			= n.division_id          
 			AND m.plan_start_yyyymmdd	= n.plan_start_yyyymmdd          
			AND m.COMPANY_ID			= n.COMPANY_ID          
 			AND m.from_site				= n.from_site            
 			AND m.item_id				= n.item_id              
 			AND m.yyyymmdd				= n.yyyymmdd             
 			AND m.measure				= n.measure              
 		WHERE 1=1
		GROUP BY m.division_id, m.plan_start_yyyymmdd, m.COMPANY_ID, m.from_site, m.TO_SITE, m.item_id, m.nick_name, m.measure, m.measure_name, m.user_sort_order_no, m.yyyymmdd, MAIL_RECEIVER, SHIP_FROZEN
		;

		DECLARE @chk INT;
		SET @chk = 0

		SELECT @chk = COUNT(*) FROM #TblDynamicPivot_SSP0021_1

		IF @chk = 0
		BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			RETURN;
		END

		--SELECT *
		--FROM #TblDynamicPivot_SSP0021_1
		--RETURN;	

		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/		
		BEGIN
			DECLARE @mQuery NVARCHAR(MAX);
			DECLARE @mEXEC NVARCHAR(MAX);

				-- PIVOIT 대상 날짜문자열 생성
			SET @mQuery = '';
			SELECT @mQuery = @mQuery + '[' + yyyymmdd + '], '
			FROM (
				SELECT *
				FROM(
					SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
							,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a with(nolock)
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.month_name	
					UNION ALL
					SELECT a.basis_yyyymmdd   AS yyyymmdd      
							, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a with(nolock)
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymmdd		
				) A WHERE yyyymmdd NOT LIKE 'M_%'
				  	
			) AS A
			ORDER BY sort_order_no  ;

			IF( LEN(@mQuery)>0)
			BEGIN
				SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);
			END;

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+'      SELECT MAIL_RECEIVER ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,division_id ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,COMPANY_ID ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,isnull(dbo.fn_get_scm_site_description(division_id, from_site ),''-'') AS from_site_description		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,isnull(dbo.fn_get_scm_site_description(division_id, to_site ),''-'') AS to_site_description		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,item_id	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,case when nick_name is null or nick_name = '''' then ''-'' else nick_name end nick_name	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,measure_name	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,user_sort_order_no	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,SHIP_FROZEN	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,'+@mQuery	 +CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0021_1 ' +CHAR(10);
			SET @mEXEC = @mEXEC+'       PIVOT ( ' +CHAR(10);
			SET @mEXEC = @mEXEC+'               SUM(qty) FOR  yyyymmdd IN ('+ @mQuery +') ' +CHAR(10);
			SET @mEXEC = @mEXEC+'             ) AS A'   +CHAR(10);
			SET @mEXEC = @mEXEC+'	   ORDER BY MAIL_RECEIVER, division_id, from_site,item_id, user_sort_order_no' +CHAR(10);

		END
		

		INSERT INTO dbo.#TMP_Tbl_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM
		EXEC (@mEXEC);

		--SELECT *
		--FROM #TblDynamicPivot_SSP0021_1
		--RETURN;	
		
		/********************************************************************************
		* HEAD CONT 
		********************************************************************************/
		SET @v_head_cont = '';
		SET @v_head_cont = @v_head_cont+ '<tr>'

		SET @v_head_cont = @v_head_cont+ '<th>' + 'Div' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th>' + 'Company' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th>' + 'From Site' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th>' + 'Model' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th>' + 'Nick Name' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th>' + 'To Site' + '</th>'
		SET @v_head_cont = @v_head_cont+ '<th>' + 'Measure' + '</th>'
		
		DECLARE	@v_tmp_cnt INT;
		DECLARE @v_tmp_date_cnt	INT;
		DECLARE @v_tmp_ship_frozen	INT;


		SET @v_tmp_cnt = 0;
		SET @v_tmp_date_cnt = @v_date_cnt;
		
		WHILE @v_tmp_date_cnt >= 0
		BEGIN
			SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_from_yyyymmdd) +  @v_tmp_cnt), 23 )   + '</th>'
			SET @v_tmp_cnt = @v_tmp_cnt + 1;
			SET @v_tmp_date_cnt = @v_tmp_date_cnt - 1;
		END
		
		SET @v_head_cont = @v_head_cont+ '</tr>'

		SET @v_mail_title = '[Notice] inter-company trade of confirmed shipment plan ';
		SET @v_body_contents = 'The shipment plan for inter-company trade Items have been confrimed as follows
								Please check the shipment plan and refer to PO creation and execution
								Thank you
								Best regards.
							
								';
		
		DECLARE CUR_SEND CURSOR FOR
		SELECT 
			*
		FROM dbo.#TMP_Tbl_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM
		ORDER BY MAIL_RECEIVER, division_id, COMPANY_ID, SHIP_FROZEN, from_site_description, to_site_description, item_id, user_sort_order_no
		
		BEGIN TRY	
			--//시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			--//LOG END
			
			SET @v_body_cont = ''			
			SET @v_receiver_temp = ''
		
			OPEN CUR_SEND;
			FETCH NEXT FROM CUR_SEND INTO @v_mail_receiver, @v_division_id, @v_company_id, @v_from_site_description, @v_to_site_description, @v_item_id, @v_nick_name, @v_measure_name,@v_user_sort_order, @v_ship_frozen
										  ,@v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5, @v_segment6, @v_segment7, @v_segment8, @v_segment9, @v_segment10, @v_segment11, @v_segment12
										  , @v_segment13, @v_segment14
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @v_to_mail = @v_mail_receiver+'@lgensol.com'

				IF @v_receiver_temp = '' 
				BEGIN
					SET @v_receiver_temp = @v_to_mail
				END

				IF @v_receiver_temp != @v_to_mail
				BEGIN
					IF LEN(@v_head_cont) > 0
					BEGIN
						SET @TABLE_BODY = '';
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
														.tdbg {background:#f5f5f5;}
													</style>
													</head>
													<body>' +'</br>'+
															'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
															'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
														'<table style=''border-top:2px solid #c8294b; width:1800px;''>
														<thead>' + ISNULL(@v_head_cont,'') +'</thead>
														<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
														</table>
														</br>
														</div>
													</body>
											</html>';
						--//메일 발송
						
						EXEC SCM_ADM_MAIL_SEND
						'jooyong026@lgespartner.com'--개발용
							--@v_receiver_temp
							, @v_mail_title
							, @TABLE_BODY
							, 'Y'
						;
						--SET @v_body_contents = ''
						SET @v_body_cont = ''

						--MAIL 발송 LOG 저장
						EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
							'MAIL'
							, 0
							, @v_division_id
							, @v_company_id
							, @v_from_site_description
							, @v_item_id
							, @v_nick_name
							, ''
							, ''
							, ''
							, ''
							, ''
							, '' --p_send_pgm
							, @v_receiver_temp
						;
						--//END : 메일 발송
						
						SET @v_receiver_temp = @v_to_mail
						
					END		--//END : IF LEN(@v_head_cont) > 0
				END			--//END : IF @v_receiver_temp != @v_to_mail

				SET @v_body_cont = @v_body_cont+ '<tr>';

				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_company_id,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_to_site_description,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_measure_name,''), CHAR(10),' ') + '</td>'
				
				SET @v_tmp_ship_frozen = @v_ship_frozen;
				
				--//1
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment1 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment1 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//2
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment2 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment2 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//3
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment3 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment3 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//4
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment4 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment4 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//5
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment5 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment5 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END

				--//6
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment6 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment6 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//7
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment7 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment7 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//8
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment8 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment8 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//9
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment9 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment9 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//10
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment10 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment10 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END

				--//11
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment11 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment11 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//12
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment12 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment12 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//13
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment13 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment13 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				--//14
				SET @v_tmp_ship_frozen = @v_tmp_ship_frozen - 1;
				IF @v_tmp_ship_frozen > 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right'' class = ''tdbg''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment14 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				ELSE
				BEGIN
					SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment14 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
				END
				
				SET @v_body_cont = @v_body_cont+ '</tr>'

				FETCH NEXT FROM CUR_SEND INTO @v_mail_receiver, @v_division_id, @v_company_id, @v_from_site_description, @v_to_site_description, @v_item_id, @v_nick_name, @v_measure_name, @v_user_sort_order, @v_ship_frozen
											,@v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5, @v_segment6, @v_segment7, @v_segment8, @v_segment9, @v_segment10, @v_segment11, @v_segment12
										  , @v_segment13, @v_segment14
			END			--//END : WHILE @@FETCH_STATUS = 0
			
			CLOSE CUR_SEND;
			DEALLOCATE CUR_SEND;

			BEGIN
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
											.tdbg {background:#f5f5f5;}
										</style>
										</head>
										<body>' +'</br>'+
												'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
												'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
											'<table style=''border-top:2px solid #c8294b; width:1800px;''>
											<thead>' + ISNULL(@v_head_cont,'') +'</thead>
											<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
											</table>
											</br>
											</div>
										</body>
								</html>'
				
					-- 메일 발송
					
					EXEC SCM_ADM_MAIL_SEND
						'jooyong026@lgespartner.com'--개발용
						--@v_to_mail
						, @v_mail_title
						, @TABLE_BODY
						, 'Y'
					;
					--SET @v_body_contents = ''
					SET @v_body_cont = '';

					--MAIL 발송 LOG 저장
					EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
						'MAIL'
						, 0
						, @v_division_id
						, @v_company_id
						, @v_from_site_description
						, @v_item_id
						, @v_nick_name
						, ''
						, ''
						, ''
						, ''
						, ''
						, '' --p_send_pgm
						, @v_receiver_temp
					;
					--//END : 메일 발송
					
				END
			END
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
				INSERT INTO scm_sys_log_batch 
				(
					program_name
					, log_type
					, log_count
					, log_message
					, description
					, event_date
					, creation_date
					, created_by
					, last_update_date
					, last_updated_by
				)
				VALUES 
				(
					ERROR_PROCEDURE()
					, 'ERROR'
					, NULL
					, ERROR_MESSAGE()
					, NULL
					, SYSDATETIME()
					, SYSDATETIME()
					, ERROR_PROCEDURE()
					, SYSDATETIME()
					, ERROR_PROCEDURE()
				);
				
				--IF @@TRANCOUNT > 0
				--	COMMIT WORK;
			END;
			BEGIN
				DECLARE @v_error_message NVARCHAR(1000);
				SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);

				--MAIL 발송 LOG 저장
				EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
					'ERROR'
				    , 0
					, 'MAIN ERROR' 
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, @v_error_message --p_send_pgm
					, ''
				;
				--IF @@TRANCOUNT > 0
				--	COMMIT WORK;
			END
			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
			
			set @p_log_messge = @v_error_message;
			return -1;
		END CATCH;
		SET @v_data_list_cnt = @v_data_list_cnt - 1;

	END				--//END : WHILE @v_data_list_cnt > 0 

	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TMP_MAIL_SEND_LIST') IS NOT NULL
		DROP TABLE #TMP_MAIL_SEND_LIST 
	IF OBJECT_ID('tempdb..#TMP_MAIL_DATA') IS NOT NULL
		DROP TABLE #TMP_MAIL_DATA 
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0021_1') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SSP0021_1 
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects with(NOLOCK) WHERE name = '#TMP_Tbl_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM')
			   DROP TABLE dbo.#TMP_Tbl_SSP_MAIL_SEND_SHIP_PLAN_INTER_COM;
	
	return 1;
END
