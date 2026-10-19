
/*
 * Program ID   : PR_SCM_MST_SLOC
 * Description  : SLOC Master I/F
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.07   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.08.08   Kim Jihye      valid_yn = 'N' 처리 로직 수정 (기존 일괄 I/F 에서 국내, 해외 분리 I/F로 변경에 따름)
 * 2020.11.09   KSG            [B Project] G260 -> Lookup 'SALES_PLANT' 사용하도록 수정
 * 2021.10.20   HWI1993        [C20211018-000316] ESS 사업부 MI판매법인 Sales Loctaion수정 관련의 건
 * 2022.02.18   sclee.lee      [PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선] - scm_mst_sloc의 valid_yn을 Attribute1에 저장
 * 2023.10.25   vadabi3        E20231024-000605 저장위치 신규등록/변경 시 S.LOC Mailing기능개선을 위한 프로그램수정 - 항목추가 (요청/재고담당)
                                                ATTRIBUTE1 = 요청자 / ATTRIBUTE2 = 요청부서 / ATTRIBUTE3 = 재고담당자 / ATTRIBUTE4 = 재고담당부서
 *                                              SCM_MST_SLOC_H) Attribute 변경은 입력 대상에서 제외
 * 2024.01.25   vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.05.27   vadabi5        NERP) QA, 개발 DB 적용
 * 2025.06.19   김준규         [IT20250117A] NERP 오펀차수별 Mapping Code적용
 ----------------------------------------------------------------------------------------------------

 EXEC NERP_PR_SCM_MST_SLOC
 EXEC      PR_SCM_MST_SLOC
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_SLOC]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_SLOC';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_history_seq      BIGINT;
    DECLARE @v_ifseqno     NVARCHAR(30); -- 누락된 전체 데이터 insert

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

    BEGIN TRY
      BEGIN
      --BEGIN TRANSACTION
         -- 인터페이스 테이블 처리 ROW UPDATE

        UPDATE xif_erp_sloc_r_sn
        SET    transfer_flag = 'P'
        WHERE  ISNULL(transfer_flag,'N') = 'N'
        -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 Start
        -- OLD 코드는 반영이 되지 않게 처리
        AND    NOT EXISTS ( SELECT 1
                            FROM   NERP_CONV_MASTER ncm WITH(NOLOCK)
                            WHERE  NCM.CODETYPE = 'PLANT_ID'
                            AND    NCM.OLD_VALUE1 = XIF_ERP_SLOC_R_SN.PLANT_ID
                            AND    NCM.ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE
                          );
        -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 End

        -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
        DECLARE CUR_ERP_SLOC CURSOR FOR
          SELECT ifseqno
          FROM   xif_erp_sloc_r_sn WITH(NOLOCK)
          WHERE  transfer_flag = 'P'
          GROUP BY ifseqno
          ORDER BY ifseqno ASC;

        -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
        IF OBJECT_ID('dbo.scm_mst_sloc_temp$') IS NOT NULL DROP TABLE scm_mst_sloc_temp$

        SELECT *
        INTO   scm_mst_sloc_temp$
        FROM   scm_mst_sloc WITH(NOLOCK);

        OPEN CUR_ERP_SLOC;
        FETCH NEXT FROM CUR_ERP_SLOC INTO @v_ifseqno ;

        WHILE (@@FETCH_STATUS = 0)
        BEGIN

          --------------------------------------------------------------------
          -- 2018.08.08 valid_yn = 'N' 처리 로직 수정
          --------------------------------------------------------------------
          UPDATE scm_mst_sloc
          SET    valid_yn = 'N'
          FROM   scm_mst_sloc ms
          JOIN  (
                 SELECT distinct plant_id AS plant_id
                 FROM   xif_erp_sloc_r_sn WITH(NOLOCK)
                 WHERE  ifseqno       = @v_ifseqno
                 AND    transfer_flag = 'P'
                 ) xif
          ON    ms.plant_id = xif.plant_id;

          MERGE INTO scm_mst_sloc A
          USING (
                SELECT /*PR_SCM_MST_SLOC*/
                        B.division_id AS division_id
                       ,C.plant_id
                       ,C.storage_id
                       ,C.storage_description
                       ,C.ATTRIBUTE1
                       ,C.ATTRIBUTE2
                       ,C.ATTRIBUTE3
                       ,C.ATTRIBUTE4
                FROM xif_erp_sloc_r_sn C WITH(NOLOCK)
                INNER JOIN scm_mst_plant_sn B WITH(NOLOCK)
                ON C.plant_id = B.plant_id
                WHERE C.ifseqno = @v_ifseqno
                AND transfer_flag = 'P'
               ) B
          ON(
                           A.division_id  = B.division_id
                       AND A.storage_id   = B.storage_id
                       AND A.plant_id     = B.plant_id
           )
          WHEN MATCHED THEN
             UPDATE SET
                        A.storage_description  =  B.storage_description
                       ,A.valid_yn             =  'Y'
                       ,A.last_updated_by      =  @v_batch_user
                       ,A.last_update_date     =  GETDATE()
                       ,A.ATTRIBUTE1  =  B.ATTRIBUTE1
                       ,A.ATTRIBUTE2  =  B.ATTRIBUTE2
                       ,A.ATTRIBUTE3  =  B.ATTRIBUTE3
                       ,A.ATTRIBUTE4  =  B.ATTRIBUTE4

          WHEN NOT MATCHED THEN
             INSERT (
                         division_id
                        ,storage_id
                        ,plant_id
                        ,storage_description
                        ,valid_yn
                        ,created_by
                        ,creation_date
                        ,last_updated_by
                        ,last_update_date
                       ,ATTRIBUTE1
                       ,ATTRIBUTE2
                       ,ATTRIBUTE3
                       ,ATTRIBUTE4
                    )
             VALUES (
                        B.division_id
                       ,B.storage_id
                       ,B.plant_id
                       ,B.storage_description
                       ,'Y'
                       ,@v_batch_user
                       ,GETDATE()
                       ,@v_batch_user
                       ,GETDATE()
                       ,B.ATTRIBUTE1
                       ,B.ATTRIBUTE2
                       ,B.ATTRIBUTE3
                       ,B.ATTRIBUTE4
                    )
            ;

            --------------------------------------------------------------------
            -- G260/G690 판매 법인 데이터 처리
            --------------------------------------------------------------------
            MERGE INTO scm_mst_sloc A
             USING (
                    SELECT /*PR_SCM_MST_SLOC  - G260 판매 법인 데이터 처리*/
                           '0' AS division_id
                           ,C.plant_id
                           ,C.storage_id
                           ,C.storage_description
                           ,C.ATTRIBUTE1
                           ,C.ATTRIBUTE2
                           ,C.ATTRIBUTE3
                           ,C.ATTRIBUTE4
                    FROM   xif_erp_sloc_r_sn C WITH(NOLOCK)
                    WHERE  C.ifseqno = @v_ifseqno
                    AND    transfer_flag = 'P'
                    -- 20201109 [B Project] G260 -> Lookup 'SALES_PLANT' 사용하도록 수정
                    --AND    plant_id = 'G260'
                    AND    plant_id IN (
                                       SELECT segment1
                                       FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                       WHERE  lookup_type = 'SALES_PLANT'
                                       AND    valid_yn    = 'Y'

                                       UNION ALL        -- [C20211018-000316]
                                       SELECT SEGMENT2  -- G389
                                         FROM SCM_CODE_LOOKUP_VALUE
                                        WHERE LOOKUP_TYPE_CODE = 'PR_SCM_MST_SLOC'
                                          AND SEGMENT1 = 'PLANT_ID'
                                      )
                    ) B
            ON(
                               A.division_id  = B.division_id
                           AND A.storage_id   = B.storage_id
                           AND A.plant_id     = B.plant_id
               )
            WHEN MATCHED THEN
                 UPDATE SET
                            A.storage_description  =  B.storage_description
                           ,A.valid_yn             =  'Y'
                           ,A.last_updated_by      =  @v_batch_user
                           ,A.last_update_date     =  GETDATE()
                           ,A.ATTRIBUTE1  =  B.ATTRIBUTE1
                           ,A.ATTRIBUTE2  =  B.ATTRIBUTE2
                           ,A.ATTRIBUTE3  =  B.ATTRIBUTE3
                           ,A.ATTRIBUTE4  =  B.ATTRIBUTE4

            WHEN NOT MATCHED THEN
                 INSERT (
                             division_id
                            ,storage_id
                            ,plant_id
                            ,storage_description
                            ,valid_yn
                            ,created_by
                            ,creation_date
                            ,last_updated_by
                            ,last_update_date
                            ,ATTRIBUTE1
                            ,ATTRIBUTE2
                            ,ATTRIBUTE3
                            ,ATTRIBUTE4
                        )
                 VALUES (
                            B.division_id
                           ,B.storage_id
                           ,B.plant_id
                           ,B.storage_description
                           ,'Y'
                           ,@v_batch_user
                           ,GETDATE()
                           ,@v_batch_user
                           ,GETDATE()
                           ,B.ATTRIBUTE1
                           ,B.ATTRIBUTE2
                           ,B.ATTRIBUTE3
                           ,B.ATTRIBUTE4
                        )
                ;

            -- Transfer_flag 처리
            UPDATE xif_erp_sloc_r_sn
            SET    transfer_flag  =  'Y'
            FROM   xif_erp_sloc_r_sn A WITH(NOLOCK)
            JOIN   scm_mst_sloc B WITH(NOLOCK)
            ON     A.storage_id   = B.storage_id
            AND    A.plant_id     = B.plant_id
            WHERE  A.ifseqno      =  @v_ifseqno;

            -- 2018.08.08 valid_yn = 'N' 처리 로직 수정
            -- Valid_yn 처리
            /*
            UPDATE scm_mst_sloc
            SET    valid_yn  =  'N'
            WHERE  storage_id + plant_id not IN (SELECT storage_id+plant_id FROM XIF_ERP_SLOC_R_SN WITH(NOLOCK) WHERE ifseqno   =  @v_ifseqno);
            */
            -----------------------------------------------------------
            -- Merge LOG
            -----------------------------------------------------------

            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'APPEND';
            SET @v_log_message = 'MERGE INTO scm_mst_sloc';
            SET @v_description = 'ifseqno = ' + @v_ifseqno;
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
            -----------------------------------------------------------

        FETCH NEXT FROM CUR_ERP_SLOC INTO  @v_ifseqno

        END

        CLOSE CUR_ERP_SLOC;
        DEALLOCATE CUR_ERP_SLOC;
        -- 처리 한 row 마킹
        UPDATE xif_erp_sloc_r_sn
        SET    transfer_flag = 'X'
        WHERE  transfer_flag = 'P'

        -- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
        SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_SLOC_H

            -- 20231025) Attribute1~4 항목 변경은 History 입력 대상에서 제외
            INSERT INTO [dbo].[scm_mst_sloc_h] (
               history_seq
              ,division_id
              ,plant_id
              ,storage_id
              ,storage_description
              ,attribute1 -- scm_mst_sloc의 valid_yn을 Attribute1에 저장
              ,creation_date
              ,last_update_date
              ,last_updated_by
              ,created_by
              ,history_creation_date
           )
            SELECT    @n_history_seq
                      ,A.*
                      ,GETDATE()
                      ,@v_batch_user
                      ,@v_batch_user
                      ,GETDATE()
            FROM
                  (
                 SELECT A.*,B.last_update_date FROM (
                 SELECT
                       division_id
                      ,plant_id
                      ,storage_id
                      ,storage_description
                      ,valid_yn
                  FROM [dbo].[scm_mst_sloc_temp$] WITH(NOLOCK)
                  EXCEPT
                  SELECT
                       division_id
                      ,plant_id
                      ,storage_id
                      ,storage_description
                      ,valid_yn
                  FROM [dbo].[scm_mst_sloc] WITH(NOLOCK)
                  ) A INNER JOIN [dbo].[scm_mst_sloc_temp$] B WITH(NOLOCK)
                  ON A.division_id = B.division_id
                  AND A.plant_id   = B.plant_id
                  AND A.storage_id = B.storage_id

                  -- scm_mst_sloc의 valid_yn까지도 비교대상에 포함
                  AND ISNULL(A.valid_yn, '') = ISNULL(B.valid_yn, '')
                  ) A

        SET @n_log_count = @@ROWCOUNT;

        DROP TABLE scm_mst_sloc_temp$;

        -- HISTORY LOG
        SET @v_log_type = 'HISTORY';
        SET @v_log_message = 'INSERT INTO scm_mst_sloc_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -- 처리 한 row 마킹
        UPDATE [XIF_ERP_SLOC_R_SN]SET transfer_flag = 'Y' WHERE transfer_flag = 'P';

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;
      END;
    --COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
          BEGIN
            ROLLBACK;
          END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;


