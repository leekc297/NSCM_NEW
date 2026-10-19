





/*=====================================================================================================================================================
 * Program ID   : PR_NERP_CONV_BLOCKED_OLD_VALUE_MAIL_SEND
 * Description  : NERP CONV BLOCKED OLD VALUE 메일 발송
 * Parameter    : @p_table, @p_Module, @p_TestProd_YN, @p_Transfer_Flag
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge       Description
 *=====================================================================================================================================================
 * 2025.06.15   김준규         NERP) 오펀차수별 적용 대응
 * 2025.06.22   김준규         NERP) Table 이름이 like EDI 일 경우 transfer_flag를 transaction_flag로 MRP 일 경우proc_flag 로 변경 
 * 2025.06.28   김준규         NERP) JV_PLANT 를 사용하는 TABLE에 조건 추가함
 *
 * EXEC PR_NERP_CONV_BLOCKED_OLD_VALUE_MAIL_SEND @p_table=N'XIF_ERP_CUSTOMER_R',@p_Module=N'ALL',@p_TestProd_YN=N'Y',@p_Transfer_Flag=N'A'
 * EXEC PR_NERP_CONV_BLOCKED_OLD_VALUE_MAIL_SEND @p_table=N'',@p_Module=N'ALL',@p_TestProd_YN=N'Y',@p_Transfer_Flag=N'A'
 * EXEC PR_NERP_CONV_BLOCKED_OLD_VALUE_MAIL_SEND @p_table=N'',@p_Module=N'ALL',@p_TestProd_YN=N'Y',@p_Transfer_Flag=N'Y'
 * EXEC PR_NERP_CONV_BLOCKED_OLD_VALUE_MAIL_SEND @p_table=N'',@p_Module=N'ALL',@p_TestProd_YN=N'Y',@p_Transfer_Flag=N'N'
 *===================================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_NERP_CONV_BLOCKED_OLD_VALUE_MAIL_SEND]
      @p_table                      NVARCHAR(254)       -- Interface table name
	, @p_Module				        NVARCHAR(100)='ALL' -- ALL:DM/SCM 모두, DM:DM만, SCP:SCP만
	, @p_TestProd_YN				NVARCHAR(100)='N'   -- Y:운영의 Linked Server 사용,N:현재서버 사용
	, @p_Transfer_Flag				NVARCHAR(100)='N'   -- A:Transfer_Flag 모두사용, Y:Transfer_Flag = 'Y', Y:Transfer_Flag = 'N' 사용
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    --==============================================================================================================
    --STEP 01. LOG 저장 (변수 생성 및 실행)
    --==============================================================================================================
    ----------------------------------------------------------------------------------------------------------------
    --STEP 01_01. LOG 용 변수 설정
    ----------------------------------------------------------------------------------------------------------------
    DECLARE @v_program_name     NVARCHAR(150) = 'PR_NERP_CONV_BLOCKED_OLD_VALUE_MAIL_SEND';
    DECLARE @v_log_type         NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count        INTEGER = 0;
    DECLARE @v_log_message      NVARCHAR(1000);
    DECLARE @v_description      NVARCHAR(500);
    DECLARE @d_event_date       DATETIME;

PRINT @v_program_name + ' : A001--' +'Table: ' + ISNULL(@p_table,'NULL') +' /Module: ' + ISNULL(@p_Module,'NULL') +' /TestProdYN: ' + ISNULL(@p_TestProd_YN,'NULL') +' /TransferFlag: ' + ISNULL(@p_Transfer_Flag,'NULL') + ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    ----------------------------------------------------------------------------------------------------------------
    --시작 LOG (START)
    ----------------------------------------------------------------------------------------------------------------
    SET @v_log_type     = 'START';
    SET @v_log_message  = '##### Start of procedure #####';
    SET @v_description  = N'NERP Open 법인으로 인터페이스에 구코드가 존재하는 내용 메일 발송 / Interface Table: ' + ISNULL(@p_table,'NULL') +' /Module: ' + ISNULL(@p_Module,'NULL') +' /TestProdYN: ' + ISNULL(@p_TestProd_YN,'NULL') +' /TransferFlag: ' + ISNULL(@p_Transfer_Flag,'NULL');
	
    SET @d_event_date   = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------------------------------------------
    --시작 LOG (END)
    ----------------------------------------------------------------------------------------------------------------
    BEGIN TRY
        --==============================================================================================================
        --STEP 02. 임시테이블 / 변수 생성
        --==============================================================================================================
		IF OBJECT_ID (N'tempdb..#T_MAIL_ADDR', N'U') IS NOT NULL	
			DROP TABLE #T_MAIL_ADDR;
			
		----------------------------------------------------------------------------------------------------------------
		--임시테이블 생성
		---------------------------------------------------------------------------------------------------------------- 
		CREATE TABLE #T_MAIL_ADDR 
		( ADDR				NVARCHAR(150)
		, SEQ				INT				IDENTITY(0,1))

        ----------------------------------------------------------------------------------------------------------------
        --임시테이블 생성
        ----------------------------------------------------------------------------------------------------------------

        ----------------------------------------------------------------------------------------------------------------
        --변수생성
        ----------------------------------------------------------------------------------------------------------------
        DECLARE @DBPrefix NVARCHAR(254);
        SET @DBPrefix = CASE WHEN ISNULL(@p_TestProd_YN, 'N') = 'Y' THEN '[10.34.220.88,7433].[LGCE_INF].[DBO].' ELSE '[LGCE_INFDEV].[DBO].' END; -- Y: LINKED_SERVER 운영DB 사용, N: 현재 DB사용

        DECLARE @SQL_STMT NVARCHAR(MAX)='';
        ------------------------------------------------------------------
        -- 2025.06.14   김준규   NERP) 오펀차수별 적용 대응 Start
        ------------------------------------------------------------------
        DECLARE @V_NERP_ROLLIN_STAGE NVARCHAR(30);
        DECLARE @V_NERP_START_YYYYMMDD NVARCHAR(8);

        SELECT TOP 1 @V_NERP_ROLLIN_STAGE = LMD.SEGMENT1
              ,@V_NERP_START_YYYYMMDD = LMD.SEGMENT2
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL lmd WITH(NOLOCK)
        JOIN   SCM_ADM_LOOKUP_MASTER alm WITH(NOLOCK)
        ON     ALM.LOOKUP_TYPE = LMD.LOOKUP_TYPE
        AND    ALM.LOOKUP_TYPE = 'NERP_ROLLIN_STAGE'
        WHERE  ALM.VALID_YN = 'Y'
        AND    LMD.VALID_YN = 'Y';
        ------------------------------------------------------------------
        -- 2025.06.14   김준규   NERP) 오펀차수별 적용 대응 End
        ------------------------------------------------------------------

        --##############
        --받을내용 정의
        --##############

        --
        --MODULE,TABLE_NAME,PROC_NM,CODETYPE,COLUMN,RECORD_COUNT,TRANSFER_DATE
        --
        DECLARE @T_MAIL_SEND TABLE (
            ID INT IDENTITY(1,1) PRIMARY KEY
            ,MODULE            NVARCHAR(10) 
            ,TBL_NM            NVARCHAR(254) NOT NULL
            ,CODETYPE          NVARCHAR(50)  
            ,COLUMN_NM         NVARCHAR(50)  
            ,OLD_VALUE         NVARCHAR(50)  
            ,CNT_RECORD        INT           
            ,MIN_TRANSFER_DATE DATETIME      
            ,MAX_TRANSFER_DATE DATETIME     
            ,PROC_NM           NVARCHAR(254) 
        );

        DECLARE @C_RTYPE NVARCHAR(10);
        DECLARE @C_TBL_NM NVARCHAR(254);
        DECLARE @C_CODETYPE NVARCHAR(30);
        DECLARE @C_COLUMN_NAME NVARCHAR(254);
        DECLARE @C_TRANSFER_DATE NVARCHAR(60);
        DECLARE @C_TRANSFER_TIME NVARCHAR(30);
        DECLARE @C_JOIN_JV_PLANT NVARCHAR(30);
        DECLARE @FIRST_ROW INT = 1;
        DECLARE @TEXT_UNION NVARCHAR(30) = N'UNION';
        DECLARE @DUMMY NVARCHAR(MAX)='';

        DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
            WITH W_JV_PLANT AS (
	            SELECT 'XIF_ERP_MAT_IMPORT_BL_R'  AS JV_TBL UNION
	            SELECT 'XIF_ERP_MAT_INBOUND_DO_R' AS JV_TBL UNION
	            SELECT 'XIF_ERP_MAT_PO_RECEIPT_R' AS JV_TBL 
		    )
            SELECT dpv.RTYPE,dpv.TBL_NM, dpv.CODETYPE, dpv.COLUMN_NAME,dpv.TRANSFER_DATE,dpv.TRANSFER_TIME
                  ,IIF(WJP.JV_TBL IS NULL, 'N', 'Y') AS JOIN_JV_PLANT
            FROM   NERP_CONV_DM_RFC_SAP_PO_V dpv WITH(NOLOCK)
            LEFT JOIN W_JV_PLANT AS WJP ON WJP.JV_TBL = dpv.TBL_NM 
            WHERE  dpv.CODETYPE IS NOT NULL
            AND    (@p_Module IS NULL OR @p_Module = '' OR @p_Module = 'ALL' OR dpv.RTYPE = @p_Module)
            AND    (@p_table IS NULL OR @p_table = '' OR dpv.TBL_NM = @p_table)
            UNION ALL
            SELECT dpv.RTYPE,dpv.TBL_NM, dpv.CODETYPE, dpv.COLUMN_NAME,dpv.TRANSFER_DATE,dpv.TRANSFER_TIME
                  ,IIF(WJP.JV_TBL IS NULL, 'N', 'Y') AS JOIN_JV_PLANT
            FROM   NERP_CONV_SCP_RFC_SAP_PO_V dpv WITH(NOLOCK)
            LEFT JOIN W_JV_PLANT AS WJP ON WJP.JV_TBL = dpv.TBL_NM 
            WHERE  dpv.CODETYPE IS NOT NULL
            AND    (@p_Module IS NULL OR @p_Module = '' OR @p_Module = 'ALL' OR dpv.RTYPE = @p_Module)
            AND    (@p_table IS NULL OR @p_table = '' OR dpv.TBL_NM = @p_table)
            ORDER BY 1,2,3,4
        
        OPEN cur

        FETCH NEXT FROM cur INTO @C_RTYPE, @C_TBL_NM, @C_CODETYPE, @C_COLUMN_NAME, @C_TRANSFER_DATE, @C_TRANSFER_TIME, @C_JOIN_JV_PLANT

        WHILE @@FETCH_STATUS = 0 BEGIN
            IF @FIRST_ROW = 1 BEGIN
                SET @TEXT_UNION = N'';
                SET @SQL_STMT = @TEXT_UNION;
                SET @FIRST_ROW = 0;
            END
            ELSE BEGIN
                SET @TEXT_UNION = N'            UNION';
                SET @SQL_STMT = @SQL_STMT+CHAR(10)+@TEXT_UNION;
            END
            SET @SQL_STMT += N'
            SELECT '''+@C_RTYPE+''' AS RTYPE, '''+@C_TBL_NM+''' AS TBL_NM, '''+@C_CODETYPE+''' AS CODETYPE,'''+@C_COLUMN_NAME+''' AS COLUMN_NM
                  ,'+@C_COLUMN_NAME+' AS OLD_VALUE,COUNT(*) AS CNT_RECORD
                  ,CONVERT(DATETIME,STUFF(STUFF(MIN('+@C_TRANSFER_DATE+' +'' ''+ '+@C_TRANSFER_TIME+'), 14, 0, '':''), 12, 0, '':'')) AS MIN_TRANSFER_DATE
                  ,CONVERT(DATETIME,STUFF(STUFF(MAX('+@C_TRANSFER_DATE+' +'' ''+ '+@C_TRANSFER_TIME+'), 14, 0, '':''), 12, 0, '':'')) AS MAX_TRANSFER_DATE
            FROM   '+@DBPrefix+@C_TBL_NM+' AS ECR ';
            --IF @C_JOIN_JV_PLANT = 'N' BEGIN END; --아무것도 안함
            IF @C_JOIN_JV_PLANT = 'Y' BEGIN
                SET @SQL_STMT += N'
            INNER JOIN JV_PLANT JP WITH(NOLOCK)
			        ON JV_DIVISION_ID = DIVISION_ID
			       AND JV_COMPANY_ID  = COMPANY_ID ';
            END;
            SET @SQL_STMT += N'
            WHERE  1=1';
        IF @p_Transfer_Flag = 'A' BEGIN
            SET @SQL_STMT += N'
            AND    1=1';
        END;
        ELSE BEGIN
            IF @C_TBL_NM LIKE '%EDI%' BEGIN
            SET @SQL_STMT += N'
            AND    ISNULL(transaction_flag,''N'') = '''+IIF(ISNULL(@p_Transfer_Flag,'')='','N',@p_Transfer_Flag)+'''';
            END
            ELSE IF @C_TBL_NM LIKE '%MRP%' BEGIN
            SET @SQL_STMT += N'
            AND    ISNULL(proc_flag,''N'') = '''+IIF(ISNULL(@p_Transfer_Flag,'')='','N',@p_Transfer_Flag)+'''';
            END
            ELSE BEGIN
            SET @SQL_STMT += N'
            AND    ISNULL(transfer_flag,''N'') = '''+IIF(ISNULL(@p_Transfer_Flag,'')='','N',@p_Transfer_Flag)+'''';
            END
        END;
        SET @SQL_STMT += N'
            AND    '+@C_TRANSFER_DATE+' >= '''+@V_NERP_START_YYYYMMDD+'''
            AND    EXISTS ( SELECT 1
                            FROM   NERP_CONV_MASTER ncm WITH(NOLOCK)
                            WHERE  NCM.CODETYPE = '''+@C_CODETYPE+'''
                            AND    NCM.OLD_VALUE1 = ECR.'+@C_COLUMN_NAME+'
                            AND    NCM.ATTRIBUTE5 <= '''+@V_NERP_ROLLIN_STAGE+'''
                          )
            GROUP BY '+@C_COLUMN_NAME+'';

	        FETCH NEXT FROM cur INTO @C_RTYPE, @C_TBL_NM, @C_CODETYPE, @C_COLUMN_NAME, @C_TRANSFER_DATE, @C_TRANSFER_TIME, @C_JOIN_JV_PLANT

        END

        CLOSE cur
        DEALLOCATE cur

        --SET @DUMMY = @SQL_STMT;
        --WHILE LEN(@DUMMY) > 0
        --BEGIN
        --    PRINT LEFT(@DUMMY, 4000)  -- 4000자씩 출력
        --    SET @DUMMY = SUBSTRING(@DUMMY, 4001, LEN(@DUMMY))
        --END
        ----EXEC sys.sp_executesql @SQL_STMT;

        SET @SQL_STMT = N'
	   WITH JV_PLANT AS (
	    SELECT JP.SEGMENT1		AS JV_DIVISION_ID
			  ,JP.SEGMENT3		AS JV_COMPANY_ID
			  ,MAX(JP.SEGMENT4)	AS DIVISION_ID_JV
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL JP WITH(NOLOCK)
		WHERE 1=1
		  AND JP.LOOKUP_TYPE = ''JV_PLANT''
		  AND JP.VALID_YN = ''Y''
		GROUP BY JP.SEGMENT1
				,JP.SEGMENT3
		)
        , W_XIF_RAW AS ('+CHAR(10)+ @SQL_STMT;
        SET @SQL_STMT += N'
        )
        SELECT DPV.MODULE,WCR.TBL_NM, WCR.CODETYPE, WCR.COLUMN_NM,WCR.OLD_VALUE, WCR.CNT_RECORD
              ,WCR.MIN_TRANSFER_DATE, WCR.MAX_TRANSFER_DATE, DPV.PROC_NM
        FROM   (SELECT * FROM NERP_CONV_DM_RFC_SAP_PO_V WITH(NOLOCK) 
                UNION SELECT * FROM NERP_CONV_SCP_RFC_SAP_PO_V WITH(NOLOCK) ) dpv
        JOIN   W_XIF_RAW AS WCR
        ON     WCR.TBL_NM = DPV.TBL_NM;';
        
        SET @DUMMY = @SQL_STMT;
        WHILE LEN(@DUMMY) > 0
        BEGIN
            PRINT LEFT(@DUMMY, 4000)  -- 4000자씩 출력
            SET @DUMMY = SUBSTRING(@DUMMY, 4001, LEN(@DUMMY))
        END

        INSERT INTO @T_MAIL_SEND(MODULE, TBL_NM, CODETYPE, COLUMN_NM, OLD_VALUE, CNT_RECORD
                            , MIN_TRANSFER_DATE, MAX_TRANSFER_DATE, PROC_NM)
        EXEC sys.sp_executesql @SQL_STMT;
        
        IF NOT (@@ROWCOUNT > 0) 
        BEGIN
            INSERT INTO @T_MAIL_SEND(MODULE, TBL_NM, CODETYPE, COLUMN_NM, OLD_VALUE, CNT_RECORD
                                     , MIN_TRANSFER_DATE, MAX_TRANSFER_DATE, PROC_NM)
            SELECT TOP 1 DPV.MODULE,DPV.TBL_NM,'COMPANY_ID' AS CODETYPE,'SALES_ORG' AS COLUMN_NM
                  ,'' AS OLD_VALUE, '' AS CNT_RECORD,GETDATE() AS MIN_TRANSFER_DATE, GETDATE() AS MAX_TRANSFER_DATE, DPV.PROC_NM
            FROM   NERP_CONV_DM_RFC_SAP_PO_V dpv WITH(NOLOCK)
            WHERE  DPV.TBL_NM = 'XIF_ERP_CUSTOMER_R'
        END
        --SELECT *FROM @T_MAIL_SEND;

 --*					  XIF_ERP_EDI_CALLOFF_HEAD_R    -> DM_DNM_EDI_CALLOFF_HEAD
 --*					  XIF_ERP_EDI_CALLOFF_PARTNER_R -> DM_DNM_EDI_CALLOFF_PARTNER
 --*					  XIF_ERP_EDI_CALLOFF_ITEM_R    -> DM_DNM_EDI_CALLOFF_ITEM


        --==============================================================================================================
        --STEP 03. 파라미터로 받은 DIV, VERSION으로 데이터 건수가 몇 건인지 확인하여 테이블에 데이터 적재
        --==============================================================================================================
        BEGIN
            DECLARE @CNT_RECORD INT = (SELECT SUM(CNT_RECORD) FROM @T_MAIL_SEND)
            DECLARE @CNT_TABLE  INT = (SELECT COUNT(DISTINCT TBL_NM) FROM @T_MAIL_SEND)
            DECLARE @CNT_LINE   INT = (SELECT COUNT(*) FROM @T_MAIL_SEND)
        END
PRINT @v_program_name + ' : A002--' +'Record Count: ' + FORMAT(@CNT_RECORD,'#,##0') + ' / '  +'Line Count: ' + FORMAT(@CNT_LINE,'#,##0') + ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

        ----------------------------------------------------------------------------------------------------------------
        --건수 LOG (START)
        ----------------------------------------------------------------------------------------------------------------
        SET @v_log_type = 'APPEND';
        SET @v_log_message = '##### APPEND of procedure #####';
        SET @v_description = N'Record Count:' + FORMAT(@CNT_RECORD,'#,##0') + N' /Line Count:'+ FORMAT(@CNT_LINE,'#,##0');
        SET @d_event_date   = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------------------------------------------
        --건수 LOG (END)
        ----------------------------------------------------------------------------------------------------------------
        --==============================================================================================================
        --STEP 04. 메일발송 대상
        --==============================================================================================================

        BEGIN
            ----------------------------------------------------------------------------------------------------------------
            --STEP 04_01. 룩업에 등록된 대상에 대해서만 메일을 발송한다.
            ----------------------------------------------------------------------------------------------------------------
            INSERT INTO #T_MAIL_ADDR ( ADDR )
            SELECT  DISTINCT A.SEGMENT2
            FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
            WHERE   A.LOOKUP_TYPE = 'NERP_BLOCKED_OLD_CODE_MAIL_ADDR'
            AND     A.SEGMENT2 = (CASE WHEN @p_Module = 'ALL' THEN A.SEGMENT2 ELSE @p_Module END)
            AND     A.VALID_YN  = 'Y'
        END
        --SELECT *FROM #T_MAIL_ADDR;
PRINT @v_program_name + ' : A003--' +'Table: ' + ISNULL(@p_table,'NULL') +' /Module: ' + ISNULL(@p_Module,'NULL') +' /TestProdYN: ' + ISNULL(@p_TestProd_YN,'NULL') +' /TransferFlag: ' + ISNULL(@p_Transfer_Flag,'NULL') + ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


        --==============================================================================================================
        --STEP 05. 메일발송 - 전송대상만큼 반복 (헤더, 본문)
        --==============================================================================================================
        BEGIN
            DECLARE   @TABLE_BODY                   NVARCHAR(MAX)
                    , @v_body_contents              NVARCHAR(MAX)
                    , @v_head_cont                  NVARCHAR(MAX)
                    , @v_body_cont                  NVARCHAR(MAX)
                    , @v_mail_title                 NVARCHAR(150)
                    , @V_OWNER                      NVARCHAR(100)
                    , @V_OWNER_TYPE                 CHAR(3)
                    , @V_LIKE_STRING                NVARCHAR(100)
                    , @v_cnt int
                    , @v_i int

            DECLARE   @MODULE               NVARCHAR(10) 
                    , @TBL_NM               NVARCHAR(254)
                    , @CODETYPE             NVARCHAR(50)  
                    , @COLUMN_NM            NVARCHAR(50)  
                    , @OLD_VALUE            NVARCHAR(50)  
                    , @CNT_REC              INT             
                    , @MIN_TRANSFER_DATE    NVARCHAR(50)      
                    , @MAX_TRANSFER_DATE    NVARCHAR(50)      
                    , @PROC_NM              NVARCHAR(254) 
                    ;

            ----------------------------------------------------------------------------------------------------------------
            --STEP 05_01. 테이블 HEADER
            ----------------------------------------------------------------------------------------------------------------
            SET @v_mail_title = N'NERP Open 법인 Interface Table에 ('''+FORMAT(@CNT_TABLE,'#,##0')+N''' 개 Table)  구코드가 존재('''+FORMAT(@CNT_RECORD,'#,##0')+N''' 건) 내용 메일 발송'

            /* 개발인경우 무조건 보내기 운영인 경우에는 주석처리 하기*/
            SET @v_body_contents  = N'개발시스템 TEST 진행중입니다. </br> '
                                 +  N'NERP Open 법인 인터페이스 테이블에 구코드가 존재하여, 테이블 및 해당 데이터의 건수 안내드립니다. </br> '

            /* 운영용
            SET @v_body_contents = N'안녕하십니까, SCM.DM 시스템입니다. </br> '
                                 +  N'Weekly Rolling Cutoff가 완료되어, 생성된 버전 및 해당 데이터의 건수 안내드립니다. </br> '
            */
            SET @v_head_cont = N'<TR>
                <TH width:10px>Module</TH>
                <TH width:110px>Table Name</TH>
                <TH width:110px>CodeType</TH>
                <TH width:110px>Column</TH>
                <TH width:110px>OldValue</TH>
                <TH width:110px>RecordCount</TH>
                <TH width:110px>MinTransterDate</TH>
                <TH width:110px>MaxTransterDate</TH>
                <TH width:110px>ProcedureName</TH>
                </TR>';
            ----------------------------------------------------------------------------------------------------------------
            --STEP 05_02. 테이블 반복 내용
            ----------------------------------------------------------------------------------------------------------------
            SELECT @V_CNT = COUNT(*), @V_I = 0, @V_OWNER = ''
            FROM #T_MAIL_ADDR
PRINT @v_program_name + ' : A004--' +'Table: ' + ISNULL(@p_table,'NULL') +' /Module: ' + ISNULL(@p_Module,'NULL') +' /TestProdYN: ' + ISNULL(@p_TestProd_YN,'NULL') +' /TransferFlag: ' + ISNULL(@p_Transfer_Flag,'NULL') + ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

            IF ( SELECT COUNT(*) FROM @T_MAIL_SEND ) > 0
            BEGIN
                WHILE ( @V_I < @V_CNT )
                BEGIN
                    SELECT @V_OWNER = ADDR
                    FROM #T_MAIL_ADDR
                    WHERE SEQ = @V_I;

                    SET @v_body_cont = '';  -- 본문내용 생성

                    DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
                    SELECT MODULE, TBL_NM,CODETYPE,COLUMN_NM, OLD_VALUE, CNT_RECORD, MIN_TRANSFER_DATE, MAX_TRANSFER_DATE, PROC_NM
                    FROM @T_MAIL_SEND A
                    ORDER BY A.ID;

                    OPEN CUR_SEND;
                    FETCH NEXT FROM CUR_SEND INTO @MODULE, @TBL_NM, @CODETYPE, @COLUMN_NM, @OLD_VALUE, @CNT_REC, @MIN_TRANSFER_DATE, @MAX_TRANSFER_DATE, @PROC_NM;

                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @v_body_cont = @v_body_cont+ N'<TR>';
                        SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'  + ISNULL(@MODULE           ,'') + N'</TD>'  ;
                        SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'  + ISNULL(@TBL_NM           ,'') + N'</TD>'  ;
                        SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'  + ISNULL(@CODETYPE         ,'') + N'</TD>'   ;
                        SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'  + ISNULL(@COLUMN_NM        ,'') + N'</TD>'   ;
                        SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'  + ISNULL(@OLD_VALUE        ,'') + N'</TD>'   ;
                        SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = RIGHT >' + FORMAT(@CNT_REC     ,'#,##0') + N'</TD>'   ;
                        --SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = RIGHT >' + ISNULL(@CNT_REC          ,'') + N'</TD>'   ;
                        SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'  + CONVERT(NVARCHAR(30), @MIN_TRANSFER_DATE, 121) + N'</TD>'   ;
                        SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'  + CONVERT(NVARCHAR(30), @MAX_TRANSFER_DATE, 121) + N'</TD>'   ;
                        SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'  + ISNULL(@PROC_NM          ,'') + N'</TD>'   ;
                        SET @v_body_cont = @v_body_cont+ N'</TR>';

                    FETCH NEXT FROM CUR_SEND INTO @MODULE, @TBL_NM, @CODETYPE, @COLUMN_NM, @OLD_VALUE, @CNT_REC, @MIN_TRANSFER_DATE, @MAX_TRANSFER_DATE, @PROC_NM;

                    END

                CLOSE CUR_SEND;
                DEALLOCATE CUR_SEND;

                SET @TABLE_BODY = N' <html>
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
                                        <body></br><b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), N'<br>') + N'</b>'
                                                + N'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'
                                                + N'<table style=''border-top:2px solid #c8294b; width:700px;''>
                                            <thead>' + ISNULL(@v_head_cont,'') + N'</thead>
                                            <tbody>' + ISNULL(@v_body_cont, '') + N'</tbody>
                                            </table>
                                            </div>
                                           <hr>';
                IF DB_NAME() <> 'LGCE_SCMDEV' BEGIN --운영간주
                SET @TABLE_BODY += N'
                                           <p>'+N'EXEC PR_NERP_CONV_BLOCKED_OLD_VALUE_MAIL_SEND @p_table=N'''+@p_table+''',@p_Module=N'''+@p_Module+''',@p_TestProd_YN=N'''+@p_TestProd_YN+''',@p_Transfer_Flag=N'''+@p_Transfer_Flag+N'''. <br>
                                               - 사용자 등록 --> SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE  LOOKUP_TYPE = ''NERP_BLOCKED_OLD_CODE_MAIL_ADDR'' </p>';
                END;
                ELSE BEGIN --개발
                SET @TABLE_BODY += N'
                                           <p>'+N'개발서버_165.244.95.223 : EXEC PR_NERP_CONV_BLOCKED_OLD_VALUE_MAIL_SEND @p_table=N'''+@p_table+''',@p_Module=N'''+@p_Module+''',@p_TestProd_YN=N'''+@p_TestProd_YN+''',@p_Transfer_Flag=N'''+@p_Transfer_Flag+N'''. <br>
                                               - 사용자 등록은 개발서버_165.244.95.223에서 등록--> SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE  LOOKUP_TYPE = ''NERP_BLOCKED_OLD_CODE_MAIL_ADDR'' </p>';
                END;
                SET @TABLE_BODY += N'
                                           <p style="font-size: 0.9em; color: #555;">
                                               <strong>파라미터 사용법:</strong><br>
                                               - @p_table          --> NULL 또는 '''' : 모두, 입력시 : Interface table name </br> 
                                               - @p_Module         --> ALL:DM/SCM 모두, DM:DM만, SCP:SCP만 </br> 
                                               - @p_TestProd_YN    --> Y:운영의 Linked Server 사용,N:현재서버 사용 </br> 
                                               - @p_Transfer_Flag  --> A:Transfer_Flag 모두, Y:Transfer_Flag = ''Y'', N:Transfer_Flag = ''N'' </br> 
                                               </br>
                                               - 쿼리 문장 <br>
                                               '+ISNULL(@SQL_STMT,'')+N'</br>
                                               </br>
                                        </body>
                                    </html>';
                ----------------------------------------------------------------------------------------------------------------
                --STEP 05-03. Mail 전송
                ----------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + N' : A005--' +'Table: ' + ISNULL(@p_table,'NULL') +' /Module: ' + ISNULL(@p_Module,'NULL') +' /TestProdYN: ' + ISNULL(@p_TestProd_YN,'NULL') +' /TransferFlag: ' + ISNULL(@p_Transfer_Flag,'NULL') + ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
                BEGIN
                    
                    --EXEC SCM_ADM_MAIL_SEND
                    --    'jungyu9.kim@lgespartner.com'
                    --    , @v_mail_title
                    --    , @TABLE_BODY
                    --    , 'Y'
                    

                    ----------------------------------------------------------------------------------------------------------------
                    --STEP 05-04. 메일은 운영일 경우에만 발송함.
                    ----------------------------------------------------------------------------------------------------------------
                    --IF DB_NAME() <> 'LGCE_SCMDEV'
                    --NERP CONV 테스트용으로 등록된 매일 4회 발송 예정
                    BEGIN
                        EXEC SCM_ADM_MAIL_SEND @V_OWNER, @v_mail_title, @TABLE_BODY, 'Y'
                    END
                        ------------------------------------------------------------------------------------------------------
                        --MAIL 발송 LOG 저장
                        ------------------------------------------------------------------------------------------------------
                        EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG
                            'MAIL'
                            , '-'
                            , @v_program_name
                            , @V_OWNER
                            , ''
                            , ''
                            , ''
                            , ''
                            , ''
                            , ''
                            , ''
                            , ''
                            , '' --p_send_pgm
                            , '' ;
                END

                IF ( @V_I % 5 IN ( 0, 5 ))
                BEGIN
                    WAITFOR DELAY '00:00:30'
                END

                SET @V_I = @V_I + 1
                END
            END
        END

PRINT @v_program_name + N' : A006--' +'Table: ' + ISNULL(@p_table,'NULL') +' /Module: ' + ISNULL(@p_Module,'NULL') +' /TestProdYN: ' + ISNULL(@p_TestProd_YN,'NULL') +' /TransferFlag: ' + ISNULL(@p_Transfer_Flag,'NULL') + ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    END TRY

BEGIN CATCH
  SET @v_log_type = 'ERROR';
  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
  SET @d_event_date = SYSDATETIME();
  SELECT @v_log_message
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END CATCH

-----------------------------------------------------------------------------------------------------------------------------------------
--종료 LOG (START)
-----------------------------------------------------------------------------------------------------------------------------------------
 SET @v_log_type = 'END';
 SET @v_log_message = '##### END of procedure #####';
 SET @v_description  = N'NERP Open 법인으로 인터페이스에 구코드가 존재하는 내용 메일 발송 / Interface Table: ' + ISNULL(@p_table,'NULL') +' /Module: ' + ISNULL(@p_Module,'NULL') +' /TestProdYN: ' + ISNULL(@p_TestProd_YN,'NULL') +' /TransferFlag: ' + ISNULL(@p_Transfer_Flag,'NULL');
 SET @d_event_date = SYSDATETIME();
 EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
-----------------------------------------------------------------------------------------------------------------------------------------
--종료 LOG (END)
-----------------------------------------------------------------------------------------------------------------------------------------

END;

