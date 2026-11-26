# SCP0028 · SCP0028_GET_SHIPMENT_LOT_SIZE ↔ PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE

- 실행 2026-11-25 01:47:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 1940행 전 컬럼 일치 · 단독행 AS-IS 0 / TO-BE 50 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+OPERATION_GROUP_ID+from_site+from_site_description+to_site+to_site_description+ITEM_ID+NICK_NAME+trans_mode_name+trans_mode_code+VALID_YN+SPLIT_YN · golden 집합 판정 DIFF
- 호출 #1 sheet=main btn=SEARCH user=bindy122678 FE 응답 행 1991 · 원천 Doc\verify\SCP0028\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "", "fromSite": "", "toSite": "", "transMode": "", "itemId": "", "valid": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 16종 중 최다(101회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'bindy122678'}, {'sesLangCd': 'KO', 'sesUserId': 'brightboy'}, {'sesLangCd': 'KO', 'sesUserId': 'candoism'}]
- AS-IS 인자(번역): `{"p_division_id": "81", "p_operation_group": "", "p_from_site": "", "p_to_site": "", "p_trans_mode": "", "p_item_id": "", "p_valid": ""}`

### 결과셋 1  As-is 1940행 ↔ To-Be O_RC1 1990행
- 행수 불일치 1940 ↔ 1990
- 값 차이: As-is 전용 0행 / To-Be 전용 50행 (공통 컬럼 18)
| 측 | DIVISION_ID | OPERATION_GROUP_ID | from_site | from_site_description | to_site | to_site_description | ITEM_ID | NICK_NAME | trans_mode_name | trans_mode_code | LOT_SIZE | INCREMENT |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | BAE_US_ENC | BAE_US_ENC | ACPP1015U-B1-001 | P1.7-001 | AIR | AIR |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | BAE_US_ENC | BAE_US_ENC | ACPP1015U-B1-001 | P1.7-001 | FERRY | FRY |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | BAE_US_ENC | BAE_US_ENC | ACPP1015U-B1-001 | P1.7-001 | RAIL | RAI |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | BAE_US_ENC | BAE_US_ENC | ACPP1015U-B1-001 | P1.7-001 | SEA | SEA | 24840 | 2484 |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | BAE_US_ENC | BAE_US_ENC | ACPP1015U-B1-001 | P1.7-001 | TRUCK | TRK |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEN1059I-A1-000 | N2.1-000 | AIR | AIR |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEN1059I-A1-000 | N2.1-000 | FERRY | FRY |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEN1059I-A1-000 | N2.1-000 | RAIL | RAI |  |  |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEN1059I-A1-000 | N2.1-000 | SEA | SEA | 0 | 0 |
| T | 81 | A | HQ07-A | LGESOC Cell HQ07 | Club Car_US_AGS | Club Car_US_AGS | ACEN1059I-A1-000 | N2.1-000 | TRUCK | TRK |  |  |
- 데이터 기준: 공통 1940행 · AS-IS 전용 0행 · TO-BE 전용 50행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1940행의 상대 순서): 일치
