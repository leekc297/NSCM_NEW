

/*
 * Program ID   : PR_SSP_MAIL_SEND_BATCH_40
 * Description  : SSP 40 Mail 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/05   mcthej		   Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 ex)
EXEC PR_SSP_MAIL_SEND_BATCH40
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SEND_BATCH_40]

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_data_cnt			NVARCHAR(8);
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_MAIL_SEND_BATCH40';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_mail_receiver			NVARCHAR(100);
	DECLARE @v_division_id				NVARCHAR(100);
	DECLARE @v_from_site_description    NVARCHAR(100);
	DECLARE @v_item_id					NVARCHAR(100);
	DECLARE @v_nick_name				NVARCHAR(100);
	DECLARE @v_measure_name				NVARCHAR(100);
	DECLARE @v_user_sort_order			NVARCHAR(100);
	DECLARE @v_segment1					NVARCHAR(100);
	DECLARE @v_segment2					NVARCHAR(100);
	DECLARE @v_segment3					NVARCHAR(100);
	DECLARE @v_segment4					NVARCHAR(100);
	DECLARE @v_segment5					NVARCHAR(100);
	DECLARE @v_cnt						INT;

	SET @v_data_cnt =0;
	SET @v_d_day = 0;
	SET @v_d_minus_day = 0;
	SET @v_from_yyyymmdd = '';
	SET @v_to_yyyymmdd   = '';
	SET @v_cnt = 0;

	SELECT @v_from_yyyymmdd = DBO.FN_DATE_TO_CHAR (DBO.FN_CHAR_TO_DATE(MAX(YYYYMMDD))  - 4)
		  ,@v_to_yyyymmdd = MAX(YYYYMMDD)
	FROM SSP_ANL_DAILY_MAIL_SEND_V;
	--NULL, NULL

	print @v_from_yyyymmdd
	print @v_to_yyyymmdd
   /********************************************************************************
	* 임시테이블만들기
	********************************************************************************/	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0015_1') IS NOT NULL
		   DROP TABLE #TblDynamicPivot_SSP0015_1 
    
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblSSPMailSendBatch40%')
		   DROP TABLE #TblSSPMailSendBatch40
 
	CREATE TABLE #TblSSPMailSendBatch40 (
			 MAIL_RECEIVER			NVARCHAR(100)
			,division_id			NVARCHAR(100) 
		   , from_site_description	 NVARCHAR(100)
		   , item_id				NVARCHAR(100)
		   , nick_name			NVARCHAR(100)
		   , measure_name        NVARCHAR(100)
		   , user_sort_order_no INT
		   , segment1			NVARCHAR(100) -- 현재일
		   , segment2			NVARCHAR(100) -- 현재일 + 1
		   , segment3			NVARCHAR(100) -- 현재일 + 2
		   , segment4			NVARCHAR(100) -- 현재일 + 3
		   , segment5			NVARCHAR(100) -- 현재일 + 4
	);

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	SELECT m.division_id	                          
 		  ,m.plan_start_yyyymmdd                               
 		  ,m.from_site                            
 		  ,m.item_id                              
 		  ,m.nick_name                            
 		  ,m.measure                              
 		  ,m.measure_name                         
 		  ,m.user_sort_order_no                
 		  ,m.yyyymmdd as yyyymmdd        
 		  ,convert(int,isnull(n.qty,0)) qty
		  ,MAIL_RECEIVER  
		INTO #TblDynamicPivot_SSP0015_1
 	FROM (                                        
 		SELECT                                    
 			  c.division_id			              
 			 ,c.plan_start_yyyymmdd                        
 			 ,c.from_site			              
 			 ,c.item_id			                  
 			 ,a.column_name	AS measure	          
 			 ,a.COLUMN_LABEL_NAME AS measure_name 
 			 ,c.yyyymmdd                          
 			 ,c.nick_name	                      
 			 ,a.sort_order_no AS user_sort_order_no	 
			 ,C.MAIL_RECEIVER   
 		FROM scm_mst_sheet_measure a with(nolock) 
 			, ( SELECT                                                              
 					   p.DIVISION_ID 			                                    
 					  ,p.PLAN_START_YYYYMMDD	                                              
 					  ,p.FROM_SITE				                                    
 					  ,p.ITEM_ID				                                    
 					  ,p.YYYYMMDD   	                                                
 					  ,dbo.fn_get_item_nickname( p.division_id, p.item_id ) AS nick_name  
					  , A.MAIL_RECEIVER    
 				FROM SSP_ANL_SHIP_PLAN_40 P with(nolock)  
				INNER JOIN (SELECT distinct division_id
				                 ,plan_start_yyyymmdd
								 ,from_site
								 ,item_id
								 ,YYYYMMDD
								 ,MAIL_RECEIVER
							FROM SSP_ANL_DAILY_MAIL_SEND_V A with(nolock)) a  ON P.DIVISION_ID = A.DIVISION_ID AND P.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD AND P.FROM_SITE = A.FROM_SITE
				                                     AND P.ITEM_ID = A.ITEM_ID 
 				WHERE 1=1 
				  AND P.YYYYMMDD BETWEEN @v_from_yyyymmdd AND A.YYYYMMDD
 				GROUP BY   p.DIVISION_ID , p.PLAN_START_YYYYMMDD, p.PLAN_TYPE, p.FROM_SITE, p.ITEM_ID, p.YYYYMMDD,A.MAIL_RECEIVER           
 			  ) c                                                              
                                                                                
 			WHERE 1=1                                                          
 			  AND a.program_id       =  'SSP0015'
 			  AND a.sheet_name       =  'Shipment PSI(Small)'
 			  AND a.valid_yn		 =	'Y' 
 		) m LEFT OUTER JOIN                                                    
 		 (SELECT DIVISION_ID                                                 
 				,PLAN_START_YYYYMMDD                                         
 				,PLAN_TYPE                                                   
 				,FROM_SITE	                                               
 				,ITEM_ID                                                     
 				,YYYYMMDD                                                    
 				,measure		                                               
 				,sum(qty) as qty
		  FROM(
					SELECT p.DIVISION_ID                                                 
 						,p.PLAN_START_YYYYMMDD                                         
 						,p.PLAN_TYPE                                                   
 						,p.FROM_SITE	                                               
 						,p.ITEM_ID                                                     
 						,p.YYYYMMDD                                                    
 						,p.measure		                                               
 						,p.qty                                            
 					FROM SSP_ANL_SHIP_PLAN_40 P with(nolock)    
					INNER JOIN (SELECT distinct division_id
									 ,plan_start_yyyymmdd
									 ,from_site
									 ,item_id
									 ,YYYYMMDD
								FROM SSP_ANL_DAILY_MAIL_SEND_V A with(nolock)) a  ON P.DIVISION_ID = A.DIVISION_ID AND P.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD AND P.FROM_SITE = A.FROM_SITE
															 AND P.ITEM_ID = A.ITEM_ID                          
 					WHERE 1=1 
						AND P.YYYYMMDD BETWEEN @v_from_yyyymmdd AND A.YYYYMMDD
		 ) A
 		 GROUP BY  A.division_id , A.plan_start_yyyymmdd, A.plan_type, A.from_site, A.item_id, A.yyyymmdd, A.measure                         
 		) n ON  m.division_id         = n.division_id          
 			AND m.plan_start_yyyymmdd = n.plan_start_yyyymmdd          
 			AND m.from_site           = n.from_site            
 			AND m.item_id             = n.item_id              
 			AND m.yyyymmdd            = n.yyyymmdd             
 			AND m.measure             = n.measure              
 		WHERE 1=1

	DECLARE @chk INT;
	SET @chk = 0

	SELECT @chk = COUNT(*)
	FROM #TblDynamicPivot_SSP0015_1

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
	--FROM #TblDynamicPivot_SSP0015_1
	--RETURN;	
	-----------------------------------------------------------
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

		--PRINT LEN(@mQuery)
		--RETURN;

		IF( LEN(@mQuery)>0)
			SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+'      SELECT MAIL_RECEIVER ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,division_id ' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,isnull(dbo.fn_get_scm_site_description(division_id, from_site ),''-'') AS from_site_description		' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,item_id	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,case when nick_name is null or nick_name = '''' then ''-'' else nick_name end nick_name	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,measure_name	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,user_sort_order_no	' +CHAR(10);
			SET @mEXEC = @mEXEC+' 			,'+@mQuery	 +CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0015_1 ' +CHAR(10);
			SET @mEXEC = @mEXEC+'       PIVOT ( ' +CHAR(10);
			SET @mEXEC = @mEXEC+'               SUM(qty) FOR  yyyymmdd IN ('+ @mQuery +') ' +CHAR(10);
			SET @mEXEC = @mEXEC+'             ) AS A'   +CHAR(10);
			SET @mEXEC = @mEXEC+'	   ORDER BY MAIL_RECEIVER, division_id, from_site,item_id, user_sort_order_no' +CHAR(10);
	END

	INSERT INTO #TblSSPMailSendBatch40
	EXEC (@mEXEC);
	/********************************************************************************
	* HEAD CONT 
	********************************************************************************/		
	SET @v_head_cont = '';
	SET @v_head_cont = @v_head_cont+ '<tr>'

	SET @v_head_cont = @v_head_cont+ '<th>' + 'Div' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'From Site' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Model' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Nick Name' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'Measure' + '</th>'
	
	SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_from_yyyymmdd) ), 23 )   + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_from_yyyymmdd) + 1 ), 23 )   + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_from_yyyymmdd) + 2 ), 23 )   + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_from_yyyymmdd) + 3 ), 23 )   + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_from_yyyymmdd) + 4 ), 23 )   + '</th>'
	
	SET @v_head_cont = @v_head_cont+ '</tr>'

	SET @v_mail_title = '[SSP_Early Warning] Shipping Schedule Negative value';
	SET @v_body_contents = 'Please refer to below table and check the Negative stock value of shipping schedule.
							You can check further information from below route.
							Thanks in advance.
							Best regards.
							
							';


	--select *
	--from #TblSSPMailSendBatch
	--return

	DECLARE CUR_SEND CURSOR FOR
	SELECT *
	FROM #TblSSPMailSendBatch40
	ORDER BY MAIL_RECEIVER, division_id, from_site_description, item_id, user_sort_order_no

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		SET @v_body_cont = ''			
		SET @v_receiver_temp = ''

		OPEN CUR_SEND;
		FETCH NEXT FROM CUR_SEND INTO @v_mail_receiver, @v_division_id, @v_from_site_description, @v_item_id, @v_nick_name, @v_measure_name,@v_user_sort_order
			                , @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5

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
														'<table style=''border-top:2px solid #c8294b; width:1000px;''>
														<thead>' + ISNULL(@v_head_cont,'') +'</thead>
														<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
														</div>
													</body>
											</html>'
							
								 --메일 발송
								EXEC SCM_ADM_MAIL_SEND
											'jooyong026@lgespartner.com'--개발용
											--@v_receiver_temp
										,@v_mail_title
										,@TABLE_BODY
										,'Y'
										;
								--SET @v_body_contents = ''
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
												,@v_receiver_temp;
								SET @v_receiver_temp = @v_to_mail
								SET @v_cnt = 0;
							END
					END
							
				SET @v_body_cont = @v_body_cont+ '<tr>'

				IF @v_cnt = 0
					BEGIN
						SET @v_body_cont = @v_body_cont+ '<td rowspan=''9''>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>'
						SET @v_body_cont = @v_body_cont+ '<td rowspan=''9''>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '</td>'
						SET @v_body_cont = @v_body_cont+ '<td rowspan=''9''>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '</td>'
						SET @v_body_cont = @v_body_cont+ '<td rowspan=''9''>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '</td>'
						
					END
				SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_measure_name,''), CHAR(10),' ') + '</td>'

				SET @v_cnt = @v_cnt + 1;
				
				IF @v_cnt = 9
					BEGIN
						SET @v_cnt = 0
					END
				
				

				IF @v_measure_name = 'BALANCE' and sign(@v_segment1) = -1
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment1 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' END
				ELSE 
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment1 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' END

				IF @v_measure_name = 'BALANCE' and sign(@v_segment2) = -1
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment2 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' END
				ELSE 
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment2 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' END

				IF @v_measure_name = 'BALANCE' and sign(@v_segment3) = -1
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment3 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' END
				ELSE 
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment3 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' END

				IF @v_measure_name = 'BALANCE' and sign(@v_segment4) = -1
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment4 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' END
				ELSE 
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment4 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' END

				IF @v_measure_name = 'BALANCE' and sign(@v_segment5) = -1
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment5 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' END
				ELSE 
					BEGIN SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment5 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' END


				--SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(@v_segment2,''), CHAR(10),' ') + '</td>'
				--SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(@v_segment3,''), CHAR(10),' ') + '</td>'
				--SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(@v_segment4,''), CHAR(10),' ') + '</td>'
				--SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(@v_segment5,''), CHAR(10),' ') + '</td>'
				SET @v_body_cont = @v_body_cont+ '</tr>'

				FETCH NEXT FROM CUR_SEND INTO @v_mail_receiver, @v_division_id, @v_from_site_description, @v_item_id, @v_nick_name, @v_measure_name, @v_user_sort_order
							, @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5
				
			END
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
										</style>
										</head>
										<body>' +'</br>'+
												'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
												'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
											'<table style=''border-top:2px solid #c8294b; width:1000px;''>
											<thead>' + ISNULL(@v_head_cont,'') +'</thead>
											<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
											</table>
											</div>
										</body>
								</html>'
				
					-- 메일 발송
					EXEC SCM_ADM_MAIL_SEND
								'jooyong026@lgespartner.com'--개발용
								--@v_to_mail
							,@v_mail_title
							,@TABLE_BODY
							,'Y'
							;
					--SET @v_body_contents = ''
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
														,@v_receiver_temp;
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
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0015_1') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SSP0015_1 
	IF OBJECT_ID('tempdb..#TblSSPMailSendBatch40') IS NOT NULL
		DROP TABLE #TblSSPMailSendBatch40
END
