# SSP0200 · SSP0200_GET_SHIPMENT_REQUEST_DRAFTING ↔ PKG_SSP0200.P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTING

- 실행 2026-11-15 06:43:23 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 confirm_id) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 cleanup_spec.json · 키 confirm_id · golden 집합 판정 PASS
- 호출 #25 sheet=sub btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SSP0200\calls\_verify_언어_전환_문구_덤프_I2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "fromSite": "", "toSite": "", "erpSoNo": "", "itemId": "", "bodId": "", "incoterms": "", "transportMode": "", "projectCode": "", "fcstType": "", "confirmId": "", "fromYyyymmdd": "20261115", "toYyyymmdd": "20261215", "changeRequestNo": "", "requestUserId": "minyonglee1", "requestStatus": "D", "language": "EN", "changeType": "C", "debugMode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "EN", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_from_site": "", "p_to_site": "", "p_erp_so_no": "", "p_item_id": "", "p_bod_id": "", "p_incoterms": "", "p_transport_mode": "", "p_project_code": "", "p_fcst_type": "", "p_confirm_id": "", "p_from_yyyymmdd": "20261115", "p_to_yyyymmdd": "20261215", "p_change_request_no": "", "p_request_user_id": "minyonglee1", "p_request_status": "D", "p_language": "EN", "p_change_type": "C", "debug_mode": "F"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "40", "p_from_site": "ALL", "p_to_site": "ALL", "p_erp_so_no": "ALL", "p_item_id": "ALL", "p_bod_id": "ALL", "p_incoterms": "ALL", "p_transport_mode": "ALL", "p_project_code": "ALL", "p_fcst_type": "ALL", "p_confirm_id": "ALL", "p_from_yyyymmdd": "20261115", "p_to_yyyymmdd": "20261215", "p_change_request_no": "ALL", "p_request_user_id": "minyonglee1", "p_request_status": "D", "p_language": "EN", "p_change_type": "C", "debug_mode": "F"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 0행 ↔ To-Be O_RC2 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
