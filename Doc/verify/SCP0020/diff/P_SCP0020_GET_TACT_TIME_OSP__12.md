# SCP0020 · SCP0020_GET_TACT_TIME_OSP ↔ PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP

- 실행 2026-11-14 10:58:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #12 sheet=packer btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SCP0020\calls\_verify_선택_조회_복수_단일_전체_왕복_G2_B6__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "plantSiteId": "ALL", "lineId": "SHP01,AZP01", "operationGroupId": "P", "itemId": "ALL", "debugMode": "N"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_plant_site_id": "", "p_line_id": "SHP01,AZP01", "p_operation_group_id": "P", "p_item_id": "", "debug_mode": ""}` · 번역 메모: p_plant_site_id: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_item_id: 'ALL'→''(all_semantics: 빈 값 = 전체)
- SKIP: 인자 미해결(UNRESOLVED): debug_mode — param_map.csv 에 값/대응 지정
