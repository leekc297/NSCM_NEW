# SCP0041 · SCP0041_GET_PACK_HOLD_STOCK ↔ PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK

- 실행 2026-11-14 15:25:22 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+SCM_SITE_ID+PROD_ID+ORG_ITEM_ID+QTY) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+SCM_SITE_ID+PROD_ID+ORG_ITEM_ID+QTY · golden 집합 판정 PASS
- 호출 #9 sheet=Pack Hold Stock btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SCP0041\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "plantSiteId": "", "itemId": "", "fromYyyymmdd": "20240814", "toYyyymmdd": "20270814", "inspectionId": "", "status": "", "cutoffFromYyyymmdd": "20241114", "cutoffToYyyymmdd": "20261114"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_plant_site_id": "", "p_item_id": "", "p_from_yyyymmdd": "20240814", "p_to_yyyymmdd": "20270814", "p_inspection_id": "", "p_status": "", "p_cutoff_from_yyyymmdd": "20241114", "p_cutoff_to_yyyymmdd": "20261114"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "40", "p_plant_site_id": "ALL", "p_item_id": "ALL", "p_from_yyyymmdd": "20240814", "p_to_yyyymmdd": "20270814", "p_inspection_id": "ALL", "p_status": "ALL", "p_cutoff_from_yyyymmdd": "20241114", "p_cutoff_to_yyyymmdd": "20261114"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
