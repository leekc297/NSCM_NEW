# SCP0028 · (AS-IS 짝 없음) ↔ PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP

- 실행 2026-11-25 01:47:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #41 sheet=popup btn=SEARCH user=minyonglee1 FE 응답 행 47 · 원천 Doc\verify\SCP0028\calls\eg_popup__eg-popup_MAIN_SCP0028_1_SCM0002_ShipmentLotSizePopup_BTN_bt_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "", "fromSite": "HQ05-W", "toSite": "", "itemId": "apvcc519h-a1", "actionFlag": "I"}`
- SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가
