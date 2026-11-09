# SCP0016 · SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL ↔ PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL

- 실행 2026-11-07 22:38:37 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 2194행 전 컬럼 일치 · 키 원천 key_map.csv · 키 KEY_IDX+MEASURE+BOD_ID · golden 집합 판정 PASS
- 호출 #9 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 None · 원천 Doc\verify\SCP0016\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "fromYyyymmdd": "20260824", "toYyyymmdd": "20270822", "bizType": "A", "projectCode": "", "itemId": "", "versionNo": "SP_W_20260608", "electype": "ALL", "programId": "SCP0016", "sheetName": "Shipment Plan FG"}`
- AS-IS 인자(번역): `{"p_from_yyyymmdd": "20260824", "p_to_yyyymmdd": "20270822", "p_division_id": "40", "p_biz_type": "A", "p_project_code": "", "p_item_id": "", "p_version_no": "SP_W_20260608", "p_electype": "", "p_program_id": "SCP0016", "p_sheet_name": "Shipment Plan FG", "p_user_id": "bpark416", "debug_mode": ""}` · 번역 메모: p_electype: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_user_id: 본문에 sesUserId 없음 → default 'bpark416' · debug_mode: 본문에 debugMode 없음 → default ''
- TO-BE 인자 중 값 없음(NULL 전달): P_USER_ID, P_DEBUG_MODE

### 결과셋 1  As-is 2212행 ↔ To-Be O_RC1 2212행
- 일치
- 데이터 기준: 공통 2212행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2212행의 상대 순서): 일치
