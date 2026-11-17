# SSP0024 · SSP0024_GET_SHIP_MASTER ↔ PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER

- 실행 2026-11-15 03:14:37 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 4행 중 불일치 셀 2 — diff/P_SSP0024_GET_SHIP_MASTER__16.csv · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+PLANT_SITE_CODE+PLANT_SITE_ID+MATERIAL_ID · golden 집합 판정 DIFF
- 호출 #16 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 5 · 원천 Doc\verify\SSP0024\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "plantSiteId": "", "materialId": "APCAN0506B,APCAN0507B", "nickName": "", "modelId": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plant_site_id": "", "p_material_id": "APCAN0506B,APCAN0507B", "p_nick_name": "", "p_model_id": ""}`

### 결과셋 1  As-is 4행 ↔ To-Be O_RC1 4행
- 값 차이: As-is 전용 2행 / To-Be 전용 2행 (공통 컬럼 25)
| 측 | DIVISION_ID | PLANT_SITE_CODE | PLANT_SITE_ID | MATERIAL_ID | MODEL_ID | CELL_TYPE | NICK_NAME | ELECTRODE_TYPE | ITEM_UOM | POST_OPER | POST_OPER_LT | UOM_CONVERT_IN_TACT_TIME |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | NA00-E | NA00-E | APCAN0506B | ECE0630N1-02 | Pouch | JH3 | ANODE | M | OP05 | 5 | 4.74001 |
| A | 81 | NA00-E | NA00-E | APCAN0507B | ECP0640N5-02 | Pouch | JP3 | ANODE | M | OP05 | 5 | 5.024393 |
| T | 81 | NA00-E | NA00-E | APCAN0506B | ECE0630N1-02 | Pouch | JH3 | ANODE | M | OP05 | 5 | 4.74001 |
| T | 81 | NA00-E | NA00-E | APCAN0507B | ECP0640N5-02 | Pouch | JP3 | ANODE | M | OP05 | 5 | 5.024393 |
- 데이터 기준: 공통 2행 · AS-IS 전용 2행 · TO-BE 전용 2행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2행의 상대 순서): 일치

## 불일치 셀(≤50) — diff/P_SSP0024_GET_SHIP_MASTER__16.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 81|NA00-E|NA00-E|APCAN0506B | BUILDING | (N/A)Nanjing Automotive Bldg 1 | E8 |
| 81|NA00-E|NA00-E|APCAN0507B | BUILDING | (N/A)Nanjing Automotive Bldg 1 | E8 |
