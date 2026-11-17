# SCP0033 · SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY ↔ PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY

- 실행 2026-11-14 11:51:31 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 1행 전 컬럼 일치 · 단독행 AS-IS 0 / TO-BE 2 · 컬럼 집합 차이 AS-IS 전용 ['svalueyn'] / TO-BE 전용 ['svalidyn'] · 키 원천 cleanup_spec.json · 키 DIVISION_ID+ITEM_ID · golden 집합 판정 DIFF
- 호출 #5 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 58 · 원천 Doc\verify\SCP0033\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"p_division_id": "40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_ST,EE_UC", "p_item_id": "", "p_valid": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82,EE,EE_HD,EE_HG,EE_HM,EE_ST,EE_UC", "p_item_id": "", "p_valid": "N"}`

### 결과셋 1  As-is 1행 ↔ To-Be O_RC1 3행
- As-is 에만 있는 컬럼: S_VALUE_YN
- To-Be 에만 있는 컬럼: S_VALID_YN
- 행수 불일치 1 ↔ 3
- 값 차이: As-is 전용 0행 / To-Be 전용 2행 (공통 컬럼 10)
| 측 | DIVISION_ID | OPERATION_GROUP | ITEM_ID | NICK_NAME | DEPARTURE_DAY | VALID_YN | CREATED_BY | CREATION_DATE | LAST_UPDATED_BY | LAST_UPDATE_DATE |
|---|---|---|---|---|---|---|---|---|---|---|
| T | 40 | A | MCCM351015B1-D01 | M53L | WED | N |  |  |  |  |
| T | 40 | E | APCAN0842A | X732 | MON | N |  |  |  |  |
- 데이터 기준: 공통 1행 · AS-IS 전용 0행 · TO-BE 전용 2행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1행의 상대 순서): 비교 불가(공통 행 2 미만)

### 결과셋 2  As-is 54행 ↔ To-Be O_RC2 55행
- 행수 불일치 54 ↔ 55
- 값 차이: As-is 전용 0행 / To-Be 전용 1행 (공통 컬럼 2)
| 측 | DIVISION_ID | ITEM_ID |
|---|---|---|
| T | 40 | MCCM351015B1-D01 |
- 데이터 기준: 공통 54행 · AS-IS 전용 0행 · TO-BE 전용 1행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 54행의 상대 순서): 일치
