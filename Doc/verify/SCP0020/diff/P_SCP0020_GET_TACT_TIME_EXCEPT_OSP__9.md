# SCP0020 · SCP0020_GET_TACT_TIME_EXCEPT ↔ PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCEPT_OSP

- 실행 2026-11-14 10:58:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #9 sheet=except btn=SEARCH user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SCP0020\calls\_verify_CRUD_필수_공란_실제_저장_시도_E3_필수_채워_실제_저장_재조회_값_보존_정리_F1_F2_F4_F6__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "plantSite": "CN00249500-P", "operationId": "CN00249500", "itemId": "EM048063P3N1", "lineId": "C1P05", "debugMode": "N"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_plant_site": "CN00249500-P", "p_operation_id": "CN00249500", "p_item_id": "EM048063P3N1", "p_line_id": "C1P05", "debug_mode": ""}`
- SKIP: 인자 미해결(UNRESOLVED): debug_mode,debug_mode — param_map.csv 에 값/대응 지정
