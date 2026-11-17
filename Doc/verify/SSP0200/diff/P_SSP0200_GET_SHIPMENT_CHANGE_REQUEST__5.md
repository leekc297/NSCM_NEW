# SSP0200 · SSP0200_GET_SHIPMENT_CHANGE_REQUEST ↔ PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST

- 실행 2026-11-15 06:43:23 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 10행 전 컬럼 일치 · 단독행 AS-IS 0 / TO-BE 10 · 키 원천 cleanup_spec.json · 키 confirm_id · golden 집합 판정 DIFF
- 호출 #5 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 21 · 원천 Doc\verify\SSP0200\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "fromSite": "ALL", "erpSoNo": "", "itemId": "", "fromYyyymmdd": "20261115", "toYyyymmdd": "20261215", "status": "ALL", "changeType": "C", "language": "KO", "debugMode": "F", "toSite": "ALL", "confirmId": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_from_site": "ALL", "p_erp_so_no": "", "p_item_id": "", "p_from_yyyymmdd": "20261115", "p_to_yyyymmdd": "20261215", "p_status": "ALL", "p_change_type": "C", "p_language": "KO", "debug_mode": "F", "p_to_site": "ALL", "p_confirm_id": ""}`
- 재시도 'ALL'→'': AS-IS 10행 ← `{"p_division_id": "81", "p_from_site": "", "p_erp_so_no": "", "p_item_id": "", "p_from_yyyymmdd": "20261115", "p_to_yyyymmdd": "20261215", "p_status": "", "p_change_type": "C", "p_language": "KO", "debug_mode": "F", "p_to_site": "", "p_confirm_id": ""}`

### 결과셋 1  As-is 10행 ↔ To-Be O_RC1 20행
- 행수 불일치 10 ↔ 20
- 값 차이: As-is 전용 0행 / To-Be 전용 10행 (공통 컬럼 69)
| 측 | division_id | erp_so_no | shipment_status | project_code | project_name | fcst_type | item_id | nick_name | shipment_date | before_qty | shipment_confirm_qty | remarks |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 81 |  | C | A15FD5002 | C727 BEV | MPS | AMFMCC727-C1-010 | FMC-C727 30 | 2026-11-30 | 2 | 3 |  |
| T | 81 |  | C | A15FD5002 | C727 BEV | MPS | AMFMCC727-C1-010 | FMC-C727 30 | 2026-11-30 | 528 | 600 |  |
| T | 81 |  | C | A15FD5002 | C727 BEV | MPS | AMFMCC727-C1-010 | FMC-C727 30 | 2026-11-30 | 600 | 3 |  |
| T | 81 |  | C | A15FD5002 | C727 BEV | MPS | AMFMCC727-C1-010 | FMC-C727 30 | 2026-11-30 | 600 | 4 |  |
| T | 81 |  | C | A15FD5002 | C727 BEV | MPS | AMFMCC727-C1-010 | FMC-C727 30 | 2026-11-30 | 600 | 5 |  |
| T | 81 |  | C | A15FD5002 | C727 BEV | MPS | AMFMCC727-C1-010 | FMC-C727 30 | 2026-11-30 | 600 | 6 |  |
| T | 81 |  | C | A24FD4001-000 | Ford HEV-C | SDC | AMFMCHEVC-A1-000 | FMC-HEVC-000 | 2026-11-26 | 10 | 10 | test1 |
| T | 81 |  | C | A24FD4001-000 | Ford HEV-C | SDC | AMFMCHEVC-A1-000 | FMC-HEVC-000 | 2026-12-04 | 0 | 2 | test2 |
| T | 81 |  | C | A24FD4001-000 | Ford HEV-C | SDC | AMFMCHEVC-A1-000 | FMC-HEVC-000 | 2026-12-04 | 10 | 12 | test2 |
| T | 81 | 1200023370 | C | A24FD4001-000 | Ford HEV-C | SDC | AMFMCHEVC-A1-000 | FMC-HEVC-000 | 2026-11-27 | 70 | 60 | test3 |
- 데이터 기준: 공통 10행 · AS-IS 전용 0행 · TO-BE 전용 10행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 10행의 상대 순서): 일치
