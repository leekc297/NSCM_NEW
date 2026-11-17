# SCP0041 · SCP0041_GET_STOCK_OSP ↔ PKG_SCP0041.P_SCP0041_GET_STOCK_OSP

- 실행 2026-11-14 15:25:22 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+SCM_SITE_ID+SITE_DESCRIPTION+ITEM_ID+QTY) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+SCM_SITE_ID+SITE_DESCRIPTION+ITEM_ID+QTY · golden 집합 판정 PASS
- 호출 #3 sheet=Osp Stock btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SCP0041\calls\_trace_A10_조회_전_그리드_K4_버튼_구성_X-REOPEN_닫기_재오픈_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "plantSiteId": "", "itemId": "", "fromYyyymmdd": "20241109", "toYyyymmdd": "20271009"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plant_site_id": "", "p_item_id": "", "p_from_yyyymmdd": "20241109", "p_to_yyyymmdd": "20271009"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "81", "p_plant_site_id": "ALL", "p_item_id": "ALL", "p_from_yyyymmdd": "20241109", "p_to_yyyymmdd": "20271009"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
