# SCP0028 · SCP0028_GET_SHIPMENT_LOT_SIZE ↔ PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE

- 실행 2026-11-20 09:29:19 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 670행 중 불일치 셀 1 — diff/P_SCP0028_GET_SHIPMENT_LOT_SIZE__9.csv · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+OPERATION_GROUP_ID+from_site+from_site_description+to_site+to_site_description+ITEM_ID+NICK_NAME+trans_mode_name+trans_mode_code+VALID_YN+SPLIT_YN · golden 집합 판정 DIFF
- 호출 #9 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 671 · 원천 Doc\verify\SCP0028\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "A", "fromSite": "", "toSite": "", "transMode": "", "itemId": "", "valid": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_operation_group": "A", "p_from_site": "", "p_to_site": "", "p_trans_mode": "", "p_item_id": "", "p_valid": ""}`

### 결과셋 1  As-is 670행 ↔ To-Be O_RC1 670행
- 값 차이: As-is 전용 1행 / To-Be 전용 1행 (공통 컬럼 18)
| 측 | DIVISION_ID | OPERATION_GROUP_ID | from_site | from_site_description | to_site | to_site_description | ITEM_ID | NICK_NAME | trans_mode_name | trans_mode_code | LOT_SIZE | INCREMENT |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEP2065I-B1 | E65D | SEA | SEA | 12800 | 12800 |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEP2065I-B1 | E65D | SEA | SEA | 12800 | 1 |
- 데이터 기준: 공통 669행 · AS-IS 전용 1행 · TO-BE 전용 1행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 669행의 상대 순서): 일치

## 불일치 셀(≤50) — diff/P_SCP0028_GET_SHIPMENT_LOT_SIZE__9.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 81|A|HQ07-A|LGESOC Cell HQ07|Club Car_US_AGS|Club Car_US_AGS|ACEP2065I-B1|E65D|SEA|SEA|Y|N | INCREMENT | 12800 | 1 |
