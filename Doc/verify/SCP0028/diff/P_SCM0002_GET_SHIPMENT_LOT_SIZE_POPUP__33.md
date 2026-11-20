# SCP0028 · SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP ↔ PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP

- 실행 2026-11-20 09:29:19 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+from_site+from_site_description+TO_SITE+to_site_description+ITEM_ID) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+from_site+from_site_description+TO_SITE+to_site_description+ITEM_ID · golden 집합 판정 PASS
- 호출 #33 sheet=popup btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SCP0028\calls\eg_popup__eg-popup_MAIN_SCP0028_0_SCM0002_ShipmentLotSizePopup_BTN_bt_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "", "fromSite": "AU000062_81-P,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,AC00-A,EG01_81-W,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,MT00-A,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P", "toSite": "EG00", "itemId": "", "actionFlag": "D"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_operation_group": "", "p_from_site": "AU000062_81-P,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,AC00-A,EG01_81-W,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,MT00-A,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P", "p_to_site": "EG00", "p_item_id": "", "p_action_flag": "D"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "81", "p_operation_group": "ALL", "p_from_site": "AU000062_81-P,HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,AC00-A,EG01_81-W,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,MT00-A,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P", "p_to_site": "EG00", "p_item_id": "ALL", "p_action_flag": "D"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
