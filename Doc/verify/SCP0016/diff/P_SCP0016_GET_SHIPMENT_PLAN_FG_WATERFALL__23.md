# SCP0016 · SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL ↔ PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL

- 실행 2026-11-14 11:04:13 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 KEY_IDX+MEASURE) — AS-IS 0행 ↔ TO-BE 6행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 key_map.csv · 키 KEY_IDX+MEASURE · golden 집합 판정 DIFF
- 호출 #23 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 7 · 원천 Doc\verify\SCP0016\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "fromYyyymmdd": "20260824", "toYyyymmdd": "20270822", "bizType": "P", "projectCode": "", "itemId": "amcome782-a1-0k0", "versionNo": "SP_W_20260608", "electype": "ALL", "programId": "SCP0016", "sheetName": "Shipment Plan FG"}`
- AS-IS 인자(번역): `{"p_from_yyyymmdd": "20260824", "p_to_yyyymmdd": "20270822", "p_division_id": "81", "p_biz_type": "P", "p_project_code": "", "p_item_id": "amcome782-a1-0k0", "p_version_no": "SP_W_20260608", "p_electype": "", "p_program_id": "SCP0016", "p_sheet_name": "Shipment Plan FG", "p_user_id": "bpark416", "debug_mode": ""}` · 번역 메모: p_electype: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_user_id: 세션 인자 sesUserId 값 미포착 → default 'bpark416'(호출 로그 없음) · debug_mode: 본문에 debugMode 없음 → default ''
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_from_yyyymmdd": "20260824", "p_to_yyyymmdd": "20270822", "p_division_id": "81", "p_biz_type": "P", "p_project_code": "ALL", "p_item_id": "amcome782-a1-0k0", "p_version_no": "SP_W_20260608", "p_electype": "ALL", "p_program_id": "SCP0016", "p_sheet_name": "Shipment Plan FG", "p_user_id": "bpark416", "debug_mode": "ALL"}`
- TO-BE 인자 중 값 없음(NULL 전달): P_USER_ID, P_DEBUG_MODE

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 6행
- 행수 불일치 0 ↔ 6
- 값 차이: As-is 전용 0행 / To-Be 전용 6행 (공통 컬럼 523)
| 측 | KEY_IDX | DIVISION_ID | BIZ_TYPE | BIZ_TYPE_NAME | PROJECT_CODE | ITEM_ID | NICK_NAME | ELECTRODE_TYPE | ORIGIN_TO_DIVISION_ID | TO_SITE | TO_SITE_NAME | INCOTERMS |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 81PA22IM4001AMCOME782-A1-0K0IC | 81 | P | Pack | A22IM4001 | AMCOME782-A1-0K0 | E782-0K0 | - | 81 | ICPT(OTS)_PL_WAW | ICPT(OTS)_PL_WAW | DAP |
| T | 81PA22IM4001AMCOME782-A1-0K0IC | 81 | P | Pack | A22IM4001 | AMCOME782-A1-0K0 | E782-0K0 | - | 81 | ICPT(OTS)_PL_WAW | ICPT(OTS)_PL_WAW | DAP |
| T | 81PA22IM4001AMCOME782-A1-0K0IC | 81 | P | Pack | A22IM4001 | AMCOME782-A1-0K0 | E782-0K0 | - | 81 | ICPT(OTS)_PL_WAW | ICPT(OTS)_PL_WAW | DAP |
| T | 81PA22IM4001AMCOME782-A1-0K0IC | 81 | P | Pack | A22IM4001 | AMCOME782-A1-0K0 | E782-0K0 | - | 81 | ICPT(OTS)_PL_WAW | ICPT(OTS)_PL_WAW | DAP |
| T | 81PA22IM4001AMCOME782-A1-0K0IC | 81 | P | Pack | A22IM4001 | AMCOME782-A1-0K0 | E782-0K0 | - | 81 | ICPT(OTS)_PL_WAW | ICPT(OTS)_PL_WAW | DAP |
| T | 81PA22IM4001AMCOME782-A1-0K0IC | 81 | P | Pack | A22IM4001 | AMCOME782-A1-0K0 | E782-0K0 | - | 81 | ICPT(OTS)_PL_WAW | ICPT(OTS)_PL_WAW | DAP |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 6행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
