# SSP0200 · SSP0200_GET_SHIPMENT_CHANGE_REQUEST ↔ PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST

- 실행 2026-11-15 06:43:23 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 confirm_id) — AS-IS 0행 ↔ TO-BE 25행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 cleanup_spec.json · 키 confirm_id · golden 집합 판정 DIFF
- 호출 #12 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 26 · 원천 Doc\verify\SSP0200\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "fromSite": "ALL", "erpSoNo": "", "itemId": "", "fromYyyymmdd": "20261115", "toYyyymmdd": "20261215", "status": "D", "changeType": "C", "language": "KO", "debugMode": "F", "toSite": "ALL", "confirmId": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_from_site": "ALL", "p_erp_so_no": "", "p_item_id": "", "p_from_yyyymmdd": "20261115", "p_to_yyyymmdd": "20261215", "p_status": "D", "p_change_type": "C", "p_language": "KO", "debug_mode": "F", "p_to_site": "ALL", "p_confirm_id": ""}`
- 재시도 'ALL'→'': AS-IS 0행 ← `{"p_division_id": "40", "p_from_site": "", "p_erp_so_no": "", "p_item_id": "", "p_from_yyyymmdd": "20261115", "p_to_yyyymmdd": "20261215", "p_status": "D", "p_change_type": "C", "p_language": "KO", "debug_mode": "F", "p_to_site": "", "p_confirm_id": ""}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "40", "p_from_site": "ALL", "p_erp_so_no": "ALL", "p_item_id": "ALL", "p_from_yyyymmdd": "20261115", "p_to_yyyymmdd": "20261215", "p_status": "D", "p_change_type": "C", "p_language": "KO", "debug_mode": "F", "p_to_site": "ALL", "p_confirm_id": "ALL"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 25행
- 행수 불일치 0 ↔ 25
- 값 차이: As-is 전용 0행 / To-Be 전용 25행 (공통 컬럼 69)
| 측 | division_id | erp_so_no | shipment_status | project_code | project_name | fcst_type | item_id | nick_name | shipment_date | before_qty | shipment_confirm_qty | remarks |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 40 |  | C | - |  | - | APCAN1650A | M50F | 2026-11-30 | 167513 | 167000 | I |
| T | 40 |  | C | - |  | - | APCCA1714A | M50F | 2026-11-30 | 0 | 22222 | I |
| T | 40 |  | C | Airbus |  | SMC | MCCH129520B1 | HJ2 | 2026-11-23 | 0 | 2300 |  |
| T | 40 |  | C | Airbus |  | SMC | MCCH129520B1 | HJ2 | 2026-12-10 | 0 | 10 |  |
| T | 40 |  | C | Airbus |  | SMC | MCCH129520B1 | HJ2 | 2026-12-10 | 0 | 10 |  |
| T | 40 |  | C | Jinle |  | MPS | MCCM348014A3 | M50LT | 2026-11-23 | 0 | 10 |  |
| T | 40 |  | C | Jinle |  | MPS | MCCM348014A3 | M50LT | 2026-11-23 | 0 | 10 |  |
| T | 40 |  | C | Jinle |  | MPS | MCCM348014A3 | M50LT | 2026-11-23 | 0 | 10 |  |
| T | 40 |  | C | Jinle |  | MPS | MCCM348014A3 | M50LT | 2026-11-23 | 0 | 100 |  |
| T | 40 |  | C | Jinle |  | MPS | MCCM348014A3 | M50LT | 2026-11-23 | 0 | 400 |  |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 25행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
