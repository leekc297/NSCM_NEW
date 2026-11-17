# SCP0020 · SCP0020_GET_TACT_TIME_OSP ↔ PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP

- 실행 2026-11-14 10:58:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #16 sheet=packer btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SCP0020\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "plantSiteId": "ALL", "lineId": "ALL", "operationGroupId": "P", "itemId": "ep096636pfb1-cg0", "debugMode": "N"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_plant_site_id": "", "p_line_id": "", "p_operation_group_id": "P", "p_item_id": "ep096636pfb1-cg0", "debug_mode": ""}` · 번역 메모: p_plant_site_id: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_line_id: 'ALL'→''(all_semantics: 빈 값 = 전체)
- SKIP: 인자 미해결(UNRESOLVED): debug_mode — param_map.csv 에 값/대응 지정
