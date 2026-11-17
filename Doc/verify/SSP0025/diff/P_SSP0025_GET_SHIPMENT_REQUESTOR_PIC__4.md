# SSP0025 · SSP0025_GET_SHIPMENT_REQUESTOR_PIC ↔ PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC

- 실행 2026-11-15 05:04:51 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 103행 전 컬럼 일치 · 단독행 AS-IS 0 / TO-BE 1 · 키 원천 cleanup_spec.json · 키 DIVISION_ID+TO_SITE+ITEM_ID+USER_ID · golden 집합 판정 DIFF
- 호출 #4 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 105 · 원천 Doc\verify\SSP0025\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "plantSite": "", "itemId": "", "nickName": "", "modelId": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_plant_site": "", "p_item_id": "", "p_nick_name": "", "p_model_id": "", "p_language": "KO"}`
- TO-BE 인자 묶음(PROC_M 순서 = BE 방식): sesLangCd→P_LANGUAGE

### 결과셋 1  As-is 103행 ↔ To-Be O_RC1 104행
- 행수 불일치 103 ↔ 104
- 값 차이: As-is 전용 0행 / To-Be 전용 1행 (공통 컬럼 19)
| 측 | DIVISION_ID | TO_SITE | SITE_DESCRIPTION | ITEM_ID | ELECTRODE_TYPE | MODEL_ID | NICK_NAME | CELL_TYPE | USER_ID | VALID_YN | USER_NAME | PART_LEADER |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 40 | NJ01-A | LGESNJ Cell NJ01 | APCAN0114A | ANODE | MCP34A3A0A10 | 34103100L1 | Pouch | idzierzyk | Y | IZABELA DZIERŻYK | lvwenjun |
- 데이터 기준: 공통 103행 · AS-IS 전용 0행 · TO-BE 전용 1행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 103행의 상대 순서): 일치
