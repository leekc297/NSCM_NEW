# SCP0028 · (AS-IS 짝 없음) ↔ PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP

- 실행 2026-11-25 01:47:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #35 sheet=popup btn=SEARCH user=minyonglee1 FE 응답 행 394 · 원천 Doc\verify\SCP0028\calls\eg_popup__eg-popup_MAIN_SCP0028_0_SCM0002_ShipmentLotSizePopup_BTN_bt_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "", "fromSite": "HQ05-W,HQ07-A,HQ07-E,HQ07-P,HQ11-A,HQ11-E,HQ11-P,KR02239900_81-P,EG01_81-W,MI00_81-W,MI00-A,MI00-E,MI00-P,MI02-A,MI02-E,MI03_81-W,MI03-P,NA00-A,NA00-E,NA00-P,NB01-A,NB01-E,NB01-P,WA00_81-W,WA00-A,WA00-E,WA00-P", "toSite": "", "itemId": "", "actionFlag": "D"}`
- SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가
