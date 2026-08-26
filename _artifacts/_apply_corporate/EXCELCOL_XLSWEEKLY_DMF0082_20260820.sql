-- EXCELCOL_XLSWEEKLY_DMF0082_20260820.sql — [E20260820-XLSWEEKLY] DMF0082 업로드 헤더 계약 = 1단 동적 주차
--   기간 토큰 M4~M16 제거 (기간 컬럼 = 주 시작일 YYYYMMDD 헤더를 BE FileServiceImpl 이 동적 인식 — DMF0014 계보).
--   식별 10토큰만 유지. stale 기간 토큰은 프레임워크가 자동 제외하지만 계약 명확화를 위해 제거.
--   BACKUP(원복용): 아래 주석의 구 HEADER_CONTENT 원문.
--   구: Div|End Customer|Sales Site|Model|Incoterms|FCST Type|Customs Handbook|Cell Prod Site|Currency|Measure|M4|M5|M6|M7|M8|M9|M10|M11|M12|M13|M14|M15|M16

UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS
SET    HEADER_CONTENT = 'Div|End Customer|Sales Site|Model|Incoterms|FCST Type|Customs Handbook|Cell Prod Site|Currency|Measure'
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
WHERE  PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice';

COMMIT;
