# SSP0024 · SSP0024_GET_SHIP_MASTER ↔ PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER

- 실행 2026-11-15 03:14:37 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 2행 중 불일치 셀 2 — diff/P_SSP0024_GET_SHIP_MASTER__12.csv · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+PLANT_SITE_CODE+PLANT_SITE_ID+MATERIAL_ID · golden 집합 판정 DIFF
- 호출 #12 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SSP0024\calls\_verify_조회조건_콤보_후보_품질_B1_B2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "plantSiteId": "MI00-E", "materialId": "", "nickName": "", "modelId": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plant_site_id": "MI00-E", "p_material_id": "", "p_nick_name": "", "p_model_id": ""}`

### 결과셋 1  As-is 2행 ↔ To-Be O_RC1 2행
- 값 차이: As-is 전용 2행 / To-Be 전용 2행 (공통 컬럼 25)
| 측 | DIVISION_ID | PLANT_SITE_CODE | PLANT_SITE_ID | MATERIAL_ID | MODEL_ID | CELL_TYPE | NICK_NAME | ELECTRODE_TYPE | ITEM_UOM | POST_OPER | POST_OPER_LT | UOM_CONVERT_IN_TACT_TIME |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 81 | MI00-E | MI00-E | APCAN1257B | ACPN1034U-A1-100 |  | P34-100 | ANODE | M | OP05 | 5 | 3.450001 |
| A | 81 | MI00-E | MI00-E | APCCA0978A | ACPN1034U-A1-100 |  | P34-100 | CATHODE | M | OP05 | 5 | 3.233996 |
| T | 81 | MI00-E | MI00-E | APCAN1257B | ACPN1034U-A1-100 |  | P34-100 | ANODE | M | OP05 | 5 | 3.450001 |
| T | 81 | MI00-E | MI00-E | APCCA0978A | ACPN1034U-A1-100 |  | P34-100 | CATHODE | M | OP05 | 5 | 3.233996 |
- 데이터 기준: 공통 0행 · AS-IS 전용 2행 · TO-BE 전용 2행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)

## 불일치 셀(≤50) — diff/P_SSP0024_GET_SHIP_MASTER__12.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 81|MI00-E|MI00-E|APCAN1257B | BUILDING | MI1_E | E9 |
| 81|MI00-E|MI00-E|APCCA0978A | BUILDING | MI1_E | E9 |
