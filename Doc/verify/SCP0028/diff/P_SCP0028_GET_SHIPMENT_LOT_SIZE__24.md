# SCP0028 · SCP0028_GET_SHIPMENT_LOT_SIZE ↔ PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE

- 실행 2026-11-25 01:47:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 776행 전 컬럼 일치 · 단독행 AS-IS 0 / TO-BE 20 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+OPERATION_GROUP_ID+from_site+from_site_description+to_site+to_site_description+ITEM_ID+NICK_NAME+trans_mode_name+trans_mode_code+VALID_YN+SPLIT_YN · golden 집합 판정 DIFF
- 호출 #24 sheet=main btn=SEARCH user=crjung FE 응답 행 797 · 원천 Doc\verify\SCP0028\calls\_verify_선택_조회_복수_단일_전체_왕복_G2_B6__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "", "fromSite": "", "toSite": "", "transMode": "AIR,FRY", "itemId": "", "valid": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "crjung"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_operation_group": "", "p_from_site": "", "p_to_site": "", "p_trans_mode": "AIR,FRY", "p_item_id": "", "p_valid": ""}`

### 결과셋 1  As-is 776행 ↔ To-Be O_RC1 796행
- 행수 불일치 776 ↔ 796
- 값 차이: As-is 전용 0행 / To-Be 전용 20행 (공통 컬럼 18)
| 측 | DIVISION_ID | OPERATION_GROUP_ID | from_site | from_site_description | to_site | to_site_description | ITEM_ID | NICK_NAME | trans_mode_name | trans_mode_code | LOT_SIZE | INCREMENT |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | BAE_US_ENC | BAE_US_ENC | ACPP1015U-B1-001 | P1.7-001 | AIR | AIR |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | BAE_US_ENC | BAE_US_ENC | ACPP1015U-B1-001 | P1.7-001 | FERRY | FRY |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEN1059I-A1-000 | N2.1-000 | AIR | AIR |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEN1059I-A1-000 | N2.1-000 | FERRY | FRY |  |  |
| T | 81 | A | WA00-A | LGESWA Cell WA00 | HKMC_WA_CZ_NVS | HKMC_WA_CZ_NVS | AAEH1085I-A1-100 | E85A-100 | AIR | AIR |  |  |
| T | 81 | A | WA00-A | LGESWA Cell WA00 | HKMC_WA_CZ_NVS | HKMC_WA_CZ_NVS | AAEH1085I-A1-100 | E85A-100 | FERRY | FRY |  |  |
| T | 81 | A | WA00-A | LGESWA Cell WA00 | HKMC_WA_CZ_NVS | HKMC_WA_CZ_NVS | ACEH1085I-A1-100 | E85A-100 | AIR | AIR |  |  |
| T | 81 | A | WA00-A | LGESWA Cell WA00 | HKMC_WA_CZ_NVS | HKMC_WA_CZ_NVS | ACEH1085I-A1-100 | E85A-100 | FERRY | FRY |  |  |
| T | 81 | P | MI00-P | LGESMI Pack MI00 | TY_US_VDH | TY_US_VDH | AMTYTTNGA-A1-070 | TYT E-TNGA-070 | AIR | AIR | 1 | 1 |
| T | 81 | P | MI00-P | LGESMI Pack MI00 | TY_US_VDH | TY_US_VDH | AMTYTTNGA-A1-070 | TYT E-TNGA-070 | FERRY | FRY | 1 | 1 |
- 데이터 기준: 공통 776행 · AS-IS 전용 0행 · TO-BE 전용 20행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 776행의 상대 순서): 일치
