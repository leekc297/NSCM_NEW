# SSP0025 · (AS-IS 짝 없음) ↔ PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC

- 실행 2026-11-09 11:50:05 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #7 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 17 · 원천 Doc\verify\SSP0025\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "plantSite": "HQ11-A,MI00-A,NA00-A,NB01-A,AC00-A,HQ07-A,MT00-A,WA00-A,MI02-A", "itemId": "", "nickName": "", "modelId": ""}`
- SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가
