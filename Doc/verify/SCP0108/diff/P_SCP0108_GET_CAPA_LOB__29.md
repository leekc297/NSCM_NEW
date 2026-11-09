# SCP0108 · (AS-IS 짝 없음) ↔ PKG_SCP0108.P_SCP0108_GET_CAPA_LOB

- 실행 2026-11-09 10:48:47 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #29 sheet=CUTOFF btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SCP0108\calls\_verify_Division별_조회_오류_콤보_이름_F4_A2__0.json
- TO-BE 인자(FE 본문): `{"version": "202610", "versionSeq": 1, "divisionId": "81_HD", "siteId": "", "plantId": "", "factoryId": "", "lineId": "", "operationId": "", "nickName": "", "electrodeType": "", "bottleneckFlag": "", "programId": "SCP0108", "sheetName": "CUTOFF"}`
- SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가
