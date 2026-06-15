-- DMF0043_01 메뉴 등록 + i18n (Contribution Sales — Overseas Subs. 삭제)
MERGE INTO SCM_ADM_MNU_M t USING (SELECT 'DMF0043_01' MNU_ID FROM DUAL) s ON (t.MNU_ID=s.MNU_ID)
 WHEN MATCHED THEN UPDATE SET LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHEN NOT MATCHED THEN INSERT (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO, MNU_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
   VALUES ('DMF0043_01','Demand_Master','contribute-view','MNU_DMF0043_01','해외법인 기여매출', 2, 3, 'SCREEN','Y','admin',SYSDATE,'admin',SYSDATE);
COMMIT;
-- ⚠ i18n MNU00031 (DMF0043_01 화면 표시명) 변경: 'Overseas Subs. Contribution Sales' → 'Contribution Sales'
-- ⚠ FE locales json 파일에서 일괄 변경 (01_FE/locales/KO|EN|CN.json 의 MNU00031 키)
