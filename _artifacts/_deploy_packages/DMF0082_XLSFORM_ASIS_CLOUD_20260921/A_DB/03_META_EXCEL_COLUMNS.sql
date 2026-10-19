-- [E20260921-XLSFORMASIS] 메타 B — DMF0082 Excel Upload 헤더 토큰을 AS-IS DMF0020 과 1:1 정렬
--
-- 근거(사내 live 실측 2026-09-21):
--   AS-IS : SCM_ADM_EXCEL_COLUMNS(PROGRAM_ID='DMF0020', SHEET_NAME='Sales Price')
--           HEADER_CONTENT = Div|Team|End Customer|Project Code|Currency|Model|M0|...|M12   (19 토큰)
--           OPTION_ATTRIBUTE_COLUMN_NUMBER = 70
--   현행  : PROGRAM_ID='DMF0082', SHEET_NAME='FcstNPrice'
--           HEADER_CONTENT = Div|Project Code|Sales Site|Model|Incoterms|FCST Type|Customs Handbook|
--                            Plant Site|Currency|Measure|M0|...|M12                         (23 토큰)
--
-- ⚠ 토큰 순서 = ATTRIBUTE 슬롯 순서다. 이 변경과 P_DMF0082_EXCEL_UPLOAD 의 슬롯 매핑
--   (ATTRIBUTE1 Div / 2 Team / 3 End Customer / 4 Project Code / 5 Currency / 6 Model / 7~19 M0~M12)
--   은 **반드시 같은 회차에 함께 배포**해야 한다. 한쪽만 적용하면 업로드가 전 행 탈락한다.
--
-- 멱등 : 현행값일 때만 갱신 + 이미 목표값이면 0건 (재실행 안전)
-- 감사 : LAST_UPDATED_BY = 'admin'

UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS
   SET HEADER_CONTENT   = 'Div|Team|End Customer|Project Code|Currency|Model|M0|M1|M2|M3|M4|M5|M6|M7|M8|M9|M10|M11|M12'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0082'
   AND SHEET_NAME = 'FcstNPrice'
   AND HEADER_CONTENT <> 'Div|Team|End Customer|Project Code|Currency|Model|M0|M1|M2|M3|M4|M5|M6|M7|M8|M9|M10|M11|M12';

COMMIT;

-- 검증 (AS-IS 와 토큰 완전 일치 = 1 이어야 한다)
SELECT CASE WHEN A.HEADER_CONTENT = B.HEADER_CONTENT THEN 1 ELSE 0 END AS ASIS_MATCH
     , A.HEADER_CONTENT AS DMF0082_HEADER
  FROM (SELECT HEADER_CONTENT FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
         WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice') A
     , (SELECT HEADER_CONTENT FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
         WHERE PROGRAM_ID='DMF0020' AND SHEET_NAME='Sales Price') B;
