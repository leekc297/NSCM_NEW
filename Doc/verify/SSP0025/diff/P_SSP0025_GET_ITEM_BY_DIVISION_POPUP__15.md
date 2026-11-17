# SSP0025 · (AS-IS 짝 없음) ↔ PKG_SSP0025.P_SSP0025_GET_ITEM_BY_DIVISION_POPUP

- 실행 2026-11-15 05:04:51 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #15 sheet=popup btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SSP0025\calls\_verify_셀_연쇄_초기화_C2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "fromSiteId": "", "toSiteId": "AC00-A", "itemId": "", "modelId": ""}`
- SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가
