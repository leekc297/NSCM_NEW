
CREATE PROCEDURE [dbo].[NERP_PR_SCM_ADM_LONG_TERM_STOCK_MAIL]
AS

/*
 * Program ID   : NERP_PR_SCM_ADM_LONG_TERM_STOCK_MAIL
 * Description  : Longterm stock 메일 report (매달 8, 20일에 발송)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.08.11   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Initial Release
 * 2022.09.16   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 메일 전송대상이 단일 팀이 아닌 복수 팀도 가능하도록 변경
 * 2022.10.17   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 추가수신자 목록 추가
 * 2022.10.25   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - NOPIC 발송시 글로벌이 아닌 오창공장 소속에 대해서만 발송
 * 2022.12.16   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 메일 발송 관련한 부실징후자재 종류를 GRM04, GRM05, GRM06으로 제한
 * 2023.02.16   sclee.lee      메일 발송 관련한 부실징후자재 조건에 outsourcing = 'N' (OSP_YN = 'N'),  Operation Group != 'Warranty' (OPERATION_GROUP != 'W') 추가
 * 2024.01.25   vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.05.27	vadabi5		   NERP) QA, 개발 DB 적용
 ----------------------------------------------------------------------------------------------------

 */

BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  
  DECLARE @v_batch_user        NVARCHAR(150) = N'SCP_batch';
  
  -- LOG 용 변수 설정
  DECLARE @v_program_name      NVARCHAR(150) = 'PR_SCM_ADM_LONG_TERM_STOCK_MAIL';
  DECLARE @v_log_type          NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count         INTEGER = 0;
  DECLARE @v_log_message       NVARCHAR(1000);
  DECLARE @v_description       NVARCHAR(500);
  DECLARE @d_event_date        DATETIME;

	-- NERP 매핑코드
    DECLARE @v_ESOC NVARCHAR(8);
	SELECT @v_ESOC = dbo.FN_GET_LOOKUP_CODE_DETAIL('NERP_HARD_CODE_COMPANY','ESOC',null,'ASIS');--C100


  -- 시작 LOG
  SET @v_log_type = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
  
  -- 메일발신용 기초변수
  DECLARE @v_toMail            VARCHAR(200) = ''; -- 특정인에게 발송할 목적인 경우 이 변수(@v_toMail)를 사용한다 (예시 -> 메일주소1 또는 메일주소1;메일주소2;메일주소3), 빈 칸인 경우는 각 담당자들에 메일이 발신됨
  DECLARE @v_toMailAddional    VARCHAR(1000) = (
                                                SELECT DISTINCT STUFF(
												                      (
												                       SELECT CONCAT(';', [SEGMENT3])
												                       FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL
												                       WHERE  LOOKUP_TYPE = 'SCP_RPA_ADDITIONAL_RECIPIENTS'
                                                                       AND    VALID_YN = 'Y'
												                       FOR XML PATH('')
												                      ), 1, 1, ''
												                     ) [Name]
												FROM   SCM_ADM_LOOKUP_MASTER_DETAIL); -- 추가수신자
  DECLARE @v_csvSavePath       NVARCHAR(100) = 'd:\SAPRFC_TEST\debug\test\'; -- csv저장위치 (운영: c:\saprfc\lts\, 개발: d:\SAPRFC_TEST\debug\test\)
  DECLARE @v_sql               NVARCHAR(4000) = '';
  DECLARE @v_yyyyMM            VARCHAR(6) = FORMAT(DATEADD(M, -1, GETDATE()), 'yyyyMM');
  DECLARE @v_csvFullPath       NVARCHAR(100) = CONCAT(@v_csvSavePath, @v_yyyyMM, '_long_term_stock_list');
  DECLARE @v_csvFullPath1      NVARCHAR(100);
  DECLARE @v_subject           NVARCHAR(200) = CONCAT(N'[담당자 확인] ', FORMAT(GETDATE(), 'yy'), N'년 ', FORMAT(DATEADD(M, -1, GETDATE()), 'MM'), N'월 부실(징후) 자재 자동 알람');
  DECLARE @v_subject1          NVARCHAR(200) = CONCAT(@v_subject, N' PIC 미입력');
  DECLARE @v_bodyContents      NVARCHAR(100) = N'부실(징후) 자재에 대해 아래(첨부)와 같이 송부드리오니, 확인 및 조치하시길 바랍니다.';
  DECLARE @v_targetDB          VARCHAR(20) = DB_NAME();
  DECLARE @v_option            VARCHAR(20) = ' -c -t"," -T -S ';
  DECLARE @v_serverName        VARCHAR(20) = @@servername;
  DECLARE @v_total             INT;
  DECLARE @v_current           INT = 0;
  DECLARE @v_affCnt            INT;
  DECLARE @v_segment1          NVARCHAR(100) = '';
  DECLARE @v_segment2          NVARCHAR(100) = '';
  DECLARE @v_segment3          NVARCHAR(100) = '';
  DECLARE @v_segment4          NVARCHAR(100) = '';
  DECLARE @v_deleteCommand     NVARCHAR(100) = 'del /f ';
  DECLARE @v_deleteCommandLine NVARCHAR(100);
  DECLARE @v_header            NVARCHAR(1000) = 'SELECT ''YY.MM'',''DIV'',''Plant Site'',''Plant'',''Material'',''Description'',''Unit'',''Long Term Type'',''Item Type'',''Process Group'',''Material Group'',''Valuation class'',''Devaluation Age'',''Qty(Long term stock)'',''Amount(Long term stock)(KRW)'',''Unit price(KRW)'',''PIC'',''NO Usage in 3M''';

  -- bcp 명령어에 포함되는 관계로 해당 구문 줄바꿈처리 절대금지
  --DECLARE @v_body              NVARCHAR(2000) = CONCAT('SELECT A.YYYYMM,A.DIVISION_ID,REPLACE(B.PLANT_NAME,'','','' '') PLANT_NAME,REPLACE(A.PLANT_ID,'','','' '') PLANT_ID,REPLACE(A.ITEM_ID,'','','' '') ITEM_ID,REPLACE(A.ITEM_NAME,'','','' '') ITEM_NAME,REPLACE(A.ITEM_UOM,'','','' '') ITEM_UOM,REPLACE(A.LONG_TERM_TYPE,'','','' '') LONG_TERM_TYPE,REPLACE(D.ITEM_TYPE,'','','' '') ITEM_TYPE,REPLACE(D.PROCESS_GROUP,'','','' '') PROCESS_GROUP,REPLACE(D.PROCESS_DETAIL,'','','' '') PROCESS_DETAIL,A.VALUATION_CLASS,A.DEVALUATION_AGE,RTRIM(LTRIM(STR(A.LONG_TERM_STOCK_QTY))) LONG_TERM_STOCK_QTY,RTRIM(LTRIM(STR(IIF(A.WAERS=N''KRW'' OR A.EX_TO_BAMT=0, A.LONG_TERM_STOCK_AMOUNT, A.UNIT_PRICE*A.EX_TO_BAMT*A.LONG_TERM_STOCK_QTY)))) COL1,RTRIM(LTRIM(STR(IIF(A.WAERS=N''KRW'' OR A.EX_TO_BAMT=0, A.UNIT_PRICE, A.UNIT_PRICE*A.EX_TO_BAMT)))) COL2,E.PIC_NM,IIF(ISNULL(F.ITEM_ID, '''') != '''', ''O'', F.ITEM_ID) COL3 FROM ', @v_targetDB,'.dbo.SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK) INNER JOIN (SELECT PLANT_ID, MAX(PLANT_NAME) AS PLANT_NAME FROM ', @v_targetDB,'.dbo.SCM_PLANT_M_SN WITH(NOLOCK) GROUP BY PLANT_ID) B ON A.PLANT_ID = B.PLANT_ID LEFT JOIN (SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS FROM ', @v_targetDB,'.dbo.SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID ) C ON A.ITEM_ID = C.ITEM_ID LEFT JOIN ', @v_targetDB,'.dbo.SCM_MST_ITEM_CLASS_M D WITH(NOLOCK) ON C.ITEM_CLASS = D.CLASS_ID LEFT JOIN ', @v_targetDB,'.dbo.SCP_MST_PIC_INFO E WITH(NOLOCK) ON E.PLANT_ID = A.PLANT_ID AND E.ITEM_ID = A.ITEM_ID LEFT JOIN ', @v_targetDB,'.dbo.SCP_MST_NO_USE_3M F WITH(NOLOCK) ON F.PLANT_ID = A.PLANT_ID AND F.ITEM_ID = A.ITEM_ID WHERE A.YYYYMM=''', @v_yyyyMM,''' AND A.VALUATION_CLASS IN (''3000'',''3001'') AND A.DEVALUATION_AGE NOT IN (''GRM00'',''GRM01'')');

  -- PJ20216994 (2022.12.16)
  --DECLARE @v_body              NVARCHAR(2000) = CONCAT('SELECT A.YYYYMM,A.DIVISION_ID,REPLACE(B.PLANT_NAME,'','','' '') PLANT_NAME,REPLACE(A.PLANT_ID,'','','' '') PLANT_ID,REPLACE(A.ITEM_ID,'','','' '') ITEM_ID,REPLACE(A.ITEM_NAME,'','','' '') ITEM_NAME,REPLACE(A.ITEM_UOM,'','','' '') ITEM_UOM,REPLACE(A.LONG_TERM_TYPE,'','','' '') LONG_TERM_TYPE,REPLACE(D.ITEM_TYPE,'','','' '') ITEM_TYPE,REPLACE(D.PROCESS_GROUP,'','','' '') PROCESS_GROUP,REPLACE(D.PROCESS_DETAIL,'','','' '') PROCESS_DETAIL,A.VALUATION_CLASS,A.DEVALUATION_AGE,RTRIM(LTRIM(STR(A.LONG_TERM_STOCK_QTY))) LONG_TERM_STOCK_QTY,RTRIM(LTRIM(STR(IIF(A.WAERS=N''KRW'' OR A.EX_TO_BAMT=0, A.LONG_TERM_STOCK_AMOUNT, A.UNIT_PRICE*A.EX_TO_BAMT*A.LONG_TERM_STOCK_QTY)))) COL1,RTRIM(LTRIM(STR(IIF(A.WAERS=N''KRW'' OR A.EX_TO_BAMT=0, A.UNIT_PRICE, A.UNIT_PRICE*A.EX_TO_BAMT)))) COL2,E.PIC_NM,IIF(ISNULL(F.ITEM_ID, '''') != '''', ''O'', F.ITEM_ID) COL3 FROM ', @v_targetDB,'.dbo.SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK) INNER JOIN (SELECT PLANT_ID, MAX(PLANT_NAME) AS PLANT_NAME FROM ', @v_targetDB,'.dbo.SCM_PLANT_M_SN WITH(NOLOCK) GROUP BY PLANT_ID) B ON A.PLANT_ID = B.PLANT_ID LEFT JOIN (SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS FROM ', @v_targetDB,'.dbo.SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID ) C ON A.ITEM_ID = C.ITEM_ID LEFT JOIN ', @v_targetDB,'.dbo.SCM_MST_ITEM_CLASS_M D WITH(NOLOCK) ON C.ITEM_CLASS = D.CLASS_ID LEFT JOIN ', @v_targetDB,'.dbo.SCP_MST_PIC_INFO E WITH(NOLOCK) ON E.PLANT_ID = A.PLANT_ID AND E.ITEM_ID = A.ITEM_ID LEFT JOIN ', @v_targetDB,'.dbo.SCP_MST_NO_USE_3M F WITH(NOLOCK) ON F.PLANT_ID = A.PLANT_ID AND F.ITEM_ID = A.ITEM_ID WHERE A.YYYYMM=''', @v_yyyyMM,''' AND A.VALUATION_CLASS IN (''3000'',''3001'') AND A.DEVALUATION_AGE NOT IN (''GRM00'',''GRM01'',''GRM02'',''GRM03'')');

  -- 2023.02.16
  DECLARE @v_body              NVARCHAR(2000) = CONCAT('SELECT A.YYYYMM,A.DIVISION_ID,REPLACE(B.PLANT_NAME,'','','' '') PLANT_NAME,REPLACE(A.PLANT_ID,'','','' '') PLANT_ID,REPLACE(A.ITEM_ID,'','','' '') ITEM_ID,REPLACE(A.ITEM_NAME,'','','' '') ITEM_NAME,REPLACE(A.ITEM_UOM,'','','' '') ITEM_UOM,REPLACE(A.LONG_TERM_TYPE,'','','' '') LONG_TERM_TYPE,REPLACE(D.ITEM_TYPE,'','','' '') ITEM_TYPE,REPLACE(D.PROCESS_GROUP,'','','' '') PROCESS_GROUP,REPLACE(D.PROCESS_DETAIL,'','','' '') PROCESS_DETAIL,A.VALUATION_CLASS,A.DEVALUATION_AGE,RTRIM(LTRIM(STR(A.LONG_TERM_STOCK_QTY))) LONG_TERM_STOCK_QTY,RTRIM(LTRIM(STR(IIF(A.WAERS=N''KRW'' OR A.EX_TO_BAMT=0, A.LONG_TERM_STOCK_AMOUNT, A.UNIT_PRICE*A.EX_TO_BAMT*A.LONG_TERM_STOCK_QTY)))) COL1,RTRIM(LTRIM(STR(IIF(A.WAERS=N''KRW'' OR A.EX_TO_BAMT=0, A.UNIT_PRICE, A.UNIT_PRICE*A.EX_TO_BAMT)))) COL2,E.PIC_NM,IIF(ISNULL(F.ITEM_ID, '''') != '''', ''O'', F.ITEM_ID) COL3 FROM ', @v_targetDB,'.dbo.SCP_ANL_LONG_TERM_STOCK A WITH(NOLOCK) INNER JOIN (SELECT PLANT_ID, MAX(PLANT_NAME) AS PLANT_NAME FROM ', @v_targetDB,'.dbo.SCM_PLANT_M_SN WITH(NOLOCK) GROUP BY PLANT_ID) B ON A.PLANT_ID = B.PLANT_ID LEFT JOIN (SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC, MAX(ITEM_CLASS) AS ITEM_CLASS FROM ', @v_targetDB,'.dbo.SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID ) C ON A.ITEM_ID = C.ITEM_ID LEFT JOIN ', @v_targetDB,'.dbo.SCM_MST_ITEM_CLASS_M D WITH(NOLOCK) ON C.ITEM_CLASS = D.CLASS_ID LEFT JOIN ', @v_targetDB,'.dbo.SCP_MST_PIC_INFO E WITH(NOLOCK) ON E.PLANT_ID = A.PLANT_ID AND E.ITEM_ID = A.ITEM_ID LEFT JOIN ', @v_targetDB,'.dbo.SCP_MST_NO_USE_3M F WITH(NOLOCK) ON F.PLANT_ID = A.PLANT_ID AND F.ITEM_ID = A.ITEM_ID INNER JOIN (SELECT PLANT_ID FROM ', @v_targetDB,'.dbo.SCM_MST_SITE WITH(NOLOCK) WHERE OSP_YN = ''N'' AND OPERATION_GROUP != ''W'' GROUP BY PLANT_ID) G ON A.PLANT_ID = G.PLANT_ID WHERE A.YYYYMM=''', @v_yyyyMM,''' AND A.VALUATION_CLASS IN (''3000'',''3001'') AND A.DEVALUATION_AGE NOT IN (''GRM00'',''GRM01'',''GRM02'',''GRM03'')');

  DECLARE @v_body1             NVARCHAR(4000);
  DECLARE @v_body2             NVARCHAR(4000);
  
  DECLARE @v_tb_recipient TABLE
  (
    RowIdx   INT
   ,SEGMENT1 NVARCHAR(100)
   ,SEGMENT2 NVARCHAR(100)
   ,SEGMENT3 NVARCHAR(100)
   ,SEGMENT4 NVARCHAR(100)
   ,SEGMENT5 NVARCHAR(100)
  );

  BEGIN TRY

      -------------------------------------------------------------------------
      -- 1. CSV생성 및 메일발신 (팀장)
      -------------------------------------------------------------------------

      ;WITH sub AS
      (
       SELECT SEGMENT1
             ,SEGMENT3
             ,LOOKUP_TYPE
       FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
       WHERE  1 = 1
       AND    LOOKUP_TYPE = 'SCP_LTS_RECIPIENT'
       AND    VALID_YN = 'Y'
      ),
      sub1 AS
      (
       SELECT SEGMENT1
             ,SEGMENT2
             ,SEGMENT3
             ,SEGMENT4
             ,DISPLAY_SEQ
       FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
       WHERE  1 = 1
       AND    LOOKUP_TYPE = 'SCP_LTS_VIEW_LIST'
       AND    VALID_YN = 'Y'
      ),
      sub2 AS
      (
       SELECT ROW_NUMBER() OVER (ORDER BY B.DISPLAY_SEQ) DISPLAY_SEQ
             ,A.SEGMENT1
             ,B.SEGMENT1 SEGMENT2
             ,A.SEGMENT3
             ,B.SEGMENT2 SEGMENT4
             ,B.SEGMENT4 SEGMENT5
       FROM   sub A
       INNER  JOIN sub1 B
       ON     A.SEGMENT3 = B.SEGMENT3
       WHERE  1 = 1
       AND    A.LOOKUP_TYPE = 'SCP_LTS_RECIPIENT'
       AND    A.SEGMENT1 LIKE 'A%'
      )
      INSERT INTO @v_tb_recipient (RowIdx, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5)
      SELECT *
      FROM   sub2
      ORDER BY DISPLAY_SEQ;
      
      SET @v_total = @@ROWCOUNT;
      SET @v_current = 0;
      
      WHILE(@v_current < @v_total)
      BEGIN
          SET @v_current += 1;
          
          SELECT @v_segment1 = SEGMENT5
                ,@v_segment3 = SEGMENT3
          FROM   @v_tb_recipient
          WHERE  RowIdx = @v_current;

          SET @v_csvFullPath1 = CONCAT(@v_csvFullPath, '_(team)', '.csv');
          SET @v_body1 = CONCAT(@v_body, ' AND EXISTS (SELECT 1 FROM ', @v_targetDB,'.dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = ''SCP_LTS_VIEW_LIST'' AND VALID_YN = ''Y'' AND SEGMENT1 = E.PIC_NO AND SEGMENT2 IN (SELECT B.SEGMENT2 FROM (SELECT SEGMENT1,SEGMENT3,LOOKUP_TYPE FROM ', @v_targetDB,'.dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = ''SCP_LTS_RECIPIENT'' AND VALID_YN = ''Y'') A INNER JOIN (SELECT SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,DISPLAY_SEQ FROM ', @v_targetDB,'.dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = ''SCP_LTS_VIEW_LIST'' AND VALID_YN = ''Y'') B ON A.SEGMENT3 = B.SEGMENT3 WHERE A.LOOKUP_TYPE = ''SCP_LTS_RECIPIENT'' AND B.SEGMENT4 LIKE ''', @v_segment1, '%''))');
          SET @v_body2 = CONCAT('SELECT @v_affCnt = COUNT(*) FROM (', @v_body1, ') A');
		  EXEC sp_executesql @v_body2, N'@v_affCnt INT OUTPUT', @v_affCnt OUTPUT;
          SET @v_sql = CONCAT('bcp "', @v_header,' UNION ALL ', @v_body1,'" queryout ', @v_csvFullPath1, @v_option, @v_serverName);

          EXEC xp_cmdshell @v_sql;

          IF(@v_toMail != '')
          BEGIN
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND
                @p_to_mail          = @v_toMail
              , @p_subject          = @v_subject
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;
          END
          
          ELSE
          BEGIN
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND 
                @p_to_mail          = @v_segment3
              , @p_subject          = @v_subject
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;
			  
              -- PJ20216994 (2022.10.17)
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND
                @p_to_mail          = @v_toMailAddional
              , @p_subject          = @v_subject
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;
          END

          SET @v_deleteCommandLine = CONCAT(@v_deleteCommand, @v_csvFullPath1);

          -- 같은 파일명이지만 내용은 다르므로 발신 후 삭제하고 다음 담당자의 내용으로 csv를 재생성함
          EXEC xp_cmdshell @v_deleteCommandLine;

          SET @v_log_type    = 'MAIL';
          SET @v_log_message = ''

          SET @v_description = CONCAT(N'[메일발신] : ', @v_segment3);
          SET @n_log_count = @v_affCnt;
          SET @d_event_date  = SYSDATETIME();
	      
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

          --파트장/팀장에겐 PIC_NO가 없는 리스트를 추가로 발송
          SET @v_csvFullPath1 = CONCAT(@v_csvFullPath, '_(team)_NOPIC', '.csv');

          --PJ20216994 (2022.10.25)
          --SET @v_body1 = CONCAT(@v_body, ' AND ISNULL(E.PIC_NO, '''') = ''''');
          SET @v_body1 = CONCAT(@v_body, ' AND ISNULL(E.PIC_NO, '''') = '''' AND EXISTS (SELECT 1 FROM ', @v_targetDB,'.dbo.SCM_MST_SITE WITH(NOLOCK) WHERE PLANT_ID = A.PLANT_ID AND SITE_TYPE = ''PLANT'' AND COMPANY_ID = '''+ @v_ESOC + ''' AND OSP_YN = ''N'')');
          SET @v_body2 = CONCAT('SELECT @v_affCnt = COUNT(*) FROM (', @v_body1, ') A');
		  EXEC sp_executesql @v_body2, N'@v_affCnt INT OUTPUT', @v_affCnt OUTPUT;
          SET @v_sql = CONCAT('bcp "', @v_header,' UNION ALL ', @v_body1,'" queryout ', @v_csvFullPath1, @v_option, @v_serverName);

          EXEC xp_cmdshell @v_sql;

          IF(@v_toMail != '')
          BEGIN
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND
                @p_to_mail          = @v_toMail
              , @p_subject          = @v_subject1
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;
          END
          
          ELSE
          BEGIN
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND 
                @p_to_mail          = @v_segment3
              , @p_subject          = @v_subject1
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;

              -- PJ20216994 (2022.10.17)
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND
                @p_to_mail          = @v_toMailAddional
              , @p_subject          = @v_subject
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;
          END

          SET @v_deleteCommandLine = CONCAT(@v_deleteCommand, @v_csvFullPath1);

          -- 같은 파일명이지만 내용은 다르므로 발신 후 삭제하고 다음 담당자의 내용으로 csv를 재생성함
          EXEC xp_cmdshell @v_deleteCommandLine;

          SET @v_log_type    = 'MAIL';
          SET @v_log_message = ''

          SET @v_description = CONCAT(N'[메일발신 (NOPIC)] : ', @v_segment3);
          SET @n_log_count = @v_affCnt;
          SET @d_event_date  = SYSDATETIME();
	      
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      END

      -------------------------------------------------------------------------
      -- 2. CSV생성 및 메일발신 (파트장)
      -------------------------------------------------------------------------

      DELETE @v_tb_recipient;

      ;WITH sub AS
      (
       SELECT SEGMENT1
             ,SEGMENT3
             ,LOOKUP_TYPE
       FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
       WHERE  1 = 1
       AND    LOOKUP_TYPE = 'SCP_LTS_RECIPIENT'
       AND    VALID_YN = 'Y'
      ),
      sub1 AS
      (
       SELECT SEGMENT1
             ,SEGMENT2
             ,SEGMENT3
             ,SEGMENT4
             ,DISPLAY_SEQ
       FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
       WHERE  1 = 1
       AND    LOOKUP_TYPE = 'SCP_LTS_VIEW_LIST'
       AND    VALID_YN = 'Y'
      ),
      sub2 AS
      (
       SELECT ROW_NUMBER() OVER (ORDER BY B.DISPLAY_SEQ) DISPLAY_SEQ
             ,A.SEGMENT1
             ,B.SEGMENT1 SEGMENT2
             ,A.SEGMENT3
             ,B.SEGMENT2 SEGMENT4
             ,B.SEGMENT4 SEGMENT5
       FROM   sub A
       INNER  JOIN sub1 B
       ON     A.SEGMENT3 = B.SEGMENT3
       WHERE  1 = 1
       AND    A.LOOKUP_TYPE = 'SCP_LTS_RECIPIENT'
       AND    A.SEGMENT1 LIKE 'B%'
      )
      INSERT INTO @v_tb_recipient (RowIdx, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5)
      SELECT *
      FROM   sub2
      ORDER BY DISPLAY_SEQ;
      
      SET @v_total = @@ROWCOUNT;
      SET @v_current = 0;
      
      WHILE(@v_current < @v_total)
      BEGIN
          SET @v_current += 1;
          
          SELECT @v_segment1 = SEGMENT5
                ,@v_segment2 = SEGMENT2
                ,@v_segment3 = SEGMENT3
          FROM   @v_tb_recipient
          WHERE  RowIdx = @v_current;
          
          SET @v_csvFullPath1 = CONCAT(@v_csvFullPath, '_(part)', '.csv');
          SET @v_body1 = CONCAT(@v_body, ' AND EXISTS (SELECT 1 FROM ', @v_targetDB,'.dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = ''SCP_LTS_VIEW_LIST'' AND VALID_YN = ''Y'' AND SEGMENT1 = E.PIC_NO AND SEGMENT2 IN (SELECT B.SEGMENT2 FROM (SELECT SEGMENT1,SEGMENT3,LOOKUP_TYPE FROM ', @v_targetDB,'.dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = ''SCP_LTS_RECIPIENT'' AND VALID_YN = ''Y'') A INNER JOIN (SELECT SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,DISPLAY_SEQ FROM ', @v_targetDB,'.dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = ''SCP_LTS_VIEW_LIST'' AND VALID_YN = ''Y'') B ON A.SEGMENT3 = B.SEGMENT3 WHERE A.LOOKUP_TYPE = ''SCP_LTS_RECIPIENT'' AND B.SEGMENT4 LIKE ''', @v_segment1, '%''))');
          SET @v_body2 = CONCAT('SELECT @v_affCnt = COUNT(*) FROM (', @v_body1, ') A');
		  EXEC sp_executesql @v_body2, N'@v_affCnt INT OUTPUT', @v_affCnt OUTPUT;
          SET @v_sql = CONCAT('bcp "', @v_header,' UNION ALL ', @v_body1,'" queryout ', @v_csvFullPath1, @v_option, @v_serverName);

          EXEC xp_cmdshell @v_sql;

          IF(@v_toMail != '')
          BEGIN
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND
                @p_to_mail          = @v_toMail
              , @p_subject          = @v_subject
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;
          END
          
          ELSE
          BEGIN
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND 
                @p_to_mail          = @v_segment3
              , @p_subject          = @v_subject
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;
          END

          SET @v_deleteCommandLine = CONCAT(@v_deleteCommand, @v_csvFullPath1);

          -- 같은 파일명이지만 내용은 다르므로 발신 후 삭제하고 다음 담당자의 내용으로 csv를 재생성함
          EXEC xp_cmdshell @v_deleteCommandLine;

          SET @v_log_type    = 'MAIL';
          SET @v_log_message = ''

          SET @v_description = CONCAT(N'[메일발신] : ', @v_segment3);
          SET @n_log_count = @v_affCnt;
          SET @d_event_date  = SYSDATETIME();
	      
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

          --파트장/팀장에겐 PIC_NO가 없는 리스트를 추가로 발송
          SET @v_csvFullPath1 = CONCAT(@v_csvFullPath, '_(part)_NOPIC', '.csv');

          --PJ20216994 (2022.10.25)
          --SET @v_body1 = CONCAT(@v_body, ' AND ISNULL(E.PIC_NO, '''') = ''''');
          SET @v_body1 = CONCAT(@v_body, ' AND ISNULL(E.PIC_NO, '''') = '''' AND EXISTS (SELECT 1 FROM ', @v_targetDB,'.dbo.SCM_MST_SITE WITH(NOLOCK) WHERE PLANT_ID = A.PLANT_ID AND SITE_TYPE = ''PLANT'' AND COMPANY_ID = '''+ @v_ESOC + ''' AND OSP_YN = ''N'')');
          SET @v_body2 = CONCAT('SELECT @v_affCnt = COUNT(*) FROM (', @v_body1, ') A');
		  EXEC sp_executesql @v_body2, N'@v_affCnt INT OUTPUT', @v_affCnt OUTPUT;
          SET @v_sql = CONCAT('bcp "', @v_header,' UNION ALL ', @v_body1,'" queryout ', @v_csvFullPath1, @v_option, @v_serverName);

          EXEC xp_cmdshell @v_sql;

          IF(@v_toMail != '')
          BEGIN
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND
                @p_to_mail          = @v_toMail
              , @p_subject          = @v_subject1
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;
          END
          
          ELSE
          BEGIN
              EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND 
                @p_to_mail          = @v_segment3
              , @p_subject          = @v_subject1
              , @p_body_contents    = @v_bodyContents
              , @p_file_attachments = @v_csvFullPath1;
          END

          SET @v_deleteCommandLine = CONCAT(@v_deleteCommand, @v_csvFullPath1);

          -- 같은 파일명이지만 내용은 다르므로 발신 후 삭제하고 다음 담당자의 내용으로 csv를 재생성함
          EXEC xp_cmdshell @v_deleteCommandLine;

          SET @v_log_type    = 'MAIL';
          SET @v_log_message = ''

          SET @v_description = CONCAT(N'[메일발신 (NOPIC)] : ', @v_segment3);
          SET @n_log_count = @v_affCnt;
          SET @d_event_date  = SYSDATETIME();
	      
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      END

      -------------------------------------------------------------------------
      -- 3. CSV생성 및 메일발신 (팀원)
      -------------------------------------------------------------------------

      DELETE @v_tb_recipient;

      ;WITH sub AS
      (
       SELECT SEGMENT1
             ,SEGMENT3
             ,LOOKUP_TYPE
       FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
       WHERE  1 = 1
       AND    LOOKUP_TYPE = 'SCP_LTS_RECIPIENT'
       AND    VALID_YN = 'Y'
      ),
      sub1 AS
      (
       SELECT SEGMENT1
             ,SEGMENT2
             ,SEGMENT3
             ,SEGMENT4
             ,DISPLAY_SEQ
       FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
       WHERE  1 = 1
       AND    LOOKUP_TYPE = 'SCP_LTS_VIEW_LIST'
       AND    VALID_YN = 'Y'
      ),
      sub2 AS
      (
       SELECT ROW_NUMBER() OVER (ORDER BY B.DISPLAY_SEQ) DISPLAY_SEQ
             ,A.SEGMENT1
             ,B.SEGMENT1 SEGMENT2
             ,A.SEGMENT3
             ,B.SEGMENT2 SEGMENT4
             ,B.SEGMENT4 SEGMENT5
       FROM   sub A
       INNER  JOIN sub1 B
       ON     A.SEGMENT3 = B.SEGMENT3
       WHERE  1 = 1
       AND    A.LOOKUP_TYPE = 'SCP_LTS_RECIPIENT'
       AND    A.SEGMENT1 LIKE 'C%'
      )
      INSERT INTO @v_tb_recipient (RowIdx, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5)
      SELECT *
      FROM   sub2
      ORDER BY DISPLAY_SEQ;
      
      SET @v_total = @@ROWCOUNT;
      SET @v_current = 0;
      
      WHILE(@v_current < @v_total)
      BEGIN
          SET @v_current += 1;
          
          SELECT @v_segment1 = SEGMENT5
                ,@v_segment2 = SEGMENT2
                ,@v_segment3 = SEGMENT3
                ,@v_segment4 = SEGMENT4
          FROM   @v_tb_recipient
          WHERE  RowIdx = @v_current;
          
          SET @v_csvFullPath1 = CONCAT(@v_csvFullPath, '.csv');
          SET @v_deleteCommandLine = CONCAT(@v_deleteCommand, @v_csvFullPath1);
          SET @v_body1 = CONCAT(@v_body, ' AND E.PIC_NO = N''', @v_segment2, '''');
          SET @v_body2 = CONCAT('SELECT @v_affCnt = COUNT(*) FROM (', @v_body1, ') A');
		  EXEC sp_executesql @v_body2, N'@v_affCnt INT OUTPUT', @v_affCnt OUTPUT;

          -- 해당 담당자별로 건수가 있으면 파일 생성후 메일발신
          IF(@v_affCnt > 0)
          BEGIN
              SET @v_sql = CONCAT('bcp "', @v_header,' UNION ALL ', @v_body1,'" queryout ', @v_csvFullPath1, @v_option, @v_serverName);
              
              EXEC xp_cmdshell @v_sql;

              IF(@v_toMail != '')
              BEGIN
                  EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND
                    @p_to_mail          = @v_toMail
                  , @p_subject          = @v_subject
                  , @p_body_contents    = @v_bodyContents
                  , @p_file_attachments = @v_csvFullPath1;
              END
              
              ELSE
              BEGIN
                  EXEC dbo.PR_SCM_ADM_MAIL_AND_FILE_SEND 
                    @p_to_mail          = @v_segment3
                  , @p_subject          = @v_subject
                  , @p_body_contents    = @v_bodyContents
                  , @p_file_attachments = @v_csvFullPath1;
              END

              -- 같은 파일명이지만 내용은 다르므로 발신 후 삭제하고 다음 담당자의 내용으로 csv를 재생성함
              EXEC xp_cmdshell @v_deleteCommandLine;
          END
		  
          SET @v_log_type    = 'MAIL';
          SET @v_log_message = ''

          SET @v_description = CONCAT(N'[메일발신] : ', @v_segment3);
          SET @n_log_count = @v_affCnt;
          SET @d_event_date  = SYSDATETIME();
	      
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      END

      -- @v_csvSavePath 내 모든 csv파일 삭제
      SET @v_csvFullPath1 = CONCAT(@v_csvSavePath, '*.csv');
      SET @v_deleteCommandLine = CONCAT(@v_deleteCommand, @v_csvFullPath1);
	  
      EXEC xp_cmdshell @v_deleteCommandLine;

      SET @n_log_count = 0;
  END TRY

  BEGIN CATCH
  
      -- ERROR LOG SAVE
      SET @v_log_type    = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date  = SYSDATETIME();
      SET @n_log_count = 0;

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  
  END CATCH;
  
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    SET @n_log_count = 0;

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
