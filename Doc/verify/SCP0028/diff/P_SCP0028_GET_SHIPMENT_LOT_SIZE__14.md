# SCP0028 · SCP0028_GET_SHIPMENT_LOT_SIZE ↔ PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE

- 실행 2026-11-20 09:29:19 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 5행 전 컬럼 일치 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+OPERATION_GROUP_ID+from_site+from_site_description+to_site+to_site_description+ITEM_ID+NICK_NAME+trans_mode_name+trans_mode_code+VALID_YN+SPLIT_YN · golden 집합 판정 PASS
- 호출 #14 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 6 · 원천 Doc\verify\SCP0028\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "", "fromSite": "", "toSite": "HKI_KR_WJU", "transMode": "", "itemId": "", "valid": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_operation_group": "", "p_from_site": "", "p_to_site": "HKI_KR_WJU", "p_trans_mode": "", "p_item_id": "", "p_valid": ""}`

### 결과셋 1  As-is 5행 ↔ To-Be O_RC1 5행
- 일치
- 데이터 기준: 공통 5행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 5행의 상대 순서): 일치
