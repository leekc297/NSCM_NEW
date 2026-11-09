# SCP0108 · (AS-IS 짝 없음) ↔ PKG_SCP0108.P_SCP0108_GET_CAPA_LOB_CURRENT

- 실행 2026-11-09 10:48:47 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #20 sheet=CURRENT btn=SEARCH user=minyonglee1 FE 응답 행 637 · 원천 Doc\verify\SCP0108\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"version": "202610", "versionSeq": 1, "divisionId": "81", "siteId": "", "plantId": "", "factoryId": "", "lineId": "", "operationId": "A5000,A7000,A7400,A8000,A8400,A9000,AFFFF", "nickName": "", "electrodeType": "", "bottleneckFlag": "", "programId": "SCP0108", "sheetName": "CURRENT"}`
- SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가
