/*
 * Program ID   : SCM_ADM_MAIL_SEND_DATA
 * Description  : MAIL 발송 BATCH - UI에서 수신자가 등록되어 있는 경우
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/05   ygkim                   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/10   ygkim                   Mail 내용이 있을 경우에만 발송되도록 수정
 * 2018/10/11   ygkim                   5명 이상일 경우 5명씩 나눠서 보내는걸로 수정
 * 2023/11/24   chaan           V1.1.1  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2        - SQL 결과 컬럼이 10개로 제한 -> 컬럼 갯수에 상관없이 유연하게 대응하도록 변경
 *                                                                                                              - 테스트모드 추가 (메일 개발자에게만 발송)
 * 2023/12/14   chaan           V1.1.2  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2        - SQL 쿼리 결과셋이 n 개 가능하도록 변경

 ex) exec SCM_ADM_MAIL_SEND_DATA 8
 */
CREATE PROCEDURE [dbo].[SCM_ADM_MAIL_SEND_DATA]
	@p_category_id				int
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

    DECLARE @v_test_mode        NVARCHAR(1)     = 'F';
    --DECLARE @v_test_mode        NVARCHAR(1)     = 'T';

    --개발자 이메일(전송 테스트용)
	DECLARE @v_dev_email        NVARCHAR(100)   = 'kimcd@lgespartner.com';

	--DECLARE @p_category_id			int     = '26'; --BOM 메일링(81)
	--DECLARE @p_category_id			int     = '90'; --Long-term stock Report(20)
	--DECLARE @p_category_id			int     = '93'; --Model Code Master(81)

    

    DECLARE @v_sql_seperator            NVARCHAR(1)         = '†';  --SQL n개 처리를 위한 쿼리구문 구분자


	DECLARE @v_table_contents	        NVARCHAR(MAX)       = N'';
	DECLARE @v_curr_table_contents	    NVARCHAR(MAX)       = N'';
	DECLARE @v_mail_text                NVARCHAR(MAX)       = N'';

	DECLARE @v_segment1                 NVARCHAR(100)       = N'';
	DECLARE @v_segment2                 NVARCHAR(100)       = N'';
	DECLARE @v_segment3                 NVARCHAR(100)       = N'';
	DECLARE @v_segment4                 NVARCHAR(100)       = N'';
	DECLARE @v_segment5                 NVARCHAR(100)       = N'';
	DECLARE @v_segment6                 NVARCHAR(100)       = N'';
	DECLARE @v_segment7                 NVARCHAR(100)       = N'';
	DECLARE @v_segment8                 NVARCHAR(100)       = N'';
	DECLARE @v_segment9                 NVARCHAR(100)       = N'';
	DECLARE @v_segment10                NVARCHAR(100)       = N'';
	DECLARE @v_column1                  NVARCHAR(100)       = N'';
	DECLARE @v_column2                  NVARCHAR(100)       = N'';
	DECLARE @v_column3                  NVARCHAR(100)       = N'';
	DECLARE @v_column4                  NVARCHAR(100)       = N'';
	DECLARE @v_column5                  NVARCHAR(100)       = N'';
	DECLARE @v_column6                  NVARCHAR(100)       = N'';
	DECLARE @v_column7                  NVARCHAR(100)       = N'';
	DECLARE @v_column8                  NVARCHAR(100)       = N'';
	DECLARE @v_column9                  NVARCHAR(100)       = N'';
	DECLARE @v_column10                 NVARCHAR(100)       = N'';
	DECLARE @v_sql_yn				    NVARCHAR(1);

	DECLARE @v_sql				        NVARCHAR(MAX)       = N'';
	DECLARE @v_curr_sql				    NVARCHAR(MAX)       = N'';
	DECLARE @v_body_title               NVARCHAR(MAX)       = N'';
	DECLARE @v_user_id                  NVARCHAR(40)        = N'';
	DECLARE @v_user_name                NVARCHAR(40)        = N'';
	DECLARE @v_mobile_phone             NVARCHAR(50)        = N'';
	DECLARE @v_language_code            NVARCHAR(50)        = N'';
	DECLARE @v_email_addr               NVARCHAR(100)       = N'';
	DECLARE @v_mail_receiver_list       NVARCHAR(4000)      = N'';
	DECLARE @v_mail_title               NVARCHAR(100)       = N'';
	DECLARE @v_send_cnt				    INT                 = 0;
	DECLARE @v_user_cnt				    INT                 = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name             NVARCHAR(150) = 'SCM_ADM_MAIL_SEND_DATA';
    DECLARE @v_log_type                 NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count                INTEGER = 0;
    DECLARE @v_log_message              NVARCHAR(1000);
    DECLARE @v_description              NVARCHAR(500);
    DECLARE @d_event_date               DATETIME;

	SELECT	@v_user_cnt = count(USER_ID)
	FROM	SCM_ADM_RECIPIENT_ASSIGN
	WHERE   1=1
        AND CATEGORY_ID = @p_category_id

--TESTING : OK
	--select * From SCM_ADM_RECIPIENT_ASSIGN	WHERE  CATEGORY_ID = @p_category_id;return;
	--select * From SCM_ADM_RECIPIENT_LIST	WHERE  CATEGORY_ID = @p_category_id;return;
	--select * From SCM_ADM_RECIPIENT_MESSAGE	WHERE  CATEGORY_ID = @p_category_id;return;

	SELECT	  @v_mail_title		= MAIL_TITLE
			, @v_body_title		= REPLACE(MESSAGE_CONTENT,CHAR(10),'<br><br>')
	FROM	SCM_ADM_RECIPIENT_MESSAGE
	WHERE   1=1
        AND CATEGORY_ID = @p_category_id;

    --PRINT CONCAT('@v_mail_title : ', @v_mail_title);
    --PRINT CONCAT('@v_body_title : ', @v_body_title);
--return;



	SELECT	@v_sql = SQL_LONG_TEXT
	FROM	SCM_ADM_RECIPIENT_LIST
	WHERE   1=1
        AND CATEGORY_ID = @p_category_id

--TESTING : OK
--exec debug_log @v_sql, 'T';return;--chaan

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type			= 'START';
		SET @v_log_message		= '########## Start of procedure ##########';
		SET @v_description		= @p_category_id;
		SET @d_event_date		= SYSDATETIME();

        --IF @v_test_mode <> 'T'
        --BEGIN
		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --END

        PRINT ('GET TABLE DATAS - BEGIN ---------------------------------------------------------------------------------');
        BEGIN
            IF CURSOR_STATUS('global','CUR_SCM_ADM_MAIL_SEND_DATA') >= -1
            BEGIN
                IF CURSOR_STATUS('global','CUR_SCM_ADM_MAIL_SEND_DATA') > -1
                BEGIN
                    CLOSE CUR_SCM_ADM_MAIL_SEND_DATA
                END

                DEALLOCATE CUR_SCM_ADM_MAIL_SEND_DATA
            END

		    DECLARE CUR_SCM_ADM_MAIL_SEND_DATA CURSOR FOR
            SELECT  TOKEN
            FROM    dbo.String_Split(@v_sql, @v_sql_seperator);
				
		    OPEN CUR_SCM_ADM_MAIL_SEND_DATA;

		    FETCH NEXT FROM CUR_SCM_ADM_MAIL_SEND_DATA INTO @v_curr_sql

		    WHILE @@FETCH_STATUS = 0
		    BEGIN
--TESTING : OK
--exec debug_log @v_curr_sql, 'T';return;--chaan
                PRINT CONCAT('@v_curr_sql : ', @v_curr_sql);
--EXEC @v_curr_sql;return;

                SET @v_curr_sql = ISNULL(@v_curr_sql, '');

		        SET @v_curr_table_contents	= ''

                EXEC UP_FX_GetHtmlBySQL @v_curr_sql, 'COLUMN', 'SEGMENT', @v_curr_table_contents OUTPUT;--chaan

                SET @v_table_contents       = ISNULL(@v_table_contents, '');
                SET @v_curr_table_contents  = ISNULL(@v_curr_table_contents, '');

                PRINT CONCAT('@v_curr_table_contents : ', @v_curr_table_contents);

                --IF (@v_table_contents <> '') --테이블 결과셋이 n개이면 테이블 구분표시
                --BEGIN
                --    SET @v_table_contents   = @v_table_contents + 
                --                              '<hr style="height:1px;border:none;color:#333;background-color:#333;">' +
                --                              @v_curr_table_contents;
                --END
                --ELSE
                --BEGIN
                    SET @v_table_contents   = @v_table_contents + @v_curr_table_contents;
                --END

                PRINT CONCAT('@v_table_contents : ' ,@v_table_contents);--return;

			    FETCH NEXT FROM CUR_SCM_ADM_MAIL_SEND_DATA INTO @v_curr_sql
            END    

		    CLOSE CUR_SCM_ADM_MAIL_SEND_DATA;

		    DEALLOCATE CUR_SCM_ADM_MAIL_SEND_DATA;
        END
        PRINT ('GET TABLE DATAS - END ---------------------------------------------------------------------------------');

        SET @v_table_contents = ISNULL(@v_table_contents, '');
        
        -- 대상 데이터가 있을때만 메일 발송
		IF LEN(@v_table_contents) > 0--chaan
		BEGIN
            PRINT ('MAKE MAIL TEXT - BEGIN ---------------------------------------------------------------------------------');
            BEGIN
			    SET @v_mail_text = ''
			    SET @v_mail_text = ' <html>
								    <head>
								    <title>Untitled Document</title>
								    <style>
   										    * {margin:0;padding:0;}
   										    body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:11px;line-height:1.8;color:#333333;}
   										    table {border-collapse:collapse;width:100%;}
   										    table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
   										    table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
   										    table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:11px}
   										    table tbody td {text-align:left;padding:6px 8px;font-size:11px}
   										    table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:11px}
									    .hori-table table thead td {text-align:center;padding:3px;}
   										    .hori-table table tbody td {text-align:center;padding:3px;}
   										    .vertical-table, .hori-table {margin-bottom:20px;}
								    </style>
								    </head>
								    <body>' +'</br>'+ '<b>' + REPLACE(ISNULL(@v_body_title, ''), CHAR(10), '<br>') + '</b>' +
									    '<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">' +
                                            '<table border=1 style="border-collapse: collapse; width:100%; white-space: nowrap; ">' +
										        @v_table_contents + '
									    </div>
								    </body>
						    </html>'
            END
            PRINT ('MAKE MAIL TEXT - END ---------------------------------------------------------------------------------');

            --TESTING: OK
            --exec debug_log @v_mail_text;return;--chaan

            PRINT (N'메일 발송 - BEGIN ---------------------------------------------------------------------------------------------')
            BEGIN
		        SET @v_user_id				= null;
		        SET @v_mail_receiver_list	= null;
		        SET @v_send_cnt				= 1;

	            DECLARE CUR_USER CURSOR FOR
	            SELECT  USER_ID
	            FROM    SCM_ADM_RECIPIENT_ASSIGN
	            WHERE   1=1
                    AND CATEGORY_ID = @p_category_id

		        OPEN CUR_USER;
		        FETCH NEXT FROM CUR_USER INTO @v_user_id

                --메일 발송 루프
		        WHILE @@FETCH_STATUS = 0
		        BEGIN
			        IF isnull(@v_mail_receiver_list,'') = ''
			        BEGIN
				        SET @v_mail_receiver_list = @v_user_id + '@lgensol.com'
			        END
			        ELSE
			        BEGIN
				        SET @v_mail_receiver_list = @v_mail_receiver_list + ';' + @v_user_id + '@lgensol.com'
			        END

                    --테스트모드에는 개발자 메일로만 발송!!!!!!!
                    IF @v_test_mode = 'T'
                    BEGIN
                        SET @v_mail_receiver_list   = @v_dev_email;
                        SET @v_user_cnt             = 1;
                    END

			        IF @v_user_cnt = @v_send_cnt
			        BEGIN
				        IF ISNULL(@v_curr_sql, '') != ''
				        BEGIN
                            PRINT '----------------------------------------------------------------------------------------------------------'
                            PRINT CONCAT('@v_mail_receiver_list : ', @v_mail_receiver_list);
                            PRINT CONCAT('@@v_mail_title : ', @v_mail_title);
                            PRINT CONCAT('@@v_mail_text : ', @v_mail_text);
                            PRINT '----------------------------------------------------------------------------------------------------------'

						    -- 메일 발송
						    EXEC SCM_ADM_MAIL_SEND    @v_mail_receiver_list
								                    , @v_mail_title
								                    , @v_mail_text
								                    , 'Y';

						    SET @v_body_title       = ''
						    SET @v_table_contents   = ''

						    EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL' ,@p_category_id ,'SCM_ADM_MAIL_SEND_DATA' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'', @v_mail_receiver_list;
				        END
				        ELSE
				        BEGIN
                            PRINT '----------------------------------------------------------------------------------------------------------'
                            PRINT CONCAT('@v_mail_receiver_list : ', @v_mail_receiver_list);
                            PRINT CONCAT('@v_mail_title : ', @v_mail_title);
                            PRINT CONCAT('@v_body_title : ', @v_body_title);
                            PRINT '----------------------------------------------------------------------------------------------------------'

					        -- 메일 발송
					        EXEC SCM_ADM_MAIL_SEND    @v_mail_receiver_list
							                        , @v_mail_title
							                        , @v_body_title
							                        , 'N';

					        --MAIL 발송 LOG 저장
						    EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL' ,@p_category_id ,'SCM_ADM_MAIL_SEND_DATA' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'', @v_mail_receiver_list;
				        END
			        END
			        ELSE -- 5명 이상일 경우
			        BEGIN
				        IF @v_send_cnt % 5 = 0
				        BEGIN
					        IF isnull(@v_curr_sql,'') != ''
					        BEGIN
						        IF LEN(@v_table_contents) > 0--chaan
						        BEGIN
                                    PRINT '----------------------------------------------------------------------------------------------------------'
                                    PRINT CONCAT('@v_mail_receiver_list : ', @v_mail_receiver_list);
                                    PRINT CONCAT('@v_mail_title : ', @v_mail_title);
                                    PRINT CONCAT('@v_mail_text : ', @v_mail_text);
                                    PRINT '----------------------------------------------------------------------------------------------------------'

							        -- 메일 발송
							        EXEC SCM_ADM_MAIL_SEND    @v_mail_receiver_list
									                        , @v_mail_title
									                        , @v_mail_text
									                        , 'Y';

							        SET @v_body_title       = ''
							        SET @v_table_contents   = ''

							        --MAIL 발송 LOG 저장
        						    EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL' ,@p_category_id ,'SCM_ADM_MAIL_SEND_DATA' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'', @v_mail_receiver_list;
						        END
					        END
					        ELSE
					        BEGIN
                                PRINT '----------------------------------------------------------------------------------------------------------'
                                PRINT CONCAT('@v_mail_receiver_list : ', @v_mail_receiver_list);
                                PRINT CONCAT('@v_mail_title : ', @v_mail_title);
                                PRINT CONCAT('@v_body_title : ', @v_body_title);
                                PRINT '----------------------------------------------------------------------------------------------------------'

						        -- 메일 발송
						        EXEC SCM_ADM_MAIL_SEND
								        @v_mail_receiver_list
								        ,@v_mail_title
								        ,@v_body_title
								        ,'N'
								        ;
						        --MAIL 발송 LOG 저장
    						    EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL' ,@p_category_id ,'SCM_ADM_MAIL_SEND_DATA' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'' ,'', @v_mail_receiver_list;
					        END

					        SET @v_mail_receiver_list = ''
				        END
			        END

			        SET @v_send_cnt = @v_send_cnt + 1

                    IF @v_test_mode = 'T'
                    BEGIN
                        BREAK;
                    END

			        FETCH NEXT FROM CUR_USER INTO @v_user_id
		        END

		        CLOSE CUR_USER;
		        DEALLOCATE CUR_USER;
            END
            PRINT (N'메일 발송 - END ---------------------------------------------------------------------------------------------')
		END

		SET @v_log_type		= 'END';
		SET @v_log_message	= '########## END of procedure ##########';
		SET @v_description	= @p_category_id;
		SET @d_event_date	= SYSDATETIME();

        --IF @v_test_mode <> 'T'
        --BEGIN
    		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --END
	END TRY 
    BEGIN CATCH
        BEGIN
            --IF @v_test_mode <> 'T'
            --BEGIN
		        INSERT INTO scm_sys_log_batch (  program_name
										        ,log_type
										        ,log_count
										        ,log_message
										        ,description
										        ,event_date
										        ,creation_date
										        ,created_by
										        ,last_update_date
										        ,last_updated_by)
				VALUES (ISNULL(ERROR_PROCEDURE(), 'SCM_ADM_MAIL_SEND_DATA')
		        -- 2025-08-09 kimcd check program name
				        ,'ERROR'
				        ,NULL
				        ,ERROR_MESSAGE()
				        ,'p_category_id:' + CONVERT(NVARCHAR(100), @p_category_id)
				        ,SYSDATETIME()
				        ,SYSDATETIME()
				        ,ERROR_PROCEDURE()
				        ,SYSDATETIME()
				        ,ERROR_PROCEDURE());

		        IF @@TRANCOUNT > 0
			        COMMIT WORK;
            --END
    	END

        BEGIN
	        DECLARE @v_error_message NVARCHAR(1000);
	        SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);

            --IF @v_test_mode <> 'T'
            --BEGIN
	            --MAIL 발송 LOG 저장
    		    EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'ERROR', @p_category_id, 'MAIN ERROR', '', '', '', '', '', '', '', '', '', @v_error_message, '';
            --END

	        IF @@TRANCOUNT > 0
		        COMMIT WORK;
        END

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;


    IF CURSOR_STATUS('global','CUR_SCM_ADM_MAIL_SEND_DATA') >= -1
    BEGIN
        IF CURSOR_STATUS('global','CUR_SCM_ADM_MAIL_SEND_DATA') > -1
        BEGIN
            CLOSE CUR_SCM_ADM_MAIL_SEND_DATA
        END

        DEALLOCATE CUR_SCM_ADM_MAIL_SEND_DATA
    END

    IF CURSOR_STATUS('global','CUR_USER') >= -1
    BEGIN
        IF CURSOR_STATUS('global','CUR_USER') > -1
        BEGIN
            CLOSE CUR_USER
        END

        DEALLOCATE CUR_USER
    END

END
