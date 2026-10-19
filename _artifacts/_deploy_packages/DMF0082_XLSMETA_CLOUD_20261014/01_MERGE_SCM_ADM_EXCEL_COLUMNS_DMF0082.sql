-- ============================================================================
-- DMF0082_XLSMETA_CLOUD_20261014 / SCM_ADM_EXCEL_COLUMNS — DMF0082 Excel Upload 메타 1행 (멱등 MERGE)
-- ----------------------------------------------------------------------------
-- 증상 : 클라우드 DMF0082 Excel Upload → "Error excelFileUplad: [WARN] excelFileUplad: Not exist ExcelUpload Data."
-- 원인 : BE admin.excel.selectExcelInfo (PROGRAM_ID=#{mnuId} AND SHEET_NAME=#{shtNm})
--        = ('DMF0082','FcstNPrice') 행이 클라우드에 없음 (사용자 클라우드 조회 0건 확인 2026-10-14).
--        09-08·09-21 이관 SQL 은 UPDATE 만 수행 → 행 부재 시 0건 반영으로 누락이 드러나지 않았다.
-- 원천 : 사내오라클 ZIOUI1 (59.19.252.148, SERVER_HOST=localhost) SCM_MGR.SCM_ADM_EXCEL_COLUMNS 실측
--        SOURCE-FRESH: TABLE SCM_MGR.SCM_ADM_EXCEL_COLUMNS ROW(DMF0082,FcstNPrice) FETCHED=2026-10-14 12:07 (24h)
--        STORAGE_SQL_ID = PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD / OPTION_ATTRIBUTE_COLUMN_NUMBER = 70 / VALID_YN = Y
--        HEADER_CONTENT = 19 토큰 (AS-IS DMF0020 'Sales Price' 와 바이트 동일, LENGTH 91)
--        ATTRIBUTE1~10 · XLS_COLUMN_CODE_MATCH = NULL
-- 키   : 테이블에 PK/UK/고유 인덱스 없음(사내 실측) → BE 조회 키 PROGRAM_ID + SHEET_NAME 로 MERGE.
-- 멱등 : 없으면 INSERT / 있으면 값이 다를 때만 UPDATE (재실행 시 0건). 삭제 없음.
-- 실행 : 파일 전체 F5 그대로 실행 (바인드·치환 변수 없음).
-- ============================================================================

-- [0] 사전 확인 — 실행 전 상태 (0건이면 INSERT 대상)
SELECT 'BEFORE' AS STEP, COUNT(*) AS CNT
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
 WHERE PROGRAM_ID = 'DMF0082'
   AND SHEET_NAME = 'FcstNPrice';

-- [0-1] 검증 SP 존재 확인 — 1건이어야 업로드 검증이 실행된다 (0건이면 PKG_DMF0082 배포 먼저)
SELECT 'VALID_PROC' AS STEP, COUNT(*) AS CNT
  FROM ALL_PROCEDURES
 WHERE OWNER = 'SCM_MGR'
   AND OBJECT_NAME = 'PKG_DMF0082'
   AND PROCEDURE_NAME = 'P_DMF0082_EXCEL_UPLOAD';

-- [1] MERGE
MERGE INTO SCM_MGR.SCM_ADM_EXCEL_COLUMNS T
USING (
    SELECT 'DMF0082'                                                                                    AS PROGRAM_ID
         , 'FcstNPrice'                                                                                 AS SHEET_NAME
         , 'PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD'                                                         AS STORAGE_SQL_ID
         , 'Div|Team|End Customer|Project Code|Currency|Model|M0|M1|M2|M3|M4|M5|M6|M7|M8|M9|M10|M11|M12' AS HEADER_CONTENT
         , 70                                                                                           AS OPTION_ATTRIBUTE_COLUMN_NUMBER
         , 'Y'                                                                                          AS VALID_YN
      FROM DUAL
) S
   ON (    T.PROGRAM_ID = S.PROGRAM_ID
       AND T.SHEET_NAME = S.SHEET_NAME )
 WHEN MATCHED THEN
      UPDATE SET T.STORAGE_SQL_ID                 = S.STORAGE_SQL_ID
               , T.HEADER_CONTENT                 = S.HEADER_CONTENT
               , T.OPTION_ATTRIBUTE_COLUMN_NUMBER = S.OPTION_ATTRIBUTE_COLUMN_NUMBER
               , T.VALID_YN                       = S.VALID_YN
               , T.LAST_UPDATED_BY                = 'admin'
               , T.LAST_UPDATE_DATE               = SYSDATE
       WHERE T.STORAGE_SQL_ID                 <> S.STORAGE_SQL_ID
          OR T.HEADER_CONTENT                 <> S.HEADER_CONTENT
          OR T.OPTION_ATTRIBUTE_COLUMN_NUMBER <> S.OPTION_ATTRIBUTE_COLUMN_NUMBER
          OR T.VALID_YN                       <> S.VALID_YN
 WHEN NOT MATCHED THEN
      INSERT ( PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT
             , OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN
             , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
      VALUES ( S.PROGRAM_ID, S.SHEET_NAME, S.STORAGE_SQL_ID, S.HEADER_CONTENT
             , S.OPTION_ATTRIBUTE_COLUMN_NUMBER, S.VALID_YN
             , 'admin', SYSDATE, 'admin', SYSDATE );

COMMIT;

-- [2] 사후 검증 — CNT = 1 / HEADER_OK = 1 / TOKENS = 19 / ASIS_MATCH = 1 이어야 한다
SELECT 'AFTER' AS STEP
     , COUNT(*) AS CNT
     , MAX(STORAGE_SQL_ID) AS STORAGE_SQL_ID
     , MAX(CASE WHEN HEADER_CONTENT = 'Div|Team|End Customer|Project Code|Currency|Model|M0|M1|M2|M3|M4|M5|M6|M7|M8|M9|M10|M11|M12'
                THEN 1 ELSE 0 END) AS HEADER_OK
     , MAX(REGEXP_COUNT(HEADER_CONTENT, '\|') + 1) AS TOKENS
     , MAX(VALID_YN) AS VALID_YN
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
 WHERE PROGRAM_ID = 'DMF0082'
   AND SHEET_NAME = 'FcstNPrice';

SELECT 'ASIS_MATCH' AS STEP
     , CASE WHEN A.HEADER_CONTENT = B.HEADER_CONTENT THEN 1 ELSE 0 END AS ASIS_MATCH
  FROM (SELECT HEADER_CONTENT FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
         WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice') A
     , (SELECT HEADER_CONTENT FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
         WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price') B;
