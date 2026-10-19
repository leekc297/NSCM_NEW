

/*===================================================================================================================================================== 
 * Program ID  : PR_DM_DNM_EDI_CALLOFF_DATA
 * Description  : BMW / AUDI등 EDI 정보 ERP I/F -> GSCM EDI_CALLOFF 신규 INSERT
 *                    XIF_ERP_EDI_CALLOFF_HEAD_R    -> DM_DNM_EDI_CALLOFF_HEAD
 *                    XIF_ERP_EDI_CALLOFF_PARTNER_R -> DM_DNM_EDI_CALLOFF_PARTNER
 *                    XIF_ERP_EDI_CALLOFF_ITEM_R    -> DM_DNM_EDI_CALLOFF_ITEM
 * Program History
 *===================================================================================================================================================== 
 *   Date       In Charge      Description
 *===================================================================================================================================================== 
 * 배포시 주의사항 : 개발기 -> LGCE_INF , 운영기 -> LGCE_INF
 *===================================================================================================================================================== 
 * 2023.05.03   kdmcc14     [EDI과제]
 * 2023.12.13   chano0612   [PARTNER_TYPE 다중으로 인한 오류 처리]
 * 2024.06.27   JSSBAE      [E20240610-000320]_SCM DM EDI(Cust FCST) 관련 문의사항 (예외로직적용: 앞뒤 공백값, NULL값 공백으로 치환해서 비교 처리)
 * 2024.08.30   JSSBAE      [E20240807-000723]_GSCM EDI내 고객사 파트넘버 문의
 * 2024.12.26   KANG.H.J    [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 * 2025.06.19   김준규      [IT20250117A] NERP 오펀차수별 Mapping Code적용 
 * 2025.09.16	JSSBAE		[E20250910-000974]_NN Mapping Master 컬럼 추가 요청
 *===================================================================================================================================================*/

 --EXEC PR_DM_DNM_EDI_CALLOFF_DATA
CREATE PROCEDURE [dbo].[PR_DM_DNM_EDI_CALLOFF_DATA]
AS
	BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user               NVARCHAR(150) = 'scm_batch';
    DECLARE @v_program_name             NVARCHAR(150) = 'PR_DM_DNM_EDI_CALLOFF_DATA';
    DECLARE @V_BATCH_CHK_MSG            NVARCHAR(150) = ''

    DECLARE @v_log_type                 NVARCHAR(30);   -- START/END/ERROR/...
    DECLARE @n_log_count                INTEGER = 0;
    DECLARE @v_log_message              NVARCHAR(1000);
    DECLARE @v_description              NVARCHAR(500);
    DECLARE @d_event_date               DATETIME;
    DECLARE @v_ifseqno                  NVARCHAR(30);   -- 누락된 전체 데이터 insert
    DECLARE @v_ifseqno_x                NVARCHAR(30);   -- CUST_FCST INSERT 순차 작업용 CURSOR
    DECLARE @v_new_insert_count         INTEGER = 0;        -- EDI New Insert 건수
    DECLARE @v_DIVISION_ID              NVARCHAR(30);
    DECLARE @v_DIVISION_ID_UC           NVARCHAR(30);

    SET @v_DIVISION_ID = '81'
    SET @v_DIVISION_ID_UC = '81_UC'

    ------------------------------------------------------------------------
    -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 Start
    ------------------------------------------------------------------------
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
    ------------------------------------------------------------------------
    -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 End
    ------------------------------------------------------------------------

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
    BEGIN TRY
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

        -- IF TABLE의 신규 수신받은 건이 있을때만 처리
        IF ( ( SELECT COUNT(1) FROM XIF_ERP_EDI_CALLOFF_HEAD_R_SN WITH(NOLOCK)    WHERE ISNULL(TRANSACTION_FLAG,'N') IN ('P', 'N') ) +
             ( SELECT COUNT(1) FROM XIF_ERP_EDI_CALLOFF_ITEM_R_SN WITH(NOLOCK)    WHERE ISNULL(TRANSACTION_FLAG,'N') IN ('P', 'N') ) +
             ( SELECT COUNT(1) FROM XIF_ERP_EDI_CALLOFF_PARTNER_R_SN WITH(NOLOCK) WHERE ISNULL(TRANSACTION_FLAG,'N') IN ('P', 'N') )
           ) > 0

        ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
        --                                                                             IF TABLE의 정보가 존재하는경우 수행 (START)
        ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
        BEGIN

            --BEGIN TRANSACTION
            -- 인터페이스 테이블 처리 ROW UPDATE
            UPDATE  XIF_ERP_EDI_CALLOFF_HEAD_R_SN
            SET     TRANSACTION_FLAG = 'P'
            WHERE   ISNULL(TRANSACTION_FLAG, 'N') = 'N'
            -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 Start
            -- OLD 코드는 반영이 되지 않게 처리
            AND    NOT EXISTS ( SELECT 1
                                FROM   NERP_CONV_MASTER ncm WITH(NOLOCK)
                                WHERE  NCM.CODETYPE = 'COMPANY_ID'
                                AND    NCM.OLD_VALUE1 = XIF_ERP_EDI_CALLOFF_HEAD_R_SN.COMPANY_ID
                                AND    NCM.ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE
                              )
            -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 End

            IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_EDI_CALL_OFF_HEAD')
            BEGIN
                CLOSE CUR_EDI_CALL_OFF_HEAD
                DEALLOCATE CUR_EDI_CALL_OFF_HEAD
            END;

print 'CUR_EDI_CALL_OFF_HEAD start' + convert(nvarchar(30), getdate(), 121)

            -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
            DECLARE CUR_EDI_CALL_OFF_HEAD CURSOR FOR

            SELECT IFSEQNO
            FROM  XIF_ERP_EDI_CALLOFF_HEAD_R_SN WITH(NOLOCK)
            WHERE TRANSACTION_FLAG = 'P'
            GROUP BY IFSEQNO
            ORDER BY IFSEQNO ASC;

            OPEN CUR_EDI_CALL_OFF_HEAD;
            FETCH NEXT FROM CUR_EDI_CALL_OFF_HEAD INTO @v_ifseqno ;

            ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
            WHILE (@@FETCH_STATUS = 0)
            ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
                BEGIN
            ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

                MERGE INTO [dbo].[DM_DNM_EDI_CALLOFF_HEAD] A
                USING (
                        SELECT  IFSEQNO
                                ,SOLDTO_CODE
                                ,COMPANY_ID
                                ,MESSAGE_REFERENCE
                                ,MESSAGE_TYPE
                                ,DOC_IDENTIFINER
                                ,EDI_INTERCHANGE_NO
                                ,DOC_ISSUE_DATE
                                ,RDD_TYPE
                                ,COMPANY_NAME
                                ,SOLDTO_NAME
                                ,EDI_IF_SEQ
                                ,TRANSACTION_FLAG
                                ,CREATE_USER_ID
                                ,CREATE_DATE
                                ,CREATE_TIME
                                ,UPDATE_USER_ID
                                ,UPDATE_DATE
                                ,UPDATE_TIME
                                ,TRANSFER_CREATE_USER_ID
                                ,TRANSFER_CREATE_DATE
                                ,TRANSFER_CREATE_TIME
                                ,TRANSFER_UPDATE_USER_ID
                                ,TRANSFER_UPDATE_DATE
                                ,TRANSFER_UPDATE_TIME
                                ,ISNULL(DOC_STATUS,'') AS DOC_STATUS
                                ,CONCAT(CASE WHEN IFSEQNO LIKE '1%' THEN 'G' ELSE 'D' END, SENDER_CODE) AS SENDER_CODE
                                ,SENDER_NAME
                                ,CASE WHEN ISNUMERIC(ATTRIBUTE1) > 0 THEN CAST(ATTRIBUTE1 AS INT) ELSE 0 END AS TT_CNT
                                ,CASE WHEN ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS INT) ELSE 0 END AS SENDER_CNT
                        FROM   XIF_ERP_EDI_CALLOFF_HEAD_R_SN WITH(NOLOCK)
                        WHERE  IFSEQNO             = @v_ifseqno
                        AND     TRANSACTION_FLAG       = 'P'
                        GROUP BY
                                IFSEQNO
                                ,SOLDTO_CODE
                                ,COMPANY_ID
                                ,MESSAGE_REFERENCE
                                ,MESSAGE_TYPE
                                ,DOC_IDENTIFINER
                                ,EDI_INTERCHANGE_NO
                                ,DOC_ISSUE_DATE
                                ,RDD_TYPE
                                ,COMPANY_NAME
                                ,SOLDTO_NAME
                                ,EDI_IF_SEQ
                                ,TRANSACTION_FLAG
                                ,CREATE_USER_ID
                                ,CREATE_DATE
                                ,CREATE_TIME
                                ,UPDATE_USER_ID
                                ,UPDATE_DATE
                                ,UPDATE_TIME
                                ,TRANSFER_CREATE_USER_ID
                                ,TRANSFER_CREATE_DATE
                                ,TRANSFER_CREATE_TIME
                                ,TRANSFER_UPDATE_USER_ID
                                ,TRANSFER_UPDATE_DATE
                                ,TRANSFER_UPDATE_TIME
                                ,ISNULL(DOC_STATUS,'')
                                ,CONCAT(CASE WHEN IFSEQNO LIKE '1%' THEN 'G' ELSE 'D' END, SENDER_CODE)
                                ,SENDER_NAME
                                ,CASE WHEN ISNUMERIC(ATTRIBUTE1) > 0 THEN CAST(ATTRIBUTE1 AS INT) ELSE 0 END
                                ,CASE WHEN ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS INT) ELSE 0 END
                    ) B
                ON (
                        A.SOLDTO_CODE           =  B.SOLDTO_CODE
                        AND A.COMPANY_ID        =  B.COMPANY_ID
                        AND ISNULL(A.MESSAGE_REFERENCE, '') =  ISNULL(B.MESSAGE_REFERENCE, '')
                        AND ISNULL(A.MESSAGE_TYPE, '')            =  ISNULL(B.MESSAGE_TYPE, '')
                        AND ISNULL(A.DOC_IDENTIFINER, '')         =  ISNULL(B.DOC_IDENTIFINER, '')
                    )
                WHEN MATCHED THEN
                    UPDATE SET
                                A.EDI_INTERCHANGE_NO     = B.EDI_INTERCHANGE_NO
                            ,A.DOC_ISSUE_DATE        = B.DOC_ISSUE_DATE
                            ,A.RDD_TYPE              = B.RDD_TYPE
                            ,A.COMPANY_NAME          = B.COMPANY_NAME
                            ,A.SOLDTO_NAME           = B.SOLDTO_NAME
                            ,A.EDI_IF_SEQ            = B.EDI_IF_SEQ
                            ,A.TRANSACTION_FLAG      = B.TRANSACTION_FLAG
                            ,A.CREATE_USER_ID        = B.CREATE_USER_ID
                            ,A.CREATE_DATE           = B.CREATE_DATE
                            ,A.CREATE_TIME           = B.CREATE_TIME
                            ,A.UPDATE_USER_ID        = B.UPDATE_USER_ID
                            ,A.UPDATE_DATE           = B.UPDATE_DATE
                            ,A.UPDATE_TIME           = B.UPDATE_TIME
                            ,A.VALID_YN              = 'Y'
                            ,A.last_updated_by       = @v_batch_user
                            ,A.last_update_date      = GETDATE()
                            ,A.ATTRIBUTE6            = ISNULL(B.DOC_STATUS, '')
                            ,A.SENDER_CODE           = B.SENDER_CODE
                            ,A.SENDER_NAME           = B.SENDER_NAME
                            ,A.TT_CNT                = B.TT_CNT
                            ,A.SENDER_CNT            = B.SENDER_CNT

                WHEN NOT MATCHED THEN
                    INSERT (
                                SOLDTO_CODE
                            ,COMPANY_ID
                            ,MESSAGE_REFERENCE
                            ,MESSAGE_TYPE
                            ,DOC_IDENTIFINER
                            ,EDI_INTERCHANGE_NO
                            ,DOC_ISSUE_DATE
                            ,RDD_TYPE
                            ,COMPANY_NAME
                            ,SOLDTO_NAME
                            ,EDI_IF_SEQ
                            ,TRANSACTION_FLAG
                            ,CREATE_USER_ID
                            ,CREATE_DATE
                            ,CREATE_TIME
                            ,UPDATE_USER_ID
                            ,UPDATE_DATE
                            ,UPDATE_TIME
                            ,VALID_YN
                            ,CREATED_BY
                            ,CREATION_DATE
                            ,LAST_UPDATED_BY
                            ,LAST_UPDATE_DATE
                            ,ATTRIBUTE6
                            ,SENDER_CODE
                            ,SENDER_NAME
                            ,TT_CNT
                            ,SENDER_CNT
                        )
                    VALUES (
                                ISNULL(B.SOLDTO_CODE, '')
                            ,ISNULL(B.COMPANY_ID, '')
                            ,ISNULL(B.MESSAGE_REFERENCE, '')
                            ,ISNULL(B.MESSAGE_TYPE, '')
                            ,ISNULL(B.DOC_IDENTIFINER, '')
                            ,B.EDI_INTERCHANGE_NO
                            ,B.DOC_ISSUE_DATE
                            ,B.RDD_TYPE
                            ,B.COMPANY_NAME
                            ,B.SOLDTO_NAME
                            ,B.EDI_IF_SEQ
                            ,B.TRANSACTION_FLAG
                            ,B.CREATE_USER_ID
                            ,B.CREATE_DATE
                            ,B.CREATE_TIME
                            ,B.UPDATE_USER_ID
                            ,B.UPDATE_DATE
                            ,B.UPDATE_TIME
                            ,'Y'
                            ,@v_batch_user
                            ,GETDATE()
                            ,@v_batch_user
                            ,GETDATE()
                            ,B.DOC_STATUS
                            ,B.SENDER_CODE
                            ,B.SENDER_NAME
                            ,B.TT_CNT
                            ,B.SENDER_CNT
                        )
                ;

              -- 처리 한 row 마킹
              UPDATE XIF_ERP_EDI_CALLOFF_HEAD_R_SN
              SET TRANSACTION_FLAG      = 'Y'
              WHERE TRANSACTION_FLAG    = 'P'
              AND IFSEQNO               = @v_ifseqno
              ;

              FETCH NEXT FROM CUR_EDI_CALL_OFF_HEAD INTO  @v_ifseqno
              END

              CLOSE CUR_EDI_CALL_OFF_HEAD;
              DEALLOCATE CUR_EDI_CALL_OFF_HEAD;

print 'CUR_EDI_CALL_OFF_HEAD end' + convert(nvarchar(30), getdate(), 121)

            -------------------------------------------------------------------------------------------------------------------
            --EDI_CALLOFF_HEAD (END)
            -------------------------------------------------------------------------------------------------------------------

            -------------------------------------------------------------------------------------------------------------------
            --EDI_CALLOFF_PARTNER (START)
            -------------------------------------------------------------------------------------------------------------------
            -- 인터페이스 테이블 처리 ROW UPDATE
            UPDATE XIF_ERP_EDI_CALLOFF_PARTNER_R_SN
            SET     TRANSACTION_FLAG = 'P'
            WHERE  ISNULL(TRANSACTION_FLAG, 'N') = 'N'
            -- 2025.06.16   김준규   NERP) 오펀차수별 적용 대응 Start
            -- OLD 코드는 반영이 되지 않게 처리
            AND    NOT EXISTS ( SELECT 1
                                FROM   NERP_CONV_MASTER ncm WITH(NOLOCK)
                                WHERE  NCM.CODETYPE = 'COMPANY_ID'
                                AND    NCM.OLD_VALUE1 = XIF_ERP_EDI_CALLOFF_PARTNER_R_SN.COMPANY_ID
                                AND    NCM.ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE
                              )
            -- 2025.06.16   김준규   NERP) 오펀차수별 적용 대응 End

            IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_EDI_CALL_OFF_PARTNER')
            BEGIN
                CLOSE CUR_EDI_CALL_OFF_PARTNER
                DEALLOCATE CUR_EDI_CALL_OFF_PARTNER
            END;

print 'CUR_EDI_CALL_OFF_PARTNER start ' + convert(nvarchar(30), getdate(), 121)

            -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
            DECLARE CUR_EDI_CALL_OFF_PARTNER CURSOR FOR

            SELECT IFSEQNO
            FROM   XIF_ERP_EDI_CALLOFF_PARTNER_R_SN WITH(NOLOCK)
            WHERE  TRANSACTION_FLAG = 'P'
            GROUP BY IFSEQNO
            ORDER BY IFSEQNO ASC;

            OPEN CUR_EDI_CALL_OFF_PARTNER;
            FETCH NEXT FROM CUR_EDI_CALL_OFF_PARTNER INTO @v_ifseqno ;

            ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
            WHILE (@@FETCH_STATUS = 0)
            ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
            BEGIN
            ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

                MERGE INTO [dbo].[DM_DNM_EDI_CALLOFF_PARTNER] A
                USING (
                        SELECT  IFSEQNO
                                ,SOLDTO_CODE
                                ,COMPANY_ID
                                ,MESSAGE_REFERENCE
                                ,MESSAGE_TYPE
                                ,DOC_IDENTIFINER
                                ,SHIPTO_CODE
                                ,PARTNER_TYPE
                                ,SHIPTO_SEQ
                                ,COMPANY_NAME
                                ,SHIPTO_NAME1
                                ,SHIPTO_NAME2
                                ,CITY_NAME
                                ,POSTAL_CODE
                                ,COUNTRY
                                ,SHIPTO_DUNS_NO
                                ,EDI_IF_SEQ
                                ,TRANSACTION_FLAG
                                ,SHIP_FROM_PLANT
                                ,CREATE_USER_ID
                                ,CREATE_DATE
                                ,CREATE_TIME
                                ,UPDATE_USER_ID
                                ,UPDATE_DATE
                                ,UPDATE_TIME
                                ,TRANSFER_CREATE_USER_ID
                                ,TRANSFER_CREATE_DATE
                                ,TRANSFER_CREATE_TIME
                                ,TRANSFER_UPDATE_USER_ID
                                ,TRANSFER_UPDATE_DATE
                                ,TRANSFER_UPDATE_TIME
                                ,ISNULL(DOC_STATUS,'') AS DOC_STATUS
                                ,CONCAT(CASE WHEN IFSEQNO LIKE '1%' THEN 'G' ELSE 'D' END, SENDER_CODE) AS SENDER_CODE
                                ,SENDER_NAME
                                ,CASE WHEN ISNUMERIC(ATTRIBUTE1) > 0 THEN CAST(ATTRIBUTE1 AS INT) ELSE 0 END AS TT_CNT
                                ,CASE WHEN ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS INT) ELSE 0 END AS SENDER_CNT
                        FROM   XIF_ERP_EDI_CALLOFF_PARTNER_R_SN WITH(NOLOCK)
                        WHERE  IFSEQNO              = @v_ifseqno
                        AND     TRANSACTION_FLAG    = 'P'
                        GROUP BY IFSEQNO
                                ,SOLDTO_CODE
                                ,COMPANY_ID
                                ,MESSAGE_REFERENCE
                                ,MESSAGE_TYPE
                                ,DOC_IDENTIFINER
                                ,SHIPTO_CODE
                                ,PARTNER_TYPE
                                ,SHIPTO_SEQ
                                ,COMPANY_NAME
                                ,SHIPTO_NAME1
                                ,SHIPTO_NAME2
                                ,CITY_NAME
                                ,POSTAL_CODE
                                ,COUNTRY
                                ,SHIPTO_DUNS_NO
                                ,EDI_IF_SEQ
                                ,TRANSACTION_FLAG
                                ,SHIP_FROM_PLANT
                                ,CREATE_USER_ID
                                ,CREATE_DATE
                                ,CREATE_TIME
                                ,UPDATE_USER_ID
                                ,UPDATE_DATE
                                ,UPDATE_TIME
                                ,TRANSFER_CREATE_USER_ID
                                ,TRANSFER_CREATE_DATE
                                ,TRANSFER_CREATE_TIME
                                ,TRANSFER_UPDATE_USER_ID
                                ,TRANSFER_UPDATE_DATE
                                ,TRANSFER_UPDATE_TIME
                                ,ISNULL(DOC_STATUS,'')
                                ,CONCAT(CASE WHEN IFSEQNO LIKE '1%' THEN 'G' ELSE 'D' END, SENDER_CODE)
                                ,SENDER_NAME
                                ,CASE WHEN ISNUMERIC(ATTRIBUTE1) > 0 THEN CAST(ATTRIBUTE1 AS INT) ELSE 0 END
                                ,CASE WHEN ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS INT) ELSE 0 END

                    ) B
                ON (
                        A.SOLDTO_CODE                           =  B.SOLDTO_CODE
                        AND A.COMPANY_ID                        =  B.COMPANY_ID
                        AND ISNULL(A.MESSAGE_REFERENCE, '')     =  ISNULL(B.MESSAGE_REFERENCE, '')
                        AND ISNULL(A.MESSAGE_TYPE, '')          =  ISNULL(B.MESSAGE_TYPE, '')
                        AND ISNULL(A.DOC_IDENTIFINER, '')       =  ISNULL(B.DOC_IDENTIFINER, '')
                        AND ISNULL(A.SHIPTO_CODE, '')           =  ISNULL(B.SHIPTO_CODE, '')
                        AND ISNULL(A.PARTNER_TYPE, '')          =  ISNULL(B.PARTNER_TYPE, '')
                        AND ISNULL(A.SHIPTO_SEQ, '')            =  ISNULL(B.SHIPTO_SEQ, '')
                    )
                WHEN MATCHED THEN
                    UPDATE SET   A.COMPANY_NAME     =  B.COMPANY_NAME
                            , A.SHIPTO_NAME1        =  B.SHIPTO_NAME1
                            , A.SHIPTO_NAME2        =  B.SHIPTO_NAME2
                            , A.CITY_NAME           =  B.CITY_NAME
                            , A.POSTAL_CODE         =  B.POSTAL_CODE
                            , A.COUNTRY             =  B.COUNTRY
                            , A.SHIPTO_DUNS_NO      =  B.SHIPTO_DUNS_NO
                            , A.EDI_IF_SEQ          =  B.EDI_IF_SEQ
                            , A.TRANSACTION_FLAG    =  B.TRANSACTION_FLAG
                            , A.SHIP_FROM_PLANT     =  B.SHIP_FROM_PLANT
                            , A.CREATE_USER_ID      =  B.CREATE_USER_ID
                            , A.CREATE_DATE         =  B.CREATE_DATE
                            , A.CREATE_TIME         =  B.CREATE_TIME
                            , A.UPDATE_USER_ID      =  B.UPDATE_USER_ID
                            , A.UPDATE_DATE         =  B.UPDATE_DATE
                            , A.UPDATE_TIME         =  B.UPDATE_TIME
                            , A.VALID_YN            =  'Y'
                            , A.LAST_UPDATED_BY     =  @v_batch_user
                            , A.last_update_date    =  GETDATE()
                            , A.ATTRIBUTE6          =  B.DOC_STATUS
                            , A.SENDER_CODE         =  B.SENDER_CODE
                            , A.SENDER_NAME         =  B.SENDER_NAME
                            , A.TT_CNT              =  B.TT_CNT
                            , A.SENDER_CNT          =  B.SENDER_CNT

                WHEN NOT MATCHED THEN
                    INSERT (
                                SOLDTO_CODE
                            ,COMPANY_ID
                            ,MESSAGE_REFERENCE
                            ,MESSAGE_TYPE
                            ,DOC_IDENTIFINER
                            ,SHIPTO_CODE
                            ,PARTNER_TYPE
                            ,SHIPTO_SEQ
                            ,COMPANY_NAME
                            ,SHIPTO_NAME1
                            ,SHIPTO_NAME2
                            ,CITY_NAME
                            ,POSTAL_CODE
                            ,COUNTRY
                            ,SHIPTO_DUNS_NO
                            ,EDI_IF_SEQ
                            ,TRANSACTION_FLAG
                            ,SHIP_FROM_PLANT
                            ,CREATE_USER_ID
                            ,CREATE_DATE
                            ,CREATE_TIME
                            ,UPDATE_USER_ID
                            ,UPDATE_DATE
                            ,UPDATE_TIME
                            ,VALID_YN
                            ,CREATED_BY
                            ,CREATION_DATE
                            ,LAST_UPDATED_BY
                            ,LAST_UPDATE_DATE
                            ,ATTRIBUTE6
                            ,SENDER_CODE
                            ,SENDER_NAME
                            ,TT_CNT
                            ,SENDER_CNT
                        )
                    VALUES (
                                B.SOLDTO_CODE
                            ,B.COMPANY_ID
                            ,ISNULL(B.MESSAGE_REFERENCE, '')
                            ,B.MESSAGE_TYPE
                            ,ISNULL(B.DOC_IDENTIFINER, '')
                            ,B.SHIPTO_CODE
                            ,B.PARTNER_TYPE
                            ,B.SHIPTO_SEQ
                            ,B.COMPANY_NAME
                            ,B.SHIPTO_NAME1
                            ,B.SHIPTO_NAME2
                            ,B.CITY_NAME
                            ,B.POSTAL_CODE
                            ,B.COUNTRY
                            ,B.SHIPTO_DUNS_NO
                            ,B.EDI_IF_SEQ
                            ,B.TRANSACTION_FLAG
                            ,B.SHIP_FROM_PLANT
                            ,B.CREATE_USER_ID
                            ,B.CREATE_DATE
                            ,B.CREATE_TIME
                            ,B.UPDATE_USER_ID
                            ,B.UPDATE_DATE
                            ,B.UPDATE_TIME
                            ,'Y'
                            ,@v_batch_user
                            ,GETDATE()
                            ,@v_batch_user
                            ,GETDATE()
                            ,B.DOC_STATUS
                            ,B.SENDER_CODE
                            ,B.SENDER_NAME
                            ,B.TT_CNT
                            ,B.SENDER_CNT
                        )
                ;

                -- 처리 한 row 마킹
                UPDATE XIF_ERP_EDI_CALLOFF_PARTNER_R_SN
                SET       TRANSACTION_FLAG  = 'Y'
                WHERE  TRANSACTION_FLAG  = 'P'
                AND   IFSEQNO            = @v_ifseqno
                ;

                FETCH NEXT FROM CUR_EDI_CALL_OFF_PARTNER INTO  @v_ifseqno
            END

            CLOSE CUR_EDI_CALL_OFF_PARTNER;
            DEALLOCATE CUR_EDI_CALL_OFF_PARTNER;

print 'CUR_EDI_CALL_OFF_PARTNER end ' + convert(nvarchar(30), getdate(), 121)

            -------------------------------------------------------------------------------------------------------------------
            --EDI_CALLOFF_ITEM (START)
            -------------------------------------------------------------------------------------------------------------------

            -- 인터페이스 테이블 처리 ROW UPDATE
            UPDATE XIF_ERP_EDI_CALLOFF_ITEM_R_SN
            SET     TRANSACTION_FLAG = 'P'
            WHERE  ISNULL(TRANSACTION_FLAG, 'N') = 'N'
            -- 2025.06.16   김준규   NERP) 오펀차수별 적용 대응 Start
            -- OLD 코드는 반영이 되지 않게 처리
            AND    NOT EXISTS ( SELECT 1
                                FROM   NERP_CONV_MASTER ncm WITH(NOLOCK)
                                WHERE  NCM.CODETYPE = 'COMPANY_ID'
                                AND    NCM.OLD_VALUE1 = XIF_ERP_EDI_CALLOFF_ITEM_R_SN.COMPANY_ID
                                AND    NCM.ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE
                              )
            -- 2025.06.16   김준규   NERP) 오펀차수별 적용 대응 End

            IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_EDI_CALL_OFF_ITEM')
            BEGIN
                CLOSE CUR_EDI_CALL_OFF_ITEM
                DEALLOCATE CUR_EDI_CALL_OFF_ITEM
            END;

print 'XIF_ERP_EDI_CALLOFF_ITEM_R_SN start ' + convert(nvarchar(30), getdate(), 121)


            -- 테이블중복제거
            IF OBJECT_ID (N'tempdb..#TEMP_EDI_NEW_ALL', N'U')           IS NOT NULL DROP TABLE #TEMP_EDI_NEW_ALL

            -- 임시확인용테이블 중복제거
            IF OBJECT_ID (N'dbo.#TEMP_EDI_NEW_ALL', N'U')                   IS NOT NULL DROP TABLE #TEMP_EDI_NEW_ALL

            --#TEMP_EDI_NEW_ALL
            CREATE TABLE #TEMP_EDI_NEW_ALL  (
                NUM                 INT NULL,
                IFSEQNO         NVARCHAR(35)    NULL
            );

            INSERT INTO #TEMP_EDI_NEW_ALL ( NUM, IFSEQNO )
            SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS NUM
                , IFSEQNO
            FROM  XIF_ERP_EDI_CALLOFF_ITEM_R_SN WITH(NOLOCK)
            WHERE TRANSACTION_FLAG = 'P'
            GROUP BY IFSEQNO
            ORDER BY IFSEQNO ASC
            ;
SELECT * FROM #TEMP_EDI_NEW_ALL;

            DECLARE @i INT = 1, @CNT INT = 0;
            ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
            SELECT @CNT = COUNT(*) FROM #TEMP_EDI_NEW_ALL
PRINT @CNT
            ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
            WHILE (@i <= @CNT)
            ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
            BEGIN
PRINT @i
                --신규 IFSEQNO
                SELECT @v_ifseqno = IFSEQNO FROM #TEMP_EDI_NEW_ALL
                WHERE NUM = @i
PRINT 'IFSEQNO : ' + @v_ifseqno
                INSERT INTO DM_DNM_EDI_CALLOFF_ITEM (
                          EDI_IF_SEQ
                        , SUB_NO
                        , YYYYMMDD
                        , DIVISION_ID, SOLDTO_CODE, COMPANY_ID, MESSAGE_REFERENCE, MESSAGE_TYPE, DOC_IDENTIFINER, SHIPTO_CODE
                        , PARTNER_TYPE, SHIPTO_SEQ, SHIP_TO_ITEM_SEQ
                        , ITEM_ID, CUSTOMER_PLANT, UNLOADING_POINT
                        , SCHEDULING_TYPE, RDD_START
                        , QTY, UOM, RDD_END, CUSTOMER_PO_NO, CUSTOMER_CALL_OFF_NO, CUSTOMER_CALL_OFF_DATE
                        , PREVIOUS_CALL_OFF_NO, PREVIOUS_CALL_OFF_DATE, COMPANY_NAME, SHIPTO_NAME1, SHIPTO_NAME2
                        , TRANSACTION_FLAG, ERP_FCST_TYPE
                        , CREATE_USER_ID, CREATE_DATE, CREATE_TIME, UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME
                        , VALID_YN
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , IFSEQNO
                        , SOLDTO_CODE_W, MESSAGE_TYPE_W
                        , RDD_START_W
                        , DOC_STATUS, PROJECT_CODE, SCM_SITE_ID, SALES_PLANT_SITE_ID, EDI_INCOTERMS
                        , STATUS_CODE, BOM_STATUS, SALES_SITE_STATUS, SSPM_STATUS, PROJECT_STATUS, ITEM_STATUS, SALES_PLANT_SITE_STATUS , INCOTERMS_STATUS
                        , CUST_MATERIAL_CODE
                        , SENDER_CODE, SENDER_NAME, TT_CNT, SENDER_CNT, ERP_STATUS
                        , BASIS_YYYYMMDD, DC_LEVEL --[E20250910-000974]_NN Mapping Master 컬럼 추가 요청											
						)
                SELECT EDI_IF_SEQ
                    , ROW_NUMBER() OVER ( PARTITION BY EDI_IF_SEQ ORDER BY RDD_START ) AS SUB_NO
                    , CASE  WHEN SUBSTRING(RDD_START, 7, 2) = '00' THEN CONVERT(NVARCHAR, EOMONTH(SUBSTRING(RDD_START, 1, 6) + '01'), 112)
                            ELSE ISNULL(RDD_START, '')                                              -- RDD_START가 년/월까지만 정의된 경우 월초로 데이터 변환
                      END                                           AS YYYYMMDD
                    , B.SEGMENT2                                    AS DIVISION_ID                  -- EDI는 모두 81로 넘어옴 ==> 법인코드별로 JV 법인 구분 기능
                    , ISNULL(A.SOLDTO_CODE, '')                     AS SOLDTO_CODE
                    , ISNULL(COMPANY_ID, '')                        AS COMPANY_ID
                    , ISNULL(MESSAGE_REFERENCE, '')                 AS MESSAGE_REFERENCE
                    , MESSAGE_TYPE
                    , ISNULL(DOC_IDENTIFINER, '')                   AS DOC_IDENTIFINER
                    , ISNULL(A.SHIPTO_CODE, '')                     AS SHIPTO_CODE
                    , PARTNER_TYPE, SHIPTO_SEQ, SHIP_TO_ITEM_SEQ
                    , ISNULL(LTRIM(RTRIM(ITEM_ID)),'')              AS ITEM_ID
                    , ISNULL(LTRIM(RTRIM(CUSTOMER_PLANT)),'')       AS CUSTOMER_PLANT
                    , ISNULL(LTRIM(RTRIM(UNLOADING_POINT)),'')      AS UNLOADING_POINT
                    , SCHEDULING_TYPE, RDD_START
                    , QTY, UOM, RDD_END, CUSTOMER_PO_NO, CUSTOMER_CALL_OFF_NO, CUSTOMER_CALL_OFF_DATE
                    , PREVIOUS_CALL_OFF_NO, PREVIOUS_CALL_OFF_DATE, COMPANY_NAME, SHIPTO_NAME1, SHIPTO_NAME2
                    , TRANSACTION_FLAG, ERP_FCST_TYPE
                    , CREATE_USER_ID, CREATE_DATE, CREATE_TIME, UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME
                    , 'Y'                                           AS VALID_YN
                    , @v_batch_user, GETDATE(), @v_batch_user, GETDATE()
                    , @v_ifseqno                                    AS IFSEQNO
                    , A.SOLDTO_CODE, MESSAGE_TYPE
                    , CASE  WHEN SUBSTRING(RDD_START, 7, 2) = '00' THEN RDD_START ELSE '' END           AS RDD_START_W
                    , ISNULL(A.DOC_STATUS, '')          AS DOC_STATUS
                    , ''                                AS PROJECT_CODE
                    , ''                                AS SCM_SITE_ID
                    , ''                                AS SALES_PLANT_SITE_ID
                    , ''                                AS EDI_INCOTERMS
                    , 'U'                               AS STATUS_CODE
                    , 'S'                               AS BOM_STATUS           -- BOM_STATUS는 체크 제외함.
                    , 'E'                               AS SALES_SITE_STATUS
                    , 'E'                               AS SSPM_STATUS
                    , 'E'                               AS PROJECT_STATUS
                    , 'E'                               AS ITEM_STATUS
                    , 'E'                               AS SALES_PLANT_SITE_STATUS
                    , 'E'                               AS INCOTERMS_STATUS
                    , ISNULL(LTRIM(RTRIM(CUST_MATERIAL_CODE)),'')                               AS CUST_MATERIAL_CODE
                    , CONCAT(CASE WHEN IFSEQNO LIKE '1%' THEN 'G' ELSE 'D' END, SENDER_CODE)    AS SENDER_CODE
                    , SENDER_NAME
                    , CASE WHEN ISNUMERIC(A.ATTRIBUTE1) > 0 THEN CAST(A.ATTRIBUTE1 AS INT) ELSE 0 END AS TT_CNT
                    , CASE WHEN ISNUMERIC(A.ATTRIBUTE2) > 0 THEN CAST(A.ATTRIBUTE2 AS INT) ELSE 0 END AS SENDER_CNT
                    , CASE WHEN (ISNULL(RDD_START, '') = '' OR LEN(RDD_START) <> 8 OR ISNULL(SOLDTO_CODE, '') = '' OR ISNULL(SHIPTO_CODE, '') ='' OR ISNULL(ITEM_ID, '') = '') THEN 'E'
                           ELSE 'S'
                      END                                           AS ERP_STATUS
                    , CASE  WHEN SUBSTRING(RDD_START, 7, 2) = '00' THEN CONVERT(NVARCHAR, EOMONTH(SUBSTRING(RDD_START, 1, 6) + '01'), 112)
                            ELSE ISNULL(RDD_START, '')
                      END                                           AS BASIS_YYYYMMDD
					, A.ATTRIBUTE3 --[E20250910-000974]_ERP에서 ATTRIBUTE3에 DC_LEVEL 정보를 넣어 주기로함
                FROM   XIF_ERP_EDI_CALLOFF_ITEM_R_SN A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  -- [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 start
                ON B.LOOKUP_TYPE = 'DM_EDI_COMPANY_DIVISION_MAPPING'
                AND A.COMPANY_ID = B.SEGMENT1
                AND B.VALID_YN = 'Y'
                WHERE  IFSEQNO          = @v_ifseqno
                AND TRANSACTION_FLAG    = 'P'
PRINT 'END'
                -- 처리 한 row 마킹
                UPDATE XIF_ERP_EDI_CALLOFF_ITEM_R_SN
                SET     TRANSACTION_FLAG    = 'Y'
                WHERE  TRANSACTION_FLAG     = 'P'
                AND     IFSEQNO             = @v_ifseqno
                ;

                SET @i = @i + 1

            END

            -- 처리결과건수 로그변수에 입력
            SET @v_new_insert_count = @v_new_insert_count + (SELECT COUNT(*) FROM DM_DNM_EDI_CALLOFF_ITEM WITH(NOLOCK) WHERE 1 = 1 AND IFSEQNO IN (SELECT IFSEQNO FROM #TEMP_EDI_NEW_ALL))

        END
        ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
        --                                                                             IF TABLE의 정보가 존재하는경우 수행 (END)
        ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
    END TRY
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

    BEGIN CATCH
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      SELECT @v_log_message

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'EDI New Insert Count : ' + CAST((@v_new_insert_count) as NVARCHAR(10))  ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

ERR_RTN:

print 'end ' + convert(nvarchar(30), getdate(), 121)
  END;




