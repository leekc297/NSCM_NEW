# SCP0028 · SCP0028_GET_SHIPMENT_LOT_SIZE ↔ PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE

- 실행 2026-11-20 09:29:19 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+OPERATION_GROUP_ID+from_site+from_site_description+to_site+to_site_description+ITEM_ID+NICK_NAME+trans_mode_name+trans_mode_code+VALID_YN+SPLIT_YN) — AS-IS 0행 ↔ TO-BE 25행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+OPERATION_GROUP_ID+from_site+from_site_description+to_site+to_site_description+ITEM_ID+NICK_NAME+trans_mode_name+trans_mode_code+VALID_YN+SPLIT_YN · golden 집합 판정 DIFF
- 호출 #24 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 26 · 원천 Doc\verify\SCP0028\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "", "fromSite": "", "toSite": "", "transMode": "", "itemId": "CEP2065I-B", "valid": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_operation_group": "", "p_from_site": "", "p_to_site": "", "p_trans_mode": "", "p_item_id": "CEP2065I-B", "p_valid": ""}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "81", "p_operation_group": "ALL", "p_from_site": "ALL", "p_to_site": "ALL", "p_trans_mode": "ALL", "p_item_id": "CEP2065I-B", "p_valid": "ALL"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 25행
- 행수 불일치 0 ↔ 25
- 값 차이: As-is 전용 0행 / To-Be 전용 25행 (공통 컬럼 18)
| 측 | DIVISION_ID | OPERATION_GROUP_ID | from_site | from_site_description | to_site | to_site_description | ITEM_ID | NICK_NAME | trans_mode_name | trans_mode_code | LOT_SIZE | INCREMENT |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEP2065I-B1 | E65D | AIR | AIR |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEP2065I-B1 | E65D | FERRY | FRY |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEP2065I-B1 | E65D | RAIL | RAI |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEP2065I-B1 | E65D | SEA | SEA | 12800 | 1 |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEP2065I-B1 | E65D | TRUCK | TRK |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Forsee_FR_MCR | Forsee_FR_MCR | ACEP2065I-B1 | E65D | AIR | AIR |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Forsee_FR_MCR | Forsee_FR_MCR | ACEP2065I-B1 | E65D | FERRY | FRY |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Forsee_FR_MCR | Forsee_FR_MCR | ACEP2065I-B1 | E65D | RAIL | RAI |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Forsee_FR_MCR | Forsee_FR_MCR | ACEP2065I-B1 | E65D | SEA | SEA | 13608 | 13608 |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Forsee_FR_MCR | Forsee_FR_MCR | ACEP2065I-B1 | E65D | TRUCK | TRK |  |  |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 25행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
