-- [E20260908-XLSMONTH] DMF0082 Excel Upload 기간 토큰 = 월 M0~M12 (13) 등재.
--   식별 10 토큰 = ATTRIBUTE1~10 / M0~M12 = ATTRIBUTE11~23 (구 M4~M16 자리 계보 동일).
--   BE cvtListUploadRows 가 HEADER_CONTENT 토큰 '이름'으로 엑셀 헤더를 찾아 ATTRIBUTE 슬롯에 넣는다.
--   ⚠ 토큰 문자열 원형 유지 — 1바이트라도 다르면 그 열 전량 탈락(무증상).
UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS
   SET HEADER_CONTENT = 'Div|Project Code|Sales Site|Model|Incoterms|FCST Type|Customs Handbook|Plant Site|Currency|Measure|M0|M1|M2|M3|M4|M5|M6|M7|M8|M9|M10|M11|M12'
     , LAST_UPDATED_BY = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice';
COMMIT;
