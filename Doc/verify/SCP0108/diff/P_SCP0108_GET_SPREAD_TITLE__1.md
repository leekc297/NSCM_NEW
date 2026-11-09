# SCP0108 · (AS-IS 짝 없음) ↔ PKG_SCP0108.P_SCP0108_GET_SPREAD_TITLE

- 실행 2026-11-09 10:48:47 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #1 sheet=spreadTitle btn=SEARCH user=minyonglee1 FE 응답 행 30 · 원천 Doc\verify\SCP0108\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"fromYyyymm": "202611", "programId": "SCP0108", "sheetName": "MAIN"}`
- SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가
