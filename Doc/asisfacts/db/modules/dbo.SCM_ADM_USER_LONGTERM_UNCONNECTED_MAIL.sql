
/*
 * Program ID   : SCM_ADM_USER_LONGTERM_UNCONNECTED_MAIL
 * Description  : 장기 미접속 메일 전송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.02.11   khj79          [C20200117-000310]권한 고정, 장기 미접속자 메일링 기능 - 장기 미접속(60일,83일) 안내 메일 전송
 * 2023.02.24   FP Prj.        [E20230216-000381]로직정리
 * 2024.07.25   FP Prj.        [E20240722-000131]장기미접속 권환회수 기간 연장 요청의 건 : 3개월 -> 1년
 */


CREATE PROCEDURE [dbo].[SCM_ADM_USER_LONGTERM_UNCONNECTED_MAIL]
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- 변수 설정
	DECLARE @v_user_id				NVARCHAR(30);   -- 사용자ID
	DECLARE @v_unconnected_term		NVARCHAR(10);   -- 미접속기간
	DECLARE @v_mail_receiver		NVARCHAR(30);   -- 메일 수신자
	DECLARE @v_mail_subject			NVARCHAR(200);  -- 메일 제목
	DECLARE @v_mail_body			NVARCHAR(4000); -- 메일 내용
	DECLARE @v_mail_content1		NVARCHAR(100);  -- 메일 본문 내용1
	DECLARE @v_mail_content2		NVARCHAR(100);  -- 메일 본문 내용2
	DECLARE @v_mail_content3		NVARCHAR(100);  -- 메일 본문 내용3
	DECLARE @v_mail_content4		NVARCHAR(100);  -- 메일 본문 내용4
	DECLARE @v_mail_send_cnt		INT = 1;        -- 메일 전송 카운트
	declare @v_prorile_name			nvarchar(50);

	-- LOG 용 변수 설정
    DECLARE @v_program_name			NVARCHAR(150) = 'SCM_ADM_USER_LONGTERM_UNCONNECTED_MAIL';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(max);
    DECLARE @d_event_date			DATETIME;

	--  메일 내용 설정
	SET @v_mail_subject				= N'GSCM 시스템 장기 미접속으로 인한 권한 회수 안내 ';
	SET @v_mail_content1			= N'업무혁신';
	SET @v_mail_content2			= N'귀하의 계정';
	--SET @v_mail_content3			= N'일 미접속으로 인해서 잠길 예정입니다.';
	SET @v_mail_content3			= N'일 미접속으로 권한이 회수됩니다.'; -- [E20240722-000131]장기미접속 권환회수 기간 연장 요청의 건 : 365일 기준으로 5일 전, 당일 미접속시
	SET @v_mail_content4			= N'GSCM 시스템에 접속하여 로그인 해주시기 바랍니다.';

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type				= 'START';
		SET @v_log_message			= '########## Start of procedure ##########';
		SET @v_description			= '';
		SET @d_event_date			= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 장기 미 접속자 CURSOR 생성
		-- 60일, 83일 미 접속자 조회
		-- Guest ,  PermanentYN = 'Y' 인 사용자 제외
		DECLARE CUR_UNCONNECTED CURSOR FOR
		 SELECT U.UserID
		      , DATEDIFF(dd, U.LastLoginDateTime , GETDATE()) as UnConnectedTerm
		   FROM TB_FX_User U WITH(NOLOCK)
          WHERE U.UseYN = 'Y'
            AND U.UserID != 'Guest'
	        AND U.PermanentYN != 'Y'
		    --AND DATEDIFF(dd, U.LastLoginDateTime , GETDATE() )  IN (85, 90)
			AND DATEDIFF(dd, U.LastLoginDateTime , GETDATE() )  IN (360, 365) -- [E20240722-000131]장기미접속 권환회수 기간 연장 요청의 건 : 365일 기준으로 5일 전, 당일 미접속시
			--AND U.LastLoginDateTime <= DATEADD(MONTH, -3, GETDATE()) 
	    ;

		-- CURSOR OPEN
		OPEN CUR_UNCONNECTED;
			FETCH NEXT FROM CUR_UNCONNECTED
			INTO @v_user_id , @v_unconnected_term

			WHILE (@@FETCH_STATUS = 0)  
			BEGIN
					
				--SET @v_mail_receiver = 'khj79' + '@lgensol.com'; -- 테스트 사용자
				SET @v_mail_receiver = @v_user_id + '@lgensol.com'; -- 실제 사용자
				--SET @v_mail_receiver = 'crjung@lgespartner.com'; -- 테스트


				SET @v_mail_body = ''
				SET @v_mail_body = N'
					<html>
						<head>
						<title>Untitled Document</title>
						<meta charset="UTF-8">
						<style>
							.textdecoration1 {PADDING-BOTTOM: 0cm; PADDING-TOP: 0cm; PADDING-LEFT: 0cm; PADDING-RIGHT: 0cm }
							.textdecoration2 { FONT-FAMILY: LG스마트체 Regular; font-size : 12pt;}
						</style>
						</head>
						<body style="FONT-SIZE: 10pt; FONT-FAMILY: LG스마트체 Regular">'+
								'<div>'+
								'<table style="WIDTH: 495pt; BACKGROUND: #c6c6c4" cellSpacing=1 cellPadding=0 width=660 border=0>' +
									'<tbody>'+
										'<tr style="HEIGHT: 35.25pt">'+
											'<td style="BORDER-TOP: medium none; HEIGHT: 35.25pt; BORDER-RIGHT: medium none; BACKGROUND: #f0f0f0; BORDER-BOTTOM: #c8284a 2.25pt solid; PADDING-BOTTOM: 0cm; PADDING-TOP: 9pt; PADDING-LEFT: 10.5pt; BORDER-LEFT: medium none; PADDING-RIGHT: 0cm" vAlign=top>'+
												'<p ><b><span style="FONT-SIZE: 10.5pt">'+ @v_mail_content1 + '<span lang=EN-US> Portal</span></span></b></p>'+
											'</td>'+
										'</tr>'+
										'<tr>'+
											'<td style="BACKGROUND: white; PADDING-BOTTOM: 0cm; PADDING-TOP: 0cm; PADDING-LEFT: 0cm; PADDING-RIGHT: 0cm">'+
												'<div align=center>'+
													'<table  style="WIDTH: 436.5pt" cellSpacing=0 cellPadding=0 width=582 border=0>'+
														'<tbody>'+
															'<tr style="HEIGHT: 22.5pt">'+
																'<td style="HEIGHT: 22.5pt; PADDING-BOTTOM: 0cm; PADDING-TOP: 0cm; PADDING-LEFT: 0cm; PADDING-RIGHT: 0cm">'+
																	'<p>&nbsp;</p>'+
																'</td>'+
															'</tr>'+
															'<tr>'+
																'<td class="textdecoration1">'+
																	'<p ><strong><span lang=EN-US style="FONT-FAMILY: 굴림; COLOR: #249697"></span></strong>'+
																	'<strong><span style="FONT-FAMILY: 굴림; COLOR: #249697">'+ @v_mail_subject + '</span></strong></p>'+
																'</td>'+
															'</tr>'+
															'<tr>'+
																'<td><p>&nbsp;</p></td>'+
															'</tr>'+
															'<tr>'+
																'<td class="textdecoration1">'+
																	'<table  style="WIDTH: 100%" cellSpacing=0 cellPadding=0 width="100%" border=0>'+
																		'<tbody>'+
																			'<tr>'+
																				'<td class="textdecoration1">'+
																					'<p class="textdecoration1">' + @v_mail_content2 + ' (' + ISNULL(@v_user_id, '') + ')</p>' +
																				'</td>'+
																			'</tr>'+
																			'<tr>'+
																				'<td><p>&nbsp;</p></td>'+
																			'</tr>'+
																			'<tr>'+
																				'<td class="textdecoration1">'+
																					'<p class="textdecoration1">' + ISNULL(@v_unconnected_term, '') + @v_mail_content3 + '</p>' +
																				'</td>'+
																			'</tr>'+
																			'<tr>'+
																				'<td><p><span lang=EN-US></span>&nbsp;</p></td>'+
																			'</tr>'+
																			'<tr>'+
																				'<td class="textdecoration1">'+
																					'<p class="textdecoration2">' + @v_mail_content4 + '</p>' +
																				'</td>'+
																			'</tr>'+
																			'<tr>'+
																				'<td><p>&nbsp;</p></td>'+
																			'</tr>'+
																		'</tbody>'+
																	'</table>'+
																'</td>'+
															'</tr>'+
														'</tbody>'+
													'</table>'+
													'</div>'+
												'</td>'+
											'</tr>'+
										'</tbody>'+
									'</table>'+
								'</body></html>';

				-- print 주석처리
				PRINT @v_user_id + ', ' +  @v_unconnected_term + ',   ' + @v_mail_receiver
				-- print @v_mail_body

				IF @v_mail_send_cnt % 10 = 0		--10건 전송시마다
				BEGIN
					WAITFOR DELAY '00:00:05'		-- 5초 딜레이
					PRINT '메일 전송 대기 중 입니다.';
				END

				-- 메일 전송
				SELECT @v_prorile_name = IIF(db_name() = 'LGCE_SCMDEV', 'GSCM_MAIL_PROD', 'GSCM_MAIL_TEST');

				EXEC msdb.dbo.sp_send_dbmail
						@profile_name		= @v_prorile_name
					, @recipients		= @v_mail_receiver
					, @subject			= @v_mail_subject
					, @body				= @v_mail_body
					, @body_format		= 'html';

				-- 메일 전송 카운트 증가
				SET @v_mail_send_cnt = @v_mail_send_cnt + 1;
					
				-- next fatch
				FETCH NEXT FROM CUR_UNCONNECTED
				INTO @v_user_id, @v_unconnected_term
			END

			
		-- CURSOR 종료	
		CLOSE CUR_UNCONNECTED;
		DEALLOCATE CUR_UNCONNECTED;
		
		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  

	END TRY

	-- CATCH 실행
	BEGIN CATCH
		CLOSE CUR_UNCONNECTED;
		DEALLOCATE CUR_UNCONNECTED;

		BEGIN

			SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());

			INSERT INTO scm_sys_log_batch 
			     ( program_name
				 , log_type
				 , log_count
				 , log_message
				 , description
				 , event_date
				 , creation_date
				 , created_by
				 , last_update_date
	             , last_updated_by)
			VALUES (ERROR_PROCEDURE()
				 , 'ERROR'
				 , NULL
				 , ERROR_MESSAGE()
				 , @v_description
				 , SYSDATETIME()
				 , SYSDATETIME()
				 , ERROR_PROCEDURE()
				 , SYSDATETIME()
				 , ERROR_PROCEDURE());

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END
