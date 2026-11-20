# SCP0028 · SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP ↔ PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP

- 실행 2026-11-20 09:29:19 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 383행 전 컬럼 일치 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+from_site+from_site_description+TO_SITE+to_site_description+ITEM_ID · golden 집합 판정 PASS
- 호출 #4 sheet=popup btn=SEARCH user=minyonglee1 FE 응답 행 384 · 원천 Doc\verify\SCP0028\calls\_trace_W4b_H3_F5_F3_M3_J1_H4_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "", "fromSite": "", "toSite": "", "itemId": "", "actionFlag": "D"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_operation_group": "", "p_from_site": "", "p_to_site": "", "p_item_id": "", "p_action_flag": "D"}`

### 결과셋 1  As-is 383행 ↔ To-Be O_RC1 383행
- 일치
- 데이터 기준: 공통 383행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 383행의 상대 순서): 일치
