-- BACKUP SCM_ADM_MSG_M MSG01151 (사내 ZIOUI1, 2026-09-22 변경 직전) — 원복 = 아래 UPDATE 실행
UPDATE SCM_ADM_MSG_M SET MSG_NM = 'Check the header information of the Excel file and upload again!', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE WHERE MSG_ID = 'MSG01151' AND LANG_CD = 'CN';
UPDATE SCM_ADM_MSG_M SET MSG_NM = 'Check the header information of the Excel file and upload again!', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE WHERE MSG_ID = 'MSG01151' AND LANG_CD = 'EN';
UPDATE SCM_ADM_MSG_M SET MSG_NM = '엑셀 파일의 Header 정보 확인 후 재 Upload 하세요!', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE WHERE MSG_ID = 'MSG01151' AND LANG_CD = 'KO';
COMMIT;
