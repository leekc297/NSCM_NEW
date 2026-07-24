-- 99_VERIFY: 적용 후 검증 (전부 기대값과 일치해야 함)
SELECT object_name,object_type,status FROM all_objects WHERE owner='SCM_MGR' AND object_name IN ('PKG_DMF0044','PKG_DMF0049') ORDER BY 1,2; -- 4행 전부 VALID
SELECT name,type,line,text FROM all_errors WHERE owner='SCM_MGR' AND name IN ('PKG_DMF0044','PKG_DMF0049') ORDER BY name,type,sequence; -- 0행
SELECT b.MNU_ID,b.SHT_NM,b.MNU_BTN_CD,a.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M b JOIN SCM_MGR.SCM_ADM_API_M a ON a.API_ID=b.API_ID WHERE b.MNU_ID='DMF0049' ORDER BY 2,3; -- 전부 PKG_DMF0049./PKG_DMF0044. 로 시작