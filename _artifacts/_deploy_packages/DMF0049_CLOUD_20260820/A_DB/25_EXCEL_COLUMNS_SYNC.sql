-- DMF0049_CLOUD_20260820 / A_DB/25_EXCEL_COLUMNS_SYNC.sql
-- SCM_ADM_EXCEL_COLUMNS — Excel Form/Upload 메타 축.
-- 사내 실측: PROGRAM_ID='DMF0049' → **0행** / SHEET_NAME='MDF Reports' → **0행**.
-- ⇒ **0행 축** — 본 화면은 Excel Upload 를 보유하지 않는다(EXCEL 버튼은 그리드 내보내기 전용).
--   MNU_BTN_MPG_M 의 DMF0049_main_EXCEL 은 조회 SP(P_DMF0049_GET_SALES_ETC_REPORTS_DATA)에
--   배선돼 있고 Upload 계약(P_MODE 0/1) SP 가 없다 → hook #135 2단 Upload 대상 아님.
-- 이관 대상 없음. 본 파일은 '축을 봤고 0행이었다' 는 사실을 남기기 위한 것이다(조용한 스킵 방지).

-- (실행할 DML 없음)