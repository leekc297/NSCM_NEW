# SCP0111 · SCP0111_GET_INTEGRATION_PSI ↔ PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI

- 실행 2026-11-18 17:39:22 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 키 없이 판정 — 전 결과셋 행 집합 완전 일치(셋1 1328행 · 한쪽 전용 0) · 키 원천 (행 집합) · 키  · golden 집합 판정 PASS
- 호출 #5 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1329 · 원천 Doc\verify\SCP0111\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "planStartYyyymmdd": "20261019", "planType": "", "seq": "", "fromYyyymm": "202610", "toYyyymm": "202703", "nickName": "", "cellItemId": "", "itemId": "", "qtyYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plan_start_yyyymmdd": "20261019", "p_plan_type": "", "p_seq": "", "p_from_yyyymm": "202610", "p_to_yyyymm": "202703", "p_nick_name": "", "p_cellitem_id": "", "p_item_id": "", "p_qty_yn": "N"}`

### 결과셋 1  As-is 1328행 ↔ To-Be O_RC 1328행
- 일치
- 데이터 기준: 공통 1328행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1328행의 상대 순서): 일치
