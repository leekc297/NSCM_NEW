
/*  
 * Program ID   : SCP0049_CAPA_LIMITS_VALID  
 * Description  : CAPA Limits Validation
 * Program History  
 *===========================================================================================================  
 *   Date       In Charge   Description  
 *===========================================================================================================  
 * 2026.08.07   SYngSn      Initial Creation
 */  

CREATE PROCEDURE [dbo].[SCP0049_CAPA_LIMITS_VALID]  
    @p_mode         INT,  
    @p_created_by   NVARCHAR(150)  
AS  
BEGIN  
    SET NOCOUNT ON;  

    -- 기본 변수 설정  
    DECLARE @v_program_id     NVARCHAR(40) = 'SCP0049';  
    DECLARE @v_sheet_name     NVARCHAR(40) = 'CAPA_LIMITS';  
    DECLARE @v_creation_date  NVARCHAR(40);  
    DECLARE @v_count          INT;  

    -- LOG 용 변수 설정  
    DECLARE @v_program_name   NVARCHAR(150) = 'SCP0049_CAPA_LIMITS_VALID';  
    DECLARE @v_log_type       NVARCHAR(30); 
    DECLARE @n_log_count      INT           = 0;  
    DECLARE @v_log_message    NVARCHAR(1000);  
    DECLARE @v_description    NVARCHAR(500);  
    DECLARE @d_event_date     DATETIME;  

    -- [시작 로그 기록]
    SET @v_log_type    = 'START';  
    SET @v_log_message = '########## Start of procedure ##########';  
    SET @v_description = '';  
    SET @d_event_date  = SYSDATETIME();  

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  

    -- 최근 업로드 생성 일자 조회
    SELECT @v_creation_date = CONVERT(NVARCHAR(40), MAX(T.CREATION_DATE), 121)  
      FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T WITH (NOLOCK)
     WHERE T.PROGRAM_ID = @v_program_id  
       AND T.SHEET_NAME = @v_sheet_name  
       AND T.CREATED_BY = @p_created_by;  

    -- 업로드 데이터가 없는 경우 종료 처리
    IF @v_creation_date IS NULL 
    BEGIN  
        SET @v_log_type    = 'END';  
        SET @v_log_message = '########## END of procedure ##########';  
        SET @v_description = 'Data Not Found [' + ISNULL(CONVERT(CHAR(19), @v_creation_date, 121), '') + ']';  
        SET @d_event_date  = SYSDATETIME();  

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
        RETURN;
    END;  

    -- Validation 및 결과 Update
    BEGIN  
        WITH CTE_CALC_EXCEEDED AS (
            SELECT 
                A.PROGRAM_ID
              , A.SHEET_NAME
              , A.CREATED_BY
              , A.CREATION_DATE
              , A.UPLOAD_STATUS_CODE
              , A.MESSAGE_TEXT
              
              -- IS_EXCEEDED 동적 메세지 산출 로직
              , CASE 
                    WHEN ISNULL(B.MAX_TACT_TIME, 0) = 0 THEN  'SUCCESS' --'N/A: Average Tact Time is 0'
                    WHEN ISNULL(CA1.TOLERANCE_PERCENT_LOOKUP, 0) = 0 THEN 'SUCCESS' --'NO TOLERANCE_PERCENT_LOOKUP: Tolerance value missing'
                    WHEN CA1.INPUT_TACT_TIME IS NULL THEN 'ERROR: Invalid Tact Time format'                   
                    
                    -- 화면 표기와 동일하게 소수점 2자리(DECIMAL)로 정제된 값으로 범위 비교
                    WHEN CA2.TACT_TIME < CA2.MIN_ALLOWED OR CA2.TACT_TIME > CA2.MAX_ALLOWED THEN 
                        'Out of range ' 
                        -- 오차율 (%)
                        --+ CONVERT(VARCHAR, CAST(ROUND(((CA1.INPUT_TACT_TIME - B.AVG_TACT_TIME) / B.AVG_TACT_TIME) * 100, 1) AS DECIMAL(18, 1))) + '% '
                        -- Allowed range: 조건 판정에 사용된 하한/상한값 표기
                        + '(Allowed: ' 
                        + CONVERT(VARCHAR, CA2.MIN_ALLOWED) 
                        + '-' 
                        + CONVERT(VARCHAR, CA2.MAX_ALLOWED) 
                        + ')'

                    ELSE 'SUCCESS'
                END AS IS_EXCEEDED

            FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] A 

            -- B 테이블: 조건별 TACT_TIME 평균 집계
            LEFT JOIN (
                SELECT  
                    COMPANY_ID 
                  , DIVISION_ID	
                  , SITE_ID 
                  , PLANT_ID 
                  , FACTORY_ID 
                  , OPERATION_ID 
                  , LINE_ID 
                  , ELECTRODE_TYPE
                  --, AVG(TACT_TIME) AS AVG_TACT_TIME
                  --, AVG(DAILY_CAPA) AS AVG_DAILY_CAPA
                  , MIN(TACT_TIME) AS MIN_TACT_TIME
                  , MAX(TACT_TIME) AS MAX_TACT_TIME
                  , MIN(DAILY_CAPA) AS MIN_DAILY_CAPA
                  , MAX(DAILY_CAPA) AS MAX_DAILY_CAPA
                FROM SCM_MST_TACT_TIME_SN WITH (NOLOCK)
                WHERE 1=1
                  --AND TACT_TIME <> 0
                  AND MONTH >= LEFT(CONVERT(VARCHAR(8), GETDATE(), 112), 6) --이번달 이후만 집계
                GROUP BY 
                    COMPANY_ID	 
                  , DIVISION_ID	
                  , SITE_ID		
                  , PLANT_ID		
                  , FACTORY_ID		
                  , OPERATION_ID	
                  , LINE_ID		
                  , ELECTRODE_TYPE
                   --HAVING COUNT(LINE_ID) > 10 --표본 값이 몇개는 있어야 하지 않나?
            ) B 
              ON A.ATTRIBUTE2 = B.COMPANY_ID
             AND A.ATTRIBUTE1 = B.DIVISION_ID
             AND A.ATTRIBUTE3 = B.SITE_ID
             AND A.ATTRIBUTE4 = B.PLANT_ID
             AND A.ATTRIBUTE5 = B.FACTORY_ID
             AND A.ATTRIBUTE7 = B.OPERATION_ID
             AND A.ATTRIBUTE6 = B.LINE_ID
             AND A.ATTRIBUTE8 = B.ELECTRODE_TYPE

            -- C 테이블: 허용 오차율(%) Lookup 조인
            LEFT JOIN SCM_ADM_LOOKUP_VALUE_FP_SN C WITH (NOLOCK)
              ON C.LOOKUP_TYPE_CODE = 'CAPA_UI_CAPA_DEFINIT'
             AND C.SEGMENT2 = A.ATTRIBUTE4  -- PLANT_ID
             AND C.SEGMENT3 = A.ATTRIBUTE7  -- OPERATION_ID

            -- [CROSS APPLY 1] FLOAT 원본 타입 변환
            CROSS APPLY (
                SELECT 
                    TRY_CAST(A.ATTRIBUTE14 AS FLOAT) AS INPUT_TACT_TIME,
                    TRY_CAST(C.ATTRIBUTE3 AS FLOAT)  AS TOLERANCE_PERCENT_LOOKUP
            ) CA1

            -- [CROSS APPLY 2] 비교 및 표기에 사용할 소수점 자리수(소수점 2자리) 통일 규격화
            CROSS APPLY (
                SELECT 
                    CAST(CA1.INPUT_TACT_TIME AS DECIMAL(18, 2)) AS TACT_TIME,
                    CASE WHEN C.ATTRIBUTE1 ='TACT TIME'  THEN CAST((B.MIN_TACT_TIME  * (1.0 - CA1.TOLERANCE_PERCENT_LOOKUP / 100.0)) AS DECIMAL(18, 2)) 
                         WHEN C.ATTRIBUTE1 ='DAILY CAPA' THEN CAST((B.MIN_DAILY_CAPA * (1.0 - CA1.TOLERANCE_PERCENT_LOOKUP / 100.0)) AS DECIMAL(18, 2)) END AS MIN_ALLOWED,
                    CASE WHEN C.ATTRIBUTE1 ='TACT TIME'  THEN CAST((B.MAX_TACT_TIME  * (1.0 + CA1.TOLERANCE_PERCENT_LOOKUP / 100.0)) AS DECIMAL(18, 2))
                         WHEN C.ATTRIBUTE1 ='DAILY CAPA' THEN CAST((B.MAX_DAILY_CAPA * (1.0 + CA1.TOLERANCE_PERCENT_LOOKUP / 100.0)) AS DECIMAL(18, 2)) END AS MAX_ALLOWED
            ) CA2

            -- 대상 변수 조건
            WHERE A.PROGRAM_ID                          = @v_program_id  
              AND A.SHEET_NAME                          = @v_sheet_name  
              AND A.CREATED_BY                          = @p_created_by  
              AND CONVERT(NVARCHAR(40), A.CREATION_DATE, 121) = @v_creation_date  
              AND A.UPLOAD_STATUS_CODE                  = 'UPLOAD'
        )
        -- SUCCESS가 아닌 대상 건에 대해 MESSAGE_TEXT 업데이트 및 STATUS를 ERROR로 변경 
        UPDATE CTE_CALC_EXCEEDED
           SET UPLOAD_STATUS_CODE = CASE WHEN IS_EXCEEDED <> 'SUCCESS' THEN 'ERROR' ELSE IS_EXCEEDED END,
               MESSAGE_TEXT       = IS_EXCEEDED;

        SET @v_log_type    = 'UPDATE';  
        SET @n_log_count   = @n_log_count + 1;  
        SET @v_log_message = '########## SUCCESS ##########';  
        SET @v_description = CONVERT(NVARCHAR(50), @@ROWCOUNT);  
        SET @d_event_date  = SYSDATETIME();  

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
    END;  

    -- ERROR 건수 확인
    SELECT @v_count = COUNT(1)  
      FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T WITH (NOLOCK)  
     WHERE T.PROGRAM_ID         = @v_program_id  
       AND T.SHEET_NAME         = @v_sheet_name  
       AND T.CREATED_BY         = @p_created_by  
       AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date  
       AND T.UPLOAD_STATUS_CODE = 'ERROR';  

    -- [종료 로그 기록]
    BEGIN  
        SET @v_log_type    = 'END';  
        SET @n_log_count   = @n_log_count + 1;  
        SET @v_log_message = '########## END of procedure ##########';  
        SET @v_description = 'Error Count: ' + CONVERT(NVARCHAR(10), @v_count);  
        SET @d_event_date  = SYSDATETIME();  

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
    END;  
END;
