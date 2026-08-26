-- ============================================================================================
-- DMF0014 Excel Upload 배선 메타 정합 — 클라우드 실오류 2건 해소 (2026-08-23, 진단 결과 반영본)
--
--   ① PLS-00201: identifier 'DMF0014_CUST_FCST_EXCEL_UPLOAD' must be declared
--   ② 전건 ERROR 'Invalid Measure Upload Bucket.'
--
-- ## 원인 = 둘 다 `SCM_ADM_EXCEL_COLUMNS` 1행의 값이 사내와 다르다 (클라우드 진단 실측 2026-08-23)
-- BE 는 이 메타를 그대로 소비한다 — 프로시저명도, 엑셀 컬럼 순서도.
--     FileServiceImpl : validProc = excelInfo.get("STORAGE_SQL_ID")  → { CALL ${validProc}(5-arg) }
--                       headerContent = excelInfo.get("HEADER_CONTENT")
--                       → cvtListUploadRows(excelList, headerContent) 로 **엑셀 열 → ATTRIBUTEn 슬롯** 결정
--
-- ### ② 의 실제 원인 (당초 NLS·서식 가설은 진단으로 **기각**됨)
--   클라우드 D0 = 사내와 동일(NLS_NUMERIC_CHARACTERS='.,')  → NLS 축 아님
--   클라우드 D1 = 헤더 '20260810' 순수 8자리                → 서식 축 아님
--   클라우드 D2 = 종전 채택 조건 통과(1행)                   → 파싱 축 아님
--   클라우드 D5 = **MASTER_HIT = 0 (10개 조합 전부)** · ATTRIBUTE10 = 'PACK'/'MODULE'/'CELL'
--   ⇒ 사내 스테이징 실측: ATTRIBUTE9='CUST_FCST'(Measure Group) / ATTRIBUTE10='Customer FCST'(Measure)
--     / **ATTRIBUTE11='PACK'(Upload UOM)**. 즉 클라우드의 ATTRIBUTE10 값은 **Upload UOM** 이다.
--     ⇒ 클라우드 매핑이 **왼쪽으로 한 칸** 밀렸다(Upload UOM 이 11 이 아니라 10 에 안착).
--       = HEADER_CONTENT 에 Upload UOM 앞 토큰 하나가 **없다**(가장 유력 = 'Customs Handbook*', 후기 추가분).
--     그 상태로 `D.MEASURE = AEU.ATTRIBUTE10` 을 보니 영원히 NOT EXISTS → 전건 'Invalid Measure Upload Bucket.'
--   ⚠ 단, 같은 증상을 **클라우드 BE 구버전**(cvtListUploadRows 매핑 상이)도 만든다.
--     [1b] 에서 SLOT10 이 'Measure*' 로 정상인데 스테이징엔 UOM 값이 들어 있으면 → 메타가 아니라 **BE 빌드** 문제.
--
-- 사내 정본 매핑 (18토큰): 1 Division* / 2 Sales Site* / 3 Plant Site* / 4 Customer Project* /
--   5 Customer Model* / 6 Incoterms* / 7 FCST Type* / 8 Customs Handbook* / 9 Measure Group* /
--   10 Measure* / 11 Upload UOM* / 12 Project / 13 Model / 14~18 W27~W31
--
-- ## 조치 = 그 1행을 사내 정본으로 동기화 (STORAGE_SQL_ID + HEADER_CONTENT + 옵션열수)
-- ⚠ 적용 후에는 **Excel Form 을 새로 내려받아** 그 파일로 업로드해야 한다.
--   기존에 받아 둔 파일은 옛 컬럼 순서라 그대로 올리면 같은 증상이 재발한다.
-- ============================================================================================

PROMPT ===== [1] 적용 전 현황 — 무엇이 다른지 눈으로 확인 =====
SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID,
       REGEXP_COUNT(HEADER_CONTENT,'[|]') + 1 AS TOKEN_CNT,
       OPTION_ATTRIBUTE_COLUMN_NUMBER AS OPT_COL, VALID_YN
FROM   SCM_MGR.SCM_ADM_EXCEL_COLUMNS
WHERE  PROGRAM_ID LIKE 'DMF0014%';
-- 사내 정본: STORAGE_SQL_ID='PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD' / TOKEN_CNT=18 / OPT_COL=70

PROMPT ----- [1b] 토큰을 슬롯과 함께 펼쳐 본다 (어느 칸이 밀렸는지) -----
SELECT LEVEL AS SLOT, 'ATTRIBUTE' || LEVEL AS ATTR,
       REGEXP_SUBSTR(HEADER_CONTENT, '[^|]+', 1, LEVEL) AS TOKEN
FROM   SCM_MGR.SCM_ADM_EXCEL_COLUMNS
WHERE  PROGRAM_ID = 'DMF0014'
CONNECT BY LEVEL <= REGEXP_COUNT(HEADER_CONTENT, '[|]') + 1;
-- 기대(사내 정본): SLOT 9 = 'Measure Group*' , SLOT 10 = 'Measure*'
-- 클라우드가 SLOT 10 = 'Measure Group*' 이면 = 한 칸 밀림 = ② 의 원인

PROMPT ===== [2] 호출 대상 객체 실존·인자수 대조 =====
SELECT 'DMF0014_CUST_FCST_EXCEL_UPLOAD (구 단독)' AS TARGET,
       (SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
         AND OBJECT_NAME='DMF0014_CUST_FCST_EXCEL_UPLOAD' AND OBJECT_TYPE='PROCEDURE') AS EXISTS_CNT,
       (SELECT COUNT(*) FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME IS NULL
         AND OBJECT_NAME='DMF0014_CUST_FCST_EXCEL_UPLOAD') AS ARG_CNT
FROM DUAL
UNION ALL
SELECT 'PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD (정본)',
       (SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
         AND OBJECT_NAME='PKG_DMF0014' AND OBJECT_TYPE='PACKAGE BODY'),
       (SELECT COUNT(*) FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0014'
         AND OBJECT_NAME='P_DMF0014_CUST_FCST_EXCEL_UPLOAD')
FROM DUAL;
-- 정본 ARG_CNT = 5 (P_MODE/P_CREATED_BY/P_PROGRAM_ID/P_SHEET_NAME/O_RESULT_CURSOR) = XML 5-arg CALL 과 1:1
-- ⚠ 구 단독 SP 는 사내에서도 3-arg·INVALID — 되살리는 방향은 오답이다.

PROMPT ===== [3] 정정 — 사내 정본으로 동기화 (멱등) =====
UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS
SET    STORAGE_SQL_ID   = 'PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD'
      ,HEADER_CONTENT   = 'Division*|Sales Site*|Plant Site*|Customer Project*|Customer Model*|Incoterms*|FCST Type*|Customs Handbook*|Measure Group*|Measure*|Upload UOM*|Project|Model|W27|W28|W29|W30|W31'
      ,OPTION_ATTRIBUTE_COLUMN_NUMBER = 70
      ,VALID_YN         = 'Y'
      ,LAST_UPDATED_BY  = 'admin'
      ,LAST_UPDATE_DATE = SYSDATE
WHERE  PROGRAM_ID = 'DMF0014'
AND    (NVL(STORAGE_SQL_ID,'-') <> 'PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD'
     OR NVL(HEADER_CONTENT,'-') <> 'Division*|Sales Site*|Plant Site*|Customer Project*|Customer Model*|Incoterms*|FCST Type*|Customs Handbook*|Measure Group*|Measure*|Upload UOM*|Project|Model|W27|W28|W29|W30|W31'
     OR NVL(OPTION_ATTRIBUTE_COLUMN_NUMBER,-1) <> 70);

COMMIT;

PROMPT ===== [4] 검증 (기대: RESULT = PASS · SLOT9=Measure Group* · SLOT10=Measure*) =====
SELECT PROGRAM_ID, SHEET_NAME,
       CASE WHEN STORAGE_SQL_ID = 'PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD'
             AND REGEXP_SUBSTR(HEADER_CONTENT,'[^|]+',1,9)  = 'Measure Group*'
             AND REGEXP_SUBSTR(HEADER_CONTENT,'[^|]+',1,10) = 'Measure*'
            THEN 'PASS' ELSE 'FAIL ⛔' END AS RESULT,
       REGEXP_COUNT(HEADER_CONTENT,'[|]') + 1 AS TOKEN_CNT
FROM   SCM_MGR.SCM_ADM_EXCEL_COLUMNS
WHERE  PROGRAM_ID = 'DMF0014';

PROMPT ===== [5] 적용 후 필수 절차 (SQL 아님 — 사람이 할 일) =====
-- 1) 화면에서 **Excel Form 을 새로 다운로드** 한다 (기존 파일은 옛 컬럼 순서 → 같은 증상 재발).
-- 2) 새 파일로 Upload → 'Invalid Measure Upload Bucket.' 이 사라지는지 확인.
-- 3) 그래도 남으면 00B_DIAG_BUCKET.sql 의 D5 를 다시 떠서 MASTER_HIT 를 본다
--    (0 이면 여전히 축 불일치 = 파일이 옛 양식이거나 마스터에 그 site/measure 가 없음).
